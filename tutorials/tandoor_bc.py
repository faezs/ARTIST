"""
Behavior-clone the scripted heuristic into the LSTM policy, then verify.

Why: model-free PPO comprehensively failed the field-real env - the
winning sweep policy's GREEDY mode cooks zero rotis (all its sampled
score was entropy noise luckily closing the shutter). The shutter skill
is event-triggered (instant flux cost, ~200 s delayed threshold payoff),
trivially expressible as a rule but nearly invisible to policy-gradient
exploration. Classic fix: imitate the working controller, then let PPO
fine-tune gently from a competent init.

Usage: python tandoor_bc.py [--days 40] [--epochs 3]
Writes: puffer_tandoor/experiments/bc_<ts>.pt
"""

import argparse
import pathlib
import sys
import time

import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_rl_env import TandoorEnv  # noqa: E402
import pufferlib.models  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
DEV = "mps" if torch.backends.mps.is_available() else "cpu"


def heuristic_actions(env, B):
    belt = env.T[:, : env.n_belt]
    ready = (env.load_timer >= 45.0) & (
        ((~env.has_bread) & (belt >= 560.0) & (belt <= 700.0)).any(1))
    return np.stack([np.full(B, 4), np.where(ready, 0, 6)], axis=1)


def collect(days, B=256, seed=0):
    env = TandoorEnv(num_agents=B, seed=seed, wide_shutter=1, warm_frac=0.5)
    env.reset(seed=seed)
    T = 1922
    obs_buf = np.zeros((days, T, B, env.single_observation_space.shape[0]),
                       dtype=np.float32)
    act_buf = np.zeros((days, T, B, 2), dtype=np.int64)
    for d in range(days):
        obs = env._obs()
        for t in range(T):
            a = heuristic_actions(env, B)
            obs_buf[d, t] = obs
            act_buf[d, t] = a
            obs, *_ , infos = env.step(a)
        print(f"  collect day {d + 1}/{days}", flush=True)
    return obs_buf.reshape(days * T, B, -1), act_buf.reshape(days * T, B, 2)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--days", type=int, default=12)
    ap.add_argument("--epochs", type=int, default=4)
    ap.add_argument("--chunk", type=int, default=64)
    ap.add_argument("--dagger", type=int, default=2)
    args = ap.parse_args()

    print("[bc] collecting heuristic rollouts...", flush=True)
    obs, act = collect(args.days)
    S, B, D = obs.shape
    print(f"[bc] dataset: {S} steps x {B} envs", flush=True)
    extra_obs, extra_act = [], []

    env = TandoorEnv(num_agents=B, seed=1, wide_shutter=1)
    pol = pufferlib.models.Default(env, hidden_size=128)
    pol = pufferlib.models.LSTMWrapper(env, pol, input_size=128,
                                       hidden_size=128).to(DEV)
    opt = torch.optim.Adam(pol.parameters(), lr=1e-3)
    nvec = [7, 7]

    T_ep = 1922
    n_days = S // T_ep
    for ep in range(args.epochs):
        tot, nb = 0.0, 0
        for d in range(n_days):
            state = dict(lstm_h=torch.zeros(B, 128, device=DEV),
                         lstm_c=torch.zeros(B, 128, device=DEV))
            for c0 in range(0, T_ep, args.chunk):
                c1 = min(c0 + args.chunk, T_ep)
                loss = 0.0
                for t in range(c0, c1):
                    o = torch.as_tensor(obs[d * T_ep + t]).to(DEV)
                    a = torch.as_tensor(act[d * T_ep + t]).to(DEV)
                    logits, _ = pol.forward_eval(o, state)
                    # shutter-close is ~1-2% of steps: weight it or BC
                    # learns "always open" at low CE and never cooks
                    w_sh = torch.where(a[:, 1] <= 3, 40.0, 1.0)
                    loss = (loss
                            + torch.nn.functional.cross_entropy(
                                logits[0], a[:, 0])
                            + (torch.nn.functional.cross_entropy(
                                logits[1], a[:, 1], reduction="none")
                               * w_sh).mean())
                opt.zero_grad()
                (loss / (c1 - c0)).backward()
                torch.nn.utils.clip_grad_norm_(pol.parameters(), 1.0)
                opt.step()
                state = {k: v.detach() for k, v in state.items()}
                tot += float(loss) / (c1 - c0)
                nb += 1
        print(f"[bc] epoch {ep}: CE {tot / nb:.4f}", flush=True)

    # DAgger: roll out the CLONE, relabel with expert actions, retrain -
    # cures the compounding distribution shift plain BC suffers
    for round_ in range(args.dagger):
        print(f"[dagger {round_}] collecting clone rollouts...", flush=True)
        denv = TandoorEnv(num_agents=B, seed=100 + round_, wide_shutter=1,
                          warm_frac=0.5)
        denv.reset(seed=100 + round_)
        o = denv._obs()
        st = dict(lstm_h=torch.zeros(B, 128, device=DEV),
                  lstm_c=torch.zeros(B, 128, device=DEV))
        d_obs = np.zeros((1922, B, D), dtype=np.float32)
        d_act = np.zeros((1922, B, 2), dtype=np.int64)
        for t in range(1922):
            d_obs[t] = o
            d_act[t] = heuristic_actions(denv, B)  # expert label
            with torch.no_grad():
                logits, _ = pol.forward_eval(
                    torch.as_tensor(o).to(DEV), st)
                a = torch.stack([lg.argmax(-1) for lg in logits], 1)
            o, *_, _inf = denv.step(a.cpu().numpy().reshape(B, 2))
        obs = np.concatenate([obs, d_obs], axis=0)
        act = np.concatenate([act, d_act], axis=0)
        S = obs.shape[0]
        n_days = S // T_ep
        for ep in range(2):
            for d in range(n_days):
                state = dict(lstm_h=torch.zeros(B, 128, device=DEV),
                             lstm_c=torch.zeros(B, 128, device=DEV))
                for c0 in range(0, T_ep, args.chunk):
                    c1 = min(c0 + args.chunk, T_ep)
                    loss = 0.0
                    for t in range(c0, c1):
                        o2 = torch.as_tensor(obs[d * T_ep + t]).to(DEV)
                        a2 = torch.as_tensor(act[d * T_ep + t]).to(DEV)
                        logits, _ = pol.forward_eval(o2, state)
                        w_sh = torch.where(a2[:, 1] <= 3, 40.0, 1.0)
                        loss = (loss
                                + torch.nn.functional.cross_entropy(
                                    logits[0], a2[:, 0])
                                + (torch.nn.functional.cross_entropy(
                                    logits[1], a2[:, 1], reduction="none")
                                   * w_sh).mean())
                    opt.zero_grad()
                    (loss / (c1 - c0)).backward()
                    torch.nn.utils.clip_grad_norm_(pol.parameters(), 1.0)
                    opt.step()
                    state = {k: v.detach() for k, v in state.items()}
        print(f"[dagger {round_}] retrained on {n_days} days", flush=True)

    ck = HERE / "puffer_tandoor" / "experiments" / f"bc_{int(time.time())}.pt"
    torch.save(pol.state_dict(), ck)
    print(f"[bc] saved {ck}", flush=True)

    # greedy verification vs the heuristic
    pol = pol.cpu().eval()
    env = TandoorEnv(num_agents=32, seed=11, device=None, wide_shutter=1)
    for mode, t0 in (("cold", 350.0), ("warm", 580.0)):
        env.reset(seed=11)
        env.T[:] = t0 + env.rng.uniform(-15, 15, env.T.shape)
        env._belt_prev = env.T[:, :8].mean(1).copy()
        o = env._obs()
        st = dict(lstm_h=torch.zeros(32, 128), lstm_c=torch.zeros(32, 128))
        rotis = []
        for _ in range(1922):
            with torch.no_grad():
                logits, _ = pol.forward_eval(torch.as_tensor(o), st)
                a = torch.stack([lg.argmax(-1) for lg in logits], 1)
            o, *_, infos = env.step(a.numpy().reshape(32, 2))
            for inf in infos:
                rotis.append(inf["rotis_per_day"])
        print(f"[bc] greedy {mode}: {np.mean(rotis):.1f} rotis/day",
              flush=True)


if __name__ == "__main__":
    main()

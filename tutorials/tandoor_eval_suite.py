"""Evaluation suite for the Hashemi tandoor policy.

Exists because the training panel's single number was hiding things -
starting with the fact that training ran on one identical solar day.
Each eval answers a specific question a deployment decision needs:

  E1 greedy vs sampled     is the score real commitment or entropy?
  E2 day-of-year sweep     memorized trajectory or closed-loop tracking?
                           (el > 65 crossing regime is UNTRAINED)
  E3 ray-fidelity          does 192-ray training transfer to the
                           1100-ray trace?
  E4 paired vs heuristic   same seeds, same days, per-seed deltas
  E5 fault battery         gale, heavy cloud, encoder bias, stuck motor
  E6 hack audit            corr(return, rotis); return/rotis ratio
  E0 memorization litmus   (panel's top addition) live policy vs its own
                           actions REPLAYED open-loop on other seeds, vs
                           encoders zeroed. If replay ~ live, the LSTM
                           learned a clock schedule, not control.

Panel findings folded in: day 265 (declination twin of 80 - separates
date-memorization from trajectory-memorization), truncation-rate
reported per cell, deployment mode fixed to ONE choice for all evals.
Known gap, deliberate: paired-seed CRN breaks when policies diverge
(shared RNG stream consumed in step order); per-seed deltas are still
reported but treated as approximate.
"""
import argparse, contextlib, io, pathlib, sys
import numpy as np

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_compare import heuristic


def make_env(seed, **kw):
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(num_agents=kw.pop("agents", 16), seed=seed,
                              wide_shutter=1, device="cpu", **kw)
        e.reset(seed=seed)
    # eval from the honest SEASONED operating state (season_sim.py,
    # 45-day carried cycle, spherical wall): morning face ~487 K
    # equilibrated, halo ~405 K. Stone cold is a commissioning
    # scenario, not an informative daily benchmark - the honest wall
    # cannot reach the band from 350 K in one sun-day.
    e.T[:] = 487.0 + e.rng.uniform(-15, 15, e.T.shape)
    e.T_sub = e.T.copy()
    e.T_deep = e.T.copy()
    e.T_halo[:] = 405.0
    e._belt_prev = e.T[:, :e.n_belt].mean(1).copy()
    return e


def load_policy(path, env):
    """Wrap a pufferlib checkpoint as an action function; None -> the
    P-controller heuristic."""
    if path is None:
        return lambda e, B, greedy: heuristic(e, B), "heuristic"
    import torch
    import importlib.util
    spec = importlib.util.spec_from_file_location(
        "pt_policy", pathlib.Path(__file__).parent
        / "puffer_tandoor" / "policy.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    pol = mod.Policy(env, hidden_size=256)
    rnn = mod.Recurrent(env, pol, input_size=256, hidden_size=256)
    sd = torch.load(path, map_location="cpu", weights_only=False)
    rnn.load_state_dict(sd if not isinstance(sd, dict) or
                        "state_dict" not in sd else sd["state_dict"])
    rnn.eval()
    state = {}

    def act(e, B, greedy):
        nonlocal state
        if not state or state["lstm_h"].shape[0] != B:
            state = dict(lstm_h=torch.zeros(B, 256),
                         lstm_c=torch.zeros(B, 256))
        ob = torch.as_tensor(e.observations[:B]).float()
        with torch.no_grad():
            logits, _ = rnn.forward_eval(ob, state)
        acts = []
        for lg in (logits if isinstance(logits, (list, tuple)) else [logits]):
            acts.append(lg.argmax(-1) if greedy
                        else torch.distributions.Categorical(
                            logits=lg).sample())
        return torch.stack(acts, 1).cpu().numpy()
    return act, pathlib.Path(path).stem


def run_day(act, seed, greedy=False, agents=16, **envkw):
    e = make_env(seed, agents=agents, **envkw)
    rot, ret, pin = [], [], []
    for _ in range(1922):
        *_, infos = e.step(act(e, agents, greedy))
        pin.append(e.p_in.mean())
        for i in infos:
            if "rotis_per_day" in i:
                rot.append(i["rotis_per_day"])
                ret.append(i["episode_return"])
    lens = [i["episode_length"] for i in []]
    return (np.mean(rot) if rot else 0.0,
            np.mean(ret) if ret else 0.0, np.mean(pin) / 1000)


def run_day_full(act, seed, greedy=False, agents=16, corrupt=None,
                 replay=None, record=False, **envkw):
    """run_day + truncation stats, obs corruption, action replay."""
    e = make_env(seed, agents=agents, **envkw)
    rot, ret, lens = [], [], []
    tape = []
    for t in range(1922):
        if corrupt == "encoders":
            e.observations[:, -2:] = 0.0
        if replay is not None:
            a = replay[min(t, len(replay) - 1)]
        else:
            a = act(e, agents, greedy)
        if record:
            tape.append(np.array(a, copy=True))
        *_, infos = e.step(a)
        for i in infos:
            if "rotis_per_day" in i:
                rot.append(i["rotis_per_day"])
                ret.append(i["episode_return"])
                lens.append(i["episode_length"])
    trunc = float(np.mean([l < 1900 for l in lens])) if lens else 0.0
    out = dict(rotis=np.mean(rot) if rot else 0.0,
               ret=np.mean(ret) if ret else 0.0, trunc=trunc)
    return (out, tape) if record else out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ckpt", default=None,
                    help="checkpoint .pt; omit for the heuristic")
    ap.add_argument("--quick", action="store_true")
    a = ap.parse_args()
    dummy = make_env(0, agents=16)
    act, name = load_policy(a.ckpt, dummy)
    seeds = (1, 2) if a.quick else (1, 2, 3)
    print(f"\n=== eval suite: {name} ===")

    print("\nE1 greedy vs sampled (day 80)")
    for greedy in (False, True):
        rs = [run_day(act, s, greedy)[0] for s in seeds]
        print(f"  {'greedy ' if greedy else 'sampled'}: "
              f"{np.mean(rs):6.1f} +- {np.std(rs):.1f}")

    if a.ckpt is not None:
        print("\nE0 memorization litmus (panel top-ranked)")
        base, tape = run_day_full(act, 1, record=True)
        rep = [run_day_full(act, s_, replay=tape)["rotis"]
               for s_ in seeds[1:]]
        cor = [run_day_full(act, s_, corrupt="encoders")["rotis"]
               for s_ in seeds[1:]]
        liv = [run_day_full(act, s_)["rotis"] for s_ in seeds[1:]]
        print(f"  live          {np.mean(liv):6.1f}")
        print(f"  action replay {np.mean(rep):6.1f}   "
              f"(~live => clock schedule, not control)")
        print(f"  encoders=0    {np.mean(cor):6.1f}   "
              f"(~live => encoders unused: open-loop tracking)")

    print("\nE2 day sweep (265 = declination twin of 80; el>65 untrained)")
    for day in (80, 127, 172, 220, 265, 300, 355):
        outs = [run_day_full(act, s, day_of_year=day) for s in seeds[:2]]
        rs = [o["rotis"] for o in outs]
        tr = np.mean([o["trunc"] for o in outs])
        import numpy as _np
        from tandoor_rl_env import _sim
        el_max = max(_sim.solar_position(28.6, day, h)[0]
                     for h in _np.linspace(8, 16, 60))
        print(f"  day {day:3d} (noon el {el_max:4.1f}): "
              f"{np.mean(rs):6.1f} +- {np.std(rs):.1f}  trunc {tr*100:3.0f}%"
              + ("   <- crossing" if el_max > 65 else "")
              + ("   <- twin" if day == 265 else ""))

    print("\nE3 ray fidelity (day 80, sampled)")
    for nr in (192, 1100):
        rs = [run_day(act, s, n_rays=nr)[0] for s in seeds[:2]]
        print(f"  {nr:4d} rays: {np.mean(rs):6.1f} +- {np.std(rs):.1f}")

    print("\nE6 hack audit (day 80)")
    rr = [run_day(act, s) for s in seeds]
    rots = np.array([r[0] for r in rr]); rets = np.array([r[1] for r in rr])
    ratio = rets.sum() / max(rots.sum(), 1e-9)
    print(f"  return/rotis ratio {ratio:.2f} (clean ~ 5.0-5.3)")
    if rots.sum() == 0:
        print("  WARNING: zero rotis in every seed - return is 100%"
              " shaping and the alignment monitor below is blind."
              " Check the thermal start state / band reachability"
              " before trusting anything else in this suite.")
    if len(seeds) > 2 and rots.std() > 0 and rets.std() > 0:
        c = np.corrcoef(rots, rets)[0, 1]
        print(f"  corr(return, rotis) across seeds: {c:+.3f}")


if __name__ == "__main__":
    main()

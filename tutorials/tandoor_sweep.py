"""
Hyperparameter sweep for the field-real tandoor env.

pufferlib 3.0's `puffer sweep` requires a wandb/neptune account, so this
drives the same CLI trainer directly: random search over the knobs that
matter for the cold-start problem, each trial scored where it counts -
full eval days at forced-cold and forced-warm starts - then a long final
run with the winning config.

Usage: python tandoor_sweep.py [--trials 6] [--trial-steps 3500000]
                               [--final-steps 24000000]
"""

import argparse
import json
import pathlib
import subprocess
import sys
import time

import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
HERE = pathlib.Path(__file__).resolve().parent
PKG = HERE / "puffer_tandoor"
PY = PKG / ".venv" / "bin" / "python"


def newest_ckpt():
    cks = sorted((PKG / "experiments").glob("*.pt"),
                 key=lambda p: p.stat().st_mtime)
    return cks[-1] if cks else None


def score_checkpoint(ck, warm_frac):
    """Cold-day and warm-day rotis for a checkpoint (cpu, 32 tandoors)."""
    from tandoor_rl_env import TandoorEnv
    import pufferlib.models, pufferlib.pytorch
    sd = torch.load(ck, map_location="cpu")
    sd = {k.replace("module.", ""): v for k, v in sd.items()}
    if any(torch.isnan(v).any() for v in sd.values() if torch.is_tensor(v)):
        return dict(cold=-1.0, warm=-1.0, nan=True)
    env = TandoorEnv(num_agents=32, seed=11, device=None, wide_shutter=1,
                     warm_frac=warm_frac)
    pol = pufferlib.models.Default(env, hidden_size=128)
    pol = pufferlib.models.LSTMWrapper(env, pol, input_size=128,
                                       hidden_size=128)
    pol.load_state_dict(sd)
    out = {}
    for mode, t0 in (("cold", 350.0), ("warm", 580.0)):
        env.reset(seed=11)
        env.T[:] = t0 + env.rng.uniform(-15, 15, env.T.shape)
        env._belt_prev = env.T[:, :8].mean(1).copy()
        obs = env._obs()
        state = dict(lstm_h=torch.zeros(32, 128),
                     lstm_c=torch.zeros(32, 128))
        rotis = []
        for _ in range(1922):
            with torch.no_grad():
                logits, _ = pol.forward_eval(torch.as_tensor(obs), state)
                a, _, _ = pufferlib.pytorch.sample_logits(logits)
            obs, *_, infos = env.step(a.numpy().reshape(32, 2))
            for inf in infos:
                rotis.append(inf["rotis_per_day"])
        out[mode] = float(np.mean(rotis)) if rotis else 0.0
    out["nan"] = False
    return out


def run_trial(overrides, steps, log_path):
    cmd = [str(PKG / "run.sh"), "train",
           "--train.total-timesteps", str(steps)]
    for k, v in overrides.items():
        cmd += [f"--{k}", str(v)]
    with open(log_path, "w") as f:
        subprocess.run(cmd, stdout=f, stderr=subprocess.STDOUT,
                       cwd=PKG, check=False)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--trials", type=int, default=8)
    ap.add_argument("--trial-steps", type=int, default=3_500_000)
    ap.add_argument("--final-steps", type=int, default=24_000_000)
    ap.add_argument("--out", default="sweep_results.jsonl")
    args = ap.parse_args()
    rng = np.random.default_rng(0)

    def sample_config():
        # optimizer is a dimension: pufferlib's stack is tuned around muon
        # (Shampoo-family) at lr ~1e-2; adam wants ~1e-3. Ranges mirror
        # their default.ini [sweep.*] sections where applicable.
        opt = str(rng.choice(["muon", "adam"], p=[0.6, 0.4]))
        lr = float(10 ** rng.uniform(-2.1, -1.3) if opt == "muon"
                   else 10 ** rng.uniform(-3.3, -2.4))
        return {
            "train.optimizer": opt,
            "train.learning-rate": lr,
            "train.ent-coef": float(10 ** rng.uniform(-3.0, -1.2)),
            "train.gamma": float(rng.choice([0.999, 0.9995, 0.9997])),
            "train.gae-lambda": float(rng.choice([0.90, 0.95])),
            "train.vf-coef": float(rng.choice([1.0, 2.0])),
            "train.clip-coef": float(rng.uniform(0.1, 0.3)),
            "train.prio-alpha": float(rng.uniform(0.5, 1.0)),
            "env.warm-frac": float(rng.choice([0.3, 0.5, 0.7])),
        }

    done = {}
    out_path = HERE / args.out
    if out_path.exists():
        for line in open(out_path):
            r = json.loads(line)
            if r.get("trial") != "final" and not r.get("nan"):
                done[r["trial"]] = r
    results = []
    for i in range(args.trials):
        cfg = sample_config()  # rng advances identically for resume
        if i in done:
            print(f"[trial {i}] resumed from log: "
                  f"score={done[i]['score']:.1f}", flush=True)
            results.append(done[i])
            continue
        t0 = time.time()
        print(f"[trial {i}] {cfg}", flush=True)
        run_trial(cfg, args.trial_steps, HERE / f"sweep_trial_{i}.log")
        ck = newest_ckpt()
        sc = score_checkpoint(ck, cfg["env.warm-frac"]) if ck else \
            dict(cold=-1, warm=-1, nan=True)
        sc["score"] = sc["cold"] + 0.4 * sc["warm"]
        rec = dict(trial=i, cfg=cfg, ckpt=str(ck), minutes=(
            time.time() - t0) / 60, **sc)
        results.append(rec)
        with open(HERE / args.out, "a") as f:
            f.write(json.dumps(rec) + "\n")
        print(f"[trial {i}] cold={sc['cold']:.1f} warm={sc['warm']:.1f} "
              f"score={sc['score']:.1f} ({rec['minutes']:.0f} min)",
              flush=True)

    best = max(results, key=lambda r: r["score"])
    print(f"[sweep] best trial {best['trial']}: {best['cfg']} "
          f"score={best['score']:.1f}", flush=True)
    print("[final] launching long run with best config...", flush=True)
    run_trial(best["cfg"], args.final_steps, HERE / "sweep_final.log")
    ck = newest_ckpt()
    sc = score_checkpoint(ck, best["cfg"]["env.warm-frac"])
    rec = dict(trial="final", cfg=best["cfg"], ckpt=str(ck), **sc,
               score=sc["cold"] + 0.4 * sc["warm"])
    with open(HERE / args.out, "a") as f:
        f.write(json.dumps(rec) + "\n")
    print(f"[final] cold={sc['cold']:.1f} warm={sc['warm']:.1f} "
          f"ckpt={ck}", flush=True)


if __name__ == "__main__":
    main()

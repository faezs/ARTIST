"""Local (MPS) sweep runner - the modal_sweep.run_sweep loop without
the cloud. Same guardrails: DERIVED architecture tie, honest params
print, crash guard observing score 0, LOGDIAG.

Local adaptations, deliberate:
  - metric rotis_per_day (day-over infos are free; the hourly metric's
    sync costs ~2/3 of local MPS SPS)
  - probe budget 1e8-5e8 mean 2e8 (local minutes are the scarce
    currency; the climb-rate signal is visible by 100M at tame lr)
  - env/train exactly as hashemi.ini (8192 agents, cold mornings,
    update_epochs default) - the sweep ranks the recipe we deploy

    ./.venv/bin/python local_sweep.py                # 20 runs
    ./.venv/bin/python local_sweep.py --smoke        # one 25M probe
"""
import argparse
import copy
import os
import pathlib
import random
import sys
import time

PKG = str(pathlib.Path(__file__).resolve().parent)
os.chdir(PKG)
sys.path.insert(0, PKG)
sys.path.insert(0, str(pathlib.Path(PKG).parent))          # tutorials
sys.path.insert(0, str(pathlib.Path(PKG).parent.parent))   # ARTIST


def main(max_runs=20, smoke=False):
    import inspect

    import numpy as np
    import torch

    import pufferlib.sweep as _pls
    assert "zero-width space = pinned" in inspect.getsource(
        _pls._params_from_puffer_sweep), \
        "pinned-space patch missing - run apply_pufferlib_patches.py"

    import pufferlib.sweep
    from pufferlib.pufferl import (train, load_config, downsample,
                                   load_env, load_policy)

    # load_config parses sys.argv itself and rejects our CLI flags
    # (--smoke / --max-runs); strip them now that we've consumed them
    sys.argv = sys.argv[:1]
    args = load_config("puffer_hashemi")
    args["train"]["device"] = "mps"
    args["env"]["device"] = "mps"
    args["wandb"] = False
    args["neptune"] = False

    # rotis_per_hour, not per_day: cold bootstrap keeps episodes short
    # (guillotine) until tracking is learned, so the day-over-only
    # per_day metric reads ~0 for a long time and can't rank probes.
    # per_hour catches fragment cooking. (hourly .mean() sync costs
    # some SPS - acceptable for ranking density; Modal used this too.)
    # COLD ranking metric (user directive: no warm probes): at
    # 1e8-5e8 cold steps no config reaches first cooks, so
    # rotis-based metrics read 0 for everyone. episode_length
    # (45 = guillotine churn -> 1750 = tracking mastered) is the
    # discriminative bootstrap signal, and cooking is gated on it.
    # Winners get long rotis-scored runs afterwards.
    args["sweep"]["metric"] = "episode_length"
    args["env"]["hourly_metric"] = 0
    # COLD probes (user directive: no warm probes) - the ini's
    # warm_frac 0.0 stands. Scores will be sparse early; the
    # rotis_per_hour metric at least sees fragment cooking.
    # local probe budget (the ini's prior is Modal-scale)
    args["sweep"]["train"]["total_timesteps"] = dict(
        distribution="log_normal", min=1.5e8, max=6e8, mean=3e8,
        scale="time")
    if smoke:
        args["sweep"]["train"]["total_timesteps"] = dict(
            distribution="log_normal", min=2.4e7, max=2.6e7,
            mean=2.5e7, scale="time")

    method = args["sweep"].pop("method")
    sweep = getattr(pufferlib.sweep, method)(args["sweep"])
    points_per_run = args["sweep"]["downsample"]
    target_key = f'environment/{args["sweep"]["metric"]}'

    print("BAKED ini [policy]:", args.get("policy"),
          "[rnn]:", args.get("rnn"), flush=True)
    print(f"BAKED env: agents={args['env']['num_agents']} "
          f"warm={args['env']['warm_frac']} "
          f"sticky={args['env'].get('sticky_k')} "
          f"opt={args['train']['optimizer']}", flush=True)

    n_runs = 1 if smoke else max_runs
    for i in range(n_runs):
        seed = time.time_ns() & 0xFFFFFFFF
        random.seed(seed)
        np.random.seed(seed)
        torch.manual_seed(seed)
        sweep.suggest(args)
        DERIVED = (("rnn", "input_size", "policy", "hidden_size"),
                   ("rnn", "hidden_size", "policy", "hidden_size"))
        for ds, dk, ss, sk in DERIVED:
            args[ds][dk] = args[ss][sk]
        _t = args["train"]
        import contextlib as _ctx
        import io as _io
        with _ctx.redirect_stdout(_io.StringIO()):
            vecenv_run = load_env("puffer_hashemi", args)
            pol_run = load_policy(args, vecenv_run)
        n_par = sum(p.numel() for p in pol_run.parameters()
                    if p.requires_grad)
        print(f"SWEEP RUN {i}: hidden={args['policy']['hidden_size']} "
              f"params={n_par/1e3:.1f}K "
              f"lr={_t['learning_rate']:.4g} "
              f"gamma={_t['gamma']:.5g} lam={_t['gae_lambda']:.4g} "
              f"ent={_t['ent_coef']:.4g} bptt={_t['bptt_horizon']} "
              f"sticky={args['env'].get('sticky_k')} "
              f"clip={_t['clip_coef']:.3g} "
              f"prio_a={_t['prio_alpha']:.2g} "
              f"steps={_t['total_timesteps']:.3g}", flush=True)
        total_timesteps = args["train"]["total_timesteps"]
        t_run = time.time()
        try:
            all_logs = train("puffer_hashemi", args=args,
                             vecenv=vecenv_run, policy=pol_run)
        except Exception as ex:
            import traceback
            traceback.print_exc()
            print(f"SWEEP RUN {i} CRASHED ({type(ex).__name__}) - "
                  f"observed as score 0", flush=True)
            if hasattr(torch, "mps"):
                torch.mps.empty_cache()
            sweep.observe(args, 0.0, time.time() - t_run)
            args["train"]["total_timesteps"] = total_timesteps
            continue
        n_raw = len(all_logs)
        _keys = sorted(k for k in (all_logs[-1] if all_logs else {})
                       if "environ" in k)
        all_logs = [e for e in all_logs if target_key in e]
        _series = [round(float(lg[target_key]), 2)
                   for lg in all_logs][:12]
        print(f"SWEEP RUN {i} LOGDIAG: raw={n_raw} "
              f"with_key={len(all_logs)} env_keys={_keys[:6]} "
              f"head={_series}", flush=True)
        scores = downsample([lg[target_key] for lg in all_logs],
                            points_per_run)
        costs = downsample([lg["uptime"] for lg in all_logs],
                           points_per_run)
        steps = downsample([lg["agent_steps"] for lg in all_logs],
                           points_per_run)
        for score, cost, ts in zip(scores, costs, steps):
            args["train"]["total_timesteps"] = ts
            sweep.observe(args, score, cost)
        args["train"]["total_timesteps"] = total_timesteps
        n_sc = len(scores)
        last_s = float(scores[-1]) if n_sc else 0.0
        best_s = float(np.max(scores)) if n_sc else 0.0
        print(f"SWEEP RUN {i} SCORE: last {last_s:.1f} "
              f"best {best_s:.1f} ep_len "
              f"({(time.time() - t_run)/60:.1f} min)", flush=True)


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--max-runs", type=int, default=20)
    p.add_argument("--smoke", action="store_true")
    a = p.parse_args()
    main(max_runs=a.max_runs, smoke=a.smoke)

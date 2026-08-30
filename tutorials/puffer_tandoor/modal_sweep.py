"""Run the puffer_hashemi hyperparameter sweep on Modal (CUDA),
SEEDED with every completed probe from the local Mac sweep.

The stack is CUDA-clean by construction: the Metal megakernel and the
Metal advantage kernel gate on device.type == "mps" and fall back to
the fused torch graph / pufferlib's native CUDA advantage. The local
pufferlib patches are applied at runtime by apply_pufferlib_patches.py.

Seeding: sweep_seeds.json (built from the Mac sweep logs) holds one
observation per completed probe - the 8 swept dims, the 30-log tail
mean of rotis_per_day, and the estimated wall cost. Protein's GP
starts warm instead of resampling the search center. The two dims the
logs never recorded (prio_alpha/prio_beta0) are pinned in hashemi.ini
so historical vectors are complete.

Usage:
    .venv/bin/modal run modal_sweep.py --smoke        # ~5 min, cents
    .venv/bin/modal run --detach modal_sweep.py --max-runs 40
    .venv/bin/modal app logs puffer-tandoor-sweep     # follow output
"""
import modal

REPO = "/root/ARTIST"

image = (
    modal.Image.debian_slim(python_version="3.11")
    .pip_install(
        "torch==2.13.0",
        "numpy",
        "gymnasium==0.29.1",
        "pufferlib==3.0.0",
        "pyro-ppl",
        "heavyball",
        "psutil",
        "matplotlib",
        "colorlog",
        "h5py",
        "scipy",
        "rich",
    )
    .add_local_file(
        "/Users/faezs/ARTIST/tutorials/puffer_tandoor/"
        "apply_pufferlib_patches.py",
        "/root/apply_pufferlib_patches.py", copy=True)
    .run_commands(
        # patch pufferlib AT BUILD TIME - deterministic, no runtime
        # ordering or bytecode-cache questions - and purge stale pyc
        "python /root/apply_pufferlib_patches.py",
        "find /usr/local/lib/python3.11/site-packages/pufferlib "
        "-name __pycache__ -type d -exec rm -rf {} + || true",
    )
    .add_local_dir(
        "/Users/faezs/ARTIST/artist", f"{REPO}/artist", copy=True)
    .add_local_dir(
        "/Users/faezs/ARTIST/tutorials", f"{REPO}/tutorials", copy=True,
        ignore=["**/.venv/**", "**/experiments/**",
                "**/__pycache__/**", "**/*.log", "**/wandb/**",
                "**/.venv", "**/experiments"])
)

app = modal.App("puffer-tandoor-sweep", image=image)


@app.function(gpu="A100", timeout=60 * 60 * 12,
              memory=32768, cpu=8)
def run_sweep(max_runs: int = 40, smoke: bool = False):
    import copy as _copy
    import json
    import os
    import random
    import subprocess
    import sys
    import time

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)

    import pufferlib as _plv
    _sw = os.path.join(os.path.dirname(_plv.__file__), "sweep.py")
    assert "zero-width space = pinned" in open(_sw).read(), \
        "pinned-space patch NOT in installed sweep.py"
    import pufferlib.sweep as _pls
    import inspect
    assert "zero-width space = pinned" in inspect.getsource(
        _pls._params_from_puffer_sweep), \
        "imported sweep module does not carry the patch (stale pyc?)"
    print("build-time patches verified in file AND imported module",
          flush=True)

    # HARD GATE: the CUDA trace must reproduce the Metal kernel's
    # output on the frozen reference bundle before any paid probe
    r = subprocess.run(
        [sys.executable, f"{REPO}/tutorials/tandoor_cuda_verify.py",
         "check"], capture_output=True, text=True)
    print(r.stdout[-500:], flush=True)
    assert r.returncode == 0, \
        f"CUDA-vs-Metal gate FAILED: {r.stderr[-800:]}"


    # register the tandoor package the way the local venv does: the
    # ini into pufferlib's config dir, the package into its
    # environments namespace (load_config/load_env look ONLY there)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    os.symlink(f"{pkg}/hashemi.ini",
               os.path.join(_pl_dir, "config", "hashemi.ini"))
    os.symlink(pkg, os.path.join(_pl_dir, "environments", "tandoor"))

    import numpy as np
    import torch
    assert torch.cuda.is_available(), "no CUDA in container"
    print("GPU:", torch.cuda.get_device_name(0))

    import pufferlib.sweep
    from pufferlib.pufferl import train, load_config, downsample

    args = load_config("puffer_hashemi")
    args["train"]["device"] = "cuda"
    args["env"]["device"] = "cuda"
    args["wandb"] = False
    args["neptune"] = False
    if smoke:
        args["sweep"]["train"]["total_timesteps"] = dict(
            distribution="log_normal", min=2.4e7, max=2.6e7,
            mean=2.5e7, scale="time")

    method = args["sweep"].pop("method")
    sweep = getattr(pufferlib.sweep, method)(args["sweep"])
    points_per_run = args["sweep"]["downsample"]
    target_key = f'environment/{args["sweep"]["metric"]}'

    # ---- seed the GP with everything the Mac sweep already learned
    with open("sweep_seeds.json") as f:
        seeds = json.load(f)
    for s_ in seeds:
        hist = _copy.deepcopy(args)
        t = hist["train"]
        t["learning_rate"] = s_["lr"]
        t["gamma"] = s_["gamma"]
        t["gae_lambda"] = s_["lam"]
        t["ent_coef"] = s_["ent"]
        t["bptt_horizon"] = s_["bptt"]
        t["minibatch_size"] = s_["mb"]
        t["total_timesteps"] = s_["steps"]
        t["vf_coef"] = s_["vf"]
        sweep.observe(hist, s_["score"], s_["cost"])
    print(f"seeded {len(seeds)} historical observations "
          f"(best {max(x['score'] for x in seeds):.1f})")

    # ---- the sweep loop (pufferl.sweep, replicated so seeding works)
    n_runs = 1 if smoke else max_runs
    for i in range(n_runs):
        seed = time.time_ns() & 0xFFFFFFFF
        random.seed(seed)
        np.random.seed(seed)
        torch.manual_seed(seed)
        sweep.suggest(args)
        _t = args["train"]
        print(f"SWEEP RUN {i}: lr={_t['learning_rate']:.4g} "
              f"gamma={_t['gamma']:.5g} lam={_t['gae_lambda']:.4g} "
              f"ent={_t['ent_coef']:.4g} bptt={_t['bptt_horizon']} "
              f"mb={_t['minibatch_size']} "
              f"steps={_t['total_timesteps']:.3g} "
              f"vf={_t['vf_coef']:.3g} "
              f"gn={_t['max_grad_norm']:.3g}", flush=True)
        total_timesteps = args["train"]["total_timesteps"]
        all_logs = train("puffer_hashemi", args=args)
        all_logs = [e for e in all_logs if target_key in e]
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


@app.local_entrypoint()
def main(smoke: bool = False, max_runs: int = 40):
    run_sweep.remote(max_runs=max_runs, smoke=smoke)

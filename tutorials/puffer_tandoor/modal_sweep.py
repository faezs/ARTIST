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
        "cupy-cuda12x",
        "nvidia-cuda-nvrtc-cu12",
        "nvidia-cuda-runtime-cu12",
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


@app.function(gpu="L4", timeout=60 * 60 * 12,
              memory=32768, cpu=8)
def run_sweep(max_runs: int = 40, smoke: bool = False,
              seed_history: bool = False):
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
        [sys.executable, f"{REPO}/tutorials/tandoor_step_verify.py",
         "check"], capture_output=True, text=True)
    print(r.stdout[-500:], flush=True)
    assert r.returncode == 0, \
        f"CUDA-vs-MPS step gate FAILED: {r.stderr[-800:]}"


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
    from pufferlib.pufferl import (train, load_config, downsample,
                                   load_env, load_policy)

    args = load_config("puffer_hashemi")
    print("BAKED ini [policy]:", args.get("policy"),
          "[rnn]:", args.get("rnn"), flush=True)
    print("BAKED sweep hidden dim:",
          args["sweep"].get("policy", "MISSING"), flush=True)
    # baked-CODE check (the config prints above proved current while
    # the env layer ran STALE - ep_len 45 under a 480-step cut):
    # read the guillotine line from the container's own files
    import tandoor_gpu_step as _tg
    print("BAKED guillotine:", [ln.strip() for ln in
          open(_tg.__file__) if "lost_ct >=" in ln], flush=True)
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

    # env scale: the L4-measured operating point (472K SPS end-to-end)
    args["env"]["num_agents"] = 32768
    # warm_frac NOT overridden (user call): the sweep runs the ini's
    # env verbatim. Pre-sticky, cold probes were 40x zero (17
    # measured); with the engagement latch, cold bootstrap reaches
    # ~40 rotis/day by 100M steps locally, so cold probes now
    # differentiate within sweep budgets - and the sweep ranks the
    # env we actually deploy.
    # hourly scoring density (env-side sync; too costly for local
    # MPS runs, fine at sweep scale)
    args["env"]["hourly_metric"] = 1
    # 32768 agents = 4x fewer optimizer updates per step than the
    # proven 8192-agent recipe; update_epochs 4 restores the update
    # cadence while keeping the big batch's collect throughput
    # (user call: more trains, not smaller batches)
    args["train"]["update_epochs"] = 4

    # ---- seed the GP with the Mac sweep's history - OFF by default
    # now: those scores were measured on the OLD physics (gated cook,
    # doughy timeout, 700 K char, max-bin shaping) and would teach
    # the GP a landscape that no longer exists
    seeds = []
    if seed_history:
        with open("sweep_seeds.json") as f:
            seeds = json.load(f)
    else:
        print("history seeding OFF: old-physics scores would mislead "
              "the GP on the new machine", flush=True)
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
    if seeds:
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
        # TIED dims (the ini sketch's 'distribution =
        # sweep.policy.hidden_size', made real): the GP samples ONE
        # architecture width; the LSTM's input and hidden follow by
        # rule, because the matmuls demand it - encoder out feeds
        # LSTM in, LSTM out feeds the decoder. Derived dims are NOT
        # swept dims, so the GP's space stays clean.
        DERIVED = (("rnn", "input_size", "policy", "hidden_size"),
                   ("rnn", "hidden_size", "policy", "hidden_size"))
        for ds, dk, ss, sk in DERIVED:
            args[ds][dk] = args[ss][sk]
        _t = args["train"]
        # build the net OURSELVES and pass it in, so the sweep can
        # never silently train a different architecture than it
        # reports (the first sweep's runs showed Params 5.0K on the
        # dashboard while claiming hidden=256)
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
              f"mb={_t['minibatch_size']} "
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
            # a dead probe (OOM at a big width x bptt corner, or any
            # crash) must not kill the sweep: score it 0 at its true
            # cost and let the GP learn to avoid the corner
            import traceback
            traceback.print_exc()
            print(f"SWEEP RUN {i} CRASHED ({type(ex).__name__}) - "
                  f"observed as score 0", flush=True)
            torch.cuda.empty_cache()
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
        # downsample returns numpy arrays: len(), never truthiness
        # (the `if scores` form killed the app AFTER probe 0's full
        # 1e9 steps - the most expensive ValueError of the night)
        n_sc = len(scores)
        last_s = float(scores[-1]) if n_sc else 0.0
        best_s = float(np.max(scores)) if n_sc else 0.0
        print(f"SWEEP RUN {i} SCORE: last {last_s:.1f} "
              f"best {best_s:.1f} rotis/day "
              f"({(time.time() - t_run)/60:.1f} min)", flush=True)


@app.function(gpu="A100", timeout=1800, memory=16384, cpu=4)
def diag():
    import os
    import sys
    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)
    import subprocess as sp
    r = sp.run([sys.executable,
                f"{REPO}/tutorials/tandoor_step_verify.py", "check"],
               capture_output=True, text=True)
    print(r.stdout[-800:], flush=True)
    if r.returncode != 0:
        print("STDERR:", r.stderr[-1200:], flush=True)
        raise SystemExit(1)

    # ---- the advantage kernel vs the certified reference (the same
    # vtrace math our Metal kernel matched to 0.00e+00 on the Mac)
    import torch
    import pufferlib.pufferl as PL
    print("ADVANTAGE_CUDA:", PL.ADVANTAGE_CUDA, flush=True)
    torch.manual_seed(0)
    S_, T_ = 64, 128
    v = torch.randn(S_, T_, device="cuda")
    rw = torch.randn(S_, T_, device="cuda") * 0.1
    dn = (torch.rand(S_, T_, device="cuda") < 0.02).float()
    imp = (1 + 0.1 * torch.randn(S_, T_, device="cuda")).clamp(.5, 2)
    adv = torch.zeros_like(v)
    PL.compute_puff_advantage(v.clone(), rw.clone(), dn.clone(),
                              imp.clone(), adv, 0.995, 0.95, 1.0, 1.0)
    ref = torch.zeros_like(v)
    lastlam = torch.zeros(S_, device="cuda")
    for t in range(T_ - 2, -1, -1):
        rho = imp[:, t].clamp(max=1.0)
        c = imp[:, t].clamp(max=1.0)
        nonterm = 1.0 - dn[:, t + 1]
        delta = rho * (rw[:, t + 1] + 0.995 * v[:, t + 1] * nonterm
                       - v[:, t])
        lastlam = delta + 0.995 * 0.95 * c * lastlam * nonterm
        ref[:, t] = lastlam
    err = float((adv - ref).abs().max())
    print(f"advantage kernel vs reference: max err {err:.3e} "
          f"(adv absmax {float(adv.abs().max()):.3e}, "
          f"ref absmax {float(ref.abs().max()):.3e})", flush=True)
    print("diag done", flush=True)


@app.function(gpu="A100", timeout=60 * 60 * 12, memory=49152, cpu=16)
def multi_train(configs_json: str):
    """Co-locate K training runs on ONE A100 (the sweep probes use
    ~3% of its VRAM and a third of its SMs). configs_json: list of
    {name, env: {...}, train: {...}} dicts; each becomes a subprocess
    with its own experiment dir, sharing the GPU."""
    import json
    import os
    import subprocess
    import sys
    import time

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)

    configs = json.loads(configs_json)
    procs = []
    for cfg in configs:
        runner = f"""
import sys, json
sys.path.insert(0, "{pkg}")
sys.path.insert(0, "{REPO}/tutorials")
sys.path.insert(0, "{REPO}")
from pufferlib.pufferl import train, load_config
cfg = json.loads('''{json.dumps(cfg)}''')
args = load_config("puffer_hashemi")
args["train"]["device"] = "cuda"
args["env"]["device"] = "cuda"
args["wandb"] = False
args["neptune"] = False
args["env"].update(cfg.get("env", {{}}))
args["train"].update(cfg.get("train", {{}}))
args["tag"] = cfg["name"]
train("puffer_hashemi", args=args)
"""
        lg = open(f"/tmp/{cfg['name']}.log", "w")
        procs.append((cfg["name"], subprocess.Popen(
            [sys.executable, "-c", runner], stdout=lg, stderr=lg)))
        print(f"launched {cfg['name']}", flush=True)
    while any(p.poll() is None for _, p in procs):
        time.sleep(60)
        for nm, p in procs:
            tail = open(f"/tmp/{nm}.log", "rb").read()[-2000:]
            for ln in tail.decode("utf-8", "replace").splitlines():
                if "rotis_per_day" in ln or "Error" in ln:
                    print(f"[{nm}] {ln.strip()[:120]}", flush=True)
                    break
    for nm, p in procs:
        print(f"{nm}: exit {p.returncode}", flush=True)


@app.function(gpu="A100", timeout=3600, memory=49152, cpu=16)
def bench_batch():
    """How far does num_agents scale on one A100? Env+policy loop
    SPS at rising B, then one real 20M-step train at the best B."""
    import contextlib
    import io
    import os
    import sys
    import time

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)
    import importlib.util
    import numpy as np
    import torch
    from tandoor_hashemi_env import TandoorHashemiEnv
    spec = importlib.util.spec_from_file_location(
        "pol", f"{pkg}/policy.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)

    for B in (8192, 32768, 65536, 131072):
        with contextlib.redirect_stdout(io.StringIO()):
            e = TandoorHashemiEnv(num_agents=B, seed=1,
                                  wide_shutter=1, device="cuda",
                                  gpu=1, n_rays=64, warm_frac=0.8)
            e.reset(seed=1)
        pol = mod.Policy(e, hidden_size=256)
        rnn = mod.Recurrent(e, pol, input_size=256,
                            hidden_size=256).to("cuda")
        rnn.eval()
        st = dict(lstm_h=torch.zeros(B, 256, device="cuda"),
                  lstm_c=torch.zeros(B, 256, device="cuda"))
        o = torch.as_tensor(e.observations).to("cuda")
        a0 = torch.full((B, e.N_HEADS), 3, dtype=torch.long,
                        device="cuda")
        for _ in range(10):
            with torch.no_grad():
                rnn.forward_eval(o, st)
            e.step_torch(a0)
        torch.cuda.synchronize()
        t0 = time.perf_counter()
        N = 40
        for _ in range(N):
            with torch.no_grad():
                logits, v = rnn.forward_eval(o, st)
            o2, r, d, tr, _ = e.step_torch(a0)
            o = o2
        torch.cuda.synchronize()
        dt = time.perf_counter() - t0
        mem = torch.cuda.max_memory_allocated() / 1e9
        print(f"B={B:6d}: {N*B/dt/1e6:.2f}M env+policy sps "
              f"({dt/N*1000:.1f} ms/step, peak mem {mem:.1f} GB)",
              flush=True)
        del e, pol, rnn, st, o
        torch.cuda.empty_cache()
        torch.cuda.reset_peak_memory_stats()

    # one real train slice at the winner
    from pufferlib.pufferl import train, load_config
    args = load_config("puffer_hashemi")
    args["train"]["device"] = "cuda"
    args["env"]["device"] = "cuda"
    args["env"]["num_agents"] = 65536
    args["train"]["total_timesteps"] = 40_000_000
    args["wandb"] = False
    args["neptune"] = False
    t0 = time.perf_counter()
    train("puffer_hashemi", args=args)
    dt = time.perf_counter() - t0
    print(f"REAL TRAIN B=65536: 40M steps in {dt:.0f}s = "
          f"{4e7/dt/1e6:.2f}M SPS end-to-end", flush=True)


@app.function(gpu="L4", timeout=3600, memory=32768, cpu=8)
def bench_l4():
    """The cheap card, saturated. L4 is $0.80/h to the A100's $2.50;
    the workload is launch-bound, not FLOP- or VRAM-bound, so the
    question is naans per dollar. Sequence: (1) HARD parity gate -
    the CUDA step must replay the frozen MPS bundle; (2) env+policy
    SPS at rising num_agents until the 24 GB is spoken for (with
    batch_size=auto the experience buffer is agents*128 rows, so B
    IS the batch lever, ~42 KB/agent trainer-side); (3) one real
    train slice at the biggest B that leaves the trainer room, with
    minibatch_size doubled to 131072 to match. Reports SPS + peak
    VRAM at every stage."""
    import contextlib
    import io
    import os
    import subprocess
    import sys
    import time

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)

    r = subprocess.run(
        [sys.executable, f"{REPO}/tutorials/tandoor_step_verify.py",
         "check"], capture_output=True, text=True)
    print(r.stdout[-600:], flush=True)
    assert r.returncode == 0, \
        f"CUDA-vs-MPS step gate FAILED: {r.stderr[-800:]}"

    import importlib.util
    import torch
    from tandoor_hashemi_env import TandoorHashemiEnv
    print("GPU:", torch.cuda.get_device_name(0), flush=True)
    spec = importlib.util.spec_from_file_location(
        "pol", f"{pkg}/policy.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)

    fits = []
    for B in (32768, 65536, 131072, 196608, 262144):
        try:
            with contextlib.redirect_stdout(io.StringIO()):
                e = TandoorHashemiEnv(num_agents=B, seed=1,
                                      wide_shutter=1, device="cuda",
                                      gpu=1, n_rays=64, warm_frac=0.8)
                e.reset(seed=1)
            pol = mod.Policy(e, hidden_size=256)
            rnn = mod.Recurrent(e, pol, input_size=256,
                                hidden_size=256).to("cuda")
            rnn.eval()
            st = dict(lstm_h=torch.zeros(B, 256, device="cuda"),
                      lstm_c=torch.zeros(B, 256, device="cuda"))
            o = torch.as_tensor(e.observations).to("cuda")
            a0 = torch.full((B, e.N_HEADS), 3, dtype=torch.long,
                            device="cuda")
            for _ in range(10):
                with torch.no_grad():
                    rnn.forward_eval(o, st)
                e.step_torch(a0)
            torch.cuda.synchronize()
            t0 = time.perf_counter()
            N = 40
            for _ in range(N):
                with torch.no_grad():
                    logits, v = rnn.forward_eval(o, st)
                o2, r_, d, tr, _ = e.step_torch(a0)
                o = o2
            torch.cuda.synchronize()
            dt = time.perf_counter() - t0
            mem = torch.cuda.max_memory_allocated() / 1e9
            # trainer adds ~42 KB/agent of experience buffers
            # (42 KB = 42e-6 GB - the first run of this printed the
            # estimate 1000x low; the OOM step-down below was the
            # real guard and B=262144 fit at ~20 GB regardless)
            est = mem + B * 42e-6
            fit = est < 21.0
            print(f"B={B:6d}: {N*B/dt/1e6:.2f}M env+policy sps "
                  f"({dt/N*1000:.1f} ms/step, peak {mem:.1f} GB, "
                  f"+train est {est:.1f} GB"
                  f"{'' if fit else ' - WONT FIT'})", flush=True)
            if fit:
                fits.append(B)
            del e, pol, rnn, st, o
        except torch.cuda.OutOfMemoryError:
            print(f"B={B}: OOM in env+policy loop", flush=True)
        torch.cuda.empty_cache()
        torch.cuda.reset_peak_memory_stats()

    # one real train slice at the saturating config, OOM step-down
    from pufferlib.pufferl import train, load_config
    for B in sorted(fits, reverse=True):
        args = load_config("puffer_hashemi")
        args["train"]["device"] = "cuda"
        args["env"]["device"] = "cuda"
        args["env"]["num_agents"] = B
        args["train"]["minibatch_size"] = 131072
        args["train"]["total_timesteps"] = 8 * B * 128
        args["wandb"] = False
        args["neptune"] = False
        torch.cuda.empty_cache()
        torch.cuda.reset_peak_memory_stats()
        try:
            t0 = time.perf_counter()
            train("puffer_hashemi", args=args)
            dt = time.perf_counter() - t0
            print(f"REAL TRAIN B={B} mb=131072: {8*B*128/1e6:.0f}M "
                  f"steps in {dt:.0f}s = {8*B*128/dt/1e6:.2f}M SPS "
                  f"end-to-end, peak "
                  f"{torch.cuda.max_memory_allocated()/1e9:.1f} GB "
                  f"of 24", flush=True)
            break
        except torch.cuda.OutOfMemoryError:
            print(f"TRAIN B={B}: OOM, stepping down", flush=True)


@app.local_entrypoint()
def main(smoke: bool = False, max_runs: int = 40,
         run_diag: bool = False):
    if run_diag:
        diag.remote()
    else:
        run_sweep.remote(max_runs=max_runs, smoke=smoke)


@app.local_entrypoint()
def bench():
    bench_batch.remote()


@app.function(gpu="L4", timeout=3600, memory=32768, cpu=8)
def train_slice_l4(B: int = 32768):
    """One train slice at a GIVEN B. The saturation probe measured
    the trap: stock pufferl recomputes the FULL-buffer advantage
    every minibatch, so train cost per step grows linearly with B -
    B=262144 gave 0.08M SPS end-to-end (19 GB, 88% of the epoch in
    train). The L4 question is therefore its throughput at SANE B."""
    import os
    import sys
    import time

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)
    import torch
    from pufferlib.pufferl import train, load_config
    args = load_config("puffer_hashemi")
    args["train"]["device"] = "cuda"
    args["env"]["device"] = "cuda"
    args["env"]["num_agents"] = B
    args["train"]["total_timesteps"] = 10 * B * 128
    args["wandb"] = False
    args["neptune"] = False
    torch.cuda.reset_peak_memory_stats()
    t0 = time.perf_counter()
    train("puffer_hashemi", args=args)
    dt = time.perf_counter() - t0
    print(f"TRAIN SLICE B={B}: {10*B*128/1e6:.0f}M steps in "
          f"{dt:.0f}s = {10*B*128/dt/1e6:.3f}M SPS end-to-end, "
          f"peak {torch.cuda.max_memory_allocated()/1e9:.1f} GB",
          flush=True)


@app.function(gpu="L4", timeout=3600, memory=32768, cpu=8)
def cuda_check(B: int = 32768):
    """The CUDA megakernel gate: (1) the frozen MPS zero-noise
    bundle must replay through the NVRTC kernels (make_state now
    mounts FusedState on CUDA); (2) verify_fused torch-vs-kernels
    on-device; (3) the advantage kernel vs the source-patched loop;
    (4) env+policy SPS at B (vs 0.66M on the torch fallback);
    (5) a real train slice (vs 94K end-to-end)."""
    import contextlib
    import io
    import os
    import subprocess
    import sys
    import time

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)

    r = subprocess.run(
        [sys.executable, f"{REPO}/tutorials/tandoor_step_verify.py",
         "check"], capture_output=True, text=True)
    print(r.stdout[-700:], flush=True)
    assert r.returncode == 0, \
        f"BUNDLE GATE FAILED: {r.stderr[-1500:]}"

    from tandoor_fused_step import verify_fused
    verify_fused(dev="cuda")

    import torch
    import pufferlib.pufferl as PL
    from tandoor_cuda_kernel import puff_adv
    torch.manual_seed(0)
    S_, T_ = 256, 128
    v = torch.randn(S_, T_, device="cuda")
    rw = torch.randn(S_, T_, device="cuda") * 0.1
    dn = (torch.rand(S_, T_, device="cuda") < 0.02).float()
    imp = (1 + 0.1 * torch.randn(S_, T_, device="cuda")).clamp(.5, 2)
    a1 = puff_adv(v, rw, dn, imp, torch.zeros_like(v),
                  0.995, 0.95, 1.0, 1.0)
    a2 = PL.compute_puff_advantage(
        v.clone(), rw.clone(), dn.clone(), imp.clone(),
        torch.zeros_like(v), 0.995, 0.95, 1.0, 1.0)
    err = float((a1 - a2).abs().max())
    print(f"advantage kernel vs patched loop: max err {err:.3e}",
          flush=True)
    assert err < 1e-4

    import importlib.util
    from tandoor_hashemi_env import TandoorHashemiEnv
    spec = importlib.util.spec_from_file_location(
        "pol", f"{pkg}/policy.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(num_agents=B, seed=1, wide_shutter=1,
                              device="cuda", gpu=1, n_rays=64,
                              warm_frac=0.8)
        e.reset(seed=1)
    assert e._metal is not None, "CudaGeo did not mount"
    pol = mod.Policy(e, hidden_size=256)
    rnn = mod.Recurrent(e, pol, input_size=256,
                        hidden_size=256).to("cuda")
    rnn.eval()
    st = dict(lstm_h=torch.zeros(B, 256, device="cuda"),
              lstm_c=torch.zeros(B, 256, device="cuda"))
    o = torch.as_tensor(e.observations).to("cuda")
    a0 = torch.full((B, e.N_HEADS), 3, dtype=torch.long,
                    device="cuda")
    for _ in range(10):
        with torch.no_grad():
            rnn.forward_eval(o, st)
        e.step_torch(a0)
    torch.cuda.synchronize()
    t0 = time.perf_counter()
    N = 60
    for _ in range(N):
        with torch.no_grad():
            logits, vv = rnn.forward_eval(o, st)
        o2, r_, d, tr, _ = e.step_torch(a0)
        o = o2
    torch.cuda.synchronize()
    dt = time.perf_counter() - t0
    print(f"CUDA-kernel env+policy B={B}: {N*B/dt/1e6:.2f}M sps "
          f"({dt/N*1000:.1f} ms/step)", flush=True)
    del e, pol, rnn, st, o
    torch.cuda.empty_cache()

    from pufferlib.pufferl import train, load_config
    args = load_config("puffer_hashemi")
    args["train"]["device"] = "cuda"
    args["env"]["device"] = "cuda"
    args["env"]["num_agents"] = B
    args["train"]["total_timesteps"] = 10 * B * 128
    args["wandb"] = False
    args["neptune"] = False
    t0 = time.perf_counter()
    train("puffer_hashemi", args=args)
    dt = time.perf_counter() - t0
    print(f"CUDA-kernel TRAIN B={B}: {10*B*128/1e6:.0f}M steps in "
          f"{dt:.0f}s = {10*B*128/dt/1e6:.3f}M SPS end-to-end",
          flush=True)


@app.local_entrypoint()
def bench_l4_run():
    bench_l4.remote()


@app.function(gpu="T4", timeout=3600, memory=32768, cpu=8)
def cuda_check_t4(B: int = 32768):
    """The same gate + numbers on the $0.59/h Turing card - the
    megakernel is plain CUDA C++, sm_75 compiles fine; whether the
    naans-per-dollar beat the L4 is a dime-sized measurement."""
    cuda_check.local(B=B)


@app.function(gpu="L4", timeout=3600, memory=32768, cpu=8)
def learn_probe():
    """Why does the sweep score 0 everywhere while the same env
    learns on MPS? Instrument the FAILING platform at the buffer
    level: per-epoch reward-storage stats, recomputed advantage
    magnitude, entropy and kl - once at the user's proven MPS
    hyperparams (lr 1e-3, hidden 256) and once at the sweep center
    (lr 1e-2). Healthy buffers + flat entropy = hyperparams/time;
    zeroed buffers = the collect/storage layer, caught red-handed."""
    import contextlib
    import io
    import os
    import sys

    pkg = f"{REPO}/tutorials/puffer_tandoor"
    os.chdir(pkg)
    sys.path.insert(0, pkg)
    sys.path.insert(0, f"{REPO}/tutorials")
    sys.path.insert(0, REPO)
    import pufferlib as _pl
    _pl_dir = os.path.dirname(_pl.__file__)
    for a, b in ((f"{pkg}/hashemi.ini",
                  os.path.join(_pl_dir, "config", "hashemi.ini")),
                 (pkg, os.path.join(_pl_dir, "environments",
                                    "tandoor"))):
        if not os.path.exists(b):
            os.symlink(a, b)
    import torch
    import pufferlib.pufferl as PL
    from pufferlib.pufferl import (PuffeRL, load_config, load_env,
                                   load_policy)
    for tag, lr in (("known-good-lr1e-3", 0.001),
                    ("sweep-center-lr1e-2", 0.01)):
        args = load_config("puffer_hashemi")
        args["train"]["device"] = "cuda"
        args["env"]["device"] = "cuda"
        args["wandb"] = False
        args["neptune"] = False
        args["env"]["num_agents"] = 8192
        args["train"]["learning_rate"] = lr
        args["policy"]["hidden_size"] = 256
        args["rnn"]["input_size"] = 256
        args["rnn"]["hidden_size"] = 256
        with contextlib.redirect_stdout(io.StringIO()):
            vecenv = load_env("puffer_hashemi", args)
            policy = load_policy(args, vecenv)
            tr = PuffeRL(dict(**args["train"], env="puffer_hashemi"),
                         vecenv, policy, None)
        print(f"=== {tag} ===", flush=True)
        for ep in range(25):
            with contextlib.redirect_stdout(io.StringIO()):
                tr.evaluate()
            rew, term = tr.rewards, tr.terminals
            nz = float((rew != 0).float().mean())
            adv = torch.zeros_like(tr.values)
            adv = PL.compute_puff_advantage(
                tr.values.clone(), rew.clone(), term.clone(),
                torch.ones_like(rew), adv, 0.995, 0.95, 1.0, 1.0)
            with contextlib.redirect_stdout(io.StringIO()):
                tr.train()
            L = tr.losses or {}
            if ep % 4 == 0 or ep == 24:
                print(f"[{tag}] ep {ep}: rew nz {nz*100:.0f}% "
                      f"mean {float(rew.mean()):+.4f} "
                      f"std {float(rew.std()):.4f} "
                      f"adv absmax {float(adv.abs().max()):.3f} "
                      f"vstd {float(tr.values.std()):.4f} "
                      f"ent {L.get('entropy', -1):.2f}/29.19 "
                      f"kl {L.get('approx_kl', -1):.5f}", flush=True)
        del tr, vecenv, policy
        torch.cuda.empty_cache()


@app.local_entrypoint()
def learn_probe_run():
    learn_probe.remote()


@app.local_entrypoint()
def cuda_check_run(b: int = 32768):
    cuda_check.remote(B=b)


@app.local_entrypoint()
def cuda_check_t4_run(b: int = 32768):
    cuda_check_t4.remote(B=b)


@app.local_entrypoint()
def slice_l4(b: int = 32768):
    train_slice_l4.remote(B=b)

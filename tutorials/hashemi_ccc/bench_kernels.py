"""How fast is the generated kernel against the handwritten one.

Times, on this machine's GPU (MPS):
  - `hashemi_mega`, the kernel compiled from Hashemi.lean (226 columns per agent, every definition
    and theorem statement of the file, a 24-step bisection inside), at several batch sizes;
  - `HashemiMachineEnv.step`, the env around it (the sun, the observation, the reward in NumPy);
  - the NumPy twin of the row, for the reference cost;
  - the handwritten tandoor megakernel: `TandoorHashemiEnv.step` on hashemi.ini's config (gpu=1:
    motors, the mount solve, the 512-ray trace through the optics, the thermal model, the reward,
    all in one Metal kernel per step) at its 8192 agents, and at 1024 for the scaling.
    python bench_kernels.py
"""
import configparser
import os
import sys
import time

import numpy as np
import torch

HERE = os.path.dirname(os.path.abspath(__file__))
TUT = os.path.dirname(HERE)
ROOT = os.path.dirname(TUT)
for p in (ROOT, TUT, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)
from hashemi_kernel import HashemiMetal, N_COLS, mega_numpy, mega_params_numpy   # noqa: E402
from hashemi_env import HashemiMachineEnv, sensor_loop_actions                    # noqa: E402


def sync():
    torch.mps.synchronize()


def timeit(fn, n_warm=5, n=30):
    for _ in range(n_warm):
        fn()
    sync()
    t0 = time.perf_counter()
    for _ in range(n):
        fn()
    sync()
    return (time.perf_counter() - t0) / n


def bench_generated():
    k = HashemiMetal()
    prm = torch.tensor(mega_params_numpy(), dtype=torch.float32, device="mps")
    rows = []
    for B in (1024, 8192, 65536, 262144, 1048576):
        rng = np.random.default_rng(0)
        st = torch.tensor(np.stack([rng.uniform(0, 6.28, B), rng.uniform(0, 1.0, B), np.zeros(B)], 1), dtype=torch.float32, device="mps")
        cmd = torch.tensor(rng.uniform(-0.2, 0.2, (B, 2)), dtype=torch.float32, device="mps")
        sun = torch.tensor(np.stack([rng.uniform(0.2, 1.4, B), rng.uniform(0, 6.28, B), np.full(B, 800.0)], 1), dtype=torch.float32, device="mps")
        dt = timeit(lambda: k.step(st, cmd, 15.0, sun, prm))
        rows.append((B, dt))
        print(f"  hashemi_mega  B={B:8d}  {1e3 * dt:8.3f} ms/launch  {1e9 * dt / B:8.1f} ns/agent-step  {B / dt / 1e6:8.2f} M agent-steps/s")
    return rows


def bench_numpy_twin():
    B = 8192
    rng = np.random.default_rng(0)
    st = np.stack([rng.uniform(0, 6.28, B), rng.uniform(0, 1.0, B), np.zeros(B)], 1)
    cmd = rng.uniform(-0.2, 0.2, (B, 2))
    sun = np.stack([rng.uniform(0.2, 1.4, B), rng.uniform(0, 6.28, B), np.full(B, 800.0)], 1)
    prm = mega_params_numpy()
    t0 = time.perf_counter()
    for _ in range(3):
        mega_numpy(st, cmd, 15.0, sun, prm)
    dt = (time.perf_counter() - t0) / 3
    print(f"  NumPy twin    B={B:8d}  {1e3 * dt:8.1f} ms/row      {1e9 * dt / B:8.1f} ns/agent-step")
    return dt


def bench_env():
    out = []
    for B in (8192, 65536):
        env = HashemiMachineEnv(num_agents=B, day_of_year=172, dt=15.0)
        env.reset()
        act = sensor_loop_actions(env)
        dt = timeit(lambda: env.step(act), n_warm=3, n=20)
        print(f"  HashemiMachineEnv.step  B={B:6d}  {1e3 * dt:8.2f} ms/step  {1e9 * dt / B:8.1f} ns/agent-step")
        out.append((B, dt))
    return out


def ini_env_kwargs(path):
    cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#"))
    cp.read(path)
    kw = {}
    for k, v in cp["env"].items():
        v = v.strip()
        if k in ("num_agents",):
            continue
        try:
            kw[k] = int(v)
        except ValueError:
            try:
                kw[k] = float(v)
            except ValueError:
                kw[k] = v
    return kw


def bench_tandoor():
    from tandoor_hashemi_env import TandoorHashemiEnv
    kw = ini_env_kwargs(os.path.join(TUT, "puffer_tandoor", "hashemi.ini"))
    out = []
    for B in (1024, 8192):
        env = TandoorHashemiEnv(num_agents=B, **kw)
        env.reset()
        nvec = env.single_action_space.nvec
        rng = np.random.default_rng(0)
        act = np.stack([rng.integers(0, n, B) for n in nvec], 1)
        dt = timeit(lambda: env.step(act), n_warm=3, n=15)
        print(f"  TandoorHashemiEnv.step (gpu=1, {kw.get('n_rays')} rays)  B={B:6d}  {1e3 * dt:8.2f} ms/step  "
              f"{1e9 * dt / B:8.1f} ns/agent-step  {B / dt / 1e3:8.1f} k agent-steps/s")
        out.append((B, dt))
    return out


if __name__ == "__main__":
    print("== the generated kernel (Hashemi.lean -> Ccc -> hashemi_mega), 226 columns/agent")
    g = bench_generated()
    print("== the NumPy twin of the same row")
    bench_numpy_twin()
    print("== the env on the generated kernel")
    e = bench_env()
    print("== the handwritten tandoor megakernel (motors + mount + 512-ray trace + thermal + reward)")
    t = bench_tandoor()

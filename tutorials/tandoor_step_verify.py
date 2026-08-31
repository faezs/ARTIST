"""Cross-device zero-noise STEP trajectory: CUDA must replay MPS.

The trace-level gate (tandoor_cuda_verify) proved the optics; the
first Modal probe learned nothing, so the WHOLE step needs the same
discipline. With env zero-noise (GpuState draws deterministic) plus
the deterministic-trace flag (sun/optics draws pinned to their
medians), the gpu-path trajectory is a pure function of the action
script - identical on any backend up to float32 reassociation.

    python tandoor_step_verify.py gen     # Mac, records 120 steps
    python tandoor_step_verify.py check   # CUDA, replays + compares
"""
import contextlib
import io
import pathlib
import sys

import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))

BUNDLE = pathlib.Path(__file__).parent / "puffer_tandoor" \
    / "step_ref_bundle.pt"
B, STEPS = 32, 120


def _env(device):
    from tandoor_hashemi_env import TandoorHashemiEnv
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(num_agents=B, seed=99, wide_shutter=1,
                              device=device, gpu=1, n_rays=64,
                              warm_frac=1.0, day_random=0,
                              lat_random=0)
        e.reset(seed=99)
    # deterministic everything
    e._det_trace = True
    e.T[:] = 500.0
    e.equilibrate_wall(halo=400.0)
    e._belt_prev = e.T[:, :e.n_belt].max(1).copy()
    return e


def _script(t):
    """Deterministic action script exercising motors, plenum, shutter:
    hold, slew, re-acquire, load-ish cadence."""
    a = np.full((B, 5), 3, dtype=np.int64)
    a[:, 0] = [6, 3, 0, 4][t // 30 % 4]          # plenum level
    a[:, 1] = 1 if (t // 45) % 2 else 0          # shutter-ish head
    a[:, 3] = 4 if t % 17 < 8 else 2             # az jog
    a[:, 4] = 4 if t % 23 < 11 else 2            # el jog
    return a


def _run(e):
    dev = e.device
    from tandoor_fused_step import make_state
    e._gpu = make_state(e)            # fused kernels on MPS, torch on CUDA
    e._gpu.zero_noise = True          # deterministic from step 0
    obs_t, rew_t = [], []
    for t in range(STEPS):
        a = torch.as_tensor(_script(t), device=dev)
        o, r, d, tr, _ = e.step_torch(a)
        obs_t.append(o.cpu())
        rew_t.append(r.cpu())
    return torch.stack(obs_t), torch.stack(rew_t)


def gen():
    e = _env("mps")
    obs, rew = _run(e)
    torch.save(dict(obs=obs, rew=rew), BUNDLE)
    print(f"bundle: obs {tuple(obs.shape)}, rew sum "
          f"{float(rew.sum()):.4f} -> {BUNDLE.name}")


def check():
    e = _env("cuda")
    obs, rew = _run(e)
    ref = torch.load(BUNDLE, map_location="cpu", weights_only=False)
    do = (obs - ref["obs"]).abs().max()
    dr = (rew - ref["rew"]).abs().max()
    # per-step worst obs error to localize any divergence in time
    per_step = (obs - ref["obs"]).abs().amax(dim=(1, 2))
    first_bad = int((per_step > 5e-3).float().argmax()) \
        if bool((per_step > 5e-3).any()) else -1
    print(f"CUDA vs MPS step trajectory: max obs err {float(do):.2e}, "
          f"max rew err {float(dr):.2e}, first step over 5e-3: "
          f"{first_bad}")
    assert float(do) < 5e-3, "obs trajectory diverges"
    assert float(dr) < 2e-2, "reward trajectory diverges"
    print("CUDA-vs-MPS step parity: PASS")


if __name__ == "__main__":
    {"gen": gen, "check": check}[sys.argv[1]]()

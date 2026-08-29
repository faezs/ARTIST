"""Zero-noise step-trajectory harness: numpy path vs GPU state path.

The same discipline the megakernel got, applied to the state machine.
Both envs share one torch generator sequence for the trace draws (so
the megakernel noise is IDENTICAL, and the kernel itself is already
verified to 1e-6 against the eager core); every state-machine noise
source is forced to zero - numpy side via an rng stub, GPU side via
GpuState.zero_noise. What remains is deterministic physics, so the two
trajectories must agree to float32-accumulation tolerance, step for
step, across T, p_act, rewards, pointing and the obs vector.
"""
import contextlib, io, pathlib, sys
import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_gpu_step import GpuState


class _ZeroRng:
    def normal(self, loc=0.0, scale=1.0, size=None):
        return np.zeros(size) if size is not None else 0.0
    def random(self, size=None):
        return (np.full(size, 0.5) if size is not None else 0.5)
    def uniform(self, lo=0.0, hi=1.0, size=None):
        mid = (np.asarray(lo) + np.asarray(hi)) / 2.0
        return np.full(size, mid) if size is not None else mid
    def integers(self, lo, hi=None):
        return int(lo if hi is not None else 0)


def verify(B=64, n_steps=300, n_rays=64, seed=3):
    mk = lambda gpu: TandoorHashemiEnv(
        num_agents=B, seed=seed, wide_shutter=1, device="mps",
        n_rays=n_rays, fuse=0, gpu=gpu)
    with contextlib.redirect_stdout(io.StringIO()):
        A = mk(0); A.reset(seed=seed)
        Bv = mk(1); Bv.reset(seed=seed)
    # identical torch-generator streams for the trace draws
    Bv._gen.set_state(A._gen.get_state())
    # the reference must run float32 like the GPU: in float64 its
    # continuous state drifts ~0.5 K from the fp32 path over 300 steps
    # (different precision, different op order), and discrete threshold
    # events - the 560 K load gate, the 45 kJ cook line - then flip on
    # one path only, showing up as a spurious +-5 reward "mismatch".
    for nm in ("T", "p_act", "p_set", "p_dist", "bread_E", "bread_t",
               "_belt_prev", "cloud", "wind_g", "bore", "load_timer",
               "ep_return", "soil", "el_m", "az_m", "f_locked",
               "decl_formed", "form_time"):
        setattr(A, nm, getattr(A, nm).astype(np.float32))
    A.rng = _ZeroRng()
    Bv.rng = _ZeroRng()
    Bv._gpu = GpuState(Bv)
    Bv._gpu.zero_noise = True
    arng = np.random.default_rng(11)
    worst = dict(T=0.0, p_act=0.0, rew=0.0, e_az=0.0, obs=0.0)
    for t in range(n_steps):
        act = arng.integers(0, 7, (B, 5))
        _, rA, *_ = A.step(act.copy())
        rA = rA.copy()
        _, rB, *_ = Bv.step(act.copy())
        S = Bv._gpu
        worst["T"] = max(worst["T"],
                         float(np.abs(A.T - S.T.cpu().numpy()).max()))
        worst["p_act"] = max(worst["p_act"], float(
            np.abs(A.p_act - S.p_act.cpu().numpy()).max()))
        worst["rew"] = max(worst["rew"], float(np.abs(rA - rB).max()))
        worst["e_az"] = max(worst["e_az"], float(
            np.abs(A._e_az - Bv._e_az).max()))
        worst["obs"] = max(worst["obs"], float(
            np.abs(A.observations - Bv.observations).max()))
    return worst


if __name__ == "__main__":
    w = verify()
    print("zero-noise trajectory, 300 steps, worst deviations:")
    for k, v in w.items():
        print(f"  {k:6s} {v:.3e}")
    ok = (w["T"] < 0.5 and w["rew"] < 0.02 and w["obs"] < 5e-3
          and w["p_act"] < 0.05 and w["e_az"] < 1e-3)
    print("PARITY:", "PASS" if ok else "FAIL")

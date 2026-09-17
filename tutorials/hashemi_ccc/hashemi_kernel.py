"""The Hashemi machine's step as ONE kernel per agent, from the Lean spec.

The physics is hashemi_ccc.h - generated from RequestProject/Hashemi.lean and HashemiStep.lean by
RequestProject/Ccc.lean (a MetaM translator over the definitions as they stand), and proved equal
to those definitions by the round-trip theorems in HashemiCccRound.lean. This module only wraps
`hk_step` for the env: the Metal source is the header under MSL macros plus a thin `kernel void`,
compiled the way MetalGeo compiles mount_solve (torch.mps.compile_shader); the CUDA source is the
same header under CUDA macros. The NumPy twin (hashemi_ccc.py, the same graphs printed for NumPy)
is the reference every kernel is checked against - one truth, printed three ways.

    state  (B, 2)  az [rad], t [rad]            the carriage's azimuth and the dish's swing
    cmd    (B, 2)  omega_m, omega_d [rad/s]     the roller's rate and the drum's (positive = take in)
    params (B, 9)  rw R rDrum ym hp a ze f h    TandoorHashemi.stepParams gives his machine's
    out    (B, 13) see TandoorHashemi.step: az' t' arm tension/(W rcm) tDead V.y V.z N.y N.z creep
                   postCross postInside rimDepth
"""
import os
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
STATE_W, CMD_W, PRM_W, OUT_W = 2, 2, 9, 13

# his machine, TandoorHashemi.stepParams: rw R rDrum ym hp a ze f h (rDrum is not in the video)
HASHEMI_PARAMS = np.array([0.05, np.sqrt(0.92 ** 2 + 0.80 ** 2), 0.03, 1.22, 0.34, 0.8,
                           np.sqrt(3.36) - 1.0, 1.0, 0.00175 / (2 * np.pi)], dtype=np.float64)


def header_text():
    with open(os.path.join(HERE, "hashemi_ccc.h")) as f:
        return f.read()


MSL_PRELUDE = """
#include <metal_stdlib>
using namespace metal;
#define HK_NO_STD
#define HK_ADDR thread
#define hk_real float
#define hk_sqrt sqrt
#define hk_sin sin
#define hk_cos cos
#define hk_tan tan
#define hk_atan atan
#define hk_exp exp
#define hk_log log
#define hk_fabs fabs
#define hk_min fmin
#define hk_max fmax
"""

CUDA_PRELUDE = """
#define HK_NO_STD
#define HK_STATIC __device__ __forceinline__
#define hk_real float
#define hk_sqrt sqrtf
#define hk_sin sinf
#define hk_cos cosf
#define hk_tan tanf
#define hk_atan atanf
#define hk_exp expf
#define hk_log logf
#define hk_fabs fabsf
#define hk_min fminf
#define hk_max fmaxf
"""

MSL_KERNEL = """
kernel void hashemi_step(
    device float*       st   [[buffer(0)]],   // (B,2) az, t - updated in place
    device const float* cmd  [[buffer(1)]],   // (B,2) omega_m, omega_d
    device const float* prm  [[buffer(2)]],   // (B,9)
    device const float* dtb  [[buffer(3)]],   // (1,) dt
    device float*       out  [[buffer(4)]],   // (B,13)
    device const int*   nB   [[buffer(5)]],
    uint b [[thread_position_in_grid]])
{
    if ((int)b >= nB[0]) return;
    device const float* p = prm + b * 9;
    hk_real o[13];
    hk_step(st[2*b], st[2*b+1], cmd[2*b], cmd[2*b+1], dtb[0],
            p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], o);
    for (int k = 0; k < 13; k++) out[13*b + k] = o[k];
    st[2*b] = o[0]; st[2*b+1] = o[1];
}
"""

CUDA_KERNEL = """
extern "C" __global__ void hashemi_step(float* st, const float* cmd, const float* prm,
                                        const float dt, float* out, int nB)
{
    int b = blockIdx.x * blockDim.x + threadIdx.x;
    if (b >= nB) return;
    const float* p = prm + b * 9;
    hk_real o[13];
    hk_step(st[2*b], st[2*b+1], cmd[2*b], cmd[2*b+1], dt,
            p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], o);
    for (int k = 0; k < 13; k++) out[13*b + k] = o[k];
    st[2*b] = o[0]; st[2*b+1] = o[1];
}
"""


def msl_source():
    return MSL_PRELUDE + header_text() + MSL_KERNEL


def cuda_source():
    return CUDA_PRELUDE + header_text() + CUDA_KERNEL


def step_numpy(state, cmd, dt, params):
    """the reference: the NumPy twin of TandoorHashemi.step, vectorised over agents"""
    import importlib.util
    spec = importlib.util.spec_from_file_location("hashemi_ccc", os.path.join(HERE, "hashemi_ccc.py"))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    st = np.asarray(state, dtype=np.float64); cm = np.asarray(cmd, dtype=np.float64)
    pr = np.broadcast_to(np.asarray(params, dtype=np.float64), (st.shape[0], PRM_W))
    args = [st[:, 0], st[:, 1], cm[:, 0], cm[:, 1], np.full(st.shape[0], float(dt))] + [pr[:, k] for k in range(PRM_W)]
    return mod.hk_step(*args)


class HashemiMetal:
    """`hk_step` as a Metal kernel, one thread per agent"""

    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(msl_source())
        self._buf = {}

    def step(self, state, cmd, dt, params):
        """state (B,2) float32 mps tensor, updated in place; returns out (B,13)"""
        torch = self.torch
        B = state.shape[0]
        key = B
        bufs = self._buf.get(key)
        if bufs is None:
            bufs = (torch.empty(B, OUT_W, dtype=torch.float32, device="mps"),
                    torch.tensor([B], dtype=torch.int32, device="mps"),
                    torch.empty(1, dtype=torch.float32, device="mps"))
            self._buf[key] = bufs
        out, nB, dtb = bufs
        dtb.fill_(float(dt))
        prm = params.to(torch.float32)
        if prm.dim() == 1:
            prm = prm.unsqueeze(0).expand(B, PRM_W)
        self.lib.hashemi_step(state, cmd.to(torch.float32).contiguous(), prm.contiguous(), dtb, out, nB)
        return out


if __name__ == "__main__":
    # parity: the Metal kernel against the NumPy twin, on random states of his machine
    import sys
    rng = np.random.default_rng(3)
    B = 4096
    state = np.stack([rng.uniform(0, 2 * np.pi, B), rng.uniform(0.0, 1.05, B)], axis=1)
    cmd = np.stack([rng.uniform(-2, 2, B), rng.uniform(-0.5, 0.5, B)], axis=1)
    dt = 1.0
    ref = step_numpy(state, cmd, dt, HASHEMI_PARAMS)
    try:
        import torch
        k = HashemiMetal()
        st = torch.tensor(state, dtype=torch.float32, device="mps")
        out = k.step(st, torch.tensor(cmd, dtype=torch.float32, device="mps"), dt,
                     torch.tensor(HASHEMI_PARAMS, dtype=torch.float32, device="mps")).cpu().numpy()
    except Exception as e:  # no Metal here: report and stop
        print("Metal unavailable:", e); sys.exit(2)
    err = np.abs(out - ref) / np.maximum(1.0, np.abs(ref))
    worst = err.max(axis=0)
    names = "az t arm tension tDead Vy Vz Ny Nz creep postCross postInside rimDepth".split()
    for n, w in zip(names, worst):
        print(f"{n:12s} max rel err {w:.2e}")
    ok = (worst < 2e-5).all()
    print("METAL == NUMPY" if ok else "MISMATCH", "over", B, "agents")
    sys.exit(0 if ok else 1)

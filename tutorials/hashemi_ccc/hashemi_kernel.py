"""The megakernel of Hashemi's machine: every definition of Hashemi.lean, one thread per agent.

hashemi_ccc.h is Hashemi.lean compiled by Ccc.lean; hashemi_mega.json is the manifest of the
six `mega*` functions of HashemiMega.lean (their column names, the shared input order, their
offsets in the row). This module wraps them:
  - MSL / CUDA source for `hashemi_mega`: reads the state (az, t, slack), the commands (ωm, ωd),
    the sun (elSun, azSun, dni), the parameters (megaParams' eight), calls the six functions
    into one row per agent, and writes the step's new state back;
  - `mega_numpy`: the same row from the NumPy twin (hashemi_ccc.py), the reference;
  - `HashemiMetal`: the Metal kernel on MPS, state updated in place.
`python hashemi_kernel.py` runs the Metal kernel against the NumPy twin on random states.
"""
import json
import os

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
MANIFEST = json.load(open(os.path.join(HERE, "hashemi_mega.json")))
COLUMNS = MANIFEST["columns"]
COL = {n: i for i, n in enumerate(COLUMNS)}
N_COLS = int(MANIFEST["n_columns"])
INPUTS = MANIFEST["inputs"]           # az t slack omegam omegad dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
MEGA_FNS = MANIFEST["functions"]
# THE MOUNT IS NO LONGER ONE MACHINE.  Until 2026-09-20 every `mega*` function opened
# `let ym := ymHashemi; let a := dishHalf; ...` - HIS 0.8 m build, frozen - while the optics took
# R, f, a, w, rc as real inputs, so at the ini's 2 m reflector a 4 m dish flew on a carriage built
# for 1.6 m.  The six now take three more inputs, `dHalf wFacet rCoil` (HashemiMega.lean), and
# every mount dimension is a compiled function of them (Hashemi.lean section 16).  They are a
# fourth parameter group here, after the eight of `megaParams`.
STATE_W, CMD_W, SUN_W, PRM_W, DIM_W = 3, 2, 3, 8, 3
assert len(INPUTS) == STATE_W + CMD_W + 1 + SUN_W + PRM_W + DIM_W, INPUTS
assert len(COLUMNS) == N_COLS, (len(COLUMNS), N_COLS)


def header_text():
    with open(os.path.join(HERE, "hashemi_ccc.h")) as f:
        return f.read()


def mega_params_numpy():
    """megaParams, from the compiled header's twin: the assumed values, in the kernel's order"""
    import hashemi_ccc as H
    return np.asarray(H.hk_megaParams(), dtype=np.float64).reshape(PRM_W)


def mega_dims_numpy():
    """the mount's three dimensions, HIS: `dHalf wFacet rCoil`.

    Not a table in this file - they are columns 2, 3 and 4 of the spec's own `traceParams` (the
    reflector's half-side, the mirror tile and the receiver coil's radius), the same triple the
    optics already take.  A caller with a DESIGNED machine passes that machine's instead, and
    then the mount and the rays fly the same build."""
    import hashemi_ccc as H
    return np.asarray(H.hk_traceParams(), dtype=np.float64).reshape(-1)[2:2 + DIM_W]


MSL_PRELUDE = """
#include <metal_stdlib>
using namespace metal;
#define HK_NO_STD
#define HK_ADDR thread
#define HK_RADDR device
#define hk_real float
#define HK_STATIC static inline
#define HK_LIT(x) ((float)(x))
#define HK_PI 3.14159265358979323846f
#define hk_sqrt(x) sqrt(fmax((x), 0.0f))
#define hk_sin sin
#define hk_cos cos
#define hk_tan tan
#define hk_atan atan
#define hk_acos(x) acos(fmin(fmax((x), -1.0f), 1.0f))
#define hk_asin(x) asin(fmin(fmax((x), -1.0f), 1.0f))
#define hk_exp exp
#define hk_log log
#define hk_fabs fabs
#define hk_floor floor
#define hk_tanh tanh
#define hk_min fmin
#define hk_max fmax
#define hk_eq(a, b) (hk_fabs((a) - (b)) <= 1e-5f * hk_max(1.0f, hk_max(hk_fabs(a), hk_fabs(b))))
"""

CUDA_PRELUDE = """
#define HK_NO_STD
#define HK_ADDR
#define HK_RADDR
#define hk_real float
#define HK_STATIC __device__ __forceinline__
#define HK_LIT(x) ((float)(x))
#define HK_PI 3.14159265358979323846f
#define hk_sqrt(x) sqrtf(fmaxf((x), 0.0f))
#define hk_sin sinf
#define hk_cos cosf
#define hk_tan tanf
#define hk_atan atanf
#define hk_acos(x) acosf(fminf(fmaxf((x), -1.0f), 1.0f))
#define hk_asin(x) asinf(fminf(fmaxf((x), -1.0f), 1.0f))
#define hk_exp expf
#define hk_log logf
#define hk_fabs fabsf
#define hk_floor floorf
#define hk_tanh tanhf
#define hk_min fminf
#define hk_max fmaxf
#define hk_eq(a, b) (hk_fabs((a) - (b)) <= 1e-5f * hk_max(1.0f, hk_max(hk_fabs(a), hk_fabs(b))))
"""


def _kernel_body():
    """the calls of the six functions, from the manifest: the same 20 arguments, each into its slice"""
    args = ("az, t, slack, om, od, dt, elSun, azSun, dni, rDrum, W, rcm, Tmax, rho, Fdrive, L10, rodLen, "
            "dHalf, wFacet, rCoil")
    calls = "\n".join(f"  {f['c']}({args}, row + {f['offset']});" for f in MEGA_FNS)
    return calls


def msl_source():
    body = _kernel_body()
    kernel = f"""
kernel void hashemi_mega(device float* st [[buffer(0)]], device const float* cmd [[buffer(1)]],
                         device const float* sun [[buffer(2)]], device const float* prm [[buffer(3)]],
                         device const float* dtb [[buffer(4)]], device float* out [[buffer(5)]],
                         device const int* nB [[buffer(6)]], device const float* dim [[buffer(7)]],
                         uint b [[thread_position_in_grid]]) {{
  if ((int)b >= nB[0]) return;
  const float az = st[b*{STATE_W}+0], t = st[b*{STATE_W}+1], slack = st[b*{STATE_W}+2];
  const float om = cmd[b*{CMD_W}+0], od = cmd[b*{CMD_W}+1];
  const float dt = dtb[0];
  const float elSun = sun[b*{SUN_W}+0], azSun = sun[b*{SUN_W}+1], dni = sun[b*{SUN_W}+2];
  const float rDrum = prm[b*{PRM_W}+0], W = prm[b*{PRM_W}+1], rcm = prm[b*{PRM_W}+2], Tmax = prm[b*{PRM_W}+3];
  const float rho = prm[b*{PRM_W}+4], Fdrive = prm[b*{PRM_W}+5], L10 = prm[b*{PRM_W}+6], rodLen = prm[b*{PRM_W}+7];
  const float dHalf = dim[b*{DIM_W}+0], wFacet = dim[b*{DIM_W}+1], rCoil = dim[b*{DIM_W}+2];
  float row[{N_COLS}];
{body}
  for (int k = 0; k < {N_COLS}; ++k) out[b*{N_COLS}+k] = row[k];
  st[b*{STATE_W}+0] = row[0]; st[b*{STATE_W}+1] = row[1]; st[b*{STATE_W}+2] = row[2];
}}
"""
    return MSL_PRELUDE + header_text() + kernel


def cuda_source():
    body = _kernel_body()
    kernel = f"""
extern "C" __global__ void hashemi_mega(float* st, const float* cmd, const float* sun, const float* prm,
                                        const float* dtb, float* out, const int* nB, const float* dim) {{
  const int b = blockIdx.x * blockDim.x + threadIdx.x;
  if (b >= nB[0]) return;
  const float az = st[b*{STATE_W}+0], t = st[b*{STATE_W}+1], slack = st[b*{STATE_W}+2];
  const float om = cmd[b*{CMD_W}+0], od = cmd[b*{CMD_W}+1];
  const float dt = dtb[0];
  const float elSun = sun[b*{SUN_W}+0], azSun = sun[b*{SUN_W}+1], dni = sun[b*{SUN_W}+2];
  const float rDrum = prm[b*{PRM_W}+0], W = prm[b*{PRM_W}+1], rcm = prm[b*{PRM_W}+2], Tmax = prm[b*{PRM_W}+3];
  const float rho = prm[b*{PRM_W}+4], Fdrive = prm[b*{PRM_W}+5], L10 = prm[b*{PRM_W}+6], rodLen = prm[b*{PRM_W}+7];
  const float dHalf = dim[b*{DIM_W}+0], wFacet = dim[b*{DIM_W}+1], rCoil = dim[b*{DIM_W}+2];
  float row[{N_COLS}];
{body}
  for (int k = 0; k < {N_COLS}; ++k) out[b*{N_COLS}+k] = row[k];
  st[b*{STATE_W}+0] = row[0]; st[b*{STATE_W}+1] = row[1]; st[b*{STATE_W}+2] = row[2];
}}
"""
    return CUDA_PRELUDE + header_text() + kernel


def mega_numpy(state, cmd, dt, sun, params, dims=None):
    """the row for every agent from the NumPy twin: state (B,3), cmd (B,2), sun (B,3),
    params (8,) or (B,8), dims (3,) or (B,3) - `dHalf wFacet rCoil`, his own when omitted"""
    import hashemi_ccc as H
    st = np.asarray(state, dtype=np.float64)
    cm = np.asarray(cmd, dtype=np.float64)
    su = np.asarray(sun, dtype=np.float64)
    B = st.shape[0]
    pr = np.broadcast_to(np.asarray(params, dtype=np.float64), (B, PRM_W))
    dm = np.broadcast_to(np.asarray(mega_dims_numpy() if dims is None else dims,
                                    dtype=np.float64), (B, DIM_W))
    args = ([st[:, 0], st[:, 1], st[:, 2], cm[:, 0], cm[:, 1], np.full(B, float(dt)),
             su[:, 0], su[:, 1], su[:, 2]] + [pr[:, k] for k in range(PRM_W)]
            + [dm[:, k] for k in range(DIM_W)])
    # the twin evaluates BOTH branches of every ite (the C does too); a dead
    # branch may go NaN, and pufferlib promotes RuntimeWarnings to errors
    with np.errstate(all="ignore"):
        parts = [np.asarray(getattr(H, f["c"])(*args), dtype=np.float64).reshape(B, f["n_out"]) for f in MEGA_FNS]
    return np.concatenate(parts, axis=1)


class HashemiMetal:
    """`hashemi_mega` as a Metal kernel, one thread per agent; the state tensor is updated in place"""

    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(msl_source())
        self._buf = {}

    def step(self, state, cmd, dt, sun, params, dims=None):
        """state (B,3) float32 mps, updated in place; cmd (B,2); sun (B,3); params (8,) or (B,8);
        dims (3,) or (B,3) - `dHalf wFacet rCoil`, his own when omitted; returns out (B,N_COLS)"""
        torch = self.torch
        B = state.shape[0]
        bufs = self._buf.get(B)
        if bufs is None:
            bufs = (torch.empty(B, N_COLS, dtype=torch.float32, device="mps"),
                    torch.tensor([B], dtype=torch.int32, device="mps"),
                    torch.empty(1, dtype=torch.float32, device="mps"))
            self._buf[B] = bufs
        out, nB, dtb = bufs
        dtb.fill_(float(dt))
        prm = params.to(torch.float32)
        if prm.dim() == 1:
            prm = prm.unsqueeze(0).expand(B, PRM_W)
        dm = dims.to(torch.float32) if torch.is_tensor(dims) else torch.as_tensor(
            np.asarray(mega_dims_numpy() if dims is None else dims, dtype=np.float32), device=state.device)
        if dm.dim() == 1:
            dm = dm.unsqueeze(0).expand(B, DIM_W)
        self.lib.hashemi_mega(state, cmd.to(torch.float32).contiguous(), sun.to(torch.float32).contiguous(),
                              prm.contiguous(), dtb, out, nB, dm.contiguous())
        return out


if __name__ == "__main__":
    import sys
    rng = np.random.default_rng(3)
    B = 4096
    prm = mega_params_numpy()
    tdead = 1.076                                   # his dead point, 61.7 deg
    state = np.stack([rng.uniform(0, 2 * np.pi, B), rng.uniform(0.0, tdead, B), rng.uniform(0, 0.05, B) * (rng.random(B) < 0.3)], axis=1)
    cmd = np.stack([rng.uniform(-2, 2, B), rng.uniform(-0.5, 0.5, B)], axis=1)
    # the sun within 15 deg of where the dish faces: the tracker's range (at random skies the row holds
    # tan of a right angle, where single precision has no meaning to compare)
    sun = np.stack([np.clip(np.pi / 2 - state[:, 1] + rng.uniform(-0.25, 0.25, B), 0.05, 1.5),
                    state[:, 0] + rng.uniform(-0.25, 0.25, B), rng.uniform(600, 1000, B)], axis=1)
    dt = 15.0
    ref = mega_numpy(state, cmd, dt, sun, prm)
    try:
        import torch
        k = HashemiMetal()
        st = torch.tensor(state, dtype=torch.float32, device="mps")
        out = k.step(st, torch.tensor(cmd, dtype=torch.float32, device="mps"), dt,
                     torch.tensor(sun, dtype=torch.float32, device="mps"),
                     torch.tensor(prm, dtype=torch.float32, device="mps")).cpu().numpy().astype(np.float64)
    except Exception as e:
        print("Metal unavailable:", e); sys.exit(2)
    err = np.abs(out - ref) / np.maximum(1.0, np.abs(ref))
    worst = err.max(axis=0)
    # boolean columns (the requirements and the theorem statements) can flip at an exact boundary
    # in single precision (an equation, `<=` at its equality case): count the flips, allow a few
    is_bool = np.all((ref == 0) | (ref == 1), axis=0)
    flips = (np.abs(out - ref) > 0.5).mean(axis=0)
    # the capture and the power carry an arccos at the lens boundary: 1e-2 in single precision
    tol = {"capture": 1e-2, "power_W": 1e-2}
    bad_real = [(COLUMNS[i], float(worst[i])) for i in range(N_COLS)
                if not is_bool[i] and worst[i] >= tol.get(COLUMNS[i], 1e-3)]
    bad_bool = [(COLUMNS[i], float(flips[i])) for i in range(N_COLS) if is_bool[i] and flips[i] > 0.005]
    order = np.argsort(-worst)[:8]
    for i in order:
        print(f"{COLUMNS[i]:26s} max rel err {worst[i]:.2e}" + (f"  (bool, flips {100 * flips[i]:.2f} %)" if is_bool[i] else ""))
    bad = bad_real + bad_bool
    print(("METAL == NUMPY" if not bad else f"MISMATCH in {len(bad)} columns: {bad[:10]}"), "over", B, "agents,", N_COLS, "columns")
    sys.exit(0 if not bad else 1)

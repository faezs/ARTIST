"""The env's step with the hyperboloid beam-down, as ONE Metal kernel (HashemiBeamdown.lean).

The coil at F is replaced by a hyperboloidal secondary inside the coil's envelope: far focus F,
near focus F2 = F + L u below, vertex dm from F, cap radius rm; the return beam crosses the dish
through the slot (width slotW along the sun side) into the tunnel mouth of radius rt. Design
parameters: L, dm, rm, rt, slotW, beta (the axis's tilt toward the tube).

    .venv/bin/python hashemi_beam_kernel.py         # Metal == NumPy; the chain at noon for a few shapes
"""
import json
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
from hashemi_kernel import MSL_PRELUDE, header_text, mega_params_numpy    # noqa: E402
from hashemi_trace_kernel import trace_params_numpy, SUN_HALF_ANGLE       # noqa: E402
from hashemi_env_kernel import draws, DISH_K, SLOPE_ERR, SPEC_ERR          # noqa: E402

BEAM = json.load(open(os.path.join(HERE, "hashemi_beam.json")))
BCOL = {n: i for i, n in enumerate(BEAM["columns"])}
BIN = {n: i for i, n in enumerate(BEAM["inputs"])}
N_IN, N_OUT, P = len(BEAM["inputs"]), int(BEAM["n_columns"]), int(BEAM["rays"])

# the receiver's design: F2 at the bar 1.25 m below F, the vertex 6 cm from F (the cone is 12 cm
# there), the cap the coil's 6 cm, a mouth of 0.55 m (the tandoor's duct), the slot 6 cm, no tilt
DESIGN = dict(L=1.25, dm=0.06, rm=0.06, rt=0.55, slotW=0.06, beta=0.0)


def beam_source():
    with open(os.path.join(HERE, "hashemi_beam.metal")) as f:
        ker = f.read()
    return MSL_PRELUDE + header_text() + ker


def beam_params(design=None):
    mp = mega_params_numpy(); tp = trace_params_numpy(); d = dict(DESIGN); d.update(design or {})
    prm = dict(rDrum=mp[0], W=mp[1], rcm=mp[2], Tmax=mp[3], rho=mp[4], Fdrive=mp[5], L10=mp[6], rodLen=mp[7],
               R=tp[0], f=tp[1], a=tp[2], w=tp[3], rc=tp[4], k=DISH_K, sigmaslope=SLOPE_ERR, sigmaspec=SPEC_ERR,
               hsun=SUN_HALF_ANGLE)
    prm.update(d)
    return prm


def pack_beam(B, state, cmd, dt, sun, soil, design=None):
    prm = beam_params(design)
    x = np.zeros((B, N_IN))
    for k, v in prm.items():
        if k in BIN:
            x[:, BIN[k]] = v
    x[:, BIN["az"]], x[:, BIN["t"]], x[:, BIN["slack"]] = state[:, 0], state[:, 1], state[:, 2]
    x[:, BIN["omegam"]], x[:, BIN["omegad"]] = cmd[:, 0], cmd[:, 1]
    x[:, BIN["dt"]] = dt
    x[:, BIN["elSun"]], x[:, BIN["azSun"]], x[:, BIN["dni"]] = sun[:, 0], sun[:, 1], sun[:, 2]
    x[:, BIN["soil"]] = soil
    return x


def beam_numpy(x, dr):
    import hashemi_ccc as H
    with np.errstate(all="ignore"):
        return np.asarray(H.hk_hashemiEnvBeam(*[x[:, k] for k in range(N_IN)], dr), dtype=np.float64).reshape(x.shape[0], N_OUT)


class HashemiBeamMetal:
    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(beam_source())
        self._buf = {}

    def step(self, x, dr):
        torch = self.torch
        B = x.shape[0]
        bufs = self._buf.get(B)
        if bufs is None:
            bufs = (torch.empty(B, N_OUT, dtype=torch.float32, device="mps"), torch.tensor([B], dtype=torch.int32, device="mps"))
            self._buf[B] = bufs
        out, nB = bufs
        self.lib.hashemi_beam(x.contiguous(), dr.contiguous(), out, nB, threads=B * P, group_size=P)
        return out


def aimed_rows(B, rng, el, design=None, t_dead=1.077):
    """B agents pointed at a sun of elevation `el` (rad): the dish's tilt from the zenith, the sun in
    the dish's frame dead ahead"""
    t = min(max(math.pi / 2 - el, 0.0), t_dead)
    state = np.stack([np.full(B, 1.0), np.full(B, t), np.zeros(B)], 1)
    sun = np.stack([np.full(B, el), np.full(B, 1.0), np.full(B, 800.0)], 1)
    return pack_beam(B, state, np.zeros((B, 2)), 15.0, sun, np.full(B, 0.95), design)


if __name__ == "__main__":
    import time
    import torch
    rng = np.random.default_rng(5)
    B = 1024
    el = math.radians(60.0)
    x = aimed_rows(B, rng, el)
    dr = draws(rng, B)
    ref = beam_numpy(x, dr)
    k = HashemiBeamMetal()
    f32 = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32), device="mps")
    out = k.step(f32(x), f32(dr)).cpu().numpy().astype(np.float64)
    torch.mps.synchronize(); t0 = time.perf_counter()
    for _ in range(20):
        k.step(f32(x), f32(dr))
    torch.mps.synchronize(); ms = (time.perf_counter() - t0) / 20 * 1e3
    print(f"hashemi_beam: {N_OUT} columns, {BEAM['n_nodes']} nodes; {ms:.2f} ms/step at B={B}")
    bad = 0
    for j, name in enumerate(BEAM["columns"]):
        a, b = out[:, j], ref[:, j]
        fin = np.isfinite(a) & np.isfinite(b)
        if name in ("stalled", "taut", "wire_holds", "sun_reachable", "lost_sun", "obs_taut", "obs_holds"):
            if np.mean(a[fin] != b[fin]) > 0.01:
                bad += 1
        else:
            if name in ("obs_e_az",):
                a = np.where(fin, ((a - b + np.pi) % (2 * np.pi)) - np.pi + b, a)
            err = np.max(np.abs(a[fin] - b[fin]) / np.maximum(1.0, np.abs(b[fin]))) if fin.any() else 0.0
            tol = 2e-2 if name in ("capture", "hit_secondary", "passes_dish", "per_dni", "p_in", "spot") else 2e-3
            if err > tol:
                bad += 1
                print(f"  mismatch {name}: {err:.2e}")
    print("METAL == NUMPY over the beam-down step" if bad == 0 else f"MISMATCH in {bad} columns")
    print(f"  the chain at 60 deg sun, the default shape: hit secondary {out[:, BCOL['hit_secondary']].mean():.3f}, passed the dish {out[:, BCOL['passes_dish']].mean():.3f},"
          f" captured {out[:, BCOL['capture']].mean():.3f}, spot at F2 {out[:, BCOL['spot']].mean():.3f} m, p_in {out[:, BCOL['p_in']].mean():.0f} W")
    for des in (dict(slotW=0.06), dict(slotW=0.2), dict(slotW=0.6), dict(rm=0.15, dm=0.15), dict(rm=0.30, dm=0.30)):
        xd = aimed_rows(B, rng, el, des)
        o = beam_numpy(xd, dr)
        print(f"  design {des}: hit {o[:, BCOL['hit_secondary']].mean():.3f} passed {o[:, BCOL['passes_dish']].mean():.3f} captured {o[:, BCOL['capture']].mean():.3f} spot {o[:, BCOL['spot']].mean():.3f} m")
    sys.exit(0 if bad == 0 else 1)

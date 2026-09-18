"""The env's step as ONE Metal kernel, extracted by Ccc from HashemiEnv.lean.

`hashemiEnv` composes the mount (`megaStep`), the optics on the new pose (64 rays of `dishPower`,
their sum the reduction) and the heat (`heatStep`: the coil, the oil, the pipes, the pot). The
driver printed it three ways from one graph: `hk_hashemiEnv` in C (the rays as a loop; the NumPy
twin vectorises it), and `hashemi_env` in Metal - a threadgroup per agent, a thread per ray, the
two sums through threadgroup memory. This module runs both and checks them against each other.

    .venv/bin/python hashemi_env_kernel.py        # Metal == NumPy over the env's step
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
from hashemi_kernel import MSL_PRELUDE, header_text, mega_params_numpy   # noqa: E402
from hashemi_trace_kernel import trace_params_numpy, SUN_HALF_ANGLE      # noqa: E402

ENV = json.load(open(os.path.join(HERE, "hashemi_env.json")))
ECOL = {n: i for i, n in enumerate(ENV["columns"])}
EIN = {n: i for i, n in enumerate(ENV["inputs"])}
N_IN, N_OUT, P = len(ENV["inputs"]), int(ENV["n_columns"]), int(ENV["rays"])
TABLES = ENV["arrays"]                                 # the kernel's buffer order: hist, ret, dr
M = int([a for a in TABLES if a["name"] == "dr"][0]["m"])
N_HIST = int([a for a in TABLES if a["name"] == "hist"][0]["P"])
HIST_COLS = [ECOL[f"hist_{k}"] for k in range(N_HIST)]
RET_COLS = [ECOL[f"ret_{k}"] for k in range(N_HIST)]

# the loop's parameters (HashemiHeat.lean / HashemiField.lean): alpha eps Ac hC Upipe UAx, and the
# flow's mcp = 0.02 kg/s x 2100 J/kgK (the pipe's Green's function e^{-Upipe/mcp} lives on it)
HEAT_PARAMS = np.array([0.9, 0.8, 0.03, 15.0, 0.92, 15.0])
MCP = 0.02 * 2100.0
DISH_K, SLOPE_ERR, SPEC_ERR = -1.0, 2e-3, 1e-3


def env_source():
    with open(os.path.join(HERE, "hashemi_env.metal")) as f:
        ker = f.read()
    return MSL_PRELUDE + header_text() + ker


def env_params():
    """the constant inputs, by name: the machine's, the optics', the heat's"""
    mp = mega_params_numpy()                      # rDrum W rcm Tmax rho Fdrive L10 rodLen
    tp = trace_params_numpy()                     # R f a w rc
    d = dict(rDrum=mp[0], W=mp[1], rcm=mp[2], Tmax=mp[3], rho=mp[4], Fdrive=mp[5], L10=mp[6], rodLen=mp[7],
             R=tp[0], f=tp[1], a=tp[2], w=tp[3], rc=tp[4], k=DISH_K, sigmaslope=SLOPE_ERR, sigmaspec=SPEC_ERR,
             hsun=SUN_HALF_ANGLE, alpha=HEAT_PARAMS[0], eps=HEAT_PARAMS[1], Ac=HEAT_PARAMS[2], hC=HEAT_PARAMS[3],
             Upipe=HEAT_PARAMS[4], UAx=HEAT_PARAMS[5], mcp=MCP)
    return d


def pack(B, state, cmd, dt, sun, soil, twall, ta, params=None):
    """the (B, n_in) input rows: state (B,3) az t slack; cmd (B,2) omega_m omega_d; sun (B,3) el az dni;
    the oil's state is not here - it is the two histories along the pipe (tables)"""
    prm = env_params() if params is None else params
    x = np.zeros((B, N_IN))
    for k, v in prm.items():
        x[:, EIN[k]] = v
    x[:, EIN["az"]], x[:, EIN["t"]], x[:, EIN["slack"]] = state[:, 0], state[:, 1], state[:, 2]
    x[:, EIN["omegam"]], x[:, EIN["omegad"]] = cmd[:, 0], cmd[:, 1]
    x[:, EIN["dt"]] = dt
    x[:, EIN["elSun"]], x[:, EIN["azSun"]], x[:, EIN["dni"]] = sun[:, 0], sun[:, 1], sun[:, 2]
    x[:, EIN["soil"]], x[:, EIN["Twall"]], x[:, EIN["Ta"]] = soil, twall, ta
    return x


def draws(rng, B):
    """the ray table: six uniforms and four normals per ray"""
    return np.concatenate([rng.random((B, P, 6)), rng.standard_normal((B, P, 4))], axis=2)


def env_numpy(x, hist, ret, dr):
    """the NumPy twin of the same graph: x (B, n_in), hist/ret (B, 16), dr (B, P, m) -> (B, n_out)"""
    import hashemi_ccc as H
    with np.errstate(all="ignore"):
        return np.asarray(H.hk_hashemiEnv(*[x[:, k] for k in range(N_IN)], hist, ret, dr), dtype=np.float64).reshape(x.shape[0], N_OUT)


class HashemiEnvMetal:
    """the megakernel: one launch per step"""

    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(env_source())
        self._buf = {}

    def step(self, x, hist, ret, dr):
        """x (B, n_in), hist/ret (B, 16), dr (B, P, m) float32 mps -> out (B, n_out) float32 mps"""
        torch = self.torch
        B = x.shape[0]
        bufs = self._buf.get(B)
        if bufs is None:
            bufs = (torch.empty(B, N_OUT, dtype=torch.float32, device="mps"),
                    torch.tensor([B], dtype=torch.int32, device="mps"))
            self._buf[B] = bufs
        out, nB = bufs
        self.lib.hashemi_env(x.contiguous(), hist.contiguous(), ret.contiguous(), dr.contiguous(), out, nB,
                             threads=B * P, group_size=P)
        return out


if __name__ == "__main__":
    import time
    import torch
    rng = np.random.default_rng(11)
    B = 2048
    tdead = 1.077
    state = np.stack([rng.uniform(0, 2 * np.pi, B), rng.uniform(0.0, tdead, B), rng.uniform(0, 0.05, B) * (rng.random(B) < 0.3)], 1)
    cmd = np.stack([rng.uniform(-2, 2, B), rng.uniform(-0.5, 0.5, B)], 1)
    # the sun within 15 deg of where the dish faces (the tracker's range), the rest of the sky is a right angle for float32
    el = np.pi / 2 - state[:, 1] + rng.uniform(-0.26, 0.26, B)
    sun = np.stack([np.clip(el, 0.05, 1.5), state[:, 0] + rng.uniform(-0.26, 0.26, B), rng.uniform(300, 1000, B)], 1)
    x = pack(B, state, cmd, 15.0, sun, rng.uniform(0.8, 1.0, B), rng.uniform(300, 500, B), 300.0)
    dr = draws(rng, B)
    hist = rng.uniform(300, 550, (B, N_HIST)); ret = rng.uniform(300, 500, (B, N_HIST))
    ref = env_numpy(x, hist, ret, dr)
    k = HashemiEnvMetal()
    f32 = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32), device="mps")
    xt, ht, rt, drt = f32(x), f32(hist), f32(ret), f32(dr)
    out = k.step(xt, ht, rt, drt).cpu().numpy().astype(np.float64)
    torch.mps.synchronize(); t0 = time.perf_counter()
    for _ in range(20):
        k.step(xt, ht, rt, drt)
    torch.mps.synchronize(); ms = (time.perf_counter() - t0) / 20 * 1e3
    print(f"hashemi_env: {N_OUT} columns, {P} rays/agent, {ENV['n_nodes']} nodes; {ms:.2f} ms/step at B={B} ({ms / B * 1e6:.0f} ns/agent)")
    worst = []
    bad = 0
    for j, name in enumerate(ENV["columns"]):
        a, b = out[:, j], ref[:, j]
        fin = np.isfinite(a) & np.isfinite(b)
        if name in ("stalled", "taut", "wire_holds", "sun_reachable", "lost_sun", "obs_taut", "obs_holds"):
            flips = float(np.mean(a[fin] != b[fin]))
            worst.append((name, flips, "flips"))
            if flips > 0.01:
                bad += 1
        else:
            if name in ("obs_e_az", "e_az"):
                a = np.where(fin, ((a - b + np.pi) % (2 * np.pi)) - np.pi + b, a)   # a wrapped angle: modulo 2 pi
            scale = np.maximum(1.0, np.abs(b[fin]))
            tol = 1e-2 if (name in ("capture", "capture_s", "per_dni", "p_in", "q_abs", "q_pot", "q_net", "q_coil_loss", "q_pipe", "T_oil", "obs_oil")
                           or name.startswith(("flux_", "coil_"))) else 1e-3
            err = float(np.max(np.abs(a[fin] - b[fin]) / scale)) if fin.any() else 0.0
            worst.append((name, err, "rel"))
            if err > tol:
                bad += 1
    for name, e, kind in sorted(worst, key=lambda r: -r[1])[:8]:
        print(f"  {name:<16} {kind} {e:.2e}")
    print(f"  capture mean {out[:, ECOL['capture']].mean():.3f}, p_in mean {out[:, ECOL['p_in']].mean():.0f} W, q_pot mean {out[:, ECOL['q_pot']].mean():.0f} W, T_out mean {out[:, ECOL['T_oil']].mean():.1f} K")
    fl = out[:, [ECOL[f'flux_{j}'] for j in range(8)]].mean(0); print("  flux bins (W, mean): " + " ".join(f"{v:.0f}" for v in fl) + f"  sum {fl.sum():.0f} vs p_in x alpha? p_in {out[:, ECOL['p_in']].mean():.0f}")
    print("  hist head == T_out:", bool(np.allclose(out[:, ECOL['hist_0']], out[:, ECOL['T_oil']])))
    print("METAL == NUMPY over the env's step" if bad == 0 else f"MISMATCH in {bad} columns")
    sys.exit(0 if bad == 0 else 1)

"""The closed loop as ONE Metal kernel, extracted by Ccc from HashemiPolicy.lean.

`hashemiLoop` composes the machine's observation (`obsOf`), a policy of the spec's interface
(`mlpPolicy`, its weights shared tables), the two drives, and the env's step (`hashemiEnv`).
The manifest `hashemi_policy.json` is the policy description the spec fixes: the eight
observations, the two commands, the head levels, the loop's 37 columns.

    .venv/bin/python hashemi_loop_kernel.py     # Metal == NumPy over the loop; the follower vs a random policy
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
from hashemi_kernel import MSL_PRELUDE, header_text   # noqa: E402
from hashemi_env_kernel import env_params, draws, P as RAYS, N_HIST  # noqa: E402

POL = json.load(open(os.path.join(HERE, "hashemi_policy.json")))
LCOL = {n: i for i, n in enumerate(POL["columns"])}
LIN = {n: i for i, n in enumerate(POL["inputs"])}
N_IN, N_OUT = len(POL["inputs"]), int(POL["n_columns"])
TABLES = POL["arrays"]                  # in the kernel's buffer order


def loop_source():
    with open(os.path.join(HERE, "hashemi_loop.metal")) as f:
        ker = f.read()
    return MSL_PRELUDE + header_text() + ker


def weights_random(rng, scale=0.3):
    """W1 (16,8), b1 (16,), W2 (2,16), b2 (2,): a random policy of the interface"""
    return dict(W1=rng.normal(0, scale, (16, 8)), b1=rng.normal(0, scale, 16),
                W2=rng.normal(0, scale, (2, 16)), b2=rng.normal(0, scale, 2))


def weights_follower(gain=109.0):
    """the follower, as a policy of the interface: u_az ~ tanh(gain e_az), u_el ~ tanh(gain e_el),
    through one hidden unit each (tanh(x) ~ x near 0)"""
    W1 = np.zeros((16, 8)); b1 = np.zeros(16); W2 = np.zeros((2, 16)); b2 = np.zeros(2)
    W1[0, 0] = gain; W2[0, 0] = 1.0        # e_az -> u_az
    W1[1, 1] = gain; W2[1, 1] = 1.0        # e_el -> u_el (positive: too high -> pay out)
    return dict(W1=W1, b1=b1, W2=W2, b2=b2)


def pack_loop(B, state, dt, sun, soil, twall, ta, taut, holds, tdead, b2, params=None):
    prm = env_params() if params is None else params
    x = np.zeros((B, N_IN))
    for k, v in prm.items():
        if k in LIN:
            x[:, LIN[k]] = v
    x[:, LIN["az"]], x[:, LIN["t"]], x[:, LIN["slack"]] = state[:, 0], state[:, 1], state[:, 2]
    x[:, LIN["dt"]] = dt
    x[:, LIN["elSun"]], x[:, LIN["azSun"]], x[:, LIN["dni"]] = sun[:, 0], sun[:, 1], sun[:, 2]
    x[:, LIN["soil"]], x[:, LIN["Twall"]], x[:, LIN["Ta"]] = soil, twall, ta
    x[:, LIN["tautPrev"]], x[:, LIN["holdsPrev"]], x[:, LIN["tDead"]] = taut, holds, tdead
    x[:, LIN["b2_0"]], x[:, LIN["b2_1"]] = b2[0], b2[1]
    return x


def loop_numpy(x, W, hist, ret, dr):
    import hashemi_ccc as H
    B = x.shape[0]
    tabs = [W["W1"], W["b1"], W["W2"], hist, ret, dr]   # the manifest's order: W1 b1 W2 hist ret dr
    with np.errstate(all="ignore"):
        return np.asarray(H.hk_hashemiLoop(*[x[:, k] for k in range(N_IN)], *tabs), dtype=np.float64).reshape(B, N_OUT)


class HashemiLoopMetal:
    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(loop_source())
        self._buf = {}

    def step(self, x, W1, b1, W2, hist, ret, dr):
        torch = self.torch
        B = x.shape[0]
        bufs = self._buf.get(B)
        if bufs is None:
            bufs = (torch.empty(B, N_OUT, dtype=torch.float32, device="mps"),
                    torch.tensor([B], dtype=torch.int32, device="mps"))
            self._buf[B] = bufs
        out, nB = bufs
        self.lib.hashemi_loop(x.contiguous(), W1.contiguous(), b1.contiguous(), W2.contiguous(),
                              hist.contiguous(), ret.contiguous(), dr.contiguous(), out, nB, threads=B * RAYS, group_size=RAYS)
        return out


if __name__ == "__main__":
    import time
    import torch
    rng = np.random.default_rng(3)
    B = 1024
    tdead = 1.077
    state = np.stack([rng.uniform(0, 2 * np.pi, B), rng.uniform(0.3, 1.0, B), np.zeros(B)], 1)
    el = np.clip(np.pi / 2 - state[:, 1] + rng.uniform(-0.05, 0.05, B), 0.5, 1.5)
    sun = np.stack([el, state[:, 0] + rng.uniform(-0.05, 0.05, B), np.full(B, 800.0)], 1)
    W = weights_random(rng)
    x = pack_loop(B, state, 15.0, sun, np.full(B, 0.95), rng.uniform(350, 450, B), 300.0,
                  np.ones(B), np.ones(B), tdead, W["b2"])
    dr = draws(rng, B)
    hist = rng.uniform(300, 500, (B, N_HIST)); ret = rng.uniform(300, 450, (B, N_HIST))
    ref = loop_numpy(x, W, hist, ret, dr)
    k = HashemiLoopMetal()
    f32 = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32), device="mps")
    args = (f32(x), f32(W["W1"]), f32(W["b1"]), f32(W["W2"]), f32(hist), f32(ret), f32(dr))
    out = k.step(*args).cpu().numpy().astype(np.float64)
    torch.mps.synchronize(); t0 = time.perf_counter()
    for _ in range(20):
        k.step(*args)
    torch.mps.synchronize(); ms = (time.perf_counter() - t0) / 20 * 1e3
    print(f"hashemi_loop: {N_OUT} columns, {POL['n_nodes']} nodes; {ms:.2f} ms/step at B={B}")
    bad = 0
    for j, name in enumerate(POL["columns"]):
        a, b = out[:, j], ref[:, j]
        fin = np.isfinite(a) & np.isfinite(b)
        if name in ("stalled", "taut", "wire_holds", "sun_reachable", "lost_sun", "taut_obs", "holds_obs", "obs_taut", "obs_holds"):
            if np.mean(a[fin] != b[fin]) > 0.01:
                bad += 1
        else:
            if name in ("obs_e_az", "e_az"):
                a = np.where(fin, ((a - b + np.pi) % (2 * np.pi)) - np.pi + b, a)   # a wrapped angle: modulo 2 pi
            err = np.max(np.abs(a[fin] - b[fin]) / np.maximum(1.0, np.abs(b[fin]))) if fin.any() else 0.0
            tol = 1e-2 if (name in ("capture", "capture_s", "per_dni", "p_in", "q_abs", "q_pot", "q_net", "q_coil_loss", "q_pipe", "T_oil", "obs_oil", "oil", "e_az")
                           or name.startswith(("flux_", "coil_"))) else 2e-3
            if err > tol:
                bad += 1
                print(f"  mismatch {name}: {err:.2e}")
    print("METAL == NUMPY over the closed loop" if bad == 0 else f"MISMATCH in {bad} columns")
    # the follower as a policy of the interface: errors within one step's move (azFull x dt =
    # 0.0092 rad) are zeroed by theorem (follower_step_az/el); through tanh at gain 1/(rate dt)
    # the linear regime does most of it in one step
    Wf = weights_follower()
    sunf = np.stack([np.clip(np.pi / 2 - state[:, 1] + rng.uniform(-0.004, 0.004, B), 0.5, 1.5),
                     state[:, 0] + rng.uniform(-0.004, 0.004, B), np.full(B, 800.0)], 1)
    xf = pack_loop(B, state, 15.0, sunf, np.full(B, 0.95), np.full(B, 400.0), 300.0,
                   np.ones(B), np.ones(B), tdead, Wf["b2"])
    h0 = np.full((B, N_HIST), 400.0)
    o1 = loop_numpy(xf, Wf, h0, h0, dr)
    e_az0, e_el0 = o1[:, LCOL["e_az"]], o1[:, LCOL["e_el"]]
    st1 = o1[:, [LCOL["az_next"], LCOL["t_next"], LCOL["slack_next"]]]
    x2 = pack_loop(B, st1, 15.0, sunf, np.full(B, 0.95), np.full(B, 400.0), 300.0,
                   o1[:, LCOL["taut"]], o1[:, LCOL["wire_holds"]], tdead, Wf["b2"])
    o2 = loop_numpy(x2, Wf, h0, h0, dr)
    e_az1, e_el1 = o2[:, LCOL["e_az"]], o2[:, LCOL["e_el"]]
    print(f"  follower policy: |e_az| {np.mean(np.abs(e_az0)):.4f} -> {np.mean(np.abs(e_az1)):.4f} rad, |e_el| {np.mean(np.abs(e_el0)):.4f} -> {np.mean(np.abs(e_el1)):.4f} rad after one step (commands u {np.mean(np.abs(o1[:, LCOL['u_az']])):.2f}, {np.mean(np.abs(o1[:, LCOL['u_el']])):.2f})")
    sys.exit(0 if bad == 0 else 1)

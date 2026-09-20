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

# THE LOOP'S PARAMETERS (HashemiOil.lean; every one of them is an INPUT of the compiled kernel,
# and every one of them has a source in that file's docstrings).  The fluid is Therminol 66; the
# hardware the video shows is a copper spiral coil and insulated copper pipe, and the bore, the
# run, the insulation, the pump and the exchanger's area are THIS FILE'S choices, not readings of
# his machine.  See README.md "## The oil loop, realistically" for the table and the sources.
LOOP_PARAMS = dict(
    alpha=0.9,        # the coil's absorptance (a blackened copper spiral)
    eps=0.8,          # its emissivity
    Ac=0.03,          # the coil's wetted surface, m2: 8 turns of 10 mm tube on a 12 cm spiral
    Qmax=6.0e-5,      # the pump at full command, m3/s (0.054 kg/s of oil at 900 kg/m3)
    Dp=0.012,         # the bore of the run, m (12 mm copper)
    Lp=6.0,           # the run, m (down the post, along the carriage, to the pot and back)
    Dins=0.062,       # over the insulation, m (25 mm of mineral wool on a 12 mm pipe)
    kIns=0.045,       # mineral wool at temperature, W/mK
    etaP=0.25,        # the pump's wire-to-water efficiency
    Pidle=8.0,        # the pump motor's standing draw, W - ABOVE HIS 5 W PANEL (see the README)
    Axch=0.20,        # the exchanger's area in the pot's wall band, m2
    # the wall-side ceiling on the exchanger's conductance, W/K - NOT a constant any more:
    # `uaExch` (HashemiOil.lean) is the buried-cylinder shape factor for the coil the spec places
    # in the liner (Tandoor.exchangerPt, 6.3 cm behind the baking face), printed like every other
    # law. The 60.0 that stood here had no law anywhere and the audit measured it binding on
    # 99.9 % of a day's steps, so the whole Reynolds/Nusselt chain sat under a ceiling that always
    # won and the machine's reported output rested on it. k = 0.25 W/mK is the ini's own
    # insulating firebrick (tandoor_rl_env.py:74); the coil's length and bore come from the
    # designed machine (hashemi_machine_<a>.json: coilLen, Dc).
    UAxMax=None,      # filled by env_params() from `uaExch`, the spec's own law (see exch_ua)
    Ccoil=216.0,      # the coil's own inventory, J/K: 0.068 kg of oil + 0.19 kg of copper tube
    degA=5.73e8,      # the Arrhenius pre-exponential, 1/s (normalised, see HashemiOil.lean)
    degEa=190000.0,   # the activation energy, J/mol (an order of magnitude, not a datasheet)
)
# the reward's prices for the two new costs (HashemiReward.lean pumpCostRaw / degCostRaw)
PUMP_PRICE = 1.0        # an electrical joule priced as the shaping prices a thermal one
DEG_PRICE = 5.0e-7      # rotis' reward per K s over the film limit: ~1 roti for a day 50 K over
# THE FIGURE IS NOT FREE, AND IT WAS PINNED AT THE FAVOURABLE END. `conicZ` carries the spec's
# homotopy k in [-1, 0]: -1 is a paraboloid, which focuses a parallel beam to a point, and 0 is a
# sphere, which does not (OpticsSphere.no_single_focus, caustic_fills, bestFocus). His form is a
# SPHERE - the file's own sag, screw length and FH are `TandoorSphere` of `dishR` - and he sweeps
# it with a curved rod on a spherical jig. This constant said -1 anyway, so every capture number
# was a paraboloid's. `dish_k` is the env's knob now; DISH_K is its default, his own figure.
DISH_K, SLOPE_ERR, SPEC_ERR = 0.0, 2e-3, 1e-3


def env_source():
    with open(os.path.join(HERE, "hashemi_env.metal")) as f:
        ker = f.read()
    return MSL_PRELUDE + header_text() + ker


K_LINER = 0.25          # W/mK, the ini's insulating firebrick (tandoor_rl_env.py:74)
D_STANDOFF = 0.063      # m, the coil behind the baking face (Tandoor.exchangerPt)


def exch_ua(machine=None, k_liner=K_LINER, d=D_STANDOFF):
    """the exchanger's conductance from the spec's own law, never a host constant"""
    import json, os
    import hashemi_ccc as H
    if machine is None:
        machine = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                               "hashemi_machine_0.8_designed.json")
    m = json.load(open(machine))
    m = m.get("machine", m)
    return float(H.hk_uaExch(k_liner, float(m["coilLen"]), float(m["Dc"]), d))


def env_params():
    """the constant inputs, by name: the machine's, the optics', the heat's"""
    mp = mega_params_numpy()                      # rDrum W rcm Tmax rho Fdrive L10 rodLen
    tp = trace_params_numpy()                     # R f a w rc
    d = dict(rDrum=mp[0], W=mp[1], rcm=mp[2], Tmax=mp[3], rho=mp[4], Fdrive=mp[5], L10=mp[6], rodLen=mp[7],
             R=tp[0], f=tp[1], a=tp[2], w=tp[3], rc=tp[4], k=DISH_K, sigmaslope=SLOPE_ERR, sigmaspec=SPEC_ERR,
             hsun=SUN_HALF_ANGLE, **LOOP_PARAMS)
    if d.get("UAxMax") is None:
        d["UAxMax"] = exch_ua()
    return d


def pack(B, state, cmd, dt, sun, soil, twall, ta, params=None, u_pump=1.0, wind=0.0, deg=0.0):
    """the (B, n_in) input rows: state (B,3) az t slack; cmd (B,2) omega_m omega_d; sun (B,3) el az dni;
    `u_pump` is the pump's command in [0,1] (the parent's head 0 through `pumpOf`), `wind` the hour's
    wind in m/s and `deg` the damage carried from the last step.  The oil's temperatures are not here -
    they are the two histories along the pipe (tables)."""
    prm = env_params() if params is None else params
    x = np.zeros((B, N_IN))
    for k, v in prm.items():
        x[:, EIN[k]] = v
    x[:, EIN["az"]], x[:, EIN["t"]], x[:, EIN["slack"]] = state[:, 0], state[:, 1], state[:, 2]
    x[:, EIN["omegam"]], x[:, EIN["omegad"]] = cmd[:, 0], cmd[:, 1]
    x[:, EIN["dt"]] = dt
    x[:, EIN["elSun"]], x[:, EIN["azSun"]], x[:, EIN["dni"]] = sun[:, 0], sun[:, 1], sun[:, 2]
    x[:, EIN["soil"]], x[:, EIN["Twall"]], x[:, EIN["Ta"]] = soil, twall, ta
    x[:, EIN["uPump"]], x[:, EIN["Vw"]], x[:, EIN["degPrev"]] = u_pump, wind, deg
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
    x = pack(B, state, cmd, 15.0, sun, rng.uniform(0.8, 1.0, B), rng.uniform(300, 500, B), 300.0,
             u_pump=rng.integers(0, 7, B) / 6.0, wind=rng.uniform(0.0, 8.0, B), deg=rng.random(B) * 0.1)
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
        if name in ("stalled", "taut", "wire_holds", "sun_reachable", "lost_sun", "obs_taut", "obs_holds", "fault"):
            flips = float(np.mean(a[fin] != b[fin]))
            worst.append((name, flips, "flips"))
            if flips > 0.01:
                bad += 1
        else:
            if name in ("obs_e_az", "e_az"):
                a = np.where(fin, ((a - b + np.pi) % (2 * np.pi)) - np.pi + b, a)   # a wrapped angle: modulo 2 pi
            scale = np.maximum(1.0, np.abs(b[fin]))
            tol = 1e-2 if (name in ("capture", "capture_s", "per_dni", "p_in", "q_abs", "q_pot", "q_net", "q_coil_loss", "q_pipe", "T_oil", "obs_oil")
                           or name in ("T_film", "film_margin", "mcp", "UA_x", "delay", "p_pump", "expansion", "obs_margin", "deg", "obs_deg")
                           or name.startswith(("flux_", "coil_", "hist_", "ret_"))) else 1e-3
            err = float(np.max(np.abs(a[fin] - b[fin]) / scale)) if fin.any() else 0.0
            worst.append((name, err, "rel"))
            if err > tol:
                bad += 1
    for name, e, kind in sorted(worst, key=lambda r: -r[1])[:8]:
        print(f"  {name:<16} {kind} {e:.2e}")
    print(f"  capture mean {out[:, ECOL['capture']].mean():.3f}, p_in mean {out[:, ECOL['p_in']].mean():.0f} W, q_pot mean {out[:, ECOL['q_pot']].mean():.0f} W, T_out mean {out[:, ECOL['T_oil']].mean():.1f} K")
    fl = out[:, [ECOL[f'flux_{j}'] for j in range(8)]].mean(0); print("  flux bins (W, mean): " + " ".join(f"{v:.0f}" for v in fl) + f"  sum {fl.sum():.0f} vs p_in x alpha? p_in {out[:, ECOL['p_in']].mean():.0f}")
    print(f"  flow mean {out[:, ECOL['flow']].mean():.2e} m3/s, T_film mean {out[:, ECOL['T_film']].mean():.0f} K, "
          f"margin mean {out[:, ECOL['film_margin']].mean():+.0f} K, p_pump mean {out[:, ECOL['p_pump']].mean():.2f} W, "
          f"mcp mean {out[:, ECOL['mcp']].mean():.1f} W/K, UA_x mean {out[:, ECOL['UA_x']].mean():.1f} W/K, "
          f"delay mean {out[:, ECOL['delay']].mean():.2f} steps")
    print("  hist head == T_out:", bool(np.allclose(out[:, ECOL['hist_0']], out[:, ECOL['T_oil']])))
    print("METAL == NUMPY over the env's step" if bad == 0 else f"MISMATCH in {bad} columns")
    sys.exit(0 if bad == 0 else 1)

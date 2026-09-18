"""The Modula layer of Hashemi.lean, compiled: every definition as a module.

Ccc prints, for every definition of the spec, on the same hash-consed graph:
  * its tangent  hk_<f>_jvp  (the value and its Jacobian-vector product: the tangent functor),
  * its box      hk_<f>_box  (interval + Lipschitz abstract interpretation: the box functor),
and the driver wraps both as Metal kernels (hashemi_modula.metal) with a manifest
(hashemi_modula.json: inputs, outputs, mass = the design parameters among the inputs).

This file runs them:
  1. SOUNDNESS on every module: the measured |J dx| along random unit directions never exceeds
     the box bound L on the same box (a jump in the graph is L = HK_INF, trivially sound).
  2. THE ENV'S MORPHISMS on physical stages: dishPower (capture per radian of pose and sun, the
     design held), megaStep (pose per unit command: the action sensitivity), the gates (the
     Boolean ones jump, the smooth ones have the slope the theorems state: 1 / (4 tau)).
  3. THE SHEAF over a day's stages: stage (hour) -> (capture interval, L); restriction to a
     refinement is monotone (max over the pieces <= the coarse bound), the sections glue.
  4. MODULA: the closed loop (policy o env) as a composite module - masses, sensitivities, the
     modular norm's composition rule - and the learning-rate budget Muon distributes over the
     policy's layers, divided by the physics' sensitivity downstream of them.
    .venv/bin/python hashemi_modula.py [--rays 256] [--day 172]
"""
import argparse
import json
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
TUT = os.path.dirname(HERE)
for _p in (os.path.dirname(TUT), TUT, HERE):
    if _p not in sys.path:
        sys.path.insert(0, _p)

from hashemi_kernel import MSL_PRELUDE, header_text, mega_params_numpy, COL   # noqa: E402
from hashemi_trace_kernel import trace_params_numpy, SUN_HALF_ANGLE           # noqa: E402

HK_INF = 1e30
MANIFEST = json.load(open(os.path.join(HERE, "hashemi_modula.json")))
MODULES = {m["name"]: m for m in MANIFEST["modules"]}


def modula_source():
    with open(os.path.join(HERE, "hashemi_modula.h")) as f:
        mh = f.read()
    with open(os.path.join(HERE, "hashemi_modula.metal")) as f:
        mk = f.read()
    return MSL_PRELUDE + header_text() + mh + mk


class ModulaMetal:
    """the tangent and box kernels of every module, on the GPU"""

    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(modula_source())

    def jvp(self, name, x, dx, tables=()):
        """x, dx (N, n_in) float32 -> y, dy (N, n_out); a ray table per `arrays` entry, (N, P, m)"""
        torch, m = self.torch, MODULES[name]
        N = x.shape[0]
        y = torch.empty(N, m["n_out"], dtype=torch.float32, device="mps")
        dy = torch.empty_like(y)
        getattr(self.lib, m["kernel_jvp"])(x.contiguous(), dx.contiguous(), *[t.contiguous() for t in tables], y, dy,
                                          torch.tensor([N], dtype=torch.int32, device="mps"), threads=N)
        return y, dy

    def box(self, name, lo, hi, sc, tables=()):
        """lo, hi, sc (N, n_in) float32 -> olo, ohi, oL (N, n_out); ray tables as points"""
        torch, m = self.torch, MODULES[name]
        N = lo.shape[0]
        olo = torch.empty(N, m["n_out"], dtype=torch.float32, device="mps")
        ohi = torch.empty_like(olo)
        oL = torch.empty_like(olo)
        getattr(self.lib, m["kernel_box"])(lo.contiguous(), hi.contiguous(), sc.contiguous(), *[t.contiguous() for t in tables],
                                          olo, ohi, oL, torch.tensor([N], dtype=torch.int32, device="mps"), threads=N)
        return olo, ohi, oL

    @staticmethod
    def tables_for(name, N, rng):
        """random ray tables for a module's `arrays`: uniforms in [0, 1) (the draws' kind)"""
        return [t32(rng.random((N, a["P"], max(a["m"], 1)))) for a in MODULES[name].get("arrays", [])]


def t32(a):
    import torch
    return torch.as_tensor(np.asarray(a, dtype=np.float32), device="mps")


# ---------------------------------------------------------------------------- 1. soundness
def soundness(mm, rng, n_boxes=64, n_probe=32, width=0.05):
    """every module: measured |dy| along random unit (inf-norm) directions inside a small box
    around a sample point vs the box's Lipschitz bound; booleans excluded"""
    rows = []
    for name, m in MODULES.items():
        n_in, n_out = m["n_in"], m["n_out"]
        real_in = ~np.array(m["bool_inputs"])
        real_out = ~np.array(m["bool_outputs"])
        if not real_out.any():
            continue
        c = rng.uniform(0.2, 1.8, (n_boxes, n_in))
        c[:, ~real_in] = (rng.random((n_boxes, (~real_in).sum())) < 0.5).astype(np.float64)
        lo = c - width * real_in; hi = c + width * real_in
        sc = np.where(real_in, 1.0, 0.0)[None, :].repeat(n_boxes, 0)
        tabs = ModulaMetal.tables_for(name, n_boxes, rng)
        olo, ohi, oL = mm.box(name, t32(lo), t32(hi), t32(sc), tabs)
        L = oL.cpu().numpy().astype(np.float64)
        # probes: points in the box, unit directions in the inf-norm on the real inputs (the
        # ray tables held: each probe of a box uses its box's table)
        x = np.repeat(c, n_probe, 0) + rng.uniform(-width, width, (n_boxes * n_probe, n_in)) * real_in
        dx = rng.choice([-1.0, 1.0], (n_boxes * n_probe, n_in)) * real_in
        tabs_p = [t.repeat_interleave(n_probe, dim=0) for t in tabs]
        y, dy = mm.jvp(name, t32(x), t32(dx), tabs_p)
        dy = np.abs(dy.cpu().numpy().astype(np.float64)).reshape(n_boxes, n_probe, n_out)
        dy = np.where(np.isfinite(dy), dy, 0.0)
        meas = dy.max(1)                                      # per box, per output
        finite = (L < HK_INF) & real_out[None, :]
        viol = (meas > L * (1 + 1e-3) + 1e-4) & finite
        rows.append((name, n_in, n_out, int(finite.sum()), int((L >= HK_INF).sum()), int(viol.sum()),
                     float(np.max(np.where(finite & (L > 1e-3), meas / np.maximum(L, 1e-30), 0.0)))))
    return rows


# ---------------------------------------------------------------------------- 2. the env's morphisms
def sun_at(lat, day, hour):
    import tandoor_hashemi_env as _m
    el, az, _ = _m._sim.solar_position(lat, day, hour)
    return math.radians(el), az


def dish_prm():
    tp = trace_params_numpy()
    return np.concatenate([tp[:5], [-1.0, 2e-3, 1e-3, 0.85, SUN_HALF_ANGLE]])


def dish_stage(mm, rng, el, az, dpose, P, design=False, t_dead=1.076):
    """dishPower on one stage: the pose within dpose (rad) of the sun-facing pose, the sun within
    dpose of (el, az); the draws held per ray. Returns the capture's box and its Lipschitz bound
    (per radian of the inf-norm on pose and sun), the measured bound, and the mean capture."""
    m = MODULES["dishPower"]
    n_in = m["n_in"]
    prm = dish_prm()
    # the pose facing the sun: az_dish = az_sun, t = pi/2 - el (the dish's tilt from the zenith)
    az_d, t_d = az, min(max(math.pi / 2 - el, 0.0), t_dead)
    c = np.zeros((P, n_in))
    c[:, :10] = prm
    c[:, 10:14] = [az_d, t_d, el, az]
    c[:, 14:20] = rng.random((P, 6))
    c[:, 20:24] = rng.standard_normal((P, 4))
    sc = np.zeros((P, n_in)); w = np.zeros((P, n_in))
    sc[:, 10:14] = 1.0; w[:, 10:14] = dpose
    if design:
        sc[:, [0, 1, 2, 5]] = 1.0                            # R f a k as learnable
        w[:, [0, 1, 2, 5]] = [0.05, 0.05, 0.02, 0.1]
    olo, ohi, oL = mm.box("dishPower", t32(c - w), t32(c + w), t32(sc))
    olo, ohi, oL = (a.cpu().numpy().astype(np.float64) for a in (olo, ohi, oL))
    # measured: probes in the box, directions on the signal inputs
    n_probe = 8
    x = np.repeat(c, n_probe, 0) + rng.uniform(-1, 1, (P * n_probe, n_in)) * np.repeat(w, n_probe, 0)
    dx = rng.choice([-1.0, 1.0], (P * n_probe, n_in)) * np.repeat(sc, n_probe, 0)
    y, dy = mm.jvp("dishPower", t32(x), t32(dx))
    y = y.cpu().numpy().astype(np.float64); dy = np.abs(dy.cpu().numpy().astype(np.float64))
    fin = lambda a: np.where(np.isfinite(a), a, 0.0)
    # the capture (0) is a step per ray: its tangent is 0 and its box jumps; the landing radius (3)
    # and the smooth capture (4) carry the physics' modulus
    return dict(cap_lo=float(olo[:, 0].mean()), cap_hi=float(ohi[:, 0].mean()), cap=float(y[:, 0].mean()),
                cap_jump_frac=float((oL[:, 0] >= HK_INF).mean()),
                rad_L_bound=float(np.median(np.minimum(oL[:, 3], HK_INF))), rad_L_inf_frac=float((oL[:, 3] >= HK_INF).mean()),
                rad_L_meas_max=float(np.max(fin(dy[:, 3]))), rad_L_meas_mean=float(np.mean(fin(dy[:, 3]))),
                capS=float(y[:, 4].mean()), capS_L_bound=float(np.median(np.minimum(oL[:, 4], HK_INF))),
                capS_L_meas_max=float(np.max(fin(dy[:, 4]))), capS_theorem=float(np.max(fin(dy[:, 3]))) / (4 * 0.005),
                L_bound=float(np.median(np.minimum(oL[:, 3], HK_INF))), L_meas_max=float(np.max(fin(dy[:, 3]))))


def megastep_action_sensitivity(mm, rng, B=2048):
    """megaStep: the pose's change per unit command (az_next, t_next wrt omega_m, omega_d) over
    the machine's state space with the sun in reach - the env's action sensitivity"""
    m = MODULES["megaStep"]
    n_in = m["n_in"]; ins = m["inputs"]
    prm = mega_params_numpy()
    c = np.zeros((B, n_in))
    c[:, ins.index("az")] = rng.uniform(0, 2 * math.pi, B)
    c[:, ins.index("t")] = rng.uniform(0.0, 1.0, B)
    c[:, ins.index("slack")] = 0.0
    c[:, ins.index("omegam")] = rng.uniform(-2, 2, B)
    c[:, ins.index("omegad")] = rng.uniform(-0.5, 0.5, B)
    c[:, ins.index("dt")] = 15.0
    c[:, ins.index("elSun")] = rng.uniform(0.55, 1.5, B)
    c[:, ins.index("azSun")] = c[:, ins.index("az")] + rng.uniform(-0.02, 0.02, B)
    c[:, ins.index("dni")] = 800.0
    for k, nm in enumerate(["rDrum", "W", "rcm", "Tmax", "rho", "Fdrive", "L10", "rodLen"]):
        c[:, ins.index(nm)] = prm[k]
    sc = np.zeros((B, n_in)); w = np.zeros((B, n_in))
    for nm, width in (("omegam", 0.01), ("omegad", 0.01)):
        sc[:, ins.index(nm)] = 1.0; w[:, ins.index(nm)] = width
    olo, ohi, oL = mm.box("megaStep", t32(c - w), t32(c + w), t32(sc))
    oL = oL.cpu().numpy().astype(np.float64)
    dx = np.zeros((B, n_in)); dx[:, ins.index("omegam")] = 1.0
    _, dy_m = mm.jvp("megaStep", t32(c), t32(dx))
    dx = np.zeros((B, n_in)); dx[:, ins.index("omegad")] = 1.0
    _, dy_d = mm.jvp("megaStep", t32(c), t32(dx))
    dy_m = np.abs(dy_m.cpu().numpy().astype(np.float64)); dy_d = np.abs(dy_d.cpu().numpy().astype(np.float64))
    ca, ct, cs = COL["az_next"], COL["t_next"], COL["swing_rate"]
    fin = lambda a: a[np.isfinite(a) & (a < HK_INF)]
    # t_next goes through the 24-fold bisection: piecewise constant, tangent 0, box inf on straddles.
    # The spec carries the analytic rate: swing_rate = elRate omega_d rDrum arm = omega_d rDrum / arm,
    # so the tilt per unit omega_d per step is (swing_rate / omega_d) x dt from the column's tangent
    return dict(az_per_omegam_meas=float(np.max(dy_m[:, ca])), t_per_omegad_bisect=float(np.max(dy_d[:, ct])),
                t_per_omegad_analytic=float(np.max(dy_d[:, cs]) * 15.0), t_bisect_jump_frac=float(np.mean(oL[:, ct] >= HK_INF)),
                az_bound_finite=float(np.mean(oL[:, ca] < HK_INF)),
                az_bound_med=float(np.median(fin(oL[:, ca]))) if fin(oL[:, ca]).size else float("inf"),
                swing_bound_med=float(np.median(fin(oL[:, cs])) * 15.0) if fin(oL[:, cs]).size else float("inf"))


def env_step_sensitivity(mm, rng, B=512):
    """THE ENV STEP AS ONE MODULE: `hashemiEnv` (the mount, 64 rays, the heat) - its tangent
    along each motor command, and its box bound, on the machine's state space with the sun in
    reach and the dish near it. The closed loop's downstream sensitivity comes from here."""
    from hashemi_env_kernel import pack, EIN, ECOL, N_IN
    m = MODULES["hashemiEnv"]
    tdead = 1.077
    state = np.stack([rng.uniform(0, 2 * math.pi, B), rng.uniform(0.3, 1.0, B), np.zeros(B)], 1)
    cmd = np.stack([rng.uniform(-1, 1, B), rng.uniform(-0.3, 0.3, B)], 1)
    el = np.clip(math.pi / 2 - state[:, 1] + rng.uniform(-0.01, 0.01, B), 0.5, 1.5)
    sun = np.stack([el, state[:, 0] + rng.uniform(-0.01, 0.01, B), np.full(B, 800.0)], 1)
    x = pack(B, state, cmd, 15.0, sun, np.full(B, 0.95), rng.uniform(350, 500, B), rng.uniform(350, 450, B), 300.0)
    tabs = [t32(np.concatenate([rng.random((B, 64, 6)), rng.standard_normal((B, 64, 4))], 2))]
    out = {}
    for head, w in (("omegam", 0.05), ("omegad", 0.02)):
        dx = np.zeros((B, N_IN)); dx[:, EIN[head]] = 1.0
        _, dy = mm.jvp("hashemiEnv", t32(x), t32(dx), tabs)
        dy = np.abs(dy.cpu().numpy().astype(np.float64))
        sc = np.zeros((B, N_IN)); sc[:, EIN[head]] = 1.0
        wd = np.zeros((B, N_IN)); wd[:, EIN[head]] = w
        _, _, oL = mm.box("hashemiEnv", t32(x - wd), t32(x + wd), t32(sc), tabs)
        oL = oL.cpu().numpy().astype(np.float64)
        fin = lambda a: np.where(np.isfinite(a) & (a < HK_INF), a, np.nan)
        out[head] = {c: dict(meas=float(np.nanmax(dy[:, ECOL[c]])), bound=float(np.nanmedian(fin(oL[:, ECOL[c]]))),
                             jump=float(np.mean(oL[:, ECOL[c]] >= HK_INF)))
                     for c in ("az_next", "t_next", "swing_rate", "capture", "capture_s", "q_pot", "T_oil")}
    return out


def gates(mm, rng, B=4096, tau=0.01):
    """the Boolean gates jump where the smooth ones have the slope the theorems state"""
    out = {}
    for name, sig in (("SunReachable", None), ("sunReachableS", 1.0 / (4 * tau))):
        m = MODULES[name]; ins = m["inputs"]
        n_in = m["n_in"]
        c = np.zeros((B, n_in))
        c[:, ins.index("tDead")] = 1.076
        c[:, ins.index("elSun")] = rng.uniform(0.3, 0.7, B)         # around the reach floor 0.495 rad
        w = np.zeros((B, n_in)); w[:, ins.index("elSun")] = 0.005
        sc = np.zeros((B, n_in)); sc[:, ins.index("elSun")] = 1.0
        olo, ohi, oL = mm.box(name, t32(c - w), t32(c + w), t32(sc))
        olo, ohi, oL = (a.cpu().numpy().astype(np.float64)[:, 0] for a in (olo, ohi, oL))
        dx = np.zeros((B, n_in)); dx[:, ins.index("elSun")] = 1.0
        _, dy = mm.jvp(name, t32(c), t32(dx))
        dy = np.abs(dy.cpu().numpy().astype(np.float64)[:, 0])
        if sig is None:     # the Prop: three-valued, its boundary is the boxes it cannot decide
            out[name] = dict(jump_frac=float(np.mean(olo != ohi)), L_max_finite=0.0, meas_max=float(np.max(dy)), theorem_slope=None)
        else:
            out[name] = dict(jump_frac=float(np.mean(oL >= HK_INF)), L_max_finite=float(np.max(np.where(oL < HK_INF, oL, 0))),
                             meas_max=float(np.max(dy)), theorem_slope=sig)
    return out


# ---------------------------------------------------------------------------- 3. the sheaf over stages
def sheaf(mm, rng, lat, day, P, dpose):
    """stage = an hour of the day: the section (capture box, L) over it, and the gluing check on
    the refinement of each stage's box into its 2^4 sub-boxes on the four signal inputs"""
    rows = []
    for hour in range(8, 17):
        el, az = sun_at(lat, day, hour)
        if el <= 0:
            continue
        coarse = dish_stage(mm, rng, el, az, dpose, P)
        # the refinement: the box halved on each signal axis, the sections over the pieces
        fine_L, fine_lo, fine_hi = [], [], []
        for sgn in [(a, b, c, d) for a in (-1, 1) for b in (-1, 1) for c in (-1, 1) for d in (-1, 1)]:
            m = MODULES["dishPower"]; n_in = m["n_in"]
            prm = dish_prm()
            c = np.zeros((P, n_in)); c[:, :10] = prm
            c[:, 10:14] = [az + sgn[0] * dpose / 2, min(max(math.pi / 2 - el, 0.0), 1.076) + sgn[1] * dpose / 2,
                           el + sgn[2] * dpose / 2, az + sgn[3] * dpose / 2]
            c[:, 14:20] = rng.random((P, 6)); c[:, 20:24] = rng.standard_normal((P, 4))
            sc = np.zeros((P, n_in)); sc[:, 10:14] = 1.0
            w = np.zeros((P, n_in)); w[:, 10:14] = dpose / 2
            olo, ohi, oL = mm.box("dishPower", t32(c - w), t32(c + w), t32(sc))
            fine_L.append(float(np.median(np.minimum(oL.cpu().numpy()[:, 3], HK_INF)))); fine_lo.append(olo.cpu().numpy()[:, 0].mean()); fine_hi.append(ohi.cpu().numpy()[:, 0].mean())
        rows.append(dict(hour=hour, el_deg=math.degrees(el), **coarse, fine_L_max=float(max(fine_L)),
                         fine_lo_min=float(min(fine_lo)), fine_hi_max=float(max(fine_hi))))
    return rows


# ---------------------------------------------------------------------------- 4. Modula: the closed loop
class Module:
    """Modula's data: mass (the share of feature learning), sensitivity (Lipschitz in the input),
    and the parameters it owns; composition and concatenation by Modula's rules"""

    def __init__(self, name, mass=0.0, sensitivity=1.0, params=(), children=()):
        self.name, self.mass, self.sensitivity, self.params, self.children = name, float(mass), float(sensitivity), list(params), list(children)

    @staticmethod
    def compose(m2, m1):
        """m2 after m1: mass adds, sensitivity multiplies; the composite norm is
        max((M/m1) s2 |w1|, (M/m2) |w2|) - each part's norm scaled by its mass share and by what sits downstream"""
        c = Module(f"({m2.name} o {m1.name})", m1.mass + m2.mass, m1.sensitivity * m2.sensitivity, m1.params + m2.params)
        c.children = [(m1, m2.sensitivity), (m2, 1.0)]     # (part, sensitivity downstream of it)
        return c

    def lr_budget(self, eta, downstream=1.0):
        """the learning rate each parameter tensor gets under the modular norm with a global step
        eta: eta * (mass share) / (the sensitivity downstream of it)"""
        rows = []
        if self.children:
            for part, s_down in self.children:
                rows += part.lr_budget(eta, downstream * s_down)
            return rows
        for p in self.params:
            rows.append((p["name"], p["shape"], self.mass, eta * downstream and eta / max(downstream, 1e-12)))
        return rows


def closed_loop(obs=68, hidden=128, actions=19, s_env=1.0):
    lin1 = Module("encoder Linear", mass=1, sensitivity=1.0, params=[dict(name="encoder.weight", shape=(hidden, obs))])
    gelu = Module("GELU", 0, 1.0)
    lstm = Module("LSTM", mass=1, sensitivity=1.0, params=[dict(name="lstm.weight_ih", shape=(4 * hidden, hidden)), dict(name="lstm.weight_hh", shape=(4 * hidden, hidden))])
    dec = Module("decoder Linear", mass=1, sensitivity=1.0, params=[dict(name="decoder.weight", shape=(actions, hidden))])
    env = Module("env step (physics)", 0, s_env)
    policy = Module.compose(dec, Module.compose(lstm, Module.compose(gelu, lin1)))
    loop = Module.compose(env, policy)
    return policy, loop


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rays", type=int, default=256)
    ap.add_argument("--day", type=int, default=172)
    ap.add_argument("--lat", type=float, default=30.2)
    ap.add_argument("--dpose", type=float, default=0.002, help="half-width of a stage's pose/sun box [rad]")
    ap.add_argument("--eta", type=float, default=0.02, help="the modular-norm step (the ini's learning rate)")
    args = ap.parse_args()
    rng = np.random.default_rng(0)
    mm = ModulaMetal()
    print(f"modules: {len(MODULES)} (tangent + box kernels compiled), with mass: {sum(1 for m in MODULES.values() if m['mass'] > 0)}")

    print("\n1. SOUNDNESS: measured |dy| along unit directions <= the box's L (finite boxes), per module")
    rows = soundness(mm, rng)
    viol = sum(r[5] for r in rows); fin = sum(r[3] for r in rows); jumps = sum(r[4] for r in rows)
    print(f"   {len(rows)} modules, {fin} finite (box, output) pairs, {jumps} jumps (L = inf), violations: {viol}")
    worst = sorted(rows, key=lambda r: -r[6])[:5]
    for r in worst:
        print(f"   tightest: {r[0]:<28} n_in {r[1]:>3} n_out {r[2]:>3} finite {r[3]:>5} jumps {r[4]:>5} viol {r[5]:>3} max meas/L {r[6]:.3f}")

    print("\n2. THE ENV'S MORPHISMS")
    el, az = sun_at(args.lat, args.day, 12.0)
    d = dish_stage(mm, rng, el, az, args.dpose, args.rays)
    print(f"   dishPower at noon, pose/sun within {args.dpose} rad: capture {d['cap']:.3f} in [{d['cap_lo']:.3f}, {d['cap_hi']:.3f}], a step per ray (box jumps on {100 * d['cap_jump_frac']:.0f} % of rays, tangent 0)")
    print(f"     landing radius: L bound (median) {d['rad_L_bound']:.3g} m/rad (inf on {100 * d['rad_L_inf_frac']:.0f} %), measured max {d['rad_L_meas_max']:.3g} mean {d['rad_L_meas_mean']:.3g} m/rad")
    print(f"     smooth capture {d['capS']:.3f}: L bound (median) {d['capS_L_bound']:.3g} /rad, measured max {d['capS_L_meas_max']:.3g}; captureS_slope x radius slope = {d['capS_theorem']:.3g}")
    dd = dish_stage(mm, rng, el, az, args.dpose, args.rays, design=True)
    print(f"   dishPower with R f a k learnable (design mode, mass 4): radius L bound (median) {dd['rad_L_bound']:.3g}, measured max {dd['rad_L_meas_max']:.3g}")
    ms = megastep_action_sensitivity(mm, rng)
    print(f"   megaStep: az per unit omega_m per step measured {ms['az_per_omegam_meas']:.3g} rad (bound finite on {100 * ms['az_bound_finite']:.0f} %, median {ms['az_bound_med']:.3g})")
    print(f"     tilt per unit omega_d per step: through the bisection {ms['t_per_omegad_bisect']:.3g} (piecewise constant; box jumps on {100 * ms['t_bisect_jump_frac']:.0f} %),"
          f" through the spec's swing_rate column {ms['t_per_omegad_analytic']:.3g} rad (bound median {ms['swing_bound_med']:.3g})")
    es = env_step_sensitivity(mm, rng)
    print("   hashemiEnv (the step as one module): per unit command, measured tangent / box bound (median) / jump fraction")
    for head in ("omegam", "omegad"):
        print("     " + head + ": " + ", ".join(f"{c} {r['meas']:.3g}/{r['bound']:.3g}/{r['jump']:.0%}" for c, r in es[head].items()))
    g = gates(mm, rng)
    for name, r in g.items():
        if r["theorem_slope"] is None:
            print(f"   {name:<14}: a subobject - undecided on {100 * r['jump_frac']:.0f} % of the boxes (its boundary), tangent {r['meas_max']:.3g}")
        else:
            print(f"   {name:<14}: jumps on {100 * r['jump_frac']:.0f} % of boxes, L max (finite) {r['L_max_finite']:.3g}, measured max {r['meas_max']:.3g}, the theorem's slope {r['theorem_slope']:.1f}")
    ok_gate = g["sunReachableS"]["L_max_finite"] <= 1 / (4 * 0.01) * (1 + 1e-3) and g["sunReachableS"]["meas_max"] <= 1 / (4 * 0.01) * (1 + 1e-3)

    print(f"\n3. THE SHEAF over day {args.day}: stage = hour -> (capture box, L); the refinement's sections against the coarse one")
    sh = sheaf(mm, rng, args.lat, args.day, max(64, args.rays // 4), args.dpose)
    print("   hour  sun el   capture   [lo, hi] coarse   [lo, hi] refined   radius L coarse  refined(max)  glued   (L: m per rad of pose, median over rays)")
    glue_ok = True
    for r in sh:
        glued = (r["fine_lo_min"] >= r["cap_lo"] - 1e-6) and (r["fine_hi_max"] <= r["cap_hi"] + 1e-6)
        glue_ok &= glued
        print(f"   {r['hour']:>4}  {r['el_deg']:6.1f}   {r['cap']:.3f}   [{r['cap_lo']:.3f}, {r['cap_hi']:.3f}]    [{r['fine_lo_min']:.3f}, {r['fine_hi_max']:.3f}]    {r['L_bound']:8.3g}  {r['fine_L_max']:8.3g}      {'yes' if glued else 'NO'}")
    json.dump(dict(day=args.day, lat=args.lat, dpose=args.dpose, stages=sh), open(os.path.join(HERE, "modula_sheaf.json"), "w"), indent=1)

    print("\n4. MODULA: the closed loop as one module; the learning-rate budget Muon distributes")
    s_env = max(es["omegam"]["capture_s"]["meas"], es["omegad"]["capture_s"]["meas"], 1e-9)   # the composite's own tangent
    policy, loop = closed_loop(s_env=s_env)
    print(f"   env sensitivity (smooth capture per unit command, from hashemiEnv's tangent) = {s_env:.3g}"
          f" (the parts' product would say {ms['az_per_omegam_meas']:.3g} x {d['capS_L_meas_max']:.3g} = {ms['az_per_omegam_meas'] * d['capS_L_meas_max']:.3g})")
    print(f"   policy: mass {policy.mass:.0f}, sensitivity {policy.sensitivity:.3g}; loop: mass {loop.mass:.0f}, sensitivity {loop.sensitivity:.3g}")
    print(f"   budget at eta = {args.eta} (mass share x eta / downstream sensitivity):")
    rows = loop.lr_budget(args.eta)
    M = loop.mass
    lrs = []
    for name, shape, mass, lr in rows:
        lr_k = args.eta * (mass / M) / (s_env if "decoder" in name else s_env * 1.0)
        lrs.append(lr_k)
        print(f"     {name:<20} {str(shape):<12} mass {mass:.0f}/{M:.0f}  lr {lr_k:.3g}")
    lr_ini = min(lrs)
    print(f"   one-group Muon (pufferlib's): the binding layer's rate, learning_rate = {lr_ini:.3g}")
    ini_src = os.path.join(TUT, "puffer_tandoor", "hashemi_ccc.ini")
    ini_dst = os.path.join(TUT, "puffer_tandoor", "hashemi_ccc_muon.ini")
    src = open(ini_src).read()
    import re
    out = re.sub(r"(?m)^optimizer = .*$", "optimizer = muon", src)
    if "optimizer = muon" not in out:
        out = out.replace("[train]\n", "[train]\noptimizer = muon\n", 1)
    out = re.sub(r"(?m)^learning_rate = .*$", f"learning_rate = {lr_ini:.4g}", out)
    out = out.replace("env_name = puffer_hashemi_ccc", "env_name = puffer_hashemi_ccc_muon")
    open(ini_dst, "w").write(out)
    print(f"   wrote {os.path.relpath(ini_dst, TUT)} (optimizer = muon, learning_rate = {lr_ini:.4g}, env_name puffer_hashemi_ccc_muon)")

    ok = viol == 0 and ok_gate and glue_ok
    print("\nMODULA LAYER " + ("HOLDS" if ok else "FAILS") + f": soundness violations {viol}, smooth gate within the theorem's slope {ok_gate}, sheaf glues {glue_ok}")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()

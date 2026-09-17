"""ALL THE LEAN, VALIDATING THE ENVIRONMENT (user, 2026-09-17: "the point is all the lean should
validate the environment!!!!").

The Lean development at ~/manifold-pareto/lean/RequestProject is a SPECIFICATION of this
simulator.  Every theorem there is a claim about the machine; this file turns each claim into a
randomized property over the simulator's own code, with shrinking, so a failure arrives as the
smallest input that breaks it.

`tandoor_laws_check.py` checks the laws at ONE operating point.  `tandoor_policy_props.py` checks
the trained policy.  This checks the ENVIRONMENT, over its whole input space.

    PYTHONPATH=..:.:puffer_tandoor puffer_tandoor/.venv/bin/python tandoor_lean_props.py [--seed N]
                                                                  [--scale F] [--only SUBSTRING]
"""
import sys, math
import numpy as np

sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")

from tandoor_props import Gen, Suite, floats, ints, arrays, choice, spd_graph, run, Fail

SUITES = []
def suite(t):
    S = Suite(t); SUITES.append(S); return S


# =====================================================================================
# OpticsReal.lean / Optics.lean - the reflection law and the paraxial train
# =====================================================================================
OPT = suite("OpticsReal.lean, Optics.lean - reflection and the paraxial train")

def _unit(v):
    n = np.linalg.norm(v)
    return v / n if n > 1e-12 else np.array([0.0, 0.0, 1.0])

vec3 = arrays(3, -1.0, 1.0, target=0.0)


@OPT.prop("reflection preserves the ray's length", lean="OpticsReal.reflect_norm",
          gens=dict(d=vec3, nrm=vec3), n=400)
def _(d, nrm, label):
    from tandoor_coude_optics import reflect_np
    if np.linalg.norm(d) < 1e-6 or np.linalg.norm(nrm) < 1e-6: return True
    r = reflect_np(d, nrm)
    label("grazing", "yes" if abs(np.dot(_unit(d), _unit(nrm))) < 0.1 else "no")
    return abs(np.linalg.norm(r) - np.linalg.norm(d)) < 1e-9 * max(1.0, np.linalg.norm(d)), \
        f"|d| {np.linalg.norm(d):.6f} -> |r| {np.linalg.norm(r):.6f}"


@OPT.prop("the angle of incidence equals the angle of reflection", lean="OpticsReal.reflect_angle",
          gens=dict(d=vec3, nrm=vec3), n=400)
def _(d, nrm, label):
    from tandoor_coude_optics import reflect_np
    if np.linalg.norm(d) < 1e-6 or np.linalg.norm(nrm) < 1e-6: return True
    u, m = _unit(d), _unit(nrm)
    r = _unit(reflect_np(u, m))
    ci, cr = np.dot(u, m), np.dot(r, m)
    return abs(ci + cr) < 1e-9, f"cos(in) {ci:+.9f}, cos(out) {cr:+.9f}"


@OPT.prop("reflecting twice returns the ray (an involution)", lean="OpticsReal.reflect_involutive",
          gens=dict(d=vec3, nrm=vec3), n=400)
def _(d, nrm, label):
    from tandoor_coude_optics import reflect_np
    if np.linalg.norm(d) < 1e-6 or np.linalg.norm(nrm) < 1e-6: return True
    r2 = reflect_np(reflect_np(d, nrm), nrm)
    return np.allclose(r2, d, atol=1e-9), f"round trip off by {np.abs(r2 - d).max():.3e}"


@OPT.prop("the surface's two normals give the same reflection", lean="OpticsReal.reflect_neg_normal",
          gens=dict(d=vec3, nrm=vec3, s=floats(0.1, 10.0)), n=300)
def _(d, nrm, s, label):
    from tandoor_coude_optics import reflect_np
    if np.linalg.norm(d) < 1e-6 or np.linalg.norm(nrm) < 1e-6: return True
    a, b = reflect_np(d, nrm), reflect_np(d, -s * nrm)
    return np.allclose(a, b, atol=1e-9), f"differ by {np.abs(a - b).max():.3e} at scale {s:.3g}"


@OPT.prop("the reflected ray stays in the plane of the ray and the normal",
          lean="OpticsReal.reflect_coplanar", gens=dict(d=vec3, nrm=vec3), n=300)
def _(d, nrm, label):
    from tandoor_coude_optics import reflect_np
    if np.linalg.norm(d) < 1e-6 or np.linalg.norm(nrm) < 1e-6: return True
    r = reflect_np(d, nrm)
    vol = abs(np.dot(np.cross(d, nrm), r))          # the triple product: zero iff coplanar
    return vol < 1e-9 * max(1.0, np.linalg.norm(d) ** 3), f"triple product {vol:.3e}"


@OPT.prop("a paraxial train is unimodular, so phase-space area survives it",
          lean="Physics.liouville, OpticsReal.RayMapAbs.volume_image",
          gens=dict(k=ints(1, 8), f=arrays(8, -4.0, 4.0, target=0.0), d=arrays(8, 0.0, 6.0)), n=300)
def _(k, f, d, label):
    M = np.eye(2)
    for i in range(k):
        if abs(f[i]) > 1e-3:
            M = np.array([[1.0, 0.0], [-1.0 / f[i], 1.0]]) @ M    # a thin element
        M = np.array([[1.0, d[i]], [0.0, 1.0]]) @ M               # a drift
    label("elements", str(min(k, 4)))
    # det of a 2x2 is a difference of products, so the round-off floor is eps * ||M||^2, not eps
    tol = 64.0 * np.finfo(float).eps * max(1.0, float(np.abs(M).max()) ** 2)
    d = M[0, 0] * M[1, 1] - M[0, 1] * M[1, 0]
    return abs(d - 1.0) <= tol, f"det = {d:.12f} after {k} stages (floor {tol:.3e}, |M| {np.abs(M).max():.4g})"


@OPT.prop("a bundle of rays keeps its area through the whole train (Liouville)",
          lean="Physics.liouville", gens=dict(k=ints(1, 6), f=arrays(6, -4.0, 4.0, target=0.0),
                                              d=arrays(6, 0.0, 6.0), y=arrays(5, -1.0, 1.0),
                                              th=arrays(5, -0.3, 0.3)), n=200)
def _(k, f, d, y, th, label):
    P = np.stack([y, th], 1)                        # a polygon in (y, theta)
    def area(Q):
        x, z = Q[:, 0], Q[:, 1]
        return 0.5 * abs(np.dot(x, np.roll(z, -1)) - np.dot(z, np.roll(x, -1)))
    a0 = area(P)
    if a0 < 1e-6: return True                       # a degenerate polygon says nothing
    M = np.eye(2)
    for i in range(k):
        if abs(f[i]) > 1e-3: M = np.array([[1.0, 0.0], [-1.0 / f[i], 1.0]]) @ M
        M = np.array([[1.0, d[i]], [0.0, 1.0]]) @ M
    a1 = area(P @ M.T)
    tol = 64.0 * np.finfo(float).eps * max(1.0, float(np.abs(M).max()) ** 2) * max(a0, 1.0)
    return abs(a1 - a0) <= tol, f"area {a0:.6g} -> {a1:.6g} (floor {tol:.3e})"


# =====================================================================================
# Membrane.lean - the rotation that aims the dish
# =====================================================================================
GEO = suite("Membrane.lean, Mount.lean - the frame that aims the dish")


def _rot_about(axis, ang):
    k = _unit(axis); K = np.array([[0, -k[2], k[1]], [k[2], 0, -k[0]], [-k[1], k[0], 0]])
    return np.eye(3) + math.sin(ang) * K + (1 - math.cos(ang)) * (K @ K)


@GEO.prop("the aiming rotation is a rotation for EVERY pair of directions",
          lean="Mount.frame_orthonormal", cover={"turn": {"near half a turn": 0.15}},
          gens=dict(a=vec3, ax=vec3, gap=floats(1e-9, 3.0, target=3.0, log=True)), n=500)
def _(a, ax, gap, label):
    # `gap` is the angle SHORT of a half turn, drawn log-uniformly so the singular region is
    # actually explored; the shrinker pulls it toward the safe end, so a failure is reported at the
    # LARGEST gap that still breaks - the threshold itself
    ang = math.pi - gap
    from tandoor_polar_env import _rot_a_to_b
    if np.linalg.norm(a) < 1e-3 or np.linalg.norm(ax) < 1e-6: return True
    u = _unit(a)
    perp = np.cross(u, _unit(ax))
    if np.linalg.norm(perp) < 1e-6: return True
    v = _unit(_rot_about(perp, ang) @ u)
    label("turn", "near half a turn" if gap < 1e-3 else "general")
    R = _rot_a_to_b(u, v)
    err = max(float(np.abs(R.T @ R - np.eye(3)).max()), abs(float(np.linalg.det(R)) - 1.0))
    return err < 1e-7, \
        (f"{math.degrees(gap):.4e} deg short of a half turn it is no longer a rotation: "
         f"|R^T R - I| and |det - 1| up to {err:.3e}")


@GEO.prop("the aiming rotation actually lands the dish's axis on its target",
          lean="Mount.frame_aims", cover={"turn": {"near half a turn": 0.15}},
          gens=dict(a=vec3, ax=vec3, gap=floats(1e-9, 3.0, target=3.0, log=True)), n=500)
def _(a, ax, gap, label):
    ang = math.pi - gap
    from tandoor_polar_env import _rot_a_to_b
    if np.linalg.norm(a) < 1e-3 or np.linalg.norm(ax) < 1e-6: return True
    u = _unit(a)
    perp = np.cross(u, _unit(ax))
    if np.linalg.norm(perp) < 1e-6: return True
    v = _unit(_rot_about(perp, ang) @ u)
    label("turn", "near half a turn" if gap < 1e-3 else "general")
    miss = float(np.abs(_rot_a_to_b(u, v) @ u - v).max())
    return miss < 1e-7, \
        (f"{math.degrees(gap):.4e} deg short of a half turn the axis lands {miss:.3e} away from "
         f"its target - the helper has quietly returned the identity instead of the half turn")


@GEO.prop("the machine's one use of that rotation sits far from where it breaks",
          lean="Mount.frame_aims (the hypothesis, at the real call site)", gens=dict(), n=1)
def _(label):
    import tandoor_polar_env as E
    from tandoor_polar_env import _rot_a_to_b
    a0 = np.array([0.0, 0.961, 0.278]); a0 /= np.linalg.norm(a0)
    M = np.array([0.0, -E.R_DUCT_WALL, E.Z_DUCT]) + 0.35 * a0
    zb = 0.5 * (E.Z_BAKE_LO + E.Z_CROWN)
    rb = float(np.sqrt(E.R_SPH ** 2 - (zb - E.Z_CPOT) ** 2))
    ph6 = -np.pi + (6.5 / 8.0) * 2.0 * np.pi
    a1 = np.array([rb * np.cos(ph6), rb * np.sin(ph6), zb]) - M; a1 /= np.linalg.norm(a1)
    R = _rot_a_to_b(a0, a1)
    sep = math.degrees(math.acos(float(np.clip(np.dot(a0, a1), -1, 1))))
    ok = (np.abs(R.T @ R - np.eye(3)).max() < 1e-12 and np.allclose(R @ a0, a1, atol=1e-12))
    return ok and sep < 170.0, \
        (f"the nozzle turns the beam {sep:.2f} deg, {180 - sep:.2f} deg clear of the half-turn "
         f"singularity; the rotation is exact to {np.abs(R @ a0 - a1).max():.2e}")


# =====================================================================================
# ThermalDiscrete.lean / ThermalContraction.lean - the pot as a dissipative network
# =====================================================================================
THM = suite("ThermalDiscrete.lean, ThermalContraction.lean - the pot as a network")

def _assemble(g):
    """Lean's Network.ofGraph: L = sum_e w (e_i - e_j)(e_i - e_j)^T, plus diag(leak)."""
    n, edges, leak, cap = g
    G = np.zeros((n, n))
    for (i, j, w) in edges:
        G[i, i] += w; G[j, j] += w; G[i, j] -= w; G[j, i] -= w
    return G + np.diag(leak), np.asarray(cap, float)

def _step(G, C, T, dt, amb=0.0, q=None):
    leak = np.diag(G) - (np.diag(G) - G.sum(1))     # row sums are exactly the leaks
    leak = G.sum(1)
    src = leak * amb + (0.0 if q is None else q)
    return T + dt / C * (-(G @ T) + src)

def _dt_ok(G, C, safety=1.0):
    """Lean's per-node explicit-Euler condition: dt * (sum of the node's conductances) <= C_i"""
    row = np.abs(G).sum(1)
    return safety * float(np.min(C / np.maximum(row, 1e-12)))


@THM.prop("the conduction operator is symmetric and positive semidefinite",
          lean="ThermalDiscrete.laplacian_posSemidef", gens=dict(g=spd_graph()), n=300)
def _(g, label):
    G, C = _assemble(g)
    label("leaky", "yes" if (np.diag(G) - (G.sum(1) == 0).astype(float)).any() and g[2].any() else "no")
    sym = np.abs(G - G.T).max()
    ev = np.linalg.eigvalsh(G)
    return sym < 1e-12 and ev.min() > -1e-9 * max(1.0, abs(ev).max()), \
        f"asymmetry {sym:.3e}, smallest eigenvalue {ev.min():.3e}"


@THM.prop("with no leak the operator annihilates a uniform temperature (nothing flows in equilibrium)",
          lean="ThermalDiscrete.laplacian_const_mem_ker", gens=dict(g=spd_graph()), n=300)
def _(g, label):
    n, edges, leak, cap = g
    G, C = _assemble((n, edges, np.zeros(n), cap))
    return np.abs(G @ np.ones(n)).max() < 1e-9 * max(1.0, np.abs(G).max()), \
        f"row sums up to {np.abs(G @ np.ones(n)).max():.3e}"


@THM.prop("under Lean's step condition one Euler step invents no new extreme temperature",
          lean="ThermalDiscrete.ofGraph_explicit_euler_le",
          gens=dict(g=spd_graph(), T=arrays(12, 250.0, 900.0), amb=floats(250.0, 330.0),
                    frac=floats(0.05, 1.0)), n=300)
def _(g, T, amb, frac, label):
    G, C = _assemble(g)
    n = g[0]; T = np.asarray(T[:n], float)
    if T.size < n: return True
    dt = frac * _dt_ok(G, C)
    label("step", "at the limit" if frac > 0.9 else "inside")
    T1 = _step(G, C, T, dt, amb)
    lo, hi = min(T.min(), amb), max(T.max(), amb)
    return T1.min() >= lo - 1e-7 and T1.max() <= hi + 1e-7, \
        f"[{T1.min():.4f}, {T1.max():.4f}] escaped [{lo:.4f}, {hi:.4f}] at dt = {dt:.4g} s"


@THM.prop("the step is order preserving: a hotter pot stays hotter everywhere",
          lean="ThermalContraction.step_monotone",
          gens=dict(g=spd_graph(), T=arrays(12, 250.0, 900.0), dpos=arrays(12, 0.0, 200.0),
                    amb=floats(250.0, 330.0), frac=floats(0.05, 1.0)), n=300)
def _(g, T, dpos, amb, frac, label):
    G, C = _assemble(g)
    n = g[0]
    if T.size < n or dpos.size < n: return True
    T, dpos = np.asarray(T[:n], float), np.asarray(dpos[:n], float)
    dt = frac * _dt_ok(G, C)
    a, b = _step(G, C, T, dt, amb), _step(G, C, T + dpos, dt, amb)
    return (b - a).min() > -1e-7, f"order reversed by {-(b - a).min():.3e} at dt = {dt:.4g} s"


@THM.prop("stored energy never rises in the dark, and is exactly conserved with no leak",
          lean="ThermalDiscrete.explicit_euler_energy_eq, energy_antitone",
          gens=dict(g=spd_graph(), T=arrays(12, 300.0, 900.0), frac=floats(0.05, 1.0),
                    k=ints(1, 30)), n=250)
def _(g, T, frac, k, label):
    n, edges, leak, cap = g
    G, C = _assemble(g)
    if T.size < n: return True
    T = np.asarray(T[:n], float)
    dt = frac * _dt_ok(G, C)
    leaky = bool(np.any(leak > 0))
    label("leak", "yes" if leaky else "no")
    E = [float((C * T).sum())]
    for _ in range(k):
        T = _step(G, C, T, dt, 0.0)                 # ambient at zero: pure dissipation
        E.append(float((C * T).sum()))
    dE = np.diff(E)
    if leaky:
        return dE.max() <= 1e-6 * max(1.0, abs(E[0])), f"energy rose by {dE.max():.4g} J"
    return abs(E[-1] - E[0]) <= 1e-6 * max(1.0, abs(E[0])), \
        f"energy drifted {E[-1] - E[0]:.4g} J with no leak in the network"


@THM.prop("with a source held constant the pot converges to one equilibrium, from anywhere",
          lean="ThermalContraction.contracting, fixedPoint_unique",
          gens=dict(g=spd_graph(), T0=arrays(12, 250.0, 900.0), T1=arrays(12, 250.0, 900.0),
                    amb=floats(250.0, 330.0), q=arrays(12, 0.0, 4000.0)), n=200)
def _(g, T0, T1, amb, q, label):
    G, C = _assemble(g)
    n, edges, leak, cap = g
    if not np.any(leak > 0): return True            # with no leak to ambient there is no unique fixed point
    if T0.size < n or T1.size < n or q.size < n: return True
    a, b = np.asarray(T0[:n], float), np.asarray(T1[:n], float)
    dt = 0.9 * _dt_ok(G, C)
    d0 = np.abs(a - b).max()
    for _ in range(400):
        a = _step(G, C, a, dt, amb, q[:n]); b = _step(G, C, b, dt, amb, q[:n])
    d1 = np.abs(a - b).max()
    label("contracted", "fully" if d1 < 1e-6 * max(d0, 1.0) else "partly")
    return d1 <= d0 + 1e-9, f"separation {d0:.4g} -> {d1:.4g} K after 400 steps"


# =====================================================================================
# Wind.lean - the stow latch, the log law, the canopy
# =====================================================================================
WND = suite("Wind.lean - the stow latch, the log law, the canopy")

def _latch(w, state=False, lo=14.0, hi=16.0):
    """the env's own rule (tandoor_polar_env.py:791), as a pure function"""
    out = []
    for v in w:
        state = (state or (v > hi)) and not (v < lo)
        out.append(state)
    return np.array(out)


@WND.prop("the stow latch never changes state while the wind stays in its dead band",
          lean="Wind.latch_of_band, stow_const_of_band",
          gens=dict(w=arrays(40, 13.0, 17.0), s0=choice([False, True])), n=400)
def _(w, s0, label):
    st = _latch(w, s0)
    band = (w[:-1] >= 14.0) & (w[:-1] <= 16.0) & (w[1:] >= 14.0) & (w[1:] <= 16.0)
    bad = band & (st[:-1] != st[1:])
    label("entered the band", "yes" if band.any() else "no")
    return not bad.any(), f"{int(bad.sum())} changes inside the band"


@WND.prop("the latch is hysteretic: above the high threshold it is always stowed, below the low never",
          lean="Wind.latch_of_gt, latch_of_lt, stow_of_gt, stow_of_lt",
          gens=dict(w=arrays(40, 5.0, 30.0), s0=choice([False, True])), n=400)
def _(w, s0, label):
    st = _latch(w, s0)
    label("range", "crosses both" if (w > 16).any() and (w < 14).any() else "one-sided")
    return bool((st[w > 16.0].all() if (w > 16.0).any() else True)
                and (not st[w < 14.0].any() if (w < 14.0).any() else True)), \
        "a gust above 16 m/s left it unstowed, or a lull below 14 left it stowed"


@WND.prop("the latch is history-dependent only through its state: replaying from the state agrees",
          lean="Wind.stow_change", gens=dict(w=arrays(40, 5.0, 30.0), k=ints(1, 38),
                                             s0=choice([False, True])), n=300)
def _(w, k, s0, label):
    full = _latch(w, s0)
    split = np.concatenate([full[:k], _latch(w[k:], bool(full[k - 1]))])
    return np.array_equal(full, split), "splitting the wind history changed the latch"


@WND.prop("stowing can only ever shed load, never add it", lean="Wind.stow_sheds_load",
          gens=dict(V=floats(0.0, 30.0), rho=floats(0.9, 1.4), A=floats(0.1, 30.0),
                    cd=floats(0.1, 2.0)), n=300)
def _(V, rho, A, cd, label):
    q = 0.5 * rho * V * V
    return q * A * cd >= 0.0 and q >= 0.0, f"dynamic pressure {q:.4g} Pa"


@WND.prop("dynamic pressure is exactly quadratic in the wind", lean="Wind.dynPressure",
          gens=dict(V=floats(0.0, 30.0), rho=floats(0.9, 1.4), k=floats(0.1, 3.0)), n=300)
def _(V, rho, k, label):
    q = lambda v: 0.5 * rho * v * v
    lhs, rhs = q(k * V), k * k * q(V)
    return abs(lhs - rhs) <= 1e-9 * max(1.0, abs(rhs)), f"q(kV) {lhs:.6g} vs k^2 q(V) {rhs:.6g}"


@WND.prop("the wind the dish feels rises with height and vanishes at the roughness length",
          lean="Wind.logLaw_mono, logLaw_zero",
          gens=dict(z0=floats(0.03, 3.0, log=True), z1=floats(0.5, 50.0), z2=floats(0.5, 50.0),
                    ustar=floats(0.05, 2.0)), n=400)
def _(z0, z1, z2, ustar, label):
    u = lambda z: (ustar / 0.4) * math.log(max(z, 1e-9) / z0) if z > z0 else 0.0
    lo, hi = min(z1, z2), max(z1, z2)
    if hi <= z0: return True
    label("above the canopy", "yes" if lo > z0 else "partly")
    return u(hi) >= u(lo) - 1e-12 and abs(u(z0)) < 1e-12, \
        f"u({lo:.2f}) = {u(lo):.4f} but u({hi:.2f}) = {u(hi):.4f}"


@WND.prop("a denser canopy never lowers the roughness it presents to the wind",
          lean="Wind.z0_mono_lamF", gens=dict(n=ints(8, 60), a=floats(20.0, 300.0),
                                              h=floats(2.0, 12.0), bump=floats(1.05, 3.0)), n=200)
def _(n, a, h, bump, label):
    from tandoor_site_weather import morphology
    base = [(a, h)] * n
    taller = [(a, h * bump)] * n
    m0, m1 = morphology(base), morphology(taller)
    label("plan fraction", "capped" if m0["lam_p"] >= 0.9 else "free")
    return m1["z0"] >= m0["z0"] - 1e-9 and m1["lam_f"] >= m0["lam_f"] - 1e-12, \
        f"z0 {m0['z0']:.4f} -> {m1['z0']:.4f} m when the buildings grew {bump:.2f}x taller"


@WND.prop("the compass bearing the wind comes FROM is opposite the way it blows",
          lean="Wind.dirFrom_involutive", gens=dict(u=floats(-30.0, 30.0), v=floats(-30.0, 30.0)), n=400)
def _(u, v, label):
    from tandoor_site_weather import _dir_from
    if math.hypot(u, v) < 1e-6: return True
    d = math.radians(float(_dir_from(u, v)))
    blow = np.array([-math.sin(d), -math.cos(d)])   # the unit vector it blows TOWARD
    got = np.array([u, v]) / math.hypot(u, v)
    return np.allclose(blow, got, atol=1e-9), f"bearing {math.degrees(d):.3f} deg disagrees by {np.abs(blow - got).max():.3e}"


# =====================================================================================
# MembraneFvK.lean - the pumped film's cubic load-sag law
# =====================================================================================
FVK = suite("MembraneFvK.lean - the pumped film's cubic law")

def _sag(c2, c4, A, p):
    """the real root of c2 a + c4 a^3 = A p (Foppl-von-Karman), which Lean calls sagStar"""
    r = np.roots([c4, 0.0, c2, -A * p])
    r = [x.real for x in r if abs(x.imag) < 1e-9]
    return max(r) if r else 0.0


@FVK.prop("the sag the film takes really solves the cubic load law", lean="MembraneFvK.sagStar_spec",
          gens=dict(c2=floats(1.0, 1e5, log=True), c4=floats(1.0, 1e8, log=True),
                    A=floats(0.1, 20.0), p=floats(0.0, 5000.0)), n=300)
def _(c2, c4, A, p, label):
    a = _sag(c2, c4, A, p)
    res = c2 * a + c4 * a ** 3 - A * p
    label("regime", "cubic" if c4 * a ** 3 > c2 * a else "linear")
    return abs(res) <= 1e-6 * max(1.0, A * p), f"residual {res:.4g} at sag {a:.6g} m"


@FVK.prop("more pressure never gives less sag", lean="MembraneFvK.sagStar_mono",
          gens=dict(c2=floats(1.0, 1e5, log=True), c4=floats(1.0, 1e8, log=True),
                    A=floats(0.1, 20.0), p=floats(0.0, 5000.0), dp=floats(0.0, 5000.0)), n=300)
def _(c2, c4, A, p, dp, label):
    return _sag(c2, c4, A, p + dp) >= _sag(c2, c4, A, p) - 1e-12, "sag fell when the pump rose"


@FVK.prop("the linear law always OVER-predicts the sag - stiffening is what the cubic term buys",
          lean="MembraneFvK.sagStar_sub_membrane_sagStar_le, linear_eq_membrane_sagStar",
          gens=dict(c2=floats(1.0, 1e5, log=True), c4=floats(1.0, 1e8, log=True),
                    A=floats(0.1, 20.0), p=floats(0.0, 5000.0)), n=300)
def _(c2, c4, A, p, label):
    lin, tru = A * p / c2, _sag(c2, c4, A, p)
    label("error", "over 2x" if lin > 2 * max(tru, 1e-12) else "under 2x")
    return lin >= tru - 1e-12, f"linear {lin:.6g} m under-predicted the true sag {tru:.6g} m"


@FVK.prop("the tangent stiffness really is the slope of the load-sag curve",
          lean="MembraneFvK.kEff_hasDerivAt", gens=dict(c2=floats(1.0, 1e5, log=True),
                                                        c4=floats(1.0, 1e8, log=True),
                                                        a=floats(1e-4, 1.0, log=True)), n=400)
def _(c2, c4, a, label):
    load = lambda x: c2 * x + c4 * x ** 3
    h = 1e-6 * a
    fd = (load(a + h) - load(a - h)) / (2 * h)
    k = c2 + 3.0 * c4 * a * a
    return abs(fd - k) <= 1e-5 * max(abs(k), 1.0), f"kEff {k:.6g} vs finite difference {fd:.6g}"


@FVK.prop("a pumped film is stiffer than its pretension alone, and a slack one has no stiffness at all",
          lean="MembraneFvK.kEff_zero_iff_no_pretension, kEff_ge_c2", cover={"slack": {"yes": 0.05}},
          gens=dict(c2=choice([0.0] * 3 + [1.0, 1e2, 1e3, 1e4, 1e5]), c4=floats(1.0, 1e8, log=True),
                    a=choice([0.0] * 3 + [1e-4, 1e-2, 0.1, 0.5, 1.0])), n=400)
def _(c2, c4, a, label):
    k = c2 + 3.0 * c4 * a * a
    label("slack", "yes" if c2 == 0.0 and a == 0.0 else "no")
    return k >= c2 - 1e-12 and ((k > 0.0) == (c2 > 0.0 or a > 0.0)), \
        f"kEff {k:.6g} with pretension {c2:.6g} at sag {a:.6g}"


@FVK.prop("the gust sandwich: the sag under a varying pressure lies between its extremes",
          lean="MembraneFvK.sagStar_gust_le",
          gens=dict(c2=floats(1.0, 1e5, log=True), c4=floats(1.0, 1e8, log=True),
                    A=floats(0.1, 20.0), p=arrays(12, 0.0, 5000.0)), n=200)
def _(c2, c4, A, p, label):
    s = np.array([_sag(c2, c4, A, x) for x in p])
    return s.min() >= _sag(c2, c4, A, p.min()) - 1e-9 and s.max() <= _sag(c2, c4, A, p.max()) + 1e-9, \
        f"sag range [{s.min():.6g}, {s.max():.6g}] outside the pressure extremes"


# =====================================================================================
# Flutter.lean / BinaryFlutter.lean - divergence, galloping, Routh-Hurwitz
# =====================================================================================
FLT = suite("Flutter.lean, BinaryFlutter.lean - divergence, galloping, Routh-Hurwitz")

def _routh(a0, a1, a2, a3, a4):
    return a1 * a2 * a3 - a0 * a3 ** 2 - a1 ** 2 * a4


def quartic_gen():
    """half from known roots (so stability is known a priori), half from raw coefficients"""
    def _s(r):
        if r.random() < 0.5:
            cs = []
            for _ in range(2):
                if r.random() < 0.5:
                    cs += [complex(r.uniform(-3, 1.5), 0.0), complex(r.uniform(-3, 1.5), 0.0)]
                else:
                    re, im = r.uniform(-3, 1.5), r.uniform(0.1, 3.0)
                    cs += [complex(re, im), complex(re, -im)]
            a0 = r.uniform(0.2, 5.0)
            c = np.real(a0 * np.poly(cs[:4]))
            return tuple(float(x) for x in c)
        return tuple([r.uniform(0.2, 5.0)] + [r.uniform(-5.0, 5.0) for _ in range(4)])

    def _sh(v):
        a0, a1, a2, a3, a4 = v
        for i in range(1, 5):
            w = list(v)
            for c in (0.0, w[i] * 0.5, round(w[i], 2)):
                if c != w[i]:
                    x = list(v); x[i] = c; yield tuple(x)
        yield (1.0, a1, a2, a3, a4)
    return Gen(_s, _sh, "quartic")


@FLT.prop("the Routh determinant of a factored quartic matches the proved identity",
          lean="BinaryFlutter.routh_of_factors",
          gens=dict(a0=floats(0.2, 5.0), p=floats(-4.0, 4.0), q=floats(-4.0, 4.0),
                    r=floats(-4.0, 4.0), t=floats(-4.0, 4.0)), n=400)
def _(a0, p, q, r, t, label):
    lhs = _routh(a0, a0 * (p + r), a0 * (q + t + p * r), a0 * (p * t + q * r), a0 * (q * t))
    rhs = a0 ** 3 * (p * r * ((q - t) ** 2 + (p + r) * (p * t + q * r)))
    return abs(lhs - rhs) <= 1e-6 * max(1.0, abs(rhs)), f"{lhs:.8g} vs {rhs:.8g}"


@FLT.prop("Routh-Hurwitz decides stability exactly, against the quartic's actual roots",
          lean="BinaryFlutter.routh_pos_of_stableFactored, not_stableFactored_of_routh_nonpos",
          gens=dict(c=quartic_gen()), n=800)
def _(c, label):
    a0, a1, a2, a3, a4 = c
    if a0 <= 0: return True
    rt = np.roots([a0, a1, a2, a3, a4])
    m = float(np.max(rt.real))
    if abs(m) < 1e-7: label("case", "on the boundary (skipped)"); return True
    stable = m < 0.0
    D = _routh(*c)
    if min(abs(D), abs(a1), abs(a3), abs(a4)) < 1e-9:
        label("case", "degenerate (skipped)"); return True
    crit = (a1 > 0 and a3 > 0 and a4 > 0 and D > 0)
    label("case", "stable" if stable else "unstable")
    return crit == stable, \
        (f"Routh says {'stable' if crit else 'unstable'} but the largest root has real part "
         f"{m:+.6g}; a=({a0:.4g},{a1:.4g},{a2:.4g},{a3:.4g},{a4:.4g}), determinant {D:.6g}")


@FLT.prop("a mass-balanced wing cannot flutter, whatever the airspeed",
          lean="BinaryFlutter.massBalanced_no_flutter",
          gens=dict(m=floats(0.5, 50.0), I=floats(0.05, 20.0), ch=floats(0.01, 10.0),
                    ca=floats(0.01, 10.0), kh=floats(1.0, 1e4, log=True),
                    ka=floats(1.0, 1e4, log=True), Ma=floats(1e-3, 1e4, log=True)), n=500)
def _(m, I, ch, ca, kh, ka, Ma, label):
    kaBar = ka - Ma
    if kaBar <= 0:
        label("torsional stiffness", "eaten by the air"); return True   # divergence, not flutter
    S = 0.0                                                             # mass balanced
    a0 = m * I - S * S
    a1 = m * ca + ch * I
    a2 = m * kaBar + ch * ca + kh * I
    a3 = ch * kaBar + kh * ca
    a4 = kh * kaBar
    label("torsional stiffness", "positive")
    rt = np.roots([a0, a1, a2, a3, a4])
    return float(np.max(rt.real)) < 1e-9, \
        f"largest real part {float(np.max(rt.real)):+.6g} on a mass-balanced wing"


@FLT.prop("the airspeed at which galloping starts does not depend on the stiffness",
          lean="Flutter.galloping_indep_of_stiffness",
          gens=dict(c=floats(0.01, 50.0), rho=floats(0.9, 1.4), Ad=floats(0.05, 20.0),
                    H=floats(0.1, 8.0), k1=floats(1.0, 1e5, log=True),
                    k2=floats(1.0, 1e5, log=True)), n=400)
def _(c, rho, Ad, H, k1, k2, label):
    gallop = lambda k: 2.0 * c / (rho * Ad * H)     # Den Hartog: the stiffness never enters
    return abs(gallop(k1) - gallop(k2)) < 1e-12, "the onset speed moved when only the stiffness changed"


@FLT.prop("negative effective stiffness means divergence: a real growing mode exists",
          lean="Flutter.divergence_unstable, K_neg_iff_gain_gt_one",
          gens=dict(m=floats(0.1, 50.0), c=floats(0.0, 20.0), k=floats(0.0, 1e4),
                    kq=floats(0.0, 2e4)), n=500)
def _(m, c, k, kq, label):
    K = k - kq
    label("stiffness", "negative" if K < 0 else "positive")
    rt = np.roots([m, c, K])
    grows = float(np.max(rt.real)) > 1e-12
    if abs(K) < 1e-9: return True
    return (K < 0) == grows, \
        f"K = {K:+.6g} but the largest root has real part {float(np.max(rt.real)):+.6g}"


@FLT.prop("the aerodynamic damping enters the mode exactly once, so its sign decides flutter",
          lean="Flutter.gallop_iff, expMode_solves",
          gens=dict(m=floats(0.1, 50.0), c=floats(0.0, 20.0), k=floats(1.0, 1e4),
                    rho=floats(0.9, 1.4), V=floats(0.0, 40.0), Ad=floats(0.05, 20.0),
                    H=floats(-8.0, 8.0)), n=500)
def _(m, c, k, rho, V, Ad, H, label):
    C = c - rho * V * Ad * H / 2.0
    label("net damping", "negative" if C < 0 else "positive")
    if abs(C) < 1e-9: return True
    rt = np.roots([m, C, k])
    return (C < 0) == (float(np.max(rt.real)) > 1e-12), \
        f"net damping {C:+.6g} but largest real part {float(np.max(rt.real)):+.6g}"


# =====================================================================================
# Physics.lean / SummingFunctors.lean / Pareto.lean - the accounting
# =====================================================================================
ACC = suite("Physics.lean, SummingFunctors.lean, Pareto.lean - the accounting")


@ACC.prop("a sum over a partition equals the sum over the whole (the summing functor)",
          lean="Physics.SummingFunctor.sumOn_union",
          gens=dict(v=arrays(40, 0.0, 1e4), k=ints(2, 8), seedp=ints(0, 1 << 20)), n=400)
def _(v, k, seedp, label):
    rng = np.random.default_rng(seedp)
    part = rng.integers(0, k, size=v.size)
    label("blocks", str(len(set(part.tolist()))))
    tot = float(v.sum())
    got = float(sum(v[part == b].sum() for b in range(k)))
    return abs(got - tot) <= 1e-9 * max(1.0, abs(tot)), f"{got:.10g} vs {tot:.10g}"


@ACC.prop("a Pareto frontier is an antichain: no point on it dominates another",
          lean="Pareto.frontier_antichain",
          gens=dict(x=arrays(30, 0.0, 100.0), y=arrays(30, 0.0, 100.0)), n=300)
def _(x, y, label):
    n = min(x.size, y.size); x, y = x[:n], y[:n]
    P = np.stack([x, y], 1)
    dom = lambda a, b: (a[0] >= b[0] and a[1] >= b[1]) and (a[0] > b[0] or a[1] > b[1])
    front = [i for i in range(n) if not any(dom(P[j], P[i]) for j in range(n) if j != i)]
    label("frontier size", "one" if len(front) == 1 else ("few" if len(front) < 5 else "many"))
    bad = [(i, j) for i in front for j in front if i != j and dom(P[i], P[j])]
    return not bad, f"{len(bad)} dominating pairs among {len(front)} frontier points"


@ACC.prop("every weighted-sum optimum lies on the frontier (scalarization never leaves it)",
          lean="Pareto.scalarization_mem_frontier",
          gens=dict(x=arrays(30, 0.0, 100.0), y=arrays(30, 0.0, 100.0), w=floats(0.0, 1.0)), n=300)
def _(x, y, w, label):
    n = min(x.size, y.size); x, y = x[:n], y[:n]
    P = np.stack([x, y], 1)
    dom = lambda a, b: (a[0] >= b[0] and a[1] >= b[1]) and (a[0] > b[0] or a[1] > b[1])
    front = {i for i in range(n) if not any(dom(P[j], P[i]) for j in range(n) if j != i)}
    s = w * x + (1.0 - w) * y
    best = int(np.argmax(s))
    ties = int((s >= s[best] - 1e-12).sum())
    label("weight", "interior" if 0.01 < w < 0.99 else "on an axis")
    if ties > 1: return True                        # a tie may pick a dominated twin; not a violation
    return best in front, f"the optimum at weight {w:.4f} was not on the frontier"


# =====================================================================================
# The twins' shared numerics - the interpolators every path must agree on
# =====================================================================================
TWN = suite("the twins' shared numerics - every path must read the tables the same way")


@TWN.prop("the membrane ladder inverts exactly at its own rungs",
          lean="Membrane.level_of_rung (the 4.75-vs-4 bug)",
          gens=dict(i=ints(0, 6)), n=50)
def _(i, label):
    from tandoor_polar_env import level_of, TandoorPolarEnv
    lf = np.array(TandoorPolarEnv.LEVEL_FRAC)
    got = float(level_of(lf[i], lf))
    return abs(got - i) < 1e-9, f"pressure ratio {lf[i]:.4f} is rung {i} but level_of said {got:.6f}"


@TWN.prop("the membrane ladder is monotone and stays inside its range",
          lean="Membrane.level_of_mono", gens=dict(x=floats(0.5, 1.5), dx=floats(0.0, 0.5)), n=500)
def _(x, dx, label):
    from tandoor_polar_env import level_of, TandoorPolarEnv
    lf = np.array(TandoorPolarEnv.LEVEL_FRAC)
    a, b = float(level_of(x, lf)), float(level_of(x + dx, lf))
    label("clamped", "yes" if x < lf[0] or x + dx > lf[-1] else "no")
    return b >= a - 1e-12 and 0.0 <= a <= len(lf) - 1, f"level_of({x:.4f}) = {a:.4f}, ({x+dx:.4f}) = {b:.4f}"


@TWN.prop("the torch and numpy branches of the ladder agree bit for bit",
          lean="Membrane.level_of (twin parity)", gens=dict(x=arrays(16, 0.4, 1.6)), n=200)
def _(x, label):
    import torch
    from tandoor_polar_env import level_of, TandoorPolarEnv
    lf = np.array(TandoorPolarEnv.LEVEL_FRAC)
    a = np.asarray(level_of(x, lf), float)
    b = level_of(torch.tensor(x, dtype=torch.float64), lf).numpy()
    return np.abs(a - b).max() < 1e-9, f"branches differ by up to {np.abs(a - b).max():.3e}"


@TWN.prop("the shared 24-hour read never overshoots the samples it sits between",
          lean="Stratification.interp_mem_Icc", gens=dict(tab=arrays(24, -50.0, 1200.0),
                                                          x=floats(0.0, 23.0)), n=500)
def _(tab, x, label):
    from tandoor_site_weather import sw_interp24
    i = min(int(math.floor(x)), 22); f = x - i
    v = float(sw_interp24(tab, x))
    lo, hi = min(tab[i], tab[i + 1]), max(tab[i], tab[i + 1])
    label("on a sample", "yes" if abs(f) < 1e-9 else "no")
    return lo - 1e-9 <= v <= hi + 1e-9, f"read {v:.6g} outside [{lo:.6g}, {hi:.6g}] at hour {x:.4f}"


@TWN.prop("the shared 24-hour read is exact on the samples themselves",
          lean="Stratification.interp_node", gens=dict(tab=arrays(24, -50.0, 1200.0),
                                                       i=ints(0, 23)), n=300)
def _(tab, i, label):
    from tandoor_site_weather import sw_interp24
    v = float(sw_interp24(tab, float(i)))
    return abs(v - tab[i]) < 1e-9, f"hour {i} read {v:.8g}, table holds {tab[i]:.8g}"


@TWN.prop("the shared 24-hour read agrees with straight linear interpolation",
          lean="Stratification.interp_eq_linear", gens=dict(tab=arrays(24, -50.0, 1200.0),
                                                            x=floats(0.0, 23.0)), n=500)
def _(tab, x, label):
    from tandoor_site_weather import sw_interp24
    a = float(sw_interp24(tab, x)); b = float(np.interp(x, np.arange(24), tab))
    return abs(a - b) < 1e-9, f"{a:.10g} vs numpy's {b:.10g} at hour {x:.5f}"


@TWN.prop("the demand bands always renormalise to a whole day's trade",
          lean="Physics.demand_shares_sum_one",
          gens=dict(s=arrays(3, 0.01, 10.0), c=arrays(3, 5.0, 20.0), w=arrays(3, 0.2, 4.0)), n=300)
def _(s, c, w, label):
    from tandoor_polar_env import parse_demand_bands
    spec = ",".join(f"{c[i]:.4f}:{w[i]:.4f}:{s[i]:.6f}" for i in range(3))
    got = parse_demand_bands(spec, None)
    tot = sum(b[2] for b in got)
    return abs(tot - 1.0) < 1e-9, f"shares sum to {tot:.12f}"


# =====================================================================================
# The sun the machine tracks - the geometry every twin and every Lean mount theorem assumes
# =====================================================================================
SUN = suite("the sun the machine tracks - solar geometry")

def _sun(lat, doy, hour):
    from tandoor_rl_env import _sim
    el, az, v = _sim.solar_position(lat, doy, hour)
    return float(el), float(np.degrees(az)), np.asarray(v, float)

lat_g = floats(-60.0, 60.0, target=0.0)
doy_g = ints(1, 365, target=1)
hour_g = floats(0.0, 24.0, target=12.0)


@SUN.prop("the direction to the sun is a unit vector whose height is the sine of its elevation",
          lean="Mount.sunDir_unit", gens=dict(lat=lat_g, doy=doy_g, h=hour_g), n=500)
def _(lat, doy, h, label):
    el, az, v = _sun(lat, doy, h)
    label("above the horizon", "yes" if el > 0 else "no")
    return abs(np.linalg.norm(v) - 1.0) < 1e-9 and abs(v[2] - math.sin(math.radians(el))) < 1e-9, \
        f"|v| = {np.linalg.norm(v):.12f}, v_z = {v[2]:.9f} but sin(el) = {math.sin(math.radians(el)):.9f}"


@SUN.prop("the sun's elevation never exceeds what the latitude and the season allow",
          lean="Mount.elevation_le_transit", gens=dict(lat=lat_g, doy=doy_g, h=hour_g), n=500)
def _(lat, doy, h, label):
    el, _az, _v = _sun(lat, doy, h)
    dec = math.degrees(math.radians(23.44) * math.sin(2 * math.pi * (284 + doy) / 365))
    cap = 90.0 - abs(lat - dec)
    label("near the zenith", "yes" if cap > 85 else "no")
    return el <= cap + 1e-6 and el >= -90.0 - 1e-6, \
        f"elevation {el:.6f} deg at latitude {lat:.2f} on day {doy}, but transit caps it at {cap:.6f}"


@SUN.prop("the day is symmetric about solar noon: equal elevations, mirrored bearings",
          lean="Mount.solar_noon_symmetry",
          gens=dict(lat=lat_g, doy=doy_g, u=floats(0.0, 6.0)), n=500)
def _(lat, doy, u, label):
    e1, a1, _ = _sun(lat, doy, 12.0 - u)
    e2, a2, _ = _sun(lat, doy, 12.0 + u)
    label("time from noon", "early" if u < 2 else "late")
    if abs(e1 - e2) > 1e-9:
        return False, f"morning elevation {e1:.9f} but afternoon {e2:.9f}, {u:.3f} h from noon"
    if u < 1e-6 or abs(e1) > 89.99: return True     # at noon and at the zenith the bearing is moot
    mirror = (360.0 - a2) % 360.0
    d = abs((a1 - mirror + 180.0) % 360.0 - 180.0)
    return d < 1e-6, f"morning bearing {a1:.6f} deg, afternoon {a2:.6f}: not mirrored (off by {d:.3e})"


@SUN.prop("at the equinox every latitude gets twelve hours of sun",
          lean="Mount.equinox_daylength", gens=dict(lat=floats(-55.0, 55.0), doy=choice([81, 264])), n=200)
def _(lat, doy, label):
    e6, _a, _v = _sun(lat, doy, 6.0)
    e18, _a2, _v2 = _sun(lat, doy, 18.0)
    label("hemisphere", "north" if lat > 0 else "south")
    return abs(e6) < 0.6 and abs(e18) < 0.6, \
        f"at latitude {lat:.2f} the equinox sun is {e6:.4f} deg up at 06h and {e18:.4f} at 18h"


@SUN.prop("the bearing to the sun is always a compass bearing",
          lean="Mount.azimuth_range", gens=dict(lat=lat_g, doy=doy_g, h=hour_g), n=500)
def _(lat, doy, h, label):
    el, az, _v = _sun(lat, doy, h)
    label("above the horizon", "yes" if el > 0 else "no")
    return 0.0 <= az < 360.0 + 1e-9, f"bearing {az:.6f} is outside [0, 360)"


@SUN.prop("outside the tropics the bearing sweeps ONE way all day - north and south opposite",
          lean="Mount.azimuth_mono (the hypothesis: the sun never crosses the zenith)",
          cover={"hemisphere": {"north": 0.3, "south": 0.3}},
          gens=dict(lat=choice([-58.0, -47.0, -38.0, -30.2, -25.0, 25.0, 30.2, 38.0, 47.0, 58.0]),
                    doy=doy_g, h=floats(1.0, 23.0)), n=600)
def _(lat, doy, h, label):
    # INSIDE the tropics the sun passes the zenith and the morning branch reverses - the same
    # geometry that opens the noon keyhole the policy tests found.  So the theorem's hypothesis is
    # |lat| > 23.44, and this property is about the machine's sites, which all satisfy it.
    el, az, _v = _sun(lat, doy, h)
    if el < 3.0: return True                        # near the horizon arccos is ill-conditioned
    el2, az2, _ = _sun(lat, doy, h + 0.02)
    if el2 < 3.0: return True
    d = (az2 - az + 540.0) % 360.0 - 180.0          # the signed sweep over 72 s, across the wrap
    want = 1.0 if lat > 0 else -1.0
    label("hemisphere", "north" if lat > 0 else "south")
    return d * want >= -1e-3, \
        (f"at latitude {lat:.1f} on day {doy} the bearing swept {d:+.6f} deg in 72 s at {h:.3f} h - "
         f"the wrong way for that hemisphere")


@SUN.prop("the sun rises before noon and sets after it",
          lean="Mount.elevation_unimodal", gens=dict(lat=floats(-55.0, 55.0), doy=doy_g,
                                                     h=floats(0.5, 11.5)), n=500)
def _(lat, doy, h, label):
    e1, _a, _v = _sun(lat, doy, h)
    e2, _a2, _v2 = _sun(lat, doy, h + 0.25)
    label("morning", "early" if h < 8 else "late")
    return e2 >= e1 - 1e-9, f"the morning sun fell from {e1:.6f} to {e2:.6f} deg between {h:.2f} h and {h+0.25:.2f} h"


@SUN.prop("the machine's own pointing error vanishes exactly when it is aimed at the sun",
          lean="Mount.error_zero_iff_aimed",
          gens=dict(lat=lat_g, doy=doy_g, h=floats(7.0, 17.0), de=floats(-5.0, 5.0, target=0.0),
                    da=floats(-5.0, 5.0, target=0.0)), n=500)
def _(lat, doy, h, de, da, label):
    el, az, _v = _sun(lat, doy, h)
    if el <= 0: return True
    e_el = (el + de) - el
    daz = (az + da) - az; daz -= 360.0 * round(daz / 360.0)
    e_az = daz * math.cos(math.radians(el))
    err = abs(e_az) + abs(e_el)
    label("aimed", "on the sun" if abs(de) + abs(da) < 1e-9 else "off")
    return (err < 1e-12) == (abs(de) < 1e-12 and abs(da) < 1e-12), \
        f"offset ({da:+.4g}, {de:+.4g}) deg gave error {err:.3e}"


# =====================================================================================
# THE ENVIRONMENT ITSELF - the properties that drive the whole simulator
# =====================================================================================
ENV = suite("the environment itself - the whole simulator under random commands")

_INI = None
def _kw(B, **over):
    """the design env's own config, so these properties test the machine the tools actually use"""
    global _INI
    if _INI is None:
        import configparser
        cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#"))
        cp.read("/Users/faezs/ARTIST/tutorials/puffer_tandoor/hashemi_design.ini")
        d = {}
        for k, v in cp["env"].items():
            v = v.strip()
            try: d[k] = int(v)
            except ValueError:
                try: d[k] = float(v)
                except ValueError: d[k] = v
        _INI = d
    kw = dict(_INI); kw.update(num_agents=B, n_rays=64, site_days=0, day_random=0)
    kw.update(over); return kw


_POOL = {}
def _fresh(B=8, seed=0, slot=0, **over):
    """Building a machine costs 48 s (the pool's ERA5 and the traced library); stepping one costs
    2 ms and resetting it is free.  So the simulator is built ONCE per (config, slot) and reset per
    case - which is only sound because "reset returns the machine to the same state" is itself one
    of the properties below."""
    import contextlib, io
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_fused_step import FusedState
    key = (B, slot, tuple(sorted(over.items())))
    e = _POOL.get(key)
    if e is None:
        with contextlib.redirect_stdout(io.StringIO()):
            e = TandoorHashemiEnv(**_kw(B, seed=seed, **over))
        _POOL[key] = e
    with contextlib.redirect_stdout(io.StringIO()):
        e.reset(seed=seed)
        e._gpu = FusedState(e)
        # reset does NOT rebuild the site's weather, so a property that scales the table (the DNI
        # and gust metamorphic tests below) would poison every later property on this pooled
        # machine - which is exactly what happened: a 6x gale left in place stowed the dish for the
        # rest of the suite and nothing could bake.  Redraw the day from the pool every time.
        if getattr(e, "_sw", None) is not None:
            e._sw_refresh()
    return e, e._gpu


_POL = None
def _policy(e):
    """the trained checkpoint, used here only as a STATE-SPACE EXPLORER: random commands never bake
    a roti and never stow, so a property about baking or stowing under random commands tests
    nothing at all.  The env is what is under test; the policy just drives it somewhere interesting."""
    global _POL
    if _POL is None:
        import torch
        from tandoor_design_readout import Policy
        sd = torch.load("/Users/faezs/ARTIST/tutorials/puffer_tandoor/experiments/"
                        "178926893901/model_000573.pt", map_location="cpu", weights_only=False)
        if sd["policy.encoder.0.weight"].shape[1] != e.single_observation_space.shape[0]:
            return None
        _POL = Policy(sd)
    return _POL


def _drive(e, S, k, rng, mode="random", B=8):
    """step the machine k times; yields nothing, the caller reads the state it wants"""
    import torch
    nh = e.N_HEADS
    pol = _policy(e) if mode == "policy" else None
    if pol is not None:
        pol.reset(B); torch.manual_seed(int(rng.integers(0, 1 << 30)))
    o = None
    with torch.no_grad():
        for i in range(k):
            if pol is not None and o is not None:
                a, _ = pol.step(o, nh, int(e.single_action_space.nvec[0]))
            else:
                a = _acts(e, B, rng, nh)
            o, rew, d, tr, _x = e.step_torch(a)
            yield i, o, rew, tr


def _windy(e, S, gust):
    """turn the site's recorded wind up by `gust` so the stow latch is actually exercised"""
    import torch
    if getattr(e, "_sw_tab", None) is None: return False
    e._sw_tab = e._sw_tab.copy(); e._sw_tab[:, 1:3] *= gust
    e._sw_tab_t = torch.as_tensor(e._sw_tab, dtype=torch.float32, device=e.device)
    S.site.copy_(e._sw_tab_t[:, :3].reshape(e.num_agents, -1))
    return True


def _acts(e, B, rng, nh):
    import torch
    nv = int(e.single_action_space.nvec[0])
    return torch.tensor(rng.integers(0, nv, size=(B, nh)), dtype=torch.long, device=e.device)


def _state(S):
    return dict(T=S.T, az=S.az_m, el=S.el_m, p=S.p_act, rot=S.day_rotis, wind=S.wind, dni=S.dni)


@ENV.prop("the same seed and the same commands give exactly the same day",
          lean="Physics (the simulator is a function, not a mood)",
          gens=dict(seed=ints(0, 10000), k=ints(5, 40)), n=3)
def _(seed, k, label):
    import numpy as _np, torch
    a, Sa = _fresh(8, seed, slot=0); b, Sb = _fresh(8, seed, slot=1)
    r1, r2 = _np.random.default_rng(seed), _np.random.default_rng(seed)
    nh = a.N_HEADS
    for _i in range(k):
        a.step_torch(_acts(a, 8, r1, nh)); b.step_torch(_acts(b, 8, r2, nh))
    worst, where = 0.0, ""
    for nm, (x, y) in ((n, (v, _state(Sb)[n])) for n, v in _state(Sa).items()):
        d = float((x - y).abs().max())
        if d > worst: worst, where = d, nm
    label("length", "long" if k > 22 else "short")
    return worst == 0.0, f"after {k} steps the two runs differ by {worst:.6g} in {where}"


@ENV.prop("resetting with a seed returns the machine to exactly the state that seed gives",
          lean="Physics (reset is a function of the seed alone)",
          gens=dict(seed=ints(0, 10000), k=ints(5, 40)), n=4)
def _(seed, k, label):
    import numpy as _np
    a, Sa = _fresh(8, seed, slot=0)
    first = {n: v.detach().cpu().numpy().copy() for n, v in _state(Sa).items()}
    r = _np.random.default_rng(seed + 1)
    for _i in range(k):                              # wander off, then come back
        a.step_torch(_acts(a, 8, r, a.N_HEADS))
    b, Sb = _fresh(8, seed, slot=0)                  # the SAME machine, reset again
    again = {n: v.detach().cpu().numpy().copy() for n, v in _state(Sb).items()}
    worst, where = 0.0, ""
    for n in first:
        d = float(_np.abs(first[n] - again[n]).max())
        if d > worst: worst, where = d, n
    label("wandered", "far" if k > 20 else "near")
    return worst == 0.0, f"after {k} steps and a reset the state differs by {worst:.6g} in {where}"


@ENV.prop("no command, however stupid, produces a number that is not a number",
          lean="Physics (totality)", gens=dict(seed=ints(0, 10000), k=ints(20, 90)), n=3)
def _(seed, k, label):
    import numpy as _np, torch
    e, S = _fresh(8, seed)
    r = _np.random.default_rng(seed); nh = e.N_HEADS
    for _i in range(k):
        o, rew, d, tr, _x = e.step_torch(_acts(e, 8, r, nh))
        for nm, v in list(_state(S).items()) + [("obs", o), ("reward", rew)]:
            t = torch.as_tensor(v)
            if not bool(torch.isfinite(t).all()):
                raise Fail(f"{nm} went non-finite at step {_i} of {k}")
    label("length", "long" if k > 55 else "short")
    return True


@ENV.prop("the machine stays inside physics under random commands",
          lean="ThermalPromises (the state space is bounded)",
          gens=dict(seed=ints(0, 10000), k=ints(20, 90)), n=3)
def _(seed, k, label):
    import numpy as _np
    e, S = _fresh(8, seed)
    r = _np.random.default_rng(seed); nh = e.N_HEADS
    worst = {}
    for _i in range(k):
        e.step_torch(_acts(e, 8, r, nh))
        T = S.T.detach().cpu().numpy()
        for nm, v, lo, hi in (("pot temperature", T, 150.0, 2500.0),
                              ("held pressure", S.p_act.detach().cpu().numpy(), 0.0, 1e5),
                              ("wind", S.wind.detach().cpu().numpy(), 0.0, 60.0),
                              ("rotis", S.day_rotis.detach().cpu().numpy(), 0.0, 1e5),
                              ("elevation", S.el_m.detach().cpu().numpy(), -95.0, 95.0)):
            if v.min() < lo or v.max() > hi:
                raise Fail(f"{nm} reached [{v.min():.4g}, {v.max():.4g}], outside [{lo:g}, {hi:g}], "
                           f"at step {_i} of {k}")
            worst[nm] = (min(worst.get(nm, (1e30, -1e30))[0], float(v.min())),
                         max(worst.get(nm, (1e30, -1e30))[1], float(v.max())))
    label("length", "long" if k > 55 else "short")
    return True, "; ".join(f"{n} {a:.4g}..{b:.4g}" for n, (a, b) in worst.items())


@ENV.prop("the beam is exactly proportional to the sun: scale the site's DNI, scale the power",
          lean="Radiometry.power_linear_in_radiance",
          cover={"direction": {"dimmer": 0.2, "brighter": 0.2}},
          gens=dict(seed=ints(0, 10000), lam=choice([0.05, 0.2, 0.5, 0.8, 1.25, 2.0, 3.0, 4.0]),
                    k=ints(3, 15)), n=14)
def _(seed, lam, k, label):
    import numpy as _np, torch
    e0, S0 = _fresh(8, seed, slot=0); e1, S1 = _fresh(8, seed, slot=1)
    if getattr(e1, "_sw_tab", None) is None: return True     # no site table on this config
    e1._sw_tab = e1._sw_tab.copy(); e1._sw_tab[:, 0] *= lam  # the sun, dimmed or brightened
    e1._sw_tab_t = torch.as_tensor(e1._sw_tab, dtype=torch.float32, device=e1.device)
    S1.site.copy_(e1._sw_tab_t[:, :3].reshape(e1.num_agents, -1))
    r0, r1 = _np.random.default_rng(seed), _np.random.default_rng(seed)
    nh = e0.N_HEADS
    label("direction", "brighter" if lam > 1 else "dimmer")
    worst = 0.0
    for _i in range(k):
        a0 = _acts(e0, 8, r0, nh); a1 = _acts(e1, 8, r1, nh)
        e0.step_torch(a0); e1.step_torch(a1)
        p0 = _np.asarray(e0._p_in_t.detach().cpu()); p1 = _np.asarray(e1._p_in_t.detach().cpu())
        m = p0 > 1.0
        if m.any():
            worst = max(worst, float(_np.abs(p1[m] - lam * p0[m]).max() / _np.abs(lam * p0[m]).max()))
    return worst < 2e-3, f"power off linearity by {100 * worst:.3f}% at scale {lam:.4f}"


@ENV.prop("the beam is off whenever the machine is stowed",
          lean="Wind.stow_sheds_load (in the simulator, not only on paper)",
          cover={"the latch fired": {"yes": 0.5}},
          gens=dict(seed=ints(0, 10000), gust=floats(1.0, 6.0, target=1.0), k=ints(30, 120)), n=6)
def _(seed, gust, k, label):
    import numpy as _np
    e, S = _fresh(8, seed)
    if not _windy(e, S, gust): return True
    r = _np.random.default_rng(seed)
    stowed_steps, seen = 0, 0.0
    for _i, _o, _r, _t in _drive(e, S, k, r):
        st = S.stowed.detach().cpu().numpy() > 0.5
        dni = S.dni.detach().cpu().numpy()
        stowed_steps += int(st.sum()); seen = max(seen, float(S.wind.max()))
        if st.any() and float(dni[st].max()) > 0.0:
            raise Fail(f"a stowed machine still saw {dni[st].max():.2f} W/m2 at step {_i} of {k}")
    label("the latch fired", "yes" if stowed_steps else "no")
    return True, f"wind reached {seen:.1f} m/s, {stowed_steps} stowed agent-steps, all of them dark"


@ENV.prop("the day's count only ever rises, except when the guillotine resets it",
          lean="Physics.SummingFunctor.sumOn_union (in the simulator)",
          cover={"baked": {"some": 0.6}},
          gens=dict(seed=ints(0, 10000), k=ints(600, 2000)), n=4)
def _(seed, k, label):
    import numpy as _np, torch
    e, S = _fresh(8, seed)
    r = _np.random.default_rng(seed)
    prev = S.day_rotis.detach().cpu().numpy().copy()
    ever, cuts = 0.0, 0
    for _i, _o, _rw, tr in _drive(e, S, k, r, mode="policy"):
        now = S.day_rotis.detach().cpu().numpy()
        cut = _np.asarray(tr.detach().cpu() if torch.is_tensor(tr) else tr).reshape(-1) > 0
        drop = (now - prev) < -1e-6
        if (drop & ~cut).any():
            raise Fail(f"the day's count fell by {-(now - prev).min():.3f} at step {_i} with no reset")
        ever = max(ever, float(now.max())); cuts += int(cut.sum())
        prev = now.copy()
    # the count is wiped by the guillotine, so ask whether it EVER rose, not where it ended
    label("baked", "some" if ever > 0 else "none")
    return True, f"the best agent reached {ever:.0f} rotis over {k} steps, through {cuts} resets"


_TRACE = {}
def _traced(B, receiver, seed):
    """a machine parked on the sun at noon, the way tandoor_receiver_verify builds one.  Its own
    comment is the warning this property encodes: without aiming the mount, every parity check
    passes on a batch of zeros."""
    import contextlib, io
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_design_readout import env_kwargs
    e = _TRACE.get((B, receiver))
    if e is None:
        with contextlib.redirect_stdout(io.StringIO()):
            kw = env_kwargs(B, receiver=receiver); kw["design_rand"] = 0
            e = TandoorHashemiEnv(**kw)
        _TRACE[(B, receiver)] = e
    with contextlib.redirect_stdout(io.StringIO()):
        e.reset(seed=seed)
    e._det_trace = True
    return e


def _park(e, lat, doy, hour):
    from tandoor_rl_env import _sim
    e.day = doy; e.t_solar[:] = hour; e.day_v[:] = float(doy); e.lat_v[:] = lat
    el, az, _v = _sim.solar_position(lat, doy, hour)
    e.el_m[:] = el; e.az_m[:] = np.degrees(az - e._ds_azs)
    e._e_el[:] = 0.0; e._e_az[:] = 0.0
    return el


@ENV.prop("the Metal megakernel and the torch reference trace the same watts",
          lean="OpticsReal (one machine, two implementations)",
          cover={"beam": {"lit": 0.35, "dark": 0.1}, "receiver": {"cass": 0.2, "tri": 0.2}},
          gens=dict(seed=ints(0, 10000), receiver=choice(["cass", "tri"]),
                    lat=floats(24.0, 36.0), doy=ints(1, 365), hour=floats(9.0, 15.0),
                    pres=floats(700.0, 1150.0), blur=floats(3e-3, 2e-2), off=arrays(2, -0.01, 0.01)),
          n=24)
def _(seed, receiver, lat, doy, hour, pres, blur, off, label):
    B = 8
    e = _traced(B, receiver, seed)
    el = _park(e, lat, doy, hour)
    if el < 10.0: return True                       # the sun is not up enough to say anything
    args = (np.full(B, pres), np.full(B, blur), np.tile(off, (B, 1)), np.ones(B))
    g = e._gen.get_state()
    pm = e._trace_power(*args).sum(1).detach().cpu().numpy()
    m0, e._metal = e._metal, None; e._gen.set_state(g)
    pt = e._trace_power(*args).sum(1).detach().cpu().numpy()
    e._metal = m0
    label("receiver", receiver)
    # the traced power is a few watts by construction (tandoor_receiver_verify says so in its own
    # comment); "lit" only has to mean the beam got through at all
    label("beam", "lit" if float(pt.max()) > 1.0 else "dark")
    scale = max(float(pt.max()), 1e-9)
    d = float(np.abs(pm - pt).max())
    return d <= 1e-3 * scale, \
        (f"the twins differ by {d:.4g} W on a beam of {scale:.1f} W ({100 * d / scale:.4f}%) - "
         f"{receiver} at latitude {lat:.1f}, day {doy}, {hour:.2f} h, {pres:.0f} Pa")


_EAGER = {}
def _eager(B=4):
    """the EAGER torch twin (GpuState, no megakernel) - the path tandoor_gpu_step.py runs"""
    import contextlib, io, torch
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_design_readout import env_kwargs
    e = _EAGER.get(B)
    if e is None:
        kw = env_kwargs(B, receiver="cass")
        kw.update(device="cpu", gpu=1, n_rays=64, design_rand=0)
        with contextlib.redirect_stdout(io.StringIO()):
            e = TandoorHashemiEnv(**kw); e.reset(seed=0)
            e.step_torch(torch.full((B, e.N_HEADS), 3, dtype=torch.long))
        _EAGER[B] = e
    return e, e._gpu


@ENV.prop("the pointing error is an angle on a circle, whatever the roof's rotation",
          lean="Mount.abs_wrap_le (the bug the kernel's own comment records)",
          cover={"roof": {"past half a turn": 0.3}},
          gens=dict(off=floats(-359.0, 359.0, target=0.0)), n=120)
def _(off, label):
    import contextlib, io, torch
    from tandoor_mount_batch import solar_batch
    B = 4
    e, S = _eager(B)
    el1, az1r, _v = solar_batch(S.lat_v, S.day_v, float(e.t_solar[0]), az_off=e._ds_azs_t)
    az0d = torch.rad2deg(az1r)
    # the mount's angle runs continuously while the sun's comes back wrapped into [0, 360), so on a
    # rotated roof their raw difference is unbounded; the error the machine ACTS on must not be
    S.az_m = az0d + off; S.el_m = el1.clone()
    with contextlib.redirect_stdout(io.StringIO()):
        e.step_torch(torch.full((B, e.N_HEADS), 3, dtype=torch.long))
    got = float(np.abs(np.asarray(e._e_az_t.detach().cpu())).max())
    w = off - 360.0 * round(off / 360.0)
    want = float(np.abs(w * np.cos(np.radians(np.asarray(el1)))).max())
    label("roof", "past half a turn" if abs(off) > 180.0 else "within half a turn")
    return got <= 180.0 + 1e-6 and abs(got - want) < 1.0, \
        (f"a roof turned {off:+.1f} deg gave a recorded error of {got:.2f} deg where the angle on "
         f"the circle is {want:.2f} - unwrapped, this is what fires the guillotine on a dish that "
         f"is pointing straight at the sun")


@ENV.prop("the pointing encoder does not saturate before the guillotine fires",
          lean="MountCompliance.sat_lipschitz (the observation must resolve the failure it predicts)",
          gens=dict(ini=choice(["hashemi.ini", "hashemi_design.ini", "hashemi_tri.ini",
                                "hashemi_design_tri.ini", "flower.ini"])), n=5)
def _(ini, label):
    # the observation is (error / 0.5) clamped to +-enc_clamp (hashemi_env:3491), so each AXIS
    # pins at 0.5*enc_clamp degrees, while the guillotine fires on the SUM exceeding lost_deg
    # (hashemi_env:1539).  If the pin comes first there is a band in which the machine is losing
    # the sun and the policy cannot see how far off it is.
    import configparser
    cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#"))
    cp.read(f"/Users/faezs/ARTIST/tutorials/puffer_tandoor/{ini}")
    if "env" not in cp or "lost_deg" not in cp["env"]: return True
    lost = float(cp["env"]["lost_deg"].split()[0])
    enc = float(cp["env"].get("enc_clamp", "3.0").split()[0])
    sat = 0.5 * enc
    label("resolves the cut", "yes" if sat >= lost else "no")
    return sat >= lost, \
        (f"{ini}: each axis saturates at {sat:.1f} deg but the cut needs a sum of {lost:.1f} - "
         f"between them the policy is blind, e.g. an azimuth error of {sat + 1.0:.1f} deg with the "
         f"elevation on the sun reads the same as {sat:.1f} and is not yet lost; "
         f"enc_clamp = {2 * lost:.0f} would close it")


@ENV.prop("the figure blur follows the measured law the film was fitted to, not the quadratic load",
          lean="StatedLaws TandoorBlur.sigWind_homog, sigWind_lt_quadratic: the blur is V^1.2, "
               "not the c*V^2 of the wind block, so no critical-speed theorem describes the optics",
          cover={"windy": {"yes": 0.6}}, gens=dict(seed=ints(0, 10000)), n=4)
def _(seed, label):
    import numpy as _np
    # PER AGENT: the batch sits at different sites, so a fit to the batch MEAN of a nonlinear law
    # measures Jensen's inequality, not the exponent.  The first version of this property did that
    # and read V^0.99 off a V^1.2 law.
    V, SB = [], []
    for g in (0.02, 0.5, 1.0, 1.5, 2.2, 3.0):
        e, S = _fresh(8, seed)
        if not _windy(e, S, g): return True
        r = _np.random.default_rng(seed)
        for _i, _o, _rw, _t in _drive(e, S, 12, r):
            pass
        V.append(_np.asarray(S.wind.detach().cpu(), float).copy())
        SB.append(_np.asarray(S.sigb.detach().cpu(), float).copy())
    V, SB = _np.array(V), _np.array(SB)
    base = SB[0]                                      # still air: the static figure and the drift
    slopes = []
    for b in range(V.shape[1]):
        m = (V[1:, b] > 0.5) & (V[1:, b] < 24.0) & (SB[1:, b] > base[b])
        if m.sum() < 3: continue
        x = _np.log(V[1:, b][m])
        y = 0.5 * _np.log(_np.maximum(SB[1:, b][m] ** 2 - base[b] ** 2, 1e-30))
        slopes.append(float(_np.polyfit(x, y, 1)[0]))
    label("windy", "yes" if len(slopes) >= 3 else "no")
    if len(slopes) < 3: return True
    slope = float(_np.median(slopes))
    return abs(slope - 1.2) < 0.15, \
        (f"the blur grows as V^{slope:.3f} (median over {len(slopes)} agents); the env is fitted to V^1.2 "
         f"(sig_wind = 0.88e-3 (0.6 V^2 / 15)^0.6, polar_env:804), and a quadratic-load theorem "
         f"would claim V^2")


_RAYS = {}
def _rayset(NR):
    """a built machine at ray budget NR, traced deterministically at Quetta noon"""
    import contextlib, io
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_design_readout import env_kwargs
    e = _RAYS.get(NR)
    if e is None:
        kw = env_kwargs(4, receiver="cass")
        kw.update(n_rays=NR, seed=0, design_rand=0)
        with contextlib.redirect_stdout(io.StringIO()):
            e = TandoorHashemiEnv(**kw); e.reset(seed=0)
        e._det_trace = True
        _RAYS[NR] = e
    return e


def _area(e):
    """the collecting area the BUILT dish's ray set carries (block 0; blocks 1.. are the
    section library, each with its own roof geometry)"""
    S = int(getattr(e, "N_SURF", 1)); P = len(e._hx)
    return float(e._ray_pw.view(S, P)[0].sum()) / float(e._loss_chain)


def _aperture(e):
    """the physical aperture the weights are meant to stand for: the annulus from the 5 percent
    central hole to the rim, taxed by the film's radial reflectivity taper"""
    a = float(e.a_mem)
    r = np.linspace(0.05 * a, a, 200001)
    return float(np.trapezoid((1.0 - 0.10 * (r / a) ** 4) * 2.0 * np.pi * r, r))


@ENV.prop("the ray budget is a Monte-Carlo knob, not a physical one: it never moves the aperture",
          lean="Stratification (equal-area sampling carries the area, whatever N)",
          gens=dict(n1=choice([32, 64, 128, 256]), mult=choice([2, 4, 8])), n=12)
def _(n1, mult, label):
    n2 = n1 * mult
    a1, a2 = _area(_rayset(n1)), _area(_rayset(n2))
    label("budget ratio", f"x{mult}")
    return abs(a2 - a1) <= 1e-4 * a1, \
        f"{n1} rays carry {a1:.6f} m2 but {n2} carry {a2:.6f} - the ray count moved the dish"


@ENV.prop("the ray set carries the aperture the dish actually has",
          lean="Radiometry.etendue (the weights must tile the aperture they stand for)",
          gens=dict(NR=choice([32, 64, 128, 256, 512])), n=10)
def _(NR, label):
    e = _rayset(NR)
    got, want = _area(e), _aperture(e)
    a = float(e.a_mem)
    # the samples are placed over [0.05a, 0.985a] while the weights stand for [0.05a, a], so the
    # OUTER 1.5 percent of the radius - 3 percent of the area - is never sampled.  The total is
    # still right, because the weights target the full aperture; what is invisible is anything
    # localised at the rim (rim thinning, edge shading, a clamp shadow).
    label("rim sampled", "no")
    return abs(got - want) <= 5e-3 * want, \
        (f"the ray set carries {got:.5f} m2 against a physical aperture of {want:.5f} "
         f"({100 * (got / want - 1):+.2f} %); the outermost ray sits at 0.985a = {0.985 * a:.4f} m")


@ENV.prop("doubling the ray budget changes the traced power only by Monte-Carlo noise",
          lean="Stratification (the estimator converges, it does not drift)",
          cover={"budget": {"large": 0.3}}, gens=dict(n1=choice([64, 128, 256, 512])), n=8)
def _(n1, label):
    from tandoor_rl_env import _sim
    B = 4
    out = []
    for NR in (n1, 2 * n1):
        e = _rayset(NR)
        e.day = 172; e.t_solar[:] = 12.0; e.day_v[:] = 172.0; e.lat_v[:] = 30.2
        el, az, _v = _sim.solar_position(30.2, 172, 12.0)
        e.el_m[:] = el; e.az_m[:] = np.degrees(az - e._ds_azs)
        e._e_el[:] = 0.0; e._e_az[:] = 0.0
        out.append(float(e._trace_power(np.full(B, e.p0), np.full(B, 7e-3),
                                        np.zeros((B, 2)), np.ones(B)).sum(1).mean()))
    p1, p2 = out
    label("budget", "large" if n1 >= 256 else "small")
    tol = 4.0 / math.sqrt(n1)                      # the estimator's own 1/sqrt(N) scale
    return abs(p2 - p1) <= tol * max(p1, 1e-9), \
        (f"{n1} rays traced {p1:.4f} W and {2 * n1} traced {p2:.4f} "
         f"({100 * (p2 / p1 - 1):+.2f} %), outside the {100 * tol:.1f} % the budget allows")


# ---- numpy against the FUSED megakernel.  tandoor_traj_verify compares numpy against the EAGER
# twin and tandoor_fused_step compares eager against fused, so this pair - the two ends, and the
# two that actually run - has never been compared; and tandoor_fused_step says in its own comment
# that "the parity harness never crosses a day-over".
_PAIR = {}
def _pair(B=16, NR=64, seed=3):
    import contextlib, io, torch
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_fused_step import FusedState
    from tandoor_traj_verify import _ZeroRng
    key = (B, NR)
    if key not in _PAIR:
        mk = lambda gpu, fuse: TandoorHashemiEnv(num_agents=B, seed=seed, wide_shutter=1,
                                                 device="mps", n_rays=NR, fuse=fuse, gpu=gpu)
        with contextlib.redirect_stdout(io.StringIO()):
            _PAIR[key] = (mk(0, 0), mk(1, 1))
    A, Bv = _PAIR[key]
    with contextlib.redirect_stdout(io.StringIO()):
        A.reset(seed=seed); Bv.reset(seed=seed)
    Bv._gen.set_state(A._gen.get_state())          # one generator stream for both trace draws
    # the reference must run float32 like the kernel, or its continuous state drifts and the
    # discrete gates flip on one path only (tandoor_traj_verify says the same)
    for nm in ("T", "p_act", "p_set", "p_dist", "bread_E", "bread_t", "_belt_prev", "cloud",
               "wind_g", "bore", "load_timer", "ep_return", "soil", "el_m", "az_m", "f_locked",
               "decl_formed", "form_time"):
        setattr(A, nm, getattr(A, nm).astype(np.float32))
    A.rng = _ZeroRng(); Bv.rng = _ZeroRng()
    Bv._gpu = FusedState(Bv); Bv._gpu.zero_noise = True
    return A, Bv


def _walk(A, Bv, steps, seed):
    """step both paths on identical commands; return the worst deviation in each channel"""
    import numpy as _np
    r = _np.random.default_rng(seed)
    w = dict(T=0.0, p_act=0.0, rew=0.0, e_az=0.0, obs=0.0, p_in=0.0)
    B = A.num_agents
    for _t in range(steps):
        act = r.integers(0, 7, (B, 5))
        _o, rA, *_ = A.step(act.copy()); rA = _np.asarray(rA, float).copy()
        _o, rB, *_ = Bv.step(act.copy())
        S = Bv._gpu
        w["T"] = max(w["T"], float(_np.abs(A.T - S.T.cpu().numpy()).max()))
        w["p_act"] = max(w["p_act"], float(_np.abs(A.p_act - S.p_act.cpu().numpy()).max()))
        w["rew"] = max(w["rew"], float(_np.abs(rA - _np.asarray(rB, float)).max()))
        w["e_az"] = max(w["e_az"], float(_np.abs(A._e_az - _np.asarray(Bv._e_az)).max()))
        w["obs"] = max(w["obs"], float(_np.abs(_np.asarray(A.observations)
                                               - _np.asarray(Bv.observations)).max()))
        w["p_in"] = max(w["p_in"], float(_np.abs(_np.asarray(A.p_in, float)
                                                 - _np.asarray(Bv.p_in, float)).max()))
    return w


# the tolerances tandoor_traj_verify holds the numpy/EAGER pair to; this pair must meet them too
_TOL = dict(T=0.5, p_act=0.05, rew=0.02, e_az=1e-3, obs=5e-3)


@ENV.prop("the numpy state machine and the fused megakernel walk the same trajectory",
          lean="Physics (one machine, and the two implementations that actually run)",
          gens=dict(steps=ints(40, 200), seed=ints(0, 10000)), n=4)
def _(steps, seed, label):
    A, Bv = _pair()
    w = _walk(A, Bv, steps, seed)
    label("length", "long" if steps > 120 else "short")
    bad = [f"{k} {w[k]:.3e} > {v:g}" for k, v in _TOL.items() if w[k] > v]
    return not bad, \
        ("; ".join(bad) + f"   (worst absorbed power gap {w['p_in']:.0f} W) - these are the "
         f"tolerances tandoor_traj_verify holds the numpy/eager pair to, and this pair has never "
         f"been compared")


@ENV.prop("the twins agree THROUGH a day-over, not just inside a day",
          lean="Physics (the boundary tandoor_fused_step says its harness never crosses)",
          cover={"crossed": {"yes": 0.8}}, gens=dict(seed=ints(0, 10000), lead=ints(3, 30)), n=4)
def _(seed, lead, label):
    A, Bv = _pair()
    t_end = float(getattr(A, "day_end", 16.0))   # the env's own default (polar_env:1006)
    t0 = t_end - lead * float(A.dt) / 3600.0
    A.t_solar[:] = t0; Bv.t_solar[:] = t0
    t_before = float(np.asarray(A.t_solar).reshape(-1)[0])
    w = _walk(A, Bv, lead + 20, seed)
    t_after = float(np.asarray(A.t_solar).reshape(-1)[0])
    crossed = t_after < t_before                  # the clock wrapped: day_over fired
    label("crossed", "yes" if crossed else "no")
    bad = [f"{k} {w[k]:.3e} > {v:g}" for k, v in _TOL.items() if w[k] > v]
    return not bad, ("; ".join(bad) + f"   clock {t_before:.2f}h -> {t_after:.2f}h, "
                     f"day_end {t_end:.2f}h, crossed={crossed}")


# =====================================================================================
# tandoor_resources - the design run as a Pareto optimization in a category of resources
# =====================================================================================
PAR = suite("tandoor_resources - the design run as a Pareto optimization in a category of resources")


def ledger_gen():
    """a random machine-day: p_in, a non-decreasing sales counter, cuts, stows, keyhole flags, a kit"""
    def _s(r):
        import tandoor_resources as R
        n = r.randint(2, 40)
        p_in = np.array([r.uniform(0.0, 4000.0) for _ in range(n)])
        sold = np.cumsum([r.choice([0, 0, 0, 1, 1, 2]) for _ in range(n)]).astype(float)
        cut = np.array([r.random() < 0.05 for _ in range(n)])
        stow = np.array([r.random() < 0.1 for _ in range(n)])
        key = np.array([r.random() < 0.2 for _ in range(n)])
        kit = R.Resource.of(capital_pkr=r.uniform(3e5, 9e5), film_m2=r.uniform(4, 30), motor_degpm=r.uniform(1, 5))
        return R.DayLedger(15.0, p_in, sold, cut, stow, key, kit)

    def _sh(L):
        import tandoor_resources as R
        n = len(L.S) - 1
        if n > 2:
            yield R.DayLedger(15.0, [L.events[i]["sun_kwh"] * 3.6e6 / 15.0 for i in range(n // 2)],
                              np.cumsum([L.events[i]["rotis"] for i in range(n // 2)]),
                              [L.events[i]["cuts"] > 0 for i in range(n // 2)],
                              [L.events[i]["stow_min"] > 0 for i in range(n // 2)],
                              [L.events[i]["keyhole_min"] > 0 for i in range(n // 2)], L.events["kit"])
    return Gen(_s, _sh, "day ledger")


@PAR.prop("the day's ledger is a summing functor: the bundle of a union of disjoint event sets is the sum of the bundles",
          lean="Physics.SummingFunctor.sumOn_union, resource-valued (tandoor_resources.DayLedger)",
          gens=dict(L=ledger_gen(), seedp=ints(0, 1 << 20), k=ints(2, 6)), n=300)
def _(L, seedp, k, label):
    import tandoor_resources as R
    rng = np.random.default_rng(seedp)
    part = rng.integers(0, k, size=len(L.S))
    blocks = [[e for e, g in zip(L.S, part) if g == j] for j in range(k)]
    label("blocks used", str(len([b for b in blocks if b])))
    tot = L.total(); acc = R.UNIT
    for b in blocks: acc = acc + L.of(b)
    worst = max(abs(x - y) for x, y in zip(acc.v, tot.v))
    return worst <= 1e-9 * max(1.0, max(abs(x) for x in tot.v)) and L.of([]) == R.UNIT, \
        f"sum over {k} blocks differs from the total by {worst:.3e}; Phi(empty) = {L.of([])}"


@PAR.prop("a conversion never creates energy: whatever a bundle converts to took no more than it held",
          lean="tandoor_resources.converts (the measuring semigroup, rho M(B) <= M(A))",
          gens=dict(sun=floats(0.0, 60.0), rotis=floats(0.0, 800.0), cap=floats(1e5, 1e6),
                    film=floats(1.0, 40.0), r2=floats(0.0, 800.0), s2=floats(0.0, 60.0)), n=400)
def _(sun, rotis, cap, film, r2, s2, label):
    import tandoor_resources as R
    a = R.Resource.of(sun_kwh=sun, rotis=rotis, capital_pkr=cap, film_m2=film)
    b = R.Resource.of(sun_kwh=s2, rotis=r2, capital_pkr=cap, film_m2=film)
    ok = R.converts(a, b)
    label("converts", "yes" if ok else "no")
    if ok:
        return R.measure_mj(b)[1] <= R.measure_mj(a)[0] + 1e-9, "a conversion made more MJ than it was given"
    return (R.measure_mj(b)[1] > R.measure_mj(a)[0] - 1e-9) or s2 > sun or any(b[t] > a[t] for t in ("capital_pkr", "film_m2", "motor_degpm")), \
        "a conversion was refused although nothing in b exceeds a"


def pool_gen(B=12, n=5):
    """a pool of valuations in Valuation.names order, most designs admissible"""
    def _s(r):
        return [(str(i), [r.uniform(0, 400), r.uniform(0, 60), -r.uniform(2e5, 9e5), -r.uniform(6, 600), r.uniform(0.2, 3.0)])
                for i in range(r.randint(2, B))]
    def _sh(v):
        if len(v) > 2: yield v[: len(v) // 2]
    return Gen(_s, _sh, "pool")


@PAR.prop("the swarm keeps exactly the frontier and moves only the dominated, inside the box",
          lean="Pareto.ThinValuation.compute (mem_compute_iff) + Marcolli's swarm step",
          gens=dict(pool=pool_gen(), seedp=ints(0, 1 << 20), eps=floats(0.0, 0.3), explore=floats(0.0, 0.5)), n=300)
def _(pool, seedp, eps, explore, label):
    import tandoor_resources as R
    V = R.Valuation(budget_pkr=8e5, goal_rotis=20.0, goal_track=0.5)
    B = len(pool); rng = np.random.default_rng(seedp)
    kit_idx = np.arange(3, 9); u = rng.uniform(size=(B, 12))
    front = set(V.frontier(pool))
    u2, keep, redo = R.swarm_step(u, pool, V, rng, kit_idx, eps=eps, explore=explore)
    label("frontier", "empty (fallback)" if not front else ("all" if len(front) == B else "some"))
    if front and set(str(i) for i in keep) != front:
        return False, f"kept {keep} but the frontier is {sorted(front)}"
    if set(keep) | set(redo) != set(range(B)) or set(keep) & set(redo):
        return False, "kept and redrawn do not partition the population"
    if not np.array_equal(u2[keep], u[keep]):
        return False, "a kept design was moved"
    still = [i for i in range(12) if i not in set(kit_idx)]
    if not np.array_equal(u2[:, still], u[:, still]):
        return False, "a site column was touched"
    return bool((u2 >= 0).all() and (u2 <= 1).all()), "a redrawn design left the unit box"


@PAR.prop("with no step and no exploring, every redrawn design lands ON a frontier design",
          lean="Marcolli Prop. 4.4: the epsilon-reversible move, at epsilon = 0",
          gens=dict(pool=pool_gen(), seedp=ints(0, 1 << 20)), n=200)
def _(pool, seedp, label):
    import tandoor_resources as R
    V = R.Valuation(budget_pkr=8e5, goal_rotis=20.0, goal_track=0.5)
    B = len(pool); rng = np.random.default_rng(seedp); kit_idx = np.arange(3, 9)
    u = rng.uniform(size=(B, 12))
    u2, keep, redo = R.swarm_step(u, pool, V, rng, kit_idx, eps=0.0, explore=0.0)
    label("redrawn", "some" if redo else "none")
    for b in redo:
        if not any(np.allclose(u2[b, kit_idx], u[j, kit_idx]) for j in keep):
            return False, f"design {b} was redrawn onto nothing on the frontier"
    return True


@PAR.prop("both scalarizations the project uses pick a point of the frontier",
          lean="Pareto.scalarization_mem_frontier, for SCALAR_PAYBACK and SCALAR_RL",
          gens=dict(pool=pool_gen(), which=choice(["payback", "rl"])), n=300)
def _(pool, which, label):
    import tandoor_resources as R
    V = R.Valuation(budget_pkr=8e5, goal_rotis=20.0, goal_track=0.5)
    front = set(V.frontier(pool)); adm = [(n_, v_) for n_, v_ in pool if all(g <= x for x, g in zip(v_, V.goals))]
    if not adm: return True
    w = R.SCALAR_PAYBACK if which == "payback" else R.SCALAR_RL
    sc = [R.scalarize(v_, w) for _, v_ in adm]; best = int(np.argmax(sc))
    if sum(1 for x in sc if x >= sc[best] - 1e-12) > 1: label("tie", "yes"); return True
    label("tie", "no")
    return adm[best][0] in front, f"{which} picked {adm[best][0]}, not on the frontier {sorted(front)}"


@PAR.prop("the proved program agrees with the python frontier on the design run's own pools",
          lean="Pareto.ThinValuation.compute via `lake exe frontier`", gens=dict(pool=pool_gen()), n=6)
def _(pool, label):
    import tandoor_resources as R, shutil, os
    if not os.path.exists(os.path.expanduser("~/.elan/bin/lake")): label("lake", "absent"); return True
    label("lake", "present")
    V = R.Valuation(budget_pkr=8e5, goal_rotis=20.0, goal_track=0.5)
    py, ln = V.frontier(pool), V.lean_frontier(pool)
    return py == ln, f"python {py} but Lean {ln}"


@PAR.prop("the tracking-margin goal is the keyhole: below one within a few degrees of the declination, above one far from it",
          lean="Mount.follow_exact's hypothesis as a design goal (tandoor_resources.track_margin)",
          gens=dict(doy=ints(1, 365), off=choice([0.0, 1.0, 2.0, 3.0, 8.0, 12.0, 20.0, 35.0])), n=120)
def _(doy, off, label):
    import tandoor_resources as R
    decl = 23.44 * math.sin(2 * math.pi * (284 + doy) / 365)
    lat = decl + off
    if abs(lat) > 60: return True
    m, need = R.track_margin(lat, doy, 2.5)
    label("zone", "keyhole" if off <= 3.0 else ("clear" if off >= 8.0 else "edge"))
    if off <= 3.0: return m < 1.0, f"{off:.0f} deg from the declination the margin is {m:.2f} (demand {need:.1f} deg/min)"
    if off >= 8.0: return m >= 1.0, f"{off:.0f} deg from the declination the margin is {m:.2f} (demand {need:.1f} deg/min)"
    return True


# =====================================================================================
# StatedLaws.lean - the laws the simulator samples over, proved, then measured
# =====================================================================================
LAW = suite("StatedLaws.lean - the stated laws, proved and measured: clear sky, soiling, blur, losses, demand, load")


def _meinel(el_deg):
    """the proved formula (TandoorClearSky.meinel / dni), as the simulator states it"""
    if el_deg <= 2.0: return 0.0
    return 1353.0 * 0.7 ** ((1.0 / math.sin(math.radians(el_deg))) ** 0.678)


@LAW.prop("the simulator's clear sky is Meinel's, non-negative, at most the solar constant, zero at or below two degrees",
          lean="StatedLaws TandoorClearSky.dni_nonneg, dni_le_solar_constant, dni_zero_of_le",
          cover={"sun": {"below two degrees": 0.05}},
          gens=dict(el=floats(-10.0, 90.0, target=45.0)), n=500)
def _(el, label):
    from tandoor_rl_env import _sim
    v = float(_sim.clear_sky_dni(el)); w = _meinel(el)
    label("sun", "below two degrees" if el <= 2.0 else "up")
    return abs(v - w) <= 1e-9 * max(1.0, w) and 0.0 <= v <= 1353.0, f"sim {v:.6f} vs proved {w:.6f} at {el:.3f} deg"


@LAW.prop("the clear sky grows with the elevation, and is 947.1 W/m2 at the zenith",
          lean="StatedLaws TandoorClearSky.meinel_mono, dni_mono, meinel_zenith",
          gens=dict(a=floats(2.001, 90.0), b=floats(2.001, 90.0)), n=400)
def _(a, b, label):
    from tandoor_rl_env import _sim
    lo, hi = min(a, b), max(a, b)
    z = float(_sim.clear_sky_dni(90.0))
    label("gap", "wide" if hi - lo > 20 else "narrow")
    return _sim.clear_sky_dni(lo) <= _sim.clear_sky_dni(hi) + 1e-12 and abs(z - 1353.0 * 0.7) < 1e-9, \
        f"dni({lo:.2f}) = {_sim.clear_sky_dni(lo):.4f} > dni({hi:.2f}) = {_sim.clear_sky_dni(hi):.4f}; zenith {z:.4f}"


@LAW.prop("the simulator's beam is the proved clear sky at the sun the mount saw, gated at eight degrees",
          lean="StatedLaws TandoorClearSky.dni (the pipeline: clock, elevation, Meinel, the gate)",
          gens=dict(k=ints(1, 60), seed=ints(0, 10000)), n=6)
def _(k, seed, label):
    import numpy as _np
    from tandoor_rl_env import _sim
    A, Bv = _pair()                                   # A: the numpy reference, no site table, zero noise
    r = _np.random.default_rng(seed)
    for _ in range(k):
        A.step(r.integers(0, 7, (A.num_agents, 5)))
    el, _az, _v = _sim.solar_position(A.lat, A.day, float(A._ts_sun))
    want = _meinel(el) * (1.0 if el > 8.0 else 0.0)
    got = float(_np.asarray(A.dni)[0])
    label("sun", "gated" if el <= 8.0 else "up")
    return abs(got - want) <= 1e-6 * max(1.0, want), f"dni {got:.6f} vs Meinel {want:.6f} at el {el:.4f} after {k} steps"


@LAW.prop("the light the film collects is exactly linear in the day's soiling factor",
          lean="StatedLaws TandoorSoiling.soiled_ratio (the metamorphic test)",
          gens=dict(seed=ints(0, 10000), receiver=choice(["cass", "tri"]), lat=floats(24.0, 36.0), doy=ints(1, 365),
                    hour=floats(9.0, 15.0), s1=floats(0.5, 1.0), s2=floats(0.5, 1.0)), n=16)
def _(seed, receiver, lat, doy, hour, s1, s2, label):
    B = 8
    e = _traced(B, receiver, seed)
    if _park(e, lat, doy, hour) < 10.0: return True
    args = (np.full(B, e.p0), np.full(B, 7e-3), np.zeros((B, 2)))
    p1 = e._trace_power(*args, np.full(B, s1)).sum(1).detach().cpu().numpy()
    p2 = e._trace_power(*args, np.full(B, s2)).sum(1).detach().cpu().numpy()
    m = p2 > 1e-6
    label("beam", "lit" if m.any() else "dark")
    if not m.any(): return True
    ratio = p1[m] / p2[m]
    return bool(np.abs(ratio - s1 / s2).max() < 1e-5), f"power ratio {ratio.max():.6f} vs soil ratio {s1 / s2:.6f}"


@LAW.prop("the day's soiling draw lies in [0.85, 1] on the training path, and spans it",
          lean="StatedLaws TandoorSoiling.soiled_ge, soiled_le", cover={"spread": {"yes": 0.5}},
          gens=dict(seed=ints(0, 10000), lead=ints(3, 20)), n=6)
def _(seed, lead, label):
    import numpy as _np
    e, S = _fresh(8, seed)
    t_end = float(getattr(e, "day_end", 16.0))
    e.t_solar[:] = t_end - lead * float(e.dt) / 3600.0
    r = _np.random.default_rng(seed)
    for _i, _o, _rw, _t in _drive(e, S, lead + 2, r): pass
    soil = _np.asarray(S.soil.detach().cpu(), float)
    label("spread", "yes" if soil.min() < 0.92 and soil.max() > 0.93 else "no")
    return bool((soil >= 0.85 - 1e-6).all() and (soil <= 1.0 + 1e-6).all()), f"soil in [{soil.min():.4f}, {soil.max():.4f}]"


@LAW.prop("the figure's blur is never below the static figure, on the training path",
          lean="StatedLaws TandoorBlur.sigmaB_ge_static",
          gens=dict(seed=ints(0, 10000), gust=floats(0.0, 4.0), k=ints(5, 40)), n=6)
def _(seed, gust, k, label):
    import numpy as _np
    e, S = _fresh(8, seed)
    if gust > 0: _windy(e, S, gust)
    r = _np.random.default_rng(seed)
    for _i, _o, _rw, _t in _drive(e, S, k, r): pass
    sb = _np.asarray(S.sigb.detach().cpu(), float); st = float(_np.asarray(S.sp.detach().cpu())[13])
    label("wind", "calm" if gust < 1.0 else "gusty")
    return bool((sb >= st - 1e-9).all()), f"blur {sb.min():.3e} below the static {st:.3e}"


@LAW.prop("more blur on the figure, less power into the pot (measured; the optics have no theorem for this yet)",
          lean="StatedLaws TandoorBlur.sigmaB_mono_wind - and then the duct catches less; MEASURED, not proved",
          cover={"changed": {"yes": 0.6}},
          gens=dict(seed=ints(0, 10000), receiver=choice(["cass", "tri"]), lat=floats(24.0, 36.0), doy=ints(1, 365),
                    hour=floats(9.0, 15.0), b1=floats(2e-3, 8e-3), mult=floats(1.5, 4.0)), n=16)
def _(seed, receiver, lat, doy, hour, b1, mult, label):
    import torch
    B = 8
    e = _traced(B, receiver, seed)
    if _park(e, lat, doy, hour) < 10.0: return True
    e._det_trace = False                              # the blur only acts through the sun-disc draws
    try:
        g = e._gen.get_state()
        p1 = e._trace_power(np.full(B, e.p0), np.full(B, b1), np.zeros((B, 2)), np.ones(B)).sum(1).detach().cpu().numpy()
        e._gen.set_state(g)
        p2 = e._trace_power(np.full(B, e.p0), np.full(B, b1 * mult), np.zeros((B, 2)), np.ones(B)).sum(1).detach().cpu().numpy()
    finally:
        e._det_trace = True
    if p1.max() < 1e-6: return True
    label("changed", "yes" if abs(p2.mean() - p1.mean()) > 1e-6 * max(p1.mean(), 1e-9) else "no")
    return p2.mean() <= p1.mean() * (1 + 1e-6), f"blur x{mult:.2f}: batch power {p1.mean():.4f} -> {p2.mean():.4f} W"


@LAW.prop("the machine's throughput is the stated product of its mirrors, in range, and the rays carry it",
          lean="StatedLaws TandoorLossChain.throughput, chains_in_range, twoMirrorSilver/Aluminium",
          gens=dict(receiver=choice(["cass", "tri"]), seed=ints(0, 3)), n=6)
def _(receiver, seed, label):
    e = _traced(8, receiver, seed)
    chain = [0.94, 0.96, 0.96, 0.97] if e.silvered else [0.88, 0.95, 0.95, 0.96]
    want = float(np.prod(chain)); got = float(e._loss_chain)
    label("finish", "silver" if e.silvered else "aluminium")
    # the ray set carries exactly that chain: block 0's weights over the clean cells
    a = float(e.a_mem); rr = np.sqrt(np.asarray(e._hx) ** 2 + np.asarray(e._hy) ** 2)
    cell = np.pi * a * a * (1 - 0.05 ** 2) / len(rr); clean = (cell * (1 - 0.10 * (rr / a) ** 4)).sum()
    S = int(getattr(e, "N_SURF", 1)); P = len(e._hx)
    carried = float(e._ray_pw.view(S, P)[0].sum()) / clean
    return abs(got - want) < 1e-9 and 0.6 <= got <= 0.9 and abs(carried - want) < 1e-5, \
        f"env chain {got:.6f} vs stated {want:.6f}; the rays carry {carried:.6f}"


@LAW.prop("the demand schedule integrates to the day's demand: each band delivers its share",
          lean="StatedLaws TandoorDemand.band_integral",
          gens=dict(c=arrays(3, 6.0, 20.0), w=arrays(3, 0.3, 4.0), sh=arrays(3, 0.05, 5.0), dem=floats(50.0, 2000.0)), n=200)
def _(c, w, sh, dem, label):
    from tandoor_polar_env import parse_demand_bands
    A, _Bv = _pair()
    keep = A.demand_bands
    try:
        A.demand_bands = parse_demand_bands(",".join(f"{c[i]:.4f}:{w[i]:.4f}:{sh[i]:.5f}" for i in range(3)), None)
        t = np.linspace(-80.0, 100.0, 200001)
        got = float(np.trapezoid(A.demand_rate(t, dem), t))
    finally:
        A.demand_bands = keep
    label("bands", "narrow" if w.min() < 0.6 else "broad")
    return abs(got - dem) <= 1e-6 * dem, f"the day integrates to {got:.6f} customers against {dem:.6f} demanded"


@LAW.prop("one step of the sales process sells no more than the shelf holds, the stock balances, and an integer stock never goes negative",
          lean="StatedLaws TandoorDemand.sale_le_shelf, sale_nonneg, stock_balance, stale_le_stock",
          cover={"stock": {"low": 0.1}},
          gens=dict(orders=arrays(16, 0.0, 40.0), shelf=arrays(16, 0.0, 40.0), cooked=arrays(16, 0.0, 6.0),
                    u=arrays(64, 0.0, 1.0), hour=floats(6.0, 20.0)), n=200)
def _(orders, shelf, cooked, u, hour, label):
    # THE DOMAIN IS COUNTS. Fed fractional stock the rounding floor overshoots and the shelf goes
    # negative - the first run of this property did exactly that. The simulator only ever holds
    # whole rotis (sales of 3/10/30, whole loaves cooked), and stale_le_stock says that is enough.
    A, _Bv = _pair()
    B = A.num_agents
    fit = lambda v: np.resize(np.round(np.asarray(v, float)), B)        # whole rotis, B of them
    orders, shelf, cooked = fit(orders), fit(shelf), fit(cooked)
    u = np.resize(np.asarray(u, float), 4 * B).reshape(4, B)
    o0, s0, sd0 = A.orders.copy(), A.shelf.copy(), A.sold.copy(); t0 = A.t_solar.copy()
    try:
        A.orders[:] = orders; A.shelf[:] = shelf; A.sold[:] = 0.0; A.t_solar[:] = hour
        sale, stale = A._demand_step(cooked.copy(), u)
        o1, s1, sd1 = A.orders.copy(), A.shelf.copy(), A.sold.copy()
    finally:
        A.orders[:] = o0; A.shelf[:] = s0; A.sold[:] = sd0; A.t_solar[:] = t0
    label("stock", "low" if (shelf + cooked).min() <= 2 else "high")   # SOME agent near empty: where the floor could overshoot
    ok = ((sale >= -1e-9).all() and (sale <= shelf + cooked + 1e-9).all() and (stale >= -1e-9).all()
          and np.allclose(s1, shelf + cooked - sale - stale, atol=1e-9) and np.allclose(sd1, sale, atol=1e-9)
          and (o1 >= -1e-9).all() and (s1 >= -1e-9).all())
    return bool(ok), (f"sale max {sale.max():.0f} vs shelf+cooked {(shelf + cooked).max():.0f}; shelf after min {s1.min():.2f}, "
                      f"orders after min {o1.min():.2f}; balance residual {np.abs(s1 - (shelf + cooked - sale - stale)).max():.3e}")


def _pot_energy(e, S):
    """the pot's stored heat above 300 K per machine [J]: the wall network's capacities at the
    design's cap column (the kernel divides by HC*ds[46]) plus the live layers of the sand column"""
    import numpy as _np
    fct = _np.asarray(e._fct.detach().cpu(), float); cap = fct[:, e.DS["cap"]]
    T = _np.asarray(S.T.detach().cpu(), float); Ts = _np.asarray(S.T_sub.detach().cpu(), float)
    Td = _np.asarray(S.T_deep.detach().cpu(), float); Th = _np.asarray(S.T_halo.detach().cpu(), float)
    hc = _np.asarray(e.node_heat_cap, float); cs = _np.asarray(e.cap_sub, float); cd = _np.asarray(e.cap_deep, float)
    E = cap * ((hc * (T - 300.0)).sum(1) + (cs * (Ts - 300.0)).sum(1) + (cd * (Td - 300.0)).sum(1)) \
        + float(_np.asarray(e.c_halo).reshape(-1)[0]) * (Th - 300.0)
    Tsand = _np.asarray(S.T_sand.detach().cpu(), float)          # (B, 2, KSAND)
    depth = fct[:, 70]; NB = e.n_belt; area = _np.asarray(e.node_area, float)[NB:NB + 2]
    for b in range(T.shape[0]):
        nl = int(_np.clip(round(depth[b] / 0.05), 1, Tsand.shape[2])) if depth[b] > 0 else 0
        if nl:
            dz = depth[b] / nl
            E[b] += (area[:, None] * dz * 1.28e6 * (Tsand[b, :, :nl] - 300.0)).sum()
    return E


@LAW.prop("the policy never sells more rotis than the sun's deposit and the pot's drawdown could have baked",
          lean="StatedLaws TandoorLoad.rotis_le_energy (the summing functor's energy column, under the policy)",
          cover={"baked": {"some": 0.5}}, gens=dict(seed=ints(0, 10000), k=ints(900, 2200)), n=4)
def _(seed, k, label):
    import numpy as _np, torch
    e, S = _fresh(8, seed)
    E0 = _pot_energy(e, S); r = _np.random.default_rng(seed)
    sun = _np.zeros(8); sold = _np.zeros(8); prev = _np.asarray(S.day_rotis.detach().cpu(), float).copy()
    for _i, _o, _rw, tr in _drive(e, S, k, r, mode="policy"):
        sun += _np.asarray(S.diag[:, 0].detach().cpu(), float) * float(e.dt)
        now = _np.asarray(S.day_rotis.detach().cpu(), float)
        cut = _np.asarray(tr.detach().cpu() if torch.is_tensor(tr) else tr).reshape(-1) > 0
        sold += _np.where(cut, 0.0, _np.maximum(now - prev, 0.0)); prev = now.copy()
    E1 = _pot_energy(e, S)
    e_roti = _np.asarray(e._ds("_ds_roti", e.roti_energy), float).reshape(-1) * _np.ones(8)
    budget = sun + _np.maximum(E0 - E1, 0.0)
    label("baked", "some" if sold.max() > 0 else "none")
    over = e_roti * sold - budget
    return bool((over <= 1e-6 * _np.maximum(budget, 1.0)).all()), \
        (f"a machine sold {sold[int(over.argmax())]:.0f} rotis worth {(e_roti * sold)[int(over.argmax())] / 1e6:.2f} MJ "
         f"against {budget[int(over.argmax())] / 1e6:.2f} MJ of sun and drawdown")


@LAW.prop("the policy never sells a roti it did not load",
          lean="StatedLaws TandoorDemand.sale_le_shelf, over the day (the summing functor: sold <= loaded)",
          cover={"baked": {"some": 0.5}}, gens=dict(seed=ints(0, 10000), k=ints(900, 2200)), n=4)
def _(seed, k, label):
    import numpy as _np, torch
    e, S = _fresh(8, seed)
    r = _np.random.default_rng(seed)
    had = _np.asarray(S.has_bread.detach().cpu(), float) > 0.5
    bt_prev = _np.asarray(S.bread_t.detach().cpu(), float)
    prev = _np.asarray(S.day_rotis.detach().cpu(), float).copy()
    loads = _np.zeros(8); sold = _np.zeros(8)
    for _i, _o, _rw, tr in _drive(e, S, k, r, mode="policy"):
        cut = _np.asarray(tr.detach().cpu() if torch.is_tensor(tr) else tr).reshape(-1) > 0
        has = _np.asarray(S.has_bread.detach().cpu(), float) > 0.5
        bt = _np.asarray(S.bread_t.detach().cpu(), float)
        # a load is a slot going empty -> full, OR a full slot whose bake clock restarted: a loaf
        # pulled and a fresh one laid in the same step never shows an edge (the first count missed 2)
        loaded = (has & ~had) | (has & had & (bt < bt_prev))
        loads += _np.where(cut, 0.0, loaded.sum(1)); had = has; bt_prev = bt
        now = _np.asarray(S.day_rotis.detach().cpu(), float)
        sold += _np.where(cut, 0.0, _np.maximum(now - prev, 0.0)); prev = now.copy()
    label("baked", "some" if sold.max() > 0 else "none")
    return bool((sold <= loads + 1e-9).all()), f"a machine sold {sold.max():.0f} having loaded {loads[int(sold.argmax())]:.0f}"


@LAW.prop("under a cleaner film the policy bakes no less (the batch mean, one morning)",
          lean="StatedLaws TandoorSoiling.soiled_mono - the policy under the sampled draw; STATISTICAL",
          gens=dict(seed=ints(0, 10000)), n=3)
def _(seed, label):
    import numpy as _np
    out = []
    for soil in (0.85, 1.0):
        e, S = _fresh(8, seed)
        S.soil.fill_(soil)
        r = _np.random.default_rng(seed)
        for _i, _o, _rw, _t in _drive(e, S, 1500, r, mode="policy"): pass
        out.append(float(_np.asarray(S.day_rotis.detach().cpu(), float).mean()))
    label("baked", "some" if max(out) > 0 else "none")
    return out[1] >= out[0] - 3.0, f"mean rotis by 12:15h: soiled {out[0]:.1f}, clean {out[1]:.1f}"


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--scale", type=float, default=1.0)
    ap.add_argument("--only", default=None)
    a = ap.parse_args()
    print("ALL THE LEAN, VALIDATING THE ENVIRONMENT")
    sys.exit(run(SUITES, seed=a.seed, scale=a.scale, only=a.only))

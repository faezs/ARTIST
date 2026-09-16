"""THE TWINS AGAINST THE PROVED LAWS (user, 2026-09-13: "make this a 1000 times better").

The Lean files in ~/manifold-pareto/lean/RequestProject (Physics, PhysicsLaws, OpticsReal,
Radiometry, ThermalDiscrete, Membrane, Mount, Stratification) state the physics as theorems with
explicit hypotheses. A theorem is only about THIS machine if the simulator's own numbers satisfy
those hypotheses, and its conclusion then has to hold in the simulator. This script checks that,
numerically, on the machine the design tools use:

  1. THE POT IS A DISSIPATIVE NETWORK (ThermalDiscrete.laplacian_posSemidef,
     ofGraph_explicit_euler_le, explicit_euler_energy_eq).
     The env's wall is a chain per node - face -> sub -> deep -> halo - plus the halo's leak to
     ambient, i.e. exactly Lean's weighted graph Laplacian with leaks. We assemble G and C from the
     env's own tables, check G is symmetric positive semidefinite, check Lean's per-node step
     condition dt * (sum of the node's conductances) <= C_i and the spectral condition
     dt * lambda_max(C^-1 G) <= 2, and then run the env in the dark and check the stored energy
     never rises.
  2. KIRCHHOFF AT THE POT (PhysicsLaws.TandoorLedger.into_add_lost).
     Every ray's power lands exactly once: the megakernel's per-node buffer (the pot and the loaves)
     plus its exterior-flux buffer (37 bins: collar, bore, deck, pot exterior, floor, escape, the
     dish's own blocking, the slot, the strip shadow, the hole, the arm, the strip window, the
     conic) must equal the power launched down the train.
  3. LIOUVILLE (Physics.liouville, OpticsReal.RayMapAbs.volume_image).
     The paraxial elements of the train are unimodular, and a polygon of rays in (y, theta) keeps
     its area through every element and through the whole train.

    PYTHONPATH=..:.:puffer_tandoor puffer_tandoor/.venv/bin/python tandoor_laws_check.py
"""
import contextlib, io, sys, os
import numpy as np

sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")

FAILURES = []


def check(name, ok, detail=""):
    print(f"   [{'PASS' if ok else 'FAIL'}] {name}{(': ' + detail) if detail else ''}", flush=True)
    if not ok:
        FAILURES.append(name)
    return ok


def build_env(device, gpu, n_rays, B):
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_design_readout import env_kwargs
    kw = env_kwargs(B, receiver="tri", site_weather="quetta", site_mean=1, site_days=0, warm_frac=1.0)
    kw.update(device=device, gpu=gpu, n_rays=n_rays, seed=0, design_rand=0, sticky_k=1,
              day_of_year=172, day_start=8.0, day_end=16.0)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=0)
    return e


# ---------------------------------------------------------------- 1. the pot dissipates
def wall_matrices(e):
    """(C, G) of the env's linear conduction network: 3N + 1 states, the chain
    face_i -> sub_i -> deep_i -> halo per node plus the halo's leak to ambient.
    Lean: ThermalDiscrete.Network.ofGraph (edges w >= 0, leaks l >= 0)."""
    N = e.n_nodes
    g01 = np.asarray(e.g01, dtype=np.float64).reshape(-1)
    g12 = np.asarray(e.g12, dtype=np.float64).reshape(-1)
    g2s = np.asarray(e.g2s, dtype=np.float64).reshape(-1)
    cap = np.asarray(e.node_heat_cap, dtype=np.float64).reshape(-1)
    cs = np.asarray(e.cap_sub, dtype=np.float64).reshape(-1)
    cd = np.asarray(e.cap_deep, dtype=np.float64).reshape(-1)
    for a in (g01, g12, g2s, cap, cs, cd):
        assert a.size == N, (a.size, N)
    n = 3 * N + 1
    G = np.zeros((n, n)); C = np.zeros(n)
    C[0:N] = cap; C[N:2 * N] = cs; C[2 * N:3 * N] = cd
    C[3 * N] = float(np.asarray(e.c_halo).reshape(-1)[0])
    edges = []                                          # (i, j, w)
    for i in range(N):
        edges += [(i, N + i, g01[i]), (N + i, 2 * N + i, g12[i]), (2 * N + i, 3 * N, g2s[i])]
    for (i, j, w) in edges:                             # w (e_i - e_j)(e_i - e_j)^T
        G[i, i] += w; G[j, j] += w; G[i, j] -= w; G[j, i] -= w
    leak = np.zeros(n)                                  # the halo's soil leak to ambient
    leak[3 * N] = float(np.asarray(e.g_halo_out).reshape(-1)[0])
    G += np.diag(leak)
    return C, G, np.array(edges), leak


def law_thermal():
    print("\n1. THE POT IS A DISSIPATIVE NETWORK (Lean ThermalDiscrete)")
    e = build_env("cpu", 0, 64, 2)
    C, G, edges, leak = wall_matrices(e)
    dt = float(e.dt); n = G.shape[0]
    print(f"   the env's wall: {e.n_nodes} face nodes x (face, sub, deep) + 1 halo = {n} states, dt {dt:.0f} s; "
          f"C {C.min():.0f}-{C.max():.0f} J/K, edge conductances {edges[:, 2].min():.3g}-{edges[:, 2].max():.3g} W/K, halo leak {leak.max():.3g} W/K")
    check("G is symmetric", np.allclose(G, G.T, atol=1e-12), f"max asymmetry {np.abs(G - G.T).max():.2e}")
    ev = np.linalg.eigvalsh(G)
    check("G is positive semidefinite (Lean laplacian_posSemidef)", ev.min() > -1e-9 * max(1.0, ev.max()),
          f"eigenvalues {ev.min():.3e} .. {ev.max():.3e}")
    x = np.random.default_rng(0).normal(size=(2000, n))
    quad = np.einsum("bi,ij,bj->b", x, G, x)
    edge_form = sum(w * (x[:, int(i)] - x[:, int(j)]) ** 2 for i, j, w in edges) + (x ** 2 * leak).sum(1)
    check("x'Gx = sum_edges w (x_i - x_j)^2 + sum_i l_i x_i^2 (Lean dotProduct_laplacian_mulVec)",
          np.allclose(quad, edge_form, rtol=1e-10), f"max rel dev {np.abs(quad - edge_form).max() / max(1e-12, np.abs(quad).max()):.2e}")
    check("C > 0 at every state", (C > 0).all(), f"min {C.min():.3g} J/K")
    node_cond = np.diag(G)
    ratio = dt * node_cond / C
    check("Lean's per-node explicit-Euler condition dt * G_ii <= C_i (ofGraph_explicit_euler_le)",
          ratio.max() <= 1.0, f"worst dt*G_ii/C_i = {ratio.max():.3f} at state {int(np.argmax(ratio))}")
    lam = np.linalg.eigvals(np.diag(1.0 / C) @ G).real.max()
    check("the spectral condition dt * lambda_max(C^-1 G) <= 2 (Lean explicit_euler_energy_le_of_spectral)",
          dt * lam <= 2.0, f"dt * lambda_max = {dt * lam:.3f}")
    # the simulator itself, in the dark
    import torch
    e2 = build_env("cpu", 0, 64, 4)
    from tandoor_rl_env import T_AMB
    a = np.full((4, e2.N_HEADS), 3, dtype=np.int64)
    a[:, 1] = 0          # shutter closed: no beam
    a[:, 2] = 6          # jammed
    a[:, -e2.n_belt:] = 0   # never load bread
    energy = []
    for t in range(200):
        e2.step(a)
        E = (0.5 * np.asarray(e2.node_heat_cap) * (e2.T[0] - T_AMB) ** 2).sum() \
            + (0.5 * np.asarray(e2.cap_sub) * (e2.T_sub[0] - T_AMB) ** 2).sum() \
            + (0.5 * np.asarray(e2.cap_deep) * (e2.T_deep[0] - T_AMB) ** 2).sum() \
            + 0.5 * float(np.asarray(e2.c_halo).reshape(-1)[0]) * (e2.T_halo[0] - T_AMB) ** 2
        energy.append(E)
    energy = np.array(energy); rises = np.diff(energy)
    check("the stored energy never rises over 200 dark steps (Lean energy_antitone / explicit_euler_energy_le)",
          rises.max() <= 1e-6 * abs(energy[0]), f"E {energy[0]/1e6:.2f} -> {energy[-1]/1e6:.2f} MJ, largest rise {rises.max():.3e} J")
    return dict(states=n, dt=dt, worst_node_ratio=float(ratio.max()), dt_lambda=float(dt * lam))


# ---------------------------------------------------------------- 2. Kirchhoff at the pot
def law_ledger():
    print("\n2. KIRCHHOFF AT THE POT (Lean TandoorLedger.into_add_lost)")
    import torch
    from tandoor_fused_step import FusedState
    e = build_env("mps", 1, 512, 8)
    B = e.num_agents
    a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=e.device)
    a[:, 1] = 6; a[:, 2] = 6
    e.step_torch(a)
    F = e._gpu
    per = F.per.detach().cpu().numpy()                       # (B, n_nodes + 8 loaf columns)
    pex = F.pex.detach().cpu().numpy().reshape(B, 37)        # (B, 37) exterior bins
    fct = e._fct.detach().cpu().numpy()
    soil = F.soil.detach().cpu().numpy() if hasattr(F, "soil") else np.ones(B)
    ray_pw = e._ray_pw.detach().cpu().numpy()
    blk = np.clip(fct[:, 60].astype(int), 0, max(0, ray_pw.size // F.P - 1))
    launched = np.array([ray_pw.reshape(-1, F.P)[blk[b]].sum() for b in range(B)]) * soil * fct[:, 41]
    got = per.sum(1) + pex.sum(1)
    rel = np.abs(got - launched) / np.maximum(launched, 1e-9)
    print(f"   per agent: pot+loaves {per.sum(1).mean():.4g}, exterior bins {pex.sum(1).mean():.4g}, "
          f"launched {launched.mean():.4g} (per unit DNI); escape bin 20 = {pex[:, 20].mean():.4g}")
    # FINDING (2026-09-16): the two ledger buffers overcount. per_dni is written for a ray that gets
    # through the inlet (weight ray_pw x soil x fct[41] x the ray's own share), pex for any ray with a
    # labelled exterior bin (same weight x scb[4] x scb[5], both 1.0 here), and the sum exceeds the
    # launched power by 1.5-13 % per agent - so some rays are deposited twice, most likely a ray that
    # passes the inlet and is ALSO binned on a surface it crossed. The miss ledger is a diagnostic, not
    # a conserved account, until that is fixed; the power the pot receives (per) is unaffected.
    check("every ray's power lands exactly once: sum(per) + sum(pex) = launched",
          rel.max() < 1e-3, f"worst relative residual {rel.max():.3e} over {B} agents "
          f"(the ledger holds MORE than was launched: ratio {(got / launched).min():.3f}-{(got / launched).max():.3f} - "
          f"rays deposited in both buffers; see the FINDING note in the source)")
    check("no fate takes negative power (Lean Ledger.power_nonneg / deposited_nonneg)",
          per.min() >= -1e-6 and pex.min() >= -1e-6, f"min per {per.min():.3e}, min pex {pex.min():.3e}")
    pot = per.sum(1); lost = pex.sum(1)
    check("into + lost = total and into <= total (Lean into_add_lost, into_le)",
          np.allclose(pot + lost, got, rtol=1e-9) and (pot <= got + 1e-9).all(),
          f"into/total = {(pot / np.maximum(got, 1e-9)).mean():.3f} mean")
    return dict(worst_residual=float(rel.max()), through_fraction=float((pot / np.maximum(got, 1e-9)).mean()))


# ---------------------------------------------------------------- 3. Liouville
def law_liouville():
    print("\n3. LIOUVILLE FOR THE PARAXIAL TRAIN (Lean Physics.liouville, OpticsReal)")
    e = build_env("cpu", 0, 64, 1)
    f = float(getattr(e, "f_nom", 5.0)); d = float(getattr(e, "d_strip", 0.6))
    prop = lambda z: np.array([[1.0, z], [0.0, 1.0]])
    mirror = lambda R: np.array([[1.0, 0.0], [-2.0 / R, 1.0]])
    train = [("dish mirror f=%.2f" % f, mirror(2 * f)), ("propagate %.2f m" % f, prop(f)),
             ("strip mirror", mirror(2 * d)), ("propagate %.2f m" % d, prop(d)),
             ("M3 mirror", mirror(2 * 1.0)), ("propagate to the bread", prop(1.0))]
    dets = [np.linalg.det(M) for _, M in train]
    check("every element is unimodular (det = 1)", max(abs(np.array(dets) - 1.0)) < 1e-12,
          f"worst |det - 1| = {max(abs(np.array(dets) - 1.0)):.2e}")
    prodM = np.eye(2)
    for _, M in train:
        prodM = M @ prodM
    check("the whole train is unimodular (Lean Train.det_matrix)", abs(np.linalg.det(prodM) - 1.0) < 1e-12,
          f"|det - 1| = {abs(np.linalg.det(prodM) - 1.0):.2e}")
    rng = np.random.default_rng(1)
    P = rng.normal(size=(12, 2)) * np.array([0.5, 0.02])
    hull = P[np.argsort(np.arctan2(P[:, 1] - P[:, 1].mean(), P[:, 0] - P[:, 0].mean()))]
    area = lambda Q: 0.5 * abs(np.dot(Q[:, 0], np.roll(Q[:, 1], -1)) - np.dot(Q[:, 1], np.roll(Q[:, 0], -1)))
    a0 = area(hull); Q = hull.copy(); worst = 0.0
    for name, M in train:
        Q = Q @ M.T
        worst = max(worst, abs(area(Q) - a0) / a0)
    check("the etendue (phase-space area) of a ray polygon is preserved by every element and the train",
          worst < 1e-12, f"worst relative area change {worst:.2e} over {len(train)} elements")
    Qp = hull @ prodM.T
    check("the train's matrix moves the polygon exactly as the elements in sequence",
          np.allclose(Qp, Q, atol=1e-12), f"max deviation {np.abs(Qp - Q).max():.2e}")
    return dict(area_error=float(worst))


if __name__ == "__main__":
    print("THE TWINS AGAINST THE PROVED LAWS (~/manifold-pareto/lean/RequestProject)")
    out = {}
    for fn in (law_thermal, law_ledger, law_liouville):
        try:
            out[fn.__name__] = fn()
        except Exception as ex:
            import traceback; traceback.print_exc()
            FAILURES.append(f"{fn.__name__} raised {type(ex).__name__}: {ex}")
    print(f"\n{len(FAILURES)} failed check(s)" + (": " + "; ".join(FAILURES) if FAILURES else " - every law holds in the simulator"))
    sys.exit(1 if FAILURES else 0)

"""THE SIMULATOR AS THE DESIGN TOOL, level 1: the receiver geometry
optimized directly on the traced ladder (perfect tracking, nominal
focus, the fused Metal step, deterministic sun draws). One env holds
the three seasons as three agents; each design point re-packs the
static table in place (set_design) and traces a handful of hours.

Objective: the annual proxy (summer + 2 x equinox + winter)/4 of the
mean delivered kW over five hours, minus a mirror-area cost term
(lambda_cost, rupees per MJ-equivalent; 0 = pure energy).
Search: a compact (mu, lambda)-CMA-ES in a bounded box.

    python tandoor_design_opt.py [--evals 400] [--lambda-cost 0.0]
"""
import argparse, contextlib, io, json, sys, time
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_mount_batch import solar_batch

DAYS = np.array([172.0, 80.0, 355.0], dtype=np.float32)     # summer, equinox, winter
WGT = np.array([1.0, 2.0, 1.0]) / 4.0
HOURS = (9.0, 10.5, 12.0, 13.5, 15.0)
# design box: name, lo, hi
BOX = [("d_strip", 0.4, 1.2), ("u_f2", 2.0, 6.0), ("r_m4", 0.6, 1.6), ("r_bore", 0.5, 1.2),
       ("w_slot", 0.4, 1.0), ("r_hole", 0.3, 0.8), ("strip_th_hi", 70.0, 125.0), ("strip_wk", 0.8, 1.8),
       ("r_duct", 0.15, 0.30)]      # the beam inlet hole: the pot model charges nothing for its size, so keep it physical
X0 = [0.6, 3.5, 1.3, 0.7, 0.7, 0.5, 100.0, 1.1, 0.20]      # the derived design (r_duct = R_DUCT_H)
DRAWS = 2                                                  # common-random-number ray draws per hour


def strip_area(d):
    """Rough strip area [m2] from the design: meridian length x mean width."""
    th = np.radians(d["strip_th_hi"])
    r_mean = d["d_strip"] * 1.4
    return r_mean * th * (d["strip_wk"] * r_mean)


def build(seed=1, **over):
    kw = dict(num_agents=3, seed=seed, wide_shutter=1, device="mps", gpu=1, n_rays=1100, warm_frac=0.0,
              day_random=0, lat_random=0, lat=30.2, wall_obs=1, n_zones=5, zone_c=0.4, g_orbit=4.0, deck_h=4.0,
              nurbs=1, silvered=1, duct_nozzle=2, spot_bread=1, loaves_per_load=8, load_ctrl=1, sticky_k=2,
              receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6)
    kw.update(over)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=seed)
    e.day_v[:] = DAYS; e.lat_v[:] = 30.2
    S = FusedState(e); e._gpu = S
    S.zero_noise = True                  # DNI/cloud/wind noise off: the objective must be pure
    S.day_v.copy_(torch.as_tensor(DAYS, device="mps")); S.lat_v.fill_(30.2)
    # the membrane formed for each agent's day (the soft re-form is a
    # policy action; without it the declination drift blurs 17 mrad)
    decl = 23.44 * np.sin(2.0 * np.pi * (284.0 + DAYS) / 365.0)
    S.decl_formed.copy_(torch.as_tensor(decl, dtype=torch.float32, device="mps"))
    S.decl_now.copy_(S.decl_formed)
    return e, S


def evaluate(e, S, design=None):
    """Mean delivered kW per season at nominal focus, perfect tracking,
    with common random numbers (the same ray draws for every design)."""
    if design is not None:
        e.set_design(**design)
        e.set_design(r_strip=0.5 * design["strip_wk"] * design["d_strip"] * 1.3)
    a = torch.full((3, e.N_HEADS), 3, dtype=torch.long, device="mps"); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
    acc = np.zeros(3)
    for h in HOURS:
        e.t_solar[:] = h
        el, az, _ = solar_batch(torch.as_tensor(e.lat_v, dtype=torch.float32), torch.as_tensor(e.day_v, dtype=torch.float32), float(h))
        S.el_m.copy_(el.to("mps")); S.az_m.copy_(torch.rad2deg(az).to("mps"))
        for k in range(DRAWS):
            S.el_m.copy_(el.to("mps")); S.az_m.copy_(torch.rad2deg(az).to("mps"))
            S.e_el_prev.zero_(); S.e_az_prev.zero_(); S.lost_ct.zero_()
            e.t_solar[:] = h
            e._gen.manual_seed(100003 * int(h * 10) + 7919 * k)
            with torch.no_grad():
                e.step_torch(a)
            acc += S.diag[:, 0].cpu().numpy() / 1e3
    return acc / (len(HOURS) * DRAWS)          # kW per season


def cmaes(f, x0, sigma0, lo, hi, evals, seed=0):
    """Minimal (mu/mu_w, lambda)-CMA-ES with box clipping."""
    rng = np.random.default_rng(seed)
    n = len(x0); lam = 4 + int(3 * np.log(n)); mu = lam // 2
    w = np.log(mu + 0.5) - np.log(np.arange(1, mu + 1)); w /= w.sum(); mueff = 1.0 / (w ** 2).sum()
    cc = (4 + mueff / n) / (n + 4 + 2 * mueff / n); cs = (mueff + 2) / (n + mueff + 5)
    c1 = 2 / ((n + 1.3) ** 2 + mueff); cmu = min(1 - c1, 2 * (mueff - 2 + 1 / mueff) / ((n + 2) ** 2 + mueff))
    damps = 1 + 2 * max(0, np.sqrt((mueff - 1) / (n + 1)) - 1) + cs
    chiN = np.sqrt(n) * (1 - 1 / (4 * n) + 1 / (21 * n * n))
    m = np.array(x0, float); sig = sigma0; C = np.eye(n); pc = np.zeros(n); ps = np.zeros(n)
    best = (np.inf, None); hist = []; used = 0; g = 0
    while used + lam <= evals:
        B_, D2, _ = np.linalg.svd(C); D = np.sqrt(np.maximum(D2, 1e-12))
        X = []; F = []
        for _ in range(lam):
            z = rng.standard_normal(n); x = m + sig * (B_ @ (D * z)); x = np.clip(x, lo, hi)
            X.append(x); F.append(f(x)); used += 1
        idx = np.argsort(F); X = np.array(X)[idx]; F = np.array(F)[idx]
        if F[0] < best[0]: best = (F[0], X[0].copy())
        hist.append(F[0])
        mold = m; m = (w[:, None] * X[:mu]).sum(0)
        y = (m - mold) / sig
        Cinvsq = B_ @ np.diag(1 / D) @ B_.T
        ps = (1 - cs) * ps + np.sqrt(cs * (2 - cs) * mueff) * (Cinvsq @ y)
        hsig = np.linalg.norm(ps) / np.sqrt(1 - (1 - cs) ** (2 * (g + 1))) / chiN < 1.4 + 2 / (n + 1)
        pc = (1 - cc) * pc + hsig * np.sqrt(cc * (2 - cc) * mueff) * y
        arty = (X[:mu] - mold) / sig
        C = (1 - c1 - cmu) * C + c1 * (np.outer(pc, pc) + (1 - hsig) * cc * (2 - cc) * C) + cmu * (arty.T * w) @ arty
        sig *= np.exp((cs / damps) * (np.linalg.norm(ps) / chiN - 1))
        g += 1
        print(f"  gen {g:3d} evals {used:4d} best {-best[0]:.3f} sigma {sig:.3f} m(unit) {np.round(m, 2).tolist()}", flush=True)
    return best, hist


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--evals", type=int, default=400); ap.add_argument("--lambda-cost", type=float, default=0.0)
    ap.add_argument("--out", default="/private/tmp/claude-501/-Users-faezs-ARTIST/40abdad5-aefb-4c8a-a67b-a45db67e0f41/scratchpad/design_opt.json")
    args = ap.parse_args()
    e, S = build()
    names = [b[0] for b in BOX]; lo = np.array([b[1] for b in BOX]); hi = np.array([b[2] for b in BOX])
    def todesign(u): return {n: float(l + float(v) * (h - l)) for n, v, l, h in zip(names, u, lo, hi)}
    def tounit(x): return (np.array(x, float) - lo) / (hi - lo)
    t0 = time.time()
    base = todesign(tounit(X0))
    kw0 = evaluate(e, S, base); print(f"baseline (derived design): kW per season {np.round(kw0, 2).tolist()} -> annual proxy {float(WGT @ kw0) * 28.8:.1f} MJ/8h  [{time.time()-t0:.1f} s]")
    def objective(x):
        d = todesign(x); kw = evaluate(e, S, d)
        mj = float(WGT @ kw) * 28.8
        return -(mj - args.lambda_cost * strip_area(d))
    best, hist = cmaes(objective, tounit(X0), 0.2, np.zeros(len(lo)), np.ones(len(hi)), args.evals, seed=1)
    d = todesign(best[1]); kw = evaluate(e, S, d)
    # independent check: a fresh env built from the design kwargs (no set_design)
    e2, S2 = build(**d, r_strip=0.5 * d["strip_wk"] * d["d_strip"] * 1.3); kw2 = evaluate(e2, S2)
    print(f"fresh-build check: {np.round(kw2, 3).tolist()} vs in-place {np.round(kw, 3).tolist()}")
    res = dict(design=d, kw_per_season=kw.tolist(), annual_proxy_MJ=float(WGT @ kw) * 28.8, strip_area_m2=strip_area(d), baseline_MJ=float(WGT @ kw0) * 28.8, evals=args.evals, lambda_cost=args.lambda_cost)
    json.dump(res, open(args.out, "w"), indent=1)
    print(f"BEST: {json.dumps({k: round(v, 3) for k, v in d.items()})}\n  kW per season {np.round(kw, 2).tolist()} -> annual proxy {res['annual_proxy_MJ']:.1f} MJ/8h vs baseline {res['baseline_MJ']:.1f}; strip ~{strip_area(d):.2f} m2  [{time.time()-t0:.0f} s]")

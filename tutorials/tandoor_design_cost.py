"""THE SIMULATOR AS THE DESIGN TOOL, level 3: co-design with a cost model.
Rotis per rupee: the receiver design is priced (formed mirror area of
the strip and M4, the bore tube, the beam inlet) and the optimizer runs
on VALUE = energy worth over the machine's life minus capital, so the
'bigger is free' answer of the energy-only optimum meets a bill.

Prices (PKR, Quetta 2026, rough; edit PRICES to re-run):
  strip   precision-formed conic strip, silvered glass on steel + the
          rotating ring it rides on          25,000 /m2
  m4      formed ellipsoid patch, silvered   15,000 /m2
  bore    insulated sheet-steel tube          4,000 /m2 of wall
  inlet   a bigger beam inlet in the pot wall: the pot model charges
          nothing for it, so its heat loss is charged HERE as radiation
          from a ~600 K interior through the extra hole area (6.2 kW/m2)
  fixed   dish, mount, pit, actuators        350,000 (design-independent)
Energy worth: the beam replaces LPG at ~6.5 PKR/MJ; 300 sun days a year,
5 years -> one MJ/8h-day of annual-proxy energy is worth ~9,750 PKR.

    python tandoor_design_cost.py [--evals 500] [--years 5] [--lpg 6.5]
"""
import argparse, json, sys, time
import numpy as np
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
import tandoor_design_opt as D

PRICES = dict(strip=25000.0, m4=15000.0, bore=4000.0, fixed=350000.0)
Q_INLET = 6200.0          # W/m2 through the extra inlet area (600 K interior)
R_INLET_BUILT = 0.20      # the built inlet the pot model already assumes


def strip_geometry(e):
    """Meridian length and tapered-width area of the strip on the F sheet
    of the hyperboloid (foci F, F2) between th_lo and th_hi, from the
    env's own chain (cs_O, cs_A, cs_a, cs_c)."""
    F, O, A = e.F_focus, e.cs_O, e.cs_A
    a, c = e.cs_a, e.cs_c
    b2 = c * c - a * a
    n_perp = np.cross(A, [0.0, 1.0, 0.0]); n_perp /= np.linalg.norm(n_perp)
    th = np.radians(np.linspace(e.strip_th_lo, e.strip_th_hi, 200))
    pts, wid = [], []
    for t in th:
        u = np.cos(t) * A + np.sin(t) * n_perp
        # (F + r u - O).A ^2 / a^2 - |perp|^2 / b2 = 1, r >= 0, the F sheet
        w = F - O
        z0, dz = w @ A, u @ A
        wp = w - z0 * A; up = u - dz * A
        qa = dz * dz / (a * a) - (up @ up) / b2
        qb = 2 * (z0 * dz / (a * a) - (wp @ up) / b2)
        qc = z0 * z0 / (a * a) - (wp @ wp) / b2 - 1.0
        disc = qb * qb - 4 * qa * qc
        if disc < 0: continue
        roots = [(-qb - np.sqrt(disc)) / (2 * qa), (-qb + np.sqrt(disc)) / (2 * qa)]
        roots = [r for r in roots if r > 1e-6 and ((F + r * u - O) @ A) * ((F - O) @ A) > 0]
        if not roots: continue
        r = min(roots); pts.append(F + r * u); wid.append(e.strip_wk * r if e.strip_wk > 0 else e.w_strip)
    pts = np.array(pts); wid = np.array(wid)
    ds = np.linalg.norm(np.diff(pts, axis=0), axis=1)
    return float(ds.sum()), float((0.5 * (wid[1:] + wid[:-1]) * ds).sum())


def cost(e, d):
    """Capital cost [PKR] of a design point on env e (after set_design)."""
    L_strip, A_strip = strip_geometry(e)
    A_m4 = np.pi * d["r_m4"] ** 2
    L_bore = float(np.linalg.norm(e.cs_P4 - e.F_focus))
    A_bore = 2 * np.pi * d["r_bore"] * L_bore
    return dict(strip_m2=A_strip, strip_len=L_strip, m4_m2=A_m4, bore_m2=A_bore,
                strip=PRICES["strip"] * A_strip, m4=PRICES["m4"] * A_m4, bore=PRICES["bore"] * A_bore,
                fixed=PRICES["fixed"],
                total=PRICES["strip"] * A_strip + PRICES["m4"] * A_m4 + PRICES["bore"] * A_bore + PRICES["fixed"])


def inlet_loss_kw(d):
    return Q_INLET * np.pi * max(d["r_duct"] ** 2 - R_INLET_BUILT ** 2, 0.0) / 1e3


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--evals", type=int, default=500); ap.add_argument("--years", type=float, default=5.0)
    ap.add_argument("--lpg", type=float, default=6.5); ap.add_argument("--days", type=float, default=300.0)
    ap.add_argument("--out", default="/private/tmp/claude-501/-Users-faezs-ARTIST/40abdad5-aefb-4c8a-a67b-a45db67e0f41/scratchpad/design_cost.json")
    args = ap.parse_args()
    worth = args.lpg * args.days * args.years            # PKR per (MJ/8h-day) of annual proxy
    e, S = D.build()
    names = [b[0] for b in D.BOX]; lo = np.array([b[1] for b in D.BOX]); hi = np.array([b[2] for b in D.BOX])
    todesign = lambda u: {n: float(l + float(v) * (h - l)) for n, v, l, h in zip(names, u, lo, hi)}
    tounit = lambda x: (np.array(x, float) - lo) / (hi - lo)
    def value(d):
        kw = D.evaluate(e, S, d)
        kw = kw - inlet_loss_kw(d)                            # the inlet's heat loss, charged to every season
        mj = float(D.WGT @ kw) * 28.8
        c = cost(e, d)
        return mj, c, mj * worth - c["total"], kw
    rows = {}
    for name, x in (("derived", D.X0), ("energy-only optimum", None)):
        if x is None:
            try: x = [json.load(open(args.out.replace("design_cost", "design_opt_energy")))["design"][n] for n in names]
            except Exception: continue
        mj, c, v, kw = value(todesign(tounit(x)))
        rows[name] = dict(design=todesign(tounit(x)), MJ=mj, cost=c["total"], value=v, kw=kw.tolist(), strip_m2=c["strip_m2"], m4_m2=c["m4_m2"], bore_m2=c["bore_m2"])
        print(f"{name:22s}: {mj:6.1f} MJ/8h, capital {c['total']/1e3:6.0f}k PKR (strip {c['strip_m2']:.2f} m2, M4 {c['m4_m2']:.2f} m2, bore {c['bore_m2']:.1f} m2), VALUE {v/1e3:7.0f}k PKR over {args.years:.0f} y", flush=True)
    t0 = time.time()
    best, hist = D.cmaes(lambda u: -value(todesign(u))[2], tounit(D.X0), 0.2, np.zeros(len(lo)), np.ones(len(hi)), args.evals, seed=3)
    d = todesign(best[1]); mj, c, v, kw = value(d)
    rows["priced optimum"] = dict(design=d, MJ=mj, cost=c["total"], value=v, kw=kw.tolist(), strip_m2=c["strip_m2"], m4_m2=c["m4_m2"], bore_m2=c["bore_m2"])
    print(f"{'priced optimum':22s}: {mj:6.1f} MJ/8h, capital {c['total']/1e3:6.0f}k PKR (strip {c['strip_m2']:.2f} m2, M4 {c['m4_m2']:.2f} m2, bore {c['bore_m2']:.1f} m2), VALUE {v/1e3:7.0f}k PKR  [{time.time()-t0:.0f} s]")
    print("PRICED BEST:", json.dumps({k: round(x, 3) for k, x in d.items()}))
    json.dump(dict(rows=rows, prices=PRICES, worth_per_MJ8h=worth, q_inlet=Q_INLET), open(args.out, "w"), indent=1)

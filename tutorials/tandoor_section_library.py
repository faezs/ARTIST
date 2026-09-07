"""The section library: for each tandoor roof quantile, overhang cap and post
rise, the site's admissible set (best post position), the one-piece annular
film and its optical surface at the seven pump levels. Records the design
table picks from (roof, cap, post_rise) by nearest bin.

  data/tandoor/section_library.pt : dict(roofs, caps, rises, records[(ir, ic, id)] = {...})
"""
import contextlib, io, json, sys, time, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_section_site import SiteFields, best_post, GRID
from tandoor_section_surface import build_section

ROOF_PCTS = (0, 10, 25, 50, 75, 90, 100)
CAPS = (1.0, 2.0, 3.5)
RISES = (0.0, 1.0, 2.0, 3.0)
OUT = "/Users/faezs/ARTIST/tutorials/data/tandoor/section_library.pt"


def perimeter(th, rmin, rmax, has=None, sector=None):
    """the film's rim length: outer + inner outlines over the bins with film, plus the two radial edges of an open sector"""
    if has is None: has = np.ones(len(th), bool)
    def L(r):
        x, y = (r * np.cos(th))[has], (r * np.sin(th))[has]
        if sector is None: x, y = np.r_[x, x[0]], np.r_[y, y[0]]
        return float(np.hypot(np.diff(x), np.diff(y)).sum())
    edges = 0.0 if sector is None else float((rmax[has] - rmin[has])[[0, -1]].sum())
    return L(rmax) + L(rmin) + edges


if __name__ == "__main__":
    from tandoor_hashemi_env import TandoorHashemiEnv
    kw = dict(num_agents=2, seed=1, device="cpu", gpu=0, n_rays=512, lat=30.2, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw)
    P, levels, f = e.n_rays, list(e.LEVEL_FRAC), float(e.f_nom)
    F = SiteFields(e); print(f"fields: {len(F.el)} poses, grid {GRID} m", flush=True)
    q = np.array(json.load(open("data/tandoor/quetta_tandoor_roof_quantiles.json")))
    X, Y = F.X, F.Y
    lib = dict(roof_pcts=ROOF_PCTS, roof_hw=[float(q[p]) for p in ROOF_PCTS], caps=CAPS, rises=RISES, P=P, levels=levels, f=f, loss_chain=1.0, records={},
               meta=dict(g_orbit=float(e.g_orbit), lat=30.2, deck_h=4.0, z_fold_above_deck=float(e.z_fold - e.z_deck), X_TOWER_C=float(e.X_TOWER_C), r_hole=0.7,
                         h_neighbour=2.3, roof_table="quetta_tandoor_roof_quantiles.json", orientation="long side east-west"))
    for ir, pct in enumerate(ROOF_PCTS):
        hw = float(q[pct]); W_, D_ = 3 * hw, 2 * hw                        # the long side east-west
        bests = best_post(F, W_, D_, RISES, CAPS)
        for ic, cap in enumerate(CAPS):
            for idl, dF in enumerate(RISES):
                area_adm, tx, ty, need, over = bests[(cap, dF)]
                mask = (need <= dF) & (over <= cap)
                t0 = time.time()
                d = None if mask.sum() * GRID * GRID < 1.0 else build_section(mask, X, Y, GRID, f, levels, P, loss_chain=1.0)
                if d is None or d["area"] < 1.0:
                    rec = dict(roof_pct=pct, W=W_, D=D_, cap=cap, rise=dF, tx=float(tx), ty=float(ty), area=0.0, empty=True)
                    note = "no film anchored at the hub" if mask.sum() * GRID * GRID >= 1.0 else "nothing admissible"
                else:
                    has = d["has"]
                    rec = dict(roof_pct=pct, W=W_, D=D_, cap=cap, rise=dF, tx=float(tx), ty=float(ty), area=float(d["area"]), admissible=float(area_adm),
                               perimeter=perimeter(d["th"], d["rmin"], d["rmax"], has, d["sector"]), r_out_max=float(d["rmax"][has].max()), th=d["th"], rmin=d["rmin"], rmax=d["rmax"],
                               sector=d["sector"], has=has, pts=d["pts"], nrm=d["nrm"], ray_pw=d["ray_pw"], pump_slope=d["pump_slope"], mesh_err=d["mesh_err"], d1max=d["d1max"],
                               resid=d["resid"], converged=d["converged"], ok=d["ok"], empty=False)
                    sec = "annulus" if d["sector"] is None else f"sector {int(has.sum())}/64 bins"
                    note = f"{sec}, mesh err {d['mesh_err']*1e3:.2f} mrad, {'converged' if d['converged'] else 'NOT converged'}{'' if d['ok'] else ' -> REJECTED'}"
                lib["records"][(ir, ic, idl)] = rec
                print(f"roof p{pct} ({W_:.1f}x{D_:.1f}) cap {cap} rise {dF}: film {rec['area']:5.1f} m2 (admissible {area_adm:5.1f}), post ({ty:.1f},{tx:.1f}); {note}  {time.time()-t0:.0f}s", flush=True)
        torch.save(lib, OUT + ".partial")
    import os; os.replace(OUT + ".partial", OUT)
    print("library:", OUT, len(lib["records"]), "records,", sum(1 for r in lib["records"].values() if not r.get("empty") and r.get("ok")), "usable films")

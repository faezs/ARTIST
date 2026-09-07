"""The section's optical surface, in the buffers the trace reads.

From a site's admissible set on the dish-plane grid (tandoor_section_site):
the star-shaped kernel of the set about its centroid (the one-piece film
with a rim), P rays spread uniformly over it (low-discrepancy in the
cumulative-area coordinate, so every ray carries the same area), the
finite-strain membrane solved at every pump level (membrane_section_fem)
and applied as the DIFFERENCE from its own level-1 solve to the analytic
parent (the mesh error cancels), giving

    pts (L, P, 3)   body-frame points on the film at each level
    nrm (L, P, 3)   unit normals (+z, toward the sun)
    ray_pw (P,)     the ray's area x rim thinning x the loss chain

the same shapes and meaning as the circular dish's _pts_l/_nrm_l/_ray_pw.
Cached under data/tandoor/sections/ by a hash of the inputs.
"""
import hashlib, json, pathlib, numpy as np, torch
from membrane_section_fem import SectionMesh, solve_section, parent_normals, parab_sag

CACHE = pathlib.Path("/Users/faezs/ARTIST/tutorials/data/tandoor/sections"); CACHE.mkdir(parents=True, exist_ok=True)
NT = 64


def _runs(ok):
    """contiguous True runs of a boolean array -> list of (k0, k1) inclusive"""
    out, k = [], 0
    while k < len(ok):
        if ok[k]:
            k0 = k
            while k + 1 < len(ok) and ok[k + 1]: k += 1
            out.append((k0, k))
        k += 1
    return out


def annular_star(mask, X, Y, grid, r_hole, centre=(0.0, 0.0)):
    """the ONE-PIECE film about the vertex: in each angle bin the admissible run that starts at
    the hole (the film is anchored to the hub; a direction whose admissible ground begins farther
    out has no film), the rim shrunk half a cell diagonal inside the last admissible sample; then
    the largest contiguous range of bins with film - a full annulus, or an open sector whose two
    radial edges end the film.
    -> theta (NT,), r_in (NT,), r_out (NT,), sector (None | (theta_lo, theta_hi)), has (NT,) bool"""
    cx, cy = centre; th = np.linspace(-np.pi, np.pi, NT, endpoint=False); dth = 2 * np.pi / NT
    x0, y0 = X[0, 0], Y[0, 0]; n0, n1 = mask.shape
    rr = np.arange(r_hole, 8.0, grid / 3); shrink = grid * np.sqrt(2) / 2
    r_in = np.full(NT, r_hole); r_out = np.full(NT, r_hole); has = np.zeros(NT, bool)
    for i, t in enumerate(th):
        xs = cx + rr * np.cos(t); ys = cy + rr * np.sin(t)
        ii = np.rint((xs - x0) / grid).astype(int); jj = np.rint((ys - y0) / grid).astype(int)
        ok = (ii >= 0) & (ii < n0) & (jj >= 0) & (jj < n1)
        ok[ok] &= mask[ii[ok], jj[ok]]
        runs = [r for r in _runs(ok) if rr[r[0]] <= r_hole + grid + 1e-6]              # anchored at the hole (within a cell of it)
        if not runs: continue
        k0, k1 = runs[0]; ro = rr[k1] - shrink
        if ro > r_hole + 0.3:                                                       # at least 30 cm of film
            r_in[i], r_out[i], has[i] = r_hole, ro, True
    if not has.any():
        return th, r_in, r_out, None, has
    if has.all():
        return th, r_in, r_out, None, has
    # the largest contiguous run of bins with film, circularly
    ext = np.r_[has, has]; best = None
    for k0, k1 in _runs(ext):
        if k0 >= NT: break
        k1 = min(k1, k0 + NT - 1)
        if best is None or (k1 - k0) > (best[1] - best[0]): best = (k0, k1)
    k0, k1 = best; keep = np.zeros(NT, bool); keep[[k % NT for k in range(k0, k1 + 1)]] = True
    r_in = np.where(keep, r_in, r_hole); r_out = np.where(keep, r_out, r_hole); has = keep
    lo, hi = th[k0 % NT] - dth / 2, th[k0 % NT] - dth / 2 + (k1 - k0 + 1) * dth
    return th, r_in, r_out, (float(lo), float(hi)), has


def annular_rays(th, r_in, r_out, centre, P, sector=None, sub=8):
    """P equal-area rays over the film: the outline sampled finely (sub per bin, linear in theta),
    theta by inverse CDF of the sub-segments' exact areas, r by sqrt within the ring"""
    dth = 2 * np.pi / NT
    if sector is None:
        thc = np.r_[th, th[0] + 2 * np.pi]; ro = np.r_[r_out, r_out[0]]; ri = np.r_[r_in, r_in[0]]
    else:
        lo, hi = sector; nb = int(round((hi - lo) / dth)); k0 = int(round((lo + dth / 2 + np.pi) / dth))
        ks = [(k0 + k) % NT for k in range(nb)]
        thc = lo + dth / 2 + dth * np.arange(nb); ro = r_out[ks]; ri = r_in[ks]
        thc = np.r_[lo, thc, hi]; ro = np.r_[ro[0], ro, ro[-1]]; ri = np.r_[ri[0], ri, ri[-1]]   # flat to the radial edges
    # fine subdivision of the outline (linear between samples)
    tf = np.concatenate([np.linspace(thc[k], thc[k + 1], sub, endpoint=False) for k in range(len(thc) - 1)] + [thc[-1:]])
    rof = np.interp(tf, thc, ro); rif = np.interp(tf, thc, ri)
    dA = 0.5 * (0.5 * (rof[:-1] ** 2 + rof[1:] ** 2) - 0.5 * (rif[:-1] ** 2 + rif[1:] ** 2)) * np.diff(tf)
    dA = np.maximum(dA, 0.0); cdf = np.r_[0, np.cumsum(dA)]; area = cdf[-1]
    k = np.arange(P) + 0.5; u = (k * 0.6180339887498949) % 1.0; v = k / P
    seg = np.clip(np.searchsorted(cdf, u * area, side="right") - 1, 0, len(dA) - 1)
    f = (u * area - cdf[seg]) / np.maximum(dA[seg], 1e-12)
    t = tf[seg] + f * np.diff(tf)[seg]; ro_t = rof[seg] * (1 - f) + rof[seg + 1] * f; ri_t = rif[seg] * (1 - f) + rif[seg + 1] * f
    r = np.sqrt(ri_t ** 2 + v * (ro_t ** 2 - ri_t ** 2))
    return centre[0] + r * np.cos(t), centre[1] + r * np.sin(t), float(area)


def build_section(mask, X, Y, grid, f, levels, P, T=2000.0, loss_chain=1.0, mesh=(96, 32), r_hole=0.7, tag=""):
    """-> dict(pts (L,P,3), nrm (L,P,3), ray_pw (P,), th, rmin, rmax, sector, area, pump_slope, mesh_err, resid, ok, ...)
    or None when the site leaves no film anchored at the hub"""
    centre = (0.0, 0.0)
    th, rmin, rmax, sector, has = annular_star(mask, X, Y, grid, r_hole, centre)
    if not has.any():
        return None
    key = hashlib.md5(json.dumps(dict(th=th.round(6).tolist(), ri=rmin.round(4).tolist(), rm=rmax.round(4).tolist(), sec=sector, f=f, L=list(levels), P=P, T=T, mesh=mesh, v=2)).encode()).hexdigest()[:12]
    path = CACHE / f"section_{key}.pt"
    rx, ry, area = annular_rays(th, rmin, rmax, centre, P, sector)
    if path.exists():
        d = torch.load(path, weights_only=False)
    else:
        from membrane_section_fem import slope_error as fem_slope_error
        m = SectionMesh(th, rmax, centre, f, n_theta=mesh[0], n_rho=mesh[1], rmin=rmin, sector=sector)
        sols = {}
        sols[1.0] = solve_section(m, 1.0, T=T)
        for side in (sorted([v for v in levels if v > 1.0]), sorted([v for v in levels if v < 1.0], reverse=True)):
            d_prev = sols[1.0]["d"]
            for lv in side:                                                    # walk away from level 1 on each side
                sols[lv] = solve_section(m, lv, T=T, d_init=d_prev); d_prev = sols[lv]["d"]
        # the level-1 solve's own departure from the parent (the mesh's error) and the residuals
        mesh_err = fem_slope_error(sols[1.0], m); d1max = float(sols[1.0]["d"].norm(dim=1).max())
        resid = {lv: sols[lv]["resid"] for lv in sols}; conv = all(sols[lv]["converged"] for lv in sols)
        # differential correction: the mesh's own level-1 error cancels
        n1 = sols[1.0]["n"]; d1 = sols[1.0]["d"]
        Xr = torch.tensor(np.stack([rx, ry], 1), dtype=torch.float64)
        base = torch.cat([Xr, parab_sag(Xr[:, 0], Xr[:, 1], f)[:, None]], 1); nb = parent_normals(base, f)
        pts, nrm, pump = [], [], []
        for lv in levels:
            dd = m.interp(sols[lv]["d"] - d1, rx, ry); dn = m.interp(sols[lv]["n"] - n1, rx, ry)
            p = base + dd; n = nb + dn; n = n / n.norm(dim=1, keepdim=True)
            pts.append(p.float()); nrm.append(n.float())
            pump.append(float(torch.sqrt((torch.arccos((n * nb).sum(1).clamp(-1, 1)) ** 2).mean())))
        d = dict(pts=torch.stack(pts), nrm=torch.stack(nrm), th=th, rmin=rmin, rmax=rmax, sector=sector, has=has, centre=centre, area=area,
                 pump_slope=pump, mesh_err=mesh_err, d1max=d1max, resid=resid, converged=conv, levels=list(levels), n_nodes=int(m.X.shape[0]))
        torch.save(d, path)
    # ray weights: equal area per ray; the film's mean reflectance factor (the circle's rim law averages to 0.967)
    d["ray_pw"] = torch.full((P,), area / P * 0.967 * loss_chain, dtype=torch.float32)
    d["rx"], d["ry"] = rx, ry
    d["ok"] = bool(d["converged"]) and d["mesh_err"] < 8e-3      # the level-1 mesh error is removed by the differential correction; reject only broken meshes
    return d


if __name__ == "__main__":
    import sys, time
    S = np.load("data/tandoor/section_site_fields.npy", allow_pickle=True).item(); xs = S["xs"]; grid = float(xs[1] - xs[0])
    X, Y = np.meshgrid(xs, xs, indexing="ij")
    levels = [0.62, 0.74, 0.85, 0.93, 1.00, 1.04, 1.10]
    for name in ("4 x 6 (median)", "p90 5.5 x 8.3"):
        site = S["sites"][name]
        for cap, dF in ((2.0, 2.0), (3.5, 2.0), (1.0, 2.0)):
            mask = (site["need"] <= dF) & (site["over"] <= cap)
            t0 = time.time(); d = build_section(mask, X, Y, grid, 4.05, levels, 512, tag=f"{name}|{cap}|{dF}")
            if d is None: print(f"{name}, cap {cap}, F+{dF}: no film"); continue
            sec = "full annulus" if d["sector"] is None else f"sector {np.degrees(d['sector'][0]):.0f}..{np.degrees(d['sector'][1]):.0f} deg"
            print(f"{name}, cap {cap} m, F+{dF} m: admissible {mask.sum()*grid*grid:.1f} m2 -> film {d['area']:.1f} m2 ({sec}, {int(d['has'].sum())}/64 bins), r_out {d['rmax'][d['has']].min():.2f}..{d['rmax'].max():.2f} m; mesh err {d['mesh_err']*1e3:.2f} mrad, |d1| {d['d1max']*1e3:.1f} mm, converged {d['converged']} (worst resid {max(d['resid'].values()):.1e}); pump slope [mrad] " + " ".join(f"{lv:.2f}:{e*1e3:.1f}" for lv, e in zip(levels, d['pump_slope'])) + f"  ({time.time()-t0:.0f}s)")

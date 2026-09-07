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


# the fixed Cassegrain receiver's acceptance against the ray's radius on the parent (measured,
# section_ladder.py, three poses): the film beyond ~3 m barely pays, so the film is chosen by USEFUL area
ACC_R = np.array([0.0, 2.1, 2.5, 3.0, 4.0, 6.0, 9.0]); ACC_V = np.array([0.90, 0.55, 0.40, 0.25, 0.10, 0.05, 0.05])


def acceptance(r):
    return np.interp(np.asarray(r, dtype=float), ACC_R, ACC_V)


def annular_star(mask, X, Y, grid, r_hole, centre=(0.0, 0.0), mode="useful"):
    """the one-piece film about the vertex: per angle bin one admissible run beyond the hole -
    'first' (nearest the hole), 'largest' (most area), 'useful' (most receiver-weighted area,
    the default), or 'best' (the larger of first/largest by area)
    -> theta (NT,), r_in (NT,), r_out (NT,) (r_out = r_in where the direction has no film)"""
    cx, cy = centre; th = np.linspace(-np.pi, np.pi, NT, endpoint=False)
    x0, y0 = X[0, 0], Y[0, 0]; n0, n1 = mask.shape
    rr = np.arange(r_hole, 8.0, grid / 3)
    films = {m: (np.full(NT, r_hole), np.full(NT, r_hole)) for m in ("first", "largest", "useful")}
    useful = lambda k0, k1: float((acceptance(rr[k0:k1 + 1]) * rr[k0:k1 + 1]).sum())
    for i, t in enumerate(th):
        xs = cx + rr * np.cos(t); ys = cy + rr * np.sin(t)
        ii = np.rint((xs - x0) / grid).astype(int); jj = np.rint((ys - y0) / grid).astype(int)
        ok = (ii >= 0) & (ii < n0) & (jj >= 0) & (jj < n1)
        ok[ok] &= mask[ii[ok], jj[ok]]
        runs = _runs(ok)
        if not runs: continue
        k0, k1 = runs[0]; films["first"][0][i], films["first"][1][i] = rr[k0], rr[k1]
        k0, k1 = max(runs, key=lambda r: rr[r[1]] ** 2 - rr[r[0]] ** 2); films["largest"][0][i], films["largest"][1][i] = rr[k0], rr[k1]
        k0, k1 = max(runs, key=lambda r: useful(*r)); films["useful"][0][i], films["useful"][1][i] = rr[k0], rr[k1]
    if mode in films:
        return th, films[mode][0], films[mode][1]
    area = {m: float(((ro ** 2 - ri ** 2) * 0.5).sum() * (2 * np.pi / NT)) for m, (ri, ro) in films.items() if m != "useful"}
    m = max(area, key=area.get)
    return th, films[m][0], films[m][1]


def annular_rays(th, r_in, r_out, centre, P):
    """P equal-area rays over the annular star: theta by inverse CDF of (r_out^2 - r_in^2), r by sqrt (low discrepancy)"""
    thc = np.r_[th, th[0] + 2 * np.pi]; ro = np.r_[r_out, r_out[0]]; ri = np.r_[r_in, r_in[0]]
    dA = 0.5 * (0.5 * (ro[:-1] ** 2 + ro[1:] ** 2) - 0.5 * (ri[:-1] ** 2 + ri[1:] ** 2)) * np.diff(thc)
    dA = np.maximum(dA, 0.0); cdf = np.r_[0, np.cumsum(dA)]; area = cdf[-1]
    k = np.arange(P) + 0.5; u = (k * 0.6180339887498949) % 1.0; v = k / P
    seg = np.clip(np.searchsorted(cdf, u * area, side="right") - 1, 0, NT - 1)
    f = (u * area - cdf[seg]) / np.maximum(dA[seg], 1e-12)
    t = thc[seg] + f * np.diff(thc)[seg]; ro_t = ro[seg] * (1 - f) + ro[seg + 1] * f; ri_t = ri[seg] * (1 - f) + ri[seg + 1] * f
    r = np.sqrt(ri_t ** 2 + v * (ro_t ** 2 - ri_t ** 2))
    return centre[0] + r * np.cos(t), centre[1] + r * np.sin(t), float(area)


def build_section(mask, X, Y, grid, f, levels, P, T=2000.0, loss_chain=1.0, mesh=(96, 32), r_hole=0.7, tag=""):
    centre = (0.0, 0.0)
    th, rmin, rmax = annular_star(mask, X, Y, grid, r_hole, centre)
    rmax = np.maximum(rmax, rmin + 0.02)                                     # no zero-width slivers in the mesh
    key = hashlib.md5(json.dumps(dict(th=th.round(6).tolist(), ri=rmin.round(4).tolist(), rm=rmax.round(4).tolist(), f=f, L=list(levels), P=P, T=T, mesh=mesh)).encode()).hexdigest()[:12]
    path = CACHE / f"section_{key}.pt"
    rx, ry, area = annular_rays(th, rmin, rmax, centre, P)
    if path.exists():
        d = torch.load(path, weights_only=False)
    else:
        m = SectionMesh(th, rmax, centre, f, n_theta=mesh[0], n_rho=mesh[1], rmin=rmin)
        sols = {}; d_prev = None
        for lv in sorted(set([1.0] + list(levels)), key=lambda v: abs(v - 1.0)):
            r = solve_section(m, lv, T=T, d_init=d_prev); sols[lv] = r; d_prev = r["d"]
        # differential correction: the mesh's own level-1 error cancels
        n1 = sols[1.0]["n"]; d1 = sols[1.0]["d"]
        Xr = torch.tensor(np.stack([rx, ry], 1), dtype=torch.float64)
        base = torch.cat([Xr, parab_sag(Xr[:, 0], Xr[:, 1], f)[:, None]], 1); nb = parent_normals(base, f)
        pts, nrm, err = [], [], []
        for lv in levels:
            dd = m.interp(sols[lv]["d"] - d1, rx, ry); dn = m.interp(sols[lv]["n"] - n1, rx, ry)
            p = base + dd; n = nb + dn; n = n / n.norm(dim=1, keepdim=True)
            pts.append(p.float()); nrm.append(n.float())
            err.append(float(torch.sqrt((torch.arccos((n * nb).sum(1).clamp(-1, 1)) ** 2).mean())))
        d = dict(pts=torch.stack(pts), nrm=torch.stack(nrm), th=th, rmin=rmin, rmax=rmax, centre=centre, area=area, slope_err=err, levels=list(levels))
        torch.save(d, path)
    # ray weights: equal area per ray, rim thinning of the film by radius about the VERTEX (the parent's own rim law)
    rr = np.hypot(rx, ry); rho_r = 1.0 - 0.10 * (rr / max(rr.max(), 1e-6)) ** 4
    d["ray_pw"] = torch.tensor(area / P * rho_r * loss_chain, dtype=torch.float32)
    d["rx"], d["ry"] = rx, ry
    return d


if __name__ == "__main__":
    import sys, time
    S = np.load("data/tandoor/section_site_fields.npy", allow_pickle=True).item(); xs = S["xs"]; grid = float(xs[1] - xs[0])
    X, Y = np.meshgrid(xs, xs, indexing="ij")
    levels = [0.62, 0.74, 0.85, 0.93, 1.00, 1.04, 1.10]
    for name in ("4 x 6 (median)", "p90 5.5 x 8.3"):
        site = S["sites"][name]
        for cap, dF in ((2.0, 2.0), (3.5, 2.0)):
            mask = (site["need"] <= dF) & (site["over"] <= cap)
            t0 = time.time(); d = build_section(mask, X, Y, grid, 4.05, levels, 512, tag=f"{name}|{cap}|{dF}")
            print(f"{name}, cap {cap} m, F+{dF} m: admissible {mask.sum()*grid*grid:.1f} m2 -> one-piece annular film {d['area']:.1f} m2, r_in {d['rmin'].min():.2f}..{d['rmin'].max():.2f}, r_out {d['rmax'].min():.2f}..{d['rmax'].max():.2f} m; slope err vs parent per level [mrad]: " + " ".join(f"{lv:.2f}:{e*1e3:.1f}" for lv, e in zip(levels, d['slope_err'])) + f"  ({time.time()-t0:.0f}s)")

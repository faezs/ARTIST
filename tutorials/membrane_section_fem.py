"""The pumped SECTION of the primary: a finite-strain membrane on the curved
surface itself.

The film is pre-formed (gores) to the parent paraboloid z = r^2/(4f), carries
an isotropic tension T in that state, and is fixed to a rim that follows the
parent's curve along an arbitrary star-shaped outline r_max(theta) about a
centre c of the dish plane. The plenum pushes it with a pressure field p(x,y)
= level x p_par(r), where p_par = 2 T H_par(r) is the law that holds the
paraboloid in exact equilibrium (Laplace on the true mean curvature; T/f at
the vertex, ~0.73 T/f at r = 5 m on f 4.05 - the zones' job). No shallowness
anywhere: the strain is the Green-Lagrange strain of each triangle relative
to its reference on the paraboloid, the pressure work is the exact swept
volume, so slopes of 0.6 and rim sags of 2 m are fine.

    W = T tr(E) + K/2 [(1-nu) E:E + nu tr(E)^2],   K = E_mod h/(1-nu^2)
    Pi = sum_tri A_ref W  +  sum_tri p_tri V_tri,   V_tri = x0.(x1 x x2)/6

(normals toward the sun, +z; the pressure pushes the film into the bowl).
Minimised over the interior nodes' 3-D displacements, rim clamped. Level 1
must return the parent itself (a check the solver passes to the mesh's
discretisation error); other levels are the cook's pump.

Outputs per level: node positions and normals on a structured polar mesh
(theta_i, rho_j) fitted to the outline, so any (x, y) of the section is
sampled by inverse-mapping to (theta, rho) and interpolating - that is how
the ray set gets its points and normals.
"""
import numpy as np, torch

F64 = torch.float64


def parab_sag(x, y, f):
    return (x * x + y * y) / (4.0 * f)


def parab_pressure_law(r, f, T):
    """p(r) = 2 T H(r) for z = r^2/(4f): (T/(2f)) (2 + z'^2) / (1 + z'^2)^1.5"""
    zp2 = (r / (2.0 * f)) ** 2
    return (T / (2.0 * f)) * (2.0 + zp2) / (1.0 + zp2) ** 1.5


def rmax_interp(theta, rmax):
    """periodic linear interpolation of a star outline r_max(theta), theta uniform on [-pi, pi)"""
    th = torch.as_tensor(theta, dtype=F64); rm = torch.as_tensor(rmax, dtype=F64); n = len(th); d = float(th[1] - th[0])

    def f(t):
        t = torch.as_tensor(t, dtype=F64); q = (t - th[0]) / d; k = torch.floor(q).long() % n; fr = q - torch.floor(q)
        return rm[k] * (1 - fr) + rm[(k + 1) % n] * fr
    return f


class SectionMesh:
    """structured polar mesh of an annular star domain r_in(theta)..r_out(theta) about centre c,
    lifted to the paraboloid. r_in = 0 (or None): a full star with a fan at the centre. Both rims
    are fixed on the parent (the outer rim ring; the inner ring is the hub round the strip's hole)."""

    def __init__(self, theta, rmax, centre, f, n_theta=96, n_rho=32, rmin=None, sector=None):
        """sector: None for a film all the way round; (theta_lo, theta_hi) [rad] for an OPEN annular
        sector whose two radial edges are rims too (the film ends there, clamped to a straight rim)."""
        self.f = float(f); self.c = np.asarray(centre, dtype=np.float64); self.rm = rmax_interp(theta, rmax)
        self.annular = rmin is not None and float(np.max(rmin)) > 0.0
        self.rmn = rmax_interp(theta, rmin) if self.annular else (lambda t: torch.zeros_like(torch.as_tensor(t, dtype=F64)))
        self.sector = None if sector is None else (float(sector[0]), float(sector[1]))
        if self.sector is None:
            th = torch.linspace(-np.pi, np.pi, n_theta + 1, dtype=F64)[:-1]; self.periodic = True
        else:
            span = self.sector[1] - self.sector[0]; n_theta = max(8, int(round(n_theta * span / (2 * np.pi))))
            th = torch.linspace(self.sector[0], self.sector[1], n_theta, dtype=F64); self.periodic = False
        self.n_theta, self.n_rho = n_theta, n_rho
        rho = torch.arange(0, n_rho + 1, dtype=F64) / n_rho if self.annular else torch.arange(1, n_rho + 1, dtype=F64) / n_rho
        self.nr = len(rho)
        TH, RHO = torch.meshgrid(th, rho, indexing="ij")                    # (n_theta, nr)
        r = self.rmn(TH) + RHO * (self.rm(TH) - self.rmn(TH))
        x = self.c[0] + r * torch.cos(TH); y = self.c[1] + r * torch.sin(TH)
        X = torch.stack([x.reshape(-1), y.reshape(-1)], 1)
        X = torch.cat([torch.tensor([[self.c[0], self.c[1]]], dtype=F64), X], 0)   # node 0: the centre (unused when annular)
        z = parab_sag(X[:, 0], X[:, 1], self.f)
        self.X = torch.cat([X, z[:, None]], 1)                               # (n, 3) reference on the paraboloid
        nr = self.nr
        idx = lambda i, j: 1 + (i % n_theta) * nr + j                       # ring j = 0..nr-1
        tris = []
        n_i = n_theta if self.periodic else n_theta - 1
        for i in range(n_i):
            if not self.annular:
                tris.append([0, idx(i, 0), idx(i + 1, 0)])                   # the fan (CCW seen from +z)
            for j in range(nr - 1):
                a, b, c_, d_ = idx(i, j), idx(i + 1, j), idx(i + 1, j + 1), idx(i, j + 1)
                tris += [[a, d_, c_], [a, c_, b]]                          # CCW seen from +z (the sun)
        self.tris = torch.tensor(tris, dtype=torch.long)
        self.is_rim = torch.zeros(self.X.shape[0], dtype=torch.bool)
        self.is_rim[[idx(i, nr - 1) for i in range(n_theta)]] = True
        if self.annular:
            self.is_rim[[idx(i, 0) for i in range(n_theta)]] = True; self.is_rim[0] = True
        if not self.periodic:                                                # the sector's two radial edges
            self.is_rim[[idx(0, j) for j in range(nr)]] = True; self.is_rim[[idx(n_theta - 1, j) for j in range(nr)]] = True
        self.theta, self.rho = th, rho
        self._idx = idx
        E1 = self.X[self.tris[:, 1]] - self.X[self.tris[:, 0]]; E2 = self.X[self.tris[:, 2]] - self.X[self.tris[:, 0]]
        self.A_ref = 0.5 * torch.linalg.cross(E1, E2).norm(dim=1)
        self.area = float(self.A_ref.sum())
        # the reference 2-D basis per triangle: e1 along E1, e2 in the plane; the inverse of [[a1,b1],[0,b2]]
        e1 = E1 / E1.norm(dim=1, keepdim=True); nrm = torch.linalg.cross(E1, E2); nrm = nrm / nrm.norm(dim=1, keepdim=True)
        e2 = torch.linalg.cross(nrm, e1)
        a1 = (E1 * e1).sum(1); b1 = (E2 * e1).sum(1); b2 = (E2 * e2).sum(1)
        a1 = torch.where(a1.abs() < 1e-9, torch.full_like(a1, 1e-9), a1); b2 = torch.where(b2.abs() < 1e-9, torch.full_like(b2, 1e-9), b2)
        self.Minv = torch.stack([torch.stack([1 / a1, -b1 / (a1 * b2)], 1), torch.stack([torch.zeros_like(a1), 1 / b2], 1)], 1)   # (m, 2, 2)
        rc = torch.sqrt(((self.X[self.tris].mean(1)[:, :2]) ** 2).sum(1))
        self.r_tri = rc

    def uv_of_xy(self, x, y):
        """(theta, rho in [0,1]) of dish-plane points relative to the centre"""
        dx, dy = torch.as_tensor(x, dtype=F64) - self.c[0], torch.as_tensor(y, dtype=F64) - self.c[1]
        th = torch.atan2(dy, dx); r = torch.sqrt(dx * dx + dy * dy)
        return th, (r - self.rmn(th)) / (self.rm(th) - self.rmn(th)).clamp(min=1e-9)

    def interp(self, field, x, y):
        """bilinear interpolation of a per-node field (n, k) at dish-plane points (x, y) inside the domain"""
        th, rho = self.uv_of_xy(x, y); nt, nr = self.n_theta, self.nr
        if self.periodic:
            qt = (th + np.pi) / (2 * np.pi / nt); it = torch.floor(qt).long() % nt; ft = qt - torch.floor(qt)
        else:
            lo, hi = self.sector; th = ((th - lo + np.pi) % (2 * np.pi)) - np.pi + lo       # unwrap about the sector
            qt = ((th - lo) / (hi - lo) * (nt - 1)).clamp(0, nt - 1 - 1e-9); it = torch.floor(qt).long(); ft = qt - torch.floor(qt)
        if self.annular:
            qr = rho.clamp(0, 1) * (nr - 1); jr = torch.floor(qr).long().clamp(0, nr - 2); fr = (qr - jr.double()).clamp(0, 1)
            node = lambda i, j: 1 + (i % nt) * nr + j
        else:
            qr = rho * nr - 1.0                                              # ring j at rho = (j+1)/nr; the centre is "ring -1"
            jr = torch.floor(qr).long(); fr = qr - torch.floor(qr)
            jr = jr.clamp(-1, nr - 2); fr = torch.where(qr < -1, torch.zeros_like(fr), fr); fr = torch.where(qr > nr - 1, torch.ones_like(fr), fr)

            def node(i, j):
                j = torch.as_tensor(j); return torch.where(j < 0, torch.zeros_like(j), 1 + (i % nt) * nr + j.clamp(min=0))
        f00 = field[node(it, jr)]; f10 = field[node(it + 1, jr)]; f01 = field[node(it, jr + 1)]; f11 = field[node(it + 1, jr + 1)]
        ft = ft[:, None]; fr = fr[:, None]
        return (1 - ft) * (1 - fr) * f00 + ft * (1 - fr) * f10 + (1 - ft) * fr * f01 + ft * fr * f11


def _energy(x, mesh, T, K, nu, p_tri):
    t = mesh.tris; x0, x1, x2 = x[t[:, 0]], x[t[:, 1]], x[t[:, 2]]
    D = torch.stack([x1 - x0, x2 - x0], 2)                                    # (m, 3, 2)
    Fd = torch.bmm(D, mesh.Minv)                                              # deformation gradient (m, 3, 2)
    C = torch.bmm(Fd.transpose(1, 2), Fd)                                     # (m, 2, 2)
    E = 0.5 * (C - torch.eye(2, dtype=F64))
    trE = E[:, 0, 0] + E[:, 1, 1]; EE = (E * E).sum((1, 2))
    W = T * trE + 0.5 * K * ((1 - nu) * EE + nu * trE * trE)
    V = (x0 * torch.linalg.cross(x1, x2)).sum(1) / 6.0
    return (mesh.A_ref * W).sum() + (p_tri * V).sum()


def solve_section(mesh, level, T=2000.0, E_mod=3.7e9, h_film=50e-6, nu=0.38, d_init=None, iters=(0, 300), verbose=False, tol=1e-3, max_restarts=8):
    """the film at pump level `level` (1 = the parent's own pressure law)
    -> dict(x (n,3), n (n,3) normals, d, energy, resid, converged, restarts)"""
    K = E_mod * h_film / (1 - nu * nu)
    p_tri = level * parab_pressure_law(mesh.r_tri, mesh.f, T)
    free = ~mesh.is_rim
    d = torch.zeros_like(mesh.X) if d_init is None else d_init.clone()
    dv = d[free].clone().requires_grad_(True)

    def total():
        x = mesh.X.clone(); x[free] = mesh.X[free] + dv
        return _energy(x, mesh, T, K, nu, p_tri)
    if iters[0]:
        opt = torch.optim.Adam([dv], lr=1e-4)
        for _ in range(iters[0]):
            opt.zero_grad(); L = total(); L.backward(); opt.step()
    opt2 = torch.optim.LBFGS([dv], max_iter=iters[1], tolerance_grad=1e-10, tolerance_change=1e-18, history_size=50, line_search_fn="strong_wolfe")

    def closure():
        opt2.zero_grad(); L = total(); L.backward(); return L
    # the residual: the largest nodal out-of-balance force relative to the tension on a node's share of rim
    # (T x the mean edge length); stationary when below tol. Restart LBFGS until it is, or flag it.
    scale = float(T) * float(torch.sqrt(mesh.A_ref.mean()))
    def residual():
        g = torch.autograd.grad(total(), dv)[0]; return float(g.norm(dim=1).max()) / scale
    resid = residual(); k = 0
    while resid > tol and k < max_restarts:
        opt2.step(closure); resid = residual(); k += 1
    with torch.no_grad():
        x = mesh.X.clone(); x[free] = mesh.X[free] + dv
        d = x - mesh.X
        t = mesh.tris; fn = torch.linalg.cross(x[t[:, 1]] - x[t[:, 0]], x[t[:, 2]] - x[t[:, 0]])   # area-weighted face normals (+z)
        n = torch.zeros_like(x).index_add_(0, t.reshape(-1), fn.repeat_interleave(3, 0))
        n = n / n.norm(dim=1, keepdim=True).clamp(min=1e-12)
    return dict(x=x, n=n, d=d, energy=float(total().detach()), resid=resid, converged=bool(resid <= tol), restarts=k)


def parent_normals(x, f):
    """the parent paraboloid's unit normals (+z) at points x (n, 3)"""
    n = torch.stack([-x[:, 0] / (2 * f), -x[:, 1] / (2 * f), torch.ones_like(x[:, 0])], 1)
    return n / n.norm(dim=1, keepdim=True)


def slope_error(res, mesh, mask=None):
    """RMS angle between the solved normals and the parent's [rad], over interior nodes (or mask)"""
    n0 = parent_normals(mesh.X, mesh.f); m = (~mesh.is_rim) if mask is None else mask
    cosang = (res["n"][m] * n0[m]).sum(1).clamp(-1, 1)
    return float(torch.sqrt((torch.arccos(cosang) ** 2).mean()))


if __name__ == "__main__":
    import time, sys
    f, T = 4.05, 2000.0
    th = np.linspace(-np.pi, np.pi, 64, endpoint=False)
    cases = {"circle a 2.1": (np.full(64, 2.1), (0.0, 0.0)),
             "tall section x 0.6..5, |y|<=2": (None, (2.8, 0.0))}
    # the rectangle as a star outline about its centre
    x0, x1, hw = 0.6, 5.0, 2.0; cx = 0.5 * (x0 + x1); hx = 0.5 * (x1 - x0)
    with np.errstate(divide="ignore"):
        rr = np.minimum(hx / np.maximum(np.abs(np.cos(th)), 1e-12), hw / np.maximum(np.abs(np.sin(th)), 1e-12))
    cases["tall section x 0.6..5, |y|<=2"] = (rr, (cx, 0.0))
    for name, (rm, c) in cases.items():
        for (nt, nr) in ((48, 16), (96, 32)):
            mesh = SectionMesh(th, rm, c, f, n_theta=nt, n_rho=nr)
            line = f"{name:32s} mesh {nt}x{nr} ({mesh.X.shape[0]} nodes, area {mesh.area:.1f} m2):"
            d_prev = None
            for lv in (1.0, 0.8, 1.2):
                t0 = time.time(); r = solve_section(mesh, lv, T=T, d_init=None)
                se = slope_error(r, mesh); dmax = float(r["d"].norm(dim=1).max())
                line += f"  L{lv:.1f}: |d|max {dmax*1e3:6.2f} mm, slope err {se*1e3:5.2f} mrad ({time.time()-t0:.0f}s)"
            print(line)

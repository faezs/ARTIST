"""
Raymap of a pump-actuated membrane concentrator in Cassegrain beam-down
configuration, feeding an underground firebrick tandoor.

System
------
 - Primary: circular Mylar membrane (aluminized by vacuum evaporation, rho=0.95),
   clamped at radius ``a``, pulled concave by a pump pressure differential dp.
   The true shape is solved from the axisymmetric Foeppl-von-Karman membrane
   equations (pretension + pressure), which at dish-like sag is in the Hencky
   regime and measurably non-parabolic. The solved shape is then fitted with an
   ARTIST ``NURBSSurface`` so points and analytic normals come from ARTIST's
   differentiable surface machinery.
 - Light source: the sun at zenith, using ARTIST's ``Sun`` distribution for the
   angular spread (sunshape + specularity).
 - Secondary: convex hyperboloid with foci at the membrane focus F1 and at the
   oven aperture F2 (classic beam-down), plus an even-asphere correction
   polynomial whose coefficients are optimized by gradient descent *through the
   raytrace* to cancel the membrane's Hencky aberration.
 - The center of the membrane is left uncoated during deposition: the clear
   Mylar disc doubles as the window over the oven pit. The beam-down passes
   through it at its waist.
 - Oven: underground spherical cavity (radius R_o) whose top cut is the
   aperture. Rotis sit on the near-vertical equatorial belt of the wall.
   The raymap deliverable is the first-strike flux on the unrolled wall.
 - Bonus: the incandescent-bulb evaporation step itself - Al thickness
   uniformity on the membrane from a point source in the vacuum chamber.

Frame: ARTIST ENU, meters. Points are 4D homogeneous [E, N, U, 1],
directions [E, N, U, 0]. Sun at zenith -> incident direction [0, 0, -1, 0].

Run:  python tutorials/03_membrane_beamdown_tandoor.py --out <dir>
"""

import argparse
import pathlib
import sys
import time
from types import SimpleNamespace

import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))

import matplotlib.pyplot as plt
from matplotlib import patches

from artist.field.tower_target_areas import TowerTargetAreas
from artist.raytracing.heliostat_tracing import HeliostatRayTracer
from artist.raytracing.rays import Rays
from artist.raytracing.raytracing_utils import line_plane_intersections, reflect
from artist.scene.sun import Sun
from artist.util.environment_setup import get_device
from artist.util.nurbs import NURBSSurface

DEVICE = get_device()  # ARTIST auto-select: CUDA > MPS > CPU
torch.manual_seed(7)


def interp1d(x, xp, fp):
    """torch analogue of np.interp for monotonically increasing xp."""
    idx = torch.searchsorted(xp, x.contiguous()).clamp(1, len(xp) - 1)
    x0, x1 = xp[idx - 1], xp[idx]
    f0, f1 = fp[idx - 1], fp[idx]
    w = ((x - x0) / (x1 - x0)).clamp(0, 1)
    return f0 + w * (f1 - f0)

# --------------------------------------------------------------------------- #
# Configuration                                                               #
# --------------------------------------------------------------------------- #
CFG = SimpleNamespace(
    # membrane (primary)
    a=1.0,                 # clamped radius [m]
    t_mem=50e-6,           # Mylar thickness [m]
    E_mem=3.7e9,           # PET Young's modulus [Pa]
    nu_mem=0.38,           # PET Poisson ratio
    T_pre=2000.0,          # pretension [N/m]  (sigma = 40 MPa, PET yield ~90)
    dp=667.0,              # pump differential [Pa]  -> linear f = T/dp = 3.0 m
    rho_mem=0.95,          # aluminized-Mylar specular reflectance (user spec)
    # secondary
    z_gap=0.85,            # secondary vertex below F1 [m]; sets Cassegrain
                           # magnification (z_vertex+pivot_drop)/z_gap - keep
                           # the F2 image matched to the pit radius
    rho_sec=0.95,          # secondary reflectance
    sec_margin=1.10,       # rim radius margin over marginal ray
    # window / pivot / oven
    pivot_drop=1.6,        # F2 (pit mouth, tracking pivot) below membrane [m]
    crater_depth=0.75,     # saucer trench around the collar for rim swing [m]
    r_pit=0.16,            # oven aperture = sphere top cut, at the F2 waist [m]
    r_window=None,         # clear membrane disc [m]; None = auto from geometry
    T_window=0.85,         # transmission of uncoated Mylar window
    R_oven=0.60,           # firebrick sphere radius [m]
    belt_half=0.25,        # roti belt: |z - z_center| < belt_half [m]
    rim_drop=0.15,         # plenum/clamp hardware hanging below the rim [m]
    # sun / radiometry
    dni=900.0,             # direct normal irradiance [W/m^2]
    n_sun_rays=32,         # ARTIST Sun rays per membrane point
    # sampling
    n_grid=120,            # membrane trace grid (n_grid x n_grid over square)
    n_fit=61,              # NURBS fit eval grid per axis
    n_cp=20,               # NURBS control points per axis
    nurbs_epochs=4000,
    # bitmaps
    ap_half=0.40,          # aperture-plane bitmap half-size [m]
    ap_res=200,
    oven_res_phi=90,
    oven_res_ct=64,
)


# --------------------------------------------------------------------------- #
# 1. Membrane mechanics: axisymmetric FvK solve (pretension + pressure)       #
# --------------------------------------------------------------------------- #
def solve_membrane(cfg, dp, n=1200, beta=0.35, tol=1e-10, max_iter=600,
                   zone_edges=None):
    """Solve the membrane BVP; ``dp`` is a scalar pressure or, with
    ``zone_edges`` (K+1 radii), a K-vector of per-zone plenum pressures
    (multiple small pumps -> piecewise-constant p(r), i.e. the membrane
    becomes a K-DOF adaptive mirror). Vertical equilibrium generalizes to
    r N_r s' = P_cum(r) = integral of p r dr.

    Runs in torch float64 on CPU by design: a 1-D sequential BVP needing
    1e-10 convergence is no fit for float32/MPS (Metal has no float64) and
    costs milliseconds. Results are cast to float32/DEVICE by consumers.

    Returns dict with radial grid r, sag s(r) (vertex 0, rim w0), slope s'(r),
    radial tension N_r(r), best-fit parabola focal length, and diagnostics.
    """
    cpu = torch.device("cpu")
    K = cfg.E_mem * cfg.t_mem / (1.0 - cfg.nu_mem**2)
    r = torch.linspace(0.0, cfg.a, n + 1, dtype=torch.float64, device=cpu)
    h = float(r[1] - r[0])
    if zone_edges is None:
        # uniform pressure: P_cum = dp r^2 / 2
        p_cum = 0.5 * float(dp) * r**2
        dp_mean = float(dp)
    else:
        pz = torch.as_tensor(dp, dtype=torch.float64)
        edges = torch.as_tensor(zone_edges, dtype=torch.float64)
        p_cum = torch.zeros_like(r)
        base = 0.0
        for k in range(len(pz)):
            lo, hi = float(edges[k]), float(edges[k + 1])
            m_ = (r > lo) & (r <= hi)
            p_cum[m_] = base + 0.5 * float(pz[k]) * (r[m_] ** 2 - lo**2)
            base += 0.5 * float(pz[k]) * (hi**2 - lo**2)
        p_cum[r > float(edges[-1])] = base
        dp_mean = float(2 * base / float(edges[-1]) ** 2)
    Nr = torch.full_like(r, cfg.T_pre)
    ri = r[1:-1]
    lo = 1.0 / h**2 - 1.0 / (2 * ri * h)
    di = -2.0 / h**2 - 1.0 / ri**2
    up = 1.0 / h**2 + 1.0 / (2 * ri * h)
    A_in = (torch.diag(di) + torch.diag(lo[1:], -1) + torch.diag(up[:-1], 1))

    for it in range(max_iter):
        sp = torch.zeros_like(r)
        sp[1:] = p_cum[1:] / (r[1:] * Nr[1:].clamp(min=1e-6))
        spp = torch.gradient(sp, spacing=(r,))[0]
        # u'' + u'/r - u/r^2 = -((1-nu)/2r) s'^2 - s' s''
        g = torch.zeros_like(r)
        g[1:] = (-((1 - cfg.nu_mem) / (2 * r[1:])) * sp[1:] ** 2
                 - sp[1:] * spp[1:])
        u_in = torch.linalg.solve(A_in, g[1:-1])
        u = torch.cat([torch.zeros(1, dtype=torch.float64), u_in,
                       torch.zeros(1, dtype=torch.float64)])
        du = torch.gradient(u, spacing=(r,))[0]
        eps_r = du + 0.5 * sp**2
        eps_t = torch.zeros_like(r)
        eps_t[1:] = u[1:] / r[1:]
        eps_t[0] = du[0]
        Nr_new = cfg.T_pre + K * (eps_r + cfg.nu_mem * eps_t)
        delta = float((Nr_new - Nr).abs().max()) / cfg.T_pre
        Nr = (1 - beta) * Nr + beta * Nr_new
        if delta < tol:
            break

    s = torch.cat([torch.zeros(1, dtype=torch.float64),
                   torch.cumulative_trapezoid(sp, r)])
    # area-weighted LSQ parabola s ~ r^2/(4f) + z0 (weight dA ~ r dr)
    w = torch.sqrt(r)[:, None]
    A = torch.stack([r**2, torch.ones_like(r)], dim=1)
    sol = torch.linalg.lstsq(A * w, (s[:, None] * w)).solution.squeeze(1)
    f_fit = float(1.0 / (4.0 * sol[0]))
    resid = s - (A @ sol)
    eps_nl = cfg.E_mem * cfg.t_mem * float(s[-1]) ** 2 / (cfg.T_pre * cfg.a**2)
    return dict(
        r=r, s=s, sp=sp, Nr=Nr, w0=float(s[-1]), f_fit=f_fit,
        z0=float(sol[1]), resid=resid, eps_nl=eps_nl, iters=it + 1,
        f_linear=cfg.T_pre / dp_mean,
    )


# --------------------------------------------------------------------------- #
# 2. ARTIST NURBS fit of the solved membrane shape                            #
# --------------------------------------------------------------------------- #
def sag_interp(mem, rr):
    """Interpolate sag and slope at radii rr (any device/dtype)."""
    xp = mem["r"].to(rr.device, rr.dtype)
    s = interp1d(rr, xp, mem["s"].to(rr.device, rr.dtype))
    sp = interp1d(rr, xp, mem["sp"].to(rr.device, rr.dtype))
    return s, sp


def fit_nurbs(cfg, mem, ctrl_init=None, epochs=None, log_name="nurbs"):
    """Fit an ARTIST NURBSSurface to the solved membrane sag (disc points only)."""
    a = cfg.a
    uu = torch.linspace(1e-5, 1 - 1e-5, cfg.n_fit, device=DEVICE)
    uv = torch.cartesian_prod(uu, uu)
    x = (uv[:, 0] - 0.5) * 2 * a
    y = (uv[:, 1] - 0.5) * 2 * a
    rr = torch.sqrt(x**2 + y**2)
    keep = rr <= a * 0.999
    uv, x, y, rr = uv[keep], x[keep], y[keep], rr[keep]

    z, sp = sag_interp(mem, rr)
    zx = torch.where(rr > 0, sp * x / rr.clamp(min=1e-9), torch.zeros_like(x))
    zy = torch.where(rr > 0, sp * y / rr.clamp(min=1e-9), torch.zeros_like(y))
    tgt_p = torch.stack([x, y, z, torch.ones_like(z)], dim=1)
    n3 = torch.nn.functional.normalize(
        torch.stack([-zx, -zy, torch.ones_like(z)], dim=1), dim=1
    )
    tgt_n = torch.cat([n3, torch.zeros(len(n3), 1, device=DEVICE)], dim=1)

    if ctrl_init is None:
        cxy = torch.linspace(-a, a, cfg.n_cp, device=DEVICE)
        grid = torch.cartesian_prod(cxy, cxy)
        cr = torch.sqrt(grid[:, 0] ** 2 + grid[:, 1] ** 2).clamp(0, a)
        cz, _ = sag_interp(mem, cr)
        ctrl = torch.hstack([grid, cz[:, None]])
        ctrl = ctrl.reshape(cfg.n_cp, cfg.n_cp, 3).clone()
    else:
        ctrl = ctrl_init.clone()
    ctrl = torch.nn.Parameter(ctrl)

    nurbs = NURBSSurface(3, 3, uv[:, 0], uv[:, 1], ctrl, device=DEVICE)
    opt = torch.optim.Adam([ctrl], lr=1e-3)
    sched = torch.optim.lr_scheduler.ReduceLROnPlateau(
        opt, mode="min", factor=0.2, patience=100, threshold=1e-8,
        threshold_mode="abs",
    )
    n_ep = epochs or cfg.nurbs_epochs
    t0 = time.time()
    for ep in range(n_ep):
        pts, nrm = nurbs.calculate_surface_points_and_normals(device=DEVICE)
        loss = (nrm - tgt_n).abs().mean() + 10.0 * (pts - tgt_p).abs().mean()
        opt.zero_grad()
        loss.backward()
        opt.step()
        sched.step(loss.item())
        if loss.item() < 2e-5:
            break
    with torch.no_grad():
        pts, nrm = nurbs.calculate_surface_points_and_normals(device=DEVICE)
        ang = torch.rad2deg(
            torch.acos((nrm[:, :3] * tgt_n[:, :3]).sum(-1).clamp(-1, 1))
        )
    print(
        f"  [{log_name}] {ep + 1} epochs, {time.time() - t0:.1f}s, "
        f"loss {loss.item():.2e}, slope err mean {ang.mean() * 1000:.2f} "
        f"/ max {ang.max() * 1000:.1f} mdeg"
    )
    return ctrl.detach(), float(ang.mean()) * torch.pi / 180.0


def eval_membrane_points(cfg, ctrl, r_inner):
    """Evaluate the fitted NURBS on a trace grid; annulus mask + cell areas.

    Cell aperture areas come from the (u,v)->(x,y) Jacobian of the actual
    NURBS map (finite differences), so collected power is exact for the
    evaluated points regardless of the parameterization.
    """
    n = cfg.n_grid
    uu = torch.linspace(1e-5, 1 - 1e-5, n, device=DEVICE)
    uv = torch.cartesian_prod(uu, uu)
    nurbs = NURBSSurface(3, 3, uv[:, 0], uv[:, 1], ctrl, device=DEVICE)
    with torch.no_grad():
        pts, nrm = nurbs.calculate_surface_points_and_normals(device=DEVICE)
    P = pts.reshape(n, n, 4)
    du = float(uu[1] - uu[0])
    xg, yg = P[..., 0], P[..., 1]
    xu = torch.gradient(xg, spacing=du, dim=0)[0]
    xv = torch.gradient(xg, spacing=du, dim=1)[0]
    yu = torch.gradient(yg, spacing=du, dim=0)[0]
    yv = torch.gradient(yg, spacing=du, dim=1)[0]
    jac = (xu * yv - xv * yu).abs().reshape(-1)
    cell_area = jac * du * du  # horizontal (projected) cell area [m^2]

    rr = torch.sqrt(pts[:, 0] ** 2 + pts[:, 1] ** 2)
    keep = (rr > r_inner) & (rr < cfg.a * 0.985)
    return pts[keep], nrm[keep], cell_area[keep]


# --------------------------------------------------------------------------- #
# 3. Secondary: hyperboloid + optimizable even asphere                        #
# --------------------------------------------------------------------------- #
class Secondary:
    """Axisymmetric z = z_c + A*sqrt(1 + rho^2/B^2) + asphere(rho).

    Hyperboloid branch near F1 with foci (0,0,z_f1), (0,0,z_f2); any ray
    aimed at F1 reflects exactly through F2 when asphere = 0.
    """

    def __init__(self, z_f1, z_f2, z_vertex, rho_max):
        self.zc = 0.5 * (z_f1 + z_f2)
        C = 0.5 * (z_f1 - z_f2)
        self.A = z_vertex - self.zc
        self.B2 = C**2 - self.A**2
        self.rho_max = rho_max
        self.coeffs = torch.zeros(6, device=DEVICE)  # asphere, mm units

    def sag(self, rho2):
        z = self.zc + self.A * torch.sqrt(1 + rho2 / self.B2)
        t = rho2 / self.rho_max**2
        pows = torch.stack([t, t**2, t**3, t**4, t**5, t**6], dim=-1)
        return z + 1e-3 * (pows @ self.coeffs)

    def dsag_drho2(self, rho2):
        d = self.A / (2 * self.B2 * torch.sqrt(1 + rho2 / self.B2))
        t = rho2 / self.rho_max**2
        dp_ = torch.stack(
            [torch.ones_like(t), 2 * t, 3 * t**2, 4 * t**3, 5 * t**4,
             6 * t**5], dim=-1
        ) / self.rho_max**2
        return d + 1e-3 * (dp_ @ self.coeffs)

    def intersect(self, p, d):
        """Ray p + t d (last dim 4). Closed-form hyperboloid root, then Newton
        for the asphere. Returns (hit_points, normals, valid_mask)."""
        px, py, pz = p[..., 0], p[..., 1], p[..., 2]
        dx, dy, dz = d[..., 0], d[..., 1], d[..., 2]
        al = dz**2 / self.A**2 - (dx**2 + dy**2) / self.B2
        be = 2 * ((pz - self.zc) * dz / self.A**2 - (px * dx + py * dy) / self.B2)
        ga = (pz - self.zc) ** 2 / self.A**2 - (px**2 + py**2) / self.B2 - 1
        disc = be**2 - 4 * al * ga
        ok = disc > 0
        sq = torch.sqrt(disc.clamp(min=0))
        t1 = (-be - sq) / (2 * al)
        t2 = (-be + sq) / (2 * al)
        # valid root: t>0 and on upper branch (z > zc)
        z1 = pz + t1 * dz
        z2 = pz + t2 * dz
        v1 = ok & (t1 > 1e-6) & (z1 > self.zc)
        v2 = ok & (t2 > 1e-6) & (z2 > self.zc)
        t = torch.where(v1 & v2, torch.minimum(t1, t2), torch.where(v1, t1, t2))
        valid = v1 | v2
        t = torch.where(valid, t, torch.ones_like(t))
        newton_iters = 8 if (
            self.coeffs.requires_grad or bool((self.coeffs != 0).any())
        ) else 0  # pure hyperboloid: closed form is already exact
        for _ in range(newton_iters):  # Newton for the asphere term
            x, y, z = px + t * dx, py + t * dy, pz + t * dz
            rho2 = x**2 + y**2
            F = z - self.sag(rho2)
            dF = dz - self.dsag_drho2(rho2) * 2 * (x * dx + y * dy)
            t = t - F / dF
        x, y, z = px + t * dx, py + t * dy, pz + t * dz
        rho2 = x**2 + y**2
        valid = valid & (rho2 <= self.rho_max**2) & (t > 1e-6)
        g = self.dsag_drho2(rho2)
        n3 = torch.stack([-2 * g * x, -2 * g * y, torch.ones_like(z)], dim=-1)
        n3 = torch.nn.functional.normalize(n3, dim=-1)
        hit = torch.stack([x, y, z, torch.ones_like(z)], dim=-1)
        nrm = torch.cat([n3, torch.zeros_like(z)[..., None]], dim=-1)
        return hit, nrm, valid


# --------------------------------------------------------------------------- #
# 4. Trace: sun -> membrane -> secondary -> window -> oven                    #
# --------------------------------------------------------------------------- #
def trace(cfg, pts, nrm, cell_area, secondary, sun=None, n_rays=1):
    """Full beam-down trace. Returns dict of per-ray tensors (flattened R*P)."""
    P = pts.shape[0]
    dev = pts.device
    if sun is not None and n_rays > 1:
        ds = sun.distribution.sample((n_rays, P))  # [R,P,2] angle offsets
        inc3 = torch.stack(
            [ds[..., 0], ds[..., 1], -torch.ones(n_rays, P, device=dev)],
            dim=-1,
        )
        inc3 = torch.nn.functional.normalize(inc3, dim=-1)
        inc = torch.cat([inc3, torch.zeros(n_rays, P, 1, device=dev)], dim=-1)
    else:
        inc = torch.tensor([0.0, 0.0, -1.0, 0.0], device=dev).expand(1, P, 4)
    R = inc.shape[0]

    power = (cfg.dni * cell_area / R).expand(R, P).reshape(-1)  # W per ray
    origins = pts.expand(R, P, 4).reshape(-1, 4)
    normals = nrm.expand(R, P, 4).reshape(-1, 4)
    d1 = reflect(inc.reshape(-1, 4), normals)
    power = power * cfg.rho_mem

    hit2, n2, ok2 = secondary.intersect(origins, d1)
    d2 = reflect(d1, n2)
    power = power * cfg.rho_sec

    # clear-window crossing at the membrane plane z = 0
    tw = -hit2[:, 2] / d2[:, 2].clamp(max=-1e-9)
    wpt = hit2 + tw[:, None] * d2
    rho_w = torch.sqrt(wpt[:, 0] ** 2 + wpt[:, 1] ** 2)
    # pit-mouth crossing at the F2 plane z = -pivot_drop (the beam waist)
    tp = (-cfg.pivot_drop - hit2[:, 2]) / d2[:, 2].clamp(max=-1e-9)
    ppit = hit2 + tp[:, None] * d2
    rho_p = torch.sqrt(ppit[:, 0] ** 2 + ppit[:, 1] ** 2)
    through = (
        ok2 & (d2[:, 2] < 0)
        & (rho_w <= cfg.r_window) & (rho_p <= cfg.r_pit)
    )
    power_oven = power * cfg.T_window

    # oven sphere first strike (crown = the pit mouth cut)
    zc = -cfg.pivot_drop - float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
    oc = torch.tensor([0.0, 0.0, zc], device=dev)
    q = ppit[:, :3] - oc
    b = (q * d2[:, :3]).sum(-1)
    c = (q * q).sum(-1) - cfg.R_oven**2
    disc = b**2 - c
    ts = -b + torch.sqrt(disc.clamp(min=0))
    strike = ppit[:, :3] + ts[:, None] * d2[:, :3]
    return dict(
        origins=origins, d1=d1, hit2=hit2, ok2=ok2, d2=d2, wpt=wpt,
        ppit=ppit, through=through, power_at_sec=power, power_oven=power_oven,
        strike=strike, oven_center_z=zc, R=R, P=P,
    )


# --------------------------------------------------------------------------- #
# 5. ARTIST bitmap at the aperture plane                                      #
# --------------------------------------------------------------------------- #
def aperture_bitmap(cfg, tr):
    """Flux map [W/m^2] at the z=0 aperture plane via ARTIST's machinery.

    The detector is horizontal (spans E-N) while ARTIST's sample_bitmaps bins
    world E and U components, so intersections are fed with N and U swapped.
    Per-ray *power* is used as the intensity so the splatted bitmap divided by
    pixel area is exact flux; ARTIST's cosine/r^2 intensity model applies to
    its sun-at-infinity radiance convention, not to a power-conserving
    multi-bounce trace.
    """
    # only rays that actually pass the clear window reach this plane; they
    # carry the window transmission
    rho_w = torch.sqrt(tr["wpt"][:, 0] ** 2 + tr["wpt"][:, 1] ** 2)
    m = tr["ok2"] & (tr["d2"][:, 2] < 0) & (rho_w <= cfg.r_window)
    target = TowerTargetAreas(
        names=["aperture"], geometries=["planar"],
        centers=torch.tensor([[0.0, 0.0, -cfg.pivot_drop, 1.0]],
                             device=DEVICE),
        normal_vectors=torch.tensor([[0.0, 0.0, 1.0, 0.0]], device=DEVICE),
        dimensions=torch.tensor([[2 * cfg.ap_half, 2 * cfg.ap_half]],
                                device=DEVICE),
        curvatures=torch.zeros(1, 2, device=DEVICE),
    )
    rays = Rays(
        ray_directions=tr["d2"][m].reshape(1, 1, -1, 4),
        ray_magnitudes=torch.ones(1, 1, int(m.sum()), device=DEVICE),
    )
    inter, _ = line_plane_intersections(
        rays=rays,
        points_at_ray_origins=tr["hit2"][m].reshape(1, -1, 4),
        target_areas=target,
        target_area_mask=torch.zeros(1, dtype=torch.int32, device=DEVICE),
        device=DEVICE,
    )
    perm = inter[..., [0, 2, 1, 3]]  # N <-> U so the E-N plane spans E-"U"
    stub = SimpleNamespace(
        scenario=SimpleNamespace(target_areas=TowerTargetAreas(
            names=["aperture"], geometries=["planar"],
            centers=torch.tensor([[0.0, 0.0, 0.0, 1.0]], device=DEVICE),
            normal_vectors=torch.tensor([[0.0, 1.0, 0.0, 0.0]], device=DEVICE),
            dimensions=torch.tensor([[2 * cfg.ap_half, 2 * cfg.ap_half]],
                                    device=DEVICE),
            curvatures=torch.zeros(1, 2, device=DEVICE),
        )),
        bitmap_resolution_e=cfg.ap_res,
        bitmap_resolution_u=cfg.ap_res,
        heliostat_group=SimpleNamespace(number_of_active_heliostats=1),
    )
    bmp = HeliostatRayTracer.sample_bitmaps(
        stub,
        perm,
        (tr["power_at_sec"][m] * cfg.T_window).reshape(1, 1, -1),
        active_heliostats_mask=torch.ones(1, dtype=torch.bool, device=DEVICE),
        target_area_mask=torch.zeros(1, dtype=torch.int32, device=DEVICE),
        device=DEVICE,
    )[0]
    pix = (2 * cfg.ap_half / cfg.ap_res) ** 2
    # sample_bitmaps writes [res-1-y, res-1-x]; one flip of both axes restores
    # +E right / +N up for imshow(origin="lower")
    return torch.flip(bmp, dims=[0, 1]).cpu().numpy() / pix


def oven_wall_map(cfg, tr):
    """First-strike flux [W/m^2] on the cavity wall, unrolled in
    (azimuth, cos polar angle) so bins are equal-area."""
    m = tr["through"]
    s = tr["strike"][m]
    p = tr["power_oven"][m]
    zc = tr["oven_center_z"]
    ct = ((s[:, 2] - zc) / cfg.R_oven).clamp(-1, 1)
    phi = torch.atan2(s[:, 1], s[:, 0])
    ct_max = float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2) / cfg.R_oven)
    iphi = ((phi + np.pi) / (2 * np.pi) * cfg.oven_res_phi).long().clamp(
        0, cfg.oven_res_phi - 1
    )
    ict = ((ct + 1) / (1 + ct_max) * cfg.oven_res_ct).long().clamp(
        0, cfg.oven_res_ct - 1
    )
    grid = torch.zeros(cfg.oven_res_ct, cfg.oven_res_phi, device=p.device)
    grid.index_put_((ict, iphi), p, accumulate=True)
    cell = cfg.R_oven**2 * (2 * np.pi / cfg.oven_res_phi) * (
        (1 + ct_max) / cfg.oven_res_ct
    )
    return grid.cpu().numpy() / cell, ct_max


# --------------------------------------------------------------------------- #
# 6. Aspheric secondary optimization (differentiable raytrace)                #
# --------------------------------------------------------------------------- #
def optimize_asphere(cfg, pts, nrm, secondary, mode="point", r_ring=0.10,
                     iters=500, coeffs_init=None):
    """Gradient-shape the secondary through the differentiable raytrace.

    mode="point": minimize RMS radius at F2 (cancel the Hencky aberration).
    mode="ring":  aim the floor strike points at an annulus of radius r_ring
                  (spread the coal-bed spot for even cooking), with a soft
                  penalty keeping rays inside the window.
    """
    coeffs = (coeffs_init.clone() if coeffs_init is not None
              else torch.zeros(6, device=DEVICE)).requires_grad_(True)
    opt = torch.optim.Adam([coeffs], lr=0.03)
    inc = torch.tensor([0.0, 0.0, -1.0, 0.0], device=DEVICE).expand(
        pts.shape[0], 4
    )
    d1 = reflect(inc, nrm).detach()
    zc = -cfg.pivot_drop - float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
    oc = torch.tensor([0.0, 0.0, zc], device=DEVICE)
    for _ in range(iters):
        secondary.coeffs = coeffs
        hit2, n2, ok = secondary.intersect(pts, d1)
        d2 = reflect(d1, n2)
        tp = (-cfg.pivot_drop - hit2[:, 2]) / d2[:, 2].clamp(max=-1e-9)
        ppit = hit2 + tp[:, None] * d2
        rho_p2 = ppit[:, 0] ** 2 + ppit[:, 1] ** 2
        if mode == "point":
            loss = (rho_p2 * ok).sum() / ok.sum() * 1e6  # mm^2 at F2
        else:
            q = ppit[:, :3] - oc
            b = (q * d2[:, :3]).sum(-1)
            c = (q * q).sum(-1) - cfg.R_oven**2
            ts = -b + torch.sqrt((b**2 - c).clamp(min=1e-12))
            strike = ppit[:, :3] + ts[:, None] * d2[:, :3]
            rho_f = torch.sqrt(
                strike[:, 0] ** 2 + strike[:, 1] ** 2 + 1e-12
            )
            loss = ((rho_f - r_ring) ** 2 * ok).sum() / ok.sum() * 1e6
            pen = torch.relu(
                torch.sqrt(rho_p2 + 1e-12) - 0.9 * cfg.r_pit
            ) ** 2
            loss = loss + 20.0 * (pen * ok).sum() / ok.sum() * 1e6
        opt.zero_grad()
        loss.backward()
        opt.step()
    secondary.coeffs = coeffs.detach()
    return coeffs.detach(), float(np.sqrt(loss.item()))


def oven_temperature(cfg, p_in):
    """Rough steady cavity temperature: buried-sphere conduction through the
    firebrick + soil, plus re-radiation out of the aperture."""
    A_ap = np.pi * cfg.r_pit**2
    A_wall = 4 * np.pi * cfg.R_oven**2 * 0.97
    R_th = 0.10 / (0.7 * A_wall) + 1.0 / (4 * np.pi * 1.3 * (cfg.R_oven + 0.10))
    sig, T0 = 5.67e-8, 300.0
    lo, hi = T0, 1500.0
    for _ in range(60):
        T = 0.5 * (lo + hi)
        out = (T - T0) / R_th + 0.9 * sig * (T**4 - T0**4) * A_ap
        lo, hi = (T, hi) if out < p_in else (lo, T)
    return T - 273.15


# --------------------------------------------------------------------------- #
# 6b. Multiple small pumps: zoned plenum as a K-DOF adaptive mirror           #
# --------------------------------------------------------------------------- #
def analytic_membrane_points(cfg, mem, r_inner, n=90):
    """Points/normals/areas straight from the solved profile (no NURBS) -
    used inside the zone-pressure optimization loop where a NURBS refit per
    iteration would dominate the cost. Uniform grid -> exact cell areas."""
    xy = torch.linspace(-cfg.a, cfg.a, n, device=DEVICE)
    X, Y = torch.meshgrid(xy, xy, indexing="ij")
    rr = torch.sqrt(X**2 + Y**2).reshape(-1)
    keep = (rr > r_inner) & (rr < cfg.a * 0.985)
    x, y, rr = X.reshape(-1)[keep], Y.reshape(-1)[keep], rr[keep]
    z, sp = sag_interp(mem, rr)
    pts = torch.stack([x, y, z, torch.ones_like(z)], 1)
    n3 = torch.nn.functional.normalize(
        torch.stack([-sp * x / rr, -sp * y / rr, torch.ones_like(z)], 1),
        dim=1,
    )
    nrm = torch.cat([n3, torch.zeros(len(n3), 1, device=DEVICE)], 1)
    h = float(xy[1] - xy[0])
    return pts, nrm, torch.full_like(rr, h * h)


def optimize_zone_pressures(cfg, secondary, r_inner, n_zones, dp0, iters=6):
    """Gauss-Newton on K plenum-zone pressures (equal-area annuli):
    minimize the RMS ray radius at the pit plane with the AS-BUILT plain
    hyperboloid secondary. The mean pressure is the focus knob; the zone
    differentials cancel the Hencky aberration - each small pump is one
    actuator of a K-DOF adaptive membrane. FD Jacobian over the FvK solve.
    """
    edges = (torch.sqrt(torch.linspace(0.0, 1.0, n_zones + 1)) * cfg.a).numpy()
    p = torch.full((n_zones,), float(dp0), dtype=torch.float64)
    mask = None

    def residuals(pz):
        mem = solve_membrane(cfg, pz.numpy(), n=500, zone_edges=edges)
        pts, nrm, _ = analytic_membrane_points(cfg, mem, r_inner)
        tr = trace(cfg, pts, nrm,
                   torch.full((pts.shape[0],), 1e-6, device=DEVICE), secondary)
        pp = tr["ppit"]
        rad = torch.sqrt(pp[:, 0] ** 2 + pp[:, 1] ** 2 + 1e-12)
        return rad.cpu().double(), tr["ok2"].cpu()

    for it in range(iters):
        r_all, ok = residuals(p)
        if mask is None:
            mask = ok  # freeze row alignment across FD perturbations
        r0 = r_all[mask]
        J = torch.zeros(len(r0), n_zones, dtype=torch.float64)
        dpert = 2.0
        for k in range(n_zones):
            pk = p.clone()
            pk[k] += dpert
            J[:, k] = (residuals(pk)[0][mask] - r0) / dpert
        JtJ = J.T @ J
        A = JtJ + 1e-2 * JtJ.diagonal().mean() * torch.eye(
            n_zones, dtype=torch.float64
        )
        p = p + torch.linalg.solve(A, -(J.T @ r0)).clamp(-60, 60)
        print(f"    GN iter {it}: waist RMS {float(torch.sqrt((r0**2).mean())) * 1000:.1f} mm"
              f", zones [Pa] = {np.array2string(p.numpy(), precision=1)}")
    return p, edges


# --------------------------------------------------------------------------- #
# 7. Deposition uniformity (the incandescent bulb's actual job)               #
# --------------------------------------------------------------------------- #
def deposition_map(cfg, h_src=1.5, n=241):
    """Al thickness on the flat membrane from a point evaporation source at
    height h_src over the center, normalized to center thickness; the window
    disc is masked during coating."""
    x = torch.linspace(-cfg.a, cfg.a, n)
    X, Y = torch.meshgrid(x, x, indexing="xy")
    r2 = X**2 + Y**2
    t_rel = (1 + r2 / h_src**2) ** -1.5
    t_rel[r2 > cfg.a**2] = torch.nan
    t_masked = t_rel.clone()
    t_masked[r2 < cfg.r_window**2] = 0.0
    return x.numpy(), t_masked.numpy(), t_rel.numpy()


# --------------------------------------------------------------------------- #
# 8. Sun paths and the tracked beam-down (GIF mode)                           #
# --------------------------------------------------------------------------- #
def solar_position(lat_deg, day_of_year, hour):
    """Solar elevation [deg] and ENU unit vector toward the sun."""
    phi = np.radians(lat_deg)
    delta = np.radians(23.44) * np.sin(2 * np.pi * (284 + day_of_year) / 365)
    h = np.radians(15.0 * (hour - 12.0))
    sin_el = np.sin(phi) * np.sin(delta) + np.cos(phi) * np.cos(delta) * np.cos(h)
    el = np.arcsin(np.clip(sin_el, -1, 1))
    cos_az = (np.sin(delta) - sin_el * np.sin(phi)) / max(
        np.cos(el) * np.cos(phi), 1e-9
    )
    az = np.arccos(np.clip(cos_az, -1, 1))
    if h > 0:
        az = 2 * np.pi - az
    s = np.array([np.cos(el) * np.sin(az), np.cos(el) * np.cos(az), sin_el])
    return np.degrees(el), az, s


def clear_sky_dni(el_deg):
    """Meinel clear-sky DNI [W/m^2] from solar elevation."""
    if el_deg <= 2.0:
        return 0.0
    am = 1.0 / np.sin(np.radians(el_deg))
    return 1353.0 * 0.7 ** (am**0.678)


def rotation_z_to(s_np):
    """torch rotation matrix R with R @ z_hat = s (Rodrigues)."""
    s = torch.tensor(s_np, dtype=torch.float32, device=DEVICE)
    z = torch.tensor([0.0, 0.0, 1.0], device=DEVICE)
    v = torch.linalg.cross(z, s)
    c = torch.dot(z, s)
    if float(v.norm()) < 1e-9:
        return torch.eye(3, device=DEVICE)
    vx = torch.tensor(
        [[0.0, -v[2], v[1]], [v[2], 0.0, -v[0]], [-v[1], v[0], 0.0]],
        device=DEVICE,
    )
    return torch.eye(3, device=DEVICE) + vx + vx @ vx * (1 - c) / (v.norm() ** 2)


def traced_frame(cfg, pts, nrm, area, secondary, sun, s_np, dni_now):
    """One tracked time step: trace in the assembly frame (sun on axis),
    rotate the post-window beam rigidly about the F2 pivot into world frame,
    clip at the fixed pit mouth, and strike the fixed oven sphere."""
    tr = trace(cfg, pts, nrm, area, secondary, sun=sun, n_rays=cfg.n_sun_rays)
    scale = dni_now / cfg.dni
    R = rotation_z_to(s_np)
    # the clear window rides with the assembly; the pit mouth does not.
    # keep rays through the (assembly-frame) window only, then clip at the
    # fixed world pit after the pivot rotation.
    rho_w = torch.sqrt(tr["wpt"][:, 0] ** 2 + tr["wpt"][:, 1] ** 2)
    m = tr["ok2"] & (tr["d2"][:, 2] < 0) & (rho_w <= cfg.r_window)
    piv = torch.tensor([0.0, 0.0, -cfg.pivot_drop], device=DEVICE)
    wpt = (R @ (tr["wpt"][m, :3] - piv).T).T  # world: origin = pit mouth
    d2 = (R @ tr["d2"][m, :3].T).T
    # fixed pit mouth at world z=0: exactly the sphere's top cut (radius
    # r_pit), so admitted crossings are inside the sphere and the far
    # quadratic root below is the first wall strike
    tcross = -wpt[:, 2] / d2[:, 2].clamp(max=-1e-9)
    pcross = wpt + tcross[:, None] * d2
    admit = (
        (d2[:, 2] < 0)
        & (pcross[:, 0] ** 2 + pcross[:, 1] ** 2 <= cfg.r_pit**2)
    )
    zc = -float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
    oc = torch.tensor([0.0, 0.0, zc], device=DEVICE)
    q = pcross - oc
    b = (q * d2).sum(-1)
    c = (q * q).sum(-1) - cfg.R_oven**2
    ts = -b + torch.sqrt((b**2 - c).clamp(min=0))
    strike = pcross + ts[:, None] * d2
    power = tr["power_oven"][m] * scale
    return dict(
        through=admit, strike=strike, power_oven=power * admit,
        oven_center_z=zc,
        p_oven=float((power * admit).sum()),
        R=R,
    )


def run_gif(cfg, mem, pts, nrm, area, secondary, out, lat):
    """Render the tracked system over three representative days as a GIF."""
    from PIL import Image

    sun = Sun(number_of_rays=cfg.n_sun_rays, device=DEVICE)
    days = [(355, "winter solstice"), (80, "equinox"), (172, "summer solstice")]
    # mount limit from rim clearance: -a sin(t) + H cos(t) >= -crater
    H_cl = cfg.pivot_drop + mem["w0"] - cfg.rim_drop
    theta_max = float(np.degrees(
        np.arctan2(H_cl, cfg.a)
        + np.arcsin(cfg.crater_depth / np.hypot(cfg.a, H_cl))
    ))
    el_min = 90.0 - theta_max
    print(f"  rim-clearance tilt limit {theta_max:.0f} deg "
          f"-> tracking above el={el_min:.0f} deg")
    zc = -float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
    frames, history = [], []
    rr_t = torch.linspace(-cfg.a, cfg.a, 121, device=DEVICE)
    sag_r = sag_interp(mem, rr_t.abs())[0]
    rs_t = torch.linspace(-secondary.rho_max, secondary.rho_max, 81,
                          device=DEVICE)
    sag_s = secondary.sag(rs_t**2)

    for day, day_name in days:
        hours = np.arange(6.0, 18.01, 0.5)
        for hour in hours:
            el, az, s_np = solar_position(lat, day, hour)
            if el < el_min:
                continue
            dni_now = clear_sky_dni(el)
            fr = traced_frame(cfg, pts, nrm, area, secondary, sun, s_np,
                              dni_now)
            wall, ct_max = oven_wall_map(cfg, fr)
            history.append((day_name, hour, el, dni_now, fr["p_oven"]))

            fig = plt.figure(figsize=(12, 6.2))
            gs = fig.add_gridspec(2, 2, width_ratios=[1.1, 1.4],
                                  height_ratios=[2.2, 1.0])
            axc = fig.add_subplot(gs[:, 0])
            # cross-section in the solar vertical plane (xi = horizontal
            # along the sun azimuth); the assembly meridian along that
            # azimuth stays in this plane under the pivot rotation
            a_hat = torch.tensor(
                [np.sin(az), np.cos(az), 0.0], dtype=torch.float32,
                device=DEVICE,
            )
            R = fr["R"]

            def to_plane(p3):
                return (p3 @ a_hat).cpu().numpy(), p3[:, 2].cpu().numpy()

            zhat = torch.tensor([0.0, 0.0, 1.0], device=DEVICE)
            mem3 = (a_hat[None, :] * rr_t[:, None]
                    + zhat[None, :] * (sag_r + cfg.pivot_drop)[:, None])
            sec3 = (a_hat[None, :] * rs_t[:, None]
                    + zhat[None, :] * (sag_s + cfg.pivot_drop)[:, None])
            for curve, color, lw in ((mem3, "#1f77b4", 3), (sec3, "#d62728", 3)):
                xi, zz = to_plane((R @ curve.T).T)
                axc.plot(xi, zz, color=color, lw=lw, zorder=3)
            # gimbal pedestal: pit collar up to the membrane vertex
            vtx = (R @ (zhat * cfg.pivot_drop)).cpu().numpy()
            axc.plot([0, float(np.dot(vtx[:2], a_hat.cpu().numpy()[:2]))],
                     [0, vtx[2]], color="0.35", lw=4, zorder=1)
            th = np.linspace(0, 2 * np.pi, 200)
            ox, oz = cfg.R_oven * np.cos(th), zc + cfg.R_oven * np.sin(th)
            axc.plot(ox[oz < 0], oz[oz < 0], color="#8c564b", lw=4, zorder=2)
            belt = np.abs(oz - zc) < cfg.belt_half
            for side in (ox > 0, ox < 0):
                mm_ = belt & (oz < 0) & side
                axc.plot(ox[mm_], oz[mm_], color="#2ca02c", lw=6, zorder=2)
            st = fr["strike"][fr["through"]]
            if len(st):
                xi, zz = to_plane(st[::37])
                axc.plot(xi, zz, ".", color="#f5a623", ms=2, alpha=0.5)
            tilt = np.degrees(np.arccos(s_np[2]))
            s_xi = float(np.dot(s_np[:2], a_hat.cpu().numpy()[:2]))
            axc.plot([0, 5 * s_xi], [cfg.pivot_drop, cfg.pivot_drop + 5 * s_np[2]],
                     color="gold", lw=2, ls=":")
            # grade with the saucer crater the rim swings into; the crater
            # floor must cover the rim's full swing reach hypot(a, H) for
            # the flat-floor clearance formula to hold. the pit collar
            # rises from the crater floor back up to grade.
            d_c = cfg.crater_depth
            R_floor = float(np.hypot(cfg.a, H_cl)) + 0.1
            for sgn in (-1, 1):
                axc.plot(
                    [sgn * 8.0, sgn * (R_floor + 0.4), sgn * R_floor,
                     sgn * (cfg.r_pit + 0.15), sgn * (cfg.r_pit + 0.15),
                     sgn * cfg.r_pit],
                    [0, 0, -d_c, -d_c, 0, 0],
                    color="k", lw=1.2, alpha=0.6, zorder=1,
                )
            # sun is always on the +xi side, so the assembly tilts that way
            axc.set_xlim(-3.0, 8.0)
            axc.set_ylim(zc - cfg.R_oven - 0.1, 8.0)
            axc.set_aspect("equal")
            axc.set_title(f"{day_name}  {int(hour):02d}:{int(hour % 1 * 60):02d}"
                          f"  el={el:.0f}° tilt={tilt:.0f}°")
            axc.set_xlabel("solar-plane horizontal [m]")
            axc.set_ylabel("U [m]")

            axw = fig.add_subplot(gs[0, 1])
            im = axw.imshow(
                wall / 1000, aspect="auto", origin="lower", cmap="inferno",
                extent=[-180, 180, zc - cfg.R_oven, zc + ct_max * cfg.R_oven],
                vmin=0, vmax=45,
            )
            for sgn in (+1, -1):
                axw.axhline(zc + sgn * cfg.belt_half, color="#2ca02c",
                            ls="--", lw=1)
            axw.set_title(f"oven wall first-strike flux "
                          f"({fr['p_oven']:.0f} W into oven)")
            axw.set_xlabel("azimuth [deg]"), axw.set_ylabel("depth [m]")
            fig.colorbar(im, ax=axw, label="kW/m$^2$")

            axp = fig.add_subplot(gs[1, 1])
            for dn, marker in zip([d[1] for d in days], ["o", "s", "^"]):
                hh = [h for (n, h, e, d_, p) in history if n == dn]
                pp = [p / 1000 for (n, h, e, d_, p) in history if n == dn]
                if hh:
                    axp.plot(hh, pp, marker, ms=3, ls="-", lw=1, label=dn)
            axp.set_xlim(6, 18), axp.set_ylim(0, 6)
            axp.set_xlabel("solar hour"), axp.set_ylabel("kW into oven")
            axp.legend(fontsize=7, loc="upper right")
            fig.tight_layout()
            fig.canvas.draw()
            frames.append(Image.fromarray(
                np.asarray(fig.canvas.buffer_rgba())[..., :3]
            ))
            plt.close(fig)

    for dn in {d[1] for d in days}:
        rows = [(h, p) for (n, h, e, d_, p) in history if n == dn]
        if len(rows) > 1:
            hh, pp = zip(*rows)
            kwh = np.trapezoid(pp, hh) / 1000
            print(f"  [{dn}] usable {hh[0]:.1f}h-{hh[-1]:.1f}h, "
                  f"{kwh:.1f} kWh into oven")
    gif = out / "suncycle.gif"
    frames[0].save(gif, save_all=True, append_images=frames[1:],
                   duration=220, loop=0)
    print(f"  wrote {gif} ({len(frames)} frames)")


# --------------------------------------------------------------------------- #
# Main                                                                        #
# --------------------------------------------------------------------------- #
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out_tandoor")
    ap.add_argument("--quick", action="store_true", help="reduced epochs/rays")
    ap.add_argument("--radius", type=float, default=None,
                    help="membrane clamp radius [m] (f1 stays T/dp)")
    ap.add_argument("--window", type=float, default=None,
                    help="clear membrane window radius [m] (default: auto)")
    ap.add_argument("--pit", type=float, default=None,
                    help="pit mouth / oven aperture radius [m]")
    ap.add_argument("--pivot", type=float, default=None,
                    help="pivot drop: F2 below membrane vertex [m]")
    ap.add_argument("--dp", type=float, default=None,
                    help="pump pressure differential [Pa]")
    ap.add_argument("--zgap", type=float, default=None,
                    help="secondary vertex distance below F1 [m]")
    ap.add_argument("--device", default=None, choices=["cpu", "mps", "cuda"],
                    help="override ARTIST's auto device selection")
    ap.add_argument("--zones", type=int, default=0,
                    help="number of plenum pump zones (0 = single plenum)")
    ap.add_argument("--gif", action="store_true",
                    help="render the tracked system over three days as a GIF")
    ap.add_argument("--lat", type=float, default=28.6,
                    help="site latitude [deg] for the sun-path GIF")
    args = ap.parse_args()
    if args.device:
        global DEVICE
        DEVICE = torch.device(args.device)
    out = pathlib.Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    cfg = CFG
    if args.radius:
        cfg.a = args.radius
        cfg.ap_half = 0.4 * max(1.0, args.radius)
    if args.window:
        cfg.r_window = args.window
    if args.pit:
        cfg.r_pit = args.pit
    if args.pivot:
        cfg.pivot_drop = args.pivot
    if args.dp:
        cfg.dp = args.dp
    if args.zgap:
        cfg.z_gap = args.zgap
    if args.quick:
        cfg.nurbs_epochs, cfg.n_sun_rays, cfg.n_grid = 800, 8, 80

    print("== 1. Membrane FvK solve ==")
    mem = solve_membrane(cfg, cfg.dp)
    print(
        f"  dp={cfg.dp:.0f} Pa  T={cfg.T_pre:.0f} N/m  linear f={mem['f_linear']:.2f} m\n"
        f"  solved: w0={mem['w0'] * 1000:.1f} mm  best-fit f={mem['f_fit']:.3f} m  "
        f"eps_nl={mem['eps_nl']:.2f}  non-parabolicity p2v="
        f"{(mem['resid'].max() - mem['resid'].min()) * 1000:.2f} mm  "
        f"({mem['iters']} iters)"
    )

    z_f1 = mem["z0"] + mem["f_fit"]
    z_vertex = z_f1 - cfg.z_gap
    # size the secondary from the ACTUAL solved shape's reflected rays at the
    # z_vertex plane (the Hencky longitudinal aberration puts axis crossings
    # well below the best-fit F1, so the parabola marginal underestimates)
    rr_m = torch.linspace(0.05 * cfg.a, cfg.a, 400)
    s_m, sp_m = sag_interp(mem, rr_m)
    n_m = torch.nn.functional.normalize(
        torch.stack([-sp_m, torch.zeros_like(sp_m), torch.ones_like(sp_m),
                     torch.zeros_like(sp_m)], dim=1), dim=1)
    d_m = reflect(torch.tensor([0.0, 0.0, -1.0, 0.0]).expand(len(rr_m), 4), n_m)
    x_at_v = rr_m + (z_vertex - s_m) / d_m[:, 2] * d_m[:, 0]
    # cover BOTH the as-built Hencky shape and the zone-corrected (parabolic)
    # state, whose marginal ray arrives less converged
    rho_parab = cfg.a * (z_f1 - z_vertex) / (z_f1 - mem["w0"])
    rho_marg = max(float(x_at_v.abs().max()), rho_parab)
    r_sec = cfg.sec_margin * rho_marg
    # F2 sits pivot_drop below the membrane vertex: the assembly gimbals
    # about the pit mouth without the rim sweeping below grade
    secondary = Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec)
    if cfg.r_window is None:
        # worst-case marginal at the membrane plane: secondary rim to the
        # far pit edge (projected), plus margin
        cfg.r_window = ((r_sec * cfg.pivot_drop + cfg.r_pit * z_vertex)
                        / (z_vertex + cfg.pivot_drop) + 0.03)
    r_inner = max(r_sec, cfg.r_window)
    # rim clearance: -a sin(t) + H cos(t) >= -crater; H allows rim_drop of
    # plenum/clamp hardware hanging below the membrane sheet
    H_cl = cfg.pivot_drop + mem["w0"] - cfg.rim_drop
    theta_max = float(np.degrees(
        np.arctan2(H_cl, cfg.a)
        + np.arcsin(cfg.crater_depth / np.hypot(cfg.a, H_cl))
    ))
    print(
        f"  secondary: vertex z={z_vertex:.2f} m, rim radius {r_sec:.3f} m, "
        f"foci ({z_f1:.2f}, {-cfg.pivot_drop:.2f}) m, magnification "
        f"{(z_vertex + cfg.pivot_drop) / (z_f1 - z_vertex):.1f}x\n"
        f"  window r={cfg.r_window:.2f} m, pit r={cfg.r_pit:.2f} m, "
        f"pivot {cfg.pivot_drop:.1f} m above pit; rim-clearance tilt limit "
        f"~{theta_max:.0f} deg (crater {cfg.crater_depth:.2f} m)"
    )

    print("== 2. Self-test: ideal parabola + pure hyperboloid ==")
    par = dict(mem)
    par["s"] = mem["r"] ** 2 / (4 * mem["f_fit"])
    par["sp"] = mem["r"] / (2 * mem["f_fit"])
    par["z0"] = 0.0
    ctrl_par, _ = fit_nurbs(cfg, par, epochs=cfg.nurbs_epochs, log_name="parabola")
    pts0, nrm0, area0 = eval_membrane_points(cfg, ctrl_par, r_inner)
    sec_test = Secondary(mem["f_fit"], -cfg.pivot_drop,
                         mem["f_fit"] - cfg.z_gap, r_sec)
    tr0 = trace(cfg, pts0, nrm0, area0, sec_test)
    w = tr0["ppit"][tr0["ok2"]]
    rms0 = float(torch.sqrt((w[:, 0] ** 2 + w[:, 1] ** 2).mean()))
    print(f"  waist RMS radius at F2 = {rms0 * 1000:.2f} mm (expect ~mm: NURBS fit residual only)")
    assert rms0 < 0.02, "Cassegrain self-test failed - pipeline geometry is off"

    print("== 3. NURBS fit of the real (Hencky) membrane ==")
    ctrl, slope_err = fit_nurbs(cfg, mem)
    pts, nrm, area = eval_membrane_points(cfg, ctrl, r_inner)
    p_collect = float((cfg.dni * area).sum())
    print(f"  trace points: {pts.shape[0]}, collected {p_collect:.0f} W "
          f"(annulus {r_inner:.2f}-{cfg.a * 0.985:.2f} m)")

    print("== 4. Optimize aspheric secondaries through the raytrace ==")
    sub = torch.randperm(pts.shape[0], device=DEVICE)[:3000]
    tr_h = trace(cfg, pts, nrm, area, secondary)  # hyperboloid baseline
    wh = tr_h["ppit"][tr_h["ok2"]]
    rms_h = float(torch.sqrt((wh[:, 0] ** 2 + wh[:, 1] ** 2).mean()))
    coeffs, rms_a = optimize_asphere(cfg, pts[sub], nrm[sub], secondary,
                                     mode="point")
    print(f"  waist RMS: hyperboloid {rms_h * 1000:.1f} mm -> aspheric "
          f"{rms_a:.1f} mm; coeffs [mm] = {coeffs.cpu().numpy().round(4)}")
    sec_ring = Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec)
    coeffs_r, res_r = optimize_asphere(cfg, pts[sub], nrm[sub], sec_ring,
                                       mode="ring", coeffs_init=coeffs)
    print(f"  ring-focus asphere: residual {res_r:.1f} mm about the "
          f"0.10 m floor ring; coeffs [mm] = {coeffs_r.cpu().numpy().round(4)}")
    # NOTE: the reachable ring radius is etendue-limited: exit angles at the
    # window are capped at ~atan((r_sec + r_window)/z_vertex) ~ 5.5 deg, so a
    # floor ring beyond ~0.11 m cannot be formed through this aperture.

    if args.gif:
        print("== 5. Sun-path GIF (tracked about the F2 pivot) ==")
        run_gif(cfg, mem, pts, nrm, area, secondary, out, args.lat)
        return

    surfaces = {
        "hyperboloid": (Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec),
                        pts, nrm, area),
        "aspheric": (secondary, pts, nrm, area),
        "ring-focus": (sec_ring, pts, nrm, area),
    }
    if args.zones:
        print(f"== 4b. Multi-pump adaptive membrane ({args.zones} zones, "
              f"plain hyperboloid secondary) ==")
        sec_h = Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec)
        p_opt, edges = optimize_zone_pressures(
            cfg, sec_h, r_inner, args.zones, cfg.dp
        )
        mem_z = solve_membrane(cfg, p_opt.numpy(), zone_edges=edges)
        ctrl_z, _ = fit_nurbs(cfg, mem_z, ctrl_init=ctrl,
                              epochs=cfg.nurbs_epochs, log_name="zoned")
        pts_z, nrm_z, area_z = eval_membrane_points(cfg, ctrl_z, r_inner)
        tr_z = trace(cfg, pts_z, nrm_z, area_z, sec_h)
        wz = tr_z["ppit"][tr_z["ok2"]]
        rms_z = float(torch.sqrt((wz[:, 0] ** 2 + wz[:, 1] ** 2).mean()))
        print(f"  zoned membrane waist RMS (NURBS surface, no asphere): "
              f"{rms_z * 1000:.1f} mm | zone pressures [Pa] = "
              f"{np.array2string(p_opt.numpy(), precision=1)}")
        surfaces["zoned-pumps"] = (sec_h, pts_z, nrm_z, area_z)

    print("== 5. Full raymaps with ARTIST Sun ==")
    sun = Sun(number_of_rays=cfg.n_sun_rays, device=DEVICE)
    results = {}
    for name, (sec, pts_i, nrm_i, area_i) in surfaces.items():
        tr = trace(cfg, pts_i, nrm_i, area_i, sec, sun=sun,
                   n_rays=cfg.n_sun_rays)
        bmp = aperture_bitmap(cfg, tr)
        wall, ct_max = oven_wall_map(cfg, tr)
        p_sec = float(tr["power_at_sec"][tr["ok2"]].sum())
        p_oven = float(tr["power_oven"][tr["through"]].sum())
        spill = 1 - float(tr["ok2"].float().mean())
        rho_w = torch.sqrt(tr["wpt"][:, 0] ** 2 + tr["wpt"][:, 1] ** 2)
        n_ok = tr["ok2"].float().sum()
        win_blk = float((tr["ok2"] & (rho_w > cfg.r_window)).float().sum() / n_ok)
        pit_spill = float(
            (tr["ok2"] & (rho_w <= cfg.r_window) & ~tr["through"]).float().sum()
            / n_ok
        )
        m = tr["through"]
        results[name] = dict(
            bmp=bmp, wall=wall, ct_max=ct_max, p_oven=p_oven,
            strike=tr["strike"][m], strike_p=tr["power_oven"][m],
        )
        print(
            f"  [{name}] after secondary {p_sec:.0f} W | spill {spill * 100:.1f}% | "
            f"window-blocked {win_blk * 100:.1f}% | pit-spill "
            f"{pit_spill * 100:.1f}% | into oven {p_oven:.0f} W | "
            f"peak wall flux {wall.max() / 1000:.1f} kW/m^2 | "
            f"cavity ~{oven_temperature(cfg, p_oven):.0f} C steady"
        )

    print("== 6. Pump sweep (the flux dial) ==")
    sweep = {}
    for fac in (0.985, 1.0, 1.015):
        if fac == 1.0:
            sweep[fac] = results["aspheric"]
            continue
        mem_s = solve_membrane(cfg, cfg.dp * fac)
        ctrl_s, _ = fit_nurbs(
            cfg, mem_s, ctrl_init=ctrl, epochs=max(800, cfg.nurbs_epochs // 4),
            log_name=f"dp x{fac}",
        )
        pts_s, nrm_s, area_s = eval_membrane_points(cfg, ctrl_s, r_inner)
        tr = trace(cfg, pts_s, nrm_s, area_s, secondary, sun=sun,
                   n_rays=cfg.n_sun_rays)
        bmp = aperture_bitmap(cfg, tr)
        wall, ct_max = oven_wall_map(cfg, tr)
        p_oven = float(tr["power_oven"][tr["through"]].sum())
        sweep[fac] = dict(bmp=bmp, wall=wall, ct_max=ct_max, p_oven=p_oven)
        print(f"  dp x{fac}: f_fit={mem_s['f_fit']:.3f} m, into oven {p_oven:.0f} W, "
              f"peak wall {wall.max() / 1000:.1f} kW/m^2")

    # ---------------------------------------------------------------- plots #
    print("== 7. Figures ==")
    plot_all(cfg, mem, ctrl, secondary, results, sweep, tr0=None, out=out,
             z_f1=z_f1, z_vertex=z_vertex, r_sec=r_sec, pts=pts, nrm=nrm)
    print(f"  saved to {out}/")


# --------------------------------------------------------------------------- #
# Plotting                                                                    #
# --------------------------------------------------------------------------- #
def plot_all(cfg, mem, ctrl, secondary, results, sweep, tr0, out, z_f1,
             z_vertex, r_sec, pts, nrm):
    zc = -cfg.pivot_drop - float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))

    # --- Fig 1: the literal raymap (meridional ray fan through the system) ---
    fig, ax = plt.subplots(figsize=(9, 11))
    r_in_fan = max(r_sec, cfg.r_window) * 1.05
    xs = torch.cat([
        torch.linspace(-cfg.a * 0.98, -r_in_fan, 11, device=DEVICE),
        torch.linspace(r_in_fan, cfg.a * 0.98, 11, device=DEVICE),
    ])
    fan_p, fan_sp = sag_interp(mem, xs.abs())
    p4 = torch.stack(
        [xs, torch.zeros_like(xs), fan_p, torch.ones_like(xs)], dim=1
    )
    n3 = torch.nn.functional.normalize(torch.stack(
        [-fan_sp * torch.sign(xs), torch.zeros_like(xs),
         torch.ones_like(xs)], dim=1), dim=1)
    n4 = torch.cat([n3, torch.zeros(len(xs), 1, device=DEVICE)], 1)
    tr = trace(cfg, p4, n4, torch.full((len(xs),), 1e-4, device=DEVICE),
               secondary)
    tr = {k: (v.cpu() if torch.is_tensor(v) else v) for k, v in tr.items()}
    p4c = p4.cpu()
    for i in range(len(xs)):
        if not tr["ok2"][i]:
            continue
        pm = p4c[i, [0, 2]].numpy()
        ps = tr["hit2"][i, [0, 2]].numpy()
        seg = [np.array([pm[0], 1.05 * z_f1]), pm, ps]
        if tr["through"][i]:
            seg += [tr["wpt"][i, [0, 2]].numpy(),
                    tr["strike"][i][[0, 2]].numpy()]
        seg = np.array(seg)
        ax.plot(seg[:, 0], seg[:, 1], color="#f5a623", lw=0.8, alpha=0.85,
                zorder=1)
    rr_t = torch.linspace(-cfg.a, cfg.a, 200, device=DEVICE)
    ss = sag_interp(mem, rr_t.abs())[0].cpu().numpy()
    rr = rr_t.cpu().numpy()
    ax.plot(rr, ss, color="#1f77b4", lw=3, zorder=3, label="membrane (FvK shape)")
    win = np.abs(rr) < cfg.r_window
    ax.plot(rr[win], ss[win], color="#9edae5", lw=3, zorder=4,
            label="clear Mylar window")
    rs = np.linspace(-r_sec, r_sec, 100)
    zs = secondary.sag(
        torch.tensor(rs**2, dtype=torch.float32, device=DEVICE)
    ).cpu().numpy()
    ax.plot(rs, zs, color="#d62728", lw=3, zorder=3, label="aspheric secondary")
    th = np.linspace(0, 2 * np.pi, 200)
    ox, oz = cfg.R_oven * np.cos(th), zc + cfg.R_oven * np.sin(th)
    keepo = oz < 0
    ax.plot(ox[keepo], oz[keepo], color="#8c564b", lw=5, zorder=2,
            label="firebrick oven")
    belt = np.abs(oz - zc) < cfg.belt_half
    for k, side in enumerate((ox > 0, ox < 0)):
        mm_ = belt & keepo & side
        ax.plot(ox[mm_], oz[mm_], color="#2ca02c", lw=7, zorder=2,
                label="roti belt" if k == 0 else None)
    # grade sits at the pit mouth, pivot_drop below the membrane vertex;
    # the gimbal pedestal connects the collar to the membrane
    ax.axhline(-cfg.pivot_drop, color="k", lw=1, ls="--", alpha=0.5)
    ax.plot([0, 0], [-cfg.pivot_drop, 0], color="0.35", lw=4, zorder=1)
    ax.plot([z_f1 * 0], [z_f1], "k*", ms=12, zorder=5)
    ax.annotate("F1", (0.03, z_f1))
    ax.set_xlabel("E [m]")
    ax.set_ylabel("U [m]")
    ax.set_title("Sun -> pump membrane -> aspheric secondary -> tandoor\n"
                 f"dp={cfg.dp:.0f} Pa, f1={mem['f_fit']:.2f} m, "
                 f"eps_nl={mem['eps_nl']:.2f}")
    ax.set_aspect("equal")
    ax.legend(loc="upper right", fontsize=8)
    ax.set_xlim(-1.6, 1.6)
    ax.set_ylim(zc - cfg.R_oven - 0.15, z_f1 + 0.5)
    fig.tight_layout()
    fig.savefig(out / "fig1_raymap_crosssection.png", dpi=150)
    plt.close(fig)

    # --- Fig 2: membrane physics + deposition ---
    fig, axs = plt.subplots(2, 2, figsize=(11, 9))
    mem = {k: (v.cpu().numpy() if torch.is_tensor(v) else v)
           for k, v in mem.items()}
    r = mem["r"]
    axs[0, 0].plot(r, mem["s"] * 1000, label="FvK solution")
    axs[0, 0].plot(r, (r**2 / (4 * mem["f_fit"]) + mem["z0"]) * 1000, "--",
                   label=f"best-fit parabola f={mem['f_fit']:.2f} m")
    axs[0, 0].set_xlabel("r [m]"), axs[0, 0].set_ylabel("sag [mm]")
    axs[0, 0].set_title("Membrane shape"), axs[0, 0].legend()
    axs[0, 1].plot(r, mem["resid"] * 1000, color="crimson")
    axs[0, 1].set_xlabel("r [m]"), axs[0, 1].set_ylabel("dev [mm]")
    axs[0, 1].set_title(f"Non-parabolicity (Hencky), eps_nl={mem['eps_nl']:.2f}")
    axs[1, 0].plot(r, mem["Nr"], color="darkgreen")
    axs[1, 0].axhline(cfg.T_pre, ls="--", color="gray")
    axs[1, 0].set_xlabel("r [m]"), axs[1, 0].set_ylabel("N_r [N/m]")
    axs[1, 0].set_title("Radial tension (pretension dashed)")
    x, dep, _ = deposition_map(cfg)
    im = axs[1, 1].imshow(dep, extent=[-cfg.a, cfg.a, -cfg.a, cfg.a],
                          cmap="viridis", origin="lower")
    axs[1, 1].set_title("Al deposition thickness (bulb evaporator, h=1.5 m)\n"
                        "masked center = oven window")
    fig.colorbar(im, ax=axs[1, 1], label="t / t_center")
    fig.tight_layout()
    fig.savefig(out / "fig2_membrane_physics.png", dpi=150)
    plt.close(fig)

    # --- Fig 3: aperture-plane flux per secondary design ---
    fig, axs = plt.subplots(1, len(results),
                            figsize=(5.7 * len(results), 5.5))
    vmax = max(results[k]["bmp"].max() for k in results) / 1000
    for axx, name in zip(axs, results):
        b = results[name]["bmp"] / 1000
        im = axx.imshow(b, extent=[-cfg.ap_half, cfg.ap_half] * 2,
                        cmap="inferno", origin="lower", vmax=vmax)
        axx.add_patch(patches.Circle((0, 0), cfg.r_pit, fill=False,
                                     color="cyan", ls="--", lw=1.5))
        axx.set_title(f"{name} secondary\n{results[name]['p_oven']:.0f} W into oven")
        axx.set_xlabel("E [m]"), axx.set_ylabel("N [m]")
        fig.colorbar(im, ax=axx, label="kW/m$^2$")
    fig.suptitle("Flux at the pit-mouth plane (F2 waist, ARTIST "
                 "sample_bitmaps); dashed = pit aperture")
    fig.tight_layout()
    fig.savefig(out / "fig3_aperture_flux.png", dpi=150)
    plt.close(fig)

    # --- Fig 4: oven raymaps (unrolled wall + plan view of the floor) ---
    fig, axs = plt.subplots(len(results), 2, figsize=(13, 4.6 * len(results)))
    for i, name in enumerate(results):
        wall, ct_max = results[name]["wall"], results[name]["ct_max"]
        axx = axs[i, 0]
        im = axx.imshow(
            wall / 1000, aspect="auto", origin="lower", cmap="inferno",
            extent=[-180, 180, zc - cfg.R_oven, zc + ct_max * cfg.R_oven],
        )
        for sgn in (+1, -1):
            axx.axhline(zc + sgn * cfg.belt_half, color="#2ca02c", ls="--",
                        lw=1.5)
        axx.text(-175, zc + cfg.belt_half - 0.05, "roti belt",
                 color="#2ca02c", fontsize=9)
        axx.set_title(f"{name}: wall peak {wall.max() / 1000:.1f} kW/m$^2$, "
                      f"{results[name]['p_oven']:.0f} W")
        axx.set_xlabel("azimuth [deg]"), axx.set_ylabel("depth z [m]")
        fig.colorbar(im, ax=axx, label="kW/m$^2$")
        # plan view of the coal bed; weight by |z - zc|/R so the horizontal-
        # area division yields true flux on the tilted spherical wall
        s = results[name]["strike"].cpu().numpy()
        p = results[name]["strike_p"].cpu().numpy()
        p = p * np.abs(s[:, 2] - zc) / cfg.R_oven
        ext = cfg.R_oven
        H, xe, ye = np.histogram2d(
            s[:, 0], s[:, 1], bins=90,
            range=[[-ext, ext], [-ext, ext]], weights=p,
        )
        pix = (xe[1] - xe[0]) * (ye[1] - ye[0])
        axf = axs[i, 1]
        im = axf.imshow(H.T / pix / 1000, extent=[-ext, ext, -ext, ext],
                        origin="lower", cmap="inferno")
        axf.add_patch(patches.Circle((0, 0), cfg.R_oven, fill=False,
                                     color="#8c564b", lw=2))
        axf.set_title("floor plan view")
        axf.set_xlabel("E [m]"), axf.set_ylabel("N [m]")
        fig.colorbar(im, ax=axf, label="kW/m$^2$")
    fig.suptitle("First-strike flux inside the tandoor "
                 "(left: unrolled wall, right: top-down floor view)")
    fig.tight_layout()
    fig.savefig(out / "fig4_oven_wall_flux.png", dpi=150)
    plt.close(fig)

    # --- Fig 5: pump sweep ---
    fig, axs = plt.subplots(2, 3, figsize=(15, 8.5))
    for j, (fac, res) in enumerate(sorted(sweep.items())):
        b = res["bmp"] / 1000
        im = axs[0, j].imshow(b, extent=[-cfg.ap_half, cfg.ap_half] * 2,
                              cmap="inferno", origin="lower")
        axs[0, j].add_patch(patches.Circle((0, 0), cfg.r_pit, fill=False,
                                           color="cyan", ls="--", lw=1))
        axs[0, j].set_title(f"dp = {cfg.dp * fac:.0f} Pa "
                            f"({(fac - 1) * 100:+.1f}%)\n"
                            f"{res['p_oven']:.0f} W into oven")
        fig.colorbar(im, ax=axs[0, j], label="kW/m$^2$")
        im = axs[1, j].imshow(
            res["wall"] / 1000, aspect="auto", origin="lower", cmap="inferno",
            extent=[-180, 180, zc - cfg.R_oven, zc + res["ct_max"] * cfg.R_oven],
        )
        for sgn in (+1, -1):
            axs[1, j].axhline(zc + sgn * cfg.belt_half, color="#2ca02c",
                              ls="--", lw=1)
        axs[1, j].set_xlabel("azimuth [deg]")
        fig.colorbar(im, ax=axs[1, j], label="kW/m$^2$")
    axs[0, 0].set_ylabel("aperture plane N [m]")
    axs[1, 0].set_ylabel("oven wall depth [m]")
    fig.suptitle("The pump is the stove knob: +-1.5% pressure = Cassegrain-"
                 "amplified refocus")
    fig.tight_layout()
    fig.savefig(out / "fig5_pump_sweep.png", dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    main()

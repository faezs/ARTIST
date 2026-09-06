"""
Generic Foeppl-von Karman membrane solver on ARBITRARY domains.

The 1-D axisymmetric solver in 03_membrane_beamdown_tandoor.py can only
express w(r) on a circular rim under uniform pressure. Three things the
designs actually depend on live outside that:

  - ELLIPTICAL / arbitrary rims (the off-axis Scheffler-style section:
    does a pressurised ellipse really give the two-curvature paraboloid
    the polar retrofit assumes?)
  - GRAVITY at tilt (m=1 sag - negligible for bare film at 0.07 kg/m2,
    NOT negligible for a jammed pouch at ~6 kg/m2 against ~170 Pa)
  - ASYMMETRIC pressure (wind m=1 / m=2, zone boundaries, partial
    shading) - the error families no axisymmetric pump can correct.

FORMULATION. Rather than the Airy-function PDE, minimise the FvK energy
directly - it is exactly what torch autograd is for, handles any domain
by weighting, and stays differentiable end-to-end for ARTIST:

  E = integral [ (T/2)|grad w|^2 + T(u,x + v,y)
                 + (K/2)(e_xx^2 + 2 nu e_xx e_yy + e_yy^2
                         + 2(1-nu) e_xy^2)
                 - p w - (body force terms) ] dA

  e_xx = u,x + w,x^2/2      e_yy = v,y + w,y^2/2
  e_xy = (u,y + v,x)/2 + w,x w,y/2        K = E h/(1-nu^2)

Q1 (bilinear) gradients at cell centres, one-point quadrature, cells
weighted by their inside-fraction from the level set so the rim is
resolved to ~O(dx^2) rather than staircased. Clamped rim: w=u=v=0
outside the level set.

Validated against the 1-D solver on a circular rim (see __main__).
"""

import numpy as np
import torch


def _cell_grads(f, dx):
    """Q1 bilinear gradients at cell centres. f is [Nx, Ny] on nodes."""
    fx = ((f[1:, :-1] - f[:-1, :-1]) + (f[1:, 1:] - f[:-1, 1:])) / (2 * dx)
    fy = ((f[:-1, 1:] - f[:-1, :-1]) + (f[1:, 1:] - f[1:, :-1])) / (2 * dx)
    return fx, fy


def _cell_avg(f):
    return 0.25 * (f[:-1, :-1] + f[1:, :-1] + f[:-1, 1:] + f[1:, 1:])


def cell_weights(phi, dx):
    """Inside-fraction of each cell from a level set (phi<0 inside)."""
    frac = torch.clamp(0.5 - phi / dx, 0.0, 1.0)
    return _cell_avg(frac)


def solve_fvk(phi, dx, p, T_pre, E_mod, h_film, nu=0.34, linear=False,
              rho_areal=0.0, tilt_deg=0.0, tilt_dir=(1.0, 0.0),
              iters=(400, 600), lr=None, device=None, verbose=False,
              w_init=None, w0=None):
    """Minimise the FvK energy on the domain {phi < 0}.

    phi   : [Nx, Ny] level set on nodes, metres (negative inside)
    p     : scalar or [Nx, Ny] transverse pressure [Pa]
    T_pre : isotropic pretension [N/m]
    rho_areal, tilt_deg, tilt_dir : gravity of the film+backing at tilt
    w0    : optional [Nx, Ny] REFERENCE SHAPE (metres). None: a flat sheet on
            a planar rim (the classic FvK). Given: the film is pre-formed to
            w0 (gores cut for it), carries the isotropic pretension T_pre in
            that shape, and is fixed to a rim that follows w0 along the
            outline - the SECTION of a sphere on a sphere-conformal rim. The
            unknown is the deviation wt (clamped at the rim), w = w0 + wt,
            with Marguerre's shallow-shell strains
                e_xx = u,x + w0,x wt,x + wt,x^2/2   (etc.)
            and the pretension's work T (w0,x wt,x + w0,y wt,y + |grad wt|^2/2),
            whose first variation -T lap(w0) balances the pressure: for a
            sphere of radius R, p = 2T/R gives wt = 0 exactly (Laplace).
            Shallow-shell theory: trust it to slopes ~0.5; the far end of a
            deep section is reported, not hidden.
    returns dict(w, u, v, wx, wy, inside, cellw, energy[, wt])
    """
    device = device or torch.device("cpu")
    phi = torch.as_tensor(phi, dtype=torch.float64, device=device)
    Nx, Ny = phi.shape
    if not torch.is_tensor(p):
        p = torch.full_like(phi, float(p))
    p = p.to(device=device, dtype=torch.float64)

    inside = phi < 0
    cw = cell_weights(phi, dx)
    if torch.is_tensor(T_pre):
        T_pre = T_pre.to(device=device, dtype=torch.float64)
        T_cell = _cell_avg(T_pre)
        T_ref = float(T_pre.mean())
    else:
        T_cell, T_ref = float(T_pre), float(T_pre)
    K = 0.0 if linear else E_mod * h_film / (1 - nu**2)

    # gravity: normal component adds to p, in-plane component drives u,v
    g_n = rho_areal * 9.81 * np.cos(np.radians(tilt_deg))
    g_t = rho_areal * 9.81 * np.sin(np.radians(tilt_deg))
    td = np.array(tilt_dir, dtype=float)
    td = td / max(np.linalg.norm(td), 1e-12)
    p_eff = p + g_n

    curved = w0 is not None
    if curved:
        w0 = torch.as_tensor(w0, dtype=torch.float64, device=device)
        w0x, w0y = _cell_grads(w0, dx)
        if w_init is None:
            w_init = torch.zeros_like(phi)
    # initial guess: linear membrane solution scaled by the mean pressure
    if w_init is None:
        # exact LINEAR membrane solution w = p(a^2-r^2)/(4T); with a signed
        # distance phi = r-a this is -p*phi*(2a+phi)/(4T)
        a_eq = float((-phi).max())
        d = torch.clamp(-phi, min=0.0)
        w_init = float(p_eff.mean()) * d * (2 * a_eq - d) / (4.0 * T_ref)
    w = (w_init.clone().to(device=device, dtype=torch.float64)
         * inside).requires_grad_(True)
    u = torch.zeros_like(phi, requires_grad=True)
    v = torch.zeros_like(phi, requires_grad=True)

    cut = torch.clamp(-phi / dx, min=0.0, max=1.0)   # 1 inside, 0 at rim

    def energy():
        wm, um, vm = w * cut, u * cut, v * cut
        wx, wy = _cell_grads(wm, dx)
        ux, uy = _cell_grads(um, dx)
        vx, vy = _cell_grads(vm, dx)
        if curved:
            # Marguerre: strains of the deviation from the pre-formed shape
            e_xx = ux + w0x * wx + 0.5 * wx * wx
            e_yy = vy + w0y * wy + 0.5 * wy * wy
            e_xy = 0.5 * (uy + vx) + 0.5 * (w0x * wy + w0y * wx) + 0.5 * wx * wy
            pre = T_cell * (w0x * wx + w0y * wy + 0.5 * (wx * wx + wy * wy))
        else:
            e_xx = ux + 0.5 * wx * wx
            e_yy = vy + 0.5 * wy * wy
            e_xy = 0.5 * (uy + vx) + 0.5 * wx * wy
            pre = 0.5 * T_cell * (wx * wx + wy * wy)
        # NB: the T*(u,x+v,y) term is analytically zero for clamped
        # in-plane BCs (divergence theorem) but is NOT numerically zero
        # under cell weighting - keeping it lets the optimiser manufacture
        # spurious in-plane strain and a far too floppy membrane. Dropped.
        dens = (pre
                + 0.5 * K * (e_xx**2 + 2 * nu * e_xx * e_yy + e_yy**2
                             + 2 * (1 - nu) * e_xy**2)
                - _cell_avg(p_eff) * _cell_avg(wm)
                - g_t * (td[0] * _cell_avg(um) + td[1] * _cell_avg(vm)))
        return (dens * cw).sum() * dx * dx

    n_adam, n_lbfgs = iters
    lr = lr or max(float(np.sqrt(abs(float(p_eff.mean())) / T_ref)) * dx, 1e-6)
    opt = torch.optim.Adam([w, u, v], lr=lr)
    for it in range(n_adam):
        opt.zero_grad()
        loss = energy()
        loss.backward()
        opt.step()
        if verbose and it % 500 == 0:
            print(f"    adam {it:5d}  E={float(loss):+.6e}")
    for _restart in range(3 if n_lbfgs else 0):
        opt2 = torch.optim.LBFGS([w, u, v], max_iter=n_lbfgs,
                                 tolerance_grad=1e-12, tolerance_change=1e-16,
                                 history_size=40, line_search_fn="strong_wolfe")

        def closure():
            opt2.zero_grad()
            loss = energy()
            loss.backward()
            return loss
        opt2.step(closure)

    with torch.no_grad():
        wm = w * cut
        wx, wy = _cell_grads(wm, dx)
        out = dict(w=wm.detach(), u=(u * cut).detach(),
                   v=(v * cut).detach(), wx=wx.detach(), wy=wy.detach(),
                   inside=inside, cellw=cw, energy=float(energy()))
        if curved:
            # report the TOTAL shape; the deviation separately
            out["wt"] = out["w"]
            out["w"] = (w0 * inside).detach() + out["wt"] if False else (w0 + out["wt"]).detach()
            out["wx"], out["wy"] = (w0x + wx).detach(), (w0y + wy).detach()
    return out


def fit_paraboloid(res, dx, extent):
    """Best-fit two-curvature paraboloid z = x^2/(4fx) + y^2/(4fy) + c
    over the inside region -> (fx, fy, rms residual, p2v)."""
    Nx, Ny = res["w"].shape
    xs = torch.linspace(-extent, extent, Nx, dtype=torch.float64)
    X, Y = torch.meshgrid(xs, xs, indexing="ij")
    m = res["inside"]
    A = torch.stack([X[m] ** 2, Y[m] ** 2, torch.ones_like(X[m])], 1)
    b = res["w"][m]
    sol = torch.linalg.lstsq(A, b[:, None]).solution.squeeze(1)
    fx = float(1.0 / (4.0 * sol[0])) if sol[0] != 0 else float("inf")
    fy = float(1.0 / (4.0 * sol[1])) if sol[1] != 0 else float("inf")
    resid = b - A @ sol
    return fx, fy, float(resid.pow(2).mean().sqrt()), float(
        resid.max() - resid.min())


def slope_error(res, dx, extent, fx, fy):
    """RMS surface-slope error vs the best-fit paraboloid [rad].
    Optical blur is twice this."""
    Nx, Ny = res["w"].shape
    xs = torch.linspace(-extent, extent, Nx, dtype=torch.float64)
    X, Y = torch.meshgrid(xs, xs, indexing="ij")
    Xc, Yc = _cell_avg(X), _cell_avg(Y)
    ideal_x = Xc / (2 * fx)
    ideal_y = Yc / (2 * fy)
    m = res["cellw"] > 0.99
    dsx = res["wx"][m] - ideal_x[m]
    dsy = res["wy"][m] - ideal_y[m]
    return float(torch.sqrt((dsx**2 + dsy**2).mean()))


def ellipse_phi(Nx, extent, ax, ay):
    xs = torch.linspace(-extent, extent, Nx, dtype=torch.float64)
    X, Y = torch.meshgrid(xs, xs, indexing="ij")
    # signed-distance-like level set (scaled so |grad phi| ~ 1)
    q = torch.sqrt((X / ax) ** 2 + (Y / ay) ** 2)
    return (q - 1.0) * min(ax, ay)


def grid(N, extent, centre=(0.0, 0.0)):
    """node coordinates X, Y [N, N] of a square box of half-width extent about centre"""
    xs = torch.linspace(-extent, extent, N, dtype=torch.float64)
    X, Y = torch.meshgrid(xs, xs, indexing="ij")
    return X + centre[0], Y + centre[1]


def sphere_w0(X, Y, R):
    """the parent sphere as a reference shape IN THE SOLVER'S CONVENTION:
    w is positive toward the pressure side (the pumped film is a dome in w),
    so the mirror's bowl of sag R - sqrt(R^2 - r^2) (vertex 0, rim high) is
    w0 = -sag. Optics code reading w must negate it back to a sag."""
    return -(R - torch.sqrt(torch.clamp(R * R - X * X - Y * Y, min=1e-9)))


def polar_phi(X, Y, theta, rmax):
    """level set of a star-shaped outline r_max(theta) (theta uniform on [-pi, pi)):
    phi ~ r - r_max(theta(x, y)), negative inside"""
    th = torch.atan2(Y, X); r = torch.sqrt(X * X + Y * Y)
    thn = torch.as_tensor(theta, dtype=torch.float64); rm = torch.as_tensor(rmax, dtype=torch.float64)
    # periodic linear interpolation of r_max
    n = len(thn); dth = float(thn[1] - thn[0]); k = torch.floor((th - thn[0]) / dth).long() % n; fr = ((th - thn[0]) / dth) % 1.0
    rmt = rm[k] * (1 - fr) + rm[(k + 1) % n] * fr
    return r - rmt


def rect_phi(X, Y, x0, x1, y0, y1):
    """level set of an axis-aligned rectangle (signed distance-like)"""
    dx_ = torch.maximum(x0 - X, X - x1); dy_ = torch.maximum(y0 - Y, Y - y1)
    return torch.maximum(dx_, dy_)


def slope_error_vs(res, w0x, w0y, mask=None):
    """RMS slope error of the solved surface against a reference slope field (cell centres) [rad]"""
    m = res["cellw"] > 0.99 if mask is None else mask
    return float(torch.sqrt(((res["wx"] - w0x)[m] ** 2 + (res["wy"] - w0y)[m] ** 2).mean()))

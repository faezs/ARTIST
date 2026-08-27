"""Hashemi's fixed-focus concentrator, checked against our own numbers.

THE CLAIM (Figures 3-5): a SPHERICAL dish of radius R whose centre of
curvature O is held on a circle of radius r = R/2 about a fixed point F,
positioned anti-sun, focuses at F for every sun direction.

WHY IT IS TRUE, and it is more general than the paper says: for a
spherical mirror, parallel rays travelling along unit s focus paraxially
at F = O + (R/2)s. So holding F fixed just means O = F - (R/2)s, which
IS a sphere of radius R/2 about F - the "focal circle". The dish vertex
is then at F + (R/2)s, i.e. also at distance R/2.

But that is only "rotate the dish about its own focus", which is true of
a PARABOLOID too. The real content is mechanical: a sphere is congruent
to itself under rotation about its centre, so the dish can SLIDE along a
fixed circular rail instead of needing a true gimbal whose pivot floats
in mid-air in front of the dish. That is what Figures 5-7 and 14-16 buy,
and it is why the dish must be spherical rather than parabolic.

THE PRICE is spherical aberration, and that is what this measures -
against the thing we actually care about, the pot's 0.14 m air inlet.

WHAT IT WOULD BUY US: the dish always faces the sun square-on, so the
cosine is 1.0. The polar retrofit pays 0.70*cos(decl).
"""
import pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from artist.raytracing.raytracing_utils import reflect
import tandoor_artist_optics as AO

DEV = torch.device("cpu")


def trace_sphere(a_ap, R, s, sigma, n_rays=40000, seed=0, r_hole=0.0):
    """Spherical cap, centre of curvature at O = F - (R/2)s, F at origin.

    Returns the transverse miss distance of each ray at the plane through
    F perpendicular to s. ARTIST supplies the sun cone and the reflection;
    the sphere intersection is closed form because ARTIST has no
    ray-surface intersection primitive.
    """
    s = np.asarray(s, float); s = s / np.linalg.norm(s)
    O = -(R / 2.0) * s                      # F is the origin
    # aperture sampling in the plane normal to s, centred on the axis
    e1 = np.cross(s, [0, 0, 1.0])
    if np.linalg.norm(e1) < 1e-8:
        e1 = np.cross(s, [0, 1.0, 0])
    e1 /= np.linalg.norm(e1); e2 = np.cross(s, e1)
    rng = np.random.default_rng(seed)
    rr = np.sqrt(rng.uniform(r_hole ** 2, a_ap ** 2, n_rays))
    th = rng.uniform(0, 2 * np.pi, n_rays)
    # start well in front of the dish, on the incoming wavefront
    start = (O - 2.0 * R * s)[None, :] + \
        rr[:, None] * (np.cos(th)[:, None] * e1 + np.sin(th)[:, None] * e2)
    # ARTIST solar cone about the direction of travel s
    sun = AO.SunCone(DEV)
    d = sun.scatter(torch.tensor(s, dtype=torch.float32),
                    np.full(1, sigma), 1, n_rays, seed)[0].numpy()
    # closed-form sphere hit, near branch (the cap facing the sun)
    oc = start - O[None, :]
    b = (oc * d).sum(1)
    c = (oc * oc).sum(1) - R ** 2
    disc = b ** 2 - c
    ok = disc > 0
    # FAR branch. The cap is at O + R*s, i.e. the side of the sphere AWAY
    # from the sun; the near root is the sphere's sunward face, which is
    # not the mirror.
    t = -b + np.sqrt(np.clip(disc, 0, None))
    hit = start + t[:, None] * d
    nrm = (O[None, :] - hit) / R                       # inward normal
    d4 = np.c_[d, np.zeros(n_rays)]
    n4 = np.c_[nrm, np.zeros(n_rays)]
    dr = reflect(torch.tensor(d4, dtype=torch.float32),
                 torch.tensor(n4, dtype=torch.float32)).numpy()[:, :3]
    # propagate to the plane through F (origin) normal to s
    den = (dr * s).sum(1)
    tf = -(hit * s).sum(1) / np.where(np.abs(den) > 1e-9, den, 1e-9)
    at_f = hit + tf[:, None] * dr
    return np.linalg.norm(at_f - (at_f * s).sum(1)[:, None] * s, axis=1), ok


if __name__ == "__main__":
    SIG = 5.99e-3          # the envs' total per-axis blur
    R_DUCT = 0.14          # the pot's native air inlet
    print("\n  1. IS THE FOCUS ACTUALLY FIXED?  centroid at F, over the sky")
    print(f"  {'sun el':>7}{'sun az':>8}{'centroid miss':>16}{'rms spot':>11}")
    for el, az in ((15, -80), (35, -20), (55, 40), (75, 120), (89, 0)):
        s = np.array([-np.cos(np.radians(el)) * np.sin(np.radians(az)),
                      -np.cos(np.radians(el)) * np.cos(np.radians(az)),
                      -np.sin(np.radians(el))])
        miss, ok = trace_sphere(1.60, 7.0, s, SIG, seed=1)
        print(f"  {el:>7.0f}{az:>8.0f}{miss[ok].mean()*1e3:>13.1f} mm"
              f"{np.sqrt((miss[ok]**2).mean())*1e3:>8.0f} mm")

    print("\n  2. WHAT SPHERICAL ABERRATION COSTS, vs the 0.14 m duct")
    print(f"  {'a_ap':>6}{'R':>6}{'f=R/2':>7}{'f/#':>6}"
          f"{'rms spot':>11}{'into duct':>11}{'x aperture':>12}")
    s = np.array([0.0, -np.cos(np.radians(50.)), -np.sin(np.radians(50.))])
    best = None
    for a_ap in (0.9, 1.2, 1.6, 2.1):
        for f in (2.5, 3.5, 5.0, 7.0):
            miss, ok = trace_sphere(a_ap, 2 * f, s, SIG, seed=2)
            thru = (miss[ok] < R_DUCT).mean()
            eff = thru * np.pi * a_ap ** 2
            flag = ""
            if best is None or eff > best[0]:
                best = (eff, a_ap, f); flag = "  <-"
            print(f"  {a_ap:>6.2f}{2*f:>6.1f}{f:>7.1f}{f/(2*a_ap):>6.2f}"
                  f"{np.sqrt((miss[ok]**2).mean())*1e3:>8.0f} mm"
                  f"{thru*100:>10.0f}%{eff:>12.2f}{flag}")
    print(f"\n  best geometric throughput: a={best[1]} m, f={best[2]} m "
          f"-> {best[0]:.2f} m2 effective")
    print("\n  3. AGAINST THE POLAR RETROFIT (same film, same duct)")
    print("     polar  : 8.0 m2 aperture x cosine 0.70 = 5.60 m2 effective")
    print(f"     sphere : {np.pi*best[1]**2:.1f} m2 aperture x cosine 1.00, "
          f"minus aberration spill = {best[0]:.2f} m2 effective")


def membrane_is_spherical():
    """Does our FvK membrane want to be a sphere or a paraboloid?

    This matters because Hashemi's mount REQUIRES a sphere - it is the
    sphere's congruence under rotation about its own centre that lets the
    dish slide on a fixed rail instead of needing a gimbal in mid-air.
    Every env here fits a PARABOLOID (f_fit) and charges the residual to
    sig_static. If the membrane is really closer to a sphere, that
    residual is partly self-inflicted.
    """
    from tandoor_rl_env import _sim
    cfg = _sim.CFG
    cfg.a, cfg.T_pre = 1.60, 600.0
    m = _sim.solve_membrane(cfg, 170.0, n=600)
    r = m["r"].numpy(); z = m["s"].numpy()
    keep = r <= cfg.a * 0.98
    r, z = r[keep], z[keep]
    z = z - z[0]
    # best-fit paraboloid z = r^2/(4f)
    A = (r ** 2)[:, None]
    cp = np.linalg.lstsq(A, z, rcond=None)[0][0]
    zp = A[:, 0] * cp
    f_par = 1.0 / (4 * cp)
    # best-fit sphere z = R - sqrt(R^2 - r^2), solved on R
    def sph_res(R):
        return z - (R - np.sqrt(np.clip(R ** 2 - r ** 2, 0, None)))
    # least-squares over R rather than rim-matching, and note the sense:
    # a LARGER R is a shallower sphere, so the residual grows with R.
    Rs = np.linspace(2.0 * cfg.a, 60.0, 20000)
    err = np.array([np.mean(sph_res(R) ** 2) for R in Rs])
    R_sph = float(Rs[np.argmin(err)])
    zs = R_sph - np.sqrt(np.clip(R_sph ** 2 - r ** 2, 0, None))
    # slope error is what actually costs power
    def slope_rms(zfit):
        d = np.gradient(z - zfit, r)
        return np.sqrt(np.mean(d ** 2))
    print("\n  4. IS OUR MEMBRANE A SPHERE OR A PARABOLOID?")
    print(f"     best-fit paraboloid f = {f_par:.3f} m   "
          f"sag residual rms {np.sqrt(np.mean((z-zp)**2))*1e3:.2f} mm   "
          f"slope err {slope_rms(zp)*1e3:.2f} mrad")
    print(f"     best-fit sphere     R = {R_sph:.3f} m (f=R/2={R_sph/2:.3f})"
          f"  sag residual rms {np.sqrt(np.mean((z-zs)**2))*1e3:.2f} mm   "
          f"slope err {slope_rms(zs)*1e3:.2f} mrad")
    better = "SPHERE" if slope_rms(zs) < slope_rms(zp) else "PARABOLOID"
    print(f"     -> the pressurised membrane is closer to a {better}")


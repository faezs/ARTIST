"""Hashemi's fixed-focus concentrator, on ARTIST, with our own membrane.

From fixed-focus-ir.pdf (Ebrahim Hashemi, 2013). A SPHERICAL dish whose
centre of curvature is held on a circle of radius R/2 about a fixed point
F, positioned anti-sun, focuses at F for every sun direction.

WHAT THE MECHANISM ACTUALLY BUYS, which the paper does not say: "the
focus is fixed" is true of ANY dish rotated about its own focal point, a
paraboloid included. The content is that a sphere is congruent to itself
under rotation about its centre, so the dish can SLIDE along a fixed
circular rail; a paraboloid needs a gimbal whose pivot floats in mid-air
in front of the dish. That is what Figures 5-7 and 14-16 solve.

FIRST VERSION OF THIS FILE WAS ONLY HALF ON ARTIST. It hand-rolled a
sphere intersection, a wavefront sampling and the focal-plane hit. The
intersection was never needed: in ARTIST's model the dish is where rays
ORIGINATE, not a surface to intersect - the same pattern the four envs
use. So the dish is now a real ARTIST NURBSSurface carrying our actual
FvK membrane, the cone is ARTIST's Sun, the bounce is ARTIST's reflect,
and the focal plane is ARTIST's line_plane_intersections.

NOTE ON WHAT IS AND IS NOT A TEST: once the dish is parameterised as
"rotated about its own focus", fixed focus is bookkeeping, not a result.
The measurements that matter are the SPOT at F and the effective
aperture, which is what section 2 reports.
"""
import pathlib, sys
import numpy as np, torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
import tandoor_artist_optics as AO

DEV = torch.device("cpu")


def _align(a, b):
    """Rotation carrying unit a onto unit b."""
    a = np.asarray(a, float); b = np.asarray(b, float) / np.linalg.norm(b)
    v = np.cross(a, b); c = float(a @ b)
    if np.linalg.norm(v) < 1e-9:
        return np.eye(3) * (1.0 if c > 0 else -1.0)
    K = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
    return np.eye(3) + K + K @ K / (1 + c)


class FixedFocusDish:
    """Membrane on ARTIST NURBS, mounted to rotate about its own focus."""

    def __init__(self, a_ap, f_target, n_rays=1600, seed=0, tag=""):
        from tandoor_rl_env import _sim
        cfg = _sim.CFG
        cfg.a, cfg.T_pre = float(a_ap), 600.0
        # pressure that puts the FITTED focus at f_target
        lo, hi = cfg.T_pre / (4 * f_target), cfg.T_pre / (0.4 * f_target)
        for _ in range(24):
            mid = 0.5 * (lo + hi)
            m = _sim.solve_membrane(cfg, mid, n=400)
            if m["z0"] + m["f_fit"] > f_target:
                lo = mid
            else:
                hi = mid
        p0 = 0.5 * (lo + hi)
        cfg.dp = p0
        mems = [_sim.solve_membrane(cfg, p0 * s, n=400)
                for s in (0.94, 0.97, 1.00, 1.03, 1.06)]
        self.f = float(mems[2]["z0"] + mems[2]["f_fit"])
        rng = np.random.default_rng(seed)
        rr = np.sqrt(rng.uniform((0.06 * a_ap) ** 2, (0.98 * a_ap) ** 2,
                                 n_rays))
        th = rng.uniform(0, 2 * np.pi, n_rays)
        self.cx, self.cy = rr * np.cos(th), rr * np.sin(th)
        self.primary = AO.MembranePrimary(
            _sim, cfg, mems, self.cx, self.cy, DEV,
            tag=f"ffocus{tag}{a_ap:.2f}f{f_target:.2f}", csr_frac=0.08)
        self.a_ap = float(a_ap)

    def spot_at_focus(self, s, sigma, seed=0):
        """Transverse miss distance at F, for sun travel direction s."""
        s = np.asarray(s, float); s = s / np.linalg.norm(s)
        lv = torch.full((1,), 2.0)
        org, d4, _ = self.primary.bounce(lv, np.full(1, sigma), seed)
        # dish +z faces the sun, so dish->world carries z onto -s; then
        # place it so its own focus lands on F (the origin)
        M = _align([0.0, 0.0, 1.0], -s)
        vertex = self.f * s
        ow = torch.tensor(org[0, :, :3].numpy() @ M.T + vertex,
                          dtype=torch.float32)
        dw = torch.tensor(d4[0, :, :3].numpy() @ M.T, dtype=torch.float32)
        plane = AO.make_plane("focus", [0.0, 0.0, 0.0], (-s).tolist(),
                              8.0, 8.0, DEV)
        hit = AO.hit_plane(
            torch.cat([ow, torch.ones_like(ow[:, :1])], -1),
            torch.cat([dw, torch.zeros_like(dw[:, :1])], -1),
            plane, DEV)[:, :3].numpy()
        return np.linalg.norm(hit - (hit @ s)[:, None] * s[None, :], axis=1)


if __name__ == "__main__":
    SIG, R_DUCT = 5.99e-3, 0.14
    print("\n  ARTIST throughout: NURBSSurface membrane, Sun cone,")
    print("  reflect(), line_plane_intersections(). No hand-rolled optics.")
    print("\n  SPOT AT THE FIXED FOCUS, vs the pot's 0.14 m air inlet")
    print(f"  {'a_ap':>6}{'f':>6}{'f/#':>6}{'f_fit':>8}{'rms spot':>11}"
          f"{'p95':>9}{'into duct':>11}{'effective m2':>14}")
    best = None
    s = np.array([0.0, -np.cos(np.radians(50.)), -np.sin(np.radians(50.))])
    for a_ap in (1.20, 1.60, 2.10):
        for f in (2.5, 3.5, 5.0, 7.0):
            d = FixedFocusDish(a_ap, f)
            miss = d.spot_at_focus(s, SIG, seed=3)
            thru = float((miss < R_DUCT).mean())
            eff = thru * np.pi * a_ap ** 2
            mark = ""
            if best is None or eff > best[0]:
                best = (eff, a_ap, f, thru); mark = "  <-"
            print(f"  {a_ap:>6.2f}{f:>6.1f}{f/(2*a_ap):>6.2f}{d.f:>8.2f}"
                  f"{np.sqrt((miss**2).mean())*1e3:>8.0f} mm"
                  f"{np.percentile(miss,95)*1e3:>6.0f} mm"
                  f"{thru*100:>10.0f}%{eff:>14.2f}{mark}")
    print("\n  INVARIANCE ACROSS THE SKY (bookkeeping, not a result - the")
    print("  dish is parameterised as rotating about its own focus)")
    d = FixedFocusDish(best[1], best[2])
    for el, az in ((15, -80), (45, 30), (75, 140), (89, 0)):
        sv = np.array([-np.cos(np.radians(el))*np.sin(np.radians(az)),
                       -np.cos(np.radians(el))*np.cos(np.radians(az)),
                       -np.sin(np.radians(el))])
        m = d.spot_at_focus(sv, SIG, seed=3)
        print(f"    el {el:>3.0f} az {az:>+5.0f}: rms "
              f"{np.sqrt((m**2).mean())*1e3:5.1f} mm   through "
              f"{float((m<R_DUCT).mean())*100:5.1f}%")
    print("\n  AGAINST THE POLAR RETROFIT, same film and same duct")
    print(f"    polar   8.0 m2 x cosine 0.70            = 5.60 m2")
    print(f"    sphere  {np.pi*best[1]**2:.1f} m2 x cosine 1.00 x "
          f"{best[3]*100:.0f}% = {best[0]:.2f} m2")

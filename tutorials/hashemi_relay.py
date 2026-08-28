"""The fixed relay at Hashemi's focus, and what it actually costs.

ARCHITECTURE: dish on Hashemi's mount (orbits its own focus, always
square to the sun, cosine 1.0) -> FIXED mirror just past the focus F,
on a post through the slot of his Figure 12 -> down a vertical chase ->
M5 -> the pot's native base air-inlet. Three reflections, not five, and
nothing but the dish moves.

THE FOLD ANGLE IS BENIGN, which is the whole reason this is worth
trying. With no secondary the beam at F is still travelling UP toward the
sun, so turning it down is a 90+el deviation, i.e. incidence 45-el/2:
32.5 deg at el 25 falling to 2.5 deg at el 85, footprint never worse than
1.19x. The coude's single fold had the beam already travelling DOWN, so
it needed 90-el, and grazed out at 22.9x.

THE RELAY MUST BE AN ELLIPSOID, NOT A SPHERE. Used at 20 deg incidence a
spherical relay blurs a point source at F to 104-128 mm rms all by
itself, which a 0.14 m duct cannot take. An ellipsoid whose two foci ARE
F and the duct images one exactly onto the other at any tilt: measured
0.00 mm. Same fixed hardware, right conic.

BUT PUTTING A POWERED RELAY PAST THE FOCUS MAKES THIS A GREGORIAN, and a
Gregorian pays the same trade a Cassegrain does. Relay at distance g past
F, duct at L beyond it: magnification m = L/g, so the spot at the duct is
the spot at F times L/g. Keeping m small means large g, and the relay's
radius is a*g/f - it grows until it shadows the dish. That trade is what
this measures, against the pot's real 0.14 m inlet.
"""
import pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from artist.raytracing.raytracing_utils import reflect
from fixed_focus_sphere import FixedFocusDish, _align
import tandoor_artist_optics as AO

DEV = torch.device("cpu")


def trace_relay(dish, a_ap, el_deg, sigma, g, L, r_duct=0.14, seed=0,
                r_relay=None):
    """Dish -> fixed ELLIPSOIDAL relay g past F -> duct L beyond it.

    ARTIST supplies the NURBS dish, the Sun cone and every reflect(); the
    ray-conic intersections are closed form because ARTIST has no
    ray-surface intersection primitive at all.
    """
    el = np.radians(el_deg)
    s = np.array([0.0, -np.cos(el), -np.sin(el)])
    org, d4, _ = dish.primary.bounce(torch.full((1,), 2.0),
                                     np.full(1, sigma), seed)
    Mr = _align([0.0, 0.0, 1.0], -s)
    p = org[0, :, :3].numpy() @ Mr.T + dish.f * s      # F at the origin
    d = d4[0, :, :3].numpy() @ Mr.T
    d /= np.linalg.norm(d, axis=1, keepdims=True)
    axis, v = -s, np.array([0.0, 0.0, -1.0])
    C = g * axis
    F2 = C + L * v
    inc = 45.0 - 0.5 * el_deg
    th = np.arctan(a_ap / dish.f)
    r_ap = g * np.tan(th) if r_relay is None else float(r_relay)
    # ellipsoid with foci at F (origin) and F2
    A = 0.5 * (g + L); ctr = 0.5 * F2
    cc = 0.5 * np.linalg.norm(F2); B2 = A * A - cc * cc
    w = F2 / np.linalg.norm(F2)
    e1 = np.cross(w, [1.0, 0.0, 0.0]); e1 /= np.linalg.norm(e1)
    e2 = np.cross(w, e1)
    Mf = np.stack([e1, e2, w])
    pl = (p - ctr) @ Mf.T; dl = d @ Mf.T
    S = np.array([1 / B2, 1 / B2, 1 / (A * A)])
    qa = (dl * dl * S).sum(1); qb = 2 * (pl * dl * S).sum(1)
    qc = (pl * pl * S).sum(1) - 1
    disc = qb * qb - 4 * qa * qc
    ok = disc > 0
    sq = np.sqrt(np.clip(disc, 0, None))
    t1 = (-qb - sq) / (2 * qa); t2 = (-qb + sq) / (2 * qa)
    h1 = p + t1[:, None] * d; h2 = p + t2[:, None] * d
    pick = np.linalg.norm(h2 - C, axis=1) < np.linalg.norm(h1 - C, axis=1)
    hit = np.where(pick[:, None], h2, h1)
    rho = np.linalg.norm(hit - C - ((hit - C) @ axis)[:, None] * axis, axis=1)
    hl = (hit - ctr) @ Mf.T
    nl = hl * S; nl /= np.linalg.norm(nl, axis=1, keepdims=True)
    nrm = nl @ Mf
    dr = reflect(torch.tensor(np.c_[d, np.zeros(len(d))],
                              dtype=torch.float32),
                 torch.tensor(np.c_[nrm, np.zeros(len(d))],
                              dtype=torch.float32)).numpy()[:, :3]
    tt = ((F2 - hit) @ v) / np.clip(dr @ v, 1e-9, None)
    at = hit + tt[:, None] * dr
    miss = np.linalg.norm(at - F2 - ((at - F2) @ v)[:, None] * v, axis=1)
    caught = ok & (rho < r_ap)
    return dict(through=float((caught & (miss < r_duct)).mean()),
                rms=float(np.sqrt((miss[caught] ** 2).mean()))
                if caught.any() else np.inf,
                r_relay=r_ap, inc=inc, shadow=(r_ap / a_ap) ** 2,
                caught=float(caught.mean()))


if __name__ == "__main__":
    SIG, L = 5.99e-3, 5.0
    print(f"\n  ellipsoidal relay; chase+trench from relay to duct L={L} m")
    print(f"  {'a':>5}{'f_dish':>8}{'g':>6}{'m=L/g':>7}{'relay r':>9}"
          f"{'shadow':>8}{'catch':>7}{'spot rms':>10}{'into duct':>11}"
          f"{'eff m2':>8}")
    best = None
    for a_ap, f_d in ((1.60, 6.0), (1.60, 10.0), (2.10, 8.0), (2.10, 12.0)):
        dish = FixedFocusDish(a_ap, f_d)
        for g in (2.0, 3.5, 5.0, 7.0):
            r = trace_relay(dish, a_ap, 50.0, SIG, g, L)
            net = max(0.0, 1.0 - r["shadow"])
            eff = r["through"] * net * np.pi * a_ap ** 2
            mark = ""
            if best is None or eff > best[0]:
                best = (eff, a_ap, f_d, g); mark = "  <-"
            print(f"  {a_ap:>5.2f}{dish.f:>8.2f}{g:>6.1f}{L/g:>7.2f}"
                  f"{r['r_relay']:>8.2f}m{r['shadow']*100:>7.0f}%"
                  f"{r['caught']*100:>6.0f}%{r['rms']*1e3:>8.0f}mm"
                  f"{r['through']*100:>10.0f}%{eff:>8.2f}{mark}")
    print(f"\n  best: a={best[1]} f={best[2]} g={best[3]} -> "
          f"{best[0]:.2f} m2 effective")
    print("  polar retrofit for reference: 8.0 m2 x 0.70 = 5.60 m2")

"""Hashemi's fixed focus feeding the coude's sideways tunnel.

THE PROPOSAL: drop the translating secondary entirely. Hashemi's mount
already holds the dish's own focus at a fixed point in world space, so
put the mouth of the coude's sideways tunnel THERE, and let the tunnel
carry the light into the pot's native base air-inlet.

WHY THE FIXED ELEMENT CANNOT BE A MIRROR. The mount fixes the focal
POINT, not the arrival DIRECTION - the beam still comes from wherever the
dish is. Any mirror at F must deviate by an angle set by the sun, so its
incidence sweeps and its footprint goes as 1/cos(i): the same failure
coude_direct_fold.py measured. An APERTURE has no such problem, which is
why the tunnel mouth works where a fold does not.

WHAT THIS MEASURES: the beam at F is a cone of half-angle atan(a/f) about
the dish direction, and that direction sweeps the sky. So the question is
what a fixed sideways bore can actually accept.
"""
import pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from fixed_focus_sphere import FixedFocusDish, _align
import tandoor_artist_optics as AO

DEV = torch.device("cpu")


def arrival_at_focus(dish, s, sigma, seed=0):
    """Ray positions AND directions in the plane through F. ARTIST
    NURBS surface, ARTIST Sun, ARTIST reflect, ARTIST plane hit."""
    s = np.asarray(s, float); s = s / np.linalg.norm(s)
    org, d4, _ = dish.primary.bounce(torch.full((1,), 2.0),
                                     np.full(1, sigma), seed)
    M = _align([0.0, 0.0, 1.0], -s)
    ow = torch.tensor(org[0, :, :3].numpy() @ M.T + dish.f * s,
                      dtype=torch.float32)
    dw = torch.tensor(d4[0, :, :3].numpy() @ M.T, dtype=torch.float32)
    plane = AO.make_plane("F", [0., 0., 0.], (-s).tolist(), 12., 12., DEV)
    hit = AO.hit_plane(torch.cat([ow, torch.ones_like(ow[:, :1])], -1),
                       torch.cat([dw, torch.zeros_like(dw[:, :1])], -1),
                       plane, DEV)[:, :3].numpy()
    return hit, dw.numpy() / np.linalg.norm(dw.numpy(), axis=1,
                                            keepdims=True)


def tunnel_throughput(dish, s, sigma, r_t, L, rho=0.90, seed=0,
                      max_bounce=12):
    """Sideways bore along -x from F to the pot. Specular cylinder, so
    spill becomes bounces rather than loss. Returns (fraction delivered,
    mean bounces, weighted throughput)."""
    p, d = arrival_at_focus(dish, s, sigma, seed)
    ax = np.array([-1.0, 0.0, 0.0])              # the tunnel runs -x
    # only rays actually heading into the bore can enter
    fwd = d @ ax > 0.05
    p, d = p[fwd], d[fwd]
    if len(p) == 0:
        return 0.0, 0.0, 0.0
    w = np.ones(len(p))
    # transverse coords in the bore
    e1 = np.array([0.0, 1.0, 0.0]); e2 = np.array([0.0, 0.0, 1.0])
    q = np.stack([p @ e1, p @ e2], 1)
    v = np.stack([d @ e1, d @ e2], 1)
    vx = d @ ax
    x = np.zeros(len(p))
    alive = np.hypot(q[:, 0], q[:, 1]) < r_t     # must enter the mouth
    nb = np.zeros(len(p))
    for _ in range(max_bounce):
        # distance to the wall along the ray
        a_ = (v * v).sum(1)
        b_ = (q * v).sum(1)
        c_ = (q * q).sum(1) - r_t ** 2
        disc = b_ ** 2 - a_ * c_
        t_w = np.where(a_ > 1e-12,
                       (-b_ + np.sqrt(np.clip(disc, 0, None)))
                       / np.where(a_ > 1e-12, a_, 1.0), 1e9)
        t_end = (L - x) / np.clip(vx, 1e-9, None)
        t = np.minimum(t_w, t_end)
        q = q + t[:, None] * v
        x = x + t * vx
        done = x >= L - 1e-6
        if (done | ~alive).all():
            break
        n = q / np.clip(np.linalg.norm(q, axis=1, keepdims=True), 1e-9, None)
        hit_wall = (~done) & alive
        v = np.where(hit_wall[:, None],
                     v - 2 * (v * n).sum(1)[:, None] * n, v)
        w = np.where(hit_wall, w * rho, w)
        nb = nb + hit_wall
        q = np.where(hit_wall[:, None], q * (1 - 1e-9), q)
    ok = alive & (x >= L - 1e-6)
    n_all = len(fwd)
    return (ok.sum() / n_all, float(nb[ok].mean()) if ok.any() else 0.0,
            float(w[ok].sum() / n_all))


if __name__ == "__main__":
    SIG = 5.99e-3
    dish = FixedFocusDish(1.60, 3.5)
    print(f"\n  dish a=1.60 m, f_fit={dish.f:.2f} m -> cone half-angle "
          f"{np.degrees(np.arctan(1.60/dish.f)):.1f} deg at F")
    print("\n  1. HOW THE ARRIVAL DIRECTION SWEEPS (why no mirror can sit here)")
    print(f"  {'sun el':>7}{'sun az':>8}{'beam axis at F':>26}")
    for el, az in ((25, -60), (45, 0), (65, 60), (85, 120)):
        s = np.array([-np.cos(np.radians(el))*np.sin(np.radians(az)),
                      -np.cos(np.radians(el))*np.cos(np.radians(az)),
                      -np.sin(np.radians(el))])
        print(f"  {el:>7.0f}{az:>8.0f}   "
              f"[{-s[0]:+.3f} {-s[1]:+.3f} {-s[2]:+.3f}]")
    print("\n  2. WHAT A FIXED SIDEWAYS BORE ACCEPTS (specular, rho=0.90)")
    print(f"  {'r_t':>6}{'L':>6}{'sun el':>8}{'delivered':>11}"
          f"{'bounces':>9}{'x rho^n':>9}")
    for r_t in (0.20, 0.35):
        for L in (1.6, 3.0):
            for el in (30., 50., 70.):
                s = np.array([0.0, -np.cos(np.radians(el)),
                              -np.sin(np.radians(el))])
                f_, nb, wt = tunnel_throughput(dish, s, SIG, r_t, L)
                print(f"  {r_t:>6.2f}{L:>6.1f}{el:>8.0f}{f_*100:>10.0f}%"
                      f"{nb:>9.1f}{wt*100:>8.0f}%")

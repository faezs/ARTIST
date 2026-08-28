"""Hashemi's rail applied to the beam-down's mount.

THE BEAM-DOWN ALREADY HAS A FIXED FOCUS. It rotates about F2, the
Cassegrain's second focus, which sits at the pit - see the `piv` term in
_trace_power. So "fixed focus" is not what the PDF adds.

WHAT IT ADDS IS HOW YOU BUILD THAT ROTATION. Our F2-pivot is a GIMBAL on
a pedestal of height pivot_drop standing over the pit, and the dish rim
sweeps down past that pedestal as the assembly tilts. That is where
el_min comes from:

    H_cl      = pivot_drop + w0 - rim_drop
    theta_max = atan2(H_cl, a) + asin(crater_depth / hypot(a, H_cl))
    el_min    = max(90 - theta_max, 8)

Hashemi's Figures 5-7 and 14-16 do the same rotation with NO pedestal:
the dish's back carries a circular arc (his "circle D") centred on the
focus, and that arc slides through ground-mounted bearings. A
VIRTUAL-CENTRE rotation - the pivot is a point in mid-air with no
hardware at it, so nothing stands under the dish for the rim to hit.

This measures what that buys, and it is honest about the new cost: the
arc and its bearings need a ring of clear ground around the pit.
"""
import pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))


def pedestal_el_min(a, pivot_drop, w0, rim_drop, crater_depth):
    """What the env does today: gimbal on a mast over the pit."""
    H_cl = pivot_drop + w0 - rim_drop
    theta_max = float(np.degrees(
        np.arctan2(H_cl, a)
        + np.arcsin(np.clip(crater_depth / np.hypot(a, H_cl), -1, 1))))
    return max(90.0 - theta_max, 8.0), theta_max


def rail_rim_clearance(a, pivot_drop, w0, rim_drop, el_deg):
    """Virtual-centre rail: the assembly rotates about F2, which sits at
    the pit mouth in the GROUND plane. Returns the lowest point of the
    dish rim relative to that plane (positive = clear).

    Dish frame: rim at z = 0, centre sagging to w0, F2 at z = -pivot_drop.
    Tilt is (90 - el) from vertical about a horizontal axis through F2.
    """
    t = np.radians(90.0 - el_deg)
    th = np.linspace(0, 2 * np.pi, 361)
    # rim points in the dish frame, relative to F2
    rim = np.stack([a * np.cos(th), a * np.sin(th),
                    np.full_like(th, pivot_drop - rim_drop)], 1)
    # rotate about the x axis through F2
    R = np.array([[1, 0, 0],
                  [0, np.cos(t), -np.sin(t)],
                  [0, np.sin(t), np.cos(t)]])
    return float((rim @ R.T)[:, 2].min())


def rail_el_min(a, pivot_drop, w0, rim_drop, crater_depth):
    lo, hi = 0.0, 90.0
    for _ in range(60):
        mid = 0.5 * (lo + hi)
        if rail_rim_clearance(a, pivot_drop, w0, rim_drop, mid) \
                < -crater_depth:
            lo = mid
        else:
            hi = mid
    return max(0.5 * (lo + hi), 8.0)


if __name__ == "__main__":
    from tandoor_rl_env import _sim
    cfg = _sim.CFG
    print(f"\n  crater_depth {cfg.crater_depth}  rim_drop {cfg.rim_drop}")
    print(f"\n  {'a_mem':>7}{'pivot':>7}{'w0':>7}"
          f"{'pedestal el_min':>17}{'rail el_min':>13}{'ring radius':>13}")
    for a_mem in (1.75, 2.10, 2.45):
        for pivot in (1.2, 1.6, 2.2):
            cfg.a, cfg.dp, cfg.pivot_drop = a_mem, 170.0, pivot
            m = _sim.solve_membrane(cfg, 170.0, n=400)
            w0 = float(m["w0"])
            ped, _ = pedestal_el_min(a_mem, pivot, w0, cfg.rim_drop,
                                     cfg.crater_depth)
            rail = rail_el_min(a_mem, pivot, w0, cfg.rim_drop,
                               cfg.crater_depth)
            # the arc must clear the pit; ring of ground it needs
            ring = np.hypot(a_mem, pivot - cfg.rim_drop)
            print(f"  {a_mem:>7.2f}{pivot:>7.2f}{w0:>7.3f}"
                  f"{ped:>14.0f} deg{rail:>10.0f} deg{ring:>11.2f} m")
    print("\n  el_min is the sun elevation below which the assembly cannot")
    print("  track at all. Lower is strictly better: it is morning and")
    print("  evening sun the beam-down currently throws away.")

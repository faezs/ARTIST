"""Same feasibility audit the coude just failed, applied to the winner.

The polar retrofit puts ONE elliptical off-axis mirror on a polar axis
through the pot's air-inlet, which sits 0.86 m BELOW the workfloor. So
the mirror centre is only ~1 m above the floor - and its semi-minor axis
is 1.35*a. Does its rim go underground, and does the beam it sends to
the duct pass through the workfloor?
"""
import contextlib, io, pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_polar_env import TandoorPolarEnv, Z_DUCT, R_POT
from tandoor_rl_env import _sim


def mirror_rim(env, day, t_solar):
    el0, az0, svec = _sim.solar_position(env.lat, day, t_solar)
    pax = np.array([0.0, np.cos(np.radians(env.lat)),
                    np.sin(np.radians(env.lat))])
    duct = np.array([0.0, 0.7, Z_DUCT])
    mc = duct + env.f_nom * pax
    svec = np.asarray(svec, float).ravel()[:3]
    nb = svec + (-pax); nb /= max(np.linalg.norm(nb), 1e-9)
    u = np.cross(nb, [0, 0, 1.0]); u /= max(np.linalg.norm(u), 1e-9)
    w_ = np.cross(nb, u)
    t = np.linspace(0, 2 * np.pi, 121)
    rim = np.array([mc + env.cfg.a * (np.cos(x) * u + 1.35 * np.sin(x) * w_)
                    for x in t])
    return mc, rim, el0


if __name__ == "__main__":
    with contextlib.redirect_stdout(io.StringIO()):
        env = TandoorPolarEnv(num_agents=1, seed=0, wide_shutter=1,
                              device="cpu")
        env.reset(seed=0)
    print(f"  lat {env.lat:.1f}   f_nom {env.f_nom:.2f} m   "
          f"mirror semi-axes {env.cfg.a:.2f} x {1.35*env.cfg.a:.2f} m")
    print(f"  duct centre is {abs(Z_DUCT):.2f} m BELOW the workfloor (z=0)\n")
    print(f"{'day':>5}{'hr':>6}{'sun el':>8}{'centre z':>10}"
          f"{'rim min z':>11}{'verdict':>26}")
    worst = 9e9
    for day in (10, 100, 172, 264, 355):
        for hr in (8.0, 10.0, 12.0, 14.0, 16.0):
            mc, rim, el0 = mirror_rim(env, day, hr)
            if el0 < 8:
                continue
            lo = rim[:, 2].min()
            worst = min(worst, lo)
            v = "" if lo > 0 else f"{-lo:.2f} m UNDERGROUND"
            print(f"{day:>5}{hr:>6.1f}{el0:>8.1f}{mc[2]:>10.2f}"
                  f"{lo:>11.2f}{v:>26}")
    print(f"\n  worst rim depth over the year: {worst:+.2f} m")
    # does the beam to the duct cross the workfloor plane?
    mc, rim, _ = mirror_rim(env, 172, 12.0)
    duct = np.array([0.0, 0.7, Z_DUCT])
    seg = np.array([p + (duct - p) * np.linspace(0, 1, 200)[:, None]
                    for p in rim[::10]])
    below = (seg[..., 2] < 0.0)
    print(f"  beam segments that pass below the workfloor before the duct: "
          f"{below.any(axis=1).mean()*100:.0f}% of rim rays")
    print("  -> the beam must reach a duct 0.86 m under the floor, so a "
          "trench\n     or sloped bore is REQUIRED; it is not modelled as "
          "an obstruction.")

"""Coude, with every correction applied, against the polar retrofit.

Corrections since the last report, all of which cut the coude's numbers:
  1. the secondary now shadows the incoming beam (it did not before);
  2. Z_M4 is the roof-clearance minimum, not a hardcoded 4.15 that put
     the dish rim 1.2 m through the deck;
  3. M3's clear aperture is 0.60, matching its measured p99 footprint.
EFL = L/sqrt(shadow), so L is the only variable that improves blur and
obstruction together - which is why the mount height matters so much.
"""
import contextlib, io, pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_compare import heuristic
from tandoor_coude_env import TandoorCoudeEnv
from tandoor_polar_env import TandoorPolarEnv


def cold(cls, B=16, seeds=2, steps=1922, **kw):
    res = []
    for sd in range(1, seeds + 1):
        with contextlib.redirect_stdout(io.StringIO()):
            env = cls(num_agents=B, seed=sd, wide_shutter=1,
                      device="cpu", **kw)
            env.reset(seed=sd)
        env.T[:] = 350.0 + env.rng.uniform(-15, 15, env.T.shape)
        env.equilibrate_wall()
        env._belt_prev = env.T[:, : env.n_belt].mean(1).copy()
        rot, pin, hb, peak = [], [], 0, 0.0
        for _ in range(steps):
            *_, infos = env.step(heuristic(env, B))
            pin.append(env.p_in.mean())
            bm = env.T[:, : env.n_belt].mean()
            hb += (560.0 <= bm <= 700.0)
            peak = max(peak, float(bm))
            for inf in infos:
                rot.append(inf["rotis_per_day"])
        res.append((np.mean(rot) if rot else 0.0, np.mean(pin) / 1000,
                    hb * env.dt / 3600.0, peak, getattr(env, "efl", 0.0),
                    getattr(env, "z_m4", 0.0)))
    r = np.array(res)
    return r.mean(0), r[:, 0].std()


if __name__ == "__main__":
    print(f"\n{'config':<26}{'rotis':>9}{'kW':>7}{'h band':>8}"
          f"{'peak K':>8}{'EFL':>7}{'Z_M4':>7}")
    print("-" * 72)
    m, sd = cold(TandoorPolarEnv)
    print(f"{'polar retrofit':<26}{m[0]:>7.1f}+-{sd:<3.0f}{m[1]:>6.2f}"
          f"{m[2]:>8.2f}{m[3]:>8.0f}{'-':>7}{'-':>7}")
    for a_mem in (1.45, 1.75, 2.10, 2.45):
        for rs_frac in (0.80, 0.95):
            kw = dict(a_mem=a_mem, r_sec=round(rs_frac * a_mem * 0.46, 2))
            m, sd = cold(TandoorCoudeEnv, **kw)
            lbl = f"coude a={a_mem} rsec={kw['r_sec']}"
            print(f"{lbl:<26}"
                  f"{m[0]:>7.1f}+-{sd:<3.0f}{m[1]:>6.2f}{m[2]:>8.2f}"
                  f"{m[3]:>8.0f}{m[4]:>7.1f}{m[5]:>7.2f}")

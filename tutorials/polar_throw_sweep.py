"""What does making the polar mirror buildable actually cost?

Its rim sits 0.82 m under the courtyard floor at f_nom = 4.59 m. To lift
the whole aperture above grade the mirror has to move OUT along the
polar axis, and throw is the blur lever: spot ~ 2*sigma*throw, so the
spot area grows as throw^2 while the duct stays 0.28 m across.
"""
import contextlib, io, pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import tandoor_polar_env as P
from tandoor_compare import heuristic
from polar_clearance import mirror_rim


def cold(B=16, seeds=2, steps=1922):
    res = []
    for sd in range(1, seeds + 1):
        with contextlib.redirect_stdout(io.StringIO()):
            env = P.TandoorPolarEnv(num_agents=B, seed=sd, wide_shutter=1,
                                    device="cpu")
            env.reset(seed=sd)
        env.T[:] = 350.0 + env.rng.uniform(-15, 15, env.T.shape)
        env.equilibrate_wall()
        env._belt_prev = env.T[:, : env.n_belt].mean(1).copy()
        rot, pin = [], []
        for _ in range(steps):
            *_, infos = env.step(heuristic(env, B))
            pin.append(env.p_in.mean())
            for inf in infos:
                rot.append(inf["rotis_per_day"])
        lo = min(mirror_rim(env, d, h)[1][:, 2].min()
                 for d in (10, 172, 264) for h in (9., 12., 15.))
        res.append((np.mean(rot) if rot else 0.0, np.mean(pin) / 1000,
                    env.f_nom, lo))
    return np.array(res).mean(0), np.array(res)[:, 0].std()


if __name__ == "__main__":
    base = P.THROW
    print(f"\n{'THROW':>7}{'f_nom':>8}{'rim min z':>11}{'buildable':>11}"
          f"{'rotis':>10}{'kW':>7}")
    print("-" * 56)
    for thr in (3.5, 4.5, 5.5, 6.5, 7.5):
        P.THROW = thr
        try:
            m, sd = cold()
        finally:
            P.THROW = base
        ok = "yes" if m[3] > 0.15 else "NO (buried)"
        print(f"{thr:>7.1f}{m[2]:>8.2f}{m[3]:>11.2f}{ok:>11}"
              f"{m[0]:>8.1f}+-{sd:<2.0f}{m[1]:>6.2f}")

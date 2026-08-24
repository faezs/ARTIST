"""
Head-to-head comparator for the three tandoor architectures.

All three envs share identical thermal, bread, cloud, soiling and reward
machinery (the polar and shed envs subclass the beam-down env), so the
differences below are architecture and nothing else.

  beamdown : overhead Cassegrain, assembly gimballed about the pit mouth,
             purpose-built spherical cavity. (superseded)
  shed     : flat heliostat -> sheltered fixed membrane -> side port,
             purpose-built cavity. (rejected: needs a new tandoor and a
             flat heliostat)
  polar    : EXISTING tandoor, one polar jammable-pouch mirror fired
             through the pot's native air-inlet hole. (retrofit)

Usage: python tandoor_compare.py [--seeds 3] [--agents 16]
"""

import argparse
import pathlib
import sys

import numpy as np

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_rl_env import TandoorEnv          # noqa: E402
from tandoor_shed_env import TandoorShedEnv    # noqa: E402
from tandoor_polar_env import TandoorPolarEnv  # noqa: E402

ENVS = {"beamdown": TandoorEnv, "shed": TandoorShedEnv,
        "polar": TandoorPolarEnv}


def heuristic(env, B):
    """Fair equivalent policy per architecture: hold nominal focus; close
    the interlock shutter only when a load is ready (beamdown/shed); hold
    the pouch jammed all day (polar - re-forming is a seasonal task)."""
    belt = env.T[:, : env.n_belt]
    ready = (env.load_timer >= 45.0) & (
        ((~env.has_bread) & (belt >= 560.0) & (belt <= 700.0)).any(1))
    lvl = np.full(B, 4)
    if env.N_HEADS == 3:                       # polar: no shutter interlock
        return np.stack([lvl, np.full(B, 6), np.full(B, 6)], axis=1)
    return np.stack([lvl, np.where(ready, 0, 6)], axis=1)


def run(name, cls, seeds, B, mode):
    out = []
    for sd in range(1, seeds + 1):
        env = cls(num_agents=B, seed=sd, wide_shutter=1, device="cpu")
        env.reset(seed=sd)
        env.T[:] = (350.0 if mode == "cold" else 580.0) \
            + env.rng.uniform(-15, 15, env.T.shape)
        env._belt_prev = env.T[:, : env.n_belt].mean(1).copy()
        rotis, scorch, pin, n = [], [], [], 0
        for _ in range(1922):
            *_, infos = env.step(heuristic(env, B))
            pin.append(env.p_in.mean())
            for inf in infos:
                rotis.append(inf["rotis_per_day"])
                scorch.append(inf["scorched"])
                n += 1
        out.append((np.mean(rotis) if rotis else 0.0,
                    np.mean(scorch) if scorch else 0.0, np.mean(pin)))
    r = np.array(out)
    return r[:, 0].mean(), r[:, 0].std(), r[:, 1].mean(), r[:, 2].mean()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--seeds", type=int, default=3)
    ap.add_argument("--agents", type=int, default=16)
    args = ap.parse_args()

    print(f"\n{'architecture':<12} {'start':<6} {'rotis/day':>14} "
          f"{'scorched':>9} {'mean kW':>8}")
    print("-" * 54)
    rows = {}
    for mode in ("cold", "warm"):
        for name, cls in ENVS.items():
            m, s, sc, pin = run(name, cls, args.seeds, args.agents, mode)
            rows[(name, mode)] = m
            print(f"{name:<12} {mode:<6} {m:>8.1f} +-{s:<4.1f} "
                  f"{sc:>9.2f} {pin / 1000:>8.2f}")
    print("-" * 54)
    for name in ENVS:
        c, w = rows[(name, "cold")], rows[(name, "warm")]
        print(f"  {name:<10} cold {c:6.1f} | warm {w:6.1f} | "
              f"day-mix {(c + w) / 2:6.1f}")


if __name__ == "__main__":
    main()

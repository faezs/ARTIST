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


ENG_A = ((0.153, -0.0097, -0.0558, -0.1218),
         (-0.0585, -0.014, -0.0174, 0.3172))


def enguehard(env, B):
    """Enguehard & Hatfield (JOSA A 11, 874, 1994) applied to the
    optics chain as a segmented mirror: each actuated stage cancels
    its LOCALLY measured error exactly (their 'apply the tilts
    directly'), the compositional redundancy - our global piston, the
    measured 1200:1 null direction mount+elbow - is resolved by
    ASSIGNMENT down the block-triangular influence matrix: only the
    mount can centre the duct relay, so it takes the encoder errors
    deadbeat; the elbow takes the wall residual, with the mount's
    still-uncancelled error FED FORWARD through the measured
    influence rows so the spot never leaves the loaf while the mount
    hunts. Scheduling (serve/advance/load) stays with the outer
    controller - a static quadratic law cannot see time."""
    from tandoor_polar_env import (SPOT_PHI0, SPOT_Z0, RATE_SPOT_PHI,
                                   RATE_SPOT_Z)
    import numpy as _np
    a = heuristic(env, B)               # scheduler + throttle + gates
    if env.N_HEADS != 7:
        return a
    # mount: keep the tuned P-jogs (deadbeat rings against backlash
    # and head quantization - measured, not argued)
    # elbow: feed the mount's residual forward through the MEASURED
    # coupling rows, but with GEOMETRIC unit denominators - the aim
    # coordinates ARE wall coordinates, gain 1; the measured elbow
    # gains were bin-centroid artifacts (dividing by them overdrove
    # the feed-forward 18x and lost 23% of the day)
    st_ph = _np.radians(RATE_SPOT_PHI) * env.dt / 3.0
    ph_des = env.spot_phi + (a[:, 5] - 3) * st_ph
    z_des = env.spot_z + (a[:, 6] - 3) * (RATE_SPOT_Z * env.dt / 3.0)
    Awp_az, Awp_el = ENG_A[0][0], ENG_A[0][1]
    Awz_az, Awz_el = ENG_A[1][0], ENG_A[1][1]
    dph_ff = -(Awp_az * env._e_az + Awp_el * env._e_el)
    dz_ff = -(Awz_az * env._e_az + Awz_el * env._e_el)
    ph_c = ph_des + _np.clip(dph_ff, -0.12, 0.12)
    z_c = z_des + _np.clip(dz_ff, -0.06, 0.06)
    a[:, 5] = _np.clip(_np.round(3 + (ph_c - env.spot_phi) / st_ph),
                       0, 6)
    a[:, 6] = _np.clip(_np.round(
        3 + (z_c - env.spot_z) / (RATE_SPOT_Z * env.dt / 3.0)), 0, 6)
    return a


def heuristic(env, B):
    """Same policy class for every architecture, so the comparison stays
    about architecture: (a) THROTTLE - full focus while cold, progressive
    defocus near the band ceiling, since overshoot wastes band time;
    (b) ANTICIPATE - close the interlock shutter one step early so it is
    already satisfied when the cook's timer expires (reacting late
    stretches the load cycle 45 -> 60 s, -25% throughput);
    (c) polar holds the pouch jammed all day (re-forming is seasonal)."""
    belt = env.T[:, : env.n_belt]
    bm = belt.mean(1)
    lvl = np.where(bm < 540, 4, np.where(bm < 630, 3,
            np.where(bm < 665, 2, np.where(bm < 690, 1, 0))))
    ready = (env.load_timer >= 30.0) & (
        ((~env.has_bread) & (belt >= 520.0) & (belt <= 700.0)).any(1))
    if env.N_HEADS in (5, 7):                  # hashemi: 2 motor heads
        # P-controller on the pointing-error encoders: cmd 3 = hold,
        # each step of command = a third of full slew
        c_az = np.clip(np.round(3 - env._e_az / 0.08), 0, 6).astype(int)
        c_el = np.clip(np.round(3 - env._e_el / 0.08), 0, 6).astype(int)
        heads = [lvl, np.full(B, 6), np.full(B, 6), c_az, c_el]
        if env.N_HEADS == 7:
            # steer the spot: serve the RAWEST loaded loaf; park at
            # the default station when the queue is empty
            from tandoor_polar_env import (SPOT_PHI0, SPOT_Z0,
                                           RATE_SPOT_PHI, RATE_SPOT_Z)
            # SERVE TO COMPLETION: hold the beam on the aimed loaf
            # until ~92% done, then advance one reachable bin - the
            # finishing loaf closes out on wall contact while the new
            # bin's gate opens for the next load. If another bin
            # holds a rawer abandoned loaf, serve it first.
            # (bins 1-3 face the duct - unreachable)
            REACH = np.array([4, 5, 6, 7, 0])
            ar = np.arange(B)
            kb_now = (((env.spot_phi + np.pi) / (2 * np.pi)
                       * env.n_belt).astype(int)) % env.n_belt
            has_here = env.has_bread[ar, kb_now]
            fr_here = env.bread_E[ar, kb_now] / env.roti_energy
            stay = has_here & (fr_here < 0.92)
            Em = np.where(env.has_bread
                          & (env.bread_E < 0.9 * env.roti_energy),
                          env.bread_E, np.inf)
            raw = np.argmin(Em, axis=1)
            raw_exists = np.isfinite(Em.min(1))
            pos = np.zeros(B, dtype=int)
            for i_, k_ in enumerate(REACH):
                pos = np.where(kb_now == k_, i_, pos)
            nxt = REACH[(pos + 1) % len(REACH)]
            done_here = has_here & (fr_here >= 0.92)
            tgt_bin = np.where(
                done_here, nxt,                    # move on when done
                np.where(~has_here & raw_exists, raw,
                         kb_now))                  # else serve or WAIT

            ph_des = -np.pi + (tgt_bin + 0.5) / env.n_belt * 2 * np.pi
            ph_des = np.where(ph_des < env.spot_phi - np.pi,
                              ph_des + 2 * np.pi, ph_des)
            dphi = np.degrees(ph_des - env.spot_phi)
            step_ph = RATE_SPOT_PHI * env.dt / 3.0
            c_ph = np.clip(np.round(3 + dphi / step_ph), 0, 6)
            dz = SPOT_Z0 - env.spot_z
            c_zz = np.clip(np.round(3 + dz / (RATE_SPOT_Z * env.dt
                                              / 3.0)), 0, 6)
            heads += [c_ph.astype(int), c_zz.astype(int)]
        return np.stack(heads, axis=1)
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
        env.equilibrate_wall()
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

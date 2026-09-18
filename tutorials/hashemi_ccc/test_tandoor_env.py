"""A day of the competing env: his concentrator on the tandoor, the pot cooking.
The pointing by the sensor loop, the shutter open, every slot loaded (a naive cook): the power
into the pot, the belt's temperature and the rotis through the day.
    .venv/bin/python test_tandoor_env.py [--agents 16] [--day 172]
"""
import argparse
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "bridge"))
sys.path.insert(0, HERE)
from export_scene import ini_env_kwargs               # noqa: E402
from hashemi_tandoor_env import HashemiTandoorEnv     # noqa: E402
from hashemi_kernel import COL                        # noqa: E402
from hashemi_env_kernel import ECOL                   # noqa: E402


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--agents", type=int, default=16)
    ap.add_argument("--day", type=int, default=172)
    ap.add_argument("--gpu", type=int, default=0, help="1: the parent's fused Metal step with the trace injected")
    ap.add_argument("--discrete", type=int, default=1, help="1: the sensor loop's commands rounded to the seven head values (the policy's space)")
    args = ap.parse_args()
    kw = ini_env_kwargs(os.path.join(os.path.dirname(HERE), "puffer_tandoor", "hashemi_ccc.ini"))
    kw["day_random"] = 0
    kw["lat_random"] = 0
    kw["gpu"] = args.gpu
    B = args.agents
    env = HashemiTandoorEnv(num_agents=B, lat=30.2, day_of_year=args.day, **kw)
    env.reset()
    nvec = env.single_action_space.nvec
    import tandoor_hashemi_env as _m
    t0 = time.time()
    k = 0
    rows = []
    agree_reach = agree_lost = 0.0
    while True:
        el0, az0, _ = _m._sim.solar_position(env.lat, env.day, float(env.t_solar[0]))
        az0 = np.degrees(az0 - env._ds_azs)
        a = np.zeros((B, env.N_HEADS))
        a[:, 1] = 6                                                    # the shutter open
        for h in range(5, env.N_HEADS - env.n_belt):
            a[:, h] = (nvec[h] - 1) // 2
        a[:, env.N_HEADS - env.n_belt:] = 6                            # load every slot
        e_el = env.el_m - el0
        d_az = env.az_m - az0
        d_az -= 360 * np.round(d_az / 360)
        a[:, 3] = 3 + 3 * -np.clip(d_az / (env.RATE_AZ * env.dt), -1, 1)
        a[:, 4] = 3 + 3 * -np.clip(e_el / (env.RATE_EL * env.dt), -1, 1)
        if args.discrete:
            a[:, 3] = np.round(a[:, 3]); a[:, 4] = np.round(a[:, 4])
        t_before = float(env.t_solar[0])
        obs, rew, term, trunc, infos = env.step(a)
        k += 1
        # the spec's Ω-columns against the parent's flags: the sun reachable = the parent's sun up,
        # the sun lost = the parent's lost counter (its L1 error in degrees vs the spec's angle:
        # they can differ by the sqrt 2 of the norms, so agreement is counted, not required exact)
        reach = env.hk_row[:, COL["sun_reachable"]] > 0.5
        lost = env.hk_row[:, COL["lost_sun"]] > 0.5
        lc = np.asarray(env._gpu.lost_ct.cpu() if args.gpu else env._lost_ct) > 0
        agree_reach += float(np.mean(reach == (el0 >= env.el_min_h)))
        agree_lost += float(np.mean(np.logical_or(~lc, lost)))     # the parent's lost (5 deg) implies the spec's (1.7 deg)
        if k % 240 == 0:
            S = env._gpu if args.gpu else env            # the fused path keeps the pot on the device
            T = np.asarray(S.T.cpu() if args.gpu else S.T)
            rows.append((float(env.t_solar[0]), el0, float(env.el_m.mean()), float(e_el.mean()), float(env.cap_traced.mean()),
                         float(np.mean(env.p_in)), float(np.mean(T[:, :env.n_belt].max(1))), float(np.asarray(S.ep_rotis.cpu() if args.gpu else S.ep_rotis).mean()),
                         float(np.mean(env.t_oil)), float(np.mean(env.row[:, ECOL["q_pot"]]))))
        if float(env.t_solar[0]) < t_before - 1.0 or k > 4000:
            break
    print(f"day {args.day} gpu={args.gpu} discrete={args.discrete}: {k} steps, {1e3 * (time.time() - t0) / k:.1f} ms/step at B={B}")
    print("  hour  sun el  dish el   e_el   capture   p_in[W]  belt Tmax  ep_rotis   T_oil[K]  q_pot[W]")
    for r in rows:
        print("  %5.2f  %6.2f  %6.2f  %+6.2f   %5.3f   %7.0f   %7.1f   %6.2f   %7.1f   %7.0f" % r)
    print(f"  spec vs parent: sun_reachable == sun up {100 * agree_reach / k:.1f} %, parent lost => spec lost {100 * agree_lost / k:.1f} %; discrete heads {args.discrete}")
    ok = rows[-1][7] > 50 and all(r[4] > 0.9 for r in rows) and agree_reach / k > 0.99 and agree_lost / k > 0.97
    print("COOKS" if ok else "DOES NOT COOK")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()

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
    ap.add_argument("--receiver", default="oil", help="oil (the coil and the loop) or beam (the hyperboloid beam-down through the slot)")
    ap.add_argument("--slot", type=float, default=0.06, help="the slot's width [m] for the beam-down")
    ap.add_argument("--oil-nodes", type=int, default=None, help="belt slots the coil heats (default: the ini's)")
    ap.add_argument("--dish-half", type=float, default=None, help="the reflector's half-side a [m] (his 0.8); the machine is derived in Lean (HashemiScale.lean) and read from hashemi_machine_<a>.json")
    ap.add_argument("--dish-design", type=int, default=None,
                    help="1: the DESIGNED machine at that half-side (HashemiScale.lean solves the held set from the constraints); 0: the held machine; default the ini's")
    ap.add_argument("--pump", default="rule", choices=["off", "max", "rule"],
                    help="the pump on the parent's pinned head 0 (HashemiPolicy.pumpOf): off (level 0), "
                         "max (level 6) or a bang-bang rule on the film margin")
    ap.add_argument("--random", type=int, default=0, help="1: uniform-random heads instead of the follower (the return's floor)")
    args = ap.parse_args()
    kw = ini_env_kwargs(os.path.join(os.path.dirname(HERE), "puffer_tandoor", "hashemi_ccc.ini"))
    kw["day_random"] = 0
    kw["lat_random"] = 0
    kw["gpu"] = args.gpu
    kw["machine_receiver"] = args.receiver
    kw["beam_slot"] = args.slot
    if args.oil_nodes is not None:
        kw["oil_nodes"] = args.oil_nodes
    if args.dish_half is not None:
        kw["dish_half"] = args.dish_half
    if args.dish_design is not None:
        kw["dish_design"] = args.dish_design
    B = args.agents
    env = HashemiTandoorEnv(num_agents=B, lat=30.2, day_of_year=args.day, **kw)
    env.reset()
    nvec = env.single_action_space.nvec
    import tandoor_hashemi_env as _m
    t0 = time.time()
    k = 0
    rows = []
    agree_reach = agree_lost = 0.0
    ret = np.zeros(B); rng = np.random.default_rng(0)
    bulk_max = np.zeros(B); film_max = np.zeros(B); margin_min = np.full(B, 1e9); pump_J = np.zeros(B); fault_ct = np.zeros(B)
    while True:
        el0, az0, _ = _m._sim.solar_position(env.lat, env.day, float(env.t_solar[0]))
        az0 = np.degrees(az0 - env._ds_azs)
        a = np.zeros((B, env.N_HEADS))
        a[:, 1] = 6                                                    # the shutter open
        # THE PUMP, on head 0 (his dish has no membrane, so the level head is the loop's).
        # The rule is bang-bang on the film margin the kernel reported last step: open the pump
        # whenever the wall the oil touches is within 50 K of the fluid's 375 C film limit, or
        # whenever the oil is hot enough to be worth moving; close it otherwise, so the loop is
        # not pumped for nothing at dawn.
        if args.pump == "max":
            a[:, 0] = 6
        elif args.pump == "off":
            a[:, 0] = 0
        else:
            margin = env.row[:, ECOL["film_margin"]] if k else np.full(B, 1e3)
            hot = env.t_oil > (np.asarray(env.T[:, :env.n_nodes]).mean(1) + 20.0)
            a[:, 0] = np.where((margin < 50.0) | hot, 6, 0)
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
        if args.random:
            a = np.stack([rng.integers(0, n, size=B) for n in nvec], 1)
        t_before = float(env.t_solar[0])
        obs, rew, term, trunc, infos = env.step(a)
        ret += np.asarray(rew, dtype=np.float64)
        k += 1
        # the spec's Ω-columns against the parent's flags: the sun reachable = the parent's sun up,
        # the sun lost = the parent's lost counter (its L1 error in degrees vs the spec's angle:
        # they can differ by the sqrt 2 of the norms, so agreement is counted, not required exact)
        if args.receiver != "beam":
            bulk_max = np.maximum(bulk_max, env.t_oil)
            film_max = np.maximum(film_max, env.row[:, ECOL["T_film"]])
            margin_min = np.minimum(margin_min, env.row[:, ECOL["film_margin"]])
            pump_J += env.row[:, ECOL["p_pump"]] * env.dt
            fault_ct += env.row[:, ECOL["fault"]]
        reach = env.hk_row[:, COL["sun_reachable"]] > 0.5
        lost = env.hk_row[:, COL["lost_sun"]] > 0.5
        lc = np.asarray(env._gpu.lost_ct.cpu() if args.gpu else env._lost_ct) > 0
        agree_reach += float(np.mean(reach == (el0 >= env.el_min_h)))
        agree_lost += float(np.mean(np.logical_or(~lc, lost)))     # the parent's lost (5 deg) implies the spec's (1.7 deg)
        if k % 240 == 0:
            S = env._gpu if args.gpu else env            # the fused path keeps the pot on the device
            T = np.asarray(S.T.cpu() if args.gpu else S.T)
            oil = args.receiver != "beam"
            rows.append((float(env.t_solar[0]), el0, float(env.el_m.mean()), float(e_el.mean()), float(env.cap_traced.mean()),
                         float(np.mean(env.p_in)), float(np.mean(T[:, :env.n_belt].max(1))), float(np.asarray(S.ep_rotis.cpu() if args.gpu else S.ep_rotis).mean()),
                         float(np.mean(env.t_oil)) if oil else 0.0, float(np.mean(env.row[:, ECOL["q_pot"]])) if oil else float(np.mean(env.row[:, env._bk.BCOL["spot"]])),
                         float(np.mean(env.row[:, ECOL["T_film"]])) if oil else 0.0,
                         float(np.mean(env.u_pump)) if oil else 0.0,
                         float(np.mean(env.row[:, ECOL["p_pump"]])) if oil else 0.0))
        if float(env.t_solar[0]) < t_before - 1.0 or k > 4000:
            break
    print(f"day {args.day} gpu={args.gpu} discrete={args.discrete} receiver={args.receiver} random={args.random}: {k} steps, {1e3 * (time.time() - t0) / k:.1f} ms/step at B={B}; "
          f"the day's return {ret.mean():+.2f} +- {ret.std():.2f} (the trainer's units, reward_div {getattr(env, 'reward_div', 1.0):g})")
    print("  hour  sun el  dish el   e_el   capture   p_in[W]  belt Tmax  ep_rotis   T_oil[K]  q_pot[W]  T_film[K]  u_pump  P_pump[W]" + ("   (beam: the last column is the spot at F2 [m])" if args.receiver == "beam" else ""))
    for r in rows:
        print("  %5.2f  %6.2f  %6.2f  %+6.2f   %5.3f   %7.0f   %7.1f   %6.2f   %7.1f   %7.0f   %8.0f  %5.2f   %6.2f" % r)
    if args.receiver != "beam":
        T = np.asarray(env.row[:, ECOL["T_film"]]); mg = np.asarray(env.row[:, ECOL["film_margin"]])
        print(f"  THE LOOP: max bulk {float(np.max(bulk_max)):.1f} K (limit 618.1), max film {float(np.max(film_max)):.0f} K "
              f"(limit 648.1), min margin {float(np.min(margin_min)):+.0f} K, degradation {float(np.mean(env.deg)):.3e}, "
              f"pump energy {float(np.mean(pump_J)) / 1e3:.1f} kJ, fault steps {int(fault_ct.mean())}/{k}")
    if hasattr(env, "machine"):
        mm = env.machine
        print("  THE MACHINE: a %g, rc %g, w %g, Ac %g, panel %g W%s"
              % (mm["kernel"]["a"], mm["kernel"]["rc"], mm["kernel"]["w"], mm["loop"]["Ac"],
                 mm["loop"]["panelW"],
                 (", DESIGNED: " + ", ".join("%s %g->%g (%s)" % (c["held"], c["from"], c["to"], c["constraint"])
                                             for c in mm["design_changes"])) if mm.get("designed") else " (held)"))
    print(f"  spec vs parent: sun_reachable == sun up {100 * agree_reach / k:.1f} %, parent lost => spec lost {100 * agree_lost / k:.1f} %; discrete heads {args.discrete}")
    # the verdict is the DELIVERABLE (rotis) and the pointing, not the capture: capture > 0.9 was
    # calibrated when the dish's figure was pinned at a paraboloid. His form is a sphere
    # (commit 4e980744) and spherical aberration caps the capture near 0.52, so that clause
    # made the harness print DOES NOT COOK at 116 rotis/day. What must hold is that the
    # follower cooks, that it keeps the sun, and that the spec's gates agree with the parent's.
    ok = rows[-1][7] > 25 and all(r[3] < 0.5 for r in rows) and agree_reach / k > 0.99 and agree_lost / k > 0.97
    if args.receiver == "beam":     # the beam-down's capture is the design's: report, do not judge
        ok = agree_reach / k > 0.99 and agree_lost / k > 0.97
    if args.random:                   # the floor: the sun lost within the hour, a negative day
        ok = ret.mean() < 0
    print(("FLOOR HOLDS (a negative day)" if ok else "FLOOR BROKEN (random heads earn a positive day)") if args.random else ("COOKS" if ok else "DOES NOT COOK"))
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()

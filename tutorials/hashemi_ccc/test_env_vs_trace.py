"""The compiled Lean machine against the env's raytracer.

A. The mount's `pnt` convention: pnt = the sun's own (el, az) in degrees reproduces the pnt=None frames
   (Hashemi's law, the dish square to the sun) row for row - so a pose handed to the trace means what the
   Lean pose means.
B. A day under the sensor loop (the video's tracker as the policy), for machine in (design, video) and a
   summer and a winter day at Quetta: hour by hour the dish's pointing error and the traced power at the
   Lean pose against the trace square to the sun. Within the wire's reach the machine tracks and the power
   matches; below the dead point the dish stands at t* and the raytracer shows the power going.

    .venv/bin/python tutorials/hashemi_ccc/test_env_vs_trace.py [--smoke] [--agents 16] [--dt 60]
"""
import argparse
import configparser
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import torch                                                       # noqa: E402
from hashemi_ccc_env import HashemiCccEnv, sensor_loop_actions     # noqa: E402

INI = os.path.join(os.path.dirname(HERE), "puffer_tandoor", "hashemi.ini")
LAT = 30.2          # Quetta


def ini_env_kwargs(path=INI):
    cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#"))
    cp.read(path)
    kw = {}
    for k, v in cp["env"].items():
        v = v.strip()
        if k in ("gpu", "num_agents", "device", "day_random", "lat_random"):
            continue
        try:
            kw[k] = int(v)
        except ValueError:
            try:
                kw[k] = float(v)
            except ValueError:
                kw[k] = v
    return kw


def make_env(B, day, machine, dt):
    kw = ini_env_kwargs()
    env = HashemiCccEnv(num_agents=B, lat=LAT, day_of_year=day, dt=dt, device="mps",
                        machine=machine, **kw)
    env._det_trace = True
    return env


def trace_power(env, el, az):
    """the parent's trace at a pose (el, az deg): the arguments the renderer builds, the pose swapped in"""
    keep = (np.array(env.el_m, dtype=np.float64), np.array(env.az_m, dtype=np.float64),
            np.array(env._e_el, dtype=np.float64), np.array(env._e_az, dtype=np.float64))
    el0, az0, _ = env._sim_solar()
    env.el_m = np.asarray(el, dtype=np.float64) * np.ones(env.num_agents)
    env.az_m = np.asarray(az, dtype=np.float64) * np.ones(env.num_agents)
    env._e_el = env.el_m - el0
    d = env.az_m - az0
    d = d - 360.0 * np.round(d / 360.0)
    env._e_az = d * np.cos(np.radians(el0))
    p_eff = np.where(env.jammed, env.f_locked, env.p_act)
    drift = np.abs(env._decl() - env.decl_formed)
    q_w = 0.6 * env.wind ** 2
    gain = np.where(env.jammed, env.jam_gain, 1.0)
    sig_wind = gain * 0.88e-3 * (np.maximum(q_w, 1e-9) / 15.0) ** 0.6
    sigma_b = np.sqrt(env.sig_static ** 2 + (2 * 0.35 * sig_wind) ** 2 + (np.radians(drift) * 0.04) ** 2)
    with torch.no_grad():
        per = env._trace_power(p_eff, sigma_b, env.bore, env.soil)
    env.el_m, env.az_m, env._e_el, env._e_az = keep
    return per.sum(1).numpy().astype(np.float64)


def part_a(env, hours=(8.0, 10.0, 12.0, 14.0, 16.0)):
    """pnt = the sun's (el, az) vs pnt=None: the same frames"""
    import tandoor_hashemi_env as _m
    dev = env.device
    B = env.num_agents
    day_t = torch.as_tensor(env.day_v, dtype=torch.float32, device=dev)
    lat_t = torch.as_tensor(env.lat_v, dtype=torch.float32, device=dev)
    worst = 0.0
    for h in hours:
        el0, az0, _ = _m._sim.solar_position(env.lat, env.day, h)
        pnt = torch.as_tensor(np.stack([np.full(B, float(el0)),
                                        np.degrees(az0 - env._ds_azs)], 1), dtype=torch.float32, device=dev)
        m0 = env._mount(day_t, lat_t, h, pnt=None)
        v0 = m0["vp"].clone()
        m1 = env._mount(day_t, lat_t, h, pnt=pnt)
        v1 = m1["vp"].clone()
        d = float((v0 - v1).abs().max())
        worst = max(worst, d)
        print(f"  A  {h:5.2f} h  sun el {float(el0):5.2f} az {np.degrees(az0):7.2f}  |vp(pnt=None) - vp(pnt=sun)| max {d:.2e}")
    return worst


def run_day(env, label, dt, sample_min=30.0, max_hours=12.0):
    B = env.num_agents
    env.reset()
    ms = env.machine_summary()
    lowest = ms["lowest_sun_deg"]
    print(f"  machine {label}: a {ms['a']:.3f} ze {ms['ze']:.3f} f {ms['f']:.3f} ym {ms['ym']:.3f} hp {ms['hp']:.3f} "
          f"R {ms['R']:.3f}  arm_rest {ms['arm_rest']:.3f}  dead point {ms['tdead_deg']:.2f} deg -> lowest sun {lowest:.2f} deg")
    rows = []
    every = max(1, int(round(sample_min * 60.0 / dt)))
    n_steps = int(max_hours * 3600.0 / dt)
    t0 = time.time()
    for k in range(n_steps):
        t_before = float(env.t_solar[0])
        act = sensor_loop_actions(env)
        env.step(act)
        if float(env.t_solar[0]) < t_before - 1.0:
            break                                       # the parent wrapped the day
        if k % every == 0:
            el0, az0, _ = env._sim_solar()
            if el0 < env.el_min_h:
                continue
            el, az = env.pose_deg()
            e_el = el - el0
            d_az = az - az0
            d_az = d_az - 360.0 * np.round(d_az / 360.0)
            p_lean = trace_power(env, el, az)
            p_ref = trace_power(env, el0, az0)
            ratio = p_lean / np.maximum(p_ref, 1e-9)
            rows.append(dict(hour=float(env.t_solar[0]), el0=float(el0), el=float(el.mean()),
                             e_el=float(e_el.mean()), e_az=float((d_az * np.cos(np.radians(el0))).mean()),
                             p_lean=float(p_lean.mean()), p_ref=float(p_ref.mean()), ratio=float(ratio.mean()),
                             arm=float(env.hk_out[:, 2].mean()), tens=float(env.hk_out[:, 3].mean()),
                             at_dead=bool(np.all(np.abs(env.hk_out[:, 1] - env.hk_tdead) < 1e-6))))
    wall = time.time() - t0
    print(f"  {len(rows)} samples, {k + 1} env steps of {dt:.0f} s in {wall:.1f} s ({1e3 * wall / (k + 1):.1f} ms/step)")
    print("   hour  sun el   dish el   e_el     e_az    P_lean   P_ref  ratio   arm   T/Wrcm  dead")
    for r in rows:
        print(f"  {r['hour']:5.2f}  {r['el0']:6.2f}   {r['el']:6.2f}  {r['e_el']:+6.2f}  {r['e_az']:+6.2f}  "
              f"{r['p_lean']:7.0f} {r['p_ref']:7.0f}  {r['ratio']:5.3f}  {r['arm']:5.3f}  {r['tens']:6.3f}  {'*' if r['at_dead'] else ' '}")
    inr = [r for r in rows[2:] if r["el0"] >= lowest + 0.5]
    out = [r for r in rows if r["el0"] < lowest - 0.5]
    res = dict(label=label, lowest=lowest, n_in=len(inr), n_out=len(out))
    if inr:
        res["e_max_in"] = max(max(abs(r["e_el"]), abs(r["e_az"])) for r in inr)
        res["ratio_min_in"] = min(r["ratio"] for r in inr)
    if out:
        res["dead_all_out"] = all(r["at_dead"] for r in out)
        res["ratio_out"] = [(round(r["el0"], 1), round(r["ratio"], 3)) for r in out]
        res["e_out_max"] = max(abs(r["e_el"]) for r in out)
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smoke", action="store_true")
    ap.add_argument("--agents", type=int, default=16)
    ap.add_argument("--dt", type=float, default=60.0)
    ap.add_argument("--days", type=str, default="172,355")
    ap.add_argument("--machines", type=str, default="design,video")
    args = ap.parse_args()
    torch.manual_seed(0)
    if args.smoke:
        env = make_env(8, 172, "design", args.dt)
        env.reset()
        print("machine:", env.machine_summary())
        print("state0 (az, t):", env._hk_state_np[:2])
        for _ in range(3):
            env.step(sensor_loop_actions(env))
            el, az = env.pose_deg()
            el0, az0, _ = env._sim_solar()
            print(f"  t_solar {float(env.t_solar[0]):.3f}  sun ({el0:.2f}, {az0[0]:.2f})  dish ({el[0]:.2f}, {az[0]:.2f})  "
                  f"e ({env._e_el[0]:+.3f}, {env._e_az[0]:+.3f})  reward {env.rewards[0]:+.3f}  arm {env.hk_out[0, 2]:.3f}")
        print("A worst:", part_a(env))
        return
    fails = []
    for day in [int(d) for d in args.days.split(",")]:
        for machine in args.machines.split(","):
            print(f"\n== day {day}, lat {LAT}, machine {machine}, {args.agents} agents, dt {args.dt:.0f} s")
            env = make_env(args.agents, day, machine, args.dt)
            if machine == "design" and day == int(args.days.split(",")[0]):
                wa = part_a(env)
                print(f"  A worst frame difference {wa:.2e}")
                if wa > 1e-3:
                    fails.append(f"A: pnt=sun differs from pnt=None by {wa:.2e}")
            res = run_day(env, f"{machine}/day{day}", args.dt)
            print("  ->", res)
            if res.get("n_in", 0) and (res["e_max_in"] > 0.3 or res["ratio_min_in"] < 0.95):
                fails.append(f"B {res['label']}: within reach e_max {res['e_max_in']:.3f} ratio_min {res['ratio_min_in']:.3f}")
            if res.get("n_out", 0) and not res["dead_all_out"]:
                fails.append(f"B {res['label']}: below the reach the dish is not at the dead point")
    print("\n" + ("ALL CHECKS PASS" if not fails else "FAILED:\n  " + "\n  ".join(fails)))
    sys.exit(0 if not fails else 1)


if __name__ == "__main__":
    main()

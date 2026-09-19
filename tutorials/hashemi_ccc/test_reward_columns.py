"""R1-R3: the measured checks on the PRINTED reward (`rewardStep`, HashemiReward.lean).

The reward of `puffer_hashemi_ccc` is a compiled morphism with three columns - `r_shape_raw`,
`r_raw`, `r_trainer` - whose constants (reward_div, capture_shaping, the raw price of a roti,
roti_energy) are its inputs. These are the three checks TOPOS_REWARD.md §4 asks for, and the
first and third are the ones that would have failed on the two bugs of 2026-09-19:

* **R1, gluing.** Two readings. (a) Every step of the numpy day is re-run through the FUSED
  implementation (the Metal kernel) on the SAME inputs: the draws cannot differ, so the two
  restrictions of the one section must agree to float32, per step. (b) The day rolled on both
  paths independently (their draws do differ) is compared by hour means of `r_shape_raw`. A
  shaping put in the wrong fibre is a factor of `reward_div` and fails both at once.
* **R2, the units.** `r_trainer · reward_div − parentRaw = r_shape_raw`, per step, on each path,
  from the columns the kernel itself returned (the naturality square, measured).
* **R3, non-negativity.** `min r_shape_raw ≥ 0` over the day: no per-step penalty exists, so
  `cut_never_pays` applies and leaving is never an escape.

They live here and not in `lake exe trace_check` because the bridge drives a Metal kernel with
given inputs - it cannot roll a day of the puffer env on two paths, which is exactly what R1 is.
The Lean statements behind R2 and R3 (`rewardStep_units`, `rewardStep_nonneg`) ARE compiled and
are measured by `test_ccc.py` with the other theorem checks.

    .venv/bin/python test_reward_columns.py [--agents 4] [--day 172]
"""
import argparse
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "bridge"))
sys.path.insert(0, HERE)
from export_scene import ini_env_kwargs               # noqa: E402
from hashemi_tandoor_env import HashemiTandoorEnv     # noqa: E402
from hashemi_reward_kernel import RCOL, pack_reward, HashemiRewardMetal   # noqa: E402
from hashemi_env_kernel import ECOL                  # noqa: E402

PIN_COL, REACH_COL = ECOL["p_in"], ECOL["sun_reachable"]


def roll(gpu, agents, day, oil_nodes):
    """a day with the follower's actions; returns the reward columns and the parent's raw reward"""
    kw = ini_env_kwargs(os.path.join(os.path.dirname(HERE), "puffer_tandoor", "hashemi_ccc.ini"))
    kw["day_random"] = 0
    kw["lat_random"] = 0
    kw["gpu"] = gpu
    kw["oil_nodes"] = oil_nodes
    env = HashemiTandoorEnv(num_agents=agents, lat=30.2, day_of_year=day, **kw)
    env.reset()
    nvec = env.single_action_space.nvec
    import tandoor_hashemi_env as _m
    div = float(getattr(env, "reward_div", 1.0))
    rows = []
    ins = []
    trn = []
    k = 0
    while True:
        el0, az0, _ = _m._sim.solar_position(env.lat, env.day, float(env.t_solar[0]))
        az0 = np.degrees(az0 - env._ds_azs)
        a = np.zeros((agents, env.N_HEADS))
        a[:, 1] = 6
        for h in range(5, env.N_HEADS - env.n_belt):
            a[:, h] = (nvec[h] - 1) // 2
        a[:, env.N_HEADS - env.n_belt:] = 6
        e_el = env.el_m - el0
        d_az = env.az_m - az0
        d_az -= 360 * np.round(d_az / 360)
        a[:, 3] = np.round(3 + 3 * -np.clip(d_az / (env.RATE_AZ * env.dt), -1, 1))
        a[:, 4] = np.round(3 + 3 * -np.clip(e_el / (env.RATE_EL * env.dt), -1, 1))
        t_before = float(env.t_solar[0])
        _, rew, _, _, _ = env.step(a)
        cols = np.asarray(env.r_cols, dtype=np.float64)
        ins.append(np.stack([cols[:, RCOL["r_raw"]] - cols[:, RCOL["r_shape_raw"]],
                             np.asarray(env.row[:, PIN_COL], dtype=np.float64),
                             np.asarray(env.row[:, REACH_COL], dtype=np.float64)], 1))
        trn.append(cols[:, RCOL["r_trainer"]].copy())
        rows.append((float(env.t_solar[0]), cols.mean(0),
                     float(np.mean(np.asarray(rew, dtype=np.float64))),
                     float(np.max(np.abs(cols[:, RCOL["r_trainer"]] * div
                                         - (cols[:, RCOL["r_raw"]] - cols[:, RCOL["r_shape_raw"]])
                                         - cols[:, RCOL["r_shape_raw"]]))),
                     float(cols[:, RCOL["r_shape_raw"]].min())))
        k += 1
        if float(env.t_solar[0]) < t_before - 1.0 or k > 4000:
            break
    hours = np.array([r[0] for r in rows])
    cols = np.stack([r[1] for r in rows])
    return dict(hours=hours, cols=cols, rew=np.array([r[2] for r in rows]),
                r2=max(r[3] for r in rows), r3=min(r[4] for r in rows), div=div, steps=k,
                ins=np.concatenate(ins, 0), trn=np.concatenate(trn, 0),
                dt=float(env.dt), cs=float(env.capture_shaping), rr=float(env.ROTI_REWARD_RAW),
                re=float(env.roti_energy))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--agents", type=int, default=4)
    ap.add_argument("--day", type=int, default=172)
    ap.add_argument("--oil-nodes", type=int, default=2)
    args = ap.parse_args()
    a = roll(0, args.agents, args.day, args.oil_nodes)
    b = roll(1, args.agents, args.day, args.oil_nodes)
    ok = True

    # ---- R1: the two paths are two restrictions of ONE section
    # (a) the implementation cover, exactly: every step's inputs of the numpy day run through the
    # FUSED implementation (the Metal kernel). The physics draws cannot differ here, so this is
    # the gluing condition itself - a shaping added in the wrong fibre shows up as a factor of
    # reward_div on every step at once.
    import torch
    x = pack_reward(a["ins"][:, 0], a["dt"], a["ins"][:, 1], a["ins"][:, 2],
                    a["div"], a["cs"], a["rr"], a["re"])
    m = HashemiRewardMetal().step(torch.as_tensor(x.astype(np.float32), device="mps")).cpu().numpy().astype(np.float64)
    scale = np.maximum(1e-3, np.abs(a["trn"]))
    per_step = float(np.max(np.abs(m[:, RCOL["r_trainer"]] - a["trn"]) / scale))
    # (b) the two days rolled independently: their draws differ (the fused path draws on the
    # device) and so do the agents' trajectories, so the two rolls are compared on the DAY's
    # shaping, with the hour means reported. Either reading is a factor of 75 out on a units bug.
    n = min(a["steps"], b["steps"])
    day_sa = float(a["cols"][:n, RCOL["r_shape_raw"]].sum())
    day_sb = float(b["cols"][:n, RCOL["r_shape_raw"]].sum())
    day_rel = abs(day_sa - day_sb) / max(1e-9, abs(day_sa))
    hb = np.floor(a["hours"][:n]).astype(int)
    keep = [h for h in np.unique(hb) if (hb == h).sum() > 60]
    hm_a = np.array([a["cols"][:n][hb == h, RCOL["r_shape_raw"]].mean() for h in keep])
    hm_b = np.array([b["cols"][:n][hb == h, RCOL["r_shape_raw"]].mean() for h in keep])
    hour_rel = float(np.max(np.abs(hm_a - hm_b) / np.maximum(1e-9, np.abs(hm_a))))
    day_a, day_b = float(a["rew"].sum()), float(b["rew"].sum())
    print(f"R1 gluing   per-step max rel |r_trainer numpy - the fused kernel on the same inputs| {per_step:.2e}"
          f"; day's r_shape_raw rel {day_rel:.3f} (full hours max rel {hour_rel:.3f})"
          f"; day's return {day_a:+.2f} vs {day_b:+.2f}")
    if per_step > 1e-6 or day_rel > 0.15:
        ok = False
        print("   R1 FAILED: the paths do not glue (a units bug shows here as a factor of reward_div)")

    # ---- R2: the naturality square, per step, on each path
    print(f"R2 units    max |r_trainer*div - parentRaw - r_shape_raw|: numpy {a['r2']:.2e}, fused {b['r2']:.2e}"
          f" (reward_div {a['div']:g})")
    if max(a["r2"], b["r2"]) > 1e-4:
        ok = False
        print("   R2 FAILED: the division is not the morphism's")

    # ---- R3: no per-step penalty
    print(f"R3 nonneg   min r_shape_raw over the day: numpy {a['r3']:.3e}, fused {b['r3']:.3e}")
    if min(a["r3"], b["r3"]) < 0.0:
        ok = False
        print("   R3 FAILED: a per-step penalty makes the guillotine an exit")

    print("R1-R3 PASS" if ok else "REWARD CHECKS FAILED")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()

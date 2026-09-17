"""The megakernel through a day at Quetta: the machine tracks under the sensor loop, every theorem
of Hashemi.lean is evaluated at every state, the requirements are watched, and the wire's reach
shows as the stall below the dead point. Also the Metal-vs-NumPy parity of the whole row.
    .venv/bin/python test_mega_day.py [--agents 64] [--dt 15] [--days 172,355]
"""
import argparse
import json
import os
import subprocess
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from hashemi_env import HashemiMachineEnv, sensor_loop_actions      # noqa: E402
from hashemi_kernel import COL, COLUMNS, MEGA_FNS, N_COLS            # noqa: E402

CCC = json.load(open(os.path.join(HERE, "hashemi_ccc.json")))
N_HYPS = {f["name"]: f.get("n_hyps", 0) for f in CCC["functions"]}


def theorem_columns():
    """the columns that are theorem statements: the closed ones and the ones at the state"""
    lo = next(f["offset"] for f in MEGA_FNS if f["name"] == "megaThmsClosed")
    hi = N_COLS
    return list(range(lo, hi))


def run_day(day, agents, dt):
    env = HashemiMachineEnv(num_agents=agents, day_of_year=day, dt=dt, seed=1)
    env.reset()
    print(f"\n== day {day}, lat {env.lat}, {agents} agents, dt {dt:.0f} s; dead point {np.degrees(env.t_dead):.2f} deg "
          f"-> lowest sun {90 - np.degrees(env.t_dead):.2f} deg; the wire holds to {np.degrees(env.t_hold):.2f} deg "
          f"(sun {90 - np.degrees(env.t_hold):.2f}); roller circle {env.roller_R:.3f} m")
    thm = theorem_columns()
    ever_false = {}
    rows = []
    every = max(1, int(round(1800.0 / dt)))
    k = 0
    energy = 0.0
    n_budget = n_sun = n_stall = 0
    while True:
        act = sensor_loop_actions(env)
        obs, rew, term, trunc, infos = env.step(act)
        if trunc.all():
            k += 1
            break                                        # the day is over; the env has reset itself
        r = env.row
        el, az, dni = env._sun
        if el > 0:
            n_sun += 1
            n_budget += int(r[:, COL["TrackerBudget"]].mean() > 0.5)
            n_stall += int(r[:, COL["stalled"]].mean() > 0.5)
        energy += float(env.rewards.mean() * 1e3) * dt / 1e6
        for c in thm:
            if (r[:, c] < 0.5).any():
                ever_false[COLUMNS[c]] = ever_false.get(COLUMNS[c], 0) + 1
        if k % every == 0 and el > -5:
            rows.append((env.hour, el, float(np.mean(90 - np.degrees(env.state[:, 1]))), float(env._e_el.mean()),
                         float(env._e_az.mean()), float(r[:, COL["arm"]].mean()), float(r[:, COL["wireTension"]].mean()),
                         float(r[:, COL["capture"]].mean()), float(env.rewards.mean() * 1e3),
                         float(r[:, COL["stalled"]].mean()), float(r[:, COL["taut"]].mean()),
                         float(r[:, COL["TrackerBudget"]].mean()), float(r[:, COL["HoldsDish"]].mean()),
                         float(r[:, COL["elPower"]].mean()), float(env.cap_traced.mean())))
        k += 1
        if k > 20000:
            break
    print("   hour  sun el  dish el   e_el    e_az    arm   T [N]  capM  capT  P [W]  stall taut budget holds  Pw [W]")
    for h, el, eld, ee, ea, arm, T, cap, P, st, ta, bu, ho, pw, capT in rows:
        print(f"  {h:5.2f}  {el:6.2f}  {eld:6.2f}  {ee:+6.2f}  {ea:+6.2f}  {arm:5.3f}  {T:6.1f}  {cap:4.2f}  {capT:4.2f}  {P:6.0f}  "
              f"{st:4.2f} {ta:4.2f}  {bu:4.2f}  {ho:4.2f}  {pw:6.3f}")
    print(f"  steps {k}, sun up {n_sun}: in the tracker budget {n_budget} ({100.0 * n_budget / max(n_sun, 1):.1f} %), "
          f"stalled at the dead point {n_stall}; energy on the coil {energy:.1f} MJ/day")
    print(f"  theorem columns: {len(thm)}; ever false: {len(ever_false)}")
    for n, c in sorted(ever_false.items()):
        print(f"    {n}: false in {c} steps (hypotheses: {N_HYPS.get(n, '?')})")
    return dict(day=day, energy=energy, budget_frac=n_budget / max(n_sun, 1), stalled=n_stall, ever_false=ever_false)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--agents", type=int, default=64)
    ap.add_argument("--dt", type=float, default=15.0)
    ap.add_argument("--days", type=str, default="172,355")
    args = ap.parse_args()
    print("== Metal vs NumPy on the whole row")
    r = subprocess.run([sys.executable, os.path.join(HERE, "hashemi_kernel.py")], capture_output=True, text=True)
    print("\n".join("  " + l for l in r.stdout.strip().splitlines()[-4:]))
    parity_ok = r.returncode == 0
    res = [run_day(int(d), args.agents, args.dt) for d in args.days.split(",")]
    fails = []
    if not parity_ok:
        fails.append("Metal != NumPy")
    for x in res:
        if x["ever_false"]:
            fails.append(f"day {x['day']}: theorem columns false: {sorted(x['ever_false'])}")
    print("\n" + ("ALL CHECKS PASS" if not fails else "FAILED:\n  " + "\n  ".join(fails)))
    sys.exit(0 if not fails else 1)


if __name__ == "__main__":
    main()

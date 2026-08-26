"""Reward-hacking audit for all three tandoor envs.

This project has already been burned twice: dense power shaping was farmed
by overheating past the loading window, then by parking just below the
threshold; and a NaN policy exploited an unclamped shutter gate to triple
its own sunlight. So: enumerate the adversarial strategies the CURRENT
reward admits, score them, and confirm each earns LESS than honest cooking.

The invariant we need: return must be maximised by the behaviour we
actually want (rotis), i.e. no strategy may beat honest play on return
while cooking substantially less.
"""
import pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_rl_env import TandoorEnv
from tandoor_shed_env import TandoorShedEnv
from tandoor_polar_env import TandoorPolarEnv

ENVS = {"beamdown": TandoorEnv, "shed": TandoorShedEnv,
        "polar": TandoorPolarEnv}

def run(cls, strat, agents=8, seed=1, mode="cold"):
    env = cls(num_agents=agents, seed=seed, wide_shutter=1, device="cpu")
    env.reset(seed=seed)
    env.T[:] = (350.0 if mode == "cold" else 580.0) + \
        env.rng.uniform(-15, 15, env.T.shape)
    env._belt_prev = env.T[:, : env.n_belt].mean(1).copy()
    R, rot, loads = 0.0, 0.0, 0
    prev_bread = np.zeros((agents, env.n_belt), dtype=bool)
    for t in range(1922):
        belt = env.T[:, : env.n_belt]; bm = belt.mean(1)
        thr_lvl = np.where(bm < 540, 4, np.where(bm < 630, 3,
                    np.where(bm < 665, 2, np.where(bm < 690, 1, 0))))
        ok_slot = ((~env.has_bread) & (belt >= 560.) & (belt <= 700.)).any(1)
        if strat == "honest":            # the reference policy
            lvl = thr_lvl
            sh = np.where((env.load_timer >= 30.) & ok_slot, 0, 6)
        elif strat == "never_load":      # hold band, never open the port
            lvl, sh = thr_lvl, np.full(agents, 6)
        elif strat == "load_farm":       # chase the +0.3 load bonus only
            lvl, sh = thr_lvl, np.full(agents, 0)
        elif strat == "hover_below":     # farm preheat shaping under 560
            lvl = np.where(bm < 550, 4, 0)
            sh = np.full(agents, 6)
        elif strat == "max_power":       # full focus always, ignore band
            lvl, sh = np.full(agents, 4), np.where(
                (env.load_timer >= 30.) & ok_slot, 0, 6)
        elif strat == "shutter_spam":    # thrash the interlock
            lvl = thr_lvl
            sh = np.where((t // 1) % 2 == 0, 0, 6) * np.ones(agents, int)
        if env.N_HEADS == 3:      # polar: no interlock, keep beam on
            a = [lvl, np.full(agents, 6), np.full(agents, 6)]
        else:
            a = [lvl, sh]
        _, r, *_ , infos = env.step(np.stack(a, axis=1))
        R += float(np.mean(r))
        loads += int(((~prev_bread) & env.has_bread).sum())
        prev_bread = env.has_bread.copy()
        for inf in infos: rot = inf["rotis_per_day"]
    return R, rot, loads / agents

print(f"{'env':>9}{'strategy':>14}{'return':>9}{'rotis':>8}{'loads':>7}"
      f"{'verdict':>10}")
for en, cls in ENVS.items():
    base = None
    for st in ("honest", "never_load", "load_farm", "hover_below",
               "max_power", "shutter_spam"):
        R, rot, ld = run(cls, st)
        if st == "honest": base = R
        flag = ("REF" if st == "honest"
                else ("HACK" if R > base + 1e-6 and rot < 0.9 * base_rot
                      else "ok"))
        if st == "honest": base_rot = rot
        print(f"{en:>9}{st:>14}{R:>9.1f}{rot:>8.1f}{ld:>7.1f}{flag:>10}")


# ---------------------------------------------------------------------- #
# ALIGNMENT TEST: the strategy list can only probe hacks I thought of.
# The general invariant is that return must be a monotone proxy for rotis
# across the whole policy space. Sample randomized policies and correlate.
print("\n== alignment: does return track rotis across random policies? ==")
rng = np.random.default_rng(0)
for en, cls in ENVS.items():
    pts = []
    for k in range(14):
        th_lo, th_hi = rng.uniform(480, 620), rng.uniform(620, 730)
        lvl_hot, lvl_cold = rng.integers(0, 4), rng.integers(3, 7)
        t_antic = rng.uniform(0, 60)
        env = cls(num_agents=6, seed=1, wide_shutter=1, device="cpu")
        env.reset(seed=1); env.T[:] = 350.0 + env.rng.uniform(-15, 15,
                                                              env.T.shape)
        env._belt_prev = env.T[:, : env.n_belt].mean(1).copy()
        R, rot = 0.0, 0.0
        for t in range(1922):
            belt = env.T[:, : env.n_belt]; bm = belt.mean(1)
            lvl = np.where(bm < th_lo, lvl_cold,
                           np.where(bm < th_hi, 2, lvl_hot))
            ok_slot = ((~env.has_bread) & (belt >= 560.)
                       & (belt <= 700.)).any(1)
            sh = np.where((env.load_timer >= t_antic) & ok_slot, 0, 6)
            if env.N_HEADS == 3:
                a = [lvl, np.full(6, 6), np.full(6, 6)]
            else:
                a = [lvl, sh]
            _, r, *_, infos = env.step(np.stack(a, axis=1))
            R += float(np.mean(r))
            for inf in infos: rot = inf["rotis_per_day"]
        pts.append((R, rot))
    P = np.array(pts)
    c = np.corrcoef(P[:, 0], P[:, 1])[0, 1]
    best_R = P[np.argmax(P[:, 0])]
    best_rot = P[np.argmax(P[:, 1])]
    print(f"  {en:>9}: corr(return, rotis) = {c:+.4f} | "
          f"argmax-return gives {best_R[1]:.0f} rotis, "
          f"argmax-rotis gives {best_rot[1]:.0f} "
          f"-> {'ALIGNED' if best_R[1] >= 0.95*best_rot[1] else 'MISALIGNED'}")

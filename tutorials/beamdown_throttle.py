"""Power stopped being the limit - overshoot became it. The pressure knob
can defocus to dump excess flux, converting 'time above the floor' into
'time IN band'.

Ceiling check: the cook loads every 45 s, so rotis <= ~80 per in-band
hour. 500 rotis therefore needs ~6.3 h held inside the band."""
import pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_rl_env import TandoorEnv

def day(policy, agents=8, seed=1, **kw):
    env = TandoorEnv(num_agents=agents, seed=seed, wide_shutter=1,
                     device="cpu", **kw)
    env.reset(seed=seed); env.T[:] = 350.0
    env._belt_prev = env.T[:, :8].mean(1).copy()
    rot, n_in, n_hot, peak, p = 0.0, 0, 0, 0.0, []
    for t in range(1922):
        belt = env.T[:, :8]; bm = belt.mean(1)
        # ANTICIPATION: loading needs the shutter already closed when the
        # timer expires. Reacting at >=45 wastes a step, stretching the
        # cycle 45 -> 60 s (-25% throughput). Closing at >=30 pre-empts it.
        thr_t = 30.0 if policy == "anticipate" else 45.0
        ready = (env.load_timer >= thr_t) & (
            ((~env.has_bread) & (belt >= 560.) & (belt <= 700.)).any(1))
        if policy == "fixed":
            lvl = np.full(agents, 4)
        else:
            # full focus while cold, progressive defocus near the ceiling
            lvl = np.where(bm < 540, 4, np.where(bm < 630, 3,
                    np.where(bm < 665, 2, np.where(bm < 690, 1, 0))))
        a = np.stack([lvl, np.where(ready, 0, 6)], axis=1)
        *_, infos = env.step(a)
        b = float(belt.mean())
        n_in += (560. <= b <= 700.); n_hot += (b >= 560.)
        peak = max(peak, b); p.append(env.p_in.mean())
        for inf in infos: rot = inf["rotis_per_day"]
    h = env.dt / 3600.0
    return dict(rotis=rot, h_in=n_in*h, h_hot=n_hot*h, peak=peak,
                kw=np.mean(p)/1000)

cfgs = [
    ("z2.2 a2.45 p2.4", dict(z_gap=2.2, a_mem=2.45, pivot_drop=2.4)),
    ("z2.6 a2.45 p1.6", dict(z_gap=2.6, a_mem=2.45, pivot_drop=1.6)),
    ("z2.6 a2.80 p1.6", dict(z_gap=2.6, a_mem=2.80, pivot_drop=1.6)),
    ("z3.0 a2.80 p1.6", dict(z_gap=3.0, a_mem=2.80, pivot_drop=1.6)),
]
print(f"{'geometry':>17}{'policy':>10}{'kW':>6}{'h_band':>8}{'h>560':>7}"
      f"{'peak':>6}{'rotis':>7}")
for nm, kw in cfgs:
    for pol in ("fixed", "throttle", "anticipate"):
        d = day(pol, r_pit=0.42, **kw)
        print(f"{nm:>17}{pol:>10}{d['kw']:>6.2f}{d['h_in']:>8.2f}"
              f"{d['h_hot']:>7.2f}{d['peak']:>6.0f}{d['rotis']:>7.1f}")

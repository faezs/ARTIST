"""Geometry sweep for beam-down cold-start. The blur lever is
EFL = f1 * (z_vertex + pivot_drop)/z_gap, and shadow = (z_gap/f1)^2 -
so z_gap trades secondary shadow against spot size. Cold start is the
binding case because low morning sun = max tilt = worst oblique pit
clipping."""
import itertools, pathlib, sys, time
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_rl_env import TandoorEnv

def cold_day(agents=8, seed=1, steps=1922, **kw):
    env = TandoorEnv(num_agents=agents, seed=seed, wide_shutter=1,
                     device="cpu", **kw)
    env.reset(seed=seed); env.T[:] = 350.0
    env._belt_prev = env.T[:, :8].mean(1).copy()
    rot, p = 0.0, []
    t_band, n_in, n_hot, peak = None, 0, 0, 0.0
    for t in range(steps):
        belt = env.T[:, :8]
        ready = (env.load_timer >= 45.0) & (
            ((~env.has_bread) & (belt >= 560.) & (belt <= 700.)).any(1))
        a = np.stack([np.full(agents, 4), np.where(ready, 0, 6)], axis=1)
        *_, infos = env.step(a)
        p.append(env.p_in.mean())
        bm = belt.mean()
        if t_band is None and bm >= 560: t_band = float(env.t_solar[0])
        n_in += (560.0 <= bm <= 700.0)      # usable cooking band
        n_hot += (bm >= 560.0)              # at or above band floor
        peak = max(peak, float(bm))
        for inf in infos: rot = inf["rotis_per_day"]
    hrs = env.dt / 3600.0
    return dict(rotis=rot, kw=np.mean(p) / 1000, t_band=(t_band or 99.0),
                h_in=n_in * hrs, h_hot=n_hot * hrs, peak=peak,
                belt_end=float(env.T[:, :8].mean()),
                rsec=env.sec.rho_max, a=env.cfg.a)

if __name__ == "__main__":
    print(f"{'z_gap':>6}{'r_pit':>7}{'a':>6}{'r_sec':>7}{'shadow':>8}"
          f"{'mean kW':>9}{'band at':>9}{'rotis':>8}")
    best = None
    for z_gap, r_pit, a_m in itertools.product(
            (1.23, 2.2, 3.0), (0.42, 0.55), (1.65, 2.05)):
        t0 = time.time()
        rot, pm, tb, be, rs, aa = cold_day(z_gap=z_gap, r_pit=r_pit, a_mem=a_m)
        sh = (rs / aa) ** 2 * 100
        print(f"{z_gap:>6.2f}{r_pit:>7.2f}{a_m:>6.2f}{rs:>7.3f}{sh:>7.0f}%"
              f"{pm/1000:>9.2f}{tb:>9.2f}{rot:>8.1f}")
        if best is None or rot > best[0]:
            best = (rot, dict(z_gap=z_gap, r_pit=r_pit, a_mem=a_m))
    print(f"\nbest so far: {best[0]:.1f} rotis  {best[1]}")

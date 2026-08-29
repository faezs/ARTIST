"""Where does the beam-down's energy actually go, and when does it reach
the cooking band from cold? Diagnose before redesigning."""
import pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from tandoor_rl_env import TandoorEnv

def diag(**kw):
    env = TandoorEnv(num_agents=8, seed=1, wide_shutter=1, device="cpu", **kw)
    env.reset(seed=1); env.T[:] = 350.0
    env.equilibrate_wall()
    env._belt_prev = env.T[:, :8].mean(1).copy()
    t_band, rot = None, 0
    p_hist = []
    for t in range(1922):
        belt = env.T[:, :8]
        ready = (env.load_timer >= 45.0) & (
            ((~env.has_bread) & (belt >= 560.) & (belt <= 700.)).any(1))
        a = np.stack([np.full(8, 4), np.where(ready, 0, 6)], axis=1)
        *_, infos = env.step(a)
        p_hist.append(env.p_in.mean())
        if t_band is None and belt.mean() >= 560.0:
            t_band = env.t_solar[0]
        for inf in infos: rot = inf["rotis_per_day"]
    return dict(t_band=t_band, rotis=rot, p_mean=np.mean(p_hist),
                p_peak=np.max(p_hist), belt_end=env.T[:, :8].mean(),
                efl=env._efl if hasattr(env, "_efl") else None,
                rsec=env.sec.rho_max, rwin=env.cfg.r_window)

print("== baseline beam-down, cold start ==")
d = diag()
print(f"  r_sec={d['rsec']:.3f} m (shadow {(d['rsec']/1.65)**2*100:.0f}%), "
      f"window r={d['rwin']:.3f} m")
print(f"  peak {d['p_peak']:.0f} W, mean {d['p_mean']:.0f} W")
print(f"  reaches 560 K band at {d['t_band']} , belt ends "
      f"{d['belt_end']:.0f} K, rotis {d['rotis']:.1f}")
print("\n(polar for scale: 2.98 kW mean, 374 rotis cold)")

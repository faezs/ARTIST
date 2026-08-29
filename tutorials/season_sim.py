"""Uncontaminated multi-day seasoning: carry the true wall+halo state
across days (the env's day-over reset redraws T - snapshot before it
fires, restore after), 16 h overnight conduction between days."""
import numpy as np, sys
sys.path.insert(0, ".")
from tandoor_eval_suite import make_env
from tandoor_compare import heuristic

SIGMA = 5.67e-8
e = make_env(7, agents=16, day_of_year=172, day_random=0, lat_random=0)
e.T[:] = 350.0 + e.rng.uniform(-15, 15, e.T.shape)
e.T_sub = e.T.copy(); e.T_deep = e.T.copy(); e.T_halo[:] = 300.0

def overnight(e):
    for _ in range(int(16*3600/15)):
        T, TAMB = e.T, 300.0
        t4 = T**4
        tc4 = (e.node_area*t4).sum(1, keepdims=True)/e.node_area.sum()
        qx = 0.85*SIGMA*e.node_area*(tc4-t4)
        qa = 0.75*SIGMA*(tc4[:, 0]-TAMB**4)*(np.pi*0.26**2)*0.05
        q01 = e.g01*(T-e.T_sub); q12 = e.g12*(e.T_sub-e.T_deep)
        q2s = e.g2s*(e.T_deep-e.T_halo[:, None])
        q = qx - q01
        q[:, e.n_belt+2] -= qa
        e.T = T + q*15/e.node_heat_cap
        e.T_sub = e.T_sub + (q01-q12)*15/e.cap_sub
        e.T_deep = e.T_deep + (q12-q2s)*15/e.cap_deep
        e.T_halo = e.T_halo + (q2s.sum(1)
                               - e.g_halo_out*(e.T_halo-TAMB))*15/e.c_halo

for d in range(1, 46):
    mb, hh = e.T[:, :e.n_belt].mean(), e.T_halo.mean()
    rot, snap = [], None
    for s in range(1921):
        snap_prev = (e.T.copy(), e.T_sub.copy(), e.T_deep.copy(),
                     e.T_halo.copy())
        *_, infos = e.step(heuristic(e, 16))
        got = [i for i in infos if "rotis_per_day" in i]
        if got:
            rot.append(got[0]["rotis_per_day"])
            snap = snap_prev          # state just BEFORE the reset stomp
    if snap is not None:              # undo the day-over redraw
        e.T, e.T_sub, e.T_deep, e.T_halo = snap
    print(f"day{d:3d} morning belt {mb:5.0f} deep {e.T_deep.mean():5.0f} "
          f"halo {hh:5.0f} -> rotis {np.mean(rot) if rot else 0:6.1f}",
          flush=True)
    overnight(e)
    e.t_solar[:] = 8.0
    e._belt_prev = e.T[:, :e.n_belt].mean(1).copy()
print(f"seasoned morning: face {e.T.mean():5.0f} sub {e.T_sub.mean():5.0f} "
      f"deep {e.T_deep.mean():5.0f} halo {e.T_halo.mean():5.0f}")

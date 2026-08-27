"""Can the pump actually tighten the beam on the secondary?

The pump sets plenum pressure, which sets the membrane's focal length
f1. The secondary sits at a FIXED z_vertex, so a shorter f1 moves the
primary's focus closer and the cone arriving at the secondary narrows.
That is real authority. But the secondary is a fixed hyperboloid with
foci (z_f1_nominal, -pivot_drop), so moving f1 off nominal also stops it
imaging correctly.

This measures both halves per pressure level: how wide the beam is where
the secondary sits, and how much light actually reaches the pit.
"""
import contextlib, io, pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
from tandoor_rl_env import TandoorEnv, _sim


if __name__ == "__main__":
    with contextlib.redirect_stdout(io.StringIO()):
        env = TandoorEnv(num_agents=1, seed=0, wide_shutter=1, device="cpu")
        env.reset(seed=0)
    cfg = env.cfg
    m0 = env._mem0
    z_f1_nom = float(m0["z0"] + m0["f_fit"])
    z_vertex = z_f1_nom - cfg.z_gap
    print(f"\n  HARDWARE, fixed at build time and NOT an action:")
    print(f"    secondary radius r_sec = sec_margin * rho_parab = "
          f"{env.sec.rho_max:.3f} m  (sec_margin={cfg.sec_margin})")
    print(f"    secondary vertex z     = {z_vertex:.3f} m")
    print(f"    aperture rays are culled below r = {env._r_keep_in:.3f} m, "
          f"which IS the shadow")
    print(f"\n  WHAT THE PUMP CAN MOVE:")
    print(f"  {'level':>6}{'p/p0':>7}{'f1':>8}{'z_gap':>8}"
          f"{'beam r @ sec':>14}{'hits sec':>10}{'to pit':>9}{'W/DNI':>9}")
    sig = float(np.sqrt(env.sigma_sun ** 2 + (2 * env.sigma_surf) ** 2
                        + (2 * env.sigma_fab) ** 2))
    peak = 0.0
    for li, fr in enumerate(env.level_frac):
        peak = max(peak, float(env._trace_power(
            np.full(1, env.p0 * fr), np.full(1, sig),
            np.zeros((1, 2)), np.ones(1)).sum()))
    for li, fr in enumerate(env.level_frac):
        m = _sim.solve_membrane(cfg, env.p0 * fr, n=500)
        f1 = float(m["z0"] + m["f_fit"])
        zg = f1 - z_vertex
        lv = torch.full((1,), float(li))
        o4, d4, _ = env.primary.bounce(lv, np.full(1, sig), 3)
        o4, d4 = o4.reshape(-1, 4), d4.reshape(-1, 4)
        # where does the cone cross the secondary's vertex plane?
        t = (z_vertex - o4[:, 2]) / d4[:, 2].clamp(min=1e-9)
        cross = o4[:, :3] + t[:, None] * d4[:, :3]
        rb = float(torch.linalg.norm(cross[:, :2], dim=1).max())
        _, _, ok = env.sec.intersect(o4, d4)
        nd = env._trace_power(np.full(1, env.p0 * fr), np.full(1, sig),
                              np.zeros((1, 2)), np.ones(1))
        print(f"  {li:>6}{fr:>7.2f}{f1:>8.2f}{zg:>8.2f}{rb:>14.3f}"
              f"{float(ok.float().mean())*100:>9.0f}%"
              f"{float(nd.sum())/max(peak,1e-9)*100:>8.0f}%"
              f"{float(nd.sum()):>9.1f}")

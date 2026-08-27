"""Where does the coude actually lose the light?

Last report blamed the blur lever (EFL 19.7 m). This checks that claim
stage by stage instead of asserting it, because the secondary looks
undersized: the converging cone at the secondary station is
D*z_gap/f1 wide, and r_sec was set to 0.75 by hand.
"""
import pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import tandoor_coude_optics as CO
from tandoor_rl_env import _sim
from tandoor_coude_env import TandoorCoudeEnv


def budget(env, el=55.0, seed=0):
    m = env._coude_mems[4]
    sg, sp = _sim.sag_interp(m, torch.tensor(env._cr, dtype=torch.float64))
    sig = float(np.sqrt(env.sigma_sun ** 2 + env.sig_static ** 2))
    R = CO.trace_coude(env._cx, env._cy, sg.numpy(), sp.numpy(), env.sec,
                       el, 0.0, env.f1_c, sig, np.random.default_rng(seed))
    n = len(env._cx)
    return dict(sec=R["ok2"].mean(), m3=R["ok"].mean(), m4=R["ok4"].mean(),
                chase=(R["ok4"] & R["in_chase"]).mean(),
                duct=R["through"].mean(),
                r_m3_p99=np.percentile(R["r_m3"][R["ok2"]], 99))


def sweep_rsec(a_mem=2.10, z_gap=2.5, els=(25., 45., 65., 88.)):
    print(f"\n=== r_sec sweep, a={a_mem}, z_gap={z_gap} "
          f"(secondary shadow NOW modelled) ===")
    print(f"{'r_sec':>7}{'shadow':>8}{'hits M2':>9}{'through':>9}"
          f"{'x aper':>8}   relative power")
    rows = []
    for rs in (0.75, 0.85, 0.95, 1.00, 1.05, 1.15, 1.30):
        import contextlib, io
        with contextlib.redirect_stdout(io.StringIO()):
            env = TandoorCoudeEnv(num_agents=1, seed=0, wide_shutter=1,
                                  device="cpu", a_mem=a_mem, z_gap=z_gap,
                                  r_sec=rs)
        th, hm = [], []
        for el in els:
            b = budget(env, el=el)
            th.append(b["duct"]); hm.append(b["sec"])
        thr = float(np.mean(th))
        rows.append((rs, thr))
        sh = (rs / env.cfg.a) ** 2
        print(f"{rs:>7.2f}{sh*100:>7.0f}%{np.mean(hm)*100:>8.1f}%"
              f"{thr*100:>8.1f}%{thr*np.pi*env.cfg.a**2:>8.2f}", end="")
        print("   " + "#" * int(round(thr * 60)))
    best = max(rows, key=lambda r: r[1])
    print(f"  -> best r_sec {best[0]:.2f} at {best[1]*100:.1f}% "
          f"(was 0.75 at {rows[0][1]*100:.1f}%)")
    return best[0]


if __name__ == "__main__":
    print("\n=== stage-by-stage ray budget, a=2.10, r_sec=0.75 (current) ===")
    env = TandoorCoudeEnv(num_agents=1, seed=0, wide_shutter=1,
                          device="cpu", a_mem=2.10)
    b = budget(env)
    f1, zg, a = env.f1_c, env.z_gap, env.cfg.a
    print(f"  f1 {f1:.2f} m   z_gap {zg:.2f}   zv {env.zv_c:.2f}   "
          f"aperture radius {a:.2f} m")
    print(f"  cone radius AT the secondary station = a*z_gap/f1 = "
          f"{a*zg/f1:.3f} m,  but r_sec = {env.sec.rho_max:.3f} m")
    print(f"    hits secondary        {b['sec']*100:5.1f} %")
    print(f"    clears M3 aperture    {b['m3']*100:5.1f} %")
    print(f"    reaches M4            {b['m4']*100:5.1f} %")
    print(f"    inside the chase bore {b['chase']*100:5.1f} %")
    print(f"    through the duct      {b['duct']*100:5.1f} %")
    print(f"  M3 footprint p99 = {b['r_m3_p99']:.3f} m (cap now {CO.R_M3})")
    sweep_rsec(2.10, 2.5)



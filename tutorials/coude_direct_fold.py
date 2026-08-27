"""Delete M3: let the secondary's exit beam run down the optical axis
straight to a single fold at the el/az crossing, which turns it down the
chase.  (User's proposal.)

WHY THE ARRIVAL POINT IS STILL INVARIANT: in an alt-az mount the optical
axis, the elevation axis and the azimuth axis all meet at one point. A
point on both moving axes cannot be moved by either rotation, so the
beam always crosses it - no matter where the dish is pointed. So one
mirror there does catch the beam at every attitude.

WHAT IS NOT INVARIANT IS THE DIRECTION. The beam arrives anti-sun, so
the deviation this single mirror must supply is (90 - el), and a mirror
deviating by D works at incidence i = (180 - D)/2 = 45 + el/2. That is
the whole question, and it is geometric, not a modelling artifact.
"""
import pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import tandoor_coude_optics as CO
from tandoor_rl_env import _sim
from coude_clearance import min_z_m4

reflect_np, rot = CO.reflect_np, CO.rot


def trace_direct(px, py, sag, slope, sec, el_deg, az_deg, sigma, z_m4,
                 z_cross=-0.45, rng=None):
    """Primary -> secondary -> (through the hole) -> ONE fold at the
    el/az crossing -> chase -> M5 -> pot.  Four reflections, not five."""
    n = len(px)
    rng = rng or np.random.default_rng(0)
    r = np.hypot(px, py); r = np.where(r < 1e-9, 1e-9, r)
    nrm = np.stack([-slope * px / r, -slope * py / r, np.ones(n)], 1)
    inc = np.stack([rng.normal(0, sigma, n), rng.normal(0, sigma, n),
                    -np.ones(n)], 1)
    inc /= np.linalg.norm(inc, axis=1, keepdims=True)
    d1 = reflect_np(inc, nrm)
    o1 = np.stack([px, py, sag], 1)
    zv_s = sec.zc + sec.A
    t_sh = (zv_s - sag) / np.where(-inc[:, 2] > 1e-9, -inc[:, 2], 1e-9)
    shp = o1 - inc * t_sh[:, None]
    lit = np.hypot(shp[:, 0], shp[:, 1]) > sec.rho_max
    hit2, n2, ok = sec.intersect(
        torch.tensor(np.c_[o1, np.ones(n)], dtype=torch.float32),
        torch.tensor(np.c_[d1, np.zeros(n)], dtype=torch.float32))
    d2 = _sim.reflect(torch.tensor(np.c_[d1, np.zeros(n)],
                                   dtype=torch.float32), n2).numpy()[:, :3]
    hit2 = hit2.numpy()[:, :3]; ok2 = ok.numpy() & lit
    # dish -> world.  The crossing is ON the optical axis at z_cross, and
    # is the point BOTH axes leave fixed, so the dish pivots about it.
    M = rot([0, 0, 1], np.radians(az_deg)) @ rot([1, 0, 0],
                                                 np.radians(90.0 - el_deg))
    p_x = np.array([CO.X_CHASE, 0.0, z_m4])
    pivot = p_x - M @ np.array([0.0, 0.0, z_cross])
    to_w = lambda p: (M @ p.T).T + pivot
    h2w = to_w(hit2); d2w = (M @ d2.T).T
    # the single articulated flat: bisect (arrival chief ray -> straight
    # down).  n proportional to u - v reflects u exactly into v.
    u = M @ np.array([0.0, 0.0, -1.0])          # anti-sun = chief arrival
    v = np.array([0.0, 0.0, -1.0])              # down the chase
    dev = np.degrees(np.arccos(np.clip(u @ v, -1, 1)))
    nf = u - v
    nf = nf / np.linalg.norm(nf) if np.linalg.norm(nf) > 1e-9 else v.copy()
    inc_ang = 0.5 * (180.0 - dev)
    den = d2w @ nf
    t = ((p_x - h2w) @ nf) / np.where(np.abs(den) > 1e-9, den, 1e-9)
    hf = h2w + t[:, None] * d2w                  # hits on the flat
    okf = ok2 & (t > 0)
    # footprint ON the mirror, in its own plane
    e1 = np.cross(nf, [0, 0, 1.0])
    e1 = e1 / np.linalg.norm(e1) if np.linalg.norm(e1) > 1e-9 else np.array([1., 0, 0])
    e2 = np.cross(nf, e1)
    q = hf[okf] - p_x
    foot = 2 * max(np.percentile(np.abs(q @ e1), 99),
                   np.percentile(np.abs(q @ e2), 99)) if okf.any() else np.inf
    d3 = reflect_np(d2w, np.broadcast_to(nf, d2w.shape))
    t5 = (CO.Z_DUCT - hf[:, 2]) / np.where(d3[:, 2] < -1e-9, d3[:, 2], -1e-9)
    h5 = hf + t5[:, None] * d3
    in_chase = np.hypot(h5[:, 0] - CO.X_CHASE, h5[:, 1]) < CO.R_CHASE
    n5 = np.array([1.0, 0.0, -1.0]) / np.sqrt(2)
    d5 = reflect_np(d3, np.broadcast_to(n5, d3.shape))
    t6 = (CO.R_POT - h5[:, 0]) / np.where(d5[:, 0] < -1e-9, d5[:, 0], -1e-9)
    h6 = h5 + t6[:, None] * d5
    through = okf & in_chase & (t5 > 0) & \
        (np.hypot(h6[:, 1], h6[:, 2] - CO.Z_DUCT) < CO.R_DUCT_C)
    return dict(through=through, ok2=ok2, okf=okf, dev=dev,
                inc=inc_ang, foot=foot, hf=hf, h5=h5)


if __name__ == "__main__":
    import contextlib, io
    from tandoor_coude_env import TandoorCoudeEnv
    for a_mem, r_sec in ((2.10, 0.85), (1.75, 0.72)):
        with contextlib.redirect_stdout(io.StringIO()):
            env = TandoorCoudeEnv(num_agents=1, seed=0, wide_shutter=1,
                                  device="cpu", a_mem=a_mem, r_sec=r_sec)
        m = env._coude_mems[4]
        sg, sp = _sim.sag_interp(m, torch.tensor(env._cr, dtype=torch.float64))
        sig = float(np.sqrt(env.sigma_sun ** 2 + env.sig_static ** 2))
        sag_rim = float(sg.numpy().max())
        z_m4 = min_z_m4(a_mem, sag_rim)
        print(f"\n=== a={a_mem} m, r_sec={r_sec}, Z_M4={z_m4:.2f} m "
              f"(roof-clearance minimum, not the old 4.15) ===")
        print(f"{'sun el':>7}{'deviation':>11}{'incidence':>11}"
              f"{'mirror needs':>14}{'hits M2':>9}{'through':>9}")
        for el in (20., 30., 45., 60., 75., 85.):
            R = trace_direct(env._cx, env._cy, sg.numpy(), sp.numpy(),
                             env.sec, el, 0.0, sig, z_m4,
                             rng=np.random.default_rng(0))
            fp = R["foot"]
            fs = f"{fp:8.2f} m" if np.isfinite(fp) and fp < 99 else "     ---"
            flag = "  <-- bigger than the dish" if fp > 2 * a_mem else ""
            print(f"{el:>7.0f}{R['dev']:>10.1f}d{R['inc']:>10.1f}d"
                  f"{fs:>14}{R['ok2'].mean()*100:>8.1f}%"
                  f"{R['through'].mean()*100:>8.1f}%{flag}")

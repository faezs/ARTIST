"""Tune the telescope's two tube stiffnesses so the wind-bent shape self-compensates in the image, over the YEAR.

A two-stage telescope is a root tube (EI1, fixed length L1) carrying an extending tube (EI2, length Lb - L1). Under a
tip load P the tip rotation and translation follow by superposition - the outer tube is a cantilever loaded by the
inner tube's root force P and moment P*L2:
    theta = P [ L1^2/(2 EI1) + L1 L2/EI1 + L2^2/(2 EI2) ]
    delta = P [ L1^3/(3 EI1) + L1^2 L2/(2 EI1) ] + theta_root * L2 + P L2^3/(3 EI2),   theta_root the outer tube's tip slope
so theta/delta is a function of Lb that the ratio EI2/EI1 and the split L1 reshape. The optics fix, pose by pose, the
theta/delta that zeroes the image walk. Choose (EI2/EI1, L1) to minimise the rms walk per newton over the year's poses.
Compare against the uniform boom as built and against a parallel-guiding boom (theta = 0)."""
import contextlib, io, sys, numpy as np, torch
from scipy.optimize import minimize
for p in ("/Users/faezs/ARTIST/tutorials", "/Users/faezs/ARTIST", "/Users/faezs/ARTIST/tutorials/puffer_tandoor"): sys.path.insert(0, p)
from tandoor_flower_env import TandoorFlowerEnv, EI_BOOM, EI_STEM, D_REC
from tandoor_mount_batch import solar_batch
K = dict(num_agents=4, seed=7, wide_shutter=1, device="mps", gpu=1, n_rays=64, warm_frac=1.0, day_random=0,
         lat_random=0, wall_obs=1, beta_dev=36.0, beta_cap_z=10.6, silvered=1, spot_bread=1, roti_kj=130.0,
         bread_area=0.12, loaves_per_load=8, elbow_aim=1, load_ctrl=1, sticky_k=0, g_orbit=4.0, a_mem=2.1,
         receiver="tri", r_duct=0.55, n_zones=5, zone_c=0.4, base="stem")
with contextlib.redirect_stdout(io.StringIO()):
    e = TandoorFlowerEnv(**K); e.reset(seed=7)
B = e.num_agents; dev = e.device; F = e._fl_F(); T0 = e._fl_stem().cpu().numpy().astype(float)
a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=dev); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
with torch.no_grad(): e.step_torch(a)
S = e._gpu
def miss(C, n, s):
    r = -s + 2*(s@n)*n; d = F - C; return d - (d@r)*r
# ---- the year's poses, each with its optical sensitivities in the boom's bending plane
P = []
for day in range(10, 366, 20):
    for hour in np.arange(7.5, 16.51, 1.0):
        el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(hour))
        if float(el.mean()) <= 12.0: continue
        S.day_v.fill_(float(day)); S.lat_v.fill_(30.2); S.el_m.copy_(el.to(dev)); S.az_m.copy_(torch.rad2deg(az).to(dev))
        e.t_solar[:] = hour; e.day = day
        C, n = e._fl_head_pose(); C = C[0].cpu().numpy().astype(float); n = n[0].cpu().numpy().astype(float); n /= np.linalg.norm(n)
        az_ = float(az[0]); el_ = float(np.radians(el[0])); s = np.array([np.cos(el_)*np.cos(az_), np.cos(el_)*np.sin(az_), np.sin(el_)])
        Cb = C - D_REC*n; b = Cb - T0; Lb = float(np.linalg.norm(b)); bu = b/Lb
        w = np.array([1.0, 0, 0]); t = w - (w@bu)*bu; tn = np.linalg.norm(t)
        if tn < 1e-6: continue
        t /= tn; ra = np.cross(bu, t); h = 1e-4
        dT = (miss(C + h*t, n, s) - miss(C - h*t, n, s))/(2*h)
        nR = lambda sg: (n + sg*h*np.cross(ra, n))/np.linalg.norm(n + sg*h*np.cross(ra, n))
        dR = (miss(C, nR(+1), s) - miss(C, nR(-1), s))/(2*h)
        u = dT/max(np.linalg.norm(dT), 1e-12)
        # the wind's transverse force on the head, per unit dynamic pressure, for weighting: cd ~ 0.5 on 13.85 m2
        P.append((Lb, float(dT@u), float(dR@u), abs(float(w@n))))
P = np.array(P); Lb, gtr, grot, cosw = P.T
print(f"{len(P)} poses. Lb runs {Lb.min():.2f}-{Lb.max():.2f} m; the optics want theta/delta = {np.median(-gtr/grot):.3f} rad/m (median), sign {'+' if np.all(-gtr/grot > 0) else 'mixed'}")

Ls = 1.0
def two_stage(Lb_, EI1, EI2, L1):
    """tip rotation and translation per newton of tip load, stem + two-stage telescope"""
    L1_ = np.minimum(L1, Lb_); L2 = np.maximum(Lb_ - L1_, 0.0)
    th_s = (Ls*Ls/2 + Lb_*Ls)/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)/EI_STEM             # the stem, carrying P and P*Lb
    th1 = L1_*L1_/(2*EI1) + L1_*L2/EI1                                                    # the root tube: force P, moment P L2
    d1 = L1_**3/(3*EI1) + L1_*L1_*L2/(2*EI1)
    th2 = L2*L2/(2*EI2); d2 = L2**3/(3*EI2)                                               # the extending tube as a cantilever
    theta = th_s + th1 + th2
    delta = d_s + th_s*Lb_ + d1 + th1*L2 + d2
    return theta, delta
def walk(theta, delta): return np.abs(grot*theta + gtr*delta)                              # m of image per N, per pose
wgt = cosw*0 + 1.0                                                                          # equal weight per pose
def rms(x): return float(np.sqrt(np.mean(wgt*x*x)))

th_u, de_u = two_stage(Lb, EI_BOOM, EI_BOOM, 1e9)                                          # uniform, as built
th_p = np.zeros_like(Lb); de_p = de_u                                                        # parallelogram: same translation, no tilt
base_u, base_p = rms(walk(th_u, de_u)), rms(walk(th_p, de_p))
from scipy.optimize import minimize as _min
Lmin = float(Lb.min())
def solve(lo_r, hi_r, label):
    """bounded: L1 in [0.2, Lmin] so the root tube is never longer than the shortest extension, and EI2/EI1 within the
    tube ratio the arrangement allows. Unbounded, the optimiser ran to a negative root and a 948 mm tube."""
    best = None
    for r0 in np.geomspace(lo_r*1.05, hi_r*0.95, 6):
        for L10 in np.linspace(0.3, Lmin - 0.05, 4):
            o = _min(lambda x: rms(walk(*two_stage(Lb, EI_BOOM, EI_BOOM*np.exp(x[0]), x[1]))),
                     [np.log(r0), L10], method="L-BFGS-B", bounds=[(np.log(lo_r), np.log(hi_r)), (0.2, Lmin)])
            if best is None or o.fun < best.fun: best = o
    return np.exp(best.x[0]), best.x[1], best.fun, label
cands = [solve(0.02, 1.0, "conventional telescope: thin tube extends from a fat root"),
         solve(1.0, 20.0, "REVERSED telescope: fat tube extends, thin tube at the root")]
r_best, L1_best, fbest, lab_best = min(cands, key=lambda c: c[2])
th_b, de_b = two_stage(Lb, EI_BOOM, EI_BOOM*r_best, L1_best); wb = walk(th_b, de_b)
class _B: pass
best = _B(); best.fun = fbest
print()
print(f"{'boom':<40} {'rms walk/N':>11} {'worst pose':>11} {'vs built':>9}")
print(f"{'uniform CHS 219x8, as built':<40} {1e6*base_u:9.2f} um {1e6*walk(th_u,de_u).max():9.2f} um {'1.00x':>9}")
print(f"{'parallel-guiding (theta = 0), same EI':<40} {1e6*base_p:9.2f} um {1e6*walk(th_p,de_p).max():9.2f} um {base_u/base_p:8.2f}x")
print(f"{'two-stage, EI2/EI1 and L1 tuned':<40} {1e6*best.fun:9.2f} um {1e6*wb.max():9.2f} um {base_u/best.fun:8.2f}x")
for r_, L1_, f_, lab_ in cands:
    print(f"  {lab_:<62} EI2/EI1 {r_:6.3f}  L1 {L1_:4.2f} m  rms {1e6*f_:6.2f} um  ({base_u/f_:.2f}x built)")
print(f"\n  best: {lab_best}: EI2 = {r_best:.3f} x EI1, root L1 = {L1_best:.2f} m")
d2 = 0.219*r_best**0.25
print(f"  at the same wall, EI scales as d^3 t ~ d^4 for a thin tube: EI2/EI1 {r_best:.3f} -> extending tube d ~ {1e3*d2:.0f} mm against the root's 219")
print(f"\n  and at 12 m/s (about 500 N rms of gust force):  built {1e3*base_u*500:.2f} mm   parallelogram {1e3*base_p*500:.2f} mm   tuned {1e3*best.fun*500:.2f} mm")

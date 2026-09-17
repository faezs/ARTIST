"""The neutral point, the chain's centres, and what a pivot anywhere on the stem line can do - with the rotation gain
taken ABOUT THE BOOM TIP (the vertex rides D_REC = 1.8 m in front of it), through the env's own miss_gains."""
import contextlib, io, sys, numpy as np, torch
for p in ("/Users/faezs/ARTIST/tutorials", "/Users/faezs/ARTIST", "/Users/faezs/ARTIST/tutorials/puffer_tandoor"): sys.path.insert(0, p)
from tandoor_flower_env import TandoorFlowerEnv, EI_BOOM, EI_STEM, D_REC, M_HEAD, M_CROWN, SIG_BALL_WORK, miss_gains
from tandoor_mount_batch import solar_batch
K = dict(num_agents=4, seed=7, wide_shutter=1, device="mps", gpu=1, n_rays=64, warm_frac=1.0, day_random=0,
         lat_random=0, wall_obs=1, beta_dev=36.0, beta_cap_z=10.6, silvered=1, spot_bread=1, roti_kj=130.0,
         bread_area=0.12, loaves_per_load=8, elbow_aim=1, load_ctrl=1, sticky_k=0, g_orbit=4.0, a_mem=2.1,
         receiver="tri", r_duct=0.55, n_zones=5, zone_c=0.4, base="stem")
with contextlib.redirect_stdout(io.StringIO()):
    e = TandoorFlowerEnv(**K); e.reset(seed=7)
B = e.num_agents; dev = e.device; Ff = torch.as_tensor(e._fl_F(), dtype=torch.float32, device=dev); T0 = e._fl_stem().cpu().numpy().astype(float)
a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=dev); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
with torch.no_grad(): e.step_torch(a)
S = e._gpu; rows = []
for day in range(10, 366, 20):
    for hour in np.arange(7.5, 16.51, 1.0):
        el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(hour))
        if float(el.mean()) <= 12.0: continue
        S.day_v.fill_(float(day)); S.lat_v.fill_(30.2); S.el_m.copy_(el.to(dev)); S.az_m.copy_(torch.rad2deg(az).to(dev))
        e.t_solar[:] = hour; e.day = day
        C, n = e._fl_head_pose(); C = C[:1]; n = n[:1]
        el_ = torch.deg2rad(el[:1].to(dev)); az_ = az[:1].to(dev)
        s = torch.stack([torch.cos(el_)*torch.cos(az_), torch.cos(el_)*torch.sin(az_), torch.sin(el_)], 1)
        Cb = C - D_REC*n; b = Cb - torch.as_tensor(T0, dtype=torch.float32, device=dev); Lb = torch.linalg.norm(b, dim=1); bu = b/Lb[:, None]
        w = torch.tensor([[1.0, 0, 0]], device=dev); t = w - (w*bu).sum(1, keepdim=True)*bu; tn = torch.linalg.norm(t, dim=1)
        if float(tn) < 1e-6: continue
        t = t/tn[:, None]; ra = torch.cross(bu, t, dim=1)
        g_tr, g_rot_C = miss_gains(Ff, C, n, s, t, ra)                       # about the vertex (the old call)
        _, g_rot = miss_gains(Ff, C, n, s, t, ra, lever=D_REC*n)              # about the tip, where the boom actually bends
        rows.append((float(Lb), float(g_tr), float(g_rot), float(g_rot_C), abs(float((w*n).sum())), float(torch.linalg.norm(Ff - C[0]))))
R = np.array(rows); Lb, gtr, grot, grotC, cosw, D = R.T
print(f"{len(R)} poses, Lb {Lb.min():.2f}-{Lb.max():.2f} m, head-to-F {D.min():.2f}-{D.max():.2f} m")
rC, rT = -grotC/gtr, -grot/gtr
print(f"rotation gain about the vertex: median {np.median(grotC):+.2f} m/rad; about the TIP (lever {D_REC} m): {np.median(grot):+.2f} m/rad; translation {np.median(gtr):+.3f} m/m")
print(f"neutral point behind the TIP: median {np.median(rT):.2f} m (10-90% {np.percentile(rT,10):.2f}-{np.percentile(rT,90):.2f}); relative to the root: {np.median(rT-Lb):+.2f} m (10-90% {np.percentile(rT-Lb,10):+.2f}..{np.percentile(rT-Lb,90):+.2f})")
print(f"   (about-the-vertex gains put it at {np.median(rC-Lb):+.2f} m from the root - that was the earlier, understated picture)")
print(f"the boom's own centre, 2Lb/3 behind the tip, is {np.median(rT-2*Lb/3):+.2f} m short of neutral (median); the stem base is at +1.0")
print(f"poses whose neutral point lies BEYOND the stem base (a base pivot cancels there): {100*np.mean(rT-Lb > 1.0):.0f}%")

Ls = 1.0
wgt = 0.25 + 0.75*cosw*cosw
def rms_w(x): return float(np.sqrt(np.sum(wgt*x*x)/np.sum(wgt)))
def walk(th, de): return np.abs(grot*th + gtr*de)
def chain(Lb_, kb=1.0, ks=1.0, c=0.0, dpiv=0.0):
    """stem (EI_STEM/ks) + boom (EI_BOOM*kb) + a lumped pivot of compliance c (rad per N m) whose centre sits dpiv m
    below the boom root on the stem line: tip rotation theta, tip translation delta, per newton of transverse tip load"""
    th_s = (Ls*Ls/2 + Lb_*Ls)*ks/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)*ks/EI_STEM
    th_b = Lb_*Lb_/(2*EI_BOOM*kb); d_b = Lb_**3/(3*EI_BOOM*kb)
    th_p = c*(Lb_ + dpiv); d_p = th_p*(Lb_ + dpiv)
    return th_s + th_b + th_p, d_s + th_s*Lb_ + d_b + d_p
base = rms_w(walk(*chain(Lb)))
print(f"\nwalk per newton, tip-referenced gains:")
print(f"{'chain':<44} {'um/N':>7} {'x built':>8}")
for lab, kw in (("as built", {}), ("boom 2x stiffer", dict(kb=2)), ("boom 4x stiffer", dict(kb=4)), ("boom rigid (the stem alone)", dict(kb=1e9)),
                ("stem 2x softer", dict(ks=2)), ("stem 4x softer", dict(ks=4)), ("stem rigid", dict(ks=1e-9)), ("stem rigid, boom rigid", dict(ks=1e-9, kb=1e9))):
    f = rms_w(walk(*chain(Lb, **kw))); print(f"{lab:<44} {1e6*f:7.2f} {base/f:8.2f}x")
print(f"\na lumped pivot on the stem line, centre dpiv below the root; best passive compliance per placement:")
print(f"{'dpiv m':>7} {'best k MN m/rad':>16} {'um/N':>7} {'x built':>8} {'poses wanting k<0':>18}")
best = None
for dpiv in (0.0, 0.5, 1.0, 2.0, 3.0, 5.0, 8.0):
    cs = np.geomspace(1e-10, 1e-4, 600); f = np.array([rms_w(walk(*chain(Lb, c=c, dpiv=dpiv))) for c in cs]); i = int(np.argmin(f))
    th0, de0 = chain(Lb); cz = -(grot*th0 + gtr*de0)/((grot + gtr*(Lb + dpiv))*(Lb + dpiv))
    print(f"{dpiv:7.1f} {1e-6/cs[i]:16.2f} {1e6*f[i]:7.2f} {base/f[i]:8.2f}x {100*np.mean(cz < 0):17.0f}%")
    if best is None or f[i] < best[2]: best = (dpiv, cs[i], f[i])
dpiv, c_b, f_b = best; k_b = 1/c_b; g = 9.81; Lmax = float(Lb.max())
M_g = (M_HEAD + M_CROWN)*g*Lmax; M_w = 0.5*1.2*15.0**2*13.85*0.5*(Lmax + dpiv)
print(f"\nbest placement {dpiv:.1f} m below the root, k = {k_b/1e6:.2f} MN m/rad: {1e6*f_b:.2f} um/N ({base/f_b:.2f}x)")
print(f"   gravity sag at full reach {1e3*M_g/k_b:.1f} mrad = {np.degrees(M_g/k_b):.2f} deg (static, pose-known); wind at 15 m/s {1e3*M_w/k_b:.2f} mrad")
E = 200e9
for L_bl, t in ((0.3, 0.04), (0.5, 0.05), (0.8, 0.06)):
    I_need = k_b*L_bl/(2*E); bw = 12*I_need/t**3
    sig_w = E*t*(M_w/k_b)/(2*L_bl); sig_g = M_g*(t/2)/(2*I_need)
    print(f"   cross-spring, two blades {1e3*bw:.0f} x {1e3*t:.0f} x {1e3*L_bl:.0f} mm: wind {1e-6*sig_w:.0f} MPa, gravity {1e-6*sig_g:.0f} MPa (cap {1e-6*SIG_BALL_WORK:.0f})")
np.save("pivot2_rows.npy", R)

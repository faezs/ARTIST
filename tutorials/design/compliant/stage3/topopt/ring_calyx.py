#!/usr/bin/env python
"""The head as it is built, not as a plate: a 50 um aluminised Mylar membrane on a rim ring, pumped to f 4 (the repo's own
FvK membrane solvers: tutorials/03_membrane_beamdown_tandoor.py, 1-D axisymmetric, and tutorials/membrane_fvk2d.py, 2-D),
the ring as a continuous aluminium tube (frame elements), and the calyx as the spider of bars from the ring to the six
platform anchors whose topology and sizes chapter 7's ground-structure method chooses (Frecker, sec. 7.3).

The chain: the membrane at its working pressure gives the ring its static line load (the film's pull, radial and axial,
from the 1-D solver's rim tension and slope); the 15 m/s peak gust adds a pressure field p = q (Cd + 8 c_M x/a) on the bowl,
solved on the 2-D FvK membrane, whose rim slope distribution is the wind's line load on the ring and whose residual against
the best-fit paraboloid is the membrane's own figure error under wind; the ring-and-spider frame carries all of it to the
anchors; the ring's displacement harmonics are read back as the membrane's boundary error: n = 1 axial is a tilt of the
figure (pointing: image walk 2 theta g), n >= 2 axial is figure (the harmonic membrane solution w_n (r/a)^n gives the slope
error), n = 2 radial is ovality (astigmatism, fy/fx = 1/ratio^2, fvk2d_answers Q1)."""
import os, sys, json, importlib.util, pathlib, numpy as np, scipy.sparse as sp, scipy.sparse.linalg as spla, matplotlib, torch
matplotlib.use("Agg"); import matplotlib.pyplot as plt
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
sys.path.insert(0, HERE); from mma1 import MMA1
TUT = pathlib.Path("/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, str(TUT)); import membrane_fvk2d as F2
_spec = importlib.util.spec_from_file_location("tsim", TUT/"03_membrane_beamdown_tandoor.py"); _sim = importlib.util.module_from_spec(_spec); _argv = sys.argv; sys.argv = [sys.argv[0]]; _spec.loader.exec_module(_sim); sys.argv = _argv
CFG = _sim.CFG
A_M, F_DES, T_PRE = 2.10, 4.0, float(os.environ.get("T_PRE", 2000.0))    # the env's membrane: a 2.10 m, CFG.T_pre 2000 N/m (the env sets only a), f 4
N_ZONES, ZONE_C = 5, 0.4                                                   # hashemi.ini: five plenum zones, p_k = p0 (1 - zone_c (r_k/a)^2) (tandoor_hashemi_env.py l. 1662-1676)
Z_EDGES = np.linspace(0.0, A_M, N_ZONES + 1); Z_RC = 0.5*(Z_EDGES[:-1] + Z_EDGES[1:]); Z_SHAPE = 1.0 - ZONE_C*(Z_RC/A_M)**2
V_PEAK, RHO_AIR, CD, CM = 15.0, 1.03, 1.40, 0.15
PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285]); D_BACK = 0.6
lines = []
def say(s=""): print(s); lines.append(s)
# ------------------------------------------------------------------ 1. the membrane at work (the repo's 1-D FvK solver)
CFG.a = A_M; CFG.T_pre = T_PRE
def f_of(p):
    m = _sim.solve_membrane(CFG, p*Z_SHAPE, n=600, zone_edges=Z_EDGES); return float(m["z0"] + m["f_fit"]) if "z0" in m else float(m["f_fit"]), m
lo, hi = T_PRE/(4*F_DES), 3.0*T_PRE/(0.25*F_DES)
for _ in range(40):
    mid = 0.5*(lo + hi); f_mid, _m = f_of(mid)
    if f_mid > F_DES: lo = mid
    else: hi = mid
DP, MEM = 0.5*(lo + hi), f_of(0.5*(lo + hi))[1]
r1 = MEM["r"].numpy() if torch.is_tensor(MEM["r"]) else np.asarray(MEM["r"]); Nr = MEM["Nr"].numpy() if torch.is_tensor(MEM["Nr"]) else np.asarray(MEM["Nr"]); sp_ = MEM["sp"].numpy() if torch.is_tensor(MEM["sp"]) else np.asarray(MEM["sp"])
N_rim, slope_rim = float(Nr[-1]), float(abs(sp_[-1])); w0 = float(MEM["w0"])
say(f"1. membrane (1-D FvK, a {A_M} m, T_pre {T_PRE:.0f} N/m, {N_ZONES} zones zone_c {ZONE_C}): centre-zone pressure {DP:.0f} Pa (rim zone {DP*Z_SHAPE[-1]:.0f}) for f {F_DES}; sag {w0*1e3:.0f} mm; rim tension {N_rim:.0f} N/m, rim slope {np.degrees(slope_rim):.1f} deg")
q_line_r, q_line_z = N_rim*np.cos(slope_rim), N_rim*np.sin(slope_rim)
P_TOT = float(np.sum(DP*Z_SHAPE*np.pi*(Z_EDGES[1:]**2 - Z_EDGES[:-1]**2)))
say(f"   the film's pull on the ring: {q_line_r:.0f} N/m radially inward (hoop compression {q_line_r*A_M/1e3:.1f} kN in the ring), {q_line_z:.0f} N/m toward the vertex ({2*np.pi*A_M*q_line_z/1e3:.1f} kN in all: the zoned pressure on the film, {P_TOT/1e3:.1f} kN)")
# ------------------------------------------------------------------ 2. the gust on the bowl (the repo's 2-D FvK solver)
q = 0.5*RHO_AIR*V_PEAK**2; N2 = 121; ext = A_M*1.04; dx = 2*ext/(N2 - 1); phi = F2.ellipse_phi(N2, ext, A_M, A_M)
xs = torch.linspace(-ext, ext, N2, dtype=torch.float64); Xg, Yg = torch.meshgrid(xs, xs, indexing="ij")
p_wind = q*(CD + 8*CM*Xg/A_M)                                          # the drag as a uniform pressure, the pitching moment as a linear gradient (into the bowl: adds to the pump)
Rg = torch.sqrt(Xg**2 + Yg**2); p_pump = torch.zeros_like(Rg)
for k in range(N_ZONES): p_pump[(Rg >= Z_EDGES[k]) & (Rg < Z_EDGES[k + 1] + (1e-9 if k == N_ZONES - 1 else 0))] = DP*Z_SHAPE[k]
p_pump[Rg >= Z_EDGES[-1]] = DP*Z_SHAPE[-1]
res0 = F2.solve_fvk(phi, dx, p_pump, T_PRE, CFG.E_mem, CFG.t_mem, CFG.nu_mem, iters=(500, 700))
res1 = F2.solve_fvk(phi, dx, p_pump + p_wind, T_PRE, CFG.E_mem, CFG.t_mem, CFG.nu_mem, iters=(500, 700), w_init=res0["w"])
fx0, fy0, rms0, _ = F2.fit_paraboloid(res0, dx, ext); se0 = F2.slope_error(res0, dx, ext, fx0, fy0)
fx1, fy1, rms1, _ = F2.fit_paraboloid(res1, dx, ext); se1 = F2.slope_error(res1, dx, ext, fx1, fy1)
# the wind's change of the rim slope around the rim -> the wind's line load on the ring
def rim_slope(res, nth=48):
    wx, wy = res["wx"].numpy(), res["wy"].numpy(); Xc, Yc = F2._cell_avg(Xg).numpy(), F2._cell_avg(Yg).numpy(); cw = res["cellw"].numpy()
    th = np.linspace(0, 2*np.pi, nth, endpoint=False); out = np.zeros(nth)
    for k, t in enumerate(th):
        rr = np.hypot(Xc - 0.92*A_M*np.cos(t), Yc - 0.92*A_M*np.sin(t)); m = (rr < 1.5*dx) & (cw > 0.5)
        out[k] = np.mean(wx[m]*np.cos(t) + wy[m]*np.sin(t)) if m.any() else np.nan
    return th, out
th, s0 = rim_slope(res0); _, s1 = rim_slope(res1); ds = s1 - s0
say(f"2. gust {V_PEAK} m/s (q {q:.0f} Pa, Cd {CD}, c_M {CM}) on the 2-D FvK membrane: f {fx0:.2f}/{fy0:.2f} -> {fx1:.2f}/{fy1:.2f} m; rms slope error vs the best paraboloid {se0*1e3:.2f} -> {se1*1e3:.2f} mrad (figure under wind, blur 2x); rim slope change mean {np.degrees(np.nanmean(ds)):.2f} deg, n=1 amplitude {np.degrees(np.nanmax(np.abs(ds - np.nanmean(ds)))):.2f} deg")
# ------------------------------------------------------------------ 3. ring (frame) + spider (truss) finite elements
E_AL, G_AL, RHO_AL = 69e9, 26e9, 2700.0; D_R, T_R = 0.100, 0.004                    # ring: Al tube 100 x 4
A_R = np.pi*(D_R*T_R - T_R**2); I_R = np.pi/64*(D_R**4 - (D_R - 2*T_R)**4); J_R = 2*I_R
NR = 48; th_r = np.linspace(0, 2*np.pi, NR, endpoint=False)
ring_nodes = [[A_M*np.cos(t), A_M*np.sin(t), 0.0] for t in th_r]
mid_nodes = [[1.55*np.cos(t), 1.55*np.sin(t), -0.30] for t in th_r[::2] + np.pi/NR] + [[1.1*np.cos(t), 1.1*np.sin(t), -0.15] for t in th_r[::4]]
anchors = [[np.cos(a), np.sin(a), -D_BACK] for a in PLAT_ANG]; hub = [[0.4*np.cos(t), 0.4*np.sin(t), -0.45] for t in th_r[::8]] + [[0.0, 0.0, -0.6]]
X = np.array(ring_nodes + mid_nodes + anchors + hub); n_nodes = len(X); n_anchor0 = NR + len(mid_nodes)
def frame_k(p, q_, E, G, A, Iy, Iz, J):
    L = np.linalg.norm(q_ - p); ex = (q_ - p)/L; ref = np.array([0, 0, 1.0]) if abs(ex[2]) < 0.9 else np.array([1.0, 0, 0]); ez = np.cross(ex, ref); ez /= np.linalg.norm(ez); ey = np.cross(ez, ex)
    R = np.vstack([ex, ey, ez]); T = np.zeros((12, 12))
    for b in range(4): T[3*b:3*b + 3, 3*b:3*b + 3] = R
    k = np.zeros((12, 12)); a_ = E*A/L; t_ = G*J/L; by, bz = E*Iy/L**3, E*Iz/L**3
    k[0, 0] = k[6, 6] = a_; k[0, 6] = k[6, 0] = -a_; k[3, 3] = k[9, 9] = t_; k[3, 9] = k[9, 3] = -t_
    for (i, j, m, n_, b_) in ((1, 7, 5, 11, bz), (2, 8, 4, 10, by)):
        sgn = 1.0 if i == 1 else -1.0
        k[i, i] = k[j, j] = 12*b_; k[i, j] = k[j, i] = -12*b_
        k[i, m] = k[m, i] = sgn*6*b_*L; k[i, n_] = k[n_, i] = sgn*6*b_*L; k[j, m] = k[m, j] = -sgn*6*b_*L; k[j, n_] = k[n_, j] = -sgn*6*b_*L
        k[m, m] = k[n_, n_] = 4*b_*L*L; k[m, n_] = k[n_, m] = 2*b_*L*L
    return T.T@k@T
frame_el = [(i, (i + 1) % NR) for i in range(NR)]
members = []
for i in range(NR, n_nodes):
    for j in range(n_nodes):
        if j == i or (j < NR and False): continue
        if j > i or j < NR:
            L = np.linalg.norm(X[j] - X[i])
            if 0.2 < L <= 1.35 and (i, j) not in members and (j, i) not in members: members.append((min(i, j), max(i, j)))
members = sorted(set(members)); M = np.array(members); nd = 6*n_nodes
dvec = X[M[:, 1]] - X[M[:, 0]]; Lm = np.linalg.norm(dvec, axis=1); dm = dvec/Lm[:, None]
def dofs_t(i): return np.array([6*i, 6*i + 1, 6*i + 2])
def dofs_f(i): return np.arange(6*i, 6*i + 6)
K_ring = sp.lil_matrix((nd, nd))
for i, j in frame_el:
    k = frame_k(X[i], X[j], E_AL, G_AL, A_R, I_R, I_R, J_R); d = np.concatenate([dofs_f(i), dofs_f(j)])
    for a_, da in enumerate(d): K_ring[da, d] += k[a_]
K_ring = K_ring.tocsc()
fixed = np.zeros(nd, bool)
for k in range(6): fixed[dofs_t(n_anchor0 + k)] = True
free = ~fixed
def K_of(A):
    rows, cols, vals = [], [], []
    for e in range(len(M)):
        b = np.concatenate([-dm[e], dm[e]]); ke = (E_AL*A[e]/Lm[e])*np.outer(b, b); d = np.concatenate([dofs_t(M[e, 0]), dofs_t(M[e, 1])])
        rows.append(np.repeat(d, 6)); cols.append(np.tile(d, 6)); vals.append(ke.ravel())
    K = K_ring + sp.coo_matrix((np.concatenate(vals), (np.concatenate(rows), np.concatenate(cols))), shape=(nd, nd)).tocsc()
    return K + sp.identity(nd, format="csc")*1e-3          # a whisper of grounding for rotations of nodes no frame touches
def solve(K, f): u = np.zeros(nd); u[free] = spla.spsolve(K[free][:, free], f[free]); return u
def elong(u): return np.array([np.concatenate([-dm[e], dm[e]])@np.concatenate([u[dofs_t(M[e, 0])], u[dofs_t(M[e, 1])]]) for e in range(len(M))])
# loads: the film's pull (static) + the gust's change of rim slope (wind) + weights, all at the ring's nodes
ell = 2*np.pi*A_M/NR; f_static = np.zeros(nd); f_wind = np.zeros(nd)
m_ring = RHO_AL*A_R*2*np.pi*A_M; m_film = 2*0.05e-3*1390*np.pi*A_M**2 + 4.0
for k, t in enumerate(th_r):
    rhat = np.array([np.cos(t), np.sin(t), 0.0]); f_static[dofs_t(k)] += -q_line_r*ell*rhat + np.array([0, 0, q_line_z*ell]) - np.array([0, 0, 9.81*(m_ring + m_film)/NR])
    dsk = np.interp(t, th, np.nan_to_num(ds), period=2*np.pi); f_wind[dofs_t(k)] += np.array([0, 0, N_rim*dsk*ell])      # the wind's extra axial pull of the film on the ring
say(f"3. ring Al {1e3*D_R:.0f} x {1e3*T_R:.0f} tube {m_ring:.0f} kg, films {m_film:.1f} kg; wind line load on the ring: {np.abs(f_wind).sum()/ell/NR:.0f} N/m mean magnitude, total axial {f_wind[2::6].sum():.0f} N (the pressure integral {float((p_wind*F2.cell_weights(phi, dx)[0]).sum()) if False else q*CD*np.pi*A_M**2:.0f} N)")
# ------------------------------------------------------------------ 4. the spider by ground structure (min compliance, both load cases)
amax, vol_frac = 4e-4, 0.12; n = len(M); A = np.full(n, vol_frac*amax); V = vol_frac*np.sum(amax*Lm); mma = MMA1(n, 1e-4*amax, amax, move=0.3)
f_tot = f_static + f_wind
for it in range(120):
    K = K_of(A); u_s = solve(K, f_static); u_w = solve(K, f_tot); dls, dlw = elong(u_s), elong(u_w)
    obj = float(f_static@u_s + f_tot@u_w); dobj = -E_AL*(dls**2 + dlw**2)/Lm
    g = float(np.sum(A*Lm)/V - 1.0); dg = Lm/V; A_new = mma.update(A, dobj, g, dg); ch = float(np.abs(A_new - A).max()/amax); A = A_new
    if it > 30 and ch < 1e-4: break
K = K_of(A); u_s = solve(K, f_static); u_w = solve(K, f_tot); u_d = u_w - u_s
kept = A > 0.05*amax; m_spider = float(np.sum(RHO_AL*A*Lm)); force = E_AL*A*elong(u_w)/Lm
say(f"4. spider by ground structure: {int(kept.sum())} bars kept of {n}, {m_spider:.0f} kg Al; bar force max {np.abs(force[kept]).max()/1e3:.1f} kN, stress max {np.abs(force[kept]/A[kept]).max()/1e6:.0f} MPa; ring stress from hoop {q_line_r*A_M/A_R/1e6:.1f} MPa")
# ------------------------------------------------------------------ 5. the ring's motion read as the membrane's boundary error
def harmonics(vals, nmax=6):
    c = np.fft.rfft(vals)/len(vals); amp = np.abs(c)*2; amp[0] /= 2; return amp[:nmax + 1]
w_s = u_s[2:6*NR:6]; w_d = u_d[2:6*NR:6]; ur_d = np.array([u_d[6*k]*np.cos(t) + u_d[6*k + 1]*np.sin(t) for k, t in enumerate(th_r)])
hw_s, hw_d, hr_d = harmonics(w_s), harmonics(w_d), harmonics(ur_d)
tilt = hw_d[1]/A_M; walk = 2*tilt*F_DES
rr = np.linspace(0, A_M, 200)[:, None]; tt = np.linspace(0, 2*np.pi, 180)[None, :]
slope2 = np.zeros_like(rr*tt)
for n_ in range(2, 7):
    wn = hw_d[n_]; slope2 += (n_*wn/A_M*(rr/A_M)**(n_ - 1))**2                 # |grad| of w_n (r/a)^n cos n theta, orientation-averaged
rms_fig = float(np.sqrt(np.sum(slope2*rr)/np.sum(rr*np.ones_like(tt))))
oval = hr_d[2]; ratio = (A_M + oval)/(A_M - oval); dfy_fx = 1/ratio**2 - 1
say(f"5. under the film's pull alone the ring sags {1e3*hw_s[0]:.2f} mm (piston, n 0) with n 2..6 axial harmonics {np.round(1e3*hw_s[2:], 3)} mm (the static warp the pump sees once; the zones absorb a fixed figure)")
say(f"   the gust adds: axial n 0 {1e3*hw_d[0]:.3f} mm, n 1 {1e3*hw_d[1]:.3f} mm (tilt {1e3*tilt:.3f} mrad, image walk {1e2*walk:.2f} cm at F), n 2..6 {np.round(1e3*hw_d[2:], 3)} mm (figure: rms slope {1e3*rms_fig:.3f} mrad, blur {2*1e3*rms_fig:.3f} mrad = {1e2*2*rms_fig*F_DES:.2f} cm); radial n 2 {1e3*oval:.3f} mm (fy/fx - 1 = {1e3*dfy_fx:.3f} per mille)")
say(f"   for comparison the membrane's own figure change under the same gust (item 2): {1e3*(se1 - se0):.2f} mrad rms; and the head's pose error from the struts and pedicel (sheet 59): 0.8-1.1 cm at F")
json.dump(dict(T_pre=T_PRE, dp=DP, sag_mm=1e3*w0, N_rim=N_rim, slope_rim_deg=np.degrees(slope_rim), q=q, f_wind=[fx1, fy1], slope_err_mrad=[1e3*se0, 1e3*se1], m_ring=m_ring, m_spider=m_spider, n_bars=int(kept.sum()),
               harm_static_mm=(1e3*hw_s).tolist(), harm_wind_axial_mm=(1e3*hw_d).tolist(), harm_wind_radial_mm=(1e3*hr_d).tolist(), tilt_mrad=1e3*tilt, walk_cm=1e2*walk, fig_rms_mrad=1e3*rms_fig, lines=lines), open(os.path.join(OUT, "ring_calyx.json"), "w"), indent=1)
open(os.path.join(OUT, "ring_calyx.txt"), "w").write("\n".join(lines) + "\n")
# ------------------------------------------------------------------ figure
fig = plt.figure(figsize=(15, 5))
ax = fig.add_subplot(1, 3, 1, projection="3d"); ax.set_title(f"ring (Al {1e3*D_R:.0f} x {1e3*T_R:.0f}) and the spider the ground structure kept: {int(kept.sum())} bars, {m_spider:.0f} kg", fontsize=9)
for i, j in frame_el: ax.plot(*zip(X[i], X[j]), color="#5b3a12", lw=2.5)
for e in range(len(M)):
    if A[e] < 0.05*amax: continue
    i, j = M[e]; g_ = 0.8*(1 - A[e]/A.max()); ax.plot(*zip(X[i], X[j]), color=(g_, g_, g_), lw=0.5 + 3*A[e]/A.max())
ax.scatter(X[n_anchor0:n_anchor0 + 6, 0], X[n_anchor0:n_anchor0 + 6, 1], X[n_anchor0:n_anchor0 + 6, 2], color="#0e7490", s=30); ax.view_init(28, -60); ax.set_axis_off()
ax = fig.add_subplot(1, 3, 2); w_img = res1["w"].numpy() - res0["w"].numpy(); w_img[~res1["inside"].numpy()] = np.nan
im = ax.imshow(1e3*w_img.T, origin="lower", extent=[-ext, ext, -ext, ext], cmap="RdBu_r"); plt.colorbar(im, ax=ax, label="mm"); ax.set_title(f"the gust's change of the membrane (2-D FvK), rms slope error {1e3*se0:.2f} -> {1e3*se1:.2f} mrad", fontsize=9)
ax = fig.add_subplot(1, 3, 3); nn = np.arange(7); ax.bar(nn - 0.2, 1e3*hw_d, 0.4, label="axial (mm)"); ax.bar(nn + 0.2, 1e3*hr_d, 0.4, label="radial (mm)"); ax.set_xlabel("harmonic n around the rim"); ax.set_yscale("log"); ax.legend(fontsize=8)
ax.set_title(f"the ring's motion under the gust: n1 tilt {1e2*walk:.2f} cm at F, n>=2 figure {1e2*2*rms_fig*F_DES:.2f} cm", fontsize=9)
fig.suptitle(f"The head as built: Mylar on a ring, pumped to f 4 at {DP:.0f} Pa; the gust at {V_PEAK} m/s through the membrane into the ring and the spider (chapter 7's ground structure) to the six anchors", fontsize=10)
fig.tight_layout(); fig.savefig(os.path.join(OUT, "ring_calyx.png"), dpi=110); print("figure written")

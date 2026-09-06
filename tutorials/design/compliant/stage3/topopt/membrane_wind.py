#!/usr/bin/env python
"""The pumped Mylar membrane under wind, with its pressure under control (the RL policy trims the pump; a local pressure loop can
be faster): the repo's own 1-D axisymmetric FvK solver (tutorials/03_membrane_beamdown_tandoor.py, zoned as hashemi.ini has it)
gives the figure's sensitivity to pressure; the wind's pressure on the bowl is q Cd (uniform) + q 8 c_M x/a (the pitching moment as
a linear gradient); the uniform part changes the focal length (a defocus at the fixed F) and is what pressure control can cancel down
to the gust band above its bandwidth; the gradient part is an n = 1 harmonic that no axisymmetric zone can touch: half of it a tilt of
the figure (pointing, which the head's loop through the struts removes at its own bandwidth) and the rest figure. Von Karman gusts
(Iu 0.25, L 50 m) give the residual as a function of the control corner frequency."""
import os, sys, json, importlib.util, pathlib, numpy as np, torch, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
TUT = pathlib.Path("/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, str(TUT)); import membrane_fvk2d as F2
_spec = importlib.util.spec_from_file_location("tsim", TUT/"03_membrane_beamdown_tandoor.py"); _sim = importlib.util.module_from_spec(_spec); _argv = sys.argv; sys.argv = [sys.argv[0]]; _spec.loader.exec_module(_sim); sys.argv = _argv
CFG = _sim.CFG; A_M, F_DES, T_PRE = 2.10, 4.0, 2000.0; CFG.a = A_M; CFG.T_pre = T_PRE
N_ZONES, ZONE_C = 5, 0.4; Z_EDGES = np.linspace(0.0, A_M, N_ZONES + 1); Z_RC = 0.5*(Z_EDGES[:-1] + Z_EDGES[1:]); Z_SHAPE = 1.0 - ZONE_C*(Z_RC/A_M)**2
RHO_AIR, CD, CM, IU, LT = 1.03, 1.40, 0.15, 0.25, 50.0
lines = []
def say(s=""): print(s); lines.append(s)
def solve(p0, extra=0.0):
    """the zoned membrane at centre pressure p0 with a uniform extra pressure (the wind's) on every zone"""
    m = _sim.solve_membrane(CFG, p0*Z_SHAPE + extra, n=800, zone_edges=Z_EDGES); return float(m["z0"] + m["f_fit"]), m
lo, hi = T_PRE/(4*F_DES), 3.0*T_PRE/(0.25*F_DES)
for _ in range(40):
    mid = 0.5*(lo + hi)
    if solve(mid)[0] > F_DES: lo = mid
    else: hi = mid
P0 = 0.5*(lo + hi); f0, M0 = solve(P0); r = np.asarray(M0["r"]); sp0 = np.asarray(M0["sp"])
say(f"1. the membrane at work (1-D FvK, zoned {N_ZONES} x zone_c {ZONE_C}, T_pre {T_PRE:.0f} N/m): centre pressure {P0:.0f} Pa, f {f0:.3f} m, sag {1e3*float(M0['w0']):.0f} mm, rim tension {float(np.asarray(M0['Nr'])[-1]):.0f} N/m")
# ---- 2. sensitivity of the figure to a uniform extra pressure: focal length and the slope field
dps = np.array([-100.0, -50.0, 50.0, 100.0]); fs = np.array([solve(P0, d)[0] for d in dps]); df_dp = float(np.polyfit(dps, fs, 1)[0])
f1, M1 = solve(P0, 50.0); sp1 = np.asarray(M1["sp"]); dslope = np.abs(sp1) - np.abs(sp0)
wts = r; rms_dslope_50 = float(np.sqrt(np.sum(dslope**2*wts)/np.sum(wts)))
say(f"2. a uniform extra pressure of +50 Pa (a 9 m/s mean wind's q Cd is {0.5*RHO_AIR*81*CD:.0f} Pa): f {f0:.3f} -> {f1:.3f} m (df/dp {1e3*df_dp:.2f} mm/Pa); the surface slope changes {1e3*rms_dslope_50:.2f} mrad rms, which the zones cannot tell from their own law until the pump acts")
def blur_cm(dp): return 1e2*2*rms_dslope_50*abs(dp)/50.0*F_DES          # image spread at F from the slope change: 2 x slope x g (the audit's rule), linear in dp
# ---- 3. the wind's pressure: mean and gust spectrum, and what control leaves
def karman_fraction_above(fc, U):
    f = np.logspace(-3, 1.5, 4000); S = (4*LT/U)/(1 + 70.8*(f*LT/U)**2)**(5/6); tot = np.trapezoid(S, f); return float(np.trapezoid(S[f > fc], f[f > fc])/tot) if fc > 0 else 1.0
say("3. the wind on the bowl: q Cd mean, its gust part (von Karman, Iu 0.25, L 50 m: the pressure fluctuates about rho U sigma_u Cd), and what the pressure control leaves above its corner frequency")
say("   control cases: none (a sealed plenum); the RL policy's step (one action per 20 s: corner 0.008 Hz); a local pressure loop at 0.5 Hz; at 2 Hz")
rows = []
for U in (9.0, 12.0, 15.0):
    q = 0.5*RHO_AIR*U**2; p_mean = q*CD; sig_p = RHO_AIR*U*(IU*U)*CD; p1 = q*8*CM
    for name, fc in (("none", 0.0), ("RL 20 s", 1/(2*np.pi*20.0)), ("loop 0.5 Hz", 0.5), ("loop 2 Hz", 2.0)):
        frac = karman_fraction_above(fc, U); res = sig_p*np.sqrt(frac); mean_left = p_mean if fc == 0 else 0.0
        rows.append(dict(U=U, control=name, p_mean=p_mean, sig_p=sig_p, frac=frac, residual=res, mean_left=mean_left, blur_mean=blur_cm(mean_left), blur_gust=blur_cm(res), p1=p1))
        say(f"   U {U:4.1f} m/s, {name:11s}: mean {p_mean:5.1f} Pa ({'left in: defocus ' + f'{blur_cm(mean_left):.1f} cm' if fc == 0 else 'trimmed by the control'}), gust sigma {sig_p:4.1f} Pa of which {100*frac:3.0f} % above the corner -> {res:4.1f} Pa rms -> defocus blur {blur_cm(res):.1f} cm rms at F")
# ---- 4. the gradient (pitching moment) part: n = 1, linear membrane theory, checked against the 2-D FvK difference
Nr_rim = float(np.asarray(M0["Nr"])[-1]); Tm = float(np.mean(np.asarray(M0["Nr"])))
say("4. the pitching moment as a pressure gradient p1 x/a (p1 = 8 c_M q): on a membrane of tension T the linear response is w1 = p1 r (a^2 - r^2) cos(theta) / (8 T a); its slope has a tilt part (pointing) and a figure part")
rr_, tt_ = np.meshgrid(np.linspace(1e-3, A_M, 300), np.linspace(0, 2*np.pi, 360), indexing="ij"); xx_, yy_ = rr_*np.cos(tt_), rr_*np.sin(tt_)
gx = (A_M**2 - 3*xx_**2 - yy_**2)/(8*Tm*A_M); gy = -2*xx_*yy_/(8*Tm*A_M)                    # grad of w1 per Pa of p1
TILT_PER_PA = float(np.sum(gx*rr_)/np.sum(rr_)); FIG_PER_PA = float(np.sqrt(np.sum((gx**2 + gy**2)*rr_)/np.sum(rr_)))
say(f"   linear theory at the working tension ({Tm:.0f} N/m mean): per Pa of p1 the rim slope amplitude is a/(4 T) = {1e3*A_M/(4*Tm):.3f} mrad/Pa; the slope's MEAN over the disc is {1e3*TILT_PER_PA:.4f} mrad/Pa (zero: w1 vanishes on the rim, so the image's centroid does not move, there is no pointing error to hand the head loop); its rms is {1e3*FIG_PER_PA:.4f} mrad/Pa, all of it blur")
for U in (9.0, 12.0, 15.0):
    q = 0.5*RHO_AIR*U**2; p1 = q*8*CM; fig = p1*FIG_PER_PA
    say(f"   U {U:4.1f}: p1 {p1:5.1f} Pa -> figure {1e3*fig:.2f} mrad rms (blur {1e2*2*fig*F_DES:.1f} cm at F) that no axisymmetric pressure removes; no image walk")
# 2-D check of the gradient response at 15 m/s: the difference of two solves on one mesh
N2 = 161; ext = A_M*1.04; dx = 2*ext/(N2 - 1); phi = F2.ellipse_phi(N2, ext, A_M, A_M); xs = torch.linspace(-ext, ext, N2, dtype=torch.float64); Xg, Yg = torch.meshgrid(xs, xs, indexing="ij"); Rg = torch.sqrt(Xg**2 + Yg**2)
p_pump = torch.full_like(Rg, P0*Z_SHAPE[-1])
for k in range(N_ZONES): p_pump[(Rg >= Z_EDGES[k]) & (Rg < Z_EDGES[k + 1])] = P0*Z_SHAPE[k]
q15 = 0.5*RHO_AIR*225; p1_15 = q15*8*CM
res0 = F2.solve_fvk(phi, dx, p_pump, T_PRE, CFG.E_mem, CFG.t_mem, CFG.nu_mem, iters=(1200, 1600))
res1 = F2.solve_fvk(phi, dx, p_pump + p1_15*Xg/A_M, T_PRE, CFG.E_mem, CFG.t_mem, CFG.nu_mem, iters=(1200, 1600), w_init=res0["w"])
dw = (res1["w"] - res0["w"]).numpy(); inside = res0["inside"].numpy(); Xn, Yn = Xg.numpy(), Yg.numpy()
A = np.stack([Xn[inside], Yn[inside], np.ones(inside.sum())], 1); coef = np.linalg.lstsq(A, dw[inside], rcond=None)[0]; resid = dw[inside] - A@coef
dwx = np.gradient(dw, dx, axis=0); dwy = np.gradient(dw, dx, axis=1); core = inside & (Rg.numpy() < 0.95*A_M)
tilt2d = float(np.hypot(np.mean(dwx[core]), np.mean(dwy[core]))); fig2d = float(np.sqrt(np.mean(dwx[core]**2 + dwy[core]**2)))
say(f"   2-D FvK check at 15 m/s (p1 {p1_15:.0f} Pa, the difference of two solves on one 161 mesh, the inner 95 % of the disc): mean slope {1e3*tilt2d:.2f} mrad (linear 0), rms slope {1e3*fig2d:.2f} mrad vs linear {1e3*p1_15*FIG_PER_PA:.2f}")
say("5. verdict: the pumped membrane's pressure response to wind is the largest term in the image budget; with no control the mean alone defocuses 3-9 cm; the RL policy at one action per 20 s removes the mean and the slow gusts; the gust band above its step needs either a local pressure loop at 0.5-2 Hz or, better, the passive regulator of item 6; the pitching moment's gradient is not a pressure-control problem at all: it is blur, 1.7-4.7 cm at 9-15 m/s, the membrane's floor under wind")
# ---- 6. the passive canceller: a constant-force mechanism holding the plenum's differential pressure (Handbook 12.3.3 constant force; the gasometer)
def volume(m):
    r_ = np.asarray(m["r"]); s_ = np.asarray(m["s"]); return float(np.trapezoid(2*np.pi*r_*np.abs(s_), r_))
V0 = volume(M0); dV_dp = (volume(M1) - V0)/50.0
say("6. gust cancelling as a compliant mechanism: what the film needs is not a pump chasing the wind but a plenum whose differential pressure cannot change. A constant-force element on a rolling diaphragm (Handbook 12.3.3: zero stiffness over its stroke; the gasometer's counterweighted bell is the gravitational original) holds p_plenum - p_face at the pump's setpoint while air flows to and from the film's changing volume; the RL policy sets the setpoint, the mechanism holds it at acoustic speed, no sensor, no electronics")
say(f"   the film's volume under its zoned pressure is {1e3*V0:.0f} L and changes {1e3*dV_dp:.2f} L per Pa (1-D FvK); the regulator must swallow that: 1-sigma gusts of 29 / 52 / 81 Pa at 9 / 12 / 15 m/s are {1e3*dV_dp*29:.0f} / {1e3*dV_dp*52:.0f} / {1e3*dV_dp*81:.0f} L, the 3-sigma peak at 15 m/s {1e3*dV_dp*243:.0f} L")
A_dia, stroke = 1.0, 3*dV_dp*243/1.0
say(f"   a 1.0 m2 rolling diaphragm needs a stroke of +-{1e2*0.5*stroke:.0f} cm for that; its constant force is p0 x A = {P0*A_dia/1e3:.2f} kN: a {P0*A_dia/9.81:.0f} kg bell in the gasometer form, or a constant-force flexure stack in the Handbook's; a 0.15 m duct passes the {1e3*dV_dp*81/0.5:.0f} L/s the 0.5 s gust asks at a few Pa of loss")
say(f"   what it leaves: the regulator's own hysteresis (a rolling diaphragm and a flexure have none; a sliding seal would), and the gradient part of item 4, {1e3*(0.5*RHO_AIR*81*8*CM)*FIG_PER_PA:.2f} mrad of figure at 9 m/s, which is the membrane's floor under wind; the uniform part's {blur_cm(29.2):.1f}-{blur_cm(81.1):.1f} cm rms of defocus blur at 9-15 m/s goes to zero")
json.dump(dict(P0=P0, f0=f0, df_dp=df_dp, V0_L=1e3*V0, dV_dp_L_per_Pa=1e3*dV_dp, tilt_per_Pa=TILT_PER_PA, fig_per_Pa=FIG_PER_PA, rms_dslope_per_50Pa=rms_dslope_50, rows=rows, T_mean=Tm, mean2d_mrad=1e3*tilt2d, rms2d_mrad=1e3*fig2d, lines=lines), open(os.path.join(OUT, "membrane_wind.json"), "w"), indent=1)
open(os.path.join(OUT, "membrane_wind.txt"), "w").write("\n".join(lines) + "\n")
fig = plt.figure(figsize=(15, 4.6))
ax = fig.add_subplot(1, 3, 1); ax.plot(r, np.degrees(np.abs(sp0)), label=f"at work, {P0:.0f} Pa"); ax.plot(r, np.degrees(np.abs(sp1)), label="+50 Pa uniform (wind)"); ax.set_xlabel("r (m)"); ax.set_ylabel("surface slope (deg)"); ax.legend(fontsize=8); ax.set_title(f"1-D zoned FvK: f {f0:.2f} -> {f1:.2f} m for +50 Pa", fontsize=9)
ax = fig.add_subplot(1, 3, 2); fcs = np.logspace(-3, 1, 60)
for U in (9.0, 12.0, 15.0):
    sig_p = RHO_AIR*U*(IU*U)*CD; ax.plot(fcs, [blur_cm(sig_p*np.sqrt(karman_fraction_above(fc, U))) for fc in fcs], label=f"U {U:.0f} m/s")
ax.axhline(4.9, color="k", lw=0.8, ls="--"); ax.text(1.2e-3, 5.2, "half power 4.9 cm", fontsize=8); ax.axvline(1/(2*np.pi*20), color="#d9480f", lw=0.8); ax.text(0.009, ax.get_ylim()[1]*0.6, "RL step 20 s", fontsize=8, color="#d9480f"); ax.axvline(0.5, color="#0e7490", lw=0.8); ax.text(0.55, ax.get_ylim()[1]*0.6, "local loop 0.5 Hz", fontsize=8, color="#0e7490")
ax.set_xscale("log"); ax.set_yscale("log"); ax.set_xlabel("pressure control corner frequency (Hz)"); ax.set_ylabel("defocus blur at F from the gust residual (cm rms)"); ax.legend(fontsize=8); ax.set_title("what the pressure control leaves of the gusts", fontsize=9)
ax = fig.add_subplot(1, 3, 3); im = ax.imshow(1e3*np.where(inside, dw, np.nan).T, origin="lower", extent=[-ext, ext, -ext, ext], cmap="RdBu_r"); plt.colorbar(im, ax=ax, label="mm"); ax.set_title(f"the pitching moment's gradient at 15 m/s (2-D FvK difference): rms slope {1e3*fig2d:.2f} mrad, mean {1e3*tilt2d:.2f}", fontsize=9)
fig.suptitle("The Mylar membrane under wind with its pressure under control: the repo's FvK solvers, hashemi.ini's five zones, von Karman gusts", fontsize=10)
fig.tight_layout(); fig.savefig(os.path.join(OUT, "membrane_wind.png"), dpi=110); print("figure written")

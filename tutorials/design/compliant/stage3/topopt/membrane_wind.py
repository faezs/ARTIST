#!/usr/bin/env python
"""The pumped Mylar membrane under wind, with its pressure under control (the RL policy trims the pump; a local pressure loop can
be faster): the repo's own 1-D axisymmetric FvK solver (tutorials/03_membrane_beamdown_tandoor.py, zoned as hashemi.ini has it)
gives the figure's sensitivity to pressure; the wind's pressure on the bowl is q Cd (uniform) + q 8 c_M x/a (the pitching moment as
a linear gradient); the uniform part changes the focal length (a defocus at the fixed F): with the plenum on a constant-pressure supply it passes one to
one and only pressure control above the gust band can cancel it; with the plenum SEALED between the pump's trims the trapped air is a
constant-volume regulator and the film's differential pressure follows the face pressure automatically, to within the gas
compressibility, with no moving part. The gradient part is an n = 1 harmonic that no axisymmetric pressure can touch and that has zero
mean slope over the disc (w1 vanishes on the rim): it moves no image centroid, it is all figure. Von Karman gusts (Iu 0.25, L 50 m)."""
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
    """the variance a first-order controller of corner fc leaves: weight f^2/(fc^2 + f^2) on the von Karman spectrum (no admittance applied: an upper bound at high f)"""
    f = np.logspace(-6, 4, 20000); S = (4*LT/U)/(1 + 70.8*(f*LT/U)**2)**(5/6); tot = np.trapezoid(S, f); return float(np.trapezoid(S*f**2/(fc**2 + f**2), f)/tot) if fc > 0 else 1.0
say("3. the wind on the bowl: q Cd mean, its gust part (von Karman, Iu 0.25, L 50 m: the pressure fluctuates about rho U sigma_u Cd), and what a pressure controller leaves (first-order, weight f^2/(fc^2 + f^2))")
say("   with the plenum on a constant-pressure supply (a blower holding a gauge pressure): none; the RL policy's step (one action per 20 s: corner 0.008 Hz); a local pressure loop at 0.5 Hz; at 2 Hz")
rows = []
for U in (9.0, 12.0, 15.0):
    q = 0.5*RHO_AIR*U**2; p_mean = q*CD; sig_p = RHO_AIR*U*(IU*U)*CD; p1 = q*8*CM
    for name, fc in (("none", 0.0), ("RL 20 s", 1/(2*np.pi*20.0)), ("loop 0.5 Hz", 0.5), ("loop 2 Hz", 2.0)):
        frac = karman_fraction_above(fc, U); res = sig_p*np.sqrt(frac); mean_left = p_mean if fc == 0 else 0.0
        rows.append(dict(U=U, control=name, p_mean=p_mean, sig_p=sig_p, frac=frac, residual=res, mean_left=mean_left, blur_mean=blur_cm(mean_left), blur_gust=blur_cm(res), p1=p1))
        say(f"   U {U:4.1f} m/s, {name:11s}: mean {p_mean:5.1f} Pa ({'left in: defocus ' + f'{blur_cm(mean_left):.1f} cm' if fc == 0 else 'trimmed by the control'}), gust sigma {sig_p:4.1f} Pa of which {100*frac:3.0f} % of the variance is left -> {res:4.1f} Pa rms -> defocus blur {blur_cm(res):.1f} cm rms at F")
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
cm_ = rr_ < 0.95*A_M; mean_lin = float(np.sum(gx[cm_]*rr_[cm_])/np.sum(rr_[cm_]))*p1_15; rms_lin = float(np.sqrt(np.sum((gx[cm_]**2 + gy[cm_]**2)*rr_[cm_])/np.sum(rr_[cm_])))*p1_15
say(f"   2-D FvK check at 15 m/s (p1 {p1_15:.0f} Pa, the difference of two solves on one 161 mesh, the inner 95 % of the disc, linear theory on the same mask): mean slope {1e3*tilt2d:.2f} mrad vs linear {1e3*mean_lin:.2f} (zero only over the whole disc), rms slope {1e3*fig2d:.2f} mrad vs linear {1e3*rms_lin:.2f}")
say("5. verdict: on a constant-pressure supply the film's response to wind is the largest term in the image budget (the mean alone defocuses 3-9 cm; an RL step of 20 s trims the mean and leaves most of the gust); the remedy is not a faster pump but the plenum of item 6; the pitching moment's gradient is not a pressure problem at all: it is blur, 1.7-4.7 cm at 9-15 m/s, the membrane's floor under wind")
# ---- 6. gust cancelling as a compliant mechanism: the sealed plenum (constant volume), not a constant-pressure regulator
def volume(m):
    r_ = np.asarray(m["r"]); s_ = np.asarray(m["s"]); return float(np.trapezoid(2*np.pi*r_*(abs(s_[-1]) - np.abs(s_)), r_))     # measured from the fixed rim plane: the air the plenum exchanges
V0 = volume(M0); dV_dp = (volume(M1) - V0)/50.0; P_ATM = 82.7e3                                   # Quetta, 1680 m
V_PLENUM = V0                                                                                       # the film over a flat back window at the rim plane; a deeper back cavity only softens the gas spring
gas = P_ATM*dV_dp/V_PLENUM; atten = 1.0/(1.0 + gas)
say("6. gust cancelling as a compliant mechanism. What the film's figure follows is p_plenum - p_face. A regulator on the plenum cannot see the face: a constant-force element on a diaphragm holds p_plenum against ambient, the wind raises p_face, and the differential falls by the full wind pressure; worse, a 140 kg bell is a second-order system with a corner near 0.2 Hz. The compliant canceller is the opposite: SEAL the plenum between the pump's trims. Then the trapped air is a constant-volume regulator: the wind pushes the face, the film cannot change its volume without compressing the air, so the differential pressure rises to meet the wind and the figure holds, to within the gas compressibility, with no moving part, no sensor, no port")
say(f"   the film's volume from the rim plane is {1e3*V0:.0f} L and changes {1e3*dV_dp:.2f} L per Pa of differential (1-D FvK); the trapped air's stiffness is p_atm dV/dp / V = {gas:.1f} times the film's own, so a face pressure change reaches the differential attenuated {gas + 1:.0f} x: {100*atten:.1f} % passes")
for U in (9.0, 12.0, 15.0):
    q = 0.5*RHO_AIR*U**2; p_mean = q*CD; sig_p = RHO_AIR*U*(IU*U)*CD
    say(f"   U {U:4.1f} m/s, sealed plenum: of the {p_mean:.0f} Pa mean {atten*p_mean:.1f} Pa reaches the figure (defocus {blur_cm(atten*p_mean):.2f} cm), of the {sig_p:.0f} Pa rms gust {atten*sig_p:.1f} Pa ({blur_cm(atten*sig_p):.2f} cm rms), the whole spectrum, at acoustic speed")
say(f"   what the seal costs: temperature: 1 K on the trapped air is {P_ATM/293:.0f} Pa of pressure, {P_ATM/293/(1 + gas):.0f} Pa of differential after the film yields ({blur_cm(P_ATM/293/(1 + gas)):.1f} cm), slow, and the RL policy's pump trims it at its 20 s step as it trims leakage; the five zones are five sealed volumes with the same argument each (their volumes and dV/dp scale together); a pump that instead holds a gauge pressure throws this away and is the case of item 3")
say(f"   what stays: the gradient of item 4 (zero volume change, the seal does nothing): {1e3*(0.5*RHO_AIR*81*8*CM)*FIG_PER_PA:.2f} / {1e3*(0.5*RHO_AIR*144*8*CM)*FIG_PER_PA:.2f} / {1e3*(0.5*RHO_AIR*225*8*CM)*FIG_PER_PA:.2f} mrad rms of figure at 9 / 12 / 15 m/s, {1e2*2*(0.5*RHO_AIR*81*8*CM)*FIG_PER_PA*F_DES:.1f} / {1e2*2*(0.5*RHO_AIR*144*8*CM)*FIG_PER_PA*F_DES:.1f} / {1e2*2*(0.5*RHO_AIR*225*8*CM)*FIG_PER_PA*F_DES:.1f} cm at F, the membrane's floor under wind")
json.dump(dict(P0=P0, f0=f0, df_dp=df_dp, V0_L=1e3*V0, dV_dp_L_per_Pa=1e3*dV_dp, gas_stiffness_ratio=gas, sealed_pass=atten, tilt_per_Pa=TILT_PER_PA, fig_per_Pa=FIG_PER_PA, rms_dslope_per_50Pa=rms_dslope_50, rows=rows, T_mean=Tm, mean2d_mrad=1e3*tilt2d, rms2d_mrad=1e3*fig2d, lines=lines), open(os.path.join(OUT, "membrane_wind.json"), "w"), indent=1)
open(os.path.join(OUT, "membrane_wind.txt"), "w").write("\n".join(lines) + "\n")
fig = plt.figure(figsize=(15, 4.6))
ax = fig.add_subplot(1, 3, 1); ax.plot(r, np.degrees(np.abs(sp0)), label=f"at work, {P0:.0f} Pa"); ax.plot(r, np.degrees(np.abs(sp1)), label="+50 Pa uniform (wind)"); ax.set_xlabel("r (m)"); ax.set_ylabel("surface slope (deg)"); ax.legend(fontsize=8); ax.set_title(f"1-D zoned FvK: f {f0:.2f} -> {f1:.2f} m for +50 Pa", fontsize=9)
ax = fig.add_subplot(1, 3, 2); fcs = np.logspace(-3, 1, 60)
for U in (9.0, 12.0, 15.0):
    sig_p = RHO_AIR*U*(IU*U)*CD; ax.plot(fcs, [blur_cm(sig_p*np.sqrt(karman_fraction_above(fc, U))) for fc in fcs], label=f"U {U:.0f} m/s")
for U, c in ((9.0, "C0"), (12.0, "C1"), (15.0, "C2")): ax.axhline(blur_cm(atten*RHO_AIR*U*(IU*U)*CD), color=c, lw=0.8, ls=":")
ax.axhline(4.9, color="k", lw=0.8, ls="--"); ax.text(1.2e-3, 5.2, "half power 4.9 cm", fontsize=8); ax.axvline(1/(2*np.pi*20), color="#d9480f", lw=0.8); ax.text(0.009, 2.0, "RL step 20 s", fontsize=8, color="#d9480f"); ax.axvline(0.5, color="#0e7490", lw=0.8); ax.text(0.55, 2.0, "local loop 0.5 Hz", fontsize=8, color="#0e7490"); ax.text(1.2e-3, 0.9*blur_cm(atten*RHO_AIR*9*(IU*9)*CD), "dotted: sealed plenum, whole spectrum", fontsize=8)
ax.set_xscale("log"); ax.set_yscale("log"); ax.set_xlabel("pressure-control corner frequency (Hz), plenum on a constant-pressure supply"); ax.set_ylabel("defocus blur at F from the gust residual (cm rms)"); ax.legend(fontsize=8); ax.set_title("what a pressure loop leaves of the gusts, and what a sealed plenum leaves", fontsize=9)
ax = fig.add_subplot(1, 3, 3); im = ax.imshow(1e3*np.where(inside, dw, np.nan).T, origin="lower", extent=[-ext, ext, -ext, ext], cmap="RdBu_r"); plt.colorbar(im, ax=ax, label="mm"); ax.set_title(f"the pitching moment's gradient at 15 m/s (2-D FvK difference): rms slope {1e3*fig2d:.2f} mrad, mean {1e3*tilt2d:.2f}", fontsize=9)
fig.suptitle("The Mylar membrane under wind: the repo's FvK solvers, hashemi.ini's five zones, von Karman gusts; a pressure loop against a sealed plenum", fontsize=10)
fig.tight_layout(); fig.savefig(os.path.join(OUT, "membrane_wind.png"), dpi=110); print("figure written")

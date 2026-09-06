#!/usr/bin/env python
"""The head's path over the year under the env's own law (hashemi.ini: beta_dev 0, retro: hub at F - g s, axis along s) and what
the crown must do: hub cloud, branch lengths from the receptacle, rim heights, the pipe and strip shadow (the env's measured table:
33 % at beta 0), and the wind loads the crown must hold. Writes out/sweep.txt and out/sweep.json."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); import physics_hp as H
sys.path.insert(0, HERE); import model as TM
OUT = os.path.join(HERE, "out")
rows = []
for doy in range(5, 366, 10):
    for hour in np.arange(7.0, 17.01, 0.5):
        el, Az, s = TM.sun(doy, hour)
        if el < np.radians(12): continue
        P, n = TM.pose(s, 0.0); xl, yl, zl = TM.head_axes(n)
        Ls = []
        for k in range(TM.N_BR):
            a = 2*np.pi*k/TM.N_BR; A = P - TM.D_BACK*n + TM.R_BACK*(np.cos(a)*xl + np.sin(a)*yl); Ls.append(np.linalg.norm(A - TM.T0))
        rows.append(dict(doy=doy, hour=float(hour), el=float(np.degrees(el)), az=float(np.degrees(Az)), hub=(P - [0, 0, TM.Z_DECK]).round(3).tolist(), el_n=float(np.degrees(np.arcsin(n[2]))),
                         L_min=min(Ls), L_max=max(Ls), rim_lo=float(P[2] - TM.Z_DECK - TM.A_M*np.sqrt(1 - n[2]**2)), rim_hi=float(P[2] - TM.Z_DECK + TM.A_M*np.sqrt(1 - n[2]**2))))
hub = np.array([r["hub"] for r in rows]); Lmax = np.array([r["L_max"] for r in rows]); Lmin = np.array([r["L_min"] for r in rows])
# wind on the head: drag on 13.9 m2 with Cd 1.3 at rho 1.03; the crown must hold the head's centre of curvature to 5 cm (half power at 0.7 deg = 4.9 cm at F)
q9, q12, q25 = [0.5*1.03*v*v for v in (9, 12, 25)]; A_D = np.pi*TM.A_M**2
lines = [f"the head on the env's retro orbit (beta_dev 0): hub over the deck x {hub[:,0].min():.2f}..{hub[:,0].max():.2f} m (north of the pipe), y +-{np.abs(hub[:,1]).max():.2f} m, z {hub[:,2].min():.2f}..{hub[:,2].max():.2f} m; a box {np.ptp(hub[:,0]):.1f} x {np.ptp(hub[:,1]):.1f} x {np.ptp(hub[:,2]):.1f} m",
         f"head axis elevation {min(r['el_n'] for r in rows):.0f}-{max(r['el_n'] for r in rows):.0f} deg (= the sun's); rim from {min(r['rim_lo'] for r in rows):.2f} to {max(r['rim_hi'] for r in rows):.2f} m over the deck (beta_cap_z 7.6 would cap it at 2.6 m: the ini's beta_dev 0 makes the cap inert)",
         f"branches from the receptacle ({TM.X_STEM} m north, {TM.H_STEM} m up) to the back ring r {TM.R_BACK} m: straight distance {Lmin.min():.2f} to {Lmax.max():.2f} m over the year; at noon {Lmax[[i for i, r in enumerate(rows) if r['hour'] == 12.0]].max():.2f} m at most, at 8 and 16 h {Lmax[[i for i, r in enumerate(rows) if r['hour'] in (8.0, 16.0)]].max():.2f} m",
         f"pipe + strip shadow at retro on this pass's own model: 24.3 % mean over the year, 14.3-24.7 % (the env's 33 % table is the fold machine's, audit F6); beta_dev 36 takes it to about 1.6 %",
         f"wind on the head: drag {q9*A_D*1.3/1e3:.2f} / {q12*A_D*1.3/1e3:.2f} / {q25*A_D*1.3/1e3:.1f} kN at 9 / 12 / 25 m/s (Cd 1.3, rho 1.03); to keep half power the crown must hold the head's centre of curvature to 5 cm = a crown stiffness of {q9*A_D*1.3/0.05/1e3:.0f} kN/m at 9 m/s, {q12*A_D*1.3/0.05/1e3:.0f} kN/m at 12 m/s, before gusts; a 5 m cantilever needs EI {q9*A_D*1.3*25*(5/3 + 4.0)/0.05/1e3:.0f} kN m2 for that, translation plus tip rotation times f (audit F8; a 150 x 5 mm steel tube is 1199 kN m2); an inflated hose r 0.25 at 40 kPa wrinkles at 1.0 kN m against a root moment of 6.7 kN m at the worst pose (audit F10)"]
for l in lines: print(l)
open(os.path.join(OUT, "sweep.txt"), "w").write("\n".join(lines) + "\n"); json.dump(rows, open(os.path.join(OUT, "sweep.json"), "w"))

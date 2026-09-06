#!/usr/bin/env python
"""Chapter 6 (Hopkins, FACT) applied step by step to the flower's twelve strut joints (Fig. 6.8, the flexure-based ball joint):
Step 1  the desired DOFs: three rotations about the joint centre C (the strut's end on the ring or the calyx);
Step 2  the freedom space that contains them: the sphere of intersecting rotation lines (3-DOF column, Type 3, Fig. 6.8b);
        its complementary constraint space, by screw reciprocity, is every pure-force line through C;
Step 3  three independent constraint lines from that space, not coplanar: a tripod of wires meeting at C (Fig. 6.8c);
Step 4  redundancy is not needed; instead the kinematic equivalence of Fig. 6.7a replaces each wire by a stacked pair of
        orthogonal blades whose planes intersect on the wire's line (Fig. 6.8d) for buckling strength.
Every step is checked in screw algebra with fact/fact_core.py (constraint_space, reciprocal products, rank). What FACT
does not do (the chapter says so, p. 82) is stiffness and strength: the sizing of the blades for the flower's loads follows
outside the method and is labelled as such."""
import os, sys, json, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "..", "fact")); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
from fact_core import rot_twist, trans_twist, wire, blade, recip, constraint_space, describe
DELTA = np.block([[np.zeros((3, 3)), np.eye(3)], [np.eye(3), np.zeros((3, 3))]])
def freedoms_of(wrenches):
    C = np.atleast_2d(np.array(wrenches, float)); u, s, vt = np.linalg.svd(C@DELTA); r = int((s > 1e-9).sum()); return vt[r:], r
def series(twist_sets):
    F = np.vstack(twist_sets); u, s, vt = np.linalg.svd(F); r = int((s > 1e-9).sum()); return vt[:r]
lines = []
def say(s=""): print(s); lines.append(s)
C = np.array([0.0, 0.0, 0.0]); zhat = np.array([0, 0, 1.0])                       # the joint centre; the strut leaves along +z
# ---- step 1
T_des = [rot_twist(C, [1, 0, 0]), rot_twist(C, [0, 1, 0]), rot_twist(C, [0, 0, 1])]
say("Step 1  desired DOFs: three rotations about C (a ball joint at the strut's end).")
# ---- step 2
CS = constraint_space(T_des); say(f"Step 2  freedom space: the sphere of rotation lines through C (3-DOF Type 3). Constraint space by reciprocity: {CS.shape[1]} dimensions.")
tests = {"a wire through C along z": wire(C, [0, 0, 1]), "a wire through C at 35 deg": wire(C, [np.sin(0.61), 0, np.cos(0.61)]), "a wire through C along x": wire(C, [1, 0, 0]),
         "a wire missing C by 0.05 m": wire(C + [0.05, 0, 0], [0, 0, 1]), "a wire missing C by 1 mm": wire(C + [0.001, 0, 0], [0, 1, 0])}
for k, w in tests.items():
    res = max(abs(recip(t, w)) for t in T_des); say(f"        {k:30s}: max reciprocal product with the three rotations {res:.4f} -> {'in the constraint space' if res < 1e-9 else 'NOT in it (it would resist a rotation)'}")
# ---- step 3
alpha = np.radians(35.0); W3 = [wire(C, [np.sin(alpha)*np.cos(p), np.sin(alpha)*np.sin(p), np.cos(alpha)]) for p in np.radians([0, 120, 240])]
free, rank = freedoms_of(W3); say(f"Step 3  tripod of three wires through C at 35 deg to the strut axis, 120 deg apart: rank {rank}, DOF {6 - rank}: {describe(free)}")
W2 = W3[:2]; f2, r2 = freedoms_of(W2); say(f"        (two wires only: rank {r2}, DOF {6 - r2}: {describe(f2)} -> a fourth freedom the chapter warns of, p. 85)")
Wcop = [wire(C, [np.cos(p), np.sin(p), 0]) for p in np.radians([0, 60, 120])]; fc, rc = freedoms_of(Wcop); say(f"        (three coplanar wires through C: rank {rc}, DOF {6 - rc}: {describe(fc)} -> dependent, as the chapter says)")
# ---- step 4: the wire -> stacked-blade equivalence of Fig. 6.7a, checked in series
def stacked_blades(P, d, off=0.03):
    d = np.asarray(d, float)/np.linalg.norm(d); a = np.cross(d, [0, 0, 1.0]) if abs(d[2]) < 0.9 else np.cross(d, [1.0, 0, 0]); a /= np.linalg.norm(a); b = np.cross(d, a)
    B1 = blade(P + 0.5*off*d, a, d); B2 = blade(P + 1.5*off*d, b, d)      # two blades along the leg, planes through the leg's line, normals orthogonal
    f1, _ = freedoms_of(B1); f2_, _ = freedoms_of(B2); return series([f1, f2_]), B1, B2
leg_free, B1, B2 = stacked_blades(C, [np.sin(alpha), 0, np.cos(alpha)]); wire_free, _ = freedoms_of([W3[0]])
same = np.linalg.matrix_rank(np.vstack([leg_free, wire_free]), tol=1e-9) == len(wire_free)
say(f"Step 4  one leg as two orthogonal blades in series: DOF {len(leg_free)}: {describe(leg_free)}; a wire: DOF {len(wire_free)}: {describe(wire_free)}; identical freedom spaces: {same}")
# the whole joint with three stacked-blade legs: each leg constrains exactly its wire line, so the joint constrains the tripod's three lines
joint_constraints = []
for p in np.radians([0, 120, 240]):
    d = [np.sin(alpha)*np.cos(p), np.sin(alpha)*np.sin(p), np.cos(alpha)]; lf, _, _ = stacked_blades(C, d)
    cs = constraint_space(lf); joint_constraints.append(cs[:, 0]/np.linalg.norm(cs[:, 0]))
jf, jr = freedoms_of(joint_constraints); say(f"        the three-leg joint: rank {jr}, DOF {6 - jr}: {describe(jf)}")
# ---- outside FACT: sizing for the flower (labelled)
say(""); say("Outside FACT (the chapter excludes stiffness and strength): sizing for the flower's struts.")
theta = np.radians(1.6); E_ti, sig_ti, EA_L = 110e9, 600e6, 200e9*1.33e-3/1.45
P_run, P_surv = 3.5e3, 14.0e3                        # per strut: the runs' maximum (yaw hunting at 12 m/s), and the survival gust (40 m/s: 60 kN drag and 16 kN m on six struts)
say(f"  motion at each ball: the six leg lengths are constant over the day (both rings are defined from the head pose), so the balls turn only with the loop's +-4 cm stroke on 1.45 m: +-{np.degrees(theta):.1f} deg; the dither adds 0.08 deg.")
Pleg, Pleg_s = P_run/(3*np.cos(alpha)), P_surv/(3*np.cos(alpha)); say(f"  load per leg: {Pleg:.0f} N in the runs' worst case, {Pleg_s:.0f} N at the 40 m/s survival gust (3.5 and 14 kN per strut, three legs at 35 deg).")
for dw in (4e-3, 6e-3, 8e-3):
    Lw = 0.06; Pcr = np.pi**2*E_ti*np.pi*dw**4/64/Lw**2; sig_w = 1.5*E_ti*dw*theta/(2*Lw); k_w = E_ti*np.pi*dw**2/4/Lw
    say(f"  a Ti wire leg d {1e3*dw:.0f} mm, 60 mm long: Euler load {Pcr/1e3:.1f} kN -> SF {Pcr/Pleg_s:.1f} at survival ({'fails' if Pcr < 3*Pleg_s else 'holds at SF 3'}); bending {sig_w/1e6:.0f} MPa at 1.6 deg; axial {k_w/1e6:.0f} MN/m per wire")
say(f"  the wire tripod holds at d 6-8 mm but is soft: three 6 mm wires give the joint {3*np.cos(alpha)**2*E_ti*np.pi*6e-3**2/4/0.06/1e6:.0f} MN/m against the strut's own EA/L {EA_L/1e6:.0f} MN/m, and two such joints would halve the leg's stiffness and the crown's 16 Hz.")
say("  step 4's reason, stiffness and load capacity, is why each wire becomes two stacked blades (Fig. 6.8d): sizing them for SF 3 on buckling at survival, bending under 0.5 sigma_y at +-1.6 deg, and a joint at least twice as stiff as the strut:")
best = None
for t in (1.0e-3, 1.5e-3, 2.0e-3, 2.5e-3, 3.0e-3):
    for w in (20e-3, 30e-3, 40e-3, 50e-3, 60e-3):
        for Lb in (15e-3, 20e-3, 30e-3, 40e-3):
            sig = 1.5*E_ti*t*theta/(2*Lb)                                            # a fixed-guided blade turned theta: 1.5 x the pure-bending E t theta / 2 L
            Pcr = 4*np.pi**2*E_ti*w*t**3/12/Lb**2                                      # fixed-fixed Euler about the thin axis
            k_ax = E_ti*w*t/Lb; k_j = 3*np.cos(alpha)**2*(k_ax/2)
            ok = sig < 0.5*sig_ti and Pcr > 3*Pleg_s and k_j >= 2*EA_L
            if ok and (best is None or (w*t*Lb) < best[0]): best = (w*t*Lb, t, w, Lb, sig, Pcr, k_ax, k_j)
_, t, w, Lb, sig, Pcr, k_ax, k_joint = best
say(f"  chosen blade (Ti 6Al-4V): t {1e3*t:.1f} mm, w {1e3*w:.0f} mm, free length {1e3*Lb:.0f} mm: bending {sig/1e6:.0f} MPa at +-1.6 deg, Euler load about the thin axis {Pcr/1e3:.1f} kN (SF {Pcr/Pleg_s:.1f} at survival), axial stiffness per blade {k_ax/1e6:.0f} MN/m")
say(f"  the joint: {k_joint/1e6:.0f} MN/m axially (three legs of two blades in series at 35 deg) = {k_joint/EA_L:.1f} x the strut's EA/L; two joints add {100*2*EA_L/k_joint:.0f} % to a leg's compliance, the crown's first mode falls by {100*(1 - 1/np.sqrt(1 + 2*EA_L/k_joint)):.0f} %")
say(f"  image walk from that compliance at 3.5 kN: {1e3*2*P_run/k_joint*2*4.0/1.45:.2f} mm at F per leg; twelve joints, 72 blades, no bearings, no backlash, no lubrication.")
json.dump(dict(theta_deg=float(np.degrees(theta)), P_leg=Pleg, P_leg_survival=Pleg_s, blade=dict(t_mm=1e3*t, w_mm=1e3*w, L_mm=1e3*Lb, sigma_MPa=sig/1e6, P_cr=Pcr), k_joint_MN_m=k_joint/1e6, lines=lines), open(os.path.join(OUT, "fact_ball.json"), "w"), indent=1)
open(os.path.join(OUT, "fact_ball.txt"), "w").write("\n".join(lines) + "\n")
# ---- figure: the four steps as pictures
fig = plt.figure(figsize=(14, 4.2))
def seg(ax, p, q, **kw): ax.plot([p[0], q[0]], [p[1], q[1]], [p[2], q[2]], **kw)
ax = fig.add_subplot(1, 4, 1, projection="3d"); ax.set_title("1  desired DOFs: 3 rotations about C", fontsize=9)
for a in np.eye(3): seg(ax, C - 0.08*a, C + 0.08*a, color="#0e7490", lw=2)
seg(ax, C, C + 0.12*zhat, color="#7c4a1e", lw=6); ax.scatter(*C, color="k", s=30)
ax = fig.add_subplot(1, 4, 2, projection="3d"); ax.set_title("2  constraint space: every line through C", fontsize=9)
for p in np.linspace(0, np.pi, 8):
    for q in np.linspace(0, np.pi, 4):
        d = np.array([np.sin(q)*np.cos(p), np.sin(q)*np.sin(p), np.cos(q)]); seg(ax, C - 0.1*d, C + 0.1*d, color="#9aa5b1", lw=0.6)
ax.scatter(*C, color="k", s=30)
ax = fig.add_subplot(1, 4, 3, projection="3d"); ax.set_title("3  three independent lines: the tripod of wires", fontsize=9)
for p in np.radians([0, 120, 240]):
    d = np.array([np.sin(alpha)*np.cos(p), np.sin(alpha)*np.sin(p), np.cos(alpha)]); seg(ax, C, C + 0.1*d, color="#d9480f", lw=2)
seg(ax, C, C - 0.12*zhat, color="#7c4a1e", lw=6); ax.scatter(*C, color="k", s=30)
ax = fig.add_subplot(1, 4, 4, projection="3d"); ax.set_title("4  each wire = two orthogonal blades in series (Fig. 6.7a)", fontsize=9)
for p in np.radians([0, 120, 240]):
    d = np.array([np.sin(alpha)*np.cos(p), np.sin(alpha)*np.sin(p), np.cos(alpha)]); a = np.cross(d, [0, 0, 1.0]); a /= np.linalg.norm(a); b = np.cross(d, a)
    for s0, n_ in ((0.01, a), (0.055, b)):
        c0 = C + s0*d; u_ = np.cross(n_, d); pts = np.array([c0 + 0.02*d*sx + 0.012*u_*sy for sx, sy in ((0, -1), (1, -1), (1, 1), (0, 1), (0, -1))])
        ax.plot(pts[:, 0], pts[:, 1], pts[:, 2], color="#d9480f", lw=1.5)
seg(ax, C, C - 0.12*zhat, color="#7c4a1e", lw=6); ax.scatter(*C, color="k", s=30)
for ax in fig.axes:
    ax.set_xlim(-0.12, 0.12); ax.set_ylim(-0.12, 0.12); ax.set_zlim(-0.12, 0.12); ax.set_axis_off(); ax.view_init(22, -50)
fig.suptitle("Chapter 6 (Hopkins, FACT) step by step on the flower's strut joints: a flexure ball at each of the twelve strut ends", fontsize=11)
fig.tight_layout(); fig.savefig(os.path.join(OUT, "fact_ball.png"), dpi=110); print("figure written")

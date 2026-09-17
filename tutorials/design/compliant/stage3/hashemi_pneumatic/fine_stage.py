#!/usr/bin/env python
"""The fine stage: an exactly constrained flexure between the back frame (coarse stage) and the dish.

Serial synthesis (Hopkins 2010 ch. 2): intermediate freedom space 1 = the sphere of rotations about F (bridle +
stem, coarse, whole sky, milliradians); intermediate freedom space 2 = 3 DOF Type 1 about the vertex: two
rotations in the dish's back plane and the translation along the axis (tip, tilt, focus). 3 + 3 = 6 = the
system's DOFs: not underconstrained. Constraint space of 3 DOF Type 1: every line in the plane plus a torque
normal to it (thesis Fig. 3.38). Constraints: three tangential rods in the back plane, one line each, exact
(m = 3), athermal (radial growth of the dish bends them). Actuators: three sealed water columns normal to the
plane at 120 deg, displacement actuators (§4.4.2) whose lines lie in the actuation space of this type, the box
of lines normal to the plane (thesis Fig. 4.3). Locked, they add three constraints: rank 6, DOF 0, no sliding
fit anywhere.
"""
import os, sys, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, HERE)
from fact_core import rot_twist, trans_twist, wire, describe
from dcm_core import interface_freedom
OUT = os.path.join(HERE, "out"); LOG = []
def log(s=""): print(s); LOG.append(s)

R_ROD, L_ROD, D_ROD = 1.40, 0.90, 0.012        # rod station radius, free length, diameter (m); 17-7PH CH900, sigma_y 1500 MPa
E_S, SY = 200e9, 1500e6
R_ACT, A_ACT, L_COL = 1.60, 0.010, 0.25        # water-column actuators: radius, piston area (m2), column length (m)
B_EFF = 0.5e9                                  # effective bulk modulus with hose compliance and a little air
THETA_MAX = 0.020                              # fine range +-20 mrad
M_DISH, D = 45.0, 4.2
Q9, Q25 = 41.7, 322.0; AREA = np.pi*(D/2)**2; CD = 1.3

# ---- FACT: constraints in the back plane z = 0, vertex at the origin, dish axis +z
rods = [wire([R_ROD*np.cos(a), R_ROD*np.sin(a), 0.0], [-np.sin(a), np.cos(a), 0.0]) for a in np.radians([90, 210, 330])]
cols = [wire([R_ACT*np.cos(a), R_ACT*np.sin(a), 0.0], [0, 0, 1.0]) for a in np.radians([30, 150, 270])]
left, r = interface_freedom(rods); log(f"three tangential rods: rank {r}, DOF {6 - r}: {describe(left)}")
left2, r2 = interface_freedom(rods + cols); log(f"rods + three locked water columns: rank {r2}, DOF {6 - r2}: exact constraint, no sliding fit")
Tfree = [rot_twist([0, 0, 0], [1, 0, 0]), rot_twist([0, 0, 0], [0, 1, 0]), trans_twist([0, 0, 1])]
rec = max(abs(w[:3]@t[3:] + w[3:]@t[:3]) for w in rods for t in Tfree); log(f"reciprocal products rods x (tip, tilt, piston): {rec:.1e}")
recA = np.array([[w[:3]@t[3:] + w[3:]@t[:3] for t in Tfree] for w in cols]); log(f"water columns x (tip, tilt, piston) = their moment arms and 1: {np.round(recA, 2).tolist()} -> they actuate all three")

# ---- TWSM of the rods + columns (Hopkins eq. 4.8): actuation wrenches for tip and tilt
def line_k(w, k):
    return k*np.outer(w, w)
k_rod = E_S*np.pi*(D_ROD/2)**2/L_ROD                       # axial
k_col = B_EFF*A_ACT/L_COL                                   # water column, sealed
K = sum(line_k(w, k_rod) for w in rods) + sum(line_k(w, k_col) for w in cols)
for name, T in (("tip about x", Tfree[0]), ("tilt about y", Tfree[1]), ("focus along z", Tfree[2])):
    Tw = np.concatenate([T[3:], T[:3]])                    # pairing [dx; dtheta] for K built from [f; tau]
    W = K @ Tw; f, tau = W[:3], W[3:]
    if np.linalg.norm(f) > 1e-9:
        q = f@tau/(f@f); rloc = np.cross(f, tau - q*f)/(f@f)
        log(f"actuation wrench for unit {name}: force {np.linalg.norm(f)/1e6:.2f} MN/rad along {np.round(f/np.linalg.norm(f), 2)} through {np.round(rloc, 2)} m, q {q:.3f}: normal to the plane, in the box of Fig. 4.3")
log(f"rotational stiffness of the locked stage about the vertex: {1.5*k_col*R_ACT**2/1e6:.0f} MN m/rad (three columns k {k_col/1e6:.0f} MN/m at r {R_ACT} m); focus stiffness {3*k_col/1e6:.0f} MN/m")

# ---- range, stress, buckling
delta = THETA_MAX*R_ROD                                     # out-of-plane offset of a rod's dish end at full tilt
sig = 3*E_S*D_ROD*delta/L_ROD**2
Pcr = np.pi**2*E_S*np.pi*D_ROD**4/64/(0.7*L_ROD)**2
F_in = M_DISH*9.81 + Q9*CD*AREA*0.3                         # in-plane load shared by 3 rods at 60 deg (weight at tilt + a third of the drag)
log(f"\nrange +-{THETA_MAX*1e3:.0f} mrad: rod end offset {delta*1e3:.0f} mm -> S-bend stress {sig/1e6:.0f} MPa = {sig/SY:.2f} sigma_y (R3 <= 0.30); in-plane load per rod {F_in/3/np.cos(np.radians(60)):.0f} N vs Euler {Pcr:.0f} N -> SF {Pcr/(F_in/3/np.cos(np.radians(60))):.1f}")
stroke = THETA_MAX*R_ACT*1e3; log(f"column stroke at full tilt +-{stroke:.0f} mm; a rolling-diaphragm or edge-welded-bellows cylinder: no seal friction, no stiction")
# ---- metering and holding
dV_mL = A_ACT*1e6*1e-3                                      # mL per 0.001 m of stroke... 1 mL -> stroke A
stroke_per_mL = 1e-6/A_ACT
log(f"1 mL of water moves a column {stroke_per_mL*1e3:.2f} mm = {stroke_per_mL/R_ACT*1e6:.0f} urad of tilt; a 10 mL/s pump slews {10*stroke_per_mL/R_ACT*1e3:.2f} mrad/s; a closed valve holds with no power")
# ---- wind on the fine stage: torque about the vertex from the drag's asymmetry (pressure centre 0.1 D off the vertex)
for q, lab in ((Q9, "9 m/s"), (Q25, "25 m/s")):
    Fw = q*CD*AREA; tau = Fw*0.1*D; Krot = 1.5*k_col*R_ACT**2
    log(f"{lab}: drag {Fw:.0f} N, torque about the vertex {tau:.0f} N m -> {tau/Krot*1e6:.0f} urad on the locked columns; each column carries up to {Fw/3:.0f} N normal load ({Fw/3/A_ACT/1e5:.1f} bar)")
# ---- thermal
dT = 40.0; alpha_w = 2.1e-4; V_col = A_ACT*L_COL
log(f"thermal: dish (Al) vs back frame (steel) radial growth {(23e-6 - 12e-6)*dT*R_ROD*1e3:.2f} mm at r {R_ROD} m, taken by rod bending at {3*E_S*D_ROD*(23e-6 - 12e-6)*dT*R_ROD/L_ROD**2/1e6:.0f} MPa; water in a column expands {alpha_w*dT*V_col*1e6:.0f} mL over +40 K = {alpha_w*dT*L_COL/R_ACT*1e3:.2f} mrad of drift for the loop to take out")
# ---- the coarse-fine budget
log("\nbudget: coarse stage (bridle + stem r 0.8, no tendons) 3.9 mrad at 9 m/s, within the +-20 mrad fine range; the fine loop on the beam centroid corrects it at a few Hz;")
log("residual = coarse error / loop rejection + fine-stage compliance (3 urad) + sensor: ~0.2-0.4 mrad at 9 m/s, 3 urad quasi-static. Above ~18 m/s the coarse error exceeds the fine range: survival mode, no cooking.")
log("the piston DOF trims the vertex onto the true focal circle R/2 = 4.10 m (the env orbits at 4.0): +-32 mm of the 100 mm.")
open(os.path.join(OUT, "fine_stage_checks.txt"), "w").write("\n".join(LOG))

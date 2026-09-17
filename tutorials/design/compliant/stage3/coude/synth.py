#!/usr/bin/env python
"""Fourth pass: the mount behind the dish, checked with the FACT algebra. The elevation pivot is a two-stage HOLLOW
cartwheel: radial blades in planes through the neck axis around a 0.6 m bore, so the beam passes along the axis.
Loads: the side-mounted head's cantilever about the stalk, the crosswind, the elevation torque."""
import os, sys, numpy as np, json
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic"))
from fact_core import rot_twist, blade, describe
from dcm_core import interface_freedom
import physics_hp as H
O = json.load(open(os.path.join(HERE, "out", "optics.json")))
E_S, SY = 200e9, 1500e6; W_B, T_B, L_B = 0.250, 0.0010, 0.120; R_IN, R_OUT = 0.33, 0.45; N_BL = 6
LOG = []; log = lambda s="": (print(s), LOG.append(s))
axis = np.array([0, 1.0, 0])                                       # the neck axis, along e
def stage(y0):
    C = []
    for k in range(N_BL):
        a = 2*np.pi*k/N_BL; rad = np.array([np.cos(a), 0, np.sin(a)])       # radial direction in the plane normal to the axis
        p = 0.5*(R_IN + R_OUT)*rad + y0*axis; nrm = np.cross(rad, axis)      # blade plane contains the axis and the radial line
        C += blade(p, nrm, rad)                                               # long direction radial (the bending length)
    return C
CA, CB = stage(+0.15), stage(-0.15)
for name, C in (("stage A", CA), ("stage B", CB)):
    left, r = interface_freedom(C); log(f"hollow cartwheel {name}: {len(C)} lines from {N_BL} radial blades around a bore of r {R_IN} m -> rank {r}, DOF {6 - r}: {describe(left)}")
T = rot_twist([0, 0, 0], axis); log(f"reciprocal product of every blade line with the rotation about the neck axis: {max(abs(w[:3]@T[3:] + w[3:]@T[:3]) for w in CA + CB):.1e}; the axis line itself is empty: the beam goes through")
th = 0.25*SY*2*L_B/(E_S*T_B); need = np.radians(71/2)/2
log(f"range: +-{np.degrees(th):.1f} deg per stage at 0.25 sigma_y; +-{np.degrees(need):.1f} needed per stage -> {E_S*T_B*need/(2*L_B)/SY:.2f} sigma_y at el 12 and 83")
I_b = W_B*T_B**3/12; Pcr = 4*np.pi**2*E_S*I_b/L_B**2; k_bl = 2*E_S*I_b/L_B
log(f"spring: {N_BL*k_bl:.0f} N m/rad per stage, {N_BL*k_bl/2:.0f} for the two in series; blade buckling (fixed-fixed, in plane) {Pcr/1e3:.1f} kN")
# loads: head (dish 60 + style and secondary 25 + frame and fine stage 40 + M3 and neck 30 = 155 kg) at OFF from the stalk; crosswind on 13.9 m2
m_head, OFF = 155.0, O["OFF"]; D9, D25 = H.Q9*1.3*H.AREA, H.Q25*1.3*H.AREA
for lab, D in (("9 m/s", D9), ("25 m/s", D25)):
    M_v = m_head*9.81*OFF + D*OFF                 # about the vertical through the pivot: weight (balanced by the yoke's counterweight in service, taken here unbalanced) + crosswind at the head
    F_ring = M_v/(2*R_OUT); per = F_ring/2           # two blades in the loaded plane per stage
    log(f"{lab}: moment about the vertical through the pivot {M_v/1e3:.1f} kN m (head weight at {OFF} m + drag {D:.0f} N) -> {F_ring/1e3:.1f} kN at the rings, {per/1e3:.2f} kN per blade in plane: SF {Pcr/per:.1f}")
tau9, tau25 = D9*(O["NECK"] + 0.3), D25*(O["NECK"] + 0.3)
# the jack's moment arm over the range: anchor 1.2 m below and 0.3 m up-sun of the neck (in the yoke), crank 0.8 m at psi from -n toward the dish axis
# the jack: anchor on the yoke 0.8 m from the neck along the axis, 0.6 m down-sun and 1.2 m below it; crank 0.8 m at 20 deg from -n toward the dish
def jack_geom(el_deg, psi_deg=20.0, ja=(-0.6, -1.2), off=0.8):
    el = np.radians(el_deg); ck = 0.8*np.array([np.cos(el - np.pi/2 + np.radians(psi_deg)), np.sin(el - np.pi/2 + np.radians(psi_deg))]); ja = np.array(ja)
    d = ck - ja; Lp = np.linalg.norm(d); L = np.hypot(Lp, off); d /= Lp
    return L, abs(ck[0]*d[1] - ck[1]*d[0])*Lp/L                 # length, and the arm about the neck axis times the planar share of the force
Ls = [jack_geom(el)[0] for el in range(12, 84)]; arm_min = min(jack_geom(el)[1] for el in range(12, 84))
log(f"elevation torque about the neck (balanced head): wind {tau9/1e3:.1f} kN m at 9 m/s, {tau25/1e3:.1f} at 25; screw jack from the yoke to the 0.8 m crank: length {min(Ls):.2f}-{max(Ls):.2f} m over el 12-83 (stroke {max(Ls) - min(Ls):.2f} m, a single-stage screw fits), arm at least {arm_min:.2f} m -> {tau9/arm_min/1e3:.1f} / {tau25/arm_min/1e3:.1f} kN")
m_cw1 = (60*1.8 + 25*3.4 + 40*1.2)/1.6                                          # balances the head about the neck
log(f"counterweights: {m_cw1:.0f} kg of water 1.6 m behind the neck on the head (about the elevation axis); {(m_head + m_cw1)*OFF/1.6:.0f} kg 1.6 m beyond the stalk on the yoke (about the azimuth axis: the head and its own counterweight both sit {OFF} m from the stalk); both in the dish's shadow")
log("what is compliant: the hollow cartwheel pivot (exact 1R, hollow), the fine stage (exact 3 DOF Type 1), the struts' flexure necks. Not: the slew ring, the stalk, the jack, M3 and M4's mounts.")
open(os.path.join(HERE, "out", "synth.txt"), "w").write("\n".join(LOG))

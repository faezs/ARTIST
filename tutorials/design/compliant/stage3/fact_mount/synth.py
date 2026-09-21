#!/usr/bin/env python
"""FACT synthesis of the dish mount (Hopkins 2010, Fig. 2.7), step by step, with the checks printed.

Tracking is two rotations about the fixed focus F: azimuth about the vertical F-F2 axis, elevation about the
horizontal through F. Azimuth (220 deg) is a ring bearing on the deck, Hashemi's ring rail, carrying a fork.
Elevation (71 deg) is a pair of two-stage cross-blade flexural pivots ON the elevation axis but OUTSIDE the
aperture: the constraint space of a rotation is the same set of lines everywhere along its axis, and the axis
through F leaves the dish's shadow at |y| = 2.1 m, so the blades sit at |y| = 3.25 m where they shade nothing and
where the 6.5 m between them turns the wind's moment about F into a pair of forces. The dish hangs in a cradle
of two side arms (outside the rim) and a back frame; water at the arms' up-sun ends balances it about the axis.
Fine pointing is a third stage, 3 DOF Type 1 about the vertex: Hopkins's tangential-blade diaphragm (Fig. 4.3),
actuated on its normals through flexure struts by water columns.
"""
import os, sys, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, HERE)
from fact_core import rot_twist, trans_twist, wire, blade, describe, constraint_space
from dcm_core import interface_freedom
import physics_hp as H
import geometry as GM
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True); LOG = []
def log(s=""): print(s); LOG.append(s)

F = H.F; G = H.G_ORBIT; A = H.A_DISH
E_S, SY = 200e9, 1500e6                  # 17-7PH CH900
D9, D25 = H.Q9*1.3*H.AREA, H.Q25*1.3*H.AREA
# ------------------------------------------------------------------ steps 1-5
log("STEP 1  desired motions: rotation about the vertical through F (azimuth, 220 deg), rotation about the horizontal through F (elevation, 71 deg, el 12-83),")
log("        and fine tip/tilt/focus of the dish about its vertex (+-20 mrad, +-30 mm). Rotation about F only, F fixed on the tube: Hashemi figs 3-5.")
log("STEP 2  freedom spaces: azimuth and elevation are each 1 DOF Type 1 (a rotation line, thesis 3.2.1); at an instant the pair is 2 DOF Type 1 (a disk of")
log("        intersecting rotation lines through F, 3.3.1). The fine motion is 3 DOF Type 1 about the vertex (3.4.1).")
log("STEP 3  parallel or serial: 220 and 71 deg are beyond any parallel flexure; the system is SERIAL (Fig. 2.7, right branch).")
log("STEP 4  intermediate freedom spaces from ground: [bearing: 1R vertical through F] -> [flexure: 1R horizontal through F] -> [flexure: 3 DOF Type 1 about the vertex].")
log("        1 + 1 + 3 = 5 twists, the five wanted; the dish's roll about its own axis is fixed by no stage and needed by none: the chain is not underconstrained (p. 36).")
log(f"STEP 5  ground = the deck and the tube (F is on the tube; the strip's own ring at the tube top turns with the fork). Stage 1 = the fork: a ring beam r {GM.R_RAIL:.2f} m")
log(f"        on the deck rail and two posts up to the elevation axis. Stage 2 = the cradle: two side arms at |y| {GM.Y_ARM} m (outside the rim, 2.22 m), a back frame")
log(f"        {GM.D_FRAME} m behind the vertex, counterweights {GM.L_CW} m up-sun of the axis. Stage 3 = the dish on its back ring.")
log("\nSTEP 6  constraints from the constraint spaces")
# ---- elevation pivot: constraint space of 1R = every line meeting the axis; blades whose planes contain the axis
axis_dir = np.array([0, 1.0, 0])         # block frame: x horizontal in the meridian plane (h), y = the elevation axis (e), z up; origin on the axis
def pivot_stage(y0, y_block=0.0):
    C = []
    for i in range(GM.N_CELL):
        y = y_block + y0 + (i - (GM.N_CELL - 1)/2)*GM.PITCH
        p = np.array([0.0, y, 0.0])
        C += blade(p, np.array([1.0, 0, 1.0])/np.sqrt(2), axis_dir)      # blade plane contains the axis: normal x u
        C += blade(p, np.array([-1.0, 0, 1.0])/np.sqrt(2), axis_dir)
    return C
CA = pivot_stage(+GM.Y_STAGE, GM.Y_T); CB = pivot_stage(-GM.Y_STAGE, GM.Y_T)
left, r = interface_freedom(CA); log(f"  trunnion block, stage A: {len(CA)} blade lines (6 blades in 3 cells at +-45 deg crossing on the axis) -> rank {r}, DOF {6 - r}: {describe(left)}")
left, r = interface_freedom(CB); log(f"  trunnion block, stage B: rank {r}, DOF {6 - r}: {describe(left)}")
Tel = rot_twist([0, 0, 0], axis_dir)
CA2 = pivot_stage(+GM.Y_STAGE, -GM.Y_T); CB2 = pivot_stage(-GM.Y_STAGE, -GM.Y_T)
log(f"  reciprocal product of every blade line of both blocks with the rotation about the axis: {max(abs(w[:3]@Tel[3:] + w[3:]@Tel[:3]) for w in CA + CB + CA2 + CB2):.1e}")
left, r = interface_freedom(CA + CA2); log(f"  the two blocks together (one stage each, in parallel across the cradle): rank {r}, DOF {6 - r}: {describe(left)}")
log(f"        the same lines meet the axis whether the blocks sit at F or at |y| {GM.Y_T} m: the constraint space of a rotation does not depend on where along its axis")
log(f"        the constraints are placed (thesis 3.2.1). At F they would cross the aperture in projection and the tube's reach; at |y| {GM.Y_T} m they do neither.")
theta_stage = 0.25*SY*2*GM.L_B/(E_S*GM.T_B)
need = np.radians(71.0/2)/2
log(f"  blades {GM.W_B*1e3:.0f} x {GM.T_B*1e3:.1f} x {GM.L_B*1e3:.0f} mm 17-7PH: +-{np.degrees(theta_stage):.1f} deg per stage at 0.25 sigma_y; needed +-{np.degrees(need):.1f} per stage (71 deg over two stages)")
log(f"        -> {E_S*GM.T_B*need/(2*GM.L_B)/1e6:.0f} MPa = {E_S*GM.T_B*need/(2*GM.L_B)/SY:.2f} sigma_y at el 12 and 83, neutral at el 47.5")
I_b = GM.W_B*GM.T_B**3/12; k_pair = 2*E_S*I_b/GM.L_B; K_stage = GM.N_CELL*k_pair; K_block = K_stage/2; K_el = 2*K_block
log(f"  spring: 2EI/L = {k_pair:.1f} N m/rad per crossed pair, {K_stage:.0f} per stage, {K_block:.0f} per block (two stages in series), {K_el:.0f} N m/rad for the two blocks; {K_el*2*need:.0f} N m at the ends of travel")
Pcr = 4*np.pi**2*E_S*I_b/GM.L_B**2
# ---- loads through the blocks: statics of the balanced cradle on two blocks 2 Y_T apart, forces resolved into the +-45 deg blade families
m_cw = GM.m_cw(); m_arms = 2*(GM.L_UP + GM.L_DOWN)*GM.M_ARM_PER_M
m_cradle = GM.M_DISH + GM.M_FRAME + m_arms + 2*m_cw + 30.0
W = m_cradle*9.81
log(f"  cradle mass: dish {GM.M_DISH:.0f} + frame {GM.M_FRAME:.0f} + arms {m_arms:.0f} + water 2 x {m_cw:.0f} + cranks {30} = {m_cradle:.0f} kg, balanced about the axis")
u_p, u_m = np.array([1, 0, 1.0])/np.sqrt(2), np.array([-1, 0, 1.0])/np.sqrt(2)
def worst_blade(loads):
    """loads: list of (name, D) -> max per-blade in-plane force over elevation and wind direction, and the case"""
    worst = (0.0, "")
    for el in np.radians(np.linspace(12, 83, 30)):
        s = np.array([np.cos(el), 0, np.sin(el)]); n = np.array([-np.sin(el), 0, np.cos(el)])
        for name, D in loads:
            cases = {"wind along the axis": (D*s/2, 0.0), "crosswind": (np.zeros(3), D*G/(2*GM.Y_T)),
                     "wind in the meridian plane, across the axis": (D*n/2, 0.0)}
            for cname, (f_direct, f_couple) in cases.items():
                for sgn in (+1, -1):
                    f = f_direct + np.array([0, 0, -W/2]) + sgn*f_couple*s
                    per = max(abs(f@u_p), abs(f@u_m))/GM.N_CELL
                    if per > worst[0]: worst = (per, f"{name}, {cname}, el {np.degrees(el):.0f}")
    return worst
for q, lab, D in ((H.Q9, "9 m/s", D9), (H.Q25, "25 m/s", D25)):
    per, case = worst_blade([(lab, D)])
    log(f"  {lab}: drag {D:.0f} N; its moment about F {D*G/1e3:.1f} kN m becomes +-{D*G/(2*GM.Y_T)/1e3:.2f} kN along the dish axis at the two blocks {2*GM.Y_T:.1f} m apart;")
    log(f"        worst blade {per:.0f} N in plane ({case}) vs fixed-fixed buckling {Pcr:.0f} N -> SF {Pcr/per:.1f}")
log(f"        the third pass put one block at F and counted forces only; the crosswind's {D9*G/1e3:.1f} kN m at 9 m/s on cells 0.33 m apart would have loaded its blades {D9*G/0.33/np.sqrt(2)/2/1e3:.1f} kN: over buckling. Two blocks fix that.")
# thermal / alignment: both blocks constrain y, so the posts must give
I_post = np.pi*(0.25**4 - 0.234**4)/64; k_post = 3*E_S*I_post/(GM.Z_POST_TOP - GM.Z_RAIL)**3
log(f"  both blocks hold y (over-constraint across {2*GM.Y_T:.1f} m): 13 K between cradle and fork = {2*GM.Y_T*12e-6*13*1e3:.1f} mm; the posts ({k_post/1e3:.0f} kN/m each, 250 x 8 x {GM.Z_POST_TOP - GM.Z_RAIL:.2f} m) give it at {2*GM.Y_T*12e-6*13*k_post/2:.0f} N;")
log(f"        crosswind at 9 m/s moves the axis {D9/(2*k_post)*1e3:.1f} mm in y (0.3 mrad of pointing, inside the fine stage); axis alignment of the two blocks to 0.2 mrad at assembly")
# ---- azimuth
log(f"  azimuth: the fork's ring beam r {GM.R_RAIL:.2f} m on the deck rail (Hashemi's ring rail); its rollers' lines meet the vertical F-F2 axis, the 1R constraint space; 220 deg; a bearing, not a flexure.")
# ---- fine stage: 3 DOF Type 1 about the vertex, tangential blades flat in the back plane (thesis Fig. 4.3)
R_D, B_D, T_D, L_D = GM.R_RING, 0.060, 0.0015, 0.45
Cd = []
for a in np.radians(GM.STATIONS):
    p = np.array([R_D*np.cos(a), R_D*np.sin(a), 0.0]); t = np.array([-np.sin(a), np.cos(a), 0.0])
    Cd += blade(p, np.array([0, 0, 1.0]), t)
left, r = interface_freedom(Cd); log(f"  fine stage: three flat tangential blades at {GM.STATIONS} deg from the slot (9 lines, all in the back plane) -> rank {r}, DOF {6 - r}: {describe(left)}")
Tfine = [rot_twist([0, 0, 0], [1, 0, 0]), rot_twist([0, 0, 0], [0, 1, 0]), trans_twist([0, 0, 1])]
log(f"  reciprocal products with tip, tilt, focus: {max(abs(w[:3]@t[3:] + w[3:]@t[:3]) for w in Cd for t in Tfine):.1e}; constraint space = the plane + a normal torque (Fig. 3.38): matched")
th = 0.020; delta = R_D*th; sig = 3*E_S*T_D*delta/L_D**2
k_rad = E_S*T_D*B_D**3/L_D**3; F_th = k_rad*(23e-6 - 12e-6)*40*R_D; sig_th = 6*(F_th*L_D/2)/(T_D*B_D**2)
log(f"  blades 60 x 1.5 x 450 mm: +-20 mrad -> end offset {delta*1e3:.0f} mm, S-bend {sig/1e6:.0f} MPa = {sig/SY:.2f} sigma_y; tangential stiffness EA/L {E_S*B_D*T_D/L_D/1e6:.0f} MN/m;")
log(f"        radial (thermal) compliance {k_rad/1e3:.0f} kN/m: the 0.62 mm Al/steel mismatch loads a blade {F_th:.0f} N at {sig_th/1e6:.0f} MPa in-plane; out-of-plane 12EI/L^3 {12*E_S*(B_D*T_D**3/12)/L_D**3:.0f} N/m (the DOF)")
Ca = [wire([GM.R_ACT*np.cos(a), GM.R_ACT*np.sin(a), 0.0], [0, 0, 1.0]) for a in np.radians(GM.COLUMNS)]
left, r = interface_freedom(Cd + Ca); log(f"  three flexure struts on the normals at r {GM.R_ACT} m, {GM.COLUMNS} deg (actuation space = box of normals, Fig. 4.3; each a wire line): with the blades rank {r}, DOF {6 - r}")
recA = np.array([[w[:3]@t[3:] + w[3:]@t[:3] for t in Tfine] for w in Ca]); log(f"  strut arms on (tip, tilt, focus): {np.round(recA, 2).tolist()}")
k_col = 0.5e9*0.01/0.25; K_rot = sum(k_col*(GM.R_ACT*np.sin(np.radians(a)))**2 for a in GM.COLUMNS)
log(f"  locked stage: {K_rot/1e6:.0f} MN m/rad about the vertex (columns); drag asymmetry 315 N m at 9 m/s -> {315/K_rot*1e6:.0f} urad; 1 mL = {1e-6/0.01/GM.R_ACT*1e6:.0f} urad")
log(f"  the slot: the tube passes through the membrane at el 55-83 anywhere along the slot, so the back ring and the frame ring are open +-{GM.GAP_RING:.0f}/{GM.GAP_FRAME:.0f} deg about it and no station or column stands within |y| 0.5 m of it")
# ---- elevation actuation: crank + screw jack per side, lever over the range
def jack(el):
    s = np.array([np.cos(el), 0, np.sin(el)]); n = np.array([-np.sin(el), 0, np.cos(el)])
    ps = np.radians(GM.PSI_CRANK); tip = GM.L_CRANK*(-np.cos(ps)*n - np.sin(ps)*s); anc = np.array([GM.A_H, 0, -GM.A_Z]); d = anc - tip; L = np.linalg.norm(d); u = d/L
    return L, abs(np.cross(tip, u)[1])
els = np.radians(np.linspace(12, 83, 72)); Ls, levs = zip(*[jack(e) for e in els])
log(f"\nACTUATION  elevation: a crank {GM.L_CRANK} m from the axis on each arm ({-GM.PSI_CRANK:.0f} deg up-sun of the perpendicular) and a self-locking screw jack to a bracket {-GM.A_H} m behind and {GM.A_Z} m below the axis on each post:")
log(f"        jack length {min(Ls):.2f}-{max(Ls):.2f} m (stroke {max(Ls) - min(Ls):.2f}), lever {min(levs):.2f}-{max(levs):.2f} m over el 12-83;")
for lab, D in (("9 m/s", D9), ("25 m/s", D25)):
    tau = D*G; log(f"        {lab}: wind torque about the axis {tau/1e3:.1f} kN m (+ {K_el*2*need:.0f} N m of blade spring) -> {tau/2/min(levs)/1e3:.1f} kN per jack at the worst lever")
log(f"        holding stiffness ~50 MN m/rad per jack -> {D9*G/100e6*1e6:.0f} urad under the 9 m/s mean; gusts inside the fine stage's +-20 mrad. No power to hold. Tr40 jacks, 50 kN, 1.2 m stroke.")
log(f"        turgor: pumping {D9*G/(9.81*(GM.L_CW + G)):.0f} L from the up-sun tanks to a tank on the back frame cancels the 9 m/s mean torque; the jack holds the rest.")
log("        azimuth: a pinion on the ring beam. fine: the columns on the beam-centroid loop at the tube's waist.")
# ---- clearance of the tube over the year
worst = (9.9, "", None)
for p in H.positions():
    d, name = GM.tube_clearance(p["el"], p["A"])
    if d < worst[0]: worst = (d, name, p)
log(f"\nCLEARANCE  tube vs cradle and fork over {len(H.positions())} Quetta sun positions: worst {worst[0]*1e3:.0f} mm ({worst[1]}, {worst[2]['season']} {worst[2]['hour']:.1f} h, el {np.degrees(worst[2]['el']):.0f})")
log(f"        the arms at |y| {GM.Y_ARM} m clear the rim toroid (2.22 m) by {(GM.Y_ARM - GM.R_ARM - 2.22)*1e3:.0f} mm; the posts at |y| {GM.Y_POST} m are outside the dish's sweep at every hour")
s12, _, _, _ = GM.frame(np.radians(12), np.pi)
log(f"        at el 12 the tank ends reach {-(F[0] - (GM.L_CW + 0.36)*np.cos(np.radians(12))):.1f} m south of the tube axis at z {F[2] + (GM.L_CW + 0.36)*np.sin(np.radians(12)):.1f}; at el 83 they stand at z {F[2] + (GM.L_CW + 0.36)*np.sin(np.radians(83)):.1f}")
log(f"        ring beam diameter {2*GM.R_RAIL + 0.3:.1f} m inside the 7.8 m the dish's sweep already needs")
log("\nSHADING  every mount part projects outside the aperture along the sun line by construction (arms and posts at |y| > 2.1 m, blocks beyond them,")
log("        counterweights on the arms); shading.py rasterises the model to confirm it. The tube, the strip and its ring are the cass machine's own.")
log("\nWHAT IS COMPLIANT HERE  the elevation pivots (two blocks of twelve blades, exact 1R about the axis through F, 71 deg, no bearing, no backlash), the fine stage")
log("        (three blades, exact 3 DOF Type 1, microradians), the flexure struts of the actuators, and the posts as the thermal compliance of the trunnion pair.")
log("        Not compliant and not pretending: the ring bearing, the tube, the arms, the jacks.")
open(os.path.join(OUT, "synth.txt"), "w").write("\n".join(LOG))

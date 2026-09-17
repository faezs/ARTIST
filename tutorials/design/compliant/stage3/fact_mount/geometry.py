#!/usr/bin/env python
"""Shared geometry of the FACT mount (metres, env frame): the fork on the deck ring, the two trunnion blocks on
the elevation axis through F outside the aperture, the cradle (two side arms, back frame), counterweights,
cranks and jacks. model.py draws exactly these members; synth.py and shading.py check them."""
import sys, os, numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "hashemi_pneumatic"))
import physics_hp as H
F = H.F; G = H.G_ORBIT; A_D = H.A_DISH; R_SPH = H.R_SPH; SAG = H.SAG; Z_DECK = H.Z_DECK
# ---- the mount's dimensions
Y_T, Y_POST, Y_ARM, Y_JACK = 3.25, 3.61, 2.45, 2.90     # trunnion block centre, post (under stage A), side arm, jack plane: offsets along the elevation axis
R_POST, R_ARM, R_TANK = 0.125, 0.075, 0.20             # 250 x 8 posts, 150 x 5 arms, 91 L tanks
L_UP, L_DOWN, L_CW = 2.6, 4.6, 2.6                      # arm beyond the axis toward the sun; arm to the back frame; counterweight station
Z_RAIL = Z_DECK + 0.18; R_RAIL = Y_POST                 # the rotating ring beam on the deck rail
Z_POST_TOP = F[2] - 0.35
W_B, T_B, L_B, N_CELL, PITCH, Y_STAGE = 0.200, 0.0010, 0.120, 3, 0.215, 0.36   # blades, cells per stage, stage centres at +-Y_STAGE
D_FRAME, D_RING = 0.60, 0.30                            # back frame plane and dish back ring behind the vertex
R_FRAME, R_RING, R_ACT = 1.75, 1.46, 1.60
GAP_FRAME, GAP_RING = 40.0, 40.0                        # half-angle of the C-rings' opening about the slot direction, deg
STATIONS = (60.0, 180.0, 300.0); COLUMNS = (90.0, 210.0, 315.0)   # fine stage blade stations and water columns, deg from the slot direction
L_CRANK, CRANK_STEP, PSI_CRANK = 1.00, 0.50, -20.0      # L-crank: 0.5 m out at the arm, across to the jack plane, on to 1.0 m; leaning 20 deg up-sun from -n
A_H, A_Z = -0.25, 2.75                                  # jack anchor on the post bracket: 0.25 m behind the post, 2.75 m below the axis
M_DISH, M_FRAME, M_ARM_PER_M, M_POST_PER_M = 60.0, 40.0, 17.9, 47.7

def frame(el, A):
    """unit vectors: s to the sun, h its horizontal, e the elevation axis (z x h), n = perpendicular to s in the meridian plane (up-sun)"""
    s = np.array([np.cos(el)*np.cos(A), np.cos(el)*np.sin(A), np.sin(el)])
    h = np.array([np.cos(A), np.sin(A), 0.0]); e = np.array([-np.sin(A), np.cos(A), 0.0])
    n = np.cos(el)*np.array([0, 0, 1.0]) - np.sin(el)*h
    return s, h, e, n

def dish_axes(el, A):
    """the dish frame of model_hp.dish_frame: x_l = -n (the slot direction, downhill), y_l = e, z_l = s"""
    s, h, e, n = frame(el, A); return -n, e, s

def crank_dir(el, A):
    s, h, e, n = frame(el, A); ps = np.radians(PSI_CRANK); return -np.cos(ps)*n - np.sin(ps)*s

def m_cw():
    """counterweight per side that puts the cradle's centre of mass on the elevation axis"""
    m_arms = 2*(L_UP + L_DOWN)*M_ARM_PER_M
    down = M_DISH*G + M_FRAME*(G + D_FRAME) + m_arms*(L_DOWN - L_UP)/2
    return down/L_CW/2

def cradle_segments(el, A):
    """[(p0, p1, r, name)] of the moving cradle and the fork, metres, world; C-rings as polylines"""
    s, h, e, n = frame(el, A); xl, yl, zl = -n, e, s; z = np.array([0, 0, 1.0])
    seg = []
    Cf = F - (G + D_FRAME)*s; Cr = F - (G + D_RING)*s
    for sg in (+1, -1):
        T = F + sg*Y_T*e; Aa = F + sg*Y_ARM*e
        base = np.array([F[0], F[1], Z_RAIL]) + sg*Y_POST*e
        seg.append((base, base + (Z_POST_TOP - Z_RAIL)*z, R_POST, "post"))
        seg.append((Aa + L_UP*s, Aa - L_DOWN*s, R_ARM, "arm"))
        seg.append((Aa + (L_CW - 0.36)*s, Aa + (L_CW + 0.36)*s, R_TANK, "tank"))
        c = crank_dir(el, A); k0 = Aa; k1 = Aa + CRANK_STEP*c; k2 = F + sg*Y_JACK*e + CRANK_STEP*c; k3 = F + sg*Y_JACK*e + L_CRANK*c
        seg += [(k0, k1, 0.04, "crank"), (k1, k2, 0.04, "crank"), (k2, k3, 0.04, "crank")]
        anchor = F + sg*Y_JACK*e + A_H*h - A_Z*z
        seg.append((anchor, k3, 0.05, "jack"))
        seg.append((F + sg*Y_POST*e - A_Z*z, anchor - 0.0*h, 0.05, "jack bracket"))
        seg.append((F + sg*Y_POST*e + A_H*h - A_Z*z, anchor, 0.05, "jack bracket"))
        # frame spokes and diagonals from the arm to the ring
        seg.append((Cf + sg*R_FRAME*yl, Cf + sg*Y_ARM*yl, 0.04, "frame spoke"))
        d = np.radians(135.0); seg.append((Cf + sg*Y_ARM*yl, Cf + R_FRAME*(np.cos(d)*xl + sg*np.sin(d)*yl), 0.03, "frame diagonal"))
        seg.append((Cf + sg*Y_ARM*yl, Cf + R_FRAME*(np.cos(np.radians(60))*xl + sg*np.sin(np.radians(60))*yl), 0.03, "frame diagonal"))
    for r, c, gap, name in ((R_FRAME, Cf, GAP_FRAME, "back frame ring"), (R_RING, Cr, GAP_RING, "dish back ring")):
        phis = np.radians(np.linspace(gap, 360 - gap, 40))
        pts = [c + r*(np.cos(p)*xl + np.sin(p)*yl) for p in phis]
        seg += [(pts[i], pts[i + 1], 0.04, name) for i in range(len(pts) - 1)]
    for a in STATIONS:
        ar = np.radians(a); rad = np.cos(ar)*xl + np.sin(ar)*yl; t = -np.sin(ar)*xl + np.cos(ar)*yl
        P = Cr + R_RING*rad + 0.45*t; seg.append((P, P - (D_FRAME - D_RING)*s, 0.03, "fine stage post"))
    for a in COLUMNS:
        ar = np.radians(a); Q = Cr + R_ACT*(np.cos(ar)*xl + np.sin(ar)*yl); seg.append((Q, Q - (D_FRAME - D_RING)*s, 0.06, "water column"))
    return seg

def tube_radius(z):
    """the cass machine's focal tube (model_hp2 scene): bell r 0.9 at the deck to 0.35 at z 5.6, 0.35 to 6.7, 0.35 -> 0.45 up to F - 0.9"""
    if z < 5.6: return 0.9 + (0.35 - 0.9)*(z - Z_DECK)/(5.6 - Z_DECK)
    if z < 6.7: return 0.35
    return 0.35 + 0.10*(z - 6.7)/(F[2] - 0.9 - 6.7)

def seg_seg_dist(p0, p1, q0, q1):
    u, v, w = p1 - p0, q1 - q0, p0 - q0
    a, b, c, d, e = u@u, u@v, v@v, u@w, v@w; D = a*c - b*b
    sc = tc = 0.0
    if D > 1e-12: sc = np.clip((b*e - c*d)/D, 0, 1)
    tc = (b*sc + e)/c if c > 1e-12 else 0.0
    if tc < 0: tc = 0.0; sc = np.clip(-d/a, 0, 1) if a > 1e-12 else 0.0
    elif tc > 1: tc = 1.0; sc = np.clip((b - d)/a, 0, 1) if a > 1e-12 else 0.0
    return np.linalg.norm(p0 + sc*u - (q0 + tc*v))

def tube_clearance(el, A):
    """min (distance - radii) between the vertical tube (deck to F - 0.9) and every cradle/fork member"""
    seg = cradle_segments(el, A); worst = (9.9, "")
    zs = np.linspace(Z_DECK, F[2] - 0.9, 80)
    for i in range(len(zs) - 1):
        q0 = np.array([F[0], F[1], zs[i]]); q1 = np.array([F[0], F[1], zs[i + 1]]); rt = max(tube_radius(zs[i]), tube_radius(zs[i + 1]))
        for p0, p1, r, name in seg:
            d = seg_seg_dist(p0, p1, q0, q1) - rt - r
            if d < worst[0]: worst = (d, name)
    return worst

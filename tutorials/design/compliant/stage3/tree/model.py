#!/usr/bin/env python
"""CadQuery model (mm, env frame: x north, z up, the deck at env z 5.0) of the fifth pass, the flower proper: one stem, a crown of
branches carrying the exact spherical membrane primary of hashemi.ini (a 2.1 m, R 8 m, f = g = 4 m), F fixed on the light pipe
(the env's bore r 0.7 on the roof, its mouth at F, the hyperboloid strip at F; the beam-down never passes through the dish and the schedule keeps the rim clear of the pipe). The head rides the orbit sphere of radius g about F as in the
env (beta_dev = 0: retro, hub at F - g s, axis along s); the branches are circular arcs from the stem top to the head's back ring.
Scenes: winter noon, equinox morning, equinox noon, summer noon, the year's sweep."""
import os, sys, json, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); ROOTDIR = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOTDIR, "3d")); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic"))
from mesh_export import Scene
import physics_hp as H
from model_hp import cyl, disc, frame_matrix, cap_shell, COL, M
COL = dict(COL); COL.update(branch="#7c4a1e", stem="#5b3a12", pipe="#1f2937", strip="#9333ea", ring="#334155")
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True); V = cq.Vector
G, RC, A_M = 4.0, 8.0, 2.1
Z_DECK = H.Z_DECK; Z_F = Z_DECK + 0.35 + np.hypot(G, A_M)                      # the env's z_fold: 4.87 m over the deck
R_PIPE, D_STRIP, R_STRIP = 0.7, 0.6, 0.6
X_STEM, H_STEM, R_STEM = 2.0, 1.0, 0.15
D_BACK, R_BACK, N_BR, R_BR = 0.45, 1.5, 12, 0.05
F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0]); T0 = np.array([X_STEM, 0.0, Z_DECK + H_STEM])
def sun(doy, hour):
    el, Az, s = H.sun(doy, hour); return float(el), float(Az), np.asarray(s, float)
def pose(s, beta_deg=0.0):
    """the env's law: the head sits on the orbit sphere at the sun's azimuth, elevation el - beta as seen from F; its axis bisects the sun and the line to F"""
    el = np.arcsin(s[2]); hxy = s[:2]/max(np.linalg.norm(s[:2]), 1e-9); eb = el - np.radians(beta_deg)
    d = np.array([np.cos(eb)*hxy[0], np.cos(eb)*hxy[1], np.sin(eb)]); P = F - G*d
    n = s + d; n /= np.linalg.norm(n); return P, n
def head_axes(n):
    up_in = Z - n*n[2]
    if np.linalg.norm(up_in) < 1e-6: up_in = np.array([1.0, 0, 0])
    up_in /= np.linalg.norm(up_in); xl = -up_in; yl = np.cross(n, xl); return xl, yl, n
def arc_points(p0, p1, k=10):
    """branch curve from p0 (tangent vertical at the root) to p1: a quadratic Bezier with its control point above the root;
    returns the points and (length, largest curvature)"""
    d = p1 - p0; L = np.linalg.norm(d); c = p0 + np.array([0, 0, 0.45*L])
    t = np.linspace(0, 1, k)[:, None]; pts = (1 - t)**2*p0 + 2*(1 - t)*t*c + t**2*p1
    seg = np.diff(pts, axis=0); ln = np.linalg.norm(seg, axis=1); length = ln.sum()
    tang = seg/ln[:, None]; dth = np.arccos(np.clip(np.einsum("ij,ij->i", tang[:-1], tang[1:]), -1, 1)); kap = float((dth/(0.5*(ln[:-1] + ln[1:]))).max()) if len(dth) else 0.0
    return pts, (length, kap)
R_HOLE, ARM_N, R_BORE_DRAWN = 0.5, 3.0, 0.42
def add_ground(sc):
    deck = cq.Workplane("XY").box(9.0 * M, 11.0 * M, 120).translate((2.0 * M, 0, Z_DECK * M - 60)).cut(cq.Workplane("XY").circle(0.5 * M).extrude(400).translate((-0.25 * M, 0, Z_DECK * M - 200)))
    sc.add(deck.val(), "roof deck (env z 5.0)", COL["ctx"], tol=3.0)
    # the light pipe: a vertical pipe on the roof, the env's r_bore 0.7, its mouth at F, going down through the roof to the oven; the beam-down never passes through the dish: the schedule keeps the head's rim 0.3 m clear of it (path.py)
    turn = np.array([0.0, 0, Z_DECK - 4.86]) * M
    sc.add(cyl(R_PIPE * M, turn, (F + [0, 0, 0.2]) * M).cut(cyl((R_PIPE - 0.02) * M, turn - [0, 0, 10], (F + [0, 0, 0.21]) * M)), "light pipe on the roof: the env's bore r 0.7, its mouth at F, down through the roof to the oven; separate of the flower", COL["pipe"], tol=3.0)
    sc.add(cq.Solid.makeSphere(60, V(*(F * M))), "F: the dish focus, the hyperboloid's first focus", COL["mirror"], tol=2.0)
def add_strip(sc, n, tag=""):
    c = (F - D_STRIP * n) * M
    sc.add(disc(R_STRIP * M, c, n, 12.0), "hyperboloid strip 0.6 m before F, r 0.6 (Masdar beam-down: F to the bore, down the pipe)" + tag, COL["strip"], tol=2.5)
def add_stem(sc):
    sc.add(cyl(R_STEM * M, np.array([X_STEM, 0, Z_DECK]) * M, T0 * M), f"stem: {H_STEM:.0f} m, r {R_STEM} m, {X_STEM} m north of the pipe; the one trunk", COL["stem"], tol=3.0)
    sc.add(cq.Solid.makeSphere(0.22 * M, V(*(T0 * M))), "receptacle: the branches' root at the stem top", COL["stem"], tol=3.0)
def add_head(sc, P, n, tag="", full=True):
    xl, yl, zl = head_axes(n); Mx = frame_matrix(P * M, xl, yl, zl)
    parts = [(cq.Solid.makeTorus(A_M * M + 60, 60, V(0, 0, H.SAG * M), V(0, 0, 1)), "inflated rim toroid", COL["rim"])]
    if full:
        skin, _ = cap_shell(RC * M, A_M * M, 1.0, 0.0)
        parts.append((skin, "membrane primary: the hashemi.ini sphere as the env traces it, a 2.1 m, R 8 m (env target 8.1), no hole: the beam-down does not pass through the dish", COL["skin"]))
    for shp, name, col in parts: sc.add(shp.transformShape(Mx), name + tag, col, tol=(9.0 if "membrane" in name else 4.0))
    return xl, yl
N_TIPS, R_TIPS, N_PRI, N_SEC = 60, 2.05, 6, 2
def crown_points(P, n):
    """the crown: tips scattered over the membrane's back (a Vogel spiral on the sphere R about the head's centre of curvature),
    secondary junctions at r 1.45 (two per sector), primary junctions at r 0.8; all in the head's frame"""
    xl, yl, zl = head_axes(n)
    def on_back(r, a, depth):
        zb = RC - np.sqrt(RC*RC - r*r)                                     # the sphere's sag at radius r (the membrane's back, concave toward +n)
        return P + (r*np.cos(a))*xl + (r*np.sin(a))*yl + (zb - depth)*n
    k = np.arange(N_TIPS); r = R_TIPS*np.sqrt((k + 0.5)/N_TIPS); a = k*np.radians(137.508)
    tips = [on_back(r[i], a[i], 0.06) for i in range(N_TIPS)]   # (the branching-tree crown keeps all tips; the hole is drawn in the membrane)
    sec = {}
    for j in range(N_PRI):
        ac = 2*np.pi*(j + 0.5)/N_PRI
        for m in range(N_SEC):
            sec[(j, m)] = on_back(1.45, ac + (m - 0.5)*np.radians(30), 0.28)
    pri = [on_back(0.8, 2*np.pi*(j + 0.5)/N_PRI, 0.42) for j in range(N_PRI)]
    return tips, sec, pri, (r, a)
def add_branches(sc, P, n, tag=""):
    """stem -> 6 primaries -> 12 secondaries -> 60 twigs whose tips carry the membrane: the foliage whose inner surface is the spherical section"""
    tips, sec, pri, (r, a) = crown_points(P, n); stats = []
    for j, J in enumerate(pri):
        pts, (L, kap) = arc_points(T0, J, 8); stats.append((L, kap))
        for i in range(len(pts) - 1): sc.add(cyl(0.05 * M, pts[i] * M, pts[i + 1] * M), f"primary branch {j + 1} of {N_PRI}: receptacle to r 0.8 on the head's back, {L:.2f} m" + tag, COL["branch"], tol=8.0)
        for m in range(N_SEC):
            S2 = sec[(j, m)]; sc.add(cyl(0.032 * M, J * M, S2 * M), f"secondary branch: r 0.8 to r 1.45, sector {j + 1}" + tag, COL["branch"], tol=8.0)
    for i, T in enumerate(tips):
        ai = (a[i]) % (2*np.pi); j = int(ai/(2*np.pi/N_PRI)) % N_PRI
        if r[i] < 1.05: src = pri[j]
        else:
            ac = 2*np.pi*(j + 0.5)/N_PRI; m = 0 if ((ai - ac + np.pi) % (2*np.pi) - np.pi) < 0 else 1; src = sec[(j, m)]
        sc.add(cyl(0.018 * M, src * M, T * M), f"twig to tip {i + 1} of {N_TIPS}: the membrane rests on the tips (a Vogel scatter on the sphere)" + tag, COL["branch"], tol=8.0)
        sc.add(cq.Solid.makeSphere(0.045 * M, V(*(T * M))), "tip pad under the membrane" + tag, COL["ring"], tol=6.0)
    return stats
def add_beam(sc, P, n, s, tag=""):
    xl, yl, zl = head_axes(n)
    for a in np.linspace(0, 2*np.pi, 8, endpoint=False):
        q = P + A_M*(np.cos(a)*xl + np.sin(a)*yl) + H.SAG*n
        sc.add(cyl(10, q * M, F * M), "beam: rim to F" + tag, COL["beam"], tol=2.0)
    sc.add(cyl(14, P * M, (P + 6.0*s) * M), "sun line" + tag, COL["sun"], tol=2.0)
sys.path.insert(0, HERE); import path as PT
def sched_pose(doy, hour):
    """the head's pose for the sun (doy, hour): the schedule's (path.json, nearest sampled day within 8 days: the env's law with beta chosen for the boom's
    reach, the rim's height and 0.3 m of clearance between the whole membrane and the r 0.7 pipe); where the schedule has none, the env's law with the
    smallest beta that clears the pipe (the branching crown's reach is not the boom's); None only if no beta within 36 deg clears the pipe."""
    pj = os.path.join(OUT, "path.json"); el, Az, s_ = sun(doy, hour)
    if os.path.exists(pj):
        PJ = json.load(open(pj)); c = [l for l in PJ["log"] if l.get("ok") and abs(l["doy"] - doy) <= 8 and abs(l["hour"] - hour) < 0.01]
        if c:
            l = min(c, key=lambda l: abs(l["doy"] - doy)); return np.array(l["P"]) + np.array([0, 0, Z_DECK]), np.array(l["n"]), l["beta"], "schedule"
    for b in np.linspace(0, 36, 37):                                                 # the env's law: the head on the orbit sphere at el - beta, axis the bisector
        for sgn in ((1,) if b == 0 else (1, -1)):
            e_ = np.radians(el) - sgn*np.radians(b); az_ = np.arctan2(s_[1], s_[0]); ub = np.array([np.cos(e_)*np.cos(az_), np.cos(e_)*np.sin(az_), np.sin(e_)])
            P = np.array([0, 0, PT.Z_F]) - G*ub; n = s_ + ub; n /= np.linalg.norm(n); ev = PT.evaluate(P, n, s_, np.array([X_STEM, 0, H_STEM]))
            if ev["rp"] >= PT.R_PIPE + 0.3 and ev["zmin"] >= PT.RIM_CLEAR: return P + np.array([0, 0, Z_DECK]), n, float(b), "env law, pipe-clear"
    return None
def scene(name, poses, full_idx=None, beta=0.0):
    sc = Scene(); add_ground(sc); add_stem(sc); allstats = []
    for j, (doy, hour) in enumerate(poses):
        el, Az, s = sun(doy, hour); sp = sched_pose(doy, hour)
        if sp is None: print(f"  {name}: {doy} d {hour} h el {np.degrees(el):.0f}: no beta within 36 deg keeps the pipe out of the membrane; not drawn"); continue
        P, n, b_, src = sp
        tag = f" [{doy} d, {hour:.0f} h, el {np.degrees(el):.0f}, beta {b_:.0f}]" if len(poses) > 1 else ""
        full = (full_idx is None) or (j == full_idx)
        add_head(sc, P, n, tag, full=full); stats = add_branches(sc, P, n, tag); allstats += stats
        if full: add_strip(sc, n, tag); add_beam(sc, P, n, s, tag)
        print(f"  {name}: {doy} d {hour:.0f} h el {np.degrees(el):.0f} az {np.degrees(Az):.0f} beta {b_:.0f} ({src}): hub {np.round(P - [0, 0, Z_DECK], 2)} m over the deck, axis el {np.degrees(np.arcsin(n[2])):.0f}, primaries {min(s_[0] for s_ in stats):.2f}-{max(s_[0] for s_ in stats):.2f} m, lowest rim {P[2] - Z_DECK - A_M*np.sqrt(1 - n[2]**2):.2f} m")
    sc.write(os.path.join(OUT, name + ".json")); return allstats

# ---- the wind-sized crown (wind_size.py): receptacle ring r 1.0 at the stem top, six steel legs 75 x 4.7 mm (extensible struts: the actuation),
#      back ring r 1.5 and inner ring r 0.7 with six spokes (40 mm), twigs 18 mm to the sixty tips; stem 215 x 9 mm steel; receptacle r 1.5, legs 85 x 5.3 (the design row of wind_size.txt)
R_REC, R_LEG, R_STEM_W = 1.5, 0.0425, 0.1075; R_PLAT, D_BACK_W, H_HEX, R_BOOM = 1.0, 0.6, 1.2, 0.1095     # the simulations' geometry (setup_sim5.py, flower_elastica.py)
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
def add_stem_w(sc, T0):
    foot = np.array([T0[0], T0[1], Z_DECK])
    sc.add(cyl(R_STEM_W * M, foot * M, T0 * M).cut(cyl((R_STEM_W - 0.009) * M, (foot - [0, 0, 0.01]) * M, (T0 + [0, 0, 0.01]) * M)), "stem: steel CHS 215 x 9 mm, 1.0 m (root 34 kN m at the 15 m/s peak or the stowed gust; 2 mrad, 2 cm at F)", COL["stem"], tol=3.0)
    sc.add(cq.Solid.makeSphere(0.16 * M, V(*(T0 * M))), "pedicel root: the slew and luff servo joint at the stem top", COL["ring"], tol=4.0)
def add_hexapod(sc, T0, P, n, tag=""):
    """the pedicel and the crown as the simulations have them: a telescoping boom from the stem top to the receptacle ring 1.8 m behind the vertex,
    coaxial with the head; six struts of constant length 1.45 m from the ring (r 1.5) to the platform ring (r 1.0) 0.6 m behind the vertex"""
    xl, yl, zl = head_axes(n); Cb = P - (D_BACK_W + H_HEX)*n; Cp = P - D_BACK_W*n
    Lb = np.linalg.norm(Cb - T0)
    sc.add(cyl(R_BOOM * M, T0 * M, Cb * M).cut(cyl((R_BOOM - 0.008) * M, (T0 - 0.01*(Cb - T0)/Lb) * M, (Cb + 0.01*(Cb - T0)/Lb) * M)), f"pedicel: telescoping boom, steel CHS 219 x 8, {Lb:.2f} m from the stem top to the receptacle; the stage that lifts and carries the head" + tag, COL["stem"], tol=3.0)
    sc.add(cq.Solid.makeSphere(0.14 * M, V(*(Cb * M))), "wrist: the servo that keeps the receptacle coaxial with the head" + tag, COL["ring"], tol=4.0)
    Mx = frame_matrix(P * M, xl, yl, zl)
    sc.add(cq.Solid.makeTorus(R_REC * M, 45, V(0, 0, -(D_BACK_W + H_HEX) * M), V(0, 0, 1)).transformShape(Mx), "receptacle ring r 1.5 m on the pedicel, the six struts' base joints" + tag, COL["stem"], tol=3.0)
    for a in BASE_ANG: sc.add(cyl(18, Cb * M, (Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl)) * M), "receptacle spoke" + tag, COL["ring"], tol=6.0)
    B = [Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG]; Pp = [Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG]
    Ls = []
    for j in range(6):
        L = np.linalg.norm(Pp[j] - B[j]); Ls.append(L)
        sc.add(cyl(R_LEG * M, B[j] * M, Pp[j] * M), f"strut {j + 1} of 6: steel CHS 85 x 5.3 mm, {L:.2f} m, a flexure ball at each end; the fine stage" + tag, COL["branch"], tol=4.0)
        sc.add(cq.Solid.makeSphere(0.07 * M, V(*(B[j] * M))), "base flexure ball" + tag, COL["ring"], tol=6.0); sc.add(cq.Solid.makeSphere(0.07 * M, V(*(Pp[j] * M))), "platform flexure ball" + tag, COL["ring"], tol=6.0)
    sc.add(cq.Solid.makeTorus(R_PLAT * M, 40, V(0, 0, -D_BACK_W * M), V(0, 0, 1)).transformShape(Mx), "platform ring r 1.0 m, 0.6 m behind the vertex, steel 80 x 5" + tag, COL["ring"], tol=3.0)
    sc.add(cq.Solid.makeTorus(0.7 * M, 30, V(0, 0, -0.30 * M), V(0, 0, 1)).transformShape(Mx), "inner ring r 0.7 m" + tag, COL["ring"], tol=3.0)
    for a in np.radians([0, 60, 120, 180, 240, 300]):
        sc.add(cyl(20, (Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl)) * M, (P - 0.30*n + 0.7*(np.cos(a)*xl + np.sin(a)*yl)) * M), "calyx spoke, aluminium 40 mm" + tag, COL["branch"], tol=6.0)
        sc.add(cyl(20, (Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl)) * M, (P + H.SAG*n*0.3 + 2.05*(np.cos(a + np.pi/6)*xl + np.sin(a + np.pi/6)*yl) - 0.06*n) * M), "calyx spoke to the rim, aluminium 40 mm" + tag, COL["branch"], tol=6.0)
    # twigs from the nearest ring point to each tip
    k = np.arange(N_TIPS); r = R_TIPS*np.sqrt((k + 0.5)/N_TIPS); a = k*np.radians(137.508)
    for i in range(N_TIPS):
        zb = RC - np.sqrt(RC*RC - r[i]*r[i]); T = P + (r[i]*np.cos(a[i]))*xl + (r[i]*np.sin(a[i]))*yl + (zb - 0.06)*n
        if r[i] < 1.1: src = P - 0.30*n + 0.7*(np.cos(a[i])*xl + np.sin(a[i])*yl)
        else: src = Cp + R_PLAT*(np.cos(a[i])*xl + np.sin(a[i])*yl)
        sc.add(cyl(9, src * M, T * M), f"twig, aluminium 18 mm, to tip {i + 1} of {N_TIPS}" + tag, COL["branch"], tol=8.0)
        sc.add(cq.Solid.makeSphere(0.045 * M, V(*(T * M))), "tip pad under the membrane" + tag, COL["ring"], tol=6.0)
    return Ls
def scene_w(name, poses, full_idx=None):
    """the wind-sized machine at the still-head schedule's poses (path.json)"""
    PJ = json.load(open(os.path.join(OUT, "path.json"))); T0w = np.array(PJ["stem"]) + np.array([0, 0, Z_DECK])
    sc = Scene(); add_ground(sc); add_stem_w(sc, T0w)
    for j, (doy, hour) in enumerate(poses):
        cands = [l for l in PJ["log"] if l.get("ok") and l["doy"] == doy and abs(l["hour"] - hour) < 0.01]
        if not cands: print(f"  {name}: no reachable pose at {doy} d {hour} h"); continue
        l = cands[0]; P = np.array(l["P"]) + np.array([0, 0, Z_DECK]); n = np.array(l["n"]); el, Az, s = sun(doy, hour)
        tag = f" [{doy} d, {hour:.0f} h, el {np.degrees(el):.0f}, beta {l['beta']:.0f}]" if len(poses) > 1 else ""
        full = (full_idx is None) or (j == full_idx)
        add_head(sc, P, n, tag, full=full); Ls = add_hexapod(sc, T0w, P, n, tag)
        if full: add_strip(sc, n, tag); add_beam(sc, P, n, s, tag)
        print(f"  {name}: {doy} d {hour:.0f} h el {np.degrees(el):.0f}: hub {np.round(P - [0, 0, Z_DECK], 2)}, axis el {l['el_n']}, beta {l['beta']}, shadow {100*l['shadow']:.1f} %, struts {min(Ls):.2f}-{max(Ls):.2f} m, boom {np.linalg.norm(P - (D_BACK_W + H_HEX)*n - T0w):.2f} m")
    sc.write(os.path.join(OUT, name + ".json"))

if __name__ == "__main__":
    scene("tr_winter_noon", [(355, 12.0)])
    scene("tr_equinox_morning", [(80, 9.0)])
    scene("tr_equinox_noon", [(80, 12.0)])
    scene("tr_summer_noon", [(172, 11.0)])          # summer noon itself (el 83) is unreachable without a hole in the membrane: the pipe would pass through it; this is the highest reachable summer sun
    st = scene("tr_sweep", [(80, 8.0), (80, 12.0), (80, 16.0), (355, 12.0), (172, 11.0)], full_idx=1)
    print(f"sweep: primary branch length {min(s_[0] for s_ in st):.2f}-{max(s_[0] for s_ in st):.2f} m")
    if os.path.exists(os.path.join(OUT, "path.json")):
        scene_w("tw_equinox_noon", [(80, 12.0)])
        scene_w("tw_winter_noon", [(35, 12.0)])
        scene_w("tw_sweep", [(80, 9.0), (80, 12.0), (80, 15.0), (35, 12.0), (170, 11.0)], full_idx=1)

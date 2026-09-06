#!/usr/bin/env python
"""CadQuery model (mm, env frame: x north, z up, the deck at env z 5.0) of the fifth pass, the flower proper: one stem, a crown of
branches carrying the exact spherical membrane primary of hashemi.ini (a 2.1 m, R 8 m, f = g = 4 m), F fixed on the light pipe
(the cass machine's bore r 0.7 with the hyperboloid strip at F). The head rides the orbit sphere of radius g about F as in the
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
def add_ground(sc):
    deck = cq.Workplane("XY").box(9.0 * M, 11.0 * M, 120).translate((2.0 * M, 0, Z_DECK * M - 60)).cut(cq.Workplane("XY").circle(R_PIPE * M + 20).extrude(400).translate((0, 0, Z_DECK * M - 200)))
    sc.add(deck.val(), "roof deck (env z 5.0)", COL["ctx"], tol=3.0)
    base = np.array([0, 0, Z_DECK - 0.6]) * M; top = np.array([0, 0, Z_F + 0.3]) * M
    sc.add(cyl(R_PIPE * M, base, top).cut(cyl(R_PIPE * M - 20, base - [0, 0, 10], top + [0, 0, 10])), "light pipe on the roof: the cass machine's bore r 0.7 m to the fold F 4.87 m over the deck (separate of the tree)", COL["pipe"], tol=3.0)
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
        skin, _ = cap_shell(RC * M, A_M * M, 2.0, 0.0)
        parts.append((skin, "membrane primary: the exact hashemi.ini sphere, a 2.1 m, R 8 m, f 4 m, no hole, no slot", COL["skin"]))
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
    tips = [on_back(r[i], a[i], 0.06) for i in range(N_TIPS)]
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
def scene(name, poses, full_idx=None, beta=0.0):
    sc = Scene(); add_ground(sc); add_stem(sc); allstats = []
    for j, (doy, hour) in enumerate(poses):
        el, Az, s = sun(doy, hour); P, n = pose(s, beta); tag = f" [{doy} d, {hour:.0f} h, el {np.degrees(el):.0f}]" if len(poses) > 1 else ""
        full = (full_idx is None) or (j == full_idx)
        add_head(sc, P, n, tag, full=full); stats = add_branches(sc, P, n, tag); allstats += stats
        if full: add_strip(sc, n, tag); add_beam(sc, P, n, s, tag)
        print(f"  {name}: {doy} d {hour:.0f} h el {np.degrees(el):.0f} az {np.degrees(Az):.0f}: hub {np.round(P - [0, 0, Z_DECK], 2)} m over the deck, axis el {np.degrees(np.arcsin(n[2])):.0f}, primaries {min(s_[0] for s_ in stats):.2f}-{max(s_[0] for s_ in stats):.2f} m, lowest rim {P[2] - Z_DECK - A_M*np.sqrt(1 - n[2]**2):.2f} m")
    sc.write(os.path.join(OUT, name + ".json")); return allstats
if __name__ == "__main__":
    scene("tr_winter_noon", [(355, 12.0)])
    scene("tr_equinox_morning", [(80, 9.0)])
    scene("tr_equinox_noon", [(80, 12.0)])
    scene("tr_summer_noon", [(172, 12.0)])
    st = scene("tr_sweep", [(80, 8.0), (80, 12.0), (80, 16.0), (355, 12.0), (172, 12.0)], full_idx=1)
    print(f"sweep: primary branch length {min(s_[0] for s_ in st):.2f}-{max(s_[0] for s_ in st):.2f} m")

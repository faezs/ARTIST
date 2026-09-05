#!/usr/bin/env python
"""CadQuery model (mm, env frame: x north, y east, z up, wall line x 1.25 m, roof deck z 5.0 m) of the Cassegrain
Hashemi machine on nix-support with the pneumatic mount: the vine rod from a root on the deck, deck tendons,
attitude tendons, the mast-pair F support. Scenes: equinox noon, summer noon, an equinox morning, and the
year's sweep of rim positions. Geometry from physics_hp so numbers and drawing agree.
"""
import os, sys, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); ROOTDIR = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOTDIR, "3d")); sys.path.insert(0, HERE)
from mesh_export import Scene
import physics_hp as H
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
V = cq.Vector
M = 1000.0
COL = dict(fabric="#5b6b7f", skin="#dfe3e8", rim="#9aa5b1", mirror="#7c3aed", beam="#d9480f", cable="#0e7490", ctx="#c9cfd6", sun="#0e7490")

def cyl(r, p0, p1):
    p0, p1 = np.asarray(p0, float), np.asarray(p1, float); d = p1 - p0; L = np.linalg.norm(d)
    return cq.Solid.makeCylinder(r, L, V(*p0), V(*(d / L)))

def disc(r, centre, normal, t=8.0):
    n = np.asarray(normal, float); n /= np.linalg.norm(n); c = np.asarray(centre, float) - n * t / 2
    return cq.Solid.makeCylinder(r, t, V(*c), V(*n))

def frame_matrix(origin, xl, yl, zl):
    """Rigid transform built natively (cq.Matrix from a list wraps a general transform whose orthogonality test
    rejects even machine-precision frames)."""
    from OCP.gp import gp_Trsf
    t = gp_Trsf(); t.SetValues(xl[0], yl[0], zl[0], origin[0], xl[1], yl[1], zl[1], origin[1], xl[2], yl[2], zl[2], origin[2])
    return cq.Matrix(t)

def dish_frame(s):
    """Local frame at the vertex: z_l = s (to the sun), x_l = downhill in-plane vertical (the slot direction)."""
    zl = np.asarray(s, float); up_in = np.array([0, 0, 1.0]) - zl * zl[2]
    if np.linalg.norm(up_in) < 1e-6: up_in = np.array([1.0, 0, 0])
    up_in /= np.linalg.norm(up_in); xl = -up_in; yl = np.cross(zl, xl)
    return xl, yl, zl

def cap_shell(Rc, a, hole, slot_w, thick=6.0):
    """Spherical-cap shell (vertex at origin, concave toward +z) with the centre hole and, if slot_w > 0, the
    radial slot along +x from the hole to the rim."""
    sag = Rc - np.sqrt(Rc**2 - a**2)
    sh = cq.Workplane("XY").sphere(Rc).translate((0, 0, Rc)).cut(cq.Workplane("XY").sphere(Rc - thick).translate((0, 0, Rc)))
    sh = sh.intersect(cq.Workplane("XY").circle(a).extrude(sag + thick + 2).translate((0, 0, -1)))
    sh = sh.cut(cq.Workplane("XY").circle(hole).extrude(600).translate((0, 0, -300)))
    if slot_w > 0:
        sh = sh.cut(cq.Workplane("XY").box(a, slot_w, 600).translate((a / 2, 0, 0)))
    return sh.val(), sag

def strip_lines(s, n_th=13, n_w=3):
    """Hyperboloid F-sheet (foci F, F2), polar from F with theta from the down axis, in the meridian toward the
    dish; width 1.1 x distance. Returns line segments (mm)."""
    F = H.F * M; F2 = np.array([1.25, 0.0, 6.14]) * M
    c = np.linalg.norm(F - F2) / 2; a = c - 0.8 * M; e = c / a; p = a * (e * e - 1)
    hdir = -np.array([s[0], s[1], 0.0]); hdir /= max(np.linalg.norm(hdir), 1e-9)
    wdir = np.cross([0, 0, 1.0], hdir)
    grid = []
    for th in np.radians(np.linspace(10, 110, 60)):
        r = p / (1 + e * np.cos(th))
        if r * np.sin(th) > 0.8 * M: break                       # r_strip 0.8: the strip stays within 0.8 m of the F-F2 axis
        c0 = F + r * (-np.cos(th) * np.array([0, 0, 1.0]) + np.sin(th) * hdir)
        grid.append([c0 + w * 0.55 * r * wdir for w in np.linspace(-1, 1, n_w)])
    n_th = len(grid)
    lines = []
    for i in range(n_th):
        for j in range(n_w):
            if j + 1 < n_w: lines.append([grid[i][j].tolist(), grid[i][j + 1].tolist()])
            if i + 1 < n_th: lines.append([grid[i][j].tolist(), grid[i + 1][j].tolist()])
    return lines

def scene_common(sc, with_masts=True):
    deck = cq.Workplane("XY").box(7.0 * M, 13.0 * M, 120).translate(((1.25 + 3.5) * M, 0, H.Z_DECK * M - 60)).cut(
        cq.Workplane("XY").circle(H.R_BEAM_DECK * M).extrude(400).translate((1.25 * M, 0, H.Z_DECK * M - 200)))
    sc.add(deck.val(), "roof deck z 5.0 with the beam hole r 0.9 at the wall line", COL["ctx"], tol=3.0)
    sc.add(cq.Workplane("XY").box(250, 13.0 * M, 4.0 * M).translate((1.125 * M, 0, 3.0 * M)).val(), "south wall (x 1.0..1.25), courtyard beyond", COL["ctx"], tol=3.0)
    sc.add(cyl(0.9 * M, (1.25 * M, 0, 0.14 * M), (1.25 * M, 0, H.Z_DECK * M - 120)).cut(cyl(0.88 * M, (1.25 * M, 0, 0.13 * M), (1.25 * M, 0, H.Z_DECK * M))), "beam column below the deck to the turn (schematic)", COL["ctx"], tol=3.0)
    sc.add(disc(1.0 * M, (1.25 * M, 0, 0.14 * M), (-1, 0, 1)), "M4 ellipsoid patch at the turn (schematic disc)", COL["mirror"], tol=3.0)
    sc.add(cyl(0.42 * M, (0.42 * M, 0, -0.8 * M), (0.42 * M, 0, 0.3 * M)).cut(cyl(0.39 * M, (0.42 * M, 0, -0.78 * M), (0.42 * M, 0, 0.31 * M))), "tandoor pot", COL["rim"], tol=3.0)
    F = H.F * M
    sc.add(cq.Solid.makeSphere(60, V(*F)), "F, the fixed focus", COL["mirror"], tol=2.0)
    sc.parts.append(dict(name="F-F2 axis (vertical bore line) and F2", color=COL["sun"], lines=[[F.tolist(), [1.25 * M, 0, 0.14 * M]]]))
    sc.add(cq.Solid.makeSphere(40, V(1.25 * M, 0, 6.14 * M)), "F2", COL["mirror"], tol=2.0)
    if with_masts:
        y_m, h_top = 5.2 * M, 10.5 * M
        for y in (-y_m, y_m):
            sc.add(cyl(0.30 * M, (1.25 * M, y, H.Z_DECK * M), (1.25 * M, y, h_top)), "mast, inflated r 0.30 m at 1 bar (pneumatic F support)", COL["fabric"], tol=3.0)
        sc.parts.append(dict(name="F suspension: cable between the mast tops through F, south guy to the courtyard", color=COL["cable"],
                             lines=[[[1.25 * M, -y_m, h_top], F.tolist()], [[1.25 * M, y_m, h_top], F.tolist()], [F.tolist(), [-3.0 * M, 0, 1.0 * M]]]))
    # the env's own F support, drawn as context: arm from a tower 3 m north
    sc.parts.append(dict(name="env's F support (context): arm to a tower at x 4.25, which the sweep shows inside the dish", color=COL["ctx"],
                         lines=[[F.tolist(), [4.25 * M, 0, F[2]]], [[4.25 * M, 0, H.Z_DECK * M], [4.25 * M, 0, F[2]]]]))

def add_dish(sc, p, tag="", full=True):
    s = p["s"]; Vx = p["V"] * M; el = p["el"]
    xl, yl, zl = dish_frame(s); Mx = frame_matrix(Vx, xl, yl, zl)
    slot_open = np.degrees(el) > 54.0
    skin, sag = cap_shell(H.R_SPH * M, H.A_DISH * M, H.R_HOLE * M, H.W_SLOT * M if slot_open else 0.0)
    r_t = 60.0
    parts = [(skin, f"membrane: sphere R 8.2 m, a 2.1 m, hole r 0.5, slot 0.7 {'open' if slot_open else 'closed by flaps'}{tag}", COL["skin"]),
             (cq.Solid.makeTorus(H.A_DISH * M + r_t, r_t, V(0, 0, sag), V(0, 0, 1)), f"inflated rim toroid{tag}", COL["rim"]),
             (disc(H.A_DISH * M, (0, 0, -250), (0, 0, 1), 4.0).cut(cq.Solid.makeCylinder(H.R_HOLE * M, 400, V(0, 0, -450), V(0, 0, 1))), f"back plenum film (5 pressure zones){tag}", COL["skin"]),
             (cq.Solid.makeTorus(1.2 * M, 30, V(0, 0, -300), V(0, 0, 1)), f"back ring r 1.2 m (attitude tendons){tag}", COL["rim"]),
             (cq.Solid.makeTorus(H.R_RING * M, 25, V(0, 0, -150), V(0, 0, 1)), f"spreader ring r 0.8 m (rod tip){tag}", COL["rim"])]
    for shp, name, col in parts:
        sc.add(shp.transformShape(Mx), name, col, tol=2.5 if full else 6.0)
    # sun direction
    sc.parts.append(dict(name=f"sun direction{tag}", color=COL["sun"], lines=[[(Vx + 2.6 * M * s).tolist(), (Vx + 5.0 * M * s).tolist()]]))
    return Mx, sag

def add_mount(sc, p, tag=""):
    s = p["s"]; tip = H.tip_point(p) * M; root = H.ROOT * M
    d = tip - root; L = np.linalg.norm(d); u = d / L
    # root bend: a short arc from vertical to the rod direction, then the straight everted rod
    ang = np.arccos(np.clip(u[2], -1, 1)); Lb = 0.5 * M
    if ang > 1e-3:
        axis = np.cross([0, 0, 1.0], u); axis /= np.linalg.norm(axis); Rb = Lb / ang
        centre = root + Rb * np.cross(axis, [0, 0, 1.0]) * -1.0
        def P(t):
            v0 = root - centre
            return centre + v0 * np.cos(t) + np.cross(axis, v0) * np.sin(t)
        segs = [cyl(0.30 * M, P(ang * i / 6), P(ang * (i + 1) / 6)) for i in range(6)]
        end = P(ang)
    else:
        segs = [cyl(0.30 * M, root, root + [0, 0, Lb])]; end = root + np.array([0, 0, Lb])
    sc.add(cq.Compound.makeCompound(segs), f"root bend (vine section){tag}", COL["fabric"], tol=3.0)
    sc.add(cyl(0.30 * M, end, tip), f"vine rod r 0.30 m at 0.17 bar, everted from the reel ({L / M:.2f} m here){tag}", COL["fabric"], tol=3.0)
    sc.add(cq.Workplane("XY").box(900, 900, 700).translate((root[0], root[1], root[2] - 350)).val(), f"reel housing under the root (the inverted hose){tag}", COL["ctx"], tol=3.0)
    # deck tendons: from three points on the spreader ring to the winches
    xl, yl, zl = dish_frame(s); Vx = p["V"] * M
    ring_pts = [Vx - 150 * zl + H.R_RING * M * (np.cos(a) * xl + np.sin(a) * yl) for a in np.radians([90, 210, 330])]
    lines = []
    for w in H.WINCH:
        wm = w * M; k = int(np.argmin([np.linalg.norm(rp - wm) for rp in ring_pts]))
        lines.append([ring_pts[k].tolist(), wm.tolist()])
        sc.add(cyl(120, wm, wm + [0, 0, 200]), f"deck winch{tag}", COL["fabric"], tol=3.0)
    sc.parts.append(dict(name=f"deck tendons to three winches at r 7 m{tag}", color=COL["cable"], lines=lines))
    # attitude tendons: from a collar 0.5 m down the rod to the back ring
    collar = tip - 0.5 * M * u
    back_pts = [Vx - 300 * zl + 1.2 * M * (np.cos(a) * xl + np.sin(a) * yl) for a in np.radians([30, 150, 270])]
    sc.parts.append(dict(name=f"attitude tendons: rod collar to the back ring{tag}", color=COL["cable"], lines=[[collar.tolist(), b.tolist()] for b in back_pts]))

def add_beam(sc, p, sag, tag=""):
    s = p["s"]; Vx = p["V"] * M; F = H.F * M; F2 = np.array([1.25, 0, 6.14]) * M
    xl, yl, zl = dish_frame(s)
    lines = []
    for a in np.radians(np.arange(0, 360, 45)):
        rim = Vx + sag * zl + H.A_DISH * M * (np.cos(a) * xl + np.sin(a) * yl)
        hit = rim + (F - rim) * (1 - 0.8 * M / np.linalg.norm(F - rim))       # stop 0.8 m before F: the strip
        lines.append([rim.tolist(), hit.tolist()]); lines.append([hit.tolist(), F2.tolist()])
    for a in np.radians(np.arange(0, 360, 90)):
        q = np.array([1.25 * M + 0.9 * M * np.cos(a), 0.9 * M * np.sin(a), 0.14 * M])
        lines.append([F2.tolist(), q.tolist()])
    lines.append([[1.25 * M, 0, 0.14 * M], [0.42 * M, 0, 0.14 * M]])
    sc.parts.append(dict(name=f"beam: rim -> strip -> F2 -> down the column -> M4 -> duct{tag}", color=COL["beam"], lines=lines))
    sc.parts.append(dict(name=f"hyperboloid strip (F sheet, theta 10-110 deg, width 1.1 x r){tag}", color=COL["mirror"], lines=strip_lines(s)))

def full_scene(doy, hour, path):
    el, A, s = H.sun(doy, hour); p = dict(el=el, A=A, s=s, V=H.F - H.G_ORBIT * s)
    sc = Scene(); scene_common(sc); Mx, sag = add_dish(sc, p); add_mount(sc, p); add_beam(sc, p, sag); sc.write(path)
    return p

if __name__ == "__main__":
    full_scene(80, 12.0, os.path.join(OUT, "hp_equinox_noon.json"))
    full_scene(172, 12.0, os.path.join(OUT, "hp_summer_noon.json"))
    full_scene(80, 9.0, os.path.join(OUT, "hp_morning.json"))
    sc = Scene(); scene_common(sc, with_masts=True)
    for hour in (7.0, 8.0, 9.5, 11.0, 12.0, 13.0, 14.5, 16.0, 17.0):
        el, A, s = H.sun(80, hour)
        if el < H.EL_MIN: continue
        p = dict(el=el, A=A, s=s, V=H.F - H.G_ORBIT * s)
        Vx = p["V"] * M; xl, yl, zl = dish_frame(s); Mx = frame_matrix(Vx, xl, yl, zl)
        sc.add(cq.Solid.makeTorus(H.A_DISH * M, 25, V(0, 0, 0), V(0, 0, 1)).transformShape(Mx), f"rim at {hour:.1f} h (equinox)", COL["rim"], tol=6.0)
        tip = H.tip_point(p) * M
        sc.parts.append(dict(name="rod at each hour", color=COL["fabric"], lines=[[(H.ROOT * M).tolist(), tip.tolist()]]))
    sc.write(os.path.join(OUT, "hp_sweep.json"))

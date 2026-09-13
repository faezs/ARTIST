#!/usr/bin/env python
"""CadQuery model (mm, env frame) of the Cassegrain Hashemi machine on the screw-designed mount:
focal tube through the slot carrying the strip and the bridle apex at F (Hashemi's near method), four bridle
wires through F from an outrigger ring, the flexing vine stem clamped to the dish's back ring, two antagonist
tendons to courtyard winches. Scenes: equinox noon, summer noon, an equinox morning, the equinox sweep.
Geometry from physics_hp / screw_mount so the drawing and the numbers agree.
"""
import os, sys, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); ROOTDIR = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOTDIR, "3d")); sys.path.insert(0, HERE)
from mesh_export import Scene
import physics_hp as H, screw_mount as S
from model_hp import cyl, disc, frame_matrix, dish_frame, cap_shell, strip_lines, COL, M
COL = dict(COL); COL["cable"] = "#2563eb"; COL["rod"] = "#15803d"; COL["colm"] = "#b45309"   # cables blue, fine-stage rods green, water columns brown
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
V = cq.Vector
R_STEM, P_STEM = 1.00, 0.8          # m, bar: the stem alone (no tendons) survives 25 m/s with SF ~1.9
R_ROD, R_ACT = 1.40, 1.60           # fine stage: tangential rods and water columns (m)
F = H.F * M; F2 = np.array([1.25, 0, 6.14]) * M

def scene_common(sc):
    deck = cq.Workplane("XY").box(7.0 * M, 13.0 * M, 120).translate(((1.25 + 3.5) * M, 0, H.Z_DECK * M - 60)).cut(
        cq.Workplane("XY").circle(H.R_BEAM_DECK * M).extrude(400).translate((1.25 * M, 0, H.Z_DECK * M - 200)))
    sc.add(deck.val(), "roof deck z 5.0 with the beam hole r 0.9 at the wall line", COL["ctx"], tol=3.0)
    sc.add(cq.Workplane("XY").box(250, 13.0 * M, 4.0 * M).translate((1.125 * M, 0, 3.0 * M)).val(), "south wall (x 1.0..1.25), courtyard beyond", COL["ctx"], tol=3.0)
    sc.add(cyl(0.9 * M, (1.25 * M, 0, 0.14 * M), (1.25 * M, 0, H.Z_DECK * M - 120)).cut(cyl(0.88 * M, (1.25 * M, 0, 0.13 * M), (1.25 * M, 0, H.Z_DECK * M))), "beam column below the deck to the turn (schematic)", COL["ctx"], tol=3.0)
    sc.add(disc(1.0 * M, (1.25 * M, 0, 0.14 * M), (-1, 0, 1)), "M4 ellipsoid patch at the turn (schematic disc)", COL["mirror"], tol=3.0)
    sc.add(cyl(0.42 * M, (0.42 * M, 0, -0.8 * M), (0.42 * M, 0, 0.3 * M)).cut(cyl(0.39 * M, (0.42 * M, 0, -0.78 * M), (0.42 * M, 0, 0.31 * M))), "tandoor pot", COL["rim"], tol=3.0)
    # the focal tube: bore casing continuing above the deck, r 0.9 -> 0.35 through the crossing band -> 0.45 to the strip
    z_lo, z_hi = 5.6 * M, 6.7 * M
    tube = cq.Solid.makeCone(0.9 * M, 0.35 * M, z_lo - H.Z_DECK * M, V(1.25 * M, 0, H.Z_DECK * M), V(0, 0, 1))
    tube = tube.fuse(cyl(0.35 * M, (1.25 * M, 0, z_lo), (1.25 * M, 0, z_hi)))
    tube = tube.fuse(cq.Solid.makeCone(0.35 * M, 0.45 * M, F[2] - 0.9 * M - z_hi, V(1.25 * M, 0, z_hi), V(0, 0, 1)))
    tube = tube.fuse(cyl(0.12 * M, (1.25 * M, 0, F[2] - 0.9 * M), (1.25 * M, 0, F[2] + 0.15 * M)))
    sc.add(tube, "focal tube (Hashemi's near method): bore casing r 0.9 -> 0.35 through the dish-crossing band -> 0.45 to the strip mount, spigot to F", COL["fabric"], tol=3.0)
    sc.add(cq.Solid.makeTorus(0.95 * M, 40, V(1.25 * M, 0, F[2] - 0.85 * M), V(0, 0, 1)), "strip bearing ring on the tube (turns with the sun's azimuth)", COL["rim"], tol=3.0)
    sc.add(cq.Solid.makeSphere(70, V(*F)), "F: bridle apex on the tube's spigot", COL["mirror"], tol=2.0)
    sc.add(cq.Solid.makeSphere(40, V(*F2)), "F2 (beam waist inside the tube)", COL["mirror"], tol=2.0)
    sc.parts.append(dict(name="F-F2 axis (vertical bore line)", color=COL["sun"], lines=[[F.tolist(), [1.25 * M, 0, 0.14 * M]]]))

def add_dish(sc, p, tag="", tol=2.5):
    s = p["s"]; Vx = p["V"] * M; el = p["el"]
    xl, yl, zl = dish_frame(s); Mx = frame_matrix(Vx, xl, yl, zl)
    slot_open = np.degrees(el) > 54.0
    skin, sag = cap_shell(H.R_SPH * M, H.A_DISH * M, H.R_HOLE * M, H.W_SLOT * M if slot_open else 0.0)
    r_t = 60.0
    parts = [(skin, f"membrane: sphere R 8.2 m, a 2.1 m, hole r 0.5, slot 0.7 {'open' if slot_open else 'closed by flaps'}{tag}", COL["skin"]),
             (cq.Solid.makeTorus(H.A_DISH * M + r_t, r_t, V(0, 0, sag), V(0, 0, 1)), f"inflated rim toroid{tag}", COL["rim"]),
             (disc(H.A_DISH * M, (0, 0, -250), (0, 0, 1), 4.0).cut(cq.Solid.makeCylinder(H.R_HOLE * M, 400, V(0, 0, -450), V(0, 0, 1))), f"back plenum film (5 pressure zones){tag}", COL["skin"]),
             (cq.Solid.makeTorus(R_ROD * M + 60, 40, V(0, 0, -300), V(0, 0, 1)), f"dish back ring r 1.46 m: the fine stage's moving side{tag}", COL["rim"]),
             # back frame (coarse stage's body): hub ring for the stem clamp, spokes, frame ring at r 1.75, outrigger ring r 3.2 for the bridle
             (cq.Solid.makeTorus(H.R_RING * M, 40, V(0, 0, -650), V(0, 0, 1)), f"back frame hub r 0.8 m: the stem's clamp{tag}", COL["fabric"]),
             (cq.Solid.makeTorus(1.75 * M, 40, V(0, 0, -650), V(0, 0, 1)), f"back frame ring r 1.75 m{tag}", COL["fabric"]),
             (cq.Solid.makeTorus(S.R_B * M, 30, V(0, 0, sag), V(0, 0, 1)), f"outrigger ring r 3.2 m on the back frame (bridle attachments){tag}", COL["fabric"])]
    for k in range(3):
        a = np.radians(90 + 120 * k)
        parts.append((cyl(30, (H.R_RING * M * np.cos(a), H.R_RING * M * np.sin(a), -650), (1.75 * M * np.cos(a), 1.75 * M * np.sin(a), -650)), f"back frame spoke{tag}", COL["fabric"]))
        parts.append((cyl(25, (1.75 * M * np.cos(a), 1.75 * M * np.sin(a), -650), (S.R_B * M * np.cos(a), S.R_B * M * np.sin(a), sag)), f"outrigger strut, outside the rim{tag}", COL["fabric"]))
    # fine stage: three tangential rods in the back plane z -300 (dish side) to posts on the frame; three water columns normal to the plane at r 1.6
    for k in range(3):
        a = np.radians(90 + 120 * k); t = np.array([-np.sin(a), np.cos(a), 0.0]); P = np.array([R_ROD * M * np.cos(a), R_ROD * M * np.sin(a), -300.0])
        parts.append((cyl(6, P, P + t * 900), f"fine stage: tangential rod d 12 mm x 0.9 m (in-plane constraint line){tag}", COL["rod"]))
        parts.append((cyl(40, P + t * 900 + [0, 0, 0], P + t * 900 + [0, 0, -350]), f"frame post for the rod{tag}", COL["fabric"]))
        b_ = np.radians(30 + 120 * k); Q = np.array([R_ACT * M * np.cos(b_), R_ACT * M * np.sin(b_), -300.0])
        parts.append((cyl(60, Q, Q + [0, 0, -350]), f"fine stage: water column d 0.12 m, stroke +-32 mm (displacement actuator, normal line){tag}", COL["colm"]))
    for shp, name, col in parts:
        sc.add(shp.transformShape(Mx), name, col, tol=tol)
    sc.parts.append(dict(name=f"sun direction{tag}", color=COL["sun"], lines=[[(Vx + 2.6 * M * s).tolist(), (Vx + 5.0 * M * s).tolist()]]))
    return sag

def add_mount(sc, p, tag=""):
    B, T, tip = S.members(p, []); s = p["s"]
    sc.parts.append(dict(name=f"bridle: four 8 mm wires through F (lines of the constraint space){tag}", color=COL["cable"], lines=[[(m["P"] * M).tolist(), F.tolist()] for m in B]))
    root = H.ROOT * M; tipm = tip * M; d = tipm - root; L = np.linalg.norm(d); u = d / L
    sc.add(cyl(R_STEM * M, root, tipm), f"stem r {R_STEM:.2f} m at {P_STEM} bar, clamped to the back frame hub; its bending couples are the coarse actuation ({L / M:.2f} m here){tag}", COL["fabric"], tol=3.0)
    sc.add(cq.Solid.makeTorus(R_STEM * M + 40, 40, V(*tipm), V(*u)), f"clamp collar at the stem tip{tag}", COL["rim"], tol=3.0)
    sc.add(cq.Workplane("XY").box(1.8 * M, 1.8 * M, 700).translate((root[0], root[1], root[2] - 350)).val(), f"root: reel housing and the clamped base{tag}", COL["ctx"], tol=3.0)

def add_beam(sc, p, sag, tag=""):
    s = p["s"]; Vx = p["V"] * M; xl, yl, zl = dish_frame(s); lines = []
    for a in np.radians(np.arange(0, 360, 45)):
        rim = Vx + sag * zl + H.A_DISH * M * (np.cos(a) * xl + np.sin(a) * yl)
        hit = rim + (F - rim) * (1 - 0.8 * M / np.linalg.norm(F - rim))
        lines.append([rim.tolist(), hit.tolist()]); lines.append([hit.tolist(), F2.tolist()])
    for a in np.radians(np.arange(0, 360, 90)):
        lines.append([F2.tolist(), [1.25 * M + 0.9 * M * np.cos(a), 0.9 * M * np.sin(a), 0.14 * M]])
    lines.append([[1.25 * M, 0, 0.14 * M], [0.42 * M, 0, 0.14 * M]])
    sc.parts.append(dict(name=f"beam: rim -> strip -> F2 -> down the tube -> M4 -> duct{tag}", color=COL["beam"], lines=lines))
    sc.parts.append(dict(name=f"hyperboloid strip (F sheet, within 0.8 m of the axis){tag}", color=COL["mirror"], lines=strip_lines(s)))

def full_scene(doy, hour, path):
    el, A, s = H.sun(doy, hour); p = dict(el=el, A=A, s=s, V=H.F - H.G_ORBIT * s)
    sc = Scene(); scene_common(sc); sag = add_dish(sc, p); add_mount(sc, p); add_beam(sc, p, sag); sc.write(path)

def fine_stage_scene(path):
    """The fine stage alone, dish axis +z, vertex at the origin: back plenum, dish back ring, rods, columns, back frame."""
    sc = Scene()
    p = dict(el=np.radians(90.0), A=0.0, s=np.array([0, 0, 1.0]), V=np.zeros(3))
    s = p["s"]; xl, yl, zl = np.array([1.0, 0, 0]), np.array([0, 1.0, 0]), np.array([0, 0, 1.0])
    sag = H.R_SPH * M - np.sqrt((H.R_SPH * M)**2 - (H.A_DISH * M)**2)
    sc.add(cq.Solid.makeTorus(H.A_DISH * M + 60, 60, V(0, 0, sag), V(0, 0, 1)), "inflated rim toroid", COL["rim"], tol=3.0)
    sc.add(disc(H.A_DISH * M, (0, 0, -250), (0, 0, 1), 4.0).cut(cq.Solid.makeCylinder(H.R_HOLE * M, 400, V(0, 0, -450), V(0, 0, 1))), "back plenum film (dish side of the fine stage)", COL["skin"], tol=3.0)
    sc.add(cq.Solid.makeTorus(R_ROD * M + 60, 40, V(0, 0, -300), V(0, 0, 1)), "dish back ring r 1.46 m: the moving side", COL["rim"], tol=3.0)
    sc.add(cq.Solid.makeTorus(H.R_RING * M, 40, V(0, 0, -650), V(0, 0, 1)), "back frame hub r 0.8 m (stem clamp)", COL["fabric"], tol=3.0)
    sc.add(cq.Solid.makeTorus(1.75 * M, 40, V(0, 0, -650), V(0, 0, 1)), "back frame ring r 1.75 m", COL["fabric"], tol=3.0)
    for k in range(3):
        a = np.radians(90 + 120 * k)
        sc.add(cyl(30, (H.R_RING * M * np.cos(a), H.R_RING * M * np.sin(a), -650), (1.75 * M * np.cos(a), 1.75 * M * np.sin(a), -650)), "back frame spoke", COL["fabric"], tol=3.0)
        t = np.array([-np.sin(a), np.cos(a), 0.0]); P = np.array([R_ROD * M * np.cos(a), R_ROD * M * np.sin(a), -300.0])
        sc.add(cyl(6, P, P + t * 900), "tangential rod d 12 mm x 0.9 m: one constraint line in the back plane (3)", COL["rod"], tol=1.0)
        sc.add(cyl(40, P + t * 900, P + t * 900 + [0, 0, -350]), "frame post for the rod's far end", COL["fabric"], tol=3.0)
        b_ = np.radians(30 + 120 * k); Q = np.array([R_ACT * M * np.cos(b_), R_ACT * M * np.sin(b_), -300.0])
        sc.add(cyl(60, Q, Q + [0, 0, -350]), "water column d 0.12 m, stroke +-32 mm: displacement actuator on a normal line (3)", COL["colm"], tol=2.0)
        sc.add(cyl(75, Q + [0, 0, -350], Q + [0, 0, -420]), "column base on the frame ring", COL["fabric"], tol=3.0)
    sc.add(cyl(R_STEM * M, (0.4 * M, 0, -650 - 0.3 * M), (1.2 * M, 0, -650 - 3.0 * M)), "stem (stub) leaving the hub toward the root", COL["fabric"], tol=4.0)
    sc.parts.append(dict(name="dish axis (to the sun) and the back plane's two rotation axes through the vertex", color=COL["sun"],
                         lines=[[[0, 0, -900], [0, 0, 900]], [[-2000, 0, 0], [2000, 0, 0]], [[0, -2000, 0], [0, 2000, 0]]]))
    sc.write(path)

if __name__ == "__main__":
    fine_stage_scene(os.path.join(OUT, "hp2_fine_stage.json"))
    full_scene(80, 12.0, os.path.join(OUT, "hp2_equinox_noon.json"))
    full_scene(172, 12.0, os.path.join(OUT, "hp2_summer_noon.json"))
    full_scene(80, 9.0, os.path.join(OUT, "hp2_morning.json"))
    sc = Scene(); scene_common(sc)
    for hour in (7.0, 8.0, 9.5, 11.0, 12.0, 13.0, 14.5, 16.0, 17.0):
        el, A, s = H.sun(80, hour)
        if el < H.EL_MIN: continue
        p = dict(el=el, A=A, s=s, V=H.F - H.G_ORBIT * s)
        Vx = p["V"] * M; xl, yl, zl = dish_frame(s); Mx = frame_matrix(Vx, xl, yl, zl)
        sc.add(cq.Solid.makeTorus(H.A_DISH * M, 25, V(0, 0, 0), V(0, 0, 1)).transformShape(Mx), f"rim at {hour:.1f} h (equinox)", COL["rim"], tol=6.0)
        B, T, tip = S.members(p)
        sc.parts.append(dict(name="stem axis at each hour", color=COL["fabric"], lines=[[(H.ROOT * M).tolist(), (tip * M).tolist()]]))
        sc.parts.append(dict(name="bridle at each hour", color=COL["cable"], lines=[[(m["P"] * M).tolist(), F.tolist()] for m in B]))
    sc.write(os.path.join(OUT, "hp2_sweep.json"))

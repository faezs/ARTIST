#!/usr/bin/env python
"""CadQuery model (mm, env frame) of the FACT mount: the fork on the deck ring (azimuth), two two-stage cross-blade
flexural pivots on the elevation axis through F outside the aperture, the cradle (side arms, back frame,
counterweights), the tangential-blade diaphragm fine stage, the cass machine's dish, tube and strip as context.
Every member comes from geometry.cradle_segments, the same list synth.py checks for clearance."""
import os, sys, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); ROOTDIR = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOTDIR, "3d")); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, HERE)
from mesh_export import Scene
import physics_hp as H
import geometry as GM
from model_hp import cyl, disc, frame_matrix, cap_shell, strip_lines, COL, M
COL = dict(COL); COL.update(blade="#c2410c", strut="#475569", water="#1d4ed8", frame="#334155", fine="#15803d", flex="#b45309", post="#1f2937", jack="#6d28d9")
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
V = cq.Vector
F = H.F * M; F2 = np.array([1.25, 0, 6.14]) * M
NAMES = {"post": ("post 250 x 8 from the ring beam to the elevation axis", COL["post"]), "arm": ("side arm 150 x 5 along the dish axis at |y| 2.45 m, outside the rim", COL["frame"]),
         "tank": ("water tank 91 L: balance and turgor trim", COL["water"]), "crank": ("crank 1.0 m on the arm", COL["frame"]), "jack": ("screw jack Tr40, self-locking, 1.2 m stroke", COL["jack"]),
         "jack bracket": ("jack bracket on the post", COL["post"]), "frame spoke": ("back frame spoke to the arm", COL["frame"]), "frame diagonal": ("back frame diagonal", COL["frame"]),
         "back frame ring": ("back frame C-ring r 1.75 m, open 80 deg at the slot", COL["frame"]), "dish back ring": ("dish back C-ring r 1.46 m (fine stage, moving side)", COL["rim"]),
         "fine stage post": ("post to the back frame (blade's far end)", COL["frame"]), "water column": ("water column d 0.12 m: displacement actuator, 62 urad per mL", COL["water"])}

def box(lx, ly, lz, centre, rot_axis=None, rot_deg=0.0):
    b = cq.Workplane("XY").box(lx, ly, lz).val()
    if rot_deg: b = b.rotate(V(0, 0, 0), V(*rot_axis), rot_deg)
    return b.translate(V(*centre))

def block_parts(tag=""):
    """one trunnion block in its local frame (mm): axis = y through the origin, +y outboard (post side); ground bars under stage A (outboard),
    the intermediate bar above both stages, the moving bar under stage B (inboard) with its clamp to the arm."""
    P = []; ys = GM.Y_STAGE * M; pitch = GM.PITCH * M; wb, tb, lb = GM.W_B * M, GM.T_B * M, GM.L_B * M
    for y0 in (+ys, -ys):
        for i in range(GM.N_CELL):
            y = y0 + (i - (GM.N_CELL - 1) / 2) * pitch
            for sgn in (+1, -1):
                P.append((box(lb, wb, tb, (0, y, 0), (0, 1, 0), 45 * sgn), f"pivot blade 17-7PH {wb:.0f} x {tb:.1f} x {lb:.0f} mm, plane through the elevation axis{tag}", COL["blade"]))
    span = (GM.N_CELL - 1) * pitch + wb + 40
    P.append((box(80, span, 40, (0, +ys, -62)), f"ground bar under stage A (on the post){tag}", COL["post"]))
    P.append((box(80, 2 * ys + span, 40, (0, 0, +62)), f"intermediate bar over both stages{tag}", COL["frame"]))
    P.append((box(80, span, 40, (0, -ys, -62)), f"moving bar under stage B (to the arm){tag}", COL["frame"]))
    return P

def c_ring(centre, xl, yl, zl, R, r, gap_deg):
    """partial torus (one solid) of major radius R, tube r, about zl through centre, open +-gap_deg about +xl"""
    ring = cq.Workplane("XZ").center(R, 0).circle(r).revolve(360 - 2 * gap_deg, (-R, 0, 0), (-R, 1, 0)).val()
    ring = ring.rotate(V(0, 0, 0), V(0, 0, 1), gap_deg)            # revolve starts at +x: shift so the gap is centred on +x
    return ring.transformShape(frame_matrix(np.asarray(centre, float), np.asarray(xl, float), np.asarray(yl, float), np.asarray(zl, float)))

def add_ground(sc, with_wall=True):
    deck = cq.Workplane("XY").box(7.0 * M, 13.0 * M, 120).translate(((1.25 + 3.5) * M, 0, H.Z_DECK * M - 60)).cut(cq.Workplane("XY").circle(0.9 * M).extrude(400).translate((1.25 * M, 0, H.Z_DECK * M - 200)))
    sc.add(deck.val(), "roof deck z 5.0 with the beam hole", COL["ctx"], tol=3.0)
    if with_wall: sc.add(cq.Workplane("XY").box(250, 13.0 * M, 4.0 * M).translate((1.125 * M, 0, 3.0 * M)).val(), "south wall", COL["ctx"], tol=3.0)
    sc.add(cyl(0.9 * M, (1.25 * M, 0, 0.14 * M), (1.25 * M, 0, H.Z_DECK * M - 120)).cut(cyl(0.88 * M, (1.25 * M, 0, 0.13 * M), (1.25 * M, 0, H.Z_DECK * M))), "beam column below the deck", COL["ctx"], tol=3.0)
    sc.add(disc(1.0 * M, (1.25 * M, 0, 0.14 * M), (-1, 0, 1)), "M4 (schematic)", COL["mirror"], tol=3.0)
    sc.add(cyl(0.42 * M, (0.42 * M, 0, -0.8 * M), (0.42 * M, 0, 0.3 * M)).cut(cyl(0.39 * M, (0.42 * M, 0, -0.78 * M), (0.42 * M, 0, 0.31 * M))), "tandoor pot", COL["rim"], tol=3.0)
    z_lo, z_hi = 5.6 * M, 6.7 * M
    tube = cq.Solid.makeCone(0.9 * M, 0.35 * M, z_lo - H.Z_DECK * M, V(1.25 * M, 0, H.Z_DECK * M), V(0, 0, 1)).fuse(cyl(0.35 * M, (1.25 * M, 0, z_lo), (1.25 * M, 0, z_hi)))
    tube = tube.fuse(cq.Solid.makeCone(0.35 * M, 0.45 * M, F[2] - 900 - z_hi, V(1.25 * M, 0, z_hi), V(0, 0, 1)))
    sc.add(tube, "focal tube (cass machine, Hashemi's near method): the ground", COL["fabric"], tol=3.0)
    sc.add(cq.Solid.makeTorus(0.5 * M, 50, V(1.25 * M, 0, F[2] - 880), V(0, 0, 1)), "strip ring at the tube top (cass machine), slaved to the fork in azimuth", COL["rim"], tol=3.0)
    sc.add(cq.Solid.makeTorus(GM.R_RAIL * M, 60, V(1.25 * M, 0, H.Z_DECK * M + 60), V(0, 0, 1)), "deck ring rail r 3.61 m (Hashemi's ring rail): the ground", COL["ctx"], tol=3.0)
    sc.add(cq.Solid.makeTorus(GM.R_RAIL * M, 75, V(1.25 * M, 0, GM.Z_RAIL * M), V(0, 0, 1)), "ring beam 150 x 5 on rollers: the fork's base, azimuth", COL["post"], tol=3.0)
    sc.add(cq.Solid.makeSphere(50, V(*F)), "F", COL["mirror"], tol=2.0); sc.add(cq.Solid.makeSphere(40, V(*F2)), "F2", COL["mirror"], tol=2.0)

def add_mount(sc, el, A, tag="", with_blocks=True):
    s, h, e, n = GM.frame(el, A)
    for p0, p1, r, name in GM.cradle_segments(el, A):
        if name in ("back frame ring", "dish back ring"): continue
        label, col = NAMES[name]; sc.add(cyl(r * M, p0 * M, p1 * M), label + tag, col, tol=2.5)
    xl, yl, zl = -n, e, s; Vx = (H.F - H.G_ORBIT * s) * M
    sc.add(c_ring(Vx - GM.D_FRAME * M * zl, xl, yl, zl, GM.R_FRAME * M, 40, GM.GAP_FRAME), NAMES["back frame ring"][0] + tag, NAMES["back frame ring"][1], tol=2.5)
    sc.add(c_ring(Vx - GM.D_RING * M * zl, xl, yl, zl, GM.R_RING * M, 40, GM.GAP_RING), NAMES["dish back ring"][0] + tag, NAMES["dish back ring"][1], tol=2.5)
    for sg in (+1, -1):
        T = F + sg * GM.Y_T * M * e
        if with_blocks:
            R = np.column_stack([h, sg * e, [0, 0, 1.0]]); Mx = frame_matrix(T, R[:, 0], R[:, 1], R[:, 2])
            for shp, name, col in block_parts(tag): sc.add(shp.transformShape(Mx), name, col, tol=1.0)
        # post top: saddle and two uprights to the ground bar; arm clamp from the moving bar
        top = np.array([F[0], F[1], GM.Z_POST_TOP * M]) + sg * GM.Y_POST * M * e
        sc.add(box(300, 700, 40, top + [0, 0, 20], (0, 0, 1), np.degrees(A) + 90).translate(V(*(-sg * 0.10 * M * e))), "post saddle" + tag, COL["post"], tol=2.0)
        for dy in (GM.Y_STAGE - 0.25, GM.Y_STAGE + 0.25):
            c = T + sg * dy * M * e + [0, 0, -(350 + 82) / 2]
            sc.add(box(60, 60, 350 - 82, c), "post upright to the ground bar" + tag, COL["post"], tol=2.0)
        c1 = T - sg * (GM.Y_STAGE + 0.25) * M * e + [0, 0, -62]; c2 = F + sg * GM.Y_ARM * M * e + [0, 0, -62]
        sc.add(cyl(30, c1, c2), "arm clamp from the moving bar" + tag, COL["frame"], tol=2.0)
        sc.add(cyl(30, c2, F + sg * GM.Y_ARM * M * e), "arm clamp from the moving bar" + tag, COL["frame"], tol=2.0)
    sc.parts.append(dict(name="F-F2 axis (vertical) and the elevation axis (horizontal through F)" + tag, color=COL["sun"], lines=[[F.tolist(), [1.25 * M, 0, 0.14 * M]], [(F - 4.2 * M * e).tolist(), (F + 4.2 * M * e).tolist()]]))

def add_dish(sc, el, A, tag="", full=True):
    s, h, e, n = GM.frame(el, A); xl, yl, zl = -n, e, s; Vx = (H.F - H.G_ORBIT * s) * M; Mx = frame_matrix(Vx, xl, yl, zl)
    sag = H.SAG * M; parts = []
    if full:
        parts += [(disc(H.A_DISH * M, (0, 0, -250), (0, 0, 1), 4.0).cut(cq.Solid.makeCylinder(H.R_HOLE * M, 400, V(0, 0, -450), V(0, 0, 1))), "back plenum film", COL["skin"])]
        skin, _ = cap_shell(H.R_SPH * M, H.A_DISH * M, H.R_HOLE * M, H.W_SLOT * M if np.degrees(el) > 54 else 0.0)
        parts.append((skin, "membrane: sphere R 8.2 m, a 2.1 m, hole and slot (cass machine)", COL["skin"]))
    parts.append((cq.Solid.makeTorus(H.A_DISH * M + 60, 60, V(0, 0, sag), V(0, 0, 1)), "inflated rim toroid (cass machine)", COL["rim"]))
    if full: parts += fine_stage_parts()
    for shp, name, col in parts: sc.add(shp.transformShape(Mx), name + tag, col, tol=2.5)

def fine_stage_parts():
    """dish frame, vertex at origin: three flat tangential blades in the back plane z = -300, flexure struts on the normals; posts and columns are drawn by cradle_segments"""
    P = []; zr = -GM.D_RING * M
    for a in GM.STATIONS:
        ar = np.radians(a); t = np.array([-np.sin(ar), np.cos(ar), 0.0]); rad = np.array([np.cos(ar), np.sin(ar), 0.0])
        c = rad * GM.R_RING * M + t * 225 + [0, 0, zr]
        P.append((cq.Workplane("XY").box(450, 60, 1.5).val().rotate(V(0, 0, 0), V(0, 0, 1), a + 90).translate(V(*c)), "fine stage: flat tangential blade 450 x 60 x 1.5 mm in the back plane", COL["fine"]))
    for a in GM.COLUMNS:
        ar = np.radians(a); Q = np.array([GM.R_ACT * M * np.cos(ar), GM.R_ACT * M * np.sin(ar), zr])
        P.append((cyl(4, Q + [0, 0, 60], Q + [0, 0, 20]), "flexure neck", COL["flex"]))
        P.append((cyl(12, Q + [0, 0, 20], Q + [0, 0, -40]), "flexure strut on the normal: a pure-force line of the actuation space", COL["flex"]))
        P.append((cyl(4, Q + [0, 0, -40], Q + [0, 0, -80]), "flexure neck", COL["flex"]))
        P.append((cyl(30, Q + [0, 0, 60], Q + [0, 0, 90]), "strut foot on the dish back ring", COL["rim"]))
    return P

def add_beam(sc, el, A, tag=""):
    s, h, e, n = GM.frame(el, A); xl, yl, zl = -n, e, s; Vx = (H.F - H.G_ORBIT * s) * M; sag = H.SAG * M; lines = []
    for a in np.radians(np.arange(0, 360, 45)):
        rim = Vx + sag * zl + H.A_DISH * M * (np.cos(a) * xl + np.sin(a) * yl); hit = rim + (F - rim) * (1 - 800 / np.linalg.norm(F - rim))
        lines.append([rim.tolist(), hit.tolist()]); lines.append([hit.tolist(), F2.tolist()])
    for a in np.radians(np.arange(0, 360, 90)): lines.append([F2.tolist(), [1.25 * M + 900 * np.cos(a), 900 * np.sin(a), 140]])
    sc.parts.append(dict(name="beam: rim -> strip -> F2 -> down the tube -> M4" + tag, color=COL["beam"], lines=lines))
    sc.parts.append(dict(name="hyperboloid strip (cass machine, on its ring)" + tag, color=COL["mirror"], lines=strip_lines(s)))
    sc.parts.append(dict(name="sun direction" + tag, color=COL["sun"], lines=[[(Vx + 2.6 * M * s).tolist(), (Vx + 5.2 * M * s).tolist()]]))

def machine(doy, hour, path):
    el, A, s = H.sun(doy, hour); sc = Scene(); add_ground(sc); add_mount(sc, el, A); add_dish(sc, el, A); add_beam(sc, el, A); sc.write(path)
    return el, A

if __name__ == "__main__":
    machine(80, 12.0, os.path.join(OUT, "fm_machine.json"))
    machine(172, 12.0, os.path.join(OUT, "fm_summer.json"))
    machine(80, 9.0, os.path.join(OUT, "fm_morning.json"))
    # the day: rims, arms, posts and axis at each hour
    sc = Scene(); add_ground(sc, with_wall=False)
    for hour in np.arange(8.0, 16.01, 1.0):
        el, A, s = H.sun(80, hour); sg = f" H{int(hour):02d}"
        s_, h, e, n = GM.frame(el, A); lines = []
        for p0, p1, r, name in GM.cradle_segments(el, A):
            if name in ("arm", "post"): lines.append([(p0 * M).tolist(), (p1 * M).tolist()])
        sc.parts.append(dict(name="arms and posts" + sg, color=COL["frame"], lines=lines))
        sc.parts.append(dict(name="elevation axis through F" + sg, color=COL["sun"], lines=[[(F - 4.2 * M * e).tolist(), (F + 4.2 * M * e).tolist()]]))
        add_dish(sc, el, A, tag=sg, full=False)
    sc.write(os.path.join(OUT, "fm_sweep.json"))
    # one trunnion block with the post top and the arm clamp, block frame (mm): +y outboard
    sc = Scene()
    for shp, name, col in block_parts(): sc.add(shp, name, col, tol=0.5)
    top_y = (GM.Y_POST - GM.Y_T) * M
    sc.add(cyl(GM.R_POST * M, (0, top_y, -1200), (0, top_y, -350)), "post 250 x 8 (top)", COL["post"], tol=2.0)
    sc.add(box(300, 700, 40, (0, top_y - 100, -330)), "post saddle", COL["post"], tol=1.0)
    for dy in (GM.Y_STAGE - 0.25, GM.Y_STAGE + 0.25): sc.add(box(60, 60, 350 - 82, (0, dy * M, -(350 + 82) / 2)), "post upright to the ground bar", COL["post"], tol=1.0)
    ya = -(GM.Y_T - GM.Y_ARM) * M
    sc.add(cyl(30, (0, -(GM.Y_STAGE + 0.25) * M, -62), (0, ya, -62)), "arm clamp from the moving bar", COL["frame"], tol=1.0)
    sc.add(cyl(30, (0, ya, -62), (0, ya, 0)), "arm clamp from the moving bar", COL["frame"], tol=1.0)
    sc.add(cyl(GM.R_ARM * M, (-900, ya, 0), (900, ya, 0)), "side arm (stub)", COL["frame"], tol=2.0)
    sc.add(cq.Solid.makeSphere(15, V(0, 0, 0)), "the elevation axis, which passes through F 3.25 m inboard", COL["mirror"], tol=1.0)
    sc.parts.append(dict(name="elevation axis through F", color=COL["sun"], lines=[[[0, -1400, 0], [0, 1000, 0]]]))
    sc.write(os.path.join(OUT, "fm_pivot.json"))
    # fine stage in the dish frame with its C-rings, posts and columns
    el, A, s = H.sun(80, 12.0); sc = Scene()
    for shp, name, col in fine_stage_parts(): sc.add(shp, name, col, tol=1.0)
    s_, h, e, n = GM.frame(el, A); xl, yl, zl = -n, e, s; Vx = H.F - H.G_ORBIT * s
    Rinv = np.column_stack([xl, yl, zl]).T
    for p0, p1, r, name in GM.cradle_segments(el, A):
        if name in ("fine stage post", "water column", "frame spoke", "frame diagonal"):
            q0, q1 = Rinv @ (p0 - Vx) * M, Rinv @ (p1 - Vx) * M; label, col = NAMES[name]; sc.add(cyl(r * M, q0, q1), label, col, tol=1.5)
    sc.add(c_ring((0, 0, -GM.D_FRAME * M), (1, 0, 0), (0, 1, 0), (0, 0, 1), GM.R_FRAME * M, 40, GM.GAP_FRAME), NAMES["back frame ring"][0], NAMES["back frame ring"][1], tol=1.5)
    sc.add(c_ring((0, 0, -GM.D_RING * M), (1, 0, 0), (0, 1, 0), (0, 0, 1), GM.R_RING * M, 40, GM.GAP_RING), NAMES["dish back ring"][0], NAMES["dish back ring"][1], tol=1.5)
    sc.add(disc(H.A_DISH * M, (0, 0, -250), (0, 0, 1), 4.0).cut(cq.Solid.makeCylinder(H.R_HOLE * M, 400, V(0, 0, -450), V(0, 0, 1))), "back plenum film", COL["skin"], tol=3.0)
    sc.parts.append(dict(name="dish axis and the back plane's rotation axes through the vertex; the slot direction is +x", color=COL["sun"], lines=[[[0, 0, -900], [0, 0, 600]], [[-2000, 0, 0], [2000, 0, 0]], [[0, -2000, 0], [0, 2000, 0]]]))
    sc.write(os.path.join(OUT, "fm_fine.json"))
    print("scenes written")

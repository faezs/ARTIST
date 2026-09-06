#!/usr/bin/env python
"""CadQuery model (mm, env frame) of the fourth pass: everything behind the dish. A Cassegrain head (pumped membrane
with a 0.12 m hole, a conical style carrying the hyperboloid secondary inside its own shadow, M3 at the neck) on a
short frame with the diaphragm fine stage, hung from a two-stage hollow cartwheel flexure pivot on the neck axis, on
a single stalk beside the dish axis; the beam goes back through the hole, along the neck axis through the pivot to
M4 at the stalk, and down the stalk to the cass machine's F2 and its underground relay. Scenes: equinox noon,
summer noon, morning, the day's sweep, the pivot, the head."""
import os, sys, json, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); ROOTDIR = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOTDIR, "3d")); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, os.path.join(HERE, "..", "fact_mount"))
from mesh_export import Scene
import physics_hp as H, geometry as GM
from model_hp import cyl, disc, frame_matrix, cap_shell, COL, M
from model import box, c_ring, fine_stage_parts
COL = dict(COL); COL.update(blade="#c2410c", frame="#334155", water="#1d4ed8", fine="#15803d", flex="#b45309", post="#1f2937", jack="#6d28d9", style="#0f766e", mirror2="#9333ea")
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True); V = cq.Vector
O = json.load(open(os.path.join(OUT, "optics.json")))
S_XY = np.array([1.25, 0.0]); Z_NECK = O["z_neck"]; NECK, OFF = O["NECK"], O["OFF"]; R_SEC, D_SEC, R_HOLE = O["r_sec"], O["D_SEC"], O["r_hole"]
F2_CASS = np.array([1.25, 0, 6.14]) * M; Z = np.array([0, 0, 1.0])
R_IN, R_OUT, PIV_C, PIV_HALF = 0.33, 0.45, 0.7, 0.30            # hollow cartwheel: radii, centre along e from the stalk, half-length

def frame(el, A):
    s, h, e, n = GM.frame(el, A); return s, h, e, n

def add_ground(sc, with_wall=True):
    deck = cq.Workplane("XY").box(7.0 * M, 13.0 * M, 120).translate(((1.25 + 3.5) * M, 0, H.Z_DECK * M - 60)).cut(cq.Workplane("XY").circle(0.9 * M).extrude(400).translate((1.25 * M, 0, H.Z_DECK * M - 200)))
    sc.add(deck.val(), "roof deck z 5.0 with the beam hole", COL["ctx"], tol=3.0)
    if with_wall: sc.add(cq.Workplane("XY").box(250, 13.0 * M, 4.0 * M).translate((1.125 * M, 0, 3.0 * M)).val(), "south wall", COL["ctx"], tol=3.0)
    sc.add(cyl(0.9 * M, (1.25 * M, 0, 0.14 * M), (1.25 * M, 0, H.Z_DECK * M - 120)).cut(cyl(0.88 * M, (1.25 * M, 0, 0.13 * M), (1.25 * M, 0, H.Z_DECK * M))), "beam bore below the deck (cass machine)", COL["ctx"], tol=3.0)
    sc.add(disc(1.0 * M, (1.25 * M, 0, 0.14 * M), (-1, 0, 1)), "underground ellipsoid M4 (cass machine, schematic)", COL["mirror"], tol=3.0)
    sc.add(cyl(0.42 * M, (0.42 * M, 0, -0.8 * M), (0.42 * M, 0, 0.3 * M)).cut(cyl(0.39 * M, (0.42 * M, 0, -0.78 * M), (0.42 * M, 0, 0.31 * M))), "tandoor pot", COL["rim"], tol=3.0)
    base = np.array([*S_XY, H.Z_DECK]) * M; top = np.array([*S_XY, Z_NECK - 0.45]) * M
    sc.add(cyl(0.5 * M, base, top).cut(cyl(0.46 * M, base - [0, 0, 10], top + [0, 0, 10])), "stalk: 1.0 m tube from the deck to the yoke, the beam inside it, the azimuth axis", COL["post"], tol=3.0)
    sc.add(cq.Solid.makeTorus(0.55 * M, 50, V(*(top + [0, 0, 20])), V(0, 0, 1)), "slew ring at the stalk top: azimuth", COL["rim"], tol=3.0)
    sc.add(cq.Solid.makeSphere(40, V(*F2_CASS)), "F2 (the cass machine's second focus at the bore top, kept)", COL["mirror"], tol=2.0)

def pivot_parts(Q, e, h, tag=""):
    """two-stage hollow cartwheel on the neck axis: ground outer ring (yoke side), intermediate ring across both stages, moving outer ring (head side); radial blades in planes through the axis"""
    P = []; c = Q + PIV_C * M * e
    def ring(r_in, r_out, y0, length, name, col):
        t = cq.Solid.makeCylinder(r_out, length, V(*(c + (y0 - length / 2) * e)), V(*e)).cut(cq.Solid.makeCylinder(r_in, length + 2, V(*(c + (y0 - length / 2) * e - 1 * e)), V(*e)))
        P.append((t, name + tag, col))
    ring(R_OUT * M, R_OUT * M + 40, -0.20 * M, 100, "ground outer ring (on the yoke)", COL["post"])
    ring(R_IN * M - 30, R_IN * M, 0.0, 2 * PIV_HALF * M + 100, "intermediate ring across both stages, bore r 0.30 m: the beam passes through", COL["frame"])
    ring(R_OUT * M, R_OUT * M + 40, +0.20 * M, 100, "moving outer ring (to the head's neck bar)", COL["frame"])
    for y0, st in ((-0.20 * M, "A"), (+0.20 * M, "B")):
        for k in range(6):
            a = 2 * np.pi * k / 6; rad = np.cos(a) * h + np.sin(a) * Z
            centre = c + y0 * e + 0.5 * (R_IN + R_OUT) * M * rad
            b = cq.Workplane("XY").box(120, 250, 1.0).val()                     # radial 120, along the axis 250, thick 1.0
            Rm = frame_matrix(centre, rad, e, np.cross(rad, e)); P.append((b.transformShape(Rm), f"cartwheel blade 17-7PH 250 x 1.0 x 120 mm, plane through the neck axis, stage {st}{tag}", COL["blade"]))
    return P

def add_machine(sc, doy, hour, tag="", full=True):
    el, A, s = H.sun(doy, hour); s, h, e, n = frame(el, A)
    Q = np.array([*S_XY, Z_NECK]) * M                                        # M4: neck axis meets the stalk axis
    N = Q + OFF * M * e                                                      # the head's centre on the neck axis
    Vx = N + NECK * M * s; xl, yl, zl = -n, e, s; Mx = frame_matrix(Vx, xl, yl, zl)
    # yoke on the slew ring: housing for M4, arm to the pivot's ground ring, counterweight beyond the stalk
    sc.add(box(600, 600, 500, Q + [0, 0, 0], (0, 0, 1), np.degrees(A)).cut(cq.Solid.makeCylinder(0.35 * M, 700, V(*(Q - 0.35 * M * e)), V(*e))).cut(cq.Solid.makeCylinder(0.35 * M, 700, V(*(Q - [0, 0, 350])), V(0, 0, 1))), "yoke housing at the stalk top: M4 inside, open along the neck axis and down the stalk" + tag, COL["post"], tol=3.0)
    sc.add(cyl(60, Q + 0.30 * M * e, Q + (PIV_C - 0.25) * M * e), "yoke arm to the pivot's ground ring" + tag, COL["post"], tol=3.0)
    sc.add(cyl(60, Q - 0.30 * M * e, Q - 1.6 * M * e), "yoke arm to the counterweight beyond the stalk" + tag, COL["post"], tol=3.0)
    sc.add(cq.Solid.makeSphere(0.32 * M, V(*(Q - 1.6 * M * e))), "water counterweight 135 kg beyond the stalk (about the azimuth axis)" + tag, COL["water"], tol=3.0)
    # M4: elliptical fold at 45 deg between -e (incoming) and -z (outgoing)
    n4 = Z - e; n4 /= np.linalg.norm(n4)
    sc.add(disc(O["r_m4"] * M, Q, n4, 12), "M4 ellipsoid on the yoke: neck axis -> down the stalk, image to F2" + tag, COL["mirror2"], tol=2.0)
    for shp, name, col in pivot_parts(Q, e, h, tag): sc.add(shp, name, col, tol=1.0)
    # head: neck bar from the pivot's moving ring to N and 0.3 beyond; M3 at N; spine to the back frame; counterweight behind the neck
    sc.add(cyl(0.36 * M, Q + (PIV_C + 0.25) * M * e, N + 0.30 * M * e).cut(cyl(0.32 * M, Q + (PIV_C + 0.2) * M * e, N + 0.35 * M * e)), "neck bar (hollow, the beam inside) from the pivot to M3" + tag, COL["frame"], tol=3.0)
    n3 = e - s; n3 /= np.linalg.norm(n3)
    sc.add(disc(O["r_m3"] * M, N, n3, 12), "M3 ellipsoid on the head: dish axis -> neck axis, image 1:1 inside the pivot" + tag, COL["mirror2"], tol=2.0)
    sc.add(cyl(60, N, Vx - GM.D_FRAME * M * s), "spine from the neck to the back frame" + tag, COL["frame"], tol=3.0)
    for a in (60, 180, 300):
        ar = np.radians(a); sc.add(cyl(35, Vx - GM.D_FRAME * M * s, Vx - GM.D_FRAME * M * s + GM.R_FRAME * M * (np.cos(ar) * xl + np.sin(ar) * yl)), "back frame spoke" + tag, COL["frame"], tol=3.0)
    sc.add(cyl(60, N, N - 1.6 * M * s), "counterweight arm behind the neck" + tag, COL["frame"], tol=3.0)
    sc.add(cq.Solid.makeSphere(0.32 * M, V(*(N - 1.6 * M * s))), "water counterweight 140 kg behind the neck (about the elevation axis), in the dish's shadow" + tag, COL["water"], tol=3.0)
    # jack from the yoke to a crank on the neck bar
    crank = N + 0.0 * e - 0.8 * M * (np.cos(np.radians(20)) * n - np.sin(np.radians(20)) * s)
    sc.add(cyl(40, N, crank), "crank 0.8 m on the neck bar" + tag, COL["frame"], tol=3.0)
    sc.add(cyl(45, Q + 0.6 * M * e - [0, 0, 1.2 * M] + 0.3 * M * h, crank), "screw jack from the yoke to the crank: elevation, self-locking" + tag, COL["jack"], tol=3.0)
    # rings and fine stage (from the fact_mount model), dish, style, secondary
    sc.add(c_ring(Vx - GM.D_FRAME * M * zl, xl, yl, zl, GM.R_FRAME * M, 40, 0.0), "back frame ring r 1.75 m" + tag, COL["frame"], tol=2.5)
    sc.add(c_ring(Vx - GM.D_RING * M * zl, xl, yl, zl, GM.R_RING * M, 40, 0.0), "dish back ring r 1.46 m (fine stage, moving side)" + tag, COL["rim"], tol=2.5)
    parts = [(cq.Solid.makeTorus(H.A_DISH * M + 60, 60, V(0, 0, H.SAG * M), V(0, 0, 1)), "inflated rim toroid", COL["rim"])]
    if full:
        skin, _ = cap_shell(H.R_SPH * M, H.A_DISH * M, R_HOLE * M, 0.0)
        parts.append((skin, "membrane: a 2.1 m, hole r 0.12 m, no slot", COL["skin"]))
        parts.append((disc(H.A_DISH * M, (0, 0, -250), (0, 0, 1), 4.0).cut(cq.Solid.makeCylinder(R_HOLE * M, 400, V(0, 0, -450), V(0, 0, 1))), "back plenum film", COL["skin"]))
        parts += fine_stage_parts()
        for a in GM.STATIONS:
            ar = np.radians(a); rad = np.array([np.cos(ar), np.sin(ar), 0.0]); t = np.array([-np.sin(ar), np.cos(ar), 0.0]); P0 = rad * GM.R_RING * M + t * 450 + [0, 0, -GM.D_RING * M]
            parts.append((cyl(30, P0, P0 - [0, 0, (GM.D_FRAME - GM.D_RING) * M]), "post to the back frame (blade's far end)", COL["frame"]))
        for a in GM.COLUMNS:
            ar = np.radians(a); Qc = np.array([GM.R_ACT * M * np.cos(ar), GM.R_ACT * M * np.sin(ar), -GM.D_RING * M]); parts.append((cyl(60, Qc, Qc - [0, 0, (GM.D_FRAME - GM.D_RING) * M]), "water column d 0.12 m", COL["water"]))
    style = cq.Solid.makeCone(R_HOLE * M, R_SEC * M, D_SEC * M, V(0, 0, H.SAG * M), V(0, 0, 1)).cut(cq.Solid.makeCone(R_HOLE * M - 6, R_SEC * M - 6, D_SEC * M + 2, V(0, 0, H.SAG * M - 1), V(0, 0, 1)))
    parts.append((style, "the style: conical shell from the hole rim to the secondary rim, inside the secondary's shadow, the return beam inside it", COL["style"]))
    parts.append((cq.Solid.makeCylinder(R_SEC * M, 30, V(0, 0, D_SEC * M), V(0, 0, 1)), "hyperboloid secondary r 0.34 m at 3.35 m: the only new shadow", COL["mirror2"]))
    for shp, name, col in parts: sc.add(shp.transformShape(Mx), name + tag, col, tol=2.5)
    # beam and axes
    lines = []
    for a in np.radians(np.arange(0, 360, 45)):
        rim = Vx + H.SAG * M * zl + H.A_DISH * M * (np.cos(a) * xl + np.sin(a) * yl); sec = Vx + D_SEC * M * zl + R_SEC * M * 0.98 * (np.cos(a) * xl + np.sin(a) * yl)
        img = Vx - O["B"] * M * zl; lines += [[(rim + 3.0 * M * zl).tolist(), rim.tolist()], [rim.tolist(), sec.tolist()], [sec.tolist(), img.tolist()]]
    img = Vx - O["B"] * M * zl; img2 = N - O["F3"] * M * e
    lines += [[img.tolist(), N.tolist()], [N.tolist(), img2.tolist()], [img2.tolist(), Q.tolist()], [Q.tolist(), F2_CASS.tolist()], [F2_CASS.tolist(), [1.25 * M, 0, 0.14 * M]]]
    for a in np.radians(np.arange(0, 360, 90)): lines.append([F2_CASS.tolist(), [1.25 * M + 900 * np.cos(a), 900 * np.sin(a), 140]])
    sc.parts.append(dict(name="beam: sun -> primary -> secondary -> image -> M3 -> along the neck through the pivot -> M4 -> down the stalk -> F2 -> M4u" + tag, color=COL["beam"], lines=lines))
    sc.parts.append(dict(name="axes: dish axis, neck (elevation) axis through the pivot, stalk (azimuth) axis" + tag, color=COL["sun"], lines=[[(Vx - 3 * M * zl).tolist(), (Vx + 4 * M * zl).tolist()], [(Q - 2.0 * M * e).tolist(), (N + 0.6 * M * e).tolist()], [(Q + [0, 0, 1.5 * M]).tolist(), [1.25 * M, 0, 0.14 * M]]]))
    sc.parts.append(dict(name="sun direction" + tag, color=COL["sun"], lines=[[(Vx + 4.5 * M * s).tolist(), (Vx + 7.0 * M * s).tolist()]]))
    return el, A

if __name__ == "__main__":
    for name, doy, hour in (("cd_equinox_noon", 80, 12.0), ("cd_summer_noon", 172, 12.0), ("cd_morning", 80, 9.0)):
        sc = Scene(); add_ground(sc); add_machine(sc, doy, hour); sc.write(os.path.join(OUT, name + ".json"))
    sc = Scene(); add_ground(sc, with_wall=False)
    for hour in np.arange(8.0, 16.01, 1.0):
        el, A, s = H.sun(80, hour); s, h, e, n = frame(el, A); Q = np.array([*S_XY, Z_NECK]) * M; N = Q + OFF * M * e; Vx = N + NECK * M * s; xl, yl, zl = -n, e, s
        rim = [(Vx + H.SAG * M * zl + (H.A_DISH * M + 60) * (np.cos(a) * xl + np.sin(a) * yl)).tolist() for a in np.radians(np.arange(0, 361, 15))]
        sc.parts.append(dict(name="rim" + f" H{int(hour):02d}", color=COL["rim"], lines=[[rim[i], rim[i + 1]] for i in range(len(rim) - 1)]))
        sc.parts.append(dict(name="neck bar, spine, secondary axis" + f" H{int(hour):02d}", color=COL["frame"], lines=[[Q.tolist(), (N + 0.3 * M * e).tolist()], [N.tolist(), (Vx - GM.D_FRAME * M * s).tolist()], [Vx.tolist(), (Vx + D_SEC * M * s).tolist()], [N.tolist(), (N - 1.6 * M * s).tolist()]]))
    sc.write(os.path.join(OUT, "cd_sweep.json"))
    # the pivot alone, in a frame with the neck axis along y and h along x
    sc = Scene(); Q0 = np.zeros(3); e0 = np.array([0, 1.0, 0]); h0 = np.array([1.0, 0, 0])
    for shp, name, col in pivot_parts(Q0, e0, h0): sc.add(shp, name, col, tol=0.6)
    sc.add(cyl(60, Q0 + 0.30 * M * e0, Q0 + (PIV_C - 0.25) * M * e0), "yoke arm (stub)", COL["post"], tol=2.0)
    sc.add(cyl(0.36 * M, Q0 + (PIV_C + 0.25) * M * e0, Q0 + 1.6 * M * e0).cut(cyl(0.32 * M, Q0 + (PIV_C + 0.2) * M * e0, Q0 + 1.7 * M * e0)), "neck bar (stub)", COL["frame"], tol=2.0)
    sc.parts.append(dict(name="neck axis: the beam's path through the bore", color=COL["sun"], lines=[[[0, -300, 0], [0, 1800, 0]]]))
    sc.parts.append(dict(name="beam through the pivot (r 0.14 m image inside)", color=COL["beam"], lines=[[[0, -300, 0], [0, 1800, 0]], [[140, 200, 0], [0, 1000, 0]], [[-140, 200, 0], [0, 1000, 0]], [[0, 200, 140], [0, 1000, 0]], [[0, 200, -140], [0, 1000, 0]]]))
    sc.write(os.path.join(OUT, "cd_pivot.json"))
    print("scenes written")

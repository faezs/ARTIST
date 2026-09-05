#!/usr/bin/env python
"""Pneumatic sunflower: CadQuery model (mm) of one flower at its design point, a bouquet of four around one pit,
and the same module at three scales. Geometry comes from physics_flower.flower / best_point so the drawing and
the numbers cannot drift apart.

Frame: pit / mast base at the origin, z up, the sun toward +x (azimuth 0) at zenith angle TILT.
"""
import os, sys, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "3d")); sys.path.insert(0, HERE)
from mesh_export import Scene
from physics_flower import flower, best_point
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)

TILT = np.radians(45.0)          # sun zenith angle drawn
NECK = 0.5                       # m
SHELL = 6.0                      # mm, drawn skin thickness
V = cq.Vector

# ---------------------------------------------------------------- primitives (mm)
def cyl(r, p0, p1):
    p0, p1 = np.asarray(p0, float), np.asarray(p1, float); d = p1 - p0; L = np.linalg.norm(d)
    return cq.Solid.makeCylinder(r, L, V(*p0), V(*(d / L)))

def disc(r, centre, normal, t=8.0):
    n = np.asarray(normal, float); n /= np.linalg.norm(n); c = np.asarray(centre, float) - n * t / 2
    return cq.Solid.makeCylinder(r, t, V(*c), V(*n))

def cap_concave(Rc, a, hole, thick=SHELL):
    """Spherical-cap shell, vertex at the origin, reflective (concave) side toward +z; the skin on the inside of a
    section of a spherical volume."""
    sag = Rc - np.sqrt(Rc**2 - a**2)
    sh = cq.Workplane("XY").sphere(Rc).translate((0, 0, Rc)).cut(cq.Workplane("XY").sphere(Rc - thick).translate((0, 0, Rc)))
    sh = sh.intersect(cq.Workplane("XY").circle(a).extrude(sag + thick + 2).translate((0, 0, -1)))
    if hole > 0: sh = sh.cut(cq.Workplane("XY").circle(hole).extrude(400).translate((0, 0, -200)))
    return sh.val(), sag

def cap_convex(Rc, r, z, thick=SHELL):
    """The same skin used from outside: convex dome facing -z, lowest point at height z."""
    sag = Rc - np.sqrt(Rc**2 - r**2)
    sh = cq.Workplane("XY").sphere(Rc).translate((0, 0, z + Rc)).cut(cq.Workplane("XY").sphere(Rc - thick).translate((0, 0, z + Rc)))
    return sh.intersect(cq.Workplane("XY").circle(r).extrude(sag + thick + 2).translate((0, 0, z - 1))).val()

def rot_y(shape, ang_deg):
    return shape.rotate(V(0, 0, 0), V(0, 1, 0), ang_deg)

def xform_pt(p, phi, tip, az_deg=0.0):
    """Head-frame point (vertex at origin, axis +z) -> world: rotate about y by phi, translate to the neck tip, azimuth about z."""
    c, s = np.cos(phi), np.sin(phi)
    x, y, z = p
    w = np.array([c * x + s * z, y, -s * x + c * z]) + tip
    ca, sa = np.cos(np.radians(az_deg)), np.sin(np.radians(az_deg))
    return np.array([ca * w[0] - sa * w[1], sa * w[0] + ca * w[1], w[2]])

def place(shape, phi, tip, az_deg=0.0):
    return rot_y(shape, np.degrees(phi)).translate(V(*tip)).rotate(V(0, 0, 0), V(0, 0, 1), az_deg)


# ---------------------------------------------------------------- one flower
def build_flower(sc, D, base=(0.0, 0.0), phi=TILT, az_deg=0.0, tag="", with_root=True, cables=True):
    f1D, dfr, r = best_point(D)
    m = 1000.0
    a, sag_m, d, mast, r_sec, r_hose, r_bv, r_bm = r["D"] / 2 * m, r["sag"] * m, r["d"] * m, r["mast"] * m, r["r_sec"] * m, r["r_hose"] * m, r["r_bv"] * m, r["r_bm"] * m
    Rc = r["R"] * m; neck = NECK * m; r_t = 0.03 * D * m
    R2 = 2.0 / (1.0 / (r["f1"] - r["d"]) - 1.0 / r["b"]) * m          # convex secondary radius (sphere approximating the hyperboloid)
    bx, by = base[0] * m, base[1] * m
    B = np.array([bx, by, 0.0])
    # neck arc in the local (x-z) plane before azimuth: centre of curvature on the +x side
    Rb = neck / phi if phi > 1e-6 else 1e9
    def P(t): return np.array([Rb * (1 - np.cos(t)), 0.0, mast + Rb * np.sin(t)])
    tip_local = P(phi); tip = B + tip_local
    ax = np.array([np.sin(phi), 0.0, np.cos(phi)])                    # head axis (local azimuth frame)
    col_skin, col_hose, col_rim, col_fold, col_beam, col_cable, col_sun = "#dfe3e8", "#5b6b7f", "#9aa5b1", "#7c3aed", "#d9480f", "#0e7490", "#0e7490"
    # mast (hose) and root ring
    sc.add(cyl(r_hose, B, B + [0, 0, mast]).cut(cyl(r_hose - 8, B - [0, 0, 1], B + [0, 0, mast + 1])), f"mast hose r {r_hose/m:.2f} m, {r['mast']:.2f} m, 2 bar{tag}", col_hose, tol=2.0)
    sc.add(cq.Solid.makeTorus(r_hose + 60, 60, V(*B), V(0, 0, 1)), f"root ring on the pit{tag}", col_rim, tol=2.0)
    # neck: vine section as short cylinders along the arc
    n = 10; segs = []
    for i in range(n):
        p0, p1 = B + P(phi * i / n), B + P(phi * (i + 1) / n)
        segs.append(cyl(r_hose, p0, p1))
    sc.add(cq.Compound.makeCompound(segs), f"vine neck: {NECK:.1f} m bending section, tendons at 120 deg{tag}", col_hose, tol=2.0)
    # head in its own frame, then placed
    skin, sag = cap_concave(Rc, a, r_bv + 30)
    parts = [(skin, f"primary skin: spherical cap R {r['R']:.1f} m, D {D} m, hole r {r_bv/m + 0.03:.2f} m{tag}", col_skin),
             (cq.Solid.makeTorus(a + r_t, r_t, V(0, 0, sag), V(0, 0, 1)), f"inflated rim toroid r {r_t/m:.2f} m{tag}", col_rim),
             (disc(a, (0, 0, -120), (0, 0, 1), 4.0), f"back plenum film (pumped membrane, on-axis){tag}", col_skin),
             (cap_convex(R2, r_sec, d), f"secondary skin: convex, r {r['r_sec']:.2f} m at {r['d']:.2f} m{tag}", col_skin)]
    for k in range(3):
        th = np.radians(90 + 120 * k)
        parts.append((cyl(0.02 * D * m, (np.cos(th) * (a + r_t), np.sin(th) * (a + r_t), sag), (np.cos(th) * (r_sec + 20), np.sin(th) * (r_sec + 20), d + 20)),
                      f"mini-stem strut (the same hose, smaller){tag}", col_hose))
    # M3 at the vertex hole: fold from -axis onto the neck chord (pointing down the neck)
    chord = (P(0) - P(phi)); chord /= np.linalg.norm(chord)
    d_in = -ax; n3 = d_in - chord; n3 /= np.linalg.norm(n3)
    # express n3 in the head frame (inverse rotation about y by phi)
    c, s = np.cos(phi), np.sin(phi); n3h = np.array([c * n3[0] - s * n3[2], n3[1], s * n3[0] + c * n3[2]])
    parts.append((disc(r_bv + 20, (0, 0, -150), n3h), f"M3 fold at the vertex hole (flexure-mounted, beam-centroid loop){tag}", col_fold))
    for shp, name, col in parts:
        sc.add(place(shp, phi, tip, az_deg), name, col, tol=2.0)
    # M4 at the mast top: fold from the chord to straight down
    n4 = chord - np.array([0, 0, -1.0]); n4 /= np.linalg.norm(n4)
    sc.add(disc(r_bm + 20, B + [0, 0, mast - 150], n4).rotate(V(0, 0, 0), V(0, 0, 1), az_deg), f"M4 fold at the mast top{tag}", col_fold, tol=2.0)
    # beam envelope (lines)
    lines = []
    for k in range(8):
        th = 2 * np.pi * k / 8
        p_rim = xform_pt((a * np.cos(th), a * np.sin(th), sag), phi, tip, az_deg)
        p_sec = xform_pt((r_sec * np.cos(th), r_sec * np.sin(th), d), phi, tip, az_deg)
        p_ver = xform_pt((r_bv * np.cos(th), r_bv * np.sin(th), 0), phi, tip, az_deg)
        p_m3 = xform_pt((r_bv * np.cos(th), r_bv * np.sin(th), -150), phi, tip, az_deg)
        lines += [[p_rim.tolist(), p_sec.tolist()], [p_sec.tolist(), p_ver.tolist()], [p_ver.tolist(), p_m3.tolist()]]
    m3c = xform_pt((0, 0, -150), phi, tip, az_deg); m4c = (B + [0, 0, mast - 150]); m4c = xform_pt((0, 0, 0), 0.0, m4c, az_deg)
    for k in range(4):                                   # envelope along the chord and down the mast
        th = np.pi / 2 * k
        u = np.cross(chord, [0, 1, 0]); u /= np.linalg.norm(u); w = np.array([0, 1.0, 0])
        off3 = (np.cos(th) * u + np.sin(th) * w) * r_bv; off4 = (np.cos(th) * u + np.sin(th) * w) * r_bm
        q3 = xform_pt((0, 0, 0), 0.0, m3c + off3, 0.0); q4 = m4c + off4
        lines.append([q3.tolist(), q4.tolist()])
        root = B + [0, 0, 350]
        lines.append([q4.tolist(), (root + np.array([np.cos(th), np.sin(th), 0]) * r_bm * 0.4).tolist()])
    sc.parts.append(dict(name=f"beam envelope: rim -> secondary -> vertex hole -> M3 -> chord -> M4 -> down the mast{tag}", color=col_beam, lines=lines))
    # sun direction
    sun_from = xform_pt((0, 0, d + 300), phi, tip, az_deg); sun_to = xform_pt((0, 0, d + 300 + 1.2 * a), phi, tip, az_deg)
    sc.parts.append(dict(name=f"sun direction (head axis){tag}", color=col_sun, lines=[[sun_from.tolist(), sun_to.tolist()]]))
    # cables from the rim to ground winches
    if cables:
        cl = []
        for k in range(3):
            th = np.radians(90 + 120 * k)
            p_rim = xform_pt((np.cos(th) * (a + r_t), np.sin(th) * (a + r_t), sag), phi, tip, az_deg)
            anc = B + np.array([np.cos(th + np.radians(az_deg)), np.sin(th + np.radians(az_deg)), 0]) * 1.5 * a
            cl.append([p_rim.tolist(), anc.tolist()])
            sc.add(cyl(90, anc, anc + [0, 0, 160]), f"ground winch{tag}", col_hose, tol=2.0)
        sc.parts.append(dict(name=f"three stay cables 4 mm (the tendons, anchored to the ground){tag}", color=col_cable, lines=cl))
    # root periscope and pot
    if with_root:
        n_r = np.array([-1.0, 0, 1.0]) / np.sqrt(2); pot_x = -1.2 * m
        sc.add(disc(r_bm * 0.5 + 40, B + [0, 0, 350], n_r), f"root fold in the mast base{tag}", col_fold, tol=2.0)
        sc.add(disc(r_bm * 0.5 + 40, B + [pot_x, 0, 350], -n_r), f"fold over the pot mouth{tag}", col_fold, tol=2.0)
        sc.add(cyl(120, B + [-r_hose, 0, 350], B + [pot_x + 120, 0, 350]).cut(cyl(112, B + [-r_hose - 1, 0, 350], B + [pot_x + 121, 0, 350])), f"horizontal duct 1.2 m{tag}", col_hose, tol=2.0)
        pot = cyl(450, B + [pot_x, 0, -900], B + [pot_x, 0, 0]).cut(cyl(420, B + [pot_x, 0, -880], B + [pot_x, 0, 1]))
        sc.add(pot, f"tandoor pot in the pit, mouth at ground{tag}", col_rim, tol=3.0)
        sc.parts.append(dict(name=f"beam in the root: down the mast -> along the duct -> into the pot{tag}", color=col_beam,
                             lines=[[(B + [0, 0, 350]).tolist(), (B + [pot_x, 0, 350]).tolist()], [(B + [pot_x, 0, 350]).tolist(), (B + [pot_x, 0, -600]).tolist()]]))
    return r


if __name__ == "__main__":
    sc = Scene(); r = build_flower(sc, 2.1); sc.write(os.path.join(OUT, "flower.json"))
    sc2 = Scene()
    for k, ang in enumerate((45, 135, 225, 315)):
        th = np.radians(ang); build_flower(sc2, 2.1, base=(2.2 * np.cos(th), 2.2 * np.sin(th)), with_root=False, cables=False)
    pit = cyl(1000, (0, 0, -1100), (0, 0, 0)).cut(cyl(940, (0, 0, -1050), (0, 0, 1)))
    sc2.add(pit, "shared oven chamber r 1.0 m, four entries", "#9aa5b1", tol=3.0)
    for ang in (45, 135, 225, 315):
        th = np.radians(ang); b = np.array([2.2 * np.cos(th), 2.2 * np.sin(th), 0]) * 1000
        e = np.array([np.cos(th), np.sin(th), 0]) * 1000
        sc2.add(cyl(120, b + [0, 0, 350] - e * 0.2, e * 1.0 + [0, 0, 350]).cut(cyl(112, b + [0, 0, 350] - e * 0.21, e * 0.99 + [0, 0, 350])), "root duct to the chamber", "#5b6b7f", tol=2.0)
    sc2.write(os.path.join(OUT, "bouquet.json"))
    sc3 = Scene()
    for D, y in ((1.4, -2.6), (2.1, 0.0), (4.2, 4.6)):
        build_flower(sc3, D, base=(0.0, y), phi=np.radians(20.0), with_root=False, cables=False)
    sc3.write(os.path.join(OUT, "flower_scales.json"))
    open(os.path.join(OUT, "design_point.txt"), "w").write(f"D 2.1: f1/D {best_point(2.1)[0]}, d/f1 {best_point(2.1)[1]}\n" + "\n".join(f"{k}: {v}" for k, v in r.items()))

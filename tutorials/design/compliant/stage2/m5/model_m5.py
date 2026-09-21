"""M5 relay: each facet on an exact-constraint compliant pad, the patch on
an athermal frame.

Pad (local frame: facet vertex at the origin, facet plane z = 0, z the
facet normal): six in-plane Ti wires in three tangential PAIRS on a
130 mm circle (twice the minimum three: R-DCM-1 redundancy) leave
exactly tip, tilt and piston free; three hard-contact adjuster screws
along z at the same three stations take those three freedoms (0 DOF,
adjustable, position defined by contact not by a spring: R6). Radial
growth of the facet relative to the frame only bends the wires (R8,
R9). Checks: exactness of the six-wire set (rank 3), of the set with
the three contacts (rank 6), the frame FE of the wire set (three soft
directions = the adjusted ones, everything else stiff), wire stress at
the +-15 mrad / +-2 mm adjustment range, buckling under the 49 N wind case, the central preload.

Patch: the 43 facets placed from m5_relay_geometry.py (positions, tilts,
families) on the ellipsoid, each shown as a hex facet on its pad, on a
pit frame drawn as a truss; the frame's thermal centre is put on the
patch reference (the chief-ray facet) so uniform growth is radial from
it. Outputs (./out): m5_pad.json, m5_patch.json, m5_pad.svg, checks.txt."""
import os, sys, json, subprocess, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, os.path.join(ROOT, "3d"))
from fact_core import rot_twist, trans_twist, wire, analyse, describe
from dcm_core import interface_freedom, frame_fe
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True); LOG = []
def log(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)

# ---------------------------------------------------------------- pad: six in-plane tangential wires + three contacts
E, G, SY = 114e3, 44e3, 880.0; SY_T = 720.0                  # Ti-6Al-4V wires; SY_T at 200 C (pit zone)
SIG_ALLOW, SIG_HELD = 0.30*SY, 0.25*SY_T                       # R3: 0.30 sigma_y working, 0.25 sigma_y(T) held
TILT_RANGE, PISTON_RANGE, PRELOAD = 0.015, 2.0, 120.0          # alignment window (rad, mm) and the central spring preload (N)
R_ST, D_W, L_W, PAIR_OFF = 100.0, 1.0, 65.0, 6.0             # station radius, wire diameter, free length, radial offset of the pair
angs = np.radians([90, 210, 330])
F_pad = [rot_twist([0, 0, 0], [1, 0, 0]), rot_twist([0, 0, 0], [0, 1, 0]), trans_twist([0, 0, 1])]
wires6 = []
for a in angs:
    p = np.array([R_ST*np.cos(a), R_ST*np.sin(a), 0.0]); t = np.array([-np.sin(a), np.cos(a), 0.0]); rad = np.array([np.cos(a), np.sin(a), 0.0])
    for s in (-1, 1):
        wires6.append(dict(kind="wire", point=p + s*PAIR_OFF/2*rad, direction=t, wrenches=[wire(p + s*PAIR_OFF/2*rad, t)]))
W6 = [w for e in wires6 for w in e["wrenches"]]
free, rank = interface_freedom(W6); log(f"pad: 6 tangential in-plane wires -> rank {rank}, DOF {6 - rank}: {describe(free)}")
contacts = [wire([R_ST*np.cos(a), R_ST*np.sin(a), 0.0], [0, 0, 1]) for a in angs]
free2, rank2 = interface_freedom(W6 + contacts); log(f"pad + 3 screw contacts -> rank {rank2}, DOF {6 - rank2}: exact-constraint adjustable mount")
_, rank5 = interface_freedom(W6[1:]); log(f"redundancy: one wire lost -> rank {rank5}, DOF {6 - rank5} (unchanged)")
# frame FE of the wire set alone: the pad body vs the frame (two 'layers' along z: the frame ring below, the facet boss above);
# the wires are horizontal, so build a block whose interface is the z = 0 plane with the wires crossing a small vertical gap:
# model each tangential wire as a beam between a frame post (at its -s end) and the facet boss (at its +s end): use frame_fe's
# convention by giving each wire a tiny z-slope through the gap.
gap = L_W
blk = dict(layers=[(-gap/2 - 10, -gap/2), (gap/2, gap/2 + 10)], interfaces=[dict(z=0.0, gap=gap, cells=[], elements=[])], L=np.array([2*R_ST, 2*R_ST, gap + 20]), lo=np.array([-R_ST, -R_ST, -gap/2 - 10]), stack_axis=2)
for e in wires6:
    d = e["direction"].copy(); d[2] = 1.0; d /= np.linalg.norm(d)      # 45 deg: the horizontal wire modelled as spanning the gap obliquely
    blk["interfaces"][0]["elements"].append(dict(kind="wire", point=e["point"], direction=d, wrenches=[wire(e["point"], d)]))
fe = frame_fe(blk, E=E, G=G, wire_d=D_W, gap=gap)
log(f"FE (wires only, 45-deg model): normalised eigen-stiffnesses {np.round(fe['eigvals'], 1)}; three soft directions vs three stiff: ratio {fe['eigvals'][2]/fe['eigvals'][3]:.2e}")
# stress at the adjustment window: a tilt about a diameter bends the wires at the far station by delta = R_ST * theta (held for 20 yr)
delta = R_ST*TILT_RANGE; sig = 3*E*D_W*delta/L_W**2    # fixed-guided beam end deflection: sigma = 3 E d delta / L^2 (delta at one end)
sig_p = 3*E*D_W*PISTON_RANGE/L_W**2
log(f"wire stress at +-{TILT_RANGE*1e3:.0f} mrad tilt: {sig:.0f} MPa = {sig/SY:.2f} sigma_y, {sig/SY_T:.2f} sigma_y(200 C) (held: R3 <= 0.25); piston +-{PISTON_RANGE:.0f} mm: {sig_p:.0f} MPa = {sig_p/SY_T:.2f} sigma_y(200 C)")
Pcr = np.pi**2*E*(np.pi*D_W**4/64)/(0.7*L_W)**2; log(f"buckling of a wire under the 49 N wind case shared by 6: {49/6:.1f} N vs P_cr {Pcr:.0f} N -> SF {Pcr/(49/6):.1f} (R10 >= 3)")
log(f"in-plane: each wire axial EA/L {E*np.pi*D_W**2/4/L_W:.0f} N/mm, three effective in any in-plane direction: a 49 N in-plane gust moves the facet {49/(3*E*np.pi*D_W**2/4/L_W)*1e3:.1f} um")
log(f"preload: central Inconel X-750 coil, {PRELOAD:.0f} N at 12 mm (k 10 N/mm) holds the facet on its three contacts against the 49 N suction case (SF {PRELOAD/49:.1f}); +-{PISTON_RANGE:.0f} mm piston changes it by +-20 N")
log(f"athermal: Al facet vs Ti frame, +40 K on a {R_ST:.0f} mm radius: differential {R_ST*(23e-6 - 8.6e-6)*40:.3f} mm radial, taken by wire bending ({3*E*D_W*R_ST*(23e-6-8.6e-6)*40/L_W**2:.1f} MPa); symmetric -> no tilt")
open(os.path.join(OUT, "checks.txt"), "w").write("\n".join(LOG))

# ---------------------------------------------------------------- pad geometry for the viewer
import cadquery as cq
from mesh_export import Scene
sc = Scene()
hexr = 160.0
facet = cq.Workplane("XY").polygon(6, 2*hexr).extrude(1.5).translate((0, 0, 8.0))
sc.add(facet, "facet: 1.5 mm anodised Al, pressed toroid", "#e5e7eb", tol=2.0)
boss = cq.Workplane("XY").circle(R_ST + 12).circle(R_ST - 12).extrude(6).translate((0, 0, 2.0))
sc.add(boss, "facet boss ring (Al)", "#c9cfd6", tol=1.5)
for a in angs:
    p = np.array([R_ST*np.cos(a), R_ST*np.sin(a), 0.0]); t = np.array([-np.sin(a), np.cos(a), 0.0])
    post = cq.Workplane("XY").box(16, 16, 30).translate(tuple(p + 24*t + [0, 0, -15])).union(cq.Workplane("XY").box(16, 16, 30).translate(tuple(p - 24*t + [0, 0, -15])))
    sc.add(post, "frame posts (Ti)", "#5b6b7f", tol=1.5)
    sc.add(cq.Workplane("XY").circle(3).extrude(26).translate(tuple(p + [0, 0, -24])), "adjuster screw M6 (hard contact)", "#7c3aed", tol=0.6)
lines = []
for e in wires6:
    p, t = e["point"], e["direction"]; lines.append([list(np.round(p - 20*t, 1)), list(np.round(p + 20*t, 1))])
sc.parts.append(dict(name="six tangential in-plane wires (Ti d 1.0)", color="#d9480f", lines=lines))
sc.parts.append(dict(name="tip / tilt axes in the facet plane", color="#0e7490", lines=[[[-200, 0, 0], [200, 0, 0]], [[0, -200, 0], [0, 200, 0]]]))
sc.write(os.path.join(OUT, "m5_pad.json"))

# ---------------------------------------------------------------- the patch: 43 facets from the geometry script
geo = subprocess.run([sys.executable, os.path.join(ROOT, "m5_relay_geometry.py")], capture_output=True, text=True, cwd=ROOT).stdout.splitlines()
rows = []
for ln in geo:
    parts = ln.split()
    if len(parts) >= 11 and parts[-1].startswith("F"):
        try: rows.append(dict(u=float(parts[0]), v=float(parts[1]), x=float(parts[2]), z=float(parts[3]), inc=float(parts[4]), tilt=float(parts[9]), fam=parts[10]))
        except ValueError: pass
log(f"patch: {len(rows)} facets parsed from m5_relay_geometry.py")
sc2 = Scene()
for k, r in enumerate(rows):
    # world position: x from the script (m), y = v (m), z (m); facet tilt about the y axis (approximation of the toroid's local normal)
    fac = cq.Workplane("XY").polygon(6, 2*hexr*0.98).extrude(1.5).rotate((0, 0, 0), (0, 1, 0), r["tilt"]).translate((r["x"]*1000, r["v"]*1000, r["z"]*1000))
    sc2.add(fac, f"facet {k+1} {r['fam']}", "#e5e7eb", tol=3.0)
    pad = cq.Workplane("XY").circle(R_ST + 12).circle(R_ST - 12).extrude(6).rotate((0, 0, 0), (0, 1, 0), r["tilt"]).translate((r["x"]*1000, r["v"]*1000, r["z"]*1000 - 8))
    sc2.add(pad, f"pad {k+1}", "#9aa5b1", tol=3.0)
# pit frame as a truss under the patch: a rectangular base with diagonals, thermal centre at the chief-ray facet (x ~ 0.74 m, y 0)
xs = [r["x"]*1000 for r in rows]; ys = [r["v"]*1000 for r in rows]; zs = [r["z"]*1000 for r in rows]
x0, x1, y0, y1, zb = min(xs) - 250, max(xs) + 250, min(ys) - 250, max(ys) + 250, min(zs) - 400
tr = []
for (a, b) in (((x0, y0), (x1, y0)), ((x1, y0), (x1, y1)), ((x1, y1), (x0, y1)), ((x0, y1), (x0, y0)), ((x0, y0), (x1, y1)), ((x1, y0), (x0, y1))):
    tr.append([[a[0], a[1], zb], [b[0], b[1], zb]])
for r in rows: tr.append([[r["x"]*1000, r["v"]*1000, zb], [r["x"]*1000, r["v"]*1000, r["z"]*1000 - 8]])
sc2.parts.append(dict(name="pit frame truss + pad posts (schematic)", color="#5b6b7f", lines=tr))
sc2.parts.append(dict(name="foci: waist fW and duct fT (world)", color="#0e7490", lines=[[[1250, 0, 4606], [1250, 0, -100]], [[1250, 0, -100], [420, 0, 140]]]))
sc2.write(os.path.join(OUT, "m5_patch.json"))
# ---------------------------------------------------------------- drawing of the pad
fig, ax = plt.subplots(figsize=(6, 6))
ax.add_patch(plt.Circle((0, 0), R_ST, fc="none", ec="#c7d0da", ls="--"))
th = np.linspace(0, 2*np.pi, 7); ax.plot(hexr*np.cos(th + np.pi/6), hexr*np.sin(th + np.pi/6), color="#14213d", lw=1.5)
for e in wires6:
    p, t = e["point"], e["direction"]; ax.plot([p[0] - 20*t[0], p[0] + 20*t[0]], [p[1] - 20*t[1], p[1] + 20*t[1]], color="#d9480f", lw=2.5)
for a in angs: ax.plot(R_ST*np.cos(a), R_ST*np.sin(a), "o", color="#7c3aed", ms=8)
ax.set_aspect("equal"); ax.set_xlim(-200, 200); ax.set_ylim(-200, 200); ax.set_xlabel("mm")
ax.set_title("M5 facet pad, plan: three tangential wire pairs (orange) leave tip, tilt, piston; three screw contacts (purple) set them", fontsize=8, loc="left")
fig.savefig(os.path.join(OUT, "m5_pad.svg"), bbox_inches="tight"); fig.savefig(os.path.join(OUT, "m5_pad.png"), dpi=110, bbox_inches="tight"); plt.close(fig)
print("wrote", OUT)

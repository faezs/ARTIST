"""Beam-down fold at F as a directionally compliant lattice saddle.

Local frame: F at the origin, the mirror face plane z = 0 facing DOWN
(-z is the beam side), the tilt axis is the y axis (in the face plane),
x is along the beam's plane of incidence. The mirror plate (0.36 x 0.44
m elliptical, 12 mm, fins to z = 40) hangs from the bottom rigid layer
of a DCM block whose every interface cell carries five oblique wires
meeting the y axis at z = 0. The block's top rigid layer bolts to the
yoke under the hood. Range per interface from wire bending at the
allowed stress; N interfaces in series give the working range; the
lattice's neutral state is the PARK state (beam dumped), so power loss
returns the mirror to park (brief R-DCM-2).

Outputs (in ./out): fold_saddle.json (viewer mesh: layers, mirror,
hood, yoke as meshes; wires as line segments), fold_elevation.svg /
fold_plan.svg (matplotlib), checks.txt (dcm_core ranks, frame FE)."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, os.path.join(ROOT, "3d"))
from dcm_core import dcm_stack, elements_1R_wires, check_block, frame_fe, interface_freedom
from fact_core import rot_twist, wire
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
LOG = []
def log(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)

# ------------------------------------------------------------------ design parameters (mm, N, MPa)
E, G, SY = 114e3, 44e3, 880.0          # Ti-6Al-4V, N/mm2 (yield at room T; 760 at 120 C used for the fraction)
SY_T = 760.0
SIG_ALLOW = 0.25*SY_T                  # brief_robustness R3: held-at-temperature flexure
D_WIRE, GAP, T_LAYER = 1.2, 25.0, 12.0 # wire diameter, interface gap (= wire free length), rigid layer thickness
CELL = 40.0                            # cell size across the interface
NX, NY = 12, 4                         # cells across (x along the mirror's long axis, y along the tilt axis)
RANGE_DEG, PARK_DEG, MIN_TILT_DEG = 27.0, 42.5, 15.0
theta_if = 2*SIG_ALLOW*GAP/(E*D_WIRE)  # bending: sigma = E d theta / (2 L)
N_IF = int(np.ceil(np.radians(RANGE_DEG)/theta_if))
N_LAYERS = N_IF + 1
Z0 = 60.0                              # bottom of the block (above the fin tops at z 40)
H = N_LAYERS*T_LAYER + N_IF*GAP
log(f"range per interface {np.degrees(theta_if):.2f} deg at {SIG_ALLOW:.0f} MPa (wire d {D_WIRE} mm, gap {GAP} mm) -> {N_IF} interfaces, {N_LAYERS} layers, block height {H:.0f} mm")

# ------------------------------------------------------------------ the DCM block: 1R about the y axis through F (z = 0)
axis_p, axis_d = [0.0, 0.0, 0.0], [0.0, 1.0, 0.0]
layers = []; z = Z0
for i in range(N_LAYERS):
    layers.append((z, z + T_LAYER)); z += T_LAYER + GAP
blk = dcm_stack(layers, NX, NY, CELL, lambda c, h, g: elements_1R_wires(axis_p, axis_d, c, h, g))
n_wires = sum(len(i["elements"]) for i in blk["interfaces"])
log(f"lattice: {NX}x{NY} cells of {CELL} mm per interface, {n_wires} wires total ({n_wires//N_IF} per interface)")
stack = check_block(blk, [rot_twist(axis_p, axis_d)], "fold saddle")
LOG.append("(dcm_core check above)")

# ------------------------------------------------------------------ frame FE: stiffness, modes, torque, one-wire-removed
fe = frame_fe(blk, E=E, G=G, wire_d=D_WIRE, gap=GAP)
K = fe["K"]                                    # 6x6 about the top layer centre (N/mm, N mm/rad) - top layer = stage? No:
# frame_fe fixes the BOTTOM layer and condenses to the TOP; here the mirror hangs from the bottom and the yoke holds the top,
# so by symmetry of the stack the same stiffness applies with the roles swapped (stiffness is a property of the stack).
# Rotational stiffness about the true axis (y through F): transform the 6x6 from the top-layer centre to F.
c_top = fe["centre"]; r = -c_top                # vector from the top-layer centre to F
Tm = np.eye(6); rx = np.array([[0, r[2], -r[1]], [-r[2], 0, r[0]], [r[1], -r[0], 0]]); Tm[:3, 3:] = rx
K_F = Tm.T @ K @ Tm                              # stiffness expressed at F
K_theta = K_F[4, 4]/1e3                          # N m/rad about the y axis through F
ratio = 1/fe["ratio"]
torque_range = K_theta*np.radians(RANGE_DEG)
log(f"FE: compliant/stiff eigen-ratio {ratio:.2e}; softest direction {np.round(fe['softest'], 3)} (expect theta_y)")
log(f"FE: rotational stiffness about the face-plane axis K_theta = {K_theta:.1f} N m/rad; torque to hold {RANGE_DEG} deg from park = {torque_range:.1f} N m")
# stiff-direction numbers at F: translational stiffness along x, y, z (N/mm) and rotational about x, z
log(f"FE at F: k_x {K_F[0,0]:.0f} N/mm, k_y {K_F[1,1]:.0f}, k_z {K_F[2,2]:.0f}; K_thx {K_F[3,3]/1e3:.0f} N m/rad, K_thz {K_F[5,5]/1e3:.0f} N m/rad")
# first mode of the compliant direction with the mirror's inertia about the axis
m_mirror = 7.5; I_axis = m_mirror*(0.03**2) + m_mirror*(0.44**2 + 0.012**2)/12   # kg m2 (CG 30 mm from the axis)
f1 = np.sqrt(K_theta/I_axis)/(2*np.pi)
log(f"first mode (tilt) with the 7.5 kg mirror: {f1:.1f} Hz (I {I_axis:.3f} kg m2)")
# one wire removed from one interface: stiffness change of that interface (redundancy, brief R-DCM-1)
W0 = [w for e in blk["interfaces"][0]["elements"] for w in e["wrenches"]]
free0, rank0 = interface_freedom(W0); free1, rank1 = interface_freedom(W0[:-1])
log(f"redundancy: interface 0 has {len(W0)} wires; with one removed rank {rank1} (still {6-rank1} DOF); stiffness change ~ {100/len(W0):.2f} %")
# stress and buckling of the most loaded wire: mirror weight 74 N shared by the bottom interface's wires (in tension when hanging)
wires_if = n_wires//N_IF; F_axial = 74.0/wires_if
A_w = np.pi*D_WIRE**2/4; sig_ax = F_axial/A_w
Pcr = np.pi**2*E*(np.pi*D_WIRE**4/64)/(0.7*GAP)**2         # clamped-pinned column, worst case if a gust reverses the load
log(f"wire axial load {F_axial:.2f} N -> {sig_ax:.2f} MPa (tension while hanging); buckling P_cr {Pcr:.1f} N -> SF {Pcr/max(F_axial,1e-6):.0f} if reversed by a 25 m/s gust on the hood (380 N / {wires_if} wires = {380/wires_if:.2f} N)")
# thermal: uniform +40 K on the Ti lattice: the wire lines meet the axis by construction; a uniform dilation about the block
# centroid (z ~ Z0 + H/2) moves the intersection line by -(zc)*alpha*dT
alpha = 8.6e-6; zc = Z0 + H/2; drift = zc*alpha*40
log(f"thermal: uniform +40 K moves the virtual axis by {drift:.3f} mm (no tilt: symmetric); Al mirror 0.44 m grows {440*23e-6*40:.2f} mm, taken by the relief pads")
mass_lattice = (n_wires*A_w*GAP + N_LAYERS*T_LAYER*(NX*CELL)*(NY*CELL)*0.35)*4.43e-6   # layers as 35 % open frames
log(f"mass: lattice {mass_lattice:.1f} kg (wires {n_wires*A_w*GAP*4.43e-6:.2f} kg), mirror 7.5 kg")
open(os.path.join(OUT, "checks.txt"), "w").write("\n".join(LOG))

# ------------------------------------------------------------------ viewer mesh: layers/mirror/hood/yoke as solids, wires as lines
sys.path.insert(0, os.path.join(ROOT, "3d"))
import cadquery as cq
from mesh_export import Scene
sc = Scene()
LX, LY = NX*CELL, NY*CELL
for i, (a, b) in enumerate(layers):
    frame = cq.Workplane("XY").box(LX, LY, T_LAYER).translate((0, 0, 0.5*(a + b)))
    for ix in range(NX):                                   # open the layer into a frame: pockets between the wire anchors
        for iy in range(NY):
            cx, cy = -LX/2 + (ix + 0.5)*CELL, -LY/2 + (iy + 0.5)*CELL
            frame = frame.cut(cq.Workplane("XY").box(CELL*0.55, CELL*0.55, T_LAYER + 2).translate((cx, cy, 0.5*(a + b))))
    sc.add(frame, f"rigid layer {i}" + (" (mirror side)" if i == 0 else " (yoke side)" if i == N_LAYERS - 1 else ""), "#9aa5b1", tol=1.5)
mirror = cq.Workplane("XY").ellipse(220, 180).extrude(12)
fins = mirror
for k in range(-8, 9): fins = fins.union(cq.Workplane("XY").box(2, 300, 28).translate((k*22, 0, 12 + 14)))
sc.add(fins.union(cq.Workplane("XY").box(LX*0.6, LY, 6).translate((0, 0, 43))), "mirror plate + fins + backplate", "#e5e7eb", tol=1.5)
yoke_z = layers[-1][1]
yoke = cq.Workplane("XY").box(LX + 80, 40, 30).translate((0, LY/2 + 40, yoke_z + 15)).union(cq.Workplane("XY").box(LX + 80, 40, 30).translate((0, -LY/2 - 40, yoke_z + 15)))
for sx in (-1, 1): yoke = yoke.union(cq.Workplane("XY").box(40, LY + 120, 30).translate((sx*(LX/2 + 20), 0, yoke_z + 15)))
sc.add(yoke, "yoke frame (to the carriage azimuth bearing)", "#5b6b7f", tol=2.0)
hood = cq.Workplane("XY").circle(330).circle(295).extrude(yoke_z + 40).translate((0, 0, -60))
sc.add(hood, "hood (insulating rim at the bottom)", "#c9cfd6", tol=3.0)
# wires as line segments (start/end where each line crosses the two layer faces bounding its gap)
lines = []
for k, itf in enumerate(blk["interfaces"]):
    zf0, zf1 = layers[k][1], layers[k + 1][0]
    for e in itf["elements"]:
        p, d = np.asarray(e["point"]), np.asarray(e["direction"])/np.linalg.norm(e["direction"])
        t0, t1 = (zf0 - p[2])/d[2], (zf1 - p[2])/d[2]
        lines.append([list(np.round(p + t0*d, 1)), list(np.round(p + t1*d, 1))])
sc.parts.append(dict(name="lattice wires (Ti-6Al-4V, d 1.2 mm)", color="#d9480f", lines=lines))
sc.parts.append(dict(name="tilt axis (in the face plane, through F)", color="#0e7490", lines=[[[-300, 0, 0], [300, 0, 0]]]))
sc.write(os.path.join(OUT, "fold_saddle.json"))

# ------------------------------------------------------------------ 2-D drawings: elevation (x-z) and plan
fig, axs = plt.subplots(1, 2, figsize=(13, 5.2))
ax = axs[0]
for (a, b) in layers: ax.add_patch(plt.Rectangle((-LX/2, a), LX, b - a, fc="#9aa5b1", ec="#14213d", lw=0.8))
for seg in lines: ax.plot([seg[0][0], seg[1][0]], [seg[0][2], seg[1][2]], color="#d9480f", lw=0.4, alpha=0.6)
ax.add_patch(plt.Rectangle((-220, 0), 440, 12, fc="#e5e7eb", ec="#14213d", lw=1.2))
for k in range(-8, 9): ax.add_patch(plt.Rectangle((k*22 - 1, 12), 2, 28, fc="#9ca3af", ec="none"))
ax.plot(0, 0, "o", color="#0e7490", ms=7); ax.text(8, -30, "F, tilt axis (y) in the face plane", color="#0e7490", fontsize=8)
ax.plot([-330, -330], [-60, yoke_z + 40], color="#6b7280", lw=2); ax.plot([330, 330], [-60, yoke_z + 40], color="#6b7280", lw=2)
ax.set_aspect("equal"); ax.set_xlim(-380, 380); ax.set_ylim(-90, yoke_z + 60); ax.set_title(f"elevation: {N_IF} interfaces x {n_wires//N_IF} oblique Ti wires, all meeting the axis at z = 0", fontsize=9, loc="left"); ax.set_xlabel("x [mm]"); ax.set_ylabel("z [mm]")
ax = axs[1]
itf0 = blk["interfaces"][0]
for c in itf0["cells"]: ax.add_patch(plt.Rectangle((c[0] - CELL/2, c[1] - CELL/2), CELL, CELL, fc="none", ec="#c7d0da", lw=0.6))
for e in itf0["elements"]:
    p, d = e["point"], e["direction"]; ax.plot([p[0] - 8*d[0], p[0] + 8*d[0]], [p[1] - 8*d[1], p[1] + 8*d[1]], color="#d9480f", lw=1.0)
ax.plot([-LX/2, LX/2], [0, 0], color="#0e7490", lw=1.5); ax.set_aspect("equal"); ax.set_xlim(-LX/2 - 20, LX/2 + 20); ax.set_ylim(-LY/2 - 20, LY/2 + 20)
ax.set_title("plan of one interface: the five wire directions per cell (projected)", fontsize=9, loc="left"); ax.set_xlabel("x [mm]"); ax.set_ylabel("y [mm]")
fig.suptitle("Fold saddle: DCM block, one rotation about the face-plane axis through F", fontsize=10)
fig.savefig(os.path.join(OUT, "fold_elevation.svg"), bbox_inches="tight"); fig.savefig(os.path.join(OUT, "fold_elevation.png"), dpi=110, bbox_inches="tight"); plt.close(fig)
print("wrote", OUT)

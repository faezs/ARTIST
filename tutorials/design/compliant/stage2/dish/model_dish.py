"""Primary dish pitch stage as a distributed compliant bearing.

Local frame: the pitch axis is the y axis through the dish CG at the
origin (in the dish's rim plane); x is the dish's plane of incidence
direction, z up (away from the membrane). Between the yoke beam below
(ground, carried by the arc-rail followers) and the rim carrier beam
above (stage, bolted to the rim ring and backing) runs a 2 m long
distributed cross-axis blade pivot: N_Y cells along the axis, each a
pair of thin steel blades crossing ON the axis at +-45 deg. Each cell
is an exact 1-DOF pivot (rank 5 of its six lines); the row is heavily
redundant, so one blade lost costs 1/(2 N_Y) of the stiffness and no
freedom (R-DCM-1). Loads: the dish mass and wind pass through the
blades in-plane (stiff, buckling-checked); only the pitch rotation
bends them. Range +-18 deg from one interface (blade bending at the
allowed stress); the neutral (as-built) state is beta = 0 (the retro
orbit, the shadowed but safe geometry).

Outputs (./out): dish_pitch.json (viewer), dish_elevation.svg,
checks.txt."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, os.path.join(ROOT, "3d"))
from dcm_core import dcm_stack, blade_beam, check_block, frame_fe, interface_freedom
from fact_core import rot_twist
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True); LOG = []
def log(*a):
    s = " ".join(str(x) for x in a); print(s); LOG.append(s)

# --------------------------------------------------------------- parameters (mm, N, MPa): 17-7PH CH900 blades
E, G, SY = 204e3, 78e3, 1500.0
SIG_ALLOW = 0.30*SY                       # R3 ambient zone
W_BLADE, T_BLADE, GAP = 150.0, 0.8, 85.0  # blade width along the axis, thickness, vertical gap between beams
L_BLADE = GAP*np.sqrt(2)                   # blade length at 45 deg
N_Y, PITCH_Y = 12, 165.0                   # cells along the axis: 12 x 165 = 1.98 m
RANGE_DEG = 18.0
theta_max = 2*SIG_ALLOW*L_BLADE/(E*T_BLADE)
log(f"blade {W_BLADE} x {T_BLADE} mm, length {L_BLADE:.0f} mm at 45 deg: range at {SIG_ALLOW:.0f} MPa = {np.degrees(theta_max):.1f} deg from neutral (need {RANGE_DEG})")
BEAM_H = 40.0
layers = [(-GAP/2 - BEAM_H, -GAP/2), (GAP/2, GAP/2 + BEAM_H)]    # yoke beam (ground), rim carrier (stage)
def cell(c, h, g):
    return [blade_beam([0.0, c[1], 0.0], [1, 0, 1], [0, 1, 0], W_BLADE, T_BLADE),
            blade_beam([0.0, c[1], 0.0], [-1, 0, 1], [0, 1, 0], W_BLADE, T_BLADE)]
blk = dcm_stack(layers, 1, N_Y, PITCH_Y, cell)
n_bl = sum(len(i["elements"]) for i in blk["interfaces"])
log(f"distributed pivot: {N_Y} cells along 2 m, {n_bl} blades")
check_block(blk, [rot_twist([0, 0, 0], [0, 1, 0])], "dish pitch row")
W0 = [w for e in blk["interfaces"][0]["elements"] for w in e["wrenches"]]
_, r0 = interface_freedom(W0); _, r1 = interface_freedom(W0[3:])
log(f"redundancy: {n_bl} blades ({len(W0)} lines) rank {r0}; one blade removed rank {r1} -> still 1 DOF; stiffness change ~{100/n_bl:.1f} %")
# ---- FE
fe = frame_fe(blk, E=E, G=G, wire_d=1.0, gap=GAP)
c_top = fe["centre"]; r = c_top; Tm = np.eye(6); rx = np.array([[0, r[2], -r[1]], [-r[2], 0, r[0]], [r[1], -r[0], 0]]); Tm[:3, 3:] = rx
K_F = Tm.T @ fe["K"] @ Tm; K_theta = K_F[4, 4]/1e3
log(f"FE: compliant/stiff ratio {1/fe['ratio']:.2e}; softest {np.round(fe['softest'], 3)}")
log(f"FE: K_theta about the pitch axis {K_theta:.0f} N m/rad; spring torque at {RANGE_DEG} deg {K_theta*np.radians(RANGE_DEG):.0f} N m; stiff: k_x {K_F[0,0]/1e3:.0f} kN/mm, k_y {K_F[1,1]/1e3:.0f}, k_z {K_F[2,2]/1e3:.0f} kN/mm; K_thx {K_F[3,3]/1e6:.0f} MN m/rad, K_thz {K_F[5,5]/1e6:.0f} MN m/rad")
# ---- loads (brief 2.1): dish 140 kg (250 survival), wind 0.94 kN at 9 m/s, 7.27 kN at 25 m/s, moments 0.40 / 3.05 kN m, gravity moment <= 30 N m
m_dish = 140.0; Wd = m_dish*9.81
T_work = K_theta*np.radians(RANGE_DEG) + 400.0 + 30.0
log(f"actuator holds spring + wind(9 m/s) + gravity = {T_work:.0f} N m -> {T_work/0.8:.0f} N on the 0.8 m lever (Tr20x4 self-locking screw, R6)")
# in-plane load per blade (dish weight + drag shared by 2 N_Y blades at 45 deg): axial component along the blade
F_vert = Wd + 940.0; F_blade = F_vert/np.sqrt(2)/n_bl
Pcr = np.pi**2*E*(W_BLADE*T_BLADE**3/12)/(0.5*L_BLADE)**2   # clamped-clamped strip
log(f"in-plane load per blade at 9 m/s: {F_blade:.0f} N vs buckling P_cr {Pcr:.0f} N -> SF {Pcr/F_blade:.1f}; at 25 m/s survival (stops engaged, R4): {(2450 + 7270)/np.sqrt(2)/n_bl:.0f} N -> SF {Pcr/((2450 + 7270)/np.sqrt(2)/n_bl):.1f}")
sig_bend = E*T_BLADE*np.radians(RANGE_DEG)/(2*L_BLADE)
log(f"blade bending stress at {RANGE_DEG} deg: {sig_bend:.0f} MPa = {sig_bend/SY:.2f} sigma_y (R3 <= 0.30); daily sweep Goodman with sigma_a = sigma_m = {sig_bend/2:.0f} MPa")
I_dish = 0.5*m_dish*2.1**2*0.6                  # kg m2 about the pitch axis (membrane dish, mass concentrated at the rim ring: ~0.6 m r^2)
f1 = np.sqrt(K_theta/I_dish)/(2*np.pi)
log(f"first pitch mode with the 140 kg dish: {f1:.2f} Hz (I {I_dish:.0f} kg m2); gust band 0.1-2 Hz -> add the eddy damper of the first memo")
alpha = 10.4e-6; log(f"thermal +40 K: steel blades and beams grow together; the axis stays on the crossing line by symmetry; carrier-vs-Al rim relief needed for {2000*23e-6*40 - 2000*alpha*40:.1f} mm differential over 2 m (R9)")
mass = n_bl*W_BLADE*T_BLADE*L_BLADE*7.8e-6 + 2*2000*BEAM_H*60*7.8e-6*0.4
log(f"mass: blades {n_bl*W_BLADE*T_BLADE*L_BLADE*7.8e-6:.2f} kg, two 2 m beams (40 x 60, 40 % open) {2*2000*BEAM_H*60*7.8e-6*0.4:.1f} kg")
open(os.path.join(OUT, "checks.txt"), "w").write("\n".join(LOG))

# --------------------------------------------------------------- viewer mesh: beams, blades as thin boxes, rim ring stub, axis
import cadquery as cq
from mesh_export import Scene
sc = Scene()
Ly = N_Y*PITCH_Y
sc.add(cq.Workplane("XY").box(60, Ly, BEAM_H).translate((0, 0, -GAP/2 - BEAM_H/2)), "yoke beam (ground, on the arc followers)", "#5b6b7f", tol=2.0)
sc.add(cq.Workplane("XY").box(60, Ly, BEAM_H).translate((0, 0, GAP/2 + BEAM_H/2)), "rim carrier beam (stage)", "#9aa5b1", tol=2.0)
for k, itf in enumerate(blk["interfaces"]):
    for j, e in enumerate(itf["elements"]):
        b = cq.Workplane("XY").box(L_BLADE*1.05, W_BLADE, T_BLADE)      # local: x along the blade length, y along the axis, z = normal
        d, n = e["direction"], e["normal"]; a = np.cross(n, d)
        M = np.array([d, a, n]).T
        mat = cq.Matrix([[M[0,0], M[0,1], M[0,2], e["point"][0]], [M[1,0], M[1,1], M[1,2], e["point"][1]], [M[2,0], M[2,1], M[2,2], e["point"][2]], [0, 0, 0, 1]])
        sc.add(cq.Workplane("XY").add(b.val().transformGeometry(mat)), f"blade {j}", "#d9480f", tol=0.8)
# rim ring stub above the carrier to show the interface (the real ring is 4.2 m across)
sc.add(cq.Workplane("XY").box(600, Ly + 200, 30).translate((0, 0, GAP/2 + BEAM_H + 15)), "rim backing (stub of the 4.2 m rim structure)", "#c9cfd6", tol=3.0)
sc.parts.append(dict(name="pitch axis through the dish CG", color="#0e7490", lines=[[[0, -Ly/2 - 200, 0], [0, Ly/2 + 200, 0]]]))
sc.write(os.path.join(OUT, "dish_pitch.json"))
# --------------------------------------------------------------- drawing: end elevation (x-z) of one cell + side view
fig, axs = plt.subplots(1, 2, figsize=(12, 4.6), gridspec_kw=dict(width_ratios=[1, 2]))
ax = axs[0]
for (a, b) in layers: ax.add_patch(plt.Rectangle((-30, a), 60, b - a, fc="#9aa5b1", ec="#14213d", lw=1))
for sgn in (1, -1): ax.plot([-sgn*GAP/2*1.05, sgn*GAP/2*1.05], [-GAP/2*1.05, GAP/2*1.05], color="#d9480f", lw=2.2)
ax.plot(0, 0, "o", color="#0e7490", ms=7); ax.text(6, -14, "pitch axis (y)", color="#0e7490", fontsize=8)
ax.set_aspect("equal"); ax.set_xlim(-120, 120); ax.set_ylim(-GAP/2 - BEAM_H - 20, GAP/2 + BEAM_H + 20); ax.set_title("end view of one cell: two blades cross ON the axis", fontsize=9, loc="left"); ax.set_xlabel("x [mm]"); ax.set_ylabel("z [mm]")
ax = axs[1]
for (a, b) in layers: ax.add_patch(plt.Rectangle((-Ly/2, a), Ly, b - a, fc="#9aa5b1", ec="#14213d", lw=1))
for itf in blk["interfaces"]:
    for e in itf["elements"]:
        yc = e["point"][1]; ax.add_patch(plt.Rectangle((yc - W_BLADE/2, -GAP/2), W_BLADE, GAP, fc="#fdba74", ec="#d9480f", lw=0.8, alpha=0.7))
ax.plot([-Ly/2 - 100, Ly/2 + 100], [0, 0], color="#0e7490", lw=1.5)
ax.set_aspect("equal"); ax.set_xlim(-Ly/2 - 120, Ly/2 + 120); ax.set_ylim(-GAP/2 - BEAM_H - 20, GAP/2 + BEAM_H + 20); ax.set_title(f"side view along the beam: {N_Y} blade pairs over {Ly/1000:.2f} m", fontsize=9, loc="left"); ax.set_xlabel("y [mm]")
fig.suptitle("Dish pitch stage: distributed cross-axis blade pivot between the yoke beam and the rim carrier", fontsize=10)
fig.savefig(os.path.join(OUT, "dish_elevation.svg"), bbox_inches="tight"); fig.savefig(os.path.join(OUT, "dish_elevation.png"), dpi=110, bbox_inches="tight"); plt.close(fig)
print("wrote", OUT)

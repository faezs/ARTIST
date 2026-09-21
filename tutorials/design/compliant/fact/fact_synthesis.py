"""FACT synthesis of the three mirror mechanisms from their freedom
spaces (Hopkins: choose the freedom space, take its reciprocal
constraint space, place independent constraint lines from that space).
Each design is verified exact with fact_core and drawn in 3-D: the
constraint-line space (the FACT 'shape'), then the synthesized flexure
system on the real part geometry."""
import numpy as np, matplotlib, os, sys
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from fact_core import rot_twist, trans_twist, wire, blade, analyse, describe, constraint_space
OUT = sys.argv[1] if len(sys.argv) > 1 else "figures"; os.makedirs(OUT, exist_ok=True)
INK, FLEX, KIN, GND = "#14213d", "#d9480f", "#0e7490", "#9aa5b1"
def seg(ax, p, q, **kw): ax.plot([p[0], q[0]], [p[1], q[1]], [p[2], q[2]], **kw)
def line_through(ax, p, d, half, **kw):
    p, d = np.asarray(p, float), np.asarray(d, float)/np.linalg.norm(d); seg(ax, p - half*d, p + half*d, **kw)
def frame(ax, lim, title):
    ax.set_xlim(-lim, lim); ax.set_ylim(-lim, lim); ax.set_zlim(-lim, lim); ax.set_box_aspect((1, 1, 1))
    ax.set_title(title, fontsize=9, loc="left", color=INK); ax.tick_params(labelsize=6)
    ax.set_xlabel("x", fontsize=7); ax.set_ylabel("y", fontsize=7); ax.set_zlabel("z", fontsize=7)

# =============================================================== 1. FOLD: 1R about an axis in the mirror face plane
# freedom: rotation about the x-axis through the origin (the origin = F, the axis lies in the mirror face plane z = 0)
F_fold = [rot_twist([0, 0, 0], [1, 0, 0])]
Cspace = constraint_space(F_fold); print("fold: constraint space dimension", Cspace.shape[1], "(all lines meeting the axis)")
# synthesis: five wire flexures, every one intersecting the axis: two bipods whose apexes sit ON the axis at
# x = +-150 (the mirror's ends) and a fifth wire through a third axis point, out of the bipod planes.
# Wires run from the mirror's back-plate anchors (z = 40, the mirror is face-down at z <= 0 so nothing sits at the axis)
# to the yoke; their LINES pass through the axis points (the anchor pads are where each line meets the mirror back).
def bipod(apex_x, spread_y, yoke_z):
    """A-frame across the axis: apex ON the axis, the two wires in the plane x = apex_x, which is TRANSVERSE to
    the axis. The pair then spans the pencil of lines through the apex in that plane, which does NOT contain the
    axis line, so two A-frames give rank 4 (a bipod whose plane contained the axis would include the axis line
    in its span and two of them would share it: rank 3, the trap the algebra caught)."""
    A = np.array([apex_x, 0.0, 0.0])
    return [(A, np.array([apex_x, spread_y, yoke_z])), (A, np.array([apex_x, -spread_y, yoke_z]))]
wires = bipod(-150, 100, 180) + bipod(150, 100, 180) + [(np.array([0.0, 0.0, 0.0]), np.array([110.0, 0.0, 180.0]))]   # fifth: a diagonal stay meeting the axis at F
C_fold = [wire(a, b - a) for a, b in wires]
left = analyse(F_fold, C_fold, "fold: 5 wires through the face-plane axis"); print("   left:", describe(left))
# what if the fifth wire is dropped?  -> under-constrained: shows why five are needed
analyse(F_fold, C_fold[:4], "fold: only the two bipods (4 wires)")
fig = plt.figure(figsize=(12, 5)); ax = fig.add_subplot(121, projection="3d")
# the FACT shape: planes of lines through the axis (draw four planes as fans of lines)
for ang in np.linspace(0, np.pi, 6, endpoint=False):
    n = np.array([0, np.cos(ang), np.sin(ang)])            # in-plane direction perpendicular to the axis
    for x0 in np.linspace(-160, 160, 5):
        for t in np.linspace(-1.0, 1.0, 5):
            d = np.array([t, 0, 0]) + n; line_through(ax, [x0, 0, 0], d, 120, color=KIN, lw=0.5, alpha=0.35)
line_through(ax, [0, 0, 0], [1, 0, 0], 220, color=INK, lw=2.5)
frame(ax, 220, "constraint space: every line meeting the axis")
ax = fig.add_subplot(122, projection="3d")
# mirror (face-down disc in z<=0 region drawn as an ellipse at z = 0..-12), back pads at z = 40, yoke bar at z = 180
th = np.linspace(0, 2*np.pi, 80); ax.plot(220*np.cos(th), 180*np.sin(th), 0*th, color=INK, lw=1.5)
ax.plot(220*np.cos(th), 180*np.sin(th), -12 + 0*th, color=INK, lw=0.8)
for a, b in wires:
    # the wire runs from its back-pad (where the line crosses z = 40) up to the yoke; the dashed part is the ideal line down to the axis
    d = (b - a)/np.linalg.norm(b - a); pad = a + d*(40/d[2]) if d[2] > 1e-9 else a
    seg(ax, pad, b, color=FLEX, lw=2.4); seg(ax, a, pad, color=FLEX, lw=0.8, ls="--"); ax.scatter(*pad, color=INK, s=12)
line_through(ax, [0, 0, 0], [1, 0, 0], 240, color=KIN, lw=1.8)
for x in (-150, 150): seg(ax, [x, 100, 180], [x, -100, 180], color=GND, lw=4)
seg(ax, [-150, 100, 180], [150, 100, 180], color=GND, lw=4); seg(ax, [-150, -100, 180], [150, -100, 180], color=GND, lw=4)
frame(ax, 260, "two A-frames + one stay, all meeting the face-plane axis")
fig.suptitle("Beam-down fold: exact 1-DOF rotation about a REMOTE axis lying in the mirror face plane, 5 wire flexures (rank 5)", fontsize=10)
fig.savefig(os.path.join(OUT, "fact_fold_remote_axis.png"), dpi=120, bbox_inches="tight"); fig.savefig(os.path.join(OUT, "fact_fold_remote_axis.svg"), bbox_inches="tight"); plt.close(fig)

# =============================================================== 2. DISH PITCH: 1R with blades, and the series (butterfly) extension
F_dish = [rot_twist([0, 0, 0], [0, 1, 0])]      # pitch axis along y through the dish CG (origin)
C_stage = blade([0, 0, 0], [1, 0, 1], [0, 1, 0]) + blade([0, 0, 0], [1, 0, -1], [0, 1, 0])   # one cross-axis pair
analyse(F_dish, C_stage, "dish: one cross-axis blade pair (rank 5 of 6 lines)")
# a serial hybrid: two identical 1R stages about the SAME axis in series (intermediate body) -> still 1R, twice the range,
# each stage takes half the angle (the butterfly / RCC-series principle).  In FACT, serial freedoms add: F = F1 + F2 = same line.
print("dish: series of two 1R stages about the same axis -> freedom space = the union of two identical twists = 1R; range doubles (18 deg per stage at half the stress)")
fig = plt.figure(figsize=(12, 5)); ax = fig.add_subplot(121, projection="3d")
for ang in (np.radians(45), np.radians(-45)):
    n = np.array([np.sin(ang), 0, np.cos(ang)])   # blade plane normal; the plane contains the y-axis
    u = np.array([np.cos(ang), 0, -np.sin(ang)])
    for s in np.linspace(-150, 150, 7):
        seg(ax, [s*u[0], -75, s*u[2]], [s*u[0], 75, s*u[2]], color=FLEX, lw=1.2)
    for yy in np.linspace(-75, 75, 5): seg(ax, [-150*u[0], yy, -150*u[2]], [150*u[0], yy, 150*u[2]], color=FLEX, lw=0.6, alpha=0.6)
line_through(ax, [0, 0, 0], [0, 1, 0], 200, color=KIN, lw=2)
frame(ax, 200, "one stage: two blade planes through the axis, rank 5")
ax = fig.add_subplot(122, projection="3d")
for k, (x0, col) in enumerate(((-260, FLEX), (260, "#f59e0b"))):
    for ang in (np.radians(45), np.radians(-45)):
        u = np.array([np.cos(ang), 0, -np.sin(ang)])
        for s in np.linspace(-120, 120, 5): seg(ax, [x0 + s*u[0], -75, s*u[2]], [x0 + s*u[0], 75, s*u[2]], color=col, lw=1.2)
seg(ax, [-260, 0, 140], [260, 0, 140], color=GND, lw=5); seg(ax, [-260, 0, -140], [260, 0, -140], color=INK, lw=5)
line_through(ax, [0, 0, 0], [0, 1, 0], 320, color=KIN, lw=2)
frame(ax, 330, "series hybrid: two stages, one axis, double range")
fig.suptitle("Dish pitch: 1-DOF rotation about the pitch axis; blades (constraint planes) carry the load; series stages extend range", fontsize=10)
fig.savefig(os.path.join(OUT, "fact_dish_pitch_series.png"), dpi=120, bbox_inches="tight"); fig.savefig(os.path.join(OUT, "fact_dish_pitch_series.svg"), bbox_inches="tight"); plt.close(fig)

# =============================================================== 3. M5 FACET: tip/tilt/piston left free, set by three screws
F_facet = [rot_twist([0, 0, 0], [1, 0, 0]), rot_twist([0, 0, 0], [0, 1, 0]), trans_twist([0, 0, 1])]
Cs = constraint_space(F_facet); print("facet: constraint space dimension", Cs.shape[1], "(all lines in the facet plane)")
R = 130.0; angs = np.radians([90, 210, 330])
C_facet = [wire([R*np.cos(a), R*np.sin(a), 0], [-np.sin(a), np.cos(a), 0]) for a in angs]      # three tangential in-plane wires
left = analyse(F_facet, C_facet, "facet: 3 tangential in-plane wires"); print("   left:", describe(left))
# plus three screws (hard contacts) along z at the same radius: they are the remaining three constraints -> 0 DOF, adjustable
C_full = C_facet + [wire([R*np.cos(a), R*np.sin(a), 0], [0, 0, 1]) for a in angs]
analyse(F_facet, C_full, "facet: wires + 3 screw contacts (intended: the screws take the 3 freedoms -> 0 DOF, adjustable)")
fig = plt.figure(figsize=(12, 5)); ax = fig.add_subplot(121, projection="3d")
for a in np.linspace(0, np.pi, 12, endpoint=False):
    for off in np.linspace(-150, 150, 7): line_through(ax, [off*np.cos(a + np.pi/2), off*np.sin(a + np.pi/2), 0], [np.cos(a), np.sin(a), 0], 170, color=KIN, lw=0.5, alpha=0.35)
th = np.linspace(0, 2*np.pi, 80); ax.plot(150*np.cos(th), 150*np.sin(th), 0*th, color=INK, lw=1.5)
frame(ax, 190, "constraint space: every line in the facet plane")
ax = fig.add_subplot(122, projection="3d")
ax.plot(150*np.cos(th), 150*np.sin(th), 0*th, color=INK, lw=1.8)
for a in angs:
    p = np.array([R*np.cos(a), R*np.sin(a), 0]); t = np.array([-np.sin(a), np.cos(a), 0])
    seg(ax, p - 45*t, p + 45*t, color=FLEX, lw=3)                       # tangential wire between two frame posts
    for e in (-1, 1): seg(ax, p + e*45*t, p + e*45*t + [0, 0, -60], color=GND, lw=3)
    seg(ax, p + [0, 0, -60], p + [0, 0, -4], color="#7c3aed", lw=2.5); ax.scatter(*(p + [0, 0, -4]), color="#7c3aed", s=25)  # screw contact
seg(ax, [-170, -170, -60], [170, -170, -60], color=GND, lw=2); seg(ax, [-170, 170, -60], [170, 170, -60], color=GND, lw=2)
seg(ax, [-170, -170, -60], [-170, 170, -60], color=GND, lw=2); seg(ax, [170, -170, -60], [170, 170, -60], color=GND, lw=2)
frame(ax, 190, "3 tangential wires + 3 screw contacts (purple)")
fig.suptitle("M5 facet mount: the flexure leaves exactly the three adjusted freedoms; radial expansion only bends the wires (athermal)", fontsize=10)
fig.savefig(os.path.join(OUT, "fact_facet_tangential_wires.png"), dpi=120, bbox_inches="tight"); fig.savefig(os.path.join(OUT, "fact_facet_tangential_wires.svg"), bbox_inches="tight"); plt.close(fig)
print("figures written to", OUT)

"""Hashemi's roof machine, to scale, from the video: sphere R 2 m ("a circle with a radius of two meters"),
focus distance f = R/2 = 1 m, dish 2 m across (a = 1), so the rim's sag is 0.268 m and the screws from the
rim beam to the axis through F are f - sag = 0.73 m - the paper's 73 cm.  Hoop from fig 14: two 1.8 m arms
riding a ring, so radius 2 m.  Posts: F sits 1.4 m over the frame because the dish's low edge at el 45 is
1.22 m under F.  Slot: the focal base passes through the dish at high sun (fig 12), so the dish is cut from
the rim to the centre along the downhill meridian."""
import numpy as np, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Circle, Rectangle

R, f, a = 2.0, 1.0, 1.0
sag = R - np.sqrt(R*R - a*a); rod = f - sag
R_ring = 2.0; z_beam = -1.40; z_deck = -1.50
w_slot, r_slot0 = 0.10, 0.06
BG, INK, DIM, ROD, RED, BLUE, COP = "#f4f1ea", "#2b2b2b", "#8a8378", "#a0522d", "#c0392b", "#2c6fbd", "#b87333"

def arc_pts(el_deg, n=200):
    el = np.radians(el_deg); s = np.array([np.cos(el), np.sin(el)])
    Cs = f*s; th = np.arcsin(a/R); base = np.arctan2(-s[1], -s[0])
    ph = np.linspace(base - th, base + th, n)
    return Cs + R*np.stack([np.cos(ph), np.sin(ph)], 1), s, Cs

fig = plt.figure(figsize=(15, 10.5), facecolor=BG)
gs = fig.add_gridspec(2, 3, height_ratios=[1.35, 1.0], hspace=0.28, wspace=0.18)
axS = fig.add_subplot(gs[0, :2]); axF = fig.add_subplot(gs[0, 2]); axD = fig.add_subplot(gs[1, 0])
axK = fig.add_subplot(gs[1, 1:])
for ax in (axS, axF, axD, axK):
    ax.set_facecolor(BG); ax.set_aspect("equal"); ax.axis("off")

# ---- A. side view along the trunnion axis, sun at 45 deg
pts, s, Cs = arc_pts(45.0)
axS.add_patch(Circle(Cs, R, fill=False, ec=INK, lw=0.6, alpha=0.45))
axS.add_patch(Circle((0, 0), f, fill=False, ec=RED, lw=1.1, ls="--"))
axS.plot(pts[:, 0], pts[:, 1], color=BLUE, lw=3.2, solid_capstyle="round")
V = -f*s; rimc = V + sag*s
axS.plot([rimc[0], 0], [rimc[1], 0], color=ROD, lw=2.6)                              # the screws, in-plane: f - sag
axS.plot([0, 0], [z_deck, 0], color=DIM, lw=1.4)                                     # the focal base, through the slot
for sg in (1, -1):
    axS.plot([sg*0.45, 0], [z_beam, 0], color=INK, lw=1.6)                            # the two A legs (both posts overlap)
axS.plot([-R_ring, R_ring], [z_beam, z_beam], color=INK, lw=2.0)                     # the beam on the hoop
axS.plot([-R_ring, R_ring], [z_beam - 0.06, z_beam - 0.06], color=RED, lw=2.4, alpha=0.8)  # the hoop
for x in (-R_ring, R_ring, 0):
    axS.add_patch(Circle((x, z_beam - 0.03), 0.06, fc=BG, ec=INK, lw=1.2))
lo = pts[np.argmin(pts[:, 1])]; drum = (0.95, z_beam + 0.05)
axS.plot([lo[0], drum[0]], [lo[1], drum[1]], color=DIM, lw=1.0)
axS.add_patch(Circle(drum, 0.07, fc="#555", ec=INK))
axS.add_patch(Circle((0, 0), 0.05, fc=COP, ec=INK, lw=0.8)); axS.add_patch(Circle((0, 0), 0.10, fill=False, ec=INK, lw=0.8))
axS.plot([Cs[0]], [Cs[1]], "+", color=INK, ms=9)
axS.annotate("F: the copper marker. The trunnion axis comes\nout of the page here; nothing else is here", (0, 0), (0.95, 0.15), fontsize=9, color=INK,
             arrowprops=dict(arrowstyle="-", color=INK, lw=0.6))
axS.annotate("centre of the 2 m sphere", Cs, (Cs[0] + 0.55, Cs[1] + 0.05), fontsize=8.5, color=INK, arrowprops=dict(arrowstyle="-", color=INK, lw=0.6))
axS.text(rimc[0] - 1.25, rimc[1] - 0.05, f"screws, rim beam to the axis:\nf - sag = {f:.2f} - {sag:.2f} = {rod:.2f} m", fontsize=9.5, color=ROD, ha="center", va="top")
axS.text(0.08, -0.72, "focal base,\nthrough the slot", fontsize=8.5, color=DIM, ha="left", va="center")
axS.text(1.05, -0.35, "focus circle, radius f:\nthe vertex rides it and the\ndish stays tangent to it", fontsize=8.5, color=RED, va="center")
axS.text(R_ring, z_beam - 0.28, "hoop, radius 2 m\n(two 1.8 m arms, fig 14)", fontsize=8.5, color=INK, ha="right", va="top")
axS.text(0.55, z_beam + 0.12, "drum: the tow-wire loop\n(half-inch rods in the build)", fontsize=8.5, color=DIM, ha="left", va="bottom")
axS.text(-1.55, 0.6, "posts: 1.4 m\nfrom the frame to F", fontsize=8.5, color=INK)
axS.set_xlim(-2.3, 2.6); axS.set_ylim(-1.75, 1.25)
axS.set_title("Side view along the trunnion axis, sun at 45 deg    R 2 m, f 1 m, dish 2 m", fontsize=11, color=INK, loc="left")

# ---- B. front view along the tilt direction, sun at 90 (the dish flat under F)
yy = np.linspace(-a, a, 200); zz = f - np.sqrt(R*R - yy*yy) + (0)  # sphere centre at (0, +f), vertex at -f
zz = f - np.sqrt(R*R - yy*yy)
m = np.abs(yy) > w_slot/2
axF.plot(np.where(m, yy, np.nan), zz, color=BLUE, lw=3.2, solid_capstyle="round")
for sg in (1, -1):
    axF.plot([sg*a, sg*a], [-f + sag, 0], color=ROD, lw=2.6)                        # the screws, vertical
    axF.plot([sg*(a + 0.09), sg*a], [z_beam, 0], color=INK, lw=1.6)                  # the post
    axF.add_patch(Circle((sg*a, 0), 0.06, fc=BG, ec=INK, lw=1.2))                     # the bearing
axF.plot([-a, a], [0, 0], color=INK, lw=0.8, ls=":")
axF.plot([0, 0], [z_deck, 0], color=DIM, lw=1.4)
axF.plot([-R_ring, R_ring], [z_beam, z_beam], color=INK, lw=2.0)
axF.plot([-R_ring, R_ring], [z_beam - 0.06, z_beam - 0.06], color=RED, lw=2.4, alpha=0.8)
axF.add_patch(Circle((0, 0), 0.05, fc=COP, ec=INK, lw=0.8))
axF.text(a + 0.14, -0.36, f"{rod:.2f} m", fontsize=10, color=ROD, va="center")
axF.text(0, 0.22, "axis through F,\nbearings at the rim's half-width", fontsize=8.5, color=INK, ha="center")
axF.text(0.1, -f - 0.02, "slot", fontsize=8.5, color=DIM, va="top")
axF.set_xlim(-2.3, 2.3); axF.set_ylim(-1.75, 0.6)
axF.set_title("Front view, sun overhead: cradled between the posts", fontsize=11, color=INK, loc="left")

# ---- C. face on: the fixed-focus notch
axD.add_patch(Circle((0, 0), a, fill=False, ec=BLUE, lw=3.0))
for r_ in (0.35, 0.65, 0.86):
    axD.add_patch(Circle((0, 0), r_*a, fill=False, ec=BLUE, lw=0.6, alpha=0.5))
axD.add_patch(Rectangle((-w_slot/2, -a - 0.02), w_slot, a - r_slot0 + 0.02, fc=BG, ec=INK, lw=1.0))
for sg in (1, -1):
    for ps in (np.radians(10), -np.radians(10)):
        axD.plot([sg*a*np.cos(ps)], [a*np.sin(ps)], "o", color=ROD, ms=6)
axD.plot([0], [0], "+", color=INK)
axD.text(0, -a - 0.12, "the fixed-focus notch: the focal base passes through the dish at high sun,\nso it is cut from the rim to the centre along the downhill meridian (fig 12)", fontsize=8.5, color=INK, ha="center", va="top")
axD.text(a + 0.08, 0.02, "the two screws\na side", fontsize=8.5, color=ROD, va="center")
axD.set_xlim(-1.35, 1.75); axD.set_ylim(-1.55, 1.25)
axD.set_title("Face on", fontsize=11, color=INK, loc="left")

# ---- D. the same drawing at three focal ratios, dish widths equalised
def lowest_over_year(R_, f_, a_):
    zmin = 0.0
    for el_ in np.linspace(0, 90, 91):
        s_ = np.array([np.cos(np.radians(el_)), np.sin(np.radians(el_))]); Cs_ = f_*s_
        th_ = np.arcsin(a_/R_); base_ = np.arctan2(-s_[1], -s_[0]); ph_ = np.linspace(base_ - th_, base_ + th_, 200)
        zmin = min(zmin, float((Cs_[1] + R_*np.sin(ph_)).min()))
    return zmin
cases = [("his roof machine", 2.0, 1.0, 1.0), ("your f 1.25 gore sphere", 2.5, 1.25, 2.1), ("the env's pump membrane", 8.1, 4.05, 2.1)]
x0 = 0.0
for name, R_, f_, a_ in cases:
    k = 1.0/a_                                   # draw every dish 2 units wide
    sag_ = R_ - np.sqrt(R_*R_ - a_*a_); rod_ = f_ - sag_
    zb = lowest_over_year(R_, f_, a_) - 0.18*a_
    yy_ = np.linspace(-a_, a_, 200); zz_ = f_ - np.sqrt(R_*R_ - yy_*yy_)
    axK.plot(x0 + k*yy_, k*zz_, color=BLUE, lw=2.6)
    for sg in (1, -1):
        axK.plot([x0 + sg*k*a_]*2, [k*(-f_ + sag_), 0], color=ROD, lw=2.2)
        axK.plot([x0 + sg*k*(a_ + 0.06*a_), x0 + sg*k*a_], [k*zb, 0], color=INK, lw=1.3)
    axK.plot([x0 - 1.6, x0 + 1.6], [k*zb]*2, color=INK, lw=1.6)
    axK.add_patch(Circle((x0, 0), 0.04, fc=COP, ec=INK, lw=0.6))
    axK.text(x0, 0.35, f"{name}\nf {f_:.2f} m  dish {2*a_:.1f} m  f/D {f_/(2*a_):.2f}", fontsize=8.8, color=INK, ha="center", va="bottom")
    axK.text(x0, k*zb - 0.12, f"screws {rod_:.2f} m   posts {-zb:.2f} m", fontsize=8.8, color=ROD, ha="center", va="top")
    x0 += 3.9
axK.set_xlim(-1.9, x0 - 3.9 + 1.9); axK.set_ylim(-4.6, 1.2)
axK.set_title("The same mechanism at three focal ratios (dish widths equalised): the screws are f - sag, the posts reach F", fontsize=11, color=INK, loc="left")
fig.suptitle("Hashemi's fixed focus, at the dimensions in the video", fontsize=14, color=INK, x=0.06, ha="left", y=0.975)
import os; out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out", "hashemi_dims.png")
fig.savefig(out, dpi=125, facecolor=BG, bbox_inches="tight"); print("wrote", out, f"sag {sag:.3f} rod {rod:.3f}")

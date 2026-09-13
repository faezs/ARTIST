"""2-D pseudo-rigid-body renders of the compliant elements chosen in the
memos, drawn from their parametric dimensions: undeflected and
deflected states side by side. Pure matplotlib -> SVG (no CAD kernel).
Deflected shapes: cross-axis blades at uniform curvature theta/L (the
memo's PRBM), fixed-guided blades as the cubic S-curve, the bistable
arch as cosine states A/B, the rim as an ellipse squeezed +-1.5 %."""
import numpy as np, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Polygon, Circle, FancyArrowPatch, Ellipse, Arc
import os, sys
OUT = sys.argv[1] if len(sys.argv) > 1 else "figures"
os.makedirs(OUT, exist_ok=True)
INK, ACC, ACC2, GREY = "#1f2937", "#c2410c", "#0e7490", "#9ca3af"
def style(ax, title, unit="mm"):
    ax.set_aspect("equal"); ax.set_title(title, fontsize=10, loc="left", color=INK)
    ax.set_xlabel(unit, fontsize=8); ax.tick_params(labelsize=7); ax.grid(alpha=0.15)
def save(fig, name):
    p = os.path.join(OUT, name); fig.savefig(p, bbox_inches="tight"); fig.savefig(p.replace(".svg", ".png"), bbox_inches="tight", dpi=110); plt.close(fig); print("wrote", p)

# ---------------------------------------------------------------- 1. cross-axis flexural pivot
def blade_arc(P0, ang0, L, theta, n=60):
    """blade of length L leaving P0 at angle ang0, bent to uniform curvature theta/L (PRBM of the memo)"""
    s = np.linspace(0, L, n)
    if abs(theta) < 1e-6:
        return P0[0] + s*np.cos(ang0), P0[1] + s*np.sin(ang0)
    R = L/theta; a = ang0 + s/R
    x = P0[0] + R*(np.sin(a) - np.sin(ang0)); y = P0[1] - R*(np.cos(a) - np.cos(ang0))
    return x, y
def cross_axis(L, t, theta_deg, name, label):
    fig, axs = plt.subplots(1, 2, figsize=(9, 4.2))
    for ax, th in zip(axs, (0.0, np.radians(theta_deg))):
        h = L/np.sqrt(2)
        # blades cross at the origin (remote centre), 90 deg apart, anchored on the ground at the bottom
        for sgn in (+1, -1):
            P0 = (-sgn*h/2, -h/2)
            x, y = blade_arc(P0, np.pi/4 if sgn > 0 else 3*np.pi/4, L, th if sgn > 0 else th)
            ax.plot(x, y, color=ACC, lw=max(1.2, 40*t/L)); ax.plot(P0[0], P0[1], "s", color=INK, ms=6)
        # moving platform: rotated by theta about the remote centre
        c, s = np.cos(th), np.sin(th)
        plat = np.array([[-h/2, h/2], [h/2, h/2], [h/2, h/2+0.25*L], [-h/2, h/2+0.25*L]]) @ np.array([[c, s], [-s, c]])
        ax.add_patch(Polygon(plat, closed=True, fc="#e5e7eb", ec=INK, lw=1.2))
        ax.plot(0, 0, "o", color=ACC2, ms=6); ax.annotate("remote centre", (0, 0), (0.15*L, -0.05*L), fontsize=8, color=ACC2, arrowprops=dict(arrowstyle="-", color=ACC2, lw=0.8))
        ax.add_patch(Rectangle((-h, -h/2-0.12*L), 2*h, 0.12*L, fc="#d1d5db", ec=INK, hatch="///", lw=0.8))
        style(ax, f"{label}: {'undeflected' if th == 0 else f'rotated {theta_deg:.0f} deg (sigma = E t theta / 2L)'}")
        ax.set_xlim(-1.0*L, 1.0*L); ax.set_ylim(-0.75*L, 1.1*L)
    fig.suptitle(f"Cross-axis flexural pivot (Handbook A.1.10): blades L = {L:g} mm, t = {t:g} mm, crossing at 90 deg", fontsize=10)
    save(fig, name)
cross_axis(60, 0.6, 20, "fold_cross_axis_pivot.svg", "fold at F, Ti-6Al-4V")
cross_axis(300, 2.0, 36, "dish_cross_axis_pivot.svg", "dish pitch stage, 17-7PH")

# ---------------------------------------------------------------- 2. cartwheel flexure
def cartwheel(Ro, Ri, t, theta_deg, name):
    fig, axs = plt.subplots(1, 2, figsize=(9, 4.2))
    for ax, th in zip(axs, (0.0, np.radians(theta_deg))):
        ax.add_patch(Circle((0, 0), Ro, fc="none", ec=INK, lw=1.2)); ax.add_patch(Circle((0, 0), Ri, fc="#e5e7eb", ec=INK, lw=1.2))
        for k in range(4):
            a0 = k*np.pi/2 + np.pi/4
            # spoke from the hub (rotated by theta) to the rim (fixed): fixed-guided S-curve between rotated ends
            p_in = Ri*np.array([np.cos(a0+th), np.sin(a0+th)]); p_out = Ro*np.array([np.cos(a0), np.sin(a0)])
            u = np.linspace(0, 1, 40); chord = p_out - p_in; nrm = np.array([-chord[1], chord[0]])/np.linalg.norm(chord)
            lateral = (Ro-Ri)*np.sin(th)*0.5*(3*u**2 - 2*u**3 - u)  # S-shape bookkeeping for the rotated end
            pts = p_in[None, :] + u[:, None]*chord[None, :] + lateral[:, None]*nrm[None, :]
            ax.plot(pts[:, 0], pts[:, 1], color=ACC, lw=1.4)
        ax.plot([0, Ri*np.cos(np.pi/2+th)], [0, Ri*np.sin(np.pi/2+th)], color=ACC2, lw=1.0)
        style(ax, "cartwheel flexure (A.1.11): " + ("undeflected" if th == 0 else f"hub rotated {theta_deg:.0f} deg"))
        ax.set_xlim(-1.2*Ro, 1.2*Ro); ax.set_ylim(-1.2*Ro, 1.2*Ro)
    fig.suptitle(f"Cartwheel flexure alternative for the fold: rim R {Ro:g} mm, hub R {Ri:g} mm, spokes t = {t:g} mm", fontsize=10)
    save(fig, name)
cartwheel(45, 12, 0.6, 15, "fold_cartwheel_alternative.svg")

# ---------------------------------------------------------------- 3. parallel-motion (parallelogram) stage
def parallelogram(L, t, w_gap, delta, name, title):
    fig, axs = plt.subplots(1, 2, figsize=(9, 3.8))
    for ax, d in zip(axs, (0.0, delta)):
        u = np.linspace(0, 1, 60); S = 3*u**2 - 2*u**3               # fixed-guided beam shape (A.1.4)
        drop = -1.2*d*d/L                                             # parasitic shortening of a fixed-guided beam
        for x0 in (0, w_gap):                                         # two blades side by side, feet on the ground
            ax.plot(x0 + d*S, u*L + drop*u, color=ACC, lw=max(1.2, 40*t/L))
        ax.add_patch(Rectangle((-0.15*L, -0.12*L), w_gap+0.3*L, 0.12*L, fc="#d1d5db", ec=INK, hatch="///", lw=0.8))
        ax.add_patch(Rectangle((d-0.15*L, L+drop), w_gap+0.3*L, 0.12*L, fc="#e5e7eb", ec=INK, lw=1.2))
        if d:
            ax.add_patch(FancyArrowPatch((0, L+0.22*L), (d, L+0.22*L), arrowstyle="->", color=ACC2, lw=1.2, mutation_scale=12))
            ax.text(w_gap/2, L+0.28*L, f"delta = {delta:g} mm, parasitic drop {abs(drop):.2f} mm", ha="center", fontsize=8, color=ACC2)
        style(ax, "parallel-motion stage (12.2.4): " + ("undeflected" if d == 0 else "translated"))
        ax.set_xlim(-0.3*L, w_gap+0.5*L); ax.set_ylim(-0.2*L, 1.45*L)
    fig.suptitle(title, fontsize=10); save(fig, name)
parallelogram(60, 0.5, 30, 6, "m5_carriage_parallel_motion.svg", "M5 facet foot carriage: two blades 12 x 0.5 x 60 mm; adjuster stroke +-30 mrad")
parallelogram(150, 1.5, 80, 3, "dish_roller_suspension.svg", "Dish arc-rail roller suspension: blades 150 x 1.5 x 80 mm, k = 32.6 kN/m, +-3 mm rail waviness")

# ---------------------------------------------------------------- 4. bistable cosine arch (wind trip)
def bistable(L, h, t, name):
    fig, axs = plt.subplots(1, 3, figsize=(11, 3.6), gridspec_kw=dict(width_ratios=[1, 1, 0.9]))
    x = np.linspace(0, L, 200)
    for ax, sgn, lab in zip(axs[:2], (1, -1), ("state A: armed (arch up)", "state B: tripped (snapped through)")):
        ax.plot(x, sgn*h/2*(1 - np.cos(2*np.pi*x/L)), color=ACC, lw=2.2)
        for xe in (0, L): ax.add_patch(Rectangle((xe-0.05*L, -0.12*L), 0.1*L, 0.24*L, fc="#d1d5db", ec=INK, hatch="///", lw=0.8))
        ax.add_patch(FancyArrowPatch((L/2, sgn*h+0.25*L), (L/2, sgn*h+0.05*L), arrowstyle="->", color=ACC2, lw=1.4, mutation_scale=14)); ax.text(L/2, sgn*h+0.28*L, "drag plate load F", ha="center", fontsize=8, color=ACC2)
        style(ax, lab); ax.set_xlim(-0.1*L, 1.1*L); ax.set_ylim(-1.4*h-0.15*L, 1.4*h+0.3*L)
    ax = axs[2]; d = np.linspace(0, 2*h, 200); F = 10*np.sin(np.pi*d/h)*(1 - 0.35*d/(2*h)) + 5
    ax.plot(d, F, color=ACC, lw=1.8); ax.axhline(0, color=GREY, lw=0.8); ax.axhline(14.6, color=ACC2, lw=1, ls="--"); ax.text(0.45*2*h, 13.2, "14.6 N = 9 m/s on 0.25 m2", fontsize=7, color=ACC2)
    ax.set_title("force vs travel: snap at ~15 N, returns at ~7 m/s (built-in hysteresis)", fontsize=9, loc="left", color=INK); ax.set_xlabel("travel [mm]", fontsize=8); ax.set_ylabel("F [N]", fontsize=8); ax.tick_params(labelsize=7); ax.grid(alpha=0.15)
    fig.suptitle(f"Bistable cosine arch wind trip (12.3.2 / 4.4.2): span {L:g} mm, rise {h:g} mm, t = {t:g} mm", fontsize=10); save(fig, name)
bistable(200, 12, 0.8, "dish_bistable_wind_trip.svg")

# ---------------------------------------------------------------- 5. rim toroid squeeze (top view)
def rim(name):
    fig, axs = plt.subplots(1, 3, figsize=(12, 4.6)); a = 2100.0
    for ax, e, lab in zip(axs, (0.0, 0.033, 0.048), ("circular rim (reference)", "as built: 3.3 % ellipse (beta ~ 28 deg)", "squeezed +1.5 %: 4.8 % ellipse (beta 36 deg)")):
        A = a*(1+e/2); B = a*(1-e/2)
        ax.add_patch(Ellipse((0, 0), 2*A, 2*B, fc="#eef2ff", ec=INK, lw=2.0))
        X = 10.0; ax.add_patch(Ellipse((0, 0), 2*a*(1+X*e/2), 2*a*(1-X*e/2), fc="none", ec=ACC2, lw=1.2, ls="--"))
        ax.plot([0, 0], [-B, -B-320], color=ACC, lw=3); ax.plot([0, 0], [B, B+320], color=ACC, lw=3)
        for sgn in (1, -1): ax.add_patch(Rectangle((sgn*A-(0 if sgn > 0 else 200), -50), 200, 100, fc="#fde68a", ec=INK, lw=0.8))
        ax.text(0, B+430, f"2a = {2*A:.0f} mm, 2b = {2*B:.0f} mm", ha="center", fontsize=8, color=INK)
        style(ax, lab); ax.set_xlim(-1.45*a, 1.45*a); ax.set_ylim(-1.55*a, 1.45*a)
    axs[0].text(0, 0, "dashed: ellipticity\nexaggerated 10x", ha="center", fontsize=7, color=ACC2)
    fig.text(0.5, -0.01, "orange: Tr10x2 squeeze link (bottom) and fixed link (top) along the pitch axis;  yellow: radially soft blades 250 x 1.2 x 120 mm on the tangential axis", ha="center", fontsize=8)
    fig.suptitle("Primary dish rim as the astigmatism-correcting toroid squeeze (A.1.6): a/b = 1/cos(beta/2); the film's 1.08 % pretension strain caps the stroke", fontsize=10); save(fig, name)
rim("dish_rim_toroid_squeeze.svg")

# ---------------------------------------------------------------- 6. fold assembly side view with tilt range
def fold_side(name):
    fig, axs = plt.subplots(1, 3, figsize=(12, 4.6))
    for ax, el_b, lab in zip(axs, (8.0, 40.0, 60.0), ("beam el 8 deg -> tilt 41 deg", "beam el 40 deg -> tilt 25 deg", "beam el 60 deg -> tilt 15 deg")):
        tilt = np.radians(45 - el_b/2)
        # yoke arms from below, cross-bar above; hood = inverted cup: top plate + side walls ending in the firebrick rim
        for sx in (-1, 1): ax.plot([sx*300, sx*300], [-420, 150], color=INK, lw=3)
        ax.plot([-300, 300], [150, 150], color=INK, lw=3)
        ax.plot([-330, 330], [120, 120], color="#6b7280", lw=1.5)
        for sx in (-1, 1):
            ax.plot([sx*330, sx*330], [120, -40], color="#6b7280", lw=1.5)
            ax.add_patch(Rectangle((sx*330-25, -80), 50, 40, fc="#fca5a5", ec=INK, lw=0.8))
        c, s = np.cos(tilt), np.sin(tilt); half = 220
        plate = np.array([[-half, 0], [half, 0], [half, 12], [-half, 12]]) @ np.array([[c, s], [-s, c]])
        ax.add_patch(Polygon(plate, closed=True, fc="#e5e7eb", ec=INK, lw=1.4))
        for k in range(-4, 5):
            fx = k*45; fin = np.array([[fx-1.5, 12], [fx+1.5, 12], [fx+1.5, 40], [fx-1.5, 40]]) @ np.array([[c, s], [-s, c]]); ax.add_patch(Polygon(fin, closed=True, fc="#9ca3af", ec="none"))
        for sgn in (-1, 1):
            pv = np.array([[sgn*170-45, 14], [sgn*170+45, 14], [sgn*170+45, 60], [sgn*170-45, 60]]) @ np.array([[c, s], [-s, c]])
            ax.add_patch(Polygon(pv, closed=True, fc="#fdba74", ec=INK, lw=0.8))
        ax.plot(0, 0, "o", color=ACC2, ms=7)
        eb = np.radians(el_b)
        ax.add_patch(FancyArrowPatch((-620*np.cos(eb), -620*np.sin(eb)), (-30*np.cos(eb), -30*np.sin(eb)), arrowstyle="->", color=ACC, lw=2.2, mutation_scale=14))
        ax.add_patch(FancyArrowPatch((0, -30), (0, -560), arrowstyle="->", color=ACC, lw=2.2, mutation_scale=14))
        style(ax, lab); ax.set_xlim(-700, 420); ax.set_ylim(-620, 220)
    axs[0].legend(handles=[plt.Line2D([], [], color=ACC, lw=2.2, label="beam: in from the dish, out straight down the post"),
                           plt.Line2D([], [], marker="o", color=ACC2, lw=0, label="F = pivot centre, in the mirror face plane"),
                           Rectangle((0, 0), 1, 1, fc="#fdba74", ec=INK, label="cross-axis pivots (Ti-6Al-4V), on the back"),
                           Rectangle((0, 0), 1, 1, fc="#e5e7eb", ec=INK, label="6061 mirror plate, integral fins"),
                           Rectangle((0, 0), 1, 1, fc="#fca5a5", ec=INK, label="hood rim: 40 mm insulating firebrick")],
                  loc="lower left", fontsize=7, framealpha=0.95)
    fig.suptitle("Beam-down fold at F: mirror hangs face-down under a fixed hood; its normal bisects the beam and the vertical (tilt = 45 - el_b/2)", fontsize=10); save(fig, name)
fold_side("fold_assembly_side.svg")

# ---------------------------------------------------------------- 7. M5 facet on three bipod feet (side view) + foot detail
def facet_feet(name):
    fig, axs = plt.subplots(1, 2, figsize=(10, 4.0), gridspec_kw=dict(width_ratios=[1.4, 1]))
    ax = axs[0]; xs = np.linspace(-160, 160, 100); ax.plot(xs, 0.0004*xs**2, color=INK, lw=3); ax.text(0, 25, "facet: 1.5 mm anodised Al, pressed toroid (R_t, R_s)", ha="center", fontsize=8)
    for fx in (-130, 0, 130):
        for sgn in (-1, 1): ax.plot([fx, fx+sgn*22], [0.0004*fx**2, -60], color=ACC, lw=1.6)
        ax.add_patch(Rectangle((fx-28, -100), 56, 40, fc="#e5e7eb", ec=INK, lw=1.0)); ax.plot([fx-30, fx-30], [-100, -60], color=ACC, lw=1.2); ax.plot([fx+30, fx+30], [-100, -60], color=ACC, lw=1.2)
        ax.add_patch(Rectangle((fx-8, -125), 16, 25, fc="#fdba74", ec=INK, lw=0.6))
    ax.add_patch(Rectangle((-200, -140), 400, 15, fc="#d1d5db", ec=INK, hatch="///", lw=0.8)); ax.text(-195, -160, "frame", fontsize=8)
    fig.text(0.5, -0.02, "three feet, each a bipod of two 2.5 x 0.5 x 40 mm strips: constrain normal + tangent, free radially (exact constraint, athermal by symmetry); carriage: parallel-motion blades 12 x 0.5 x 60 mm; M6 detent adjuster, 0.28 mrad per click", ha="center", fontsize=7.5, wrap=True)
    style(ax, "M5 facet on three compliant feet (side view)"); ax.set_xlim(-230, 230); ax.set_ylim(-215, 60)
    ax = axs[1]; ax.add_patch(Polygon([[0, 0], [60, 0], [60, 8], [0, 8]], fc="#fdba74", ec=INK)); ax.text(30, 12, "folded 0.5 mm 301 blank", ha="center", fontsize=7)
    for sgn in (-1, 1): ax.plot([30, 30+sgn*20], [8, 48], color=ACC, lw=2.2)
    ax.add_patch(Rectangle((22, 48), 16, 6, fc="#e5e7eb", ec=INK)); ax.text(30, 58, "facet pad", ha="center", fontsize=7)
    ax.add_patch(FancyArrowPatch((-5, 28), (15, 28), arrowstyle="<->", color=ACC2, lw=1, mutation_scale=9)); ax.text(5, 32, "free", fontsize=7, color=ACC2)
    ax.add_patch(FancyArrowPatch((50, 20), (50, 40), arrowstyle="<->", color=GREY, lw=1, mutation_scale=9)); ax.text(52, 28, "stiff", fontsize=7, color=GREY)
    style(ax, "bipod foot: two strips in a V"); ax.set_xlim(-15, 75); ax.set_ylim(-5, 68)
    fig.suptitle("M5 relay facet mount (Handbook 12.2.4 parallel motion + FACT-style exact constraint)", fontsize=10); save(fig, name)
facet_feet("m5_facet_feet.svg")
print("done")

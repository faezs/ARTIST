#!/usr/bin/env python
"""The pedicel as it now is: the stage that actually points the flower.

Drawn from the year's schedule (out/path.json) and the geometry the two simulations use (setup_sim5.py, flower_elastica.py):
a 1 m steel stem on the deck, a slew-and-luff joint at its top, a telescoping boom, a wrist that keeps the receptacle ring
coaxial with the head, and the six constant-length struts that carry the head off that ring.

The diagram states the thing the simulations showed and the register had not caught up with: the pedicel has five degrees of
freedom (slew, luff, extend, and the wrist's two), the head needs five, so the pedicel alone fixes the pose. The six struts
never change their commanded length - 1.446348 m at every pose in the year - so they are a rigid truss carrying a fine stage
of +-15 mm, not a hexapod that moves the head."""
import os, json, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch, Circle
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
PJ = json.load(open(os.path.join(OUT, "path.json"))); PD = json.load(open(os.path.join(OUT, "pedicel.json")))
LOG = [l for l in PJ["log"] if l.get("ok")]
S = np.array(PD["stem"]); D_REC, D_BACK, A_M, G = PD["d_rec"], 0.6, 2.1, 4.0
R_REC, R_PLAT, R_STEM = 1.5, 1.0, 0.1075
Z_F = 0.35 + np.hypot(G, A_M); F = np.array([0.0, 0.0, Z_F]); R_PIPE = 0.7
def pose(doy, hour):
    c = [l for l in LOG if l["doy"] == doy and abs(l["hour"] - hour) < 0.01]
    if not c: return None
    l = c[0]; P = np.array(l["P"]); n = np.array(l["n"]); return P, n/np.linalg.norm(n), l
def frame(n):
    ref = np.array([-1.0, 0, 0]); x = ref - n*(ref@n)
    if np.linalg.norm(x) < 1e-6: x = np.array([0, 1.0, 0]) - n*n[1]
    x /= np.linalg.norm(x); return x, np.cross(n, x)
RC = 8.0
def elevation(ax, P, n, col, lab, alpha=1.0):
    """the machine in its own meridian: the vertical plane through the stem and the head. X = distance from the stem along the
    boom's horizontal heading, Z = height over the deck. Every part is projected, nothing is schematic except that the six
    struts are drawn as the two that lie in this plane."""
    Cb = P - D_REC*n; Cp = P - D_BACK*n
    e3 = np.array([Cb[0] - S[0], Cb[1] - S[1], 0.0]); e3 = e3/max(np.linalg.norm(e3), 1e-9)
    to2 = lambda q: np.array([(np.asarray(q) - S)@e3, np.asarray(q)[2]])
    r3 = e3 - n*(e3@n); r3 = r3/max(np.linalg.norm(r3), 1e-9)                      # the in-plane radius of the rings and the rim
    s2, cb2, cp2, p2 = to2(S), to2(Cb), to2(Cp), to2(P)
    ax.plot([s2[0]]*2, [0, s2[1]], color="#5b3a12", lw=8, solid_capstyle="butt", alpha=alpha, zorder=3)          # the stem
    ax.plot([s2[0], cb2[0]], [s2[1], cb2[1]], color=col, lw=5.5, alpha=alpha, zorder=3)                           # the boom
    for c3, R in ((Cb, R_REC), (Cp, R_PLAT)):                                                                     # the two rings, edge on
        a_, b_ = to2(c3 - R*r3), to2(c3 + R*r3); ax.plot([a_[0], b_[0]], [a_[1], b_[1]], color=col, lw=3.5, alpha=alpha, zorder=3)
    for sg in (-1, 1):                                                                                            # the struts that lie in this plane
        a_, b_ = to2(Cb + sg*R_REC*r3), to2(Cp + sg*R_PLAT*r3)
        ax.plot([a_[0], b_[0]], [a_[1], b_[1]], color="#b45309", lw=2.4, alpha=alpha, zorder=3)
    aa = np.linspace(-A_M, A_M, 61); sag = RC - np.sqrt(np.maximum(RC**2 - aa**2, 0.0))
    mem = np.array([to2(P + aa[k]*r3 + sag[k]*n) for k in range(len(aa))])
    ax.plot(mem[:, 0], mem[:, 1], color="#64748b", lw=3, alpha=alpha, zorder=3)                                   # the membrane, in section
    f2 = to2(F)
    for k in (0, len(mem)//2, -1): ax.plot([mem[k, 0], f2[0]], [mem[k, 1], f2[1]], color="#d4a017", lw=0.8, ls=(0, (2, 3)), alpha=alpha, zorder=2)
    ax.plot(*s2, "o", color="#0e7490", ms=10, alpha=alpha, zorder=4); ax.plot(*cb2, "o", color="#0e7490", ms=9, alpha=alpha, zorder=4)
    return dict(s=s2, cb=cb2, cp=cp2, p=p2, f=f2, mem=mem, col=col, lab=lab)
if __name__ == "__main__":
    pe = pose(80, 12.0); pm = pose(80, 9.0)                                    # equinox noon (retracted) and 9 h (extended)
    fig = plt.figure(figsize=(16.5, 9.6))
    gs = fig.add_gridspec(3, 3, width_ratios=[1.55, 1, 1], height_ratios=[1, 1, 0.9], hspace=0.42, wspace=0.26)
    # ---------------- the machine, in section, dimensioned
    from matplotlib.lines import Line2D
    ax = fig.add_subplot(gs[:, 0]); ax.set_aspect("equal")
    E = elevation(ax, *pm[:2], "#0e7490", "9 h", alpha=0.32)
    N = elevation(ax, *pe[:2], "#7c2d12", "noon")
    fx = N["f"][0]
    ax.fill_betweenx([0, Z_F], fx - R_PIPE, fx + R_PIPE, color="#cbd5e1", zorder=1)
    ax.plot(fx, Z_F, "o", color="#7c3aed", ms=9, zorder=5); ax.text(fx, Z_F + 0.32, "F", fontsize=11, color="#7c3aed", ha="center")
    ax.text(fx, -0.48, "light pipe, r 0.7", fontsize=8, color="#64748b", ha="center")
    ax.axhline(0, color="#94a3b8", lw=1.4, zorder=1)
    ax.text(N["s"][0] + 0.9, -0.48, "roof deck", fontsize=8, color="#64748b", ha="left")
    for D, lab, dy in ((E, "9 h: boom 3.22 m, luff -31 deg", 0.40), (N, "noon: boom 1.07 m, luff +33 deg", -0.62)):
        m_ = 0.5*(D["s"] + D["cb"])
        ax.text(m_[0], m_[1] + dy, lab, fontsize=8.5, color=D["col"], ha="center", zorder=6,
                bbox=dict(fc="white", ec="none", alpha=0.8, pad=1.5))
    ax.annotate("", xy=(N["s"][0] + 0.55, N["s"][1]), xytext=(N["s"][0] + 0.55, 0), arrowprops=dict(arrowstyle="<->", color="#334155", lw=1.0))
    ax.text(N["s"][0] + 0.70, 0.5*N["s"][1], "1.0 m", fontsize=8, color="#334155", va="center")
    keys = [Line2D([], [], color="#5b3a12", lw=6, label="stem, 215 x 9 CHS, on the deck"),
            Line2D([], [], color="#7c2d12", lw=5, label="boom, 219 x 8, telescoping 0.90-3.30 m"),
            Line2D([], [], color="#0e7490", marker="o", ls="", ms=8, label="servos: slew + luff at the stem, wrist at the tip"),
            Line2D([], [], color="#b45309", lw=2.4, label="six struts, 1.446 m, length FIXED (+-15 mm of trim)"),
            Line2D([], [], color="#64748b", lw=3, label="the membrane in section, and the two rings it rides"),
            Line2D([], [], color="#d4a017", lw=1, ls=(0, (2, 3)), label="the beam to F")]
    ax.legend(handles=keys, fontsize=8, loc="upper left", framealpha=0.93, borderpad=0.6)
    allx = np.concatenate([E["mem"][:, 0], N["mem"][:, 0], [fx - 1.4, N["s"][0] + 1.0]])
    ally = np.concatenate([E["mem"][:, 1], N["mem"][:, 1], [-0.9, Z_F + 0.9]])
    ax.set_xlim(allx.min() - 0.5, allx.max() + 0.5); ax.set_ylim(-1.0, max(ally.max(), Z_F) + 1.4); ax.set_axis_off()
    ax.set_title("the pedicel in its own meridian, to scale: equinox noon and 9 h", fontsize=10)
    # ---------------- plan of the receptacle's path
    ax = fig.add_subplot(gs[0, 1]); ax.set_aspect("equal")
    Cb = np.array([np.array(l["P"]) - D_REC*np.array(l["n"])/np.linalg.norm(l["n"]) for l in LOG])
    sc = ax.scatter(Cb[:, 0], Cb[:, 1], c=[l["doy"] for l in LOG], s=7, cmap="twilight", alpha=0.85)
    ax.plot(S[0], S[1], "o", color="#5b3a12", ms=9); ax.text(S[0] + 0.15, S[1] + 0.15, "stem", fontsize=8, color="#5b3a12")
    ax.add_patch(Circle((0, 0), R_PIPE, color="#a3aab5")); ax.text(0.1, -1.0, "pipe", fontsize=8, color="#64748b")
    plt.colorbar(sc, ax=ax, label="day of year", shrink=0.85)
    ax.set_xlabel("x north (m)"); ax.set_ylabel("y (m)"); ax.set_title("where the boom must put the receptacle, over the year", fontsize=9)
    # ---------------- joint travel
    ax = fig.add_subplot(gs[0, 2])
    names = ["boom extend\n(m)", "slew\n(deg)", "luff\n(deg)", "wrist\n(deg)"]
    lims = [PD["boom"], PD["slew"], PD["luff"], PD["wrist"]]
    for i, (nm, (lo, hi)) in enumerate(zip(names, lims)):
        ax.barh(i, hi - lo, left=lo, height=0.45, color="#0e7490", alpha=0.85)
        ax.text(hi + 0.02*(max(h for _, h in lims) - min(l for l, _ in lims)), i, f"{lo:.2f} .. {hi:.2f}", va="center", fontsize=8)
    ax.set_yticks(range(4)); ax.set_yticklabels(names, fontsize=8); ax.invert_yaxis()
    ax.set_title("what each joint must travel (342 poses of the year)", fontsize=9); ax.grid(axis="x", alpha=0.25)
    # ---------------- boom length and wrist against the sun
    ax = fig.add_subplot(gs[1, 1])
    R = np.array(PD["rows"]); day = R[:, 0]; hr = R[:, 1]
    for d, c in ((35, "#1d4ed8"), (80, "#0e7490"), (170, "#d97706")):
        m = np.abs(day - d) < 6
        if m.any(): ax.plot(hr[m], R[m, 3], "o-", ms=3, lw=1.2, color=c, label=f"day {d}")
    ax.set_xlabel("solar hour"); ax.set_ylabel("boom length (m)"); ax.legend(fontsize=7.5); ax.grid(alpha=0.25)
    ax.set_title("the boom over a day: it does the pointing", fontsize=9)
    ax = fig.add_subplot(gs[1, 2])
    for d, c in ((35, "#1d4ed8"), (80, "#0e7490"), (170, "#d97706")):
        m = np.abs(day - d) < 6
        if m.any(): ax.plot(hr[m], R[m, 6], "o-", ms=3, lw=1.2, color=c)
    ax.set_xlabel("solar hour"); ax.set_ylabel("wrist angle (deg)"); ax.grid(alpha=0.25)
    ax.set_title("the wrist: it keeps the ring coaxial with the head", fontsize=9)
    # ---------------- what the pedicel carries, and the degrees of freedom
    ax = fig.add_subplot(gs[2, 1:]); ax.set_axis_off()
    txt = ("THE LOAD AT THE STEM        the receptacle stands 0.74-3.29 m horizontally from the stem.\n"
           "   dead load                 130 kg head on 3.29 m  ->  4.2 kN m at the stem top\n"
           "   9 m/s peak gust           3.05 kN of drag        -> +10.0 kN m,  13.1 kN m at the stem's root\n"
           "   15 m/s peak gust          8.47 kN of drag        -> +27.9 kN m,  36.3 kN m at the root (the 215 x 9 stem's case)\n\n"
           "THE DEGREES OF FREEDOM      slew + luff + extend + the wrist's two = 5.  A sphere's image needs 5 (its centre of\n"
           "   curvature's 3, and the axis's 2; spin about the axis moves nothing).  So THE PEDICEL ALONE FIXES THE POSE.\n"
           "   The six struts' commanded length is 1.446348 m at every pose in the year: they are a rigid truss, and their\n"
           "   only authority is the loop's +-15 mm of feedback and the +-2 mm dither.  Sheets 56-57 draw the other machine,\n"
           "   where the ring sits on the stem top and the struts really are the actuation, running 1.7-4.9 m.")
    ax.text(0.0, 1.0, txt, fontsize=8.6, family="monospace", va="top", linespacing=1.45)
    fig.suptitle("The pedicel: the stage that points the flower, as the simulations actually run it", fontsize=12)
    fig.savefig(os.path.join(OUT, "pedicel.png"), dpi=110, bbox_inches="tight"); print("wrote", os.path.join(OUT, "pedicel.png"))

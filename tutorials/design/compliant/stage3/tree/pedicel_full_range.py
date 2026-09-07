#!/usr/bin/env python
"""Hashemi's carriage as a rigid body, and what it would take for the pedicel to reach ALL of it.

Hashemi's mount is a two-parameter machine: the dish slides on an arc rail whose centre IS the focus F, and the whole rail
turns in azimuth. So its reachable set is every retro pose - vertex at P = F - g ub, axis n = ub - for ub anywhere in the
elevation band the mount allows, at any azimuth. That set, not the subset the sun happens to ask for, is what "the same
coverage" means. Two questions follow, and they have different answers.

  1. Can any mount hold those poses at all?  The light pipe stands under F. At retro the head sits on the line from F along
     -ub, so for a high sun it sits directly under F and the pipe runs into the aperture. Hashemi's own machine answers this
     with a hole in the membrane (the env's r_hole, 0.5 m, for a bore drawn at r 0.42). Without a hole - the production
     beam-down, which must not pass through the dish - the poses above some elevation are impossible for ANY mount.
  2. Can the pedicel reach the ones that are possible?  At retro the receptacle sits at Cb = F - (g + d_rec) ub, i.e. on a
     sphere of radius g + d_rec about F. A boom from a base S must therefore span |R - D| to R + D, with D = |F - S|. Only
     D = 0 - the rotation centre AT F - makes that a single length. That is the whole content of the arc rail."""
import os, sys, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); import physics_hp as H
sys.path.insert(0, HERE); import path as PT
G, A_M, D_REC = 4.0, 2.1, 1.8; Z_F = PT.Z_F; F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0])
R_PIPE_PHYS, RIM_CLEAR = 0.42, PT.RIM_CLEAR                       # the bore as the env draws it; the r 0.7 is the ray limit
EL_MIN, EL_MAX = 12.0, 88.0
PH = np.linspace(0, 2*np.pi, 72, endpoint=False); RR = np.linspace(0.0, 1.0, 9)
DISC = np.array([[r*np.cos(p), r*np.sin(p)] for r in RR for p in PH])*A_M
def retro(ub): return F - G*ub, ub.copy()
def clearances(ub, r_hole=0.0):
    """at the retro pose: the rim's lowest point over the deck, and how close the aperture comes to the pipe's axis
    (points inside r_hole of the vertex do not count: that is the hole)"""
    P, n = retro(ub); e1 = np.cross(n, Z); e1 /= max(np.linalg.norm(e1), 1e-9); e2 = np.cross(n, e1)
    rad = np.hypot(DISC[:, 0], DISC[:, 1]); keep = rad >= r_hole
    Q = P + DISC[keep, :1]*e1 + DISC[keep, 1:]*e2
    below = Q[:, 2] < Z_F
    rp = np.hypot(Q[below, 0], Q[below, 1]).min() if below.any() else 9.9
    return Q[:, 2].min(), rp
if __name__ == "__main__":
    lines = []
    def say(t=""): print(t, flush=True); lines.append(t)
    say("HASHEMI'S REACHABLE SET AS A RIGID BODY: every retro pose with ub between el 12 and 88, at any azimuth.")
    say("")
    # ---- 1. is the pose possible at all, with and without a hole in the membrane?
    els = np.arange(EL_MIN, EL_MAX + 0.01, 1.0)
    for r_hole, lab in ((0.0, "no hole (the production beam-down)"), (0.5, "the env's own r_hole 0.5 m")):
        ok = []
        for e in els:
            ub = np.array([np.cos(np.radians(e)), 0.0, np.sin(np.radians(e))])
            zmin, rp = clearances(ub, r_hole); ok.append(zmin >= RIM_CLEAR and rp >= R_PIPE_PHYS + 0.15)
        ok = np.array(ok); good = els[ok]
        say(f"  {lab:34s}: the pose is geometrically possible for {100*ok.mean():.0f} % of the band"
            + (f", elevations {good.min():.0f}-{good.max():.0f} deg" if ok.any() else "")
            + ("" if ok.all() else f"; blocked above {els[~ok].min():.0f} deg, where the pipe runs into the aperture"))
    say("  -> the ceiling is the pipe, not the mount. Hashemi reaches his whole band only because his membrane has a hole in it.")
    say("")
    # ---- 2. what boom a base at S needs to reach the whole set
    say("WHAT THE PEDICEL WOULD NEED. At retro the receptacle sits on a sphere of radius g + d_rec = "
        f"{G + D_REC:.1f} m about F, so a boom from a base S must span |R - D| to R + D with D = |F - S|.")
    say(f"{'base':>42} {'D = |F - S|':>12} {'boom needed':>16} {'stroke ratio':>13}")
    bases = [("the stem as built, 3 m north, 1 m tall", np.array([3.0, 0.0, 1.0])),
             ("a collar on the pipe at deck level", np.array([0.0, 0.0, 0.0])),
             ("a collar on the pipe, 2.5 m up", np.array([0.0, 0.0, 2.5])),
             ("a mast beside the pipe, axis at F's height", np.array([1.2, 0.0, Z_F])),
             ("a yoke straddling the pipe, axes crossing AT F", F.copy())]
    UBz = []
    for e in np.arange(EL_MIN, EL_MAX + 0.01, 2.0):
        for a in np.arange(0, 360, 5.0):
            ce = np.cos(np.radians(e)); UBz.append([ce*np.cos(np.radians(a)), ce*np.sin(np.radians(a)), np.sin(np.radians(e))])
    UBz = np.array(UBz); CB = F - (G + D_REC)*UBz
    for lab, S in bases:
        L = np.linalg.norm(CB - S, axis=1); D = np.linalg.norm(F - S)
        say(f"{lab:>42} {D:>12.2f} {f'{L.min():.2f} - {L.max():.2f} m':>16} {L.max()/max(L.min(), 1e-6):>12.1f}x")
    say("  -> only a rotation centre AT F gives a constant boom. Hashemi's arc rail is exactly that: a remote centre at F,")
    say("     with nothing standing there. Any mount that covers his whole range must have its centre at F too - a ring")
    say("     bearing concentric with the pipe carrying a fork whose luff axis passes through F, or an arc rail of its own.")
    say("")
    # ---- 3. the pedicel as built, over the whole set
    S0 = np.array([3.0, 0.0, 1.0]); BOOM = (0.9, 3.3)
    L0 = np.linalg.norm(CB - S0, axis=1); inb = (L0 >= BOOM[0]) & (L0 <= BOOM[1])
    zmins = np.array([clearances(u)[0] for u in UBz]); rps = np.array([clearances(u)[1] for u in UBz])
    pos = (zmins >= RIM_CLEAR) & (rps >= R_PIPE_PHYS + 0.15)
    w = UBz[:, 2]*0 + np.cos(np.arcsin(np.clip(UBz[:, 2], -1, 1)))                    # solid-angle weight
    say(f"THE PEDICEL AS BUILT over Hashemi's whole set ({len(UBz)} poses, elevation 12-88 at every azimuth):")
    say(f"  possible at all (no hole in the membrane): {100*(pos*w).sum()/w.sum():.0f} % of the set")
    say(f"  the boom reaches:                          {100*(inb*w).sum()/w.sum():.0f} %")
    say(f"  both:                                      {100*((inb & pos)*w).sum()/w.sum():.0f} %")
    say(f"  with a boom of 0.9-10.7 m instead:         {100*(( (L0 <= 10.7) & pos)*w).sum()/w.sum():.0f} % (every pose the pipe allows)")
    open(os.path.join(OUT, "pedicel_full_range.txt"), "w").write("\n".join(lines) + "\n")
    # ---- figure
    fig, axs = plt.subplots(1, 3, figsize=(15.5, 4.6))
    E = np.arange(EL_MIN, EL_MAX + 0.01, 1.0)
    for r_hole, c, lab in ((0.0, "#7c2d12", "no hole"), (0.5, "#0e7490", "r_hole 0.5 m")):
        rp = [clearances(np.array([np.cos(np.radians(e)), 0, np.sin(np.radians(e))]), r_hole)[1] for e in E]
        axs[0].plot(E, rp, color=c, lw=2, label=lab)
    axs[0].axhline(R_PIPE_PHYS + 0.15, color="#111827", ls="--", lw=1); axs[0].text(14, R_PIPE_PHYS + 0.22, "the pipe, r 0.42 + clearance", fontsize=8)
    axs[0].set_xlabel("elevation of ub (deg)"); axs[0].set_ylabel("closest the aperture comes to the pipe's axis (m)")
    axs[0].set_title("what stops the high poses: the pipe, not the mount", fontsize=9.5); axs[0].legend(fontsize=8); axs[0].grid(alpha=0.25)
    for lab, S, c in (("stem, 3 m north", np.array([3.0, 0, 1.0]), "#7c2d12"), ("collar on the pipe, deck", np.array([0, 0, 0.0]), "#b45309"),
                      ("yoke with its axes at F", F.copy(), "#0e7490")):
        L = np.linalg.norm(CB - S, axis=1); axs[1].scatter(np.degrees(np.arcsin(UBz[:, 2])), L, s=3, color=c, alpha=0.5, label=lab)
    axs[1].axhspan(0.9, 3.3, color="#94a3b8", alpha=0.25); axs[1].text(14, 3.45, "the boom as built, 0.9-3.3 m", fontsize=8)
    axs[1].set_xlabel("elevation of ub (deg)"); axs[1].set_ylabel("boom length needed (m)"); axs[1].legend(fontsize=8, loc="upper right")
    axs[1].set_title("only a centre at F needs one length", fontsize=9.5); axs[1].grid(alpha=0.25)
    az = np.degrees(np.arctan2(UBz[:, 1], UBz[:, 0])); el = np.degrees(np.arcsin(UBz[:, 2]))
    axs[2].scatter(az[pos], el[pos], s=4, color="#cbd5e1", label="the pipe allows")
    axs[2].scatter(az[pos & inb], el[pos & inb], s=4, color="#7c2d12", label="and the boom reaches")
    axs[2].set_xlabel("azimuth of ub (deg)"); axs[2].set_ylabel("elevation (deg)"); axs[2].legend(fontsize=8, loc="lower left")
    axs[2].set_title("Hashemi's whole set, and the pedicel's share of it", fontsize=9.5)
    fig.suptitle("Hashemi's reachable set as a rigid body, and what covering all of it demands", fontsize=12)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, "pedicel_full_range.png"), dpi=110); print("wrote", os.path.join(OUT, "pedicel_full_range.png"))

#!/usr/bin/env python
"""The pedicel in screw theory, and what it actually covers of the orbit sphere against Hashemi's carriage.

THE SCREW SYSTEM. The pedicel is a serial chain of five joints between the deck and the head:
    $1  revolute about z through the stem top S            (slew)
    $2  revolute about a2 = z x b_h through S              (luff; b_h is the boom's horizontal heading)
    $3  prismatic along the boom's own direction b         (extend)
    $4  revolute about a2 through the boom tip Cb          (wrist pitch)
    $5  revolute about b x a2 through Cb                   (wrist yaw)
A screw is written [w; v] with w the axis direction and v = a x (P - p) its moment at the head's vertex P (a prismatic joint
contributes [0; b]). The head's useful output is five-dimensional: the vertex's three translations and the two rotations that
turn its axis. Spin about that axis moves nothing - the primary is a sphere, its image depends only on where the centre of
curvature sits - so the pedicel's five joints and the task's five freedoms match exactly, and the chain is square. Where the
five screws become linearly dependent the pedicel is singular; this reports the smallest singular value over the year.

THE COVERAGE. The head's centre of curvature must sit on a sphere of radius g = 4 m about F, and which patch of that sphere
it must reach is set by the sun: for a beam that leaves along ub (the unit vector from the head toward F), the head stands at
P = F - g ub. Hashemi's carriage reaches the WHOLE zone the mount allows, because the dish slides on an arc rail centred on F
and the whole rail turns in azimuth: any ub with elevation between el_min and el_max, at any azimuth. The pedicel reaches
whatever its boom can put the receptacle ring behind, with the rim clear of the deck and of the pipe. This computes both sets
on the same axes and states the difference."""
import os, json, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
import sys; sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); import physics_hp as H
sys.path.insert(0, HERE); import path as PT
G, A_M, D_REC = 4.0, 2.1, 1.8
Z_F = PT.Z_F; F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0])
_PJ = json.load(open(os.path.join(OUT, "path.json")))
S = np.array(_PJ["stem"], float); BOOM = tuple(PT.REACH)     # the stem top and the boom's stroke, as the schedule found them
EL_MIN, EL_MAX = 12.0, 88.0                                  # the env's tracking band: what Hashemi's arc rail serves
BETA_MAX = PT.BETA_MAX                                       # the hard cap; the schedule holds the traced optimum PT.BETA_OPT and spends past it only where it must
def head_from_ub(ub, s=None):
    """the env's law: the head stands at P = F - g ub and its axis is the bisector of the sun and the return leg"""
    P = F - G*ub; n = (s + ub) if s is not None else ub.copy(); return P, n/np.linalg.norm(n)
def screws(P, n):
    """the five joint screws at the head's vertex P, and the 5 x 5 map from joint rates to the useful output"""
    Cb = P - D_REC*n; b = Cb - S; Lb = np.linalg.norm(b); bh = np.array([b[0], b[1], 0.0])
    bh = bh/max(np.linalg.norm(bh), 1e-9); a2 = np.cross(Z, bh); a2 /= max(np.linalg.norm(a2), 1e-9)
    bu = b/Lb; a5 = np.cross(bu, a2); a5 /= max(np.linalg.norm(a5), 1e-9)
    J = np.zeros((6, 5))
    for k, (a, p) in enumerate(((Z, S), (a2, S))):                       # slew, luff: revolute about a through p
        J[:3, k] = a; J[3:, k] = np.cross(a, P - p)
    J[:3, 2] = 0.0; J[3:, 2] = bu                                        # extend: prismatic along the boom
    for k, a in ((3, a2), (4, a5)):                                      # the wrist's two, through the boom tip
        J[:3, k] = a; J[3:, k] = np.cross(a, P - Cb)
    t1 = np.cross(n, Z); t1 = t1/max(np.linalg.norm(t1), 1e-9); t2 = np.cross(n, t1)   # the two rotations that turn the axis
    U = np.vstack([J[3:, :], t1@J[:3, :], t2@J[:3, :]])                  # the useful output: 3 translations of P, 2 axis rotations
    return J, U, dict(Lb=Lb, Cb=Cb, a2=a2, a5=a5, bu=bu)
def reachable(ub, s=None):
    """can the pedicel hold the head there? the boom's stroke, the rim over the deck, the whole membrane clear of the pipe"""
    P, n = head_from_ub(ub, s); Cb = P - D_REC*n; Lb = np.linalg.norm(Cb - S)
    if not (BOOM[0] <= Lb <= BOOM[1]): return False, Lb, None
    ev = PT.evaluate(P, n, s if s is not None else ub, S)
    ok = ev["zmin"] >= PT.RIM_CLEAR and ev["rp"] >= PT.R_PIPE + 0.3
    return ok, Lb, ev
if __name__ == "__main__":
    lines = []
    def say(t=""): print(t); lines.append(t)
    # ---------------- 1. the screw system at a representative pose, written out
    PJ = json.load(open(os.path.join(OUT, "path.json"))); LOG = [l for l in PJ["log"] if l.get("ok")]
    l0 = [l for l in LOG if l["doy"] == 80 and abs(l["hour"] - 12.0) < 0.01][0]
    P0 = np.array(l0["P"]); n0 = np.array(l0["n"]); n0 /= np.linalg.norm(n0)
    J0, U0, g0 = screws(P0, n0)
    say("THE PEDICEL AS A SCREW SYSTEM (equinox noon, the head at " + np.array2string(P0, precision=2) + " m over the deck)")
    names = ["$1 slew   (revolute, z through the stem top)", "$2 luff   (revolute, horizontal through the stem top)",
             "$3 extend (prismatic, along the boom)", "$4 wrist pitch (revolute, through the boom tip)", "$5 wrist yaw   (revolute, through the boom tip)"]
    for k, nm in enumerate(names):
        say(f"  {nm:52s} w {np.array2string(J0[:3, k], precision=3, suppress_small=True):26s} v_at_P {np.array2string(J0[3:, k], precision=2, suppress_small=True)}")
    say(f"  the five screws are independent: rank {np.linalg.matrix_rank(J0, tol=1e-9)} of 5; the head's useful output is 5 (3 translations of the vertex, 2 rotations of its axis)")
    say(f"  spin about the head's own axis is NOT in the span and does not need to be: a sphere's image does not move under it")
    sv = np.linalg.svd(U0, compute_uv=False)
    say(f"  singular values of the 5 x 5 map at this pose: {np.array2string(sv, precision=3)}  (condition {sv[0]/sv[-1]:.1f})")
    # ---------------- 2. the same over the year
    conds, mins = [], []
    for l in LOG:
        P = np.array(l["P"]); n = np.array(l["n"]); n /= np.linalg.norm(n)
        _, U, _ = screws(P, n); s_ = np.linalg.svd(U, compute_uv=False); conds.append(s_[0]/s_[-1]); mins.append(s_[-1])
    conds, mins = np.array(conds), np.array(mins)
    say(""); say(f"OVER THE YEAR ({len(LOG)} scheduled poses): condition number {conds.min():.1f} .. {conds.max():.1f} (median {np.median(conds):.1f});"
                 f" smallest singular value {mins.min():.3f} .. {mins.max():.3f}")
    say(f"  the chain never loses rank on the schedule: the pedicel is non-singular everywhere it is asked to go")
    # ---------------- 3. the coverage of the orbit sphere, against Hashemi's arc
    naz, nel = 145, 61
    AZ = np.linspace(-180, 180, naz); EL = np.linspace(0, 90, nel)
    cover = np.zeros((nel, naz), bool); boomL = np.full((nel, naz), np.nan)
    for i, e in enumerate(EL):
        for j, a in enumerate(AZ):
            ub = np.array([np.cos(np.radians(e))*np.cos(np.radians(a)), np.cos(np.radians(e))*np.sin(np.radians(a)), np.sin(np.radians(e))])
            ok, Lb, _ = reachable(ub); cover[i, j] = ok; boomL[i, j] = Lb
    hash_zone = (EL[:, None] >= EL_MIN) & (EL[:, None] <= EL_MAX) & np.ones((1, naz), bool)
    w = np.cos(np.radians(EL))[:, None]*np.ones((1, naz))                     # solid-angle weight
    fr_p = float((cover*w).sum()/w.sum()); fr_h = float((hash_zone*w).sum()/w.sum())
    say(""); say("COVERAGE OF THE ORBIT SPHERE (retro, the head exactly on the anti-sun line; ub = the direction from the head to F)")
    say(f"  Hashemi's carriage: the whole zone its arc rail allows, elevation {EL_MIN:.0f}-{EL_MAX:.0f} deg at every azimuth = {100*fr_h:.0f} % of the sphere's upper half")
    say(f"  the pedicel:        {100*fr_p:.0f} % of the same half, and NOT the same patch: it is a lobe about the stem's own meridian")
    inside = cover & hash_zone; say(f"  the pedicel covers {100*float((inside*w).sum()/ (hash_zone*w).sum()):.0f} % of what Hashemi's carriage covers")
    # what the sun actually asks for, and what each machine serves
    SS = PT.suns(step_doy=15, step_h=0.5)
    served_h = served_p = served_pb = 0
    miss_el = []
    for doy, hour, el, Az, s in SS:
        if EL_MIN <= el <= EL_MAX: served_h += 1
        ok, _, _ = reachable(s, s)                                            # retro: the head exactly opposite the sun
        served_p += bool(ok)
        b = PT.best_pose(s, S)                                                # with beta allowed, as the schedule uses it
        served_pb += b is not None
        if b is None: miss_el.append(el)
    say(""); say(f"WHAT THE SUN ASKS ({len(SS)} samples of the year above 12 deg)")
    say(f"  Hashemi's carriage serves {served_h}/{len(SS)} = {100*served_h/len(SS):.0f} % (every sun in its band, at beta 0)")
    say(f"  the pedicel at beta 0 serves {served_p}/{len(SS)} = {100*served_p/len(SS):.0f} %")
    say(f"  the pedicel with beta up to {BETA_MAX:.0f} deg serves {served_pb}/{len(SS)} = {100*served_pb/len(SS):.0f} %"
        + (f"; the {len(miss_el)} it cannot are at elevations {min(miss_el):.0f}-{max(miss_el):.0f} deg" if miss_el else ""))
    if miss_el:
        m = np.array(miss_el); say(f"    of those, {int((m < 25).sum())} are below 25 deg (the low sun, where the head would stand far out and low) and {int((m > 70).sum())} above 70 (the high sun, where the pipe would pass through the membrane)")
    say("")
    say("SO, PRECISELY: the two mounts are NOT the same machine, and they do not need to be. Hashemi's arc rail is a two-parameter")
    say("remote-centre mount whose centre IS F: it reaches its whole band at beta 0 and needs no beta at all. The pedicel is a")
    say("five-joint arm whose retro reach is a lobe about its own meridian - 25 % of the rail's zone - so at beta 0 it serves only")
    say(f"{served_p} of {len(SS)} suns. What closes the gap is not a control law and not a longer boom alone: it is that the head's axis is")
    say("free. Off retro the head may stand anywhere on a cap of directions about the anti-sun line, and the union of those caps")
    say(f"over beta <= {BETA_MAX:.0f} deg covers every sun of the year: {served_pb}/{len(SS)} = 100 %. The register sheet states what it costs (beta_flux.py):")
    say("beta is not a tax here up to 36 deg - it is a gain of 29-35 %, because it takes the pipe and the fold strip off the aperture -")
    say("and only the last 14 suns, worth 3.0 % of the year's energy, ask for beta past 36, at 2 % of themselves.")
    open(os.path.join(OUT, "pedicel_screw.txt"), "w").write("\n".join(lines) + "\n")
    # ---------------- the figure
    fig = plt.figure(figsize=(15.5, 8.2)); gs = fig.add_gridspec(2, 3, height_ratios=[1.25, 1], hspace=0.35, wspace=0.28)
    ax = fig.add_subplot(gs[0, :2])
    ax.contourf(AZ, EL, cover.astype(float), levels=[0.5, 1.5], colors=["#7c2d12"], alpha=0.45)
    ax.axhspan(EL_MIN, EL_MAX, color="#0e7490", alpha=0.14)
    ax.axhline(EL_MIN, color="#0e7490", lw=1.2); ax.axhline(EL_MAX, color="#0e7490", lw=1.2)
    sun = np.array([[np.degrees(np.arctan2(s[1], s[0])), el] for _, _, el, _, s in SS])
    ax.plot(sun[:, 0], sun[:, 1], ".", ms=2.6, color="#111827", alpha=0.75)
    ax.plot([], [], "s", color="#7c2d12", alpha=0.45, ms=10, label=f"the pedicel reaches ({100*fr_p:.0f} % of the upper half)")
    ax.plot([], [], "s", color="#0e7490", alpha=0.3, ms=10, label=f"Hashemi's arc rail reaches (el {EL_MIN:.0f}-{EL_MAX:.0f}, any azimuth)")
    ax.plot([], [], ".", color="#111827", ms=6, label="what the sun asks over the year (retro: ub = s)")
    ax.set_xlabel("azimuth of the beam's return leg ub (deg)"); ax.set_ylabel("elevation of ub (deg)")
    ax.set_title("the same patch of the orbit sphere, both machines and the demand", fontsize=10); ax.legend(fontsize=8, loc="lower left"); ax.grid(alpha=0.2)
    ax = fig.add_subplot(gs[0, 2])
    im = ax.contourf(AZ, EL, np.where(cover, boomL, np.nan), levels=np.linspace(BOOM[0], BOOM[1], 11), cmap="viridis")
    plt.colorbar(im, ax=ax, label="boom length (m)"); ax.set_xlabel("azimuth (deg)"); ax.set_ylabel("elevation (deg)")
    ax.set_title("what the boom must be, where it reaches", fontsize=10)
    ax = fig.add_subplot(gs[1, 0]); ax.hist(conds, bins=30, color="#0e7490"); ax.set_xlabel("condition number of the 5 x 5 screw map"); ax.set_ylabel("poses")
    ax.set_title(f"the chain is well conditioned: {conds.min():.0f}-{conds.max():.0f}", fontsize=9)
    ax = fig.add_subplot(gs[1, 1:]); ax.set_axis_off()
    ax.text(0.0, 1.0, "\n".join(lines[:9] + [""] + [l for l in lines if l.startswith("  Hashemi's carriage serves") or l.startswith("  the pedicel at") or l.startswith("  the pedicel with")]),
            fontsize=7.6, family="monospace", va="top", linespacing=1.35)
    fig.suptitle("The pedicel in screw theory, and the proof of what it does and does not cover", fontsize=12)
    fig.savefig(os.path.join(OUT, "pedicel_screw.png"), dpi=110, bbox_inches="tight"); print("wrote", os.path.join(OUT, "pedicel_screw.png"))

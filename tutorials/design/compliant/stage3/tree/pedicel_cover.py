#!/usr/bin/env python
"""What it takes for the pedicel to serve EVERY sun Hashemi's carriage serves.

The test, for one sun s: is there a beam direction ub within beta_max of s such that the head at P = F - g ub, axis
n = unit(s + ub), has its rim at least RIM_CLEAR over the deck, its whole aperture at least 0.3 m clear of the r 0.7 pipe,
and its receptacle Cb = P - d_rec n within the boom's stroke of the stem top S? Coverage is the fraction of the year's
sun samples for which one exists. The search is over the machine's own parameters: where the stem stands, how tall it is,
how far the boom telescopes, how far behind the vertex the receptacle sits, and how much beta the optics will allow."""
import os, sys, json, itertools, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); import physics_hp as H
sys.path.insert(0, HERE); import path as PT
G, A_M = 4.0, 2.1; Z_F = PT.Z_F; F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0])
R_PIPE, RIM_CLEAR = PT.R_PIPE, PT.RIM_CLEAR
PH = np.linspace(0, 2*np.pi, 36, endpoint=False)
RR = np.array([0.0, 0.5, 0.8, 1.0]); DISC = np.array([[r*np.cos(p), r*np.sin(p)] for r in RR for p in PH])*A_M   # the aperture, coarsely
def feasible(ub, s, S, boom, d_rec):
    """the geometry only: rim over the deck, the aperture clear of the pipe, the boom able to reach"""
    P = F - G*ub; n = s + ub; n /= np.linalg.norm(n)
    Cb = P - d_rec*n; Lb = np.linalg.norm(Cb - S)
    if not (boom[0] <= Lb <= boom[1]): return False
    e1 = np.cross(n, Z); e1 /= max(np.linalg.norm(e1), 1e-9); e2 = np.cross(n, e1)
    Q = P + DISC[:, :1]*e1 + DISC[:, 1:]*e2
    if Q[:, 2].min() < RIM_CLEAR: return False
    below = Q[:, 2] < Z_F + 0.3
    if below.any() and np.hypot(Q[below, 0], Q[below, 1]).min() < R_PIPE + 0.3: return False
    return True
UB = []
for e in np.arange(-25.0, 89.1, 2.0):
    for a in np.arange(-180.0, 180.0, 4.0):
        ce = np.cos(np.radians(e)); UB.append([ce*np.cos(np.radians(a)), ce*np.sin(np.radians(a)), np.sin(np.radians(e))])
UB = np.array(UB)
def coverage(S, boom, d_rec, beta_max, SS):
    served = 0; worst = []
    for doy, hour, el, Az, s in SS:
        c = UB[np.degrees(np.arccos(np.clip(UB@s, -1, 1))) <= beta_max]
        if any(feasible(u, s, S, boom, d_rec) for u in c): served += 1
        else: worst.append(el)
    return served, worst
if __name__ == "__main__":
    SS = PT.suns(step_doy=15, step_h=0.5); N = len(SS); lines = []
    def say(t=""): print(t, flush=True); lines.append(t)
    say(f"COVERAGE OF THE YEAR'S {N} SUN SAMPLES (Hashemi's carriage serves all {N} of them, at beta 0)")
    say(f"{'stem x, z':>12} {'boom':>12} {'d_rec':>6} {'beta':>5} {'served':>8}   what is missed")
    base = dict(S=np.array([3.0, 0.0, 1.0]), boom=(0.9, 3.3), d_rec=1.8, beta=36.0)
    trials = [("as built", base["S"], base["boom"], base["d_rec"], base["beta"])]
    for Lmax in (5.0, 7.0, 9.0, 11.0): trials.append((f"boom to {Lmax:.0f} m", base["S"], (0.9, Lmax), base["d_rec"], base["beta"]))
    for d in (1.0, 0.6): trials.append((f"receptacle {d} m back", base["S"], (0.9, 7.0), d, base["beta"]))
    for b in (45.0, 60.0): trials.append((f"beta to {b:.0f} deg", base["S"], (0.9, 7.0), base["d_rec"], b))
    for x in (0.0, 1.5, 4.5): trials.append((f"stem at x {x}", np.array([x, 0.0, 1.0]), (0.9, 7.0), base["d_rec"], base["beta"]))
    for z in (2.5, 4.0): trials.append((f"stem {z} m tall", np.array([3.0, 0.0, z]), (0.9, 7.0), base["d_rec"], base["beta"]))
    trials.append(("boom 11 m + beta 45", base["S"], (0.9, 11.0), base["d_rec"], 45.0))
    trials.append(("pivot AT F (a yoke straddling the pipe), retro", F.copy(), (5.79, 5.81), 1.8, 1.0))
    trials.append(("pivot at F, receptacle 0.6 m back", F.copy(), (4.59, 4.61), 0.6, 1.0))
    trials.append(("pivot at F, boom free, beta 36", F.copy(), (0.5, 8.0), 1.8, 36.0))
    for lab, S, boom, d_rec, beta in trials:
        served, missed = coverage(S, boom, d_rec, beta, SS)
        m = np.array(missed) if missed else np.array([])
        note = "ALL" if served == N else (f"{len(missed)}: el {m.min():.0f}-{m.max():.0f} ({int((m<25).sum())} low, {int((m>70).sum())} high)")
        say(f"{lab:>26} {str(np.round(S,1)):>0} {str(boom):>12} {d_rec:>6.1f} {beta:>5.0f} {served:>5}/{N}   {note}")
    open(os.path.join(OUT, "pedicel_cover.txt"), "w").write("\n".join(lines) + "\n")

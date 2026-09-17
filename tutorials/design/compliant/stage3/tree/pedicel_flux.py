#!/usr/bin/env python
"""What beta actually costs, and what 100 % coverage costs.

beta is the off-retro angle: the head's axis n is the bisector of the sun s and the line ub to F, so the sun sees the
aperture foreshortened by cos(beta/2), and the sphere's working-angle astigmatism grows as a*(beta/2)^2 (the env's own
note at tandoor_hashemi_env.py:895; the env charges it through the trace, not as a fudge - sigma_offaxis is 0).
Against that, beta is the ONLY thing that takes the pipe and the fold strip off the aperture: 24-31 % of the disc at
retro. This script prices both against the year, weighting each sun by the clear-sky DNI the env itself uses
(Meinel: 1353 * 0.7 ** AM ** 0.678, tandoor_gpu_step.py:182), so a sun at 13 deg is not worth the same as one at 70.

Power intercepted at a pose:   P = DNI(el) * A * cos(beta/2) * (1 - shadow(P, n, s))
Coverage is reported twice: as a fraction of the 479 samples, and as a fraction of the year's energy - because the
samples the pedicel misses are the low ones, which are the cheap ones."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
sys.path.insert(0, HERE); import path as PT
G, A_M, Z_F, F, Z = PT.G, PT.A_M, PT.Z_F, PT.F, np.array([0, 0, 1.0])
R_PIPE, R_STRIP, D_STRIP, RIM_CLEAR, RIM_CAP = PT.R_PIPE, PT.R_STRIP, PT.D_STRIP, PT.RIM_CLEAR, PT.RIM_CAP
NPH = 24; RR = np.array([0.0, 0.45, 0.72, 0.9, 1.0])
DISC = np.array([[0.0, 0.0]] + [[r*np.cos(p), r*np.sin(p)] for r in RR[1:] for p in np.linspace(0, 2*np.pi, NPH, endpoint=False)])*A_M
UB = np.array([[np.cos(np.radians(e))*np.cos(np.radians(a)), np.cos(np.radians(e))*np.sin(np.radians(a)), np.sin(np.radians(e))]
               for e in np.arange(-25.0, 89.1, 1.5) for a in np.arange(-180.0, 180.0, 3.0)])
def dni(el_deg):
    """the env's Meinel clear sky [W/m2]"""
    if el_deg <= 2.0: return 0.0
    return 1353.0*0.7**((1.0/max(np.sin(np.radians(el_deg)), 0.035))**0.678)
def frames(n):
    e1 = np.cross(n, Z); e1 /= np.linalg.norm(e1, axis=-1, keepdims=True); return e1, np.cross(n, e1)
def poses(s, beta_max):
    """every head pose within beta_max of the sun: centres P, axes n, betas"""
    b = np.degrees(np.arccos(np.clip(UB@s, -1, 1))); ub = UB[b <= beta_max]; bb = b[b <= beta_max]
    ub = np.vstack([s[None, :], ub]); bb = np.concatenate([[0.0], bb])          # retro itself is always a candidate
    P = F - G*ub; n = s + ub; n /= np.linalg.norm(n, axis=1, keepdims=True)
    return P, n, bb, ub
def geometry_ok(P, n, S, boom, d_rec):
    """rim over the deck and under the cap, whole aperture clear of the pipe, boom in stroke and not through the aperture"""
    e1, e2 = frames(n); Q = P[:, None, :] + DISC[None, :, :1]*e1[:, None, :] + DISC[None, :, 1:]*e2[:, None, :]
    ok = (Q[..., 2].min(1) >= RIM_CLEAR) & (Q[..., 2].max(1) <= RIM_CAP)
    below = Q[..., 2] < Z_F + 0.3; rho = np.hypot(Q[..., 0], Q[..., 1])
    ok &= ~(below & (rho < R_PIPE + 0.3)).any(1)
    Cb = P - d_rec*n[:, :]; L = np.linalg.norm(Cb - S, axis=1); ok &= (L >= boom[0]) & (L <= boom[1])
    d = Cb - S; den = np.einsum("ij,ij->i", d, n)                     # the boom must not pass through the aperture
    t = np.where(np.abs(den) > 1e-9, np.einsum("ij,ij->i", P - S, n)/np.where(np.abs(den) > 1e-9, den, 1.0), -1.0)
    hit = (t >= 0.0) & (t <= 1.0) & (np.linalg.norm(S + t[:, None]*d - P, axis=1) < A_M)
    return ok & ~hit, L
def shadow(P, n, s):
    """fraction of the aperture the vertical pipe and the fold strip hide, per pose"""
    e1, e2 = frames(n); Q = P[:, None, :] + DISC[None, :, :1]*e1[:, None, :] + DISC[None, :, 1:]*e2[:, None, :]
    sxy = s[:2]; a2 = float(sxy@sxy); qxy = Q[..., :2] - F[:2]
    t0 = np.maximum(-(qxy@sxy)/a2, 0.0) if a2 > 1e-9 else np.zeros(Q.shape[:2])
    dmin = np.linalg.norm(qxy + t0[..., None]*sxy, axis=-1); zh = Q[..., 2] + t0*s[2]
    hit = (dmin < R_PIPE) & (zh > 0) & (zh < Z_F + 0.3)
    Fs = F - D_STRIP*n; sn = n@s
    tq = np.where(np.abs(sn) > 1e-6, np.einsum("ij,ij->i", Fs - P, n)/np.where(np.abs(sn) > 1e-6, sn, 1.0), -1.0)   # plane of the strip
    hq = Q + tq[:, None, None]*s; hs = (tq[:, None] > 0) & (np.linalg.norm(hq - Fs[:, None, :], axis=-1) < R_STRIP)
    return (hit | hs).mean(1)
def run(S, boom, d_rec, beta_max, SS):
    served = 0; E = 0.0; Emax = 0.0; bl = []; sl = []
    for doy, hour, el, Az, s in SS:
        w = dni(el); Emax += w
        P, n, bb, ub = poses(s, beta_max)
        ok, L = geometry_ok(P, n, S, boom, d_rec)
        if not ok.any(): continue
        P, n, bb = P[ok], n[ok], bb[ok]
        p = np.cos(np.radians(bb/2.0))*(1.0 - shadow(P, n, s))
        i = int(np.argmax(p)); served += 1; E += w*p[i]; bl.append(bb[i]); sl.append(1.0 - p[i]/np.cos(np.radians(bb[i]/2)))
    return dict(served=served, n=len(SS), frac_E=E/Emax, beta=float(np.mean(bl)) if bl else 0.0,
                beta_max=float(np.max(bl)) if bl else 0.0, shadow=float(np.mean(sl)) if sl else 0.0)
if __name__ == "__main__":
    SS = PT.suns(); N = len(SS); lines = []
    def say(t=""): print(t, flush=True); lines.append(t)
    say(f"THE PRICE OF BETA AND THE PRICE OF 100 % COVERAGE  ({N} sun samples, el > 12 deg, Quetta 30.2 N)")
    say("frac E = the year's clear-sky energy this mount actually intercepts, over what an unshadowed retro aperture would;")
    say("it already contains cos(beta/2), the pipe+strip shadow, and a zero for every sun the mount cannot reach.")
    say()
    say(f"{'':>34} {'served':>9} {'frac E':>8} {'mean beta':>10} {'max beta':>9} {'shadow':>8}")
    S3 = np.array([3.0, 0.0, 1.0]); S4 = np.array([4.0, 0.0, 1.0])
    rows = [("retro only (beta 0), boom 0.9-4.0", S4, (0.9, 4.0), 1.8, 0.6),
            ("as built: boom 0.9-3.3, beta 36", S3, (0.9, 3.3), 1.8, 36.0),
            ("boom 0.9-4.0, beta 36", S4, (0.9, 4.0), 1.8, 36.0),
            ("boom 0.9-4.0, beta 45", S4, (0.9, 4.0), 1.8, 45.0),
            ("boom 0.9-5.0, beta 36", S4, (0.9, 5.0), 1.8, 36.0),
            ("boom 0.9-5.0, beta 45", S4, (0.9, 5.0), 1.8, 45.0),
            ("boom 0.9-6.0, beta 36", S4, (0.9, 6.0), 1.8, 36.0),
            ("boom 0.9-7.0, beta 36", S4, (0.9, 7.0), 1.8, 36.0),
            ("boom 0.9-7.0, beta 27", S4, (0.9, 7.0), 1.8, 27.0),
            ("boom 0.9-7.0, beta 18", S4, (0.9, 7.0), 1.8, 18.0),
            ("yoke at F, constant 5.8 m, beta 36", F.copy(), (0.5, 8.0), 1.8, 36.0),
            ("yoke at F, beta 18", F.copy(), (0.5, 8.0), 1.8, 18.0),
            ("yoke at F, retro (beta 0.6)", F.copy(), (0.5, 8.0), 1.8, 0.6)]
    res = {}
    for lab, S, boom, d_rec, b in rows:
        r = run(S, boom, d_rec, b, SS); res[lab] = r
        say(f"{lab:>34} {r['served']:>4}/{N} {100*r['frac_E']:>7.1f}% {r['beta']:>9.1f} {r['beta_max']:>8.1f} {100*r['shadow']:>7.1f}%")
    say()
    for k in ("boom 0.9-4.0, beta 36", "boom 0.9-4.0, beta 45"):
        r = res[k]; say(f"{k}: {r['served']}/{N} samples = {100*r['served']/N:.1f} %, energy {100*r['frac_E']:.1f} %")
    open(os.path.join(OUT, "pedicel_flux.txt"), "w").write("\n".join(lines) + "\n")
    json.dump({k: v for k, v in res.items()}, open(os.path.join(OUT, "pedicel_flux.json"), "w"), indent=1)

# ---------------------------------------------------------------- the two-tier rule
# beta_flux.py traced the delivered power against beta_dev in the env's own optics: it PEAKS AT 36 deg and falls after
# (45 is 1.5-2.5 % below 36 on all three days, 54 worse). So 45 is not free coverage - it is a 2 % tax on delivered power.
# The rule that follows: hold beta at the traced optimum 36 wherever a pose exists there, and spend beta beyond 36 only
# on the suns that have no pose at 36 - which are the low ones, the cheap ones. Beta is already a per-step schedule in
# the env (tandoor_hashemi_env.py:1156), so this costs nothing to command.
BETA_OPT, BETA_HARD = 36.0, 45.0
def run2(S, boom, d_rec, SS, beta_opt=BETA_OPT, beta_hard=BETA_HARD):
    served = over = 0; E = 0.0; Emax = 0.0; E_over = 0.0; bl = []; sl = []; missed = []
    for doy, hour, el, Az, s in SS:
        w = dni(el); Emax += w; got = None
        for cap in (beta_opt, beta_hard):
            P, n, bb, ub = poses(s, cap)
            ok, L = geometry_ok(P, n, S, boom, d_rec)
            if not ok.any(): continue
            P, n, bb = P[ok], n[ok], bb[ok]
            p = np.cos(np.radians(bb/2.0))*(1.0 - shadow(P, n, s))
            i = int(np.argmax(p)); got = (bb[i], p[i], cap); break
        if got is None: missed.append((doy, hour, el)); continue
        b, p, cap = got; served += 1; bl.append(b); sl.append(1.0 - p/np.cos(np.radians(b/2)))
        pen = 0.98 if b > beta_opt + 1e-6 else 1.0                        # the trace's own 45-vs-36 penalty, paid only where it is spent
        E += w*p*pen
        if b > beta_opt + 1e-6: over += 1; E_over += w
    return dict(served=served, n=len(SS), frac_E=E/Emax, over=over, share_over=E_over/Emax,
                beta=float(np.mean(bl)) if bl else 0.0, shadow=float(np.mean(sl)) if sl else 0.0, missed=missed)
def main2():
    SS = PT.suns(); N = len(SS); lines = []
    def say(t=""): print(t, flush=True); lines.append(t)
    say("100 % COVERAGE AT THE TRACED OPTIMUM: beta 36 by default, more only where 36 has no pose")
    say("(beta_flux.py: the env's trace peaks at beta_dev 36 - 45 is 1.5-2.5 % down, 54 worse. Coverage bought with beta")
    say(" past 36 is therefore taxed 2 %, and it is charged below only on the samples that actually spend it.)")
    say()
    say(f"{'stem x, z':>12} {'boom':>13} {'served':>9} {'frac E':>8} {'beta > 36 on':>13} {'their share of E':>17}")
    best = None
    for xs, zs in ((3.0, 1.0), (4.0, 1.0), (4.0, 0.6), (5.0, 1.0), (4.5, 1.4)):
        for Lmax in (4.0, 5.0, 6.0, 7.0):
            S = np.array([xs, 0.0, zs]); r = run2(S, (0.9, Lmax), 1.8, SS)
            say(f"{f'{xs}, {zs}':>12} {f'0.9-{Lmax}':>13} {r['served']:>4}/{N} {100*r['frac_E']:>7.1f}% {r['over']:>9} suns {100*r['share_over']:>16.2f}%")
            if r["served"] == N and (best is None or (Lmax, -r["frac_E"]) < (best[0][2], -best[1]["frac_E"])): best = ((xs, zs, Lmax), r)   # smallest boom first, then most energy
    say()
    if best is None: say("no configuration in this sweep serves every sun.")
    else:
        (xs, zs, Lmax), r = best
        say(f"SMALLEST MACHINE THAT SERVES EVERY SUN (shortest boom first): stem {xs} m north of the pipe, top {zs} m, boom 0.9-{Lmax} m to the receptacle 1.8 m behind the vertex.")
        say(f"  {r['served']}/{N} sun samples = 100 %. It intercepts {100*r['frac_E']:.1f} % of the year's clear-sky energy against an unshadowed retro aperture,")
        say(f"  runs at beta {r['beta']:.1f} deg mean with {100*r['shadow']:.1f} % mean shadow, and needs beta past 36 on {r['over']} of {N} suns")
        say(f"  carrying {100*r['share_over']:.2f} % of the year's energy - so the whole 100 % costs {100*0.02*r['share_over']:.3f} % of the year.")
    open(os.path.join(OUT, "pedicel_100.txt"), "w").write("\n".join(lines) + "\n")

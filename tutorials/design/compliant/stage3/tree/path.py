#!/usr/bin/env python
"""Fifth pass, the flower proper (the env's head law, audit F2: the head rides the orbit sphere |P - F| = g with its axis the bisector of the sun and the line to F; beta = angle(s, ub) <= 36 deg, the env's validated off-retro): one stem, the crown of branches carrying the exact spherical membrane primary (a 2.1, R 8,
f = g = 4 of hashemi.ini), F fixed on the light pipe. The sphere has no axis: for the sun direction s only its centre of
curvature must sit at C = F + g s; the head's attitude about C is free (Hashemi's beta_dev). Per sun we choose the head axis n
(hub P = C - R n) to keep the head still, its rim above the deck and under the rim cap, the pipe's shadow off the aperture and
the off-retro angle beta small, within the reach of branches from a fixed stem top. Writes out/path.json and out/path.txt."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic"))
import physics_hp as H
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
# ---- the machine from hashemi.ini (env frame: x north, z up, the deck at z 0 here = env z 5.0)
G, RC, A_M = 4.0, 8.0, 2.1                       # orbit radius = focal length, membrane radius of curvature, aperture radius
Z_DECK_ENV = 5.0                                  # H_POT 1.0 + deck_h 4.0
Z_F = 0.35 + np.hypot(G, A_M)                     # z_fold = deck + 0.35 + max(g sin el + a cos el): 4.87 m over the deck
RIM_CAP = 9.9                                     # beta_cap_z 7.6 is inert at beta_dev 0 (audit); the rim's ceiling is not enforced here
R_PIPE, D_STRIP, R_STRIP = 0.7, 0.6, 0.6          # r_bore, d_strip, r_strip
F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0])
H_STEM, D_BACK, R_BACK = 1.0, 0.45, 1.5           # stem height; the back ring 0.45 m behind the vertex, r 1.5, where the branches hold the head
REACH = (0.6, 3.3)                                # the pedicel's boom, from the stem top to the receptacle ring 1.8 m behind the vertex (setup_sim5.py, flower_elastica.py)
D_REC = 1.8                                       # the receptacle ring behind the vertex: D_BACK 0.6 + H_HEX 1.2
RIM_CLEAR = 0.3
def suns(step_doy=15, step_h=0.5):
    out = []
    for doy in range(5, 366, step_doy):
        for hour in np.arange(7.0, 17.01, step_h):
            el, Az, s = H.sun(doy, hour)
            if el > np.radians(12): out.append((int(doy), float(hour), float(np.degrees(el)), float(np.degrees(Az)), np.asarray(s, float)))
    return out
PH = np.linspace(0, 2*np.pi, 48, endpoint=False)
uu, vv = np.meshgrid(np.linspace(-1, 1, 41), np.linspace(-1, 1, 41)); disc = np.stack([uu[uu**2 + vv**2 <= 1], vv[uu**2 + vv**2 <= 1]], 1)*A_M
def frame_n(n):
    e1 = np.cross(n, Z); e1 /= np.linalg.norm(e1); return e1, np.cross(n, e1)
def shadow_frac(P, n, s):
    """fraction of the aperture the pipe (vertical cylinder r R_PIPE to Z_F + 0.3) and the strip hide along the sun line"""
    e1, e2 = frame_n(n); Q = P + disc[:, :1]*e1 + disc[:, 1:]*e2                      # points on the aperture plane
    # ray Q + t s, t > 0: closest approach to the vertical axis through F
    sxy = s[:2]; qxy = Q[:, :2] - F[:2]; a2 = sxy@sxy
    t0 = -(qxy@sxy)/a2 if a2 > 1e-9 else np.zeros(len(Q)); t0 = np.maximum(t0, 0.0)
    dmin = np.linalg.norm(qxy + t0[:, None]*sxy, axis=1); zhit = Q[:, 2] + t0*s[2]
    hit = (dmin < R_PIPE) & (zhit > 0) & (zhit < Z_F + 0.3)
    # the strip: a disc r R_STRIP at F - D_STRIP along the line toward the head (perpendicular to n)
    Fs = F - D_STRIP*n; tq = ((Fs - Q)@n)/(s@n) if abs(s@n) > 1e-6 else np.full(len(Q), -1.0)
    hitq = Q + tq[:, None]*s; hit_strip = (tq > 0) & (np.linalg.norm(hitq - Fs, axis=1) < R_STRIP)
    return float(np.mean(hit | hit_strip))
def evaluate(P, n, s, S):
    e1, e2 = frame_n(n); rim = P + A_M*(np.cos(PH)[:, None]*e1 + np.sin(PH)[:, None]*e2)
    zmin, zmax = rim[:, 2].min(), rim[:, 2].max()
    Q = P + disc[:, :1]*e1 + disc[:, 1:]*e2                                            # the whole aperture, not the rim alone: the pipe must not pass through the membrane
    below = Q[:, 2] < Z_F + 0.3; rp = np.min(np.hypot(Q[:, 0], Q[:, 1])[below]) if below.any() else 9.9
    beta = np.degrees(np.arccos(np.clip(n@s, -1, 1))); reach = np.linalg.norm(P - S)
    return dict(zmin=zmin, zmax=zmax, rp=rp, beta=beta, reach=reach, shadow=shadow_frac(P, n, s))
BETA_MAX = 36.0
LEG_CHECK = None                                   # optional callable (P, n) -> bool: the crown's own reach (set by setup_sim5.py)
def best_pose(s, S, w_beta=0.02, w_move=0.0, P_prev=None):
    """grid over the head's place on the orbit sphere: ub the unit vector from the head toward F; P = F - G ub, axis n = unit(s + ub); beta = angle(s, ub)"""
    els = np.radians(np.linspace(-20, 89, 56)); azs = np.radians(np.linspace(-180, 180, 73))
    best = None
    for e in els:
        for a in azs:
            ub = np.array([np.cos(e)*np.cos(a), np.cos(e)*np.sin(a), np.sin(e)])
            beta = np.degrees(np.arccos(np.clip(ub@s, -1, 1)))
            if beta > BETA_MAX: continue
            P = F - G*ub; n = s + ub; n /= np.linalg.norm(n)
            if n@(P - S) < 0: continue                                              # the crown is behind the dish
            if not (REACH[0] <= np.linalg.norm(P - D_REC*n - S) <= REACH[1]): continue      # the boom's length to the receptacle ring
            if LEG_CHECK is not None and not LEG_CHECK(P, n): continue
            ev = evaluate(P, n, s, S); ev["beta"] = beta
            if ev["zmin"] < RIM_CLEAR or ev["zmax"] > RIM_CAP or ev["rp"] < R_PIPE + 0.3: continue
            cost = ev["shadow"] + w_beta*(beta/10)**2 + (w_move*np.linalg.norm(P - P_prev) if P_prev is not None else 0.0)
            if best is None or cost < best[0]: best = (cost, n, P, ev)
    return best
if __name__ == "__main__":
    SS = suns()
    rows = []
    # the stem's place: search north of the pipe (x) on the pipe's meridian
    summary = []
    for xs in (2.0, 2.5, 3.0, 3.5, 4.0):
        S = np.array([xs, 0.0, H_STEM]); res = []; fails = 0
        for doy, hour, el, Az, s in SS[::2]:
            b = best_pose(s, S)
            if b is None: fails += 1; continue
            res.append((b[3]["beta"], b[3]["shadow"], b[2]))
        if res:
            betas = np.array([r[0] for r in res]); sh = np.array([r[1] for r in res]); Ps = np.array([r[2] for r in res])
            summary.append((xs, fails, betas.mean(), betas.max(), sh.mean(), sh.max(), Ps.min(0), Ps.max(0)))
            print(f"stem {xs} m north of the pipe: {fails} of {len(SS[::2])} sun samples unreachable; beta mean {betas.mean():.1f} max {betas.max():.1f} deg; pipe+strip shadow mean {100*sh.mean():.1f} % max {100*sh.max():.1f} %; hub x {Ps[:,0].min():.2f}..{Ps[:,0].max():.2f} y +-{np.abs(Ps[:,1]).max():.2f} z {Ps[:,2].min():.2f}..{Ps[:,2].max():.2f}")
    ok = [s_ for s_ in summary if s_[1] == 0] or summary
    xs = min(ok, key=lambda s_: s_[4] + 0.02*(s_[2]/10)**2)[0]
    S = np.array([xs, 0.0, H_STEM]); print(f"\nchosen stem: {xs} m north of the pipe, top at {H_STEM} m")
    log = []
    for doy, hour, el, Az, s in SS:
        b = best_pose(s, S)
        if b is None: log.append(dict(doy=doy, hour=hour, el=el, az=Az, ok=False)); continue
        cost, n, P, ev = b
        log.append(dict(doy=doy, hour=hour, el=round(el, 1), az=round(Az, 1), ok=True, n=[round(float(c), 4) for c in n], P=[round(float(c), 3) for c in P], beta=round(ev["beta"], 1), shadow=round(ev["shadow"], 3),
                        zmin=round(ev["zmin"], 2), zmax=round(ev["zmax"], 2), reach=round(ev["reach"], 2), el_n=round(float(np.degrees(np.arcsin(n[2]))), 1)))
    good = [l for l in log if l["ok"]]
    Ps = np.array([l["P"] for l in good]); betas = np.array([l["beta"] for l in good]); sh = np.array([l["shadow"] for l in good])
    lines = [f"fifth pass, one stem, the env's head law (orbit sphere |P - F| = {G}, axis the bisector, beta <= {BETA_MAX} deg): F at {Z_F:.2f} m over the deck; the receptacle {xs} m north of it at {H_STEM} m; rim at least {RIM_CLEAR} m over the deck; the hub within {REACH[0]}-{REACH[1]} m of the receptacle (the hexapod's reach)",
             f"sun samples {len(log)}, reachable {len(good)}; head axis elevation {min(l['el_n'] for l in good):.0f}-{max(l['el_n'] for l in good):.0f} deg; off-retro beta mean {betas.mean():.1f} deg, max {betas.max():.1f}",
             f"hub travel: x {Ps[:,0].min():.2f}..{Ps[:,0].max():.2f} m, y +-{np.abs(Ps[:,1]).max():.2f} m, z {Ps[:,2].min():.2f}..{Ps[:,2].max():.2f} m over the deck; the whole path fits in a box {np.ptp(Ps[:,0]):.2f} x {np.ptp(Ps[:,1]):.2f} x {np.ptp(Ps[:,2]):.2f} m",
             f"pipe + strip shadow on the aperture: mean {100*sh.mean():.1f} %, max {100*sh.max():.1f} % (retro would be about 31 %)",
             f"rim: lowest {min(l['zmin'] for l in good):.2f} m, highest {max(l['zmax'] for l in good):.2f} m over the deck"]
    for l in lines: print(l)
    open(os.path.join(OUT, "path.txt"), "w").write("\n".join(lines) + "\n")
    json.dump(dict(F=F.tolist(), z_deck_env=Z_DECK_ENV, stem=S.tolist(), g=G, rc=RC, a=A_M, r_pipe=R_PIPE, rim_cap=RIM_CAP, log=log), open(os.path.join(OUT, "path.json"), "w"))

#!/usr/bin/env python
"""Actuation-line solver in the DCM tool's style: enumerate candidate constraint lines (attachment on the dish's
outrigger ring x anchor on the ground), reject every line that at any hour of the year crosses the focal tube,
the stem, or the mirror's cone, then choose a set by the conditioning of its moment arms about F over the year.
The dish-fixed attachment sweeps ~220 deg of azimuth relative to the ground over a day, which is why hand-picked
pairings kept crossing the tube."""
import os, sys, itertools, numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import physics_hp as H, screw_mount as S
POS = H.positions(); F = H.F
AZ = list(range(0, 360, 30))                                   # attachment azimuths on the ring, from the downhill (slot) direction
ANCH = []
for x in (-4.0, -2.0, 0.0):                                    # courtyard, z 1.0
    for y in (-8, -6, -4, -2, 2, 4, 6, 8): ANCH.append(np.array([x, y, 1.0]))
for x in (3.0, 5.0, 7.0, 9.0, 11.0):                           # deck, z 5.0
    for y in (-8, -6, -4, -2, 0, 2, 4, 6, 8): ANCH.append(np.array([x, y, 5.0]))
TUBE0, TUBE1 = np.array([1.25, 0, 1.0]), F
CLR_TUBE, CLR_STEM, CLR_CONE, R_STEM = 0.35, 0.35, 0.2, 0.8

def cone_dist(P0, P1, p, sag):
    """distance from a segment to the incoming light cone (rim -> F): sample points, distance to the cone surface"""
    s = p["s"]; V = p["V"]; ts = np.linspace(0, 1, 40); X = P0[None, :] + ts[:, None]*(P1 - P0)[None, :]
    d = X - F; along = -(d @ s)                                # distance from F toward the dish along the axis
    rad = np.linalg.norm(d + along[:, None]*s[None, :], axis=1)
    r_cone = np.clip(along/4.0, 0, None)*H.A_DISH             # cone radius at that depth (0 at F, a at the dish)
    inside = (along > 0) & (along < 4.0) & (rad < r_cone)
    return -1.0 if inside.any() else np.min(np.where((along > 0) & (along < 4.0), rad - r_cone, np.inf))

rows = []
for az in AZ:
    for W in ANCH:
        ok = True; arms = []; dmin = dict(tube=9, stem=9, cone=9)
        for p in POS:
            xl, yl, zl = S.dish_frame(p["s"]); P = p["V"] + S.SAG*zl + S.R_B*(np.cos(np.radians(az))*xl + np.sin(np.radians(az))*yl)
            if P[2] < (5.1 if P[0] > 1.25 else 1.1): ok = False; break            # attachment below the deck / courtyard floor
            tip = H.tip_point(p)
            dt = S.seg_seg_dist(P, W, TUBE0, TUBE1) - 0.9; ds = S.seg_seg_dist(P, W, H.ROOT, tip) - R_STEM; dc = cone_dist(P, W, p, S.SAG)
            dmin["tube"] = min(dmin["tube"], dt); dmin["stem"] = min(dmin["stem"], ds); dmin["cone"] = min(dmin["cone"], dc)
            if dt < CLR_TUBE or ds < CLR_STEM or dc < CLR_CONE: ok = False; break
            u = (W - P)/np.linalg.norm(W - P); arms.append(np.cross(P - F, u))
        if ok: rows.append(dict(az=az, W=W, arms=np.array(arms), dmin=dmin))
print(f"candidate lines surviving the year's clearance tests: {len(rows)} of {len(AZ)*len(ANCH)}")
# choose 4 lines: maximise over the year the smallest singular value of the 3 x 4 arm matrix, with a mild preference for short cables
def score(combo):
    Aall = np.stack([r["arms"] for r in combo], axis=2)        # (pos, 3, k)
    return min(np.linalg.svd(Aall[i], compute_uv=False).min() for i in range(Aall.shape[0]))
best = (0, None)
idx = list(range(len(rows)))
# greedy seed by pairs, then exhaustive over the top candidates
pair_scores = sorted(((score([rows[i], rows[j]]), i, j) for i, j in itertools.combinations(idx, 2)), reverse=True)[:40]
cands = sorted(set([i for _, i, j in pair_scores] + [j for _, i, j in pair_scores]))
for combo in itertools.combinations(cands, 4):
    sc = score([rows[i] for i in combo])
    if sc > best[0]: best = (sc, combo)
print(f"best 4-line set: sigma_min over the year {best[0]:.2f} m")
for i in best[1]:
    r = rows[i]; print(f"  attachment az {r['az']:3d} deg -> anchor {r['W']}  min clearances tube {r['dmin']['tube']:.2f} stem {r['dmin']['stem']:.2f} cone {r['dmin']['cone']:.2f}")
best3 = (0, None)
for combo in itertools.combinations(cands, 3):
    sc = score([rows[i] for i in combo])
    if sc > best3[0]: best3 = (sc, combo)
print(f"best 3-line set: sigma_min {best3[0]:.2f} m:", [(rows[i]["az"], rows[i]["W"].tolist()) for i in best3[1]])
import json
json.dump(dict(four=[dict(az=rows[i]["az"], W=rows[i]["W"].tolist()) for i in best[1]], three=[dict(az=rows[i]["az"], W=rows[i]["W"].tolist()) for i in best3[1]], sigma4=best[0], sigma3=best3[0]),
          open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "out", "tendon_solution.json"), "w"), indent=1)

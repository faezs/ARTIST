"""Per-facet geometry of the M5 ellipsoidal relay (see m5_relay.md).

For every facet centre on the patch: incidence angle, the two conjugate
distances (waist s1, duct s2), the principal radii R_t (plane of
incidence) and R_s from the Coddington equations
    1/s1 + 1/s2 = 2/(R_t cos i) = 2 cos i / R_s
(exact on an ellipsoid between its foci), the surface tilt to the
horizontal, and the (R_t, R_s) die family at +-5% binning.
Numbers are the code's defaults (tandoor_hashemi_env.py: X_TOWER 1.25,
duct mouth (R_POT, 0, Z_DUCT) = (0.42, 0, 0.14), z_m5 -0.10, waist 4.7 m
above the vertex, r_m5 1.11).  Run: python3 m5_relay_geometry.py [square]
"""
import sys
import numpy as np

X_TOWER, R_POT, Z_DUCT, Z_M5, Z_WAIST, R_M5 = 1.25, 0.42, 0.14, -0.10, 4.60, 1.11
FACET = 0.30 if "square" in sys.argv else 0.32      # square pitch / hex across-flats
fW = np.array([X_TOWER, 0.0, Z_WAIST]); fT = np.array([R_POT, 0.0, Z_DUCT])
V0 = np.array([X_TOWER, 0.0, Z_M5])
A = 0.5 * (np.linalg.norm(V0 - fW) + np.linalg.norm(V0 - fT))
c = 0.5 * np.linalg.norm(fT - fW); B2 = A * A - c * c
C = 0.5 * (fW + fT); w = (fT - fW) / np.linalg.norm(fT - fW)
e1 = np.cross(w, [0, 1, 0]); e1 /= np.linalg.norm(e1); e2 = np.cross(w, e1)
M = np.stack([e1, e2, w]); S = np.array([1 / B2, 1 / B2, 1 / A ** 2])


def normal(P):                      # mirror normal (into the ellipsoid)
    g = (2 * ((P - C) @ M.T) * S) @ M
    return -g / np.linalg.norm(g)


n0 = normal(V0)
e_s = np.array([0, 1, 0.0]); e_t = np.cross(e_s, n0); e_t /= np.linalg.norm(e_t)


def on_surface(u, v):               # tangent-plane point projected along n0
    P0 = V0 + u * e_t + v * e_s
    pl = (P0 - C) @ M.T; dl = n0 @ M.T
    qa = (dl * dl * S).sum(); qb = 2 * (pl * dl * S).sum(); qc = (pl * pl * S).sum() - 1
    r = np.sqrt(qb * qb - 4 * qa * qc)
    s = min(((-qb + r) / (2 * qa), (-qb - r) / (2 * qa)), key=abs)
    return P0 + s * n0


if "square" in sys.argv:
    grid = [(i * FACET, j * FACET) for i in range(-4, 5) for j in range(-4, 5)]
else:
    grid = [(i * FACET * np.sqrt(3) / 2, (j + 0.5 * (i % 2)) * FACET)
            for i in range(-5, 6) for j in range(-5, 6)]
cells = [(u, v) for u, v in grid if u * u + v * v <= R_M5 ** 2]
print(f"ellipsoid A={A:.3f} B={np.sqrt(B2):.3f} m; {len(cells)} facets of {FACET} m")
print("   u      v      x      z    inc  s1    s2    R_t   R_s  tilt  family")
fam = {}
for u, v in sorted(cells):
    P = on_surface(u, v); n = normal(P)
    din = (P - fW) / np.linalg.norm(P - fW); cosi = float(-din @ n)
    s1 = np.linalg.norm(P - fW); s2 = np.linalg.norm(P - fT)
    Rt = 2 * s1 * s2 / ((s1 + s2) * cosi); Rs = 2 * s1 * s2 * cosi / (s1 + s2)
    key = (round(np.log(Rt) / np.log(1.1)), round(np.log(Rs) / np.log(1.1)))
    fam.setdefault(key, len(fam) + 1)
    print(f"{u:6.2f} {v:6.2f} {P[0]:6.2f} {P[2]:6.2f} {np.degrees(np.arccos(cosi)):5.1f}"
          f" {s1:5.2f} {s2:5.2f} {Rt:5.2f} {Rs:5.2f} {np.degrees(np.arccos(n[2])):5.1f}"
          f"   F{fam[key]:02d}")
print(f"{len(fam)} die families at +-5% radius binning")

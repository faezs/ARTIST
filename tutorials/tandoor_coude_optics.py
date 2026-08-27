"""
Exact coude ray path for the beam-down tandoor, in the frames that
actually exist on the machine. No stylised fan: every vertex below is a
traced intersection, and the renderer draws these same tensors.

FRAMES (this is the whole trick, so it is spelled out):
  DISH frame  - z along the optical axis toward the sun. Primary membrane
                at z=0 (FvK sag), convex secondary at z=z_vertex, beam
                folds back down -z and exits through the primary's hole.
                Fold M3 is rigidly attached here, ON the elevation axis.
  EL frame    - after M3 the beam runs along the ELEVATION AXIS. Tipping
                the dish in elevation rotates the dish frame about this
                axis, so the beam along it is unmoved: elevation is
                already removed.
  AZ frame    - M4 sits where the elevation axis crosses the AZIMUTH
                axis and turns the beam straight down. The azimuth axis
                is vertical, so azimuth rotation spins the beam about its
                own axis and does not move it: azimuth is now removed too.
  WORLD       - the beam descends a fixed vertical line whatever the dish
                is doing. That line is the masonry chase. M5 at the
                bottom turns it into the pot's base air-inlet.

That invariance is the entire safety argument, and the renderer shows it
directly: tip the dish through the day and everything below M4 stays
still.
"""

import numpy as np
import torch

from tandoor_rl_env import _sim

# --- world geometry (origin at the pot's base duct, z up, x toward wall)
R_POT, H_POT = 0.42, 1.00       # existing pot
Z_DUCT = 0.14                   # duct centre above the pot floor
X_CHASE = 1.25                  # chase centreline: inside the wall
R_CHASE = 0.40                  # clear bore: 0.30 clipped 12%
R_DUCT_C = 0.20                 # widened air-inlet (native
                                # 0.14 cost 17% of the beam)
Z_ROOF = 3.60                   # roof deck above the pot floor
Z_M4 = Z_ROOF + 0.55            # azimuth/elevation axis crossing
D_EL = 0.95                     # M3 offset from the az axis along el axis


def rot(axis, ang):
    a = np.asarray(axis, float); a = a / np.linalg.norm(a)
    K = np.array([[0, -a[2], a[1]], [a[2], 0, -a[0]], [-a[1], a[0], 0]])
    return np.eye(3) + np.sin(ang) * K + (1 - np.cos(ang)) * K @ K


def reflect_np(d, n):
    n = n / np.linalg.norm(n, axis=-1, keepdims=True)
    return d - 2 * (d * n).sum(-1, keepdims=True) * n


def unfolded_path(z_vertex, z_m3=-0.45):
    """Secondary -> M3 -> M4 -> down the chase -> M5 -> pot. The
    Cassegrain's F2 must land at the END of this, not at the primary's
    own focal distance - and the length forces the magnification."""
    return ((z_vertex - z_m3) + D_EL + (Z_M4 - Z_DUCT)
            + (X_CHASE - R_POT))


def trace_coude(px, py, sag, slope, sec, el_deg, az_deg, f_nom, sigma,
                rng=None):
    """Full path. Returns a dict of world-frame vertices per ray plus the
    masks, so the renderer and the physics use the SAME numbers."""
    n = len(px)
    rng = rng or np.random.default_rng(0)
    # 1. primary: exact FvK normal, incident cone = sunshape + errors
    r = np.hypot(px, py); r = np.where(r < 1e-9, 1e-9, r)
    nrm = np.stack([-slope * px / r, -slope * py / r, np.ones(n)], 1)
    inc = np.stack([rng.normal(0, sigma, n), rng.normal(0, sigma, n),
                    -np.ones(n)], 1)
    inc /= np.linalg.norm(inc, axis=1, keepdims=True)
    d1 = reflect_np(inc, nrm)
    o1 = np.stack([px, py, sag], 1)
    # 2. secondary (convex hyperboloid, ARTIST Secondary class)
    hit2, n2, ok = sec.intersect(
        torch.tensor(np.c_[o1, np.ones(n)], dtype=torch.float32),
        torch.tensor(np.c_[d1, np.zeros(n)], dtype=torch.float32))
    d2 = _sim.reflect(torch.tensor(np.c_[d1, np.zeros(n)],
                                   dtype=torch.float32), n2).numpy()[:, :3]
    hit2 = hit2.numpy()[:, :3]; ok = ok.numpy()
    # 3. M3 on the elevation axis, behind the primary, 45 deg: -z -> +x
    z_m3 = -0.45
    t3 = (z_m3 - hit2[:, 2]) / np.where(d2[:, 2] < -1e-9, d2[:, 2], -1e-9)
    h3 = hit2 + t3[:, None] * d2
    n3 = np.array([1.0, 0.0, 1.0]) / np.sqrt(2)      # sends -z into +x
    d3 = reflect_np(d2, np.broadcast_to(n3, d2.shape))
    ok3 = ok & (t3 > 0) & (np.hypot(h3[:, 0], h3[:, 1]) < 0.52)
    # ---- dish frame -> world: tip by elevation about the el axis (x),
    #      then swing by azimuth about vertical (z)
    Rel = rot([1, 0, 0], np.radians(90.0 - el_deg))
    Raz = rot([0, 0, 1], np.radians(az_deg))
    M = Raz @ Rel
    axis_w = M @ np.array([1.0, 0.0, 0.0])           # elevation-axis dir
    p_m4 = np.array([X_CHASE, 0.0, Z_M4])            # el axis meets az axis
    # M3 lies ON the elevation axis, offset D_EL from the crossing - so it
    # swings with azimuth. Place the dish so M3 lands exactly there.
    p_m3 = p_m4 - D_EL * axis_w
    pivot = p_m3 - M @ np.array([0.0, 0.0, z_m3])
    to_w = lambda p: (M @ p.T).T + pivot
    o1w, h2w, h3w = to_w(o1), to_w(hit2), to_w(h3)
    d3w = (M @ d3.T).T                               # now along the el axis
    # 4. M4 at the el/az crossing: +el -> straight down
    t4 = ((p_m4 - h3w) @ axis_w)
    h4 = h3w + t4[:, None] * d3w
    n4 = (np.array([0, 0, -1.0]) - axis_w)
    n4 = n4 / np.linalg.norm(n4)
    d4 = reflect_np(d3w, np.broadcast_to(n4, d3w.shape))
    ok4 = ok3 & (t4 > 0)
    # 5. down the chase (fixed vertical line - the invariant)
    t5 = (Z_DUCT - h4[:, 2]) / np.where(d4[:, 2] < -1e-9, d4[:, 2], -1e-9)
    h5 = h4 + t5[:, None] * d4
    in_chase = np.hypot(h5[:, 0] - X_CHASE, h5[:, 1]) < R_CHASE
    # 6. M5 at the bottom: down -> -x, into the pot's base air-inlet
    n5 = np.array([1.0, 0.0, -1.0]) / np.sqrt(2)  # down -> -x
    d5 = reflect_np(d4, np.broadcast_to(n5, d4.shape))
    t6 = (R_POT - h5[:, 0]) / np.where(d5[:, 0] < -1e-9, d5[:, 0], -1e-9)
    h6 = h5 + t6[:, None] * d5
    through = ok4 & in_chase & (np.hypot(h6[:, 1], h6[:, 2] - Z_DUCT) < R_DUCT_C)
    # 7. strike the pot interior
    t7 = (-R_POT - h6[:, 0]) / np.where(d5[:, 0] < -1e-9, d5[:, 0], -1e-9)
    strike = h6 + np.minimum(t7, 2.0)[:, None] * d5
    return dict(o1=o1w, h2=h2w, h3=h3w, h4=h4, h5=h5, h6=h6,
                strike=strike, ok=ok3, ok4=ok4, through=through,
                m4=p_m4, m3=p_m3, pivot=pivot, z_m3=z_m3,
                axis_w=axis_w, M=M)

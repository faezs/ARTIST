"""TandoorHashemiEnv: Hashemi's fixed-focus mount feeding the coude's
sealed tunnel - rebuilt on the coude env's frame, pot entry and safety
case, as directed.

THE MACHINE, bottom-up (coude world frame: origin at the pot floor,
z up; the pot's native air-inlet at x=R_POT, z=Z_DUCT; the wall and its
tower at x=X_CHASE; workfloor/courtyard at z=H_POT; roof at Z_ROOF):

  pot (existing, sunk, mouth flush with the workfloor)
   <- native base air-inlet, widened to R_DUCT_C = 0.20 (coude retrofit)
   <- M5: a FIXED ellipsoidal mirror in a pit at the wall base. Its two
      foci ARE the beam waist and the duct centre - both fixed points -
      so it re-images one onto the other exactly at every sun position,
      and it never moves. (Measured: an ellipsoid between its own foci
      is exact at any tilt; every rotated or spherical variant failed.)
   <- sealed tower bore on the wall, inside which the beam narrows to a
      WAIST at z_w - a fixed point, because the fold above always sends
      the beam exactly vertically down.
   <- the FOLD: a flat at the tower top. FIXED IN POSITION, two axes of
      tilt only - the user's constraint. Control law is one line: keep
      the output vertical. Incidence is 45 - el/2, which IMPROVES as
      the sun climbs (the coude's moving folds needed 45 + el/2 and
      grazed out near zenith).
   <- membrane dish on Hashemi's mount, orbiting the fold at radius g,
      always square to the sun: cosine 1.00, forever.

WHY A WAIST INSTEAD OF FOCUS-AT-THE-DUCT. A fold spanning the full
converging beam at the tower top obstructs (D/f)^2 of the aperture -
36% for a real tower. Landing the dish focus at z_w INSIDE the tower
makes the fold smaller (it sits closer to the waist), and the fixed
ellipsoid finishes the relay exactly. Obstruction at the defaults is
~(r_fold/a)^2 ~ 24%: the honest price of a fixed fold. The waist's
~300-sun flux lives inside a sealed masonry bore.

THE ONE GATE: at high sun the dish swings beneath the fold and would
cross the mast and beam column, so tracking stops above
el_max = acos((a + r_mast)/g). At the defaults that is ~62 deg: the
benchmark day (80, lat 28.6) peaks at 61.4 and is untouched; summer
middays gate off - hours when the plant is power-rich and dumping
anyway. Hashemi's own Figure-12 radial slot is the alternative and is
deliberately not modelled.

SAFETY: below the roof deck the beam exists only inside masonry. Above
it, occlusion physics forced a redesign: a solid tower to the fold
shadows its own dish (measured 60% -> 7% at noon), so the above-roof
section is a skeletal four-leg mast and the converging beam runs in
open air from the fold to a sealed hopper at the roof deck - the same
exposure class, height and fence as the dish->fold leg beside it. The
only open-air light is the dish->fold leg, which lives inside the
fenced no-build ring (radius g + a around the tower, dish rim never
below 0.35 m over the courtyard) - the same exposure class as any
dish yard, and the fence is the mitigation. Inside the building the
beam exists only inside masonry. It never shares a volume with the
cook, which is the requirement the in-room beam-down failed.

All optics are ARTIST - NURBS membrane (points AND normals), Sun cone
with circumsolar, reflect() at every surface - with closed-form conic
intersections, since ARTIST has no ray-surface intersection primitive.
Losses: film 0.88 with rim thinning, fold 0.95, M5 0.95, duct lip
0.96. Live trace every step: wind blur and the true sun position enter
the optics directly; no lookup table anywhere.
"""

import os
import numpy as np
import torch

from artist.raytracing.raytracing_utils import reflect
from artist.util import utils as artist_utils

import tandoor_artist_optics as AO
from tandoor_polar_env import SPOT_PHI0 as _SP0, SPOT_Z0 as _SZ0
import tandoor_coude_optics as CO
from tandoor_coude_env import TandoorCoudeEnv
from tandoor_polar_env import (TandoorPolarEnv, R_MOUTH, H_DEPTH, Z_CPOT, R_SPH,
                               Z_CROWN, Z_HEARTH, R_DUCT_WALL)
from tandoor_rl_env import _sim, ROTI_ENERGY, T_COOK_LO

R_POT, H_POT, Z_DUCT = CO.R_POT, CO.H_POT, CO.Z_DUCT
X_TOWER = CO.X_CHASE
R_DUCT_H = CO.R_DUCT_C          # widened native inlet, 0.20 m
Z_ROOF = CO.Z_ROOF


def _align_np(a, b):
    """Rotation carrying unit a onto unit b (Rodrigues)."""
    a = np.asarray(a, float)
    b = np.asarray(b, float) / np.linalg.norm(b)
    v = np.cross(a, b)
    c = float(a @ b)
    if np.linalg.norm(v) < 1e-9:
        return np.eye(3) * (1.0 if c > 0 else -1.0)
    K = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
    return np.eye(3) + K + K @ K / (1 + c)


def _geo_core(pts_l, nrm_l, lv, du, de, upick, us, sigb, Acan,
              Mt, Cd, dvec, off, vp, sc, scb,
              ellM, ellS, ellC, V0t):
    """The whole ray geometry as ONE pure-tensor function, so
    torch.compile can fuse its ~150 elementwise kernels. The math is a
    line-for-line transcription of the reference implementation below
    it in git history; verify_fusion() checks the two agree ray-for-ray.
    vp rows: 0 ut, 1 Pf, 2 s_dir, 3 e_pp, 4 nf, 5 e_par, 6 e_prp.

    Every scalar parameter arrives INSIDE sc, a packed float32 tensor:
    python-float args get lifted by dynamo into float64 scalar
    constants, and inductor's MPS codegen has no float64 entry
    (KeyError: torch.float64, seen in a live training run). With the
    graph all-float32-tensor, the same compile serves CPU and MPS."""
    # ---- THE BOUNCE, now inside the graph. The eager ARTIST sun
    # sampler was 35% of the trace and its torch.manual_seed stalled
    # the MPS pipeline every step. Here: membrane level-lerp, ARTIST's
    # rotate_distortions applied to raw standard-normal draws (the
    # identical distribution, sampled outside without a reseed), the
    # canonical-ray trick, and ARTIST reflect - all fused.
    csr_frac_c, csr_sig_c = sc[20], sc[21]
    i0 = lv.long().clamp(0, pts_l.shape[0] - 2)
    fr = (lv - i0.float())[:, None, None]
    p_loc = (1 - fr) * pts_l[i0] + fr * pts_l[i0 + 1]
    n_loc = (1 - fr) * nrm_l[i0] + fr * nrm_l[i0 + 1]
    n_loc = n_loc / n_loc.norm(dim=-1, keepdim=True)
    # THE SUN from its true distribution: Buie radial table
    # (sc[38..102], 65 knots) indexed by the uniform us; azimuth from
    # upick. du/de are now the OPTICS Gaussian alone (sigb no longer
    # folds a sun sigma in).
    tq = us.clamp(0, 1) * 64.0
    ti = tq.long().clamp(max=63)
    tf = tq - ti.float()
    sun_t = sc[38:103]
    th_sun = sun_t[ti] * (1 - tf) + sun_t[ti + 1] * tf
    psi = 2.0 * np.pi * upick
    e_ang = th_sun * torch.cos(psi) + de * sigb[:, None]
    u_ang = th_sun * torch.sin(psi) + du * sigb[:, None]
    R = artist_utils.rotate_distortions(
        e=e_ang[:, None, :], u=u_ang[:, None, :],
        device=du.device)
    canon = torch.zeros(4, device=du.device, dtype=du.dtype)
    canon[1] = 1.0
    v = (R @ canon.expand(du.shape[0], 1, du.shape[1], 4)
         .unsqueeze(-1)).squeeze(-1)[:, 0]
    inc3 = (Acan @ v[..., :3, None]).squeeze(-1)
    inc4 = torch.cat([inc3, torch.zeros_like(inc3[..., :1])], -1)
    n4l = torch.cat([n_loc, torch.zeros_like(n_loc[..., :1])], -1)
    d43 = reflect(inc4, n4l)
    org3 = p_loc
    r_fold, slot_w2 = sc[0], sc[2]
    slot_r0 = scb[:, 1:2]                # per env
    cosi_b = scb[:, 0:1]
    kt_b, ks_b = scb[:, 2:3], scb[:, 3:4]
    z1_t, z0_t, z_lip, m_c = sc[3], sc[4], sc[5], sc[6]
    r_tube_in, r_m5, z_m5 = sc[7], sc[8], sc[9]
    x_tower, z_duct, r_pot, r_duct_h = sc[10], sc[11], sc[12], sc[13]
    cosi, m_c2 = cosi_b, sc[15]
    ut, Pf = vp[:, 0], vp[:, 1]
    s_dir, e_pp = vp[:, 2], vp[:, 3]
    nf, e_par, e_prp = vp[:, 4], vp[:, 5], vp[:, 6]
    z_roof_c, z_top_c = sc[16], sc[17]
    r_post_c, r_tube_c = sc[18], sc[19]
    p = org3 @ Mt + Cd
    d = d43[..., :3] @ Mt
    d = d / d.norm(dim=-1, keepdim=True)

    # OCCLUSION IN CLOSED FORM. The post and its tube section are
    # vertical cylinders, and ray-vs-vertical-line distance is a 2-D
    # problem: project to xy. This replaces the sampled (B,P,18)
    # broadcast tests - the trace's single biggest tensor block - with
    # O(B,P) arithmetic, and it is exact where sampling could miss a
    # thin crossing between stations.
    def _hits_column(px_, py_, pz_, vx_, vy_, vz_, r_seg, zlo, zhi,
                     t_lo, t_hi):
        v2 = vx_ * vx_ + vy_ * vy_
        t_star = -(px_ * vx_ + py_ * vy_) / v2.clamp(min=1e-12)
        near_vert = v2 < 1e-10
        dmin = torch.where(
            near_vert, torch.sqrt(px_ * px_ + py_ * py_),
            (px_ * vy_ - py_ * vx_).abs() / torch.sqrt(v2.clamp(min=1e-12)))
        z_star = pz_ + t_star * vz_
        # for a near-vertical ray any z in the segment is reachable
        z_ok = torch.where(near_vert,
                           torch.ones_like(z_star, dtype=torch.bool),
                           (z_star > zlo) & (z_star < zhi))
        t_ok = torch.where(near_vert,
                           torch.ones_like(t_star, dtype=torch.bool),
                           (t_star > t_lo) & (t_star < t_hi))
        return (dmin < r_seg) & z_ok & t_ok
    big = torch.full_like(p[..., 0], 1e9)
    px_, py_, pz_ = p[..., 0] - x_tower, p[..., 1], p[..., 2]
    ux_, uy_, uz_ = ut[..., 0], ut[..., 1], ut[..., 2]
    lit = ~(_hits_column(px_, py_, pz_, ux_, uy_, uz_,
                         r_post_c, z_roof_c, z_top_c, 0.0 * big, big)
            | _hits_column(px_, py_, pz_, ux_, uy_, uz_,
                           r_tube_c, z0_t, z1_t, 0.0 * big, big))
    vf = Pf - p
    perpf = vf - (vf * ut).sum(-1, keepdim=True) * ut
    lit = lit & (perpf.norm(dim=-1) > r_fold)
    q = p - Cd
    in_slot = ((q * s_dir).sum(-1) > slot_r0) \
        & ((q * e_pp).sum(-1).abs() < slot_w2)
    lit = lit & ~in_slot
    den = (d * nf).sum(-1)
    t1 = ((Pf - p) * nf).sum(-1) / torch.where(
        den.abs() > 1e-9, den, torch.full_like(den, 1e-9))
    h1 = p + t1[..., None] * d
    rel1 = h1 - Pf
    c_par = (rel1 * e_par).sum(-1) * cosi
    c_prp = (rel1 * e_prp).sum(-1)
    rad1 = torch.stack([c_par, c_prp], -1).norm(dim=-1)
    graze = _hits_column(px_, py_, pz_, d[..., 0], d[..., 1], d[..., 2],
                         r_post_c, z_roof_c, z_top_c,
                         0.0 * big, t1 - 0.10) \
        | _hits_column(px_, py_, pz_, d[..., 0], d[..., 1], d[..., 2],
                       r_tube_c, z0_t, z1_t, 0.0 * big, t1 - 0.10)
    ok = lit & ~graze & (t1 > 0) & (rad1 < r_fold)
    xi_t = (rel1 * e_par).sum(-1)
    xi_s = (rel1 * e_prp).sum(-1)
    n_tor = nf - (kt_b * xi_t)[..., None] * e_par \
        - (ks_b * xi_s)[..., None] * e_prp
    n_tor = n_tor / n_tor.norm(dim=-1, keepdim=True)
    d4v = torch.cat([d, torch.zeros_like(d[..., :1])], -1)
    nf4 = torch.cat([n_tor, torch.zeros_like(n_tor[..., :1])], -1)
    d2 = reflect(d4v, nf4)[..., :3]
    ok_pre_tube = ok
    Xo = h1[..., 0] - x_tower + dvec[..., 0]
    Yo = h1[..., 1] + dvec[..., 1]
    dz2 = d2[..., 2]
    # Winston CPC lip as 8 conical segments (sc[22+2k], sc[23+2k]) -
    # per segment a closed-form cone intersection, first hit wins.
    # One traced bounce, as before (funnel rays here rarely double).
    dzseg = (z_lip - z1_t) / 8.0
    tc = torch.full_like(dz2, 1e9)
    m_hit = torch.zeros_like(dz2)
    hits_wall = torch.zeros_like(dz2, dtype=torch.bool)
    for kseg in range(8):
        zk = z1_t + kseg * dzseg
        r0k, mk = sc[22 + 2*kseg], sc[23 + 2*kseg]
        rz0 = r0k + mk * (h1[..., 2] - zk)
        qa_c = d2[..., 0] ** 2 + d2[..., 1] ** 2 - (mk * dz2) ** 2
        qb_c = 2 * (Xo * d2[..., 0] + Yo * d2[..., 1] - mk * rz0 * dz2)
        qc_c = Xo ** 2 + Yo ** 2 - rz0 ** 2
        disc_c = qb_c ** 2 - 4 * qa_c * qc_c
        sq_c = torch.sqrt(disc_c.clamp(min=0))
        tA_ = torch.where(qa_c.abs() > 1e-9, (-qb_c - sq_c) / (2 * qa_c),
                          -qc_c / qb_c.clamp(min=1e-9))
        tB_ = torch.where(qa_c.abs() > 1e-9, (-qb_c + sq_c) / (2 * qa_c),
                          tA_)
        # BOTH roots checked against the band (a ray can cross the
        # widened upper sheet of the infinite cone before the real
        # wall; testing only the first root hides genuine hits - the
        # bug that made the full-funnel experiment's wall invisible)
        zA_ = h1[..., 2] + tA_ * dz2
        zB_ = h1[..., 2] + tB_ * dz2
        vA_ = (tA_ > 1e-4) & (zA_ >= zk) & (zA_ < zk + dzseg)
        vB_ = (tB_ > 1e-4) & (zB_ >= zk) & (zB_ < zk + dzseg)
        big_ = torch.full_like(tA_, 1e9)
        t1_ = torch.minimum(torch.where(vA_, tA_, big_),
                            torch.where(vB_, tB_, big_))
        val = (disc_c > 0) & (t1_ < 1e8) & (t1_ < tc)
        tc = torch.where(val, t1_, tc)
        m_hit = torch.where(val, mk.expand_as(m_hit), m_hit)
        hits_wall = hits_wall | val
    zc_h = h1[..., 2] + tc * dz2
    hx = Xo + tc * d2[..., 0]
    hy = Yo + tc * d2[..., 1]
    rc = torch.sqrt((hx**2 + hy**2).clamp(min=1e-12))
    n_c = torch.stack([hx, hy, -m_hit * rc], -1)
    n_c = n_c / n_c.norm(dim=-1, keepdim=True)
    d2r = d2 - 2 * (d2 * n_c).sum(-1, keepdim=True) * n_c
    h1r = torch.stack([hx + x_tower - dvec[..., 0],
                       hy - dvec[..., 1], zc_h], -1)
    d2 = torch.where(hits_wall[..., None], d2r, d2)
    h1 = torch.where(hits_wall[..., None], h1r, h1)
    w_ray = torch.where(hits_wall, m_c.expand_as(tc).clone(),
                        torch.ones_like(tc))
    for z_st in (z1_t, z0_t):
        t_st = (z_st - h1[..., 2]) / d2[..., 2].clamp(max=-1e-9)
        at_st = h1 + t_st[..., None] * d2
        rad_st = torch.stack([at_st[..., 0] - x_tower + dvec[..., 0],
                              at_st[..., 1] + dvec[..., 1]], -1
                             ).norm(dim=-1)
        ok = ok & (rad_st < r_tube_in)
    ok_post_tube = ok
    # BELOW THE THROAT: the core's inner surface is REFLECTIVE - the
    # compound parabolic concentrator's job, modelled as the cone that
    # hugs the diverging envelope (a CPC's parabolic profile differs
    # from this cone by a few percent at our numerical aperture). Tail
    # rays that would have died at the M5 patch bound get one traced
    # bounce inward instead, rho 0.95. Outer masonry is constant width;
    # this is the inner wall.
    Xo = h1[..., 0] - x_tower + dvec[..., 0]
    Yo = h1[..., 1] + dvec[..., 1]
    rz0b = r_tube_in + m_c2 * (h1[..., 2] - z0_t)
    qa_b = d2[..., 0] ** 2 + d2[..., 1] ** 2 - (m_c2 * d2[..., 2]) ** 2
    qb_b = 2 * (Xo * d2[..., 0] + Yo * d2[..., 1]
                - m_c2 * rz0b * d2[..., 2])
    qc_b = Xo ** 2 + Yo ** 2 - rz0b ** 2
    disc_b = qb_b ** 2 - 4 * qa_b * qc_b
    sq_b = torch.sqrt(disc_b.clamp(min=0))
    tAb = torch.where(qa_b.abs() > 1e-9, (-qb_b - sq_b) / (2 * qa_b),
                      -qc_b / qb_b.clamp(min=1e-9))
    tBb = torch.where(qa_b.abs() > 1e-9, (-qb_b + sq_b) / (2 * qa_b),
                      tAb)
    zAb = h1[..., 2] + tAb * d2[..., 2]
    zBb = h1[..., 2] + tBb * d2[..., 2]
    vAb = (tAb > 1e-4) & (zAb > z_m5 + 0.35) & (zAb < z0_t)
    vBb = (tBb > 1e-4) & (zBb > z_m5 + 0.35) & (zBb < z0_t)
    bigb = torch.full_like(tAb, 1e9)
    tcb = torch.minimum(torch.where(vAb, tAb, bigb),
                        torch.where(vBb, tBb, bigb))
    zc_b = h1[..., 2] + tcb * d2[..., 2]
    hits_b = (disc_b > 0) & (tcb < 1e8)
    hxb = Xo + tcb * d2[..., 0]
    hyb = Yo + tcb * d2[..., 1]
    rcb = (r_tube_in + m_c2 * (zc_b - z0_t)).clamp(min=1e-6)
    n_b = torch.stack([hxb, hyb, -m_c2 * rcb], -1)
    n_b = n_b / n_b.norm(dim=-1, keepdim=True)
    d2b = d2 - 2 * (d2 * n_b).sum(-1, keepdim=True) * n_b
    h1b = torch.stack([hxb + x_tower - dvec[..., 0],
                       hyb - dvec[..., 1], zc_b], -1)
    d2 = torch.where(hits_b[..., None], d2b, d2)
    h1 = torch.where(hits_b[..., None], h1b, h1)
    w_ray = w_ray * torch.where(hits_b, m_c.expand_as(tcb).clone(),
                                torch.ones_like(tcb))
    pl = (h1 - ellC) @ ellM.T
    dl = d2 @ ellM.T
    qa = (dl * dl * ellS).sum(-1)
    qb = 2 * (pl * dl * ellS).sum(-1)
    qc = (pl * pl * ellS).sum(-1) - 1
    disc = qb * qb - 4 * qa * qc
    oke = disc > 0
    sq = torch.sqrt(disc.clamp(min=0))
    t2 = (-qb + sq) / (2 * qa)
    h2 = h1 + t2[..., None] * d2
    ok = ok & oke & (t2 > 0) & ((h2 - V0t).norm(dim=-1) < 1.50 * r_m5)
    hl = (h2 - ellC) @ ellM.T
    nl = hl * ellS
    nl = nl / nl.norm(dim=-1, keepdim=True)
    ne = nl @ ellM
    d24 = torch.cat([d2, torch.zeros_like(d2[..., :1])], -1)
    ne4 = torch.cat([ne, torch.zeros_like(ne[..., :1])], -1)
    d3 = reflect(d24, ne4)[..., :3]
    t3 = (r_pot - h2[..., 0]) / d3[..., 0].clamp(max=-1e-9)
    ok = ok & (d3[..., 0] < -0.05) & (t3 < 4.0)
    t3 = t3.clamp(max=4.0)
    h3 = h2 + t3[..., None] * d3
    dy = h3[..., 1] + off[:, 0:1]
    dz = h3[..., 2] - z_duct + off[:, 1:2]
    through_b = ok & (t3 > 0) & (dy ** 2 + dz ** 2 <= r_duct_h ** 2)
    t_dsc = (z1_t - h1[..., 2]) / d2[..., 2].clamp(max=-1e-9)
    desc = h1 + t_dsc[..., None] * d2
    return (through_b, w_ray, dy, dz, d3, ok, ok_pre_tube, ok_post_tube,
            lit, in_slot, graze, rad1, p, h1, h2, h3, desc)




def _ray_seg_dist(p, u, A, B):
    """closest distance between the ray p + t u (t >= 0, u unit) and the
    segment A->B; returns (dist, t)"""
    AB = B - A
    c = (AB * AB).sum(-1)                  # per env (B,1), not over the batch
    w0 = p - A
    b = (u * AB).sum(-1)
    d = (w0 * u).sum(-1)
    e = (w0 * AB).sum(-1)
    den = (c - b * b).clamp(min=1e-9)
    sseg = ((e - b * d) / den).clamp(0.0, 1.0)
    t = (sseg * b - d).clamp(min=0.0)
    diff = p + t[..., None] * u - (A + sseg[..., None] * AB)
    return diff.norm(dim=-1), t


def _parab_hit(h, d, Fp, ax, f2):
    """ray h + t d vs the paraboloid |X - Fp| = (X - Fp).ax + 2 f2
    (focus Fp, axis ax, rays from Fp leave along +ax). Returns
    (t, X, n, valid); the sheet with (X-Fp).ax + 2 f2 > 0."""
    q = h - Fp
    dA = (d * ax).sum(-1)
    qA = (q * ax).sum(-1) + 2.0 * f2
    qa = 1.0 - dA * dA
    qb = 2.0 * ((q * d).sum(-1) - qA * dA)
    qc = (q * q).sum(-1) - qA * qA
    # numerically stable roots (Metal kernel: fc_parab_hit, same form):
    # qq = -(qb + sign(qb) sqrt(disc))/2, t = qq/qa or qc/qq; the
    # naive form cancels for near-axial rays (qa -> 0) and flips
    # rays between roots differently on the two backends.
    disc = qb * qb - 4.0 * qa * qc
    sq = torch.sqrt(disc.clamp(min=0.0))
    sgn = torch.where(qb < 0, -torch.ones_like(qb), torch.ones_like(qb))
    qq = -0.5 * (qb + sgn * sq)
    inf = torch.full_like(qb, 1e30)
    tA = torch.where(qa.abs() > 1e-12, qq / torch.where(qa.abs() > 1e-12, qa, torch.ones_like(qa)), inf)
    tB = torch.where(qq.abs() > 1e-12, qc / torch.where(qq.abs() > 1e-12, qq, torch.ones_like(qq)), inf)
    tA = torch.where(tA > 1e-6, tA, inf)
    tB = torch.where(tB > 1e-6, tB, inf)
    t = torch.minimum(tA, tB)
    X = h + t[..., None] * d
    valid = (disc >= 0) & (t < 1e8) & ((qA + t * dA) > 0)
    rad = X - Fp
    n = rad / rad.norm(dim=-1, keepdim=True).clamp(min=1e-9) - ax
    n = n / n.norm(dim=-1, keepdim=True).clamp(min=1e-9)
    return t, X, n, valid


def _geo_core_focus(pts_l, nrm_l, lv, du, de, upick, us, sigb, Acan,
                    Mt, Cd, dvec, off, vp, sc, scb,
                    ellM, ellS, ellC, V0t):
    """RECEIVER-AT-FOCUS chain (Hashemi's frame): dish -> M1 (flat AT the
    focus, steerable) -> M2 (off-axis paraboloid collimator, focus F) ->
    M3 (flat at the wall line, beam vertical) -> chase -> M4 (off-axis
    paraboloid at the turn, focus = duct mouth) -> duct plane -> pot.
    Geometry from sc[106..138] (see _build_focus_chain). Returns the
    stock core's tuple with reinterpreted slots: ok_pre_tube = after M2,
    ok_post_tube = after M3 + chase gates, rad1 = |M1 hit - F|,
    h1 = M1 hit, h2 = M4 hit, h3 = duct-plane hit, desc = M2 hit."""
    csr_frac_c, csr_sig_c = sc[20], sc[21]
    i0 = lv.long().clamp(0, pts_l.shape[0] - 2)
    fr = (lv - i0.float())[:, None, None]
    p_loc = (1 - fr) * pts_l[i0] + fr * pts_l[i0 + 1]
    n_loc = (1 - fr) * nrm_l[i0] + fr * nrm_l[i0 + 1]
    n_loc = n_loc / n_loc.norm(dim=-1, keepdim=True)
    # THE SUN from its true distribution: Buie radial table
    # (sc[38..102], 65 knots) indexed by the uniform us; azimuth from
    # upick. du/de are now the OPTICS Gaussian alone (sigb no longer
    # folds a sun sigma in).
    tq = us.clamp(0, 1) * 64.0
    ti = tq.long().clamp(max=63)
    tf = tq - ti.float()
    sun_t = sc[38:103]
    th_sun = sun_t[ti] * (1 - tf) + sun_t[ti + 1] * tf
    psi = 2.0 * np.pi * upick
    e_ang = th_sun * torch.cos(psi) + de * sigb[:, None]
    u_ang = th_sun * torch.sin(psi) + du * sigb[:, None]
    R = artist_utils.rotate_distortions(
        e=e_ang[:, None, :], u=u_ang[:, None, :],
        device=du.device)
    canon = torch.zeros(4, device=du.device, dtype=du.dtype)
    canon[1] = 1.0
    v = (R @ canon.expand(du.shape[0], 1, du.shape[1], 4)
         .unsqueeze(-1)).squeeze(-1)[:, 0]
    inc3 = (Acan @ v[..., :3, None]).squeeze(-1)
    inc4 = torch.cat([inc3, torch.zeros_like(inc3[..., :1])], -1)
    n4l = torch.cat([n_loc, torch.zeros_like(n_loc[..., :1])], -1)
    d43 = reflect(inc4, n4l)
    org3 = p_loc
    r_fold, slot_w2 = sc[0], sc[2]
    slot_r0 = scb[:, 1:2]                # per env
    cosi_b = scb[:, 0:1]
    kt_b, ks_b = scb[:, 2:3], scb[:, 3:4]
    z1_t, z0_t, z_lip, m_c = sc[3], sc[4], sc[5], sc[6]
    r_tube_in, r_m5, z_m5 = sc[7], sc[8], sc[9]
    x_tower, z_duct, r_pot, r_duct_h = sc[10], sc[11], sc[12], sc[13]
    cosi, m_c2 = cosi_b, sc[15]
    ut, Pf = vp[:, 0], vp[:, 1]
    s_dir, e_pp = vp[:, 2], vp[:, 3]
    nf, e_par, e_prp = vp[:, 4], vp[:, 5], vp[:, 6]
    z_roof_c, z_top_c = sc[16], sc[17]
    r_post_c, r_tube_c = sc[18], sc[19]
    p = org3 @ Mt + Cd
    d = d43[..., :3] @ Mt
    d = d / d.norm(dim=-1, keepdim=True)


    zhat = torch.tensor([0.0, 0.0, 1.0], device=p.device, dtype=p.dtype)
    Ps = sc[107:110]                                # strut base
    r_m1 = sc[110]
    r2 = sc[118]
    P3, r3, r_bore = sc[119:122], sc[125], sc[126]
    # per-env, per-step (the exit switches sides with the sun): mount rows
    e_ex, P2, A2, n3 = vp[:, 2], vp[:, 3], vp[:, 5], vp[:, 6]   # (B,1,3)
    f2 = scb[:, 1:2]                                # (B,1)
    P4, F4, f4, r4 = sc[127:130], sc[130:133], sc[133], sc[134]
    r_strut, z_bot, x_chase, y_chase = sc[135], sc[136], sc[137], sc[138]
    F = Pf                                          # (B,3) per env
    # ---- shadows on the SUN leg (p + t ut): M1 disc at F, M2 disc,
    # M3 disc, the strut from the wall tower to F. Discs as spheres of
    # the same radius, ahead of the dish point only.
    def _blocked(center, rad):
        vc = center - p
        ahead = (vc * ut).sum(-1) > 0
        perp = vc - (vc * ut).sum(-1, keepdim=True) * ut
        return ahead & (perp.norm(dim=-1) < rad)
    lit = ~_blocked(F, r_m1)
    lit = lit & ~_blocked(P2, r2)
    lit = lit & ~_blocked(P3, r3)
    ds, _ = _ray_seg_dist(p, ut, Ps, F)
    lit = lit & (ds > r_strut)
    in_slot = torch.zeros_like(lit)
    # ---- M1 at the focus (flat, normal nf from the mount)
    den = (d * nf).sum(-1)
    t1 = ((F - p) * nf).sum(-1) / torch.where(
        den.abs() > 1e-9, den, torch.full_like(den, 1e-9))
    h1 = p + t1[..., None] * d
    rad1 = (h1 - F).norm(dim=-1)
    # graze: the dish->F leg hitting the strut or M2 before F
    dsg, tsg = _ray_seg_dist(p, d, Ps, F)
    graze = (dsg < r_strut) & (tsg < t1 - 0.10)
    vc2 = P2 - p
    t_p2 = (vc2 * d).sum(-1)
    perp2 = (vc2 - t_p2[..., None] * d).norm(dim=-1)
    graze = graze | ((perp2 < r2) & (t_p2 > 0) & (t_p2 < t1 - 0.10))
    ok = lit & ~graze & (t1 > 0) & (rad1 < r_m1)
    d2 = d - 2.0 * (d * nf).sum(-1, keepdim=True) * nf
    # ---- M2: off-axis paraboloid collimator (focus F, axis A2)
    t2, h2m, n2, v2 = _parab_hit(h1, d2, F, A2, f2)
    ok = ok & v2 & ((h2m - P2).norm(dim=-1) < r2)
    ok_pre_tube = ok
    d3 = d2 - 2.0 * (d2 * n2).sum(-1, keepdim=True) * n2
    # ---- M3: flat at the wall line (normal n3), beam vertical
    den3 = (d3 * n3).sum(-1)
    t3 = ((P3 - h2m) * n3).sum(-1) / torch.where(
        den3.abs() > 1e-9, den3, torch.full_like(den3, 1e-9))
    h3m = h2m + t3[..., None] * d3
    ok = ok & (t3 > 0) & ((h3m - P3).norm(dim=-1) < r3)
    d4 = d3 - 2.0 * (d3 * n3).sum(-1, keepdim=True) * n3
    # ---- the chase: gates at the top (M3) and the bottom (turn)
    tg = (z_bot - h3m[..., 2]) / d4[..., 2].clamp(max=-1e-9)
    gx = h3m[..., 0] + tg * d4[..., 0] - x_chase
    gy = h3m[..., 1] + tg * d4[..., 1] - y_chase
    ok = ok & (d4[..., 2] < -0.5) & (torch.sqrt(gx * gx + gy * gy) < r_bore)
    ok_post_tube = ok
    # ---- M4: off-axis paraboloid at the turn (focus = duct mouth, axis +z)
    t4, h4, n4, v4 = _parab_hit(h3m, d4, F4, zhat, f4)
    ok = ok & v4 & ((h4 - P4).norm(dim=-1) < r4)
    d5 = d4 - 2.0 * (d4 * n4).sum(-1, keepdim=True) * n4
    # ---- the duct plane x = r_pot (the built mouth), as the stock chain
    r_pot_c, z_duct_c, r_duct_c = sc[12], sc[11], sc[13]
    t5 = (r_pot_c - h4[..., 0]) / d5[..., 0].clamp(max=-1e-9)
    ok = ok & (d5[..., 0] < -0.05) & (t5 < 4.0)
    t5 = t5.clamp(max=4.0)
    h5 = h4 + t5[..., None] * d5
    dy = h5[..., 1] + off[:, 0:1]
    dz = h5[..., 2] - z_duct_c + off[:, 1:2]
    through_b = ok & (t5 > 0) & (dy ** 2 + dz ** 2 <= r_duct_c ** 2)
    w_ray = torch.ones_like(t1)
    return (through_b, w_ray, dy, dz, d5, ok, ok_pre_tube, ok_post_tube,
            lit, in_slot, graze, rad1, p, h1, h4, h5, h2m)


def _hyp_hit(h, d, O, A, a_h, c_h):
    """Ray (h + t d) vs the F-side sheet of the two-sheet hyperboloid with
    centre O, axis A (unit, F -> F2), semi-axes a_h (along A) and
    b^2 = c^2 - a^2. Returns (t, hit, normal, valid); the F sheet is
    z = (X-O).A < 0. Smallest positive root on that sheet."""
    w = h - O
    z0 = (w * A).sum(-1)
    dz = (d * A).sum(-1)
    wd = (w * d).sum(-1)
    ww = (w * w).sum(-1)
    b2 = c_h * c_h - a_h * a_h
    qa = c_h * c_h * dz * dz - a_h * a_h
    qb = 2.0 * (c_h * c_h * z0 * dz - a_h * a_h * wd)
    qc = c_h * c_h * z0 * z0 - a_h * a_h * ww - a_h * a_h * b2
    disc = qb * qb - 4.0 * qa * qc
    sq = torch.sqrt(disc.clamp(min=0.0))
    sgn = torch.where(qb >= 0, torch.ones_like(qb), -torch.ones_like(qb))
    qq = -0.5 * (qb + sgn * sq)
    qa_s = torch.where(qa.abs() > 1e-12, qa, torch.full_like(qa, 1e-12))
    qq_s = torch.where(qq.abs() > 1e-12, qq, torch.full_like(qq, 1e-12))
    tA = qq / qa_s
    tB = qc / qq_s
    big = torch.full_like(tA, 1e9)
    def _sheet_ok(t):
        X = h + t[..., None] * d
        return (t > 1e-6) & (((X - O) * A).sum(-1) < 0)
    tA = torch.where(_sheet_ok(tA), tA, big)
    tB = torch.where(_sheet_ok(tB), tB, big)
    t = torch.minimum(tA, tB)
    valid = (disc >= 0) & (t < 1e8)
    X = h + t[..., None] * d
    zz = ((X - O) * A).sum(-1, keepdim=True)
    # per-env (B,1) semi-axes: the vector terms need a trailing axis
    n = (c_h * c_h)[..., None] * zz * A - (a_h * a_h)[..., None] * (X - O)
    n = n / n.norm(dim=-1, keepdim=True).clamp(min=1e-12)
    # orient toward the incoming ray
    n = torch.where((n * d).sum(-1, keepdim=True) > 0, -n, n)
    return t, X, n, valid


def _ellip_hit(h, d, O, A, a_e, c_e):
    """Ray (h + t d) vs the ellipsoid of revolution with centre O, axis A
    (unit), semi-major a_e, focal half-distance c_e. Returns the FAR
    positive root (the mirror patch sits on the far wall beyond the
    near focus), the hit, the inward normal oriented against d, valid."""
    w = h - O
    z0 = (w * A).sum(-1)
    dz = (d * A).sum(-1)
    wd = (w * d).sum(-1)
    ww = (w * w).sum(-1)
    a2, c2 = a_e * a_e, c_e * c_e
    b2 = a2 - c2
    qa = a2 - c2 * dz * dz
    qb = 2.0 * (a2 * wd - c2 * z0 * dz)
    qc = a2 * ww - c2 * z0 * z0 - a2 * b2
    disc = qb * qb - 4.0 * qa * qc
    sq = torch.sqrt(disc.clamp(min=0.0))
    qa_s = torch.where(qa.abs() > 1e-12, qa, torch.full_like(qa, 1e-12))
    t1 = (-qb - sq) / (2.0 * qa_s)
    t2 = (-qb + sq) / (2.0 * qa_s)
    t = torch.maximum(t1, t2)
    valid = (disc >= 0) & (t > 1e-6)
    X = h + t[..., None] * d
    wX = X - O
    zz = (wX * A).sum(-1, keepdim=True)
    n = a2[..., None] * wX - c2[..., None] * zz * A
    n = n / n.norm(dim=-1, keepdim=True).clamp(min=1e-12)
    n = torch.where((n * d).sum(-1, keepdim=True) > 0, -n, n)
    return t, X, n, valid


N_LEV_SURF = 7   # pressure levels per surface block (N_LEVELS); pts_l stacks blocks of this many


def _geo_core_cass(pts_l, nrm_l, lv, du, de, upick, us, sigb, Acan,
                   Mt, Cd, dvec, off, vp, sc, scb,
                   ellM, ellS, ellC, V0t, fct=None):
    """CASSEGRAIN receiver (user design 2026-09-04): dish -> a rotating
    STRIP of the hyperboloid with foci F (the dish focus) and F2 (the
    mirror image of the duct mouth in a flat M4 at the turn) -> straight
    bore from the tower top to the wall base -> M4 (flat) -> duct plane
    -> pot. The strip turns about the F-F2 axis with the dish's azimuth
    (a surface of revolution: both foci stay put) and spans the polar
    window [th_lo, th_hi] about that axis. Geometry from sc[106..138]
    (see _build_cass_chain). Stock tuple with reinterpreted slots:
    rad1 = 0 inside the strip / 1 outside, ok_pre_tube = after the
    membrane-crossing test, ok_post_tube = after the bore gates,
    h1 = strip hit, h2 = M4 hit, h3 = duct-plane hit, desc = strip hit."""
    csr_frac_c, csr_sig_c = sc[20], sc[21]
    if fct is None:
        fct = torch.cat([sc[106:145], sc[13:14]])[None, :].expand(lv.shape[0], -1)
    # the surface block (design table [60]): pts_l stacks N_LEV_SURF levels per
    # block - the built circle first, then the installed SECTIONS of the parent
    L = N_LEV_SURF if pts_l.shape[0] > N_LEV_SURF else pts_l.shape[0]
    i0 = lv.long().clamp(0, L - 2)
    if fct.shape[1] > 60 and pts_l.shape[0] > N_LEV_SURF:
        i0 = i0 + (fct[:, 60] + 0.5).long().clamp(0, pts_l.shape[0] // L - 1) * L
    fr = (lv - lv.long().clamp(0, L - 2).float())[:, None, None]
    p_loc = (1 - fr) * pts_l[i0] + fr * pts_l[i0 + 1]
    n_loc = (1 - fr) * nrm_l[i0] + fr * nrm_l[i0 + 1]
    n_loc = n_loc / n_loc.norm(dim=-1, keepdim=True)
    if fct.shape[1] > 60 and pts_l.shape[0] > N_LEV_SURF and scb.shape[1] > 6:
        # a SECTION's points live in the dish's body frame (x up the dish); the
        # trace's frame is turned about the normal by psi = scb[:, 6]: turn the
        # film to match (block 0, the circle, is left exactly as before)
        sec = (fct[:, 60] > 0.5)[:, None]
        cps = torch.where(sec, torch.cos(scb[:, 6:7]), torch.ones_like(sec, dtype=p_loc.dtype))[:, :, None]
        sps = torch.where(sec, torch.sin(scb[:, 6:7]), torch.zeros_like(sec, dtype=p_loc.dtype))[:, :, None]
        p_loc = torch.cat([cps * p_loc[..., :1] - sps * p_loc[..., 1:2], sps * p_loc[..., :1] + cps * p_loc[..., 1:2], p_loc[..., 2:]], -1)
        n_loc = torch.cat([cps * n_loc[..., :1] - sps * n_loc[..., 1:2], sps * n_loc[..., :1] + cps * n_loc[..., 1:2], n_loc[..., 2:]], -1)
    # the dish scale (design table [40]): uniform scaling of the membrane
    # about the frame origin, f and a scale together (kernel twin)
    if fct.shape[1] > 40:
        p_loc = p_loc * fct[:, 40, None, None]
    tq = us.clamp(0, 1) * 64.0
    ti = tq.long().clamp(max=63)
    tf = tq - ti.float()
    sun_t = sc[38:103]
    th_sun = sun_t[ti] * (1 - tf) + sun_t[ti + 1] * tf
    psi = 2.0 * np.pi * upick
    e_ang = th_sun * torch.cos(psi) + de * sigb[:, None]
    u_ang = th_sun * torch.sin(psi) + du * sigb[:, None]
    R = artist_utils.rotate_distortions(
        e=e_ang[:, None, :], u=u_ang[:, None, :],
        device=du.device)
    canon = torch.zeros(4, device=du.device, dtype=du.dtype)
    canon[1] = 1.0
    v = (R @ canon.expand(du.shape[0], 1, du.shape[1], 4)
         .unsqueeze(-1)).squeeze(-1)[:, 0]
    inc3 = (Acan @ v[..., :3, None]).squeeze(-1)
    inc4 = torch.cat([inc3, torch.zeros_like(inc3[..., :1])], -1)
    n4l = torch.cat([n_loc, torch.zeros_like(n_loc[..., :1])], -1)
    d43 = reflect(inc4, n4l)
    org3 = p_loc
    ut, Pf = vp[:, 0], vp[:, 1]           # ut = the SUN direction (shadows)
    ud = vp[:, 2]                          # the DISH axis (the strip follows it)
    p = org3 @ Mt + Cd
    d = d43[..., :3] @ Mt
    d = d / d.norm(dim=-1, keepdim=True)
    # ---- table: PER-ENV design rows fct (B,40) = _fc_table + r_duct
    # (design_rand: every agent its own receiver), or the shared static
    # block sc[106..144] + sc[13] broadcast to every env. Scalars are
    # (B,1) columns against the (B,P) ray tensors; vectors (B,1,3).
    Bn = p.shape[0]
    if fct is None:
        fct = torch.cat([sc[106:145], sc[13:14]])[None, :].expand(Bn, -1)
    g = lambda k: fct[:, k, None]
    v3 = lambda k: fct[:, k:k + 3][:, None, :]
    arm_n = g(1)                          # north arm length (post root = F + arm_n x)
    r_strip, d_strip, a_h, c_h = g(2), g(3), g(4), g(5)
    O, A = v3(6), v3(9)
    th_lo, th_hi, w_strip = g(12), g(13), g(14)
    P4, F4 = v3(15), v3(18)
    Oe, Ae, a_e, c_e = v3(21), v3(24), g(27), g(28)
    r_m4, r_bore, r_strut = g(29), g(30), g(31)
    f_dish, a_dish, z_deck, r_hole, w_slot = g(32), g(33), g(34), g(35), g(36)
    strip_wk, slot_el = g(37), g(38)
    r_duct = g(39)
    # THE SECONDARY'S SIDE IS PER AGENT (2026-09-08).  fct[:, 0] is the strip's
    # kind - 2 = 'cass' (hyperboloid, the F sheet before F), 3 = 'greg' (ellipsoid
    # beyond F) - and the Metal twin has always read it per thread
    # (cs_greg = cs_tab[0] > 2.5f).  This reference core read it ONCE, off row 0,
    # and called the receiver type global: a batch holding both would have traced
    # every agent through whichever secondary agent 0 happened to have.
    greg_b = fct[:, 0] > 2.5              # (B,)
    gm1 = greg_b[:, None]                 # against the (B,P) ray tensors
    gm3 = greg_b[:, None, None]           # against (B,P,3) and the (B,1,3) vectors
    any_greg = bool(greg_b.any())
    m4_ell = a_e > 1e-6                   # PER AGENT: an ellipsoid M4 (a_e > 0) or a flat one at the turn
    F = Pf                                # (B,1,3) per env
    xhat = torch.tensor([1.0, 0.0, 0.0], device=p.device, dtype=p.dtype)
    Ps = F + arm_n[..., None] * xhat
    _one = torch.ones((), device=p.device, dtype=p.dtype)
    side = torch.where(gm3, _one, -_one)      # (B,1,1)
    Hc = F + side * d_strip[..., None] * ud   # strip centre on the dish axis (before/beyond F)
    # arm end: F for cass (the strip intercepts the cone before F); for
    # greg a bearing on the axis d_strip up the anti-sun side, F - d A,
    # outside both the cone and the beam
    Qarm = torch.where(gm3, F - d_strip[..., None] * A, F)
    def _blocked(center, rad):
        vc = center - p
        ahead = (vc * ut).sum(-1) > 0
        perp = vc - (vc * ut).sum(-1, keepdim=True) * ut
        return ahead & (perp.norm(dim=-1) < rad)
    # ---- shadows on the sun leg: the strip (as a sphere) and the arm
    lit = ~_blocked(Hc, r_strip)
    rho_l = torch.sqrt(org3[..., 0] ** 2 + org3[..., 1] ** 2)
    lit = lit & (rho_l > r_hole)
    # the slot meridian: the world vertical's in-plane component in the
    # dish frame, downhill side (where the vertical through F pierces a
    # tilted dish); slot half-width w_slot/2 from r_hole to the rim
    zl = torch.einsum("k,bjk->bj", torch.tensor([0.0, 0.0, 1.0], device=p.device, dtype=p.dtype), Mt)   # (B,3)
    sl = -zl[:, :2]
    sl = sl / sl.norm(dim=-1, keepdim=True).clamp(min=1e-9)
    sl = sl[:, None, :]
    el_sun = torch.arcsin(ut[..., 2].clamp(-1, 1))            # (B,1)
    slot_open = (w_slot > 0) & (el_sun > slot_el)
    def _in_slot(xy):
        along = (xy * sl).sum(-1)
        perp = xy[..., 0] * sl[..., 1] - xy[..., 1] * sl[..., 0]
        return slot_open & (along > 0) & (perp.abs() < 0.5 * w_slot)
    in_slot = _in_slot(org3[..., :2])
    lit = lit & ~in_slot
    ds, _ = _ray_seg_dist(p, ut, Ps, Qarm)
    lit = lit & (ds > r_strut)
    # ---- the strip: hyperboloid hit on the F sheet, before F
    # the hyperboloid always (it is the built machine on every run so far); the
    # ellipsoid only when some agent asks for it, so a pure-'cass' batch costs
    # exactly what it did before.
    t1, h1, nh, v1 = _hyp_hit(p, d, O, A, a_h, c_h)
    if any_greg:
        # ellipsoid beyond F: the first surface crossing AFTER the ray
        # passes F (both roots lie on the closed surface)
        tF = ((F - p) * d).sum(-1)
        w_ = p - O
        z0_ = (w_ * A).sum(-1); dz_ = (d * A).sum(-1)
        wd_ = (w_ * d).sum(-1); ww_ = (w_ * w_).sum(-1)
        a2_, c2_ = a_h * a_h, c_h * c_h
        b2_ = a2_ - c2_
        qa_ = a2_ - c2_ * dz_ * dz_
        qb_ = 2.0 * (a2_ * wd_ - c2_ * z0_ * dz_)
        qc_ = a2_ * ww_ - c2_ * z0_ * z0_ - a2_ * b2_
        disc_ = qb_ * qb_ - 4.0 * qa_ * qc_
        sq_ = torch.sqrt(disc_.clamp(min=0.0))
        qa_s_ = torch.where(qa_.abs() > 1e-12, qa_, torch.full_like(qa_, 1e-12))
        ta_ = (-qb_ - sq_) / (2.0 * qa_s_)
        tb_ = (-qb_ + sq_) / (2.0 * qa_s_)
        big_ = torch.full_like(ta_, 1e9)
        ta_ = torch.where(ta_ > tF, ta_, big_)
        tb_ = torch.where(tb_ > tF, tb_, big_)
        te_ = torch.minimum(ta_, tb_)
        ve_ = (disc_ >= 0) & (te_ < 1e8)
        he_ = p + te_[..., None] * d
        wX_ = he_ - O
        zz_ = (wX_ * A).sum(-1, keepdim=True)
        ne_ = a2_[..., None] * wX_ - c2_[..., None] * zz_ * A
        ne_ = ne_ / ne_.norm(dim=-1, keepdim=True).clamp(min=1e-12)
        ne_ = torch.where((ne_ * d).sum(-1, keepdim=True) > 0, -ne_, ne_)
        t1 = torch.where(gm1, te_, t1)
        h1 = torch.where(gm3, he_, h1)
        nh = torch.where(gm3, ne_, nh)
        v1 = torch.where(gm1, ve_, v1)
    rel = h1 - F
    rn = rel.norm(dim=-1).clamp(min=1e-9)
    cth = (rel * A).sum(-1) / rn
    th = torch.arccos(cth.clamp(-1, 1))
    # azimuth about A: the strip's meridian follows the dish (-ut)
    def _azvec(x):
        return x - (x * A).sum(-1, keepdim=True) * A
    av_h = _azvec(rel)
    av_s = _azvec(side * ud)
    cosd = (av_h * av_s).sum(-1) / (av_h.norm(dim=-1) * av_s.norm(dim=-1)).clamp(min=1e-9)
    rho = av_h.norm(dim=-1)
    arc = torch.arccos(cosd.clamp(-1, 1)) * rho
    # near the axis the meridian azimuth is degenerate: a hit within the
    # strip's half-width of the axis is covered whatever its azimuth
    w_loc = torch.where(strip_wk > 0, strip_wk * rn, w_strip.expand_as(rn))
    on_strip = v1 & (th >= th_lo) & (th <= th_hi) & ((arc < 0.5 * w_loc) | (rho < 0.5 * w_loc))
    rad1 = torch.where(on_strip, torch.zeros_like(th), torch.ones_like(th))
    # the dish->strip leg grazing the arm
    dsg, tsg = _ray_seg_dist(p, d, Ps, Qarm)
    graze = (dsg < r_strut) & (tsg < t1 - 0.05)
    ok = lit & ~graze & on_strip
    d2 = d - 2.0 * (d * nh).sum(-1, keepdim=True) * nh
    # ---- the reflected leg must clear the membrane (ideal paraboloid,
    # vertex Cd, axis ut, focal length f_dish) and the arm
    l0 = torch.einsum("bnk,bjk->bnj", h1 - Cd, Mt)
    dl = torch.einsum("bnk,bjk->bnj", d2, Mt)
    qa = dl[..., 0] ** 2 + dl[..., 1] ** 2
    qb = 2.0 * (l0[..., 0] * dl[..., 0] + l0[..., 1] * dl[..., 1]) - 4.0 * f_dish * dl[..., 2]
    qc = l0[..., 0] ** 2 + l0[..., 1] ** 2 - 4.0 * f_dish * l0[..., 2]
    disc = qb * qb - 4.0 * qa * qc
    sq = torch.sqrt(disc.clamp(min=0.0))
    qa_s = torch.where(qa.abs() > 1e-12, qa, torch.full_like(qa, 1e-12))
    tm = (-qb - sq) / (2.0 * qa_s)
    tp = (-qb + sq) / (2.0 * qa_s)
    def _dish_block(t):
        X = l0 + t[..., None] * dl
        rr = torch.sqrt(X[..., 0] ** 2 + X[..., 1] ** 2)
        return (disc >= 0) & (t > 1e-3) & (rr < a_dish) & (rr > r_hole) & ~_in_slot(X[..., :2])
    crossing = _dish_block(tm) | _dish_block(tp)
    dsa, tsa = _ray_seg_dist(h1, d2, Ps, Qarm)
    crossing = crossing | ((dsa < r_strut) & (tsa > 0))
    ok = ok & ~crossing
    ok_pre_tube = ok
    # ---- the bore: a straight cylinder of radius r_bore about the axis
    # F -> P4; gates at the deck plane and at M4's plane
    axis = P4 - F
    axis = axis / axis.norm(dim=-1, keepdim=True)
    def _axis_dist(X):
        w = X - F
        return (w - (w * axis).sum(-1, keepdim=True) * axis).norm(dim=-1)
    tdeck = (z_deck - h1[..., 2]) / d2[..., 2].clamp(max=-1e-9)
    hdeck = h1 + tdeck[..., None] * d2
    # M4 per env: the ellipsoid patch (foci F2 and the duct mouth) where a_e > 0, else a FLAT
    # mirror at the turn - the u_f2 = 0 design, in which the strip images F straight onto the
    # mouth. Both are evaluated and selected elementwise: a batch may hold either (the kernel
    # branches per env, so a batch-wide Python `if` here would break parity).
    t4e, h4e, n4e, v4e = _ellip_hit(h1, d2, Oe, Ae, a_e.clamp(min=1e-3), c_e)
    den4 = (d2 * Ae).sum(-1)
    t4f = ((P4 - h1) * Ae).sum(-1) / torch.where(
        den4.abs() > 1e-9, den4, torch.full_like(den4, 1e-9))
    h4f = h1 + t4f[..., None] * d2
    n4f = Ae.expand_as(d2)
    t4 = torch.where(m4_ell, t4e, t4f)
    h4 = torch.where(m4_ell[..., None], h4e, h4f)
    n4 = torch.where(m4_ell[..., None], n4e, n4f)
    v4 = torch.where(m4_ell, v4e, t4f > 0)
    ok = ok & (d2[..., 2] < -0.2) & (_axis_dist(hdeck) < r_bore)
    ok_post_tube = ok
    # ---- M4: ellipsoid patch (foci F2, duct mouth) or flat at the turn
    ok = ok & v4 & ((h4 - P4).norm(dim=-1) < r_m4)
    if fct.shape[1] > 66:
        # a FACETTED M4 (design table [66], rad rms): each ray's facet tilts its normal by a Gaussian
        # of that width in a random direction in the mirror's tangent plane; the draw comes from the
        # ray's two uniforms scrambled (kernel twin). sigma 0 = the smooth ellipsoid, exactly as before.
        # LOCAL NAMES PREFIXED f4_: t1/t2/g1/g2 are the hyperboloid hit's, and w_ray is built from t1
        f4_sig = fct[:, 66, None, None]
        f4_u1 = torch.frac(upick * 97.0 + 0.137); f4_u2 = torch.frac(us * 89.0 + 0.618)
        f4_r = torch.sqrt(-2.0 * torch.log(f4_u1.clamp(min=1e-7)))
        f4_g1 = (f4_r * torch.cos(6.2831853 * f4_u2))[..., None]; f4_g2 = (f4_r * torch.sin(6.2831853 * f4_u2))[..., None]
        f4_yh = torch.tensor([0.0, 1.0, 0.0], dtype=n4.dtype, device=n4.device).expand_as(n4)
        f4_t1 = torch.linalg.cross(n4, f4_yh); f4_t1 = f4_t1 / f4_t1.norm(dim=-1, keepdim=True).clamp(min=1e-9)
        f4_t2 = torch.linalg.cross(n4, f4_t1)
        f4_n = n4 + f4_sig * (f4_g1 * f4_t1 + f4_g2 * f4_t2); n4 = f4_n / f4_n.norm(dim=-1, keepdim=True)
    d5 = d2 - 2.0 * (d2 * n4).sum(-1, keepdim=True) * n4
    # ---- the duct plane x = r_pot (the built mouth), as the stock chain;
    # the mouth radius is the per-env design's (fct[39])
    r_pot_c, z_duct_c = sc[12], sc[11]
    # A PORT-MOUNTED M3 (x_turn = R_POT) straddles this plane. A ray that hit the inner
    # half reflected INSIDE the pot: it must have come in through the hole (test the
    # strip->M3 leg's crossing), and it needs no outbound crossing - h5 is then the
    # backward extrapolation to the plane, which is exactly the origin _bin_pot wants.
    inside = h4[..., 0] <= r_pot_c
    t_in = (r_pot_c - h1[..., 0]) / d2[..., 0].clamp(max=-1e-9)
    h_in = h1 + t_in[..., None] * d2
    dyi = h_in[..., 1] + off[:, 0:1]
    dzi = h_in[..., 2] - z_duct_c + off[:, 1:2]
    in_ok = ~inside | ((d2[..., 0] < 0) & (t_in > 0) & (dyi ** 2 + dzi ** 2 <= r_duct ** 2))
    ok = ok & in_ok
    t5 = (r_pot_c - h4[..., 0]) / d5[..., 0].clamp(max=-1e-9)
    t5raw = t5                                              # before the clamp: the ledger needs the real value
    ok = ok & (d5[..., 0] < -0.05) & (t5 < 4.0)
    t5 = t5.clamp(max=4.0)
    h5 = h4 + t5[..., None] * d5
    dy = h5[..., 1] + off[:, 0:1]
    dz = h5[..., 2] - z_duct_c + off[:, 1:2]
    through_b = ok & (inside | ((t5 > 0) & (dy ** 2 + dz ** 2 <= r_duct ** 2)))
    w_ray = torch.ones_like(t1)
    # THE MISS LEDGER - the Metal kernel's mk_ block, line for line. First failure
    # wins; codes as there; 6..9 continue to the nearest real surface.
    _ZC, _RS, _RDW = g(78), g(79), g(80)                  # this agent's pit (B,1), as the kernel reads them
    mk_bore = (d2[..., 2] < -0.2) & (_axis_dist(hdeck) < r_bore)
    mk_m3 = v4 & ((h4 - P4).norm(dim=-1) < r_m4)
    mk_way = (d5[..., 0] < -0.05) & (t5raw < 4.0) & (inside | (t5raw > 0))
    code = torch.full_like(t1, 0.0)
    stop = h5.clone()
    o_ = h5.clone(); d_ = d5.clone(); cont = torch.zeros_like(through_b)
    def _set(mask, c, s, o=None, d=None, k=False):
        nonlocal code, stop, o_, d_, cont
        m = mask & (code == 0.0) & ~through_b if c != 0.0 else mask
        code = torch.where(m, torch.full_like(code, c), code)
        stop = torch.where(m[..., None], s, stop)
        if k:
            o_ = torch.where(m[..., None], o, o_); d_ = torch.where(m[..., None], d, d_)
            cont = cont | m
    # priority order = the kernel's if/else chain
    _set(_blocked(Hc, r_strip), 11.0, p); _set(~(rho_l > r_hole), 12.0, p); _set(in_slot, 13.0, p); _set(~(ds > r_strut), 14.0, p)
    _set(~v1, 2.0, p); _set(~on_strip, 3.0, h1); _set(graze, 4.0, h1); _set(crossing, 5.0, h1)
    _set(~mk_bore, 6.0, h1, h1, d2, True); _set(~mk_m3, 7.0, h1, h1, d2, True)
    _set(~in_ok, 9.0, h_in)                                             # the collar, from the OUTSIDE, on the way in
    _set(~mk_way, 8.0, h4, h4, d5, True)
    _set(~through_b, 9.0, h5)
    # continuation for 6..8: nearest positive t among bore wall, deck, pot sphere, pit floor
    big = torch.full_like(t1, 1e9)
    a_ = (P4 - F); a_ = a_ / a_.norm(dim=-1, keepdim=True).clamp(min=1e-9)
    w_ = o_ - F; wp = w_ - (w_ * a_).sum(-1, keepdim=True) * a_; dp = d_ - (d_ * a_).sum(-1, keepdim=True) * a_
    qa = (dp * dp).sum(-1); qb = 2.0 * (wp * dp).sum(-1); qc = (wp * wp).sum(-1) - r_bore ** 2   # r_bore is (B,1)
    dsc = qb * qb - 4.0 * qa * qc; sq = torch.sqrt(dsc.clamp(min=0.0)); qas = torch.where(qa.abs() > 1e-9, qa, torch.full_like(qa, 1e-9))
    tmin = big; surf = torch.full_like(t1, -1.0)
    def _take(t_, sid):
        nonlocal tmin, surf
        m_ = t_ < tmin; tmin = torch.where(m_, t_, tmin); surf = torch.where(m_, torch.full_like(surf, float(sid)), surf)
    for r_ in ((-qb - sq) / (2.0 * qas), (-qb + sq) / (2.0 * qas)):
        _take(torch.where((qa > 1e-9) & (dsc >= 0) & (r_ > 1e-3), r_, big), 0)          # bore wall
    dz_ = torch.where(d_[..., 2].abs() > 1e-9, d_[..., 2], torch.full_like(t1, 1e-9))
    td = (z_deck - o_[..., 2]) / dz_; _take(torch.where(td > 1e-3, td, big), 1)             # deck
    pc = torch.stack([r_pot_c - _RDW[:, 0], torch.zeros_like(_RDW[:, 0]), _ZC[:, 0] + 1.0], -1)[:, None, :]   # (B,1,3)
    ws = o_ - pc; sb = 2.0 * (ws * d_).sum(-1); scc = (ws * ws).sum(-1) - _RS ** 2; sd = sb * sb - 4.0 * scc; sqs = torch.sqrt(sd.clamp(min=0.0))
    for s_ in ((-sb - sqs) * 0.5, (-sb + sqs) * 0.5):
        _take(torch.where((sd >= 0) & (s_ > 1e-3), s_, big), 2)                            # pot exterior
    tf = ((_ZC + 1.0 - _RS) - o_[..., 2]) / dz_; _take(torch.where(tf > 1e-3, tf, big), 3)    # pit floor
    esc = cont & (tmin > 20.0); code = torch.where(esc, torch.full_like(code, 10.0), code); tmin = tmin.clamp(max=20.0)
    surf = torch.where(esc | ~cont, torch.full_like(surf, -1.0), surf)
    stop = torch.where(cont[..., None], o_ + tmin[..., None] * d_, stop)
    # THE EXTERIOR BIN - the kernel's table, line for line (NX = 37)
    rf = (torch.sqrt(org3[..., 0] ** 2 + org3[..., 1] ** 2) / a_dish.clamp(min=1e-6)).clamp(0.0, 0.999)
    rb_ = (rf * 4.0).floor()
    binv = torch.full_like(t1, -1.0)
    def _bin(mask, val):
        nonlocal binv
        binv = torch.where(mask & (binv < 0), val if torch.is_tensor(val) else torch.full_like(binv, float(val)), binv)
    dyc = torch.where(in_ok, dy, dyi); dzc = torch.where(in_ok, dz, dzi)          # the collar hit: inbound or outbound
    _bin(code == 9.0, ((torch.atan2(dzc, dyc) + np.pi) / (2.0 * np.pi) * 8.0).floor().clamp(0, 7))
    _bin(code == 5.0, 21.0 + rb_); _bin(code == 11.0, 25.0 + rb_); _bin(code == 13.0, 29.0 + rb_)
    _bin(code == 12.0, 33.0); _bin(code == 14.0, 34.0); _bin(code == 3.0, 35.0); _bin(code == 2.0, 36.0); _bin(code == 10.0, 20.0)
    ax_ = (P4 - F); Lb_ = ax_.norm(dim=-1, keepdim=True).clamp(min=1e-6); ax_ = ax_ / Lb_
    bore_fr = (((stop - F) * ax_).sum(-1) / Lb_[..., 0]).clamp(0.0, 0.999)
    lat_ = ((stop[..., 2] - (_ZC + 1.0)) / _RS * 0.5 + 0.5).clamp(0.0, 0.999)
    _bin(cont & (surf == 1.0), 14.0); _bin(cont & (surf == 2.0), 15.0 + (lat_ * 4.0).floor())
    _bin(cont & (surf == 3.0), 19.0); _bin(cont & (surf == 0.0), 8.0 + (bore_fr * 6.0).floor())
    fate = torch.cat([code[..., None], stop, surf[..., None], binv[..., None]], dim=-1)
    return (through_b, w_ray, dy, dz, d5, ok, ok_pre_tube, ok_post_tube,
            lit, in_slot, graze, rad1, p, h1, h4, h5, h1, fate)


class TandoorHashemiEnv(TandoorCoudeEnv):
    #: level, shutter, jam - plus Hashemi's TWO DC MOTORS (fig 14/17):
    #: the azimuth roller on the ring rail and the elevation tow-wire.
    #: Tracking is no longer assumed: the policy drives the carriage.
    N_HEADS = 5
    #: jam, seasonal drift, and the two pointing-error encoders
    N_EXTRA_OBS = 4
    # Slew at full command. The sun moves ~0.004 deg/s; these are ~8x
    # that - enough to acquire and hold, geared like a real tow-wire.
    # (First cut used 0.45 deg/s: one step of the smallest command was
    # 2.3 deg at this dt, and the tracker limit-cycled at +-2.4 deg.)
    RATE_AZ = 0.035    # roller slew [deg/s] at full command
    RATE_EL = 0.025    # tow-wire slew [deg/s] at full command

    def __init__(self, *args, a_mem=2.10, g_orbit=5.0, z_waist=None,
                 z_m5=-0.10, el_min=12.0, r_mast=0.25, n_rays=1100,
                 fuse=1, gpu=0, beta_dev=0.0, slot_flaps=0,
                 silvered=0, m5_scale=1.0, zone_c=0.0,
                 receiver="fold", cut_penalty=0.0, exit_el=20.0,
                 d_strip=0.6, strip_th_lo=0.0, strip_th_hi=100.0,
                 w_strip=1.2, r_strip=0.6, arm_north=3.0, u_f2=3.5,
                 sec_side="cass", r_hole=0.5,
                 night_carry=0, night_hours=16.0, dt_night=60.0, r_duct=None,
                 w_slot=0.7, strip_wk=1.1, slot_el=54.0,
                 lost_deg=3.0, enc_clamp=3.0, m4_mode="field",
                 leg_tilt=50.0, post_offset=2.5,
                 deck_h=None, col_dist=0.75, col_radius=0.5, r_m1=0.15,
                 r_m3=1.0, r_bore=1.3, z_turn=None, x_turn=None, r_m4=1.3, shell="perlite",
                 r_strut=0.08, **kwargs):
        # OPTICAL-EFFICIENCY levers (defaults = current machine):
        # beta_dev: off-axis deviation [deg] of the beam from retro.
        #   The primary is a SPHERE - it has no optical axis, so the
        #   retro orbit (dish diametrically opposite the fold from the
        #   sun) is a choice, and the costliest one: it centers the
        #   fold's shadow on the aperture (31%). Biasing the orbit by
        #   beta_dev slides the shadow off at the price of the
        #   sphere's working-angle astigmatism ~ a*(beta/2)^2, which
        #   the ellipsoid's 3x DEMAGNIFYING relay compresses below
        #   the duct radius. Pure aim law - the carriage already owns
        #   both degrees of freedom.
        # slot_flaps: thin mirrored flaps close the dish slot except
        #   in the post-crossing band (el >= el_x - 3 deg).
        # silvered: ReflecTech-class silvered film and silvered
        #   fold/M5/duct (0.88/0.95/0.95/0.96 -> 0.94/0.97/0.96/0.97).
        # m5_scale: M5 patch radius margin multiplier.
        self.beta_dev = float(beta_dev)
        self.slot_flaps = bool(slot_flaps)
        self.silvered = bool(silvered)
        self.m5_scale = float(m5_scale)
        # ZONED MEMBRANE (Hashemi-frame short-f design): n_zones plenum
        # zones at p_k = p0 * (1 - zone_c * (r_k/a)^2) (zone-centre radii)
        # make the pumped membrane a paraboloid at fast f/D - the FvK
        # solver's per-zone pressures (solve_membrane zone_edges). At
        # a 2.10 m, T_pre 600 N/m, f 4.0: uniform 7.0 mrad slope rms;
        # 5 zones zone_c 0.4 -> 0.50 mrad (scratchpad membrane_f4_T600).
        # zone_c 0 (default) = uniform pressure, the stock membrane.
        self.zone_c = float(zone_c)
        # RECEIVER AT THE FOCUS (Hashemi's frame, user design 2026-09-04):
        # receiver='focus' puts a small steerable beam-down mirror M1 AT
        # the dish focus F (orbit radius g_orbit = the focal length, dish
        # square to the sun, axis through F), sends the beam down along
        # e_exit (exit_tilt deg from vertical toward the courtyard, -x),
        # collimates it on an off-axis paraboloid M2 (focus F, col_dist
        # along the exit, radius col_radius), folds it vertical on a flat
        # M3 at the wall line (deck level), down a chase of radius
        # r_bore to the turn at z_turn, where an off-axis paraboloid M4
        # (focus = the built duct mouth) throws it into the pot. F stands
        # post_offset north of the wall so the dish's high-sun swing
        # clears the wall tower; the strut from the tower to F is the
        # post. 'fold' (default) is the stock fixed-fold machine.
        # Measured (torch ladder, f 4, 5 zones, summer, perfect tracking):
        # through 74-78%, shadow ~10% (M2 5%, M3+strut), 184 MJ/8h vs the
        # stock 147; Metal == torch reference 0/120 mismatches, 3e-6 W.
        self.receiver = str(receiver)
        # fixed truncation penalty (raw reward units) on top of the exact
        # potential refund: a lost sun is a failure, not a free exit to a
        # fresh pot (runs 178846843942/178847731389 collapsed through the
        # last-hour cut being cheaper than holding unfinishable loaves)
        self.cut_penalty = float(cut_penalty)
        if self.receiver not in ("fold", "focus", "cass", "tri"):
            raise ValueError(f"receiver={receiver!r}: 'fold', 'focus', 'cass' or 'tri'")
        # THE THREE-MIRROR MACHINE (user, 2026-09-07): dish -> hyperboloid strip ->
        # M3 -> the bread. Same shapes as 'cass', but M3's second focus sits ON a
        # loaf instead of on the pot's inlet, and the elbow is gone - so the strip's
        # image lands on the bread itself and M3 turns about the bore's own axis to
        # choose which loaf. Every 'cass' branch below is shared through self._cass.
        # inlet_esc: how much of the pot's cavity radiation escapes through the beam
        # inlet (an unlidded hole of radius r_duct). 1 = a clear hole to ambient,
        # 0 = the pre-2026-09-07 behaviour, in which the inlet was free.
        self.inlet_esc = float(kwargs.pop("inlet_esc", 1.0))
        self.tri = self.receiver == "tri"
        self._cass = self.receiver in ("cass", "tri")
        # THE INLET IS A DIFFERENT PART ON THE THREE-MIRROR MACHINE.  On 'cass' the
        # elbow re-images inside the pot and the inlet is the duct's mouth behind it;
        # on 'tri' the beam itself passes through the hole on its way to the bread, so
        # the hole is an optical aperture and the measured chain wants 0.55-0.90 (at
        # 0.40 the collar clips a third of the power; the M3 turn's half-power span
        # goes +-25 -> +-45 deg over that range).  Deleting the elbow also removes the
        # second chance: on 'cass' the elbow re-images at the pot and forgives a badly
        # proportioned chain, while on 'tri' the beam must survive strip -> bore -> M3
        # -> through the inlet -> onto the bread in one go.
        # Until 2026-09-08 that lived here as a per-env fork of DESIGN_BOX (_TRI_BOX
        # narrowed r_duct to 0.35-0.90 and d_strip to 0.40-0.80 whenever receiver was
        # 'tri').  It is no longer expressible: 'receiver' is a design COLUMN, so one
        # batch holds both machines and there can only be one box.  The union box lives
        # in DESIGN_BOX - r_duct reaches 0.90 for everyone now - and the interaction is
        # the designer's to learn rather than mine to assert.  What the fork was really
        # working around is a search problem, not a physics one: over 2048 random tri
        # designs the mean traced power was 0.49 kW against 141 rotis on the good ones,
        # so a uniform draw was mostly machines that miss and the critic went constant.
        # The bootstrap-on-the-ladder generations in tandoor_designer.py are the fix
        # that does not move the coordinates under a trained policy.
        # CASSEGRAIN receiver (user design 2026-09-04): receiver='cass'
        # replaces M1+M2+M3 by ONE rotating strip of the hyperboloid whose
        # foci are F and the mirror image of the duct mouth in a flat M4
        # at the turn; the beam converges down a straight bore from the
        # tower top to the wall base. d_strip: strip distance from F on
        # the dish axis [m]; strip_th_lo/hi: polar window about the F-F2
        # axis [deg]; w_strip: azimuthal width [m]; r_strip: shadow
        # radius [m]; arm_north: the F post arrives horizontally from a
        # north tower this far beyond F (out of the bore).
        self.d_strip, self.w_strip, self.r_strip = float(d_strip), float(w_strip), float(r_strip)
        self.strip_th_lo, self.strip_th_hi = float(strip_th_lo), float(strip_th_hi)
        self.arm_north = float(arm_north)
        self.u_f2 = float(u_f2)       # F2 this far before M4 up the bore; M4 = ellipsoid (F2, duct mouth)
        # sec_side: 'cass' = hyperboloid strip BEFORE F (dish side, convex);
        # 'greg' = ellipsoid strip BEYOND F (sun side, concave): the rays
        # pass F, diverge and re-converge to F2. Same foci, same bore.
        self.sec_side = str(sec_side)
        # r_hole: central hole in the membrane (classic Cassegrain: the
        # converging beam passes the primary through it; the centre is
        # in the secondary's shadow anyway)
        self.r_hole = float(r_hole)
        # w_slot: Hashemi's radial slot, a cut of this width along the
        # dish's downhill meridian from r_hole to the rim; the vertical
        # bore's converging beam passes the dish through it at high sun
        self.w_slot = float(w_slot)
        # strip_wk > 0: the strip's width follows the cone's footprint,
        # width = strip_wk x (hit distance from F) instead of w_strip
        self.strip_wk = float(strip_wk)
        # slot_el > 0: mirrored flaps close the slot while the sun is below
        # slot_el deg (the dish only reaches the bore above ~54 deg)
        self.slot_el = float(slot_el)
        # POINTING: lost_deg is the |e_az|+|e_el| threshold (deg) behind
        # the 40-step guillotine; enc_clamp the +-clamp of the pointing
        # encoders (units of 0.5 deg, so 3 = blind beyond 1.5 deg). The
        # cass run 178862753223 learned a deliberate 1-2 deg azimuth
        # offset (spot steering, 9 m/rad on that machine) right under
        # the 3 deg cliff and blind beyond 1.5 - noise walked it over.
        self.lost_deg = float(lost_deg)
        self.enc_clamp = float(enc_clamp)
        # m4_mode: 'relay' = the image F2 sits u_f2 up the bore and M4 (foci
        # F2, mouth) demagnifies it onto the mouth; 'field' (user,
        # 2026-09-06) = the image sits ON M4 (F2 = P4) and M4 is a FIELD
        # mirror with foci at F and the mouth: it images the strip onto
        # the mouth, so every ray passes a ~10 cm pupil there and an
        # actuated M4 steers the spot in the pot without losing rays
        self.m4_mode = str(m4_mode)
        if self.m4_mode not in ("relay", "field"):
            raise ValueError("m4_mode: 'relay' or 'field'")
        # NIGHT CARRY-OVER (user, 2026-09-04: "warm_frac should be set by
        # the insulation type"): with night_carry the day-over does not
        # draw a warm/cold pot; yesterday's pot cools through night_hours
        # with the SAME wall model the day uses (lid on, no sun, dt_night
        # explicit Euler), so the dawn state is whatever the insulation
        # leaves and the seasoned regime emerges over consecutive days.
        # warm_frac then only seeds the very first day of a rollout.
        # r_duct: the built duct mouth radius (sc[13]); default R_DUCT_H
        self.r_duct = float(R_DUCT_H) if r_duct is None else float(r_duct)
        self.night_carry = bool(night_carry)
        self.night_hours = float(night_hours)
        self.dt_night = float(dt_night)
        if self.sec_side not in ("cass", "greg"):
            raise ValueError("sec_side: 'cass' or 'greg'")
        # exit of the beam-down M1: on the azimuth turntable with M2 -
        # toward the WEST while the sun is east, toward the EAST while it
        # is west (always the anti-sun side, above the dish's cone), at
        # exit_el above horizontal; M1 incidence then stays 20-55 deg all
        # day. M3 (fixed on the wall line) trims its tilt for the two
        # legs. The leg from M2 runs down-south at leg_tilt from vertical.
        self.exit_el = float(exit_el)
        self.leg_tilt = float(leg_tilt)
        self.post_offset = float(post_offset)
        self.deck_h = deck_h
        self.col_dist, self.col_radius = float(col_dist), float(col_radius)
        self.r_m1, self.r_m3, self.r_bore = float(r_m1), float(r_m3), float(r_bore)
        if self._cass:
            # the derived bore geometry (ladder at Quetta:
            # 182/193/149 MJ per 8 h summer/equinox/winter): the tower
            # 0.5 m north of the wall, the bore 0.7 m at the deck, M4
            # r 1.3 - applied where the shared kwargs still hold the
            # focus machine's defaults.
            # NOT a vertical bore, whatever this comment used to say.
            # The bore runs F -> P4 and P4 is fixed over the chase, so
            # post_offset TILTS it: 0.5 m gives 2.94 deg and puts F
            # 0.71 bore radii off the borehole's axis. post_offset=0
            # is the vertical one, and it costs 19% at midwinter and
            # 4% on the year (traced) because the offset buys low-sun
            # clearance past the wall tower.
            if post_offset == 2.5:
                self.post_offset = 0.5
            if r_bore == 1.3:
                self.r_bore = 0.7
        if self.tri and not int(kwargs.get("design_rand", 0)):
            # the three-mirror machine has no elbow: M3 throws the image straight at
            # the bread, so the jet model in _bin_pot must not turn it again. Set it
            # in KWARGS, not on self - the base class assigns self.duct_nozzle from
            # the kwarg later and would put the elbow back (the ini asks for 2).
            # ONLY when the receiver is fixed for the whole env. Under design_rand
            # the receiver is a design column: the batch holds both machines, so the
            # env must still BUILD the elbow (self._noz2, from this kwarg) for the
            # 'cass' rows, and _fct[:, DS['noz']] decides per agent who gets it.
            if int(kwargs.get("duct_nozzle", 0)):
                print(f"  [hashemi] receiver='tri': duct_nozzle={kwargs['duct_nozzle']} ignored, the three-mirror machine has no elbow")
            kwargs["duct_nozzle"] = 0
        self.z_turn, self.r_m4, self.r_strut = z_turn, float(r_m4), float(r_strut)
        # x_turn: M3's x. None = over the chase (X_TOWER, the bore's foot). Set it to
        # R_POT and the mirror's vertex sits IN the inlet plane - the port-mounted M3
        # (user, 2026-09-10): half the disc inside the wall, the strip's beam landing
        # on it at the hole, nothing downstream to clip. The kernels then test the
        # INBOUND crossing for rays that hit the inner half, and let rays that reflect
        # inside pass without an outbound crossing (see the duct-plane block).
        self.x_turn = None if x_turn is None else float(x_turn)
        # shell: what the pit's insulating annulus is MADE OF (tandoor_rl_env.SHELL_MATERIALS).
        # ins_scale stays the design knob (the deep->halo conductance factor); the material
        # decides the thickness and mass that factor costs, and the bill prices that.
        from tandoor_rl_env import SHELL_MATERIALS as _SM
        if shell not in _SM:
            raise ValueError(f"shell={shell!r}: one of {sorted(_SM)}")
        self.shell = str(shell)
        # fold_toroid: COMPLIANT SECONDARY. The fold becomes a weak
        # toroid whose meridian curvatures re-unify the sphere's
        # off-axis tangential/sagittal foci at the waist. The needed
        # ratio R_t/R_s = 1/cos^2(i) varies with elevation - exactly
        # a one-parameter figure family, i.e. a membrane on a
        # compliant rim with a single squeeze dof slaved to pitch
        # (PRBM). Enables beta past the astigmatism budget, toward
        # the shadow-zero orbit.
        self.fold_toroid = float(kwargs.pop("fold_toroid", 0))
        if int(kwargs.get("elbow_aim", 0)):
            self.N_HEADS = 7          # + spot azimuth, spot height
            # + spot phi, spot z, and the aimed BIN one-hot (8): the
            # phi->bin binding is discrete data the env computes
            # exactly - embed it, don't make the net learn it
            self.N_EXTRA_OBS = 14
        if int(kwargs.get("load_ctrl", 0)):
            # the policy plays the COOK: one 7-way gate head per bin
            # (value > thr_g = slap dough here at the next lean; the
            # last n_belt heads), and has_bread joins obs so a cold
            # parked loaf is distinguishable from a cold empty bin
            self.N_HEADS += 8
            self.N_EXTRA_OBS += 8
        # design_rand: RL THE DESIGN. Every agent runs its own receiver
        # design (uniform in DESIGN_BOX, seeded) and sees it in obs as
        # unit-box coordinates (2u-1), so one policy is conditioned on
        # the design and its critic reads out V(design); rotis-by-design
        # is the design sensitivity WITH the controller in the loop.
        # form_min: soft steps of the cook's hands before the membrane's
        # figure follows the day's declination (the dawn re-form is paid
        # for, never free; 1 = the old instant re-form)
        if kwargs.get("render_mode") == "human":
            kwargs["num_agents"] = 1        # the renderer shows agent 0 only (user): one agent, one machine
        self.form_min = int(kwargs.pop("form_min", 4))
        # form_drift: the dawn routine. With the carry-over the cook
        # re-forms the membrane by hand at dawn whenever the figure has
        # drifted this many degrees of declination from the day's - it
        # costs form_min soft steps of reward (-0.02 each) and is
        # recorded in form_minutes; mid-day re-forming stays the policy's.
        self.form_drift = float(kwargs.pop("form_drift", 2.0))
        # consecutive_days: with the carry-over, tomorrow is the next
        # calendar day at the same site (1, the physical model) or a
        # fresh random day and latitude with the pot carried and the
        # figure re-formed for free (0: the pre-490778e3 training
        # distribution, kept as an experimental control)
        self.consecutive_days = int(kwargs.pop("consecutive_days", 1))
        # day_end: the solar hour the day ends at (16 = the old daylight-only
        # day; 20 = the evening, baked from the stored heat after sunset -
        # what the sand bed is for). The night is what is left of 24 h.
        self.day_end = float(kwargs.pop("day_end", 16.0))
        # day_start: the solar hour the day begins (8 = the old day; 6 with
        # the demand process, so breakfast is in the day)
        self.day_start = float(kwargs.pop("day_start", 8.0))
        if float(night_hours) == 16.0 and (self.day_end != 16.0 or self.day_start != 8.0):
            night_hours = 24.0 - (self.day_end - self.day_start)
            self.night_hours = float(night_hours)     # (the attribute was already set above)
        # THE CUSTOMERS (user): a tandoor sells at breakfast, lunch and
        # dinner. demand=1 samples customers each step from a three-band
        # rate (7:30 / 13:00 / 19:30 solar, shares 25/35/40 %), each with
        # an order of 3, 10 or 30 rotis (a few, a family, a lunch or
        # dinner); orders wait `patience` minutes, baked rotis keep on the
        # shelf `shelf_life` minutes; a roti counts (+5) only when it meets
        # an order, a stale one costs stale_pen. The shop's size is the
        # site's demand_scale (design table col 56) x demand_day rotis/day.
        # design_pop: THE METAPROGRAMMER's population (tandoor_designer.py
        # writes it). Every redesign_days dawns, a share of the agents
        # redraw their kit from the designer's Gaussian for their site
        # (nearest site entry by roof percentile), the elites (the top
        # quartile of the day's sales) keep theirs, and a redesign_explore
        # share draws uniformly so the box is never abandoned.
        self.design_pop = kwargs.pop("design_pop", None)
        self.redesign_days = int(kwargs.pop("redesign_days", 3))
        self.redesign_share = float(kwargs.pop("redesign_share", 0.5))
        self.redesign_explore = float(kwargs.pop("redesign_explore", 0.2))
        self._redesign_ct = 0
        self.demand = int(kwargs.pop("demand", 0))
        self.demand_day = float(kwargs.pop("demand_day", 500.0))
        self.shelf_life = float(kwargs.pop("shelf_life", 45.0))
        self.patience = float(kwargs.pop("patience", 15.0))
        self.stale_pen = float(kwargs.pop("stale_pen", 1.0))
        # r_rail: the azimuth ring rail's radius on the roof (Hashemi fig
        # 18: the A-frames' rollers run on a fixed ring around the tower),
        # g_orbit + 0.6 m by default; it must sit ON the roof - it cannot
        # overhang - so it is the binding footprint of a rail mount. A
        # central-post (trunnion) mount has no rail.
        self.r_rail = float(kwargs.pop("r_rail", float(g_orbit) + 0.6))
        self.design_rand = int(kwargs.pop("design_rand", 0))
        # site_rand: SAMPLE THE SITE on a cook run - the roof's orientation, the pit's size and
        # the neighbourhood's horizon per agent - while the kit stays the built machine. The
        # design obs columns are present (zero for the kit, 2u-1 for the site) so a policy can
        # read its site, and the design-table plumbing is shared with design_rand.
        self.site_rand = int(kwargs.pop("site_rand", 0))
        self.design_seed = int(kwargs.pop("design_seed", 1234))
        # roof_table: a JSON list of roof half-width quantiles [m] (0..1 in
        # equal steps) from building footprints; None = the placeholder
        rt = kwargs.pop("roof_table", None)
        # sections: the section library (tandoor_section_library.py) - the
        # membranes the sites allow, installed as surface blocks after the
        # built dish; the design's "section" knob picks them per agent
        self._sections_path = kwargs.pop("sections", None)
        self._seclib = None
        self._roof_q = None
        if rt:
            import json as _json
            with open(str(rt)) as fh:
                self._roof_q = np.asarray(_json.load(fh), dtype=np.float64)
        self.N_EXTRA_OBS += 2                          # the sand columns (hearth, floor)
        if self.demand:
            self.N_EXTRA_OBS += 2                      # the queue and the shelf
        if self.design_rand or self.site_rand:
            self.N_EXTRA_OBS += self.N_DESIGN + 2          # the design columns (site_rand: the kit's at the nominal, the site's drawn), then the horizon ahead
        # beta_cap_z: hard cap (meters) on the TOP OF THE DISH RIM.
        # beta becomes a per-step SCHEDULE: full beta_dev when the sun
        # is high, tapered exactly as much as the cap demands when it
        # is low (winter mornings). The slot lower bound (beam below
        # el_x) is always kept, so the dish stays uncut.
        bcz = kwargs.pop("beta_cap_z", None)
        self.beta_cap_z = None if bcz is None else float(bcz)
        self._ray_scale = 1.0
        self.gpu = bool(gpu)
        self._gpu = None
        self.fuse = bool(fuse)
        # n_rays trades Monte-Carlo noise per step against speed. The
        # power estimate's sigma ~ 1/sqrt(n); training averages it out
        # over thousands of steps, eval keeps full resolution.
        self.n_rays = int(n_rays)
        self.g_orbit = float(g_orbit)
        self.z_waist = None if z_waist is None else float(z_waist)
        self.z_m5 = float(z_m5)
        self.el_min_h = float(el_min)
        self.r_mast = float(r_mast)
        super().__init__(*args, a_mem=a_mem, **kwargs)
        self._apply_system_design()

    def _reset_state(self):
        super()._reset_state()
        B = self.num_agents
        el0, az0, _ = _sim.solar_position(self.lat, self.day,
                                          float(self.t_solar[0]))
        self.el_m = np.clip(el0 + self.rng.normal(0, 0.3, B),
                            self.el_min_h, self.el_max_h)
        self.az_m = np.degrees(az0 - self._ds_azs) + self.rng.normal(0, 0.3, B)   # the sun in each SITE's frame
        self._e_el = np.zeros(B)
        self._e_az = np.zeros(B)
        self._lost_ct = np.zeros(B, dtype=int)

    def _extra_obs(self):
        base = super()._extra_obs()
        # encoder readings of the pointing error, with sensor noise
        enc = np.stack([
            np.clip((self._e_el + self.rng.normal(0, 0.03,
                                                  self.num_agents)) / 0.5,
                    -self.enc_clamp, self.enc_clamp),
            np.clip((self._e_az + self.rng.normal(0, 0.03,
                                                  self.num_agents)) / 0.5,
                    -self.enc_clamp, self.enc_clamp)], axis=1)
        cols = [base, enc]
        if self.elbow_aim:
            from tandoor_polar_env import SPOT_PHI0, SPOT_Z0
            cols.append(np.stack(
                [(self.spot_phi - SPOT_PHI0) / 2.0,
                 (self.spot_z - SPOT_Z0) / 1.0], axis=1))
            # NB: the same expression the kernel uses, so the two paths agree. On the
            # three-mirror machine this is a monotone code for the M3 turn rather than
            # the literal slot - tri_aim_bin() gives the true slot for diagnostics.
            kb = (((self.spot_phi + np.pi) / (2 * np.pi)
                   * self.n_belt).astype(int)) % self.n_belt
            oh = np.zeros((self.num_agents, self.n_belt),
                          dtype=np.float64)
            oh[np.arange(self.num_agents), kb] = 1.0
            cols.append(oh)
        if getattr(self, "load_ctrl", 0):
            cols.append(self.has_bread.astype(np.float64))
        cols.append(self._sand_obs())                 # the two sand columns' mean temperature
        if self.demand:                                # the queue and the shelf
            cols.append(np.stack([np.clip(self.orders / 10.0, 0, 3), np.clip(self.shelf / 10.0, 0, 3)], 1))
        if getattr(self, "design_rand", 0) or getattr(self, "site_rand", 0):
            cols.append(self._design_obs)
            _el, _az, _ = _sim.solar_position(self.lat, self.day, float(self.t_solar[0]))
            cols.append(self._hz_obs(_az - self._ds_azs))           # the horizon ahead, in each site's frame
        return np.concatenate(cols, axis=1)

    def _sync_from_gpu(self):
        """The HUD's numpy mirrors of the device state (render mode on the
        megakernel path): every field the renderer or the time series
        reads, copied once per frame."""
        S = self._gpu
        if S is None:
            return
        for nm in ("T", "T_sub", "T_deep", "T_halo", "T_sand", "bread_E", "bread_t", "bread_C",
                   "p_act", "p_set", "p_dist", "shutter", "f_locked", "form_time", "decl_formed",
                   "load_timer", "ep_rotis", "ep_scorch", "ep_spall", "ep_return", "ep_len", "el_m", "az_m",
                   "cloud", "wind_g", "spot_phi", "spot_z", "dni", "wind", "day_rotis", "orders", "shelf", "sold", "soil"):
            v = getattr(S, nm, None)
            if v is not None:
                setattr(self, nm, v.detach().cpu().numpy().astype(np.float64) if v.dtype != torch.bool else v.detach().cpu().numpy())
        for nm, dst in (("jammed", "jammed"), ("stowed", "stowed"), ("has_bread", "has_bread")):
            v = getattr(S, nm, None)
            if v is not None:
                setattr(self, dst, v.detach().cpu().numpy() > 0.5)
        for nm, dst in (("lost_ct", "_lost_ct"), ("belt_prev", "_belt_prev"), ("hold_p", "_hold_p"), ("hold_s", "_hold_s"), ("hold_j", "_hold_j"), ("off", "bore")):
            v = getattr(S, nm, None)
            if v is not None:
                setattr(self, dst, v.detach().cpu().numpy())
        self._spot_view = (self.spot_phi, self.spot_z)

    def _render_trace(self):
        """Agent rays for the renderer from the torch twin of the trace
        (parity-verified against the megakernel that stepped the physics):
        the same membrane pressure and figure blur the kernel used, no
        random terms."""
        B = self.num_agents
        p_eff = np.where(self.jammed, self.f_locked, self.p_act)
        drift = np.abs(self._decl() - self.decl_formed)
        q_w = 0.6 * self.wind ** 2
        gain = np.where(self.jammed, self.jam_gain, 1.0)
        sig_wind = gain * 0.88e-3 * (np.maximum(q_w, 1e-9) / 15.0) ** 0.6
        sigma_b = np.sqrt(self.sig_static ** 2 + (2 * 0.35 * sig_wind) ** 2 + (np.radians(drift) * 0.04) ** 2)
        with torch.no_grad():
            self._trace_power(p_eff, sigma_b, self.bore, self.soil)     # fills _ladder and _hv while the sun is up
        el, _, _ = _sim.solar_position(self.lat, self.day, float(self.t_solar[0]))
        if not (self.el_min_h <= el <= self.el_max_h):
            self._hv = None; self._ladder = dict(shadow=0.0, slot=0.0, fold=0.0, tube=0.0, m5=0.0, duct=0.0, through=0.0)

    def step(self, actions):
        if self.gpu and self._metal is not None:
            # THE RENDERER RUNS THE MEGAKERNEL (user): the physics the cook
            # trained on; the rays it draws come from the torch twin once
            # a frame, the HUD from the synced device state
            obs, rew, infos = self._gpu_full_step(actions)
            self.observations[:] = obs.cpu().numpy()
            self.rewards[:] = rew.cpu().numpy()
            # the numpy wrapper is the eval/bench path: keep the host
            # mirrors its consumers read (the P-controller heuristic
            # reads _e_az/_e_el; probes read p_in). The trainer's
            # step_torch path skips these syncs.
            self._e_el = self._e_el_t.cpu().numpy()
            self._e_az = self._e_az_t.cpu().numpy()
            self.p_in = self._p_in_t.cpu().numpy()
            if getattr(self._gpu, "fused", False):
                self.truncations[:] = \
                    self._trunc_t.cpu().numpy() > 0.5
            rd = getattr(self, "reward_div", 1.0)
            if rd != 1.0:
                self.rewards[:] = self.rewards / rd
            if self.render_mode == "human":
                self._sync_from_gpu()
                self._render_trace()
            return (self.observations, self.rewards, self.terminals,
                    self.truncations, infos)
        B = self.num_agents
        a = np.asarray(actions).reshape(B, self.N_HEADS)
        if getattr(self, "load_ctrl", 0):
            # the base steps reshape actions to THEIR head counts -
            # the mask heads only exist here, so stash them for the
            # polar load block
            self._load_mask = a[:, -self.n_belt:]
        # -- the two motors, BEFORE the optics see the sun this step.
        # cmd 0..6 -> rate -1..+1 of full slew; backlash as rate noise.
        el0, az0, _ = _sim.solar_position(self.lat, self.day,
                                          float(self.t_solar[0]))
        az0 = np.degrees(az0 - self._ds_azs)               # per agent: the sun in the site's frame
        # potential BEFORE this step's motor action: the previous
        # step's pointing error. (The zero-noise trajectory harness
        # caught the original placement: pot_prev was computed AFTER the
        # motor update and pot_now after super().step() from the SAME
        # unchanged arrays - the shaping term had been identically zero
        # through every training run so far.)
        pot_prev = np.minimum(np.abs(self._e_az) + np.abs(self._e_el), 4.0)
        r_az = (np.clip(a[:, 3], 0, 6) - 3) / 3.0 * self.RATE_AZ * self._ds_rate
        r_el = (np.clip(a[:, 4], 0, 6) - 3) / 3.0 * self.RATE_EL * self._ds_rate
        if self.elbow_aim:
            from tandoor_polar_env import (SPOT_PHI_RANGE, SPOT_Z_RANGE,
                                           RATE_SPOT_PHI, RATE_SPOT_Z)
            r_ph = (np.clip(a[:, 5], 0, 6) - 3) / 3.0 * RATE_SPOT_PHI
            r_zz = (np.clip(a[:, 6], 0, 6) - 3) / 3.0 * RATE_SPOT_Z
            # the head's travel is the machine's: the elbow's +-110 deg on 'cass',
            # M3's own turn on 'tri' - PER AGENT, off the design table, since one
            # batch can hold both (it used to be an env-wide if self.tri).
            w_p = getattr(self, "_ds_phw", None)
            if w_p is None:
                w_p = self.aim_halfspan(self.tri)
            self.spot_phi = np.clip(
                self.spot_phi + np.radians(r_ph) * self.dt, _SP0 - w_p, _SP0 + w_p)
            self.spot_z = np.clip(self.spot_z + r_zz * self.dt,
                                  SPOT_Z_RANGE[0], SPOT_Z_RANGE[1])
            self._spot_view = (self.spot_phi, self.spot_z)
        self.az_m = self.az_m + r_az * self.dt \
            + self.rng.normal(0, 0.02, B)
        self.el_m = np.clip(self.el_m + r_el * self.dt
                            + self.rng.normal(0, 0.02, B),
                            self.el_min_h - 2.0, self.el_max_h + 1.0)
        # pointing error the optics will feel (az foreshortened)
        self._e_el = self.el_m - el0
        _daz = self.az_m - az0; _daz = _daz - 360.0 * np.round(_daz / 360.0)     # on the circle (site frame, wrapped sun)
        self._e_az = _daz * np.cos(np.radians(el0))
        t_before = float(self.t_solar[0])
        # potential-based tracking shaping, the same pattern as the
        # belt-rise term in the base reward: r += k (phi_prev - phi_now)
        # with phi = min(|e_az|+|e_el|, 4 deg). Policy-invariant (it
        # telescopes to phi_end - phi_start, bounded +-0.4/episode), so
        # it cannot be farmed - but it gives the motor heads the
        # per-step gradient the roti reward is too far downstream to
        # provide: measured at 14M steps of training, a random policy
        # loses the sun in ~4 steps, power stays 0, every episode
        # returns the same -172, and approx_kl sits at 0.000.
        out = super().step(a[:, :3])
        sun_up = el0 >= self.el_min_h                 # the evening: nothing to track
        pot_now = np.where(sun_up, np.minimum(np.abs(self._e_az) + np.abs(self._e_el), 4.0), pot_prev)
        wrapped = float(self.t_solar[0]) < t_before - 1.0
        if not wrapped:
            shape = 1.0 * (pot_prev - pot_now)
            self.rewards[:] += shape.astype(np.float32)
            self.ep_return += shape
        # EARLY EXIT, as most RL envs do: 40 consecutive steps (10 min)
        # with the sun lost is a dead rollout - the rest of the day
        # teaches nothing. The sun clock is shared by the batch, so the
        # episode is TRUNCATED in place: fresh pot, counters zeroed,
        # carriage re-acquired, sun left where it is. Bootstrapped via
        # truncations, not terminals.
        lost = sun_up & ((np.abs(self._e_az) + np.abs(self._e_el)) > self.lost_deg)
        self._lost_ct = np.where(lost, self._lost_ct + 1, 0)
        cut = self._lost_ct >= 40
        if cut.any() and not wrapped:
            from tandoor_mount_batch import solar_batch
            el1v, az1v, _ = solar_batch(
                torch.as_tensor(self.lat_v, dtype=torch.float32),
                torch.as_tensor(self.day_v, dtype=torch.float32),
                float(self.t_solar[0]), az_off=torch.as_tensor(self._ds_azs, dtype=torch.float32))
            el1v = el1v.numpy()
            az1v = np.degrees(az1v.numpy())
            for i in np.nonzero(cut)[0]:
                self.truncations[i] = True
                # CHARGE-AND-CRASH closed: the preheat shaping accrued
                # this episode (0.05 per K of belt rise below the band)
                # re-arms on the fresh cold pot, so a deliberate sun-loss
                # farms it (+15% measured). Give it back at the cut -
                # the potential telescopes to zero across the truncation.
                # exact potential of the wiped state + in-flight
                # load bonuses + accrued doneness (charge-and-crash
                # closed)
                phys_cut = bool(getattr(self, "night_carry", 0))
                # carry-over mode: a lost mount is a lost mount; the pot,
                # the sand, the halo and the loaves keep their physics,
                # nothing is refunded because nothing is wiped
                give = 0.0 if phys_cut else (
                    0.3 * float(self.has_bread[i].sum())
                    + 2.0 * float(np.clip(
                        self.bread_E[i] / self._ds_roti[i],
                        0.0, 1.0).sum())
                    + 0.05 * float(np.clip(
                        np.minimum(self.T[i, : self.n_belt],
                                   T_COOK_LO) - 350.0,
                        0, None).sum()))
                self.rewards[i] -= give + self.cut_penalty
                self.ep_return[i] -= give + self.cut_penalty
                if not phys_cut:
                    # always cold on lost-sun truncation (no warm lottery)
                    self.T[i] = 350.0
                    self.T[i] += self.rng.uniform(-15, 15, self.n_nodes)
                    self.T_sub[i] = self.T[i].copy()
                    self.T_deep[i] = self.T[i].copy()
                    self.T_sand[i] = self.T[i, self.n_belt:self.n_belt + 2, None]
                    self.T_halo[i] = 300.0
                    self.bread_t[i] = 0.0
                    self.bread_C[i] = 0.0    # fresh dough carries no char
                self.ep_rotis[i] = self.ep_scorch[i] = 0.0
                self.ep_spall[i] = 0.0
                self.ep_return[i] = self.ep_len[i] = 0.0
                if not phys_cut:
                    self.p_set[i] = self.p_act[i] = self.p0
                    self.has_bread[i] = False
                    self.bread_E[i] = 0.0
                self.el_m[i] = np.clip(el1v[i]
                                       + self.rng.normal(0, 0.3),
                                       self.el_min_h, self.el_max_h)
                self.az_m[i] = az1v[i] + self.rng.normal(0, 0.3)
                # clear the shaping potential to post-reset pointing
                self._e_el[i] = self.el_m[i] - el1v[i]
                self._e_az[i] = (self.az_m[i] - az1v[i]) \
                    * np.cos(np.radians(el1v[i]))
                self._belt_prev[i] = self.T[i, : self.n_belt].max()
            self._lost_ct[cut] = 0
            # obs were assembled inside super().step BEFORE these
            # resets: rebuild for the cut agents so a truncation step
            # returns the new episode's first obs, matching the base
            # env's own day-over convention (autoreset) and the GPU
            # path. Caught by the zero-noise trajectory harness.
            self.observations[cut] = self._obs()[cut]
        if wrapped:
            if getattr(self, "night_carry", 0) and not getattr(self, "consecutive_days", 1):
                # control: random day and latitude, pot carried, figure re-formed
                if self.day_random:
                    self.day_v[:] = self.rng.integers(1, 366, self.num_agents); self.day = int(self.day_v[0])
                if self.lat_random:
                    self.lat_v[:] = self.rng.uniform(15.0, 35.0, self.num_agents); self.lat = float(self.lat_v[0])
                self.decl_formed = 23.44 * np.sin(2.0 * np.pi * (284.0 + self.day_v) / 365.0)
            elif getattr(self, "night_carry", 0):
                # the pit carried the night: the next calendar day, same site
                self.day_v[:] = self.day_v % 365 + 1
                self.day = int(self.day_v[0])
                # the dawn routine: re-form by hand when the figure has drifted
                decl_t = 23.44 * np.sin(2.0 * np.pi * (284.0 + self.day_v) / 365.0)
                need = np.abs(decl_t - self.decl_formed) >= self.form_drift
                self.decl_formed = np.where(need, decl_t, self.decl_formed)
                self.form_time = np.where(need, float(self.form_min), self.form_time)
                self.rewards -= 0.02 * self.form_min * need
                self.ep_return -= 0.02 * self.form_min * need
            elif self.day_random or self.lat_random:
                if self.day_random:
                    self.day_v[:] = self.rng.integers(
                        1, 366, self.num_agents)
                    self.day = int(self.day_v[0])
                if self.lat_random:
                    self.lat_v[:] = self.rng.uniform(
                        15.0, 35.0, self.num_agents)
                    self.lat = float(self.lat_v[0])
            # the episode wrapped to the next morning: the crew reparks
            # the carriage overnight (hours of slack at full slew)
            el1, az1, _ = _sim.solar_position(self.lat, self.day,
                                              float(self.t_solar[0]))
            self.el_m = np.clip(el1 + self.rng.normal(0, 0.3, B),
                                self.el_min_h, self.el_max_h)
            self.az_m = np.degrees(az1 - self._ds_azs) + self.rng.normal(0, 0.3, B)
        rd = getattr(self, "reward_div", 1.0)
        if rd != 1.0:
            # trainer-facing channel only; ep_return/infos stay raw
            self.rewards[:] = self.rewards / rd
        return out

    # ------------------------------------------------------------ mount #
    def _cosine(self, decl_deg):
        """Square to the sun always: the mount's whole point."""
        return 1.0

    def _build_focus_chain(self):
        """Receiver-at-focus chain geometry (world frame: x north, the
        courtyard and pot at x < X_TOWER, the roof at x > X_TOWER).
        F = (X_TOWER_C, 0, z_fold) is the dish focus and M1's centre.
        M2: off-axis paraboloid, focus F, chief ray col_dist along e_exit,
        axis toward M3. M3: flat on the wall line at deck+0.3 turning the
        beam vertical. M4: off-axis paraboloid at the turn, focus = the
        built duct mouth. Packed into sc[106..138] for both cores."""
        F = np.array([self.X_TOWER_C, 0.0, self.z_fold])
        el_e = np.radians(self.exit_el)
        # nominal (east) exit for the static parts; the mount computes
        # the live e / M2 / leg / M3 normal per env each step
        e = np.array([0.0, np.cos(el_e), np.sin(el_e)])
        P2 = F + self.col_dist * e
        chi = np.radians(self.leg_tilt)
        t3 = (F[0] - float(X_TOWER)) / np.sin(chi)
        P3 = np.array([float(X_TOWER), 0.0, P2[2] - t3 * np.cos(chi)])
        A2 = P3 - P2
        A2 = A2 / np.linalg.norm(A2)
        f2 = 0.5 * self.col_dist * (1.0 - float(e @ A2))
        n3 = A2 + np.array([0.0, 0.0, 1.0])
        n3 = n3 / np.linalg.norm(n3)
        z_turn = float(Z_DUCT) if self.z_turn is None else float(self.z_turn)
        P4 = np.array([float(X_TOWER), 0.0, z_turn])
        F4 = np.array([float(R_POT), 0.0, float(Z_DUCT)])
        f4 = 0.5 * (np.linalg.norm(P4 - F4) - (P4[2] - F4[2]))
        # the strut: from the wall tower 1.5 m below M3 up to F, under
        # both collimated legs
        Ps = np.array([float(X_TOWER), 0.0, P3[2] - 1.5])
        self.e_exit, self.F_focus = e, F
        self.fc_P2, self.fc_A2, self.fc_f2 = P2, A2, float(f2)
        self.fc_P3, self.fc_n3, self.fc_P4, self.fc_F4 = P3, n3, P4, F4
        self.fc_f4, self.fc_Ps = float(f4), Ps
        self._fc_table = ([1.0] + list(Ps) + [self.r_m1] + list(P2) + list(A2)
                          + [float(f2), self.col_radius] + list(P3) + list(n3)
                          + [self.r_m3, self.r_bore] + list(P4) + list(F4)
                          + [float(f4), self.r_m4, self.r_strut, float(P4[2]),
                             float(X_TOWER), 0.0])
        assert len(self._fc_table) == 33

    def _night_cool_torch(self, S):
        """Yesterday's pot through the night: the day's lumped wall model
        (face nodes, substrate, deep clay, soil halo; radiative exchange
        in the cavity; lidded mouth) with no sun and no bread, explicit
        Euler at dt_night for night_hours. Twin of the numpy
        _night_cool_np in tandoor_polar_env."""
        from tandoor_rl_env import SIGMA, T_AMB
        from tandoor_polar_env import R_MOUTH
        n = int(round(self.night_hours * 3600.0 / self.dt_night))
        dt = float(self.dt_night)
        dev = S.T.device
        def tt(x):
            return torch.as_tensor(np.asarray(x, dtype=np.float32), device=dev)
        # the wall parameters live on the env (FusedState packs them into
        # the kernel's sp block; GpuState mirrors them) - read the env's
        area, cap = tt(self.node_area), tt(self._ds_hc)
        g01, g12, g2s = tt(self._ds_g01), tt(self._ds_g12), tt(self._ds_g2s)
        cs, cd = tt(self._ds_cs), tt(self._ds_cd)
        ch = float(np.asarray(self.c_halo, dtype=np.float64).mean())
        gout = float(np.asarray(self.g_halo_out, dtype=np.float64).mean())
        asum = area.sum()
        mouth = tt(np.pi * R_MOUTH ** 2 * self._ds_lid)
        T, Ts, Td, Th = S.T, S.T_sub, S.T_deep, S.T_halo
        Tc = S.T_sand.clone()
        k_ap = self.n_belt + 2
        for _ in range(n):
            t4 = T ** 4
            tcav4 = (area * t4).sum(1, keepdim=True) / asum
            q = 0.85 * SIGMA * area * (tcav4 - t4)
            q01 = g01 * (T - Ts)
            q12 = g12 * (Ts - Td)
            q2s = g2s * (Td - Th[:, None])
            Tc, q_bed, q_bot, bed = self._sand_step_t(T, Tc, Th, dt)
            for j in (self.n_belt, self.n_belt + 1):
                q01[:, j] = torch.where(bed, torch.zeros_like(q01[:, j]), q01[:, j])
                q12[:, j] = torch.where(bed, torch.zeros_like(q12[:, j]), q12[:, j])
                q2s[:, j] = torch.where(bed, torch.zeros_like(q2s[:, j]), q2s[:, j])
            q = q - q01
            q[:, self.n_belt:self.n_belt + 2] = q[:, self.n_belt:self.n_belt + 2] - q_bed
            q[:, k_ap] = q[:, k_ap] - 0.75 * SIGMA * (tcav4[:, 0] - T_AMB ** 4) * mouth
            T = T + q * dt / cap
            Ts = Ts + (q01 - q12) * dt / cs
            Td = Td + (q12 - q2s) * dt / cd
            Th = Th + (q2s.sum(1) + q_bot - gout * (Th - T_AMB)) * dt / ch
        # in place: FusedState fields are views into the packed state
        S.T.copy_(T)
        S.T_sub.copy_(Ts)
        S.T_deep.copy_(Td)
        S.T_halo.copy_(Th)
        S.T_sand.copy_(Tc)

    #: the M3 turn, as the angle the mirror is rotated about the vertical through its
    #: vertex - the bore's own axis, so the incoming cone is unchanged by it
    M3_TURN = (-0.55, 0.55)          # rad; +-31 deg reaches four loaves (measured)

    def aim_halfspan(self, tri):
        """Half-travel of the aim head about SPOT_PHI0 [rad]. Both machines steer
        with the same joystick column, but it drives different hardware: on 'cass'
        the concave elbow at the duct mouth (+-110 deg of spot azimuth on the pot
        wall), on 'tri' the M3 turn itself (+-31 deg, and the inlet collar is what
        caps it). Per agent since 2026-09-08 - it reaches the kernels as the design
        table's phw column, not as a scalar in the step params."""
        from tandoor_polar_env import SPOT_PHI_RANGE as _SPR
        w_tri = 0.5 * (self.M3_TURN[1] - self.M3_TURN[0])
        w_cass = 0.5 * (_SPR[1] - _SPR[0])
        return float(np.where(np.asarray(tri, dtype=bool), w_tri, w_cass)) \
            if np.ndim(tri) == 0 else np.where(np.asarray(tri, dtype=bool), w_tri, w_cass)

    def tri_target(self, psi=0.0, pot=None):
        """The world point M3 aims at: a loaf on the bake row, turned psi about the
        vertical through M3's vertex. psi = 0 is the loaf straight across the pot.
        pot = (R_SPH, Z_CPOT, R_DUCT_WALL) of THIS agent's pit; None = self._pot_cur, which
        _rows_from_u sets per agent while it builds each chain (default: the nominal pit)."""
        from tandoor_polar_env import (R_SPH as _RS0, Z_CPOT as _ZC0, Z_CROWN as _ZCR,
                                       Z_BAKE_LO as _ZBL, R_DUCT_WALL as _RDW0)
        _cur = pot if pot is not None else getattr(self, "_pot_cur", None)
        _RS, _ZC, _RDW = _cur if _cur is not None else (_RS0, _ZC0, _RDW0)
        zb = 0.5 * (_ZBL + _ZCR)
        rb = float(np.sqrt(max(_RS ** 2 - (zb - _ZC) ** 2, 1e-6)))
        # _bin_pot stitches the frames at the mouth: pot x = world y, pot y = -world x,
        # pot z = world z - H_POT, with the pot's axis at world x = R_POT - R_DUCT_WALL
        T0 = np.array([-rb + float(R_POT) - float(_RDW), 0.0, zb + float(H_POT)])
        P4 = np.array([float(X_TOWER) if self.x_turn is None else float(self.x_turn), 0.0,
                       float(Z_DUCT) if self.z_turn is None else float(self.z_turn)])
        c, s_ = np.cos(psi), np.sin(psi)
        d = T0 - P4
        return P4 + np.array([c * d[0] - s_ * d[1], s_ * d[0] + c * d[1], d[2]])

    def _m3_figure(self, psi):
        """M3's ellipsoid (Oe, Ae) rotated psi about the vertical through its vertex -
        a rigid turn of the mirror, so a_e and c_e are the figure it was cut with."""
        P4 = np.asarray(self.cs_P4, dtype=np.float64)
        c, s_ = np.cos(psi), np.sin(psi)
        R = np.array([[c, -s_, 0.0], [s_, c, 0.0], [0.0, 0.0, 1.0]])
        return P4 + (np.asarray(self._m3_Oe0) - P4) @ R.T, np.asarray(self._m3_Ae0) @ R.T

    def _build_cass_chain(self):
        """Cassegrain chain geometry. F = (X_TOWER_C, 0, z_fold). M4 is a
        flat at P4 = (X_TOWER, 0, z_turn) folding the bore axis (F -> P4)
        into the duct toward F4 = (R_POT, 0, Z_DUCT); the hyperboloid's
        second focus F2 is the mirror image of F4 in M4, i.e. P4 plus the
        bore direction times |F4 - P4|. Strip: the F sheet at d_strip
        from F (a = c - d_strip). Packed into sc[106..138]."""
        F = np.array([self.X_TOWER_C, 0.0, self.z_fold])
        z_turn = float(Z_DUCT) if self.z_turn is None else float(self.z_turn)
        P4 = np.array([float(X_TOWER) if self.x_turn is None else float(self.x_turn), 0.0, z_turn])
        # 'cass': M3 images onto the pot's inlet and an elbow re-images that onto the
        # wall. 'tri': M3 images onto the BREAD, so its second focus is the loaf and
        # the beam only passes the inlet on the way (the aperture that gates it).
        F4 = self.tri_target(0.0) if self.tri else np.array([float(R_POT), 0.0, float(Z_DUCT)])
        A_in = P4 - F
        A_in = A_in / np.linalg.norm(A_in)
        L_out = np.linalg.norm(F4 - P4)
        A_out = (F4 - P4) / L_out
        if self.m4_mode == "field":
            # image ON M4: hyperboloid foci (F, P4); M4 ellipsoid foci (F, F4)
            F2 = P4.copy()
            Oe = 0.5 * (F + F4)
            c_e = 0.5 * np.linalg.norm(F4 - F)
            Ae = (F4 - F) / (2.0 * c_e)
            a_e = 0.5 * (np.linalg.norm(P4 - F) + L_out)
            n4 = (F - P4) / np.linalg.norm(F - P4) + A_out
            n4 = n4 / np.linalg.norm(n4)
        elif self.u_f2 > 0.0:
            # F2 sits u_f2 before M4 up the bore; M4 is the ellipsoid patch
            # with foci F2 and the duct mouth F4 through P4 (demagnification
            # L_out / u_f2 of the F2 image)
            F2 = P4 - A_in * self.u_f2
            Oe = 0.5 * (F2 + F4)
            c_e = 0.5 * np.linalg.norm(F4 - F2)
            Ae = (F4 - F2) / (2.0 * c_e)
            a_e = 0.5 * (np.linalg.norm(P4 - F2) + L_out)
            n4 = (F2 - P4) / np.linalg.norm(F2 - P4) + (F4 - P4) / L_out
            n4 = n4 / np.linalg.norm(n4)
        else:
            # u_f2 = 0: M4 is a FLAT at the turn; F2 is the mirror image of
            # the duct mouth in it, so the strip images F straight onto the
            # mouth (a_e = 0 flags the flat to the cores; Oe/Ae carry n4)
            F2 = P4 + A_in * L_out
            n4 = A_out - A_in
            n4 = n4 / np.linalg.norm(n4)
            Oe, Ae, a_e, c_e = P4.copy(), n4.copy(), 0.0, 0.0
        c_h = 0.5 * np.linalg.norm(F2 - F)
        O = 0.5 * (F + F2)
        A = (F2 - F) / (2.0 * c_h)
        if self.sec_side == "cass":
            a_h = c_h - self.d_strip          # hyperboloid, F sheet d before F
            assert a_h > 0.0, "d_strip must be < the focal separation"
        else:
            a_h = c_h + self.d_strip          # ellipsoid, near vertex d beyond F
        # the F post: a horizontal arm from a north tower arm_north
        # beyond F (out of the bore, above the dish at low sun)
        Ps = np.array([self.X_TOWER_C + self.arm_north, 0.0, self.z_fold])
        self.F_focus, self.cs_F2, self.cs_O, self.cs_A = F, F2, O, A
        self.cs_a, self.cs_c, self.cs_P4, self.cs_n4, self.cs_F4 = float(a_h), float(c_h), P4, n4, F4
        self.cs_Ps = Ps
        self.cs_mag = float((2.0 * c_h - self.d_strip) / self.d_strip)
        # a flat M4 (u_f2 = 0) neither magnifies nor demagnifies
        self.cs_demag = float(L_out / self.u_f2) if self.u_f2 > 0.0 else 1.0
        self.cs_Oe, self.cs_Ae, self.cs_ae, self.cs_ce = Oe, Ae, float(a_e), float(c_e)
        self._m3_Oe0, self._m3_Ae0 = np.asarray(Oe, dtype=np.float64), np.asarray(Ae, dtype=np.float64)
        self._fc_table = ([2.0 if self.sec_side == "cass" else 3.0, self.arm_north, self.r_strip, self.d_strip, float(a_h), float(c_h)]
                          + list(O) + list(A)
                          + [np.radians(self.strip_th_lo), np.radians(self.strip_th_hi), self.w_strip]
                          + list(P4) + list(F4) + list(Oe) + list(Ae) + [float(a_e), float(c_e)]
                          + [self.r_m4, self.r_bore, self.r_strut, float(self.f_nom), float(self.a_mem),
                             float(self.z_deck), self.r_hole, self.w_slot,
                             self.strip_wk, np.radians(self.slot_el)])
        assert len(self._fc_table) == 39

    def _build_optics(self):
        # coude's own _build_optics would build its lookup table; we want
        # only the polar scaffolding underneath it (cfg, thermal hooks).
        TandoorPolarEnv._build_optics(self)
        cfg, dev = self.cfg, self.device
        cfg.a = self.a_mem
        a, g = float(cfg.a), self.g_orbit
        # the machine's footprint on the roof: the dish sweep g + a (the
        # design run scales both with the dish) and the ring rail
        self.sweep0 = float(g + a)
        self.g_orbit0 = float(g)       # the nominal orbit (the row builder scales g per agent)

        # -- the mount solve, all of it geometric:
        # NO tracking ceiling: Hashemi's fig-12 SLOT. The dish carries a
        # radial cut so the focal post passes through it at high sun -
        # the paper's own mechanism (his g ~ a, the post crosses daily).
        # The slot must also pass the DESCENDING beam, so the waist is
        # placed inside the dish-crossing height band and sheathed in a
        # short sealed tube on the post: the slot then only clears the
        # tube, not the open beam.
        self.el_max_h = 88.0
        # fold height: the ENTIRE machine stands on the roof (Hashemi's
        # fig 18 - ring rail, beam, A-frames, dish sweep, all on the
        # deck, parapet as the fence; nothing ground-standing). So the
        # dish's under-swing (g sin el + a cos el below the fold) must
        # clear the ROOF DECK at every tracked el, not the courtyard -
        # which raises the fold by the storey height and is the real
        # price of the rooftop siting.
        els = np.radians(np.linspace(self.el_min_h, self.el_max_h, 300))
        under = float((g * np.sin(els) + a * np.cos(els)).max())
        self.z_deck = Z_ROOF if self.deck_h is None else H_POT + float(self.deck_h)
        self.z_fold = self.z_deck + 0.35 + under
        # dish-crossing band: the dish plane crosses the post axis for
        # el > acos(a/g); the waist sits at its centre, tube around it
        el_x = np.degrees(np.arccos(np.clip(a / g, 0, 1)))
        if (self.receiver == "focus" or self._cass):
            el_x = 89.0        # the strut is beside the dish: no crossing, no slot bound
        self.el_x = float(el_x)
        # SLOTLESS: with beta_dev >= el_max - el_x the beam elevation
        # never reaches the crossing condition - the dish NEVER
        # intersects the post, so the physical dish needs no slot cut
        # at all (an uncut, stiffer membrane; flaps hardware deleted).
        if self.gpu and self.duct_nozzle == 1:
            raise ValueError("duct_nozzle=1 is cpu-path only; the "
                             "kernel implements mode 2 (concave)")
        self.slotless = (self.beta_dev >= (self.el_max_h - el_x)
            or self.beta_cap_z is not None or (self.receiver == "focus" or self._cass))
        if self.slotless:
            print(f"  [hashemi] SLOTLESS: beta_dev {self.beta_dev:.0f}"
                  f" deg keeps beam el <= {self.el_max_h - self.beta_dev:.0f}"
                  f" < el_x {el_x:.0f} - dish never crosses the post;"
                  f" build the dish UNCUT")
        z_x = [self.z_fold - g * np.sin(np.radians(e))
               for e in (el_x, self.el_max_h)]
        self.z_tube = (min(z_x) - 0.20, max(z_x) + 0.20)
        # the WAIST need not sit at the band centre: the slot only needs
        # the beam narrow OVER THE BAND, and it is narrow within ~1.5 m
        # of the waist either side. Raising z_w shortens the fold's
        # lever delta = z_fold - z_w, and obstruction = (delta/f)^2 -
        # this is the direct answer to "the secondary is pretty shit".
        # z_waist=None keeps the old band-centre behaviour.
        if (self.receiver == "focus" or self._cass):
            self.z_waist = self.z_fold - 0.05     # M1 sits AT the focus
        elif self.z_waist is None or self.z_waist <= 0:
            self.z_waist = 0.5 * (z_x[0] + z_x[1])
        delta = self.z_fold - self.z_waist
        f_design = g + delta

        # -- membrane pressure tuned to HASHEMI'S OWN GEOMETRY: the
        # paper builds everything on a SPHERE of radius R with its focal
        # circle at R/2, and the pressurised membrane's natural figure
        # is measurably nearer a sphere than a paraboloid (2.62 vs 2.76
        # mrad slope error, fixed_focus_sphere.py). So the target is the
        # best-fit SPHERE radius R = 2 f_design, not the parabolic f_fit
        # - the membrane is asked to be what it already wants to be.
        def _sphere_R(m):
            r_ = m["r"].numpy(); z_ = m["s"].numpy()
            keep = r_ <= cfg.a * 0.98
            r_, z_ = r_[keep], z_[keep] - z_[keep][0]
            Rs = np.linspace(1.2 * f_design, 3.2 * f_design, 400)
            mse = [np.mean((z_ - (R - np.sqrt(
                np.clip(R * R - r_ * r_, 1e-9, None)))) ** 2) for R in Rs]
            return float(Rs[int(np.argmin(mse))])
        # MEASURED: targeting the sphere radius directly drops duct
        # throughput 37% -> 28%, because a sphere's paraxial focus is
        # not its best focus at f/2.3 - the waist smears axially into
        # the tube walls. The parabolic f_fit IS the best-focus
        # estimator, so the pressure tracks it; the membrane still IS
        # the R = 2f sphere's section to ~2.6 mrad, reported below.
        # bracket to f/D ~0.7: at f 4.0 the membrane needs ~1250 Pa and
        # the old 0.4 cap (1235 Pa) left it unfocused on the fold
        K_z = int(getattr(self, "n_zones", 1) or 1)
        if self.zone_c != 0.0 and K_z > 1:
            _edges = np.linspace(0.0, a, K_z + 1)
            _rc = 0.5 * (_edges[:-1] + _edges[1:])
            _shape = 1.0 - self.zone_c * (_rc / a) ** 2

            def _solve(p, n=400):
                return _sim.solve_membrane(cfg, p * _shape, n=n,
                                           zone_edges=_edges)
        else:
            def _solve(p, n=400):
                return _sim.solve_membrane(cfg, p, n=n)
        self._solve_membrane = _solve
        lo, hi = cfg.T_pre / (4 * f_design), cfg.T_pre / (0.25 * f_design)
        if self.zone_c != 0.0 and K_z > 1:
            hi = hi * 3.0          # zoned law needs ~2.5x the uniform p0
        for _ in range(22):
            mid = 0.5 * (lo + hi)
            m = _solve(mid)
            if m["z0"] + m["f_fit"] > f_design:
                lo = mid
            else:
                hi = mid
        self.p0 = float(0.5 * (lo + hi))
        self.R_sphere = _sphere_R(_solve(self.p0))
        cfg.dp = self.p0
        self.level_frac = np.array(self.LEVEL_FRAC)   # coude's wide dump
        mems = [_solve(self.p0 * fr) for fr in self.level_frac]
        self._mem0 = mems[4]
        self.f_nom = float(mems[4]["z0"] + mems[4]["f_fit"])
        self.X_TOWER_C = float(X_TOWER) + (
            self.post_offset if (self.receiver == "focus" or self._cass) else 0.0)

        # -- apertures, from the beam itself
        self.r_fold = a * delta / self.f_nom * 1.08 + 0.06
        if self.receiver == "focus":
            self.r_fold = self.r_m1
        if self._cass:
            self.r_fold = self.r_strip
            self.r_m1 = 0.5            # ladder gate: rad1 is 0/1 for cass
        self.obstruction = (self.r_fold / a) ** 2
        if self.receiver == "focus":
            self.obstruction += (self.col_radius / a) ** 2
        # tube inner radius passes 3 sigma of the waist; post below it
        # tube radius from the measured tube-vs-slot trade (the two are
        # coupled: the slot must clear the tube). Swept at windy blur:
        #   r_in 0.20: slot  9% tube 24% -> through 33.5%
        #   r_in 0.32: slot 12% tube  4% -> through 45.1%   <- optimum
        #   r_in 0.50: slot 17% tube  0% -> through 43.9%
        # The static-only 3-sigma sizing (0.20) was starving the machine.
        geo_band = max(abs(z - self.z_waist) for z in self.z_tube) \
            * a / f_design
        self.r_tube_in = geo_band + 0.235
        self.r_tube = self.r_tube_in + 0.04
        self.r_post = 0.15
        # the slot: radial cut from r0 to the rim, wide enough for the
        # tube; loss printed, enforced ray-exactly in the trace
        self.slot_r0 = 0.28
        self.slot_w2 = self.r_tube + 0.06
        self.slot_loss = 2 * self.slot_w2 * (a - self.slot_r0) \
            / (np.pi * a * a)
        self.r_m5 = ((a / self.f_nom) * (self.z_waist - self.z_m5)
                     + 0.10) * self.m5_scale

        # -- M5's ellipsoid: foci at the waist and the duct centre; sized
        # so its lower surface passes through the wall base at z_m5
        # local foci only - NOT stored on self: self.T is the
        # temperature state array and self.W would shadow nothing but
        # the collision cost a debugging session once
        fW = np.array([X_TOWER, 0.0, self.z_waist])
        # the duct mouth is BUILT at [R_POT, 0, Z_DUCT] - the real
        # pit's axis sits R_DUCT_WALL behind it (x = R_POT -
        # R_DUCT_WALL = -0.79), which is the strike code's frame;
        # the optics aim at the built mouth, unchanged
        fT = np.array([R_POT, 0.0, Z_DUCT])
        V0 = np.array([X_TOWER, 0.0, self.z_m5])
        A2 = np.linalg.norm(V0 - fW) + np.linalg.norm(V0 - fT)
        self.ell_A = 0.5 * A2
        cc = 0.5 * np.linalg.norm(fT - fW)
        self.ell_B2 = self.ell_A ** 2 - cc ** 2
        self.ell_ctr = 0.5 * (fW + fT)
        w = (fT - fW) / np.linalg.norm(fT - fW)
        e1 = np.cross(w, [0.0, 1.0, 0.0]); e1 /= np.linalg.norm(e1)
        e2 = np.cross(w, e1)
        self.ell_M = torch.tensor(np.stack([e1, e2, w]),
                                  dtype=torch.float32, device=dev)
        self.ell_S = torch.tensor(
            [1 / self.ell_B2, 1 / self.ell_B2, 1 / self.ell_A ** 2],
            dtype=torch.float32, device=dev)
        self.ell_ctr_t = torch.tensor(self.ell_ctr, dtype=torch.float32,
                                      device=dev)

        # -- ray set + ARTIST primary
        NR = self.n_rays
        # FIBONACCI-SPIRAL aperture sampling. A random draw fixed at
        # build time is a BIAS at small N, not a variance: 16 unlucky
        # points scored 306 rotis where 8 lucky ones scored 416. The
        # golden-angle spiral covers the annulus uniformly at any N, so
        # the ray count buys only Monte-Carlo smoothness, never
        # coverage.
        k = np.arange(NR) + 0.5
        rr = np.sqrt((0.05 * a) ** 2
                     + ((0.985 * a) ** 2 - (0.05 * a) ** 2) * k / NR)
        th = k * np.pi * (3.0 - np.sqrt(5.0))
        self._hx, self._hy = rr * np.cos(th), rr * np.sin(th)
        self.primary = AO.MembranePrimary(
            _sim, cfg, mems, self._hx, self._hy, dev,
            tag=f"hashemi2_{a:.2f}g{g:.1f}w{self.z_waist:.1f}",
            csr_frac=self.csr_frac)
        # circular on-axis rim: no off-axis astigmatism term
        self.sigma_offaxis = 0.0
        self.sig_static = float(np.sqrt((2 * 2.0e-3) ** 2
                                        + (2 * self.sigma_print) ** 2))
        # film 0.88 w/ rim thinning, fold 0.95, M5 0.95, duct lip 0.96
        if self.silvered:
            self._loss_chain = 0.94 * 0.97 * 0.96 * 0.97
        else:
            self._loss_chain = 0.88 * 0.95 * 0.95 * 0.96
        if self.receiver == "focus":
            # film x M1 x M2 x M3 x M4 x duct lip: four mirrors, no tube
            self._loss_chain = ((0.94 * 0.96 ** 4 * 0.97) if self.silvered
                                else (0.88 * 0.95 ** 4 * 0.96))
            self._build_focus_chain()
        if self._cass:
            # film x strip x M4 x duct lip: two mirrors, straight bore
            self._loss_chain = ((0.94 * 0.96 ** 2 * 0.97) if self.silvered
                                else (0.88 * 0.95 ** 2 * 0.96))
            self._build_cass_chain()
        rho_r = 1.0 - 0.10 * (rr / a) ** 4
        cell = np.pi * (a ** 2) * (1 - 0.05 ** 2) / NR
        # beta's cosine tax cos(beta_t/2) is charged PER STEP via
        # self._ray_scale (set in the mount solve): with the beta
        # SCHEDULE the tilt varies over the day, so it cannot live in
        # this static tensor. The retro orbit (beta 0) pays nothing.
        self._ray_pw = torch.tensor(cell * rho_r * self._loss_chain,
                                    dtype=torch.float32, device=dev)
        self._env_off = (torch.arange(self.num_agents, device=dev)
                         * self.n_nodes).repeat_interleave(NR)
        # static geometry tensors, built ONCE (they were rebuilt every
        # step); and the fused trace core - the same _geo_core function
        # either eager or torch.compile'd, so the fallback is exact
        # membrane surfaces as (L,P,3) buffers for the fused bounce;
        # the constant rotation taking ARTIST's canonical ray onto the
        # local nominal (0,0,-1); a persistent device generator so no
        # step ever reseeds (the manual_seed stall)
        self._pts_l = self.primary.membrane.points[..., :3].contiguous()
        self._nrm_l = self.primary.membrane.normals[..., :3].contiguous()
        self._Acan = torch.tensor(
            _align_np([0.0, 1.0, 0.0], [0.0, 0.0, -1.0]),
            dtype=torch.float32, device=dev)
        self._gen = torch.Generator(device=dev.type)
        self._gen.manual_seed(int(self.rng.integers(2 ** 31)))
        self._V0t = torch.tensor([X_TOWER, 0.0, self.z_m5],
                                 dtype=torch.float32, device=dev)
        z1_t, z0_t = self.z_tube[1], self.z_tube[0]
        # THE CPC LIP, done honestly: a compound parabolic concentrator
        # is NOT a cone - it is the tilted-parabola Winston profile
        # (each meridional arc is a parabola whose focus sits on the
        # OPPOSITE edge of the throat, axis tilted by the acceptance
        # half-angle), truncated to the 0.60 m the pipe allows. Solve
        # the acceptance angle so the truncated profile meets the
        # built entry radius, then trace it as 8 conical segments
        # (closed-form intersections; the sag of a segment vs the true
        # curve is < 1 mm).
        self._cpc_knots = self._solve_cpc(self.r_tube_in, 0.55, 0.60,
                                          n_seg=8)
        cpc_flat = []
        dzseg = 0.60 / 8
        for k in range(8):
            r0k = self._cpc_knots[k][1]
            mk = (self._cpc_knots[k+1][1] - r0k) / dzseg
            cpc_flat += [r0k, mk]
        # THE SUN, actually: a Gaussian is not a star. The Buie
        # sunshape - limb-darkened 4.65 mrad disk, power-law
        # circumsolar tail parameterized by the CSR - sampled exactly
        # through a 65-knot inverse-CDF table both kernels share.
        # (DNI already comes from the Meinel clear-sky airmass model;
        # this fixes the sun's SHAPE, the remaining approximation.)
        chi = max(float(self.csr_frac), 0.01)
        _gam = 2.2 * np.log(0.52 * chi) * chi ** 0.43 - 0.1
        _kap = 0.9 * np.log(13.5 * chi) * chi ** (-0.3)
        _th = np.linspace(1e-4, 43.6, 6000)          # mrad
        _phi = np.where(_th <= 4.65,
                        np.cos(0.326 * _th) / np.cos(0.308 * _th),
                        np.exp(_kap) * _th ** _gam)
        _cdf = np.cumsum(_phi * _th)
        _cdf = _cdf / _cdf[-1]
        _uu = np.linspace(0.0, 1.0, 65)
        self._sun_table = np.interp(_uu, _cdf, _th) * 1e-3   # radians
        self._sc_base = torch.tensor(
            [self.r_fold, self.slot_r0, self.slot_w2, z1_t, z0_t,
             z1_t + 0.60, (0.97 if self.silvered else 0.95),
             self.r_tube_in, self.r_m5, self.z_m5,
             X_TOWER, Z_DUCT, R_POT, self.r_duct,
             0.0,                                   # cosi, set per step
             -(1.12 * self.r_m5 - self.r_tube_in) / (z0_t - self.z_m5),
             Z_ROOF, self.z_fold - 0.10, self.r_post, self.r_tube,
             self.csr_frac, 15e-3] + cpc_flat
            + list(self._sun_table)
            + [0.0, 0.0, float(self.duct_nozzle)]
            + (self._fc_table if (self.receiver == "focus" or self._cass) else [0.0] * 33),   # cass/tri: 39
            dtype=torch.float32, device=dev)
        self._sc1_base = float(self._sc_base[1])
        prm = np.zeros(49, dtype=np.float32)
        prm[48] = 1.0 if self._cass else 0.0   # mount row 2 = dish axis
        if self.receiver == "focus":
            prm[42] = 1.0
            prm[43] = np.radians(self.exit_el)
            prm[44] = self.col_dist
            prm[45:48] = self.fc_P3
        prm[1] = self.beta_dev
        prm[2] = 1e9 if self.beta_cap_z is None else self.beta_cap_z
        prm[3] = self.a_mem
        prm[4] = self.z_fold
        prm[5] = self.g_orbit
        prm[6] = self.el_x
        prm[7] = 1.0 if self.slotless else 0.0
        prm[8] = 1.0 if self.slot_flaps else 0.0
        prm[9] = float(self.X_TOWER_C)
        prm[10] = self._sc1_base
        prm[11] = float(self.fold_toroid)
        prm[12] = self.f_nom
        prm[13] = self.z_waist
        prm[14:22] = self._SHADOW_B
        prm[22:30] = self._SHADOW_F
        prm[30:35] = self._SHADOW_BN
        prm[35:40] = self._SHADOW_FN
        prm[40] = self.el_min_h
        prm[41] = self.el_max_h
        self._mnt_prm = torch.tensor(prm, device=dev)
        self._finish_trace_build(a, g, f_design)
        if self._cass and getattr(self, "design_rand", 0):
            self._build_zone1_block(a, f_design)
        if self._sections_path:
            self._load_section_library(str(self._sections_path))
        elif getattr(self, "_extra_blocks", None):
            self.install_sections(list(self._extra_blocks))
        self._build_design_table()

    # ------------------------------------------------------ design #
    #: the design box (name, lo, hi) sampled per agent by design_rand
    DESIGN_BOX = (("d_strip", 0.4, 1.2), ("u_f2", 2.0, 6.0),
                  ("r_m4", 0.6, 1.6), ("r_bore", 0.5, 1.2),
                  ("w_slot", 0.4, 1.0), ("r_hole", 0.3, 0.8),
                  ("strip_th_hi", 70.0, 125.0), ("strip_wk", 0.8, 1.8),
                  ("r_duct", 0.15, 0.90))     # the inlet: charged as an aperture since 2026-09-07, and on 'tri' the beam itself passes it (the collar caps the M3 turn's span: +-25 deg at 0.40, +-45 at 0.90)
    #: THE SYSTEM IS THE DESIGN: the rest of the machine, per agent
    #: (name, lo, hi): dish scale (radius, focal length and orbit scale
    #: together; mirror area ~ s^2), tower deck height (fold height and
    #: the receiver's F follow), actuator class (slew-rate scale), wall
    #: insulation (wall->soil conductance scale, 1 = the ini's shell),
    #: thermal mass (node capacity scale), lid leak, roti size, loaves
    #: per lean
    #: THE SITE COMES FIRST: every tandoor has its own roof, most of them
    #: small. roof_r is the roof's usable half-width (m) drawn from a
    #: quantile table (Open Buildings footprints around Quetta when the
    #: table is given, a log-uniform 3-12 m placeholder otherwise); the
    #: dish is the largest that fits, s = roof_r / (g_orbit + a_mem) of
    #: the nominal machine, clipped to [S_LO, S_HI]. The obs column is
    #: the roof percentile.
    S_LO, S_HI = 0.35, 1.30
    RAIL_MARGIN = 0.6          # ring rail radius = g_orbit x s + margin [m]
    ROOF_DEFAULT = (1.5, 12.0)  # log-uniform placeholder half-width [m]
    #: VERTICAL SPACE: a tiny roof can still carry a dish by going up -
    #: above DECK_CLEAR the sweep may overhang the parapet (neighbouring
    #: roofs and the street below it), OVERHANG_PER_M of reach per metre
    #: of deck above the clearance, at most OVERHANG_MAX (structure and
    #: wind). Assumption, to be replaced by a real setback rule.
    DECK_CLEAR, OVERHANG_PER_M, OVERHANG_MAX = 3.0, 1.0, 3.5
    #: mount_post: the mount class - u < 0.5 a ring-rail mount (the rail
    #: must sit on the roof: s <= (roof_r - margin) / g_orbit), u >= 0.5
    #: a central-post trunnion mount (no rail; only the dish sweep, which
    #: may overhang above the parapet, limits the dish)
    #: THE RETROFIT (user, 2026-09-06): existing firebrick tandoors get a
    #: collector kit. Site variables (not for sale): roof_r, cap_scale
    #: (the pit's wall thickness, 0.7-1.5 of the model's firebrick pit).
    #: Kit variables: deck, mount class, actuator class, ins_scale (a
    #: ceramic-fibre / aerogel lining: 1.0 = the bare firebrick pit,
    #: 0.3 = heavy high-tech insulation, priced per m2 of pit), lid,
    #: and the cook's roti size and loaves per lean.
    SYS_BOX = (("roof_r", 0.0, 1.0), ("deck_h", 3.0, 8.0),
               ("rate_scale", 0.5, 2.0), ("ins_scale", 0.3, 1.0),
               ("cap_scale", 0.7, 1.5), ("lid_leak", 0.05, 0.40),
               ("bread_area", 0.08, 0.16), ("loaves_per_load", 4.0, 8.0),
               ("mount_post", 0.0, 1.0),
               ("sand_depth", 0.0, 0.40), ("sand_k", 0.3, 3.0),
               ("demand_scale", 0.5, 2.0),
               ("section", 0.0, 1.0),      # >= 0.5: the membrane is the SECTION of the parent the site allows (else the scaled circle)
               ("post_rise", 0.0, 3.0),    # F raised above the as-built under-swing height [m]: the tallness that lets a section overhang
               ("over_cap", 0.0, 1.0),     # SITE: how far past the parapet the neighbours accept the rim (thirds: 1.0 / 2.0 / 3.5 m)
               ("zones", 0.0, 1.0),        # < 0.5: ONE plenum zone (one pump, the uniform-pressure figure) instead of five
               ("m4_facet", 0.0, 1.0),     # < 1/3: the smooth ellipsoid M4; else flat facets of chord 0.05..0.25 m (a slope error at M4)
               ("roof_light", 0.0, 1.0),   # SITE: >= 0.5 the shop's roof is light (GI sheet / wood), not a concrete slab
               ("grid", 0.0, 1.0),         # SITE: >= 0.5 grid power at the shop (else PV + battery)
               ("receiver", 0.0, 1.0),     # THE RECEIVER: < 0.5 'cass' (elbow at the pot inlet), >= 0.5 'tri' (no elbow, M3 aimed at the loaf)
               # THE SITE, CONTINUED (user, 2026-09-10: "sample different buildings"): the machine
               # is going onto real roofs over real pits, and until now every agent had one roof
               # orientation, one neighbourhood and one pit.
               ("site_az", 0.0, 1.0),      # SITE: the roof's orientation - the sun's azimuth is rotated by 2 pi u in the machine's frame
               ("pot_r", 0.75, 1.30),      # SITE: the existing pit's floor and mouth radius, as a scale on the nominal (R_POT 0.42, R_MOUTH 0.26)
               ("pot_h", 0.70, 1.30),      # SITE: the existing pit's depth, as a scale on the nominal (H_DEPTH 2.44)
               ("site_hz", 0.0, 1.0))      # SITE: the neighbourhood - a seed for the horizon of parapet and neighbouring buildings (see _site_horizon)
    SITE_KEYS = ("roof_r", "cap_scale", "demand_scale", "over_cap", "roof_light", "grid",
                 "site_az", "pot_r", "pot_h", "site_hz")   # drawn with the site, never chosen
    SITE_NEW = ("site_az", "pot_r", "pot_h", "site_hz")    # the ones site_rand samples on a COOK run (the kit stays the built machine)
    N_HZ = 16                                               # horizon bins round the compass
    #: THE SAND INSIDE THE TANDOOR (user): the hearth and floor sit on a
    #: sand bed of sand_depth [m] the beam charges directly and that
    #: gives the heat back to the cavity at night; sand_k [W/mK] is its
    #: effective conductivity (0.3 plain sand, up to 3 with rebar fins:
    #: plain sand only lets ~8 cm take part in a day). Modelled on the
    #: wall's two layers under those nodes: sub = the top 8 cm, deep =
    #: the rest, an insulated bottom.
    SAND_RC = 1.28e6          # sand volumetric heat capacity [J/m3K]
    SAND_TOP = 0.08           # the sub layer's depth [m]
    N_DESIGN = 9 + 24
    FCT_W = 82
    # RESOLVED, 2026-09-11 (was OPEN since 2026-09-09 as "the receiver refactor moved the
    # traced power of a design_rand + section machine -17%"): every input to the trace
    # core was bit-identical across the two trees except the membrane LEVEL. The refactor
    # gave _trace_power's torch path np.interp against the ladder LEVEL_FRAC (0.62 .. 1.10,
    # not evenly spaced), so p0 maps to level 4 - the row the secondary was designed at -
    # while the old linear inverse (and, until today, the training kernel's step_pre,
    # _metal_trace and the polar _trace_power) put p0 at level 4.75, a figure at 1.03 p0.
    # Tracing the same kit at 1.030 p0 on the new tree gives back the old 17.900 W exactly.
    # Now one function for every path: tandoor_polar_env.level_of (kernel: sp[54..]).
    #: system block layout in the design table (offset 40)
    DS = dict(s=40, s2=41, zfold=42, zdeck=43, rate=44, ins=45, cap=46,
              lid=47, bread=48, hb=49, roti=50, lfp=51, lpl=52, fnom=53,
              amem=54, gorb=55, demand=56, roof=57, post=58, rail=59,
              site=60,                  # the primary's SURFACE BLOCK: 0 the built circle, k >= 1 the k-th installed section
              film=61, rim=62, rise=63, ocap=64,  # info for the bill and the readouts: film area [m2], rim length [m], post rise [m], overhang cap [m]
              zones=65, m4sig=66, roofl=67, grid=68, m4c=69,   # plenum zones (1 or 5), M4 facet slope error [rad rms] (the kernels read it), light roof, grid power, facet chord [m]
              sand_d=70, sand_k=71,     # the sand column: depth [m], conductivity [W/mK]; [56] the shop's demand scale
              # THE RECEIVER IS A COLUMN (2026-09-08). It used to be an env mode
              # (self.tri / self.duct_nozzle / M3_TURN), which made a batch one
              # machine or the other and quietly priced a mixed batch as whichever
              # the env happened to be built as. These three carry it per agent:
              recv=72,                  # 0 = the elbow re-images at the pot inlet ('cass'), 1 = M3 throws at the loaf ('tri')
              noz=73,                   # the elbow class at the duct mouth: 0 none, 1 flat, 2 the concave 2-DOF mount
              phw=74,                   # the aim head's half-travel about SPOT_PHI0 [rad]: the elbow's 110 deg, or M3's turn
              # THE SITE (2026-09-10): the sun's azimuth offset in the machine frame [rad], and
              # the existing pit's geometry - scales and the derived sphere the kernels bin on
              azs=75, potr=76, poth=77, zc=78, rs=79, rdw=80, hd=81)


    def _roof_quantile(self, u):
        """Roof half-width [m] at percentile u (0..1) from the site table."""
        q = getattr(self, "_roof_q", None)
        u = np.asarray(u, dtype=np.float64)
        if q is None:
            lo, hi = self.ROOF_DEFAULT
            return lo * (hi / lo) ** u
        return np.interp(u, np.linspace(0.0, 1.0, len(q)), q)

    def roof_to_scale(self, roof_r, deck_h=None, post=False):
        """The largest dish that fits a roof of half-width roof_r [m] with
        a deck deck_h [m] above the pot. The dish sweep (g_orbit + a_mem,
        scaled) may overhang the parapet by what the height above
        DECK_CLEAR allows; a ring rail (post=False) cannot overhang, so
        s <= (roof_r - RAIL_MARGIN) / g_orbit binds a rail mount."""
        r = np.asarray(roof_r, dtype=np.float64)
        over = 0.0
        if deck_h is not None:
            over = np.clip((np.asarray(deck_h, dtype=np.float64) - self.DECK_CLEAR)
                           * self.OVERHANG_PER_M, 0.0, self.OVERHANG_MAX)
        s = (r + over) / self.sweep0
        s_rail = (r - self.RAIL_MARGIN) / max(float(getattr(self, "g_orbit0", self.g_orbit)), 1e-6)
        s = np.where(np.asarray(post, dtype=bool), s, np.minimum(s, s_rail))
        return np.clip(s, self.S_LO, self.S_HI)

    def _design_row(self, sys=None):
        """One design table row (64): _fc_table (39) + duct mouth + the
        system block (nominal machine unless sys overrides)."""
        rec = (list(self._fc_table) if self._cass
               else [0.0] * 39) + [float(self.r_duct)]
        d = dict(s=1.0, s2=1.0, zfold=float(self.z_fold), zdeck=float(self.z_deck),
                 rate=1.0, ins=1.0, cap=1.0, lid=float(self.lid_leak),
                 bread=float(self.bread_area), hb=float(self.h_bread),
                 roti=float(self.roti_energy),
                 lfp=float(np.sqrt(self.bread_area) / 2.0),
                 lpl=float(self.loaves_per_load), fnom=float(self.f_nom),
                 amem=float(self.a_mem), gorb=float(self.g_orbit),
                 roof=float(self.sweep0), post=0.0, rail=float(self.r_rail),
                 sand_d=0.0, sand_k=0.3, demand=1.0, site=0.0,
                 film=float(np.pi * self.a_mem ** 2), rim=float(2 * np.pi * self.a_mem), rise=0.0, ocap=0.0,
                 zones=float(getattr(self, "n_zones", 5) or 5), m4sig=0.0, roofl=0.0, grid=0.0, m4c=0.0,
                 recv=float(self.tri), noz=float(getattr(self, "duct_nozzle", 0)),
                 phw=self.aim_halfspan(self.tri),
                 azs=0.0, potr=1.0, poth=1.0, **self.pot_sphere(1.0, 1.0))
        if sys:
            d.update(sys)
        row = rec + [0.0] * (self.FCT_W - 40)
        for k, i in self.DS.items():
            row[i] = d[k]
        self._last_row_extra = {k: v for k, v in d.items() if k not in self.DS}
        return row

    def _build_design_table(self):
        """The per-env receiver table _fct (B,40) the cores read (Metal
        buffer 28, torch fct=): the built design in every row, or with
        design_rand one design point per agent, uniform in DESIGN_BOX
        (r_strip tied to the strip footprint). _design_obs (B,N_DESIGN)
        is the unit-box coordinate 2u-1 the policy sees."""
        B = self.num_agents
        if not self._cass or not (getattr(self, "design_rand", 0) or getattr(self, "site_rand", 0)):
            rows = np.tile(np.asarray(self._design_row(), dtype=np.float32),
                           (B, 1))
            self._design_u = np.zeros((B, 0))
            self._m3_base = np.ascontiguousarray(rows[:, 15:27].copy())
            self._m3_dO_t = None
        elif not getattr(self, "design_rand", 0):
            # SITE ONLY: the built machine in every row, then the four site columns drawn
            # per agent and written over it (the kit's obs columns sit at the nominal).
            box = tuple(self.DESIGN_BOX) + tuple(self.SYS_BOX); names = [k for k, _, _ in box]
            rng = np.random.default_rng(self.design_seed)
            u = np.tile(self._u_nominal()[None, :], (B, 1))
            for k in self.SITE_NEW:
                u[:, names.index(k)] = rng.uniform(size=B)
            rows = np.tile(np.asarray(self._design_row(), dtype=np.float32), (B, 1))
            sv = {k: lo + u[:, names.index(k)] * (hi - lo) for k, lo, hi in box if k in self.SITE_NEW}
            rows[:, self.DS["azs"]] = 2.0 * np.pi * sv["site_az"]
            rows[:, self.DS["potr"]] = sv["pot_r"]; rows[:, self.DS["poth"]] = sv["pot_h"]
            sph = self.pot_sphere(sv["pot_r"], sv["pot_h"])
            for k in ("zc", "rs", "rdw", "hd"):
                rows[:, self.DS[k]] = sph[k]
            rs0 = float(self.pot_sphere(1.0, 1.0)["rs"])
            for b in range(B):                                  # the chain on THIS pit: F4 on its wall
                self._pot_cur = (float(sph["rs"][b]), float(sph["zc"][b]), float(sph["rdw"][b]))
                self._build_cass_chain()
                if self._cass:                                  # (the focus receiver has no chain in the row)
                    rows[b, :len(self._fc_table)] = np.asarray(self._fc_table, dtype=np.float32)
                _area = (float(sph["rs"][b]) / rs0) ** 2
                rows[b, self.DS["ins"]] *= _area; rows[b, self.DS["cap"]] *= _area
            self._pot_cur = None
            self._build_cass_chain()
            self._design_u = u
            self._m3_base = np.ascontiguousarray(rows[:, 15:27].copy())
            self._m3_dO_t = None
            self._site_horizon(u[:, names.index("site_hz")], rows[:, self.DS["roof"]])
        else:
            u = getattr(self, "_design_u", None)
            if u is None or u.shape != (B, self.N_DESIGN):          # keep the population across set_design rebuilds
                rng = np.random.default_rng(self.design_seed)
                u = rng.uniform(size=(B, self.N_DESIGN))
                u = self._kits_from_pop(u, rng)                   # START on the designer's machines, if there is a population
            self._design_u = u
            rows = self._rows_from_u(u)
        self._fct = torch.as_tensor(rows, dtype=torch.float32,
                                    device=self.device)
        self._design_obs = 2.0 * self._design_u - 1.0
        nd = self._design_obs.shape[1]
        self._dsn_t = torch.as_tensor(
            self._design_obs if nd else np.zeros((B, 1)),
            dtype=torch.float32, device=self.device)

    def _rows_from_u(self, u):
        """Design table rows (B,64) for unit-box coordinates u (B,N_DESIGN):
        the receiver box, then the site (roof percentile) and the system
        box; the dish is the largest that fits the roof and the deck."""
        B = u.shape[0]
        nominal = {k: getattr(self, k) for k, _, _ in self.DESIGN_BOX}
        nominal["r_strip"] = self.r_strip; m4_mode0 = self.m4_mode
        tri0, noz0 = bool(self.tri), int(getattr(self, "duct_nozzle", 0))
        base = {k: getattr(self, k) for k in ("a_mem", "f_nom", "g_orbit", "z_fold", "z_deck")}
        A0 = float(self.bread_area)
        nr = len(self.DESIGN_BOX)
        rows = np.zeros((B, self.FCT_W), dtype=np.float32)
        for b in range(B):
            for (k, lo, hi), ub in zip(self.DESIGN_BOX, u[b, :nr]):
                setattr(self, k, float(lo + ub * (hi - lo)))
            self.r_strip = 0.5 * self.strip_wk * self.d_strip * 1.3
            sv = {k: lo + ub * (hi - lo)
                  for (k, lo, hi), ub in zip(self.SYS_BOX, u[b, nr:])}
            # THE M4 MENU (design knob m4_facet): a smooth ellipsoid patch (< 1/3, doubly curved,
            # the dearest mirror in the kit), the same ellipsoid built from flat facets (1/3..2/3,
            # a slope error c/(2 R sqrt 3) at its 0.73 m vertex radius), or a FLAT M4 at the turn
            # (> 2/3: u_f2 = 0, the strip images F straight onto the duct mouth) - a plane mirror
            # needs no forming and facets cost it nothing.
            # THE RECEIVER, PER AGENT. _build_cass_chain reads self.tri for F4 - the
            # second focus of M3, which is the pot's inlet on 'cass' and a loaf on
            # 'tri' - so it has to be set before the chain is built, and put back
            # after the loop (the env still has one nominal machine for the readouts).
            self.tri = bool(sv.get("receiver", float(tri0)) >= 0.5)
            # THIS AGENT'S PIT: the loaf M3 aims at sits on ITS wall, so the sphere goes in
            # before the chain is built (tri_target reads _pot_cur); the wall's area scales
            # the pit's capacity and its conductance to the soil (both are per m2 of wall).
            _sph = self.pot_sphere(float(sv.get("pot_r", 1.0)), float(sv.get("pot_h", 1.0)))
            self._pot_cur = (float(_sph["rs"]), float(_sph["zc"]), float(_sph["rdw"]))
            _area = (float(_sph["rs"]) / float(self.pot_sphere(1.0, 1.0)["rs"])) ** 2
            # no elbow on the three-mirror machine: M3 already threw the beam at the
            # bread, and a second turn at the mouth would aim it again.
            noz_b = 0 if self.tri else noz0
            uf_ = float(sv.get("m4_facet", 0.0))
            if uf_ > 2.0 / 3.0:
                self.u_f2 = 0.0; self.m4_mode = "relay"
            else:
                self.m4_mode = m4_mode0
            roof = float(self._roof_quantile(sv["roof_r"]))
            post = bool(sv["mount_post"] >= 0.5)
            s = float(self.roof_to_scale(roof, sv["deck_h"], post))
            # THE SECTION (user, 2026-09-07): the membrane is the part of the
            # parent primary (f, F and the receiver unchanged) that stays
            # legal over the year on this roof, with the post raised by
            # post_rise so it may overhang the neighbours at height; the
            # library holds the film and its optics per (roof, cap, rise)
            nz = 1 if sv.get("zones", 1.0) < 0.5 else 5                     # one plenum zone or five
            rec, blk = (None, 0)
            if self._seclib is not None and sv.get("section", 0.0) >= 0.5:
                rec, blk = self._pick_section(roof, sv.get("over_cap", 0.5), sv.get("post_rise", 0.0), nz)
            if rec is None and nz == 1 and getattr(self, "_zone1_block", 0):
                blk = int(self._zone1_block)                                  # the one-zone CIRCLE (scaled like block 0)
            if rec is not None:
                nz = 5      # a SECTION's film is solved under the paraboloid's own pressure law: it needs the zoned pump
            rise = float(rec["rise"]) if rec is not None else 0.0
            if rec is not None:
                s, post = 1.0, True                       # the parent as built; a post mount (no ring rail fits these roofs)
                # the receiver chain's membrane-crossing test (the descending beam
                # through the dish plane, always on the DOWNHILL meridian) must see
                # the film that is there: its reach and inner rim along that
                # meridian, not a disc of the maximum reach
                r_out_dn, r_in_dn = self._film_downhill(rec)
                self.a_mem = float(r_out_dn); self.r_hole = max(float(self.r_hole), float(r_in_dn))
                self.f_nom = base["f_nom"]; self.g_orbit = base["g_orbit"]
            else:
                # the dish, its focal length and the orbit scale together;
                self.a_mem = base["a_mem"] * s
                self.f_nom = base["f_nom"] * s
                self.g_orbit = base["g_orbit"] * s
            # the deck sets the fold height and the receiver's F; the post rise lifts F further
            self.z_deck = H_POT + float(sv["deck_h"])
            self.z_fold = base["z_fold"] + (self.z_deck - base["z_deck"]) + rise
            self._build_cass_chain()
            # a FACETTED M4: flat facets of chord c laid on the mirror's curve. Across a facet the true
            # surface's slope runs +-c/(2R) about the facet's plane, R the mirror's vertex radius of
            # curvature (b^2/a of the built ellipsoid), so the rms slope error is c/(2 R sqrt(3)).
            # A FLAT M4 (the u_f2 = 0 design, a_e = 0) has R = inf: facets cost it nothing.
            uf = uf_; chord = 0.0 if uf < 1.0 / 3.0 else 0.05 + 0.20 * min(uf - 1.0 / 3.0, 1.0 / 3.0) / (1.0 / 3.0)
            R_m4 = (self.cs_ae ** 2 - self.cs_ce ** 2) / self.cs_ae if self.cs_ae > 1e-6 else np.inf
            m4sig = 0.0 if (chord <= 0.0 or not np.isfinite(R_m4)) else chord / (2.0 * R_m4 * np.sqrt(3.0))
            A = float(sv["bread_area"])
            sysd = dict(s=s, s2=s * s, zfold=self.z_fold, zdeck=self.z_deck,
                        rate=float(sv["rate_scale"]), ins=float(sv["ins_scale"]) * _area,
                        cap=float(sv["cap_scale"]) * _area, lid=float(sv["lid_leak"]),
                        bread=A, hb=25.0 * A,
                        roti=float(self.roti_energy) * A / A0,
                        lfp=float(np.sqrt(A) / 2.0),
                        lpl=float(int(round(sv["loaves_per_load"]))),
                        fnom=self.f_nom, amem=(float(rec["r_out_max"]) if rec is not None else self.a_mem), gorb=self.g_orbit,
                        roof=roof, post=float(post),
                        rail=0.0 if post else base["g_orbit"] * s + self.RAIL_MARGIN,
                        sand_d=float(sv["sand_depth"]), sand_k=float(sv["sand_k"]),
                        demand=float(sv["demand_scale"]),
                        site=float(blk), rise=rise, zones=float(nz), m4sig=float(m4sig), m4c=float(chord),
                        roofl=float(sv.get("roof_light", 0.0) >= 0.5), grid=float(sv.get("grid", 0.0) >= 0.5),
                        recv=float(self.tri), noz=float(noz_b), phw=self.aim_halfspan(self.tri),
                        azs=2.0 * np.pi * float(sv.get("site_az", 0.0)), potr=float(sv.get("pot_r", 1.0)), poth=float(sv.get("pot_h", 1.0)),
                        **self.pot_sphere(float(sv.get("pot_r", 1.0)), float(sv.get("pot_h", 1.0))),
                        film=float(rec["area"]) if rec is not None else float(np.pi * (base["a_mem"] * s) ** 2),
                        rim=float(rec["perimeter"]) if rec is not None else float(2 * np.pi * base["a_mem"] * s),
                        ocap=float(rec["cap"]) if rec is not None else 0.0)
            rows[b] = self._design_row(sysd)
        for k, vv in nominal.items():
            setattr(self, k, vv)
        for k, vv in base.items():
            setattr(self, k, vv)
        self.m4_mode = m4_mode0
        self.tri = tri0
        self._pot_cur = None                                   # back to the nominal pit for the env's own chain
        self._build_cass_chain()
        # THE UNTURNED M3 FIGURE, PER AGENT. _apply_m3_turn rotates M3 about the
        # bore axis every step and writes columns 21..26; before 2026-09-08 it
        # rotated the ENV's nominal chain and wrote that to every row, so on a
        # design_rand run each agent's M3 ellipsoid was the nominal machine's
        # while its a_e/c_e (27, 28) stayed its own. These are the per-agent
        # bases it turns from, captured while the rows are still untouched.
        self._m3_base = np.ascontiguousarray(rows[:, 15:27].copy())   # P4 (15:18), Oe0 (21:24), Ae0 (24:27)
        self._m3_dO_t = None                                          # force the device cache to rebuild
        # the neighbourhood, per agent, from its site seed (the roof sets the parapet distance)
        _names = [k for k, _, _ in tuple(self.DESIGN_BOX) + tuple(self.SYS_BOX)]
        self._site_horizon(u[:, _names.index("site_hz")], rows[:, self.DS["roof"]])
        return rows

    def _load_design_pop(self):
        import json as _json, os as _os
        p = self.design_pop
        if not p or not _os.path.exists(str(p)):
            return None
        m = _os.path.getmtime(str(p))
        if getattr(self, "_pop_mtime", None) == m:
            return self._pop
        with open(str(p)) as fh:
            self._pop = _json.load(fh)
        self._pop_mtime = m
        return self._pop

    def _kits_from_pop(self, u, rng):
        """The first draw of a design run (2026-09-11). redesign_at_dawn only reaches the
        agents every redesign_days dawns and only the non-elites, so a run used to START
        on the uniform box - where the median kit puts a tenth of the built machine's
        light into the pot and the cook policy learns on dead machines for days. With a
        population, each agent's kit comes from the Gaussian of its nearest roof site
        (redesign_explore of them stay uniform so the box is never abandoned); the SITE
        columns are untouched - they are the env's draw, not the designer's."""
        if not self.design_pop:
            return u
        pop = self._load_design_pop()
        if pop is None or not pop.get("sites"):
            return u
        names = [k_ for k_, _, _ in tuple(self.DESIGN_BOX) + tuple(self.SYS_BOX)]
        assert list(pop["names"]) == names and list(pop["site_keys"]) == list(self.SITE_KEYS), "design population was written for a different design box - regenerate it"
        kit_idx = np.array(pop["kit_index"]); i_roof = names.index("roof_r")
        sites = sorted(pop["sites"].values(), key=lambda s: s["site_u"][0]); roofs = np.array([s["site_u"][0] for s in sites])
        u = u.copy()
        for b in range(u.shape[0]):
            if rng.uniform() < self.redesign_explore:
                continue
            s = sites[int(np.argmin(np.abs(roofs - u[b, i_roof])))]
            z = np.array(s["mu"]) + np.exp(np.array(s["log_std"])) * rng.standard_normal(len(kit_idx))
            u[b, kit_idx] = 1.0 / (1.0 + np.exp(-z))
        return u

    def redesign_at_dawn(self, day_sales):
        """The metaprogrammer's move at the day-over: keep the old machine
        (the elites) or draw a new one from the designer's population for
        the agent's site. day_sales (B,) numpy: yesterday's sold rotis."""
        if not getattr(self, "design_rand", 0) or not self.design_pop:
            return False
        self._redesign_ct += 1
        if self._redesign_ct % max(self.redesign_days, 1):
            return False
        pop = self._load_design_pop()
        if pop is None or not pop.get("sites"):
            return False
        B = self.num_agents; u = self._design_u.copy(); rng = self.rng
        assert list(pop["names"]) == [k_ for k_, _, _ in tuple(self.DESIGN_BOX) + tuple(self.SYS_BOX)] and list(pop["site_keys"]) == list(self.SITE_KEYS), "design population was written for a different design box - regenerate it with tandoor_designer.py"
        kit_idx = np.array(pop["kit_index"]); names = pop["names"]; i_roof = names.index("roof_r")
        sites = sorted(pop["sites"].values(), key=lambda s: s["site_u"][0]); roofs = np.array([s["site_u"][0] for s in sites])
        # AN AGENT THAT SOLD NOTHING IS NOT AN ELITE.  A bare quantile makes every
        # agent one as soon as a quarter of them sell nothing: the 75th percentile of
        # day_sales is then 0, `>= 0` is true everywhere, redo comes out empty, and the
        # designer's population can never reach the agents it was built for.  That is
        # exactly the case it is needed in - a fragile receiver whose uniform box is
        # mostly machines that miss - so the protection has to require real sales
        # (2026-09-08: it pinned a tri design run to the dead uniform box).
        elite = (day_sales > 0.0) & (day_sales >= np.quantile(day_sales, 0.75))
        redo = (rng.uniform(size=B) < self.redesign_share) & ~elite
        for b in np.where(redo)[0]:
            if rng.uniform() < self.redesign_explore:
                u[b, kit_idx] = rng.uniform(size=len(kit_idx)); continue
            s = sites[int(np.argmin(np.abs(roofs - u[b, i_roof])))]
            z = np.array(s["mu"]) + np.exp(np.array(s["log_std"])) * rng.standard_normal(len(kit_idx))
            u[b, kit_idx] = 1.0 / (1.0 + np.exp(-z))
        self.set_design_points(u)
        return True

    def set_design_points(self, u):
        """Set every agent's design from unit-box coordinates u (B,N_DESIGN):
        the design search's hook (tree search, Bayesian optimization) -
        the table, the design obs and the per-env arrays are rebuilt;
        rebuild the device state (FusedState) afterwards."""
        u = np.asarray(u, dtype=np.float64)
        assert u.shape == (self.num_agents, self.N_DESIGN), u.shape
        self._design_u = u
        rows = self._rows_from_u(u)
        self._fct = torch.as_tensor(rows, dtype=torch.float32, device=self.device)
        self._design_obs = 2.0 * u - 1.0
        self._dsn_t = torch.as_tensor(self._design_obs, dtype=torch.float32, device=self.device)
        self._apply_system_design()
        return self

    def design_points(self):
        """The per-agent designs as a dict of (B,) arrays (design_rand):
        the box values, with roof_r in metres and the derived dish_scale."""
        box = tuple(self.DESIGN_BOX) + tuple(self.SYS_BOX)
        d = {k: lo + self._design_u[:, i] * (hi - lo)
             for i, (k, lo, hi) in enumerate(box)}
        if "roof_r" in d:
            d["roof_r"] = self._roof_quantile(d["roof_r"])
        fct = self._fct.detach().cpu().numpy()
        d["dish_scale"] = fct[:, self.DS["s"]].astype(np.float64)
        for k in ("site", "film", "rim", "rise", "ocap"):
            d[k] = fct[:, self.DS[k]].astype(np.float64)
        d["film_m2"], d["rim_m"] = d["film"], d["rim"]
        d["r_out_max"] = np.where(d["site"] > 0.5, fct[:, self.DS["amem"]], 2.1 * d["dish_scale"]).astype(np.float64)   # the film's reach
        for k in ("zones", "m4sig", "roofl", "grid", "m4c"):
            d[k] = fct[:, self.DS[k]].astype(np.float64)
        d["m4chord"] = d["m4c"]
        d["m4flat"] = (fct[:, 27] <= 1e-6).astype(np.float64)      # a_e = 0: the flat M4 at the turn
        d["tri"] = fct[:, self.DS["recv"]].astype(np.float64)      # the three-mirror receiver: no elbow, M3 actuated - PER AGENT, read off the table the machine was built from (it used to broadcast the env's own flag, which priced a mixed batch as whichever receiver the env happened to be)
        d["r_duct"] = fct[:, 39].astype(np.float64)
        # the insulating shell this ins_scale costs, in the material the env was built with
        t_, v_, c_ = self.shell_spec(d["ins_scale"])
        d["shell"] = np.full(self.num_agents, {"perlite": 0.0, "glasswool": 1.0, "aac": 2.0}[self.shell])
        d["shell_name"] = self.shell; d["shell_t"] = t_; d["shell_m3"] = v_; d["shell_MJK"] = c_ / 1e6
        return d

    SEC_CAPS = (1.0, 2.0, 3.5)          # the library's overhang caps [m], picked by thirds of the over_cap site key

    def _build_zone1_block(self, a, f_design):
        """The ONE-ZONE circle: the same membrane pumped by a single plenum (uniform pressure) to the
        same design focal length - the Hencky figure, no zone correction. Installed as surface block 1
        (design knob zones < 0.5 on a circle); the section library's blocks follow."""
        cfg = self.cfg
        def _solve(p, n=400): return _sim.solve_membrane(cfg, p, n=n)
        f_of = lambda p: _solve(p)["z0"] + _solve(p)["f_fit"] if False else (lambda m: m["z0"] + m["f_fit"])(_solve(p))
        # bracket the root first: the uniform (Hencky) law needs ~1.5x the linear pressure
        # T/f, and the zoned bracket's ceiling (T/(0.25 f)) sits BELOW it - the bisection
        # then saturates at the ceiling and returns a membrane of the wrong focal length
        lo, hi = cfg.T_pre / (8 * f_design), cfg.T_pre / (0.25 * f_design)
        for _ in range(8):
            if f_of(hi) <= f_design: break
            hi *= 2.0
        for _ in range(8):
            if f_of(lo) >= f_design: break
            lo *= 0.5
        for _ in range(22):
            mid = 0.5 * (lo + hi); m = _solve(mid)
            if m["z0"] + m["f_fit"] > f_design: lo = mid
            else: hi = mid
        p0 = 0.5 * (lo + hi); mems = [_solve(p0 * fr) for fr in self.level_frac]
        prim = AO.MembranePrimary(_sim, cfg, mems, self._hx, self._hy, self.device,
                                  tag=f"hashemi2z1_{a:.2f}g{self.g_orbit:.1f}w{self.z_waist:.1f}", csr_frac=self.csr_frac)
        self._zone1 = dict(pts=prim.membrane.points[..., :3].contiguous(), nrm=prim.membrane.normals[..., :3].contiguous(),
                           ray_pw=self._ray_pw.clone(), loss_chain=float(self._loss_chain), p0=float(p0), f_fit=float(mems[4]["z0"] + mems[4]["f_fit"]))
        self._extra_blocks = [self._zone1]; self._zone1_block = 1
        print(f"  [hashemi] one-zone circle block: p0 {p0:.0f} Pa (zoned {self.p0:.0f}), f {self._zone1['f_fit']:.3f} vs {self.f_nom:.3f}")
        assert abs(self._zone1["f_fit"] - f_design) < 0.05, f"one-zone membrane missed the design focal length: {self._zone1['f_fit']:.3f} vs {f_design:.3f}"

    def _load_section_library(self, path):
        """install every non-empty record of the library as a surface block and
        keep the (roof, cap, rise) -> block map for _rows_from_u"""
        lib = torch.load(path, weights_only=False)
        # the library must be THIS machine's: the parent's focal length, the pump levels, the ray count
        meta = lib.get("meta", {})
        assert abs(float(lib["f"]) - float(self.f_nom)) < 2e-3, f"section library built for f {lib['f']}, this machine has f_nom {self.f_nom:.4f}"
        assert [round(float(v), 4) for v in lib["levels"]] == [round(float(v), 4) for v in self.LEVEL_FRAC], "section library's pump levels differ from LEVEL_FRAC"
        assert "g_orbit" not in meta or abs(float(meta["g_orbit"]) - float(self.g_orbit)) < 1e-3, \
            f"section library built at g_orbit {meta['g_orbit']}, env has {self.g_orbit}"
        lat_ = getattr(self, "lat", None)          # a soft check: the films' legality was solved for one latitude's sun
        if "lat" in meta and lat_ is not None and abs(float(meta["lat"]) - float(lat_)) > 0.05:
            print(f"  [hashemi] WARNING: section library solved at lat {meta['lat']}, this env runs lat {lat_} - the films' legality is approximate")
        n_exp = len(lib["roof_hw"]) * len(lib["caps"]) * len(lib["rises"])
        if len(lib["records"]) != n_exp:
            print(f"  [hashemi] WARNING: section library has {len(lib['records'])} of {n_exp} records (a partial build?)")
        extra = list(getattr(self, "_extra_blocks", []))                   # the one-zone circle first, if built
        recs, blocks, keys = [], {}, sorted(lib["records"].keys()); bad = 0
        for k in keys:
            r = lib["records"][k]
            if r.get("empty", False) or r.get("area", 0.0) < 1.0:
                continue
            if not r.get("ok", True):
                bad += 1; continue                                           # the membrane solve did not converge / the mesh was bad
            blocks[k] = 1 + len(extra) + len(recs); recs.append(r)
        self.install_sections(extra + [dict(pts=r["pts"], nrm=r["nrm"], ray_pw=r["ray_pw"], loss_chain=float(lib.get("loss_chain", 1.0))) for r in recs])
        self._seclib = dict(lib=lib, blocks=blocks, recs=recs, roof_hw=np.asarray(lib["roof_hw"], dtype=np.float64),
                            caps=tuple(lib["caps"]), rises=np.asarray(lib["rises"], dtype=np.float64),
                            zones=tuple(lib.get("zones", (5,))), four=bool(keys and len(keys[0]) == 4))
        print(f"  [hashemi] section library: {len(recs)} films installed from {len(keys)} (roof x cap x rise) records" + (f", {bad} rejected (solver)" if bad else ""))

    @staticmethod
    def _film_downhill(rec, half_width_deg=20.0):
        """the film's outer reach and inner rim along the downhill meridian (body theta = pi),
        the max/min over +-half_width_deg of it (the bore's spread)"""
        th = np.asarray(rec["th"]); d = np.abs((th - np.pi + np.pi) % (2 * np.pi) - np.pi)
        m = d <= np.radians(half_width_deg)
        return float(np.asarray(rec["rmax"])[m].max()), float(np.asarray(rec["rmin"])[m].min())

    def _pick_section(self, roof_hw, cap_u, rise, zones=5):
        """the library record for a roof half-width [m] (a floor), the over_cap site
        coordinate (0..1), a post rise [m] and the plenum zones -> (record, block) or (None, 0)"""
        L = self._seclib
        iz = list(L.get("zones", (5,))).index(zones) if zones in L.get("zones", (5,)) else 0
        # the roof bin is a FLOOR: the largest library roof not larger than the agent's (a film
        # made for a bigger roof would overhang this one); below the smallest bin, no film
        fits = np.where(L["roof_hw"] <= float(roof_hw) + 1e-6)[0]
        if len(fits) == 0:
            return None, 0
        ir = int(fits.max())
        ic = min(int(float(cap_u) * len(L["caps"])), len(L["caps"]) - 1)
        idl = int(np.argmin(np.abs(L["rises"] - float(rise))))
        k = (ir, ic, idl, iz) if L.get("four", False) else (ir, ic, idl)
        if k not in L["blocks"]:
            return None, 0
        return L["lib"]["records"][k], L["blocks"][k]

    def install_sections(self, sections):
        """SECTIONS of the parent primary as extra surface blocks: each a dict
        with pts (L,P,3), nrm (L,P,3) in the dish's body frame and ray_pw (P,)
        (tandoor_section_surface.build_section, P = n_rays, L = N_LEVELS).
        Block 0 stays the built circular dish; block k is sections[k-1]. An
        agent's block is design-table column DS['site']; the kernels read
        pts_l/nrm_l/ray_pw stacked, the torch binning per-agent weights."""
        assert self._cass, "sections: receiver 'cass' or 'tri' only"
        L, P = self.N_LEVELS, len(self._hx)
        if not hasattr(self, "_surf0"):
            self._surf0 = (self._pts_l.clone(), self._nrm_l.clone(), self._ray_pw.clone())
        pts, nrm, pw = [self._surf0[0]], [self._surf0[1]], [self._surf0[2]]
        for sd in sections:
            sp, sn, spw = sd["pts"], sd["nrm"], sd["ray_pw"]
            assert sp.shape[0] == L and sp.shape[2] == 3, (sp.shape, (L, P, 3))
            if sp.shape[1] != P:
                # a different ray count: an even stride through the equal-area sequence keeps it uniform; the weights keep the area
                idx = torch.as_tensor(np.round(np.linspace(0, sp.shape[1] - 1, P)).astype(np.int64))
                sp, sn, spw = sp[:, idx], sn[:, idx], spw[idx] * (sp.shape[1] / P)
            pts.append(sp.to(self.device, torch.float32)); nrm.append(sn.to(self.device, torch.float32))
            pw.append(spw.to(self.device, torch.float32) * float(self._loss_chain) / float(sd.get("loss_chain", 1.0)))
        self._pts_l = torch.cat(pts, 0).contiguous(); self._nrm_l = torch.cat(nrm, 0).contiguous()
        self._ray_pw = torch.cat(pw, 0).contiguous()
        self._sections = list(sections); self.N_SURF = 1 + len(sections)
        self._refresh_site_weights()
        return self

    def _refresh_site_weights(self):
        """the per-agent ray weights the torch binning uses (block from DS['site'])"""
        S = int(getattr(self, "N_SURF", 1)); P = len(self._hx)
        if S <= 1 or getattr(self, "_fct", None) is None:     # no sections, or the table not built yet (init order)
            self._ray_pw_agent = None; return
        site = (self._fct[:, self.DS["site"]] + 0.5).long().clamp(0, S - 1)
        self._ray_pw_agent = self._ray_pw.view(S, P)[site]
        self._site_idx = site

    def _apply_m3_turn(self):
        """Write M3's turned figure into the design table (columns 21..26), so both
        cores see the mirror where the actuator has put it. The turn angle is
        spot_phi, the head the elbow used to steer; on the three-mirror machine
        that head turns M3 instead. Called from every trace entry point, and from
        the fused step, which does not go through _metal_trace."""
        if getattr(self, "_fct", None) is None or getattr(self, "_m3_base", None) is None:
            return
        dev = self._fct.device
        if getattr(self, "_m3_dO_t", None) is None:
            # PER AGENT, from the rows each machine was built with. The env's own
            # cs_P4/_m3_Oe0 are the nominal chain's; broadcasting those wrote the
            # nominal M3 into every row while a_e/c_e stayed per agent, so on a
            # design_rand run the mirror did not match the ellipsoid it was cut as.
            base = torch.as_tensor(self._m3_base, dtype=torch.float32, device=dev)
            self._m3_P4_t = base[:, 0:3]                       # rows 15..17
            self._m3_dO_t = base[:, 6:9] - base[:, 0:3]        # rows 21..23, about P4
            self._m3_A0_t = base[:, 9:12]                      # rows 24..26
            self._m3_base_t6 = base[:, 6:12].contiguous()      # the untouched figure, for the 'cass' rows
            self._m3_tri_t = (self._fct[:, self.DS["recv"]] > 0.5)[:, None]
            self._m3_phw_t = self._fct[:, self.DS["phw"]]
        sp0 = (self._spot_view[0] if getattr(self, "_spot_view", None) is not None
               else self.spot_phi)                      # the live aim: numpy or device
        psi = (sp0 if torch.is_tensor(sp0)
               else torch.as_tensor(np.asarray(sp0, dtype=np.float32))).to(dev, torch.float32)
        w = self._m3_phw_t
        psi = (psi - float(_SP0)).clamp(min=0.0) .minimum(w) \
            + (psi - float(_SP0)).clamp(max=0.0).maximum(-w)   # +-phw, per agent
        c, s_ = torch.cos(psi)[:, None], torch.sin(psi)[:, None]
        P4, dO, A0 = self._m3_P4_t, self._m3_dO_t, self._m3_A0_t
        turned = torch.cat([
            P4[:, 0:1] + c * dO[:, 0:1] - s_ * dO[:, 1:2],
            P4[:, 1:2] + s_ * dO[:, 0:1] + c * dO[:, 1:2],
            P4[:, 2:3] + dO[:, 2:3],
            c * A0[:, 0:1] - s_ * A0[:, 1:2],
            s_ * A0[:, 0:1] + c * A0[:, 1:2],
            A0[:, 2:3]], dim=1)
        # ONLY the three-mirror rows turn. A 'cass' agent's M3 is the built
        # ellipsoid at the turn and its steering happens at the elbow instead;
        # writing the untouched base back keeps this branch-free on a mixed batch.
        self._fct[:, 21:27] = torch.where(self._m3_tri_t, turned, self._m3_base_t6)

    def tri0(self):
        """Is the RENDERED agent (0) a three-mirror machine? The HUD and the
        drawing describe one agent, and since the receiver became a design column
        the env's own self.tri is only the nominal machine - on a design_rand run
        agent 0 may be either."""
        f = getattr(self, "_fct", None)
        if f is None or f.shape[1] <= self.DS["recv"]:
            return bool(self.tri)
        return bool(float(f[0, self.DS["recv"]]) > 0.5)

    def pot_sphere(self, pot_r, pot_h):
        """The existing pit as the sphere the kernels bin on, for radius scale pot_r (floor and
        mouth together) and depth scale pot_h: Z_CPOT, R_SPH, R_DUCT_WALL, H_DEPTH - the same
        derivation tandoor_polar_env makes for the nominal pit. Vectorised over agents."""
        from tandoor_polar_env import R_MOUTH as _RM, H_DEPTH as _HD, Z_DUCT as _ZD
        pr_, ph_ = np.asarray(pot_r, dtype=np.float64), np.asarray(pot_h, dtype=np.float64)
        rm, rp, hd = _RM * pr_, float(R_POT) * pr_, _HD * ph_
        zc = (rm ** 2 - rp ** 2 - hd ** 2) / (2.0 * hd)
        rs = np.sqrt(rm ** 2 + zc ** 2)
        rdw = np.sqrt(np.maximum(rs ** 2 - (float(_ZD) - zc) ** 2, 1e-6))
        return dict(zc=zc, rs=rs, rdw=rdw, hd=hd)

    @classmethod
    def unit_of(cls, k, v):
        """Unit-box coordinate of physical value v on knob k (DESIGN_BOX or SYS_BOX)."""
        lo, hi = [(lo, hi) for kk, lo, hi in tuple(cls.DESIGN_BOX) + tuple(cls.SYS_BOX) if kk == k][0]
        return float(np.clip((float(v) - lo) / (hi - lo), 0.0, 1.0))

    @classmethod
    def site_nominal_u(cls):
        """The SITE_NEW columns of the nominal site, in unit coordinates: roof square to the
        sun, the pit as built, the median horizon draw. The design tools pin these - the pit
        is the site's, never the designer's choice - and a cook run with site_rand draws them."""
        return dict(site_az=0.0, pot_r=cls.unit_of("pot_r", 1.0), pot_h=cls.unit_of("pot_h", 1.0), site_hz=0.5)

    def _u_nominal(self):
        """The built machine's unit-box coordinates, so a site-only table can carry the kit at
        its real values in the obs. Exact where the env has the attribute; the few switches
        (mount, section, zones, facets, receiver) from the env's state."""
        box = tuple(self.DESIGN_BOX) + tuple(self.SYS_BOX)
        val = {k: getattr(self, k) for k, _, _ in self.DESIGN_BOX}
        val.update(deck_h=float(self.deck_h), rate_scale=1.0, ins_scale=1.0, cap_scale=1.0, lid_leak=float(self.lid_leak),
                   bread_area=float(self.bread_area), loaves_per_load=float(self.loaves_per_load),
                   mount_post=1.0 if float(getattr(self, "r_rail", 0.0)) <= 0.0 else 0.0, sand_depth=0.0, sand_k=0.3,
                   demand_scale=1.0, section=0.0, post_rise=0.0, over_cap=0.5, zones=0.0 if int(getattr(self, "n_zones", 5) or 5) == 1 else 1.0,
                   m4_facet=0.0, roof_light=0.0, grid=1.0, receiver=1.0 if self.tri else 0.0,
                   site_az=0.0, pot_r=1.0, pot_h=1.0, site_hz=0.5, roof_r=1.0)
        return np.array([np.clip((float(val[k]) - lo) / (hi - lo), 0.0, 1.0) for k, lo, hi in box])

    def _site_horizon(self, u_hz, roof_r):
        """THE NEIGHBOURHOOD, per agent: the elevation [deg] of whatever blocks the sun in each
        of N_HZ azimuth bins - the roof's own parapet all round, and one to three neighbouring
        buildings of random height and distance. Drawn deterministically from the site seed
        u_hz (so a site reproduces), scaled to the roof (a big roof keeps its neighbours
        further off). Stored as self._hz (B,N_HZ) and self._hz_t on the device."""
        u_hz = np.asarray(u_hz, dtype=np.float64).ravel(); roof_r = np.asarray(roof_r, dtype=np.float64).ravel()
        B, NH = len(u_hz), self.N_HZ
        hz = np.zeros((B, NH)); az_c = (np.arange(NH) + 0.5) * (2 * np.pi / NH)
        for b in range(B):
            r = np.random.default_rng(int(u_hz[b] * 2 ** 31) + 7)
            par_h, par_d = r.uniform(0.5, 1.2), max(float(roof_r[b]), 1.5)          # the parapet, all round
            hz[b, :] = np.degrees(np.arctan2(par_h, par_d))
            for _ in range(r.integers(1, 4)):                                         # the neighbours
                c, w = r.uniform(0, 2 * np.pi), r.uniform(np.radians(20), np.radians(70))
                h, d = r.uniform(1.0, 8.0), r.uniform(3.0, 15.0) + float(roof_r[b])
                dphi = np.abs((az_c - c + np.pi) % (2 * np.pi) - np.pi)
                hz[b, dphi < 0.5 * w] = np.maximum(hz[b, dphi < 0.5 * w], np.degrees(np.arctan2(h, d)))
        self._hz = hz
        self._hz_t = torch.as_tensor(hz, dtype=torch.float32, device=self.device)
        return hz

    def _hz_obs(self, az_machine):
        """The two horizon obs columns: the obstruction elevation in the sun's current
        azimuth bin and in the next one along (the sun crosses a bin in ~1.5 h), each
        /90 - so a policy can see the morning start late and the afternoon end early.
        az_machine (B,) rad in the site's frame; numpy in -> numpy, torch in -> torch."""
        hz = getattr(self, "_hz", None)
        if torch.is_tensor(az_machine):
            if hz is None:
                return torch.zeros(az_machine.shape[0], 2, device=az_machine.device, dtype=torch.float32)
            H = self._hz_t.to(az_machine.device)
            b0 = ((torch.remainder(az_machine, 2 * np.pi)) / (2 * np.pi) * self.N_HZ).long().clamp(0, self.N_HZ - 1)
            b1 = (b0 + 1) % self.N_HZ
            return torch.stack([H.gather(1, b0[:, None])[:, 0], H.gather(1, b1[:, None])[:, 0]], 1) / 90.0
        az_machine = np.asarray(az_machine, dtype=np.float64).ravel()
        if hz is None:
            return np.zeros((az_machine.shape[0], 2))
        b0 = np.clip(((az_machine % (2 * np.pi)) / (2 * np.pi) * self.N_HZ).astype(int), 0, self.N_HZ - 1)
        b1 = (b0 + 1) % self.N_HZ; ar = np.arange(len(b0))
        return np.stack([hz[ar, b0], hz[ar, b1]], 1) / 90.0

    def _shade(self, soil, mnt):
        """SHADING: the sun behind the horizon costs the whole beam, and the model already has
        a per-agent per-trace attenuation - soil - so the horizon rides on it. mask = sigmoid
        ((el_sun - horizon(az_sun)) / 0.27 deg), the sun's half-disc as the edge. Takes numpy
        or torch soil and returns the same kind; a no-op when no horizon was drawn."""
        hz = getattr(self, "_hz", None)
        if hz is None:
            return soil
        el, az = mnt["el"], mnt["az"]                                        # (B,) deg, (B,) rad, from the mount solve
        if torch.is_tensor(soil):
            elt = el.to(soil.device, soil.dtype); azt = az.to(soil.device, soil.dtype)
            b_ = ((azt % (2 * np.pi)) / (2 * np.pi) * self.N_HZ).long().clamp(0, self.N_HZ - 1)
            h = self._hz_t.to(soil.device, soil.dtype).gather(1, b_[:, None])[:, 0]
            return soil * torch.sigmoid((elt - h) / 0.27)
        eln = np.asarray(el.detach().cpu().numpy() if torch.is_tensor(el) else el, dtype=np.float64).ravel()
        azn = np.asarray(az.detach().cpu().numpy() if torch.is_tensor(az) else az, dtype=np.float64).ravel()
        b_ = np.clip(((azn % (2 * np.pi)) / (2 * np.pi) * self.N_HZ).astype(int), 0, self.N_HZ - 1)
        h = hz[np.arange(len(b_)), b_]
        return np.asarray(soil, dtype=np.float64) / (1.0 + np.exp(-(eln - h) / 0.27))

    def shell_spec(self, ins, damp=False):
        """For the pit's insulating annulus of self.shell at design factor ins (the
        deep->halo conductance factor ins_scale): (thickness [m], volume [m3], heat
        capacity [J/K]) per agent - the SAME spherical series _build_thermal uses
        (wall r0+0.115 -> rf3 at k_wall, then soil 0.5 W/mK to the halo), inverted:
        R_ins = R_no (1/ins - 1) = (1/(4 pi k)) (1/rf3 - 1/(rf3 + t))."""
        from tandoor_rl_env import SHELL_MATERIALS as _SM, SHELL_AAC_DAMP_K as _KD
        k, rc, _ = _SM[self.shell]
        if damp and self.shell == "aac":
            k = _KD
        ins = np.clip(np.asarray(ins, dtype=np.float64), 0.05, 1.0)
        a_tot = float(np.asarray(self.node_area).sum()); r0 = np.sqrt(a_tot / (4 * np.pi)); rf3 = r0 + 0.165
        gsph = lambda kk, ra, rb: 4 * np.pi * kk / (1 / ra - 1 / rb)
        R_no = 1 / gsph(self.k_wall, r0 + 0.115, rf3) + 1 / gsph(0.5, rf3, rf3 + 0.55)
        R_ins = R_no * (1.0 / ins - 1.0)
        inv = 1.0 / rf3 - 4 * np.pi * k * R_ins
        rb = np.where(inv > 1e-6, 1.0 / np.maximum(inv, 1e-6), rf3 + 0.6)       # cap a hopeless factor at 60 cm
        t = np.clip(rb - rf3, 0.0, 0.6)
        vol = (4.0 / 3.0) * np.pi * ((rf3 + t) ** 3 - rf3 ** 3)
        return t, vol, rc * vol

    def _pot0(self):
        """Agent 0's pit (the one on screen): rs, zc, rdw, hd - from the table when there is one."""
        from tandoor_polar_env import R_SPH as _RS0, Z_CPOT as _ZC0, R_DUCT_WALL as _RDW0, H_DEPTH as _HD0
        f = getattr(self, "_fct", None)
        if f is None or f.shape[1] <= self.DS["hd"]:
            return dict(rs=float(_RS0), zc=float(_ZC0), rdw=float(_RDW0), hd=float(_HD0))
        r = f[0].detach().cpu().numpy()
        return dict(rs=float(r[self.DS["rs"]]), zc=float(r[self.DS["zc"]]), rdw=float(r[self.DS["rdw"]]), hd=float(r[self.DS["hd"]]))

    def receiver0(self):
        """The RENDERED agent's receiver, as built: (r_m4, r_duct, r_beam, pass_frac,
        turn_deg, span_deg).  r_beam is the cone's radius where _bin_pot gates it -
        at the duct plane x = R_POT - so pass_frac is the share of M3's aperture the
        inlet actually admits.  That number is the difference between 186 and 513
        rotis a day and nothing on screen used to show it."""
        f = getattr(self, "_fct", None)
        if f is None or f.shape[1] <= self.DS["phw"]:
            return (float(self.r_m4), float(self.r_duct), float("nan"), float("nan"), 0.0, 0.0)
        f0 = (f[0].detach().cpu().numpy() if torch.is_tensor(f) else np.asarray(f)[0])
        r_m4, r_duct, phw = float(f0[29]), float(f0[39]), float(f0[self.DS["phw"]])
        tri_b = float(f0[self.DS["recv"]]) > 0.5
        psi = float(np.clip(np.asarray(self.spot_phi, dtype=np.float64).ravel()[0] - _SP0,
                            -phw, phw)) if getattr(self, "spot_phi", None) is not None else 0.0
        P4 = f0[15:18].astype(np.float64)
        F4 = self.tri_target(psi) if tri_b else np.asarray(self.cs_F4, dtype=np.float64)
        dx = float(F4[0] - P4[0])
        if abs(dx) < 1e-9:
            return (r_m4, r_duct, float("nan"), float("nan"), np.degrees(psi), np.degrees(phw))
        # on 'cass' F4 IS the duct mouth, so hit == F4, r_beam -> 0 and the inlet
        # passes everything: the elbow re-images beyond it and the hole can be small.
        # That is the second chance 'tri' gives up, and it is why the same 0.20 m
        # hole is harmless on one machine and costs 96% of the beam on the other.
        # (Idealised - a real waist has the sun's angular width, so 100% is a ceiling.)
        hit = P4 + ((float(R_POT) - P4[0]) / dx) * (F4 - P4)
        # r_beam is the CONE EDGE at the inlet plane (the full M3 aperture converging
        # on F4): where the outermost rays are, not where the power is. Traced, the
        # power-weighted r50 is ~0.4 m against an edge of ~0.95, so the admitted
        # fraction is read off the trace (_inlet_thru), never off this radius.
        r_beam = r_m4 * float(np.linalg.norm(hit - F4)) / max(float(np.linalg.norm(F4 - P4)), 1e-9)
        thru = getattr(self, "_inlet_thru", None)
        frac = float(np.asarray(thru).ravel()[0]) if thru is not None else float("nan")
        return (r_m4, r_duct, r_beam, frac, np.degrees(psi), np.degrees(phw))

    NX_EXT = 37     #: exterior surface bins (the MSL define NX): see tandoor_metal_kernel for the layout
    #: what each bin IS, for the tag on the surface (bands and sectors collapse to one surface name)
    EXT_NAMES = (["collar"] * 8 + ["bore wall"] * 6 + ["deck"] + ["pot exterior"] * 4 + ["pit floor", "escaped"]
                 + ["dish: return leg blocked"] * 4 + ["dish: strip shadow"] * 4 + ["dish: slot"] * 4
                 + ["dish: hole", "F arm", "strip: outside window", "strip: missed conic"])

    def _surface_tags(self):
        """TEXT TAGS FOR EVERY SURFACE IN THE LIGHT CONE THAT TOOK RAYS, for the agent on
        screen - the same thing _pot_lbls does for the pot's nodes, extended to everything
        after the secondary (and the dish it throws back through). One tag per surface,
        placed at the power-weighted centroid of the rays that stopped there, reading the
        surface and its watts; bore bands keep one tag each because height is the point.
        Plus the strip and M3 themselves with what reached them. Built from _pex/_ext_cent
        (the deposition) - no geometry is redone here."""
        px, ce = getattr(self, "_pex", None), getattr(self, "_ext_cent", None)
        if px is None or ce is None:
            return []
        px = px.reshape(-1, self.NX_EXT)[0].detach().cpu().numpy(); ce = ce.reshape(-1, self.NX_EXT, 3)[0].detach().cpu().numpy()
        wtot = float(getattr(self, "_w_total", torch.zeros(1))[0]); ext = float(px.sum())
        tags = []
        # collapse sectors/quarters to one tag per surface; keep bore bands separate
        groups = {}
        for b in range(self.NX_EXT):
            key = f"bore wall {b - 8}" if 8 <= b <= 13 else self.EXT_NAMES[b]
            if px[b] > 1e-6:
                g = groups.setdefault(key, [0.0, np.zeros(3)]); g[0] += px[b]; g[1] += px[b] * ce[b]
        for key, (w, c) in groups.items():
            pct = 100.0 * w / max(wtot, 1e-9)
            col = ((255, 130, 110) if key.startswith(("collar", "bore", "pot", "deck", "pit", "escaped"))
                   else (235, 200, 120))
            tags.append((c / w, f"{key}  {w:.2f} W  ({pct:.0f}%)", col))
        # the two mirrors themselves, as sums over the rays that reached them: the strip
        # takes everything not lost on the sun leg (codes 11..14); M3 takes the rays that
        # went through (0), hit the collar (9) or went the wrong way after it (8)
        wc = getattr(self, "_w_by_code", None)
        wc = wc[0].detach().cpu().numpy() if wc is not None else np.zeros(16)
        f0 = self._fct[0].detach().cpu().numpy()
        tags.append((np.asarray(self.F_focus, float), f"strip  {wtot - wc[11:15].sum():.2f} W hit", (200, 170, 255)))   # the strip sits about F
        tags.append((np.asarray(f0[15:18], float), f"M3  {wc[0] + wc[8] + wc[9]:.2f} W hit", (160, 220, 240)))
        tags.append((None, f"beam caught {wtot:.2f} W: pot {wtot - ext:.2f}, elsewhere {ext:.2f}", (200, 200, 210)))
        return tags

    def _ray_weights(self, fate, soil_t):
        """Every ray's incident power, per agent: the kernel's own selection
        ray_pw[block(b)*P + ip] x ray_scale x soil x the dish area factor. Also
        stashes _w_total (the beam the dish caught) and _w_by_code (watts per fate
        code, 0 = through) - on BOTH trace paths, from the ledger the path produced."""
        B, P = fate.shape[0], fate.shape[1]
        code = fate[..., 0]
        rp = self._ray_pw.reshape(-1, P).to(fate.dtype)
        blk = self._fct[:, 60].round().long().clamp(0, rp.shape[0] - 1)
        pw = rp[blk]
        rs = getattr(self, "_ray_scale", None)
        rs = torch.ones(B, device=fate.device, dtype=fate.dtype) if rs is None else rs.to(fate.dtype).reshape(B)
        w_all = pw * rs[:, None] * (soil_t.to(fate.dtype).reshape(B) * self._ds_s2_t.to(fate.dtype).reshape(B))[:, None]
        self._w_total = w_all.sum(1)
        self._w_by_code = torch.zeros(B, 16, device=fate.device, dtype=fate.dtype).scatter_add_(
            1, code.clamp(min=0, max=15).long(), w_all)
        return w_all

    def _deposit_exterior(self, fate, soil_t):
        """The exterior flux labelling on the torch path: every missed ray's power
        onto the surface bin the ledger chose - the same weight _bin_pot gives a
        through ray (ray_pw x ray_scale x soil x dish area), minus the through gate.
        Returns (B, NX_EXT) watts; the kernel's pex is the same sum by atomic add."""
        B, P = fate.shape[0], fate.shape[1]
        code, binv = fate[..., 0], fate[..., 5]
        w_all = self._ray_weights(fate, soil_t)
        w = torch.where((code > 0.5) & (binv >= 0), w_all, torch.zeros_like(w_all))
        idx = binv.clamp(min=0).long()
        pex = torch.zeros(B, self.NX_EXT, device=fate.device, dtype=fate.dtype).scatter_add_(1, idx, w)
        # the tag goes where the rays actually landed: power-weighted centroid per bin
        cen = torch.zeros(B, self.NX_EXT, 3, device=fate.device, dtype=fate.dtype)
        cen.scatter_add_(1, idx[..., None].expand(-1, -1, 3), fate[..., 1:4] * w[..., None])
        self._ext_cent = cen / pex[..., None].clamp(min=1e-9)
        return pex

    def tri_aim_bin(self, psi=None):
        """the loaf slot M3 is aimed at, from the turn angle (exact, by geometry)"""
        from tandoor_polar_env import R_POT as _RP, R_DUCT_WALL as _RDW
        psi = (np.asarray(self.spot_phi, dtype=np.float64) - _SP0) if psi is None else psi
        NB = self.n_belt
        out = np.zeros(np.shape(psi), dtype=np.int64)
        _pots = getattr(self, "_ds_rs", None)
        for i, p_ in enumerate(np.atleast_1d(psi)):
            pot_i = (float(self._ds_rs[i]), float(self._ds_zc[i]), float(self._ds_rdw[i])) if _pots is not None else None
            T = self.tri_target(float(np.clip(p_, self.M3_TURN[0], self.M3_TURN[1])), pot=pot_i)
            _rdw_i = pot_i[2] if pot_i is not None else float(_RDW)
            px, py = T[1], -(T[0] - (float(R_POT) - _rdw_i))            # world -> pot
            ph = np.arctan2(py, px)
            out[i] = int(np.clip(((ph + np.pi) / (2 * np.pi) * NB), 0, NB - 1))
        return out

    def _apply_system_design(self):
        """Per-env arrays of the system design for the numpy and torch
        steps (the kernels read the table directly): actuator rate
        scale, lid leak, roti size/energy, loaves per lean, the scaled
        wall conductance and thermal mass, the dish-area factor."""
        B, N = self.num_agents, self.n_nodes
        self._refresh_site_weights()
        D = {k: i - 40 for k, i in self.DS.items()}
        ds = self._fct[:, 40:].detach().cpu().numpy().astype(np.float64)
        # the sand columns: depth and conductivity per agent, layers of >= 5 cm
        self._sand_d = ds[:, D["sand_d"]]; self._sand_k = ds[:, D["sand_k"]]
        self._sand_ka = np.where(self._sand_d >= 0.05, np.clip(np.round(self._sand_d / 0.05), 1, self.KSAND), 0).astype(np.int64)
        self._ds_demand = ds[:, D["demand"]]
        # THE RECEIVER, PER AGENT: which machine (0 cass / 1 tri), the elbow class
        # at the duct mouth, and how far the aim head travels. _bin_pot and the
        # numpy step read these instead of self.tri / self.duct_nozzle.
        self._ds_recv = ds[:, D["recv"]]
        self._ds_noz = ds[:, D["noz"]]
        self._ds_phw = ds[:, D["phw"]]
        # THE SITE: the sun's azimuth offset into each agent's frame [rad], and the pit
        self._ds_azs = ds[:, D["azs"]]
        self._ds_potr, self._ds_poth = ds[:, D["potr"]], ds[:, D["poth"]]
        self._ds_zc, self._ds_rs, self._ds_rdw, self._ds_hd = ds[:, D["zc"]], ds[:, D["rs"]], ds[:, D["rdw"]], ds[:, D["hd"]]
        self._ds_rate = ds[:, D["rate"]]
        self._ds_lid = ds[:, D["lid"]]
        self._ds_bread = ds[:, D["bread"]:D["bread"] + 1]
        self._ds_hb = ds[:, D["hb"]:D["hb"] + 1]
        self._ds_roti = ds[:, D["roti"]:D["roti"] + 1]
        self._ds_lfp = ds[:, D["lfp"]]
        self._ds_lpl = ds[:, D["lpl"]].astype(np.int64)
        self._ds_s2 = ds[:, D["s2"]]
        cap = ds[:, D["cap"]:D["cap"] + 1]
        self._ds_hc = np.asarray(self.node_heat_cap, dtype=np.float64)[None, :] * cap
        self._ds_cs = np.asarray(self.cap_sub, dtype=np.float64)[None, :] * cap
        self._ds_cd = np.asarray(self.cap_deep, dtype=np.float64)[None, :] * cap
        self._ds_g2s = np.asarray(self.g2s, dtype=np.float64)[None, :] * ds[:, D["ins"]:D["ins"] + 1]
        self._ds_g01 = np.tile(np.asarray(self.g01, dtype=np.float64)[None, :], (B, 1))
        self._ds_g12 = np.tile(np.asarray(self.g12, dtype=np.float64)[None, :], (B, 1))
        t = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32).reshape(B), device=self.device)
        self._ds_rate_t, self._ds_lid_t = t(self._ds_rate), t(self._ds_lid)
        self._ds_bread_t, self._ds_hb_t = t(self._ds_bread), t(self._ds_hb)
        self._ds_roti_t, self._ds_lfp_t = t(self._ds_roti), t(self._ds_lfp)
        self._ds_lpl_t, self._ds_s2_t = t(self._ds_lpl), t(self._ds_s2)
        self._sand_ka_t, self._sand_d_t, self._sand_k_t = t(self._sand_ka), t(self._sand_d), t(self._sand_k)
        self._ds_demand_t = t(self._ds_demand)
        self._ds_recv_t, self._ds_noz_t = t(self._ds_recv), t(self._ds_noz)
        self._ds_phw_t = t(self._ds_phw)
        self._ds_azs_t = t(self._ds_azs)
        self._ds_zc_t, self._ds_rs_t, self._ds_rdw_t, self._ds_hd_t = t(self._ds_zc), t(self._ds_rs), t(self._ds_rdw), t(self._ds_hd)

    def _sand_step_t(self, T, Tc, Th, dt):
        """Torch twin of the numpy column step: T (B,N), Tc (B,2,K), Th (B,)
        -> (Tc_new, q_bed (B,2), q_bot (B,), bed (B,) mask)."""
        K = self.KSAND; B = T.shape[0]; dev = T.device
        ka = self._sand_ka_t; d = self._sand_d_t; k = self._sand_k_t
        bed = ka > 0; kas = ka.clamp(min=1.0)
        dz = torch.where(bed, d / kas, torch.full_like(d, 0.05))   # a dummy thickness where there is no bed
        L = torch.arange(K, device=dev, dtype=T.dtype)[None, :]; act = (L < ka[:, None]).to(T.dtype)
        Tc_new = Tc.clone(); q_bed = torch.zeros(B, 2, device=dev, dtype=T.dtype); q_bot = torch.zeros(B, device=dev, dtype=T.dtype)
        for n, j in enumerate((self.n_belt, self.n_belt + 1)):
            A = float(self.node_area[j]); tc = Tc[:, n, :]
            C = A * dz * self.SAND_RC; G = A * k / dz
            Gt = A / (0.0075 / 1.1 + 0.5 * dz / k); Gb = A * 1.0
            qtop = Gt * (T[:, j] - tc[:, 0])
            last = tc.gather(1, (kas - 1).long()[:, None]).squeeze(1)
            qbot = Gb * (last - Th)
            prev = torch.roll(tc, 1, dims=1); nxt = torch.roll(tc, -1, dims=1)
            qa = torch.where(L == 0, qtop[:, None], G[:, None] * (prev - tc))
            qb = torch.where(L == (ka - 1)[:, None], qbot[:, None], G[:, None] * (tc - nxt))
            qin = (qa - qb) * act
            Tc_new[:, n, :] = torch.where(bed[:, None], tc + qin * dt / C[:, None], tc)
            q_bed[:, n] = torch.where(bed, qtop, torch.zeros_like(qtop)); q_bot = q_bot + torch.where(bed, qbot, torch.zeros_like(qbot))
        return Tc_new, q_bed, q_bot, bed

    def _sand_obs_t(self, S):
        """(B,2) the columns' mean temperature over the active layers /1000."""
        K = self.KSAND; NB = self.n_belt; ka = self._sand_ka_t
        L = torch.arange(K, device=S.T.device, dtype=S.T.dtype)[None, :]; act = (L < ka[:, None]).to(S.T.dtype)
        m = (S.T_sand * act[:, None, :]).sum(2) / ka.clamp(min=1.0)[:, None]
        return torch.where((ka > 0)[:, None], m, S.T[:, NB:NB + 2]) / 1000.0

    DESIGN_KEYS = ("d_strip", "u_f2", "r_m4", "r_bore", "w_slot", "r_hole",
                   "strip_th_lo", "strip_th_hi", "strip_wk", "w_strip",
                   "r_strip", "r_duct", "slot_el", "m4_mode")

    def set_design(self, **kw):
        """Re-build the receiver chain in place for a new design point
        (the simulator as the design tool): only the static table's
        receiver block and the duct mouth change, so no membrane solve,
        no mount rebuild - a few ms, and the next step traces it."""
        assert self._cass, "set_design: receiver 'cass' or 'tri' only"
        for k, v in kw.items():
            if k not in self.DESIGN_KEYS:
                raise KeyError(f"set_design: unknown key {k!r}")
            setattr(self, k, v if k == "m4_mode" else float(v))
        self.r_fold = self.r_strip
        self.obstruction = (self.r_fold / float(self.a_mem)) ** 2
        self._build_cass_chain()
        dev = self._sc_base.device
        tail = torch.tensor(self._fc_table, dtype=torch.float32, device=dev)
        self._sc_base = torch.cat([self._sc_base[:106], tail])
        self._sc_base[13] = float(self.r_duct)
        self._build_design_table()
        self._apply_system_design()
        return self

    def m4_args(self):
        """the M4 ellipsoid the Metal trace reads: per agent when a mount has moved it (set_m4_frame), else the shared one"""
        m4 = getattr(self, "_m4_b", None)
        return m4 if m4 is not None else (self.ell_M, self.ell_S, self.ell_ctr_t, self._V0t)

    def set_m4_frame(self, T):
        """M4 on a mount: T (B,4,4) the rigid motion of the mirror from where it was built (tandoor_screws.poe or
        exp_screw). The ellipsoid's foci, centre, vertex and body axes move with it, its shape does not - so a tilted M4
        throws the beam where a tilted M4 throws it. None restores the shared, built M4."""
        if T is None: self._m4_b = None; return
        B = T.shape[0]; R = T[:, :3, :3].float(); t = T[:, :3, 3].float()
        M = self.ell_M.float()[None].expand(B, 3, 3)                                    # rows: the body axes in the world
        ellM = torch.bmm(M, R.transpose(1, 2)).reshape(B, 9).contiguous()               # each row e -> (R e)^T
        ellC = (torch.einsum("bij,j->bi", R, self.ell_ctr_t.float()) + t).contiguous()
        V0 = (torch.einsum("bij,j->bi", R, self._V0t.float()) + t).contiguous()
        self._m4_b = (ellM, self.ell_S.float()[None].expand(B, 3).contiguous(), ellC, V0)

    def _mount(self, day_t, lat_t, hour, pnt=None, mech=None):
        """Mount solve dispatch: the Metal kernel when present (one
        launch, B threads), the batched torch solve otherwise.
        mech (B, MECHW): the mount as screws + compliance per agent
        (tandoor_screws); None takes the env's standing rows
        (self._mech_rows, set by a mount-aware subclass), False forces
        Hashemi's law from pnt."""
        if mech is None: mech = getattr(self, "_mech_rows", None)
        if mech is False: mech = None
        if self._metal is not None:
            self._mnt_prm[0] = float(hour)
            return self._metal.mount(day_t, lat_t, self._mnt_prm,
                                     day_t.shape[0], pnt=pnt,
                                     fct=getattr(self, "_fct", None),
                                     mech=mech)
        from tandoor_mount_batch import mount_batch
        return mount_batch(self, day_t, lat_t, float(hour),
                           day_t.device, pnt=pnt, mech=mech)

    def _finish_trace_build(self, a, g, f_design):
        dev = self.device
        self._geo = _geo_core
        self._geo_is_fused = False
        # THE MEGAKERNEL: on MPS the whole trace runs as one Metal
        # kernel, one thread per ray, registers only. _geo_core stays
        # the reference implementation; verify_megakernel() compares
        # them on identical inputs. Physics changes go: _geo_core ->
        # verify_fusion -> transcribe to MSL -> verify_megakernel.
        self._metal = None
        if dev.type == "mps":
            try:
                from tandoor_metal_kernel import MetalGeo
                self._metal = MetalGeo()
                self._metal.loaf_h = float(np.sqrt(self.bread_area) / 2.0)
                print("  [hashemi] megakernel active (Metal, 1 thread/ray)")
            except Exception as ex:
                print(f"  [hashemi] megakernel unavailable ({ex}); "
                      f"using the fused graph")
        elif dev.type == "cuda":
            # the SAME kernel source, transpiled to CUDA and NVRTC-
            # jitted (tandoor_cuda_kernel) - one source of truth
            try:
                from tandoor_cuda_kernel import CudaGeo
                self._metal = CudaGeo()
                print("  [hashemi] megakernel active (CUDA/NVRTC, "
                      "1 thread/ray)")
            except Exception as ex:
                print(f"  [hashemi] CUDA megakernel unavailable "
                      f"({ex}); using the fused graph")
        if self.fuse:
            try:
                self._geo = torch.compile(_geo_core, dynamic=False)
                self._geo_is_fused = True
            except Exception as ex:
                print(f"  [hashemi] torch.compile unavailable ({ex}); "
                      f"running the eager reference")
        self._geo_ref = _geo_core
        if self.receiver == "focus":
            # the focus chain runs the eager reference core (no compile)
            self._geo = _geo_core_focus
            self._geo_ref = _geo_core_focus
            self._geo_is_fused = False
        if self._cass:
            # torch reference only (no Metal port yet): ladder/design use
            self._geo = _geo_core_cass
            self._geo_ref = _geo_core_cass
            self._geo_is_fused = False
        pk = 0.9 * np.pi * a * a * 0.88 * (1 - self.obstruction)
        print(f"  [hashemi] dish {np.pi*a*a:.1f} m2 SPHERE R="
              f"{self.R_sphere:.1f} m (f=R/2={self.R_sphere/2:.2f}, "
              f"design {f_design:.2f}) "
              f"orbit g={g:.1f} -> fold at z={self.z_fold:.2f} m, "
              f"waist z={self.z_waist:.1f}, M5 pit z={self.z_m5:.2f}")
        print(f"  [hashemi] fold r={self.r_fold:.2f} m (obstruction "
              f"{self.obstruction*100:.0f}%), slot {2*self.slot_w2:.2f} m "
              f"({self.slot_loss*100:.0f}%), waist z={self.z_waist:.2f} in "
              f"tube [{self.z_tube[0]:.1f},{self.z_tube[1]:.1f}], M5 "
              f"r={self.r_m5:.2f} at core base, track el "
              f"{self.el_min_h:.0f}-{self.el_max_h:.0f} (NO gate), "
              f"chain {self._loss_chain:.3f}")
        print(f"  [hashemi] machine wholly on the roof: ring rail R {self.r_rail:.1f}, "
              f"dish sweep r={g+a:.1f} m inside the parapet; beam sealed "
              f"below the roof deck")

    def _gpu_full_step(self, actions):
        """The whole step on-device (tandoor_gpu_step). Python keeps the
        scalar sun clock, the rare synchronized day-over branch, and one
        obs/reward copy into the pufferlib buffers."""
        from tandoor_gpu_step import GpuState, gpu_step
        import tandoor_gpu_step as G
        if self._gpu is None:
            from tandoor_fused_step import make_state
            self._gpu = make_state(self)
        if getattr(self._gpu, "fused", False):
            from tandoor_fused_step import fused_full_step
            return fused_full_step(self, actions)
        S, dev, B = self._gpu, self.device, self.num_agents
        rew, cut, p_in, e_el, e_az = gpu_step(self, actions)
        self._p_in_t = p_in
        self._e_el_t, self._e_az_t = e_el, e_az
        self.truncations[:] = False
        if bool(cut.any()):
            from tandoor_mount_batch import solar_batch
            el1, az1r, _ = solar_batch(S.lat_v, S.day_v,
                                       float(self.t_solar[0]), az_off=self._ds_azs_t)
            az1d = torch.rad2deg(az1r)
            # ALWAYS COLD on a lost-sun truncation. The warm_frac draw
            # here was a lottery: 20% chance of a free 540-620 K pot for
            # crashing the episode - and a trained policy found it
            # (ep_len pinned at 24, cook-and-crash at 220M steps). A
            # fresh pot mid-day is cold; warm mornings belong to
            # day-over only.
            newT = torch.full((B, self.n_nodes), 350.0, device=dev) \
                + (S.u(B, self.n_nodes) - 0.5) * 30.0
            cutf = cut[:, None]
            # CHARGE-AND-CRASH closed (mirror of the numpy path): give
            # back the accrued preheat shaping and any load bonuses
            # still in flight before the state is overwritten
            # exact potential of the wiped state + in-flight load
            # bonuses (charge-and-crash closed)
            phys_cut = bool(getattr(self, "night_carry", 0))
            give = 0.3 * S.has_bread.float().sum(1) \
                + 2.0 * (S.bread_E / self._ds_roti_t[:, None]) \
                .clamp(0.0, 1.0).sum(1) \
                + 0.05 * (S.T[:, : self.n_belt].clamp(max=T_COOK_LO)
                          - 350.0).clamp(min=0.0).sum(1)
            if phys_cut:
                give = torch.zeros_like(give)      # nothing wiped, nothing refunded
            rew = rew - (give + self.cut_penalty) * cut.float()
            if not phys_cut:
                S.T = torch.where(cutf, newT, S.T)
                S.T_sub = torch.where(cutf, newT, S.T_sub)
                S.T_deep = torch.where(cutf, newT, S.T_deep)
                S.T_sand = torch.where(cut[:, None, None], newT[:, self.n_belt:self.n_belt + 2, None].expand_as(S.T_sand), S.T_sand)
                S.T_halo = torch.where(cut, torch.full_like(S.T_halo, 300.0),
                                       S.T_halo)
            for nm in (("ep_rotis", "ep_scorch", "ep_spall", "ep_return", "ep_len")
                       + (() if phys_cut else ("bread_E", "bread_t", "bread_C"))):
                v = getattr(S, nm)
                setattr(S, nm, torch.where(cut[:, None] if v.dim() > 1
                                           else cut,
                                           torch.zeros_like(v), v))
            if not phys_cut:
                S.has_bread = S.has_bread & ~cutf
                S.p_set = torch.where(cut, torch.full_like(S.p_set, self.p0),
                                      S.p_set)
                S.p_act = torch.where(cut, torch.full_like(S.p_act, self.p0),
                                      S.p_act)
            S.el_m = torch.where(
                cut, (el1 + 0.3 * S.n(B)).clamp(self.el_min_h,
                                                self.el_max_h), S.el_m)
            S.az_m = torch.where(cut, az1d + 0.3 * S.n(B), S.az_m)
            S.lost_ct = torch.where(cut, torch.zeros_like(S.lost_ct),
                                    S.lost_ct)
            # clear the shaping potential to the POST-reset pointing:
            # leaving the stale pre-reset error refunded the whole
            # drift (+0.1*(4.0 - 0.3)) on the first step after reset -
            # the exit penalty for losing the sun netted to zero
            e_el_r = S.el_m - el1
            e_az_r = (S.az_m - az1d) * torch.cos(torch.deg2rad(el1))
            S.e_el_prev = torch.where(cut, e_el_r, S.e_el_prev)
            S.e_az_prev = torch.where(cut, e_az_r, S.e_az_prev)
            S.belt_prev = torch.where(
                cut, newT[:, : self.n_belt].max(1).values, S.belt_prev)
            # the cleared pointing must also reach THIS step's obs and
            # the host mirrors (autoreset: a truncation step reports the
            # new episode's state, matching the numpy path's rebuild)
            e_el = torch.where(cut, e_el_r, e_el)
            e_az = torch.where(cut, e_az_r, e_az)
            self._e_el_t, self._e_az_t = e_el, e_az
            self.truncations[:] = cut.cpu().numpy()
            self._trunc_t = cut.float()
            self._trunc_live = True
        else:
            self._trunc_live = False
        infos = []
        ts0 = float(self.t_solar[0])
        hr = int(ts0)
        if getattr(self, "hourly_metric", 0) \
                and hr > getattr(self, "_hr_mark", 8) \
                and ts0 < self.day_end:
            cur = float(S.day_rotis.mean())
            infos.append({"rotis_per_hour":
                          cur - getattr(self, "_hr_rotis", 0.0),
                          "rotis_per_day": cur,
                          "scorched": float(S.ep_scorch.mean())})
            self._hr_rotis = cur
            self._hr_mark = hr
        if float(self.t_solar[0]) >= self.day_end:
            # end-of-day stuff-the-oven closed (mirror of numpy paths)
            inflight = 0.3 * S.has_bread.float().sum(1) \
                + 2.0 * (S.bread_E / self._ds_roti_t[:, None]) \
                .clamp(0.0, 1.0).sum(1)
            rew = rew - inflight
            S.ep_return = S.ep_return - inflight
            infos.append({
                "rotis_per_day": float(S.day_rotis.mean()),
                "scorched": float(S.ep_scorch.mean()),
                "spall_events": float(S.ep_spall.mean()),
                "form_minutes": float(S.form_time.mean() * self.dt / 60),
                "episode_return": float(S.ep_return.mean()),
                "episode_length": float(S.ep_len.mean()),
            })
            self.terminals[:] = True
            self.t_solar[:] = self.day_start
            need_dawn = torch.zeros(B, dtype=torch.bool, device=dev)
            if getattr(self, "night_carry", 0) and not getattr(self, "consecutive_days", 1):
                if self.day_random:
                    self.day_v[:] = self.rng.integers(1, 366, B); self.day = int(self.day_v[0])
                if self.lat_random:
                    self.lat_v[:] = self.rng.uniform(15.0, 35.0, B); self.lat = float(self.lat_v[0])
                S.lat_v = torch.as_tensor(self.lat_v.astype(np.float32), device=dev)
                S.decl_formed = 23.44 * torch.sin(2.0 * np.pi * (284.0 + torch.as_tensor(self.day_v.astype(np.float32), device=dev)) / 365.0)
            elif getattr(self, "night_carry", 0):
                self.day_v[:] = self.day_v % 365 + 1
                self.day = int(self.day_v[0])
                decl_t = 23.44 * torch.sin(2.0 * np.pi * (284.0 + torch.as_tensor(self.day_v.astype(np.float32), device=dev)) / 365.0)
                need_dawn = (decl_t - S.decl_formed).abs() >= self.form_drift
                S.decl_formed = torch.where(need_dawn, decl_t, S.decl_formed)
                rew = rew - 0.02 * self.form_min * need_dawn.float()
            else:
                if self.day_random:
                    self.day_v[:] = self.rng.integers(1, 366, B)
                    self.day = int(self.day_v[0])
                if self.lat_random:
                    self.lat_v[:] = self.rng.uniform(15.0, 35.0, B)
                    self.lat = float(self.lat_v[0])
            S.day_v = torch.as_tensor(self.day_v.astype(np.float32),
                                      device=dev)
            S.lat_v = torch.as_tensor(self.lat_v.astype(np.float32),
                                      device=dev)
            from tandoor_mount_batch import solar_batch
            el1, az1r, _ = solar_batch(S.lat_v, S.day_v,
                                       torch.full_like(S.day_v, self.day_start), az_off=self._ds_azs_t)
            az1d = torch.rad2deg(az1r)
            if self.night_carry:
                self._night_cool_torch(S)
            else:
                warm = (S.u(B) < self.warm_frac)
                S.T = torch.where(
                    warm[:, None],
                    (465.0 + 40.0 * S.u(B))[:, None].expand(B, self.n_nodes),
                    torch.full((B, self.n_nodes), 350.0, device=dev)) \
                    + (S.u(B, self.n_nodes) - 0.5) * 30.0
                S.T_sub = S.T.clone()
                S.T_deep = S.T.clone()
                S.T_sand = S.T[:, self.n_belt:self.n_belt + 2, None].expand_as(S.T_sand).clone()
                S.T_halo = torch.where(warm, 395.0 + 20.0 * S.u(B),
                                       torch.full((B,), 300.0, device=dev))
            for nm in ("ep_rotis", "ep_scorch", "ep_spall", "ep_return",
                       "ep_len", "bread_E", "bread_t", "bread_C",
                       "form_time", "wind_g", "cloud", "p_dist",
                       "day_rotis", "orders", "shelf", "sold"):
                setattr(S, nm, torch.zeros_like(getattr(S, nm)))
            S.form_time = need_dawn.float() * float(self.form_min)
            S.ep_return = S.ep_return - 0.02 * self.form_min * need_dawn.float()
            self._hr_mark = int(self.day_start)
            self._hr_rotis = 0.0
            S.has_bread = torch.zeros_like(S.has_bread)
            S.p_set = torch.full_like(S.p_set, self.p0)
            S.p_act = torch.full_like(S.p_act, self.p0)
            S.shutter = torch.ones_like(S.shutter)
            S.hold_p = torch.full_like(S.hold_p, 4.0)
            S.hold_s = torch.full_like(S.hold_s, 6.0)
            S.hold_j = torch.full_like(S.hold_j, 6.0)
            # mirror numpy day-over: membrane jammed at p0, re-formed
            # to the NEW day's declination (per-agent, kernel formula)
            S.jammed = torch.ones_like(S.jammed)
            S.f_locked = torch.full_like(S.f_locked, self.p0)
            if not getattr(self, "night_carry", 0):
                S.decl_formed = 23.44 * torch.sin(
                    2.0 * np.pi * (284.0 + S.day_v) / 365.0)
            S.soil = 0.90 + 0.08 * S.u(B)
            S.el_m = (el1 + 0.3 * S.n(B)).clamp(self.el_min_h,
                                                self.el_max_h)
            S.az_m = az1d + 0.3 * S.n(B)
            S.e_el_prev = S.el_m - el1
            S.e_az_prev = (S.az_m - az1d) \
                * torch.cos(torch.deg2rad(el1))
            e_el, e_az = S.e_el_prev, S.e_az_prev
            self._e_el_t, self._e_az_t = e_el, e_az
            S.belt_prev = S.T[:, :self.n_belt].max(1).values
            az_dawn = az1r
        else:
            self.terminals[:] = False
            az_dawn = None
        return self._gpu_obs(S, dev, B, rew, p_in, e_el, e_az, infos, az_rad=az_dawn)

    def _gpu_obs(self, S, dev, B, rew, p_in, e_el, e_az, infos, az_rad=None):
        # ---- obs, one assembly + one copy
        ts = torch.full((B,), float(self.t_solar[0]), device=dev)
        if getattr(self, "design_rand", 0) or getattr(self, "site_rand", 0):
            # THE HORIZON OBS wants the sun's azimuth in the site's frame (rad). The
            # day-over callers pass the dawn sun they just solved (az1r); anyone else
            # gets it from the solar solve at this hour - the same solve the mount uses.
            if az_rad is None:
                from tandoor_mount_batch import solar_batch
                _, az_rad, _ = solar_batch(S.lat_v, S.day_v, float(self.t_solar[0]), az_off=self._ds_azs_t)
            hz_obs = self._hz_obs(az_rad)
        h = (ts - 8.0) / 8.0
        enc_el = ((e_el + 0.03 * S.n(B)) / 0.5).clamp(-self.enc_clamp, self.enc_clamp)
        enc_az = ((e_az + 0.03 * S.n(B)) / 0.5).clamp(-self.enc_clamp, self.enc_clamp)
        obs = torch.cat([
            torch.stack([torch.sin(np.pi * h), torch.cos(np.pi * h),
                         S.dni / 1000.0], 1),
            S.T / 1000.0,
        ] + ([torch.stack([S.T_sub[:, : self.n_belt].mean(1) / 1000.0,
                           S.T_deep[:, : self.n_belt].mean(1) / 1000.0,
                           S.T_halo / 1000.0], 1)]
             if self.wall_obs else []) + [
            torch.stack([(S.p_act - self.p0) / 60.0, S.shutter,
                         S.wind / 10.0,
                         (S.bore[:, 0] / 0.1).clamp(-2, 2),
                         (S.bore[:, 1] / 0.1).clamp(-2, 2),
                         (S.load_timer / 45.0).clamp(0, 2)], 1),
            S.bread_E / self._ds_roti_t[:, None],
            S.bread_C,
            p_in[:, None] / 6000.0,
            torch.stack([S.jammed.float(),
                         ((S.decl_formed
                           - getattr(S, "decl_now", S.decl_formed))
                          .abs() / 10.0).clamp(0, 3),
                         enc_el, enc_az], 1),
        ] + ([torch.stack(
            [(S.spot_phi - _SP0) / 2.0,
             (S.spot_z - _SZ0) / 1.0], 1),
            torch.nn.functional.one_hot(
                ((S.spot_phi + np.pi) / (2 * np.pi)
                 * self.n_belt).long() % self.n_belt,
                self.n_belt).float()] if self.elbow_aim else [])
          + ([S.has_bread.float()] if getattr(self, "load_ctrl", 0)
             else [])
          + [self._sand_obs_t(S)]
          + ([torch.stack([(S.orders / 10.0).clamp(0, 3), (S.shelf / 10.0).clamp(0, 3)], 1)] if self.demand else [])
          + ([self._dsn_t, hz_obs] if (getattr(self, "design_rand", 0) or getattr(self, "site_rand", 0)) else []),
            1)
        return obs, rew, infos

    def step_torch(self, actions):
        """Device-native step: MPS actions in, MPS obs/rewards out. No
        numpy anywhere - the fast-collect loop's contract. Identical
        trajectory to the numpy wrapper (same core, same draws)."""
        obs, rew, infos = self._gpu_full_step(actions)
        rd = getattr(self, "reward_div", 1.0)
        if rd != 1.0:
            rew = rew / rd
        if not hasattr(self, "_term_zeros"):
            self._term_zeros = torch.zeros(
                self.num_agents, dtype=torch.float32,
                device=self.device)
        term = self._term_zeros if not bool(self.terminals[0]) else \
            torch.ones_like(self._term_zeros)
        trunc = getattr(self, "_trunc_t", None)
        if trunc is None or not self._trunc_live:
            trunc = self._term_zeros
        if self.render_mode == "human":
            # THE RENDERER NEEDS THE TRACE, and step() is not the only way in. tandoor_fast_collect routes evaluation
            # through step_torch whenever the env exposes it, and step_torch used to skip these two lines - so _hv was
            # never filled, the renderer had no rays, no dish, no fold, no duct, and drew the room and the pot alone.
            # Same gate and same pair as the numpy path: only in human mode, so training never pays for it.
            self._sync_from_gpu()
            self._render_trace()
        return obs, rew, term, trunc, infos

    def _aim_dirs(self, B, dev):
        """Per-env elbow aim directions a1 (B,3) from the spot state
        - the same construction _bin_pot uses, so kernel and fallback
        can never disagree about where the mirror points. The sphere is this
        agent's pit (table columns 78/79); the elbow itself stays at the nominal
        mouth - the machine is built to the wall, the pit varies behind it."""
        M = self._noz2["M"]
        sp, szv = self._spot_view
        ph = (sp if torch.is_tensor(sp) else
              torch.as_tensor(sp)).to(dev, torch.float32)
        zt = (szv if torch.is_tensor(szv) else
              torch.as_tensor(szv)).to(dev, torch.float32)
        rt = torch.sqrt(
            (self._ds_rs_t.to(zt.dtype).reshape(-1)**2 - (zt - self._ds_zc_t.to(zt.dtype).reshape(-1))**2).clamp(min=1e-4)) * 0.999
        a1 = torch.stack([rt * torch.cos(ph) - M[0],
                          rt * torch.sin(ph) - M[1],
                          zt - M[2]], 1)
        return (a1 / a1.norm(dim=1, keepdim=True)).contiguous()

    def _metal_trace(self, p_eff, sigma_b, off, soil, e_el, e_az, mnt):
        """Megakernel call, per-env geometry (the gpu_step path).
        mnt is mount_batch's output: every env its own sun. Zero
        per-step host->device work - the 03bda4ee invariant, restored
        and now structural (the geometry never touches numpy)."""
        dev = self.device
        self._apply_m3_turn()                 # M3 where the actuator has put it
        soil = self._shade(soil, mnt)         # the neighbourhood's horizon, on the beam
        B, P_ = p_eff.shape[0], len(self._hx)
        vp = mnt["vp"].reshape(B, 21).contiguous()
        Mt = mnt["Mt"].contiguous()
        Cd = mnt["Cd"].contiguous()
        Acan_t = mnt["Acan"].contiguous()
        scb = mnt["scb"].contiguous()
        self._ray_scale = scb[:, 4] * scb[:, 5]
        sc = self._sc_base
        if getattr(self, "_det_trace", False):
            du = torch.zeros(B, P_, device=dev)
            de = torch.zeros(B, P_, device=dev)
            upick = torch.full((B, P_), 0.5, device=dev)
            us = torch.full((B, P_), 0.5, device=dev)
        else:
            du = torch.randn(B, P_, generator=self._gen, device=dev)
            de = torch.randn(B, P_, generator=self._gen, device=dev)
            upick = torch.rand(B, P_, generator=self._gen, device=dev)
            us = torch.rand(B, P_, generator=self._gen, device=dev)
        f_b = self._fct[:, 53]                     # per-env focal length (dish scale)
        dvec = torch.stack([2.0 * f_b * torch.deg2rad(e_el),
                            2.0 * f_b * torch.deg2rad(e_az)],
                           1)[:, None, :]
        from tandoor_polar_env import level_of
        lv = level_of(p_eff / self.p0, self.level_frac)       # against the ladder (the kernel's step_pre does the same)
        if self._metal is not None:
            args = (self._pts_l, self._nrm_l, lv, du, de, upick, us,
                    sigma_b, Acan_t, Mt, Cd, dvec, off, vp, sc) + self.m4_args()
            _, _, per = self._metal(*args, self._ray_pw, soil,
                                    self.n_nodes,
                                    self._aim_dirs(B, dev), scb,
                                    fct=self._fct)
            return per
        # no Metal on this device (CUDA/CPU): the fused torch graph
        # with broadcast-shaped per-env geometry, binned identically
        args = (self._pts_l, self._nrm_l, lv, du, de, upick, us,
                sigma_b, Acan_t.view(B, 1, 3, 3), Mt,
                Cd[:, None, :], dvec, off,
                mnt["vp"][:, :, None, :], sc, scb,
                self.ell_M, self.ell_S, self.ell_ctr_t, self._V0t)
        if self._cass:
            args = args + (self._fct,)
        out = self._geo(*args)
        (through_b, w_ray, dy, dz, d3) = out[:5]
        through = through_b.float() * w_ray
        self._inlet_thru = (through.sum(1) / w_ray.sum(1).clamp(min=1e-9)).detach().cpu().numpy()   # what the inlet admitted (see the metal branch)
        # _bin_pot returns cpu (its numpy-path contract) - gpu_step
        # needs it back on the compute device
        return self._bin_pot(dy - off[:, 0:1], dz - off[:, 1:2],
                             d3[..., 1], -d3[..., 0], d3[..., 2],
                             through, soil * self._ds_s2_t.to(soil.device), B, P_).to(soil.device)

    # measured fold-shadow fraction vs beta (solstice ladders,
    # slotless). NOT sign-symmetric: on the negative side the fold
    # disc turns broadside to low sun and the tower shades the
    # below-fold dish - the negative curve floors at ~12% (measured
    # peak of scheduled power at -36; -42/-48 are collision geometry
    # anyway and gain nothing).
    _SHADOW_B = (0.0, 12.0, 19.0, 24.0, 28.0, 32.0, 36.0, 40.0)
    _SHADOW_F = (0.33, 0.21, 0.15, 0.142, 0.09, 0.046, 0.0155, 0.0)
    _SHADOW_BN = (0.0, 24.0, 30.0, 36.0, 42.0)
    _SHADOW_FN = (0.33, 0.208, 0.156, 0.124, 0.119)

    def _beta_now(self, el):
        """The SIGNED beta schedule. beta has a sign: positive tilts
        the beam DOWN (el_b = el - b, dish rides high at low sun),
        negative tilts it UP (el_b = el + |b|, dish sinks BELOW the
        fold). With beta_cap_z set, each step picks the branch of
        larger scheduled power cos(b/2)(1 - shadow(|b|)):
          positive: full beta_dev if the rim top stays under the cap,
            else tapered to the cap (fixed point on the rim eqn);
            slot bound b >= el - (el_x-1).
          negative: |b| = min(beta_dev, el_x - 2 - el) - the slot
            bound from above (el + |b| < el_x); the dish sinks, so
            the cap is free by construction.
        Winter noon picks negative (dish at ~5.5 m); high sun picks
        positive (dish dives anyway). The seam el ~ 40-48 pays a few
        shadow points; the envelope never exceeds the cap."""
        # the slot lower bound protects an UNCUT dish; the stock cut
        # dish is allowed to cross the post - that is what the cut is
        # for. Without the gate the retro baseline gets silently
        # forced off-axis at high sun (measured +36%/yr - a real
        # schedule discovery, but not the historical baseline).
        lo = max(0.0, el - (self.el_x - 1.0)) if self.slotless else 0.0
        bp = float(np.clip(self.beta_dev, lo, max(self.beta_dev, lo)))
        if self.beta_cap_z is None:
            return bp
        # positive branch, tapered to the rim cap
        for _ in range(3):
            naim_el = np.radians(el - 0.5 * bp)
            allow = self.beta_cap_z \
                - self.a_mem * max(np.cos(naim_el), 0.0)
            sarg = np.clip((self.z_fold - allow) / self.g_orbit,
                           -1.0, 1.0)
            hi = el - np.degrees(np.arcsin(sarg))
            bp = float(np.clip(min(self.beta_dev, hi), lo,
                               max(self.beta_dev, lo)))
        # negative branch (only exists while the slot bound allows it
        # and the positive branch is actually pinched by the cap)
        bn = -min(self.beta_dev, max(self.el_x - 2.0 - el, 0.0))
        if bn == 0.0 or bp >= self.beta_dev - 1e-9:
            return bp
        def sh(b):
            if b >= 0:
                return float(np.interp(b, self._SHADOW_B,
                                       self._SHADOW_F))
            return float(np.interp(-b, self._SHADOW_BN,
                                   self._SHADOW_FN))
        score = lambda b: np.cos(np.radians(b) / 2.0) * (1.0 - sh(b))
        return bn if score(bn) > score(bp) else bp

    # ------------------------------------------------------------ trace #
    @staticmethod
    def _solve_cpc(a_thr, r_entry, height, n_seg=8):
        """Truncated Winston CPC profile knots [(z, r)], z measured up
        from the throat. Parametrization (Welford & Winston):
          f = a'(1+sin th),  phi in [2 th, pi/2 + th]
          r(phi) = 2 f sin(phi-th)/(1-cos phi) - a'
          z(phi) = 2 f cos(phi-th)/(1-cos phi)
        (checked: r,z at phi=pi/2+th -> (a', 0); at phi=2 th ->
        (a'/sin th, full length)). Bisect th so the profile passes
        through (height, r_entry); if the envelope cannot host any
        truncated CPC that wide, fall back to the widest-acceptance
        profile (th = asin(a'/r_entry)) and report its actual mouth.
        """
        def prof(th):
            f = a_thr * (1.0 + np.sin(th))
            phi = np.linspace(np.pi/2 + th, 2*th + 1e-4, 3000)
            r = 2*f*np.sin(phi - th)/(1 - np.cos(phi)) - a_thr
            z = 2*f*np.cos(phi - th)/(1 - np.cos(phi))
            return z, r

        def r_at(th, zq):
            z, r = prof(th)
            if z[-1] < zq:
                return r[-1] + (zq - z[-1]) * 1e3   # too short: punish
            return float(np.interp(zq, z, r))

        th_hi = float(np.arcsin(min(a_thr / r_entry, 1.0)))  # widest
        lo, hi = 0.05, th_hi
        g_lo, g_hi = r_at(lo, height) - r_entry, r_at(hi, height) - r_entry
        if g_lo * g_hi > 0:
            th = th_hi          # envelope inconsistent: widest CPC
        else:
            for _ in range(60):
                mid = 0.5 * (lo + hi)
                if (r_at(mid, height) - r_entry) * g_lo <= 0:
                    hi = mid
                else:
                    lo = mid
            th = 0.5 * (lo + hi)
        z, r = prof(th)
        zk = np.linspace(0.0, height, n_seg + 1)
        rk = np.interp(zk, z, r)
        print(f"  [hashemi] CPC lip: Winston profile, acceptance "
              f"{np.degrees(th):.1f} deg, throat {a_thr:.2f} -> mouth "
              f"{rk[-1]:.3f} m over {height:.2f} m ({n_seg} segments)")
        return list(zip(zk, rk))

    def _set_hv(self, p, h1, h2, h3, ok, ok_pre, in_slot, desc, through, u, el, az, C_dish, ub, naim, el_b):
        """the renderer's view of one agent's rays. The per-ray 'made it' flags differ by chain: the fold machine ends
        at the duct (through_b), the Cassegrain has no M5 so it ends at the tube (ok_post_tube), and handing the
        renderer the fold flags on a Cassegrain drew every ray as lost."""
        self._hv = dict(dish=p[0].cpu().numpy(), fold=h1[0].cpu().numpy(),
                        m5=h2[0].cpu().numpy(), duct=h3[0].cpu().numpy(),
                        ok=ok[0].cpu().numpy(), ok_pre=ok_pre[0].cpu().numpy(),
                        slot=in_slot[0].cpu().numpy(), desc=desc[0].cpu().numpy(),
                        through=through[0].cpu().numpy(),
                        u=u, el=el, az=float(az), C=C_dish,
                        ub=ub, naim=naim, el_b=el_b)

    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        """Live ARTIST trace: dish -> fixed 2-axis fold -> waist ->
        fixed ellipsoidal M5 -> duct -> pot. The geometry runs in
        _geo_core - torch.compile-fused when available, eager otherwise;
        both are the same function, and verify_fusion() checks the
        compiled path agrees ray-for-ray."""
        dev = self.device
        self._apply_m3_turn()                 # M3 where the actuator has put it
        B, P = np.asarray(p_eff).shape[0], len(self._hx)
        el, az, u_np = _sim.solar_position(self.lat, self.day,
                                           float(self.t_solar[0]))
        if not (self.el_min_h <= el <= self.el_max_h):
            return torch.zeros(B, self.n_nodes + self.n_belt)
        # level_frac is NOT uniformly spaced (0.70, 0.82, 0.90, 0.96, 1.00, 1.04, 1.10 - the steps tighten around
        # the nominal), so a linear inverse does not land on the levels it came from: it maps the NOMINAL pressure
        # p_eff = p0 to level 4.5 instead of 4, half a step of defocus on every render trace. mems[4] is the level
        # the secondary was designed for. Interpolate against the table itself.
        lv = np.interp(np.asarray(p_eff) / self.p0, self.level_frac,
                       np.arange(self.N_LEVELS, dtype=np.float64))
        P_ = len(self._hx)
        if getattr(self, "_det_trace", False):
            du = torch.zeros(B, P_, device=dev)
            de = torch.zeros(B, P_, device=dev)
            upick = torch.full((B, P_), 0.5, device=dev)
            us = torch.full((B, P_), 0.5, device=dev)
        else:
            du = torch.randn(B, P_, generator=self._gen, device=dev)
            de = torch.randn(B, P_, generator=self._gen, device=dev)
            upick = torch.rand(B, P_, generator=self._gen, device=dev)
            us = torch.rand(B, P_, generator=self._gen, device=dev)
        sigb_t = torch.as_tensor(np.asarray(sigma_b), dtype=torch.float32,
                                 device=dev)
        lv_t = torch.as_tensor(lv, dtype=torch.float32, device=dev)
        # PER-ENV SUN: the same batched mount solve as the gpu path
        # - one function, both twins, no scalar copy to drift
        from tandoor_mount_batch import mount_batch
        day_t = torch.as_tensor(self.day_v, dtype=torch.float32,
                                device=dev)
        lat_t = torch.as_tensor(self.lat_v, dtype=torch.float32,
                                device=dev)
        pnt_np = torch.as_tensor(np.stack([np.asarray(self.el_m, dtype=np.float32),
                                           np.asarray(self.az_m, dtype=np.float32)], 1),
                                 device=dev)
        mnt = mount_batch(self, day_t, lat_t,
                          float(self.t_solar[0]), dev, pnt=pnt_np)
        soil = self._shade(soil, mnt)                    # the neighbourhood's horizon, on the beam
        Mt = mnt["Mt"].contiguous()
        Cd = mnt["Cd"].contiguous()
        Acan_t = mnt["Acan"].contiguous()
        scb = mnt["scb"].contiguous()
        self._ray_scale = scb[:, 4] * scb[:, 5]
        sc = self._sc_base
        f_np = self._fct[:, 53].detach().cpu().numpy().astype(np.float64)
        dvec = torch.tensor(
            np.stack([2.0 * f_np * np.radians(self._e_el),
                      2.0 * f_np * np.radians(self._e_az)], 1),
            dtype=torch.float32, device=dev)[:, None, :]
        off = torch.as_tensor(offset_w, dtype=torch.float32, device=dev)
        if self._metal is not None and self.render_mode != "human":
            args = (self._pts_l, self._nrm_l, lv_t, du, de, upick,
                    us, sigb_t, Acan_t,
                    Mt, Cd, dvec, off,
                    mnt["vp"].reshape(B, 21).contiguous(), sc,
                    self.ell_M, self.ell_S, self.ell_ctr_t,
                    self._V0t)
            soil_t = torch.as_tensor(np.asarray(soil),
                                     dtype=torch.float32, device=dev)
            thr, out6, per = self._metal(*args, self._ray_pw,
                                         soil_t, self.n_nodes,
                                         self._aim_dirs(B, dev), scb,
                                         fct=self._fct)
            # WHAT THE INLET ADMITTED, from the trace, not from geometry: the
            # through weight over the pre-gate ray weight (out6[...,5] = sh_w).
            # All upstream gates included, so this is end-to-end. The geometric
            # cone that used to be on the HUD overstated the clipping ~3x.
            _w = out6.reshape(B, -1, 6)[..., 5]
            self._inlet_thru = (thr.reshape(B, -1).sum(1) / _w.sum(1).clamp(min=1e-9)).detach().cpu().numpy()
            self._fate = getattr(self._metal, "last_fate", None)                 # the miss ledger
            self._pex = getattr(self._metal, "last_pex", None)                   # exterior flux (B, NX)
            if self._fate is not None:
                self._ray_weights(self._fate, soil_t)                            # _w_total / _w_by_code on this path too
            return per.cpu()
        args = (self._pts_l, self._nrm_l, lv_t, du, de, upick, us,
                sigb_t, Acan_t.view(B, 1, 3, 3), Mt,
                Cd[:, None, :], dvec, off,
                mnt["vp"][:, :, None, :], sc, scb,
                self.ell_M, self.ell_S, self.ell_ctr_t, self._V0t)
        if self._cass:
            args = args + (self._fct,)
        try:
            out = self._geo(*args)
        except Exception as ex:
            if self._geo_is_fused:
                print(f"  [hashemi] fused core failed ({type(ex).__name__}:"
                      f" {ex}); falling back to eager permanently")
                self._geo = self._geo_ref
                self._geo_is_fused = False
                out = self._geo(*args)
            else:
                raise
        (through_b, w_ray, dy, dz, d3, ok, ok_pre_tube, ok_post_tube,
         lit, in_slot, graze, rad1, p, h1, h2, h3, desc) = out[:17]
        self._fate = out[17].detach() if len(out) > 17 else None       # the miss ledger (cass/tri twin)
        self._pex = (self._deposit_exterior(self._fate, torch.as_tensor(np.asarray(soil), dtype=torch.float32, device=self._fate.device))
                     if self._fate is not None else None)              # exterior flux, the torch twin of pex
        through = through_b.float() * w_ray
        self._inlet_thru = (through.sum(1) / w_ray.sum(1).clamp(min=1e-9)).detach().cpu().numpy()   # what the inlet admitted (see the metal branch)
        u = mnt["u"][0].cpu().numpy()
        ub = mnt["ub"][0].cpu().numpy()
        naim = mnt["naim"][0].cpu().numpy()
        el_b = float(mnt["el_b"][0])
        C_dish = mnt["Cd"][0].cpu().numpy()
        if self.render_mode == "human" and self._cass:
            # THE CASSEGRAIN ENDS AT THE TUBE. 'ok' is the fold chain's M5 acceptance and 'through_b' is gated on it;
            # this chain has no M5, so both are identically zero however well the machine is working - measured
            # lit 85.7, pre_tube 76.0, post_tube 28.1, ok 0.0, through_b 0.0, while the megakernel deposited 2.741 kW.
            # Reporting those two as the last rungs told the renderer every ray was lost, so it drew none of them.
            # The last stage this chain actually has is post_tube; the delivery itself is accounted in 'per'.
            self._ladder = dict(
                shadow=1.0 - float(lit[0].float().mean()),
                slot=0.0,
                strip=float((lit[0] & ~graze[0] & ~ok_pre_tube[0]).float().mean()),
                graze=float((lit[0] & graze[0]).float().mean()),
                tube=float((ok_pre_tube[0] & ~ok_post_tube[0]).float().mean()),
                through=float(ok_post_tube[0].float().mean()))
            self._set_hv(p, h1, h2, h3, ok_post_tube, ok_pre_tube, in_slot, desc, ok_post_tube,
                         u, el, az, C_dish, ub, naim, el_b)
        elif self.render_mode == "human" and self.receiver == "focus":
            ok1 = lit & ~graze & (rad1 < self.r_m1)
            self._ladder = dict(
                shadow=1.0 - float(lit[0].float().mean()),
                slot=0.0,
                fold=float((lit[0] & ~graze[0] & ~(rad1[0] < self.r_m1)
                            ).float().mean()),
                m2=float((ok1[0] & ~ok_pre_tube[0]).float().mean()),
                tube=float((ok_pre_tube[0] & ~ok_post_tube[0]).float().mean()),
                m5=float((ok_post_tube[0] & ~ok[0]).float().mean()),
                duct=float((ok[0] & ~through_b[0]).float().mean()),
                through=float(through[0].float().mean()))
            self._set_hv(p, h1, h2, h3, ok, ok_pre_tube, in_slot, desc, through_b,
                         u, el, az, C_dish, ub, naim, el_b)
        elif self.render_mode == "human":
            self._ladder = dict(
                shadow=1.0 - float(lit[0].float().mean()),
                slot=float(in_slot[0].float().mean()),
                fold=float((lit[0] & ~in_slot[0] & ~graze[0]
                            & ~(rad1[0] < self.r_fold)).float().mean()),
                tube=float((ok_pre_tube[0] & ~ok_post_tube[0]
                            ).float().mean()),
                m5=float((ok_post_tube[0] & ~ok[0]).float().mean()),
                duct=float((ok[0] & ~through_b[0]).float().mean()),
                through=float(through[0].float().mean()))
            self._hv = dict(dish=p[0].cpu().numpy(),
                            fold=h1[0].cpu().numpy(),
                            m5=h2[0].cpu().numpy(),
                            duct=h3[0].cpu().numpy(),
                            ok=ok[0].cpu().numpy(),
                            ok_pre=ok_pre_tube[0].cpu().numpy(),
                            slot=in_slot[0].cpu().numpy(),
                            desc=desc[0].cpu().numpy(),
                            through=through_b[0].cpu().numpy(),
                            u=u, el=el, az=float(az), C=C_dish,
                            ub=ub, naim=naim, el_b=el_b)
        # into the pot via the SHARED polar binning; rigid map between the
        # frames: theirs (x,y,z) = (y_ours, -x_ours, z_ours - H_POT)
        return self._bin_pot(dy - off[:, 0:1], dz - off[:, 1:2],
                             d3[..., 1], -d3[..., 0], d3[..., 2],
                             through, torch.as_tensor(np.asarray(soil), dtype=torch.float32, device=self._ds_s2_t.device) * self._ds_s2_t, B, P)

    def verify_megakernel(self):
        """Megakernel vs the eager reference core on identical inputs.
        Returns (through-mask mismatches, max |diff| on jointly-through
        rays' duct coordinates and directions)."""
        if self._metal is None:
            return 0, 0.0
        gstate = self._gen.get_state()
        tick0, rm0 = self.tick, self.render_mode
        B = self.num_agents
        pe, sg = np.full(B, self.p0), np.full(B, 7e-3)
        try:
            self.render_mode = None
            metal, self._metal = self._metal, None
            geo0, self._geo = self._geo, self._geo_ref
            self.tick = 4242
            ref = self._trace_power(pe, sg, np.zeros((B, 2)), np.ones(B))
            self._metal = metal
            self._gen.set_state(gstate)
            self.tick = 4242
            fus = self._trace_power(pe, sg, np.zeros((B, 2)), np.ones(B))
        finally:
            self._metal, self._geo = metal, geo0
            self.tick, self.render_mode = tick0, rm0
        mism = int((ref - fus).abs().gt(1e-3).sum())
        return mism, float((ref - fus).abs().max())

    def verify_fusion(self, n=6):
        """Run the compiled and eager cores on identical inputs and
        compare ray-for-ray. Returns (mask_mismatches, max_pos_diff)."""
        if not self._geo_is_fused:
            return 0, 0.0
        fused, self._geo = self._geo, _geo_core
        tick0 = self.tick
        try:
            B = self.num_agents
            pe = np.full(B, self.p0)
            sg = np.full(B, 7e-3)
            gstate = self._gen.get_state()
            self.tick = 12345
            ref = self._trace_power(pe, sg, np.zeros((B, 2)), np.ones(B))
            self._geo = fused
            self._gen.set_state(gstate)
            self.tick = 12345
            fus = self._trace_power(pe, sg, np.zeros((B, 2)), np.ones(B))
        finally:
            self._geo = fused
            self.tick = tick0
        mism = int((ref - fus).abs().gt(1e-4).sum())
        return mism, float((ref - fus).abs().max())


    # ------------------------------------------------ exact renderer #
    def _ts_append(self):
        """Per-frame history for the HUD line graphs. Resets on day
        rollover (solar time jumps back); capped by pairwise decimation
        so a full day stays a few thousand points."""
        t = float(self.t_solar[0])
        h = getattr(self, "_ts_h", None)
        if h is None or (h["t"] and t < h["t"][-1] - 0.5):
            keys = ("t", "pin", "dni", "belt", "hearth", "halo",
                    "thr", "shadow", "el", "elb", "rotis",
                    "rew", "ret")
            h = self._ts_h = {k: [] for k in keys}
        H = getattr(self, "_hv", None)
        L = getattr(self, "_ladder", None)
        h["t"].append(t)
        h["pin"].append(float(self.p_in[0]) / 1000.0)
        h["dni"].append(float(self.dni[0]) / 100.0)
        h["belt"].append(float(self.T[0, :self.n_belt].mean()))
        h["hearth"].append(float(self.T[0, self.n_belt]))
        h["halo"].append(float(self.T_halo[0]))
        h["thr"].append(100.0 * L["through"] if L else 0.0)
        h["shadow"].append(100.0 * L["shadow"] if L else 0.0)
        h["el"].append(float(H["el"]) if H else 0.0)
        h["elb"].append(float(H.get("el_b", H["el"])) if H else 0.0)
        h["rotis"].append(float(self.ep_rotis[0]))
        h["rew"].append(float(self.rewards[0]))
        h["ret"].append(float(self.ep_return[0]) / 100.0)
        if len(h["t"]) > 4000:
            for k in h:
                h[k] = h[k][::2]

    @staticmethod
    def _draw_ts(pr, x, y, w, h, title, series, unit="", tspan=None,
                 fmt=".0f"):
        """One panel of day-long line graphs. series is a list of
        (values, color, label); shared autoscaled y axis with
        unit-labeled ticks (hi/mid/lo), latest value printed beside
        each label; tspan=(t0, t1) prints the solar-hour x range."""
        pr.draw_rectangle(x, y, w, h, (20, 23, 31, 255))
        pr.draw_rectangle_lines(x, y, w, h, (58, 62, 76, 255))
        allv = [v for d, _, _ in series for v in d if v == v]
        if len(allv) >= 2:
            lo, hi = min(allv), max(allv)
            pad = 0.08 * (hi - lo) if hi > lo else \
                max(abs(hi), 1.0) * 0.1
            lo, hi = lo - pad, hi + pad
            ym = y + h - 3 - int((h - 18) * (0.5))
            pr.draw_line(x + 3, ym, x + w - 52, ym, (38, 42, 54, 255))
            for d, col, _ in series:
                m = len(d)
                if m < 2:
                    continue
                stride = max(1, m // max(w - 8, 1))
                idx = list(range(0, m, stride))
                if idx[-1] != m - 1:
                    idx.append(m - 1)
                pts = [(x + 4 + int((w - 58) * i / (m - 1)),
                        y + h - 3 - int((h - 18)
                                        * (d[i] - lo) / (hi - lo)))
                       for i in idx]
                for k in range(len(pts) - 1):
                    pr.draw_line(pts[k][0], pts[k][1],
                                 pts[k + 1][0], pts[k + 1][1], col)
            tick = (130, 138, 150, 255)
            pr.draw_text(f"{hi:{fmt}}{unit}", x + w - 50, y + 14,
                         10, tick)
            pr.draw_text(f"{0.5 * (hi + lo):{fmt}}{unit}",
                         x + w - 50, ym - 5, 10, tick)
            pr.draw_text(f"{lo:{fmt}}{unit}", x + w - 50, y + h - 12,
                         10, tick)
        if tspan is not None:
            pr.draw_text(f"{tspan[0]:.1f}h", x + 4, y + h - 12, 10,
                         (130, 138, 150, 255))
            pr.draw_text(f"{tspan[1]:.2f}h  solar time", x + 40,
                         y + h - 12, 10, (130, 138, 150, 255))
        pr.draw_text(title, x + 5, y + 2, 12, (205, 210, 220, 255))
        tx = x + 5 + 8 * len(title) + 10
        for d, col, lab in series:
            cur = f"{lab} {d[-1]:{fmt}}" if d else lab
            pr.draw_text(cur, tx, y + 2, 12, col)
            tx += 8 * len(cur) + 10

    def render(self):
        """The machine this env simulates, from its own traced vertices:
        dish points -> fixed fold -> waist -> fixed ellipsoid M5 -> duct
        -> pot strike. Nothing stylised; the polar/coude scenes do not
        apply here and are fully overridden."""
        if self.render_mode != "human":
            return None
        import pyray as pr
        H = getattr(self, "_hv", None)
        W_, HT = 1400, 850
        if not self._window:
            pr.init_window(W_, HT, "Hashemi fixed focus -> sealed tower "
                           "-> existing tandoor")
            pr.set_target_fps(24); self._window = True
            self._cam_th, self._cam_ph, self._cam_r = 1.05, 0.22, 20.0
            self._cam_tgt = np.array([1.0, 0.0, 3.0])
            # TANDOOR_CAM="th,ph,r,tx,ty,tz" sets the opening view (the mouse still
            # orbits from there, and R returns to this preset) - so a screenshot can
            # be taken from a chosen angle without touching the machine
            _cam = os.environ.get("TANDOOR_CAM")
            if _cam:
                try:
                    v = [float(x) for x in _cam.split(",")]
                    self._cam_th, self._cam_ph, self._cam_r = v[0], v[1], v[2]
                    if len(v) >= 6: self._cam_tgt = np.array(v[3:6])
                    self._cam_home = (self._cam_th, self._cam_ph, self._cam_r, self._cam_tgt.copy())
                    print(f"  [hashemi] camera preset: th {self._cam_th:.2f} ph {self._cam_ph:.2f} r {self._cam_r:.1f} at {np.round(self._cam_tgt, 2)}")
                except Exception as _ex:
                    print(f"  [hashemi] TANDOOR_CAM ignored ({_ex})")
            # roti-lifecycle animation state (agent 0's kitchen)
            self._rvis = dict(prev=None, anims=[], flash=[],
                              stack=0, rej=0, prev_rot=0.0, prev_sc=0.0)
        if pr.is_mouse_button_down(0):
            dd = pr.get_mouse_delta()
            self._cam_th -= dd.x * 0.006
            self._cam_ph = float(np.clip(self._cam_ph + dd.y * 0.006,
                                         -0.3, 1.45))
        if pr.is_mouse_button_down(1):
            dd = pr.get_mouse_delta()
            fv = np.array([np.cos(self._cam_th), np.sin(self._cam_th)])
            self._cam_tgt[:2] += (np.array([fv[1], -fv[0]]) * dd.x
                                  - fv * dd.y) * 0.004 * self._cam_r
            self._cam_tgt[2] += dd.y * 0.003 * self._cam_r
        if pr.is_key_pressed(pr.KeyboardKey.KEY_R):
            if getattr(self, "_cam_home", None) is not None:
                self._cam_th, self._cam_ph, self._cam_r, _t = self._cam_home
                self._cam_tgt = _t.copy()
            else:
                self._cam_tgt = np.array([1.0, 0.0, 3.0])
                self._cam_th, self._cam_ph, self._cam_r = 1.05, 0.22, 20.0
        self._cam_r = float(np.clip(
            self._cam_r - pr.get_mouse_wheel_move() * 1.2, 3.0, 60.0))
        tgt = pr.Vector3(*[float(v) for v in self._cam_tgt])
        cp = pr.Vector3(
            tgt.x + self._cam_r*np.cos(self._cam_ph)*np.cos(self._cam_th),
            tgt.y + self._cam_r*np.cos(self._cam_ph)*np.sin(self._cam_th),
            tgt.z + self._cam_r*np.sin(self._cam_ph))
        cam = pr.Camera3D(cp, tgt, pr.Vector3(0., 0., 1.), 45.,
                          pr.CameraProjection.CAMERA_PERSPECTIVE)
        v3 = lambda q: pr.Vector3(float(q[0]), float(q[1]), float(q[2]))

        def ring(c, r, col, n=36, ax="z"):
            t = np.linspace(0, 2*np.pi, n+1)
            if ax == "z":
                q = np.stack([c[0]+r*np.cos(t), c[1]+r*np.sin(t),
                              np.full(n+1, c[2])], 1)
            else:
                q = np.stack([np.full(n+1, c[0]), c[1]+r*np.cos(t),
                              c[2]+r*np.sin(t)], 1)
            for k in range(n):
                pr.draw_line_3d(v3(q[k]), v3(q[k+1]), col)

        def disc(c, nrm, r, col, seg=12):
            # solid triangle-fan disc facing nrm, both windings
            n_ = np.asarray(nrm, float)
            n_ = n_ / max(np.linalg.norm(n_), 1e-9)
            e1 = np.cross(n_, [0.0, 0.0, 1.0])
            if np.linalg.norm(e1) < 1e-6:
                e1 = np.array([1.0, 0.0, 0.0])
            e1 /= np.linalg.norm(e1)
            e2 = np.cross(n_, e1)
            c = np.asarray(c, float)
            th = np.linspace(0, 2*np.pi, seg + 1)
            rim = [c + r*(np.cos(t)*e1 + np.sin(t)*e2) for t in th]
            for j in range(seg):
                pr.draw_triangle_3d(v3(c), v3(rim[j]), v3(rim[j+1]), col)
                pr.draw_triangle_3d(v3(c), v3(rim[j+1]), v3(rim[j]), col)

        def browning(fr_, scorched=False):
            if scorched:
                return (62, 48, 38, 255)
            fr_ = min(max(fr_, 0.0), 1.0)   # pyray colors are u8
            if fr_ < 0.5:
                t_ = fr_ / 0.5
                return (int(232-24*t_), int(215-57*t_), int(180-88*t_),
                        255)
            t_ = (fr_ - 0.5) / 0.5
            return (int(208-48*t_), int(158-60*t_), int(92-47*t_), 255)

        def smooth(t_):
            t_ = float(np.clip(t_, 0.0, 1.0))
            return t_*t_*(3.0 - 2.0*t_)

        def path_eval(path, u_):
            q = smooth(u_) * (len(path) - 1)
            j = min(int(q), len(path) - 2)
            f_ = q - j
            return (1-f_)*np.asarray(path[j]) + f_*np.asarray(path[j+1])

        dim = float(np.clip(self.dni[0]/950., 0.05, 1.))
        pr.begin_drawing()
        pr.clear_background((int(11+22*dim), int(13+28*dim),
                             int(21+46*dim), 255))
        pr.draw_rectangle(1000, 0, W_-1000, HT, (13, 15, 22, 255))
        pr.begin_mode_3d(cam)
        # THE BUILDING, machine wholly on its roof (fig 18): the deck
        # spans the dish sweep, parapet at the edge, the tandoor room a
        # bay under the southern part, the masonry core in its north wall.
        BX0, BX1, BYy = X_TOWER - 5.7, X_TOWER + 5.7, 5.7
        wallb = (100, 88, 74, 255)
        for cx, cy in ((BX0, -BYy), (BX0, BYy), (BX1, -BYy), (BX1, BYy)):
            pr.draw_line_3d(v3([cx, cy, H_POT]), v3([cx, cy, Z_ROOF]),
                            wallb)
        for zz in (H_POT, Z_ROOF, Z_ROOF + 0.35):        # plates + parapet
            for q0, q1 in (((BX0, -BYy), (BX0, BYy)),
                           ((BX1, -BYy), (BX1, BYy)),
                           ((BX0, -BYy), (BX1, -BYy)),
                           ((BX0, BYy), (BX1, BYy))):
                pr.draw_line_3d(v3([q0[0], q0[1], zz]),
                                v3([q1[0], q1[1], zz]), wallb)
        for gx in np.linspace(BX0, BX1, 12):             # roof deck
            pr.draw_line_3d(v3([gx, -BYy, Z_ROOF]), v3([gx, BYy, Z_ROOF]),
                            (80, 78, 70, 255))
        for gy in np.linspace(-BYy, BYy, 12):
            pr.draw_line_3d(v3([BX0, gy, Z_ROOF]), v3([BX1, gy, Z_ROOF]),
                            (80, 78, 70, 255))
        RX0, RX1, RY = -2.4, X_TOWER, 2.3
        wallc = (118, 102, 84, 255)
        for cx, cy in ((RX0, -RY), (RX0, RY), (RX1, -RY), (RX1, RY)):
            pr.draw_line_3d(v3([cx, cy, H_POT]), v3([cx, cy, Z_ROOF]),
                            wallc)
        for zz in (H_POT, Z_ROOF):
            for q0, q1 in (((RX0, -RY), (RX0, RY)), ((RX1, -RY), (RX1, RY)),
                           ((RX0, -RY), (RX1, -RY)), ((RX0, RY), (RX1, RY))):
                pr.draw_line_3d(v3([q0[0], q0[1], zz]),
                                v3([q1[0], q1[1], zz]), wallc)
        # wall studs; the south wall keeps a door gap the cook uses
        for gy in np.linspace(-RY, RY, 9):
            pr.draw_line_3d(v3([RX1, gy, H_POT]), v3([RX1, gy, Z_ROOF]),
                            wallc)                       # north wall: solid
            if abs(gy) > 0.65:                            # door in south
                pr.draw_line_3d(v3([RX0, gy, H_POT]),
                                v3([RX0, gy, Z_ROOF]), wallc)
        for gx in np.linspace(RX0, RX1, 6):
            for gy in (-RY, RY):
                pr.draw_line_3d(v3([gx, gy, H_POT]), v3([gx, gy, Z_ROOF]),
                                (96, 84, 70, 255))
        for gx in np.linspace(RX0, RX1, 5):               # room floor
            pr.draw_line_3d(v3([gx, -RY, H_POT]), v3([gx, RY, H_POT]),
                            (58, 60, 72, 255))
        # the wall the tower stands on, workfloor -> roof (coude scene)
        for wx in (X_TOWER - 0.55, X_TOWER + 0.55):
            for wy in (-2.2, 2.2):
                pr.draw_line_3d(v3([wx, wy, H_POT]), v3([wx, wy, Z_ROOF]),
                                (118, 102, 84, 255))
            pr.draw_line_3d(v3([wx, -2.2, Z_ROOF]), v3([wx, 2.2, Z_ROOF]),
                            (118, 102, 84, 255))
        # THE EXISTING POT: a SPHERICAL SECTION, as built - the clay
        # urn is the sphere through the coal-bed floor (r R_POT at
        # z 0) and the cook's mouth (R_MOUTH at H_POT); the belly
        # between them is over a metre across, far wider than the
        # cook. z_c and R_S solve those two circles.
        _p0 = self._pot0()
        zc_w = H_POT + _p0["zc"]       # sphere centre, world frame (agent 0's pit)
        z_fl = H_POT - _p0["hd"]       # coal-bed floor, world frame
        XC = R_POT - _p0["rdw"]        # pot AXIS: 1.21 m behind the
        xc3 = np.array([XC, 0.0, 0.0])  # built duct mouth
        r_at = lambda zz: float(np.sqrt(max(
            _p0["rs"]*_p0["rs"] - (zz - zc_w)**2, 1e-6)))
        pot_prof = [(zz, r_at(zz))
                    for zz in np.linspace(z_fl, H_POT, 22)]
        for zz, rr_ in pot_prof:
            ring([XC, 0, zz], rr_, (150, 118, 92, 255), 32)
        for aa in np.linspace(0, 2*np.pi, 16, endpoint=False):
            pts_ = [np.array([XC + r_*np.cos(aa), r_*np.sin(aa), zz])
                    for zz, r_ in pot_prof]
            for j in range(len(pts_) - 1):
                pr.draw_line_3d(v3(pts_[j]), v3(pts_[j+1]),
                                (128, 100, 78, 255))
        t_lbls = []                      # (world pos, text, color)
        # hearth glow: the coal-bed spot breathing with temperature
        t_h = float(self.T[0, self.n_belt])
        if t_h > 450.0:
            gl = float(np.clip((t_h - 450.0) / 400.0, 0, 1))
            disc([XC, 0, z_fl + 0.05], [0, 0, 1],
                 R_POT*(0.30 + 0.20*gl),
                 (255, int(120 + 90*gl), 40, int(70 + 120*gl)), 16)
        ring([XC, 0, H_POT], R_MOUTH, (190, 160, 120, 255), 24)
        if self.load_timer[0] >= 4.0:          # lid on between loads
            ring([XC, 0, H_POT + 0.03], R_MOUTH * 0.92,
                 (120, 120, 128, 255), 20)
        # belt WALL SEGMENTS, each at its own node temperature. The bin
        # frame maps theirs->ours as (x,y) = (-y_t, x_t), so segment k's
        # arc is drawn through that map - the hot side faces the duct.
        z_lo, z_hi = H_POT + Z_HEARTH, H_POT + Z_CROWN
        for k in range(self.n_belt):
            a0 = -np.pi + 2 * np.pi * k / self.n_belt
            th_ = np.linspace(a0, a0 + 2 * np.pi / self.n_belt, 8)
            col = self._heat_color(self.T[0, k])
            for zz in np.linspace(z_lo + 0.06, z_hi - 0.05, 6):
                rw = r_at(zz) * 0.995
                for j in range(7):
                    pr.draw_line_3d(
                        v3([XC - rw*np.sin(th_[j]),
                            rw*np.cos(th_[j]), zz]),
                        v3([XC - rw*np.sin(th_[j+1]),
                            rw*np.cos(th_[j+1]), zz]), col)
            am_ = a0 + np.pi / self.n_belt
            rl_ = r_at(0.5 * (z_lo + z_hi)) * 1.02
            t_lbls.append((np.array([XC - rl_*np.sin(am_),
                                     rl_*np.cos(am_),
                                     0.5 * (z_lo + z_hi)]),
                           f"{self.T[0, k]:.0f}", col))
            # the ROTI slapped on this wall segment: a flat disc
            # pressed against the clay, browning as it cooks, blistering
            # past half-done, charring if the wall runs to scorch
            if self.has_bread[0, k]:
                am = a0 + np.pi / self.n_belt
                z_br = H_POT - 0.55        # arm's reach into the pit
                r_an = r_at(z_br) * 0.955
                anchor = np.array([XC - r_an*np.sin(am),
                                   r_an*np.cos(am), z_br])
                nrm = -anchor * [1, 1, 0]        # inward wall normal
                fr_ = min(max(float(self.bread_E[0, k])
                              / self.roti_energy, 0.0), 1.0)
                hot = float(self.bread_C[0, k]) > 0.5
                disc(anchor, nrm, 0.085 + 0.02*fr_, browning(fr_, hot))
                # the flux integral over THIS roti's surface [W]:
                # wall contact + direct beam, stashed by the step
                bpw = getattr(self, "_bread_pw", None)
                if bpw is not None:
                    n_ = nrm / np.linalg.norm(nrm)
                    t_lbls.append((anchor + 0.17 * n_ + [0, 0, 0.09],
                                   f"{float(bpw[0, k]):.0f}W",
                                   (255, 228, 150, 255)))
                if fr_ > 0.5 and not hot:        # blisters
                    e1 = np.cross(nrm/np.linalg.norm(nrm), [0., 0., 1.])
                    for bx, bz in ((0.03, 0.02), (-0.025, -0.03),
                                   (0.01, -0.045)):
                        pr.draw_sphere(
                            v3(anchor + bx*e1 + [0, 0, bz]
                               + 0.012*nrm/np.linalg.norm(nrm)),
                            0.012, (168, 112, 58, 255))
        # hearth (coal-bed spot the beam lands on) and crown
        ring([XC, 0, z_fl + 0.03], R_POT * 0.5,
             self._heat_color(self.T[0, self.n_belt]), 18)
        ring([XC, 0, H_POT - 0.12], r_at(H_POT - 0.12) * 0.97,
             self._heat_color(self.T[0, self.n_belt + 2]), 22)
        t_lbls.append((np.array([XC, R_POT * 0.35, z_fl + 0.06]),
                       f"{self.T[0, self.n_belt]:.0f}",
                       self._heat_color(self.T[0, self.n_belt])))
        t_lbls.append((np.array([XC, r_at(H_POT-0.12)*0.8,
                                 H_POT - 0.10]),
                       f"{self.T[0, self.n_belt + 2]:.0f}",
                       self._heat_color(self.T[0, self.n_belt + 2])))
        self._pot_lbls = t_lbls
        ring([R_POT, 0, Z_DUCT], R_DUCT_H,
             (120, 220, 235, 255), 18, ax="x")
        # THE ELBOW on its 2-DOF mount: mirror disc, aim axis, and
        # the spot ring on the wall it serves; strikes from the trace
        if getattr(self, "duct_nozzle", 0) == 2:
            M_ = self._noz2["M"]
            p2w = lambda t_: np.array([XC - t_[1], t_[0],
                                       t_[2] + H_POT])
            Mw = p2w(M_)
            ph0_ = float(self.spot_phi[0]); zt0_ = float(self.spot_z[0])
            rt_ = float(np.sqrt(max(self._pot0()["rs"]**2 - (zt0_ - self._pot0()["zc"])**2,
                                    1e-4))) * 0.995
            Tw = p2w([rt_*np.cos(ph0_), rt_*np.sin(ph0_), zt0_])
            nrm_ = Tw - Mw
            disc(Mw, nrm_, 0.13, (160, 220, 240, 235), 14)
            pr.draw_line_3d(v3([R_POT, 0, Z_DUCT]), v3(Mw),
                            (120, 220, 235, 200))
            pr.draw_line_3d(v3(Mw), v3(Tw), (255, 230, 140, 200))
            ring(Tw, 0.31, (255, 230, 140, 220), 20,
                 ax="z" if abs(nrm_[2]) > 0.7 else "x")
            ps = getattr(self, "_pot_strikes", None)
            if ps is not None:
                pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
                st_, thr_ = ps["strike"], ps["through"]
                for k_ in range(0, len(st_), max(1, len(st_)//90)):
                    if thr_[k_] <= 0:
                        continue
                    pr.draw_line_3d(v3(Mw), v3(p2w(st_[k_])),
                                    (200, 150, 60, 26))
                pr.end_blend_mode()
        # ---- THE KITCHEN: the workfloor over the pit. Dough comes off
        # the prep table, down through the mouth, slapped to the wall;
        # done rotis come back up on the hook. Driven by diffing agent
        # 0's bread state between frames - every animation is an event
        # the env actually emitted, never decoration.
        RV = self._rvis
        TBL = np.array([-1.5, 1.2, H_POT + 0.82]) + xc3
        AM = np.array([0.0, 0.0, H_POT + 0.55]) + xc3
        MTH = np.array([0.0, 0.0, H_POT - 0.15]) + xc3
        REJ = np.array([0.85, -0.75, H_POT + 0.03]) + xc3

        def bin_anchor(k_):
            am_ = -np.pi + 2*np.pi*(k_ + 0.5) / self.n_belt
            return np.array([-0.955*R_POT*np.sin(am_),
                             0.955*R_POT*np.cos(am_),
                             0.5*(z_lo + z_hi)])

        cur = self.has_bread[0].copy()
        rot_now = float(self.ep_rotis[0])
        sc_now = float(self.ep_scorch[0])
        if RV["prev"] is None or rot_now < RV["prev_rot"] - 0.5:
            RV["prev"] = cur.copy()          # first frame / day rollover
            RV["prev_rot"], RV["prev_sc"] = rot_now, sc_now
            RV["stack"] = RV["rej"] = 0
        d_rot = rot_now - RV["prev_rot"]
        d_sc = sc_now - RV["prev_sc"]
        for k_ in np.nonzero(cur & ~RV["prev"])[0]:
            a_ = bin_anchor(int(k_))
            RV["anims"].append(dict(
                kind="load", t=0, T=26, k=int(k_),
                path=[TBL, TBL + [0.35, -0.45, 0.40], AM, MTH, a_]))
        for k_ in np.nonzero(RV["prev"] & ~cur)[0]:
            a_ = bin_anchor(int(k_))
            if d_rot > 0.5:
                d_rot -= 1.0
                RV["anims"].append(dict(
                    kind="pull", t=0, T=34, k=int(k_), ok=True,
                    down=[AM, MTH, a_], up=[a_, MTH, AM,
                                            TBL + [-0.28, 0.18, 0.10]]))
            elif d_sc > 0.5:
                d_sc -= 1.0
                RV["anims"].append(dict(
                    kind="pull", t=0, T=34, k=int(k_), ok=False,
                    down=[AM, MTH, a_], up=[a_, MTH, AM, REJ]))
        RV["prev"] = cur.copy()
        RV["prev_rot"], RV["prev_sc"] = rot_now, sc_now

        hand_tgt = None
        keep = []
        for an in RV["anims"]:
            an["t"] += 1
            if an["kind"] == "load":
                u_ = an["t"] / an["T"]
                pos = path_eval(an["path"], u_)
                nrm = (1-u_)*np.array([0., 0., 1.]) \
                    - u_*bin_anchor(an["k"])*[1, 1, 0]
                disc(pos, nrm, 0.075, (235, 224, 198, 255))
                if u_ < 0.45:
                    hand_tgt = pos
                if an["t"] >= an["T"]:
                    RV["flash"].append(dict(k=an["k"], age=0))
                else:
                    keep.append(an)
            else:                                      # the hook
                T1 = 12
                if an["t"] <= T1:
                    tip = path_eval(an["down"], an["t"]/T1)
                else:
                    u_ = (an["t"] - T1) / (an["T"] - T1)
                    tip = path_eval(an["up"], u_)
                    col = browning(1.0, not an["ok"])
                    disc(tip, [0, 0, 1], 0.085, col)
                pole0 = np.array([0.0, 0.0, H_POT + 0.95])
                pr.draw_line_3d(v3(pole0), v3(tip + [0, 0, 0.05]),
                                (185, 185, 195, 255))
                for jj in range(5):                    # the curl
                    q0 = tip + [0, 0, 0.05] \
                        + 0.05*np.array([np.sin(jj*0.5), 0,
                                         -1 + np.cos(jj*0.5)])
                    q1 = tip + [0, 0, 0.05] \
                        + 0.05*np.array([np.sin((jj+1)*0.5), 0,
                                         -1 + np.cos((jj+1)*0.5)])
                    pr.draw_line_3d(v3(q0), v3(q1), (185, 185, 195, 255))
                hand_tgt = pole0 + np.array([-0.25, 0.1, -0.1])
                if an["t"] >= an["T"]:
                    if an["ok"]:
                        RV["stack"] += 1
                    else:
                        RV["rej"] += 1
                else:
                    keep.append(an)
        RV["anims"] = keep
        fl_keep = []
        for fl in RV["flash"]:                          # the slap
            fl["age"] += 1
            a_ = bin_anchor(fl["k"])
            n_ = -a_ * [1, 1, 0]
            n_ = n_ / np.linalg.norm(n_)
            e1 = np.cross(n_, [0., 0., 1.])
            rr_ = 0.09 + 0.022 * fl["age"]
            th = np.linspace(0, 2*np.pi, 13)
            q = [a_ + 0.01*n_ + rr_*(np.cos(t_)*e1
                                     + np.sin(t_)*np.array([0., 0., 1.]))
                 for t_ in th]
            for jj in range(12):
                pr.draw_line_3d(v3(q[jj]), v3(q[jj+1]),
                                (255, 240, 200, 255))
            if fl["age"] < 6:
                fl_keep.append(fl)
        RV["flash"] = fl_keep
        # prep table, waiting dough, the day's stack, the reject pile
        pr.draw_cube(v3(TBL), 0.95, 0.65, 0.05, (140, 110, 80, 255))
        for lx, ly in ((-0.42, -0.27), (-0.42, 0.27), (0.42, -0.27),
                       (0.42, 0.27)):
            pr.draw_line_3d(v3(TBL + [lx, ly, -0.02]),
                            v3([TBL[0]+lx, TBL[1]+ly, H_POT]),
                            (110, 88, 66, 255))
        if self.load_timer[0] >= 35.0:
            pr.draw_sphere(v3(TBL + [0.28, -0.14, 0.07]), 0.055,
                           (238, 228, 206, 255))
        if self.load_timer[0] >= 44.0:
            pr.draw_sphere(v3(TBL + [0.14, -0.22, 0.05]), 0.04,
                           (238, 228, 206, 255))
        for i_ in range(min(RV["stack"], 14)):
            disc(TBL + [-0.28, 0.18, 0.03 + 0.022*i_], [0, 0, 1],
                 0.085, browning(1.0))
        for i_ in range(min(RV["rej"], 6)):
            disc(REJ + [0.06*(i_ % 3), 0.05*(i_ // 3), 0.012*i_],
                 [0, 0, 1], 0.08, browning(1.0, True))
        # THE COOK at the mouth: feet on the workfloor, one arm working
        ck = np.array([-0.72, 0.34, H_POT])
        hips, sho = ck + [0, 0, 0.52], ck + [0, 0, 0.88]
        skin, cloth = (222, 190, 158, 255), (94, 108, 138, 255)
        pr.draw_sphere(v3(ck + [0, 0, 1.00]), 0.075, skin)
        pr.draw_line_3d(v3(hips), v3(sho), cloth)
        for sx in (-0.09, 0.09):
            pr.draw_line_3d(v3(hips), v3(ck + [sx, 0.02, 0.0]), cloth)
        if hand_tgt is None:
            hand_tgt = hips + np.array([0.22, -0.18, 0.05])
        rv = np.asarray(hand_tgt, float) - sho
        rn = np.linalg.norm(rv)
        hand = sho + rv * (min(rn, 0.62) / max(rn, 1e-9))
        pr.draw_line_3d(v3(sho), v3(hand), skin)
        pr.draw_line_3d(v3(sho), v3(hips + [-0.20, 0.12, 0.12]), skin)
        # THE PIPE, drawn as built: constant outer width everywhere
        # (the visible object), with the reflective CPC inner profile
        # drawn inside it - flared lip at the mouth, straight through
        # the slot band, expanding cone below the throat to M5.
        if self.receiver == "focus":
            # THE FOCUS-RECEIVER CHAIN, drawn as built: the wall tower up
            # to M3, the chase of radius r_bore down to the turn, M4 at
            # the turn throwing into the built duct mouth, and the strut
            # from the tower up to F (the post).
            P3_, P4_, F4_ = self.fc_P3, self.fc_P4, self.fc_F4
            Ps_, Ff_ = self.fc_Ps, self.F_focus
            colt = (160, 148, 126, 255)
            pr.draw_line_3d(v3([X_TOWER, 0, self.z_deck]), v3(P3_), colt)
            for zz in np.linspace(self.z_deck, P3_[2], 6):     # wall tower
                ring([X_TOWER, 0, zz], 0.25, (150, 140, 120, 255), 12)
            for zz in np.linspace(P4_[2], P3_[2], 12):         # the chase
                ring([X_TOWER, 0, zz], self.r_bore, (120, 104, 88, 255), 20)
            for aa in (0, np.pi/2, np.pi, 3*np.pi/2):
                pr.draw_line_3d(v3([X_TOWER + self.r_bore*np.cos(aa),
                                    self.r_bore*np.sin(aa), P3_[2]]),
                                v3([X_TOWER + self.r_bore*np.cos(aa),
                                    self.r_bore*np.sin(aa), P4_[2]]),
                                (120, 104, 88, 255))
            n4_ = (F4_ - P4_) / max(np.linalg.norm(F4_ - P4_), 1e-9) \
                + np.array([0., 0., 1.])
            n4_ /= max(np.linalg.norm(n4_), 1e-9)
            disc(P4_, n4_, self.r_m4, (160, 220, 240, 235), 20)  # M4
            pr.draw_line_3d(v3(P4_), v3(F4_), (120, 220, 235, 200))
            pr.draw_line_3d(v3(Ps_), v3(Ff_), colt)               # strut
            for zz in np.linspace(self.z_deck, Ff_[2], 4):     # post rings
                ring([Ff_[0], 0, zz], 0.12, (150, 140, 120, 255), 10)
        elif self._cass:
            # THE CASSEGRAIN CHAIN, drawn as built: the straight bore of
            # radius r_bore from the tower top down to the turn at the
            # wall base, the ellipsoid M4 patch at the turn (foci F2 up
            # the bore and the built duct mouth), the duct, and the F
            # post: a horizontal arm from the north tower (out of the
            # bore) to F (cass) or to the bearing Q = F - d A (greg).
            P4_, F4_, Ff_ = self.cs_P4, self.cs_F4, self.F_focus
            F2_, n4_, Ps_ = self.cs_F2, self.cs_n4, self.cs_Ps
            colt = (160, 148, 126, 255)
            ax_ = P4_ - Ff_
            Lb_ = max(np.linalg.norm(ax_), 1e-9)
            ax_ = ax_ / Lb_
            e1_ = np.cross(ax_, [0., 1., 0.])
            e1_ /= max(np.linalg.norm(e1_), 1e-9)
            e2_ = np.cross(ax_, e1_)
            tt_ = np.linspace(0, 2*np.pi, 21)
            zdk_ = self.z_deck
            # bore rings from the deck crossing down to M4
            t_deck = (zdk_ - Ff_[2]) / ax_[2] if abs(ax_[2]) > 1e-6 else 0.0
            for tb_ in np.linspace(max(t_deck, 0.0), Lb_, 12):
                cb_ = Ff_ + tb_*ax_
                ptsb = [cb_ + self.r_bore*(np.cos(x)*e1_ + np.sin(x)*e2_) for x in tt_]
                for k in range(20):
                    pr.draw_line_3d(v3(ptsb[k]), v3(ptsb[k+1]), (120, 104, 88, 255))
            for aa in (0, np.pi/2, np.pi, 3*np.pi/2):
                off_ = self.r_bore*(np.cos(aa)*e1_ + np.sin(aa)*e2_)
                pr.draw_line_3d(v3(Ff_ + max(t_deck, 0.0)*ax_ + off_),
                                v3(P4_ + off_), (120, 104, 88, 255))
            # THE RECEIVER AS BUILT, FOR THE AGENT ON SCREEN.  Row 0 of the design
            # table, not the env's nominal - under design_rand those are different
            # machines and the nominal one is nobody's.
            _f0 = (self._fct[0].detach().cpu().numpy() if torch.is_tensor(self._fct)
                   else np.asarray(self._fct)[0])
            P4b = _f0[15:18].astype(np.float64)
            r_m4b, r_ductb = float(_f0[29]), float(_f0[39])
            tri_b = float(_f0[self.DS["recv"]]) > 0.5
            phw_b = float(_f0[self.DS["phw"]])
            psi_b = float(np.clip(np.asarray(self.spot_phi, dtype=np.float64).ravel()[0]
                                  - _SP0, -phw_b, phw_b))
            F4b = self.tri_target(psi_b) if tri_b else np.asarray(self.cs_F4, dtype=np.float64)

            def hoop(c, nrm, r, col, seg=48):
                """rim only, so two circles in the same plane can be compared by eye"""
                n_ = np.asarray(nrm, float); n_ = n_ / max(np.linalg.norm(n_), 1e-9)
                e1 = np.cross(n_, [0.0, 0.0, 1.0])
                if np.linalg.norm(e1) < 1e-6:
                    e1 = np.array([1.0, 0.0, 0.0])
                e1 = e1 / np.linalg.norm(e1); e2 = np.cross(n_, e1)
                c = np.asarray(c, float)
                p_ = [c + r*(np.cos(t)*e1 + np.sin(t)*e2)
                      for t in np.linspace(0, 2*np.pi, seg + 1)]
                for j_ in range(seg):
                    pr.draw_line_3d(v3(p_[j_]), v3(p_[j_+1]), col)

            disc(P4b, n4_, r_m4b, (160, 220, 240, 235), 20)         # M3 AT ITS BUILT RADIUS
            hoop(P4b, n4_, r_m4b, (205, 240, 255, 255))
            pr.draw_sphere(v3(F2_), 0.06, (120, 220, 235, 255))       # F2

            # THE INLET, drawn where _bin_pot actually gates it: a circle of radius
            # r_duct at (R_POT, 0, Z_DUCT), normal down the duct - and beside it the
            # beam's OWN footprint in that plane.  On 'tri' the beam passes the hole
            # on its way to the loaf, so the gap between these two circles IS the
            # clipping: at r_duct 0.20 the hole passes 4.4% of the cone's area, at
            # 0.55 it passes 33%, at 0.85 it passes 80%.
            inl_c = np.array([float(R_POT), 0.0, float(Z_DUCT)])
            xh_ = np.array([1.0, 0.0, 0.0])
            dx_ = float(F4b[0] - P4b[0])
            if abs(dx_) > 1e-9:
                t_ = (inl_c[0] - P4b[0]) / dx_
                hit_ = P4b + t_ * (F4b - P4b)
                r_beam = r_m4b * float(np.linalg.norm(hit_ - F4b)) \
                    / max(float(np.linalg.norm(F4b - P4b)), 1e-9)
                hoop(inl_c, xh_, r_beam, (255, 205, 110, 225))        # what arrives
            disc(inl_c, xh_, r_ductb, (255, 110, 90, 40), 28)         # what fits through
            hoop(inl_c, xh_, r_ductb, (255, 110, 90, 255))

            # WHAT THE POLICY IS DOING WITH M3.  The faint arc is every loaf the
            # mirror can reach (+-phw about SPOT_PHI0, the design table's own travel
            # column); the bright ray is where the actuator has it aimed THIS step.
            if tri_b:
                arc_ = [self.tri_target(p_) for p_ in np.linspace(-phw_b, phw_b, 25)]
                for j_ in range(len(arc_) - 1):
                    pr.draw_line_3d(v3(arc_[j_]), v3(arc_[j_+1]), (90, 150, 170, 150))
                for p_ in (-phw_b, phw_b):
                    pr.draw_sphere(v3(self.tri_target(p_)), 0.05, (90, 150, 170, 210))
                pr.draw_line_3d(v3(P4b), v3(F4b), (120, 220, 235, 235))
                pr.draw_sphere(v3(F4b), 0.09, (255, 230, 140, 255))   # the commanded loaf
            else:
                pr.draw_line_3d(v3(P4b), v3(F4b), (120, 220, 235, 200))
            Q_ = Ff_ - self.d_strip*self.cs_A if self.sec_side == "greg" else Ff_
            pr.draw_line_3d(v3(Ps_), v3(Q_), colt)                    # the arm
            for zz in np.linspace(self.z_deck, Ps_[2], 6):            # north tower
                ring([Ps_[0], 0, zz], 0.20, (150, 140, 120, 255), 12)
        else:
            pr.draw_line_3d(v3([X_TOWER, 0, self.z_tube[1] + 0.6]),
                            v3([X_TOWER, 0, self.z_fold]), (160, 148, 126, 255))
            r_out = self.r_tube + 0.05
            for zz in np.linspace(Z_ROOF, self.z_tube[1] + 0.6, 10):
                ring([X_TOWER, 0, zz], r_out, (150, 140, 120, 255), 14)
            for zz in np.linspace(self.z_m5, Z_ROOF, 6):    # buried outer
                ring([X_TOWER, 0, zz], self.r_m5 + 0.20, (120, 104, 88, 255),
                     20)
            # inner CPC profile (gold): the true Winston lip -> straight
            # -> expanding cone; drawn from the same knots the trace uses
            prof = []
            for zk_, rk_ in reversed(self._cpc_knots):
                prof.append((self.z_tube[1] + zk_, rk_))
            for zz in np.linspace(self.z_tube[1], self.z_tube[0], 3):
                prof.append((zz, self.r_tube_in))
            for zz in np.linspace(self.z_tube[0], self.z_m5 + 0.35, 6):
                prof.append((zz, self.r_tube_in
                             + (self.r_m5 - self.r_tube_in)
                             * (self.z_tube[0] - zz)
                             / (self.z_tube[0] - self.z_m5)))
            for zz, rr_ in prof:
                ring([X_TOWER, 0, zz], rr_, (205, 175, 120, 255), 16)
            for aa in (0, np.pi/2, np.pi, 3*np.pi/2):
                pts_ = [np.array([X_TOWER + r_*np.cos(aa), r_*np.sin(aa), zz])
                        for zz, r_ in prof]
                for k in range(len(pts_) - 1):
                    pr.draw_line_3d(v3(pts_[k]), v3(pts_[k+1]),
                                    (205, 175, 120, 255))
        # fenced no-build ring the dish sweeps over
        ring([self.X_TOWER_C, 0, H_POT + 0.02], self.g_orbit + self.cfg.a,
             (150, 130, 190, 255), 72)
        if H is not None:
            u = H["u"]
            # ---- THE CARRIAGE, from Hashemi's construction photos
            # (figs 9-18): a FIXED ring rail + the central post; the only
            # moving part is one beam rotating about the post, carrying
            # two A-frames and the focus-centred arc rail the dish slides
            # on. Elevation = the dish's position along the arc; azimuth
            # = the beam's rotation. Scaled from his 2 m yard unit.
            g, a = self.g_orbit, self.cfg.a
            R_rail, R_ring = g + 0.35, self.r_rail
            zh_ = np.array([0., 0., 1.])
            hdir = -(u - u[2]*zh_)
            hdir = hdir / max(np.linalg.norm(hdir), 1e-9)
            e_s = np.cross(zh_, hdir)
            Pf_ = np.array([self.X_TOWER_C, 0., self.z_fold])
            z_beam = self.z_deck + 0.10
            colc = (150, 140, 120, 255)
            arc = lambda e_: Pf_ + R_rail*(np.cos(e_)*hdir
                                           - np.sin(e_)*zh_)
            # fixed ring rail on posts (roof stubs south, courtyard north)
            ring([self.X_TOWER_C, 0, z_beam - 0.05], R_ring, (120, 104, 88, 255),
                 48)
            for aa in np.linspace(0, 2*np.pi, 12, endpoint=False):
                fx = self.X_TOWER_C + R_ring*np.cos(aa); fy = R_ring*np.sin(aa)
                pr.draw_line_3d(v3([fx, fy, z_beam-0.05]),
                                v3([fx, fy, self.z_deck]), (104, 92, 76, 255))
            # rotating beam through the collar on the mast, wheels at rim
            for sgn in (1.0, -1.0):
                pr.draw_line_3d(v3(Pf_*[1,1,0] + [0,0,z_beam]),
                                v3(Pf_*[1,1,0] + [0,0,z_beam]
                                   + sgn*R_ring*hdir), colc)
                wp = Pf_*[1,1,0] + [0,0,z_beam] + sgn*R_ring*hdir
                ring(wp - [0,0,0.06], 0.10, (200,180,140,255), 10)
            ring([self.X_TOWER_C, 0, z_beam], 0.22, colc, 12)   # the collar
            # two A-frames on the beam holding the arc rail
            for rA in (2.9, 4.4):
                eA = np.arccos(np.clip(rA / R_rail, -1, 1))
                apex = arc(eA)
                for sgn in (1.0, -1.0):
                    foot = (Pf_*[1,1,0] + [0,0,z_beam]
                            + rA*hdir + sgn*0.55*e_s)
                    pr.draw_line_3d(v3(foot), v3(apex), colc)
            # the arc rail (circle D, centred on the FOLD), two tubes
            e_lo = np.radians(self.el_min_h - 2)
            e_hi = np.radians(self.el_max_h + 2)
            ee = np.linspace(e_lo, e_hi, 22)
            for off in (0.45, -0.45):
                pts_ = [arc(x) + off*e_s for x in ee]
                for k in range(21):
                    pr.draw_line_3d(v3(pts_[k]), v3(pts_[k+1]),
                                    (168, 150, 122, 255))
            # strap bearings + threaded-rod ties: dish back to the rail
            el_r = np.radians(H.get("el_b", H["el"]))
            dstrap = np.arcsin(np.clip(0.8*a / R_rail, -1, 1))
            Cd_ = np.asarray(H["C"])
            p_up = (hdir*np.sin(el_r) + zh_*np.cos(el_r))
            for sg_ in (1.0, -1.0):
                strap = arc(el_r + sg_*dstrap)
                rim = Cd_ + sg_*0.8*a*p_up
                pr.draw_line_3d(v3(strap), v3(rim), (200, 180, 140, 255))
                ring(strap, 0.08, (200, 180, 140, 255), 8)
            # counterweight at the arc's upper end (fig 18)
            pr.draw_sphere(v3(arc(e_lo) - 0.15*zh_), 0.14,
                           (110, 110, 120, 255))

            if self.receiver == "focus":
                # RECEIVER AT THE FOCUS: M1 (steerable flat) at F, M2 the
                # collimating off-axis paraboloid on the exit (turntable:
                # west while the sun is east, east while west), the
                # collimated leg to M3 on the wall line, M3 turning it
                # into the chase. Per-env exit as the mount computes it.
                ub_ = np.asarray(H.get("ub", u))
                el_e = np.radians(self.exit_el)
                side = -1.0 if u[1] > 0 else 1.0
                e_ = np.array([0.0, side*np.cos(el_e), np.sin(el_e)])
                Ff = self.F_focus
                P2_ = Ff + self.col_dist*e_
                A2_ = self.fc_P3 - P2_
                A2_ /= max(np.linalg.norm(A2_), 1e-9)
                nf = ub_ - e_
                nf /= max(np.linalg.norm(nf), 1e-9)
                n2_ = e_ - A2_
                n2_ /= max(np.linalg.norm(n2_), 1e-9)
                n3_ = A2_ + np.array([0., 0., 1.])
                n3_ /= max(np.linalg.norm(n3_), 1e-9)
                inc_ = np.arccos(np.clip(abs(ub_ @ nf), 0.0, 1.0))
                e_pa = ub_ - (ub_ @ nf)*nf
                e_pa /= max(np.linalg.norm(e_pa), 1e-9)
                e_pr = np.cross(nf, e_pa)
                t = np.linspace(0, 2*np.pi, 25)
                fr = [Ff + self.r_m1*(np.cos(x)/max(np.cos(inc_), 0.2)*e_pa
                                     + np.sin(x)*e_pr) for x in t]
                for k in range(24):
                    pr.draw_line_3d(v3(fr[k]), v3(fr[k+1]),
                                    (235, 110, 110, 255))          # M1
                disc(P2_, n2_, self.col_radius, (235, 160, 90, 230), 20)  # M2
                disc(self.fc_P3, n3_, self.r_m3, (200, 140, 235, 230), 20)  # M3
                pr.draw_line_3d(v3(Ff), v3(P2_), (235, 200, 90, 200))
                pr.draw_line_3d(v3(P2_), v3(self.fc_P3), (235, 200, 90, 200))
                pr.draw_line_3d(v3(self.fc_P3), v3(self.fc_P4), (235, 200, 90, 120))
                # turntable ring under M1/M2 and the F marker
                ring(Ff - np.array([0, 0, 0.30]), 0.35, (200, 180, 140, 255), 14)
                ring(Ff, 0.12, (235, 200, 90, 255), 14)
            elif self._cass:
                # THE ROTATING STRIP: a patch of the conic with foci F and
                # F2 (hyperboloid before F for cass, ellipsoid beyond F
                # for greg), turned about the F-F2 axis to sit under the
                # dish's cone. Rows along the meridian (polar window),
                # columns across the strip width. Points from F: r(u) =
                # (c^2-a^2)/(a + c u.A) [cass] or (a^2-c^2)/(a - c u.A) [greg].
                ub_ = np.asarray(H.get("ub", u))
                Ff, A_ = self.F_focus, self.cs_A
                a_h, c_h = self.cs_a, self.cs_c
                greg_ = self.sec_side == "greg"
                sd_ = ub_ if greg_ else -ub_
                m_ = sd_ - (sd_ @ A_)*A_                     # the meridian
                m_ /= max(np.linalg.norm(m_), 1e-9)
                m2_ = np.cross(A_, m_)
                th_ = np.radians(np.linspace(self.strip_th_lo, self.strip_th_hi, 9))
                rows_ = []
                for th in th_:
                    ca_, sa_ = np.cos(th), np.sin(th)
                    r0_ = ((a_h*a_h - c_h*c_h) / max(a_h - c_h*ca_, 1e-6)) if greg_ \
                        else ((c_h*c_h - a_h*a_h) / max(a_h + c_h*ca_, 1e-6))
                    rho_ = r0_*sa_
                    dphi = min(0.5*self.w_strip / max(rho_, 1e-6), np.pi)
                    row_ = []
                    for ph in np.linspace(-dphi, dphi, 7):
                        u_ = ca_*A_ + sa_*(np.cos(ph)*m_ + np.sin(ph)*m2_)
                        r_ = ((a_h*a_h - c_h*c_h) / max(a_h - c_h*(u_ @ A_), 1e-6)) if greg_ \
                            else ((c_h*c_h - a_h*a_h) / max(a_h + c_h*(u_ @ A_), 1e-6))
                        row_.append(Ff + r_*u_)
                    rows_.append(row_)
                for i_ in range(len(rows_)):
                    for j_ in range(6):
                        pr.draw_line_3d(v3(rows_[i_][j_]), v3(rows_[i_][j_+1]), (200, 140, 235, 255))
                    if i_ + 1 < len(rows_):
                        for j_ in range(7):
                            pr.draw_line_3d(v3(rows_[i_][j_]), v3(rows_[i_+1][j_]), (200, 140, 235, 255))
                # the F-F2 axis (faint), the F marker, the strip's bearing ring on the axis
                pr.draw_line_3d(v3(Ff), v3(self.cs_P4), (235, 200, 90, 90))
                ring(Ff, 0.12, (235, 200, 90, 255), 14)
                Qb_ = Ff - (self.d_strip if greg_ else 0.35)*A_
                e1b = np.cross(A_, [0., 1., 0.]); e1b /= max(np.linalg.norm(e1b), 1e-9)
                e2b = np.cross(A_, e1b)
                rb_ = [Qb_ + 0.30*(np.cos(x)*e1b + np.sin(x)*e2b) for x in np.linspace(0, 2*np.pi, 15)]
                for k in range(14):
                    pr.draw_line_3d(v3(rb_[k]), v3(rb_[k+1]), (200, 180, 140, 255))
            else:
                # the FIXED fold: the true ELLIPTICAL plate (semi-major
                # r_fold/cos i along the beam) on a visible two-axis yoke.
                # It stays FLAT because only a flat images perfectly under a
                # deviation that sweeps 90+el; a rigidly tracked powered
                # conic measured 1.3-3.5 m rms off-design.
                ub_ = np.asarray(H.get("ub", u))
                nf = ub_ + np.array([0., 0., 1.])
                nf /= np.linalg.norm(nf)
                Pf = np.array([X_TOWER, 0., self.z_fold])
                inc_ = np.arccos(np.clip(abs(ub_ @ nf), 0.0, 1.0))
                e_pa = ub_ - (ub_ @ nf)*nf
                e_pa /= max(np.linalg.norm(e_pa), 1e-9)
                e_pr = np.cross(nf, e_pa)
                t = np.linspace(0, 2*np.pi, 41)
                for sc_ in (1.0, 0.55):
                    fr = [Pf + sc_*self.r_fold*(np.cos(x)/np.cos(inc_)*e_pa
                                                + np.sin(x)*e_pr) for x in t]
                    for k in range(40):
                        pr.draw_line_3d(v3(fr[k]), v3(fr[k+1]),
                                        (235, 110, 110, 255))
                pr.draw_line_3d(v3(Pf), v3(Pf + 0.7*nf), (235, 110, 110, 255))
                # yoke: yaw collar on the post, pitch trunnions to the rim
                ring(Pf - np.array([0, 0, 0.35]), 0.30,
                     (200, 180, 140, 255), 14)
                for sgn_ in (1.0, -1.0):
                    tr = Pf + sgn_*1.05*self.r_fold*e_pr
                    pr.draw_line_3d(v3(tr), v3(Pf - np.array([0, 0, 0.35])
                                               + sgn_*0.30*e_pr),
                                    (200, 180, 140, 255))
                # waist marker: the fixed point the whole design pivots on
                ring([X_TOWER, 0, self.z_waist], 0.12, (235, 200, 90, 255), 14)
            # THE PRIMARY, drawn as built: rim, sagged rings and
            # meridians of the actual membrane, slot as a real notch.
            el_r0 = np.radians(H.get("el_b", H["el"]))
            p_upw = hdir*np.sin(el_r0) + zh_*np.cos(el_r0)
            s_dirw = -p_upw
            naim_ = np.asarray(H.get("naim", u))
            e_ppw = np.cross(naim_, s_dirw)
            e_ppw /= max(np.linalg.norm(e_ppw), 1e-9)
            Cd_ = np.asarray(H["C"])
            Ml = _align_np([0., 0., 1.], naim_)
            r32 = self._mem0["r"].numpy()
            s32 = self._mem0["s"].numpy()
            def _slotted(qw):
                if self.slotless:
                    return False       # uncut dish: no notch to draw
                qq = qw - Cd_
                return (qq @ s_dirw) > self.slot_r0 and \
                    abs(qq @ e_ppw) < self.slot_w2
            colm = (90, 150, 235, 255)
            for rr_ in (0.35*a, 0.65*a, 0.86*a, 0.995*a):
                zz_ = float(np.interp(rr_, r32, s32))
                th_ = np.linspace(0, 2*np.pi, 49)
                pts_ = [Ml @ np.array([rr_*np.cos(x), rr_*np.sin(x), zz_])
                        + Cd_ for x in th_]
                for k in range(48):
                    if _slotted(pts_[k]) or _slotted(pts_[k+1]):
                        continue
                    pr.draw_line_3d(v3(pts_[k]), v3(pts_[k+1]), colm)
            for am_ in np.linspace(0, 2*np.pi, 12, endpoint=False):
                rs_ = np.linspace(0.3*a, a, 7)
                pts_ = [Ml @ np.array(
                    [r_*np.cos(am_), r_*np.sin(am_),
                     float(np.interp(r_, r32, s32))]) + Cd_ for r_ in rs_]
                for k in range(6):
                    if _slotted(pts_[k]) or _slotted(pts_[k+1]):
                        continue
                    pr.draw_line_3d(v3(pts_[k]), v3(pts_[k+1]), colm)
            if not self.slotless:
                for sgn_ in (1.0, -1.0):
                    q0 = Cd_ + self.slot_r0*s_dirw \
                        + sgn_*self.slot_w2*e_ppw
                    q1 = Cd_ + a*s_dirw + sgn_*self.slot_w2*e_ppw
                    pr.draw_line_3d(v3(q0), v3(q1), (235, 190, 90, 255))
            # every traced ray, additive; spill in red
            pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
            a_hi = int(4 + 20*dim)
            cb = (150, 112, 40, min(int(a_hi * 1.6), 255))
            cd = (150, 40, 30, 42)
            ok, th = H["ok"], H["through"]
            fold, m5, duct = H["fold"], H["m5"], H["duct"]
            dish = H["dish"]
            # EVERY collected ray is drawn to where it actually ends.
            # RED = a miss, at its true death point - the tube wall, the
            # M5 bound, or the duct rim. The red count IS the miss
            # count; hiding it hid the design's real losses.
            okp = H.get("ok_pre", ok)
            for i in range(0, len(dish), 2):
                pr.draw_line_3d(v3(dish[i] + 2.6*u), v3(dish[i]),
                                (60, 52, 30, max(a_hi//2, 2)))
                if not okp[i]:
                    continue
                if not ok[i]:
                    # died at the tube gates or the M5 bound: drawn along
                    # its ACTUAL reflected path to the lip plane. (The
                    # first version drew a fabricated vertical stub from
                    # the fold hit - a 2.3 m wide curtain of geometry
                    # that never existed, read as "rays going straight
                    # from the primary into the tandoor".)
                    pr.draw_line_3d(v3(dish[i]), v3(fold[i]), cd)
                    pr.draw_line_3d(v3(fold[i]), v3(H["desc"][i]), cd)
                    continue
                col = cb if th[i] else cd
                pr.draw_line_3d(v3(dish[i]), v3(fold[i]), col)
                if self.receiver == "focus":
                    # M1 -> M2 (desc) -> M3 (leg meets M3's plane) -> M4 (m5) -> duct
                    h2_ = H["desc"][i]
                    dn_ = float(A2_ @ n3_)
                    t3_ = float((self.fc_P3 - h2_) @ n3_) / (dn_ if abs(dn_) > 1e-9 else 1e-9)
                    h3_ = h2_ + t3_*A2_
                    pr.draw_line_3d(v3(fold[i]), v3(h2_), col)
                    pr.draw_line_3d(v3(h2_), v3(h3_), col)
                    pr.draw_line_3d(v3(h3_), v3(m5[i]), col)
                else:
                    pr.draw_line_3d(v3(fold[i]), v3(m5[i]), col)
                pr.draw_line_3d(v3(m5[i]), v3(duct[i]), col)
            lr = getattr(self, "_last_rays", None)
            if lr is not None:
                st = lr["strike"]; thr = lr["through"]
                # map the shared-bin frame back: ours = (-y, x, z + H_POT)
                for i in range(0, len(st), 2):
                    if thr[i]:
                        pr.draw_line_3d(
                            v3(duct[i]),
                            v3([-st[i][1], st[i][0], st[i][2] + H_POT]),
                            cb)
            pr.end_blend_mode()
        pr.end_mode_3d()
        for wp, txt, col in getattr(self, "_pot_lbls", []):
            sp = pr.get_world_to_screen(v3(wp), cam)
            if 8 < sp.x < 960 and 8 < sp.y < HT - 12:
                pr.draw_text(txt, int(sp.x) - 12, int(sp.y) - 6, 13,
                             (col[0], col[1], col[2], 235))
        # THE SURFACE TAGS: every surface after the secondary that took rays, labelled
        # where the rays landed with what landed there (see _surface_tags)
        _tags = []
        for wp, txt, col in self._surface_tags():
            if wp is None:                                   # the totals line, top-left
                pr.draw_text(txt, 20, 36, 14, (col[0], col[1], col[2], 235)); continue
            sp = pr.get_world_to_screen(v3(wp), cam)
            if 8 < sp.x < 960 and 8 < sp.y < HT - 12:
                _tags.append([float(sp.x), float(sp.y), txt, col])
        # A tag sits AT its surface. Only when its text box would lie on top of one
        # already drawn is it dropped a line (up to three), with a leader back to the
        # anchor so it still reads as that surface's. The anchor dot never moves.
        _placed = []                                      # (x0, x1, y0, y1) of drawn text boxes
        for x_, y_, txt, col in sorted(_tags, key=lambda t_: t_[1]):
            pr.draw_circle(int(x_), int(y_), 3.0, (col[0], col[1], col[2], 255))     # the anchor
            w_ = 7.0 * len(txt); tx_, ty_ = x_ + 7.0, y_ - 6.0
            for _k in range(4):
                box = (tx_, tx_ + w_, ty_, ty_ + 13.0)
                if not any(box[0] < b[1] and box[1] > b[0] and box[2] < b[3] and box[3] > b[2] for b in _placed):
                    break
                ty_ += 13.0
            if ty_ > y_ - 6.0 + 0.5:                       # moved: leader from the anchor to the text
                pr.draw_line(int(x_), int(y_), int(tx_), int(ty_ + 6.0), (col[0], col[1], col[2], 160))
            pr.draw_text(txt, int(tx_), int(ty_), 13, (col[0], col[1], col[2], 235))
            _placed.append((tx_, tx_ + w_, ty_, ty_ + 13.0))
        self._draw_bread_strip(pr, 1015, 26)
        self._draw_disturbances(pr, 1015, 120)
        if self._cass:
            tilt_ = np.degrees(np.arccos(np.clip(-self.cs_A[2], -1, 1)))
            hud = [f"dish f {self.f_nom:.1f} m hinged at F, {self.post_offset:.1f} m N of wall",
                   f"{'ellipsoid' if self.sec_side == 'greg' else 'hyperboloid'} strip d {self.d_strip:.1f} m, foci F & F2, mag {self.cs_mag:.1f}",
                   ((lambda rm, rd, rb, fr, tn, sp:
                     # one HUD row is ~55 characters before it runs under the graphs: the built
                     # sizes, the commanded turn against its travel, and what the inlet admits
                     f"bore {self.r_bore:.1f} M3 r{rm:.2f} turn {tn:+.0f}/{sp:.0f}d slot{int(self.tri_aim_bin()[0])} "
                     f"inlet r{rd:.2f} {100*fr:.0f}%thru"
                     )(*self.receiver0())
                    if self.tri0() else
                    (lambda rm, rd, rb, fr, tn, sp:
                     f"bore r {self.r_bore:.1f}, {tilt_:.0f} deg; F2 {self.u_f2:.1f} m up; "
                     f"M4 r{rm:.2f}  inlet r{rd:.2f} = {100*fr:.0f}% thru (waist)"
                     )(*self.receiver0())),
                   f"strip {self.strip_th_lo:.0f}-{self.strip_th_hi:.0f} deg x {self.w_strip:.1f} m, shadow "
                   f"{self.obstruction*100:.0f}%"]
        elif self.receiver == "focus":
            side_ = "E" if (H is not None and H["u"][1] < 0) else "W"
            hud = [f"dish f {self.f_nom:.1f} m hinged at F, {self.post_offset:.1f} m N of wall",
                   f"F z {self.z_fold:.1f}  M1 r {self.r_m1:.2f}  M2 r {self.col_radius:.2f} @{self.col_dist:.2f}",
                   f"M3 r {self.r_m3:.1f} z {self.fc_P3[2]:.1f}  chase r {self.r_bore:.1f}  M4 r {self.r_m4:.1f}",
                   f"exit {side_}-up {self.exit_el:.0f} deg, leg {self.leg_tilt:.0f} deg, shadow "
                   f"{self.obstruction*100:.0f}%"]
        else:
          hud = [f"dish f {self.f_nom:.1f} m orbits fixed fold at "
               f"g {self.g_orbit:.1f} m",
                 f"fold r {self.r_fold:.2f} m  waist z {self.z_waist:.1f}"
                 f" m  M5 r {self.r_m5:.2f} m",
                 ("uncut dish, beta schedule"
                  + (f" cap {self.beta_cap_z:.1f} m"
                     if self.beta_cap_z is not None else ""))
                 if self.slotless else
                 f"slot cut, obstruction {self.obstruction*100:.0f}%"]
        hud_y0, hud_dy = (290, 19) if (self.receiver == "focus" or self._cass) else (300, 22)
        for j, l in enumerate(hud):
            pr.draw_text(l, 1015, hud_y0 + hud_dy*j, 15, (225, 225, 205, 255))
        # the day so far, as line graphs - control is a TRAJECTORY:
        # the instantaneous numbers hid ramps, overshoot, and the
        # schedule's sign flip
        self._ts_append()
        h_ = self._ts_h
        gx, gw, gy, gh, gp = 1012, 376, 372, 72, 4
        tsp = (h_["t"][0], h_["t"][-1]) if h_["t"] else None
        self._draw_ts(pr, gx, gy, gw, gh, "power into pot",
                      [(h_["pin"], (235, 180, 80, 255), "pot kW"),
                       (h_["dni"], (108, 114, 126, 255),
                        "dni 100W/m2")], unit="kW", fmt=".1f")
        self._draw_ts(pr, gx, gy + (gh + gp), gw, gh, "wall temp",
                      [(h_["belt"], (235, 140, 60, 255), "belt"),
                       (h_["hearth"], (225, 80, 60, 255), "hearth"),
                       (h_["halo"], (120, 150, 200, 255), "halo")],
                      unit="K")
        self._draw_ts(pr, gx, gy + 2 * (gh + gp), gw, gh, "optics",
                      [(h_["thr"], (110, 210, 130, 255), "through"),
                       (h_["shadow"], (220, 90, 90, 255), "shadow")],
                      unit="%")
        self._draw_ts(pr, gx, gy + 3 * (gh + gp), gw, gh, "elevation",
                      [(h_["el"], (235, 210, 90, 255), "sun"),
                       (h_["elb"], (95, 200, 220, 255), "beam")],
                      unit="deg")
        self._draw_ts(pr, gx, gy + 4 * (gh + gp), gw, gh, "naans",
                      [(h_["rotis"], (230, 230, 235, 255), "cooked")])
        self._draw_ts(pr, gx, gy + 5 * (gh + gp), gw, gh, "reward",
                      [(h_["rew"], (140, 220, 140, 255), "r/step"),
                       (h_["ret"], (200, 160, 240, 255), "ret/100")],
                      tspan=tsp, fmt=".1f")
        if self.tri0():
            foot1 = ("EXACT, THREE MIRRORS: dish -> rotating conic strip at the focus "
                     "(foci F, F2) -> straight bore -> M3 at the turn -> THE BREAD. No elbow.")
            foot2 = ("M3 turns about the bore's own axis to choose the roti, so the cone "
                     "it sees never changes. The strip turns with the sun; nothing else moves.")
        elif self._cass:
            foot1 = ("EXACT: dish -> rotating conic strip at the focus (foci F, F2) "
                     "-> straight bore -> ellipsoid M4 at the turn -> duct -> pot.")
            foot2 = ("The strip turns about the F-F2 axis with the sun; nothing else "
                     "moves. Dish square to the sun, hinged at F; F post from the north.")
        elif self.receiver == "focus":
            foot1 = ("EXACT: dish -> M1 AT the focus -> M2 collimator -> M3 "
                     "on the wall -> chase -> M4 at the turn -> duct -> pot.")
            foot2 = ("M1+M2 turn with the sun (west while it is east, east "
                     "while west); dish square to the sun, hinged at F.")
        else:
            foot1 = ("EXACT: dish -> FIXED 2-axis fold -> waist -> FIXED "
                     "ellipsoid M5 -> native air inlet -> pot.")
            foot2 = ("Nothing below the fold ever moves. Sealed below the "
                     "roof deck; open air above it, inside the fence.")
        pr.draw_text(foot1, 20, HT-72, 16, (150, 200, 160, 255))
        pr.draw_text(foot2, 20, HT-50, 16, (150, 200, 160, 255))
        pr.draw_text("left-drag orbit  right-drag pan  wheel zoom  R reset",
                     20, HT-26, 16, (140, 140, 155, 255))
        pr.end_drawing()
        snap = os.environ.get("TANDOOR_RENDER_SNAP")
        if snap:
            # export_image takes the path as given (take_screenshot prepends
            # the working directory and silently fails on absolute paths)
            img = pr.load_image_from_screen()
            pr.export_image(img, snap)
            pr.unload_image(img)
        return None

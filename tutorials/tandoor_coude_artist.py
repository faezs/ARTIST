"""Live, batched, ARTIST-based coude trace. Replaces the lookup table.

WHY THE TABLE HAD TO GO. _build_coude_table tabulated the traced pass
fraction over (pressure level x elevation) at az = 0 and interpolated it
at runtime. Two things fell out of the model entirely:

  * sigma_b - the per-agent, per-step blur from wind and pressure error -
    appeared ONLY in the signature of _trace_power. Wind had exactly zero
    effect on delivered power, so the env's central control problem was
    partly fictional.
  * azimuth. The table was built at az = 0. The coude's invariance means
    the PASS fraction really is azimuth-independent, but the strike
    PATTERN rotates about the chase axis as the sun swings, so which belt
    segments get heated was frozen at the az = 0 pattern.

Everything here is ARTIST: NURBSSurface for the membrane (points and
normals from the spline's own derivatives), Sun + rotate_distortions for
the solar cone, reflect() at every mirror, and TowerTargetAreas +
line_plane_intersections for every plane hit.

THE ONE THING ARTIST CANNOT DO, stated plainly: it has no ray-surface
intersection primitive. Its raytracer emits rays FROM surface points AT a
target plane; NURBSSurface.calculate_surface_points_and_normals evaluates
at uv and never intersects. A Cassegrain needs a real ray-secondary
intersection, so the convex secondary keeps its closed-form conic
intersect. Everything downstream of it is ARTIST.
"""

import numpy as np
import torch

from artist.raytracing.raytracing_utils import reflect

import tandoor_artist_optics as AO
import tandoor_coude_optics as CO


def _v4(t):
    return torch.cat([t, torch.zeros_like(t[..., :1])], dim=-1)


def _p4(t):
    return torch.cat([t, torch.ones_like(t[..., :1])], dim=-1)


class CoudeTracer:
    """Holds the ARTIST surfaces; traces a whole batch every step."""

    def __init__(self, sim, cfg, mems, cx, cy, sec, z_m4, device,
                 tag="", z_m3=-0.45):
        self.device = device
        # _sim pins its DEVICE to cpu for the small 1-D solves, so the
        # secondary's asphere coefficients land there. Move them or every
        # matmul in intersect() trips the mps/cpu boundary.
        sec.coeffs = sec.coeffs.to(device)
        self.sec = sec
        self.z_m4 = float(z_m4)
        self.z_m3 = float(z_m3)
        self.membrane = AO.MembraneNURBS(sim, cfg, mems, cx, cy, device,
                                         tag=tag)
        self.sun = AO.SunCone(device)
        self.P = len(cx)
        z_sec = float(sec.zc + sec.A)
        self.rho_sec = float(sec.rho_max)
        # every optical surface as an ARTIST target area
        self.pl_sec = AO.make_plane("secondary", [0., 0., z_sec],
                                    [0., 0., 1.], 4., 4., device)
        self.pl_m3 = AO.make_plane("M3", [0., 0., self.z_m3],
                                   [0., 0., 1.], 2., 2., device)
        self.n_m3 = torch.tensor([1., 0., 1., 0.], device=device) / np.sqrt(2)
        self.n_m5 = torch.tensor([1., 0., -1., 0.], device=device) / np.sqrt(2)
        self.pl_duct = AO.make_plane("duct", [CO.R_POT, 0., CO.Z_DUCT],
                                     [1., 0., 0.], 1., 1., device)
        self.pl_chase = AO.make_plane("chase", [CO.X_CHASE, 0., CO.Z_DUCT],
                                      [0., 0., 1.], 2., 2., device)

    def _mount(self, el_deg, az_deg):
        """Dish->world via ARTIST's own rotations (rotate_e about east,
        rotate_u about up) instead of a hand-rolled Rodrigues."""
        dev = self.device
        # MPS has no float64, and np.radians returns one - pin float32.
        e = torch.tensor([np.radians(90.0 - el_deg)], dtype=torch.float32,
                         device=dev)
        u = torch.tensor([np.radians(az_deg)], dtype=torch.float32,
                         device=dev)
        M = (AO.utils.rotate_u(u=u, device=dev)[0]
             @ AO.utils.rotate_e(e=e, device=dev)[0])[:3, :3]
        axis_w = M @ torch.tensor([1., 0., 0.], device=dev)
        p_m4 = torch.tensor([CO.X_CHASE, 0., self.z_m4], device=dev)
        p_m3 = p_m4 - CO.D_EL * axis_w
        pivot = p_m3 - M @ torch.tensor([0., 0., self.z_m3], device=dev)
        return M, axis_w, p_m4, pivot

    def trace(self, lv, sigma, el_deg, az_deg, offset, seed):
        """One live batched trace. lv (B,) level index, sigma (B,) rad."""
        dev, P = self.device, self.P
        B = lv.shape[0]
        pts, nrm = self.membrane.sample(lv)
        # ARTIST solar cone, scattered about the dish's -z (anti-sun travel)
        inc = _v4(self.sun.scatter(torch.tensor([0., 0., -1.],
                                        device=self.device), sigma,
                                   B, P, seed))
        d1 = reflect(inc, nrm)
        # the secondary shadows the sun BEFORE it reaches the primary
        back = AO.hit_plane(pts.reshape(-1, 4), (-inc).reshape(-1, 4),
                            self.pl_sec, dev).reshape(B, P, 4)
        lit = back[..., :2].norm(dim=-1) > self.rho_sec
        hit2, n2, ok = self.sec.intersect(pts, d1)
        d2 = reflect(d1, n2)
        ok = ok & lit
        # M3, still in the dish frame
        h3 = AO.hit_plane(hit2.reshape(-1, 4), d2.reshape(-1, 4),
                          self.pl_m3, dev).reshape(B, P, 4)
        fwd = ((h3 - hit2)[..., :3] * d2[..., :3]).sum(-1) > 0
        ok = ok & fwd & (h3[..., :2].norm(dim=-1) < CO.R_M3)
        d3 = reflect(d2, self.n_m3.expand_as(d2))
        # dish -> world
        M, axis_w, p_m4, pivot = self._mount(el_deg, az_deg)
        h3w = h3[..., :3] @ M.T + pivot
        d3w = d3[..., :3] @ M.T
        # M4 sits on the elevation axis; its plane normal IS that axis
        pl_m4 = AO.make_plane("M4", p_m4.tolist(), axis_w.tolist(),
                              2., 2., dev)
        h4 = AO.hit_plane(_p4(h3w).reshape(-1, 4), _v4(d3w).reshape(-1, 4),
                          pl_m4, dev).reshape(B, P, 4)
        ok = ok & (((h4[..., :3] - h3w) * d3w).sum(-1) > 0)
        n4 = torch.tensor([0., 0., -1.], device=dev) - axis_w
        d4 = reflect(_v4(d3w), _v4(n4 / n4.norm()).expand_as(_v4(d3w)))
        # down the fixed vertical chase
        h5 = AO.hit_plane(h4.reshape(-1, 4), d4.reshape(-1, 4),
                          self.pl_chase, dev).reshape(B, P, 4)
        ok = ok & (d4[..., 2] < -1e-9)
        in_chase = (torch.stack([h5[..., 0] - CO.X_CHASE, h5[..., 1]], -1)
                    .norm(dim=-1) < CO.R_CHASE)
        # M5 turns it into the pot's native base air-inlet
        d5 = reflect(d4, self.n_m5.expand_as(d4))
        h6 = AO.hit_plane(h5.reshape(-1, 4), d5.reshape(-1, 4),
                          self.pl_duct, dev).reshape(B, P, 4)
        off = torch.as_tensor(offset, dtype=torch.float32,
                              device=dev).reshape(B, 1, 2)
        dy = h6[..., 1] + off[..., 0]
        dz = h6[..., 2] - CO.Z_DUCT + off[..., 1]
        through = (ok & in_chase & (d5[..., 0] < -1e-9)
                   & (torch.stack([dy, dz], -1).norm(dim=-1) < CO.R_DUCT_C))
        return through, h6, d5

    def strike_nodes(self, h6, d5, through, n_belt, n_nodes):
        """Where the beam lands inside the pot, binned onto the thermal
        nodes. A REAL cylinder intersection: the old rule advanced a
        capped distance along -x and so was a plane, not a pot wall."""
        dev = self.device
        B, P = h6.shape[0], h6.shape[1]
        o, d = h6[..., :3], d5[..., :3]
        # pot wall: |o_xy + t d_xy| = R_POT, take the forward root
        aq = (d[..., :2] ** 2).sum(-1)
        bq = (o[..., :2] * d[..., :2]).sum(-1)
        cq = (o[..., :2] ** 2).sum(-1) - CO.R_POT ** 2
        disc = (bq ** 2 - aq * cq).clamp(min=0)
        t_wall = (-bq + disc.sqrt()) / aq.clamp(min=1e-9)
        # pot floor at z = 0 (origin is the pot floor in this frame)
        t_floor = torch.where(d[..., 2] < -1e-9, -o[..., 2] / d[..., 2],
                              torch.full_like(t_wall, 1e9))
        hit_floor = t_floor < t_wall
        t = torch.where(hit_floor, t_floor, t_wall).clamp(min=0)
        s = o + t[..., None] * d
        z = s[..., 2]
        phi = torch.atan2(s[..., 1], s[..., 0])
        seg = (((phi + np.pi) / (2 * np.pi)) * n_belt).long().clamp(
            0, n_belt - 1)
        node = torch.where(
            hit_floor | (z < 0.10), torch.full_like(seg, n_belt),
            torch.where(z > 0.80, torch.full_like(seg, n_belt + 2), seg))
        off = (torch.arange(B, device=dev) * n_nodes)[:, None]
        out = torch.zeros(B * n_nodes, device=dev)
        out.index_put_(((off + node).reshape(-1),),
                       through.reshape(-1).float(), accumulate=True)
        return out.reshape(B, n_nodes) / max(P, 1)

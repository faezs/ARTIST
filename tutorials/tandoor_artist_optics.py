"""ARTIST primitives for every tandoor env. No hand-rolled optics.

WHAT THIS REPLACES, and why each replacement is not cosmetic:

  membrane surface   sag_interp() linearly interpolated a 1-D axisymmetric
                     FvK solution and built normals by hand as
                     [-slope*x/r, -slope*y/r, 1]. Now an ARTIST
                     NURBSSurface per pressure level, with points AND
                     normals from the spline's own derivatives - so the
                     normals are consistent with the surface instead of
                     being a separate analytic guess, and the whole thing
                     is differentiable end to end.

  sun cone           torch.randn(B,P,2)*sigma. Now Sun.get_distortions()
                     applied with utils.rotate_distortions(). ARTIST's
                     default sun covariance is 4.3681e-06, i.e. 2.09 mrad
                     - which is exactly the sigma_sun these envs already
                     used, so this is the same physics from the source.

  reflection         already ARTIST's reflect() via _sim, except in
                     tandoor_coude_optics which had a numpy reflect_np.

  plane hits         hand-rolled t = (z_plane - o_z)/d_z per surface. Now
                     TowerTargetAreas + line_plane_intersections.

CAVEAT, stated rather than hidden: line_plane_intersections also applies
Lambert's cosine law and a 1/r^2 distance attenuation. That is right for
a RECEIVER and wrong for a fold mirror, which redirects rather than
collects. So folds use its geometry (`intersections`) and ignore its
`absolute_intensities`; only the terminal target uses both.
"""

import hashlib
import pathlib

import numpy as np
import torch

from artist.field.tower_target_areas import TowerTargetAreas
from artist.raytracing.rays import Rays
from artist.raytracing.raytracing_utils import line_plane_intersections, reflect
from artist.scene.sun import Sun
from artist.util import utils
from artist.util.nurbs import NURBSSurface

CACHE = pathlib.Path(__file__).resolve().parent / "data" / "tandoor" / "nurbs"


# --------------------------------------------------------------- planes #
def make_plane(name, center, normal, width, height, device):
    """One optical surface as an ARTIST TowerTargetAreas of length 1."""
    c = torch.as_tensor(center, dtype=torch.float32, device=device)
    n = torch.as_tensor(normal, dtype=torch.float32, device=device)
    n = n / n.norm()
    return TowerTargetAreas(
        names=[name], geometries=["planar"],
        centers=torch.cat([c, torch.ones(1, device=device)])[None, :],
        normal_vectors=torch.cat([n, torch.zeros(1, device=device)])[None, :],
        dimensions=torch.tensor([[width, height]], dtype=torch.float32,
                                device=device),
        curvatures=torch.zeros(1, 2, dtype=torch.float32, device=device))


def hit_plane(origins, directions, plane, device):
    """Geometric ray-plane hit through ARTIST. Shapes (N,4) -> (N,4).

    line_plane_intersections wants (heliostats, rays, points, 4); we use
    one 'heliostat' and one 'ray per point', then squeeze back.
    """
    # line_plane_intersections demands the rays strike the plane's FRONT
    # (-d.n > 0) and raises otherwise. That is right for a receiver and a
    # nuisance for a fold we may hit from either side, so orient the plane
    # to face the beam: for a mirror, facing is bookkeeping, not physics.
    if float((directions[..., :3].mean(0)
              * plane.normal_vectors[0, :3]).sum()) > 0:
        plane = TowerTargetAreas(
            names=list(plane.names), geometries=list(plane.geometries),
            centers=plane.centers, normal_vectors=-plane.normal_vectors,
            dimensions=plane.dimensions, curvatures=plane.curvatures)
    d = directions[None, None, :, :]
    rays = Rays(ray_directions=d,
                ray_magnitudes=torch.ones(d.shape[:-1], device=device))
    inter, _ = line_plane_intersections(
        rays=rays, points_at_ray_origins=origins[None, :, :],
        target_areas=plane, device=device)
    return inter[0, 0]


# ------------------------------------------------------- membrane NURBS #
class MembraneNURBS:
    """One ARTIST NURBSSurface per pressure level, fitted to the FvK solve.

    The envs used to interpolate a 1-D sag table and synthesise normals.
    Here the normals come from the spline's own derivatives, so surface
    and normal cannot disagree. Fitting is warm-started level to level
    and cached on disk, because it is far too slow for env construction.
    """

    def __init__(self, sim, cfg, mems, cx, cy, device, tag="", epochs=1200):
        self.device = device
        a = float(cfg.a)
        u = torch.as_tensor(cx / (2 * a) + 0.5, dtype=torch.float32)
        v = torch.as_tensor(cy / (2 * a) + 0.5, dtype=torch.float32)
        u = u.clamp(1e-5, 1 - 1e-5).to(device)
        v = v.clamp(1e-5, 1 - 1e-5).to(device)
        key = hashlib.md5(
            f"{tag}|{a}|{cfg.T_pre}|{cfg.n_cp}|{len(mems)}|"
            f"{[round(float(m['z0']), 6) for m in mems]}".encode()).hexdigest()[:12]
        CACHE.mkdir(parents=True, exist_ok=True)
        path = CACHE / f"ctrl_{key}.pt"
        if path.exists():
            ctrls = torch.load(path, map_location="cpu")
        else:
            ctrls, prev = [], None
            for i, m in enumerate(mems):
                c, _ = sim.fit_nurbs(cfg, m, ctrl_init=prev, epochs=epochs,
                                     log_name=f"nurbs L{i}")
                ctrls.append(c.cpu()); prev = c
            ctrls = torch.stack(ctrls)
            torch.save(ctrls, path)
        self.ctrl = ctrls.to(device)
        pts, nrm = [], []
        for c in self.ctrl:
            surf = NURBSSurface(3, 3, u, v, c, device=device)
            p, n = surf.calculate_surface_points_and_normals(device=device)
            pts.append(p); nrm.append(n)
        self.points = torch.stack(pts)             # (L, P, 4)
        self.normals = torch.stack(nrm)            # (L, P, 4)
        self.n_levels = len(mems)

    def sample(self, lv):
        """Per-agent surface. lv is a float level index tensor (B,)."""
        i0 = lv.long().clamp(0, self.n_levels - 2)
        fr = (lv - i0.float())[:, None, None]
        p = (1 - fr) * self.points[i0] + fr * self.points[i0 + 1]
        n = (1 - fr) * self.normals[i0] + fr * self.normals[i0 + 1]
        return p, torch.nn.functional.normalize(n, dim=-1)


# ------------------------------------------------------------ sun cone #
class SunCone:
    """ARTIST's Sun distribution + ARTIST's rotate_distortions.

    APPLIED TO THE SUN RAY, NOT THE NORMAL, and that placement matters.
    rotate_distortions rotates about up and then east, so it is DEGENERATE
    for a vector along up: R_u leaves it fixed and only R_e tilts it, giving
    a 1-D smear instead of a cone. The beam-down's reflected ray is very
    nearly vertical, so scattering it there would be anisotropic. The
    incoming sun ray is not vertical (except at exact zenith), so that is
    where ARTIST itself scatters - see HeliostatRayTracer.

    The Sun is built with unit covariance and the sampled angles are scaled
    per agent, because covariance is fixed at construction and the blur here
    varies per step with wind. Scaling a zero-mean normal is exact, so this
    is still ARTIST's distribution, just re-scaled.
    """

    #: ARTIST's own default solar covariance, 4.3681e-06 -> 2.09 mrad.
    #: This is where these envs' sigma_sun came from in the first place.
    ARTIST_SUN_COVARIANCE = 4.3681e-06

    def __init__(self, device, n_rays=1):
        self.device = device
        self.sun = Sun(number_of_rays=n_rays,
                       distribution_parameters=dict(
                           distribution_type="normal", mean=0.0,
                           covariance=1.0),
                       device=device)

    #: Scatter this, never the real direction: it is horizontal, so both
    #: of rotate_distortions' rotations bite and the cone stays round.
    _CANON = (0.0, 1.0, 0.0, 0.0)

    def scatter(self, nominal, sigma, B, P, seed):
        """nominal (3,) unit sun direction -> (B,P,4) scattered directions.

        Scatters the canonical horizontal ray with ARTIST and then rotates
        the whole bundle onto `nominal`, which removes the pole degeneracy
        without leaving ARTIST's distribution. sigma is PER AXIS, matching
        both ARTIST's covariance and the randn(B,P,2)*sigma it replaces.
        """
        du, de = self.sun.get_distortions(number_of_points=P,
                                          number_of_heliostats=B,
                                          random_seed=int(seed) % (2 ** 31))
        s = torch.as_tensor(sigma, dtype=torch.float32,
                            device=self.device).reshape(-1, 1, 1)
        R = utils.rotate_distortions(e=de * s, u=du * s, device=self.device)
        canon = torch.tensor(self._CANON, device=self.device)
        v = (R @ canon.expand(B, 1, P, 4).unsqueeze(-1)).squeeze(-1)[:, 0]
        return (self._align(canon[:3], nominal) @ v[..., :3, None]
                ).squeeze(-1)

    def scatter_csr(self, nominal, sigma, csr_frac, csr_sigma, B, P, seed):
        """Two-component sunshape: gaussian core + circumsolar tail.

        ARTIST's Sun accepts only a normal distribution (it raises on
        anything else), so the tail is a second ARTIST sample mixed in
        rather than a different distribution type. Same mixture the envs
        already used, but now both components come from ARTIST.
        """
        core = self.scatter(nominal, sigma, B, P, seed)
        if not csr_frac:
            return core
        tail = self.scatter(nominal, np.full(B, csr_sigma), B, P,
                            seed + 977)
        g = torch.Generator(device="cpu").manual_seed(int(seed) % (2 ** 31))
        pick = (torch.rand(B, P, 1, generator=g) < float(csr_frac)).to(
            self.device)
        return torch.where(pick, tail, core)

    def _align(self, a, b):
        """Rotation carrying unit a onto unit b (Rodrigues, 3x3)."""
        b = torch.as_tensor(b, dtype=torch.float32,
                            device=self.device)[:3]
        b = b / b.norm()
        v = torch.linalg.cross(a, b)
        c = float((a * b).sum())
        if float(v.norm()) < 1e-8:
            return torch.eye(3, device=self.device) * (1.0 if c > 0 else -1.0)
        K = torch.zeros(3, 3, device=self.device)
        K[0, 1], K[0, 2] = -v[2], v[1]
        K[1, 0], K[1, 2] = v[2], -v[0]
        K[2, 0], K[2, 1] = -v[1], v[0]
        return torch.eye(3, device=self.device) + K + K @ K / (1 + c)


# ------------------------------------------------------- primary bounce #
class MembranePrimary:
    """The bit every tandoor env shares: sun -> membrane -> reflected ray.

    Each env used to do this by hand and identically: interpolate a 1-D
    sag table, synthesise the normal as [-slope*x/r, -slope*y/r, 1],
    draw randn(B,P,2)*sigma for the cone, and reflect. Now one ARTIST
    path - NURBSSurface for points AND normals, Sun for the cone,
    reflect() for the bounce - so the three envs cannot drift apart.
    """

    def __init__(self, sim, cfg, mems, cx, cy, device, tag="",
                 csr_frac=0.0, csr_sigma=15e-3):
        self.device = device
        cx = torch.as_tensor(cx, dtype=torch.float32).cpu().numpy()
        cy = torch.as_tensor(cy, dtype=torch.float32).cpu().numpy()
        self.membrane = MembraneNURBS(sim, cfg, mems, cx, cy, device, tag=tag)
        self.sun = SunCone(device)
        self.csr_frac = float(csr_frac)
        self.csr_sigma = float(csr_sigma)
        self.P = len(cx)

    def bounce(self, lv, sigma, seed, nominal=(0.0, 0.0, -1.0)):
        """-> (origins, reflected dirs, incident dirs), each (B,P,4).

        The incident ray comes back too because the renderers draw it.
        """
        B = lv.shape[0]
        pts, nrm = self.membrane.sample(lv)
        nom = torch.tensor(nominal, dtype=torch.float32, device=self.device)
        inc = self.sun.scatter_csr(nom, sigma, self.csr_frac,
                                   self.csr_sigma, B, self.P, seed)
        inc4 = torch.cat([inc, torch.zeros_like(inc[..., :1])], dim=-1)
        return pts, reflect(inc4, nrm), inc4

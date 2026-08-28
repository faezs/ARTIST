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

import numpy as np
import torch

from artist.raytracing.raytracing_utils import reflect

import tandoor_artist_optics as AO
import tandoor_coude_optics as CO
from tandoor_coude_env import TandoorCoudeEnv
from tandoor_polar_env import TandoorPolarEnv, R_MOUTH
from tandoor_rl_env import _sim, ROTI_ENERGY

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


class TandoorHashemiEnv(TandoorCoudeEnv):

    def __init__(self, *args, a_mem=2.10, g_orbit=5.0, z_waist=1.5,
                 z_m5=-0.10, el_min=12.0, r_mast=0.25, **kwargs):
        self.g_orbit = float(g_orbit)
        self.z_waist = float(z_waist)
        self.z_m5 = float(z_m5)
        self.el_min_h = float(el_min)
        self.r_mast = float(r_mast)
        super().__init__(*args, a_mem=a_mem, **kwargs)

    # ------------------------------------------------------------ mount #
    def _cosine(self, decl_deg):
        """Square to the sun always: the mount's whole point."""
        return 1.0

    def _build_optics(self):
        # coude's own _build_optics would build its lookup table; we want
        # only the polar scaffolding underneath it (cfg, thermal hooks).
        TandoorPolarEnv._build_optics(self)
        cfg, dev = self.cfg, self.device
        cfg.a = self.a_mem
        a, g = float(cfg.a), self.g_orbit

        # -- the mount solve, all of it geometric:
        # tracking ceiling: dish must not cross the mast / beam column
        self.el_max_h = float(np.degrees(np.arccos(
            np.clip((a + self.r_mast) / g, 0.0, 0.999))))
        # fold height: the dish's under-swing (g sin el + a cos el below
        # the fold) must clear the courtyard floor at every tracked el
        els = np.radians(np.linspace(self.el_min_h, self.el_max_h, 300))
        under = float((g * np.sin(els) + a * np.cos(els)).max())
        self.z_fold = H_POT + 0.35 + under
        delta = self.z_fold - self.z_waist
        f_design = g + delta

        # -- membrane pressure that puts the FITTED focus at f_design
        lo, hi = cfg.T_pre / (4 * f_design), cfg.T_pre / (0.4 * f_design)
        for _ in range(24):
            mid = 0.5 * (lo + hi)
            m = _sim.solve_membrane(cfg, mid, n=400)
            if m["z0"] + m["f_fit"] > f_design:
                lo = mid
            else:
                hi = mid
        self.p0 = float(0.5 * (lo + hi))
        cfg.dp = self.p0
        self.level_frac = np.array(self.LEVEL_FRAC)   # coude's wide dump
        mems = [_sim.solve_membrane(cfg, self.p0 * fr, n=400)
                for fr in self.level_frac]
        self._mem0 = mems[4]
        self.f_nom = float(mems[4]["z0"] + mems[4]["f_fit"])

        # -- apertures, from the beam itself
        self.r_fold = a * delta / self.f_nom * 1.08 + 0.06
        self.obstruction = (self.r_fold / a) ** 2
        self.r_m5 = (a / self.f_nom) * (self.z_waist - self.z_m5) * 1.25 \
            + 0.08

        # -- M5's ellipsoid: foci at the waist and the duct centre; sized
        # so its lower surface passes through the wall base at z_m5
        self.W = np.array([X_TOWER, 0.0, self.z_waist])
        self.T = np.array([R_POT, 0.0, Z_DUCT])
        V0 = np.array([X_TOWER, 0.0, self.z_m5])
        A2 = np.linalg.norm(V0 - self.W) + np.linalg.norm(V0 - self.T)
        self.ell_A = 0.5 * A2
        cc = 0.5 * np.linalg.norm(self.T - self.W)
        self.ell_B2 = self.ell_A ** 2 - cc ** 2
        self.ell_ctr = 0.5 * (self.W + self.T)
        w = (self.T - self.W) / np.linalg.norm(self.T - self.W)
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
        rng = np.random.default_rng(7)
        NR = 1100
        rr = np.sqrt(rng.uniform((0.05 * a) ** 2, (0.985 * a) ** 2, NR))
        th = rng.uniform(0, 2 * np.pi, NR)
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
        self._loss_chain = 0.88 * 0.95 * 0.95 * 0.96
        rho_r = 1.0 - 0.10 * (rr / a) ** 4
        cell = np.pi * (a ** 2) * (1 - 0.05 ** 2) / NR
        self._ray_pw = torch.tensor(cell * rho_r * self._loss_chain,
                                    dtype=torch.float32, device=dev)
        self._env_off = (torch.arange(self.num_agents, device=dev)
                         * self.n_nodes).repeat_interleave(NR)
        pk = 0.9 * np.pi * a * a * 0.88 * (1 - self.obstruction)
        print(f"  [hashemi] dish {np.pi*a*a:.1f} m2 f={self.f_nom:.2f} m "
              f"orbit g={g:.1f} -> fold at z={self.z_fold:.2f} m, "
              f"waist z={self.z_waist:.1f}, M5 pit z={self.z_m5:.2f}")
        print(f"  [hashemi] fold r={self.r_fold:.2f} m (obstruction "
              f"{self.obstruction*100:.0f}%), M5 r={self.r_m5:.2f} m, "
              f"track el {self.el_min_h:.0f}-{self.el_max_h:.0f} deg, "
              f"chain {self._loss_chain:.3f}, cosine 1.00, "
              f"~{pk/(np.pi*self.r_fold**2):.1f} kW/m2 on the fold")
        print(f"  [hashemi] swept ring r={g+a:.1f} m around the tower is "
              f"a fenced no-build zone; beam sealed below the fold")

    # ------------------------------------------------------------ trace #
    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        """Live ARTIST trace: dish -> fixed 2-axis fold -> waist ->
        fixed ellipsoidal M5 -> duct -> pot. No table: wind blur and the
        true sun position enter every step."""
        dev = self.device
        B, P = np.asarray(p_eff).shape[0], len(self._hx)
        el, az, u_np = _sim.solar_position(self.lat, self.day,
                                           float(self.t_solar[0]))
        if not (self.el_min_h <= el <= self.el_max_h):
            return torch.zeros(B, self.n_nodes)
        lv = np.clip((np.asarray(p_eff) / self.p0 - self.level_frac[0])
                     / (self.level_frac[-1] - self.level_frac[0])
                     * (self.N_LEVELS - 1), 0, self.N_LEVELS - 1)
        org, d4, _ = self.primary.bounce(
            torch.as_tensor(lv, dtype=torch.float32, device=dev),
            sigma_b, int(self.tick))
        # SITE ORIENTATION, pinned: world +x is NORTH. The pot room is
        # south of the wall (x<X_TOWER), the courtyard north (x>X_TOWER).
        # The dish sits down-sun of the fold, and at lat 28.6 the sun
        # rides the southern sky, so the dish stays over the northern
        # courtyard through the tracked day. solar_position returns
        # s=(east,north,up); remap to (north,east,up).
        u = np.array([u_np[1], u_np[0], u_np[2]], dtype=float)
        u /= np.linalg.norm(u)
        P_fold = np.array([X_TOWER, 0.0, self.z_fold])
        C_dish = P_fold - self.g_orbit * u          # down-sun of the fold
        M = _align_np([0.0, 0.0, 1.0], u)
        Mt = torch.tensor(M.T, dtype=torch.float32, device=dev)
        Cd = torch.tensor(C_dish, dtype=torch.float32, device=dev)
        p = org[..., :3] @ Mt + Cd
        d = d4[..., :3] @ Mt
        d = d / d.norm(dim=-1, keepdim=True)
        ut = torch.tensor(u, dtype=torch.float32, device=dev)
        Pf = torch.tensor(P_fold, dtype=torch.float32, device=dev)
        # EVERYTHING IS OPAQUE, and modelling that redesigned the tower.
        # A solid masonry column to the fold shadows the dish brutally -
        # the dish hangs directly down-sun of it, and measured throughput
        # collapsed 60% -> 7% at noon. But the dish always rides above
        # the roofline, so only the ABOVE-ROOF structure can shadow it:
        # that section is therefore SKELETAL - four slender legs carrying
        # the fold, the converging beam in open air (the same exposure
        # class as the dish->fold leg beside it, inside the same fence),
        # entering a sealed masonry hopper at the roof deck. Below the
        # roof, sealed all the way to the pot as before.
        K = 10
        zs = torch.linspace(Z_ROOF, self.z_fold - 0.10, K, device=dev)
        leg_off = 0.75 * self.r_fold
        legs = []
        for sx, sy in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
            legs.append(torch.stack(
                [torch.full((K,), X_TOWER + sx * leg_off, device=dev),
                 torch.full((K,), sy * leg_off, device=dev), zs], 1))
        Tw = torch.cat(legs, 0)                            # (4K,3)
        r_tw = torch.full((4 * K,), 0.07, device=dev)
        # (a) incoming sun: ray p + t*u, t>0 toward the sun
        w = Tw[None, None] - p[..., None, :]               # (B,P,4K,3)
        tproj = (w * ut).sum(-1)
        perp = (w - tproj[..., None] * ut).norm(dim=-1)
        lit = ~((tproj > 0) & (perp < r_tw)).any(-1)
        # the fold disc itself still shadows the dish centre
        vf = Pf - p
        perpf = vf - (vf * ut).sum(-1, keepdim=True) * ut
        lit = lit & (perpf.norm(dim=-1) > self.r_fold)
        # the fold: fixed point, two axes of tilt; output exactly -z
        zh = torch.tensor([0.0, 0.0, 1.0], device=dev)
        nf = ut + zh
        nf = nf / nf.norm()
        den = (d * nf).sum(-1)
        t1 = ((Pf - p) * nf).sum(-1) / torch.where(
            den.abs() > 1e-9, den, torch.full_like(den, 1e-9))
        h1 = p + t1[..., None] * d
        rad1 = (h1 - Pf - ((h1 - Pf) * nf).sum(-1, keepdim=True) * nf
                ).norm(dim=-1)
        # (b) the dish->fold leg against the legs and the sealed hopper
        # below the roof (rays from a low dish rim can clip its shoulder)
        Kh = 8
        zh = torch.linspace(self.z_m5 + 0.2, Z_ROOF, Kh, device=dev)
        frh = (zh - self.z_m5) / (self.z_fold - self.z_m5)
        rh = self.r_m5 + frh * (self.r_fold - self.r_m5) + 0.05
        Hp = torch.stack([torch.full((Kh,), X_TOWER, device=dev),
                          torch.zeros(Kh, device=dev), zh], 1)
        occ = torch.cat([Tw, Hp], 0)
        r_occ = torch.cat([r_tw, rh], 0)
        wb = occ[None, None] - p[..., None, :]
        tb = (wb * d[..., None, :]).sum(-1)
        perp_b = (wb - tb[..., None] * d[..., None, :]).norm(dim=-1)
        graze = ((tb > 0) & (tb < t1[..., None] - 0.10)
                 & (perp_b < r_occ)).any(-1)
        ok = lit & ~graze & (t1 > 0) & (rad1 < self.r_fold)
        d2 = reflect(torch.cat([d, torch.zeros_like(d[..., :1])], -1),
                     torch.cat([nf, torch.zeros(1, device=dev)]
                               ).expand_as(
                         torch.cat([d, torch.zeros_like(d[..., :1])], -1))
                     )[..., :3]
        # M5's ellipsoid: far root = the physical mirror at the wall base
        pl = (h1 - self.ell_ctr_t) @ self.ell_M.T
        dl = d2 @ self.ell_M.T
        qa = (dl * dl * self.ell_S).sum(-1)
        qb = 2 * (pl * dl * self.ell_S).sum(-1)
        qc = (pl * pl * self.ell_S).sum(-1) - 1
        disc = qb * qb - 4 * qa * qc
        oke = disc > 0
        sq = torch.sqrt(disc.clamp(min=0))
        t2 = (-qb + sq) / (2 * qa)
        h2 = h1 + t2[..., None] * d2
        rad2 = torch.stack([h2[..., 0] - X_TOWER, h2[..., 1]], -1
                           ).norm(dim=-1)
        ok = ok & oke & (t2 > 0) & (h2[..., 2] < self.z_waist - 0.2) \
            & (rad2 < self.r_m5)
        hl = (h2 - self.ell_ctr_t) @ self.ell_M.T
        nl = hl * self.ell_S
        nl = nl / nl.norm(dim=-1, keepdim=True)
        ne = nl @ self.ell_M
        d3 = reflect(torch.cat([d2, torch.zeros_like(d2[..., :1])], -1),
                     torch.cat([ne, torch.zeros_like(ne[..., :1])], -1)
                     )[..., :3]
        # the duct plane x = R_POT, with boresight decenter
        t3 = (R_POT - h2[..., 0]) / d3[..., 0].clamp(max=-1e-9)
        h3 = h2 + t3[..., None] * d3
        off = torch.as_tensor(offset_w, dtype=torch.float32, device=dev)
        dy = h3[..., 1] + off[:, 0:1]
        dz = h3[..., 2] - Z_DUCT + off[:, 1:2]
        through = ok & (t3 > 0) & (dy ** 2 + dz ** 2 <= R_DUCT_H ** 2)
        if self.render_mode == "human":
            self._hv = dict(dish=p[0].cpu().numpy(),
                            fold=h1[0].cpu().numpy(),
                            m5=h2[0].cpu().numpy(),
                            duct=h3[0].cpu().numpy(),
                            ok=ok[0].cpu().numpy(),
                            through=through[0].cpu().numpy(),
                            u=u, el=el, az=float(az), C=C_dish)
        # into the pot via the SHARED polar binning; rigid map between the
        # frames: theirs (x,y,z) = (y_ours, -x_ours, z_ours - H_POT)
        return self._bin_pot(dy - off[:, 0:1], dz - off[:, 1:2],
                             d3[..., 1], -d3[..., 0], d3[..., 2],
                             through, soil, B, P)

    # ------------------------------------------------ exact renderer #
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

        dim = float(np.clip(self.dni[0]/950., 0.05, 1.))
        pr.begin_drawing()
        pr.clear_background((int(11+22*dim), int(13+28*dim),
                             int(21+46*dim), 255))
        pr.draw_rectangle(1000, 0, W_-1000, HT, (13, 15, 22, 255))
        pr.begin_mode_3d(cam)
        # THE ROOM, drawn as a building: pot room south of the wall
        # (x < X_TOWER), courtyard north. Corner posts, plates, wall
        # lines, a door gap in the south wall, roof joists over the room.
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
        for gy in np.linspace(-RY, RY, 8):                # roof joists
            pr.draw_line_3d(v3([RX0, gy, Z_ROOF]), v3([RX1, gy, Z_ROOF]),
                            (92, 88, 78, 255))
        # courtyard paving, north of the wall only; workfloor inside
        for gx in np.linspace(RX1, 8, 8):
            pr.draw_line_3d(v3([gx, -8, H_POT]), v3([gx, 8, H_POT]),
                            (64, 68, 82, 255))
        for gy in np.linspace(-8, 8, 17):
            pr.draw_line_3d(v3([RX1, gy, H_POT]), v3([8, gy, H_POT]),
                            (64, 68, 82, 255))
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
        # THE EXISTING POT, drawn for real (ported from the beam-down):
        # clay barrel sunk under the workfloor, neck to the mouth
        for zz in np.linspace(0.0, H_POT, 8):
            rr_ = R_POT if zz < H_POT - 0.25 else \
                R_MOUTH + (R_POT - R_MOUTH) * (H_POT - zz) / 0.25
            ring([0, 0, zz], rr_, (150, 118, 92, 255), 28)
        ring([0, 0, H_POT], R_MOUTH, (190, 160, 120, 255), 24)
        if self.load_timer[0] >= 4.0:          # lid on between loads
            ring([0, 0, H_POT + 0.03], R_MOUTH * 0.92,
                 (120, 120, 128, 255), 20)
        # belt WALL SEGMENTS, each at its own node temperature. The bin
        # frame maps theirs->ours as (x,y) = (-y_t, x_t), so segment k's
        # arc is drawn through that map - the hot side faces the duct.
        z_lo, z_hi = 0.12, H_POT - 0.22
        for k in range(self.n_belt):
            a0 = -np.pi + 2 * np.pi * k / self.n_belt
            th_ = np.linspace(a0, a0 + 2 * np.pi / self.n_belt, 8)
            col = self._heat_color(self.T[0, k])
            for zz in (z_lo + 0.15, 0.5 * (z_lo + z_hi), z_hi - 0.10):
                for j in range(7):
                    pr.draw_line_3d(
                        v3([-R_POT*np.sin(th_[j]), R_POT*np.cos(th_[j]),
                            zz]),
                        v3([-R_POT*np.sin(th_[j+1]),
                            R_POT*np.cos(th_[j+1]), zz]), col)
            # the ROTI stuck on this wall segment, growing as it cooks
            if self.has_bread[0, k]:
                am = a0 + np.pi / self.n_belt
                fr_ = min(float(self.bread_E[0, k]) / ROTI_ENERGY, 1.0)
                pr.draw_sphere(
                    v3([-0.965*R_POT*np.sin(am), 0.965*R_POT*np.cos(am),
                        0.5*(z_lo+z_hi)]),
                    0.05 + 0.02 * fr_, (205, 170, 112, 255))
        # hearth (coal-bed spot the beam lands on) and crown
        ring([0, 0, 0.03], R_POT * 0.5,
             self._heat_color(self.T[0, self.n_belt]), 18)
        ring([0, 0, H_POT - 0.12], R_POT * 0.93,
             self._heat_color(self.T[0, self.n_belt + 2]), 22)
        ring([R_POT, 0, Z_DUCT], R_DUCT_H, (120, 220, 235, 255), 18,
             ax="x")
        # sealed masonry hopper: roof deck down to the M5 pit
        for zz in np.linspace(self.z_m5, Z_ROOF, 8):
            fr_ = (zz - self.z_m5) / (self.z_fold - self.z_m5)
            ring([X_TOWER, 0, zz], self.r_m5 + fr_*(self.r_fold-self.r_m5),
                 (140, 120, 96, 255), 22)
        # skeletal mast above the roof: four legs to the fold, beam in
        # open air (this is what the occlusion model traces against)
        lo = 0.75 * self.r_fold
        for sx, sy in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
            pr.draw_line_3d(v3([X_TOWER + sx*lo, sy*lo, Z_ROOF]),
                            v3([X_TOWER + sx*lo*0.35, sy*lo*0.35,
                                self.z_fold - 0.05]), (150, 140, 120, 255))
        ring([X_TOWER, 0, Z_ROOF], self.r_m5 + (Z_ROOF - self.z_m5)
             / (self.z_fold - self.z_m5) * (self.r_fold - self.r_m5) + 0.05,
             (170, 145, 110, 255), 24)
        # fenced no-build ring the dish sweeps over
        ring([X_TOWER, 0, H_POT + 0.02], self.g_orbit + self.cfg.a,
             (150, 130, 190, 255), 72)
        if H is not None:
            u = H["u"]
            # the FIXED fold at its true two-axis tilt
            nf = u + np.array([0., 0., 1.]); nf /= np.linalg.norm(nf)
            e1 = np.cross(nf, [0, 0, 1.]); e1 /= max(np.linalg.norm(e1),
                                                     1e-9)
            e2 = np.cross(nf, e1)
            Pf = np.array([X_TOWER, 0., self.z_fold])
            t = np.linspace(0, 2*np.pi, 37)
            fr = [Pf + self.r_fold*(np.cos(x)*e1 + np.sin(x)*e2)
                  for x in t]
            for k in range(36):
                pr.draw_line_3d(v3(fr[k]), v3(fr[k+1]),
                                (235, 110, 110, 255))
            # waist marker: the fixed point the whole design pivots on
            ring([X_TOWER, 0, self.z_waist], 0.12, (235, 200, 90, 255), 14)
            # dish surface quills from its own traced points
            dish = H["dish"]
            for k in range(0, len(dish), 6):
                pr.draw_line_3d(v3(dish[k]), v3(dish[k] + 0.12*u),
                                (90, 150, 235, 255))
            # every traced ray, additive; spill in red
            pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
            a_hi = int(4 + 20*dim)
            cb, cd = (120, 88, 30, a_hi), (150, 40, 30, 55)
            ok, th = H["ok"], H["through"]
            fold, m5, duct = H["fold"], H["m5"], H["duct"]
            for i in range(0, len(dish), 2):
                pr.draw_line_3d(v3(dish[i] + 2.6*u), v3(dish[i]),
                                (60, 52, 30, max(a_hi//2, 2)))
                if not ok[i]:
                    continue
                col = cb if th[i] else cd
                pr.draw_line_3d(v3(dish[i]), v3(fold[i]), col)
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
        self._draw_bread_strip(pr, 1015, 26)
        self._draw_disturbances(pr, 1015, 120)
        el_txt = f"{H['el']:.0f}" if H else "--"
        hud = [f"sun el {el_txt}   track {self.el_min_h:.0f}-"
               f"{self.el_max_h:.0f} deg",
               f"dish f {self.f_nom:.1f} m orbits fixed fold at "
               f"g {self.g_orbit:.1f} m",
               f"fold r {self.r_fold:.2f} m  obstruction "
               f"{self.obstruction*100:.0f}%",
               f"waist z {self.z_waist:.1f} m  M5 ellipsoid r "
               f"{self.r_m5:.2f} m",
               f"through duct {100*H['through'].mean():.0f}%" if H
               else "gated",
               f"into pot {self.p_in[0]:5.0f} W"]
        for j, l in enumerate(hud):
            pr.draw_text(l, 1015, 300 + 26*j, 17, (225, 225, 205, 255))
        pr.draw_text("EXACT: dish -> FIXED 2-axis fold -> waist -> FIXED "
                     "ellipsoid M5 -> native air inlet -> pot.",
                     20, HT-72, 16, (150, 200, 160, 255))
        pr.draw_text("Nothing below the fold ever moves. Sealed below the "
                     "roof deck; open air above it, inside the fence.",
                     20, HT-50, 16, (150, 200, 160, 255))
        pr.draw_text("left-drag orbit  right-drag pan  wheel zoom  R reset",
                     20, HT-26, 16, (140, 140, 155, 255))
        pr.end_drawing()
        return None

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

    def __init__(self, *args, a_mem=2.10, g_orbit=5.0, z_waist=1.5,
                 z_m5=-0.10, el_min=12.0, r_mast=0.25, n_rays=1100,
                 **kwargs):
        # n_rays trades Monte-Carlo noise per step against speed. The
        # power estimate's sigma ~ 1/sqrt(n); training averages it out
        # over thousands of steps, eval keeps full resolution.
        self.n_rays = int(n_rays)
        self.g_orbit = float(g_orbit)
        self.z_waist = float(z_waist)
        self.z_m5 = float(z_m5)
        self.el_min_h = float(el_min)
        self.r_mast = float(r_mast)
        super().__init__(*args, a_mem=a_mem, **kwargs)

    def _reset_state(self):
        super()._reset_state()
        B = self.num_agents
        el0, az0, _ = _sim.solar_position(self.lat, self.day,
                                          float(self.t_solar[0]))
        self.el_m = np.clip(el0 + self.rng.normal(0, 0.3, B),
                            self.el_min_h, self.el_max_h)
        self.az_m = np.degrees(az0) + self.rng.normal(0, 0.3, B)
        self._e_el = np.zeros(B)
        self._e_az = np.zeros(B)

    def _extra_obs(self):
        base = super()._extra_obs()
        # encoder readings of the pointing error, with sensor noise
        enc = np.stack([
            np.clip((self._e_el + self.rng.normal(0, 0.03,
                                                  self.num_agents)) / 0.5,
                    -3, 3),
            np.clip((self._e_az + self.rng.normal(0, 0.03,
                                                  self.num_agents)) / 0.5,
                    -3, 3)], axis=1)
        return np.concatenate([base, enc], axis=1)

    def step(self, actions):
        B = self.num_agents
        a = np.asarray(actions).reshape(B, self.N_HEADS)
        # -- the two motors, BEFORE the optics see the sun this step.
        # cmd 0..6 -> rate -1..+1 of full slew; backlash as rate noise.
        el0, az0, _ = _sim.solar_position(self.lat, self.day,
                                          float(self.t_solar[0]))
        az0 = np.degrees(az0)
        r_az = (np.clip(a[:, 3], 0, 6) - 3) / 3.0 * self.RATE_AZ
        r_el = (np.clip(a[:, 4], 0, 6) - 3) / 3.0 * self.RATE_EL
        self.az_m = self.az_m + r_az * self.dt \
            + self.rng.normal(0, 0.02, B)
        self.el_m = np.clip(self.el_m + r_el * self.dt
                            + self.rng.normal(0, 0.02, B),
                            self.el_min_h - 2.0, self.el_max_h + 1.0)
        # pointing error the optics will feel (az foreshortened)
        self._e_el = self.el_m - el0
        self._e_az = (self.az_m - az0) * np.cos(np.radians(el0))
        t_before = float(self.t_solar[0])
        out = super().step(a[:, :3])
        if float(self.t_solar[0]) < t_before - 1.0:
            # the episode wrapped to the next morning: the crew reparks
            # the carriage overnight (hours of slack at full slew)
            el1, az1, _ = _sim.solar_position(self.lat, self.day,
                                              float(self.t_solar[0]))
            self.el_m = np.clip(el1 + self.rng.normal(0, 0.3, B),
                                self.el_min_h, self.el_max_h)
            self.az_m = np.degrees(az1) + self.rng.normal(0, 0.3, B)
        return out

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
        self.z_fold = Z_ROOF + 0.35 + under
        # dish-crossing band: the dish plane crosses the post axis for
        # el > acos(a/g); the waist sits at its centre, tube around it
        el_x = np.degrees(np.arccos(np.clip(a / g, 0, 1)))
        z_x = [self.z_fold - g * np.sin(np.radians(e))
               for e in (el_x, self.el_max_h)]
        self.z_waist = 0.5 * (z_x[0] + z_x[1])
        self.z_tube = (min(z_x) - 0.20, max(z_x) + 0.20)
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
        lo, hi = cfg.T_pre / (4 * f_design), cfg.T_pre / (0.4 * f_design)
        for _ in range(22):
            mid = 0.5 * (lo + hi)
            m = _sim.solve_membrane(cfg, mid, n=400)
            if m["z0"] + m["f_fit"] > f_design:
                lo = mid
            else:
                hi = mid
        self.p0 = float(0.5 * (lo + hi))
        self.R_sphere = _sphere_R(_sim.solve_membrane(cfg, self.p0, n=400))
        cfg.dp = self.p0
        self.level_frac = np.array(self.LEVEL_FRAC)   # coude's wide dump
        mems = [_sim.solve_membrane(cfg, self.p0 * fr, n=400)
                for fr in self.level_frac]
        self._mem0 = mems[4]
        self.f_nom = float(mems[4]["z0"] + mems[4]["f_fit"])

        # -- apertures, from the beam itself
        self.r_fold = a * delta / self.f_nom * 1.08 + 0.06
        self.obstruction = (self.r_fold / a) ** 2
        # tube inner radius passes 3 sigma of the waist; post below it
        # tube radius from the measured tube-vs-slot trade (the two are
        # coupled: the slot must clear the tube). Swept at windy blur:
        #   r_in 0.20: slot  9% tube 24% -> through 33.5%
        #   r_in 0.32: slot 12% tube  4% -> through 45.1%   <- optimum
        #   r_in 0.50: slot 17% tube  0% -> through 43.9%
        # The static-only 3-sigma sizing (0.20) was starving the machine.
        self.r_tube_in = 0.32
        self.r_tube = self.r_tube_in + 0.04
        self.r_post = 0.15
        # the slot: radial cut from r0 to the rim, wide enough for the
        # tube; loss printed, enforced ray-exactly in the trace
        self.slot_r0 = 0.28
        self.slot_w2 = self.r_tube + 0.06
        self.slot_loss = 2 * self.slot_w2 * (a - self.slot_r0) \
            / (np.pi * a * a)
        self.r_m5 = (a / self.f_nom) * (self.z_waist - self.z_m5) + 0.10

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
        NR = self.n_rays
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
        print(f"  [hashemi] machine wholly on the roof: ring rail R 4.6, "
              f"dish sweep r={g+a:.1f} m inside the parapet; beam sealed "
              f"below the roof deck")

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
        # single focal post (fig 14: the bearing wraps its base), with
        # the thicker sealed tube section around the waist
        K = 18
        zs = torch.linspace(Z_ROOF, self.z_fold - 0.10, K, device=dev)
        in_tube = (zs > self.z_tube[0]) & (zs < self.z_tube[1])
        r_tw = torch.where(in_tube,
                           torch.full((K,), self.r_tube, device=dev),
                           torch.full((K,), self.r_post, device=dev))
        Tw = torch.stack([torch.full((K,), X_TOWER, device=dev),
                          torch.zeros(K, device=dev), zs], 1)
        # (a) incoming sun: ray p + t*u, t>0 toward the sun
        w = Tw[None, None] - p[..., None, :]               # (B,P,4K,3)
        tproj = (w * ut).sum(-1)
        perp = (w - tproj[..., None] * ut).norm(dim=-1)
        lit = ~((tproj > 0) & (perp < r_tw)).any(-1)
        # the fold disc itself still shadows the dish centre
        vf = Pf - p
        perpf = vf - (vf * ut).sum(-1, keepdim=True) * ut
        lit = lit & (perpf.norm(dim=-1) > self.r_fold)
        # THE SLOT (fig 12): a radial cut in the dish, always facing the
        # post. The membrane is axisymmetric, so rotating the mask with
        # azimuth is exactly the physical dish rotating on its carriage.
        el_r = np.radians(el)
        h_np = -(u - u[2] * np.array([0., 0., 1.]))
        h_np = h_np / max(np.linalg.norm(h_np), 1e-9)
        p_up = h_np * np.sin(el_r) + np.array([0., 0., 1.]) * np.cos(el_r)
        s_dir = torch.tensor(-p_up, dtype=torch.float32, device=dev)
        e_pp = torch.linalg.cross(ut, s_dir)
        Cd_t = Cd
        q = p - Cd_t
        in_slot = ((q * s_dir).sum(-1) > self.slot_r0) \
            & ((q * e_pp).sum(-1).abs() < self.slot_w2)
        lit = lit & ~in_slot
        # the fold: fixed point, two axes of tilt; output exactly -z
        zh = torch.tensor([0.0, 0.0, 1.0], device=dev)
        nf = ut + zh
        nf = nf / nf.norm()
        den = (d * nf).sum(-1)
        t1 = ((Pf - p) * nf).sum(-1) / torch.where(
            den.abs() > 1e-9, den, torch.full_like(den, 1e-9))
        h1 = p + t1[..., None] * d
        # the plate is trimmed to the beam's true footprint: an ELLIPSE,
        # semi-major r_fold/cos(i) along the in-plane beam direction. A
        # circle both clipped the tails at low sun (largest i) and
        # oversized the cross axis for nothing.
        inc_i = np.radians(45.0 - 0.5 * el)
        e_par = ut - (ut * nf).sum() * nf
        e_par = e_par / e_par.norm()
        e_prp = torch.linalg.cross(nf, e_par)
        rel1 = h1 - Pf
        c_par = (rel1 * e_par).sum(-1) * np.cos(inc_i)
        c_prp = (rel1 * e_prp).sum(-1)
        rad1 = torch.stack([c_par, c_prp], -1).norm(dim=-1)
        # (b) the dish->fold leg against the post and tube (the dish
        # never dips below the deck, so the core cannot graze it)
        wb = Tw[None, None] - p[..., None, :]
        tb = (wb * d[..., None, :]).sum(-1)
        perp_b = (wb - tb[..., None] * d[..., None, :]).norm(dim=-1)
        graze = ((tb > 0) & (tb < t1[..., None] - 0.10)
                 & (perp_b < r_tw)).any(-1)
        ok = lit & ~graze & (t1 > 0) & (rad1 < self.r_fold)
        d2 = reflect(torch.cat([d, torch.zeros_like(d[..., :1])], -1),
                     torch.cat([nf, torch.zeros(1, device=dev)]
                               ).expand_as(
                         torch.cat([d, torch.zeros_like(d[..., :1])], -1))
                     )[..., :3]
        # the descending beam must pass the sealed tube: clip blur tails
        # on its inner wall at both ends
        ok_pre_tube = ok.clone()
        # POINTING ERROR from the two motors: a mistrack of e tilts the
        # reflected beam 2e, decentering it 2 e f at the waist. Applied
        # as a per-agent transverse shift in the funnel frame (the
        # geometry itself is traced at the true sun; first-order model,
        # same approach as the bore channel every env uses).
        dvec = torch.tensor(
            np.stack([2.0 * self.f_nom * np.radians(self._e_el),
                      2.0 * self.f_nom * np.radians(self._e_az)], 1),
            dtype=torch.float32, device=dev)[:, None, :]
        # THE FUNNEL, shaped where the CPC logic actually wants it: the
        # slot pins the pipe to r_tube_in only over the dish-crossing
        # band, so the pipe is straight there (the measured optimum,
        # 0.32) and FLARES above the band into a mirrored collecting
        # lip - wide where nothing constrains it, reflecting tail rays
        # inward-and-down. One bounce traced at rho 0.95. (First cut
        # put the cone INSIDE the band and narrowed the throat to 0.19:
        # tighter than the pipe it replaced, and it cost 20 percent.)
        z1_t, z0_t = self.z_tube[1], self.z_tube[0]
        z_lip = z1_t + 0.60
        r_lip = 0.55
        m_c = (r_lip - self.r_tube_in) / (z_lip - z1_t)
        Xo = h1[..., 0] - X_TOWER + dvec[..., 0]
        Yo = h1[..., 1] + dvec[..., 1]
        dz2 = d2[..., 2]
        rz0 = self.r_tube_in + m_c * (h1[..., 2] - z1_t)
        qa_c = d2[..., 0] ** 2 + d2[..., 1] ** 2 - (m_c * dz2) ** 2
        qb_c = 2 * (Xo * d2[..., 0] + Yo * d2[..., 1] - m_c * rz0 * dz2)
        qc_c = Xo ** 2 + Yo ** 2 - rz0 ** 2
        disc_c = qb_c ** 2 - 4 * qa_c * qc_c
        sq_c = torch.sqrt(disc_c.clamp(min=0))
        tc = torch.where(qa_c.abs() > 1e-9, (-qb_c - sq_c) / (2 * qa_c),
                         -qc_c / qb_c.clamp(min=1e-9))
        tc2 = torch.where(qa_c.abs() > 1e-9, (-qb_c + sq_c) / (2 * qa_c),
                          tc)
        tc = torch.where(tc > 1e-4, tc, tc2)
        zc_h = h1[..., 2] + tc * dz2
        hits_wall = (disc_c > 0) & (tc > 1e-4) & (zc_h > z1_t) \
            & (zc_h < z_lip)
        hx = Xo + tc * d2[..., 0]
        hy = Yo + tc * d2[..., 1]
        rc = (self.r_tube_in + m_c * (zc_h - z1_t)).clamp(min=1e-6)
        n_c = torch.stack([hx, hy, -m_c * rc], -1)
        n_c = n_c / n_c.norm(dim=-1, keepdim=True)
        d2r = d2 - 2 * (d2 * n_c).sum(-1, keepdim=True) * n_c
        h1r = torch.stack([hx + X_TOWER - dvec[..., 0],
                           hy - dvec[..., 1], zc_h], -1)
        d2 = torch.where(hits_wall[..., None], d2r, d2)
        h1 = torch.where(hits_wall[..., None], h1r, h1)
        w_ray = torch.where(hits_wall, torch.full_like(tc, 0.95),
                            torch.ones_like(tc))
        # the straight section's two gates, pointing decenter included
        for z_st in (z1_t, z0_t):
            t_st = (z_st - h1[..., 2]) / d2[..., 2].clamp(max=-1e-9)
            at_st = h1 + t_st[..., None] * d2
            rad_st = torch.stack([at_st[..., 0] - X_TOWER + dvec[..., 0],
                                  at_st[..., 1] + dvec[..., 1]], -1
                                 ).norm(dim=-1)
            ok = ok & (rad_st < self.r_tube_in)
        ok_post_tube = ok.clone()
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
        # THE MIRROR IS A PATCH, NOT THE WHOLE ELLIPSOID. The far root
        # can land on the surface's side lobes (measured: x 0.15-2.11,
        # z to +1.07); rays reflecting there went wherever, some drawn
        # straight through the foundations. Bound the patch to a disc
        # around its vertex V0 at the core base.
        V0t = torch.tensor([X_TOWER, 0.0, self.z_m5], dtype=torch.float32,
                           device=dev)
        ok = ok & oke & (t2 > 0) \
            & ((h2 - V0t).norm(dim=-1) < 1.25 * self.r_m5)
        hl = (h2 - self.ell_ctr_t) @ self.ell_M.T
        nl = hl * self.ell_S
        nl = nl / nl.norm(dim=-1, keepdim=True)
        ne = nl @ self.ell_M
        d3 = reflect(torch.cat([d2, torch.zeros_like(d2[..., :1])], -1),
                     torch.cat([ne, torch.zeros_like(ne[..., :1])], -1)
                     )[..., :3]
        # the duct plane x = R_POT, with boresight decenter. A ray must
        # make real progress toward the pot: near-grazing directions
        # (d3x ~ 0) produced kilometre-long bogus segments - they hit
        # the chamber masonry within a metre in reality.
        t3 = (R_POT - h2[..., 0]) / d3[..., 0].clamp(max=-1e-9)
        ok = ok & (d3[..., 0] < -0.05) & (t3 < 4.0)
        t3 = t3.clamp(max=4.0)
        h3 = h2 + t3[..., None] * d3
        off = torch.as_tensor(offset_w, dtype=torch.float32, device=dev)
        dy = h3[..., 1] + off[:, 0:1]
        dz = h3[..., 2] - Z_DUCT + off[:, 1:2]
        through_b = ok & (t3 > 0) & (dy ** 2 + dz ** 2 <= R_DUCT_H ** 2)
        through = through_b.float() * w_ray
        if self.render_mode == "human":
            n_all = float(lit.shape[-1])
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
        if self.render_mode == "human":
            self._hv = dict(dish=p[0].cpu().numpy(),
                            fold=h1[0].cpu().numpy(),
                            m5=h2[0].cpu().numpy(),
                            duct=h3[0].cpu().numpy(),
                            ok=ok[0].cpu().numpy(),
                            ok_pre=ok_pre_tube[0].cpu().numpy(),
                            slot=in_slot[0].cpu().numpy(),
                            through=through_b[0].cpu().numpy(),
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
        # SINGLE focal post (fig 14: the azimuth bearing wraps its
        # base) with the sealed tube section around the waist
        pr.draw_line_3d(v3([X_TOWER, 0, Z_ROOF]),
                        v3([X_TOWER, 0, self.z_fold]), (160, 148, 126, 255))
        for zz in np.linspace(Z_ROOF, self.z_fold, 9):
            ring([X_TOWER, 0, zz], self.r_post, (150, 140, 120, 255), 10)
        for zz in np.linspace(self.z_tube[0], self.z_tube[1], 5):
            ring([X_TOWER, 0, zz], self.r_tube, (205, 175, 120, 255), 14)
        # the buried masonry core: deck penetration widening to M5
        for zz in np.linspace(self.z_m5, Z_ROOF, 7):
            rr_ = (self.cfg.a / self.f_nom) * (self.z_waist - zz) + 0.10
            ring([X_TOWER, 0, zz], rr_, (140, 120, 96, 255), 20)
        # fenced no-build ring the dish sweeps over
        ring([X_TOWER, 0, H_POT + 0.02], self.g_orbit + self.cfg.a,
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
            R_rail, R_ring = g + 0.35, 4.6
            zh_ = np.array([0., 0., 1.])
            hdir = -(u - u[2]*zh_)
            hdir = hdir / max(np.linalg.norm(hdir), 1e-9)
            e_s = np.cross(zh_, hdir)
            Pf_ = np.array([X_TOWER, 0., self.z_fold])
            z_beam = Z_ROOF + 0.10
            colc = (150, 140, 120, 255)
            arc = lambda e_: Pf_ + R_rail*(np.cos(e_)*hdir
                                           - np.sin(e_)*zh_)
            # fixed ring rail on posts (roof stubs south, courtyard north)
            ring([X_TOWER, 0, z_beam - 0.05], R_ring, (120, 104, 88, 255),
                 48)
            for aa in np.linspace(0, 2*np.pi, 12, endpoint=False):
                fx = X_TOWER + R_ring*np.cos(aa); fy = R_ring*np.sin(aa)
                pr.draw_line_3d(v3([fx, fy, z_beam-0.05]),
                                v3([fx, fy, Z_ROOF]), (104, 92, 76, 255))
            # rotating beam through the collar on the mast, wheels at rim
            for sgn in (1.0, -1.0):
                pr.draw_line_3d(v3(Pf_*[1,1,0] + [0,0,z_beam]),
                                v3(Pf_*[1,1,0] + [0,0,z_beam]
                                   + sgn*R_ring*hdir), colc)
                wp = Pf_*[1,1,0] + [0,0,z_beam] + sgn*R_ring*hdir
                ring(wp - [0,0,0.06], 0.10, (200,180,140,255), 10)
            ring([X_TOWER, 0, z_beam], 0.22, colc, 12)     # the collar
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
            el_r = np.radians(H["el"])
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

            # the FIXED fold: the true ELLIPTICAL plate (semi-major
            # r_fold/cos i along the beam) on a visible two-axis yoke.
            # It stays FLAT because only a flat images perfectly under a
            # deviation that sweeps 90+el; a rigidly tracked powered
            # conic measured 1.3-3.5 m rms off-design.
            nf = u + np.array([0., 0., 1.]); nf /= np.linalg.norm(nf)
            Pf = np.array([X_TOWER, 0., self.z_fold])
            inc_ = np.radians(45.0 - 0.5*H["el"])
            e_pa = u - (u @ nf)*nf
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
            el_r0 = np.radians(H["el"])
            p_upw = hdir*np.sin(el_r0) + zh_*np.cos(el_r0)
            s_dirw = -p_upw
            e_ppw = np.cross(u, s_dirw)
            Cd_ = np.asarray(H["C"])
            Ml = _align_np([0., 0., 1.], u)
            r32 = self._mem0["r"].numpy()
            s32 = self._mem0["s"].numpy()
            def _slotted(qw):
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
            for sgn_ in (1.0, -1.0):
                q0 = Cd_ + self.slot_r0*s_dirw + sgn_*self.slot_w2*e_ppw
                q1 = Cd_ + a*s_dirw + sgn_*self.slot_w2*e_ppw
                pr.draw_line_3d(v3(q0), v3(q1), (235, 190, 90, 255))
            # every traced ray, additive; spill in red
            pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
            a_hi = int(4 + 20*dim)
            cb, cd = (120, 88, 30, a_hi), (150, 40, 30, 55)
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
                    # died on the tube or the M5 bound: red to the fold,
                    # then a red stub down the descent to the tube zone
                    pr.draw_line_3d(v3(dish[i]), v3(fold[i]), cd)
                    dz_ = fold[i] - np.array([0, 0,
                                              fold[i][2] - self.z_tube[1]])
                    pr.draw_line_3d(v3(fold[i]), v3(dz_), cd)
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
               (lambda L: f"losses: shadow {L['shadow']*100:.0f}% "
                f"slot {L['slot']*100:.0f}% tube {L['tube']*100:.0f}% "
                f"duct {L['duct']*100:.0f}%")(self._ladder)
               if hasattr(self, "_ladder") else "",
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

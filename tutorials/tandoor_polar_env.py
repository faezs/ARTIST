"""
TandoorPolarEnv: the RETROFIT architecture - an existing tandoor, a single
polar-mounted jammable pouch mirror, fired through the pot's own air-inlet
hole. Subclasses the field-real beam-down env so thermal/bread/reward
physics are identical and the comparison isolates architecture.

CONSTRAINTS THIS RESPECTS (the ones the earlier designs violated):
  - EXISTING tandoor: clay pot sunk under a workfloor, mouth flush with
    the floor where the cook stands. No new cavity, no side port cut, no
    berm, no crater. Heat enters through the pot's NATIVE air-inlet hole
    at the base - the draft hole the charcoal fire already breathes
    through - landing on the pot floor exactly where the coal bed sits.
  - NO flat heliostat. One mirror only. With a fixed ground target, a
    single-mirror fixed focus forces a polar axis through the target and
    therefore an OFF-AXIS section (Scheffler lineage), realized here as
    an elliptical-rim pump membrane.
  - The courtyard wall is the windbreak (it already exists).

THE JAMMABLE POUCH (stiffness as a control input):
  A sealed pouch - metallized film front, bladder back, granular fill,
  two ports. Circuit 1 (forming dp) sets f = T/dp while SOFT. Circuit 2
  (bed vacuum) JAMS the fill, freezing the figure into a shallow shell.
  While jammed the shape is set by the bed, not by pressure, so a gust
  perturbs focus ~50x less (df/f 24% -> 0.5% at 100 Pa) and needs ZERO
  control authority. Cost: the mirror can only be re-formed while soft,
  and while soft it is wind-exposed and not cooking.

  Third action head = jam/release. The agent must spend re-forming
  windows to correct seasonal declination drift and pressure loss,
  choosing calm moments - a genuine scheduling problem that the
  continuously-pumped designs never posed.

VALIDATED (membrane_fvk2d.py, generic 2-D FvK energy minimisation on
arbitrary domains, checked against the 1-D axisymmetric solver to 1% in
focal length): a pressurised ELLIPTICAL rim really does give a
two-curvature paraboloid, with fy/fx tracking the linear-theory value
1/ratio^2 to within 2-4% even deep in the Hencky regime, and adding only
~1.5-2.5 mrad of residual figure error over a circular rim. So the rim
aspect ratio is a BUILD-TIME design parameter that sets the astigmatism
of the off-axis section, and the pump trims focus on top of it -
sigma_offaxis below is now that measured increment, not a guess.
Grain print-through remains an assumed slope term.

OPERATIONAL CONSTRAINT the 2-D solve exposed: a 20 mm jammed bed weighs
~6 kg/m2 = 59 Pa, a THIRD of the ~170 Pa forming pressure, so the
gravity component normal to the membrane shifts the formed focus by up
to 13%. FORM AT THE OPERATING TILT (or the figure bakes in that error).
"""

import numpy as np
import torch

from tandoor_rl_env import (TandoorEnv, _sim, SIGMA, T_AMB,
                            T_COOK_LO, T_COOK_HI)

R_POT = 0.42          # coal-bed FLOOR radius [m]
H_POT = 1.00          # legacy mouth anchor for the world frame [m]
R_MOUTH = 0.26        # mouth radius (cook's opening) [m]
R_DUCT = 0.14         # native air-inlet hole radius [m]
Z_DUCT = -0.86        # duct centre, mouth frame - the machine's
                      # built inlet height, unchanged by the pit
# THE REAL PIT (as built): a SPHERICAL SECTION ~8 ft to the floor,
# far wider than the cook - the single sphere through the mouth
# (R_MOUTH at z 0, mouth frame) and the coal-bed floor (R_POT at
# z -H_DEPTH). Belly ~2.54 m across at 1.24 m below the mouth.
H_DEPTH = 2.44
Z_CPOT = (R_MOUTH**2 - R_POT**2 - H_DEPTH**2) / (2.0 * H_DEPTH)
R_SPH = float(np.hypot(R_MOUTH, Z_CPOT))
Z_CROWN = -0.22       # near-mouth band (strike + thermal share it)
Z_HEARTH = -H_DEPTH + 0.12
# BAKING ROW: the reachable upper wall (arm's depth from the mouth).
# Belt nodes 0..7 ARE this row - checkpoints keep their indices; the
# lower belly becomes 4 quadrant nodes appended after crown.
Z_BAKE_LO = -0.85
N_LOWER = 4
SPOT_NODE = 6          # the concave elbow's default target bin
SPOT_AREA = 0.30       # imaged spot area on the wall [m2]
SPOT_PHI0 = -np.pi + (SPOT_NODE + 0.5) / 8.0 * 2.0 * np.pi
SPOT_Z0 = 0.5 * (Z_BAKE_LO + Z_CROWN)
SPOT_PHI_RANGE = (SPOT_PHI0 - np.radians(110.0),
                  SPOT_PHI0 + np.radians(110.0))
SPOT_Z_RANGE = (-2.05, -0.30)
RATE_SPOT_PHI = 0.5    # deg/s of spot slew: 7.5 deg/step, sixth-bin
                       # resolution (4.0 teleported 60 deg/step -
                       # more than a whole bin; aiming was bang-bang)
RATE_SPOT_Z = 0.005    # m/s: 75 mm/step (was 600)
R_DUCT_WALL = float(np.sqrt(R_SPH**2 - (Z_DUCT - Z_CPOT)**2))
THROW = 3.5           # mirror -> duct mouth [m]


def _rot_a_to_b(a, b):
    """Rotation matrix taking unit vector a onto unit vector b."""
    v = np.cross(a, b); c = float(np.dot(a, b))
    K = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]],
                  [-v[1], v[0], 0]])
    return np.eye(3) + K + K @ K / max(1.0 + c, 1e-9)


class TandoorPolarEnv(TandoorEnv):
    # puffer's eval loop calls render() BEFORE the first step(),
    # and step() is where _cos_now is assigned. Class default so
    # the HUD has something to draw on frame 0.
    _cos_now = 0.0
    _last_org = None
    N_HEADS = 3        # pressure level, shutter, JAM/RELEASE
    N_EXTRA_OBS = 2    # jam state, seasonal figure drift
    # narrow focus trim: the retrofit is power-limited, so it never needs
    # to dump. Subclasses with surplus power MUST widen this or they
    # overshoot the band and cook less despite delivering more.
    LEVEL_FRAC = [0.86, 0.93, 0.97, 0.99, 1.00, 1.01, 1.06]

    def _extra_obs(self):
        return np.stack([
            self.jammed.astype(np.float64),
            np.clip(np.abs(self._decl() - self.decl_formed) / 10.0,
                    0, 3),
        ], axis=1)

    def __init__(self, *args, wall_shelter=0.4, sigma_offaxis=1.8e-3,
                 sigma_print=0.8e-3, jam_gain=0.02, lid_leak=0.18,
                 **kwargs):
        self.lid_leak = float(lid_leak)   # lidded mouth loss factor
        self.wall_shelter = float(wall_shelter)   # courtyard wall: v -> 0.4v
        # measured by the 2-D FvK solve (fvk2d_answers.py), not guessed
        self.sigma_offaxis = float(sigma_offaxis)
        self.sigma_print = float(sigma_print)      # grain print-through
        self.jam_gain = float(jam_gain)            # wind->focus gain jammed
        # nozzle elbow rotation (about the duct-frame x axis): from
        # the as-built jet axis to the line duct-mouth -> bed centre
        self.duct_nozzle = int(kwargs.pop("duct_nozzle", 0))
        self.spot_bread = int(kwargs.pop("spot_bread", 0))
        # elbow_aim: the concave elbow gets a 2-DOF mount and its aim
        # becomes TWO POLICY ACTION HEADS (spot azimuth around the
        # wall, spot height up the wall). With it off the mirror is
        # bolted at node 6's centre - identical to the fixed station.
        self.elbow_aim = int(kwargs.pop("elbow_aim", 0))
        # load_ctrl: the POLICY plays the cook too - one gate head
        # per bin (shutter threshold semantics) says where the lean's
        # dough goes; obs gains has_bread so occupancy is visible
        self.load_ctrl = int(kwargs.pop("load_ctrl", 0))
        # reward_div: normalize the TRAINER-facing reward channel
        # (Suarez: divide by the known max - 900 naans is the
        # solstice ceiling). Internal bookkeeping (ep_return, infos,
        # refunds) stays in raw naan units so dashboards remain
        # comparable. At 900 every realistic step reward sits deep
        # inside the trainer's +-1 clamp, so a lean pulling N naans
        # finally earns N times one naan instead of being censored
        # to +1, and day-returns land O(1) where vf_clip 0.2 is sane.
        self.reward_div = float(kwargs.pop("reward_div", 1.0))
        # hourly_metric: rotis_per_hour emission. OFF by default -
        # the hour-boundary .mean() sync drains the whole async
        # queue (measured: 315K -> 112.5K SPS on MPS). The Modal
        # sweep turns it on for scoring density; local runs read
        # day-over stats.
        self.hourly_metric = int(kwargs.pop("hourly_metric", 0))
        # sticky_k: the engagement heads (plenum level, shutter, jam)
        # latch - their actions only take effect on ticks where
        # tick % sticky_k == 0; in between the latched values reapply.
        # Cooking needs multi-minute holds, and per-step sampling
        # noise on these heads made cook events vanish from on-policy
        # data (measured: 1-2 cooks per 32768 sampled agent-steps even
        # from a policy that cooks 59/2h greedy). Motors stay
        # per-step; a held setting persists across a guillotine cut
        # (cuts never reset engagement) and resets at day-over.
        self.sticky_k = int(kwargs.pop("sticky_k", 0))
        self.n_extra_nodes = N_LOWER
        ax_now = np.arctan2(0.278, 0.961)
        ax_tgt = np.arctan2(-H_DEPTH - Z_DUCT, R_DUCT_WALL)
        dpitch = ax_tgt - ax_now
        self._nozzle_cs = (float(np.cos(dpitch)), float(np.sin(dpitch)))
        # nozzle mode 2: CONCAVE elbow 0.35 m inside the pot, imaging
        # the duct waist onto the baking row's far-wall node - the
        # 3x concentration that closes the 180-200 K gap
        a0 = np.array([0.0, 0.961, 0.278]); a0 /= np.linalg.norm(a0)
        O = np.array([0.0, -R_DUCT_WALL, Z_DUCT])
        M = O + 0.35 * a0
        zb = 0.5 * (Z_BAKE_LO + Z_CROWN)
        rb = float(np.sqrt(R_SPH**2 - (zb - Z_CPOT)**2))
        # aim at the CENTRE of far-wall node 6, not the 5/6 seam at
        # phi = pi/2 - a seam-split spot halves the concentration
        ph6 = -np.pi + (6.5 / 8.0) * 2.0 * np.pi
        Tgt = np.array([rb * np.cos(ph6), rb * np.sin(ph6), zb])
        a1 = Tgt - M; L1 = float(np.linalg.norm(a1)); a1 /= L1
        R_ = _rot_a_to_b(a0, a1)
        # python floats ONLY: numpy float64 scalars promote float32
        # tensors to float64, which MPS cannot run - the cpu path
        # masked it while the mps fallback sprayed the crown
        self._noz2 = dict(
            a0=tuple(float(v) for v in a0),
            M=tuple(float(v) for v in M),
            a1=tuple(float(v) for v in a1),
            f=float(1.0 / (1.0 / 0.35 + 1.0 / L1)),
            R=tuple(float(v) for v in R_.reshape(-1)))
        # the real pit's sphere, handed to _build_thermal and
        # struck by _bin_pot - one geometry, two consumers
        self._pot_sphere = (R_SPH, Z_CPOT, H_DEPTH,
                            Z_CROWN, Z_HEARTH, Z_BAKE_LO)
        super().__init__(*args, **kwargs)

    # ------------------------------------------------------------ optics #
    def _build_optics(self):
        cfg = _sim.CFG
        cfg.a = 1.60                     # equivalent circular radius (~8 m2)
        cfg.r_pit = R_DUCT
        self.cfg = cfg
        self.throw = THROW
        # jammed pouch: the bed holds the figure, so tension only has to
        # keep the film smooth - 12 MPa, 13% of yield (creep win kept),
        # but high enough to stay out of the deep-Hencky regime
        cfg.T_pre = 600.0
        # solve dp so the FITTED focus (not the linear T/dp) lands on the
        # duct: stress-stiffening otherwise doubles the throw
        lo, hi = cfg.T_pre / (4 * THROW), cfg.T_pre / (0.4 * THROW)
        for _ in range(18):
            mid = 0.5 * (lo + hi)
            m = _sim.solve_membrane(cfg, mid, n=400)
            f_fit = m["z0"] + m["f_fit"]
            if f_fit > THROW:
                lo = mid
            else:
                hi = mid
        self.p0 = float(0.5 * (lo + hi))
        cfg.dp = self.p0
        dev = self.device

        self.level_frac = np.array(self.LEVEL_FRAC)
        mems = [_sim.solve_membrane(cfg, self.p0 * f, n=500)
                for f in self.level_frac]
        self._mem0 = mems[4]

        n = 40
        xy = torch.linspace(-cfg.a, cfg.a, n)
        X, Y = torch.meshgrid(xy, xy, indexing="ij")
        rr = torch.sqrt(X**2 + Y**2).reshape(-1)
        keep = (rr > 0.05) & (rr < cfg.a * 0.985)
        self.px = X.reshape(-1)[keep].float().to(dev)
        self.py = Y.reshape(-1)[keep].float().to(dev)
        self.pr = rr[keep].float().to(dev)
        r32 = self._mem0["r"].float().to(dev)
        self.sp_levels = torch.stack([
            _sim.interp1d(self.pr, r32, m["sp"].float().to(dev))
            for m in mems])
        self.z_levels = torch.stack([
            _sim.interp1d(self.pr, r32, m["s"].float().to(dev))
            for m in mems])
        self.pz_sag = self.z_levels[4]
        self.f_nom = float(self._mem0["z0"] + self._mem0["f_fit"])
        # ARTIST: NURBS membrane + Sun cone + reflect, replacing the
        # sag-table interpolation and randn cone this env used to do by
        # hand. sp_levels/z_levels stay for the renderer and diagnostics.
        import tandoor_artist_optics as AO
        self.AO = AO
        self.primary = AO.MembranePrimary(
            _sim, cfg, mems, self.px, self.py, dev, tag=f"polar{cfg.a:.2f}",
            csr_frac=self.csr_frac, csr_sigma=15e-3)
        self.pl_duct = AO.make_plane("duct", [0.0, 0.0, self.f_nom],
                                     [0.0, 0.0, 1.0], 4.0, 4.0, dev)

        # ONE reflection: soiled outdoor film only, then the duct lip
        cell = float(xy[1] - xy[0]) ** 2
        self._loss_chain = 0.88 * 0.96
        self._ray_pw = torch.full_like(self.pr, cell * self._loss_chain)

        self.sigma_sun = 2.09e-3
        # static budget: film + off-axis mismatch + grain print-through
        self.sig_static = np.sqrt((2 * 2.0e-3) ** 2
                                  + (2 * self.sigma_offaxis) ** 2
                                  + (2 * self.sigma_print) ** 2)

        # cavity: existing pot, cylinder r=R_POT from z=-H_POT to 0
        self.ct_cut = 1.0
        self.zc_oven = -H_POT
        self._zc_w = -H_POT
        B, P = self.num_agents, self.pr.shape[0]
        self._env_off = (torch.arange(B, device=dev) * self.n_nodes
                         ).repeat_interleave(P)
        self._ones_bp1 = torch.zeros(B, P, 1, device=dev)
        self._inv_r = (1.0 / self.pr).expand(B, P)
        self._sun_R = torch.eye(3, device=dev)
        self.a_charge = 0.0   # no charge window: nothing is being rebuilt
        print(f"  [polar optics] one mirror {np.pi * cfg.a**2:.1f} m2, "
              f"f={self.f_nom:.2f} m, T={cfg.T_pre:.0f} N/m "
              f"({cfg.T_pre / 50e-6 / 1e6:.0f} MPa film), duct r={R_DUCT} m")

    def _cosine(self, decl_deg):
        """Polar mount: hour angle costs nothing (the mirror clocks with
        the sun); only declination does, times the off-axis section
        factor. ~0.70 equinox, ~0.64 solstice."""
        return 0.70 * float(np.cos(np.radians(decl_deg)))

    # ------------------------------------------------------------- trace #
    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        B, P = p_eff.shape[0], self.pr.shape[0]
        lv = (p_eff / self.p0 - self.level_frac[0]) / (
            self.level_frac[-1] - self.level_frac[0]) * (self.N_LEVELS - 1)
        lv = torch.as_tensor(lv, dtype=torch.float32,
                             device=self.device).clamp(0, self.N_LEVELS - 1)
        # ARTIST: NURBS surface points+normals, Sun cone, reflect, and
        # TowerTargetAreas/line_plane_intersections for the duct plane.
        org, d4, _inc = self.primary.bounce(lv, sigma_b, self.tick)
        d1 = d4[..., :3]
        hit = self.AO.hit_plane(org.reshape(-1, 4), d4.reshape(-1, 4),
                                self.pl_duct, self.device).reshape(B, P, 4)
        off = torch.as_tensor(offset_w, dtype=torch.float32,
                              device=self.device)
        pxp = hit[..., 0] + off[:, 0:1]
        pyp = hit[..., 1] + off[:, 1:2]
        through = (pxp**2 + pyp**2) <= R_DUCT**2

        # through the duct: beam runs +y (into the pot) angled down onto
        # the pot floor where the coal bed lives
        if self.render_mode == "human":
            self._last_org = org[0, :, :3].cpu().numpy()
        return self._bin_pot(pxp, pyp, d1[..., 0], -d1[..., 2],
                             d1[..., 1] - 0.16, through, soil, B, P)


    def _bin_pot(self, pxp, pyp, dxw, dyw, dzw, through, soil,
                 B, P):
        """Duct-plane arrival -> pot floor / belt / crown node
        powers. Shared so the polar and Hashemi retrofits, which
        enter through the SAME native air-inlet, cannot drift
        apart downstream of the optics."""
        # jet origin on the sphere wall at the duct mouth
        ox = pxp
        oy = torch.full_like(pxp, -R_DUCT_WALL)
        oz = pyp + Z_DUCT
        noz = getattr(self, "duct_nozzle", 0)
        if noz == 1:
            # polished flat elbow: aims the jet at the coal bed. One
            # extra reflection: x0.95.
            cn, sn = self._nozzle_cs
            dy2 = cn * dyw - sn * dzw
            dzw = sn * dyw + cn * dzw
            dyw = dy2
            through = through * 0.95
        elif noz == 2:
            # CONCAVE elbow on its 2-DOF mount: images the duct waist
            # onto the wall point (spot_phi, spot_z) - per env, per
            # step. Thin-mirror model: propagate to the mirror plane,
            # Rodrigues-rotate the bundle onto the aim axis, focusing
            # kick q/f, x0.95. Aim state comes through _spot_view so
            # the numpy and gpu paths each feed their own live copy.
            nz = self._noz2
            a0 = nz["a0"]; M = nz["M"]; f = nz["f"]
            sp, szv = self._spot_view
            dt_ = dxw.dtype; dv_ = dxw.device
            ph = torch.as_tensor(sp, dtype=dt_, device=dv_)[:, None]
            zt = torch.as_tensor(szv, dtype=dt_, device=dv_)[:, None]
            rt = torch.sqrt(
                (R_SPH**2 - (zt - Z_CPOT)**2).clamp(min=1e-4)) * 0.999
            a1x = rt * torch.cos(ph) - M[0]
            a1y = rt * torch.sin(ph) - M[1]
            a1z = zt - M[2]
            nA = torch.sqrt(a1x*a1x + a1y*a1y + a1z*a1z)
            a1x, a1y, a1z = a1x / nA, a1y / nA, a1z / nA
            da = (dxw * a0[0] + dyw * a0[1]
                  + dzw * a0[2]).clamp(min=1e-6)
            tm = ((M[0] - ox) * a0[0] + (M[1] - oy) * a0[1]
                  + (M[2] - oz) * a0[2]) / da
            px = ox + tm * dxw - M[0]
            py = oy + tm * dyw - M[1]
            pz = oz + tm * dzw - M[2]
            vx = a0[1]*a1z - a0[2]*a1y
            vy = a0[2]*a1x - a0[0]*a1z
            vz = a0[0]*a1y - a0[1]*a1x
            cc = a0[0]*a1x + a0[1]*a1y + a0[2]*a1z
            k1 = 1.0 / (1.0 + cc).clamp(min=1e-6)

            def _rot(x, y, z):
                cx = vy*z - vz*y
                cy = vz*x - vx*z
                cz = vx*y - vy*x
                return (x + cx + k1*(vy*cz - vz*cy),
                        y + cy + k1*(vz*cx - vx*cz),
                        z + cz + k1*(vx*cy - vy*cx))
            dxw, dyw, dzw = _rot(dxw, dyw, dzw)
            px, py, pz = _rot(px, py, pz)
            qpar = px*a1x + py*a1y + pz*a1z
            dxw = dxw - (px - qpar*a1x) / f
            dyw = dyw - (py - qpar*a1y) / f
            dzw = dzw - (pz - qpar*a1z) / f
            nrm = torch.sqrt(dxw*dxw + dyw*dyw
                             + dzw*dzw).clamp(min=1e-9)
            dxw, dyw, dzw = dxw / nrm, dyw / nrm, dzw / nrm
            ox = M[0] + px
            oy = M[1] + py
            oz = M[2] + pz
            through = through * 0.95
        # strike the SPHERE (the real pit); where the far root dives
        # below the coal bed the ray lands on the floor disc instead
        # (the sphere meets z=-H_DEPTH exactly at r=R_POT, so the
        # crossing is always inside the disc)
        ozc = oz - Z_CPOT
        aq = dxw**2 + dyw**2 + dzw**2
        bq = ox * dxw + oy * dyw + ozc * dzw
        cq = ox**2 + oy**2 + ozc**2 - R_SPH**2
        t_wall = (-bq + torch.sqrt((bq**2 - aq * cq).clamp(min=0))) \
            / aq.clamp(min=1e-9)
        sz_s = oz + t_wall * dzw
        hit_floor = sz_s < -H_DEPTH
        t_floor = (-H_DEPTH - oz) / dzw.clamp(max=-1e-6)
        fx, fy = ox + t_floor * dxw, oy + t_floor * dyw
        wz = oz + t_wall * dzw
        sx = torch.where(hit_floor, fx, ox + t_wall * dxw)
        sy = torch.where(hit_floor, fy, oy + t_wall * dyw)
        sz = torch.where(hit_floor, torch.full_like(wz, -H_DEPTH), wz)
        phi = torch.atan2(sy, sx)
        seg = ((phi + np.pi) / (2 * np.pi) * self.n_belt).long().clamp(
            0, self.n_belt - 1)
        seg4 = ((phi + np.pi) / (2 * np.pi) * N_LOWER).long().clamp(
            0, N_LOWER - 1)
        node = torch.where(
            hit_floor | (sz < Z_HEARTH),
            torch.full_like(seg, self.n_belt),          # hearth = coal bed
            torch.where(sz > Z_CROWN,
                        torch.full_like(seg, self.n_belt + 2),  # near mouth
                        torch.where(sz > Z_BAKE_LO,
                                    seg,                # BAKING ROW
                                    self.n_belt + 3 + seg4)))  # lower belly
        soil_t = torch.as_tensor(soil, dtype=torch.float32,
                                 device=self.device)
        rs = getattr(self, "_ray_scale", 1.0)
        if torch.is_tensor(rs):
            rs = rs.to(pxp.device)[:, None]   # per-env cosine + gate
        w = ((self._ray_pw[None, :] * soil_t[:, None] * rs).reshape(-1)
             * through.reshape(-1).float())
        if self.render_mode == "human":
            # pot-frame strikes for the kitchen view: where the jet
            # (post-elbow) actually lands on the clay
            self._pot_strikes = dict(
                strike=torch.stack([sx[0], sy[0], sz[0]],
                                   -1).cpu().numpy(),
                node=node.reshape(pxp.shape)[0].cpu().numpy(),
                through=through[0].cpu().numpy())
        if self.render_mode == "human" and self._last_org is not None:
            # populated by the caller, which is where the ray
            # origins live; _bin_pot only knows the duct plane on.
            self._last_rays = dict(
                org=self._last_org,
                pduct=torch.stack([pxp[0], torch.zeros_like(pxp[0]),
                                   pyp[0]], -1).cpu().numpy(),
                strike=torch.stack([sx[0], sy[0], sz[0]],
                                   -1).cpu().numpy(),
                through=through[0].cpu().numpy())
        # THE LOAF PATCH (2026-09-06, the footprint comes from the trace):
        # the bin's loaf is a square of half-size sqrt(bread_area)/2 on
        # the wall at the bake row's mid-height; rays striking it are the
        # loaf's, accumulated in n_belt loaf columns after the nodes
        NB = self.n_belt; N = self.n_nodes
        zb = 0.5 * (Z_BAKE_LO + Z_CROWN)
        rb = float(np.sqrt(max(R_SPH**2 - (zb - Z_CPOT)**2, 1e-6)))
        hl = float(np.sqrt(self.bread_area) / 2.0)
        phk = -np.pi + (seg.float() + 0.5) * (2 * np.pi / NB)
        dph = phi - phk
        dph = dph - 2 * np.pi * torch.floor((dph + np.pi) / (2 * np.pi))
        onloaf = (node < NB) & (dph.abs() * rb < hl) & ((sz - zb).abs() < hl)
        off2 = (torch.arange(B, device=self.device) * (N + NB))[:, None] \
            .expand(B, node.reshape(B, -1).shape[1]).reshape(-1)
        out = torch.zeros(B * (N + NB), device=self.device)
        out.index_put_((off2 + node.reshape(-1),), w, accumulate=True)
        out.index_put_((off2 + N + seg.reshape(-1),),
                       w * onloaf.reshape(-1).float(), accumulate=True)
        return out.reshape(B, N + NB).cpu()

    # -------------------------------------------------------------- step #
    def _reset_state(self):
        super()._reset_state()
        B_ = self.num_agents
        self.spot_phi = np.full(B_, SPOT_PHI0)
        self.spot_z = np.full(B_, SPOT_Z0)
        self._spot_view = (self.spot_phi, self.spot_z)
        B = self.num_agents
        self.jammed = np.ones(B, dtype=bool)
        self.f_locked = np.full(B, self.p0)     # pressure frozen at jam
        self.decl_formed = np.full(B, self._decl())
        self.form_time = np.zeros(B)            # steps spent soft today
        # sticky-engagement latches, as raw action values: level 4 is
        # level_frac 1.00 (p_set = p0), 6 > thr on shutter and jam -
        # the reset state's own actions
        self._hold_p = np.full(B, 4, dtype=np.int64)
        self._hold_s = np.full(B, 6, dtype=np.int64)
        self._hold_j = np.full(B, 6, dtype=np.int64)

    def _decl(self):
        return float(np.degrees(np.radians(23.44) * np.sin(
            2 * np.pi * (284 + self.day) / 365)))

    def _night_cool_np(self, mask):
        """Numpy twin of TandoorHashemiEnv._night_cool_torch: yesterday's
        pot through night_hours with the lumped wall model, lid on, no
        sun, no bread; explicit Euler at dt_night."""
        idx = np.nonzero(mask)[0]
        if idx.size == 0:
            return
        hours = float(getattr(self, "night_hours", 16.0))
        dt = float(getattr(self, "dt_night", 60.0))
        n = int(round(hours * 3600.0 / dt))
        area = np.asarray(self.node_area, dtype=np.float64)
        asum = area.sum()
        mouth = float(np.pi * R_MOUTH ** 2 * self.lid_leak)
        T = self.T[idx].astype(np.float64)
        Ts = self.T_sub[idx].astype(np.float64)
        Td = self.T_deep[idx].astype(np.float64)
        Th = np.asarray(self.T_halo, dtype=np.float64)[idx]
        g01 = np.asarray(self.g01, dtype=np.float64)
        g12 = np.asarray(self.g12, dtype=np.float64)
        g2s = np.asarray(self.g2s, dtype=np.float64)
        cap = np.asarray(self.node_heat_cap, dtype=np.float64)
        cs = np.asarray(self.cap_sub, dtype=np.float64)
        cd = np.asarray(self.cap_deep, dtype=np.float64)
        ch = float(np.asarray(self.c_halo, dtype=np.float64).mean())
        gout = float(np.asarray(self.g_halo_out, dtype=np.float64).mean())
        k_ap = self.n_belt + 2
        for _ in range(n):
            t4 = T ** 4
            tcav4 = (area * t4).sum(1, keepdims=True) / asum
            q = 0.85 * SIGMA * area * (tcav4 - t4)
            q01 = g01 * (T - Ts)
            q12 = g12 * (Ts - Td)
            q2s = g2s * (Td - Th[:, None])
            q = q - q01
            q[:, k_ap] -= 0.75 * SIGMA * (tcav4[:, 0] - T_AMB ** 4) * mouth
            T = T + q * dt / cap
            Ts = Ts + (q01 - q12) * dt / cs
            Td = Td + (q12 - q2s) * dt / cd
            Th = Th + (q2s.sum(1) - gout * (Th - T_AMB)) * dt / ch
        self.T[idx] = T
        self.T_sub[idx] = Ts
        self.T_deep[idx] = Td
        self.T_halo[idx] = Th

    def step(self, actions):
        B = self.num_agents
        a = np.asarray(actions).reshape(B, 3)
        if self.sticky_k > 1:
            if self.tick % self.sticky_k == 0:
                self._hold_p[:] = a[:, 0]
                self._hold_s[:] = a[:, 1]
                self._hold_j[:] = a[:, 2]
            else:
                a = a.copy()      # never mutate the caller's buffer
                a[:, 0] = self._hold_p
                a[:, 1] = self._hold_s
                a[:, 2] = self._hold_j
        thr = 3.5 if self.wide_shutter else 0.5
        self.p_set = self.p0 * self.level_frac[
            np.clip(a[:, 0], 0, self.N_LEVELS - 1)]
        self.shutter = (a[:, 1] > thr).astype(np.float64)
        want_jam = a[:, 2] > thr

        # --- the jam/release mechanism -------------------------------- #
        releasing = self.jammed & ~want_jam
        jamming = (~self.jammed) & want_jam
        self.jammed = want_jam.copy()
        self.form_time += (~self.jammed).astype(float)
        # while SOFT the pump servos and the shape follows pressure;
        # while JAMMED the bed holds the figure and the pump is inert
        bias = 0.05 * (self.dni - 400.0) / 10.0
        self.p_dist += ((bias - self.p_dist) / 900.0 * self.dt
                        + self.rng.normal(0, 1.2, B))
        self.p_dist = np.clip(self.p_dist, -40, 60)
        soft = ~self.jammed
        self.p_act = np.where(
            soft, self.p_act + np.clip(self.p_set + self.p_dist - self.p_act,
                                       -6.0, 6.0), self.p_act)
        self.f_locked = np.where(jamming, self.p_act, self.f_locked)
        # re-forming while soft also re-matches the seasonal declination
        self.decl_formed = np.where(soft, self._decl(), self.decl_formed)

        # --- sun, cloud, wind (courtyard-sheltered) -------------------- #
        self.t_solar += self.dt / 3600.0
        el0, az0, svec = _sim.solar_position(self.lat, self.day,
                                             float(self.t_solar[0]))
        clear = _sim.clear_sky_dni(el0)
        tau_c = 900.0
        self.cloud += (-self.cloud / tau_c * self.dt
                       + self.rng.normal(
                           0, 0.25 * np.sqrt(2 * self.dt / tau_c), B))
        deep = self.rng.random(B) < 0.0015 * self.dt / 15.0
        self.cloud[deep] -= 1.5
        self.cloud = np.clip(self.cloud, -3, 0.25)
        base_w = 2.5 + 3.5 * np.sin(np.pi * np.clip(
            (self.t_solar - 8.0) / 8.0, 0, 1))
        self.wind_g += (-self.wind_g / 600.0 * self.dt
                        + self.rng.normal(
                            0, 1.8 * np.sqrt(2 * self.dt / 600.0), B))
        self.wind = np.clip((base_w + self.wind_g) * self.wall_shelter,
                            0, 25)
        # a jammed pouch is a shell: it can ride out far more wind before
        # stowing than a pressure-held membrane
        self.stowed = (self.stowed | (self.wind > 16.0)) & ~(self.wind < 14.0)
        cosf = self._cosine(self._decl()) if el0 > 8.0 else 0.0
        self._cos_now = cosf
        self.dni = clear * np.exp(self.cloud) * (el0 > 8.0) * ~self.stowed

        # --- wind -> figure, gated by the jam state -------------------- #
        q_w = 0.6 * self.wind**2
        gain = np.where(self.jammed, self.jam_gain, 1.0)
        p_eff = np.where(self.jammed, self.f_locked, self.p_act) \
            + gain * q_w * np.sign(self.rng.normal(0, 1, B))
        # 2-D-FvK-measured law (see fvk2d_cassegrain.py), not q*a/2T
        sig_wind = gain * 0.88e-3 * (np.maximum(q_w, 1e-9) / 15.0) ** 0.6
        # seasonal drift since the last re-forming shows up as astigmatism
        drift = np.abs(self._decl() - self.decl_formed)
        sig_drift = np.radians(drift) * 0.04
        sigma_b = np.sqrt(self.sig_static**2
                          + (2 * 0.35 * sig_wind) ** 2 + sig_drift**2)
        self.bore += (-self.bore / 300.0 * self.dt
                      + self.rng.normal(
                          0, 0.010 * np.sqrt(2 * self.dt / 300.0), (B, 2)))

        with torch.no_grad():
            per_dni = self._trace_power(p_eff, sigma_b, self.bore,
                                        self.soil).numpy()
        gate = self.dni * cosf * self.shutter * self.jammed
        per_loaf = per_dni[:, self.n_nodes:self.n_nodes + self.n_belt]
        per_dni = per_dni[:, :self.n_nodes]
        q_solar = per_dni * gate[:, None] * 0.85
        # DONENESS POTENTIAL, phi_old: total in-oven doneness at step
        # start, BEFORE any bread energy moves (direct beam below,
        # wall exchange, pulls, placements). phi = sum clip(E/E_r,0,1)
        # - empty bins are 0 (pulls zero bread_E with has_bread)
        phi_old = np.clip(self.bread_E / self.roti_energy,
                          0.0, 1.0).sum(1)
        if getattr(self, "spot_bread", 0):
            ph_, zt_ = self._spot_view
            ar = np.arange(len(ph_))
            kb = (((np.asarray(ph_) + np.pi) / (2 * np.pi)
                   * self.n_belt).astype(int)) % self.n_belt
            valid = ((np.asarray(zt_) >= Z_BAKE_LO)
                     & (np.asarray(zt_) <= Z_CROWN))
            # every loaded loaf takes the TRACED beam power on its own
            # patch (the loaf columns): the footprint is the trace's
            nb = self.n_belt
            valid = np.ones_like(valid, dtype=bool)
            lit_b = self.has_bread[:, :nb].astype(float)
            fr_b = np.clip(self.bread_E[:, :nb] / self.roti_energy, 0, 1)
            alpha_b = 0.55 + 0.35 * fr_b      # dough browns, absorbs
            inc_b = per_loaf * gate[:, None]
            q_b = lit_b * alpha_b * inc_b
            q_solar[:, :nb] -= lit_b * 0.85 * inc_b
            self.bread_E[:, :nb] += q_b * self.dt
            q_direct = q_b.sum(1)
            self._spot_bin = (kb, valid)
            self._spot_q = q_b
            self._spot_flux = q_direct / max(self.bread_area, 1e-6)
            self._spot_kb = kb
        self.p_in = per_dni.sum(1) * gate

        # --- thermal / bread / reward: identical to the parent --------- #
        T = self.T
        t4 = T**4
        t_cav4 = (self.node_area * t4).sum(1, keepdims=True) \
            / self.node_area.sum()
        q_exch = 0.85 * SIGMA * self.node_area * (t_cav4 - t4)
        # the pot's OWN mouth radiates ~1.4 kW at baking temperature -
        # a loss the purpose-built cavities never had. Real tandoors are
        # kept lidded between batches; the lid lifts only to load.
        lid = np.where(self.load_timer < 4.0, 1.0, self.lid_leak)
        q_ap = 0.75 * SIGMA * (t_cav4.squeeze(1) - T_AMB**4) \
            * (np.pi * R_MOUTH**2) * lid
        q01 = self.g01 * (T - self.T_sub)
        q12 = self.g12 * (self.T_sub - self.T_deep)
        q2s = self.g2s * (self.T_deep - self.T_halo[:, None])
        q = q_solar + q_exch - q01
        self.T_sub = self.T_sub + (q01 - q12) * self.dt / self.cap_sub
        self.T_deep = self.T_deep + (q12 - q2s) * self.dt / self.cap_deep
        self.T_halo = self.T_halo + (
            q2s.sum(1) - self.g_halo_out * (self.T_halo - T_AMB)
        ) * self.dt / self.c_halo
        q[:, self.n_belt + 2] -= q_ap
        belt_T = T[:, : self.n_belt]
        # dough exchanges at its own temperature: room-temp coldstart
        # warming to ~400 K at full bake (see the rl_env twin)
        t_dough = 300.0 + 100.0 * np.clip(
            np.maximum(self.bread_E, 0.0) / self.roti_energy, 0.0, 1.0)
        q_b = self.has_bread * self.h_bread * (belt_T - t_dough)
        # per-loaf absorbed power for the renderer: the flux integral
        # over each roti's surface = wall contact + direct beam [W]
        self._bread_pw = q_b.copy()
        if getattr(self, "_spot_kb", None) is not None:
            self._bread_pw[np.arange(len(self._spot_kb)),
                           self._spot_kb] += \
                self._spot_flux * self.bread_area
        q[:, : self.n_belt] -= q_b
        dT = q * self.dt / self.node_heat_cap
        self.T = T + dT
        self.bread_E += q_b * self.dt
        self.bread_t += self.has_bread * self.dt
        spall = dT[:, self.n_belt] > 25.0
        self.ep_spall += spall

        rew = np.zeros(B)
        belt_T = self.T[:, : self.n_belt]
        # char as a RATE + banking on the cook's lean (see the rl_env
        # twin). NOTE: the beam enters at the BASE and never crosses
        # the mouth, so neither loading nor pulling needs a shutter
        # interlock - the retrofit's structural safety win.
        c_dot = np.clip(belt_T - 800.0, 0, None) / 6000.0
        if getattr(self, "spot_bread", 0) and \
                getattr(self, "_spot_flux", None) is not None:
            kbc, validc = self._spot_bin
            fkw_b = self._spot_q / max(self.bread_area, 1e-6) / 1000.0
            c_dot = c_dot + np.clip(fkw_b - 8.0, 0, None) / 1000.0 \
                * validc[:, None]
        self.bread_C += self.has_bread * c_dot * self.dt
        ready = self.has_bread & (self.bread_E >= self.roti_energy)
        # ONE lean event: pull and load share the opening (see the
        # rl_env twin for why this is the post-increment timer)
        pull_open = self.load_timer + self.dt >= self.load_period
        cooked = ready & pull_open[:, None]
        scorched = self.has_bread & (self.bread_C >= 1.0)
        # NO doughy timeout: cooked or charred only (rl_env twin)
        rew += 5.0 * cooked.sum(1) - 5.0 * scorched.sum(1) \
            - 0.5 * spall
        self.ep_rotis += cooked.sum(1)
        self.day_rotis += cooked.sum(1)
        self.ep_scorch += scorched.sum(1)
        done_bread = cooked | scorched
        self.has_bread &= ~done_bread
        self.bread_E[done_bread] = 0.0
        self.bread_t[done_bread] = 0.0
        self.bread_C[done_bread] = 0.0
        self.load_timer += self.dt
        from tandoor_rl_env import cook_bin
        want = self.load_timer >= self.load_period
        ar_ = np.arange(self.num_agents)
        if self.load_ctrl:
            # the POLICY plays the cook (rl_env twin): last n_belt
            # heads gate each bin; empty bins only, up to
            # loaves_per_load per lean. The heads live on the OUTER
            # env's action row (this step sees a (B,3) slice), so
            # the subclass stashes them as _load_mask.
            mask = getattr(self, "_load_mask",
                           a[:, -self.n_belt:]) > thr
            left = np.full(self.num_agents, self.loaves_per_load)
            for k in range(self.n_belt):
                place = want & mask[:, k] & ~self.has_bread[:, k] \
                    & (left > 0)
                self.has_bread[place, k] = True
                left[place] -= 1
                rew[place] += 0.3
        else:
            # RANDOM bins (user call: the argmax cook taught the
            # policy to heat ONE cell); cook_bin is a deterministic
            # hash of (env, tick, loaf), identical on every backend
            for _k in range(self.loaves_per_load):
                j = cook_bin(ar_, self.tick, _k, self.n_belt)
                place = want & ~self.has_bread[ar_, j]
                self.has_bread[ar_[place], j[place]] = True
                rew[place] += 0.3
        self.load_timer[want] = 0.0
        # HOLDING COST (user call): every in-flight loaf drips
        # 0.3/loaves_per_load per step - the placement bonus is an
        # advance repaid by dawdling, so slow-cooking bleeds and
        # stuffing bins never pays. Boundary refunds stay at the full
        # 0.3: the drip only makes crash-with-inflight MORE negative,
        # so charge-and-crash remains over-closed.
        rew -= (0.03 / max(self.loaves_per_load, 1)) \
            * self.has_bread.sum(1)
        # DONENESS POTENTIAL (user call): +2 per full loaf-equivalent
        # of energy INTO dough, paid the step the spot delivers it -
        # the dense aim-at-the-roti channel the +5 was too far
        # downstream to provide. Telescopes exactly: a pull drops phi
        # by 1 (net +5-2 that step), scorch and boundary wipes refund
        # accrued doneness. At full flux ~+0.05/loaf-step, it beats
        # the -0.033 holding rent - cooking pays, dawdling bleeds.
        rew += 2.0 * (np.clip(self.bread_E / self.roti_energy,
                              0.0, 1.0).sum(1) - phi_old)
        # BANDED-SUM preheat potential, REINSTATED (see the rl_env
        # twin for the full why): beam-on must pay before the first
        # cook or the policy retreats to a soft mirror
        rew += 0.05 * np.clip(
            np.minimum(belt_T, T_COOK_LO)
            - np.minimum(T[:, : self.n_belt], T_COOK_LO),
            -5, 5).sum(1)
        self._belt_prev = belt_T.max(1).copy()
        # no temperature penalty (user call; matches the twins - and
        # heed the old warning here: this method is a FULL OVERRIDE,
        # base-class reward edits do NOT apply)
        rew -= 0.02 * (~self.jammed)        # soft = exposed and not cooking

        self.ep_return += rew
        self.ep_len += 1
        self.tick += 1
        day_over = self.t_solar >= 16.0
        self.terminals[:] = day_over
        self.truncations[:] = False
        self.rewards[:] = rew.astype(np.float32)
        infos = []
        ts0 = float(self.t_solar[0])
        hr = int(ts0)
        if self.hourly_metric \
                and hr > getattr(self, "_hr_mark", 8) \
                and ts0 < 16.0:
            infos.append({"rotis_per_hour":
                          float(self.day_rotis.mean())
                          - getattr(self, "_hr_rotis", 0.0),
                          "rotis_per_day":
                          float(self.day_rotis.mean()),
                          "scorched":
                          float(self.ep_scorch.mean())})
            self._hr_rotis = float(self.day_rotis.mean())
            self._hr_mark = hr
        if day_over.any():
            # end-of-day stuff-the-oven closed: a loaf loaded in the
            # last minutes was paid +0.3 but can never cook - charge
            # the bonus back when the day wipes it
            inflight = 0.3 * self.has_bread[day_over].sum(1) \
                + 2.0 * np.clip(self.bread_E[day_over]
                                / self.roti_energy, 0.0, 1.0).sum(1)
            self.rewards[day_over] -= inflight.astype(np.float32)
            self.ep_return[day_over] -= inflight
            infos.append({
                "rotis_per_day": float(
                    self.day_rotis[day_over].mean()),
                "scorched": float(self.ep_scorch[day_over].mean()),
                "spall_events": float(self.ep_spall[day_over].mean()),
                "form_minutes": float(
                    self.form_time[day_over].mean() * self.dt / 60),
                "episode_return": float(self.ep_return[day_over].mean()),
                "episode_length": float(self.ep_len[day_over].mean()),
            })
            night = bool(getattr(self, "night_carry", 0))
            if night:
                self._night_cool_np(day_over)
            for i in np.nonzero(day_over)[0]:
                self.t_solar[i] = 8.0
                if not night:
                    warm_i = self.rng.random() < self.warm_frac
                    if warm_i:
                        self.T[i] = self.rng.uniform(465, 505)
                    else:
                        self.T[i] = 350.0
                    self.T[i] += self.rng.uniform(-15, 15, self.n_nodes)
                    self.T_sub[i] = self.T[i].copy()
                    self.T_deep[i] = self.T[i].copy()
                    self.T_halo[i] = (self.rng.uniform(395, 415)
                                      if warm_i else 300.0)
                self._belt_prev[i] = self.T[i, : self.n_belt].mean()
                self.p_set[i] = self.p_act[i] = self.p0
                self.f_locked[i] = self.p0
                self.jammed[i] = True
                self._hold_p[i] = 4
                self._hold_s[i] = 6
                self._hold_j[i] = 6
                self.form_time[i] = 0.0
                self.decl_formed[i] = self._decl()
                self.p_dist[i] = 0.0
                self.shutter[i] = 1.0
                self.wind_g[i] = 0.0
                self.stowed[i] = False
                self.soil[i] = self.rng.uniform(0.85, 1.0)
                self.bore[i] = 0.0
                self.cloud[i] = 0.0
                self.has_bread[i] = False
                self.bread_E[i] = 0.0
                self.bread_t[i] = 0.0
                self.bread_C[i] = 0.0     # fresh dough carries no char
                self.load_timer[i] = 0.0
                self.ep_rotis[i] = self.ep_scorch[i] = 0.0
                self.day_rotis[i] = 0.0
                self.ep_spall[i] = 0.0
                self.ep_return[i] = self.ep_len[i] = 0.0
        self.observations[:] = self._obs()
        return (self.observations, self.rewards, self.terminals,
                self.truncations, infos)

    # ------------------------------------------------------------ render #
    def render(self):
        if self.render_mode == "ansi":
            bt = self.T[0, : self.n_belt]
            bar = "".join(" .:-=+*#%@"[int(np.clip((t - 350) / 60, 0, 9))]
                          for t in bt)
            return (f"t={self.t_solar[0]:5.2f}h P={self.p_in[0]:4.0f}W "
                    f"{'JAM' if self.jammed[0] else 'SOFT'} belt[{bar}] "
                    f"rotis={self.ep_rotis[0]:.0f}")
        if self.render_mode != "human":
            return None
        import pyray as pr
        W, H = 1400, 850
        if not self._window:
            pr.init_window(W, H, "Polar retrofit - existing tandoor")
            pr.set_target_fps(24)
            self._window = True
            self._cam_th, self._cam_ph, self._cam_r = 1.2, 0.30, 11.0
            self._cam_tgt = np.array([0.0, 1.8, -0.4])
        if pr.is_mouse_button_down(0):
            d = pr.get_mouse_delta()
            self._cam_th -= d.x * 0.006
            self._cam_ph = float(np.clip(self._cam_ph + d.y * 0.006,
                                         -0.35, 1.45))
        if pr.is_mouse_button_down(1):
            d = pr.get_mouse_delta()
            fwd = np.array([np.cos(self._cam_th), np.sin(self._cam_th)])
            right = np.array([fwd[1], -fwd[0]])
            self._cam_tgt[:2] += (right * d.x - fwd * d.y) * 0.004 * self._cam_r
            self._cam_tgt[2] += d.y * 0.003 * self._cam_r
        if pr.is_key_pressed(pr.KeyboardKey.KEY_R):
            self._cam_tgt = np.array([0.0, 1.8, -0.4])
            self._cam_th, self._cam_ph, self._cam_r = 1.2, 0.30, 11.0
        self._cam_r = float(np.clip(
            self._cam_r - pr.get_mouse_wheel_move() * 0.8, 1.5, 30.0))
        tgt = pr.Vector3(*[float(v) for v in self._cam_tgt])
        cp = pr.Vector3(
            tgt.x + self._cam_r * np.cos(self._cam_ph) * np.cos(self._cam_th),
            tgt.y + self._cam_r * np.cos(self._cam_ph) * np.sin(self._cam_th),
            tgt.z + self._cam_r * np.sin(self._cam_ph))
        cam = pr.Camera3D(cp, tgt, pr.Vector3(0.0, 0.0, 1.0), 45.0,
                          pr.CameraProjection.CAMERA_PERSPECTIVE)
        dim = float(np.clip(self.dni[0] / 950.0, 0.05, 1.0))
        el0, az0, svec = _sim.solar_position(self.lat, self.day,
                                             float(self.t_solar[0]))

        def v3(p):
            return pr.Vector3(float(p[0]), float(p[1]), float(p[2]))

        def ring(c, r, col, n=32, ax="z"):
            t_ = np.linspace(0, 2 * np.pi, n + 1)
            if ax == "z":
                q = np.stack([c[0] + r * np.cos(t_), c[1] + r * np.sin(t_),
                              np.full(n + 1, c[2])], 1)
            else:
                q = np.stack([c[0] + r * np.cos(t_), np.full(n + 1, c[1]),
                              c[2] + r * np.sin(t_)], 1)
            for k in range(n):
                pr.draw_line_3d(v3(q[k]), v3(q[k + 1]), col)

        pr.begin_drawing()
        pr.clear_background((int(12 + 26 * dim), int(14 + 32 * dim),
                             int(22 + 52 * dim), 255))
        pr.draw_rectangle(1010, 0, W - 1010, H, (13, 15, 22, 255))
        pr.begin_mode_3d(cam)
        # WORKFLOOR (the thing the earlier designs ignored) + courtyard wall
        for gx in np.linspace(-4, 4, 9):
            pr.draw_line_3d(v3([gx, -2.5, 0]), v3([gx, 7.0, 0]),
                            (52, 56, 66, 255))
        for gy in np.linspace(-2.5, 7.0, 10):
            pr.draw_line_3d(v3([-4, gy, 0]), v3([4, gy, 0]),
                            (52, 56, 66, 255))
        for wy in (-2.5, 7.0):
            for k in range(8):
                x0 = -4 + k
                pr.draw_line_3d(v3([x0, wy, 0]), v3([x0 + 1, wy, 0]),
                                (110, 96, 80, 255))
                pr.draw_line_3d(v3([x0, wy, 0]), v3([x0, wy, 1.8]),
                                (110, 96, 80, 255))
            pr.draw_line_3d(v3([-4, wy, 1.8]), v3([4, wy, 1.8]),
                            (110, 96, 80, 255))
        # EXISTING POT: barrel below the floor, mouth flush at z=0
        for zz in np.linspace(-H_POT, 0, 6):
            rr_ = R_POT if zz < -0.25 else R_MOUTH + (R_POT - R_MOUTH) * \
                (abs(zz) / 0.25)
            band = -0.75 < zz < -0.25
            col = (self._heat_color(self.T[0, 0]) if band
                   else (150, 118, 92, 255))
            ring(np.array([0, 0, zz]), rr_, col, 28)
        ring(np.array([0, 0, -H_POT]), R_POT * 0.5,
             self._heat_color(self.T[0, self.n_belt]), 16)   # hot floor
        ring(np.array([0, 0, 0]), R_MOUTH, (190, 160, 120, 255), 24)
        lidded = self.load_timer[0] >= 4.0
        if lidded:
            ring(np.array([0, 0, 0.03]), R_MOUTH * 0.92,
                 (120, 120, 128, 255), 20)
        # native AIR-INLET duct at the base, facing north
        for aa in (0, np.pi / 2, np.pi, 3 * np.pi / 2):
            pr.draw_line_3d(
                v3([R_DUCT * np.cos(aa), 0.0, Z_DUCT + R_DUCT * np.sin(aa)]),
                v3([R_DUCT * np.cos(aa), 0.7, Z_DUCT + R_DUCT * np.sin(aa)]),
                (170, 140, 100, 255))
        ring(np.array([0, 0.7, Z_DUCT]), R_DUCT, (120, 220, 235, 255),
             20, ax="y")
        # POLAR AXIS through the duct mouth, at the site latitude
        pax = np.array([0.0, np.cos(np.radians(self.lat)),
                        np.sin(np.radians(self.lat))])
        duct = np.array([0.0, 0.7, Z_DUCT])
        mc = duct + self.f_nom * pax
        pr.draw_line_3d(v3(duct - 0.5 * pax), v3(mc + 1.0 * pax),
                        (95, 95, 115, 255))
        # the ONE mirror: elliptical off-axis section, normal bisecting
        # sun and the line to focus; clocks about the polar axis
        to_f = -pax
        nb = svec + to_f
        nb = nb / max(np.linalg.norm(nb), 1e-9)
        u = np.cross(nb, [0, 0, 1.0]); u /= max(np.linalg.norm(u), 1e-9)
        w_ = np.cross(nb, u)
        t_ = np.linspace(0, 2 * np.pi, 41)
        rim = [mc + self.cfg.a * (np.cos(x) * u + 1.35 * np.sin(x) * w_)
               for x in t_]
        col_m = ((90, 150, 235, 255) if self.jammed[0]
                 else (235, 170, 90, 255))
        for k in range(40):
            pr.draw_line_3d(v3(rim[k]), v3(rim[k + 1]), col_m)
        for k in range(0, 40, 5):
            pr.draw_line_3d(v3(mc), v3(rim[k]), col_m)
        # rays: sun -> mirror -> duct -> pot floor
        lr = getattr(self, "_last_rays", None)
        if lr is not None and self.dni[0] > 1:
            pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
            ah = int(4 + 22 * dim)
            cb = (120, 88, 30, ah)
            for i in range(0, len(lr["org"]), 2):
                lx, ly, _ = lr["org"][i]
                mp = mc + lx * u + 1.35 * ly * w_
                pr.draw_line_3d(v3(mp + 2.5 * svec), v3(mp),
                                (60, 52, 30, max(ah // 2, 2)))
                if lr["through"][i]:
                    dp_ = lr["pduct"][i]
                    dw = np.array([dp_[0], 0.7, Z_DUCT + dp_[2]])
                    pr.draw_line_3d(v3(mp), v3(dw), cb)
                    pr.draw_line_3d(v3(dw), v3(lr["strike"][i]), cb)
                else:
                    pr.draw_line_3d(v3(mp), v3(duct), cb)
            pr.end_blend_mode()
        pr.end_mode_3d()
        # HUD
        self._draw_bread_strip(pr, 1025, 26)
        jam = self.jammed[0]
        drift = abs(self._decl() - self.decl_formed[0])
        hud = [
            f"solar {self.t_solar[0]:5.2f} h   el {el0:.0f} deg",
            f"DNI {self.dni[0]:4.0f}   cosine {self._cos_now:.2f}   "
            f"into pot {self.p_in[0]:5.0f} W",
            f"pouch {'JAMMED (shell, wind-immune)' if jam else 'SOFT (forming)'}",
            f"figure drift {drift:4.1f} deg   wind {self.wind[0]:4.1f} m/s"
            f"{'  STOWED' if self.stowed[0] else ''}",
            f"mouth {'LIDDED' if lidded else 'OPEN (loading)'}",
            f"rotis {self.ep_rotis[0]:.0f}   scorch {self.ep_scorch[0]:.0f}",
        ]
        hud.append(f"soft so far {self.form_time[0]*self.dt/60:4.0f} min"
                   f"   spall {self.ep_spall[0]:.0f}")
        for j, line in enumerate(hud):
            pr.draw_text(line, 1025, 120 + 26 * j, 17,
                         (120, 230, 140, 255) if (j == 2 and jam)
                         else (225, 225, 205, 255))
        self._draw_disturbances(pr, 1025, 320)
        pr.draw_text("POLAR RETROFIT: existing pot, native air-inlet, one "
                     "jammable mirror", 20, H - 50, 17, (170, 170, 185, 255))
        pr.draw_text("left-drag orbit   right-drag pan   wheel zoom   R reset",
                     20, H - 26, 16, (140, 140, 155, 255))
        pr.end_drawing()
        return None

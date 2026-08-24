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

SPECULATIVE ELEMENT (flagged, not hidden): the elliptical-rim membrane is
modelled as an on-axis FvK solve plus an explicit off-axis figure-error
term (sigma_offaxis). A true 2-D FvK solve on an elliptical rim is the
validation this design still owes; grain print-through is likewise an
explicit slope term rather than a derived one.
"""

import numpy as np
import torch

from tandoor_rl_env import TandoorEnv, _sim, SIGMA, T_AMB

R_POT = 0.42          # existing pot belly radius [m]
H_POT = 1.00          # pot depth, mouth at workfloor z=0 [m]
R_MOUTH = 0.26        # mouth radius (cook's opening) [m]
R_DUCT = 0.14         # native air-inlet hole radius [m]
Z_DUCT = -0.86        # duct centre height (near the base) [m]
THROW = 3.5           # mirror -> duct mouth [m]


class TandoorPolarEnv(TandoorEnv):
    N_HEADS = 3        # pressure level, shutter, JAM/RELEASE
    N_EXTRA_OBS = 2    # jam state, seasonal figure drift

    def _extra_obs(self):
        return np.stack([
            self.jammed.astype(np.float64),
            np.clip(np.abs(self._decl() - self.decl_formed) / 10.0,
                    0, 3),
        ], axis=1)

    def __init__(self, *args, wall_shelter=0.4, sigma_offaxis=1.2e-3,
                 sigma_print=0.8e-3, jam_gain=0.02, lid_leak=0.18,
                 **kwargs):
        self.lid_leak = float(lid_leak)   # lidded mouth loss factor
        self.wall_shelter = float(wall_shelter)   # courtyard wall: v -> 0.4v
        self.sigma_offaxis = float(sigma_offaxis)  # elliptical-rim mismatch
        self.sigma_print = float(sigma_print)      # grain print-through
        self.jam_gain = float(jam_gain)            # wind->focus gain jammed
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

        self.level_frac = np.array([0.86, 0.93, 0.97, 0.99, 1.00, 1.01,
                                    1.06])
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
        i0 = lv.long().clamp(max=self.N_LEVELS - 2)
        fr = (lv - i0.float())[:, None]
        sp = (1 - fr) * self.sp_levels[i0] + fr * self.sp_levels[i0 + 1]
        z = (1 - fr) * self.z_levels[i0] + fr * self.z_levels[i0 + 1]
        n3 = torch.stack([
            -sp * self.px * self._inv_r[0], -sp * self.py * self._inv_r[0],
            torch.ones_like(sp)], dim=-1)
        n3 = n3 * torch.rsqrt((n3 * n3).sum(-1, keepdim=True))
        sb = torch.as_tensor(sigma_b, dtype=torch.float32,
                             device=self.device)[:, None, None]
        ds = torch.randn(B, P, 2, device=self.device) * sb
        tail = torch.rand(B, P, 1, device=self.device) < self.csr_frac
        ds = torch.where(
            tail, torch.randn(B, P, 2, device=self.device) * 15e-3, ds)
        i3 = torch.cat([ds, -torch.ones_like(self._ones_bp1)], dim=-1)
        i3 = i3 * torch.rsqrt((i3 * i3).sum(-1, keepdim=True))
        d1 = i3 - 2 * (i3 * n3).sum(-1, keepdim=True) * n3
        off = torch.as_tensor(offset_w, dtype=torch.float32,
                              device=self.device)
        tz = (self.f_nom - z) / d1[..., 2].clamp(min=1e-6)
        pxp = self.px + tz * d1[..., 0] + off[:, 0:1]
        pyp = self.py + tz * d1[..., 1] + off[:, 1:2]
        through = (pxp**2 + pyp**2) <= R_DUCT**2

        # through the duct: beam runs +y (into the pot) angled down onto
        # the pot floor where the coal bed lives
        dxw = d1[..., 0]
        dyw = -d1[..., 2]
        dzw = d1[..., 1] - 0.16          # aim the cone at the floor
        ox = pxp
        oy = torch.full_like(pxp, -R_POT)
        oz = pyp + Z_DUCT
        # strike the pot: floor plane first, else the cylinder wall
        t_floor = (-H_POT - oz) / dzw.clamp(max=-1e-6)
        fx, fy = ox + t_floor * dxw, oy + t_floor * dyw
        hit_floor = (fx**2 + fy**2) <= R_POT**2
        aq = dxw**2 + dyw**2
        bq = ox * dxw + oy * dyw
        cq = ox**2 + oy**2 - R_POT**2
        t_wall = (-bq + torch.sqrt((bq**2 - aq * cq).clamp(min=0))) \
            / aq.clamp(min=1e-9)
        wz = oz + t_wall * dzw
        sx = torch.where(hit_floor, fx, ox + t_wall * dxw)
        sy = torch.where(hit_floor, fy, oy + t_wall * dyw)
        sz = torch.where(hit_floor, torch.full_like(wz, -H_POT), wz)
        phi = torch.atan2(sy, sx)
        seg = ((phi + np.pi) / (2 * np.pi) * self.n_belt).long().clamp(
            0, self.n_belt - 1)
        node = torch.where(
            hit_floor | (sz < -H_POT + 0.12),
            torch.full_like(seg, self.n_belt),          # hearth = pot floor
            torch.where(sz > -0.22,
                        torch.full_like(seg, self.n_belt + 2),  # near mouth
                        seg))                                   # roti wall
        soil_t = torch.as_tensor(soil, dtype=torch.float32,
                                 device=self.device)
        w = ((self._ray_pw[None, :] * soil_t[:, None]).reshape(-1)
             * through.reshape(-1).float())
        if self.render_mode == "human":
            self._last_rays = dict(
                org=torch.stack([self.px, self.py, z[0]], -1).cpu().numpy(),
                pduct=torch.stack([pxp[0], torch.zeros(P, device=self.device),
                                   pyp[0]], -1).cpu().numpy(),
                strike=torch.stack([sx[0], sy[0], sz[0]], -1).cpu().numpy(),
                through=through[0].cpu().numpy())
        out = torch.zeros(B * self.n_nodes, device=self.device)
        out.index_put_((self._env_off + node.reshape(-1),), w,
                       accumulate=True)
        return out.reshape(B, self.n_nodes).cpu()

    # -------------------------------------------------------------- step #
    def _reset_state(self):
        super()._reset_state()
        B = self.num_agents
        self.jammed = np.ones(B, dtype=bool)
        self.f_locked = np.full(B, self.p0)     # pressure frozen at jam
        self.decl_formed = np.full(B, self._decl())
        self.form_time = np.zeros(B)            # steps spent soft today

    def _decl(self):
        return float(np.degrees(np.radians(23.44) * np.sin(
            2 * np.pi * (284 + self.day) / 365)))

    def step(self, actions):
        B = self.num_agents
        a = np.asarray(actions).reshape(B, 3)
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
        sig_wind = gain * q_w * self.cfg.a / (2.0 * self.cfg.T_pre)
        # seasonal drift since the last re-forming shows up as astigmatism
        drift = np.abs(self._decl() - self.decl_formed)
        sig_drift = np.radians(drift) * 0.04
        sigma_b = np.sqrt(self.sigma_sun**2 + self.sig_static**2
                          + (2 * 0.35 * sig_wind) ** 2 + sig_drift**2)
        self.bore += (-self.bore / 300.0 * self.dt
                      + self.rng.normal(
                          0, 0.010 * np.sqrt(2 * self.dt / 300.0), (B, 2)))

        with torch.no_grad():
            per_dni = self._trace_power(p_eff, sigma_b, self.bore,
                                        self.soil).numpy()
        gate = self.dni * cosf * self.shutter * self.jammed
        q_solar = per_dni * gate[:, None] * 0.85
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
        q = q_solar + q_exch - (T - T_AMB) / self.r_soil
        q[:, self.n_belt + 2] -= q_ap
        belt_T = T[:, : self.n_belt]
        q_b = self.has_bread * (25.0 * 0.05) * (belt_T - 400.0)
        q[:, : self.n_belt] -= q_b
        dT = q * self.dt / self.node_heat_cap
        self.T = T + dT
        self.bread_E += q_b * self.dt
        self.bread_t += self.has_bread * self.dt
        spall = dT[:, self.n_belt] > 25.0
        self.ep_spall += spall

        rew = np.zeros(B)
        belt_T = self.T[:, : self.n_belt]
        cooked = self.has_bread & (self.bread_E >= 45e3)
        scorched = self.has_bread & (belt_T > 730.0)
        doughy = self.has_bread & (self.bread_t > 300.0) & ~cooked
        rew += 5.0 * cooked.sum(1) - 5.0 * scorched.sum(1) \
            - 0.5 * doughy.sum(1) - 0.5 * spall
        self.ep_rotis += cooked.sum(1)
        self.ep_scorch += scorched.sum(1)
        done_bread = cooked | scorched | doughy
        self.has_bread &= ~done_bread
        self.bread_E[done_bread] = 0.0
        self.bread_t[done_bread] = 0.0
        # cook loads at the mouth: the beam is at the BASE and never
        # crosses the mouth, so loading needs no shutter interlock here -
        # the retrofit's structural safety win
        self.load_timer += self.dt
        ok_ = (~self.has_bread) & (belt_T >= 560.0) & (belt_T <= 700.0)
        can = np.nonzero((self.load_timer >= 45.0) & ok_.any(1))[0]
        j = np.argmax(np.where(ok_, belt_T, -np.inf), axis=1)
        self.has_bread[can, j[can]] = True
        self.load_timer[can] = 0.0
        rew[can] += 0.3
        belt_mean = belt_T.mean(1)
        below = belt_mean < 560.0
        rew += 0.05 * np.clip(belt_mean - self._belt_prev, -5, 5) * below
        self._belt_prev = belt_mean.copy()
        rew -= 0.05 * np.clip(belt_mean - 690.0, 0, None) / 10.0
        rew -= 0.02 * ((belt_mean - 640.0) / 100.0) ** 2
        rew -= 0.02 * (~self.jammed)        # soft = exposed and not cooking

        self.ep_return += rew
        self.ep_len += 1
        self.tick += 1
        day_over = self.t_solar >= 16.0
        self.terminals[:] = day_over
        self.truncations[:] = False
        self.rewards[:] = rew.astype(np.float32)
        infos = []
        if day_over.any():
            infos.append({
                "rotis_per_day": float(self.ep_rotis[day_over].mean()),
                "scorched": float(self.ep_scorch[day_over].mean()),
                "spall_events": float(self.ep_spall[day_over].mean()),
                "form_minutes": float(
                    self.form_time[day_over].mean() * self.dt / 60),
                "episode_return": float(self.ep_return[day_over].mean()),
                "episode_length": float(self.ep_len[day_over].mean()),
            })
            for i in np.nonzero(day_over)[0]:
                self.t_solar[i] = 8.0
                if self.rng.random() < self.warm_frac:
                    self.T[i] = self.rng.uniform(540, 620)
                else:
                    self.T[i] = 350.0
                self.T[i] += self.rng.uniform(-15, 15, self.n_nodes)
                self._belt_prev[i] = self.T[i, : self.n_belt].mean()
                self.p_set[i] = self.p_act[i] = self.p0
                self.f_locked[i] = self.p0
                self.jammed[i] = True
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
                self.load_timer[i] = 0.0
                self.ep_rotis[i] = self.ep_scorch[i] = 0.0
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
        for k in range(self.n_belt):
            pr.draw_rectangle(1025 + 44 * k, 30, 40, 30,
                              self._heat_color(self.T[0, k]))
            pr.draw_text(f"{self.T[0, k] - 273:.0f}", 1030 + 44 * k, 38, 13,
                         (235, 235, 235, 255))
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
        for j, line in enumerate(hud):
            pr.draw_text(line, 1025, 90 + 28 * j, 18,
                         (120, 230, 140, 255) if (j == 2 and jam)
                         else (225, 225, 205, 255))
        pr.draw_text("POLAR RETROFIT: existing pot, native air-inlet, one "
                     "jammable mirror", 20, H - 50, 17, (170, 170, 185, 255))
        pr.draw_text("left-drag orbit   right-drag pan   wheel zoom   R reset",
                     20, H - 26, 16, (140, 140, 155, 255))
        pr.end_drawing()
        return None

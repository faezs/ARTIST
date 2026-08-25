"""
TandoorShedEnv: the Shed Furnace as a PufferLib env, sharing the
field-real thermal/bread/reward machinery of the beam-down env so the
two architectures are comparable eval-for-eval.

Geometry (world frame, z up, y north):
  - Tandoor sphere buried with its SIDE PORT at the origin, facing north
    (beam travels south -> north into the port... i.e., port normal +y).
  - Membrane: standing disc 3 m north of the port (y=+3), axis -y,
    permanently aimed; sheltered in a shed (no wind/soiling terms).
  - Heliostat: flat board ~6 m further north (y=+9), 2-axis, reflects
    the sun into the -y horizontal feed beam. Flat slope error 3 mrad;
    pointing error small (garden-tracker class) modeled as OU decenter.
  - Charge window: 0.5 m^2 glazing admitting unconcentrated DNI to the
    cavity crown for preheat (always-on trickle).

Actions: identical to the beam-down env (MultiDiscrete [7,7]):
  pressure level (focus trim about f=3 m), shutter open/closed.
"""

import numpy as np
import torch

from tandoor_rl_env import TandoorEnv, _sim, SIGMA, T_AMB


class TandoorShedEnv(TandoorEnv):
    def _build_optics(self):
        cfg = _sim.CFG
        cfg.a = 1.6
        cfg.r_pit = 0.15         # side-port throat radius
        self.cfg = cfg
        self.throw = 3.0
        self.p0 = float(cfg.T_pre / self.throw)  # dp for f = 3 m
        cfg.dp = self.p0
        dev = self.device

        # 7 focus-trim levels about f = 3 m, exact FvK solves
        self.level_frac = np.array([0.85, 0.92, 0.96, 0.985, 1.00, 1.015,
                                    1.05])
        mems = [_sim.solve_membrane(cfg, self.p0 * f, n=500)
                for f in self.level_frac]
        self._mem0 = mems[4]

        n = 44
        xy = torch.linspace(-cfg.a, cfg.a, n)
        X, Y = torch.meshgrid(xy, xy, indexing="ij")
        rr = torch.sqrt(X**2 + Y**2).reshape(-1)
        keep = (rr > 0.06) & (rr < cfg.a * 0.985)
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

        # honest chain, Shed Furnace edition: outdoor soiled flat, shed
        # window, SHELTERED membrane (clean), port lip
        cell = float(xy[1] - xy[0]) ** 2
        self._loss_chain = 0.85 * 0.92 * 0.90 * 0.96
        self._ray_pw = torch.full_like(self.pr, cell * self._loss_chain)

        # blur: sheltered membrane 2.0 mrad + outdoor flat 3.0 mrad,
        # both doubled on reflection; NO wind term on the membrane
        self.sigma_sun = 2.09e-3
        self.sig_static = np.sqrt((2 * 2.0e-3) ** 2 + (2 * 3.0e-3) ** 2)

        # side-fired cavity: port at origin, normal +y (beam goes -y..
        # port plane y=0), sphere center at -y interior
        R = cfg.R_oven
        self._yc_w = -float(np.sqrt(R**2 - cfg.r_pit**2))
        self._oc_w = torch.tensor([0.0, self._yc_w, 0.0], device=dev)
        self.ct_cut = float(np.sqrt(R**2 - cfg.r_pit**2) / R)
        self.zc_oven = self._yc_w  # renderer compat
        self._zc_w = self._yc_w

        B, P = self.num_agents, self.pr.shape[0]
        self._env_off = (torch.arange(B, device=dev) * self.n_nodes
                         ).repeat_interleave(P)
        self._ones_bp1 = torch.zeros(B, P, 1, device=dev)
        self._inv_r = (1.0 / self.pr).expand(B, P)
        self._sun_R = torch.eye(3, device=dev)
        self.a_charge = 0.5  # m^2 charge window
        print(f"  [shed optics] f={self.f_nom:.2f} m, dp0={self.p0:.0f} Pa, "
              f"port r={cfg.r_pit} m, chain {self._loss_chain:.2f}")

    def _cosine(self, svec):
        # Odeillo layout: heliostat north, feed beam travels -y (south)
        tgt = np.array([0.0, -1.0, 0.0])
        return float(np.sqrt(np.clip((svec @ tgt + 1) / 2, 0, 1)))

    def _trace_power(self, p_act, sigma_b, offset_w, soil):
        """Membrane-local frame: axis z toward the port at z=f. World
        embedding for the renderer: local (x,y,z) -> world (x, f - z, z')
        with the disc standing vertical; strikes computed on the side-
        fired sphere."""
        B = p_act.shape[0]
        P = self.pr.shape[0]
        lv = (p_act / self.p0 - self.level_frac[0]) / (
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
        # boresight decenter (heliostat pointing residual): shift at port
        off = torch.as_tensor(offset_w, dtype=torch.float32,
                              device=self.device)
        tz = (self.f_nom - z) / d1[..., 2].clamp(min=1e-6)
        pxp = self.px + tz * d1[..., 0] + off[:, 0:1]
        pyp = self.py + tz * d1[..., 1] + off[:, 1:2]
        rho2 = pxp**2 + pyp**2
        through = rho2 <= self.cfg.r_pit**2
        # side-fired sphere strike: enter port plane traveling +z local =
        # -y world into the sphere centered at y = yc
        # local->world: xw = xp, yw = -(depth beyond port), zw = yp
        dxw = d1[..., 0]
        dyw = -d1[..., 2]
        dzw = d1[..., 1]
        ox, oy, oz = pxp, torch.zeros_like(pxp), pyp
        qx, qy, qz = ox, oy - self._yc_w, oz
        b = qx * dxw + qy * dyw + qz * dzw
        c = qx**2 + qy**2 + qz**2 - self.cfg.R_oven**2
        ts = -b + torch.sqrt((b**2 - c).clamp(min=0))
        sx_, sy_, sz_ = (ox + ts * dxw, oy + ts * dyw, oz + ts * dzw)
        # node binning: belt = vertical band of the sphere; azimuth about
        # the vertical axis through the sphere center
        ct = (sz_ / self.cfg.R_oven).clamp(-1, 1)
        phi = torch.atan2(sy_ - self._yc_w, sx_)
        seg = ((phi + np.pi) / (2 * np.pi) * self.n_belt).long().clamp(
            0, self.n_belt - 1)
        rho_h = torch.sqrt(sx_**2 + (sy_ - self._yc_w) ** 2)
        node = torch.where(
            (ct < -0.4), torch.full_like(seg, self.n_belt + 1),
            torch.where(
                (ct < -0.1) & (rho_h < 0.30),
                torch.full_like(seg, self.n_belt),
                torch.where(ct > 0.55,
                            torch.full_like(seg, self.n_belt + 2), seg)))
        soil_t = torch.as_tensor(soil, dtype=torch.float32,
                                 device=self.device)
        w = ((self._ray_pw[None, :] * soil_t[:, None]).reshape(-1)
             * through.reshape(-1).float())
        if self.render_mode == "human":
            sl = slice(0, P)
            self._last_rays = dict(
                org=torch.stack([self.px, self.py,
                                 z[0]], -1).cpu().numpy(),
                d1=d1[0].cpu().numpy(),
                pport=torch.stack([pxp[0], torch.zeros(P, device=self.device),
                                   pyp[0]], -1).cpu().numpy(),
                strike=torch.stack([sx_[0], sy_[0], sz_[0]],
                                   -1).cpu().numpy(),
                through=through[0].cpu().numpy(),
                w=w.reshape(B, P)[0].cpu().numpy(),
            )
        out = torch.zeros(B * self.n_nodes, device=self.device)
        out.index_put_((self._env_off + node.reshape(-1),), w,
                       accumulate=True)
        return out.reshape(B, self.n_nodes).cpu()

    def step(self, actions):
        # reuse the parent thermal/bread/reward loop wholesale, but with
        # shed physics: cosine collection, no wind on the membrane (wind
        # only stows the flat above 14 m/s - it is low and braced), and
        # the charge window trickle
        B = self.num_agents
        a = np.asarray(actions).reshape(B, 2)
        self.p_set = self.p0 * self.level_frac[
            np.clip(a[:, 0], 0, self.N_LEVELS - 1)]
        thr = 3.5 if self.wide_shutter else 0.5
        self.shutter = (a[:, 1] > thr).astype(np.float64)
        bias = 0.05 * (self.dni - 400.0) / 10.0
        self.p_dist += ((bias - self.p_dist) / 900.0 * self.dt
                        + self.rng.normal(0, 1.2, B))
        self.p_dist = np.clip(self.p_dist, -40, 60)
        self.p_act += np.clip(self.p_set + self.p_dist - self.p_act,
                              -6.0, 6.0)
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
        self.wind = np.clip(base_w + self.wind_g, 0, 25)
        self.stowed = (self.stowed | (self.wind > 14.0)) & ~(
            self.wind < 12.0)  # flat stows at higher wind than a dish
        cosf = self._cosine(svec) if el0 > 8.0 else 0.0
        self._cos_now = cosf
        self.dni = clear * np.exp(self.cloud) * (el0 > 8.0) * ~self.stowed
        # blur: NO wind-on-membrane term; small flat-flex term with wind
        # sheltered membrane: only the outdoor flat flexes, and the
        # 2-D-solver-calibrated law makes even that negligible
        sigma_b = np.sqrt(self.sigma_sun**2 + self.sig_static**2
                          + (2 * 0.14e-3 * (0.6 * self.wind**2 / 15.0)
                             ** 0.6) ** 2)
        self.bore += (-self.bore / 300.0 * self.dt
                      + self.rng.normal(
                          0, 0.012 * np.sqrt(2 * self.dt / 300.0), (B, 2)))
        with torch.no_grad():
            per_dni = self._trace_power(self.p_act, sigma_b, self.bore,
                                        self.soil).numpy()
        gate = self.dni * cosf * self.shutter
        q_solar = per_dni * gate[:, None] * 0.85
        # charge window: unconcentrated trickle onto the crown, always on
        q_solar[:, self.n_belt + 2] += (self.dni * np.sin(np.radians(
            max(el0, 0))) * self.a_charge * 0.85 * 0.85)
        self.p_in = per_dni.sum(1) * gate

        T = self.T
        t4 = T**4
        t_cav4 = (self.node_area * t4).sum(1, keepdims=True) \
            / self.node_area.sum()
        q_exch = 0.85 * SIGMA * self.node_area * (t_cav4 - t4)
        q_ap = 0.3 * SIGMA * (t_cav4.squeeze(1) - T_AMB**4) * self.a_ap
        q = q_solar + q_exch - (T - T_AMB) / self.r_soil
        q[:, self.n_belt + 2] -= q_ap
        h_bread = 25.0 * 0.05
        belt_T = T[:, : self.n_belt]
        q_b = self.has_bread * h_bread * (belt_T - 400.0)
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
        self.load_timer += self.dt
        want = (self.load_timer >= 45.0) & (self.shutter < 0.5)
        ok_ = (~self.has_bread) & (belt_T >= 560.0) & (belt_T <= 700.0)
        can = np.nonzero(want & ok_.any(1))[0]
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


    def render(self):
        if self.render_mode == "ansi":
            bt = self.T[0, : self.n_belt]
            bar = "".join(" .:-=+*#%@"[int(np.clip(
                (t - 350) / 60, 0, 9))] for t in bt)
            return (f"t={self.t_solar[0]:5.2f}h DNI={self.dni[0]:4.0f} "
                    f"P={self.p_in[0]:4.0f}W belt[{bar}] "
                    f"rotis={self.ep_rotis[0]:.0f}")
        if self.render_mode != "human":
            return None
        import pyray as pr
        W, H = 1400, 850
        if not self._window:
            pr.init_window(W, H, "Shed Furnace - ARTIST raytrace (3D)")
            pr.set_target_fps(24)
            self._window = True
            self._cam_th, self._cam_ph, self._cam_r = 1.15, 0.35, 13.0
            self._cam_tgt = np.array([0.0, 3.5, 0.0])
        if pr.is_mouse_button_down(0):
            d = pr.get_mouse_delta()
            self._cam_th -= d.x * 0.006
            self._cam_ph = float(np.clip(self._cam_ph + d.y * 0.006,
                                         -0.2, 1.45))
        if pr.is_mouse_button_down(1):
            d = pr.get_mouse_delta()
            fwd = np.array([np.cos(self._cam_th), np.sin(self._cam_th)])
            right = np.array([fwd[1], -fwd[0]])
            self._cam_tgt[:2] += (right * d.x - fwd * d.y * np.sin(
                self._cam_ph)) * 0.004 * self._cam_r
            self._cam_tgt[2] += d.y * 0.004 * self._cam_r * np.cos(
                self._cam_ph)
        if pr.is_key_pressed(pr.KeyboardKey.KEY_R):
            self._cam_tgt = np.array([0.0, 3.5, 0.0])
            self._cam_th, self._cam_ph, self._cam_r = 1.15, 0.35, 13.0
        self._cam_r = float(np.clip(
            self._cam_r - pr.get_mouse_wheel_move() * 0.9, 1.5, 30.0))
        tgt = pr.Vector3(*[float(v) for v in self._cam_tgt])
        cp = pr.Vector3(
            tgt.x + self._cam_r * np.cos(self._cam_ph) * np.cos(self._cam_th),
            tgt.y + self._cam_r * np.cos(self._cam_ph) * np.sin(self._cam_th),
            tgt.z + self._cam_r * np.sin(self._cam_ph))
        cam = pr.Camera3D(cp, tgt, pr.Vector3(0.0, 0.0, 1.0), 45.0,
                          pr.CameraProjection.CAMERA_PERSPECTIVE)
        dim = float(np.clip(self.dni[0] / 950.0, 0.04, 1.0))
        GRADE = -1.7

        def v3(p):
            return pr.Vector3(float(p[0]), float(p[1]), float(p[2]))

        def ring(c, r, col, n=36, axis="z"):
            th_ = np.linspace(0, 2 * np.pi, n + 1)
            if axis == "z":
                pts = np.stack([c[0] + r * np.cos(th_),
                                c[1] + r * np.sin(th_),
                                np.full(n + 1, c[2])], 1)
            else:  # normal +y (port rings)
                pts = np.stack([c[0] + r * np.cos(th_),
                                np.full(n + 1, c[1]),
                                c[2] + r * np.sin(th_)], 1)
            for k in range(n):
                pr.draw_line_3d(v3(pts[k]), v3(pts[k + 1]), col)

        pr.begin_drawing()
        pr.clear_background((int(12 + 28 * dim), int(14 + 34 * dim),
                             int(22 + 56 * dim), 255))
        pr.draw_rectangle(1000, 0, W - 1000, H, (13, 15, 22, 255))
        pr.begin_mode_3d(cam)
        # grade + berm + shed box
        for r_ in (3.0, 6.0, 9.5):
            ring(np.array([0, 4.0, GRADE]), r_, (58, 60, 72, 255), 48)
        el0, az0, svec = _sim.solar_position(self.lat, self.day,
                                             float(self.t_solar[0]))
        # tandoor: sphere wireframe, belt colored, crown mouth, side port
        yc = self._yc_w
        for zo in (-0.45, -0.2, 0.2, 0.45):
            rw = np.sqrt(max(self.cfg.R_oven**2 - zo**2, 1e-4))
            ring(np.array([0, yc, zo]), rw, (95, 70, 58, 255), 28)
        for k in range(self.n_belt):
            a0 = -np.pi + 2 * np.pi * k / self.n_belt
            th_ = np.linspace(a0, a0 + 2 * np.pi / self.n_belt, 7)
            col = self._heat_color(self.T[0, k])
            rw = self.cfg.R_oven
            for j in range(6):
                pr.draw_line_3d(
                    v3([rw * np.cos(th_[j]), yc + rw * np.sin(th_[j]), 0]),
                    v3([rw * np.cos(th_[j + 1]),
                        yc + rw * np.sin(th_[j + 1]), 0]), col)
        ring(np.array([0, yc, self.cfg.R_oven * 0.96]), 0.2,
             (170, 125, 90, 255), 20)          # crown mouth (cook side)
        ring(np.array([0, 0, 0]), self.cfg.r_pit, (120, 220, 235, 255),
             24, axis="y")                     # side port
        # berm outline around the tandoor
        ring(np.array([0, yc, GRADE]), 1.6, (70, 66, 60, 255), 30)
        # shed: box wireframe y in [1.4, 4.6]
        bx = [(-2.1, 1.4), (2.1, 1.4), (2.1, 4.6), (-2.1, 4.6)]
        for z_ in (GRADE, 2.0):
            for i in range(4):
                x0, y0 = bx[i]
                x1, y1 = bx[(i + 1) % 4]
                pr.draw_line_3d(v3([x0, y0, z_]), v3([x1, y1, z_]),
                                (80, 85, 100, 255))
        for x0, y0 in bx:
            pr.draw_line_3d(v3([x0, y0, GRADE]), v3([x0, y0, 2.0]),
                            (80, 85, 100, 255))
        # membrane: standing disc at y=3 (wireframe rings + spokes)
        pr_np = self.pr.cpu().numpy()
        order = np.argsort(pr_np)
        rs_, zs_ = pr_np[order], self.pz_sag.cpu().numpy()[order]
        for rr_ in np.linspace(rs_[0], rs_[-1], 4):
            sg = float(np.interp(rr_, rs_, zs_))
            ring(np.array([0, 3.0 - sg, 0]), rr_, (90, 150, 235, 255),
                 30, axis="y")
        for aa in np.linspace(0, 2 * np.pi, 10, endpoint=False):
            pts = np.stack([np.cos(aa) * rs_[::90],
                            3.0 - zs_[::90],
                            np.sin(aa) * rs_[::90]], 1)
            for j in range(len(pts) - 1):
                pr.draw_line_3d(v3(pts[j]), v3(pts[j + 1]),
                                (90, 150, 235, 255))
        # heliostat: flat board at y=9 whose normal bisects sun -> -y
        d_out = np.array([0.0, -1.0, 0.0])
        nb = svec + d_out
        nb = nb / max(np.linalg.norm(nb), 1e-9)
        u = np.cross(nb, [0, 0, 1.0]); u /= max(np.linalg.norm(u), 1e-9)
        w_ = np.cross(nb, u)
        cb = np.array([0, 9.0, 0.0])
        corners = [cb + 1.7 * (su * u + sw * w_) for su, sw in
                   ((-1, -1), (1, -1), (1, 1), (-1, 1))]
        for i in range(4):
            pr.draw_line_3d(v3(corners[i]), v3(corners[(i + 1) % 4]),
                            (200, 200, 215, 255))
        pr.draw_line_3d(v3(cb), v3(cb + 1.2 * nb), (150, 150, 165, 255))
        # rays: sun -> heliostat -> membrane -> port -> wall, additive
        lr = getattr(self, "_last_rays", None)
        if lr is not None:
            pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
            a_hi = int(4 + 24 * dim * self._cos_now
                       * float(self.shutter[0]) + 3)
            col_b = (120, 88, 30, a_hi)
            col_in = (65, 55, 30, max(a_hi // 2, 2))
            P = len(lr["org"])
            for i in range(P):
                x, yl, sg = lr["org"][i]
                mw = np.array([x, 3.0 - sg, yl])
                hb = np.array([x, 9.0, yl])
                pr.draw_line_3d(v3(hb + 3.0 * svec), v3(hb), col_in)
                pr.draw_line_3d(v3(hb), v3(mw), col_in)
                if lr["through"][i]:
                    pp = lr["pport"][i]
                    pr.draw_line_3d(v3(mw), v3(pp), col_b)
                    pr.draw_line_3d(v3(pp), v3(lr["strike"][i]), col_b)
                else:
                    pp = lr["pport"][i]
                    pr.draw_line_3d(v3(mw), v3(pp), col_b)
            pr.end_blend_mode()
        pr.end_mode_3d()
        # HUD: port-plane + wall maps from the live rays
        if lr is not None:
            pw = lr["w"] * self.dni[0] * self._cos_now
            pp = lr["pport"]
            hist, xe, ye = np.histogram2d(
                pp[:, 0], pp[:, 2], bins=30,
                range=[[-0.25, 0.25], [-0.25, 0.25]], weights=pw)
            if not hasattr(self, "_pmap"):
                self._pmap = hist
            self._pmap = 0.85 * self._pmap + 0.15 * hist
            vm = max(self._pmap.max(), 1e-6)
            pr.draw_text("port flux", 1020, 14, 16, (200, 200, 210, 255))
            for i in range(30):
                for j in range(30):
                    pr.draw_rectangle(1020 + i * 6, 36 + j * 6, 6, 6,
                                      self._flux_color(self._pmap[i, j], vm))
            pr.draw_text(f"cosine {self._cos_now:.2f}   "
                         f"P {self.p_in[0]:.0f} W", 1020, 232, 17,
                         (220, 220, 205, 255))
        for k in range(self.n_belt):
            pr.draw_rectangle(1020 + 44 * k, 270, 40, 30,
                              self._heat_color(self.T[0, k]))
            pr.draw_text(f"{self.T[0, k] - 273:.0f}", 1026 + 44 * k, 278,
                         13, (235, 235, 235, 255))
        sh = self.shutter[0] > 0.5
        hud = [
            f"solar {self.t_solar[0]:5.2f} h  el {el0:.0f}  "
            f"DNI {self.dni[0]:4.0f}",
            f"shutter {'OPEN' if sh else 'CLOSED'}   wind "
            f"{self.wind[0]:4.1f}{'  STOWED' if self.stowed[0] else ''}",
            f"plenum {self.p_act[0] - self.p0:+.0f} Pa   rotis "
            f"{self.ep_rotis[0]:.0f}  scorch {self.ep_scorch[0]:.0f}",
        ]
        for j, line in enumerate(hud):
            pr.draw_text(line, 1020, 330 + 26 * j, 18, (225, 225, 205, 255))
        pr.draw_text("SHED FURNACE   left-drag orbit  right-drag pan  "
                     "wheel zoom  R reset", 20, H - 28, 16,
                     (150, 150, 165, 255))
        pr.end_drawing()
        return None

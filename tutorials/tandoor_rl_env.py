"""
TandoorEnv: the pump-actuated membrane beam-down tandoor as a native
PufferLib environment (pufferlib >= 3.0, PufferEnv API).

The agent is the PUMP CONTROLLER of the multi-zone adaptive membrane:
each step it nudges the K plenum-zone pressures (rate-limited, like real
diaphragm pumps). Focus, aberration correction, and power throttling are
all the same knob - pressure. It must keep the roti belt in the cooking
band while:
  - the sun runs its day arc (clear-sky DNI x an Ornstein-Uhlenbeck cloud
    process with occasional deep cloud events),
  - actuator drift biases commanded vs actual pressures (so open-loop
    lookup fails - feedback through the flux/temperature obs is required),
  - rotis are slapped onto the hottest in-band wall segment on a fixed
    cadence and cook as local heat sinks (scorch if the wall runs hot).

Physics per step (all torch, batched over the vectorized envs):
  - membrane slope field = FvK baseline + sum_k dp_k * mode_k. The modes are
    per-zone FvK solves done once at init; linearity of pressure -> shape was
    validated by one-step Gauss-Newton convergence in the design study
    (03_membrane_beamdown_tandoor.py).
  - raytrace: reflect at the membrane (ARTIST's reflect()), closed-form
    hyperboloid intersection, reflect, window/pit clipping, sphere strike,
    scatter-add power into 10 wall nodes (8 belt azimuth segments + floor
    + crown). ~[B, 1500] rays in a handful of tensor ops.
  - thermal: lumped-capacitance wall nodes with one-bounce gray cavity
    exchange, soil conduction, aperture re-radiation, and bread heat sinks.

Episode: one cooking day (08:00-16:00 solar, dt = 15 s -> 1920 steps).
Reward: +1 per roti cooked, -1 scorched, -0.1 timed-out doughy, minus a
small belt-temperature-band penalty and pump-effort cost.

Run `python tutorials/tandoor_rl_env.py` for a random-policy benchmark.
"""

import importlib.util
import pathlib
import sys

import gymnasium
import numpy as np
import torch

import pufferlib

_here = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(_here.parent))
_spec = importlib.util.spec_from_file_location(
    "tandoor_sim", _here / "03_membrane_beamdown_tandoor.py"
)
_sim = importlib.util.module_from_spec(_spec)
sys.argv, _argv = [sys.argv[0]], sys.argv  # keep the sim's argparse quiet
_spec.loader.exec_module(_sim)
sys.argv = _argv
_sim.DEVICE = torch.device("cpu")  # RL rollouts: small batched CPU tensors

SIGMA = 5.67e-8
T_AMB = 300.0
T_COOK_LO, T_COOK_HI, T_SCORCH = 580.0, 700.0, 730.0  # K
ROTI_ENERGY = 45e3  # J to cook one roti
ROTI_TIMEOUT = 300.0  # s on the wall before it counts as doughy


class TandoorEnv(pufferlib.PufferEnv):
    """Natively vectorized: one instance simulates ``num_agents`` tandoors."""

    def __init__(self, num_agents=32, n_zones=5, dt=15.0, lat=28.6,
                 day_of_year=80, seed=0, device=None, render_mode=None,
                 buf=None):
        if device is None:
            device = "mps" if torch.backends.mps.is_available() else "cpu"
        self.device = torch.device(device)
        self.render_mode = render_mode
        self._window = False
        self.n_zones = n_zones
        self.dt = dt
        self.lat = lat
        self.day = day_of_year
        self.n_belt = 8
        # nodes: belt segments + hearth spot (beam footprint) + floor rest
        # + crown. The tiny hearth node runs ~800 K and does the radiating
        # (T^4: a small glowing spot beats the same power smeared wide).
        self.n_nodes = self.n_belt + 3
        obs_dim = 3 + self.n_nodes + n_zones + self.n_belt + 1
        self.single_observation_space = gymnasium.spaces.Box(
            low=-4, high=4, shape=(obs_dim,), dtype=np.float32
        )
        # MultiDiscrete setpoints: 7 pressure levels per zone, -60..+60 Pa
        # about nominal in 20 Pa steps. (A continuous Box head anti-trained
        # under pufferlib 3.0's PPO in every configuration we probed - env
        # verified stable at lr~0, good init degraded monotonically on both
        # cpu and mps learners - while the MultiDiscrete path is the one
        # every Ocean env exercises. Discrete levels also match real pump
        # setpoint control.)
        self.single_action_space = gymnasium.spaces.MultiDiscrete(
            [7] * n_zones
        )
        self.num_agents = num_agents
        super().__init__(buf)

        self.rng = np.random.default_rng(seed)
        self._build_optics()
        self._build_thermal()
        self.tick = 0

    # ------------------------------------------------------------- optics #
    def _build_optics(self):
        cfg = _sim.CFG
        cfg.a, cfg.dp, cfg.z_gap, cfg.r_pit = 1.65, 404.0, 1.23, 0.26
        cfg.r_window = None
        self.cfg = cfg
        self.p0 = float(cfg.dp)
        edges = (np.sqrt(np.linspace(0, 1, self.n_zones + 1)) * cfg.a)

        mem0 = _sim.solve_membrane(cfg, np.full(self.n_zones, self.p0),
                                   n=500, zone_edges=edges)
        r64 = mem0["r"]
        modes = []
        for k in range(self.n_zones):
            pz = np.full(self.n_zones, self.p0)
            pz[k] += 5.0
            mk = _sim.solve_membrane(cfg, pz, n=500, zone_edges=edges)
            modes.append(((mk["sp"] - mem0["sp"]) / 5.0).numpy())
        self.zone_edges = edges

        # fixed membrane point set (annulus), slope via baseline + modes
        z_f1 = mem0["z0"] + mem0["f_fit"]
        z_vertex = z_f1 - cfg.z_gap
        rho_parab = cfg.a * (z_f1 - z_vertex) / (z_f1 - mem0["w0"])
        r_sec = cfg.sec_margin * rho_parab
        cfg.r_window = ((r_sec * cfg.pivot_drop + cfg.r_pit * z_vertex)
                        / (z_vertex + cfg.pivot_drop) + 0.03)
        n = 44
        dev = self.device
        xy = torch.linspace(-cfg.a, cfg.a, n)
        X, Y = torch.meshgrid(xy, xy, indexing="ij")
        rr = torch.sqrt(X**2 + Y**2).reshape(-1)
        keep = (rr > max(r_sec, cfg.r_window)) & (rr < cfg.a * 0.985)
        self.px = X.reshape(-1)[keep].float().to(dev)
        self.py = Y.reshape(-1)[keep].float().to(dev)
        self.pr = rr[keep].float().to(dev)
        r32 = r64.float().to(dev)
        self.pz_sag = _sim.interp1d(self.pr, r32, mem0["s"].float().to(dev))
        self.sp0 = _sim.interp1d(self.pr, r32, mem0["sp"].float().to(dev))
        self.mode_sp = torch.stack([
            _sim.interp1d(self.pr, r32,
                          torch.tensor(m, dtype=torch.float32, device=dev))
            for m in modes
        ])  # [K, P]
        cell = float(xy[1] - xy[0]) ** 2
        self.ray_power0 = cell * cfg.rho_mem * cfg.rho_sec * cfg.T_window

        self.sec = _sim.Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec)
        self.sec.coeffs = self.sec.coeffs.to(dev)
        self.zc_oven = -cfg.pivot_drop - float(
            np.sqrt(cfg.R_oven**2 - cfg.r_pit**2)
        )
        self.ct_cut = float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2) / cfg.R_oven)

        # per-step constants, precomputed once (B and the point set are fixed)
        B, P = self.num_agents, self.pr.shape[0]
        self._inv_r = (1.0 / self.pr).expand(B, P)
        self._i3 = torch.tensor([0.0, 0.0, -1.0], device=dev).expand(B, P, 3)
        org = torch.stack(
            [self.px.expand(B, P), self.py.expand(B, P),
             self.pz_sag.expand(B, P)], dim=-1)
        self._o4 = torch.cat([org, torch.ones(B, P, 1, device=dev)],
                             -1).reshape(-1, 4)
        self._env_off = (torch.arange(B, device=dev) * self.n_nodes
                         ).repeat_interleave(P)
        self._oc = torch.tensor([0.0, 0.0, self.zc_oven], device=dev)
        self._ones_bp1 = torch.zeros(B, P, 1, device=dev)

    def _trace_power(self, dp_zones):
        """dp_zones [B, K] (actual pressures - p0) -> node powers [B, N] in
        watts per unit DNI (multiply by DNI outside). Runs on self.device."""
        B = dp_zones.shape[0]
        P = self.pr.shape[0]
        sp = self.sp0 + dp_zones.float().to(self.device) @ self.mode_sp
        n3 = torch.stack([
            -sp * self.px * self._inv_r[0], -sp * self.py * self._inv_r[0],
            torch.ones_like(sp)
        ], dim=-1)
        n3 = n3 * torch.rsqrt((n3 * n3).sum(-1, keepdim=True))
        i3 = self._i3
        d1 = i3 - 2 * (i3 * n3).sum(-1, keepdim=True) * n3
        o4 = self._o4
        d4 = torch.cat([d1, self._ones_bp1], -1).reshape(-1, 4)
        hit, n2, ok = self.sec.intersect(o4, d4)
        d2 = _sim.reflect(d4, n2)
        cfg = self.cfg
        tw = -hit[:, 2] / d2[:, 2].clamp(max=-1e-9)
        wpt = hit + tw[:, None] * d2
        tp = (-cfg.pivot_drop - hit[:, 2]) / d2[:, 2].clamp(max=-1e-9)
        ppit = hit + tp[:, None] * d2
        through = (
            ok & (d2[:, 2] < 0)
            & (wpt[:, 0] ** 2 + wpt[:, 1] ** 2 <= cfg.r_window**2)
            & (ppit[:, 0] ** 2 + ppit[:, 1] ** 2 <= cfg.r_pit**2)
        )
        q = ppit[:, :3] - self._oc
        b = (q * d2[:, :3]).sum(-1)
        c = (q * q).sum(-1) - cfg.R_oven**2
        ts = -b + torch.sqrt((b**2 - c).clamp(min=0))
        strike = ppit[:, :3] + ts[:, None] * d2[:, :3]
        ct = ((strike[:, 2] - self.zc_oven) / cfg.R_oven).clamp(-1, 1)
        phi = torch.atan2(strike[:, 1], strike[:, 0])
        rho_h = torch.sqrt(strike[:, 0] ** 2 + strike[:, 1] ** 2)
        # node index: hearth spot (bottom, within beam footprint radius),
        # floor rest (ct < -0.4), crown (ct > 0.55), else belt segment
        seg = ((phi + np.pi) / (2 * np.pi) * self.n_belt).long().clamp(
            0, self.n_belt - 1
        )
        node = torch.where(
            (ct < -0.4) & (rho_h < 0.28), torch.full_like(seg, self.n_belt),
            torch.where(
                ct < -0.4, torch.full_like(seg, self.n_belt + 1),
                torch.where(ct > 0.55,
                            torch.full_like(seg, self.n_belt + 2), seg),
            ),
        )
        w = self.ray_power0 * through.float()
        out = torch.zeros(B * self.n_nodes, device=self.device)
        out.index_put_((self._env_off + node,), w, accumulate=True)
        return out.reshape(B, self.n_nodes).cpu()

    # ------------------------------------------------------------ thermal #
    def _build_thermal(self):
        cfg = self.cfg
        R = cfg.R_oven
        # node areas on the sphere; hearth = beam footprint carved out of
        # the bottom cap
        a_belt = 2 * np.pi * R**2 * (0.55 + 0.4) / self.n_belt
        a_hearth = np.pi * 0.28**2
        a_floor = 2 * np.pi * R**2 * (1 - 0.4) - a_hearth
        a_crown = 2 * np.pi * R**2 * (self.ct_cut - 0.55)
        self.node_area = np.array(
            [a_belt] * self.n_belt + [a_hearth, a_floor, a_crown],
            dtype=np.float64,
        )
        # thin hot-face construction: 1.5 cm dense liner over insulating
        # backfill (k ~ 0.06 W/mK). We only need the SURFACE hot - the
        # liner reaches the cooking band in tens of minutes on ~5 kW, at
        # the price of less thermal buffering when clouds pass.
        self.node_heat_cap = self.node_area * 1900 * 880 * 0.015
        self.r_soil = 1.0 / (1.2 * self.node_area)  # fiber: 0.06/0.05 W/m2K
        self.a_ap = np.pi * cfg.r_pit**2

    # -------------------------------------------------------------- state #
    def _reset_state(self):
        B = self.num_agents
        self.t_solar = np.full(B, 8.0)
        # cold overnight start: the agent must run the preheat itself
        self.T = np.full((B, self.n_nodes), 350.0)
        self.T += self.rng.uniform(-15, 15, (B, self.n_nodes))
        self.p_cmd = np.zeros((B, self.n_zones))
        self.p_drift = np.zeros((B, self.n_zones))
        self.cloud = np.zeros(B)
        self.bread_E = np.zeros((B, self.n_belt))  # J absorbed, 0 = empty
        self.bread_t = np.zeros((B, self.n_belt))
        self.has_bread = np.zeros((B, self.n_belt), dtype=bool)
        self.load_timer = np.zeros(B)
        self.ep_rotis = np.zeros(B)
        self.ep_scorch = np.zeros(B)
        self.ep_return = np.zeros(B)
        self.ep_len = np.zeros(B)

    def _obs(self):
        h = (self.t_solar - 8.0) / 8.0
        obs = np.concatenate([
            np.stack([np.sin(np.pi * h), np.cos(np.pi * h),
                      self.dni / 1000.0], axis=1),
            self.T / 1000.0,
            (self.p_cmd + self.p_drift) / 60.0,
            self.bread_E / ROTI_ENERGY,
            self.p_in[:, None] / 6000.0,
        ], axis=1).astype(np.float32)
        return obs

    # ---------------------------------------------------------------- api #
    def reset(self, seed=None):
        if seed is not None:
            self.rng = np.random.default_rng(seed)
        self._reset_state()
        self.dni = np.full(self.num_agents, 700.0)
        self.p_in = np.zeros(self.num_agents)
        self.observations[:] = self._obs()
        return self.observations, [{}]

    def step(self, actions):
        B = self.num_agents
        a_idx = np.asarray(actions).reshape(B, self.n_zones)
        # absolute setpoint control (ARTIST-actuator style: positions, not
        # velocities); level 3 = nominal. The pump slews 3 Pa/step.
        target = (a_idx.astype(np.float64) - 3.0) * 20.0
        self.p_cmd += np.clip(target - self.p_cmd, -3.0, 3.0)
        a = (a_idx - 3.0) / 3.0  # for the effort-cost term
        # slow actuator drift the controller must fight (OU process)
        self.p_drift += (-self.p_drift / 600.0
                         + self.rng.normal(0, 0.35, (B, self.n_zones))
                         ) * self.dt / 15.0
        # sun + clouds (vectorized over envs)
        self.t_solar += self.dt / 3600.0
        phi = np.radians(self.lat)
        delta = np.radians(23.44) * np.sin(2 * np.pi * (284 + self.day) / 365)
        h = np.radians(15.0 * (self.t_solar - 12.0))
        sin_el = (np.sin(phi) * np.sin(delta)
                  + np.cos(phi) * np.cos(delta) * np.cos(h))
        el = np.degrees(np.arcsin(np.clip(sin_el, -1, 1)))
        am = 1.0 / np.clip(sin_el, 0.035, None)
        clear = np.where(el > 2.0, 1353.0 * 0.7 ** (am**0.678), 0.0)
        # OU cloud factor: stationary std 0.25 about clear sky, tau 900 s,
        # plus rare deep cloud events
        tau_c = 900.0
        self.cloud += (-self.cloud / tau_c * self.dt
                       + self.rng.normal(
                           0, 0.25 * np.sqrt(2 * self.dt / tau_c), B))
        deep = self.rng.random(B) < 0.0015 * self.dt / 15.0
        self.cloud[deep] -= 1.5
        self.cloud = np.clip(self.cloud, -3, 0.25)
        self.dni = clear * np.exp(self.cloud) * (el > 27.0)

        # optics: node powers
        with torch.no_grad():
            per_dni = self._trace_power(
                torch.tensor(self.p_cmd + self.p_drift)
            ).numpy()
        q_solar = per_dni * self.dni[:, None] * 0.85  # brick absorptivity
        self.p_in = per_dni.sum(1) * self.dni

        # thermal update on the thin hot-face liner
        T = self.T
        t4 = T**4
        t_cav4 = (self.node_area * t4).sum(1, keepdims=True) / self.node_area.sum()
        q_exch = 0.85 * SIGMA * self.node_area * (t_cav4 - t4)
        q_ap = 0.6 * SIGMA * (t_cav4.squeeze(1) - T_AMB**4) * self.a_ap
        q = q_solar + q_exch - (T - T_AMB) / self.r_soil
        q[:, self.n_belt + 2] -= q_ap  # crown node borders the aperture
        # bread sinks on belt nodes
        h_bread = 25.0 * 0.05  # W/K effective contact+radiation, 0.05 m^2
        q_b = self.has_bread * h_bread * (T[:, : self.n_belt] - 400.0)
        q[:, : self.n_belt] -= q_b
        self.T = T + q * self.dt / self.node_heat_cap
        self.bread_E += q_b * self.dt
        self.bread_t += self.has_bread * self.dt

        # bread lifecycle + reward
        rew = np.zeros(B)
        belt_T = self.T[:, : self.n_belt]
        cooked = self.has_bread & (self.bread_E >= ROTI_ENERGY)
        scorched = self.has_bread & (belt_T > T_SCORCH)
        doughy = self.has_bread & (self.bread_t > ROTI_TIMEOUT) & ~cooked
        rew += 5.0 * cooked.sum(1) - 5.0 * scorched.sum(1) - 0.5 * doughy.sum(1)
        self.ep_rotis += cooked.sum(1)
        self.ep_scorch += scorched.sum(1)
        done_bread = cooked | scorched | doughy
        self.has_bread &= ~done_bread
        self.bread_E[done_bread] = 0.0
        self.bread_t[done_bread] = 0.0
        # the cook loads the hottest free in-band segment every 45 s
        self.load_timer += self.dt
        want = self.load_timer >= 45.0
        ok_ = (~self.has_bread) & (belt_T >= T_COOK_LO) & (belt_T <= T_COOK_HI)
        can = np.nonzero(want & ok_.any(1))[0]
        j = np.argmax(np.where(ok_, belt_T, -np.inf), axis=1)
        self.has_bread[can, j[can]] = True
        self.load_timer[can] = 0.0
        # NOTE: dense power-based shaping was tried twice and reward-hacked
        # both times (overheat-and-farm, then park-below-threshold-and-farm).
        # Cooking events are plentiful (random play cooks ~95/day), so the
        # roti reward alone carries the gradient; keep only mild band
        # shaping and effort cost.
        belt_mean = belt_T.mean(1)
        rew -= 0.05 * np.clip(belt_mean - 690.0, 0, None) / 10.0
        rew -= 0.02 * ((belt_mean - 640.0) / 100.0) ** 2
        rew -= 0.005 * np.abs(a).sum(1)

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
                "episode_return": float(self.ep_return[day_over].mean()),
                "episode_length": float(self.ep_len[day_over].mean()),
            })
            idx = np.nonzero(day_over)[0]
            for i in idx:  # per-env auto-reset
                self.t_solar[i] = 8.0
                self.T[i] = 350.0 + self.rng.uniform(-15, 15, self.n_nodes)
                self.p_cmd[i] = 0.0
                self.p_drift[i] = 0.0
                self.cloud[i] = 0.0
                self.has_bread[i] = False
                self.bread_E[i] = 0.0
                self.bread_t[i] = 0.0
                self.load_timer[i] = 0.0
                self.ep_rotis[i] = self.ep_scorch[i] = 0.0
                self.ep_return[i] = self.ep_len[i] = 0.0
        self.observations[:] = self._obs()
        return (self.observations, self.rewards, self.terminals,
                self.truncations, infos)

    # ------------------------------------------------------------- render #
    def _ray_geometry(self, agent=0, n_rays=26):
        """Re-trace a thin fan for one agent with its live pump pressures:
        the ARTIST raytrace, drawn directly."""
        with torch.no_grad():
            dp = torch.tensor(
                self.p_cmd[agent] + self.p_drift[agent], dtype=torch.float32
            )[None].to(self.device)
            P = self.pr.shape[0]
            idx = torch.linspace(0, P - 1, n_rays, device=self.device).long()
            sp = (self.sp0 + dp @ self.mode_sp)[0, idx]
            px, py, pr_ = self.px[idx], self.py[idx], self.pr[idx]
            n3 = torch.stack(
                [-sp * px / pr_, -sp * py / pr_, torch.ones_like(sp)], -1)
            n3 = n3 / n3.norm(dim=-1, keepdim=True)
            i3 = torch.tensor([0.0, 0.0, -1.0],
                              device=self.device).expand(n_rays, 3)
            d1 = i3 - 2 * (i3 * n3).sum(-1, keepdim=True) * n3
            org3 = torch.stack([px, py, self.pz_sag[idx]], -1)
            one = torch.ones(n_rays, 1, device=self.device)
            hit, n2, ok = self.sec.intersect(
                torch.cat([org3, one], -1), torch.cat([d1, 0 * one], -1))
            d2 = _sim.reflect(torch.cat([d1, 0 * one], -1), n2)
            cfg = self.cfg
            tp = (-cfg.pivot_drop - hit[:, 2]) / d2[:, 2].clamp(max=-1e-9)
            ppit = hit + tp[:, None] * d2
            q = ppit[:, :3] - self._oc
            b = (q * d2[:, :3]).sum(-1)
            c = (q * q).sum(-1) - cfg.R_oven**2
            ts = -b + torch.sqrt((b**2 - c).clamp(min=0))
            strike = ppit[:, :3] + ts[:, None] * d2[:, :3]
        return [t.cpu().numpy() for t in
                (org3, hit[:, :3], ppit[:, :3], strike, ok)]

    @staticmethod
    def _heat_color(t_kelvin):
        f = float(np.clip((t_kelvin - 350.0) / 550.0, 0, 1))
        r = int(min(1.0, 2.2 * f) * 255)
        g = int(np.clip(1.8 * f - 0.5, 0, 1) * 255)
        b_ = int(np.clip(3.0 * f - 2.1, 0, 1) * 255)
        return (max(r, 25), max(g, 22), max(b_, 30), 255)

    def render(self):
        if self.render_mode == "ansi":
            bt = self.T[0, : self.n_belt]
            bar = "".join(" .:-=+*#%@"[int(np.clip(
                (t - 350) / 60, 0, 9))] for t in bt)
            return (f"t={self.t_solar[0]:5.2f}h DNI={self.dni[0]:4.0f} "
                    f"P={self.p_in[0]:4.0f}W hearth={self.T[0, 8]:4.0f}K "
                    f"belt[{bar}] rotis={self.ep_rotis[0]:.0f} "
                    f"scorch={self.ep_scorch[0]:.0f}")
        if self.render_mode != "human":
            return None
        import pyray as pr
        W, H = 1150, 720
        if not self._window:
            pr.init_window(W, H, "Solar Tandoor - ARTIST raytrace")
            pr.set_target_fps(30)
            self._window = True

        def sx(x):
            return int(280 + x * 46)

        def sy(z):
            return int(90 + (6.9 - z) * 46)

        pr.begin_drawing()
        pr.clear_background((16, 18, 26, 255))
        cfg = self.cfg
        # grade / crater / collar
        for sgn in (-1, 1):
            pts = [(-8, 0), (-2.4, 0), (-2.0, -0.75), (-0.41, -0.75),
                   (-0.41, 0), (-0.26, 0)]
            for (x0, z0), (x1, z1) in zip(pts, pts[1:]):
                pr.draw_line(sx(sgn * x0), sy(z0 - 1.6),
                             sx(sgn * x1), sy(z1 - 1.6), (90, 85, 78, 255))
        # oven wall arcs colored by node temps (west nodes left, east right)
        th = np.linspace(0, 2 * np.pi, 80)
        zc = self.zc_oven
        for k in range(len(th) - 1):
            zw = zc + cfg.R_oven * np.sin(th[k])
            if zw > -cfg.pivot_drop:
                continue
            xw = cfg.R_oven * np.cos(th[k])
            band = abs(zw - zc) < cfg.belt_half
            if band:
                node = 0 if xw < 0 else self.n_belt // 2
                col = self._heat_color(self.T[0, node])
                w = 6
            else:
                col = self._heat_color(self.T[0, 9]) if zw < zc else (
                    120, 90, 70, 255)
                w = 3
            x2 = cfg.R_oven * np.cos(th[k + 1])
            z2 = zc + cfg.R_oven * np.sin(th[k + 1])
            pr.draw_line_ex(pr.Vector2(sx(xw), sy(zw)),
                            pr.Vector2(sx(x2), sy(min(z2, -cfg.pivot_drop))),
                            w, col)
        # hearth glow
        pr.draw_circle(sx(0), sy(zc - cfg.R_oven + 0.06), 9,
                       self._heat_color(self.T[0, 8]))
        # membrane + secondary + pedestal
        xs = np.linspace(-cfg.a, cfg.a, 60)
        sag = np.interp(np.abs(xs), self.pr.cpu().numpy(),
                        self.pz_sag.cpu().numpy())
        for k in range(len(xs) - 1):
            pr.draw_line_ex(pr.Vector2(sx(xs[k]), sy(sag[k])),
                            pr.Vector2(sx(xs[k + 1]), sy(sag[k + 1])),
                            4, (70, 130, 220, 255))
        rs = np.linspace(-self.sec.rho_max, self.sec.rho_max, 30)
        zsec = self.sec.sag(torch.tensor(
            rs**2, dtype=torch.float32, device=self.device)).cpu().numpy()
        for k in range(len(rs) - 1):
            pr.draw_line_ex(pr.Vector2(sx(rs[k]), sy(zsec[k])),
                            pr.Vector2(sx(rs[k + 1]), sy(zsec[k + 1])),
                            4, (210, 70, 70, 255))
        pr.draw_line_ex(pr.Vector2(sx(0), sy(-1.6)), pr.Vector2(sx(0), sy(0)),
                        5, (95, 95, 100, 255))
        # the ARTIST raytrace, live
        org, hit, ppit, strike, ok = self._ray_geometry()
        dim = max(self.dni[0] / 950.0, 0.06)
        ray_col = (245, 180, 60, int(60 + 170 * dim))
        for i in range(len(org)):
            if not ok[i]:
                continue
            pr.draw_line(sx(org[i, 0]), sy(org[i, 2] + 3.2),
                         sx(org[i, 0]), sy(org[i, 2]), ray_col)
            pr.draw_line(sx(org[i, 0]), sy(org[i, 2]),
                         sx(hit[i, 0]), sy(hit[i, 2]), ray_col)
            pr.draw_line(sx(hit[i, 0]), sy(hit[i, 2]),
                         sx(ppit[i, 0]), sy(ppit[i, 2]), ray_col)
            pr.draw_line(sx(ppit[i, 0]), sy(ppit[i, 2]),
                         sx(strike[i, 0]), sy(strike[i, 2]), ray_col)
        # HUD: unrolled belt, pressures, counters
        pr.draw_text("belt (unrolled)", 700, 60, 18, (200, 200, 210, 255))
        for k in range(self.n_belt):
            col = self._heat_color(self.T[0, k])
            pr.draw_rectangle(700 + 52 * k, 90, 48, 60, col)
            if self.has_bread[0, k]:
                frac = self.bread_E[0, k] / ROTI_ENERGY
                pr.draw_circle(724 + 52 * k, 120, 12, (240, 225, 190, 255))
                pr.draw_circle(724 + 52 * k, 120, int(12 * min(frac, 1)),
                               (170, 110, 50, 255))
        pr.draw_text("zone pumps [Pa vs nominal]", 700, 180, 18,
                     (200, 200, 210, 255))
        for k in range(self.n_zones):
            v = float(self.p_cmd[0, k] + self.p_drift[0, k])
            h_ = int(v)
            pr.draw_rectangle(700 + 60 * k, 260 - max(h_, 0), 40, abs(h_) + 2,
                              (120, 190, 240, 255))
            pr.draw_text(f"{v:+.0f}", 700 + 60 * k, 270, 16,
                         (150, 150, 160, 255))
        hud = [
            f"solar time {self.t_solar[0]:5.2f} h",
            f"DNI {self.dni[0]:4.0f} W/m2",
            f"into oven {self.p_in[0]:5.0f} W",
            f"hearth {self.T[0, 8] - 273:4.0f} C",
            f"belt avg {self.T[0, :8].mean() - 273:4.0f} C",
            f"rotis {self.ep_rotis[0]:.0f}   scorched {self.ep_scorch[0]:.0f}",
        ]
        for j, line in enumerate(hud):
            pr.draw_text(line, 700, 330 + 26 * j, 20, (220, 220, 200, 255))
        pr.end_drawing()
        return None

    def close(self):
        if self._window:
            import pyray as pr
            pr.close_window()


if __name__ == "__main__":
    import time

    for B in (64, 512):
        env = TandoorEnv(num_agents=B)
        obs, _ = env.reset(seed=0)
        steps = 300
        acts = env.rng.integers(0, 7, (B, env.n_zones))
        env.step(acts)  # warm up kernels
        t0 = time.time()
        for _ in range(steps):
            env.step(acts)
        dt = time.time() - t0
        print(f"[{env.device}] B={B}: {steps * B / dt:.0f} agent-steps/s "
              f"({dt / steps * 1000:.1f} ms/step)")
    print(f"belt T sample [K]: {env.T[0, :8].round(0)}")
    print(f"power into oven, env 0: {env.p_in[0]:.0f} W at DNI "
          f"{env.dni[0]:.0f} W/m^2")

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
                 nurbs=0, flare_ratio=1.4, flare_reflect=0.9, buf=None):
        self.use_nurbs = bool(nurbs)
        self.flare_ratio = float(flare_ratio)
        self.flare_reflect = float(flare_reflect)
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
        modes, mem_ks = [], []
        for k in range(self.n_zones):
            pz = np.full(self.n_zones, self.p0)
            pz[k] += 5.0
            mk = _sim.solve_membrane(cfg, pz, n=500, zone_edges=edges)
            mem_ks.append(mk)
            modes.append(((mk["sp"] - mem0["sp"]) / 5.0).numpy())
        self.zone_edges = edges
        self._mem0, self._mem_ks = mem0, mem_ks

        # fixed membrane point set (annulus), slope via baseline + modes
        z_f1 = mem0["z0"] + mem0["f_fit"]
        z_vertex = z_f1 - cfg.z_gap
        rho_parab = cfg.a * (z_f1 - z_vertex) / (z_f1 - mem0["w0"])
        r_sec = cfg.sec_margin * rho_parab
        cfg.r_window = ((r_sec * cfg.pivot_drop + cfg.r_pit * z_vertex)
                        / (z_vertex + cfg.pivot_drop) + 0.03)
        n = 44
        dev = self.device
        self._r_keep_in = max(r_sec, cfg.r_window)
        xy = torch.linspace(-cfg.a, cfg.a, n)
        X, Y = torch.meshgrid(xy, xy, indexing="ij")
        rr = torch.sqrt(X**2 + Y**2).reshape(-1)
        keep = (rr > self._r_keep_in) & (rr < cfg.a * 0.985)
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
        self._loss_chain = cfg.rho_mem * cfg.rho_sec * cfg.T_window
        self._ray_pw = torch.full_like(self.pr, cell * self._loss_chain)

        if self.use_nurbs:
            self._build_nurbs_basis(cfg)

        self.sec = _sim.Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec)
        self.sec.coeffs = self.sec.coeffs.to(dev)
        self.zc_oven = -cfg.pivot_drop - float(
            np.sqrt(cfg.R_oven**2 - cfg.r_pit**2)
        )
        self.ct_cut = float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2) / cfg.R_oven)

        # ARTIST Sun: one distortion sample per ray per step gives an
        # unbiased stochastic sunshape at no extra ray count
        self._sun = _sim.Sun(number_of_rays=1, device=dev)

        # per-step constants, precomputed once (B and the point set are fixed)
        B, P = self.num_agents, self.pr.shape[0]
        self._inv_r = (1.0 / self.pr).expand(B, P)
        org = torch.stack(
            [self.px.expand(B, P), self.py.expand(B, P),
             self.pz_sag.expand(B, P)], dim=-1)
        self._o4 = torch.cat([org, torch.ones(B, P, 1, device=dev)],
                             -1).reshape(-1, 4)
        self._env_off = (torch.arange(B, device=dev) * self.n_nodes
                         ).repeat_interleave(P)
        self._oc = torch.tensor([0.0, 0.0, self.zc_oven], device=dev)
        self._zc_w = -float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
        self._oc_w = torch.tensor([0.0, 0.0, self._zc_w], device=dev)
        self._sun_R = torch.eye(3, device=dev)
        self._ones_bp1 = torch.zeros(B, P, 1, device=dev)

    def _build_nurbs_basis(self, cfg, eps=1e-4, delta=5.0):
        """Exact per-step ARTIST-NURBS geometry at RL speed.

        For fixed degree, knots, and evaluation points, the NURBS map is
        LINEAR in the control points. We therefore fit control-point z-modes
        per pump zone (through _sim.fit_nurbs, i.e. ARTIST's NURBSSurface),
        extract the point and FD-derivative basis matrices once by pushing
        unit z-control-vectors through ARTIST's evaluator, and per step the
        surface points and analytic-derivative normals reduce to matmuls in
        the z control points. No linearization of the surface itself: this
        IS the NURBS, evaluated exactly, for whatever ctrl-z the pressures
        imply."""
        cpu = torch.device("cpu")
        print("  [nurbs] fitting control-point modes (one-time)...")
        ctrl0, _ = _sim.fit_nurbs(cfg, self._mem0, epochs=1500,
                                  log_name="rl-base")
        zmodes = []
        for k, mk in enumerate(self._mem_ks):
            ck, _ = _sim.fit_nurbs(cfg, mk, ctrl_init=ctrl0, epochs=350,
                                   log_name=f"rl-zone{k}")
            zmodes.append(
                ((ck[..., 2] - ctrl0[..., 2]) / delta).reshape(-1))
        ncp = cfg.n_cp * cfg.n_cp
        n = 44
        uu = torch.linspace(1e-5, 1 - 1e-5 - eps, n)
        uv = torch.cartesian_prod(uu, uu)
        print("  [nurbs] extracting basis matrices (one-time)...")
        Bs, xyz = [], []
        for ee, nn_ in ((uv[:, 0], uv[:, 1]),
                        (uv[:, 0] + eps, uv[:, 1]),
                        (uv[:, 0], uv[:, 1] + eps)):
            surf = _sim.NURBSSurface(3, 3, ee, nn_, ctrl0.clone(), device=cpu)
            pts, _ = surf.calculate_surface_points_and_normals(device=cpu)
            xyz.append(pts[:, :3].clone())
            B = torch.zeros(len(ee), ncp)
            unit = ctrl0.clone().reshape(-1, 3)
            for i in range(ncp):
                u_i = unit.clone()
                u_i[:, 2] = 0.0
                u_i[i, 2] = 1.0
                surf.control_points = u_i.reshape(cfg.n_cp, cfg.n_cp, 3)
                p_i, _ = surf.calculate_surface_points_and_normals(device=cpu)
                B[:, i] = p_i[:, 2]
            Bs.append(B)
        x, y = xyz[0][:, 0], xyz[0][:, 1]
        xu, yu = (xyz[1][:, 0] - x) / eps, (xyz[1][:, 1] - y) / eps
        xv, yv = (xyz[2][:, 0] - x) / eps, (xyz[2][:, 1] - y) / eps
        du = float(uu[1] - uu[0])
        area = (xu * yv - xv * yu).abs() * du * du
        rr = torch.sqrt(x**2 + y**2)
        keep = (rr > self._r_keep_in) & (rr < cfg.a * 0.985)

        dev = self.device
        self.px, self.py, self.pr = (t[keep].to(dev) for t in (x, y, rr))
        self._ray_pw = (area[keep] * self._loss_chain).to(dev)
        cz0 = ctrl0[..., 2].reshape(-1)
        self.pz_sag = (Bs[0][keep] @ cz0).to(dev)
        self._cz0 = cz0.to(dev)
        self._zmodeM = torch.stack(zmodes).to(dev)          # [K, ncp]
        self._BzT = Bs[0][keep].T.contiguous().to(dev)      # [ncp, P]
        self._BuzT = ((Bs[1] - Bs[0])[keep] / eps).T.contiguous().to(dev)
        self._BvzT = ((Bs[2] - Bs[0])[keep] / eps).T.contiguous().to(dev)
        self._xu, self._yu = xu[keep].to(dev), yu[keep].to(dev)
        self._xv, self._yv = xv[keep].to(dev), yv[keep].to(dev)
        # keep slope arrays consistent for the render fan
        r32 = self._mem0["r"].float().to(dev)
        self.sp0 = _sim.interp1d(self.pr, r32, self._mem0["sp"].float().to(dev))
        self.mode_sp = torch.stack([
            _sim.interp1d(self.pr, r32,
                          ((mk["sp"] - self._mem0["sp"]) / delta)
                          .float().to(dev))
            for mk in self._mem_ks
        ])
        print(f"  [nurbs] per-step NURBS active: {int(keep.sum())} points, "
              f"{ncp} control points")

    def _trace_power(self, dp_zones):
        """dp_zones [B, K] (actual pressures - p0) -> node powers [B, N] in
        watts per unit DNI (multiply by DNI outside). Runs on self.device."""
        B = dp_zones.shape[0]
        P = self.pr.shape[0]
        dp32 = dp_zones.float().to(self.device)
        if self.use_nurbs:
            # exact ARTIST-NURBS surface for each agent's pressures:
            # points and derivative tangents are linear in ctrl-z
            ctrl_z = self._cz0 + dp32 @ self._zmodeM        # [B, ncp]
            z = ctrl_z @ self._BzT                          # [B, P]
            zu = ctrl_z @ self._BuzT
            zv = ctrl_z @ self._BvzT
            tu = torch.stack([self._xu.expand(B, P),
                              self._yu.expand(B, P), zu], dim=-1)
            tv = torch.stack([self._xv.expand(B, P),
                              self._yv.expand(B, P), zv], dim=-1)
            n3 = torch.linalg.cross(tu, tv)
            org = torch.stack([self.px.expand(B, P),
                               self.py.expand(B, P), z], dim=-1)
            o4 = torch.cat(
                [org, torch.ones(B, P, 1, device=self.device)], -1
            ).reshape(-1, 4)
        else:
            sp = self.sp0 + dp32 @ self.mode_sp
            n3 = torch.stack([
                -sp * self.px * self._inv_r[0],
                -sp * self.py * self._inv_r[0],
                torch.ones_like(sp)
            ], dim=-1)
            o4 = self._o4
        n3 = n3 * torch.rsqrt((n3 * n3).sum(-1, keepdim=True))
        n4 = torch.cat([n3, self._ones_bp1], -1)
        # incident rays from ARTIST's Sun distribution (sunshape cone about
        # nadir), reflected with ARTIST's reflect() at both bounces
        ds = self._sun.distribution.sample((B, P))
        i4 = torch.cat([
            ds, -torch.ones_like(self._ones_bp1), self._ones_bp1 * 0.0
        ], dim=-1)
        i4 = i4 * torch.rsqrt(
            (i4[..., :3] ** 2).sum(-1, keepdim=True)
        )
        d4 = _sim.reflect(i4, n4).reshape(-1, 4)
        hit, n2, ok = self.sec.intersect(o4, d4)
        d2 = _sim.reflect(d4, n2)
        cfg = self.cfg
        # window crossing in the ASSEMBLY frame (the clear disc rides the
        # tracked optic, which keeps the sun on-axis)
        tw = -hit[:, 2] / d2[:, 2].clamp(max=-1e-9)
        wpt = hit + tw[:, None] * d2
        rho_w = torch.sqrt(wpt[:, 0] ** 2 + wpt[:, 1] ** 2)
        okw = ok & (d2[:, 2] < 0) & (rho_w <= cfg.r_window)
        # pivot into the WORLD frame (the oven is earth-fixed): rotate about
        # F2 by the current sun position, then clip at the fixed pit mouth -
        # the beam sweeps the oven wall azimuthally through the day
        R3 = self._sun_R
        piv = torch.tensor([0.0, 0.0, -cfg.pivot_drop], device=self.device)
        wpt_w = (wpt[:, :3] - piv) @ R3.T
        d2_w = d2[:, :3] @ R3.T
        tp = -wpt_w[:, 2] / d2_w[:, 2].clamp(max=-1e-9)
        ppit = wpt_w + tp[:, None] * d2_w
        down = okw & (d2_w[:, 2] < 0)
        direct = down & (ppit[:, 0] ** 2 + ppit[:, 1] ** 2 <= cfg.r_pit**2)
        # flared reflective throat (tandoor-mouth chamfer): a 45-deg
        # polished cone from r_pit up to flare_ratio*r_pit catches rays
        # that would clip the rim at oblique entry and folds them down
        # through the throat with one extra reflection
        flare_w = torch.zeros(direct.shape, device=self.device)
        if self.flare_ratio > 1.0:
            h_f = (self.flare_ratio - 1.0) * cfg.r_pit
            xw, yw, zw = wpt_w[:, 0], wpt_w[:, 1], wpt_w[:, 2]
            dxw, dyw, dzw = d2_w[:, 0], d2_w[:, 1], d2_w[:, 2]
            a_c = dxw**2 + dyw**2 - dzw**2
            b_c = 2 * (xw * dxw + yw * dyw - (zw + cfg.r_pit) * dzw)
            c_c = xw**2 + yw**2 - (zw + cfg.r_pit) ** 2
            disc = (b_c**2 - 4 * a_c * c_c).clamp(min=0)
            sq = torch.sqrt(disc)
            t1 = (-b_c - sq) / (2 * a_c + 1e-12)
            t2 = (-b_c + sq) / (2 * a_c + 1e-12)
            zh1 = zw + t1 * dzw
            zh2 = zw + t2 * dzw
            v1 = (t1 > 1e-6) & (zh1 >= 0) & (zh1 <= h_f)
            v2 = (t2 > 1e-6) & (zh2 >= 0) & (zh2 <= h_f)
            tc = torch.where(v1, t1, t2)
            hitc = wpt_w + tc[:, None] * d2_w
            rho_c = torch.sqrt(
                hitc[:, 0] ** 2 + hitc[:, 1] ** 2
            ).clamp(min=1e-9)
            n_c = torch.stack([hitc[:, 0] / rho_c, hitc[:, 1] / rho_c,
                               -torch.ones_like(rho_c)], dim=-1)
            n_c = n_c / np.sqrt(2.0)
            d_r = d2_w - 2 * (d2_w * n_c).sum(-1, keepdim=True) * n_c
            tpit2 = -hitc[:, 2] / d_r[:, 2].clamp(max=-1e-9)
            p2 = hitc + tpit2[:, None] * d_r
            recovered = (
                down & ~direct & (v1 | v2) & (d_r[:, 2] < -1e-6)
                & (p2[:, 0] ** 2 + p2[:, 1] ** 2 <= cfg.r_pit**2)
            )
            ppit = torch.where(recovered[:, None], p2, ppit)
            d2_w = torch.where(recovered[:, None], d_r, d2_w)
            flare_w = recovered.float() * self.flare_reflect
        through = direct | (flare_w > 0)
        through_f = direct.float() + flare_w
        q = ppit - self._oc_w
        b = (q * d2[:, :3]).sum(-1)
        c = (q * q).sum(-1) - cfg.R_oven**2
        ts = -b + torch.sqrt((b**2 - c).clamp(min=0))
        strike = ppit + ts[:, None] * d2_w
        ct = ((strike[:, 2] - self._zc_w) / cfg.R_oven).clamp(-1, 1)
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
        w = self._ray_pw.expand(B, P).reshape(-1) * through_f
        if self.render_mode == "human":
            # stash agent 0's COMPLETE ray state from this exact trace so
            # the renderer shows the same rays that heat the oven. World-
            # frame points also come back to the assembly frame (inverse
            # pivot) for the cross-section polylines.
            sl = slice(0, P)
            ppit_asm = ppit[sl] @ R3 + piv
            strike_asm = strike[sl] @ R3 + piv
            self._last_rays = dict(
                org=o4[sl, :3].cpu().numpy(),
                inc=i4.reshape(-1, 4)[sl, :3].cpu().numpy(),
                hit=hit[sl, :3].cpu().numpy(),
                wpt=wpt[sl, :3].cpu().numpy(),
                ppit=ppit[sl].cpu().numpy(),
                ppit_asm=ppit_asm.cpu().numpy(),
                strike=strike[sl].cpu().numpy(),
                strike_asm=strike_asm.cpu().numpy(),
                ok=ok[sl].cpu().numpy(),
                okw=okw[sl].cpu().numpy(),
                through=through[sl].cpu().numpy(),
                w=w[sl].cpu().numpy(),
                R=R3.cpu().numpy(),
            )
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
        # the oven is world-fixed while the optic tracks: the beam enters
        # the pit rotated about the F2 pivot by the CURRENT sun position,
        # sweeping the wall through the day (envs are time-synchronized)
        el0, _, s_np = _sim.solar_position(self.lat, self.day,
                                           float(self.t_solar[0]))
        if el0 > 27.0:
            self._sun_R = _sim.rotation_z_to(s_np).to(self.device)
        else:
            self._sun_R = torch.eye(3, device=self.device)
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
            if n_rays >= P:
                idx = torch.arange(P, device=self.device)
            else:  # rotating random fan so the beam visibly shimmers
                idx = torch.sort(torch.randint(
                    0, P, (n_rays,), device=self.device)).values
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

    def _flux_maps(self, agent=0, n_az=48, n_ct=28, n_pit=36):
        """Flux fields accumulated from the step's ACTUAL ray tensors
        (sunshape samples included) - the live analogue of the design
        study's raymaps, EMA-smoothed across frames."""
        lr = getattr(self, "_last_rays", None)
        if lr is None:
            return np.zeros((n_ct, n_az)), np.zeros((n_pit, n_pit))
        cfg = self.cfg
        zc = self._zc_w
        ppit, strike = lr["ppit"], lr["strike"]
        pw = lr["w"] * self.dni[agent]  # rays that reach the oven wall
        ct = np.clip((strike[:, 2] - zc) / cfg.R_oven, -1, 1)
        phi = np.arctan2(strike[:, 1], strike[:, 0])
        wall, _, _ = np.histogram2d(
            ct, phi, bins=[n_ct, n_az],
            range=[[-1, self.ct_cut], [-np.pi, np.pi]], weights=pw)
        cell = cfg.R_oven**2 * (2 * np.pi / n_az) * ((1 + self.ct_cut) / n_ct)
        wall /= cell * 1000.0  # kW/m^2
        pit, _, _ = np.histogram2d(
            ppit[:, 0], ppit[:, 1], bins=n_pit,
            range=[[-0.3, 0.3], [-0.3, 0.3]], weights=pw)
        pit /= (0.6 / n_pit) ** 2 * 1000.0
        if not hasattr(self, "_wall_ema"):
            self._wall_ema, self._pit_ema = wall, pit
        self._wall_ema = 0.85 * self._wall_ema + 0.15 * wall
        self._pit_ema = 0.85 * self._pit_ema + 0.15 * pit
        return self._wall_ema, self._pit_ema

    @staticmethod
    def _flux_color(v, vmax):
        f = float(np.clip(v / max(vmax, 1e-6), 0, 1))
        # inferno-ish: black -> purple -> orange -> yellow
        r = int(np.clip(3.0 * f, 0, 1) * 255)
        g = int(np.clip(2.0 * f - 0.55, 0, 1) * 255)
        b_ = int((np.clip(1.2 * f, 0, 0.5) if f < 0.45
                  else np.clip(2.2 * f - 1.35, 0, 1)) * 255)
        return (r, g, b_, 255)

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
        W, H = 1400, 850
        if not self._window:
            pr.init_window(W, H, "Solar Tandoor - ARTIST raytrace (3D)")
            pr.set_target_fps(24)
            self._window = True
            self._cam_th, self._cam_ph, self._cam_r = 0.9, 0.38, 10.0

        # three.js-style orbit controls: left-drag rotates, wheel zooms
        if not hasattr(self, "_cam_tgt"):
            self._cam_tgt = np.array([0.0, 0.0, 1.2])
        if pr.is_mouse_button_down(0):
            d = pr.get_mouse_delta()
            self._cam_th -= d.x * 0.006
            self._cam_ph = float(np.clip(self._cam_ph + d.y * 0.006,
                                         -0.2, 1.45))
        if pr.is_mouse_button_down(1):  # right-drag pans the orbit target
            d = pr.get_mouse_delta()
            fwd = np.array([np.cos(self._cam_th), np.sin(self._cam_th)])
            right = np.array([fwd[1], -fwd[0]])
            self._cam_tgt[:2] += (right * d.x - fwd * d.y * np.sin(
                self._cam_ph)) * 0.004 * self._cam_r
            self._cam_tgt[2] += d.y * 0.004 * self._cam_r * np.cos(
                self._cam_ph)
            self._cam_tgt = np.clip(self._cam_tgt,
                                    [-6, -6, -3.2], [6, 6, 8])
        if pr.is_key_pressed(pr.KeyboardKey.KEY_R):
            self._cam_tgt = np.array([0.0, 0.0, 1.2])
            self._cam_th, self._cam_ph, self._cam_r = 0.9, 0.38, 10.0
        self._cam_r = float(np.clip(
            self._cam_r - pr.get_mouse_wheel_move() * 0.9, 1.2, 25.0))
        tgt = pr.Vector3(*[float(v) for v in self._cam_tgt])
        cp = pr.Vector3(
            tgt.x + self._cam_r * np.cos(self._cam_ph) * np.cos(self._cam_th),
            tgt.y + self._cam_r * np.cos(self._cam_ph) * np.sin(self._cam_th),
            tgt.z + self._cam_r * np.sin(self._cam_ph))
        cam = pr.Camera3D(cp, tgt, pr.Vector3(0.0, 0.0, 1.0), 45.0,
                          pr.CameraProjection.CAMERA_PERSPECTIVE)

        dim = float(np.clip(self.dni[0] / 950.0, 0.04, 1.0))
        lr = getattr(self, "_last_rays", None)
        cfg = self.cfg
        Rm = lr["R"] if lr is not None else np.eye(3)
        piv = np.array([0.0, 0.0, -cfg.pivot_drop])

        def w3(p_asm):
            return (p_asm - piv) @ Rm.T

        def v3(p):
            return pr.Vector3(float(p[0]), float(p[1]), float(p[2]))

        def ring(c, r, col, n=40, frame=None):
            th_ = np.linspace(0, 2 * np.pi, n + 1)
            pts = np.stack([c[0] + r * np.cos(th_), c[1] + r * np.sin(th_),
                            np.full(n + 1, c[2])], 1)
            if frame is not None:
                pts = (pts - piv) @ frame.T
            for k in range(n):
                pr.draw_line_3d(v3(pts[k]), v3(pts[k + 1]), col)

        pr.begin_drawing()
        pr.clear_background((int(10 + 26 * dim), int(12 + 32 * dim),
                             int(20 + 52 * dim), 255))
        pr.begin_mode_3d(cam)
        # ground, crater, pit mouth (world-fixed)
        for r_, col in ((3.2, (60, 62, 74, 255)), (2.5, (70, 66, 60, 255)),
                        (cfg.r_pit, (150, 110, 80, 255)),
                        (self.flare_ratio * cfg.r_pit, (110, 85, 65, 255))):
            ring(np.array([0, 0, 0.0]), r_, col)
        # oven sphere wireframe + belt nodes colored by temperature
        zc = self._zc_w
        for zoff in (-0.45, -0.25, 0.25, 0.45):
            zw = zc + zoff * cfg.R_oven / 0.6
            rw = np.sqrt(max(cfg.R_oven**2 - (zw - zc) ** 2, 1e-4))
            ring(np.array([0, 0, zw]), rw, (95, 70, 58, 255), 32)
        # meridians so the cavity reads as a closed sphere
        th_m = np.linspace(np.arccos(self.ct_cut), np.pi, 14)
        for am in np.linspace(0, 2 * np.pi, 8, endpoint=False):
            pts_m = np.stack([
                cfg.R_oven * np.sin(th_m) * np.cos(am),
                cfg.R_oven * np.sin(th_m) * np.sin(am),
                zc + cfg.R_oven * np.cos(th_m)], 1)
            for j in range(len(pts_m) - 1):
                pr.draw_line_3d(v3(pts_m[j]), v3(pts_m[j + 1]),
                                (85, 62, 52, 255))
        # mouth throat + flare funnel (world-fixed at grade)
        h_fl = (self.flare_ratio - 1.0) * cfg.r_pit
        ring(np.array([0, 0, h_fl]), self.flare_ratio * cfg.r_pit,
             (170, 125, 90, 255), 24)
        for am in np.linspace(0, 2 * np.pi, 8, endpoint=False):
            ca, sa = np.cos(am), np.sin(am)
            pr.draw_line_3d(
                v3([cfg.r_pit * ca, cfg.r_pit * sa, 0]),
                v3([self.flare_ratio * cfg.r_pit * ca,
                    self.flare_ratio * cfg.r_pit * sa, h_fl]),
                (170, 125, 90, 255))
        for k in range(self.n_belt):
            a0 = -np.pi + 2 * np.pi * k / self.n_belt
            th_ = np.linspace(a0, a0 + 2 * np.pi / self.n_belt, 8)
            col = self._heat_color(self.T[0, k])
            for zoff in (-0.6 * cfg.belt_half, 0.0, 0.6 * cfg.belt_half):
                zw = zc + zoff
                rw = np.sqrt(cfg.R_oven**2 - (zw - zc) ** 2)
                for j in range(7):
                    pr.draw_line_3d(
                        v3([rw * np.cos(th_[j]), rw * np.sin(th_[j]), zw]),
                        v3([rw * np.cos(th_[j + 1]),
                            rw * np.sin(th_[j + 1]), zw]), col)
            if self.has_bread[0, k]:
                am = a0 + np.pi / self.n_belt
                fr_ = min(self.bread_E[0, k] / ROTI_ENERGY, 1)
                rw = np.sqrt(cfg.R_oven**2 - 0.0) * 0.97
                pr.draw_sphere(v3([rw * np.cos(am), rw * np.sin(am), zc]),
                               0.05 + 0.02 * fr_, (200, 165, 110, 255))
        pr.draw_sphere(v3([0, 0, zc - cfg.R_oven * 0.95]), 0.09,
                       self._heat_color(self.T[0, 8]))
        # tracked assembly wireframe (membrane, secondary, pedestal) in world
        pr_np = self.pr.cpu().numpy()
        order = np.argsort(pr_np)
        rs_, zs_ = pr_np[order], self.pz_sag.cpu().numpy()[order]
        for rr_ in np.linspace(rs_[0], rs_[-1], 5):
            zz = float(np.interp(rr_, rs_, zs_))
            ring(np.array([0, 0, zz]), rr_, (90, 150, 235, 255), 36, Rm)
        for aa in np.linspace(0, 2 * np.pi, 12, endpoint=False):
            pts = np.stack([np.cos(aa) * rs_[::90], np.sin(aa) * rs_[::90],
                            zs_[::90]], 1)
            pw_ = w3(pts)
            for j in range(len(pw_) - 1):
                pr.draw_line_3d(v3(pw_[j]), v3(pw_[j + 1]),
                                (90, 150, 235, 255))
        sec_r = np.linspace(0, self.sec.rho_max, 4)[1:]
        for rr_ in sec_r:
            zz = float(self.sec.sag(torch.tensor(
                [rr_**2], dtype=torch.float32, device=self.device)).cpu()[0])
            ring(np.array([0, 0, zz]), rr_, (225, 80, 80, 255), 28, Rm)
        z_edge = float(self.sec.sag(torch.tensor(
            [self.sec.rho_max**2], dtype=torch.float32,
            device=self.device)).cpu()[0])
        z_v0 = float(self.sec.sag(torch.tensor(
            [0.0], dtype=torch.float32, device=self.device)).cpu()[0])
        for aa in np.linspace(0, 2 * np.pi, 8, endpoint=False):
            pw_ = w3(np.array([
                [0.0, 0.0, z_v0],
                [self.sec.rho_max * np.cos(aa),
                 self.sec.rho_max * np.sin(aa), z_edge]]))
            pr.draw_line_3d(v3(pw_[0]), v3(pw_[1]), (225, 80, 80, 255))
        # clear window marked on the membrane (the oven "lid")
        zw_ = float(np.interp(cfg.r_window, rs_, zs_))
        ring(np.array([0, 0, zw_]), cfg.r_window, (120, 220, 235, 255),
             36, Rm)
        pr.draw_line_3d(v3(w3(np.array([0, 0, -cfg.pivot_drop]))),
                        v3(w3(np.array([0, 0, 0.0]))), (120, 120, 130, 255))
        # EVERY ray from the step's actual trace, additive so density = flux
        if lr is not None:
            pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
            a_hi = int(3 + 22 * dim)
            col_beam = (120, 88, 30, a_hi)
            col_in = (60, 52, 30, max(a_hi // 2, 2))
            col_blk = (140, 40, 28, 90)
            org_w, hit_w, wpt_w = (w3(lr[k]) for k in ("org", "hit", "wpt"))
            sun_dir = Rm @ np.array([0, 0, 1.0])
            for i in range(len(org_w)):
                if not lr["ok"][i]:
                    continue
                o, h_ = org_w[i], hit_w[i]
                pr.draw_line_3d(v3(o + 3.5 * sun_dir), v3(o), col_in)
                pr.draw_line_3d(v3(o), v3(h_), col_beam)
                if lr["okw"][i]:
                    pp = lr["ppit"][i]
                    pr.draw_line_3d(v3(h_), v3(pp), col_beam)
                    if lr["through"][i]:
                        pr.draw_line_3d(v3(pp), v3(lr["strike"][i]), col_beam)
                    else:
                        pr.draw_line_3d(v3(pp), v3(pp + [0, 0, 0.04]),
                                        col_blk)
                else:
                    wa = lr["wpt"][i]
                    if wa[0] ** 2 + wa[1] ** 2 <= cfg.a**2:
                        wp = wpt_w[i]  # dies on the aluminized membrane back
                        pr.draw_line_3d(v3(h_), v3(wp), col_beam)
                        pr.draw_line_3d(v3(wp), v3(wp + 0.03 * sun_dir),
                                        col_blk)
            pr.end_blend_mode()
        pr.end_mode_3d()

        # 2D HUD overlays: live flux fields + state
        wall, pit = self._flux_maps()
        vmax_w = max(wall.max(), 5.0)
        pr.draw_text(f"wall flux (peak {wall.max():.0f} kW/m2)", 1020, 14,
                     16, (200, 200, 210, 255))
        for i in range(wall.shape[0]):
            for j in range(wall.shape[1]):
                pr.draw_rectangle(1020 + j * 7, 36 + (wall.shape[0] - 1 - i)
                                  * 5, 7, 5, self._flux_color(wall[i, j],
                                                              vmax_w))
        for ct_b in (-cfg.belt_half, cfg.belt_half):
            yy = 36 + int((1 - (ct_b / cfg.R_oven + 1) / (1 + self.ct_cut))
                          * wall.shape[0]) * 5
            pr.draw_line(1020, yy, 1020 + wall.shape[1] * 7, yy,
                         (90, 200, 110, 200))
        vmax_p = max(pit.max(), 5.0)
        pr.draw_text(f"pit waist (peak {pit.max():.0f} kW/m2)", 1020, 190,
                     16, (200, 200, 210, 255))
        for i in range(pit.shape[0]):
            for j in range(pit.shape[1]):
                pr.draw_rectangle(1020 + i * 4, 212 + j * 4, 4, 4,
                                  self._flux_color(pit[i, j], vmax_p))
        for k in range(self.n_belt):
            pr.draw_rectangle(1020 + 40 * k, 370, 37, 26,
                              self._heat_color(self.T[0, k]))
            pr.draw_text(f"{self.T[0, k] - 273:.0f}", 1024 + 40 * k, 376, 13,
                         (235, 235, 235, 255))
        for k in range(self.n_zones):
            v = float(self.p_cmd[0, k] + self.p_drift[0, k])
            pr.draw_rectangle(1020 + 44 * k, 450 - max(int(v // 2), 0), 30,
                              abs(int(v // 2)) + 2, (120, 190, 240, 255))
        el_now, _, _ = _sim.solar_position(self.lat, self.day,
                                           float(self.t_solar[0]))
        hud = [
            f"solar {self.t_solar[0]:5.2f} h   el {el_now:.0f} deg   "
            f"day {np.clip((self.t_solar[0] - 8) / 8, 0, 1) * 100:.0f}%",
            f"DNI {self.dni[0]:4.0f} W/m2   into oven {self.p_in[0]:5.0f} W",
            f"hearth {self.T[0, 8] - 273:4.0f} C   belt avg "
            f"{self.T[0, :8].mean() - 273:4.0f} C",
            f"rotis {self.ep_rotis[0]:.0f}   scorched {self.ep_scorch[0]:.0f}",
        ]
        for j, line in enumerate(hud):
            pr.draw_text(line, 1020, 500 + 26 * j, 18, (225, 225, 205, 255))
        pr.draw_text("left-drag: orbit   right-drag: pan   wheel: zoom   "
                     "R: reset   world frame, oven fixed, assembly tracks "
                     "the sun", 20, H - 28, 16, (150, 150, 165, 255))
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

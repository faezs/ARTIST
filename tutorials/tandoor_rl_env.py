"""
TandoorEnv v2 "field-real": the buildable redesign of the pump-membrane
beam-down tandoor as a native PufferLib environment, with the mechanical
and optical effects the v1 sim hazed over (per the expert panel review)
modeled explicitly.

THE REDESIGNED PLANT (panel-driven):
  - SINGLE plenum: pressure is the focus/throttle knob only. The 7 action
    levels map to 7 exact FvK solves done at init - no pressure->shape
    linearization remains (zone plenums were unbuildable: partition rings
    print scattering kinks, gap seals leak ~170 L/s).
  - Fixed best-effort aspheric secondary (optimized once at init against
    the nominal shape), de-rated by fabrication slope error.
  - Rigid glass window over the pit collar (T=0.90, cleanable) - the
    structural clear-PET window died at its glass transition in review.
  - Side-loading port with INTERLOCKED SHUTTER (second action head):
    the cook can only load while the shutter is closed (beam dumped), so
    admitting bread costs cooking flux - a real scheduling tradeoff.
  - Auto-stow above the wind limit (9 m/s, hysteresis to 7).

THE FORMERLY-HAZED-OVER PHYSICS, NOW IN THE LOOP:
  - Wind: diurnal + OU gust process driving slope ripple, boresight
    buffet and stow events. The slope law is now MEASURED by the generic
    2-D FvK solver (membrane_fvk2d.py / fvk2d_cassegrain.py): 0.88 mrad
    at 5 m/s, sublinear in q. The q*a/2T hand estimate this file used to
    carry overstated it ~2.5x and was largely responsible for how badly
    the beam-down scored.
  - Surface figure: 2.5 mrad RMS membrane slope error (orange peel, clamp
    scalloping, seam) + 1.5 mrad secondary fabrication error, doubled on
    reflection; circumsolar tail (8% of rays at sigma 15 mrad, Buie-ish).
  - Reflectance honesty: rho_mem 0.90 with rim-thinning profile from the
    deposition physics, rho_sec 0.88, glass 0.90, all times a per-episode
    soiling factor (0.85-1.0, unwashable-film reality).
  - Boresight: OU pointing wander (EFL ~ 27 m -> ~40 mm sigma at the pit)
    plus a deterministic flexure offset growing with tilt; observed by the
    agent as collar quadrant-sensor signals.
  - Plenum thermodynamics: insolation-correlated pressure disturbance
    (sealed gas ~300 Pa/K) replacing the ad-hoc actuator drift.
  - Liner thermal shock: hearth heating faster than ~25 K/step is a spall
    event (penalized) - ramp-rate limiting via defocus is a skill.
  - Degraded flare throat (0.6 semi-specular, weeks-old, not 0.9 new).

Actions: MultiDiscrete([7, 2]) = pressure level, shutter open/closed.
Episode: one cooking day (08:00-16:00 solar, dt = 15 s -> 1920 steps).

Run `python tutorials/tandoor_rl_env.py` for a benchmark.
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
# the REAL bakery loads from 180 C (user): the gate is physical
# permission, not judgment - economics (doughy, char, beam service)
# decide what is worth loading
T_COOK_LO, T_COOK_HI, T_SCORCH = 453.0, 700.0, 730.0  # K
# 560 K = 287 C wall: real tandoor range; the ideal-optics design
# used a conservative 580 that the honest plant cannot hold
ROTI_ENERGY = 45e3  # J to cook one roti
# (the old ROTI_TIMEOUT doughy rule is gone: a roti comes off only
# when cooked or charred - user call)

_U32 = 0xFFFFFFFF


def cook_bin(x, y, z, nb):
    """Which bin gets loaf z at tick y in env x: the cook's habit as
    a hash (user-supplied xor hash, kept integer-exact - the float
    step is dropped so numpy/torch/Metal agree BIT for bit; uint32
    wraparound semantics, masked at every op). The bin comes from the
    HIGH bits via (v*nb)>>31 - the float original divides by 2^30
    for the same reason: this hash's low bits are structured (v is
    always odd; a plain %8 put 62.5% of loaves in one bin)."""
    x = np.asarray(x, dtype=np.uint64)
    s = (x + np.uint64(y) * np.uint64(57)
         + np.uint64(z) * np.uint64(241)) & np.uint64(_U32)
    s = ((s << np.uint64(13)) ^ s) & np.uint64(_U32)
    t = ((s * s) & np.uint64(_U32)) * np.uint64(15731) \
        + np.uint64(789221)
    v = (s * (t & np.uint64(_U32))
         + np.uint64(1376312589)) & np.uint64(0x7FFFFFFF)
    return ((v * np.uint64(nb)) >> np.uint64(31)).astype(np.int64)


class TandoorEnv(pufferlib.PufferEnv):
    """Natively vectorized: one instance simulates ``num_agents`` tandoors."""

    N_LEVELS = 7  # pressure setpoints, exact FvK shapes precomputed
    N_HEADS = 2   # subclasses may add heads (polar adds jam/release)
    N_EXTRA_OBS = 0

    def __init__(self, num_agents=32, n_zones=5, dt=15.0, lat=28.6,
                 day_of_year=80, day_random=0, lat_random=0, seed=0,
                 device=None, render_mode=None,
                 nurbs=0, flare_ratio=1.4, flare_reflect=0.6,
                 sigma_surf=2.0e-3, sigma_fab=1.5e-3, csr_frac=0.08,
                 wind_limit=9.0, wide_shutter=0, warm_frac=0.5,
                 z_gap=2.6, r_pit=0.42, pivot_drop=1.6, a_mem=2.45,
                 wall_obs=None, insulation=0, load_period=45.0,
                 loaves_per_load=1, roti_kj=45.0, bread_area=0.05,
                 buf=None):
        # design levers for the 900/day campaign (defaults = current).
        # Ground truth from the real oven: up to 9-10 loaves cook
        # SIMULTANEOUSLY, Afghani-naan sized (~120-140 kJ each, ~3x
        # the generic small roti this env grew up with).
        self.insulation = bool(insulation)
        self.load_period = float(load_period)
        self.loaves_per_load = int(loaves_per_load)
        self.roti_energy = float(roti_kj) * 1e3
        self.h_bread = 25.0 * float(bread_area)
        self.bread_area = float(bread_area)
        # spot_bread (set by the polar retrofit): the elbow's flux
        # lands ON the loaf at the lit station; default off here
        self.spot_bread = getattr(self, "spot_bread", 0)
        # wall_obs=0 drops the 3 buried-thermocouple channels so
        # checkpoints trained before the honest-wall obs (33-dim) load.
        # Settable via env var (pufferlib's CLI only forwards known ini
        # keys):  TANDOOR_WALL_OBS=0 puffer eval puffer_hashemi ...
        import os
        _ev = os.environ.get("TANDOOR_WALL_OBS")
        if _ev is not None:
            wall_obs = int(_ev)      # env var beats ini/kwarg: the
        elif wall_obs is None:       # ini always forwards its value,
            wall_obs = 1             # so the var must outrank it
        self.wall_obs = bool(wall_obs)
        # TANDOOR_RENDER=human opens the exact renderer under
        # `puffer eval` (the ini carries no render_mode key)
        if render_mode is None:
            render_mode = os.environ.get("TANDOOR_RENDER")
        self.g_zgap, self.g_rpit = float(z_gap), float(r_pit)
        self.g_pivot, self.g_a = float(pivot_drop), float(a_mem)
        self.warm_frac = float(warm_frac)
        self.wide_shutter = bool(wide_shutter)
        self.flare_ratio = float(flare_ratio)
        self.flare_reflect = float(flare_reflect)
        self.sigma_surf = float(sigma_surf)
        self.sigma_fab = float(sigma_fab)
        self.csr_frac = float(csr_frac)
        self.wind_limit = float(wind_limit)
        if device is None:
            device = "mps" if torch.backends.mps.is_available() else "cpu"
        self.device = torch.device(device)
        self.render_mode = render_mode
        self._window = False
        self.n_zones = n_zones
        self.dt = dt
        self.lat = lat
        self.day = day_of_year
        # PER-ENV SUN: every env its own day and site. The scalars
        # above stay as env-0 mirrors for render/eval consumers.
        self.day_v = np.full(num_agents, float(day_of_year))
        self.lat_v = np.full(num_agents, float(lat))
        # day_random=1 draws a fresh day-of-year each dawn. A fixed day
        # lets the LSTM memorize THE solar trajectory against its clock
        # and track semi-open-loop - and day 80 never exceeds el 61.4,
        # so the slot/crossing regime above 65 deg goes completely
        # untrained. Found auditing the eval suite, after 1.4B steps of
        # training on one identical day.
        self.day_random = bool(day_random)
        # lat_random=1 draws a fresh site latitude each dawn (15-35 N) -
        # a policy must track the sun, not a memorized site geometry
        self.lat_random = bool(lat_random)
        self.n_belt = 8
        # nodes: belt segments + hearth spot (beam footprint) + floor rest
        # + crown. The tiny hearth node runs ~800 K and does the radiating
        # (T^4: a small glowing spot beats the same power smeared wide).
        self.n_nodes = self.n_belt + 3 \
            + getattr(self, "n_extra_nodes", 0)
        # obs: [sin t, cos t, dni] + node temps + [pressure lvl, shutter,
        # wind, boresight qx, boresight qy] + bread progress + [p_in]
        obs_dim = (3 + self.n_nodes + (3 if self.wall_obs else 0)
                   + 6 + 2 * self.n_belt + 1 + self.N_EXTRA_OBS)
        self.single_observation_space = gymnasium.spaces.Box(
            low=-4, high=4, shape=(obs_dim,), dtype=np.float32
        )
        # [pressure level 0-6 (defocus-dump .. over-focus), shutter 0/1].
        # MultiDiscrete: pufferlib 3.0's continuous head anti-trains.
        # wide_shutter=1 makes both heads width-7 (shutter = a1 > 3):
        # probe for pufferlib 3.0's unequal-nvec -inf padding pathology
        # equal head widths always: pufferlib 3.0 NaNs on unequal nvec
        self.single_action_space = gymnasium.spaces.MultiDiscrete(
            [self.N_LEVELS] * self.N_HEADS if self.wide_shutter
            else [self.N_LEVELS] + [2] * (self.N_HEADS - 1)
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
        # GEOMETRY REDESIGN (beamdown_sweep*.py): blur lever is
        # EFL = f1*(z_vertex+pivot)/z_gap while secondary shadow is
        # (z_gap/f1)^2. The original z_gap=1.23 minimised shadow (4%) at
        # a ~39 m lever and NEVER reached the cooking band from cold.
        # Paying 14% shadow for a 3x shorter lever returns 13x the rotis;
        # a 4.9 m dish then clears 500/day cold (5.6 m gives ~541).
        cfg.a, cfg.dp = self.g_a, 404.0
        cfg.z_gap, cfg.r_pit = self.g_zgap, self.g_rpit
        cfg.pivot_drop = self.g_pivot
        cfg.r_window = None
        self.cfg = cfg
        self.p0 = float(cfg.dp)
        dev = self.device

        # 7 pressure setpoints from deep-defocus dump to over-focus;
        # each is an EXACT FvK solve - no linearization anywhere
        self.level_frac = np.array([0.70, 0.82, 0.90, 0.96, 1.00, 1.04,
                                    1.10])
        mems = [_sim.solve_membrane(cfg, self.p0 * f, n=500)
                for f in self.level_frac]
        mem0 = mems[4]  # nominal: the level the secondary is designed for
        self._mem0 = mem0

        z_f1 = mem0["z0"] + mem0["f_fit"]
        z_vertex = z_f1 - cfg.z_gap
        rho_parab = cfg.a * (z_f1 - z_vertex) / (z_f1 - mem0["w0"])
        r_sec = cfg.sec_margin * rho_parab
        cfg.r_window = ((r_sec * cfg.pivot_drop + cfg.r_pit * z_vertex)
                        / (z_vertex + cfg.pivot_drop) + 0.03)
        self._r_keep_in = max(r_sec, cfg.r_window)

        # fixed membrane point set (annulus)
        n = 44
        xy = torch.linspace(-cfg.a, cfg.a, n)
        X, Y = torch.meshgrid(xy, xy, indexing="ij")
        rr = torch.sqrt(X**2 + Y**2).reshape(-1)
        keep = (rr > self._r_keep_in) & (rr < cfg.a * 0.985)
        self.px = X.reshape(-1)[keep].float().to(dev)
        self.py = Y.reshape(-1)[keep].float().to(dev)
        self.pr = rr[keep].float().to(dev)
        r32 = mem0["r"].float().to(dev)
        self.sp_levels = torch.stack([
            _sim.interp1d(self.pr, r32, m["sp"].float().to(dev))
            for m in mems
        ])  # [L, P]
        self.z_levels = torch.stack([
            _sim.interp1d(self.pr, r32, m["s"].float().to(dev))
            for m in mems
        ])
        self.pz_sag = self.z_levels[4]
        # ARTIST: NURBS membrane (points AND normals from the spline) +
        # Sun cone + reflect, replacing the sag-table interpolation and
        # the synthesised [-slope*x/r, -slope*y/r, 1] normal.
        # sp_levels/z_levels stay for the renderer and diagnostics.
        import tandoor_artist_optics as AO
        self.AO = AO
        self.primary = AO.MembranePrimary(
            _sim, cfg, mems, self.px, self.py, dev,
            tag=f"beamdown{cfg.a:.2f}g{cfg.z_gap:.2f}",
            csr_frac=self.csr_frac, csr_sigma=15e-3)
        self.pl_z0 = AO.make_plane("z0", [0.0, 0.0, 0.0], [0.0, 0.0, 1.0],
                                   8.0, 8.0, dev)

        # honest reflectance chain: fresh Al 0.90 with rim-thinning from
        # the deposition physics, secondary 0.88, rigid glass window 0.90;
        # per-episode soiling multiplies on top (see _reset_state)
        cell = float(xy[1] - xy[0]) ** 2
        rho_mem_r = 0.90 * (1.0 - 0.10 * (self.pr / cfg.a) ** 4)
        self._loss_chain = 0.88 * 0.90
        self._ray_pw = cell * rho_mem_r * self._loss_chain

        # fixed best-effort aspheric secondary, optimized once at init
        # against the nominal shape (fabrication error enters as blur)
        self.sec = _sim.Secondary(z_f1, -cfg.pivot_drop, z_vertex, r_sec)
        pts_o, nrm_o, _ = _sim.analytic_membrane_points(
            cfg, mem0, self._r_keep_in)
        coeffs, rms_a = _sim.optimize_asphere(
            cfg, pts_o, nrm_o, self.sec, mode="point", iters=250)
        print(f"  [v2 optics] init asphere waist {rms_a:.1f} mm; "
              f"7 exact FvK levels; chain rim rho "
              f"{float(rho_mem_r.min()):.2f}")
        self.sec.coeffs = self.sec.coeffs.to(dev)
        self.zc_oven = -cfg.pivot_drop - float(
            np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
        self.ct_cut = float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2)
                            / cfg.R_oven)
        H_cl = cfg.pivot_drop + mem0["w0"] - cfg.rim_drop
        theta_max = float(np.degrees(
            np.arctan2(H_cl, cfg.a)
            + np.arcsin(np.clip(cfg.crater_depth / np.hypot(cfg.a, H_cl),
                                -1, 1))))
        self.el_min = max(90.0 - theta_max, 8.0)
        print(f"  [mount] rim-clearance tilt limit {theta_max:.0f} deg "
              f"-> tracks only above el {self.el_min:.0f} deg")
        self.sigma_sun = float(np.sqrt(4.3681e-06))  # ARTIST Sun default

        # per-step constants
        B, P = self.num_agents, self.pr.shape[0]
        self._inv_r = (1.0 / self.pr).expand(B, P)
        self._env_off = (torch.arange(B, device=dev) * self.n_nodes
                         ).repeat_interleave(P)
        self._oc = torch.tensor([0.0, 0.0, self.zc_oven], device=dev)
        self._zc_w = -float(np.sqrt(cfg.R_oven**2 - cfg.r_pit**2))
        self._oc_w = torch.tensor([0.0, 0.0, self._zc_w], device=dev)
        self._sun_R = torch.eye(3, device=dev)
        self._ones_bp1 = torch.zeros(B, P, 1, device=dev)

    def _trace_power(self, p_act, sigma_b, offset_w, soil):
        """p_act [B] plenum pressure (Pa) -> node powers [B, N] per unit
        DNI. Shape = interpolation between exact FvK level solves; blur =
        sunshape + surface/fabrication/wind slope errors + circumsolar
        tail; offset_w [B,2] = boresight decenter at the pit; soil [B] =
        per-episode reflectance soiling."""
        B = p_act.shape[0]
        P = self.pr.shape[0]
        lv = (p_act / self.p0 - self.level_frac[0]) / (
            self.level_frac[-1] - self.level_frac[0]) * (self.N_LEVELS - 1)
        lv = torch.as_tensor(lv, dtype=torch.float32,
                             device=self.device).clamp(0, self.N_LEVELS - 1)
        # ARTIST: NURBS surface points+normals, Sun cone (gaussian core +
        # circumsolar tail, both ARTIST samples), ARTIST reflect.
        org_b, d_b, i4 = self.primary.bounce(lv, sigma_b, self.tick)
        z = org_b[..., 2]
        o4 = org_b.reshape(-1, 4)
        d4 = d_b.reshape(-1, 4)
        hit, n2, ok = self.sec.intersect(o4, d4)
        d2 = _sim.reflect(d4, n2)
        cfg = self.cfg
        wpt = self.AO.hit_plane(hit, d2, self.pl_z0, self.device)
        rho_w = torch.sqrt(wpt[:, 0] ** 2 + wpt[:, 1] ** 2)
        okw = ok & (d2[:, 2] < 0) & (rho_w <= cfg.r_window)
        R3 = self._sun_R
        piv = torch.tensor([0.0, 0.0, -cfg.pivot_drop], device=self.device)
        wpt_w = (wpt[:, :3] - piv) @ R3.T
        d2_w = d2[:, :3] @ R3.T
        # boresight error (tracking + flexure + buffet) as beam decenter
        off = torch.as_tensor(offset_w, dtype=torch.float32,
                              device=self.device)
        wpt_w = wpt_w.clone()
        wpt_w[:, :2] += off.repeat_interleave(P, dim=0)
        _p = lambda t: torch.cat([t, torch.ones_like(t[..., :1])], -1)
        _d = lambda t: torch.cat([t, torch.zeros_like(t[..., :1])], -1)
        ppit = self.AO.hit_plane(_p(wpt_w), _d(d2_w), self.pl_z0,
                                 self.device)[..., :3]
        down = okw & (d2_w[:, 2] < 0)
        direct = down & (ppit[:, 0] ** 2 + ppit[:, 1] ** 2 <= cfg.r_pit**2)
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
            rho_c = torch.sqrt(hitc[:, 0] ** 2
                               + hitc[:, 1] ** 2).clamp(min=1e-9)
            n_c = torch.stack([hitc[:, 0] / rho_c, hitc[:, 1] / rho_c,
                               -torch.ones_like(rho_c)], dim=-1)
            n_c = n_c / np.sqrt(2.0)
            d_r = d2_w - 2 * (d2_w * n_c).sum(-1, keepdim=True) * n_c
            tpit2 = -hitc[:, 2] / d_r[:, 2].clamp(max=-1e-9)
            p2 = hitc + tpit2[:, None] * d_r
            recovered = (down & ~direct & (v1 | v2) & (d_r[:, 2] < -1e-6)
                         & (p2[:, 0] ** 2 + p2[:, 1] ** 2 <= cfg.r_pit**2))
            ppit = torch.where(recovered[:, None], p2, ppit)
            d2_w = torch.where(recovered[:, None], d_r, d2_w)
            flare_w = recovered.float() * self.flare_reflect
        through = direct | (flare_w > 0)
        through_f = direct.float() + flare_w
        q = ppit - self._oc_w
        b = (q * d2_w).sum(-1)
        c = (q * q).sum(-1) - cfg.R_oven**2
        ts = -b + torch.sqrt((b**2 - c).clamp(min=0))
        strike = ppit + ts[:, None] * d2_w
        ct = ((strike[:, 2] - self._zc_w) / cfg.R_oven).clamp(-1, 1)
        phi = torch.atan2(strike[:, 1], strike[:, 0])
        rho_h = torch.sqrt(strike[:, 0] ** 2 + strike[:, 1] ** 2)
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
        soil_t = torch.as_tensor(soil, dtype=torch.float32,
                                 device=self.device)
        w = (self._ray_pw.expand(B, P)
             * soil_t[:, None]).reshape(-1) * through_f
        if self.render_mode == "human":
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
        pot = getattr(self, "_pot_sphere", None)
        if pot is not None:
            # THE REAL PIT: node areas are the exact zones of the
            # spherical section between the strike code's own z-bands
            # (Archimedes: zone area = 2 pi R dz), plus the coal-bed
            # floor disc - the same sphere _bin_pot strikes, so power
            # binning and thermal area can never drift apart.
            R_s, z_cp, h_d, z_cr, z_he, z_bk = pot
            zone = lambda z0, z1: 2 * np.pi * R_s * (z1 - z0)
            a_belt = zone(z_bk, z_cr) / self.n_belt   # BAKING ROW
            a_hearth = np.pi * 0.28**2       # beam footprint on the bed
            a_floor = (zone(-h_d, z_he) + np.pi * 0.42**2) - a_hearth
            a_crown = zone(z_cr, 0.0)
            a_lower = zone(z_he, z_bk) / max(
                getattr(self, "n_extra_nodes", 0), 1)
        else:
            R = cfg.R_oven
            # node areas on the sphere; hearth = beam footprint carved
            # out of the bottom cap
            a_belt = 2 * np.pi * R**2 * (0.55 + 0.4) / self.n_belt
            a_hearth = np.pi * 0.28**2
            a_floor = 2 * np.pi * R**2 * (1 - 0.4) - a_hearth
            a_crown = 2 * np.pi * R**2 * (self.ct_cut - 0.55)
        extra = [a_lower] * getattr(self, "n_extra_nodes", 0) \
            if pot is not None else []
        self.node_area = np.array(
            [a_belt] * self.n_belt + [a_hearth, a_floor, a_crown]
            + extra,
            dtype=np.float64,
        )
        # thin hot-face construction: 1.5 cm dense liner over insulating
        # backfill (k ~ 0.06 W/mK). We only need the SURFACE hot - the
        # liner reaches the cooking band in tens of minutes on ~5 kW, at
        # the price of less thermal buffering when clouds pass.
        self.node_heat_cap = self.node_area * 1900 * 880 * 0.015
        # THE WALL BEHIND THE LINER (thermal audit, thermal_audit.py):
        # the lumped 1.5 cm face + steady U=0.7 drain reached the cook
        # band in 0.78 h where true 1-D conduction takes 3.80 h - the
        # charge phase was ~5x too fast, inflating every cold-start
        # roti count. Model: face (the 1.5 cm liner above) + 5 cm
        # substrate + 10 cm deep clay + a soil halo shell, discretized
        # as SPHERICAL shells of the equivalent buried cavity
        # (r_eff = sqrt(A_tot/4pi)): exact 4 pi k/(1/ra - 1/rb) shell
        # conductances and true shell volumes - planar layers would
        # understate deep storage ~40% and the far field is a 3-D
        # spreading resistance, not a slab to ambient. The halo
        # (~12 MJ/K, tau ~2 weeks) is the transient 3-D soil term: a
        # fresh pit loses ~2x what a seasoned one does.
        K_CLAY, K_SOIL, RC = 0.9, 0.5, 1900 * 880
        a_tot = float(self.node_area.sum())
        r0 = float(np.sqrt(a_tot / (4 * np.pi)))
        rf1, rf2, rf3 = r0 + 0.015, r0 + 0.065, r0 + 0.165
        r_halo = rf3 + 0.55
        shell = lambda ra, rb: (4/3) * np.pi * (rb**3 - ra**3)
        gsph = lambda k, ra, rb: 4 * np.pi * k / (1/ra - 1/rb)
        frac = self.node_area / a_tot
        self.cap_sub = RC * shell(rf1, rf2) * frac
        self.cap_deep = RC * shell(rf2, rf3) * frac
        self.g01 = gsph(K_CLAY, r0 + 0.0075, r0 + 0.040) * frac
        self.g12 = gsph(K_CLAY, r0 + 0.040, r0 + 0.115) * frac
        self.g2s = frac / (1/gsph(K_CLAY, r0 + 0.115, rf3)
                           + 1/gsph(K_SOIL, rf3, r_halo))
        self.g_halo_out = 4 * np.pi * K_SOIL * r_halo
        self.c_halo = 1500 * 1200 * shell(rf3, r_halo)
        if self.insulation:
            # 10 cm glass-wool annulus (k=0.05) between clay and soil:
            # R_ins ~ 0.27 K/W in series with the 0.105 K/W spreading
            # path -> deep->halo conductance drops to ~28%
            self.g2s = self.g2s * 0.28

        # 8 cm fiber backfill (honest-yield redesign): 0.06/0.08
        self.r_soil = 1.0 / (0.7 * self.node_area)
        self.a_ap = np.pi * cfg.r_pit**2

    # -------------------------------------------------------------- state #
    def _reset_state(self):
        B = self.num_agents
        self.t_solar = np.full(B, 8.0)
        # curriculum: half the tandoors wake up still warm from yesterday
        # (belt in or near the loading band) so the shutter/loading skill
        # is discoverable; cold starts remain the other half
        warm = self.rng.random(B) < self.warm_frac
        # "warm" = a SEASONED pit operated yesterday. 45-day carried
        # simulation (season_sim.py, spherical wall + halo, state
        # preserved across the day-over reset): daily operation
        # converges to morning face ~487 K equilibrated, halo ~405 K,
        # after ~6 weeks. The old 540-620 K draw was a mid-day
        # temperature no overnight preserves - off-manifold - and the
        # interim 405-470 K draw was read off a sim the env's own
        # day-over reset was stomping (under-seasoned, band-unreachable).
        base_T = np.where(warm, self.rng.uniform(465, 505, B),
                          350.0 + self.rng.uniform(-15, 15, B))
        self.T = np.repeat(base_T[:, None], self.n_nodes, axis=1)
        self.T += self.rng.uniform(-15, 15, (B, self.n_nodes))
        self.p_set = np.full(B, self.p0)
        self.p_act = np.full(B, self.p0)
        self.p_dist = np.zeros(B)          # plenum thermodynamic drift [Pa]
        self.shutter = np.ones(B)          # 1 = open (beam into pit)
        self.wind_g = np.zeros(B)          # gust OU about the diurnal base
        self.wind = np.zeros(B)
        self.stowed = np.zeros(B, dtype=bool)
        self.soil = self.rng.uniform(0.85, 1.0, B)  # per-episode soiling
        self.bore = np.zeros((B, 2))       # boresight OU wander [m at pit]
        self.cloud = np.zeros(B)
        self.bread_E = np.zeros((B, self.n_belt))
        self.bread_C = np.zeros((B, self.n_belt))   # char fraction
        self.bread_t = np.zeros((B, self.n_belt))
        self.has_bread = np.zeros((B, self.n_belt), dtype=bool)
        self.load_timer = np.zeros(B)
        self._belt_prev = self.T[:, : self.n_belt].max(1).copy()
        self.ep_rotis = np.zeros(B)
        # cut-IMMUNE daily naan counter: cuts zero ep_rotis, so
        # rotis_per_day under-reported; day_rotis only day-over
        # zeroes it, and hourly deltas come off it
        self.day_rotis = np.zeros(B)
        self.ep_scorch = np.zeros(B)
        self.ep_spall = np.zeros(B)
        self.T_sub = self.T.copy()
        self.T_deep = self.T.copy()
        self.T_halo = np.where(warm, self.rng.uniform(395, 415, B), 300.0)
        self.ep_return = np.zeros(B)
        self.ep_len = np.zeros(B)

    def equilibrate_wall(self, halo=None):
        """For diagnostics that force self.T wholesale after reset():
        bring the hidden wall state (substrate, deep clay, soil halo)
        onto the same manifold, or they leak yesterday's heat into a
        supposedly cold benchmark. Halo defaults by face temp: seasoned
        ~400 K for a warm wall, fresh 300 K for a cold one."""
        self.T_sub = self.T.copy()
        self.T_deep = self.T.copy()
        if halo is None:
            warm = self.T[:, : self.n_belt].mean(1) > 450.0
            self.T_halo = np.where(warm, 400.0, 300.0)
        else:
            self.T_halo = np.full(self.num_agents, float(halo))

    def _obs(self):
        h = (self.t_solar - 8.0) / 8.0
        obs = np.concatenate([
            np.stack([np.sin(np.pi * h), np.cos(np.pi * h),
                      self.dni / 1000.0], axis=1),
            self.T / 1000.0,
        ] + ([
            # buried thermocouples: the wall's hidden charge state. The
            # value function cannot price a morning (face 470/sub 470
            # vs face 470/sub 390 differ by the whole day's return) by
            # integrating face history over 1900 steps through a short
            # BPTT window - so let it read the column directly.
            np.stack([
                self.T_sub[:, : self.n_belt].mean(1) / 1000.0,
                self.T_deep[:, : self.n_belt].mean(1) / 1000.0,
                self.T_halo / 1000.0,
            ], axis=1),
        ] if self.wall_obs else []) + [
            np.stack([
                (self.p_act - self.p0) / 60.0,
                self.shutter,
                self.wind / 10.0,
                np.clip(self.bore[:, 0] / 0.1, -2, 2),
                np.clip(self.bore[:, 1] / 0.1, -2, 2),
                # cook readiness: the next pera is rolled (bell signal)
                np.clip(self.load_timer / 45.0, 0, 2),
            ], axis=1),
            self.bread_E / self.roti_energy,
            self.bread_C,
            self.p_in[:, None] / 6000.0,
        ] + ([self._extra_obs()] if self.N_EXTRA_OBS else []),
            axis=1).astype(np.float32)
        return np.clip(obs, -4.0, 4.0)

    def _extra_obs(self):
        return np.zeros((self.num_agents, self.N_EXTRA_OBS))

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
        a = np.asarray(actions).reshape(B, 2)
        # hard-validate both heads: shutter is a gate, never a multiplier
        # (a NaN policy once fed 0-6 here and tripled the sun)
        self.p_set = self.p0 * self.level_frac[
            np.clip(a[:, 0], 0, self.N_LEVELS - 1)]
        thr = 3.5 if self.wide_shutter else 0.5
        self.shutter = (a[:, 1] > thr).astype(np.float64)
        # pump servo chases setpoint against plenum thermodynamics
        # (sealed-gas ~300 Pa/K; insolation-correlated bias + noise)
        bias = 0.05 * (self.dni - 400.0) / 10.0
        self.p_dist += ((bias - self.p_dist) / 900.0 * self.dt
                        + self.rng.normal(0, 1.2, B))
        self.p_dist = np.clip(self.p_dist, -40, 60)
        self.p_act += np.clip(self.p_set + self.p_dist - self.p_act,
                              -6.0, 6.0)
        # sun + clouds
        self.t_solar += self.dt / 3600.0
        phi = np.radians(self.lat)
        delta = np.radians(23.44) * np.sin(2 * np.pi * (284 + self.day) / 365)
        hh = np.radians(15.0 * (self.t_solar - 12.0))
        sin_el = (np.sin(phi) * np.sin(delta)
                  + np.cos(phi) * np.cos(delta) * np.cos(hh))
        el = np.degrees(np.arcsin(np.clip(sin_el, -1, 1)))
        am = 1.0 / np.clip(sin_el, 0.035, None)
        clear = np.where(el > 2.0, 1353.0 * 0.7 ** (am**0.678), 0.0)
        tau_c = 900.0
        self.cloud += (-self.cloud / tau_c * self.dt
                       + self.rng.normal(0, 0.25 * np.sqrt(2 * self.dt / tau_c), B))
        deep = self.rng.random(B) < 0.0015 * self.dt / 15.0
        self.cloud[deep] -= 1.5
        self.cloud = np.clip(self.cloud, -3, 0.25)
        el0, _, s_np = _sim.solar_position(self.lat, self.day,
                                           float(self.t_solar[0]))
        # HONEST GATE: the assembly cannot tilt past its own rim-clearance
        # limit, which tightens as the dish grows. Previously hardcoded at
        # 27 deg, which silently credited big dishes with tracking their
        # mounts could not reach.
        if el0 > self.el_min:
            self._sun_R = _sim.rotation_z_to(s_np).to(self.device)
        else:
            self._sun_R = torch.eye(3, device=self.device)
        # wind: diurnal base + per-env gusts; auto-stow with hysteresis
        base_w = 2.5 + 3.5 * np.sin(np.pi * np.clip(
            (self.t_solar - 8.0) / 8.0, 0, 1))
        self.wind_g += (-self.wind_g / 600.0 * self.dt
                        + self.rng.normal(0, 1.8 * np.sqrt(2 * self.dt / 600.0), B))
        self.wind = np.clip(base_w + self.wind_g, 0, 25)
        self.stowed = (self.stowed | (self.wind > self.wind_limit)) & ~(
            self.wind < self.wind_limit - 2.0)
        self.dni = clear * np.exp(self.cloud) * (el > 27.0) * ~self.stowed
        # slope-error budget -> per-env angular sigma (doubled on reflect)
        q_w = 0.6 * self.wind**2
        # measured by the 2-D FvK solver (fvk2d_cassegrain.py), NOT the
        # q*a/2T hand estimate that overstated this ~2.5x: the nonlinear
        # membrane resists asymmetric load far better, and sublinearly
        sig_wind = 0.88e-3 * (q_w / 15.0) ** 0.6
        # OPTICS-ONLY sigma: the sun's shape now comes from the Buie
        # table in the trace itself, not a Gaussian folded in here
        sigma_b = np.sqrt((2 * self.sigma_surf) ** 2
                          + (2 * self.sigma_fab) ** 2
                          + (2 * sig_wind) ** 2)
        # boresight: OU wander + tilt-dependent mast flexure + wind buffet
        self.bore += (-self.bore / 300.0 * self.dt
                      + self.rng.normal(0, 0.030 * np.sqrt(2 * self.dt / 300.0),
                                        (B, 2)))
        tilt_s = np.sqrt(max(0.0, 1.0 - s_np[2] ** 2))
        a_hat = (s_np[:2] / max(np.linalg.norm(s_np[:2]), 1e-9)
                 if tilt_s > 1e-3 else np.array([1.0, 0.0]))
        offset = (self.bore + 0.035 * tilt_s * a_hat[None, :]
                  + self.rng.normal(0, 1, (B, 2))
                  * (0.002 * self.wind)[:, None])

        with torch.no_grad():
            per_dni = self._trace_power(self.p_act, sigma_b, offset,
                                        self.soil).numpy()
        gate = self.dni * self.shutter  # shutter dumps the beam at the pit
        q_solar = per_dni * gate[:, None] * 0.85
        self.p_in = per_dni.sum(1) * gate

        # thermal update on the thin hot-face liner
        T = self.T
        t4 = T**4
        t_cav4 = (self.node_area * t4).sum(1, keepdims=True) / self.node_area.sum()
        q_exch = 0.85 * SIGMA * self.node_area * (t_cav4 - t4)
        # rigid glass over the mouth is opaque to thermal IR: it
        # traps cavity re-radiation (transmission cost is in the
        # chain; here its greenhouse benefit cuts aperture IR loss)
        q_ap = 0.3 * SIGMA * (t_cav4.squeeze(1) - T_AMB**4) * self.a_ap
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
        h_bread = self.h_bread
        belt_T = T[:, : self.n_belt]
        # the dough exchanges at its OWN temperature: room-temp
        # coldstart (T_AMB) warming to ~400 K at full bake (user
        # call: a cold wall is a cold wall - the roti on it just
        # sits there trading heat). At E -> E_r the driving gap is
        # T_wall - 400: the old baking-band condition to FINISH a
        # loaf is unchanged; fresh dough just drinks faster.
        t_dough = T_AMB + 100.0 * np.clip(
            np.maximum(self.bread_E, 0.0) / self.roti_energy, 0.0, 1.0)
        q_b = self.has_bread * h_bread * (belt_T - t_dough)
        q[:, : self.n_belt] -= q_b
        dT = q * self.dt / self.node_heat_cap
        self.T = T + dT
        self.bread_E += q_b * self.dt
        self.bread_t += self.has_bread * self.dt

        # liner thermal shock at the hearth: spalling if heated too fast -
        # ramp-rate limiting via defocus/shutter is a learnable skill
        spall = dT[:, self.n_belt] > 25.0
        self.ep_spall += spall

        rew = np.zeros(B)
        belt_T = self.T[:, : self.n_belt]
        # CHAR is a RATE, not a threshold: time-at-temperature on the
        # contact side plus front-surface beam flux. A done loaf STAYS
        # on the wall, charring, until the cook's next lean pulls it -
        # scorch is a scheduling phenomenon, not a cliff.
        c_dot = np.clip(belt_T - 800.0, 0, None) / 6000.0
        if getattr(self, "spot_bread", 0) and \
                getattr(self, "_spot_flux", None) is not None:
            kb, valid = self._spot_bin
            ar_ = np.arange(len(kb))
            fkw = self._spot_flux / 1000.0
            add = np.zeros_like(c_dot)
            add[ar_, kb] = np.clip(fkw - 8.0, 0, None) / 1000.0 * valid
            c_dot = c_dot + add
        self.bread_C += self.has_bread * c_dot * self.dt
        ready = self.has_bread & (self.bread_E >= self.roti_energy)
        # the cook banks READY loaves at an opening (same lean that
        # loads); reward lands on the PULL, so bread that chars after
        # doneness earns nothing
        # the beam enters at the BASE, never the mouth: the lean
        # needs no shutter interlock (polar's structural safety win)
        # ONE lean event: pull and load share the opening. The timer
        # is checked against its post-increment value because the
        # unconditional lean below resets it in the same step - the
        # pre-increment check never saw the period and pull could
        # never fire (the old temperature-gated load only worked
        # because FAILED leans left the timer running past the period)
        pull_open = self.load_timer + self.dt >= self.load_period
        cooked = ready & pull_open[:, None]
        scorched = self.has_bread & (self.bread_C >= 1.0)
        # NO doughy timeout (user call): a roti comes off the wall
        # only COOKED or charred. Raw dough on a cold wall just sits
        # there, blocking its bin from the random cook - the waste IS
        # the lost throughput, no synthetic penalty needed.
        rew += 5.0 * cooked.sum(1) - 5.0 * scorched.sum(1)
        rew -= 0.5 * spall
        self.ep_rotis += cooked.sum(1)
        self.day_rotis += cooked.sum(1)
        self.ep_scorch += scorched.sum(1)
        done_bread = cooked | scorched
        self.has_bread &= ~done_bread
        self.bread_E[done_bread] = 0.0
        self.bread_t[done_bread] = 0.0
        self.bread_C[done_bread] = 0.0
        # INTERLOCK: the cook loads through the side port only while the
        # shutter is CLOSED (beam dumped) - admitting bread costs flux
        self.load_timer += self.dt
        want = (self.load_timer >= self.load_period) & (self.shutter < 0.5)
        ar_ = np.arange(self.num_agents)
        if getattr(self, "load_ctrl", 0):
            # the POLICY plays the cook: the last n_belt heads gate
            # each bin (value > thr = slap dough here). Only physics
            # remains: empty bins only, loaves_per_load per lean.
            # (_load_mask: the outer env stashes its full action row
            # - this step's own `a` is reshaped to ITS head count)
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
            # the cook slaps loaves_per_load rotis into RANDOM bins -
            # no temperature check, no hottest-first (user call: the
            # argmax taught the policy to heat ONE cell). cook_bin is
            # deterministic in (env, tick, loaf), same on every
            # backend; dough does not stack on an occupied bin.
            for _k in range(self.loaves_per_load):
                j = cook_bin(ar_, self.tick, _k, self.n_belt)
                place = want & ~self.has_bread[ar_, j]
                self.has_bread[ar_[place], j[place]] = True
                rew[place] += 0.3
        self.load_timer[want] = 0.0
            # potential-based preheat shaping on the HOTTEST bin: reward
        # its temperature RISE while it is below the band (policy-
        # invariant, telescopes to zero over any closed loop). The
        # mean-based version taught the old whole-belt pot; on the
        # spot machine one bin of eight charges and the mean diluted
        # the only signal that teaches holding the aim 8x (Suarez:
        # difference rewards, but on the RIGHT channel).
        # MEASURED (why magnitude-delta, not Suarez's sign(delta)):
        # dawn charging, good policy: dT_max +0.90 K/step [p10 +0.31];
        # random policy: -0.01 +- 0.15. 6-sigma separation, 90x reward
        # ratio - his -0.95/-0.94 disease is absent. A +-1 sign reward
        # would pay FULL scale for the sign of the random column's
        # noise (bad behavior here is STASIS, deltas ~0, where sign is
        # a coin flip but magnitude is correctly silent). The clipped
        # magnitude delta IS the deadbanded form his rule needs in a
        # noisy-thermal env.
        # BANDED-SUM preheat potential, REINSTATED. The removal was
        # wrong (user data: old-reward runs reached 180-360/day at
        # warm_frac 0; without shaping the policy collapsed into
        # soft-retreat, form_minutes 243): 'the pot cooks from
        # minute one' was measured under the HEURISTIC - circular
        # for a fresh policy that has not learned jam/track/aim.
        # Beam-on must pay BEFORE the first cook. Sum of sub-453
        # rises over ALL bins: engagement rewarded row-wide, no
        # single-cell fixation, per-bin clamp kills overshoot pay,
        # telescopes exactly (in-step old/new T, no belt_prev).
        rew += 0.05 * np.clip(
            np.minimum(belt_T, T_COOK_LO)
            - np.minimum(T[:, : self.n_belt], T_COOK_LO),
            -5, 5).sum(1)
        belt_max = belt_T.max(1)
        self._belt_prev = belt_max.copy()
        # NO temperature penalty at all (user call): the 950 K
        # structure barrier followed the 690/640 taxes out the door.
        # Bread economics (+5 cooked / -5 scorched at 730 K) and the
        # spall event are the only thermal regulators - the policy
        # owns the hot cadence entirely.

        self.ep_return += rew
        self.ep_len += 1
        self.tick += 1
        day_over = self.t_solar >= 16.0
        self.terminals[:] = day_over
        self.truncations[:] = False
        self.rewards[:] = rew.astype(np.float32)
        infos = []
        if day_over.any():
            # end-of-day stuff-the-oven closed: a loaf loaded in the
            # last minutes was paid +0.3 but can never cook - charge
            # the bonus back when the day wipes it
            inflight = 0.3 * self.has_bread[day_over].sum(1)
            self.rewards[day_over] -= inflight.astype(np.float32)
            self.ep_return[day_over] -= inflight
            infos.append({
                "rotis_per_day": float(self.ep_rotis[day_over].mean()),
                "scorched": float(self.ep_scorch[day_over].mean()),
                "spall_events": float(self.ep_spall[day_over].mean()),
                "episode_return": float(self.ep_return[day_over].mean()),
                "episode_length": float(self.ep_len[day_over].mean()),
            })
            for i in np.nonzero(day_over)[0]:
                self.t_solar[i] = 8.0
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
                self.bread_C[i] = 0.0     # fresh dough carries no char
                self.load_timer[i] = 0.0
                self.ep_rotis[i] = self.ep_scorch[i] = 0.0
                self.day_rotis[i] = 0.0
                self.ep_spall[i] = 0.0
                self._belt_prev[i] = self.T[i, : self.n_belt].max()
                self.ep_return[i] = self.ep_len[i] = 0.0
        self.observations[:] = self._obs()
        return (self.observations, self.rewards, self.terminals,
                self.truncations, infos)


    # ------------------------------------------------- shared HUD pieces #
    def _draw_disturbances(self, pr, x, y):
        """Every simulated disturbance, drawn once on the base class so the
        three renderers cannot drift out of sync with the physics again.
        These terms all move the beam or scale its power with no visible
        cause otherwise - exactly the category where a bug can hide."""
        def txt(dy, s, col=(200, 200, 212, 255)):
            pr.draw_text(s, x, y + dy, 16, col)
        cmd = float(self.p_set[0]) if hasattr(self, "p_set") else self.p0
        act = float(self.p_act[0])
        drift = float(self.p_dist[0])
        txt(0, "disturbances", (150, 190, 230, 255))
        txt(22, f"plenum cmd {cmd - self.p0:+5.0f}  act {act - self.p0:+5.0f}"
                f"  drift {drift:+5.0f} Pa",
            (230, 160, 110, 255) if abs(drift) > 12 else (200, 200, 212, 255))
        bx, by = float(self.bore[0, 0]), float(self.bore[0, 1])
        txt(44, f"boresight  {bx*1000:+4.0f}, {by*1000:+4.0f} mm",
            (230, 160, 110, 255) if np.hypot(bx, by) > 0.05
            else (200, 200, 212, 255))
        txt(66, f"soiling {self.soil[0]:.2f}   cloud "
                f"{np.exp(self.cloud[0]):.2f}x",
            (230, 160, 110, 255) if self.soil[0] < 0.9
            else (200, 200, 212, 255))
        el0, _, _ = _sim.solar_position(self.lat, self.day,
                                        float(self.t_solar[0]))
        emin = getattr(self, "el_min", None)   # only the gimballed
        gated = emin is not None and el0 <= emin   # beam-down has one
        txt(88, f"sun el {el0:4.0f}" + (
                f"  mount limit {emin:.0f}{'  GATED' if gated else ''}"
                if emin is not None else "  (no mount tilt limit)"),
            (235, 110, 90, 255) if gated else (200, 200, 212, 255))
        frac = float(np.clip(self.load_timer[0] / 45.0, 0, 1))
        txt(110, f"cook ready in {max(45.0-float(self.load_timer[0]),0):4.0f}s")
        pr.draw_rectangle(x, y + 132, 180, 10, (45, 48, 58, 255))
        pr.draw_rectangle(x, y + 132, int(180 * frac), 10,
                          (120, 220, 140, 255) if frac >= 1
                          else (120, 160, 220, 255))
        if hasattr(self, "ep_spall"):
            txt(148, f"spall events {self.ep_spall[0]:.0f}",
                (235, 110, 90, 255) if self.ep_spall[0] > 0
                else (200, 200, 212, 255))

    def _draw_bread_strip(self, pr, x, y):
        """Belt temperatures + the QUEUE: per-bin dough dots browning
        by cook fraction, blackening by char, ringed green when READY
        (waiting for the cook's lean). Kelvin throughout."""
        nb_ = int(self.has_bread[0].sum())
        pr.draw_text(f"belt K   queue {nb_}/{self.loaves_per_load}",
                     x, y - 14, 12, (170, 176, 188, 255))
        for k in range(self.n_belt):
            pr.draw_rectangle(x + 44 * k, y, 40, 30,
                              self._heat_color(self.T[0, k]))
            pr.draw_text(f"{self.T[0, k]:.0f}", x + 4 + 44 * k, y + 8,
                         13, (235, 235, 235, 255))
            if self.has_bread[0, k]:
                fr = float(min(self.bread_E[0, k]
                               / self.roti_energy, 1.0))
                ch = float(min(self.bread_C[0, k], 1.0))
                if fr >= 1.0:          # READY: waiting for the lean
                    pr.draw_circle(x + 20 + 44 * k, y + 46, 12,
                                   (110, 220, 130, 255))
                pr.draw_circle(x + 20 + 44 * k, y + 46, 9,
                               (240, 225, 190, 255))
                pr.draw_circle(x + 20 + 44 * k, y + 46, int(9 * fr),
                               (int(150 * (1 - ch) + 40 * ch),
                                int(95 * (1 - ch) + 34 * ch),
                                int(45 * (1 - ch) + 30 * ch), 255))

    # ------------------------------------------------------------- render #
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
        # boresight crosshair on the pit map: the beam really is being
        # walked around by wander + tilt flexure, previously invisible
        if lr is not None:
            cx = 1020 + int((self.bore[0, 0] / 0.3 + 1) * 0.5 * 30 * 4)
            cy = 212 + int((self.bore[0, 1] / 0.3 + 1) * 0.5 * 30 * 4)
            pr.draw_line(cx - 7, cy, cx + 7, cy, (120, 230, 235, 200))
            pr.draw_line(cx, cy - 7, cx, cy + 7, (120, 230, 235, 200))
        self._draw_bread_strip(pr, 1020, 360)
        self._draw_disturbances(pr, 1020, 440)
        v = float(self.p_act[0] - self.p0)
        pr.draw_text("plenum [Pa vs nominal]", 1020, 414, 15,
                     (170, 170, 185, 255))
        pr.draw_rectangle(1020, 450 - max(int(v // 2), 0), 30,
                          abs(int(v // 2)) + 2, (120, 190, 240, 255))
        sh = self.shutter[0] > 0.5
        pr.draw_text(f"shutter {'OPEN' if sh else 'CLOSED'}", 1070, 436, 16,
                     (120, 230, 140, 255) if sh else (230, 120, 90, 255))
        pr.draw_text(f"wind {self.wind[0]:4.1f} m/s"
                     f"{'  STOWED' if self.stowed[0] else ''}",
                     1070, 458, 16,
                     (230, 120, 90, 255) if self.stowed[0]
                     else (170, 170, 185, 255))
        pr.draw_text(f"spall events {self.ep_spall[0]:.0f}", 1070, 480, 15,
                     (170, 170, 185, 255))
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
        acts = np.stack([env.rng.integers(0, 7, B),
                         env.rng.integers(0, 2, B)], axis=1)
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

"""His concentrator on the tandoor: the puffer env that competes on rotis per day.

The tandoor env (tandoor_hashemi_env.TandoorHashemiEnv) is kept whole - its pot, wall chain,
bread, guillotine, observations and reward are the code puffer_hashemi and puffer_flower score
on, and their laws are already checked in Lean. Two things come from Hashemi.lean through Ccc
instead of the tandoor's own machine:

  * the carriage and the dish: the state (az, t, slack) advances by `hk_step` in the megakernel
    (the wire's length as the state's carrier, the dead point, the winch gated by HoldsDish);
    the parent's motors stand still and its pose is set from the Lean state;
  * the power into the pot: his 1.6 m faceted satellite dish traced by `hk_traceRayK` (the
    sun on its disc, 2 mrad slope and 1 mrad specularity errors), the capture on a 12 cm
    aperture at F, times the dish's area and reflectance and the DNI - delivered into the pot
    along the parent's own node profile (its beam's split over the floor and belt, recorded once
    at reset), in place of the tri train.

`puffer train --config hashemi_ccc.ini` runs it; the metric is the parent's rotis.
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
TUT = os.path.dirname(HERE)
ROOT = os.path.dirname(TUT)
for _p in (ROOT, TUT, HERE):
    if _p not in sys.path:
        sys.path.insert(0, _p)

import torch                                        # noqa: E402
from tandoor_hashemi_env import TandoorHashemiEnv   # noqa: E402
from hashemi_kernel import COL, HashemiMetal, mega_numpy, mega_params_numpy   # noqa: E402
from hashemi_trace_kernel import (HashemiTraceMetal, sample_rays_mc, sun_in_dish, trace_params_numpy,   # noqa: E402
                                  RAY_W, OUT_W, SUN_HALF_ANGLE)


class HashemiTandoorEnv(TandoorHashemiEnv):
    """the tandoor with his concentrator: pose and power from the compiled Hashemi.lean"""

    DISH_K = -1.0            # the panel as the frames show it: a satellite dish (a paraboloid)
    SLOPE_ERR = 2e-3         # rad, the tiles' slope error (SolTrace's model)
    SPEC_ERR = 1e-3
    RHO = 0.85               # the mosaic's reflectance (megaParams)
    RC_INLET = 0.06          # the pot's aperture at F, his 12 cm coil's size

    def __init__(self, *args, trace_rays=64, **kwargs):
        # gpu=0: the parent's numpy step, the trace on Metal (the eval/bench path);
        # gpu=1: the parent's fused Metal step with the trace injected (the training path)
        self._fused_profile = None
        super().__init__(*args, **kwargs)
        B = self.num_agents
        self.trace_rays = int(trace_rays)
        self._hk = HashemiMetal()
        self._tr = HashemiTraceMetal()
        self._prm = torch.as_tensor(mega_params_numpy(), dtype=torch.float32, device="mps")
        self._prm_np = mega_params_numpy()
        self._trace_prm = trace_params_numpy()
        self._st = torch.zeros(B, 3, dtype=torch.float32, device="mps")
        self.hk_state = np.zeros((B, 3))
        rest = mega_numpy(np.zeros((B, 3)), np.zeros((B, 2)), 0.0, np.array([[0.5, 0.0, 800.0]] * B), self._prm_np)
        self.hk_row = rest
        self.t_dead = float(rest[0, COL["t_dead"]])
        self.dish_area = float(rest[0, COL["dishSide"]]) ** 2
        self._om_full = np.radians(self.RATE_AZ) * float(rest[0, COL["rollerRadius"]]) / 0.05
        self._od_full = 0.01 / float(self._prm_np[0])              # 1 cm/s of wire at full command
        self._beam_profile = None
        self.cap_traced = np.zeros(B)

    # --- the parent's sag model is not this machine's: the dish's elevation is the Lean state
    def el_dish_deg(self, el_m, wind):
        return np.asarray(el_m, dtype=np.float64)

    def el_dish_t(self, el_m, wind):
        return el_m

    def _sync_from_motors(self, mask):
        mask = np.asarray(mask, dtype=bool)
        if not mask.any():
            return
        self.hk_state[mask, 0] = np.radians(np.asarray(self.az_m, dtype=np.float64)[mask])
        t = np.radians(90.0 - np.asarray(self.el_m, dtype=np.float64)[mask])
        self.hk_state[mask, 1] = np.clip(t, 0.0, self.t_dead)
        self.hk_state[mask, 2] = 0.0
        self.el_m = np.asarray(self.el_m, dtype=np.float64)
        self.el_m[mask] = 90.0 - np.degrees(self.hk_state[mask, 1])
        self._st.copy_(torch.as_tensor(self.hk_state, dtype=torch.float32))

    def _sun(self):
        import tandoor_hashemi_env as _m
        el0, az0, _ = _m._sim.solar_position(self.lat, self.day, float(self.t_solar[0]))
        return float(el0), float(az0)

    def reset(self, *args, **kwargs):
        res = super().reset(*args, **kwargs)
        self._sync_from_motors(np.ones(self.num_agents, dtype=bool))
        return res

    # --- the power into the pot: his dish's trace, on the parent's node profile
    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        B = self.num_agents
        if self._beam_profile is None:
            per0 = super()._trace_power(p_eff, sigma_b, offset_w, soil).numpy()
            tot = per0.sum(1, keepdims=True)
            self._beam_profile = np.where(tot > 0, per0 / np.maximum(tot, 1e-9), 0.0)
            if not (self._beam_profile.sum(1) > 0).all():
                prof = np.zeros(per0.shape[1]); prof[:self.n_nodes] = 1.0 / self.n_nodes
                self._beam_profile = np.where(self._beam_profile.sum(1, keepdims=True) > 0, self._beam_profile, prof)
        el0, az0 = self._sun()
        if el0 < self.el_min_h:
            self.cap_traced[:] = 0.0
            return torch.zeros(B, self._beam_profile.shape[1])
        sd = sun_in_dish(self.hk_state[:, 0], self.hk_state[:, 1], np.full(B, np.radians(el0)), np.full(B, az0))
        P = self.trace_rays
        rays = np.concatenate([sample_rays_mc(P, sd[b], self.rng, sigma_slope=self.SLOPE_ERR, sigma_spec=self.SPEC_ERR)
                               for b in range(B)], 0)
        rays = self._fold_errors(rays)
        prm = torch.as_tensor(np.concatenate([self._trace_prm[:5], [self.DISH_K]]), dtype=torch.float32, device="mps")
        out = torch.empty(B * P, OUT_W, dtype=torch.float32, device="mps")
        self._tr.lib.hashemi_trace_k(torch.as_tensor(rays[:, :RAY_W], device="mps").contiguous(), prm, out,
                                     torch.tensor([B * P], dtype=torch.int32, device="mps"))
        self.cap_traced = out[:, 3].reshape(B, P).mean(1).cpu().numpy().astype(np.float64)
        # per unit DNI, as the parent expects: m^2 of aperture delivered, split along the beam profile
        per = (self.dish_area * self.RHO * self.cap_traced)[:, None] * self._beam_profile
        return torch.as_tensor(per, dtype=torch.float32)

    # ------------------------------------------------------------------ the fused GPU path
    # The parent's whole step runs in Metal (mount -> step_pre -> trace -> step_post on one
    # packed state). Here the motors are the Lean state, written into the packed state before
    # the step, and F.per (m^2 of aperture per unit DNI, per node) comes from his dish's trace
    # instead of the tandoor's, delivered along the tandoor beam's own node profile (recorded
    # from the parent's trace on the first fused step, as the numpy path records it at reset).
    def _sample_rays_t(self, sd, P):
        """the numpy sampler's draws on the device: the facet uniform on the grid, the point
        uniform in it, the direction -sun tilted by a draw on the sun's disc; the slope and
        specularity errors folded into that tilt as one Gaussian of sqrt((2 s_slope)^2 + s_spec^2)
        (a single reflection: the mirror's slope error doubles into the ray, first order)"""
        B = sd.shape[0]
        dev, g = sd.device, self._gen
        a, w = float(self._trace_prm[2]), float(self._trace_prm[3])
        n_side = int(round(2 * a / w))
        ci = torch.randint(0, n_side, (B, P), generator=g, device=dev).float()
        cj = torch.randint(0, n_side, (B, P), generator=g, device=dev).float()
        cx = -a + w / 2 + ci * w
        cy = -a + w / 2 + cj * w
        ux = (torch.rand(B, P, generator=g, device=dev) - 0.5) * w
        uy = (torch.rand(B, P, generator=g, device=dev) - 0.5) * w
        s = -sd[:, None, :].expand(B, P, 3)
        helper = torch.where(s[..., 2:3].abs() < 0.9, torch.tensor([0.0, 0.0, 1.0], device=dev),
                             torch.tensor([1.0, 0.0, 0.0], device=dev))
        e1 = torch.cross(s, helper, dim=-1); e1 = e1 / e1.norm(dim=-1, keepdim=True)
        e2 = torch.cross(s, e1, dim=-1)
        rho = SUN_HALF_ANGLE * torch.rand(B, P, generator=g, device=dev).sqrt()
        phi = 2 * np.pi * torch.rand(B, P, generator=g, device=dev)
        sig = float(np.sqrt((2 * self.SLOPE_ERR) ** 2 + self.SPEC_ERR ** 2))
        tx = rho * torch.cos(phi) + sig * torch.randn(B, P, generator=g, device=dev)
        ty = rho * torch.sin(phi) + sig * torch.randn(B, P, generator=g, device=dev)
        d = s + tx[..., None] * e1 + ty[..., None] * e2
        d = d / d.norm(dim=-1, keepdim=True)
        rays = torch.cat([cx[..., None], cy[..., None], ux[..., None], uy[..., None], d], -1)
        return rays.reshape(B * P, RAY_W).to(torch.float32).contiguous()

    def _fused_power(self, F, aux, soil_eff):
        """fills F.per from his dish's trace, on the device; called by tandoor_fused_step"""
        B, P, dev = self.num_agents, self.trace_rays, F.per.device
        if self._fused_profile is None:
            per0 = F.per.clone()
            tot = per0.sum(1, keepdim=True)
            prof = torch.where(tot > 0, per0 / tot.clamp_min(1e-9), torch.zeros_like(per0))
            uni = torch.zeros(per0.shape[1], device=dev); uni[:self.n_nodes] = 1.0 / self.n_nodes
            self._fused_profile = torch.where(prof.sum(1, keepdim=True) > 0, prof, uni[None, :])
            self._cap_t = torch.zeros(B, device=dev)
            self._sun_buf = (torch.empty(B, 4, dtype=torch.float32, device=dev),
                             torch.empty(B, 3, dtype=torch.float32, device=dev),
                             torch.empty(1, dtype=torch.float32, device=dev),
                             torch.tensor([B], dtype=torch.int32, device=dev),
                             torch.as_tensor(np.concatenate([self._trace_prm[:5], [self.DISH_K]]),
                                             dtype=torch.float32, device=dev),
                             torch.empty(B * P, OUT_W, dtype=torch.float32, device=dev),
                             torch.tensor([B * P], dtype=torch.int32, device=dev))
        pose, sd, dummy, nB, prm, out, nBP = self._sun_buf
        # the sun in the dish's frame: `sunInDish` compiled, one thread per agent (the mount's
        # per-agent sun: el deg, az rad)
        pose[:, 0] = self._st[:, 0]
        pose[:, 1] = self._st[:, 1]
        pose[:, 2] = torch.deg2rad(aux[:, 0])
        pose[:, 3] = aux[:, 1]
        self._tr.lib.hashemi_sun(pose, dummy, sd, nB)
        up = aux[:, 0] > self.el_min_h
        rays = self._sample_rays_t(sd, P)
        self._tr.lib.hashemi_trace_k(rays, prm, out, nBP)
        cap = out[:, 3].reshape(B, P).mean(1) * up.float()
        self._cap_t.copy_(cap)
        F.per.copy_(self._fused_profile * (self.dish_area * self.RHO * cap * soil_eff)[:, None])

    def _gpu_full_step(self, actions):
        B = self.num_agents
        if self._gpu is None:
            from tandoor_fused_step import make_state
            self._gpu = make_state(self)
        F = self._gpu
        if not getattr(F, "fused", False):
            raise RuntimeError("HashemiTandoorEnv gpu=1 needs the fused Metal step (MPS)")
        a = actions if torch.is_tensor(actions) else torch.as_tensor(np.asarray(actions, dtype=np.float32), device=self.device)
        a = a.reshape(B, self.N_HEADS)
        c_az = (a[:, 3].float().clamp(0, 6) - 3) / 3.0
        c_el = (a[:, 4].float().clamp(0, 6) - 3) / 3.0
        cmd = torch.stack([c_az * self._om_full, -c_el * self._od_full], 1)
        el0, az0 = self._sun()
        sun = torch.tensor([np.radians(el0), az0, 800.0], dtype=torch.float32, device=self.device).expand(B, 3)
        out = self._hk.step(self._st, cmd, float(self.dt), sun, self._prm)
        self._st[:, 0] = out[:, COL["az_next"]]
        self._st[:, 1] = out[:, COL["t_next"]]
        self._st[:, 2] = out[:, COL["slack_next"]]
        F.el_m.copy_(90.0 - torch.rad2deg(self._st[:, 1]))
        F.az_m.copy_(torch.rad2deg(self._st[:, 0]))
        F.el_dish.copy_(F.el_m)
        neutral = a.clone()
        neutral[:, 3] = 3
        neutral[:, 4] = 3
        neutral[:, 0] = 4          # the level head pinned (his dish has no membrane)
        neutral[:, 2] = 6          # the jam head held on (the parent gates the beam by `jammed`)
        t_before = float(self.t_solar[0])
        from tandoor_fused_step import fused_full_step
        res = fused_full_step(self, neutral)
        # a cut agent's motors were re-parked by step_post, every agent's at day over: the
        # Lean state follows the parent's motors there, as on the numpy path
        mask = F.trunc > 0.5
        if float(self.t_solar[0]) < t_before - 1.0:
            mask = torch.ones_like(mask, dtype=torch.bool)
        az_p = torch.deg2rad(F.az_m)
        t_p = torch.deg2rad(90.0 - F.el_m).clamp(0.0, self.t_dead)
        self._st[:, 0] = torch.where(mask, az_p, self._st[:, 0])
        self._st[:, 1] = torch.where(mask, t_p, self._st[:, 1])
        self._st[:, 2] = torch.where(mask, torch.zeros_like(t_p), self._st[:, 2])
        return res

    def _fold_errors(self, rays11):
        """the sampler's four normal draws folded into the ray's direction as one Gaussian tilt of
        sqrt((2 s_slope)^2 + s_spec^2) - the same fold the device sampler makes (hk_traceRayK
        takes the conic constant but no optical errors; hk_traceRayErr takes the errors on the
        sphere only). Returns the 7-wide rays hashemi_trace_k reads."""
        r = np.asarray(rays11, dtype=np.float64)
        s = r[:, 4:7]
        helper = np.where(np.abs(s[:, 2:3]) < 0.9, np.array([0.0, 0.0, 1.0]), np.array([1.0, 0.0, 0.0]))
        e1 = np.cross(s, helper); e1 /= np.linalg.norm(e1, axis=-1, keepdims=True)
        e2 = np.cross(s, e1)
        sig = np.sqrt((2 * self.SLOPE_ERR) ** 2 + self.SPEC_ERR ** 2)
        d = s + sig * (r[:, 7:8] * e1 + r[:, 8:9] * e2)
        d /= np.linalg.norm(d, axis=-1, keepdims=True)
        return np.concatenate([r[:, :4], d], 1).astype(np.float32)

    # --- the step: the machine from the megakernel, everything else the parent's
    def step(self, actions):
        if self.gpu and self._metal is not None:
            res = super().step(actions)              # routes through _gpu_full_step above
            self.cap_traced = self._cap_t.cpu().numpy().astype(np.float64)
            self.hk_state[:] = self._st.cpu().numpy()
            self.el_m = 90.0 - np.degrees(self.hk_state[:, 1])       # host mirrors for the eval path
            self.az_m = np.degrees(self.hk_state[:, 0])
            return res
        B = self.num_agents
        a = np.asarray(actions).reshape(B, self.N_HEADS)
        c_az = (np.clip(a[:, 3], 0, 6) - 3) / 3.0
        c_el = (np.clip(a[:, 4], 0, 6) - 3) / 3.0
        cmd = np.stack([c_az * self._om_full, -c_el * self._od_full], 1)
        el0, az0 = self._sun()
        sun = np.broadcast_to(np.array([np.radians(el0), az0, 800.0]), (B, 3)).copy()
        out = self._hk.step(self._st, torch.as_tensor(cmd, dtype=torch.float32, device="mps"), float(self.dt),
                            torch.as_tensor(sun, dtype=torch.float32, device="mps"), self._prm)
        self.hk_row = out.cpu().numpy().astype(np.float64)
        self.hk_state[:, 0] = self.hk_row[:, COL["az_next"]]
        self.hk_state[:, 1] = self.hk_row[:, COL["t_next"]]
        self.hk_state[:, 2] = self.hk_row[:, COL["slack_next"]]
        self.el_m = 90.0 - np.degrees(self.hk_state[:, 1])
        self.az_m = np.degrees(self.hk_state[:, 0])
        neutral = np.array(np.round(a), dtype=np.int64)
        neutral[:, 3] = 3
        neutral[:, 4] = 3
        # his dish has no membrane to pump or lock: the parent's level head is pinned at the design
        # level and its jam head held on, so the beam always counts (the parent gates by `jammed`)
        neutral[:, 0] = 4
        neutral[:, 2] = 6
        t_before = float(self.t_solar[0])
        res = super().step(neutral)
        wrapped = float(self.t_solar[0]) < t_before - 1.0
        resync = np.asarray(self.truncations, dtype=bool).copy()
        if wrapped:
            resync[:] = True
        self._sync_from_motors(resync)
        return res

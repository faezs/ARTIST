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
from hashemi_trace_kernel import (HashemiTraceMetal, dish_numpy, trace_params_numpy,   # noqa: E402
                                  DISH_OUT_W, SUN_HALF_ANGLE)


class HashemiTandoorEnv(TandoorHashemiEnv):
    """the tandoor with his concentrator: pose and power from the compiled Hashemi.lean"""

    DISH_K = -1.0            # the panel as the frames show it: a satellite dish (a paraboloid)
    SLOPE_ERR = 2e-3         # rad, the tiles' slope error (SolTrace's model)
    SPEC_ERR = 1e-3
    RHO = 0.85               # the mosaic's reflectance (megaParams)
    RC_INLET = 0.06          # the pot's aperture at F, his 12 cm coil's size

    def __init__(self, *args, trace_rays=64, lost_shaping=0.02, **kwargs):
        # gpu=0: the parent's numpy step, the trace on Metal (the eval/bench path);
        # gpu=1: the parent's fused Metal step with the trace injected (the training path)
        self._fused_profile = None
        self._prm_np = mega_params_numpy()
        rest = mega_numpy(np.zeros((1, 3)), np.zeros((1, 2)), 0.0, np.array([[0.5, 0.0, 800.0]]), self._prm_np)
        self.t_dead = float(rest[0, COL["t_dead"]])
        # THE PARENT'S DAY AND CUT PULLED BACK ALONG THE SPEC'S Ω-COLUMNS: the megakernel's
        # `sun_reachable` (SunReachable: π/2 - tDead ≤ elSun) and `lost_sun` (LostSun: reachable
        # and the pointing error past the 1.7° budget). The parent gates its beam and its
        # guillotine by el_min and lost_deg, its own knobs; they are set here to the spec's
        # constants so the parent's flags coincide with the compiled columns, and the day test
        # checks that coincidence step by step (lost_sun vs the parent's lost counter).
        kwargs.setdefault("el_min", 90.0 - np.degrees(self.t_dead))
        kwargs.setdefault("lost_deg", np.degrees(0.03))
        # THE GATE AS A GRADIENT: `lost_sun_s` (lostSunS, the smooth gate with the slope the
        # theorems state: 1/(4 tau) per radian) charged per step at `lost_shaping`, so the cook
        # feels the sun slipping before the parent's guillotine falls (40 steps lost -> a cut).
        # 0.02/step over a 1921-step day is the order of the parent's cut penalty (40) spread out.
        self.lost_shaping = float(lost_shaping)
        super().__init__(*args, **kwargs)
        B = self.num_agents
        self.trace_rays = int(trace_rays)
        self._hk = HashemiMetal()
        self._tr = HashemiTraceMetal()
        self._prm = torch.as_tensor(mega_params_numpy(), dtype=torch.float32, device="mps")
        self._trace_prm = trace_params_numpy()
        self._st = torch.zeros(B, 3, dtype=torch.float32, device="mps")
        self.hk_state = np.zeros((B, 3))
        rest = mega_numpy(np.zeros((B, 3)), np.zeros((B, 2)), 0.0, np.array([[0.5, 0.0, 800.0]] * B), self._prm_np)
        self.hk_row = rest
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

    # ------------------------------------------------------------------ the optics: ONE morphism
    # `dishPower` of HashemiTrace.lean is the sampler, the conic trace with the optical errors and
    # the delivery as one arrow, draws x pose x sun x parameters -> (captured, m^2 per unit DNI,
    # fate). Ccc carries it to the C twin (the numpy path) and to Metal (the fused path); the host
    # supplies the draws and takes the mean over the rays. Nothing optical is written here.
    def _dish_prm(self):
        return np.concatenate([self._trace_prm[:5], [self.DISH_K, self.SLOPE_ERR, self.SPEC_ERR, self.RHO, SUN_HALF_ANGLE]]
                              ).astype(np.float32)

    def _profile_from(self, per0, lib):
        """the receiver's node profile from the parent's own trace (its beam's split over the floor and belt)"""
        tot = per0.sum(1, keepdims=True) if lib is np else per0.sum(1, keepdim=True)
        prof = lib.where(tot > 0, per0 / (lib.maximum(tot, 1e-9) if lib is np else tot.clamp_min(1e-9)), 0.0 * per0)
        uni = lib.zeros(per0.shape[1]) if lib is np else torch.zeros(per0.shape[1], device=per0.device)
        uni[:self.n_nodes] = 1.0 / self.n_nodes
        ok = (prof.sum(1, keepdims=True) if lib is np else prof.sum(1, keepdim=True)) > 0
        return lib.where(ok, prof, uni[None, :])

    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        """the numpy path: the C twin of `dishPower` over numpy draws"""
        B, P = self.num_agents, self.trace_rays
        if self._beam_profile is None:
            self._beam_profile = self._profile_from(super()._trace_power(p_eff, sigma_b, offset_w, soil).numpy(), np)
        el0, az0 = self._sun()
        if el0 < self.el_min_h:
            self.cap_traced[:] = 0.0
            return torch.zeros(B, self._beam_profile.shape[1])
        pose = np.stack([self.hk_state[:, 0], self.hk_state[:, 1], np.full(B, np.radians(el0)), np.full(B, az0)], 1)
        draws = np.concatenate([self.rng.random((B * P, 6)), self.rng.standard_normal((B * P, 4))], 1)
        out = dish_numpy(self._dish_prm(), pose, draws, P).reshape(B, P, DISH_OUT_W)
        self.cap_traced = out[:, :, 0].mean(1)
        per = (out[:, :, 1].mean(1) * np.asarray(soil, dtype=np.float64))[:, None] * self._beam_profile
        return torch.as_tensor(per, dtype=torch.float32)

    def _fused_power(self, F, aux, soil_eff):
        """the fused path: the Metal kernel of `dishPower` over device draws; called by tandoor_fused_step"""
        B, P, dev = self.num_agents, self.trace_rays, F.per.device
        if self._fused_profile is None:
            self._fused_profile = self._profile_from(F.per.clone(), torch)
            self._cap_t = torch.zeros(B, device=dev)
            self._dish_buf = (torch.as_tensor(self._dish_prm(), device=dev),
                              torch.empty(B, 4, dtype=torch.float32, device=dev),
                              torch.empty(B * P, DISH_OUT_W, dtype=torch.float32, device=dev))
        prm, pose, out = self._dish_buf
        pose[:, 0] = self._st[:, 0]
        pose[:, 1] = self._st[:, 1]
        pose[:, 2] = torch.deg2rad(aux[:, 0])           # the mount's per-agent sun: el deg, az rad
        pose[:, 3] = aux[:, 1]
        g = self._gen
        draws = torch.cat([torch.rand(B * P, 6, generator=g, device=dev), torch.randn(B * P, 4, generator=g, device=dev)], 1)
        self._tr.dish(prm, pose, draws, out, P)
        o = out.reshape(B, P, DISH_OUT_W)
        up = (aux[:, 0] > self.el_min_h).float()
        self._cap_t.copy_(o[:, :, 0].mean(1) * up)
        F.per.copy_(self._fused_profile * (o[:, :, 1].mean(1) * up * soil_eff)[:, None])

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
        self._hk_out = out
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
        obs_t, rew_t, infos = fused_full_step(self, neutral)
        if self.lost_shaping:
            rew_t = rew_t - self.lost_shaping * self._hk_out[:, COL["lost_sun_s"]]
        res = (obs_t, rew_t, infos)
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

    def step(self, actions):
        if self.gpu and self._metal is not None:
            res = super().step(actions)              # routes through _gpu_full_step above
            self.cap_traced = self._cap_t.cpu().numpy().astype(np.float64)
            self.hk_state[:] = self._st.cpu().numpy()
            self.hk_row = self._hk_out.cpu().numpy().astype(np.float64)   # the kernel's columns (spec checks read them)
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
        if self.lost_shaping:
            self.rewards[:] = self.rewards - self.lost_shaping * self.hk_row[:, COL["lost_sun_s"]]
        wrapped = float(self.t_solar[0]) < t_before - 1.0
        resync = np.asarray(self.truncations, dtype=bool).copy()
        if wrapped:
            resync[:] = True
        self._sync_from_motors(resync)
        return res

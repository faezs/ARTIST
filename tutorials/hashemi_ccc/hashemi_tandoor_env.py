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
                                  RAY_W, OUT_W)


class HashemiTandoorEnv(TandoorHashemiEnv):
    """the tandoor with his concentrator: pose and power from the compiled Hashemi.lean"""

    DISH_K = -1.0            # the panel as the frames show it: a satellite dish (a paraboloid)
    SLOPE_ERR = 2e-3         # rad, the tiles' slope error (SolTrace's model)
    SPEC_ERR = 1e-3
    RHO = 0.85               # the mosaic's reflectance (megaParams)
    RC_INLET = 0.06          # the pot's aperture at F, his 12 cm coil's size

    def __init__(self, *args, trace_rays=64, **kwargs):
        kwargs["gpu"] = 0                     # the parent's numpy step: its pot, bread and reward; the trace on Metal
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
        prm = torch.as_tensor(np.concatenate([self._trace_prm[:5], [self.DISH_K]]), dtype=torch.float32, device="mps")
        out = torch.empty(B * P, OUT_W, dtype=torch.float32, device="mps")
        self._tr.lib.hashemi_trace_k(torch.as_tensor(rays[:, :RAY_W], device="mps").contiguous(), prm, out,
                                     torch.tensor([B * P], dtype=torch.int32, device="mps"))
        self.cap_traced = out[:, 3].reshape(B, P).mean(1).cpu().numpy().astype(np.float64)
        # per unit DNI, as the parent expects: m^2 of aperture delivered, split along the beam profile
        per = (self.dish_area * self.RHO * self.cap_traced)[:, None] * self._beam_profile
        return torch.as_tensor(per, dtype=torch.float32)

    # --- the step: the machine from the megakernel, everything else the parent's
    def step(self, actions):
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

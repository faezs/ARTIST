"""His concentrator on the tandoor: the puffer env that competes on rotis per day.

The tandoor env (tandoor_hashemi_env.TandoorHashemiEnv) is kept whole - its pot, wall chain,
bread, guillotine, observations and reward are the code puffer_hashemi and puffer_flower score
on, and their laws are already checked in Lean. His machine is ONE Lean definition,
`hashemiEnv` (HashemiEnv.lean), extracted by Ccc into ONE Metal kernel (`hashemi_env`):

  * the mount: `megaStep` advances (az, t, slack) - the wire's length as the state's carrier, the
    dead point, the winch gated by HoldsDish - from the two motor heads;
  * the optics: on the new pose, 64 rays of `dishPower` (the sampler, the conic trace with the
    optical errors at the surface, the delivery) are the tensor power of one morphism and their
    sum the reduction - one thread per ray, the sum in threadgroup memory;
  * the heat: `heatStep` - the copper coil at F absorbs, an unglazed coil loses, insulated
    copper pipes lose, the exchanger in the pot's wall delivers `UAx (Toil - Twall)` to the
    oven, the oil's temperature is the state (HashemiHeat.lean: the steady state exists and is
    unique, the pot never takes more than the coil absorbed, the step's modulus is proved).

The parent's pot takes the exchanger's power through its own gate: `per_dni x gate x 0.85` is
what its nodes absorb, so `per = q_pot / (gate x 0.85)` along the beam's node profile, and the
exchanger's `UAx` is opened only while that gate is open (the shutter is the valve; the beam
gate closes at night, so heat left in the oil after sunset is not delivered - 1.3 MJ, under an
hour of the pot's need). The host supplies the draws, the launch, and the host mirrors the
parent's readers expect. Nothing optical or thermal is computed here.

`puffer train puffer_hashemi_ccc` runs it (gpu = 1: the parent's fused Metal step); the metric
is the parent's rotis.
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
from hashemi_kernel import COL, mega_numpy, mega_params_numpy                       # noqa: E402
from hashemi_env_kernel import (HashemiEnvMetal, env_numpy, env_params, pack, draws,   # noqa: E402
                                ECOL, EIN, N_IN, N_OUT, P as ENV_RAYS, M as ENV_M, N_HIST, HIST_COLS, RET_COLS)
# THE REWARD IS A PRINTED MORPHISM TOO (HashemiReward.lean `rewardStep`, compiled by the same
# driver): its three columns are r_shape_raw, r_raw, r_trainer and its constants - reward_div,
# capture_shaping, the raw price of a roti, roti_energy - are INPUTS, so the ini's values are
# handed to the kernel instead of being arithmetic on a host.
from hashemi_reward_kernel import (HashemiRewardMetal, pack_reward, reward_numpy,   # noqa: E402
                                   RCOL, RIN, N_IN as R_N_IN)
import json                                         # noqa: E402
# THE POLICY DESCRIPTION IS THE SPEC'S (HashemiPolicy.lean, written out by the driver): which
# heads are the motors, how many levels, and the drives a head's value means (headToDriveAz /
# headToDriveEl, compiled - here through the NumPy twin, exactly the kernel's functions)
POLICY = json.load(open(os.path.join(HERE, "hashemi_policy.json")))
HEAD_AZ, HEAD_EL = POLICY["motor_heads"]
import hashemi_policy as machine_policy              # noqa: E402  the generated spaces module
OBS_COLS = [ECOL["obs_" + n] for n in machine_policy.OBS_NAMES]


class HashemiTandoorEnv(TandoorHashemiEnv):
    """the tandoor with his concentrator: the machine from one compiled morphism"""

    def __init__(self, *args, lost_shaping=0.0, pointing_shaping=0.0, capture_shaping=0.2, t_amb=300.0, trace_rays=None,
                 machine_receiver="oil", oil_nodes=8, dish_half=None, dish_R=None, beam_L=1.25, beam_dm=0.06, beam_rm=0.06, beam_rt=0.55, beam_slot=0.06, beam_beta=0.0, **kwargs):
        # THE MACHINE'S RECEIVER (the parent's `receiver` - its tri chain - passes through untouched):
        # "oil" - the coil at F, hot oil in insulated pipes, the exchanger in the pot's wall
        # (HashemiHeat/HashemiField.lean); "beam" - a hyperboloid inside the coil's envelope sending
        # the beam down through the slot into the tunnel to the pot (HashemiBeamdown.lean): the
        # parent's pot takes the beam directly, per unit DNI, as its own tri chain would
        self.machine_receiver = str(machine_receiver)
        # THE EXCHANGER'S PROFILE IS DEFINED, NOT INHERITED. The coil in the pot's wall
        # (HashemiHeat.lean qPot = UAx (Toil - Twall)) heats the wall band the bread is slapped on:
        # the first `oil_nodes` belt slots, uniformly (8 = the whole band; fewer = a hot plate under
        # k slots), nothing on the loaf columns (no beam on the bread's face). Until 2026-09-19 the
        # profile was the parent's own tri-chain spot frozen at the first step: on day 172 that put
        # 74 % of the pot's power into ONE slot (which then baked, 61 a day from that slot), on day 80
        # it spread it over all 15 nodes (nothing reached 380 K, 0 a day) - the trainer's zero.
        # The beam receiver keeps the parent's live landing profile every step.
        self.oil_nodes = int(oil_nodes)
        self.beam_design = dict(L=beam_L, dm=beam_dm, rm=beam_rm, rt=beam_rt, slotW=beam_slot, beta=beam_beta)
        # trace_rays: accepted for the ini's sake; the rays are the spec's (HashemiEnv.lean `envRays`, 64)
        if trace_rays is not None and int(trace_rays) != ENV_RAYS:
            print(f"  [hashemi_ccc] trace_rays={trace_rays} ignored: the megakernel's rays are the spec's {ENV_RAYS}")
        # gpu=0: the parent's numpy step, the machine through the C twin of the same graph;
        # gpu=1: the parent's fused Metal step, the machine through the Metal megakernel
        self._fused_profile = None
        self._beam_profile = None
        self._prm_np = mega_params_numpy()
        rest = mega_numpy(np.zeros((1, 3)), np.zeros((1, 2)), 0.0, np.array([[0.5, 0.0, 800.0]]), self._prm_np)
        self.t_dead = float(rest[0, COL["t_dead"]])
        self.dish_area = float(rest[0, COL["dishSide"]]) ** 2
        # THE PARENT'S DAY AND CUT PULLED BACK ALONG THE SPEC'S Ω-COLUMNS: `sun_reachable`
        # (SunReachable: π/2 - tDead ≤ elSun) and `lost_sun` (LostSun: reachable and the pointing
        # error past the 1.7° budget). The parent gates its beam and its guillotine by el_min and
        # lost_deg, its own knobs; set to the spec's constants so its flags coincide with the
        # compiled columns (the day test counts that coincidence step by step)
        kwargs.setdefault("el_min", 90.0 - np.degrees(self.t_dead))
        # lost_deg stays the parent's (the ini's 5 deg): the guillotine is the cook's training
        # device; the receiver's 1.7 deg budget is the spec's `lost_sun` column, felt through the
        # capture itself and the smooth gate's shaping. (Set to 1.7 deg once: with a discrete
        # policy no episode survived the day.)
        # THE POLICY LEARNS TO POINT (no sensor closes the loop), and THE REWARD IS A PRINTED
        # MORPHISM: `rewardStep` (HashemiReward.lean, compiled by the same driver as the physics)
        # takes the parent's raw reward for the step, the step, `p_in` and `sun_reachable`, and
        # the ini's constants as INPUTS, and returns r_shape_raw / r_raw / r_trainer. Both paths
        # read those columns (`_reward_cols`), so `reward_div` is applied ONCE, inside the
        # function, and the two paths cannot disagree about units - the gluing condition of
        # TOPOS_REWARD.md, measured per step by test_reward_columns.py (R1-R3).
        # (Until 2026-09-19 the pointing penalty went in raw on the fused path and divided on the
        # numpy path: the trainer saw 1/75 of what the day test showed, and the policy drifted to
        # a 1.4 deg lag; and a per-step PENALTY makes the guillotine an exit - at 0.5 per rad a
        # day at 4 deg costs 66 against a cut of 1 in the trainer's units, and the epoch-260
        # policy rode the 5 deg cliff and left at noon.)
        #   capture_shaping: the light arriving at the receiver (`p_in`, the spec's column, W) as
        #   energy per step in roti units (roti_energy), paid capture_shaping x 5 per roti's worth.
        #   Delay-free (the oil loop lags minutes, the rotis hours), physical, non-negative: a
        #   policy that points earns it every step, so being cut never pays. At 0.2 a pointed day
        #   (~3 kW x 15 s / 130 kJ = 0.35 roti of light a step, ~1700 steps) earns ~120 raw, its
        #   70-80 rotis at 5 each ~375: the light is a fifth of the roti it could become.
        #   pointing_shaping: potential-based, k (phi - phi_prev) with phi = -min(pointing_err, 0.5 rad),
        #   only while the sun is reachable, zero on a resynced step and the one after: it
        #   telescopes, cannot be farmed, and adds nothing the parent's own term does not; off.
        #   lost_shaping: the smooth gate `lost_sun_s`, saturated beyond ~3 deg; off.
        self.lost_shaping = float(lost_shaping)
        self.pointing_shaping = float(pointing_shaping)
        self.capture_shaping = float(capture_shaping)
        self._phi_prev = self._phi_prev_t = None
        self._pb_skip = self._pb_skip_t = None
        self._rew = None                      # the reward kernel (fused path)
        self.t_amb = float(t_amb)
        super().__init__(*args, **kwargs)
        B = self.num_agents
        self._params = env_params()
        # THE REFLECTOR'S EXTENT (user, 2026-09-20): the panel is the square section of half-side
        # `a` cut from the sphere of radius `R` (built as a plaster mould off a curved rod, an iron
        # frame and a fibre-resin skin with mirror facets or Mylar); his numbers a = 0.8, R = 2
        # (f = R/2). dish_half sets a from the ini; dish_R the sphere, default his proportion
        # a/R = 0.4 so the cap stays a cap. The facets (w) and the coil (rc) are unchanged, the
        # slot is the mount's; there is no aperture. Both receivers take the same optics.
        if dish_half is not None:
            a = float(dish_half)
            R = float(dish_R) if dish_R is not None else a / 0.4
            self._params.update(a=a, R=R, f=R / 2.0)
            self.beam_design.update(a=a, R=R, f=R / 2.0)
        self.dish_area = (2.0 * float(self._params["a"])) ** 2
        self.hk_state = np.zeros((B, 3))
        self.t_oil = np.full(B, self.t_amb)
        # THE OIL'S STATE IS THE FIELD ALONG THE PIPE: the coil's outlet and the exchanger's outlet
        # over the last 16 steps (HashemiField.lean `shift`, the plug-flow kernel on the grid)
        self.hist = np.full((B, N_HIST), self.t_amb)
        self.ret = np.full((B, N_HIST), self.t_amb)
        self.row = np.zeros((B, N_OUT))              # the last step's 27 columns (host mirror)
        self.hk_row = self.row
        self.cap_traced = np.zeros(B)
        self._q_pot = np.zeros(B)
        # the printed reward's columns for the last step (host mirrors, what the checks read)
        self.r_cols = np.zeros((B, 3))
        # THE HEADS MEAN WHAT THE SPEC SAYS: HashemiPolicy.lean's headToDriveAz / headToDriveEl
        # (full command = azFull / elFull of the dish, the drum's rate at the wire's CURRENT lever
        # arm), compiled; the finest step outruns the sun and stays inside the tracker's budget
        # by theorem (quantum_outruns_sun, quantum_within_budget). The twin is the kernel's
        # function; the fused path evaluates the same formula on the device.
        import hashemi_ccc as H
        self._rw, self._R = 0.05, float(rest[0, COL["rollerRadius"]])     # hashemi.rDrive (the frames' 5 cm roller), rollerRadius hashemi
        self._az_full = float(H.hk_azFull())            # rad/s of the dish at full command
        self._el_full_rate = float(H.hk_elFull())
        self._om_full = self._az_full * self._R / self._rw               # headToDriveAz at u = 1
        self._el_full = self._el_full_rate / float(self._prm_np[0])       # x arm = headToDriveEl at u = -1 (the head's sense)
        self._arm0 = 1.03
        # the machine's own interface (HashemiPolicy.lean through the generated module): the
        # observation Box and the command Box; `machine_obs` is the kernel's observation columns
        self.machine_observation_space = machine_policy.observation_space()
        self.machine_action_space = machine_policy.action_space()
        self.machine_obs = np.zeros((B, machine_policy.N_OBS), dtype=np.float32)
        self._env = None
        self._rew_x = None
        if self.machine_receiver == "beam":
            import hashemi_beam_kernel as _bk
            self._bk = _bk
        if self.gpu and self._metal is not None:
            dev = "mps"
            if self.machine_receiver == "beam":
                self._env = self._bk.HashemiBeamMetal()
                x = self._bk.pack_beam(B, np.zeros((B, 3)), np.zeros((B, 2)), float(self.dt), np.zeros((B, 3)), np.ones(B), self.beam_design)
            else:
                self._env = HashemiEnvMetal()
                x = pack(B, np.zeros((B, 3)), np.zeros((B, 2)), float(self.dt), np.zeros((B, 3)), np.ones(B),
                         np.full(B, self.t_amb), self.t_amb, self._params)
            self._x = torch.as_tensor(x.astype(np.float32), device=dev)
            self._st = torch.zeros(B, 3, dtype=torch.float32, device=dev)
            self._hist = torch.full((B, N_HIST), self.t_amb, dtype=torch.float32, device=dev)
            self._ret = torch.full((B, N_HIST), self.t_amb, dtype=torch.float32, device=dev)
            self._q_pot_t = torch.zeros(B, dtype=torch.float32, device=dev)
            self._cap_t = torch.zeros(B, dtype=torch.float32, device=dev)
            self._hk_out = torch.zeros(B, N_OUT, dtype=torch.float32, device=dev)
            self._uax = float(self._params["UAx"])
            self._rew = HashemiRewardMetal()
            self._rew_x = torch.zeros(B, R_N_IN, dtype=torch.float32, device=dev)
            self._rew_cols_t = None

    # --- the parent's sag model is not this machine's: the dish's elevation is the Lean state
    def el_dish_deg(self, el_m, wind):
        return np.asarray(el_m, dtype=np.float64)

    def el_dish_t(self, el_m, wind):
        return el_m

    def _sun(self):
        """the sun now: elevation (rad), azimuth (rad, the mount's frame)"""
        import tandoor_hashemi_env as _m
        el0, az0, _ = _m._sim.solar_position(self.lat, self.day, float(self.t_solar[0]))
        return float(np.radians(el0)), float(az0)

    def _sync_from_motors(self, mask):
        """a cut agent's motors were re-parked by the parent: the Lean state follows"""
        mask = np.asarray(mask, dtype=bool)
        if not mask.any():
            return
        self.hk_state[mask, 0] = np.radians(np.asarray(self.az_m, dtype=np.float64)[mask])
        t = np.radians(90.0 - np.asarray(self.el_m, dtype=np.float64)[mask])
        self.hk_state[mask, 1] = np.clip(t, 0.0, self.t_dead)
        self.hk_state[mask, 2] = 0.0
        self.el_m = np.asarray(self.el_m, dtype=np.float64)
        self.el_m[mask] = 90.0 - np.degrees(self.hk_state[mask, 1])
        if self._env is not None:
            self._st.copy_(torch.as_tensor(self.hk_state, dtype=torch.float32))

    def reset(self, *args, **kwargs):
        res = super().reset(*args, **kwargs)
        self._phi_prev = self._phi_prev_t = None
        self._pb_skip = self._pb_skip_t = None
        self._sync_from_motors(np.ones(self.num_agents, dtype=bool))
        self.t_oil[:] = self.t_amb
        self.hist[:] = self.t_amb
        self.ret[:] = self.t_amb
        if self._env is not None:
            self._hist.fill_(self.t_amb)
            self._ret.fill_(self.t_amb)
        return res

    # --- the beam's node profile: where the parent's own trace puts the pot's power
    def _profile_from(self, per0, lib):
        tot = per0.sum(1, keepdims=True) if lib is np else per0.sum(1, keepdim=True)
        prof = lib.where(tot > 0, per0 / (lib.maximum(tot, 1e-9) if lib is np else tot.clamp_min(1e-9)), 0.0 * per0)
        uni = lib.zeros(per0.shape[1]) if lib is np else torch.zeros(per0.shape[1], device=per0.device)
        uni[:self.n_nodes] = 1.0 / self.n_nodes
        ok = (prof.sum(1, keepdims=True) if lib is np else prof.sum(1, keepdim=True)) > 0
        return lib.where(ok, prof, uni[None, :])

    # ------------------------------------------------------------------ the numpy path
    def _oil_profile(self, lib, dev=None):
        """uniform over the first oil_nodes belt slots, zero elsewhere (N nodes + n_belt loaf columns)"""
        k = max(1, min(self.oil_nodes, self.n_belt))
        w = self.n_nodes + self.n_belt
        prof = np.zeros((self.num_agents, w)); prof[:, :k] = 1.0 / k
        return prof if lib is np else torch.as_tensor(prof, dtype=torch.float32, device=dev)

    def _valve_np(self):
        """the parent's beam gate, as it will compute it this step: dni x cos x shutter x jammed"""
        el_deg = np.degrees(self._sun()[0])
        cosf = 1.0 if el_deg > 8.0 else 0.0
        return np.asarray(self.dni, dtype=np.float64) * cosf * np.asarray(self.shutter, dtype=np.float64) \
            * np.asarray(self.jammed, dtype=np.float64)

    ROTI_REWARD_RAW = 5.0        # tandoor_rl_env: rew += 5.0 * cooked

    def _pb_raw(self, pe, reach, resync, xp):
        """the OPTIONAL potential-based pointing term, in the parent's raw units. It is not part
        of the printed morphism: it is a coboundary (RewardTopos.lean `shaping_telescopes`), it
        carries no units of its own beyond the raw reward's, and it is off (`pointing_shaping`
        = 0) in every ini. When it is on it is folded into the morphism's `parentRaw` input, so
        the division still happens once, in the printed function."""
        if not self.pointing_shaping:
            return 0.0
        if xp is np:
            phi = -np.minimum(pe, 0.5)
            prev = phi if self._phi_prev is None else self._phi_prev
            skip = resync if self._pb_skip is None else (resync | self._pb_skip)
            pb = np.where(skip, 0.0, self.pointing_shaping * (phi - prev) * reach)
            self._phi_prev = phi.copy(); self._pb_skip = np.asarray(resync, dtype=bool).copy()
        else:
            phi = -pe.clamp(max=0.5)
            prev = phi if self._phi_prev_t is None else self._phi_prev_t
            skip = resync if self._pb_skip_t is None else (resync | self._pb_skip_t)
            pb = torch.where(skip, torch.zeros_like(phi), self.pointing_shaping * (phi - prev) * reach)
            self._phi_prev_t = phi.clone(); self._pb_skip_t = resync.clone()
        return pb

    def _reward_cols(self, parent_raw, p_in, reach, xp):
        """THE REWARD, PRINTED (`rewardStep`, HashemiReward.lean): the three columns
        r_shape_raw, r_raw, r_trainer for this step, from the parent's raw reward, the step, the
        light at the receiver and the sun's reach - with the ini's constants as INPUTS
        (reward_div, capture_shaping, the raw price of a roti, roti_energy). The NumPy twin and
        the Metal kernel are the same graph, so the two paths cannot disagree on the units: that
        is the gluing condition of TOPOS_REWARD.md §1, and the bug of 2026-09-19 was its failure."""
        div = float(getattr(self, "reward_div", 1.0))
        cs, rr, re = float(self.capture_shaping), float(self.ROTI_REWARD_RAW), float(self.roti_energy)
        if xp is np:
            x = pack_reward(np.asarray(parent_raw, dtype=np.float64), float(self.dt),
                            np.asarray(p_in, dtype=np.float64), np.asarray(reach, dtype=np.float64),
                            div, cs, rr, re)
            cols = reward_numpy(x)
            self.r_cols = cols
            return cols
        x = self._rew_x
        x[:, RIN["parentRaw"]] = parent_raw
        x[:, RIN["dt"]] = float(self.dt)
        x[:, RIN["pIn"]] = p_in
        x[:, RIN["reach"]] = reach
        x[:, RIN["rewardDiv"]] = div
        x[:, RIN["capShaping"]] = cs
        x[:, RIN["rotiReward"]] = rr
        x[:, RIN["rotiEnergy"]] = re
        cols = self._rew.step(x)
        self._rew_cols_t = cols
        return cols

    def _run_np(self, a):
        """one launch of the C twin: the pose, the capture, the oil, the pot's heat"""
        B = self.num_agents
        import hashemi_ccc as H
        arm = np.maximum(self.row[:, ECOL["arm"]], 0.05) if self.row[:, ECOL["arm"]].any() else np.full(B, self._arm0)
        cmd = np.stack([np.asarray(H.hk_headToDriveAz(a[:, HEAD_AZ], np.full(B, self._rw), np.full(B, self._R)), dtype=np.float64),
                        np.asarray(H.hk_headToDriveEl(a[:, HEAD_EL], arm, np.full(B, float(self._prm_np[0]))), dtype=np.float64)], 1)
        el, az = self._sun()
        sun = np.stack([np.full(B, el), np.full(B, az), np.asarray(self.dni, dtype=np.float64)], 1)
        if self.machine_receiver != "beam" and self._beam_profile is None:
            self._beam_profile = self._oil_profile(np)
        if self._beam_profile is None:
            twall = self.T[:, :self.n_nodes].mean(1)
        else:
            pn = self._beam_profile[:, :self.n_nodes]
            twall = (self.T[:, :self.n_nodes] * pn).sum(1) / np.maximum(pn.sum(1), 1e-9)
        dr = draws(self.rng, B)
        if self.machine_receiver == "beam":
            x = self._bk.pack_beam(B, self.hk_state, cmd, float(self.dt), sun, np.asarray(self.soil, dtype=np.float64), self.beam_design)
            self.row = self._bk.beam_numpy(x, dr)
        else:
            x = pack(B, self.hk_state, cmd, float(self.dt), sun, np.asarray(self.soil, dtype=np.float64),
                     twall, self.t_amb, self._params)
            x[:, EIN["UAx"]] *= (self._valve_np() > 0)            # the exchanger opens with the beam gate
            self.row = env_numpy(x, self.hist, self.ret, dr)
            self.hist = self.row[:, HIST_COLS].copy()
            self.ret = self.row[:, RET_COLS].copy()
        self.hk_row = self.row
        C = self._bk.BCOL if self.machine_receiver == "beam" else ECOL
        self.hk_state[:, 0] = self.row[:, C["az_next"]]
        self.hk_state[:, 1] = self.row[:, C["t_next"]]
        self.hk_state[:, 2] = self.row[:, C["slack_next"]]
        self.cap_traced = self.row[:, C["capture"]].copy()
        if self.machine_receiver == "beam":
            self._per_beam = self.row[:, C["per_dni"]].copy()
        else:
            self.t_oil = self.row[:, C["T_oil"]].copy()
            self._q_pot = self.row[:, C["q_pot"]].copy()
        self.machine_obs = self.row[:, [C["obs_" + n] for n in machine_policy.OBS_NAMES]].astype(np.float32)
        self.el_m = 90.0 - np.degrees(self.hk_state[:, 1])
        self.az_m = np.degrees(self.hk_state[:, 0])

    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        """the numpy path: the exchanger's power to the pot, as the parent's per-unit-DNI aperture"""
        B = self.num_agents
        if self.machine_receiver == "beam":                            # the beam itself: aperture per unit DNI,
            self._beam_profile = self._profile_from(super()._trace_power(p_eff, sigma_b, offset_w, soil).numpy(), np)
            return torch.as_tensor(self._per_beam[:, None] * self._beam_profile, dtype=torch.float32)   # where the parent's trace lands it, live
        if self._beam_profile is None:
            self._beam_profile = self._oil_profile(np)
        gate = self._valve_np()
        per = np.where(gate > 0, self._q_pot / np.maximum(gate * 0.85, 1e-9), 0.0)[:, None] * self._beam_profile
        return torch.as_tensor(per, dtype=torch.float32)

    # ------------------------------------------------------------------ the fused path
    def _fused_power(self, F, aux, soil_eff):
        """after the parent's step_pre (its gate is current): F.per from the exchanger's power"""
        if self.machine_receiver == "beam":
            self._fused_profile = self._profile_from(F.per.clone(), torch)     # the parent's landing, live
            F.per.copy_(self._fused_profile * self._per_beam_t[:, None])
            return
        if self._fused_profile is None:
            self._fused_profile = self._oil_profile(torch, F.per.device)
        gate = F.gate
        per = torch.where(gate > 0, self._q_pot_t / (gate * 0.85).clamp_min(1e-9), torch.zeros_like(gate))
        F.per.copy_(self._fused_profile * per[:, None])

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
        # ---- ONE launch: the mount, the optics, the receiver
        x = self._x
        IN = self._bk.BIN if self.machine_receiver == "beam" else EIN
        C = self._bk.BCOL if self.machine_receiver == "beam" else ECOL
        x[:, IN["az"]] = self._st[:, 0]; x[:, IN["t"]] = self._st[:, 1]; x[:, IN["slack"]] = self._st[:, 2]
        # headToCmd / driveAz / driveEl of HashemiPolicy.lean, on the device
        x[:, IN["omegam"]] = (a[:, HEAD_AZ].float().clamp(0, 6) - 3) / 3.0 * self._om_full
        arm = self._hk_out[:, C["arm"]].clamp_min(0.05)
        arm = torch.where(arm > 0.05, arm, torch.full_like(arm, self._arm0))
        x[:, IN["omegad"]] = -(a[:, HEAD_EL].float().clamp(0, 6) - 3) / 3.0 * self._el_full * arm
        el, az = self._sun()
        x[:, IN["elSun"]] = el; x[:, IN["azSun"]] = az
        x[:, IN["dni"]] = F.dni                      # the parent's draw (last step's until step_pre)
        x[:, IN["soil"]] = F.soil
        if self.machine_receiver == "beam":
            dr = torch.cat([torch.rand(B, ENV_RAYS, 6, generator=self._gen, device=self.device),
                            torch.randn(B, ENV_RAYS, 4, generator=self._gen, device=self.device)], 2)
            out = self._env.step(x, dr)
            self._hk_out = out
            self._st[:, 0] = out[:, C["az_next"]]; self._st[:, 1] = out[:, C["t_next"]]; self._st[:, 2] = out[:, C["slack_next"]]
            self._per_beam_t = out[:, C["per_dni"]]
            self._cap_t.copy_(out[:, C["capture"]])
            return self._finish_step(F, a, out, C, t_before=float(self.t_solar[0]))
        prof = self._fused_profile[:, :self.n_nodes] if self._fused_profile is not None else None
        x[:, EIN["Twall"]] = F.T[:, :self.n_nodes].mean(1) if prof is None else \
            (F.T[:, :self.n_nodes] * prof).sum(1) / prof.sum(1).clamp_min(1e-9)
        x[:, EIN["UAx"]] = self._uax * (F.gate > 0).float()    # the exchanger opens with the beam gate
        g = self._gen
        dr = torch.cat([torch.rand(B, ENV_RAYS, 6, generator=g, device=self.device),
                        torch.randn(B, ENV_RAYS, 4, generator=g, device=self.device)], 2)
        out = self._env.step(x, self._hist, self._ret, dr)
        self._hk_out = out
        self._st[:, 0] = out[:, ECOL["az_next"]]
        self._st[:, 1] = out[:, ECOL["t_next"]]
        self._st[:, 2] = out[:, ECOL["slack_next"]]
        self._hist.copy_(out[:, HIST_COLS])
        self._ret.copy_(out[:, RET_COLS])
        self._q_pot_t.copy_(out[:, ECOL["q_pot"]])
        self._cap_t.copy_(out[:, ECOL["capture"]])
        return self._finish_step(F, a, out, ECOL, t_before=float(self.t_solar[0]))

    def _finish_step(self, F, a, out, C, t_before):
        """the parent's fused step after the machine's: the motors into the packed state, the
        neutralised heads, the shaping, the resync of cut and day-over agents"""
        F.el_m.copy_(90.0 - torch.rad2deg(self._st[:, 1]))
        F.az_m.copy_(torch.rad2deg(self._st[:, 0]))
        F.el_dish.copy_(F.el_m)
        neutral = a.clone()
        neutral[:, 3] = 3
        neutral[:, 4] = 3
        neutral[:, 0] = 4          # the level head pinned (his dish has no membrane)
        neutral[:, 2] = 6          # the jam head held on (the parent gates the beam by `jammed`)
        from tandoor_fused_step import fused_full_step
        obs_t, rew_t, infos = fused_full_step(self, neutral)
        # a cut agent's motors were re-parked by step_post, every agent's at day over: the Lean
        # state follows the parent's motors there; the oil keeps its field
        mask = F.trunc > 0.5
        if float(self.t_solar[0]) < t_before - 1.0:
            mask = torch.ones_like(mask, dtype=torch.bool)
        # THE REWARD FROM THE PRINTED MORPHISM: the parent's raw reward for the step is this
        # function's `parentRaw` input (with the optional host coboundary folded in), and the
        # kernel returns r_shape_raw / r_raw / r_trainer. `rew_t` leaves here RAW, because step
        # and step_torch divide by reward_div after this - i.e. the parent's own division IS the
        # morphism's third column (measured per step by R2 in test_reward_columns.py).
        extra = self._pb_raw(out[:, C["pointing_err"]], out[:, C["sun_reachable"]], mask, torch)
        if self.lost_shaping:
            extra = extra - self.lost_shaping * out[:, C["lost_sun_s"]]
        cols = self._reward_cols(rew_t + extra, out[:, C["p_in"]], out[:, C["sun_reachable"]], torch)
        shape = cols[:, RCOL["r_shape_raw"]] + extra
        rew_t = cols[:, RCOL["r_raw"]]
        F.ep_return.add_(shape)
        res = (obs_t, rew_t, infos)
        az_p = torch.deg2rad(F.az_m)
        t_p = torch.deg2rad(90.0 - F.el_m).clamp(0.0, self.t_dead)
        self._st[:, 0] = torch.where(mask, az_p, self._st[:, 0])
        self._st[:, 1] = torch.where(mask, t_p, self._st[:, 1])
        self._st[:, 2] = torch.where(mask, torch.zeros_like(t_p), self._st[:, 2])
        return res

    # --- the step
    def step(self, actions):
        if self.gpu and self._metal is not None:
            res = super().step(actions)              # routes through _gpu_full_step above
            self.row = self._hk_out.cpu().numpy().astype(np.float64)   # host mirrors for the eval path
            self.hk_row = self.row
            C = self._bk.BCOL if self.machine_receiver == "beam" else ECOL
            self.cap_traced = self.row[:, C["capture"]]
            self.hk_state[:] = self._st.cpu().numpy()
            if self.machine_receiver != "beam":
                self.t_oil = self.row[:, C["T_oil"]]
                self.hist = self.row[:, HIST_COLS]; self.ret = self.row[:, RET_COLS]
            self.machine_obs = self.row[:, [C["obs_" + n] for n in machine_policy.OBS_NAMES]].astype(np.float32)
            if self._rew_cols_t is not None:
                self.r_cols = self._rew_cols_t.cpu().numpy().astype(np.float64)
            self.el_m = 90.0 - np.degrees(self.hk_state[:, 1])
            self.az_m = np.degrees(self.hk_state[:, 0])
            return res
        B = self.num_agents
        a = np.asarray(actions).reshape(B, self.N_HEADS)
        self._run_np(a)
        neutral = np.array(np.round(a), dtype=np.int64)
        neutral[:, 3] = 3
        neutral[:, 4] = 3
        neutral[:, 0] = 4
        neutral[:, 2] = 6
        t_before = float(self.t_solar[0])
        res = super().step(neutral)
        C = self._bk.BCOL if self.machine_receiver == "beam" else ECOL
        wrapped = float(self.t_solar[0]) < t_before - 1.0
        resync = np.asarray(self.truncations, dtype=bool).copy()
        if wrapped:
            resync[:] = True
        # THE SAME PRINTED MORPHISM on this path. The parent has already divided self.rewards by
        # reward_div, so the raw reward of the step is lifted back into the morphism's own fibre
        # (`scale_natural`, RewardTopos.lean: the only change of base there is) and the trainer's
        # reward is the function's third column - never host arithmetic on units.
        div = float(getattr(self, "reward_div", 1.0))
        extra = self._pb_raw(self.row[:, C["pointing_err"]], self.row[:, C["sun_reachable"]], resync, np)
        if self.lost_shaping:
            extra = extra - self.lost_shaping * self.row[:, C["lost_sun_s"]]
        parent_raw = np.asarray(self.rewards, dtype=np.float64) * div + extra
        cols = self._reward_cols(parent_raw, self.row[:, C["p_in"]], self.row[:, C["sun_reachable"]], np)
        self.rewards[:] = cols[:, RCOL["r_trainer"]].astype(np.float32)
        self.ep_return += cols[:, RCOL["r_shape_raw"]] + extra
        self._sync_from_motors(resync)
        return res

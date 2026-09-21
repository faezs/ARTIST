"""Hashemi's fixed-focus concentrator as a puffer env: the physics is the megakernel.

The machine is the one in the video (Hashemi.lean): the 1.6 m chord of the R 2 m sphere hung on
four M12-eyed hangers from the two posts of the 1.84 m carriage, a roller on the 1.22 m ring for
the azimuth, a winch on the outrigger's mast towing the mast-side rim for the swing, the copper
coil at F on the carriage's post, a sun sensor on the rim. Every number and every law in the
step is a definition or a theorem of Hashemi.lean compiled by Ccc (hashemi_ccc.h, HashemiMega.lean):
the state (az, t, slack) advances by `step` (the wire's length is the state's carrier, with its
dead point and its slack), and the row the kernel returns holds every definition of the file
evaluated at the state and every theorem's statement evaluated there (1 = holds).

What is not from the file, and is said so: the sun (the tandoor's solar_position and Meinel
clear-sky DNI), the motors' full-command rates (a 0.5 deg/s yaw slew, a 1 cm/s wire speed),
the coil capture law (HashemiMega.coilCapture: two discs' overlap), and `megaParams` (the
assumed weight, centre of mass, wire rating, reflectance, drive force, bearing rating, rod).

Observation (16): the sensor's pointing errors (el, az; the loop of section 13), the hour, the
sun, the pose, the slack, the arm, stalled, taut, the capture, the power. Actions: two heads of
7 (the roller, the winch), 3 = stop. Reward: the power on the coil in kW per step. An episode is
one day at the site; `day_random` draws the day per reset.
"""
import importlib.util
import os
import pathlib
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
TUT = os.path.dirname(HERE)
if HERE not in sys.path:
    sys.path.insert(0, HERE)
from hashemi_kernel import (COL, COLUMNS, N_COLS, PRM_W, HashemiMetal, mega_numpy,   # noqa: E402
                            mega_params_numpy)
from hashemi_trace_kernel import (HashemiTraceMetal, sample_rays, sun_in_dish, trace_numpy,   # noqa: E402
                                  trace_params_numpy)

_spec = importlib.util.spec_from_file_location("tandoor_sim03", pathlib.Path(TUT) / "03_membrane_beamdown_tandoor.py")
_sim = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_sim)
solar_position = _sim.solar_position          # (el deg, az rad from north clockwise, unit vector)
clear_sky_dni = _sim.clear_sky_dni

try:
    import gymnasium
    import pufferlib
    _Base = pufferlib.PufferEnv
except Exception:  # no pufferlib: a plain class with the same buffers
    gymnasium = None

    class _Base:
        def __init__(self, buf=None):
            B = self.num_agents
            self.observations = np.zeros((B, self.single_observation_space_shape), dtype=np.float32)
            self.rewards = np.zeros(B, dtype=np.float32)
            self.terminals = np.zeros(B, dtype=bool)
            self.truncations = np.zeros(B, dtype=bool)

N_OBS = 16
#: the motors at full command (not in the video): the carriage yaws at 0.5 deg/s, the winch pays 1 cm/s
SLEW_AZ_DEG_S = 0.5
WIRE_SPEED = 0.01


class HashemiMachineEnv(_Base):
    def __init__(self, num_agents=1024, lat=30.2, day_of_year=172, day_random=0, dt=15.0, day_start=5.5,
                 day_end=19.5, device="mps", full_obs=0, seed=0, params=None, trace_rays=64, dish_k=-1.0, buf=None, **kwargs):
        self.num_agents = int(num_agents)
        self.lat = float(lat)
        self.day = int(day_of_year)
        self.day_random = int(day_random)
        self.dt = float(dt)
        self.day_start = float(day_start)
        self.day_end = float(day_end)
        self.full_obs = int(full_obs)
        self.rng = np.random.default_rng(seed)
        B = self.num_agents
        self.n_obs = N_OBS + (N_COLS if self.full_obs else 0)
        self.single_observation_space_shape = self.n_obs
        if gymnasium is not None:
            self.single_observation_space = gymnasium.spaces.Box(-4.0, 4.0, (self.n_obs,), dtype=np.float32)
            self.single_action_space = gymnasium.spaces.MultiDiscrete([7, 7])
        self.params = np.asarray(mega_params_numpy() if params is None else params, dtype=np.float64).reshape(PRM_W)
        self._metal = None
        self.torch = None
        if device == "mps":
            try:
                import torch
                if torch.backends.mps.is_available():
                    self.torch = torch
                    self._metal = HashemiMetal()
            except Exception as e:
                print(f"[hashemi_env] Metal unavailable ({e}); NumPy twin")
        # THE TRACED CAPTURE: `trace_rays` rays per agent per step through his dish's trace
        # (HashemiTrace.lean, generated) replace the added model `coilCapture` in the reward; the
        # model stays in the row for comparison. 0 keeps the model.
        self.trace_rays = int(trace_rays)
        # the panel's conic constant: -1 the satellite dish the frames show (a paraboloid), 0 the
        # length figure's compass circle (the sphere of Hashemi.lean's dishR); the vertex curvature 1/R
        self.dish_k = float(dish_k)
        self._tracer = None
        self._trace_prm = trace_params_numpy()
        if self.trace_rays > 0 and self._metal is not None:
            self._tracer = HashemiTraceMetal()
        self.cap_traced = np.zeros(B, dtype=np.float64)
        self.state = np.zeros((B, 3), dtype=np.float64)          # az, t, slack
        self.row = np.zeros((B, N_COLS), dtype=np.float64)
        self.hour = self.day_start
        self._e_el = np.zeros(B)
        self._e_az = np.zeros(B)
        self._sun = (0.0, 0.0, 0.0)
        if self._metal is not None:
            self._st_t = self.torch.zeros(B, 3, dtype=self.torch.float32, device="mps")
            self._prm_t = self.torch.as_tensor(self.params, dtype=self.torch.float32, device="mps")
        super().__init__(buf)
        # the machine's own numbers, from the kernel at rest: the dead point and the roller circle
        rest = self._eval(np.zeros((B, 3)), np.zeros((B, 2)), np.array([[0.5, 0.0, 800.0]] * B))
        self.t_dead = float(rest[0, COL["t_dead"]])
        self.t_hold = self._hold_limit()
        self.roller_R = float(rest[0, COL["rollerRadius"]])
        self.rw = 0.05                                             # hashemi.rDrive
        self.om_full = np.radians(SLEW_AZ_DEG_S) * self.roller_R / self.rw   # azRate: wm rw / R = the slew
        self.od_full = WIRE_SPEED / float(self.params[0])                  # rDrum wd = the wire's speed

    def _hold_limit(self):
        """the largest swing at which the wire still holds the dish, `HoldsDish Tmax W rcm arm`: the
        arm `leverAt` (compiled) falls to zero at the dead point, so bisect on its falling branch for
        arm = W rcm / Tmax - where the winch parks the dish at night and where it stalls by day"""
        import hashemi_ccc as H
        ym, hp, a = 1.22, 0.34, 0.8                                   # ymHashemi, hpHashemi, dishHalf
        ze = 1.0 - (2.0 - np.sqrt(4.0 - 0.64))                        # zeHashemi = f - sag
        W, rcm, Tmax = self.params[1], self.params[2], self.params[3]
        need = W * rcm / Tmax
        lo, hi = 0.5 * self.t_dead, self.t_dead
        for _ in range(48):
            m = 0.5 * (lo + hi)
            if float(H.hk_leverAt(ym, hp, a, ze, m)) > need:
                lo = m
            else:
                hi = m
        return lo

    # ------------------------------------------------------------ the kernel
    def _eval(self, state, cmd, sun):
        if self._metal is None:
            return mega_numpy(state, cmd, self.dt, sun, self.params)
        torch = self.torch
        st = torch.as_tensor(np.asarray(state, dtype=np.float32), device="mps")
        out = self._metal.step(st, torch.as_tensor(np.asarray(cmd, dtype=np.float32), device="mps"), self.dt,
                               torch.as_tensor(np.asarray(sun, dtype=np.float32), device="mps"), self._prm_t)
        return out.cpu().numpy().astype(np.float64)

    def _traced_capture(self):
        """the capture fraction per agent from the generated trace at the current pose and sun"""
        B = self.num_agents
        el, az, _ = self._sun
        sd = sun_in_dish(self.state[:, 0], self.state[:, 1], np.full(B, np.radians(el)), np.full(B, az))
        rays = sample_rays(B, self.trace_rays, sd, self.rng)
        if self._tracer is not None:
            return self._tracer.capture(rays, self._trace_prm, B, self.trace_rays, k=self.dish_k)
        out = trace_numpy(rays, self._trace_prm)
        return out[:, 3].reshape(B, self.trace_rays).mean(1)

    def sun_now(self):
        el, az, _ = solar_position(self.lat, self.day, self.hour)
        return float(el), float(az), float(clear_sky_dni(float(el)))

    # ------------------------------------------------------------ the loop
    def reset(self, seed=None):
        if seed is not None:
            self.rng = np.random.default_rng(seed)
        if self.day_random:
            self.day = int(self.rng.integers(1, 366))
        self.hour = self.day_start
        B = self.num_agents
        el, az, dni = self.sun_now()
        self.state[:, 0] = az + np.radians(self.rng.normal(0, 2.0, B))
        self.state[:, 1] = np.clip(np.radians(90.0 - el) + np.radians(self.rng.normal(0, 1.0, B)), 0.0, self.t_hold)
        self.state[:, 2] = 0.0
        self._sun = (el, az, dni)
        self.row[:] = self._eval(self.state, np.zeros((B, 2)), self._sun_rows())
        self._errors()
        self.observations[:] = self._obs()
        return self.observations, []

    def _sun_rows(self):
        el, az, dni = self._sun
        return np.broadcast_to(np.array([np.radians(el), az, dni]), (self.num_agents, 3)).copy()

    def _errors(self):
        el, az, _ = self._sun
        self._e_el = (90.0 - np.degrees(self.state[:, 1])) - el
        d = np.degrees(self.state[:, 0]) - np.degrees(az)
        d = d - 360.0 * np.round(d / 360.0)
        self._e_az = d * np.cos(np.radians(el))

    def _obs(self):
        el, az, _ = self._sun
        r = self.row
        h = 2 * np.pi * (self.hour - 12.0) / 24.0
        B = self.num_agents
        o = np.stack([self._e_el / 10.0, self._e_az / 10.0, np.full(B, np.sin(h)), np.full(B, np.cos(h)),
                      np.full(B, el / 90.0), np.full(B, np.sin(az)), np.full(B, np.cos(az)),
                      self.state[:, 1] / self.t_dead, np.sin(self.state[:, 0]), np.cos(self.state[:, 0]),
                      self.state[:, 2] * 10.0, r[:, COL["arm"]], r[:, COL["stalled"]], r[:, COL["taut"]],
                      (self.cap_traced if self.trace_rays > 0 else r[:, COL["capture"]]),
                      (self.rewards if self.trace_rays > 0 else r[:, COL["power_W"]] / 1000.0)], 1)
        if self.full_obs:
            o = np.concatenate([o, r], 1)
        return np.clip(o, -4.0, 4.0).astype(np.float32)

    def commands(self, actions):
        """actions (B,2) in 0..6 -> (ωm, ωd) rad/s; the +el head raises the face, so it pays wire OUT"""
        a = np.asarray(actions, dtype=np.float64).reshape(self.num_agents, 2)
        c_az = (np.clip(a[:, 0], 0, 6) - 3) / 3.0
        c_el = (np.clip(a[:, 1], 0, 6) - 3) / 3.0
        return np.stack([c_az * self.om_full, -c_el * self.od_full], 1)

    def step(self, actions):
        B = self.num_agents
        cmd = self.commands(actions)
        # the sun for this step, then the kernel: the row at the OLD state under these commands, the new state in row[0:3]
        self._sun = self.sun_now()
        self.row[:] = self._eval(self.state, cmd, self._sun_rows())
        self.state[:, 0] = self.row[:, COL["az_next"]]
        self.state[:, 1] = self.row[:, COL["t_next"]]
        self.state[:, 2] = self.row[:, COL["slack_next"]]
        self.hour += self.dt / 3600.0
        self._errors()
        if self.trace_rays > 0:
            # the power from the traced capture: the same DNI, area and reflectance as the row's model column
            el, az, dni = self._sun
            self.cap_traced = self._traced_capture() if el > 0 else np.zeros(B)
            power = dni * self.row[:, COL["dishSide"]] ** 2 * self.params[4] * self.cap_traced
            self.rewards[:] = (power * 1e-3).astype(np.float32)
        else:
            self.rewards[:] = (self.row[:, COL["power_W"]] * 1e-3).astype(np.float32)
        self.terminals[:] = False
        done = self.hour >= self.day_end
        self.truncations[:] = done
        infos = []
        if done:
            infos = [dict(power_mean_W=float(self.rewards.mean() * 1e3),
                          capture_model=float(self.row[:, COL["capture"]].mean()), capture_traced=float(self.cap_traced.mean()),
                          in_budget=float(self.row[:, COL["TrackerBudget"]].mean()),
                          stalled=float(self.row[:, COL["stalled"]].mean()))]
            self.reset()
        else:
            self.observations[:] = self._obs()
        return self.observations, self.rewards, self.terminals, self.truncations, infos


def sensor_loop_actions(env, deadband_deg=0.02):
    """the video's tracker as a policy: the rim sensor's errors drive both motors toward zero,
    proportional inside one step's slew, saturated beyond"""
    B = env.num_agents
    slew_az = SLEW_AZ_DEG_S * env.dt
    slew_el = np.degrees(WIRE_SPEED / np.maximum(env.row[:, COL["arm"]], 0.05)) * env.dt
    d_az = env._e_az / np.cos(np.radians(max(env._sun[0], 1.0)))
    c_az = -np.clip(d_az / slew_az, -1.0, 1.0)
    c_el = -np.clip(env._e_el / slew_el, -1.0, 1.0)
    c_az[np.abs(d_az) < deadband_deg] = 0.0
    c_el[np.abs(env._e_el) < deadband_deg] = 0.0
    act = np.zeros((B, 2))
    act[:, 0] = 3.0 + 3.0 * c_az
    act[:, 1] = 3.0 + 3.0 * c_el
    return act

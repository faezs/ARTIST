"""The compiled Lean machine as the mount of a puffer env.

`HashemiCccEnv` is `TandoorHashemiEnv` with its motor model replaced. The
parent integrates the drum and the roller by hand (`az_m += r_az dt`,
`el_m += r_el dt`) and takes the dish's elevation from the drum's through a
linearised tow-wire sag (`el_dish_deg`). Here the carriage's yaw and the
dish's swing come from `hk_step` - `HashemiStep.step` in
~/manifold-pareto/lean/RequestProject, compiled by Ccc.lean to hashemi_ccc.h
and run as the Metal kernel `hashemi_step`, one thread per agent. The
state is the Lean state (az, t): yaw of the carriage and swing of the dish
about the M12 bolt line; the wire's lever arm, its dead point and the
gravity return are the theorems of Hashemi.lean, not a sag coefficient.

Everything downstream is the parent's, untouched: the mount solve (`pnt`
= the dish's elevation and azimuth in degrees), the Metal trace, the
thermal model, the reward, the guillotine.

Machine rows (per agent, the 9 inputs of `hk_step`):
  rw     roller radius            his 5 cm
  R      roller circle             the design table's g_orbit (fct[55])
  rDrum  winch drum radius         0.03 (not in the video)
  ym, hp mast station and pulley height over the bolts: his 1.22, 0.34,
         scaled with the dish (a / 0.8) when machine="design"
  a      dish half-width           fct[54]
  ze     rim depth below F         f - sag on the R = 2 f sphere
  f      focal length              fct[53]
  h      M12 helix advance per rad
machine="video" takes his 1.6 m dish's numbers (HASHEMI_PARAMS) for the
machine while the trace stays the env's optics: the pose is scale-free.
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
TUT = os.path.dirname(HERE)
ROOT = os.path.dirname(TUT)          # the repo root: the artist package
for _p in (ROOT, TUT, HERE):
    if _p not in sys.path:
        sys.path.insert(0, _p)

import torch                                        # noqa: E402
from tandoor_hashemi_env import TandoorHashemiEnv   # noqa: E402
from hashemi_kernel import (HASHEMI_PARAMS, HashemiMetal, step_numpy,   # noqa: E402
                            PRM_W, OUT_W)

#: hk_step's output columns (HashemiStep.lean)
OUT_COLS = ("az", "t", "arm", "tension", "tDead", "Vy", "Vz", "Ny", "Nz",
            "creep", "postCross", "postInside", "rimDepth")
COL = {n: i for i, n in enumerate(OUT_COLS)}


class HashemiCccEnv(TandoorHashemiEnv):
    """the parent env, its carriage and dish stepped by the compiled Lean"""

    def __init__(self, *args, machine="design", r_drum=0.03, mast_ym=1.22,
                 mast_hp=0.34, r_wheel=0.05, **kwargs):
        kwargs["gpu"] = 0        # the parent's numpy motor path; the trace stays on Metal
        self._hk_cfg = dict(machine=machine, r_drum=float(r_drum), mast_ym=float(mast_ym),
                            mast_hp=float(mast_hp), r_wheel=float(r_wheel))
        super().__init__(*args, **kwargs)
        B = self.num_agents
        self._hk_dev = torch.device("mps") if torch.backends.mps.is_available() else None
        self._hk = HashemiMetal() if self._hk_dev is not None else None
        self._hk_params_np = self._machine_rows()                       # (B, 9) float64
        self._hk_params = None if self._hk is None else torch.as_tensor(
            self._hk_params_np, dtype=torch.float32, device=self._hk_dev)
        self._hk_state_np = np.zeros((B, 2), dtype=np.float64)
        self._hk_state = None if self._hk is None else torch.zeros(B, 2, dtype=torch.float32, device=self._hk_dev)
        # the rest pose (t = 0, no command) through the compiled step: the arm at rest and the dead point
        rest = step_numpy(np.zeros((B, 2)), np.zeros((B, 2)), 0.0, self._hk_params_np)
        self.hk_arm_rest = rest[:, COL["arm"]].copy()
        self.hk_tdead = rest[:, COL["tDead"]].copy()
        self.hk_out = rest
        # full command = the parent's slew rates, so a policy's actions keep their meaning:
        # yaw: azRate wm rw R = wm rw / R;  swing: elRate wd rDrum arm = wd rDrum / arm (at the rest arm)
        rate = np.asarray(getattr(self, "_ds_rate", 1.0), dtype=np.float64) * np.ones(B)
        rw, R, rD = self._hk_params_np[:, 0], self._hk_params_np[:, 1], self._hk_params_np[:, 2]
        self._om_full = np.radians(self.RATE_AZ * rate) * R / rw
        self._od_full = np.radians(self.RATE_EL * rate) * self.hk_arm_rest / rD
        if hasattr(self, "az_m"):                 # the parent makes its motors in reset()
            self._sync_from_motors(np.ones(B, dtype=bool))

    # ----------------------------------------------------------- machine
    def _machine_rows(self):
        B = self.num_agents
        c = self._hk_cfg
        rows = np.tile(HASHEMI_PARAMS[None, :], (B, 1)).astype(np.float64)
        if c["machine"] == "video":
            return rows
        fct = self._fct.detach().cpu().numpy().astype(np.float64)
        f = fct[:, 53]
        a = fct[:, 54]
        R = fct[:, 55]
        sag = 2.0 * f - np.sqrt(np.maximum(4.0 * f * f - a * a, 0.0))   # TandoorSphere.sag on the R = 2 f sphere
        ze = f - sag
        s = a / 0.8
        rows[:, 0] = c["r_wheel"]
        rows[:, 1] = R
        rows[:, 2] = c["r_drum"]
        rows[:, 3] = c["mast_ym"] * s
        rows[:, 4] = c["mast_hp"] * s
        rows[:, 5] = a
        rows[:, 6] = ze
        rows[:, 7] = f
        return rows

    def machine_summary(self):
        p = self._hk_params_np[0]
        return dict(rw=p[0], R=p[1], rDrum=p[2], ym=p[3], hp=p[4], a=p[5], ze=p[6], f=p[7], h=p[8],
                    arm_rest=float(self.hk_arm_rest[0]), tdead_deg=float(np.degrees(self.hk_tdead[0])),
                    lowest_sun_deg=90.0 - float(np.degrees(self.hk_tdead[0])))

    # ----------------------------------------------------------- the pose
    def el_dish_deg(self, el_m, wind):
        """the dish's elevation IS the Lean state; no sag model on top of it"""
        return np.asarray(el_m, dtype=np.float64)

    def el_dish_t(self, el_m, wind):
        return el_m

    def _sync_from_motors(self, mask):
        """the Lean state from the parent's (el_m, az_m) where the parent re-acquired the carriage
        (reset, a lost-sun cut, the day wrap); the swing is clamped to the wire's reach"""
        mask = np.asarray(mask, dtype=bool)
        if not mask.any():
            return
        st = self._hk_state_np
        st[mask, 0] = np.radians(np.asarray(self.az_m, dtype=np.float64)[mask])
        t = np.radians(90.0 - np.asarray(self.el_m, dtype=np.float64)[mask])
        st[mask, 1] = np.clip(t, 0.0, self.hk_tdead[mask])
        self.el_m = np.asarray(self.el_m, dtype=np.float64)
        self.el_m[mask] = 90.0 - np.degrees(st[mask, 1])
        if self._hk is not None:
            self._hk_state.copy_(torch.as_tensor(st, dtype=torch.float32))

    def _hk_advance(self, cmd):
        """one hk_step for the batch: cmd (B, 2) = (omega_m, omega_d) rad/s; returns out (B, 13)"""
        if self._hk is None:
            out = step_numpy(self._hk_state_np, cmd, float(self.dt), self._hk_params_np)
            self._hk_state_np[:, 0] = out[:, COL["az"]]
            self._hk_state_np[:, 1] = out[:, COL["t"]]
            return out
        cmd_t = torch.as_tensor(np.asarray(cmd, dtype=np.float32), device=self._hk_dev)
        out = self._hk.step(self._hk_state, cmd_t, float(self.dt), self._hk_params).cpu().numpy().astype(np.float64)
        self._hk_state_np[:, 0] = out[:, COL["az"]]
        self._hk_state_np[:, 1] = out[:, COL["t"]]
        return out

    def pose_deg(self):
        """(el_dish, az) in degrees from the Lean state: the dish's normal is swungPt (0,1) t"""
        return 90.0 - np.degrees(self._hk_state_np[:, 1]), np.degrees(self._hk_state_np[:, 0])

    # ----------------------------------------------------------- the step
    def reset(self, *args, **kwargs):
        res = super().reset(*args, **kwargs)
        self._sync_from_motors(np.ones(self.num_agents, dtype=bool))
        return res

    def step(self, actions):
        B = self.num_agents
        a = np.asarray(actions).reshape(B, self.N_HEADS)
        c_az = (np.clip(a[:, 3], 0, 6) - 3) / 3.0
        c_el = (np.clip(a[:, 4], 0, 6) - 3) / 3.0
        # a positive drum speed winds the wire IN: the back comes toward the mast, the face turns away, the
        # elevation DROPS (Hashemi.lean, the swing's sign); the parent's +el head raises the dish, so it pays out
        cmd = np.stack([c_az * self._om_full, -c_el * self._od_full], 1)
        self.hk_out = self._hk_advance(cmd)
        el, az = self.pose_deg()
        self.el_m = el
        self.az_m = az
        neutral = np.array(np.round(a), dtype=np.int64)     # the parent's heads are discrete
        neutral[:, 3] = 3
        neutral[:, 4] = 3            # the parent's motors stand still; the Lean moved them
        t_before = float(self.t_solar[0])
        res = super().step(neutral)
        wrapped = float(self.t_solar[0]) < t_before - 1.0
        resync = np.asarray(self.truncations, dtype=bool).copy()
        if wrapped:
            resync[:] = True
        self._sync_from_motors(resync)
        return res


def sensor_loop_actions(env, deadband_deg=0.02, extra=None):
    """the video's tracker as a policy: the sensor on the rim sees the dish's pointing error and drives both
    motors toward zero - proportional inside one step's slew, saturated beyond. Returns (B, N_HEADS) actions
    with the other heads at 3 (level/shutter/jam neutral) unless `extra` supplies them."""
    B = env.num_agents
    el0, az0, _ = env._sim_solar()
    e_el = np.asarray(env.el_m, dtype=np.float64) - el0
    d_az = np.asarray(env.az_m, dtype=np.float64) - az0
    d_az = d_az - 360.0 * np.round(d_az / 360.0)
    rate = np.asarray(getattr(env, "_ds_rate", 1.0), dtype=np.float64) * np.ones(B)
    slew_az = env.RATE_AZ * rate * float(env.dt)
    slew_el = env.RATE_EL * rate * float(env.dt)
    c_az = -np.clip(d_az / slew_az, -1.0, 1.0)
    c_el = -np.clip(e_el / slew_el, -1.0, 1.0)
    c_az[np.abs(d_az) < deadband_deg] = 0.0
    c_el[np.abs(e_el) < deadband_deg] = 0.0
    act = np.full((B, env.N_HEADS), 3.0) if extra is None else np.array(extra, dtype=np.float64)
    act[:, 3] = 3.0 + 3.0 * c_az
    act[:, 4] = 3.0 + 3.0 * c_el
    return act


def _sim_solar(self):
    """the sun in the site's frame, degrees: what the parent's step compares the motors against"""
    import tandoor_hashemi_env as _m
    el0, az0, _ = _m._sim.solar_position(self.lat, self.day, float(self.t_solar[0]))   # el in degrees, az in radians
    az0 = np.degrees(az0 - self._ds_azs)
    return float(el0), az0, None


HashemiCccEnv._sim_solar = _sim_solar

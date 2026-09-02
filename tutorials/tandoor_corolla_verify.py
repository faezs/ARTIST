"""Corolla-modular parity: verify the machine vertex by vertex.

Manin-Marcolli Corollary 2.20: a network summing functor is
completely determined by its values on corollas (a vertex with its
half-edges) plus the grafting along edges. Applied to our parity
discipline: instead of only comparing whole 500-step tapes and
bisecting on divergence, verify each subsystem automaton and each
coupling separately - a future divergence then NAMES its corolla.

Corollas (torch GpuState vs fused MSL, zero noise, same tape):
  membrane  - jam/soft, pump servo, figure formation
  mount     - motors, pointing error, lost counter
  elbow     - spot aim integrator
  thermal   - wall/sub/deep/halo network with the beam on, no dough
  bread     - single-bin dough: energy, doneness, events
  lean      - the load-timer modulator and pull gating

    .venv/bin/python tandoor_corolla_verify.py
"""
import contextlib
import io
import pathlib
import sys

import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))

STEPS = 80


def build(cls, loaves, gates_open):
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_mount_batch import solar_batch
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(
            num_agents=16, seed=7, wide_shutter=1, device="mps",
            gpu=1, n_rays=64, warm_frac=1.0, day_random=0,
            lat_random=0, wall_obs=1, beta_dev=36.0, beta_cap_z=10.6,
            silvered=1, duct_nozzle=2, spot_bread=1, roti_kj=130.0,
            bread_area=0.12, loaves_per_load=loaves, elbow_aim=1,
            load_ctrl=1, sticky_k=0)
        e.reset(seed=7)
    e._det_trace = True
    e.day_v[:] = 172
    e.day = 172
    e.t_solar[:] = 11.5
    el1, az1r, _ = solar_batch(torch.full((16,), 28.6),
                               torch.full((16,), 172.0), 11.5)
    e.lat_v[:] = 28.6
    e.lat = 28.6
    e.el_m[:] = float(el1[0])
    e.az_m[:] = float(torch.rad2deg(az1r)[0])
    e._e_el[:] = 0.0
    e._e_az[:] = 0.0
    e.T[:] = 640.0
    e.equilibrate_wall(halo=470.0)
    e._belt_prev = e.T[:, :e.n_belt].max(1).copy()
    e._gates_open = gates_open
    S = cls(e)
    S.zero_noise = True
    e._gpu = S
    return e, S


def tape_step(e, t, jam_script, motor_wiggle):
    a = np.full((16, e.N_HEADS), 3, dtype=np.int64)
    a[:, 0] = (t // 9) % 7
    a[:, 1] = 6
    a[:, 2] = jam_script(t)
    if motor_wiggle:
        a[:, 3] = 4 if t % 11 < 5 else 2
        a[:, 4] = 4 if t % 13 < 6 else 2
        a[:, 5] = 4 if t % 17 < 8 else 2
        a[:, 6] = 2 if t % 19 < 9 else 4
    for k in getattr(e, "_gates_open", ()):
        a[:, 7 + k] = 6
    return a


def run(cls, loaves, gates_open, jam_script, motor_wiggle, fields):
    from tandoor_gpu_step import GpuState      # noqa: F401
    e, S = build(cls, loaves, gates_open)
    out = {f: [] for f in fields}
    rews = []
    for t in range(STEPS):
        a = tape_step(e, t, jam_script, motor_wiggle)
        o, r, d, tr, _ = e.step_torch(
            torch.as_tensor(a, device=e.device))
        rews.append(r.cpu().clone())
        for f in fields:
            v = getattr(S, f)
            v = v.float() if torch.is_tensor(v) else torch.as_tensor(v)
            out[f].append(v.cpu().clone())
    return ({f: torch.stack(v) for f, v in out.items()},
            torch.stack(rews))


def corolla(name, loaves, gates_open, jam_script, motor_wiggle,
            fields, tol):
    from tandoor_gpu_step import GpuState
    from tandoor_fused_step import FusedState
    a1, r1 = run(GpuState, loaves, gates_open, jam_script,
                 motor_wiggle, fields)
    a2, r2 = run(FusedState, loaves, gates_open, jam_script,
                 motor_wiggle, fields)
    worst, wf = 0.0, ""
    for f in fields:
        err = float((a1[f] - a2[f]).abs().max())
        if err > worst:
            worst, wf = err, f
    dr = float((r1 - r2).abs().max())
    print(f"  {name:9s} worst field |d| = {worst:.2e} ({wf})"
          f"   rew |d| = {dr:.2e}")
    assert worst < tol, f"{name} corolla diverges on {wf}"
    return dr


if __name__ == "__main__":
    print("corolla-modular parity (torch vs fused, zero noise)")
    jam_hold = lambda t: 6                       # noqa: E731
    jam_flap = lambda t: 6 if t % 7 < 5 else 0   # noqa: E731
    # membrane: beam irrelevant to these scalars; flapping jam
    corolla("membrane", 0, (), jam_flap, False,
            ["p_act", "p_set", "p_dist", "jammed", "f_locked",
             "form_time", "decl_formed"], 5e-3)
    # mount + elbow: motors wiggling, jam held
    corolla("mount", 0, (), jam_hold, True,
            ["el_m", "az_m", "e_az_prev", "e_el_prev", "lost_ct"],
            5e-3)
    corolla("elbow", 0, (), jam_hold, True,
            ["spot_phi", "spot_z"], 1e-4)
    # thermal: beam on, no dough anywhere
    corolla("thermal", 0, (), jam_hold, False,
            ["T", "T_sub", "T_deep", "T_halo"], 5e-2)
    # bread: dough in one gate-opened bin only
    corolla("bread", 2, (2,), jam_hold, False,
            ["bread_E", "bread_t", "bread_C", "has_bread",
             "day_rotis", "ep_rotis"], 5e-2)
    # lean modulator: timer and pull gating (dough in two bins)
    corolla("lean", 3, (1, 4), jam_hold, False,
            ["load_timer", "ep_rotis", "has_bread"], 5e-2)
    print("corolla-modular parity: PASS")

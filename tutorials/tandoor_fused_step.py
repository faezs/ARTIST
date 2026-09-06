"""The whole step in Metal: mount_solve -> step_pre -> trace -> step_post.

tandoor_gpu_step put the step on-device as ~150 torch ops; at B=8192
those launches, not the physics, were the step (the megakernel is
0.8 ms of ~12). This module packs ALL per-env state into ONE (B, NS)
float tensor and runs the step as four kernel launches plus the bulk
RNG draws. Python keeps the scalar sun clock, the rare synchronized
day-over branch (in-place on views), and nothing else - the per-step
host->device traffic is one float (the hour).

PARITY DISCIPLINE, one more rung of the same ladder: the numpy step
is the reference, tandoor_gpu_step is its torch transcription, and
the step_pre/step_post kernels are transcriptions of THAT.
verify_fused() runs the torch path and this path from identical
state with zero noise and compares full obs/reward trajectories.
Physics changes land in numpy first, then torch, then here.

State packing (offsets mirrored in the MSL header comment):
  st[:, 0:N] T | [N:2N] T_sub | [2N:3N] T_deep | [3N] T_halo
  [3N+1:+NB] bread_E, bread_t, bread_C, has_bread
  scalars at S0 = 3N+1+4NB (see _SCAL below)
bore lives in the `off` buffer the trace already binds; soil, lv,
sigb, dvec, aim are their own contiguous (B,k) buffers for the same
reason. day/lat stay separate so mount_solve keeps its contract.
"""
import numpy as np
import torch

KSAND = 8      # layers of the sand column under the hearth and the floor (kernel KSAND)
_SCAL = ("p_act", "p_set", "p_dist", "shutter", "jammed", "f_locked",
         "form_time", "decl_formed", "load_timer", "ep_rotis",
         "ep_scorch", "ep_spall", "ep_return", "ep_len", "el_m",
         "az_m", "lost_ct", "belt_prev", "cloud", "wind_g",
         "e_az_prev", "e_el_prev", "spot_phi", "spot_z", "dni",
         "wind", "stowed", "el0s", "az0d", "pot_prev", "gate",
         "decl_now", "e_el", "e_az", "day_rotis",
         "hold_p", "hold_s", "hold_j")


def _step_params(env):
    """The sp float table + ip int table (layout in the MSL header)."""
    from tandoor_polar_env import (SPOT_PHI_RANGE, SPOT_Z_RANGE,
                                   RATE_SPOT_PHI, RATE_SPOT_Z,
                                   SPOT_AREA, Z_BAKE_LO, Z_CROWN,
                                   R_SPH, Z_CPOT, SPOT_PHI0, SPOT_Z0)
    dt = float(env.dt)
    M = env._noz2["M"] if getattr(env, "_noz2", None) else (0.0,) * 3
    N = env.n_nodes
    sp = np.zeros(66 + 7 * N, dtype=np.float32)
    sp[0:11] = [dt, env.p0, env.RATE_AZ, env.RATE_EL, RATE_SPOT_PHI,
                RATE_SPOT_Z, SPOT_PHI_RANGE[0], SPOT_PHI_RANGE[1],
                SPOT_Z_RANGE[0], SPOT_Z_RANGE[1],
                3.5 if env.wide_shutter else 0.5]
    sp[11:17] = [env.jam_gain, env.wall_shelter, env.sig_static,
                 env.el_min_h, env.el_max_h, float(env._cosine(0.0))]
    sp[17:24] = [env.lid_leak, env.h_bread, env.roti_energy,
                 env.load_period,
                 min(env.bread_area / SPOT_AREA, 1.0),
                 Z_BAKE_LO, Z_CROWN]
    sp[24:29] = [float(getattr(env, "elbow_aim", 0)),
                 float(getattr(env, "spot_bread", 0)),
                 float(env.wall_obs), 453.0, 700.0]
    sp[29:35] = [R_SPH, Z_CPOT, M[0], M[1], M[2], env.f_nom]
    sp[35:38] = [env.N_LEVELS - 1, env.level_frac[0],
                 env.level_frac[-1] - env.level_frac[0]]
    sp[38:44] = [env.g_halo_out, env.c_halo, SPOT_PHI0, SPOT_Z0,
                 dt / 3600.0, 300.0]
    sp[44:52] = [0.25 * np.sqrt(2 * dt / 900.0),
                 1.8 * np.sqrt(2 * dt / 600.0),
                 0.010 * np.sqrt(2 * dt / 300.0),
                 0.0015 * dt / 15.0, dt / 900.0, dt / 600.0,
                 dt / 300.0, np.pi * 0.26 ** 2]
    sp[52] = env.node_area.sum()
    sp[53] = env.bread_area
    sp[54:61] = env.level_frac
    sp[61] = env.loaves_per_load
    sp[62] = float(getattr(env, "load_ctrl", 0))
    sp[63] = float(getattr(env, "cut_penalty", 0.0))   # fixed cut penalty (raw)
    sp[64] = float(getattr(env, "lost_deg", 3.0))       # guillotine threshold (deg)
    sp[65] = float(getattr(env, "enc_clamp", 3.0))      # pointing encoder clamp
    for i, v in enumerate((env.node_area, env.node_heat_cap,
                           env.cap_sub, env.cap_deep, env.g01,
                           env.g12, env.g2s)):
        sp[66 + i * N:66 + (i + 1) * N] = v
    return sp


class FusedState:
    """Packed device state + persistent kernel buffers. Exposes the
    same field names as GpuState (as views into st) so the day-over
    branch, _gpu_obs and infos read/write the one storage."""
    fused = True

    def __init__(self, env):
        assert env.n_nodes <= 20 and env.n_belt <= 12, \
            "raise NMAX/NBMAX in the MSL"
        self.env = env
        dev, B = env.device, env.num_agents
        N, NB = env.n_nodes, env.n_belt
        self.S0 = S0 = 3 * N + 1 + 4 * NB
        self.SB = SB = S0 + len(_SCAL)            # the sand columns (hearth, floor) x KSAND
        self.NS = NS = SB + 2 * KSAND
        e = env
        st = np.zeros((B, NS), dtype=np.float32)
        st[:, SB:SB + 2 * KSAND] = np.asarray(e.T_sand, dtype=np.float64).reshape(B, 2 * KSAND)
        st[:, 0:N] = e.T
        st[:, N:2 * N] = e.T_sub
        st[:, 2 * N:3 * N] = e.T_deep
        st[:, 3 * N] = e.T_halo
        st[:, 3 * N + 1:3 * N + 1 + NB] = e.bread_E
        st[:, 3 * N + 1 + NB:3 * N + 1 + 2 * NB] = e.bread_t
        st[:, 3 * N + 1 + 2 * NB:3 * N + 1 + 3 * NB] = e.bread_C
        st[:, 3 * N + 1 + 3 * NB:3 * N + 1 + 4 * NB] = e.has_bread
        sc = dict(p_act=e.p_act, p_set=e.p_set, p_dist=e.p_dist,
                  shutter=e.shutter, jammed=e.jammed,
                  f_locked=e.f_locked, form_time=e.form_time,
                  decl_formed=e.decl_formed, load_timer=e.load_timer,
                  ep_rotis=e.ep_rotis, ep_scorch=e.ep_scorch,
                  ep_spall=e.ep_spall, ep_return=e.ep_return,
                  ep_len=e.ep_len, el_m=e.el_m, az_m=e.az_m,
                  lost_ct=e._lost_ct, belt_prev=e._belt_prev,
                  cloud=e.cloud, wind_g=e.wind_g, e_az_prev=e._e_az,
                  e_el_prev=e._e_el, spot_phi=e.spot_phi,
                  spot_z=e.spot_z,
                  dni=getattr(e, "dni", np.full(B, 700.0)),
                  stowed=e.stowed, day_rotis=e.day_rotis,
                  hold_p=e._hold_p, hold_s=e._hold_s,
                  hold_j=e._hold_j)
        for k, v in sc.items():
            st[:, S0 + _SCAL.index(k)] = np.asarray(v, dtype=np.float64)
        self.st = torch.as_tensor(st, device=dev)
        for i, nm in enumerate(_SCAL):
            setattr(self, nm, self.st[:, S0 + i])
        self.T = self.st[:, 0:N]
        self.T_sub = self.st[:, N:2 * N]
        self.T_deep = self.st[:, 2 * N:3 * N]
        self.T_halo = self.st[:, 3 * N]
        self.T_sand = self.st[:, SB:SB + 2 * KSAND].view(B, 2, KSAND)
        self.bread_E = self.st[:, 3 * N + 1:3 * N + 1 + NB]
        self.bread_t = self.st[:, 3 * N + 1 + NB:3 * N + 1 + 2 * NB]
        self.bread_C = self.st[:, 3 * N + 1 + 2 * NB:
                               3 * N + 1 + 3 * NB]
        self.has_bread = self.st[:, 3 * N + 1 + 3 * NB:
                                 3 * N + 1 + 4 * NB]
        f = lambda a: torch.as_tensor(
            np.asarray(a, dtype=np.float32), device=dev).contiguous()
        self.day_v = f(e.day_v)
        self.lat_v = f(e.lat_v)
        self.soil = f(e.soil)
        self.off = f(e.bore)                       # bore state
        self.bore = self.off
        # kernel outputs / trace inputs, persistent
        z = lambda *s: torch.zeros(*s, dtype=torch.float32, device=dev)
        self.lv = z(B)
        self.sigb = z(B)
        self.dvec = z(B, 2)
        self.aim = z(B, 3)
        self.per = z(B, N + e.n_belt)       # N nodes, then the loaf columns
        self.lfp = torch.tensor([float(np.sqrt(e.bread_area) / 2.0)], dtype=torch.float32, device=dev)
        self.P = len(e._hx)
        self.thr = z(B * self.P)
        self.out6 = z(B * self.P, 6)
        OD = e.observations.shape[1]
        self.obs = z(B, OD)
        self.rew = z(B)
        self.trunc = z(B)
        self.diag = z(B, 8)
        self.sp = torch.as_tensor(_step_params(e), device=dev)
        nd = int(getattr(e, "_design_obs", np.zeros((B, 0))).shape[1])
        self.ip = torch.tensor([B, N, NB, e.N_HEADS, self.NS, OD, 0,
                                int(getattr(e, "sticky_k", 0)), nd,
                                int(getattr(e, "form_min", 1)),
                                int(bool(getattr(e, "night_carry", 0)))],
                               dtype=torch.int32, device=dev)
        L = e._pts_l.shape[0]
        self.tdims = torch.tensor([B, self.P, L, N + e.n_belt],
                                  dtype=torch.int32, device=dev)
        self.zero_noise = False
        self._rn0 = z(B, 12)
        self._ru5 = torch.full((B, 16), 0.5, device=dev)
        self._du0 = z(B, self.P)
        self._up5 = torch.full((B, self.P), 0.5, device=dev)
        # host mirrors the numpy wrapper / heuristics read
        env._p_in_t = self.diag[:, 0]
        env._e_el_t = self.diag[:, 1]
        env._e_az_t = self.diag[:, 2]
        env._trunc_t = self.trunc
        env._trunc_live = True
        env._spot_view = (self.spot_phi, self.spot_z)

    def draw(self):
        if self.zero_noise:
            return self._rn0, self._ru5
        g, dev = self.env._gen, self.env.device
        B = self.env.num_agents
        return (torch.randn(B, 12, generator=g, device=dev),
                torch.rand(B, 16, generator=g, device=dev))

    def n(self, *shape):
        if self.zero_noise:
            return torch.zeros(*shape, device=self.env.device)
        return torch.randn(*shape, generator=self.env._gen,
                           device=self.env.device)

    def u(self, *shape):
        if self.zero_noise:
            return torch.full(shape, 0.5, device=self.env.device)
        return torch.rand(*shape, generator=self.env._gen,
                          device=self.env.device)


def make_state(env):
    """FusedState wherever a megakernel backend is mounted (Metal on
    MPS, the NVRTC transpile on CUDA), GpuState elsewhere."""
    from tandoor_gpu_step import GpuState
    if (env._metal is not None
            and env.device.type in ("mps", "cuda")
            and env.n_nodes <= 20 and env.n_belt <= 12):
        return FusedState(env)
    return GpuState(env)


def fused_full_step(env, actions):
    """One env step: four kernel launches + the RNG draws. Returns
    (obs, rew, infos) - the _gpu_full_step contract."""
    F = env._gpu
    dev, B = env.device, env.num_agents
    lib = env._metal.lib
    env._mnt_prm[0] = float(env.t_solar[0])
    F.ip[6] = int(env.tick)          # the cook's hash clock
    mnt = env._metal.mount(F.day_v, F.lat_v, env._mnt_prm, B,
                           pnt=torch.stack([F.el_m, F.az_m], 1),
                           fct=env._fct)
    aux = mnt["aux"]
    env.t_solar += env.dt / 3600.0
    a = actions if torch.is_tensor(actions) else \
        torch.as_tensor(np.asarray(actions), device=dev)
    # .contiguous() is LOAD-BEARING: sample_logits returns action.T, a
    # non-contiguous (NH,B)-strided view; reshape((B,NH)) is a no-op on
    # it and .to() preserves the transposed strides, so the megakernel
    # (which reads act + b*NH assuming row-major) gets every agent's
    # heads scrambled - motors read the wrong head, drift off-sun, and
    # the whole sampled-rollout collect loop trains on garbage while
    # greedy (contiguous argmax) looks fine. Cost measured: champion
    # sampled 2213 guillotine cuts vs 0 with this line.
    a32 = a.reshape(B, env.N_HEADS).to(
        device=dev, dtype=torch.int32).contiguous()
    rn, ru = F.draw()
    lib.step_pre(F.lv, F.st, a32, rn, ru, F.sp, F.ip, aux, F.day_v,
                 F.lat_v, env._mnt_prm, F.sigb, F.dvec, F.off, F.aim,
                 F.per, env._fct)
    if getattr(env, "_det_trace", False):
        du = de = F._du0
        upick = us = F._up5
    else:
        rr = torch.randn(2 * B, F.P, generator=env._gen, device=dev)
        uu = torch.rand(2 * B, F.P, generator=env._gen, device=dev)
        du, de, upick, us = rr[:B], rr[B:], uu[:B], uu[B:]
    lib.tandoor_trace(F.thr, F.out6, env._pts_l, env._nrm_l, F.lv,
                      du, de, upick, F.sigb, F.dvec, F.off,
                      mnt["vp"], env._sc_base, mnt["Acan"], mnt["Mt"],
                      mnt["Cd"], env.ell_M, env.ell_S, env.ell_ctr_t,
                      env._V0t, F.tdims, env._ray_pw, F.soil, F.per,
                      us, F.aim, mnt["scb"], F.lfp, env._fct)
    lib.step_post(F.rew, F.st, F.per, F.sp, F.ip, rn, ru, F.day_v,
                  F.lat_v, env._mnt_prm, F.off, F.obs, F.trunc,
                  F.diag, a32, env._dsn_t, env._fct)
    env.tick += 1
    infos = []
    ts0 = float(env.t_solar[0])
    hr = int(ts0)
    if getattr(env, "hourly_metric", 0) \
            and hr > getattr(env, "_hr_mark", 8) and ts0 < 16.0:
        # rotis_per_hour: 8x denser scoring stream than the day-over
        # metric (one device sync per sim-hour, 1/240 steps)
        cur = float(F.day_rotis.mean())
        infos.append({"rotis_per_hour":
                      cur - getattr(env, "_hr_rotis", 0.0),
                      "rotis_per_day": cur,
                      "scorched": float(F.ep_scorch.mean())})
        env._hr_rotis = cur
        env._hr_mark = hr
    if ts0 >= 16.0:
        return _day_over(env, F, infos)
    env.terminals[:] = False
    return F.obs, F.rew, infos


def _day_over(env, F, infos):
    """The synchronized end-of-day branch, in place on the packed
    state (mirror of _gpu_full_step's, which mirrors numpy's)."""
    from tandoor_mount_batch import solar_batch
    S, B, dev = F, env.num_agents, env.device
    N = env.n_nodes
    inflight = 0.3 * S.has_bread.sum(1) \
        + 2.0 * (S.bread_E / env._ds_roti_t[:, None]).clamp(0.0, 1.0).sum(1)
    rew = F.rew - inflight
    S.ep_return.sub_(inflight)
    infos.append({
        "rotis_per_day": float(S.day_rotis.mean()),
        "scorched": float(S.ep_scorch.mean()),
        "spall_events": float(S.ep_spall.mean()),
        "form_minutes": float(S.form_time.mean() * env.dt / 60),
        "episode_return": float(S.ep_return.mean()),
        "episode_length": float(S.ep_len.mean()),
    })
    env.terminals[:] = True
    env.t_solar[:] = 8.0
    need_dawn = torch.zeros(B, dtype=torch.bool, device=dev)
    dawn_charge = torch.zeros(B, device=dev)
    if getattr(env, "night_carry", 0) and not getattr(env, "consecutive_days", 1):
        # control: a random day and latitude, the pot carried, the figure re-formed
        if env.day_random:
            env.day_v[:] = env.rng.integers(1, 366, B); env.day = int(env.day_v[0])
        if env.lat_random:
            env.lat_v[:] = env.rng.uniform(15.0, 35.0, B); env.lat = float(env.lat_v[0])
        S.decl_formed.copy_(23.44 * torch.sin(2.0 * np.pi * (284.0 + torch.as_tensor(env.day_v.astype(np.float32), device=dev)) / 365.0))
    elif getattr(env, "night_carry", 0):
        # the pit carried the night: tomorrow is the NEXT day at the SAME
        # site (the site does not move; the declination drifts slowly
        # and the figure keeps yesterday's, until the cook re-forms)
        env.day_v[:] = env.day_v % 365 + 1
        env.day = int(env.day_v[0])
        # the dawn routine (numpy twin): re-form by hand when the figure
        # has drifted form_drift degrees, charged form_min soft steps
        decl_t = 23.44 * torch.sin(2.0 * np.pi * (284.0 + torch.as_tensor(env.day_v.astype(np.float32), device=dev)) / 365.0)
        need_dawn = (decl_t - S.decl_formed).abs() >= float(getattr(env, "form_drift", 2.0))
        S.decl_formed.copy_(torch.where(need_dawn, decl_t, S.decl_formed))
        dawn_charge = 0.02 * float(getattr(env, "form_min", 4)) * need_dawn.float()
        rew = rew - dawn_charge
    else:
        if env.day_random:
            env.day_v[:] = env.rng.integers(1, 366, B)
            env.day = int(env.day_v[0])
        if env.lat_random:
            env.lat_v[:] = env.rng.uniform(15.0, 35.0, B)
            env.lat = float(env.lat_v[0])
    S.day_v.copy_(torch.as_tensor(env.day_v.astype(np.float32),
                                  device=dev))
    S.lat_v.copy_(torch.as_tensor(env.lat_v.astype(np.float32),
                                  device=dev))
    el1, az1r, _ = solar_batch(S.lat_v, S.day_v,
                               torch.full_like(S.day_v, 8.0))
    az1d = torch.rad2deg(az1r)
    if getattr(env, "night_carry", False):
        # yesterday's pot through the night with the wall model (in
        # place on the packed state); warm_frac seeds only the first day
        env._night_cool_torch(S)
    else:
        warm = (S.u(B) < env.warm_frac)
        newT = torch.where(
            warm[:, None],
            (465.0 + 40.0 * S.u(B))[:, None].expand(B, N),
            torch.full((B, N), 350.0, device=dev)) \
            + (S.u(B, N) - 0.5) * 30.0
        S.T.copy_(newT)
        S.T_sub.copy_(newT)
        S.T_deep.copy_(newT)
        NBb = env.n_belt
        S.T_sand.copy_(newT[:, NBb:NBb + 2, None].expand(B, 2, KSAND))
        S.T_halo.copy_(torch.where(warm, 395.0 + 20.0 * S.u(B),
                                   torch.full((B,), 300.0, device=dev)))
    for nm in ("ep_rotis", "ep_scorch", "ep_spall", "ep_return",
               "ep_len", "bread_E", "bread_t", "bread_C",
               "form_time", "wind_g", "cloud", "p_dist",
               "day_rotis"):
        getattr(S, nm).zero_()
    # the dawn routine's book: the minutes and the charge land in the new day
    S.form_time.copy_(need_dawn.float() * float(getattr(env, "form_min", 4)))
    S.ep_return.sub_(dawn_charge)
    env._hr_mark = 8
    env._hr_rotis = 0.0
    S.has_bread.zero_()
    S.p_set.fill_(env.p0)
    S.p_act.fill_(env.p0)
    S.shutter.fill_(1.0)
    S.hold_p.fill_(4.0)
    S.hold_s.fill_(6.0)
    S.hold_j.fill_(6.0)
    # numpy day-over also resets the membrane (jammed at p0, formed
    # to the NEW day's declination). Missing here, day_random carried
    # yesterday's figure into the redrawn day: E|d decl| = 19 deg ->
    # ~3.4x dawn optics blur, on the training path only (the parity
    # harness never crosses a day-over; probes reset() to a matched
    # decl). Per-agent decl, same formula as the kernel.
    S.jammed.fill_(1.0)
    S.f_locked.fill_(env.p0)
    if not getattr(env, "night_carry", 0):
        # a fresh pot is a fresh machine, formed on commissioning; with
        # the carry-over the figure persists and the re-form is PAID
        S.decl_formed.copy_(23.44 * torch.sin(
            2.0 * np.pi * (284.0 + S.day_v) / 365.0))
    S.soil.copy_(0.90 + 0.08 * S.u(B))
    S.el_m.copy_((el1 + 0.3 * S.n(B)).clamp(env.el_min_h,
                                            env.el_max_h))
    S.az_m.copy_(az1d + 0.3 * S.n(B))
    S.e_el_prev.copy_(S.el_m - el1)
    S.e_az_prev.copy_((S.az_m - az1d) * torch.cos(torch.deg2rad(el1)))
    S.belt_prev.copy_(S.T[:, :env.n_belt].max(1).values)
    obs, rew, infos = env._gpu_obs(S, dev, B, rew, F.diag[:, 0],
                                   S.e_el_prev, S.e_az_prev, infos)
    return obs, rew, infos


def verify_fused(B=32, steps=120, quiet=False, dev="mps"):
    """Same device, zero noise: the torch gpu_step path and the fused
    kernels must produce the same obs/reward trajectory from the same
    initial state and action script. (On CUDA the torch path shares
    the kernel TRACE via _metal_trace, so this gates the step logic;
    the MPS-frozen bundle in tandoor_step_verify gates the trace.)"""
    import contextlib
    import io
    from tandoor_gpu_step import GpuState
    from tandoor_step_verify import _env, _script

    def run(force_torch):
        e = _env(dev)
        S = GpuState(e) if force_torch else FusedState(e)
        S.zero_noise = True
        e._gpu = S
        obs_t, rew_t = [], []
        for t in range(steps):
            a = torch.as_tensor(_script(t), device=e.device)
            o, r, d, tr, _ = e.step_torch(a)
            obs_t.append(o.cpu().clone())
            rew_t.append(r.cpu().clone())
        return torch.stack(obs_t), torch.stack(rew_t)

    o1, r1 = run(True)
    o2, r2 = run(False)
    do = float((o1 - o2).abs().max())
    dr = float((r1 - r2).abs().max())
    per_step = (o1 - o2).abs().amax(dim=(1, 2))
    first_bad = int((per_step > 5e-3).float().argmax()) \
        if bool((per_step > 5e-3).any()) else -1
    if not quiet:
        print(f"fused vs torch step: max obs err {do:.2e}, "
              f"max rew err {dr:.2e}, first step over 5e-3: "
              f"{first_bad}")
    assert do < 5e-3, "fused obs trajectory diverges"
    assert dr < 2e-2, "fused reward trajectory diverges"
    if not quiet:
        print("fused-vs-torch step parity: PASS")
    return do, dr


if __name__ == "__main__":
    verify_fused()

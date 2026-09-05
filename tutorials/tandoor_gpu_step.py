"""The whole Hashemi step on-device: the answer to the last 14 ms.

Profiled at B=16384: the megakernel trace was 4.9 ms and the numpy
state machine 14.2 ms - hundreds of small (B,) array ops in the
inherited polar step, host->device tensor builds, and obs assembly.
This module keeps ALL per-agent state as MPS tensors and runs one
torch step mirroring tandoor_polar_env.step + TandoorHashemiEnv.step
LINE FOR LINE. Python keeps only: the scalar sun clock, the rare
day-over branch (one step in 1922, synchronized), and the single
obs/reward copy into pufferlib's numpy buffers.

PARITY DISCIPLINE, same as the megakernel's: the numpy path remains
the reference. verify_gpu_step() runs both from identical state with
NOISE FORCED TO ZERO (the physics is deterministic given draws) and
compares full state trajectories; the stochastic terms are additive
OU noises transcribed 1:1 and drawn from the env's torch generator.
Physics changes land in the numpy step first, then here.
"""
import numpy as np
import torch

SIGMA = 5.67e-8  # match tandoor_rl_env exactly
T_AMB = 300.0
R_MOUTH = 0.26


class GpuState:
    def __init__(self, env):
        self.env = env
        dev = env.device
        f = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32),
                                      device=dev)
        bl = lambda a: torch.as_tensor(np.asarray(a, dtype=bool),
                                       device=dev)
        e = env
        self.T = f(e.T); self.p_act = f(e.p_act); self.p_set = f(e.p_set)
        self.spot_phi = f(e.spot_phi); self.spot_z = f(e.spot_z)
        self.bread_C = f(e.bread_C)
        self.day_v = f(e.day_v); self.lat_v = f(e.lat_v)
        self.p_dist = f(e.p_dist); self.shutter = f(e.shutter)
        self.cloud = f(e.cloud); self.wind_g = f(e.wind_g)
        self.bore = f(e.bore); self.stowed = bl(e.stowed)
        self.jammed = bl(e.jammed); self.f_locked = f(e.f_locked)
        self.form_time = f(e.form_time); self.decl_formed = f(e.decl_formed)
        self.load_timer = f(e.load_timer); self.has_bread = bl(e.has_bread)
        self.bread_E = f(e.bread_E); self.bread_t = f(e.bread_t)
        self.ep_rotis = f(e.ep_rotis); self.ep_scorch = f(e.ep_scorch)
        self.day_rotis = f(e.day_rotis)
        self.ep_spall = f(e.ep_spall); self.ep_return = f(e.ep_return)
        self.ep_len = f(e.ep_len); self.soil = f(e.soil)
        self.el_m = f(e.el_m); self.az_m = f(e.az_m)
        self.lost_ct = torch.as_tensor(e._lost_ct, device=dev)
        self.belt_prev = f(e._belt_prev)
        self.dni = f(getattr(e, "dni", np.full(e.num_agents, 700.0)))
        self.e_az_prev = f(e._e_az)
        self.e_el_prev = f(e._e_el)
        self.hold_p = f(e._hold_p)
        self.hold_s = f(e._hold_s)
        self.hold_j = f(e._hold_j)
        self.node_area = f(e.node_area)[None, :]
        self.node_heat_cap = f(e.node_heat_cap)
        self.T_sub = f(e.T_sub); self.T_deep = f(e.T_deep)
        self.cap_sub = f(e.cap_sub); self.cap_deep = f(e.cap_deep)
        self.g01 = f(e.g01); self.g12 = f(e.g12); self.g2s = f(e.g2s)
        self.T_halo = f(e.T_halo)
        self.g_halo_out = float(e.g_halo_out)
        self.c_halo = float(e.c_halo)
        self.level_frac = f(e.level_frac)
        self.zero_noise = False

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


def gpu_step(env, actions):
    """One full env step on-device. Mirrors TandoorHashemiEnv.step ->
    TandoorPolarEnv.step line for line (see module docstring)."""
    from tandoor_rl_env import _sim
    S, dev = env._gpu, env.device
    B = env.num_agents
    if isinstance(actions, torch.Tensor):
        a = actions.to(dev).reshape(B, env.N_HEADS)
    else:
        a = torch.as_tensor(np.asarray(actions).reshape(B, env.N_HEADS),
                            device=dev)
    dt = env.dt

    # ---- Hashemi motors (BEFORE the optics see the sun this step)
    mnt = env._mount(S.day_v, S.lat_v, float(env.t_solar[0]),
                     pnt=torch.stack([S.el_m, S.az_m], 1))
    el0s = mnt["el"]                     # (B,) deg - per-env sun
    az0d = torch.rad2deg(mnt["az"])
    # potential BEFORE this step's motor action (see the numpy path)
    pot_prev = (S.e_az_prev.abs() + S.e_el_prev.abs()).clamp(max=4.0)
    r_az = (a[:, 3].clamp(0, 6).float() - 3) / 3.0 * env.RATE_AZ
    r_el = (a[:, 4].clamp(0, 6).float() - 3) / 3.0 * env.RATE_EL
    if getattr(env, "elbow_aim", 0):
        from tandoor_polar_env import (SPOT_PHI_RANGE, SPOT_Z_RANGE,
                                       RATE_SPOT_PHI, RATE_SPOT_Z)
        r_ph = (a[:, 5].clamp(0, 6).float() - 3) / 3.0 * RATE_SPOT_PHI
        r_zz = (a[:, 6].clamp(0, 6).float() - 3) / 3.0 * RATE_SPOT_Z
        S.spot_phi = (S.spot_phi + torch.deg2rad(r_ph) * dt).clamp(
            SPOT_PHI_RANGE[0], SPOT_PHI_RANGE[1])
        S.spot_z = (S.spot_z + r_zz * dt).clamp(
            SPOT_Z_RANGE[0], SPOT_Z_RANGE[1])
    env._spot_view = (S.spot_phi, S.spot_z)
    S.az_m = S.az_m + r_az * dt + 0.02 * S.n(B)
    S.el_m = (S.el_m + r_el * dt + 0.02 * S.n(B)).clamp(
        env.el_min_h - 2.0, env.el_max_h + 1.0)
    e_el = S.el_m - el0s
    e_az = (S.az_m - az0d) * torch.cos(torch.deg2rad(el0s))

    # ---- polar step: heads, jam, servo
    # sticky engagement: heads 0-2 latch, fresh actions land only on
    # ticks where tick % sticky_k == 0 (numpy twin: polar step)
    a0, a1, a2 = a[:, 0], a[:, 1], a[:, 2]
    k_st = int(getattr(env, "sticky_k", 0))
    if k_st > 1:
        if int(env.tick) % k_st == 0:
            S.hold_p = a0.float()
            S.hold_s = a1.float()
            S.hold_j = a2.float()
        else:
            a0 = S.hold_p.long()
            a1 = S.hold_s.long()
            a2 = S.hold_j.long()
    thr_g = 3.5 if env.wide_shutter else 0.5
    S.p_set = env.p0 * S.level_frac[a0.clamp(0, 6).long()]
    S.shutter = (a1 > thr_g).float()
    want_jam = a2 > thr_g
    jamming = (~S.jammed) & want_jam
    S.jammed = want_jam.clone()
    S.form_time = S.form_time + (~S.jammed).float()
    bias = 0.05 * (S.dni - 400.0) / 10.0
    S.p_dist = (S.p_dist + (bias - S.p_dist) / 900.0 * dt
                + 1.2 * S.n(B)).clamp(-40, 60)
    soft = ~S.jammed
    S.p_act = torch.where(
        soft, S.p_act + (S.p_set + S.p_dist - S.p_act).clamp(-6, 6),
        S.p_act)
    S.f_locked = torch.where(jamming, S.p_act, S.f_locked)
    decl_now = 23.44 * torch.sin(2.0 * np.pi * (284.0 + S.day_v)
                                 / 365.0)
    S.decl_now = decl_now
    S.decl_formed = torch.where(soft, decl_now, S.decl_formed)

    # ---- sun scalars (python), cloud/wind OU (device)
    env.t_solar += dt / 3600.0
    ts = float(env.t_solar[0])
    sin_el0 = torch.sin(torch.deg2rad(el0s))
    am = 1.0 / sin_el0.clamp(min=0.035)
    clear = torch.where(
        el0s > 2.0,
        1353.0 * torch.pow(torch.tensor(0.7, device=dev),
                           am ** 0.678),
        torch.zeros_like(am))
    tau_c = 900.0
    S.cloud = (S.cloud - S.cloud/tau_c*dt
               + 0.25*np.sqrt(2*dt/tau_c) * S.n(B))
    S.cloud = torch.where(S.u(B) < 0.0015*dt/15.0, S.cloud - 1.5, S.cloud)
    S.cloud = S.cloud.clamp(-3, 0.25)
    base_w = 2.5 + 3.5*np.sin(np.pi*np.clip((ts - 8.0)/8.0, 0, 1))
    S.wind_g = S.wind_g - S.wind_g/600.0*dt \
        + 1.8*np.sqrt(2*dt/600.0) * S.n(B)
    wind = ((base_w + S.wind_g) * env.wall_shelter).clamp(0, 25)
    S.stowed = (S.stowed | (wind > 16.0)) & ~(wind < 14.0)
    S.wind = wind
    el0 = el0s
    day_up = (el0 > 8.0).float()
    cosf = day_up * float(env._cosine(0.0))
    dni = clear * torch.exp(S.cloud) * day_up * (~S.stowed).float()
    S.dni = dni

    # ---- wind -> figure, jam-gated
    q_w = 0.6 * wind**2
    gain = torch.where(S.jammed, torch.full_like(q_w, env.jam_gain),
                       torch.ones_like(q_w))
    p_eff = torch.where(S.jammed, S.f_locked, S.p_act) \
        + gain * q_w * torch.sign(S.n(B))
    sig_wind = gain * 0.88e-3 * (q_w.clamp(min=1e-9)/15.0)**0.6
    drift_t = (S.decl_formed - S.decl_now).abs()
    sig_drift = torch.deg2rad(drift_t) * 0.04
    sigma_b = torch.sqrt(env.sig_static**2
                         + (2*0.35*sig_wind)**2 + sig_drift**2)
    S.bore = S.bore - S.bore/300.0*dt \
        + 0.010*np.sqrt(2*dt/300.0) * S.n(B, 2)

    # ---- the MEGAKERNEL, per-env geometry; scb's el_ok gates
    # out-of-range envs inside the kernel
    per = env._metal_trace(p_eff, sigma_b, S.bore, S.soil,
                           e_el, e_az, mnt)
    gate = dni * cosf * S.shutter * S.jammed.float()
    q_solar = per * gate[:, None] * 0.85
    p_in = per.sum(1) * gate
    # DONENESS POTENTIAL, phi_old (numpy twins line for line):
    # in-oven doneness at step start, before any bread energy moves
    phi_old = (S.bread_E / env.roti_energy).clamp(0.0, 1.0).sum(1)
    if getattr(env, "spot_bread", 0):
        from tandoor_polar_env import (SPOT_AREA, Z_BAKE_LO, Z_CROWN)
        import numpy as _np
        kb = (((S.spot_phi + _np.pi) / (2 * _np.pi)
               * env.n_belt).long()) % env.n_belt
        valid = (S.spot_z >= Z_BAKE_LO) & (S.spot_z <= Z_CROWN)
        fcov = min(env.bread_area / SPOT_AREA, 1.0)
        # EVERY loaded loaf takes the beam landing on ITS bin (2026-09-06):
        # the footprint the optics put on the belt - focused on one bin,
        # defocused by the level head over several, swept by the spot
        # heads - is what bakes, and each loaf chars on its own share.
        # The old rule fed only the aimed bin's loaf, so a spread beam
        # heated walls next to the loaves it was lighting. Spreading is
        # the network's behaviour through the mirror, not a knob.
        nb = env.n_belt
        lit_b = (S.has_bread[:, :nb] & valid[:, None]).float()
        frb_b = (S.bread_E[:, :nb] / env.roti_energy).clamp(0, 1)
        alpha_b = 0.55 + 0.35 * frb_b
        inc_b = per[:, :nb] * gate[:, None]
        q_b = lit_b * alpha_b * fcov * inc_b
        q_solar[:, :nb] = q_solar[:, :nb] - lit_b * 0.85 * fcov * inc_b
        S.bread_E[:, :nb] = S.bread_E[:, :nb] + q_b * dt
        q_direct = q_b.sum(1)
        env._spot_bin_t = (kb, valid)
        env._spot_q_t = q_b
        env._spot_flux_t = q_direct / max(env.bread_area, 1e-6)

    # ---- thermal / bread / reward (polar's copy, 950 K structure term)
    T = S.T
    t4 = T**4
    t_cav4 = (S.node_area * t4).sum(1, keepdim=True) / S.node_area.sum()
    q_exch = 0.85 * SIGMA * S.node_area * (t_cav4 - t4)
    lid = torch.where(S.load_timer < 4.0, torch.ones_like(S.load_timer),
                      torch.full_like(S.load_timer, env.lid_leak))
    q_ap = 0.75 * SIGMA * (t_cav4.squeeze(1) - T_AMB**4) \
        * (np.pi * R_MOUTH**2) * lid
    q01 = S.g01 * (T - S.T_sub)
    q12 = S.g12 * (S.T_sub - S.T_deep)
    q2s = S.g2s * (S.T_deep - S.T_halo[:, None])
    q = q_solar + q_exch - q01
    S.T_sub = S.T_sub + (q01 - q12) * dt / S.cap_sub
    S.T_deep = S.T_deep + (q12 - q2s) * dt / S.cap_deep
    S.T_halo = S.T_halo + (
        q2s.sum(1) - S.g_halo_out * (S.T_halo - T_AMB)) * dt / S.c_halo
    q[:, env.n_belt + 2] -= q_ap
    belt_T = T[:, :env.n_belt]
    # dough exchanges at its own temperature: room-temp coldstart
    # warming to ~400 K at full bake (numpy twins line for line)
    t_dough = T_AMB + 100.0 * (S.bread_E.clamp(min=0.0)
                               / env.roti_energy).clamp(max=1.0)
    q_b = S.has_bread.float() * env.h_bread * (belt_T - t_dough)
    q[:, :env.n_belt] -= q_b
    dT = q * dt / S.node_heat_cap
    S.T = T + dT
    S.bread_E = S.bread_E + q_b * dt
    S.bread_t = S.bread_t + S.has_bread.float() * dt
    spall = dT[:, env.n_belt] > 25.0
    S.ep_spall = S.ep_spall + spall.float()

    rew = torch.zeros(B, device=dev)
    belt_T = S.T[:, :env.n_belt]
    # char as a RATE (wall time-at-temperature + beam flux on the
    # loaf); ready loaves wait for the cook's lean - see numpy twin
    c_dot = (belt_T - 800.0).clamp(min=0) / 6000.0
    if getattr(env, "spot_bread", 0):
        kbc, validc = env._spot_bin_t
        # per-loaf beam flux: each loaf chars on its own share
        fkw_b = env._spot_q_t / max(env.bread_area, 1e-6) / 1000.0
        c_dot = c_dot + (fkw_b - 8.0).clamp(min=0) / 1000.0 * validc.float()[:, None]
    S.bread_C = S.bread_C + S.has_bread.float() * c_dot * dt
    ready = S.has_bread & (S.bread_E >= env.roti_energy)
    # ONE lean event: pull and load share the opening (post-increment
    # timer; see the numpy twins)
    pull_open = S.load_timer + dt >= env.load_period
    cooked = ready & pull_open[:, None]
    scorched = S.has_bread & (S.bread_C >= 1.0)
    # NO doughy timeout: cooked or charred only (numpy twins)
    rew = rew + 5.0*cooked.float().sum(1) - 5.0*scorched.float().sum(1) \
        - 0.5*spall.float()
    S.ep_rotis = S.ep_rotis + cooked.float().sum(1)
    S.day_rotis = S.day_rotis + cooked.float().sum(1)
    S.ep_scorch = S.ep_scorch + scorched.float().sum(1)
    done_b = cooked | scorched
    S.has_bread = S.has_bread & ~done_b
    S.bread_E = torch.where(done_b, torch.zeros_like(S.bread_E), S.bread_E)
    S.bread_t = torch.where(done_b, torch.zeros_like(S.bread_t), S.bread_t)
    S.bread_C = torch.where(done_b, torch.zeros_like(S.bread_C), S.bread_C)
    S.load_timer = S.load_timer + dt
    can = S.load_timer >= env.load_period
    loads = torch.zeros(B, device=dev)
    if getattr(env, "load_ctrl", 0):
        # the POLICY plays the cook (numpy twins line for line):
        # last n_belt heads gate each bin, empty bins only, up to
        # loaves_per_load per lean
        mask = a[:, -env.n_belt:].float() > thr_g
        left = torch.full((B,), float(env.loaves_per_load),
                          device=dev)
        hb_ = S.has_bread.clone()
        for k in range(env.n_belt):
            place = can & mask[:, k] & ~hb_[:, k] & (left > 0)
            hb_[:, k] = hb_[:, k] | place
            left = left - place.float()
            loads = loads + place.float()
        S.has_bread = hb_
    else:
        # RANDOM bins via cook_bin's hash, int64+mask (two's-
        # complement wraparound recovers uint32 semantics exactly)
        bidx = getattr(S, "_bidx", None)
        if bidx is None:
            bidx = S._bidx = torch.arange(B, device=dev)
        M32 = 0xFFFFFFFF
        tick = int(env.tick)
        for _k in range(env.loaves_per_load):
            s0 = (bidx + tick * 57 + _k * 241) & M32
            s0 = ((s0 << 13) ^ s0) & M32
            t0 = ((s0 * s0) & M32) * 15731 + 789221
            v = (s0 * (t0 & M32) + 1376312589) & 0x7FFFFFFF
            j = (v * env.n_belt) >> 31   # HIGH bits: low are structured
            place = can & ~S.has_bread.gather(1, j[:, None]).squeeze(1)
            oh = torch.nn.functional.one_hot(j, env.n_belt).bool() \
                & place[:, None]
            S.has_bread = S.has_bread | oh
            loads = loads + place.float()
    S.load_timer = torch.where(can, torch.zeros_like(S.load_timer),
                               S.load_timer)
    rew = rew + 0.3 * loads
    # HOLDING COST (numpy twins line for line): in-flight loaves
    # drip 0.3/loaves_per_load per step
    rew = rew - (0.03 / max(env.loaves_per_load, 1)) \
        * S.has_bread.float().sum(1)
    # DONENESS POTENTIAL (numpy twins line for line): +2 per full
    # loaf-equivalent of energy INTO dough, telescoped
    rew = rew + 2.0 * ((S.bread_E / env.roti_energy)
                       .clamp(0.0, 1.0).sum(1) - phi_old)
    # BANDED-SUM preheat potential, REINSTATED (numpy twins line
    # for line; see rl_env for the why)
    rew = rew + 0.05 * (belt_T.clamp(max=453.0)
                        - T[:, :env.n_belt].clamp(max=453.0)) \
        .clamp(-5.0, 5.0).sum(1)
    S.belt_prev = belt_T.max(1).values.clone()
    rew = rew - 0.02 * (~S.jammed).float()

    # ---- Hashemi shaping + truncation + wrap
    e_el2 = S.el_m - el0s
    e_az2 = (S.az_m - az0d) * torch.cos(torch.deg2rad(el0s))
    pot_now = (e_az2.abs() + e_el2.abs()).clamp(max=4.0)
    rew = rew + 1.0 * (pot_prev - pot_now)
    S.e_az_prev, S.e_el_prev = e_az2, e_el2
    lost = (e_az2.abs() + e_el2.abs()) > float(getattr(env, 'lost_deg', 3.0))
    S.lost_ct = torch.where(lost, S.lost_ct + 1,
                            torch.zeros_like(S.lost_ct))
    cut = S.lost_ct >= 40

    S.ep_return = S.ep_return + rew
    S.ep_len = S.ep_len + 1
    env.tick += 1
    return rew, cut, p_in, e_el2, e_az2

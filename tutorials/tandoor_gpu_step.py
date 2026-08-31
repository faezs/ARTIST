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
        self.p_dist = f(e.p_dist); self.shutter = f(e.shutter)
        self.cloud = f(e.cloud); self.wind_g = f(e.wind_g)
        self.bore = f(e.bore); self.stowed = bl(e.stowed)
        self.jammed = bl(e.jammed); self.f_locked = f(e.f_locked)
        self.form_time = f(e.form_time); self.decl_formed = f(e.decl_formed)
        self.load_timer = f(e.load_timer); self.has_bread = bl(e.has_bread)
        self.bread_E = f(e.bread_E); self.bread_t = f(e.bread_t)
        self.ep_rotis = f(e.ep_rotis); self.ep_scorch = f(e.ep_scorch)
        self.ep_spall = f(e.ep_spall); self.ep_return = f(e.ep_return)
        self.ep_len = f(e.ep_len); self.soil = f(e.soil)
        self.el_m = f(e.el_m); self.az_m = f(e.az_m)
        self.lost_ct = torch.as_tensor(e._lost_ct, device=dev)
        self.belt_prev = f(e._belt_prev)
        self.dni = f(getattr(e, "dni", np.full(e.num_agents, 700.0)))
        self.e_az_prev = f(e._e_az)
        self.e_el_prev = f(e._e_el)
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
    el0s, az0s, _ = _sim.solar_position(env.lat, env.day,
                                        float(env.t_solar[0]))
    az0d = np.degrees(az0s)
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
    e_az = (S.az_m - az0d) * float(np.cos(np.radians(el0s)))

    # ---- polar step: heads, jam, servo
    thr_g = 3.5 if env.wide_shutter else 0.5
    S.p_set = env.p0 * S.level_frac[a[:, 0].clamp(0, 6).long()]
    S.shutter = (a[:, 1] > thr_g).float()
    want_jam = a[:, 2] > thr_g
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
    decl = env._decl()
    S.decl_formed = torch.where(soft, torch.full_like(S.decl_formed,
                                                      float(decl)),
                                S.decl_formed)

    # ---- sun scalars (python), cloud/wind OU (device)
    env.t_solar += dt / 3600.0
    ts = float(env.t_solar[0])
    phi = np.radians(env.lat)
    delta = np.radians(23.44) * np.sin(2*np.pi*(284 + env.day)/365)
    hh = np.radians(15.0 * (ts - 12.0))
    sin_el = (np.sin(phi)*np.sin(delta)
              + np.cos(phi)*np.cos(delta)*np.cos(hh))
    el_deg = np.degrees(np.arcsin(np.clip(sin_el, -1, 1)))
    am = 1.0 / max(sin_el, 0.035)
    clear = 1353.0 * 0.7 ** (am ** 0.678) if el_deg > 2.0 else 0.0
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
    el0 = el_deg
    cosf = env._cosine(decl) if el0 > 8.0 else 0.0
    dni = clear * torch.exp(S.cloud) * float(el0 > 8.0) * (~S.stowed).float()
    S.dni = dni

    # ---- wind -> figure, jam-gated
    q_w = 0.6 * wind**2
    gain = torch.where(S.jammed, torch.full_like(q_w, env.jam_gain),
                       torch.ones_like(q_w))
    p_eff = torch.where(S.jammed, S.f_locked, S.p_act) \
        + gain * q_w * torch.sign(S.n(B))
    sig_wind = gain * 0.88e-3 * (q_w.clamp(min=1e-9)/15.0)**0.6
    drift = abs(decl - 0) # placeholder replaced below
    drift_t = (S.decl_formed - float(decl)).abs()
    sig_drift = torch.deg2rad(drift_t) * 0.04
    sigma_b = torch.sqrt(env.sig_static**2
                         + (2*0.35*sig_wind)**2 + sig_drift**2)
    S.bore = S.bore - S.bore/300.0*dt \
        + 0.010*np.sqrt(2*dt/300.0) * S.n(B, 2)

    # ---- gate on tracking range, then the MEGAKERNEL
    if env.el_min_h <= el0 <= env.el_max_h:
        per = env._metal_trace(p_eff, sigma_b, S.bore, S.soil,
                               e_el, e_az, el0)
    else:
        per = torch.zeros(B, env.n_nodes, device=dev)
    gate = dni * cosf * S.shutter * S.jammed.float()
    q_solar = per * gate[:, None] * 0.85
    p_in = per.sum(1) * gate
    if getattr(env, "spot_bread", 0):
        from tandoor_polar_env import (SPOT_AREA, Z_BAKE_LO, Z_CROWN)
        import numpy as _np
        kb = (((S.spot_phi + _np.pi) / (2 * _np.pi)
               * env.n_belt).long()) % env.n_belt
        valid = (S.spot_z >= Z_BAKE_LO) & (S.spot_z <= Z_CROWN)
        kb1 = kb[:, None]
        lit = (S.has_bread.gather(1, kb1).squeeze(1)
               & valid).float()
        frb = (S.bread_E.gather(1, kb1).squeeze(1)
               / env.roti_energy).clamp(0, 1)
        alpha = 0.55 + 0.35 * frb
        fcov = min(env.bread_area / SPOT_AREA, 1.0)
        inc = per.gather(1, kb1).squeeze(1) * gate
        q_direct = lit * alpha * fcov * inc
        q_solar.scatter_add_(1, kb1,
                             (-lit * 0.85 * fcov * inc)[:, None])
        S.bread_E.scatter_add_(1, kb1, (q_direct * dt)[:, None])
        env._spot_bin_t = (kb, valid)
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
    q_b = S.has_bread.float() * env.h_bread * (belt_T - 400.0)
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
    c_dot = (belt_T - 700.0).clamp(min=0) / 6000.0
    if getattr(env, "spot_bread", 0):
        kbc, validc = env._spot_bin_t
        fkw = env._spot_flux_t / 1000.0
        addc = torch.zeros_like(c_dot)
        addc.scatter_(1, kbc[:, None],
                      ((fkw - 8.0).clamp(min=0) / 1000.0
                       * validc.float())[:, None])
        c_dot = c_dot + addc
    S.bread_C = S.bread_C + S.has_bread.float() * c_dot * dt
    ready = S.has_bread & (S.bread_E >= env.roti_energy)
    pull_open = (S.load_timer >= env.load_period) & (S.shutter < 0.5)
    cooked = ready & pull_open[:, None]
    scorched = S.has_bread & (S.bread_C >= 1.0)
    doughy = S.has_bread & (S.bread_t > 300.0) & ~ready
    rew = rew + 5.0*cooked.float().sum(1) - 5.0*scorched.float().sum(1) \
        - 0.5*doughy.float().sum(1) - 0.5*spall.float()
    S.ep_rotis = S.ep_rotis + cooked.float().sum(1)
    S.ep_scorch = S.ep_scorch + scorched.float().sum(1)
    done_b = cooked | scorched | doughy
    S.has_bread = S.has_bread & ~done_b
    S.bread_E = torch.where(done_b, torch.zeros_like(S.bread_E), S.bread_E)
    S.bread_t = torch.where(done_b, torch.zeros_like(S.bread_t), S.bread_t)
    S.bread_C = torch.where(done_b, torch.zeros_like(S.bread_C), S.bread_C)
    S.load_timer = S.load_timer + dt
    ok_ = (~S.has_bread) & (belt_T >= 453.0) & (belt_T <= 700.0)
    can = (S.load_timer >= env.load_period) & ok_.any(1)
    j = torch.where(ok_, belt_T,
                    torch.full_like(belt_T, -1e30)).argmax(1)
    put = can[:, None] & (torch.nn.functional.one_hot(
        j, env.n_belt).bool())
    S.has_bread = S.has_bread | put
    S.load_timer = torch.where(can, torch.zeros_like(S.load_timer),
                               S.load_timer)
    rew = rew + 0.3 * can.float()
    belt_max = belt_T.max(1).values
    below = (belt_max < 453.0).float()
    rew = rew + 0.05 * (belt_max - S.belt_prev).clamp(-5, 5) * below
    S.belt_prev = belt_max.clone()
    rew = rew - 0.02 * (~S.jammed).float()

    # ---- Hashemi shaping + truncation + wrap
    e_el2 = S.el_m - el0s
    e_az2 = (S.az_m - az0d) * float(np.cos(np.radians(el0s)))
    pot_now = (e_az2.abs() + e_el2.abs()).clamp(max=4.0)
    rew = rew + 0.1 * (pot_prev - pot_now)
    S.e_az_prev, S.e_el_prev = e_az2, e_el2
    lost = (e_az2.abs() + e_el2.abs()) > 3.0
    S.lost_ct = torch.where(lost, S.lost_ct + 1,
                            torch.zeros_like(S.lost_ct))
    cut = S.lost_ct >= 40

    S.ep_return = S.ep_return + rew
    S.ep_len = S.ep_len + 1
    env.tick += 1
    return rew, cut, p_in, e_el2, e_az2

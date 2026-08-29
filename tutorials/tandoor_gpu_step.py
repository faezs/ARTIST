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

SIGMA = 5.670374419e-8
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
        self.r_soil = f(e.r_soil) if np.ndim(e.r_soil) else float(e.r_soil)
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
    sigma_b = torch.sqrt(env.sigma_sun**2 + env.sig_static**2
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

    # ---- thermal / bread / reward (polar's copy, 950 K structure term)
    T = S.T
    t4 = T**4
    t_cav4 = (S.node_area * t4).sum(1, keepdim=True) / S.node_area.sum()
    q_exch = 0.85 * SIGMA * S.node_area * (t_cav4 - t4)
    lid = torch.where(S.load_timer < 4.0, torch.ones_like(S.load_timer),
                      torch.full_like(S.load_timer, env.lid_leak))
    q_ap = 0.75 * SIGMA * (t_cav4.squeeze(1) - T_AMB**4) \
        * (np.pi * R_MOUTH**2) * lid
    q = q_solar + q_exch - (T - T_AMB) / S.r_soil
    q[:, env.n_belt + 2] -= q_ap
    belt_T = T[:, :env.n_belt]
    q_b = S.has_bread.float() * (25.0*0.05) * (belt_T - 400.0)
    q[:, :env.n_belt] -= q_b
    dT = q * dt / S.node_heat_cap
    S.T = T + dT
    S.bread_E = S.bread_E + q_b * dt
    S.bread_t = S.bread_t + S.has_bread.float() * dt
    spall = dT[:, env.n_belt] > 25.0
    S.ep_spall = S.ep_spall + spall.float()

    rew = torch.zeros(B, device=dev)
    belt_T = S.T[:, :env.n_belt]
    cooked = S.has_bread & (S.bread_E >= 45e3)
    scorched = S.has_bread & (belt_T > 730.0)
    doughy = S.has_bread & (S.bread_t > 300.0) & ~cooked
    rew = rew + 5.0*cooked.float().sum(1) - 5.0*scorched.float().sum(1) \
        - 0.5*doughy.float().sum(1) - 0.5*spall.float()
    S.ep_rotis = S.ep_rotis + cooked.float().sum(1)
    S.ep_scorch = S.ep_scorch + scorched.float().sum(1)
    done_b = cooked | scorched | doughy
    S.has_bread = S.has_bread & ~done_b
    S.bread_E = torch.where(done_b, torch.zeros_like(S.bread_E), S.bread_E)
    S.bread_t = torch.where(done_b, torch.zeros_like(S.bread_t), S.bread_t)
    S.load_timer = S.load_timer + dt
    ok_ = (~S.has_bread) & (belt_T >= 560.0) & (belt_T <= 700.0)
    can = (S.load_timer >= 45.0) & ok_.any(1)
    j = torch.where(ok_, belt_T,
                    torch.full_like(belt_T, -1e30)).argmax(1)
    put = can[:, None] & (torch.nn.functional.one_hot(
        j, env.n_belt).bool())
    S.has_bread = S.has_bread | put
    S.load_timer = torch.where(can, torch.zeros_like(S.load_timer),
                               S.load_timer)
    rew = rew + 0.3 * can.float()
    belt_mean = belt_T.mean(1)
    below = (belt_mean < 560.0).float()
    rew = rew + 0.05 * (belt_mean - S.belt_prev).clamp(-5, 5) * below
    S.belt_prev = belt_mean.clone()
    rew = rew - 0.10 * (belt_mean - 950.0).clamp(min=0) / 10.0
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

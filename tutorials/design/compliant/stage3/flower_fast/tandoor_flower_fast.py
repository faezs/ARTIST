"""The flower's OWN controller: a standalone policy at 1 kHz, on its own actuators, seeing a flux camera.

The Hashemi policy commands an AIM at 15 s and a servo follows it. This is the other machine: the flower's inner loop,
running at 1 ms, driving the actuators the flower actually has, and looking at the only thing a real one could look at -
a camera watching the flux land at the fold. It exists because the gust band is 0.1-2 Hz and the boom's first mode is
2-7 Hz, and neither is anything a 15 s step can answer.

WHAT IT DRIVES (11 heads, MultiDiscrete width 7, neutral 3, the same encoding Hashemi uses):
    $0 rail carriage   $1 slew   $2 luff   $3 extend   $4 wrist pitch   $5 wrist yaw     - the pedicel, rate commands
    fine tilt x, fine tilt y, fine piston                                                - the crown, the fast stage
    plenum level (Hashemi's 7 FvK setpoints, absolute), plenum valve (sealed / open)     - the primary mirror itself

WHAT IT SEES: a flux camera at the fold. Not a distilled miss-and-blur pair - the frame. The spot lands somewhere on
the duct's mouth with some size and some brightness, the camera reads it at 8 bits with shot and read noise over a 1 ms
exposure that smears whatever moved, and the duct's own rim is in the frame as the only fixed reference. A short
proprioceptive tail follows the image (joint encoders, the valve, the plenum's error) because no camera can see where
the mount's own joints are, and the joints have limits.

THE PHYSICS, all at 1 ms:
  * wind: von Karman resolved as a shaping filter, not a per-step Gaussian - at 1 kHz the gust has structure
  * structure: the head on the stem-and-boom cantilever as a damped 2-dof oscillator, stiffness from the boom's
    CURRENT extension (tandoor_flower_env.compliance), zeta 0.02, so it rings where a real one rings
  * crown: the fine stage as a first-order actuator with its stroke, its rate and its bandwidth
  * primary: HASHEMI'S OWN MEMBRANE ACTUATION. The 7 pressure setpoints are his exact FvK solves (solve_membrane,
    level_frac 0.70-1.10 of cfg.dp), the pump servo chases the setpoint at his slew rate, and his plenum disturbance -
    a DNI-correlated bias on a 900 s time constant - is resampled to 1 ms. Sealed, the trapped air passes about 3 % of
    the wind's pressure to the figure; open to the blower it passes all of it.
  * optics: the miss at F from the head's true pose, the spot's size from the sun's cone, the static errors, the
    pressure's defocus and the film's wind gradient, and the duct's acceptance.

THE REWARD IS HASHEMI'S, resampled. His terms are per 15 s step; every one that this loop can move is kept with its own
weight and multiplied by dt/15, so a second of this env pays exactly what a second of his does. Nothing is reweighted.

    puffer train puffer_flower_fast          (flowerfast.ini)
"""
import numpy as np, torch, gymnasium, pufferlib
from tandoor_flower_env import (TandoorFlowerEnv, compliance, pedicel_fk, hexapod_jacobian, head_frame,
                                EI_BOOM, EI_STEM, D_DISH,
                                D_REC, R_PLAT, A_M, RHO_AIR, CD_BOWL, CD_BACK, C_M, IU, M_HEAD, M_CROWN,
                                J_LIM, J_LIM_RING, J_RATE, J_SLEW, RING_R, RING_Z, RAIL_RATE,
                                FINE_STROKE, ZETA, SIG_MEM_K, PLENUM_SEALED, P_SURV, SIG_BALL_PER_N, J_HEX_FT, film_soften)

DT = 1.0e-3                      # 1 kHz
DT_HASH = 15.0                   # the step Hashemi's reward weights were written for
L_KARMAN = 50.0                  # the gust's integral length [m]
FINE_BW_ACT, FINE_RATE = 50.0, 0.8        # the fine stage's actuator: 50 Hz first-order, 0.8 m/s of leg speed
FINE_CMD_RATE = 5.0                       # full command sweeps the whole stroke in 1/5 s - the heads command a RATE
CAM_FOV = 0.30                   # the flux camera's half-width AT THE RECEIVER [m]: the traced spot has a 3 cm rms
                                 # spread and the duct is r 0.2, so 0.3 frames both the spot and the rim it must sit in
SUN_MRAD = 4.65e-3               # the sun's angular radius


J_HEAD = 200.0                   # the head and crown about a diameter: m r^2 / 4 plus the rings
CM_RMS = 0.15                    # the FLUCTUATING pitching coefficient of a disc at incidence, taken equal to its mean.
# This is the term that matters and it was missing. Only the drag fluctuated, and drag reaches the image through the
# boom's BENDING - a stiff path. A fluctuating moment reaches it through the boom's END ROTATION, and the image answers
# tilt 5:1 over translation. At 12 m/s that is about 2 mm against the drag path's 0.03 mm - a factor of 67, and the
# difference between a control problem and an inert one.

# THREE POLES, not one. A single first-order filter of time constant L/U has the right variance and the wrong shape:
# audited against von Karman it carries 3.8x too little energy above 1 Hz and 7x too little at the boom's own 6.6 Hz
# mode, so the structure never gets excited where it rings. These three, fitted to von Karman's integrated spectrum by
# non-negative least squares over 0.01-50 Hz, track it within a fifth of a decade everywhere that matters
# (0.5 Hz: 13.1 % against 14.8 %; 6.6 Hz: 2.40 % against 2.65 %).
# VORTEX SHEDDING. The boom is a 0.219 m tube and it sheds at St U / d; its own bending mode is 6.56 Hz; those cross
# at U = 7.2 m/s, in the middle of the operating range, with a lock-in band of roughly 6-9 m/s. A forced sinusoid would
# miss the point entirely - what matters is LOCK-IN, the shedding capturing the structure's frequency and then feeding
# on its motion until motion-induced damping limits it. Only a wake oscillator coupled BOTH ways reproduces that, so
# this is Facchinetti's (2004): a Van der Pol wake variable q driven by the structure's acceleration, driving the lift.
ST_CYL, D_TUBE = 0.20, 0.219     # circular cylinder in the subcritical regime, and the boom's diameter
ST_DISC, CL_DISC = 0.135, 0.10   # a normal disc sheds far lower - 0.39 Hz at 12 m/s - well clear of both modes
EPS_VS, A_VS, CL0 = 0.3, 12.0, 0.3
KARMAN_TAU = (1.0, 1/6.0, 1/216.0)          # multiples of the eddy turnover L/U
KARMAN_W = (0.726, 0.246, 0.028)            # weights on the VARIANCE, summing to one
# AERODYNAMIC ADMITTANCE. The gust the head's loads see is not the point gust: eddies smaller than the dish average out over
# it. Vickery's admittance chi^2 = 1/(1 + (2 f sqrt(A)/U)^(4/3)) is carried as a first-order lag on the gust with its
# half-power corner at f = U/(2 sqrt(A)) - 1.6 Hz at 12 m/s - which cuts the force spectrum at the boom's 2-7 Hz mode by
# 4-5x against the point gust the envs used before. The film's own figure keeps the POINT gust: the small eddies that
# cancel in the net force are exactly what loads its n >= 1 harmonics.
ADMIT_SQRT_A = float(np.sqrt(np.pi*2.1*2.1))
def karman_step(u, dt, U, iu, gen, dev):
    """one 1 ms step of the three-pole gust. u is (B, 3): one state per pole, the gust is their sum."""
    t0 = torch.clamp(L_KARMAN/torch.clamp(U, min=0.5), min=1e-3)[:, None]
    tau = t0*torch.as_tensor(KARMAN_TAU, device=dev)[None, :]
    a = torch.exp(-dt/tau)
    w = torch.as_tensor(KARMAN_W, device=dev)[None, :]
    sig = (iu*U)[:, None]*torch.sqrt(w)*torch.sqrt(torch.clamp(1 - a*a, min=1e-9))
    return a*u + sig*torch.randn(u.shape, generator=gen, device=dev)


def karman_sum(u):
    """the three poles, summed into one gust"""
    return u.sum(1)


class TandoorFlowerFastEnv(TandoorFlowerEnv):
    """1 kHz, own actuators, flux-camera observation, Hashemi's reward and Hashemi's membrane."""
    N_ACT = 11
    def __init__(self, *a, cam_n=24, episode_s=8.0, wind_scale=1.0, wind_mean=None, cam_bits=8,
                 cam_noise=1.0, obs_proprio=1, obs_strain=0, on_device=0, **k):
        k.setdefault("num_agents", 1024)
        self._vec_buf = k.get("buf", None)          # the vector backend's shared buffer, if it gave us one
        super().__init__(*a, wind_scale=wind_scale, **k)
        dev = self.device; B = self.num_agents
        self.dt = DT                                       # every rate limit in the parent reads self.dt
        self.cam_n = int(cam_n); self.cam_bits = int(cam_bits); self.cam_noise = float(cam_noise)
        self.obs_proprio = int(obs_proprio); self.obs_strain = int(obs_strain); self.episode_n = int(episode_s/DT)
        # THE STEM AS A LOAD CELL. A compliant member is a force sensor: two strain gauges at the stem's foot read the
        # wind's bending moment the instant the gust arrives, a quarter-period before the boom's mode has moved the
        # image and whether or not the spot is still in the frame. The reading is the WIND part only - the gravity
        # moment is pose-known and nulled from the joints - scaled by the moment at the 15 m/s tracking limit with
        # the boom at full reach, bowl to the wind.
        self._m_ref = 0.5*RHO_AIR*15.0**2*np.pi*A_M**2*CD_BOWL*(float(self.boom[1]) + 1.0)
        self.wind_mean = wind_mean; self.on_device = int(on_device)
        self._obs_t = self._rew_t = self._done_t = None
        self._dni_t = torch.full((self.num_agents,), 700.0, device=self.device)
        self._bias_t = torch.zeros((), device=self.device)
        self._fl_init()
        # ---- the primary's actuation, Hashemi's: his 7 exact FvK setpoints and what each does to the focal length
        self.f_level = np.array([float(m["f_fit"]) for m in getattr(self, "_mems_cache", [])] or
                                [float(self._mem0["f_fit"])]*len(self.level_frac))
        self.f_nom = float(self._mem0["f_fit"])
        self.p_lv = self.p0*np.asarray(self.level_frac, float)
        self.P_LV = torch.as_tensor(self.p_lv, dtype=torch.float32, device=dev)
        self.F_LV = torch.as_tensor(self.f_level, dtype=torch.float32, device=dev)
        self.pump_slew = 6.0/DT_HASH                        # his +-6 Pa per 15 s step, as Pa/s
        # ---- the fast state
        z = lambda n=None: (torch.zeros(B, device=dev) if n is None else torch.zeros(B, n, device=dev))
        self.S = dict(u=z(3), v=z(3), cm=z(3),               # the gust along the wind, across it, and in pitching moment
                      th=z(2), thd=z(2),                     # the head's TILT and its rate: the moment's own mode
                      q_vs=z(), qd_vs=z(), acc_l=z(), ph_d=z(),   # the boom's wake oscillator, and the dish's shedding phase

                      x=z(2), xd=z(2),                       # the head's lateral deflection and its rate
                      ua=z(), va=z(),                        # the gust as the head's loads see it: admittance-filtered
                      fine=z(3), fine_c=z(3),                # the fine stage: where it is, where it is going
                      p_act=torch.full((B,), float(self.p0), device=dev), p_dist=z(), valve=torch.ones(B, device=dev),
                      E=z(int(self.loaves_per_load)),        # the dough, so the reward's dough term is Markov
                      t=z(), miss=z(2), pk=z())
        self._parent_obs_n = int(np.prod(self.single_observation_space.shape))   # Hashemi's own observation width
        self._cam_grid()
        self._respace()

    # ---------------------------------------------------------------- spaces
    def _respace(self):
        """the flux frame, then a short proprioceptive tail. PufferEnv sizes its buffers from these, so rebuild them."""
        n_img = self.cam_n*self.cam_n
        self.n_prop = ((6 + 3 + 3) + (2 if self.obs_strain else 0)) if self.obs_proprio else 0
        # joints, fine stage, plenum+valve+dough, and with obs_strain the stem's two bending moments
        self.single_observation_space = gymnasium.spaces.Box(low=0.0, high=1.0, shape=(n_img + self.n_prop,), dtype=np.float32)
        self.single_action_space = gymnasium.spaces.MultiDiscrete([7]*self.N_ACT)
        for attr in ("observation_space", "action_space"):                   # the parent already made the joint spaces,
            if hasattr(self, attr): delattr(self, attr)                      # and PufferEnv refuses to see them on entry
        # and it must be re-run against the SHARED buffer the vector backend handed us, not a fresh one: a native
        # PufferEnv writes into that buffer, and allocating our own instead leaves the trainer reading zeros forever.
        buf = self._vec_buf                                                  # Serial hands this as a DICT of slices
        if buf is not None:
            ob = buf["observations"] if isinstance(buf, dict) else getattr(buf, "observations", None)
            ok = ob is not None and int(np.prod(np.asarray(ob).shape[1:])) == int(np.prod(self.single_observation_space.shape))
            if not ok: buf = None
        pufferlib.PufferEnv.__init__(self, buf=buf)

    def _cam_grid(self):
        dev = self.device; n = self.cam_n
        g = (torch.arange(n, device=dev, dtype=torch.float32) + 0.5)/n*2.0 - 1.0
        self.cam_x, self.cam_y = torch.meshgrid(g*CAM_FOV, g*CAM_FOV, indexing="xy")
        self.cam_r = torch.sqrt(self.cam_x**2 + self.cam_y**2)
        self.cam_rim = ((self.cam_r > self.r_duct*0.98) & (self.cam_r < self.r_duct*1.10)).float()
        self.cam_rim = self.cam_rim.reshape(-1)

    # ---------------------------------------------------------------- the frame
    def _unused_flux_frame(self, miss, sig, peak):
        """what the camera at the fold sees: a Gaussian spot of width sig, centred on the miss, over the duct's rim.
        8-bit, shot noise on the signal, read noise on everything, and the rim lit faintly so the frame always carries
        its own reference - a controller that only ever sees a blob cannot tell a centred spot from a lost one."""
        B, n = miss.shape[0], self.cam_n
        dx = self.cam_x[None] - miss[:, 0, None, None]; dy = self.cam_y[None] - miss[:, 1, None, None]
        s2 = torch.clamp(sig, min=5e-3)[:, None, None]**2
        img = peak[:, None, None]*torch.exp(-0.5*(dx*dx + dy*dy)/s2)
        img = img + 0.06*self.cam_rim[None]*peak.mean().clamp(min=1e-3)
        if self.cam_noise > 0:
            gen = getattr(self, "_gen", None)
            sh = torch.sqrt(torch.clamp(img, min=0.0)/CAM_FULL)*self.cam_noise
            img = img + sh*torch.randn(img.shape, generator=gen, device=img.device) \
                      + (2.0/CAM_FULL)*self.cam_noise*torch.randn(img.shape, generator=gen, device=img.device)
        q = float(2**self.cam_bits - 1)
        return torch.clamp((img*q).round()/q, 0.0, 1.0)

    # ---------------------------------------------------------------- one millisecond
    def step_torch(self, actions):
        dev = self.device; B = self.num_agents; S = self.S; F = self._fl
        gen = getattr(self, "_gen", None)
        a = torch.as_tensor(actions, device=dev).reshape(B, self.N_ACT).float()
        cmd = (a.clamp(0, 6) - 3.0)/3.0                                        # every head: -1 .. +1

        # ---- 1. the pedicel: six rate commands, its own travel and its two drive speeds
        keys = ("slew", "luff", "ext", "pitch", "yaw")
        lim = self.j_lim
        if self.base == "ring":
            dphi = cmd[:, 0]*RAIL_RATE/max(self.ring_r, 1e-6)*self.dt
            F["q_rail"] = F["q_rail"] + dphi
        for i, kk in enumerate(keys):
            r = cmd[:, 1 + i]*J_RATE[kk]
            F["q_" + kk] = torch.clamp(F["q_" + kk] + r*self.dt, lim[kk][0], lim[kk][1])
        Ff = torch.as_tensor(self._fl_F(), dtype=torch.float32, device=dev)
        if self.base == "ring":
            T0 = torch.stack([Ff[0] + self.ring_r*torch.cos(F["q_rail"]), Ff[1] + self.ring_r*torch.sin(F["q_rail"]),
                              torch.full_like(F["q_rail"], float(self.z_deck) + self.stem_z)], 1)
        else:
            T0 = self._fl_stem()[None, :].expand(B, 3)
        q = {kk: F["q_" + kk] for kk in keys}
        C0, n0 = pedicel_fk(T0, q)

        # ---- 2. the fine stage: three commands, first-order actuator, its stroke and its speed
        lim3 = torch.as_tensor([FINE_STROKE/R_PLAT, FINE_STROKE/R_PLAT, FINE_STROKE], device=dev)
        S["fine_c"] = torch.clamp(S["fine_c"] + cmd[:, 6:9]*FINE_CMD_RATE*lim3*self.dt, -lim3, lim3)
        S["fine"] = S["fine"] + (S["fine_c"] - S["fine"])*min(1.0, 2*np.pi*FINE_BW_ACT*self.dt)

        # ---- 3. the wind, resolved
        U = torch.clamp((torch.as_tensor(float(self.wind_mean), device=dev).expand(B) if self.wind_mean is not None
                         else torch.as_tensor(self._gpu.wind if getattr(self, "_gpu", None) is not None else 6.0,
                                              device=dev).reshape(-1).expand(B))*self.wind_scale, min=0.0)
        S["u"] = karman_step(S["u"], self.dt, U, IU, gen, dev)
        S["v"] = karman_step(S["v"], self.dt, U, 0.6*IU, gen, dev)
        S["cm"] = karman_step(S["cm"], self.dt, torch.ones_like(U), CM_RMS, gen, dev)
        u_g = karman_sum(S["u"]); v_g = karman_sum(S["v"]); cm_g = karman_sum(S["cm"])
        V = torch.clamp(U + u_g, min=0.0)                                              # the point gust: the film, the boom's shedding
        k_adm = torch.clamp(2*np.pi*(U/(2*ADMIT_SQRT_A))*self.dt, max=1.0)              # Vickery's corner, as a first-order lag
        S["ua"] = S["ua"] + (u_g - S["ua"])*k_adm; S["va"] = S["va"] + (v_g - S["va"])*k_adm
        Vh = torch.clamp(U + S["ua"], min=0.0)                                          # the gust the head's loads see
        ca = (n0[:, 0]*self._fl_what_x)
        into = ca < 0
        cd = 0.25 + (torch.where(into, torch.full_like(ca, CD_BOWL), torch.full_like(ca, CD_BACK)) - 0.25)*ca*ca
        A_D = np.pi*A_M**2
        drag = 0.5*RHO_AIR*Vh*Vh*A_D*cd
        side = 0.5*RHO_AIR*Vh*S["va"]*A_D*0.9

        # ---- 4. the structure: a damped oscillator at THIS extension, so it rings where a real boom rings
        Cb0 = C0 - D_REC*n0; bu = Cb0 - T0
        bu = bu/torch.linalg.norm(bu, dim=1).clamp(min=1e-9)[:, None]
        zc = torch.zeros_like(bu); zc[:, 2] = 1.0
        t1 = torch.cross(bu, zc, dim=1); t1 = t1/torch.linalg.norm(t1, dim=1).clamp(min=1e-6)[:, None]
        t2 = torch.cross(bu, t1, dim=1)                                            # the boom's own bending plane
        w_hat = torch.stack([torch.full_like(ca, self._fl_what_x), torch.zeros_like(ca), torch.zeros_like(ca)], 1)
        v_hat = torch.stack([torch.zeros_like(ca), torch.ones_like(ca), torch.zeros_like(ca)], 1)
        # ---- vortex shedding, before the forces are assembled: the wake's lift is one of them
        cos_ax = (w_hat*bu).sum(1)
        un = V*torch.sqrt(torch.clamp(1 - cos_ax*cos_ax, min=0.0))              # only the CROSS-flow component sheds
        ws = 2*np.pi*ST_CYL*un/D_TUBE; F["f_vs"] = ws/(2*np.pi)
        lf = torch.cross(bu, w_hat, dim=1)
        lf = lf/torch.linalg.norm(lf, dim=1).clamp(min=1e-6)[:, None]           # across both the tube and the flow
        qdd = (-EPS_VS*ws*(S["q_vs"]*S["q_vs"] - 1.0)*S["qd_vs"] - ws*ws*S["q_vs"]
               + (A_VS/D_TUBE)*S["acc_l"])                                      # the structure feeds the wake back
        S["qd_vs"] = S["qd_vs"] + qdd*self.dt; S["q_vs"] = S["q_vs"] + S["qd_vs"]*self.dt
        F_vs = 0.5*RHO_AIR*un*un*D_TUBE*F["q_ext"]*(CL0/2)*S["q_vs"]*0.375      # distributed; 3/8 of it as a tip load
        # and the dish's own shedding: far below both modes, so no lock-in, but a real narrowband force in the band
        # the coarse loop has to hold
        S["ph_d"] = torch.remainder(S["ph_d"] + 2*np.pi*ST_DISC*V/D_DISH*self.dt, 2*np.pi)
        F_disc = 0.5*RHO_AIR*V*V*A_D*CL_DISC*torch.sin(S["ph_d"])
        F["f_vs_d"] = ST_DISC*V/D_DISH
        Fw = drag[:, None]*w_hat + (side + F_disc)[:, None]*v_hat + F_vs[:, None]*lf
        cmp_ = compliance(F["q_ext"], self.boom_kind, self.boom_ratio, self.boom_root,
                          m_tip=D_REC*(n0*bu).sum(1))                            # the drag acts at the dish, past the tip
        k = cmp_["k_lat"]; m = M_HEAD + M_CROWN
        w0 = torch.sqrt(k/m)
        f_t = torch.stack([(Fw*t1).sum(1), (Fw*t2).sum(1)], 1)                     # only the transverse part bends it
        F["m_root"] = f_t*(F["q_ext"] + 1.0)[:, None]                              # the stem foot's wind moment, N m: the gauges
        acc = f_t/m - 2*ZETA*w0[:, None]*S["xd"] - (w0*w0)[:, None]*S["x"]
        S["xd"] = S["xd"] + acc*self.dt; S["x"] = S["x"] + S["xd"]*self.dt
        S["acc_l"] = acc[:, 0]*(lf*t1).sum(1) + acc[:, 1]*(lf*t2).sum(1)        # what the wake sees of the motion
        # THE PITCHING MOMENT, on its own mode. An end moment on the stem-and-boom chain turns the tip by
        # theta = M (Lb/EI_b + Ls/EI_s), so the rotational stiffness is that reciprocal and the inertia is the head's
        # own. On this machine that mode sits near 14 Hz - above the fine stage's 8 Hz loop, which is exactly what
        # makes it the interesting part of the job rather than a slow bias.
        k_th = 1.0/torch.clamp(F["q_ext"]/EI_BOOM + 1.0/EI_STEM, min=1e-12)
        w_th = torch.sqrt(k_th/J_HEAD); F["f_th"] = w_th/(2*np.pi)
        M_w = 0.5*RHO_AIR*Vh*Vh*A_D*D_DISH*cm_g                                    # the fluctuating moment, about the
        m_t = torch.stack([M_w*(w_hat*t2).sum(1), -M_w*(w_hat*t1).sum(1)], 1)      # axis across the wind
        a_th = m_t/J_HEAD - 2*ZETA*w_th[:, None]*S["thd"] - (w_th*w_th)[:, None]*S["th"]
        S["thd"] = S["thd"] + a_th*self.dt; S["th"] = S["th"] + S["thd"]*self.dt
        F["f_n"] = w0/(2*np.pi); F["k_img"] = cmp_["k_img"]; F["drag"] = drag; F["V"] = U; F["gust"] = u_g

        # ---- 5. where the head really is: the joints, plus the structure's deflection, minus what the fine stage took out
        xl, yl = head_frame(n0)
        dx = S["x"][:, 0:1]*t1 + S["x"][:, 1:2]*t2
        C = C0 + dx + S["fine"][:, 2:3]*n0
        # A cantilever's tip does not only move - it TURNS, by theta/delta radians per metre of deflection, about the axis
        # perpendicular to the load. That rotation is what the image feels: 5.01 m of walk per radian against 0.95 m per
        # metre, so getting it as a rotation rather than a vector nudge is the difference between the dominant term being
        # right and being decorative. Rotate n by phi about (bu x load), small-angle: n + phi x n.
        kt = (cmp_["theta"]/torch.clamp(cmp_["delta"], min=1e-12))[:, None]
        phi = kt*(S["x"][:, 0:1]*t2 - S["x"][:, 1:2]*t1)                           # bending about the boom's own axes
        phi = phi + S["th"][:, 0:1]*t1 + S["th"][:, 1:2]*t2                        # and the pitching moment's own tilt
        phi = phi + S["fine"][:, 0:1]*yl - S["fine"][:, 1:2]*xl                  # and the crown's own two tilts
        n = n0 + torch.cross(phi, n0, dim=1)
        n = n/torch.linalg.norm(n, dim=1).clamp(min=1e-9)[:, None]

        # ---- 6. the primary: Hashemi's membrane, actuated
        lvl = torch.clamp(a[:, 9].long(), 0, len(self.p_lv) - 1)
        p_set = self.P_LV[lvl]
        S["valve"] = (a[:, 10] <= 3.0).float()                                    # sealed unless the policy opens it
        bias = self._bias_t                                                        # cached: dni moves on the slow env's clock, not this one
        S["p_dist"] = torch.clamp(S["p_dist"] + (bias - S["p_dist"])/900.0*self.dt
                                  + 1.2*np.sqrt(self.dt/DT_HASH)*torch.randn(B, generator=gen, device=dev), -40, 60)
        S["p_act"] = S["p_act"] + torch.clamp(p_set + S["p_dist"] - S["p_act"], -self.pump_slew*self.dt, self.pump_slew*self.dt)
        f_now = self._lerp_lv(S["p_act"])                                          # on device: a .cpu() here cost 50x the physics
        defocus = A_M*torch.abs(f_now - self.f_nom)/max(self.f_nom, 1e-6)          # the spot's growth from the wrong focal length
        wind_pass = torch.where(S["valve"] > 0.5, torch.full_like(V, PLENUM_SEALED), torch.ones_like(V))
        sig_film = SIG_MEM_K*V*V*film_soften(V)*wind_pass                          # the film's own figure under wind, rad rms, softened by the flow

        # ---- 7. the optics: THE RAY TRACE. The megakernel is handed the dish frame the flower's joints actually
        # produced, so the power is what those rays deliver - not a closed form fitted to a half-power radius.
        s_dir = self._sun_dir(B, dev)
        r = -s_dir + 2*(s_dir*n).sum(1, keepdim=True)*n
        d = Ff[None, :] - C
        miss_v = d - (d*r).sum(1, keepdim=True)*r
        e1 = torch.cross(r, torch.stack([torch.zeros_like(ca), torch.zeros_like(ca), torch.ones_like(ca)], 1), dim=1)
        e1 = e1/torch.linalg.norm(e1, dim=1).clamp(min=1e-9)[:, None]; e2 = torch.cross(r, e1, dim=1)
        miss = torch.stack([(miss_v*e1).sum(1), (miss_v*e2).sum(1)], 1)
        S["miss"] = miss
        # the beam's angular budget, composed the way the kernel composes it (tandoor_hashemi_env.py:1259), plus the
        # film's own wind gradient and the plenum's defocus, which is what the membrane's actuation buys or loses
        sigb = torch.sqrt(self.sig_static**2 + (2*0.35*sig_film)**2 + (defocus/max(float(self.g_orbit), 1e-6))**2)
        lv_f = torch.clamp((S["p_act"]/self.p0 - self.level_frac[0])
                           /(self.level_frac[-1] - self.level_frac[0])*(len(self.p_lv) - 1), 0, len(self.p_lv) - 1)
        thr, out6, per = self.trace(C, n, lv_f, sigb)
        # PER LOAF, not in total. The megakernel already bins each ray onto the loaf it lands on (the eight columns
        # after the nodes), and that spatial term is the whole point: total throughput barely moves when the beam
        # wanders, because the duct is r 0.2 and the spot is 3 cm rms - the traced acceptance is still 99 % at 8 mm
        # and 98.7 % at 32 mm. What DOES move is which loaf the energy lands on, and Hashemi's dough term is written
        # on exactly that. Scoring the sum instead of the bins was throwing away the only thing worth controlling.
        NBL = per.shape[1] - self.n_nodes
        scale = (self._dni_t*self._tr["scale"])[:, None]
        loaf = torch.clamp(scale*per[:, self.n_nodes:self.n_nodes + NBL], min=0.0)
        P_del = loaf.sum(1)

        # ---- 8. Hashemi's reward, resampled to 1 ms. Same terms, same weights, x dt/15.
        roti_E = float(self.roti_energy) if hasattr(self, "roti_energy") else float(self.roti_kj)*1e3
        nl = min(S["E"].shape[1], loaf.shape[1])
        share = torch.zeros_like(S["E"]); share[:, :nl] = loaf[:, :nl]
        phi_old = torch.clamp(S["E"]/roti_E, 0, 1).sum(1)
        S["E"] = S["E"] + share*self.dt
        phi_new = torch.clamp(S["E"]/roti_E, 0, 1).sum(1)
        scale = self.dt/DT_HASH
        rew = 2.0*(phi_new - phi_old) - 0.02*scale                                # cooking pays, holding is rent
        rew = rew/float(getattr(self, "reward_div", 1.0))

        # ---- 9. the frame, the tail, and the episode
        img = self.flux_image(thr, out6)
        if self.n_prop:
            prop = torch.stack([ (F["q_" + kk] - lim[kk][0])/(lim[kk][1] - lim[kk][0]) for kk in keys ]
                               + [torch.remainder(F["q_rail"]/(2*np.pi) + 0.5, 1.0)]
                               + [S["fine"][:, 0]/(FINE_STROKE/R_PLAT)*0.5 + 0.5, S["fine"][:, 1]/(FINE_STROKE/R_PLAT)*0.5 + 0.5,
                                  S["fine"][:, 2]/FINE_STROKE*0.5 + 0.5]
                               + [(S["p_act"] - self.P_LV[0])/(self.P_LV[-1] - self.P_LV[0]), S["valve"],
                                  torch.clamp(phi_new/max(int(self.loaves_per_load), 1), 0, 1)]
                               + ([0.5 + 0.5*torch.clamp(F["m_root"][:, 0]/self._m_ref, -1, 1),
                                   0.5 + 0.5*torch.clamp(F["m_root"][:, 1]/self._m_ref, -1, 1)] if self.obs_strain else []), 1)
            obs = torch.cat([img, torch.clamp(prop, 0, 1)], 1)
        else:
            obs = img
        S["t"] = S["t"] + 1
        done = (S["t"] >= self.episode_n)                                          # no .any(): branching here syncs the device
        S["t"] = torch.where(done, torch.zeros_like(S["t"]), S["t"])
        S["E"] = torch.where(done[:, None], torch.zeros_like(S["E"]), S["E"])
        done = done.float()
        self._obs_t, self._rew_t, self._done_t = obs, rew, done                    # the on-device collector reads these
        if not self.on_device:
            self.observations[:] = obs.detach().cpu().numpy()
            self.rewards[:] = rew.detach().cpu().numpy()
            self.terminals[:] = done.detach().cpu().numpy() > 0.5
            self.truncations[:] = False
            return self.observations, self.rewards, self.terminals, self.truncations, []
        return obs, rew, done, torch.zeros_like(done), []
        return self.observations, self.rewards, self.terminals, self.truncations, []

    def _lerp_lv(self, p):
        """the focal length at this plenum pressure, interpolated across Hashemi's seven exact FvK solves, on device"""
        i = torch.clamp(torch.bucketize(p, self.P_LV) - 1, 0, len(self.p_lv) - 2)
        p0 = self.P_LV[i]; p1 = self.P_LV[i + 1]
        w = torch.clamp((p - p0)/torch.clamp(p1 - p0, min=1e-6), 0.0, 1.0)
        return self.F_LV[i]*(1 - w) + self.F_LV[i + 1]*w

    def strut_loads(self):
        """the six axial forces, for the readout - not needed by the loop, so it is not in it"""
        S = self.S; dev = self.device; B = self.num_agents
        w = torch.cat([torch.stack([self._fl["drag"], torch.zeros(B, device=dev),
                                    torch.full((B,), -(M_HEAD*9.81), device=dev)], 1), torch.zeros(B, 3, device=dev)], 1)
        return -torch.einsum("ij,bj->bi", torch.as_tensor(J_HEX_FT, dtype=torch.float32, device=dev), w)

    def _sun_dir(self, B, dev):
        """the sun, frozen over an episode: at 1 kHz it does not move (0.004 deg/s), and pretending otherwise would
        only add a ramp the controller cannot act on"""
        # the sun as the KERNEL has it, not as I would rederive it. Building it from a solar formula of my own left a
        # 2.17 cm static miss with no wind and nothing commanded - a third of a degree of convention, and it swamped
        # everything the loop was supposed to be learning to fight. mount_batch returns u, the sun direction, in the
        # env's own axes; the Metal mount does not, so take the torch one once per episode - it costs one solve.
        if getattr(self, "_sun_cache", None) is None:
            u = None
            try:
                from tandoor_mount_batch import mount_batch
                S_ = getattr(self, "_gpu", None)
                day = getattr(S_, "day_v", None); lat = getattr(S_, "lat_v", None)
                if day is None: day = getattr(self, "day_v", None)
                if lat is None: lat = getattr(self, "lat_v", None)
                day_t = torch.as_tensor(day, dtype=torch.float32, device=dev).reshape(-1)
                lat_t = torch.as_tensor(lat, dtype=torch.float32, device=dev).reshape(-1)
                el_m = S_.el_m if (S_ is not None and hasattr(S_, "el_m")) else self.el_m
                az_m = S_.az_m if (S_ is not None and hasattr(S_, "az_m")) else self.az_m
                pnt = torch.stack([torch.as_tensor(el_m, dtype=torch.float32, device=dev).reshape(-1),
                                   torch.as_tensor(az_m, dtype=torch.float32, device=dev).reshape(-1)], 1)
                mnt = mount_batch(self, day_t, lat_t, float(self.t_solar[0]), dev, pnt=pnt)
                u = mnt["u"].float()
            except Exception:
                u = None
            if u is None:
                u = torch.tensor([[0.0, 0.0, 1.0]], device=dev)
            self._sun_cache = (u/torch.linalg.norm(u, dim=1).clamp(min=1e-9)[:, None])
        c = self._sun_cache
        return c if c.shape[0] == B else c[:1].expand(B, 3)

    def step(self, actions):
        """the numpy path always fills the numpy buffers. on_device is for the on-device collector, which calls
        step_torch; letting it leak into step() would hand a caller the stale buffer - zeros - and say nothing."""
        od, self.on_device = self.on_device, 0
        try:
            return self.step_torch(actions)
        finally:
            self.on_device = od

    def reset(self, seed=None):
        # the parent's reset writes ITS observation into the buffer; ours is the flux frame and a different width, so
        # lend it a scratch array of its own size and keep everything else it sets up (day, dni, the device state)
        buf = self.observations
        self.observations = np.zeros((self.num_agents, self._parent_obs_n), dtype=np.float32)
        try:
            super().reset(seed=seed)
        finally:
            self.observations = buf
        self._fl_init()
        for k_, v in self.S.items():
            if torch.is_tensor(v): v.zero_()
        self.S["p_act"].fill_(float(self.p0)); self.S["valve"].fill_(1.0)
        gen = getattr(self, "_gen", None)                                        # q = 0 is an exact equilibrium of the
        self.S["q_vs"] = 0.01*torch.randn(self.num_agents, generator=gen, device=self.device)   # wake oscillator, so seed it
        self.S["ph_d"] = 2*np.pi*torch.rand(self.num_agents, generator=gen, device=self.device)
        self._sun_cache = None
        self._dni_t = torch.as_tensor(np.asarray(self.dni, dtype=np.float32), device=self.device).reshape(-1)
        if self._dni_t.numel() != self.num_agents: self._dni_t = self._dni_t[:1].expand(self.num_agents).contiguous()
        self._bias_t = 0.05*(self._dni_t.mean() - 400.0)/10.0
        self.acquire()
        self.trace_setup()
        self.observations[:] = 0.0
        return self.observations, [{}]

    def trace_setup(self):
        """everything the megakernel needs that does NOT change at 1 kHz. The mount solve, the canopy frame, the
        per-ray sampling: all of it belongs to the sun and the day, which move on the slow env's clock. Only the dish's
        own frame (Mt) and centre (Cd) change per millisecond, and those come from the flower's joints."""
        from tandoor_mount_batch import mount_batch
        dev = self.device; B = self.num_agents; P = len(self._hx)
        day_t = torch.as_tensor(np.asarray(self.day_v, dtype=np.float32), device=dev).reshape(-1)
        lat_t = torch.as_tensor(np.asarray(self.lat_v, dtype=np.float32), device=dev).reshape(-1)
        pnt = torch.stack([torch.as_tensor(np.asarray(self.el_m, dtype=np.float32), device=dev).reshape(-1),
                           torch.as_tensor(np.asarray(self.az_m, dtype=np.float32), device=dev).reshape(-1)], 1)
        mnt = mount_batch(self, day_t, lat_t, float(self.t_solar[0]), dev, pnt=pnt)
        gen = getattr(self, "_gen", None)
        z = lambda: torch.zeros(B, P, device=dev)
        self._tr = dict(Acan=mnt["Acan"].contiguous(), vp=mnt["vp"].reshape(B, 21).contiguous(),
                        scb=mnt["scb"].contiguous(), u=mnt["u"].float().contiguous(),
                        du=z(), de=z(), upick=torch.full((B, P), 0.5, device=dev), us=torch.full((B, P), 0.5, device=dev),
                        dvec=torch.zeros(B, 1, 2, device=dev), off=torch.zeros(B, 2, device=dev),
                        soil=torch.ones(B, device=dev), aim=self._aim_dirs(B, dev),
                        scale=(mnt["scb"][:, 4]*mnt["scb"][:, 5]).contiguous())
        self._sun_cache = self._tr["u"]/torch.linalg.norm(self._tr["u"], dim=1).clamp(min=1e-9)[:, None]

    def trace(self, C, n, lv, sigb):
        """ONE megakernel launch from the flower's own head pose. Returns the delivered power per agent and every ray's
        landing point at the receiver - which is the flux camera, measured rather than modelled. 3.9 ms at 8192 agents
        by 64 rays, i.e. 2.1 M agent-steps/s: the real trace is CHEAPER here than the closed form it replaces, because
        it is one launch and the batch pays for it."""
        from tandoor_mount_batch import _align_batch
        T = self._tr; dev = self.device; B = self.num_agents
        zc = torch.zeros_like(n); zc[:, 2] = 1.0
        Mt = _align_batch(zc[0], n).transpose(1, 2).contiguous()
        thr, out6, per = self._metal(self._pts_l, self._nrm_l, lv, T["du"], T["de"], T["upick"], T["us"], sigb,
                                     T["Acan"], Mt, C.contiguous(), T["dvec"], T["off"], T["vp"], self._sc_base,
                                     self.ell_M, self.ell_S, self.ell_ctr_t, self._V0t,
                                     self._ray_pw, T["soil"], self.n_nodes, T["aim"], T["scb"], fct=self._fct)
        return thr, out6, per

    def flux_image(self, thr, out6):
        """the camera: bin every ray that got through by where it landed on the receiver. No Gaussian, no assumed spot
        shape - the histogram IS the flux map, with whatever coma, astigmatism and clipping the trace gave it."""
        B, n = self.num_agents, self.cam_n
        yz = out6[..., :2]; w = torch.clamp(thr, min=0.0)
        ix = torch.clamp(((yz[..., 0] + CAM_FOV)/(2*CAM_FOV)*n).long(), 0, n - 1)
        iy = torch.clamp(((yz[..., 1] + CAM_FOV)/(2*CAM_FOV)*n).long(), 0, n - 1)
        img = torch.zeros(B, n*n, device=thr.device)
        img.scatter_add_(1, iy*n + ix, w)
        img = img/torch.clamp(img.amax(dim=1, keepdim=True), min=1e-6)*0.9
        img = img + 0.18*self.cam_rim.reshape(1, -1)      # the duct's rim, lit enough to read: it is the frame's only
                                                          # fixed reference, and a spot with nothing to be off-centre
                                                          # FROM tells a convolution nothing about where to push
        if self.cam_noise > 0:
            gen = getattr(self, "_gen", None)
            img = img + (0.01*self.cam_noise)*torch.randn(img.shape, generator=gen, device=img.device)
        q = float(2**self.cam_bits - 1)
        return torch.clamp((img*q).round()/q, 0.0, 1.0)

    def acquire(self):
        """put the mount on the sun before the episode starts. The policy's job is to HOLD a pose against the wind at
        1 kHz, not to find one from a cold start with every joint at zero - from there the spot is nine metres off the
        camera and the frame is black, which teaches nothing. This is the slow env's own follower, run once."""
        from tandoor_flower_env import pedicel_ik
        C, n = self._fl_head_pose()
        if C is None: return
        Cb = C - D_REC*n
        T0, phi, _ = self._fl_base(Cb, torch.zeros(self.num_agents, device=self.device), 1e6)
        self._fl["q_rail"] = phi
        q = pedicel_ik(T0, C, n)
        for kk in ("slew", "luff", "ext", "pitch", "yaw"):
            self._fl["q_" + kk] = q[kk].clamp(self.j_lim[kk][0], self.j_lim[kk][1])
        self._fl["q_init"] = torch.ones(self.num_agents, device=self.device)

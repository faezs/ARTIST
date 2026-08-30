"""Electroforming RL env: grow a rigid mirror shell on the silvered
membrane mandrel (the M5 replication process from the tandoor build).

The agent runs a two-phase copper electroform over a simulated ~48 h:

  PAD phase   - "water-only" plating through a Cu-loaded cation-exchange
                resin sheet (water-softener chemistry): the resin is a
                finite solid ion reservoir (~2 eq/L -> ~7 um of copper
                per 1 mm sheet per load), gentle on the fragile Tollens
                silver flash. Builds the strike layer that lets the
                mandrel survive the acid bath.
  BATH phase  - membrane-divided acid copper bath for the structural
                kilograms. Additives (brightener/suppressor) set both
                roughness and internal stress; the divided cell slows
                their anodic destruction.

Physics, deliberately the strongest models that still run as vectorized
per-step ODEs (the same discipline as the tandoor's thermal audit -
reduced-order but calibrated against the real theory):

  * Faraday growth  dh/dt = CE * i * M / (n F rho); at 3 A/dm2 that is
    39.7 um/h - matches handbook acid-copper rates.
  * Transport limit i_lim = n F D C / delta, boundary layer thinned by
    agitation; current efficiency and roughness both degrade as i/i_lim
    rises (dendritic/mossy growth above ~0.4 i_lim).
  * Current distribution: primary (geometric, rim-crowded) blended
    toward uniform by the Wagner number Wa ~ (RT/(alpha n F i))*kappa/L
    - low current density = high throwing power, like the real cell.
  * Internal stress: Chason-form kinetic model - a tensile
    grain-boundary term that grows with brightener coverage (finer
    grain) and current, a compressive adatom-insertion term that
    dominates at very low growth rate, and the signature reversible
    drift toward compressive during growth interruptions. The FIGURE
    of the peeled shell depends on the stress FIRST MOMENT through the
    thickness (a free shell relieves uniform stress; the gradient
    bends it): kappa = 12 M_sigma / (E h^3). Sub-MPa gradient control
    is what mrad figure demands - that is the game.
  * Additives: Langmuir adsorption to surface coverages, incorporation
    consumption proportional to current (CEAC-lite), anodic
    destruction slashed 10x by the divided cell, replenished by dosing
    actions. The bath chemistry drifts; the agent maintains it.
  * Witness strip: internal stress is HIDDEN state; the agent sees a
    noisy Stoney-curl reading of the running stress-thickness, exactly
    like plating a coupon beside the work.

Failure modes (all irreversible, all reachable): switching to the bath
with a thin strike dissolves the silver (delamination), sustained
i > 0.4 i_lim runs dendrites away past r_crit (scrap), additive
depletion sends stress tensile, over-current burns zones.

Reward: potential-based thickness shaping that telescopes to zero
(terminal absorbs the potential - peel-early farming nets nothing),
a small time cost, and a terminal shell-quality payout gated on
thickness, uniformity, figure (stress moment -> mrad), and defects.

Actions (6 heads x 7 levels, equal widths for pufferlib 3.0):
  0 current setpoint  0..I_MAX
  1 reverse-pulse duty 0..30%
  2 dose brightener   (0 = none)
  3 dose suppressor   (0 = none)
  4 agitation         pump speed
  5 mode: 0-2,5 hold | 3 switch pad->bath | 4 reload resin | 6 PEEL

On Julia/Catlab Petri nets, considered and declined for the env: the
species bookkeeping (additive adsorption/incorporation/destruction,
resin site exchange) IS a clean mass-action reaction network and
AlgebraicPetri/Catalyst.jl would compose it beautifully - but the
electrochemical core (Butler-Volmer exponentials, field-driven current
distribution, the moving film boundary, Stoney mechanics) is not
mass-action, and the training loop is PufferLib/torch: per-step FFI
into Julia would cost the SPS the megakernel bought. The right use of
that ecosystem here is as an offline reference oracle for the CRN
subsystem, mirroring this project's numpy-vs-GPU parity discipline.
"""
import gymnasium
import numpy as np
import pufferlib

# ---- constants ------------------------------------------------------- #
F = 96485.0            # C/mol
M_CU = 63.55e-3        # kg/mol
RHO_CU = 8960.0        # kg/m3
N_E = 2.0
E_CU = 110e9           # Pa, electroformed copper
D_CU = 5.3e-10         # m2/s Cu2+ in acid bath
C_CU0 = 800.0          # mol/m3 (~0.8 M)
DELTA0 = 130e-6        # m, stagnant boundary layer
AREA = 1.0             # m2 workpiece (M5-scale patch)
H_TARGET = 400e-6      # m structural shell
I_MAX = 500.0          # A/m2 (5 A/dm2 ceiling)
DT = 60.0              # s per step
T_MAX_STEPS = 2880     # 48 h
R_CRIT = 1.0           # roughness scrap threshold (normalized)
H_STRIKE_SAFE = 20e-6  # pad-built strike that survives the bath
PAD_UM_PER_LOAD = 7e-6  # 1 mm resin sheet @ ~2 eq/L -> ~7 um Cu / load
PAD_I_MAX = 60.0       # A/m2 through wet resin, fresh load
RELOAD_STEPS = 15      # 15 min to swap/recharge the resin sheet


class ElectroformEnv(pufferlib.PufferEnv):
    """Natively vectorized: one instance simulates ``num_agents`` cells."""

    N_HEADS = 6
    N_LEVELS = 7

    def __init__(self, num_agents=32, seed=0, divided=1, dt=DT,
                 render_mode=None, buf=None):
        self.dt = float(dt)
        self.divided = bool(divided)   # membrane-divided cell (design)
        self.render_mode = render_mode
        self.n_z = 8                   # radial zones, center -> rim
        # primary (geometric) current distribution: rim crowding for a
        # concave workpiece facing a plane anode; normalized weights
        r = (np.arange(self.n_z) + 0.5) / self.n_z
        p = 0.72 + 0.9 * r**3          # rim ~1.6x center
        self.p_dist = p / p.mean()
        obs_dim = 3 + 2 * self.n_z + 12
        self.single_observation_space = gymnasium.spaces.Box(
            low=-4, high=4, shape=(obs_dim,), dtype=np.float32)
        self.single_action_space = gymnasium.spaces.MultiDiscrete(
            [self.N_LEVELS] * self.N_HEADS)
        self.num_agents = num_agents
        super().__init__(buf)
        self.rng = np.random.default_rng(seed)
        self._reset_state()
        self.tick = 0

    # ------------------------------------------------------------ state #
    def _reset_state(self):
        B, Z = self.num_agents, self.n_z
        self.phase = np.zeros(B)               # 0 = pad, 1 = bath
        self.soc = np.ones(B)                  # resin state of charge
        self.reload_t = np.zeros(B)            # steps left in a reload
        self.h = np.zeros((B, Z))              # deposit thickness [m]
        self.h_strike = np.zeros(B)            # pad-phase thickness [m]
        self.rough = np.full((B, Z), 0.05)     # normalized roughness
        self.sigma_h = np.zeros((B, Z))        # stress-thickness [N/m]
        self.sigma_m = np.zeros((B, Z))        # stress 1st moment [N]
        self.c_b = np.full(B, 1.0)             # brightener, norm. conc
        self.c_s = np.full(B, 1.0)             # suppressor
        self.th_b = np.full(B, 0.5)            # surface coverages
        self.th_s = np.full(B, 0.5)
        self.c_cu = np.full(B, C_CU0)
        self.delam = np.zeros(B, dtype=bool)
        self.burned = np.zeros((B, Z), dtype=bool)
        self.t_step = np.zeros(B)
        self.ep_return = np.zeros(B)
        self.phi_prev = np.zeros(B)            # shaping potential
        self.last_sigma = np.zeros(B)          # witness reading cache
        self.observations[:] = self._obs()

    def _reset_agent(self, i):
        for arr, v in ((self.phase, 0), (self.soc, 1.0),
                       (self.reload_t, 0), (self.h_strike, 0),
                       (self.c_b, 1.0), (self.c_s, 1.0),
                       (self.th_b, 0.5), (self.th_s, 0.5),
                       (self.c_cu, C_CU0), (self.t_step, 0),
                       (self.ep_return, 0), (self.phi_prev, 0),
                       (self.last_sigma, 0)):
            arr[i] = v
        self.h[i] = 0.0
        self.rough[i] = 0.05
        self.sigma_h[i] = 0.0
        self.sigma_m[i] = 0.0
        self.delam[i] = False
        self.burned[i] = False

    # ------------------------------------------------------------- step #
    def step(self, actions):
        a = np.asarray(actions).reshape(self.num_agents, self.N_HEADS)
        B, Z = self.num_agents, self.n_z
        pad = self.phase < 0.5
        busy = self.reload_t > 0
        self.reload_t = np.maximum(self.reload_t - 1, 0)

        # ---- actions -> setpoints
        i_set = a[:, 0] / 6.0 * I_MAX
        duty = a[:, 1] / 6.0 * 0.30
        dose_b = a[:, 2] / 6.0 * 0.30
        dose_s = a[:, 3] / 6.0 * 0.30
        agit = a[:, 4] / 6.0
        mode = a[:, 5]
        # pad phase limits gentle current; a reload zeroes it
        i_cap = np.where(pad, PAD_I_MAX * np.maximum(self.soc, 0.0),
                         I_MAX)
        i_tot = np.clip(i_set, 0, i_cap) * (~busy)

        # ---- transport limit and current distribution
        delta = DELTA0 / (1.0 + 2.5 * agit) ** 0.6
        i_lim = N_E * F * D_CU * self.c_cu / delta
        # the resin pad plates by CONTACT - conformal, no field crowding
        i_lim = np.where(pad, PAD_I_MAX * 2.0, i_lim)
        # Wagner blend: low current -> kinetic control -> uniform; the
        # suppressor raises cathodic polarization, so its coverage IS
        # the throwing-power knob (why platers run PEG-Cl at all)
        wa = 22.0 / np.maximum(i_tot, 1.0) \
            * (1.0 + 8.0 * self.th_s)
        lam = (wa / (1.0 + wa))[:, None]
        w = (1.0 - lam) * self.p_dist[None, :] + lam
        w = np.where(pad[:, None], 1.0, w)
        i_z = i_tot[:, None] * w / w.mean(1, keepdims=True)
        frac = i_z / np.maximum(i_lim[:, None], 1e-9)

        # ---- current efficiency, growth
        ce = np.clip(1.0 - 0.5 * frac ** 4, 0.05, 1.0)
        k_far = M_CU / (N_E * F * RHO_CU) * self.dt
        dep = ce * i_z * k_far * (1.0 - duty[:, None])
        # periodic reverse deplates the crowded zones hardest (anodic
        # current follows the same primary distribution, amplified) -
        # the classic pulse-reverse leveling effect
        wsr = w ** 1.8
        strip = 0.6 * duty[:, None] * i_tot[:, None] * k_far \
            * wsr / wsr.mean(1, keepdims=True)
        dh = np.maximum(dep - strip, 0.0)
        self.h += dh
        self.h_strike += np.where(pad, dh.mean(1), 0.0)
        # resin depletion: charge drawn / charge per load
        q_load = PAD_UM_PER_LOAD * RHO_CU * N_E * F / M_CU   # C/m2
        self.soc -= np.where(pad, i_tot * self.dt / q_load, 0.0)
        self.soc = np.clip(self.soc, 0.0, 1.0)
        self.c_cu -= (i_z.mean(1) * AREA / (N_E * F)) * self.dt \
            / 0.25 * ~pad                    # 250 L bath, anode lags
        self.c_cu += np.where(~pad, 0.9 * (C_CU0 - self.c_cu) * 1e-4
                              * self.dt, 0.0)

        # ---- additive dynamics (bath only)
        k_anode = 2.0e-5 * (0.1 if self.divided else 1.0)
        inc = 4.0e-5 * i_tot / I_MAX
        self.c_b += (-k_anode * self.c_b - inc * self.th_b
                     + dose_b / self.dt) * self.dt * ~pad
        self.c_s += (-0.5 * k_anode * self.c_s - 0.5 * inc * self.th_s
                     + dose_s / self.dt) * self.dt * ~pad
        self.c_b = np.clip(self.c_b, 0.0, 3.0)
        self.c_s = np.clip(self.c_s, 0.0, 3.0)
        for th, c, kad in ((self.th_b, self.c_b, 8e-3),
                           (self.th_s, self.c_s, 6e-3)):
            th += (kad * c * (1 - th) - 1.2e-2 * (i_tot / I_MAX) * th
                   ) * self.dt * ~pad
            np.clip(th, 0.0, 1.0, out=th)

        # ---- roughness: dendritic growth vs leveling
        dend = np.maximum(frac - 0.55, 0.0)
        self.rough += (0.35 * dend ** 2 * (1 + 4 * self.rough)
                       - (0.010 + 0.06 * self.th_s[:, None]
                          + 0.5 * duty[:, None]) * self.rough
                       ) * self.dt / 60.0
        self.rough = np.clip(self.rough, 0.01, 2.0)
        burn = frac > 0.95
        self.burned |= burn
        self.rough[burn] = np.maximum(self.rough[burn], 0.8)

        # ---- Chason-form stress [Pa]; only where growth happens
        i_ref = 150.0
        gr = i_z / i_ref
        sig_t = 32e6 * np.sqrt(self.th_b[:, None] + 0.05) \
            * np.maximum(gr, 1e-3) ** 0.35
        sig_c = 14e6 / (gr + 0.15)
        sigma = (sig_t - sig_c) * (1.0 - 1.1 * duty[:, None])
        sigma = np.where(pad[:, None], 2e6 * np.ones_like(sigma), sigma)
        self.sigma_h += sigma * dh
        self.sigma_m += sigma * dh * (self.h - dh / 2)
        # growth interruption: reversible compressive drift (Chason)
        idle = (i_tot < 1.0)[:, None] & (self.h > 1e-6)
        self.sigma_h -= idle * 0.03 * self.dt         # N/m per s scale
        self.sigma_m -= idle * 0.03 * self.dt * self.h / 2

        # ---- mode actions
        to_bath = pad & (mode == 3) & ~busy
        if to_bath.any():
            # thin strike: acid eats the silver flash - delamination
            risk = np.exp(-self.h_strike / (H_STRIKE_SAFE * 0.45))
            roll = self.rng.random(B)
            self.delam |= to_bath & (roll < risk)
            self.phase = np.where(to_bath, 1.0, self.phase)
        reload_ = pad & (mode == 4) & ~busy
        self.reload_t = np.where(reload_, RELOAD_STEPS, self.reload_t)
        self.soc = np.where(reload_, 1.0, self.soc)

        # ---- reward: telescoping thickness potential + time cost
        rew = np.full(B, -0.003)
        rew -= 0.002 * (i_tot / I_MAX)              # energy
        phi = 2.0 * np.clip(self.h.min(1) / H_TARGET, 0, 1)
        rew += phi - self.phi_prev
        self.phi_prev = phi

        # ---- termination: peel, scrap, or timeout
        self.t_step += 1
        peel = (mode == 6) & ~busy
        scrap = (self.rough.max(1) > R_CRIT)
        timeout = self.t_step >= T_MAX_STEPS
        done = peel | scrap | timeout
        self.terminals[:] = done
        self.truncations[:] = False
        infos = []
        if done.any():
            q, mrad, hum = self._quality()
            # terminal absorbs the potential: total shaping = quality
            term_r = np.where(peel, q, 0.0) - self.phi_prev
            rew = np.where(done, rew + term_r, rew)
            self.ep_return += rew
            infos.append({
                "shell_quality": float(q[done].mean()),
                "figure_mrad": float(mrad[done].mean()),
                "thickness_um": float(hum[done].mean()),
                "hours": float(self.t_step[done].mean() * self.dt
                               / 3600.0),
                "scrapped": float(scrap[done].mean()),
                "delaminated": float(self.delam[done].mean()),
                "episode_return": float(self.ep_return[done].mean()),
                "episode_length": float(self.t_step[done].mean()),
            })
            for i in np.nonzero(done)[0]:
                self._reset_agent(i)
        else:
            self.ep_return += rew

        self.rewards[:] = rew.astype(np.float32)
        self.observations[:] = self._obs()
        self.tick += 1
        return (self.observations, self.rewards, self.terminals,
                self.truncations, infos)

    # ---------------------------------------------------------- quality #
    def _quality(self):
        h = self.h
        h_mean = np.maximum(h.mean(1), 1e-9)
        t_ok = np.clip(h.min(1) / H_TARGET, 0, 1) ** 2
        uni = np.exp(-((h.std(1) / h_mean) / 0.15) ** 2)
        # figure: stress first moment about the mid-plane -> curvature
        mom = self.sigma_m - self.sigma_h * h / 2
        kappa = 12.0 * np.abs(mom.mean(1)) \
            / np.maximum(E_CU * h_mean ** 3, 1e-12)
        mrad = kappa * 0.5 * 1e3            # slope at r = 0.5 m
        fig = np.exp(-(mrad / 3.0) ** 2)
        clean = np.exp(-((self.rough.max(1) - 0.05) / 0.5) ** 2)
        q = 20.0 * t_ok * (0.3 + 0.7 * uni) * (0.2 + 0.8 * fig) \
            * (0.3 + 0.7 * clean)
        q = np.where(self.delam, 0.0, q)
        return q, mrad, h_mean * 1e6

    # -------------------------------------------------------------- obs #
    def _obs(self):
        B = self.num_agents
        witness = self.sigma_h.mean(1) / 2000.0 \
            + self.rng.normal(0, 0.02, B)
        self.last_sigma = witness
        obs = np.concatenate([
            np.stack([self.phase, self.soc,
                      self.t_step / T_MAX_STEPS], 1),
            self.h / H_TARGET,
            self.rough,
            np.stack([
                witness,
                self.c_b + self.rng.normal(0, 0.03, B),
                self.c_s + self.rng.normal(0, 0.03, B),
                self.th_b, self.th_s,
                self.c_cu / C_CU0,
                self.h_strike / H_STRIKE_SAFE,
                self.reload_t / RELOAD_STEPS,
                self.delam.astype(float),
                (self.rough.max(1) > 0.5).astype(float),
                self.burned.any(1).astype(float),
                self.h.min(1) / H_TARGET,
            ], 1),
        ], axis=1).astype(np.float32)
        return np.clip(obs, -4.0, 4.0)

    def reset(self, seed=None):
        if seed is not None:
            self.rng = np.random.default_rng(seed)
        self._reset_state()
        return self.observations, [{}]


def electroform_heuristic(env):
    """Recipe operator: pad-strike to 20 um with reloads, then bath at
    ~0.4 i_lim with timer dosing, peel at target thickness."""
    B = env.num_agents
    a = np.zeros((B, env.N_HEADS), dtype=np.int64)
    pad = env.phase < 0.5
    a[:, 0] = np.where(pad, 6, 4)                    # current level
    a[:, 1] = np.where(pad, 0, 1)                    # small duty
    a[:, 2] = np.where(~pad & (env.c_b < 0.7), 2, 0)
    a[:, 3] = np.where(~pad & (env.c_s < 0.7), 2, 0)
    a[:, 4] = 6                                      # full agitation
    mode = np.zeros(B, dtype=np.int64)
    mode[pad & (env.soc < 0.08)] = 4                 # reload
    mode[pad & (env.h_strike >= H_STRIKE_SAFE * 1.15)] = 3
    mode[env.h.min(1) >= H_TARGET] = 6               # peel
    a[:, 5] = mode
    return a

"""TandoorHashemiEnv: Hashemi's fixed-focus mount feeding the coude's
sealed sideways tunnel.

  dish (orbits its own focus, always square to the sun, cosine 1.00)
    -> ellipsoidal relay segment just past the focus F
    -> vertical masonry chase inside the wall
    -> M5 -> the pot's NATIVE base air-inlet

Three reflections, not the coude's five, and the beam never shares a
volume with the cook.

WHY THE FOLD IS BENIGN HERE AND WAS NOT IN THE COUDE. With no Cassegrain
secondary the beam at F is still travelling UP toward the sun, so turning
it down is a 90+el deviation, i.e. incidence 45-el/2: 32.5 deg at el 25
falling to 2.5 deg at el 85. The coude's beam had already been turned
around, so it needed 90-el and grazed out at 22.9x footprint near zenith.

THE RELAY IS AN ELLIPSOID AND IT SLIDES. Two things, both load-bearing:

  * It must be an ELLIPSOID whose two foci ARE F and the duct. Such a
    surface images one focus exactly onto the other from ANY point on it,
    at any tilt. A spherical relay at 20 deg incidence blurs a point
    source at F to 104-128 mm rms on its own, against a 0.14 m duct.

  * It cannot be rigidly fixed. The arrival direction sweeps with the
    sun, so a mirror with a frozen normal would not send the beam down
    the chase except at one elevation. But because EVERY point of that
    ellipsoid images F onto the duct, the relay can be a SEGMENT that
    slides over a fixed ellipsoidal shell, following the beam - Hashemi's
    rail trick one level down. It rotates and slides in place; unlike our
    Cassegrain secondary it never translates through space, and it is
    ~0.9 m rather than 1.5 m. The numbers below assume exactly that.

THE COST, stated plainly: a powered mirror past the focus is a Gregorian
secondary, so it magnifies the dish's own spot at F by m = L/g while
shadowing the aperture by (g/f)^2. At EQUAL aperture that loses to the
polar retrofit (4.69 m2 against 5.60), because polar puts its focus
straight on the duct and only pays 0.70 cosine for it. This architecture
buys containment with aperture instead: a=2.10 gives 7.92 m2 effective,
7.45 after the extra glass fold, i.e. +33% on polar with the beam sealed
the whole way.
"""

import numpy as np
import torch

from artist.raytracing.raytracing_utils import reflect

import tandoor_artist_optics as AO
from tandoor_polar_env import (TandoorPolarEnv, R_DUCT, R_POT, H_POT,
                               Z_DUCT)
from tandoor_rl_env import _sim

def _align_np(a, b):
    """Rotation carrying unit a onto unit b (Rodrigues)."""
    a = np.asarray(a, float)
    b = np.asarray(b, float) / np.linalg.norm(b)
    v = np.cross(a, b)
    c = float(a @ b)
    if np.linalg.norm(v) < 1e-9:
        return np.eye(3) * (1.0 if c > 0 else -1.0)
    K = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
    return np.eye(3) + K + K @ K / (1 + c)


G_RELAY = 5.0      # relay distance past the focus [m]
L_TUNNEL = 5.0     # relay -> chase -> M5 -> duct, unfolded [m]


class TandoorHashemiEnv(TandoorPolarEnv):
    # WIDE dump authority. Square-on tracking on a 19 m2 dish delivers
    # 6-9 kW into a pot that wants ~3, so the binding constraint is not
    # "can it reach the band" but "can it avoid cooking past it" - the
    # same flip the coude geometry sweep found. Polar's narrow trim
    # (0.86..1.06) scored 199 rotis on 6.4 kW because level 0 was not a
    # dump. Level 0 here spills the focus off the duct entirely.
    LEVEL_FRAC = [0.62, 0.74, 0.85, 0.93, 1.00, 1.04, 1.10]

    def __init__(self, *args, a_mem=2.10, f_dish=12.0, g_relay=G_RELAY,
                 l_tunnel=L_TUNNEL, r_chase=0.70, **kwargs):
        self.r_chase = float(r_chase)
        self.a_mem = float(a_mem)
        self.f_dish = float(f_dish)
        self.g_relay = float(g_relay)
        self.l_tunnel = float(l_tunnel)
        super().__init__(*args, **kwargs)

    # -------------------------------------------------------- optics #
    def _cosine(self, decl_deg):
        """The dish is always square to the sun. That is the whole point
        of the mount, and it is what pays for the relay."""
        return 1.0

    def _build_optics(self):
        super()._build_optics()
        cfg = self.cfg
        dev = self.device
        cfg.a = self.a_mem
        # pressure that puts the FITTED focus at f_dish
        lo, hi = cfg.T_pre / (4 * self.f_dish), cfg.T_pre / (0.4 * self.f_dish)
        for _ in range(24):
            mid = 0.5 * (lo + hi)
            m = _sim.solve_membrane(cfg, mid, n=400)
            if m["z0"] + m["f_fit"] > self.f_dish:
                lo = mid
            else:
                hi = mid
        self.p0 = float(0.5 * (lo + hi))
        cfg.dp = self.p0
        self.level_frac = np.array(self.LEVEL_FRAC)
        mems = [_sim.solve_membrane(cfg, self.p0 * f, n=400)
                for f in self.level_frac]
        self._mem0 = mems[4]
        self.f_nom = float(mems[4]["z0"] + mems[4]["f_fit"])
        rng = np.random.default_rng(5)
        NR = 1100
        rr = np.sqrt(rng.uniform((0.06 * cfg.a) ** 2, (0.98 * cfg.a) ** 2, NR))
        th = rng.uniform(0, 2 * np.pi, NR)
        self._hx, self._hy = rr * np.cos(th), rr * np.sin(th)
        self.primary = AO.MembranePrimary(
            _sim, cfg, mems, self._hx, self._hy, dev,
            tag=f"hashemi{cfg.a:.2f}f{self.f_dish:.1f}",
            csr_frac=self.csr_frac)
        # circular rim, on axis: no off-axis astigmatism term to carry
        self.sigma_offaxis = 0.0
        self.sig_static = float(np.sqrt((2 * 2.0e-3) ** 2
                                        + (2 * self.sigma_print) ** 2))
        # Full chain, matched to what the other envs charge: aluminised
        # film 0.88, the FLAT fold and M5 as silvered glass 0.95 each,
        # and the duct lip 0.96 the polar retrofit also pays. Plus the
        # rim thinning the deposition physics gives the film, which the
        # beam-down models and this had been ignoring.
        self._loss_chain = 0.88 * 0.95 ** 2 * 0.96
        rho_r = 1.0 - 0.10 * (np.hypot(self._hx, self._hy) / cfg.a) ** 4
        cell = np.pi * (cfg.a ** 2) * (1 - 0.06 ** 2) / NR
        self._ray_pw = torch.tensor(cell * rho_r * self._loss_chain,
                                    dtype=torch.float32, device=dev)
        # our ray set is a different size from the polar env's, so the
        # scatter offsets built by super()._build_optics() are stale
        self._env_off = (torch.arange(self.num_agents, device=dev)
                         * self.n_nodes).repeat_interleave(NR)
        # FLAT fold at the pivot: the dish focuses, the flat only folds,
        # so there is no tilt aberration at any sun elevation.
        self.g_pivot = self.f_nom - self.l_tunnel
        self.r_flat = cfg.a * self.l_tunnel / self.f_nom
        sh = (self.l_tunnel / self.f_nom) ** 2
        print(f"  [hashemi] dish {np.pi*cfg.a**2:.1f} m2 f={self.f_nom:.2f} m,"
              f" FLAT fold r={self.r_flat:.2f} m at pivot g="
              f"{self.g_pivot:.2f} m, shadow {sh*100:.0f}%, chain "
              f"{self._loss_chain:.3f}, cosine 1.00")

    # --------------------------------------------------------- trace #
    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        """Live ARTIST trace: NURBS dish -> FLAT fold at the pivot -> duct.

        No lookup table: sigma_b (wind, pressure error) and the sun's
        position both enter every step, which is what the coude's table
        threw away.
        """
        dev = self.device
        B, P = p_eff.shape[0], len(self._hx)
        lv = np.clip((np.asarray(p_eff) / self.p0 - self.level_frac[0])
                     / (self.level_frac[-1] - self.level_frac[0])
                     * (self.N_LEVELS - 1), 0, self.N_LEVELS - 1)
        org, d4, _ = self.primary.bounce(
            torch.as_tensor(lv, dtype=torch.float32, device=dev),
            sigma_b, int(self.tick))
        el0, _, _ = _sim.solar_position(self.lat, self.day,
                                        float(self.t_solar[0]))
        el = float(np.clip(el0, 8.0, 89.0))
        s = np.array([0.0, -np.cos(np.radians(el)), -np.sin(np.radians(el))])
        M = _align_np([0.0, 0.0, 1.0], -s)
        Mt = torch.tensor(M.T, dtype=torch.float32, device=dev)
        p = org[..., :3] @ Mt
        d = d4[..., :3] @ Mt
        d = d / d.norm(dim=-1, keepdim=True)
        ax = torch.tensor(-s, dtype=torch.float32, device=dev)
        vdn = torch.tensor([0.0, 0.0, -1.0], device=dev)
        C = self.g_pivot * ax                    # the flat, at the PIVOT
        nf = ax - vdn
        nf = nf / nf.norm()
        inc0 = np.radians(45.0 - 0.5 * el)
        r_flat_t = self.r_flat / max(np.cos(inc0), 1e-3)
        # THE FOLD BLOCKS THE SUN BEFORE IT REACHES THE DISH. It sits on
        # the optical axis g_pivot in front, so it shadows the middle of
        # the aperture; without this the env overstates power by (L/f)^2.
        sun_d = torch.tensor(s, dtype=torch.float32, device=dev)
        den_s = (sun_d * nf).sum()
        t_sh = ((C - p) * nf).sum(-1) / torch.where(
            den_s.abs() > 1e-9, den_s, torch.full_like(den_s, 1e-9))
        sh = p + t_sh[..., None] * sun_d
        rel_s = sh - C
        rho_s = (rel_s - (rel_s * nf).sum(-1, keepdim=True) * nf).norm(dim=-1)
        lit = (rho_s > r_flat_t) | (t_sh > 0)
        den = (d * nf).sum(-1)
        t1 = ((C - p) * nf).sum(-1) / torch.where(den.abs() > 1e-9, den,
                                                  torch.full_like(den, 1e-9))
        hit = p + t1[..., None] * d
        rel = hit - C
        rho = (rel - (rel * nf).sum(-1, keepdim=True) * nf).norm(dim=-1)
        r_flat = r_flat_t
        dr = reflect(torch.cat([d, torch.zeros_like(d[..., :1])], -1),
                     torch.cat([nf, torch.zeros(1, device=dev)]
                               ).expand(B, P, 4))[..., :3]
        F2 = C + self.l_tunnel * vdn             # the duct mouth
        dv = (dr * vdn).sum(-1)
        t2 = ((F2 - hit) * vdn).sum(-1) / dv.clamp(min=1e-9)
        at = hit + t2[..., None] * dr
        # the converging beam has to fit the chase it descends
        mid = hit + 0.5 * (at - hit)
        r_mid = (mid - C - ((mid - C) * vdn).sum(-1, keepdim=True) * vdn
                 ).norm(dim=-1)
        ok = (lit & (rho < r_flat) & (t1 > 0) & (t2 > 0) & (dv > 1e-6)
              & (r_mid < self.r_chase))
        q = at - F2
        off = torch.as_tensor(offset_w, dtype=torch.float32, device=dev)
        ex = torch.tensor([1.0, 0.0, 0.0], device=dev)
        ey = torch.tensor([0.0, 1.0, 0.0], device=dev)
        pxp = (q * ex).sum(-1) + off[:, 0:1]
        pyp = (q * ey).sum(-1) + off[:, 1:2]
        through = ok & ((pxp ** 2 + pyp ** 2) <= R_DUCT ** 2)
        if self.render_mode == "human":
            self._last_org = org[0, :, :3].cpu().numpy()
        dxw = (dr * ex).sum(-1)
        dyw = -(dr * vdn).sum(-1)
        dzw = (dr * ey).sum(-1) - 0.16
        return self._bin_pot(pxp, pyp, dxw, dyw, dzw, through, soil, B, P)

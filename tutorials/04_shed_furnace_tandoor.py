"""
Shed Furnace: the architecture-search winner, quantified.

Layout (solar-furnace topology at tandoor scale):
  - OUTDOORS: one dumb flat heliostat (cheap film on a board, ~11 m^2,
    slope error ~3 mrad) tracks the sun and throws a horizontal beam
    north through a shed window.
  - INDOORS (zero wind/rain/dust/UV): the pump membrane (a=1.6 m,
    f = T/dp ~ 3 m) sits PERMANENTLY AIMED at the tandoor wall port,
    3 m away. Constant illumination geometry all day - the membrane
    never moves; the pump remains the focus trim.
  - PORT: r=0.15 m throat in the tandoor's side wall (cook works at the
    top mouth, never crosses the beam). A charge window (0.5 m^2 plain
    glazing) admits unconcentrated flux for cold-morning preheat.

Why this wins over the overhead beam-down Cassegrain (03_*): the blur
lever collapses from 27 m to 3 m - identical film errors cost 9x less -
and the precision surface is sheltered, so the wind/soiling terms that
gutted the field-real beam-down simply vanish.

Run: python 04_shed_furnace_tandoor.py
"""

import importlib.util
import pathlib
import sys

import numpy as np
trap = getattr(np, "trapezoid", getattr(np, "trapz", None))
import torch
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

_here = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(_here.parent))
_spec = importlib.util.spec_from_file_location(
    "tandoor_sim", _here / "03_membrane_beamdown_tandoor.py")
_sim = importlib.util.module_from_spec(_spec)
sys.argv, _argv = [sys.argv[0]], sys.argv
_spec.loader.exec_module(_sim)
sys.argv = _argv

# ---------------------------------------------------------------- config #
A_MEM = 1.6            # membrane radius [m]
THROW = 3.0            # membrane -> port [m]
R_PORT = 0.15          # port throat radius [m]
SIG_FLAT = 3.0e-3      # outdoor flat heliostat slope error [rad]
SIG_MEM = 2.0e-3       # sheltered membrane slope error [rad]
SIG_SUN = 2.09e-3      # ARTIST sunshape sigma [rad]
RHO_FLAT = 0.85        # outdoor soiled film flat
T_SHED = 0.92          # shed window
RHO_MEM = 0.90         # sheltered aluminized membrane (stays clean)
PORT_EFF = 0.96        # CPC-lip bounce losses for rim rays
LAT = 28.6
A_CHARGE = 0.5         # charge window [m^2]
T_CHARGE = 0.85        # its glazing
CAVITY_LOSS_K = 0.7    # W/m^2K backfill (8 cm fiber), area ~4.3 m^2
CAVITY_AREA = 4.3
A_PORT_LOSS = np.pi * R_PORT**2

# membrane FvK shape at f = THROW (pump-set): dp = T/f
CFG = _sim.CFG
CFG.a = A_MEM
mem = _sim.solve_membrane(CFG, CFG.T_pre / THROW, n=600)
print(f"membrane: dp={CFG.T_pre / THROW:.0f} Pa, f_fit={mem['f_fit']:.2f} m, "
      f"eps_nl={mem['eps_nl']:.2f}, w0={mem['w0'] * 1000:.0f} mm")

# ------------------------------------------------- port-spill Monte Carlo #
def port_pass_fraction(sig_extra=0.0, n=40000):
    """Trace the fixed on-axis system: rays over the membrane annulus,
    angular error = sunshape + doubled flat + doubled membrane slope
    errors; Hencky non-parabolicity enters EXACTLY via the FvK slope."""
    rng = np.random.default_rng(0)
    r = np.sqrt(rng.uniform(0.05**2, (0.985 * A_MEM) ** 2, n))
    th = rng.uniform(0, 2 * np.pi, n)
    x, y = r * np.cos(th), r * np.sin(th)
    rt = torch.tensor(r, dtype=torch.float64)
    s, sp = _sim.sag_interp(mem, rt)
    s, sp = s.numpy(), sp.numpy()
    # exact reflected direction off the FvK surface toward the focus,
    # then add angular errors and propagate to the port plane at z=f
    sig_ang = np.sqrt((2 * SIG_MEM) ** 2 + (2 * SIG_FLAT) ** 2
                      + SIG_SUN**2 + sig_extra**2)
    n3 = np.stack([-sp * x / r, -sp * y / r, np.ones(n)], 1)
    n3 /= np.linalg.norm(n3, axis=1, keepdims=True)
    d0 = np.array([0.0, 0.0, -1.0])
    d = d0 - 2 * (n3 @ d0)[:, None] * n3  # reflect upward toward focus
    d[:, :2] += rng.normal(0, sig_ang, (n, 2))
    tz = (mem["z0"] + mem["f_fit"] - s) / d[:, 2]
    px = x + tz * d[:, 0]
    py = y + tz * d[:, 1]
    return float(np.mean(px**2 + py**2 <= R_PORT**2))


# ------------------------------------------------------------ day chains #
def day_energy(day, name):
    hours = np.arange(7.0, 17.01, 0.25)
    p_in, p_charge, cos_h = [], [], []
    for t in hours:
        el, az, svec = _sim.solar_position(LAT, day, t)
        if el < 8.0:
            p_in.append(0.0), p_charge.append(0.0), cos_h.append(0.0)
            continue
        dni = _sim.clear_sky_dni(el)
        # Odeillo layout: heliostat NORTH of the shed fires SOUTH, so the
        # low winter sun is nearly beam-aligned - best cosine in winter,
        # exactly when the tandoor is energy-starved
        tgt = np.array([0.0, -1.0, 0.0])
        cos2i = np.clip((svec @ tgt + 1) / 2, 0, 1)  # cos^2 of half-angle
        c = np.sqrt(cos2i)
        cos_h.append(c)
        pw = (dni * np.pi * A_MEM**2 * 0.97 * c * RHO_FLAT * T_SHED
              * RHO_MEM * PASS_NOM * PORT_EFF)
        p_in.append(pw)
        p_charge.append(dni * A_CHARGE * max(np.sin(np.radians(el)), 0)
                        * T_CHARGE)
    p_in, p_charge = np.array(p_in), np.array(p_charge)
    kwh = trap(p_in, hours) / 1000
    print(f"  [{name}] peak {p_in.max():.0f} W into cavity | "
          f"day {kwh:.1f} kWh | mean cosine "
          f"{np.mean([c for c in cos_h if c > 0]):.2f} | charge window "
          f"+{trap(p_charge, hours) / 1000:.1f} kWh")
    return hours, p_in, p_charge, kwh


PASS_NOM = port_pass_fraction()
print(f"port pass fraction (nominal film): {PASS_NOM:.3f}")

print("== spillage vs membrane quality (the robustness story) ==")
for sig_mem_test in (1e-3, 2e-3, 3e-3, 5e-3):
    global SIG_MEM_SAVE
    old = SIG_MEM
    globals()["SIG_MEM"] = sig_mem_test
    p = port_pass_fraction()
    globals()["SIG_MEM"] = old
    print(f"  sigma_mem {sig_mem_test * 1e3:.0f} mrad -> pass {p:.3f}")

print("== day chains ==")
days = [(355, "winter solstice"), (80, "equinox"), (172, "summer solstice")]
results = {n: day_energy(d, n) for d, n in days}

# cold start: all delivered flux preheats (no band gating on input) plus
# the charge window; liner 20 MJ to band
liner_mj = 4.3 * 1900 * 880 * 0.015 * (560 - 350) / 1e6
h, p, pc, _ = results["equinox"]
cum = np.cumsum((p + pc) * 0.85) * (h[1] - h[0]) * 3600 / 1e6
t_band = h[np.searchsorted(cum, liner_mj)] if cum[-1] > liner_mj else np.inf
print(f"cold start: liner needs {liner_mj:.0f} MJ -> belt-band by "
      f"~{t_band:.1f} h solar (equinox), vs ~11:30 for the beam-down")

# steady margin at band
loss_band = (CAVITY_LOSS_K * CAVITY_AREA * (640 - 300)
             + 0.3 * 5.67e-8 * (640**4 - 300**4) * A_PORT_LOSS)
print(f"cavity losses at 640 K: {loss_band:.0f} W vs peak delivery "
      f"{results['equinox'][1].max():.0f} W")

# ------------------------------------------- heliostat pointing budget #
# The flat IS a robot: 2-axis, ~11 m^2, outdoors. Its burden, quantified:
# a pointing error delta tilts the beam 2*delta; at the port that walks
# the focal spot 2*delta*f (f = 3 m), and at the membrane it walks the
# illumination patch 2*delta*L_h (L_h ~ 6 m) causing edge vignetting.
print("== heliostat pointing budget (the 'robot' question) ==")
for dmr in (2.0, 5.0, 10.0, 15.0):
    d = dmr * 1e-3
    spot_walk = 2 * d * THROW * 1000
    vign = min(2 * d * 6.0 / (2 * A_MEM), 1.0)
    pp = port_pass_fraction(sig_extra=0.0, n=20000)
    # port pass with a static decenter: approximate via extra sigma? do
    # exact: shift the spot and recount
    rng = np.random.default_rng(1)
    r = np.sqrt(rng.uniform(0.05**2, (0.985 * A_MEM) ** 2, 20000))
    th = rng.uniform(0, 2 * np.pi, 20000)
    x, y = r * np.cos(th), r * np.sin(th)
    rt = torch.tensor(r, dtype=torch.float64)
    s, sp = _sim.sag_interp(mem, rt)
    s, sp = s.numpy(), sp.numpy()
    sig_ang = np.sqrt((2 * SIG_MEM) ** 2 + (2 * SIG_FLAT) ** 2 + SIG_SUN**2)
    n3 = np.stack([-sp * x / r, -sp * y / r, np.ones(20000)], 1)
    n3 /= np.linalg.norm(n3, axis=1, keepdims=True)
    d0 = np.array([np.sin(2 * d), 0.0, -np.cos(2 * d)])  # mispointed feed
    dd = d0 - 2 * (n3 @ d0)[:, None] * n3
    dd[:, :2] += rng.normal(0, sig_ang, (20000, 2))
    tz = (mem["z0"] + mem["f_fit"] - s) / dd[:, 2]
    px, py = x + tz * dd[:, 0], y + tz * dd[:, 1]
    pass_dec = float(np.mean(px**2 + py**2 <= R_PORT**2))
    print(f"  pointing err {dmr:4.1f} mrad: spot walk {spot_walk:4.0f} mm, "
          f"membrane vignette ~{vign * 100:2.0f}%, port pass {pass_dec:.3f}")
print("  (beam-down needed <2 mrad on a 6 m tilting gimbal; this needs "
      "<~10 mrad = 0.6 deg on a ground-level frame - garden-tracker class)")

# ------------------------------------------------------------------ fig #
fig, axs = plt.subplots(1, 2, figsize=(13, 5))
for n, (h, p, pc, kwh) in results.items():
    axs[0].plot(h, p / 1000, label=f"{n} ({kwh:.1f} kWh)")
axs[0].axhline(loss_band / 1000, color="r", ls="--",
               label="cavity loss at 640 K")
axs[0].set_xlabel("solar hour"), axs[0].set_ylabel("kW into cavity")
axs[0].set_title("Shed Furnace: delivered power (honest chain)")
axs[0].legend(fontsize=8)
sig = np.linspace(0.5e-3, 6e-3, 12)
ps = []
for sg in sig:
    globals()["SIG_MEM"] = sg
    ps.append(port_pass_fraction(n=20000))
axs[1].plot(sig * 1e3, ps, "o-")
axs[1].set_xlabel("membrane slope error [mrad]")
axs[1].set_ylabel("port pass fraction")
axs[1].set_title(f"Robustness: 3 m throw vs the beam-down's 27 m lever")
axs[1].set_ylim(0, 1.05)
fig.tight_layout()
out = _here / "data" / "tandoor" / "shed_furnace_study.png"
fig.savefig(out, dpi=110)
print(f"figure: {out}")

"""Refine beam-down geometry. pivot_drop is included because it is both
the mechanical clearance knob (rim swing radius hypot(a, pivot+w0)) and
an EFL term through M = (z_vertex+pivot)/z_gap - performance and
buildability are coupled here.

Metrics: rotis saturates at the cook's cadence (8 slots x 45 s), so
hours-in-band and peak temperature show the real thermal headroom."""
import itertools, pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from beamdown_sweep import cold_day

print(f"{'z_gap':>6}{'a':>6}{'piv':>5}{'shdw':>6}{'tilt':>6}{'kW':>6}"
      f"{'band@':>7}{'h_band':>8}{'h>560':>7}{'peak':>6}{'rotis':>7}")
best = None
for z_gap, a_m, piv in itertools.product(
        (1.8, 2.2, 2.6), (2.05, 2.45), (1.6, 2.4)):
    d = cold_day(z_gap=z_gap, r_pit=0.42, a_mem=a_m, pivot_drop=piv)
    H = piv + 0.06 - 0.15
    tl = np.degrees(np.arctan2(H, d["a"]) + np.arcsin(
        np.clip(0.75 / np.hypot(d["a"], H), -1, 1)))
    print(f"{z_gap:>6.2f}{a_m:>6.2f}{piv:>5.1f}"
          f"{(d['rsec']/d['a'])**2*100:>5.0f}%{tl:>5.0f}d{d['kw']:>6.2f}"
          f"{d['t_band']:>7.2f}{d['h_in']:>8.2f}{d['h_hot']:>7.2f}"
          f"{d['peak']:>6.0f}{d['rotis']:>7.1f}")
    if best is None or d["rotis"] > best[0]:
        best = (d["rotis"], dict(z_gap=z_gap, a_mem=a_m, pivot_drop=piv), d)
print(f"\nbest: {best[0]:.1f} rotis  {best[1]}")
print(f"      {best[2]['h_in']:.2f} h in band, {best[2]['h_hot']:.2f} h "
      f"above floor, peak {best[2]['peak']:.0f} K")

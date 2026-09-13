#!/usr/bin/env python
"""The stem with water in its lower sections: hydrostatic pressure rising toward the root (where the cantilever
moment is largest), the water as the foundation ballast, turgor actuation by pumping between two side chambers,
and the sloshing column as a liquid damper."""
import numpy as np
RHO_W, G = 1000.0, 9.81
r = 0.8; p_air = 1.0e5; L = 5.58; ET = 500e3
M_need9, M_need25 = 3.7e3, 35e3                    # base moments from screw_mount (4-tendon set, incl. own drag)
print("=== water in the lower section of the r 0.80 m stem ===")
for h_w in (0.0, 1.0, 2.0, 3.0):
    p_base = p_air + RHO_W*G*h_w
    Mw_base = 0.5*np.pi*p_base*r**3; Mw_top = 0.5*np.pi*p_air*r**3
    m_w = RHO_W*np.pi*r**2*h_w
    # moment diagram of the cantilever under a tip shear S: M(z) = S (L - z): the capacity must exceed it everywhere
    z = np.linspace(0, L, 200); p_z = p_air + RHO_W*G*np.clip(h_w - z, 0, None); Mw_z = 0.5*np.pi*p_z*r**3
    S_allow = np.min(Mw_z/np.clip(L - z, 1e-3, None))          # tip shear the whole stem carries
    print(f"water {h_w:.0f} m: base pressure {p_base/1e5:.2f} bar, wrinkle at base {Mw_base/1e3:.0f} kN m (top {Mw_top/1e3:.0f}); allowable tip shear {S_allow:.0f} N -> tip-shear moment at base {S_allow*L/1e3:.0f} kN m; water mass {m_w/1e3:.1f} t; hoop at base {p_base*r/1e3:.0f} kN/m")
print("\n=== the water as the foundation: overturning about the root's edge (footprint 1.8 m) ===")
for h_w in (1.0, 2.0, 3.0):
    m_w = RHO_W*np.pi*r**2*h_w; M_rest = (m_w*G)*0.9
    print(f"water {h_w:.0f} m: {m_w/1e3:.1f} t x g x 0.9 m = {M_rest/1e3:.0f} kN m of restoring moment vs {M_need9/1e3:.1f} kN m (9 m/s) / {M_need25/1e3:.0f} kN m (25 m/s)")
print("\n=== turgor actuation: two side chambers (half tubes) with a pressure difference ===")
for dp_bar in (0.05, 0.1, 0.2):
    M = dp_bar*1e5*(2*r**3/3)                       # net moment of a pressure difference over two half-discs (centroid 4r/3pi each)
    print(f"dp {dp_bar:.2f} bar: bending moment {M/1e3:.1f} kN m at any section (the 9 m/s holding torque is 3.7 kN m)")
V_half = 0.5*np.pi*r**2*2.0
print(f"a 2 m turgor section holds {V_half*1e3:.0f} L per half; a 100 L/min pump swaps a quarter of it in {0.25*V_half*1e3/100:.1f} min; the sun moves 0.25 deg/min: ample; a valve holds the set point with no power")
print("\n=== liquid damping ===")
f1 = 15.0
h_slosh = 1.0; f_slosh = np.sqrt(G*1.84/r*np.tanh(1.84*h_slosh/r))/(2*np.pi)
print(f"first sloshing mode of a {h_slosh:.0f} m column in the r {r} m tube: {f_slosh:.2f} Hz, in the gust band; the mount's rotational mode is {f1:.0f} Hz. The column damps the gust band, not the structure's mode: it is a tuned liquid damper for the dish's low-frequency swing if the bridle is slack, and ballast otherwise")

#!/usr/bin/env python
"""Inflated-beam checks for the fork's tubes, from the vine-robot theses and papers in resources/:
 - Coad 2021 (Stanford), eq. 4.2-4.3: axial buckling force of an inflated beam (Fichter's model) and the crushing force P A;
 - McFarland & McGuinness 2025 (arXiv 2510.25727), eq. 1: transverse collapse moment M = P pi D^3 / 8 (Leonard; Comer & Levy);
   the wrinkling onset is half of that, M_w = P pi r^3 / 2 (Veldman; Le van & Wielgosz);
 - Blumenschein 2019 (Stanford), eq. 2.1-2.3: the growth (eversion) force P A and its yield/viscous losses, the Lockhart-Ortega
   turgor-growth law r = phi (P - Y)^n that the plants' cells and these tubes share.
Applied to the posts (r 0.6 m) and the arms (r 0.4 m) at the simulation's 40 kPa and the design's 80 kPa."""
import numpy as np, sys, os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "fact_mount")); import geometry as GM
E, G, t = 1.0e9, 0.35e9, 0.5e-3           # a coated polyester/aramid fabric: E t = 500 kN/m, 0.5 mm
def coad_buckling(R, L, P): return (E*np.pi**3*R**4*t*P + E*G*np.pi**3*R**3*t**2)/(E*np.pi**2*R**2*t + R*L**2*P + G*t*L**2)
def crushing(R, P): return P*np.pi*R**2
def m_collapse(R, P): return P*np.pi*(2*R)**3/8
def m_wrinkle(R, P): return 0.5*np.pi*P*R**3
rows = []
for P in (40e3, 80e3):
    for name, R, L, F_ax, M_load in (("post", 0.60, 4.52, 0.5*650*9.81, 1.5e3),                    # half the cradle; ~1 m off-axis
                                     ("arm", 0.40, 4.10, 0.0, 0.5*100*9.81*4.6*np.cos(np.radians(12))),   # half the head at 4.6 m, el 12
                                     ("counterweight tube", 0.30, 2.10, 91*9.81, 91*9.81*2.6*np.sin(np.radians(45)))):
        rows.append((P/1e3, name, crushing(R, P), coad_buckling(R, L, P), F_ax, m_wrinkle(R, P), m_collapse(R, P), M_load))
print(f"{'P kPa':>6} {'tube':>18} {'crush F=PA':>11} {'Coad buckling':>14} {'axial load':>11} {'M_wrinkle':>10} {'M_collapse':>11} {'moment load':>12}  SF(wrinkle) SF(collapse)")
for P, name, Fc, Fb, Fa, Mw, Mc, Ml in rows:
    print(f"{P:6.0f} {name:>18} {Fc/1e3:9.1f} kN {Fb/1e3:11.1f} kN {Fa/1e3:8.2f} kN {Mw/1e3:7.1f} kNm {Mc/1e3:8.1f} kNm {Ml/1e3:9.2f} kNm  {Mw/Ml:8.1f} {Mc/Ml:10.1f}")
print("\nBlumenschein eq. 2.1: growth force P A for the post at 40 kPa =", round(crushing(0.6, 40e3)/1e3, 1), "kN; the eversion losses Y A and (v/phi)^(1/n) A are the blower's headroom (her Table: Y ~ 1-3 kPa for LDPE/ripstop).")
print("Lockhart-Ortega: dL/dt = phi (P - Y)^n is the turgor growth law of a plant cell wall; the vine tube and the pulvinus obey the same form.")

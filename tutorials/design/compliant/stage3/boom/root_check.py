"""3. what does a root 45x softer in bending than CHS 219x8 actually cost? EI_r = EI_boom/sqrt(45), arm EI_a = 45 EI_r."""
import numpy as np
E = 200e9; EI_b = E*np.pi/64*(0.219**4 - 0.203**4)
ratio, L_root = 45.0, 0.25
EI_r, EI_a = EI_b/np.sqrt(ratio), EI_b*np.sqrt(ratio)
print(f"built boom EI {EI_b/1e6:.2f} MN m2;  root EI {EI_r/1e6:.2f} (1/{np.sqrt(ratio):.1f}x);  arm EI {EI_a/1e6:.2f} ({np.sqrt(ratio):.1f}x)")
print()
print("the ROOT, 0.25 m long: a tube with EI_r, wall t, at the same steel")
for d in (0.10, 0.12, 0.15):
    I_need = EI_r/E; t = None
    for tt in np.linspace(0.002, 0.03, 500):
        if np.pi/64*(d**4 - (d-2*tt)**4) >= I_need: t = tt; break
    if t is None: print(f"   d {1e3*d:.0f} mm: no wall thick enough"); continue
    A = np.pi/4*(d*d - (d-2*t)**2); I = np.pi/64*(d**4 - (d-2*t)**4)
    P_head = (130 + 80)*9.81                                   # head and crown, the axial load the root carries
    m_arm = 7850*np.pi/4*((0.219*ratio**0.125)**2 - (0.219*ratio**0.125 - 2*0.008)**2)*6.0   # a 6 m arm of the fatter tube
    P_ax = P_head + m_arm*9.81
    Pcr = np.pi**2*E*I/(2*L_root)**2                           # cantilever root, effective length 2L
    M_gust = 14e3*6.0                                          # the survival gust force at a 6 m arm
    sig = M_gust*(d/2)/I
    print(f"   d {1e3*d:.0f} mm, t {1e3*t:.1f} mm: axial {P_ax/1e3:.1f} kN vs Euler {Pcr/1e3:.0f} kN (SF {Pcr/P_ax:.0f});  gust moment {M_gust/1e3:.0f} kN m -> {sig/1e6:.0f} MPa")
print()
print("the ARM: 45x the root's EI is ~2.6x the built tube's EI - d ~", f"{1e3*0.219*ratio**0.125:.0f} mm at the same wall;")
m_built = 7850*np.pi/4*(0.219**2 - 0.203**2); m_arm = 7850*np.pi/4*((0.219*ratio**0.125)**2 - (0.219*ratio**0.125 - 0.016)**2)
print(f"   mass {m_arm:.0f} kg/m against the built {m_built:.0f} kg/m - a 6 m arm gains {6*(m_arm-m_built):.0f} kg at the tip end of the stem")
print()
print("so the soft root is the binding element: at the 40 m/s gust its bending stress is the number to watch,")
print("and it is a FLEXURE - 0.25 m of tube bending a fraction of a degree under the head's weight and the wind,")
print("which is where the compliance was supposed to live all along.")

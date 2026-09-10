"""What the membrane's current theory leaves out, sized: modes with the air on it, the gust's admittance and resonance,
the aeroelastic limit, the thermal/creep drift of tension, and the n = 2 pressure harmonic the zones cannot touch."""
import numpy as np
from scipy.special import jn_zeros
a, t, E, nu, rho_pet = 2.10, 50e-6, 3.7e9, 0.38, 1390.0
T = 3000.0                          # working tension, mean over the disc (1-D FvK at f 4: rim 4.5 kN/m, pre 2.0)
rho, sag = 1.03, 0.276
mu_film = rho_pet*t
print(f"film {1e3*mu_film:.0f} g/m2, working tension {T:.0f} N/m, stress {1e-6*T/t:.0f} MPa (PET yield ~90), strain {100*T/(E*t):.2f} %")
print("\n1. MODES WITH THE AIR ON THEM (the film is 70 g/m2; the air it carries is 10-20x that)")
print(f"{'mode (m,n)':>10} {'j_mn':>6} {'added mass kg/m2':>17} {'mu total':>9} {'f in vacuum':>12} {'f in air':>9} {'volume-changing':>16}")
for (m, n) in ((0, 1), (1, 1), (2, 1), (0, 2), (3, 1)):
    j = jn_zeros(m, n)[-1]; k = j/a
    m_face = rho/k                                   # fluid loading of a wavy surface, one side, k a >~ 2
    m_back = rho*sag                                 # the plenum's air slab rides with the film (the sag-deep cavity)
    mu = mu_film + m_face + m_back
    f_vac = (j/(2*np.pi*a))*np.sqrt(T/mu_film); f_air = (j/(2*np.pi*a))*np.sqrt(T/mu)
    print(f"{str((m, n)):>10} {j:6.3f} {m_face + m_back:17.2f} {mu:9.2f} {f_vac:12.1f} {f_air:9.1f} {'yes -> +gas spring' if m == 0 else 'no':>16}")
gas = 32.0
print(f"   the sealed plenum stiffens the volume-changing modes by the gas spring ({gas:.0f}x the film): (0,1) -> {(jn_zeros(0,1)[-1]/(2*np.pi*a))*np.sqrt(T*(1+gas)/(mu_film + rho/(jn_zeros(0,1)[-1]/a) + rho*sag)):.0f} Hz; the tilt-like (1,1) and astigmatic (2,1) modes do not compress it")
print("\n2. THE GUST AT THOSE FREQUENCIES: the point spectrum the envs use, and Vickery's aerodynamic admittance the envs do not")
L, Iu = 50.0, 0.25; sqA = np.sqrt(np.pi*a*a)
def S_norm(f, U):                                        # f S(f)/sigma^2, von Karman
    x = f*L/U; return 4*x/(1 + 70.8*x*x)**(5/6)
def chi2(f, U): return 1.0/(1.0 + (2*f*sqA/U)**(4/3))    # Vickery: the gust's coherence over the dish
print(f"{'U m/s':>6} {'f Hz':>6} {'f S/sigma2':>11} {'admittance':>11} {'resonant/static variance (zeta 0.03)':>36}")
for U in (9.0, 12.0, 15.0):
    for f in (4.0, 16.0, 24.0):
        ratio = (np.pi/(4*0.03))*S_norm(f, U)*chi2(f, U)
        print(f"{U:6.1f} {f:6.1f} {S_norm(f, U):11.4f} {chi2(f, U):11.3f} {ratio:36.3f}")
print("   at 4 Hz (the boom) the envs load the head with the point spectrum: with admittance the force spectrum there is 4-5x lower;")
print("   at the film's 16-24 Hz modes the resonant response is under 1 % of the quasi-static one: the membrane's dynamics are not the gap")
print("\n3. THE AEROELASTIC LIMIT of a tensioned membrane in a stream (Tiomkin & Raveh 2017: T* = T/(q c) ~ 1 at divergence)")
c = 2*a
for U in (9.0, 12.0, 15.0, 25.0, 40.0):
    q = 0.5*rho*U*U; Tstar = T/(q*c)
    print(f"   U {U:4.0f}: q {q:5.0f} Pa, T* {Tstar:5.1f} -> the flow softens the film's stiffness by ~{100/Tstar:.0f} %{'   (survival: near divergence, stow)' if Tstar < 1.5 else ''}")
print("\n4. TENSION DRIFT the control has to chase: f = a^2/(4 s0) with s0 = p a^2/(4 T) -> f follows T/p one to one")
alpha = 17e-6; dT_sun = 30.0
dstrain = alpha*dT_sun; strain0 = T/(E*t)
print(f"   the film 30 K warmer in the sun: thermal strain {100*dstrain:.3f} % against a working strain of {100*strain0:.2f} % -> tension {100*dstrain/strain0:.0f} % lower -> f {4*dstrain/strain0:.2f} m shorter (the 7 pressure levels span +-20 %)")
print(f"   PET creep at 60 MPa: ~1 % per decade of hours -> ~{100*0.01/strain0:.0f} % of the working strain per decade: a slow pressure trim, seasonal not gusty")
print("\n5. THE PRESSURE MAP'S HARMONICS: the linear membrane response to p_n cos(n theta) r^n/a^n, slope rms per Pa")
rr = np.linspace(1e-3, a, 400); th = np.linspace(0, 2*np.pi, 360); R, TH = np.meshgrid(rr, th, indexing="ij")
for n_ in (1, 2, 3):
    # w_n = p_n a^2 (r/a)^n (1 - (r/a)^2) cos(n th) / (4 (n+1) T)  solves T lap w = -p_n (r/a)^n cos(n th), w(a) = 0
    W = (R/a)**n_*(1 - (R/a)**2)*np.cos(n_*TH)*a*a/(4*(n_ + 1)*T)
    wr = np.gradient(W, rr, axis=0); wt = np.gradient(W, th, axis=1)/R
    rms = np.sqrt(np.sum((wr**2 + wt**2)*R)/np.sum(R))
    print(f"   n = {n_}: slope {1e3*rms:.4f} mrad rms per Pa of harmonic amplitude -> at 15 m/s (q 116 Pa) a Cp harmonic of 0.3 gives {1e3*rms*0.3*116:.2f} mrad, blur {1e2*2*rms*0.3*116*4:.1f} cm at F")
print("   the envs carry n = 0 (defocus, corrected by the plenum) and n = 1 (the pitching moment, 5.9 mrad at 15 m/s); a bowl at Re 4e6 has n = 2, 3 of the same order, untouched by any zone.")

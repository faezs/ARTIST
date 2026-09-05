#!/usr/bin/env python
"""Pneumatic sunflower: sizing of the hose mast, the vine neck, the skin head and its Cassegrain, at three scales.

Frame: the tandoor pit at the origin, z up. One flower = root ring on the pit -> hose mast (straight, the beam
duct) -> bending neck (vine section) -> head: inflated toroidal rim + spherical-cap reflective skin under a
back plenum (the pumped membrane we already have, now on-axis), convex secondary skin on three mini-stems, a
fold M3 at the vertex hole aiming down the chord of the bent neck, a fold M4 at the mast top aiming down the
mast. Everything in the load path is fabric + pressure + cables; the only bearings are the two small folds.
"""
import numpy as np, os
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
LOG = []
def log(s=""): print(s); LOG.append(s)

RHO = 1.03                      # air at 1680 m (Quetta)
Q9, Q25 = 0.5*RHO*9**2, 0.5*RHO*25**2
CD = 1.3                        # dish, averaged over attitude
P = 200e3                       # 2 bar in the mast and neck (a water hose)
ET = 400e3                      # fabric modulus x thickness, PVC-coated polyester layflat, N/m
S_FAB = 60e3                    # fabric strength, N/m
Z_MAX = np.radians(80)          # deepest useful sun zenith angle -> head tilt
SUN = 9.3e-3                    # solar angular diameter, rad
DNI = 900.0

def hose(r, p=P):
    Mw = 0.5*np.pi*p*r**3        # wrinkling onset (compressive side reaches zero)
    Mc = np.pi*p*r**3            # collapse (Comer & Levy)
    EI = ET*np.pi*r**3           # inflated-beam bending stiffness (fabric acts as a thin shell)
    hoop = p*r                   # N/m
    return Mw, Mc, EI, hoop

ROOT_RUN = 1.2                  # root periscope: fold in the mast base -> horizontal run -> fold over the pot mouth

def flower(D, f1_over_D, d_frac, neck=0.5, clear=0.3, r_hose=None, p=P, root_run=ROOT_RUN):
    a = D/2; A = np.pi*a**2
    f1 = f1_over_D*D; R = 2*f1; sag = R - np.sqrt(R**2 - a**2)
    d = d_frac*f1                                  # secondary height above the vertex (inside the prime focus)
    mast = max(0.6, a*np.sin(Z_MAX) + clear - neck)  # rim clears the ground at full tilt
    hv = mast + neck                               # vertex height when upright
    b = d + neck + mast + root_run                 # secondary -> neck chord -> mast -> root periscope -> focus at the pot mouth
    m = b/(f1 - d); feff = m*f1
    r_sec = a*(f1 - d)/f1; shadow = (r_sec/a)**2
    r_beam_vertex = r_sec*(1 - d/b); r_beam_mast = r_sec*(1 - (d + neck)/b)
    # spherical-cap aberration (marginal ray) at the prime focus, magnified to the final focus
    th = np.arcsin(a/R); lsa = f1*(1/np.cos(th) - 1); tsa = lsa*a/f1
    spot = feff*SUN + 2*tsa*m
    # head mass: skins 0.35 kg/m2 (mirror film + back plenum film), toroidal rim, secondary + 3 mini-stems, folds
    r_t = 0.03*D
    m_head = 0.35*A + (2*np.pi*a)*(2*np.pi*r_t)*0.5 + 0.35*np.pi*r_sec**2*2 + 3*(0.05*D) + 2.0
    F9, F25 = Q9*CD*A, Q25*CD*A
    M9, M25 = F9*hv, F25*hv
    if r_hose is None: r_hose = max(0.12, r_beam_mast + 0.06)
    Mw, Mc, EI, hoop = hose(r_hose, p)
    # free cantilever pointing under the 9 m/s wind (no cables): rotation at the head
    th_free = F9*hv**2/(2*EI)
    # cable-stayed: three cables from the rim to ground anchors at 1.5 a from the base; 4 mm steel, EA 0.25 MN
    L_c = np.hypot(1.5*a, hv); k_c = 2.5e5/L_c
    K_cab = 1.5*k_c*a**2*(hv/L_c)**2                 # rotational stiffness about the head centre (3 cables, cos^2 of the slope)
    th_cab = M9/K_cab
    T_pre = 1.2*M9/(a*(1.5*a/L_c))/2                   # pretension so no cable goes slack in the 9 m/s gust (rough)
    P_axial = 3*T_pre*(hv/L_c) + m_head*9.81
    Pcr_euler = np.pi**2*EI/(2*hv)**2                # mast as a fixed-free column
    P_press = p*np.pi*r_hose**2                      # axial capacity before the wall goes slack
    eff = 0.88*0.90*0.95*0.95*(1 - shadow)*0.90
    return dict(D=D, A=A, f1=f1, R=R, sag=sag, d=d, mast=mast, hv=hv, b=b, m=m, feff=feff, r_sec=r_sec, shadow=shadow,
                r_bv=r_beam_vertex, r_bm=r_beam_mast, spot=spot, tsa=tsa, m_head=m_head, F9=F9, F25=F25, M9=M9, M25=M25,
                r_hose=r_hose, Mw=Mw, Mc=Mc, EI=EI, hoop=hoop, th_free=th_free, th_cab=th_cab, T_pre=T_pre, P_axial=P_axial,
                Pcr=Pcr_euler, P_press=P_press, eff=eff, kW=eff*A*DNI/1e3, L_c=L_c, K_cab=K_cab)

def best_point(D, spot_max=0.20, shadow_max=0.12, strut_max=1.2):
    """Smallest spot at the pot subject to the shadow and strut-length budgets; falls back to the least-bad point."""
    best = None
    for f1D in np.arange(1.0, 2.01, 0.1):
        for dfr in np.arange(0.50, 0.90, 0.025):
            r = flower(D, f1D, dfr)
            ok = r["spot"] <= spot_max and r["shadow"] <= shadow_max and r["d"] <= strut_max*D
            score = (0 if ok else 1, r["spot"] if ok else r["spot"] + 2*max(0, r["shadow"] - shadow_max) + max(0, r["d"] - strut_max*D))
            if best is None or score < best[0]: best = (score, round(f1D, 2), round(dfr, 3), r)
    return best[1], best[2], best[3]

DESIGN = {4.2: None, 2.1: None, 1.4: None}


def main():
    log("=== pneumatic sunflower: one head of the present collector area (13.9 m2) vs a bouquet of smaller ones ===")
    log(f"air {RHO} kg/m3: q 9 m/s {Q9:.0f} Pa, 25 m/s {Q25:.0f} Pa; Cd {CD}; hose {P/1e3:.0f} kPa, E t {ET/1e3:.0f} kN/m, strength {S_FAB/1e3:.0f} kN/m")
    rows = []
    for D, n in ((4.2, 1), (2.1, 4), (1.4, 9)):
        f1D, dfr, r = best_point(D); DESIGN[D] = (f1D, dfr)
        rows.append((n, r))
        log(f"\n--- D {D} m ({n} flower{'s' if n>1 else ''} for 13.9 m2), f1 = {f1D} D = {r['f1']:.2f} m, secondary at {dfr:.2f} f1 = {r['d']:.2f} m ---")
        log(f"skin: sphere R {r['R']:.2f} m, sag {r['sag']*1e3:.0f} mm; marginal-ray aberration blur {r['tsa']*1e3:.0f} mm at prime focus")
        log(f"mast {r['mast']:.2f} m + neck 0.50 m -> vertex at {r['hv']:.2f} m (rim clears ground at 80 deg tilt)")
        log(f"Cassegrain: secondary r {r['r_sec']:.2f} m (shadow {r['shadow']*100:.0f} %), magnification {r['m']:.1f}, f_eff {r['feff']:.1f} m, back focus {r['b']:.2f} m at the root")
        log(f"beam radius at the vertex hole {r['r_bv']*1e3:.0f} mm, at the mast top {r['r_bm']*1e3:.0f} mm -> hose r {r['r_hose']:.2f} m; spot at the pot {r['spot']*1e3:.0f} mm dia")
        log(f"head mass ~{r['m_head']:.0f} kg; wind force {r['F9']:.0f} N (9 m/s) / {r['F25']:.0f} N (25 m/s); base moment {r['M9']:.0f} / {r['M25']:.0f} N m")
        log(f"hose: wrinkle {r['Mw']:.0f} N m (SF {r['Mw']/r['M9']:.1f} at 9 m/s), collapse {r['Mc']:.0f} N m ({'lies down' if r['M25'] > r['Mc'] else 'survives'} at 25 m/s); hoop {r['hoop']/1e3:.0f} kN/m vs {S_FAB/1e3:.0f}; EI {r['EI']/1e3:.1f} kN m2")
        log(f"pointing at 9 m/s: free hose {np.degrees(r['th_free']):.1f} deg (useless) -> three ground cables: {r['th_cab']*1e3:.1f} mrad, pretension {r['T_pre']:.0f} N each, mast axial {r['P_axial']:.0f} N vs Euler {r['Pcr']:.0f} N / pressure {r['P_press']:.0f} N")
        log(f"optics: efficiency {r['eff']*100:.0f} % -> {r['kW']:.1f} kW per flower, {n*r['kW']:.1f} kW total (today 4.5-6 kW through the beta-tilted orbit with the 34 % fold shadow)")
    log("\n=== scale law at constant pressure (why the module is fractal) ===")
    log("wind moment ~ q Cd (pi/4) D^2 x height(~0.9 D) ~ D^3; wrinkling moment (pi/2) p r^3 with r ~ D ~ D^3: the safety factor is scale-free.")
    log("hoop tension p r ~ D: fabric thickness grows with scale (or pressure falls as 1/D, then SF ~ 1/D: large flowers lose).")
    log("free-hose pointing error F h^2 / (2 E t pi r^3) ~ D^4 / D^3 ~ D: small flowers point better; cable stays make it ~D^3/D^2 ~ D too, but 100x smaller.")
    log("head mass ~ D^2 (skins) while a rigid dish ~ D^2.5-3: the skin head is 17 kg at 4.2 m against 140 kg today.")
    log("eversion force p pi r^2 ~ D^2 ~ head weight: setup by inflation works at every scale.")
    log("\n=== what the flower removes from today's machine ===")
    log("no tower at F, no arc rail, no carriage, no beta tilt (on-axis head): no astigmatism, no rim squeeze; fold shadow 34 % -> secondary shadow 7-9 %;")
    log("the receiver-at-focus bore conflict disappears (the beam is always vertical in the mast); survival = vent and lie flat.")
    open(os.path.join(OUT, "checks.txt"), "w").write("\n".join(LOG))
    log(f"\ndesign points (f1/D, d/f1): {DESIGN}")

if __name__ == "__main__":
    main()

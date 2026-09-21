#!/usr/bin/env python
"""The crown sized for wind. The six primaries are a hexapod of struts from a receptacle ring at the stem top (r 0.6) to the
head's back ring (r 1.5): a triangulated crown holds the head axially, which a cantilever crown cannot. Loads are the audit's
corrected ones (peak factor 3 on the mean wind; 40 m/s 3-s survival gust; lift and the hinge moment). Members: the legs, the stem,
the calyx (secondaries and twigs under the membrane). Pointing: the image at F walks with the head's centre of curvature
C = P + R n, so the criterion is |dP + R (dtheta x n)| <= 5 cm (half power) at the operating peak. Writes out/wind_size.txt/json."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
sys.path.insert(0, HERE); import model as TM
A_D, D_D, RC, A_M = 13.854, 4.2, 8.0, 2.1
# ---- loads (audit, wind critic): peak load per (m/s)^2 of MEAN wind with G_load 3; survival 40 m/s 3-s gust, rho 1.055
K_F, K_M, K_L = 37.63, 10.07, 17.37                                 # N, N m, N per (m/s)^2 of mean wind (peak)
Q_S = 0.5*1.055*40**2                                                # 844 Pa
CASES = [("9 m/s mean, peak", 9.0, K_F*81, K_M*81, K_L*81), ("12 m/s mean, peak", 12.0, K_F*144, K_M*144, K_L*144), ("15 m/s mean, peak (stow decision)", 15.0, K_F*225, K_M*225, K_L*225),
         ("40 m/s 3-s gust, survival, unstowed", 40.0, 16.6e3, 0.34*Q_S*A_D*D_D, 7.7e3),
         ("40 m/s 3-s gust, survival, stowed face-up", 40.0, 0.24*Q_S*A_D*0.35, 0.08*Q_S*A_D*D_D, 1.5*Q_S*A_D)]   # edge-on Cd 0.24 on the sag's frontal area; hinge cm ~0.08; ASCE uplift GCr 1.5
TOL_F = 0.05                                                          # m at F: half power (env: 0.7 deg of head rotation = 4.9 cm)
# ---- geometry: the hexapod (6-6 Stewart layout) between the receptacle ring and the back ring
R_BASE, R_PLAT, D_BACK = 0.6, 1.5, 0.45
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])   # each base pair splits to two platform pairs (the 6-6 layout)
def hexapod(T0, P, n, up=np.array([0, 0, 1.0]), r_base=None):
    r_base = R_BASE if r_base is None else r_base
    xl, yl, zl = TM.head_axes(n)
    # base frame: x along the horizontal direction to the head, so the legs pair up toward it
    hx = P - T0; hx = hx - up*(hx@up); hx = hx/np.linalg.norm(hx) if np.linalg.norm(hx) > 1e-6 else np.array([1.0, 0, 0]); hy = np.cross(up, hx)
    B = np.array([T0 + r_base*(np.cos(a)*hx + np.sin(a)*hy) for a in BASE_ANG])
    Cp = P - D_BACK*n; Pp = np.array([Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG])
    L = np.linalg.norm(Pp - B, axis=1); U = (Pp - B)/L[:, None]
    J = np.hstack([U, np.cross(Pp - P, U)])                          # rows: leg screws about the hub
    return B, Pp, L, U, J
def leg_forces(J, W): return np.linalg.solve(J.T, W)                  # J^T f = W
def platform_compliance(J, k): return np.linalg.inv(J.T@np.diag(k)@J)  # 6x6, (dP, dtheta) = C W
MATERIALS = {
    "steel CHS": dict(E=200e9, rho=7850, sig=200e6),
    "aluminium 6082 tube": dict(E=70e9, rho=2700, sig=130e6),
    "GFRP pultruded tube": dict(E=30e9, rho=1900, sig=150e6),
    "timber (pine) pole": dict(E=10e9, rho=550, sig=20e6),
}
def chs(d, t): A = np.pi*(d*t - t*t); I = np.pi/64*(d**4 - (d - 2*t)**4); return A, I
def size_leg(mat, L, f_surv, f_op, k_needed=None):
    """smallest CHS (t = d/16, min 3 mm) with Euler SF 2 against the survival compression and sigma <= allowable"""
    E = MATERIALS[mat]["E"]; sig = MATERIALS[mat]["sig"]
    for d in np.arange(0.03, 0.40, 0.005):
        t = max(0.003, d/16); A, I = chs(d, t); Pcr = np.pi**2*E*I/L**2
        if Pcr >= 2*abs(f_surv) and abs(f_surv)/A <= sig: return d, t, A, I, Pcr
    return None
def wrench(case, n):
    _, V, F, Mh, Lf = case; w = np.array([-1.0, 0, 0]); Fv = F*w + Lf*np.array([0, 0, 1.0]); Mv = np.cross(w, n); Mv = Mv/np.linalg.norm(Mv)*Mh
    return np.concatenate([Fv, Mv])
def run_pose(P, n, T0, label, lines, sizing, r_bases=(0.6, 1.0, 1.5)):
    lines.append(f"\n== pose {label}: hub {np.round(P - [0, 0, TM.Z_DECK], 2)} m over the deck, axis el {np.degrees(np.arcsin(n[2])):.0f} deg")
    for rb in r_bases:
        B, Pp, L, U, J = hexapod(T0, P, n, r_base=rb); cond = np.linalg.cond(J)
        fmax = {c[0]: np.abs(leg_forces(J, wrench(c, n))).max() for c in CASES}
        lines.append(f"  receptacle r {rb} m: legs {L.min():.2f}-{L.max():.2f} m, Jacobian condition {cond:.0f}; max leg force " + ", ".join(f"{k.split(',')[0]}{' stowed' if 'stowed face' in k else (' unstowed' if 'unstowed' in k else '')}: {v/1e3:.1f} kN" for k, v in fmax.items()))
        f_design = max(fmax[CASES[2][0]], fmax[CASES[4][0]]); f_nostow = fmax[CASES[3][0]]
        for mat in ("steel CHS", "aluminium 6082 tube"):
            for tag, f_s in (("design: tracks to 15 m/s, stows for the gust", f_design), ("no stow: survives 40 m/s tracking", f_nostow)):
                sz = size_leg(mat, L.max(), f_s, 0)
                if sz is None: lines.append(f"     {mat}, {tag}: no section under 400 mm"); continue
                d, t, A, I, Pcr = sz; k = MATERIALS[mat]["E"]*A/L; C = platform_compliance(J, k)
                walk = [np.linalg.norm((C@wrench(c, n))[:3] + RC*np.cross((C@wrench(c, n))[3:], n)) for c in CASES[:3]]
                m_legs = 6*MATERIALS[mat]["rho"]*A*L.mean(); k_lat = 1.0/np.linalg.norm(C[:3, :3]@np.array([1.0, 0, 0])); f1 = np.sqrt(k_lat/(150.0 + m_legs/3))/(2*np.pi)
                lines.append(f"     {mat:20s} {tag:44s}: d {d*1e3:.0f} x {t*1e3:.1f} mm for {f_s/1e3:.0f} kN (Euler {Pcr/1e3:.0f} kN), {m_legs:.0f} kg; image walk at F {walk[0]*100:.1f} / {walk[1]*100:.1f} / {walk[2]*100:.1f} cm at 9 / 12 / 15 m/s peak (limit 5); first mode {f1:.1f} Hz")
                sizing.setdefault(label, {})[f"{mat}|{rb}|{tag}"] = dict(d=float(d), t=float(t), f=float(f_s), walk=[float(w_) for w_ in walk], f1=float(f1), m_legs=float(m_legs), legs=[float(L.min()), float(L.max())])
        if rb == 0.6:
            for Et, name in ((500e3, "fabric hose, E t 500 kN/m"), (5e6, "steel-wound hose, E t 5 MN/m")):
                r = 0.12; A = np.pi*r*r; K_eff = 1.0/(1.0/2.2e9 + 2*r/Et); k = K_eff*A/L; C = platform_compliance(J, k)
                x = C@wrench(CASES[0], n); walk9 = np.linalg.norm(x[:3] + RC*np.cross(x[3:], n))
                lines.append(f"     legs as water columns r 0.12 in a {name}: column modulus {K_eff/1e6:.1f} MPa -> image walk {walk9*100:.0f} cm at the 9 m/s peak: the wall's hoop compliance makes the water column a spring")
def size_stem(P, n, T0, lines, sizing):
    """the stem: a column from the deck to the receptacle carrying the head's wrench; sized for survival strength and for its tip rotation's share of the pointing"""
    O = np.array([T0[0], T0[1], TM.Z_DECK]); Ls = T0[2] - O[2]
    out = {}
    for case, V, F, Mh, Lf in CASES:
        w = np.array([-1.0, 0, 0]); Fv = F*w + Lf*np.array([0, 0, 1.0]); Mv = np.cross(w, n); Mv = Mv/np.linalg.norm(Mv)*Mh
        M_root = np.linalg.norm(Mv + np.cross(P - O, Fv)); out[case] = M_root
        lines.append(f"   stem root moment, {case:38s}: {M_root/1e3:5.1f} kN m (shear {F/1e3:.1f} kN)")
    M_s = max(out[CASES[2][0]], out[CASES[4][0]]); M_ns = out[CASES[3][0]]; M_9 = out[CASES[0][0]]
    lever = np.linalg.norm(P + RC*n - O)                                                          # from the stem foot to the head's centre of curvature
    for mat in MATERIALS:
        E, sig = MATERIALS[mat]["E"], MATERIALS[mat]["sig"]
        for d in np.arange(0.06, 0.8, 0.005):
            t = max(0.004, d/25); A, I = chs(d, t); Z = 2*I/d
            theta = M_9*Ls/(E*I); walk = theta*lever
            if M_s/Z <= sig and walk <= 0.4*TOL_F: break
        lines.append(f"   stem in {mat:20s} (design: 15 m/s tracking or stowed gust, {M_s/1e3:.0f} kN m; unstowed gust would be {M_ns/1e3:.0f}): d {d*1e3:.0f} x {t*1e3:.0f} mm, {Ls:.1f} m: stress {M_s/Z/1e6:.0f} MPa (allowable {sig/1e6:.0f}), tip rotation at 9 m/s peak {theta*1e3:.2f} mrad -> {walk*100:.1f} cm at F over the {lever:.1f} m lever; mass {MATERIALS[mat]['rho']*A*Ls:.0f} kg")
        sizing.setdefault("stem", {})[mat] = dict(d=float(d), t=float(t), M_root_surv=float(M_s))
    # an inflated stem for contrast
    for r in (0.25, 0.4):
        p_w = 2*M_s/(np.pi*r**3); p_op = 2*M_9/(np.pi*r**3)
        lines.append(f"   inflated stem r {r}: wrinkling needs p {p_w/1e5:.1f} bar at survival ({p_op/1e5:.2f} bar at the 9 m/s peak), hoop {p_w*r/1e3:.0f} kN/m; and its bending stiffness (E t pi r^3 at E t 500 kN/m) {500e3*np.pi*r**3/1e3:.0f} kN m2 gives {M_9*Ls/(500e3*np.pi*r**3)*1e3:.0f} mrad of tip rotation at 9 m/s peak: it is not a stem, it is a hinge")
def size_calyx(lines, sizing):
    """the head's own frame under the membrane: 60 tips on twigs of 0.5 m from 12 secondaries of 0.65 m from the back ring; the membrane's wind pressure divides among the tips"""
    for case, V, F, Mh, Lf in (CASES[0], CASES[3]):
        F_tip = (F + Lf)/60; M_twig = F_tip*0.5; F_sec = 5*F_tip; M_sec = F_sec*0.65 + 5*F_tip*0.25
        d_tw = next(d for d in np.arange(0.012, 0.08, 0.002) if M_twig/(2*chs(d, max(0.0015, d/16))[1]/d) <= 130e6)
        d_sc = next(d for d in np.arange(0.02, 0.12, 0.002) if M_sec/(2*chs(d, max(0.002, d/16))[1]/d) <= 130e6)
        lines.append(f"   calyx, {case:38s}: {F_tip:.0f} N per tip -> twig {d_tw*1e3:.0f} mm aluminium tube (0.5 m), secondary {d_sc*1e3:.0f} mm (0.65 m, five tips); membrane pressure difference {(F + Lf)/A_D:.0f} Pa")
        sizing.setdefault("calyx", {})[case] = dict(d_twig=float(d_tw), d_sec=float(d_sc), F_tip=float(F_tip))
if __name__ == "__main__":
    lines, sizing = [], {}
    lines.append("loads (audit: peak factor 3 on the mean wind; survival 40 m/s 3-s gust at rho 1.055): " + "; ".join(f"{c[0]}: F {c[2]/1e3:.2f} kN, hinge M {c[3]/1e3:.2f} kN m, lift {c[4]/1e3:.2f} kN" for c in CASES))
    poses = []
    pj = os.path.join(OUT, "path.json")
    if os.path.exists(pj):
        PJ = json.load(open(pj)); good = [l for l in PJ["log"] if l.get("ok")]
        if good:
            T0 = np.array(PJ["stem"]) + np.array([0, 0, TM.Z_DECK]); lines.append(f"still-head schedule from path.json: stem {PJ['stem'][0]} m north, {len(good)} of {len(PJ['log'])} sun samples reachable, beta mean {np.mean([l['beta'] for l in good]):.1f} max {max(l['beta'] for l in good):.1f} deg, pipe+strip shadow mean {100*np.mean([l['shadow'] for l in good]):.1f} %")
            picks = sorted(good, key=lambda l: -l["reach"])[:1] + [min(good, key=lambda l: abs(l["hour"] - 12) + abs(l["doy"] - 80))]
            for l in picks: poses.append((f"{l['doy']} d {l['hour']:.0f} h (beta {l['beta']:.0f})", np.array(l["P"]) + np.array([0, 0, TM.Z_DECK]), np.array(l["n"])))
    if not poses:
        T0 = TM.T0.copy(); el, Az, s = TM.sun(80, 12.0); P, n = TM.pose(s, 0.0); poses.append(("equinox noon retro", P, n))
        el, Az, s = TM.sun(80, 8.0); P, n = TM.pose(s, 0.0); poses.append(("equinox 8 h retro", P, n))
    for label, P, n in poses:
        run_pose(P, n, T0, label, lines, sizing)
    lines.append("\n== the stem (from the worst pose)")
    label, P, n = poses[0]; size_stem(P, n, T0, lines, sizing)
    lines.append("\n== the calyx")
    size_calyx(lines, sizing)
    txt = "\n".join(lines); print(txt); open(os.path.join(OUT, "wind_size.txt"), "w").write(txt + "\n"); json.dump(sizing, open(os.path.join(OUT, "wind_size.json"), "w"), indent=1)

#!/usr/bin/env python
"""The dish mount as a screw-theoretic constraint design, checked over the Quetta year.

Body: the dish. Freedom (Hashemi, figs 3-5): rotations about the fixed focus F only; the vertex rides the focal
circle of radius f = R/2 about F, the axis through F. Freedom space: the 3-D space of rotation twists about
axes through F. Reciprocal constraint space: pure-force wrenches whose lines pass through F.

Members and their wrench spaces:
  bridle   4 wires from an outrigger ring to the apex at F: lines through F. They span the constraint space,
           carry the force part of every load, and are reciprocal to all three rotations: zero moment arm.
  stem     the vine hose from the root on the deck, clamped to the dish's back ring: a compliant 6-DOF element.
           Unlike a wire it transmits shear forces off its own line and couples; flexed, it applies the torque
           toward the top of the orbit that no line from below can (a tension line from a point below F pulls
           the dish down its orbit). Its capacity is the wrinkling moment of the hose.
  tendons  4 pretensioned wires to low winches: bilateral stiffness once pretensioned, redundancy, no holding
           torque of their own.
Twist pairing about F: t = [dx_F; dtheta], w = [f; tau_F]. Stiffness K = sum k w w^T over lines + the stem's
tip stiffness transported to F. Statics: LP with the lines unilateral and the stem's tip shear bounded.
"""
import os, sys, numpy as np
from scipy.optimize import linprog
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "fact")); sys.path.insert(0, HERE)
from fact_core import rot_twist, wire, describe
from dcm_core import interface_freedom
import physics_hp as H
OUT = os.path.join(HERE, "out"); LOG = []
def log(s=""): print(s); LOG.append(s)

F = H.F; A = H.A_DISH; R_SPH = H.R_SPH; SAG = H.SAG; ROOTP = H.ROOT
R_B = 3.2                                       # outrigger ring radius (rim 2.1): bridle outside the cone, clear of the strip
BRIDLE_AZ = np.radians([70, 110, -70, -110])    # from the downhill (slot) direction: never on the strip's meridian
TENDON_SETS = {
    "EW pair, far south winches":       [(90, "ew_south"), (-90, "ew_south")],
    "EW far south + north pair out":    [(90, "ew_south"), (-90, "ew_south"), (135, "north_out"), (-135, "north_out")],
    "north pair out only":              [(135, "north_out"), (-135, "north_out")],
    "EW far south + north pair far":    [(90, "ew_south"), (-90, "ew_south"), (135, "north_far"), (-135, "north_far")],
}
import json as _json
_sol = os.path.join(OUT, "tendon_solution.json")
if os.path.exists(_sol):
    _d = _json.load(open(_sol))
    TENDON_SETS = {"solver 4": [(e["az"], ("anchor", e["W"])) for e in _d["four"]], "solver 3": [(e["az"], ("anchor", e["W"])) for e in _d["three"]]}
CHOSEN = "solver 4"
TENDON_AZ = np.radians([45, -45])
WINCH_R = 6.0
M_HEAD = 60.0
EA_B, EA_T = 5.0e6, 5.0e6                       # 8 mm wire rope
MBL = 38e3
T_MIN = 300.0
ET, GT = 500e3, 150e3                           # hose fabric E t, G t (N/m)
Q9, Q25 = H.Q9, H.Q25; AREA = H.AREA
STEMS = [(0.60, 1.00), (0.70, 1.20), (0.80, 1.00)]   # (radius m, pressure bar)

def winches():
    W = []
    for psi in np.radians([45, 135, 225, 315]):
        x, y = 1.25 + WINCH_R*np.cos(psi), WINCH_R*np.sin(psi); W.append(np.array([x, y, 5.0 if x >= 1.25 else 1.0]))
    return W

def dish_frame(s):
    zl = np.asarray(s, float); up = np.array([0, 0, 1.0]) - zl*zl[2]
    if np.linalg.norm(up) < 1e-6: up = np.array([1.0, 0, 0])
    up /= np.linalg.norm(up); xl = -up; yl = np.cross(zl, xl); return xl, yl, zl

def wrench_F(P, u):
    u = np.asarray(u, float)/np.linalg.norm(u); return np.concatenate([u, np.cross(np.asarray(P) - F, u)])

def skew(r):
    return np.array([[0, -r[2], r[1]], [r[2], 0, -r[0]], [-r[1], r[0], 0]])

def stem_element(tip, r_s, p_bar):
    """clamped-clamped inflated beam from the root to the tip: 6x6 tip stiffness transported to F, plus capacities."""
    d = tip - ROOTP; L = np.linalg.norm(d); ez = d/L
    ex = np.cross([0, 0, 1.0], ez); ex = ex/np.linalg.norm(ex) if np.linalg.norm(ex) > 1e-6 else np.array([1.0, 0, 0]); ey = np.cross(ez, ex)
    Rm = np.column_stack([ex, ey, ez])
    EA, EI, GJ = ET*2*np.pi*r_s, ET*np.pi*r_s**3, GT*2*np.pi*r_s**3
    k = np.zeros((6, 6))
    k[2, 2] = EA/L; k[5, 5] = GJ/L
    k[0, 0] = k[1, 1] = 12*EI/L**3; k[3, 3] = k[4, 4] = 4*EI/L
    k[0, 4] = k[4, 0] = 6*EI/L**2; k[1, 3] = k[3, 1] = -6*EI/L**2
    Rb = np.block([[Rm, np.zeros((3, 3))], [np.zeros((3, 3)), Rm]]); kw = Rb @ k @ Rb.T
    B = np.block([[np.eye(3), np.zeros((3, 3))], [skew(tip - F), np.eye(3)]])
    p = p_bar*1e5
    return dict(K_F=B @ kw @ B.T, L=L, ez=ez, ex=ex, ey=ey, EI=EI, thrust=p*np.pi*r_s**2, Mw=0.5*np.pi*p*r_s**3, Mc=np.pi*p*r_s**3)

def members(p, tendon_set=None):
    tendon_set = TENDON_SETS[CHOSEN] if tendon_set is None else tendon_set
    s = p["s"]; V = p["V"]; xl, yl, zl = dish_frame(s)
    ring = lambda az: V + SAG*zl + R_B*(np.cos(az)*xl + np.sin(az)*yl)
    B = []
    for az in BRIDLE_AZ:
        P = ring(az); u = F - P; L = np.linalg.norm(u); B.append(dict(P=P, u=u/L, L=L, k=EA_B/L))
    T = []
    for az_deg, kind in tendon_set:
        az = np.radians(az_deg); P = ring(az); sgn = 1.0 if (az_deg % 360) < 180 else -1.0
        if isinstance(kind, tuple):  W = np.array(kind[1], float)       # explicit anchor from the solver
        elif kind == "ew_south":  W = np.array([-1.0, 7.0*sgn, 1.0])     # just south of the wall, far out: the crossing of the wall plane stays clear of the tube
        elif kind == "north_out": W = np.array([9.0, 6.0*sgn, 5.0])     # deck, beyond the sweep, outward: lines run away from the stem
        elif kind == "north_far": W = np.array([11.0, 3.0*sgn, 5.0])
        else:                     W = np.array([-3.0, 4.24*sgn, 1.0])
        u = W - P; L = np.linalg.norm(u); T.append(dict(P=P, u=u/L, L=L, k=EA_T/L, W=W))
    tip = H.tip_point(p)
    return B, T, tip

def ext_wrenches(p, q):
    s = p["s"]; V = p["V"]; Cg = V - 0.15*s; Cp = V
    g = np.array([0, 0, -M_HEAD*9.81]); Wg = np.concatenate([g, np.cross(Cg - F, g)])
    out = []
    for ang in np.radians(np.arange(0, 360, 45)):
        wd = np.array([np.cos(ang), np.sin(ang), 0.0]); Fw = q*AREA*(1.4*abs(wd@s) + 0.25)*wd
        out.append(Wg + np.concatenate([Fw, np.cross(Cp - F, Fw)]))
    out.append(Wg); return out

def analyse(p, q, r_s, p_bar, tendon_set=None):
    tendon_set = TENDON_SETS[CHOSEN] if tendon_set is None else tendon_set
    B, T, tip = members(p, tendon_set); st = stem_element(tip, r_s, p_bar)
    lines = B + T; n = len(lines)
    wL = np.array([wrench_F(m["P"], m["u"]) for m in lines])
    L = st["L"]; Mw = st["Mw"]; Tw = np.sqrt(2)*np.pi*(p_bar*1e5)*r_s**3; Nmax = st["thrust"]
    ex, ey, ez = st["ex"], st["ey"], st["ez"]
    # stem variables, each split +/-: Sx Sy (tip shear along ex, ey), N (axial), Mx My (tip couples about ex, ey), Tz (torsion)
    cols = [wrench_F(tip, ex), wrench_F(tip, ey), wrench_F(tip, ez), np.concatenate([np.zeros(3), ex]), np.concatenate([np.zeros(3), ey]), np.concatenate([np.zeros(3), ez])]
    Acols = [wL.T]
    for c_ in cols: Acols += [c_[:, None], -c_[:, None]]
    Aeq = np.hstack(Acols)                          # 6 x (n + 12)
    # base bending: |M_y + L S_x| <= Mw and |M_x - L S_y| <= Mw (sign pattern of the clamped beam), torsion |T| <= Tw
    def row(coefs):
        r = np.zeros(n + 12)
        for idx, val in coefs: r[n + idx] = val
        return r
    # index map: Sx+ 0, Sx- 1, Sy+ 2, Sy- 3, N+ 4, N- 5, Mx+ 6, Mx- 7, My+ 8, My- 9, T+ 10, T- 11
    Aub = np.array([row([(8, 1), (9, -1), (0, L), (1, -L)]), row([(8, -1), (9, 1), (0, -L), (1, L)]),
                    row([(6, 1), (7, -1), (2, -L), (3, L)]), row([(6, -1), (7, 1), (2, L), (3, -L)])])
    bub = np.array([Mw, Mw, Mw, Mw])
    bounds = [(T_MIN, None)]*n + [(0, None)]*4 + [(0, 0.5*Nmax), (0, Nmax)] + [(0, Mw)]*4 + [(0, Tw)]*2
    cost = np.concatenate([np.ones(n), [L, L, L, L, 0.05, 0.05, 1, 1, 1, 1, 1, 1]])     # tensions in N, stem usage in N m
    res_all = []
    for We in ext_wrenches(p, q):
        res = linprog(c=cost, A_eq=Aeq, b_eq=-We, A_ub=Aub, b_ub=bub, bounds=bounds, method="highs")
        res_all.append(res.x if res.success else None)
    K = sum(m["k"]*np.outer(w, w) for m, w in zip(lines, wL)) + st["K_F"]
    Cm = np.linalg.pinv(K); Wg = ext_wrenches(p, q)[8]
    rot = 0.0
    for We in ext_wrenches(p, q)[:8]:
        t = Cm @ (We - Wg); th = t[3:]; th = th - (th@p["s"])*p["s"]; rot = max(rot, np.linalg.norm(th))
    return dict(B=B, T=T, tip=tip, st=st, res=res_all, K=K, rot=rot, n=n)

def stem_base_moment(x, a):
    n = a["n"]; L = a["st"]["L"]; v = x[n:]
    Sx, Sy, Mx, My = v[0] - v[1], v[2] - v[3], v[6] - v[7], v[8] - v[9]
    return max(abs(My + L*Sx), abs(Mx - L*Sy))

def strip_points(s):
    F2 = np.array([1.25, 0.0, 6.14]); c = np.linalg.norm(F - F2)/2; a = c - 0.8; e = c/a; pp = a*(e*e - 1)
    hdir = -np.array([s[0], s[1], 0.0]); hdir /= max(np.linalg.norm(hdir), 1e-9); wdir = np.cross([0, 0, 1.0], hdir)
    pts = []
    for th in np.radians(np.linspace(10, 110, 60)):
        r = pp/(1 + e*np.cos(th))
        if r*np.sin(th) > 0.8: break
        c0 = F + r*(-np.cos(th)*np.array([0, 0, 1.0]) + np.sin(th)*hdir)
        for w in np.linspace(-1, 1, 5): pts.append(c0 + w*0.55*r*wdir)
    return np.array(pts)

def seg_seg_dist(P0, P1, Q0, Q1, n=60):
    ts = np.linspace(0, 1, n); A_ = P0[None, :] + ts[:, None]*(P1 - P0)[None, :]; B_ = Q0[None, :] + ts[:, None]*(Q1 - Q0)[None, :]
    return np.linalg.norm(A_[:, None, :] - B_[None, :, :], axis=2).min()

def seg_point_dist(P0, P1, X):
    d = P1 - P0; t = np.clip(((X - P0) @ d)/(d@d), 0, 1); return np.linalg.norm(X - (P0 + t[:, None]*d), axis=1).min()

def main():
    POS = H.positions()
    log("=== freedom and constraint spaces (equinox noon) ===")
    p0 = [p for p in POS if p["season"] == "equinox" and abs(p["hour"] - 12) < 0.01][0]
    B, T, tip = members(p0)
    wB = [wire(m["P"], m["u"]) for m in B]; wT = [wire(m["P"], m["u"]) for m in T]
    Tfree = [rot_twist(F, [1, 0, 0]), rot_twist(F, [0, 1, 0]), rot_twist(F, [0, 0, 1])]
    left, r = interface_freedom(wB); log(f"bridle (4 lines through F): rank {r}, DOF {6 - r}: {describe(left)}")
    log(f"any three bridle wires: rank {interface_freedom(wB[:3])[1]}; bridle + 2 tendons: rank {interface_freedom(wB + wT)[1]} (the sixth constraint, roll about the dish axis, is the stem's torsion); any single line lost: rank >= {min(interface_freedom([w for j, w in enumerate(wB + wT) if j != i])[1] for i in range(6))}")
    rec = np.array([[abs(w[:3]@t[3:] + w[3:]@t[:3]) for t in Tfree] for w in wB]); log(f"reciprocal products bridle x rotations-about-F: max {rec.max():.1e}")
    arms = np.array([np.cross(m["P"] - F, m["u"]) for m in T]); log(f"tendon moment arms about F (x,y,z) [m]: {np.round(arms, 2).tolist()}")
    log(f"gravity torque about F at this position: {np.round(ext_wrenches(p0, Q9)[8][3:], 0)} N m; every tendon arm has the same sign about y: lines from below cannot hold the dish up its orbit")
    st = stem_element(tip, 0.4, 0.5)
    log(f"stem (r 0.40, 0.5 bar, L {st['L']:.2f} m) tip stiffness at F: rotational block eigenvalues {np.round(np.linalg.eigvalsh(st['K_F'][3:, 3:])/1e3, 0)} kN m/rad; it is a 6-D wrench source: couples and off-line shear, capacity M_w {st['Mw']/1e3:.1f} kN m")
    log("\n=== over the year: 59 positions x 9 wrenches (gravity + 8 wind directions) ===")
    I_F = M_HEAD*(4.0**2 + A**2/4)
    for tname, tset in TENDON_SETS.items():
        log(f"\n--- tendons: {tname} (pretension {T_MIN:.0f} N) ---")
        for r_s, p_bar in STEMS:
            stt = dict(fail9=0, fail25=0, Mb9=0, Mb25=0, t9=0, t25=0, b9=0, rot=0, kmin=np.inf, clr=np.inf, Lmax=0, clr_stem=np.inf, clr_tube=np.inf)
            for p in POS:
                for q, key, mk, tk in ((Q9, "fail9", "Mb9", "t9"), (Q25, "fail25", "Mb25", "t25")):
                    a = analyse(p, q, r_s, p_bar, tset)
                    for x in a["res"]:
                        if x is None: stt[key] += 1; continue
                        stt[mk] = max(stt[mk], stem_base_moment(x, a)); stt[tk] = max(stt[tk], x[:a["n"]].max())
                        if key == "fail9": stt["b9"] = max(stt["b9"], x[:4].max())
                    if key == "fail9":
                        stt["rot"] = max(stt["rot"], a["rot"]); stt["Lmax"] = max(stt["Lmax"], a["st"]["L"])
                        sv = p["s"]; e1 = np.cross(sv, [0, 0, 1.0]); e1 /= np.linalg.norm(e1); e2 = np.cross(sv, e1)
                        Ktt = a["K"][3:, 3:]; Kt = np.array([[e1@Ktt@e1, e1@Ktt@e2], [e2@Ktt@e1, e2@Ktt@e2]])
                        stt["kmin"] = min(stt["kmin"], np.linalg.eigvalsh(Kt).min())
                        sp = strip_points(p["s"])
                        for m in a["B"]: stt["clr"] = min(stt["clr"], seg_point_dist(m["P"], F, sp))
                        for m in a["T"]:
                            stt["clr_stem"] = min(stt["clr_stem"], seg_seg_dist(m["P"], m["W"], ROOTP, a["tip"]) - r_s)
                            stt["clr_tube"] = min(stt["clr_tube"], seg_seg_dist(m["P"], m["W"], np.array([1.25, 0, 5.0]), F) - 0.9)
            Mw = 0.5*np.pi*p_bar*1e5*r_s**3; EI = ET*np.pi*r_s**3
            Mwind9, Mwind25 = Q9*1.2*2*r_s*stt["Lmax"]**2/2, Q25*1.2*2*r_s*stt["Lmax"]**2/2
            log(f"stem r {r_s:.2f} m at {p_bar:.1f} bar (M_w {Mw/1e3:.1f} kN m, hoop {p_bar*1e5*r_s/1e3:.0f} kN/m): infeasible 9/25 m/s {stt['fail9']}/{stt['fail25']} of 531; "
                f"base moment needed {(stt['Mb9'] + Mwind9)/1e3:.1f} / {(stt['Mb25'] + Mwind25)/1e3:.1f} kN m incl. own drag -> SF {Mw/max(stt['Mb9'] + Mwind9, 1):.1f} / {Mw/max(stt['Mb25'] + Mwind25, 1):.1f}; "
                f"line max {stt['t9']/1e3:.1f} / {stt['t25']/1e3:.1f} kN; transverse pointing at 9 m/s {stt['rot']*1e3:.2f} mrad, K_transverse min {stt['kmin']/1e6:.2f} MN m/rad, mode {np.sqrt(max(stt['kmin'],1e-9)/I_F)/(2*np.pi):.1f} Hz; "
                f"vine curl for the 9 m/s shear {stt['Mb9']*stt['Lmax']**2/(3*EI)*1e3:.0f} mm; clearances: bridle-strip {stt['clr']:.2f}, tendon-stem {stt['clr_stem']:.2f}, tendon-tube {stt['clr_tube']:.2f} m")
    log("\n=== Hashemi's optics (paper figs 3-5) against the env ===")
    log(f"sphere R {R_SPH} -> focal circle radius R/2 = {R_SPH/2:.3f} m; env orbits at g {H.G_ORBIT} with f_nom 4.05: vertex {R_SPH/2 - H.G_ORBIT:.2f} m inside the focal circle, marginal-ray defocus blur {(R_SPH/2 - H.G_ORBIT)*A/(R_SPH/2)*1e3:.0f} mm radius at F")
    log("receiver at F on the focal tube through the slot (near method, fig 8B): the tube is the bore casing, r 0.45 above F2, 0.35 through the crossing band; it carries the strip and the bridle apex")
    open(os.path.join(OUT, "screw_checks.txt"), "w").write("\n".join(LOG))

if __name__ == "__main__":
    main()


# ---------------------------------------------------------------- Hopkins 2010, ch. 4 and Appendix B: the actuation space
def decompose_wrench(W):
    """Hopkins eq. 1.10-1.11: q = f.tau/f.f; location r with r x f = tau - q f (least-norm solution)."""
    f, tau = W[:3], W[3:]; ff = f @ f
    if ff < 1e-12: return None, None, np.inf
    q = (f @ tau)/ff; r = np.cross(f, tau - q*f)/ff
    return r, f/np.sqrt(ff), q

def actuation_space(p, r_s=0.8, p_bar=1.0, with_stem=True):
    """W_i = [K_TW] T_i for the three rotations about F (eq. 4.1/4.3): the actuation wrenches, decomposed."""
    B, T, tip = members(p)
    wB = np.array([wrench_F(m["P"], m["u"]) for m in B])
    K = sum(m["k"]*np.outer(w, w) for m, w in zip(B, wB))
    if with_stem: K = K + stem_element(tip, r_s, p_bar)["K_F"]
    out = []
    for ax in (np.array([1.0, 0, 0]), np.array([0, 1.0, 0]), np.array([0, 0, 1.0])):
        Tw = np.concatenate([np.zeros(3), ax])          # pairing [dx_F; dtheta]: a unit rotation about F along ax
        W = K @ Tw                                       # [f; tau_F]
        r, fhat, q = decompose_wrench(W)
        out.append(dict(axis=ax, W=W, r=r, f=fhat, q=q, mag=np.linalg.norm(W[:3])))
    return out, K, tip

def actuation_report(POS):
    log("\n=== actuation space (Hopkins 2010 ch. 4, eq. 4.1-4.3; his Fig. 4.2/4.6 is three wires converging on a point, our bridle) ===")
    p0 = [p for p in POS if p["season"] == "equinox" and abs(p["hour"] - 12) < 0.01][0]
    s = p0["s"]; V = p0["V"]
    for with_stem, label in ((False, "bridle alone (4 wires through F, EA 5 MN)"), (True, "bridle + stem r 0.8 at 1.0 bar")):
        out, K, tip = actuation_space(p0, with_stem=with_stem)
        log(f"-- {label}")
        for o in out:
            if o["r"] is None:
                log(f"   rotation about {o['axis']}: actuation wrench is a pure moment {np.round(o['W'][3:]/1e3, 1)} kN m/rad (q infinite)")
                continue
            d_axis = (o["r"] - F) @ (-s)                     # distance of the actuation line's point from F along the dish axis, toward the dish
            log(f"   rotation about {o['axis']}: force {o['mag']/1e3:.1f} kN/rad along {np.round(o['f'], 2)} through {np.round(o['r'], 2)}, q {o['q']:.2f} m; that point is {d_axis:.2f} m from F toward the dish (vertex at 4.0 m)")
    out, K, tip = actuation_space(p0, with_stem=False)
    ev, evec = np.linalg.eigh(K); log(f"   TWSM eigen-stiffnesses (bridle alone): {np.round(ev/1e6, 2)} MN/m or MN m/rad; the three zero ones are the rotations about F (eq. 4.12: eigenvectors are the collinear twist-wrench pairs)")
    # where do our actuators sit relative to that plane? stem tip (back ring) and outrigger attachments
    xl, yl, zl = dish_frame(s)
    d_tip = (tip - F) @ (-s); d_ring = (V + SAG*zl - F) @ (-s)
    log(f"   our actuator attachment points: stem tip {d_tip:.2f} m from F along the axis, outrigger ring {d_ring:.2f} m; the bridle's actuation plane (see above) is where a force turns the dish about F without translating F")
    # parasitic translation of F under the 9 m/s wind, from the full compliance (bridle + stem + tendons)
    a = analyse(p0, Q9, 0.8, 1.0)
    Cm = np.linalg.pinv(a["K"]); Wg = ext_wrenches(p0, Q9)[8]
    dx = max(np.linalg.norm((Cm @ (We - Wg))[:3]) for We in ext_wrenches(p0, Q9)[:8])
    log(f"   parasitic translation of F under the 9 m/s wind wrench: {dx*1e3:.1f} mm (the virtual pivot's own motion; the spot walks this much on the strip)")
    # force ratios (eq. 4.5) for a unit elevation twist with our actuators: stem shear at the tip (2 directions) + 4 tendons
    B, T, tip = members(p0); st = stem_element(tip, 0.8, 1.0)
    WA = np.column_stack([wrench_F(tip, st["ex"]), wrench_F(tip, st["ey"])] + [wrench_F(m["P"], m["u"]) for m in T])
    e_h = np.cross(s, [0, 0, 1.0]); e_h /= np.linalg.norm(e_h)               # elevation axis: horizontal, perpendicular to the meridian
    T_el = np.concatenate([np.zeros(3), e_h])*np.radians(1.0)
    Kfull = a["K"]
    mags = np.linalg.pinv(WA.T @ WA) @ WA.T @ (Kfull @ T_el)
    log(f"   eq. 4.5 force magnitudes for 1 deg of elevation about F with [stem shear x, stem shear y, tendon 1..4]: {np.round(mags, 0)} N (negative = the line must push, which a tendon cannot: the stem supplies it)")

if __name__ == "__main__":
    actuation_report(H.positions())
    open(os.path.join(OUT, "screw_checks.txt"), "a").write("\n".join(LOG[-14:]))

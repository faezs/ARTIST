#!/usr/bin/env python
"""Fifth pass, the flower: the exact hashemi.ini membrane on a crown that is a hexapod of six water-driven struts from a receptacle
ring at the top of a 1 m stem, F fixed on the light pipe. The machine erects itself by pumping the struts from a face-up stow to the
first pose on the orbit sphere, holds a calibration dither so that its own motion can be identified (DMDc, validated against
persistence), and tracks the day on the env's head law (hub 4 m from F, axis the bisector of the sun and the line to F, beta
within 36 deg) with the identified model closing the loop (LQR on the leg lengths), under the dish's drag and gusts.
Solver: the fourth pass's Gauss-Seidel XPBD kernels (rigid cliques, bilateral force-capped struts), no inflatables: the wind
sizing (../tree/wind_size.py) made the struts steel and the stem a column. Outputs: out/<tag>_log.json, out/<tag>_anim.json,
out/<tag>_ident.txt."""
import os, sys, json, base64, zlib, time, argparse, numpy as np
import warp as wp
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, os.path.join(HERE, "..", "tree"))
import physics_hp as H
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
ap = argparse.ArgumentParser(); ap.add_argument("--t_setup", type=float, default=30.0); ap.add_argument("--t_cal", type=float, default=20.0); ap.add_argument("--t_day", type=float, default=40.0)
ap.add_argument("--fps", type=int, default=30); ap.add_argument("--rec", type=int, default=3); ap.add_argument("--substeps", type=int, default=8); ap.add_argument("--iters", type=int, default=16)
ap.add_argument("--doy", type=int, default=80); ap.add_argument("--h0", type=float, default=9.0); ap.add_argument("--h1", type=float, default=15.0)
ap.add_argument("--wind", type=float, default=0.0, help="mean wind m/s from the north (-x)"); ap.add_argument("--gust", type=float, default=0.73, help="gust amplitude fraction: two sinusoids (4.0, 1.3 s); 0.73 gives peak q = 3 x mean")
ap.add_argument("--wind_from", default="N", help="N or S: the wind blows from the north onto the head's back, or from the south into the bowl"); ap.add_argument("--gust_model", default="karman", help="karman: von Karman spectrum, Iu and L_turb; sines: the two sinusoids"); ap.add_argument("--Iu", type=float, default=0.25); ap.add_argument("--L_turb", type=float, default=50.0)
ap.add_argument("--k_boom", type=float, default=2.0e5, help="lateral stiffness of pedicel + stem at the receptacle, N/m (219 x 8 boom of 3.2 m on the 215 x 9 stem)"); ap.add_argument("--m_rec", type=float, default=80.0, help="mass of the receptacle ring and boom tip, kg")
ap.add_argument("--n_zones", type=int, default=5); ap.add_argument("--T_mem", type=float, default=20e3, help="membrane tension N/m")
ap.add_argument("--cd", type=float, default=1.3); ap.add_argument("--cm", type=float, default=0.12); ap.add_argument("--no_lqr", action="store_true"); ap.add_argument("--schedule_only", action="store_true"); ap.add_argument("--tag", default="setup5"); ap.add_argument("--quiet", action="store_true")
A = ap.parse_args()
wp.config.quiet = True; wp.init(); DEV = "cpu"
# ------------------------------------------------------------------ the machine (deck at z 0 = env z 5.0; x north; F on the pipe)
G, RC, A_M, SAG = 4.0, 8.0, 2.1, 8.0 - np.sqrt(64 - 2.1**2)
Z_F = 0.35 + np.hypot(G, A_M); F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0])
S_REC, R_REC, R_PLAT, D_BACK, H_HEX = np.array([3.0, 0.0, 1.0]), 1.5, 1.0, 0.6, 1.2   # stem top; receptacle ring r 1.5 carried by the pedicel, coaxial with the head, H_HEX behind the platform ring r 1.0 (0.6 m behind the vertex)
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
A_DISH, D_DISH, RHO, R_HOLE = np.pi*(A_M**2 - 0.5**2), 4.2, 1.03, 0.5
KE_RIG, KE_LEG, F_LEG_MAX = 2.0e7, 2.0e7, 1.0e6                    # the legs and the head's truss at one stiffness the solver converges (a 3 kN leg load = 0.15 mm); the steel legs' EA/L is 1e8
M_HEAD = 130.0
BETA_MAX = 36.0
def sun(hour): el, Az, s = H.sun(A.doy, hour); return float(el), float(Az), np.asarray(s, float)
def head_axes(n):
    """in-plane frame of the head: x_l = the direction toward the pipe (-x) projected on the head's plane, the same reference the receptacle uses, so the legs never cross"""
    ref = np.array([-1.0, 0, 0]); xl = ref - n*(ref@n)
    if np.linalg.norm(xl) < 1e-6: xl = np.array([0, 1.0, 0]) - n*n[1]
    xl /= np.linalg.norm(xl); yl = np.cross(n, xl); return xl, yl, n
def head_points(P, n):
    """the head's particles for a pose: platform joints, vertex, rim (8), two calyx points"""
    xl, yl, zl = head_axes(n); Cp = P - D_BACK*n
    plat = [Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG]
    rim = [P + A_M*(np.cos(a)*xl + np.sin(a)*yl) + SAG*n for a in 2*np.pi*np.arange(8)/8]
    return plat, [P], rim, [Cp, P - 0.3*n]
def base_joints(P, n):
    """the receptacle ring on the pedicel: coaxial with the head, H_HEX behind the platform ring; the pedicel (slew + luff from the stem top) places it"""
    xl, yl, zl = head_axes(n); Cb = P - (D_BACK + H_HEX)*n
    return [Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG]
def leg_lengths(P, n, B=None):
    B = base_joints(P, n) if B is None else B; plat = head_points(P, n)[0]; return np.array([np.linalg.norm(plat[j] - B[j]) for j in range(6)])
def image_miss(P, n, s):
    """chief ray from the vertex: incoming -s reflected about n; its miss distance from F, and the defocus |P - F| - g"""
    r = -s + 2*(s@n)*n; d = F - P; miss = np.linalg.norm(d - (d@r)*r); return miss, np.linalg.norm(d) - G
def jacobian(P, n, B=None):
    """d(leg length)/d(dP, dtheta): rows = legs; the hexapod's inverse Jacobian"""
    B = base_joints(P, n) if B is None else B; plat = head_points(P, n)[0]; J = np.zeros((6, 6))
    for j in range(6):
        u = plat[j] - B[j]; L = np.linalg.norm(u); u /= L; J[j, :3] = u; J[j, 3:] = np.cross(plat[j] - P, u)
    return J
# ---- the schedule: the env's head law with the pose chosen on the reachable part of the orbit sphere (path.py's rule)
import path as PT
PT.REACH = (1.0, 4.2); PT.RIM_CAP = 9.9; PT.BETA_MAX = BETA_MAX      # the pedicel's reach from the stem top to the hub
def pose_ok(P_, n_):
    Cb = P_ - (D_BACK + H_HEX)*n_; return Cb[2] >= 0.8 and 1.0 <= np.linalg.norm(Cb - S_REC) <= 3.8          # the receptacle above the deck and within the pedicel's boom
PT.LEG_CHECK = pose_ok
def schedule():
    hours = np.arange(A.h0, A.h1 + 1e-6, 0.25); poses = []
    P_prev = None
    for hr in hours:
        el, Az, s = sun(hr); b = PT.best_pose(s, S_REC, w_move=0.3, P_prev=P_prev)
        if b is not None: P_prev = b[2]
        if b is None: poses.append(None); continue
        cost, n, P, ev = b; poses.append((P, n, ev["beta"], ev["shadow"]))
    # fill unreachable hours by holding the nearest reachable pose
    idx = [i for i, p in enumerate(poses) if p is not None]
    assert idx, "no reachable pose in the day"
    for i in range(len(poses)):
        if poses[i] is None: poses[i] = poses[min(idx, key=lambda k: abs(k - i))]
    return hours, poses
t0w = time.time(); HOURS, POSES = schedule(); print(f"schedule: {len(HOURS)} poses, beta {min(p[2] for p in POSES):.0f}-{max(p[2] for p in POSES):.0f} deg, shadow {100*np.mean([p[3] for p in POSES]):.1f} % mean ({time.time() - t0w:.0f} s)")
def pose_at(hour):
    i = np.clip(np.searchsorted(HOURS, hour) - 1, 0, len(HOURS) - 2); w = np.clip((hour - HOURS[i])/(HOURS[i + 1] - HOURS[i]), 0, 1)
    P = (1 - w)*POSES[i][0] + w*POSES[i + 1][0]; n = (1 - w)*POSES[i][1] + w*POSES[i + 1][1]; n /= np.linalg.norm(n); return P, n
P_STOW, N_STOW = S_REC + np.array([0, 0, D_BACK + H_HEX]), Z.copy()  # the stow: the receptacle horizontal at the stem top, the head face-up at the hexapod's nominal height
if A.schedule_only:
    print("hour  hub (x y z over deck)   el_n  beta  cond  legs  jump"); prev = None
    for h, p in zip(HOURS, POSES):
        P_, n_, beta_, sh_ = p; L_ = leg_lengths(P_, n_); c_ = np.linalg.cond(jacobian(P_, n_))
        print(f"{h:5.2f}  {np.round(P_ - [0, 0, 5.0], 2)}  {np.degrees(np.arcsin(n_[2])):4.0f}  {beta_:4.0f}  {c_:5.1f}  {L_.min():.2f}-{L_.max():.2f}  {0 if prev is None else np.linalg.norm(P_ - prev):.2f} m"); prev = P_
    worst = []
    for i in range(len(HOURS) - 1):
        for w_ in np.linspace(0, 1, 11):
            P_ = (1 - w_)*POSES[i][0] + w_*POSES[i + 1][0]; n_ = (1 - w_)*POSES[i][1] + w_*POSES[i + 1][1]; n_ /= np.linalg.norm(n_)
            worst.append((round(float(np.linalg.cond(jacobian(P_, n_))), 1), round(float(HOURS[i] + w_*0.25), 2), round(float(leg_lengths(P_, n_).min()), 2)))
    worst.sort(reverse=True); print("worst conditioning along the interpolated path (cond, hour, min leg):", worst[:8]); sys.exit(0)
# ------------------------------------------------------------------ particles and constraints
Pts, Mass, Pin = [], [], []
def add(p, m, pin=False): Pts.append(np.asarray(p, float)); Mass.append(m); Pin.append(pin); return len(Pts) - 1
S = []
def spring(i, j, kind, ke): S.append((int(i), int(j), kind, ke))
def clique(ids, ke=KE_RIG):
    for a in range(len(ids)):
        for b_ in range(a + 1, len(ids)): spring(ids[a], ids[b_], 2, ke)
BASE0 = base_joints(P_STOW, N_STOW); BJ = [add(b, A.m_rec/7, pin=False) for b in BASE0]; RC_C = add(np.mean(BASE0, 0), A.m_rec/7)
clique(BJ + [RC_C])                                                     # the receptacle ring is rigid
GH_OFF = 0.25; AXES = [np.array([GH_OFF, 0, 0]), np.array([0, GH_OFF, 0]), np.array([0, 0, GH_OFF])]
GH = [[add(b + o, 0.0, pin=True) for o in AXES] for b in BASE0]         # pinned ghosts at the boom's commanded position: a bushing per joint
KE_GH = A.k_boom/6.0
for j in range(6):
    for g in GH[j]: spring(g, BJ[j], 6, KE_GH)
plat0, vtx0, rim0, cal0 = head_points(P_STOW, N_STOW)
m_pt = M_HEAD/(6 + 1 + 8 + 2)
PJ = [add(p, m_pt) for p in plat0]; VTX = add(vtx0[0], m_pt); RIM = [add(p, m_pt) for p in rim0]; CAL = [add(p, m_pt) for p in cal0]
HEAD = PJ + [VTX] + RIM + CAL; clique(HEAD)
LEGS = [(BJ[j], PJ[j]) for j in range(6)]
for a_, b_ in LEGS: spring(a_, b_, 6, KE_LEG)
GH_K = [[None]*3 for _ in range(6)]
FP = add(F, 0.0, pin=True)
X0 = np.array(Pts); n = len(Pts); inv_m = np.array([0.0 if m == 0 else 1.0/m for m in Mass]); pinned = np.array(Pin)
S = np.array(S, float); idx = S[:, :2].astype(np.int32); kind = S[:, 2].astype(int); ke_s = S[:, 3]
nominal0 = np.linalg.norm(X0[idx[:, 0]] - X0[idx[:, 1]], axis=1); n_spr = len(S)
uni = np.zeros(n_spr, np.int32)
col = -np.ones(n_spr, int); used = [set() for _ in range(n)]
for s_i in np.argsort(-ke_s, kind="stable"):
    i_, j_ = idx[s_i]; c = 0
    while c in used[i_] or c in used[j_]: c += 1
    col[s_i] = c; used[i_].add(c); used[j_].add(c)
n_col = int(col.max()) + 1; colour_ids = [np.where(col == c)[0].astype(np.int32) for c in range(n_col)]
LEG_K = [int(np.where((idx[:, 0] == a_) & (idx[:, 1] == b_))[0][0]) for a_, b_ in LEGS]
# ------------------------------------------------------------------ warp
def wa(a, dt): return wp.array(a, dtype=dt, device=DEV)
x = wa(X0.astype(np.float32), wp.vec3); v = wa(np.zeros((n, 3), np.float32), wp.vec3); xp = wa(X0.astype(np.float32), wp.vec3)
fext = wa(np.zeros((n, 3), np.float32), wp.vec3); w = wa(inv_m.astype(np.float32), float)
sidx = wa(idx.reshape(-1), wp.int32); rest = wa(nominal0.astype(np.float32), float); kew = wa(ke_s.astype(np.float32), float)
lam = wa(np.zeros(n_spr, np.float32), float); uniw = wa(uni, wp.int32)
fmax_np = np.where(kind == 6, F_LEG_MAX, 1e30).astype(np.float32); fmax = wa(fmax_np, float)
GH_FLAT = [g for row in GH for g in row]; GH_OFFS = np.array([o for _ in range(6) for o in AXES]); colw = [wa(c, wp.int32) for c in colour_ids]
@wp.kernel
def predict(x: wp.array(dtype=wp.vec3), v: wp.array(dtype=wp.vec3), fe: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), g: wp.vec3, dt: float, damp: float, xp: wp.array(dtype=wp.vec3)):
    i = wp.tid()
    if w[i] == 0.0:
        xp[i] = x[i]; return
    vi = (v[i] + (fe[i]*w[i] + g)*dt)*damp
    v[i] = vi; xp[i] = x[i] + vi*dt
@wp.kernel
def springs(ids: wp.array(dtype=wp.int32), xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), idx: wp.array(dtype=wp.int32), rest: wp.array(dtype=float), ke: wp.array(dtype=float),
            uni: wp.array(dtype=wp.int32), fmax: wp.array(dtype=float), lam: wp.array(dtype=float), dt: float):
    s = ids[wp.tid()]; i = idx[2*s]; j = idx[2*s + 1]
    d = xp[i] - xp[j]; L = wp.length(d)
    if L < 1e-9: return
    c = L - rest[s]
    nrm = d/L; wi = w[i]; wj = w[j]; den = wi + wj
    if den == 0.0: return
    alpha = 1.0/(ke[s]*dt*dt)
    dl = -(c + alpha*lam[s])/(den + alpha)
    lnew = lam[s] + dl; lmin = -fmax[s]*dt*dt; lmax = fmax[s]*dt*dt
    if lnew < lmin: lnew = lmin
    if lnew > lmax: lnew = lmax
    dl = lnew - lam[s]; lam[s] = lnew
    if wi > 0.0: xp[i] = xp[i] + nrm*(wi*dl)
    if wj > 0.0: xp[j] = xp[j] - nrm*(wj*dl)
@wp.kernel
def ground(xp: wp.array(dtype=wp.vec3), r: float):
    i = wp.tid(); q = xp[i]
    if q[2] < r: xp[i] = wp.vec3(q[0], q[1], r)
@wp.kernel
def finish(x: wp.array(dtype=wp.vec3), xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), dt: float, v: wp.array(dtype=wp.vec3)):
    i = wp.tid()
    if w[i] == 0.0: return
    v[i] = (xp[i] - x[i])/dt; x[i] = xp[i]
# ------------------------------------------------------------------ wind on the head (drag along the wind, pitching moment about the hub; gusts)
def karman_series(U, Iu, Lt, T_total, fps, seed=7):
    """along-wind speed from the von Karman spectrum, S(f) = sigma^2 (4 L/U) / (1 + 70.8 (f L/U)^2)^(5/6), synthesised with random phases"""
    rng_ = np.random.default_rng(seed); f = np.linspace(0.01, 3.0, 300); df = f[1] - f[0]; sig = Iu*U
    S = sig*sig*(4*Lt/U)/(1 + 70.8*(f*Lt/U)**2)**(5/6); amp = np.sqrt(2*S*df); ph = rng_.uniform(0, 2*np.pi, len(f))
    t = np.arange(0, T_total + 1.0/fps, 1.0/fps); v = U + (amp[None, :]*np.cos(2*np.pi*f[None, :]*t[:, None] + ph[None, :])).sum(1)
    return t, np.maximum(v, 0.0)
WIND_T, WIND_V = (karman_series(A.wind, A.Iu, A.L_turb, A.t_setup + A.t_cal + A.t_day, A.fps) if (A.wind > 0 and A.gust_model == "karman") else (None, None))
def wind_now(t):
    if A.wind <= 0 or t < A.t_setup: return 0.0
    if A.gust_model == "karman": return float(np.interp(t, WIND_T, WIND_V))
    return A.wind*(1.0 + A.gust*(0.6*np.sin(2*np.pi*t/4.0) + 0.4*np.sin(2*np.pi*t/1.3 + 1.0)))
def dish_load(q, vw):
    Fv = np.zeros((n, 3))
    if vw <= 0: return Fv, 0.0, 0.0
    what = np.array([-1.0, 0, 0]) if A.wind_from == "N" else np.array([1.0, 0, 0]); qd = 0.5*RHO*vw*vw
    nd = head_normal(q); ca = float(nd@what); into_bowl = ca < 0                                             # the wind travels along what; it enters the bowl when it opposes the normal
    cd_n = 1.40 if into_bowl else 1.05; cd = 0.25 + (cd_n - 0.25)*ca*ca; Fd = qd*A_DISH*cd
    pts = RIM + [VTX]; Fv[pts] += Fd*what/len(pts)
    nperp = nd - (nd@what)*what; npn = np.linalg.norm(nperp)
    if npn > 1e-6: Fv[pts] += (qd*A_DISH*(0.5 if into_bowl else 0.4)*abs(2*ca*np.sqrt(max(1 - ca*ca, 0.0))))*(nperp/npn)*(1.0 if into_bowl else -1.0)/len(pts)   # lift, C_L ~ 0.5 sin 2 alpha, toward the convex side
    weff = what if ca >= 0 else -what; ax = np.cross(nd, weff); sa = np.linalg.norm(ax); Mv = np.zeros(3)
    if sa > 1e-6:
        Mv = ax/sa*qd*A_DISH*D_DISH*(0.15 if into_bowl else 0.10)*2*abs(ca)*sa; c_d = q[RIM].mean(0); r = q[RIM] - c_d; Sm = 0.5*np.sum(np.linalg.norm(r, axis=1)**2); Fv[RIM] += np.cross(Mv, r)/Sm
    return Fv, Fd, float(np.linalg.norm(Mv))
def head_normal(q):
    nd = np.cross(q[RIM[2]] - q[RIM[0]], q[RIM[4]] - q[RIM[0]]); nd /= np.linalg.norm(nd)
    if nd@(q[VTX] - q[RIM].mean(0)) < 0: nd = -nd                       # the vertex is behind the rim plane (concave toward +n): the normal points out of the bowl
    return -nd if nd@(q[CAL[1]] - q[VTX]) > 0 else nd
def head_pose(q):
    nd = head_normal(q); return q[VTX].copy(), nd
def pose_error(q, P_t, n_t):
    """(dP, dtheta) of the head relative to the target, in world axes"""
    P, nd = head_pose(q); dth = np.cross(n_t, nd); return np.concatenate([P - P_t, dth])          # actual minus target, both parts
# ------------------------------------------------------------------ run
T_S, T_C = A.t_setup, A.t_cal; T_TOTAL = T_S + T_C + A.t_day; dt_f = 1.0/A.fps; dt = dt_f/A.substeps; damp = float(np.exp(-2.0*dt)); GRAV = wp.vec3(0.0, 0.0, -9.81)
def smooth(u): return u*u*(3 - 2*u)
def ramp(t, t0, t1): return float(np.clip((t - t0)/(t1 - t0), 0.0, 1.0))
rng = np.random.default_rng(3); dither = np.zeros(6); dither_target = np.zeros(6); u_fb = np.zeros(6); Kgain = None; ident = {}; ctrl_name = 'feedforward only'
L_stow = nominal0[LEG_K].copy(); P1, n1 = pose_at(A.h0); L_first = leg_lengths(P1, n1)
frames, log, cal = [], [], []
n_frames = int(round(T_TOTAL*A.fps)); t0 = time.time()
for fr in range(n_frames + 1):
    t = fr*dt_f
    if t < T_S + T_C: hour = A.h0
    else: hour = A.h0 + (A.h1 - A.h0)*(t - T_S - T_C)/A.t_day
    el, Az, s = sun(hour); q = x.numpy().astype(float)
    # target pose and feedforward leg lengths
    if t < T_S:
        u_ = smooth(ramp(t, 0.05*T_S, 0.95*T_S)); P_t = (1 - u_)*P_STOW + u_*P1; n_t = (1 - u_)*N_STOW + u_*n1; n_t /= np.linalg.norm(n_t)
    else: P_t, n_t = pose_at(hour)
    L_ff = leg_lengths(P_t, n_t)
    # calibration dither (PRBS-like, +-8 mm, held 0.5 s) and identification at the end of the calibration
    if T_S <= t < T_S + T_C:
        if int(t/0.5) != int((t - dt_f)/0.5): dither_target = rng.choice([-1.0, 1.0], 6)*0.002
        dither = dither + (dither_target - dither)*(dt_f/0.3)                                     # +-3 mm, first-order smoothed (0.3 s)
    else: dither = dither*(1 - dt_f/0.3)
    if abs(t - (T_S + T_C)) < 0.5*dt_f and cal and not A.no_lqr:
        X = np.array([c[0] for c in cal]); U = np.array([c[1] for c in cal]); dU = np.diff(U, axis=0); dX = np.diff(X, axis=0)
        # DMDc in velocity form with three input lags (a time-delay embedding of the command), ridge-regularised, on the pose rows only (the command rows are
        # known): dX_k = B0 dU_k + B1 dU_k-1 + B2 dU_k-2; the static gain is B0 + B1 + B2, the pose's settled response to a command increment; 30 % hold-out vs persistence
        NL = 3; Phi = np.hstack([dU[NL - 1 - j: len(dU) - j] for j in range(NL)]); Y = dX[NL - 1:]; ntr = int(0.7*len(Y))
        lam = 1e-3*np.trace(Phi[:ntr].T@Phi[:ntr])/Phi.shape[1]
        M = np.linalg.solve(Phi[:ntr].T@Phi[:ntr] + lam*np.eye(Phi.shape[1]), Phi[:ntr].T@Y[:ntr]).T
        pred = Phi[ntr:]@M.T; e_m = np.sqrt(np.mean((pred - Y[ntr:])**2, 0)); e_p = np.sqrt(np.mean(Y[ntr:]**2, 0))
        skill = 1 - np.mean(e_m/np.maximum(e_p, 1e-9))
        Gid = sum(M[:, 6*j:6*(j + 1)] for j in range(NL))                                    # identified pose change per unit leg increment (6 x 6)
        Jan = np.linalg.inv(jacobian(P_t, n_t))                                             # the analytic inverse Jacobian for comparison
        rel = np.linalg.norm(Gid - Jan)/np.linalg.norm(Jan)
        if skill >= 0.5 and rel < 0.5: Kgain = np.linalg.pinv(Gid); ctrl_name = f'integral loop through the IDENTIFIED gain (skill {skill:.2f}, {100*rel:.0f} % from the analytic Jacobian)'
        else: Kgain = None; ctrl_name = f'integral loop through the analytic Jacobian (identified gain skill {skill:.2f}, {100*rel:.0f} % off)'
        print(ctrl_name)
        ident = dict(n_train=int(ntr), n_test=int(len(Y) - ntr), rms_model=e_m.tolist(), rms_persist=e_p.tolist(), skill=float(skill), gain_rel_err=float(rel), controller=ctrl_name)
        print(f"identified at t {t:.1f}: DMDc one-step test RMS (dP mm, dtheta mrad) {np.round(e_m[:3]*1e3, 2)} {np.round(e_m[3:]*1e3, 2)} vs persistence {np.round(e_p[:3]*1e3, 2)} {np.round(e_p[3:]*1e3, 2)}")
    err = pose_error(q, P_t, n_t) if t >= T_S else np.zeros(6)
    if t >= T_S + T_C and not A.no_lqr:
        Ginv = Kgain if Kgain is not None else jacobian(P_t, n_t)
        u_fb = np.clip(u_fb + np.clip(-1.5*dt_f*(Ginv@err), -0.003, 0.003), -0.04, 0.04)                                  # integral on the pose error, 3 mm per frame at most
    B_t = base_joints(P_t, n_t); xn = x.numpy(); xn[GH_FLAT] = (np.repeat(np.array(B_t), 3, axis=0) + GH_OFFS).astype(np.float32); x.assign(xn)   # the pedicel's command: the ghosts move, the ring follows through the boom's stiffness
    L_cmd = L_ff + dither + u_fb
    nom = nominal0.copy()
    for j, k_ in enumerate(LEG_K): nom[k_] = L_cmd[j]
    rest.assign(nom.astype(np.float32))
    vw = wind_now(t); Fw, F_dish, M_dish = dish_load(q, vw); fext.assign(Fw.astype(np.float32))
    for k in range(A.substeps):
        lam.zero_()
        wp.launch(predict, dim=n, inputs=[x, v, fext, w, GRAV, dt, damp, xp], device=DEV)
        for it in range(A.iters):
            for cw_ in colw: wp.launch(springs, dim=len(cw_), inputs=[cw_, xp, w, sidx, rest, kew, uniw, fmax, lam, dt], device=DEV)
            wp.launch(ground, dim=n, inputs=[xp, 0.05], device=DEV)
        wp.launch(finish, dim=n, inputs=[x, xp, w, dt, v], device=DEV)
    q = x.numpy().astype(float)
    if not np.isfinite(q).all(): print("NaN at frame", fr); break
    P, nd = head_pose(q); miss, defoc = image_miss(P, nd, s)
    slope_mem = 5.89e-3*(vw/9.0)**2*(20e3/A.T_mem)/A.n_zones if vw > 0 else 0.0                                # rad, the antisymmetric wind mode of the membrane
    miss_mem = 2*slope_mem*G; miss_tot = np.hypot(miss, miss_mem)                                            # a slope error tilts the beam by twice itself; 4 m to F
    rec_err = float(np.linalg.norm(q[BJ].mean(0) - np.mean(B_t, 0)))                                         # the receptacle's departure from the pedicel's command
    L_now = np.array([np.linalg.norm(q[b_] - q[a_]) for a_, b_ in LEGS]); f_leg = lam.numpy()[LEG_K]/(dt*dt)          # the constraint force: the multiplier of the last substep (positive = tension)
    if T_S <= t < T_S + T_C: cal.append((pose_error(q, P_t, n_t), dither + u_fb))
    beta = float(np.degrees(np.arccos(np.clip(((F - P)/np.linalg.norm(F - P))@s, -1, 1))))
    if fr % A.rec == 0:
        frames.append(np.round(q*100).astype(np.int16))
        Cb = P_t - (D_BACK + H_HEX)*n_t; boom = Cb - S_REC
        log.append(dict(t=round(t, 2), hour=round(hour, 3), wind=round(vw, 2), miss_cm=round(100*miss, 2), miss_mem_cm=round(100*miss_mem, 2), miss_tot_cm=round(100*miss_tot, 2), rec_err_cm=round(100*rec_err, 2), boom_m=round(float(np.linalg.norm(boom)), 3), boom_el=round(float(np.degrees(np.arcsin(boom[2]/max(np.linalg.norm(boom), 1e-9)))), 1), boom_az=round(float(np.degrees(np.arctan2(boom[1], boom[0]))), 1), defocus_cm=round(100*defoc, 2), beta=round(beta, 1), legs_m=[round(float(l_), 3) for l_ in L_now], f_leg_kN=[round(float(f_)/1e3, 2) for f_ in f_leg],
                        err=[round(float(e_), 4) for e_ in err], u_fb_mm=[round(1e3*float(u_), 2) for u_ in u_fb], f_dish=round(F_dish), m_dish=round(M_dish), P=[round(float(c), 3) for c in P], n=[round(float(c), 4) for c in nd]))
    if not A.quiet and fr % (A.fps*2) == 0:
        print(f"t {t:5.1f} h {hour:5.2f} wind {vw:4.1f} | miss at F {100*miss:5.1f} cm (+membrane {100*miss_mem:4.1f} -> {100*miss_tot:5.1f}) receptacle off {100*rec_err:4.1f} cm defocus {100*defoc:+5.1f} cm beta {beta:4.1f} | legs {np.round(L_now, 2)} m forces {np.round(f_leg/1e3, 1)} kN | hub {np.round(P, 2)} el_n {np.degrees(np.arcsin(nd[2])):4.0f} ({time.time() - t0:.0f} s)")
# ------------------------------------------------------------------ outputs
Qf = np.stack(frames); blob = base64.b64encode(zlib.compress(Qf.tobytes(), 9)).decode()
anim = dict(n_frames=int(Qf.shape[0]), n_particles=int(Qf.shape[1]), dt=A.rec/A.fps, scale=0.01, z_offset=H.Z_DECK, blob=blob, legs=[list(p) for p in LEGS], rim=RIM, vtx=VTX, plat=PJ, base=BJ, F=FP,
            receptacle=dict(c=S_REC.tolist(), r=R_REC), stem_top=S_REC.tolist(), pipe=dict(c=[0.0, 0.0], r=0.42, z_top=float(Z_F)), t_setup=T_S, t_cal=T_C, t_day=A.t_day, h0=A.h0, h1=A.h1, wind=A.wind, log=log, ident=ident)
json.dump(anim, open(os.path.join(OUT, A.tag + "_anim.json"), "w"), separators=(",", ":")); json.dump(log, open(os.path.join(OUT, A.tag + "_log.json"), "w"))
ts = np.array([l["t"] for l in log]); miss = np.array([l["miss_cm"] for l in log]); mtot = np.array([l["miss_tot_cm"] for l in log]); mmem = np.array([l["miss_mem_cm"] for l in log]); rerr = np.array([l["rec_err_cm"] for l in log]); wv = np.array([l["wind"] for l in log]); day = ts >= T_S + T_C; calm = (ts >= T_S) & (ts < T_S + T_C); setup = ts < T_S
fmax_leg = max(max(abs(f_) for f_ in l["f_leg_kN"]) for l in log if l["t"] >= T_S)
lines = [f"fifth pass, {A.tag}: wind {A.wind} m/s mean from the {A.wind_from} (gust {A.gust}: peak q = {(1 + A.gust)**2:.1f} x mean), sun {A.h0}-{A.h1} h in {A.t_day} s; setup {T_S} s, calibration {T_C} s",
         f"setup: the head rises from the stow (hub {P_STOW[2]:.2f} m up, face up) to the first pose by pumping the legs {np.round(L_stow, 2)} -> {np.round(L_first, 2)} m; miss at F at the end of setup {miss[setup][-1]:.1f} cm",
         f"calibration (dither +-2 mm per leg, smoothed): miss at F mean {miss[calm].mean():.1f} cm, max {miss[calm].max():.1f}" + (f"; DMDc one-step test RMS dP {np.round(np.array(ident['rms_model'][:3])*1e3, 2)} mm, dtheta {np.round(np.array(ident['rms_model'][3:])*1e3, 2)} mrad vs persistence {np.round(np.array(ident['rms_persist'][:3])*1e3, 2)} mm, {np.round(np.array(ident['rms_persist'][3:])*1e3, 2)} mrad" if ident else ""),
         f"the day ({'feedforward only' if A.no_lqr else ctrl_name}): geometric miss at F mean {miss[day].mean():.1f} cm, max {miss[day].max():.1f} cm; with the membrane's own figure ({A.n_zones} zones, T {A.T_mem/1e3:.0f} kN/m: {mmem[day].mean():.1f} cm mean, {mmem[day].max():.1f} max) total {mtot[day].mean():.1f} cm mean, {mtot[day].max():.1f} max (half power 4.9); receptacle off its command {rerr[day].mean():.1f} cm mean, {rerr[day].max():.1f} max (k_boom {A.k_boom/1e3:.0f} kN/m); wind {A.gust_model}: mean {wv[day].mean():.1f}, sigma {wv[day].std():.1f}, peak {wv[day].max():.1f} m/s; beta {min(l['beta'] for l in log if l['t'] >= T_S + T_C):.0f}-{max(l['beta'] for l in log if l['t'] >= T_S + T_C):.0f} deg; leg force max {fmax_leg:.1f} kN; leg lengths {min(min(l['legs_m']) for l in log):.2f}-{max(max(l['legs_m']) for l in log):.2f} m; pedicel boom {min(l['boom_m'] for l in log):.2f}-{max(l['boom_m'] for l in log):.2f} m, elevation {min(l['boom_el'] for l in log):.0f}-{max(l['boom_el'] for l in log):.0f} deg, azimuth {min(l['boom_az'] for l in log):.0f}-{max(l['boom_az'] for l in log):.0f} deg; wind peak {max(l['wind'] for l in log):.1f} m/s, dish force max {max(l['f_dish'] for l in log)/1e3:.2f} kN"]
print("\n".join(lines)); open(os.path.join(OUT, A.tag + "_ident.txt"), "w").write("\n".join(lines) + "\n")

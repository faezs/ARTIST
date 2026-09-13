#!/usr/bin/env python
"""The machine sets itself up, fourth-pass geometry: everything behind the dish. A 3-D soft-body simulation in NVIDIA Warp kernels.

Fourth pass (this file): one inflatable stalk on the deck grows to the neck height and carries the yoke (M4, the hollow pivot's
axis points, the jack anchor, the counterweight hose beyond the stalk); the head (M3 at the neck, crank, back frame, rod posts,
column feet, the counterweight hose behind the neck) hinges on the yoke about the neck axis; the dish (back ring, column heads,
vertex, rim, the secondary on its style) sits on the fine stage. The deck ring turns the stalk's base for the azimuth; the jack
sets the elevation; water pumped into the two hoses balances the head about the neck and the yoke about the stalk (their
masses come from the built moment balance, printed at the start). The paragraphs below describe the third pass's solver
and sequence, which this file keeps.

The frame is the hose. Two inflatable posts on the deck ring, an inflatable arm and an inflatable counterweight tube
per side on the cradle, all closed fabric tubes: triangle-mesh membranes of tension-only XPBD constraints, inflated by
a pressure kernel (p A n / 3 on every wall and cap triangle) and grown like everting vine robots by lengthening the
axial rest lengths from stubs. The trunnion blocks (the FACT cross-blade pivots, exact 1R) are hinges between the
post tops and the cradle: two shared points on the elevation axis through F. Pneumatic muscles (pull-only springs)
between each post top and a crank on the cradle set the elevation; the deck ring (kinematic here) sets the azimuth;
water pumped into the tanks at the counterweight tubes' ends balances the cradle about the axis. The head (frame,
dish rim, vertex) is a stiff spring truss on the arms' tip caps and points where the arms point, so the dish's attitude
follows from the rotation about the axis through F, as in the FACT mount.

Sequence from the stow (posts short, cradle face-up on its stubs, tanks empty): inflate; posts grow until the axis is at
F's height; arms and counterweight tubes grow; tanks fill; the muscles rotate the cradle down to the morning sun; then
the day. Deck at z = 0 (env z 5.0); gravity on; time compressed: the pump's minutes are the sim's seconds.

Solver: averaged-Jacobi XPBD (Macklin et al. 2016) with long-range attachments for the tubes, in Warp kernels
(warp.sim's XPBD sums Jacobi deltas without normalising by valence and diverges on stiff dense nets).

Outputs: out/setup_anim.json (frames for the register's viewer), out/setup_log.json (controller and load traces).
"""
import os, sys, json, base64, zlib, time, argparse, numpy as np
import warp as wp
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, os.path.join(HERE, "..", "fact_mount"))
import physics_hp as H
import geometry as GM
OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
ap = argparse.ArgumentParser(); ap.add_argument("--t_setup", type=float, default=40.0); ap.add_argument("--t_day", type=float, default=40.0)
ap.add_argument("--fps", type=int, default=30); ap.add_argument("--rec", type=int, default=3); ap.add_argument("--substeps", type=int, default=16); ap.add_argument("--iters", type=int, default=12)
ap.add_argument("--doy", type=int, default=80); ap.add_argument("--h0", type=float, default=8.0); ap.add_argument("--h1", type=float, default=16.0); ap.add_argument("--quiet", action="store_true")
ap.add_argument("--p_max", type=float, default=40e3); ap.add_argument("--wind", type=float, default=0.0, help="mean wind m/s from the north (-x) after setup")
ap.add_argument("--gust", type=float, default=0.35, help="gust amplitude as a fraction of the mean (two sinusoids, 4.0 and 1.3 s periods, in the structure's real seconds)")
ap.add_argument("--cd", type=float, default=1.3, help="dish drag coefficient face-on (Peterka & Derickson 1992 order); edge-on 0.25")
ap.add_argument("--cm", type=float, default=0.12, help="dish pitching-moment coefficient amplitude, M = q A D cm sin 2 alpha about the dish centre")
ap.add_argument("--tag", default="setup4", help="output file stem")
A = ap.parse_args()
wp.config.quiet = True; wp.init(); DEV = "cpu"
# ------------------------------------------------------------------ geometry (metres; sim frame = env frame with the deck at z 0)
import json as _json
OPT = _json.load(open(os.path.join(HERE, "..", "coude", "out", "optics.json")))
NECK, OFF, Z_NECK = OPT["NECK"], OPT["OFF"], OPT["z_neck"] - H.Z_DECK            # neck 1.8 m behind the vertex, stalk 1.4 m beside the dish axis, neck 1.94 m over the deck
D_SEC, R_SEC = OPT["D_SEC"], OPT["r_sec"]
S_XY = np.array([1.25, 0.0, 0.0]); Z = np.array([0, 0, 1.0])
R_STALK, L_STALK, STUB_STALK = 0.50, Z_NECK - 0.45, 0.50                        # the stalk: one tube from the deck to the yoke
R_CW, L_CW1, L_CW2, STUB = 0.35, 1.20, 2.00, 0.30                                # counterweight hoses: behind the neck (base 0.4 m behind N, tip 0.34 m over the deck at the stow), beyond the stalk (base 0.4 m from Q)
M_CW1, M_CW2 = 200.0, 136.0                                                      # placeholders: set below from the moment balance about the neck and about the stalk
N_C, N_ST, N_CW = 12, 8, 6
P_MAX = A.p_max; M_PART = 0.15
KE_FAB, KE_RIG, KE_MUS = 1.5e6, 6.0e6, 1.0e6
F_MUS_MAX = 15e3                                  # the screw jack: stiff (1 MN/m), force-capped; the third pass's 50 kN/m was a pneumatic muscle
R_FRAME, R_RIM = GM.R_FRAME, 2.16
def sun(hour): return H.sun(A.doy, hour)
def frame_of(hour):
    el, Az, s = sun(hour); s_, h, e, n = GM.frame(el, Az); return el, Az, s, h, e, n
el_, Az_, s_sun, h0, e0, n0 = frame_of(A.h0)
Fxy = S_XY.copy()
P, Mass, Pin = [], [], []
def add(p, m, pin=False): P.append(np.asarray(p, float)); Mass.append(m); Pin.append(pin); return len(P) - 1
S = []     # (i, j, kind, ke): kind 0 tube axial/diag (grows), 1 tube circumferential, 2 rigid truss, 4 LRA (pull only, grows), 6 double-acting strut (bilateral, force-capped)
def spring(i, j, kind, ke): S.append((int(i), int(j), kind, ke))
def clique(ids, ke=KE_RIG):
    for a in range(len(ids)):
        for b_ in range(a + 1, len(ids)): spring(ids[a], ids[b_], 2, ke)
tubes = []; tris_all = []
def add_tube(base_c, axis, radius, n_a, L_full, stub, group, base_pinned=False, base_center=None, ring_mass=M_PART):
    axis = np.asarray(axis, float)/np.linalg.norm(axis); u = np.cross(axis, Z if abs(axis[2]) < 0.9 else np.array([1.0, 0, 0])); u /= np.linalg.norm(u); v = np.cross(axis, u)
    th = 2*np.pi*np.arange(N_C)/N_C; rings = np.zeros((n_a + 1, N_C), int)
    for j in range(n_a + 1):
        for i in range(N_C):
            p = base_c + radius*(np.cos(th[i])*u + np.sin(th[i])*v) + axis*stub*j/n_a
            rings[j, i] = add(p, 0.0 if (j == 0 and base_pinned) else (1.0 if j in (0, n_a) else ring_mass), pin=(j == 0 and base_pinned))
    cap = add(base_c + axis*stub, 1.0)
    bc = base_center if base_center is not None else add(base_c, 0.0 if base_pinned else 5.0, pin=base_pinned)
    spring(bc, cap, 4, KE_FAB)
    for i in range(N_C):
        spring(rings[n_a, i], cap, 2, KE_RIG); spring(rings[n_a, i], rings[n_a, (i + 3) % N_C], 2, KE_RIG); spring(rings[n_a, i], rings[n_a, (i + 6) % N_C], 2, KE_RIG)
    for j in range(n_a + 1):
        for i in range(N_C):
            spring(rings[j, i], rings[j, (i + 1) % N_C], 1, KE_FAB)
            if j < n_a:
                spring(rings[j, i], rings[j + 1, i], 0, KE_FAB); spring(rings[j, i], rings[j + 1, (i + 1) % N_C], 0, KE_FAB); spring(rings[j, (i + 1) % N_C], rings[j + 1, i], 0, KE_FAB)
            if j >= 2: spring(rings[0, i], rings[j, i], 4, KE_FAB)
    t0 = len(tris_all)
    for j in range(n_a):
        for i in range(N_C):
            a0, a1, b0, b1 = rings[j, i], rings[j, (i + 1) % N_C], rings[j + 1, i], rings[j + 1, (i + 1) % N_C]
            tris_all.append([a0, a1, b1]); tris_all.append([a0, b1, b0])
    for i in range(N_C): tris_all.append([rings[n_a, i], rings[n_a, (i + 1) % N_C], cap])
    n_wall = len(tris_all) - t0
    for i in range(N_C): tris_all.append([rings[0, (i + 1) % N_C], rings[0, i], bc])
    tubes.append(dict(rings=rings, cap=cap, bc=bc, axis=axis, L=L_full, stub=stub, n_a=n_a, radius=radius, group=group, tri_range=(t0, len(tris_all)), n_wall=n_wall, base_c=base_c.copy()))
    return tubes[-1]
# ---- the stalk (pinned at the deck), the yoke body on its cap
z_neck0 = STUB_STALK + 0.45
stalk = add_tube(Fxy, Z, R_STALK, N_ST, L_STALK, STUB_STALK, "stalk", base_pinned=True)
Q = Fxy + z_neck0*Z                                                              # M4: the neck axis meets the stalk axis
A1 = add(Q + 0.4*e0, 8.0); A2 = add(Q + 1.0*e0, 8.0)                             # the hollow pivot's two axis points (hinge)
JA = add(Q + 0.6*e0 - 0.6*h0 - 1.2*Z, 5.0)                                        # jack anchor on the yoke: 0.8 m from the neck along the axis, 0.6 m down-sun, 1.2 m below (jack 1.40-2.15 m, arm >= 0.38 m over el 12-83)
Mass[stalk["cap"]] = 30.0                                                        # M4 and its housing
bc_cw2 = add(Q - 0.4*e0, 5.0)
cw2 = add_tube(Q - 0.4*e0, -e0, R_CW, N_CW, L_CW2, STUB, "cw2", base_center=bc_cw2)
clique(list(stalk["rings"][-1]) + [stalk["cap"], A1, A2, JA, bc_cw2] + list(cw2["rings"][0]))
# ---- the head body: neck bar to M3 at N, crank, spine, back frame ring, rod posts, column feet, counterweight tube base
s_c = Z.copy(); n_c = -h0                                                        # at the stow the dish axis points up (el 90), n = -h
N = Q + OFF*e0
m_h = 70.0/26
def cdir_of(s, n): ps = np.radians(GM.PSI_CRANK); return -np.cos(ps)*n - np.sin(ps)*s   # the design's crank: 20 deg from -n toward the dish (geometry.crank_dir); a sign slip here once put a dead centre at el 34
CK = add(N + 0.8*cdir_of(s_c, n_c), 5.0)
Cf = N + (NECK - GM.D_FRAME)*s_c                                                  # back frame plane, 0.6 m behind the vertex
xl0, yl0 = -n_c, e0
FRAME = [add(Cf + R_FRAME*(np.cos(a)*xl0 + np.sin(a)*yl0), m_h) for a in 2*np.pi*np.arange(8)/8]
st = [np.radians(a) for a in GM.STATIONS]; cl = [np.radians(a) for a in GM.COLUMNS]
Cr = N + (NECK - GM.D_RING)*s_c                                                    # the dish's back plane
RODP = [add(Cr + GM.R_RING*(np.cos(a)*xl0 + np.sin(a)*yl0) + 0.45*(-np.sin(a)*xl0 + np.cos(a)*yl0), m_h) for a in st]
QF = [add(Cf + GM.R_ACT*(np.cos(a)*xl0 + np.sin(a)*yl0), m_h) for a in cl]
M3 = add(N, 10.0)
bc_cw1 = add(N - 0.4*s_c, 5.0)
cw1 = add_tube(N - 0.4*s_c, -s_c, R_CW, N_CW, L_CW1, STUB, "cw1", base_center=bc_cw1)
head_body = [A1, A2, M3, CK, bc_cw1] + FRAME + RODP + QF + list(cw1["rings"][0])
clique(head_body)
spring(JA, CK, 6, KE_MUS)
# ---- the dish body: back ring stations, column heads, vertex, rim, the secondary on its style
m_d = 85.0/13
BR = [add(Cr + GM.R_RING*(np.cos(a)*xl0 + np.sin(a)*yl0), m_d) for a in st]
QD = [add(Cr + GM.R_ACT*(np.cos(a)*xl0 + np.sin(a)*yl0), m_d) for a in cl]
Vx0 = N + NECK*s_c
VTX = add(Vx0, m_d)
RIM = [add(Vx0 + R_RIM*(np.cos(a)*xl0 + np.sin(a)*yl0) + H.SAG*s_c, m_d) for a in 2*np.pi*np.arange(8)/8]
SEC = add(Vx0 + D_SEC*s_c, 15.0)
dish_body = BR + QD + [VTX] + RIM + [SEC]
clique(dish_body)
FINE_RODS = [(BR[k], RODP[k]) for k in range(3)]; FINE_COLS = [(QF[k], QD[k]) for k in range(3)]
for a_, b_ in FINE_RODS: spring(a_, b_, 2, KE_RIG)
for a_, b_ in FINE_COLS: spring(a_, b_, 6, 1.0e6)
head = head_body + dish_body
FP = add(Q, 0.0, pin=True)                                                       # a marker at M4, re-pinned to the yoke each frame
# ---- counterweights from the moment balance: the head about the neck axis (e0 through N), the yoke about the stalk axis (vertical through Q)
def water_lever(tb, base_off):                                                   # the water rides in the hose walls, rings 1..n_a of the grown hose
    return base_off + tb["L"]*(tb["n_a"] + 1)/(2*tb["n_a"])
cw1_ids = set(cw1["rings"].reshape(-1).tolist()) | {cw1["cap"], cw1["bc"]}; cw2_ids = set(cw2["rings"].reshape(-1).tolist()) | {cw2["cap"], cw2["bc"]}
def moment(ids, origin, axis_dir):                                               # mass moment (kg m) of the built particles along axis_dir about origin
    return sum(Mass[i]*float((P[i] - origin)@axis_dir) for i in ids if not Pin[i])
M_n = moment([i for i in head_body + dish_body if i not in cw1_ids] + [cw1["cap"], cw1["bc"]], N, s_c) + moment(cw1_ids - {cw1["cap"], cw1["bc"]}, N, s_c)
M_CW1 = 1.0 + max(0.0, M_n)/water_lever(cw1, 0.4)                                # the head about the neck: dish and frame in front, hose water behind
all_free = [i for i in range(len(P)) if not Pin[i] and i != FP]
M_e = moment([i for i in all_free if i not in cw2_ids], Q, e0) + (M_CW1 - 1.0)*float((N - Q)@e0) + moment(cw2_ids, Q, e0)
M_CW2 = 1.0 + max(0.0, M_e)/water_lever(cw2, 0.4)                                # the yoke about the stalk: everything at the neck vs the hose beyond the stalk
print(f"balance: head about the neck {M_n:.0f} kg m -> {M_CW1:.0f} kg of water in the hose behind the neck (lever {water_lever(cw1, 0.4):.2f} m, hose holds {1e3*np.pi*R_CW**2*L_CW1:.0f} L); "
      f"yoke about the stalk {M_e:.0f} kg m -> {M_CW2:.0f} kg beyond the stalk (lever {water_lever(cw2, 0.4):.2f} m, hose holds {1e3*np.pi*R_CW**2*L_CW2:.0f} L)")
sides = [dict(tank=cw1["cap"], cw=cw1), dict(tank=cw2["cap"], cw=cw2)]
X0 = np.array(P); n = len(P); inv_m = np.array([0.0 if m == 0 else 1.0/m for m in Mass]); pinned = np.array(Pin)
S = np.array(S, float); idx = S[:, :2].astype(np.int32); kind = S[:, 2].astype(int); ke_s = S[:, 3]
nominal0 = np.linalg.norm(X0[idx[:, 0]] - X0[idx[:, 1]], axis=1); n_spr = len(S)
uni = ((kind == 0) | (kind == 1) | (kind == 3) | (kind == 4)).astype(np.int32)
col = -np.ones(n_spr, int); used = [set() for _ in range(n)]
for s_i in np.argsort(-ke_s, kind="stable"):
    i_, j_ = idx[s_i]; c = 0
    while c in used[i_] or c in used[j_]: c += 1
    col[s_i] = c; used[i_].add(c); used[j_].add(c)
n_col = int(col.max()) + 1; colour_ids = [np.where(col == c)[0].astype(np.int32) for c in range(n_col)]
tris = np.array(tris_all, np.int32)
tube_of_tri = -np.ones(len(tris), np.int32); wall_tri = np.zeros(len(tris), np.int32); tube_of_part = -np.ones(len(P), np.int32)
for ti, tb in enumerate(tubes):
    a, b_ = tb["tri_range"]; tube_of_tri[a:b_] = ti; wall_tri[a:a + tb["n_wall"]] = 1
    for pid in list(tb["rings"].reshape(-1)) + [tb["cap"], tb["bc"]]: tube_of_part[pid] = ti
EPS_V = 0.035; EPS_AX = 0.012
def vol_target_of(ti, g):
    tb = tubes[ti]; return 0.5*N_C*tb["radius"]**2*np.sin(2*np.pi/N_C)*g*tb["L"]*(1.0 + EPS_V)
grow_tube = -np.ones(n_spr, int)
for ti, tb in enumerate(tubes):
    ids = set(tb["rings"].reshape(-1).tolist()) | {tb["cap"], tb["bc"]}
    m = np.isin(idx[:, 0], list(ids)) & np.isin(idx[:, 1], list(ids)) & ((kind == 0) | (kind == 4)); grow_tube[m] = ti
# ------------------------------------------------------------------ warp arrays and kernels
def wa(a, dt): return wp.array(a, dtype=dt, device=DEV)
x = wa(X0.astype(np.float32), wp.vec3); v = wa(np.zeros((n, 3), np.float32), wp.vec3); xp = wa(X0.astype(np.float32), wp.vec3)
f = wa(np.zeros((n, 3), np.float32), wp.vec3); w = wa(inv_m.astype(np.float32), float)
sidx = wa(idx.reshape(-1), wp.int32); rest = wa(nominal0.astype(np.float32), float); kew = wa(ke_s.astype(np.float32), float)
lam = wa(np.zeros(n_spr, np.float32), float); uniw = wa(uni, wp.int32); triw = wa(tris.reshape(-1), wp.int32); pres = wa(np.zeros(len(tris), np.float32), float)
fmax_np = np.where((kind == 3) | (kind == 6), F_MUS_MAX, 1e30).astype(np.float32)
for a_, b_ in FINE_COLS: fmax_np[np.where((idx[:, 0] == a_) & (idx[:, 1] == b_))[0]] = 50e3   # water columns: incompressible, the cap is the valve seat
fmax = wa(fmax_np, float)
colw = [wa(c, wp.int32) for c in colour_ids]
totw = wa(tube_of_tri, wp.int32); wallw = wa(wall_tri, wp.int32); topw = wa(tube_of_part, wp.int32)
n_tubes = len(tubes); grad = wa(np.zeros((n, 3), np.float32), wp.vec3); vol = wa(np.zeros(n_tubes, np.float32), float); vden = wa(np.zeros(n_tubes, np.float32), float)
vtar = wa(np.zeros(n_tubes, np.float32), float); vlam = wa(np.zeros(n_tubes, np.float32), float)
R_PART = 0.05
fext = wa(np.zeros((n, 3), np.float32), wp.vec3)                              # the dish's aerodynamic load, set once per frame
A_DISH, D_DISH, RHO = np.pi*GM.R_RING**2*0 + 13.9, 4.2, 1.03
DISH_PTS = RIM + [VTX]
def wind_now(t):
    if A.wind <= 0 or t <= T_S: return 0.0
    return A.wind*(1.0 + A.gust*(0.6*np.sin(2*np.pi*t/4.0) + 0.4*np.sin(2*np.pi*t/1.3 + 1.0)))
def dish_load(q, vw):
    """drag along the wind and a pitching moment about the dish centre, as forces on the rim and vertex (the dish is a rigid clique, so only the resultant and the couple matter)"""
    F = np.zeros((n, 3))
    if vw <= 0: return F, 0.0, 0.0
    what = np.array([-1.0, 0, 0]); qd = 0.5*RHO*vw*vw
    n_d = np.cross(q[BR[1]] - q[BR[0]], q[BR[2]] - q[BR[0]]); n_d /= np.linalg.norm(n_d)
    if n_d@(q[VTX] - q[BR].mean(0)) < 0: n_d = -n_d
    ca = float(n_d@what); cd = 0.25 + (A.cd - 0.25)*ca*ca; Fd = qd*A_DISH*cd
    c_d = q[DISH_PTS].mean(0); F[DISH_PTS] += Fd*what/len(DISH_PTS)
    weff = what if ca >= 0 else -what; ax = np.cross(n_d, weff); sa = np.linalg.norm(ax)
    Mv = np.zeros(3)
    if sa > 1e-6:
        Mv = ax/sa*qd*A_DISH*D_DISH*A.cm*2*abs(ca)*sa                      # cm sin 2 alpha, turning the dish face-on
        r = q[RIM] - c_d; S = 0.5*np.sum(np.linalg.norm(r, axis=1)**2)
        F[RIM] += np.cross(Mv, r)/S
    return F, Fd, float(np.linalg.norm(Mv))

@wp.kernel
def predict(x: wp.array(dtype=wp.vec3), v: wp.array(dtype=wp.vec3), f: wp.array(dtype=wp.vec3), fe: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), g: wp.vec3, dt: float, damp: float, vmax: float, xp: wp.array(dtype=wp.vec3)):
    i = wp.tid()
    if w[i] == 0.0:
        xp[i] = x[i]; return
    vi = (v[i] + ((f[i] + fe[i])*w[i] + g)*dt)*damp
    m = wp.length(vi)
    if m > vmax: vi = vi*(vmax/m)
    v[i] = vi; xp[i] = x[i] + vi*dt

@wp.kernel
def wind_force(x: wp.array(dtype=wp.vec3), tri: wp.array(dtype=wp.int32), wall: wp.array(dtype=wp.int32), wind: wp.vec3, f: wp.array(dtype=wp.vec3)):
    t = wp.tid()
    if wall[t] == 0: return
    i = tri[3*t]; j = tri[3*t + 1]; k = tri[3*t + 2]
    an = 0.5*wp.cross(x[j] - x[i], x[k] - x[i])
    q = 0.5*1.03*wp.dot(wind, wind); wn = wind/wp.length(wind); c = wp.dot(an, wn)
    if c < 0.0:
        fv = wn*(-c)*q*1.2/3.0
        wp.atomic_add(f, i, fv); wp.atomic_add(f, j, fv); wp.atomic_add(f, k, fv)

@wp.kernel
def vol_grad(xp: wp.array(dtype=wp.vec3), tri: wp.array(dtype=wp.int32), tot: wp.array(dtype=wp.int32), grad: wp.array(dtype=wp.vec3), vol: wp.array(dtype=float)):
    t = wp.tid(); tb = tot[t]
    if tb < 0: return
    i = tri[3*t]; j = tri[3*t + 1]; k = tri[3*t + 2]; xi = xp[i]; xj = xp[j]; xk = xp[k]
    wp.atomic_add(vol, tb, wp.dot(wp.cross(xi, xj), xk)/6.0)
    wp.atomic_add(grad, i, wp.cross(xj, xk)/6.0); wp.atomic_add(grad, j, wp.cross(xk, xi)/6.0); wp.atomic_add(grad, k, wp.cross(xi, xj)/6.0)

@wp.kernel
def vol_denom(w: wp.array(dtype=float), grad: wp.array(dtype=wp.vec3), top: wp.array(dtype=wp.int32), den: wp.array(dtype=float)):
    i = wp.tid(); tb = top[i]
    if tb < 0: return
    g = grad[i]; wp.atomic_add(den, tb, w[i]*wp.dot(g, g))

@wp.kernel
def vol_apply(xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), grad: wp.array(dtype=wp.vec3), top: wp.array(dtype=wp.int32), vol: wp.array(dtype=float), vtar: wp.array(dtype=float),
              den: wp.array(dtype=float), vlam: wp.array(dtype=float), alpha: float):
    i = wp.tid(); tb = top[i]
    if tb < 0: return
    if den[tb] <= 0.0: return
    dl = -(vol[tb] - vtar[tb] + alpha*vlam[tb])/(den[tb] + alpha)
    if w[i] > 0.0: xp[i] = xp[i] + grad[i]*(w[i]*dl)
    grad[i] = wp.vec3(0.0)

@wp.kernel
def vol_lam(vol: wp.array(dtype=float), vtar: wp.array(dtype=float), den: wp.array(dtype=float), vlam: wp.array(dtype=float), alpha: float):
    tb = wp.tid()
    if den[tb] > 0.0: vlam[tb] = vlam[tb] - (vol[tb] - vtar[tb] + alpha*vlam[tb])/(den[tb] + alpha)

@wp.kernel
def springs(ids: wp.array(dtype=wp.int32), xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), idx: wp.array(dtype=wp.int32), rest: wp.array(dtype=float), ke: wp.array(dtype=float),
            uni: wp.array(dtype=wp.int32), fmax: wp.array(dtype=float), lam: wp.array(dtype=float), dt: float):
    s = ids[wp.tid()]; i = idx[2*s]; j = idx[2*s + 1]
    d = xp[i] - xp[j]; L = wp.length(d)
    if L < 1e-9: return
    c = L - rest[s]
    if uni[s] == 1 and c < 0.0:
        lam[s] = 0.0; return
    nrm = d/L; wi = w[i]; wj = w[j]; den = wi + wj
    if den == 0.0: return
    alpha = 1.0/(ke[s]*dt*dt)
    dl = -(c + alpha*lam[s])/(den + alpha)
    lnew = lam[s] + dl; lmin = -fmax[s]*dt*dt; lmax = fmax[s]*dt*dt
    if lnew < lmin: lnew = lmin
    if uni[s] == 0 and lnew > lmax: lnew = lmax
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

# ------------------------------------------------------------------ schedule and controller
T_S = A.t_setup
def ramp(t, t0, t1): return float(np.clip((t - t0)/(t1 - t0), 0.0, 1.0))
def smooth(u): return u*u*(3 - 2*u)
growth = {"stalk": lambda t: 1.0, "cw1": lambda t: smooth(ramp(t, 0.42*T_S, 0.66*T_S)), "cw2": lambda t: smooth(ramp(t, 0.42*T_S, 0.66*T_S))}
g_post = STUB_STALK/L_STALK
def el_target(t, hour):
    el, Az, s = sun(hour)
    if t < 0.74*T_S: return np.pi/2
    return np.pi/2 + (el - np.pi/2)*smooth(ramp(t, 0.74*T_S, 0.98*T_S))
def set_rests(t, g_post):
    nom = nominal0.copy()
    for ti, tb in enumerate(tubes):
        g = g_post if tb["group"] == "stalk" else (tb["stub"] + (tb["L"] - tb["stub"])*growth[tb["group"]](t))/tb["L"]
        m = grow_tube == ti
        # axial and LRA springs scale with the tube's length; diagonals keep their circumferential part
        L_ring = tb["L"]/tb["n_a"]; dz0 = tb["stub"]/tb["n_a"]; dc = 2*np.pi*tb["radius"]/N_C
        ax_m = m & (kind == 0) & (np.abs(nominal0 - dz0) < 1e-6); dg_m = m & (kind == 0) & ~ax_m; lra = m & (kind == 4)
        nom[ax_m] = g*L_ring*(1 - EPS_AX); nom[dg_m] = np.hypot(dc, g*L_ring*(1 - EPS_AX)); nom[lra] = nominal0[lra]*(g*L_ring/dz0)*(1 - EPS_AX)
    return nom
muscle_ids = [(i_, s) for i_, s in enumerate(range(n_spr)) if kind[s] == 3]
JA_REL = X0[JA] - X0[M3]                                                         # the anchor in the yoke's frame (the yoke turns with the sun in azimuth, so this is fixed)
def jack_length(elt):
    """the jack's length when the head sits at elevation elt on a rigid yoke: a fixed function of the command, from the built geometry"""
    s_t = np.cos(elt)*h0 + np.sin(elt)*Z; n_t = -np.sin(elt)*h0 + np.cos(elt)*Z
    return float(np.linalg.norm(0.8*cdir_of(s_t, n_t) - JA_REL))
def muscle_rests(nom, elt, hour, q, engaged):
    """the screw jack: rest length = its length at the commanded elevation (yoke-fixed geometry; the coarse loop's bias on elt takes up the yoke's pitch)"""
    k = np.where((idx[:, 0] == JA) & (idx[:, 1] == CK))[0][0]; nom[k] = jack_length(elt)
    return nom
def az_rotate(hour, bias=0.0):
    el, Az, s, h, e, nn = frame_of(hour); dA = Az - Az_ + bias
    c, s_ = np.cos(dA), np.sin(dA); R = np.array([[c, -s_, 0], [s_, c, 0], [0, 0, 1.0]])
    return R
ALPHA_V = 0.0
dt_f = 1.0/A.fps; dt = dt_f/A.substeps; damp = float(np.exp(-4.0*dt)); GRAV = wp.vec3(0.0, 0.0, -9.81)
u_fine = [0.0, 0.0, 0.0]; u_tilt = [0.0, 0.0, 0.0]; u_piston = 0.0; el_bias = 0.0; az_bias = 0.0
T_TOTAL = T_S + A.t_day; n_frames = int(round(T_TOTAL*A.fps)); frames, log = [], []; t0 = time.time()
pin_ids = np.where(pinned & (np.arange(n) != FP))[0]; X0pin = X0[pin_ids].copy()
for fr in range(n_frames + 1):
    t = fr*dt_f
    hour = A.h0 if t < T_S else A.h0 + (A.h1 - A.h0)*(t - T_S)/A.t_day
    el, Az, s, h, e, nn = frame_of(hour)
    q = x.numpy().astype(float)
    # pressure ramps in the first tenth; posts grow with feedback on the axis height; tanks fill
    p = P_MAX
    z_axis = 0.5*(q[A1][2] + q[A2][2])
    z_goal = Z_NECK
    if 0.08*T_S < t < 0.98*T_S: g_post = float(np.clip(g_post + np.clip(0.5*(z_goal - z_axis)/L_STALK, -0.09, 0.09)*dt_f, STUB_STALK/L_STALK, 1.08))   # rate-limited: the blower's speed
    fill = smooth(ramp(t, 0.6*T_S, 0.74*T_S)); m_tank = 1.0 + (M_CW1 - 1.0)*fill
    for sd, m_full in ((sides[0], M_CW1), (sides[1], M_CW2)):
        cw_ids = sd["cw"]["rings"][1:].reshape(-1); m_w = 1.0 + (m_full - 1.0)*fill; inv_m[cw_ids] = 1.0/(M_PART + (m_w - 1.0)/len(cw_ids)); inv_m[sd["tank"]] = 1.0/max(1.0, (m_w - 1.0)/len(cw_ids))
    w.assign(inv_m.astype(np.float32))
    elt = el_target(t, hour) + el_bias
    nom = set_rests(t, g_post); nom = muscle_rests(nom, elt, hour, q, engaged=True)
    if True:
        c_d = q[BR].mean(0); n_d = np.cross(q[BR[1]] - q[BR[0]], q[BR[2]] - q[BR[0]]); n_d /= np.linalg.norm(n_d)
        if n_d@(q[VTX] - c_d) < 0: n_d = -n_d
        n_f = np.cross(q[FRAME[2]] - q[FRAME[0]], q[FRAME[4]] - q[FRAME[0]]); n_f /= np.linalg.norm(n_f)
        if n_f@(q[VTX] - q[FRAME].mean(0)) < 0: n_f = -n_f
        if t >= 0.98*T_S:                                                            # coarse loops on a sun sensor once the turn is over: elevation through the jack, azimuth through the ring
            el_f = np.arcsin(np.clip(n_f[2], -1, 1)); az_f = np.arctan2(n_f[1], n_f[0])
            el_bias = float(np.clip(el_bias + 1.0*(el - el_f)*dt_f, -0.2, 0.2))
            daz = (Az - az_f + np.pi) % (2*np.pi) - np.pi; az_bias = float(np.clip(az_bias + 1.0*daz*dt_f, -0.2, 0.2))
        coarse_now = float(np.degrees(np.arccos(np.clip(n_f@s, -1, 1))))
        if t >= T_S and coarse_now > 3.0:                                             # outside the fine stage's range: let the columns come back to centre
            u_tilt = [u_*(1 - 0.5*dt_f) for u_ in u_tilt]; u_piston *= (1 - 0.5*dt_f); u_fine = [u_tilt[k] + u_piston for k in range(3)]
        elif t >= T_S:                                                                # the fine stage closes on the sun once the coarse stage has arrived
            eps = np.cross(n_d, s)                                                   # small rotation that takes the dish axis onto the sun line
            dz = 0.5*(np.linalg.norm(q[VTX] - (q[A1] + (OFF - 0.4)*e)) - NECK)        # focus: keep the vertex 1.8 m from the neck, within the piston's small share
            u_piston = float(np.clip(u_piston - np.clip(dz, -0.01, 0.01)*2.0*dt_f, -0.007, 0.007))   # longer columns push the dish forward: a vertex too far needs shorter ones
            for k, (a_, b_) in enumerate(FINE_COLS):
                r_k = q[b_] - c_d; du = (np.cross(eps, r_k)@n_d)*2.0*dt_f
                u_tilt[k] = float(np.clip(u_tilt[k] + du, -0.025, 0.025))            # tilt keeps the range: +-25 mm of the +-32
        u_fine = [u_tilt[k] + u_piston for k in range(3)]
        for k, (a_, b_) in enumerate(FINE_COLS):
            kk = np.where((idx[:, 0] == a_) & (idx[:, 1] == b_))[0][0]; nom[kk] = nominal0[kk] + u_fine[k]
    rest.assign(nom.astype(np.float32))
    vt = np.array([vol_target_of(ti, g_post if tb["group"] == "stalk" else (tb["stub"] + (tb["L"] - tb["stub"])*growth[tb["group"]](t))/tb["L"]) for ti, tb in enumerate(tubes)], np.float32); vtar.assign(vt)
    # azimuth: the deck ring turns the post bases (kinematic)
    R = az_rotate(hour, az_bias); newpin = (R @ (X0pin - Fxy).T).T + Fxy
    xn = x.numpy(); xn[pin_ids] = newpin.astype(np.float32); xn[FP] = xn[stalk["cap"]] + np.array([0, 0, 0.45], np.float32); x.assign(xn)
    vw = wind_now(t); wind = wp.vec3(-vw, 0.0, 0.0)
    Fw, F_dish, M_dish = dish_load(q, vw); fext.assign(Fw.astype(np.float32))
    for k in range(A.substeps):
        f.zero_(); lam.zero_(); vlam.zero_()
        if vw > 0: wp.launch(wind_force, dim=len(tris), inputs=[x, triw, wallw, wind, f], device=DEV)
        wp.launch(predict, dim=n, inputs=[x, v, f, fext, w, GRAV, dt, damp, 8.0, xp], device=DEV)
        for it in range(A.iters):
            for cw_ in colw:
                wp.launch(springs, dim=len(cw_), inputs=[cw_, xp, w, sidx, rest, kew, uniw, fmax, lam, dt], device=DEV)
            vol.zero_(); vden.zero_()
            wp.launch(vol_grad, dim=len(tris), inputs=[xp, triw, totw, grad, vol], device=DEV)
            wp.launch(vol_denom, dim=n, inputs=[w, grad, topw, vden], device=DEV)
            wp.launch(vol_apply, dim=n, inputs=[xp, w, grad, topw, vol, vtar, vden, vlam, ALPHA_V], device=DEV)
            wp.launch(vol_lam, dim=n_tubes, inputs=[vol, vtar, vden, vlam, ALPHA_V], device=DEV)
            wp.launch(ground, dim=n, inputs=[xp, R_PART], device=DEV)
        wp.launch(finish, dim=n, inputs=[x, xp, w, dt, v], device=DEV)
    q = x.numpy().astype(float)
    # the state is now at t + dt_f: judge it against the sun of that instant (in this compressed day the sun moves 0.08 deg per frame, so judging against the frame's opening sun reads a one-frame lead as error)
    hour_end = A.h0 if t + dt_f < T_S else A.h0 + (A.h1 - A.h0)*(t + dt_f - T_S)/A.t_day
    el, Az, s, h, e, nn = frame_of(hour_end)
    p_eq = []
    for tb in tubes:
        rg = tb["rings"][1:-1]; c0 = q[rg].mean(1, keepdims=True); rr = np.linalg.norm(q[rg] - c0, axis=2).mean()
        chord = 2*tb["radius"]*np.sin(np.pi/N_C); eps = max(0.0, 2*rr*np.sin(np.pi/N_C)/chord - 1.0)
        g_now = g_post if tb["group"] == "stalk" else (tb["stub"] + (tb["L"] - tb["stub"])*growth[tb["group"]](t))/tb["L"]
        p_eq.append(KE_FAB*eps*chord/((g_now*tb["L"]/tb["n_a"])*rr))                        # hoop tension per unit length / r
    p_eq = np.array(p_eq).round(0)
    if not np.isfinite(q).all(): print("NaN at frame", fr); break
    V_ideal = q[A1] + (OFF - 0.4)*e + NECK*s; err = float(np.linalg.norm(q[VTX] - V_ideal)); free = np.where(inv_m > 0)[0]; i_low = int(free[np.argmin(q[free][:, 2])]); z_min = float(q[i_low][2])
    if True:
        n_f = np.cross(q[FRAME[2]] - q[FRAME[0]], q[FRAME[4]] - q[FRAME[0]]); n_f /= np.linalg.norm(n_f)
        if n_f@(q[VTX] - q[FRAME].mean(0)) < 0: n_f = -n_f
        coarse_err = float(np.degrees(np.arccos(np.clip(n_f@s, -1, 1))))
        n_d = np.cross(q[BR[1]] - q[BR[0]], q[BR[2]] - q[BR[0]]); n_d /= np.linalg.norm(n_d)
        if n_d@(q[VTX] - q[BR].mean(0)) < 0: n_d = -n_d
        point_err = float(np.degrees(np.arccos(np.clip(n_d@s, -1, 1))))

    mus = [abs(KE_MUS*(np.linalg.norm(q[JA] - q[CK]) - nom[np.where((idx[:, 0] == JA) & (idx[:, 1] == CK))[0][0]]))]
    if fr % A.rec == 0:
        frames.append(np.round(q*100).astype(np.int16))
        log.append(dict(t=round(t, 2), hour=round(hour, 2), p=round(p), g_post=round(g_post, 3), z_axis=round(z_axis, 3), tank=round(m_tank, 1), el_t=round(float(np.degrees(elt)), 1), el_bias=round(float(np.degrees(el_bias)), 2), az_bias=round(float(np.degrees(az_bias)), 2),
                        err=round(err, 3), point=round(point_err, 3), coarse=round(coarse_err, 2), fine_mm=[round(1e3*u_, 1) for u_ in u_fine], z_min=round(z_min, 2), p_eq=[float(v_) for v_ in p_eq], muscles=[round(m_) for m_ in mus], vtx=[round(float(c), 3) for c in q[VTX]], tgt=[round(float(c), 3) for c in V_ideal], wind=round(vw, 2), f_dish=round(F_dish), m_dish=round(M_dish), lean=round(float(np.degrees(np.arctan2(np.hypot(q[stalk['cap']][0] - Fxy[0], q[stalk['cap']][1] - Fxy[1]), q[stalk['cap']][2]))), 3)))
    if not A.quiet and fr % (A.fps*2) == 0:
        print(f"t {t:5.1f}  h {hour:5.2f}  p_eq {np.round(p_eq/1e3, 1)} kPa  axis z {z_axis:.2f}  g_post {g_post:.2f}  tank {m_tank:5.1f}  el_t {np.degrees(elt):5.1f}  vtx {np.round(q[VTX], 2)}  ideal {np.round(V_ideal, 2)}  err {err:.2f} m  coarse {coarse_err:.1f} deg  dish {point_err:.2f} deg  cols {np.round(np.array(u_fine)*1e3, 1)} mm  zmin {z_min:.2f}@{i_low}  muscles {np.round(mus, -1)}  wind {vw:4.1f} m/s dish {F_dish/1e3:.2f} kN {M_dish/1e3:.2f} kN m lean {np.degrees(np.arctan2(np.hypot(q[stalk['cap']][0] - Fxy[0], q[stalk['cap']][1] - Fxy[1]), q[stalk['cap']][2])):.2f} deg  ({time.time() - t0:.0f} s)")
# ------------------------------------------------------------------ outputs
Q = np.stack(frames); blob = base64.b64encode(zlib.compress(Q.tobytes(), 9)).decode()
head_pairs = [[A2, M3], [M3, FRAME[0]], [M3, FRAME[4]], [M3, CK]] + [[FRAME[i], FRAME[(i + 1) % 8]] for i in range(8)] + [[VTX, SEC]] + [[VTX, RIM[i]] for i in range(0, 8, 2)] + [[RIM[i], SEC] for i in range(0, 8, 2)]
axle_pairs = [[A1, A2], [A2, CK]]
anim = dict(n_frames=int(Q.shape[0]), n_particles=int(Q.shape[1]), dt=A.rec/A.fps, scale=0.01, z_offset=H.Z_DECK, blob=blob,
            tris=tris.reshape(-1).tolist(), n_tube=int(n), head_lines=head_pairs, axle_lines=axle_pairs, muscles=[[JA, CK]],
            tanks=[sd["tank"] for sd in sides], fine_rods=[list(p) for p in FINE_RODS], fine_cols=[list(p) for p in FINE_COLS], sec=int(SEC), m3=int(M3), rim=RIM, frame=FRAME, vtx=VTX, F=FP, rail=dict(c=[float(Fxy[0]), float(Fxy[1])], r=float(R_STALK + 0.1)), wires=[],
            t_setup=T_S, t_day=A.t_day, h0=A.h0, h1=A.h1, p_max=P_MAX, m_cw1=round(M_CW1), m_cw2=round(M_CW2), log=log)
json.dump(anim, open(os.path.join(OUT, A.tag + "_anim.json"), "w"), separators=(",", ":")); json.dump(log, open(os.path.join(OUT, A.tag + "_log.json"), "w"))
errs = np.array([l["err"] for l in log]); ts = np.array([l["t"] for l in log]); pts = np.array([l["point"] for l in log]); crs = np.array([l.get("coarse", 0) for l in log]); track = ts > T_S
print(f"\nframes {Q.shape[0]} x {Q.shape[1]} particles, {len(tris)} triangles, {n_spr} constraints in {n_col} colours -> {len(blob)//1024} KB; wall {time.time() - t0:.0f} s")
if track.any():
    late = track & (ts > T_S + 0.15*A.t_day)
    print(f"setup: vertex error {errs[~track][-1]:.2f} m, coarse pointing {crs[~track][-1]:.1f} deg at t_setup; tracking {A.h0:.0f}-{A.h1:.0f} h: vertex error mean {errs[track].mean():.2f} m max {errs[track].max():.2f} m;")
    print(f"        coarse (frame) pointing mean {crs[track].mean():.2f} deg max {crs[track].max():.2f}; wind mean {np.mean([l.get('wind', 0) for l in log if l['t'] > T_S]):.1f} m/s, dish force max {max(l.get('f_dish', 0) for l in log)/1e3:.2f} kN, stalk lean max {max(l.get('lean', 0) for l in log if l['t'] > T_S):.2f} deg; dish pointing with the fine stage: mean {pts[track].mean():.3f} deg, after the first 15 % of the day mean {pts[late].mean():.3f} deg = {pts[late].mean()*17.45:.2f} mrad, max {pts[late].max():.3f} deg; columns at end {log[-1]['fine_mm']} mm; muscles at end {log[-1]['muscles']} N; axis z {log[-1]['z_axis']:.2f} (neck target {Z_NECK:.2f})")

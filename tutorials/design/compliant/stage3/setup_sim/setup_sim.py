#!/usr/bin/env python
"""The machine sets itself up: a 3-D soft-body simulation of the inflatable fork, written in NVIDIA Warp kernels.

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
ap.add_argument("--stage", type=int, default=4, help="bisection: 1 posts+top bodies, 2 +axle bodies, 3 +arm and cw tubes, 4 full"); ap.add_argument("--p_max", type=float, default=40e3); ap.add_argument("--wind", type=float, default=0.0, help="steady wind m/s from the north (-x) after setup")
A = ap.parse_args()
wp.config.quiet = True; wp.init(); DEV = "cpu"
# ------------------------------------------------------------------ geometry (metres; sim frame = env frame with the deck at z 0)
F = H.F - np.array([0, 0, H.Z_DECK]); G_ORBIT = H.G_ORBIT; SAG = H.SAG
Y_T, Y_POST, Y_ARM = GM.Y_T, GM.Y_POST, GM.Y_ARM
R_POST, R_ARM, R_CW = 0.60, 0.40, 0.30
L_POST = F[2] - 0.35; L_ARM = G_ORBIT + GM.D_FRAME - 0.5; L_CW = GM.L_CW - 0.5         # tube lengths: post top 0.35 under the axis; arm and counterweight tubes start 0.5 m from the axis
N_C, N_POST, N_ARM, N_CW = 12, 14, 14, 8
P_MAX = A.p_max; M_PART, M_HEAD, M_TANK = 0.15, 100.0, 91.0
KE_FAB, KE_RIG, KE_MUS = 1.5e6, 6.0e6, 5.0e4          # fabric E t ~ 1.5 MN/m (heavy coated polyester); rigid bodies; strut compliance
STUB_POST, STUB = 1.05, 0.30
F_MUS_MAX = 10e3                                  # a pair of large pneumatic muscles: force-limited
R_FRAME, R_RIM = GM.R_FRAME, 2.16
def sun(hour): return H.sun(A.doy, hour)
el0, A0, s0_ = sun(A.h0)
def frame_of(hour):
    el, Az, s = sun(hour); s_, h, e, n = GM.frame(el, Az); return el, Az, s, h, e, n
el_, Az_, s_sun, h0, e0, n0 = frame_of(A.h0)
Z = np.array([0, 0, 1.0]); Fxy = np.array([F[0], F[1], 0.0])

P, Mass, Pin = [], [], []
def add(p, m, pin=False): P.append(np.asarray(p, float)); Mass.append(m); Pin.append(pin); return len(P) - 1
S = []     # (i, j, kind, ke): kind 0 tube axial/diag (grows), 1 tube circumferential, 2 rigid truss, 3 muscle (pull only), 4 LRA (pull only, grows), 6 double-acting strut (bilateral, force-capped)
def spring(i, j, kind, ke): S.append((int(i), int(j), kind, ke))
def clique(ids, ke=KE_RIG):
    for a in range(len(ids)):
        for b_ in range(a + 1, len(ids)): spring(ids[a], ids[b_], 2, ke)
tubes = []     # dict(rings (N_A+1, N_C), axis(unit), L_full, stub, tris list, lra list, group)
tris_all, tris_tube = [], []
def add_tube(base_c, axis, radius, n_a, L_full, stub, group, base_pinned=False, base_ids=None, base_center=None):
    """rings 0..n_a from base_c along axis; ring 0 either new pinned particles or given ids (part of a rigid body). Returns dict."""
    axis = np.asarray(axis, float)/np.linalg.norm(axis); u = np.cross(axis, Z if abs(axis[2]) < 0.9 else np.array([1.0, 0, 0])); u /= np.linalg.norm(u); v = np.cross(axis, u)
    th = 2*np.pi*np.arange(N_C)/N_C; rings = np.zeros((n_a + 1, N_C), int)
    for j in range(n_a + 1):
        for i in range(N_C):
            p = base_c + radius*(np.cos(th[i])*u + np.sin(th[i])*v) + axis*stub*j/n_a
            if j == 0 and base_ids is not None: rings[0, i] = base_ids[i]
            else: rings[j, i] = add(p, 0.0 if (j == 0 and base_pinned) else M_PART, pin=(j == 0 and base_pinned))
    cap = add(base_c + axis*stub, M_PART)
    bc = base_center if base_center is not None else add(base_c, 0.0 if base_pinned else 2.0, pin=base_pinned)
    spring(bc, cap, 4, KE_FAB)                                                  # base centre to cap: the tube's length, held directly (grows)
    for i in range(N_C):                                                        # the tip cap: a rigid disc on the last ring
        spring(rings[n_a, i], cap, 2, KE_RIG); spring(rings[n_a, i], rings[n_a, (i + 3) % N_C], 2, KE_RIG); spring(rings[n_a, i], rings[n_a, (i + 6) % N_C], 2, KE_RIG)
    for j in range(n_a + 1):
        for i in range(N_C):
            spring(rings[j, i], rings[j, (i + 1) % N_C], 1, KE_FAB)
            if j < n_a:
                spring(rings[j, i], rings[j + 1, i], 0, KE_FAB); spring(rings[j, i], rings[j + 1, (i + 1) % N_C], 0, KE_FAB); spring(rings[j, (i + 1) % N_C], rings[j + 1, i], 0, KE_FAB)
            if j >= 2: spring(rings[0, i], rings[j, i], 4, KE_FAB)          # long-range attachment to the base ring
    t0 = len(tris_all)
    for j in range(n_a):
        for i in range(N_C):
            a0, a1, b0, b1 = rings[j, i], rings[j, (i + 1) % N_C], rings[j + 1, i], rings[j + 1, (i + 1) % N_C]
            tris_all.append([a0, a1, b1]); tris_all.append([a0, b1, b0])
    for i in range(N_C): tris_all.append([rings[n_a, i], rings[n_a, (i + 1) % N_C], cap])
    n_wall = len(tris_all) - t0
    for i in range(N_C): tris_all.append([rings[0, (i + 1) % N_C], rings[0, i], bc])          # base cap, outward (-axis): closes the volume
    tubes.append(dict(rings=rings, cap=cap, bc=bc, axis=axis, L=L_full, stub=stub, n_a=n_a, radius=radius, group=group, tri_range=(t0, len(tris_all)), n_wall=n_wall, base_c=base_c.copy()))
    return tubes[-1]
# ---- per side: post, post-top body, axle body, arm tube, counterweight tube, cranks, muscle anchor
z_axis0 = STUB_POST + 0.35
sides = []
for sg in (+1, -1):
    B = Fxy + sg*Y_POST*e0
    post = add_tube(B, Z, R_POST, N_POST, L_POST, STUB_POST, "post", base_pinned=True)
    top = post["rings"][-1]; hub = post["cap"]; Mass[hub] = 20.0
    for r_ in top: Mass[r_] = 1.0
    Ax = Fxy + sg*Y_T*e0 + z_axis0*Z
    A1 = add(Ax - 0.3*sg*e0, 5.0); A2 = add(Ax + 0.3*sg*e0, 5.0)
    clique(list(top) + [hub, A1, A2])                                          # post-top body: tip ring, cap, the two axis points
    if A.stage == 1:
        sides.append(dict(sg=sg, post=post, A1=A1, A2=A2)); continue
    Ac = Fxy + sg*Y_ARM*e0 + z_axis0*Z                                          # the axis point on the arm's line
    s_c, n_c = -Z, -h0                                                          # cradle arm direction = -s: at the face-up stow (el 90) the arms point down, the head hangs under F; n_c = -h
    cdir0 = -np.cos(np.radians(GM.PSI_CRANK))*n_c - np.sin(np.radians(GM.PSI_CRANK))*(-s_c)   # the third pass's crank: 1 m from the axis, 20 deg up-sun of the perpendicular (s = -s_c)
    Ax1 = Ax - 0.3*sg*e0                                                        # A1's station on the axis
    Ck = add(Ax1 + 1.0*cdir0, 5.0)
    Mus = add(Fxy + sg*(Y_T - 0.3)*e0 + GM.A_H*h0 + 0.10*Z, 0.0, pin=True)        # strut anchor on the deck ring, 0.25 m behind the axis's vertical
    bc_arm = add(Ac + 0.5*s_c, 5.0); bc_cw = add(Ac - 0.5*s_c, 5.0)
    if A.stage == 2:
        clique([A1, A2, Ck, bc_arm, bc_cw]); spring(Mus, Ck, 6, KE_MUS)
        sides.append(dict(sg=sg, post=post, A1=A1, A2=A2, Mus=Mus, Ck=Ck)); continue
    arm = add_tube(Ac + 0.5*s_c, s_c, R_ARM, N_ARM, L_ARM, STUB, "arm", base_center=bc_arm)
    cw = add_tube(Ac - 0.5*s_c, -s_c, R_CW, N_CW, L_CW, STUB, "cw", base_center=bc_cw)
    tank = cw["cap"]; Mass[tank] = 1.0
    for r_ in list(arm["rings"][0]) + list(arm["rings"][-1]) + list(cw["rings"][0]): Mass[r_] = 1.0
    clique([A1, A2, Ck, bc_arm, bc_cw] + list(arm["rings"][0]) + list(cw["rings"][0]))        # axle body: axis points, crank, both base rings and centres
    spring(Mus, Ck, 6, KE_MUS)
    sides.append(dict(sg=sg, post=post, arm=arm, cw=cw, A1=A1, A2=A2, Mus=Mus, Ck=Ck, tank=tank, base_ids=list(post["rings"][0])))
# ---- head: on the two arms' tip caps; frame ring r 1.75 in the tip plane, vertex 0.6 ahead, rim r 2.16 at 0.87
if A.stage < 4:
    FRAME, RIM = [], []; VTX = add(Fxy + 0.7*Z, 1.0); head = [VTX]; hubs = []; FINE_RODS = []; FINE_COLS = []; BR = []; QD = []
tipz = z_axis0 - 0.5 - STUB                                                    # the arms' tip plane (the back frame), under the axis
if A.stage == 4:
  hubs = [sd["arm"]["cap"] for sd in sides]
  # back-frame body (40 kg): arm caps, frame ring r 1.75, the three rod posts (in the dish's back plane) and the three column feet (frame plane)
  m_f = 40.0/16; m_d = 60.0/12
  FRAME = [add(Fxy + R_FRAME*(np.cos(a)*h0 + np.sin(a)*e0) + tipz*Z, m_f) for a in 2*np.pi*np.arange(8)/8]
  z_ring = tipz + (GM.D_FRAME - GM.D_RING)                                          # the dish's back plane, 0.3 m toward F from the frame plane
  st = [np.radians(a) for a in GM.STATIONS]; cl = [np.radians(a) for a in GM.COLUMNS]
  xl0, yl0 = -h0, e0                                                                  # dish-frame axes at the stow (axis up): x_l = -n = -(-h) ... at el 90 n = -h so x_l = h; keep the slot toward +h
  xl0 = h0
  BR = [add(Fxy + GM.R_RING*(np.cos(a)*xl0 + np.sin(a)*yl0) + z_ring*Z, m_d) for a in st]          # dish back ring stations (dish body)
  RODP = [add(Fxy + GM.R_RING*(np.cos(a)*xl0 + np.sin(a)*yl0) + 0.45*(-np.sin(a)*xl0 + np.cos(a)*yl0) + z_ring*Z, m_f) for a in st]   # rod posts (frame body)
  QF = [add(Fxy + GM.R_ACT*(np.cos(a)*xl0 + np.sin(a)*yl0) + tipz*Z, m_f) for a in cl]             # column feet (frame body)
  QD = [add(Fxy + GM.R_ACT*(np.cos(a)*xl0 + np.sin(a)*yl0) + z_ring*Z, m_d) for a in cl]           # column heads (dish body)
  VTX = add(Fxy + (tipz + GM.D_FRAME)*Z, m_d)
  RIM = [add(Fxy + R_RIM*(np.cos(a)*h0 + np.sin(a)*e0) + (tipz + GM.D_FRAME + SAG)*Z, m_d) for a in 2*np.pi*np.arange(8)/8]
  frame_body = hubs + FRAME + RODP + QF; dish_body = BR + QD + [VTX] + RIM; head = frame_body + dish_body
  for sd in sides: Mass[sd["arm"]["cap"]] = m_f
  clique(frame_body); clique(dish_body)
  for sd in sides:
    for i, r in enumerate(sd["arm"]["rings"][-1]):
        spring(r, sd["arm"]["cap"], 2, KE_RIG); spring(r, FRAME[i % 8], 2, KE_RIG)
  FINE_RODS = [(BR[k], RODP[k]) for k in range(3)]; FINE_COLS = [(QF[k], QD[k]) for k in range(3)]
  for a_, b_ in FINE_RODS: spring(a_, b_, 2, KE_RIG)                                # tangential rods: three lines in the back plane -> tip, tilt, focus free
  for a_, b_ in FINE_COLS: spring(a_, b_, 6, 1.0e6)                                  # water columns: displacement actuators on the normals, force-capped
FP = add(F, 0.0, pin=True)
X0 = np.array(P); n = len(P); inv_m = np.array([0.0 if m == 0 else 1.0/m for m in Mass]); pinned = np.array(Pin)
S = np.array(S, float); idx = S[:, :2].astype(np.int32); kind = S[:, 2].astype(int); ke_s = S[:, 3]
nominal0 = np.linalg.norm(X0[idx[:, 0]] - X0[idx[:, 1]], axis=1); n_spr = len(S)
uni = ((kind == 0) | (kind == 1) | (kind == 3) | (kind == 4)).astype(np.int32)
bil_cap = (kind == 6).astype(np.int32)
# graph colouring of the constraints for a Gauss-Seidel solve: springs sharing a particle get different colours
col = -np.ones(n_spr, int); used = [set() for _ in range(len(P))]
order = np.argsort(-ke_s, kind="stable")                                       # stiff (rigid) springs first
for sidx_ in order:
    i_, j_ = idx[sidx_]; c = 0
    while c in used[i_] or c in used[j_]: c += 1
    col[sidx_] = c; used[i_].add(c); used[j_].add(c)
n_col = int(col.max()) + 1; colour_ids = [np.where(col == c)[0].astype(np.int32) for c in range(n_col)]
tris = np.array(tris_all, np.int32)
tube_of_tri = -np.ones(len(tris), np.int32); wall_tri = np.zeros(len(tris), np.int32); tube_of_part = -np.ones(n if False else len(P), np.int32)
for ti, tb in enumerate(tubes):
    a, b_ = tb["tri_range"]; tube_of_tri[a:b_] = ti; wall_tri[a:a + tb["n_wall"]] = 1
    for pid in list(tb["rings"].reshape(-1)) + [tb["cap"], tb["bc"]]: tube_of_part[pid] = ti
EPS_V = 0.035                                    # over-volume: the walls' 1.7 % hoop strain against it is about 40 kPa in this fabric (reported per tube from the strain)
def vol_target_of(ti, g):
    tb = tubes[ti]; return 0.5*N_C*tb["radius"]**2*np.sin(2*np.pi/N_C)*g*tb["L"]*(1.0 + EPS_V)   # 12-gon section x nominal length, prestressed
# growth bookkeeping: for tube springs of kind 0/4 the nominal length scales with the tube's growth factor
grow_of = np.zeros(n_spr); grow_tube = -np.ones(n_spr, int)
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
for a_, b_ in FINE_COLS: fmax_np[np.where((idx[:, 0] == a_) & (idx[:, 1] == b_))[0]] = 5e3
fmax = wa(fmax_np, float)
colw = [wa(c, wp.int32) for c in colour_ids]
totw = wa(tube_of_tri, wp.int32); wallw = wa(wall_tri, wp.int32); topw = wa(tube_of_part, wp.int32)
n_tubes = len(tubes); grad = wa(np.zeros((n, 3), np.float32), wp.vec3); vol = wa(np.zeros(n_tubes, np.float32), float); vden = wa(np.zeros(n_tubes, np.float32), float)
vtar = wa(np.zeros(n_tubes, np.float32), float); vlam = wa(np.zeros(n_tubes, np.float32), float)
R_PART = 0.05

@wp.kernel
def predict(x: wp.array(dtype=wp.vec3), v: wp.array(dtype=wp.vec3), f: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), g: wp.vec3, dt: float, damp: float, vmax: float, xp: wp.array(dtype=wp.vec3)):
    i = wp.tid()
    if w[i] == 0.0:
        xp[i] = x[i]; return
    vi = (v[i] + (f[i]*w[i] + g)*dt)*damp
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
growth = {"post": lambda t: 1.0, "arm": lambda t: smooth(ramp(t, 0.42*T_S, 0.66*T_S)), "cw": lambda t: smooth(ramp(t, 0.42*T_S, 0.66*T_S))}
g_post = STUB_POST/L_POST
def el_target(t, hour):
    el, Az, s = sun(hour)
    if t < 0.74*T_S: return np.pi/2
    return np.pi/2 + (el - np.pi/2)*smooth(ramp(t, 0.74*T_S, 0.98*T_S))
def set_rests(t, g_post):
    nom = nominal0.copy()
    for ti, tb in enumerate(tubes):
        g = g_post if tb["group"] == "post" else (tb["stub"] + (tb["L"] - tb["stub"])*growth[tb["group"]](t))/tb["L"]
        m = grow_tube == ti
        # axial and LRA springs scale with the tube's length; diagonals keep their circumferential part
        L_ring = tb["L"]/tb["n_a"]; dz0 = tb["stub"]/tb["n_a"]; dc = 2*np.pi*tb["radius"]/N_C
        ax_m = m & (kind == 0) & (np.abs(nominal0 - dz0) < 1e-6); dg_m = m & (kind == 0) & ~ax_m; lra = m & (kind == 4)
        nom[ax_m] = g*L_ring; nom[dg_m] = np.hypot(dc, g*L_ring); nom[lra] = nominal0[lra]*(g*L_ring/dz0)
    return nom
muscle_ids = [(i_, s) for i_, s in enumerate(range(n_spr)) if kind[s] == 3]
def muscle_rests(nom, elt, hour, q, engaged):
    """the double-acting strut per side: rest length = the distance from its deck anchor to where the crank sits at the commanded elevation"""
    el, Az, s, h, e, nn = frame_of(hour)
    s_t = np.cos(elt)*h + np.sin(elt)*Z; n_t = -np.sin(elt)*h + np.cos(elt)*Z
    cdir = -np.cos(np.radians(GM.PSI_CRANK))*n_t - np.sin(np.radians(GM.PSI_CRANK))*s_t
    for sd in sides:
        k = np.where((idx[:, 0] == sd["Mus"]) & (idx[:, 1] == sd["Ck"]))[0][0]
        nom[k] = np.linalg.norm(q[sd["A1"]] + 1.0*cdir - q[sd["Mus"]])
    return nom
def az_rotate(hour):
    el, Az, s, h, e, nn = frame_of(hour); dA = Az - Az_
    c, s_ = np.cos(dA), np.sin(dA); R = np.array([[c, -s_, 0], [s_, c, 0], [0, 0, 1.0]])
    return R
ALPHA_V = 0.0
dt_f = 1.0/A.fps; dt = dt_f/A.substeps; damp = float(np.exp(-4.0*dt)); GRAV = wp.vec3(0.0, 0.0, -9.81)
u_fine = [0.0, 0.0, 0.0]
T_TOTAL = T_S + A.t_day; n_frames = int(round(T_TOTAL*A.fps)); frames, log = [], []; t0 = time.time()
pin_ids = np.where(pinned & (np.arange(n) != FP))[0]; X0pin = X0[pin_ids].copy()
for fr in range(n_frames + 1):
    t = fr*dt_f
    hour = A.h0 if t < T_S else A.h0 + (A.h1 - A.h0)*(t - T_S)/A.t_day
    el, Az, s, h, e, nn = frame_of(hour)
    q = x.numpy().astype(float)
    # pressure ramps in the first tenth; posts grow with feedback on the axis height; tanks fill
    p = P_MAX
    z_axis = np.mean([0.5*(q[sd["A1"]][2] + q[sd["A2"]][2]) for sd in sides])
    z_goal = F[2] + (0.12 if t < 0.74*T_S else 0.0)                                # a hand's width high until the cradle turns: the face-up head clears the deck
    if 0.08*T_S < t < 0.98*T_S: g_post = float(np.clip(g_post + np.clip(0.5*(z_goal - z_axis)/L_POST, -0.09, 0.09)*dt_f, STUB_POST/L_POST, 1.08))   # rate-limited: the blower's speed
    m_tank = 1.0 + (M_TANK - 1.0)*smooth(ramp(t, 0.6*T_S, 0.74*T_S))
    for sd in sides:
        if "cw" not in sd: break
        cw_ids = sd["cw"]["rings"][1:].reshape(-1); inv_m[cw_ids] = 1.0/(M_PART + (m_tank - 1.0)/len(cw_ids)); inv_m[sd["tank"]] = 1.0/max(1.0, (m_tank - 1.0)/len(cw_ids))
    w.assign(inv_m.astype(np.float32))
    elt = el_target(t, hour)
    nom = set_rests(t, g_post); nom = muscle_rests(nom, elt, hour, q, engaged=True) if A.stage >= 2 else nom
    if A.stage == 4:
        c_d = q[BR].mean(0); n_d = np.cross(q[BR[1]] - q[BR[0]], q[BR[2]] - q[BR[0]]); n_d /= np.linalg.norm(n_d)
        if n_d@(q[VTX] - c_d) < 0: n_d = -n_d
        if t >= T_S:                                                                 # the fine stage closes on the sun once the coarse stage has arrived
            eps = np.cross(n_d, s)                                                   # small rotation that takes the dish axis onto the sun line
            dz = np.clip(0.5*(np.linalg.norm(F - q[VTX]) - G_ORBIT), -0.01, 0.01)    # focus: keep the vertex 4 m from F
            for k, (a_, b_) in enumerate(FINE_COLS):
                r_k = q[b_] - c_d; du = (np.cross(eps, r_k)@n_d)*2.0*dt_f + dz*2.0*dt_f
                u_fine[k] = float(np.clip(u_fine[k] + du, -0.032, 0.032))
        for k, (a_, b_) in enumerate(FINE_COLS):
            kk = np.where((idx[:, 0] == a_) & (idx[:, 1] == b_))[0][0]; nom[kk] = nominal0[kk] + u_fine[k]
    rest.assign(nom.astype(np.float32))
    vt = np.array([vol_target_of(ti, g_post if tb["group"] == "post" else (tb["stub"] + (tb["L"] - tb["stub"])*growth[tb["group"]](t))/tb["L"]) for ti, tb in enumerate(tubes)], np.float32); vtar.assign(vt)
    # azimuth: the deck ring turns the post bases (kinematic)
    R = az_rotate(hour); newpin = (R @ (X0pin - Fxy).T).T + Fxy
    xn = x.numpy(); xn[pin_ids] = newpin.astype(np.float32); x.assign(xn)
    wind = wp.vec3(-A.wind, 0.0, 0.0) if (A.wind > 0 and t > T_S) else wp.vec3(0.0, 0.0, 0.0)
    for k in range(A.substeps):
        f.zero_(); lam.zero_(); vlam.zero_()
        if A.wind > 0 and t > T_S: wp.launch(wind_force, dim=len(tris), inputs=[x, triw, wallw, wind, f], device=DEV)
        wp.launch(predict, dim=n, inputs=[x, v, f, w, GRAV, dt, damp, 8.0, xp], device=DEV)
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
    if A.stage == 1 and fr % 15 == 0:
        tb = tubes[0]; rg = q[tb["rings"]]; zr = rg[:, :, 2].mean(1); rr = np.linalg.norm(rg[:, :, :2] - rg[:, :, :2].mean(1, keepdims=True), axis=2).mean(1)
        k_l = np.where((idx[:, 0] == tb["bc"]) & (idx[:, 1] == tb["cap"]))[0][0]; nomn = rest.numpy()
        ax_ids = np.where((grow_tube == 0) & (kind == 0) & (np.abs(nominal0 - tb["stub"]/tb["n_a"]) < 1e-6))[0]
        actual_ax = np.linalg.norm(q[idx[ax_ids, 0]] - q[idx[ax_ids, 1]], axis=1)
        print(f"  DBG t {t:5.2f} g {g_post:.3f} V {float(vol.numpy()[0]):.3f}/{float(vtar.numpy()[0]):.3f} cap z {q[tb['cap']][2]:.2f} LRA bc-cap rest {nomn[k_l]:.2f} actual {np.linalg.norm(q[tb['cap']] - q[tb['bc']]):.2f} | axial rest {nomn[ax_ids[0]]:.3f} actual mean {actual_ax.mean():.3f} max {actual_ax.max():.3f} | ring z " + " ".join(f"{z:.2f}" for z in zr[::2]) + " | r " + " ".join(f"{r:.3f}" for r in rr[::3]))
    p_eq = []
    for tb in tubes:
        rg = tb["rings"][1:-1]; c0 = q[rg].mean(1, keepdims=True); rr = np.linalg.norm(q[rg] - c0, axis=2).mean()
        chord = 2*tb["radius"]*np.sin(np.pi/N_C); eps = max(0.0, 2*rr*np.sin(np.pi/N_C)/chord - 1.0)
        g_now = g_post if tb["group"] == "post" else (tb["stub"] + (tb["L"] - tb["stub"])*growth[tb["group"]](t))/tb["L"]
        p_eq.append(KE_FAB*eps*chord/((g_now*tb["L"]/tb["n_a"])*rr))                        # hoop tension per unit length / r
    p_eq = np.array(p_eq).round(0)
    if not np.isfinite(q).all(): print("NaN at frame", fr); break
    V_ideal = F - G_ORBIT*s; err = float(np.linalg.norm(q[VTX] - V_ideal)); free = np.where(inv_m > 0)[0]; i_low = int(free[np.argmin(q[free][:, 2])]); z_min = float(q[i_low][2])
    if A.stage == 4:
        n_f = np.cross(q[FRAME[2]] - q[FRAME[0]], q[FRAME[4]] - q[FRAME[0]]); n_f /= np.linalg.norm(n_f)
        if n_f@(q[VTX] - q[FRAME].mean(0)) < 0: n_f = -n_f
        coarse_err = float(np.degrees(np.arccos(np.clip(n_f@s, -1, 1))))
        n_d = np.cross(q[BR[1]] - q[BR[0]], q[BR[2]] - q[BR[0]]); n_d /= np.linalg.norm(n_d)
        if n_d@(q[VTX] - q[BR].mean(0)) < 0: n_d = -n_d
        point_err = float(np.degrees(np.arccos(np.clip(n_d@s, -1, 1))))
    else: point_err = 0.0; coarse_err = 0.0
    mus = [abs(KE_MUS*(np.linalg.norm(q[sd["Mus"]] - q[sd["Ck"]]) - nom[np.where((idx[:, 0] == sd["Mus"]) & (idx[:, 1] == sd["Ck"]))[0][0]])) for sd in sides] if A.stage >= 2 else [0.0]
    if fr % A.rec == 0:
        frames.append(np.round(q*100).astype(np.int16))
        log.append(dict(t=round(t, 2), hour=round(hour, 2), p=round(p), g_post=round(g_post, 3), z_axis=round(z_axis, 3), tank=round(m_tank, 1), el_t=round(float(np.degrees(elt)), 1),
                        err=round(err, 3), point=round(point_err, 3), coarse=round(coarse_err, 2), fine_mm=[round(1e3*u_, 1) for u_ in u_fine], z_min=round(z_min, 2), p_eq=[float(v_) for v_ in p_eq], muscles=[round(m_) for m_ in mus], vtx=[round(float(c), 3) for c in q[VTX]], tgt=[round(float(c), 3) for c in V_ideal]))
    if not A.quiet and fr % (A.fps*2) == 0:
        print(f"t {t:5.1f}  h {hour:5.2f}  p_eq {np.round(p_eq/1e3, 1)} kPa  axis z {z_axis:.2f}  g_post {g_post:.2f}  tank {m_tank:5.1f}  el_t {np.degrees(elt):5.1f}  vtx {np.round(q[VTX], 2)}  ideal {np.round(V_ideal, 2)}  err {err:.2f} m  coarse {coarse_err:.1f} deg  dish {point_err:.2f} deg  cols {np.round(np.array(u_fine)*1e3, 1)} mm  zmin {z_min:.2f}@{i_low}  muscles {np.round(mus, -1)}  ({time.time() - t0:.0f} s)")
# ------------------------------------------------------------------ outputs
Q = np.stack(frames); blob = base64.b64encode(zlib.compress(Q.tobytes(), 9)).decode()
head_pairs = [[head[a_], head[b_]] for a_ in range(len(head)) for b_ in range(a_ + 1, len(head)) if a_ < 2 or b_ == 10 or (2 <= a_ < 10 and b_ == a_ + 9)]
axle_pairs = []
for sd in sides:
    axle_pairs += [[sd["A1"], sd["A2"]]] + ([[sd["A1"], sd["Ck"]], [sd["A2"], sd["Ck"]]] if "Ck" in sd else [])
anim = dict(n_frames=int(Q.shape[0]), n_particles=int(Q.shape[1]), dt=A.rec/A.fps, scale=0.01, z_offset=H.Z_DECK, blob=blob,
            tris=tris.reshape(-1).tolist(), n_tube=int(n), head_lines=head_pairs, axle_lines=axle_pairs, muscles=[[sd["Mus"], sd["Ck"]] for sd in sides] if A.stage >= 2 else [],
            tanks=[sd["tank"] for sd in sides] if A.stage >= 3 else [], fine_rods=[list(p) for p in FINE_RODS], fine_cols=[list(p) for p in FINE_COLS], rim=RIM, frame=FRAME, vtx=VTX, F=FP, rail=dict(c=[float(Fxy[0]), float(Fxy[1])], r=float(Y_POST)), wires=[],
            t_setup=T_S, t_day=A.t_day, h0=A.h0, h1=A.h1, p_max=P_MAX, log=log)
json.dump(anim, open(os.path.join(OUT, "setup_anim.json"), "w"), separators=(",", ":")); json.dump(log, open(os.path.join(OUT, "setup_log.json"), "w"))
errs = np.array([l["err"] for l in log]); ts = np.array([l["t"] for l in log]); pts = np.array([l["point"] for l in log]); crs = np.array([l.get("coarse", 0) for l in log]); track = ts > T_S
print(f"\nframes {Q.shape[0]} x {Q.shape[1]} particles, {len(tris)} triangles, {n_spr} constraints in {n_col} colours -> {len(blob)//1024} KB; wall {time.time() - t0:.0f} s")
if track.any():
    late = track & (ts > T_S + 0.15*A.t_day)
    print(f"setup: vertex error {errs[~track][-1]:.2f} m, coarse pointing {crs[~track][-1]:.1f} deg at t_setup; tracking {A.h0:.0f}-{A.h1:.0f} h: vertex error mean {errs[track].mean():.2f} m max {errs[track].max():.2f} m;")
    print(f"        coarse (frame) pointing mean {crs[track].mean():.2f} deg max {crs[track].max():.2f}; dish pointing with the fine stage: mean {pts[track].mean():.3f} deg, after the first 15 % of the day mean {pts[late].mean():.3f} deg = {pts[late].mean()*17.45:.2f} mrad, max {pts[late].max():.3f} deg; columns at end {log[-1]['fine_mm']} mm; muscles at end {log[-1]['muscles']} N; axis z {log[-1]['z_axis']:.2f} (F {F[2]:.2f})")

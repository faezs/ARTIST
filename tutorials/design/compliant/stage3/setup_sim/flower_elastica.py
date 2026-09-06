#!/usr/bin/env python
"""The flower as soft robots are actually represented: Cosserat rods (PyElastica, Gazzola et al.) for every slender member -
the stem, the pedicel's boom, the six struts, the spokes of the receptacle ring and of the head - rigid bodies for the ring and
the head, penalty joints between them (spherical at the struts' ends, fixed at the spokes' roots), a servoed fixed joint at the
stem top for the pedicel's slew and luff (its rest rotation is the command), the boom's and the struts' rest lengths as the
length commands (the water), gravity, damping, the dish's aerodynamic load with von Karman gusts and the membrane's own figure,
the env's head law for the schedule (path.py), a calibration dither, DMDc identification and the integral loop, as in
setup_sim5.py. Outputs out/<tag>_log.json, out/<tag>_anim.json (rod polylines), out/<tag>_ident.txt."""
import os, sys, json, time, argparse, numpy as np
import elastica as ea
from elastica import CosseratRod, BaseSystemCollection, Constraints, Forcing, Damping, CallBacks, Connections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, os.path.join(HERE, "..", "tree"))
import physics_hp as H
OUT = os.path.join(HERE, "out")
ap = argparse.ArgumentParser(); ap.add_argument("--t_setup", type=float, default=12.0); ap.add_argument("--t_cal", type=float, default=8.0); ap.add_argument("--t_day", type=float, default=24.0)
ap.add_argument("--fps", type=int, default=30); ap.add_argument("--dt", type=float, default=1e-5); ap.add_argument("--rot_scale", type=float, default=10.0); ap.add_argument("--kt_servo", type=float, default=1e7); ap.add_argument("--doy", type=int, default=80); ap.add_argument("--h0", type=float, default=9.0); ap.add_argument("--h1", type=float, default=15.0)
ap.add_argument("--wind", type=float, default=0.0); ap.add_argument("--wind_from", default="S"); ap.add_argument("--Iu", type=float, default=0.25); ap.add_argument("--L_turb", type=float, default=50.0)
ap.add_argument("--n_zones", type=int, default=5); ap.add_argument("--T_mem", type=float, default=20e3); ap.add_argument("--no_loop", action="store_true"); ap.add_argument("--diag", action="store_true"); ap.add_argument("--watch", action="store_true"); ap.add_argument("--parts", type=int, default=3); ap.add_argument("--k_j", type=float, default=5e8); ap.add_argument("--kt_j", type=float, default=1e6); ap.add_argument("--probe", action="store_true"); ap.add_argument("--tag", default="flower"); ap.add_argument("--quiet", action="store_true")
A = ap.parse_args()
# ------------------------------------------------------------------ geometry (deck z 0; x north; F on the pipe)
G, RC, A_M, SAG = 4.0, 8.0, 2.1, 8.0 - np.sqrt(64 - 2.1**2)
Z_F = 0.35 + np.hypot(G, A_M); F = np.array([0.0, 0.0, Z_F]); Z = np.array([0, 0, 1.0])
S_REC, R_REC, R_PLAT, D_BACK, H_HEX = np.array([3.0, 0.0, 1.0]), 1.5, 1.0, 0.6, 1.2
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
A_DISH, D_DISH, RHO = np.pi*(A_M**2 - 0.5**2), 4.2, 1.03
M_HEAD, M_REC, BETA_MAX = 130.0, 80.0, 36.0
def sun(hour): el, Az, s = H.sun(A.doy, hour); return float(el), float(Az), np.asarray(s, float)
def head_axes(n):
    ref = np.array([-1.0, 0, 0]); xl = ref - n*(ref@n)
    if np.linalg.norm(xl) < 1e-6: xl = np.array([0, 1.0, 0]) - n*n[1]
    xl /= np.linalg.norm(xl); yl = np.cross(n, xl); return xl, yl, n
def plat_points(P, n):
    xl, yl, zl = head_axes(n); Cp = P - D_BACK*n; return [Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG]
def base_points(P, n):
    xl, yl, zl = head_axes(n); Cb = P - (D_BACK + H_HEX)*n; return [Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG]
def leg_lengths(P, n): b = base_points(P, n); p = plat_points(P, n); return np.array([np.linalg.norm(p[j] - b[j]) for j in range(6)])
def jacobian(P, n):
    b = base_points(P, n); p = plat_points(P, n); J = np.zeros((6, 6))
    for j in range(6):
        u = p[j] - b[j]; L = np.linalg.norm(u); u /= L; J[j, :3] = u; J[j, 3:] = np.cross(p[j] - P, u)
    return J
def image_miss(P, n, s):
    r = -s + 2*(s@n)*n; d = F - P; return np.linalg.norm(d - (d@r)*r), np.linalg.norm(d) - G
import path as PT
PT.REACH = (1.0, 4.2); PT.RIM_CAP = 9.9; PT.BETA_MAX = BETA_MAX
PT.LEG_CHECK = lambda P_, n_: (lambda Cb: Cb[2] >= 0.8 and 1.0 <= np.linalg.norm(Cb - S_REC) <= 3.8)(P_ - (D_BACK + H_HEX)*n_)
def schedule():
    hours = np.arange(A.h0, A.h1 + 1e-6, 0.25); poses = []; P_prev = None
    for hr in hours:
        el, Az, s = sun(hr); b = PT.best_pose(s, S_REC, w_move=0.3, P_prev=P_prev)
        if b is None: poses.append(None); continue
        P_prev = b[2]; poses.append((b[2], b[1], b[3]["beta"], b[3]["shadow"]))
    idx = [i for i, p in enumerate(poses) if p is not None]
    for i in range(len(poses)):
        if poses[i] is None: poses[i] = poses[min(idx, key=lambda k: abs(k - i))]
    return hours, poses
HOURS, POSES = schedule(); print(f"schedule: {len(HOURS)} poses, beta {min(p[2] for p in POSES):.0f}-{max(p[2] for p in POSES):.0f} deg")
def pose_at(hour):
    i = int(np.clip(np.searchsorted(HOURS, hour) - 1, 0, len(HOURS) - 2)); w = float(np.clip((hour - HOURS[i])/(HOURS[i + 1] - HOURS[i]), 0, 1))
    P = (1 - w)*POSES[i][0] + w*POSES[i + 1][0]; n = (1 - w)*POSES[i][1] + w*POSES[i + 1][1]; n /= np.linalg.norm(n); return P, n
P_STOW, N_STOW = S_REC + np.array([0, 0, 0.6 + D_BACK + H_HEX]), Z.copy(); P1, n1 = pose_at(A.h0)   # stow: the boom 0.6 m up, the head face-up on the hexapod at its nominal height
# ------------------------------------------------------------------ the Cosserat model
class Sim(BaseSystemCollection, Constraints, Forcing, Damping, CallBacks, Connections): pass
sim = Sim(); E_S, G_S, RHO_S = 200e9, 77e9, 7850.0
def chs(d, t): return np.pi*(d*t - t*t), np.pi/64*(d**4 - (d - 2*t)**4)
def make_rod(p0, p1, d, t, n_el):
    """a steel CHS as a Cosserat rod: solid radius matching EI, density matching the mass (EA comes out 2-3x high, harmless)"""
    Ar, I = chs(d, t); r_I = (4*I/np.pi)**0.25; rho_eff = RHO_S*Ar/(np.pi*r_I**2)
    p0, p1 = np.asarray(p0, float), np.asarray(p1, float); dvec = p1 - p0; L = np.linalg.norm(dvec); dvec /= L
    nrm = np.cross(dvec, Z) if abs(dvec[2]) < 0.9 else np.cross(dvec, np.array([1.0, 0, 0])); nrm /= np.linalg.norm(nrm)
    rod = CosseratRod.straight_rod(n_el, p0, dvec, nrm, L, r_I, rho_eff, youngs_modulus=E_S, shear_modulus=G_S)
    # the explicit step is set by the Timoshenko shear cut-off sqrt(G A_s / (rho I)) of the thinnest member, 1.5e5 rad/s for a 60x4 tube (4e5 in the
    # solid-equivalent rod, whose rotary inertia is rho_eff/rho low): give every element its true tube rotary inertia and scale it by --rot_scale
    # (selective mass scaling: statics and the low modes untouched, the cut-off down by sqrt(rot_scale)); at 10x the 60x4 spokes allow dt 4e-5
    rod.mass_second_moment_of_inertia[:] *= (RHO_S/rho_eff)*A.rot_scale; rod.inv_mass_second_moment_of_inertia[:] = 1.0/rod.mass_second_moment_of_inertia
    for i in range(3):
        for j in range(3):
            if i != j: rod.inv_mass_second_moment_of_inertia[i, j, :] = 0.0
    sim.append(rod); sim.add_forcing_to(rod).using(ea.GravityForces, acc_gravity=np.array([0, 0, -9.81])); sim.dampen(rod).using(ea.AnalyticalLinearDamper, damping_constant=1.0, time_step=A.dt)
    return rod
def make_body(centre, axis, radius, length, mass):
    xl, yl, zl = head_axes(axis); dens = mass/(np.pi*radius**2*length)
    body = ea.Cylinder(np.asarray(centre) - 0.5*length*axis, axis, xl, length, radius, dens); sim.append(body)
    sim.add_forcing_to(body).using(ea.GravityForces, acc_gravity=np.array([0, 0, -9.81])); return body
Cb0 = P_STOW - (D_BACK + H_HEX)*N_STOW
stem = make_rod([S_REC[0], S_REC[1], 0.0], S_REC, 0.215, 0.009, 2)
boom = make_rod(S_REC, Cb0, 0.219, 0.008, 3)
rec = make_body(Cb0, N_STOW, R_REC, 0.10, M_REC)
head = make_body(P_STOW - 0.15*N_STOW, N_STOW, A_M, 0.30, M_HEAD)       # its centre 0.15 m behind the vertex; the vertex = centre + 0.15 d3
B0, Pp0 = base_points(P_STOW, N_STOW), plat_points(P_STOW, N_STOW)
struts = [make_rod(B0[j], Pp0[j], 0.085, 0.0053, 3) for j in range(6)] if A.parts >= 2 else []
rec_spokes, head_spokes = [], []                    # the receptacle ring and the calyx are rigid bodies: the strut ends sit on them at offsets (radial 60x4 spokes tried first bent 10 cm under 5 kN)
K_J, NU_J, KT_J, NUT_J = A.k_j, 1e-4*A.k_j, A.kt_j, 200.0    # joint springs: k 5e8 (the struts' EA/L is 1.8e8), kt 1e6 (a spoke element's EI/l is 7e4); explicit limits k dt^2/m, kt dt^2/I << 1, nu dt/m, nut dt/I << 1
class ServoJoint(ea.FixedJoint):
    """a fixed joint whose rest rotation is a command: "stem" is the pedicel's slew and luff at the stem top, "wrist" the receptacle's tilt on the boom tip
    (the boom points from the stem top to the receptacle centre, which is not the head's axis: without the wrist the receptacle, and with it the head, would be slaved to the boom direction)"""
    cmd = {"stem": np.eye(3), "wrist": np.eye(3)}
    def __init__(self, k, nu, kt, nut=0.0, key="stem"):
        super().__init__(k, nu, kt, nut); self.key = key
    @property
    def rest_rotation_matrix(self): return ServoJoint.cmd[self.key]
    @rest_rotation_matrix.setter
    def rest_rotation_matrix(self, v): pass
class OffsetSphericalJoint(ea.FreeJoint):
    """a ball joint between a material point of a rigid body (system one, offset r_loc in its frame) and a rod end node (system two)"""
    def __init__(self, k, nu, r_loc):
        super().__init__(k, nu); self.r_loc = np.asarray(r_loc, float)
    def apply_forces(self, system_one, index_one, system_two, index_two, time=0.0):
        D = system_one.director_collection[:, :, 0]; xb = system_one.position_collection[:, 0]; r = D.T@self.r_loc
        om_w = D.T@system_one.omega_collection[:, 0]; xa = xb + r; va = system_one.velocity_collection[:, 0] + np.cross(om_w, r)
        f = self.k*(xa - system_two.position_collection[:, index_two]) + self.nu*(va - system_two.velocity_collection[:, index_two])   # on the rod node
        system_two.external_forces[:, index_two] += f; system_one.external_forces[:, 0] -= f; system_one.external_torques[:, 0] += D@np.cross(r, -f)
    def apply_torques(self, system_one, index_one, system_two, index_two, time=0.0): pass
def rest_rot(sa, ia, sb, ib):
    """the built relative rotation C_12 = D1 D2^T that a fixed joint must keep (its default is the identity: aligned directors)"""
    return sa.director_collection[:, :, ia]@sb.director_collection[:, :, ib].T
sim.constrain(stem).using(ea.OneEndFixedBC, constrained_position_idx=(0,), constrained_director_idx=(0,))
ServoJoint.cmd["stem"] = rest_rot(stem, -1, boom, 0); ServoJoint.cmd["wrist"] = rest_rot(boom, -1, rec, 0)
sim.connect(stem, boom, first_connect_idx=-1, second_connect_idx=0).using(ServoJoint, k=K_J, nu=NU_J, kt=A.kt_servo, nut=1e-4*A.kt_servo, key="stem")
sim.connect(boom, rec, first_connect_idx=-1, second_connect_idx=0).using(ServoJoint, k=K_J, nu=NU_J, kt=A.kt_servo, nut=1e-4*A.kt_servo, key="wrist")
for j in range(len(struts)):
    sim.connect(rec, struts[j], first_connect_idx=0, second_connect_idx=0).using(OffsetSphericalJoint, k=K_J, nu=NU_J, r_loc=rec.director_collection[:, :, 0]@(B0[j] - rec.position_collection[:, 0]))
    sim.connect(head, struts[j], first_connect_idx=0, second_connect_idx=-1).using(OffsetSphericalJoint, k=K_J, nu=NU_J, r_loc=head.director_collection[:, :, 0]@(Pp0[j] - head.position_collection[:, 0]))
class AxialDamper(ea.NoForces):
    """a dashpot in parallel with each element's axial spring (a jack's oil, a screw's friction): PyElastica 1.0 has no material damping, and an undamped
    steel strut rings at its 1.3 kHz axial mode for tens of frames after every change of command rate (forces of +-100 kN were read from that ringing)"""
    def __init__(self, c): super().__init__(); self.c = c
    def apply_forces(self, system, time=0.0):
        x = system.position_collection; v = system.velocity_collection; tvec = x[:, 1:] - x[:, :-1]; tvec = tvec/np.linalg.norm(tvec, axis=0)
        f = self.c*np.sum((v[:, 1:] - v[:, :-1])*tvec, axis=0)*tvec          # on the element's far node: opposes the elongation rate
        system.external_forces[:, 1:] -= f; system.external_forces[:, :-1] += f
for r_ in struts: sim.add_forcing_to(r_).using(AxialDamper, c=5e4)           # zeta ~0.3 on the strut's axial mode (EA/l 1.5e9 N/m, 5 kg per element)
sim.add_forcing_to(boom).using(AxialDamper, c=2e5)
LOAD = {"F": np.zeros(3), "M": np.zeros(3)}
class HeadLoads(ea.NoForces):
    """the dish's aerodynamic load (set per frame) and the head's damping, on the rigid head"""
    def apply_forces(self, system, time=0.0):
        v = system.velocity_collection[:, 0]; system.external_forces[:, 0] += LOAD["F"] - 300.0*v
    def apply_torques(self, system, time=0.0):
        D = system.director_collection[:, :, 0]; om = system.omega_collection[:, 0]
        system.external_torques[:, 0] += D@LOAD["M"] - 2000.0*om
sim.add_forcing_to(head).using(HeadLoads)
BOOM_D0 = boom.director_collection[:, :, 0].copy(); STEM_D1 = stem.director_collection[:, :, -1].copy()
sim.finalize(); stepper = ea.PositionVerlet(); dt = A.dt; steps_per_frame = int(round(1.0/(A.fps*dt)))
if A.probe:
    allsys = [("stem", stem), ("boom", boom), ("rec", rec), ("head", head)] + [(f"strut{j}", r) for j, r in enumerate(struts)]
    def nan_report(tag):
        bad = []
        for nm, sy in allsys:
            for attr in ("position_collection", "velocity_collection", "director_collection", "omega_collection", "external_forces", "external_torques"):
                a = getattr(sy, attr, None)
                if a is not None and not np.isfinite(a).all(): bad.append(f"{nm}.{attr}")
            for attr in ("rest_lengths", "lengths", "mass", "mass_second_moment_of_inertia", "inv_mass_second_moment_of_inertia", "rest_voronoi_lengths"):
                a = getattr(sy, attr, None)
                if a is not None and not np.isfinite(np.asarray(a, float)).all(): bad.append(f"{nm}.{attr}")
        print(tag, "NaN in:", bad[:12] if bad else "none")
    nan_report("initial"); tt_ = 0.0
    for k_ in range(12):
        for _ in range(40): stepper.step(sim, tt_, dt); tt_ += dt
        vm = sorted(((nm, float(np.nanmax(np.abs(sy.velocity_collection)))) for nm, sy in allsys), key=lambda kv: -kv[1])[:3]
        om = sorted(((nm, float(np.nanmax(np.abs(sy.omega_collection)))) for nm, sy in allsys), key=lambda kv: -kv[1])[:2]
        print(f"step {40*(k_ + 1)}: |v| {[(a, f'{b:.1e}') for a, b in vm]} |omega| {[(a, f'{b:.1e}') for a, b in om]}")
        if any(not np.isfinite(sy.position_collection).all() for _, sy in allsys): nan_report("first NaN"); break
    names = ["stem", "boom"] + [f"rspoke{j}" for j in range(len(rec_spokes))] + [f"strut{j}" for j in range(len(struts))] + [f"hspoke{j}" for j in range(len(head_spokes))]
    allrods = [stem, boom] + rec_spokes + struts + head_spokes; tt_ = 0.0
    for k_ in range(6):
        for _ in range(500): stepper.step(sim, tt_, dt); tt_ += dt
        vmax = {nm: float(np.abs(r.velocity_collection).max()) for nm, r in zip(names, allrods)}; worst = sorted(vmax.items(), key=lambda kv: -kv[1])[:4]
        print(f"after {tt_*1e3:.0f} ms: worst |v| {worst}; head v {np.abs(head.velocity_collection).max():.2e} rec v {np.abs(rec.velocity_collection).max():.2e}")
    sys.exit(0)
# ------------------------------------------------------------------ helpers
def head_pose():
    D = head.director_collection[:, :, 0]; n = D[2]; n = n/np.linalg.norm(n); P = head.position_collection[:, 0] + 0.15*n; return P.copy(), n
def head_normal_dir(): return head.director_collection[:, :, 0][2].copy()
def set_boom(Cb_cmd, n_cmd):
    """the pedicel's command: boom length, boom orientation (the stem-top servo) and the receptacle's axis n_cmd (the wrist servo, relative to the commanded boom)"""
    dvec = Cb_cmd - S_REC; L = np.linalg.norm(dvec); dvec /= L; set_rest(boom, L)
    d3_0 = BOOM_D0[2]; ax = np.cross(d3_0, dvec); sa = np.linalg.norm(ax); ca = float(np.clip(d3_0@dvec, -1, 1))
    if sa < 1e-9: R = np.eye(3) if ca > 0 else -np.eye(3)
    else:
        ax /= sa; Kx = np.array([[0, -ax[2], ax[1]], [ax[2], 0, -ax[0]], [-ax[1], ax[0], 0]]); R = np.eye(3) + Kx*sa + Kx@Kx*(1 - ca)     # minimal rotation taking the built boom axis to the command
    D2 = BOOM_D0@R.T                                                          # rows d1, d2, d3 rotated with the boom
    ServoJoint.cmd["stem"] = STEM_D1@D2.T      # a RELATIVE servo (encoder on the joint): the rest rotation is a function of time only, so the joint is a conservative spring;
    # taking the stem's actual tip director here (an absolute-attitude servo on a flexible stem) pumped energy into the stem-boom system and it fluttered at 31/s
    xl, yl, zl = head_axes(n_cmd); Drec = np.vstack([xl, np.cross(zl, xl), zl]); ServoJoint.cmd["wrist"] = D2@Drec.T   # the receptacle's directors as ea.Cylinder builds them: normal, axis x normal, axis
def set_rest(rod, L):
    rod.rest_lengths[:] = L/rod.n_elems; rod.rest_voronoi_lengths[:] = L/rod.n_elems             # the bending strain's reference length follows the telescoping member
def set_struts(L_cmd):
    for j in range(6): set_rest(struts[j], L_cmd[j])
def karman_series(U, Iu, Lt, T_total, fps, seed=7):
    rng_ = np.random.default_rng(seed); f = np.linspace(0.01, 3.0, 300); df = f[1] - f[0]; sig = Iu*U
    S = sig*sig*(4*Lt/U)/(1 + 70.8*(f*Lt/U)**2)**(5/6); amp = np.sqrt(2*S*df); ph = rng_.uniform(0, 2*np.pi, len(f))
    t = np.arange(0, T_total + 1.0/fps, 1.0/fps); v = U + (amp[None, :]*np.cos(2*np.pi*f[None, :]*t[:, None] + ph[None, :])).sum(1); return t, np.maximum(v, 0.0)
T_S, T_C = A.t_setup, A.t_cal; T_TOTAL = T_S + T_C + A.t_day
WIND_T, WIND_V = karman_series(A.wind, A.Iu, A.L_turb, T_TOTAL, A.fps) if A.wind > 0 else (None, None)
def wind_now(t): return 0.0 if (A.wind <= 0 or t < T_S) else float(np.interp(t, WIND_T, WIND_V))
def dish_load(vw, n):
    if vw <= 0: return np.zeros(3), np.zeros(3), 0.0
    what = np.array([-1.0, 0, 0]) if A.wind_from == "N" else np.array([1.0, 0, 0]); qd = 0.5*RHO*vw*vw; ca = float(n@what); into = ca < 0
    cd_n = 1.40 if into else 1.05; Fd = qd*A_DISH*(0.25 + (cd_n - 0.25)*ca*ca); Fv = Fd*what
    nperp = n - ca*what; npn = np.linalg.norm(nperp)
    if npn > 1e-6: Fv = Fv + qd*A_DISH*(0.5 if into else 0.4)*abs(2*ca*np.sqrt(max(1 - ca*ca, 0.0)))*(nperp/npn)*(1.0 if into else -1.0)
    ax = np.cross(n, what if ca >= 0 else -what); sa = np.linalg.norm(ax); Mv = ax/sa*qd*A_DISH*D_DISH*(0.15 if into else 0.10)*2*abs(ca)*sa if sa > 1e-6 else np.zeros(3)
    return Fv, Mv, Fd
def smooth(u): return u*u*(3 - 2*u)
def ramp(t, t0, t1): return float(np.clip((t - t0)/(t1 - t0), 0.0, 1.0))
# ------------------------------------------------------------------ run
rng = np.random.default_rng(3); dither = np.zeros(6); dither_t = np.zeros(6); u_fb = np.zeros(6); Kgain = None; ident = {}; ctrl_name = "feedforward only"; cal = []
log, frames = [], []; rods = [stem, boom] + struts
n_frames = int(round(T_TOTAL*A.fps)); t0 = time.time(); tt = 0.0; dt_f = 1.0/A.fps
for fr in range(n_frames + 1):
    t = fr*dt_f; hour = A.h0 if t < T_S + T_C else A.h0 + (A.h1 - A.h0)*(t - T_S - T_C)/A.t_day
    el, Az, s = sun(hour)
    if t < T_S:
        u_ = smooth(ramp(t, 0.05*T_S, 0.95*T_S)); P_t = (1 - u_)*P_STOW + u_*P1; n_t = (1 - u_)*N_STOW + u_*n1; n_t /= np.linalg.norm(n_t)
    else: P_t, n_t = pose_at(hour)
    Cb_t = P_t - (D_BACK + H_HEX)*n_t
    if T_S <= t < T_S + T_C:
        if int(t/0.5) != int((t - dt_f)/0.5): dither_t = rng.choice([-1.0, 1.0], 6)*0.002
        dither = dither + (dither_t - dither)*(dt_f/0.3)
    else: dither = dither*(1 - dt_f/0.3)
    P, nd = head_pose(); err = np.concatenate([P - P_t, np.cross(n_t, nd)]) if t >= T_S else np.zeros(6)
    if abs(t - (T_S + T_C)) < 0.5*dt_f and cal and not A.no_loop:
        X = np.array([c[0] for c in cal]); U = np.array([c[1] for c in cal]); dU = np.diff(U, axis=0); dX = np.diff(X, axis=0)
        # DMDc in velocity form with three input lags (a time-delay embedding of the command), ridge-regularised, on the pose rows only: dX_k = B0 dU_k + B1 dU_k-1 + B2 dU_k-2;
        # the static gain is B0 + B1 + B2; 30 % hold-out against persistence
        NL = 3; Phi = np.hstack([dU[NL - 1 - j: len(dU) - j] for j in range(NL)]); Y = dX[NL - 1:]; ntr = int(0.7*len(Y))
        lam = 1e-3*np.trace(Phi[:ntr].T@Phi[:ntr])/Phi.shape[1]; M = np.linalg.solve(Phi[:ntr].T@Phi[:ntr] + lam*np.eye(Phi.shape[1]), Phi[:ntr].T@Y[:ntr]).T
        pred = Phi[ntr:]@M.T; e_m = np.sqrt(np.mean((pred - Y[ntr:])**2, 0)); e_p = np.sqrt(np.mean(Y[ntr:]**2, 0))
        skill = 1 - np.mean(e_m/np.maximum(e_p, 1e-9)); Gid = sum(M[:, 6*j:6*(j + 1)] for j in range(NL)); Jan = np.linalg.inv(jacobian(P_t, n_t)); rel = np.linalg.norm(Gid - Jan)/np.linalg.norm(Jan)
        if skill >= 0.5 and rel < 0.3: Kgain = np.linalg.pinv(Gid)      # one-step skill does not qualify a gain for the loop: at rel 0.4-0.5 the loop hunted +-4 cm in yaw (the gain's weak direction) while F held; ctrl_name = f"integral loop through the IDENTIFIED gain (skill {skill:.2f}, {100*rel:.0f} % from the analytic Jacobian)"
        else: Kgain = None; ctrl_name = f"integral loop through the analytic Jacobian (identified gain skill {skill:.2f}, {100*rel:.0f} % off)"
        ident = dict(skill=float(skill), gain_rel_err=float(rel), rms_model=e_m.tolist(), rms_persist=e_p.tolist(), controller=ctrl_name); print(ctrl_name)
    if t >= T_S + T_C and not A.no_loop:
        Ginv = Kgain if Kgain is not None else jacobian(P_t, n_t)
        u_fb = np.clip(u_fb + np.clip(-1.5*dt_f*(Ginv@err), -0.003, 0.003), -0.04, 0.04)
    L_cmd = leg_lengths(P_t, n_t) + dither + u_fb
    vw = wind_now(t); Fv, Mv, Fd = dish_load(vw, nd); LOAD["F"], LOAD["M"] = Fv, Mv
    if fr == 0: CMD_PREV = (Cb_t.copy(), n_t.copy(), L_cmd.copy())
    for k_ in range(steps_per_frame):                                          # the commands ramp through the frame: a step of 0.2 mm in a 5e8 N/m strut is a 100 kN hammer blow
        w_ = (k_ + 1.0)/steps_per_frame; nk = (1 - w_)*CMD_PREV[1] + w_*n_t; set_boom((1 - w_)*CMD_PREV[0] + w_*Cb_t, nk/np.linalg.norm(nk)); set_struts((1 - w_)*CMD_PREV[2] + w_*L_cmd)
        stepper.step(sim, tt, dt); tt += dt
    CMD_PREV = (Cb_t.copy(), n_t.copy(), L_cmd.copy())
    P, nd = head_pose()
    if A.watch:
        allsys_ = [("stem", stem), ("boom", boom), ("rec", rec), ("head", head)] + [(f"strut{j}", r) for j, r in enumerate(struts)]
        print(f"  watch t {t:6.3f} " + " ".join(f"{nm} v {np.abs(sy.velocity_collection).max():.2e} w {np.abs(sy.omega_collection).max():.2e}" for nm, sy in allsys_) + f" | boom L {boom.rest_lengths.sum():.3f} legs {np.round(L_cmd, 4)}")
    if not np.isfinite(P).all(): print("diverged at t", t); break
    miss, defoc = image_miss(P, nd, s); slope_mem = 5.89e-3*(vw/9.0)**2*(20e3/A.T_mem)/A.n_zones if vw > 0 else 0.0; miss_mem = 2*slope_mem*G; miss_tot = np.hypot(miss, miss_mem)
    L_now = np.array([np.linalg.norm(struts[j].position_collection[:, -1] - struts[j].position_collection[:, 0]) for j in range(6)])
    f_leg = np.array([float(np.mean(struts[j].internal_stress[2, :])) for j in range(6)])                        # axial internal force (rod convention: positive in tension)
    rec_err = float(np.linalg.norm(rec.position_collection[:, 0] - Cb_t)); stem_tip = float(np.linalg.norm(stem.position_collection[:, -1] - S_REC))
    if T_S <= t < T_S + T_C: cal.append((np.concatenate([P - P_t, np.cross(n_t, nd)]), dither + u_fb))
    beta = float(np.degrees(np.arccos(np.clip(((F - P)/np.linalg.norm(F - P))@s, -1, 1))))
    frames.append([r.position_collection.T.round(3).tolist() for r in rods] + [[P.round(3).tolist(), (P + 2.0*nd).round(3).tolist()], [rec.position_collection[:, 0].round(3).tolist()]])
    log.append(dict(t=round(t, 2), hour=round(hour, 3), wind=round(vw, 2), miss_cm=round(100*miss, 2), miss_mem_cm=round(100*miss_mem, 2), miss_tot_cm=round(100*miss_tot, 2), rec_err_cm=round(100*rec_err, 2), stem_tip_cm=round(100*stem_tip, 2),
                    defocus_cm=round(100*defoc, 2), beta=round(beta, 1), legs_m=[round(float(l_), 3) for l_ in L_now], f_leg_kN=[round(float(f_)/1e3, 2) for f_ in f_leg], f_dish=round(Fd), P=[round(float(c), 3) for c in P], n=[round(float(c), 4) for c in nd]))
    if A.diag and fr % (A.fps*2) == 0:
        def ang(a, b): return float(np.degrees(np.arccos(np.clip(a@b/np.linalg.norm(a)/np.linalg.norm(b), -1, 1))))
        Db = boom.director_collection[:, :, -1]; Dr = rec.director_collection[:, :, 0]; Ds = stem.director_collection[:, :, -1]; Db0 = boom.director_collection[:, :, 0]
        dev_stem = ang(np.array([1, 0, 0]), np.array([1, 0, 0])); rs = Ds@Db0.T@ServoJoint.cmd["stem"].T; rw = Db@Dr.T@ServoJoint.cmd["wrist"].T
        print(f"  diag t {t:4.1f}: rec centre - Cb_t {np.round(100*(rec.position_collection[:, 0] - Cb_t), 2)} cm; boom tip - Cb_t {np.round(100*(boom.position_collection[:, -1] - Cb_t), 2)} cm; rec axis vs n_t {ang(Dr[2], n_t):.2f} deg; boom end d3 vs command {ang(Db[2], (Cb_t - S_REC)):.2f} deg"
              f"; stem tip slope {ang(Ds[2], Z):.2f} deg; servo deviation stem {np.degrees(np.arccos(np.clip((np.trace(rs) - 1)/2, -1, 1))):.3f} wrist {np.degrees(np.arccos(np.clip((np.trace(rw) - 1)/2, -1, 1))):.3f} deg"
              f"; head P - P_t {np.round(100*(P - P_t), 2)} cm, n vs n_t {ang(nd, n_t):.2f} deg; legs now - cmd {np.round(1e3*(L_now - L_cmd), 1)} mm; boom rest L {boom.rest_lengths.sum():.3f} actual {np.linalg.norm(boom.position_collection[:, -1] - boom.position_collection[:, 0]):.3f}")
        if struts:
            fs = []
            for _ in range(60):
                for __ in range(10): stepper.step(sim, tt, dt); tt += dt
                fs.append([float(np.mean(struts[j].internal_stress[2, :])) for j in range(6)] + [float(np.linalg.norm(struts[0].position_collection[:, -1] - struts[0].position_collection[:, 0])), float(np.abs(struts[0].velocity_collection).max())])
            fs = np.array(fs); print(f"  within 6 ms: leg forces mean {np.round(fs[:, :6].mean(0)/1e3, 1)} kN, min {np.round(fs[:, :6].min(0)/1e3, 1)}, max {np.round(fs[:, :6].max(0)/1e3, 1)}; leg 0 length {fs[:, 6].min():.5f}-{fs[:, 6].max():.5f} m, |v| max {fs[:, 7].max():.3f} m/s")
    if not A.quiet and fr % (A.fps*2) == 0:
        print(f"t {t:5.1f} h {hour:5.2f} wind {vw:4.1f} | miss at F {100*miss:5.1f} cm (+membrane {100*miss_mem:4.1f} -> {100*miss_tot:5.1f}) receptacle off {100*rec_err:4.1f} cm stem tip {100*stem_tip:4.1f} cm | legs {np.round(L_now, 2)} forces {np.round(f_leg/1e3, 1)} kN | hub {np.round(P, 2)} el_n {np.degrees(np.arcsin(nd[2])):4.0f} ({time.time() - t0:.0f} s)")
json.dump(dict(frames=frames, log=log, F=F.tolist(), stem_top=S_REC.tolist(), t_setup=T_S, t_cal=T_C, t_day=A.t_day, wind=A.wind, ident=ident, n_rods=len(rods), cal_X=[c[0].round(6).tolist() for c in cal], cal_U=[c[1].round(6).tolist() for c in cal]), open(os.path.join(OUT, A.tag + "_anim.json"), "w"), separators=(",", ":"))
json.dump(log, open(os.path.join(OUT, A.tag + "_log.json"), "w"))
ts = np.array([l["t"] for l in log]); miss = np.array([l["miss_cm"] for l in log]); mtot = np.array([l["miss_tot_cm"] for l in log]); mmem = np.array([l["miss_mem_cm"] for l in log]); rerr = np.array([l["rec_err_cm"] for l in log]); wv = np.array([l["wind"] for l in log]); day = ts >= T_S + T_C; calm = (ts >= T_S) & (ts < T_S + T_C); setup = ts < T_S
lines = [f"flower (Cosserat rods, PyElastica), {A.tag}: wind {A.wind} m/s mean from the {A.wind_from}, von Karman Iu {A.Iu}; sun {A.h0}-{A.h1} h in {A.t_day} s; setup {T_S} s, calibration {T_C} s; dt {A.dt:.0e}, {len(rods)} rods, 2 rigid bodies; wall {time.time() - t0:.0f} s",
         f"setup: miss at F at the end {miss[setup][-1]:.1f} cm; receptacle off its command {rerr[setup][-1]:.1f} cm",
         f"calibration: miss at F mean {miss[calm].mean():.1f} cm" + (f"; DMDc one-step test RMS dP {np.round(np.array(ident['rms_model'][:3])*1e3, 2)} mm, dtheta {np.round(np.array(ident['rms_model'][3:])*1e3, 2)} mrad vs persistence {np.round(np.array(ident['rms_persist'][:3])*1e3, 2)} mm, {np.round(np.array(ident['rms_persist'][3:])*1e3, 2)} mrad" if ident else ""),
         f"the day ({'feedforward only' if A.no_loop else ctrl_name}): geometric miss at F mean {miss[day].mean():.1f} cm, max {miss[day].max():.1f}; membrane figure {mmem[day].mean():.1f} cm mean; total {mtot[day].mean():.1f} cm mean, {mtot[day].max():.1f} max (half power 4.9); receptacle off its command {rerr[day].mean():.1f} cm mean, {rerr[day].max():.1f} max; stem tip {max(l['stem_tip_cm'] for l in log):.1f} cm max; strut force max {max(max(abs(f_) for f_ in l['f_leg_kN']) for l in log if l['t'] >= T_S):.1f} kN; wind mean {wv[day].mean():.1f}, peak {wv[day].max():.1f} m/s, dish force max {max(l['f_dish'] for l in log)/1e3:.2f} kN"]
print("\n".join(lines)); open(os.path.join(OUT, A.tag + "_ident.txt"), "w").write("\n".join(lines) + "\n")

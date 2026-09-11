"""Screw theory for the mounts: the one vocabulary the megakernel needs.

A mirror is where its foci are. A mount is a list of screws (what it lets the mirror do) and a 6 x 6 compliance
(how far a load moves it). This module is the finite-motion half of the theory that FACT (Hopkins) does not use:

    twist   xi = (v; omega)      a small motion, or a joint's screw: revolute about the line (w, q) is (q x w; w),
                                 prismatic along w is (w; 0)                      [tandoor_screw_render._twist]
    wrench  W  = (f; m)          a load, or a constraint; xi . W is power
    exp     T  = exp([xi] theta) the finite screw motion (Chasles): every rigid motion is one
    adjoint Ad_T                 moves twists and wrenches between frames; a compliance moves as A C A^T
    chain   T  = exp(S1 q1) exp(S2 q2) ... T0    the product of exponentials over the space-frame screws at home
    series  C  = sum_i A_i C_i A_i^T             compliances add at one point; stiffnesses add in parallel

Conventions: twists (v; omega) and wrenches (f; m), both 6-vectors, both in WORLD orientation unless a function says
local; the plain dot product is the reciprocal product. A 6 x 6 mixes metres with radians: never eigen-decompose one
without the length scaling tandoor_screw_render.evaluate applies.

The kernel side: mount_solve reads one row of MECHW floats per agent (mech_rows below), walks the screws innermost
first from the home pose, applies the elastic twist and C W, and hands the trace the head's vertex and axis. The
torch twin here (apply_rows) is what tandoor_mount_batch runs on CUDA/CPU, and what the parity tests compare.
"""
import math
import numpy as np
import torch

# ---- the kernel row: [0] n_screws [1] flags (1: elastic twist, 2: C W) [8 + 8 i] screw i (w, q, pitch, theta)
#      [72..77] home vertex and axis [80..85] elastic twist (v; omega) [88..123] C (6 x 6 row-major) [124..129] W (f; m)
MECHW, NS_MAX = 136, 8
OFF_SCREW, OFF_HOME, OFF_XI, OFF_C, OFF_W = 8, 72, 80, 88, 124
PRISMATIC = 1e9                      # the pitch that marks a slide (the kernel tests h > 1e8)


# ======================================================================================================================
# the algebra, batched torch (B, ...) - float32 on the device the envs run on, float64 in the tests
# ======================================================================================================================
def hat(w):
    """(B,3) -> (B,3,3) skew matrix, [w] x = w x x"""
    B = w.shape[0]; K = torch.zeros(B, 3, 3, dtype=w.dtype, device=w.device)
    K[:, 0, 1] = -w[:, 2]; K[:, 0, 2] = w[:, 1]; K[:, 1, 0] = w[:, 2]
    K[:, 1, 2] = -w[:, 0]; K[:, 2, 0] = -w[:, 1]; K[:, 2, 1] = w[:, 0]
    return K


def rodrigues(w, theta):
    """(B,3) unit axis, (B,) angle -> (B,3,3) rotation"""
    K = hat(w); s, c = torch.sin(theta)[:, None, None], torch.cos(theta)[:, None, None]
    I = torch.eye(3, dtype=w.dtype, device=w.device)[None]
    return I + s*K + (1 - c)*torch.bmm(K, K)


def exp_screw(w, q, h, theta):
    """the finite screw motion about the line (w, q) with pitch h by theta: (B,4,4). h >= PRISMATIC/10 is a slide
    along w by theta (metres); otherwise theta is radians and the point q on the axis stays put (h = 0)."""
    B = w.shape[0]; T = torch.eye(4, dtype=w.dtype, device=w.device)[None].repeat(B, 1, 1)
    slide = h > PRISMATIC/10
    wn = w/torch.linalg.norm(w, dim=1, keepdim=True).clamp(min=1e-12)
    R = rodrigues(wn, torch.where(slide, torch.zeros_like(theta), theta))
    p_rev = q - torch.bmm(R, q[:, :, None])[:, :, 0] + (h*theta)[:, None]*wn          # (I - R) q + h theta w
    p_sl = theta[:, None]*wn
    T[:, :3, :3] = R; T[:, :3, 3] = torch.where(slide[:, None], p_sl, p_rev)
    return T


def compose(*Ts):
    out = Ts[0]
    for T in Ts[1:]: out = torch.bmm(out, T)
    return out


def inverse(T):
    R = T[:, :3, :3]; p = T[:, :3, 3]
    Ti = torch.zeros_like(T); Rt = R.transpose(1, 2)
    Ti[:, :3, :3] = Rt; Ti[:, :3, 3] = -torch.bmm(Rt, p[:, :, None])[:, :, 0]; Ti[:, 3, 3] = 1.0
    return Ti


def ad_twist(T):
    """(B,4,4) -> (B,6,6): xi_s = Ad xi_b for a twist (v; omega) written in frame b, T taking b's coordinates to s's"""
    R = T[:, :3, :3]; p = T[:, :3, 3]; B = T.shape[0]
    A = torch.zeros(B, 6, 6, dtype=T.dtype, device=T.device)
    A[:, :3, :3] = R; A[:, 3:, 3:] = R; A[:, :3, 3:] = torch.bmm(hat(p), R)
    return A


def ad_wrench(T):
    """(B,4,4) -> (B,6,6): W_s = Ad W_b for a wrench (f; m). Equal to ad_twist(inverse(T))^T, which the tests check."""
    R = T[:, :3, :3]; p = T[:, :3, 3]; B = T.shape[0]
    A = torch.zeros(B, 6, 6, dtype=T.dtype, device=T.device)
    A[:, :3, :3] = R; A[:, 3:, 3:] = R; A[:, 3:, :3] = torch.bmm(hat(p), R)
    return A


def transport_compliance(C_b, T):
    """a compliance written in frame b, moved to frame s: C_s = A C_b A^T with A = ad_twist(T)"""
    A = ad_twist(T); return torch.bmm(torch.bmm(A, C_b), A.transpose(1, 2))


def transport_stiffness(K_b, T):
    A = ad_wrench(T); return torch.bmm(torch.bmm(A, K_b), A.transpose(1, 2))


def frame_at(p, R=None):
    """(B,3) origin and optional (B,3,3) orientation -> (B,4,4)"""
    B = p.shape[0]; T = torch.eye(4, dtype=p.dtype, device=p.device)[None].repeat(B, 1, 1)
    if R is not None: T[:, :3, :3] = R
    T[:, :3, 3] = p; return T


def frame_along(x_dir, p):
    """(B,4,4) with the first axis along x_dir at p: a beam element's local frame"""
    x = x_dir/torch.linalg.norm(x_dir, dim=1, keepdim=True).clamp(min=1e-12)
    ref = torch.zeros_like(x); ref[:, 2] = 1.0
    bad = (x*ref).sum(1).abs() > 0.9
    alt = torch.zeros_like(x); alt[:, 0] = 1.0
    ref = torch.where(bad[:, None], alt, ref)
    y = torch.cross(ref, x, dim=1); y = y/torch.linalg.norm(y, dim=1, keepdim=True).clamp(min=1e-12)
    z = torch.cross(x, y, dim=1)
    return frame_at(p, torch.stack([x, y, z], 2))


def poe(screws, theta, T0):
    """the product of exponentials: screws (B,N,7) = (w, q, pitch) at HOME in the world, theta (B,N), T0 (B,4,4) the
    home frame -> (B,4,4). Screw 0 is the base joint, screw N-1 the one nearest the head."""
    B, N, _ = screws.shape
    T = T0
    for i in range(N - 1, -1, -1):
        T = torch.bmm(exp_screw(screws[:, i, 0:3], screws[:, i, 3:6], screws[:, i, 6], theta[:, i]), T)
    return T


def move_points(T, P):
    """(B,4,4) on (B,P,3) points"""
    return torch.einsum("bij,bpj->bpi", T[:, :3, :3], P) + T[:, :3, 3][:, None, :]


def apply_twist(xi, C, n):
    """the finite screw motion of a small twist (v; omega) at the vertex: rotates the axis, translates the vertex"""
    om = xi[:, 3:]; v = xi[:, :3]; a = torch.linalg.norm(om, dim=1)
    w = om/a.clamp(min=1e-12)[:, None]
    R = rodrigues(w, a)
    n2 = torch.where((a > 1e-12)[:, None], torch.bmm(R, n[:, :, None])[:, :, 0], n)
    return C + v, n2/torch.linalg.norm(n2, dim=1, keepdim=True).clamp(min=1e-12)


# ======================================================================================================================
# elements: what a 6 x 6 is for each thing the register has synthesised
# ======================================================================================================================
def beam_compliance(L, EIy, EIz, GJ, EA):
    """a cantilever along local +x, root at -L, tip at the origin: the tip's twist (v; omega) per wrench (f; m) at the
    tip, Euler-Bernoulli. (B,) tensors -> (B,6,6), symmetric."""
    B = L.shape[0]; C = torch.zeros(B, 6, 6, dtype=L.dtype, device=L.device)
    L2, L3 = L*L, L*L*L
    C[:, 0, 0] = L/EA
    C[:, 1, 1] = L3/(3*EIz); C[:, 1, 5] = L2/(2*EIz); C[:, 5, 1] = L2/(2*EIz); C[:, 5, 5] = L/EIz
    C[:, 2, 2] = L3/(3*EIy); C[:, 2, 4] = -L2/(2*EIy); C[:, 4, 2] = -L2/(2*EIy); C[:, 4, 4] = L/EIy
    C[:, 3, 3] = L/GJ
    return C


def chs_section(d, t, E=200e9, nu=0.3):
    """EI, GJ, EA of a steel circular hollow section"""
    di = d - 2*t; A = math.pi/4*(d*d - di*di); I = math.pi/64*(d**4 - di**4)
    G = E/(2*(1 + nu)); return E*I, G*2*I, E*A


def series_at(elements, P_ref):
    """elements: list of (C_local (B,6,6), T_tip (B,4,4)) - each element's tip frame in the world. Returns the
    compliance at the world point P_ref (B,3), world orientation: C = sum A_i C_i A_i^T, A_i = Ad(T_ref^-1 T_i)."""
    Tr = inverse(frame_at(P_ref)); out = None
    for C_loc, T_tip in elements:
        A = ad_twist(torch.bmm(Tr, T_tip)); Ci = torch.bmm(torch.bmm(A, C_loc), A.transpose(1, 2))
        out = Ci if out is None else out + Ci
    return out


def parallel_at(stiffnesses, P_ref):
    """stiffnesses: list of (K_local (B,6,6), T (B,4,4)) -> K at P_ref, world orientation"""
    Tr = inverse(frame_at(P_ref)); out = None
    for K_loc, T in stiffnesses:
        A = ad_wrench(torch.bmm(Tr, T)); Ki = torch.bmm(torch.bmm(A, K_loc), A.transpose(1, 2))
        out = Ki if out is None else out + Ki
    return out


def stiffness_from_members(members, origin):
    """tandoor_screw_render's realised members -> the 6 x 6 stiffness at `origin` (numpy, (f; m) per (v; omega)),
    each blade a stiff line along its length and a soft one normal to its plane, as evaluate() assembles it."""
    from tandoor_screw_render import _wrenches
    K = np.zeros((6, 6))
    for sw, k, _, _ in _wrenches(members, origin=origin): K += k*np.outer(sw, sw)
    return K


def invert_compliance(K, k_free=None, w_free=None):
    """C = K^-1 with the freedom held by an actuator of stiffness k_free along the wrench direction w_free (6,)"""
    Kf = K.clone()
    if k_free is not None:
        wf = w_free/torch.linalg.norm(w_free, dim=1, keepdim=True).clamp(min=1e-12)
        Kf = Kf + k_free[:, None, None]*torch.einsum("bi,bj->bij", wf, wf)
    return torch.linalg.pinv(Kf)


# ======================================================================================================================
# the catalogue: the frame types the register has drawn, as screws at home
# ======================================================================================================================
def _e(B, x, y, z, dtype, device):
    return torch.tensor([x, y, z], dtype=dtype, device=device)[None].expand(B, 3)


def hashemi_chain(Pf, g_orb, dtype=torch.float32, device="cpu"):
    """Hashemi's machine: the vertex on the sphere of radius g_orb about F, two rotations about F (azimuth about the
    vertical, elevation about the horizontal), and the beta offset the kernel's schedule adds - the head sent round F
    by beta and its normal tilted back by beta/2 so that it bisects the sun and the beam. Home: pointing north, level.
    Joints (rad): az, el, beta, -beta/2. Pf (B,3)."""
    B = Pf.shape[0]; z = _e(B, 0, 0, 1, dtype, device); my = _e(B, 0, -1, 0, dtype, device); y = -my
    x = _e(B, 1, 0, 0, dtype, device)
    C0 = Pf - g_orb*x
    screws = torch.stack([torch.cat([z, Pf, torch.zeros(B, 1, dtype=dtype, device=device)], 1),
                          torch.cat([my, Pf, torch.zeros(B, 1, dtype=dtype, device=device)], 1),
                          torch.cat([y, Pf, torch.zeros(B, 1, dtype=dtype, device=device)], 1),
                          torch.cat([y, C0, torch.zeros(B, 1, dtype=dtype, device=device)], 1)], 1)
    return dict(names=["az", "el", "beta", "half"], screws=screws, C0=C0, n0=x)


def hashemi_theta(el_deg, az_deg, beta_deg):
    return torch.stack([torch.deg2rad(az_deg), torch.deg2rad(el_deg), torch.deg2rad(beta_deg), -0.5*torch.deg2rad(beta_deg)], 1)


def pedicel_chain(T0, D_REC, dtype=torch.float32, device="cpu"):
    """the flower's pedicel: slew about the vertical at the stem top, luff about the horizontal, the boom's slide,
    pitch and yaw at the wrist (tandoor_flower_env.pedicel_fk). Home: the boom along +x at zero extension, the head
    D_REC in front of the wrist. Joints: slew, luff (rad), ext (m), pitch, yaw (rad). T0 (B,3)."""
    B = T0.shape[0]; z = _e(B, 0, 0, 1, dtype, device); my = _e(B, 0, -1, 0, dtype, device); x = _e(B, 1, 0, 0, dtype, device)
    o = torch.zeros(B, 1, dtype=dtype, device=device); pr = torch.full((B, 1), PRISMATIC, dtype=dtype, device=device)
    screws = torch.stack([torch.cat([z, T0, o], 1), torch.cat([my, T0, o], 1), torch.cat([x, T0, pr], 1),
                          torch.cat([my, T0, o], 1), torch.cat([z, T0, o], 1)], 1)
    return dict(names=["slew", "luff", "ext", "pitch", "yaw"], screws=screws, C0=T0 + D_REC*x, n0=x)


def pedicel_theta(q):
    """q: dict of (B,) tensors slew, luff, pitch, yaw in degrees and ext in metres (the envs' F['q_*'])"""
    return torch.stack([torch.deg2rad(q["slew"]), torch.deg2rad(q["luff"]), q["ext"], torch.deg2rad(q["pitch"]),
                        torch.deg2rad(q["yaw"])], 1)


def crown_screws(C0, n0, xl0, yl0, dtype=torch.float32, device="cpu"):
    """the fine stage at the vertex, 3 DOF Type 1: tip about -xl, tilt about -yl (the signs the fast env's normal
    perturbation uses: n + fine0 yl - fine1 xl), piston along the axis. Appended innermost to any chain."""
    B = C0.shape[0]; o = torch.zeros(B, 1, dtype=dtype, device=device); pr = torch.full((B, 1), PRISMATIC, dtype=dtype, device=device)
    return torch.stack([torch.cat([-xl0, C0, o], 1), torch.cat([-yl0, C0, o], 1), torch.cat([n0, C0, pr], 1)], 1)


def fork_chain(Pf, g_orb, dtype=torch.float32, device="cpu"):
    """the FACT fork: the ring's azimuth about the vertical through F, the trunnions' elevation about the horizontal
    through F; no beta (the head's normal points where the head points). Home: north, level."""
    B = Pf.shape[0]; z = _e(B, 0, 0, 1, dtype, device); my = _e(B, 0, -1, 0, dtype, device); x = _e(B, 1, 0, 0, dtype, device)
    o = torch.zeros(B, 1, dtype=dtype, device=device)
    screws = torch.stack([torch.cat([z, Pf, o], 1), torch.cat([my, Pf, o], 1)], 1)
    return dict(names=["az", "el"], screws=screws, C0=Pf - g_orb*x, n0=x)


def coude_chain(P_stalk, z_neck, r_neck, dtype=torch.float32, device="cpu"):
    """the fourth pass: the stalk's azimuth about its own vertical axis, the neck pivot r_neck to one side at z_neck,
    the head hanging on it. Home: the head north of the stalk, level. The kernel does not trace the coude's optics
    (four reflections, the beam down the stalk); the chain is here so the mount can be evaluated with the rest."""
    B = P_stalk.shape[0]; z = _e(B, 0, 0, 1, dtype, device); my = _e(B, 0, -1, 0, dtype, device); x = _e(B, 1, 0, 0, dtype, device)
    o = torch.zeros(B, 1, dtype=dtype, device=device)
    neck = P_stalk.clone(); neck[:, 2] = z_neck
    screws = torch.stack([torch.cat([z, P_stalk, o], 1), torch.cat([my, neck, o], 1)], 1)
    return dict(names=["az", "neck"], screws=screws, C0=neck + r_neck*x, n0=x)


# ======================================================================================================================
# compliances at the vertex, world orientation, for the current pose - one function per mount type
# ======================================================================================================================
def pedicel_compliance(T0, Cb, n, D_REC, EI_stem, EI_boom, kind="uniform", ratio=45.0, root=0.25, Ls=1.0,
                       stem_d=(0.215, 0.009), boom_d=(0.219, 0.008)):
    """the stem (vertical, length Ls, tip at T0) and the boom (T0 to the wrist Cb) in series, the 6 x 6 at the vertex
    C = Cb + D_REC n. EI as the env carries them; GJ and EA from the sections. 'reversed' splits the boom into a root
    tube of `root` metres and an arm ratio x stiffer, pinned at the geometric mean (tandoor_flower_env.compliance)."""
    B = T0.shape[0]; dt, dv = T0.dtype, T0.device
    b = Cb - T0; Lb = torch.linalg.norm(b, dim=1).clamp(min=1e-6); bu = b/Lb[:, None]
    _, GJs, EAs = chs_section(*stem_d); _, GJb, EAb = chs_section(*boom_d)
    L_s = torch.full((B,), Ls, dtype=dt, device=dv)
    up = torch.zeros(B, 3, dtype=dt, device=dv); up[:, 2] = 1.0
    els = [(beam_compliance(L_s, torch.full_like(L_s, EI_stem), torch.full_like(L_s, EI_stem), torch.full_like(L_s, GJs),
                            torch.full_like(L_s, EAs)), frame_along(up, T0))]
    if kind == "reversed":
        EI_r = EI_boom/float(ratio)**0.5; EI_a = EI_r*float(ratio)
        L1 = torch.clamp(torch.full_like(Lb, float(root)), max=Lb); L2 = torch.clamp(Lb - L1, min=0.0)
        els.append((beam_compliance(L1, torch.full_like(L1, EI_r), torch.full_like(L1, EI_r), torch.full_like(L1, GJb),
                                    torch.full_like(L1, EAb)), frame_along(bu, T0 + L1[:, None]*bu)))
        els.append((beam_compliance(L2, torch.full_like(L2, EI_a), torch.full_like(L2, EI_a), torch.full_like(L2, GJb),
                                    torch.full_like(L2, EAb)), frame_along(bu, Cb)))
    else:
        els.append((beam_compliance(Lb, torch.full_like(Lb, EI_boom), torch.full_like(Lb, EI_boom), torch.full_like(Lb, GJb),
                                    torch.full_like(Lb, EAb)), frame_along(bu, Cb)))
    return series_at(els, Cb + D_REC*n)


def crown_compliance(n, xl, yl, k_tilt=77e6, k_focus=60e6, k_inplane=38e6, k_spin=147e6):
    """the tangential-blade diaphragm fine stage, locked: 77 MN m/rad about the vertex in tip and tilt and 60 MN/m in
    focus (stage3/fact_mount/memo.md), the three 12 mm rods' EA/L in the plane and about the axis. Diagonal in the
    head frame, returned in world orientation (B,6,6)."""
    B = n.shape[0]; R = torch.stack([xl, yl, n], 2)
    d = torch.tensor([1/k_inplane, 1/k_inplane, 1/k_focus, 1/k_tilt, 1/k_tilt, 1/k_spin], dtype=n.dtype, device=n.device)
    C = torch.diag(d)[None].repeat(B, 1, 1)
    A = torch.zeros(B, 6, 6, dtype=n.dtype, device=n.device); A[:, :3, :3] = R; A[:, 3:, 3:] = R
    return torch.bmm(torch.bmm(A, C), A.transpose(1, 2))


def fork_compliance(Pf, az, y_T=3.25, travel=math.radians(71.0), load=2000.0, k_jack=2*50e6, radius=0.15,
                    dtype=torch.float64, device="cpu"):
    """the trunnion blocks at F +- y_T on the elevation axis, each realised from its screw by tandoor_screw_render
    (blades in planes containing the axis) and scored as a 6 x 6 at its own point; the two in parallel at F, the
    elevation freedom held by the jacks (k_jack about the axis); the ring rigid. numpy inside, (B,6,6) out."""
    from tandoor_screw_render import realise
    B = Pf.shape[0]; out = torch.zeros(B, 6, 6, dtype=dtype, device=device)
    for b in range(B):
        F = Pf[b].detach().cpu().double().numpy(); a = float(az[b])
        ca, sa = math.cos(a), math.sin(a)
        w_el = np.array([sa, -ca, 0.0])                                    # the horizontal through F, turned by the ring
        y_dir = np.array([-sa, ca, 0.0])
        K = np.zeros((6, 6))
        for s in (+1.0, -1.0):
            q = F + s*y_T*y_dir
            mem = realise([("el", w_el, q, 0.0, travel, load)], radius=radius, n_blades=2)
            Kq = stiffness_from_members(mem, q)                            # at the block's point, world orientation
            d = q - F                                                      # move to F: K_F = Ad_w K Ad_w^T, R = I
            A = np.eye(6); A[3:, :3] = np.array([[0, -d[2], d[1]], [d[2], 0, -d[0]], [-d[1], d[0], 0]])
            K += A @ Kq @ A.T
        wf = np.concatenate([np.zeros(3), w_el]); K += k_jack*np.outer(wf, wf)
        out[b] = torch.as_tensor(np.linalg.pinv(K), dtype=dtype, device=device)
    return out


# ======================================================================================================================
# the kernel rows and their torch twin
# ======================================================================================================================
def mech_rows(B, dtype=torch.float32, device="cpu"):
    return torch.zeros(B, MECHW, dtype=dtype, device=device)


def set_chain(rows, screws, theta, C0, n0):
    """screws (B,N,7), theta (B,N), home vertex and axis (B,3)"""
    B, N, _ = screws.shape; assert N <= NS_MAX, N
    rows[:, 0] = float(N)
    for i in range(N):
        rows[:, OFF_SCREW + 8*i: OFF_SCREW + 8*i + 7] = screws[:, i]; rows[:, OFF_SCREW + 8*i + 7] = theta[:, i]
    rows[:, OFF_HOME:OFF_HOME + 3] = C0; rows[:, OFF_HOME + 3:OFF_HOME + 6] = n0
    return rows


def set_elastic(rows, xi):
    rows[:, OFF_XI:OFF_XI + 6] = xi; rows[:, 1] = torch.bitwise_or(rows[:, 1].long(), 1).to(rows.dtype); return rows


def set_compliance(rows, C, W):
    rows[:, OFF_C:OFF_C + 36] = C.reshape(C.shape[0], 36); rows[:, OFF_W:OFF_W + 6] = W
    rows[:, 1] = torch.bitwise_or(rows[:, 1].long(), 2).to(rows.dtype); return rows


def apply_rows(rows):
    """the kernel's chain walk in torch: rows (B, MECHW) -> vertex (B,3), axis (B,3). Same order, same arithmetic."""
    B = rows.shape[0]; N = int(rows[:, 0].max().item()) if B else 0                # per agent: unused slots are zeros = identity
    C = rows[:, OFF_HOME:OFF_HOME + 3].clone(); n = rows[:, OFF_HOME + 3:OFF_HOME + 6].clone()
    for i in range(N - 1, -1, -1):
        s = rows[:, OFF_SCREW + 8*i: OFF_SCREW + 8*i + 8]
        w, q, h, th = s[:, 0:3], s[:, 3:6], s[:, 6], s[:, 7]
        slide = (h > PRISMATIC/10)[:, None]
        wn = w/torch.linalg.norm(w, dim=1, keepdim=True).clamp(min=1e-12)
        R = rodrigues(wn, th)
        C_rev = torch.bmm(R, (C - q)[:, :, None])[:, :, 0] + q + (h*th)[:, None]*wn*0.0
        n_rev = torch.bmm(R, n[:, :, None])[:, :, 0]
        C = torch.where(slide, C + th[:, None]*wn, C_rev); n = torch.where(slide, n, n_rev)
    flags = rows[:, 1].long()
    xi = rows[:, OFF_XI:OFF_XI + 6]*((flags & 1) > 0).to(rows.dtype)[:, None]
    Cm = rows[:, OFF_C:OFF_C + 36].reshape(B, 6, 6); W = rows[:, OFF_W:OFF_W + 6]
    xi = xi + torch.bmm(Cm, W[:, :, None])[:, :, 0]*((flags & 2) > 0).to(rows.dtype)[:, None]
    C, n = apply_twist(xi, C, n)
    return C, n


def pointing_from_frame(C, n, Pf):
    """what the kernel derives from the chain's vertex and axis: the beam direction to F, the pointing the mirror
    reflects it into, and the effective beta (deg) between them"""
    ub = Pf - C; ub = ub/torch.linalg.norm(ub, dim=1, keepdim=True).clamp(min=1e-12)
    um = 2*(n*ub).sum(1, keepdim=True)*n - ub
    um = um/torch.linalg.norm(um, dim=1, keepdim=True).clamp(min=1e-12)
    beta = torch.rad2deg(2*torch.atan2(torch.linalg.norm(torch.cross(n, ub, dim=1), dim=1), (n*ub).sum(1)))   # atan2: acos loses 0.05 deg near 1 in float32
    return um, ub, beta

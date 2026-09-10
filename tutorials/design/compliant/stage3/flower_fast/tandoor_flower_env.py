"""The flower: the Hashemi machine's optics with the fifth-pass compliant mount in the loop, mechanism and all.

The dish is the same hashemi.ini membrane on the same orbit about the same fixed F; what changes is what holds it. The flower is a
PEDICEL - slew, luff, a telescoping boom, wrist pitch, wrist yaw - carrying a receptacle ring to 1.8 m behind the vertex, six
1.45 m steel struts on flexure balls to the platform ring, and the head. Every number below comes from the design folder,
tutorials/design/compliant/stage3, and is cited where it is used.

WHAT THE PEDICEL STANDS ON is a configuration, and running the mechanism decided it. The register's machine is a 1 m stem on the
deck 4 m north of the pipe, and that works for the flower's OWN schedule, which is free to choose the head's azimuth. This env's
aim law is not free: it puts the head diametrically opposite the sun in azimuth and biases only the elevation, so the head swings
right round the pipe. Measured over the year with the mount tracking, a fixed stem then needs a 0.18-8.56 m boom - a 48:1
telescope, which is not a machine. Put the foot on a CARRIAGE running a ring rail round the pipe and the same law needs
1.09-2.80 m, one stage, and a short boom is a stiff one: 9 um of image per N at 2.8 m against 60 um/N at 7.4. The rail's radius
is not free either - at 3 m the boom passes through the head's own aperture on half the year's poses, at 4 m on none of them.
So base='ring' is the default here and base='stem' draws the register's machine and shows what it costs.

WHAT THIS ENV MODELS, each 15 s step, vectorised over agents on the device:

  1. THE PEDICEL IS SOLVED, not assumed. From the kernel's own mount frame (the head's vertex C and axis n) the joint variables
     are inverted: the carriage's place on the rail, slew and luff above it, the boom's length, and the wrist's pitch and yaw.
     They are held to the travel the year actually asks (measured per base, not assumed) and to TWO drive speeds - a creep to
     track, ten times that to acquire, because a mount that only creeps spends its morning pointing nowhere. A commanded pose
     outside the envelope is NOT silently granted: the pedicel goes as far as it can, the shortfall is handed to the kernel as
     a pointing error, and the HUD says which joint ran out. The boom is also checked against the head's own aperture: a mount
     that reaches through its mirror is refused, in the same test the design's schedule uses.
  2. THE STRUCTURE IS AS STIFF AS IT IS, and that depends on the boom's extension. The stem (CHS 215 x 9) and the boom
     (CHS 219 x 8) are cantilevers in series, so the head's compliance runs as Lb^3 and its first mode as Lb^-1.5: 23 Hz and
     1.3 um of image per N with the boom in, 4.2 Hz and 17.0 um/N at 4 m, 3.2 Hz and 26.4 um/N at full stretch. One constant
     K_IMG was the old model; this is the real one, and it is what makes a long boom expensive.
  3. THE CROWN IS THE FINE STAGE. The six struts never change length over the year's schedule (hexapod_role.py: 1.446348 m,
     spread 3e-15 m) - the pedicel's five joints already span the task's five freedoms. What the crown does is the gust: its
     6 x 6 Jacobian turns the wind wrench into six axial forces, and its stroke (+-50 mm, 33 mm needed at the worst 12 m/s
     miss) nulls the walk up to its 8 Hz bandwidth. What is left is the variance above that, the saturation, and the sensor's
     own floor at the fold.
  4. THE FLEXURE BALLS ARE CHECKED. fact_ball_cad.py sized them at 385 MN/m axial with 282 MPa of compression at the 40 m/s
     gust; here the per-strut force gives the stress, the deflection and the ball's angular travel every step.
  5. THE MACHINE STOWS. The design tracks to 15 m/s mean and stows for the gust (wind_size.txt). Above the stow wind the head
     is parked face-up, and the kernel is told so: the rays miss, and the policy pays for the weather instead of pretending.
  6. BETA IS TWO-TIER. beta_flux.py traced delivered power against beta_dev in this env's own optics: it peaks at 36 deg
     (+29/+34/+35 % over retro) and falls after. So the mount holds 36 wherever the pedicel can, and spends up to 45 only
     where the geometry leaves no pose - 14 of the year's 479 suns, worth 3.0 % of its energy.
  7. THE PLENUM IS A STATE. Sealed, the trapped air is a constant-volume regulator and only ~3 % of the wind's pressure
     reaches the figure (membrane_wind.py); open to the blower it passes one to one. The policy's level action opens it.

The membrane's own figure under wind stays the kernel's model (sig_wind); the film's pitching-moment gradient
(2.63e-5 V^2 rad rms, sealed) is added beside it. `puffer train puffer_flower` runs the same trainer as Hashemi;
`puffer eval puffer_flower --env.render-mode human` draws the flower in place of Hashemi's carriage (no tower, no arm:
F is the pipe's mouth) with the wind, the gust, the joints, the strut forces and the image's walk.

Config: flower.ini (hashemi.ini plus wind_from, wind_scale, stow_wind, fine_stage, mech). A warm start from a Hashemi
checkpoint is the direct translation:
    puffer train puffer_flower --load-model-path experiments/<hashemi run>/model_000160.pt
"""
import inspect, textwrap, numpy as np, torch
from math import isinf
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_screw_render import realise, STEEL

# ---------------------------------------------------------------- the machine, from the design folder
G_ORB, A_M, RHO_AIR = 4.0, 2.1, 1.03; A_DISH = np.pi*A_M**2; D_DISH = 2*A_M
CD_BOWL, CD_BACK, C_M = 1.40, 1.05, 0.15
# THE MECHANISM AS FLEXURES (tandoor_screw_render.realise): the blade standoff from each axis - the pedicel's joints, the
# strip's HOLLOW ring round the bore mouth (the beam goes down the middle), M3's under its patch - and the loads the two
# mirrors' pivots carry (the strip's is wind at 40 m/s on 0.7 m2 plus its own weight; M3 sits underground and carries
# itself, taken at 5x its weight). FLEX_EXAG is how much the renderer exaggerates the wind-bent stem and boom.
R_PIV, R_PIV_M2, R_PIV_M3 = 0.30, 0.85, 0.30
M2_LOAD, M3_LOAD = 1.2e3, 4.0e3
FLEX_EXAG = 200.0
IU = 0.25                                                     # von Karman turbulence intensity (L 50 m)
D_BACK, H_HEX, R_REC, R_PLAT = 0.6, 1.2, 1.5, 1.0             # the platform ring 0.6 m behind the vertex, the receptacle 1.8 m
D_REC = D_BACK + H_HEX                                        # the boom's tip, on the head's axis
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
STEM_X, STEM_Z = 4.0, 1.0                                     # the stem 4 m north of the pipe, its top 1 m over the deck (tree/path.py)
M_HEAD, M_CROWN = 130.0, 80.0                                 # the head and the crown+receptacle (setup_sim5.py, flower_elastica.py)
E_ST = 200e9; RHO_ST = 7850.0
def _chs(d, t):
    """area and second moment of a circular hollow section"""
    di = d - 2*t; return np.pi/4*(d*d - di*di), np.pi/64*(d**4 - di**4)
A_BOOM, I_BOOM = _chs(0.219, 0.008); EI_BOOM = E_ST*I_BOOM    # the pedicel's boom, steel CHS 219 x 8
A_STEM, I_STEM = _chs(0.215, 0.009); EI_STEM = E_ST*I_STEM    # the stem, steel CHS 215 x 9
A_LEG, I_LEG = _chs(0.085, 0.0053); L_LEG = 1.446348          # the struts, steel CHS 85 x 5.3, the length they never leave
EA_LEG = E_ST*A_LEG/L_LEG; P_CR_LEG = np.pi**2*E_ST*I_LEG/L_LEG**2      # 184 MN/m, and the Euler load of a pin-ended strut
K_BALL = 385e6                                                # the flexure ball's axial stiffness (topopt/fact_ball_cad.py)
P_RUN, P_SURV = 5.0e3, 14.0e3                                 # per strut: the sims' logged maximum, and the 40 m/s survival gust (fact_ball_cad.py:39)
SIG_BALL_PER_N = 282e6/P_SURV                                 # the ball's waist carries 282 MPa at that survival load (fact_ball_cad.py:180)
SIG_BALL_WORK = 438e6                                         # the working stress the sizing allowed
BALL_TRAVEL = 0.015                                           # +-15 mm at the ball before the blades foul (the sims' loop clip)
G_ROT, G_TR = 5.01, 0.95                                      # image walk at F per rad of head tilt / per m of head translation (tree/hexapod_role.py)
# the pedicel's envelope: what the year asks (tree/path.json) plus margin, and drives ~4x the fastest the sun demands
J_LIM = dict(slew=(-180.0, 180.0), luff=(-55.0, 70.0), ext=(0.60, 5.00), pitch=(85.0, 145.0), yaw=(-55.0, 55.0))
# and the ring carriage's own envelope, measured the same way over the year (joint_envelope.py): with the foot at the head's
# azimuth the whole machine is planar in that meridian, so the wrist's yaw is idle and its pitch must swing right round.
J_LIM_RING = dict(slew=(-180.0, 180.0), luff=(-95.0, 55.0), ext=(1.05, 2.85), pitch=(-180.0, 180.0), yaw=(-15.0, 15.0))
J_ASK = dict(slew=(-128.3, 133.8), luff=(-48.5, 61.7), ext=(0.66, 5.00), pitch=(92.0, 138.0), yaw=(-48.7, 48.7))
J_RATE = dict(slew=0.60, luff=0.15, ext=0.012, pitch=0.10, yaw=0.20)    # TRACKING rates: deg/s, deg/s, m/s, deg/s, deg/s
J_SLEW = {k: 10.0*v for k, v in J_RATE.items()}    # and the SLEW rates, ten times those. Every real mount has two speeds: it
# creeps while it tracks (the sun moves 0.004 deg/s) and runs while it acquires - at dawn, after a stow, after a cloud. Without
# the second speed the pedicel crawls out of a night's park at 12 mm/s and spends twenty minutes of the morning pointing nowhere.
BASE_KIND = "ring"              # "stem": the register's fixed mast on the deck. "ring": a carriage on a rail round the pipe.
RING_R, RING_Z, RAIL_RATE = 4.0, 2.5, 0.20     # the ring rail's radius, its height over the deck, and the carriage's speed [m/s].
# 4 m, not 3: at r 3 the stroke is prettier (1.8:1) but the boom passes through the head's OWN APERTURE on 50 % of the year's
# poses - the carriage sits inside the cone the mirror looks through. At r 4 that number is 0.0 %, measured pose by pose with
# _boom_clear over the year. A mount that reaches through its own mirror is not a mount, however good its stroke looks.
BOOM_DESIGN = (0.66, 5.00)      # what the FLOWER's own schedule asks (tree/path.json), and what the register is drawn to
BOOM_STEM = (0.15, 8.60)        # what THIS env's aim law asks of that fixed stem, measured over the year with the mount tracking:
# 0.18 to 8.56 m, a 48:1 telescope, which is not a machine. The flower's own schedule needs 0.66-5.0 m because it CHOOSES the
# head's azimuth; the kernel's law pins the azimuth to the anti-sun line and biases only the elevation, so the head swings right
# round the pipe and a fixed stem must reach across the whole circle.
BOOM_RING = (1.05, 2.85)        # the same law from a carriage on a ring rail of radius 3 m about the pipe, 2.5 m up: 1.92-3.52 m,
# at r 3; at the r 4 the clearance forces, 1.09-2.80 m. Either way one telescoping stage, and a SHORT one, which is worth more
# than the stroke: at 2.8 m the head hangs on 9 um/N and a 6 Hz first mode instead of 60 um/N and 2 Hz at 7.4 m.
# Letting the FOOT travel with the head is what buys this, and it is the trick
# Hashemi's own mount uses (his carriage runs a ring rail too). It is also what the design's rigid-body study concluded from the
# other end: only a base concentric with F holds the radius nearly constant (tree/pedicel_full_range.py).
# The kernel puts the head diametrically opposite the sun in AZIMUTH and biases only the elevation by beta, while the
# flower's schedule is free to choose the azimuth and keeps the head over its own stem. Following the kernel from a deck
# stem 4 m north costs a 4.5-7.4 m boom (1.7:1, an easy telescope) instead of 0.66-5.0 (7.6:1, a hard one) - but at 7.4 m
# the head hangs on a far softer cantilever, and compliance() below says what that costs. boom_min/boom_max pick the machine.
FINE_STROKE, FINE_BW, FINE_FLOOR = 0.050, 8.0, 2.0e-4         # the crown as the fine stage: +-50 mm, 8 Hz closed loop, 0.2 mm at the fold sensor
ZETA = 0.02                                                   # structural damping of a welded steel boom
BETA_OPT, BETA_HARD = 36.0, 45.0                              # the traced optimum and the hard cap (tree/beta_flux.py)
PLENUM_SEALED = 0.03                                          # the fraction of the wind's pressure a sealed plenum lets reach the figure (topopt/membrane_wind.py)
SIG_MEM_K = 2.63e-5                                           # rad rms of film gradient per (m/s)^2, sealed
# The LES of the bowl (stage3/wind, equinox-noon retro, 12 m/s, dx 0.06) puts the film's figure error from the load's n = 1, 2, 3
# harmonics at 3.42 mrad against this constant's 3.79 - the same to 10 % at that attitude, differently composed (3.2 / 1.0 / 0.5);
# the attitude table from the year's matrix replaces the constant when it lands. What the constant lacked is the flow's
# own softening of the film: a tensioned membrane in a stream loses stiffness as q D / T (Tiomkin & Raveh 2017, divergence
# at T* = T/(q D) ~ 1). At the working area-mean tension 4922 N/m that is 6 % at 12 m/s, 10 % at 15, divergence at 48 m/s.
T_WORK, D_AERO = 4922.0, 4.2


def film_soften(V):
    """the film's compliance under wind over its still-air compliance, 1/(1 - q D/T), capped short of divergence"""
    return 1.0/(1.0 - torch.clamp(0.5*RHO_AIR*V*V*D_AERO/T_WORK, max=0.6))


def hexapod_jacobian():
    """the crown's 6 x 6 Jacobian in the HEAD's own frame - constant, because both rings are built in that frame.
    Row j is d(leg j length)/d(head twist [dP; dtheta about the vertex]). Same construction as tree/hexapod_role.py."""
    Cb = np.array([0.0, 0.0, -D_REC]); Cp = np.array([0.0, 0.0, -D_BACK])
    B = np.array([Cb + R_REC*np.array([np.cos(a), np.sin(a), 0.0]) for a in BASE_ANG])
    P = np.array([Cp + R_PLAT*np.array([np.cos(a), np.sin(a), 0.0]) for a in PLAT_ANG])
    J = np.zeros((6, 6))
    for j in range(6):
        u = P[j] - B[j]; u = u/np.linalg.norm(u); J[j, :3] = u; J[j, 3:] = np.cross(P[j], u)
    return J, B, P
J_HEX, B_HEX, P_HEX = hexapod_jacobian()
J_HEX_FT = np.linalg.inv(J_HEX.T)          # wrench at the vertex -> the six axial forces
L_HEX = np.linalg.norm(P_HEX - B_HEX, axis=1)


def pedicel_screws(T0, Cb, P, n):
    """the pedicel's five joint screws at the head's vertex, and the 5 x 5 map from joint rates to the useful output
    (the vertex's three translations and the two rotations that turn the axis; spin about the axis moves no image on a sphere).
    Same construction as stage3/tree/pedicel_screw.py."""
    Z = np.array([0.0, 0.0, 1.0]); b = Cb - T0; Lb = max(np.linalg.norm(b), 1e-9); bu = b/Lb
    bh = np.array([b[0], b[1], 0.0]); bh = bh/max(np.linalg.norm(bh), 1e-9)
    a2 = np.cross(Z, bh); a2 /= max(np.linalg.norm(a2), 1e-9); a5 = np.cross(bu, a2); a5 /= max(np.linalg.norm(a5), 1e-9)
    J = np.zeros((6, 5))
    for k, (a, p_) in enumerate(((Z, T0), (a2, T0))): J[:3, k] = a; J[3:, k] = np.cross(a, P - p_)
    J[3:, 2] = bu
    for k, a in ((3, a2), (4, a5)): J[:3, k] = a; J[3:, k] = np.cross(a, P - Cb)
    t1 = np.cross(n, Z); t1 = t1/max(np.linalg.norm(t1), 1e-9); t2 = np.cross(n, t1)
    U = np.vstack([J[3:, :], t1@J[:3, :], t2@J[:3, :]]); sv = np.linalg.svd(U, compute_uv=False)
    return dict(Z=Z, a2=a2, a5=a5, bu=bu, Lb=Lb, sv=sv, cond=float(sv[0]/max(sv[-1], 1e-12)), rank=int(np.linalg.matrix_rank(J, tol=1e-9)))


def pedicel_ik(T0, C, n):
    """T0 may be one point (3,) or one per agent (B, 3): the ring carriage moves, the stem does not."""
    """invert the five joints from the head's pose. Torch, batched: T0 (3,), C (B, 3), n (B, 3) -> dict of (B,) tensors.
      slew   about z at the stem top          luff  about the horizontal normal to the boom's heading
      extend the boom's own length            pitch about that same horizontal at the wrist
      yaw    about boom x pitch-axis at the wrist
    The wrist's two angles are read as the head axis in the boom's frame, which is the decomposition the screws use."""
    if T0.dim() == 1: T0 = T0[None, :]
    Cb = C - D_REC*n; b = Cb - T0
    Lb = torch.linalg.norm(b, dim=1).clamp(min=1e-6); bu = b/Lb[:, None]
    bh = b.clone(); bh[:, 2] = 0.0; bh = bh/torch.linalg.norm(bh, dim=1).clamp(min=1e-9)[:, None]
    z = torch.zeros_like(bu); z[:, 2] = 1.0
    a2 = torch.cross(z, bh, dim=1); a2 = a2/torch.linalg.norm(a2, dim=1).clamp(min=1e-9)[:, None]
    a5 = torch.cross(bu, a2, dim=1); a5 = a5/torch.linalg.norm(a5, dim=1).clamp(min=1e-9)[:, None]
    slew = torch.rad2deg(torch.atan2(b[:, 1], b[:, 0]))
    luff = torch.rad2deg(torch.asin((b[:, 2]/Lb).clamp(-1, 1)))
    yaw = torch.rad2deg(torch.asin((n*a2).sum(1).clamp(-1, 1)))
    pitch = torch.rad2deg(torch.atan2((n*a5).sum(1), (n*bu).sum(1)))
    return dict(slew=slew, luff=luff, ext=Lb, pitch=pitch, yaw=yaw, Cb=Cb, bu=bu, a2=a2, a5=a5)


def pedicel_fk(T0, q):
    """the head's pose from the five joints - the inverse of pedicel_ik, used to see what the pedicel ACHIEVED
    after its limits and rates had their say."""
    sl, lu = torch.deg2rad(q["slew"]), torch.deg2rad(q["luff"])
    ch, sh = torch.cos(sl), torch.sin(sl); cl, sl_ = torch.cos(lu), torch.sin(lu)
    bu = torch.stack([cl*ch, cl*sh, sl_], 1)
    bh = torch.stack([ch, sh, torch.zeros_like(ch)], 1)
    z = torch.zeros_like(bh); z[:, 2] = 1.0
    a2 = torch.cross(z, bh, dim=1); a2 = a2/torch.linalg.norm(a2, dim=1).clamp(min=1e-9)[:, None]
    a5 = torch.cross(bu, a2, dim=1); a5 = a5/torch.linalg.norm(a5, dim=1).clamp(min=1e-9)[:, None]
    Cb = (T0 if T0.dim() == 2 else T0[None, :]) + q["ext"][:, None]*bu
    pi_, ya = torch.deg2rad(q["pitch"]), torch.deg2rad(q["yaw"])
    n = (torch.sin(ya)[:, None]*a2
         + torch.cos(ya)[:, None]*(torch.cos(pi_)[:, None]*bu + torch.sin(pi_)[:, None]*a5))
    n = n/torch.linalg.norm(n, dim=1).clamp(min=1e-9)[:, None]
    return Cb + D_REC*n, n


def head_frame(n):
    """an orthonormal frame with n as its third axis, batched (B, 3) -> (xl, yl)"""
    ref = torch.zeros_like(n); ref[:, 0] = -1.0
    xl = ref - n*(n*ref).sum(1)[:, None]
    bad = torch.linalg.norm(xl, dim=1) < 1e-6
    if bad.any():
        alt = torch.zeros_like(n); alt[:, 1] = 1.0
        xl = torch.where(bad[:, None], alt - n*(n*alt).sum(1)[:, None], xl)
    xl = xl/torch.linalg.norm(xl, dim=1).clamp(min=1e-9)[:, None]
    return xl, torch.cross(n, xl, dim=1)


# THE BOOM'S COMPLIANCE IS A DESIGN VARIABLE, NOT AN ERROR. The image at F moves by g_rot*theta + g_tr*delta when
# the head tilts by theta and translates by delta, and on the real geometry those two gains have OPPOSITE signs at
# every pose of the year (the optics want theta/delta = 0.18 rad/m, median, to cancel). A uniform cantilever under a
# tip load delivers theta/delta = 3/(2 Lb) - too much tilt when short, nearly right when long - and that ratio is set
# by where the stiffness sits along the boom. Measured over 170 poses of the year (stage3/fact, boom_tune.py):
#     uniform CHS 219x8, as built                 4.51 um of image per N of wind      1.00x
#     parallel-guiding boom (theta = 0)          17.61 um                              0.26x   worse: tilt was cancelling
#     conventional telescope, thin tube extends   4.60 um                              0.98x   wants to be uniform
#     REVERSED telescope, soft short root, stiff arm  2.27-2.38 um                     2.3-2.4x
# so the exploit is to put the compliance at the ROOT: a short soft section under a stiff arm, with the arm 20-50x
# stiffer than the root. The floor it leaves (2.3 um/N) is the pose-to-pose spread in what the optics want, which no
# single passive stiffness curve can follow - and that residual is the fine stage's job, now 2.4x smaller.
BOOM_KIND, BOOM_RATIO, BOOM_ROOT = "uniform", 45.0, 0.25      # reversed: arm EI = ratio x root EI, root length [m]


def compliance(Lb, kind=None, ratio=None, root=None, m_tip=None):
    """the head's compliance at the end of the stem-and-boom chain, per newton of transverse force at the head.
    The stem carries the boom's force AND its moment P*Lb. For the uniform boom
        theta = (P L^2/2 + P Lb L)/EI_s + P Lb^2/(2 EI_b)
        delta = (P L^3/3 + P Lb L^2/2)/EI_s + theta_s*Lb + P Lb^3/(3 EI_b)
    and for the reversed two-stage boom the root tube (EI_r, length L1) carries the arm's force and moment P*L2 and the
    arm (EI_a = ratio*EI_r) is a cantilever off its tip. Lb is a (B,) tensor; everything returned is (B,).

    m_tip (B,), metres: the drag acts at the DISH, D_REC in front of the boom's tip on the head's axis, so the tip also
    sees a moment P*m_tip with m_tip = D_REC*(n.bu) - signed, and negative when the head leans back over the boom, in
    which case it UNBENDS the chain a little (year-rms walk 0.77x of the force-only figure). None means force only.
    k_img is the UNSIGNED sum G_ROT*theta + G_TR*delta - the pessimistic scalar; the signed, pose-dependent walk that
    lets a tuned boom cancel is computed where the pose is known (_fl_after_step, and geometrically in the fast env)."""
    kind = BOOM_KIND if kind is None else kind; ratio = BOOM_RATIO if ratio is None else ratio; root = BOOM_ROOT if root is None else root
    Ls = 1.0
    m = torch.zeros_like(Lb) if m_tip is None else m_tip
    th_s = (Ls*Ls/2 + Lb*Ls + m*Ls)/EI_STEM
    d_s = (Ls**3/3 + Lb*Ls*Ls/2 + m*Ls*Ls/2)/EI_STEM
    if kind == "reversed":
        EI_r = EI_BOOM/float(ratio)**0.5; EI_a = EI_r*float(ratio)             # geometric mean pinned to the built tube
        L1 = torch.clamp(torch.full_like(Lb, float(root)), max=Lb); L2 = torch.clamp(Lb - L1, min=0.0)
        th1 = (L1*L1/2 + L1*L2 + m*L1)/EI_r; d1 = (L1**3/3 + L1*L1*L2/2 + m*L1*L1/2)/EI_r
        th2 = (L2*L2/2 + m*L2)/EI_a; d2 = (L2**3/3 + m*L2*L2/2)/EI_a
        theta = th_s + th1 + th2
        delta = d_s + th_s*Lb + d1 + th1*L2 + d2
    else:
        theta = th_s + (Lb*Lb/2 + m*Lb)/EI_BOOM
        delta = d_s + th_s*Lb + (Lb**3/3 + m*Lb*Lb/2)/EI_BOOM
    k_lat = 1.0/delta.clamp(min=1e-12)
    f_n = torch.sqrt(k_lat/(M_HEAD + M_CROWN))/(2*np.pi)
    return dict(theta=theta, delta=delta, k_lat=k_lat, f_n=f_n, k_img=G_ROT*theta + G_TR*delta)


def miss_gains(Ff, C, n, s, t, ra, h=1e-4, lever=None):
    """the SIGNED optical sensitivities at this pose, batched (B,): metres of image walk at F per metre of head
    translation along t, and per radian of head rotation about ra, both projected on the direction the translation
    moves the image. Their signs are what a tuned boom exploits; an unsigned G_ROT + G_TR sum cannot cancel.

    lever (B,3): the vector from the ROTATION CENTRE to the vertex C. The boom's tip is D_REC behind the vertex on the
    head's axis, so a tip rotation also carries the vertex sideways by theta x lever - a shift of the dish in its own
    plane that moves the image as surely as a translation does. Left None the rotation is about C itself, which
    understates the rotation gain by that lever (checked: 2.0 vs 3.8 m/rad at a 3.3 m boom)."""
    def miss(Cq, nq):
        r = -s + 2*(s*nq).sum(1, keepdim=True)*nq; d = Ff[None, :] - Cq
        return d - (d*r).sum(1, keepdim=True)*r
    dT = (miss(C + h*t, n) - miss(C - h*t, n))/(2*h)
    def rot(sg):
        nn = n + sg*h*torch.cross(ra, n, dim=1); nn = nn/torch.linalg.norm(nn, dim=1, keepdim=True).clamp(min=1e-9)
        Cq = C if lever is None else C + sg*h*torch.cross(ra, lever, dim=1)
        return Cq, nn
    dR = (miss(*rot(+1.0)) - miss(*rot(-1.0)))/(2*h)
    u = dT/torch.linalg.norm(dT, dim=1, keepdim=True).clamp(min=1e-12)
    return (dT*u).sum(1), (dR*u).sum(1)


def frac_above(U, f):
    """the fraction of von Karman gust variance (L 50 m) above frequency f, anchored on the measured 0.10 at 9 m/s and
    0.5 Hz (topopt/membrane_wind.py) and carried by the -2/3 law of the integrated spectrum."""
    U = torch.clamp(U, min=0.5)
    return torch.clamp(0.10*((0.5/f)*(U/9.0))**(2.0/3.0), 1e-4, 1.0)


class TandoorFlowerEnv(TandoorHashemiEnv):
    def __init__(self, *a, wind_from="S", wind_scale=1.0, stow_wind=15.0, fine_stage=1, mech=1, two_tier_beta=0,
                 boom_kind=BOOM_KIND, boom_ratio=BOOM_RATIO, boom_root=BOOM_ROOT, flexures=1,
                 base=BASE_KIND, ring_r=RING_R, stem_x=STEM_X, stem_z=None, boom_min=None, boom_max=None, **k):
        # two_tier_beta defaults OFF: the kernel owns the beta schedule, and letting the mount write it too makes the two fight.
        super().__init__(*a, **k)
        self.base = str(base); self.ring_r = float(ring_r)
        self.stem_x = float(stem_x)
        self.boom_kind, self.boom_ratio, self.boom_root = str(boom_kind), float(boom_ratio), float(boom_root)
        self.stem_z = float(RING_Z if stem_z is None and self.base == "ring" else (STEM_Z if stem_z is None else stem_z))
        bd = BOOM_RING if self.base == "ring" else BOOM_STEM
        self.boom = (float(bd[0] if boom_min is None else boom_min), float(bd[1] if boom_max is None else boom_max))
        self.j_lim = dict(J_LIM_RING if self.base == "ring" else J_LIM); self.j_lim["ext"] = self.boom
        self.wind_from, self.wind_scale = str(wind_from), float(wind_scale)
        self.stow_wind = float(stow_wind); self.fine_stage = int(fine_stage)
        self.mech = int(mech); self.two_tier_beta = int(two_tier_beta)
        self._fl_what_x = 1.0 if self.wind_from.upper().startswith("S") else -1.0     # the wind blows toward +x (north) when from the south
        self._fl = None                                                               # device tensors, made on the first step
        self._fl_act = None                                                           # this step's actions, for the plenum
        self.flexures = int(flexures)                                                  # 0 none, 1 the strip's and M3's (default), 2 every joint - the pedicel's are 9 m blades, drawn only on request
        self._fl_travel = None; self._flex_rep = None                                  # the year's joint travel, and the flexure eval
        self._fl_T0 = None
        self._fl_JFT = torch.as_tensor(J_HEX_FT, dtype=torch.float32, device=self.device)
        self._fl_JH = torch.as_tensor(J_HEX, dtype=torch.float32, device=self.device)

    # ------------------------------------------------------------ the pedicel's own frame
    def _fl_F(self):
        """the fold point F = the light pipe's mouth: (X_TOWER_C, 0, z_fold). F_focus is only built for the focus and cass
        receivers, so take the primitive one when it is absent."""
        Ff = getattr(self, "F_focus", None)
        if Ff is None: Ff = np.array([float(self.X_TOWER_C), 0.0, float(self.z_fold)])
        return np.asarray(Ff, float)

    def _fl_stem(self):
        """the fixed stem's top, in the env's world frame"""
        if self._fl_T0 is None:
            Ff = self._fl_F()
            self._fl_T0 = torch.as_tensor([Ff[0] + self.stem_x, Ff[1], float(self.z_deck) + self.stem_z],
                                          dtype=torch.float32, device=self.device)
        return self._fl_T0

    def _fl_base(self, Cb, phi_prev, dt):
        """$0, the carriage on the ring rail: it rides round the pipe to sit under the receptacle, at a rolling speed of
        RAIL_RATE. The shortest boom from a circle of radius r about F is always at the receptacle's own azimuth, so the
        carriage has a closed-form command and only its rate to obey. With base='stem' there is no joint 0 at all."""
        T0f = self._fl_stem()
        if self.base != "ring":
            B = Cb.shape[0]
            return T0f[None, :].expand(B, 3), torch.zeros(B, device=Cb.device), torch.zeros(B, device=Cb.device)
        Ff = torch.as_tensor(self._fl_F(), dtype=torch.float32, device=Cb.device)
        want = torch.atan2(Cb[:, 1] - Ff[1], Cb[:, 0] - Ff[0])
        d = torch.remainder(want - phi_prev + np.pi, 2*np.pi) - np.pi                  # the short way round the rail
        cap = RAIL_RATE*dt/max(self.ring_r, 1e-6)                                      # a carriage speed, not a teleport
        fast = d.abs() > 5.0*cap
        lim = torch.where(fast, torch.full_like(d, 10.0*cap), torch.full_like(d, cap))
        phi = phi_prev + d.clamp(-lim, lim)
        T0 = torch.stack([Ff[0] + self.ring_r*torch.cos(phi), Ff[1] + self.ring_r*torch.sin(phi),
                          torch.full_like(phi, float(self.z_deck) + self.stem_z)], dim=1)
        return T0, phi, (d.abs() > lim + 1e-9).float()

    @staticmethod
    def _boom_clear(T0, Cb, C, n, a_m):
        """does the boom pass through the head's own aperture? The disc of radius a_m at C with normal n is the mirror; a boom
        that crosses it is not a boom. This is the test the design's schedule uses (tree/path.py) and it is why Hashemi's mount
        is an arc RAIL that goes round the beam rather than an arm that reaches through it."""
        d = Cb - T0; den = (d*n).sum(1)
        t = torch.where(den.abs() > 1e-9, ((C - T0)*n).sum(1)/torch.where(den.abs() > 1e-9, den, torch.ones_like(den)), torch.full_like(den, -1.0))
        q = T0 + t[:, None]*d - C
        return ((t >= 0.0) & (t <= 1.0) & (torch.linalg.norm(q, dim=1) < a_m)).float()

    def _fl_head_pose(self):
        """the head's vertex and axis, per agent, from the kernel's own mount solve"""
        dev = self.device; S = getattr(self, "_gpu", None)
        day = getattr(S, "day_v", None) if S is not None else None
        if day is None: day = getattr(self, "day_v", None)
        lat = getattr(S, "lat_v", None) if S is not None else None
        if lat is None: lat = getattr(self, "lat_v", None)
        if day is None or lat is None: return None, None
        day_t = torch.as_tensor(day, dtype=torch.float32, device=dev).reshape(-1)
        lat_t = torch.as_tensor(lat, dtype=torch.float32, device=dev).reshape(-1)
        el_m = S.el_m if (S is not None and hasattr(S, "el_m")) else self.el_m
        az_m = S.az_m if (S is not None and hasattr(S, "az_m")) else self.az_m
        if self._fl is not None and self._fl.get("cmd_el") is not None:
            el_t, az_t = self._fl["cmd_el"], self._fl["cmd_az"]                       # the command as the policy gave it, before this step's injection
        else:
            el_t = torch.as_tensor(el_m, dtype=torch.float32, device=dev).reshape(-1)
            az_t = torch.as_tensor(az_m, dtype=torch.float32, device=dev).reshape(-1)
        pnt = torch.stack([el_t, az_t], 1)
        mnt = self._mount(day_t, lat_t, float(self.t_solar[0]), pnt=pnt)
        # the Metal mount returns the frame, not the axis: Mt is M^T with M taking zhat onto naim, so naim is Mt's third ROW
        n = mnt["naim"] if "naim" in mnt else mnt["Mt"][:, 2, :]
        n = n.float(); n = n/torch.linalg.norm(n, dim=1).clamp(min=1e-9)[:, None]
        return mnt["Cd"].float(), n

    # ------------------------------------------------------------ the mechanics, vectorised over agents
    def _fl_init(self):
        B, dev = self.num_agents, self.device; z = lambda: torch.zeros(B, device=dev)
        self._fl = dict(applied_el=z(), applied_az=z(), cmd_el=None, cmd_az=None, V=z(), gust=z(), drag=z(), pitch=z(), lift=z(),
                        strut=z(), strut_min=z(), leg=torch.zeros(B, 6, device=dev), walk_a=z(), walk_x=z(),
                        d_el=z(), d_az=z(), sig_mem=z(), Lb=torch.full((B,), 3.0, device=dev), f_n=z(), k_img=z(),
                        q_slew=z(), q_luff=z(), q_ext=torch.full((B,), 3.0, device=dev), q_pitch=z(), q_yaw=z(),
                        lim_hit=z(), rate_hit=z(), pose_err=z(), fine_use=z(), fine_sat=z(),
                        ball_sig=z(), ball_defl=z(), ball_ang=z(), stow=z(), beta=torch.full((B,), float(getattr(self, 'beta_dev', BETA_OPT)), device=dev), ext_ask=z(), acq=z(), beta_hold=z(), q_rail=z(), thru=z(),
                        plenum=torch.ones(B, device=dev), walk_open=z(), q_init=z())

    def _fl_before_step(self):
        """apply this step's pointing error of the head to the kernel's motor state (its change from the last step)"""
        S = getattr(self, "_gpu", None)
        if S is None or not hasattr(S, "el_m"): return
        if self._fl is None: self._fl_init()
        F = self._fl
        F["cmd_el"] = (S.el_m - F["applied_el"]).clone()                               # the policy's OWN command, recorded before the flower touches it.
        F["cmd_az"] = (S.az_m - F["applied_az"]).clone()                               # Reconstructing it later by subtraction ratchets: the kernel
        S.el_m += F["d_el"] - F["applied_el"]                                          # clips el_m, so the injected error does not always come back out,
        S.az_m += F["d_az"] - F["applied_az"]                                          # and the pedicel then chases a command that its own error moves.
        F["applied_el"] = F["d_el"].clone(); F["applied_az"] = F["d_az"].clone()

    def _fl_after_step(self):
        """the whole mechanism for this step: the wind, the pedicel, the structure, the crown, the balls, the stow and the
        plenum - then the pointing error all of that leaves, handed to the kernel before the next step."""
        S = getattr(self, "_gpu", None)
        if S is None or not hasattr(S, "el_m"): return
        if self._fl is None: self._fl_init()
        F = self._fl; B, dev = self.num_agents, self.device
        tr = getattr(self, "_trunc_t", None)
        if tr is not None and getattr(self, "_trunc_live", False):
            keep = (tr < 0.5).float(); F["applied_el"] *= keep; F["applied_az"] *= keep; F["q_init"] *= keep

        # ---- 1. the wind on the bowl: mean, gust, drag, lift and the pitching moment
        U = torch.clamp(S.wind*self.wind_scale, min=0.0)
        gen = getattr(self, "_gen", None)                                              # the env's OWN seeded stream, like every other
        rn = lambda: torch.randn(B, generator=gen, device=dev) if gen is not None else torch.randn(B, device=dev)
        gust = rn()*IU*U; V = torch.clamp(U + gust, min=0.0)                           # stochastic term here (tandoor_hashemi_env.py:2956):
        # drawing from the global generator instead would put the flower's gust outside the seed, and two runs of the same
        # seed would then differ - which breaks both reproducibility and the parity discipline.
        el = torch.deg2rad(S.el0s) if hasattr(S, "el0s") else torch.full((B,), 0.8, device=dev)
        az = torch.deg2rad(S.az0d) if hasattr(S, "az0d") else torch.zeros(B, device=dev)
        ca = torch.cos(el)*torch.cos(az)*self._fl_what_x                              # the head's axis is near the sun's: its cosine to the wind
        into = ca < 0
        cd_n = torch.where(into, torch.full_like(ca, CD_BOWL), torch.full_like(ca, CD_BACK))
        cd = 0.25 + (cd_n - 0.25)*ca*ca
        q = 0.5*RHO_AIR*V*V
        F["drag"] = q*A_DISH*cd
        F["lift"] = q*A_DISH*0.9*ca.abs()*torch.sqrt(torch.clamp(1 - ca*ca, min=0.0))
        F["pitch"] = q*A_DISH*D_DISH*torch.where(into, torch.full_like(ca, C_M), torch.full_like(ca, 0.10))*2*ca.abs()*torch.sqrt(torch.clamp(1 - ca*ca, min=0.0))

        # ---- 2. stow: the design tracks to stow_wind mean and parks face-up for the gust (tree/out/wind_size.txt)
        stow = torch.where(U > self.stow_wind, torch.ones_like(U),
                           torch.where(U < self.stow_wind - 3.0, torch.zeros_like(U), F["stow"]))    # 3 m/s of hysteresis
        F["stow"] = stow

        if not self.mech:
            F["V"], F["gust"], F["sig_mem"] = U, gust, SIG_MEM_K*V*V*film_soften(V)
            F["d_el"] = torch.zeros(B, device=dev); F["d_az"] = torch.zeros(B, device=dev); return

        # ---- 3. the pedicel: invert the five joints, hold them to their travel and their drives' rates
        C, n = self._fl_head_pose()
        if C is None:
            F["V"], F["gust"], F["sig_mem"] = U, gust, SIG_MEM_K*V*V*film_soften(V); return
        dt0 = float(getattr(self, "dt", 15.0))
        Cb_want = C - D_REC*n
        T0, phi, rail_hit = self._fl_base(Cb_want, F["q_rail"], dt0)
        F["q_rail"] = phi
        qc = pedicel_ik(T0, C, n)
        first = F["q_init"] < 0.5
        prev = dict(slew=F["q_slew"], luff=F["q_luff"], ext=F["q_ext"], pitch=F["q_pitch"], yaw=F["q_yaw"])
        dt = float(getattr(self, "dt", 15.0))
        q = {}; lim_hit = torch.zeros(B, device=dev); rate_hit = torch.zeros(B, device=dev); acquiring = torch.zeros(B, device=dev)
        for kk in ("slew", "luff", "ext", "pitch", "yaw"):
            lo, hi = self.j_lim[kk]; want = qc[kk]
            if kk in ("slew", "pitch", "yaw") and self.j_lim[kk][1] - self.j_lim[kk][0] >= 359.0:   # continuous: take the short way round
                d = torch.remainder(want - prev[kk] + 180.0, 360.0) - 180.0
                want = torch.where(first, want, prev[kk] + d)
            cl = want.clamp(lo, hi); lim_hit = lim_hit + (cl != want).float()
            err = cl - prev[kk]
            fast = err.abs() > 5.0*J_RATE[kk]*dt                                      # far from the command: acquire at slew speed
            lim_r = torch.where(fast, torch.full_like(err, J_SLEW[kk]*dt), torch.full_like(err, J_RATE[kk]*dt))
            got = torch.where(first, cl, prev[kk] + err.clamp(-lim_r, lim_r))
            rate_hit = rate_hit + (err.abs() > lim_r + 1e-9).float()
            acquiring = acquiring + fast.float()
            q[kk] = got
        F["q_slew"], F["q_luff"], F["q_ext"], F["q_pitch"], F["q_yaw"] = q["slew"], q["luff"], q["ext"], q["pitch"], q["yaw"]
        F["lim_hit"], F["rate_hit"], F["q_init"] = lim_hit, rate_hit, torch.ones(B, device=dev)
        F["acq"] = acquiring
        F["ext_ask"] = qc["ext"]                                                      # what the aim law asked for, before the limit
        F["Lb"] = q["ext"]
        C_got, n_got = pedicel_fk(T0, q)                                              # what the pedicel actually achieved
        F["thru"] = self._boom_clear(T0, C_got - D_REC*n_got, C_got, n_got, float(self.a_mem))
        F["rate_hit"] = F["rate_hit"] + rail_hit
        # what the shortfall does to the image at F: the axis error turns the beam, the vertex error slides it
        dC = C_got - C
        pose_ang = torch.linalg.norm(torch.cross(n, n_got, dim=1), dim=1).clamp(max=1.0)
        F["pose_err"] = pose_ang
        el_c = torch.rad2deg(torch.asin(n[:, 2].clamp(-1, 1))); el_g = torch.rad2deg(torch.asin(n_got[:, 2].clamp(-1, 1)))
        az_c = torch.rad2deg(torch.atan2(n[:, 1], n[:, 0])); az_g = torch.rad2deg(torch.atan2(n_got[:, 1], n_got[:, 0]))
        d_el_pose = el_g - el_c                                                       # the axis error, in the kernel's own coordinates
        d_az_pose = torch.remainder(az_g - az_c + 180.0, 360.0) - 180.0
        walk_pose = G_TR*torch.linalg.norm(dC, dim=1)                                 # the vertex error slides the image; the axis error turns it

        # ---- 4. the structure: compliance and first mode at THIS extension, not a constant
        cmp_ = compliance(F["Lb"], self.boom_kind, self.boom_ratio, self.boom_root,
                          m_tip=D_REC*(n_got*qc["bu"]).sum(1))                      # the drag acts at the dish, D_REC past the tip
        F["f_n"], F["k_img"] = cmp_["f_n"], cmp_["k_img"]

        # ---- 5. the crown: the wind wrench through the 6 x 6 Jacobian into six axial forces
        xl, yl = head_frame(n)
        w = torch.zeros(B, 3, device=dev); w[:, 0] = self._fl_what_x                  # the wind's direction, horizontal
        gvec = torch.zeros(B, 3, device=dev); gvec[:, 2] = -1.0
        Fw = F["drag"][:, None]*w + F["lift"][:, None]*(-gvec) + (M_HEAD*9.81)*gvec
        Mw = F["pitch"][:, None]*torch.cross(w, n, dim=1)
        R = torch.stack([xl, yl, n], dim=2)                                            # head frame -> world
        wr = torch.cat([torch.einsum("bij,bi->bj", R, Fw), torch.einsum("bij,bi->bj", R, Mw)], dim=1)
        legs = -torch.einsum("ij,bj->bi", self._fl_JFT, wr)                            # the six axial forces that balance it (J^T f + w = 0)
        F["leg"] = legs; F["strut"] = legs.abs().max(dim=1).values; F["strut_min"] = legs.min(dim=1).values

        # ---- 6. the flexure balls: stress, deflection, angular travel
        F["ball_sig"] = SIG_BALL_PER_N*F["strut"]; F["ball_defl"] = F["strut"]/K_BALL

        # ---- 7. the image's walk: open loop from the gust force, then the coarse pedicel loop and the crown's fine loop
        sig_force = RHO_AIR*U*(IU*U)*A_DISH*cd                                         # rms of the drag's fluctuation
        # THE WALK IS SIGNED. G_ROT*theta + G_TR*delta adds two magnitudes and can never cancel; on the real geometry
        # the two gains have opposite signs at every pose, which is the whole basis for tuning the boom. So take the
        # signed sensitivities at THIS pose, in the plane the wind actually bends the boom in.
        s_dir = torch.stack([torch.cos(el)*torch.cos(az), torch.cos(el)*torch.sin(az), torch.sin(el)], 1)
        bu_ = qc["bu"]; t_b = w - (w*bu_).sum(1, keepdim=True)*bu_
        t_b = t_b/torch.linalg.norm(t_b, dim=1, keepdim=True).clamp(min=1e-9); ra_ = torch.cross(bu_, t_b, dim=1)
        g_tr, g_rot = miss_gains(torch.as_tensor(self._fl_F(), dtype=torch.float32, device=dev), C_got, n_got, s_dir, t_b, ra_,
                                 lever=D_REC*n_got)                                     # the tip rotates; the vertex is D_REC in front of it
        F["g_tr"], F["g_rot"] = g_tr, g_rot                                        # kept for the renderer's neutral point
        F["k_img"] = (g_rot*cmp_["theta"] + g_tr*cmp_["delta"]).abs()             # signed, then magnitude
        F["k_img_unsigned"] = G_ROT*cmp_["theta"] + G_TR*cmp_["delta"]             # the old pessimistic scalar, for the HUD
        sig_open = F["k_img"]*sig_force; F["walk_open"] = sig_open
        if self.fine_stage:
            resid = frac_above(U, FINE_BW)
            ring_ = torch.where(F["f_n"] > FINE_BW, frac_above(U, F["f_n"])*(1.0/(2*ZETA))**2, torch.zeros_like(sig_open))
            sig_res = torch.sqrt((sig_open**2)*(resid + ring_) + FINE_FLOOR**2)
            demand = (sig_open*3.0/G_ROT)*(R_PLAT)                                     # the leg stroke a 3-sigma correction asks for
            F["fine_use"] = demand
            over = torch.clamp(demand - FINE_STROKE, min=0.0); F["fine_sat"] = over
            sig_res = sig_res + over*G_ROT/R_PLAT
        else:
            resid = frac_above(U, 0.5)
            sig_res = torch.sqrt((sig_open**2)*resid + 0.003**2)                        # the old model: the pedicel's own 0.5 Hz loop and a 3 mm floor
            F["fine_use"] = torch.zeros(B, device=dev); F["fine_sat"] = torch.zeros(B, device=dev)
        F["ball_ang"] = F["fine_use"]/L_LEG
        sig_walk = sig_res + walk_pose                                                  # what the loops could not fix, plus the vertex the pedicel could not reach
        F["walk_a"] = rn()*sig_walk; F["walk_x"] = rn()*0.5*sig_walk
        gorb = float(getattr(self, "g_orbit", G_ORB))
        d_el = torch.rad2deg(F["walk_a"]/(2*gorb)) + d_el_pose
        d_az = torch.rad2deg(F["walk_x"]/(2*gorb))/torch.clamp(torch.cos(el), min=0.2) + d_az_pose
        d_el = d_el.clamp(-90.0, 90.0); d_az = d_az.clamp(-180.0, 180.0)

        # ---- 8. stowed, the head is parked face-up and the rays miss: the policy pays for the weather
        park = (90.0 - torch.rad2deg(el))
        F["d_el"] = torch.where(stow > 0.5, park, d_el); F["d_az"] = torch.where(stow > 0.5, torch.zeros_like(d_az), d_az)

        # ---- 9. the plenum: sealed it is a constant-volume regulator, open to the blower it passes the wind one to one
        act = self._fl_act
        open_ = torch.zeros(B, device=dev)
        if act is not None:
            a0 = torch.as_tensor(act, device=dev).reshape(B, -1)[:, 0].float()
            open_ = (a0 != 3.0).float()                                                 # the level action is off neutral: the valve is open this step
        F["plenum"] = 1.0 - open_
        F["sig_mem"] = SIG_MEM_K*V*V*film_soften(V)*torch.where(open_ > 0.5, torch.full_like(V, 1.0/PLENUM_SEALED), torch.ones_like(V))

        # ---- 10. beta, two-tier at the traced optimum (tree/beta_flux.py)
        if self.two_tier_beta:
            # HYSTERESIS, and it is not optional. beta is a shared scalar in the kernel's mount parameters, and the kernel's own
            # beta schedule already has two branches with a seam near el 40-48 (tandoor_hashemi_env.py:3006). Writing beta from
            # this step's reach deficit feeds one schedule into the other: measured, the pair limit-cycled every step between
            # a 3.04 m and a 2.50 m boom demand. So raise beta the moment the pedicel runs out of reach, and lower it only
            # after HOLD clean steps.
            HOLD = 40
            need = (F["lim_hit"] > 0).float()
            F["beta_hold"] = torch.where(need > 0, torch.full_like(need, float(HOLD)), torch.clamp(F["beta_hold"] - 1.0, min=0.0))
            F["beta"] = torch.where(F["beta_hold"] > 0, torch.full_like(need, BETA_HARD), torch.full_like(need, BETA_OPT))
            want_b = float(F["beta"].max())
            if abs(want_b - float(getattr(self, "_fl_beta_set", BETA_OPT))) > 1e-6:
                self._fl_beta_set = want_b
                try: self._mnt_prm[1] = want_b
                except Exception: pass
        F["V"], F["gust"] = U, gust

    # ------------------------------------------------------------ the env's own hooks
    def step_torch(self, actions):
        self._fl_act = actions; self._fl_before_step(); out = super().step_torch(actions); self._fl_after_step(); return out

    def step(self, actions):
        self._fl_act = actions; self._fl_before_step(); out = super().step(actions); self._fl_after_step(); return out

    def _fl_scalars(self):
        F = self._fl
        if F is None:
            return dict(V=0.0, gust=0.0, drag=0.0, lift=0.0, pitch=0.0, strut=0.0, leg=np.zeros(6), walk=np.zeros(2),
                        d_el=0.0, d_az=0.0, sig_mem=0.0, Lb=0.0, f_n=0.0, k_img=0.0, q=dict(slew=0.0, luff=0.0, ext=0.0, pitch=0.0, yaw=0.0),
                        lim_hit=0.0, rate_hit=0.0, pose_err=0.0, fine_use=0.0, fine_sat=0.0, ball_sig=0.0, ball_defl=0.0,
                        ball_ang=0.0, stow=0.0, beta=float(getattr(self, 'beta_dev', BETA_OPT)), plenum=1.0, walk_open=0.0, ext_ask=0.0, acq=0.0, rail=0.0, thru=0.0)
        g = lambda k: float(F[k][0])
        return dict(V=g("V"), gust=g("gust"), drag=g("drag"), lift=g("lift"), pitch=g("pitch"), strut=g("strut"),
                    leg=F["leg"][0].detach().cpu().numpy(), walk=np.array([g("walk_a"), g("walk_x")]),
                    d_el=g("d_el"), d_az=g("d_az"), sig_mem=g("sig_mem"), Lb=g("Lb"), f_n=g("f_n"), k_img=g("k_img"),
                    q=dict(slew=g("q_slew"), luff=g("q_luff"), ext=g("q_ext"), pitch=g("q_pitch"), yaw=g("q_yaw")),
                    lim_hit=g("lim_hit"), rate_hit=g("rate_hit"), pose_err=g("pose_err"), fine_use=g("fine_use"),
                    fine_sat=g("fine_sat"), ball_sig=g("ball_sig"), ball_defl=g("ball_defl"), ball_ang=g("ball_ang"),
                    stow=g("stow"), beta=g("beta"), plenum=g("plenum"), walk_open=g("walk_open"), ext_ask=g("ext_ask"), acq=g("acq"),
                    rail=g("q_rail"), thru=g("thru"))


    # ------------------------------------------------------------ the mechanism as SCREWS, realised as flexures
    def _fl_year_travel(self):
        """each joint's travel over the machine's own year, from the kernel's own aim law - the sweep path.py runs
        (days 10..365 by 20, 7.5..16.5 h, el > 12 deg) - cached. Angles are ranges ON THE CIRCLE, the largest empty
        gap being what the joint never visits, so the slew's continuous +-180 limit does not read as 360 deg."""
        if self._fl_travel is not None: return self._fl_travel
        from tandoor_mount_batch import solar_batch
        B, dev = self.num_agents, self.device
        S = getattr(self, "_gpu", None); lat_v = getattr(S, "lat_v", None) if S is not None else None
        lat = float(torch.as_tensor(lat_v).reshape(-1)[0]) if lat_v is not None else 30.2
        hour0 = float(self._mnt_prm[0]) if hasattr(self, "_mnt_prm") else None
        Ff = self._fl_F(); T0 = self._fl_stem(); T0 = T0.reshape(-1)[:3] if T0.dim() > 1 else T0
        P4 = getattr(self, "cs_P4", None)
        A_in = (np.asarray(P4, float) - Ff) if P4 is not None else np.array([0.0, 0.0, -1.0]); A_in = A_in/max(np.linalg.norm(A_in), 1e-9)
        e1 = np.cross(A_in, [0.0, 0.0, 1.0]); e1 = e1 if np.linalg.norm(e1) > 1e-6 else np.cross(A_in, [0.0, 1.0, 0.0])
        e1 = e1/np.linalg.norm(e1); e2 = np.cross(A_in, e1)
        rows = []
        with torch.no_grad():
            for day in range(10, 366, 20):
                for hour in np.arange(7.5, 16.51, 1.0):
                    el, az, _ = solar_batch(torch.full((B,), lat), torch.full((B,), float(day)), float(hour))
                    if float(el.mean()) <= 12.0: continue
                    pnt = torch.stack([el.to(dev).float(), torch.rad2deg(az).to(dev).float()], 1)
                    mnt = self._mount(torch.full((B,), float(day), device=dev), torch.full((B,), lat, device=dev), float(hour), pnt=pnt)
                    n = (mnt["naim"] if "naim" in mnt else mnt["Mt"][:, 2, :]).float(); n = n/torch.linalg.norm(n, dim=1, keepdim=True).clamp(min=1e-9)
                    C = mnt["Cd"].float(); q = pedicel_ik(T0, C[:1], n[:1])
                    d = C[0].cpu().numpy().astype(float) - Ff; d = d - (d@A_in)*A_in
                    rows.append([float(q[k][0]) for k in ("slew", "luff", "ext", "pitch", "yaw")] + [np.degrees(np.arctan2(d@e2, d@e1))])
        if hour0 is not None: self._mnt_prm[0] = hour0
        R = np.array(rows) if rows else np.zeros((1, 6))
        def circ(a):
            a = np.sort(np.mod(a, 360.0)); gaps = np.diff(np.r_[a, a[0] + 360.0]); return float(360.0 - gaps.max())
        self._fl_travel = dict(slew=circ(R[:, 0]), luff=float(np.ptp(R[:, 1])), ext=float(np.ptp(R[:, 2])),
                               pitch=float(np.ptp(R[:, 3])), yaw=float(np.ptp(R[:, 4])), strip=circ(R[:, 5]), n=len(rows))
        return self._fl_travel

    def flower_screws(self, g):
        """the machine's mechanism as SCREWS - (name, axis, point, pitch, travel, load), one per actuated freedom, at
        this pose. Travel is what the joint covers over the machine's own year; load is what its blades would carry,
        the worst moment at the joint over the blade standoff. The pedicel's five are pedicel_screws' axes; the
        secondary's is the strip turning about the bore axis to keep its 1.2 m width facing the head as the head goes
        round F; the tertiary's is M3_TURN about the vertical through P4."""
        tr = self._fl_year_travel(); sc = pedicel_screws(g["T0"], g["Cb"], g["C"], g["n"])
        Lmax = float(self.boom[1]); q15 = 0.5*RHO_AIR*15.0**2
        M_root = (M_HEAD + M_CROWN)*9.81*Lmax + q15*A_DISH*CD_BOWL*Lmax          # gravity at full reach, drag at the tracking limit
        M_wrist = M_HEAD*9.81*D_REC + q15*A_DISH*D_DISH*C_M                      # the head hung D_REC past the wrist, and the pitching moment
        Lb = float(np.linalg.norm(g["Cb"] - g["T0"]))
        S = [("$1 slew", sc["Z"], g["T0"], 0.0, np.radians(tr["slew"]), M_root/R_PIV),
             ("$2 luff", sc["a2"], g["T0"], 0.0, np.radians(tr["luff"]), M_root/R_PIV),
             ("$3 extend", sc["bu"], g["T0"] + 0.5*Lb*sc["bu"], float("inf"), tr["ext"], q15*A_DISH*CD_BOWL),
             ("$4 pitch", sc["a2"], g["Cb"], 0.0, np.radians(tr["pitch"]), M_wrist/R_PIV),
             ("$5 yaw", sc["a5"], g["Cb"], 0.0, np.radians(tr["yaw"]), M_wrist/R_PIV)]
        P4 = getattr(self, "cs_P4", None)
        if P4 is not None:
            Ff = g["Ff"]; P4 = np.asarray(P4, float); A_in = P4 - Ff; A_in = A_in/max(np.linalg.norm(A_in), 1e-9)
            S.append(("M2 strip", A_in, Ff + 0.25*A_in, 0.0, np.radians(tr["strip"]), M2_LOAD))
            S.append(("M3 turn", np.array([0.0, 0.0, 1.0]), P4 - np.array([0.0, 0.0, 0.35]), 0.0,
                      float(self.M3_TURN[1] - self.M3_TURN[0]), M3_LOAD))
        return S

    def _flex_groups(self, S, everything):
        """realise() per group, each with its own standoff: the pedicel at R_PIV with the cross-blade pair, the strip as
        a hollow ring of four radial blades a station at R_PIV_M2, M3 at R_PIV_M3."""
        ped = [x for x in S if x[0].startswith("$")]; m2 = [x for x in S if x[0] == "M2 strip"]; m3 = [x for x in S if x[0] == "M3 turn"]
        out = []
        if ped and (everything or self.flexures >= 2): out.append((ped, dict(radius=R_PIV, n_blades=2)))
        if m2: out.append((m2, dict(radius=R_PIV_M2, n_blades=4, span=0.10)))
        if m3: out.append((m3, dict(radius=R_PIV_M3, n_blades=2)))
        return out

    def flexure_report(self, g=None):
        """THE EVAL. Every joint realised from its screw and scored by tandoor_screw_render.evaluate: kind, stations,
        blade section, softness ratio (the stiffest constrained direction over the freedom asked for; a pivot above
        about 100, a lump below), travel and load. Pose-independent, so cached."""
        if self._flex_rep is None:
            if g is None: g = self._flower_geom(None)
            S = self.flower_screws(g); rows = []
            for scr, kw in self._flex_groups(S, everything=True):
                mem, rp = realise(scr, mat=STEEL, evaluate_too=True, **kw)
                first = {}
                for m in mem: first.setdefault(m["joint"], m)
                for r in rp:
                    m = first.get(r["joint"], {}); scr_ = next(x for x in scr if x[0] == r["joint"])
                    r.update(t=m.get("t"), w=m.get("w"), L=m.get("L"), n_st=m.get("n_stations", 1 if m.get("kind") == "blade" else 0),
                             slenderness=m.get("slenderness"), reason=m.get("reason"), travel=scr_[4], load=scr_[5],
                             prismatic=isinf(scr_[3]) if isinstance(scr_[3], float) else False)
                    rows.append(r)
            self._flex_rep = rows
        return self._flex_rep

    @staticmethod
    def flexure_lines(rep):
        """the report as text, one joint a line"""
        out = []
        for r in rep:
            trav = f"{r['travel']:.2f} m" if r.get("prismatic") else f"{np.degrees(r['travel']):.0f} deg"
            if r.get("ideal"):
                out.append(f"{r['joint']:<10} {trav:>8} {r['load']/1e3:6.1f} kN  {r['kind']:<18} {r.get('reason') or ''}")
            else:
                out.append(f"{r['joint']:<10} {trav:>8} {r['load']/1e3:6.1f} kN  {r['kind']:<18} {r['n_st']:2d} stations, blade "
                           f"{1e3*r['t']:.1f} x {1e3*r['w']:.0f} x {1e3*r['L']:.0f} mm, {r['mass_kg']:.0f} kg, softness {r['softness_ratio']:.0f}"
                           f"  {'PIVOT' if r['good_pivot'] else 'a lump, not a pivot'}")
        return out

    def _draw_flexures(self, pr, v3, g):
        """draw what realise() returns - blades as OUTLINES of their planes, slaving links, pins - and one short label a
        joint, above its stack. Filled planes at true scale hid the machine (the pedicel's are 9 m long)."""
        if not self.flexures: return
        rep = {r["joint"]: r for r in self.flexure_report(g)}
        members = []
        for scr, kw in self._flex_groups(self.flower_screws(g), everything=False): members += realise(scr, mat=STEEL, **kw)
        ce, cl, cp = (90, 170, 235, 170), (255, 200, 90, 160), (210, 120, 120, 255)
        tops = {}
        for m in members:
            v = m["verts"]
            if m["kind"] in ("blade", "leaf parallelogram"):
                for i in range(4): pr.draw_line_3d(v3(v[i]), v3(v[(i + 1) % 4]), ce)
            elif m["kind"] == "slaving link": pr.draw_line_3d(v3(v[0]), v3(v[1]), cl)
            elif m["kind"] == "pin": pr.draw_cylinder_ex(v3(v[0]), v3(v[1]), 0.07, 0.07, 8, cp)
            elif m["kind"] == "rigid slide": pr.draw_line_3d(v3(v[0]), v3(v[1]), cp)
            t = tops.get(m["joint"]); hi = v[np.argmax(v[:, 2])]
            if t is None or hi[2] > t[2]: tops[m["joint"]] = hi
        for j, top in tops.items():
            r = rep.get(j, {})
            if r.get("ideal"): lab = f"{j}: {r['kind']}"
            else: lab = f"{j}: {r.get('n_st', 0)} st, {1e3*r['t']:.0f}x{1e3*r['w']:.0f}x{1e3*r['L']:.0f} mm, {r['mass_kg']:.0f} kg, s{r['softness_ratio']:.0f}"
            self._pot_lbls.append((top + np.array([0.0, 0.0, 0.35]), lab, ce if (r.get("ideal") or r.get("good_pivot")) else cp))

    def _draw_bent(self, pr, v3, g):
        """the stem and boom as the compliant members they are: their elastic curve under this step's drag, x FLEX_EXAG;
        the chain's own centre of rotation; and the optical NEUTRAL POINT, the centre a bent chain would have to turn
        about for the image at F to stay put. The gap between the two markers IS the walk."""
        F = self._fl
        if F is None or "g_tr" not in F: return
        T0, Cb, foot = g["T0"], g["Cb"], g["foot"]; bu = Cb - T0; Lb = max(float(np.linalg.norm(bu)), 1e-9); bu = bu/Lb
        w = np.array([self._fl_what_x, 0.0, 0.0]); t = w - (w@bu)*bu; tn = float(np.linalg.norm(t))
        if tn < 1e-6: return
        t = t/tn; P = float(F["drag"][0])*tn; m = D_REC*float(g["n"]@bu); Ls = max(float(np.linalg.norm(T0 - foot)), 1e-6)
        zs = np.linspace(0.0, Ls, 8); ys = P*(zs**2*(3*Ls - zs)/(6*EI_STEM) + (Lb + m)*zs**2/(2*EI_STEM))
        th_s = P*(Ls*Ls/2 + (Lb + m)*Ls)/EI_STEM; d_s = float(ys[-1])
        xs = np.linspace(0.0, Lb, 16); yb = d_s + th_s*xs + P*(xs**2*(3*Lb - xs)/(6*EI_BOOM) + m*xs**2/(2*EI_BOOM))
        th = th_s + P*(Lb*Lb/2 + m*Lb)/EI_BOOM; de = float(yb[-1])
        col = (255, 150, 90, 230)
        pts = ([foot + (z/Ls)*(T0 - foot) + FLEX_EXAG*y*t for z, y in zip(zs, ys)]
               + [T0 + x*bu + FLEX_EXAG*y*t for x, y in zip(xs, yb)])
        for i in range(len(pts) - 1): pr.draw_line_3d(v3(pts[i]), v3(pts[i + 1]), col)
        pr.draw_line_3d(v3(pts[-1]), v3(g["C"] + FLEX_EXAG*de*t + FLEX_EXAG*th*np.cross(np.cross(bu, t), g["C"] - Cb)), col)
        self._pot_lbls.append((pts[-1] + np.array([0.0, 0.0, 0.5]), f"bent x{FLEX_EXAG:.0f}: {1e3*de:.2f} mm, {1e3*th:.2f} mrad", col))
        r_chain = de/max(th, 1e-12)
        g_tr, g_rot = float(F["g_tr"][0]), float(F["g_rot"][0])
        pr.draw_sphere(v3(Cb - r_chain*bu), 0.09, col)
        self._pot_lbls.append((Cb - r_chain*bu + np.array([0.0, 0.0, -0.3]), f"chain centre {r_chain:.1f} m back", col))
        if abs(g_tr) > 1e-9:
            r_star = -g_rot/g_tr; cn = (120, 255, 160, 255)
            pr.draw_sphere(v3(Cb - r_star*bu), 0.09, cn)
            self._pot_lbls.append((Cb - r_star*bu + np.array([0.0, 0.0, 0.3]), f"neutral point {r_star:.1f} m back", cn))
            self._fl_neutral = (r_chain, r_star)

    # ------------------------------------------------------------ drawing (pyray), called from the patched base renderer
    def _flower_geom(self, H):
        """the mount's geometry. H is the TRACE, and the trace is not always there - the sun goes out of band, the
        megakernel path skips it, the env has not stepped yet. The frame is still there when the light is not, so the
        pose falls back to the mount's own solve and the stem is drawn either way."""
        if H is not None and "C" in H:
            C = np.asarray(H["C"], float); n = np.asarray(H["naim"], float)
        else:
            Ct, nt = self._fl_head_pose()
            if Ct is None:                                    # nothing has stepped yet: park it on the orbit
                Ff = self._fl_F(); C = Ff + np.array([0.0, 0.0, float(self.g_orbit)]); n = np.array([0.0, 0.0, -1.0])
            else:
                C = Ct[0].detach().cpu().numpy().astype(float); n = nt[0].detach().cpu().numpy().astype(float)
        n = np.asarray(n, float); n = n/max(np.linalg.norm(n), 1e-9)
        Ff = self._fl_F()
        if self.base == "ring":                                                        # the carriage stands where the rail put it
            phi = float(self._fl["q_rail"][0]) if self._fl is not None else 0.0
            T0 = np.array([Ff[0] + self.ring_r*np.cos(phi), Ff[1] + self.ring_r*np.sin(phi), self.z_deck + self.stem_z])
        else:
            T0 = np.array([Ff[0] + self.stem_x, Ff[1], self.z_deck + self.stem_z])
        foot = np.array([T0[0], T0[1], self.z_deck])
        ref = np.array([-1.0, 0, 0]); xl = ref - n*(ref@n)
        if np.linalg.norm(xl) < 1e-6: xl = np.array([0, 1.0, 0]) - n*n[1]
        xl /= np.linalg.norm(xl); yl = np.cross(n, xl); Cb = C - D_REC*n; Cp = C - D_BACK*n
        return dict(C=C, n=n, T0=T0, foot=foot, Cb=Cb, Cp=Cp,
                    B=[Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG],
                    P=[Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG], xl=xl, yl=yl, Ff=Ff)

    def _draw_flower(self, pr, v3, ring, disc, H, hdir, zh_):
        g = self._flower_geom(H); fl = self._fl_scalars()
        self._draw_chain(pr, v3)                              # the secondary and tertiary frames, trace or no trace
        stem, boom, ringc = (128, 84, 40, 255), (150, 100, 52, 255), (90, 100, 120, 255)
        zd = float(self.z_deck); zr = float(TandoorHashemiEnv.render.__globals__["Z_ROOF"]); Ff = g["Ff"]
        dx0, dx1, dy = Ff[0] - 3.0, Ff[0] + 6.0, 5.5
        for gx in np.linspace(dx0, dx1, 10): pr.draw_line_3d(v3([gx, -dy, zd]), v3([gx, dy, zd]), (150, 140, 120, 255))      # the machine deck
        for gy in np.linspace(-dy, dy, 12): pr.draw_line_3d(v3([dx0, gy, zd]), v3([dx1, gy, zd]), (150, 140, 120, 255))
        for cx in np.linspace(dx0, dx1, 4):
            for cy in (-dy, dy): pr.draw_line_3d(v3([cx, cy, zr]), v3([cx, cy, zd]), (120, 110, 95, 255))                     # its stubs to the roof
        if self.base == "ring":
            # $0: the ring rail round the pipe, and the carriage on it. This is what makes the boom short - and r 4 m, not 3,
            # is what keeps it out of the head's own aperture.
            th = np.linspace(0, 2*np.pi, 97); zr_ = self.z_deck + self.stem_z
            rp = [np.array([Ff[0] + self.ring_r*np.cos(t_), Ff[1] + self.ring_r*np.sin(t_), zr_]) for t_ in th]
            for k in range(96): pr.draw_line_3d(v3(rp[k]), v3(rp[k+1]), (150, 140, 120, 255))
            for t_ in np.linspace(0, 2*np.pi, 13)[:-1]:                                                # the rail's own posts
                q_ = np.array([Ff[0] + self.ring_r*np.cos(t_), Ff[1] + self.ring_r*np.sin(t_), zr_])
                pr.draw_line_3d(v3(q_), v3([q_[0], q_[1], zd]), (120, 110, 95, 255))
            car = g["T0"]; tang = np.array([-np.sin(float(self._fl["q_rail"][0]) if self._fl is not None else 0.0),
                                            np.cos(float(self._fl["q_rail"][0]) if self._fl is not None else 0.0), 0.0])
            pr.draw_cylinder_ex(v3(car - 0.35*tang), v3(car + 0.35*tang), 0.22, 0.22, 10, stem)        # the carriage
            self._pot_lbls.append((car + np.array([0, 0, 0.45]), f"$0 carriage {np.degrees(float(self._fl['q_rail'][0])) if self._fl is not None else 0.0:+.0f} deg on the r {self.ring_r:.0f} m rail", (255, 170, 60, 255)))
        else:
            pr.draw_cylinder_ex(v3(g["foot"] - np.array([0, 0, 0.04])), v3(g["foot"] + np.array([0, 0, 0.04])), 0.30, 0.30, 16, (90, 80, 70, 255))
            pr.draw_cylinder_ex(v3(g["foot"]), v3(g["T0"]), 0.108, 0.108, 12, stem)                    # stem: steel CHS 215 x 9
        pr.draw_sphere(v3(g["T0"]), 0.16, ringc)                                                       # the slew and luff servos
        # the boom, drawn as the two-stage telescope it has to be at a 8:1 stroke, and coloured by how much is out
        bu_ = (g["Cb"] - g["T0"]); Lb_ = max(np.linalg.norm(bu_), 1e-9); bu_ = bu_/Lb_
        out = np.clip((Lb_ - self.boom[0])/max(self.boom[1] - self.boom[0], 1e-6), 0, 1)
        root = min(Lb_, 0.6*self.boom[1])                                                              # the telescope: root stage, then the sliding one
        pr.draw_cylinder_ex(v3(g["T0"]), v3(g["T0"] + root*bu_), 0.115, 0.115, 12, boom)
        if Lb_ > root: pr.draw_cylinder_ex(v3(g["T0"] + root*bu_), v3(g["Cb"]), 0.088, 0.088, 12, (int(150 + 80*out), int(110 - 40*out), 60, 255))
        pr.draw_sphere(v3(g["Cb"]), 0.14, ringc)                                                       # the wrist
        e1, e2 = g["xl"], g["yl"]; t = np.linspace(0, 2*np.pi, 49)
        for r_, c_, col in ((R_REC, g["Cb"], stem), (R_PLAT, g["Cp"], ringc)):
            pts = [c_ + r_*(np.cos(x)*e1 + np.sin(x)*e2) for x in t]
            for k in range(48): pr.draw_line_3d(v3(pts[k]), v3(pts[k+1]), col)
        for a in BASE_ANG: pr.draw_line_3d(v3(g["Cb"]), v3(g["Cb"] + R_REC*(np.cos(a)*e1 + np.sin(a)*e2)), ringc)
        # the six struts, each coloured by ITS OWN axial force against the Euler load of the strut
        leg = np.asarray(fl["leg"], float)
        for j in range(6):
            fr = float(np.clip(abs(leg[j])/(0.35*P_CR_LEG), 0, 1))
            scol = (int(110 + 145*fr), int(150*(1 - fr) + 50), int(170*(1 - fr)), 255) if leg[j] < 0 else (int(90 + 60*fr), int(160 + 60*fr), int(220 - 60*fr), 255)
            pr.draw_cylinder_ex(v3(g["B"][j]), v3(g["P"][j]), 0.0425, 0.0425, 8, scol)
            pr.draw_sphere(v3(g["B"][j]), 0.06, ringc); pr.draw_sphere(v3(g["P"][j]), 0.06, ringc)
        # THE PEDICEL'S SCREW SYSTEM, drawn where it acts, each axis tagged with its joint's travel
        sc = pedicel_screws(g["T0"], g["Cb"], g["C"], g["n"]); self._fl_screw = sc
        rev, pri, hot = (90, 220, 255, 255), (255, 170, 60, 255), (255, 110, 90, 255)
        qq = fl["q"]
        def bar(v, lo, hi):
            return float(np.clip((v - lo)/max(hi - lo, 1e-9), 0, 1))
        def axis(p0, d, half, lab, key, lo, hi, val):
            u_ = bar(val, lo, hi); col = hot if (u_ < 0.03 or u_ > 0.97) else rev
            a_, b_ = np.asarray(p0) - half*np.asarray(d), np.asarray(p0) + half*np.asarray(d)
            pr.draw_line_3d(v3(a_), v3(b_), col)
            for q_ in (a_, b_): pr.draw_sphere(v3(q_), 0.045, col)
            self._pot_lbls.append((b_ + np.array([0, 0, 0.12]), f"{lab} {val:+.0f}" + ("m" if key == "ext" else "d"), col))
        axis(g["T0"], sc["Z"], 0.85, "$1 slew", "slew", *J_LIM["slew"], qq["slew"])
        axis(g["T0"], sc["a2"], 0.85, "$2 luff", "luff", *J_LIM["luff"], qq["luff"])
        axis(g["Cb"], sc["a2"], 0.7, "$4 pitch", "pitch", *J_LIM["pitch"], qq["pitch"])
        axis(g["Cb"], sc["a5"], 0.7, "$5 yaw", "yaw", *J_LIM["yaw"], qq["yaw"])
        mid = 0.5*(g["T0"] + g["Cb"])
        pr.draw_line_3d(v3(mid - 0.45*sc["bu"]), v3(mid + 0.45*sc["bu"]), pri)
        pr.draw_sphere(v3(mid + 0.45*sc["bu"]), 0.05, pri)
        self._pot_lbls.append((mid + 0.55*sc["bu"] + np.array([0, 0, 0.1]), f"$3 extend {Lb_:.2f} m of {self.boom[1]:.1f}", pri))
        self._draw_bent(pr, v3, g)                            # the stem and boom as the compliant members they are
        self._draw_flexures(pr, v3, g)                        # and every joint realised from its screw
        # the wind, its gust, and the stow flag
        C = g["C"]; w = np.array([self._fl_what_x, 0.0, 0.0]); base = C - 4.5*w + np.array([0, 0, 0.8])
        L = 0.25*fl["V"]; Lg = 0.25*max(fl["V"] + fl["gust"], 0.0)
        pr.draw_line_3d(v3(base), v3(base + L*w), (120, 200, 240, 220))
        pr.draw_line_3d(v3(base + L*w), v3(base + Lg*w), (250, 120, 60, 240) if fl["gust"] > 0 else (80, 140, 200, 200))
        for k in range(3):
            o = np.array([0, 0.25*(k - 1), 0.0]); pr.draw_line_3d(v3(base + o), v3(base + o + L*w), (120, 200, 240, 110))
        self._pot_lbls.append((base + np.array([0, 0, 0.35]),
                               f"wind {fl['V']:.1f} {'+' if fl['gust'] >= 0 else '-'}{abs(fl['gust']):.1f} m/s" + ("  STOWED" if fl["stow"] > 0.5 else ""),
                               (255, 120, 90, 255) if fl["stow"] > 0.5 else (140, 210, 245, 255)))
        # the image at F: where it walks, and what it would have been with the crown held rigid
        ex = np.cross(g["n"], zh_); ex = ex/max(np.linalg.norm(ex), 1e-9); ey = np.cross(ex, g["n"])
        spot = Ff + 5.0*(fl["walk"][0]*ey + fl["walk"][1]*ex)
        ring(spot, 0.08 + 2*fl["sig_mem"]*G_ORB, (255, 200, 60, 255), 16); pr.draw_line_3d(v3(Ff), v3(spot), (255, 200, 60, 160))
        if fl["walk_open"] > 0:
            ring(Ff, 5.0*fl["walk_open"], (255, 110, 90, 120), 20)
            self._pot_lbls.append((Ff + np.array([0, 0, -0.35]), f"open loop {100*fl['walk_open']:.1f} cm (x5)", (255, 130, 110, 220)))
        self._pot_lbls.append((spot + np.array([0, 0, 0.25]), f"image walk {100*np.linalg.norm(fl['walk']):.1f} cm (x5)", (255, 210, 90, 255)))

    def _draw_chain(self, pr, v3):
        """THE FRAMES OF ALL THREE MIRRORS, drawn from the machine's own conic constants rather than sketched.

        primary    the membrane on its calyx, carried by the flower - drawn by _draw_flower
        secondary  the hyperboloid strip at F: a surface of revolution about cs_A through cs_O with semi-axes
                   a = cs_a, b = sqrt(c^2 - a^2). It is a STRIP - w_strip long, r_strip across - and it is held on
                   the post from the wall tower (cs_Ps), which is the only thing standing in the beam.
        tertiary   M3 at the turn: the ellipsoid patch at cs_P4, turned about the vertical by the aim head, on its
                   stub into the chase wall. Its normal is cs_n4 carried through the same turn.
        and the bore between them, drawn as the wireframe tube it is so you can see the beam inside it."""
        cs_P4 = getattr(self, "cs_P4", None)
        if cs_P4 is None: return                              # not a Cassegrain chain: nothing to draw here
        F = self._fl_F(); P4 = np.asarray(cs_P4, float)
        col_m2, col_m3, col_st, col_bore = (170, 200, 230, 255), (200, 190, 140, 255), (120, 115, 105, 255), (70, 80, 95, 160)

        def loop(pts, col):
            for i in range(len(pts) - 1): pr.draw_line_3d(v3(pts[i]), v3(pts[i + 1]), col)
            pr.draw_line_3d(v3(pts[-1]), v3(pts[0]), col)
        def frame_of(ax):
            e1 = np.cross(ax, [0.0, 0.0, 1.0])
            if np.linalg.norm(e1) < 1e-6: e1 = np.cross(ax, [0.0, 1.0, 0.0])
            e1 = e1/np.linalg.norm(e1); return e1, np.cross(ax, e1)

        # ---- the bore: F down to the turn, as rings on the real axis (which is tilted when post_offset is not 0)
        A_in = P4 - F; L_bore = float(np.linalg.norm(A_in)); A_in = A_in/max(L_bore, 1e-9)
        e1, e2 = frame_of(A_in); th = np.linspace(0, 2*np.pi, 25)
        rb_ = float(getattr(self, "r_bore", 0.7))
        for t in np.linspace(0.06, 0.97, 9):
            c_ = F + t*L_bore*A_in
            loop([c_ + rb_*(np.cos(x)*e1 + np.sin(x)*e2) for x in th], col_bore)
        for x in np.linspace(0, 2*np.pi, 7)[:-1]:
            d_ = rb_*(np.cos(x)*e1 + np.sin(x)*e2)
            pr.draw_line_3d(v3(F + 0.06*L_bore*A_in + d_), v3(F + 0.97*L_bore*A_in + d_), col_bore)

        # ---- the SECONDARY: the hyperboloid strip, from its own conic
        O = np.asarray(getattr(self, "cs_O", F), float); Ax = np.asarray(getattr(self, "cs_A", A_in), float)
        Ax = Ax/max(np.linalg.norm(Ax), 1e-9)
        a_h, c_h = float(getattr(self, "cs_a", 1.0)), float(getattr(self, "cs_c", 1.2))
        b_h = float(np.sqrt(max(c_h*c_h - a_h*a_h, 1e-9)))
        f1, f2 = frame_of(Ax)
        sgn = 1.0 if float((F - O)@Ax) > 0 else -1.0         # the sheet F sits on
        t0 = a_h + float(getattr(self, "d_strip", 0.6))*0.0   # the sheet's vertex
        rows = []
        for t in np.linspace(t0, t0 + float(getattr(self, "w_strip", 1.2)), 7):
            r_ = b_h*np.sqrt(max((t/a_h)**2 - 1.0, 0.0))
            r_ = min(r_, float(getattr(self, "r_strip", 0.6)))
            c_ = O + sgn*t*Ax
            rows.append([c_ + r_*(np.cos(x)*f1 + np.sin(x)*f2) for x in th])
            loop(rows[-1], col_m2)
        for k in range(0, len(th) - 1, 4):
            for i in range(len(rows) - 1): pr.draw_line_3d(v3(rows[i][k]), v3(rows[i + 1][k]), col_m2)
        # the post that holds it: the only structure standing in the beam
        Ps = np.asarray(getattr(self, "cs_Ps", np.array([F[0], 0.0, float(self.z_deck)])), float)
        pr.draw_cylinder_ex(v3(Ps), v3(F), 0.06, 0.06, 8, col_st)
        for zz in np.linspace(float(self.z_deck), Ps[2], 4):
            loop([np.array([Ps[0] + 0.16*np.cos(x), Ps[1] + 0.16*np.sin(x), zz]) for x in th], col_st)

        # ---- the TERTIARY: M3 at the turn, where the aim head has actually put it
        try:
            from tandoor_polar_env import SPOT_PHI0 as _SP0
            psi = float(np.asarray(self._spot_view[0]).reshape(-1)[0]) - float(_SP0) if getattr(self, "_spot_view", None) is not None else 0.0
            psi = float(np.clip(psi, self.M3_TURN[0], self.M3_TURN[1])) if getattr(self, "tri", 0) else 0.0
        except Exception:
            psi = 0.0
        n4 = np.asarray(getattr(self, "cs_n4", np.array([0.0, 0.0, 1.0])), float)
        c_, s_ = np.cos(psi), np.sin(psi)
        n4 = np.array([c_*n4[0] - s_*n4[1], s_*n4[0] + c_*n4[1], n4[2]])
        n4 = n4/max(np.linalg.norm(n4), 1e-9)
        g1, g2 = frame_of(n4); r_m4 = float(getattr(self, "r_m4", 1.3))
        for rr in np.linspace(0.2, 1.0, 4)*r_m4:
            loop([P4 + rr*(np.cos(x)*g1 + np.sin(x)*g2) for x in th], col_m3)
        for x in np.linspace(0, 2*np.pi, 9)[:-1]:
            pr.draw_line_3d(v3(P4), v3(P4 + r_m4*(np.cos(x)*g1 + np.sin(x)*g2)), col_m3)
        pr.draw_line_3d(v3(P4), v3(P4 + 0.6*n4), (240, 210, 120, 255))      # where it is pointing
        F4 = np.asarray(getattr(self, "cs_F4", P4), float)
        pr.draw_line_3d(v3(P4), v3(F4), (240, 190, 90, 200))                # and at what
        pr.draw_cylinder_ex(v3(P4), v3(P4 - 0.5*n4), 0.10, 0.10, 8, col_st)  # its stub into the chase wall

    def _draw_flower_hud(self, pr):
        fl = self._fl_scalars(); y0 = 12; sc = getattr(self, "_fl_screw", None); q = fl["q"]
        q_w = 0.6*fl["V"]**2; sig_env = 0.88e-3*(max(q_w, 1e-9)/15.0)**0.6
        leg = np.asarray(fl["leg"], float)
        lines = [
            "THE FLOWER   " + (f"a carriage on the r {self.ring_r:.0f} m ring rail round the pipe, {self.stem_z:.1f} m up . pedicel 6 joints"
                               if self.base == "ring" else
                               f"a {self.stem_z:.0f} m stem on the deck {self.stem_x:.0f} m north of the pipe . pedicel 5 joints")
            + " . crown 6 struts on flexure balls, the fine stage"
            + ("   [STOWED: wind over " + f"{self.stow_wind:.0f} m/s, head parked face-up]" if fl["stow"] > 0.5 else ""),
            f"wind {fl['V']:.1f} m/s mean, gust {fl['gust']:+.1f} (von Karman, Iu {IU}, from the {self.wind_from})"
            + (f"  [x{self.wind_scale:.1f}]" if self.wind_scale != 1.0 else "")
            + f"   drag {fl['drag']/1e3:.2f} kN  lift {fl['lift']/1e3:.2f} kN  pitching {fl['pitch']/1e3:.2f} kN m",
            (f"pedicel  $0 carriage {np.degrees(fl['rail']):+7.1f} deg on the r {self.ring_r:.0f} m ring rail   " if self.base == "ring" else "pedicel  ")
            + f"$1 slew {q['slew']:+7.1f} [{self.j_lim['slew'][0]:.0f},{self.j_lim['slew'][1]:.0f}]   $2 luff {q['luff']:+6.1f} [{self.j_lim['luff'][0]:.0f},{self.j_lim['luff'][1]:.0f}]"
            f"   $3 extend {q['ext']:5.2f} m [{self.boom[0]:.2f},{self.boom[1]:.2f}] (asked {fl['ext_ask']:5.2f})   $4 pitch {q['pitch']:6.1f}   $5 yaw {q['yaw']:+6.1f}",
            f"         at a limit: {fl['lim_hit']:.0f} joints . rate-limited: {fl['rate_hit']:.0f} . pose shortfall {1e3*fl['pose_err']:.2f} mrad"
            + ("   BOOM THROUGH THE APERTURE" if fl["thru"] > 0.5 else " . the boom clears the aperture")
            + f"   beta {fl['beta']:.0f} deg (the cass optimum; tri traces best at retro)",
            f"structure  boom out {q['ext']:.2f} m -> {1e6*fl['k_img']:.1f} um of image per N of drag, first mode {fl['f_n']:.1f} Hz"
            f"   (fully in, {self.boom[0]:.1f} m: {1e6*float(compliance(torch.tensor([self.boom[0]]))['k_img'][0]):.1f} um/N, {float(compliance(torch.tensor([self.boom[0]]))['f_n'][0]):.0f} Hz;"
            f" the aim law asks {self.boom[0]:.2f}-{self.boom[1]:.2f} m of this base)",
            f"crown  struts " + " ".join(f"{x/1e3:+5.1f}" for x in leg) + f" kN   worst {fl['strut']/1e3:.1f} kN of {P_CR_LEG/1e3:.0f} kN Euler"
            f"   ball {fl['ball_sig']/1e6:.0f} MPa of {SIG_BALL_WORK/1e6:.0f}, {1e3*fl['ball_defl']:.2f} mm, {1e3*fl['ball_ang']:.1f} mrad",
            f"fine stage  {'ON' if self.fine_stage else 'OFF'}  stroke asked {1e3*fl['fine_use']:.1f} mm of {1e3*FINE_STROKE:.0f}"
            + (f"  SATURATED by {1e3*fl['fine_sat']:.1f} mm" if fl["fine_sat"] > 0 else "")
            + f"   open loop {100*fl['walk_open']:.1f} cm -> held to {100*np.linalg.norm(fl['walk']):.2f} cm at F",
            f"pointing handed to the kernel  el {60*fl['d_el']:.2f}'  az {60*fl['d_az']:.2f}'"
            f"   blur: kernel sig_wind {1e3*sig_env:.2f} mrad . film {1e3*fl['sig_mem']:.2f} mrad rms ({'sealed plenum' if fl['plenum'] > 0.5 else 'PLENUM OPEN to the blower'})",
        ]
        if sc is not None:
            lines.append(f"the pedicel's screw system: rank {sc['rank']}/5, condition {sc['cond']:.1f}, smallest singular value {sc['sv'][-1]:.2f}"
                         f"   ($1 slew, $2 luff, $3 extend {sc['Lb']:.2f} m, $4 pitch, $5 yaw; the head's useful output is 5)")
            lines.append(f"the six struts hold a FIXED {L_LEG:.3f} m over the whole year: they are the fine stage, not the pointing. The pedicel alone fixes the pose.")
        nt = getattr(self, "_fl_neutral", None)
        if nt is not None:
            lines.append(f"compliance  chain centre {nt[0]:.1f} m behind the tip, neutral point {nt[1]:.1f} m: the {abs(nt[1] - nt[0]):.1f} m gap is the walk (it moves 8 m over the year; stage3/boom)")
        if self.flexures and self._flex_rep is not None:
            fx = []
            for r in self._flex_rep:
                if r.get("ideal"): fx.append(f"{r['joint']} {r['kind']}")
                elif r["mass_kg"] > 2000: fx.append(f"{r['joint']} {r['mass_kg']/1e3:.0f} t: a bearing")
                else: fx.append(f"{r['joint']} {r['n_st']} st {r['mass_kg']:.0f} kg{'' if r['good_pivot'] else ' lump'}")
            ped = [x for x in fx if x.startswith("$")]; mir = [x for x in fx if not x.startswith("$")]
            lines.append("flexures from the screws  pedicel: " + " . ".join(ped))
            lines.append("                          mirrors: " + " . ".join(mir) + ("   (drawn: M2, M3; --flexures all for the pedicel)" if self.flexures == 1 else ""))
        pr.draw_rectangle(12, y0 - 4, 1000, 18*len(lines) + 8, (10, 12, 18, 175))
        for j, l in enumerate(lines): pr.draw_text(l, 18, y0 + 18*j, 14, (225, 232, 240, 255) if j else (255, 214, 120, 255))


def _patched_render():
    """the Hashemi renderer with its carriage, north tower and arm cut out and the flower drawn in their place"""
    src = textwrap.dedent(inspect.getsource(TandoorHashemiEnv.render))
    def cut(s, start, end, repl):
        i0 = s.index(start); i0 = s.rfind("\n", 0, i0) + 1; ind = s[i0:len(s) - len(s[i0:].lstrip(" "))]
        i1 = s.index(end, i0); i1 = s.index("\n", i1) + 1; return s[:i0] + ind + repl + "\n" + s[i1:]
    src = cut(src, "# fixed ring rail on posts (roof stubs south, courtyard north)", "(110, 110, 120, 255))", "self._draw_flower(pr, v3, ring, disc, H, hdir, zh_)")
    src = cut(src, "pr.draw_line_3d(v3(Ps_), v3(Q_), colt)                    # the arm", "ring([Ps_[0], 0, zz], 0.20, (150, 140, 120, 255), 12)", "pass                                                        # no arm, no north tower: F is the pipe's mouth")
    i = src.index("# the day so far, as line graphs"); j = src.rfind("\n", 0, i) + 1; src = src[:j] + src[j:i] + "self._draw_flower_hud(pr)\n" + src[j:]
    ns = dict(TandoorHashemiEnv.render.__globals__); exec(src, ns); return ns["render"]
TandoorFlowerEnv.render = _patched_render()

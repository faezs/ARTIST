"""Where is the optical NEUTRAL POINT of the head, and can a designed flexure pivot at the boom root - the luff joint's
own compliance - put the chain's wind response on it?

A head rotation theta about a point r behind it along the boom translates the head by r*theta and turns the reflected
beam (mirror doubling makes that ~2 theta). The walk at F is zero at r* = -g_rot/g_tr. Compare r* with the boom
length: if r* sits at the boom root, a soft LUFF pivot is optically inert and the walk-producing part is the boom's
own bending (its own centre is 2Lb/3 behind the tip). Then a pivot whose ratio 1/Lb is on the far side of the optics'
wanted ratio from the boom's 3/(2Lb) cancels the boom, with the pose spread as the residual."""
import sys; exec(open("boom_tune.py").read().split("Ls = 1.0")[0])
from tandoor_flower_env import M_HEAD, M_CROWN, SIG_BALL_WORK
Ls = 1.0
rstar = -grot/gtr
print(f"\nneutral point r* behind the head, along the boom: median {np.median(rstar):.2f} m, 10-90% {np.percentile(rstar,10):.2f}-{np.percentile(rstar,90):.2f}")
print(f"r* - Lb (0 = the boom root, +1 = the stem base): median {np.median(rstar-Lb):+.2f} m, 10-90% {np.percentile(rstar-Lb,10):+.2f}..{np.percentile(rstar-Lb,90):+.2f}")
print(f"the boom's own bending centre is 2Lb/3 behind the tip: median {np.median(2*Lb/3):.2f} m -> {np.median(rstar-2*Lb/3):+.2f} m short of neutral")
# ---- direct check on the last pose: walk per radian for a rotation about points along the boom, and about F
def walk_about(A):
    th = 1e-4; ax = ra
    def pose(sg):
        R = lambda v: v + sg*th*np.cross(ax, v)
        return C + R(C - A) - (C - A), R(n)/np.linalg.norm(R(n))
    Cp, npp = pose(+1); Cm, nm = pose(-1)
    d = (miss(Cp, npp, s) - miss(Cm, nm, s))/(2*th); return float(d@u)
print(f"\nlast pose (Lb {Lb[-1]:.2f}): walk per rad of head rotation about ...")
for lab, A in (("the head itself", C), ("the boom root (stem top)", T0), ("the stem base (roof)", T0 - np.array([0, 0, Ls])),
               ("F", F.cpu().numpy().astype(float) if hasattr(F, "cpu") else np.asarray(F, float)),
               (f"r* = {rstar[-1]:.2f} m back along the boom", C - rstar[-1]*bu)):
    print(f"   {lab:<44} {walk_about(np.asarray(A, float)):+9.4f} m/rad")

# ---- chain with a lumped pivot of compliance c (rad per N m) at the boom root, in series with the built stem and boom
def chain(Lb_, c, kb=1.0):
    th_s = (Ls*Ls/2 + Lb_*Ls)/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)/EI_STEM
    th_p = Lb_*c
    th_b = Lb_*Lb_/(2*EI_BOOM*kb); d_b = Lb_**3/(3*EI_BOOM*kb)
    return th_s + th_p + th_b, d_s + th_s*Lb_ + th_p*Lb_ + d_b
def walk(th, de): return np.abs(grot*th + gtr*de)
wgt = 0.25 + 0.75*cosw*cosw
def rms_w(x): return float(np.sqrt(np.sum(wgt*x*x)/np.sum(wgt)))
base = rms_w(walk(*chain(Lb, 0.0)))
print(f"\nboom as built, rigid luff: {1e6*base:.2f} um/N")
print(f"{'boom':>8} {'best pivot k, MN m/rad':>24} {'walk um/N':>10} {'x built':>8} {'   scheduled (passive, k>=0)':>28} {'   scheduled (active)':>22}")
for kb in (1.0, 2.0, 4.0, 8.0):
    cs = np.geomspace(1e-9, 1e-5, 400); f = [rms_w(walk(*chain(Lb, c, kb))) for c in cs]; i = int(np.argmin(f))
    # per-pose: the pivot compliance that zeroes this pose; passive keeps c >= 0, active lets the servo push
    th0, de0 = chain(Lb, 0.0, kb); c_zero = -(grot*th0 + gtr*de0)/((grot + gtr*Lb)*Lb)
    sched_p = rms_w(walk(*chain(Lb, np.clip(c_zero, 0, None), kb))); sched_a = rms_w(walk(*chain(Lb, c_zero, kb)))
    print(f"{kb:7.1f}x {1e-6/cs[i]:24.2f} {1e6*f[i]:10.2f} {base/f[i]:8.2f}x {1e6*sched_p:14.2f} ({base/sched_p:4.2f}x) {1e6*sched_a:12.2f} ({base/sched_a:4.2f}x)")
    if kb == 1.0:
        k_best = 1/cs[i]; frac_neg = float(np.mean(c_zero < 0))
        print(f"          per-pose zeroing compliance: {100*frac_neg:.0f}% of poses need a NEGATIVE pivot stiffness (the boom is not rotation-dominant there)")
# ---- what the best single pivot means physically
g = 9.81; Lmax = float(Lb.max())
M_g = (M_HEAD + M_CROWN)*g*Lmax                                  # gravity moment at full reach, boom level: the worst static case
q15 = 0.5*1.2*15.0**2; Fw = q15*13.85*0.5; M_w = Fw*Lmax         # drag on the head at the 15 m/s tracking limit, cd 0.5 on the disc
print(f"\nbest single pivot k = {k_best/1e6:.2f} MN m/rad:")
print(f"   gravity sag at full reach {1e3*M_g/k_best:.1f} mrad ({np.degrees(M_g/k_best):.2f} deg, static, a pose-known offset the IK removes)")
print(f"   wind rotation at 15 m/s, full reach {1e3*M_w/k_best:.2f} mrad -> the head moves {1e3*M_w/k_best*Lmax:.1f} mm at the tip (inert if r* is at the root)")
E = 200e9; L_bl = 0.30
for t in (0.03, 0.04, 0.05):
    # a cross-spring pivot: two blades b x t x L, rotational stiffness ~ 2 E I / L, each blade in bending
    I_need = k_best*L_bl/(2*E); b = 12*I_need/t**3
    sig_w = E*t*(M_w/k_best)/(2*L_bl); sig_g = M_g*(t/2)/(2*I_need)
    print(f"   cross-spring, blades {1e3*b:.0f} x {1e3*t:.0f} x {1e3*L_bl:.0f} mm: wind stress {1e-6*sig_w:.0f} MPa, gravity {1e-6*sig_g:.0f} MPa (cap {1e-6*SIG_BALL_WORK:.0f})")

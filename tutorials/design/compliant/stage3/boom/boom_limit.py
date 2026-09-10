"""Where does the reversed telescope saturate? Push the ratio bound out, and add the pure limit: a rigid arm on a
root pivot of rotational stiffness k_th, where theta/delta = 1/Lb exactly. Also weight poses by the wind they see
(drag ~ cos^2 of the head's angle to the wind) instead of equally."""
import sys; exec(open("boom_tune.py").read().split("Ls = 1.0")[0])          # reuse the pose sampling and sensitivities
Ls = 1.0
def two_stage(Lb_, EI1, EI2, L1):
    L1_ = np.minimum(L1, Lb_); L2 = np.maximum(Lb_ - L1_, 0.0)
    th_s = (Ls*Ls/2 + Lb_*Ls)/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)/EI_STEM
    th1 = L1_*L1_/(2*EI1) + L1_*L2/EI1; d1 = L1_**3/(3*EI1) + L1_*L1_*L2/(2*EI1)
    th2 = L2*L2/(2*EI2); d2 = L2**3/(3*EI2)
    return th_s + th1 + th2, d_s + th_s*Lb_ + d1 + th1*L2 + d2
def root_hinge(Lb_, k_th, EI_arm):
    """a rigid-ish arm of EI_arm on a rotational spring k_th at the stem top: theta = P Lb / k_th (+ the arm's own)"""
    th_s = (Ls*Ls/2 + Lb_*Ls)/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)/EI_STEM
    th_h = Lb_/k_th; th_a = Lb_*Lb_/(2*EI_arm); d_a = Lb_**3/(3*EI_arm)
    return th_s + th_h + th_a, d_s + th_s*Lb_ + th_h*Lb_ + d_a
wgt_wind = 0.25 + 0.75*cosw*cosw                          # the head's drag rises with cos^2 of its angle to the wind
def rms_w(x, w): return float(np.sqrt(np.sum(w*x*x)/np.sum(w)))
def walk(theta, delta): return np.abs(grot*theta + gtr*delta)
from scipy.optimize import minimize
th_u, de_u = two_stage(Lb, EI_BOOM, EI_BOOM, 1e9); base = rms_w(walk(th_u, de_u), wgt_wind)
print(f"wind-weighted rms walk, uniform boom as built: {1e6*base:.2f} um/N\n")
print(f"{'design':<52} {'EI2/EI1 or k_th':>16} {'L1':>5} {'rms um/N':>9} {'x built':>8}")
for hi in (19, 50, 200, 1000):
    best = None
    for r0 in np.geomspace(2, hi*0.9, 5):
        for L10 in (0.25, 0.5, 1.0):
            o = minimize(lambda x: rms_w(walk(*two_stage(Lb, EI_BOOM, EI_BOOM*np.exp(x[0]), x[1])), wgt_wind),
                         [np.log(r0), L10], method="L-BFGS-B", bounds=[(0.0, np.log(hi)), (0.2, float(Lb.min()))])
            if best is None or o.fun < best.fun: best = o
    print(f"{'reversed telescope, ratio <= ' + str(hi):<52} {np.exp(best.x[0]):16.1f} {best.x[1]:5.2f} {1e6*best.fun:9.2f} {base/best.fun:8.2f}x")
best = None
for k0 in np.geomspace(1e5, 1e9, 9):
    o = minimize(lambda x: rms_w(walk(*root_hinge(Lb, np.exp(x[0]), EI_BOOM*np.exp(x[1]))), wgt_wind),
                 [np.log(k0), np.log(5.0)], method="L-BFGS-B", bounds=[(np.log(1e4), np.log(1e10)), (0.0, np.log(50.0))])
    if best is None or o.fun < best.fun: best = o
kth, ea = np.exp(best.x[0]), np.exp(best.x[1])
print(f"{'RIGID ARM ON A ROOT PIVOT (the limit)':<52} {kth:16.3g} {'-':>5} {1e6*best.fun:9.2f} {base/best.fun:8.2f}x")
print(f"\n  the limit wants a root pivot of k_th = {kth:.3g} N m/rad under an arm {ea:.1f}x stiffer than CHS 219x8.")
print(f"  that pivot's compliance per metre of arm is 1/Lb - the optics' median want was {np.median(-gtr/grot):.3f} rad/m, and 1/Lb runs {1/Lb.max():.3f}-{1/Lb.min():.3f}.")
print(f"  the pose-to-pose spread in 'want' ({np.percentile(-gtr/grot,10):.3f}-{np.percentile(-gtr/grot,90):.3f}) is what a single passive design cannot follow.")

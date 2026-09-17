"""Is the 2.4x from the RATIO or from the arm simply being STIFFER? Same model, same poses, same weighting."""
import sys; exec(open("boom_tune.py").read().split("Ls = 1.0")[0])
Ls = 1.0
def two_stage(Lb_, EI1, EI2, L1):
    L1_ = np.minimum(L1, Lb_); L2 = np.maximum(Lb_ - L1_, 0.0)
    th_s = (Ls*Ls/2 + Lb_*Ls)/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)/EI_STEM
    th1 = L1_*L1_/(2*EI1) + L1_*L2/EI1; d1 = L1_**3/(3*EI1) + L1_*L1_*L2/(2*EI1)
    th2 = L2*L2/(2*EI2); d2 = L2**3/(3*EI2)
    return th_s + th1 + th2, d_s + th_s*Lb_ + d1 + th1*L2 + d2
wgt = 0.25 + 0.75*cosw*cosw
def rms_w(x): return float(np.sqrt(np.sum(wgt*x*x)/np.sum(wgt)))
def walk(th, de): return np.abs(grot*th + gtr*de)
def ratio_td(th, de): return float(np.median(th/de))
base = rms_w(walk(*two_stage(Lb, EI_BOOM, EI_BOOM, 1e9)))
print(f"{'boom':<52} {'walk um/N':>10} {'x built':>8} {'median th/d':>12}")
print(f"{'(the optics want th/d = ' + format(np.median(-gtr/grot), '.3f') + ')':<52}")
for lab, EI1, EI2, L1 in (("uniform, as built",                       EI_BOOM, EI_BOOM,     1e9),
                          ("uniform, 45x stiffer everywhere",          45*EI_BOOM, 45*EI_BOOM, 1e9),
                          ("uniform, 6.7x stiffer everywhere",         6.7*EI_BOOM, 6.7*EI_BOOM, 1e9),
                          ("reversed: root = built, arm 45x  (boom_limit)", EI_BOOM, 45*EI_BOOM, 0.25),
                          ("reversed: root = built/6.7, arm 6.7x (env)", EI_BOOM/6.7, EI_BOOM*6.7, 0.25),
                          ("reversed: root = built/45, arm = built (stress)", EI_BOOM/45, EI_BOOM, 0.25),
                          ("stem-only: infinitely stiff boom",          1e12, 1e12, 1e9)):
    th, de = two_stage(Lb, EI1, EI2, L1); f = rms_w(walk(th, de))
    print(f"{lab:<52} {1e6*f:10.2f} {base/f:8.2f}x {ratio_td(th, de):12.3f}")
print()
print("if 'uniform 45x stiffer' ~= 'reversed root=built arm 45x', the gain was stiffness, not shape.")
print("the stem-only row is the floor: what the 1 m stem alone contributes with a rigid boom.")

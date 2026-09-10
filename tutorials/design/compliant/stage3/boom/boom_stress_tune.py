"""Re-tune the reversed boom UNDER THE ROOT'S STRESS CAP. Stress in the root goes as M (d/2)/I with I pinned by the
EI the tuning asks for, so the least-stressed round section at a given EI is the SOLID bar (smallest d for that I).
Sweep the ratio, size the root as the least-stressed section that gives its EI, and keep only ratios whose root stays
under the 438 MPa working stress at the 15 m/s tracking limit with the arm at full reach. Report the best walk that
survives - and what a stronger root material buys."""
import sys; exec(open("boom_tune.py").read().split("Ls = 1.0")[0])
Ls = 1.0; E = 200e9
def two_stage(Lb_, EI1, EI2, L1):
    L1_ = np.minimum(L1, Lb_); L2 = np.maximum(Lb_ - L1_, 0.0)
    th_s = (Ls*Ls/2 + Lb_*Ls)/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)/EI_STEM
    th1 = L1_*L1_/(2*EI1) + L1_*L2/EI1; d1 = L1_**3/(3*EI1) + L1_*L1_*L2/(2*EI1)
    th2 = L2*L2/(2*EI2); d2 = L2**3/(3*EI2)
    return th_s + th1 + th2, d_s + th_s*Lb_ + d1 + th1*L2 + d2
wgt = 0.25 + 0.75*cosw*cosw
def rms_w(x): return float(np.sqrt(np.sum(wgt*x*x)/np.sum(wgt)))
def walk(th, de): return np.abs(grot*th + gtr*de)
base = rms_w(walk(*two_stage(Lb, EI_BOOM, EI_BOOM, 1e9)))
F15, ARM = 8.47e3, float(Lb.max())                        # the 15 m/s peak head force, at full reach
print(f"uniform as built: {1e6*base:.2f} um/N. Root stress cap 438 MPa at {F15/1e3:.2f} kN x {ARM:.1f} m = {F15*ARM/1e3:.0f} kN m.\n")
print(f"{'arm/root EI':>12} {'root EI MNm2':>13} {'solid bar d':>12} {'stress MPa':>11} {'ok?':>5} {'walk um/N':>10} {'x built':>8}")
best = None
for ratio in (1, 2, 3, 5, 8, 12, 20, 45):
    # root at the BUILT tube's EI divided by ratio^0.5 keeps the geometric mean; instead pin the ARM to the built tube
    # (an arm no fatter than what we have) and soften only the root - the honest version of 'put the compliance at the root'
    EI_a = EI_BOOM; EI_r = EI_BOOM/ratio
    I_r = EI_r/E; d_solid = (64*I_r/np.pi)**0.25; sig = F15*ARM*(d_solid/2)/I_r
    L1 = 0.25
    f = rms_w(walk(*two_stage(Lb, EI_r, EI_a, L1)))
    ok = sig <= 438e6
    print(f"{ratio:12.0f} {EI_r/1e6:13.2f} {1e3*d_solid:9.0f} mm {sig/1e6:11.0f} {'yes' if ok else 'NO':>5} {1e6*f:10.2f} {base/f:8.2f}x")
    if ok and (best is None or f < best[1]): best = (ratio, f, sig, d_solid)
print()
if best:
    r, f, sig, d = best
    print(f"best that survives the cap: arm/root {r:.0f}, root a solid {1e3*d:.0f} mm bar at {sig/1e6:.0f} MPa -> {1e6*f:.2f} um/N, {base/f:.2f}x built")
print()
print("with a 1800 MPa maraging-steel root (same E), the cap lifts 4x and the ratio can go to:")
for ratio in (20, 45):
    EI_r = EI_BOOM/ratio; I_r = EI_r/E; d_solid = (64*I_r/np.pi)**0.25; sig = F15*ARM*(d_solid/2)/I_r
    f = rms_w(walk(*two_stage(Lb, EI_r, EI_BOOM, 0.25)))
    print(f"   ratio {ratio:2.0f}: {sig/1e6:.0f} MPa vs 1800*0.6 = 1080 working -> {'ok' if sig < 1080e6 else 'NO'},  {1e6*f:.2f} um/N, {base/f:.2f}x")

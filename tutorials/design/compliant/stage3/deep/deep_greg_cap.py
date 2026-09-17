"""the Gregorian cap with its TRUE shadow disc: the rays from F meet the ellipsoid within a(1 - e^2) ~ 2d of the axis, so the
disc the kernel shades the primary with (r_strip) is that, ~0.2 m at d 0.1, not the semi-minor axis. Noon, midsummer, with a
perfect film and with the envs' 4.3 mrad figure."""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_blur.py")).read().split("v, drv = build(); LFP")[0])
v, drv = build(); LFP = float(np.linalg.norm(np.asarray(drv.cs_P4) - np.asarray(drv.F_focus))); v.close()
for c2 in (3.0, 1.2):
    c = c2/2; d = 0.1; a = c + d; e = c/a; r_cap = a*(1 - e*e)
    v, drv = build(sec_side="greg", d_strip=d, r_strip=float(r_cap), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0, m4_mode="relay", u_f2=float(LFP - 2*c))
    print(f"F2 {c2:.1f} m from F, cap 0.1 m beyond, shadow disc r {r_cap:.3f} m ({100*r_cap*r_cap/2.1**2:.2f} %), magnification {(2*c + d)/d:.0f}")
    for f in (1.05, 1.5):
        for sig in (0.0, 0.0043):
            print(f"   f {f}: figure {1e3*sig:.1f} mrad -> {100*thr_at(drv, f, sig):5.1f} % through at noon")
    v.close()

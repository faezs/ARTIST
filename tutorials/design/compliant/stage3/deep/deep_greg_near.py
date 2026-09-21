"""the Gregorian cap with F2 brought near F (m4_mode relay, u_f2 large): the cap's half-width b = sqrt(2 c d) falls with c, so
the shadow falls with it; what the chain then does with the fast beam below F2 is the kernel's to say"""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_greg.py")).read().split("results = {}")[0])
v, drv = build()
F = np.asarray(drv.F_focus); P4 = np.asarray(drv.cs_P4); LFP = float(np.linalg.norm(P4 - F))
print(f"built: |P4 - F| {LFP:.2f} m, |F2 - F| {2*float(drv.cs_c):.2f} m (F2 = P4: the image on M4, field mode)")
v.close()
for c_target in (1.5, 0.6):
    u = LFP - 2*c_target; d = 0.1; b = np.sqrt(2*c_target*d + d*d)
    try:
        v, drv = build(sec_side="greg", d_strip=d, r_strip=float(b), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0, m4_mode="relay", u_f2=float(u))
    except Exception as e:
        print(f"c {c_target}: build failed: {e}"); continue
    study(drv, [None, 1.05], f"Gregorian cap 0.1 m beyond F with F2 {2*c_target:.1f} m from F (u_f2 {u:.1f})")
    v.close()

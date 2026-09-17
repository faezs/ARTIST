"""the year again with the better cap: the Gregorian D_CAP m beyond F (env var, 0.1 by default) with F2 3 m from F (m4_mode relay,
u_f2 = |P4 - F| - 3). The kernel's shadow sphere is the cap the rays meet, a(1 - e^2) ~ 2 D_CAP across from the axis at F's level
(deep_greg_cap.py), not the ellipsoid's semi-minor axis: 0.19 m at 0.1, inside the 0.5 m hole. SIGB sets the per-ray figure."""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_year.py")).read()
head = src.split("v, drv = build(); base = sweep(drv, None); v.close()")[0]
exec(head)
v, drv = build(); base = sweep(drv, None); LFP = float(np.linalg.norm(np.asarray(drv.cs_P4) - np.asarray(drv.F_focus))); v.close()
c = 1.5; d = float(os.environ.get("D_CAP", "0.1")); b = (c + d)*(1 - (c/(c + d))**2)   # the cap the rays meet: a(1 - e^2) ~ 2d, its true shadow disc
v, drv = build(sec_side="greg", d_strip=d, r_strip=float(b), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0, m4_mode="relay", u_f2=float(LFP - 2*c))
deep = {f: sweep(drv, f) for f in (1.05, 1.5)}; v.close()
print(f"\nrays through (%), the Gregorian cap {d} m beyond F with F2 3 m from F (cap r {b:.3f} m, shadow {100*b*b/(2.1*2.1):.1f} % inside the hole, magnification {(2*c + d)/d:.0f}); 'axis' = the crossing rays counted as passed")
print(f"{'day':<10} {'hour':>4} {'el':>5} | {'built f4':>8} | {'deep 1.05':>9} {'axis 1.05':>9} | {'deep 1.5':>8} {'axis 1.5':>8}")
tot = {}
for dname in DAYS:
    for hour in HRS:
        b0 = base[(dname, hour)]; d1 = deep[1.05][(dname, hour)]; d2 = deep[1.5][(dname, hour)]
        print(f"{dname:<10} {hour:4d} {b0['el']:5.1f} | {100*b0['thr']:7.1f}% | {100*d1['thr']:8.1f}% {100*(d1['thr'] + d1['cross']):8.1f}% | {100*d2['thr']:7.1f}% {100*(d2['thr'] + d2['cross']):7.1f}%")
        for k, val in (("built", b0["thr"]), ("deep1.05", d1["thr"]), ("axis1.05", d1["thr"] + d1["cross"]), ("deep1.5", d2["thr"]), ("axis1.5", d2["thr"] + d2["cross"])):
            tot.setdefault((dname, k), 0.0); tot[(dname, k)] += val*max(np.sin(np.radians(b0["el"])), 0.0)
print("\nsummed over the nine hours weighted by sin(el), relative to the built machine:")
for dname in DAYS:
    bb = max(tot[(dname, "built")], 1e-9)
    print(f"  {dname:<10} built 1.00 | deep 1.05 {tot[(dname, 'deep1.05')]/bb:5.2f}  axis 1.05 {tot[(dname, 'axis1.05')]/bb:5.2f} | deep 1.5 {tot[(dname, 'deep1.5')]/bb:5.2f}  axis 1.5 {tot[(dname, 'axis1.5')]/bb:5.2f}")

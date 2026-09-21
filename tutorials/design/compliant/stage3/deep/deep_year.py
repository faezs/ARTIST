"""the year: midwinter, equinox, midsummer x nine hours, the built machine against the deep Gregorian (cap 0.1 m beyond F,
full cap, F2 on M4 as built). Two readings per hour for the deep dish: as traced with the vertical bore, and the same with
the 'crossing' rays (the bore through the deep bowl) counted as passed - the upper bound a beam down the dish's own
axis (the fourth pass's stalk) would reach, since everything that reaches the cap passes the rest of the chain."""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_greg.py")).read().split("results = {}")[0]
exec(src)
DAYS = {"midwinter": 355.0, "equinox": 80.0, "midsummer": 172.0}; HRS = [8, 9, 10, 11, 12, 13, 14, 15, 16]
def sweep(drv, f):
    dev = drv.device; B = drv.num_agents
    pts0 = drv._pts_l.clone(); nrm0 = drv._nrm_l.clone(); fct0 = drv._fct.clone(); L, P, _ = pts0.shape
    xy = pts0[:, :, :2]; w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
    if f is not None:
        z = (xy[..., 0]**2 + xy[..., 1]**2)/(4*f); drv._pts_l = torch.cat([xy, z[..., None]], 2).contiguous()
        n = torch.stack([-xy[..., 0]/(2*f), -xy[..., 1]/(2*f), torch.ones_like(z)], 2); drv._nrm_l = (n/torch.linalg.norm(n, dim=2, keepdim=True)).contiguous()
        drv._fct[:, 53] = f; drv._fct[:, 55] = f; drv._fct[:, 32] = f
    out = {}
    for dname, day in DAYS.items():
        for hour in HRS:
            day_t = torch.full((B,), day, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
            m0 = drv._mount(day_t, lat_t, float(hour), pnt=None, mech=False)
            el = float(m0["aux"][0, 0])
            if el < 12.0: out[(dname, hour)] = dict(el=el, thr=0.0, cross=0.0, power=0.0); continue
            pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
            m = drv._mount(day_t, lat_t, float(hour), pnt=pnt, mech=False)
            C = m["Cd"].clone(); n = m["Mt"][:, 2, :].clone()
            elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
            drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
            drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
            if float(os.environ.get("SIGB", "0")) > 0:                      # the per-ray figure noise, off in the fast env at reset (du = de = 0)
                g = torch.Generator(device="cpu").manual_seed(int(day) + hour)
                drv._tr["du"] = torch.randn(B, P, generator=g).to(dev); drv._tr["de"] = torch.randn(B, P, generator=g).to(dev)
            lv = torch.full((B,), float(L//2), device=dev); sigb = torch.full((B,), float(os.environ.get("SIGB", "0.003")), device=dev)
            thr, out6, per = drv.trace(C.contiguous(), n.contiguous(), lv, sigb)
            fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
            out[(dname, hour)] = dict(el=el, thr=float(((fate == 0).float()*w_ray[None]).sum(1).mean()), cross=float(((fate == 5).float()*w_ray[None]).sum(1).mean()), power=float(per.sum(1).mean()))
    drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0
    return out
v, drv = build(); base = sweep(drv, None); v.close()
c_h = float(drv.cs_c); d = 0.1; b = np.sqrt(2*c_h*d + d*d)
v, drv = build(sec_side="greg", d_strip=d, r_strip=float(b), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0)
deep = {f: sweep(drv, f) for f in (1.05, 1.5)}; v.close()
print(f"\nrays through (%), by day and hour; deep = the Gregorian cap 0.1 m beyond F (shadow {100*np.pi*b*b/(np.pi*2.1*2.1):.0f} %); 'axis' = the deep dish with the crossing rays counted as passed")
print(f"{'day':<10} {'hour':>4} {'el':>5} | {'built f4':>8} | {'deep 1.05':>9} {'axis 1.05':>9} | {'deep 1.5':>8} {'axis 1.5':>8}")
tot = {}
for dname in DAYS:
    for hour in HRS:
        b0 = base[(dname, hour)]; d1 = deep[1.05][(dname, hour)]; d2 = deep[1.5][(dname, hour)]
        print(f"{dname:<10} {hour:4d} {b0['el']:5.1f} | {100*b0['thr']:7.1f}% | {100*d1['thr']:8.1f}% {100*(d1['thr'] + d1['cross']):8.1f}% | {100*d2['thr']:7.1f}% {100*(d2['thr'] + d2['cross']):7.1f}%")
        for k, val in (("built", b0["thr"]), ("deep1.05", d1["thr"]), ("axis1.05", d1["thr"] + d1["cross"]), ("deep1.5", d2["thr"]), ("axis1.5", d2["thr"] + d2["cross"])):
            tot.setdefault((dname, k), 0.0); tot[(dname, k)] += val*max(np.sin(np.radians(b0["el"])), 0.0)   # weight by the sun's elevation (the aperture's projected irradiance is per unit area normal to the sun: the dish tracks, so the weight is the day's DNI shape ~ sin(el)^0.5..1; sin(el) here)
print("\nrays through, summed over the nine hours weighted by sin(el) (a crude clear-sky DNI shape), relative to the built machine:")
for dname in DAYS:
    bb = max(tot[(dname, "built")], 1e-9)
    print(f"  {dname:<10} built 1.00 | deep 1.05 {tot[(dname, 'deep1.05')]/bb:5.2f}  axis 1.05 {tot[(dname, 'axis1.05')]/bb:5.2f} | deep 1.5 {tot[(dname, 'deep1.5')]/bb:5.2f}  axis 1.5 {tot[(dname, 'axis1.5')]/bb:5.2f}")

"""the two machines' tolerance to the film's figure error, in the trace: the same slope noise per ray (sigb) blurs the spot at F
in proportion to the path to F, so the deep dish should keep its throughput where the shallow one loses it. Noon, midsummer."""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_greg.py")).read().split("results = {}")[0]
exec(src)
def thr_at(drv, f, sig, hour=12.0):
    dev = drv.device; B = drv.num_agents; pts0 = drv._pts_l.clone(); nrm0 = drv._nrm_l.clone(); fct0 = drv._fct.clone(); L, P, _ = pts0.shape
    xy = pts0[:, :, :2]; w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
    if f is not None:
        z = (xy[..., 0]**2 + xy[..., 1]**2)/(4*f); drv._pts_l = torch.cat([xy, z[..., None]], 2).contiguous()
        n = torch.stack([-xy[..., 0]/(2*f), -xy[..., 1]/(2*f), torch.ones_like(z)], 2); drv._nrm_l = (n/torch.linalg.norm(n, dim=2, keepdim=True)).contiguous()
        drv._fct[:, 53] = f; drv._fct[:, 55] = f; drv._fct[:, 32] = f
    day_t = torch.full((B,), 172.0, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
    m0 = drv._mount(day_t, lat_t, hour, pnt=None, mech=False); pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
    m = drv._mount(day_t, lat_t, hour, pnt=pnt, mech=False); C = m["Cd"].clone(); n = m["Mt"][:, 2, :].clone()
    elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
    drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
    drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
    # the trace's per-ray optics noise: du/de are unit Gaussians scaled by sigb; the study's fixed 0.003 stands in for the static figure
    drv._tr["du"] = torch.randn(B, P, device=dev); drv._tr["de"] = torch.randn(B, P, device=dev)
    thr, out6, per = drv.trace(C.contiguous(), n.contiguous(), torch.full((B,), float(L//2), device=dev), torch.full((B,), sig, device=dev))
    drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0; drv._tr["du"] = torch.zeros(B, P, device=dev); drv._tr["de"] = torch.zeros(B, P, device=dev)
    return float(thr.float().mean())
v, drv = build(); LFP = float(np.linalg.norm(np.asarray(drv.cs_P4) - np.asarray(drv.F_focus)))
print("built machine (f 4.05, Cassegrain strip), rays through at midsummer noon against the per-ray slope noise (rad rms, one sigma of the reflected ray's deviation):")
for sig in (0.003, 0.0043, 0.006, 0.008, 0.012, 0.02): print(f"   sigb {sig:.3f}: {100*thr_at(drv, None, sig):5.1f} %")
v.close()
c = 1.5; d = 0.1; b = np.sqrt(2*c*d + d*d)
v, drv = build(sec_side="greg", d_strip=d, r_strip=float(b), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0, m4_mode="relay", u_f2=float(LFP - 2*c))
for f in (1.5, 1.05):
    print(f"deep f {f} (Gregorian cap, F2 3 m from F):")
    for sig in (0.003, 0.0043, 0.006, 0.008, 0.012, 0.02): print(f"   sigb {sig:.3f}: {100*thr_at(drv, f, sig):5.1f} %")
v.close()

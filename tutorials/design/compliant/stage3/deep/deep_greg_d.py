"""the cap's distance d beyond F, now that its shadow is known to be the F-sheet within a(1 - e^2) ~ 2d of the axis and not the
semi-minor axis: the hole (r 0.5) hides a cap out to d ~ 0.25, and the magnification (2c + d)/d falls with d, so a larger d
buys figure tolerance for free. Midsummer noon, F2 3 m from F, f 1.05, with a perfect film and with the envs' 4.3 mrad; the
ledger says where the rays go (the kernel's shadow sphere is r_strip at F + d along the axis).
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python design/compliant/stage3/deep/deep_greg_d.py"""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_greg.py")).read().split("results = {}")[0])
def ledger(drv, f, sig, hour=12.0):
    dev = drv.device; B = drv.num_agents; pts0 = drv._pts_l.clone(); nrm0 = drv._nrm_l.clone(); fct0 = drv._fct.clone(); L, P, _ = pts0.shape
    xy = pts0[:, :, :2]; w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum(); rho = torch.hypot(xy[L//2, :, 0], xy[L//2, :, 1]).cpu()
    z = (xy[..., 0]**2 + xy[..., 1]**2)/(4*f); drv._pts_l = torch.cat([xy, z[..., None]], 2).contiguous()
    n = torch.stack([-xy[..., 0]/(2*f), -xy[..., 1]/(2*f), torch.ones_like(z)], 2); drv._nrm_l = (n/torch.linalg.norm(n, dim=2, keepdim=True)).contiguous()
    drv._fct[:, 53] = f; drv._fct[:, 55] = f; drv._fct[:, 32] = f
    day_t = torch.full((B,), 172.0, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
    m0 = drv._mount(day_t, lat_t, hour, pnt=None, mech=False); pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
    m = drv._mount(day_t, lat_t, hour, pnt=pnt, mech=False); C = m["Cd"].clone(); n = m["Mt"][:, 2, :].clone()
    elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
    drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
    drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
    drv._tr["du"] = torch.randn(B, P, device=dev); drv._tr["de"] = torch.randn(B, P, device=dev)
    thr, out6, per = drv.trace(C.contiguous(), n.contiguous(), torch.full((B,), float(L//2), device=dev), torch.full((B,), sig, device=dev))
    fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
    frac = {c: float(((fate == c).float()*w_ray[None]).sum(1).mean()) for c in CODES}
    net = float((((fate == 11) & (rho[None] > drv.r_hole)).float()*w_ray[None]).sum(1).mean())
    drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0; drv._tr["du"] = torch.zeros(B, P, device=dev); drv._tr["de"] = torch.zeros(B, P, device=dev)
    return float(thr.float().mean()), frac, net
v, drv = build(); LFP = float(np.linalg.norm(np.asarray(drv.cs_P4) - np.asarray(drv.F_focus))); r_hole = float(drv.r_hole); v.close()
c2 = 3.0; c = c2/2; f = 1.05
print(f"F2 {c2} m from F, f {f}, hole r {r_hole}; midsummer noon; the cap the rays meet reaches a(1 - e^2) from the axis at F's level")
print(f"{'d':>5} {'r_cap':>6} {'shade':>6} {'mag':>4} {'image':>6} {'figure':>7} {'through':>8} | " + " ".join(f"{CODES[k]:>9}" for k in KEYS) + " | net shadow")
for d in (0.10, 0.15, 0.20, 0.25, 0.30):
    a = c + d; e = c/a; r_cap = a*(1 - e*e); mag = (2*c + d)/d
    v, drv = build(sec_side="greg", d_strip=d, r_strip=float(r_cap), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0, m4_mode="relay", u_f2=float(LFP - 2*c))
    for sig in (0.0, 0.0043):
        thr, frac, net = ledger(drv, f, sig)
        print(f"{d:5.2f} {r_cap:6.3f} {100*r_cap*r_cap/2.1**2:5.1f}% {mag:4.0f} {100*mag*2*f*0.0093:5.0f}cm {1e3*sig:5.1f}mr {100*thr:7.1f}% | " + " ".join(f"{100*frac[k]:8.1f}%" for k in KEYS) + f" | {100*net:.1f} %", flush=True)
    v.close()

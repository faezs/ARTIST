"""the year for ONE relay design (env DESIGN = neck,2c,d,s1p,s2p,hole), with the spot sizes: the rms radius of the through
rays at the collar plane and at the bread's plane, and the built machine's collar-plane spot from the kernel's out6.
run:  cd ~/ARTIST-compliant/tutorials && DESIGN=1.8,1.5,0.2,0.8,3.5,0.4 PYTHONPATH=.. .../python design/compliant/stage3/deep/deep_relay_year.py"""
import os, sys, numpy as np, torch, importlib.util
sys.argv = [sys.argv[0]]
_sp = importlib.util.spec_from_file_location("deep_relay", os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_relay.py")); DR = importlib.util.module_from_spec(_sp); _sp.loader.exec_module(DR)
from deep_relay import *   # noqa  (the exec'd prefix: build, CODES, KEYS ...)
NECK_B, two_c, d_c, s1p, s2p, rh = [float(x) for x in os.environ.get("DESIGN", "1.8,1.5,0.2,0.8,3.5,0.4").split(",")]
cc = two_c/2; a_c = cc + d_c; rc = a_c*(1 - (cc/a_c)**2); SIGB = DR.SIGB; K = 128
LV_BUILT = float(os.environ.get("LV_BUILT", "4.75"))   # the built machine at the fast env's WORKING pump level (f 4.05), not the ladder's middle (level 3, f 4.30) the first year logs used
v, drv = DR.build(); B = drv.num_agents; dev = drv.device; L, P, _ = drv._pts_l.shape
rays = DR.Rays(drv, K, seed=7)
F, P4, F4 = np.asarray(drv.F_focus, dtype=np.float64), np.asarray(drv.cs_P4, dtype=np.float64), np.asarray(drv.cs_F4, dtype=np.float64)
geo = dict(z_deck=float(drv.z_deck), r_m4=float(drv.r_m4), r_pot=float(DR.HE.R_POT), z_duct=float(DR.HE.Z_DUCT), r_duct=float(drv.r_duct))
w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
DAYS = {"midwinter": 355.0, "equinox": 80.0, "midsummer": 172.0}; HRS = [8, 9, 10, 11, 12, 13, 14, 15, 16]
suns = {}; built = {}
for dname, day in DAYS.items():
    for hour in HRS:
        day_t = torch.full((B,), day, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
        m0 = drv._mount(day_t, lat_t, float(hour), pnt=None, mech=False); el = float(m0["aux"][0, 0])
        elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
        sun = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1)
        suns[(dname, hour)] = (el, sun[0].cpu().double().numpy())
        if el < 12.0: built[(dname, hour)] = (0.0, 0.0, 0.0); continue
        pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
        m = drv._mount(day_t, lat_t, float(hour), pnt=pnt, mech=False)
        drv._sun_cache = sun.float().contiguous(); drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
        drv._tr["du"] = rays.du.float().to(dev); drv._tr["de"] = rays.de.float().to(dev)
        res = []
        for disc in (False, True):
            drv._tr["us"] = (rays.us.float() if disc else torch.full((K, P), 0.5)).to(dev); drv._tr["upick"] = (rays.upick.float() if disc else torch.full((K, P), 0.5)).to(dev)
            thr, out6, per = drv.trace(m["Cd"].clone().contiguous(), m["Mt"][:, 2, :].clone().contiguous(), torch.full((B,), LV_BUILT, device=dev), torch.full((B,), SIGB, device=dev))
            fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu(); ok = (fate == 0)
            yz = out6[..., :2].detach().float().cpu(); r2 = (yz**2).sum(-1)
            res.append((float((ok.float()*w_ray[None]).sum(1).mean()), float(torch.sqrt((r2*ok.float()*w_ray[None]).sum()/(ok.float()*w_ray[None]).sum().clamp(min=1e-9)))))
        built[(dname, hour)] = (res[0][0], res[1][0], res[1][1])
v.close()
stalk_xy = (float(F[0]), float(F[1])); KR = [0, 11, 12, 15, 2, 5, 21, 22, 23, 24, 7, 8, 9]
print(f"THE YEAR for the relay design neck {NECK_B}, 2c {two_c}, d {d_c} (cap r {rc:.3f}, magnification {(two_c + d_c)/d_c:.0f}), M3 {NECK_B - (two_c - DR.F_DISH):.2f} -> {s1p}, M4 {DR.OFF - s1p:.2f} -> {s2p}, hole {rh}; sigb {SIGB}; rays through and the spot's rms radius (cm) at the collar plane, for the built machine from the kernel's out6")
print(f"{'day':<10} {'hour':>4} {'el':>5} | {'built':>6} {'built':>6} {'spot':>5} | {'coude':>6} {'coude':>6} {'spot':>5} {'bread':>5} | " + " ".join(f"{DR.CODES_R[k][:6]:>6}" for k in KR[1:]) + " | net light built x3, coude x5 (disc)")
print(f"{'':<10} {'':>4} {'':>5} | {'fixed':>6} {'disc':>6} {'disc':>5} | {'fixed':>6} {'disc':>6} {'disc':>5} {'disc':>5} |")
tot = {}
for dname in DAYS:
    for hour in HRS:
        el, sun = suns[(dname, hour)]; b0, b1, bs = built[(dname, hour)]
        if el < 12.0:
            print(f"{dname:<10} {hour:4d} {el:5.1f} | {100*b0:5.1f}% {100*b1:5.1f}% {'-':>5} | {'-':>6} {'-':>6} {'-':>5} {'-':>5} |"); continue
        ex = {}
        tab, led = DR.trace_coude(rays, SIGB, sun, stalk_xy, geo["z_deck"], P4, F4, two_c, d_c, rc, rh, s1p, s2p, 0.55, 0.60, geo["r_m4"], geo["r_pot"], geo["z_duct"], geo["r_duct"], neck=NECK_B, extra=ex, disc=True)
        tab0, _ = DR.trace_coude(rays, SIGB, sun, stalk_xy, geo["z_deck"], P4, F4, two_c, d_c, rc, rh, s1p, s2p, 0.55, 0.60, geo["r_m4"], geo["r_pot"], geo["z_duct"], geo["r_duct"], neck=NECK_B, disc=False)
        thr, thr0 = tab["through"], tab0["through"]
        print(f"{dname:<10} {hour:4d} {el:5.1f} | {100*b0:5.1f}% {100*b1:5.1f}% {100*bs:5.1f} | {100*thr0:5.1f}% {100*thr:5.1f}% {100*ex['spot_collar']:5.1f} {100*ex['spot_bread']:5.1f} | " + " ".join(f"{100*tab[DR.CODES_R[k]]:5.1f}%" for k in KR[1:]) + f" | {100*b1*0.94**3:5.1f}% {100*thr*0.94**5:5.1f}%", flush=True)
        for k, val in (("built", b0), ("built_disc", b1), ("coude", thr0), ("coude_disc", thr), ("built_net", b1*0.94**3), ("coude_net", thr*0.94**5)):
            tot.setdefault((dname, k), 0.0); tot[(dname, k)] += val*max(np.sin(np.radians(el)), 0.0)
print("\nsummed over the nine hours weighted by sin(el), the coude machine relative to the built one:")
for dname in DAYS:
    print(f"  {dname:<10} rays through: fixed offset {tot[(dname, 'coude')]/max(tot[(dname, 'built')], 1e-9):5.2f}x, sun's disc {tot[(dname, 'coude_disc')]/max(tot[(dname, 'built_disc')], 1e-9):5.2f}x;   net light with the disc {tot[(dname, 'coude_net')]/max(tot[(dname, 'built_net')], 1e-9):5.2f}x")

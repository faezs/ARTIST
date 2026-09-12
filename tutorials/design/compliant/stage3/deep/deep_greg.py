"""THE DEEP DISH WITH THE SECONDARY IT NEEDS, traced by the flower's kernel, kept separate.

A hyperboloid strip with foci F and F2 (4 m apart) and its vertex d before F only intercepts rays inside its asymptotic
cone, acos(a/c) = acos(1 - d/c): 32 deg at d 0.3, 18 deg at d 0.1. A deep paraboloid sends its rays through F over
+-90 deg, so the Cassegrain strip cannot be made to catch them by moving or enlarging it. The ellipsoid BEYOND F (the
kernel's sec_side = 'greg', a = c + d) has a closed F-sheet: every ray through F meets it, at a distance b = sqrt(2 c d)
to the side at worst, and is sent to F2 with magnification (2c + d)/d. Its shadow on the primary is the cap's own area,
about pi b^2 / A. The strip is made a full cap (every azimuth, every polar angle) because a deep bowl's light fills the
cone around F, where the shallow machine's came from one direction.

Per configuration the env is built with the kernel's own knobs (sec_side, d_strip, r_strip, w_strip, strip_wk,
strip_th_hi) and then, for the study only, the primary is replaced by a formed paraboloid of focal length f with the
orbit and the receiver block's f_dish set to f (columns 53, 55 and 32), so the crossing test blocks the bore's rays with
the deep bowl and not the built one. The miss ledger by hour says where the rays go.
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python design/compliant/stage3/deep/deep_greg.py"""
import os, sys, importlib.util, numpy as np, torch
ROOT = "/Users/faezs/ARTIST-compliant"; TUT = ROOT + "/tutorials"; PT = TUT + "/puffer_tandoor"
for p in (PT, TUT, ROOT):
    if p in sys.path: sys.path.remove(p)
    sys.path.insert(0, p)
os.chdir(PT); sys.argv = [sys.argv[0]]
_sp = importlib.util.spec_from_file_location("puffer_tandoor", PT + "/__init__.py", submodule_search_locations=[PT])
_pk = importlib.util.module_from_spec(_sp); sys.modules["puffer_tandoor"] = _pk; _sp.loader.exec_module(_pk); sys.modules["pufferlib.environments.tandoor"] = _pk
for _m in ("tandoor_screws", "tandoor_mount_batch", "tandoor_metal_kernel", "tandoor_cuda_kernel", "tandoor_fused_step"):
    _s = importlib.util.spec_from_file_location(_m, TUT + "/" + _m + ".py"); _mod = importlib.util.module_from_spec(_s); sys.modules[_m] = _mod; _s.loader.exec_module(_mod)
from pufferlib import pufferl
CODES = {0: "through", 11: "shadow", 12: "hole", 13: "slot", 14: "strut", 2: "no hit", 3: "off strip", 4: "graze", 5: "crossing", 6: "bore", 7: "M3", 8: "way", 9: "collar"}
KEYS = [0, 11, 3, 5, 6, 7, 9, 8, 13, 14]
HOURS = (9.0, 12.0, 15.0)

def build(**env_kw):
    sys.argv = [sys.argv[0]]
    args = pufferl.load_config("puffer_flower_fast"); args["env"]["num_agents"] = 128; args["env"]["on_device"] = 0; args["env"]["n_rays"] = 512
    args["env"].update(env_kw); args["vec"] = dict(backend="Serial", num_envs=1)
    v = pufferl.load_env("puffer_flower_fast", args); d = v.driver_env; v.reset(seed=11); return v, d

def study(drv, f_list, label):
    dev = drv.device; B = drv.num_agents
    pts0 = drv._pts_l.clone(); nrm0 = drv._nrm_l.clone(); fct0 = drv._fct.clone()
    a = float(drv.a_mem); r_hole = float(drv.r_hole); L, P, _ = pts0.shape
    xy = pts0[:, :, :2]; rho = torch.hypot(xy[L//2, :, 0], xy[L//2, :, 1]).cpu()
    w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
    c_h = float(drv.cs_c); d = float(drv.d_strip); greg = drv.sec_side == "greg"
    b = np.sqrt(2*c_h*d + d*d) if greg else float("nan"); mag = (2*c_h + d)/d if greg else (2*c_h - d)/d
    asym = np.degrees(np.arccos(max(min((c_h - d)/c_h, 1.0), -1.0))) if not greg else 180.0
    print(f"\n== {label}: sec {drv.sec_side}, d {d:.3f} m, c {c_h:.2f} m, {'cap half-width b %.2f m' % b if greg else 'asymptote %.0f deg' % asym}, magnification {mag:.0f}, r_strip {drv.r_strip:.2f} (shadow {100*np.pi*drv.r_strip**2/(np.pi*a*a):.1f} % of the aperture)")
    print(f"{'f':>5} {'hour':>4} {'sun el':>6} {'power':>7} | " + " ".join(f"{CODES[k]:>9}" for k in KEYS) + " | net shadow")
    def formed(f):
        z = (xy[..., 0]**2 + xy[..., 1]**2)/(4*f); pts = torch.cat([xy, z[..., None]], 2)
        n = torch.stack([-xy[..., 0]/(2*f), -xy[..., 1]/(2*f), torch.ones_like(z)], 2); n = n/torch.linalg.norm(n, dim=2, keepdim=True)
        return pts.contiguous(), n.contiguous()
    out = {}
    for f in f_list:
        if f is None: drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0; f_eff = float(fct0[0, 53])
        else: drv._pts_l, drv._nrm_l = formed(f); drv._fct[:, 53] = f; drv._fct[:, 55] = f; drv._fct[:, 32] = f; f_eff = f
        for hour in HOURS:
            day_t = torch.full((B,), 172.0, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
            m0 = drv._mount(day_t, lat_t, hour, pnt=None, mech=False)
            pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
            m = drv._mount(day_t, lat_t, hour, pnt=pnt, mech=False)
            C = m["Cd"].clone(); n = m["Mt"][:, 2, :].clone()
            elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
            drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
            drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
            lv = torch.full((B,), float(L//2), device=dev); sigb = torch.full((B,), 0.003, device=dev)
            thr, out6, per = drv.trace(C.contiguous(), n.contiguous(), lv, sigb)
            fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
            frac = {c: float(((fate == c).float()*w_ray[None]).sum(1).mean()) for c in CODES}
            net = float((((fate == 11) & (rho[None] > r_hole)).float()*w_ray[None]).sum(1).mean())
            power = float(per.sum(1).mean()); out[(f_eff, hour)] = dict(power=power, frac=frac, net=net, el=float(m0["aux"][0, 0]))
            print(f"{f_eff:5.2f} {hour:4.0f} {float(m0['aux'][0, 0]):6.1f} {power:7.2f} | " + " ".join(f"{100*frac[k]:8.1f}%" for k in KEYS) + f" | {100*net:.1f} %")
    drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0
    return out

results = {}
v, drv = build()
results["cass d0.3 (built)"] = study(drv, [None, 1.5, 1.05], "the built machine: Cassegrain strip at 0.3 m")
v.close()
for d in (0.10, 0.20):
    c_h = 0.5*np.linalg.norm(np.asarray(drv.cs_F2) - np.asarray(drv.F_focus))
    b = np.sqrt(2*c_h*d + d*d)
    v, drv = build(sec_side="greg", d_strip=d, r_strip=float(b), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0)
    results[f"greg d{d}"] = study(drv, [None, 1.5, 1.2, 1.05], f"Gregorian cap {d} m beyond F, full cap")
    v.close()
print("\nSUMMARY: delivered power, the built machine at f 4.05 = 1.00 per hour")
base = results["cass d0.3 (built)"]
print(f"{'configuration':<28} {'f':>5} " + " ".join(f"{'h%.0f' % h:>7}" for h in HOURS) + "   day")
for name, res in results.items():
    for f in sorted({k[0] for k in res}):
        vals = [res[(f, h)]["power"]/max(base[(float(list(base)[0][0]), h)]["power"], 1e-9) for h in HOURS]
        print(f"{name:<28} {f:5.2f} " + " ".join(f"{x:7.2f}" for x in vals) + f"   {np.mean(vals):5.2f}")

"""THE DEEP DISH IN THE TRACE, kept separate from the flower's configs: the same machine, the same kernel, the same strip
(r 0.6 m at 0.3 m below F, the bore, M3 at the inlet), with the primary replaced by a FORMED paraboloid of focal length f
and the head's orbit radius set to f, so the vertex sits f from F on the sphere the aim law rides. Nothing is written
back; the design table rows are edited on the live env for the study only.

For each f and each hour the miss ledger says where every ray died, and the question asked is answered from it: the
share of the sun's rays that hit the strip (either face) on their way to the primary when they would otherwise have hit
the film (code 11 with the landing radius beyond the hole), and, for the deep bowl, how much of the converging cone the
strip at 0.3 m still catches (code 3: the beam misses the strip's extent).
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python design/compliant/stage3/deep/deep_trace.py"""
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
args = pufferl.load_config("puffer_flower_fast"); args["env"]["num_agents"] = 256; args["env"]["on_device"] = 0; args["env"]["n_rays"] = 512; args["vec"] = dict(backend="Serial", num_envs=1)
vecenv = pufferl.load_env("puffer_flower_fast", args); drv = vecenv.driver_env; ob, _ = vecenv.reset(seed=11)
dev = drv.device; B = drv.num_agents
CODES = {0: "through", 11: "strip shadow", 12: "hole", 13: "slot", 14: "strut", 2: "no strip hit", 3: "beam misses strip", 4: "graze", 5: "crossing",
         6: "misses bore", 7: "misses M3", 8: "the way", 9: "collar"}
pts0 = drv._pts_l.clone(); nrm0 = drv._nrm_l.clone(); fct0 = drv._fct.clone()
a = float(drv.a_mem); r_hole = float(drv.r_hole); r_strip = float(drv.r_strip); d_strip = float(drv.d_strip)
L, P, _ = pts0.shape
xy = pts0[:, :, :2]; rho = torch.hypot(xy[L//2, :, 0], xy[L//2, :, 1]).cpu()                 # per ray, the dish-frame radius
w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
print(f"the machine: a {a:.2f} m, hole r {r_hole}, strip r {r_strip} at {d_strip} m below F, f_nom {drv.f_nom:.2f}, orbit {drv.g_orbit:.2f}, slotless {getattr(drv, 'slotless', None)}; {P} rays, {B} agents\n")

def formed(f):
    """a formed paraboloid of focal length f on the same ray grid at every level (a formed film's pressure ladder barely moves f)"""
    z = (xy[..., 0]**2 + xy[..., 1]**2)/(4*f)
    pts = torch.cat([xy, z[..., None]], 2)
    n = torch.stack([-xy[..., 0]/(2*f), -xy[..., 1]/(2*f), torch.ones_like(z)], 2); n = n/torch.linalg.norm(n, dim=2, keepdim=True)
    return pts.contiguous(), n.contiguous()

def run(f, hour):
    if f is None: drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:, 53] = fct0[:, 53]; drv._fct[:, 55] = fct0[:, 55]; f_eff = float(fct0[0, 53])
    else: drv._pts_l, drv._nrm_l = formed(f); drv._fct[:, 53] = f; drv._fct[:, 55] = f; f_eff = f
    day_t = torch.full((B,), 172.0, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
    m0 = drv._mount(day_t, lat_t, hour, pnt=None, mech=False)                                  # the sun, from the kernel
    pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()             # point AT the sun
    m = drv._mount(day_t, lat_t, hour, pnt=pnt, mech=False)
    C = m["Cd"].clone(); n = m["Mt"][:, 2, :].clone()
    elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]                                 # the sun at THIS hour, for the trace's Acan
    drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
    drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
    lv = torch.full((B,), float(L//2), device=dev); sigb = torch.full((B,), 0.003, device=dev)
    thr, out6, per = drv.trace(C.contiguous(), n.contiguous(), lv, sigb)
    fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
    el = float(m0["aux"][0, 0])
    frac = {c: float(((fate == c).float()*w_ray[None]).sum(1).mean()) for c in CODES}
    net_shadow = float((((fate == 11) & (rho[None] > r_hole)).float()*w_ray[None]).sum(1).mean())
    power = float(per.sum(1).mean())
    sag = a*a/(4*f_eff); cone = 2*np.degrees(np.arctan2(a, f_eff - sag))
    return dict(f=f_eff, el=el, cone=cone, power=power, thr=float(thr.float().mean()), net_shadow=net_shadow, frac=frac)

rows = []
for hour in (9.0, 12.0, 15.0):
    base = run(None, hour); rows.append(base)
    for f in (2.0, 1.5, 1.2, 1.05): rows.append(run(f, hour))
drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0
keys = [0, 11, 12, 3, 4, 5, 2, 6, 7, 9, 8, 13, 14]
print(f"{'hour':>4} {'f m':>5} {'sun el':>6} {'cone':>5} {'power':>7} {'vs f4':>6} | " + " ".join(f"{CODES[k][:12]:>12}" for k in keys) + " | net strip shadow (would have hit the film)")
for r in rows:
    b = [x for x in rows if x["el"] == r["el"] and x["f"] > 4][0]
    print(f"{'':>4} {r['f']:5.2f} {r['el']:6.1f} {r['cone']:4.0f}° {r['power']:7.2f} {r['power']/max(b['power'], 1e-9):6.2f} | " + " ".join(f"{100*r['frac'][k]:11.1f}%" for k in keys) + f" | {100*r['net_shadow']:.1f} %")
print("\nthe strip's r 0.6 m at 0.3 m below F subtends a half-angle of", f"{np.degrees(np.arctan2(r_strip, d_strip)):.0f} deg from F: rays arriving at F from further off the bore's axis miss it")
for f in (4.05, 2.0, 1.5, 1.2, 1.05):
    # the radius on the dish whose ray reaches F at that angle: tan(phi) = r / (f - r^2/4f)
    phi = np.arctan2(r_strip, d_strip); rr = np.linspace(0.01, a, 2000); ang = np.arctan2(rr, f - rr*rr/(4*f)); r_max = rr[np.argmax(ang > phi)] if (ang > phi).any() else a
    print(f"   f {f:4.2f}: the strip catches the dish out to r {r_max:.2f} m of {a:.1f} = {100*(r_max**2 - r_hole**2)/(a*a - r_hole**2):.0f} % of the film's area")
vecenv.close()

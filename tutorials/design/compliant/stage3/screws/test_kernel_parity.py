"""The mount as screws INSIDE the megakernel, against the paths that exist:
  A. Hashemi's machine as a 4-screw chain through mount_solve's mech row, against mount_solve's own pnt law: Mt, Cd, vp, scb, Acan
  B. the pedicel chain in the kernel against tandoor_flower_env.pedicel_fk on the host, and the trace run from both
  C. the elastic twist and C W in the kernel against tandoor_screws.apply_rows
  D. the torch twin (tandoor_mount_batch with mech) against the Metal kernel with the same rows
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python design/compliant/stage3/screws/test_kernel_parity.py"""
import os, sys, numpy as np, torch
ROOT = "/Users/faezs/ARTIST-compliant"; TUT = ROOT + "/tutorials"; PT = TUT + "/puffer_tandoor"
for p in (PT, TUT, ROOT):
    if p in sys.path: sys.path.remove(p)
    sys.path.insert(0, p)
os.chdir(PT); sys.argv = [sys.argv[0]]
import importlib.util                                                               # THIS tree's package, whatever the venv's finders say
_sp = importlib.util.spec_from_file_location("puffer_tandoor", PT + "/__init__.py", submodule_search_locations=[PT])
_pk = importlib.util.module_from_spec(_sp); sys.modules["puffer_tandoor"] = _pk; _sp.loader.exec_module(_pk)
assert _pk.__file__.startswith(ROOT), _pk.__file__
sys.modules["pufferlib.environments.tandoor"] = _pk        # the inis say package = tandoor: pufferl imports THAT name, so pin it too
# the env construction pushes ~/ARTIST/tutorials onto sys.path and the kernel is imported lazily: pin the kernel
# modules to THIS tree first, so the lazy import finds them in sys.modules
for _m in ("tandoor_screws", "tandoor_mount_batch", "tandoor_metal_kernel", "tandoor_cuda_kernel"):
    _s = importlib.util.spec_from_file_location(_m, TUT + "/" + _m + ".py"); _mod = importlib.util.module_from_spec(_s)
    sys.modules[_m] = _mod; _s.loader.exec_module(_mod)
from pufferlib import pufferl
args = pufferl.load_config("puffer_flower_fast"); args["env"]["num_agents"] = 128; args["env"]["on_device"] = 0; args["vec"] = dict(backend="Serial", num_envs=1)
vecenv = pufferl.load_env("puffer_flower_fast", args); drv = vecenv.driver_env
import tandoor_flower_fast as FF, tandoor_flower_env as FE, tandoor_metal_kernel as MK, tandoor_screws as SC, tandoor_mount_batch as MB
for m in (FF, FE, MK, SC, MB): assert m.__file__.startswith(ROOT), m.__file__          # this tree, not the shared checkout
assert drv._metal is not None, "no Metal: the parity test needs the kernel"
ob, _ = vecenv.reset(seed=11)
dev = drv.device; B = drv.num_agents; g = torch.Generator(device="cpu").manual_seed(5)
fails = []
def check(name, err, tol):
    ok = err <= tol; print(f"  {'ok ' if ok else 'FAIL'} {name:<64} {err:.2e} (tol {tol:.0e})")
    if not ok: fails.append(name)
def dmax(a, b): return float((a.float() - b.float()).abs().max())
# the Metal mount returns VIEWS of buffers cached per (B, device): every call overwrites the last, so snapshot each result
def mount(**kw): return {k: (v.clone() if torch.is_tensor(v) else v) for k, v in drv._mount(day_t, lat_t, hour, pnt=pnt, **kw).items()}
day_t = torch.full((B,), 172.0, device=dev); lat_t = torch.full((B,), 30.2, device=dev); hour = 12.0
el_m = torch.rand(B, generator=g)*60 + 20; az_m = torch.rand(B, generator=g)*120 - 60
pnt = torch.stack([el_m, az_m], 1).to(dev)

print("A. Hashemi's machine as a chain, in the kernel")
ma = mount()
bt = ma["aux"][:, 6].cpu()                                                          # the schedule's beta, per agent
prm = drv._mnt_prm.cpu(); fct = drv._fct.cpu()
Pf = torch.stack([torch.full((B,), float(prm[9])), torch.zeros(B), fct[:, 42]], 1); g_orb = fct[:, 55]
ch = SC.hashemi_chain(Pf, g_orb[:, None]); theta = SC.hashemi_theta(el_m, az_m, bt)
rows = SC.mech_rows(B); SC.set_chain(rows, ch["screws"], theta, ch["C0"], ch["n0"])
mb = mount(mech=rows.to(dev))
for k in ("Mt", "Cd", "vp", "scb", "Acan"): check(f"{k}: chain vs pnt law", dmax(ma[k], mb[k]), 3e-5)
check("beta recovered (deg)", dmax(ma["aux"][:, 6], mb["aux"][:, 6]), 1e-3)
check("beam elevation (deg)", dmax(ma["aux"][:, 2], mb["aux"][:, 2]), 1e-3)

print("B. the pedicel chain in the kernel against the host's forward kinematics, and the trace from both")
T0 = drv._fl_stem().to(dev)[None].expand(B, 3).contiguous()
# the pose the env's own inverse kinematics set at reset (aimed at the sun, so the trace carries power), jittered a little
q = {k: drv._fl["q_" + k].detach().cpu().float() + (torch.rand(B, generator=g) - 0.5)*(0.02 if k == "ext" else 0.4)
     for k in ("slew", "luff", "ext", "pitch", "yaw")}
qd = {k: v.to(dev) for k, v in q.items()}
C_fk, n_fk = FE.pedicel_fk(T0, qd)
chp = SC.pedicel_chain(T0.cpu(), FE.D_REC); rows_p = SC.mech_rows(B); SC.set_chain(rows_p, chp["screws"], SC.pedicel_theta(q), chp["C0"], chp["n0"])
mp = mount(mech=rows_p.to(dev))
C_k, n_k = mp["Cd"], mp["Mt"][:, 2, :]
check("vertex: kernel chain vs pedicel_fk", dmax(C_k, C_fk), 2e-5); check("axis: kernel chain vs pedicel_fk", dmax(n_k, n_fk), 2e-6)
lv = torch.full((B,), 3.0, device=dev); sigb = torch.full((B,), 0.003, device=dev)
thr_a, out_a, per_a = drv.trace(C_fk.float().contiguous(), n_fk.float().contiguous(), lv, sigb)
thr_b, out_b, per_b = drv.trace(C_k.float().contiguous(), n_k.float().contiguous(), lv, sigb)
check("trace: rays through, host frame vs kernel frame", dmax(thr_a, thr_b), 1e-6)
check("trace: power per node (relative)", dmax(per_a, per_b)/max(float(per_a.abs().max()), 1e-9), 1e-4)
print(f"     ({100*float(thr_a.mean()):.1f} % of rays through at this pose, power {float(per_a.sum(1).mean()):.1f} per agent)")

print("C. the elastic twist and C W in the kernel")
xi = (torch.rand(B, 6, generator=g) - 0.5)*2e-3
rows_e = rows_p.clone(); SC.set_elastic(rows_e, xi)
me = mount(mech=rows_e.to(dev))
C_h, n_h = SC.apply_twist(xi.to(dev), C_fk, n_fk)
check("elastic twist: vertex", dmax(me["Cd"], C_h), 2e-5); check("elastic twist: axis", dmax(me["Mt"][:, 2, :], n_h), 2e-6)
Cb = C_fk - FE.D_REC*n_fk
Cm = SC.pedicel_compliance(T0.cpu().double(), Cb.cpu().double(), n_fk.cpu().double(), FE.D_REC, FE.EI_STEM, FE.EI_BOOM).float()   # float64 on the CPU: MPS has none
W = torch.zeros(B, 6); W[:, 1] = 400.0; W[:, 4] = 150.0                                        # 400 N crosswind, 150 N m of pitching
rows_c = rows_e.clone(); SC.set_compliance(rows_c, Cm, W)
mc = mount(mech=rows_c.to(dev))
C_r, n_r = SC.apply_rows(rows_c)
check("C W + elastic: vertex (kernel vs apply_rows)", dmax(mc["Cd"].cpu(), C_r), 2e-5); check("C W + elastic: axis", dmax(mc["Mt"][:, 2, :].cpu(), n_r), 2e-6)
walk = torch.linalg.norm((mc["Cd"] - mp["Cd"]).cpu(), dim=1)
print(f"     (400 N of crosswind and 150 N m on the {float(q['ext'].mean()):.1f} m mean boom moves the vertex {1e3*float(walk.mean()):.2f} mm)")

print("D. the torch twin against the Metal kernel, same rows")
drv._mnt_prm[0] = hour
tw = MB.mount_batch(drv, day_t, lat_t, hour, dev, pnt=pnt, mech=rows_c.to(dev))
for k in ("Mt", "Cd", "vp", "scb", "Acan"): check(f"{k}: torch twin vs kernel", dmax(tw[k].reshape(mc[k].shape), mc[k]), 3e-5)
vecenv.close()
print("\nFAILED: " + ", ".join(fails) if fails else "\nall passed")
sys.exit(1 if fails else 0)

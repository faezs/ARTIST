"""EXPLOIT THE BOOM'S COMPLIANCE instead of suppressing it.

The image at F moves by  walk = g_rot . theta + g_tr . delta  when the head tilts by theta and translates by delta.
A bent boom delivers theta and delta in a FIXED RATIO set by its stiffness distribution - 3/(2L) for a uniform
cantilever under a tip load, 0 for a parallel-guiding flexure (ch. 12.2.4), anything in between for a twin beam with
unequal stiffness. The optics fix the ratio at which the two terms cancel. If the boom can be built to that ratio,
the wind bends it and the image does not move - the compliance IS the gust rejection, with no actuator.

This computes the optical sensitivities on the real machine at its real pose (central differences on the exact
reflection law, the same way hexapod_role.py did), projects them onto the boom's bending plane, and asks: what
theta/delta does the optics want, what does each boom type give, and what does that do to the wind walk?"""
import contextlib, io, sys, numpy as np, torch
for p in ("/Users/faezs/ARTIST/tutorials", "/Users/faezs/ARTIST", "/Users/faezs/ARTIST/tutorials/puffer_tandoor"): sys.path.insert(0, p)
from tandoor_flower_env import TandoorFlowerEnv, EI_BOOM, EI_STEM, compliance
from tandoor_mount_batch import solar_batch
K = dict(num_agents=4, seed=7, wide_shutter=1, device="mps", gpu=1, n_rays=64, warm_frac=1.0, day_random=0,
         lat_random=0, wall_obs=1, beta_dev=36.0, beta_cap_z=10.6, silvered=1, spot_bread=1, roti_kj=130.0,
         bread_area=0.12, loaves_per_load=8, elbow_aim=1, load_ctrl=1, sticky_k=0, g_orbit=4.0, a_mem=2.1,
         receiver="tri", r_duct=0.55, n_zones=5, zone_c=0.4, base="stem")
with contextlib.redirect_stdout(io.StringIO()):
    e = TandoorFlowerEnv(**K); e.reset(seed=7)
B = e.num_agents; dev = e.device; F = e._fl_F()
a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=dev); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
with torch.no_grad(): e.step_torch(a)
S = e._gpu

def miss(C, n, s):
    r = -s + 2*(s@n)*n; d = F - C; return d - (d@r)*r          # the miss VECTOR at F
def pose_at(day, hour):
    el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(hour))
    S.day_v.fill_(float(day)); S.lat_v.fill_(30.2); S.el_m.copy_(el.to(dev)); S.az_m.copy_(torch.rad2deg(az).to(dev))
    e.t_solar[:] = hour; e.day = day
    C, n = e._fl_head_pose(); C = C[0].cpu().numpy().astype(float); n = n[0].cpu().numpy().astype(float)
    az_ = float(az[0]); el_ = float(np.radians(el[0]))
    s = np.array([np.cos(el_)*np.cos(az_), np.cos(el_)*np.sin(az_), np.sin(el_)])
    return C, n/np.linalg.norm(n), s

T0 = e._fl_stem().cpu().numpy().astype(float)
print(f"{'pose':>18} {'Lb':>5} {'want th/d':>10} {'cantilever':>11} {'walk/N cant':>12} {'parallelogram':>14} {'compensated':>12}")
res = []
for day, hour in ((80, 9.0), (80, 12.0), (80, 15.0), (172, 12.0), (355, 12.0)):
    C, n, s = pose_at(day, hour)
    Cb = C - 1.8*n; b = Cb - T0; Lb = float(np.linalg.norm(b)); bu = b/Lb
    # the wind's transverse load on the boom: horizontal, across the boom
    w = np.array([1.0, 0, 0]); t = w - (w@bu)*bu; t = t/max(np.linalg.norm(t), 1e-9)      # the bending direction
    rot_axis = np.cross(bu, t)                                                              # the tip rotates about this
    h = 1e-4
    dT = (miss(C + h*t, n, s) - miss(C - h*t, n, s))/(2*h)                                  # m of miss per m of translation along t
    nR = lambda sg: (n + sg*h*np.cross(rot_axis, n))/np.linalg.norm(n + sg*h*np.cross(rot_axis, n))
    dR = (miss(C, nR(+1), s) - miss(C, nR(-1), s))/(2*h)                                    # m of miss per rad about rot_axis
    # project both onto the direction the translation moves the image, so signs are comparable
    u = dT/max(np.linalg.norm(dT), 1e-12); g_tr = float(dT@u); g_rot = float(dR@u)
    want = -g_tr/g_rot if abs(g_rot) > 1e-9 else np.inf                                    # theta/delta that zeroes the walk
    cant = 1.5/Lb                                                                           # uniform cantilever tip load
    cmp_ = compliance(torch.tensor([Lb])); th, de = float(cmp_["theta"][0]), float(cmp_["delta"][0])
    walk_c = abs(g_rot*th + g_tr*de); walk_p = abs(g_tr*de); walk_z = 0.0
    res.append((Lb, want, cant, walk_c, walk_p))
    print(f"day {day:3d} {hour:4.1f}h {Lb:5.2f} {want:10.3f} {cant:11.3f} {1e6*walk_c:9.1f} um {1e6*walk_p:11.1f} um {1e6*walk_z:9.1f} um")
print()
print("want th/d  = the tip-rotation-per-translation the OPTICS need for the two terms to cancel [rad/m]")
print("cantilever = what a uniform boom under a tip load actually gives, 3/(2 Lb)")
print("walk/N     = image motion at F per newton of wind on the head: as built, with a parallelogram boom (theta = 0),")
print("             and with a boom tuned to 'want' - which is the exploit, if 'want' has the cantilever's sign.")

"""Where the power goes as the strip moves out from F (the knob that shrinks the image
at the turn). One agent per d_strip, the loss ladder at summer noon."""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_hashemi_env as HE
from tandoor_mount_batch import mount_batch

DS = (0.4, 0.6, 0.8, 1.0, 1.2)
WK = (0.8, 1.1, 1.5, 1.8)
B = len(DS) * len(WK)
e = build(num_agents=B, gpu=0, device="cpu", n_rays=2048, design_rand=1,
          roof_table="/Users/faezs/ARTIST/tutorials/data/tandoor/quetta_tandoor_roof_quantiles.json")
obs, _ = e.reset(seed=3)
BOX = tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX); names = [k for k, _, _ in BOX]
box = {k: (lo, hi) for k, lo, hi in BOX}
u0 = np.zeros(len(BOX))
for i, (k, lo, hi) in enumerate(BOX):
    v = getattr(e, k, None); u0[i] = 0.5 if (v is None or k == "roof_r") else float(np.clip((float(v) - lo) / (hi - lo), 0, 1))
for k, v in dict(roof_r=0.5, cap_scale=0.375, demand_scale=1/3, mount_post=1.0, deck_h=0.2, sand_depth=0.0,
                 loaves_per_load=1.0, section=0.0, post_rise=0.0, over_cap=0.5, roof_light=0.0, grid=0.0).items():
    u0[names.index(k)] = v
u = np.tile(u0, (B, 1)); rows = []
for a, ds in enumerate(DS):
    for c, wk in enumerate(WK):
        i = a * len(WK) + c
        u[i, names.index("d_strip")] = (ds - box["d_strip"][0]) / (box["d_strip"][1] - box["d_strip"][0])
        u[i, names.index("strip_wk")] = (wk - box["strip_wk"][0]) / (box["strip_wk"][1] - box["strip_wk"][0])
        rows.append((ds, wk))
e.set_design_points(u)
e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
dev = e.device; P = e.n_rays
mnt = mount_batch(e, torch.full((B,), 172.0, device=dev), torch.full((B,), 30.2, device=dev), 12.0, dev,
                  pnt=torch.tensor(np.stack([e.el_m, e.az_m], 1), dtype=torch.float32, device=dev))
z = lambda: torch.zeros(B, P, device=dev)
metal, e._metal = e._metal, None; geo0, e._geo = e._geo, e._geo_ref
args = (e._pts_l, e._nrm_l, torch.full((B,), 4.0, device=dev), z(), z(), torch.rand(B, P, device=dev), torch.rand(B, P, device=dev),
        torch.full((B,), 5e-3, device=dev), mnt["Acan"].contiguous().view(B, 1, 3, 3), mnt["Mt"].contiguous(),
        mnt["Cd"].contiguous()[:, None, :], torch.zeros(B, 1, 2, device=dev), torch.zeros(B, 2, device=dev),
        mnt["vp"][:, :, None, :], e._sc_base, mnt["scb"].contiguous(), e.ell_M, e.ell_S, e.ell_ctr_t, e._V0t, e._fct)
out = e._geo(*args); e._metal, e._geo = metal, geo0
(through_b, w_ray, dy, dz, d3, ok, ok_pre, ok_post, lit, in_slot, graze, rad1, p, h1, h2, h3, desc) = out
f = lambda t: t.float().mean(1).detach().cpu().numpy()
lit_, pre_, post_, ok_, thr_ = f(lit), f(ok_pre), f(ok_post), f(ok), f(through_b)
r_strip = e._fct[:, 2].detach().cpu().numpy()
print(f"{'d_strip':>7s} {'strip_wk':>8s} {'shadow r':>8s} {'obstruction':>11s} | {'lit':>6s} {'on the strip':>12s} {'down the bore':>13s} {'past M4':>8s} {'through':>8s}")
for i, (ds, wk) in enumerate(rows):
    print(f"{ds:7.2f} {wk:8.2f} {r_strip[i]:8.2f} {(r_strip[i]/2.1)**2*100:10.0f}% | {lit_[i]*100:5.0f}% {pre_[i]*100:11.0f}% {post_[i]*100:12.0f}% {ok_[i]*100:7.0f}% {thr_[i]*100:7.0f}%")

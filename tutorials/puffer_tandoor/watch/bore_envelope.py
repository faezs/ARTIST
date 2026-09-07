"""The beam's real size down the bore: primary -> hyperboloid strip -> M3 (the turn).

The strip's second focus is M3 itself (m4_mode 'field'), so the bore carries a
converging beam to a waist AT the turn. Earlier I measured |hit - P4| on M3's curved
surface, which is not the beam's width - a ray converging steeply meets a curved
mirror well off its vertex. This measures the bundle in PLANES: the radius about the
bore axis at heights from the strip down to the turn, so "is M3 smaller than the
inlet?" becomes a number.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_hashemi_env as HE
from tandoor_mount_batch import mount_batch


def rays(e, day=172, hour=12.0, B=None, det=False):
    """the eager core's ray set: strip hit h1 and the direction d2 after the strip"""
    B = B or e.num_agents
    e._det_trace = det
    el, az, _ = HE._sim.solar_position(30.2, day, hour)
    e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
    e.day = day; e.day_v[:] = day; e.lat_v[:] = 30.2; e.t_solar[0] = hour
    dev = e.device; P = e.n_rays
    mnt = mount_batch(e, torch.full((B,), float(day), device=dev), torch.full((B,), 30.2, device=dev), hour, dev,
                      pnt=torch.tensor(np.stack([e.el_m, e.az_m], 1), dtype=torch.float32, device=dev))
    z = lambda: torch.zeros(B, P, device=dev)
    metal, e._metal = e._metal, None; geo0, e._geo = e._geo, e._geo_ref
    args = (e._pts_l, e._nrm_l, torch.full((B,), 4.0, device=dev), z(), z(),
            torch.rand(B, P, device=dev), torch.rand(B, P, device=dev),
            torch.full((B,), 5e-3, device=dev), mnt["Acan"].contiguous().view(B, 1, 3, 3), mnt["Mt"].contiguous(),
            mnt["Cd"].contiguous()[:, None, :], torch.zeros(B, 1, 2, device=dev), torch.zeros(B, 2, device=dev),
            mnt["vp"][:, :, None, :], e._sc_base, mnt["scb"].contiguous(), e.ell_M, e.ell_S, e.ell_ctr_t, e._V0t, e._fct)
    out = e._geo(*args); e._metal, e._geo = metal, geo0
    (through_b, w_ray, dy, dz, d3, ok, ok_pre, ok_post, lit, in_slot, graze, rad1, p, h1, h2, h3, desc) = out
    return dict(h1=h1[0].detach().cpu().numpy(), d2=None, ok=ok_pre[0].detach().cpu().numpy(),
                thr=through_b[0].detach().cpu().numpy(), h2=h2[0].detach().cpu().numpy(),
                dy=dy[0].detach().cpu().numpy(), dz=dz[0].detach().cpu().numpy(), desc=desc[0].detach().cpu().numpy())


e = build(num_agents=8, gpu=0, device="cpu", n_rays=4096)
obs, _ = e.reset(seed=3)
F = np.array([e.X_TOWER_C, 0.0, e.z_fold]); P4 = np.array(e.cs_P4); F4 = np.array(e.cs_F4); F2 = np.array(e.cs_F2)
print(f"chain: dish -> strip (d_strip {e.d_strip:.2f} m from F) -> the turn mirror at {np.round(P4,2)} -> inlet {np.round(F4,2)}")
print(f"  F {np.round(F,2)}, the strip's second focus F2 {np.round(F2,2)} ({'AT the turn mirror' if np.allclose(F2, P4, atol=1e-6) else 'up the bore'}), mode '{e.m4_mode}', magnification {e.cs_mag:.1f}")
print(f"  bore length |F - turn| {np.linalg.norm(P4-F):.2f} m; inlet radius r_duct {e.r_duct:.2f} m; the mirror's patch bound r_m4 {e.r_m4:.2f} m")
R = rays(e)
h1, h2 = R["h1"], R["h2"]                           # the strip hit and the hit on the turn mirror
seg = h2 - h1; L = np.linalg.norm(seg, axis=-1)
desc = seg / np.maximum(L, 1e-9)[:, None]           # the true direction down the bore, strip -> mirror
m = R["ok"] & (L > 0.5) & (desc[:, 2] < -0.5)
print(f"  rays leaving the strip: {m.sum()} of {len(m)}")
axis = (P4 - F) / np.linalg.norm(P4 - F)
print(f"\n  height z   distance below F   beam radius about the bore axis [m]: rms / 90th pct / max")
for zt in (9.0, 8.0, 6.0, 4.0, 2.0, 1.0, 0.6, 0.4, 0.30, 0.20, 0.14, 0.10, 0.0):
    t = (zt - h1[:, 2]) / np.where(np.abs(desc[:, 2]) > 1e-9, desc[:, 2], -1e-9)
    X = h1 + t[:, None] * desc
    w = X - F; perp = w - (w @ axis)[:, None] * axis[None, :]
    r = np.linalg.norm(perp, axis=1)[m & (t > 0)]
    if len(r) < 10: continue
    print(f"   {zt:5.2f} m   {e.z_fold - zt:14.2f} m   {np.sqrt((r**2).mean()):6.3f} / {np.percentile(r,90):6.3f} / {r.max():6.3f}" + ("   <- the turn mirror" if abs(zt - P4[2]) < 1e-6 else "") + ("   <- inlet height" if abs(zt - F4[2]) < 1e-6 and abs(zt-P4[2])>1e-9 else ""))
print(f"\n  the waist: the strip focuses the sun's image onto the turn, magnified {e.cs_mag:.1f}x from the dish's focal image")
print(f"  (the sun's image at F is 2 x {4.05*4.65e-3*1e3:.0f} mm, so at the turn it is 2 x {4.05*4.65e-3*e.cs_mag*1e3:.0f} mm = {2*4.05*4.65e-3*e.cs_mag:.2f} m across)")
r4 = np.linalg.norm(R["h2"] - P4, axis=-1)[R["thr"]]
print(f"  for comparison, the HIT radius on the curved mirror |h - P4|: rms {np.sqrt((r4**2).mean()):.3f}, max {r4.max():.3f} m - the surface's extent, not the beam's width")

"""Per-block parity (all agents on one surface block) and the loss ladder of
the fixed Cassegrain receiver against the ray's radius on the parent, for the
built circle and two sections of the 4 x 6 roof."""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_section_surface import build_section
from tandoor_mount_batch import mount_batch
B = 64
kw = dict(num_agents=B, seed=1, device="mps", gpu=1, n_rays=512, lat=30.2, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1, flare_ratio=1.4, flare_reflect=0.6, elbow_aim=1, spot_bread=1, wall="ifb", insulation=1, night_carry=1)
with contextlib.redirect_stdout(io.StringIO()):
    e = TandoorHashemiEnv(**kw); e.reset(seed=1)
S = np.load("/Users/faezs/ARTIST/tutorials/data/tandoor/section_site_fields.npy", allow_pickle=True).item(); xs = S["xs"]; grid = float(xs[1] - xs[0])
X, Y = np.meshgrid(xs, xs, indexing="ij"); site = S["sites"]["4 x 6 (median)"]
secs = [build_section((site["need"] <= 2.0) & (site["over"] <= cap), X, Y, grid, float(e.f_nom), list(e.LEVEL_FRAC), e.n_rays, loss_chain=float(e._loss_chain)) for cap in (2.0, 3.5)]
e.install_sections(secs)
names = ("built circle", "section cap 2", "section cap 3.5")
for k in range(3):
    e._fct[:, e.DS["site"]] = float(k); e._refresh_site_weights()
    mism, maxd = e.verify_megakernel(); print(f"parity, all agents on block {k} ({names[k]}): {mism} mismatches > 1e-3, max |diff| {maxd:.2e}")
# the ladder against the ray's radius on the parent, at two poses (perfect pointing, nominal pump, no blur)
e._det_trace = True; e.el_m = np.zeros(B); e.az_m = np.zeros(B)
for name_pose, day, hour in (("summer noon", 172, 12.0), ("winter noon", 355, 12.0), ("equinox 9:00", 80, 9.0)):
    e.day = day; e.day_v = np.full(B, day, dtype=np.float64); e.lat_v = np.full(B, 30.2); e.t_solar[0] = hour
    import tandoor_hashemi_env as HE
    el, az, _ = HE._sim.solar_position(30.2, day, hour); e.el_m = np.full(B, el); e.az_m = np.full(B, np.degrees(az) if abs(az) < 7 else az)
    for k in range(3):
        e._fct[:, e.DS["site"]] = float(k); e._refresh_site_weights()
        metal, e._metal = e._metal, None
        # replicate _trace_power's argument build to get the raw tuple
        dev = e.device; P = e.n_rays
        lv = torch.full((B,), 4.0, device=dev)  # level 1.00 is index 4 of LEVEL_FRAC
        du = torch.zeros(B, P, device=dev); de = torch.zeros(B, P, device=dev); upick = torch.full((B, P), 0.5, device=dev); us = torch.full((B, P), 0.5, device=dev)
        mnt = mount_batch(e, torch.full((B,), float(day), device=dev), torch.full((B,), 30.2, device=dev), hour, dev, pnt=torch.tensor(np.stack([e.el_m, e.az_m], 1), dtype=torch.float32, device=dev))
        f_np = e._fct[:, 53].detach().cpu().numpy().astype(np.float64)
        dvec = torch.zeros(B, 1, 2, device=dev); off = torch.zeros(B, 2, device=dev)
        args = (e._pts_l, e._nrm_l, lv, du, de, upick, us, torch.full((B,), 1e-4, device=dev), mnt["Acan"].contiguous().view(B, 1, 3, 3), mnt["Mt"].contiguous(), mnt["Cd"].contiguous()[:, None, :], dvec, off, mnt["vp"][:, :, None, :], e._sc_base, mnt["scb"].contiguous(), e.ell_M, e.ell_S, e.ell_ctr_t, e._V0t, e._fct)
        out = e._geo_ref(*args); e._metal = metal
        (through_b, w_ray, dy, dz, d3, ok, ok_pre_tube, ok_post_tube, lit, in_slot, graze, rad1, p, h1, h2, h3, desc) = out
        pl = e._pts_l[4 + k * 7] if e._pts_l.shape[0] > 7 else e._pts_l[4]
        r = torch.sqrt(pl[:, 0] ** 2 + pl[:, 1] ** 2).cpu().numpy()
        f = lambda t: t[0].float().cpu().numpy()
        lit0, strip, pre, post, okk, thr = f(lit), f(lit & ~graze & (rad1 < e.r_m1)), f(ok_pre_tube), f(ok_post_tube), f(ok), f(through_b)
        pw = e._ray_pw_agent[0].cpu().numpy() if e._ray_pw_agent is not None else e._ray_pw.cpu().numpy()
        print(f"{name_pose:13s} {names[k]:16s} sun el {el:4.1f}: lit {lit0.mean():.2f} strip {strip.mean():.2f} pre-bore {pre.mean():.2f} post-bore {post.mean():.2f} M4/duct {okk.mean():.2f} through {thr.mean():.2f}; power {float((thr*pw).sum()):.2f} of {pw.sum():.2f}")
        edges = np.array([0.6, 1.5, 2.1, 2.5, 3.0, 3.5, 4.0, 5.0, 6.0, 7.0])
        row = []
        for a_, b_ in zip(edges[:-1], edges[1:]):
            m = (r >= a_) & (r < b_)
            if m.sum() >= 3: row.append(f"r {a_:.1f}-{b_:.1f}: {thr[m].mean():.2f} (strip {strip[m].mean():.2f} bore {post[m].mean():.2f} M4 {okk[m].mean():.2f})")
        print("     through by radius: " + "; ".join(row))

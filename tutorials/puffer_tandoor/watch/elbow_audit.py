"""Where the beam actually lands inside the pot, and whether M4 could do the elbow's job.

Part A: run the trained hashemi.ini cook for a day and account for every watt that
enters the pot - bake row, loaves, hearth, crown, lower wall - so "the elbow is not
spraying it into the rotis" becomes a number.

Part B: the geometry that decides whether the elbow can be deleted. M4 is an
ellipsoid that images F2 (up the bore) onto the pot's INLET; the inlet is the
bottleneck (r_duct 0.15..0.30 m) and M4's illuminated patch is metres across, so
the beam only fits through the hole because it is focused there. Aiming M4 at a
loaf instead moves its focus past the inlet and the beam re-expands: this measures
the illuminated radius on M4 and the beam radius at the inlet for every aim.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_design_readout import Policy
import tandoor_polar_env as PE

CK = "/Users/faezs/ARTIST/tutorials/puffer_tandoor/experiments/178873334019/model_000358.pt"
DEV = "mps"
KW = dict(gpu=1, day_random=0, lat_random=0, lat=30.2, device=DEV, n_rays=512, num_agents=256, g_orbit=4, n_zones=5,
          zone_c=0.4, deck_h=4.0, nurbs=1, wide_shutter=1, warm_frac=0.0, wall_obs=1, flare_ratio=1.4, flare_reflect=0.6,
          beta_dev=0.0, beta_cap_z=7.6, silvered=1, duct_nozzle=2, spot_bread=1, elbow_aim=1, load_ctrl=1, roti_kj=130.0,
          bread_area=0.12, loaves_per_load=8, reward_div=75.0, sticky_k=2, receiver="cass", r_m4=1.3, night_carry=1,
          wall="ifb", insulation=1, cut_penalty=75.0, lost_deg=5.0, enc_clamp=6.0)


def build(**over):
    kw = dict(KW); kw.update(over)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw)
    return e


def run_day(e, pol, day, steps=1800):
    """one pinned day with the trained cook; accumulate the per-node power [W per step]"""
    B, N, NB = e.num_agents, e.n_nodes, e.n_belt
    e.day = day
    if hasattr(e, "day_v"): e.day_v[:] = day
    obs, _ = e.reset(seed=7)
    pol.reset(B, DEV)
    nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0])
    acc = torch.zeros(N + NB, device=DEV); n_acc = 0; rot = []
    for t in range(steps):
        with torch.no_grad():
            a, _ = pol.step(torch.as_tensor(obs, device=DEV, dtype=torch.float32), nh, nv)
        obs, r, term, trunc, info = e.step(a.cpu().numpy() if torch.is_tensor(a) else a)
        S = e._gpu
        if S is not None:
            S.day_v.fill_(float(day)); S.lat_v.fill_(30.2)
            acc += S.per.mean(0).detach(); n_acc += 1
        for i in (info if isinstance(info, (list, tuple)) else []):
            if isinstance(i, dict) and "rotis_per_day" in i: rot.append(float(i["rotis_per_day"]))
    return acc.cpu().numpy(), n_acc, (float(np.mean(rot)) if rot else float("nan"))


def flux_table(acc, N, NB, label):
    node, loaf = acc[:N], acc[N:]
    bake = node[:NB].sum(); hearth = node[NB]; crown = node[NB + 2]; low = node[NB + 3:N].sum()
    other = node.sum() - bake - hearth - crown - low
    tot = node.sum(); onloaf = loaf.sum()
    print(f"\n== {label} ==")
    print(f"  power into the pot, by where it lands (share of the total):")
    for nm, v in (("bake row (the wall band the loaves lean on)", bake), ("hearth / floor", hearth), ("crown (above the bake row)", crown), ("lower wall", low), ("other nodes", other)):
        print(f"    {nm:44s} {v/max(tot,1e-9)*100:5.1f}%")
    print(f"  of the total, landing ON a loaf patch: {onloaf/max(tot,1e-9)*100:5.1f}%  (of the bake row's own share: {onloaf/max(bake,1e-9)*100:5.1f}%)")
    print(f"  per loaf slot [% of total]: " + " ".join(f"{v/max(tot,1e-9)*100:4.1f}" for v in loaf))
    return dict(bake=float(bake), loaf=float(onloaf), tot=float(tot))


def m4_geometry(e):
    """the illuminated patch on M4 and the beam's radius at the inlet for any aim"""
    B = e.num_agents
    e._det_trace = True
    import tandoor_hashemi_env as HE
    el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
    e.el_m = np.full(B, el); e.az_m = np.full(B, np.degrees(az) if abs(az) < 7 else az)
    e.day = 172; e.day_v[:] = 172; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
    metal, e._metal = e._metal, None; geo0, e._geo = e._geo, e._geo_ref
    from tandoor_mount_batch import mount_batch
    dev = e.device
    P = e.n_rays
    mnt = mount_batch(e, torch.full((B,), 172.0, device=dev), torch.full((B,), 30.2, device=dev), 12.0, dev,
                      pnt=torch.tensor(np.stack([e.el_m, e.az_m], 1), dtype=torch.float32, device=dev))
    lv = torch.full((B,), 4.0, device=dev)
    z = lambda: torch.zeros(B, P, device=dev)
    args = (e._pts_l, e._nrm_l, lv, z(), z(), torch.full((B, P), 0.5, device=dev), torch.full((B, P), 0.5, device=dev),
            torch.full((B,), 1e-4, device=dev), mnt["Acan"].contiguous().view(B, 1, 3, 3), mnt["Mt"].contiguous(),
            mnt["Cd"].contiguous()[:, None, :], torch.zeros(B, 1, 2, device=dev), torch.zeros(B, 2, device=dev),
            mnt["vp"][:, :, None, :], e._sc_base, mnt["scb"].contiguous(), e.ell_M, e.ell_S, e.ell_ctr_t, e._V0t, e._fct)
    out = e._geo(*args); e._metal, e._geo = metal, geo0
    (through_b, w_ray, dy, dz, d3, ok, ok_pre, ok_post, lit, in_slot, graze, rad1, p, h1, h2, h3, desc) = out
    P4 = np.array(e.cs_P4); F4 = np.array(e.cs_F4)
    m = ok_post[0].cpu().numpy()
    h4 = h2[0].cpu().numpy(); r4 = np.linalg.norm(h4 - P4, axis=-1)
    thr = through_b[0].cpu().numpy()
    h5 = h3[0].cpu().numpy()
    d_m4_mouth = float(np.linalg.norm(F4 - P4))
    print(f"\n== M4 and the inlet (summer noon, perfect pointing) ==")
    print(f"  M4 at {np.round(P4,2)}, the pot's inlet at {np.round(F4,2)}: {d_m4_mouth:.2f} m apart; M4's aperture bound r_m4 {e.r_m4:.2f} m, the inlet r_duct {e.r_duct:.2f} m")
    print(f"  rays reaching M4: {m.sum()} of {P}; the illuminated patch on M4 spans radius {r4[m].min():.2f}..{r4[m].max():.2f} m (rms {np.sqrt((r4[m]**2).mean()):.2f})")
    if thr.any():
        rr5 = np.linalg.norm(h5[thr][:, 1:] - np.array([0.0, e.z_m5 if False else h5[thr][:, 2].mean()]), axis=-1) if False else None
        print(f"  rays through the inlet: {thr.sum()} ({thr.mean()*100:.0f}% of all rays)")
    R = float(np.sqrt((r4[m] ** 2).mean()) * 2 ** 0.5) if m.any() else float("nan")   # rms -> an equivalent-uniform radius
    print(f"\n  THE APERTURE ARGUMENT: M4 focuses the beam INTO the inlet {d_m4_mouth:.2f} m away. Aim its focus at a point")
    print(f"  L metres away instead (a loaf on the far wall is ~2.3 m from M4) and the beam's radius at the inlet grows to")
    print(f"  R_patch x |1 - {d_m4_mouth:.2f}/L|:")
    for L, what in ((d_m4_mouth, "the inlet itself (as built)"), (1.2, "just inside the mouth"), (1.6, "the near wall"), (2.3, "a loaf on the far wall"), (3.0, "the far wall's far side")):
        rb = R * abs(1.0 - d_m4_mouth / L)
        print(f"    L {L:4.2f} m ({what:28s}): beam radius at the inlet {rb:5.2f} m -> {min(1.0, (e.r_duct/max(rb,1e-9))**2)*100:5.1f}% of the beam passes a {e.r_duct:.2f} m hole")
    return R, d_m4_mouth


if __name__ == "__main__":
    e = build()
    sd = torch.load(CK, map_location="cpu", weights_only=False)
    W = sd["policy.encoder.0.weight"].shape[1]
    assert W == e.single_observation_space.shape[0], f"checkpoint obs {W} vs env {e.single_observation_space.shape[0]}"
    pol = Policy(sd, DEV)
    print(f"cook {CK.split('/')[-2]}/{CK.split('/')[-1]}, {e.num_agents} agents, {e.n_nodes} nodes + {e.n_belt} loaf columns")
    for day, lab in ((172, "summer (day 172)"), (355, "winter (day 355)")):
        acc, steps, rot = run_day(e, pol, day)
        flux_table(acc, e.n_nodes, e.n_belt, f"{lab}, {steps} steps, the trained cook with the elbow (duct_nozzle=2), rotis/day {rot:.0f}")
    m4_geometry(e)

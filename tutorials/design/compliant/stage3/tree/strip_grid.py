"""Two proposals on the configured tri machine, by its own trace: (1) F vertically above M3 (post_offset 0, the bore
vertical); (2) the strip AT F rather than d_strip ahead of it (d_strip -> 0: the hyperboloid's F sheet moves onto its
own focus and the magnification (2c - d)/d runs away). Same harness as beta_flux.py."""
import sys, numpy as np, torch
sys.argv = [sys.argv[0]]
exec(open("/Users/faezs/ARTIST-compliant/tutorials/design/compliant/stage3/tree/beta_flux54.py").read().split('if __name__ == "__main__":')[0])
def build_cfg(beta, post_offset, d_strip):
    kw = dict(num_agents=16, seed=7, wide_shutter=1, device="mps", gpu=1, n_rays=256, warm_frac=1.0, day_random=0,
              lat_random=0, wall_obs=1, beta_dev=float(beta), beta_cap_z=10.6, silvered=1, duct_nozzle=2,
              spot_bread=1, roti_kj=130.0, bread_area=0.12, loaves_per_load=8, elbow_aim=1, load_ctrl=1, sticky_k=0,
              receiver="tri", r_duct=0.55, r_m4=1.3, g_orbit=4.0, n_zones=5, zone_c=0.4, post_offset=float(post_offset),
              d_strip=float(d_strip), nurbs=1, flare_ratio=1.4, flare_reflect=0.6)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=7)
    e._det_trace = True; S = FusedState(e); e._gpu = S
    return e, S
CODES = {0: "through", 2: "missed the hyperboloid", 3: "off the strip", 4: "grazed the arm", 5: "re-crossed", 6: "outside the bore at the deck",
         7: "missed M3", 8: "lost on the way", 9: "collar", 11: "strip shadow", 12: "hole", 13: "slot", 14: "arm shadow"}
def ledger_at(e, S, day, hour):
    B = e.num_agents; S.zero_noise = True; S.day_v.fill_(float(day)); S.lat_v.fill_(30.2)
    decl = 23.44*np.sin(2.0*np.pi*(284.0 + day)/365.0); S.decl_formed.fill_(decl); S.decl_now.fill_(decl)
    a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=DEV); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
    el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(hour))
    S.el_m.copy_(el.to(DEV)); S.az_m.copy_(torch.rad2deg(az).to(DEV)); S.e_el_prev.zero_(); S.e_az_prev.zero_(); S.lost_ct.zero_()
    e.t_solar[:] = hour; e._gen.manual_seed(100003*int(hour*10) + 7919)
    with torch.no_grad(): e.step_torch(a)
    code = S.fate.reshape(-1, 6)[:, 0].cpu().numpy(); n = len(code); vals, cnt = np.unique(code, return_counts=True)
    return float(S.diag[:, 0].mean().item())/1e3, " . ".join(f"{CODES.get(int(v), int(v))} {100*c/n:.0f}%" for v, c in sorted(zip(vals, cnt), key=lambda x: -x[1]) if c/n >= 0.02)
e, S = build_cfg(0.0, 0.5, 0.6)
print(f"the machine: F {np.round(e.F_focus, 2)}, P4 {np.round(np.asarray(e.cs_P4), 2)}, F2 {np.round(np.asarray(e.cs_F2), 2)}, c_h {e.cs_c:.2f} m, a_h {e.cs_a:.2f}, mag {e.cs_mag:.1f}, u_f2 {e.u_f2}, m4_mode {getattr(e, 'm4_mode', '?')}, arm from x {e.cs_Ps[0]:.2f} at z {e.cs_Ps[2]:.2f}")
del e, S
print(f"\n{'post_off':>8} {'d_strip':>7} {'mag':>5} {'beta':>4} | {'midwinter':>9} {'equinox':>8} {'midsummer':>9} kW day means")
grid = [(0.5, 0.6, 0), (0.5, 0.6, 36), (0.0, 0.6, 0), (0.0, 0.6, 36), (0.0, 0.3, 0), (0.0, 0.3, 36), (0.0, 0.15, 0), (0.0, 0.9, 0), (0.0, 1.2, 0)]
res = {}
for po, d, beta in grid:
    means = []
    for day in DAYS:
        e, S = build_cfg(beta, po, d); rows = traced_kw(e, S, day); means.append(float(np.mean([r[1] for r in rows]))); mag = e.cs_mag; del e, S
    res[(po, d, beta)] = means
    print(f"{po:8.1f} {d:7.2f} {mag:5.1f} {beta:4.0f} | {means[0]:9.2f} {means[1]:8.2f} {means[2]:9.2f}", flush=True)
print("\nwhere the rays go at equinox noon, retro, bore vertical:")
for d in (0.6, 0.3, 0.15):
    e, S = build_cfg(0.0, 0.0, d); kw, led = ledger_at(e, S, 80, 12.5); print(f"   d_strip {d:.2f} (mag {e.cs_mag:.1f}): {kw:.2f} kW | {led}"); del e, S

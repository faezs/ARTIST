"""beta 36 under different rim caps on the configured machine: flower.ini kept beta_cap_z = 10.6 from the old deck,
and F has since come down 1.4 m with deck_h = None. If the cap was what tamed beta at high sun, lowering it should
bring the high-sun power back."""
import sys, numpy as np
sys.argv = [sys.argv[0]]
exec(open("/Users/faezs/ARTIST-compliant/tutorials/design/compliant/stage3/tree/beta_flux54.py").read().split('if __name__ == "__main__":')[0])
def build_cap(beta, cap):
    kw = dict(num_agents=16, seed=7, wide_shutter=1, device="mps", gpu=1, n_rays=256, warm_frac=1.0, day_random=0,
              lat_random=0, wall_obs=1, beta_dev=float(beta), beta_cap_z=cap, silvered=1, duct_nozzle=2,
              spot_bread=1, roti_kj=130.0, bread_area=0.12, loaves_per_load=8, elbow_aim=1, load_ctrl=1, sticky_k=0,
              receiver="tri", r_duct=0.55, r_m4=1.3, g_orbit=4.0, n_zones=5, zone_c=0.4, post_offset=0.5,
              nurbs=1, flare_ratio=1.4, flare_reflect=0.6)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=7)
    e._det_trace = True; S = FusedState(e); e._gpu = S
    return e, S
hdr = "  ".join(f"{h:>5.1f}h" for h in HOURS)
for day, name in zip(DAYS, ("midwinter (doy 355)", "equinox (doy 80)", "midsummer (doy 172)")):
    print(f"{name}   beta_dev 36 under rim caps"); print(f"{'cap_z':>6}  {hdr}   {'day mean':>9}   eff beta by hour", flush=True)
    for cap in (10.6, 9.6, 9.2, 8.8, 8.5, None):
        e, S = build_cap(36.0, cap); rows = traced_kw(e, S, day); kws = [r[1] for r in rows]
        print(f"{str(cap):>6}  " + "  ".join(f"{k:>6.2f}" for k in kws) + f"   {np.mean(kws):>6.2f} kW   " + " ".join(f"{r[2]:.0f}" for r in rows), flush=True)
        del e, S
    print()

#!/usr/bin/env python
"""The power at beta 54 - and past it - on the machine AS NOW CONFIGURED (flower.ini: tri receiver, r_duct 0.55, M3 r 1.3,
the deck on the roof, post_offset 0.5, zoned membrane, nurbs figure), by the env's own perfect-tracking trace.
Same harness as beta_flux.py (ladder_day semantics: S.diag[:, 0] delivered kW, zero sun-cone noise, 16 identical
agents, n_rays 256). The confined-head law wants the TOP of the beta band, so the ladder runs 36, 45, 54, 63, 72,
and logs the beta the env actually applies each hour (its own cap and slot clamps can pull it below the command).

    /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python beta_flux54.py"""
import contextlib, io, os, sys, json
import numpy as np, torch
for p in ("/Users/faezs/ARTIST/tutorials", "/Users/faezs/ARTIST", "/Users/faezs/ARTIST/tutorials/puffer_tandoor"): sys.path.insert(0, p)
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_mount_batch import solar_batch
DEV = "mps"; OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out"); os.makedirs(OUT, exist_ok=True)
HOURS = (8.0, 9.5, 11.0, 12.5, 14.0, 15.5); DAYS = (355, 80, 172)
BETAS = (36.0, 45.0, 54.0, 63.0, 72.0)
def traced_kw(e, S, day, hours=HOURS):
    B = e.num_agents; S.zero_noise = True
    S.day_v.fill_(float(day)); S.lat_v.fill_(30.2)
    decl = 23.44*np.sin(2.0*np.pi*(284.0 + day)/365.0); S.decl_formed.fill_(decl); S.decl_now.fill_(decl)
    a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=DEV); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
    out = []
    for h in hours:
        el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(h))
        S.el_m.copy_(el.to(DEV)); S.az_m.copy_(torch.rad2deg(az).to(DEV))
        S.e_el_prev.zero_(); S.e_az_prev.zero_(); S.lost_ct.zero_()
        e.t_solar[:] = h; e._gen.manual_seed(100003*int(h*10) + 7919)
        with torch.no_grad(): e.step_torch(a)
        try: b_eff = float(np.mean(np.atleast_1d(e._beta_now(float(el.mean().item())))))
        except Exception: b_eff = float("nan")
        out.append((float(el.mean().item()), float(S.diag[:, 0].mean().item())/1e3, b_eff))
    return out
def build(beta):
    kw = dict(num_agents=16, seed=7, wide_shutter=1, device="mps", gpu=1, n_rays=256, warm_frac=1.0, day_random=0,
              lat_random=0, wall_obs=1, beta_dev=float(beta), beta_cap_z=10.6, silvered=1, duct_nozzle=2,
              spot_bread=1, roti_kj=130.0, bread_area=0.12, loaves_per_load=8, elbow_aim=1, load_ctrl=1, sticky_k=0,
              # the machine as flower.ini has it
              receiver="tri", r_duct=0.55, r_m4=1.3, g_orbit=4.0, n_zones=5, zone_c=0.4, post_offset=0.5,
              nurbs=1, flare_ratio=1.4, flare_reflect=0.6)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=7)
    e._det_trace = True; S = FusedState(e); e._gpu = S
    return e, S
if __name__ == "__main__":
    lines = []; res = {}
    def say(t=""): print(t, flush=True); lines.append(t)
    say("THE POWER PAST BETA 45, on the machine as flower.ini configures it (tri, r_duct 0.55, roof deck, post_offset 0.5)")
    say("delivered kW at the bread, perfect tracking, n_rays 256, zero sun-cone noise, 16 identical agents. 'eff' is the")
    say("beta the env actually applied at that hour after its own cap and slot clamps.")
    say()
    hdr = "  ".join(f"{h:>5.1f}h" for h in HOURS)
    for day, name in zip(DAYS, ("midwinter (doy 355)", "equinox (doy 80)", "midsummer (doy 172)")):
        say(f"{name}"); say(f"{'beta_dev':>9}  {hdr}   {'day mean':>9}   {'vs 36':>7}   eff beta by hour")
        base = None
        for beta in BETAS:
            e, S = build(beta); rows = traced_kw(e, S, day); kws = [r[1] for r in rows]; m = float(np.mean(kws))
            base = m if base is None else base
            say(f"{beta:>9.0f}  " + "  ".join(f"{k:>6.2f}" for k in kws) + f"   {m:>6.2f} kW   {100*(m/base - 1):+5.1f} %   "
                + " ".join(f"{r[2]:.0f}" for r in rows))
            res[f"{day}_{beta:.0f}"] = dict(day=day, beta=beta, kw=kws, mean=m, el=[r[0] for r in rows], eff=[r[2] for r in rows])
            del e, S
        say()
    open(os.path.join(OUT, "beta_flux54.txt"), "w").write("\n".join(lines) + "\n")
    json.dump(res, open(os.path.join(OUT, "beta_flux54.json"), "w"), indent=1)

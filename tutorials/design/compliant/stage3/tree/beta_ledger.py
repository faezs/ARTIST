"""WHERE THE RAYS GO at retro and at beta 36 on the configured tri machine: the per-ray fate ledger, so the shading the
trace actually charges is read off in percent of the rays rather than inferred."""
import sys, numpy as np, torch
sys.argv = [sys.argv[0]]
exec(open("/Users/faezs/ARTIST-compliant/tutorials/design/compliant/stage3/tree/beta_flux54.py").read().split('if __name__ == "__main__":')[0])
CODES = {0: "through to the bread", 2: "missed the hyperboloid", 3: "off the strip's extent", 4: "grazed the arm", 5: "re-crossed the dish or arm",
         6: "outside the bore at the deck", 7: "missed M3", 8: "lost on the way", 9: "hit the collar / not through",
         11: "STRIP SHADOW on the dish", 12: "the dish's HOLE (r_hole)", 13: "the SLOT", 14: "the ARM's shadow on the dish"}
def ledger(e, S, day, hour):
    B = e.num_agents; S.zero_noise = True
    S.day_v.fill_(float(day)); S.lat_v.fill_(30.2)
    decl = 23.44*np.sin(2.0*np.pi*(284.0 + day)/365.0); S.decl_formed.fill_(decl); S.decl_now.fill_(decl)
    a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=DEV); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
    el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(hour))
    S.el_m.copy_(el.to(DEV)); S.az_m.copy_(torch.rad2deg(az).to(DEV)); S.e_el_prev.zero_(); S.e_az_prev.zero_(); S.lost_ct.zero_()
    e.t_solar[:] = hour; e._gen.manual_seed(100003*int(hour*10) + 7919)
    with torch.no_grad(): e.step_torch(a)
    fate = None
    for src in (getattr(e, "_fate", None), getattr(S, "_fate", None), getattr(getattr(e, "_metal", None), "last_fate", None), getattr(S, "fate", None)):
        if src is not None: fate = src; break
    kw = float(S.diag[:, 0].mean().item())/1e3
    if fate is None: return kw, None, float(el.mean())
    code = fate.reshape(-1, 6)[:, 0].detach().cpu().numpy()
    return kw, code, float(el.mean())
for day, name in ((80, "equinox"), (172, "midsummer"), (355, "midwinter")):
    for hour in (12.5, 9.5):
        print(f"\n{name} {hour} h")
        for beta in (0.0, 36.0):
            e, S = build(beta); kw, code, el = ledger(e, S, day, hour)
            if code is None: print(f"   beta {beta:.0f}: {kw:.2f} kW, no ledger exposed on this path"); del e, S; continue
            n = len(code); vals, cnt = np.unique(code, return_counts=True)
            parts = [f"{CODES.get(int(v), f'code {int(v)}')} {100*c/n:.1f}%" for v, c in sorted(zip(vals, cnt), key=lambda x: -x[1]) if c/n >= 0.004]
            print(f"   beta {beta:.0f} (sun el {el:.0f}): {kw:.2f} kW | " + " . ".join(parts))
            del e, S

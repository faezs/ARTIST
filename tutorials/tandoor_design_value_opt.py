"""RL THE DESIGN, the value model as the design tool: the design-conditioned
critic V(design | dawn state) is differentiable in its design inputs, so
the design is optimized by gradient ascent THROUGH the trained network -
no ladder, no surrogate, the policy's own estimate of what a machine is
worth with itself in the loop.

Per site (the roof is not a choice): the roof percentile is fixed, the
deck and the rest of the machine are free, the dish is the largest that
fits (the env's roof_to_scale rule). Unpriced: maximize V0. Priced:
maximize rotis(V0) x bread x PKR x days x years - capital(design), the
capital in torch so it is part of the gradient.

    python tandoor_design_value_opt.py CKPT.pt [--layout site|old] [--sites 0.1,0.5,0.9]
        [--calib readout.json]  # rotis per unit of V0 from a readout's regression
"""
import argparse, contextlib, io, json, sys
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_design_readout import Policy, env_kwargs, DEV
import tandoor_system_cost as C


def capital_torch(d, roof):
    """C.capital in torch (d: dict of (K,) tensors of design values)."""
    s = d["dish_scale"]; deck = d["deck_h"]
    A_dish = np.pi * (C.A_MEM0 * s) ** 2
    th = torch.deg2rad(d["strip_th_hi"]); r_mean = 1.4 * d["d_strip"]
    A_strip = r_mean * th * d["strip_wk"] * r_mean
    A_m4 = np.pi * d["r_m4"] ** 2
    A_bore = 2 * np.pi * d["r_bore"] * (C.L_BORE + (deck - 4.0))
    P = C.PRICES
    p_post = d.get("mount_post", torch.zeros_like(s))
    mount = p_post * P["post_mount"] + (1 - p_post) * P["rail_m"] * 2 * np.pi * (C.G_ORBIT0 * s + 0.6)
    sand = torch.where(d.get("sand_depth", torch.zeros_like(s)) > 0.01,
                       P["sand_fixed"] + P["fins_m2_per_k"] * 1.51 * (d.get("sand_k", torch.full_like(s, 0.3)) - 0.3).clamp(min=0), torch.zeros_like(s))
    return (P["dish_m2"] * A_dish + P["tower_m"] * deck + mount + sand + P["motors"] * d["rate_scale"] ** 1.5
            + P["shell"] / d["ins_scale"].clamp(min=0.2) + P["mass"] * d["cap_scale"]
            + P["lid"] * 0.18 / d["lid_leak"].clamp(min=0.02) + P["strip_m2"] * A_strip
            + P["m4_m2"] * A_m4 + P["bore_m2"] * A_bore + P["fixed"])


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt", nargs="+", help="one checkpoint, or several: an ensemble (mean - kappa x std, so the design cannot exploit one critic's error)")
    ap.add_argument("--layout", default="site", choices=["site", "old"]); ap.add_argument("--kappa", type=float, default=1.0)
    ap.add_argument("--sites", default="0.1,0.5,0.9"); ap.add_argument("--calib", default=None)
    ap.add_argument("--starts", type=int, default=128); ap.add_argument("--iters", type=int, default=400)
    ap.add_argument("--years", type=float, default=5.0); ap.add_argument("--roti-pkr", type=float, default=8.0); ap.add_argument("--days", type=float, default=300.0)
    ap.add_argument("--seasoned", type=int, default=1)
    args = ap.parse_args()
    sds = [torch.load(c, map_location="cpu", weights_only=False) for c in args.ckpt]; pols = [Policy(sd) for sd in sds]; sd, pol = sds[0], pols[0]
    B = 256
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**env_kwargs(B, night_carry=int(args.seasoned > 1))); e.day = 172; e.lat = 30.2; e.reset(seed=1)
    OD = e.single_observation_space.shape[0]; nd = e.N_DESIGN; nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0])
    assert sd["policy.encoder.0.weight"].shape[1] == OD, "checkpoint obs dim != env obs dim"
    # the dawn template: the first observation of the day (cold pit), or the
    # dawn after (seasoned-1) carried nights, non-design columns averaged
    from tandoor_fused_step import FusedState
    e.day_v[:] = 172; e.lat_v[:] = 30.2; S = FusedState(e); e._gpu = S
    a = torch.full((B, nh), 3, dtype=torch.long, device=DEV)
    o, *_ = e.step_torch(a); pol.reset(B)
    for dday in range(args.seasoned - 1):
        with torch.no_grad():
            for t in range(2000):
                act, _ = pol.step(o, nh, nv); o, r, d, tr, _ = e.step_torch(act)
                if d.reshape(-1).any(): break
    dawn = o[:, :OD - nd].mean(0).detach()                    # (OD-nd,)
    names = [k for k, _, _ in tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX)]
    lo = torch.tensor([b[1] for b in tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX)], device=DEV); hi = torch.tensor([b[2] for b in tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX)], device=DEV)
    if args.layout == "old":
        names[9] = "dish_scale"; lo[9], hi[9] = 0.75, 1.30
    i_site = 9 if args.layout == "site" else None
    i_deck = names.index("deck_h")
    k_rotis = 400.0
    if args.calib:
        R = json.load(open(args.calib)); rr, vv = [], []
        for dd in R["days"].values(): rr += dd["rotis"]; vv += dd["v0"]
        b = np.polyfit(vv, rr, 1)[0]; k_rotis = float(b); print(f"calibration from {args.calib}: {k_rotis:.0f} rotis/day per unit of V0")

    def value_of(u, roof_u):
        """u (K,nd) in [0,1]; returns V0 (K,), design dict, capital (K,)."""
        x = lo + u * (hi - lo)
        d = {n: x[:, i] for i, n in enumerate(names)}
        if args.layout == "site":
            roof = torch.as_tensor(e._roof_quantile(roof_u), dtype=torch.float32, device=DEV).expand(u.shape[0])
            d["roof_r"] = roof
            over = ((d["deck_h"] - e.DECK_CLEAR) * e.OVERHANG_PER_M).clamp(0.0, e.OVERHANG_MAX)
            s_dish = (roof + over) / e.sweep0
            s_rail = (roof - e.RAIL_MARGIN) / float(e.g_orbit0)
            d["dish_scale"] = torch.where(d["mount_post"] >= 0.5, s_dish, torch.minimum(s_dish, s_rail)).clamp(e.S_LO, e.S_HI)
            uu = u.clone(); uu[:, i_site] = roof_u
        else:
            roof = torch.as_tensor(e._roof_quantile(roof_u), dtype=torch.float32, device=DEV).expand(u.shape[0])
            over = ((d["deck_h"] - e.DECK_CLEAR) * e.OVERHANG_PER_M).clamp(0.0, e.OVERHANG_MAX)
            d["dish_scale"] = ((roof + over) / e.sweep0).clamp(e.S_LO, e.S_HI)
            uu = u.clone(); uu[:, 9] = (d["dish_scale"] - 0.75) / 0.55     # the old layout's dish column follows the fit
        obs = torch.cat([dawn[None].expand(u.shape[0], -1), 2.0 * uu - 1.0], 1)
        vs = []
        for pk in pols:
            x1 = torch.nn.functional.gelu(obs @ pk.We + pk.be)
            h0 = torch.zeros(u.shape[0], pk.H, device=DEV); g = x1 @ pk.Wih + h0 @ pk.Whh + pk.bg
            i_, f_, gg, o_ = g.chunk(4, dim=-1); c = i_.sigmoid() * gg.tanh(); h = o_.sigmoid() * c.tanh()
            vs.append((h @ pk.Wv + pk.bv).squeeze(-1))
        vs = torch.stack(vs, 0)
        v = vs.mean(0) - (args.kappa * vs.std(0) if len(pols) > 1 else 0.0)   # the ensemble's lower confidence bound
        return v, d, capital_torch(d, roof)

    print(f"critic-driven design, {len(pols)} critic(s) {[c.split('/')[-1] for c in args.ckpt]}, layout {args.layout}, {'seasoned day %d' % args.seasoned if args.seasoned > 1 else 'cold'} dawn template, {args.starts} starts x {args.iters} Adam steps")
    for site in [float(x) for x in args.sites.split(",")]:
        roof_m = float(e._roof_quantile(site))
        for priced in (False, True):
            u = torch.rand(args.starts, nd, device=DEV, requires_grad=True); opt = torch.optim.Adam([u], lr=0.02)
            for it in range(args.iters):
                v, d, cap = value_of(u.clamp(0, 1), site)
                if priced:
                    val = k_rotis * v * (d["bread_area"] / 0.12) * args.roti_pkr * args.days * args.years - cap
                    loss = -val.mean()
                else:
                    loss = -v.mean()
                opt.zero_grad(); loss.backward(); opt.step()
                with torch.no_grad(): u.clamp_(0, 1)
            with torch.no_grad():
                v, d, cap = value_of(u, site)
                val = k_rotis * v * (d["bread_area"] / 0.12) * args.roti_pkr * args.days * args.years - cap
                j = int((val if priced else v).argmax())
                best = {n: float(d[n][j]) for n in names if n != "roof_r"}; best["dish_scale"] = float(d["dish_scale"][j])
            tag = "PRICED " if priced else "V0 only"
            print(f"  site p{site*100:.0f} (roof half-width {roof_m:.1f} m) {tag}: V0 {float(v[j]):.2f} -> ~{k_rotis*float(v[j]):.0f} rotis/day, capital {float(cap[j])/1e3:.0f}k, value {float(val[j])/1e3:.0f}k PKR; "
                  + ", ".join(f"{k}={best[k]:.2f}" for k in ("dish_scale", "deck_h", "rate_scale", "ins_scale", "cap_scale", "lid_leak", "bread_area", "loaves_per_load", "d_strip", "r_m4", "r_bore", "w_slot", "strip_th_hi")))

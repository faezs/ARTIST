"""RL THE DESIGN, the readout: one policy over B agents = B receiver
designs (design_rand=1, the same seeded designs the run trains on).
For a fixed day at Quetta, sampled actions, cold pit:
  rotis[b]   the day's rotis with the controller in the loop
  V0[b]      the critic's value of the dawn obs = V(design) once the
             policy has learned to read the design columns
  ladder[b]  the traced energy of design b at perfect tracking (the
             per-agent table makes a 2048-design ladder ten steps)
then a standardized linear regression of each on the unit-box design
coordinates: the design sensitivities, with and without the controller.

    python tandoor_design_readout.py ckpt.pt [--agents 2048] [--days 172,355]
"""
import argparse, contextlib, io, json, sys, time
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_mount_batch import solar_batch
DEV = "mps"


class Policy:
    """pufferlib Default + LSTMWrapper forward_eval, with the value head:
    GELU(enc) -> LSTMCell -> decoder logits, value = h @ Wv."""
    def __init__(self, sd, device=DEV):
        g = lambda k: sd[k].to(device)
        self.We, self.be = g("policy.encoder.0.weight").T, g("policy.encoder.0.bias")
        self.Wd, self.bd = g("policy.decoder.weight").T, g("policy.decoder.bias")
        self.Wv, self.bv = g("policy.value.weight").T, g("policy.value.bias")
        self.Wih, self.Whh = g("lstm.weight_ih_l0").T, g("lstm.weight_hh_l0").T
        self.bg = g("lstm.bias_ih_l0") + g("lstm.bias_hh_l0")
        self.H = self.Whh.shape[0]; self.h = self.c = None
    def reset(self, B, device=DEV):
        self.h = torch.zeros(B, self.H, device=device); self.c = torch.zeros(B, self.H, device=device)
    def step(self, obs, nh, nv):
        x = torch.nn.functional.gelu(obs @ self.We + self.be)
        gts = x @ self.Wih + self.h @ self.Whh + self.bg
        i, f, gg, o = gts.chunk(4, dim=-1)
        self.c = f.sigmoid() * self.c + i.sigmoid() * gg.tanh(); self.h = o.sigmoid() * self.c.tanh()
        lg = (self.h @ self.Wd + self.bd).view(-1, nh, nv)
        v = (self.h @ self.Wv + self.bv).squeeze(-1)
        u = torch.rand_like(lg)
        return (lg - torch.log(-torch.log(u.clamp_min(1e-20)))).argmax(-1), v


def env_kwargs(B, seed=1234):
    return dict(num_agents=B, seed=1, wide_shutter=1, device=DEV, gpu=1, n_rays=512, warm_frac=0.0,
                day_random=0, lat_random=0, wall_obs=1, n_zones=5, nurbs=1, flare_ratio=1.4, flare_reflect=0.6,
                silvered=1, duct_nozzle=2, spot_bread=1, roti_kj=130.0, bread_area=0.12, loaves_per_load=8,
                elbow_aim=1, load_ctrl=1, reward_div=75.0, receiver="cass", r_m4=1.3, g_orbit=4.0, zone_c=0.4,
                deck_h=4.0, beta_dev=0.0, beta_cap_z=7.6, cut_penalty=75.0, lost_deg=5.0, enc_clamp=6.0,
                sticky_k=2, wall="ifb", insulation=1, design_rand=1, design_seed=seed)


def ladder_day(e, S, day, hours=(9.0, 10.5, 12.0, 13.5, 15.0), draws=2):
    """Per-agent traced kW at perfect tracking for one day (all B designs at once)."""
    B = e.num_agents
    S.zero_noise = True
    S.day_v.fill_(float(day)); S.lat_v.fill_(30.2)
    decl = 23.44 * np.sin(2.0 * np.pi * (284.0 + day) / 365.0)
    S.decl_formed.fill_(decl); S.decl_now.fill_(decl)
    a = torch.full((B, e.N_HEADS), 3, dtype=torch.long, device=DEV); a[:, 0] = 4; a[:, 1] = 6; a[:, 2] = 6
    acc = torch.zeros(B, device=DEV)
    for h in hours:
        el, az, _ = solar_batch(torch.full((B,), 30.2), torch.full((B,), float(day)), float(h))
        for k in range(draws):
            S.el_m.copy_(el.to(DEV)); S.az_m.copy_(torch.rad2deg(az).to(DEV))
            S.e_el_prev.zero_(); S.e_az_prev.zero_(); S.lost_ct.zero_()
            e.t_solar[:] = h; e._gen.manual_seed(100003 * int(h * 10) + 7919 * k)
            with torch.no_grad():
                e.step_torch(a)
            acc += S.diag[:, 0]
    return (acc / (len(hours) * draws) / 1e3).cpu().numpy()


def run_day(e, pol, day, nh, nv):
    B = e.num_agents
    e.day = day; e.lat = 30.2
    with contextlib.redirect_stdout(io.StringIO()):
        e.reset(seed=1)
    e.day_v[:] = day; e.lat_v[:] = 30.2
    S = FusedState(e); e._gpu = S
    pol.reset(B); torch.manual_seed(1)
    a = torch.full((B, nh), 3, dtype=torch.long, device=DEV)
    o, r, d, tr, _ = e.step_torch(a)
    last = S.day_rotis.clone(); cuts = torch.zeros(B, device=DEV); v0 = None; ret = torch.zeros(B, device=DEV)
    with torch.no_grad():
        for t in range(2000):
            act, v = pol.step(o, nh, nv)
            if v0 is None: v0 = v.clone()
            o, r, d, tr, _ = e.step_torch(act)
            ret += r.reshape(-1); cuts += tr.reshape(-1).float()
            if d.reshape(-1).any(): break
            last = S.day_rotis.clone()
    return last.cpu().numpy(), cuts.cpu().numpy(), v0.cpu().numpy(), ret.cpu().numpy(), S


def regress(y, U, names):
    """standardized OLS: y ~ 1 + U; returns (coef per unit of the full box span, SE, R2)."""
    X = np.c_[np.ones(len(y)), U]
    beta, res, *_ = np.linalg.lstsq(X, y, rcond=None)
    yhat = X @ beta; r2 = 1 - ((y - yhat) ** 2).sum() / ((y - y.mean()) ** 2).sum()
    s2 = ((y - yhat) ** 2).sum() / max(len(y) - X.shape[1], 1)
    se = np.sqrt(np.diag(s2 * np.linalg.inv(X.T @ X)))
    return beta[1:], se[1:], r2


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt"); ap.add_argument("--agents", type=int, default=2048)
    ap.add_argument("--days", default="172,355"); ap.add_argument("--label", default="")
    ap.add_argument("--out", default="/private/tmp/claude-501/-Users-faezs-ARTIST/40abdad5-aefb-4c8a-a67b-a45db67e0f41/scratchpad/design_readout.json")
    args = ap.parse_args()
    B = args.agents
    sd = torch.load(args.ckpt, map_location="cpu", weights_only=False)
    pol = Policy(sd)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**env_kwargs(B))
    nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0])
    assert sd["policy.encoder.0.weight"].shape[1] == e.single_observation_space.shape[0], "obs dim mismatch: pad the checkpoint"
    BOX = tuple(e.DESIGN_BOX) + tuple(getattr(e, "SYS_BOX", ()))
    U = e._design_u.copy(); names = [k for k, _, _ in BOX]; lo = np.array([b[1] for b in BOX]); hi = np.array([b[2] for b in BOX])
    out = dict(ckpt=args.ckpt, label=args.label, names=names, U=U.tolist(), days={})
    t0 = time.time()
    for day in [int(x) for x in args.days.split(",")]:
        rot, cuts, v0, ret, S = run_day(e, pol, day, nh, nv)
        lad = ladder_day(e, S, day)
        lad = lad / e._ds_s2                      # per m2 of the nominal dish: the controller's use of the beam, not the dish size
        br, sr, r2r = regress(rot, U, names); bl, sl, r2l = regress(lad, U, names); bv, sv, r2v = regress(v0, U, names)
        cc = np.corrcoef(rot, lad)[0, 1]
        print(f"\nday {day} ({'summer' if day == 172 else 'winter' if day == 355 else 'equinox'}), {B} designs, sampled: rotis {rot.mean():.1f} +- {rot.std():.1f} (min {rot.min():.0f} max {rot.max():.0f}), cuts/agent {cuts.mean():.2f}, "
              f"ladder {lad.mean():.2f} +- {lad.std():.2f} kW, V0 {v0.mean():.2f} +- {v0.std():.2f}; corr(rotis, ladder) {cc:.2f}  [{time.time()-t0:.0f} s]")
        print(f"  {'design':12s} {'d rotis / box':>14s} {'d ladder kW / box':>18s} {'d V0 / box':>12s}   (effect of sweeping the whole box lo->hi, +- SE)")
        for i, n in enumerate(names):
            print(f"  {n:12s} {br[i]:+7.1f} +-{sr[i]:4.1f}    {bl[i]:+6.2f} +-{sl[i]:4.2f}      {bv[i]:+6.2f} +-{sv[i]:4.2f}")
        print(f"  R2: rotis {r2r:.2f}, ladder {r2l:.2f}, V0 {r2v:.2f}")
        top = np.argsort(-rot)[:5]; bot = np.argsort(rot)[:5]
        fmt = lambda b: ", ".join(f"{n}={lo[i] + U[b, i] * (hi[i] - lo[i]):.2f}" for i, n in enumerate(names))
        print("  top designs by rotis: " + " | ".join(f"{rot[b]:.0f} [{fmt(b)}]" for b in top[:3]))
        print("  worst designs by rotis: " + " | ".join(f"{rot[b]:.0f} [{fmt(b)}]" for b in bot[:3]))
        out["days"][day] = dict(rotis=rot.tolist(), cuts=cuts.tolist(), v0=v0.tolist(), ladder=lad.tolist(), ret=ret.tolist(),
                                coef_rotis=br.tolist(), se_rotis=sr.tolist(), coef_ladder=bl.tolist(), coef_v0=bv.tolist(), r2=[r2r, r2l, r2v], corr=cc)
    json.dump(out, open(args.out, "w"))

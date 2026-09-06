"""THE METAPROGRAMMER (user): co-design as a learned designer rather than a
uniform box. AlphaZero-shaped: a small network is the PRIOR over kits
given the site, the cook's critic is the cheap leaf VALUE, real batched
rollouts of the cook score the few best candidates, and the designer is
regressed toward what the search actually chose. The cook, in turn,
trains on the designer's population (env kwarg design_pop=<json>: at
each dawn a share of the agents redraw their kit from the designer's
distribution for their site, the elites keep theirs).

    python tandoor_designer.py CKPT.pt --gens 4 --out design_pop.json

Site = (roof percentile, pit wall thickness, shop demand), the SITE_KEYS
of the box; kit = the other N_DESIGN - 3 coordinates. Everything lives in
the unit box; the designer's Gaussian is on logits so the box is respected.
"""
import argparse, contextlib, io, json, math, sys, time
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_design_readout import Policy, env_kwargs, DEV
import tandoor_system_cost as C

BOX = tuple(TandoorHashemiEnv.DESIGN_BOX) + tuple(TandoorHashemiEnv.SYS_BOX)
NAMES = [k for k, _, _ in BOX]
SITE = list(TandoorHashemiEnv.SITE_KEYS)
I_SITE = [NAMES.index(k) for k in SITE]
I_KIT = [i for i in range(len(NAMES)) if i not in I_SITE]
ND, NK = len(NAMES), len(I_KIT)


def logit(u): u = np.clip(u, 1e-4, 1 - 1e-4); return np.log(u / (1 - u))
def sigmoid(x): return 1 / (1 + np.exp(-x))


class Designer(torch.nn.Module):
    """site (3) -> Gaussian over the kit's NK logits."""
    def __init__(self, h=64):
        super().__init__()
        self.net = torch.nn.Sequential(torch.nn.Linear(len(SITE), h), torch.nn.Tanh(), torch.nn.Linear(h, h), torch.nn.Tanh(), torch.nn.Linear(h, 2 * NK))
        with torch.no_grad():
            self.net[-1].weight.mul_(0.1); self.net[-1].bias.zero_(); self.net[-1].bias[NK:] = math.log(1.2)   # start near uniform in the box
    def forward(self, site):
        o = self.net(site); return o[:, :NK], o[:, NK:].clamp(-3.0, 1.5)     # mean, log std (logit space)
    def sample(self, site, n):
        mu, ls = self.forward(site.expand(n, -1)); z = mu + ls.exp() * torch.randn_like(mu); return z
    def logp(self, site, z):
        mu, ls = self.forward(site); return (-0.5 * ((z - mu) / ls.exp()) ** 2 - ls).sum(1)


def kits_to_u(site_u, z):
    """site_u (3,), z (n, NK) logits -> u (n, ND)"""
    u = np.zeros((z.shape[0], ND)); u[:, I_SITE] = site_u[None]; u[:, I_KIT] = sigmoid(z); return u


class Sim:
    def __init__(self, ckpt, B, seasoned):
        self.pol = Policy(torch.load(ckpt, map_location="cpu", weights_only=False))
        kw = env_kwargs(B, night_carry=int(seasoned > 1)); kw.update(dict(design_rand=1, day_start=6.0, day_end=21.5, demand=1, demand_day=500.0))
        with contextlib.redirect_stdout(io.StringIO()):
            self.e = TandoorHashemiEnv(**kw)
        self.B, self.seasoned = B, seasoned; self.nh, self.nv = self.e.N_HEADS, int(self.e.single_action_space.nvec[0]); self.calls = 0
    def dawn_value(self, u):
        """the critic's dawn value of B machines (one forward pass, no rollout)."""
        e = self.e; e.set_design_points(u); e.day = 172; e.lat = 30.2
        with contextlib.redirect_stdout(io.StringIO()):
            e.reset(seed=7)
        e.day_v[:] = 172; e.lat_v[:] = 30.2; S = FusedState(e); e._gpu = S; self.pol.reset(self.B)
        a = torch.full((self.B, self.nh), 3, dtype=torch.long, device=DEV); o, *_ = e.step_torch(a)
        with torch.no_grad():
            _, v = self.pol.step(o, self.nh, self.nv)
        return v.cpu().numpy()
    def rollout(self, u, day=172):
        """sold rotis on the last of `seasoned` days for B machines."""
        e = self.e; e.set_design_points(u); e.day = day; e.lat = 30.2
        with contextlib.redirect_stdout(io.StringIO()):
            e.reset(seed=1 + self.calls)
        e.day_v[:] = day; e.lat_v[:] = 30.2; S = FusedState(e); e._gpu = S; self.pol.reset(self.B); torch.manual_seed(1 + self.calls)
        a = torch.full((self.B, self.nh), 3, dtype=torch.long, device=DEV); o, *_ = e.step_torch(a); last = S.day_rotis.clone(); days = 0
        with torch.no_grad():
            for t in range(4000 * self.seasoned):
                act, _ = self.pol.step(o, self.nh, self.nv); o, r, d, tr, _ = e.step_torch(act)
                if d.reshape(-1).any():
                    days += 1
                    if days >= self.seasoned: break
                    continue
                last = S.day_rotis.clone()
        self.calls += 1
        return last.cpu().numpy()


def priced(sim, u, sold, budget):
    """the search's objective: sold rotis, one off per 50 PKR over the budget."""
    e = sim.e; cap = []
    rows = e._rows_from_u(np.asarray(u, dtype=np.float64))          # the design table's own derivation: scale, film, rim, rise, site
    for b in range(u.shape[0]):
        d = {k: float(lo + u[b, i] * (hi - lo)) for i, (k, lo, hi) in enumerate(BOX)}
        d["roof_r"] = float(e._roof_quantile(d["roof_r"]))
        d["dish_scale"] = float(rows[b, e.DS["s"]]); d["site"] = float(rows[b, e.DS["site"]]); d["film_m2"] = float(rows[b, e.DS["film"]])
        d["rim_m"] = float(rows[b, e.DS["rim"]]); d["rise"] = float(rows[b, e.DS["rise"]])
        cap.append(C.capital(d)["total"])
    cap = np.array(cap); return sold - 0.02 * np.maximum(cap - budget, 0.0), cap


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt"); ap.add_argument("--gens", type=int, default=4); ap.add_argument("--cand", type=int, default=512)
    ap.add_argument("--top", type=int, default=64); ap.add_argument("--seasoned", type=int, default=2); ap.add_argument("--budget", type=float, default=100000.0)
    ap.add_argument("--sites", default="0.25,0.5,0.75"); ap.add_argument("--out", default="/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/design_pop.json")
    ap.add_argument("--load", default=None)
    ap.add_argument("--over-cap", type=float, default=0.5, help="site: the overhang the neighbours accept, as the box coordinate (thirds: 1.0 / 2.0 / 3.5 m)")
    args = ap.parse_args()
    torch.manual_seed(0); np.random.seed(0)
    des = Designer().to(DEV)
    if args.load: des.load_state_dict(torch.load(args.load, map_location=DEV))
    opt = torch.optim.Adam(des.parameters(), lr=3e-3)
    sim = Sim(args.ckpt, B=args.cand, seasoned=args.seasoned)
    sites = [(float(r), 0.375, 1 / 3, args.over_cap) for r in args.sites.split(",")]      # roof percentile, nominal pit, nominal shop, the neighbours' tolerance
    pop = {"names": NAMES, "site_keys": SITE, "kit_index": I_KIT, "sites": {}}
    t0 = time.time()
    for g in range(args.gens):
        for su in sites:
            st = torch.tensor(su, dtype=torch.float32, device=DEV)[None]
            # 1. the prior proposes candidates, 2. the critic ranks them cheaply
            with torch.no_grad(): z = des.sample(st, args.cand)
            u = kits_to_u(np.array(su), z.cpu().numpy()); v0 = sim.dawn_value(u)
            _, cap0 = priced(sim, u, np.zeros(u.shape[0]), args.budget)
            within = cap0 <= args.budget
            if within.sum() < args.top:                                # not enough affordable kits: take the cheapest over-budget ones too
                within = np.argsort(cap0) [:args.top]; mask = np.zeros(u.shape[0], bool); mask[within] = True; within = mask
            v0m = np.where(within, v0, -1e9)
            keep = np.argsort(-v0m)[:args.top]                         # the critic's shortlist, within the budget
            # 3. the real rollout of the shortlist (batched: the shortlist tiled to B)
            reps = int(np.ceil(args.cand / len(keep))); uu = np.tile(u[keep], (reps, 1))[:args.cand]
            sold = sim.rollout(uu); score, cap = priced(sim, uu, sold, args.budget)
            sc = np.zeros(len(keep)); cp = np.zeros(len(keep))
            for j in range(len(keep)): sel = np.arange(j, args.cand, len(keep)); sc[j] = score[sel].mean(); cp[j] = cap[sel].mean()
            # 4. the designer moves toward the search's winners (weighted max-likelihood)
            w = np.exp((sc - sc.max()) / max(sc.std(), 1.0)); w /= w.sum()
            zk = z[keep]; wt = torch.tensor(w, dtype=torch.float32, device=DEV)
            for _ in range(20):
                loss = -(wt * des.logp(st.expand(len(keep), -1), zk)).sum(); opt.zero_grad(); loss.backward(); opt.step()
            best = int(np.argmax(sc))
            with torch.no_grad(): mu, ls = des.forward(st)
            kit = {NAMES[i]: float(lo + u[keep[best], i] * (hi - lo)) for i, (k, lo, hi) in enumerate(BOX)}
            pop["sites"][f"{su[0]:.2f}"] = dict(site_u=list(su), mu=mu[0].detach().cpu().numpy().tolist(), log_std=ls[0].detach().cpu().numpy().tolist(),
                                              elite_u=u[keep[np.argsort(-sc)[:8]]].tolist(), best_score=float(sc[best]), best_capital=float(cp[best]))
            print(f"gen {g} site p{su[0]*100:.0f}: {int((cap0 <= args.budget).sum())}/{args.cand} proposals within budget, shortlist {len(keep)}, rollout best {sc[best]:.0f} sold-rotis at {cp[best]/1e3:.0f}k (mean of shortlist {sc.mean():.0f}); "
                  f"prior std now {float(ls.exp().mean()):.2f}; best kit: " + ", ".join(f"{k}={kit[k]:.2f}" for k in ("deck_h", "mount_post", "rate_scale", "ins_scale", "sand_depth", "r_bore", "r_m4", "bread_area")) + f"  [{time.time()-t0:.0f} s]", flush=True)
        json.dump(pop, open(args.out, "w"), indent=1); torch.save(des.state_dict(), args.out.replace(".json", ".pt"))
    print("designer population written to", args.out)

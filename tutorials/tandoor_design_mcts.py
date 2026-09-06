"""Monte Carlo tree search over the design, with the batched simulator as
the rollout: no surrogate, no critic - every expansion evaluates the
children of a partial design by simulating hundreds of random
completions of each in ONE GPU rollout, the trained cook driving every
machine. The site (roof percentile) is the root; the parameters are
assigned one at a time in thirds of their box (progressive refinement
is the obvious next step); the leaf score of a child is the mean of its
best-quartile completions (an optimistic backup, since we are looking
for the best machine, not the average one); UCB selects the path.

    python tandoor_design_mcts.py CKPT.pt [--site 0.5] [--sims 20] [--k 256] [--day 172] [--seasoned 1]
"""
import argparse, contextlib, io, json, math, sys, time
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_design_readout import Policy, env_kwargs, DEV
import tandoor_system_cost as C

ORDER = ["mount_post", "deck_h", "ins_scale", "bread_area", "cap_scale", "rate_scale", "d_strip", "r_bore", "r_m4",
         "w_slot", "strip_th_hi", "strip_wk", "r_hole", "u_f2", "r_duct", "lid_leak", "loaves_per_load"]
NBIN = 3


class Node:
    __slots__ = ("path", "N", "W", "children", "best")
    def __init__(self, path):
        self.path = path            # tuple of (param index in ORDER, bin)
        self.N = 0; self.W = 0.0; self.children = {}; self.best = (-1.0, None)


class Sim:
    """The batched rollout: B machines, one pinned day (or the last of a
    seasoned run of days), the trained policy sampled; returns rotis (B,)."""
    def __init__(self, ckpt, B, day, seasoned):
        self.pol = Policy(torch.load(ckpt, map_location="cpu", weights_only=False))
        with contextlib.redirect_stdout(io.StringIO()):
            self.e = TandoorHashemiEnv(**env_kwargs(B, night_carry=int(seasoned > 1)))
        self.B, self.day, self.seasoned = B, day, seasoned
        e = self.e
        self.names = [k for k, _, _ in tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX)]
        self.nh, self.nv = e.N_HEADS, int(e.single_action_space.nvec[0])
        self.calls = 0

    def run(self, u):
        e = self.e; B = self.B
        e.set_design_points(u)
        e.day = self.day; e.lat = 30.2
        with contextlib.redirect_stdout(io.StringIO()):
            e.reset(seed=1 + self.calls)
        e.day_v[:] = self.day; e.lat_v[:] = 30.2
        S = FusedState(e); e._gpu = S; self.pol.reset(B); torch.manual_seed(1 + self.calls)
        a = torch.full((B, self.nh), 3, dtype=torch.long, device=DEV)
        o, *_ = e.step_torch(a); last = S.day_rotis.clone(); days = 0
        with torch.no_grad():
            for t in range(2000 * self.seasoned):
                act, _ = self.pol.step(o, self.nh, self.nv)
                o, r, d, tr, _ = e.step_torch(act)
                if d.reshape(-1).any():
                    days += 1
                    if days >= self.seasoned: break
                    continue
                last = S.day_rotis.clone()
        self.calls += 1
        return last.cpu().numpy()


def completions(rng, sim, node, site, k):
    """k unit-box designs consistent with the node's partial assignment."""
    nd = len(sim.names); u = rng.uniform(size=(k, nd))
    u[:, sim.names.index("roof_r")] = site
    for pi, b in node.path:
        j = sim.names.index(ORDER[pi]); u[:, j] = (b + rng.uniform(size=k)) / NBIN
    return u


def score(x):
    """The child's score: the mean of its best quartile (optimistic backup)."""
    q = np.quantile(x, 0.75)
    return float(x[x >= q].mean()) if (x >= q).any() else float(x.mean())


def designs_of(sim, u):
    """Unit-box rows -> design dicts with roof_r in metres and the derived dish."""
    e = sim.e; box = tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX); out = []
    for b in range(u.shape[0]):
        d = {k: float(lo + u[b, i] * (hi - lo)) for i, (k, lo, hi) in enumerate(box)}
        d["roof_r"] = float(e._roof_quantile(d["roof_r"])); d["dish_scale"] = float(e.roof_to_scale(d["roof_r"], d["deck_h"], d.get("mount_post", 0.0) >= 0.5))
        out.append(d)
    return out


def objective(sim, u, rot, args):
    """rotis, or the priced value: rotis x bread x PKR x days x years - capital [PKR]."""
    if not args.priced:
        return rot
    D = designs_of(sim, u)
    cap = np.array([C.capital(d)["total"] for d in D]); area = np.array([d["bread_area"] for d in D])
    return rot * (area / 0.12) * args.roti_pkr * args.days * args.years - cap


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt"); ap.add_argument("--site", type=float, default=0.5)
    ap.add_argument("--sims", type=int, default=20); ap.add_argument("--k", type=int, default=256)
    ap.add_argument("--day", type=int, default=172); ap.add_argument("--seasoned", type=int, default=1)
    ap.add_argument("--c", type=float, default=0.6); ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--priced", action="store_true", help="optimize value = rotis x bread x PKR x days x years - capital")
    ap.add_argument("--roti-pkr", type=float, default=8.0); ap.add_argument("--days", type=float, default=300.0); ap.add_argument("--years", type=float, default=5.0)
    ap.add_argument("--out", default="/private/tmp/claude-501/-Users-faezs-ARTIST/40abdad5-aefb-4c8a-a67b-a45db67e0f41/scratchpad/design_mcts.json")
    args = ap.parse_args()
    rng = np.random.default_rng(args.seed)
    sim = Sim(args.ckpt, NBIN * args.k, args.day, args.seasoned)
    roof_m = float(sim.e._roof_quantile(args.site))
    print(f"MCTS over the design: site p{args.site*100:.0f} (roof half-width {roof_m:.1f} m), day {args.day}{' seasoned %d' % args.seasoned if args.seasoned > 1 else ' cold'}, "
          f"{args.sims} simulations x {NBIN} children x {args.k} completions", flush=True)
    root = Node(()); gbest = (-1e18, None, 0.0); t0 = time.time(); scale = 100.0
    unit = 1e3 if args.priced else 1.0; lab = "k PKR" if args.priced else "rotis"
    print(f"  objective: {'VALUE over %.0f years at %.0f PKR/roti, %.0f days/yr, minus capital' % (args.years, args.roti_pkr, args.days) if args.priced else 'rotis on the last day'}", flush=True)
    # simulation 0: the root itself = the uniform baseline (3k designs)
    u0 = completions(rng, sim, root, args.site, NBIN * args.k); rot0 = sim.run(u0); r0 = objective(sim, u0, rot0, args)
    root.N = 1; root.W = score(r0); j = int(r0.argmax()); gbest = (float(r0[j]), u0[j], float(rot0[j])); scale = float(r0.std()) + 1e-6
    print(f"  sim 0 (uniform, {len(r0)} designs): mean {r0.mean()/unit:.0f}, best-quartile mean {score(r0)/unit:.0f}, best {r0.max()/unit:.0f} {lab}  [{time.time()-t0:.0f} s]", flush=True)
    for s_ in range(1, args.sims + 1):
        # select: down the tree by UCB until a node with unexpanded children (or a leaf at full depth)
        node = root; path = [root]
        while len(node.path) < len(ORDER) and len(node.children) == NBIN:
            lnN = math.log(max(node.N, 1))
            node = max(node.children.values(), key=lambda ch: ch.W / max(ch.N, 1) / scale + args.c * math.sqrt(lnN / max(ch.N, 1)))
            path.append(node)
        if len(node.path) == len(ORDER):
            u = completions(rng, sim, node, args.site, NBIN * args.k); rot = sim.run(u); r = objective(sim, u, rot, args); sc = score(r)
            for n_ in path: n_.N += 1; n_.W += sc
            kids = []
        else:
            # expand all children of this node in one rollout
            pi = len(node.path); kids = [Node(node.path + ((pi, b),)) for b in range(NBIN)]
            u = np.concatenate([completions(rng, sim, ch, args.site, args.k) for ch in kids]); rot = sim.run(u); r = objective(sim, u, rot, args)
            for ci, ch in enumerate(kids):
                rc = r[ci * args.k:(ci + 1) * args.k]; sc = score(rc); ch.N = 1; ch.W = sc
                jj = int(rc.argmax()); ch.best = (float(rc[jj]), u[ci * args.k + jj])
                node.children[ch.path[-1][1]] = ch
            best_sc = max(ch.W for ch in kids)
            for n_ in path: n_.N += 1; n_.W += best_sc      # the parent inherits its best child's estimate
        j = int(r.argmax())
        if r[j] > gbest[0]: gbest = (float(r[j]), u[j], float(rot[j]))
        desc = " > ".join(f"{ORDER[pi]}:{['lo','mid','hi'][b]}" for pi, b in node.path) or "root"
        kid_s = ", ".join(f"{['lo','mid','hi'][ch.path[-1][1]]} {ch.W/unit:.0f}" for ch in kids) if kids else "leaf re-eval"
        print(f"  sim {s_:2d}: expand [{desc}] -> {ORDER[len(node.path)] if kids else ''} {kid_s}; batch mean {r.mean()/unit:.0f}, best so far {gbest[0]/unit:.0f} {lab}  [{time.time()-t0:.0f} s]", flush=True)
    # report: the greedy path by mean value, and the best single design seen
    node = root; greedy = []
    while node.children:
        b, ch = max(node.children.items(), key=lambda kv: kv[1].W / max(kv[1].N, 1)); greedy.append((ORDER[len(node.path)], ["lo", "mid", "hi"][b], ch.W / max(ch.N, 1), ch.N)); node = ch
    print("\ngreedy path (parameter: third, estimated best-quartile rotis, visits):")
    for nm, b, v, n in greedy: print(f"  {nm:16s} {b:4s} {v/unit:7.0f} {lab}  n={n}")
    e = sim.e; box = tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX)
    bu = gbest[1]; d = {k: float(lo + bu[i] * (hi - lo)) for i, (k, lo, hi) in enumerate(box)}
    d["roof_r"] = roof_m; d["dish_scale"] = float(e.roof_to_scale(roof_m, d["deck_h"], d.get("mount_post", 0.0) >= 0.5))
    cap = C.capital(d)["total"]
    print(f"\nbest single design: {gbest[2]:.0f} rotis (day {args.day}{', seasoned day %d' % args.seasoned if args.seasoned > 1 else ''}), capital {cap/1e3:.0f}k PKR"
          + (f", VALUE {gbest[0]/1e3:.0f}k PKR over {args.years:.0f} y" if args.priced else "") + ": " + ", ".join(f"{k}={v:.2f}" for k, v in d.items()))
    print(f"evaluated {sim.calls * NBIN * args.k} machines in {time.time()-t0:.0f} s")
    json.dump(dict(site=args.site, roof_m=roof_m, day=args.day, seasoned=args.seasoned, priced=args.priced, best_score=gbest[0], best_rotis=gbest[2], best_u=bu.tolist(), best_design=d, capital=cap, greedy=greedy, sims=args.sims, k=args.k), open(args.out, "w"), indent=1)

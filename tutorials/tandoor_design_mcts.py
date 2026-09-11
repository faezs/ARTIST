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

#: THE ORDER IS THE SEARCH.  The tree assigns one parameter per level, so
#: whatever sits at the front gets the visits and whatever sits at the back is
#: decided after everything else is frozen.  The FRAMING goes first - which
#: slice of the parent sphere the roof allows and how tall the post has to be
#: to make it legal - because every other knob is chosen against that shape.
#: (Until 2026-09-08 section and post_rise were LAST, at depth 19 and 20: the
#: search never reached them and the run could not answer "what does a small
#: roof want".)
ORDER = ["receiver",                                                          # WHICH MACHINE: the elbow at the pot inlet, or M3 thrown at the loaf
         "section", "post_rise", "deck_h", "mount_post",                       # the framing: the roof decides the machine
         "d_strip", "r_bore", "r_m4", "u_f2", "r_duct",                        # the receiver on the bore
         "strip_wk", "strip_th_hi", "w_slot", "r_hole",                        # the strip and the deck
         "ins_scale", "sand_depth", "sand_k", "lid_leak",                      # the pit
         "bread_area", "loaves_per_load", "rate_scale"]                        # the shop and its actuators
#: the site's pit (1.0x wall) and shop (1.0x demand), and what the NEIGHBOURS
#: accept over their heads - a site condition, not a design choice, so it is
#: pinned per run (--over-cap) instead of drawn: the overhang cap is exactly
#: what decides whether tallness buys a bigger section.
SITE_U = {"cap_scale": 0.375, "demand_scale": 1.0 / 3.0, **TandoorHashemiEnv.site_nominal_u()}   # the site is given, not searched
NBIN = 3
#: A KNOB THAT IS A SWITCH GETS TWO BINS, NOT THREE.  'section' and 'mount_post'
#: are read by the env as booleans (sv["section"] >= 0.5 picks the section of the
#: parent over the scaled circle; sv["mount_post"] >= 0.5 picks the post over the
#: ring rail), so splitting them in thirds put the MIDDLE third across the
#: threshold: that child was a mixture of both machines, its score meant nothing,
#: and on the first reordered run it was the one the greedy path chose (2026-09-08).
#: The label tuple's length IS the bin count.  Knobs that really are three-way
#: (over_cap's 1.0/2.0/3.5 m, m4_facet's smooth/faceted/flat) keep their thirds.
BIN_LAB = {"section": ("circle", "section"), "mount_post": ("rail", "post"),
           "receiver": ("cass", "tri")}
DEF_LAB = ("lo", "mid", "hi")


def nbin_of(name):
    return len(BIN_LAB[name]) if name in BIN_LAB else NBIN


def blab(name, b):
    return BIN_LAB.get(name, DEF_LAB)[b]


class Node:
    __slots__ = ("path", "N", "W", "children", "best")
    def __init__(self, path):
        self.path = path            # tuple of (param index in ORDER, bin)
        self.N = 0; self.W = 0.0; self.children = {}; self.best = (-1.0, None)


class Sim:
    """The batched rollout: B machines, one pinned day (or the last of a
    seasoned run of days), the trained policy sampled; returns rotis (B,)."""
    def __init__(self, ckpt, B, day, seasoned, shell="perlite"):
        self.pol = Policy(torch.load(ckpt, map_location="cpu", weights_only=False))
        with contextlib.redirect_stdout(io.StringIO()):
            self.e = TandoorHashemiEnv(**env_kwargs(B, night_carry=int(seasoned > 1), shell=shell))
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
            for t in range(4000 * self.seasoned):
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
    for kname, uv in SITE_U.items():
        if kname in sim.names: u[:, sim.names.index(kname)] = uv
    for pi, b in node.path:
        j = sim.names.index(ORDER[pi]); u[:, j] = (b + rng.uniform(size=k)) / nbin_of(ORDER[pi])
    return u


def score(x):
    """The child's score: the mean of its best quartile (optimistic backup)."""
    q = np.quantile(x, 0.75)
    return float(x[x >= q].mean()) if (x >= q).any() else float(x.mean())


def designs_of(sim, u):
    """The designs AS BUILT, read back off the env's design table (design_points())
    rather than re-derived from the unit box.

    The box and the bill speak DIFFERENT VOCABULARIES and this function used to
    hand the first to the second: the box has 'section', 'zones' as a 0..1
    coordinate, 'm4_facet', 'roof_light'; tandoor_bom.bom() wants 'site',
    'film_m2', 'rim_m', 'rise', 'zones' as a COUNT, 'm4flat'/'m4chord', 'roofl',
    'tri'.  None of those were being set, so every lever silently took its
    default and - worst of it - a SECTION machine was priced as the scaled
    circle its dish_scale described: the trace installed the parent's film
    (25.5 m2 on a 1.69 m roof) while the bill charged for pi*a^2 at
    dish_scale 0.45, i.e. 2.8 m2, with the mount, tower and motors sized to
    match.  design_points() reads self._fct after _apply_system_design, so it
    reports the machine that was actually built (2026-09-08)."""
    D = sim.e.design_points()
    B = u.shape[0]
    def _one(v, b):
        if isinstance(v, str):
            return v                                   # e.g. shell_name: the bill reads it as a name
        return float(v[b]) if np.ndim(v) else float(v)
    return [{k: _one(v, b) for k, v in D.items()} for b in range(B)]


def objective(sim, u, rot, args):
    """--value (the default): PKR of NET VALUE over the horizon, the same
    objective tandoor_design_value_opt maximizes - bread-weighted rotis at the
    shop's price times days times years, minus the kit.  Capital is then priced
    against bread at 12,000 PKR per roti/day instead of thrown at a cliff.

    The cliff it replaces (rotis minus 1 per 50 PKR over --budget) is only
    meaningful for a REACHABLE budget.  Against the default 100k it was not:
    the researched bill floors near 335k, so every design lost 8,000+ rotis to
    the penalty, the bread term was noise on top of it, and the tree was
    ranking machines purely by cheapness (2026-09-08)."""
    D = designs_of(sim, u); sim.last_D = D
    cap = np.array([C.capital(d)["total"] for d in D]); area = np.array([d["bread_area"] for d in D])
    if args.value:
        return rot * (area / 0.12) * args.roti_pkr * args.days * args.years - cap
    score = rot * (area / 0.12) if args.priced else rot
    return score - 0.02 * np.maximum(cap - args.budget, 0.0)


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt"); ap.add_argument("--site", type=float, default=0.5)
    ap.add_argument("--sims", type=int, default=20); ap.add_argument("--k", type=int, default=256)
    ap.add_argument("--day", type=int, default=172); ap.add_argument("--seasoned", type=int, default=1)
    ap.add_argument("--c", type=float, default=0.6); ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--shell", default="perlite", choices=("perlite", "glasswool", "aac"),
                    help="what the pit's insulating annulus is made of: ins_scale stays the knob, the material sets the thickness, mass and price it costs (tandoor_rl_env.SHELL_MATERIALS)")
    ap.add_argument("--over-cap", type=float, default=0.5, dest="over_cap",
                    help="how far past the parapet the neighbours accept the rim, as a unit-box coordinate (thirds: 1.0 / 2.0 / 3.5 m); pinned for the run")
    ap.add_argument("--priced", action="store_true", help="bread-weighted rotis (roti area / 0.12)")
    ap.add_argument("--budget-cliff", action="store_false", dest="value",
                    help="rank by rotis with a hard price cap instead of net value (only meaningful for a REACHABLE --budget)")
    ap.add_argument("--budget", type=float, default=C.BUDGET, help="the kit's price cap [PKR]; over-budget designs are penalised")
    ap.add_argument("--roti-pkr", type=float, default=8.0); ap.add_argument("--days", type=float, default=300.0); ap.add_argument("--years", type=float, default=5.0)
    ap.add_argument("--out", default="/private/tmp/claude-501/-Users-faezs-ARTIST/40abdad5-aefb-4c8a-a67b-a45db67e0f41/scratchpad/design_mcts.json")
    args = ap.parse_args()
    rng = np.random.default_rng(args.seed)
    SITE_U["over_cap"] = float(args.over_cap)      # pin the neighbours' tolerance with the rest of the site
    for _nm in ORDER:
        assert (NBIN * args.k) % nbin_of(_nm) == 0, f"--k {args.k}: {NBIN*args.k} agents do not split {nbin_of(_nm)} ways for {_nm}"
    sim = Sim(args.ckpt, NBIN * args.k, args.day, args.seasoned, shell=args.shell)
    roof_m = float(sim.e._roof_quantile(args.site))
    print(f"MCTS over the design: site p{args.site*100:.0f} (roof half-width {roof_m:.1f} m), day {args.day}{' seasoned %d' % args.seasoned if args.seasoned > 1 else ' cold'}, "
          f"{args.sims} simulations x {NBIN} children x {args.k} completions", flush=True)
    root = Node(()); gbest = (-1e18, None, 0.0); t0 = time.time(); scale = 100.0
    unit, lab = (1e3, "k PKR net") if args.value else (1.0, "bread-rotis" if args.priced else "rotis")
    obj_s = (f"NET VALUE [PKR]: bread-weighted rotis x {args.roti_pkr:.0f} PKR x {args.days:.0f} days x {args.years:.0f} yr, minus the kit"
             if args.value else
             f"{'bread-weighted rotis' if args.priced else 'rotis'} on the last day, kit within {args.budget/1e3:.0f}k PKR (1 roti per 50 PKR over)")
    print(f"  objective: {obj_s}; site: {', '.join(f'{k} u={v}' for k, v in SITE_U.items())}", flush=True)
    # simulation 0: the root itself = the uniform baseline (3k designs)
    u0 = completions(rng, sim, root, args.site, NBIN * args.k); rot0 = sim.run(u0); r0 = objective(sim, u0, rot0, args)
    root.N = 1; root.W = score(r0); j = int(r0.argmax()); gbest = (float(r0[j]), u0[j], float(rot0[j]), sim.last_D[j]); scale = float(r0.std()) + 1e-6
    print(f"  sim 0 (uniform, {len(r0)} designs): mean {r0.mean()/unit:.0f}, best-quartile mean {score(r0)/unit:.0f}, best {r0.max()/unit:.0f} {lab}  [{time.time()-t0:.0f} s]", flush=True)
    for s_ in range(1, args.sims + 1):
        # select: down the tree by UCB until a node with unexpanded children (or a leaf at full depth)
        node = root; path = [root]
        while len(node.path) < len(ORDER) and len(node.children) == nbin_of(ORDER[len(node.path)]):
            lnN = math.log(max(node.N, 1))
            node = max(node.children.values(), key=lambda ch: ch.W / max(ch.N, 1) / scale + args.c * math.sqrt(lnN / max(ch.N, 1)))
            path.append(node)
        if len(node.path) == len(ORDER):
            u = completions(rng, sim, node, args.site, NBIN * args.k); rot = sim.run(u); r = objective(sim, u, rot, args); sc = score(r)
            for n_ in path: n_.N += 1; n_.W += sc
            kids = []
        else:
            # expand all children of this node in one rollout
            # the rollout batch is FIXED at NBIN*k agents (the env is built once), so a
            # two-bin knob splits the same batch two ways: 1.5x the completions per child.
            pi = len(node.path); nb = nbin_of(ORDER[pi]); kk = (NBIN * args.k) // nb
            kids = [Node(node.path + ((pi, b),)) for b in range(nb)]
            u = np.concatenate([completions(rng, sim, ch, args.site, kk) for ch in kids]); rot = sim.run(u); r = objective(sim, u, rot, args)
            for ci, ch in enumerate(kids):
                rc = r[ci * kk:(ci + 1) * kk]; sc = score(rc); ch.N = 1; ch.W = sc
                jj = int(rc.argmax()); ch.best = (float(rc[jj]), u[ci * kk + jj])
                node.children[ch.path[-1][1]] = ch
            best_sc = max(ch.W for ch in kids)
            for n_ in path: n_.N += 1; n_.W += best_sc      # the parent inherits its best child's estimate
        j = int(r.argmax())
        if r[j] > gbest[0]: gbest = (float(r[j]), u[j], float(rot[j]), sim.last_D[j])
        desc = " > ".join(f"{ORDER[pi]}:{blab(ORDER[pi], b)}" for pi, b in node.path) or "root"
        kid_s = ", ".join(f"{blab(ORDER[len(ch.path)-1], ch.path[-1][1])} {ch.W/unit:.0f}" for ch in kids) if kids else "leaf re-eval"
        print(f"  sim {s_:2d}: expand [{desc}] -> {ORDER[len(node.path)] if kids else ''} {kid_s}; batch mean {r.mean()/unit:.0f}, best so far {gbest[0]/unit:.0f} {lab}  [{time.time()-t0:.0f} s]", flush=True)
    # report: the greedy path by mean value, and the best single design seen
    node = root; greedy = []
    while node.children:
        nm_ = ORDER[len(node.path)]
        b, ch = max(node.children.items(), key=lambda kv: kv[1].W / max(kv[1].N, 1)); greedy.append((nm_, blab(nm_, b), ch.W / max(ch.N, 1), ch.N)); node = ch
    print("\ngreedy path (parameter: bin, estimated best-quartile value, visits):")
    for nm, b, v, n in greedy: print(f"  {nm:16s} {b:8s} {v/unit:7.0f} {lab}  n={n}")
    bu = gbest[1]; d = gbest[3]          # the machine as built, not re-derived from the box
    cap = C.capital(d)["total"]
    print(f"\n  (as built: {'SECTION' if d.get('site',0) >= 0.5 else 'circle'}, film {d.get('film_m2',0):.1f} m2, "
          f"dish_scale {d.get('dish_scale',1):.2f}, rise {d.get('rise',0):.1f} m, "
          f"{int(d.get('zones',5) or 5)} plenum zone(s), {'tri' if d.get('tri',0) >= 0.5 else 'cass'})")
    print(f"\nbest single design: {gbest[2]:.0f} rotis (day {args.day}{', seasoned day %d' % args.seasoned if args.seasoned > 1 else ''}), kit {cap/1e3:.0f}k PKR"
          + f" ({'within' if cap <= args.budget else 'OVER'} the {args.budget/1e3:.0f}k budget): " + ", ".join((f"{k}={v}" if isinstance(v, str) else f"{k}={v:.2f}") for k, v in d.items()))
    print("bill of materials:\n" + C.bom_text(d, args.budget))
    print(f"evaluated {sim.calls * NBIN * args.k} machines in {time.time()-t0:.0f} s")
    json.dump(dict(site=args.site, roof_m=roof_m, day=args.day, seasoned=args.seasoned, priced=args.priced, best_score=gbest[0], best_rotis=gbest[2], best_u=bu.tolist(), best_design=d, capital=cap, greedy=greedy, sims=args.sims, k=args.k), open(args.out, "w"), indent=1)

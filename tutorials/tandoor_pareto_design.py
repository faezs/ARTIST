"""THE DESIGN RUN READ AS A PARETO OPTIMIZATION (tandoor_resources, 2026-09-17).

Rolls a checkpoint over the design population for one day at the site pool - every agent a
machine, a site, a recorded day - and reads the run the way Marcolli reads it: each machine's
day is a SUMMING FUNCTOR over its events into the resource category, valued by (F, X), and the
run's answer is the FRONTIER, not a best. Then the two scalarizations the project already uses
(payback, the RL reward) are shown picking their frontier points, and the swarm step the design
run's dawn would take is shown without being taken.

    PYTHONPATH=..:.:puffer_tandoor puffer_tandoor/.venv/bin/python tandoor_pareto_design.py \\
        [--ckpt CKPT] [--day 173] [--B 64] [--budget 700000] [--goal-rotis 0] [--goal-track 1] \\
        [--out data/tandoor/pareto_design.json] [--lean-check]
"""
import argparse, contextlib, io, json, os, sys
import numpy as np, torch

sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
import tandoor_resources as R
from tandoor_frontier import Ledger

CKPT = "/Users/faezs/ARTIST/tutorials/puffer_tandoor/experiments/178926893901/model_000573.pt"
INI = "/Users/faezs/ARTIST/tutorials/puffer_tandoor/hashemi_design.ini"


def build(B, day, seed):
    import configparser
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_fused_step import FusedState
    cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#")); cp.read(INI)
    kw = {}
    for k, v in cp["env"].items():
        v = v.strip()
        try: kw[k] = int(v)
        except ValueError:
            try: kw[k] = float(v)
            except ValueError: kw[k] = v
    kw.update(num_agents=B, n_rays=256, seed=seed, day_of_year=day, day_random=0, site_days=0)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=seed)
    e.day_v[:] = day; e._sw_refresh()
    e._gpu = FusedState(e)
    return e, e._gpu


def rollout(e, S, ckpt, seed):
    """one day under the trained policy; per-step (steps, B) records of what the ledger needs"""
    from tandoor_design_readout import Policy, DEV
    sd = torch.load(ckpt, map_location="cpu", weights_only=False)
    assert sd["policy.encoder.0.weight"].shape[1] == e.single_observation_space.shape[0], "obs width mismatch"
    pol = Policy(sd); B = e.num_agents; pol.reset(B); torch.manual_seed(seed)
    nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0])
    rec = {k: [] for k in ("p_in", "rotis", "cut", "stow", "t")}
    o, r, d, tr, _ = e.step_torch(torch.full((B, nh), 3, dtype=torch.long, device=DEV))
    with torch.no_grad():
        for _ in range(4000):
            act, _ = pol.step(o, nh, nv)
            o, r, d, tr, _ = e.step_torch(act)
            rec["t"].append(float(e.t_solar[0]))
            rec["p_in"].append(S.diag[:, 0].detach().cpu().numpy().copy())
            rec["rotis"].append(S.day_rotis.detach().cpu().numpy().copy())
            rec["cut"].append(np.asarray(tr.detach().cpu().numpy() if torch.is_tensor(tr) else tr).reshape(-1) > 0)
            rec["stow"].append(S.stowed.detach().cpu().numpy() > 0.5)
            dn = d.detach().cpu().numpy() if torch.is_tensor(d) else np.asarray(d)
            if dn.reshape(-1).any(): break
    Rc = {k: np.asarray(v) for k, v in rec.items()}
    w = np.nonzero(np.diff(Rc["t"]) < 0)[0]
    n = int(w[0]) + 1 if w.size else len(Rc["t"])     # ONE day: cut at the wrap
    return {k: v[:n] for k, v in Rc.items()}


def keyhole_steps(e, t, dt):
    """per step, per agent: is the sun's azimuth outrunning THIS machine's motor right now"""
    from tandoor_policy_props import solpos, dcirc
    B = e.num_agents; rate = np.asarray(e._ds_rate, float) * e.RATE_AZ * dt      # deg/step per machine
    out = np.zeros((len(t), B), bool); cache = {}
    for b in range(B):
        key = (round(float(e.lat_v[b]), 2), int(e.day_v[b]))
        if key not in cache:
            p = np.array([solpos(key[0], key[1], float(h)) for h in t])
            up = p[:, 0] > 0; both = up[:-1] & up[1:]
            cache[key] = np.concatenate([[0.0], np.where(both, dcirc(p[:, 1]), 0.0)])
        out[:, b] = cache[key] > rate[b]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ckpt", default=CKPT); ap.add_argument("--day", type=int, default=173)
    ap.add_argument("--B", type=int, default=64); ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--budget", type=float, default=700_000.0); ap.add_argument("--goal-rotis", type=float, default=0.0)
    ap.add_argument("--goal-track", type=float, default=1.0)
    ap.add_argument("--out", default="/Users/faezs/ARTIST/tutorials/data/tandoor/pareto_design.json")
    ap.add_argument("--lean-check", action="store_true")
    a = ap.parse_args()
    print(f"THE DESIGN RUN AS A PARETO OPTIMIZATION\n   checkpoint {os.path.basename(a.ckpt)}, day {a.day}, {a.B} machines")
    e, S = build(a.B, a.day, a.seed)
    rec = rollout(e, S, a.ckpt, a.seed)
    n, B, dt = rec["p_in"].shape[0], e.num_agents, float(e.dt)
    key = keyhole_steps(e, rec["t"], dt)
    print(f"   {n} steps of {dt:.0f} s over {len(set(e.site_idx.tolist()))} sites; the mount outrun in "
          f"{100 * key.mean():.1f} % of agent-steps")

    # ---- every machine's day as a summing functor into the resource category ------------------
    cap = e.design_capital(); d = e.design_points()
    rate = np.asarray(e._ds_rate, float) * e.RATE_AZ * 60.0
    V = R.Valuation(budget_pkr=a.budget, goal_rotis=a.goal_rotis, goal_track=a.goal_track, demand=e.demand_day)
    ledgers, bundles, named, margins = [], [], [], []
    cache = {}
    for b in range(B):
        kit = R.Resource.of(capital_pkr=float(cap[b]), film_m2=float(d["film_m2"][b]), motor_degpm=float(rate[b]))
        L = R.DayLedger(dt, rec["p_in"][:, b], rec["rotis"][:, b], rec["cut"][:, b], rec["stow"][:, b], key[:, b], kit)
        tot = L.total()
        k = (round(float(e.lat_v[b]), 2), int(e.day_v[b]), round(float(rate[b]), 3))
        if k not in cache: cache[k] = R.track_margin(k[0], k[1], k[2], dt=dt)[0]
        ledgers.append(L); bundles.append(tot); margins.append(cache[k]); named.append((str(b), V.value(tot, cache[k])))
    # THE MEASURING SEMIGROUP: no machine converted more energy than it received
    mj_in = np.array([R.measure_mj(r)[0] for r in bundles]); mj_out = np.array([R.measure_mj(r)[1] for r in bundles])
    bad = mj_out > mj_in + 1e-9
    print(f"   energy: {mj_in.sum():.0f} MJ of sun into the pots, {mj_out.sum():.0f} MJ into rotis; "
          f"{'no machine made more than it was given' if not bad.any() else str(int(bad.sum())) + ' MACHINES MADE MORE THAN THEY WERE GIVEN'}")
    assert not bad.any()
    # THE SUMMING FUNCTOR agrees with the simulator's own counter on an uncut day
    uncut = ~rec["cut"].any(0)
    ledger_rotis = np.array([r["rotis"] for r in bundles]); env_rotis = rec["rotis"][-1]
    if uncut.any():
        dmax = float(np.abs(ledger_rotis[uncut] - env_rotis[uncut]).max())
        print(f"   the ledger's rotis equal the simulator's on the {int(uncut.sum())} uncut machines (max |d| {dmax:.0f}); "
              f"on the {int((~uncut).sum())} cut machines the ledger keeps what the reset wiped")
        assert dmax < 0.5

    # ---- the frontier ----------------------------------------------------------------------------
    led = Ledger(V.names)
    for b in range(B):
        led.add(str(b), named[b][1], meta=dict(lat=float(e.lat_v[b]), site=int(e.site_idx[b]), dish_scale=float(d["dish_scale"][b]),
                                              film_m2=float(d["film_m2"][b]), capital_pkr=float(cap[b]), motor_degpm=float(rate[b]),
                                              tri=float(d["tri"][b]), track_margin=float(margins[b]), cuts=float(bundles[b]["cuts"]),
                                              stow_min=float(bundles[b]["stow_min"]), keyhole_min=float(bundles[b]["keyhole_min"])))
    front = led.report(V.goals, keys=("lat", "dish_scale", "film_m2", "track_margin", "cuts"), lean_check=a.lean_check, top=12)
    adm = [n_ for n_, v_ in named if all(g <= x for x, g in zip(v_, V.goals))]
    print(f"   admissible: {len(adm)} of {B} (goals: rotis >= {a.goal_rotis:g}, capital <= {a.budget:,.0f} PKR, "
          f"tracking margin >= {a.goal_track:g})")
    off_track = sum(1 for m in margins if m < a.goal_track)
    print(f"   {off_track} machines fail the tracking goal - the noon keyhole, now a design goal, not a policy failure")

    # ---- the scalarizations, as readings of the frontier -----------------------------------------
    fnames = {r[0] for r in front}
    for label, w in (("payback (tandoor_payback)", R.SCALAR_PAYBACK), ("the RL reward (sold rotis)", R.SCALAR_RL)):
        pool = [(n_, v_) for n_, v_ in named if n_ in set(adm)]
        if not pool: continue
        sc = [R.scalarize(v_, w) for _, v_ in pool]
        best = int(np.argmax(sc)); ties = sum(1 for x in sc if x >= sc[best] - 1e-9)
        pick = pool[best][0]
        print(f"   scalarization {label:28s} picks machine {pick:>3s}: on the frontier = {pick in fnames}"
              + (f" ({ties} tied)" if ties > 1 else "") + " - scalarization_mem_frontier")
        if ties == 1: assert pick in fnames

    # ---- the swarm step the dawn would take ------------------------------------------------------
    pop = json.load(open(e.design_pop)) if e.design_pop else None
    if pop:
        kit_idx = np.array(pop["kit_index"])
        u2, keep, redo = R.swarm_step(e._design_u, named, V, np.random.default_rng(a.seed), kit_idx, eps=e.pareto_eps, explore=e.redesign_explore)
        moved = float(np.abs(u2 - e._design_u).max())
        print(f"   the swarm step: {len(keep)} machines kept (the frontier), {len(redo)} redrawn toward it "
              f"(max move {moved:.3f} in the unit box) - the design run's dawn under design_pareto=1")

    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    fp = led.write(a.out.replace(".json", ".frontier.json"), V.goals)
    json.dump(dict(day=a.day, ckpt=a.ckpt, names=V.names, goals=V.goals,
                   bundles={str(b): bundles[b].as_dict() for b in range(B)},
                   frontier=[r[0] for r in front]), open(a.out, "w"), indent=1)
    print(f"   written {a.out} and {fp} (the Lean input format)")


if __name__ == "__main__":
    main()

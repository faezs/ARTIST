"""THE STATE-SPACE CUBICAL COMPLEX, DERIVED FROM THE PHYSICS (user, 2026-09-13).

The words the cook uses - jam, level, shutter, load, stow - are not states of a machine in a diagram;
they are functions on the space of material states, and their consequence is what they do to the
forces and the energy. Read in a topos of physics (Schreiber: a sheaf on the site of test spaces; here,
the smooth set of configurations of film, pot, bread, mount and sun):

    jam, shutter, stow  : X -> Omega     characteristic functions (truth values) of subobjects of X
    level               : X -> {0..6}    the pump's setpoint, i.e. the pressure p = p0 lf[level] on the film
    load_k              : X -> Omega     dough of mass m in slot k, a thermal mass C_b with an energy target
                                         (roti_kj) added to the state

and the physics in each mode m = (jam, shutter, stow, level, load) is a port-Hamiltonian generator
    L_m  =  ((J_m - R_m) grad H_m + G_m u) . grad          acting on observables f : X -> R,
H_m the stored energy (the film's elastic energy T/2 |grad w|^2 - p w, the pot's thermal energy
sum C_i T_i, the dough's), R_m the dissipation (the thermal conductances g01/g12/g2s, the lid leak),
G_m the ports (the beam, gated by shutter and stow; the wind's dynamic pressure q = rho V^2/2 on the
film with gain 1 soft / jam_gain jammed; the pump; the cook's hands). jam turns a compliant film
(pressure-held, wind-loaded) into a shell (figure locked at f_locked); stow closes the sun port;
shutter closes the beam port; load adds a state coordinate. So the "Hamiltonian operators" of the
question are these L_m: derivations on the observables, one per mode.

The cubical complex is then NOT declared, it is measured: two transitions a, b out of a mode commute
- the square [a,b] exists, the two schedules a;b and b;a are dihomotopic (Fajstrup-Goubault-Raussen)
- exactly when their generators commute, [L_a, L_b] = 0 on the states reached, which the env decides
as the physics functor: run a then b and b then a from the same state with the same noise and compare.
Holes (non-commuting pairs) are the strategy-distinguishing orders; the dihomotopy classes of
schedules through the skeleton are the strategies, counted as Mazurkiewicz traces.

    python tandoor_cubical.py [--steps 8] [--agents 4]        -> the complex, its holes, the strategies
"""
import sys, io, time, json, argparse, contextlib, itertools
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv

STATE = ["T", "T_sub", "T_deep", "T_halo", "T_sand", "p_act", "p_set", "p_dist", "f_locked", "jammed", "shutter", "form_time", "decl_formed",
         "bread_E", "bread_t", "bread_C", "has_bread", "load_timer", "el_m", "az_m", "stowed", "wind_g", "wind", "cloud", "bore", "dni", "soil", "t_solar"]
THR = 3.5


def make_env(B, seed=0, receiver="tri"):
    """the design tools' machine (tandoor_design_readout.env_kwargs: the built kit, Quetta's average day 172), on the
    numpy twin so the state can be snapshotted and restored; load_ctrl on, the aim head on, no sticky latch"""
    from tandoor_design_readout import env_kwargs
    kw = env_kwargs(B, receiver=receiver, site_weather="quetta", site_mean=1, site_days=0, warm_frac=1.0)
    kw.update(device="cpu", gpu=0, n_rays=64, seed=seed, design_rand=0, sticky_k=1, day_of_year=172, day_start=8.0, day_end=16.0)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=seed)
    e._det_trace = True
    return e


def snap(e):
    s = {k: np.array(getattr(e, k), copy=True) for k in STATE if hasattr(e, k)}
    s["_rng"] = e.rng.bit_generator.state; s["_gen"] = e._gen.get_state().clone() if getattr(e, "_gen", None) is not None else None; s["_tick"] = int(getattr(e, "tick", 0)); s["_day"] = int(e.day)
    return s


def restore(e, s):
    for k, v in s.items():
        if k.startswith("_"): continue
        a = getattr(e, k); a[...] = v.astype(a.dtype) if hasattr(a, "dtype") else v
    e.rng.bit_generator.state = s["_rng"]
    if s["_gen"] is not None: e._gen.set_state(s["_gen"])
    e.tick = s["_tick"]; e.day = s["_day"]


def action(e, mode, load=None):
    """the action row that holds a mode: [level, shutter, jam, az, el, load x n_belt]; the motors track the sun"""
    B = e.num_agents; a = np.full((B, e.N_HEADS), 3, dtype=np.int64)
    a[:, 0] = mode["level"]; a[:, 1] = 6 if mode["shutter"] else 0; a[:, 2] = 6 if mode["jam"] else 0
    k = 25.0   # a P-controller on the pointing error (deg -> rate steps)
    a[:, 3] = np.clip(np.round(3 - k * e._e_az), 0, 6); a[:, 4] = np.clip(np.round(3 - k * e._e_el), 0, 6)
    a[:, 5:5 + e.n_belt] = 0
    if load is not None: a[:, 5 + load] = 6
    return a


def track(e):
    """perfect tracking: the mount on the sun (the motors are continuous controls, not the modes under test)"""
    from tandoor_rl_env import _sim
    el, az, _ = _sim.solar_position(e.lat, e.day, float(e.t_solar[0]))
    e.el_m[:] = el; e.az_m[:] = np.degrees(az - e._ds_azs); e._e_el[:] = 0.0; e._e_az[:] = 0.0


def run(e, s0, mode, load, steps):
    """from state s0, hold `mode` for `steps` steps (a load pulse on the first); returns the final state"""
    restore(e, s0); track(e)
    for t in range(steps):
        if load is not None and t == 0: e.load_timer[:] = e.load_period           # the cook leans in now
        e.step(action(e, mode, load if t == 0 else None)); track(e)
    return snap(e)


def vec(s, keys=("T", "T_sub", "T_halo", "p_act", "f_locked", "bread_E")):
    return {k: s[k].astype(np.float64) for k in keys if k in s}


def interaction(e, x, base, a, b, steps):
    """THE COMMUTATOR, DISCRETISED. Over `steps` steps from state x: the change under both features
    minus the sum of the changes under each - I_ab = step_{m+a+b} - step_m - (step_{m+a} - step_m) - (step_{m+b} - step_m).
    Zero (to first order, 1 step) iff the generators of a and b commute on x: the square [a,b] exists."""
    ma, la = a[1], a[2]; mb, lb = b[1], b[2]; mab = dict(ma)
    for key in ("level", "jam", "shutter"):
        if mb[key] != base[key]: mab[key] = mb[key]
    lab = la if la is not None else lb
    if la is not None and lb is not None:                    # two loads: both slots this step
        s_ab = run_loads(e, x, mab, (la, lb), steps)
    else:
        s_ab = run(e, x, mab, lab, steps)
    s_m = run(e, x, base, None, steps); s_a = run(e, x, ma, la, steps); s_b = run(e, x, mb, lb, steps)
    out = {}
    for k in vec(s_m):
        I = (s_ab[k] - s_m[k]) - (s_a[k] - s_m[k]) - (s_b[k] - s_m[k]) if k in s_ab else 0.0
        da = np.abs(s_a[k] - s_m[k]).max(); db = np.abs(s_b[k] - s_m[k]).max()
        out[k] = (float(np.abs(I).max()), float(np.abs(I).max() / max(da + db, 1e-9)))
    return out


def run_loads(e, s0, mode, slots, steps):
    restore(e, s0); track(e)
    for t in range(steps):
        a = action(e, mode, None)
        if t == 0:
            e.load_timer[:] = e.load_period
            for k in slots: a[:, 5 + k] = 6
        e.step(a); track(e)
    return snap(e)


def transitions(e, base):
    """the controllable transitions out of a mode: level changes, the jam/release, the shutter, a load into each empty slot"""
    ts = []
    for j in range(e.N_LEVELS):
        if j != base["level"]: ts.append((f"level{j}", dict(base, level=j), None))
    ts.append(("release" if base["jam"] else "jam", dict(base, jam=not base["jam"]), None))
    ts.append(("shutter" + ("_close" if base["shutter"] else "_open"), dict(base, shutter=not base["shutter"]), None))
    for k in range(e.n_belt): ts.append((f"load{k}", dict(base), k))
    return ts


def compose(a, b):
    """the mode after a then b (each transition changes one coordinate; loads are pulses)"""
    m = dict(a[1]); 
    for key in ("level", "jam", "shutter"):
        if b[1][key] != a[1].get("_base", {}).get(key, None) and b[1][key] != m[key] and key == b[0].split("_")[0][:len(key)]: m[key] = b[1][key]
    return m


def main(steps=8, B=4, tol=1e-6):
    e = make_env(B); C = np.asarray(getattr(e, "node_heat_cap", np.ones(e.n_nodes)), dtype=np.float64); roti_kj = float(getattr(e, "roti_energy", 130e3)) / 1e3
    print(f"the machine: {e.n_nodes} pot nodes, {e.n_belt} bread slots, {e.N_LEVELS} pump levels, dt {e.dt:.0f} s; the film p0 {e.p0:.0f} Pa on {e.a_mem:.1f} m2 = {e.p0 * e.a_mem / 1e3:.1f} kN; "
          f"wind q at 6 / 12 m/s = {0.6 * 36:.0f} / {0.6 * 144:.0f} Pa (jam gain {e.jam_gain}); a roti {roti_kj:.0f} kJ; pot thermal mass {C.sum() / 1e3:.0f} kJ/K (nodes)")
    s0 = snap(e); results = {}
    kind = lambda n: n.rstrip("0123456789") if n.startswith(("level", "load")) else n
    for tag, base in (("soft, shutter open, level 4", dict(level=4, jam=False, shutter=True)), ("jammed, shutter open, level 4", dict(level=4, jam=True, shutter=True))):
        x = run(e, s0, base, None, 3)                          # settle the base mode, then the state x
        ts = transitions(e, base); t0 = time.time(); holes = {}; squares = {}; same = 0
        for i, j in itertools.combinations(range(len(ts)), 2):
            a, b = ts[i], ts[j]
            if kind(a[0]) == kind(b[0]) == "level": same += 1; continue      # the same variable: sequential by definition, no square
            I1 = interaction(e, x, base, a, b, 1); Ik = interaction(e, x, base, a, b, steps)
            rel1 = max(v[1] for v in I1.values()); key = tuple(sorted((kind(a[0]), kind(b[0]))))
            (holes if rel1 > tol else squares).setdefault(key, []).append((rel1, I1, Ik))
        results[tag] = dict(squares=sorted(squares), holes=sorted(holes))
        print(f"\nmode [{tag}], state x after 3 settled steps: {len(ts)} transitions, {sum(len(v) for v in holes.values()) + sum(len(v) for v in squares.values())} pairs across variables ({time.time() - t0:.0f} s), {same} same-variable pairs skipped")
        print(f"   SQUARES (generators commute, the schedules a;b ~ b;a):")
        for key, lst in sorted(squares.items()):
            Ik = max(lst, key=lambda z: max(v[1] for v in z[2].values()))[2]
            print(f"      {key[0]:14s} x {key[1]:14s} ({len(lst):2d} pairs)  1-step interaction {max(z[0] for z in lst):.1e};  over {steps} steps the second-order coupling is " + ", ".join(f"{k} {v[0]:.3g}" for k, v in Ik.items() if v[0] > 0))
        print(f"   HOLES (an interaction term: the order of a and b is a strategy):")
        for key, lst in sorted(holes.items(), key=lambda kv: -max(z[0] for z in kv[1])):
            I1 = max(lst, key=lambda z: z[0])[1]
            print(f"      {key[0]:14s} x {key[1]:14s} ({len(lst):2d} pairs)  interaction {max(z[0] for z in lst):.2f} of the two effects; per step: " + ", ".join(f"{k} {v[0]:.3g}" for k, v in I1.items() if v[1] > tol))
    # ---- the complex on the skeleton (jam x shutter x level x stow) and with the belt ----
    NL, NB = e.N_LEVELS, e.n_belt
    V_sk = 2 * 2 * NL * 2; V_full = V_sk * 2 ** NB
    print(f"\nthe complex: skeleton jam x shutter x level x stow = {V_sk} vertices; with the belt's {NB} slots {V_full} vertices."
          f" Every vertex has {NL - 1} level edges, 1 jam edge, 1 shutter edge, up to {NB} load edges (and the wind's stow edge, exogenous).")
    # strategies: Mazurkiewicz traces of the shortest schedules that change level, jam and shutter once each
    hole_kinds = {tuple(k) for tag in results for k in results[tag]["holes"]}
    letters = ["level", "jam", "shutter_close", "load"]
    indep = lambda x, y: tuple(sorted((x, y))) not in hole_kinds and x != y
    def trace_classes(word):
        perms = set(itertools.permutations(word)); parent = {p: p for p in perms}
        def find(p):
            while parent[p] != p: parent[p] = parent[parent[p]]; p = parent[p]
            return p
        for p in perms:
            for i in range(len(p) - 1):
                if indep(p[i], p[i + 1]):
                    q = p[:i] + (p[i + 1], p[i]) + p[i + 2:]; parent[find(p)] = find(q)
        return len({find(p) for p in perms})
    for word in (("level", "jam", "shutter_close"), ("level", "jam", "load"), ("level", "jam", "shutter_close", "load")):
        print(f"   schedules that do {word} once each: {len(list(itertools.permutations(word)))} orders, {trace_classes(word)} dihomotopy classes (strategies)")
    json.dump(results, open("/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/cubical.json", "w"), indent=1); print("-> puffer_tandoor/watch/cubical.json")


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--steps", type=int, default=8); ap.add_argument("--agents", type=int, default=4); ap.add_argument("--tol", type=float, default=1e-6)
    a = ap.parse_args(); main(a.steps, a.agents, a.tol)

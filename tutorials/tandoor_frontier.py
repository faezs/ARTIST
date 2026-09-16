"""The Pareto frontier of a pool of designs - the numerical twin of the proved program
`Marcolli.ThinValuation.compute` (~/manifold-pareto/lean/RequestProject/Pareto.lean, theorem
`mem_compute_iff`), and the cross-check against it.

Marcolli (arXiv:2204.11931 §2): objectives are valued in categories with goal objects and dominance
is the existence of a conversion; in the thin case that is a preorder per objective. Here every
objective is a rational, "bigger is better" (a cost enters as its negative, a boolean as 1/0 with
goal 1): a design is ADMISSIBLE when every value is at or above its goal, Ψ DOMINATES Φ when Ψ is at
least as good on every objective and strictly better on one, and the frontier of a pool is its
admissible members that no admissible member dominates. No scalarization: payback is one reading
of the frontier (tandoor_payback), not the frontier.

  frontier(designs, goals)      designs: [(name, [vals...]), ...]
  python tandoor_frontier.py --check-lean [--trials 200]    random pools vs `lake exe frontier`

For the design tools: light on the bread per (season, hour) are objectives (the goals: what the
lunch rush needs, per season), -cost is one (goal: -budget), buildability is one (goal 1).
"""
import argparse, json, os, random, subprocess, sys
from fractions import Fraction

LEAN_DIR = os.path.expanduser("~/manifold-pareto/lean")


def _q(x):
    return x if isinstance(x, Fraction) else Fraction(str(x)) if isinstance(x, float) else Fraction(x)


def admissible(vals, goals):
    return all(_q(g) <= _q(v) for v, g in zip(vals, goals)) and len(vals) >= len(goals)


def dominates(a, b):
    """b dominates a: at least as good everywhere, strictly better somewhere."""
    a, b = [_q(x) for x in a], [_q(x) for x in b]
    return all(x <= y for x, y in zip(a, b)) and any(x < y for x, y in zip(a, b))


def frontier(designs, goals):
    """[(name, vals)] -> the names on the frontier, in pool order (exactly `compute`'s filter)."""
    n = len(goals)
    pool = [(name, [_q(v) for v in list(vals)[:n]] + [Fraction(0)] * max(0, n - len(vals))) for name, vals in designs]
    adm = [admissible(v, goals) for _, v in pool]
    return [name for i, (name, v) in enumerate(pool)
            if adm[i] and not any(adm[j] and dominates(v, w) for j, (_, w) in enumerate(pool))]


def _json_num(q):
    """a Fraction as an exact JSON decimal when the denominator is a power of ten, else a float"""
    d = q.denominator; k = 0
    while d % 10 == 0: d //= 10; k += 1
    if d == 1:
        return f"{q.numerator / 10 ** k:.{k}f}" if k else str(q.numerator)
    return repr(float(q))


def to_lean_json(designs, goals):
    return "{" + '"goals": [' + ", ".join(_json_num(_q(g)) for g in goals) + '], "designs": [' + ", ".join(
        '{"name": ' + json.dumps(n) + ', "vals": [' + ", ".join(_json_num(_q(v)) for v in vals) + "]}" for n, vals in designs) + "]}"


def lean_frontier(designs, goals):
    out = subprocess.run(["lake", "exe", "frontier"], input=to_lean_json(designs, goals), text=True, capture_output=True, cwd=LEAN_DIR,
                         env={**os.environ, "PATH": os.path.expanduser("~/.elan/bin") + ":" + os.environ.get("PATH", "")})
    if out.returncode != 0:
        raise RuntimeError(out.stderr)
    return [l for l in out.stdout.splitlines() if l]


def check_lean(trials=200, seed=0):
    rng = random.Random(seed); bad = 0
    for t in range(trials):
        n = rng.randint(1, 4); m = rng.randint(1, 12)
        goals = [Fraction(rng.randint(-3, 3), rng.choice([1, 2, 10])) for _ in range(n)]
        designs = [(f"d{i}", [Fraction(rng.randint(-6, 6), rng.choice([1, 2, 10])) for _ in range(n)]) for i in range(m)]
        py, ln = frontier(designs, goals), lean_frontier(designs, goals)
        if py != ln:
            bad += 1; print(f"MISMATCH trial {t}: goals {goals} designs {designs}\n  python {py}\n  lean   {ln}")
    print(f"{trials} random pools: {trials - bad} agree with the proved frontier, {bad} differ")
    return bad == 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--check-lean", action="store_true"); ap.add_argument("--trials", type=int, default=200); ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--json", help="a designs.json (the Lean input format) to print the frontier of")
    a = ap.parse_args()
    if a.check_lean:
        sys.exit(0 if check_lean(a.trials, a.seed) else 1)
    if a.json:
        j = json.load(open(a.json)); print("\n".join(frontier([(d["name"], d["vals"]) for d in j["designs"]], j["goals"])))


class Ledger:
    """Every kit a design tool evaluates, with its oriented valuations, and the frontier at the end.

    objectives: names, all "bigger is better". Rows keep a `meta` dict (the design as built) so the
    frontier can be printed as machines, not numbers. `write` emits the Lean input format
    (`lake exe frontier`) with the extra keys the Lean reader ignores."""

    def __init__(self, objectives):
        self.objectives = list(objectives); self.rows = []

    def add(self, name, vals, meta=None):
        assert len(vals) == len(self.objectives), (name, vals)
        self.rows.append((str(name), [float(v) for v in vals], meta or {}))

    def frontier(self, goals):
        names = set(frontier([(n, v) for n, v, _ in self.rows], goals))
        return [r for r in self.rows if r[0] in names]

    def write(self, path, goals):
        json.dump({"objectives": self.objectives, "goals": [float(_q(g)) for g in goals],
                   "designs": [{"name": n, "vals": v, "meta": m} for n, v, m in self.rows]}, open(path, "w"), indent=1)
        return path

    def report(self, goals, keys=(), lean_check=False, top=12):
        front = self.frontier(goals)
        print(f"\nPARETO FRONTIER (Marcolli: admissible - every objective at or above its goal - and dominated by no admissible kit): "
              f"{len(front)} of {len(self.rows)} kits evaluated; objectives {self.objectives}; goals {[float(_q(g)) for g in goals]}")
        for n, v, m in sorted(front, key=lambda r: -r[1][0])[:top]:
            print("  " + f"{n:10s} " + "  ".join(f"{o}={x:,.2f}" for o, x in zip(self.objectives, v)) + ("   " + ", ".join(f"{k}={m[k]:.2f}" if isinstance(m.get(k), float) else f"{k}={m.get(k)}" for k in keys if k in m) if keys else ""))
        if len(front) > top: print(f"  ... and {len(front) - top} more")
        if lean_check:
            ln = lean_frontier([(n, v) for n, v, _ in self.rows], goals)
            ok = ln == [n for n, _, _ in front]
            print(f"  lean exe frontier: {'AGREES' if ok else 'DIFFERS'} ({len(ln)} names)")
        return front

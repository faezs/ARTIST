"""A PROPERTY-BASED TESTING ENGINE FOR THE TANDOOR (user, 2026-09-17: "the point is all the lean
should validate the environment").

QuickCheck, in the small: a property is a named claim over randomly generated inputs, each input
class carries its own SHRINKER, and a failure is reported as the smallest counterexample the
shrinker can reach rather than as whatever random monster first tripped it.  Properties also
LABEL their cases, so a property that passed only because every draw was degenerate says so
instead of reporting a green tick.

    from tandoor_props import Gen, floats, ints, arrays, Suite
    S = Suite("the pot")
    @S.prop("energy never rises in the dark", lean="ThermalDiscrete.explicit_euler_energy_eq",
            gens=dict(n=ints(2, 40), w=floats(0.0, 50.0)))
    def _(n, w, label):
        label("size", "small" if n < 8 else "large")
        return ok, "what the numbers were"

The property returns True/False, or (bool, detail).  Raising counts as a failure, with the
exception as the detail - a crash on a legal input is a failure of the same kind.
"""
import math, random, sys, time, traceback
import numpy as np


# ------------------------------------------------------------------ generators
class Gen:
    """sample(rng) -> value;  shrink(value) -> an iterable of simpler values."""
    __slots__ = ("sample", "shrink", "desc")

    def __init__(self, sample, shrink=None, desc=""):
        self.sample = sample
        self.shrink = shrink if shrink is not None else (lambda v: ())
        self.desc = desc

    def map(self, f, desc=None):
        return Gen(lambda r: f(self.sample(r)),
                   lambda v: (),                  # a mapped value cannot be shrunk blind
                   desc or self.desc)

    def filter(self, pred, tries=200):
        def _s(r):
            for _ in range(tries):
                v = self.sample(r)
                if pred(v): return v
            raise RuntimeError(f"generator {self.desc!r} could not satisfy its filter in {tries} draws")
        return Gen(_s, lambda v: (x for x in self.shrink(v) if pred(x)), self.desc)


def _towards(v, target):
    """The shrink ladder.  The fractions converge geometrically on the boundary: the caller keeps
    the FIRST candidate that still fails and restarts, so approaching from the target side with
    0.5 .. 0.995 walks the failing region's edge instead of stalling when the halfway point passes."""
    if v == target: return
    yield target
    gap = v - target
    for f in (0.5, 0.75, 0.9, 0.95, 0.99, 0.995):
        c = target + gap * f
        if c != v: yield c
    r = round(v, 3)
    if r != v and abs(r - target) < abs(v - target): yield r


def floats(lo, hi, target=None, log=False):
    """uniform (or log-uniform) on [lo, hi], shrinking toward `target` (default: the end nearer 0)"""
    if target is None:
        target = lo if abs(lo) <= abs(hi) else hi
    if log:
        assert lo > 0, "log-uniform needs a positive low end"
        s = lambda r: math.exp(r.uniform(math.log(lo), math.log(hi)))
    else:
        s = lambda r: r.uniform(lo, hi)
    return Gen(s, lambda v: (c for c in _towards(v, target) if lo <= c <= hi),
               f"float[{lo:g},{hi:g}]")


def ints(lo, hi, target=None):
    if target is None:
        target = lo if abs(lo) <= abs(hi) else hi

    def _sh(v):
        seen = set()
        for c in _towards(float(v), float(target)):
            c = int(round(c))
            if lo <= c <= hi and c != v and c not in seen:
                seen.add(c); yield c
        step = 1 if target < v else -1               # and a single step, so it can walk the edge
        c = v - step
        if lo <= c <= hi and c not in seen: yield c
    return Gen(lambda r: r.randint(lo, hi), _sh, f"int[{lo},{hi}]")


def choice(seq):
    seq = list(seq)
    def _sh(v):
        i = seq.index(v) if v in seq else 0
        for j in range(i):                        # earlier in the list is "simpler"
            yield seq[j]
    return Gen(lambda r: r.choice(seq), _sh, f"choice{len(seq)}")


def arrays(n, lo, hi, target=None, log=False, sort=False):
    """a vector of floats; shrinks elementwise, and by collapsing to a constant vector"""
    el = floats(lo, hi, target, log)
    tgt = el.sample.__self__ if False else (lo if target is None else target)

    def _s(r):
        v = np.array([el.sample(r) for _ in range(n if isinstance(n, int) else n.sample(r))])
        return np.sort(v) if sort else v

    def _sh(v):
        v = np.asarray(v, float)
        if v.size == 0: return
        if not np.allclose(v, v[0]):
            yield np.full_like(v, float(v.mean()))    # a constant vector
            yield np.full_like(v, float(v.min()))
        if not np.allclose(v, tgt):
            yield np.full_like(v, float(tgt))         # the degenerate vector
        for i in range(v.size):                       # one coordinate at a time
            for c in _towards(float(v[i]), float(tgt)):
                if lo <= c <= hi:
                    w = v.copy(); w[i] = c; yield w
                    break
        if v.size > 2:
            yield v[: v.size // 2]                    # a shorter vector
    return Gen(_s, _sh, f"array[{n}]")


def spd_graph(nmax=12, wmax=50.0, lmax=5.0):
    """a random weighted graph with leaks: (n, edges [(i,j,w)], leak[n], cap[n]).
    This is EXACTLY Lean's ThermalDiscrete.Network.ofGraph: w >= 0 on edges, l >= 0 at nodes."""
    def _s(r):
        n = r.randint(2, nmax)
        m = r.randint(1, max(1, n * (n - 1) // 2))
        edges = []
        for _ in range(m):
            i = r.randrange(n); j = r.randrange(n)
            if i != j: edges.append((min(i, j), max(i, j), r.uniform(0.0, wmax)))
        leak = np.array([r.uniform(0.0, lmax) if r.random() < 0.4 else 0.0 for _ in range(n)])
        cap = np.array([r.uniform(1.0, 5e5) for _ in range(n)])
        return (n, edges, leak, cap)

    def _sh(v):
        n, edges, leak, cap = v
        if len(edges) > 1:
            yield (n, edges[:len(edges) // 2], leak, cap)
            yield (n, edges[:1], leak, cap)
        if np.any(leak > 0):
            yield (n, edges, np.zeros_like(leak), cap)
        if not np.allclose(cap, cap[0]):
            yield (n, edges, leak, np.full_like(cap, float(cap.min())))
        if n > 2:
            k = n // 2
            yield (k, [(i, j, w) for (i, j, w) in edges if i < k and j < k], leak[:k], cap[:k])
    return Gen(_s, _sh, "graph")


# ------------------------------------------------------------------ the suite
class Fail(Exception):
    """raise inside a property to fail it with a message"""


class Suite:
    def __init__(self, title):
        self.title = title
        self.props = []

    def prop(self, name, lean="", gens=None, n=200, tol=None, cover=None):
        """cover={"label key": {"class": minimum fraction}} - a property that never GENERATED the
        interesting case has not been tested, however green it looks.  An unmet requirement fails
        the property, so a generator that drifts away from the hard cases cannot hide."""
        def deco(fn):
            self.props.append(dict(name=name, lean=lean, gens=gens or {}, fn=fn, n=n, tol=tol,
                                   cover=cover or {}))
            return fn
        return deco


def _invoke(p, case, labels):
    """run one case; returns (ok, detail).  A raise is a failure, not a crash."""
    try:
        out = p["fn"](label=lambda k, v="": labels.append((k, v)), **case)
    except Fail as ex:
        return False, str(ex)
    except Exception:
        return False, "raised " + traceback.format_exc(limit=2).strip().splitlines()[-1]
    if isinstance(out, tuple):
        return bool(out[0]), (out[1] if len(out) > 1 else "")
    return bool(out), ""


def _shrink(p, case, budget=400):
    """greedy coordinate descent on the failing case: keep any simpler input that still fails"""
    best, det = dict(case), ""
    improved, steps = True, 0
    while improved and steps < budget:
        improved = False
        for k, g in p["gens"].items():
            for cand in g.shrink(best[k]):
                steps += 1
                if steps >= budget: break
                trial = dict(best); trial[k] = cand
                ok, d = _invoke(p, trial, [])
                if not ok:
                    best, det, improved = trial, d, True
                    break
            if improved: break
    return best, det, steps


def _fmt(v):
    if isinstance(v, np.ndarray):
        if v.size <= 6: return "[" + " ".join(f"{x:.4g}" for x in v.ravel()) + "]"
        return f"array{v.shape} [{v.min():.4g} .. {v.max():.4g}]"
    if isinstance(v, tuple) and len(v) == 4 and isinstance(v[1], list):
        return f"graph(n={v[0]}, {len(v[1])} edges, {int((v[2] > 0).sum())} leaks)"
    if isinstance(v, float): return f"{v:.6g}"
    return repr(v)


def run(suites, seed=0, scale=1.0, only=None, verbose=False):
    """run every suite; returns the number of failures"""
    rng = random.Random(seed)
    nfail = nprop = 0
    t0 = time.time()
    for S in suites:
        printed = False
        for p in S.props:
            if only and only not in p["name"] and only not in p["lean"]: continue
            if not printed:
                print(f"\n{S.title.upper()}", flush=True); printed = True
            nprop += 1
            n = max(1, int(p["n"] * scale))
            labels, fail = [], None
            r = random.Random(rng.randrange(1 << 30))
            for i in range(n):
                case = {}
                try:
                    for k, g in p["gens"].items(): case[k] = g.sample(r)
                except Exception as ex:
                    fail = (case, f"generator failed: {ex}", 0, i + 1); break
                ok, det = _invoke(p, case, labels)
                if not ok:
                    mini, mdet, steps = _shrink(p, case)
                    fail = (mini, mdet or det, steps, i + 1); break
            tag = f"  [{p['lean']}]" if p["lean"] else ""
            if fail is None:
                cls = {}
                for (k, v) in labels: cls.setdefault(k, {}).setdefault(str(v), 0)
                for (k, v) in labels: cls[k][str(v)] += 1
                cov = ""
                if cls:
                    cov = "  " + "; ".join(
                        f"{k}: " + ", ".join(f"{v} {100*c/max(1,sum(d.values())):.0f}%"
                                             for v, c in sorted(d.items(), key=lambda x: -x[1])[:4])
                        for k, d in cls.items())
                short = []
                for k, want in p.get("cover", {}).items():
                    d = cls.get(k, {}); tot = max(1, sum(d.values()))
                    for v, need in want.items():
                        got = d.get(str(v), 0) / tot
                        if got < need:
                            short.append(f"{k}={v} in {100*got:.1f}% of cases, wanted {100*need:.0f}%")
                if short:
                    nfail += 1
                    print(f"   [FAIL] {p['name']}{tag}", flush=True)
                    print(f"          the assertion held, but the generator never reached the hard case:",
                          flush=True)
                    for t in short: print(f"            {t}", flush=True)
                    if cov: print(f"          {cov.strip()}", flush=True)
                else:
                    print(f"   [PASS] {p['name']}  ({n} cases){tag}", flush=True)
                    if cov: print(f"          {cov.strip()}", flush=True)
            else:
                nfail += 1
                mini, det, steps, tried = fail
                print(f"   [FAIL] {p['name']}{tag}", flush=True)
                print(f"          failed on case {tried} of {n}; shrunk in {steps} steps to:", flush=True)
                for k, v in mini.items():
                    print(f"            {k} = {_fmt(v)}", flush=True)
                if det: print(f"          {det}", flush=True)
    print(f"\n{nprop} properties, {nfail} failed  ({time.time() - t0:.1f}s, seed {seed})", flush=True)
    return nfail

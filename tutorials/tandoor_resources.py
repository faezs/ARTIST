"""THE DESIGN RUN AS A PARETO OPTIMIZATION IN A CATEGORY OF RESOURCES (user, 2026-09-17: "reframe the
design run as a pareto optimization for a categorical resource-based framework").

Marcolli, "Pareto optimization in categories" (arXiv:2204.11931), in the thin case this machine
needs - every piece below names the object it is:

  RESOURCES     a symmetric monoidal category (C, ⊗, I). Here the free commutative monoid on the
                machine's resource TYPES: an object is a bundle (`Resource`), ⊗ is componentwise
                addition (`__add__`), the unit is the empty bundle. A conversion A → B exists when B
                is obtainable from A; the MEASURING SEMIGROUP M: (C, ⊗) → (ℝ≥0, +) sends a bundle to
                energy or to money through the machine's own rates (`measure_mj`, `measure_pkr`), and
                a conversion A → B respects it: M(B) ≤ M(A) (energy is never created; the property).
  SUMMING       Φ: P(S) → C on the day's EVENTS S (its steps, plus the commissioning). Φ(A) is the
  FUNCTOR       bundle the events in A contributed: Φ(A ⊔ A') = Φ(A) ⊗ Φ(A'), Φ(∅) = 0 - the
                resource-valued form of Physics.lean's SummingFunctor.sumOn_union (`DayLedger`).
  VALUATION     (F, X): objectives F_α on Σ_C(S) with goals X_α. Thin: each V_α is (ℚ, ≤), bigger is
  SYSTEM        better, a cost enters negated - Pareto.lean's ThinValuation, which
                toValuationSystem_majorizes_iff identifies with the categorical one (`Valuation`).
  THE FRONTIER  admissible (every goal met) and dominated by no admissible design: tandoor_frontier
                .frontier, the numerical twin of the proved program ThinValuation.compute
                (mem_compute_iff); `lake exe frontier` re-derives it on request.
  SCALARIZATION a linear functional on the valuations - payback (tandoor_payback) is one, the RL
                reward is another - and scalarization_mem_frontier says each only ever picks a
                frontier point. Readings of the frontier, not the frontier.
  THE SWARM     Marcolli §4: the population keeps its frontier and moves every dominated design by
                an ε-step toward a frontier design (ε-reversible, so the chain of minorizations
                converges - Prop. 4.4). This replaces the design run's old elite rule, the top
                quartile of ONE scalar (yesterday's sales), with the frontier (`swarm_step`).

The design run is then: a population of machines, each a summing functor over its day, valued by
(F, X), the cook policy learning across all of them while the population climbs the frontier.
"""
from dataclasses import dataclass, field
import numpy as np

from tandoor_frontier import frontier as _frontier, lean_frontier, to_lean_json, Ledger

# ---- the resource types: one commutative monoid, these generators -------------------------------
#: what the sun put into the pot [kWh]; what the machine sold [rotis] and let go stale; the
#: capital it cost [PKR]; the film it needs [m2]; the azimuth its motor can turn [deg/min]; the
#: minutes the sun outran that motor (the noon keyhole, tandoor_policy_props); the guillotine
#: cuts it took; the minutes it stood stowed; the fuel the sun displaced [kg LPG]
TYPES = ("sun_kwh", "rotis", "stale", "capital_pkr", "film_m2", "motor_degpm", "keyhole_min",
         "cuts", "stow_min", "lpg_kg")


@dataclass(frozen=True)
class Resource:
    """an object of the resource category: a bundle in the free commutative monoid on TYPES"""
    v: tuple = field(default_factory=lambda: (0.0,) * len(TYPES))

    @classmethod
    def of(cls, **kw):
        bad = set(kw) - set(TYPES)
        assert not bad, f"not a resource type: {bad}"
        return cls(tuple(float(kw.get(t, 0.0)) for t in TYPES))

    def __add__(self, o):                                # ⊗, the monoidal product
        return Resource(tuple(a + b for a, b in zip(self.v, o.v)))

    def __getitem__(self, t):
        return self.v[TYPES.index(t)]

    def scale(self, k):
        return Resource(tuple(k * a for a in self.v))

    def as_dict(self):
        return dict(zip(TYPES, self.v))

    def __repr__(self):
        return "Resource(" + ", ".join(f"{t}={x:.4g}" for t, x in zip(TYPES, self.v) if x) + ")"


UNIT = Resource()                                        # I, the empty bundle: Φ(∅)


# ---- the measuring semigroup: the machine's own rates ---------------------------------------
ROTI_KJ = 130.0                                          # tandoor_payback DEFAULTS: the heat a roti takes


def measure_mj(r):
    """M_energy: the bundle as megajoules - what the sun put in, and what the rotis took out.
    Returns (in, out); a conversion never makes more than it was given: out <= in."""
    return r["sun_kwh"] * 3.6, (r["rotis"] + r["stale"]) * ROTI_KJ / 1000.0


def measure_pkr(r, fuel="lpg", **kw):
    """M_money: the bundle as rupees per day - the fuel the sun displaces (tandoor_payback), less
    the capital's upkeep. THIS is the scalarization payback reads."""
    import tandoor_payback as P
    p = {**P.DEFAULTS, **kw}
    sav = float(P.savings_per_day(r["rotis"], fuel, **p))
    return sav - p["maint"] * r["capital_pkr"] / p["days"]


def converts(a, b, tol=1e-9):
    """a conversion a → b exists in the THIN resource preorder: b asks no more of any consumed
    resource than a had, and b makes no more product than a's energy allows - the measuring
    semigroup's constraint, rho * M(b) <= M(a)"""
    consumed = ("capital_pkr", "film_m2", "sun_kwh", "motor_degpm")
    if any(b[t] > a[t] + tol for t in consumed):
        return False
    return measure_mj(b)[1] <= measure_mj(a)[0] + tol


# ---- the summing functor: the day as a set of events -----------------------------------------
class DayLedger:
    """Φ: P(S) → C for one machine's day. S = the day's steps 0..n-1 plus the commissioning event
    'kit'. `of(A)` is Φ(A); `total()` is Φ(S). Built from the per-step increments the simulator
    exposes: p_in [W] (the sun's deposit), the sales counter, the guillotine, the stow latch."""

    def __init__(self, dt, p_in, sold_cum, cut, stowed, keyhole_step, kit):
        n = len(p_in)
        sold = np.diff(np.concatenate([[0.0], np.asarray(sold_cum, float)]))
        sold = np.where(np.asarray(cut, bool), 0.0, np.maximum(sold, 0.0))   # a reset is not a sale
        self.events = {}
        for i in range(n):
            self.events[i] = Resource.of(
                sun_kwh=float(p_in[i]) * dt / 3.6e6, rotis=float(sold[i]),
                cuts=float(bool(cut[i])), stow_min=float(bool(stowed[i])) * dt / 60.0,
                keyhole_min=float(bool(keyhole_step[i])) * dt / 60.0)
        self.events["kit"] = kit                           # the commissioning: capital, film, motor
        self.S = list(self.events)

    def of(self, A):
        """Φ(A): the bundle the events in A contributed - the sum over A"""
        r = UNIT
        for e in A:
            r = r + self.events[e]
        return r

    def total(self):
        return self.of(self.S)


# ---- the valuation system, thin --------------------------------------------------------------
class Valuation:
    """(F, X) on Σ_C(S), thin: objectives F_α: Resource → ℚ, bigger is better, goals X_α.
    The frontier of a pool is tandoor_frontier.frontier - the proved program's twin."""

    def __init__(self, budget_pkr=700_000.0, goal_rotis=0.0, goal_track=1.0, goal_payback_months=None,
                 fuel="lpg", demand=500.0):
        import tandoor_payback as P
        self.P, self.fuel, self.demand = P, fuel, demand
        self.names = ["rotis", "sun_kwh", "neg_PKR", "neg_payback_mo", "track_margin"]
        self.goals = [goal_rotis, 0.0, -budget_pkr,
                      -(goal_payback_months if goal_payback_months is not None else 600.0), goal_track]

    def value(self, r, track_margin):
        """F(Φ(S)) - the design's valuation vector"""
        pb = float(self.P.payback_months(r["capital_pkr"], r["rotis"], self.fuel, rotis=self.demand))
        return [r["rotis"], r["sun_kwh"], -r["capital_pkr"], -min(pb, 600.0), float(track_margin)]

    def frontier(self, named_vals):
        """[(name, vals)] -> frontier names (admissible, undominated), in pool order"""
        return _frontier(named_vals, self.goals)

    def lean_frontier(self, named_vals):
        return lean_frontier(named_vals, self.goals)

    def lean_json(self, named_vals):
        return to_lean_json(named_vals, self.goals)


def scalarize(vals, weights):
    """a scalarization: one linear functional on the valuations. `weights` names -> weight."""
    return sum(float(w) * float(v) for v, w in zip(vals, weights))


#: the two scalarizations the project already uses, as weight vectors on Valuation.names
SCALAR_PAYBACK = (0.0, 0.0, 0.0, 1.0, 0.0)            # tandoor_payback: months, and nothing else
SCALAR_RL      = (1.0, 0.0, 0.0, 0.0, 0.0)            # the design run's reward: sold rotis


def track_margin(lat, day, rate_deg_per_min, dt=15.0):
    """the follower theorems' hypothesis as a number: the motor's azimuth rate over the sun's peak
    azimuth rate at this site on this day (tandoor_policy_props P2). >= 1: the mount keeps up all
    day; < 1: the noon keyhole is open and no policy can satisfy Mount.follow_exact inside it."""
    from tandoor_policy_props import solpos, dcirc
    t = np.arange(4.0, 20.0, dt / 3600.0)
    p = np.array([solpos(float(lat), int(day), float(h)) for h in t])
    up = p[:, 0] > 0.0
    both = up[:-1] & up[1:]
    w = np.where(both, dcirc(p[:, 1]), 0.0)
    need = float(w.max()) / dt * 60.0                    # deg/min the site demands
    return float(rate_deg_per_min) / max(need, 1e-9), need


# ---- the swarm ---------------------------------------------------------------------------------
def swarm_step(u, named_vals, valuation, rng, kit_idx, eps=0.05, explore=0.1):
    """Marcolli's particle swarm on the thin frontier, one dawn.

    u (B, N_DESIGN): the population in the unit box; named_vals: [(str(b), vals)] per agent.
    The frontier stays (the elites). Every other agent is redrawn: with probability `explore`
    uniformly on the kit columns (the box is never abandoned), otherwise as an ε-step from a
    frontier design chosen at random - ε-reversible, the move that makes the chain of
    minorizations converge (Prop. 4.4). With NO admissible design (no goal met by anyone) the
    swarm keeps the best-selling quarter, the old rule, so the run never stalls on an empty
    frontier. Returns (u', kept indices, redrawn indices)."""
    B = u.shape[0]
    names = valuation.frontier(named_vals)
    keep = [i for i in range(B) if str(i) in set(names)]
    if not keep:                                         # nobody admissible: the old elite rule
        sales = np.array([v[0] for _, v in named_vals])
        keep = [i for i in range(B) if sales[i] > 0 and sales[i] >= np.quantile(sales, 0.75)] or [int(np.argmax(sales))]
    u = np.asarray(u, float).copy()
    redo = [b for b in range(B) if b not in set(keep)]
    for b in redo:
        if rng.uniform() < explore:
            u[b, kit_idx] = rng.uniform(size=len(kit_idx))
        else:
            j = keep[rng.integers(len(keep))]
            u[b, kit_idx] = np.clip(u[j, kit_idx] + eps * rng.standard_normal(len(kit_idx)), 0.0, 1.0)
    return u, keep, redo

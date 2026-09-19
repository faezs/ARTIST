# Reward and learning for `puffer_hashemi_ccc`, in the language of topoi

The physics of this env is a spec compiled by Ccc: one morphism `hashemiEnv` (HashemiEnv.lean,
83 columns), its conditions as Ω-columns (`SunReachable`, `LostSun`, `sunReachableS`, `lostSunS` in
HashemiMega.lean), two runtimes printed from one hash-consed graph. The reward was not compiled: it
was assembled by hand in `hashemi_tandoor_env.py` on each path, and on 2026-09-19 (commit bb3c855)
it was found wrong twice. This is the design that says what the reward IS, so that the same
translator prints it and the same checker measures it.

The Lean is now TWO layers (2026-09-19, after the user's judgement that the first version was
"too specific to this particular environment"): `lean/RewardTheory.lean`, the theory with no env in
it, and `lean/RewardTopos.lean`, this env as one instance of it (mirrors of
`~/manifold-pareto/lean/RequestProject/`). **0 `sorry`**; `lake build RequestProject.RewardTheory
RequestProject.RewardTopos RequestProject.TandoorRewardInstance` succeeds. See
"## The general theory" below for what is generic and what is this env's.

## The general theory

`lean/RewardTheory.lean` has **no import from this env**. It is parametrized over

| parameter | what it is | this env's value | the tandoor's |
|---|---|---|---|
| `S` | a state type | `hashemiEnv`'s 83-column row × the parent's raw reward for the step | the belt's temperatures × the dough's energy |
| `A` | an action type | `Fin 7 × Fin 7`, the two heads | which bins the cook loads/pulls |
| `V` | the value object: `[Field V] [LinearOrder V] [IsStrictOrderedRing V]` (`Archimedean` only where a *horizon* is produced) | ℝ | ℝ |
| transition | `Dynamics.step : S → A → S`, a plain function (§5 of the file says what a Markov kernel changes: the expectation is linear, so nothing structural) | the env's step | the env's step |
| truncation | `Truncation.value ≤ 0` | the guillotine, `−(give + 75)` | the day's cut |

and proves four theorems, each generic in all five:

1. **Gluing.** A reward is a `Term` (atoms = the columns a runtime reads, rational constants, `+`,
   `·`); a `Model` is any evaluation that respects that structure. `glue`: two models with the same
   reading of the columns agree on *every* term. `eq_stdModel`: every model is the canonical one —
   a printed morphism. `not_model_of_scaled`: a second path returning `k ·` a term's value, `k ≠ 1`,
   where that value is non-zero, is **not a model** of it. The 75x bug of 2026-09-19 is the instance
   `k = reward_div` at `shapeTerm` (`TandoorHashemi.handwritten_not_a_model`).
2. **Units as change of base.** `eval_map`: a ring map `f : V →+* W` on values carries a model to a
   model and the naturality square commutes for every term — a printed definition cannot put the
   divisor in the wrong fibre. On a reward assembled as a summing functor over a cover,
   `Summed.total_scale` / `Summed.total_div`: the divided reward is the division of the reward
   (`scale_natural` here, `trainer_add` in the tandoor's instance).
3. **Truncation.** `trunc_never_beats`: with a per-step reward `≥ 0` the cut never beats continuing,
   for *any* plan, state, horizon and `0 ≤ γ`. `exists_horizon_trunc_wins`: any strictly negative
   per-step reward has a horizon at which the cut wins (Archimedean). Bug 2 is that converse, and
   the fix is the hypothesis of the first.
4. **Shaping is a coboundary.** `shaping_telescopes`: the return changes by `γⁿ φ(n) − φ(0)` only.
   `greedy_invariant`: a state-only additive term leaves the greedy set unchanged.
   `bellman_shift`: a Bellman fixed point of the shaped reward is the original's shifted by `φ`.

`lean/RewardTopos.lean` is this env's instance and derives every theorem it used to prove itself
(its own proofs are now only the arithmetic of *this* reward's constants and the `rfl` that ties it
to `HashemiReward.lean`). `RequestProject/TandoorRewardInstance.lean` is a second instance, for the
parent tandoor's own reward (5 per roti, −5 scorched, the holding cost, the doneness and belt-rise
potentials, the cut at 75, `reward_div`) — a page, no proof repeated, and nothing of
`tandoor_rl_env.py` touched. `beltRise_is_coboundary` identifies that env's banded preheat term as
`φ(T') − φ(T)` for `φ(T) = 0.05 · Σ min(T, T_COOK_LO)`, which is what makes it free.

## 1. The site

The right home for the reward is not "the state space": it is the site `S` of *stages at which a
value can be asserted*, with three kinds of covering family of the object "this agent's step":

| cover | the family | where it already exists |
|---|---|---|
| **composition** | `mount ; rays ; heat ; pot` — the four sub-morphisms of `hashemiEnv` | HashemiEnv.lean's `megaStep`, `∑ dishPower`, `coilProfile`, `delivered` |
| **implementation** | `{numpy, fused}` — the same object computed twice | `_run_np` / `_gpu_full_step` in `hashemi_tandoor_env.py` |
| **temporal** | a day covered by its steps, and a refinement of that cover | `hashemi_modula.py::sheaf` already checks restriction monotonicity over the day's stages |

The subobjects of Ω enter as the *support* of the sections: `SunReachable` and `LostSun` are
Ω-columns (`sun_reachable`, `lost_sun`, indices 13 and 14; smoothly 15, 16), and the reward is a
section supported on `SunReachable` — `rewardRaw` in the Lean multiplies by that column, which is
the internal statement "the light is only counted where the sun is in the winch's reach".

A reward is then a **section of the presheaf of values over `S`**, and the two bugs are exactly the
two ways a presheaf fails to be a sheaf.

**Bug 1 (units) = failure of gluing on the implementation cover.** The per-step shaping went in raw
on the fused path (before `step_torch`'s `reward_div = 75`) and after the division on the NumPy
path. Two restrictions of one object disagreed by a factor of 75, so the compatible-family
condition failed and no global section existed: "the reward" was not a well-defined quantity at
all. In the Lean: `Glues` on `PathFamily`, `printed_glues` (a family printed from one morphism glues
by `rfl`), `handwritten_does_not_glue` / `paths_disagree` (the handwritten family provably does
not, whenever any light is captured), and `paths_gap` (the gap is `rewardRaw · (1 − 1/75)`).

The same bug read the other way is a **naturality** failure. Units are a change of base: the
trainer's value object is the parent's raw units rescaled by `1/reward_div`, and the square

```
  raw value  --(+ shaping)-->  raw value
      |                            |
   (/ 75)                       (/ 75)
      v                            v
 trainer value --(+ shaping/75)--> trainer value
```

must commute. `scale_natural` is that square and it is a `ring` identity; the handwritten glue put
the shaping in the wrong fibre on one path. One printed definition cannot make this mistake — which
is the whole argument for §4.

**Bug 2 (escape) = the terminal object.** The guillotine is the unique morphism from the step to the
episode's terminal object; its value is `−(give + cut_penalty)` (`tandoor_hashemi_env.py:1572`,
`cut_penalty = 75`, i.e. exactly 1 in trainer units — `cutCostTrainer_one`). A per-step *penalty*
makes the section over the remaining stages of the day negative, and for a long enough day the
terminal beats it: `escape_pays` proves that for any strictly negative per-step reward there is a
day length at which cutting is strictly better, and the measured instance was 66 against 1
(`measured_escape`). The fix is a property of the section, not a tuning: **non-negative per-step
reward ⇒ leaving never pays** (`cut_never_pays`, via `ret_nonneg`). That is why the reward is now
the light at the receiver — `p_in`, column 20 — and not a pointing penalty.

## 2. Reward as a valuation, shaping as a coboundary

Marcolli (Pareto.lean): objectives are categories with goal objects, a solution's valuation is an
object, dominance is a morphism, and a scalar reward is a *scalarization* — one reading of the
frontier, not the frontier. `rewardObjectives` instantiates a two-objective thin valuation system
(the light delivered, the rotis baked) and `reward_monotone_in_light` is the condition that makes
the scalar reward a legitimate reading of it: monotone in each objective, `≤` being the conversion
morphism in the thin category ℝ. Nothing here claims the scalar reward finds the frontier; Pareto.lean's
`onMaximalFrontier_of_argmax` already says exactly how much a scalarization buys.

Potential-based shaping is a **coboundary** on the transition graph: `δφ(i) = γ φ(i+1) − φ(i)`.
`shaping_telescopes` proves that the return changes only by the boundary term `γⁿ φ(n) − φ(0)`, so
the reward's cohomology class — the thing the policy optimizes — is unchanged. That is the precise
sense in which `pointing_shaping` (currently 0.0, zeroed on resync steps) is free and
`capture_shaping` is not: the capture term is a genuine change of class, justified physically (it is
the quantity the rotis are made of, delay-free where the oil lags minutes), not a free
reparametrisation.

The composition cover gives the summing-functor reading: `stageReward` assigns a value to each stage
and `stageReward_sum` says the step's reward is the sum over the cover — with the whole value on the
`rays` stage. This is where a future per-stage reward (e.g. charging the pipe's loss) would go, and
the sum condition is what keeps it a section rather than a second, competing reward.

## 3. Learning

* **The policy is a morphism in a tangent category.** Ccc already prints the tangent functor: every
  compiled definition has `hk_<f>_jvp` (value + JVP) and `hk_<f>_box` (interval + Lipschitz), and
  `hashemi_modula.py` runs them, checking soundness (|J dx| ≤ the box bound) and composing the
  closed loop `policy ∘ env` as one module. The reward is a morphism on the same graph, so when it
  is compiled (§4) its tangent and box come for free — the gradient of the return with respect to
  the policy's weights factors through the physics' printed sensitivity, and Muon's step in the
  modular norm is distributed over the policy's layers *divided by* that downstream sensitivity
  (`closed_loop` in `hashemi_modula.py`). The sheaf check over the day's stages (§1, temporal cover)
  is the statement that this budget is stable under refinement of the day.
* **The return is a functional on sections**: `ret γ r n`, and `ret_nonneg` / `cut_never_pays` are
  statements about it, not about any particular learner.
* **PBRS invariance is proved in two of its three forms.** (a) The *greedy set* form:
  adding a function of the state alone to every action's value leaves the argmax set unchanged
  (`greedy_invariant`; it needs only the order on the value object, not the finiteness of the
  heads). (b) The *Bellman* form: if `Vf` is a fixed point of the Bellman operator for the reward,
  then `Vf − φ` is a fixed point for the shaped reward — the value shifts by `φ` exactly
  (`RewardTheory.bellman_shift`, `TandoorHashemi.bellman_shift`, `sup'` over the heads, no
  `S`-finiteness). (c) What is NOT proved: that this fixed point is unique and is the optimal
  value — that needs a contraction argument (`|γ| < 1`, a complete value object) which is not in
  the file. The earlier wording of this bullet ("the optimal policy is unchanged, proved") claimed
  (c); it is corrected here to what the Lean actually contains.

## 4. What Ccc should print

The rule this design asks for: **no host arithmetic on reward units.** Concretely, add
`RequestProject.RewardTopos` to `HashemiCcc.lean`'s imports and `"rewardNames"` to its `notCompiled`
list; the driver then compiles, from `namespace TandoorHashemi`:

| definition | what is printed |
|---|---|
| `rewardRaw dt pIn reach` | the shaping in the parent's raw units, gated by `sun_reachable` |
| `rewardTrainer parentRaw dt pIn reach` | `(parentRaw + rewardRaw) / rewardDiv` — the single place `reward_div` appears |
| `rewardStep` (`Fin 3 → ℝ`), `rewardNames` | columns `r_shape_raw`, `r_raw`, `r_trainer` |
| `rewardDiv`, `cutPenalty`, `rotiReward`, `capShaping`, `rotiEnergy`, `stepDt` | the ini's constants as spec constants |
| `rewardOfRow` | the reward read off `hashemiEnv`'s own row (`p_in` = 20, `sun_reachable` = 13; `rewardOfRow_column_names` checks the names by `rfl`) |

Both paths of `hashemi_tandoor_env.py` then call the printed function (`hk_rewardStep` / its NumPy
twin / the Metal column) instead of `_shape_raw` plus a hand-placed division, and the ini's
`reward_div` / `cut_penalty` become inputs of the printed morphism rather than host floats.

TraceCheck-style checks to add (the same shape as the 30 measured optics theorems):

1. **R1, gluing.** Run a day on both paths; `|r_trainer_numpy − r_trainer_fused| ≤ 1e-6` per step.
   *This is the check that fails on bug 1* — it would have reported a factor of 75 on the first run.
2. **R2, the units.** `r_trainer · rewardDiv − parentRaw = r_shape_raw` per step (the naturality
   square, measured).
3. **R3, non-negativity.** `min over the day of r_shape_raw ≥ 0`. *This is the check that fails on
   bug 2*: any per-step penalty makes it negative, and `cut_never_pays` then no longer applies.
4. **R4, the coboundary.** With `pointing_shaping` on, the day's return minus the day's return
   without it equals `γⁿ φ(n) − φ(0)` to float tolerance (`shaping_telescopes`, measured).
5. **R5, the cut's ledger.** `cutValue give ≤ ret` over the remaining steps, at every step at which
   an agent was cut in the recorded day — the escape incentive measured rather than argued.

Only R1 and R3 are needed to have caught what was found; R2, R4 and R5 are what keeps it caught.

## Status: §4 is DONE (2026-09-19, the same day)

`lean/RewardTopos.lean` compiles against Mathlib v4.28.0 with **0 `sorry`**, and the part of §4 it
asked for is now printed: `lean/HashemiReward.lean` holds `rewardShapeRaw` and
`rewardStep : Fin 3 → ℝ` with `rewardNames`, **the constants as INPUTS** (the review's correction:
`rewardDiv`, `capShaping`, `rotiReward`, `rotiEnergy` are arguments, so the ini's values are the
kernel's inputs; `cutPenalty` and `stepDt` stay spec constants of RewardTopos, which is where the
cut's ledger is stated). The driver compiles it with the physics: `hk_rewardStep` in
`hashemi_ccc.h` / `hashemi_ccc.py`, the Float twin, the round trip `rewardStep_ccc` by `rfl`, and
its own kernel `hashemi_reward.metal` (8 inputs, 3 columns, 15 nodes, one thread per agent) - a
second launch, not three more columns of `hashemi_env`, because the parent's own reward for the
step exists only after the machine's step. `rewardStep_at_spec` (RewardTopos) ties it back to
this file's `rewardTrainer` at the spec's constants, definitionally.

`hashemi_tandoor_env.py` reads `r_shape_raw` / `r_raw` / `r_trainer` from that function on both
paths; `_shape_raw` is gone. The potential-based pointing term and `lost_shaping` (both off in
every ini) stay host-side - a coboundary and a gate, not units - and when on are folded into the
morphism's `parentRaw` input, so the division still happens once, inside the printed function.

**R1, R2, R3 are measured** by `test_reward_columns.py` (a day rolled on both paths; R1 also
re-runs every step of the numpy day through the Metal kernel on the same inputs, which is the
gluing condition with the physics held fixed). R4 and R5 are still only Lean statements.

/-
# Reward and learning for `puffer_hashemi_ccc`, in the language of topoi

The physics of this env is a Lean spec compiled by Ccc: one morphism `hashemiEnv` (HashemiEnv.lean),
its conditions as Ω-columns (`SunReachable`, `LostSun` in HashemiMega.lean), two runtimes printed
from the same graph (the C/NumPy twin and the Metal kernel). The REWARD was not: it was assembled
by hand in `hashemi_tandoor_env.py` on each path, and it was wrong twice (2026-09-19, commit
bb3c855):

1. the **unit** bug: the per-step shaping entered raw on the fused path and after `reward_div` on
   the NumPy path - the same section of the same object restricted two ways and the restrictions
   differed by a factor of 75. A family that does not agree on the overlap does not glue: there was
   no global section, so "the reward" did not exist.
2. the **escape** bug: a per-step penalty made the value of the cut - the morphism to the
   terminal object of the episode - larger than the value of staying. A day near the cliff cost 66
   against a cut of 1.

This file is the design: the site, the reward as a section over it, shaping as a coboundary, the cut
as a morphism to the terminal object, and the two bugs as the Props that would have refuted them.
Everything is stated over the actual definitions (`hashemiEnv`'s `p_in` and `sun_reachable` columns,
`reward_div = 75`, `cut_penalty = 75`, the seven-level heads of HashemiPolicy.lean).

See TOPOS_REWARD.md in tutorials/hashemi_ccc for the prose.
-/
import RequestProject.HashemiEnv
import RequestProject.HashemiReward
import RequestProject.HashemiPolicy
import RequestProject.Pareto
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace TandoorHashemi

open Finset

/-! ## 1. The constants of the glue, as spec constants

The trainer's numbers are `puffer_tandoor/hashemi_ccc.ini`: `reward_div = 75`, `cut_penalty = 75`,
`capture_shaping = 0.2`, `roti_kj = 130`, the parent's 5 raw per roti (`ROTI_REWARD_RAW`), the
15 s step. They are constants of the spec here, so that the printed reward carries them. -/

/-- the trainer's divisor: the raw reward of the parent env divided before PPO sees it -/
def rewardDiv : ℝ := 75

/-- the guillotine's cost in raw units -/
def cutPenalty : ℝ := 75

/-- the parent's raw reward for one roti -/
def rotiReward : ℝ := 5

/-- the shaping weight on the light at the receiver -/
def capShaping : ℝ := 0.2

/-- a roti's energy (J): `roti_kj = 130` -/
def rotiEnergy : ℝ := 130000

/-- the env's step (s) -/
def stepDt : ℝ := 15

theorem rewardDiv_pos : 0 < rewardDiv := by unfold rewardDiv; norm_num
theorem cutPenalty_nonneg : 0 ≤ cutPenalty := by unfold cutPenalty; norm_num

/-! ## 2. The reward morphism

`rewardRaw` is the light arriving at the receiver - `hashemiEnv`'s `p_in` column (index 20), gated
by its `sun_reachable` column (index 13) - as energy per step in roti units, at the parent's raw
price of a roti. ONE definition; both runtimes are to be printed from it (§6). -/

/-- **the shaping, in the parent's raw units**: `p_in · dt / rotiEnergy` rotis' worth of light this
step, priced at `capShaping · rotiReward`, gated by the sun's reach. -/
noncomputable def rewardRaw (dt pIn reach : ℝ) : ℝ :=
  capShaping * rotiReward * dt / rotiEnergy * pIn * reach

/-- **the reward the trainer sees**: the parent's raw reward plus the shaping, then divided once. -/
noncomputable def rewardTrainer (parentRaw dt pIn reach : ℝ) : ℝ :=
  (parentRaw + rewardRaw dt pIn reach) / rewardDiv

/-- the bug of 2026-09-19 on the NumPy path, written down: the shaping added AFTER the division
(i.e. in the wrong fibre of the unit torsor). -/
noncomputable def rewardTrainerUndivided (parentRaw dt pIn reach : ℝ) : ℝ :=
  parentRaw / rewardDiv + rewardRaw dt pIn reach

/-- **the unit bug as a Prop.** The two paths differ by `(1 - 1/75)` of the shaping: whenever any
light is captured they are not the same number, so the family `{numpy, fused}` over the one
object `step` does not glue. A single `rfl`-level check of this Prop in TraceCheck would have
failed on the first run. -/
theorem paths_disagree (parentRaw dt pIn reach : ℝ) (h : rewardRaw dt pIn reach ≠ 0) :
    rewardTrainerUndivided parentRaw dt pIn reach ≠ rewardTrainer parentRaw dt pIn reach := by
  unfold rewardTrainerUndivided rewardTrainer
  intro hEq
  apply h
  have hd : (rewardDiv : ℝ) ≠ 0 := ne_of_gt rewardDiv_pos
  field_simp at hEq
  -- `parentRaw + rewardRaw * rewardDiv = parentRaw + rewardRaw`
  have : rewardRaw dt pIn reach * rewardDiv = rewardRaw dt pIn reach := by linarith
  have h74 : rewardRaw dt pIn reach * (rewardDiv - 1) = 0 := by linarith [this]
  rcases mul_eq_zero.mp h74 with h1 | h2
  · exact h1
  · exfalso; unfold rewardDiv at h2; norm_num at h2

/-- and the size of the gap: exactly `reward_div - 1` times the shaping, over 75 -/
theorem paths_gap (parentRaw dt pIn reach : ℝ) :
    rewardTrainerUndivided parentRaw dt pIn reach - rewardTrainer parentRaw dt pIn reach
      = rewardRaw dt pIn reach * (1 - 1 / rewardDiv) := by
  unfold rewardTrainerUndivided rewardTrainer rewardDiv
  ring

/-- **the naturality square that must commute**: adding the shaping and then rescaling is the
same as rescaling both and adding. This is the only correct place to put `reward_div`, and it is a
`ring` identity - which is why one printed definition cannot get it wrong. -/
theorem scale_natural (parentRaw dt pIn reach : ℝ) :
    rewardTrainer parentRaw dt pIn reach
      = parentRaw / rewardDiv + rewardRaw dt pIn reach / rewardDiv := by
  unfold rewardTrainer; ring

/-- **non-negativity**: light is non-negative, the gate is non-negative, the step is positive. -/
theorem rewardRaw_nonneg {dt pIn reach : ℝ} (hdt : 0 ≤ dt) (hp : 0 ≤ pIn) (hr : 0 ≤ reach) :
    0 ≤ rewardRaw dt pIn reach := by
  unfold rewardRaw capShaping rotiReward rotiEnergy
  have : (0:ℝ) ≤ 0.2 * 5 * dt / 130000 := by positivity
  exact mul_nonneg (mul_nonneg this hp) hr

/-! ## 3. The site: stages, paths, and the day

The site whose sheaves are the right home for the reward has three kinds of cover of one object,
"this agent's step":

* the **composition cover** `mount ; rays ; heat ; pot` - the stages of `hashemiEnv`;
* the **implementation cover** `{numpy, fused}` - two restrictions of the same object;
* the **temporal cover** - a day covered by its steps, refined as in `hashemi_modula.py`'s sheaf
  check (restriction to a refinement is monotone, the sections glue).

A reward is a section of the presheaf of values over this site. The unit bug is a failure of the
gluing condition on the second cover; the escape bug is a failure on the third (§5). -/

/-- the stages of the env's step, in composition order (the four sub-morphisms of `hashemiEnv`) -/
inductive Stage | mount | rays | heat | pot
deriving DecidableEq, Repr

/-- the two runtimes of the same object -/
inductive Path | numpy | fused
deriving DecidableEq, Repr

/-- a candidate reward: a value on each runtime of the step -/
structure PathFamily where
  val : Path → ℝ

/-- **the gluing condition** on the implementation cover: the two restrictions agree on the
overlap (they are restrictions of the same step), so the family comes from a global section. -/
def Glues (f : PathFamily) : Prop := f.val Path.numpy = f.val Path.fused

/-- the family printed from ONE morphism glues, definitionally. -/
theorem printed_glues (parentRaw dt pIn reach : ℝ) :
    Glues ⟨fun _ => rewardTrainer parentRaw dt pIn reach⟩ := rfl

/-- the family assembled by hand did not (§2). -/
theorem handwritten_does_not_glue (parentRaw dt pIn reach : ℝ) (h : rewardRaw dt pIn reach ≠ 0) :
    ¬ Glues ⟨fun p => match p with
      | Path.numpy => rewardTrainerUndivided parentRaw dt pIn reach
      | Path.fused => rewardTrainer parentRaw dt pIn reach⟩ :=
  paths_disagree parentRaw dt pIn reach h

/-- the reward is supported on ONE stage of the composition cover: the rays (the light at the
receiver). `stageReward` is the summing functor of the cover; the step's reward is its sum. -/
noncomputable def stageReward (dt pIn reach : ℝ) : Stage → ℝ
  | Stage.rays => rewardRaw dt pIn reach
  | _ => 0

theorem stageReward_sum (dt pIn reach : ℝ) :
    stageReward dt pIn reach Stage.mount + stageReward dt pIn reach Stage.rays
      + stageReward dt pIn reach Stage.heat + stageReward dt pIn reach Stage.pot
      = rewardRaw dt pIn reach := by
  unfold stageReward; ring

/-! ## 4. Reward as a valuation, shaping as a coboundary

Marcolli's frame (Pareto.lean): objectives are categories with goals, a solution's valuation is an
object, dominance is a morphism, and a scalar reward is a *scalarization* - one reading of the
frontier, not the frontier. Here the two objectives are the light delivered and the rotis baked. -/

/-- the two objectives of a step: the light at the receiver and the rotis baked. -/
def rewardObjectives : Marcolli.ValuationSystem (ℝ × ℝ) (Fin 2) where
  V := fun _ => ℝ
  F := fun α x => if α = 0 then x.1 else x.2
  X := fun _ => 0

/-- the trainer's scalar reward is a scalarization of that system: monotone in every objective
(`≤` is the conversion in the thin category `ℝ`). -/
theorem reward_monotone_in_light {dt pIn pIn' reach : ℝ} (hdt : 0 ≤ dt) (hr : 0 ≤ reach)
    (h : pIn ≤ pIn') : rewardRaw dt pIn reach ≤ rewardRaw dt pIn' reach := by
  unfold rewardRaw
  have hc : (0:ℝ) ≤ capShaping * rotiReward * dt / rotiEnergy := by
    unfold capShaping rotiReward rotiEnergy; positivity
  exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left h hc) hr

/-- the (undiscounted-shape) return of a run: `∑ γⁱ r i` -/
noncomputable def ret (γ : ℝ) (r : ℕ → ℝ) (n : ℕ) : ℝ := ∑ i ∈ range n, γ ^ i * r i

/-- **potential-based shaping is a coboundary**: `δφ i = γ φ(i+1) - φ i` telescopes, so the return
changes by a boundary term only - the class of the reward 1-cochain is unchanged. This is the
`pointing_shaping` term of `hashemi_tandoor_env.py::_shape_raw`. -/
theorem shaping_telescopes (γ : ℝ) (r φ : ℕ → ℝ) (n : ℕ) :
    ret γ (fun i => r i + (γ * φ (i + 1) - φ i)) n = ret γ r n + γ ^ n * φ n - φ 0 := by
  induction n with
  | zero => simp [ret]
  | succ n ih =>
      simp only [ret, Finset.sum_range_succ] at ih ⊢
      rw [ih]; ring

/-- with `γ = 1` (the cut's own accounting) the boundary is `φ n - φ 0`. -/
theorem shaping_telescopes_one (r φ : ℕ → ℝ) (n : ℕ) :
    ret 1 (fun i => r i + (φ (i + 1) - φ i)) n = ret 1 r n + φ n - φ 0 := by
  have := shaping_telescopes 1 r φ n
  simpa using this

/-! ### PBRS policy invariance for the discrete heads

The action set of the machine is the two seven-level heads of HashemiPolicy.lean
(`actionLevels = 7`, `headToCmd`), i.e. `Fin 7 × Fin 7` - finite, so "the optimal policy is
unchanged" is the statement that the argmax SET over that finite type is unchanged when a function
of the STATE ALONE is added to every action's value. -/

/-- the machine's action set: the two seven-level heads -/
abbrev Heads := Fin actionLevels × Fin actionLevels

/-- the greedy set of a value function over the heads -/
def Greedy {S : Type} (Q : S → Heads → ℝ) (s : S) : Set Heads := {a | ∀ b, Q s b ≤ Q s a}

/-- **PBRS policy invariance, discrete heads**: adding a state potential to every action's value
leaves the greedy set - hence the optimal policy - unchanged. -/
theorem greedy_invariant {S : Type} (Q : S → Heads → ℝ) (φ : S → ℝ) (s : S) :
    Greedy (fun s a => Q s a + φ s) s = Greedy Q s := by
  ext a
  simp [Greedy, add_le_add_iff_right]

/-! ## 5. The cut as a morphism to the terminal object

The guillotine ends the episode: it is the unique morphism `step ⟶ ⊤`, and the value of `⊤` is
0 continuation minus what the cut costs (`cut_penalty = 75` raw, plus the `give` of the dough
wiped, `tandoor_hashemi_env.py:1572`). Leaving pays exactly when the value of the remaining
section is below that. -/

/-- the raw value of taking the cut now -/
noncomputable def cutValue (give : ℝ) : ℝ := -(give + cutPenalty)

/-- a non-negative per-step reward has a non-negative return (any `n`, any `0 ≤ γ`). -/
theorem ret_nonneg {γ : ℝ} (hγ : 0 ≤ γ) {r : ℕ → ℝ} (hr : ∀ i, 0 ≤ r i) (n : ℕ) :
    0 ≤ ret γ r n := by
  unfold ret
  exact Finset.sum_nonneg fun i _ => mul_nonneg (pow_nonneg hγ i) (hr i)

/-- **non-negative reward makes leaving never pay** (the design rule of commit bb3c855): if every
step's reward is non-negative and the cut costs something non-negative, the cut's value never
exceeds the value of staying to the end of the day. -/
theorem cut_never_pays {γ give : ℝ} (hγ : 0 ≤ γ) (hg : 0 ≤ give) {r : ℕ → ℝ}
    (hr : ∀ i, 0 ≤ r i) (n : ℕ) : cutValue give ≤ ret γ r n := by
  have h0 := ret_nonneg hγ hr n
  have : cutValue give ≤ 0 := by
    unfold cutValue
    have : 0 ≤ give + cutPenalty := by have := cutPenalty_nonneg; linarith
    linarith
  linarith

/-- **the escape bug as a Prop**: with a strictly negative per-step reward, a long enough day is
worse than the cut - the policy learns to leave. (γ = 1; `exists_nat_gt` supplies the day.) -/
theorem escape_pays {c give : ℝ} (hc : 0 < c) (_hg : 0 ≤ give) :
    ∃ n : ℕ, ret 1 (fun _ => -c) n < cutValue give := by
  obtain ⟨n, hn⟩ := exists_nat_gt ((give + cutPenalty) / c)
  refine ⟨n, ?_⟩
  have hsum : ret 1 (fun _ => -c) n = -(n * c) := by
    unfold ret; simp [Finset.sum_const, nsmul_eq_mul]
  have : (give + cutPenalty) < n * c := by
    have := (div_lt_iff₀ hc).mp hn
    linarith
  rw [hsum]; unfold cutValue; linarith

/-- the run that was measured: a day held at 4° of pointing error cost 66 in trainer units under
the old per-step penalty, against 1 for the cut (`cut_penalty / reward_div = 1`). -/
noncomputable def cutCostTrainer : ℝ := cutPenalty / rewardDiv

theorem cutCostTrainer_one : cutCostTrainer = 1 := by
  unfold cutCostTrainer cutPenalty rewardDiv; norm_num

theorem measured_escape : cutCostTrainer < 66 := by
  rw [cutCostTrainer_one]; norm_num

/-! ## 6. What Ccc should print

`rewardStep` is the reward as a morphism with columns, and it is now COMPILED: it lives in
HashemiReward.lean (with its constants as arguments, so the ini's values are inputs of the printed
function), the driver imports it and prints `hk_rewardStep`, the Float twin, the round trip and the
kernel `hashemi_reward.metal`, and `hashemi_tandoor_env.py` reads its columns on both paths. The
units are PRINTED, not assembled. -/

/-- **the reward's columns** are `rewardStep` (HashemiReward.lean), the file the driver compiles: its
constants are ARGUMENTS, so the ini's values are inputs of the printed morphism.  At the spec's
own constants it is this file's reward, definitionally. -/
theorem rewardStep_at_spec (parentRaw dt pIn reach : ℝ) :
    rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy
      = ![rewardRaw dt pIn reach,
          parentRaw + rewardRaw dt pIn reach,
          rewardTrainer parentRaw dt pIn reach] := rfl

/-- the reward read off `hashemiEnv`'s own row: `p_in` is column 20 and `sun_reachable` column 13
of `envNames` - no host arithmetic on units at all. -/
noncomputable def rewardOfRow (parentRaw dt : ℝ) (row : Fin 83 → ℝ) : ℝ :=
  rewardTrainer parentRaw dt (row 20) (row 13)

theorem rewardOfRow_column_names :
    envNames[20]! = "p_in" ∧ envNames[13]! = "sun_reachable" := by
  constructor <;> rfl

/-- the same statement the TraceCheck rows should measure: on a row with non-negative light and
the Boolean gate, the trainer's reward is at least the parent's own, divided. -/
theorem rewardOfRow_ge {parentRaw dt : ℝ} {row : Fin 83 → ℝ} (hdt : 0 ≤ dt)
    (hp : 0 ≤ row 20) (hr : 0 ≤ row 13) :
    parentRaw / rewardDiv ≤ rewardOfRow parentRaw dt row := by
  unfold rewardOfRow
  rw [scale_natural]
  have h := rewardRaw_nonneg hdt hp hr
  have : 0 ≤ rewardRaw dt (row 20) (row 13) / rewardDiv :=
    div_nonneg h (le_of_lt rewardDiv_pos)
  linarith

end TandoorHashemi

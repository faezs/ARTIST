/-
# The reward of `puffer_hashemi_ccc` as ONE INSTANCE of RewardTheory

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

Neither argument is about this env. **RewardTheory.lean** is the theory - gluing, units as change
of base, the truncation morphism, shaping as a coboundary - parametrized over a state type, an
action type, a value object, a transition and a truncation, with no import from here. This file is
the INSTANCE: `S` = the env's 83-column row paired with the parent's raw reward for the step,
`A` = the two seven-level heads `Fin 7 × Fin 7`, `V` = ℝ, the transition = the env's own step, the
truncation = the guillotine. Every theorem below is derived from the generic one; the only proofs
that remain here are the arithmetic of THIS reward (its constants, its columns) and the facts that
tie it to `HashemiReward.lean`, the file the driver compiles.

See TOPOS_REWARD.md in tutorials/hashemi_ccc for the prose, and TandoorRewardInstance.lean for the
second instance (the parent tandoor's own reward), which is what shows the layering carries.
-/
import RequestProject.HashemiEnv
import RequestProject.HashemiReward
import RequestProject.HashemiPolicy
import RequestProject.Pareto
import RequestProject.RewardTheory
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

/-! ## 2. The parameters of the instance

`RewardTheory` asks for five things. Here they are, once:

* the **state** `HState`: the env's own row (`hashemiEnv`'s 83 columns) together with the parent
  env's raw reward for the step - the parent computes its reward AFTER the machine's step, which
  is exactly why `rewardStep` is a second kernel and not three more columns of `hashemi_env`;
* the **action** `Heads`: the two seven-level heads of HashemiPolicy.lean;
* the **value object** ℝ;
* the **transition**: the env's step, as any `HState → Heads → HState` (nothing below depends on
  which one it is - the theorems hold for the env's own);
* the **truncation**: the guillotine, `cutValue give = -(give + cutPenalty) ≤ 0`. -/

/-- the machine's action set: the two seven-level heads -/
abbrev Heads := Fin actionLevels × Fin actionLevels

instance : NeZero actionLevels := ⟨by unfold actionLevels; decide⟩
instance : Inhabited Heads := ⟨(0, 0)⟩

/-- the state a reward is asserted at: `hashemiEnv`'s row and the parent's raw reward for the step -/
abbrev HState := (Fin 96 → ℝ) × ℝ

/-- the env's transition, as a parameter of the instance -/
abbrev hashemiDyn (next : HState → Heads → HState) : RewardTheory.Dynamics HState Heads :=
  ⟨next⟩

/-! ## 3. The reward morphism

`rewardRaw` is the light arriving at the receiver - `hashemiEnv`'s `p_in` column (index 20), gated
by its `sun_reachable` column (index 13) - as energy per step in roti units, at the parent's raw
price of a roti. ONE definition; both runtimes are printed from it (§7). -/

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
  have hmul : rewardRaw dt pIn reach * rewardDiv = rewardRaw dt pIn reach := by linarith
  have h74 : rewardRaw dt pIn reach * (rewardDiv - 1) = 0 := by linarith [hmul]
  rcases mul_eq_zero.mp h74 with h1 | h2
  · exact h1
  · exfalso; unfold rewardDiv at h2; norm_num at h2

/-- and the size of the gap: exactly `reward_div - 1` times the shaping, over 75 -/
theorem paths_gap (parentRaw dt pIn reach : ℝ) :
    rewardTrainerUndivided parentRaw dt pIn reach - rewardTrainer parentRaw dt pIn reach
      = rewardRaw dt pIn reach * (1 - 1 / rewardDiv) := by
  unfold rewardTrainerUndivided rewardTrainer rewardDiv
  ring

/-- **the naturality square that must commute** (THEOREM 2 of RewardTheory, at `d = rewardDiv`):
adding the shaping and then rescaling is rescaling both and adding. This is the only correct place
to put `reward_div`. -/
theorem scale_natural (parentRaw dt pIn reach : ℝ) :
    rewardTrainer parentRaw dt pIn reach
      = parentRaw / rewardDiv + rewardRaw dt pIn reach / rewardDiv :=
  RewardTheory.add_div_eq parentRaw (rewardRaw dt pIn reach) rewardDiv

/-- **non-negativity**: light is non-negative, the gate is non-negative, the step is positive. -/
theorem rewardRaw_nonneg {dt pIn reach : ℝ} (hdt : 0 ≤ dt) (hp : 0 ≤ pIn) (hr : 0 ≤ reach) :
    0 ≤ rewardRaw dt pIn reach := by
  unfold rewardRaw capShaping rotiReward rotiEnergy
  have : (0:ℝ) ≤ 0.2 * 5 * dt / 130000 := by positivity
  exact mul_nonneg (mul_nonneg this hp) hr

/-! ## 4. The site: stages, paths, and the day

The site whose sheaves are the right home for the reward has three kinds of cover of one object,
"this agent's step":

* the **composition cover** `mount ; rays ; heat ; pot` - the stages of `hashemiEnv`;
* the **implementation cover** `{numpy, fused}` - two restrictions of the same object;
* the **temporal cover** - a day covered by its steps, refined as in `hashemi_modula.py`'s sheaf
  check.

Gluing on the second cover is `RewardTheory.glue`; the summing functor over the first is
`RewardTheory.Summed`. -/

/-- the stages of the env's step, in composition order (the four sub-morphisms of `hashemiEnv`) -/
inductive Stage | mount | rays | heat | pot
deriving DecidableEq, Repr, Fintype

/-- the two runtimes of the same object -/
inductive Path | numpy | fused
deriving DecidableEq, Repr

/-- a candidate reward: a value on each runtime of the step -/
abbrev PathFamily := RewardTheory.PathFamily Path ℝ

/-- **the gluing condition** on the implementation cover: the restrictions agree (they are
restrictions of the same step), so the family comes from a global section. -/
abbrev Glues (f : PathFamily) : Prop := f.Glues

/-- the family printed from ONE morphism glues, definitionally (`RewardTheory.glues_const`). -/
theorem printed_glues (parentRaw dt pIn reach : ℝ) :
    Glues ⟨fun _ => rewardTrainer parentRaw dt pIn reach⟩ :=
  RewardTheory.glues_const _

/-- the family assembled by hand did not (§3). -/
theorem handwritten_does_not_glue (parentRaw dt pIn reach : ℝ) (h : rewardRaw dt pIn reach ≠ 0) :
    ¬ Glues ⟨fun p => match p with
      | Path.numpy => rewardTrainerUndivided parentRaw dt pIn reach
      | Path.fused => rewardTrainer parentRaw dt pIn reach⟩ := by
  intro hg
  exact paths_disagree parentRaw dt pIn reach h (hg Path.numpy Path.fused)

/-! ### The 75x bug as an instance of `RewardTheory.not_model_of_scaled`

The reward's columns as a TERM in the generic language: atoms are what a runtime reads off the
state (`p_in`, `sun_reachable`, the step, the parent's raw reward), and `shapeTerm` is the shaping.
The canonical model is the printed morphism; a path that returns 75x the shaping is then provably
not a model of it, which is the unit bug with no arithmetic of this env in the proof. -/

/-- the columns a runtime of this reward may read -/
inductive Atom | parentRaw | dt | pIn | reach
deriving DecidableEq, Repr

/-- how the env's row answers them: `p_in` is column 20, `sun_reachable` column 13 -/
noncomputable def hashemiAtoms : Atom → HState → Heads → ℝ
  | Atom.parentRaw => fun s _ => s.2
  | Atom.dt => fun _ _ => stepDt
  | Atom.pIn => fun s _ => s.1 20
  | Atom.reach => fun s _ => s.1 13

/-- the shaping as a term: `capShaping · rotiReward / rotiEnergy · dt · p_in · sun_reachable`
(the constant is the rational `0.2 · 5 / 130000`). -/
def shapeTerm : RewardTheory.Term Atom :=
  .mul (.mul (.mul (.num (1/130000)) (.atom Atom.dt)) (.atom Atom.pIn)) (.atom Atom.reach)

/-- the printed morphism is the canonical model of the columns. -/
noncomputable abbrev hashemiModel : RewardTheory.Model Atom HState Heads ℝ :=
  RewardTheory.stdModel hashemiAtoms

/-- **the 75x bug, as the generic corollary.** No model of these columns returns `rewardDiv` times
the shaping wherever the shaping is non-zero: the handwritten NumPy path was not a model of the
reward, so the family had no global section. -/
theorem handwritten_not_a_model (N : RewardTheory.Model Atom HState Heads ℝ)
    (hN : N.atom = hashemiAtoms) (s : HState) (a : Heads)
    (hne : hashemiModel.ev shapeTerm s a ≠ 0) :
    N.ev shapeTerm s a ≠ rewardDiv * hashemiModel.ev shapeTerm s a :=
  RewardTheory.not_model_of_scaled hashemiModel N hN shapeTerm rewardDiv
    (by unfold rewardDiv; norm_num) s a hne

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

/-- the same cover as a `RewardTheory.Summed`, so that the generic unit theorems apply to it -/
noncomputable def stageSummed : RewardTheory.Summed Stage HState Heads ℝ :=
  ⟨fun x s _ => stageReward stepDt (s.1 20) (s.1 13) x⟩

/-- **the divided reward is the division of the reward**, on this cover (THEOREM 2). -/
theorem stageSummed_div (s : HState) (a : Heads) :
    stageSummed.total s a / rewardDiv = ∑ x : Stage, stageSummed.stage x s a / rewardDiv :=
  RewardTheory.Summed.total_div rewardDiv stageSummed s a

/-! ## 5. Reward as a valuation

Marcolli's frame (Pareto.lean): objectives are categories with goals, a solution's valuation is an
object, dominance is a morphism, and a scalar reward is a *scalarization* - one reading of the
frontier, not the frontier. -/

/-- the two objectives of a step: the light at the receiver and the rotis baked. -/
def rewardObjectives : Marcolli.ValuationSystem (ℝ × ℝ) (Fin 2) where
  V := fun _ => ℝ
  F := fun α x => if α = 0 then x.1 else x.2
  X := fun _ => 0

/-- the trainer's scalar reward is a scalarization of that system: monotone in every objective
(`≤` is the conversion in the thin category `ℝ`; `RewardTheory.monotone_of_nonneg_scale`). -/
theorem reward_monotone_in_light {dt pIn pIn' reach : ℝ} (hdt : 0 ≤ dt) (hr : 0 ≤ reach)
    (h : pIn ≤ pIn') : rewardRaw dt pIn reach ≤ rewardRaw dt pIn' reach := by
  unfold rewardRaw
  have hc : (0:ℝ) ≤ capShaping * rotiReward * dt / rotiEnergy := by
    unfold capShaping rotiReward rotiEnergy; positivity
  exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left h hc) hr

/-! ## 6. The cut as a morphism to the terminal object, and shaping

The guillotine ends the episode: it is the unique morphism `step ⟶ ⊤`, and the value of `⊤` is
0 continuation minus what the cut costs (`cut_penalty = 75` raw, plus the `give` of the dough
wiped, `tandoor_hashemi_env.py:1572`). This is `RewardTheory.Truncation`; §3 of the theory is the
whole argument. -/

/-- the return of a run: `∑ γⁱ r i` - `RewardTheory.ret` at `V = ℝ` -/
noncomputable abbrev ret (γ : ℝ) (r : ℕ → ℝ) (n : ℕ) : ℝ := RewardTheory.ret γ r n

/-- the raw value of taking the cut now -/
noncomputable def cutValue (give : ℝ) : ℝ := -(give + cutPenalty)

/-- the guillotine as the instance's truncation morphism: its value is `≤ 0`. -/
noncomputable def hashemiCut (give : ℝ) (hg : 0 ≤ give) : RewardTheory.Truncation ℝ where
  value := cutValue give
  nonpos := by unfold cutValue; have := cutPenalty_nonneg; linarith

/-- a non-negative per-step reward has a non-negative return (`RewardTheory.ret_nonneg`). -/
theorem ret_nonneg {γ : ℝ} (hγ : 0 ≤ γ) {r : ℕ → ℝ} (hr : ∀ i, 0 ≤ r i) (n : ℕ) :
    0 ≤ ret γ r n := RewardTheory.ret_nonneg hγ hr n

/-- **non-negative reward makes leaving never pay** (the design rule of commit bb3c855), the
non-positivity of `hashemiCut` against `RewardTheory.ret_nonneg`. -/
theorem cut_never_pays {γ give : ℝ} (hγ : 0 ≤ γ) (hg : 0 ≤ give) {r : ℕ → ℝ}
    (hr : ∀ i, 0 ≤ r i) (n : ℕ) : cutValue give ≤ ret γ r n :=
  le_trans (hashemiCut give hg).nonpos (ret_nonneg hγ hr n)

/-- the same statement along the env's own transition (`RewardTheory.trunc_never_beats`): for ANY
step function, any plan and any state, the cut never beats continuing when the per-step reward is
non-negative. -/
theorem cut_never_pays_along (next : HState → Heads → HState) {γ give : ℝ} (hγ : 0 ≤ γ)
    (hg : 0 ≤ give) {r : HState → Heads → ℝ} (hr : ∀ s a, 0 ≤ r s a) (s : HState)
    (π : ℕ → Heads) (n : ℕ) :
    cutValue give ≤ (hashemiDyn next).retAlong r γ s π n :=
  RewardTheory.trunc_never_beats (hashemiCut give hg) (hashemiDyn next) hγ hr s π n

/-- **the escape bug as a Prop** (`RewardTheory.exists_horizon_trunc_wins`): with a strictly
negative per-step reward, a long enough day is worse than the cut - the policy learns to leave. -/
theorem escape_pays {c give : ℝ} (hc : 0 < c) (hg : 0 ≤ give) :
    ∃ n : ℕ, ret 1 (fun _ => -c) n < cutValue give := by
  obtain ⟨n, hn⟩ := RewardTheory.exists_horizon_trunc_wins (hashemiCut give hg)
    (hashemiDyn (fun s _ => s)) (r := fun _ _ => -c) hc (fun _ _ => le_refl _)
    (fun _ => 0, 0) (fun _ => default)
  exact ⟨n, hn⟩

/-- the run that was measured: a day held at 4° of pointing error cost 66 in trainer units under
the old per-step penalty, against 1 for the cut (`cut_penalty / reward_div = 1`). -/
noncomputable def cutCostTrainer : ℝ := cutPenalty / rewardDiv

theorem cutCostTrainer_one : cutCostTrainer = 1 := by
  unfold cutCostTrainer cutPenalty rewardDiv; norm_num

theorem measured_escape : cutCostTrainer < 66 := by
  rw [cutCostTrainer_one]; norm_num

/-! ### Shaping (THEOREM 4), at this env's heads -/

/-- **potential-based shaping is a coboundary** (`RewardTheory.shaping_telescopes`): the return
changes by a boundary term only - the class of the reward 1-cochain is unchanged. This is the
`pointing_shaping` term of `hashemi_tandoor_env.py::_shape_raw`. -/
theorem shaping_telescopes (γ : ℝ) (r φ : ℕ → ℝ) (n : ℕ) :
    ret γ (fun i => r i + (γ * φ (i + 1) - φ i)) n = ret γ r n + γ ^ n * φ n - φ 0 :=
  RewardTheory.shaping_telescopes γ r φ n

/-- with `γ = 1` (the cut's own accounting) the boundary is `φ n - φ 0`. -/
theorem shaping_telescopes_one (r φ : ℕ → ℝ) (n : ℕ) :
    ret 1 (fun i => r i + (φ (i + 1) - φ i)) n = ret 1 r n + φ n - φ 0 :=
  RewardTheory.shaping_telescopes_one r φ n

/-- the greedy set of a value function over the heads -/
abbrev Greedy {S : Type} (Q : S → Heads → ℝ) (s : S) : Set Heads := RewardTheory.Greedy Q s

/-- **PBRS policy invariance, discrete heads** (`RewardTheory.greedy_invariant`): adding a state
potential to every action's value leaves the greedy set - hence the optimal policy - unchanged. -/
theorem greedy_invariant {S : Type} (Q : S → Heads → ℝ) (φ : S → ℝ) (s : S) :
    Greedy (fun s a => Q s a + φ s) s = Greedy Q s :=
  RewardTheory.greedy_invariant Q φ s

/-- **the Bellman version** (`RewardTheory.bellman_shift`), at this env's heads: if `Vf` is a fixed
point of the Bellman operator for the reward, `Vf - φ` is one for the shaped reward - the value
shifts by `φ` exactly. -/
theorem bellman_shift (next : HState → Heads → HState) (r : HState → Heads → ℝ) (γ : ℝ)
    (φ : HState → ℝ) {Vf : HState → ℝ} (h : (hashemiDyn next).BellmanFixed r γ Vf) :
    (hashemiDyn next).BellmanFixed ((hashemiDyn next).shaped r γ φ) γ (fun s => Vf s - φ s) :=
  RewardTheory.bellman_shift (hashemiDyn next) r γ φ h

/-! ## 7. What Ccc prints

`rewardStep` is the reward as a morphism with columns, and it is COMPILED: it lives in
HashemiReward.lean (with its constants as arguments, so the ini's values are inputs of the printed
function), the driver imports it and prints `hk_rewardStep`, the Float twin, the round trip and the
kernel `hashemi_reward.metal`, and `hashemi_tandoor_env.py` reads its columns on both paths. The
units are PRINTED, not assembled. -/

/-- **the reward's columns** are `rewardStep` (HashemiReward.lean), the file the driver compiles: its
constants are ARGUMENTS, so the ini's values are inputs of the printed morphism.  At the spec's
own constants it is this file's reward, definitionally. -/
theorem rewardStep_at_spec (parentRaw dt pIn reach : ℝ) :
    rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy 0 0 0 0
      = ![rewardRaw dt pIn reach, 0, 0,
          parentRaw + rewardRaw dt pIn reach,
          rewardTrainer parentRaw dt pIn reach] := by
  simp only [rewardStep, pumpCostRaw, degCostRaw, rewardTrainer, rewardRaw, rewardShapeRaw]
  norm_num

/-- the reward read off `hashemiEnv`'s own row: `p_in` is column 20 and `sun_reachable` column 13
of `envNames` - no host arithmetic on units at all. -/
noncomputable def rewardOfRow (parentRaw dt : ℝ) (row : Fin 96 → ℝ) : ℝ :=
  rewardTrainer parentRaw dt (row 20) (row 13)

theorem rewardOfRow_column_names :
    envNames[20]! = "p_in" ∧ envNames[13]! = "sun_reachable" := by
  constructor <;> rfl

/-- the same statement the TraceCheck rows should measure: on a row with non-negative light and
the Boolean gate, the trainer's reward is at least the parent's own, divided. -/
theorem rewardOfRow_ge {parentRaw dt : ℝ} {row : Fin 96 → ℝ} (hdt : 0 ≤ dt)
    (hp : 0 ≤ row 20) (hr : 0 ≤ row 13) :
    parentRaw / rewardDiv ≤ rewardOfRow parentRaw dt row := by
  unfold rewardOfRow
  rw [scale_natural]
  have h := rewardRaw_nonneg hdt hp hr
  have : 0 ≤ rewardRaw dt (row 20) (row 13) / rewardDiv :=
    div_nonneg h (le_of_lt rewardDiv_pos)
  linarith

end TandoorHashemi

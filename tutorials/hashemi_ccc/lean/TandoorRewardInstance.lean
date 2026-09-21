/-
# The parent tandoor's own reward, as a SECOND instance of RewardTheory

`RewardTopos.lean` instantiates the theory with `puffer_hashemi_ccc`. This file does the same for a
different env - `tutorials/tandoor_rl_env.py`, the parent tandoor, whose reward is nothing like the
machine's: 5 raw per roti cooked and −5 per roti scorched (`rew += 5.0 * cooked.sum(1) − 5.0 *
scorched.sum(1)`), a holding cost on in-flight dough, the doneness potential
(`2 · Σ clip(bread_E / roti_energy)`, telescoped), the banded **belt-rise** potential
(`0.05 · Σ clip(min(T', LO) − min(T, LO))`, which is the coboundary of
`φ(T) = 0.05 · Σ min(T, LO)`), the guillotine at 75 raw, and `reward_div`.

Nothing of the tandoor's code is touched and nothing is imported from the Hashemi files: the point
is that the four theorems cost a page here, with no proof repeated. The state is the belt's
temperatures and the dough's energy, the action is which bins the cook loads and pulls, the value
object is ℝ, the transition is the env's own step (any function - the theorems do not look at it)
and the truncation is the day's cut.
-/
import RequestProject.RewardTheory
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace TandoorParent

open RewardTheory

/-! ## 1. The parameters -/

/-- the belt has eight bins (`n_belt = 8`) -/
abbrev nBelt : ℕ := 8

/-- the state: the belt's temperatures and the dough's accumulated energy per bin -/
abbrev TState := (Fin nBelt → ℝ) × (Fin nBelt → ℝ)

/-- the action: load / pull / idle at each bin (the cook's heads) -/
abbrev TAction := Fin nBelt → Bool

instance : Inhabited TAction := ⟨fun _ => false⟩

/-- the env's step, as a parameter -/
abbrev tandoorDyn (next : TState → TAction → TState) : Dynamics TState TAction := ⟨next⟩

/-! ## 2. The constants (`tandoor_rl_env.py`) -/

/-- 5 raw per roti cooked -/
def rotiReward : ℝ := 5

/-- 5 raw charged back per roti scorched at 730 K -/
def scorchPenalty : ℝ := 5

/-- the guillotine, as in the machine's env -/
def cutPenalty : ℝ := 75

/-- the trainer's divisor -/
def rewardDiv : ℝ := 75

/-- the weight of the banded belt-rise potential -/
def beltWeight : ℝ := 0.05

/-- the top of the cooking band: `T_COOK_LO` -/
def cookLo : ℝ := 453

theorem rewardDiv_pos : 0 < rewardDiv := by unfold rewardDiv; norm_num

/-! ## 3. The reward and its units (THEOREM 2)

The bread's economics, then the potential terms, then ONE division - the same discipline the
machine's env got by being printed. -/

/-- the bread's economics for a step: `5 · cooked − 5 · scorched` -/
def breadRaw (cooked scorched : ℝ) : ℝ := rotiReward * cooked - scorchPenalty * scorched

/-- the trainer's reward: the raw reward (bread plus the shaping terms) divided ONCE -/
noncomputable def trainer (raw : ℝ) : ℝ := raw / rewardDiv

/-- **the naturality square** (`RewardTheory.add_div_eq`): dividing the total is dividing each
term. The only place `reward_div` may appear. -/
theorem trainer_add (bread shaping : ℝ) :
    trainer (bread + shaping) = trainer bread + trainer shaping :=
  RewardTheory.add_div_eq bread shaping rewardDiv

/-- the reward as a summing functor over the named terms of the env's step -/
inductive Term2 | bread | holding | doneness | beltRise
deriving DecidableEq, Repr, Fintype

/-- **the divided reward is the division of the reward** (`RewardTheory.Summed.total_div`), on the
tandoor's own cover of terms. -/
theorem terms_div (R : Summed Term2 TState TAction ℝ) (s : TState) (a : TAction) :
    R.total s a / rewardDiv = ∑ x : Term2, R.stage x s a / rewardDiv :=
  RewardTheory.Summed.total_div rewardDiv R s a

/-! ## 4. Gluing (THEOREM 1)

The tandoor has a torch twin and a NumPy twin of the same step. The same corollary applies: a path
that returns the reward scaled by `reward_div` is not a model of it. -/

/-- the columns a runtime of this reward reads -/
inductive Atom2 | cooked | scorched | phiNew | phiOld
deriving DecidableEq, Repr

/-- how the state answers them (the dough's energy is the doneness potential's argument) -/
noncomputable def tandoorAtoms : Atom2 → TState → TAction → ℝ
  | Atom2.cooked => fun _ a => (Finset.univ.filter fun i => a i).card
  | Atom2.scorched => fun s _ => ∑ i, max (s.1 i - 730) 0
  | Atom2.phiNew => fun s _ => beltWeight * ∑ i, min (s.1 i) cookLo
  | Atom2.phiOld => fun s _ => beltWeight * ∑ i, min (s.2 i) cookLo

/-- the bread term as a syntactic term: `5 · cooked − 5 · scorched` -/
def breadTerm : Term Atom2 :=
  .add (.mul (.num 5) (.atom Atom2.cooked)) (.mul (.num (-5)) (.atom Atom2.scorched))

noncomputable abbrev tandoorModel : Model Atom2 TState TAction ℝ := stdModel tandoorAtoms

/-- **the unit bug, for this env**: no model of these columns returns `reward_div` times the bread
term where that term is non-zero. Two runtimes that disagree by the divisor do not glue, so there
is no reward. -/
theorem scaled_path_not_a_model (N : Model Atom2 TState TAction ℝ) (hN : N.atom = tandoorAtoms)
    (s : TState) (a : TAction) (hne : tandoorModel.ev breadTerm s a ≠ 0) :
    N.ev breadTerm s a ≠ rewardDiv * tandoorModel.ev breadTerm s a :=
  not_model_of_scaled tandoorModel N hN breadTerm rewardDiv (by unfold rewardDiv; norm_num) s a hne

/-! ## 5. The cut (THEOREM 3) -/

/-- the day's cut: `−(give + cut_penalty)`, the wiped in-flight dough included -/
noncomputable def cutValue (give : ℝ) : ℝ := -(give + cutPenalty)

/-- the cut as the truncation morphism -/
noncomputable def tandoorCut (give : ℝ) (hg : 0 ≤ give) : Truncation ℝ where
  value := cutValue give
  nonpos := by unfold cutValue cutPenalty; linarith

/-- **truncating never beats continuing** while nothing scorches and the potentials rise: the
generic theorem, at the tandoor's cut and the tandoor's transition. -/
theorem cut_never_pays (next : TState → TAction → TState) {γ give : ℝ} (hγ : 0 ≤ γ)
    (hg : 0 ≤ give) {r : TState → TAction → ℝ} (hr : ∀ s a, 0 ≤ r s a) (s : TState)
    (π : ℕ → TAction) (n : ℕ) :
    cutValue give ≤ (tandoorDyn next).retAlong r γ s π n :=
  trunc_never_beats (tandoorCut give hg) (tandoorDyn next) hγ hr s π n

/-- **and the converse**: the holding cost alone (`−0.03/loaves_per_load` per in-flight loaf, with
no bread paid) is a strictly negative per-step reward, and there is then a day at which stuffing
the oven and cutting beats cooking. -/
theorem holding_cost_escape (next : TState → TAction → TState) {c give : ℝ} (hc : 0 < c)
    (hg : 0 ≤ give) (s : TState) (π : ℕ → TAction) :
    ∃ n : ℕ, (tandoorDyn next).retAlong (fun _ _ => -c) 1 s π n < cutValue give := by
  obtain ⟨n, hn⟩ := exists_horizon_trunc_wins (tandoorCut give hg) (tandoorDyn next) hc
    (fun _ _ => le_refl _) s π
  exact ⟨n, hn⟩

/-! ## 6. The belt-rise potential is a coboundary (THEOREM 4) -/

/-- the banded belt potential the env telescopes: `0.05 · Σ min(T, T_COOK_LO)` -/
noncomputable def beltPotential (T : Fin nBelt → ℝ) : ℝ :=
  beltWeight * ∑ i, min (T i) cookLo

/-- the env's per-step term IS `φ(T') − φ(T)` (`rew += 0.05 * (min(T', LO) − min(T, LO)).sum()`,
before the ±5 clip). -/
theorem beltRise_is_coboundary (T T' : Fin nBelt → ℝ) :
    beltWeight * ∑ i, (min (T' i) cookLo - min (T i) cookLo)
      = beltPotential T' - beltPotential T := by
  unfold beltPotential
  rw [Finset.sum_sub_distrib, mul_sub]

/-- **the return changes by a boundary term only** (`RewardTheory.shaping_telescopes_one`): the
belt-rise term is free - it cannot change what the policy optimizes, only how fast it is found. -/
theorem beltRise_telescopes (r : ℕ → ℝ) (T : ℕ → Fin nBelt → ℝ) (n : ℕ) :
    RewardTheory.ret 1 (fun i => r i + (beltPotential (T (i + 1)) - beltPotential (T i))) n
      = RewardTheory.ret 1 r n + beltPotential (T n) - beltPotential (T 0) :=
  shaping_telescopes_one r (fun i => beltPotential (T i)) n

/-- **policy invariance** for the cook's heads (`RewardTheory.greedy_invariant`). -/
theorem greedy_invariant (Q : TState → TAction → ℝ) (φ : TState → ℝ) (s : TState) :
    Greedy (fun s a => Q s a + φ s) s = Greedy Q s :=
  RewardTheory.greedy_invariant Q φ s

/-- **the Bellman version** (`RewardTheory.bellman_shift`): the value of the shaped problem is the
original's, shifted by `φ`. -/
theorem bellman_shift (next : TState → TAction → TState) (r : TState → TAction → ℝ) (γ : ℝ)
    (φ : TState → ℝ) {Vf : TState → ℝ} (h : (tandoorDyn next).BellmanFixed r γ Vf) :
    (tandoorDyn next).BellmanFixed ((tandoorDyn next).shaped r γ φ) γ (fun s => Vf s - φ s) :=
  RewardTheory.bellman_shift (tandoorDyn next) r γ φ h

end TandoorParent

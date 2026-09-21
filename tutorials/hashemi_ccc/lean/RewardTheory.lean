/-
# A theory of rewards: gluing, units, truncation, shaping

`RewardTopos.lean` said what the reward of `puffer_hashemi_ccc` is and why the two bugs of
2026-09-19 were failures of a sheaf condition. Every statement there was about *that* env - its
83-column row, its `p_in`, its `reward_div = 75`. None of the four arguments needs any of that.

This file is the theory, with NO env in it. It is parametrized over

* a state type `S` and an action type `A` (no structure at all),
* a value object `V` - an ordered field (the weakest thing that carries `≤`, the division by
  `reward_div` and the rational constants of a reward term; the Archimedean hypothesis is asked
  for only where a *horizon* is produced),
* a transition `Dynamics.step : S → A → S` (a plain function; §5 notes what a Markov kernel
  changes and what it does not),
* a truncation `Truncation.value ≤ 0` - the value of the unique morphism to the episode's
  terminal object.

Four results, each generic in those parameters:

1. **Gluing** (§1): two models of one reward term agree, and a hand-assembled family that differs
   by a scale factor on one path is not a model of it.
2. **Units as change of base** (§2): a ring map on values is a functor on reward terms and the
   naturality square commutes for every term; on a summing functor of stages, the divided reward
   is the division of the reward.
3. **Truncation** (§3): a per-step reward `≥ 0` means truncating never beats continuing, at any
   horizon and any discount; and any strictly negative per-step reward has a horizon at which
   truncating wins.
4. **Shaping is a coboundary** (§4): the return changes by a boundary term, the greedy set is
   invariant under any state-only additive term, and the Bellman fixed point shifts by `φ`.

`RewardTopos.lean` instantiates all of it with the Hashemi env; `TandoorRewardInstance.lean` does
the same for the parent tandoor's own reward (5 per roti, the belt-rise potential, the cut). The
point of the layering is that the second instance costs a page and proves no lemma twice.
-/
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Positivity
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Group.Finset
import Mathlib.Algebra.Order.Archimedean.Basic
import Mathlib.Algebra.Order.Ring.Defs
import Mathlib.Data.Rat.Cast.Defs

namespace RewardTheory

open Finset

universe u v w

/-! ## 1. Reward terms and their models

A reward is a *term*: atoms (the columns a runtime can read - `p_in`, a gate, a count of rotis),
rational constants (the ini's numbers), sums and products. A *model* is any map that evaluates
terms compatibly with that structure - a printed C function, a NumPy expression, a Metal kernel,
a hand-written host formula. -/

/-- the syntax of a reward: atoms, rational constants, `+`, `·`. -/
inductive Term (ι : Type u) : Type u
  | atom : ι → Term ι
  | num : ℚ → Term ι
  | add : Term ι → Term ι → Term ι
  | mul : Term ι → Term ι → Term ι

/-- **a model of the reward language**: an interpretation `atom` of the columns and an evaluation
`ev` of every term that agrees with the structure. Two runtimes of one env are two models. -/
structure Model (ι : Type u) (S : Type v) (A : Type w) (V : Type*) [DivisionRing V] where
  /-- what each column means in this runtime -/
  atom : ι → S → A → V
  /-- what this runtime computes for a term -/
  ev : Term ι → S → A → V
  ev_atom : ∀ i, ev (.atom i) = atom i
  ev_num : ∀ q, ev (.num q) = fun _ _ => (q : V)
  ev_add : ∀ e f, ev (e.add f) = fun s a => ev e s a + ev f s a
  ev_mul : ∀ e f, ev (e.mul f) = fun s a => ev e s a * ev f s a

variable {ι : Type u} {S : Type v} {A : Type w} {V W : Type*}

/-- **the canonical model**: the structural evaluation of a term. A printed morphism IS this
model; the theorem below says every other model of the same columns equals it. -/
def evalTerm [DivisionRing V] (α : ι → S → A → V) : Term ι → S → A → V
  | .atom i => α i
  | .num q => fun _ _ => (q : V)
  | .add e f => fun s a => evalTerm α e s a + evalTerm α f s a
  | .mul e f => fun s a => evalTerm α e s a * evalTerm α f s a

/-- the canonical model as a `Model` - all four laws hold by `rfl`. -/
def stdModel [DivisionRing V] (α : ι → S → A → V) : Model ι S A V where
  atom := α
  ev := evalTerm α
  ev_atom _ := rfl
  ev_num _ := rfl
  ev_add _ _ := rfl
  ev_mul _ _ := rfl

@[simp] theorem stdModel_ev [DivisionRing V] (α : ι → S → A → V) (e : Term ι) :
    (stdModel α).ev e = evalTerm α e := rfl


/-- **Gluing.** Two models with the same reading of the columns agree on *every* term: a family of
runtimes printed from one morphism glues, by induction on the term. This is the whole content of
"there is a global section" - the reward exists as a quantity. -/
theorem glue [DivisionRing V] (M N : Model ι S A V) (h : M.atom = N.atom) (e : Term ι) :
    M.ev e = N.ev e := by
  induction e with
  | atom i => rw [M.ev_atom, N.ev_atom, h]
  | num q => rw [M.ev_num, N.ev_num]
  | add e f ihe ihf => rw [M.ev_add, N.ev_add, ihe, ihf]
  | mul e f ihe ihf => rw [M.ev_mul, N.ev_mul, ihe, ihf]

/-- **the corollary that catches a unit bug.** A second runtime that reads the same columns but
returns `k ·` the term's value at some point where that value is non-zero, `k ≠ 1`, is NOT a model
of that term: the family does not glue, so no reward is being computed at all. (The Hashemi bug of
2026-09-19 is the instance `k = 75`; the tandoor's `reward_div` would give another.) -/
theorem not_model_of_scaled [Field V] (M N : Model ι S A V) (h : N.atom = M.atom)
    (e : Term ι) (k : V) (hk : k ≠ 1) (s : S) (a : A) (hne : M.ev e s a ≠ 0) :
    N.ev e s a ≠ k * M.ev e s a := by
  have hg : N.ev e = M.ev e := glue N M h e
  rw [hg]
  intro heq
  apply hk
  have hz : M.ev e s a * (k - 1) = 0 := by linear_combination -heq
  rcases mul_eq_zero.mp hz with h1 | h2
  · exact absurd h1 hne
  · exact sub_eq_zero.mp h2

/-- **every model of the same columns is the canonical one**: there is one reward, and a runtime
either computes it or is not a model. -/
theorem eq_stdModel [DivisionRing V] (M : Model ι S A V) (e : Term ι) :
    M.ev e = evalTerm (M.atom) e := glue M (stdModel M.atom) rfl e

/-- a family of candidate values indexed by the runtimes (`numpy`, `fused`, the kernel, …). -/
structure PathFamily (P : Type*) (V : Type*) where
  val : P → V

/-- the gluing condition on an implementation cover: all restrictions agree. -/
def PathFamily.Glues {P V : Type*} (f : PathFamily P V) : Prop := ∀ p q, f.val p = f.val q

/-- anything printed from ONE morphism glues, definitionally. -/
theorem glues_const {P V : Type*} (v : V) : (PathFamily.mk (P := P) fun _ => v).Glues :=
  fun _ _ => rfl

/-- a two-element family glues iff its two members are equal - the shape of a `numpy` / `fused`
check, and the Prop a trace check measures. -/
theorem glues_two {V : Type*} (f : PathFamily Bool V) :
    f.Glues ↔ f.val false = f.val true :=
  ⟨fun h => h false true, fun h p q => by cases p <;> cases q <;> simp [h]⟩

/-! ## 2. Units as change of base

Units are a change of base along a map of value objects. On terms this is *functorial*: a ring map
`f : V →+* W` carries a model over `V` to a model over `W`, and the naturality square commutes for
every term. On the additive part - a reward assembled as a sum over a cover of stages - the
statement one actually wants is that dividing the total is dividing each part: there is exactly one
place a divisor may be applied, and it does not matter which. -/

/-- **naturality of a change of base.** If a second model reads every column through `f`, it
evaluates every term through `f`. Nothing in the reward language can break this - which is why a
printed definition cannot put the divisor in the wrong fibre and a host expression can. -/
theorem eval_map [DivisionRing V] [DivisionRing W] (M : Model ι S A V) (N : Model ι S A W)
    (f : V →+* W) (h : ∀ i s a, N.atom i s a = f (M.atom i s a)) (e : Term ι) (s : S) (a : A) :
    N.ev e s a = f (M.ev e s a) := by
  induction e with
  | atom i => rw [M.ev_atom, N.ev_atom]; exact h i s a
  | num q => rw [M.ev_num, N.ev_num]; simp
  | add e g ihe ihg => rw [M.ev_add, N.ev_add]; simp [ihe, ihg]
  | mul e g ihe ihg => rw [M.ev_mul, N.ev_mul]; simp [ihe, ihg]

/-- **a reward as a summing functor over a cover**: a value on each stage of the cover (the
sub-morphisms of the env's step, or the named terms of a hand-written reward). -/
structure Summed (σ : Type*) [Fintype σ] (S : Type v) (A : Type w) (V : Type*) where
  stage : σ → S → A → V

variable {σ : Type*} [Fintype σ]

/-- the step's reward is the sum over the cover. -/
def Summed.total [AddCommMonoid V] (R : Summed σ S A V) (s : S) (a : A) : V :=
  ∑ x : σ, R.stage x s a

/-- **the scaling functor** on rewards: rescale every stage. -/
def Summed.scale [Mul V] (c : V) (R : Summed σ S A V) : Summed σ S A V :=
  ⟨fun x s a => c * R.stage x s a⟩

/-- **the naturality square for units**: scaling the reward is rescaling every part of it. -/
theorem Summed.total_scale [NonUnitalNonAssocSemiring V] (c : V) (R : Summed σ S A V)
    (s : S) (a : A) : (Summed.scale c R).total s a = c * R.total s a :=
  (Finset.mul_sum _ _ _).symm

/-- **the divided reward is the division of the reward**: `reward_div` may be applied once to the
total or once to each part, and the two are equal. Put it anywhere else - after one part, before
another - and §1's `not_model_of_scaled` applies. -/
theorem Summed.total_div [DivisionRing V] (d : V) (R : Summed σ S A V) (s : S) (a : A) :
    R.total s a / d = ∑ x : σ, R.stage x s a / d := by
  simp [Summed.total, div_eq_mul_inv, Finset.sum_mul]

/-- the two-term case spelled out, the one every env has: parent reward plus shaping, divided. -/
theorem add_div_eq [DivisionRing V] (p q d : V) : (p + q) / d = p / d + q / d := add_div p q d

/-! ## 3. The truncation morphism

An episode may be cut: a unique morphism from the step to the terminal object, whose value is
`≤ 0` (a cost, never a bonus). The question every env asks is whether the agent is paid to take
it. -/

section Order

variable [Field V] [LinearOrder V] [IsStrictOrderedRing V]

/-- the value of the cut: a non-positive number. -/
structure Truncation (V : Type*) [Zero V] [LE V] where
  value : V
  nonpos : value ≤ 0

/-- the discounted return of a stream of rewards over a horizon. -/
def ret (γ : V) (r : ℕ → V) (n : ℕ) : V := ∑ i ∈ range n, γ ^ i * r i

theorem ret_zero (γ : V) (r : ℕ → V) : ret γ r 0 = 0 := by simp [ret]

theorem ret_succ (γ : V) (r : ℕ → V) (n : ℕ) :
    ret γ r (n + 1) = ret γ r n + γ ^ n * r n := by
  simp [ret, Finset.sum_range_succ]

/-- a non-negative reward stream has a non-negative return, at any horizon and any `0 ≤ γ`. -/
theorem ret_nonneg {γ : V} (hγ : 0 ≤ γ) {r : ℕ → V} (hr : ∀ i, 0 ≤ r i) (n : ℕ) :
    0 ≤ ret γ r n :=
  Finset.sum_nonneg fun i _ => mul_nonneg (pow_nonneg hγ i) (hr i)

/-- **the transition**: a deterministic dynamics on the parameters. (§5.) -/
structure Dynamics (S : Type v) (A : Type w) where
  step : S → A → S

/-- the state reached after `n` steps of a plan from `s`. -/
def Dynamics.traj (D : Dynamics S A) (s : S) (π : ℕ → A) : ℕ → S
  | 0 => s
  | n + 1 => D.step (D.traj s π n) (π n)

/-- the return of a plan from a state, under a per-step reward on the transition. -/
def Dynamics.retAlong (D : Dynamics S A) (r : S → A → V) (γ : V) (s : S) (π : ℕ → A) (n : ℕ) :
    V := ret γ (fun i => r (D.traj s π i) (π i)) n

/-- **THEOREM 3 (truncation).** If the per-step reward is non-negative everywhere, then truncating
never beats continuing: the cut's value is `≤` the return of *any* plan from *any* state, at
*every* horizon and *every* non-negative discount. Making the reward non-negative is therefore not
a tuning of the cut penalty - it removes the escape incentive uniformly. -/
theorem trunc_never_beats (T : Truncation V) (D : Dynamics S A) {r : S → A → V} {γ : V}
    (hγ : 0 ≤ γ) (hr : ∀ s a, 0 ≤ r s a) (s : S) (π : ℕ → A) (n : ℕ) :
    T.value ≤ D.retAlong r γ s π n :=
  le_trans T.nonpos (ret_nonneg hγ (fun i => hr _ _) n)

/-- **the converse.** Any strictly negative per-step reward has a horizon at which truncating
wins - however small the per-step penalty and however large the cut's cost. (`γ = 1`, the cut's
own accounting; Archimedean is what produces the day.) -/
theorem exists_horizon_trunc_wins [Archimedean V] (T : Truncation V) (D : Dynamics S A)
    {r : S → A → V} {c : V} (hc : 0 < c) (hr : ∀ s a, r s a ≤ -c) (s : S) (π : ℕ → A) :
    ∃ n : ℕ, D.retAlong r 1 s π n < T.value := by
  obtain ⟨n, hn⟩ := exists_nat_gt (-T.value / c)
  refine ⟨n + 1, ?_⟩
  have hbound : D.retAlong r 1 s π (n + 1) ≤ -((n + 1 : ℕ) * c) := by
    unfold Dynamics.retAlong ret
    have : ∀ i ∈ range (n + 1), (1 : V) ^ i * r (D.traj s π i) (π i) ≤ -c := by
      intro i _; simpa using hr _ _
    calc ∑ i ∈ range (n + 1), (1 : V) ^ i * r (D.traj s π i) (π i)
        ≤ ∑ _i ∈ range (n + 1), (-c) := Finset.sum_le_sum this
      _ = -((n + 1 : ℕ) * c) := by simp [Finset.sum_const, nsmul_eq_mul]
  have hlt : -T.value < (n : V) * c := by
    have := (div_lt_iff₀ hc).mp hn; linarith
  have hn1 : (n : V) * c ≤ ((n + 1 : ℕ) : V) * c := by
    have : (n : V) ≤ ((n + 1 : ℕ) : V) := by push_cast; linarith
    exact mul_le_mul_of_nonneg_right this (le_of_lt hc)
  have : -((n + 1 : ℕ) * c) < T.value := by push_cast at hn1 ⊢; linarith
  exact lt_of_le_of_lt hbound (by push_cast at this ⊢; linarith)

/-! ## 4. Potential shaping is a coboundary -/

/-- **THEOREM 4a (the coboundary).** `δφ i = γ φ(i+1) − φ i` telescopes: the return changes by a
boundary term only, so the cohomology class of the reward - what a learner optimizes - is
unchanged. -/
theorem shaping_telescopes (γ : V) (r φ : ℕ → V) (n : ℕ) :
    ret γ (fun i => r i + (γ * φ (i + 1) - φ i)) n = ret γ r n + γ ^ n * φ n - φ 0 := by
  induction n with
  | zero => simp [ret]
  | succ n ih =>
      simp only [ret, Finset.sum_range_succ] at ih ⊢
      rw [ih]; ring

/-- with `γ = 1` the boundary is `φ n − φ 0`. -/
theorem shaping_telescopes_one (r φ : ℕ → V) (n : ℕ) :
    ret 1 (fun i => r i + (φ (i + 1) - φ i)) n = ret 1 r n + φ n - φ 0 := by
  simpa using shaping_telescopes (1 : V) r φ n

/-- the greedy set of an action-value function at a state. -/
def Greedy (Q : S → A → V) (s : S) : Set A := {a | ∀ b, Q s b ≤ Q s a}

/-- **THEOREM 4b (policy invariance).** Adding any function of the STATE ALONE to every action's
value leaves the greedy set - hence the optimal policy - unchanged. No finiteness, no measure
theory: the statement is about the order on `V`. -/
theorem greedy_invariant (Q : S → A → V) (φ : S → V) (s : S) :
    Greedy (fun s a => Q s a + φ s) s = Greedy Q s := by
  ext a; simp [Greedy, add_le_add_iff_right]

/-- the shaped reward on a transition: the original plus the coboundary of `φ`. -/
def Dynamics.shaped (D : Dynamics S A) (r : S → A → V) (γ : V) (φ : S → V) : S → A → V :=
  fun s a => r s a + (γ * φ (D.step s a) - φ s)

variable [Fintype A] [Nonempty A]

/-- the Bellman operator's fixed-point condition for a deterministic dynamics on a finite action
set (`sup'` over the actions - no `S`-finiteness is needed for the shift). -/
def Dynamics.BellmanFixed (D : Dynamics S A) (r : S → A → V) (γ : V) (Vf : S → V) : Prop :=
  ∀ s, Vf s = (univ : Finset A).sup' univ_nonempty fun a => r s a + γ * Vf (D.step s a)

/-- **THEOREM 4c (the Bellman version).** If `Vf` is a fixed point of the Bellman operator for `r`,
then `Vf − φ` is a fixed point for the shaped reward: **the optimal value shifts by `φ`**, exactly.
(Stated as a correspondence of fixed points; with a contraction hypothesis - `|γ| < 1` and a
complete `V` - the fixed point is unique and this reads "the optimal value shifts by φ".) -/
theorem bellman_shift (D : Dynamics S A) (r : S → A → V) (γ : V) (φ : S → V) {Vf : S → V}
    (h : D.BellmanFixed r γ Vf) : D.BellmanFixed (D.shaped r γ φ) γ (fun s => Vf s - φ s) := by
  intro s
  have key : (fun a => D.shaped r γ φ s a + γ * (Vf (D.step s a) - φ (D.step s a)))
      = fun a => (r s a + γ * Vf (D.step s a)) + (-φ s) := by
    funext a; unfold Dynamics.shaped; ring
  rw [key, ← Finset.sup'_add]
  exact by rw [← h s]; ring

/-- and the greedy set of the shaped problem is the greedy set of the original: the policy the
fixed point induces is the same one. -/
theorem bellman_greedy_invariant (D : Dynamics S A) (r : S → A → V) (γ : V) (φ : S → V)
    (Vf : S → V) (s : S) :
    Greedy (fun s a => D.shaped r γ φ s a + γ * (Vf (D.step s a) - φ (D.step s a))) s
      = Greedy (fun s a => r s a + γ * Vf (D.step s a)) s := by
  have key : (fun (s : S) (a : A) =>
      D.shaped r γ φ s a + γ * (Vf (D.step s a) - φ (D.step s a)))
      = fun s a => (r s a + γ * Vf (D.step s a)) + (-φ s) := by
    funext s a; unfold Dynamics.shaped; ring
  rw [key]
  exact greedy_invariant _ (fun s => -φ s) s

/-! ## 5. What a Markov kernel would change

Nothing above uses `Dynamics.step` beyond "the next state is a function of `(s, a)`". Replacing it
by a kernel `S → A → Dist S` replaces `retAlong` by an expectation and `sup'` by a sup of
expectations; §3 survives verbatim (an expectation of non-negative rewards is non-negative) and
§4's `bellman_shift` survives with `γ * φ (step s a)` replaced by `γ * 𝔼[φ]` - the coboundary is
still a coboundary because the expectation is linear. The deterministic version is what both envs
here are (their randomness is drawn at `reset`, into the state), so it is the one that is proved. -/

/-- the monotonicity condition that makes a scalar reward a legitimate reading of a multi-objective
valuation (Marcolli: a scalarization, not the frontier): monotone in each column it reads. -/
def MonotoneInAtom (f : V → V) : Prop := ∀ x y : V, x ≤ y → f x ≤ f y

theorem monotone_of_nonneg_scale {c : V} (hc : 0 ≤ c) : MonotoneInAtom fun x => c * x :=
  fun _ _ h => mul_le_mul_of_nonneg_left h hc

end Order

end RewardTheory

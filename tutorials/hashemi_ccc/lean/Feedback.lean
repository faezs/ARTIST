/-
# Bounded feedback attains its fixed point

The semantics of a ray trace with bounces is "step until a terminal fate": the least fixed point of
the step functional, the supremum of its finite iterates. A kernel computes the `N`-th iterate.
The two agree exactly when every trajectory is stationary by stage `N` - a `done` state is fixed
by the step, and every start reaches `done` within `N` steps. Then the `N`-th iterate IS the fixed
point: `f^[m] s = f^[N] s` for every `m ≥ N`. This is the theorem a bounce cap silently assumes,
and the one to prove for any multi-bounce train (the CPC lip, the duct). `Ccc` compiles `f^[N]` by
unrolling, so a bounded loop with a `done` flag is already in its vocabulary; this file is what
makes that unrolling a semantics rather than an approximation.
-/
import Mathlib

namespace Feedback

variable {α : Type*}

/-- a `done` state is fixed by the step -/
def Stops (f : α → α) (done : α → Prop) : Prop := ∀ s, done s → f s = s

/-- once done, done forever -/
theorem done_iterate {f : α → α} {done : α → Prop} (h : Stops f done) {s : α} (hs : done s) :
    ∀ k, f^[k] s = s := by
  intro k
  induction k with
  | zero => rfl
  | succ k ih => rw [Function.iterate_succ_apply', ih, h s hs]

/-- **the `N`-th iterate is the fixed point** once the trajectory is done at stage `N` -/
theorem iterate_stationary {f : α → α} {done : α → Prop} (h : Stops f done) (N : ℕ) (s : α)
    (hN : done (f^[N] s)) : ∀ m, N ≤ m → f^[m] s = f^[N] s := by
  intro m hm
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hm
  rw [Nat.add_comm, Function.iterate_add_apply]
  exact done_iterate h hN k

/-- the least fixed point, when every start is done by stage `N`: the `N`-th iterate is a fixed
point of `f`, and it is reached from `s` - so a kernel that runs `N` steps computes the semantics -/
theorem iterate_isFixed {f : α → α} {done : α → Prop} (h : Stops f done) (N : ℕ) (s : α)
    (hN : done (f^[N] s)) : f (f^[N] s) = f^[N] s :=
  h _ hN

/-- a single bounce: done after one step, so `N = 1` (his dish: every ray either misses the panel
or lands on the coil's plane, no second surface) -/
theorem single_bounce {f : α → α} {done : α → Prop} (h : Stops f done) (s : α) (h1 : done (f s)) :
    ∀ m, 1 ≤ m → f^[m] s = f s := by
  simpa using iterate_stationary h 1 s (by simpa using h1)

end Feedback

namespace Feedback

/-! ## A train of surfaces is a bounded feedback

Every receiver configuration is a multi-bounce train - the tri (dish, strip, M4, pot), the
cassegrain (dish, fold, waist, M5, duct), the focus, the CPC lip - a FIXED SEQUENCE of surfaces,
each of which either terminates the ray with a fate or passes it to the next. Such a train is a
bounded feedback: the step advances the stage or sets the fate, a set fate is stationary, and
after as many steps as there are surfaces every ray is done. So the kernel's fixed sequence IS the
least fixed point of "step until a fate", attained at stage `n` - `iterate_stationary` with
`N = n` - and the measured statement "every ray has exactly one fate" is this theorem seen from
the GPU. -/

/-- a ray in a train: its geometric state, the stage it is at, and its fate once it has one -/
structure Ray (σ : Type*) where
  geom : σ
  stage : ℕ
  fate : Option ℕ

/-- one surface: from the geometric state, either a fate or the state passed on -/
def Surface (σ : Type*) := σ → Sum ℕ σ

/-- the train's step: a done ray stays; otherwise the surface at the ray's stage acts, and past
the last surface the ray gets the terminal fate `n` (missed everything) -/
def trainStep {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) (r : Ray σ) : Ray σ :=
  match r.fate with
  | some _ => r
  | none =>
    if r.stage < n then
      match surf r.stage r.geom with
      | Sum.inl f => { r with fate := some f }
      | Sum.inr g => { r with geom := g, stage := r.stage + 1 }
    else { r with fate := some n }

def Done {σ : Type*} (r : Ray σ) : Prop := r.fate.isSome = true

/-- a done ray is fixed by the step -/
theorem trainStep_done {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) {r : Ray σ} (h : Done r) :
    trainStep surf n r = r := by
  unfold Done at h
  cases hf : r.fate with
  | none => simp [hf] at h
  | some f => simp [trainStep, hf]

theorem trainStep_stops {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) :
    Stops (trainStep surf n) Done :=
  fun _ h => trainStep_done surf n h

/-- an undone ray below the train's length: the step is the stage's surface acting -/
theorem trainStep_of_undone {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) {r : Ray σ}
    (h0 : r.fate = none) (hlt : r.stage < n) :
    trainStep surf n r = match surf r.stage r.geom with
      | Sum.inl f => { r with fate := some f }
      | Sum.inr g => { r with geom := g, stage := r.stage + 1 } := by
  unfold trainStep
  rw [h0]
  simp [hlt]

/-- an undone step advanced the stage, and the stage was below the train's length -/
theorem step_undone {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) {r : Ray σ} (h0 : r.fate = none)
    (h1 : (trainStep surf n r).fate = none) :
    (trainStep surf n r).stage = r.stage + 1 ∧ r.stage < n := by
  unfold trainStep at h1 ⊢
  rw [h0] at h1 ⊢
  by_cases hlt : r.stage < n
  · rcases hs : surf r.stage r.geom with f | g
    · simp [hlt, hs] at h1
    · simp [hlt, hs]
  · simp [hlt] at h1

/-- an undone iterate has advanced one stage per step, within the train's length -/
theorem undone_iter {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) (r : Ray σ) (hr : r.stage ≤ n) :
    ∀ k, ((trainStep surf n)^[k] r).fate = none →
      ((trainStep surf n)^[k] r).stage = r.stage + k ∧ r.stage + k ≤ n := by
  intro k
  induction k with
  | zero => intro _; simpa using hr
  | succ k ih =>
    intro hk
    rw [Function.iterate_succ_apply'] at hk ⊢
    have hprev : ((trainStep surf n)^[k] r).fate = none := by
      by_contra hc
      have hd : Done ((trainStep surf n)^[k] r) := Option.ne_none_iff_isSome.mp hc
      rw [trainStep_done surf n hd] at hk
      exact hc hk
    obtain ⟨hst, _⟩ := ih hprev
    obtain ⟨hst2, hlt⟩ := step_undone surf n hprev hk
    constructor
    · omega
    · omega

/-- **the train terminates within its length**: after `n + 1` steps from stage 0 every ray has a
fate - the least fixed point is attained, which is the theorem a kernel's fixed sequence of
surfaces embodies and "every ray has exactly one fate" measures -/
theorem train_done {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) (r : Ray σ) (h0 : r.stage = 0) :
    Done ((trainStep surf n)^[n + 1] r) := by
  unfold Done
  rw [← Option.ne_none_iff_isSome]
  intro hnone
  obtain ⟨_, hle⟩ := undone_iter surf n r (by omega) (n + 1) hnone
  omega

/-- and it stays there: the fixed point, from stage `n + 1` on -/
theorem train_fixed {σ : Type*} (surf : ℕ → Surface σ) (n : ℕ) (r : Ray σ) (h0 : r.stage = 0) :
    ∀ m, n + 1 ≤ m → (trainStep surf n)^[m] r = (trainStep surf n)^[n + 1] r :=
  iterate_stationary (trainStep_stops surf n) (n + 1) r (train_done surf n r h0)

end Feedback

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

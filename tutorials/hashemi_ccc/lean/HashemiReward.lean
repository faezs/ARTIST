/-
# The trainer's reward as a printed morphism

`RewardTopos.lean` says what the reward IS (the site, the gluing, the coboundary, the cut) and
why the two bugs of 2026-09-19 were failures of a sheaf condition.  This file is the part of it
that the driver COMPILES: one morphism with columns, whose constants are INPUTS, so the ini's
`reward_div`, `capture_shaping`, the parent's raw price of a roti and `roti_kj` flow into the
kernel as inputs instead of being frozen into the spec or assembled on a host.

`hashemiEnv` gives the two columns this reads - `p_in` (20) and `sun_reachable` (13) - and the
parent env gives its own raw reward for the step; `rewardStep` is then the whole of the trainer's
reward, printed for C, NumPy, Metal and the Float twin exactly as the physics is.
-/
import RequestProject.HashemiEnv

namespace TandoorHashemi

/-- **the shaping, in the parent's RAW reward units**: the light at the receiver this step
(`p_in · dt`, J) in roti units (`/ rotiEnergy`), priced at `capShaping · rotiReward`, gated by the
sun's reach (`sun_reachable`, 0 or 1).  Every constant is an argument: the ini's value is what the
kernel is handed. -/
noncomputable def rewardShapeRaw (dt pIn reach capShaping rotiReward rotiEnergy : ℝ) : ℝ :=
  capShaping * rotiReward * dt / rotiEnergy * pIn * reach

/-- **the reward's three columns**, `rewardNames`: the shaping in raw units, the step's total raw
reward, and the trainer's reward - the ONE place `reward_div` is applied.  The naturality square
of RewardTopos.lean is the identity `col 2 · rewardDiv = parentRaw + col 0`, and it holds by
construction because there is one definition, not two host expressions. -/
noncomputable def rewardStep (parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy : ℝ) :
    Fin 3 → ℝ :=
  let s := rewardShapeRaw dt pIn reach capShaping rotiReward rotiEnergy
  ![s, parentRaw + s, (parentRaw + s) / rewardDiv]

/-- the column names, as `envNames` is for the env's kernel -/
def rewardNames : Array String := #["r_shape_raw", "r_raw", "r_trainer"]

theorem rewardNames_size : rewardNames.size = 3 := by rfl

/-- **R2, the units** (the naturality square, as a Prop the driver prints and measures):
the trainer's column times the divisor, less the parent's raw reward, IS the shaping column. -/
theorem rewardStep_units (parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy : ℝ)
    (hd : rewardDiv ≠ 0) :
    rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy 2 * rewardDiv
      - parentRaw
      = rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy 0 := by
  simp only [rewardStep, Matrix.cons_val_zero, Matrix.cons_val_two, Matrix.tail_cons,
    Matrix.head_cons]
  field_simp
  ring

/-- **R3, non-negativity**: with non-negative light, a non-negative gate, a positive step and
non-negative prices, the shaping column is non-negative - so no per-step penalty exists and
RewardTopos.lean's `cut_never_pays` applies. -/
theorem rewardStep_nonneg {dt pIn reach capShaping rotiReward rotiEnergy : ℝ}
    (hdt : 0 ≤ dt) (hp : 0 ≤ pIn) (hr : 0 ≤ reach) (hc : 0 ≤ capShaping)
    (hq : 0 ≤ rotiReward) (he : 0 ≤ rotiEnergy) (parentRaw rewardDiv : ℝ) :
    0 ≤ rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy 0 := by
  simp only [rewardStep, Matrix.cons_val_zero, rewardShapeRaw]
  have : (0:ℝ) ≤ capShaping * rotiReward * dt / rotiEnergy := by positivity
  exact mul_nonneg (mul_nonneg this hp) hr

end TandoorHashemi

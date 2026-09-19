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

/-- **the pump's bill, in the parent's RAW reward units**: the electrical energy the pump spent
this step (`pPump · dt`, J) converted to roti-equivalents (`/ rotiEnergy`) at the parent's raw
price of a roti, scaled by `pumpPrice`.

The rate is stated here and nowhere else: `pumpPrice = 1` prices an electrical joule exactly as
the shaping prices a thermal joule delivered to the receiver, which is the most favourable
accounting the pump can get (electricity off a panel is worth more than heat, not less).  It is
an INPUT, so the ini may raise it.  `HashemiOil.pumpElec` says what `pPump` is, and
`PumpWithinBudget` says that it does not fit on his 5 W panel - the cost is here so the policy
cannot run the pump flat out for free. -/
noncomputable def pumpCostRaw (dt pPump pumpPrice rotiReward rotiEnergy : ℝ) : ℝ :=
  pumpPrice * rotiReward * dt / rotiEnergy * max 0 pPump

/-- **the over-limit bill**: `degPrice` rotis' worth of reward per kelvin-second the FILM
temperature spends above the fluid's 375 °C limit (`filmExcess = max 0 (T_film - oilFilmMax)`).

The rate has no datasheet behind it - a fluid's life is not a linear function of degrees over -
so it is an input and its ini default is set so that a full day pinned 50 K over the limit costs
about one roti: a cost the policy feels, not a cliff it cannot cross.  What IS proved is that
the damage itself accumulates (`degradRate_mono`); this column is the price put on it. -/
noncomputable def degCostRaw (dt filmExcess degPrice rotiReward : ℝ) : ℝ :=
  degPrice * rotiReward * dt * max 0 filmExcess

/-- **the reward's five columns**, `rewardNames`: the shaping in raw units, the pump's bill, the
over-limit bill, the step's total raw reward, and the trainer's reward - the ONE place
`reward_div` is applied.  The naturality square of RewardTopos.lean is the identity
`col 4 · rewardDiv - parentRaw = col 0 - col 1 - col 2`, and it holds by construction because
there is one definition, not two host expressions. -/
noncomputable def rewardStep (parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy
    pPump filmExcess pumpPrice degPrice : ℝ) : Fin 5 → ℝ :=
  let s := rewardShapeRaw dt pIn reach capShaping rotiReward rotiEnergy
  let cp := pumpCostRaw dt pPump pumpPrice rotiReward rotiEnergy
  let cd := degCostRaw dt filmExcess degPrice rotiReward
  ![s, cp, cd, parentRaw + s - cp - cd, (parentRaw + s - cp - cd) / rewardDiv]

/-- the column names, as `envNames` is for the env's kernel -/
def rewardNames : Array String := #["r_shape_raw", "r_pump_raw", "r_deg_raw", "r_raw", "r_trainer"]

theorem rewardNames_size : rewardNames.size = 5 := by rfl

/-- both bills are non-negative: they are costs, never a bonus -/
theorem pumpCostRaw_nonneg {dt pPump pumpPrice rotiReward rotiEnergy : ℝ} (hdt : 0 ≤ dt)
    (hpp : 0 ≤ pumpPrice) (hq : 0 ≤ rotiReward) (he : 0 ≤ rotiEnergy) :
    0 ≤ pumpCostRaw dt pPump pumpPrice rotiReward rotiEnergy := by
  unfold pumpCostRaw
  have : (0:ℝ) ≤ pumpPrice * rotiReward * dt / rotiEnergy := by positivity
  exact mul_nonneg this (le_max_left _ _)

theorem degCostRaw_nonneg {dt filmExcess degPrice rotiReward : ℝ} (hdt : 0 ≤ dt)
    (hd : 0 ≤ degPrice) (hq : 0 ≤ rotiReward) :
    0 ≤ degCostRaw dt filmExcess degPrice rotiReward := by
  unfold degCostRaw
  have : (0:ℝ) ≤ degPrice * rotiReward * dt := by positivity
  exact mul_nonneg this (le_max_left _ _)

/-- **R2, the units** (the naturality square, as a Prop the driver prints and measures):
the trainer's column times the divisor, less the parent's raw reward, IS the shaping column. -/
theorem rewardStep_units (parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy
    pPump filmExcess pumpPrice degPrice : ℝ) (hd : rewardDiv ≠ 0) :
    rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy pPump filmExcess pumpPrice degPrice 4 * rewardDiv
      - parentRaw
      = rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy pPump filmExcess pumpPrice degPrice 0
        - rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy pPump filmExcess pumpPrice degPrice 1
        - rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy pPump filmExcess pumpPrice degPrice 2 := by
  simp only [rewardStep, Matrix.cons_val]
  field_simp
  ring

/-- **R3, non-negativity**: with non-negative light, a non-negative gate, a positive step and
non-negative prices, the shaping column is non-negative - so no per-step penalty exists and
RewardTopos.lean's `cut_never_pays` applies. -/
theorem rewardStep_nonneg {dt pIn reach capShaping rotiReward rotiEnergy : ℝ}
    (hdt : 0 ≤ dt) (hp : 0 ≤ pIn) (hr : 0 ≤ reach) (hc : 0 ≤ capShaping)
    (hq : 0 ≤ rotiReward) (he : 0 ≤ rotiEnergy) (parentRaw rewardDiv pPump filmExcess pumpPrice degPrice : ℝ) :
    0 ≤ rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy pPump filmExcess pumpPrice degPrice 0 := by
  simp only [rewardStep, Matrix.cons_val_zero, rewardShapeRaw]
  have : (0:ℝ) ≤ capShaping * rotiReward * dt / rotiEnergy := by positivity
  exact mul_nonneg (mul_nonneg this hp) hr

end TandoorHashemi

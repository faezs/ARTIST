/-
# The loop as a field: energy density, power flux, Green's functions

HashemiHeat.lean carried one oil temperature. Here the loop is a FIELD along its coordinate:
the energy density `u = ρ c A T` and the power flux `Φ = v u`, with the conservation law
`∂ₜ u + ∂ₛ Φ = σ - λ (T - Tₐ)` - the absorbed flux density `σ` on the coil, the loss `λ` per
metre. Two transports are linear and have closed Green's functions:

* the pipe: for `∂ₜ + v ∂ₛ + a` the kernel is `δ(s - s' - v (t - t')) e^{-a (t - t')}` - plug
  flow with attenuation. The oil at the pot is the coil's outlet delayed by `L / v` and scaled by
  `pipeGreen = e^{-U L / (ṁ c)}`; the state along the pipe is a HISTORY of outlet temperatures,
  shifted one step at a time (`shift`): the density along the pipe, sampled per step;
* the coil: the oil crosses it in about a second, so within a step the field along the turns is
  quasi-static - a fold from the inlet through each turn's source and loss (`coilProfile`).

The receiver's flux is a convolution already (the sun's disc with the mirror's spread, which the
trace does by Monte Carlo); binned into annuli of the aperture it is the source per turn
(`fluxBins` in HashemiEnv.lean, sums over the rays; `bins_partition` below: the annuli partition
the aperture, so the bins sum to the capture).

Theorems: the pipe's kernel is positive, at most one, and composes (`pipeGreen_semigroup`: the
attenuation over two runs is the product - the semigroup of the transport); the coil's fold
conserves energy (`coilProfile_balance`: what the oil gains is what the turns absorbed less what
they lost); the density carried down the pipe never exceeds what went in (`shift` moves,
`pipeGreen` attenuates: `delivered_le`).
-/
import RequestProject.HashemiHeat
import RequestProject.HashemiMega

namespace TandoorHashemi

/-! ## The pipe's Green's function -/

/-- the attenuation of a temperature excess over a run of loss `Upipe` (W/K) at flow `mcp` (W/K):
`e^{-Upipe / mcp}` -/
noncomputable def pipeGreen (Upipe mcp : ℝ) : ℝ := Real.exp (-Upipe / mcp)

theorem pipeGreen_pos (Upipe mcp : ℝ) : 0 < pipeGreen Upipe mcp := Real.exp_pos _

theorem pipeGreen_le_one {Upipe mcp : ℝ} (hU : 0 ≤ Upipe) (hm : 0 < mcp) : pipeGreen Upipe mcp ≤ 1 := by
  unfold pipeGreen
  rw [Real.exp_le_one_iff]
  exact div_nonpos_of_nonpos_of_nonneg (by linarith) hm.le

/-- **the semigroup of the transport**: two runs in series attenuate by the product -/
theorem pipeGreen_semigroup (U₁ U₂ mcp : ℝ) :
    pipeGreen (U₁ + U₂) mcp = pipeGreen U₁ mcp * pipeGreen U₂ mcp := by
  unfold pipeGreen
  rw [← Real.exp_add]
  congr 1
  ring

/-- the oil delivered after a run: ambient plus the attenuated excess -/
noncomputable def delivered (Upipe mcp Ta Tin : ℝ) : ℝ := Ta + (Tin - Ta) * pipeGreen Upipe mcp

/-- an excess over ambient never grows down the pipe -/
theorem delivered_le {Upipe mcp Ta Tin : ℝ} (hU : 0 ≤ Upipe) (hm : 0 < mcp) (hT : Ta ≤ Tin) :
    delivered Upipe mcp Ta Tin ≤ Tin := by
  unfold delivered
  have h1 := pipeGreen_le_one hU hm
  have h2 := (pipeGreen_pos Upipe mcp).le
  nlinarith [mul_le_mul_of_nonneg_left h1 (sub_nonneg.2 hT)]

theorem delivered_ge_amb {Upipe mcp Ta Tin : ℝ} (hT : Ta ≤ Tin) : Ta ≤ delivered Upipe mcp Ta Tin := by
  unfold delivered
  nlinarith [(pipeGreen_pos Upipe mcp).le, sub_nonneg.2 hT]

/-! ## The history: the density along the pipe -/

/-- the state along the pipe as the last 16 outlet temperatures, the most recent first; one step
moves the oil one station down: the plug-flow kernel's `δ(s - s' - v (t - t'))` on the grid -/
noncomputable def shift (x : ℝ) (h : Fin 16 → ℝ) : Fin 16 → ℝ :=
  ![x, h 0, h 1, h 2, h 3, h 4, h 5, h 6, h 7, h 8, h 9, h 10, h 11, h 12, h 13, h 14]

theorem shift_head (x : ℝ) (h : Fin 16 → ℝ) : shift x h 0 = x := rfl

/-- the run's delay in steps: `L / v` over `dt` - 6 m at 0.21 m/s (0.02 kg/s of oil in a 12 mm
tube) is 29 s, two steps of 15 s -/
def delaySteps : ℕ := 2

/-! ## The coil as a field along its turns -/

/-- one turn: the oil enters at `Tin`, takes `α P` of the turn's incident power, loses by
radiation and convection from the turn's share `Ac / 8` of the coil's surface at its inlet
temperature (explicit along the flow), and leaves warmer by the net over the flow's `mcp` -/
noncomputable def turnOut (α ε Ac hC Ta mcp P Tin : ℝ) : ℝ :=
  Tin + (α * P - (ε * sigmaSB * (Ac / 8) * (Tin ^ 4 - Ta ^ 4) + hC * (Ac / 8) * (Tin - Ta))) / mcp

/-- the turn's loss, as it appears in `turnOut` -/
noncomputable def turnLoss (ε Ac hC Ta Tin : ℝ) : ℝ :=
  ε * sigmaSB * (Ac / 8) * (Tin ^ 4 - Ta ^ 4) + hC * (Ac / 8) * (Tin - Ta)

theorem turnOut_eq (α ε Ac hC Ta mcp P Tin : ℝ) :
    turnOut α ε Ac hC Ta mcp P Tin = Tin + (α * P - turnLoss ε Ac hC Ta Tin) / mcp := rfl

/-- **the coil's field**: the oil's temperature at the outlet of each of the eight turns, from the
inlet through each turn's source `P k` (the flux bin's power) - a fold along the flow -/
noncomputable def coilProfile (α ε Ac hC Ta mcp Tin : ℝ) (P : Fin 8 → ℝ) : Fin 8 → ℝ :=
  let T0 := turnOut α ε Ac hC Ta mcp (P 0) Tin
  let T1 := turnOut α ε Ac hC Ta mcp (P 1) T0
  let T2 := turnOut α ε Ac hC Ta mcp (P 2) T1
  let T3 := turnOut α ε Ac hC Ta mcp (P 3) T2
  let T4 := turnOut α ε Ac hC Ta mcp (P 4) T3
  let T5 := turnOut α ε Ac hC Ta mcp (P 5) T4
  let T6 := turnOut α ε Ac hC Ta mcp (P 6) T5
  let T7 := turnOut α ε Ac hC Ta mcp (P 7) T6
  ![T0, T1, T2, T3, T4, T5, T6, T7]

/-- **conservation along the coil**: what the oil gains over the coil, `mcp (Tout - Tin)`, is the
absorbed power less the turns' losses - the discrete continuity law, telescoped -/
theorem coilProfile_balance (α ε Ac hC Ta mcp Tin : ℝ) (P : Fin 8 → ℝ) (hm : mcp ≠ 0) :
    mcp * (coilProfile α ε Ac hC Ta mcp Tin P 7 - Tin)
      = α * (∑ k : Fin 8, P k)
        - (turnLoss ε Ac hC Ta Tin
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 0)
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 1)
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 2)
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 3)
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 4)
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 5)
          + turnLoss ε Ac hC Ta (coilProfile α ε Ac hC Ta mcp Tin P 6)) := by
  simp only [coilProfile, Matrix.cons_val]
  simp only [turnOut_eq, Fin.sum_univ_eight]
  field_simp
  ring

/-! ## The receiver's flux, binned -/

/-- the annulus `k` of eight over the aperture of radius `rc`: `[k rc / 8, (k + 1) rc / 8)` -/
def inBin (rc r : ℝ) (k : ℕ) : Prop := k * rc / 8 ≤ r ∧ r < (k + 1) * rc / 8

open Classical in
/-- an indicator of `A ∧ ¬ B` when `B` implies `A`: the difference of the indicators -/
theorem b2r_and_not {A B : Prop} (h : B → A) : b2r (A ∧ ¬ B) = b2r A - b2r B := by
  unfold b2r
  split_ifs <;> simp_all

open Classical in
/-- **the annuli partition the aperture**: a landing radius in `[0, rc)` lies in exactly one
bin, so the bins' indicators sum to the aperture's - the thresholds telescope -/
theorem bins_partition {rc r : ℝ} (hrc : 0 < rc) (hr : 0 ≤ r) :
    b2r (inBin rc r 0) + b2r (inBin rc r 1) + b2r (inBin rc r 2) + b2r (inBin rc r 3)
      + b2r (inBin rc r 4) + b2r (inBin rc r 5) + b2r (inBin rc r 6) + b2r (inBin rc r 7)
      = b2r (r < rc) := by
  let c : ℕ → ℝ := fun k => b2r ((k : ℝ) * rc / 8 ≤ r)
  have hb : ∀ k : ℕ, b2r (inBin rc r k) = c k - c (k + 1) := fun k => by
    simp only [c, b2r, inBin]
    push_cast
    have hk : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
    split_ifs <;>
      first
      | (norm_num; done)
      | (exfalso; simp_all; done)
      | (exfalso; (try push_neg at *); nlinarith)
  have h0 : c 0 = 1 := by
    simp only [c, b2r, Nat.cast_zero, zero_mul, zero_div]
    rw [if_pos hr]
  have h8 : c 8 = 1 - b2r (r < rc) := by
    simp only [c, b2r]
    have e : ((8 : ℕ) : ℝ) * rc / 8 = rc := by push_cast; ring
    rw [e]
    split_ifs <;> first | (exfalso; linarith) | norm_num
  rw [hb 0, hb 1, hb 2, hb 3, hb 4, hb 5, hb 6, hb 7]
  simp only [Nat.reduceAdd]
  linarith [h0, h8]

end TandoorHashemi

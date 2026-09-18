/-
# The receiver's heat: the coil at F, hot oil in insulated copper pipes, the tandoor

His receiver (Hashemi.lean, section 14) is a copper spiral coil about 12 cm across on a post
through the slot, at F - "temporary", its plumbing not shown. Here it carries THERMAL OIL: the
coil absorbs the dish's concentrated flux, insulated copper pipes take the oil down the post and
along the carriage to the tandoor, an exchanger in the pot's wall gives the heat to the oven, the
cool oil returns. Lumped, one oil temperature, explicit in the env's step. The laws:

* `qAbs`: the coil takes `α` of the delivered power;
* `qCoilLoss`: an unglazed coil loses by radiation and convection from its surface;
* `qPipe`: the insulated run loses `Upipe` per kelvin over ambient;
* `qPot`: the exchanger delivers `UAx (Toil - Twall)`, never backwards (a check valve);
* `qNet`, `oilStep`: the balance, and the oil's step held under its limit.

Theorems: the net heat is antitone in the oil's temperature (`qNet_antitone`), so a steady state
is unique (`steady_unique`) and, between a cold oil and its stagnation, exists
(`steady_exists`); the exchanger never delivers more than the coil absorbed at a steady state
(`steady_conservation`); and the step's modulus (`qNet_lipschitz`, `oilStep_lipschitz`): the
Lipschitz constant of one step in the oil's temperature, what Modula needs of a module.
-/
import Mathlib

namespace TandoorHashemi

/-- Stefan-Boltzmann, W/m²K⁴ -/
def sigmaSB : ℝ := 5.67e-8

/-- the coil takes `α` of the delivered power -/
def qAbs (α Pin : ℝ) : ℝ := α * Pin

/-- an unglazed coil of surface `Ac` at the oil's temperature: radiation at emissivity `ε` and
convection at `hC` to air at `Ta` -/
noncomputable def qCoilLoss (ε Ac hC Toil Ta : ℝ) : ℝ :=
  ε * sigmaSB * Ac * (Toil ^ 4 - Ta ^ 4) + hC * Ac * (Toil - Ta)

/-- the insulated pipe run: `Upipe` W/K over ambient -/
def qPipe (Upipe Toil Ta : ℝ) : ℝ := Upipe * (Toil - Ta)

/-- the exchanger in the pot's wall: `UAx` W/K to the wall, never backwards -/
noncomputable def qPot (UAx Toil Twall : ℝ) : ℝ := max 0 (UAx * (Toil - Twall))

/-- the net heat into the oil -/
noncomputable def qNet (α ε Ac hC Upipe UAx Pin Toil Twall Ta : ℝ) : ℝ :=
  qAbs α Pin - qCoilLoss ε Ac hC Toil Ta - qPipe Upipe Toil Ta - qPot UAx Toil Twall

/-- one explicit step of the oil of heat capacity `Coil` (J/K), held under `ToilMax` -/
noncomputable def oilStep (α ε Ac hC Upipe UAx Coil ToilMax Pin Toil Twall Ta dt : ℝ) : ℝ :=
  min ToilMax (Toil + dt * qNet α ε Ac hC Upipe UAx Pin Toil Twall Ta / Coil)

/-- **the heat step**: `(Toil', qAbs, qCoilLoss, qPipe, qPot, qNet)` -/
noncomputable def heatStep (α ε Ac hC Upipe UAx Coil ToilMax Pin Toil Twall Ta dt : ℝ) : Fin 6 → ℝ :=
  ![oilStep α ε Ac hC Upipe UAx Coil ToilMax Pin Toil Twall Ta dt, qAbs α Pin,
    qCoilLoss ε Ac hC Toil Ta, qPipe Upipe Toil Ta, qPot UAx Toil Twall,
    qNet α ε Ac hC Upipe UAx Pin Toil Twall Ta]

/-- the parameters assumed: absorptance 0.9, emissivity 0.8, coil surface 0.03 m², convection
15 W/m²K, the pipe run 0.92 W/K (6 m of 12 mm copper in 25 mm of mineral wool), the exchanger
15 W/K, 3 kg of oil at 2100 J/kgK, the oil's limit 593 K (320 °C) -/
noncomputable def heatParams : Fin 8 → ℝ := ![0.9, 0.8, 0.03, 15, 0.92, 15, 6300, 593]

theorem qPot_nonneg (UAx Toil Twall : ℝ) : 0 ≤ qPot UAx Toil Twall := le_max_left _ _

/-- the exchanger delivers at most `UAx (Toil - Twall)` when the oil is hotter, nothing otherwise -/
theorem qPot_le {UAx Toil Twall : ℝ} (hU : 0 ≤ UAx) :
    qPot UAx Toil Twall ≤ UAx * max 0 (Toil - Twall) := by
  unfold qPot
  rcases le_total 0 (Toil - Twall) with h | h
  · rw [max_eq_right h, max_eq_right (mul_nonneg hU h)]
  · rw [max_eq_left h, max_eq_left (mul_nonpos_of_nonneg_of_nonpos hU h), mul_zero]

/-- the coil's loss, the pipe's loss and the exchanger's delivery all grow with the oil's
temperature: the net heat is antitone in it (for `0 ≤ Ta ≤ Toil`) -/
theorem qNet_antitone {α ε Ac hC Upipe UAx Pin Twall Ta T₁ T₂ : ℝ} (hε : 0 ≤ ε) (hA : 0 ≤ Ac)
    (hh : 0 ≤ hC) (hp : 0 ≤ Upipe) (hU : 0 ≤ UAx) (h0 : 0 ≤ T₁) (h12 : T₁ ≤ T₂) :
    qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta ≤ qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta := by
  unfold qNet qCoilLoss qPipe qPot qAbs
  have hσ : (0 : ℝ) ≤ sigmaSB := by unfold sigmaSB; norm_num
  have h4 : T₁ ^ 4 ≤ T₂ ^ 4 := pow_le_pow_left₀ h0 h12 4
  have hrad : ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) ≤ ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4) :=
    mul_le_mul_of_nonneg_left (by linarith) (by positivity)
  have hconv : hC * Ac * (T₁ - Ta) ≤ hC * Ac * (T₂ - Ta) :=
    mul_le_mul_of_nonneg_left (by linarith) (by positivity)
  have hpipe : Upipe * (T₁ - Ta) ≤ Upipe * (T₂ - Ta) :=
    mul_le_mul_of_nonneg_left (by linarith) hp
  have hpot : max 0 (UAx * (T₁ - Twall)) ≤ max 0 (UAx * (T₂ - Twall)) :=
    max_le_max le_rfl (mul_le_mul_of_nonneg_left (by linarith) hU)
  linarith

/-- with any loss path strictly open the net heat strictly falls with the oil's temperature -/
theorem qNet_strictAnti {α ε Ac hC Upipe UAx Pin Twall Ta T₁ T₂ : ℝ} (hε : 0 ≤ ε) (hA : 0 ≤ Ac)
    (hh : 0 ≤ hC) (hp : 0 < Upipe) (hU : 0 ≤ UAx) (h0 : 0 ≤ T₁) (h12 : T₁ < T₂) :
    qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta < qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta := by
  have h := qNet_antitone (α := α) (Pin := Pin) (Twall := Twall) (Ta := Ta) hε hA hh hp.le hU h0 h12.le
  -- the pipe alone separates them: redo the bound with the strict pipe term
  unfold qNet qCoilLoss qPipe qPot qAbs at *
  have hσ : (0 : ℝ) ≤ sigmaSB := by unfold sigmaSB; norm_num
  have h4 : T₁ ^ 4 ≤ T₂ ^ 4 := pow_le_pow_left₀ h0 h12.le 4
  have hrad : ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) ≤ ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4) :=
    mul_le_mul_of_nonneg_left (by linarith) (by positivity)
  have hconv : hC * Ac * (T₁ - Ta) ≤ hC * Ac * (T₂ - Ta) :=
    mul_le_mul_of_nonneg_left (by linarith) (by positivity)
  have hpipe : Upipe * (T₁ - Ta) < Upipe * (T₂ - Ta) :=
    mul_lt_mul_of_pos_left (by linarith) hp
  have hpot : max 0 (UAx * (T₁ - Twall)) ≤ max 0 (UAx * (T₂ - Twall)) :=
    max_le_max le_rfl (mul_le_mul_of_nonneg_left (by linarith) hU)
  linarith

/-- **the steady state is unique**: two oil temperatures with no net heat are one -/
theorem steady_unique {α ε Ac hC Upipe UAx Pin Twall Ta T₁ T₂ : ℝ} (hε : 0 ≤ ε) (hA : 0 ≤ Ac)
    (hh : 0 ≤ hC) (hp : 0 < Upipe) (hU : 0 ≤ UAx) (h1 : 0 ≤ T₁) (h2 : 0 ≤ T₂)
    (e1 : qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta = 0)
    (e2 : qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta = 0) : T₁ = T₂ := by
  by_contra hne
  rcases lt_or_gt_of_ne hne with h | h
  · have := qNet_strictAnti (α := α) (Pin := Pin) (Twall := Twall) (Ta := Ta) hε hA hh hp hU h1 h
    linarith
  · have := qNet_strictAnti (α := α) (Pin := Pin) (Twall := Twall) (Ta := Ta) hε hA hh hp hU h2 h
    linarith

/-- the net heat is continuous in the oil's temperature -/
theorem qNet_continuous (α ε Ac hC Upipe UAx Pin Twall Ta : ℝ) :
    Continuous fun T => qNet α ε Ac hC Upipe UAx Pin T Twall Ta := by
  unfold qNet qCoilLoss qPipe qPot qAbs
  fun_prop

/-- **a steady state exists** between a cold oil, which gains, and a hot one, which loses:
the intermediate value theorem on the net heat -/
theorem steady_exists {α ε Ac hC Upipe UAx Pin Twall Ta Tlo Thi : ℝ} (hlt : Tlo ≤ Thi)
    (hlo : 0 ≤ qNet α ε Ac hC Upipe UAx Pin Tlo Twall Ta)
    (hhi : qNet α ε Ac hC Upipe UAx Pin Thi Twall Ta ≤ 0) :
    ∃ T ∈ Set.Icc Tlo Thi, qNet α ε Ac hC Upipe UAx Pin T Twall Ta = 0 := by
  have hc := (qNet_continuous α ε Ac hC Upipe UAx Pin Twall Ta).continuousOn (s := Set.Icc Tlo Thi)
  have hmem : (0 : ℝ) ∈ Set.Icc (qNet α ε Ac hC Upipe UAx Pin Thi Twall Ta)
      (qNet α ε Ac hC Upipe UAx Pin Tlo Twall Ta) := ⟨hhi, hlo⟩
  obtain ⟨T, hT, e⟩ := intermediate_value_Icc' hlt hc hmem
  exact ⟨T, hT, e⟩

/-- **conservation at a steady state**: the pot receives what the coil absorbed less the two
losses; with the oil above ambient it receives at most what the coil absorbed -/
theorem steady_conservation {α ε Ac hC Upipe UAx Pin Toil Twall Ta : ℝ}
    (e : qNet α ε Ac hC Upipe UAx Pin Toil Twall Ta = 0) :
    qPot UAx Toil Twall = qAbs α Pin - qCoilLoss ε Ac hC Toil Ta - qPipe Upipe Toil Ta := by
  unfold qNet at e; linarith

theorem steady_pot_le_abs {α ε Ac hC Upipe UAx Pin Toil Twall Ta : ℝ} (hε : 0 ≤ ε) (hA : 0 ≤ Ac)
    (hh : 0 ≤ hC) (hp : 0 ≤ Upipe) (h0 : 0 ≤ Ta) (hT : Ta ≤ Toil)
    (e : qNet α ε Ac hC Upipe UAx Pin Toil Twall Ta = 0) :
    qPot UAx Toil Twall ≤ qAbs α Pin := by
  rw [steady_conservation e]
  unfold qCoilLoss qPipe
  have hσ : (0 : ℝ) ≤ sigmaSB := by unfold sigmaSB; norm_num
  have h4 : Ta ^ 4 ≤ Toil ^ 4 := pow_le_pow_left₀ h0 hT 4
  have := mul_nonneg (mul_nonneg (mul_nonneg hε hσ) hA) (sub_nonneg.2 h4)
  have := mul_nonneg (mul_nonneg hh hA) (sub_nonneg.2 hT)
  have := mul_nonneg hp (sub_nonneg.2 hT)
  linarith

/-- `T₁⁴ - T₂⁴` on `[0, M]` is within `4 M³ |T₁ - T₂|` -/
theorem pow4_lipschitz {T₁ T₂ M : ℝ} (h1 : 0 ≤ T₁) (h1' : T₁ ≤ M) (h2 : 0 ≤ T₂) (h2' : T₂ ≤ M) :
    |T₁ ^ 4 - T₂ ^ 4| ≤ 4 * M ^ 3 * |T₁ - T₂| := by
  have e : T₁ ^ 4 - T₂ ^ 4 = (T₁ - T₂) * (T₁ ^ 3 + T₁ ^ 2 * T₂ + T₁ * T₂ ^ 2 + T₂ ^ 3) := by ring
  rw [e, abs_mul, mul_comm (4 * M ^ 3)]
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
  have hM : 0 ≤ M := le_trans h1 h1'
  have s0 : 0 ≤ T₁ ^ 3 + T₁ ^ 2 * T₂ + T₁ * T₂ ^ 2 + T₂ ^ 3 := by positivity
  rw [abs_of_nonneg s0]
  have a1 : T₁ ^ 3 ≤ M ^ 3 := pow_le_pow_left₀ h1 h1' 3
  have a2 : T₁ ^ 2 * T₂ ≤ M ^ 3 := by
    calc T₁ ^ 2 * T₂ ≤ M ^ 2 * M := mul_le_mul (pow_le_pow_left₀ h1 h1' 2) h2' h2 (by positivity)
      _ = M ^ 3 := by ring
  have a3 : T₁ * T₂ ^ 2 ≤ M ^ 3 := by
    calc T₁ * T₂ ^ 2 ≤ M * M ^ 2 := mul_le_mul h1' (pow_le_pow_left₀ h2 h2' 2) (by positivity) hM
      _ = M ^ 3 := by ring
  have a4 : T₂ ^ 3 ≤ M ^ 3 := pow_le_pow_left₀ h2 h2' 3
  linarith

/-- **the modulus of the net heat** in the oil's temperature on `[0, M]`:
`4 ε σ Ac M³ + hC Ac + Upipe + UAx` per kelvin - what one step of the oil costs Modula -/
theorem qNet_lipschitz {α ε Ac hC Upipe UAx Pin Twall Ta T₁ T₂ M : ℝ} (hε : 0 ≤ ε) (hA : 0 ≤ Ac)
    (hh : 0 ≤ hC) (hp : 0 ≤ Upipe) (hU : 0 ≤ UAx)
    (h1 : 0 ≤ T₁) (h1' : T₁ ≤ M) (h2 : 0 ≤ T₂) (h2' : T₂ ≤ M) :
    |qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta - qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta|
      ≤ (4 * ε * sigmaSB * Ac * M ^ 3 + hC * Ac + Upipe + UAx) * |T₁ - T₂| := by
  unfold qNet qCoilLoss qPipe qPot qAbs
  have hσ : (0 : ℝ) ≤ sigmaSB := by unfold sigmaSB; norm_num
  have hr := pow4_lipschitz h1 h1' h2 h2'
  have hrad : |ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) - ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4)|
      ≤ 4 * ε * sigmaSB * Ac * M ^ 3 * |T₁ - T₂| := by
    rw [← mul_sub, abs_mul, abs_of_nonneg (by positivity : 0 ≤ ε * sigmaSB * Ac)]
    have e : ε * sigmaSB * Ac * (4 * M ^ 3 * |T₁ - T₂|) = 4 * ε * sigmaSB * Ac * M ^ 3 * |T₁ - T₂| := by ring
    have : T₁ ^ 4 - Ta ^ 4 - (T₂ ^ 4 - Ta ^ 4) = T₁ ^ 4 - T₂ ^ 4 := by ring
    rw [this, ← e]
    exact mul_le_mul_of_nonneg_left hr (by positivity)
  have hconv : |hC * Ac * (T₁ - Ta) - hC * Ac * (T₂ - Ta)| ≤ hC * Ac * |T₁ - T₂| := by
    rw [← mul_sub, abs_mul, abs_of_nonneg (by positivity : 0 ≤ hC * Ac)]
    have : T₁ - Ta - (T₂ - Ta) = T₁ - T₂ := by ring
    rw [this]
  have hpipe : |Upipe * (T₁ - Ta) - Upipe * (T₂ - Ta)| ≤ Upipe * |T₁ - T₂| := by
    rw [← mul_sub, abs_mul, abs_of_nonneg hp]
    have : T₁ - Ta - (T₂ - Ta) = T₁ - T₂ := by ring
    rw [this]
  have hpot : |max 0 (UAx * (T₁ - Twall)) - max 0 (UAx * (T₂ - Twall))| ≤ UAx * |T₁ - T₂| := by
    have h := abs_max_sub_max_le_max 0 (UAx * (T₁ - Twall)) 0 (UAx * (T₂ - Twall))
    rw [sub_self, abs_zero, max_eq_right (abs_nonneg (UAx * (T₁ - Twall) - UAx * (T₂ - Twall)))] at h
    calc |max 0 (UAx * (T₁ - Twall)) - max 0 (UAx * (T₂ - Twall))|
        ≤ |UAx * (T₁ - Twall) - UAx * (T₂ - Twall)| := h
      _ = UAx * |T₁ - T₂| := by
        rw [← mul_sub, abs_mul, abs_of_nonneg hU]
        have : T₁ - Twall - (T₂ - Twall) = T₁ - T₂ := by ring
        rw [this]
  calc |α * Pin - (ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) + hC * Ac * (T₁ - Ta)) - Upipe * (T₁ - Ta)
          - max 0 (UAx * (T₁ - Twall)) -
        (α * Pin - (ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4) + hC * Ac * (T₂ - Ta)) - Upipe * (T₂ - Ta)
          - max 0 (UAx * (T₂ - Twall)))|
      = |-(ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) - ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4))
          - (hC * Ac * (T₁ - Ta) - hC * Ac * (T₂ - Ta)) - (Upipe * (T₁ - Ta) - Upipe * (T₂ - Ta))
          - (max 0 (UAx * (T₁ - Twall)) - max 0 (UAx * (T₂ - Twall)))| := by ring_nf
    _ ≤ |ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) - ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4)|
          + |hC * Ac * (T₁ - Ta) - hC * Ac * (T₂ - Ta)| + |Upipe * (T₁ - Ta) - Upipe * (T₂ - Ta)|
          + |max 0 (UAx * (T₁ - Twall)) - max 0 (UAx * (T₂ - Twall))| := by
        have := abs_sub (-(ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) - ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4))
          - (hC * Ac * (T₁ - Ta) - hC * Ac * (T₂ - Ta)) - (Upipe * (T₁ - Ta) - Upipe * (T₂ - Ta)))
          (max 0 (UAx * (T₁ - Twall)) - max 0 (UAx * (T₂ - Twall)))
        have h2 := abs_sub (-(ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) - ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4))
          - (hC * Ac * (T₁ - Ta) - hC * Ac * (T₂ - Ta))) (Upipe * (T₁ - Ta) - Upipe * (T₂ - Ta))
        have h3 := abs_sub (-(ε * sigmaSB * Ac * (T₁ ^ 4 - Ta ^ 4) - ε * sigmaSB * Ac * (T₂ ^ 4 - Ta ^ 4)))
          (hC * Ac * (T₁ - Ta) - hC * Ac * (T₂ - Ta))
        rw [abs_neg] at h3
        linarith
    _ ≤ 4 * ε * sigmaSB * Ac * M ^ 3 * |T₁ - T₂| + hC * Ac * |T₁ - T₂| + Upipe * |T₁ - T₂| + UAx * |T₁ - T₂| := by
        linarith
    _ = (4 * ε * sigmaSB * Ac * M ^ 3 + hC * Ac + Upipe + UAx) * |T₁ - T₂| := by ring

/-- **the modulus of one step of the oil**: `1 + dt K / Coil` with `K` the net heat's constant;
`min` with the limit costs nothing -/
theorem oilStep_lipschitz {α ε Ac hC Upipe UAx Coil ToilMax Pin Twall Ta dt T₁ T₂ M : ℝ}
    (hε : 0 ≤ ε) (hA : 0 ≤ Ac) (hh : 0 ≤ hC) (hp : 0 ≤ Upipe) (hU : 0 ≤ UAx) (hC0 : 0 < Coil)
    (hdt : 0 ≤ dt) (h1 : 0 ≤ T₁) (h1' : T₁ ≤ M) (h2 : 0 ≤ T₂) (h2' : T₂ ≤ M) :
    |oilStep α ε Ac hC Upipe UAx Coil ToilMax Pin T₁ Twall Ta dt
      - oilStep α ε Ac hC Upipe UAx Coil ToilMax Pin T₂ Twall Ta dt|
      ≤ (1 + dt * (4 * ε * sigmaSB * Ac * M ^ 3 + hC * Ac + Upipe + UAx) / Coil) * |T₁ - T₂| := by
  unfold oilStep
  have hq := qNet_lipschitz (α := α) (Pin := Pin) (Twall := Twall) (Ta := Ta) hε hA hh hp hU h1 h1' h2 h2'
  set K := 4 * ε * sigmaSB * Ac * M ^ 3 + hC * Ac + Upipe + UAx with hK
  have hmin := abs_min_sub_min_le_max ToilMax (T₁ + dt * qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta / Coil)
    ToilMax (T₂ + dt * qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta / Coil)
  rw [sub_self, abs_zero, max_eq_right (abs_nonneg ((T₁ + dt * qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta / Coil)
    - (T₂ + dt * qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta / Coil)))] at hmin
  calc |min ToilMax (T₁ + dt * qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta / Coil)
          - min ToilMax (T₂ + dt * qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta / Coil)|
      ≤ |(T₁ + dt * qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta / Coil)
          - (T₂ + dt * qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta / Coil)| := hmin
    _ = |(T₁ - T₂) + dt / Coil * (qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta
          - qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta)| := by ring_nf
    _ ≤ |T₁ - T₂| + |dt / Coil * (qNet α ε Ac hC Upipe UAx Pin T₁ Twall Ta
          - qNet α ε Ac hC Upipe UAx Pin T₂ Twall Ta)| := abs_add_le _ _
    _ ≤ |T₁ - T₂| + dt / Coil * (K * |T₁ - T₂|) := by
        rw [abs_mul, abs_of_nonneg (by positivity : 0 ≤ dt / Coil)]
        have := mul_le_mul_of_nonneg_left hq (by positivity : 0 ≤ dt / Coil)
        linarith
    _ = (1 + dt * K / Coil) * |T₁ - T₂| := by ring

end TandoorHashemi

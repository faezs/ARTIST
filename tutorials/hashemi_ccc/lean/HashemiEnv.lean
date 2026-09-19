/-
# The env's step as one morphism

The mount, the optics and the heat as ONE definition, extracted by Ccc into ONE Metal kernel:
`megaStep` advances the pose (Hashemi.lean's machine); on the new pose 64 rays of `dishPower`
(HashemiTrace.lean) are the tensor power of one morphism and their sum the reduction - one
thread per ray, the sum in threadgroup memory; the delivered power goes to `heatStep`
(HashemiHeat.lean), the coil, the oil, the pipes, the pot. The rays are independent, so they
tensor; the heat needs the optics' output, so it composes. Nothing of this is glued in a host.
-/
import RequestProject.HashemiTrace
import RequestProject.HashemiHeat
import RequestProject.HashemiField

namespace TandoorHashemi
open Classical

/-- the rays per agent per step -/
def envRays : ℕ := 64

/-- **the env's step**: inputs the mount's 17 (`megaStep`), the optics' `R f a w rc k σslope
σspec hsun soil`, the loop's `α ε Ac hC Upipe UAx mcp Twall Ta`, the two histories along the
pipe (`hist`: the coil's outlet, `ret`: the exchanger's outlet; most recent first) and the ray
table `dr`. Outputs `megaStep`'s 17 columns; `capture, capture_s, per_dni, p_in`; the loop's
`T_out, q_abs, q_coil_loss, q_pipe, q_pot, q_net`; the eight observations of the new state; then
the FIELDS: the receiver's flux in eight annuli (W), the oil along the eight turns (K), the
density along the pipe as the two shifted histories (K). The loop is HashemiField.lean's: plug
flow with the pipe's Green's function, the coil a fold along the flow. -/
noncomputable def hashemiEnv (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) : Fin 83 → ℝ :=
  let s := megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
  let cap := (∑ i : Fin 64, dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0) / 64
  let capS := (∑ i : Fin 64, dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 4) / 64
  let per := (2 * a) ^ 2 * rho * cap
  let Pin := per * dni * soil
  -- the receiver's flux: the captured power in annulus k of the aperture (W)
  -- the indicator decided CLASSICALLY and explicitly: `inBin` is a definition, so instance
  -- synthesis cannot see the conjunction inside it and picks `Classical.propDecidable` for that
  -- half and a structural instance for the other - a term no printed `if` can be re-elaborated
  -- into.  Written this way the twin prints the instance it sees (`@ite _ … propDecidable …`).
  let binOf := fun (j : Fin 8) => (∑ i : Fin 64, @b2r (inBin rc (dishPower R f a w rc k σslope σspec rho hsun
    (s 0) (s 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 3)
    j ∧ dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0 > 0.5)
    (Classical.propDecidable _))
    / 64 * (2 * a) ^ 2 * rho * dni * soil
  -- the eight annuli LISTED: the same function, written as the vector it is, so the round trip
  -- can print `coilProfile … ![b 0, …, b 7]` as the text this line writes (a lambda has none)
  let bin : Fin 8 → ℝ := ![binOf 0, binOf 1, binOf 2, binOf 3, binOf 4, binOf 5, binOf 6, binOf 7]
  -- the pipe: what the pot receives is the coil's outlet two steps ago, attenuated over half the
  -- run; the exchanger draws down to the wall at most; the return runs the other half
  let Tpot := delivered (Upipe / 2) mcp Ta (hist 1)
  let qPot := min UAx mcp * max 0 (Tpot - Twall)
  let Tret := Tpot - qPot / mcp
  let Tin := delivered (Upipe / 2) mcp Ta (ret 1)
  -- the coil: the oil through the eight turns
  let prof := coilProfile α ε Ac hC Ta mcp Tin bin
  let Tout := prof 7
  let qAbs := α * (bin 0 + bin 1 + bin 2 + bin 3 + bin 4 + bin 5 + bin 6 + bin 7)
  let qCoil := qAbs - mcp * (Tout - Tin)
  let qPipe := mcp * ((hist 1 - Tpot) + (ret 1 - Tin))
  let qNet := qAbs - qCoil - qPipe - qPot
  let h' := shift Tout hist
  let r' := shift Tret ret
  let eAz := (azSun - s 0) - 2 * Real.pi * ((⌊((azSun - s 0) + Real.pi) / (2 * Real.pi)⌋ : ℤ) : ℝ)
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9, s 10, s 11, s 12, s 13, s 14, s 15, s 16,
    cap, capS, per, Pin, Tout, qAbs, qCoil, qPipe, qPot, qNet,
    eAz, (Real.pi / 2 - s 1) - elSun, s 1, s 6, s 7, (Tout - 300) / 300, s 15, s 16,
    bin 0, bin 1, bin 2, bin 3, bin 4, bin 5, bin 6, bin 7,
    prof 0, prof 1, prof 2, prof 3, prof 4, prof 5, prof 6, prof 7,
    h' 0, h' 1, h' 2, h' 3, h' 4, h' 5, h' 6, h' 7, h' 8, h' 9, h' 10, h' 11, h' 12, h' 13, h' 14, h' 15,
    r' 0, r' 1, r' 2, r' 3, r' 4, r' 5, r' 6, r' 7, r' 8, r' 9, r' 10, r' 11, r' 12, r' 13, r' 14, r' 15]

/-- the columns -/
def envNames : Array String := #[
  "az_next", "t_next", "slack_next", "wire_len", "t_dead", "stalled", "taut", "wire_holds", "arm",
  "swing_rate", "az_rate", "pointing_err", "el_dish", "sun_reachable", "lost_sun", "sun_reachable_s", "lost_sun_s",
  "capture", "capture_s", "per_dni", "p_in", "T_oil", "q_abs", "q_coil_loss", "q_pipe", "q_pot", "q_net",
  "obs_e_az", "obs_e_el", "obs_swing", "obs_taut", "obs_holds", "obs_oil", "obs_reach_s", "obs_lost_s",
  "flux_0", "flux_1", "flux_2", "flux_3", "flux_4", "flux_5", "flux_6", "flux_7",
  "coil_0", "coil_1", "coil_2", "coil_3", "coil_4", "coil_5", "coil_6", "coil_7",
  "hist_0", "hist_1", "hist_2", "hist_3", "hist_4", "hist_5", "hist_6", "hist_7",
  "hist_8", "hist_9", "hist_10", "hist_11", "hist_12", "hist_13", "hist_14", "hist_15",
  "ret_0", "ret_1", "ret_2", "ret_3", "ret_4", "ret_5", "ret_6", "ret_7",
  "ret_8", "ret_9", "ret_10", "ret_11", "ret_12", "ret_13", "ret_14", "ret_15"]

theorem envNames_size : envNames.size = 83 := by rfl

/-- the capture is a mean of Booleans: in `[0, 1]` -/
theorem hashemiEnv_capture_mem (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) :
    0 ≤ hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta hist ret dr 17 ∧
      hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta hist ret dr 17 ≤ 1 := by
  simp only [hashemiEnv]
  simp only [Matrix.cons_val]
  have h : ∀ i : Fin 64,
      0 ≤ dishPower R f a w rc k σslope σspec rho hsun
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0)
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun
        (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0 ∧
      dishPower R f a w rc k σslope σspec rho hsun
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0)
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun
        (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0 ≤ 1 := by
    intro i
    rcases dishPower_captured R f a w rc k σslope σspec rho hsun
      (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0)
      (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun
      (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) with e | e <;>
      rw [e] <;> norm_num
  constructor
  · exact div_nonneg (Finset.sum_nonneg fun i _ => (h i).1) (by norm_num)
  · rw [div_le_one (by norm_num)]
    calc _ ≤ ∑ _i : Fin 64, (1 : ℝ) := Finset.sum_le_sum fun i _ => (h i).2
      _ = 64 := by simp

/-- the pot never receives more than the exchanger can pass: `min UAx mcp` per kelvin of excess -/
theorem hashemiEnv_pot_le (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) (hU : 0 ≤ UAx) (hm : 0 ≤ mcp) :
    hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta hist ret dr 25
      ≤ UAx * max 0 (delivered (Upipe / 2) mcp Ta (hist 1) - Twall) := by
  simp only [hashemiEnv]
  simp only [Matrix.cons_val]
  apply mul_le_mul_of_nonneg_right (min_le_left _ _) (le_max_left _ _)

/-- the pipe's density record moves one station: the new history's head is the coil's outlet -/
theorem hashemiEnv_hist_head (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) :
    hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta hist ret dr 51
      = hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta hist ret dr 21 := by
  simp only [hashemiEnv]
  simp only [Matrix.cons_val, shift]

end TandoorHashemi

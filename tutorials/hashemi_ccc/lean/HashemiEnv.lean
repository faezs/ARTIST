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

namespace TandoorHashemi
open Classical

/-- the rays per agent per step -/
def envRays : ℕ := 64

/-- **the env's step**: inputs the mount's 17 (`megaStep`), the optics' `R f a w rc k σslope
σspec hsun soil`, the heat's `α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta`, and the ray table
`dr` (64 rays × the sampler's six uniforms and four normals). Outputs `megaStep`'s 17 columns,
then `capture, capture_s, per_dni, p_in`, then `heatStep`'s six. -/
noncomputable def hashemiEnv (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) : Fin 27 → ℝ :=
  let s := megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
  let cap := (∑ i : Fin 64, dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0) / 64
  let capS := (∑ i : Fin 64, dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 4) / 64
  let per := (2 * a) ^ 2 * rho * cap
  let Pin := per * dni * soil
  let h := heatStep α ε Ac hC Upipe UAx Coil ToilMax Pin Toil Twall Ta dt
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9, s 10, s 11, s 12, s 13, s 14, s 15, s 16,
    cap, capS, per, Pin, h 0, h 1, h 2, h 3, h 4, h 5]

/-- the columns -/
def envNames : Array String := #[
  "az_next", "t_next", "slack_next", "wire_len", "t_dead", "stalled", "taut", "wire_holds", "arm",
  "swing_rate", "az_rate", "pointing_err", "el_dish", "sun_reachable", "lost_sun", "sun_reachable_s", "lost_sun_s",
  "capture", "capture_s", "per_dni", "p_in", "T_oil", "q_abs", "q_coil_loss", "q_pipe", "q_pot", "q_net"]

theorem envNames_size : envNames.size = 27 := by rfl

/-- the capture is a mean of Booleans: in `[0, 1]` -/
theorem hashemiEnv_capture_mem (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) :
    0 ≤ hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta dr 17 ∧
      hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta dr 17 ≤ 1 := by
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

/-- the pot never receives more than the exchanger can pass: `UAx max 0 (Toil - Twall)` -/
theorem hashemiEnv_pot_le (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (hU : 0 ≤ UAx) :
    hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta dr 25
      ≤ UAx * max 0 (Toil - Twall) := by
  simp only [hashemiEnv, heatStep]
  simp only [Matrix.cons_val]
  exact qPot_le hU

/-- the oil never exceeds its limit -/
theorem hashemiEnv_oil_le (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) :
    hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx Coil ToilMax Toil Twall Ta dr 21
      ≤ ToilMax := by
  simp only [hashemiEnv, heatStep, oilStep]
  simp only [Matrix.cons_val]
  exact min_le_left _ _

end TandoorHashemi

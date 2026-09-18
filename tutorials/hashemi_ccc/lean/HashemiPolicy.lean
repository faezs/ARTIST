/-
# The policy of his machine, from the spec

Hashemi.lean's machine is one mirror on two motors: the roller's yaw about the tube and the
winch's swing about the bolt line (section 3, the FACT description: two freedoms, two
actuations). Its policy is a map from what its sensors give to those two drives, and that
interface is a fact of the spec, not of the tandoor's nineteen heads. This file states it and
lets Ccc extract it with everything else:

* **the actuation**: a command in `[-1, 1]` per motor, full command at the machine's rates
  (`driveAz`, `driveEl`; the rates are the env's assumed motors, the video gives neither drum
  nor ratios); a seven-level head maps to it (`headToCmd`), and the finest step both outruns
  the sun and stays inside the tracker's budget (`quantum_outruns_sun`, `quantum_within_budget`)
  - the property the first training run lacked;
* **the sensing** (`obsOf`): the rim sensor's two pointing errors, the swing, the wire's state,
  the oil's temperature, the two smooth gates;
* **the reference policy** (`follower`): the saturated follower of Mount.lean on each axis - one
  step inside the budget zeroes the error (`follower_step_az`, `follower_step_el`), and
  `tracks_exactly` / `el_tracks_exactly` say it keeps the sun exactly at the drives' rates;
* **a policy of this interface** (`mlpPolicy`): one hidden layer of 16 tanh units, its weights
  as inputs (shared by every agent), its outputs inside `(-1, 1)` (`mlpPolicy_bounded`);
* **the closed loop** (`hashemiLoop`): the observation, the policy, the drives, the env's step -
  one morphism, one kernel: the policy's tangent and box come with it;
* **the observation's bounds** (`obsLo`, `obsHi`, `wrapRad_mem`): what the generated space module
  reads for the Box.
-/
import RequestProject.HashemiEnv

namespace TandoorHashemi
open Classical

/-! ## The actuation -/

/-- the roller's yaw at full command, rad/s of the dish (the env's motor: 0.035 deg/s) -/
noncomputable def azFull : ℝ := 0.035 * Real.pi / 180

/-- the winch's swing at full command, rad/s of the dish (0.025 deg/s) -/
noncomputable def elFull : ℝ := 0.025 * Real.pi / 180

/-- the heads' levels: seven, `0..6`, `3` at rest -/
def actionLevels : ℕ := 7

/-- a head's value to a command in `[-1, 1]` -/
noncomputable def headToCmd (h : ℝ) : ℝ := (min (max h 0) 6 - 3) / 3

/-- the roller's rate for a command: `azRate ωm rw R = u azFull` -/
noncomputable def driveAz (u rw R : ℝ) : ℝ := u * azFull * R / rw

/-- the drum's rate for a command at the wire's lever arm: `elRate ωd rDrum arm = u elFull`;
a positive command pays wire and lowers the dish -/
noncomputable def driveEl (u arm rDrum : ℝ) : ℝ := u * elFull * arm / rDrum

theorem driveAz_rate (u rw R : ℝ) (hrw : rw ≠ 0) (hR : R ≠ 0) :
    azRate (driveAz u rw R) rw R = u * azFull := by
  unfold azRate driveAz; field_simp

theorem driveEl_rate (u arm rDrum : ℝ) (hr : rDrum ≠ 0) (ha : arm ≠ 0) :
    elRate (driveEl u arm rDrum) rDrum arm = u * elFull := by
  unfold elRate driveEl; field_simp

/-- the sun's fastest rate, rad/s: the Earth's 15 deg/h -/
noncomputable def sunRate : ℝ := 7.3e-5

/-- **the finest step outruns the sun**: a third of full command on either motor is faster than
the sun ever moves, so a follower can keep up -/
theorem quantum_outruns_sun : sunRate < elFull / 3 ∧ sunRate < azFull / 3 := by
  unfold sunRate elFull azFull
  constructor <;> nlinarith [Real.pi_gt_three]

/-- **and stays inside the tracker's budget**: over a 15 s step the finest step moves the dish
under the 0.03 rad the receiver allows (`tracker_margin_hashemi`) -/
theorem quantum_within_budget : azFull / 3 * 15 < 0.03 ∧ elFull / 3 * 15 < 0.03 := by
  unfold azFull elFull
  constructor <;> nlinarith [Real.pi_le_four]

/-- the heads as drives: azimuth, and elevation with the parent's sense (a head above rest
raises the dish, so the command is negated into the paying-out drive) -/
noncomputable def headToDriveAz (h rw R : ℝ) : ℝ := driveAz (headToCmd h) rw R
noncomputable def headToDriveEl (h arm rDrum : ℝ) : ℝ := driveEl (-(headToCmd h)) arm rDrum

/-! ## The sensing -/

/-- an angle wrapped to `[-π, π)` -/
noncomputable def wrapRad (d : ℝ) : ℝ :=
  d - 2 * Real.pi * ((⌊(d + Real.pi) / (2 * Real.pi)⌋ : ℤ) : ℝ)

/-- **the machine's observation**: the rim sensor's azimuth error (the sun ahead of the dish,
wrapped) and elevation error (the dish above the sun), the swing, the wire taut and holding,
the oil's temperature (scaled), and the two smooth gates -/
noncomputable def obsOf (az t elSun azSun taut holds Toil tDead : ℝ) : Fin 8 → ℝ :=
  ![wrapRad (azSun - az), (Real.pi / 2 - t) - elSun, t, taut, holds, (Toil - 300) / 300,
    sunReachableS tDead elSun, lostSunS tDead az t elSun azSun 0.03]

def obsNames : Array String := #["e_az", "e_el", "swing", "taut", "holds", "oil", "reach_s", "lost_s"]

/-- the observation's bounds: the wrapped azimuth error in `[-π, π)`, the elevation error within a
right angle, the swing from the zenith to the vertical, the wire's flags, the oil from ambient to
its limit (`(593 - 300) / 300`), the gates in `[0, 1]` -/
noncomputable def obsLo : Fin 8 → ℝ := ![-Real.pi, -Real.pi / 2, 0, 0, 0, 0, 0, 0]
noncomputable def obsHi : Fin 8 → ℝ := ![Real.pi, Real.pi / 2, Real.pi / 2, 1, 1, 293 / 300, 1, 1]

theorem wrapRad_mem (d : ℝ) : -Real.pi ≤ wrapRad d ∧ wrapRad d < Real.pi := by
  unfold wrapRad
  have hpos : (0 : ℝ) < 2 * Real.pi := by positivity
  have h1 := Int.floor_le ((d + Real.pi) / (2 * Real.pi))
  have h2 := Int.lt_floor_add_one ((d + Real.pi) / (2 * Real.pi))
  have e : (d + Real.pi) / (2 * Real.pi) * (2 * Real.pi) = d + Real.pi := by field_simp
  have l1 := mul_le_mul_of_nonneg_right h1 hpos.le
  have l2 := mul_lt_mul_of_pos_right h2 hpos
  rw [e] at l1 l2
  constructor <;> nlinarith [l1, l2]

def actionNames : Array String := #["u_az", "u_el"]

/-! ## The reference policy: the follower -/

/-- the follower on each axis: the error saturated to one step's move, as a fraction of full
command (`TandoorMount.sat`, the follower of Mount.lean) -/
noncomputable def follower (eAz eEl dt : ℝ) : Fin 2 → ℝ :=
  ![TandoorMount.sat (azFull * dt) eAz / (azFull * dt), TandoorMount.sat (elFull * dt) eEl / (elFull * dt)]

theorem azFull_pos : 0 < azFull := by unfold azFull; positivity
theorem elFull_pos : 0 < elFull := by unfold elFull; positivity

/-- **one step inside the budget zeroes the azimuth error** -/
theorem follower_step_az {eAz eEl dt : ℝ} (hdt : 0 < dt) (h : |eAz| ≤ azFull * dt) :
    eAz - azFull * dt * follower eAz eEl dt 0 = 0 := by
  simp only [follower, Matrix.cons_val_zero]
  have hb : azFull * dt ≠ 0 := (mul_pos azFull_pos hdt).ne'
  rw [TandoorMount.sat_of_abs_le h, mul_div_cancel₀ _ hb]
  ring

/-- **and the elevation error** -/
theorem follower_step_el {eAz eEl dt : ℝ} (hdt : 0 < dt) (h : |eEl| ≤ elFull * dt) :
    eEl - elFull * dt * follower eAz eEl dt 1 = 0 := by
  simp only [follower, Matrix.cons_val]
  have hb : elFull * dt ≠ 0 := (mul_pos elFull_pos hdt).ne'
  rw [TandoorMount.sat_of_abs_le h, mul_div_cancel₀ _ hb]
  ring

/-- the follower's command is within full command -/
theorem follower_bounded (eAz eEl dt : ℝ) (hdt : 0 < dt) :
    |follower eAz eEl dt 0| ≤ 1 ∧ |follower eAz eEl dt 1| ≤ 1 := by
  have ha := mul_pos azFull_pos hdt
  have he := mul_pos elFull_pos hdt
  simp only [follower, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, TandoorMount.sat]
  constructor
  · rw [abs_div, abs_of_pos ha, div_le_one ha, abs_le]
    constructor
    · exact le_max_left _ _
    · exact max_le (by linarith) (min_le_right _ _)
  · rw [abs_div, abs_of_pos he, div_le_one he, abs_le]
    constructor
    · exact le_max_left _ _
    · exact max_le (by linarith) (min_le_right _ _)

/-! ## A policy of this interface -/

/-- `|tanh x| < 1` -/
theorem tanh_abs_lt_one (x : ℝ) : |Real.tanh x| < 1 := by
  rw [Real.tanh_eq_sinh_div_cosh, abs_div, abs_of_pos (Real.cosh_pos x), div_lt_one (Real.cosh_pos x)]
  exact abs_lt_of_sq_lt_sq (by nlinarith [Real.cosh_sq x]) (Real.cosh_pos x).le

/-- one hidden layer of 16 tanh units over the eight observations, two tanh outputs: the
weights are inputs, shared by every agent -/
noncomputable def mlpPolicy (W1 : Fin 16 → Fin 8 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 2 → Fin 16 → ℝ)
    (b2 : Fin 2 → ℝ) (o : Fin 8 → ℝ) : Fin 2 → ℝ :=
  let h : Fin 16 → ℝ := fun i => Real.tanh ((∑ j : Fin 8, W1 i j * o j) + b1 i)
  fun k => Real.tanh ((∑ i : Fin 16, W2 k i * h i) + b2 k)

/-- the policy's outputs are commands: within `[-1, 1]` (strictly inside by `tanh_abs_lt_one`;
the closed bound is what a float witnesses, a saturated unit giving 1.0 exactly) -/
theorem mlpPolicy_bounded (W1 : Fin 16 → Fin 8 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 2 → Fin 16 → ℝ)
    (b2 : Fin 2 → ℝ) (o : Fin 8 → ℝ) (k : Fin 2) : |mlpPolicy W1 b1 W2 b2 o k| ≤ 1 :=
  (tanh_abs_lt_one _).le

/-! ## The closed loop as one morphism -/

/-- **the closed loop**: the observation of the state, the policy, the two drives (the wire's
lever arm at the current swing), the env's step. Outputs the env's 83 columns, the eight
observations the policy acted on and its two commands. -/
noncomputable def hashemiLoop (az t slack dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta
    tautPrev holdsPrev tDead : ℝ)
    (W1 : Fin 16 → Fin 8 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 2 → Fin 16 → ℝ) (b2 : Fin 2 → ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) : Fin 93 → ℝ :=
  let o := obsOf az t elSun azSun tautPrev holdsPrev (hist 0) tDead
  let u := mlpPolicy W1 b1 W2 b2 o
  let arm := leverAt ymHashemi hpHashemi dishHalf zeHashemi t
  let ωm := driveAz (u 0) hashemi.rDrive (rollerRadius hashemi)
  let ωd := driveEl (u 1) arm rDrum
  let s := hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac hC Upipe UAx mcp Twall Ta hist ret dr
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9, s 10, s 11, s 12, s 13, s 14, s 15,
    s 16, s 17, s 18, s 19, s 20, s 21, s 22, s 23, s 24, s 25, s 26, s 27, s 28, s 29, s 30, s 31,
    s 32, s 33, s 34, s 35, s 36, s 37, s 38, s 39, s 40, s 41, s 42, s 43, s 44, s 45, s 46, s 47,
    s 48, s 49, s 50, s 51, s 52, s 53, s 54, s 55, s 56, s 57, s 58, s 59, s 60, s 61, s 62, s 63,
    s 64, s 65, s 66, s 67, s 68, s 69, s 70, s 71, s 72, s 73, s 74, s 75, s 76, s 77, s 78, s 79,
    s 80, s 81, s 82, o 0, o 1, o 2, o 3, o 4, o 5, o 6, o 7, u 0, u 1]

def loopNames : Array String := #[
  "az_next", "t_next", "slack_next", "wire_len", "t_dead", "stalled", "taut", "wire_holds", "arm",
  "swing_rate", "az_rate", "pointing_err", "el_dish", "sun_reachable", "lost_sun", "sun_reachable_s", "lost_sun_s",
  "capture", "capture_s", "per_dni", "p_in", "T_oil", "q_abs", "q_coil_loss", "q_pipe", "q_pot", "q_net",
  "obs_e_az", "obs_e_el", "obs_swing", "obs_taut", "obs_holds", "obs_oil", "obs_reach_s", "obs_lost_s",
  "flux_0", "flux_1", "flux_2", "flux_3", "flux_4", "flux_5", "flux_6", "flux_7",
  "coil_0", "coil_1", "coil_2", "coil_3", "coil_4", "coil_5", "coil_6", "coil_7",
  "hist_0", "hist_1", "hist_2", "hist_3", "hist_4", "hist_5", "hist_6", "hist_7",
  "hist_8", "hist_9", "hist_10", "hist_11", "hist_12", "hist_13", "hist_14", "hist_15",
  "ret_0", "ret_1", "ret_2", "ret_3", "ret_4", "ret_5", "ret_6", "ret_7",
  "ret_8", "ret_9", "ret_10", "ret_11", "ret_12", "ret_13", "ret_14", "ret_15",
  "e_az", "e_el", "swing", "taut_obs", "holds_obs", "oil", "reach_s", "lost_s", "u_az", "u_el"]

theorem loopNames_size : loopNames.size = 93 := by rfl

end TandoorHashemi

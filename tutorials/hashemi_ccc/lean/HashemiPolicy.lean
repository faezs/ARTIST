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

/-! ## The pump, on the parent's pinned head -/

/-- **the pump's command from a seven-level head**: the parent tandoor env's head 0 was the
membrane's level, which his dish does not have, so `hashemi_tandoor_env.py` pinned it - and read
it first.  Here it is the PUMP: level `h` of seven is the fraction `h / 6` of the maximum
volumetric flow, from a stopped loop at 0 to full flow at 6.  Nothing else in the parent's
nineteen heads is free, and the loop needs exactly one more command than the two motors.
(`HashemiOil.lean`: the flow sets the Reynolds number, the film coefficient, the exchanger's UA,
the pipe's delay, the film temperature and the pump's electrical power - one head, six laws.) -/
noncomputable def pumpOf : Fin 7 → ℝ := ![0, 1/6, 2/6, 3/6, 4/6, 5/6, 1]

/-- the pump's command is a fraction -/
theorem pumpOf_mem (h : Fin 7) : 0 ≤ pumpOf h ∧ pumpOf h ≤ 1 := by
  fin_cases h <;> (unfold pumpOf; norm_num)

/-- level 0 stops the loop and level 6 opens it: the head spans the whole range -/
theorem pumpOf_ends : pumpOf 0 = 0 ∧ pumpOf 6 = 1 := by
  constructor <;> simp only [pumpOf, Matrix.cons_val]

/-- a continuous command mapped to the same fraction (the closed loop's third output, a `tanh` in
`[-1, 1]`, read as `(u + 1) / 2`) -/
noncomputable def pumpCmd (u : ℝ) : ℝ := min (max ((u + 1) / 2) 0) 1

theorem pumpCmd_mem (u : ℝ) : 0 ≤ pumpCmd u ∧ pumpCmd u ≤ 1 :=
  ⟨le_min (le_max_right _ _) (by norm_num), min_le_right _ _⟩

/-! ## The sensing -/

/-- an angle wrapped to `[-π, π)` -/
noncomputable def wrapRad (d : ℝ) : ℝ :=
  d - 2 * Real.pi * ((⌊(d + Real.pi) / (2 * Real.pi)⌋ : ℤ) : ℝ)

/-- **the machine's observation**: the rim sensor's azimuth error (the sun ahead of the dish,
wrapped) and elevation error (the dish above the sun), the swing, the wire taut and holding,
the oil's BULK temperature (scaled), the two smooth gates - and, since the loop became a loop,
the three the pump needs: the FILM MARGIN (how far the wall the oil touches is from the fluid's
375 °C limit, scaled by 300 K), the flow it is running, and the damage it has already done.
A policy cannot learn to modulate a pump it cannot see the consequences of. -/
noncomputable def obsOf (az t elSun azSun taut holds Toil tDead margin flow deg : ℝ) : Fin 11 → ℝ :=
  ![wrapRad (azSun - az), (Real.pi / 2 - t) - elSun, t, taut, holds, (Toil - 300) / 300,
    sunReachableS tDead elSun, lostSunS tDead az t elSun azSun 0.03,
    margin, flow, deg]

def obsNames : Array String := #["e_az", "e_el", "swing", "taut", "holds", "oil", "reach_s", "lost_s",
  "margin", "flow", "deg"]

/-- the observation's bounds: the wrapped azimuth error in `[-π, π)`, the elevation error within a
right angle, the swing from the zenith to the vertical, the wire's flags, the oil from ambient to
its limit (`(593 - 300) / 300`), the gates in `[0, 1]` -/
noncomputable def obsLo : Fin 11 → ℝ := ![-Real.pi, -Real.pi / 2, 0, 0, 0, 0, 0, 0, -2, 0, 0]
noncomputable def obsHi : Fin 11 → ℝ := ![Real.pi, Real.pi / 2, Real.pi / 2, 1, 1, 318.15 / 300, 1, 1, 1.2, 1, 1]

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

def actionNames : Array String := #["u_az", "u_el", "u_pump"]

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

/-- one hidden layer of 16 tanh units over the eleven observations, three tanh outputs (two motors and the pump): the
weights are inputs, shared by every agent -/
noncomputable def mlpPolicy (W1 : Fin 16 → Fin 11 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 3 → Fin 16 → ℝ)
    (b2 : Fin 3 → ℝ) (o : Fin 11 → ℝ) : Fin 3 → ℝ :=
  let h : Fin 16 → ℝ := fun i => Real.tanh ((∑ j : Fin 11, W1 i j * o j) + b1 i)
  fun k => Real.tanh ((∑ i : Fin 16, W2 k i * h i) + b2 k)

/-- the policy's outputs are commands: within `[-1, 1]` (strictly inside by `tanh_abs_lt_one`;
the closed bound is what a float witnesses, a saturated unit giving 1.0 exactly) -/
theorem mlpPolicy_bounded (W1 : Fin 16 → Fin 11 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 3 → Fin 16 → ℝ)
    (b2 : Fin 3 → ℝ) (o : Fin 11 → ℝ) (k : Fin 3) : |mlpPolicy W1 b1 W2 b2 o k| ≤ 1 :=
  (tanh_abs_lt_one _).le

/-! ## The closed loop as one morphism -/

/-- **the closed loop**: the observation of the state (now eleven: the pointing, the wire, the
oil's bulk, the gates, and the loop's film margin, flow and damage), the policy, the two drives
(the wire's lever arm at the current swing) AND THE PUMP, the env's step. Outputs the env's 96
columns, the eleven observations the policy acted on and its three commands. -/
noncomputable def hashemiLoop (az t slack dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta
    Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa
    tautPrev holdsPrev tDead marginPrev flowPrev : ℝ)
    (W1 : Fin 16 → Fin 11 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 3 → Fin 16 → ℝ) (b2 : Fin 3 → ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) : Fin 110 → ℝ :=
  let o := obsOf az t elSun azSun tautPrev holdsPrev (hist 0) tDead marginPrev flowPrev degPrev
  let u := mlpPolicy W1 b1 W2 b2 o
  let arm := leverAt ymHashemi hpHashemi dishHalf zeHashemi t
  let ωm := driveAz (u 0) hashemi.rDrive (rollerRadius hashemi)
  let ωd := driveEl (u 1) arm rDrum
  let uPump := pumpCmd (u 2)
  let s := hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta
    uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9, s 10, s 11, s 12, s 13, s 14, s 15,
    s 16, s 17, s 18, s 19, s 20, s 21, s 22, s 23, s 24, s 25, s 26, s 27, s 28, s 29, s 30, s 31,
    s 32, s 33, s 34, s 35, s 36, s 37, s 38, s 39, s 40, s 41, s 42, s 43, s 44, s 45, s 46, s 47,
    s 48, s 49, s 50, s 51, s 52, s 53, s 54, s 55, s 56, s 57, s 58, s 59, s 60, s 61, s 62, s 63,
    s 64, s 65, s 66, s 67, s 68, s 69, s 70, s 71, s 72, s 73, s 74, s 75, s 76, s 77, s 78, s 79,
    s 80, s 81, s 82, s 83, s 84, s 85, s 86, s 87, s 88, s 89, s 90, s 91, s 92, s 93, s 94, s 95,
    o 0, o 1, o 2, o 3, o 4, o 5, o 6, o 7, o 8, o 9, o 10, u 0, u 1, u 2]

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
  "T_film", "film_margin", "flow", "deg", "p_pump", "mcp", "UA_x", "delay", "fault", "expansion",
  "obs_margin", "obs_flow", "obs_deg",
  "e_az", "e_el", "swing", "taut_obs", "holds_obs", "oil", "reach_s", "lost_s",
  "margin", "flow_obs", "deg_obs", "u_az", "u_el", "u_pump"]

theorem loopNames_size : loopNames.size = 110 := by rfl

end TandoorHashemi

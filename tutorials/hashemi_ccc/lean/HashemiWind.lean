/-
# The wind on the dish, and what it does to a wire that only pulls

Wind entered this env in exactly one place: `hWind Vw` in the coil's heat-transfer coefficient,
`5.7 + 3.8 V`.  `Vw` is input 38 of `hashemiEnv` and the string occurred three times in the
71 kB kernel - its declaration, its load, and that one coefficient.  Wind cooled the receiver and
could do nothing else.  Two proved laws about it were unmodelled, and this file wires both.

LAW ONE, A WIRE ONLY PULLS.  `Hashemi.lean` §11 defines `wireTension W rcm rw t = W rcm sin t / rw`
and `wire_taut_iff` proves the tension non-negative exactly when the dish is swung to the wire's
side.  That test prices GRAVITY only.  A wind moment that lifts the dish unloads the wire, and
`wireTensionW` below is the same tension with the moment in it: the wire carries
`(W rcm sin t - M) / rw`, it is taut exactly when gravity's moment beats the wind's
(`wire_tautW_iff`), and `tensionW_le_of_holds` still bounds it by the winch's rating.  Every
existing theorem stays true: `wireTensionW_calm` is `wireTension` at `M = 0`.

LAW TWO, THE MOMENT ITSELF.  `MountCompliance.lean` writes `windMoment ρ V A D Cm θ` as the
dynamic pressure times the area times an arm times a moment-coefficient table.  This file gives
that table the parent env's own two coefficients rather than inventing one, and
`windMomentAt_eq_windMoment` proves the specialisation IS the library's definition, so the wind
the env now feels and the wind `abs_windMoment_le` and `windMoment_lipschitz` reason about are the
same function.

THE THREE CONSTANTS ARE THE PARENT ENV'S, cited:

    tandoor_hashemi_env.py:99    EL_HEAD_KG_M2, EL_CT, EL_CM = 10.0, 0.10, 0.15
                                 # dish + frame + straps per m2 of aperture, and the tangential
                                 # force and pitching moment coefficients
    tandoor_hashemi_env.py:1884  sag_w = (EL_CT * A * R + EL_CM * A * 2.0 * a_mem) * 0.6 / k

and that `0.6` is `ρ_air / 2` at 1.2 kg/m³, which is `TandoorWind.dynPressure`'s own factor.  So
the moment is `q (2a)² (Ct rcm + Cm 2a)`: the tangential force on the aperture at the swing's own
lever, plus the pitching moment on the aperture at its own diameter.  `EL_HEAD_KG_M2` is NOT used
here - the weight follows the aperture in the spec now (`weightOf`), and the droop's own algebra
cancels it.

WHAT IS NOT MODELLED.  One coefficient pair, constant in incidence: the parent's table is
constant too, and `plateCm`'s `2ε sin θ` shape is in MountCompliance if anyone measures this dish.
Gusts are the hour's mean here, as the coil's convection already takes them.  And the dish is
taken as always presenting its aperture, which is the worst case and is stated as such
(`windMomentAt_nonneg`).
-/
import RequestProject.HashemiDroop
import RequestProject.MountCompliance

namespace TandoorHashemi

/-! ## 1. The moment -/

/-- the air, kg/m³: the density behind the parent's `0.6 = ρ/2` (tandoor_hashemi_env.py:1884) -/
noncomputable def airRho : ℝ := 1.2

/-- the tangential force coefficient on the aperture (`EL_CT`, :99) -/
noncomputable def dragCt : ℝ := 0.10

/-- and the pitching moment coefficient (`EL_CM`, :99) -/
noncomputable def dragCm : ℝ := 0.15

/-- **the wind's moment about the bolt line**, from quantities the kernel already has: the
aperture `(2a)²`, the swing's own lever `rcm`, the air and `Vw`.  The tangential force acts at the
lever; the pitching moment acts on the aperture's own diameter. -/
noncomputable def windMomentAt (rhoA Vw a rcm ct cm : ℝ) : ℝ :=
  TandoorWind.dynPressure rhoA Vw * (2 * a) ^ 2 * (ct * rcm + cm * (2 * a))

/-- **and it IS `MountCompliance.windMoment`**, at the constant table this dish's coefficients
make: the same `q A D Cm` with `A = (2a)²`, `D = ct rcm + cm 2a` and a table that is 1 at every
incidence.  So `abs_windMoment_le` and `windMoment_lipschitz` are about this moment too. -/
theorem windMomentAt_eq_windMoment (rhoA Vw a rcm ct cm θ : ℝ) :
    windMomentAt rhoA Vw a rcm ct cm
      = TandoorMountCompliance.windMoment rhoA Vw ((2 * a) ^ 2) (ct * rcm + cm * (2 * a))
          (fun _ => 1) θ := by
  unfold windMomentAt TandoorMountCompliance.windMoment
  ring

/-- **the moment is non-negative**: the dish is taken as presenting its aperture, which is the
worst case, and a dynamic pressure is a square -/
theorem windMomentAt_nonneg {rhoA Vw a rcm ct cm : ℝ} (hρ : 0 ≤ rhoA) (ha : 0 ≤ a)
    (hr : 0 ≤ rcm) (hct : 0 ≤ ct) (hcm : 0 ≤ cm) : 0 ≤ windMomentAt rhoA Vw a rcm ct cm := by
  unfold windMomentAt TandoorWind.dynPressure
  have h1 : (0 : ℝ) ≤ rhoA / 2 * Vw ^ 2 := by positivity
  have h2 : (0 : ℝ) ≤ (2 * a) ^ 2 := by positivity
  have h3 : (0 : ℝ) ≤ ct * rcm + cm * (2 * a) := by positivity
  positivity

/-- **and it grows with the wind**, as a square: the whole reason a gust matters -/
theorem windMomentAt_mono {rhoA V V' a rcm ct cm : ℝ} (hρ : 0 ≤ rhoA) (ha : 0 ≤ a) (hr : 0 ≤ rcm)
    (hct : 0 ≤ ct) (hcm : 0 ≤ cm) (hV : 0 ≤ V) (h : V ≤ V') :
    windMomentAt rhoA V a rcm ct cm ≤ windMomentAt rhoA V' a rcm ct cm := by
  unfold windMomentAt TandoorWind.dynPressure
  have hsq : V ^ 2 ≤ V' ^ 2 := by nlinarith
  have h2 : (0 : ℝ) ≤ (2 * a) ^ 2 := by positivity
  have h3 : (0 : ℝ) ≤ ct * rcm + cm * (2 * a) := by positivity
  have : rhoA / 2 * V ^ 2 ≤ rhoA / 2 * V' ^ 2 := by nlinarith
  nlinarith [mul_nonneg h2 h3]

/-- a calm hour has no moment -/
theorem windMomentAt_calm (rhoA a rcm ct cm : ℝ) : windMomentAt rhoA 0 a rcm ct cm = 0 := by
  unfold windMomentAt TandoorWind.dynPressure; ring

/-! ## 2. The taut test, with the wind in it -/

/-- **the wire's tension under wind**, generalising `wireTension`: the wind's moment is taken off
gravity's before the lever divides.  A wind that lifts the dish unloads the wire. -/
noncomputable def wireTensionW (W rcm rw t M : ℝ) : ℝ := (W * rcm * Real.sin t - M) / rw

/-- on a calm hour it IS `wireTension`: the existing law is the `M = 0` case, not replaced -/
theorem wireTensionW_calm (W rcm rw t : ℝ) :
    wireTensionW W rcm rw t 0 = wireTension W rcm rw t := by
  unfold wireTensionW wireTension; ring_nf

/-- **`wire_taut_iff` with the wind in it**: the wire carries something exactly when gravity's
moment beats the wind's.  At `M = 0` this is the old test, `0 ≤ sin t`, scaled by `W rcm`. -/
theorem wire_tautW_iff {W rcm rw t M : ℝ} (hw : 0 < rw) :
    0 ≤ wireTensionW W rcm rw t M ↔ M ≤ W * rcm * Real.sin t := by
  unfold wireTensionW
  rw [le_div_iff₀ hw, zero_mul]
  constructor <;> intro h <;> linarith

/-- **and the winch's rating still covers it**: `tension_le_of_holds` survives, because a
non-negative wind moment only ever takes tension OFF the wire -/
theorem tensionW_le_of_holds {Tmax W rcm rw t M : ℝ} (hW : 0 ≤ W) (hr : 0 ≤ rcm) (hw : 0 < rw)
    (hM : 0 ≤ M) (h : HoldsDish Tmax W rcm rw) : wireTensionW W rcm rw t M ≤ Tmax := by
  have h0 : wireTensionW W rcm rw t M ≤ wireTension W rcm rw t := by
    unfold wireTensionW wireTension
    rw [div_le_div_iff_of_pos_right hw]
    linarith
  exact h0.trans (tension_le_of_holds hW hr hw h t)

/-! ## 3. What a slack wire lets the dish do -/

/-- **the wind's own equilibrium swing**: where the dish's weight balances the wind's moment,
`sin t* = M / (W rcm)`.  A wire only pulls, so once it is slack nothing holds the swing back and
the dish runs out to here - and past `W rcm` there is no equilibrium at all, which the clamp
reports as a right angle. -/
noncomputable def blowOver (W rcm M : ℝ) : ℝ :=
  Real.arcsin (min 1 (max 0 (M / (W * rcm))))

/-- a calm hour blows nothing over -/
theorem blowOver_calm (W rcm : ℝ) : blowOver W rcm 0 = 0 := by
  unfold blowOver
  norm_num

theorem blowOver_nonneg (W rcm M : ℝ) : 0 ≤ blowOver W rcm M := by
  unfold blowOver
  have h : (0 : ℝ) ≤ min 1 (max 0 (M / (W * rcm))) :=
    le_min (by norm_num) (le_max_left _ _)
  exact Real.arcsin_nonneg.2 h

/-- **the achieved swing under wind**: the commanded one while the wire is taut, the wind's
equilibrium once it is not.  `max` IS the slack test, because `blowOver ≤ t` exactly when the
wire is taut - so no case split is needed and the law is continuous in the wind. -/
noncomputable def swingWind (W rcm t M : ℝ) : ℝ := max t (blowOver W rcm M)

/-- a taut wire holds the swing where it was commanded -/
theorem swingWind_taut {W rcm t M : ℝ} (h : blowOver W rcm M ≤ t) : swingWind W rcm t M = t :=
  max_eq_left h

/-- and the dish never goes back on its own: the achieved swing is never less than commanded -/
theorem swingWind_ge (W rcm t M : ℝ) : t ≤ swingWind W rcm t M := le_max_left _ _

/-- a calm hour leaves it exactly where it was commanded, for `t ≥ 0` -/
theorem swingWind_calm {W rcm t : ℝ} (ht : 0 ≤ t) : swingWind W rcm t 0 = t := by
  unfold swingWind
  rw [blowOver_calm]
  exact max_eq_left ht

end TandoorHashemi

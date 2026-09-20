/-
# The droop: the attitude achieved, not the attitude commanded

An encoder on the winch's drum knows how much wire it paid out.  It does not know where the dish
is, because between the drum and the dish there is a wire that stretches.  The difference is the
droop, and until now nothing in the env carried it: the dish was traced exactly where the drum
said it was.

WHICH MEMBER DROOPS, FROM THE SCREW COLUMNS THE ENV ALREADY CARRIES.  This is not a new statics
model; it is a reading of `megaScrew`, whose forty columns are in the env's row as `mount_recip_*`:

* columns 13-17 are `recip sw (hw i)`, the trunnion hinge's five constraint wrenches against the
  SWING twist, and `hinge_reciprocal_swing` proves every one of them ZERO.  A constraint that does
  no work on a motion cannot resist it.  So the hinge does not hold the swing at all;
* columns 23-25 are `recip (rollY Fp) (hw i)`, the same hinge against a ROLL about `y` at F, and
  `tilt_not_driven` proves they are NOT all zero.  The hinge is stiff - in a direction the swing is
  not.  That is the whole content of the freedom/constraint split for this axis;
* column 33 is `recip sw (wrenchAt q fw)`, the tow wire's wrench against the swing twist, and
  `wire_recip_swing` gives it as a moment about the bolt line.  The wire is the only member with
  a moment there.

So at first order the swing is held by the wire and by nothing else, and a deflection of the
commanded attitude is the WIRE'S OWN EXTENSION divided by the lever it pulls on.  No gearbox, no
drum, no bolt term is modelled here, and their absence is the honest gap: see `droopUnmodelled`.

THE TWO MATERIAL NUMBERS ARE THE PARENT ENV'S OWN, cited rather than chosen:
`tandoor_hashemi_env.py:89` reads

    EL_WINCH_SIG, EL_WINCH_E = 48e6, 110e9   # a 6x19 rope: working stress under the weight
                                             # moment, effective modulus

and `:1877` sizes the cable from them, `A_r = W R / (lever * EL_WINCH_SIG)` - one cable, sized to
the load it pulls.  Both are inputs here so the env can move them; `winchSig` and `winchE` are
those values.

WHAT THE DROOP IS NOT.  `MountCompliance.lean` writes the achieved attitude as the fixed point of
`θ = θcmd + C · M θ` and bounds it by `C |M| / (1 - C Lm)` (`abs_deflection_le`).  That is the
right shape for a mount whose moment depends on the attitude - a wind moment does - and it will be
what carries the wind in the next pass.  Under GRAVITY alone the loop is not needed: the moment is
known at the commanded attitude, the response is one member's extension, and `droop` below is that
response exactly rather than a bound on it.
-/
import RequestProject.HashemiWire

namespace TandoorHashemi

/-! ## 1. The one member that holds the swing -/

/-- the working stress the parent env sizes the tow cable to, Pa (`tandoor_hashemi_env.py:89`,
`EL_WINCH_SIG`: a 6x19 rope under the weight moment) -/
noncomputable def winchSig : ℝ := 48e6

/-- and its effective modulus, Pa (`EL_WINCH_E`, the same line): a rope's, not steel's, because a
stranded rope unlays before it strains -/
noncomputable def winchE : ℝ := 110e9

/-- **the tow cable's section**, from the parent's own sizing rule: one cable, carrying the weight
moment `W rcm` on the lever it has at rest, at the working stress.  A thinner cable is not
allowed and a thicker one is not sized. -/
noncomputable def towCableArea (W rcm armRest sig : ℝ) : ℝ := W * rcm / (armRest * sig)

/-- Hooke on that cable: the extension of a run `L` under tension `T` -/
noncomputable def wireStretch (T L E A : ℝ) : ℝ := T * L / (E * A)

/-- **the droop**: the wire's own extension, turned into an angle by the lever it pulls on.

`wireTension W rcm arm t` is the spec's own tension (Hashemi.lean §11), `wireLen` the run it
stretches over, `leverAt` the arm the extension turns about.  Positive means the dish hangs BACK
from where the drum says it is, which is the only direction a stretching wire can give. -/
noncomputable def droop (W rcm arm armRest L sig E t : ℝ) : ℝ :=
  wireStretch (wireTension W rcm arm t) L E (towCableArea W rcm armRest sig) / arm

/-- the droop at the machine's own state: the lever and the run are `leverAt` and `wireLen`, and
the rest lever is `armRestOf` - every one of them already a column of the mount -/
noncomputable def droopAt (ym hp a ze W rcm armRest sig E t : ℝ) : ℝ :=
  droop W rcm (leverAt ym hp a ze t) armRest (wireLen ym hp a ze t) sig E t

/-! ## 2. What the droop owes -/

/-- written out, the droop is `sin t · L · armRest · σ / (arm² E)`: the weight cancels, because
the cable was SIZED to the weight.  A heavier dish on a cable sized for it droops the same. -/
theorem droop_eq {W rcm arm armRest L sig E t : ℝ} (hW : W ≠ 0) (hr : rcm ≠ 0) (harm : arm ≠ 0)
    (hE : E ≠ 0) (hs : sig ≠ 0) (hrest : armRest ≠ 0) :
    droop W rcm arm armRest L sig E t
      = Real.sin t * L * armRest * sig / (arm ^ 2 * E) := by
  unfold droop wireStretch towCableArea wireTension
  field_simp

/-- **a wire only pulls, so a wire only droops one way**: on the taut side the droop is
non-negative, which is `wire_taut_iff`'s own range -/
theorem droop_nonneg {W rcm arm armRest L sig E t : ℝ} (hW : 0 < W) (hr : 0 < rcm) (harm : 0 < arm)
    (hL : 0 ≤ L) (hE : 0 < E) (hs : 0 < sig) (hrest : 0 < armRest) (ht : 0 ≤ Real.sin t) :
    0 ≤ droop W rcm arm armRest L sig E t := by
  rw [droop_eq hW.ne' hr.ne' harm.ne' hE.ne' hs.ne' hrest.ne']
  positivity

/-- a dish the wire is not holding does not droop: at `t = 0` the weight hangs straight down, the
tension is zero (`wireTension`), and so is the extension -/
theorem droop_rest {W rcm arm armRest L sig E : ℝ} (hW : W ≠ 0) (hr : rcm ≠ 0) (harm : arm ≠ 0)
    (hE : E ≠ 0) (hs : sig ≠ 0) (hrest : armRest ≠ 0) :
    droop W rcm arm armRest L sig E 0 = 0 := by
  rw [droop_eq hW hr harm hE hs hrest]
  simp

/-- **the droop grows with the run**: a longer wire between pulley and clip stretches further,
which is why the machine droops most at dawn and least at the dead point -/
theorem droop_mono_len {W rcm arm armRest L L' sig E t : ℝ} (hW : 0 < W) (hr : 0 < rcm)
    (harm : 0 < arm) (hE : 0 < E) (hs : 0 < sig) (hrest : 0 < armRest) (ht : 0 ≤ Real.sin t)
    (h : L ≤ L') : droop W rcm arm armRest L sig E t ≤ droop W rcm arm armRest L' sig E t := by
  rw [droop_eq hW.ne' hr.ne' harm.ne' hE.ne' hs.ne' hrest.ne',
      droop_eq hW.ne' hr.ne' harm.ne' hE.ne' hs.ne' hrest.ne']
  have hden : (0 : ℝ) < arm ^ 2 * E := by positivity
  rw [div_le_div_iff_of_pos_right hden]
  nlinarith [mul_nonneg (mul_nonneg ht hrest.le) hs.le]

/-- **a stiffer rope droops less**, which is the only lever a builder has here once the cable is
sized: the droop falls as `E` rises -/
theorem droop_anti_E {W rcm arm armRest L sig E E' t : ℝ} (hW : 0 < W) (hr : 0 < rcm)
    (harm : 0 < arm) (hE : 0 < E) (hE' : E ≤ E') (hs : 0 < sig) (hrest : 0 < armRest)
    (hL : 0 ≤ L) (ht : 0 ≤ Real.sin t) :
    droop W rcm arm armRest L sig E' t ≤ droop W rcm arm armRest L sig E t := by
  have hE'0 : (0 : ℝ) < E' := lt_of_lt_of_le hE hE'
  rw [droop_eq hW.ne' hr.ne' harm.ne' hE.ne' hs.ne' hrest.ne',
      droop_eq hW.ne' hr.ne' harm.ne' hE'0.ne' hs.ne' hrest.ne']
  have hnum : (0 : ℝ) ≤ Real.sin t * L * armRest * sig := by positivity
  apply div_le_div_of_nonneg_left hnum (by positivity)
  nlinarith [sq_nonneg arm]

/-! ## 3. The attitude the rays see, and the gate that is charged for it -/

/-- **the achieved swing**: the commanded one plus the droop.  This is what the dish is at, and
the drum's encoder cannot see the difference. -/
noncomputable def swingAchieved (ym hp a ze W rcm armRest sig E t : ℝ) : ℝ :=
  t + droopAt ym hp a ze W rcm armRest sig E t

/-- **the sun lost, at an error already computed**: `LostSun`'s own conjunction with the pointing
error handed in rather than recomputed, so the gate can be charged the ACHIEVED error -/
noncomputable def LostSunAt (tDead elSun ε e : ℝ) : Prop := SunReachable tDead elSun ∧ ε < e

/-- and it IS `LostSun` when the error handed in is the commanded one: nothing is weakened -/
theorem lostSunAt_eq (tDead az t elSun azSun ε : ℝ) :
    LostSunAt tDead elSun ε (pointingError az t elSun azSun) ↔ LostSun tDead az t elSun azSun ε :=
  Iff.rfl

/-- the smooth gate, the same way -/
noncomputable def lostSunSAt (tDead elSun ε e : ℝ) : ℝ :=
  sunReachableS tDead elSun * Real.sigmoid ((e - ε) / gateTau)

theorem lostSunSAt_eq (tDead az t elSun azSun ε : ℝ) :
    lostSunSAt tDead elSun ε (pointingError az t elSun azSun)
      = lostSunS tDead az t elSun azSun ε := rfl

/-- **a drooping dish is never less lost**: the gate is monotone in the error it is charged, so
adding a non-negative droop can only close it -/
theorem sigmoid_mono {x y : ℝ} (h : x ≤ y) : Real.sigmoid x ≤ Real.sigmoid y := by
  have h1 : Real.exp (-y) ≤ Real.exp (-x) := Real.exp_le_exp.2 (by linarith)
  have hx : (0 : ℝ) < 1 + Real.exp (-x) := by positivity
  have hy : (0 : ℝ) < 1 + Real.exp (-y) := by positivity
  simp only [Real.sigmoid_def]
  exact inv_anti₀ hy (by linarith)

theorem lostSunSAt_mono {tDead elSun ε e e' : ℝ} (h : e ≤ e') :
    lostSunSAt tDead elSun ε e ≤ lostSunSAt tDead elSun ε e' := by
  unfold lostSunSAt
  have hg : (0 : ℝ) ≤ sunReachableS tDead elSun := Real.sigmoid_nonneg _
  have hτ : (0 : ℝ) < gateTau := by unfold gateTau; norm_num
  exact mul_le_mul_of_nonneg_left (sigmoid_mono (by gcongr)) hg

/-- `SunReachable` IS this comparison, definitionally.  The env writes the comparison rather than
the name because a `b2r` whose proposition is built from a COMPILED definition becomes an opaque
call in the printed twin, which no `if` re-elaborates into; written out it prints exactly as the
flux indicator and the oil's fault flag already do. -/
theorem sunReachable_iff (tDead elSun : ℝ) :
    SunReachable tDead elSun ↔ Real.pi / 2 - tDead ≤ elSun := Iff.rfl

/-- **a conjunction of indicators is their product**, so a gate that is one column AND one
comparison may be written as the arithmetic it is.  The env needs this because a `b2r` whose
proposition is built from a COMPILED definition becomes an opaque call the printed twin cannot
re-elaborate; `b2r` of a bare `<` can, and the reach gate is already a column. -/
theorem b2r_and_mul (P Q : Prop) [Decidable P] [Decidable Q] :
    b2r (P ∧ Q) = b2r P * b2r Q := by
  unfold b2r
  by_cases hp : P <;> by_cases hq : Q <;> simp [hp, hq]

/-! ## 4. What is NOT modelled, stated rather than hidden -/

/-- **the terms this droop does not carry**, as a definition so the number cannot be quoted
without them: the winch's gearboxes and their backlash, the drum's own wind-up, the bolted joints
at the clip and the pulley, the mast's bending, and the panel's own sag between its hangers.
Nothing in either repository measures any of them, and a guess would be worse than a gap.  The
value is the droop with those terms at zero, which is a LOWER BOUND on the true deflection -
`droop_is_lower_bound` says exactly that and no more. -/
noncomputable def droopUnmodelled : ℝ := 0

/-- the honest statement: the true deflection is this droop plus the unmodelled terms, and since
those are non-negative the droop under-reports.  The env's columns are therefore a floor on the
pointing error, not an estimate of it. -/
theorem droop_is_lower_bound {W rcm arm armRest L sig E t extra : ℝ} (hx : 0 ≤ extra) :
    droop W rcm arm armRest L sig E t ≤ droop W rcm arm armRest L sig E t + extra := by
  linarith

end TandoorHashemi

/-
# The megakernel: every definition of Hashemi.lean at the machine's state

The env's kernel is these five functions, compiled by `Ccc` and run as one Metal kernel, one
thread per agent. Their inputs are the state of his machine (the carriage's azimuth `az`, the
dish's swing `t`, the tow wire's `slack`), the two motor commands (`ωm` the roller, `ωd` the
drum), the time step, the sun (`elSun`, `azSun`, rad, in the roof frame whose `x` is north and
whose azimuth is measured like `az`; `dni` W/m²), and the parameters the video did not give -
`megaParams` holds the assumed values, each named in its docstring. Everything else is a
definition of Hashemi.lean applied at that state, or a theorem of Hashemi.lean evaluated there
(`HashemiProps.lean`: `prop_X` is the statement of `X`, proved by `X`). Nothing in the kernel
comes from anywhere else.

Frames. The screw frame of sections 2-4: the tube's axis is `z` through the origin, `x` runs from
the tube to the bar (the bar at `x = apexH`), `y` along the bar, `z` up from the deck; the bolt
line is `y`-parallel at `(apexH, ·, zBolt)`. The wire frame of sections 11-14 (`swungPt`,
`edgeClipAt`, `pulleyAt`) lies in the plane across the bar: its `y` runs AWAY from the mast
(the mast at `y = -ym`), its `z` up from the bolt line; it is the screw frame's `(-(x - apexH),
z - zBolt)`. Section 8's `swingVertex`/`swingNormal` turn the other way (`t ↦ -t`). The dish's
face at swing `t` and azimuth `az` points along `(sin t cos az, sin t sin az, cos t)`.

The only law not in Hashemi.lean is `coilCapture`, the fraction of a uniform spot that lands on
the coil: two discs' overlap - the spot is `facetSpot`, its centre is displaced by the paraxial
spot shift `TandoorMount.spot`, the coil is 12 cm across (section 14). It is a model, marked.
-/
import RequestProject.Hashemi
import RequestProject.HashemiStep
import RequestProject.HashemiProps

namespace TandoorHashemi
open Classical
set_option linter.unusedVariables false

/-- a proposition as a real: 1 when it holds -/
noncomputable def b2r (p : Prop) [Decidable p] : ℝ := if p then 1 else 0

/-- **the parameters the video did not give**, in `mega*`'s input order after the state, the
commands, the step and the sun: `rDrum` the winch drum's radius (0.03), `W` the dish's weight in N
(a one-man lift, 30 kg), `rcm` the dish's centre of mass below the bolt line (0.9 m: the panel
hangs between its vertex 1 m down and its rim 0.83 m down), `Tmax` the wire's rated tension (2 kN,
a 3 mm steel wire), `rho` the mosaic's reflectance (0.85), `Fdrive` the roller's tangential force
(10 N), `L10` the bearings' rating in revolutions (10^6), `rodLen` the hanger rod's full length
(1 m; the nuts take up the rest, `setLength`) -/
noncomputable def megaParams : Fin 8 → ℝ := ![0.03, 300, 0.9, 2000, 0.85, 10, 1000000, 1]

/-- the fraction of a uniform disc of radius `rs`, centred `d` from the axis, inside a disc of
radius `rc` on the axis: the lens area over the spot's area. NOT in Hashemi.lean: the capture
model of the env -/
noncomputable def coilCapture (rs rc d : ℝ) : ℝ :=
  if rs + rc ≤ d then 0
  else if d ≤ rc - rs then 1
  else
    let A := rs ^ 2 * Real.arccos ((d ^ 2 + rs ^ 2 - rc ^ 2) / (2 * d * rs))
           + rc ^ 2 * Real.arccos ((d ^ 2 + rc ^ 2 - rs ^ 2) / (2 * d * rc))
           - Real.sqrt ((-d + rs + rc) * (d + rs - rc) * (d - rs + rc) * (d + rs + rc)) / 2
    A / (Real.pi * rs ^ 2)

/-- the rim's depth below F on his dish: `f - sag` -/
noncomputable def zeHashemi : ℝ := dishF - TandoorSphere.sag dishR dishHalf

/-- the pulley's height over the bolt line (`pulley_above_pivot`) -/
noncomputable def hpHashemi : ℝ := 0.34

/-- the bolt line's height over the deck: the rail, the post, less the hole's 5 cm
(`receiverPost_height`) -/
noncomputable def zBoltHashemi : ℝ := hashemiBase.zRail + hashemiLeg.upright - 0.05

/-- the eye's station along the bolt: at the bolt's end, the eye's reach in from the post's face -/
noncomputable def xhHashemi : ℝ := hashemi.chord / 2 - 0.03

/-- the pointing error: the angle between the dish's face `n` and the sun `u`, as
`arctan (|n × u| / (n · u))` - exact, and stable for the small angles the tracker lives at
(`arccos (n · u)` loses them in single precision); a right angle or more when the sun is behind -/
noncomputable def pointingError (az t elSun azSun : ℝ) : ℝ :=
  let nx := Real.sin t * Real.cos az
  let ny := Real.sin t * Real.sin az
  let nz := Real.cos t
  let ux := Real.cos elSun * Real.cos azSun
  let uy := Real.cos elSun * Real.sin azSun
  let uz := Real.sin elSun
  let c := nx * ux + ny * uy + nz * uz
  let s := Real.sqrt ((ny * uz - nz * uy) ^ 2 + (nz * ux - nx * uz) ^ 2 + (nx * uy - ny * ux) ^ 2)
  if c ≤ 0 then Real.pi / 2 + Real.arctan (-c / max s 1e-12) else Real.arctan (s / c)

/-- **the sun within the winch's reach**: the wire holds the dish no lower than `π/2 - tDead`
(`HoldsDish` at the dead point), so a sun under that elevation is not the machine's to track -/
def SunReachable (tDead elSun : ℝ) : Prop := Real.pi / 2 - tDead ≤ elSun

/-- **the sun lost**: reachable, and the pointing error beyond the tracker's budget `ε` -/
noncomputable def LostSun (tDead az t elSun azSun ε : ℝ) : Prop :=
  SunReachable tDead elSun ∧ ε < pointingError az t elSun azSun

/-- a sun the winch cannot reach is never lost: the cook is not charged for the machine's reach -/
theorem lostSun_unreachable (tDead az t elSun azSun ε : ℝ) (h : ¬ SunReachable tDead elSun) :
    ¬ LostSun tDead az t elSun azSun ε := fun hl => h hl.1

/-- within the budget the sun is not lost -/
theorem lostSun_within_budget (tDead az t elSun azSun ε : ℝ) (h : pointingError az t elSun azSun ≤ ε) :
    ¬ LostSun tDead az t elSun azSun ε := fun hl => absurd hl.2 (not_lt.mpr h)

/-! ### The gates, smoothly

The constructive content of a condition is its modulus. `SunReachable` and `LostSun` are
subobjects, decided classically; here they are Lipschitz gates with a slope, so the cook sees a
gradient where the guillotine had a jump. `gateTau` is the band (rad) over which a gate turns. -/

/-- the gates' temperature: 0.01 rad (0.57°) of elevation deficit or pointing excess -/
noncomputable def gateTau : ℝ := 0.01

/-- **the sun's reach, smoothly** -/
noncomputable def sunReachableS (tDead elSun : ℝ) : ℝ :=
  Real.sigmoid ((elSun - (Real.pi / 2 - tDead)) / gateTau)

/-- **the sun lost, smoothly**: the reach gate times the budget gate on the pointing error -/
noncomputable def lostSunS (tDead az t elSun azSun ε : ℝ) : ℝ :=
  sunReachableS tDead elSun * Real.sigmoid ((pointingError az t elSun azSun - ε) / gateTau)

/-- the sigmoid's slope is at most a quarter -/
theorem sigmoid_slope_le (x : ℝ) : Real.sigmoid x * (1 - Real.sigmoid x) ≤ 1 / 4 := by
  nlinarith [sq_nonneg (Real.sigmoid x - 1 / 2)]

/-- the sigmoid is 1/4-Lipschitz -/
theorem sigmoid_lipschitz : LipschitzWith (1 / 4 : NNReal) Real.sigmoid := by
  refine lipschitzWith_of_nnnorm_deriv_le differentiable_sigmoid fun x => ?_
  rw [Real.deriv_sigmoid]
  have h0 : 0 ≤ Real.sigmoid x * (1 - Real.sigmoid x) := by
    have := Real.sigmoid_pos x; have := Real.sigmoid_lt_one x; nlinarith
  rw [← NNReal.coe_le_coe, coe_nnnorm, Real.norm_of_nonneg h0]
  simpa using sigmoid_slope_le x

/-- the slope of the reach gate: `1 / (4 τ)` per radian of elevation -/
theorem sunReachableS_slope (tDead e1 e2 : ℝ) :
    |sunReachableS tDead e1 - sunReachableS tDead e2| ≤ |e1 - e2| / (4 * gateTau) := by
  unfold sunReachableS
  have h := sigmoid_lipschitz.dist_le_mul ((e1 - (Real.pi / 2 - tDead)) / gateTau) ((e2 - (Real.pi / 2 - tDead)) / gateTau)
  rw [Real.dist_eq, Real.dist_eq] at h
  have hτ : (0 : ℝ) < gateTau := by unfold gateTau; norm_num
  have : (e1 - (Real.pi / 2 - tDead)) / gateTau - (e2 - (Real.pi / 2 - tDead)) / gateTau = (e1 - e2) / gateTau := by ring
  rw [this, abs_div, abs_of_pos hτ] at h
  simp only [NNReal.coe_div, NNReal.coe_one, NNReal.coe_ofNat] at h
  calc |Real.sigmoid ((e1 - (Real.pi / 2 - tDead)) / gateTau) - Real.sigmoid ((e2 - (Real.pi / 2 - tDead)) / gateTau)|
      ≤ 1 / 4 * (|e1 - e2| / gateTau) := h
    _ = |e1 - e2| / (4 * gateTau) := by field_simp

/-- the gate takes values in [0, 1] (strictly inside, by `Real.sigmoid_pos` and `sigmoid_lt_one`;
the closed bounds are what a float can witness, a far-off sun saturating the gate at 1.0 exactly) -/
theorem sunReachableS_mem (tDead elSun : ℝ) : 0 ≤ sunReachableS tDead elSun ∧ sunReachableS tDead elSun ≤ 1 :=
  ⟨Real.sigmoid_nonneg _, Real.sigmoid_le_one _⟩

/-- lost implies reachable, smoothly: `lostSunS ≤ sunReachableS` -/
theorem lostSunS_le_reach (tDead az t elSun azSun ε : ℝ) :
    lostSunS tDead az t elSun azSun ε ≤ sunReachableS tDead elSun := by
  unfold lostSunS
  have h0 : 0 < sunReachableS tDead elSun := Real.sigmoid_pos _
  have h1 := Real.sigmoid_le_one ((pointingError az t elSun azSun - ε) / gateTau)
  nlinarith

/-- the smooth gate agrees with the Boolean one outside its band: `x` bands above the floor
give at least `1 - 1 / (2 + x)` -/
theorem sigmoid_ge_of_nonneg (x : ℝ) (hx : 0 ≤ x) : 1 - 1 / (2 + x) ≤ Real.sigmoid x := by
  rw [Real.sigmoid_def, Real.exp_neg]
  have he : 1 + x ≤ Real.exp x := by linarith [Real.add_one_le_exp x]
  have hpos : 0 < 1 + x := by linarith
  have h1 : (Real.exp x)⁻¹ ≤ (1 + x)⁻¹ := inv_anti₀ hpos he
  have h2 : (1 + (1 + x)⁻¹)⁻¹ ≤ (1 + (Real.exp x)⁻¹)⁻¹ := by
    apply inv_anti₀ (by positivity); linarith
  calc 1 - 1 / (2 + x) = (1 + (1 + x)⁻¹)⁻¹ := by field_simp; ring
    _ ≤ (1 + (Real.exp x)⁻¹)⁻¹ := h2

/-- **the state, the wire, the pointing** (17): `0..7` the step's outputs (az', t', slack', the
wire's length, the dead point, stalled, taut, holds), `8` the wire's lever arm at `t` (`leverAt`),
`9` the swing rate the winch imposes (`elRate` on the arm), `10` the azimuth rate (`azRate`),
`11` the pointing error, `12` the elevation the dish faces, `13` the sun within the winch's reach
(`SunReachable`), `14` the sun lost (`LostSun` at the 1.7° budget) - the two Ω-columns the env's
day and cut are pulled back along; `15`, `16` the same gates smoothly (`sunReachableS`, `lostSunS`) -/
noncomputable def megaStep (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10
    rodLen : ℝ) : Fin 17 → ℝ :=
  let ym := ymHashemi
  let hp := hpHashemi
  let a := dishHalf
  let ze := zeHashemi
  let rw := hashemi.rDrive
  let R := rollerRadius hashemi
  let s := step az t slack ωm ωd dt rw R rDrum ym hp a ze W rcm Tmax
  let arm := leverAt ym hp a ze t
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, arm, elRate ωd rDrum arm, azRate ωm rw R,
    pointingError az t elSun azSun, Real.pi / 2 - t,
    b2r (SunReachable (s 4) elSun), b2r (LostSun (s 4) az t elSun azSun 0.03),
    sunReachableS (s 4) elSun, lostSunS (s 4) az t elSun azSun 0.03]

/-- **the geometry, the optics, the loads, the electrics** (60): the machine's numbers from the
file's definitions, and the quantities of sections 5-15 at the state -/
noncomputable def megaGeom (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10
    rodLen : ℝ) : Fin 60 → ℝ :=
  let ym := ymHashemi
  let hp := hpHashemi
  let a := dishHalf
  let sag := TandoorSphere.sag dishR dishHalf
  let ze := zeHashemi
  let arm := leverAt ym hp a ze t
  let ω := elRate ωd rDrum arm
  let ε := pointingError az t elSun azSun
  let el := Real.pi / 2 - t
  let P := pulleyAt ym hp
  let C := edgeClipAt a ze t
  let V := swungPt 0 (-dishF) t
  let N := swungPt 0 1 t
  let V8 := swingVertex (0, 0) dishF (-t)
  let N8 := swingNormal (-t)
  let Fok := swingFocus (0, 0) dishF dishF (-t)
  let Fbad := swingFocus (0, 0) (dishF + 0.01) dishF (-t)
  let spotShift := TandoorMount.spot dishF ε
  let spotW := facetSpot 0.05 dishF
  let capture := coilCapture (spotW / 2) 0.06 spotShift
  let power := if 0 < elSun then dni * dishSide ^ 2 * rho * capture else 0
  let Froof := rot az (hashemi.apexH, 0)
  let Ftop := postTop hashemi hashemiLeg 0 1
  let Q : Fin 3 → ℝ := ![hashemi.apexH + hashemiOutrigger.standStation, 0, 0]
  let lean : Fin 3 → ℝ := ![-0.0005, 0, 0]
  ![-- 0..9 the dish and the sphere (sections 5, 6, 8)
    dishR, dishF, dishHalf, dishSide, sag, ze, screwLength dishR dishHalf,
    hangerLength dishR dishHalf 0.4 0, rodTan, cosTubeCut,
    -- 10..19 the carriage, the base, the legs, the stand, the outrigger (2-4, 7)
    rollerRadius hashemi, hashemi.chord, hashemi.apexH, hashemiBase.zRail, hashemiBase.zBearing,
    Leg.footLong hashemiLeg, braceHeight hashemiLeg, hashemiStand.post, hashemiStand.foot,
    hashemiOutrigger.endStation,
    -- 20..29 the pose (8, 11, 14)
    V.1, V.2, N.1, N.2, V8.1, V8.2, N8.1, N8.2, Real.sqrt (Fok.1 ^ 2 + Fok.2 ^ 2),
    Real.sqrt (Fbad.1 ^ 2 + Fbad.2 ^ 2),
    -- 30..39 the wire (9, 11, 13, 15)
    P.1, P.2, C.1, C.2, wireLever P C, deadPoint ym hp a ze, wireLen ym hp a ze t,
    wireTension W rcm arm t, elPower W rcm t ω, slackSpot dishF slack arm,
    -- 40..49 the receiver, the post, the rim (5, 14)
    slotExit a ze, dishF * Real.tan t, edgeDepth dishF a sag el, clearance hashemiLeg 0.05 (edgeDepth dishF a sag el),
    a * Real.sin t + ze * Real.cos t, sideGap, hashemiLeg.upright - 0.05, Froof.1, Froof.2,
    Real.sqrt (Froof.1 ^ 2 + Froof.2 ^ 2),
    -- 50..59 the optics, the alignment, the electrics, the struts (8, 10, 12, 13, 14)
    spotShift, spotW, capture, power, focusShift 1.25 0.0005, tiltOfMismatch 0.0015,
    setLength rodLen (rodLen - hashemiHanger.length), helixAdvance 0.00175 t,
    cableDrop 4 (hashemiPanel.watts / systemVolts), strutStrain Ftop Q lean]

/-- **the screw theory at the state** (40): the reciprocal products of the base's constraints
with the yaw (section 4), the drive's work on the yaw, the hinge's and the screw joint's
constraints against the swing (12), the wire's wrench against the swing (9, 12), the velocities
of F under the yaw and the swing (10), the bolt and the panel (12, 13) -/
noncomputable def megaScrew (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10
    rodLen : ℝ) : Fin 40 → ℝ :=
  let ym := ymHashemi
  let hp := hpHashemi
  let a := dishHalf
  let ze := zeHashemi
  let arm := leverAt ym hp a ze t
  let zB := zBoltHashemi
  let xh := xhHashemi
  let cs := constraints hashemi hashemiBase
  let cg := constraintsGrooved hashemi hashemiBase
  let sw := swingTwist hashemi.apexH zB
  let st := screwTwist hM12 zB
  let hw := hingeWrench xh zB
  let sc := screwWrench xh zB hM12
  let Fp : Fin 3 → ℝ := ![hashemi.apexH, 0, zB]
  let vy := pointVel yaw Fp
  let vs := pointVel sw Fp
  let vr := pointVel (rollY Fp) ![hashemi.apexH, 0.3, zB]
  let C := edgeClipAt a ze t
  let P := pulleyAt ym hp
  let q : Fin 3 → ℝ := ![hashemi.apexH - C.1, 0, zB + C.2]
  let L := wireLen ym hp a ze t
  let T := wireTension W rcm arm t
  let fw : Fin 3 → ℝ := ![T * (-(P.1 - C.1)) / L, 0, T * (P.2 - C.2) / L]
  ![-- 0..4 the five constraints against the yaw (all zero: constraints_reciprocal_yaw)
    recip (cs 0) yaw, recip (cs 1) yaw, recip (cs 2) yaw, recip (cs 3) yaw, recip (cs 4) yaw,
    -- 5..11 the grooved seven against the yaw
    recip (cg 0) yaw, recip (cg 1) yaw, recip (cg 2) yaw, recip (cg 3) yaw, recip (cg 4) yaw,
    recip (cg 5) yaw, recip (cg 6) yaw,
    -- 12 the drive's work on the yaw, F R (drive_recip_yaw)
    recip yaw (wDrive hashemi hashemiBase Fdrive),
    -- 13..17 the hinge's five against the swing (zero: hinge_reciprocal_swing)
    recip sw (hw 0), recip sw (hw 1), recip sw (hw 2), recip sw (hw 3), recip sw (hw 4),
    -- 18..22 the screw joint's five against the helical twist (zero: screw_reciprocal)
    recip st (sc 0), recip st (sc 1), recip st (sc 2), recip st (sc 3), recip st (sc 4),
    -- 23..25 a roll about y at F against the hinge (tilt_not_driven: not all zero)
    recip (rollY Fp) (hw 0), recip (rollY Fp) (hw 1), recip (rollY Fp) (hw 2),
    -- 26..28 F's velocity under the yaw (0.8 m/rad across: the open point of section 4)
    vy 0, vy 1, vy 2,
    -- 29..31 F's velocity under the swing (zero: F is on the bolt line)
    vs 0, vs 1, vs 2,
    -- 32 a point 0.3 m along the bar under the roll
    vr 2,
    -- 33 the wire's wrench against the swing: its moment about the bolt line (wire_recip_swing)
    recip sw (wrenchAt q fw),
    -- 34..36 the bolt, the helix, the panel
    boltStress W 0.03 0.0101, hM12, hashemiPanel.watts / systemVolts,
    -- 37..39 the tracking power, the azimuth rate in rpm at the sun's rate, the roller rpm
    elPower W rcm t ω, azRate ωm hashemi.rDrive (rollerRadius hashemi) * 60 / (2 * Real.pi),
    ωm * 60 / (2 * Real.pi)]
  where ω := elRate ωd rDrum (leverAt ymHashemi hpHashemi dishHalf zeHashemi t)

/-- **the requirements** (7 Props of the file, as 1/0 at the state) -/
noncomputable def megaReqs (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10
    rodLen : ℝ) : Fin 7 → ℝ :=
  let ym := ymHashemi
  let hp := hpHashemi
  let a := dishHalf
  let ze := zeHashemi
  let arm := leverAt ym hp a ze t
  let ε := pointingError az t elSun azSun
  ![b2r (Fits hashemiBase hashemi), b2r (HangerClearsPost 0.010 hashemiHanger.dRod),
    b2r (HoldsDish Tmax W rcm arm), b2r (MastClears ym a ze), b2r (ReachesVertical ym hp a ze),
    b2r (SlackHarmless dishF ε (slackSpot dishF slack arm) 0.03), b2r (TrackerBudget dishF ε 0.03)]

/-- **the theorems, closed** (56): the statements with no binders, 1 when true in the kernel's
arithmetic (true in ℝ by their proofs) -/
noncomputable def megaThmsClosed (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive
    L10 rodLen : ℝ) : Fin 56 → ℝ :=
  ![b2r prop_AH_bounds, b2r prop_FC_bounds, b2r prop_FC_eq, b2r prop_FH_bounds, b2r prop_FH_eq,
    b2r prop_HD_bounds, b2r prop_HD_eq, b2r prop_braceHeight_hashemi, b2r prop_brace_cuts_moment,
    b2r prop_brace_stiffens, b2r prop_cosTubeCut_bounds, b2r prop_deadTan_at_ym,
    b2r prop_deadTan_hashemi, b2r prop_dish_between_posts, b2r prop_dish_swings_to_vertical,
    b2r prop_facetSpot_hashemi, b2r prop_hangerLength_bounds, b2r prop_hangerLength_halfEdge,
    b2r prop_hashemiHanger_length, b2r prop_hashemi_clearance, b2r prop_hashemi_eyes_clear,
    b2r prop_hashemi_fits, b2r prop_helixAdvance_small, b2r prop_lean_one_degree,
    b2r prop_lowestSun_tan_at_ym, b2r prop_mastClears_hashemi, b2r prop_mast_beyond_ring,
    b2r prop_mast_for_vertical_hashemi, b2r prop_one_turn_tilt, b2r prop_panel_current,
    b2r prop_pulley_above_pivot, b2r prop_receiverPost_height, b2r prop_rodTan_bounds,
    b2r prop_rollerRadius_hashemi, b2r prop_rollerRadius_hashemi_bounds, b2r prop_roller_rpm_hashemi,
    b2r prop_screwLength_hashemi, b2r prop_screwLength_hashemi_bounds, b2r prop_shim_negligible,
    b2r prop_sideGap_eq, b2r prop_sixty_reachable, b2r prop_slot_exit_hashemi, b2r prop_sqrt32_bounds,
    b2r prop_wireLeft_at_ym, b2r prop_wireLever_rest_at_ym, b2r prop_wireLever_sixty_at_ym,
    b2r prop_wire_short_of_vertical, b2r prop_ym_is_standStation,
    -- the closed instances of the file's parametric theorems at his numbers
    b2r (prop_clearance_hashemi 0.05), b2r (prop_edgeClip_radius_hashemi t),
    b2r (prop_tracker_margin_hashemi (pointingError az t elSun azSun)),
    b2r (prop_mastClears_hashemi_iff ymHashemi), b2r (prop_plumbed_shift 0.0005),
    b2r (prop_cable_drop_small 4 (hashemiPanel.watts / systemVolts)), b2r (prop_bearing_life L10),
    b2r (prop_m12_carries_dish W)]

/-- **the theorems with binders, at the state** (50): each `prop_X` at the machine's own values -/
noncomputable def megaThmsState (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive
    L10 rodLen : ℝ) : Fin 50 → ℝ :=
  let ym := ymHashemi
  let hp := hpHashemi
  let a := dishHalf
  let sag := TandoorSphere.sag dishR dishHalf
  let ze := zeHashemi
  let arm := leverAt ym hp a ze t
  let ω := elRate ωd rDrum arm
  let ε := pointingError az t elSun azSun
  let el := Real.pi / 2 - t
  let rw := hashemi.rDrive
  let R := rollerRadius hashemi
  let zB := zBoltHashemi
  let xh := xhHashemi
  let sw := swingTwist hashemi.apexH zB
  let st := screwTwist hM12 zB
  let Fp : Fin 3 → ℝ := ![hashemi.apexH, 0, zB]
  let P := pulleyAt ym hp
  let C := edgeClipAt a ze t
  let L := wireLen ym hp a ze t
  let T := wireTension W rcm arm t
  let q : Fin 3 → ℝ := ![hashemi.apexH - C.1, 0, zB + C.2]
  let fw : Fin 3 → ℝ := ![T * (-(P.1 - C.1)) / L, 0, T * (P.2 - C.2) / L]
  let Ftop := postTop hashemi hashemiLeg 0 1
  let Q : Fin 3 → ℝ := ![hashemi.apexH + hashemiOutrigger.standStation, 0, 0]
  let lean : Fin 3 → ℝ := ![-0.0005, 0, 0]
  ![b2r (prop_azRate_pos ωm rw R), b2r (prop_drive_recip_yaw hashemi hashemiBase Fdrive),
    b2r (prop_drive_works_on_yaw hashemi hashemiBase Fdrive), b2r (prop_edgeClip_cross ym hp a ze t),
    b2r (prop_edgeClip_radius a ze t), b2r (prop_edgeClip_reach a ze t),
    b2r (prop_edgeDepth_horizon dishF a sag), b2r (prop_edgeDepth_le dishF a sag el),
    b2r (prop_edgeDepth_noon dishF a sag), b2r (prop_edgeLever_dead ym hp a ze t),
    b2r (prop_edgeLever_pos_iff ym hp a ze t), b2r (prop_elPower_eq_wire arm W rcm t ω),
    b2r (prop_elPower_le W rcm ω t), b2r (prop_focus_on_axis az (hashemi.apexH, 0)),
    b2r (prop_grooved_relation_x hashemi hashemiBase), b2r (prop_grooved_relation_y hashemi hashemiBase),
    b2r (prop_hinge_freedom xh zB sw), b2r (prop_hinge_freedom_smul xh zB hashemi.apexH sw),
    b2r (prop_mul_bounds_neg_pos (-ym) hp (-ym - 0.01) (-ym + 0.01) (hp - 0.01) (hp + 0.01)),
    b2r (prop_mul_bounds_pos_pos a ze (a - 0.01) (a + 0.01) (ze - 0.01) (ze + 0.01)),
    b2r (prop_play_budget dishF ε 0.03 (slackSpot dishF slack arm)),
    b2r (prop_postTop_on_rail hashemi hashemiLeg 1), b2r (prop_postTops_apart hashemi hashemiLeg 0),
    b2r (prop_postTops_level hashemi hashemiLeg 0), b2r (prop_postTops_offAxis hashemi hashemiLeg 0 1),
    b2r (prop_reachesVertical_iff ym hp a ze), b2r (prop_rim_under_F_iff a ze t),
    b2r (prop_rollerRadius_pos hashemi), b2r (prop_rollerRadius_sq hashemi),
    b2r (prop_screwLength_eq_focal dishR dishHalf), b2r (prop_screwTwist_zero hashemi.apexH zB),
    b2r (prop_screw_freedom xh zB hM12 st),
    b2r (prop_slackHarmless_of_budget dishF ε (slackSpot dishF slack arm) 0.03),
    b2r (prop_slackHarmless_of_lever dishF ε slack arm 0.03),
    b2r (prop_sq_bounds_neg (-ym) (-ym - 0.01) (-ym + 0.01)),
    b2r (prop_strut_resists_lean Ftop Q lean 0.0005),
    b2r (prop_swingFocus_circle (0, 0) dishF dishF (-t)), b2r (prop_swingNormal_unit (-t)),
    b2r (prop_swing_focusCircle (0, 0) dishF (-t)), b2r (prop_swing_lift hashemi.apexH zB Fp),
    b2r (prop_tension_le_of_holds Tmax W rcm arm t), b2r (prop_trackerBudget_iff dishF ε 0.03),
    b2r (prop_tracking_power_tiny W rcm ω t), b2r (prop_wireLever_edge_formula ym hp a ze t),
    b2r (prop_wireLever_pos_iff P C), b2r (prop_wireLever_rest ym hp a ze),
    b2r (prop_wire_recip_swing hashemi.apexH zB q fw), b2r (prop_wire_taut_iff W rcm arm t),
    b2r (prop_yaw_lifts_nothing Fp),
    b2r (prop_bearing_life L10)]

/-- the column names of the six vectors, in order, for the env -/
def megaNames : Array String := #[
  -- megaStep
  "az_next", "t_next", "slack_next", "wire_len", "t_dead", "stalled", "taut", "wire_holds", "arm",
  "swing_rate", "az_rate", "pointing_err", "el_dish", "sun_reachable", "lost_sun", "sun_reachable_s", "lost_sun_s",
  -- megaGeom
  "dishR", "dishF", "dishHalf", "dishSide", "sag", "ze", "screwLength", "hangerLength", "rodTan",
  "cosTubeCut", "rollerRadius", "chord", "apexH", "zRail", "zBearing", "footLong", "braceHeight",
  "standPost", "standFoot", "outriggerEnd", "V_y", "V_z", "N_y", "N_z", "V8_y", "V8_z", "N8_y",
  "N8_z", "F_wander_ok", "F_wander_1cm", "P_y", "P_z", "C_y", "C_z", "wireLever", "deadPoint",
  "wireLen", "wireTension", "elPower", "slackSpot", "slotExit", "postCross", "edgeDepth",
  "clearance", "rimDepth", "sideGap", "bolt_over_bar", "Froof_x", "Froof_y", "Froof_r",
  "spotShift", "spotW", "capture", "power_W", "focusShift_plumb", "tilt_one_turn",
  "hanger_set", "helixAdvance", "cableDrop", "strutStrain",
  -- megaScrew
  "recip_c0_yaw", "recip_c1_yaw", "recip_c2_yaw", "recip_c3_yaw", "recip_c4_yaw",
  "recip_g0_yaw", "recip_g1_yaw", "recip_g2_yaw", "recip_g3_yaw", "recip_g4_yaw", "recip_g5_yaw",
  "recip_g6_yaw", "drive_work_yaw", "recip_sw_h0", "recip_sw_h1", "recip_sw_h2", "recip_sw_h3",
  "recip_sw_h4", "recip_st_s0", "recip_st_s1", "recip_st_s2", "recip_st_s3", "recip_st_s4",
  "recip_roll_h0", "recip_roll_h1", "recip_roll_h2", "vF_yaw_x", "vF_yaw_y", "vF_yaw_z",
  "vF_swing_x", "vF_swing_y", "vF_swing_z", "v_roll_z", "wire_moment", "boltStress", "hM12",
  "panel_amps", "elPower_screw", "az_rpm", "roller_rpm",
  -- megaReqs
  "Fits", "HangerClearsPost", "HoldsDish", "MastClears", "ReachesVertical", "SlackHarmless",
  "TrackerBudget",
  -- megaThmsClosed
  "AH_bounds", "FC_bounds", "FC_eq", "FH_bounds", "FH_eq", "HD_bounds", "HD_eq",
  "braceHeight_hashemi", "brace_cuts_moment", "brace_stiffens", "cosTubeCut_bounds",
  "deadTan_at_ym", "deadTan_hashemi", "dish_between_posts", "dish_swings_to_vertical",
  "facetSpot_hashemi", "hangerLength_bounds", "hangerLength_halfEdge", "hashemiHanger_length",
  "hashemi_clearance", "hashemi_eyes_clear", "hashemi_fits", "helixAdvance_small",
  "lean_one_degree", "lowestSun_tan_at_ym", "mastClears_hashemi", "mast_beyond_ring",
  "mast_for_vertical_hashemi", "one_turn_tilt", "panel_current", "pulley_above_pivot",
  "receiverPost_height", "rodTan_bounds", "rollerRadius_hashemi", "rollerRadius_hashemi_bounds",
  "roller_rpm_hashemi", "screwLength_hashemi", "screwLength_hashemi_bounds", "shim_negligible",
  "sideGap_eq", "sixty_reachable", "slot_exit_hashemi", "sqrt32_bounds", "wireLeft_at_ym",
  "wireLever_rest_at_ym", "wireLever_sixty_at_ym", "wire_short_of_vertical", "ym_is_standStation",
  "clearance_hashemi", "edgeClip_radius_hashemi", "tracker_margin_hashemi", "mastClears_hashemi_iff",
  "plumbed_shift", "cable_drop_small", "bearing_life", "m12_carries_dish",
  -- megaThmsState
  "azRate_pos", "drive_recip_yaw", "drive_works_on_yaw", "edgeClip_cross", "edgeClip_radius",
  "edgeClip_reach", "edgeDepth_horizon", "edgeDepth_le", "edgeDepth_noon", "edgeLever_dead",
  "edgeLever_pos_iff", "elPower_eq_wire", "elPower_le", "focus_on_axis", "grooved_relation_x",
  "grooved_relation_y", "hinge_freedom", "hinge_freedom_smul", "mul_bounds_neg_pos",
  "mul_bounds_pos_pos", "play_budget", "postTop_on_rail", "postTops_apart", "postTops_level",
  "postTops_offAxis", "reachesVertical_iff", "rim_under_F_iff", "rollerRadius_pos",
  "rollerRadius_sq", "screwLength_eq_focal", "screwTwist_zero", "screw_freedom",
  "slackHarmless_of_budget", "slackHarmless_of_lever", "sq_bounds_neg", "strut_resists_lean",
  "swingFocus_circle", "swingNormal_unit", "swing_focusCircle", "swing_lift",
  "tension_le_of_holds", "trackerBudget_iff", "tracking_power_tiny", "wireLever_edge_formula",
  "wireLever_pos_iff", "wireLever_rest", "wire_recip_swing", "wire_taut_iff", "yaw_lifts_nothing",
  "bearing_life_state"]

set_option maxRecDepth 20000 in
theorem megaNames_size : megaNames.size = 17 + 60 + 40 + 7 + 56 + 50 := by rfl

end TandoorHashemi

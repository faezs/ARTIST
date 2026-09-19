/-
# The machine at any reflector size: his relationships, run forwards

`Hashemi.lean` is one machine at one size: `dishR = 2`, `dishF = 1`, `dishHalf = 0.8`, and some
two hundred declarations that DERIVE the rest from those three - the sag `HD_eq`, the screw
length `FH_eq`, the deepest reach `FC_eq`, the chord through `dish_between_posts`/`sideGap_eq`,
the hanger `hangerLength_halfEdge`, the pulley `pulley_above_pivot`, the mast `mastClears_hashemi`,
the dead point `deadTan_at_ym`, the arm `wireLever_rest_at_ym`, the post `receiverPost_height`,
the spot `facetSpot_hashemi`.  Every one of those is a FUNCTION of the givens that his file
applies at one point.  This file names the point: `Givens` is what is independent, `Machine` is
everything the file derives, `derive` is the file's own definitions with the constants replaced by
the fields, `Sound` is the conjunction of the constraints the file states, `sound_his` is that
conjunction at his numbers - proved, so nothing about his machine changes - and `#machine 2.0` /
`lake exe machine_scale 2.0` run the same arithmetic at another size and say, per constraint,
whether it still holds.

## What is independent, and what a proportion

The reflector's half-side `a` is the one free dimension.  Everything the video MEASURES against
the dish is carried as its proportion to `a`, so that `derive his` is his machine to the
millimetre and `derive {a := 2}` is the same machine at 2.5 times the size:

| proportion | value | where the file fixes it |
|---|---|---|
| `pR = R/a` | 2.5 | `dishR`/`dishHalf`; `dishF = R/2` is `TandoorSphere.focal_zero` |
| `kGap = sideGap/a` | 0.15 | `sideGap_eq` (12 cm a side), whence `chord = 2a(1 + kGap)` = 1.84 |
| `kApex = apexH/a` | 1.0 | the carriage figure's 80 cm |
| `kBase`, `kCross`, `kBarW` | 1.225, 0.4875, 0.16875 | the same figure's 98, 39, 13.5 cm |
| `kHead = (upright - FC)/a` | 0.18125 | `hashemi_clearance`: 130 cm is F-C and 14.5 cm over |
| `kHole = holeDown/a` | 0.0625 | the bolt 5 cm below the top (12:10), `receiverPost_height` |
| `kMast = (ym - FC)/a` | 0.08125 | `ymHashemi` 1.22 against `MastClears`'s floor F-C |
| `kPulley = hp/a` | 0.425 | `pulley_above_pivot` 0.34, whence the stand's post |
| `kRim = yr/a` | 0.5 | the rim holes at the middle of each half edge (the user) |
| `kEye = reach/a` | 0.0375 | the eyes 3 cm beyond the post face (`m12_carries_dish`) |
| `kFoot`, `kBrace`, `kShort` | 0.4769, 0.7385, 0.1346 | the leg figure's 62/96/17.5 cm over its 130 |
| `kRod = rodLen/a` | 1.25 | the hanger rod's 1 m (`megaParams`) |

The leg's triangle is carried as a SIMILAR triangle because the only laws the file states about it
- `brace_cuts_moment` (the peak moment cut to 0.35) and `brace_stiffens` (24 times stiffer) - are
ratios of `braceHeight` to `upright`, and similarity is what preserves them exactly.

## What is held, and why

Everything else the file fixes is a number with no law attached to it, and it is held, marked
`-- held: the spec gives no law`:

* **the facet** `w = 0.05` - a mirror tile, section 14; a bigger dish is more tiles, not bigger
  ones.  This is why `facetSpot = w + f * 0.0093` does not scale: its second term does and its
  first does not.
* **the coil** `rc = 0.06` - "a bigger spiral tube ... placed here is temporary" (sections 14, 15).
* **the sensor** `tanEps = 0.03` - `tracker_margin_hashemi`, the 1.7° his receiver allowed.
* **the weight** `W = 300` N, **the wire** `Tmax = 2000` N, **the drum** `rDrum = 0.03`, **the
  traction** `Fdrive = 10`, **the bearings** `L10 = 1e6`, **the mirror** `rho = 0.85`, **the rod**
  `dRod = 0.010` and **the bolt** `dBolt = 0.0101` with its pitch, **the panel** 5 W at 12 V,
  **the motors** `azFull`/`elFull`.  The file states NO law by which any of them follows from the
  dish - `megaParams`' W is "a one-man lift", the bolt is "M12, the user", the panel is "a small
  5 watt panel" - so none of them is scaled here.  That silence is itself a finding: at `a = 2`
  the load constraints (`HoldsDish`, `m12_carries_dish`, `tracking_power_tiny`) pass only because
  the mass did not grow with the area, and the file gives nothing with which to make it grow.

## What the check reports

`Sound` is fifteen conjuncts, each the generalisation of a named constraint of the file.
`ReachesVertical` is NOT among them: `wire_short_of_vertical` says his own machine fails it, so it
is reported beside `Sound` as the file reports it - a limit, not a requirement.
-/
import RequestProject.HashemiPolicy
import RequestProject.HashemiTrace

namespace TandoorHashemi

open Lean Elab Command Term

/-! ## 1. The givens -/

/-- the independent dimensions: the reflector's half-side, the proportions his figures fix
against it, and the numbers the file fixes with no law attached (held) -/
structure Givens where
  /-- the reflector's half-side, `dishHalf`: the ONE free dimension -/
  a : ℝ
  /-- `R/a`, his sphere's proportion (`dishR`/`dishHalf`) -/
  pR : ℝ := 2.5
  /-- `sideGap/a` (`sideGap_eq`) -/
  kGap : ℝ := 0.15
  /-- `apexH/a` -/
  kApex : ℝ := 1.0
  /-- `aBase/a` -/
  kBase : ℝ := 1.225
  /-- `cross/a` -/
  kCross : ℝ := 0.4875
  /-- `barW/a` -/
  kBarW : ℝ := 0.16875
  /-- `(upright - FC)/a` (`hashemi_clearance`) -/
  kHead : ℝ := 0.18125
  /-- `holeDown/a` -/
  kHole : ℝ := 0.0625
  /-- `(ym - FC)/a` (`ymHashemi` over `MastClears`) -/
  kMast : ℝ := 0.08125
  /-- `hp/a` (`pulley_above_pivot`) -/
  kPulley : ℝ := 0.425
  /-- `yr/a`, the rim hole along the edge -/
  kRim : ℝ := 0.5
  /-- the eye's reach beyond the post face, over `a` -/
  kEye : ℝ := 0.0375
  /-- the leg's foot, brace and short side over the upright (a similar triangle) -/
  kFoot : ℝ := 0.4769230769
  kBrace : ℝ := 0.7384615385
  kShort : ℝ := 0.1346153846
  /-- the hanger rod's full length over `a` -/
  kRod : ℝ := 1.25
  /-- the centre of mass below the bolt line, over `a`: `megaParams`' 0.9 at his 0.8.  The file's
  own reason for that number - "the panel hangs between its vertex 1 m down and its rim 0.83 m
  down" - is a statement about `f` and `ze`, both of which scale with `a`, so this does too -/
  kCm : ℝ := 1.125
  -- held: the spec gives no law
  /-- the mirror tile (section 14) -- held: the spec gives no law -/
  w : ℝ := 0.05
  /-- the coil's radius (sections 14, 15) -- held: the spec gives no law -/
  rc : ℝ := 0.06
  /-- the tracker's error as a tangent (`tracker_margin_hashemi`) -- held -/
  tanEps : ℝ := 0.03
  /-- the drive roller (the frames' 5 cm) -- held -/
  rDrive : ℝ := 0.05
  /-- the winch drum (`megaParams`) -- held -/
  rDrum : ℝ := 0.03
  /-- the dish's weight, N (`megaParams`, "a one-man lift") -- held: mass has no law here -/
  W : ℝ := 300
  /-- the wire's rated tension, N -- held -/
  Tmax : ℝ := 2000
  /-- the mosaic's reflectance -- held -/
  rho : ℝ := 0.85
  /-- the roller's traction, N -- held -/
  Fdrive : ℝ := 10
  /-- the bearings' rating, revolutions -- held -/
  L10 : ℝ := 1000000
  /-- the hanger rod's diameter (M10) -- held -/
  dRod : ℝ := 0.010
  /-- the eye's offset on the bolt (a nut) -- held -/
  eyeOffset : ℝ := 0.010
  /-- the rim nut's pitch, M10 coarse -- held -/
  pitch : ℝ := 0.0015
  /-- the pivot bolt's minor diameter (M12) -- held -/
  dBolt : ℝ := 0.0101
  /-- the panel, W -- held ("you can also use a 10-watt panel") -/
  panelW : ℝ := 5
  /-- the system's volts -- held -/
  volts : ℝ := 12

/-- **his machine**: `a = dishHalf`, every proportion at the value his figures give -/
def his : Givens where
  a := dishHalf

theorem his_a : his.a = dishHalf := rfl

/-! ## 2. The machine -/

/-- every dependent dimension of the fixed-focus concentrator -/
structure Machine where
  /-- the dish (5b): half-side, sphere, focal length, rim sag, the rim's depth below F (`FH`),
  the panel's side -/
  a : ℝ
  R : ℝ
  f : ℝ
  sag : ℝ
  ze : ℝ
  side : ℝ
  /-- the carriage (2): the bar, the apex, the A, the cross member, the bar's width, the rail -/
  chord : ℝ
  apexH : ℝ
  aBase : ℝ
  cross : ℝ
  barW : ℝ
  rRail : ℝ
  sideGap : ℝ
  /-- the legs (5, 6): the upright, the hole's drop, the bolt line over the bar, the deepest reach
  of the rim below the bolts (F-C), what is left over the bar, the leg's triangle -/
  upright : ℝ
  holeDown : ℝ
  postH : ℝ
  FC : ℝ
  clearance : ℝ
  foot : ℝ
  brace : ℝ
  footShort : ℝ
  braceHeight : ℝ
  /-- the hangers (6, 8, 12): the rim hole's station, its depth, the rod's length eye to hole, its
  lean, the eye's reach, the rod stock -/
  rimHole : ℝ
  zh : ℝ
  hanger : ℝ
  rodTan : ℝ
  boltReach : ℝ
  rodLen : ℝ
  /-- the mast and the wire (7, 9, 11): the mast's station, the pulley over the bolts, the stand's
  post and foot, the dead point's tangent, the arm at rest, the wire left there, the wire the
  winch takes in -/
  ym : ℝ
  hp : ℝ
  standPost : ℝ
  standFoot : ℝ
  deadTan : ℝ
  armRest : ℝ
  wireLeft : ℝ
  wireTake : ℝ
  /-- the receiver (14): the slot's exit tangent, the centre of mass below the bolts -/
  slotTan : ℝ
  rcm : ℝ
  /-- the optics (14): the facet, the coil, the spot at F, the coil's margin over it, the pointing
  budget that margin allows as a tangent, the sensor's own error -/
  w : ℝ
  rc : ℝ
  spotW : ℝ
  margin : ℝ
  budgetTan : ℝ
  tanEps : ℝ
  /-- the alignment and the loads (10, 12): the tilt one turn of a rim nut sets, the bolt's
  bending stress, the weight, the wire's rating, the drum, the drive roller, the traction, the
  bearings, the mirror, the panel, the volts -/
  tiltPerTurn : ℝ
  boltStress : ℝ
  boltD : ℝ
  W : ℝ
  Tmax : ℝ
  rDrum : ℝ
  rDrive : ℝ
  Fdrive : ℝ
  L10 : ℝ
  rho : ℝ
  panelW : ℝ
  volts : ℝ

/-- **the derivation**: every field is the file's own definition with his constants replaced by
the givens.  Nothing here is new; the right-hand sides are `TandoorSphere.sag`, `screwLength`,
`dishSide`, `sideGap`, `rollerRadius`, the bound of `edgeDepth_le`, `braceHeight`, `hangerLength`,
`rodTan`, `pulley_above_pivot`, `deadTan_at_ym`, `wireLever_rest`, `wireLeft_at_ym`,
`rim_under_F_iff`, `facetSpot`, `tiltOfMismatch` and `boltStress` -/
noncomputable def derive (g : Givens) : Machine :=
  let a := g.a
  let R := g.pR * a
  let f := R / 2                                        -- TandoorSphere.focal_zero
  let sag := TandoorSphere.sag R a                      -- HD_eq
  let ze := screwLength R a                             -- FH_eq: f - sag
  let side := 2 * a                                     -- dishSide
  let sideGap := g.kGap * a                             -- sideGap_eq
  let chord := side + 2 * sideGap                       -- dish_between_posts, the other way round
  let apexH := g.kApex * a
  let rRail := Real.sqrt ((chord / 2) ^ 2 + apexH ^ 2)  -- rollerRadius
  let FC := Real.sqrt (ze ^ 2 + a ^ 2)                  -- FC_eq = the bound of edgeDepth_le
  let upright := FC + g.kHead * a                       -- hashemi_clearance
  let holeDown := g.kHole * a
  let postH := upright - holeDown                       -- receiverPost_height
  let foot := g.kFoot * upright
  let brace := g.kBrace * upright
  let footShort := g.kShort * upright
  let footLong := foot - footShort
  let rimHole := g.kRim * a
  let zh := f - TandoorSphere.sag R (Real.sqrt (a ^ 2 + rimHole ^ 2))
  let ym := FC + g.kMast * a                            -- MastClears' floor, plus his margin
  let hp := g.kPulley * a                               -- pulley_above_pivot
  let spotW := facetSpot g.w f                          -- facetSpot_hashemi
  let margin := g.rc - spotW / 2
  let rcm := g.kCm * a                                  -- megaParams 0.9: between the vertex (f) and the rim (ze)
  let boltReach := g.kEye * a
  { a := a, R := R, f := f, sag := sag, ze := ze, side := side,
    chord := chord, apexH := apexH, aBase := g.kBase * a, cross := g.kCross * a,
    barW := g.kBarW * a, rRail := rRail, sideGap := sideGap,
    upright := upright, holeDown := holeDown, postH := postH, FC := FC,
    clearance := upright - holeDown - FC,               -- clearance
    foot := foot, brace := brace, footShort := footShort,
    braceHeight := Real.sqrt (brace ^ 2 - footLong ^ 2),-- braceHeight
    rimHole := rimHole, zh := zh,
    hanger := hangerLength R a rimHole 0,               -- hangerLength_halfEdge
    rodTan := rimHole / zh,                             -- rodTan
    boltReach := boltReach, rodLen := g.kRod * a,
    ym := ym, hp := hp, standPost := postH + hp, standFoot := chord,
    deadTan := (ym * ze + hp * a) / (ym * a - hp * ze), -- deadTan_at_ym
    armRest := (ym * ze + hp * a) / Real.sqrt ((ym - a) ^ 2 + (hp + ze) ^ 2),  -- wireLever_rest
    wireLeft := Real.sqrt (ym ^ 2 + hp ^ 2) - FC,      -- wireLeft_at_ym
    wireTake := Real.sqrt ((ym - a) ^ 2 + (hp + ze) ^ 2) - (Real.sqrt (ym ^ 2 + hp ^ 2) - FC),
    slotTan := a / ze,                                  -- slot_exit_hashemi
    rcm := rcm,
    w := g.w, rc := g.rc, spotW := spotW, margin := margin,
    budgetTan := margin / f,                            -- trackerBudget_iff
    tanEps := g.tanEps,
    tiltPerTurn := g.pitch / side,                      -- tiltOfMismatch
    boltStress := boltStress g.W boltReach g.dBolt,    -- m12_carries_dish
    boltD := g.dBolt, W := g.W, Tmax := g.Tmax, rDrum := g.rDrum, rDrive := g.rDrive,
    Fdrive := g.Fdrive, L10 := g.L10, rho := g.rho, panelW := g.panelW, volts := g.volts }

/-! ## 3. Soundness: the file's constraints, generalised -/

/-- **every constraint `Hashemi.lean` states, at this machine**.  In order: the dish is real;
the panel fits between the posts (`dish_between_posts`); the mast clears the clip's circle
(`MastClears`, `mastClears_hashemi`); something is left over the bar at the worst elevation
(`clearance_hashemi`); the dish can swing to the vertical (`dish_swings_to_vertical`); the eyes
clear the post (`HangerClearsPost`, `hashemi_eyes_clear`); the rod is long enough to set the
hanger (`setLength_surj`); the winch holds the dish on its side (`HoldsDish`); 60° of swing is
inside the wire's range (`sixty_reachable`); the coil is wider than the facet's own beam
(`facetSpot_hashemi` against the coil); the tracker's error is inside the receiver's margin
(`TrackerBudget` through `trackerBudget_iff`); the finest head step stays inside that same budget
(`quantum_within_budget`); the pivot bolt carries the dish (`m12_carries_dish`); tracking costs
under 1.5 % of the panel (`tracking_power_tiny`); one turn of a rim nut moves F under a
millimetre (`one_turn_tilt`) -/
def Sound (m : Machine) : Prop :=
  0 < m.a ∧
  m.side < m.chord ∧
  MastClears m.ym m.a m.ze ∧
  0 < m.clearance ∧
  m.a < m.postH ∧
  HangerClearsPost 0.010 0.010 ∧
  m.hanger < m.rodLen ∧
  HoldsDish m.Tmax m.W m.rcm m.armRest ∧
  Real.sin (Real.pi / 3) * (m.ym * m.a - m.hp * m.ze) <
    Real.cos (Real.pi / 3) * (m.ym * m.ze + m.hp * m.a) ∧
  0 < m.margin ∧
  m.f * m.tanEps ≤ m.margin ∧
  azFull / 3 * 15 < m.budgetTan ∧ elFull / 3 * 15 < m.budgetTan ∧
  m.boltStress < 1.6e8 ∧
  m.W * m.rcm * 7.3e-5 ≤ 0.015 * m.panelW ∧
  m.f * m.tiltPerTurn < 0.001

/-! ### His machine, unchanged

The bounds his file proves, re-derived through `derive`: nothing about his machine moves. -/

theorem derive_his_a : (derive his).a = 0.8 := rfl
theorem derive_his_R : (derive his).R = 2 := by show (2.5 : ℝ) * 0.8 = 2; norm_num
theorem derive_his_f : (derive his).f = 1 := by show (2.5 : ℝ) * 0.8 / 2 = 1; norm_num
theorem derive_his_side : (derive his).side = dishSide := by
  show (2 : ℝ) * 0.8 = 2 * dishHalf; unfold dishHalf; norm_num
theorem derive_his_chord : (derive his).chord = hashemi.chord := by
  show (2 : ℝ) * 0.8 + 2 * (0.15 * 0.8) = hashemi.chord; unfold hashemi; norm_num
theorem derive_his_apexH : (derive his).apexH = hashemi.apexH := by
  show (1.0 : ℝ) * 0.8 = hashemi.apexH; unfold hashemi; norm_num
theorem derive_his_sideGap : (derive his).sideGap = sideGap := by
  rw [sideGap_eq]; show (0.15 : ℝ) * 0.8 = 0.12; norm_num

/-- the rim's depth below the bolt line is his `FH = √3.36 - 1` -/
theorem derive_his_ze : (derive his).ze = Real.sqrt 3.36 - 1 := by
  show screwLength (2.5 * 0.8) 0.8 = _
  rw [show (2.5 : ℝ) * 0.8 = dishR by unfold dishR; norm_num,
      show (0.8 : ℝ) = dishHalf by unfold dishHalf; norm_num]
  exact FH_eq

theorem ze_bounds : 0.833 < (derive his).ze ∧ (derive his).ze < 0.8331 := by
  rw [derive_his_ze]; constructor <;> linarith [AH_bounds.1, AH_bounds.2]

/-- the deepest reach of the rim below the bolts is his F-C -/
theorem derive_his_FC : (derive his).FC = Real.sqrt (5 - 2 * Real.sqrt 3.36) := by
  show Real.sqrt ((derive his).ze ^ 2 + (0.8 : ℝ) ^ 2) = _
  rw [derive_his_ze]
  congr 1
  have h : Real.sqrt 3.36 ^ 2 = 3.36 := Real.sq_sqrt (by norm_num)
  nlinarith [h]

theorem FC_bounds' : 1.154 < (derive his).FC ∧ (derive his).FC < 1.1551 := by
  rw [derive_his_FC]; exact FC_bounds

/-- **1.30 m**: his upright, from F-C and the 14.5 cm over it -/
theorem derive_his_upright : 1.2989 < (derive his).upright ∧ (derive his).upright < 1.3001 := by
  have h : (derive his).upright = (derive his).FC + 0.18125 * 0.8 := rfl
  rw [h]; constructor <;> linarith [FC_bounds'.1, FC_bounds'.2]

/-- **1.22 m**: his mast station, `ymHashemi`, from F-C and his margin -/
theorem derive_his_ym : 1.2189 < (derive his).ym ∧ (derive his).ym < 1.2201 := by
  have h : (derive his).ym = (derive his).FC + 0.08125 * 0.8 := rfl
  rw [h]; constructor <;> linarith [FC_bounds'.1, FC_bounds'.2]

/-- **0.34 m**: `pulley_above_pivot` -/
theorem derive_his_hp : (derive his).hp = 0.34 := by show (0.425 : ℝ) * 0.8 = 0.34; norm_num

/-- **1.25 m**: `receiverPost_height` -/
theorem derive_his_postH : 1.2489 < (derive his).postH ∧ (derive his).postH < 1.2501 := by
  have h : (derive his).postH = (derive his).upright - 0.0625 * 0.8 := rfl
  rw [h]; constructor <;> linarith [derive_his_upright.1, derive_his_upright.2]

/-- **1.59 m**: his stand's post -/
theorem derive_his_standPost :
    1.5889 < (derive his).standPost ∧ (derive his).standPost < 1.5901 := by
  have h : (derive his).standPost = (derive his).postH + (derive his).hp := rfl
  rw [h, derive_his_hp]; constructor <;> linarith [derive_his_postH.1, derive_his_postH.2]

/-- **9.5 cm** left over the bar at the worst elevation (`clearance_hashemi`) -/
theorem derive_his_clearance : (derive his).clearance = 0.095 := by
  show (derive his).upright - 0.0625 * 0.8 - (derive his).FC = 0.095
  have h : (derive his).upright = (derive his).FC + 0.18125 * 0.8 := rfl
  rw [h]; ring

/-- **0.0593 m** at F: `facetSpot_hashemi` -/
theorem derive_his_spotW : (derive his).spotW = 0.0593 := by
  show facetSpot 0.05 ((2.5 : ℝ) * 0.8 / 2) = 0.0593
  unfold facetSpot; norm_num

/-- and so the coil leaves **3.035 cm** of margin, the budget of `tracker_margin_hashemi` -/
theorem derive_his_margin : (derive his).margin = 0.03035 := by
  show (0.06 : ℝ) - (derive his).spotW / 2 = 0.03035
  rw [derive_his_spotW]; norm_num

theorem derive_his_budgetTan : (derive his).budgetTan = 0.03035 := by
  show (derive his).margin / ((2.5 : ℝ) * 0.8 / 2) = 0.03035
  rw [derive_his_margin]; norm_num

/-- the arm at rest, **1.03 m** (`wireLever_rest_at_ym`) -/
theorem derive_his_armRest : 1.03 < (derive his).armRest ∧ (derive his).armRest < 1.04 := by
  have hz := ze_bounds
  have hy := derive_his_ym
  have harm : (derive his).armRest =
      ((derive his).ym * (derive his).ze + 0.34 * 0.8) /
        Real.sqrt (((derive his).ym - 0.8) ^ 2 + (0.34 + (derive his).ze) ^ 2) := by
    show ((derive his).ym * (derive his).ze + (derive his).hp * 0.8) /
      Real.sqrt (((derive his).ym - 0.8) ^ 2 + ((derive his).hp + (derive his).ze) ^ 2) = _
    rw [derive_his_hp]
  rw [harm]
  set y := (derive his).ym
  set z := (derive his).ze
  have hnum1 : (1.2873 : ℝ) < y * z + 0.34 * 0.8 := by nlinarith [hy.1, hz.1]
  have hnum2 : y * z + 0.34 * 0.8 < (1.2887 : ℝ) := by nlinarith [hy.2, hz.2]
  have hd1 : (1.5514 : ℝ) < (y - 0.8) ^ 2 + (0.34 + z) ^ 2 := by nlinarith [hy.1, hz.1, hy.2, hz.2]
  have hd2 : (y - 0.8) ^ 2 + (0.34 + z) ^ 2 < (1.5539 : ℝ) := by nlinarith [hy.1, hz.1, hy.2, hz.2]
  have hs1 : (1.2455 : ℝ) < Real.sqrt ((y - 0.8) ^ 2 + (0.34 + z) ^ 2) := by
    rw [Real.lt_sqrt (by norm_num)]; nlinarith [hd1]
  have hs2 : Real.sqrt ((y - 0.8) ^ 2 + (0.34 + z) ^ 2) < (1.2466 : ℝ) := by
    rw [Real.sqrt_lt' (by norm_num)]; nlinarith [hd2]
  have hpos : 0 < Real.sqrt ((y - 0.8) ^ 2 + (0.34 + z) ^ 2) := by linarith
  constructor
  · rw [lt_div_iff₀ hpos]; nlinarith
  · rw [div_lt_iff₀ hpos]; nlinarith

/-- the centre of mass, **0.9 m** below the bolts: `megaParams`' own number, and it lies between
the rim (`ze` = 0.833) and the vertex (`f` = 1), which is the reason the file gives for it -/
theorem derive_his_rcm : (derive his).rcm = 0.9 := by show (1.125 : ℝ) * 0.8 = 0.9; norm_num

theorem derive_his_rcm_between : (derive his).ze < (derive his).rcm ∧ (derive his).rcm < (derive his).f := by
  rw [derive_his_rcm, derive_his_f]; constructor <;> linarith [ze_bounds.2]

/-- the hanger, **0.884 m** (`hangerLength_bounds`) -/
theorem derive_his_hanger :
    0.884 < (derive his).hanger ∧ (derive his).hanger < 0.8846 := by
  have h : (derive his).hanger = hangerLength 2 0.8 0.4 0 := by
    show hangerLength ((2.5 : ℝ) * 0.8) 0.8 (0.5 * 0.8) 0 = _
    norm_num
  rw [h, hangerLength_halfEdge]; exact hangerLength_bounds

/-- the bolt's stress, **44.5 MPa** at his 300 N (`m12_carries_dish` at the same reach) -/
theorem derive_his_boltStress : (derive his).boltStress < 1.6e8 := by
  have h : (derive his).boltStress = boltStress 300 0.03 0.0101 := by
    show boltStress 300 (0.0375 * 0.8) 0.0101 = _; norm_num
  rw [h]; exact m12_carries_dish (by norm_num)

/-- **`Sound (derive his)`**: every constraint his file states, at his machine, proved -/
theorem sound_his : Sound (derive his) := by
  have hz := ze_bounds
  have hy := derive_his_ym
  have harm := derive_his_armRest
  have hrcm := derive_his_rcm
  refine ⟨by show (0:ℝ) < 0.8; norm_num, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · -- the panel between the posts
    show (2 : ℝ) * 0.8 < 2 * 0.8 + 2 * (0.15 * 0.8); norm_num
  · -- the mast clears the clip's circle
    show Real.sqrt ((derive his).a ^ 2 + (derive his).ze ^ 2) < (derive his).ym
    have hc : Real.sqrt ((derive his).a ^ 2 + (derive his).ze ^ 2) = (derive his).FC := by
      show Real.sqrt ((0.8 : ℝ) ^ 2 + (derive his).ze ^ 2) = Real.sqrt ((derive his).ze ^ 2 + 0.8 ^ 2)
      ring_nf
    rw [hc]
    have h : (derive his).ym = (derive his).FC + 0.08125 * 0.8 := rfl
    rw [h]; norm_num
  · rw [derive_his_clearance]; norm_num
  · -- the dish swings to the vertical
    show (0.8 : ℝ) < (derive his).postH
    linarith [derive_his_postH.1]
  · show (0.010 : ℝ) / 2 < 0.010; norm_num
  · -- the rod is longer than the hanger
    show (derive his).hanger < 1.25 * 0.8
    linarith [derive_his_hanger.2]
  · -- the winch holds the dish
    show (derive his).W * (derive his).rcm ≤ (derive his).Tmax * (derive his).armRest
    show (300 : ℝ) * (derive his).rcm ≤ 2000 * (derive his).armRest
    rw [hrcm]; nlinarith [harm.1]
  · -- 60 degrees of swing is inside the wire's range
    rw [Real.sin_pi_div_three, Real.cos_pi_div_three]
    have h3 : Real.sqrt 3 < 1.7321 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
    have h30 : (0 : ℝ) ≤ Real.sqrt 3 := Real.sqrt_nonneg 3
    have ha : (derive his).a = 0.8 := rfl
    have hh : (derive his).hp = 0.34 := derive_his_hp
    rw [ha, hh]
    have hq : 0 < (derive his).ym * 0.8 - 0.34 * (derive his).ze := by nlinarith [hy.1, hz.2]
    nlinarith [mul_pos (sub_pos.2 h3) hq, mul_nonneg h30 hq.le, hy.1, hz.1]
  · rw [derive_his_margin]; norm_num
  · -- the sensor inside the receiver's margin
    show (derive his).f * (0.03 : ℝ) ≤ (derive his).margin
    rw [derive_his_margin, derive_his_f]; norm_num
  · rw [derive_his_budgetTan]; unfold azFull; nlinarith [Real.pi_le_four]
  · rw [derive_his_budgetTan]; unfold elFull; nlinarith [Real.pi_le_four]
  · exact derive_his_boltStress
  · -- tracking under 1.5 % of the panel
    show (300 : ℝ) * (derive his).rcm * 7.3e-5 ≤ 0.015 * 5
    rw [hrcm]; norm_num
  · -- one turn of a rim nut
    show (derive his).f * (0.0015 / ((2 : ℝ) * 0.8)) < 0.001
    rw [derive_his_f]; norm_num

/-! ## 4. The Float twin, the command, and the exe

`derive` is `Real`: its fields are `Real.sqrt`, and no command can print them.  `deriveF` is the
same arithmetic in `Float`, line for line, and the exe checks it against the intervals the
theorems above PROVE at `a = 0.8` before it prints anything, so the twin cannot drift.  The
verdicts are Float comparisons with a relative guard: a conjunct whose two sides agree to within
`1e-9` of their scale is reported `undecided`, never silently `holds`. -/

/-- the givens in Float -/
structure GivensF where
  a : Float
  pR : Float := 2.5
  kGap : Float := 0.15
  kApex : Float := 1.0
  kBase : Float := 1.225
  kCross : Float := 0.4875
  kBarW : Float := 0.16875
  kHead : Float := 0.18125
  kHole : Float := 0.0625
  kMast : Float := 0.08125
  kPulley : Float := 0.425
  kRim : Float := 0.5
  kEye : Float := 0.0375
  kFoot : Float := 0.4769230769
  kBrace : Float := 0.7384615385
  kShort : Float := 0.1346153846
  kRod : Float := 1.25
  kCm : Float := 1.125
  w : Float := 0.05
  rc : Float := 0.06
  tanEps : Float := 0.03
  rDrive : Float := 0.05
  rDrum : Float := 0.03
  W : Float := 300
  Tmax : Float := 2000
  rho : Float := 0.85
  Fdrive : Float := 10
  L10 : Float := 1000000
  dRod : Float := 0.010
  eyeOffset : Float := 0.010
  pitch : Float := 0.0015
  dBolt : Float := 0.0101
  panelW : Float := 5
  volts : Float := 12

/-- the machine in Float: the same fields, as `(name, value)` so the table and the JSON are one
list and cannot disagree -/
def deriveF (g : GivensF) : Array (String × Float) :=
  let a := g.a
  let R := g.pR * a
  let f := R / 2
  let sag := R - Float.sqrt (R * R - a * a)
  let ze := f - sag
  let side := 2 * a
  let sideGap := g.kGap * a
  let chord := side + 2 * sideGap
  let apexH := g.kApex * a
  let rRail := Float.sqrt ((chord / 2) * (chord / 2) + apexH * apexH)
  let FC := Float.sqrt (ze * ze + a * a)
  let upright := FC + g.kHead * a
  let holeDown := g.kHole * a
  let postH := upright - holeDown
  let foot := g.kFoot * upright
  let brace := g.kBrace * upright
  let footShort := g.kShort * upright
  let footLong := foot - footShort
  let braceHeight := Float.sqrt (brace * brace - footLong * footLong)
  let rimHole := g.kRim * a
  let rh := Float.sqrt (a * a + rimHole * rimHole)
  let zh := f - (R - Float.sqrt (R * R - rh * rh))
  let hanger := Float.sqrt (rimHole * rimHole + zh * zh)
  let ym := FC + g.kMast * a
  let hp := g.kPulley * a
  let Lrest := Float.sqrt ((ym - a) * (ym - a) + (hp + ze) * (hp + ze))
  let Ldead := Float.sqrt (ym * ym + hp * hp) - FC
  let spotW := g.w + f * 0.0093
  let margin := g.rc - spotW / 2
  let rcm := g.kCm * a
  let boltReach := g.kEye * a
  let deadTan := (ym * ze + hp * a) / (ym * a - hp * ze)
  #[("a", a), ("R", R), ("f", f), ("sag", sag), ("ze", ze), ("side", side),
    ("chord", chord), ("apexH", apexH), ("aBase", g.kBase * a), ("cross", g.kCross * a),
    ("barW", g.kBarW * a), ("rRail", rRail), ("sideGap", sideGap),
    ("upright", upright), ("holeDown", holeDown), ("postH", postH), ("FC", FC),
    ("clearance", upright - holeDown - FC),
    ("foot", foot), ("brace", brace), ("footShort", footShort), ("braceHeight", braceHeight),
    ("rimHole", rimHole), ("zh", zh), ("hanger", hanger), ("rodTan", rimHole / zh),
    ("boltReach", boltReach), ("rodLen", g.kRod * a),
    ("ym", ym), ("hp", hp), ("standPost", postH + hp), ("standFoot", chord),
    ("deadTan", deadTan), ("deadDeg", Float.atan deadTan * 180.0 / 3.14159265358979323846),
    ("armRest", (ym * ze + hp * a) / Lrest), ("wireLeft", Ldead), ("wireTake", Lrest - Ldead),
    ("slotTan", a / ze), ("rcm", rcm),
    ("w", g.w), ("rc", g.rc), ("spotW", spotW), ("margin", margin),
    ("budgetTan", margin / f), ("budgetDeg", Float.atan (margin / f) * 180.0 / 3.14159265358979323846),
    ("tanEps", g.tanEps),
    ("tiltPerTurn", g.pitch / side),
    ("boltStress", (g.W / 2 * boltReach) / (3.14159265358979323846 * g.dBolt * g.dBolt * g.dBolt / 32)),
    ("boltD", g.dBolt), ("W", g.W), ("Tmax", g.Tmax), ("rDrum", g.rDrum), ("rDrive", g.rDrive),
    ("Fdrive", g.Fdrive), ("L10", g.L10), ("rho", g.rho), ("panelW", g.panelW),
    ("volts", g.volts)]

/-- a field of the derived table -/
def fieldOf (m : Array (String × Float)) (n : String) : Float :=
  match m.find? (fun p => p.1 == n) with
  | some p => p.2
  | none => 0.0

/-- the two motor rates of `HashemiPolicy.lean`, in Float: `azFull`, `elFull` (rad/s) -/
def azFullF : Float := 0.035 * 3.14159265358979323846 / 180
def elFullF : Float := 0.025 * 3.14159265358979323846 / 180

/-- a verdict on one constraint: the two sides, the relation, and `holds`/`FAILS`/`undecided`
(undecided when the sides agree to within `1e-9` of their scale - never silently `holds`) -/
def verdict (lhs rhs : Float) : String :=
  let s := max 1.0 (max lhs.abs rhs.abs)
  if (rhs - lhs).abs ≤ 1e-9 * s then "undecided" else if lhs < rhs then "holds" else "FAILS"

/-- **`Sound`, conjunct by conjunct, as `lhs < rhs`**: the same fifteen, in the same order, and
then `ReachesVertical` - which `wire_short_of_vertical` says HIS machine fails, so it is reported
apart, as the file reports it -/
def checksF (m : Array (String × Float)) : Array (String × Float × Float × String) :=
  let g := fieldOf m
  let row (n : String) (lhs rhs : Float) := (n, lhs, rhs, verdict lhs rhs)
  #[row "positive_a" 0 (g "a"),
    row "dish_between_posts" (g "side") (g "chord"),
    row "MastClears" (g "FC") (g "ym"),
    row "clearance" 0 (g "clearance"),
    row "dish_swings_to_vertical" (g "a") (g "postH"),
    row "HangerClearsPost" (0.010 / 2) 0.010,
    row "rod_sets_hanger" (g "hanger") (g "rodLen"),
    row "HoldsDish" (g "W" * g "rcm") (g "Tmax" * g "armRest"),
    row "sixty_reachable" (0.8660254038 * (g "ym" * g "a" - g "hp" * g "ze"))
      (0.5 * (g "ym" * g "ze" + g "hp" * g "a")),
    row "coil_covers_facet" (g "spotW" / 2) (g "rc"),
    row "TrackerBudget" (g "f" * g "tanEps") (g "margin"),
    row "quantum_within_budget_az" (azFullF / 3 * 15) (g "budgetTan"),
    row "quantum_within_budget_el" (elFullF / 3 * 15) (g "budgetTan"),
    row "m12_carries_dish" (g "boltStress") 1.6e8,
    row "tracking_power_tiny" (g "W" * g "rcm" * 7.3e-5) (0.015 * g "panelW"),
    row "one_turn_tilt" (g "f" * g "tiltPerTurn") 0.001,
    row "ReachesVertical (not in Sound: wire_short_of_vertical)"
      (g "ym" * g "a") (g "hp" * g "ze")]

/-- the report: the derived table, then the verdicts -/
def report (a : Float) : String :=
  let m := deriveF { a := a }
  let rows := m.foldl (fun s p => s ++ s!"  {p.1.pushn ' ' (if p.1.length < 16 then 16 - p.1.length else 0)} {p.2}\n") ""
  let ok := (checksF m).foldl (fun n r => if r.2.2.2 == "holds" then n + 1 else n) 0
  let ver := (checksF m).foldl
    (fun s r => s ++ s!"  {r.1.pushn ' ' (if r.1.length < 46 then 46 - r.1.length else 0)} {r.2.2.2}   {r.2.1} < {r.2.2.1}\n") ""
  s!"#machine {a}\n{rows}\n  constraints ({ok} of {(checksF m).size} hold):\n{ver}"

/-- **`#machine 2.0`**: the whole machine at that half-side, and every constraint's verdict -/
def floatOfSyntax (s : Syntax) : Option Float :=
  match s.isNatLit? with
  | some n => some (Float.ofNat n)
  | none => match s.isScientificLit? with
            | some (m, e, exp) => some (Float.ofScientific m e exp)
            | none => none

elab "#machine " t:term : command => do
  match floatOfSyntax t with
  | some a => logInfo (report a)
  | none => throwError "#machine takes a numeral, e.g. #machine 2.0" 

/-- the JSON the runtime reads: the kernel's optics inputs (`R f a w rc`), the mount parameters
(`megaParams`: `rDrum W rcm Tmax rho Fdrive L10 rodLen`), the build's dimensions, and the
verdicts, so the env can refuse a machine the spec says is unsound -/
def machineJson (a : Float) : String :=
  let m := deriveF { a := a }
  let g := fieldOf m
  let quote (s : String) := "\"" ++ s ++ "\""
  let pairs := m.foldl (fun acc p => acc.push s!"    {quote p.1}: {p.2}") #[]
  let isSound (n : String) := !(n.startsWith "ReachesVertical")
  let chk := ((checksF m).filter (fun r => isSound r.1)).foldl
    (fun acc r => acc.push s!"    {quote r.1}: {quote r.2.2.2}") #[]
  let rest := ((checksF m).filter (fun r => !isSound r.1)).foldl
    (fun acc r => acc.push s!"    {quote r.1}: {quote r.2.2.2}") #[]
  let kern := #[s!"    {quote "R"}: {g "R"}", s!"    {quote "f"}: {g "f"}", s!"    {quote "a"}: {g "a"}",
    s!"    {quote "w"}: {g "w"}", s!"    {quote "rc"}: {g "rc"}"]
  let mount := #[s!"    {quote "rDrum"}: {g "rDrum"}", s!"    {quote "W"}: {g "W"}",
    s!"    {quote "rcm"}: {g "rcm"}", s!"    {quote "Tmax"}: {g "Tmax"}",
    s!"    {quote "rho"}: {g "rho"}", s!"    {quote "Fdrive"}: {g "Fdrive"}",
    s!"    {quote "L10"}: {g "L10"}", s!"    {quote "rodLen"}: {g "rodLen"}"]
  "{\n  \"source\": \"RequestProject/HashemiScale.lean: derive, from Hashemi.lean's own relationships\",\n" ++
  s!"  \"a\": {a},\n" ++
  "  \"kernel\": {\n" ++ String.intercalate ",\n" kern.toList ++ "\n  },\n" ++
  "  \"mount\": {\n" ++ String.intercalate ",\n" mount.toList ++ "\n  },\n" ++
  "  \"machine\": {\n" ++ String.intercalate ",\n" pairs.toList ++ "\n  },\n" ++
  "  \"constraints\": {\n" ++ String.intercalate ",\n" chk.toList ++ "\n  },\n" ++
  "  \"not_required\": {\n" ++ String.intercalate ",\n" rest.toList ++ "\n  }\n}\n"

/-- the Float twin against the intervals the theorems PROVE at `a = 0.8`: `ze` (`FH_bounds`),
`FC` (`FC_bounds`), the upright, `ym` (`ymHashemi`), `hp` (`pulley_above_pivot`), the post
(`receiverPost_height`), the stand, the hanger (`hangerLength_bounds`), the arm
(`wireLever_rest_at_ym`), the dead point (`deadTan_at_ym`), the spot (`facetSpot_hashemi`), the
slot (`slot_exit_hashemi`), the rail (`rollerRadius_hashemi_bounds`), the gap (`sideGap_eq`), the
brace (`braceHeight_hashemi`), the lean (`rodTan_bounds`), the wire left (`wireLeft_at_ym`) -/
def hisChecks : Array (String × Float × Float) :=
  #[("ze", 0.833, 0.8331), ("FC", 1.154, 1.1551), ("upright", 1.2989, 1.3001),
    ("ym", 1.2189, 1.2201), ("hp", 0.3399, 0.3401), ("postH", 1.2489, 1.2501),
    ("standPost", 1.5889, 1.5901), ("hanger", 0.884, 0.8846),
    ("armRest", 1.033, 1.035), ("rcm", 0.8999, 0.9001), ("deadTan", 1.859, 1.86),
    ("spotW", 0.0592, 0.0594), ("slotTan", 0.960, 0.9605),
    ("rRail", 1.219, 1.2195), ("sideGap", 0.1199, 0.1201),
    ("braceHeight", 0.85, 0.851), ("rodTan", 0.507, 0.5072),
    ("wireLeft", 0.111, 0.113), ("chord", 1.8399, 1.8401), ("apexH", 0.7999, 0.8001)]

end TandoorHashemi

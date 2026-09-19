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
* **the sensor** `tanEps = 0.03` - `tracker_margin_hashemi`, the 1.7 deg his receiver allowed.
* **the weight** `W = 300` N, **the wire** `Tmax = 2000` N, **the drum** `rDrum = 0.03`, **the
  traction** `Fdrive = 10`, **the bearings** `L10 = 1e6`, **the mirror** `rho = 0.85`, **the rod**
  `dRod = 0.010` and **the bolt** `dBolt = 0.0101` with its pitch, **the panel** 5 W at 12 V,
  **the motors** `azDeg`/`elDeg` (`azFull`/`elFull` in deg/s).
* **the loop** (`HashemiOil.lean`, `hashemi_env_kernel.py`'s `LOOP_PARAMS`): the coil's surface
  `Ac = 0.03` and bore `Dc = 0.010`, the run's bore `Dp = 0.012` and length `Lp = 6`, the pump's
  full flow `Qmax`, its efficiency and its STANDING DRAW `Pidle = 8` W, the coil's absorptance,
  the expansion tank.  The video names no oil, no pump and no pipe diameter at all.

The file states NO law by which any of them follows from the dish - `megaParams`' W is "a one-man
lift", the bolt is "M12, the user", the panel is "a small 5 watt panel" - so none of them is
scaled here.  That silence is the whole subject of this file.

## What the check reports

`SoundGeom` is sixteen conjuncts, each the generalisation of a named constraint of the file, and
`SoundLoop` is three more from `HashemiOil.lean` - the pump inside the panel's budget, the
stagnation film temperature under the fluid's limit, the expansion tank.  `Sound` is both.
`ReachesVertical` is NOT among them: `wire_short_of_vertical` says his own machine fails it, so it
is reported beside `Sound` as the file reports it - a limit, not a requirement.

**`sound_his : SoundGeom (derive his)` is proved**, so nothing about his build moves.  The loop is
a different story, and it is reported, not weakened: `tank_holds_his` is proved, but
`pump_over_budget_his` proves his 5 W panel does NOT pay for an 8 W pump, and
`film_over_limit_his` proves that at any film coefficient under 1958 W/m2K - the Float twin
measures 1173 - his own 0.03 m2 coil at his own 1958 W of sunlight puts the oil's wall at 668 K,
over Therminol 66's 648 K film limit.  So `not_sound_his : ~ Sound (derive his)` is a theorem.

## Design by constraint

Every conjunct is an inequality in ONE held quantity, and solved for it, it is a design rule
(section 4): `rcMin` (the coil `TrackerBudget` needs), `epsMax` (the sensor that coil allows),
`wMax` (the facet it allows - negative at `a = 2`, which is the lever going dead), `panelMin`
(`PumpWithinBudget`), `AcMin` and `coilLenMin` (the film limit), `tankMin` (the expansion).  Each
has a theorem that the solved value satisfies its conjunct BY CONSTRUCTION
(`tracker_holds_of_rc`, `pump_holds_of_panel`, `film_holds_of_Ac`, `tank_holds_of_tank`), and
`design` takes the pointwise maximum of the held value and its floor - the MINIMAL change to the
held set - with `design_tracker`, `design_pump`, `design_film`, `design_tank` proved of it.

`#machine 2.0` reports the held machine's verdicts, `#design 2.0` prints what had to change
(`rc 0.060 -> 0.112 (TrackerBudget)`, `panelW 5 -> 8.59 (PumpWithinBudget)`,
`Ac 0.030 -> 0.313 (FilmLimit)`) and the designed machine's verdicts, and
`#machine 2.0 with rc := 0.112, panelW := 13` is the what-if beside it.  `lake exe machine_scale
2.0 --design out.json` writes the designed machine for the env, with the changes recorded in it.
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
  /-- the roller's rate at full command, deg/s (`HashemiPolicy.azFull`) -- held: the video gives
  neither drum nor ratios, so the rate does not follow from the dish -/
  azDeg : ℝ := 0.035
  /-- the winch's rate at full command, deg/s (`HashemiPolicy.elFull`) -- held -/
  elDeg : ℝ := 0.025
  -- the loop (HashemiOil.lean).  The video names no oil, no pump and no pipe diameter; these are
  -- `hashemi_env_kernel.py`'s `LOOP_PARAMS`, and every one of them is held for the same reason.
  /-- the coil's wetted surface, m² -- held: the spec gives no law -/
  Ac : ℝ := 0.03
  /-- the coil's tube bore, m -- held -/
  Dc : ℝ := 0.010
  /-- the run's bore, m -- held -/
  Dp : ℝ := 0.012
  /-- the run's length, m -- held -/
  Lp : ℝ := 6.0
  /-- the pump at full command, m³/s -- held -/
  Qmax : ℝ := 6.0e-5
  /-- the pump's wire-to-water efficiency -- held -/
  etaP : ℝ := 0.25
  /-- the pump motor's standing draw, W -- held: `pumpElec`'s honesty note -/
  Pidle : ℝ := 8.0
  /-- the coil's absorptance -- held -/
  alphaC : ℝ := 0.9
  /-- the expansion tank, m³ -- held -/
  Vtank : ℝ := 0.001
  -- the design condition the loop's limits are read at: the sun the machine must survive, the
  -- fill temperature the tank is sized from, and the temperature the pump's viscosity is read at
  /-- the design DNI, W/m² (`film_limit_reachable`'s 900) -/
  dniMax : ℝ := 900
  /-- the cold fill, K (20 °C) -/
  Tfill : ℝ := 293.15
  /-- the temperature the pump's viscosity is read at, K (200 °C) -/
  Tref : ℝ := 473.15

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
  /-- the two motor rates as rad/s of the dish (`azFull`, `elFull`) -/
  azFullM : ℝ
  elFullM : ℝ
  /-- the loop (14, 15; HashemiOil.lean): the coil's surface and bore, the run's bore and length,
  the pump's full flow, efficiency and standing draw, the coil's absorptance, the tank -/
  Ac : ℝ
  Dc : ℝ
  Dp : ℝ
  Lp : ℝ
  Qmax : ℝ
  etaP : ℝ
  Pidle : ℝ
  alphaC : ℝ
  Vtank : ℝ
  /-- and what the loop's constraints are read from: the winch's own draw, the pump's electrical
  power at full flow, the coil's film coefficient there, the light the coil must survive, the
  stagnation film temperature at that light, the oil's expansion and the loop's volume -/
  trackW : ℝ
  pumpElecW : ℝ
  hCoilW : ℝ
  PinFull : ℝ
  filmStag : ℝ
  expFrac : ℝ
  Vloop : ℝ
  coilLen : ℝ

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
  -- the loop, at the design condition (HashemiOil.lean's own functions, nothing new)
  let trackW := g.W * rcm * 7.3e-5                      -- tracking_power_tiny's left side
  let pumpElecW := pumpElec g.Qmax g.Dp g.Lp g.Tref g.etaP g.Pidle
  let hCoilW := hCoil g.Qmax g.Dc oilBulkMax            -- the film coefficient at full flow
  let PinFull := g.dniMax * (2 * a) ^ 2 * g.rho         -- the light on the coil at full sun
  let filmStag := filmTemp oilBulkMax (g.alphaC * PinFull / g.Ac) hCoilW
  let coilLen := g.Ac / (Real.pi * g.Dc)
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
    Fdrive := g.Fdrive, L10 := g.L10, rho := g.rho, panelW := g.panelW, volts := g.volts,
    azFullM := g.azDeg * Real.pi / 180, elFullM := g.elDeg * Real.pi / 180,
    Ac := g.Ac, Dc := g.Dc, Dp := g.Dp, Lp := g.Lp, Qmax := g.Qmax, etaP := g.etaP,
    Pidle := g.Pidle, alphaC := g.alphaC, Vtank := g.Vtank,
    trackW := trackW, pumpElecW := pumpElecW, hCoilW := hCoilW, PinFull := PinFull,
    filmStag := filmStag,
    expFrac := expansionFrac g.Tfill oilBulkMax,
    Vloop := pipeArea g.Dp * g.Lp + g.Ac * g.Dc / 4,   -- (π Dc²/4)(Ac/(π Dc)): the π cancels
    coilLen := coilLen }

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
def SoundGeom (m : Machine) : Prop :=
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
  m.azFullM / 3 * 15 < m.budgetTan ∧ m.elFullM / 3 * 15 < m.budgetTan ∧
  m.boltStress < 1.6e8 ∧
  m.trackW ≤ 0.015 * m.panelW ∧
  m.f * m.tiltPerTurn < 0.001

/-- **the loop's constraints** (`HashemiOil.lean`), which are constraints on the same held set and
so belong in the same check.  In order: the pump fits in what the panel has left after the winch
(`PumpWithinBudget`, whose honesty note says the standing draw is "of the order of the panel
itself"); the stagnation the oil's wall sees at full sun and full flow is under the fluid's
maximum FILM temperature (`filmTemp` against `oilFilmMax` - the limit `film_limit_reachable`
proves the machine can reach); and the expansion tank holds what the oil grows by between the
cold fill and the bulk limit (`TankHolds`, `expansionFrac`). -/
def SoundLoop (m : Machine) : Prop :=
  PumpWithinBudget m.pumpElecW (m.panelW - m.trackW) ∧
  m.filmStag ≤ oilFilmMax ∧
  TankHolds m.Vtank m.Vloop m.expFrac

/-- **the whole check**: the build's constraints and the loop's -/
def Sound (m : Machine) : Prop := SoundGeom m ∧ SoundLoop m

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

/-- **`SoundGeom (derive his)`**: every constraint his file states about the BUILD, at his
machine, proved.  (The loop's three are below: two hold and one - the pump's - his 5 W panel
does not pay for, which is a finding of this file, not a licence to weaken the constraint.) -/
theorem sound_his : SoundGeom (derive his) := by
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
  · show (0.035 : ℝ) * Real.pi / 180 / 3 * 15 < (derive his).budgetTan
    rw [derive_his_budgetTan]; nlinarith [Real.pi_le_four]
  · show (0.025 : ℝ) * Real.pi / 180 / 3 * 15 < (derive his).budgetTan
    rw [derive_his_budgetTan]; nlinarith [Real.pi_le_four]
  · exact derive_his_boltStress
  · -- tracking under 1.5 % of the panel
    show (300 : ℝ) * (derive his).rcm * 7.3e-5 ≤ 0.015 * 5
    rw [hrcm]; norm_num
  · -- one turn of a rim nut
    show (derive his).f * (0.0015 / ((2 : ℝ) * 0.8)) < 0.001
    rw [derive_his_f]; norm_num

/-! ### The loop at his machine: two hold, one does not

`HashemiOil.lean`'s three constraints are constraints on the same held set, so they are checked
here.  Two of them his machine satisfies; the pump's budget it does not, and that is reported,
not weakened. -/

/-- the pump's hydraulic power is never negative, in either regime -/
theorem pumpHyd_nonneg {Q D L T : ℝ} (hQ : 0 ≤ Q) (hD : 0 < D) (hL : 0 ≤ L)
    (hT0 : 273.15 ≤ T) (hT1 : T ≤ oilBulkMax) : 0 ≤ pumpHyd Q D L T := by
  have hA : 0 < pipeArea D := pipeArea_pos hD
  have hv : 0 ≤ velOf Q D := div_nonneg hQ hA.le
  have hρ : 0 < oilRho T := oilRho_pos hT0 hT1
  have hμ : 0 < oilMu T := oilMu_pos T
  unfold pumpHyd dPipe
  split_ifs with h
  · refine mul_nonneg ?_ hQ
    unfold dpLam
    exact div_nonneg (by positivity) (by positivity)
  · refine mul_nonneg ?_ hQ
    unfold dpTurb
    have hf : 0 ≤ frictionBlasius (reynolds Q D T) := by
      unfold frictionBlasius; exact div_nonneg (by norm_num) (Real.sqrt_nonneg _)
    exact div_nonneg
      (mul_nonneg (mul_nonneg (mul_nonneg hf (div_nonneg hL hD.le)) hρ.le) (sq_nonneg _))
      (by norm_num)

/-- **his 5 W panel does not pay for a circulation pump.**  `pumpElec`'s honesty note says the
standing draw of a 12 V pump is "of the order of the panel itself", and the loop's own parameter
file puts it at 8 W - above the whole panel, before the winch has taken its 20 mW.  The
constraint is stated, the machine fails it, and `panelMin` below says by how much. -/
theorem pump_over_budget_his :
    ¬ PumpWithinBudget (derive his).pumpElecW ((derive his).panelW - (derive his).trackW) := by
  have hnn : 0 ≤ pumpHyd (6.0e-5 : ℝ) 0.012 6.0 473.15 :=
    pumpHyd_nonneg (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by unfold oilBulkMax; norm_num)
  have he : (derive his).pumpElecW = pumpHyd (6.0e-5 : ℝ) 0.012 6.0 473.15 / 0.25 + 8.0 := by
    show pumpElec (6.0e-5 : ℝ) 0.012 6.0 473.15 0.25 8.0 = _
    unfold pumpElec; rw [if_pos (by norm_num)]
  have ht : (derive his).panelW - (derive his).trackW
      = (5 : ℝ) - 300 * (1.125 * 0.8) * 7.3e-5 := rfl
  unfold PumpWithinBudget
  rw [he, ht, not_le]
  have : 0 ≤ pumpHyd (6.0e-5 : ℝ) 0.012 6.0 473.15 / 0.25 := div_nonneg hnn (by norm_num)
  norm_num; linarith

/-- **and so `Sound` does not hold at his machine**: the geometry does (`sound_his`), the loop
does not.  This is the file saying what the video's own parameters cost. -/
theorem not_sound_his : ¬ Sound (derive his) := fun h => pump_over_budget_his h.2.1

/-- **his expansion tank holds**: the loop is 0.75 litre of oil and Therminol 66 grows by 30.9 %
between the cold fill and its bulk limit, so 0.23 litre must be taken - the 1 litre tank is
enough at both sizes (the run and the coil do not scale with `a` either). -/
theorem tank_holds_his :
    TankHolds (derive his).Vtank (derive his).Vloop (derive his).expFrac := by
  have hpi := Real.pi_le_four
  have hpi0 := Real.pi_pos
  have hV0 : (derive his).Vloop = pipeArea (0.012 : ℝ) * 6.0 + (0.03 : ℝ) * 0.010 / 4 := rfl
  unfold pipeArea at hV0
  have hF0 : (derive his).expFrac = expansionFrac (293.15 : ℝ) oilBulkMax := rfl
  have hF : (derive his).expFrac = oilRho 293.15 / oilRho oilBulkMax - 1 := by
    rw [hF0]; unfold expansionFrac; rfl
  have hT : (derive his).Vtank = (0.001 : ℝ) := rfl
  -- the two densities, bounded by integers (the fill at 20 °C, the bulk cap at 345 °C)
  have hd2 : (0 : ℝ) < oilRho oilBulkMax :=
    oilRho_pos (by unfold oilBulkMax; norm_num) (le_refl _)
  have h1u : oilRho 293.15 ≤ 1009 := by unfold oilRho celsius; norm_num
  have h1l : (1008 : ℝ) ≤ oilRho 293.15 := by unfold oilRho celsius; norm_num
  have h2u : oilRho oilBulkMax ≤ 771 := by unfold oilRho celsius oilBulkMax; norm_num
  have h2l : (770 : ℝ) ≤ oilRho oilBulkMax := by unfold oilRho celsius oilBulkMax; norm_num
  -- so the expansion is between 0 and 31.1 %
  have hxu : oilRho 293.15 / oilRho oilBulkMax ≤ 1.311 := by
    rw [div_le_iff₀ hd2]; nlinarith
  have hxl : (1 : ℝ) ≤ oilRho 293.15 / oilRho oilBulkMax := by
    rw [le_div_iff₀ hd2]; nlinarith
  unfold TankHolds
  rw [hV0, hF, hT]
  nlinarith [hpi, hpi0, hxu, hxl]

/-- **his coil is too small for his own sun.**  At `a = 0.8` the reflector puts 1958 W of
sunlight on the coil at 900 W/m²; the coil absorbs 90 % of it over 0.03 m², which is 59 kW/m².
The oil's wall sits `q''/h` above the bulk, so unless the film coefficient exceeds 1958 W/m²K
the wall is over Therminol 66's 375 °C film limit at the bulk cap.  The Float twin evaluates
`hCoil` at full flow: **1173 W/m²K**, and the stagnation film temperature is 668 K against a
limit of 648 K.  `AcMin` below says the coil his own machine needs is 0.050 m², not 0.030. -/
theorem film_over_limit_his {h : ℝ} (hh : 0 < h) (hb : h ≤ 1958) :
    oilFilmMax < filmTemp oilBulkMax
      ((derive his).alphaC * (derive his).PinFull / (derive his).Ac) h := by
  have hq : (derive his).alphaC * (derive his).PinFull / (derive his).Ac = 58752 := by
    show (0.9 : ℝ) * (900 * (2 * 0.8) ^ 2 * 0.85) / 0.03 = _; norm_num
  unfold filmTemp oilFilmMax oilBulkMax
  rw [hq, ← sub_lt_iff_lt_add', lt_div_iff₀ hh]
  nlinarith

/-! ## 4. Design by constraint: the held quantities SOLVED

Every conjunct of `Sound` is an inequality in ONE held quantity that the spec does not scale.
Solved for that quantity, it is a design rule: the smallest coil the tracker allows, the coarsest
sensor the coil allows, the widest facet, the smallest panel the pump and the winch fit in, the
coil area the fluid's film limit demands, the tank the oil's expansion demands.  Each is a
definition with a theorem that the solved value satisfies the constraint BY CONSTRUCTION, and
`design` is the pointwise maximum of the held value and its floor - the minimal change to the
held set that makes the constraint hold. -/

/-- **the coil the tracker needs**: `TrackerBudget` is `f tanEps ≤ rc - spotW/2`, solved for `rc`.
The spot at `F` grows with `f` and the pointing error is `f tanEps`, so both terms scale while
his 12 cm coil does not - which is exactly why `#machine 2.0` fails. -/
noncomputable def rcMin (g : Givens) : ℝ := (derive g).spotW / 2 + (derive g).f * g.tanEps

theorem tracker_holds_of_rc {g : Givens} (h : rcMin g ≤ g.rc) :
    (derive g).f * (derive g).tanEps ≤ (derive g).margin := by
  have e1 : (derive g).margin = g.rc - (derive g).spotW / 2 := rfl
  have e2 : (derive g).tanEps = g.tanEps := rfl
  unfold rcMin at h
  rw [e1, e2]; linarith

/-- **the sensor the coil allows**, the same inequality solved for `tanEps` instead: the
alternative to a bigger coil is a better tracker, and this is how much better. -/
noncomputable def epsMax (g : Givens) : ℝ := (derive g).margin / (derive g).f

theorem tracker_holds_of_eps {g : Givens} (hf : 0 < (derive g).f) (h : g.tanEps ≤ epsMax g) :
    (derive g).f * (derive g).tanEps ≤ (derive g).margin := by
  have e2 : (derive g).tanEps = g.tanEps := rfl
  have := mul_le_mul_of_nonneg_left h hf.le
  rw [e2]
  unfold epsMax at this
  rwa [mul_div_cancel₀ _ hf.ne'] at this

/-- **the facet the coil allows**, the same inequality solved for `w`: `spotW = w + 0.0093 f`, so
smaller tiles buy margin one for one.  It can be NEGATIVE - at `a = 2` the pointing term
`f tanEps = 0.075` already exceeds the 12 cm coil's radius, so no facet, however fine, puts the
beam inside it.  That is the lever going dead, and the table says so. -/
noncomputable def wMax (g : Givens) : ℝ :=
  2 * (g.rc - (derive g).f * g.tanEps) - (derive g).f * 0.0093

theorem tracker_holds_of_w {g : Givens} (h : g.w ≤ wMax g) :
    (derive g).f * (derive g).tanEps ≤ (derive g).margin := by
  have e1 : (derive g).margin = g.rc - (derive g).spotW / 2 := rfl
  have e2 : (derive g).tanEps = g.tanEps := rfl
  have e3 : (derive g).spotW = g.w + (derive g).f * 0.0093 := rfl
  unfold wMax at h
  rw [e1, e2, e3]; linarith

/-- **the panel the loop needs**: `PumpWithinBudget` with the winch's own draw taken out first,
solved for the panel. -/
noncomputable def panelMin (g : Givens) : ℝ := (derive g).pumpElecW + (derive g).trackW

theorem pump_holds_of_panel {g : Givens} (h : panelMin g ≤ g.panelW) :
    PumpWithinBudget (derive g).pumpElecW ((derive g).panelW - (derive g).trackW) := by
  have e : (derive g).panelW = g.panelW := rfl
  unfold PumpWithinBudget panelMin at *
  rw [e]; linarith

/-- **the coil the fluid needs**: the film limit `Tbulk + α Pin / (Ac h) ≤ oilFilmMax` at the
bulk cap and the design sun, solved for the coil's area.  The 30 K between `oilBulkMax` and
`oilFilmMax` is the whole allowance, which is why the area it demands is large. -/
noncomputable def AcMin (g : Givens) : ℝ :=
  g.alphaC * (derive g).PinFull / ((derive g).hCoilW * (oilFilmMax - oilBulkMax))

/-- and the tube that carries it, `Ac = π Dc L` -/
noncomputable def coilLenMin (g : Givens) : ℝ := AcMin g / (Real.pi * g.Dc)

theorem coilLenMin_area {g : Givens} (hD : 0 < g.Dc) :
    Real.pi * g.Dc * coilLenMin g = AcMin g := by
  unfold coilLenMin
  field_simp

theorem film_holds_of_Ac {g : Givens} (hh : 0 < (derive g).hCoilW)
    (hq : 0 ≤ g.alphaC * (derive g).PinFull) (hA0 : 0 < g.Ac) (hA : AcMin g ≤ g.Ac) :
    (derive g).filmStag ≤ oilFilmMax := by
  have e : (derive g).filmStag
      = filmTemp oilBulkMax (g.alphaC * (derive g).PinFull / g.Ac) (derive g).hCoilW := rfl
  have h30 : (0 : ℝ) < oilFilmMax - oilBulkMax := by unfold oilFilmMax oilBulkMax; norm_num
  unfold AcMin at hA
  rw [div_le_iff₀ (by positivity)] at hA
  rw [e]
  unfold filmTemp
  rw [div_div, ← sub_nonneg]
  have : g.alphaC * (derive g).PinFull / (g.Ac * (derive g).hCoilW) ≤ oilFilmMax - oilBulkMax := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  linarith

/-- and its converse, the finding at a coil that is too small -/
theorem film_fails_of_Ac_lt {g : Givens} (hh : 0 < (derive g).hCoilW)
    (hq : 0 < g.alphaC * (derive g).PinFull) (hA0 : 0 < g.Ac) (hA : g.Ac < AcMin g) :
    oilFilmMax < (derive g).filmStag := by
  have e : (derive g).filmStag
      = filmTemp oilBulkMax (g.alphaC * (derive g).PinFull / g.Ac) (derive g).hCoilW := rfl
  have h30 : (0 : ℝ) < oilFilmMax - oilBulkMax := by unfold oilFilmMax oilBulkMax; norm_num
  unfold AcMin at hA
  rw [lt_div_iff₀ (by positivity)] at hA
  rw [e]
  unfold filmTemp
  have : oilFilmMax - oilBulkMax
      < g.alphaC * (derive g).PinFull / (g.Ac * (derive g).hCoilW) := by
    rw [lt_div_iff₀ (by positivity)]
    nlinarith
  rw [div_div]
  linarith

/-- **the tank the oil needs**: `TankHolds`, solved for the tank -/
noncomputable def tankMin (g : Givens) : ℝ := (derive g).Vloop * (derive g).expFrac

theorem tank_holds_of_tank {g : Givens} (h : tankMin g ≤ g.Vtank) :
    TankHolds (derive g).Vtank (derive g).Vloop (derive g).expFrac := h

/-- **the design**: the minimal change to the held set that makes the constraints that name a
held quantity hold at this size.  Each floor depends only on quantities `design` does not move
(the coil's floor on `w`, `f` and the sensor; the panel's on the pump and the winch; the coil
area's on the sun and the flow), so one pass is a fixed point - except the tank, which is sized
from the loop's volume and so is set after the coil. -/
noncomputable def design (g : Givens) : Givens :=
  let g₁ : Givens := { g with rc := max g.rc (rcMin g), panelW := max g.panelW (panelMin g),
                              Ac := max g.Ac (AcMin g) }
  { g₁ with Vtank := max g₁.Vtank (tankMin g₁) }

theorem design_a (g : Givens) : (design g).a = g.a := rfl

/-- **the designed machine meets the tracker's budget**, by construction -/
theorem design_tracker (g : Givens) :
    (derive (design g)).f * (derive (design g)).tanEps ≤ (derive (design g)).margin :=
  tracker_holds_of_rc (le_max_right _ _)

/-- **and the pump's budget** -/
theorem design_pump (g : Givens) :
    PumpWithinBudget (derive (design g)).pumpElecW
      ((derive (design g)).panelW - (derive (design g)).trackW) :=
  pump_holds_of_panel (le_max_right _ _)

/-- **and the film limit**, given a film coefficient and a sun -/
theorem design_film {g : Givens} (hh : 0 < (derive g).hCoilW)
    (hq : 0 < g.alphaC * (derive g).PinFull) (hA0 : 0 < g.Ac) :
    (derive (design g)).filmStag ≤ oilFilmMax :=
  film_holds_of_Ac hh hq.le (lt_of_lt_of_le hA0 (le_max_left _ _)) (le_max_right _ _)

/-- **and the tank** -/
theorem design_tank (g : Givens) :
    TankHolds (derive (design g)).Vtank (derive (design g)).Vloop (derive (design g)).expFrac :=
  tank_holds_of_tank (le_max_right _ _)

/-! ## 5. The Float twin, the command, and the exe

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
  azDeg : Float := 0.035
  elDeg : Float := 0.025
  Ac : Float := 0.03
  Dc : Float := 0.010
  Dp : Float := 0.012
  Lp : Float := 6.0
  Qmax : Float := 6.0e-5
  etaP : Float := 0.25
  Pidle : Float := 8.0
  alphaC : Float := 0.9
  Vtank : Float := 0.001
  dniMax : Float := 900
  Tfill : Float := 293.15
  Tref : Float := 473.15

/-! ### The loop's correlations in Float, line for line with `HashemiOil.lean` -/

def piF : Float := 3.14159265358979323846
def oilBulkMaxF : Float := 618.15
def oilFilmMaxF : Float := 648.15

def oilRhoF (T : Float) : Float := let c := T - 273.15; 1020.62 - 0.614254 * c - 0.000321 * c * c
def oilCpF (T : Float) : Float :=
  let c := T - 273.15; 1000 * (1.496005 + 0.003313 * c + 0.0000008970757 * c * c)
def oilKF (T : Float) : Float :=
  let c := T - 273.15; 0.118294 - 0.000033 * c - 0.00000015 * c * c
def oilMuF (T : Float) : Float := Float.exp (586.375 / (T - 273.15 + 62.5) - 2.2809) / 1000

def pipeAreaF (D : Float) : Float := piF * D * D / 4
def velOfF (Q D : Float) : Float := Q / pipeAreaF D
def reynoldsF (Q D T : Float) : Float := oilRhoF T * velOfF Q D * D / oilMuF T

/-- `dPipe`'s two branches, `pumpHyd`, `pumpElec` (the standing draw whenever the pump turns) -/
def pumpElecF (Q D L T η Pidle : Float) : Float :=
  let v := velOfF Q D
  let Re := reynoldsF Q D T
  let dP := if Re < 2300 then 32 * oilMuF T * L * v / (D * D)
            else (0.3164 / Float.sqrt (Float.sqrt (max Re 1))) * (L / D) * oilRhoF T * v * v / 2
  dP * Q / η + (if 0 < Q then Pidle else 0)

/-- `hCoil`: `Nu k / D`, laminar `48/11` or Dittus-Boelter -/
def hCoilF (Q D T : Float) : Float :=
  let Re := reynoldsF Q D T
  let Pr := oilMuF T * oilCpF T / oilKF T
  let Nu := if Re < 2300 then 4.364
            else 0.023 * Float.exp (0.8 * Float.log (max Re 1))
                       * Float.exp (0.4 * Float.log (max Pr 0.01))
  Nu * oilKF T / D

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
  -- the loop at the design condition (HashemiOil.lean's functions, in Float)
  let trackW := g.W * rcm * 7.3e-5
  let pumpElecW := pumpElecF g.Qmax g.Dp g.Lp g.Tref g.etaP g.Pidle
  let hCoilW := hCoilF g.Qmax g.Dc oilBulkMaxF
  let PinFull := g.dniMax * (2 * a) * (2 * a) * g.rho
  let filmStag := oilBulkMaxF + g.alphaC * PinFull / g.Ac / hCoilW
  let expFrac := oilRhoF g.Tfill / oilRhoF oilBulkMaxF - 1
  let Vloop := pipeAreaF g.Dp * g.Lp + g.Ac * g.Dc / 4
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
    ("volts", g.volts),
    ("azFullM", g.azDeg * piF / 180), ("elFullM", g.elDeg * piF / 180),
    ("Ac", g.Ac), ("Dc", g.Dc), ("Dp", g.Dp), ("Lp", g.Lp), ("Qmax", g.Qmax),
    ("etaP", g.etaP), ("Pidle", g.Pidle), ("alphaC", g.alphaC), ("Vtank", g.Vtank),
    ("coilLen", g.Ac / (piF * g.Dc)),
    ("trackW", trackW), ("pumpElecW", pumpElecW), ("hCoilW", hCoilW), ("PinFull", PinFull),
    ("filmStag", filmStag), ("expFrac", expFrac), ("Vloop", Vloop),
    ("tanEpsDeg", Float.atan g.tanEps * 180.0 / piF)]

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

/-- a verdict on a constraint the file states with `≤`: two sides that agree to within `1e-9`
of their scale SATISFY it, so this one reports `holds` there rather than `undecided` -/
def verdictLe (lhs rhs : Float) : String :=
  let s := max 1.0 (max lhs.abs rhs.abs)
  if (rhs - lhs).abs ≤ 1e-9 * s then "holds" else if lhs < rhs then "holds" else "FAILS"

/-- **`Sound`, conjunct by conjunct, as `lhs < rhs`**: the same fifteen, in the same order, and
then `ReachesVertical` - which `wire_short_of_vertical` says HIS machine fails, so it is reported
apart, as the file reports it -/
def checksF (m : Array (String × Float)) : Array (String × Float × Float × String) :=
  let g := fieldOf m
  let row (n : String) (lhs rhs : Float) := (n, lhs, rhs, verdict lhs rhs)
  -- the conjuncts `Sound` states with `≤` rather than `<`: equality satisfies them, so the
  -- machine `design` puts exactly on the line is reported `holds`, not `undecided`
  let rowLe (n : String) (lhs rhs : Float) := (n, lhs, rhs, verdictLe lhs rhs)
  #[row "positive_a" 0 (g "a"),
    row "dish_between_posts" (g "side") (g "chord"),
    row "MastClears" (g "FC") (g "ym"),
    row "clearance" 0 (g "clearance"),
    row "dish_swings_to_vertical" (g "a") (g "postH"),
    row "HangerClearsPost" (0.010 / 2) 0.010,
    row "rod_sets_hanger" (g "hanger") (g "rodLen"),
    rowLe "HoldsDish" (g "W" * g "rcm") (g "Tmax" * g "armRest"),
    row "sixty_reachable" (0.8660254038 * (g "ym" * g "a" - g "hp" * g "ze"))
      (0.5 * (g "ym" * g "ze" + g "hp" * g "a")),
    row "coil_covers_facet" (g "spotW" / 2) (g "rc"),
    rowLe "TrackerBudget" (g "f" * g "tanEps") (g "margin"),
    row "quantum_within_budget_az" (g "azFullM" / 3 * 15) (g "budgetTan"),
    row "quantum_within_budget_el" (g "elFullM" / 3 * 15) (g "budgetTan"),
    row "m12_carries_dish" (g "boltStress") 1.6e8,
    rowLe "tracking_power_tiny" (g "trackW") (0.015 * g "panelW"),
    row "one_turn_tilt" (g "f" * g "tiltPerTurn") 0.001,
    -- the loop (HashemiOil.lean): the pump in the panel, the film under the fluid's limit, the tank
    rowLe "PumpWithinBudget" (g "pumpElecW") (g "panelW" - g "trackW"),
    rowLe "FilmLimit" (g "filmStag") oilFilmMaxF,
    rowLe "TankHolds" (g "Vloop" * g "expFrac") (g "Vtank"),
    row "ReachesVertical (not in Sound: wire_short_of_vertical)"
      (g "ym" * g "a") (g "hp" * g "ze")]

/-! ### `solve` in Float: the held quantity each constraint names, and the design

The same definitions as §4, on the derived table.  `designF` is `design`: the pointwise maximum
of the held value and the floor its constraint gives, the coil first and the tank after it. -/

def rcMinF (m : Array (String × Float)) : Float := fieldOf m "spotW" / 2 + fieldOf m "f" * fieldOf m "tanEps"
def epsMaxF (m : Array (String × Float)) : Float := fieldOf m "margin" / fieldOf m "f"
def wMaxF (m : Array (String × Float)) : Float :=
  2 * (fieldOf m "rc" - fieldOf m "f" * fieldOf m "tanEps") - fieldOf m "f" * 0.0093
def panelMinF (m : Array (String × Float)) : Float := fieldOf m "pumpElecW" + fieldOf m "trackW"
def AcMinF (m : Array (String × Float)) : Float :=
  fieldOf m "alphaC" * fieldOf m "PinFull" / (fieldOf m "hCoilW" * (oilFilmMaxF - oilBulkMaxF))
def coilLenMinF (m : Array (String × Float)) : Float := AcMinF m / (piF * fieldOf m "Dc")
def tankMinF (m : Array (String × Float)) : Float := fieldOf m "Vloop" * fieldOf m "expFrac"

/-- **the designed givens**: the held set with every floor applied -/
def designF (g : GivensF) : GivensF :=
  let m := deriveF g
  let g₁ : GivensF := { g with rc := max g.rc (rcMinF m),
                               panelW := max g.panelW (panelMinF m),
                               Ac := max g.Ac (AcMinF m) }
  { g₁ with Vtank := max g₁.Vtank (tankMinF (deriveF g₁)) }

/-- the held quantities `#machine ... with ...` can override -/
def knownHeld : Array String :=
  #["a", "w", "rc", "tanEps", "panelW", "volts", "W", "Tmax", "rho", "azDeg", "elDeg",
    "Ac", "Dc", "Dp", "Lp", "Qmax", "etaP", "Pidle", "alphaC", "Vtank", "dniMax", "Tfill", "Tref"]

def applyOv (g : GivensF) (os : Array (String × Float)) : GivensF :=
  os.foldl (fun g p =>
    match p.1 with
    | "a" => { g with a := p.2 }        | "w" => { g with w := p.2 }
    | "rc" => { g with rc := p.2 }      | "tanEps" => { g with tanEps := p.2 }
    | "panelW" => { g with panelW := p.2 } | "volts" => { g with volts := p.2 }
    | "W" => { g with W := p.2 }        | "Tmax" => { g with Tmax := p.2 }
    | "rho" => { g with rho := p.2 }    | "azDeg" => { g with azDeg := p.2 }
    | "elDeg" => { g with elDeg := p.2 } | "Ac" => { g with Ac := p.2 }
    | "Dc" => { g with Dc := p.2 }      | "Dp" => { g with Dp := p.2 }
    | "Lp" => { g with Lp := p.2 }      | "Qmax" => { g with Qmax := p.2 }
    | "etaP" => { g with etaP := p.2 }  | "Pidle" => { g with Pidle := p.2 }
    | "alphaC" => { g with alphaC := p.2 } | "Vtank" => { g with Vtank := p.2 }
    | "dniMax" => { g with dniMax := p.2 } | "Tfill" => { g with Tfill := p.2 }
    | "Tref" => { g with Tref := p.2 }  | _ => g) g

/-- **the design table**: per held quantity, the value his spec gives, the value the constraint
demands at this size, and which constraint demanded it.  Only the ones that had to move. -/
def designRows (g : GivensF) : Array (String × Float × Float × String) :=
  let d := designF g
  (#[("rc", g.rc, d.rc, "TrackerBudget"), ("panelW", g.panelW, d.panelW, "PumpWithinBudget"),
     ("Ac", g.Ac, d.Ac, "FilmLimit"), ("Vtank", g.Vtank, d.Vtank, "TankHolds")] :
     Array (String × Float × Float × String)).filter (fun r => r.2.1 < r.2.2.1)

/-- the derived table and the verdicts, for any givens -/
def reportG (title : String) (g : GivensF) : String :=
  let m := deriveF g
  let rows := m.foldl (fun s p => s ++ s!"  {p.1.pushn ' ' (if p.1.length < 16 then 16 - p.1.length else 0)} {p.2}\n") ""
  let ok := (checksF m).foldl (fun n r => if r.2.2.2 == "holds" then n + 1 else n) 0
  let ver := (checksF m).foldl
    (fun s r => s ++ s!"  {r.1.pushn ' ' (if r.1.length < 46 then 46 - r.1.length else 0)} {r.2.2.2}   {r.2.1} < {r.2.2.1}\n") ""
  s!"{title}\n{rows}\n  constraints ({ok} of {(checksF m).size} hold):\n{ver}"

/-- the report: the derived table, then the verdicts -/
def report (a : Float) : String := reportG s!"#machine {a}" { a := a }

/-- **the design report**: what had to change, what it costs, and the alternatives the same
inequality offers - the sensor the coil allows and the facet it allows, which is the other way to
buy the tracker's budget - followed by the designed machine's own verdicts. -/
def designReport (g : GivensF) (title : String) : String :=
  let m := deriveF g
  let d := designF g
  let tbl := (designRows g).foldl
    (fun s r => s ++ s!"  {r.1.pushn ' ' (if r.1.length < 10 then 10 - r.1.length else 0)} {r.2.1} -> {r.2.2.1}   ({r.2.2.2})\n") ""
  let tbl := if tbl.isEmpty then "  (nothing had to change: the held set is already sound here)\n" else tbl
  let epsDeg := Float.atan (epsMaxF m) * 180.0 / piF
  let hisDeg := Float.atan (fieldOf m "tanEps") * 180.0 / piF
  let hisW := fieldOf m "w"
  let dc := fieldOf m "Dc"
  let alt :=
    s!"  the same budget, the other way: the sensor the coil allows is tanEps <= {epsMaxF m} " ++
    s!"({epsDeg} deg, his is {hisDeg}); " ++
    s!"the facet it allows is w <= {wMaxF m} (his is {hisW})\n" ++
    s!"  the coil the film limit demands is {AcMinF m} m2 = {coilLenMinF m} m of {dc} m tube\n"
  s!"{title}\n  held -> designed:\n{tbl}{alt}\n" ++ reportG "  the designed machine:" d

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

/-- one `held := value` override -/
syntax heldOv := ident " := " term

/-- the overrides of a `with` clause, checked against `knownHeld` -/
def ovsOf (ss : Array Syntax) : CommandElabM (Array (String × Float)) := do
  let mut os : Array (String × Float) := #[]
  for s in ss do
    let n := s[0].getId.toString
    unless knownHeld.contains n do
      throwError s!"{n} is not a held quantity; the held set is {knownHeld}"
    match floatOfSyntax s[2] with
    | some v => os := os.push (n, v)
    | none => throwError s!"{n} := ... takes a numeral"
  return os

/-- **`#machine 2.0 with rc := 0.10, panelW := 13`**: the same table and verdicts with some of
the held set replaced by hand - the what-if beside the solved design -/
elab "#machine " t:term " with " ovs:heldOv,+ : command => do
  match floatOfSyntax t with
  | none => throwError "#machine takes a numeral, e.g. #machine 2.0"
  | some a =>
    let os ← ovsOf (ovs.getElems.map (·.raw))
    logInfo (reportG s!"#machine {a} with {os.map (fun p => s!"{p.1} := {p.2}")}" (applyOv { a := a } os))

/-- **`#design 2.0`**: the minimal changes to the held set that make `Sound` hold at that size -/
elab "#design " t:term : command => do
  match floatOfSyntax t with
  | some a => logInfo (designReport { a := a } s!"#design {a}")
  | none => throwError "#design takes a numeral, e.g. #design 2.0"

/-- the JSON the runtime reads: the kernel's optics inputs (`R f a w rc`), the mount parameters
(`megaParams`: `rDrum W rcm Tmax rho Fdrive L10 rodLen`), the build's dimensions, and the
verdicts, so the env can refuse a machine the spec says is unsound -/
def machineJsonG (a : Float) (g₀ : GivensF) (designed : Bool) (changes : Array (String × Float × Float × String)) : String :=
  let m := deriveF g₀
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
  -- the loop's inputs, under the names `hashemi_env_kernel.py`'s LOOP_PARAMS uses
  let loop := #[s!"    {quote "Ac"}: {g "Ac"}", s!"    {quote "Qmax"}: {g "Qmax"}",
    s!"    {quote "Dp"}: {g "Dp"}", s!"    {quote "Lp"}: {g "Lp"}",
    s!"    {quote "etaP"}: {g "etaP"}", s!"    {quote "Pidle"}: {g "Pidle"}",
    s!"    {quote "alpha"}: {g "alphaC"}", s!"    {quote "Dc"}: {g "Dc"}",
    s!"    {quote "coilLen"}: {g "coilLen"}", s!"    {quote "Vtank"}: {g "Vtank"}",
    s!"    {quote "panelW"}: {g "panelW"}", s!"    {quote "hCoilW"}: {g "hCoilW"}",
    s!"    {quote "PinFull"}: {g "PinFull"}", s!"    {quote "filmStag"}: {g "filmStag"}"]
  let ch := changes.foldl (fun acc r =>
    acc.push ("    {" ++ s!"{quote "held"}: {quote r.1}, {quote "from"}: {r.2.1}, " ++
              s!"{quote "to"}: {r.2.2.1}, {quote "constraint"}: {quote r.2.2.2}" ++ "}")) #[]
  "{\n  \"source\": \"RequestProject/HashemiScale.lean: derive, from Hashemi.lean's own relationships\",\n" ++
  s!"  \"a\": {a},\n" ++
  s!"  \"designed\": {designed},\n" ++
  "  \"kernel\": {\n" ++ String.intercalate ",\n" kern.toList ++ "\n  },\n" ++
  "  \"mount\": {\n" ++ String.intercalate ",\n" mount.toList ++ "\n  },\n" ++
  "  \"loop\": {\n" ++ String.intercalate ",\n" loop.toList ++ "\n  },\n" ++
  "  \"design_changes\": [\n" ++ String.intercalate ",\n" ch.toList ++ "\n  ],\n" ++
  "  \"machine\": {\n" ++ String.intercalate ",\n" pairs.toList ++ "\n  },\n" ++
  "  \"constraints\": {\n" ++ String.intercalate ",\n" chk.toList ++ "\n  },\n" ++
  "  \"not_required\": {\n" ++ String.intercalate ",\n" rest.toList ++ "\n  }\n}\n"

/-- the held machine at `a` -/
def machineJson (a : Float) : String := machineJsonG a { a := a } false #[]

/-- **the designed machine at `a`**, with the held changes recorded in it -/
def machineJsonDesigned (a : Float) : String :=
  machineJsonG a (designF { a := a }) true (designRows { a := a })

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

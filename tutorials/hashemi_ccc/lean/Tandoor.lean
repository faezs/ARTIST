/-
# The oven, as the parent env has it

His concentrator does not stand on an empty grid.  It stands on the roof of a building whose
ground floor holds the tandoor it feeds, and until now the oven existed only in the parent
Python env — so the picture showed a machine with nothing to cook in.  This file is the oven's
geometry as definitions of the same specification the machine is written in, so that the scene
draws both machines out of ONE compiled morphism.

**Every number below is the parent's, cited.**  The pit is a *spherical section*, not a cylinder:
the clay urn is the sphere through the coal-bed floor (radius `rPot` at the bottom) and the cook's
mouth (`rMouth` at the top), which is how `tandoor_polar_env.py` builds it and how
`tandoor_hashemi_env.py` draws it.

| definition | value | source |
|---|---|---|
| `rPot` | 0.42 m | `tutorials/tandoor_polar_env.py:56` (`R_POT`, the coal-bed FLOOR radius) |
| `hPot` | 1.00 m | `tutorials/tandoor_polar_env.py:57` (`H_POT`, the mouth's height in the world frame) |
| `rMouth` | 0.26 m | `tutorials/tandoor_polar_env.py:58` (`R_MOUTH`, the cook's opening) |
| `rDuctNative` | 0.14 m | `tutorials/tandoor_polar_env.py:59` (`R_DUCT`, the native air inlet) |
| `zDuctPot` | -0.86 m | `tutorials/tandoor_polar_env.py:60` (`Z_DUCT`, the duct's centre in the mouth frame) |
| `hDepth` | 2.44 m | `tutorials/tandoor_polar_env.py:66` (`H_DEPTH`) |
| `zCPot` | derived | `tutorials/tandoor_polar_env.py:67` (`Z_CPOT`, the sphere's centre) |
| `rSph` | derived | `tutorials/tandoor_polar_env.py:68` (`R_SPH = hypot(R_MOUTH, Z_CPOT)`) |
| `zCrown` | -0.22 m | `tutorials/tandoor_polar_env.py:69` (`Z_CROWN`) |
| `zHearth` | -2.32 m | `tutorials/tandoor_polar_env.py:70` (`Z_HEARTH = -H_DEPTH + 0.12`) |
| `zBakeLo` | -0.85 m | `tutorials/tandoor_polar_env.py:74` (`Z_BAKE_LO`) |
| `rDuctWall` | derived | `tutorials/tandoor_polar_env.py:87` (`R_DUCT_WALL`) |
| `xChase` | 1.25 m | `tutorials/tandoor_coude_optics.py:36` (`X_CHASE`, the bore's centreline) |
| `rDuctBuilt` | 0.20 m | `tutorials/tandoor_coude_optics.py:38` (`R_DUCT_C`, the widened inlet) |
| `zRoof` | 3.60 m | `tutorials/tandoor_coude_optics.py:40` (`Z_ROOF`; `tandoor_hashemi_env.py:1974` `z_deck`) |
| `nBelt` | 8 | `tutorials/tandoor_rl_env.py:213` (`self.n_belt`) |
| `rHearth` | 0.28 m | `tutorials/tandoor_rl_env.py:484` (`a_hearth = π 0.28²`, the beam's footprint on the bed) |
| `breadArea` | 0.05 m² | `tutorials/tandoor_rl_env.py:135,161` (`bread_area`, one roti's face) |
| `zRoti` | -0.55 m | `tutorials/tandoor_hashemi_env.py:4389` (`z_br`, arm's reach into the pit) |
| `rotiHug` | 0.955 | `tutorials/tandoor_hashemi_env.py:4390` (the loaf pressed on the clay) |
| `deckHalf` | 5.7 m | `tutorials/tandoor_hashemi_env.py:4279` (`BX0/BX1/BYy` about `X_TOWER`) |
| `parapet` | 0.35 m | `tutorials/tandoor_hashemi_env.py:4284` (`Z_ROOF + 0.35`) |

The bands are the thermal nodes' own (`tutorials/tandoor_rl_env.py:481-497`, over
`_pot_sphere` = `(R_SPH, Z_CPOT, H_DEPTH, Z_CROWN, Z_HEARTH, Z_BAKE_LO)`,
`tutorials/tandoor_polar_env.py:214`): **crown** `zCrown..0`, the **belt** the bread is slapped on
`zBakeLo..zCrown` cut into `nBelt` slots, the **lower** band `zHearth..zBakeLo` (the four extra
nodes, `N_LOWER`), the **floor** below `zHearth` plus the bed disc, and the **hearth** — the tiny
beam footprint carved out of the bed.  The slots' angles are the binning code's own,
`a₀ = -π + 2π k / nBelt` with the mid-angle half a slot along
(`tutorials/tandoor_hashemi_env.py:4367,4381`), and the render's map from the bin frame into the
world, `(x, y) = (-sin θ, cos θ) · r` (`tutorials/tandoor_hashemi_env.py:4363-4374`), is the one
used here.

**What the parent does not state, and this file therefore chooses** (each said once, here):

1. *Where his machine stands.*  The parent never places his concentrator in its world — it is a
   different receiver for the same pot.  This file stands it **over the chase**: the roof frame's
   origin is the carriage's tube on the deck, at the parent's `X_TOWER = X_CHASE`, so his beam
   goes straight down the bore the coudé machine already uses.  That fixes the oven's offset,
   `xPotRoof`, and nothing else.
2. *The roti's shape.*  The parent gives a roti an AREA (`bread_area`) and the render draws a
   disc of a radius of its own (`0.085 + 0.02 fr`, `tandoor_hashemi_env.py:4397`).  A scene needs
   corners, so this file draws the square of the parent's area, `√breadArea` on a side.
3. *The ring stations* (`jr` of twenty-four, `jz` of five, …) are the drawing's own conventions,
   bound to literals by the scene exactly as `sg = ±1` always was.
4. *The coil's radial standoff* (`1.06`): the oil exchanger is buried in the wall behind the
   belt, and the drawing puts it just outside the clay so it is visible.  The parent states which
   SLOTS it heats (`oil_nodes`, `hashemi_ccc/hashemi_tandoor_env.py:115`), not a radius.
-/
import Mathlib

namespace TandoorHashemi

open Real

/-! ## 1. The oven's dimensions -/

/-- the coal-bed floor's radius (`R_POT`) -/
noncomputable def rPot : ℝ := 0.42
/-- the mouth's height in the parent's world frame (`H_POT`) -/
noncomputable def hPot : ℝ := 1.00
/-- the cook's opening (`R_MOUTH`) -/
noncomputable def rMouth : ℝ := 0.26
/-- the native air-inlet hole (`R_DUCT`) -/
noncomputable def rDuctNative : ℝ := 0.14
/-- the widened inlet the machine's beam passes (`R_DUCT_C`) -/
noncomputable def rDuctBuilt : ℝ := 0.20
/-- the duct's centre, in the mouth frame (`Z_DUCT`) -/
noncomputable def zDuctPot : ℝ := -0.86
/-- the pit's depth below the mouth (`H_DEPTH`) -/
noncomputable def hDepth : ℝ := 2.44
/-- the crown band's lower edge (`Z_CROWN`) -/
noncomputable def zCrown : ℝ := -0.22
/-- the hearth band's upper edge (`Z_HEARTH = -H_DEPTH + 0.12`) -/
noncomputable def zHearth : ℝ := -hDepth + 0.12
/-- the baking band's lower edge (`Z_BAKE_LO`) -/
noncomputable def zBakeLo : ℝ := -0.85
/-- the chase's centreline in the parent's world (`X_CHASE`) -/
noncomputable def xChase : ℝ := 1.25
/-- the roof deck over the pot floor (`Z_ROOF`, the env's `z_deck`) -/
noncomputable def zRoof : ℝ := 3.60
/-- the parapet over the deck -/
noncomputable def parapet : ℝ := 0.35
/-- half the deck's side -/
noncomputable def deckHalf : ℝ := 5.7
/-- the belt's slots (`n_belt`) -/
noncomputable def nBelt : ℝ := 8
/-- the beam's footprint on the bed, the hearth node's own radius -/
noncomputable def rHearth : ℝ := 0.28
/-- one roti's face (`bread_area`) -/
noncomputable def breadArea : ℝ := 0.05
/-- the height a roti is slapped at, mouth frame -/
noncomputable def zRoti : ℝ := -0.55
/-- how close to the clay the render presses it -/
noncomputable def rotiHug : ℝ := 0.955

/-- **the sphere's centre** (`Z_CPOT`): the one circle through the floor and the mouth -/
noncomputable def zCPot : ℝ := (rMouth ^ 2 - rPot ^ 2 - hDepth ^ 2) / (2 * hDepth)

/-- **the sphere's radius** (`R_SPH = hypot(R_MOUTH, Z_CPOT)`) -/
noncomputable def rSph : ℝ := Real.sqrt (rMouth ^ 2 + zCPot ^ 2)

/-- **the pot's radius at a height of the mouth frame** — the render's own `r_at`
(`tandoor_hashemi_env.py:4338-4339`), floor and all -/
noncomputable def potR (z : ℝ) : ℝ := Real.sqrt (max (rSph ^ 2 - (z - zCPot) ^ 2) 1e-6)

/-- the pot's radius where the duct pierces it (`R_DUCT_WALL`) -/
noncomputable def rDuctWall : ℝ := potR zDuctPot

/-- the baking band's mid-height -/
noncomputable def zBelt : ℝ := (zBakeLo + zCrown) / 2

/-! ## 2. The frame: the oven under the machine's own deck

The machine's scene works in the roof frame — x north, y east, z up from the deck, the origin at
the carriage's tube (`HashemiSceneInst.roofOfCarriage`).  The oven is written in the parent's
**mouth frame**: the origin at the centre of the cook's opening, on the pot's axis, z up.  One
translation carries the second into the first.  The deck is z = 0 and the oven is below it. -/

/-- the deck over the mouth: `z_deck - H_POT`, the parent's own two heights -/
noncomputable def zMouthRoof : ℝ := hPot - zRoof

/-- the pot's axis, in the roof frame.  The duct leaves the chase at `x = xChase` and pierces the
wall at `x = rPot` (`tandoor_hashemi_env.py:4427`, `ring([R_POT, 0, Z_DUCT], …, ax="x")`), which
stands `rDuctWall` from the axis — so the axis is that much further on.  With the roof frame's
origin over the chase (this file's choice 1) the offset is a difference of the parent's numbers
and nothing else. -/
noncomputable def xPotRoof : ℝ := rPot - rDuctWall - xChase

/-- **the pot's frame to the roof** -/
noncomputable def roofOfPot (p : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![p 0 + xPotRoof, p 1, p 2 + zMouthRoof]

/-! ## 3. The oven's points -/

/-- a point of the pot's wall at the bin angle `th` and the height `z`, in the mouth frame.
The map from the binning code's frame into the drawing's is the render's own,
`(x, y) = (-sin θ, cos θ) · r`. -/
noncomputable def potWallPt (z th : ℝ) : Fin 3 → ℝ :=
  ![-(potR z) * Real.sin th, potR z * Real.cos th, z]

/-- station `jr` of twenty-four around the wall at the height `z` -/
noncomputable def potRingPt (z jr : ℝ) : Fin 3 → ℝ := potWallPt z (2 * Real.pi * jr / 24)

/-- the mouth ring: `jr` of twenty-four at z = 0 -/
noncomputable def mouthPt (jr : ℝ) : Fin 3 → ℝ := potRingPt 0 jr
/-- the crown band's lower rim -/
noncomputable def crownPt (jr : ℝ) : Fin 3 → ℝ := potRingPt zCrown jr
/-- the baking band's lower rim -/
noncomputable def beltLoPt (jr : ℝ) : Fin 3 → ℝ := potRingPt zBakeLo jr
/-- the lower band's floor rim -/
noncomputable def hearthBandPt (jr : ℝ) : Fin 3 → ℝ := potRingPt zHearth jr

/-- the coal-bed floor circle, `jr` of twenty-four at the pit's bottom -/
noncomputable def floorPt (jr : ℝ) : Fin 3 → ℝ :=
  ![rPot * Real.cos (2 * Real.pi * jr / 24), rPot * Real.sin (2 * Real.pi * jr / 24), -hDepth]

/-- the hearth: the beam's own footprint on the bed -/
noncomputable def hearthPt (jr : ℝ) : Fin 3 → ℝ :=
  ![rHearth * Real.cos (2 * Real.pi * jr / 24), rHearth * Real.sin (2 * Real.pi * jr / 24),
    -hDepth + 0.03]

/-- station `jz` of five down a meridian `jth` of four, from the mouth to the floor -/
noncomputable def potMeridPt (jth jz : ℝ) : Fin 3 → ℝ :=
  potWallPt (-hDepth * jz / 5) (2 * Real.pi * jth / 4)

/-! ### The belt's slots, and the bread on them -/

/-- the leading edge of slot `ks` — the binning code's `a₀ = -π + 2π k / n_belt` -/
noncomputable def slotEdge (ks : ℝ) : ℝ := -Real.pi + 2 * Real.pi * ks / nBelt

/-- the mid-angle of slot `ks`, half a slot along -/
noncomputable def slotAngle (ks : ℝ) : ℝ := slotEdge ks + Real.pi / nBelt

/-- the centre of slot `ks`: on the pot's wall, at the baking band's mid-height -/
noncomputable def slotCentrePt (ks : ℝ) : Fin 3 → ℝ := potWallPt zBelt (slotAngle ks)

/-- half the side of the roti's square: the parent's own `bread_area` -/
noncomputable def rotiHalf : ℝ := Real.sqrt breadArea / 2

/-- corner `(su, sv)` of the roti pressed on slot `ks`, in the mouth frame: the anchor is the
render's (`r_at(z_br) · 0.955`), the square the parent's area -/
noncomputable def rotiCornerPt (ks su sv : ℝ) : Fin 3 → ℝ :=
  ![-(potR zRoti * rotiHug) * Real.sin (slotAngle ks)
      - su * rotiHalf * Real.cos (slotAngle ks),
    potR zRoti * rotiHug * Real.cos (slotAngle ks)
      - su * rotiHalf * Real.sin (slotAngle ks),
    zRoti + sv * rotiHalf]

/-- the oil coil in the wall behind slot `ks` — which slots it heats is `oil_nodes`; the standoff
is this file's choice 4 -/
noncomputable def exchangerPt (ks : ℝ) : Fin 3 → ℝ :=
  ![-(potR zBelt * 1.06) * Real.sin (slotEdge ks), potR zBelt * 1.06 * Real.cos (slotEdge ks),
    zBelt]

/-! ## 4. The tunnel: the roof deck down to the pot

The path the beam takes when `machine_receiver = "beam"`, and the chase the oil pipes run down
when it is `"oil"`: a vertical bore from the deck at the carriage's own station to the duct's
height, and then the duct itself, horizontally into the pot's wall.  These are written in the
ROOF frame — they belong to neither machine's own. -/

/-- the bore's mouth on the deck -/
noncomputable def boreTopPt : Fin 3 → ℝ := ![0, 0, 0]

/-- the turn at the foot of the bore, at the duct's height -/
noncomputable def boreFootPt : Fin 3 → ℝ := ![0, 0, zDuctPot + zMouthRoof]

/-- where the duct pierces the pot's wall -/
noncomputable def ductMouthPt : Fin 3 → ℝ := ![rPot - xChase, 0, zDuctPot + zMouthRoof]

/-- station `jd` of twelve on the duct's mouth circle, whose axis is the duct's own -/
noncomputable def ductRingPt (jd : ℝ) : Fin 3 → ℝ :=
  ![rPot - xChase, rDuctBuilt * Real.cos (2 * Real.pi * jd / 12),
    zDuctPot + zMouthRoof + rDuctBuilt * Real.sin (2 * Real.pi * jd / 12)]

/-! ## 5. The building the machine stands on

The deck at z = 0, the parapet over it, and the ground the building rises from — which is the
mouth's own level, because the cook stands at the mouth. -/

/-- a corner of the roof deck -/
noncomputable def deckCornerPt (su sv : ℝ) : Fin 3 → ℝ := ![su * deckHalf, sv * deckHalf, 0]
/-- the same corner at the top of the parapet -/
noncomputable def parapetCornerPt (su sv : ℝ) : Fin 3 → ℝ :=
  ![su * deckHalf, sv * deckHalf, parapet]
/-- the same corner at the ground, which is the mouth's level -/
noncomputable def groundCornerPt (su sv : ℝ) : Fin 3 → ℝ :=
  ![su * deckHalf, sv * deckHalf, zMouthRoof]

/-! ## 6. What is cheap and true -/

/-- the sphere's radius squared is what `hypot` made it -/
theorem rSph_sq : rSph ^ 2 = rMouth ^ 2 + zCPot ^ 2 := by
  have h : (0 : ℝ) ≤ rMouth ^ 2 + zCPot ^ 2 := by positivity
  exact Real.sq_sqrt h

/-- **the sphere passes through the cook's mouth**: at z = 0 the pot's radius is `R_MOUTH` -/
theorem potR_mouth : potR 0 = rMouth := by
  have hx : rSph ^ 2 - ((0 : ℝ) - zCPot) ^ 2 = rMouth ^ 2 := by rw [rSph_sq]; ring
  have hm : max (rSph ^ 2 - ((0 : ℝ) - zCPot) ^ 2) 1e-6 = rMouth ^ 2 := by
    rw [hx]
    have : (1e-6 : ℝ) ≤ rMouth ^ 2 := by rw [rMouth]; norm_num
    exact max_eq_left this
  show Real.sqrt (max (rSph ^ 2 - ((0 : ℝ) - zCPot) ^ 2) 1e-6) = rMouth
  rw [hm]
  exact Real.sqrt_sq (by rw [rMouth]; norm_num)

/-- **the sphere passes through the coal bed**: at the pit's bottom the radius is `R_POT` -/
theorem potR_floor : potR (-hDepth) = rPot := by
  have hx : rSph ^ 2 - (-hDepth - zCPot) ^ 2 = rPot ^ 2 := by
    rw [rSph_sq, zCPot, hDepth, rMouth, rPot]
    norm_num
  have hm : max (rSph ^ 2 - (-hDepth - zCPot) ^ 2) 1e-6 = rPot ^ 2 := by
    rw [hx]
    have : (1e-6 : ℝ) ≤ rPot ^ 2 := by rw [rPot]; norm_num
    exact max_eq_left this
  show Real.sqrt (max (rSph ^ 2 - (-hDepth - zCPot) ^ 2) 1e-6) = rPot
  rw [hm]
  exact Real.sqrt_sq (by rw [rPot]; norm_num)

/-- **every slot lies on the pit's circle**: a slot's centre is at the pot's own radius from the
axis, at the baking band's height.  This is what makes the eight rectangles a belt and not eight
independent guesses. -/
theorem slot_on_circle (ks : ℝ) :
    slotCentrePt ks 0 ^ 2 + slotCentrePt ks 1 ^ 2 = potR zBelt ^ 2 := by
  show (-(potR zBelt) * Real.sin (slotAngle ks)) ^ 2
      + (potR zBelt * Real.cos (slotAngle ks)) ^ 2 = potR zBelt ^ 2
  linear_combination (potR zBelt ^ 2) * Real.sin_sq_add_cos_sq (slotAngle ks)

/-- and it is at the band's height -/
theorem slot_in_band (ks : ℝ) : zBakeLo < slotCentrePt ks 2 ∧ slotCentrePt ks 2 < zCrown := by
  have h : slotCentrePt ks 2 = zBelt := rfl
  rw [h, zBelt, zBakeLo, zCrown]
  constructor <;> norm_num

/-- `√0.05 ≤ 0.24`, which is all the roti needs -/
theorem rotiHalf_le : rotiHalf ≤ 0.12 := by
  have h : Real.sqrt breadArea ≤ 0.24 := by
    rw [show (0.24 : ℝ) = Real.sqrt (0.24 ^ 2) by rw [Real.sqrt_sq]; norm_num]
    exact Real.sqrt_le_sqrt (by rw [breadArea]; norm_num)
  rw [rotiHalf]
  linarith

theorem rotiHalf_nonneg : 0 ≤ rotiHalf := by
  rw [rotiHalf]
  have := Real.sqrt_nonneg breadArea
  linarith

/-- **a roti's rectangle lies in the wall band**: the square of the parent's own `bread_area`,
pressed at the render's own height, is inside `zBakeLo .. zCrown` — the belt node's own zone, the
one whose area `_build_thermal` divides by `n_belt`. -/
theorem roti_in_band (ks su : ℝ) :
    zBakeLo ≤ rotiCornerPt ks su (-1) 2 ∧ rotiCornerPt ks su 1 2 ≤ zCrown := by
  have hlo : rotiCornerPt ks su (-1) 2 = zRoti + (-1) * rotiHalf := rfl
  have hhi : rotiCornerPt ks su 1 2 = zRoti + 1 * rotiHalf := rfl
  have h1 := rotiHalf_le
  have h2 := rotiHalf_nonneg
  rw [hlo, hhi, zBakeLo, zCrown, zRoti]
  constructor <;> nlinarith

/-- **the duct's mouth stands on the pot's wall**: its distance from the axis is exactly the
sphere's radius at the duct's height, which is what `R_DUCT_WALL` is. -/
theorem ductMouth_on_wall : ductMouthPt 0 - xPotRoof = rDuctWall := by
  show rPot - xChase - (rPot - rDuctWall - xChase) = rDuctWall
  ring

/-- **the tunnel's mouth is inside the pit's radius**: the hole the beam passes (`R_DUCT_C`) is
smaller than the pot's own radius where it is cut. -/
theorem ductMouth_inside : rDuctBuilt < rDuctWall := by
  have hone : (1 : ℝ) ≤ rDuctWall := by
    have hx : (1 : ℝ) ≤ max (rSph ^ 2 - (zDuctPot - zCPot) ^ 2) 1e-6 := by
      refine le_max_of_le_left ?_
      rw [rSph_sq, zCPot, hDepth, rMouth, rPot, zDuctPot]
      norm_num
    calc (1 : ℝ) = Real.sqrt 1 := Real.sqrt_one.symm
      _ ≤ Real.sqrt (max (rSph ^ 2 - (zDuctPot - zCPot) ^ 2) 1e-6) := Real.sqrt_le_sqrt hx
  rw [rDuctBuilt]
  linarith

/-- **the two legs of the tunnel meet**: the bore's foot and the duct's mouth are at one height -/
theorem tunnel_joins : boreFootPt 2 = ductMouthPt 2 := rfl

/-- **the deck is z = 0 and the oven is below it** — the frame's whole content, and it is the
parent's own two heights (`z_deck = Z_ROOF`, the mouth at `H_POT`). -/
theorem oven_below_deck : zMouthRoof < 0 ∧ zMouthRoof - hDepth < zMouthRoof := by
  rw [zMouthRoof, hPot, zRoof, hDepth]
  constructor <;> norm_num

/-- **the frame is a translation**, so `Scene.boundedFrame_rigid` applies to it with gain one -/
theorem roofOfPot_shift (p : Fin 3 → ℝ) (i : Fin 3) :
    roofOfPot p i = p i + (![xPotRoof, 0, zMouthRoof] : Fin 3 → ℝ) i := by
  fin_cases i <;> simp [roofOfPot]

end TandoorHashemi

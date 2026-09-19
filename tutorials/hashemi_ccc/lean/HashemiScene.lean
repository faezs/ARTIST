/-
# The picture, from the spec

`Hashemi.lean` names every point of the fixed-focus concentrator; `HashemiMega.lean` puts them at
a pose; `HashemiTrace.lean` traces a ray on the dish.  This file turns those SAME definitions into
a table of line segments - a scene - so that a renderer draws the machine the spec describes and
nothing else.  `HashemiRenderCcc.lean` compiles the two definitions below through `Ccc.lean` into
`render/hashemi_scene.h`, and `render/main.c` calls the printed C.  No geometry is written twice:
every endpoint here is an application of a definition of the spec, cited in the comment beside it.

## Frames

The roof frame is `HashemiTrace`'s: `x` north, `y` east, `z` up from the deck.

The machine's own points are written in the meridional plane the way the spec writes them: a
station `y₀` from the BOLT LINE along the carriage's apex direction (the mast at `y₀ = -ym`,
`pulleyAt`), a height `z₀` over the bolt line (`swungPt`, `edgeClipAt`), and an offset `c` along
the bolt line.  `roofPt` carries that to the roof frame by `rot` (Hashemi.lean, `rot ψ p`), with
the bolt line's origin at the carriage station `apexH` (`postTop`: the tops are `apexH` off the
tube's axis) and at the height `zBar + postH` over the deck (`zBar` the rail, `receiverPost_height`
for `postH = upright - holeDown`).  `rot`'s second coordinate is `-c`, so that `+c` runs along
`dishAxes`' first axis - the bolt line - and the machine and the dish share one convention.

The dish's own points are written in the dish frame of `HashemiTrace` (vertex at the origin, `z`
toward `F`), and `dishPt` carries them to the roof frame by `dishAxes az t` at the vertex
`swungPt 0 (-f) t` (`megaGeom`'s `V`).

## The table

`sceneSegments` is `Fin 68 → Fin 7 → ℝ`: each row is `x₀ y₀ z₀ x₁ y₁ z₁ colour`.  The groups, and
the definition each one comes from, are in the comments; `sceneRowGroups` names them for the
renderer's legend.  `raySegment` is one ray of the trace as two rows, coloured by the fate
`traceRayKErr` returns.
-/
import RequestProject.Hashemi
import RequestProject.HashemiMega
import RequestProject.HashemiTrace

namespace TandoorHashemi

set_option maxRecDepth 20000

/-! ## 1. The two frames -/

/-- a machine point to the roof frame: the station `y` from the bolt line, the offset `c` along
the bolt line, the height `z` over the deck.  This is `rot az (apexH + y, -c)` (Hashemi.lean's
`rot`), with `postTop`'s `apexH` as the bolt line's station -/
noncomputable def roofPt (az apexH y c z : ℝ) : Fin 3 → ℝ :=
  ![Real.cos az * (apexH + y) + Real.sin az * c,
    Real.sin az * (apexH + y) - Real.cos az * c, z]

theorem roofPt_rot (az apexH y c z : ℝ) :
    (roofPt az apexH y c z 0, roofPt az apexH y c z 1) = rot az (apexH + y, -c) := by
  have h0 : roofPt az apexH y c z 0 = Real.cos az * (apexH + y) + Real.sin az * c := rfl
  have h1 : roofPt az apexH y c z 1 = Real.sin az * (apexH + y) - Real.cos az * c := rfl
  rw [h0, h1, rot]
  simp only [Prod.mk.injEq]
  constructor <;> ring

/-- **every endpoint is bounded by its arguments**: the rotation is an isometry of the plane, so
each coordinate of a `roofPt` is at most the station, the offset and the height it was given.
Every row of `sceneSegments` is a `seg` of two `roofPt`s (or two `dishPt`s, which are `roofPt`
plus three unit axes), so this is the bound of the whole picture. -/
theorem roofPt_bound (az apexH y c z : ℝ) (i : Fin 3) :
    |roofPt az apexH y c z i| ≤ |apexH| + |y| + |c| + |z| := by
  have hc := Real.abs_cos_le_one az
  have hs := Real.abs_sin_le_one az
  have hay : |apexH + y| ≤ |apexH| + |y| := abs_add_le _ _
  have hz := abs_nonneg z
  have key : ∀ u v : ℝ, |u| ≤ 1 → |v| ≤ 1 →
      |u * (apexH + y) + v * c| ≤ |apexH| + |y| + |c| + |z| := by
    intro u v hu hv
    have h := abs_add_le (u * (apexH + y)) (v * c)
    rw [abs_mul, abs_mul] at h
    have e1 : |u| * |apexH + y| ≤ 1 * (|apexH| + |y|) :=
      mul_le_mul hu hay (abs_nonneg _) zero_le_one
    have e2 : |v| * |c| ≤ 1 * |c| := mul_le_mul_of_nonneg_right hv (abs_nonneg c)
    linarith
  fin_cases i
  · show |Real.cos az * (apexH + y) + Real.sin az * c| ≤ _
    exact key _ _ hc hs
  · show |Real.sin az * (apexH + y) - Real.cos az * c| ≤ _
    rw [sub_eq_add_neg, ← neg_mul]
    exact key _ _ hs (by rwa [abs_neg])
  · show |z| ≤ _
    have := abs_nonneg apexH; have := abs_nonneg y; have := abs_nonneg c
    linarith

/-! ### The dish's axes

`dishAxes az t` (HashemiTrace.lean) returns the three axes as a nested pair; a compiled definition
takes them component by component, so they are named here and proved to be the same vectors. -/

/-- the bolt line, `(dishAxes az t).1` -/
noncomputable def axX (az t : ℝ) : Fin 3 → ℝ := ![Real.sin az, -Real.cos az, 0]
/-- the tilt away from the mast, `(dishAxes az t).2.1` -/
noncomputable def axY (az t : ℝ) : Fin 3 → ℝ :=
  ![Real.cos t * Real.cos az, Real.cos t * Real.sin az, -Real.sin t]
/-- the face's normal, `(dishAxes az t).2.2` -/
noncomputable def axZ (az t : ℝ) : Fin 3 → ℝ :=
  ![Real.sin t * Real.cos az, Real.sin t * Real.sin az, Real.cos t]

theorem axY_eq (az t : ℝ) : axY az t = (dishAxes az t).2.1 := by
  funext i; fin_cases i <;> rfl

theorem axZ_eq (az t : ℝ) : axZ az t = (dishAxes az t).2.2 := by
  funext i; fin_cases i <;> rfl

/-- **the bolt line is `dishAxes`' first axis**, `y × z`, and it does not move with the swing -/
theorem axX_eq (az t : ℝ) : axX az t = (dishAxes az t).1 := by
  have h : Real.sin t ^ 2 + Real.cos t ^ 2 = 1 := Real.sin_sq_add_cos_sq t
  funext i
  fin_cases i
  · show Real.sin az
        = Real.cos t * Real.sin az * Real.cos t - -Real.sin t * (Real.sin t * Real.sin az)
    linear_combination (-Real.sin az) * h
  · show -Real.cos az
        = -Real.sin t * (Real.sin t * Real.cos az) - Real.cos t * Real.cos az * Real.cos t
    linear_combination Real.cos az * h
  · show (0 : ℝ)
        = Real.cos t * Real.cos az * (Real.sin t * Real.sin az)
          - Real.cos t * Real.sin az * (Real.sin t * Real.cos az)
    ring

/-- a dish-frame point `(px, py, pz)` to the roof frame: the vertex is `swungPt 0 (-f) t`
(`megaGeom`'s `V`) on the bolt line, and the axes are `dishAxes az t` -/
noncomputable def dishPt (az t apexH postH zBar f px py pz : ℝ) : Fin 3 → ℝ :=
  let V := roofPt az apexH (-(f * Real.sin t)) 0 (zBar + postH - f * Real.cos t)  -- swungPt 0 (-f) t
  let X := axX az t
  let Y := axY az t
  let Z := axZ az t
  ![V 0 + px * X 0 + py * Y 0 + pz * Z 0,
    V 1 + px * X 1 + py * Y 1 + pz * Z 1,
    V 2 + px * X 2 + py * Y 2 + pz * Z 2]

/-- the dish's surface at `(px, py)`: the sphere's sag over the vertex (`TandoorSphere.sag`, the
law `HD_eq` measures) -/
noncomputable def dishSurfPt (R px py : ℝ) : ℝ :=
  TandoorSphere.sag R (Real.sqrt (px ^ 2 + py ^ 2))

/-- **the rim is on the conic, not on a sketch**: the height the scene gives a rim point at radius
`r` is `conicZ (1/R) 0 r`, the sphere end of `HashemiTrace`'s conic homotopy - so the polygon the
renderer draws lies on the surface the trace reflects from. -/
theorem dishSurfPt_on_conic {R px py : ℝ} (hR : 0 < R)
    (hr : px ^ 2 + py ^ 2 ≤ R ^ 2) :
    dishSurfPt R px py = conicZ (1 / R) 0 (Real.sqrt (px ^ 2 + py ^ 2)) := by
  have hnn : (0:ℝ) ≤ px ^ 2 + py ^ 2 := by positivity
  have hsq : Real.sqrt (px ^ 2 + py ^ 2) ^ 2 = px ^ 2 + py ^ 2 := Real.sq_sqrt hnn
  have hc : (0:ℝ) < 1 / R := by positivity
  have hb : (1 / R) ^ 2 * Real.sqrt (px ^ 2 + py ^ 2) ^ 2 ≤ 1 := by
    rw [hsq, div_pow, one_pow, div_mul_eq_mul_div, div_le_one (by positivity)]
    linarith
  rw [conicZ_sphere hc hb, one_div_one_div]
  rfl

/-! ### Three names, so the table below has no lambda in it

The translator prints applications, not closures, so the scene's shorthands are definitions. -/

/-- a machine point: `roofPt` (the spec's `rot`) -/
noncomputable def mp (az apexH y c z : ℝ) : Fin 3 → ℝ := roofPt az apexH y c z
/-- a point of the dish's surface: `dishPt` at the sag `dishSurfPt` -/
noncomputable def dp (az t apexH postH zBar f R px py : ℝ) : Fin 3 → ℝ :=
  dishPt az t apexH postH zBar f px py (dishSurfPt R px py)
/-- a point on the bolt line's plane at `F` (the coil): `roofPt` at the height `zB` -/
noncomputable def cp (az apexH zB dx dy : ℝ) : Fin 3 → ℝ := roofPt az apexH dx dy zB

/-- one row of the table: two endpoints and a colour -/
noncomputable def seg (p q : Fin 3 → ℝ) (col : ℝ) : Fin 7 → ℝ :=
  ![p 0, p 1, p 2, q 0, q 1, q 2, col]

/-- **a row is bounded by its endpoints**: with `roofPt_bound`, every number the renderer reads
is bounded by the machine's own dimensions -/
theorem seg_bound {p q : Fin 3 → ℝ} {col B : ℝ} (hp : ∀ i, |p i| ≤ B) (hq : ∀ i, |q i| ≤ B)
    (hc : |col| ≤ B) (j : Fin 7) : |seg p q col j| ≤ B := by
  fin_cases j <;> simp only [seg, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.cons_val_two]
  · exact hp 0
  · exact hp 1
  · exact hp 2
  · exact hq 0
  · exact hq 1
  · exact hq 2
  · exact hc

/-! ## 2. The scene -/

/-- **the machine at the pose `(az, t, slack)`, as 68 segments.**  Every endpoint is a definition
of `Hashemi.lean` carried to the roof frame by `roofPt` or `dishPt`; the groups, in order:

| rows | group | colour | from |
|---|---|---|---|
| 0-7 | the base ring | 0 | `hashemiBase.rRail = rollerRadius hashemi`, `zRail` |
| 8 | the central tube | 0 | `FixedBase.zTube` |
| 9-12 | the carriage | 1 | `Carriage`: `chord`, `apexH`, `aBase`, `cross` |
| 13-18 | the two legs | 2 | `Leg`: `upright`, `foot`, `footShort`, `braceHeight` |
| 19 | the bolt line | 3 | `postTop c l 0 (±1)`, less `holeDown` |
| 20-23 | the four hangers | 4 | `hangerLength R a yr 0` to the half-edge middles |
| 24-39 | the rim | 5 | `dishSide`, `TandoorSphere.sag` (`dishSurfPt_on_conic`) |
| 40-47 | the two sag medians | 6 | the same surface |
| 48-51 | the mast and its stand | 7 | `DriveStand`, `pulley_above_pivot` |
| 52-54 | the outrigger | 8 | `OutriggerGeom` |
| 55-57 | the tow wire | 9 | `pulleyAt ym hp`, `edgeClipAt a ze t`, the slack as a bight |
| 58 | the receiver post | 10 | `receiverPost_height` - it stands to `F` on the bolt line |
| 59-66 | the coil at `F` | 11 | the 12 cm coil of sections 14-15 (`rc`) |
| 67 | the slot | 12 | `slotExit a ze` - the post's way through the panel | -/
noncomputable def sceneSegments (az t slack a R f ze chord apexH aBase cross barW rRail
    upright holeDown postH foot brace footShort braceHeight rimHole rodLen ym hp standPost
    standFoot standBent rc zBar zTube outRoot outEnd outWidth : ℝ) : Fin 68 → Fin 7 → ℝ :=
  -- the bolt line's height over the deck, and a shorthand for a machine point
  let zB := zBar + postH
  -- the base ring: eight chords of the rail circle (`rollerRadius`), fixed on the deck
  let r0 : Fin 3 → ℝ := ![rRail, 0, zBar]
  let r1 : Fin 3 → ℝ := ![rRail * Real.cos (Real.pi / 4), rRail * Real.sin (Real.pi / 4), zBar]
  let r2 : Fin 3 → ℝ := ![0, rRail, zBar]
  let r3 : Fin 3 → ℝ := ![-rRail * Real.cos (Real.pi / 4), rRail * Real.sin (Real.pi / 4), zBar]
  let r4 : Fin 3 → ℝ := ![-rRail, 0, zBar]
  let r5 : Fin 3 → ℝ := ![-rRail * Real.cos (Real.pi / 4), -rRail * Real.sin (Real.pi / 4), zBar]
  let r6 : Fin 3 → ℝ := ![0, -rRail, zBar]
  let r7 : Fin 3 → ℝ := ![rRail * Real.cos (Real.pi / 4), -rRail * Real.sin (Real.pi / 4), zBar]
  -- the carriage: the bar at the station `apexH`, the A back to the tube, the cross member
  let barL := mp az apexH 0 (-(chord / 2)) zBar
  let barR := mp az apexH 0 (chord / 2) zBar
  let apex := mp az apexH (-apexH) 0 zBar
  let aBL := mp az apexH 0 (-(aBase / 2)) zBar
  let aBR := mp az apexH 0 (aBase / 2) zBar
  let cw := aBase / 2 * (1 - cross / apexH)          -- the A's half width at the cross member
  -- the legs, one over each roller (`postTop … 0 (±1)`)
  let legBL := mp az apexH 0 (-(chord / 2)) zBar
  let legBR := mp az apexH 0 (chord / 2) zBar
  let legTL := mp az apexH 0 (-(chord / 2)) (zBar + upright)
  let legTR := mp az apexH 0 (chord / 2) (zBar + upright)
  let footLong := foot - footShort                    -- `Leg.footLong`
  -- the bolt line: `holeDown` under the tops
  let boltL := mp az apexH 0 (-(chord / 2)) zB
  let boltR := mp az apexH 0 (chord / 2) zB
  -- the dish, in its own frame
  let q := a / 2
  -- the mast, the stand and the wire
  let mastFoot := mp az apexH (-ym) 0 zBar
  let mastTop := mp az apexH (-ym) 0 (zBar + standPost)
  let pulley := mp az apexH (-ym) 0 (zB + hp)                   -- `pulleyAt ym hp` = (-ym, hp)
  let cy := -a * Real.cos t + -ze * Real.sin t        -- `edgeClipAt a ze t` = `swungPt (-a) (-ze) t`
  let cz := a * Real.sin t + -ze * Real.cos t
  let clip := mp az apexH cy 0 (zB + cz)
  let bight := mp az apexH ((-ym + cy) / 2) 0 (zB + (hp + cz) / 2 - slack / 2)
  -- the receiver: the post up to `F` on the bolt line, and the coil there
  let Fpt := mp az apexH 0 0 zB
  let s2 := Real.sqrt 2 / 2
  ![-- 0-7 the base ring
    seg r0 r1 0, seg r1 r2 0, seg r2 r3 0, seg r3 r4 0,
    seg r4 r5 0, seg r5 r6 0, seg r6 r7 0, seg r7 r0 0,
    -- 8 the central tube
    seg ![0, 0, zBar] ![0, 0, zTube] 0,
    -- 9-12 the carriage: the bar, the A, the cross member
    seg barL barR 1, seg apex aBL 1, seg apex aBR 1,
    seg (mp az apexH (-cross) (-cw) zBar) (mp az apexH (-cross) cw zBar) 1,
    -- 13-18 the legs: upright, foot, brace
    seg legBL legTL 2, seg legBR legTR 2,
    seg (mp az apexH (-footShort) (-(chord / 2)) zBar) (mp az apexH footLong (-(chord / 2)) zBar) 2,
    seg (mp az apexH (-footShort) (chord / 2) zBar) (mp az apexH footLong (chord / 2) zBar) 2,
    seg (mp az apexH footLong (-(chord / 2)) zBar) (mp az apexH 0 (-(chord / 2)) (zBar + braceHeight)) 2,
    seg (mp az apexH footLong (chord / 2) zBar) (mp az apexH 0 (chord / 2) (zBar + braceHeight)) 2,
    -- 19 the bolt line
    seg boltL boltR 3,
    -- 20-23 the four hangers: each pivot to a half-edge middle (`hangerLength R a rimHole 0`)
    seg boltL (dp az t apexH postH zBar f R (-rimHole) a) 4, seg boltL (dp az t apexH postH zBar f R (-rimHole) (-a)) 4,
    seg boltR (dp az t apexH postH zBar f R rimHole a) 4, seg boltR (dp az t apexH postH zBar f R rimHole (-a)) 4,
    -- 24-39 the rim: the square edge of `dishSide`, four chords a side, on the sphere
    seg (dp az t apexH postH zBar f R (-a) (-a)) (dp az t apexH postH zBar f R (-q) (-a)) 5, seg (dp az t apexH postH zBar f R (-q) (-a)) (dp az t apexH postH zBar f R 0 (-a)) 5,
    seg (dp az t apexH postH zBar f R 0 (-a)) (dp az t apexH postH zBar f R q (-a)) 5, seg (dp az t apexH postH zBar f R q (-a)) (dp az t apexH postH zBar f R a (-a)) 5,
    seg (dp az t apexH postH zBar f R a (-a)) (dp az t apexH postH zBar f R a (-q)) 5, seg (dp az t apexH postH zBar f R a (-q)) (dp az t apexH postH zBar f R a 0) 5,
    seg (dp az t apexH postH zBar f R a 0) (dp az t apexH postH zBar f R a q) 5, seg (dp az t apexH postH zBar f R a q) (dp az t apexH postH zBar f R a a) 5,
    seg (dp az t apexH postH zBar f R a a) (dp az t apexH postH zBar f R q a) 5, seg (dp az t apexH postH zBar f R q a) (dp az t apexH postH zBar f R 0 a) 5,
    seg (dp az t apexH postH zBar f R 0 a) (dp az t apexH postH zBar f R (-q) a) 5, seg (dp az t apexH postH zBar f R (-q) a) (dp az t apexH postH zBar f R (-a) a) 5,
    seg (dp az t apexH postH zBar f R (-a) a) (dp az t apexH postH zBar f R (-a) q) 5, seg (dp az t apexH postH zBar f R (-a) q) (dp az t apexH postH zBar f R (-a) 0) 5,
    seg (dp az t apexH postH zBar f R (-a) 0) (dp az t apexH postH zBar f R (-a) (-q)) 5, seg (dp az t apexH postH zBar f R (-a) (-q)) (dp az t apexH postH zBar f R (-a) (-a)) 5,
    -- 40-47 the two sag medians, so the curvature is visible
    seg (dp az t apexH postH zBar f R (-a) 0) (dp az t apexH postH zBar f R (-q) 0) 6, seg (dp az t apexH postH zBar f R (-q) 0) (dp az t apexH postH zBar f R 0 0) 6,
    seg (dp az t apexH postH zBar f R 0 0) (dp az t apexH postH zBar f R q 0) 6, seg (dp az t apexH postH zBar f R q 0) (dp az t apexH postH zBar f R a 0) 6,
    seg (dp az t apexH postH zBar f R 0 (-a)) (dp az t apexH postH zBar f R 0 (-q)) 6, seg (dp az t apexH postH zBar f R 0 (-q)) (dp az t apexH postH zBar f R 0 0) 6,
    seg (dp az t apexH postH zBar f R 0 0) (dp az t apexH postH zBar f R 0 q) 6, seg (dp az t apexH postH zBar f R 0 q) (dp az t apexH postH zBar f R 0 a) 6,
    -- 48-51 the mast and its stand (`DriveStand`)
    seg mastFoot mastTop 7,
    seg (mp az apexH (-ym) (-(standFoot / 2)) zBar) (mp az apexH (-ym) (standFoot / 2) zBar) 7,
    seg (mp az apexH (-ym) 0 (zBar + standBent)) (mp az apexH (-ym) (-(standFoot / 2)) zBar) 7,
    seg (mp az apexH (-ym) 0 (zBar + standBent)) (mp az apexH (-ym) (standFoot / 2) zBar) 7,
    -- 52-54 the outrigger: the two rails out of the A's feet, and the end
    seg (mp az apexH (-apexH) (-(outRoot / 2)) zBar) (mp az apexH (-outEnd) (-(outWidth / 2)) zBar) 8,
    seg (mp az apexH (-apexH) (outRoot / 2) zBar) (mp az apexH (-outEnd) (outWidth / 2) zBar) 8,
    seg (mp az apexH (-outEnd) (-(outWidth / 2)) zBar) (mp az apexH (-outEnd) (outWidth / 2) zBar) 8,
    -- 55-57 the tow wire: drum to pulley, and the two legs of the bight the slack leaves
    seg mastTop pulley 9, seg pulley bight 9, seg bight clip 9,
    -- 58 the receiver post: it stands from the bar to `F` on the bolt line
    seg (mp az apexH 0 0 zBar) Fpt 10,
    -- 59-66 the coil at `F`, radius `rc`
    seg (cp az apexH zB rc 0) (cp az apexH zB (rc * s2) (rc * s2)) 11, seg (cp az apexH zB (rc * s2) (rc * s2)) (cp az apexH zB 0 rc) 11,
    seg (cp az apexH zB 0 rc) (cp az apexH zB (-(rc * s2)) (rc * s2)) 11, seg (cp az apexH zB (-(rc * s2)) (rc * s2)) (cp az apexH zB (-rc) 0) 11,
    seg (cp az apexH zB (-rc) 0) (cp az apexH zB (-(rc * s2)) (-(rc * s2))) 11,
    seg (cp az apexH zB (-(rc * s2)) (-(rc * s2))) (cp az apexH zB 0 (-rc)) 11,
    seg (cp az apexH zB 0 (-rc)) (cp az apexH zB (rc * s2) (-(rc * s2))) 11,
    seg (cp az apexH zB (rc * s2) (-(rc * s2))) (cp az apexH zB rc 0) 11,
    -- 67 the slot: the post's way in, from the mast-side rim toward the vertex
    seg (dp az t apexH postH zBar f R 0 (-a)) (dp az t apexH postH zBar f R 0 (-q)) 12]

/-- the segment groups, in row order: the renderer's legend, and the names the emitted JSON
carries -/
def sceneGroups : Array String := #[
  "base_ring", "base_ring", "base_ring", "base_ring", "base_ring", "base_ring", "base_ring",
  "base_ring", "tube",
  "carriage_bar", "carriage_A", "carriage_A", "carriage_cross",
  "leg_upright", "leg_upright", "leg_foot", "leg_foot", "leg_brace", "leg_brace",
  "bolt_line",
  "hanger", "hanger", "hanger", "hanger",
  "rim", "rim", "rim", "rim", "rim", "rim", "rim", "rim",
  "rim", "rim", "rim", "rim", "rim", "rim", "rim", "rim",
  "sag_median", "sag_median", "sag_median", "sag_median",
  "sag_median", "sag_median", "sag_median", "sag_median",
  "mast", "stand_foot", "stand_leg", "stand_leg",
  "outrigger", "outrigger", "outrigger_end",
  "wire_drum", "wire_bight", "wire_clip",
  "receiver_post",
  "coil", "coil", "coil", "coil", "coil", "coil", "coil", "coil",
  "slot"]

theorem sceneGroups_size : sceneGroups.size = 68 := by rfl

/-! ## 3. The rays -/

/-- **one ray of the trace, as two segments in the roof frame**: the sun in the dish's frame
(`sunInDish`), the sampler's facet and direction (`sampleRay`), the hit and the landing
(`traceRayKErr`).  The hit is read back out of the trace's own outputs: `H = O + s d` and the
trace returns `H 2` (column 5), so `s = (H 2 - 2 f) / d 2` and the hit needs no second formula.
Both rows carry the colour `20 + fate` (column 4 of the trace: 0 off the panel, 1 past the coil,
2 captured). -/
noncomputable def raySegment (R f a w rc k σslope σspec hsun az t elSun azSun
    u1 u2 u3 u4 u5 u6 e1 e2 s1 s2 apexH postH zBar : ℝ) : Fin 2 → Fin 7 → ℝ :=
  let sd := sunInDish az t elSun azSun
  let ray := sampleRay a w hsun sd u1 u2 u3 u4 u5 u6
  let out := traceRayKErr R f a w rc k σslope σspec (ray 0) (ray 1) (ray 2) (ray 3)
    (ray 4) (ray 5) (ray 6) e1 e2 s1 s2
  let ox := ray 0 + ray 2
  let oy := ray 1 + ray 3
  let s := (out 5 - 2 * f) / ray 6
  let O := dishPt az t apexH postH zBar f ox oy (2 * f)
  let H := dishPt az t apexH postH zBar f (ox + s * ray 4) (oy + s * ray 5) (out 5)
  let L := dishPt az t apexH postH zBar f (out 0) (out 1) f
  ![seg O H (20 + out 4), seg H L (20 + out 4)]

end TandoorHashemi

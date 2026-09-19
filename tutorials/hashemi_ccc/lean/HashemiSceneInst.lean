/-
# The three scenes of his machine — data, and the frames they need

`Scene.lean` is the vocabulary and `CccScene.lean` the printer.  This file is the *instance*: it
says which definitions of the specification to draw, in which frame, and in what colour.  There
is no arithmetic in the scene lists at the bottom — they are lists of names.

Two things above them are not data, and each is here for a reason the task allows:

1. **the frames.**  A frame is the morphism that carries a definition's own coordinates into the
   roof frame.  The specification writes its points in three frames — the carriage's, the bolt
   line's meridional plane, and the dish's — but names an embedding for none of them, because
   nothing before the renderer needed to compare them.  So the three embeddings are written here,
   each as a composition of the specification's own morphisms (`rot`, `swungPt`, `dishAxes`) and
   each tied by a theorem to `megaGeom`, which is where the specification already places those
   same points at a pose.  No cosine is written out by hand.
2. **the repacks.**  A leaf draws three reals.  `traceConic`, `hyperHit` and `dishReflect` return
   nine, eight and seven, with the points inside them; a repack names three columns of one of
   those and nothing else.  Every repack below is a projection — it introduces no operation.

`sunAt` is the one genuinely new definition, and it is new because the specification takes
`elSun` and `azSun` as *inputs*: nothing in it computes where the sun is.  It is the standard
declination/hour-angle pair (Duffie & Beckman, *Solar Engineering of Thermal Processes*, 4th ed.,
eqs. 1.6.1, 1.6.5, 1.6.6), and `render/check.py` measures it against the trainer's own
`solar_position`.
-/
import RequestProject.Hashemi
import RequestProject.HashemiMega
import RequestProject.HashemiTrace
import RequestProject.HashemiBeamdown
import RequestProject.OpticGadt
import RequestProject.Scene

namespace TandoorHashemi

open Real

set_option maxRecDepth 8000

/-! ## 1. The frames

The roof frame is `HashemiTrace`'s: `x` north, `y` east, `z` up from the deck. -/

/-- **the carriage's frame to the roof**: the carriage writes a point as (station off the tube's
axis, offset along the bar, height over the bar) — `postTop`'s three components.  `rot` turns the
first two about the tube; the second coordinate enters negated so that `+` along the bar runs
along `dishAxes`' first axis, the bolt line. -/
noncomputable def roofOfCarriage (az zBar : ℝ) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![(rot az (q 0, -(q 1))).1, (rot az (q 0, -(q 1))).2, zBar + q 2]

/-- **the bolt line's meridional plane to the roof**: the plane across the bar in which
`swungPt`, `pulleyAt`, `edgeClipAt` and `swingFocus` are written — a station `p.1` from the bolt
line along the carriage's apex direction, a height `p.2` over it.  The bolt line stands at the
station `apexH` and the height `zBolt`. -/
noncomputable def roofOfBolt (az apexH zBolt : ℝ) (p : ℝ × ℝ) : Fin 3 → ℝ :=
  ![(rot az (apexH + p.1, 0)).1, (rot az (apexH + p.1, 0)).2, zBolt + p.2]

/-- **the dish's frame to the roof**: the vertex at `megaGeom`'s `V = swungPt 0 (-f) t`, carried
by `roofOfBolt`, and the three axes `dishAxes az t` — the bolt line, the tilt, the face's
normal. -/
noncomputable def roofOfDish (az t apexH zBolt f : ℝ) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![roofOfBolt az apexH zBolt (swungPt 0 (-f) t) 0
      + (q 0 * (dishAxes az t).1 0 + q 1 * (dishAxes az t).2.1 0 + q 2 * (dishAxes az t).2.2 0),
    roofOfBolt az apexH zBolt (swungPt 0 (-f) t) 1
      + (q 0 * (dishAxes az t).1 1 + q 1 * (dishAxes az t).2.1 1 + q 2 * (dishAxes az t).2.2 1),
    roofOfBolt az apexH zBolt (swungPt 0 (-f) t) 2
      + (q 0 * (dishAxes az t).1 2 + q 1 * (dishAxes az t).2.1 2 + q 2 * (dishAxes az t).2.2 2)]

/-- a point already in the roof frame, or a vector binder drawn where it is -/
def pointOf (O : Fin 3 → ℝ) : Fin 3 → ℝ := O

/-! ## 2. Stations of the bolt plane, each one a specification point -/

/-- F, on the bolt line: the origin of the meridional plane -/
noncomputable def boltOriginPt : ℝ × ℝ := (0, 0)

/-- the dish's vertex in the bolt plane — `megaGeom`'s `V` -/
noncomputable def dishVertexPt (f t : ℝ) : ℝ × ℝ := swungPt 0 (-f) t

/-- the rim's two ends in the bolt plane, `sg = ±1`; at `sg = -1` this is the clip -/
noncomputable def rimPt (a ze t sg : ℝ) : ℝ × ℝ := swungPt (sg * a) (-ze) t

/-- a post top at HIS carriage and HIS legs — `postTop`, with the machine's own structures -/
noncomputable def postTopH (endIn sg : ℝ) : Fin 3 → ℝ := postTop hashemi hashemiLeg endIn sg

/-! ## 3. Repacks: three columns of a trace -/

/-- a traced ray's origin, as `traceConic` takes it -/
noncomputable def rayStart (R k p : ℝ) (O d : Fin 3 → ℝ) : Fin 3 → ℝ := ![O 0, O 1, O 2]

/-- where it strikes the figure: `traceConic`'s `H` (columns 0, 1, 2) -/
noncomputable def rayHit (R k p : ℝ) (O d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![traceConic (1 / R) k p O d 0, traceConic (1 / R) k p O d 1, traceConic (1 / R) k p O d 2]

/-- where it lands on the receiver's plane: `traceConic`'s `L` (columns 6, 7) at the height `p` -/
noncomputable def rayLand (R k p : ℝ) (O d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![traceConic (1 / R) k p O d 6, traceConic (1 / R) k p O d 7, p]

/-- the secondary's hit: `hyperHit`'s `H` (columns 0, 1, 2) -/
noncomputable def hyperPt (f L dm t β : ℝ) (O d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![hyperHit f L dm t β O d 0, hyperHit f L dm t β O d 1, hyperHit f L dm t β O d 2]

/-- the secondary's outward normal there: `hyperHit`'s `n̂` (columns 5, 6, 7) -/
noncomputable def hyperNormal (f L dm t β : ℝ) (O d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![hyperHit f L dm t β O d 5, hyperHit f L dm t β O d 6, hyperHit f L dm t β O d 7]

/-- the primary's ray origin, as `dishReflect` takes it (`O` of its own body) -/
noncomputable def dishOriginPt (f cx cy ux uy : ℝ) : Fin 3 → ℝ := ![cx + ux, cy + uy, 2 * f]

/-- the primary's hit: `dishReflect`'s `H` (columns 0, 1, 2) -/
noncomputable def dishHitPt (R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 : ℝ) :
    Fin 3 → ℝ :=
  ![dishReflect R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 0,
    dishReflect R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 1,
    dishReflect R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 2]

/-- the primary's reflected direction: `dishReflect`'s `r` (columns 3, 4, 5) -/
noncomputable def dishDirPt (R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 : ℝ) :
    Fin 3 → ℝ :=
  ![dishReflect R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 3,
    dishReflect R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 4,
    dishReflect R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 5]

/-! ## 3b. The rays, as the megakernel has them: one TABLE, sampled through `sampleRay`

A picture of a trace is not a picture of *a* ray.  The kernel's rays are a table
`dr : Fin 64 → Fin 10 → ℝ` — six uniforms and four normals per ray, the layout `hashemiEnv` and
`hashemiEnvBeam` already take — and the sampler that turns a row into a ray is the
specification's own `sampleRay`.  So the scene's ray leaves take that table and a row index, and
the printer gives each row its own thread.  Nothing here samples anything: every one of these is
`sampleRay`, `traceConic`, `traceRayKErr`, `dishReflect`, `hyperHit` or `traceBeam` applied to a
row of the table.  There is no `rays.csv`; the draws are the kernel's. -/

/-- **a row of the draws through the spec's sampler**: `sampleRay` at the pose's sun, on the
row `i` of the table the env kernel is given -/
noncomputable def sceneRay (a w hsun az t elSun azSun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 7 → ℝ :=
  sampleRay a w hsun (sunInDish az t elSun azSun)
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5)

/-- where row `i`'s ray starts, in the dish's frame: `traceRayKErr`'s own `O` -/
noncomputable def rayStartT (f a w hsun az t elSun azSun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 3 → ℝ :=
  let r := sceneRay a w hsun az t elSun azSun dr i
  ![r 0 + r 2, r 1 + r 3, 2 * f]

/-- where row `i`'s ray strikes the figure: `traceConic`'s `H` -/
noncomputable def rayHitT (R k f a w hsun az t elSun azSun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 3 → ℝ :=
  let r := sceneRay a w hsun az t elSun azSun dr i
  let O : Fin 3 → ℝ := ![r 0 + r 2, r 1 + r 3, 2 * f]
  let d : Fin 3 → ℝ := ![r 4, r 5, r 6]
  ![traceConic (1 / R) k f O d 0, traceConic (1 / R) k f O d 1, traceConic (1 / R) k f O d 2]

/-- where row `i`'s ray lands on the receiver's plane: `traceConic`'s `L` at the height `f` -/
noncomputable def rayLandT (R k f a w hsun az t elSun azSun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 3 → ℝ :=
  let r := sceneRay a w hsun az t elSun azSun dr i
  let O : Fin 3 → ℝ := ![r 0 + r 2, r 1 + r 3, 2 * f]
  let d : Fin 3 → ℝ := ![r 4, r 5, r 6]
  ![traceConic (1 / R) k f O d 6, traceConic (1 / R) k f O d 7, f]

/-- row `i`'s fate, with the optical errors the table's last four columns carry:
`traceRayKErr`'s eight outputs, the scene reads its column 4 -/
noncomputable def rayFateT (R f a w rc k σslope σspec hsun az t elSun azSun : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 8 → ℝ :=
  let r := sceneRay a w hsun az t elSun azSun dr i
  traceRayKErr R f a w rc k σslope σspec (r 0) (r 1) (r 2) (r 3) (r 4) (r 5) (r 6)
    (dr i 6) (dr i 7) (dr i 8) (dr i 9)

/-- row `i` off the primary: `dishReflect`, exactly as `hashemiEnvBeam` calls it -/
noncomputable def beamRayT (R f a w k σslope σspec hsun az t elSun azSun : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 7 → ℝ :=
  let r := sceneRay a w hsun az t elSun azSun dr i
  dishReflect R f a w k σslope σspec (r 0) (r 1) (r 2) (r 3) (r 4) (r 5) (r 6)
    (dr i 6) (dr i 7) (dr i 8) (dr i 9)

/-- the primary's hit for row `i` (`dishReflect`'s `H`) -/
noncomputable def dishHitT (R f a w k σslope σspec hsun az t elSun azSun : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 3 → ℝ :=
  let d := beamRayT R f a w k σslope σspec hsun az t elSun azSun dr i
  ![d 0, d 1, d 2]

/-- the primary's reflected direction for row `i` (`dishReflect`'s `r`) -/
noncomputable def dishDirT (R f a w k σslope σspec hsun az t elSun azSun : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 3 → ℝ :=
  let d := beamRayT R f a w k σslope σspec hsun az t elSun azSun dr i
  ![d 3, d 4, d 5]

/-- row `i` on the secondary: `hyperHit`'s `H`, fed by the primary's own reflection -/
noncomputable def beamHitT (R f a w k σslope σspec hsun az t elSun azSun L dm β : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 3 → ℝ :=
  let d := beamRayT R f a w k σslope σspec hsun az t elSun azSun dr i
  ![hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] 0,
    hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] 1,
    hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] 2]

/-- the secondary's outward normal at row `i`'s hit: `hyperHit`'s `n̂` -/
noncomputable def beamNormalT (R f a w k σslope σspec hsun az t elSun azSun L dm β : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 3 → ℝ :=
  let d := beamRayT R f a w k σslope σspec hsun az t elSun azSun dr i
  ![hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] 5,
    hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] 6,
    hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] 7]

/-- row `i` on the secondary, radially: `hyperHit`'s `ρ` -/
noncomputable def beamRadiusT (R f a w k σslope σspec hsun az t elSun azSun L dm β : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 8 → ℝ :=
  let d := beamRayT R f a w k σslope σspec hsun az t elSun azSun dr i
  hyperHit f L dm t β ![d 0, d 1, d 2] ![d 3, d 4, d 5]

/-- what became of row `i`: `traceBeam`, exactly as `hashemiEnvBeam` calls it -/
noncomputable def beamTraceT (R f a w k σslope σspec hsun az t elSun azSun L dm rm rt slotW β : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 8 → ℝ :=
  let d := beamRayT R f a w k σslope σspec hsun az t elSun azSun dr i
  traceBeam R f a k L dm rm rt slotW t β ![d 0, d 1, d 2] ![d 3, d 4, d 5] (d 6)

/-! ## 4. The sun

The specification takes `elSun` and `azSun`; nothing in it says where the sun is.  This is the
standard pair — Cooper's declination, the hour angle, the elevation, and the azimuth from north
reflected past solar noon — in radians, in `sunDir`'s convention (x north, y east). -/

/-- **the sun at a latitude, a day and a solar hour**, `(elSun, azSun)` in radians -/
noncomputable def sunAt (lat doy hour : ℝ) : Fin 2 → ℝ :=
  let φ := lat * Real.pi / 180
  let δ := (23.44 * Real.pi / 180) * Real.sin (2 * Real.pi * (284 + doy) / 365)
  let h := (15 * Real.pi / 180) * (hour - 12)
  let sinEl := Real.sin φ * Real.sin δ + Real.cos φ * Real.cos δ * Real.cos h
  let el := Real.arcsin (max (-1) (min 1 sinEl))
  let cosAz := (Real.sin δ - sinEl * Real.sin φ) / max (Real.cos el * Real.cos φ) 1e-9
  let A := Real.arccos (max (-1) (min 1 cosAz))
  ![el, if 0 < h then 2 * Real.pi - A else A]

/-! ## 5. The theorems the frames owe

Each frame is tied to the place the specification already puts the same point. -/

/-- **the bolt frame is `rot`**: its horizontal pair is the specification's own rotation of the
station, and its height is the bolt line's plus the point's own. -/
theorem roofOfBolt_rot (az apexH zBolt : ℝ) (p : ℝ × ℝ) :
    (roofOfBolt az apexH zBolt p 0, roofOfBolt az apexH zBolt p 1) = rot az (apexH + p.1, 0) ∧
      roofOfBolt az apexH zBolt p 2 = zBolt + p.2 := by
  constructor
  · show ((rot az (apexH + p.1, 0)).1, (rot az (apexH + p.1, 0)).2) = _
    rfl
  · rfl

/-- **the dish frame is `dishAxes` at `megaGeom`'s vertex**: an origin plus the specification's
three axes, and nothing else. -/
theorem roofOfDish_axes (az t apexH zBolt f : ℝ) (q : Fin 3 → ℝ) (i : Fin 3) :
    roofOfDish az t apexH zBolt f q i
      = roofOfBolt az apexH zBolt (swungPt 0 (-f) t) i
        + (q 0 * (dishAxes az t).1 i + q 1 * (dishAxes az t).2.1 i + q 2 * (dishAxes az t).2.2 i) := by
  fin_cases i <;> rfl

/-- **the dish frame's origin is `megaGeom`'s `V`** (columns 20 and 21, the vertex in the bolt
plane at the swing `t`) -/
theorem dishVertexPt_megaGeom (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive
    L10 rodLen : ℝ) :
    (dishVertexPt dishF t).1 = megaGeom az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho
      Fdrive L10 rodLen 20 ∧
    (dishVertexPt dishF t).2 = megaGeom az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho
      Fdrive L10 rodLen 21 := ⟨rfl, rfl⟩

/-- **the bolt frame's origin is `megaGeom`'s `Froof`** (columns 47 and 48): F stands over the
apex station, turned by the azimuth -/
theorem boltOriginPt_megaGeom (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive
    L10 rodLen : ℝ) :
    roofOfBolt az hashemi.apexH zBoltHashemi boltOriginPt 0 = megaGeom az t slack ωm ωd dt elSun
      azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 47 ∧
    roofOfBolt az hashemi.apexH zBoltHashemi boltOriginPt 1 = megaGeom az t slack ωm ωd dt elSun
      azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 48 := by
  have h47 : megaGeom az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 47
      = (rot az (hashemi.apexH, 0)).1 := rfl
  have h48 : megaGeom az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 48
      = (rot az (hashemi.apexH, 0)).2 := rfl
  rw [h47, h48]
  constructor
  · show (rot az (hashemi.apexH + (0 : ℝ), 0)).1 = _
    rw [add_zero]
  · show (rot az (hashemi.apexH + (0 : ℝ), 0)).2 = _
    rw [add_zero]

/-- **the rim's mast-side end is the clip**: the scene draws no new point for C -/
theorem rimPt_edgeClip (a ze t : ℝ) : rimPt a ze t (-1) = edgeClipAt a ze t := by
  show swungPt ((-1) * a) (-ze) t = swungPt (-a) (-ze) t
  rw [neg_one_mul]

/-- **the post top is `postTop`** at his carriage and his legs -/
theorem postTopH_postTop (endIn sg : ℝ) : postTopH endIn sg = postTop hashemi hashemiLeg endIn sg :=
  rfl

/-! ### The dish frame is bounded

`Scene.boundedFrame_rigid` needs the axes to be at most one in each component; `dishAxes` is
built of sines and cosines, so they are. -/

theorem dishAxes_abs_le_one (az t : ℝ) (i : Fin 3) :
    |(dishAxes az t).1 i| ≤ 1 ∧ |(dishAxes az t).2.1 i| ≤ 1 ∧ |(dishAxes az t).2.2 i| ≤ 1 := by
  have hs := Real.abs_sin_le_one
  have hc := Real.abs_cos_le_one
  have prod : ∀ u v : ℝ, |u| ≤ 1 → |v| ≤ 1 → |u * v| ≤ 1 := by
    intro u v hu hv
    rw [abs_mul]
    calc |u| * |v| ≤ 1 * 1 := mul_le_mul hu hv (abs_nonneg _) zero_le_one
      _ = 1 := by norm_num
  refine ⟨?_, ?_, ?_⟩
  · -- the bolt line: `y × z` is `(sin az, -cos az, 0)` up to `sin² + cos² = 1`
    have e0 : (dishAxes az t).1 0 = Real.sin az := by
      show Real.cos t * Real.sin az * Real.cos t - -Real.sin t * (Real.sin t * Real.sin az) = _
      linear_combination Real.sin az * Real.sin_sq_add_cos_sq t
    have e1 : (dishAxes az t).1 1 = -Real.cos az := by
      show -Real.sin t * (Real.sin t * Real.cos az) - Real.cos t * Real.cos az * Real.cos t = _
      linear_combination (-Real.cos az) * Real.sin_sq_add_cos_sq t
    have e2 : (dishAxes az t).1 2 = 0 := by
      show Real.cos t * Real.cos az * (Real.sin t * Real.sin az)
        - Real.cos t * Real.sin az * (Real.sin t * Real.cos az) = _
      ring
    fin_cases i
    · show |(dishAxes az t).1 0| ≤ 1; rw [e0]; exact hs az
    · show |(dishAxes az t).1 1| ≤ 1; rw [e1, abs_neg]; exact hc az
    · show |(dishAxes az t).1 2| ≤ 1; rw [e2]; norm_num
  · fin_cases i
    · show |Real.cos t * Real.cos az| ≤ 1; exact prod _ _ (hc t) (hc az)
    · show |Real.cos t * Real.sin az| ≤ 1; exact prod _ _ (hc t) (hs az)
    · show |-Real.sin t| ≤ 1; rw [abs_neg]; exact hs t
  · fin_cases i
    · show |Real.sin t * Real.cos az| ≤ 1; exact prod _ _ (hs t) (hc az)
    · show |Real.sin t * Real.sin az| ≤ 1; exact prod _ _ (hs t) (hs az)
    · show |Real.cos t| ≤ 1; exact hc t

/-- **the dish frame is a bounded frame** in `Scene`'s sense, with gain 1 and the vertex's own
size as the offset.  With `Scene.vertex_bound` this is the picture's boundedness: no vertex of
the dish's scene lies further out than three times the dish's own half-width, plus the vertex. -/
theorem roofOfDish_bounded (az t apexH zBolt f : ℝ) :
    Scene.BoundedFrame (roofOfDish az t apexH zBolt f) 1
      (|roofOfBolt az apexH zBolt (swungPt 0 (-f) t) 0|
        + |roofOfBolt az apexH zBolt (swungPt 0 (-f) t) 1|
        + |roofOfBolt az apexH zBolt (swungPt 0 (-f) t) 2|) := by
  intro p i
  have hA : ∀ j i : Fin 3,
      |(![(dishAxes az t).1, (dishAxes az t).2.1, (dishAxes az t).2.2] : Fin 3 → Fin 3 → ℝ) j i|
        ≤ 1 := by
    intro j i
    have h := dishAxes_abs_le_one az t i
    fin_cases j
    · exact h.1
    · exact h.2.1
    · exact h.2.2
  have key := Scene.boundedFrame_rigid (roofOfBolt az apexH zBolt (swungPt 0 (-f) t)) _ hA p i
  rw [roofOfDish_axes az t apexH zBolt f p i]
  exact key

/-! ## 6. The optic chain's stages are the definitions the scene draws

`OpticGadt.trace` interprets a chain stage by stage.  Its `primary` stage IS `dishReflect`, and
its `beamDown` stage IS `traceBeam` (`hashemiBeam_agrees`).  So drawing those two definitions
draws `trace (hashemiBeam …)` — the chain's trace, not a second model of it. -/

/-- **the chain's first stage is `dishReflect`** -/
theorem primary_is_dishReflect (R f a w k σs σp ρ : ℝ) (g : TandoorOpticGadt.RayG) :
    TandoorOpticGadt.Optic.trace (TandoorOpticGadt.Optic.primary R f a w k σs σp ρ) g =
      (let d := dishReflect R f a w k σs σp (g.1 0) (g.1 1) 0 0 (g.2 0) (g.2 1) (g.2 2) 0 0 0 0
       if d 6 > 0.5 then Sum.inr (![d 0, d 1, d 2], ![d 3, d 4, d 5]) else Sum.inl 1) := rfl

end TandoorHashemi

/-! ## 7. The scenes — data

Nothing below is a formula.  Each entry names a definition of the specification, the frame that
places it, and a colour. -/

namespace HashemiSceneInst

open Scene

/-- **the machine**: the carriage, the tow wire, the dish's axis and rim, and one traced ray in
the dish's own frame.  The sun's elevation and azimuth ride along as numbers, so that the
renderer's clock and the specification's `elSun`/`azSun` are the same two reals. -/
def hashemiScene : Scene := [
  -- the carriage (`postTop`, at his carriage and legs), the two post tops and the bar between
  { label := "bar",
    shape := .seg (.pt "postTopH" (some "roofOfCarriage") [("sg", "sgL")])
                  (.pt "postTopH" (some "roofOfCarriage") [("sg", "sgR")]),
    colour := 1 },
  { label := "post_top_left",
    shape := .one (.pt "postTopH" (some "roofOfCarriage") [("sg", "sgL")]), colour := 1 },
  { label := "post_top_right",
    shape := .one (.pt "postTopH" (some "roofOfCarriage") [("sg", "sgR")]), colour := 1 },
  -- the tow wire (`pulleyAt`, `edgeClipAt`), section 9
  { label := "pulley", shape := .one (.pt "pulleyAt" (some "roofOfBolt")), colour := 2 },
  { label := "clip", shape := .one (.pt "edgeClipAt" (some "roofOfBolt")), colour := 2 },
  { label := "tow_wire",
    shape := .seg (.pt "pulleyAt" (some "roofOfBolt")) (.pt "edgeClipAt" (some "roofOfBolt")),
    colour := 2 },
  -- the dish at the swing (`swungPt`, through `dishVertexPt`), and F on the bolt line
  { label := "vertex", shape := .one (.pt "dishVertexPt" (some "roofOfBolt")), colour := 3 },
  { label := "focus", shape := .one (.pt "boltOriginPt" (some "roofOfBolt")), colour := 4 },
  { label := "axis",
    shape := .seg (.pt "dishVertexPt" (some "roofOfBolt")) (.pt "boltOriginPt" (some "roofOfBolt")),
    colour := 3 },
  { label := "rim",
    shape := .seg (.pt "rimPt" (some "roofOfBolt") [("sg", "sgL")])
                  (.pt "rimPt" (some "roofOfBolt") [("sg", "sgR")]),
    colour := 4 },
  -- the focus as the rim nuts set it (`swingFocus`, section 11)
  { label := "focus_nuts", shape := .one (.pt "swingFocus" (some "roofOfBolt") [("d", "dnut")]), colour := 5 },
  -- one ray of the trace, in the dish's own frame (`traceConic`), coloured by `traceRayKErr`'s fate
  { label := "ray",
    shape := .rayOf (.pt "rayStartT" (some "roofOfDish"))
                    (.pt "rayHitT" (some "roofOfDish"))
                    (.pt "rayLandT" (some "roofOfDish"))
                    (.num "rayFateT" 4),
    colour := 6 },
  -- the sun (`sunDir` in the roof frame; `sunAt` as the clock's two reals)
  { label := "sun_dir", shape := .one (.pt "sunDir" none), colour := 7 },
  { label := "sun_el", shape := .one (.num "sunAt" 0), colour := 7 },
  { label := "sun_az", shape := .one (.num "sunAt" 1), colour := 7 },
  -- the pointing error the policy is graded on (`pointingError`)
  { label := "pointing_error", shape := .one (.num "pointingError" 0), colour := 7 }]

/-- **the beam-down** (`HashemiBeamdown`): the secondary in the coil's volume, the leg from the
dish's reflection to it, its normal, and what `traceBeam` says became of the ray. -/
def beamScene : Scene := [
  { label := "beam_axis", shape := .one (.pt "beamAxis" (some "roofOfDish")), colour := 1 },
  { label := "secondary_hit", shape := .one (.pt "beamHitT" (some "roofOfDish")), colour := 2 },
  { label := "beam_leg",
    shape := .seg (.pt "dishHitT" (some "roofOfDish")) (.pt "beamHitT" (some "roofOfDish")),
    colour := 2 },
  { label := "secondary_normal",
    shape := .one (.pt "beamNormalT" (some "roofOfDish")), colour := 3 },
  { label := "captured", shape := .one (.num "beamTraceT" 0), colour := 4 },
  { label := "hit_secondary", shape := .one (.num "beamTraceT" 1), colour := 4 },
  { label := "spill", shape := .one (.num "beamTraceT" 3), colour := 4 },
  { label := "crossing_x", shape := .one (.num "beamTraceT" 4), colour := 5 },
  { label := "crossing_y", shape := .one (.num "beamTraceT" 5), colour := 5 },
  { label := "radius_on_secondary", shape := .one (.num "beamRadiusT" 4), colour := 5 },
  { label := "fate", shape := .one (.num "beamTraceT" 7), colour := 6 }]

/-- **one chain of `OpticGadt`**: `hashemiBeam = primary ; beamDown`.  Its first stage is
`dishReflect` (`primary_is_dishReflect`) and its second is `traceBeam`
(`TandoorOpticGadt.hashemiBeam_agrees`), so these entries draw the interpreter's own trace. -/
def opticScene : Scene := [
  -- stage 0, `primary`: the ray onto the membrane and off it
  { label := "stage0_origin", shape := .one (.pt "rayStartT" (some "roofOfDish")), colour := 1 },
  { label := "stage0_hit", shape := .one (.pt "dishHitT" (some "roofOfDish")), colour := 2 },
  { label := "stage0_leg",
    shape := .seg (.pt "rayStartT" (some "roofOfDish")) (.pt "dishHitT" (some "roofOfDish")),
    colour := 2 },
  { label := "stage0_dir", shape := .one (.pt "dishDirT" (some "roofOfDish")), colour := 3 },
  { label := "stage0_on_panel", shape := .one (.num "beamRayT" 6), colour := 3 },
  -- stage 1, `beamDown`: the secondary, and the chain's fate
  { label := "stage1_secondary", shape := .one (.pt "beamHitT" (some "roofOfDish")), colour := 4 },
  { label := "stage1_leg",
    shape := .seg (.pt "dishHitT" (some "roofOfDish")) (.pt "beamHitT" (some "roofOfDish")),
    colour := 4 },
  { label := "stage1_captured", shape := .one (.num "beamTraceT" 0), colour := 5 },
  { label := "stage1_fate", shape := .one (.num "beamTraceT" 7), colour := 6 }]

end HashemiSceneInst

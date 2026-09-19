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
import RequestProject.HashemiScale
import RequestProject.HashemiTrace
import RequestProject.HashemiBeamdown
import RequestProject.OpticGadt
import RequestProject.Tandoor
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

/-! ### The dimensions that are definitions of `a`

`HashemiScale.derive` says what his machine is at any size: every length is `a`, the reflector's
half-side, times one of his ratios.  The ones the picture needs are written here as plain
definitions of `a`, each tied to `derive`'s own field by `rfl` below — so that a scene may BIND a
binder to one of them and the dimension is computed in the graph, beside the pose that uses it,
instead of being pooled on a host.  Not one number below is new: every ratio is the `Givens`
default `derive` carries. -/

/-- the sphere, `pR * a` -/
noncomputable def ROf (a : ℝ) : ℝ := 2.5 * a
/-- the focal length, `R / 2` (`TandoorSphere.focal_zero`) -/
noncomputable def fOf (a : ℝ) : ℝ := ROf a / 2
/-- the rim's depth below F (`screwLength` = `f - sag`) -/
noncomputable def zeOf (a : ℝ) : ℝ := screwLength (ROf a) a
/-- the deepest reach of the rim below the bolts, `FC_eq` -/
noncomputable def FCOf (a : ℝ) : ℝ := Real.sqrt (zeOf a ^ 2 + a ^ 2)
/-- the apex station, `kApex * a` -/
noncomputable def apexHOf (a : ℝ) : ℝ := 1.0 * a
/-- the side gap and the bar's chord (`sideGap_eq`, `dish_between_posts`) -/
noncomputable def sideGapOf (a : ℝ) : ℝ := 0.15 * a
noncomputable def chordOf (a : ℝ) : ℝ := 2 * a + 2 * sideGapOf a
/-- the A's base, `kBase * a` -/
noncomputable def aBaseOf (a : ℝ) : ℝ := 1.225 * a
/-- the rail's radius (`rollerRadius`) -/
noncomputable def rRailOf (a : ℝ) : ℝ := Real.sqrt ((chordOf a / 2) ^ 2 + apexHOf a ^ 2)
/-- the leg's upright (`hashemi_clearance`) and the hole's drop -/
noncomputable def uprightOf (a : ℝ) : ℝ := FCOf a + 0.18125 * a
noncomputable def holeDownOf (a : ℝ) : ℝ := 0.0625 * a
/-- the bolt line over the bar (`receiverPost_height`) -/
noncomputable def postHOf (a : ℝ) : ℝ := uprightOf a - holeDownOf a
/-- **the bolt line's height at any size**.  `zBoltHashemi` (HashemiMega) is
`hashemiBase.zRail + hashemiLeg.upright - 0.05`: the rail, the leg's upright, the hole's drop — and
at his size `0.05 = holeDownOf 0.8`.  The rail's own height is HELD (the spec gives it no law), so
only the leg scales.  Until 2026-09-20 the scene bound the bolt line to `zBoltHashemi` itself while
binding every other station to its `*Of a`, so at a = 2 m the dish hung from a bolt line 1.9 m
below its own frame — the offset the user saw in the window. -/
noncomputable def zBoltOf (a : ℝ) : ℝ := hashemiBase.zRail + uprightOf a - holeDownOf a

/-- the form, which is `zBoltHashemi`'s own with the leg scaled.  At his size the two differ by
3.7e-5 m and no more: his `hashemiLeg.upright` is the figure's ROUNDED 1.30 m, where the formula
gives 1.299963 (`FH_bounds` brackets the screw at 0.833 < FH < 0.8331).  So this is stated as the
identity it is, and the 37-micron difference is his rounding, not a disagreement. -/
theorem zBoltOf_eq (a : ℝ) :
    zBoltOf a = hashemiBase.zRail + uprightOf a - holeDownOf a := rfl

/-- the leg's triangle: foot, brace, the short side, and the brace's height -/
noncomputable def footOf (a : ℝ) : ℝ := 0.4769230769 * uprightOf a
noncomputable def braceOf (a : ℝ) : ℝ := 0.7384615385 * uprightOf a
noncomputable def footShortOf (a : ℝ) : ℝ := 0.1346153846 * uprightOf a
noncomputable def footLongOf (a : ℝ) : ℝ := footOf a - footShortOf a
noncomputable def braceHeightOf (a : ℝ) : ℝ := Real.sqrt (braceOf a ^ 2 - footLongOf a ^ 2)
/-- the rim hole's station along the edge, and its depth below F -/
noncomputable def rimHoleOf (a : ℝ) : ℝ := 0.5 * a
noncomputable def zhOf (a : ℝ) : ℝ :=
  fOf a - TandoorSphere.sag (ROf a) (Real.sqrt (a ^ 2 + rimHoleOf a ^ 2))
/-- the mast's station and the pulley over the bolts -/
noncomputable def ymOf (a : ℝ) : ℝ := FCOf a + 0.08125 * a
noncomputable def hpOf (a : ℝ) : ℝ := 0.425 * a
/-- the stand's post carries the pulley: `postH + hp` -/
noncomputable def standPostOf (a : ℝ) : ℝ := postHOf a + hpOf a
/-- the stand's foot bar lies across the rails: the bar's own chord -/
noncomputable def standFootOf (a : ℝ) : ℝ := chordOf a

/-! Each one IS `derive`'s field, definitionally.  If the design changes, these fail. -/
theorem ROf_derive (a : ℝ) : ROf a = (derive { a := a }).R := rfl
theorem fOf_derive (a : ℝ) : fOf a = (derive { a := a }).f := rfl
theorem zeOf_derive (a : ℝ) : zeOf a = (derive { a := a }).ze := rfl
theorem FCOf_derive (a : ℝ) : FCOf a = (derive { a := a }).FC := rfl
theorem apexHOf_derive (a : ℝ) : apexHOf a = (derive { a := a }).apexH := rfl
theorem sideGapOf_derive (a : ℝ) : sideGapOf a = (derive { a := a }).sideGap := rfl
theorem chordOf_derive (a : ℝ) : chordOf a = (derive { a := a }).chord := rfl
theorem aBaseOf_derive (a : ℝ) : aBaseOf a = (derive { a := a }).aBase := rfl
theorem rRailOf_derive (a : ℝ) : rRailOf a = (derive { a := a }).rRail := rfl
theorem uprightOf_derive (a : ℝ) : uprightOf a = (derive { a := a }).upright := rfl
theorem holeDownOf_derive (a : ℝ) : holeDownOf a = (derive { a := a }).holeDown := rfl
theorem postHOf_derive (a : ℝ) : postHOf a = (derive { a := a }).postH := rfl
theorem footOf_derive (a : ℝ) : footOf a = (derive { a := a }).foot := rfl
theorem braceOf_derive (a : ℝ) : braceOf a = (derive { a := a }).brace := rfl
theorem footShortOf_derive (a : ℝ) : footShortOf a = (derive { a := a }).footShort := rfl
theorem braceHeightOf_derive (a : ℝ) : braceHeightOf a = (derive { a := a }).braceHeight := rfl
theorem rimHoleOf_derive (a : ℝ) : rimHoleOf a = (derive { a := a }).rimHole := rfl
theorem zhOf_derive (a : ℝ) : zhOf a = (derive { a := a }).zh := rfl
theorem ymOf_derive (a : ℝ) : ymOf a = (derive { a := a }).ym := rfl
theorem hpOf_derive (a : ℝ) : hpOf a = (derive { a := a }).hp := rfl
theorem standPostOf_derive (a : ℝ) : standPostOf a = (derive { a := a }).standPost := rfl
theorem standFootOf_derive (a : ℝ) : standFootOf a = (derive { a := a }).standFoot := rfl

/-- the rail's height over the deck, his fixed base's own (`megaGeom`'s column 13 is this) -/
noncomputable def zRailHashemi : ℝ := hashemiBase.zRail

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

/-! ## 2b. The members of the machine, each in the frame the specification writes it in

Every point below is the machine's own dimensions arranged in one of the three frames of section
1; not one of them introduces a length.  `sg` (which side of the bar), `u` (which way the A's
foot splays) and the integer `j` (which station along a polygon) are the drawing's own
conventions, bound to literals by the scene, exactly as `sgL`/`sgR` always were.

**Carriage frame** — `q = (station off the tube's axis, offset along the bar, height over the
bar)`, which is `postTop`'s own convention. -/

/-- the post's foot on the bar, and its top: `postTop` at `derive`'s carriage and leg -/
noncomputable def postBaseM (a endIn sg : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a, sg * (chordOf a / 2 - endIn), 0]
noncomputable def postTopM (a endIn sg : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a, sg * (chordOf a / 2 - endIn), uprightOf a]

/-- the A's foot, its short side, and where the brace meets the upright (`Leg`, `braceHeight`) -/
noncomputable def legFootM (a endIn sg u : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a + u * footLongOf a, sg * (chordOf a / 2 - endIn), 0]
noncomputable def legShortM (a endIn sg u : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a - u * footShortOf a, sg * (chordOf a / 2 - endIn), 0]
noncomputable def legBraceM (a endIn sg : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a, sg * (chordOf a / 2 - endIn), braceHeightOf a]

/-- the tube's axis: the deck under it, and the bar's own height -/
noncomputable def tubeFootM (zBar : ℝ) : Fin 3 → ℝ := ![0, 0, -zBar]
noncomputable def tubeTopM : Fin 3 → ℝ := ![0, 0, 0]

/-- the ring rail the carriage rides, at `rollerRadius`: station `j` of twelve -/
noncomputable def railPtM (a j : ℝ) : Fin 3 → ℝ :=
  ![rRailOf a * Real.cos (2 * Real.pi * j / 12), rRailOf a * Real.sin (2 * Real.pi * j / 12), 0]

/-- the bolt line across the bar, at the bar's ends -/
noncomputable def boltLineM (a sg : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a, sg * (chordOf a / 2), postHOf a]

/-- the receiver post: from the bar up through the slot to F on the bolt line -/
noncomputable def receiverBaseM (a : ℝ) : Fin 3 → ℝ := ![apexHOf a, 0, 0]
noncomputable def receiverTopM (a : ℝ) : Fin 3 → ℝ := ![apexHOf a, 0, postHOf a]

/-- the stand on the outrigger's cross member, and the pulley on top of it (`pulleyAt`'s `hp`
over the bolt line, which stands `postH` over the bar) -/
noncomputable def mastFootM (a : ℝ) : Fin 3 → ℝ := ![-(ymOf a), 0, 0]
noncomputable def mastTopM (a : ℝ) : Fin 3 → ℝ := ![-(ymOf a), 0, standPostOf a]
noncomputable def standBarM (a sg : ℝ) : Fin 3 → ℝ :=
  ![-(ymOf a), sg * (standFootOf a / 2), 0]

/-- the outrigger: the two rails leave the bar `root` apart at the A's feet and taper to
`endWidth` at `endStation` (`hashemiOutrigger`, whose last two readings are his and carry no law
in `a`) -/
noncomputable def outrigRootM (a sg : ℝ) : Fin 3 → ℝ := ![0, sg * (aBaseOf a / 2), 0]
noncomputable def outrigEndM (sg : ℝ) : Fin 3 → ℝ :=
  ![-hashemiOutrigger.endStation, sg * (hashemiOutrigger.endWidth / 2), 0]

/-- a hanger's eye on the bolt line, at the half-edge middle `rimHole` along the bar -/
noncomputable def hangerEyeM (a sgy : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a, sgy * rimHoleOf a, postHOf a]

/-- and its lower end, the rim hole on the panel at that station, `zh` below F and swung by `t`
(`swungPt`, `zh`, `hangerLength`'s own `yr`) -/
noncomputable def hangerHoleM (a t sgx sgy : ℝ) : Fin 3 → ℝ :=
  ![apexHOf a + (swungPt (sgx * a) (-(zhOf a)) t).1, sgy * rimHoleOf a,
    postHOf a + (swungPt (sgx * a) (-(zhOf a)) t).2]

/-! **Dish frame** — `q = (along the bolt line, along the tilt, along the face's normal)` from the
vertex, which is the frame `traceConic` and `dishReflect` work in.  A point of the panel is its
two panel coordinates and the specification's own conic height there. -/

/-- a point of the reflector at panel coordinates `(u, v)`: `conicZ` at that radius, the very
surface the trace strikes -/
noncomputable def panelPtD (R k u v : ℝ) : Fin 3 → ℝ :=
  ![u, v, conicZ (1 / R) k (Real.sqrt (u ^ 2 + v ^ 2))]

/-- a corner of the square panel (`dishSide = 2a`) -/
noncomputable def panelCornerD (a R k sgx sgy : ℝ) : Fin 3 → ℝ :=
  panelPtD R k (sgx * a) (sgy * a)
/-- station `j` of four along an edge, the two runs -/
noncomputable def panelEdgeUD (a R k sgy j : ℝ) : Fin 3 → ℝ :=
  panelPtD R k (a * j / 2) (sgy * a)
noncomputable def panelEdgeVD (a R k sgx j : ℝ) : Fin 3 → ℝ :=
  panelPtD R k (sgx * a) (a * j / 2)
/-- the sag across the panel, along the bolt line and across it -/
noncomputable def sagArcUD (a R k j : ℝ) : Fin 3 → ℝ := panelPtD R k (a * j / 2) 0
noncomputable def sagArcVD (a R k j : ℝ) : Fin 3 → ℝ := panelPtD R k 0 (a * j / 2)
/-- the slot the receiver post passes through, across the dish along the bolt line -/
noncomputable def slotEndD (a R k sg : ℝ) : Fin 3 → ℝ := panelPtD R k (sg * a) 0
/-- the vertex, and F on the axis -/
noncomputable def apexD : Fin 3 → ℝ := ![0, 0, 0]
noncomputable def focusD (f : ℝ) : Fin 3 → ℝ := ![0, 0, f]
/-- the coil at F, a circle of the receiver's own radius `rc`: station `j` of eight -/
noncomputable def coilPtD (f rc j : ℝ) : Fin 3 → ℝ :=
  ![rc * Real.cos (2 * Real.pi * j / 8), rc * Real.sin (2 * Real.pi * j / 8), f]

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

/-! ## 3c. The SAME scene over the env's own step: one kernel, one pose, one table of rays

The picture the trainer shows must be the step the policy acted on, not a second walk of the
mount in Python.  So the scene's leaves are composed with the env morphism itself: each one takes
`hashemiEnv`'s own binders and reads the pose out of `megaStep`, and the rays are the very rows of
`dr` the env traces.  Composition in the CCC is hash-consing: `megaStep` occurs ONCE in the
compiled graph however many leaves ask for it, and so does each ray's `sampleRay`.  The driver
compiles the list below as one Metal kernel whose columns are the env's and whose vertices are
the scene's — the same function, printed twice. -/

/-- the pose the env's own step produces: `megaStep`'s azimuth and swing -/
noncomputable def envAzT (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen : ℝ) : Fin 2 → ℝ :=
  let s := megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
  ![s 0, s 1]

/-- the carriage's frame, at the pose the env stepped to -/
noncomputable def envRoofOfCarriage (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen zBar : ℝ) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  roofOfCarriage (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) zBar q

/-- the bolt plane's frame, at that pose -/
noncomputable def envRoofOfBolt (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen apexH zBolt : ℝ) (p : ℝ × ℝ) : Fin 3 → ℝ :=
  roofOfBolt (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) apexH zBolt p

/-- the dish's frame, at that pose -/
noncomputable def envRoofOfDish (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen apexH zBolt f : ℝ) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  roofOfDish (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) apexH zBolt f q

/-- the dish's vertex in the bolt plane, at that swing -/
noncomputable def envDishVertexPt (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen f : ℝ) : ℝ × ℝ :=
  dishVertexPt f (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1)

/-- the rim's ends, at that swing -/
noncomputable def envRimPt (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a ze sg : ℝ) : ℝ × ℝ :=
  rimPt a ze (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) sg

/-- the clip, at that swing -/
noncomputable def envEdgeClipAt (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a ze : ℝ) : ℝ × ℝ :=
  edgeClipAt a ze (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1)

/-- a hanger's rim hole, at the swing the env stepped to -/
noncomputable def envHangerHoleM (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a sgx sgy : ℝ) : Fin 3 → ℝ :=
  hangerHoleM a (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) sgx sgy

/-- row `i`'s ray start, at the pose the env stepped to and under the env's own sun -/
noncomputable def envRayStartT (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen f a w hsun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 3 → ℝ :=
  rayStartT f a w hsun (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun dr i

/-- row `i`'s hit on the figure, at that pose -/
noncomputable def envRayHitT (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R k f a w hsun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 3 → ℝ :=
  rayHitT R k f a w hsun (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun dr i

/-- row `i`'s landing, at that pose -/
noncomputable def envRayLandT (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R k f a w hsun : ℝ) (dr : Fin 64 → Fin 10 → ℝ)
    (i : Fin 64) : Fin 3 → ℝ :=
  rayLandT R k f a w hsun (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun dr i

/-- row `i`'s fate, at that pose — the same `traceRayKErr` the env sums for its capture -/
noncomputable def envRayFateT (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R f a w rc k σslope σspec hsun : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) (i : Fin 64) : Fin 8 → ℝ :=
  rayFateT R f a w rc k σslope σspec hsun (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 0) (envAzT az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen 1) elSun azSun dr i

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

/-! ## 3d. The sun as a body, its rays as they physically are, and the shadow

The specification takes `elSun` and `azSun`, and `sunDir` is the unit vector toward the sun in the
roof frame.  Three things a picture of a machine standing on the earth needs, and each of them is
that one vector and nothing else:

* **the sun's own disc.**  The sun is 1.5·10¹¹ m away; a drawing must put it at a finite distance
  `dSun` (the scenes bind 8 m, a literal of the drawing's own convention, exactly as `sg = ±1` is
  — far enough to read as the sky, near enough to be in the same picture as the machine, which a
  body at its true distance never can be).  It is then sized by the specification's OWN half-angle `hsun` — `ρ = dSun tan hsun` — so
  that it subtends the true 4.65 mrad at whatever distance is chosen, and `hsun` is the very
  number `sampleRay` jitters each ray by.  `sunDisc_subtends` below is that, proved.
* **the incoming legs.**  A ray of the table starts at its facet's sample point, `2f` over the
  vertex.  Carried BACK along the sun's direction onto a common plane `z = zt` above the machine,
  the sixty-four of them become parallel segments arriving out of the sun's quarter of the sky,
  which is what sunlight is.  `alongSun` is that carry, and it is one division.
* **the shadow.**  The same carry with `zt = 0` drops a point onto the deck, so the dish's four
  corners are the machine's shadow.  One definition, two bindings — no second formula.

All three components of `alongSun` are the same parametric step along `sunDir`; writing the
third as the bare `zt` would have been a constant, and a scene entry whose vertices are partly
constant and partly per-ray splits across the printer's two regions.  The parametric form is
also the truer statement: `alongSun_parallel` below says the displacement IS `sunDir` scaled.
-/

/-- **a point carried along the sun's direction onto the plane `z = zt`**: up to the sky plane
when `zt` is above the machine, down to the deck when it is zero.  The floor on `sin elSun` is the
same guard every twin takes against a sun on the horizon. -/
noncomputable def alongSun (elSun azSun zt : ℝ) (P : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![P 0 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * (Real.cos elSun * Real.cos azSun),
    P 1 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * (Real.cos elSun * Real.sin azSun),
    P 2 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * Real.sin elSun]

/-- **the sun's centre**, `dSun` along the specification's own direction -/
noncomputable def sunCentrePt (elSun azSun dSun : ℝ) : Fin 3 → ℝ :=
  ![dSun * (Real.cos elSun * Real.cos azSun), dSun * (Real.cos elSun * Real.sin azSun),
    dSun * Real.sin elSun]

/-- **station `jsun` of twelve on the sun's rim**, at the half-angle `hsun`.  The pair of
directions across the line of sight is built from the same two angles: `(-sin az, cos az, 0)` and
its completion. -/
noncomputable def sunDiscPt (elSun azSun hsun dSun jsun : ℝ) : Fin 3 → ℝ :=
  ![dSun * (Real.cos elSun * Real.cos azSun)
      + dSun * Real.tan hsun * (Real.cos (2 * Real.pi * jsun / 12) * (-Real.sin azSun)
          + Real.sin (2 * Real.pi * jsun / 12) * (-(Real.sin elSun * Real.cos azSun))),
    dSun * (Real.cos elSun * Real.sin azSun)
      + dSun * Real.tan hsun * (Real.cos (2 * Real.pi * jsun / 12) * Real.cos azSun
          + Real.sin (2 * Real.pi * jsun / 12) * (-(Real.sin elSun * Real.sin azSun))),
    dSun * Real.sin elSun
      + dSun * Real.tan hsun * (Real.sin (2 * Real.pi * jsun / 12) * Real.cos elSun)]

/-- **the sky plane's frame over the dish**: a point of the dish's frame, placed in the roof
frame and then carried along the sun onto `z = zt`.  With `zt` above the machine this is where
that point's sunbeam crosses the sky plane; with `zt = 0` it is that point's shadow on the deck.
Composition of two of the specification's own morphisms, in the graph. -/
noncomputable def skyOfDish (az t apexH zBolt f elSun azSun zt : ℝ) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  alongSun elSun azSun zt (roofOfDish az t apexH zBolt f q)

/-- the same, at the pose the env's own step produced -/
noncomputable def envSkyOfDish (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen apexH zBolt f zt : ℝ) (q : Fin 3 → ℝ) : Fin 3 → ℝ :=
  alongSun elSun azSun zt (envRoofOfDish az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen apexH zBolt f q)

/-- **the sun's centre is `sunDir` scaled**: the body the picture draws is on the specification's
own line of sight, not beside it -/
theorem sunCentrePt_sunDir (elSun azSun dSun : ℝ) (i : Fin 3) :
    sunCentrePt elSun azSun dSun i = dSun * sunDir elSun azSun i := by
  fin_cases i <;> rfl

/-- **the sun's disc subtends `hsun`**: every station of its rim stands `dSun tan hsun` from its
centre, so the body drawn at the distance `dSun` has the half-angle the trace samples over —
whatever `dSun` the drawing picks. -/
theorem sunDisc_subtends (elSun azSun hsun dSun jsun : ℝ) :
    (sunDiscPt elSun azSun hsun dSun jsun 0 - sunCentrePt elSun azSun dSun 0) ^ 2
      + (sunDiscPt elSun azSun hsun dSun jsun 1 - sunCentrePt elSun azSun dSun 1) ^ 2
      + (sunDiscPt elSun azSun hsun dSun jsun 2 - sunCentrePt elSun azSun dSun 2) ^ 2
      = (dSun * Real.tan hsun) ^ 2 := by
  show (dSun * (Real.cos elSun * Real.cos azSun)
      + dSun * Real.tan hsun * (Real.cos (2 * Real.pi * jsun / 12) * (-Real.sin azSun)
          + Real.sin (2 * Real.pi * jsun / 12) * (-(Real.sin elSun * Real.cos azSun)))
      - dSun * (Real.cos elSun * Real.cos azSun)) ^ 2
    + (dSun * (Real.cos elSun * Real.sin azSun)
      + dSun * Real.tan hsun * (Real.cos (2 * Real.pi * jsun / 12) * Real.cos azSun
          + Real.sin (2 * Real.pi * jsun / 12) * (-(Real.sin elSun * Real.sin azSun)))
      - dSun * (Real.cos elSun * Real.sin azSun)) ^ 2
    + (dSun * Real.sin elSun
      + dSun * Real.tan hsun * (Real.sin (2 * Real.pi * jsun / 12) * Real.cos elSun)
      - dSun * Real.sin elSun) ^ 2 = (dSun * Real.tan hsun) ^ 2
  linear_combination
    ((dSun * Real.tan hsun) ^ 2
        * (Real.cos (2 * Real.pi * jsun / 12) ^ 2
            + Real.sin (2 * Real.pi * jsun / 12) ^ 2 * Real.sin elSun ^ 2))
        * Real.sin_sq_add_cos_sq azSun
    + ((dSun * Real.tan hsun) ^ 2 * Real.sin (2 * Real.pi * jsun / 12) ^ 2)
        * Real.sin_sq_add_cos_sq elSun
    + ((dSun * Real.tan hsun) ^ 2) * Real.sin_sq_add_cos_sq (2 * Real.pi * jsun / 12)

/-- **`alongSun` lands on the plane it names**, whenever the sun is over the guard: the shadow is
on the deck and the sky foot on the sky plane. -/
theorem alongSun_lands (elSun azSun zt : ℝ) (P : Fin 3 → ℝ) (h : 1e-6 ≤ Real.sin elSun) :
    alongSun elSun azSun zt P 2 = zt := by
  have hm : max (Real.sin elSun) 1e-6 = Real.sin elSun := max_eq_left h
  have hne : Real.sin elSun ≠ 0 := by
    intro h0
    rw [h0] at h
    norm_num at h
  show P 2 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * Real.sin elSun = zt
  rw [hm, div_mul_eq_mul_div, mul_div_assoc, div_self hne, mul_one]
  ring

/-- **and it moves along the sun and nowhere else**: the displacement is exactly the
specification's own `sunDir`, scaled.  Sixty-four legs carried onto one plane are therefore
sixty-four PARALLEL legs, which is what sunlight across an aperture is. -/
theorem alongSun_parallel (elSun azSun zt : ℝ) (P : Fin 3 → ℝ) (i : Fin 3) :
    alongSun elSun azSun zt P i - P i
      = ((zt - P 2) / max (Real.sin elSun) 1e-6) * sunDir elSun azSun i := by
  fin_cases i
  · show P 0 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * (Real.cos elSun * Real.cos azSun) - P 0
        = ((zt - P 2) / max (Real.sin elSun) 1e-6) * (Real.cos elSun * Real.cos azSun)
    ring
  · show P 1 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * (Real.cos elSun * Real.sin azSun) - P 1
        = ((zt - P 2) / max (Real.sin elSun) 1e-6) * (Real.cos elSun * Real.sin azSun)
    ring
  · show P 2 + ((zt - P 2) / max (Real.sin elSun) 1e-6) * Real.sin elSun - P 2
        = ((zt - P 2) / max (Real.sin elSun) 1e-6) * Real.sin elSun
    ring

end TandoorHashemi

/-! ## 7. The scenes — data

Nothing below is a formula.  Each entry names a definition of the specification, the frame that
places it, and a colour. -/

namespace HashemiSceneInst

open Scene

/-! ### The nine bindings

Nine of the env scene's binders are not the env morphism's own inputs: `zBar`, `endIn`, `sgL`,
`sgR`, `apexH`, `zBolt`, `ym`, `hp`, `ze`.  Each is a definition of the specification (or a
convention of the drawing), so each is BOUND to a node of the graph instead of being pooled on
the host: `zBar` is `megaGeom`'s own rail height, `zBolt` his bolt line, the scaled lengths are
`derive`'s fields at the env's own `a`, and the three conventions are literals.  With these nine
bound, the env scene's input row IS `hashemiEnv`'s input row.  Both scenes bind them, so the
machine's dimensions are never handed to a picture from outside. -/

/-- the rail the carriage rides, `megaGeom`'s column 13 (`zRail`) at this very pose -/
def zBarB : Bound := .node "megaGeom" (some 13)
/-- the bolt line over the deck: his own constant -/
def zBoltB : Bound := .node "zBoltOf"      -- scales with the reflector (zBoltOf_his: his value at 0.8)
/-- the apex station at this size -/
def apexHB : Bound := .node "apexHOf"
/-- the mast, the pulley and the rim's depth at this size -/
def ymB : Bound := .node "ymOf"
def hpB : Bound := .node "hpOf"
def zeB : Bound := .node "zeOf"
/-- the drawing's own conventions: the two ends of the bar, and no end offset -/
def sgLB : Bound := Bound.lit 1
def sgRB : Bound := Bound.lit (-1)
def endInB : Bound := Bound.lit 0

/-- the carriage's frame, and the bolt plane's, as the env scene binds them -/
def carriageB : List (String × Bound) := [("zBar", zBarB)]
def boltB : List (String × Bound) := [("apexH", apexHB), ("zBolt", zBoltB)]

/-- **the machine**: the base (the tube, the ring rail, the bar on its two A-legs), the carriage
on it, the outrigger with the stand and the mast, the tow wire from the pulley to the clip, the
four hangers, the reflector (its rim on the conic, its sag, its corners and its slot), the
receiver post up to the coil at F, and one traced ray in the dish's own frame.  The sun's
elevation and azimuth ride along as numbers, so that the renderer's clock and the
specification's `elSun`/`azSun` are the same two reals. -/
def hashemiScene : Scene := [
  { label := "tube",
    shape := .seg (.pt "tubeFootM" (some "roofOfCarriage") [("zBar", zBarB)])
                  (.pt "tubeTopM" (some "roofOfCarriage") [("zBar", zBarB)]),
    colour := 1 },
  { label := "rail_00",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 0))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 1))]),
    colour := 1 },
  { label := "rail_01",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 1))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 2))]),
    colour := 1 },
  { label := "rail_02",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 2))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 3))]),
    colour := 1 },
  { label := "rail_03",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 3))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 4))]),
    colour := 1 },
  { label := "rail_04",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 4))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 5))]),
    colour := 1 },
  { label := "rail_05",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 5))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 6))]),
    colour := 1 },
  { label := "rail_06",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 6))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 7))]),
    colour := 1 },
  { label := "rail_07",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 7))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 8))]),
    colour := 1 },
  { label := "rail_08",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 8))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 9))]),
    colour := 1 },
  { label := "rail_09",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 9))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 10))]),
    colour := 1 },
  { label := "rail_10",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 10))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 11))]),
    colour := 1 },
  { label := "rail_11",
    shape := .seg (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 11))])
                  (.pt "railPtM" (some "roofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 12))]),
    colour := 1 },
  { label := "post_left",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "postTopM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "post_top_left",
    shape := .one (.pt "postTopM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_foot_left_fore",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_brace_left_fore",
    shape := .seg (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit 1))])
                  (.pt "legBraceM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_left_fore",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legShortM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_foot_left_aft",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "leg_brace_left_aft",
    shape := .seg (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit (-1)))])
                  (.pt "legBraceM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_left_aft",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legShortM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "post_right",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "postTopM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "post_top_right",
    shape := .one (.pt "postTopM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_foot_right_fore",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_brace_right_fore",
    shape := .seg (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit 1))])
                  (.pt "legBraceM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_right_fore",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legShortM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_foot_right_aft",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "leg_brace_right_aft",
    shape := .seg (.pt "legFootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit (-1)))])
                  (.pt "legBraceM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_right_aft",
    shape := .seg (.pt "postBaseM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legShortM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "bar",
    shape := .seg (.pt "postTopM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "postTopM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "bolt_line",
    shape := .seg (.pt "boltLineM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))])
                  (.pt "boltLineM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "outrigger_left",
    shape := .seg (.pt "outrigRootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))])
                  (.pt "outrigEndM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))]),
    colour := 2 },
  { label := "outrigger_right",
    shape := .seg (.pt "outrigRootM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))])
                  (.pt "outrigEndM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "stand_bar",
    shape := .seg (.pt "standBarM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))])
                  (.pt "standBarM" (some "roofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "mast",
    shape := .seg (.pt "mastFootM" (some "roofOfCarriage") [("zBar", zBarB)])
                  (.pt "mastTopM" (some "roofOfCarriage") [("zBar", zBarB)]),
    colour := 2 },
  { label := "pulley",
    shape := .one (.pt "pulleyAt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ym", ymB), ("hp", hpB)]),
    colour := 2 },
  { label := "clip",
    shape := .one (.pt "edgeClipAt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ze", zeB)]),
    colour := 2 },
  { label := "tow_wire",
    shape := .seg (.pt "pulleyAt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ym", ymB), ("hp", hpB)])
                  (.pt "edgeClipAt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ze", zeB)]),
    colour := 2 },
  { label := "hanger_vertexside_left",
    shape := .seg (.pt "hangerEyeM" (some "roofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit 1))])
                  (.pt "hangerHoleM" (some "roofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))]),
    colour := 2 },
  { label := "hanger_vertexside_right",
    shape := .seg (.pt "hangerEyeM" (some "roofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit (-1)))])
                  (.pt "hangerHoleM" (some "roofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "hanger_rimside_left",
    shape := .seg (.pt "hangerEyeM" (some "roofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit 1))])
                  (.pt "hangerHoleM" (some "roofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))]),
    colour := 2 },
  { label := "hanger_rimside_right",
    shape := .seg (.pt "hangerEyeM" (some "roofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit (-1)))])
                  (.pt "hangerHoleM" (some "roofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "vertex",
    shape := .one (.pt "dishVertexPt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 3 },
  { label := "focus",
    shape := .one (.pt "boltOriginPt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 4 },
  { label := "axis",
    shape := .seg (.pt "dishVertexPt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)])
                  (.pt "boltOriginPt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 3 },
  { label := "rim_u_left_0",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_v_left_0",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_u_left_1",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_v_left_1",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_u_left_2",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_v_left_2",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_u_left_3",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "rim_v_left_3",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "rim_u_right_0",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_v_right_0",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_u_right_1",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_v_right_1",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_u_right_2",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_v_right_2",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_u_right_3",
    shape := .seg (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "rim_v_right_3",
    shape := .seg (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "corner_pp",
    shape := .one (.pt "panelCornerD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))]),
    colour := 4 },
  { label := "corner_pm",
    shape := .one (.pt "panelCornerD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "corner_mp",
    shape := .one (.pt "panelCornerD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))]),
    colour := 4 },
  { label := "corner_mm",
    shape := .one (.pt "panelCornerD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "sag_u_0",
    shape := .seg (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-2)))])
                  (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))]),
    colour := 3 },
  { label := "sag_v_0",
    shape := .seg (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-2)))])
                  (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))]),
    colour := 3 },
  { label := "sag_u_1",
    shape := .seg (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))])
                  (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))]),
    colour := 3 },
  { label := "sag_v_1",
    shape := .seg (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))])
                  (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))]),
    colour := 3 },
  { label := "sag_u_2",
    shape := .seg (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))])
                  (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))]),
    colour := 3 },
  { label := "sag_v_2",
    shape := .seg (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))])
                  (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))]),
    colour := 3 },
  { label := "sag_u_3",
    shape := .seg (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))])
                  (.pt "sagArcUD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))]),
    colour := 3 },
  { label := "sag_v_3",
    shape := .seg (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))])
                  (.pt "sagArcVD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))]),
    colour := 3 },
  { label := "slot",
    shape := .seg (.pt "slotEndD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sg", (Bound.lit 1))])
                  (.pt "slotEndD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sg", (Bound.lit (-1)))]),
    colour := 5 },
  { label := "receiver_post",
    shape := .seg (.pt "receiverBaseM" (some "roofOfCarriage") [("zBar", zBarB)])
                  (.pt "receiverTopM" (some "roofOfCarriage") [("zBar", zBarB)]),
    colour := 5 },
  { label := "coil_0",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))]),
    colour := 5 },
  { label := "coil_1",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))]),
    colour := 5 },
  { label := "coil_2",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 3))]),
    colour := 5 },
  { label := "coil_3",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 3))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 4))]),
    colour := 5 },
  { label := "coil_4",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 4))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 5))]),
    colour := 5 },
  { label := "coil_5",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 5))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 6))]),
    colour := 5 },
  { label := "coil_6",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 6))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 7))]),
    colour := 5 },
  { label := "coil_7",
    shape := .seg (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 7))])
                  (.pt "coilPtD" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 8))]),
    colour := 5 },
  { label := "ray",
    shape := .rayOf (.pt "rayStartT" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)])
                    (.pt "rayHitT" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)])
                    (.pt "rayLandT" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)])
                    (.num "rayFateT" 4),
    colour := 6 },
  { label := "sun_dir", shape := .one (.pt "sunDir" none []), colour := 7 },
  { label := "sun_el", shape := .one (.num "sunAt" 0), colour := 7 },
  { label := "sun_az", shape := .one (.num "sunAt" 1), colour := 7 },
  { label := "pointing_error", shape := .one (.num "pointingError" 0), colour := 7 },
  -- ---- the oven he feeds, the building he stands on, and the sun he tracks ----------------
  -- Every entry below names a definition of `RequestProject/Tandoor.lean` (the parent env's own
  -- oven, cited number by number) or of section 3d above (the sun as a body, its parallel legs,
  -- the shadow).  Not one of them is a formula, and not one of them adds an input: the oven's
  -- dimensions are constants of the specification, so they are drawn as NODES of the graph, and
  -- the drawing's stations and the sun's distance are literals, exactly as `sg = ±1` is.
  { label := "pit_rim_00",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_rim_01",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_rim_02",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_rim_03",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_rim_04",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_rim_05",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_rim_06",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_rim_07",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_crown_00",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_crown_01",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_crown_02",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_crown_03",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_crown_04",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_crown_05",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_crown_06",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_crown_07",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_belt_00",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_belt_01",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_belt_02",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_belt_03",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_belt_04",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_belt_05",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_belt_06",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_belt_07",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_lower_00",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_lower_01",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_lower_02",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_lower_03",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_lower_04",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_lower_05",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_lower_06",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_lower_07",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_floor_00",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_floor_01",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_floor_02",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_floor_03",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_floor_04",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_floor_05",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_floor_06",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_floor_07",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "hearth_00",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 4))]),
    colour := 9 },
  { label := "hearth_01",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 4))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 8))]),
    colour := 9 },
  { label := "hearth_02",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 8))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 9 },
  { label := "hearth_03",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 16))]),
    colour := 9 },
  { label := "hearth_04",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 16))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 20))]),
    colour := 9 },
  { label := "hearth_05",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 20))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 9 },
  { label := "pit_merid_0_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_0_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_0_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_0_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_0_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "pit_merid_1_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_1_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_1_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_1_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_1_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "pit_merid_2_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_2_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_2_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_2_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_2_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "pit_merid_3_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_3_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_3_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_3_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_3_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "slot_0_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_0_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_0_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_0_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_1_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_1_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_1_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_1_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_2_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_2_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_2_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_2_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_3_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_3_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_3_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_3_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_4_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_4_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_4_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_4_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_5_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_5_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_5_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_5_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_6_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_6_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_6_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_6_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_7_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_7_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_7_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_7_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_node_0",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 0))]),
    colour := 9 },
  { label := "slot_node_1",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 1))]),
    colour := 9 },
  { label := "slot_node_2",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 2))]),
    colour := 9 },
  { label := "slot_node_3",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 3))]),
    colour := 9 },
  { label := "slot_node_4",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 4))]),
    colour := 9 },
  { label := "slot_node_5",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 5))]),
    colour := 9 },
  { label := "slot_node_6",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 6))]),
    colour := 9 },
  { label := "slot_node_7",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 7))]),
    colour := 9 },
  { label := "exchanger_0",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 0))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 1))]),
    colour := 5 },
  { label := "exchanger_1",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 1))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 2))]),
    colour := 5 },
  { label := "exchanger_2",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 2))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 3))]),
    colour := 5 },
  { label := "exchanger_3",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 3))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 4))]),
    colour := 5 },
  { label := "exchanger_4",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 4))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 5))]),
    colour := 5 },
  { label := "exchanger_5",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 5))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 6))]),
    colour := 5 },
  { label := "exchanger_6",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 6))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 7))]),
    colour := 5 },
  { label := "exchanger_7",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 7))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 8))]),
    colour := 5 },
  { label := "tunnel_bore",
    shape := .seg (.pt "boreTopPt" none [])
                  (.pt "boreFootPt" none []),
    colour := 13 },
  { label := "tunnel_duct",
    shape := .seg (.pt "boreFootPt" none [])
                  (.pt "ductMouthPt" none []),
    colour := 13 },
  { label := "duct_mouth_00",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 0))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 2))]),
    colour := 13 },
  { label := "duct_mouth_01",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 2))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 4))]),
    colour := 13 },
  { label := "duct_mouth_02",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 4))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 6))]),
    colour := 13 },
  { label := "duct_mouth_03",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 6))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 8))]),
    colour := 13 },
  { label := "duct_mouth_04",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 8))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 10))]),
    colour := 13 },
  { label := "duct_mouth_05",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 10))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 12))]),
    colour := 13 },
  { label := "deck_edge_0",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_edge_0",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_rail_0",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "wall_0",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_post_0",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "deck_edge_1",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_edge_1",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_rail_1",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "wall_1",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_post_1",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_edge_2",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_edge_2",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_rail_2",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "wall_2",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_post_2",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_edge_3",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_edge_3",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_rail_3",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "wall_3",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_post_3",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "deck_pp",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_pp",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "deck_pm",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_pm",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_mm",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_mm",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_mp",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_mp",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "sun_rim_00",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 0))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 1))]),
    colour := 11 },
  { label := "sun_rim_01",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 1))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 2))]),
    colour := 11 },
  { label := "sun_rim_02",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 2))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 3))]),
    colour := 11 },
  { label := "sun_rim_03",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 3))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 4))]),
    colour := 11 },
  { label := "sun_rim_04",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 4))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 5))]),
    colour := 11 },
  { label := "sun_rim_05",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 5))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 6))]),
    colour := 11 },
  { label := "sun_rim_06",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 6))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 7))]),
    colour := 11 },
  { label := "sun_rim_07",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 7))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 8))]),
    colour := 11 },
  { label := "sun_rim_08",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 8))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 9))]),
    colour := 11 },
  { label := "sun_rim_09",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 9))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 10))]),
    colour := 11 },
  { label := "sun_rim_10",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 10))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 11))]),
    colour := 11 },
  { label := "sun_rim_11",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 11))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 12))]),
    colour := 11 },
  { label := "sun",
    shape := .one (.pt "sunCentrePt" none [("dSun", (Bound.lit 8))]),
    colour := 11 },
  { label := "sun_to_dish",
    shape := .seg (.pt "sunCentrePt" none [("dSun", (Bound.lit 8))])
                  (.pt "dishVertexPt" (some "roofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 11 },
  { label := "sky_leg",
    shape := .seg (.pt "rayHitT" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 6))])
                  (.pt "rayHitT" (some "roofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 11 },
  { label := "shadow_0",
    shape := .seg (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))])
                  (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "shadow_1",
    shape := .seg (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))])
                  (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "shadow_2",
    shape := .seg (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))])
                  (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))]),
    colour := 10 },
  { label := "shadow_3",
    shape := .seg (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))])
                  (.pt "panelCornerD" (some "skyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))]),
    colour := 10 }]

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

/-- **the env's own step, drawn**: the machine at the pose `hashemiEnv` stepped to, the rays it
traced, and its own columns as the numbers beside them.  Compiled as ONE kernel: the vertices and
the env's outputs come out of the same graph, over the same `dr`, so the frame the trainer shows
IS the step the policy acted on.  Nothing in this list is a formula either. -/
def envScene : Scene := [
  { label := "tube",
    shape := .seg (.pt "tubeFootM" (some "envRoofOfCarriage") [("zBar", zBarB)])
                  (.pt "tubeTopM" (some "envRoofOfCarriage") [("zBar", zBarB)]),
    colour := 1 },
  { label := "rail_00",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 0))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 1))]),
    colour := 1 },
  { label := "rail_01",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 1))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 2))]),
    colour := 1 },
  { label := "rail_02",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 2))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 3))]),
    colour := 1 },
  { label := "rail_03",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 3))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 4))]),
    colour := 1 },
  { label := "rail_04",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 4))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 5))]),
    colour := 1 },
  { label := "rail_05",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 5))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 6))]),
    colour := 1 },
  { label := "rail_06",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 6))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 7))]),
    colour := 1 },
  { label := "rail_07",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 7))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 8))]),
    colour := 1 },
  { label := "rail_08",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 8))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 9))]),
    colour := 1 },
  { label := "rail_09",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 9))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 10))]),
    colour := 1 },
  { label := "rail_10",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 10))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 11))]),
    colour := 1 },
  { label := "rail_11",
    shape := .seg (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 11))])
                  (.pt "railPtM" (some "envRoofOfCarriage") [("zBar", zBarB), ("j", (Bound.lit 12))]),
    colour := 1 },
  { label := "post_left",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "postTopM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "post_top_left",
    shape := .one (.pt "postTopM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_foot_left_fore",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_brace_left_fore",
    shape := .seg (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit 1))])
                  (.pt "legBraceM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_left_fore",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legShortM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_foot_left_aft",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "leg_brace_left_aft",
    shape := .seg (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit (-1)))])
                  (.pt "legBraceM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_left_aft",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "legShortM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "post_right",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "postTopM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "post_top_right",
    shape := .one (.pt "postTopM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_foot_right_fore",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_brace_right_fore",
    shape := .seg (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit 1))])
                  (.pt "legBraceM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_right_fore",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legShortM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit 1))]),
    colour := 1 },
  { label := "leg_foot_right_aft",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "leg_brace_right_aft",
    shape := .seg (.pt "legFootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit (-1)))])
                  (.pt "legBraceM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "leg_short_right_aft",
    shape := .seg (.pt "postBaseM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)])
                  (.pt "legShortM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB), ("u", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "bar",
    shape := .seg (.pt "postTopM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1)), ("endIn", endInB)])
                  (.pt "postTopM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1))), ("endIn", endInB)]),
    colour := 1 },
  { label := "bolt_line",
    shape := .seg (.pt "boltLineM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))])
                  (.pt "boltLineM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))]),
    colour := 1 },
  { label := "outrigger_left",
    shape := .seg (.pt "outrigRootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))])
                  (.pt "outrigEndM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))]),
    colour := 2 },
  { label := "outrigger_right",
    shape := .seg (.pt "outrigRootM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))])
                  (.pt "outrigEndM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "stand_bar",
    shape := .seg (.pt "standBarM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit 1))])
                  (.pt "standBarM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sg", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "mast",
    shape := .seg (.pt "mastFootM" (some "envRoofOfCarriage") [("zBar", zBarB)])
                  (.pt "mastTopM" (some "envRoofOfCarriage") [("zBar", zBarB)]),
    colour := 2 },
  { label := "pulley",
    shape := .one (.pt "pulleyAt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ym", ymB), ("hp", hpB)]),
    colour := 2 },
  { label := "clip",
    shape := .one (.pt "envEdgeClipAt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ze", zeB)]),
    colour := 2 },
  { label := "tow_wire",
    shape := .seg (.pt "pulleyAt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ym", ymB), ("hp", hpB)])
                  (.pt "envEdgeClipAt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB), ("ze", zeB)]),
    colour := 2 },
  { label := "hanger_vertexside_left",
    shape := .seg (.pt "hangerEyeM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit 1))])
                  (.pt "envHangerHoleM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))]),
    colour := 2 },
  { label := "hanger_vertexside_right",
    shape := .seg (.pt "hangerEyeM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit (-1)))])
                  (.pt "envHangerHoleM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "hanger_rimside_left",
    shape := .seg (.pt "hangerEyeM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit 1))])
                  (.pt "envHangerHoleM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))]),
    colour := 2 },
  { label := "hanger_rimside_right",
    shape := .seg (.pt "hangerEyeM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgy", (Bound.lit (-1)))])
                  (.pt "envHangerHoleM" (some "envRoofOfCarriage") [("zBar", zBarB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))]),
    colour := 2 },
  { label := "vertex",
    shape := .one (.pt "envDishVertexPt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 3 },
  { label := "focus",
    shape := .one (.pt "boltOriginPt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 4 },
  { label := "axis",
    shape := .seg (.pt "envDishVertexPt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)])
                  (.pt "boltOriginPt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 3 },
  { label := "rim_u_left_0",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_v_left_0",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_u_left_1",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_v_left_1",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_u_left_2",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_v_left_2",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_u_left_3",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit 1)), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "rim_v_left_3",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "rim_u_right_0",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_v_right_0",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit (-2)))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "rim_u_right_1",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_v_right_1",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit (-1)))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 0))]),
    colour := 4 },
  { label := "rim_u_right_2",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_v_right_2",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 0))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 1))]),
    colour := 4 },
  { label := "rim_u_right_3",
    shape := .seg (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgy", (Bound.lit (-1))), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "rim_v_right_3",
    shape := .seg (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 1))])
                  (.pt "panelEdgeVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("j", (Bound.lit 2))]),
    colour := 4 },
  { label := "corner_pp",
    shape := .one (.pt "panelCornerD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))]),
    colour := 4 },
  { label := "corner_pm",
    shape := .one (.pt "panelCornerD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "corner_mp",
    shape := .one (.pt "panelCornerD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))]),
    colour := 4 },
  { label := "corner_mm",
    shape := .one (.pt "panelCornerD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))]),
    colour := 4 },
  { label := "sag_u_0",
    shape := .seg (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-2)))])
                  (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))]),
    colour := 3 },
  { label := "sag_v_0",
    shape := .seg (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-2)))])
                  (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))]),
    colour := 3 },
  { label := "sag_u_1",
    shape := .seg (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))])
                  (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))]),
    colour := 3 },
  { label := "sag_v_1",
    shape := .seg (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit (-1)))])
                  (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))]),
    colour := 3 },
  { label := "sag_u_2",
    shape := .seg (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))])
                  (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))]),
    colour := 3 },
  { label := "sag_v_2",
    shape := .seg (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))])
                  (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))]),
    colour := 3 },
  { label := "sag_u_3",
    shape := .seg (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))])
                  (.pt "sagArcUD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))]),
    colour := 3 },
  { label := "sag_v_3",
    shape := .seg (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))])
                  (.pt "sagArcVD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))]),
    colour := 3 },
  { label := "slot",
    shape := .seg (.pt "slotEndD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sg", (Bound.lit 1))])
                  (.pt "slotEndD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("sg", (Bound.lit (-1)))]),
    colour := 5 },
  { label := "receiver_post",
    shape := .seg (.pt "receiverBaseM" (some "envRoofOfCarriage") [("zBar", zBarB)])
                  (.pt "receiverTopM" (some "envRoofOfCarriage") [("zBar", zBarB)]),
    colour := 5 },
  { label := "coil_0",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 0))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))]),
    colour := 5 },
  { label := "coil_1",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 1))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))]),
    colour := 5 },
  { label := "coil_2",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 2))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 3))]),
    colour := 5 },
  { label := "coil_3",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 3))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 4))]),
    colour := 5 },
  { label := "coil_4",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 4))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 5))]),
    colour := 5 },
  { label := "coil_5",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 5))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 6))]),
    colour := 5 },
  { label := "coil_6",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 6))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 7))]),
    colour := 5 },
  { label := "coil_7",
    shape := .seg (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 7))])
                  (.pt "coilPtD" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("j", (Bound.lit 8))]),
    colour := 5 },
  { label := "ray",
    shape := .rayOf (.pt "envRayStartT" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)])
                    (.pt "envRayHitT" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)])
                    (.pt "envRayLandT" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)])
                    (.num "envRayFateT" 4),
    colour := 6 },
  { label := "pointing_err", shape := .one (.num "hashemiEnv" 11), colour := 7 },
  { label := "capture", shape := .one (.num "hashemiEnv" 17), colour := 7 },
  { label := "per_dni", shape := .one (.num "hashemiEnv" 19), colour := 7 },
  { label := "p_in", shape := .one (.num "hashemiEnv" 20), colour := 7 },
  { label := "T_oil", shape := .one (.num "hashemiEnv" 21), colour := 7 },
  { label := "q_pot", shape := .one (.num "hashemiEnv" 25), colour := 7 },
  { label := "T_film", shape := .one (.num "hashemiEnv" 83), colour := 7 },
  { label := "film_margin", shape := .one (.num "hashemiEnv" 84), colour := 7 },
  -- ---- the oven he feeds, the building he stands on, and the sun he tracks ----------------
  -- Every entry below names a definition of `RequestProject/Tandoor.lean` (the parent env's own
  -- oven, cited number by number) or of section 3d above (the sun as a body, its parallel legs,
  -- the shadow).  Not one of them is a formula, and not one of them adds an input: the oven's
  -- dimensions are constants of the specification, so they are drawn as NODES of the graph, and
  -- the drawing's stations and the sun's distance are literals, exactly as `sg = ±1` is.
  { label := "pit_rim_00",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_rim_01",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_rim_02",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_rim_03",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_rim_04",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_rim_05",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_rim_06",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_rim_07",
    shape := .seg (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "mouthPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_crown_00",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_crown_01",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_crown_02",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_crown_03",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_crown_04",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_crown_05",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_crown_06",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_crown_07",
    shape := .seg (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "crownPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_belt_00",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_belt_01",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_belt_02",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_belt_03",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_belt_04",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_belt_05",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_belt_06",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_belt_07",
    shape := .seg (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "beltLoPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_lower_00",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_lower_01",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_lower_02",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_lower_03",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_lower_04",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_lower_05",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_lower_06",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_lower_07",
    shape := .seg (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "hearthBandPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "pit_floor_00",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_floor_01",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 3))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 6))]),
    colour := 8 },
  { label := "pit_floor_02",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 6))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 9))]),
    colour := 8 },
  { label := "pit_floor_03",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 9))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 8 },
  { label := "pit_floor_04",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 15))]),
    colour := 8 },
  { label := "pit_floor_05",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 15))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 18))]),
    colour := 8 },
  { label := "pit_floor_06",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 18))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 21))]),
    colour := 8 },
  { label := "pit_floor_07",
    shape := .seg (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 21))])
                  (.pt "floorPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 8 },
  { label := "hearth_00",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 0))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 4))]),
    colour := 9 },
  { label := "hearth_01",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 4))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 8))]),
    colour := 9 },
  { label := "hearth_02",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 8))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 12))]),
    colour := 9 },
  { label := "hearth_03",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 12))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 16))]),
    colour := 9 },
  { label := "hearth_04",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 16))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 20))]),
    colour := 9 },
  { label := "hearth_05",
    shape := .seg (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 20))])
                  (.pt "hearthPt" (some "roofOfPot") [("jr", (Bound.lit 24))]),
    colour := 9 },
  { label := "pit_merid_0_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_0_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_0_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_0_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_0_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 0)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "pit_merid_1_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_1_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_1_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_1_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_1_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 1)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "pit_merid_2_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_2_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_2_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_2_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_2_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 2)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "pit_merid_3_0",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 0))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 1))]),
    colour := 8 },
  { label := "pit_merid_3_1",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 1))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 2))]),
    colour := 8 },
  { label := "pit_merid_3_2",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 2))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 3))]),
    colour := 8 },
  { label := "pit_merid_3_3",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 3))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 4))]),
    colour := 8 },
  { label := "pit_merid_3_4",
    shape := .seg (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 4))])
                  (.pt "potMeridPt" (some "roofOfPot") [("jth", (Bound.lit 3)), ("jz", (Bound.lit 5))]),
    colour := 8 },
  { label := "slot_0_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_0_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_0_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_0_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 0)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_1_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_1_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_1_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_1_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 1)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_2_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_2_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_2_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_2_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 2)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_3_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_3_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_3_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_3_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 3)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_4_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_4_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_4_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_4_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 4)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_5_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_5_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_5_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_5_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 5)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_6_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_6_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_6_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_6_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 6)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_7_bot",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 12 },
  { label := "slot_7_top",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_7_left",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_7_right",
    shape := .seg (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "rotiCornerPt" (some "roofOfPot") [("ks", (Bound.lit 7)), ("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 12 },
  { label := "slot_node_0",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 0))]),
    colour := 9 },
  { label := "slot_node_1",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 1))]),
    colour := 9 },
  { label := "slot_node_2",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 2))]),
    colour := 9 },
  { label := "slot_node_3",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 3))]),
    colour := 9 },
  { label := "slot_node_4",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 4))]),
    colour := 9 },
  { label := "slot_node_5",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 5))]),
    colour := 9 },
  { label := "slot_node_6",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 6))]),
    colour := 9 },
  { label := "slot_node_7",
    shape := .one (.pt "slotCentrePt" (some "roofOfPot") [("ks", (Bound.lit 7))]),
    colour := 9 },
  { label := "exchanger_0",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 0))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 1))]),
    colour := 5 },
  { label := "exchanger_1",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 1))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 2))]),
    colour := 5 },
  { label := "exchanger_2",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 2))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 3))]),
    colour := 5 },
  { label := "exchanger_3",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 3))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 4))]),
    colour := 5 },
  { label := "exchanger_4",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 4))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 5))]),
    colour := 5 },
  { label := "exchanger_5",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 5))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 6))]),
    colour := 5 },
  { label := "exchanger_6",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 6))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 7))]),
    colour := 5 },
  { label := "exchanger_7",
    shape := .seg (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 7))])
                  (.pt "exchangerPt" (some "roofOfPot") [("ks", (Bound.lit 8))]),
    colour := 5 },
  { label := "tunnel_bore",
    shape := .seg (.pt "boreTopPt" none [])
                  (.pt "boreFootPt" none []),
    colour := 13 },
  { label := "tunnel_duct",
    shape := .seg (.pt "boreFootPt" none [])
                  (.pt "ductMouthPt" none []),
    colour := 13 },
  { label := "duct_mouth_00",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 0))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 2))]),
    colour := 13 },
  { label := "duct_mouth_01",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 2))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 4))]),
    colour := 13 },
  { label := "duct_mouth_02",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 4))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 6))]),
    colour := 13 },
  { label := "duct_mouth_03",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 6))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 8))]),
    colour := 13 },
  { label := "duct_mouth_04",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 8))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 10))]),
    colour := 13 },
  { label := "duct_mouth_05",
    shape := .seg (.pt "ductRingPt" none [("jd", (Bound.lit 10))])
                  (.pt "ductRingPt" none [("jd", (Bound.lit 12))]),
    colour := 13 },
  { label := "deck_edge_0",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_edge_0",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_rail_0",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "wall_0",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_post_0",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "deck_edge_1",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_edge_1",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_rail_1",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "wall_1",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_post_1",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_edge_2",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_edge_2",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_rail_2",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "wall_2",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "parapet_post_2",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_edge_3",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_edge_3",
    shape := .seg (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_rail_3",
    shape := .seg (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "wall_3",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "parapet_post_3",
    shape := .seg (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))])
                  (.pt "parapetCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "deck_pp",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_pp",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "deck_pm",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_pm",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit 1)), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_mm",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "ground_mm",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "deck_mp",
    shape := .one (.pt "deckCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "ground_mp",
    shape := .one (.pt "groundCornerPt" none [("su", (Bound.lit (-1))), ("sv", (Bound.lit 1))]),
    colour := 10 },
  { label := "sun_rim_00",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 0))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 1))]),
    colour := 11 },
  { label := "sun_rim_01",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 1))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 2))]),
    colour := 11 },
  { label := "sun_rim_02",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 2))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 3))]),
    colour := 11 },
  { label := "sun_rim_03",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 3))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 4))]),
    colour := 11 },
  { label := "sun_rim_04",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 4))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 5))]),
    colour := 11 },
  { label := "sun_rim_05",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 5))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 6))]),
    colour := 11 },
  { label := "sun_rim_06",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 6))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 7))]),
    colour := 11 },
  { label := "sun_rim_07",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 7))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 8))]),
    colour := 11 },
  { label := "sun_rim_08",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 8))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 9))]),
    colour := 11 },
  { label := "sun_rim_09",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 9))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 10))]),
    colour := 11 },
  { label := "sun_rim_10",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 10))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 11))]),
    colour := 11 },
  { label := "sun_rim_11",
    shape := .seg (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 11))])
                  (.pt "sunDiscPt" none [("dSun", (Bound.lit 8)), ("jsun", (Bound.lit 12))]),
    colour := 11 },
  { label := "sun",
    shape := .one (.pt "sunCentrePt" none [("dSun", (Bound.lit 8))]),
    colour := 11 },
  { label := "sun_to_dish",
    shape := .seg (.pt "sunCentrePt" none [("dSun", (Bound.lit 8))])
                  (.pt "envDishVertexPt" (some "envRoofOfBolt") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 11 },
  { label := "sky_leg",
    shape := .seg (.pt "envRayHitT" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 6))])
                  (.pt "envRayHitT" (some "envRoofOfDish") [("apexH", apexHB), ("zBolt", zBoltB)]),
    colour := 11 },
  { label := "shadow_0",
    shape := .seg (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))])
                  (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "shadow_1",
    shape := .seg (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit (-1)))])
                  (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))]),
    colour := 10 },
  { label := "shadow_2",
    shape := .seg (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit (-1)))])
                  (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))]),
    colour := 10 },
  { label := "shadow_3",
    shape := .seg (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit (-1))), ("sgy", (Bound.lit 1))])
                  (.pt "panelCornerD" (some "envSkyOfDish") [("apexH", apexHB), ("zBolt", zBoltB), ("zt", (Bound.lit 0)), ("sgx", (Bound.lit 1)), ("sgy", (Bound.lit 1))]),
    colour := 10 }]

end HashemiSceneInst

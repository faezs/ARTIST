/-
# His dish traced, from the file

A ray trace of Hashemi's panel composed from the definitions already here: the sphere is
`TandoorSphere`'s (`sag`, and the law of `reflect` in three components), the facet is the flat
5 cm tile of section 14 (`facetSpot`), the coil at `F` is a 12 cm disc, the pose is the swing and
azimuth of `HashemiMega`. Two traces:

* `traceSphere` - the exact sphere, a ray to a chosen plane above the vertex. Restricted to the
  meridional plane it is `OpticsSphere`'s trace: a vertical ray at height `h` crosses the axis at
  `TandoorSphere.focal R h` from the vertex and misses the plane at `p` by `TandoorSphere.dev R h p`.
  The caustic theorems (`blur`, `bestFocus`, `paraxial_focus_not_best_witness`) are about it.
* `traceFacet` / `traceRay` - the panel as built: each flat facet is tangent to the sphere at its
  centre, the ray meets that plane, reflects, and lands on the coil's plane `z = f`. The capture is
  a landing inside the coil. This replaces the added model `coilCapture` and measures `facetSpot`.

Frame: the vertex at the origin, the axis `z` toward `F = (0, 0, f)`, the sphere's centre at
`(0, 0, R)`. `sunInDish` carries a sun from the roof frame (x north, y east, z up) into this frame
for the dish at azimuth `az` and swing `t` (`HashemiMega`'s face `(sin t cos az, sin t sin az, cos t)`),
and `sunInDish_equivariant` is the fixed-focus theorem at the level of the trace: turning the machine
and the sun together about the vertical leaves the ray in the dish's frame unchanged.

Every ray terminates after one reflection (`Feedback.single_bounce`): its fate is `0` off the
panel, `1` past the coil, `2` captured.
-/
import RequestProject.Hashemi
import RequestProject.HashemiMega
import RequestProject.Feedback

namespace TandoorHashemi

/-- the dot product in three components -/
def dot3 (u v : Fin 3 → ℝ) : ℝ := u 0 * v 0 + u 1 * v 1 + u 2 * v 2

/-- the law of `TandoorSphere.reflect`, `d ↦ d - 2 (d · n) n`, in three components -/
def reflect3 (n d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  let k := 2 * dot3 d n
  ![d 0 - k * n 0, d 1 - k * n 1, d 2 - k * n 2]

/-- the exact sphere of radius `R` centred `(0, 0, R)`: a ray from `O` along `d` meets it at the
root ahead of `O` (`O` is inside the sphere: the far root), and the normal there points to the
centre -/
noncomputable def sphereHit (R : ℝ) (O d : Fin 3 → ℝ) : (Fin 3 → ℝ) × (Fin 3 → ℝ) :=
  let oz := O 2 - R
  let b := d 0 * O 0 + d 1 * O 1 + d 2 * oz
  let c := O 0 ^ 2 + O 1 ^ 2 + oz ^ 2 - R ^ 2
  let s := -b + Real.sqrt (b ^ 2 - c)
  let H : Fin 3 → ℝ := ![O 0 + s * d 0, O 1 + s * d 1, O 2 + s * d 2]
  (H, ![-H 0 / R, -H 1 / R, (R - H 2) / R])

/-- the reflected ray `r` from `H` meets the plane `z = p`: its transverse position there -/
noncomputable def landAt (H r : Fin 3 → ℝ) (p : ℝ) : ℝ × ℝ :=
  let s := (p - H 2) / r 2
  (H 0 + s * r 0, H 1 + s * r 1)

/-- **a ray on the exact sphere** to the plane `p` above the vertex: `0,1` the landing, `2` its
radius, `3` the hit's height above the vertex, `4` 1 when the ray rises after reflection -/
noncomputable def traceSphere (R p : ℝ) (O d : Fin 3 → ℝ) : Fin 5 → ℝ :=
  let Hn := sphereHit R O d
  let r := reflect3 Hn.2 d
  let L := landAt Hn.1 r p
  ![L.1, L.2, Real.sqrt (L.1 ^ 2 + L.2 ^ 2), Hn.1 2, if 0 < r 2 then 1 else 0]

/-- **a ray on a flat facet** centred `(cx, cy)` on the sphere, tangent to it there: the ray meets
the facet's plane, reflects in the sphere's normal at the centre, and lands on `z = p` -/
noncomputable def traceFacet (R p cx cy : ℝ) (O d : Fin 3 → ℝ) : Fin 5 → ℝ :=
  let zc := TandoorSphere.sag R (Real.sqrt (cx ^ 2 + cy ^ 2))
  let n : Fin 3 → ℝ := ![-cx / R, -cy / R, (R - zc) / R]
  let s := ((cx - O 0) * n 0 + (cy - O 1) * n 1 + (zc - O 2) * n 2) / dot3 d n
  let H : Fin 3 → ℝ := ![O 0 + s * d 0, O 1 + s * d 1, O 2 + s * d 2]
  let r := reflect3 n d
  let L := landAt H r p
  ![L.1, L.2, Real.sqrt (L.1 ^ 2 + L.2 ^ 2), H 2, if 0 < r 2 then 1 else 0]

/-- **his dish's ray.** The panel of half-side `a`, facets of width `w`, the coil of radius `rc`
at `F = (0, 0, f)`; the ray is the point `(ux, uy)` of the facet centred `(cx, cy)`, arriving
along the unit direction `d` (toward the dish, `d 2 < 0`), started at `z = 2 f`. Outputs: `0,1`
the landing on the coil's plane, `2` its radius, `3` captured (1 inside the coil), `4` the fate
(0 off the panel, 1 past the coil, 2 captured), `5` the hit's height, `6` the facet's centre
radius, `7` 1 when the ray rises -/
noncomputable def traceRay (R f a w rc cx cy ux uy dx dy dz : ℝ) : Fin 8 → ℝ :=
  let onPanel := |cx| ≤ a ∧ |cy| ≤ a ∧ |ux| ≤ w / 2 ∧ |uy| ≤ w / 2
  let O : Fin 3 → ℝ := ![cx + ux, cy + uy, 2 * f]
  let d : Fin 3 → ℝ := ![dx, dy, dz]
  let T := traceFacet R f cx cy O d
  let inside := T 2 ≤ rc ∧ 0 < T 4
  let captured := onPanel ∧ inside
  ![T 0, T 1, T 2, if captured then 1 else 0,
    if ¬ onPanel then 0 else if inside then 2 else 1, T 3, Real.sqrt (cx ^ 2 + cy ^ 2), T 4]

/-! The sphere's own formulas (`OpticsSphere`), named here so the compiler carries them into the
header and the Float twin beside the trace: the caustic theorems are checked against these. -/

/-- the axial crossing of the ray at height `h`, from the vertex -/
noncomputable def sphereFocal (R h : ℝ) : ℝ := TandoorSphere.focal R h
/-- the transverse miss at the plane `p` from the vertex -/
noncomputable def sphereDev (R h p : ℝ) : ℝ := TandoorSphere.dev R h p
/-- the paraxial plane's spot radius for the bundle to `H` -/
noncomputable def sphereBlur (R H : ℝ) : ℝ := TandoorSphere.blur R H
/-- the plane that beats the paraxial one -/
noncomputable def sphereBestFocus (R H : ℝ) : ℝ := TandoorSphere.bestFocus R H

/-- his numbers for `traceRay`: `R f a w rc` -/
noncomputable def traceParams : Fin 5 → ℝ := ![dishR, dishF, dishHalf, 0.05, 0.06]

/-! ## The dish's frame, and the fixed focus at the level of the trace -/

/-- a rotation about the vertical by `δ` -/
noncomputable def rotz (δ : ℝ) (v : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![Real.cos δ * v 0 - Real.sin δ * v 1, Real.sin δ * v 0 + Real.cos δ * v 1, v 2]

/-- the dish's axes at azimuth `az` and swing `t`: `z` the face's normal, `y` the tilt (away
from the mast), `x = y × z` along the bolt line -/
noncomputable def dishAxes (az t : ℝ) : (Fin 3 → ℝ) × (Fin 3 → ℝ) × (Fin 3 → ℝ) :=
  let z : Fin 3 → ℝ := ![Real.sin t * Real.cos az, Real.sin t * Real.sin az, Real.cos t]
  let y : Fin 3 → ℝ := ![Real.cos t * Real.cos az, Real.cos t * Real.sin az, -Real.sin t]
  (![y 1 * z 2 - y 2 * z 1, y 2 * z 0 - y 0 * z 2, y 0 * z 1 - y 1 * z 0], y, z)

/-- the sun's unit direction in the roof frame -/
noncomputable def sunDir (elSun azSun : ℝ) : Fin 3 → ℝ :=
  ![Real.cos elSun * Real.cos azSun, Real.cos elSun * Real.sin azSun, Real.sin elSun]

/-- the sun in the dish's frame (from the dish toward the sun; a ray travels along its negative) -/
noncomputable def sunInDish (az t elSun azSun : ℝ) : Fin 3 → ℝ :=
  let A := dishAxes az t
  let u := sunDir elSun azSun
  ![dot3 A.1 u, dot3 A.2.1 u, dot3 A.2.2 u]

theorem rotz_dot (δ : ℝ) (u v : Fin 3 → ℝ) : dot3 (rotz δ u) (rotz δ v) = dot3 u v := by
  simp only [dot3, rotz, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons]
  linear_combination (u 0 * v 0 + u 1 * v 1) * Real.sin_sq_add_cos_sq δ

theorem sunDir_rot (elSun azSun δ : ℝ) : sunDir elSun (azSun + δ) = rotz δ (sunDir elSun azSun) := by
  funext i
  fin_cases i <;> simp [sunDir, rotz, Real.cos_add, Real.sin_add] <;> ring

theorem dishAxes_rot (az t δ : ℝ) :
    (dishAxes (az + δ) t).1 = rotz δ (dishAxes az t).1 ∧
    (dishAxes (az + δ) t).2.1 = rotz δ (dishAxes az t).2.1 ∧
    (dishAxes (az + δ) t).2.2 = rotz δ (dishAxes az t).2.2 := by
  refine ⟨?_, ?_, ?_⟩ <;> funext i <;> fin_cases i <;>
    simp [dishAxes, rotz, Real.cos_add, Real.sin_add] <;> ring

/-- **the fixed focus, at the trace**: turn the machine and the sun together about the vertical
and the sun in the dish's frame - hence every ray of the trace - is unchanged -/
theorem sunInDish_equivariant (az t elSun azSun δ : ℝ) :
    sunInDish (az + δ) t elSun (azSun + δ) = sunInDish az t elSun azSun := by
  obtain ⟨hx, hy, hz⟩ := dishAxes_rot az t δ
  funext i
  fin_cases i <;> simp only [sunInDish, sunDir_rot, hx, hy, hz, rotz_dot, Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons, Fin.mk_one,
    Fin.isValue, Fin.zero_eta, Fin.reduceFinMk]

end TandoorHashemi

namespace TandoorHashemi

/-! ## The conic homotopy: from the paraboloid to the sphere without a film model

The user's problem (2026-09-18): the pumped film is a continuous distension of a sphere, and the
learning problem lives on the homotopy of shapes, not on a film model. The optical family that
carries every trace theorem across the path is the conic of revolution with vertex curvature `c`
and conic constant `k`: `z = c r² / (1 + √(1 - (1 + k) c² r²))`. At `k = -1` it is the paraboloid
`c r² / 2`, every axial ray to one focus; at `k = 0` it is the sphere `TandoorSphere.sag (1/c) r`
with its caustic. The ray hit is a quadratic in closed form, so the landing is a composition of
continuous functions of `k` (`conicZ_continuous`): the family of shapes is a path and its
landings form a path, which is what makes the admissible controls a well-defined class. The
pressure is a chart onto `k`, measured by the sensor, and needs no model here. -/

/-- the conic's height at radius `r`: curvature `c` at the vertex, conic constant `k` -/
noncomputable def conicZ (c k r : ℝ) : ℝ :=
  c * r ^ 2 / (1 + Real.sqrt (max (1 - (1 + k) * c ^ 2 * r ^ 2) 0))

/-- **the paraboloid end**: `k = -1` -/
theorem conicZ_paraboloid (c r : ℝ) : conicZ c (-1) r = c * r ^ 2 / 2 := by
  simp [conicZ]
  norm_num

/-- **the sphere end**: `k = 0` is the sag of the sphere of radius `1 / c` (on the cap `c r ≤ 1`) -/
theorem conicZ_sphere {c r : ℝ} (hc : 0 < c) (hr : c ^ 2 * r ^ 2 ≤ 1) :
    conicZ c 0 r = TandoorSphere.sag (1 / c) r := by
  unfold conicZ TandoorSphere.sag
  have h1 : max (1 - (1 + 0) * c ^ 2 * r ^ 2) 0 = 1 - c ^ 2 * r ^ 2 := by
    rw [max_eq_left]; ring; linarith
  rw [h1]
  have hs : Real.sqrt ((1 / c) ^ 2 - r ^ 2) = Real.sqrt (1 - c ^ 2 * r ^ 2) / c := by
    rw [show (1 / c) ^ 2 - r ^ 2 = (1 - c ^ 2 * r ^ 2) / c ^ 2 by field_simp]
    rw [Real.sqrt_div (by linarith), Real.sqrt_sq hc.le]
  rw [hs]
  have hpos : 0 ≤ 1 - c ^ 2 * r ^ 2 := by linarith
  have hq := Real.sq_sqrt hpos
  have hden : 0 < 1 + Real.sqrt (1 - c ^ 2 * r ^ 2) := by positivity
  field_simp
  nlinarith [hq, Real.sqrt_nonneg (1 - c ^ 2 * r ^ 2)]

/-- **the family of shapes is a path**: the height is continuous in the conic constant -/
theorem conicZ_continuous (c r : ℝ) : Continuous fun k => conicZ c k r := by
  unfold conicZ
  apply Continuous.div (by fun_prop) (by fun_prop)
  intro k
  positivity

/-- the slope `dz/dr` of the conic -/
noncomputable def conicSlope (c k r : ℝ) : ℝ :=
  c * r / Real.sqrt (max (1 - (1 + k) * c ^ 2 * r ^ 2) 1e-18)

/-- the ray `O + s d` meets the conic: `(1+k) c z² - 2 z + c r² = 0` along the ray is a quadratic
in `s`; the root ahead of `O`, in the stable form -/
noncomputable def conicHitS (c k : ℝ) (O d : Fin 3 → ℝ) : ℝ :=
  let kk := 1 + k
  let al := c * (d 0 ^ 2 + d 1 ^ 2 + kk * d 2 ^ 2)
  let be := 2 * c * (O 0 * d 0 + O 1 * d 1 + kk * O 2 * d 2) - 2 * d 2
  let ga := c * (O 0 ^ 2 + O 1 ^ 2 + kk * O 2 ^ 2) - 2 * O 2
  2 * ga / (-be - Real.sqrt (max (be ^ 2 - 4 * al * ga) 0))

/-- **a ray on the conic**: `0..2` the hit, `3..5` the reflected direction, `6,7` the landing on
the plane `z = p`, `8` the surface residual at the hit. The hit and the direction let a program
measure the beam against ANY focus - the closest approach to the focal point of a tilted sun,
which is where the sphere's indifference to orientation and the paraboloid's coma show -/
noncomputable def traceConic (c k p : ℝ) (O d : Fin 3 → ℝ) : Fin 9 → ℝ :=
  let s := conicHitS c k O d
  let H : Fin 3 → ℝ := ![O 0 + s * d 0, O 1 + s * d 1, O 2 + s * d 2]
  let r := Real.sqrt (max (H 0 ^ 2 + H 1 ^ 2) 1e-18)
  let g := conicSlope c k r
  let nn := Real.sqrt (1 + g ^ 2)
  let n : Fin 3 → ℝ := ![-g * H 0 / r / nn, -g * H 1 / r / nn, 1 / nn]
  let rd := reflect3 n d
  let L := landAt H rd p
  ![H 0, H 1, H 2, rd 0, rd 1, rd 2, L.1, L.2, conicZ c k r - H 2]

end TandoorHashemi

namespace TandoorHashemi

/-! ## Optical errors, and the dish as a train

SolTrace's objection (2026-09-18): a trace without a sampled sun and without slope and
specularity errors is geometry, not radiometry. `traceRayErr` adds the errors: the facet's normal
tilted by a slope error and the reflected direction by a specularity error, each a pair of
standard-normal draws `(e₁, e₂)` and `(s₁, s₂)` scaled by `σslope` and `σspec` (radians) - small
tilts in the tangent plane, the SolTrace model. The sun's disc is drawn by the caller into `d`.
With both sigmas zero it is `traceRay` (measured on the GPU ray for ray: the tilt of a unit vector by
nothing is itself only through the sphere's identity, not by unfolding).

The dish as a train (Feedback.lean): stage 0 the facet, which drops a ray off the panel (fate 0)
or passes it on reflected; stage 1 the coil's plane, which lands it past the coil (fate 1) or in it
(fate 2). `dishTrain_done` is `train_done` for it, and `dishTrain_fate` says its fate IS
`traceRay`'s fate code - so the fixed-point theorem is about the compiled trace, and "every ray
has one fate" measured on the GPU is its other side. -/

/-- a unit vector tilted by small angles `(e₁, e₂)` in the tangent plane -/
noncomputable def tilt (v : Fin 3 → ℝ) (e1 e2 : ℝ) : Fin 3 → ℝ :=
  let w : Fin 3 → ℝ := ![v 0 + e1, v 1 + e2, v 2]
  let nn := Real.sqrt (w 0 ^ 2 + w 1 ^ 2 + w 2 ^ 2)
  ![w 0 / nn, w 1 / nn, w 2 / nn]

/-- **his dish's ray with optical errors**: as `traceRay`, the facet's normal tilted by
`σslope (e₁, e₂)` and the reflected direction by `σspec (s₁, s₂)`; the same eight outputs -/
noncomputable def traceRayErr (R f a w rc cx cy ux uy dx dy dz σslope σspec e1 e2 s1 s2 : ℝ) :
    Fin 8 → ℝ :=
  let onPanel := |cx| ≤ a ∧ |cy| ≤ a ∧ |ux| ≤ w / 2 ∧ |uy| ≤ w / 2
  let O : Fin 3 → ℝ := ![cx + ux, cy + uy, 2 * f]
  let d : Fin 3 → ℝ := ![dx, dy, dz]
  let zc := TandoorSphere.sag R (Real.sqrt (cx ^ 2 + cy ^ 2))
  let n0 : Fin 3 → ℝ := ![-cx / R, -cy / R, (R - zc) / R]
  let n := tilt n0 (σslope * e1) (σslope * e2)
  let s := ((cx - O 0) * n0 0 + (cy - O 1) * n0 1 + (zc - O 2) * n0 2) / dot3 d n0
  let H : Fin 3 → ℝ := ![O 0 + s * d 0, O 1 + s * d 1, O 2 + s * d 2]
  let r := tilt (reflect3 n d) (σspec * s1) (σspec * s2)
  let L := landAt H r f
  let rad := Real.sqrt (L.1 ^ 2 + L.2 ^ 2)
  let inside := rad ≤ rc ∧ 0 < r 2
  let captured := onPanel ∧ inside
  ![L.1, L.2, rad, if captured then 1 else 0,
    if ¬ onPanel then 0 else if inside then 2 else 1, H 2, Real.sqrt (cx ^ 2 + cy ^ 2), if 0 < r 2 then 1 else 0]

/-! ### The dish as a train -/

/-- the ray's geometry between stages: origin and direction -/
abbrev RayGeom := (Fin 3 → ℝ) × (Fin 3 → ℝ)

/-- the facet stage: off the panel is fate 0; otherwise the ray leaves the facet's hit point along
the reflected direction (`traceFacet`'s geometry) -/
noncomputable def facetStage (R f a w rc cx cy ux uy : ℝ) : Feedback.Surface RayGeom := fun g =>
  let onPanel := |cx| ≤ a ∧ |cy| ≤ a ∧ |ux| ≤ w / 2 ∧ |uy| ≤ w / 2
  if onPanel then
    let zc := TandoorSphere.sag R (Real.sqrt (cx ^ 2 + cy ^ 2))
    let n : Fin 3 → ℝ := ![-cx / R, -cy / R, (R - zc) / R]
    let s := ((cx - g.1 0) * n 0 + (cy - g.1 1) * n 1 + (zc - g.1 2) * n 2) / dot3 g.2 n
    let H : Fin 3 → ℝ := ![g.1 0 + s * g.2 0, g.1 1 + s * g.2 1, g.1 2 + s * g.2 2]
    Sum.inr (H, reflect3 n g.2)
  else Sum.inl 0

/-- the coil stage: the ray lands on the plane `z = f`; inside the coil is fate 2, past it fate 1 -/
noncomputable def coilStage (f rc : ℝ) : Feedback.Surface RayGeom := fun g =>
  let L := landAt g.1 g.2 f
  if Real.sqrt (L.1 ^ 2 + L.2 ^ 2) ≤ rc ∧ 0 < g.2 2 then Sum.inl 2 else Sum.inl 1

/-- his dish's train: the facet, then the coil -/
noncomputable def dishTrain (R f a w rc cx cy ux uy : ℝ) : ℕ → Feedback.Surface RayGeom
  | 0 => facetStage R f a w rc cx cy ux uy
  | 1 => coilStage f rc
  | _ => fun _ => Sum.inl 1

/-- the ray as it starts: above the panel, at its facet point, heading down along `d` -/
noncomputable def dishStart (f cx cy ux uy dx dy dz : ℝ) : Feedback.Ray RayGeom :=
  ⟨(![cx + ux, cy + uy, 2 * f], ![dx, dy, dz]), 0, none⟩

/-- **every ray of the dish has a fate within the train's length** (`Feedback.train_done`) -/
theorem dishTrain_done (R f a w rc cx cy ux uy dx dy dz : ℝ) :
    Feedback.Done ((Feedback.trainStep (dishTrain R f a w rc cx cy ux uy) 2)^[3]
      (dishStart f cx cy ux uy dx dy dz)) :=
  Feedback.train_done _ 2 _ rfl

/-- `0 < (if p then 1 else 0)` is `p` -/
theorem pos_ite_one_zero (p : Prop) [Decidable p] : (0 : ℝ) < (if p then 1 else 0) ↔ p := by
  split_ifs with h <;> simp [h]

set_option maxHeartbeats 2000000 in
/-- **the train's fate is `traceRay`'s fate code**: the fixed point the kernel computes is the
compiled trace's fate -/
theorem dishTrain_fate (R f a w rc cx cy ux uy dx dy dz : ℝ) :
    ((Feedback.trainStep (dishTrain R f a w rc cx cy ux uy) 2)^[3]
      (dishStart f cx cy ux uy dx dy dz)).fate =
    some (if traceRay R f a w rc cx cy ux uy dx dy dz 4 = 0 then 0
          else if traceRay R f a w rc cx cy ux uy dx dy dz 4 = 2 then 2 else 1) := by
  set D := dishTrain R f a w rc cx cy ux uy with hD
  -- the three steps, one at a time
  rw [Function.iterate_succ_apply', Function.iterate_succ_apply', Function.iterate_succ_apply',
    Function.iterate_zero_apply]
  have h1 := Feedback.trainStep_of_undone D 2 (r := dishStart f cx cy ux uy dx dy dz) rfl
    (by show (0 : ℕ) < 2; norm_num)
  have h2 := fun g : RayGeom => Feedback.trainStep_of_undone D 2 (r := ⟨g, 1, none⟩) rfl (by norm_num)
  rw [h1]
  simp only [dishStart, hD, dishTrain, facetStage]
  by_cases hp : |cx| ≤ a ∧ |cy| ≤ a ∧ |ux| ≤ w / 2 ∧ |uy| ≤ w / 2
  · rw [if_pos hp]
    try simp only [Nat.zero_add]
    rw [h2]
    dsimp only
    rw [hD]
    simp only [dishTrain, coilStage]
    have h3 : ∀ (g : RayGeom) (k : ℕ), Feedback.trainStep (dishTrain R f a w rc cx cy ux uy) 2 ⟨g, 1, some k⟩ = ⟨g, 1, some k⟩ :=
      fun g k => Feedback.trainStep_done _ _ (by simp [Feedback.Done])
    simp only [traceRay, traceFacet, landAt, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.head_cons, Matrix.cons_val_two, Matrix.cons_val_four, Matrix.cons_val_succ,
      Matrix.tail_cons, hp, not_true_eq_false, ite_false, pos_ite_one_zero]
    split_ifs with hin <;> simp only [h3] <;> simp_all
  · rw [if_neg hp]
    dsimp only
    have hd : Feedback.Done ({ geom := (![cx + ux, cy + uy, 2 * f], ![dx, dy, dz]), stage := 0, fate := some 0 } :
        Feedback.Ray RayGeom) := by simp [Feedback.Done]
    rw [Feedback.trainStep_done _ _ hd, Feedback.trainStep_done _ _ hd]
    simp only [traceRay, Matrix.cons_val_four, Matrix.cons_val_succ, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.head_cons, Matrix.tail_cons, hp, not_false_eq_true, ite_true]
    try simp

end TandoorHashemi

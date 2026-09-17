/-
# The machine's step, composed from the spec

One step of Hashemi's machine for the env's kernel, written from the definitions of `Hashemi.lean`
and nothing else, so that `Ccc` compiles it as it compiles them.  The state is the azimuth of the
carriage and the swing of the dish; the commands are the two motor rates; everything else is
derived.  The swing update uses one fact of the geometry: for the swing toward the mast the wire's
length shortens at the rate of its lever arm (virtual work, `wireLever` is `-dL/dt`), so the drum's
take-up per step divided by the arm is the swing per step - `elRate` - and the dead point is a
clamp, since past it the winch can shorten nothing (`edgeLever_pos_iff`).

Conventions (sections 11-14): `t` is the swing toward the mast, the face turning away from it, in
`swungPt`'s sign; the machine frame has the bolt line along `x`, the mast at `y = -ym`, `z` up
from the bolt line; the azimuth `az` turns the machine frame about the tube.
-/
import RequestProject.Hashemi

namespace TandoorHashemi

/-- the swing at which the wire dies for a given mast: `arctan ((ym ze + hp a)/(ym a - hp ze))`
(`edgeLever_dead`), or a right angle when the pulley is high enough (`ReachesVertical`) -/
noncomputable def deadPoint (ym hp a ze : ℝ) : ℝ :=
  if ym * a ≤ hp * ze then Real.pi / 2
  else Real.arctan ((ym * ze + hp * a) / (ym * a - hp * ze))

/-- the swing at which the receiver's post leaves the dish through the rim: `arctan (a / ze)`
(`rim_under_F_iff`) -/
noncomputable def slotExit (a ze : ℝ) : ℝ := Real.arctan (a / ze)

/-- the wire's lever arm at swing `t` for his clip and pulley (`wireLever` on `edgeClipAt`) -/
noncomputable def leverAt (ym hp a ze t : ℝ) : ℝ :=
  wireLever (pulleyAt ym hp) (edgeClipAt a ze t)

/-- **one step of the machine.**  Inputs: the state `az` (rad) and `t` (rad), the roller's rate
`ωm` (rad/s) and the drum's rate `ωd` (rad/s, positive = take in), the step `dt`; the machine:
`rw` the roller's radius and `R` the ring's (`azRate`), `rDrum` the drum's, the mast's `ym` and `hp`,
the panel's half-chord `a` and its rim's depth `ze = f - sag` below the bolts, the focal length `f`,
the helical pitch `h` of the eyes (`screwTwist`).  Output vector:
`0` az', `1` t', `2` the lever arm at `t`, `3` the tension per unit `W rcm` (`sin t / arm`, the
`wireTension` law), `4` the swing's dead point, `5` the vertex `y`, `6` the vertex `z` (bolt line
= 0; `swungPt` of the vertex `f` below the bolts), `7` the normal `y`, `8` the normal `z`,
`9` F's creep along the bar `h t'` (`helixAdvance`), `10` the post's crossing of the dish plane
`f tan t'` from the vertex (section 14), `11` whether the post is inside the panel (`t' < slotExit`),
`12` the sun-side rim's depth below the bolts at `t'` (`edgeDepth`, for the clearance over the bar) -/
noncomputable def step (az t ωm ωd dt rw R rDrum ym hp a ze f h : ℝ) : Fin 13 → ℝ :=
  let arm := leverAt ym hp a ze t
  let tDead := deadPoint ym hp a ze
  let tRaw := t + elRate ωd rDrum arm * dt
  let t' := if tRaw < 0 then 0 else if tDead < tRaw then tDead else tRaw
  let az' := az + azRate ωm rw R * dt
  let V := swungPt 0 (-f) t'
  let N := swungPt 0 1 t'
  ![az', t', arm, Real.sin t / arm, tDead, V.1, V.2, N.1, N.2, h * t',
    f * Real.tan t', if t' < slotExit a ze then 1 else 0,
    a * Real.sin t' + ze * Real.cos t']

/-- his machine's constants for the step, in its input order after the state, commands and `dt`:
`rw R rDrum ym hp a ze f h` - the drum's radius is not in the video (0.03 m assumed here) -/
noncomputable def stepParams : Fin 9 → ℝ :=
  ![hashemi.rDrive, rollerRadius hashemi, 0.03, ymHashemi, 0.34, dishHalf, Real.sqrt 3.36 - 1,
    dishF, hM12]

end TandoorHashemi

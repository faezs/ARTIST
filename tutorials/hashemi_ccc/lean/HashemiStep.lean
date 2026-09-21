/-
# The machine's step, composed from the spec

One step of Hashemi's machine for the env's kernel, written from the definitions of `Hashemi.lean`
and nothing else, so that `Ccc` compiles it as it compiles them.

The state is the azimuth of the carriage, the swing of the dish about the bolt line, and the
slack of the tow wire; the commands are the two motor rates.  THE WIRE IS THE STATE'S CARRIER:
the winch pays wire in or out at `ωd rDrum` per second (`Winch`, `elRate` with the lever as its
arm), and the dish sits where the wire's length puts it - the length from the pulley to the clip,
`wireLen`, falls from its rest value at `t = 0` to its least at the dead point (`edgeLever_pos_iff`:
the lever `-dL/dt` is positive up to `t*` and zero there, `edgeLever_dead`), so on `[0, t*]` the
swing is the inverse of the length, found by bisection.  Winding past the least length stalls the
winch (`wire_short_of_vertical`: the wire cannot take the dish further); paying out past the rest
length leaves slack on the ground (`wire_taut_iff`: a wire only pulls, gravity is the return
stroke).  The first version of this file divided the wire speed by the lever and stepped the swing
directly; at the dead point that divides by zero and a discrete step overshoots - the env's
raytracer test caught it (2026-09-17).

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

/-- the wire's length from the pulley to the clip at swing `t` (the denominator of `wireLever`) -/
noncomputable def wireLen (ym hp a ze t : ℝ) : ℝ :=
  let P := pulleyAt ym hp
  let C := edgeClipAt a ze t
  Real.sqrt ((C.1 - P.1) ^ 2 + (C.2 - P.2) ^ 2)

/-- one bisection step for the swing whose wire length is `L`: the length falls with the swing on
`[0, t*]`, so the swing is above the midpoint iff the length there is above `L` -/
noncomputable def bisectStep (ym hp a ze L : ℝ) (lohi : ℝ × ℝ) : ℝ × ℝ :=
  let m := (lohi.1 + lohi.2) / 2
  let up := L < wireLen ym hp a ze m
  (if up then m else lohi.1, if up then lohi.2 else m)

/-- the swing at which the wire has length `L`, on `[0, t*]`: 24 bisections (a part in 1.7e7) -/
noncomputable def swingOfLength (ym hp a ze tDead L : ℝ) : ℝ :=
  let lohi := (bisectStep ym hp a ze L)^[24] ((0 : ℝ), tDead)
  (lohi.1 + lohi.2) / 2

open Classical in
/-- **one step of the machine.**  Inputs: the state `az` (rad), `t` (rad), `slack` (m of wire
paid out beyond the rest), the roller's rate `ωm` (rad/s) and the drum's rate `ωd` (rad/s,
positive = take in), the step `dt`; the machine: `rw` the roller's radius and `R` the ring's
(`azRate`), `rDrum` the drum's, the mast's `ym` and `hp`, the panel's half-chord `a` and its rim's
depth `ze = f - sag` below the bolts; the load: the dish's weight `W`, its centre of mass `rcm`
below the bolts, and `Tmax` the most the wire (or the winch) can pull.  The winch winds in only
while the wire holds the dish - `HoldsDish Tmax W rcm arm`, the file's bound `W rcm ≤ Tmax arm`
(`tension_le_of_holds`) - since toward the dead point the arm vanishes and the tension
`wireTension` grows without bound; paying out is gravity's and always allowed.  Output vector:
`0` az', `1` t', `2` slack', `3` the wire's length at `t'`, `4` the dead point, `5` stalled
(1 when the winch asked for less wire than the dead point allows, or more pull than it has),
`6` taut (1 when the wire carries the dish: no slack), `7` holds (1 when `HoldsDish` at `t'`) -/
noncomputable def step (az t slack ωm ωd dt rw R rDrum ym hp a ze W rcm Tmax : ℝ) : Fin 8 → ℝ :=
  let tDead := deadPoint ym hp a ze
  let Lmax := wireLen ym hp a ze 0
  let Lmin := wireLen ym hp a ze tDead
  let Lcmd := wireLen ym hp a ze t + slack - ωd * rDrum * dt   -- the winch's take-in this step
  let short := Lcmd < Lmin
  let L1 := if short then Lmin else if Lmax < Lcmd then Lmax else Lcmd
  let slack' := if Lmax < Lcmd then Lcmd - Lmax else 0
  let t1 := if Lmax ≤ Lcmd then 0 else swingOfLength ym hp a ze tDead L1
  let holds := HoldsDish Tmax W rcm (leverAt ym hp a ze t1)
  let overload := t < t1 ∧ ¬ holds                          -- winding in past what the wire holds
  let t' := if overload then t else t1
  let L' := if overload then wireLen ym hp a ze t else L1
  let az' := az + azRate ωm rw R * dt
  ![az', t', slack', L', tDead, if short ∨ overload then 1 else 0, if slack' = 0 then 1 else 0,
    if HoldsDish Tmax W rcm (leverAt ym hp a ze t') then 1 else 0]

/-- his machine's constants for the step, in its input order after the state, commands and `dt`:
`rw R rDrum ym hp a ze` - the drum's radius is not in the video (0.03 m assumed here) -/
noncomputable def stepParams : Fin 7 → ℝ :=
  ![hashemi.rDrive, rollerRadius hashemi, 0.03, ymHashemi, 0.34, dishHalf, Real.sqrt 3.36 - 1]

end TandoorHashemi

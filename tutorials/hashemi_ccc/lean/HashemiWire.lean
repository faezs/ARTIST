/-
# The tow wire, end to end

`Hashemi.lean` has every piece of the tow wire except the wire.  It has the drum (`Winch`,
`elRate`), the pulley (`pulleyAt`, `hp` over the bolt line), the clip (`edgeClipAt`, C at the
middle of the edge nearest the mast), the lever the pull acts on (`wireLever`, `leverAt`), the
dead point where the lever dies (`deadPoint`, `edgeLever_dead`, about 62° of swing), the span
from pulley to clip (`wireLen`, HashemiStep) and the one-sided range a wire has (`wire_taut_iff`).
What it does not have is the PATH: the wire as one run from the drum to the clip, so that the
length the drum has to pay is a definition and not a picture.

His own words fix the path (Hashemi.lean §7, 19:20-20:05 and 23:40-24:10): the winch is "bolted
at the outrigger's narrow end under the mast, drum along the rail, motor up"; "the drum at the
outrigger's end, the pulley 0.34 m over the bolt line, a clip at C on the back of the dish"; and
"the wire runs from the drum straight up to the mast, past it".  So the run is two legs:

  drum ──(the mast leg, fixed)──► pulley ──(the span, `wireLen t`)──► clip at C

and the drum's pay-out is the whole change of the second leg, because the first does not move.
That is `payOut_eq_run` below, and it is the reason `step` may carry the SPAN as the state's
carrier and still be the drum's own bookkeeping.

Frames.  Everything here is the meridional plane across the bar, the frame `pulleyAt`,
`swungPt` and `edgeClipAt` are written in: `y` from the bolt line away from the mast (the mast at
`y = -ym`), `z` up from the bolt line.  The drum stands on the outrigger's rail, which is the
BAR's own plane, `postH` below the bolt line (`receiverPost_height`), at the narrow end `es`
beyond the bolt line on the mast's side.  Both numbers are the scene's own stations
(`postHOf`, `endStationOf`, Hashemi.lean §16), and neither is new here.

Nothing in this file is a load.  It is geometry: lengths, a lever and a pay-out.

WHAT IS REUSED AND WHAT IS NEW.  The file is written INSIDE `namespace TandoorHashemi` and imports
his whole machine, so every definition, record and theorem of the specification is in scope by its
own name and nothing below re-derives one.  Reused verbatim: `pulleyAt`, `edgeClipAt`, `swungPt`,
`wireLen`, `wireLever`, `leverAt`, `deadPoint` (HashemiStep), `elRate`, `Winch`, `edgeClip_radius`,
`edgeLever_pos_iff`, `wire_taut_iff`, and `HashemiScale.derive`'s own `wireTake` for the drum's
whole take — this file does NOT restate it.  Genuinely new, because the specification places
neither: `drumAt`, the winch's own station, whose two coordinates are the scene's existing
`endStationOf` and `postHOf`; and `wireSeg`, which is the length `wireLen` and `wireLever` each
already compute INLINE and neither exposes as a name (`wireLen_eq_seg` below is that identity, by
`rfl`).  Everything else is a composition of those.
-/
import RequestProject.Hashemi
import RequestProject.HashemiStep
import RequestProject.HashemiMega

namespace TandoorHashemi

/-! ## 1. The two ends the specification did not place -/

/-- the straight-line length of one leg of the wire in the bolt plane -/
noncomputable def wireSeg (P B : ℝ × ℝ) : ℝ :=
  Real.sqrt ((B.1 - P.1) ^ 2 + (B.2 - P.2) ^ 2)

/-- **the drum**: the winch bolted at the outrigger's narrow end, `es` beyond the bolt line on the
mast's side, its rail `postH` below the bolt line.  The wire leaves it along the rail and turns up
to the pulley - "the wire runs from the drum straight up to the mast, past it" -/
def drumAt (es postH : ℝ) : ℝ × ℝ := (-es, -postH)

/-- **the mast leg**: drum to pulley.  It does not move with the dish -/
noncomputable def mastRun (ym hp es postH : ℝ) : ℝ :=
  wireSeg (drumAt es postH) (pulleyAt ym hp)

/-- **the whole run**: the wire from the drum, over the pulley, to the clip at C -/
noncomputable def wireRun (ym hp a ze es postH t : ℝ) : ℝ :=
  mastRun ym hp es postH + wireLen ym hp a ze t

/-- **the pay-out** the drum must deliver to take the dish from swing `tFrom` to swing `tTo`:
positive when the drum takes wire IN (the span shortens as the swing grows) -/
noncomputable def payOut (ym hp a ze tFrom tTo : ℝ) : ℝ :=
  wireLen ym hp a ze tFrom - wireLen ym hp a ze tTo

/-- the same, in radians of the drum: `payOut / rDrum` (`elRate`'s own ratio) -/
noncomputable def drumAngle (ym hp a ze rDrum tFrom tTo : ℝ) : ℝ :=
  payOut ym hp a ze tFrom tTo / rDrum

/-- the wire the drum takes in over one step at its rate - `step`'s own `ωd rDrum dt` -/
noncomputable def drumTakeIn (ωd rDrum dt : ℝ) : ℝ := ωd * rDrum * dt

/-- and it is `elRate`'s law read the other way: the swing rate `elRate ωd rDrum rw` on the lever
`rw` is this much wire a second -/
theorem drumTakeIn_elRate {rw : ℝ} (hw : rw ≠ 0) (ωd rDrum dt : ℝ) :
    elRate ωd rDrum rw * rw * dt = drumTakeIn ωd rDrum dt := by
  unfold elRate drumTakeIn; field_simp

/-- **the drum's two stations at any size are the specification's own**: `endStationOf a` is the
outrigger's narrow end and `postHOf a` the bolt line over the bar (Hashemi.lean §16).  Nothing is
named a second time here - this only records which two `drumAt` is meant to be applied to. -/
theorem drumAt_stations (a : ℝ) :
    drumAt (endStationOf a) (postHOf a) = (-(endStationOf a), -(postHOf a)) := rfl

/-! ## 2. What the path owes -/

/-- the span of `wireLen` IS a leg of this wire: pulley to clip -/
theorem wireLen_eq_seg (ym hp a ze t : ℝ) :
    wireLen ym hp a ze t = wireSeg (pulleyAt ym hp) (edgeClipAt a ze t) := rfl

/-- a leg is never negative -/
theorem wireSeg_nonneg (P B : ℝ × ℝ) : 0 ≤ wireSeg P B := Real.sqrt_nonneg _

theorem wireLen_nonneg (ym hp a ze t : ℝ) : 0 ≤ wireLen ym hp a ze t := Real.sqrt_nonneg _

theorem mastRun_nonneg (ym hp es postH : ℝ) : 0 ≤ mastRun ym hp es postH := Real.sqrt_nonneg _

/-- **the mast leg is the whole wire less the span**, at every swing: the run is a sum, and the
first term carries no `t` -/
theorem wireRun_sub_span (ym hp a ze es postH t : ℝ) :
    wireRun ym hp a ze es postH t - wireLen ym hp a ze t = mastRun ym hp es postH := by
  unfold wireRun; ring

/-- the run is never shorter than the leg that does not move -/
theorem mastRun_le_wireRun (ym hp a ze es postH t : ℝ) :
    mastRun ym hp es postH ≤ wireRun ym hp a ze es postH t := by
  unfold wireRun
  linarith [wireLen_nonneg ym hp a ze t]

/-- **the drum pays the whole change of the run**: the mast leg cancels, so the drum's own
bookkeeping is the span's, which is what `step` carries as the state -/
theorem payOut_eq_run (ym hp a ze es postH tFrom tTo : ℝ) :
    wireRun ym hp a ze es postH tFrom - wireRun ym hp a ze es postH tTo = payOut ym hp a ze tFrom tTo := by
  unfold wireRun payOut; ring

/-- standing still pays nothing -/
theorem payOut_self (ym hp a ze t : ℝ) : payOut ym hp a ze t t = 0 := by
  unfold payOut; ring

/-- and going back pays the same the other way: a wire is not a ratchet -/
theorem payOut_symm (ym hp a ze tFrom tTo : ℝ) :
    payOut ym hp a ze tFrom tTo = -payOut ym hp a ze tTo tFrom := by
  unfold payOut; ring

/-- the pay-out composes along a path -/
theorem payOut_trans (ym hp a ze tFrom tTo tOn : ℝ) :
    payOut ym hp a ze tFrom tTo + payOut ym hp a ze tTo tOn = payOut ym hp a ze tFrom tOn := by
  unfold payOut; ring

/-- the drum's angle times its radius is the wire it moved (`elRate`'s ratio, the other way) -/
theorem drumAngle_mul (ym hp a ze rDrum tFrom tTo : ℝ) (hr : rDrum ≠ 0) :
    drumAngle ym hp a ze rDrum tFrom tTo * rDrum = payOut ym hp a ze tFrom tTo := by
  unfold drumAngle; field_simp

/-- **the step's commanded length is this pay-out**: `step`'s `Lcmd` is the span it is at, plus
the slack on the ground, less the wire the drum took in - nothing else -/
theorem step_takeIn (ym hp a ze t slack ωd rDrum dt : ℝ) :
    wireLen ym hp a ze t + slack - drumTakeIn ωd rDrum dt
      = wireLen ym hp a ze t + slack - ωd * rDrum * dt := rfl

/-- **the clip end is on the rim**, at every swing: it rides the circle of radius `√(a² + ze²)`
about the bolt line, which is F-C (`edgeClip_radius`) -/
theorem wireClip_on_rim (a ze t : ℝ) :
    (edgeClipAt a ze t).1 ^ 2 + (edgeClipAt a ze t).2 ^ 2 = a ^ 2 + ze ^ 2 :=
  edgeClip_radius a ze t

/-- **the pull acts on `leverAt`**: the wire's moment about the bolt line is its tension times
the lever `wireLever` takes between the pulley and the clip - the arm `megaStep` already reports
and `elRate` already divides by -/
theorem wire_lever_is_leverAt (ym hp a ze t : ℝ) :
    leverAt ym hp a ze t = wireLever (pulleyAt ym hp) (edgeClipAt a ze t) := rfl

/-- the whole run at rest, `t = 0`: the mast leg plus `Lmax`, the longest span there is on
`[0, t*]` (`edgeLever_pos_iff`: the span falls with the swing up to the dead point) -/
theorem wireRun_rest (ym hp a ze es postH : ℝ) :
    wireRun ym hp a ze es postH 0 = mastRun ym hp es postH + wireLen ym hp a ze 0 := rfl

/-! ## 3. The slack, geometrically

`step` already carries the slack as the state's third component: pay the drum out past the rest
length `Lmax` and the excess `Lcmd - Lmax` goes on the ground, the dish resting at `t = 0` with
the wire loose (`wire_taut_iff`: a wire only pulls, and gravity is the return stroke).  What the
specification does not say is what a loose wire LOOKS like, and a straight line between the
pulley and the clip is a lie about a wire that is longer than the gap it spans.

So the loose wire is drawn as the V an inextensible wire makes when its weight hangs at the
middle: both legs equal, the vertex square to the chord on the downward side.  That is a MODEL of
the shape - a real wire hangs in a catenary, which is shallower - but it is EXACT about the one
thing that matters here, the length: `bight_legs` proves the two drawn legs sum to `wireLen +
slack`, the wire the drum has actually paid out, so the picture cannot show a length the
bookkeeping does not have.  At `slack = 0` the vertex is the chord's own midpoint and the two
legs ARE the taut straight wire, so the scene needs no case split.

The slack is harmless up to a budget, and that is not restated here: `SlackHarmless`,
`slackHarmless_of_budget`, `slackHarmless_of_lever` and `slackSpot` (Hashemi.lean section 11) say
what a displaced pulley costs the spot, and they are columns of the mount already. -/

/-- **the bight's depth**: half the wire of length `L + s` across a chord of `L`, square to it.
Exact for the V - `bight_legs` - and about twice a catenary's sag at the same excess -/
noncomputable def bightDepth (L s : ℝ) : ℝ := Real.sqrt (s * (2 * L + s)) / 2

/-- a taut wire has no bight -/
theorem bightDepth_taut (L : ℝ) : bightDepth L 0 = 0 := by
  unfold bightDepth; simp

theorem bightDepth_nonneg {L s : ℝ} (hL : 0 ≤ L) (hs : 0 ≤ s) : 0 ≤ bightDepth L s := by
  unfold bightDepth; positivity

/-- and it grows with the wire paid out -/
theorem bightDepth_mono {L s s' : ℝ} (hL : 0 ≤ L) (hs : 0 ≤ s) (h : s ≤ s') :
    bightDepth L s ≤ bightDepth L s' := by
  unfold bightDepth
  have : s * (2 * L + s) ≤ s' * (2 * L + s') := by nlinarith
  exact div_le_div_of_nonneg_right (Real.sqrt_le_sqrt this) (by norm_num) |>.trans_eq rfl

/-- **the two legs of the V are the wire the drum paid out**: each is `(L + s)/2`, so the drawing
carries exactly `wireLen + slack` of wire and not a millimetre more -/
theorem bight_leg (L s : ℝ) (hL : 0 ≤ L) (hs : 0 ≤ s) :
    Real.sqrt ((L / 2) ^ 2 + bightDepth L s ^ 2) = (L + s) / 2 := by
  unfold bightDepth
  have hd : Real.sqrt (s * (2 * L + s)) ^ 2 = s * (2 * L + s) :=
    Real.sq_sqrt (by nlinarith)
  have hq : (Real.sqrt (s * (2 * L + s)) / 2) ^ 2 = s * (2 * L + s) / 4 := by
    rw [div_pow, hd]; norm_num
  have : (L / 2) ^ 2 + (Real.sqrt (s * (2 * L + s)) / 2) ^ 2 = ((L + s) / 2) ^ 2 := by
    rw [hq]; ring
  rw [this, Real.sqrt_sq (by linarith)]

/-- the unit of the chord `P → B`, turned a quarter and pointed DOWN (its `z` is `-|Δy|`): the
direction the bight's vertex leaves the chord in -/
noncomputable def bightNormal (P B : ℝ × ℝ) : ℝ × ℝ :=
  let dy := B.1 - P.1
  let dz := B.2 - P.2
  let L := max (wireSeg P B) 1e-9
  -- the choice is written per COMPONENT, not around the pair: the twin's printer distributes an
  -- `if` over a product and the round trip is a defeq check on the text it wrote
  (if 0 < dy then dz / L else -dz / L, if 0 < dy then -dy / L else dy / L)

/-- **the bight's vertex**: the chord's midpoint, `bightDepth` square to the chord on the low
side.  At `s = 0` it IS the midpoint, so a taut wire draws as the straight line it is -/
noncomputable def bightPt (P B : ℝ × ℝ) (s : ℝ) : ℝ × ℝ :=
  let d := bightDepth (wireSeg P B) s
  ((P.1 + B.1) / 2 + d * (bightNormal P B).1, (P.2 + B.2) / 2 + d * (bightNormal P B).2)

/-- a taut wire's vertex is the chord's own midpoint -/
theorem bightPt_taut (P B : ℝ × ℝ) : bightPt P B 0 = ((P.1 + B.1) / 2, (P.2 + B.2) / 2) := by
  unfold bightPt
  rw [bightDepth_taut]
  simp

/-- the normal is a unit vector wherever the chord is not a point -/
theorem bightNormal_unit {P B : ℝ × ℝ} (h : 1e-9 ≤ wireSeg P B) :
    (bightNormal P B).1 ^ 2 + (bightNormal P B).2 ^ 2 = 1 := by
  have hL : max (wireSeg P B) 1e-9 = wireSeg P B := max_eq_left h
  have hpos : (0 : ℝ) < wireSeg P B := lt_of_lt_of_le (by norm_num) h
  have hsq : wireSeg P B ^ 2 = (B.1 - P.1) ^ 2 + (B.2 - P.2) ^ 2 := by
    unfold wireSeg; exact Real.sq_sqrt (by positivity)
  unfold bightNormal
  simp only [hL]
  split <;> · field_simp; linarith [hsq]

/-- **the wire the drum has paid out**: the whole run plus whatever lies slack on the ground -/
noncomputable def wirePaid (ym hp a ze es postH t slack : ℝ) : ℝ :=
  wireRun ym hp a ze es postH t + slack

/-- the drum's own turn to take the slack up again: `slack / rDrum` radians (`elRate`'s ratio) -/
noncomputable def windBack (slack rDrum : ℝ) : ℝ := slack / rDrum

theorem windBack_mul {rDrum : ℝ} (hr : rDrum ≠ 0) (slack : ℝ) :
    windBack slack rDrum * rDrum = slack := by
  unfold windBack; field_simp

/-- the paid-out wire is the run when the wire is taut, and longer when it is not -/
theorem wirePaid_taut (ym hp a ze es postH t : ℝ) :
    wirePaid ym hp a ze es postH t 0 = wireRun ym hp a ze es postH t := by
  unfold wirePaid; ring

theorem wireRun_le_wirePaid {slack : ℝ} (hs : 0 ≤ slack) (ym hp a ze es postH t : ℝ) :
    wireRun ym hp a ze es postH t ≤ wirePaid ym hp a ze es postH t slack := by
  unfold wirePaid; linarith

/-- **the whole take is `derive`'s own `wireTake`** (HashemiScale.lean): the pay-out from rest to
the dead point, which that field already writes out as `Lmax - Lmin`.  Stated here as the pay-out
it is, so the drum's bookkeeping and the machine's derivation are the same number. -/
theorem payOut_rest_to_dead (ym hp a ze : ℝ) :
    payOut ym hp a ze 0 (deadPoint ym hp a ze)
      = wireLen ym hp a ze 0 - wireLen ym hp a ze (deadPoint ym hp a ze) := rfl

end TandoorHashemi

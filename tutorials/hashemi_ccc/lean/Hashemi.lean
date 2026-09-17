/-
# Hashemi's roof machine, as built: the master design

`RequestProject/Mount.lean` tracks the sun with two rate-limited motors and never says what turns.
`MountCompliance.lean` gives the mount one lumped compliance and never says what bends.
`OpticsSphere.lean` traces the sphere exactly and never says how the sphere is held so that its
focus stays put.  This file is the machine those three are about, taken from Ebrahim Hashemi's
build video (channel *fixedfocus*, "Fixed focus solar concentrator", 30:07,
https://www.youtube.com/watch?v=5rIKy5frygw) one step at a time, in the order he builds it, with
his numbers.  It is a MASTER DESIGN: each section is one stage of the build, the structures carry
the dimensions, and the theorems say what those dimensions commit the machine to.  Sections
arrived with the video; this revision holds the whole build, 0:00-30:07, in fifteen sections,
with the user's corrections where the frames misled.  Nothing is asserted about a stage the
frames have not shown: where they stop, the file says so.

## 1. The fixed base (0:00-2:10)

A ring of 2 cm iron pipe on the roof deck: an upper rail and a lower hoop on short posts, eight
spokes at the ground to a central hub, and in the hub a tube standing higher than the rail with a
foam ring on it - "the tube in the center has a higher height and there is a foam ring on it ...
this foam ring keeps the bearings at the right level".  Two large bearings go on that tube: "it
is not necessary to use the first-class type, and it is sufficient if it is healthy.  You can even
use the second-hand type because the speed of the rotation is very low.  It is enough to put the
bearings on a high level and in the right place."  `FixedBase` holds the rail radius, the rail
height, the tube and the bearing level.  `bearing_life` is his remark made a number: the carriage
turns less than one revolution a day, so a bearing rated for a million revolutions has a margin
of more than a hundred over twenty years.

## 2. The movable base (2:10-4:42)

"Now it's time for the movable base of the system ... made of a two-centimeter iron can", and he
gives its dimensions in a figure shot from above: a bar 184 cm long and 13.5 cm wide with a
roller at each end, and rising from it - IN THE SAME PLANE, which is the thing to see - an A of
base 98 cm and height 80 cm with a cross member 39 cm up and a bearing housing at the apex.
Installed, the A lies flat: the apex bearing drops over the central tube, the two rollers ride
the rail - "this movable base has two independent metal rollers ... one is this metal roller and
the other is this metal roller that rotates easily" - and "the third roller is made of compressed
rubber ... and an electric motor moves it", with "the big iron washer to prevent the rubber ring
from coming out".  That is the carriage of the paper's fig 14 - a bearing on the focal base tube,
two slotted wheels and a rubber drive wheel on a fixed ring, three contacts - and its geometry is
now fixed by his two numbers:

* `rollerRadius`: the rollers sit at the ends of the chord, 92 cm either side of a point 80 cm
  from the apex, so they ride a circle of radius `√(0.92² + 0.80²)` about the tube -
  **1.219 m** (`rollerRadius_hashemi`, `rollerRadius_hashemi_bounds`).  The paper's "2 m ring" is
  this ring's diameter to one figure; the rail is 2.44 m across.  `Fits` is the one condition that
  joins the two structures - the rail radius IS the roller radius - and `hashemi_fits` says his
  base is built to his carriage.
* `azRate`: a drive roller of radius `rw` turned at `ωm` on a rail of radius `R` turns the
  carriage at `ωm rw / R` (rolling without slip), and that is the rate `r` of `Mount.lean`'s
  follower.  `tracks_exactly` is `TandoorMount.follow_exact` with this rate: if the sun's azimuth
  advances no faster than the roller carries the carriage, a carriage that starts on the sun
  stays on it, exactly, in the env's move-then-measure convention.  "The speed of the rotation
  is very low": at Quetta the sun's azimuth never moves faster than about 2°/min (the
  summer-solstice noon), so a 5 cm roller on this rail needs 0.14 rpm (`roller_rpm_hashemi`).

## 2b. Fitting the carriage to the base (4:42-6:30)

"To build this mobile structure, we must first fasten the semi-circular fasteners to the bearings
and then connect and weld the other components.  This method makes work easy and it causes
precision in its construction."  Then: "Before I tighten the semicircular set screws I need to
fix the looseness of the bearings that you can see.  For this, I use a number of small pieces of
iron sheet.  And now I close the screws."  And: "This part can rotate 360 degrees around
itself."  Three facts, and the frames add a fourth: the wheels at the chord's ends are GROOVED
pulleys on the round rail - the paper's "slotted wheels" - so each wheel fixes its radial
position on the rail as well as its height.  That changes the count in section 3, see there, and
it is why the order of assembly matters: the bearings go on the tube first and the frame is
welded around them, so the frame is built to the axis it will turn about and the grooves land on
the rail at the radius that axis defines.  The looseness is the bearing's radial play; the shims
take it out; the clamps lock it.

* `play_budget` is what the play costs.  Whatever the later stages hang on the axis - the focus,
  by `focus_on_axis` - moves with it, so a play `δ` comes straight off the receiver's half-size
  `h` in the pointing budget of `Mount.lean` section 4: `spot f ε + δ ≤ h`.  `shim_negligible`
  is his half-millimetre of sheet against a 6 cm loaf: under one per cent of the budget.
* `tracks_exactly_circ` is the 360°: the azimuth is on the circle with no stop, so the carriage
  is `Mount.lean`'s wrapped follower, `followCirc_exact` at the roller's rate - exact through the
  ±180 seam, the failure this project once had.

## 3. Freedom, constraint, actuation

The FACT expectation for every mount in this project (Hopkins): name the constraint space, the
freedom space it leaves, and the actuation that works on the freedom and not on the constraints.
Screws are `Fin 6 → ℝ`, a twist `(ω; v)` and a wrench `(f; τ)`, and `recip` is the reciprocal
product `ω·τ + v·f` - the power a wrench delivers to a twist.  `wrenchAt p f` is the wrench of a
force `f` applied at the point `p`, `(f; p × f)`.  The azimuth stage has five constraint
wrenches: the tube bearing takes the two horizontal forces at the apex (`wBearX`, `wBearY`), the
foam ring the vertical force there (`wStop`), and the two rollers the vertical forces at the
chord's ends (`wRollP`, `wRollN`).  `yaw` is the twist of rotation about the tube.

* `constraints_reciprocal_yaw`: every constraint wrench is reciprocal to the yaw - the base does
  no work on the azimuth motion, so that motion is free.
* `constraints_linearIndependent`: the five are independent (the chord and the apex height are
  nonzero), so they remove five of the six freedoms and the yaw is ALL that is left.  With plain
  rollers the stage would be exactly determinate - nothing over-constrained to fight, nothing
  loose - and these five are the minimal set.  Two rollers and a bearing at a height different
  from the rail's already block rocking about the chord; the foam ring's job is to set the
  level, which is what he says it does.
* `drive_works_on_yaw`: the rubber roller's traction is a tangential force at the rail, and its
  reciprocal product with the yaw is `F · R`, nonzero for any traction: the actuation is outside
  the constraint space, so the motor turns the carriage and the bearings never see the traction
  as a moment they have to hold.
* **The wheels are grooved, so as built it is over-constrained.**  The paper calls them "slotted
  wheels", and at 10:00 the leg's foot is set on the grooved tire's rod, which settles it.
  `wRollPr`, `wRollNr` are the radial forces a groove exerts, along the lines from the tube out
  to each wheel, and `constraintsGrooved` is the seven-strong set.  All seven are reciprocal to the yaw
  (`grooved_reciprocal_yaw`), so their rank is at most five, and the two dependencies are
  explicit: `grooved_relation_x` and `grooved_relation_y` write the grooves' radial forces as
  combinations of the bearing's horizontal force and the three verticals - the grooves and the
  bearing fix the axis twice over, in `x` and in `y`; `grooved_not_linearIndependent` is the
  corollary.  An over-constrained stage works only if the redundant constraints agree: the circle
  the grooves define must be centred on the tube.  His build makes them agree by construction
  (2b), takes the residual up in the bearing's play, then shims the play out.

## 4. What the next stages must satisfy

Two things the later batches must obey are already forced by this one.

* `focus_on_axis`: a point of the horizontal plane left fixed by a turn about the tube that is
  not a whole number of turns lies ON the tube's axis.  So IF the receiver is to stand still on
  the roof through the day, the focus is over the central tube (the paper calls that tube the
  focal base).  Whether his receiver stands on the roof or rides the carriage is for the video
  to show; the theorem is about the base alone and takes no side.
* `screwLength`: with `TandoorSphere.sag` the rim of a dish of aperture radius `a` on a sphere of
  radius `R` sits `sag R a` toward the focus from the vertex, and the paraxial focus is `R/2`
  (`TandoorSphere.focal_zero`), so a screw that stands the rim off the axis through the focus is
  `R/2 - sag R a` long.  The 2 m sphere with a 2 m dish gives `√3 - 1 = 0.732 m`
  (`screwLength_hashemi`, `screwLength_hashemi_bounds`) - the paper's 73 cm screws; the video's
  dish is the 1.6 m chord of section 5b, for which it is `FH = √3.36 - 1 = 0.833 m`
  (`FH_eq`, `FH_bounds`).  Either way it is the caption's "the length of the screw passed from
  the edge of the dish should be such that the focus distance from the centre of the dish is the
  same in all cases".

## 5. The two legs (8:00-9:30)

"In order to install this solar dish on the moving part, we need to install two legs on the
moving part.  These foundations should be such that they can provide two horizontal and vertical
movements of the dish.  Of course, horizontal movement is easy, but vertical movement by the legs
should be like swinging.  And the vertical movement should be such that the dish is always
perpendicular to the supposed circle of focus."  Then the legs themselves, "two base numbers ...
both of these bases are the same size and have neither left nor right", with a figure shot from
above: a 130 cm upright, a 62 cm foot across its end, a 96 cm knee brace from the foot's long end
to the upright, "four holes on the base".  And where they go: "a base for this side that is
placed like this ... and another base for the other side ... these bases must be installed with
screws ... I mount this on one side of the moving part like this ... this base was installed so
easily" - one at each END of the carriage's chord bar, the upright vertical at the bar's end by
the roller, the foot lying ALONG the bar and screwed down into the rail (the drill at 9:30 drives
into the rail's top), its long side cantilevered outboard past the end, so the brace triangle
stands in the bar's own vertical plane, outside the post.  Both wide shots, 9:40 and 9:55, show
the triangle that way.  And its purpose in his words: "the chord of the triangle on the base
prevents bending of the vertical base".  At 10:00 the foot is seen to sit ON THE GROOVED WHEEL'S
AXLE ROD at the bar's end - the post stands directly over the wheel - and the carriage is turned
through four azimuths with the leg on it: it spins.  "Now I do this part in the same way": the
second leg at the other end, foot on the wheel's axle block, a bracket bolt to the rail
(10:08-10:11), both uprights vertical and both braces leaning outboard (10:17-10:24): "now both
the main bases of the dish are ready".  Then the rule for the upright's length - "pay attention
that the length of the vertical base should be suitable for the vertical movement of the dish
and is calculated according to the figure" - and the figure, "Calculation of the length of the
base of the solar dish holder": the post drawn spanning from the dish's lowest point up to
about F, at both ends of the travel.  At noon the dish lies at the bottom of the focus circle
and its vertex is `f` = 1 m below F; at low sun the dish stands at the side of the circle and its
lower edge B is `a` = 1 m below F.  His 130 cm is that metre and 30 cm over.  The dish in every
frame is a square-ish panel of mirror tiles on a backing, leaning on the wall; it is not on the
machine yet.

* `Leg`, `hashemiLeg`: the figure's numbers.  `braceHeight` is where the brace lands on the
  upright, `√(96² - 44.5²) = 85 cm` (`braceHeight_hashemi`), with the foot's 17.5 cm short side
  read off the figure.
* `brace_cuts_moment`, `brace_stiffens`: his sentence about the chord, as numbers.  A horizontal
  pull at the post top - the dish's, along the bar - bends an unbraced post over its full 130 cm;
  braced at 85 cm it bends over the 45 cm above the brace, so the peak bending moment is 0.35 of
  the unbraced one and, going as the cube of the free length, the top is stiffer by a factor of
  more than 24 in the plane of the bar.
* `postTop`: the tops in the carriage's frame (tube at the origin, chord along `y`).  What is
  MEASURED and nothing more: the two tops are level (`postTops_level`), `upright` above the bar,
  a chord apart less the end offsets (`postTops_apart`), and on the chord line `apexH` from the
  tube's axis (`postTops_offAxis`).  With the foot on the wheel's rod the end offset is zero,
  and then `postTop_on_rail`: the post's horizontal position IS the wheel's, on the rail circle,
  `rollerRadius` = 1.22 m from the tube - so the post's load goes straight down through the
  wheel onto the rail, and the bar carries none of it in bending.
* `AlwaysTangent` is his requirement on the vertical movement, as stated: at every elevation the
  vertex plus the focal distance along the normal lands on F - "always perpendicular to the
  supposed circle of focus".  `alwaysTangent_focusCircle` is his diagram, proved from that
  sentence alone: a dish that is always tangent has its vertex on the circle of radius `f` about
  `F`.  HOW the legs make the dish swing so is not in these frames, and the file does not say.
* `edgeDepth` is the length rule as a function of elevation: a dish always tangent to the focus
  circle has its lower edge `(f - sag) sin el + a cos el` below F.  The first figure checks the
  two ends of the travel - `edgeDepth_horizon` gives `a` at the horizon, and at noon the vertex
  itself is `f` down - but the edge reaches deepest BETWEEN them: `edgeDepth_le` bounds it by
  `√((f - sag)² + a²)`, attained where `tan el = (f - sag)/a`.  His second figure (10:40, below)
  computes exactly that length for his dish and labels it "Base": `FC` = **1.155 m**.

## 5b. His dish, from the geometry figure (10:40)

"A circle with a radius of two meters and a segment of a circle with a length of 1.6 meters as a
solar dish."  A is the centre, `AB = AD = AC = 2 m`; D the vertex; F the "dish focal point",
`AF = FD = 1 m`; B-C the dish, `BC = 1.6 m`, H its midpoint, `BH = HC = 0.8 m`; and the segment
F-C is labelled "Base".  He works it: `AC² = HC² + AH²` gives `AH = √3.36`, so `HD = 0.167 m`
and `FH = 0.833 m`; `FC² = HC² + FH²` gives `FC = 1.155 m`.  In the file: `dishR`, `dishF`,
`dishHalf` are the three givens; `HD_eq`/`HD_bounds` recover his sag as `TandoorSphere.sag 2 0.8
= 2 - √3.36`; `FH_eq`/`FH_bounds` recover `FH` as `screwLength 2 0.8 = √3.36 - 1` - the screw
length for THIS dish, 0.833 m, where the paper's 2 m dish gives 0.732; `FC_eq`/`FC_bounds`
recover `FC = √(5 - 2√3.36)` and identify it with the bound of `edgeDepth_le`: the deepest the
rim reaches below F.  So the upright is sized to FC: `hashemi_clearance`, 130 cm against
1.155 m, **14.5 cm** to spare at the worst elevation, `tan el = FH/HC`, 46°.  (The earlier
revision of this file put the dish at 2 m and found 6 cm; the figure fixes the dish at 1.6 m and
the number with it.)  What the figure does NOT say is how the dish is held so that it turns
about F; "Base" names a length, and the file takes it as no more than that.

## 6. The swing: four hanger legs on two pivot bolts (10:43-12:10)

"Of course, I have considered the length of this base to be 130 cm, because the distance of the
hole above the base should also be taken into account.  The important point here is that our
dish is bigger than the previous one and it cannot be hung with two legs.  And it needs four
hanging legs.  These four hanging legs act like swing chains.  I made four hanger legs like this
and used threaded rod and carefully welded the ends to the iron nut.  Of course, you can use
bearings instead of nuts.  Two for one side and two for the other side.  We choose two screws
with the right diameter, which we must install on top of the vertical posts.  These two screws
must be able to bear the weight of the entire solar dish and are of particular importance.  The
screws are placed like this.  Nuts welded to threaded rods are bolted at the proper distance."
The frames: four threaded rods of about 10 mm, each with a nut welded on one end as its eye; two
bolts, each pushed horizontally through the hole near a post's top, pointing INWARD along the
chord at the other post, with that side's two hanger eyes side by side on its shank and a nut
holding them at a set gap.  So each side's pair leaves one pivot as a V to two points on the
rim, and dish plus four hangers is one rigid body about the bolt line - which is why "it cannot
be hung with two legs".

So the elevation axis is the line through the two bolts, the dish hangs below it on the four
hangers, and dish plus hangers is a rigid pendulum about that line.  Because the hangers are
threaded, the nuts at the rim set their length, which is the caption's "the length of the screw
passed from the edge of the dish should be such that the focus distance from the centre of the
dish is the same in all cases" - the screws ARE the hangers, and their setting puts F on the
bolts.  (Corrected twice: this revision first took the figure's "Base" F-C, 1.155 m, for the
hanger; the swing frames suggested the CORNERS, 1.03 m; the user then placed the rim holes at
the middle of each half of the edge, `y = ±a/2` = ±0.4 m, each rod about 27° off the vertical.
The length that puts F on the bolts is eye to that hole, **0.88 m** (`hangerLength_halfEdge`).
F-C stays what section 5b made it: the deepest reach of the fore and aft edges below the bolt
line, which sizes the post - and, section 11, the tow-wire clip's radius about the bolts.)

* `swingVertex`, `swingNormal`: the pendulum - the vertex `f` from the pivot along the hangers,
  the normal pointing back at the pivot.  `swing_alwaysTangent` **discharges section 5's
  requirement**: hung so, the dish is always tangent to the focus circle about the pivot, so F is
  the pivot; `swing_focusCircle` is then his diagram for this mechanism.
* `clearance`: the hole sits `holeDown` below the post top, so what is left over the bar at the
  worst elevation is `upright - holeDown - FC` (`clearance_hashemi`), FC being the fore and aft
  edges' deepest reach: 14.5 cm less the hole's drop.  At 12:10 the far post's bolt sits about 5 cm below its top, and the stub points along
  the chord at the other post - the bolts are the axis - so about 9.5 cm is left, which is what
  "the distance of the hole above the base should also be taken into account" is about.
* The two bolts carry the dish between them, each hanger a quarter of it at rest; the bolt
  diameter is not given in the frames, only that it must be "right" - M12, the user
  (2026-09-17), with the eyes turning on the thread: section 12.
* Where the eyes sit on the bolt (12:40-13:00): "if the threaded rods is placed at the beginning
  of the main screw, the weight of the dish will cause more pressure to the vertical legs.
  Therefore, it is better to direct them to the end of the screw as much as possible."  The
  frames show a nut between the post face and the eyes as the spacer.  The hangers swing in a
  plane parallel to the post's face, offset from it by where the eyes sit, so pushed to the
  beginning they bear on the post through the swing and pushed to the end they clear it:
  `HangerClearsPost` is that condition, the eye offset beyond the rod's half-thickness, and
  `hashemi_eyes_clear` his spacer nut against his 10 mm rod.

One consequence, stated and not resolved: the bolt line is the chord line, `apexH` = 0.80 m from
the tube's axis (`postTops_offAxis`), so F sits there and, by `focus_on_axis`, a receiver fixed
to the roof would see it go round a 0.8 m circle through the day.  Either the receiver rides the
carriage, or something not yet shown moves F.  The frames have not shown the receiver.
(Resolved at 27:30, section 14: the receiver stands on a post below F, rising from the
carriage through the slot in the dish - it rides the carriage.)

## 7. The vertical-movement stand: an outrigger, a motor with gearbox, a pulley mast (13:20-15:20)

"We use one of the threaded rod for one side of the dish and the other for the other side.
Another vertical stand for vertical movement should be installed here, and it is better to
install it before installing the dish, because the dish will interfere with our installation.
The part that should perform the vertical movement of the dish is fixed, due to the size of the
dish, outside the circular axis of the base.  Therefore, we use a structure to connect it with
the horizontal axis.  This is where our motor with gearbox fits.  So I install it first.  This
is how the screws are screwed.  This part is very strong and can easily support even my weight.
So it can easily bear the weight of the dish.  I made this vertical stand as you can see.  I
have placed a metal pulley on top of it, as you can see.  The two bent legs on its side are
vertical due to the strength of the leg, and you can see its dimensions in the figure.  Now I
bolt and install it on the system like this."

The frames.  The OUTRIGGER (14:13-14:51): a frame of two rails with cross members, splayed to a
narrow end, bolted to the carriage's bar and reaching out past the ring; at its narrow end a
grooved pulley on an axle between the rails, where "our motor with gearbox fits"; he leans his
weight on it.  The STAND (14:55-15:20), with a figure shot from above: a 159 cm post on a 184 cm
foot bar, two bent legs from the foot's ends curving up 41 cm to the post; a metal pulley at the
post's top; bolted onto the outrigger, standing vertically outside the ring beside the second
leg.  So the elevation drive is a motor with gearbox on an outrigger and a pulley 1.59 m up a
mast outside the ring, and its hardware goes on before the dish because the dish would be in the
way.  It is the tow-wire drive of the paper's fig 17 in its parts.

* `DriveStand`, `hashemiStand`: the figure's numbers.
* `Outrigger`: what the frames give of it - it joins the stand to the carriage, and the motor
  with gearbox sits at its end - with no dimensions, because the video gives none.  Its shape
  and stations are read off the frames in section 11 (`OutriggerGeom`, `hashemiOutrigger`).
* `pulley_above_pivot`: the one relation the two figures fix between them: the stand's pulley
  sits `1.59 - (1.30 - holeDown)` above the bolt line, **0.34 m** with the bolt 5 cm below the
  leg's top.  Where the wire runs from that pulley to the dish, and how "one threaded rod for
  one side and the other for the other side" is rigged, the frames had not shown at this point;
  the path arrives at 23:40 (section 11): drum, pulley, a clip on the back of the dish.

## 8. The stand on the outrigger, the dish in, the rods closed to the corners (15:20-19:20)

"There is some slack that won't be a problem in practice.  The engine and gearbox will be placed
here, which I will install later.  Now I place the dish on the system.  Well, now we close the
threaded rods to the solar dish.  I closed all four threaded rods and you can see that it can
move like a cradle.  The length of the screw passed from the edge of the dish should be such
that the focus distance from the centre of the dish is the same in all cases.  In fact, the dish
should be tangent to the focus circle.  Here, because our dish is a circle with a radius of two
meters, so the focus distance of the dish is one meter.  Because the edges of the dish have a
special curve, you can cut two pieces of pipe diagonally to the right size and place them under
the beads [nuts].  You can see that the dish can easily move in the vertical axis.  And
horizontal movement is also done in this way.  Well, let's go to the installation of the engine
and gearbox for vertical movement."

The frames.  THE STAND ON THE OUTRIGGER (15:20-16:32): the outrigger's two rails run from the
carriage bar out past the ring to their narrow end, where a V-groove pulley sits on a bolt axle
between them; the stand's foot bar lies across the rails and is bolted to them, the post stands
on it with its two bent legs down to the rails.  He rocks the post by its top - that is the
slack - and puts his hand at the outrigger's end by the pulley for the motor with gearbox,
"which I will install later".  Three posts stand: the two legs at the bar's ends, each with its
bolt and a V of two hangers already hanging, and the taller mast outside the ring with the
pulley on top.  THE DISH (16:32-16:57): a square panel of mirror tiles on a tan fibreglass
backing with a flat flange round its edge, light enough for one man; it goes in face up between
the posts and rests on the ring and the carriage.  Along its centre line, from one rim to the
middle, a straight feature: a flat strip lying on the face (loose - it lifts at the rim in one
frame) and a bright line at the same place from the back; slot or seam, the frames do not say.
THE RODS CLOSED (17:00-17:34): each hanger passes through a hole in the flange of the edge
nearest its post - the wide shots suggested the corners; the user (2026-09-17) places the holes
at the middle of each half of the edge, `y = ±a/2`, each rod about 27° off the vertical, the
pair a V of about 55° - a nut on the face side, a nut below, two wrenches.  Then the swing by hand, the figure of section 5b again, and
the "Tube with x degree cut" figure: one post, two rods from its top to two points on the dish's
arc, a tube on one rod between the two nuts - the diagonally cut pipe that seats the nut on the
flange where the rod meets it at an angle.  Then elevation by hand, azimuth by hand (the whole
carriage walked round the ring), and the motor is next.

What follows from it:

* `dish_between_posts`, `sideGap`: the 1.6 m panel between posts a 1.84 m bar apart leaves
  **12 cm a side** before the post's inset - the hangers drop from the bolt's end to a flange
  just inboard of the post, as the frames show.
* `hangerLength`: the hanger that puts F on the bolt line is eye to rim hole -
  `√(dx² + yr² + (f - sag)²)` with the hole `yr` along the edge and the eye `dx` outboard of
  the edge line.  `hangerLength_halfEdge`, `hangerLength_bounds`: at the middle of the half
  edge, `yr = 0.4`, eye over the edge line, **0.884 m** (`√(4.36 - 2√3.2)`); an eye 9 cm
  outboard adds 5 mm in quadrature.  `rodTan`, `rodTan_bounds`: the rod leans
  `0.4 / (f - sag)` off the vertical, tan 0.507, **27°**, the pair a V of 54° (the user: about
  60°).  `hashemiHanger` is corrected to this; section 6's 1.155 m was F-C, which the post is
  sized to, not the hanger, and 1.03 m was the corners.
* `swingVertexAt`, `swingFocus`, `swingFocus_circle`, `swingFocus_fixed_iff`: **his rule for the
  nuts as a theorem**.  With the vertex `d` from the bolts (what the nuts set) and the focus `f`
  from the vertex, the focus rides a circle of radius `|d - f|` about the bolts through the
  swing, and stays put for every swing angle exactly when `d = f` - "the focus distance from
  the centre of the dish is the same in all cases".  Section 6's `swing_alwaysTangent` is the
  case `d = f`.
* `setLength`, `setLength_surj`: the clamp makes the rim point a fixed point on its rod, which is
  what the rigid pendulum assumed, and the nuts set any length up to the rod's, continuously.
  What they set is the one pointing freedom no drive reaches: a difference `e` between the two
  sides' lengths drops one edge by `e` and tilts the dish `e / 1.6` about the horizontal axis
  across the bar (`tiltOfMismatch`), and that roll is outside the span of the yaw and the swing
  (`tilt_not_driven`; `swing_yaw_independent` is the two freedoms he shows by hand).  A fore-aft
  difference within one side only turns the dish about the bolt line, which the elevation drive
  re-zeroes.  Conditional on the rod being M10 (10 mm read off the frames; coarse pitch
  1.5 mm), one turn of a rim nut is `one_turn_tilt` = **0.94 mrad**, under a quarter of the
  sun's half-angle, 0.94 mm at F - a one-time alignment set to a fraction of a turn.
* `cosTubeCut`, `cosTubeCut_bounds`: the x of his "Tube with x degree cut", if the flange
  continues the panel's surface at the hole: the angle between the hanger and the sphere's
  normal there has cosine 0.888 - **x = 27°**.
* `SlackHarmless`: his claim about the mast, as section 2b's play budget with the mast's play in
  it.  The play reaches the dish through the wire, whose path is not yet shown, so the spot
  shift it causes is a parameter; discharging the claim waits for the wire.
* `Outrigger.motorAtEnd` is confirmed by "the engine and gearbox will be placed here", at the
  narrow end by the pulley, still uninstalled at 19:20.

## 9. The winch, and the struts against the legs' lean (19:20-20:50)

"Well, let's go to the installation of the engine and gearbox for vertical movement.  This
engine with a gearbox, along with an additional gearbox and a wire collecting roller, all work
like a winch.  Also, I installed the towing wire on its grooved roller and it easily supports
the weight of the dish.  And here is the place to install it.  The installation of the vertical
dish lift has been completed.  And later I will connect the towing wire to the dish.  One
problem is that when the dish is directed upwards in one direction, the vertical legs tilt
towards the dish.  In order to prevent this from happening, we must use foundations in the
opposite direction of the deviation of the vertical foundations.  I prepared two bases with
suitable length and install each on one side."

The frames.  THE WINCH (19:20-20:05): a motor standing on a gearbox, a second gearbox, and a
flanged grooved drum with the wire already wound on it, one unit on a bracket; bolted at the
outrigger's narrow end under the mast, drum along the rail, motor up.  The bronze V-pulley
stays on the outrigger's centreline between the ring and the winch.  The wire hangs loose from
the drum: "later I will connect the towing wire to the dish".  THE LEAN (20:10-20:50): with the
dish swung far he rocks a post by its top - the legs lean toward the dish.  His fix: two struts,
one per leg, each from the post at about the brace's height diagonally down to the outrigger's
end beside the mast, drilled and bolted at both ends; no length given.

What follows from it:

* `Winch`, `elRate`, `el_tracks_exactly`: the drum pays wire at `ωd rDrum`; on a lever arm `rw`
  about the bolt line that is an elevation rate `ωd rDrum / rw`, `azRate`'s law again, and
  `Mount.lean`'s exact follower again: a winch that can outrun the sun's elevation keeps the
  dish on the sun.  Drum, ratios and motor are not given, so they are parameters.
* `wire_recip_swing`: the wire's pull as a wrench at its rim point against the swing twist -
  **the wire drives the swing by its moment about the bolt line**, `q_y f_z - (q_z - zBolt) f_y`,
  whatever the rim point and the direction turn out to be.
* `wireTension`, `wire_taut_iff`, `HoldsDish`, `tension_le_of_holds`: the pendulum hung `rcm`
  below the bolts and swung to `t` needs a moment `W rcm sin t`, which a wire on lever arm `rw`
  gives at `W rcm sin t / rw`.  **A wire only pulls**: the tension is non-negative exactly when
  `sin t ≥ 0`, the dish swung toward the wire's side; the return stroke is gravity's and the
  range is one-sided, which the sun allows.  "It easily supports the weight of the dish":
  `HoldsDish` is the winch's holding tension covering the dish on its side, `sin t = 1`, and
  then every swing angle is covered.
* `strutStrain`, `strut_resists_lean`: a strut from `P` on the post to `Q` on the outrigger
  resists motion of `P` along its own axis; the lean toward the dish, `(-ε, 0, 0)` for the post
  at `+x`, shortens it exactly when the outrigger end is inboard of the post - "in the opposite
  direction of the deviation", and that is where he runs it.  The cause of the lean is not
  shown; a reading, not a theorem: leg, brace and foot are one triangle, and the foot only RESTS
  on the wheel's axle (section 5), so an inward pull at the top turns the whole leg about its
  bolts to the bar - the brace cannot stop a motion of the body it belongs to; the strut ties
  the post to a second body, the outrigger.

## 10. The level, the second strut, the panel and the box (20:50-23:20)

"To know that we have done the work correctly, we use a level.  I'm going to place this
alignment on top of the vertical base and the base should be vertical.  Now I will install the
other diagonal support.  Now you can see how much effect it had on the stability of vertical
foundations.  And the support bases of the solar dish will not be inclined anymore.  Now we go
to the installation of the solar panel.  By installing a small 5 watt panel, we can supply the
system's motion energy because the electric motors of this system have very little consumption.
In fact, this panel charges the battery, and the battery transfers electrical energy to the
motors, and horizontal and vertical movement is performed.  This five-watt panel is suitable and
easily performs the work of the system, but you can also use a 10-watt panel.  The installation
of the panel was done and the communication wire of its charge control is directly connected to
the battery.  Well, here we need to install the appropriate box to control the system.  So here
I install a box called system control box."

The frames.  THE LEVEL (20:50-21:10): a spirit level held against a post's upper part.  THE
SECOND STRUT (21:14-21:40): from the far post at mid-height to the same outrigger end, so the
two struts meet at the winch; with the two posts and the outrigger they close a pyramid.  THE
PANEL (21:50-22:50): a framed 5 W module, a hand's breadth square, on a bracket on the carriage
bar at one post's foot, tilted face up; its charge-control lead to a battery.  THE BOX
(22:50-23:20): a steel enclosure marked "DC.P", three holes in its face, on the bar at the other
post's foot; what is in it is not shown.  Panel, battery and box all ride the carriage:
everything electrical turns with the azimuth, and the panel faces where the dish faces.

What follows from it:

* `pointVel`, `yaw_lifts_nothing`, `swing_lift`: a twist's velocity at a point.  The yaw about
  the tube lifts no point - **the azimuth does no work against gravity** - and the swing lifts a
  point at `y` at the rate `y` per unit angular rate: the pendulum's centre of mass at
  `rcm sin t`, which is `elPower`.
* `elPower`, `elPower_eq_wire`, `elPower_le`, `tracking_power_tiny`: the winch's work rate is
  `W rcm sin t ω`, the wire's tension times its speed, at most `W rcm ω`; at the sun's rate
  (never above the Earth's 15°/h, 7.3e-5 rad/s), for any dish under 100 kg hung with its centre
  within `f` of the bolts, **under 0.073 W - 1.5 % of the 5 W panel**.  "Very little
  consumption" is, on the mechanical side, a theorem; motor and gearbox losses are not given.
* `Panel`, `hashemiPanel`: 5 W; "you can also use a 10-watt panel".
* `focusShift`, `lean_one_degree`, `plumbed_shift`: **why the posts must stand vertical**.  F sits
  on the bolts, so a lean `ε` of a post moves F by `h sin ε` at the bolt height: an unbraced lean
  of one degree at 1.25 m is **over 2 cm**, and a post plumbed to a builder's level (0.5 mm/m - a
  typical figure, not a caption) is under 0.7 mm.  The struts make the lean static and the level
  checks it: "the base should be vertical" is a requirement on F.

## 11. The box, the cables, and the tow wire to the back of the dish (23:03-24:10)

"This box is where the control circuit and battery and connections are located.  I use a 1.5
single pair cable for the electrical connection between the solar panel and the electric motor
with a horizontal gearbox and the winch related to the vertical movement with the system
control box.  I use a cable that is resistant to sunlight and rain.  And I am wiring these two
cables for the solar panel and the electric motor for horizontal movement like this.  First, I
have to raise the dish on the reverse side to free up the work space.  The cable is pulled and
now we are going to pull the towing wire between the winch and the solar dish.  The tow wire
needs to be tied under the solar dish so I bring the dish up.  I connect it to the back of the
solar dish with a fastener suitable for the towing diameter."

The frames.  THE BOX AND THE CABLES (23:03-23:35): the "DC.P" box holds the control circuit, the
battery and the connections; three runs of 2 × 1.5 mm² sun- and rain-resistant cable along the
bar - the panel, the azimuth motor ("electric motor with a horizontal gearbox"), the winch - all
to the box.  Everything electrical rides the carriage: no slip ring.  THE TOW WIRE
(23:40-24:10): he swings the dish by hand to clear the space, pulls the wire from the drum up
over the mast's pulley and down to the BACK of the dish, swung up with its back toward the mast,
and fixes it there with a wire-rope clip "suitable for the towing diameter".  Which point of the
back the frames do not fix; the user (2026-09-17): the clip is on the edge nearest the pulley,
halfway between the corners - the figure's C - and the wire is clipped again at the centre of
the back, so its pull on the dish acts at C, the last contact before the pulley.  The wire's
diameter is not stated.  So section 7's open path is: the drum at the outrigger's end, the
pulley 0.34 m over the bolt line, a clip at C on the back of the dish.  Winching in pulls the back toward the mast and turns the face away from it: the
mast is the shadow side of the machine, the dish faces the other way, and that is the one-sided
range of `wire_taut_iff`.

What follows from it:

* `wireLever`, `pulleyAt`, `swungPt`, `edgeClipAt`, `edgeClip_radius`, `edgeClip_cross`,
  `wireLever_rest`: with the pulley `ym` beyond the bolt line and `hp` above it, and the clip
  at C - `a` toward the mast, `ze = FH` below the bolt line at rest, so on a circle of radius
  F-C = 1.155 m about the bolts (`edgeClip_radius_hashemi`: his "Base" once more) - the wire's
  moment about the bolt line has the sign of `(ym ze + hp a) cos t + (hp ze - ym a) sin t`; at
  rest the arm is `(ym ze + hp a) / √((ym - a)² + (hp + ze)²)`, 1.03 m with the mast 1.2 m out.
  `hp` = 0.34 is section 7's `pulley_above_pivot`; `ym` is not given.  This is the `rw` of
  `elRate`, `wireTension` and `HoldsDish`.
* `edgeLever_pos_iff`, `edgeLever_dead`: **the edge clip has a dead point**.  The wire turns
  the dish exactly while `tan t < (ym ze + hp a)/(ym a - hp ze)`, and its moment vanishes where
  the clip reaches the pulley's ray from the bolt line: `t* = arctan(ze/a) + arctan(hp/ym)`,
  the clip's own 46° below the horizontal plus the pulley's elevation seen from the bolts.
* `edgeClip_reach`, `MastClears`, `mastClears_hashemi_iff`: the clip swings out to F-C from
  the bolt line, so **the mast must stand beyond 1.155 m** - at least 1.2 m.
* `deadTan_hashemi`, `sixty_reachable`: with the mast at that closest 1.2 m, `tan t*` is
  1.878-1.88, **62° of swing**, and the wire runs out at the same place (9 cm left between
  clip and pulley): the lowest sun the wire reaches is 28° up.  60° of swing - the sun 30° up,
  Quetta's winter noon at 36° inside it - is within the range.  A mast farther out shortens
  the range toward 46°; a taller mast lengthens it.
* `ymHashemi`, `mastClears_hashemi`, `deadTan_at_ym`, `wireLeft_at_ym`, `wireLever_rest_at_ym`:
  `ym` read off the frames.  Two shots along the bar (20:50, 20:55) put the mast's foot 312 px
  from the bar's midpoint at 255 px/m of its own 1.59 m, and 285 px at 230 px/m: **1.22 m**,
  give or take a decimetre - right at the floor `MastClears` sets, 1.155 m plus the mast's
  half-width and a hand's clearance.  At 1.22 the dead point is at tan 1.859-1.86, **61.7°**,
  with **11 cm** of wire left between clip and pulley; the lever arm at rest is **1.03 m**; the
  winch takes in 1.25 - 0.11 = 1.13 m of wire over the swing; the lowest sun the wire reaches
  is 28° up.
* `OutriggerGeom`, `hashemiOutrigger`, `ym_is_standStation`, `mast_beyond_ring`: the appendage
  the mast sits on, read off 14:24-14:51.  Two rails leave the bar at the A's feet, `aBase` =
  0.98 m apart, and taper over about 1.35 m to a narrow end about 0.25 m across, where the
  bronze pulley sits at 14:29 and the winch later; a cross member with bolts part-way down is
  where the stand's foot bar - 1.84 m, the carriage bar's own stock - lies across the rails,
  and the mast stands on the centreline there.  `ym` IS that station, 1.22 m; the mast's foot
  is then `apexH + ym` = 2.02 m from the tube's axis, well beyond the ring's 1.22 - "outside
  the circular axis of the base".
* `slackSpot`, `slackHarmless_of_lever`: the mast's play now has its path to the receiver.  A
  pulley displaced by `δ` changes the wire's length by at most `2δ` (the two segments' unit
  vectors sum to at most 2), the dish turns `2δ / rw`, the spot moves `2 f δ / rw` (paraxial) -
  section 8's `SlackHarmless` with that in for its parameter.
* `cableArea`, `rhoCu`, `cableDrop`, `cable_drop_small`: 1.5 mm² copper, both conductors of the
  pair, a run of at most 4 m and a current of at most 1 A (the motors' draw is not given; 5 W at
  12 V is under half an ampere): **under 0.1 V**.

## 12. The hangers as joints: the motion through the connection (the 17:50-19:06 frames again)

The frames of the swing, seen again for what the connection is.  THE EYE: a nut on the bolt's
shank, turning about it - "you can use bearings instead of nuts" - a revolute joint about the
bolt line; both eyes of a side on one bolt, the two bolts pointing at each other along the
chord, so all four rods hinge on ONE line.  THE RIM END: a rigid clamp - the nut above, the nut
below, the tube with the x-degree cut seating it on the curved flange - so each rod is one body
with the dish.  Dish and four rods are therefore one rigid body on one hinge line, and what the
frames show is that body turning: the near edge dropping (17:50, the mirror face catching the
light) and rising (17:52, the back toward the camera), then the whole thing by hand at 18:56
and the carriage walked round at 19:06.  A pin at the rim instead of a clamp would have left a
second freedom - the dish sliding along the bar on its four rods as a four-bar - and the clamps
are what remove it.

What follows from it:

* `hingeWrench`, `hinge_reciprocal_swing`: the eye as its five constraint wrenches at the eye's
  place - three forces and the two moments across the bolt - all reciprocal to the swing.
* `hinge_freedom`, `hinge_freedom_smul`: **the motion through the connection**.  A twist the
  eye lets through has no turn across the bolt and no slide: it is `(ω, 0, 0, 0, zBolt ω, 0)`,
  `ω • swingTwist` - the turn about the bolt line and nothing else.  With the rods clamped to
  the rim, that is the dish's freedom: one.
* `second_hinge_redundant`: the second eye on the same line adds no constraint - each of its
  five wrenches lies in the first's span.  Two coaxial hinges are one hinge with five redundant
  constraints, a door on two hinges; "bolted at the proper distance" and the shims are what
  carry the redundancy, as the shims did for the seven constraints of the grooved wheels.
* `helixAdvance`, `helixAdvance_small`: an eye that threads on the bolt makes the joint
  helical, and the swing screws the eye along the bolt - under a third of a millimetre over the
  wire's 62° on M12.
* THE USER (2026-09-17): the bolts are M12 and the eyes turn on the thread.  So the joint is the
  helical one, not the plain hinge: `hM12`, `screwTwist`, `screwWrench`, `screw_reciprocal`,
  `screw_freedom` - a twist the threaded eye lets through is `(ω, 0, 0, h ω, zBolt ω, 0)`, the
  swing plus `h = pitch / 2π`, 0.28 mm of travel along the bolt per radian on the coarse 1.75 mm
  pitch; the hinge is the case `h = 0` (`screwTwist_zero`).  The fifth constraint is no longer
  the axial force alone but the axial force paired with the moment `-h` about the bolt - what
  the thread turns a push into.  Both eyes ride the same screw, so the dish, and F on the bolt
  line with it, walks along the bar `h φ` over a swing `φ` - under 0.31 mm over the wire's 62°
  - and there is no binding, since a right-hand thread advances the same way about the same
  turn whichever way its bolt points.
* `boltStress`, `m12_carries_dish`: "these two screws must be able to bear the weight of the
  entire solar dish": the eyes at the end of the shank, 3 cm out (spacer nut and eyes, read off
  the frames), carry half the dish each in bending on the thread's minor diameter, 10.1 mm - a
  dish under 100 kg is **under 160 MPa**, inside a grade-4.6 bolt's 240 MPa; a factor of five
  at the 30 kg a man carries.  The grade is not given.

## 13. The tracker, the azimuth motor, the tow holding the dish (24:10-26:40)

"It's time to install the tracker.  The method of making this solar tracker and the control
circuit inside the control box are in the previous videos, and you can refer to their address
in the description of this video and watch them.  For the fixed focus system, you must use a
precise solar tracker, which of course exists in the market, but their price is high.  The
solar tracker is one of the most important parts of the fixed focus system, and it must be
installed on top of the solar dish in a way that is perpendicular to the plane of the dish.
You can use spiral guard wrap for better protection of the [cable].  Now I want to do the final
installation and it is a small 12 volt electric motor with a gearbox.  This small electric
motor can perform the horizontal movement of the system.  Now I will remove the obstacle that
I have placed to hold the dish up, you can see that the tow is holding it up.  Since the system
circuits are not connected at the moment, I lower the dish with a battery and connecting it to
a vertical electric motor."

The frames.  THE TRACKER (24:10-25:10): a sun sensor - a short tube, its aperture at one end,
on a bracket with its cable - fixed to the rim at the top of the dish, the edge nearest the
mast, with its axis along the dish's axis; its cable down to the box.  So the control loop
closes on the dish's own pointing: the sensor rides the dish and sees the sun where the dish
sees it.  THE AZIMUTH MOTOR (25:20-25:50): a 12 V motor with a gearbox on a bracket at the
bar's end by the panel, its roller on the ring - section 2's `rDrive`.  THE TOW (26:00-26:40):
the dish swung up with its back to the mast, held by a pipe propped under it; the pipe comes
away and the tow holds the dish where it is; then, the circuits not yet wired, he lowers it by
putting a battery straight on the winch motor - the wire paying out under the dish's weight,
`wire_taut_iff`'s return stroke.

What follows from it:

* `TrackerBudget`, `trackerBudget_iff`: "precise" as a number.  The sensor's error `ε` -
  precision and mounting misalignment together - is a pointing error of the dish, so the spot
  moves `spot f ε`; the receiver's half-size `h` allows `tan ε ≤ h / f`.  What the loop cannot
  see is anything that moves F rather than the dish's axis - the hangers' set lengths
  (`one_turn_tilt`), the posts' lean (`focusShift`); those stay one-time alignments.
* `systemVolts`, `panel_current`: 12 V; the panel's 5 W is under half an ampere, inside the
  1 A of `cable_drop_small`.
* `wireLever_edge_formula`, `wireLever_sixty_at_ym`: "the tow is holding it up", at about 60°.
  The wire's arm has fallen from 1.03 m at rest to **0.38 m** at 60°, two degrees short of the
  dead point, so the tension there is `W rcm sin 60° / 0.38` ≈ 2.3 W rcm, about twice the
  dish's weight - what `HoldsDish` must cover, and what the winch's gearing holds unpowered.

## 14. The start, the receiver on its post through the slot, the shadow test (26:40-28:30)

"Now our dish is in horizontal position.  Due to the increase in video volume, I connect the
interface cables in the control box and then start the system.  Therefore, after launching the
system, we test it in front of the sun.  Also, the weather is cloudy and we will test it on a
sunny day.  Now I started the system and you can see that it is working and the dish is
perpendicular to the sunlight.  Because we currently have other experiments with the fixed
focus system, I have used an old copper spiral tube with an additional base as a focus.
Because our solar dish is made of 5 cm mirrors, so its focus width is more and I have to use a
bigger spiral tube.  The center of the focus shadow on the dish should be in the center of the
dish.  Now the sun is almost at the highest point and because of that, the focus heat is more.
You can see that the small dc motor is activated and returns the moving part to the first
position.  The heat of the focus is high and if I apply Electrical Contact Cleaner Spray to it,
it produces a lot of smoke."

The frames.  THE START (26:40-27:10): the dish winched down level, the cables into the box; a
cloudy day, so the test waits.  THE SUNNY DAY (27:20-28:30): the dish on the sun, the sensor
on its top rim; the RECEIVER - a copper spiral coil, some 12 cm across, on top of a rusty
vertical pipe standing on "an additional base" - rises to F, and the dish's face has a SLOT in
the mosaic from its centre to the sun-side rim: the strip of section 8 was its cover, and the
post passes through it.  The coil's shadow on the mirrors sits at the dish's centre - his
alignment check.  At noon the coil glows, and contact cleaner sprayed on it smokes.  The
azimuth motor's roller on the ring runs "and returns the moving part to the first position".

What follows from it:

* The receiver stands on a post straight below F, rising from the carriage through the slot:
  F rides the carriage, and section 6's open question is answered that way - the roof-fixed
  receiver of `focus_on_axis` is not what he built.  The user (2026-09-17, from the closing
  shots): the post stands at the dead centre of the frame - the bar's midpoint, between the two
  legs - so it is the vertical through F, and its height from the bar to F is the legs' own
  `upright - holeDown` = 1.25 m (`receiverPost_height`).  `rim_under_F_iff`, `slot_exit_hashemi`:
  the post leaves the dish through the sun-side rim exactly when that rim point is straight
  below F, `tan t = a / FH` = 0.96 - **43.8° of swing, the sun 46° up** - the same swing at
  which the rim is deepest (`edgeDepth_le`).  Higher sun, the post is inside the panel and
  needs the slot; lower, the dish hangs beside it.  So the slot runs from the centre to the
  rim, as built.
* The shadow test: with the sensor holding the axis on the sun the light is parallel to the
  axis, and the receiver's shadow falls on the vertex exactly when the receiver is on the axis;
  the sun's 9.3 mrad blurs the shadow's edge by 9 mm at 1 m, so the coil can be centred to a
  few millimetres.
* `facetSpot`, `facetSpot_hashemi`, `tracker_margin_hashemi`: "5 cm mirrors, so its focus
  width is more" - a flat facet's beam does not converge; at F it is the facet plus the sun's
  9.3 mrad times `f`: **6 cm**.  Over a coil 12 cm across (read off the frames) that leaves
  3 cm of pointing margin, so the tracker's budget is `tan ε ≤ 0.03`, **1.7°** - what
  "precise" comes to on this machine.

## 15. The end (28:43-30:07)

"Thanks for sticking with me this far and I've tried to explain clearly how to install the
fixed focus system.  Now the system is launched and active, and due to the increase in the
volume of the video, I have not been able to explain the installation of the electrical
circuit of the system.  [The focus] placed here is temporary and I did not have time to prepare
a suitable focus.  As you can see, the sun is on the horizon and the dish is pulled up.  Thank
you again for your attention to the video, and liking the video will help spread this
information better.  Until the next program, I wish you all to be healthy.  Goodbye."

The frames: the machine complete at evening, seen from the tube's side - the dish pulled up
steep toward a low sun, its face to the camera; the coil on its post at F, the sensor on the top
rim, the panel on the bar, the box, the mast with the wire from its pulley.  Two limits, kept
apart (the user, 2026-09-17: "the swing limit for the dish is probably 90 degrees"): THE DISH'S
OWN SWING reaches the vertical and past it - his length figure's low-sun end (section 5,
`edgeDepth_horizon`), the rim `a` below F there and never deeper than F-C anywhere
(`dish_swings_to_vertical`, `clearance_hashemi`), and by hand he swings it there at 17:27.  THE
WIRE'S REACH does not: with the clip on the mast-side rim and the pulley 0.34 m over the bolts
the wire from pulley to clip is shortest at 61.7° (`deadTan_at_ym`), past which the winch
cannot shorten it, and its moment at the vertical is negative (`wire_short_of_vertical`,
`edgeClip_cross` at 90°) - and clips do not change this, since the wire bears on the mast-side
rim whatever it is clamped to.  So the winch takes the dish to about 62°, the sun 28° up
(`lowestSun_tan_at_ym`).  The vertical from that rim needs the pulley at least `a / ze` = 0.96
of `ym` above the bolts - 1.17 m at 1.22 m out, a mast of 2.4 m (`ReachesVertical`,
`mast_for_vertical_hashemi`) - or a wire path that does not cross the mast-side rim.  The last
shot is the rigging as shown: the dish at 60-65°, the coil unlit, the sun low.  The coil is
temporary, so the receiver's size is his to change, and the tracker's budget
(`tracker_margin_hashemi`) moves with it.

## What the video did not give

The coil's size and plumbing (temporary, by his own account; its post is at the bar's midpoint,
the user); the winch's drum and ratios, which with `ym`
fix the elevation rate; the wire's diameter; the bolts' grade; the bronze pulley's role (the
wire runs from the drum straight up to the mast, past it); the sensor's own precision and the
circuit's logic - deadband, the "first position" the azimuth motor returns to, the search at
dawn - which are in his earlier videos; the battery's size; whether the wire ever takes the dish
past its dead point (no frame shows it beyond about 65°).  Read off frames or from the user,
not from a caption: `ym` (1.22 m, a decimetre either way), the rod's 10 mm and its pitch, the
rim holes at the middle of each half edge and the clip at C, the flange in the panel's surface,
the struts' attachment heights, the level's sensitivity, the cable runs' length and the motors'
current, the coil's 12 cm.  `r_rail = g_orbit + 0.6` in `tandoor_hashemi_env.py` is the env's
ring; his is `1.219 g` at `g = 1` - a knob, not a theorem.
-/
import Mathlib
import RequestProject.Mount
import RequestProject.OpticsSphere

namespace TandoorHashemi

/-! ## 1. The fixed base -/

/-- the fixed base: the red ring on the roof, its central tube, and the level the foam ring holds
the bearings at.  Metres; heights over the deck -/
structure FixedBase where
  /-- radius of the rolling surface the carriage's wheels ride -/
  rRail : ℝ
  /-- height of that rail over the deck -/
  zRail : ℝ
  /-- top of the central tube - "a higher height" than the rail -/
  zTube : ℝ
  /-- the level the foam ring keeps the bearings at -/
  zBearing : ℝ
  /-- the pipe: "the fixed base pipes are also 2 cm" -/
  dPipe : ℝ := 0.02
  /-- the spokes from the hub to the lower hoop -/
  nSpokes : ℕ := 8
  rail_pos : 0 < rRail
  tube_above_rail : zRail < zTube
  bearing_on_tube : zRail ≤ zBearing ∧ zBearing ≤ zTube

/-- "the second-hand type ... because the speed of the rotation is very low": the carriage follows
the sun's azimuth, under one turn a day, so twenty years is under 7305 revolutions - a hundredfold
margin on any bearing rated to a million -/
theorem bearing_life {L10 : ℝ} (hL : 10 ^ 6 ≤ L10) : 100 * (20 * 365.25) < L10 := by
  linarith

/-! ## 2. The movable base -/

/-- the carriage, from the figure shot from above: a chord bar with a roller at each end and a
flat A whose apex bearing takes the central tube.  In-plane lengths, metres -/
structure Carriage where
  /-- the bar, roller to roller: 184 cm -/
  chord : ℝ
  /-- apex to the bar: 80 cm -/
  apexH : ℝ
  /-- the A's base on the bar: 98 cm -/
  aBase : ℝ
  /-- the cross member's height above the bar: 39 cm -/
  cross : ℝ
  /-- the bar's width: 13.5 cm -/
  barW : ℝ
  /-- the rubber drive roller's radius -/
  rDrive : ℝ
  chord_pos : 0 < chord
  apex_pos : 0 < apexH
  cross_lt : cross < apexH
  base_le : aBase ≤ chord
  drive_pos : 0 < rDrive

/-- his carriage.  The drive roller is not dimensioned in the video; 5 cm is read off the frame -/
def hashemi : Carriage where
  chord := 1.84
  apexH := 0.80
  aBase := 0.98
  cross := 0.39
  barW := 0.135
  rDrive := 0.05
  chord_pos := by norm_num
  apex_pos := by norm_num
  cross_lt := by norm_num
  base_le := by norm_num
  drive_pos := by norm_num

/-- the circle the rollers ride: the apex is at the centre, the rollers are half a chord either
side of a point `apexH` away -/
noncomputable def rollerRadius (c : Carriage) : ℝ :=
  Real.sqrt ((c.chord / 2) ^ 2 + c.apexH ^ 2)

theorem rollerRadius_pos (c : Carriage) : 0 < rollerRadius c := by
  unfold rollerRadius
  have := c.apex_pos
  positivity

theorem rollerRadius_sq (c : Carriage) :
    rollerRadius c ^ 2 = (c.chord / 2) ^ 2 + c.apexH ^ 2 := by
  unfold rollerRadius
  exact Real.sq_sqrt (by positivity)

theorem rollerRadius_hashemi : rollerRadius hashemi = Real.sqrt 1.4864 := by
  unfold rollerRadius hashemi
  norm_num

/-- **1.219 m**: the rail is 2.44 m across -/
theorem rollerRadius_hashemi_bounds :
    1.219 < rollerRadius hashemi ∧ rollerRadius hashemi < 1.2195 := by
  rw [rollerRadius_hashemi]
  constructor
  · rw [Real.lt_sqrt (by norm_num)]; norm_num
  · rw [Real.sqrt_lt' (by norm_num)]; norm_num

/-- the carriage fits the base: the rail is where the rollers are -/
def Fits (b : FixedBase) (c : Carriage) : Prop := b.rRail = rollerRadius c

/-- his fixed base, built to his carriage.  The heights are read off the frames: the rail at
knee height, the tube a hand above it, the bearings between -/
noncomputable def hashemiBase : FixedBase where
  rRail := rollerRadius hashemi
  zRail := 0.55
  zTube := 0.75
  zBearing := 0.62
  rail_pos := rollerRadius_pos hashemi
  tube_above_rail := by norm_num
  bearing_on_tube := by norm_num

theorem hashemi_fits : Fits hashemiBase hashemi := rfl

/-- the carriage's rate from the drive: a roller of radius `rw` turned at `ωm` rolls the carriage
round a rail of radius `R` at `ωm rw / R` (rad/s for rad/s; deg/s for deg/s) -/
noncomputable def azRate (ωm rw R : ℝ) : ℝ := ωm * rw / R

theorem azRate_pos {ωm rw R : ℝ} (h1 : 0 < ωm) (h2 : 0 < rw) (h3 : 0 < R) :
    0 < azRate ωm rw R := by
  unfold azRate; positivity

/-- `Mount.lean`'s exact follower, driven by the roller: if the sun's azimuth never advances faster
than the roller carries the carriage, a carriage on the sun stays on the sun -/
theorem tracks_exactly {ωm rw R ω dt : ℝ} (hdt : 0 ≤ dt) (hω : 0 ≤ ω)
    (hrate : ω ≤ azRate ωm rw R) {θ : ℕ → ℝ} (hθ : ∀ n, |θ (n + 1) - θ n| ≤ ω * dt) :
    ∀ n, TandoorMount.follow (azRate ωm rw R * dt) θ (θ 0) n = θ n :=
  TandoorMount.follow_exact hdt hω hrate hθ

/-- and the roller speed a given sun rate asks for: `ωsun R / rw`.  At Quetta's fastest azimuth,
2°/min on his rail with a 5 cm roller, that is 0.14 rpm - eight turns an hour -/
theorem roller_rpm_hashemi :
    let ωsun : ℝ := 2 / 360                    -- rev/min of azimuth
    0.13 < ωsun * 1.2192 / 0.05 ∧ ωsun * 1.2192 / 0.05 < 0.14 := by
  norm_num

/-- "this part can rotate 360 degrees around itself": the azimuth is on the circle with no stop,
so the carriage is the WRAPPED follower of `Mount.lean`, and at the roller's rate it tracks the
sun exactly through the ±180 seam -/
theorem tracks_exactly_circ {ωm rw R ω dt : ℝ} (hdt : 0 ≤ dt) (hω : 0 ≤ ω)
    (hrate : ω ≤ azRate ωm rw R) {θ : ℕ → ℝ}
    (hθ : ∀ n, |TandoorMount.wrap (θ (n + 1) - θ n)| ≤ ω * dt) {m0 : ℝ}
    (h0 : TandoorMount.Cong m0 (θ 0)) :
    ∀ n, TandoorMount.errCirc (azRate ωm rw R * dt) θ m0 n = 0 :=
  TandoorMount.followCirc_exact hdt hω hrate hθ h0

/-- the bearing's play `δ` moves the axis and everything the later stages hang on it, so it comes
straight off the receiver's half-size `h`: the pointing budget of `Mount.lean` §4 shrinks to
`h - δ` -/
theorem play_budget {f ε h δ : ℝ} (hε : TandoorMount.spot f ε ≤ h - δ) :
    TandoorMount.spot f ε + δ ≤ h := by
  linarith

/-- "a number of small pieces of iron sheet": half a millimetre of play left, on a 6 cm loaf, is
under one per cent of the budget -/
theorem shim_negligible : (0.0005 : ℝ) < 0.01 * 0.06 := by norm_num

/-! ## 3. Freedom, constraint, actuation -/

/-- a screw: a twist `(ω; v)` or a wrench `(f; τ)`, six reals -/
abbrev Screw := Fin 6 → ℝ

/-- the reciprocal product of a twist and a wrench: `ω·τ + v·f`, the power delivered -/
def recip (t w : Screw) : ℝ :=
  t 0 * w 3 + t 1 * w 4 + t 2 * w 5 + t 3 * w 0 + t 4 * w 1 + t 5 * w 2

/-- the wrench of a force `f` applied at the point `p`: `(f; p × f)` -/
def wrenchAt (p f : Fin 3 → ℝ) : Screw :=
  ![f 0, f 1, f 2,
    p 1 * f 2 - p 2 * f 1, p 2 * f 0 - p 0 * f 2, p 0 * f 1 - p 1 * f 0]

/-- the yaw: rotation about the vertical through the tube, the origin -/
def yaw : Screw := ![0, 0, 1, 0, 0, 0]

/-- the tube bearing: the horizontal force along `x` at the apex -/
def wBearX (b : FixedBase) : Screw := wrenchAt ![0, 0, b.zBearing] ![1, 0, 0]

/-- the tube bearing: the horizontal force along `y` at the apex -/
def wBearY (b : FixedBase) : Screw := wrenchAt ![0, 0, b.zBearing] ![0, 1, 0]

/-- the foam ring: the vertical force at the apex -/
def wStop (b : FixedBase) : Screw := wrenchAt ![0, 0, b.zBearing] ![0, 0, 1]

/-- the roller at the chord's `+y` end: a vertical force there -/
noncomputable def wRollP (c : Carriage) (b : FixedBase) : Screw :=
  wrenchAt ![c.apexH, c.chord / 2, b.zRail] ![0, 0, 1]

/-- the roller at the chord's `-y` end -/
noncomputable def wRollN (c : Carriage) (b : FixedBase) : Screw :=
  wrenchAt ![c.apexH, -(c.chord / 2), b.zRail] ![0, 0, 1]

/-- the five constraint wrenches of the azimuth stage -/
noncomputable def constraints (c : Carriage) (b : FixedBase) : Fin 5 → Screw :=
  ![wBearX b, wBearY b, wStop b, wRollP c b, wRollN c b]

/-- the base does no work on the yaw: every constraint is reciprocal to it -/
theorem constraints_reciprocal_yaw (c : Carriage) (b : FixedBase) :
    ∀ i, recip yaw (constraints c b i) = 0 := by
  intro i
  fin_cases i <;>
    simp [recip, yaw, constraints, wBearX, wBearY, wStop, wRollP, wRollN, wrenchAt]

/-- the five constraints are independent, so the yaw is the WHOLE freedom space: the stage is
exactly determinate -/
theorem constraints_linearIndependent (c : Carriage) (b : FixedBase) :
    LinearIndependent ℝ (constraints c b) := by
  rw [Fintype.linearIndependent_iff]
  intro g hg
  have h : ∀ j, (∑ i, g i • constraints c b i) j = 0 := fun j => by rw [hg]; rfl
  simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, Fin.sum_univ_five] at h
  have h0 := h 0
  have h1 := h 1
  have h2 := h 2
  have h3 := h 3
  have h4 := h 4
  simp [constraints, wBearX, wBearY, wStop, wRollP, wRollN, wrenchAt] at h0 h1 h2 h3 h4
  have hL := c.chord_pos
  have hH := c.apex_pos
  have g0 : g 0 = 0 := by linarith
  have g1 : g 1 = 0 := by linarith
  have e34 : g 3 = g 4 := by
    have : c.chord / 2 * (g 3 - g 4) = 0 := by
      linear_combination h3 + b.zBearing * g1
    rcases mul_eq_zero.mp this with hc | hc
    · exact absurd hc (by positivity)
    · linarith
  have s34 : g 3 + g 4 = 0 := by
    have : c.apexH * (g 3 + g 4) = 0 := by
      linear_combination -h4 + b.zBearing * g0
    rcases mul_eq_zero.mp this with hc | hc
    · exact absurd hc (by positivity)
    · exact hc
  have g3 : g 3 = 0 := by linarith
  have g4 : g 4 = 0 := by linarith
  have g2 : g 2 = 0 := by linarith
  intro i
  fin_cases i <;> [exact g0; exact g1; exact g2; exact g3; exact g4]

/-- the drive: the rubber roller's traction `F`, tangential to the rail at the `+y` roller.  The
tangent there is `(-chord/2, apexH) / R` -/
noncomputable def wDrive (c : Carriage) (b : FixedBase) (F : ℝ) : Screw :=
  wrenchAt ![c.apexH, c.chord / 2, b.zRail]
    ![-(F * (c.chord / 2) / rollerRadius c), F * c.apexH / rollerRadius c, 0]

/-- the actuation works on the freedom: the traction's moment about the tube is `F R` -/
theorem drive_recip_yaw (c : Carriage) (b : FixedBase) (F : ℝ) :
    recip yaw (wDrive c b F) = F * rollerRadius c := by
  have hR := rollerRadius_sq c
  have hpos := rollerRadius_pos c
  simp [recip, yaw, wDrive, wrenchAt]
  have key : F * rollerRadius c = F * ((c.chord / 2) ^ 2 + c.apexH ^ 2) / rollerRadius c := by
    rw [← hR, pow_two, mul_div_assoc, mul_div_cancel_right₀ _ hpos.ne']
  rw [key]; ring

/-- ... and so any traction at all turns the carriage -/
theorem drive_works_on_yaw (c : Carriage) (b : FixedBase) {F : ℝ} (hF : F ≠ 0) :
    recip yaw (wDrive c b F) ≠ 0 := by
  rw [drive_recip_yaw]
  exact mul_ne_zero hF (rollerRadius_pos c).ne'

/-! ### As built: the wheels are grooved, so seven constraints of rank five -/

/-- the `+y` wheel's groove: a radial force at the wheel along the line from the tube out to it.
Unnormalised on purpose - a constraint is a line, not a magnitude -/
noncomputable def wRollPr (c : Carriage) (b : FixedBase) : Screw :=
  wrenchAt ![c.apexH, c.chord / 2, b.zRail] ![c.apexH, c.chord / 2, 0]

/-- the `-y` wheel's groove -/
noncomputable def wRollNr (c : Carriage) (b : FixedBase) : Screw :=
  wrenchAt ![c.apexH, -(c.chord / 2), b.zRail] ![c.apexH, -(c.chord / 2), 0]

/-- the seven constraints of the stage as he built it -/
noncomputable def constraintsGrooved (c : Carriage) (b : FixedBase) : Fin 7 → Screw :=
  ![wBearX b, wBearY b, wStop b, wRollP c b, wRollN c b, wRollPr c b, wRollNr c b]

/-- the grooves, too, do no work on the yaw: a radial force through the axis has no moment about
it.  So all seven lie in the five-dimensional space reciprocal to the yaw -/
theorem grooved_reciprocal_yaw (c : Carriage) (b : FixedBase) :
    ∀ i, recip yaw (constraintsGrooved c b i) = 0 := by
  intro i
  fin_cases i <;>
    simp [recip, yaw, constraintsGrooved, wBearX, wBearY, wStop, wRollP, wRollN, wRollPr,
      wRollNr, wrenchAt] <;> ring

/-- the first dependency: the two grooves together fix the axis along `x`, which the bearing
already does.  The verticals make up the moment the height difference `zRail - zBearing`
leaves over -/
theorem grooved_relation_x (c : Carriage) (b : FixedBase) :
    wRollPr c b + wRollNr c b - (2 * c.apexH) • wBearX b
      + (b.zRail - b.zBearing) • (wRollP c b + wRollN c b - (2 : ℝ) • wStop b) = 0 := by
  funext i
  fin_cases i <;>
    simp [wBearX, wStop, wRollP, wRollN, wRollPr, wRollNr, wrenchAt] <;> first | ring1 | norm_num

/-- the second: the grooves' difference fixes the axis along `y`, which the bearing already does -/
theorem grooved_relation_y (c : Carriage) (b : FixedBase) :
    wRollPr c b - wRollNr c b - c.chord • wBearY b
      - (b.zBearing - b.zRail) • (wRollP c b - wRollN c b) = 0 := by
  funext i
  fin_cases i <;>
    simp [wBearY, wRollP, wRollN, wRollPr, wRollNr, wrenchAt] <;> ring1

/-- so the stage as built is over-constrained: the seven are dependent.  The witness is
`grooved_relation_x`, read as coefficients on the seven -/
theorem grooved_not_linearIndependent (c : Carriage) (b : FixedBase) :
    ¬ LinearIndependent ℝ (constraintsGrooved c b) := by
  intro hli
  rw [Fintype.linearIndependent_iff] at hli
  let g : Fin 7 → ℝ :=
    ![-(2 * c.apexH), 0, -(2 * (b.zRail - b.zBearing)), b.zRail - b.zBearing,
      b.zRail - b.zBearing, 1, 1]
  have hsum : ∑ i, g i • constraintsGrooved c b i = 0 := by
    funext j
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul, Fin.sum_univ_succ,
      Finset.univ_eq_empty, Finset.sum_empty]
    simp [g, constraintsGrooved]
    fin_cases j <;>
      simp [wBearX, wStop, wRollP, wRollN, wRollPr, wRollNr, wrenchAt] <;> ring1
  have h5 := hli g hsum 5
  simp [g] at h5

/-! ## 4. What the next stages must satisfy -/

/-- rotation of the horizontal plane by `ψ` about the tube -/
noncomputable def rot (ψ : ℝ) (p : ℝ × ℝ) : ℝ × ℝ :=
  (Real.cos ψ * p.1 - Real.sin ψ * p.2, Real.sin ψ * p.1 + Real.cos ψ * p.2)

/-- **the fixed-focus condition, from the base alone**: a point the azimuth leaves fixed, for a
turn that is not a whole number of turns, lies on the axis.  So the focus sits over the central
tube, and the elevation stage must put it there -/
theorem focus_on_axis {ψ : ℝ} (hψ : Real.cos ψ ≠ 1) {p : ℝ × ℝ} (h : rot ψ p = p) :
    p = (0, 0) := by
  obtain ⟨x, y⟩ := p
  simp only [rot, Prod.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  have hsc := Real.sin_sq_add_cos_sq ψ
  have hk : (Real.cos ψ - 1) ^ 2 + Real.sin ψ ^ 2 ≠ 0 := by
    intro h0
    apply hψ
    nlinarith [sq_nonneg (Real.cos ψ - 1), sq_nonneg (Real.sin ψ)]
  have hx : ((Real.cos ψ - 1) ^ 2 + Real.sin ψ ^ 2) * x = 0 := by
    linear_combination (Real.cos ψ - 1) * h1 + Real.sin ψ * h2
  have hy : ((Real.cos ψ - 1) ^ 2 + Real.sin ψ ^ 2) * y = 0 := by
    linear_combination (Real.cos ψ - 1) * h2 - Real.sin ψ * h1
  have hx0 : x = 0 := (mul_eq_zero.mp hx).resolve_left hk
  have hy0 : y = 0 := (mul_eq_zero.mp hy).resolve_left hk
  simp [hx0, hy0]

/-- the screw that stands the rim of a dish of aperture radius `a` on a sphere of radius `R` off the
axis through the paraxial focus: the focal distance `R/2` less the rim's sag toward it -/
noncomputable def screwLength (R a : ℝ) : ℝ := R / 2 - TandoorSphere.sag R a

theorem screwLength_eq_focal (R a : ℝ) :
    screwLength R a = TandoorSphere.focal R 0 - TandoorSphere.sag R a := by
  rw [TandoorSphere.focal_zero]; rfl

/-- his 2 m sphere with a 2 m dish: `√3 - 1` -/
theorem screwLength_hashemi : screwLength 2 1 = Real.sqrt 3 - 1 := by
  unfold screwLength TandoorSphere.sag
  norm_num
  ring

/-- **0.73 m**: the paper's 73 cm screws -/
theorem screwLength_hashemi_bounds : 0.732 < screwLength 2 1 ∧ screwLength 2 1 < 0.7321 := by
  rw [screwLength_hashemi]
  constructor
  · have : (1.732 : ℝ) < Real.sqrt 3 := by rw [Real.lt_sqrt (by norm_num)]; norm_num
    linarith
  · have : Real.sqrt 3 < (1.7321 : ℝ) := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
    linarith

/-! ## 5. The two legs -/

/-- one leg, from the figure shot from above: a 130 cm upright, a 62 cm foot across its end, a
96 cm knee brace from the foot's long end to the upright, four holes through the foot.  The
upright meets the foot `footShort` from one end - 17.5 cm, read off the figure.  Metres -/
structure Leg where
  upright : ℝ
  foot : ℝ
  brace : ℝ
  footShort : ℝ
  holes : ℕ := 4
  upright_pos : 0 < upright
  foot_pos : 0 < foot
  short_nonneg : 0 ≤ footShort
  short_lt : footShort < foot
  /-- the brace reaches past the foot's long end: it can land on the upright -/
  brace_reaches : foot - footShort < brace

/-- his leg -/
def hashemiLeg : Leg where
  upright := 1.30
  foot := 0.62
  brace := 0.96
  footShort := 0.175
  upright_pos := by norm_num
  foot_pos := by norm_num
  short_nonneg := by norm_num
  short_lt := by norm_num
  brace_reaches := by norm_num

/-- the foot's long side, where the brace starts -/
def Leg.footLong (l : Leg) : ℝ := l.foot - l.footShort

/-- where the brace lands on the upright, up from the foot -/
noncomputable def braceHeight (l : Leg) : ℝ := Real.sqrt (l.brace ^ 2 - l.footLong ^ 2)

/-- **85 cm** up the post -/
theorem braceHeight_hashemi : 0.85 < braceHeight hashemiLeg ∧ braceHeight hashemiLeg < 0.851 := by
  unfold braceHeight Leg.footLong hashemiLeg
  constructor
  · rw [Real.lt_sqrt (by norm_num)]; norm_num
  · rw [Real.sqrt_lt' (by norm_num)]; norm_num

/-- "the chord of the triangle on the base prevents bending of the vertical base": a horizontal
pull at the top bends an unbraced post over its whole length; braced, over the length above the
brace.  The peak moment is cut to `(upright - braceHeight) / upright`: **0.35** on his leg -/
theorem brace_cuts_moment :
    (hashemiLeg.upright - braceHeight hashemiLeg) / hashemiLeg.upright < 0.35 := by
  have h := braceHeight_hashemi.1
  have hu : hashemiLeg.upright = 1.30 := rfl
  rw [hu, div_lt_iff₀ (by norm_num)]
  linarith

/-- and the tip stiffness goes as the cube of the free length: braced, the top is more than 24 times
stiffer against that pull -/
theorem brace_stiffens :
    ((hashemiLeg.upright - braceHeight hashemiLeg) / hashemiLeg.upright) ^ 3 < 1 / 24 := by
  have h := braceHeight_hashemi.1
  have hu : hashemiLeg.upright = 1.30 := rfl
  have h0 : 0 ≤ (hashemiLeg.upright - braceHeight hashemiLeg) / hashemiLeg.upright := by
    rw [hu]
    have := braceHeight_hashemi.2
    apply div_nonneg <;> linarith
  have h1 : (hashemiLeg.upright - braceHeight hashemiLeg) / hashemiLeg.upright < 0.3462 := by
    rw [hu, div_lt_iff₀ (by norm_num)]
    linarith
  calc ((hashemiLeg.upright - braceHeight hashemiLeg) / hashemiLeg.upright) ^ 3
      < 0.3462 ^ 3 := by gcongr
    _ < 1 / 24 := by norm_num

/-- a post top in the carriage's frame - the tube at the origin, the chord along `y`, heights over
the bar - for the leg at the `sg = ±1` end, its foot `endIn` in from the roller -/
noncomputable def postTop (c : Carriage) (l : Leg) (endIn sg : ℝ) : Fin 3 → ℝ :=
  ![c.apexH, sg * (c.chord / 2 - endIn), l.upright]

/-- the two tops are level -/
theorem postTops_level (c : Carriage) (l : Leg) (endIn : ℝ) :
    postTop c l endIn 1 2 = postTop c l endIn (-1) 2 := by
  simp [postTop]

/-- and a chord apart, less the two end offsets -/
theorem postTops_apart (c : Carriage) (l : Leg) (endIn : ℝ) :
    postTop c l endIn 1 1 - postTop c l endIn (-1) 1 = c.chord - 2 * endIn := by
  simp [postTop]; ring

/-- and the line between them is `apexH` from the tube's axis - 80 cm, the carriage's own number -/
theorem postTops_offAxis (c : Carriage) (l : Leg) (endIn sg : ℝ) :
    postTop c l endIn sg 0 = c.apexH := by
  simp [postTop]

/-- "the foot is on the grooved tire rod": with no end offset the post stands over the wheel, so
its horizontal position is the wheel's - on the rail circle, `rollerRadius` from the tube.  The
post's load goes down through the wheel onto the rail; the bar carries none of it in bending -/
theorem postTop_on_rail (c : Carriage) (l : Leg) {sg : ℝ} (hsg : sg ^ 2 = 1) :
    postTop c l 0 sg 0 ^ 2 + postTop c l 0 sg 1 ^ 2 = rollerRadius c ^ 2 := by
  rw [rollerRadius_sq]
  simp only [postTop, Matrix.cons_val_zero, Matrix.cons_val_one, sub_zero]
  rw [mul_pow, hsg, one_mul]
  ring

/-- **his requirement on the vertical movement, as he states it**: in the plane of the swing, at
every elevation `t` the vertex plus the focal distance along the unit normal lands on `F` - "the
dish is always perpendicular to the supposed circle of focus".  A requirement, not a mechanism -/
def AlwaysTangent (F : ℝ × ℝ) (f : ℝ) (v n : ℝ → ℝ × ℝ) : Prop :=
  ∀ t, (v t).1 + f * (n t).1 = F.1 ∧ (v t).2 + f * (n t).2 = F.2

/-- and that is his diagram, from the sentence alone: a dish that is always tangent to the focus
circle has its vertex ON that circle, at distance `f` from `F`, at every elevation -/
theorem alwaysTangent_focusCircle {F : ℝ × ℝ} {f : ℝ} {v n : ℝ → ℝ × ℝ}
    (hn : ∀ t, (n t).1 ^ 2 + (n t).2 ^ 2 = 1) (h : AlwaysTangent F f v n) :
    ∀ t, ((v t).1 - F.1) ^ 2 + ((v t).2 - F.2) ^ 2 = f ^ 2 := by
  intro t
  obtain ⟨h1, h2⟩ := h t
  have e1 : (v t).1 - F.1 = -(f * (n t).1) := by linarith
  have e2 : (v t).2 - F.2 = -(f * (n t).2) := by linarith
  rw [e1, e2]
  linear_combination f ^ 2 * hn t

/-- his length figure as a function of elevation.  A dish of half-width `a` on a sphere with rim
sag `sag`, always tangent to the focus circle of radius `f` about F, at sun elevation `el`: the
vertex is `f sin el` below F, the lower edge `a cos el` further down along the dish and `sag sin
el` back up toward F -/
noncomputable def edgeDepth (f a sag el : ℝ) : ℝ := (f - sag) * Real.sin el + a * Real.cos el

/-- the figure's low-sun end: the edge B is `a` below F -/
theorem edgeDepth_horizon (f a sag : ℝ) : edgeDepth f a sag 0 = a := by
  simp [edgeDepth]

/-- the figure's noon end: the edge sits `sag` above the vertex, which is `f` down -/
theorem edgeDepth_noon (f a sag : ℝ) : edgeDepth f a sag (Real.pi / 2) = f - sag := by
  simp [edgeDepth]

/-- but the deepest reach is between the ends: never more than `√((f - sag)² + a²)`, and that is
attained where `tan el = (f - sag) / a` -/
theorem edgeDepth_le (f a sag el : ℝ) :
    edgeDepth f a sag el ≤ Real.sqrt ((f - sag) ^ 2 + a ^ 2) := by
  refine le_trans (le_abs_self _) (Real.abs_le_sqrt ?_)
  have hs := Real.sin_sq_add_cos_sq el
  unfold edgeDepth
  nlinarith [sq_nonneg ((f - sag) * Real.cos el - a * Real.sin el)]

/-! ### 5b. His dish, from the geometry figure -/

/-- "a circle with a radius of two meters": `AB = AD = AC` -/
def dishR : ℝ := 2

/-- the dish focal point, midway: `AF = FD` -/
def dishF : ℝ := 1

/-- "a segment of a circle with a length of 1.6 meters": `BH = HC` -/
def dishHalf : ℝ := 0.8

/-- `√3.36`, his `AH`, in the two places it is needed: `1.833 < AH < 1.8331` -/
theorem AH_bounds : (1.833 : ℝ) < Real.sqrt 3.36 ∧ Real.sqrt 3.36 < 1.8331 := by
  constructor
  · rw [Real.lt_sqrt (by norm_num)]; norm_num
  · rw [Real.sqrt_lt' (by norm_num)]; norm_num

/-- `HD`, the dish's sag at the rim, is `TandoorSphere.sag 2 0.8 = 2 - √3.36`: his `AD - AH` -/
theorem HD_eq : TandoorSphere.sag dishR dishHalf = 2 - Real.sqrt 3.36 := by
  unfold TandoorSphere.sag dishR dishHalf
  norm_num

/-- **0.167 m** -/
theorem HD_bounds :
    0.166 < TandoorSphere.sag dishR dishHalf ∧ TandoorSphere.sag dishR dishHalf < 0.168 := by
  rw [HD_eq]
  have h := AH_bounds
  constructor <;> linarith [h.1, h.2]

/-- `FH = AH - AF = √3.36 - 1`, and it is `screwLength 2 0.8`: the screw length for this dish -/
theorem FH_eq : screwLength dishR dishHalf = Real.sqrt 3.36 - 1 := by
  unfold screwLength
  rw [HD_eq]
  unfold dishR
  ring

/-- **0.833 m** -/
theorem FH_bounds : 0.833 < screwLength dishR dishHalf ∧ screwLength dishR dishHalf < 0.8331 := by
  rw [FH_eq]
  have h := AH_bounds
  constructor <;> linarith [h.1, h.2]

/-- `FC² = HC² + FH²` - his "Base" - and it is exactly the bound of `edgeDepth_le`: the deepest the
rim reaches below F, `√(5 - 2√3.36)` -/
theorem FC_eq :
    Real.sqrt ((dishF - TandoorSphere.sag dishR dishHalf) ^ 2 + dishHalf ^ 2)
      = Real.sqrt (5 - 2 * Real.sqrt 3.36) := by
  rw [HD_eq]
  unfold dishF dishHalf
  congr 1
  have h : Real.sqrt 3.36 ^ 2 = 3.36 := Real.sq_sqrt (by norm_num)
  nlinarith [h]

/-- **1.155 m** -/
theorem FC_bounds :
    1.154 < Real.sqrt (5 - 2 * Real.sqrt 3.36) ∧ Real.sqrt (5 - 2 * Real.sqrt 3.36) < 1.1551 := by
  have h := AH_bounds
  constructor
  · rw [Real.lt_sqrt (by norm_num)]
    have e : (1.154 : ℝ) ^ 2 = 1.331716 := by norm_num
    rw [e]; linarith [h.2]
  · rw [Real.sqrt_lt' (by norm_num)]
    have e : (1.1551 : ℝ) ^ 2 = 1.33425601 := by norm_num
    rw [e]; linarith [h.1]

/-- the upright is sized to FC: 130 cm against 1.155 m, **14.5 cm** to spare at the worst
elevation - if the pivot is at the post top, as his first figure draws it -/
theorem hashemi_clearance :
    0.1449 < hashemiLeg.upright - Real.sqrt (5 - 2 * Real.sqrt 3.36) ∧
      hashemiLeg.upright - Real.sqrt (5 - 2 * Real.sqrt 3.36) < 0.146 := by
  have h := FC_bounds
  have hu : hashemiLeg.upright = 1.30 := rfl
  rw [hu]
  constructor <;> linarith [h.1, h.2]

/-! ## 6. The swing: four hanger legs on two pivot bolts -/

/-- a hanger leg: threaded rod with a nut welded on as its eye at the pivot ("you can use bearings
instead of nuts"); its length, eye to rim hole, is what the rim nuts set (section 8) -/
structure Hanger where
  length : ℝ
  dRod : ℝ
  length_pos : 0 < length
  rod_pos : 0 < dRod

/-- his hangers: eye to the middle of the half edge, **0.88 m** (`hangerLength_halfEdge`, section
8; this revision first had F-C, 1.155 m, then the corners, 1.03 m, before the user placed the
holes), on threaded rod of about 10 mm - the rod read off the frames -/
noncomputable def hashemiHanger : Hanger where
  length := Real.sqrt (4.36 - 2 * Real.sqrt 3.2)
  dRod := 0.010
  length_pos := by
    have h : Real.sqrt 3.2 < 2.18 := by
      rw [Real.sqrt_lt' (by norm_num)]; norm_num
    exact Real.sqrt_pos.2 (by linarith)
  rod_pos := by norm_num

/-- the pendulum: hung from the pivot `P`, the vertex sits `f` from it along the hangers, at swing
angle `t` from straight down -/
noncomputable def swingVertex (P : ℝ × ℝ) (f t : ℝ) : ℝ × ℝ :=
  (P.1 + f * Real.sin t, P.2 - f * Real.cos t)

/-- and the vertex normal points back up the hangers at the pivot -/
noncomputable def swingNormal (t : ℝ) : ℝ × ℝ := (-Real.sin t, Real.cos t)

theorem swingNormal_unit (t : ℝ) : (swingNormal t).1 ^ 2 + (swingNormal t).2 ^ 2 = 1 := by
  simp only [swingNormal, neg_sq]
  exact Real.sin_sq_add_cos_sq t

/-- **the swing discharges the requirement of section 5**: a dish hung rigidly from the bolts,
its vertex `f` below them along the hangers, is always tangent to the focus circle about the
bolts.  F is the pivot -/
theorem swing_alwaysTangent (P : ℝ × ℝ) (f : ℝ) :
    AlwaysTangent P f (swingVertex P f) swingNormal := by
  intro t
  simp only [swingVertex, swingNormal]
  constructor <;> ring

/-- and so, by his own diagram, the vertex rides the focus circle -/
theorem swing_focusCircle (P : ℝ × ℝ) (f : ℝ) :
    ∀ t, ((swingVertex P f t).1 - P.1) ^ 2 + ((swingVertex P f t).2 - P.2) ^ 2 = f ^ 2 :=
  alwaysTangent_focusCircle swingNormal_unit (swing_alwaysTangent P f)

/-- what is left over the bar at the worst elevation: the upright, less the hole's drop below the
top, less the dish's deepest reach below the bolt line - `edgeDepth_le`'s bound `FC`, from the
fore and aft edges -/
def clearance (l : Leg) (holeDown reach : ℝ) : ℝ := l.upright - holeDown - reach

/-- "the distance of the hole above the base should also be taken into account": on his leg it is
14.5 cm less the hole's drop - about 9.5 cm with the bolt 5 cm below the top, as at 12:10 -/
theorem clearance_hashemi (holeDown : ℝ) :
    0.1449 - holeDown < clearance hashemiLeg holeDown (Real.sqrt (5 - 2 * Real.sqrt 3.36)) ∧
      clearance hashemiLeg holeDown (Real.sqrt (5 - 2 * Real.sqrt 3.36)) < 0.146 - holeDown := by
  have h := FC_bounds
  have hu : hashemiLeg.upright = 1.30 := rfl
  unfold clearance
  rw [hu]
  constructor <;> linarith [h.1, h.2]

/-- the hangers swing in a plane parallel to the post's face, offset from it by where their eyes
sit on the bolt; they clear the post through the whole swing exactly when that offset exceeds the
rod's half-thickness - "direct them to the end of the screw as much as possible" -/
def HangerClearsPost (eyeOffset dRod : ℝ) : Prop := dRod / 2 < eyeOffset

/-- his spacer: a nut between the post face and the eyes.  A nut on a 12 mm bolt is 10 mm thick,
against a 10 mm rod - it clears, by 5 mm -/
theorem hashemi_eyes_clear : HangerClearsPost 0.010 hashemiHanger.dRod := by
  unfold HangerClearsPost hashemiHanger
  norm_num

/-! ## 7. The vertical-movement stand -/

/-- the stand for the vertical movement, from the figure shot from above: a post on a foot bar,
two bent legs from the foot's ends curving up to the post, a metal pulley at the top.  Metres -/
structure DriveStand where
  post : ℝ
  foot : ℝ
  bentLeg : ℝ
  post_pos : 0 < post
  foot_pos : 0 < foot
  bent_lt : bentLeg < post

/-- his stand: 159 cm post, 184 cm foot, bent legs 41 cm -/
def hashemiStand : DriveStand where
  post := 1.59
  foot := 1.84
  bentLeg := 0.41
  post_pos := by norm_num
  foot_pos := by norm_num
  bent_lt := by norm_num

/-- the outrigger, as far as the frames go: it joins the stand to the carriage ("a structure to
connect it with the horizontal axis"), it reaches outside the ring, and the motor with gearbox
sits at its end.  No dimension is given, so none is recorded -/
structure Outrigger where
  /-- the stand is carried outside the ring: "outside the circular axis of the base" -/
  standOutsideRing : Prop
  /-- the motor with gearbox is at its end: "this is where our motor with gearbox fits" -/
  motorAtEnd : Prop

/-- the stand's pulley over the bolt line: `post - (upright - holeDown)`, **0.34 m** with the bolt
5 cm below the leg's top -/
theorem pulley_above_pivot :
    hashemiStand.post - (hashemiLeg.upright - 0.05) = 0.34 := by
  unfold hashemiStand hashemiLeg
  norm_num

/-! ## 8. The stand on the outrigger, the dish in, the rods closed to the corners -/

/-- the panel as placed: square, the 1.6 m chord of section 5b on each side -/
def dishSide : ℝ := 2 * dishHalf

/-- the panel goes in between the posts: 1.6 m across against a 1.84 m bar -/
theorem dish_between_posts : dishSide < hashemi.chord := by
  unfold dishSide dishHalf hashemi
  norm_num

/-- what is left each side between the panel's edge and the bar's end, before the post's inset -/
noncomputable def sideGap : ℝ := (hashemi.chord - dishSide) / 2

/-- **12 cm a side** -/
theorem sideGap_eq : sideGap = 0.12 := by
  unfold sideGap dishSide dishHalf hashemi
  norm_num

/-- the hanger that puts F on the bolt line: from its eye, on the bolt line `dx` outboard of the
edge line, to a rim hole `yr` along the edge of the panel of half-chord `a` on the sphere `R`.
The eye sits `R/2` over the vertex, the hole `sag` below the vertex's level at its own radius -/
noncomputable def hangerLength (R a yr dx : ℝ) : ℝ :=
  Real.sqrt (dx ^ 2 + yr ^ 2 + (R / 2 - TandoorSphere.sag R (Real.sqrt (a ^ 2 + yr ^ 2))) ^ 2)

/-- to the middle of the half edge of his panel, `yr = 0.4`, eye over the edge line:
`√(4.36 - 2√3.2)` -/
theorem hangerLength_halfEdge :
    hangerLength 2 0.8 0.4 0 = Real.sqrt (4.36 - 2 * Real.sqrt 3.2) := by
  unfold hangerLength TandoorSphere.sag
  have h1 : Real.sqrt ((0.8 : ℝ) ^ 2 + 0.4 ^ 2) ^ 2 = 0.8 := by
    rw [Real.sq_sqrt (by norm_num)]; norm_num
  rw [h1]
  have h2 : Real.sqrt ((2 : ℝ) ^ 2 - 0.8) = Real.sqrt 3.2 := by norm_num
  rw [h2]
  congr 1
  have h3 : Real.sqrt 3.2 ^ 2 = 3.2 := Real.sq_sqrt (by norm_num)
  linear_combination h3

theorem sqrt32_bounds : 1.7888 < Real.sqrt 3.2 ∧ Real.sqrt 3.2 < 1.78886 := by
  constructor
  · rw [Real.lt_sqrt (by norm_num)]; norm_num
  · rw [Real.sqrt_lt' (by norm_num)]; norm_num

/-- **0.884 m** - after the 1.155 m of F-C and the 1.03 m of the corners -/
theorem hangerLength_bounds :
    0.884 < Real.sqrt (4.36 - 2 * Real.sqrt 3.2) ∧
      Real.sqrt (4.36 - 2 * Real.sqrt 3.2) < 0.8846 := by
  have h := sqrt32_bounds
  constructor
  · rw [Real.lt_sqrt (by norm_num)]
    have e : (0.884 : ℝ) ^ 2 = 0.781456 := by norm_num
    rw [e]; linarith [h.2]
  · rw [Real.sqrt_lt' (by norm_num)]
    have e : (0.8846 : ℝ) ^ 2 = 0.78251716 := by norm_num
    rw [e]; linarith [h.1]

/-- section 6's hanger is this length -/
theorem hashemiHanger_length : hashemiHanger.length = hangerLength 2 0.8 0.4 0 := by
  show Real.sqrt (4.36 - 2 * Real.sqrt 3.2) = hangerLength 2 0.8 0.4 0
  exact hangerLength_halfEdge.symm

/-- the rod's lean off the vertical, eye over the edge line: `yr / (f - sag)` at the hole,
`0.4 / (√3.2 - 1)` -/
noncomputable def rodTan : ℝ := 0.4 / (Real.sqrt 3.2 - 1)

/-- tan 0.507: each rod **27°** off the vertical, the pair a V of 54° - the user's "about 60°" -/
theorem rodTan_bounds : 0.507 < rodTan ∧ rodTan < 0.5072 := by
  have hs := sqrt32_bounds
  have hpos : 0 < Real.sqrt 3.2 - 1 := by linarith [hs.1]
  unfold rodTan
  constructor
  · rw [lt_div_iff₀ hpos]; linarith [hs.2]
  · rw [div_lt_iff₀ hpos]; linarith [hs.1]

/-- the pendulum with the vertex `d` from the pivot along the hangers - `d` is what the rim nuts
set; section 6's `swingVertex` is the case `d = f` -/
noncomputable def swingVertexAt (P : ℝ × ℝ) (d t : ℝ) : ℝ × ℝ :=
  (P.1 + d * Real.sin t, P.2 - d * Real.cos t)

/-- and the focus, `f` back up the normal from the vertex -/
noncomputable def swingFocus (P : ℝ × ℝ) (d f t : ℝ) : ℝ × ℝ :=
  ((swingVertexAt P d t).1 + f * (swingNormal t).1,
    (swingVertexAt P d t).2 + f * (swingNormal t).2)

/-- **the focus rides a circle of radius `|d - f|` about the bolts**: nuts set long or short by
`e`, F wanders `e` off the bolts through the day -/
theorem swingFocus_circle (P : ℝ × ℝ) (d f t : ℝ) :
    ((swingFocus P d f t).1 - P.1) ^ 2 + ((swingFocus P d f t).2 - P.2) ^ 2 = (d - f) ^ 2 := by
  simp only [swingFocus, swingVertexAt, swingNormal]
  have := Real.sin_sq_add_cos_sq t
  linear_combination (d - f) ^ 2 * this

/-- **"the focus distance from the centre of the dish is the same in all cases"**: the focus stays
put through the whole swing exactly when the nuts set the vertex `f` from the bolts -/
theorem swingFocus_fixed_iff (P : ℝ × ℝ) (d f : ℝ) :
    (∀ t, swingFocus P d f t = P) ↔ d = f := by
  constructor
  · intro h
    have := congrArg Prod.snd (h 0)
    simp [swingFocus, swingVertexAt, swingNormal] at this
    linarith
  · rintro rfl t
    refine Prod.ext ?_ ?_ <;> simp [swingFocus, swingVertexAt, swingNormal]

/-- the rim clamp: the flange sits between two nuts on the rod, so the hanger's working length is
the rod less what stands above the flange - "the length of the screw passed from the edge" -/
def setLength (rod excess : ℝ) : ℝ := rod - excess

/-- any length up to the rod's is settable, continuously - what a threaded hanger is for -/
theorem setLength_surj {rod L : ℝ} (h : L ≤ rod) :
    ∃ excess, 0 ≤ excess ∧ setLength rod excess = L :=
  ⟨rod - L, by linarith, by unfold setLength; ring⟩

/-- a difference `e` between the two sides' hanger lengths drops one edge by `e` against the
other, `dishSide` away: the dish tilts `e / dishSide` about the horizontal axis across the bar
(small angles) -/
noncomputable def tiltOfMismatch (e : ℝ) : ℝ := e / dishSide

/-- one turn of a rim nut, IF the rod is M10 (10 mm is read off the frames; coarse pitch 1.5 mm):
**0.94 mrad**, under a quarter of the sun's half-angle, and 0.94 mm at F - the rods are a
one-time alignment set to a fraction of a turn -/
theorem one_turn_tilt :
    tiltOfMismatch 0.0015 < 0.001 ∧ 4 * tiltOfMismatch 0.0015 < 0.00465 ∧
      dishF * tiltOfMismatch 0.0015 < 0.001 := by
  unfold tiltOfMismatch dishSide dishHalf dishF
  norm_num

/-- the swing as a twist: rotation about the bolt line, along the bar (x) through
`(apexH, 0, zBolt)` - the same Plücker numbers as a wrench on that line -/
def swingTwist (apexH zBolt : ℝ) : Screw := wrenchAt ![apexH, 0, zBolt] ![1, 0, 0]

/-- a roll about the horizontal axis across the bar (y), through any point `p` -/
def rollY (p : Fin 3 → ℝ) : Screw := wrenchAt p ![0, 1, 0]

/-- the two freedoms he shows by hand - "the dish can easily move in the vertical axis",
"horizontal movement is also done in this way" - are independent -/
theorem swing_yaw_independent (apexH zBolt : ℝ) :
    LinearIndependent ℝ ![swingTwist apexH zBolt, yaw] := by
  rw [LinearIndependent.pair_iff]
  intro a b h
  have h0 := congrFun h 0
  have h2 := congrFun h 2
  simp [swingTwist, yaw, wrenchAt] at h0 h2
  exact ⟨h0, h2⟩

/-- **the tilt the rim nuts set is outside both drives**: no combination of the yaw about the tube
and the swing about the bolt line is a roll about y - their angular parts have no y -/
theorem tilt_not_driven (apexH zBolt : ℝ) (p : Fin 3 → ℝ) :
    rollY p ∉ Submodule.span ℝ {swingTwist apexH zBolt, yaw} := by
  rw [Submodule.mem_span_pair]
  rintro ⟨a, b, h⟩
  have h1 := congrFun h 1
  simp [swingTwist, yaw, rollY, wrenchAt] at h1

/-- "Tube with x degree cut": the cosine of the angle between the hanger and the sphere's normal
at the hole, the flange continuing the panel's surface there.  `rod · n / (|rod| R)` with
`rod = (0, 0.4, -(√3.2 - 1))`, `n = (0.8, 0.4, -√3.2)`, `|n| = R = 2` -/
noncomputable def cosTubeCut : ℝ :=
  (3.36 - Real.sqrt 3.2) / (2 * Real.sqrt (4.36 - 2 * Real.sqrt 3.2))

/-- cos x = 0.888: **x = 27°** -/
theorem cosTubeCut_bounds : 0.888 < cosTubeCut ∧ cosTubeCut < 0.889 := by
  have hs := sqrt32_bounds
  have hL := hangerLength_bounds
  have hpos : 0 < 2 * Real.sqrt (4.36 - 2 * Real.sqrt 3.2) := by linarith [hL.1]
  unfold cosTubeCut
  constructor
  · rw [lt_div_iff₀ hpos]; linarith [hs.2, hL.2]
  · rw [div_lt_iff₀ hpos]; linarith [hs.1, hL.1]

/-- "There is some slack that won't be a problem in practice": the play at the mast's pulley
reaches the dish through the wire, whose path the frames have not shown, so the shift `δ` of the
spot it causes at the receiver is a parameter here.  His claim is section 2b's play budget with
the mast's play in it -/
def SlackHarmless (f ε δ h : ℝ) : Prop := TandoorMount.spot f ε + δ ≤ h

theorem slackHarmless_of_budget {f ε δ h : ℝ} (hε : TandoorMount.spot f ε ≤ h - δ) :
    SlackHarmless f ε δ h :=
  play_budget hε

/-! ## 9. The winch, and the struts against the legs' lean -/

/-- "this engine with a gearbox, along with an additional gearbox and a wire collecting roller,
all work like a winch": the elevation drive as installed - a drum of radius `rDrum` turned
through two gearboxes.  No figure gives the drum, the ratios or the motor -/
structure Winch where
  rDrum : ℝ
  drum_pos : 0 < rDrum

/-- the drum pays wire at `ωd * rDrum`; on a lever arm `rw` about the bolt line that is an
elevation rate `ωd * rDrum / rw` - `azRate`'s law for the winch -/
noncomputable def elRate (ωd rDrum rw : ℝ) : ℝ := ωd * rDrum / rw

/-- `Mount.lean`'s exact follower, driven by the winch: if the sun's elevation never advances
faster than the winch swings the dish, a dish on the sun stays on the sun -/
theorem el_tracks_exactly {ωd rDrum rw ω dt : ℝ} (hdt : 0 ≤ dt) (hω : 0 ≤ ω)
    (hrate : ω ≤ elRate ωd rDrum rw) {θ : ℕ → ℝ} (hθ : ∀ n, |θ (n + 1) - θ n| ≤ ω * dt) :
    ∀ n, TandoorMount.follow (elRate ωd rDrum rw * dt) θ (θ 0) n = θ n :=
  TandoorMount.follow_exact hdt hω hrate hθ

/-- the wire's pull as a wrench, force `f` at its rim point `q`, against the swing twist:
**the wire drives the swing by its moment about the bolt line**, whatever the rim point and the
direction turn out to be -/
theorem wire_recip_swing (apexH zBolt : ℝ) (q f : Fin 3 → ℝ) :
    recip (swingTwist apexH zBolt) (wrenchAt q f) = q 1 * f 2 - (q 2 - zBolt) * f 1 := by
  simp [recip, swingTwist, wrenchAt]
  ring

/-- the pendulum hung `rcm` below the bolts and swung to `t` needs a moment `W rcm sin t` about
the bolt line; a wire on lever arm `rw` gives it at this tension -/
noncomputable def wireTension (W rcm rw t : ℝ) : ℝ := W * rcm * Real.sin t / rw

/-- **a wire only pulls**: the tension is non-negative exactly when `sin t ≥ 0`, the dish swung
toward the wire's side.  The return stroke is gravity's; the range is one-sided -/
theorem wire_taut_iff {W rcm rw : ℝ} (hW : 0 < W) (hr : 0 < rcm) (hw : 0 < rw) (t : ℝ) :
    0 ≤ wireTension W rcm rw t ↔ 0 ≤ Real.sin t := by
  unfold wireTension
  rw [le_div_iff₀ hw, zero_mul, mul_nonneg_iff_of_pos_left (mul_pos hW hr)]

/-- "it easily supports the weight of the dish": the winch's holding tension `Tmax` covers the
dish on its side, `sin t = 1` -/
def HoldsDish (Tmax W rcm rw : ℝ) : Prop := W * rcm ≤ Tmax * rw

/-- and then it covers every swing angle -/
theorem tension_le_of_holds {Tmax W rcm rw : ℝ} (hW : 0 ≤ W) (hr : 0 ≤ rcm) (hw : 0 < rw)
    (h : HoldsDish Tmax W rcm rw) (t : ℝ) : wireTension W rcm rw t ≤ Tmax := by
  unfold wireTension HoldsDish at *
  rw [div_le_iff₀ hw]
  have h1 : W * rcm * Real.sin t ≤ W * rcm * 1 :=
    mul_le_mul_of_nonneg_left (Real.sin_le_one t) (mul_nonneg hW hr)
  linarith

/-- a strut from `P` on the post to `Q` on the outrigger resists motion of `P` along its own
axis: the first-order change of its length under a displacement `δ` of `P` is `(P - Q) · δ`, up
to the length -/
def strutStrain (P Q δ : Fin 3 → ℝ) : ℝ :=
  (P 0 - Q 0) * δ 0 + (P 1 - Q 1) * δ 1 + (P 2 - Q 2) * δ 2

/-- **"foundations in the opposite direction of the deviation"**: the lean toward the dish moves
the post at `+x` by `(-ε, 0, 0)`, and that shortens the strut - loads it - exactly when the
outrigger end is inboard of the post, which is where he runs it -/
theorem strut_resists_lean (P Q δ : Fin 3 → ℝ) {ε : ℝ} (hε : 0 < ε) (h : Q 0 < P 0)
    (h0 : δ 0 = -ε) (h1 : δ 1 = 0) (h2 : δ 2 = 0) : strutStrain P Q δ < 0 := by
  unfold strutStrain
  rw [h0, h1, h2]
  nlinarith [mul_pos (sub_pos.2 h) hε]

/-! ## 10. The level, the second strut, the panel and the box -/

/-- the velocity a twist `t = (ω, v₀)` gives a point `p`: `ω × p + v₀` -/
def pointVel (t : Screw) (p : Fin 3 → ℝ) : Fin 3 → ℝ :=
  ![t 1 * p 2 - t 2 * p 1 + t 3, t 2 * p 0 - t 0 * p 2 + t 4, t 0 * p 1 - t 1 * p 0 + t 5]

/-- **the azimuth does no work against gravity**: the yaw about the tube lifts no point -/
theorem yaw_lifts_nothing (p : Fin 3 → ℝ) : pointVel yaw p 2 = 0 := by
  simp [pointVel, yaw]

/-- the swing lifts a point at `y` at the rate `y` per unit angular rate - the centre of mass at
`rcm sin t` in the pendulum, hence `elPower` -/
theorem swing_lift (apexH zBolt : ℝ) (p : Fin 3 → ℝ) :
    pointVel (swingTwist apexH zBolt) p 2 = p 1 := by
  simp [pointVel, swingTwist, wrenchAt]

/-- the winch's work rate: the weight lifted at the swing's rate, `W rcm sin t ω` -/
noncomputable def elPower (W rcm t ω : ℝ) : ℝ := W * rcm * Real.sin t * ω

/-- which is the wire's tension times the wire's speed `rw ω` -/
theorem elPower_eq_wire {rw : ℝ} (hw : rw ≠ 0) (W rcm t ω : ℝ) :
    wireTension W rcm rw t * (rw * ω) = elPower W rcm t ω := by
  unfold wireTension elPower
  field_simp

/-- at most `W rcm ω` -/
theorem elPower_le {W rcm ω : ℝ} (hW : 0 ≤ W) (hr : 0 ≤ rcm) (hω : 0 ≤ ω) (t : ℝ) :
    elPower W rcm t ω ≤ W * rcm * ω := by
  unfold elPower
  have h1 : W * rcm * Real.sin t ≤ W * rcm * 1 :=
    mul_le_mul_of_nonneg_left (Real.sin_le_one t) (mul_nonneg hW hr)
  linarith [mul_le_mul_of_nonneg_right h1 hω]

/-- the photovoltaic panel that runs the two motors through a battery -/
structure Panel where
  watts : ℝ
  pos : 0 < watts

/-- "a small 5 watt panel" - "you can also use a 10-watt panel" -/
def hashemiPanel : Panel := ⟨5, by norm_num⟩

/-- **tracking is nearly free**: any dish under 100 kg (`W ≤ 1000` N), hung with its centre within
`f` of the bolts, swung no faster than the Earth turns (15°/h = 7.3e-5 rad/s), costs under
0.073 W - 1.5 % of his 5 W panel.  "Very little consumption" on the mechanical side; motor and
gearbox losses are not given -/
theorem tracking_power_tiny {W rcm ω : ℝ} (hW : 0 ≤ W) (hW' : W ≤ 1000) (hr : 0 ≤ rcm)
    (hr' : rcm ≤ dishF) (hω : 0 ≤ ω) (hω' : ω ≤ 7.3e-5) (t : ℝ) :
    elPower W rcm t ω ≤ 0.073 ∧ (0.073 : ℝ) < 0.015 * hashemiPanel.watts := by
  have hf : dishF = 1 := rfl
  rw [hf] at hr'
  constructor
  · have h := elPower_le hW hr hω t
    have a : W * rcm ≤ 1000 * 1 := mul_le_mul hW' hr' hr (by norm_num)
    have b : W * rcm * ω ≤ 1000 * 1 * ω := mul_le_mul_of_nonneg_right a hω
    have c : 1000 * 1 * ω ≤ 1000 * 1 * 7.3e-5 := by linarith
    linarith
  · unfold hashemiPanel
    norm_num

/-- F sits on the bolts, so a lean `ε` of a post moves F by `h sin ε` at the bolt height -/
noncomputable def focusShift (h ε : ℝ) : ℝ := h * Real.sin ε

/-- an unbraced lean of one degree at the bolt height of 1.25 m moves F **over 2 cm** -/
theorem lean_one_degree : 0.02 < focusShift 1.25 (Real.pi / 180) := by
  unfold focusShift
  have h3 := Real.pi_gt_three
  have h4 := Real.pi_le_four
  have hx0 : 0 < Real.pi / 180 := by positivity
  have hx1 : Real.pi / 180 ≤ 1 := by linarith
  have hs := Real.sin_gt_sub_cube hx0 hx1
  have hxu : Real.pi / 180 ≤ 4 / 180 := by linarith
  have hcube : (Real.pi / 180) ^ 3 ≤ (4 / 180) ^ 3 := by gcongr
  nlinarith

/-- a post plumbed to a builder's level, 0.5 mm/m (a typical figure, not a caption), moves F under
0.7 mm at 1.3 m: `sin ε ≤ ε` -/
theorem plumbed_shift {ε : ℝ} (h0 : 0 ≤ ε) (hε : ε ≤ 0.0005) :
    focusShift 1.30 ε ≤ 0.00065 := by
  unfold focusShift
  have hs := Real.sin_le h0
  linarith [mul_le_mul_of_nonneg_left hs (by norm_num : (0:ℝ) ≤ 1.30)]

/-! ## 11. The box, the cables, and the tow wire to the back of the dish -/

/-- the tow wire's lever arm about the bolt line, signed positive when its pull turns the back
toward the mast: pulley `P` and clip `B` in the plane across the bar, `(y, z)` from the bolt
line; `(P × B) / |B - P|` -/
noncomputable def wireLever (P B : ℝ × ℝ) : ℝ :=
  (P.1 * B.2 - P.2 * B.1) / Real.sqrt ((B.1 - P.1) ^ 2 + (B.2 - P.2) ^ 2)

/-- the pulley: `ym` beyond the bolt line on the mast's side, `hp` above it -/
def pulleyAt (ym hp : ℝ) : ℝ × ℝ := (-ym, hp)

/-- a point of the dish at swing `t` (back toward the mast), from its rest place `(y₀, z₀)`
relative to the bolt line -/
noncomputable def swungPt (y₀ z₀ t : ℝ) : ℝ × ℝ :=
  (y₀ * Real.cos t + z₀ * Real.sin t, -y₀ * Real.sin t + z₀ * Real.cos t)

/-- the clip: the middle of the edge nearest the mast (the user's placement), `a` toward the mast
and `ze = f - sag` below the bolt line at rest.  It is the figure's C, and F is on the bolt
line, so its radius about the bolts is F-C -/
noncomputable def edgeClipAt (a ze t : ℝ) : ℝ × ℝ := swungPt (-a) (-ze) t

/-- the clip rides a circle of radius `√(a² + ze²)` about the bolts -/
theorem edgeClip_radius (a ze t : ℝ) :
    (edgeClipAt a ze t).1 ^ 2 + (edgeClipAt a ze t).2 ^ 2 = a ^ 2 + ze ^ 2 := by
  simp only [edgeClipAt, swungPt]
  have := Real.sin_sq_add_cos_sq t
  linear_combination (a ^ 2 + ze ^ 2) * this

/-- on his panel that radius squared is `5 - 2√3.36`: F-C, his "Base", 1.155 m -/
theorem edgeClip_radius_hashemi (t : ℝ) :
    (edgeClipAt dishHalf (Real.sqrt 3.36 - 1) t).1 ^ 2 +
      (edgeClipAt dishHalf (Real.sqrt 3.36 - 1) t).2 ^ 2 = 5 - 2 * Real.sqrt 3.36 := by
  rw [edgeClip_radius]
  unfold dishHalf
  have h : Real.sqrt 3.36 ^ 2 = 3.36 := Real.sq_sqrt (by norm_num)
  linear_combination h

/-- `P × B` for the edge clip: `(ym ze + hp a) cos t + (hp ze - ym a) sin t` -/
theorem edgeClip_cross (ym hp a ze t : ℝ) :
    (pulleyAt ym hp).1 * (edgeClipAt a ze t).2 - (pulleyAt ym hp).2 * (edgeClipAt a ze t).1 =
      (ym * ze + hp * a) * Real.cos t + (hp * ze - ym * a) * Real.sin t := by
  simp only [pulleyAt, edgeClipAt, swungPt]
  ring

/-- the lever arm has the sign of `P × B` whenever the clip is not at the pulley -/
theorem wireLever_pos_iff {P B : ℝ × ℝ} (hP : 0 < (B.1 - P.1) ^ 2 + (B.2 - P.2) ^ 2) :
    0 < wireLever P B ↔ 0 < P.1 * B.2 - P.2 * B.1 := by
  unfold wireLever
  exact div_pos_iff_of_pos_right (Real.sqrt_pos.2 hP)

/-- at rest: `(ym ze + hp a) / √((ym - a)² + (hp + ze)²)` - with the mast 1.2 m out, 1.03 m, the
wire nearly tangent to the clip's circle -/
theorem wireLever_rest (ym hp a ze : ℝ) :
    wireLever (pulleyAt ym hp) (edgeClipAt a ze 0) =
      (ym * ze + hp * a) / Real.sqrt ((ym - a) ^ 2 + (hp + ze) ^ 2) := by
  simp only [wireLever, pulleyAt, edgeClipAt, swungPt, Real.sin_zero, Real.cos_zero, mul_zero,
    mul_one, add_zero, zero_add]
  congr 1
  · ring
  · congr 1
    ring

/-- **the edge clip has a dead point**: the wire turns the dish exactly while
`sin t (ym a - hp ze) < cos t (ym ze + hp a)` - in the first quadrant, `tan t` under
`(ym ze + hp a) / (ym a - hp ze)` - and its moment vanishes where the clip reaches the pulley's
ray from the bolt line.  The range ends there, with `√(ym² + hp²) - √(a² + ze²)` of wire left -/
theorem edgeLever_pos_iff {ym hp a ze t : ℝ}
    (hP : 0 < ((edgeClipAt a ze t).1 - (pulleyAt ym hp).1) ^ 2 +
      ((edgeClipAt a ze t).2 - (pulleyAt ym hp).2) ^ 2) :
    0 < wireLever (pulleyAt ym hp) (edgeClipAt a ze t) ↔
      Real.sin t * (ym * a - hp * ze) < Real.cos t * (ym * ze + hp * a) := by
  rw [wireLever_pos_iff hP, edgeClip_cross]
  constructor <;> intro h <;> linarith

/-- and it is zero at the swing with `sin t (ym a - hp ze) = cos t (ym ze + hp a)`:
`t* = arctan(ze/a) + arctan(hp/ym)`, the clip's own angle below the horizontal plus the pulley's
above it.  A taller mast lengthens the range -/
theorem edgeLever_dead {ym hp a ze t : ℝ}
    (h : Real.sin t * (ym * a - hp * ze) = Real.cos t * (ym * ze + hp * a)) :
    (pulleyAt ym hp).1 * (edgeClipAt a ze t).2 - (pulleyAt ym hp).2 * (edgeClipAt a ze t).1
      = 0 := by
  rw [edgeClip_cross]
  linarith

/-- the clip's reach toward the mast: never beyond `√(a² + ze²)` from the bolt line -/
theorem edgeClip_reach (a ze t : ℝ) :
    |(edgeClipAt a ze t).1| ≤ Real.sqrt (a ^ 2 + ze ^ 2) := by
  apply Real.abs_le_sqrt
  simp only [edgeClipAt, swungPt]
  have := Real.sin_sq_add_cos_sq t
  nlinarith [sq_nonneg (a * Real.sin t - ze * Real.cos t)]

/-- **the mast must stand beyond the clip's reach**: `√(a² + ze²) < ym` -/
def MastClears (ym a ze : ℝ) : Prop := Real.sqrt (a ^ 2 + ze ^ 2) < ym

/-- on his panel that reach is F-C, 1.155 m: the mast is at least 1.2 m beyond the bolt line -/
theorem mastClears_hashemi_iff (ym : ℝ) :
    MastClears ym dishHalf (Real.sqrt 3.36 - 1) ↔ Real.sqrt (5 - 2 * Real.sqrt 3.36) < ym := by
  unfold MastClears dishHalf
  have h : Real.sqrt 3.36 ^ 2 = 3.36 := Real.sq_sqrt (by norm_num)
  have e : (0.8 : ℝ) ^ 2 + (Real.sqrt 3.36 - 1) ^ 2 = 5 - 2 * Real.sqrt 3.36 := by
    linear_combination h
  rw [e]

/-- with the mast at its closest, 1.2 m, on his panel: `tan t*` between 1.878 and 1.88, **62° of
swing** - and 9 cm of wire left between clip and pulley there.  The lowest sun the wire reaches
is 28° up -/
theorem deadTan_hashemi :
    1.878 < (1.2 * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        (1.2 * dishHalf - 0.34 * (Real.sqrt 3.36 - 1)) ∧
      (1.2 * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        (1.2 * dishHalf - 0.34 * (Real.sqrt 3.36 - 1)) < 1.88 := by
  unfold dishHalf
  have h := AH_bounds
  have hden : 0 < 1.2 * (0.8 : ℝ) - 0.34 * (Real.sqrt 3.36 - 1) := by linarith [h.2]
  constructor
  · rw [lt_div_iff₀ hden]; linarith [h.1, h.2]
  · rw [div_lt_iff₀ hden]; linarith [h.1, h.2]

/-- and 60° of swing - the sun 30° up, Quetta's winter noon at 36° inside it - is within the
range at that mast: `sin (π/3) (ym a - hp ze) < cos (π/3) (ym ze + hp a)` -/
theorem sixty_reachable :
    Real.sin (Real.pi / 3) * (1.2 * dishHalf - 0.34 * (Real.sqrt 3.36 - 1)) <
      Real.cos (Real.pi / 3) * (1.2 * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) := by
  rw [Real.sin_pi_div_three, Real.cos_pi_div_three]
  unfold dishHalf
  have h := AH_bounds
  have h3 : Real.sqrt 3 < 1.7321 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
  have h30 : 0 ≤ Real.sqrt 3 := Real.sqrt_nonneg 3
  have hq : 0 < 1.2 * (0.8 : ℝ) - 0.34 * (Real.sqrt 3.36 - 1) := by linarith [h.2]
  nlinarith [mul_pos (sub_pos.2 h3) hq, mul_nonneg h30 hq.le]

/-- the mast's play, now with its path: a pulley displaced by `δ` changes the wire's length by at
most `2δ`, the dish turns `2δ / rw`, the spot moves `2 f δ / rw` (paraxial) -/
noncomputable def slackSpot (f δ rw : ℝ) : ℝ := 2 * f * δ / rw

/-- section 8's claim with that in for its parameter -/
theorem slackHarmless_of_lever {f ε δ rw h : ℝ}
    (hε : TandoorMount.spot f ε ≤ h - slackSpot f δ rw) :
    SlackHarmless f ε (slackSpot f δ rw) h :=
  play_budget hε

/-- the cable: 2 × 1.5 mm², "resistant to sunlight and rain" -/
def cableArea : ℝ := 1.5e-6

/-- copper's resistivity, Ω m -/
def rhoCu : ℝ := 1.72e-8

/-- the drop over both conductors of a run of `L` at current `I` -/
noncomputable def cableDrop (L I : ℝ) : ℝ := rhoCu * (2 * L) * I / cableArea

/-- for a run of at most 4 m and a current of at most 1 A (not given; 5 W at 12 V is under half
an ampere): **under 0.1 V** -/
theorem cable_drop_small {L I : ℝ} (hL : L ≤ 4) (hI0 : 0 ≤ I) (hI : I ≤ 1) :
    cableDrop L I < 0.1 := by
  unfold cableDrop rhoCu cableArea
  rw [div_lt_iff₀ (by norm_num)]
  have h : L * I ≤ 4 * 1 := mul_le_mul hL hI hI0 (by norm_num)
  nlinarith

/-! ## 12. The hangers as joints: the motion through the connection -/

/-- the eye: a nut on the bolt's shank, turning about it ("you can use bearings instead of nuts")
- a revolute joint about the bolt line.  Its five constraint wrenches at the eye's place
`(xh, 0, zBolt)`: the three forces there and the two moments across the bolt -/
def hingeWrench (xh zBolt : ℝ) : Fin 5 → Screw :=
  ![wrenchAt ![xh, 0, zBolt] ![1, 0, 0], wrenchAt ![xh, 0, zBolt] ![0, 1, 0],
    wrenchAt ![xh, 0, zBolt] ![0, 0, 1], ![0, 0, 0, 0, 1, 0], ![0, 0, 0, 0, 0, 1]]

/-- all five are reciprocal to the swing: the hinge lets the swing through -/
theorem hinge_reciprocal_swing (xh zBolt apexH : ℝ) :
    ∀ i, recip (swingTwist apexH zBolt) (hingeWrench xh zBolt i) = 0 := by
  intro i
  fin_cases i <;> simp [recip, swingTwist, hingeWrench, wrenchAt]

/-- **the motion through the connection**: a twist the eye lets through has no turn across the
bolt and no slide - it is `(ω, 0, 0, 0, zBolt ω, 0)`, a turn about the bolt line and nothing
else -/
theorem hinge_freedom {xh zBolt : ℝ} {t : Screw}
    (h : ∀ i, recip t (hingeWrench xh zBolt i) = 0) :
    t 1 = 0 ∧ t 2 = 0 ∧ t 3 = 0 ∧ t 4 = t 0 * zBolt ∧ t 5 = 0 := by
  have h3 : t 1 = 0 := by simpa [recip, hingeWrench, wrenchAt] using h 3
  have h4 : t 2 = 0 := by simpa [recip, hingeWrench, wrenchAt] using h 4
  have h0 := h 0
  have h1 := h 1
  have h2 := h 2
  simp [recip, hingeWrench, wrenchAt, h3, h4] at h0 h1 h2
  refine ⟨h3, h4, ?_, ?_, ?_⟩ <;> linarith

/-- the same as a vector: the twist is `t 0 • swingTwist` -/
theorem hinge_freedom_smul {xh zBolt apexH : ℝ} {t : Screw}
    (h : ∀ i, recip t (hingeWrench xh zBolt i) = 0) : t = t 0 • swingTwist apexH zBolt := by
  obtain ⟨h1, h2, h3, h4, h5⟩ := hinge_freedom h
  funext j
  fin_cases j <;> simp [swingTwist, wrenchAt, h1, h2, h3, h4, h5]

/-- the second eye on the same bolt line, at `x'`, adds nothing: each of its wrenches lies in the
span of the first's - two coaxial hinges are one hinge with five redundant constraints, a door on
two hinges.  "Bolted at the proper distance" and the shims are what carry that redundancy -/
theorem second_hinge_redundant (x x' zBolt : ℝ) :
    ∀ i, hingeWrench x' zBolt i ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) := by
  have m : ∀ j, hingeWrench x zBolt j ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) :=
    fun j => Submodule.subset_span ⟨j, rfl⟩
  have e0 : hingeWrench x' zBolt 0 = hingeWrench x zBolt 0 := by
    funext j; fin_cases j <;> simp [hingeWrench, wrenchAt]
  have e1 : hingeWrench x' zBolt 1 =
      hingeWrench x zBolt 1 + (x' - x) • hingeWrench x zBolt 4 := by
    funext j; fin_cases j <;> simp [hingeWrench, wrenchAt]
  have e2 : hingeWrench x' zBolt 2 =
      hingeWrench x zBolt 2 - (x' - x) • hingeWrench x zBolt 3 := by
    funext j; fin_cases j <;> simp [hingeWrench, wrenchAt]
    ring
  have e3 : hingeWrench x' zBolt 3 = hingeWrench x zBolt 3 := by
    funext j; fin_cases j <;> simp [hingeWrench]
  have e4 : hingeWrench x' zBolt 4 = hingeWrench x zBolt 4 := by
    funext j; fin_cases j <;> simp [hingeWrench]
  have s0 : hingeWrench x' zBolt 0 ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) := by
    rw [e0]; exact m 0
  have s1 : hingeWrench x' zBolt 1 ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) := by
    rw [e1]; exact Submodule.add_mem _ (m 1) (Submodule.smul_mem _ _ (m 4))
  have s2 : hingeWrench x' zBolt 2 ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) := by
    rw [e2]; exact Submodule.sub_mem _ (m 2) (Submodule.smul_mem _ _ (m 3))
  have s3 : hingeWrench x' zBolt 3 ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) := by
    rw [e3]; exact m 3
  have s4 : hingeWrench x' zBolt 4 ∈ Submodule.span ℝ (Set.range (hingeWrench x zBolt)) := by
    rw [e4]; exact m 4
  intro i
  fin_cases i <;> [exact s0; exact s1; exact s2; exact s3; exact s4]

/-- if the eye threads on the bolt rather than turning on a smooth shank, the joint is helical:
a turn `φ` advances the eye `pitch φ / 2π` along the bolt -/
noncomputable def helixAdvance (pitch φ : ℝ) : ℝ := pitch * φ / (2 * Real.pi)

/-- over the wire's 62° of swing on the M12 bolt (the user; coarse pitch 1.75 mm): under 0.31 mm
-/
theorem helixAdvance_small : helixAdvance 0.00175 (62 * Real.pi / 180) < 0.00031 := by
  unfold helixAdvance
  have hpi := Real.pi_pos
  rw [div_lt_iff₀ (by positivity)]
  nlinarith [hpi]

/-- M12, and the eye turns on the thread (the user): the joint is helical, a turn `φ` about the
bolt line carrying the eye `h φ` along it, `h = pitch / 2π` - 0.28 mm per radian on the coarse
1.75 mm pitch -/
noncomputable def hM12 : ℝ := 0.00175 / (2 * Real.pi)

/-- the screw twist: the swing with `h` of travel along the bolt line per radian -/
def screwTwist (h zBolt : ℝ) : Screw := ![1, 0, 0, h, zBolt, 0]

/-- the plain hinge is the case `h = 0` -/
theorem screwTwist_zero (apexH zBolt : ℝ) : screwTwist 0 zBolt = swingTwist apexH zBolt := by
  funext j
  fin_cases j <;> simp [screwTwist, swingTwist, wrenchAt]

/-- the helical joint's five constraint wrenches at the eye `(xh, 0, zBolt)`: the two forces
across the bolt, the two moments across it, and the axial force paired with the moment `-h`
about the bolt - what the thread turns a push into -/
def screwWrench (xh zBolt h : ℝ) : Fin 5 → Screw :=
  ![wrenchAt ![xh, 0, zBolt] ![0, 1, 0], wrenchAt ![xh, 0, zBolt] ![0, 0, 1],
    ![0, 0, 0, 0, 1, 0], ![0, 0, 0, 0, 0, 1], ![1, 0, 0, -h, zBolt, 0]]

/-- all five are reciprocal to the screw twist -/
theorem screw_reciprocal (xh zBolt h : ℝ) :
    ∀ i, recip (screwTwist h zBolt) (screwWrench xh zBolt h i) = 0 := by
  intro i
  fin_cases i <;> simp [recip, screwTwist, screwWrench, wrenchAt]

/-- **the motion through the threaded connection**: a twist the threaded eye lets through is
`(ω, 0, 0, h ω, zBolt ω, 0)` - the swing, plus `h` of travel along the bolt per radian -/
theorem screw_freedom {xh zBolt h : ℝ} {t : Screw}
    (hc : ∀ i, recip t (screwWrench xh zBolt h i) = 0) :
    t 1 = 0 ∧ t 2 = 0 ∧ t 3 = t 0 * h ∧ t 4 = t 0 * zBolt ∧ t 5 = 0 := by
  have h1 : t 1 = 0 := by simpa [recip, screwWrench, wrenchAt] using hc 2
  have h2 : t 2 = 0 := by simpa [recip, screwWrench, wrenchAt] using hc 3
  have e0 := hc 0
  have e1 := hc 1
  have e4 := hc 4
  simp [recip, screwWrench, wrenchAt, h1, h2] at e0 e1 e4
  refine ⟨h1, h2, ?_, ?_, ?_⟩ <;> linarith

/-- the bolt in bending: the eyes at the end of the shank, `reach` beyond the post face, carry
half the dish; the threaded section's diameter `d` is what resists -/
noncomputable def boltStress (W reach d : ℝ) : ℝ := (W / 2 * reach) / (Real.pi * d ^ 3 / 32)

/-- M12 coarse, minor diameter 10.1 mm: a dish under 100 kg on eyes 3 cm out (the spacer nut and
the eyes, read off the frames) is **under 160 MPa**, inside a grade-4.6 bolt's 240 MPa - a factor
of 1.5 at 100 kg, five at the 30 kg a man carries.  The grade is not given -/
theorem m12_carries_dish {W : ℝ} (hW : W ≤ 1000) :
    boltStress W 0.03 0.0101 < 1.6e8 := by
  unfold boltStress
  have hpi := Real.pi_gt_three
  have hden : 0 < Real.pi * (0.0101 : ℝ) ^ 3 / 32 := by positivity
  rw [div_lt_iff₀ hden]
  nlinarith [hpi, hW]

/-- the mast's distance from the bolt line, read off two frames shot along the bar (20:50, 20:55):
the mast's foot 312 px from the bar's midpoint at 255 px/m of its own 1.59 m, and 285 px at
230 px/m - **1.22 m**, give or take a decimetre; right at the floor `MastClears` sets -/
def ymHashemi : ℝ := 1.22

/-- it clears the clip's circle -/
theorem mastClears_hashemi : MastClears ymHashemi dishHalf (Real.sqrt 3.36 - 1) := by
  rw [mastClears_hashemi_iff]
  unfold ymHashemi
  linarith [FC_bounds.2]

/-- the dead point with the mast at 1.22: `tan t*` between 1.859 and 1.86, **61.7°** -/
theorem deadTan_at_ym :
    1.859 < (ymHashemi * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        (ymHashemi * dishHalf - 0.34 * (Real.sqrt 3.36 - 1)) ∧
      (ymHashemi * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        (ymHashemi * dishHalf - 0.34 * (Real.sqrt 3.36 - 1)) < 1.86 := by
  unfold ymHashemi dishHalf
  have h := AH_bounds
  have hden : 0 < 1.22 * (0.8 : ℝ) - 0.34 * (Real.sqrt 3.36 - 1) := by linarith [h.2]
  constructor
  · rw [lt_div_iff₀ hden]; linarith [h.1, h.2]
  · rw [div_lt_iff₀ hden]; linarith [h.1, h.2]

/-- the wire left at the dead point: the pulley's radius from the bolt line less the clip's,
`√(1.22² + 0.34²) - F-C` - **11 cm** -/
theorem wireLeft_at_ym :
    0.111 < Real.sqrt (ymHashemi ^ 2 + 0.34 ^ 2) - Real.sqrt (5 - 2 * Real.sqrt 3.36) ∧
      Real.sqrt (ymHashemi ^ 2 + 0.34 ^ 2) - Real.sqrt (5 - 2 * Real.sqrt 3.36) < 0.113 := by
  unfold ymHashemi
  have hF := FC_bounds
  have e : (1.22 : ℝ) ^ 2 + 0.34 ^ 2 = 1.604 := by norm_num
  rw [e]
  have h1 : 1.2664 < Real.sqrt 1.604 := by rw [Real.lt_sqrt (by norm_num)]; norm_num
  have h2 : Real.sqrt 1.604 < 1.2665 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
  constructor <;> linarith [hF.1, hF.2]

/-- the wire's lever arm at rest with the mast at 1.22, `(ym ze + hp a)/√((ym-a)² + (hp+ze)²)`:
**1.03 m**, nearly the clip's whole radius - the wire nearly tangent to its circle -/
theorem wireLever_rest_at_ym :
    1.033 < (ymHashemi * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        Real.sqrt ((ymHashemi - dishHalf) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2) ∧
      (ymHashemi * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        Real.sqrt ((ymHashemi - dishHalf) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2) < 1.035 := by
  unfold ymHashemi dishHalf
  have h := AH_bounds
  have hb : (1.173 : ℝ) ≤ 0.34 + (Real.sqrt 3.36 - 1) := by linarith [h.1]
  have hb' : 0.34 + (Real.sqrt 3.36 - 1) ≤ (1.1731 : ℝ) := by linarith [h.2]
  have hin1 : (1.552329 : ℝ) ≤ (1.22 - 0.8) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2 := by
    nlinarith [mul_le_mul hb hb (by norm_num) (by linarith)]
  have hin2 : (1.22 - 0.8 : ℝ) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2 ≤ 1.5526 := by
    nlinarith [mul_le_mul hb' hb' (by linarith) (by norm_num)]
  have hsq1 : 1.2459 < Real.sqrt ((1.22 - 0.8 : ℝ) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2) := by
    rw [Real.lt_sqrt (by norm_num)]; linarith
  have hsq2 : Real.sqrt ((1.22 - 0.8 : ℝ) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2) < 1.2461 := by
    rw [Real.sqrt_lt' (by norm_num)]; linarith
  have hpos : 0 < Real.sqrt ((1.22 - 0.8 : ℝ) ^ 2 + (0.34 + (Real.sqrt 3.36 - 1)) ^ 2) := by
    linarith
  constructor
  · rw [lt_div_iff₀ hpos]; nlinarith [h.1, hsq2]
  · rw [div_lt_iff₀ hpos]; nlinarith [h.2, hsq1]

/-- the outrigger's geometry, read off the frames (14:24-14:51) and the two shots along the bar
(20:50, 20:55) - none of it is in a figure.  Two rails leave the bar at the A's feet, `root`
apart, and taper over `endStation` to a narrow end `endWidth` across, where the winch sits; a
cross member with bolts at `standStation` is where the stand's 1.84 m foot bar lies across the
rails and the mast stands on the centreline -/
structure OutriggerGeom where
  root : ℝ
  standStation : ℝ
  endStation : ℝ
  endWidth : ℝ
  root_pos : 0 < root
  stand_pos : 0 < standStation
  stand_le_end : standStation ≤ endStation
  end_lt_root : endWidth < root

/-- his: the rails from the A's feet 0.98 m apart, the stand's cross member at 1.22 m, the end at
about 1.35 m and about 0.25 m across - the last two the roughest of the readings -/
def hashemiOutrigger : OutriggerGeom where
  root := hashemi.aBase
  standStation := ymHashemi
  endStation := 1.35
  endWidth := 0.25
  root_pos := by unfold hashemi; norm_num
  stand_pos := by unfold ymHashemi; norm_num
  stand_le_end := by unfold ymHashemi; norm_num
  end_lt_root := by unfold hashemi; norm_num

/-- `ym` is the station of the stand's cross member on the outrigger -/
theorem ym_is_standStation : ymHashemi = hashemiOutrigger.standStation := rfl

/-- "outside the circular axis of the base": the mast's foot is `apexH + ym` = 2.02 m from the
tube's axis, beyond the ring's 1.22 -/
theorem mast_beyond_ring : rollerRadius hashemi < hashemi.apexH + hashemiOutrigger.standStation := by
  have h := rollerRadius_hashemi_bounds
  have ha : hashemi.apexH = 0.80 := rfl
  have hs : hashemiOutrigger.standStation = 1.22 := rfl
  rw [ha, hs]
  linarith [h.2]

/-! ## 13. The tracker, the azimuth motor, the tow holding the dish -/

/-- "you must use a precise solar tracker ... installed on top of the solar dish in a way that is
perpendicular to the plane of the dish": the sensor's boresight along the dish's axis, so the
loop closes on the dish's own pointing.  Its error `ε` - precision and mounting misalignment
together - is a pointing error of the dish, and the spot moves `spot f ε`; the budget is the
receiver's half-size `h` -/
def TrackerBudget (f ε h : ℝ) : Prop := TandoorMount.spot f ε ≤ h

/-- the precision the receiver asks for: `tan ε ≤ h / f` -/
theorem trackerBudget_iff {f ε h : ℝ} (hf : 0 < f) :
    TrackerBudget f ε h ↔ Real.tan ε ≤ h / f := by
  unfold TrackerBudget TandoorMount.spot
  rw [le_div_iff₀ hf]
  constructor <;> intro h' <;> linarith

/-- "a small 12 volt electric motor with a gearbox", and the battery: the system is 12 V -/
def systemVolts : ℝ := 12

/-- the panel's current at 12 V is under half an ampere - `cable_drop_small`'s 1 A covers it -/
theorem panel_current : hashemiPanel.watts / systemVolts < 0.5 := by
  unfold hashemiPanel systemVolts
  norm_num

/-- the edge clip's lever arm in the open: `edgeClip_cross` over the distance from pulley to
clip -/
theorem wireLever_edge_formula (ym hp a ze t : ℝ) :
    wireLever (pulleyAt ym hp) (edgeClipAt a ze t) =
      ((ym * ze + hp * a) * Real.cos t + (hp * ze - ym * a) * Real.sin t) /
        Real.sqrt ((ym - a * Real.cos t - ze * Real.sin t) ^ 2 +
          (a * Real.sin t - ze * Real.cos t - hp) ^ 2) := by
  unfold wireLever
  rw [edgeClip_cross]
  congr 2
  simp only [pulleyAt, edgeClipAt, swungPt]
  ring

/-- interval arithmetic for what follows: a negative times a positive, from bounds on each -/
theorem mul_bounds_neg_pos {b r blo bhi rlo rhi : ℝ} (hb1 : blo < b) (hb2 : b < bhi)
    (hbhi : bhi ≤ 0) (hr1 : rlo < r) (hr2 : r < rhi) (hrlo : 0 ≤ rlo) :
    blo * rhi < b * r ∧ b * r < bhi * rlo := by
  have hbneg : b < 0 := by linarith
  have hrhi : 0 < rhi := by linarith
  constructor
  · nlinarith [mul_pos (neg_pos.2 hbneg) (sub_pos.2 hr2), mul_pos (sub_pos.2 hb1) hrhi]
  · nlinarith [mul_nonneg hrlo (sub_pos.2 hb2).le, mul_pos (neg_pos.2 hbneg) (sub_pos.2 hr1)]

/-- and a positive times a positive -/
theorem mul_bounds_pos_pos {x r xlo xhi rlo rhi : ℝ} (hx1 : xlo < x) (hx2 : x < xhi)
    (hxlo : 0 ≤ xlo) (hr1 : rlo < r) (hr2 : r < rhi) (hrlo : 0 ≤ rlo) :
    xlo * rlo < x * r ∧ x * r < xhi * rhi := by
  have hr : 0 < r := by linarith
  have hxhi : 0 < xhi := by linarith
  constructor
  · nlinarith [mul_nonneg hxlo (sub_pos.2 hr1).le, mul_pos (sub_pos.2 hx1) hr]
  · nlinarith [mul_pos (sub_pos.2 hx2) hr, mul_pos hxhi (sub_pos.2 hr2)]

/-- the square of a bounded negative -/
theorem sq_bounds_neg {x lo hi : ℝ} (h1 : lo < x) (h2 : x < hi) (hhi : hi ≤ 0) :
    hi ^ 2 < x ^ 2 ∧ x ^ 2 < lo ^ 2 := by
  constructor
  · nlinarith [mul_pos (sub_pos.2 h2) (by linarith : (0 : ℝ) < -(x + hi))]
  · nlinarith [mul_pos (sub_pos.2 h1) (by linarith : (0 : ℝ) < -(lo + x))]

set_option maxHeartbeats 800000 in
/-- "the tow is holding it up": at 60° of swing with the mast at 1.22 the wire's arm has fallen
to **0.38 m** from 1.03 at rest, two degrees short of the dead point, and the tension is
`W rcm sin 60° / 0.38` ≈ 2.3 W rcm - about twice the dish's weight -/
theorem wireLever_sixty_at_ym :
    0.37 < wireLever (pulleyAt ymHashemi 0.34)
        (edgeClipAt dishHalf (Real.sqrt 3.36 - 1) (Real.pi / 3)) ∧
      wireLever (pulleyAt ymHashemi 0.34)
        (edgeClipAt dishHalf (Real.sqrt 3.36 - 1) (Real.pi / 3)) < 0.38 := by
  rw [wireLever_edge_formula, Real.cos_pi_div_three, Real.sin_pi_div_three]
  unfold ymHashemi dishHalf
  have hz := AH_bounds
  have hr1 : (1.7320 : ℝ) < Real.sqrt 3 := by rw [Real.lt_sqrt (by norm_num)]; norm_num
  have hr2 : Real.sqrt 3 < 1.7321 := by rw [Real.sqrt_lt' (by norm_num)]; norm_num
  set z := Real.sqrt 3.36 - 1 with hzd
  set r := Real.sqrt 3 with hrd
  have hz1 : (0.833 : ℝ) < z := by rw [hzd]; linarith [hz.1]
  have hz2 : z < (0.8331 : ℝ) := by rw [hzd]; linarith [hz.2]
  have hB := mul_bounds_neg_pos (b := 0.34 * z - 1.22 * 0.8) (r := r) (blo := -0.69278)
    (bhi := -0.692746) (rlo := 1.7320) (rhi := 1.7321) (by linarith) (by linarith)
    (by norm_num) hr1 hr2 (by norm_num)
  have hzr := mul_bounds_pos_pos (x := z) (r := r) (xlo := 0.833) (xhi := 0.8331)
    (rlo := 1.7320) (rhi := 1.7321) hz1 hz2 (by norm_num) hr1 hr2 (by norm_num)
  have hN1 : (0.0441 : ℝ) <
      (1.22 * z + 0.34 * 0.8) * (1 / 2) + (0.34 * z - 1.22 * 0.8) * (r / 2) := by
    linarith [hB.1]
  have hN2 : (1.22 * z + 0.34 * 0.8) * (1 / 2) + (0.34 * z - 1.22 * 0.8) * (r / 2) <
      (0.0443 : ℝ) := by
    linarith [hB.2]
  have hu1 : (0.0984 : ℝ) < 1.22 - 0.8 * (1 / 2) - z * (r / 2) := by linarith [hzr.2]
  have hu2 : 1.22 - 0.8 * (1 / 2) - z * (r / 2) < (0.0987 : ℝ) := by linarith [hzr.1]
  have hv1 : (-0.0638 : ℝ) < 0.8 * (r / 2) - z * (1 / 2) - 0.34 := by linarith
  have hv2 : 0.8 * (r / 2) - z * (1 / 2) - 0.34 < (-0.0636 : ℝ) := by linarith
  have hu' := mul_bounds_pos_pos (x := 1.22 - 0.8 * (1 / 2) - z * (r / 2))
    (r := 1.22 - 0.8 * (1 / 2) - z * (r / 2)) (xlo := 0.0984) (xhi := 0.0987)
    (rlo := 0.0984) (rhi := 0.0987) hu1 hu2 (by norm_num) hu1 hu2 (by norm_num)
  have hv' := sq_bounds_neg (x := 0.8 * (r / 2) - z * (1 / 2) - 0.34) (lo := -0.0638)
    (hi := -0.0636) hv1 hv2 (by norm_num)
  have hD1 : (0.11716 : ℝ) < Real.sqrt ((1.22 - 0.8 * (1 / 2) - z * (r / 2)) ^ 2 +
      (0.8 * (r / 2) - z * (1 / 2) - 0.34) ^ 2) := by
    rw [Real.lt_sqrt (by norm_num)]; nlinarith [hu'.1, hv'.1]
  have hD2 : Real.sqrt ((1.22 - 0.8 * (1 / 2) - z * (r / 2)) ^ 2 +
      (0.8 * (r / 2) - z * (1 / 2) - 0.34) ^ 2) < 0.11753 := by
    rw [Real.sqrt_lt' (by norm_num)]; nlinarith [hu'.2, hv'.2]
  have hDpos : 0 < Real.sqrt ((1.22 - 0.8 * (1 / 2) - z * (r / 2)) ^ 2 +
      (0.8 * (r / 2) - z * (1 / 2) - 0.34) ^ 2) := by linarith
  constructor
  · rw [lt_div_iff₀ hDpos]; nlinarith [hN1, hD2]
  · rw [div_lt_iff₀ hDpos]; nlinarith [hN2, hD1]

/-! ## 14. The start, the receiver on its post through the slot, the shadow test -/

/-- the receiver's post stands straight below F.  The sun-side rim point, `(a, -ze)` at rest
with `ze = f - sag`, swung by `t` (`swungPt`, the face turning away from the mast), is straight
below F - on the post - exactly when `tan t = a / ze`: the swing at which the post leaves the
dish through the rim, and at which the rim is deepest below F -/
theorem rim_under_F_iff {a ze t : ℝ} (hz : 0 < ze) (hc : 0 < Real.cos t) :
    (swungPt a (-ze) t).1 = 0 ↔ Real.tan t = a / ze := by
  simp only [swungPt]
  rw [Real.tan_eq_sin_div_cos, div_eq_div_iff hc.ne' hz.ne']
  constructor <;> intro h <;> linarith

/-- on his panel: `tan t = 0.8 / FH` = 0.96, **43.8° of swing** - the sun 46° up.  Higher sun,
the post is inside the panel and needs the slot from the centre to the rim; lower, the dish
hangs beside it -/
theorem slot_exit_hashemi :
    0.960 < dishHalf / (Real.sqrt 3.36 - 1) ∧ dishHalf / (Real.sqrt 3.36 - 1) < 0.9605 := by
  unfold dishHalf
  have h := AH_bounds
  have hpos : 0 < Real.sqrt 3.36 - 1 := by linarith [h.1]
  constructor
  · rw [lt_div_iff₀ hpos]; linarith [h.2]
  · rw [div_lt_iff₀ hpos]; linarith [h.1]

/-- the receiver's post, at the dead centre of the frame (the user): the vertical through F from
the bar's midpoint, so its height to F is the legs' `upright - holeDown`, **1.25 m** -/
theorem receiverPost_height : hashemiLeg.upright - 0.05 = 1.25 := by
  unfold hashemiLeg
  norm_num

/-- "our solar dish is made of 5 cm mirrors, so its focus width is more": a flat facet of width
`w` throws a beam that does not converge - its footprint at F is the facet's own width plus the
sun's full angle, 9.3 mrad, times the focal length -/
noncomputable def facetSpot (w f : ℝ) : ℝ := w + f * 0.0093

/-- his: **6 cm** across at F - "a bigger spiral tube" -/
theorem facetSpot_hashemi : facetSpot 0.05 dishF = 0.0593 := by
  unfold facetSpot dishF
  norm_num

/-- a coil about 12 cm across (read off the frames) over a 6 cm spot leaves 3 cm of pointing
margin: the tracker's budget is `tan ε ≤ 0.03`, **1.7°** - what "precise" comes to here -/
theorem tracker_margin_hashemi (ε : ℝ) : TrackerBudget dishF ε 0.03 ↔ Real.tan ε ≤ 0.03 := by
  rw [trackerBudget_iff (by unfold dishF; norm_num)]
  unfold dishF
  norm_num

/-! ## 15. The end -/

/-- the lowest sun the wire reaches with the mast at 1.22: its elevation is `90° - t*`, with
tangent `1 / tan t*` between 0.537 and 0.538 - **28°**.  "The sun is on the horizon and the dish
is pulled up" is the dish at that limit -/
theorem lowestSun_tan_at_ym :
    0.537 < 1 / ((ymHashemi * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        (ymHashemi * dishHalf - 0.34 * (Real.sqrt 3.36 - 1))) ∧
      1 / ((ymHashemi * (Real.sqrt 3.36 - 1) + 0.34 * dishHalf) /
        (ymHashemi * dishHalf - 0.34 * (Real.sqrt 3.36 - 1))) < 0.538 := by
  have h := deadTan_at_ym
  constructor
  · calc (0.537 : ℝ) < 1 / 1.86 := by norm_num
      _ < 1 / _ := one_div_lt_one_div_of_lt (by linarith [h.1]) h.2
  · calc 1 / _ < 1 / 1.859 := one_div_lt_one_div_of_lt (by norm_num) h.1
      _ < (0.538 : ℝ) := by norm_num

/-- **the dish's own swing reaches the vertical**: at 90° the rim is `a` below F
(`edgeDepth_horizon`), under the post's `upright - holeDown`; the deepest reach anywhere is F-C
(`clearance_hashemi`).  His length figure's low-sun end; the pendulum is not what limits the
machine -/
theorem dish_swings_to_vertical : dishHalf < hashemiLeg.upright - 0.05 := by
  unfold dishHalf hashemiLeg
  norm_num

/-- **the wire's reach is**: with the clip on the mast-side rim, the wire's moment at the vertical
is `hp ze - ym a` (`edgeClip_cross` at 90°), negative on his numbers - the winch cannot hold the
dish there, and the dead point lies before it -/
theorem wire_short_of_vertical : 0.34 * (Real.sqrt 3.36 - 1) - ymHashemi * dishHalf < 0 := by
  unfold ymHashemi dishHalf
  linarith [AH_bounds.2]

/-- what the vertical takes from the mast-side rim: the pulley's rise over the bolt line against
its distance out, `ym a ≤ hp ze` - the pulley at least `a / ze` of `ym` above the bolts -/
def ReachesVertical (ym hp a ze : ℝ) : Prop := ym * a ≤ hp * ze

theorem reachesVertical_iff {ym hp a ze : ℝ} (hz : 0 < ze) :
    ReachesVertical ym hp a ze ↔ ym * a / ze ≤ hp := by
  unfold ReachesVertical
  rw [div_le_iff₀ hz]

/-- on his machine that is a pulley **over 1.17 m** above the bolts at 1.22 m out - a mast of
2.4 m, not 1.59 - or a wire that does not cross the mast-side rim -/
theorem mast_for_vertical_hashemi : 1.17 < ymHashemi * dishHalf / (Real.sqrt 3.36 - 1) := by
  unfold ymHashemi dishHalf
  have h := AH_bounds
  rw [lt_div_iff₀ (by linarith [h.1])]
  linarith [h.2]

end TandoorHashemi

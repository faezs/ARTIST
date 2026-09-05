# The mount synthesized by FACT: blade trunnions on the axis through F, a cradle, a diaphragm fine stage

Third pass on the mount for the Cassegrain Hashemi machine, corrected. The second pass (`../hashemi_pneumatic/`)
had the right constraint topology for the coarse motion, four wires through F, but actuated it with a hose and
drew a pipe. The first draft of this pass put a two-stage cross-blade pivot AT F with a cage of struts to the
dish; checking it before publication found two faults, recorded here because the correction is the design:

- the four struts from F to the rim shaded the aperture in projection along the sun line (each crossed the
  annulus 0.5-2.1 m as a 60 mm radial strip: 2.9 % together, against 0.4 % for the second pass's wires);
- the block at F was checked for forces only. The crosswind's moment about F (3.0 kN m at 9 m/s, 23 kN m at
  25) lands on the pivot's constrained rotations; on cells 0.33 m apart it would have put 3.2 kN into blades
  that buckle at 3.5 kN.

Both are fixed by one move that FACT licenses directly: the constraint space of a rotation is every line meeting
its axis, wherever along the axis the constraint sits (thesis 3.2.1). The elevation axis through F leaves the
dish's shadow at |y| = 2.1 m, so the same blade cells now sit at |y| = 3.25 m in two trunnion blocks, where they
shade nothing and where the 6.5 m between them turns the wind's moment into a pair of forces along the dish
axis. Everything else follows Hopkins's six steps (Fig. 2.7); `synth.py` prints each step with its rank,
reciprocity, stress, clearance and jack checks (`out/synth.txt`), `shading.py` rasterises the model along the
sun line (`out/shading.txt`), `geometry.py` holds the members that `model.py` draws and `synth.py` checks.

## The synthesis

| step | result |
|---|---|
| 1 desired motions | azimuth about the vertical through F (220°), elevation about the horizontal through F (71°, el 12-83), fine tip, tilt and focus about the vertex (±20 mrad, ±30 mm) |
| 2 freedom spaces | azimuth and elevation each 1 DOF Type 1; at an instant the pair is 2 DOF Type 1, a disk of intersecting rotation lines through F; the fine motion is 3 DOF Type 1 about the vertex |
| 3 parallel or serial | serial: 220° and 71° are beyond any parallel flexure |
| 4 intermediate spaces | bearing 1R vertical → flexure 1R horizontal → flexure 3 DOF Type 1: 1 + 1 + 3 = 5 twists, the five wanted; the roll about the dish axis is fixed by no stage and needed by none, so the chain is not underconstrained (p. 36) |
| 5 ground and stages | ground: the deck and the tube (F is on the tube; the strip's own ring at the tube top is slaved to the fork in azimuth). Stage 1: the fork, a ring beam r 3.6 m on the deck rail (Hashemi's ring rail, kept) and two 250 × 8 posts up to the elevation axis. Stage 2: the cradle, two 150 × 5 side arms at |y| 2.45 m outside the rim (2.22 m), a back frame 0.6 m behind the vertex, counterweights 2.6 m up-sun of the axis. Stage 3: the dish on its back ring |
| 6 constraints | below |

**Elevation: two trunnion blocks.** The constraint space of a rotation is every line meeting its axis; a blade
whose plane contains the axis supplies three such lines. Each block is two stages in series, each three cells of
two 17-7PH blades 200 × 1.0 × 120 mm at ±45° crossing on the axis, the stage-2 pitch-row cell with the blade
widened and thickened for the loads. Each stage: 18 lines, rank 5, one DOF, the rotation about the axis through
F; reciprocal products of all 48 lines with that rotation 0; the two blocks in parallel across the cradle: rank
5, DOF 1, the same rotation. Range ±25.8° per stage at 0.25 σ_y held; the 71° needed is ±17.8° per stage, 258 MPa
= 0.17 σ_y at el 12 and 83, neutral at 47.5°. Spring 56 N m/rad per crossed pair, 167 per stage, 83 per block,
167 N m/rad for the pair; 103 N m at the ends of travel. Loads: the cradle (650 kg with its water, balanced) and
the wind, resolved into the ±45° blade families over every elevation and wind direction; the worst blade carries
906 N in plane at 9 m/s (crosswind, el 44) and 1940 N at 25 m/s against 9.1 kN fixed-fixed buckling: SF 10 and
4.7. No bearing, no backlash, no lubricant, and nothing in front of the mirror.

Both blocks hold the axial direction y, an over-constraint across 6.5 m that the posts absorb: 13 K between
cradle and fork is 1.0 mm, which the 4.3 m posts (328 kN/m each) give at 166 N; the 9 m/s crosswind moves the
axis 1.1 mm in y, 0.3 mrad of pointing, inside the fine stage. The two axes are aligned to 0.2 mrad at assembly.

**Azimuth.** The ring beam on the deck rail. Its rollers' lines meet the vertical axis, which is the constraint
space of that rotation, but a bearing is not a flexure and this memo does not call it one. Ring diameter 7.5 m
inside the 7.8 m the dish's sweep already needs.

**The cradle.** Two side arms from the blocks' moving bars along the dish axis, 2.6 m toward the sun and 4.6 m
back to the frame, at |y| 2.45 m: outside the rim toroid by 155 mm and outside the aperture in projection at
every hour, so the light never meets them. A C-ring r 1.75 m behind the dish, spokes and diagonals to the arms.
Both the frame ring and the dish's back ring are open 80° about the slot direction, because the tube passes
through the membrane anywhere along the slot between el 55 and 83 and continues behind it; the worst clearance
of tube to cradle over the 59 Quetta positions is 71 mm (the back ring's end, summer 11 h, el 75). 91 L of water
2.6 m up each arm puts the cradle's centre of mass on the axis.

**Fine stage.** 3 DOF Type 1 about the vertex: constraint space every line in the back plane plus a normal
torque (thesis Fig. 3.38). Hopkins's own realisation is a plate on three flat arms in the plane (Fig. 4.3):
here three tangential blades 450 × 60 × 1.5 mm flat in the back plane between the dish's back ring r 1.46 m and
posts on the frame, at 60°, 180° and 300° from the slot so none stands in the tube's corridor. Nine lines, all in
the plane, rank 3, DOF 3: tip, tilt and focus; reciprocal products 0. ±20 mrad bends a blade 29 mm, 130 MPa,
0.09 σ_y; tangential stiffness 40 MN/m; the aluminium dish's 0.62 mm of radial growth against the steel frame
bends the blades in-plane at 114 MPa, so the stage is athermal without a sliding fit. The actuation space of this
type is the box of lines normal to the plane (Fig. 4.3B): three flexure struts, rods with 8 mm necks at both
ends so each is a pure-force line, on the normals at r 1.6 m (90°, 210°, 315°), driven by sealed water columns.
Struts and blades together: rank 6, DOF 0. Locked, 90 MN m/rad about the vertex; the drag's asymmetry gives
4 µrad at 9 m/s. One millilitre is 62 µrad.

## Actuation (thesis ch. 4)

Elevation: with the cradle balanced, the torque on the axis is the wind's, 3.0 kN m at 9 m/s and 23 kN m at 25,
plus 103 N m of blade spring. A crank 1.0 m from the axis on each arm, leaning 20° up-sun of the perpendicular,
and a self-locking Tr40 screw jack from a bracket 0.25 m behind and 2.75 m below the axis on each post: length
2.06-3.22 m, lever 0.81-1.00 m over el 12-83, 1.9 kN per jack at 9 m/s, 14 kN at 25, no power to hold;
about 50 MN m/rad each, 30 µrad under the 9 m/s mean. Pumping 46 L from the up-sun tanks to a tank on the frame
cancels the 9 m/s mean torque, turgor at the speed of a pump; the jacks hold the rest. Azimuth: a pinion on the
ring beam. Fine: the columns on the beam-centroid loop at the tube's waist.

## Shading

`shading.py` projects every solid along the sun line and rasterises what lies in front of the membrane inside the
annulus 0.5-2.1 m, at 1 cm. The mount: 0.000 m² at equinox noon, summer noon and equinox 9 h. The cass machine's
own parts: the vertical tube 9.8 % at el 59 and 10.0 % at el 37 (Hashemi's near method stands the tube in the
light below F at every elevation but the highest), the strip's ring 1.3-1.6 %, the rim toroid 0.14 %; the strip
itself is the Cassegrain secondary's obscuration. Those numbers belong to the other fork's ray trace, not to this
mount; they are printed so the two are not confused.

## Footprint and scale

The roof is the dish's sweep, 9.2 × 7.8 m for a 2.1 m dish at f 4.0; the ring beam (7.5 m) and the posts sit
inside it. At el 12 the tank ends reach 1.6 m south of the tube axis at z 10.5; at el 83 they stand at z 12.8. At
the same f/D the whole drawing scales: a 1.5 m dish needs 6.5 × 5.6 m, a 1.05 m dish 4.6 × 3.9 m. The blade
pivots scale with it: at constant t/L the range and the stress at range are unchanged, wind loads and blade
buckling both go as L², so the wind safety factors are scale-free, and weight goes as L³, so the smaller machine
is lighter on its blades. The fine stage's µrad per millilitre goes as L⁻³.

## What is compliant and what is not

Compliant, and synthesized: the elevation pivots (two blocks of twelve blades, exact 1R about the axis through F
over 71°), the fine stage (three blades, exact 3 DOF Type 1, microradians), the flexure struts of the actuators,
and the posts as the deliberate compliance that lets two 1R blocks share one axis. Not compliant, and not
pretending: the ring bearing, the tube, the arms, the jacks. The hose is gone; the water stays as counterweight,
trim and the fine stage's incompressible columns.

## The flower

Read organ by organ, it is a heliotropic bowl flower with an inferior ovary (`flower_organs.py`, and the plates on
the register): roots the deck and its rail; stalk the ring beam and the two posts; pulvinus the trunnion blocks,
the joint that turns the head to the sun; turgor the water at the arms' ends that balances and trims it; calyx
the cradle; corolla the bowl; style the focal tube up the middle of the bowl, the light conducted down inside it
as a pollen tube runs down a style; stigma the strip under F; ovary the tandoor below the ground. Not a flower
in silhouette: the stalk is a fork of two posts, because the flexure pivot needs two blocks far apart to turn the
crosswind's moment into forces.

## Open

- The blocks' bars, the post saddles and the ring beam are drawn as bars and tubes; their own stiffness against
  the blade loads and the ring's roller stiffness are the next check.
- The strip's ring at the tube top and the fork's ring on the deck must turn together; a shaft alongside the tube
  or a slaved drive, not yet drawn.
- The cradle's first mode on the arms' bending is about 6 Hz with the dish at the tips; the posts' about 5 Hz;
  both above the gust band, neither yet computed with the real sections.

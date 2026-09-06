# The machine sets itself up: the inflatable fork as a soft-body simulation

The brief's first line: a water hose for the frame, actuated like a vine robot, so that setup and tracking are
automatic. This folder is that machine running. It is the FACT mount of `../fact_mount/` (two flexure trunnion
blocks on the elevation axis through F, a cradle, a diaphragm fine stage) with the hose as its frame: the two
posts, the two arms and the two counterweight tubes are closed fabric tubes, pressurised and grown from stubs
the way an everting vine robot grows; water pumped into the counterweight tubes for the balance; a double-acting
pneumatic strut per side from the deck ring for the elevation; the deck ring for the azimuth. `setup_sim.py` is
the simulation (NVIDIA Warp 1.8 kernels), `out/setup_anim.json` its frames for the register's viewer (sheet 45),
`out/setup.gif` the film, `inflated_beam.py` the tube checks from the theses, `koopman_fit.py` the lifted
linear model of the tracking, `test_column.py` the one-column check.

## What the first simulation taught: one stem cannot do it

The second pass's machine (`../hashemi_pneumatic/`) was a single stem from a root on the deck with a bridle of
four wires to F. Simulated as a growing, steerable tube, it could reach the head's place on the sphere about F
but not the head's attitude, and the reason is geometric, not numerical. The dish must point at the sun, so the
stem's tip must arrive at the hub along the dish axis; the hub lies on the far side of F from the sun; the root is
fixed on the deck. In the morning the hub is 4 m west of the root and the required tip tangent points east and
up: a curve from a vertical root that goes west and arrives pointing east turns through almost 300 degrees. A
vine's curvature is bounded by its pouch shortening (about 0.45 rad/m for a 1 m tube); over 5 m that is 130
degrees. The stem's tip position and tip tangent are coupled through one curvature, and the day needs them
independent. Rotation about an axis through F gives both at once, which is why the fork exists: the arms fixed
on the trunnion axis put the vertex on the sphere and the dish axis through F in the same motion. The stem is
kept as the record; the hose becomes the fork.

## The machine in the simulation

| part | in the simulation | in the design |
|---|---|---|
| posts | two closed tubes r 0.6 m, 12 x 14 mesh, base rings pinned on the deck ring, grown 1.05 to 4.52 m by lengthening rest lengths at the blower's rate with feedback on the axis height | 250 x 8 steel in `../fact_mount/`; here fabric at about 40 kPa (80 kPa in the design) |
| trunnions | two shared particles per side on the elevation axis, so the post-top body and the cradle's axle body can only rotate about the line through them: the exact 1R of the blade blocks | 12-blade cross-blade pivots, rank 5, DOF 1 |
| arms | two tubes r 0.4 m from the axle bodies along the cradle axis, grown 0.3 to 4.1 m; the head truss on their caps | 150 x 5 steel |
| counterweights | two tubes r 0.3 m the other way, grown 0.3 to 2.1 m; 91 kg of water per side pumped into the tube's own walls | 91 L tanks at 2.6 m |
| elevation drive | one double-acting pneumatic strut per side, from a pinned anchor on the deck ring 0.25 m behind the axis's vertical to a crank 1 m from the axis at the third pass's angle (lever 0.75-0.94 m over the range), force-capped at 10 kN, rest length set from the commanded elevation | crank + Tr40 screw jack |
| azimuth | the post base rings and strut anchors turned kinematically about F's vertical to the sun's azimuth | the deck ring on rollers |
| head | frame ring r 1.75 m, vertex 0.6 m toward F, rim r 2.16 m, 100 kg, a clique of stiff springs on the arm caps | back frame, dish, fine stage |

Sequence from the stow (posts short, cradle face-up on its stubs directly under F, tanks empty): tubes
pressurised; posts grow until the axis is a hand's width above F (t 3-17 s of 40); arms and counterweight
tubes grow (17-26 s), the head descending under F; water pumped (24-30 s); the struts turn the cradle from
el 90 to the morning sun (30-39 s); then the day, 8-16 h in 40 s, azimuth on the ring and elevation on the
struts, both closed on a sun sensor on the frame (the struts' command and the ring's angle carry an integral
bias from the frame's pointing error), and the fine stage closed on the sun once the frame is within 3 degrees.
The pump's minutes are the simulation's seconds. Numbers from the run are in the register's title block
for sheet 45 and in `out/setup_log.json`.

A first version of the drive, two pull-only muscles per side hung from an anchor under the axis, lost its lever
as the cradle came down and left the head dragging on the deck at 57 degrees; the geometry the third pass had
already searched for its jack was put back.

## The solver, and why it is ours

- warp.sim's XPBD integrator sums Jacobi constraint deltas without normalising by a particle's valence; on the
  head's clique and the tubes' nets it diverges in one substep. An averaged-Jacobi version converges too slowly
  for the loads: the head sagged to the deck and the posts crumpled while their rest lengths grew.
- Inflation as an explicit pressure force on light membrane particles could not carry the heavy cap and head
  through the projections (mass ratio 35), so the tubes folded. Inflation is now one volume constraint per closed
  tube (base cap, wall, tip cap), solved exactly each iteration; the target volume is the tube's rest volume at
  its current growth plus 2 %, and the walls' hoop strain against that over-volume is the pressure (10-50 kPa in
  this fabric over the run; reported per tube from the strain).
- Constraints are solved Gauss-Seidel by graph colouring (46 colours), tension-only for the fabric, with
  long-range attachments from each tube's base to its rings and cap so growth cannot lag by solver error. The
  axial rest lengths are 1.2 % shorter than the tube's nominal length, so the pressure holds the walls in axial
  tension (p r / 2) as in a real inflated beam; without that the compressed side of a bent tube went slack at
  once and the posts leaned far more than E t pi r^3 allows. Masses
  are the machine's: blocks and saddles 5-20 kg, flanges 1 kg, fabric 0.15 kg per node, water in the counterweight
  walls.
- The lone inflated column carries 150 kg 1.2 m off-centre and grows 1.05 to 4.5 m with a 15 cm lean
  (`test_column.py`); the machine's posts collapsed in the full model until a bookkeeping fault was found: the
  base-to-cap length constraint was not in the tube's growth set and clamped the post at its stub length.

## Checked against the theses (resources/)

- Blumenschein 2019 (Stanford), ch. 2: the growth force is P A (eq. 2.1) less a yield force and a viscous term
  (eq. 2.3), the Lockhart-Ortega turgor law r = phi (P - Y)^n that plant cells obey; ch. 4: general actuator
  routing for steering, which is what the stem's one-sided shortening was.
- Coad 2021 (Stanford), 4.3.2-4.3.3: the inflated beam's axial buckling force (eq. 4.2) and crushing force P A
  (eq. 4.3); the curved beam's bending moment P A R against the tail's T_T D.
- McFarland and McGuinness 2025 (arXiv 2510.25727): transverse collapse of a vine robot under its own weight,
  M = P pi D^3/8 (Leonard; Comer and Levy), with tail tension and with inflated supports; validated on
  1.2-8.5 cm tubes at 2-28 kPa.
- Jitosho, Agharese, Okamura, Manchester (ICRA): a rigid-link dynamics simulator for vine robots with growth as a
  rate constraint, the same idea as the rest-length growth here (their code is Julia, `resources/Vine_Simulator`).
- `inflated_beam.py`: for the simulation's 40 kPa the posts have SF 9 on wrinkling and 18 on collapse under
  1.5 kN m, the arms 1.8 / 3.6 under half the head at el 12, the counterweight tube 1.0 / 2.1 with the water at
  its tip; at the design's 80 kPa each doubles. Water in the tube walls halves the counterweight moment.

## The simulation on the fourth-pass geometry (`setup_sim4.py`)

The published run is now the machine of `../coude/`: one inflatable stalk r 0.5 m at the azimuth axis, grown from a
0.5 m stub to the yoke's height (the neck at env z 6.94); the yoke body on its cap with M4, the two hinge points
of the hollow pivot on the neck axis and the jack's anchor; the head body (neck bar, M3, crank, back frame, rod
posts, column feet) hinged on those two points; the dish body (back ring, vertex, rim, the secondary on its style)
on the fine stage; two counterweight hoses r 0.35 m, one 1.2 m behind the neck on the head and one 2.0 m beyond the
stalk on the yoke, grown from stubs and pumped full (the water masses come from the built moment balance about
the neck and about the stalk, printed at the start; the first draft's 136 kg beyond the stalk balanced the head
without its own neck counterweight and left 3.7 kN m on the stalk); the jack from the yoke's arm
to a 0.8 m crank on the neck bar, force-capped at 15 kN; the stalk's base ring turned kinematically for the
azimuth. Stow: stalk short, head face-up over the neck, hoses empty. Sequence: the stalk grows (t 3-17 s of 40),
the hoses grow (17-26 s) and fill (24-30 s), the jack turns the head from el 90 to the morning sun (30-39 s),
then the day with the coarse loops on the sun and the fine stage closed once the frame is within 3 degrees. The
water columns' cap is 50 kN (a 5 kN cap let the dish slip 8 degrees on its columns in the start-up swing). The
third-pass fork version (`setup_sim.py`, `out/setup_anim.json`) is kept as the record.

Two things the first fourth-pass runs taught. The stalk's volume target was keyed to the third pass's tube name
("post"), so it stayed at the full-length volume while the stalk was short (a balloon, 1.4 MPa on the hoop
readout) and then fell below the grown length once the height feedback pushed the growth past 1.0: an
under-filled tube has no pre-tension, and a pinned-base sock carrying 3.7 kN m simply leaned 0.3 m and took the
head with it; the jack then turned the head against a yoke that turned the other way, and the pointing had no
relation to the command. The volume constraint is the pressure: it must follow the grown length exactly, and a
tube's stiffness in this solver is worth nothing without its over-volume. Then two more: the jack's command must be
a fixed function of the elevation from the yoke's own geometry, not recomputed from the anchor's current position
(that recomputation fed the stalk's bending back into the command and pitched the yoke 5 degrees); and the crank's
lean had the wrong sign against `geometry.crank_dir`, which put the jack's dead centre at el 34 so that below it the
head sat on the other branch (el 54 when 14 was asked). With the design's crank (20 deg from -n toward the dish),
the anchor 0.6 m down-sun and 1.2 m below the neck on the yoke and a stiff (1 MN/m, 15 kN) screw jack, the head
follows the command. Last, two bookkeeping errors that read as physics: the run's log judged each frame's end state
against the sun of the frame's start, and in a day compressed to 40 s the sun moves 0.08 degrees per frame, so the
loops (which correctly drive the state at the start of a frame onto that frame's sun) were reported 0.1 degrees off
all day, dish and frame alike; the log now uses the sun of the instant it judges. And the focus term drove the piston
the wrong way (longer columns push the dish forward, so a vertex too far needs shorter ones), which parked the piston
at its +7 mm stop.

The published run (`out/setup4_anim.json`, `out/setup4_log.json`, sheet 45): the stalk reaches the neck height at
t 14 s and holds it (g 1.01, hoop readout 182 kPa); 260 kg and 409 kg of water go into the hoses; the head arrives
0.3 degrees from the morning sun with the vertex 1 cm from its place at t 40 s; over the compressed day the frame
holds 0.04 degrees on average (0.5 at the very start), the dish on the fine stage 0.014 degrees (0.004 after the
first sixth of the day, i.e. the loop's resolution in single precision, not the stage's), the vertex within 2 cm, the
jack 0.3 kN at the end and 15 kN (its cap) only in the turn. The Koopman fit on this run (`out/koopman4.txt`): DMDc
one-step 2.2 cm / 0.12 degrees, 12 s roll-out 35 cm / 0.5 degrees; the quadratic lift again overfits. Second, the counterweight beyond the
stalk in the first draft (136 kg) balanced the head alone; the head's own neck counterweight also sits 1.4 m from
the stalk, so the yoke's counterweight must carry both (267 kg at 1.6 m in the design; in the simulation the two
hose masses are computed from the built moment balance and printed at the start).

## To microradians: the fine stage in the loop

The fork lands the dish inside the fine stage's range; the fine stage does the pointing. In the simulation the
head is now two bodies: the back frame on the arms' caps, and the dish (back ring, vertex, rim) held to the frame
by the FACT diaphragm of `../fact_mount/`: three tangential rods in the dish's back plane (three lines, rank 3,
leaving tip, tilt and focus) and three water columns on the normals at r 1.6 m, modelled as force-capped struts
whose rest lengths are commanded. Once the coarse stage has arrived, the loop closes on the sun: the small
rotation that takes the dish's normal onto the sun line is turned into three column length changes
(u_k = (eps x r_k) . n, plus a common piston that keeps the vertex 4 m from F), integrated at 2 /s and clipped
to +-32 mm (+-20 mrad). The run then shows the cradle wandering by degrees, from the posts' sway, the arms'
droop and the strut servo's lag, while the dish holds the sun to a fraction of a degree; the number is in the
title block of sheet 45. What the simulation cannot show is the last decade: its columns are 1 MN/m struts and
its positions single precision, so its residual is the loop's, not the stage's. The microradians come from the
stage's own numbers in `../fact_mount/synth.py`: 90 MN m/rad locked, 4 urad under the 9 m/s drag asymmetry,
62 urad per millilitre, closed on the beam centroid at the tube's waist rather than on a sun sensor. The chain is
therefore: inflated fork, degrees; strut and ring servos on the optical error, tens of milliradians at the gust
band; fine stage on the beam centroid, microradians; and the membrane's own figure (the other fork's 0.5 mrad
slope) sets the spot, not the pointing.

## Control: the Koopman step

The hand loops in `setup_sim.py` (growth rate on the axis height, strut rest lengths from the elevation
command) are enough to show the sequence. For the real controller the plant is nonlinear and slow: two post sways,
the arm droop, the struts' compliance, the water's slosh. `koopman_fit.py` lifts the tracking data (vertex, axis
height, pointing error; inputs elevation command and sun azimuth) with pykoopman's DMDc and EDMDc, the approach
of Bruder et al. (RSS 2019, T-RO 2021) for pneumatic soft arms, and reports the one-step and roll-out errors in
`out/koopman.txt`. The linear lifted model is what a model-predictive controller would run at the struts' valves
and the ring's drive.

## Open

- The dish membrane's own pumping is the other fork's; here the dish is a rigid fan.
- Wind is a kernel (`--wind`) but not run in the published frames; the storm answer is to vent: the head comes
  down face-up onto its stubs and the posts onto the ring.
- The trunnion blocks' blades are hinges here; their spring (167 N m/rad) is 2 % of the drive torque and was
  left out.
- The struts are force-capped and compliant (50 kN/m); their pressure dynamics are not modelled.
- The fabric springs have a fixed stiffness per spring, so a stub with its rings four times closer is four times
  stiffer than the grown tube and its pressure readout starts high (300 kPa) and settles to about 45 kPa when
  grown; scaling the spring stiffness with the ring spacing as the tube grows is the fix.
- A day compressed into 40 s makes the strut servo lag the sun; the coarse loop on the sun sensor removes most of it, and the real day is 700 times slower.

## The flower in the simulation (`setup_sim5.py`, fifth pass)

The machine the user meant, as a soft-body system in the fourth pass's solver: the exact hashemi.ini membrane (a 2.1,
R 8, with its 0.5 m hole) as a rigid clique of 130 kg on six bilateral force-capped struts; the struts' base joints on
a receptacle ring (r 1.5) carried by a pedicel from the stem top (kinematic in this run: it places the ring 1.2 m
behind the platform ring, coaxial with the head, so the hexapod always works near its nominal, well-conditioned
pose); the platform ring r 1.0 on the head's back 0.6 m behind the vertex; F fixed on the light pipe. The head law is
the env's (audit F2): hub on the orbit sphere 4 m from F, axis the bisector of the sun and the line to F, the
pose per quarter hour chosen by `../tree/path.py` within beta 36 deg, the pedicel's reach and continuity.

Sequence: stow (receptacle horizontal at the stem top, head face-up at the hexapod's nominal height); setup by
interpolating the pose to the first sun and pumping the six struts accordingly (in one assembly mode; interpolating
the leg lengths instead let the hexapod change mode); a calibration hold with a smoothed +-2 mm dither on each strut,
from which the machine identifies itself (DMDc in velocity form: state = pose error and strut command, input =
command increment; validated on a 30 % hold-out against persistence); then the day with an integral loop on the
pose error through the identified static gain (the analytic Jacobian as fallback if the identified gain has no
skill), 3 mm per frame at most; the dish's drag and pitching moment with gusts (mean plus two sinusoids, peak
pressure 3 x mean, the audit's factor), from the north (onto the back) or the south (into the bowl).

What the first version got wrong, in order, each visible in a run: the strut force read as stiffness x residual
(meaningless at 1e8 N/m; read the multiplier); equal base and platform radii (singular in yaw when coaxial); a
stiffness mismatch between legs and head truss the Gauss-Seidel solver could not converge; a 180 deg twist between
the receptacle's and the head's angular frames at the face-up stow (the legs started crossed); the stow's platform
ring below the base ring after deepening the calyx; the rotation part of the pose error with the opposite sign to
the translation part (positive feedback); the identification regressed on the dither's level instead of its
increment (no skill on a quasi-static plant); and, decisive, a fixed receptacle: the hexapod then has five
well-conditioned islands over the day and must jump 1.6 m between them through condition numbers above 100. A
fixed-base hexapod cannot serve a 5 m workspace; it serves the last decimetres. The pedicel is the stage the
kinematics demanded.

Results (`out/*_ident.txt`): setup lands at 0.0 cm from focus; the identified gain has skill 0.95-0.97 over
persistence and lies 39 % from the analytic Jacobian (the head truss's compliance); the day at 0, 9 and 12 m/s mean
with gusts (peaks 15.6 and 20.8 m/s), wind from the north or the south: the image at F holds 0.1-2.5 cm in steady
tracking against the 4.9 cm half power, strut forces under 3.5 kN, strut strokes 1.41-1.55 m, the pedicel's boom
0-3.2 m long, elevation -2 to 18 deg, azimuth +-68 deg. The 13-21 cm maxima are one quarter-hour pose step that the
compressed day turns into a jump. Not in this run: the pedicel's and the stem's compliance (the stem alone is 2 mrad
= 1.8 cm at F from `../tree/wind_size.py`), front/back asymmetry of the drag, the hole's and slot's effect on the
membrane's own figure, and real gust spectra.

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
struts. The pump's minutes are the simulation's seconds. Numbers from the run are in the register's title block
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
- Constraints are solved Gauss-Seidel by graph colouring (about 30 colours), tension-only for the fabric, with
  long-range attachments from each tube's base to its rings and cap so growth cannot lag by solver error. Masses
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
- A day compressed into 40 s makes the strut servo lag the sun by degrees; the real day is 700 times slower.

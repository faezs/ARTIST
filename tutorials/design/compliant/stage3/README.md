# Stage 3: the mount

Fourth pass, `coude/`: everything behind the dish. A Cassegrain head on the pumped membrane with the secondary on a
conical style inside its own shadow, the beam back through a 0.12 m hole, one fold on the head along the neck
axis through a hollow cartwheel flexure trunnion, a second fold at the stalk down to the cass machine's F2 and its
unchanged underground relay. Shading above the deck 2.5 % of the aperture against 17-25 % for the machine with
Hashemi's tube; four reflections above ground instead of two; net light 1.03-1.14 x. `coude/optics.py`,
`synth.py`, `shading.py`, `model.py`, `memo.md`; sheets 46-51. The passes below are the record.

## Third pass (record): the FACT fork with Hashemi's tube

Third pass, `fact_mount/`: the mount synthesized by FACT to the end and built from blades. Azimuth: a ring beam on
the deck rail (Hashemi's ring rail) carrying a fork. Elevation: two two-stage cross-blade flexural pivots ON the
axis through F but OUTSIDE the aperture, at |y| 3.25 m (the constraint space of a rotation is the same everywhere
along its axis; there the blades shade nothing and the 6.5 m between them turns the crosswind's moment into a
pair of forces); 71 deg at 0.17 sigma_y, blade SF 10 / 4.7 at 9 / 25 m/s. The dish in a cradle (side arms outside
the rim, C-frame behind, water counterweights up-sun), the tangential-blade diaphragm fine stage (Hopkins
Fig. 4.3) for microradians. Shading by the mount: 0.000 m2 (rasterised along the sun line). The first draft of
this pass (one block at F, struts to the dish) shaded 2.9 % and its blades were overloaded by the crosswind's
moment; the memo keeps both faults beside the correction. `fact_mount/synth.py` prints the six steps with their
checks; `geometry.py` is the member list that `model.py` draws and `synth.py`/`shading.py` check; `memo.md`;
`flower_organs.py` recolours the model organ by organ and writes the botanical drawing; sheets 34-44 on the
register. The pneumatic passes below are kept as the record of how it got there.

## The machine sets itself up: `setup_sim/`

The inflatable fork as a 3-D soft-body simulation (NVIDIA Warp kernels): the FACT mount with the hose as its
frame. Posts, arms and counterweight tubes are closed fabric tubes grown from stubs like everting vine robots,
water is pumped into the counterweights, a double-acting pneumatic strut per side turns the cradle about the
flexure trunnions on the axis through F, the deck ring turns the azimuth; the head lands on the sphere about F
pointing at the sun and follows it. `setup_sim.py` (simulation), `inflated_beam.py` (Coad's buckling and crushing
forces, McFarland's collapse moment), `koopman_fit.py` (pykoopman model of the tracking), `render_gif.py`,
`memo.md` (including why the second pass's single stem cannot give the head both its place and its attitude);
`setup_sim4.py` is the same simulation on the fourth-pass geometry (one stalk, hollow neck, counterweight hoses)
and is the published sheet 45.

## Earlier: the pneumatic mount

The brief of 2026-09-05: a water hose for the frame, actuated like a vine robot so setup and tracking are
automatic; the structural dual of Hashemi's machine, the assembly below the primary like a flower; fractal, the
same stem and skin at every scale. The machine it applies to is the Cassegrain-receiver Hashemi machine on
nix-support (f 4.05, orbit 4 m about F, hyperboloid strip, vertical beam to the ellipsoid M4).

- `hashemi_pneumatic/memo_hp.md`: the mount as a freedom, actuation and constraint topology (Hopkins 2010), coarse-fine:
  a fine exact-constraint flexure stage (three tangential rods + three water columns, `fine_stage.py`) holds the
  dish to microradians behind the pneumatic coarse stage; no deck tendons, so the roof is the dish's sweep.
  Coarse stage:
  freedom space the sphere of rotations about F; constraints four wires through F from an outrigger ring
  (Hashemi's near method puts F on the focal tube through the slot); actuation by pure couples from a flexing
  water-filled stem, plus four pretensioned tendons routed by a clearance solver in the DCM paper's style.
  Checked over 59 Quetta sun positions at 9 and 25 m/s; stays deployed in the survival wind.
- `hashemi_pneumatic/screw_mount.py`: rank and reciprocity checks, unilateral statics, TWSM stiffness,
  actuation space, clearances; `tendon_solver.py`: the line enumeration; `water_stem.py`; `physics_hp.py`
  (sweep, root); `model_hp2.py`: CadQuery scenes; `model_hp.py`, `physics_hp.py`'s rod concept: superseded
  (a compression rod from the deck and hand-routed tendons; its sheets `hp_*` remain).
- register sheets 28-31.
- `flower/`: the first reading of the brief as a self-contained sunflower with a Cassegrain head and the beam
  down its own stem. Superseded: it redesigned the optics, which is the other fork's, and its secondary
  shadow was the wrong turn. Kept for the inflated-hose scale law and the hose sizing.

## The mount as screws, in the megakernel: `screws/`

`tandoor_screws.py` is the finite-motion half of screw theory FACT does not use - twists, wrenches, the exponential,
the adjoint, the product of exponentials, series and parallel composition, the beam 6 x 6 - with the register's
frame types as screws at home: hashemi, pedicel, crown, fork, coude. `mount_solve` (buffer 12, one row of 136 floats
per agent) walks the chain, applies the elastic twist and C W, and derives the beam direction, the pointing and beta
from where the head is; a row of zeros is the old path. The fold chain's relay ellipsoid is per agent (the cass/tri M2, M3, M4
already are, as design-table columns). The strip follows the link it is mounted on.
`flower.ini` names the type (`mount = pedicel`), `flowerfast.ini` sends the joints through the kernel (`mech_kernel`).
Parity: Hashemi's machine as a chain reproduces the kernel's law to 2e-7; the pedicel chain reproduces `pedicel_fk`
to 2e-6 m; the slow env with the chain matches the injection path to 1e-6 in reward with the wind off. Found on the
way: the fast env's trace froze the sun's direction in the dish frame at reset, so the crown's tilts turned the
traced beam once instead of twice - fixed, and the throughput ceiling is 89.8 %, not 87 (`screws/README.md`).

## The wind as a field (2026-09-12): `screws/`, the rod

The stem and boom as a curve, the wind as a density along it: `tandoor_screws.rod_twist` (the derivative of the curve,
exact for uniform densities with any number of elements), `tube_density`, `wind_profile`. The fast env rings two rod
solutions a step on the modes of the chain's 6 x 6 (3.0 / 10.5 Hz); the slow env takes its walk per newton from the
same 6 x 6 (14 um/N, not the planar 6.3). The LES table carries the signed mean pitching moment, now applied, and the
film's n = 1 deflection plane, which is figure and not pointing (Gauss: a rim-fixed film has no mean slope).

## The deep dish, traced (2026-09-12/13, corrected 13th): `deep/`

The user's 'you really do need deeper dishes', put to the flower's kernel with the geometry kept out of the configs:
a formed paraboloid at f 1.05-2 replaces the film for the study, the orbit and f_dish follow. The strip's shadow is its
own area at any depth; the built strip's BAND catches only the shallow cone (a full hyperboloid shell would pass 72 %
at f 1.05, erratum 2 - the 'asymptote' reason first given was wrong); the ellipsoid beyond F (`sec_side = greg`) as a full cap catches every
ray, and the cap the rays meet is a dome ~2 d across (the ellipse's polar form from its focus, not its semi-minor
axis), so its shadow sits inside the hole. The vertical bore crosses the deep bowl whenever the sun is more than ~30 deg
from the zenith: the beam would have to go down the dish's own axis, and that relay - the fourth pass's M3 at the neck
and M4 at the stalk, the hollow pivot between them, the stalk, the built chain below the deck - is traced end to end
in `deep_relay.py`, a torch twin of the kernel's ray model validated against it to 0.6 points (which also found that
the fast env's trace has no sun disc: `upick = us = 0.5`, a fixed 3.2 mrad offset). ERRATUM: the first version traced
the built machine at the film ladder's middle level (f 4.30) instead of its working level (f 4.05); the strip
magnifies 27x, so the built machine read 8-28 % through where it passes 48-80 %, and the '4-8x' was wrong. Corrected:
the coude machine passes 82-88 % of the sun's rays at every hour with the envs' 4.3 mrad figure and the sun's disc,
1.2 / 1.4 / 1.6x the built machine in rays and 1.06 / 1.25 / 1.43x in net light after its two extra reflections - its
gain is the built machine's high-sun crossing and slot, nothing in winter. Not the play (the user's call, and the
numbers agree). What the study leaves the tri machine: the film's figure is its throughput lever - 82 % with a perfect
film at midsummer noon, 50 at 4.3 mrad, seven points per milliradian through the strip's 27x - so the zones and a film
off yield come first; and a relay that magnifies at M3 loses two thirds of its light in a 0.30 m pivot bore.

## The tri machine, the production architecture (2026-09-13): `tri/`

The user's call: the coude is not the play; the machine is the tri receiver at f 4. Four steps on it. The zones were
already on (`n_zones 5, zone_c 0.4`); the 4.3 mrad the envs put on every ray is the film's own slope (2 mrad) and
print (0.8), doubled on reflection, and at the working level it costs the tri machine 30 points at high sun. The
rim-fed film (the rim a spool, `film_T` in the base env, the flower envs and inis, the cook's wind blur through
`sp[7]`) takes the film from yield to 42 MPa at the price of 2.3x the wind figure. The LES pressure maps traced on the
film as a per-ray field (`wind/film_field.py`) pass the strip and the collar like an isotropic blur of the same rms,
cost 3 points of the year at the site's 5 m/s and 17 at 9, and show the film's smoothness worth 12 points of the year.
The receiver's box searched by the MCTS under the three film models (`tri/mcts_run.py`) lands on the same machine
each time - tri, section, high deck, post mount, d_strip 0.7, r_duct high - and the film model moves only the value
(-8 % rim-fed, -2.5 % at 1 mrad). The lever it exposes: the strip's distance. At d_strip 0.7 (magnification 11) the
tri machine passes 80-90 % with today's film against 50-78 % at the flower configs' 0.3 (27), and 68-82 % with a film
twice as bad; `hashemi.ini` is at 0.6 already. Run 4's controller transfers to the rim-fed env unchanged
(`tri/README.md`).

## The elevation drive is the tow-wire loop, not the rail (2026-09-16)

Read from Hashemi's own paper (`fixed-focus-ir.pdf`, figs 6, 16, 17) after the user pointed at his channel. Three parts
that the register had conflated into one:

- ELEVATION IS A CRADLE ON FOUR RODS, ABOUT A REMOTE CENTRE AT F. "I closed all four threaded rods and you can see that
  it can move like a cradle" (17:32 in the build video). The rods are SHORT and each is radial to F, so the dish they
  suspend rocks about a virtual centre at the focus: no axle at F, no mast reaching up to it, and the bearings on arc D
  hold it to that exact circle over the full travel. Compose that with the frame spinning on the ring about the vertical
  through F and the dish has two degrees of freedom over the focal sphere, which is why F never moves. Two revolutes can
  only fix a point if both axes pass through it, and that is the constraint that makes a physical trunnion at F need a
  4 m arm; the remote centre is how the machine avoids paying it. The rods are also the alignment: nutted above and
  below the rim, they set the dish tangential to the focal circle (fig 16, p13).
- the drive is a ROD on a crank off the trunnion. Fig 17 draws a tow-wire loop on two pulleys instead, and either works,
  but the desk model and the production build use a rod, which is 3-4x stiffer and can push. Its price is buckling: at
  the built scale the rod is 10.7 mm carrying 3.6 kN, against an Euler load of 0.3 kN pinned, so it must be biased into
  tension by the dish's own weight or kept short and end-fixed. Sized to its load, the sag is sigma L / (E lever), which
  is independent of the dish: 15 millidegrees, against the wire loop's 34 and a 0.7 deg half-power width.
- the threaded rods of fig 16 are NOT the drive: two 73 cm screws on nuts through the straps, used once at assembly to
  set the dish tangential to the focal circle.

So the network's elevation command drives the DRUM, and the dish hangs off it through the loop's elasticity about
the trunnion, whose arm is the orbit radius. The kernel's
design table is widened to FCTW 84 to carry the two sag coefficients ([82] radians per cos(el) from the dish's weight about the trunnion,
[83] radians per (m/s)^2 from the wind's tangential moment - a force normal to the dish points at F and makes no moment
about the arc's centre, so the rail takes it), the fused state gains `el_dish` at +38, and the trace is pointed with the
dish while the obs and the reward keep reading the drum, which is what a real encoder sees. Sizing the wire to the dish's
weight, as fig 17 says ("a thin tow wire (proportional to the weight of the dish)"), makes the sag the same angle for
every design in the box: 34 millidegrees, against a 0.7 deg half-power width. A fixed 6 mm wire instead sags 0.28 deg on
the box's largest dish, which is how the wire's sizing rule got found. Kernel and numpy twins agree to 5e-7 deg
(`screws/test_env_mount.py` section 4). Every path the cook points with carries it: the numpy trace, the fused step
and `tandoor_gpu_step`, so all four receivers (fold, focus, cass, tri) get it, since they share this mount. The flower's
fast loop does NOT: it resolves its head pose through the screw chain, and sagging only its pointing broke the
chain-against-law equivalence the mount tests check; its pedicel and fork mounts carry their own compliance and read
zero in those columns, which is why the mount type must be set before the base env builds the table. The renderer draws
the focus post, the trunnion at its top and the dish's arms, keeps the loop, and dims the rail to what it is.

Two other things the paper settles: the membrane's SLOT is not optional - he picks the near method in fig 8 precisely
because the focus balances better, and its stated price is that the dish must be cut where the focal base passes through
it (fig 12) - and his production reflector is a cut home satellite dish faceted with 2 mm mirror in 5 x 3 cm pieces, not
a membrane at all.

## The master design in Lean, from the video, one stage at a time (2026-09-17): `~/manifold-pareto/lean/RequestProject/Hashemi.lean`

The machine the Lean library is about, written down as Hashemi builds it: a section per stage of the video, the
structures carrying his dimensions, the theorems saying what those dimensions commit the machine to. This revision
is the base, 0:00-4:42. The fixed base (`FixedBase`): the 2 cm ring on the deck, the central tube "with a higher
height", the foam ring that "keeps the bearings at the right level"; `bearing_life` is his "second-hand type,
because the speed of the rotation is very low" as a number, a hundredfold margin over twenty years on any bearing
rated to a million turns. The movable base (`Carriage`, `hashemi`): his figure shot from above - a 184 x 13.5 cm bar
with a roller at each end and a flat A of base 98 and height 80 with a cross member at 39 and a bearing at the apex.
The A lies IN THE PLANE OF THE RING: the apex bearing drops over the tube, the rollers ride the rail, the rubber
third roller drives. So the rollers ride a circle of radius sqrt(0.92^2 + 0.80^2) = 1.219 m about the tube
(`rollerRadius_hashemi_bounds`): the rail is 2.44 m across, the paper's "2 m ring" to one figure; `Fits` is the one
condition joining base to carriage. The drive rate is `azRate = ωm rw / R`, and `tracks_exactly` is `Mount.lean`'s
`follow_exact` with that rate - the roller carrying the sun's azimuth exactly whenever it can outrun it, 0.14 rpm
on a 5 cm roller at Quetta's fastest 2 deg/min (`roller_rpm_hashemi`). The FACT statement (`Screw`, `recip`,
`wrenchAt`): five constraint wrenches - the tube bearing's two horizontal forces, the foam ring's vertical, the two
rollers' verticals - are all reciprocal to the yaw (`constraints_reciprocal_yaw`) and linearly independent
(`constraints_linearIndependent`), so the yaw is the whole freedom space and the stage is exactly determinate; the
traction's reciprocal product with the yaw is F R (`drive_recip_yaw`), so the motor works on the freedom and the
bearings never hold the traction as a moment (`drive_works_on_yaw`). Two constraints on the stages still to come
fall out of the base alone: `focus_on_axis` (a point the azimuth leaves fixed lies on the tube's axis, so the focus
sits over the tube and the elevation stage must put it there - the fixed-focus condition itself) and `screwLength`
(`R/2 - TandoorSphere.sag R a`, the screw that stands the rim off the axis through the focus: sqrt 3 - 1 = 0.732 m
on his 2 m sphere with a 2 m dish, the paper's 73 cm, `screwLength_hashemi_bounds`). Builds against
`RequestProject.Mount` and `RequestProject.OpticsSphere`; the dish frame, posts, trunnion, screws, tow-wire loop,
slot and receiver arrive with their stretches of the video. `fact_mount/hashemi_dims.py` is the to-scale drawing of
the same machine (R 2 m, f 1 m, dish 2 m) with the three-focal-ratio strip that answers why the env's f 4 mount is
tall: a_mem, f_nom and g_orbit scale together in the env, so g_orbit cannot drop alone.

Same day, two more stretches, and a correction of method. 4:42-6:30, fitting the carriage: bearings on the tube first,
frame welded around them ("it causes precision in its construction"), the bearing's looseness shimmed with iron sheet,
the semicircular clamps locked, 360 deg with no stop. `play_budget` is what a play delta costs - it comes straight off
the receiver's half-size in Mount.lean's pointing budget, `spot f eps + delta <= h`; `shim_negligible` his half
millimetre against a 6 cm loaf; `tracks_exactly_circ` the 360 deg as `followCirc_exact` at the roller's rate. IF the
wheels are grooved (the paper's "slotted wheels"; the frames do not resolve it) the stage is over-constrained by two:
`constraintsGrooved` is the seven-strong set, all reciprocal to the yaw, with the two dependencies written out
(`grooved_relation_x`, `grooved_relation_y`, `grooved_not_linearIndependent`) - the grooves and the bearing fix the axis
twice, which is what the construction order and the shims are for. 8:00-10:00, the two legs: identical ("neither left
nor right"), a 130 cm upright, a 62 cm foot, a 96 cm knee brace, four holes; one at each END of the chord bar, upright
vertical by the roller, the foot ALONG the bar with its long side cantilevered outboard, the brace triangle in the
bar's own vertical plane - "the chord of the triangle on the base prevents bending of the vertical base" - and at 10:00
the foot is seen to sit ON THE GROOVED WHEEL'S AXLE ROD (the user: "the foot is on the grooved tire rod. look how it
spins" - four frames, four azimuths, the leg on): `postTop_on_rail`, the post stands over the wheel at the roller
radius, 1.22 m from the tube, its load straight down through the wheel onto the rail, the bar carrying none of it in
bending. That also settles the wheels as grooved, so the seven-constraint over-constraint is no longer conditional.
10:00-10:40: the second leg "in the same way", both braces outboard, "now both the main bases of the dish are ready",
and the rule for the upright - "the length of the vertical base ... is calculated according to the figure": the post
drawn from the dish's lowest point up to about F at both ends of the travel, the vertex f = 1 m below F at noon, the
edge B a = 1 m below F at low sun, his 130 cm being that metre and 30 over. `edgeDepth` is that figure as a function of
elevation, `(f - sag) sin el + a cos el`; `edgeDepth_horizon`/`edgeDepth_noon` are his two ends, and `edgeDepth_le`
bounds the reach by sqrt((f - sag)^2 + a^2), attained at tan el = (f - sag)/a: on his sphere 1.24 m at 36 deg
- and his own geometry figure at 10:40 then computes exactly that length for HIS dish and labels it "Base": "a
circle with a radius of two meters and a segment of a circle with a length of 1.6 meters as a solar dish", A the
centre, D the vertex, F midway (AF = FD = 1 m), B-C the 1.6 m dish, H its midpoint, AH = sqrt 3.36, HD = 0.167 m (the
sag), FH = 0.833 m (F over the rim plane - the screw length for this dish, where the paper's 2 m dish gives 0.732),
FC = 1.155 m. `dishR/dishF/dishHalf`, `HD_eq/_bounds` (= `TandoorSphere.sag 2 0.8`), `FH_eq/_bounds`
(= `screwLength 2 0.8`), `FC_eq/_bounds` (= the bound of `edgeDepth_le`, the deepest the rim reaches below F, at
tan el = FH/HC = 46 deg), `hashemi_clearance`: the 130 cm upright against FC 1.155 leaves 14.5 cm - IF the pivot is at
the post top as his first figure draws it. The 2 m dish and its 6 cm of the previous revision were mine; the figure
fixes the dish at 1.6 m and the number with it.

10:43-12:40, THE SWING, which closes the requirement: "the length of this base to be 130 cm, because the distance of
the hole above the base should also be taken into account ... our dish is bigger than the previous one and it cannot
be hung with two legs. And it needs four hanging legs. These four hanging legs act like swing chains. I made four
hanger legs like this and used threaded rod and carefully welded the ends to the iron nut. Of course, you can use
bearings instead of nuts. Two for one side and two for the other side. We choose two screws with the right diameter,
which we must install on top of the vertical posts. These two screws must be able to bear the weight of the entire
solar dish ... Nuts welded to threaded rods are bolted at the proper distance." The frames: a bolt through the hole
about 5 cm below each post's top, pointing INWARD along the chord; on each bolt the two hanger eyes side by side at
a set gap, so each side's pair leaves one pivot as a V to two rim points. So the elevation axis is the bolt line,
the "Base" F-C of the figure is the hanger from pivot to rim edge (1.155 m), the hangers are threaded so the rim
nuts set that length - the earlier caption's "length of the screw passed from the edge of the dish" - and dish plus
hangers is a rigid pendulum about the bolts with F AT the bolts. `swingVertex`/`swingNormal`, `swing_alwaysTangent`
(DISCHARGES `AlwaysTangent`: F is the pivot), `swing_focusCircle`, `Hanger`/`hashemiHanger` (FC long, ~10 mm rod),
`clearance l holeDown FC = upright - holeDown - FC`, `clearance_hashemi` (14.5 cm less the hole's drop: ~9.5 cm at
5 cm). Stated and left open: the bolt line is the chord line 0.80 m from the tube's axis, so F is there and a
roof-fixed receiver would see it circle 0.8 m through the day (`focus_on_axis`) - either the receiver rides the
carriage or something not yet shown moves F. 12:40-13:00, where the eyes sit on the bolt: "at the beginning of the
main screw ... more pressure to the vertical legs ... direct them to the end of the screw as much as possible" - a
spacer nut between post face and eyes, so the hangers, swinging in a plane parallel to the post's face, clear it:
`HangerClearsPost` (eye offset beyond the rod's half-thickness), `hashemi_eyes_clear`. 13:20-14:00, OPENED NOT
RESOLVED: "one of the threaded rod for one side of the dish and the other for the other side ... another vertical
stand for vertical movement should be installed here ... before installing the dish, because the dish will interfere
... the part that should perform the vertical movement of the dish is" (cut) - a third, taller stand near the
carriage's centre with a long threaded rod diagonally beside it, and a ladder frame in hand: the elevation drive,
on the moving part, before the dish. 14:00-15:20 resolves its hardware: "the part that should perform the vertical
movement of the dish is fixed, due to the size of the dish, outside the circular axis of the base. Therefore, we use a
structure to connect it with the horizontal axis. This is where our motor with gearbox fits ... very strong, can easily
support even my weight ... I made this vertical stand ... placed a metal pulley on top of it ... the two bent legs on its
side are vertical due to the strength of the leg, and you can see its dimensions in the figure ... now I bolt and
install it on the system." The OUTRIGGER: two rails with cross members, splayed to a narrow end, bolted to the
carriage's bar and reaching out past the ring, a grooved pulley on an axle at its end where the motor with gearbox
fits. The STAND, from its figure: 159 cm post, 184 cm foot bar, two bent legs curving up 41 cm, a metal pulley at the
top; bolted on the outrigger, vertical, outside the ring beside the second leg. So the elevation drive is a motor with
gearbox on an outrigger and a pulley 1.59 m up a mast outside the ring - the paper's fig 17 tow-wire drive in its
parts. `DriveStand`/`hashemiStand` (159/184/41), `Outrigger` (joins stand to carriage, motor at its end; no
dimensions given, none recorded), `pulley_above_pivot` = 1.59 - (1.30 - 0.05) = 0.34 m over the bolt line. The
wire's path from the pulley to the dish, and how "one threaded rod for one side and the other for the other side" is
rigged, is NOT in the frames and nothing is recorded about it. 91 declarations, no sorry. The user's video frames
are in ~/Downloads/hashemi_frames (112 at 15:20).
15:20-19:20, THE STAND ON THE OUTRIGGER, THE DISH IN, THE RODS CLOSED - and a CORRECTION to the swing entry above.
"There is some slack that won't be a problem in practice. The engine and gearbox will be placed here, which I will
install later. Now I place the dish on the system. Well, now we close the threaded rods to the solar dish. I closed
all four threaded rods and you can see that it can move like a cradle. The length of the screw passed from the edge
of the dish should be such that the focus distance from the centre of the dish is the same in all cases. In fact,
the dish should be tangent to the focus circle. Here, because our dish is a circle with a radius of two meters, so
the focus distance of the dish is one meter. Because the edges of the dish have a special curve, you can cut two
pieces of pipe diagonally to the right size and place them under the beads [nuts]. You can see that the dish can
easily move in the vertical axis. And horizontal movement is also done in this way. Well, let's go to the
installation of the engine and gearbox for vertical movement." The frames: the stand's 184 cm foot bar bolted across
the outrigger's rails, the post braced to them by its bent legs, a V-groove pulley on a bolt axle at the outrigger's
narrow end where the motor goes (later); he rocks the mast by its top - the slack. The dish: a square tile-mosaic
panel on a fibreglass backing with a flat flange round it, one man carries it, in face up between the posts; along
its centre line from one rim to the middle a straight feature (a loose flat strip on the face, a bright line from the
back) - slot or seam, not said. The rods: each passes through a hole in the flange near a CORNER - each post's V
reaches the near and the far corner of its edge - a nut above, a nut below, two wrenches; then the swing by hand,
the 10:40 figure again, the "Tube with x degree cut" figure (a wedge pipe seats the nut where the rod meets the
flange at an angle), elevation by hand, azimuth by hand. CORRECTION: the swing entry above took the figure's "Base"
F-C = 1.155 m for the hanger; the rods reach the corners, so the hanger that puts F on the bolts is eye to corner,
`hangerLength 2 0.8 0.8 0` = sqrt(4.36 - 2 sqrt 2.72) = 1.030 m (`hangerLength_corner/_bounds`; an eye 9 cm outboard
of the edge line adds 4 mm in quadrature). `hashemiHanger` is corrected in place; F-C stays the deepest reach of the
fore and aft edges below the bolt line (`edgeDepth_le`), which sizes the post, so `clearance_hashemi` stands. New:
`dish_between_posts`/`sideGap` (the 1.6 m panel on the 1.84 m bar: 12 cm a side); HIS RULE FOR THE NUTS AS A
THEOREM, `swingVertexAt`/`swingFocus`/`swingFocus_circle`/`swingFocus_fixed_iff` - with the vertex d from the bolts
(what the nuts set) and the focus f from the vertex, the focus rides a circle of radius |d - f| about the bolts
through the swing, and stays put at every swing angle iff d = f ("the same in all cases"); `setLength`/
`setLength_surj` (the clamp fixes the rim point on its rod - what the rigid pendulum assumed - and the nuts set any
length continuously); `tiltOfMismatch`, `tilt_not_driven` (a side-to-side length difference e tilts the dish e/1.6
about the axis across the bar, a roll outside the span of the yaw and swing twists - the one pointing freedom no
drive reaches; `swing_yaw_independent` are the two he shows by hand); `one_turn_tilt` (IF the rod is M10, coarse
pitch 1.5 mm: one turn = 0.94 mrad, under a quarter of the sun's half-angle, 0.94 mm at F - a one-time alignment
set to a fraction of a turn); `cosTubeCut/_bounds` (the x of his tube: the corner hanger against the sphere's normal
at the corner, cos 0.830, x = 34 deg, IF the flange continues the panel's surface); `SlackHarmless` (his mast claim
as the play budget with a parameter for the spot shift the wire will carry - waits for the wire). 116 declarations,
no sorry. NOT here: the motor with gearbox (19:20 on), the wire's path and the one-rod-per-side rigging, the slot,
the receiver; read off frames, not stated: the 10 mm rod and its pitch, the holes at the corners, the flange in the
panel's surface. Frames folder: 140 at 19:20.
19:20-20:50, THE WINCH, AND THE STRUTS AGAINST THE LEGS' LEAN. "This engine with a gearbox, along with an additional
gearbox and a wire collecting roller, all work like a winch. Also, I installed the towing wire on its grooved roller and
it easily supports the weight of the dish. And here is the place to install it. The installation of the vertical dish
lift has been completed. And later I will connect the towing wire to the dish. One problem is that when the dish is
directed upwards in one direction, the vertical legs tilt towards the dish. In order to prevent this from happening, we
must use foundations in the opposite direction of the deviation of the vertical foundations. I prepared two bases with
suitable length and install each on one side." The frames: a motor on a gearbox, a second gearbox, a flanged grooved
drum with the wire wound on, one unit bolted at the outrigger's narrow end under the mast (drum along the rail, motor
up); the bronze V-pulley stays on the outrigger's centreline between ring and winch; the wire hangs loose - not yet
connected. With the dish swung far he rocks a post by its top: the legs lean toward the dish; two struts, one per leg,
from the post at about the brace's height diagonally down to the outrigger's end by the mast, bolted at both ends, no
length given. `Winch` (drum radius a parameter - no figure), `elRate` = wd rDrum / rw (`azRate`'s law),
`el_tracks_exactly` (`follow_exact` again), `wire_recip_swing` (the wire's wrench at any rim point against the swing
twist = its moment about the bolt line, q_y f_z - (q_z - zBolt) f_y), `wireTension` = W rcm sin t / rw, `wire_taut_iff`
(A WIRE ONLY PULLS: tension >= 0 iff sin t >= 0 - the return stroke is gravity's, the range one-sided),
`HoldsDish`/`tension_le_of_holds` ("easily supports the weight of the dish" = the holding tension covers the dish on its
side, and then every angle), `strutStrain`/`strut_resists_lean` (the lean toward the dish shortens the strut iff the
outrigger end is inboard of the post - where he runs it). The cause of the lean is a reading, not a theorem: leg, brace
and foot are one triangle and the foot only rests on the wheel's axle, so the whole leg turns about its bolts to the bar;
the strut ties it to a second body. 126 declarations, no sorry. NOT here: the wire's path (drum -> presumably the mast
pulley -> dish, "later"), hence rw, the winch's rate and the mast slack's effect; the bronze pulley's role; the slot; the
receiver. Frames folder: 160 at 20:50 (the 17:00-19:20 batch's transcript entry holds only 8 of its 27 frames).
20:50-23:20, THE LEVEL, THE SECOND STRUT, THE PANEL AND THE BOX. "To know that we have done the work correctly, we use a
level ... the base should be vertical. Now I will install the other diagonal support ... the support bases of the solar
dish will not be inclined anymore. Now we go to the installation of the solar panel. By installing a small 5 watt panel,
we can supply the system's motion energy because the electric motors of this system have very little consumption. In
fact, this panel charges the battery, and the battery transfers electrical energy to the motors ... you can also use a
10-watt panel ... the communication wire of its charge control is directly connected to the battery ... So here I
install a box called system control box." The frames: a spirit level against a post; the second strut from the far post
at mid-height to the SAME outrigger end, so the two struts meet at the winch and close a pyramid with the posts and the
outrigger; a framed 5 W module on a bracket on the carriage bar at one post's foot, tilted face up; a steel "DC.P" box on
the bar at the other post's foot. Everything electrical rides the carriage. `pointVel`, `yaw_lifts_nothing` (THE AZIMUTH
DOES NO WORK AGAINST GRAVITY: the yaw twist lifts no point), `swing_lift` (the swing lifts a point at y at rate y),
`elPower` = W rcm sin t w, `elPower_eq_wire` (= tension x wire speed), `elPower_le`, `tracking_power_tiny` (any dish under
100 kg, centre within f of the bolts, at the Earth's 15 deg/h: UNDER 0.073 W = 1.5 % of the 5 W panel - "very little
consumption" is a theorem on the mechanical side; motor/gearbox losses not given), `Panel`/`hashemiPanel` 5 W,
`focusShift` = h sin eps (F sits on the bolts, so a post's lean moves F), `lean_one_degree` (1 deg at 1.25 m = OVER 2 CM),
`plumbed_shift` (a post plumbed to 0.5 mm/m - a typical level, not a caption - under 0.7 mm): "the base should be
vertical" is a requirement on F.
23:03-24:10, THE BOX, THE CABLES, AND THE TOW WIRE TO THE BACK OF THE DISH - the path open since 15:20 is shown. "This box
is where the control circuit and battery and connections are located. I use a 1.5 single pair cable for the electrical
connection between the solar panel and the electric motor with a horizontal gearbox and the winch related to the
vertical movement with the system control box ... resistant to sunlight and rain ... First, I have to raise the dish on
the reverse side to free up the work space ... now we are going to pull the towing wire between the winch and the solar
dish. The tow wire needs to be tied under the solar dish so I bring the dish up. I connect it to the back of the solar
dish with a fastener suitable for the towing diameter." The frames: three runs of 2 x 1.5 mm2 cable along the bar (panel,
azimuth motor, winch) to the box, which holds circuit + battery; the wire from the drum up over the mast's pulley and
down to the BACK of the dish, swung up with its back toward the mast, clipped with a wire-rope clip (which point of the
back: not fixed by the frames; wire diameter not stated). Winching in pulls the back toward the mast and turns the face
AWAY from it - the mast is the shadow side, the one-sided range of `wire_taut_iff`. `wireLever` (P x B / |B - P|),
`pulleyAt` (ym beyond the bolt line, hp = 0.34 above), `clipAt` (zb below, swung toward the mast), `wireLever_rest` =
ym zb / sqrt(ym^2 + (hp + zb)^2), `wireLever_pos` (NO DEAD POINT: positive over the whole quarter swing) - this rw is the
rw of `elRate`/`wireTension`/`HoldsDish`; ym, zb about a metre each, read off frames, not given. `slackSpot` = 2 f delta / rw
(the mast's play now has its path to the receiver: a pulley displaced delta changes the wire by at most 2 delta),
`slackHarmless_of_lever`. `cableArea` 1.5e-6, `rhoCu`, `cableDrop`, `cable_drop_small` (run <= 4 m, I <= 1 A: under 0.1 V;
current not given). 149 declarations, no sorry. NOT here: where on the back the wire is clipped and the mast's distance
from the bar (ym, zb); the wire's diameter; the bronze pulley's role; the battery's size and what the control circuit
does; the slot; the receiver. Frames folder: 180 at 23:20 (the 23:03-24:10 batch arrived mid-turn; its transcript
entry was not yet written when the extractor ran).
THE USER'S TWO CORRECTIONS (2026-09-17, after 24:10). (1) The four hangers reach the edge nearest their post at the
MIDDLE OF EACH HALF EDGE, y = +-a/2 = +-0.4 m, not the corners the wide shots suggested, each rod "at like a 60 degree
angle" - the pair's V. Third value for the hanger: eye to hole sqrt(4.36 - 2 sqrt 3.2) = 0.884 m (`hangerLength_halfEdge`,
`hangerLength_bounds`; F-C 1.155 was the post's reach, the corners gave 1.03); `rodTan` = 0.4/(sqrt 3.2 - 1) = 0.507, each
rod 27 deg off the vertical, the V 54 deg (a rod 60 deg off vertical would need 1.4 m of sideways reach, so the user's
60 is read as the V); `cosTubeCut` 0.888, x = 27 deg (was 34). `hashemiHanger` corrected in place, sections 6 and 8 say so.
(2) The tow wire is clipped at the TOP EDGE NEAREST THE PULLEY, halfway between the corners - the figure's C - and again at
the centre of the back; the pull on the dish acts at C, the last contact before the pulley. The clip rides a circle of
radius F-C = 1.155 m about the bolts (`edgeClip_radius_hashemi`: his "Base" a third time). Two consequences a centre clip
did not have: `edgeClip_reach`/`MastClears`/`mastClears_hashemi_iff` - THE MAST MUST STAND BEYOND 1.155 m from the bolt
line, at least 1.2 m; and `edgeClip_cross`/`edgeLever_pos_iff`/`edgeLever_dead` - THE WIRE HAS A DEAD POINT where the
clip reaches the pulley's ray, t* = arctan(ze/a) + arctan(hp/ym) = 46 deg + arctan(0.34/ym); with the mast at 1.2 m
`deadTan_hashemi` puts tan t* in 1.878-1.88, 62 DEG OF SWING, 9 cm of wire left, the lowest sun 28 deg up;
`sixty_reachable`: 60 deg (the sun 30 deg up, Quetta's winter noon 36 deg inside) is within range. A mast farther out
shortens the range toward 46 deg, a taller mast lengthens it - the 159 cm mast sets the range. `wireLever_rest` at C:
(ym ze + hp a)/sqrt((ym - a)^2 + (hp + ze)^2), 1.03 m at ym 1.2. The earlier `wireLever_pos` ("no dead point", centre
clip) is WITHDRAWN with the centre-clip model. 162 declarations, no sorry. Open: ym (the mast's distance from the bar).
THE HANGERS AS JOINTS - "figure out the motion via the physical connection" (the user, with the 17:50-19:06 frames
re-sent). The eye is a nut on the bolt's shank, turning about it ("you can use bearings instead of nuts") - a REVOLUTE
about the bolt line; both eyes of a side on one bolt, the bolts pointing at each other, so all four rods hinge on ONE
line. The rim end is a rigid clamp (nut above, nut below, the x-degree tube seating it on the curved flange), so each
rod is one body with the dish. Dish + four rods = one rigid body on one hinge line: ONE freedom, the turn about the bolt
line. A pin at the rim instead of a clamp would have left a second freedom (the dish sliding along the bar on its rods
as a four-bar); the clamps remove it. The frames: the camera is across the ring from the bar, so the swing reads as the
curved panel's near edge dropping (17:50, mirror face lit) and rising (17:52, back toward the camera) - not a
left-right tilt. `hingeWrench` (the eye's five constraint wrenches: three forces at the eye, two moments across the
bolt), `hinge_reciprocal_swing`, `hinge_freedom`/`hinge_freedom_smul` (THE MOTION THROUGH THE CONNECTION: a twist the
eye passes is (w, 0, 0, 0, zBolt w, 0) = w * swingTwist - the turn about the bolt line and nothing else),
`second_hinge_redundant` (the second eye on the same line adds no constraint: two coaxial hinges = one hinge with five
redundant constraints, a door on two hinges - "bolted at the proper distance" and the shims carry it),
`helixAdvance`/`helixAdvance_small` (an eye threaded on the bolt is a helical joint: under 0.31 mm of travel over 62 deg
on an M12 - bolt size not given). 169 declarations, no sorry. Frames folder: 194 (the re-sent batch recovered).
THE USER: THE BOLTS ARE M12 AND THE EYES TURN ON THE THREAD. So the joint is helical, not the plain hinge: `hM12` =
1.75 mm / 2 pi = 0.28 mm per radian (coarse pitch), `screwTwist` (1, 0, 0, h, zBolt, 0), `screwTwist_zero` (the hinge is
h = 0), `screwWrench` (the two forces across the bolt, the two moments across it, and the axial force PAIRED WITH THE
MOMENT -h about it - what the thread turns a push into; the axial force alone is no longer a constraint),
`screw_reciprocal`, `screw_freedom` (THE MOTION THROUGH THE THREADED CONNECTION: a passed twist is (w, 0, 0, h w,
zBolt w, 0) - the swing plus h of travel along the bolt per radian). Both eyes ride the same screw, so the dish and F
walk along the bar h phi over a swing phi: under 0.31 mm over the wire's 62 deg (`helixAdvance_small`), and no binding -
a right-hand thread advances the same way about the same turn whichever way its bolt points. `boltStress`,
`m12_carries_dish`: "these two screws must be able to bear the weight of the entire solar dish" - eyes 3 cm out (spacer
nut + eyes, read off the frames) carry half the dish each in bending on the thread's minor diameter 10.1 mm: a dish
under 100 kg is UNDER 160 MPa, inside a grade-4.6 bolt's 240 MPa (factor 1.5 at 100 kg, five at the 30 kg a man
carries; the grade is not given). 177 declarations, no sorry.
YM CALCULATED (the user: "calculate ym"; then "your Hashemi.lean should have the geometry of the frame and the little
appendage this one is sitting on"). Two frames shot along the bar (20:50 "we use a level", 20:55 "place this alignment")
put the outrigger across the image with the mast's own 1.59 m as the scale at the bar-midpoint depth: the mast's foot
312 px from the bar's midpoint at 255 px/m -> 1.22 m; 285 px at 230 px/m -> 1.24 m. `ymHashemi` = 1.22 m (a decimetre
either way) - right at the floor `MastClears` sets (1.155 + the mast's half-width + a hand): he put the mast as close as
the swinging dish allows. `mastClears_hashemi`; `deadTan_at_ym` (tan t* 1.859-1.86: 61.7 deg of swing), `wireLeft_at_ym`
(11 cm of wire between clip and pulley at the dead point), `wireLever_rest_at_ym` (1.03 m - the wire nearly tangent to
the clip's circle); the winch takes in ~1.13 m over the swing; lowest sun 28 deg. THE APPENDAGE: frame 14:29 shows the
outrigger plainly - two rails leaving the bar at the A's feet (`aBase` 0.98 apart), tapering over ~1.35 m to a narrow end
~0.25 m across (the bronze pulley there, the winch later), a bolted cross member part-way where the stand's 1.84 m foot
bar (the carriage bar's own stock) lies across the rails and the mast stands on the centreline. `OutriggerGeom`,
`hashemiOutrigger` (root 0.98, standStation 1.22, endStation ~1.35, endWidth ~0.25 - the last two the roughest),
`ym_is_standStation` (ym IS the cross member's station), `mast_beyond_ring` (the mast's foot apexH + ym = 2.02 m from
the tube, beyond the ring's 1.22: "outside the circular axis of the base"). 186 declarations, no sorry.
24:10-26:40, THE TRACKER, THE AZIMUTH MOTOR, THE TOW HOLDING THE DISH. "It's time to install the tracker ... the control
circuit inside the control box are in the previous videos ... For the fixed focus system, you must use a precise solar
tracker ... it must be installed on top of the solar dish in a way that is perpendicular to the plane of the dish ... a
small 12 volt electric motor with a gearbox ... can perform the horizontal movement ... Now I will remove the obstacle
that I have placed to hold the dish up, you can see that the tow is holding it up. Since the system circuits are not
connected at the moment, I lower the dish with a battery and connecting it to a vertical electric motor." The frames: a
sun SENSOR (a short tube, aperture at one end, on a bracket) fixed to the rim at the TOP of the dish - the mast-side
edge - with its axis along the dish's axis, cable to the box: THE LOOP CLOSES ON THE DISH'S OWN POINTING. The azimuth
motor (12 V + gearbox) on a bracket at the bar's end by the panel, its roller on the ring (`rDrive`). The dish swung up,
back to the mast, propped by a pipe; the pipe comes away and the WIRE HOLDS IT; then he lowers it with a battery straight
on the winch (gravity return, `wire_taut_iff`). `TrackerBudget`/`trackerBudget_iff` ("precise" as a number: the sensor's
error incl. mounting misalignment is a dish pointing error, spot f eps <= h <=> tan eps <= h/f; what the loop cannot see:
anything that moves F rather than the axis - nut mismatch, post lean - stay one-time alignments), `systemVolts` 12,
`panel_current` (<0.5 A), `wireLever_edge_formula`, `wireLever_sixty_at_ym` (the arm at 60 deg with ym 1.22: 0.38 m,
down from 1.03 at rest, two degrees short of the dead point; tension there ~2.3 W rcm ~ twice the dish's weight;
proof via three interval lemmas `mul_bounds_neg_pos`/`mul_bounds_pos_pos`/`sq_bounds_neg` - the one-shot nlinarith
version timed out).
26:40-28:30, THE START, THE RECEIVER ON ITS POST THROUGH THE SLOT, THE SHADOW TEST - the file's oldest open question
answered. "Now our dish is in horizontal position ... connect the interface cables in the control box and then start the
system ... the weather is cloudy and we will test it on a sunny day. Now I started the system and you can see that it is
working and the dish is perpendicular to the sunlight ... I have used an old copper spiral tube with an additional base as
a focus. Because our solar dish is made of 5 cm mirrors, so its focus width is more and I have to use a bigger spiral
tube. The center of the focus shadow on the dish should be in the center of the dish. Now the sun is almost at the
highest point and because of that, the focus heat is more. You can see that the small dc motor is activated and returns
the moving part to the first position. The heat of the focus is high and if I apply Electrical Contact Cleaner Spray
to it, it produces a lot of smoke." The frames: the RECEIVER is a copper spiral coil ~12 cm across on a vertical pipe
("an additional base") rising to F; the dish's face has a SLOT in the mosaic from its centre to the sun-side rim - the
strip of 16:5x was its cover - and the post passes through it: THE RECEIVER RIDES THE CARRIAGE, F with it (the roof-fixed
receiver of `focus_on_axis` is not what he built; section 6's open question closed). The coil's shadow at the dish's
centre is his alignment check; at noon the coil glows and contact cleaner smokes. `rim_under_F_iff`, `slot_exit_hashemi`:
the post is straight below F, so it leaves the dish through the sun-side rim exactly when that rim point is straight
below F - tan t = a/FH = 0.96, 43.8 DEG OF SWING (sun 46 deg up), the same swing at which the rim is deepest
(`edgeDepth_le`); higher sun the post is inside the panel and needs the slot, lower the dish hangs beside it - so the
slot runs centre to rim, as built. `facetSpot`/`facetSpot_hashemi` (a flat 5 cm facet's beam does not converge: 5 cm +
9.3 mrad x 1 m = 6 CM at F, hence "a bigger spiral tube"), `tracker_margin_hashemi` (a 12 cm coil over a 6 cm spot
leaves 3 cm: the tracker's budget tan eps <= 0.03, 1.7 deg - what "precise" comes to). 200 declarations, no sorry.
NOT here: the receiver's base (on the carriage by the physics), the coil's size/plumbing, the winch's drum and ratios,
the wire's diameter, the bolts' grade, the bronze pulley's role, the sensor's precision and the circuit's logic (the
"first position" it returns to), the battery. Frames folder: 214 (the 26:40-28:30 batches arrived mid-turn; not yet in
the transcript).
`Leg`/`hashemiLeg`, `braceHeight` = sqrt(96^2 - 44.5^2) = 85 cm, `brace_cuts_moment` (peak moment 0.35 of unbraced) and
`brace_stiffens` (tip stiffness x24) are that sentence as numbers; `postTop` records only what is measured - the tops
level, 1.30 m over the bar, a chord apart, on the chord line 0.80 m from the tube. His requirement on the vertical
movement is encoded as he states it and no further: `AlwaysTangent` ("always perpendicular to the supposed circle of
focus") and `alwaysTangent_focusCircle`, his diagram proved from that sentence - a dish always tangent has its vertex on
the circle of radius f about F. HOW the dish swings from the post tops is not in the frames and the file says so; the
earlier inference that F must sit over the tube is now stated conditionally (if the receiver stands on the roof). The
method, after the user's "forget what you know, look at the pictures": each section records the frames and captions,
the theorems follow from the figures' numbers, and nothing is asserted about a stage the video has not shown.

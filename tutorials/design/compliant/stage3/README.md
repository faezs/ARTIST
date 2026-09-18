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
28:43-30:07, THE END. "Now the system is launched and active ... I have not been able to explain the installation of
the electrical circuit ... [The focus] placed here is temporary and I did not have time to prepare a suitable focus. As
you can see, the sun is on the horizon and the dish is pulled up." The machine complete at evening: the dish pulled up
steep, its face to a low sun; the coil at F, the sensor on the top rim, the panel, the box, the mast and wire. The last
shot IS the file's range limit: the dish at 60-65 deg of swing, where `deadTan_at_ym` puts the wire's dead point (61.7),
the sun not on the horizon but ~28 deg up (`lowestSun_tan_at_ym`: tan 0.538). A lower sun is out of the wire's reach on
this mast. The video is complete: fifteen sections, 201 declarations, no sorry; source
https://www.youtube.com/watch?v=5rIKy5frygw. What the video did not give, listed at the end of the file's header: the
receiver's base and the coil (temporary), the winch's drum and ratios, the wire's diameter, the bolts' grade, the bronze
pulley, the sensor's precision and the circuit's logic, the battery. Frames folder: 221.
THE USER, on the closing shots: the receiver's post stands at the DEAD CENTRE OF THE FRAME - the bar's midpoint between
the two legs - so it is the vertical through F from the carriage, height to F = the legs' upright - holeDown = 1.25 m
(`receiverPost_height`); the receiver's base is no longer open. 202 declarations, no sorry.
THE USER: "the swing limit for the dish is probably 90 degrees. i'm sure he mentioned it somewhere. were you not paying
attention?" - right about the dish, and I had conflated two limits. His length figure (10:30) draws the dish VERTICAL at
the low-sun end - in the file since section 5 as `edgeDepth_horizon`; the post's 1.25 m clears the rim at every angle
(`dish_swings_to_vertical`, `clearance_hashemi`); by hand he swings it there at 17:27. The pendulum's range is 90+ deg.
The 62 deg is THE WIRE'S REACH: with the clip on the mast-side rim and the pulley 0.34 m over the bolts, the wire from
pulley to clip is shortest at 61.7 deg, past which the winch cannot shorten it, and its moment at the vertical is
negative (`wire_short_of_vertical` = `edgeClip_cross` at 90 deg) - clips do not change this, the wire bears on the
mast-side rim whatever it is clamped to. To reach the vertical from that rim the pulley must rise >= a/ze = 0.96 of ym
above the bolts (`ReachesVertical`, `reachesVertical_iff`): 1.17 m at 1.22 m out, a 2.4 m mast (`mast_for_vertical_hashemi`)
- or a wire path that does not cross the mast-side rim. The closing shot (dish 60-65 deg, coil unlit, sun low) is what
the rigging as shown gives. Section 15 rewritten to keep the two limits apart. 207 declarations, no sorry.
`Leg`/`hashemiLeg`, `braceHeight` = sqrt(96^2 - 44.5^2) = 85 cm, `brace_cuts_moment` (peak moment 0.35 of unbraced) and
`brace_stiffens` (tip stiffness x24) are that sentence as numbers; `postTop` records only what is measured - the tops
level, 1.30 m over the bar, a chord apart, on the chord line 0.80 m from the tube. His requirement on the vertical
movement is encoded as he states it and no further: `AlwaysTangent` ("always perpendicular to the supposed circle of
focus") and `alwaysTangent_focusCircle`, his diagram proved from that sentence - a dish always tangent has its vertex on
the circle of radius f about F. HOW the dish swings from the post tops is not in the frames and the file says so; the
earlier inference that F must sit over the tube is now stated conditionally (if the receiver stands on the roof). The
method, after the user's "forget what you know, look at the pictures": each section records the frames and captions,
the theorems follow from the figures' numbers, and nothing is asserted about a stage the video has not shown.

COMPILING HASHEMI.LEAN INTO THE MEGAKERNEL - AN ANALYSIS, NOT AN IMPLEMENTATION (2026-09-17, on the user's request).
What the file holds, in three layers. (A) DATA: the instances - hashemi/hashemiBase/hashemiLeg/hashemiHanger/hashemiStand/
hashemiOutrigger/hashemiPanel, ymHashemi, dishR/dishF/dishHalf, hM12, systemVolts, cableArea/rhoCu - some forty numbers,
each with a provenance (figure, caption, frame, the user). (B) FUNCTIONS, all `noncomputable` over ℝ: rollerRadius,
azRate, sag/screwLength, postTop, edgeDepth, hangerLength, swingVertexAt/swingFocus/swingNormal, setLength,
tiltOfMismatch, cosTubeCut, wrenchAt/recip and the twists and wrench sets (yaw, swingTwist, screwTwist, hingeWrench,
screwWrench, constraints, constraintsGrooved), pointVel, elRate, wireTension, elPower, focusShift, wireLever/pulleyAt/
swungPt/edgeClipAt, slackSpot, cableDrop, boltStress, helixAdvance, facetSpot, strutStrain, plus Mount.lean's follow and
spot. (C) PROPS AND THEOREMS: requirements (AlwaysTangent, Fits, HangerClearsPost, MastClears, SlackHarmless, HoldsDish,
TrackerBudget, ReachesVertical) and proofs (numeric bounds, identities, reciprocity/rank, exact tracking).
WHY NOT LEAN'S OWN COMPILER: everything is over ℝ (Cauchy reals) - `Real.sqrt 3.36` cannot be evaluated; Frontier.lean
runs because Pareto is over ℚ. So "compile" is a METAPROGRAM: a command elaborator (`#hashemi_kernel "path"`, defs tagged
`@[kernel]`, a `HashemiMachine` structure bundling the instances as the one root) that reads each definition's Expr and
prints C99 from a small fragment - numerals (OfNat/OfScientific), + - * / neg, ℕ powers, Real.sqrt/sin/cos/tan/arctan/pi,
abs/min/max, Prod -> float2, `![..]`/Fin n -> ℝ -> fixed arrays, let, lambda binders -> parameters, instance projections
-> the generated param table (tunables) or literals, ℕ-recursion (follow) -> a loop; anything outside the fragment is a
compile ERROR naming the def, so the fragment is enforced by the macro. Emits: hashemi_geom.h (static inline device
functions, `hk_` prefix per the hygiene rule, MSL/CUDA-neutral), hashemi_params.h + JSON (the design-table row generated
WITH NAMES, unlike the hand-numbered FCTW/MECHW), hashemi_checks.h (Props as bool functions; theorem bounds as init-time
double assertions). The same traversal with a Float printer gives a Lean twin (`lake exe hashemi_twin`, JSON in/out, the
frontier pattern) for parity. ~500 lines of Lean; no external tool.
THE MEGAKERNEL: the repo already keeps one physics in three forms (_geo_core torch -> MSL -> CUDA, verify_megakernel /
tandoor_cuda_verify); the extractor makes Lean the first form and the three derived. Per agent per step: (1) sun
(mount_solve, unchanged); (2) the pose from the two motors - yaw about the tube at azRate, the swing t from the winch's
drum through the wire: L(t) = |edgeClipAt - pulleyAt| is monotone on [0, t*], inverted per step (Newton on the closed
form or a table from wireLever_edge_formula's denominator), the dead point a HARD CLAMP (deadTan_at_ym), wireTension x
wireLever the winch load (stall), hM12 the helical creep of F along the bar; (3) the mount-as-screws row GENERATED from
the spec - screw 1 yaw (w = z, q = tube), screw 2 screwTwist hM12 about the bolt line through (apexH, 0, zBolt), home
vertex/axis from swingVertexAt at t = 0, the constraint wrenches (hingeWrench/screwWrench, constraints) what MountCompliance's
C must be reciprocal to - the MECHW layout already has exactly these slots, the product-of-exponentials walk is
unchanged; (4) the errors that move F rather than the axis (tiltOfMismatch, focusShift, slackSpot) as design-rand
params - the one-time alignments the sensor cannot see; (5) the sensor loop: the dish's axis vs the sun, the sensor's
precision/misalignment as params, TrackerBudget gating the reward; the circuit's logic (deadband, homing) is NOT in the
spec - the policy or a deadband controller supplies it; (6) optics in tandoor_trace with two additions from the spec: the
receiver post through the slot (rim_under_F_iff: inside the footprint below 43.8 deg, a shading strip + a missing strip of
mirror) and the flat-facet blur (facetSpot: a 5 cm BOX, not the env's Gaussian slope error); (7) thermal/reward unchanged.
WHAT TRANSFERS AND WHAT DOES NOT: the STRUCTURE transfers exactly (mechanical translation, no transcription bug - the
class verify_megakernel exists for); the float error does not (Lean is exact-real; theorems have finite margins - the
tight ones: wireLever_sixty's 1e-6 interval steps, m12_carries_dish 3 %, the dead-point arm A cos t + B sin t -> 0 by
cancellation: compute in double). Bridges: (i) every theorem with a numeric bound -> an init-time assertion in double on
the emitted constants; (ii) every identity/inequality over the fragment -> a randomized property in the existing suite
(65 today, generatable); (iii) rank/reciprocity (LinearIndependent, span) do not extract - they are WHY the wrench sets are
right; the kernel gets the arrays and a numeric rank check. LEAN-vs-C SEMANTICS the extractor must handle explicitly:
x / 0 = 0 in Lean vs NaN in C (emit guarded division or assert the theorems' `hpos` side conditions), Real.sqrt of a
negative = 0 vs NaN, tan at pi/2, the two swing sign conventions (swungPt CW, swingVertexAt CCW - emit both, use one).
WHAT THE SPEC LACKS for a complete step: the drum radius/ratio, the sensor logic, the coil's size, the dish's mass and
CoM (W, rcm), wind (Wind.lean/MountCompliance), the thermal model - emitted as REQUIRED params with provenance "not in
the video", so the env must supply them (a typed contract, not a silent zero).
SEQUENCE IF DONE: (1) HashemiMachine root + @[kernel] tags, no proof changes; (2) extractor + C printer -> geom.h and the
JSON; (3) the Float twin + parity test; (4) the MECHW row from the JSON - the smallest env change with immediate value;
(5) the wire elevation drive + sensor loop in mount_solve/step_pre; (6) slot/post aperture + facet box in tandoor_trace;
(7) the generated property suite. Each step verifiable under the three-implementations discipline.

THE COMPILE PLAN, REVISED AFTER CONAL ELLIOTT'S concat (2026-09-17; the user: "take the 200 definitions already here,
convert them automatically - that is the point"; checkout at ~/Library/concat). THE PATTERN THERE: `toCcc :: (a -> b) ->
(a `k` b)` is a pseudo-function; a GHC Core plugin (plugin/src/ConCat/Plugin.hs + RULES in AltCat/Rebox) rewrites
ordinary Haskell functions into the categorical vocabulary of classes/src/ConCat/Category.hs - Category, ProductCat
(exl/exr/dup), ClosedCat (curry/apply), ConstCat, BoolCat/EqCat/OrdCat/IfCat/MinMaxCat, NumCat (negateC addC mulC powIC),
FractionalCat, FloatingCat, RepCat (structure <-> representation), CoerceCat, ArrayCat, UnknownCat (foreign nodes). The
program is written ONCE, monomorphically; every target is an INSTANCE: (->) the meaning; Syn (Syntactic.hs) the printed
categorical expression; (:>) (Circuit.hs) the hash-consed, optimised dataflow graph (buses + components, mkGraph ->
[CompS]); and PRINTERS off that one graph - writeDot/displayDot (RunCircuit.hs), GLSL (graphics/src/ConCat/Graphics/GLSL.hs:
`glsl = compsShader widgets . fmap simpleComp . mkGraph . uncurry` -> a Shader [UVar] funDef; genHtml writes an HTML page
with `var uniforms = <json>; var effect = <GLSL>` and `<body onload='go(uniforms,effect)'>`, the runner
graphics/out/shaders/script.js compiling the fragment shader on a full-screen WebGL quad with uniforms from Widgets:
timeW, sliderW, pairW), and Verilog (hardware/src/ConCat/Hardware/Verilog.hs: mkGraph -> Language.Netlist AST ->
GenVerilog -> ppModule). `EC a b = Syn :**: (:>)` is a product of categories - two backends in one pass. Other
instances: GAD/RAD/Dual (automatic differentiation), Interval, Incremental, SMT (satisfy -> z3), Choice, Regress,
Synchronous (Mealy (a x s -> b x s) s: stream transformers as circuits), StackVM. Gold tests check semantic preservation.
THE LEAN ANALOG, OVER THE 202 DEFINITIONS AS THEY ARE: Lean has natively what GHC needs a plugin for - reflection.
`toCcc` becomes a MetaM function reading `ConstantInfo.value!` and translating the Expr by Conal's rules (abstraction
elimination to combinators; the fragment is first-order like his circuits, so straight to a hash-consed DAG). The
vocabulary is enforced by the translator: NumCat/FractionalCat/FloatingCat (+ - * / neg, ℕ-literal pow, sqrt sin cos
tan arctan pi), ProductCat (Prod, `![..]`/Fin n -> ℝ as n-ary buses), ConstCat (OfScientific/OfNat numerals), RepCat
(structures <-> tuples; instance projections `hashemi.chord` unfold to literals, or stay as named inputs = tunables),
OrdCat/BoolCat/IfCat (classical `ite` on ℝ is fine syntactically; Props -> Bool nodes), UnknownCat (tandoor_trace as a
foreign node), Synchronous/Mealy for ℕ-recursion (`follow` IS a Mealy machine). Anything else -> a compile error naming
the def (his "Oops: toCcc' called"). Lean's Core-cast/dictionary noise: instance arguments in HAdd.hAdd, Nat.cast,
Matrix.vecCons, Real.decidableLT. `noncomputable` is irrelevant: nothing is evaluated, only read. WHAT LEAN ADDS THAT
HASKELL CANNOT: the translator also emits, per definition, `theorem f_ccc : eval (ccc f) = f` (rfl / simp), so his gold
tests become theorems and the file's 200 theorems transfer to the graph; the printers stay the only trusted part.
TARGETS, WRITTEN ONCE: Graph -> C99 (MSL/CUDA device functions; the megakernel = `ccc hashemiStep`, a new Lean def
composing the existing ones with the trace as an unknown node); Graph -> GLSL + HTML/JS (the concat-graphics style
applied to the machine: an image R2 -> Color of the y-z plane - bolt line, dish arc via swungPt, wire via pulleyAt/
edgeClipAt, mast, post through the slot - widgets timeW for the swing/day, sliders for ym/hp/W; the shader IS the
compiled spec and the dead point shows as the wire refusing to shorten; his script.js reused as is); Graph -> Verilog
(the control - deadband tracker, dead-point limit, homing - as a Mealy machine: the DC.P box from the spec; needs a
number representation, fixed point); Graph -> dot (every definition as a dataflow diagram); Graph -> JSON (the param
table). Free once ccc exists: AD (d(dead point)/d(ym,hp) for the design tool), Interval (rigorous float bounds - the
ℝ-vs-float gap closed), SMT (the Props to z3: "∃ mast with ReachesVertical ∧ MastClears"), Choice. The Syn :**: Graph
product trick = all backends in one pass. WHAT CHANGED FROM THE FIRST PLAN: not Expr -> C directly, but Expr -> Graph
once (CSE, constant folding, the preservation theorem once) -> many printers. Still automatic over the definitions as
they stand - no rewriting of Hashemi.lean. SEQUENCE IF DONE: Ccc.lean (translator + eval + generated theorems, ~600
lines); printers C/dot/JSON (~300), GLSL+HTML (~200, runner copied), Verilog (~200 + a netlist AST); `hashemiStep`; then
the env integration as before (MECHW row from the graph, the wire drive, the sensor loop). Sources: ~/Library/concat
(files above); http://conal.net/papers/compiling-to-categories/ (ICFP 2017); https://github.com/conal/concat.
CORE <-> EXPR, LINE FOR LINE (the user: "concat also gets Expr directly from the haskell source code"). His
plugin/src/ConCat/Plugin.hs (2299 lines) is one function `ccc :: CccEnv -> Ops -> Type -> ReExpr` over GHC Core with
cases Lam x body -> goLam (eta-reduce; a pair body -> mkFork = triangle; data constructors; Let inside a lambda ->
subst / float / beta-redex / compose), top Let (subst / float / beta), `reCat` (a categorical op already in (->) moved
to k - the "known" table, known/src/ConCat/Known.hs, and the Op0(addC..sqrtC) list in AltCat with RULES reboxing
Prelude methods), Case of bottom / Case of product (exl, exr) / Case unfold (of a DICTIONARY - class evidence), Cast
(coercions -> coerceC via reCatCo), App u v -> apply . (f triangle a), Tick. Lean's Expr has the same constructors
with the noise removed: lam (de Bruijn bvar, so abstraction elimination is index arithmetic), app (getAppFnArgs),
letE, proj / Prod.fst (his Case-of-product), lit + OfScientific/OfNat (his Lit), mdata (his Tick); NO casts (Lean
coercions are explicit terms like Nat.cast, matched by name); class evidence is an explicit instance ARGUMENT, so his
"Case unfold of dictionary" becomes: match the METHOD NAME (HAdd.hAdd ℝ ℝ ℝ _ a b -> addC) and never unfold past it
- Real.add is a Cauchy-sequence quotient and whnf into it is the one thing the translator must refuse. Two structural
differences in our favour: (1) his conversion runs INSIDE the compiler pipeline interleaved with the simplifier, so
inlining order matters (RunCircuit.go's NOINLINE + RULES "go'" trick; the run-time "Oops: toCcc' called"; output that
shifts with GHC versions, which the gold tests must tolerate) - ours reads the final elaborated closed term, is
deterministic, and can emit `eval (ccc f) = f` as a theorem; (2) Lean's source carries the theorem STATEMENTS, so the
same translator reads Props into Bool nodes - nothing in Core corresponds. The Lean translator for the first-order
fragment is a few hundred lines, not 2300: the 2300 are casts, dictionaries and simplifier interleaving.

IMPLEMENTED (2026-09-17, the user: "implement it", then "I want a puffer env megakernel"). tutorials/hashemi_ccc/.
THE COMPILER: RequestProject/Ccc.lean (~600 lines, mirrored in hashemi_ccc/lean/): `translate` walks a definition's
Expr - fvar / letE (zeta) / proj / app - into a hash-consed graph (`Node`: input lit bconst pi un bin pow ite; `Val`:
real bool pair vec struct), with the vocabulary as the match on the head constant (HAdd.hAdd ... Real.sqrt ... Prod.mk
... Matrix.vecCons ... ite ... LT.lt ... ∀ i : Fin n unrolled), user definitions unfolded by `unfoldDefinition?` +
headBeta, structure constructors read field by field (proofs skipped), instance projections resolved against the
constructor, `bindInput` turning binders of type ℝ / ℝ×ℝ / Fin n → ℝ / a structure into flattened inputs that carry
both a C name and a Lean access path. Printers: C99, dot, Lean-ℝ (the round trip), Lean-Float (the twin), NumPy.
Driver RequestProject/HashemiCcc.lean: `#eval` at `lake build` over the namespace, writing the artifacts. The step:
RequestProject/HashemiStep.lean - `TandoorHashemi.step` composed from the spec (dL/dt = -wireLever, so the swing
per step is `elRate` and the dead point a clamp; `deadPoint`, `slotExit`, `leverAt`, `stepParams`), 13 outputs.
BUGS MET, ALL FIXED: `b` as a pattern variable inside `def Val.flatten` resolves to the constructor `Val.b` (the
namespace is open there); ℝ is itself a Mathlib `structure`, so "unfold a structure instance" must key on the
body's head being a constructor, not on the type; double-backtick name literals are checked at elaboration, so a
module that does not import Mathlib uses single backticks; Greek binder names (ε δ ωm) must be transliterated for C
and kept for Lean; `Float.toString` prints six digits - the twin prints `Float.toBits`; `Float.sqrt x` as an argument
needs parentheses; `=` on ℝ is a tolerance in floats (four exact-equality checks fail bitwise otherwise); MSL needs
`thread` on pointer parameters (`HK_ADDR`); a generated file must import what it names or the names become
auto-bound variables and `rfl` "fails". VERIFIED: 127 compiled (72 defs, 7 props, 48 theorem checks), 74 skipped
(∀-quantified theorems, one higher-order Prop); round trip 0 errors - 79 `theorem f_ccc : f = ⟦ccc f⟧ := rfl`
kernel-checked; C(double) vs Float twin 381/381 samples; 48/48 theorem checks true in double; Metal `hashemi_step`
(torch.mps.compile_shader, one thread per agent, the header under MSL macros) vs the NumPy twin: max rel err 2.6e-6
over 4096 agents. NOT DONE: the ∀-theorems as property functions; wiring `hk_step` into tandoor_hashemi_env.py /
the puffer env (replacing its mount for the Hashemi config, generating the MECHW row from `yaw`/`screwTwist`) -
a change to the RL env's step that wants the user's choice of hook.


THE WRONG TURN AND THE MEGAKERNEL (2026-09-17/18). Asked to "wire it into a separate env that you will then test
against the raytracer", I subclassed the tandoor env and drove only its pointing with `hk_step`, scaling his 1.22 m
mast to the tandoor's 2.1 m dish - a machine the video never showed - with 126 of 127 compiled definitions unused
(commit c01c472c). The user: "Huh is this completely ignoring all the careful things we've done in Hashemi.lean", then
"use every definition in Hashemi.lean in the megakernel". DONE, tutorials/hashemi_ccc/ (its README is the record):
(1) Ccc.lean compiles THEOREMS WITH BINDERS as property functions (data binders → inputs, hypotheses → implications,
the telescope stopping at a leading `∀ i : Fin n`, conjunctions right-nested) and gains linear `let`, `Nat.iterate`
unrolling, structured `if`/`=`/`+`/`•`, arccos/arcsin, a classical-`if` node, let-bound Lean printing (the inline
printer was exponential on shared graphs and killed the driver with the OOM signal); (2) HashemiPropsGen.lean writes
HashemiProps.lean: `prop_X (data) : Prop := printed statement` and `prop_X_ok := X` for all 109 compilable theorems -
Lean checks the theorem compiler against every theorem (12 not compilable: higher-order, LinearIndependent, span
membership, ∃, a ∀ over ℝ under ↔); (3) HashemiStep.lean rewritten: the wire's LENGTH is the state's carrier
(bisection for the swing on [0, t*], slack, the winch gated by `HoldsDish` since the tension diverges at the dead
point - the first step divided the wire speed by the vanishing arm and flipped the dish to the zenith in the winter
run); (4) HashemiMega.lean: six functions applying EVERY definition and every `prop_X` at the state (az, t, slack;
the two motor rates; the sun; the eight values the video did not give, `megaParams`), 226 named columns, compiled to
one Metal kernel `hashemi_mega`, one thread per agent; (5) hashemi_env.py: HIS machine as a puffer env
(`puffer_hashemi_ccc`, hashemi_ccc.ini), reward the power on the coil, the video's sensor loop as a policy; the only
laws not from the file, said so in the code: the sun, the motors' full-command rates, the coil capture (two discs'
overlap of `facetSpot` shifted by `TandoorMount.spot`). VERIFIED five ways: 109/109 theorem statements proved by
their theorems; rfl round trip 196/196 (the 24-fold bisection excluded from rfl with the reason, its step
round-trips and the iterate rule is checked on `f^[3]`); C vs Float twin 945/945 over 315 functions, 109 checks true
in double; Metal vs NumPy 226 columns over 4096 states in the tracker's range (1e-3; capture 1e-2 from the arccos at
the lens boundary); two days at Quetta with 106 theorem columns never false. WHAT THE DAYS SAY: the dish parks where
the wire holds (61.14 deg of swing, sun 28.86, 1.75 kN against the 2 kN assumed) rather than at the dead point
(61.73, where the formula gives 934 kN); tracking within 0.05 deg in the 1.7 deg budget, capture 1.00, 1.65-2.06 kW
on the coil while the sun is in reach; June 67 MJ/day with 70 % of the sun-up steps in budget, December 31 MJ and
45 % - the video's closing shot, the dish pulled up and the sun on the horizon, is the winter afternoon. NEXT: the
12 uncompiled statements as tactic-checked properties; a ray trace of his faceted sphere onto the coil to test
`facetSpot` and the capture law; the mega row's eight parameters as a design box.

LEAN CALLS THE RAYTRACER (2026-09-18, "why aren't you writing optics theorems via our raytracing kernel ffi in lean?",
"what about that C99 calls MSL", "think about the semantics of raytracing in our optics and the fixed point theorems",
"do it all"). There was no FFI; now there is: bridge/metal_bridge.m, one C function in Objective-C that JIT-compiles any
MSL source and runs it on the buffers Lean hands over, bound by `@[extern]` in MetalBridge.lean, linked by the lakefile,
so `lake exe trace_check` measures theorems on the GPU from Lean and fails the build when one is false. The semantics: a
trace is a measure-preserving partial map on phase space (Optics.lean's Liouville), the power the pushforward measure
restricted to the capture set; the fixed points sit at four levels - F as the fixed point of the tracking group (the
machine), the focus of the ray map (absent for the sphere: the caustic), the bounce loop as a least fixed point (the
kernel's bounce cap = Feedback.lean's `iterate_stationary`, Hasegawa's trace/fixed-point correspondence being why Ccc
unrolls), and the loops around the optics (small gain, the thermal contraction, Bellman). HIS DISH TRACED FROM THE FILE
(HashemiTrace.lean, compiled, five verifications green: 347 functions, 115 theorem round trips, 223 rfl, 1041 samples,
Metal == NumPy): the sphere trace equals OpticsSphere's `dev`/`focal` exactly, the caustic theorem's half-spot bound is
attained at bestFocus, and THE FACET SPOT IS 1.13 m ACROSS, NOT 5.9 cm - the 1.6 m square panel's corners sit 1.13 m out
on the R 2 m sphere (beyond R/2, outside `blur_upper_cubic`'s domain), so 56 % of the on-axis rays reach the 12 cm coil
(76 % at the best plane 4.5 cm nearer the dish), the capture is 0.46 at 1 deg and 0 at 3 deg, and the tracker budget's
1.7 deg was the added model's, not the trace's; the env's reward is now the traced capture (38.6 MJ/day June, 16.1
December, against 67/31 under the model). `sunInDish_equivariant` PROVED: the fixed focus at the level of the trace.
THE HOMOTOPY (the user: the sphere is the fixed-point set of the rotations, the pumped film a continuous distension of it,
the learning problem lives on the homotopy of shapes; "can't we use homotopy enough to not need FvK?" - yes; "this needs
to work with the raytrace theorems"): the conic of revolution with constant k from -1 (paraboloid) to 0 (sphere), closed-
form hit, `conicZ_continuous`, `conicZ_sphere`, `conicZ_paraboloid` proved; measured: the sphere's J is the same for every
tilt when the cap faces the sun (0.034835 m), the paraboloid's coma grows (0 to 0.96 m at 30 deg), and a cap that cannot
turn is best at an INTERIOR k (-0.75 at 5 deg, -0.5 from 10 to 30) - one homotopy class, an interval of admissible k per
tilt. FvK dropped from the optics (its three theorems worth keeping: the knob's monotonicity, the reachable set, the gust
response). THE TANDOOR TRACE REPLAYED FROM LEAN (bridge/export_scene.py records a real dispatch): the replay reproduces the
record to 1e-6; one fate per ray, absorbed 96.1 of 104.0 m2/(W/m2) delivered; blur antitone on the rays the theorem is
about (102.6 -> 60.7) while the total first RISES (95.9 -> 96.1, `exists_blur_captures`: blur brings mis-aimed rays in);
pointing antitone with half power at 0.73 deg (the memory's 0.7, now measured from Lean); the site turned with the machine
changes the power 1.06 % because the fold, slot and horizon do not turn. Bugs met: the props generator importing its own
output (split into a core and two drivers at the right points of the import order); the round-trip file importing the
wrong top module (auto-bound names, `rfl` "fails"); `Prod.fst` applied to a pair with further arguments; Nat literals in
Float arithmetic in the check program. NEXT: the mega row's theorem columns fed by the traced capture; the FvK chart
measured (pressure -> k) on the env's seven fitted levels; the admissible-k intervals across a day as the policy's
target; the CPC lip's bounce bound (the first multi-bounce train, the fixed-point lemma's real case).

THE TRI MACHINE ALONG THE HOMOTOPY (2026-09-18, the user: "the tri receiver configuration is paramount"). The tri trace
takes the film as buffers (aperture points + normals per pressure level, the env's FvK/NURBS solve), so trace_check fits
the conic family to the film and replays the train with conic primaries along k. MEASURED: the film at every level is a
NEAR-PARABOLOID, k in -1.15..-0.80 (0.03-0.11 mm rms), pressure moving f from 4.85 to 3.91 m and k by a tenth - the env's
comment "measurably nearer a sphere than a paraboloid" is wrong on the env's own solve; the conic at the fitted k
reproduces the film's power through strip, M4 and pot to 0.3 %; and the capture at the pot RISES monotonically along the
homotopy at the same vertex curvature, 92.4 (paraboloid) -> 96.4 (the film) -> 116.7 (the sphere), +21 %, with the
pointing budget unchanged (half power 0.74 vs 0.75 deg: the strip's acceptance sets it). So the sphere end is worth a
fifth at the pot and pressure cannot reach it: the shaping control is the rim (tension, the strings), which is the
learning problem's real knob on tri, with the fitted k per level as the observation. 24/24 measured theorems.

THE RIM-SHAPING FAMILY THROUGH THE TRI TRAIN (2026-09-18, the user: "why not use nurbs"). bridge/film_family.py: the film's
zoned solve (per-zone pressures, the K-DOF adaptive mirror already in solve_membrane) at several laws, re-bisected to f
4.05, fitted into ARTIST NURBS control points warm-started from the working level (600 epochs, 5 s each on MPS),
evaluated at the env's aperture and consumed by the trace. trace_check section F: the design's own law refit reproduces
the recorded working level to 0.0002 % (the pipeline is exact); every other member loses at the same f - uniform 48,
law 0.2/0.6/0.8 -> 83/76/47, rim x0.6/x1.4 -> 85/73, a ring pressed in 35, against 96 - the zoned law is a sharp optimum
for the strip and M4 as built, the only admissible member at 5 %. Caveat in the record: far shapes' fits converged worse
(20-45 mdeg mean slope error vs 12, local maxima > 1 deg), so part of the loss is fit noise. 27/27 measured theorems.

THE SOLTRACE OBJECTIONS, FIXED (2026-09-18, "what would the author of soltrace say", "fix these"). (1) A sampled sun and
statistics: Monte Carlo rays from Lean's generator (facet, point, pillbox disc), capture as a Bernoulli estimate with its
standard error; zero-error trace = the trace on 40000/40000 fates. (2) Optical errors: `traceRayErr` tilts the normal by a
Gaussian slope error and the reflection by a specularity error; on axis 0.591+-0.002 -> 0.584 at 4 mrad: his dish is
ABERRATION-LIMITED (8 mm of error against a 1.13 m spot); the pointing cliff under 2+1 mrad errors 0.596 -> 0.000 over
0-3 deg, antitone within error bars. (3) The stage model: his dish as an instance of Feedback's train, and
`dishTrain_fate` PROVED - the train's fate is `traceRay`'s fate code - so the fixed-point theorem is about the compiled
trace. Ccc gained a `let`-in-head-position case (a reflected vector applied to an index). 30/30 measured theorems.

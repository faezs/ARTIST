# The dish mount as a freedom, actuation and constraint topology

The machine is the Cassegrain-receiver Hashemi machine on nix-support (working config, 2026-09-05): dish a 2.1 m,
pumped membrane as a sphere R 8.2 m, orbiting its focus F = (1.25, 0, 9.87) at 4.0 m, axis through F, hole
r 0.5 and slot 0.7 toward the sun, the hyperboloid strip 0.8 m under F, the beam down the vertical through the
deck hole to the ellipsoid M4. Frame x north, y east, z up; wall line x 1.25; deck z 5.0. The optics are not
touched. This memo designs what holds the dish and F, in the language of Hopkins's Freedom, Actuation and
Constraint Topologies (thesis, MIT 2010, `../../resources/hopkins_2010_FACT_thesis.pdf`), with the automated
constraint placement of Shaw et al. 2019 and the geometry of Hashemi's paper (`~/Downloads/fixed-focus-ir.pdf`).

Numbers from `screw_mount.py` (`out/screw_checks.txt`), `tendon_solver.py` (`out/tendon_solution.json`),
`water_stem.py` and `physics_hp.py`; drawings `out/hp2_*_views.svg`; models `out/hp2_*.json`.

## 1. Twists, wrenches and the two spaces

A small motion of the dish is a twist T = [Δθ; c × Δθ + pΔθ] (thesis eq. 1.1); a flexible constraint or a load
is a wrench W = [f; r × f + q f] (eq. 1.3); a constraint permits a motion when Wᵀ[Φ]T = 0 with Φ swapping the
two halves (eq. 1.6-1.7), and a system's freedom space is the null space of its constraint space (eq. 1.9). Only
pure-force wrenches (q = 0) model flexible constraints: a wire is one line, a blade three coplanar lines (p. 23).
The count is 6 = m + n (eq. 1.5). Redundant constraints may be added anywhere inside the constraint space; they
change stiffness, dynamics and load capacity but not the DOFs (p. 25). In this memo the pairing is about F:
t = [dx_F; dθ], w = [f; τ_F].

## 2. The FACT design process applied (thesis Fig. 2.7)

**Step 1, desired motions.** Hashemi's figures 3-5: the vertex rides the focal circle of radius R/2 about F with
the axis through F. Tracking is two rotations about F, azimuth about the vertical and elevation about the
horizontal perpendicular to the sun's meridian. At any instant these two intersecting rotation lines span a
disk: the thesis's 2 DOF Type 1 (§3.3.1). Its constraint space is every line through the disk's centre, every
line in the disk's plane, and a torque normal to the plane (Fig. 3.12). But the disk turns with the sun, so the
constraint set that serves the whole day is the one common to every such disk: the lines through F only. That
is the 3 DOF type whose freedom space is the sphere of rotation lines through a point and whose constraint
space is the sphere of lines through it (Fig. 2.2, 3 DOF column). We accept the third rotation, roll about the
sun line, as a freedom to be held by actuation; it carries no wind torque on a round dish.

**Step 2, freedom space.** The sphere of rotations about F; n = 3.

**Step 3, parallel or serial.** The sphere lies inside the parallel pyramid (Fig. 2.2): a parallel system exists.
Hashemi's own machine is the serial alternative: an azimuth stage (lines meeting the vertical through F: the
ring rail's rollers) then an elevation stage (lines meeting the horizontal through F: the arc rail D centred on
F), two intermediate 1 DOF Type 1 spaces summing to the disk. The parallel one has no rails.

**Step 5, ground and stage.** The stage is the dish with an outrigger ring at r 3.2 m in the rim plane. The
ground is the top of the focal tube: Hashemi's near method (his Fig. 8B), the bore casing continued above the
deck through the dish's slot, r 0.9 at the deck, 0.35 through the crossing band, 0.45 to the strip's bearing
ring, a spigot to F. The env's arm from a tower 3 m north is not usable: that tower's line pierces the membrane
at 13 of the 59 sun positions of the year (`physics_hp.py`).

**Step 6, constraints from the constraint space.** m = 6 - 3 = 3 non-redundant lines through F. We use four,
one redundant for load sharing and single-wire loss: 8 mm wires from the outrigger ring at ±70° and ±110° from
the slot direction to the spigot at F. Azimuths on the ring are fixed in the dish frame, and the strip's
meridian is fixed in the dish frame too (it is the slot direction), so these four never meet the strip: the
minimum clearance over the year is 0.14 m, and at r 3.2 the wires run outside the light cone all the way.

| check (equinox noon, and over the year) | result |
|---|---|
| rank of the four bridle wrenches | 3, DOF 3, all three rotations about F (`interface_freedom`, `describe`) |
| any three of the four | rank 3: one wire lost keeps the virtual pivot |
| reciprocal product with each rotation about F | 8.9 × 10⁻¹⁶: the bridle never resists a rotation about F |
| TWSM of the bridle alone (eq. 4.8) | eigen-stiffnesses 0, 0, 0, 0.2, 1.5, 2.3 MN/m: three zero rotations, three stiff translations |

## 3. Actuation space (thesis ch. 4)

Hopkins defines the wrench that actuates a motion with minimal parasitic error through the twist-wrench
stiffness matrix, W = [K_TW] T (eq. 4.1), K_TW = Σ N_R S N⁻¹ over the constraints (eq. 4.8-4.11); the
frame-FE of this repository is that matrix. His worked example (Fig. 4.2, 4.6, 4.8) is three flexures
converging on a point, the same topology as our bridle: its actuation space is a plane of pure forces below the
convergence point plus a pure moment for the third rotation, and he notes a moment may be replaced by a force
whose line is far from the axis (p. 118).

For a bridle of cables the rotational block of K_TW is exactly zero, so the actuation wrenches for the three
rotations are pure moments (q infinite): any force through F is in the constraint space and only stretches the
wires; any force not through F carries a moment about F, which turns the dish, and a force part, which loads
the bridle and moves F. That is the screw statement of "apply the torque by flexing": a couple applied at the
dish does no work against lines through F. With the stem included in the TWSM the equivalent actuation lines
fall 11.8 m from F, three times the dish distance, which is a couple for all practical purposes.

So the actuators are:

- **the stem**, an inflated hose r 0.80 m at 1.0 bar from a root on the deck at x 2.5, clamped to the dish's
  back ring: a compliant 6-DOF element whose bending couples about the two axes normal to the sun line are the
  elevation and azimuth actuation wrenches, and whose torsion holds roll. It is a displacement actuator in
  Hopkins's sense (§4.4.2): its commanded curvature is the input. Pumping water between two side chambers, a
  pressure difference of 0.1-0.2 bar, gives 3.4-6.8 kN m of couple at any section and holds with a closed valve
  (`water_stem.py`). One degree of elevation moves the back ring 72 mm, the stem's tip travel.
- **no deck tendons.** They were linear actuators outside the actuation space, kept for gust stiffness; the
  fine stage of §3a makes that stiffness unnecessary, and without them the roof is the dish's sweep alone.
  (§4 records what the tendon solver found; it stays as the method for any future line.)

## 3a. The fine stage: milliradian accuracy from exact constraint

The coarse stage cannot point to a milliradian in wind: the stem alone holds 1.7 mrad at 9 m/s and its
error grows with the square of the wind speed. Hopkins's serial synthesis (ch. 2, Fig. 2.7 steps 3-4) is
the remedy: a second stage in series with its own intermediate freedom space. Intermediate space 1 is the
sphere of rotations about F (the bridle and stem, the whole sky, milliradians). Intermediate space 2 is
3 DOF Type 1 about the dish's vertex (§3.4.1, Fig. 3.37): the two rotations in the dish's back plane and
the translation along its axis, that is tip, tilt and focus. Their DOFs sum to 6, the system's, so the chain
is not underconstrained (p. 36). The fine stage does what a flexure is uniquely good at: it has no friction,
no backlash and no stick-slip, so it can be commanded and held to microradians, and it is stiff in every
direction it constrains.

Constraint space of 3 DOF Type 1: every line in the plane and a torque normal to it (Fig. 3.38). The stage:

| element | value |
|---|---|
| constraints | three 12 mm 17-7PH rods 0.9 m long, tangential in the back plane at r 1.4 m: one line each, m = 3, exact; radial growth of the aluminium dish against the steel frame (0.62 mm at 40 K) only bends them (5 MPa) |
| actuators | three sealed water columns normal to the plane at r 1.6 m, 120 deg apart, rolling-diaphragm or edge-welded-bellows cylinders: displacement actuators (§4.4.2) whose lines lie in this type's actuation space, the box of lines normal to the plane (Fig. 4.3); locked, they are three more constraint lines: rank 6, DOF 0 |
| FACT checks | rods alone rank 3, DOF 3, exactly tip, tilt and the normal translation (`interface_freedom`); reciprocal products with those three: 0; with the columns: rank 6 |
| range | ±20 mrad tip and tilt, ±32 mm of focus: rod end offset 28 mm, S-bend stress 249 MPa = 0.17 σ_y; Euler SF 11 on the in-plane loads |
| stiffness, locked | 77 MN m/rad about the vertex, 60 MN/m in focus (20 MN/m per column at 0.5 GPa effective bulk modulus) |
| wind on the locked stage | drag asymmetry torque 315 N m at 9 m/s: 4 µrad; 2.4 kN m at 25 m/s: 32 µrad; columns carry 0.25-1.9 kN each |
| metering | 1 mL moves a column 0.10 mm, 62 µrad of tilt; a 10 mL/s pump slews 0.62 mrad/s; a closed valve holds with no power |
| thermal | 21 mL of water expansion per column over 40 K is 1.3 mrad of slow drift, taken out by the loop; or a matched reservoir cancels it |
| focus | the piston trims the vertex onto the true focal circle R/2 = 4.10 m against the env's 4.0 m orbit (§7) |

Accuracy budget: the coarse error (1.7 mrad at 9 m/s, slow) sits inside the fine range with a factor of ten;
a loop on the beam centroid at the tube's waist corrects it at a few hertz; the residual is the coarse error
divided by the loop's rejection plus the locked stage's 4 µrad, of order 0.2 mrad in a 9 m/s wind and
microradians when the air is still. Above about 18 m/s the coarse error leaves the fine range: survival, not
cooking. The stage is the M5 facet pad of stage 2 scaled up, with water columns in place of screws; it is
where the earlier flexure work belongs, at the accuracy end of the machine, not in the tracking pivot.


## 4. Why lines from below cannot hold the dish, and what the solver found

Gravity's wrench about F is a torque that swings the dish down its orbit toward the point under F. A tension
line from the dish to any anchor below it has a moment arm about F of the same sign: at equinox noon every
deck-anchored line had a positive arm about the east axis while gravity's torque was +1244 N m. The set of
unilateral lines from below cannot positively span the torque space, so no pretension state existed: 95 % of
the 531 load cases were infeasible with four deck tendons and no stem, and 100 % without tendons once the
stem's couples were left out of the model. Hashemi solves it with a tow wire to a pulley at the top of the arc.
The stem's couple solves it here; with the stem entered as a bounded six-component wrench source, every case
closes.

The tendon routing then becomes a constraint-placement problem of the kind Shaw et al. automate: enumerate
candidate lines, test each, keep the independent ones. `tendon_solver.py` takes 12 attachment azimuths on the
outrigger ring and 69 anchors on the deck and in the courtyard, 828 lines, and rejects any line that at any of
the 59 sun positions passes within 0.35 m of the focal tube, within 0.35 m of the stem, or inside the light
cone; 44 survive. It then picks four by the smallest singular value of their 3 × 4 moment-arm matrix about F
over the year, 1.58 m, against 0.1 m for my hand-picked pairs, which crossed the tube at other hours because
a dish-fixed attachment sweeps 220° of azimuth relative to the ground in a day.

| tendon | attachment on the ring, from the slot direction | anchor (x north, y east, z) |
|---|---|---|
| 1 | 60° | (9, -8, 5) |
| 2 | 180° | (11, -4, 5) |
| 3 | 180° | (11, 4, 5) |
| 4 | 300° | (9, 8, 5) |

## 5. Loads, stiffness and robustness over the year

Statics: an LP at each of 59 positions for gravity and eight wind directions, tensions unilateral above 300 N,
the stem's shear, axial force, couples and torsion bounded by its wrinkling moment (π/2)p r³ = 126 kN m,
torsional wrinkling √2 π p r³, and the hoop thrust. Stiffness: K = Σ k w wᵀ over the lines plus the stem's tip
stiffness transported to F; the compliance twist under the wind wrench gives the pointing.

| quantity | 9 m/s | 25 m/s |
|---|---|---|
| load cases without equilibrium (stem r 1.0 m at 0.8 bar, no tendons) | 0 of 531 | 0 of 531 |
| stem base moment needed, incl. its own drag, against M_w 126 kN m | 7.4 kN m, SF 17 | 44.7 kN m, SF 2.8 |
| largest bridle tension (8 mm rope, MBL 38 kN) | 1.7 kN | 6.4 kN, SF 5.9 |
| coarse pointing error about F | 1.7 mrad | outside the fine range above ~18 m/s |
| translation of F (parasitic) | 0.1 mm | |
| fine stage, locked: pointing under the drag asymmetry | 4 µrad | 32 µrad |
| coarse first mode, 60 kg head | 10 Hz | |
| clearance bridle-strip over the year | 0.14 m | |
| any single bridle wire lost | rank 3 remains: the pivot holds | |

The machine stays deployed at 25 m/s. Venting remains the fallback: the stem folds, the dish lies face-up on the
deck around the root, the bridle and tendons slack.

## 6. Water in the stem

Hydrostatic pressure adds 0.1 bar per metre of fill at the root, where the cantilever moment is largest: 2 m of
water raises the base wrinkling moment from 80 to 96 kN m at no cost to the hoop load above the fill. The same
2 m is 4 t; on the 1.8 m root footprint it is 36 kN m of restoring moment, which is the 25 m/s demand: the
water is the foundation, no anchors into the roof. Two side chambers pumped against each other are the
actuator of §3, turgor: 100 L/min moves a quarter of a 2 m section in 5 min against the sun's 0.25°/min. The
column's first slosh mode is 0.75 Hz, in the gust band, a tuned liquid damper for whatever low-frequency swing
the tendons leave; the mount's own mode is at 13 Hz.

## 7. Hashemi's optics against the env

The paper's condition (figs 3-4) is that the dish is tangent to the focal circle of radius R/2: R 8.2 m gives
4.10 m, the env orbits at 4.0 with f_nom 4.05. The vertex sits 0.10 m inside the focal circle, a marginal-ray
defocus blur of 51 mm radius at F against the strip's 0.44 m half-width. Tolerable, and the other fork's to set;
the mount serves any radius. His "bent rail behind the dish to make it more resistant to wind" (p. 13) is the
job the stem and tendons do here, without a rail.

## 8. Open

- Roof: with the tendons gone the machine needs the dish's sweep, 9.2 by 7.8 m for the 4.2 m dish at f 4.1,
  of which 5.8 m north of the wall; at the same f/D a 3.0 m dish needs 6.5 by 5.6 m and a 2.1 m dish 4.6 by
  3.9 m, and the structure scales with it at constant pressure.
- The fine stage's water columns: cylinder type, seals without stiction, the metering pump and valves, and
  the beam-centroid sensor at the waist are the next design.
- The bridle-strip clearance of 0.14 m is tight; r 3.4 on the outrigger would give more at the cost of a bigger
  ring.
- The stem at r 1.0 m and 0.8 bar carries 80 kN/m hoop: coated polyester in two plies; the reel that everts and
  retracts a 2 m hose is unproven.
- The slot and its flaps, the strip's winter behaviour and the orbit radius belong to the optics fork.
- The turgor pump loop, its valves and the pointing controller are the next design.

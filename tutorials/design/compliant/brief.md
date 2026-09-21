# Design brief: machine-scale compliant structures for the three mirrors

Written from the readers' findings in `brief_findings.md` (geometry, loads,
FACT motion sets, precedents; every number there carries a file:line or
paper source, or is marked estimate) and the robustness requirements in
`brief_robustness.md`. This brief is the contract for the stage-2
designs: full-scale, three-dimensional compliant STRUCTURES built as
directionally compliant lattices (DCM, Shaw et al. 2019, ported in
`fact/dcm_core.py`) wherever a degree of freedom is needed, and as
exact-constraint athermal structure everywhere else.

## 1. World frame and layout (stock machine)

World frame: origin on the tandoor axis at the pot mouth plane (the
workfloor); x toward the tower wall, z up; sun vector u = (north, east,
up) enters as u = (s_y, s_x, s_z), so +x is north.

| reference | position [m] | source |
|---|---|---|
| tower wall / mast axis | x = 1.25 (X_TOWER = X_CHASE) | frame constants |
| workfloor = pot mouth plane | z = 1.00 (H_POT); pit floor z = -1.44 | frame constants |
| roof deck / parapet top | z = 3.60 / 3.95; deck 11.4 x 11.4 m centred on the mast | building |
| fold F (stock: the fold, not the focus) | P_f = (1.25, 0, 9.373), 5.77 m above the deck | mast |
| post | r 0.15 from z 3.60 to 9.273; four-leg mast above deck (legs not modelled) | mast |
| dish orbit | centre P_f, radius g = 5.0 m; dish radius a = 2.10 m, f = 9.767 m (sphere R 19.5) | mount law |
| ring rail / rotating beam | R 4.6 m about (1.25, 0) at z 3.65 / 3.70, 12 posts to the deck | carriage |
| arc rail (focus-centred) | radius ~5.35 m about P_f in the carriage's vertical plane (assumed +-0.8 m rail spacing) | carriage, estimate |
| waist / tube | z_waist 4.606; tube z 4.176..5.035, inner r 0.327 | bore |
| M5 | V0 (1.25, 0, -0.10); foci fW (1.25, 0, 4.606) and fT (0.42, 0, 0.14); semi-major 2.785 m; patch r 1.11 m, 43 facets 0.32 m hex, incidence 8.9-50.9 deg, R_t 0.97-3.72 m, R_s 0.94-1.48 m; projected extent x -0.06..1.97 m; ~5 south facets fall inside the modelled pot sphere (trim or move the wall) | M5 |
| duct into the pot | aperture centre (0.42, 0, 0.14), r 0.20; 0.83 m from V0 | duct |
| deployed schedule | beta_dev 36, cap 10.6 m; el_b 7.7-62.7 deg; a 54 deg el_b seam twice a day (27 deg in fold tilt); tracked 6:15-17:45 (d172) | mount |
| dish rim envelope, deployed | rim top up to 10.4 m, rim bottom down to 3.52 m on the negative-beta branch (0.08 m BELOW the deck: unresolved interference), reach 5.9 m (parapet says 7.1 m sweep; renderer deck half-width 5.7) | mount |

Receiver-at-focus variant (fold AT the focus, the user's direction):
F = (3.75, 0, 8.468) for f = 4 m (post 4.87 m above the deck), F =
(3.75, 0, 10.307) for f = 6 m; the beam-down is a 0.15 m mirror at F,
tilt = 45 - el/2; the downstream chain (M3 at the wall, M4 at duct
height, chase r 1.3) is an optical optimum with unresolved structural
conflicts (the chase crosses the pot and tower walls). The fold
structure is designed for this variant; the dish and M5 for the stock
positions, parametrised so the variant's numbers drop in.

## 2. Per mirror: functions, motion sets, loads, environment

### 2.1 Primary dish (pumped membrane, a = 2.10 m)

| item | value | source / note |
|---|---|---|
| membrane | 50 um PET, E 3.7 GPa, T_pre 600 N/m in code (memo used 2000: decide), p0 114 Pa at f 9.77, levels 0.62-1.10 p0 (71-125 Pa), envelope 31-185 Pa; f 4 m needs 375 Pa | code + derived |
| rim loads | hoop 2.2 kN (f 9.77) to 4.7 kN (f 3); axial pressure load 1.6-6.9 kN; sag 113-217 mm; rain 12 mm pooling | derived |
| mass cases | 60 / 140 / 250 kg (films 1.4-2, rim 38, hub 10-40, jam bed 83, sled 60-120) | estimate |
| wind | 9 m/s: 0.94 kN drag, 0.67 kN lift, 0.40 kN m; 25 m/s survival: 7.27 kN, 5.2 kN, 3.05 kN m (Cd 1.4, CL 1.0); design gust 47 m/s at lat 28.6 for a 50-yr return (not in code) | estimate |
| gravity moment at pitch axis | 135 -> 5 N m over el 10-88 deg for 140 kg at 0.1 m; keep the axis within 20 mm of the CG: <= 30 N m | derived |
| motions and FACT verdicts | azimuth 240 deg/day: BEARING (post bearing + 3 ring rollers, rank 5 exact). Elevation 52-76 deg along the focus-centred arc, 4-6.6 m travel: RAIL (4 bearings on 2 rails, rank 5), optional +-25 mm compliant fine stage. Beta pitch +-18 deg about the axis through the CG, 0.34-2.6 kN m: FLEXURE / DCM (constraint space 5-D, lines meeting the axis). Rim squeeze +-33-40 mm: an elastic ring's m = 2 mode, 0.73-0.89 kN, not a rigid-body DOF. Plenum levels: pneumatic. | fact reader |
| rates, accuracy | az 0.035 deg/s, el 0.025 deg/s (sun 0.004), hold 0.3 deg, sun lost at 3 deg; 0.02 deg/step backlash noise in the env | code |
| cycles | 1 pitch sweep/day (2e4 in 20 yr) plus ~1e7 gust micro-cycles/yr (rainflow from a Kaimal spectrum: the env's OU gust has nothing above 10 mHz) | derived |
| environment | outdoor rooftop, -10..+60 C, dust, rain; the film is the weak element (creep above ~60 MPa) | derived |

### 2.2 Beam-down fold at F (receiver-at-focus layout)

| item | value | source / note |
|---|---|---|
| mirror | 0.36 x 0.44 m elliptical 6061 plate 12 mm + fins, ~7.5 kg, face-down at F; spot 7-13 cm radius, 90-300 suns, 4.5-6 kW delivered (9 kW with optics upgrades) | memo, README |
| tilt law | normal bisects the beam and the vertical: tilt 45 - el_b/2 -> 15-41 deg working (stock schedule; 12-47 deg if el_b runs 12-88), 27 deg seam twice a day; azimuth 240 deg from the carriage bearing | mount law |
| loads | mirror + hood 10-15 kg; wind on the hood at 9/25 m/s (~0.1 m2: 50 / 380 N); post sway at 9 m/s ~5-10 mm at 8 m (estimate); tilt torque 0.3 N m gravity + the flexure's own spring | estimate |
| thermal | absorbed 210 / 450 W (silver / dielectric); +35 K finned passive, +75 K worst; flexures at ambient +15 K; 10-min spot walk on the hood rim at 3-15 kW/m2 | derived |
| FACT verdict | 1 rotation about the axis in the face plane through F: constraint space = all lines meeting the axis (5-D). DCM saddle on the mirror's back: N interfaces of oblique wire cells, exact per interface, range N x per-interface | fact reader + dcm_core |
| accuracy | 2-5 mrad absolute, better repeatability; relay tolerates 5-10 mrad of beam error | memo |
| fail-safe | park at the stop with the beam dumped onto the hood rim / bumper; the lattice's neutral state IS the park state (power loss returns it) | robustness R6, R13 |

### 2.3 M5 relay (ellipsoidal patch, 43 facets)

| item | value | source / note |
|---|---|---|
| patch | r 1.11 m (30 m2 / 2-3 m radius in receiver-at-focus layouts), 43 pressed-toroid Al facets 0.32 m hex ~0.5 kg each, R_t 0.97-3.72 m, R_s 0.94-1.48 m, incidence 8.9-50.9 deg; frame ~440 kg (estimate) | M5 + estimate |
| duty | hold each facet to 10 mrad through +-40 K daily cycles for 20 yr; patch position to a few mm relative to fW and fT | memo |
| loads | 49 N per facet with the hatch open at 47 m/s; self-weight; 1.5 kN tie-down; incident 1-5 suns | estimate |
| FACT verdict | per facet: tip + tilt + piston (2 rotations in the facet plane + 1 normal translation): constraint space = all lines in the facet plane (3-D), NOT a cell space -> layered intermediates (1R about x, 1R about y, 1T along z) or 3 tangential in-plane wires; then 3 hard-contact adjusters take the 3 freedoms (6 constraints, 0 DOF, adjustable). Global fine steer: 2-3 DOF of the whole patch | fact reader + dcm_core |
| athermal | monolithic Al facet (bonded dissimilar layers give 19-46 mrad at 40 K); frame with a thermal centre on the patch reference; radial-free feet | memo + R8/R9 |

## 3. Robustness rules

`brief_robustness.md` R1-R11 and following apply verbatim: exact
constraint (rank = 6 - n), no sliding fit in any optical stage, working
stress <= 0.30 sigma_y(T) (0.25 where a position is held at
temperature), survival with stops SF >= 1.5, infinite-life fatigue with
Goodman and temperature knockdown, position by latch not spring, one
relief direction per dissimilar-material loop, thermal centre on the
optical reference, flexures in tension or buckling SF >= 3, stiff/
compliant ratio >= 1000 and first mode >= 5x the disturbance. For DCM
lattices two rules are added here:

- R-DCM-1: element redundancy is the robustness mechanism: any single
  element fracture changes the interface stiffness by < 2 % and no DOF;
  show the wire count per interface and the stiffness with one wire
  removed.
- R-DCM-2: the lattice's neutral (as-built) state is the safe state
  (park); actuation works against the lattice from park, so power loss
  returns the mirror to park without a spring or a gravity trick.

## 4. Precedents to use

Keck 36-segment support (36 axial flexures as 3 x 12-point
whiffletrees, 30-leaf warping harness), the 18-point Hindle flexure
whiffletree (3 bipods + 6 tripods) whose flexure failure at 9 months is
the cautionary tale, STABLE/ASTEP bipod athermal benches (<10 um over
-70..70 C), Sandia stretched-membrane mirrors (14 m module, 304 SS
film on a box-beam ring, focus by plenum vacuum, toroid -30 %), CSEM
butterfly pivot (+-15 deg, 2 N m/rad, <2 um), the ESA/CSEM large-angle
pivot (+-90 deg, 467 g, 0.53 N m, <10 um shift, qualified with a factor
4 on life cycles and a 1 mrad clamp-misalignment buckling lesson), LLNL
stacked cross-pivots (range scales with the number of stacked stages),
and the DCM paper's own 1R and 3R cubes reproduced by `dcm_core.py`.

## 5. Deliverable per structure

1. `stage2/<mirror>/model_<mirror>.py`: the whole structure at full
   scale in mm, z up, from the coordinates above; DCM blocks generated
   cell by cell with `dcm_core`; every element a part; exports the JSON
   mesh for the page viewer (lattice wires as line segments to keep it
   small) and elevation/plan drawings.
2. `stage2/<mirror>/checks`: dcm_core's per-interface rank/DOF and the
   stack's freedoms; the frame FE's compliant/stiff ratio, first modes
   with the real mass, stress at range, buckling of the most loaded
   element, thermal drift per 40 K, one-wire-removed stiffness.
3. `stage2/<mirror>/memo_<mirror>.md`: requirements traced to this
   brief and to R1-R11, the structure part by part, the numbers, the
   weak-link order and safe state, materials, manufacturing (wire-EDM
   or additive Ti for the lattice, folded/rolled sheet for facets),
   mass, open risks.

## 6. Open gaps to bound

Pot wall thickness and the M5-to-pot masonry (estimate 0.10-0.15 m);
mast leg geometry; the deck-size versus sweep inconsistency and the
negative-beta rim-below-deck interference; the 54 deg seam's real slew
time (~36 min at 0.025 deg/s); membrane pretension 600 vs 2000 N/m;
the receiver-at-focus downstream chain's structural layout; a real
turbulence spectrum for fatigue; the five M5 facets inside the pot
sphere.

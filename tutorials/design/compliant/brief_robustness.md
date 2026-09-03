# Robustness design rules for the three compliant mirror structures

Scope: (1) the 2.1 m pumped-membrane dish on the fixed-focus carriage
(compliant pitch stage, rim-toroid squeeze, parallelogram roller
suspensions), (2) the beam-down fold at F on the post (two Ti-6Al-4V
cross-axis pivots, 90-300 suns), (3) the M5 ellipsoidal relay of 43
facets on bipod feet in the pit. Companion memos: `primary_dish.md`,
`beam_down_fold.md`, `m5_relay.md`. Premise: a flexure has no
lubricant, no wear, no backlash and one deterministic rest state; at
temperature that is a structural advantage because there is no
clearance to seize and thermal growth is taken by strain that is
designed in. The rules below make that premise checkable. DRAFT 1 -
sources and numbers being verified against the open literature.

## A. Design requirements (checkable)

Abbreviations: D = dish, F = fold, M5 = relay. "Check" names the
analysis or test that closes the rule.

**R1 Exact constraint.** Every stage constrains exactly 6 - n DoF; no
redundant constraint anywhere in a moving optical loop. *Reason:*
redundant constraints turn thermal growth and build tolerance into
locked-in stress and unpredictable position (Blanding 1999; Hale 1999
ch. 6). *Apply:* D pitch stage 5-D constraint space; F 5 constraints
about the face-plane axis; M5 three bipods = 6 constraints (already
computed in `fact/`). *Check:* screw-algebra rank = 6 - n; fit-up test:
last fastener closes with no gap and no strain.

**R2 No sliding fit in any optical stage.** Motion only by flexure,
preloaded rolling element, or a threaded latch under one-signed
preload. *Reason:* sliding fits need lubricant and clearance; both are
what heat, dust and 20 years destroy (Slocum 1992 ch. 7; Howell 2001
ch. 1). *Apply:* D rollers on parallelogram suspensions, Tr screw as
latch; F pushrod necks replace pin joints, PEEK nut on a rolled screw
is the one sliding interface and is outside the optical loop; M5 screw
ball-on-pad detent. *Check:* parts list has no bushing, journal or
slide in the loop.

**R3 Working stress fraction.** Peak flexure stress at the extreme of
the working range <= 0.30 sigma_y(T) in ambient and pit zones and
<= 0.25 sigma_y(T_fault) for any flexure that holds a position at
temperature (F). *Reason:* infinite-life fatigue and stress relaxation
both scale with the stress fraction; Howell/Handbook ch. 1 p. 7 warns
that held stress at temperature takes a set. *Apply:* D 427 MPa /
1580 MPa = 0.27 ok; F 200 / ~760 MPa at 120 C = 0.26 ok; M5 bipod
375 MPa at full 30 mrad range is 0.5 of 17-7PH/316 yield - reduce the
adjuster range or lengthen the legs. *Check:* nonlinear FE at the
range extremes, Kt included.

**R4 Survival load with stops engaged.** With the hard stops carrying
the survival case (25 m/s, 1 g shock), the flexure stress has SF >= 1.5
on sigma_y(T). *Reason:* ECSS-E-ST-32-10C uses 1.25 on yield for
structures; a flexure that yields has lost its calibration, so take
1.5. *Apply:* D 687 MPa at 25 m/s, SF 2.2 ok; F blades at the 42.5 deg
park stop with 20 m/s on the hood; M5 legs at 49 N/facet with hatch
open. *Check:* FE, stop contact plus survival load superposed.

**R5 Infinite-life fatigue.** For every flexure cycled more than 10^4
times over life: sigma_a <= sigma_e(surface, size, T)/1.5 on a Goodman
line; finite-life items (bistable trips, latches, ~10^3 cycles) verified
by a 4x life test. *Reason:* ECSS-E-ST-33-01C requires a factor of 4 on
life cycles for mechanisms; the ESA LAFP pivot was qualified this way.
*Apply:* D daily sweep Goodman 0.65 at 2e4 cycles, plus 10^7 gust
micro-cycles/yr which must be rainflow-counted from a Kaimal spectrum
(the env's OU gust has none above 10 mHz); F 15 k major cycles at
130 MPa, Goodman 0.5; M5 ~100 adjust cycles, 7300 thermal cycles at
< 10 MPa. *Check:* rainflow + Goodman with temperature knockdown.

**R6 Hold position by a latch, not by the spring.** Any position that
is held for hours is defined by a self-locking screw, a hard stop or a
preloaded thread flank; the flexure only supplies the preload.
*Reason:* stress relaxation moves a spring-defined position, never a
stop-defined one (Handbook p. 7; Henein 2001). *Apply:* D Tr20x4 screw;
F screw + park stop; M5 thread flank + detent. *Check:* relaxation
budget: predicted set over life x flexure compliance -> position error
< 10 % of pointing budget.

**R7 No sliding fit and no thermal fight in the fold assembly.**
Thermal growth of the Al mirror (0.2 mm at 100 K) and of the yoke is
absorbed by the relief blade pair and must change the fold normal by
< 2 mrad over the -10..+120 C range and < 5 mrad in a 250 C fault soak.
*Reason:* the beam error is 2x the mirror error and the relay tolerates
5-10 mrad. *Check:* FE thermal case, steady plus the 10 K/min transient
at spot arrival.

**R8 Athermal geometry: a thermal centre on the optical reference.**
Mounts are symmetric about the point that must not move so uniform
temperature change produces growth about that point and no tilt (Hale
1999 6.3 thermal centre; Yoder/Vukobratovich athermal mounts).
*Apply:* D pitch axis within 20 mm of the CG, pivot pair symmetric on
the yoke; F remote centre in the face plane, pivots symmetric about it;
M5 three bipods at 120 deg with the free direction radial so the boss
circle grows about the facet vertex (0.003 mrad/K). *Check:* uniform
dT case: rotation about the reference = 0 within FE noise.

**R9 One relief direction per structural loop.** Every closed loop of
dissimilar materials (Al on steel, Ti on steel, glass/silver on Al)
has exactly one compliant direction that takes the CTE mismatch.
*Reason:* bonded dissimilar layers give 31-46 mrad at 40 K on an M5
facet (Timoshenko bimetal, m5_relay.md); a loop without relief becomes
a redundant constraint (R1) as soon as temperature changes. *Apply:*
D Al yoke on steel leaves, 0.04 deg per 30 K drift accepted; F axial
relief pair; M5 monolithic Al facet, radial-free feet. *Check:* loop
inventory table: material, length, dT, relief element, residual stress.

**R10 Flexures in tension, or buckling SF >= 3.** Blades and wires are
arranged so the load path is tension; any blade that can see
compression has a linear-buckling SF >= 3 at survival load and a
nonlinear check with 1 mrad of clamp misalignment imposed. *Reason:*
the LAFP lesson: a 1 mrad flange misalignment warped a blade into a
bistable buckled mode that cracked under vibration (Spanoudakis 2019).
*Apply:* D leaves 1.1 kN vs 8.9 kN critical (SF 8); F blades at
gravity preload; M5 legs 10 N vs 129 N (SF 13), rod in tension.

**R11 Support stiffness ratio and modes.** Stiff/compliant direction
ratio >= 1000; first mode >= 5x the highest disturbance frequency and
>= 3x controller bandwidth. *Reason:* parasitic motion under wind and
gust is the compliant direction leaking (Smith 2000 ch. 4). *Apply:*
D pitch mode vs 0.1-2 Hz gust, eddy damper; F 5.5 Nm/rad pivot with
7.5 kg at r 20 mm: pendulum mode ~1 Hz - hood shields wind; M5 6400
ratio, 300-900 Hz. *Check:* modal FE with the gust spectrum.

**R12 Stored-energy safe state, no power, no electronics.** Each
actuated DoF has a gravity or spring return to a defined safe geometry
that needs no power, no lubricant and no controller; return-torque
margin >= 2 at worst case (ECSS motorisation rule applied to the
return). *Apply:* D vents normally open, brake spring-applied; F
gravity + flexure preload to the 42.5 deg park, 0.9 Nm net vs
0.3 Nm wind; M5 nothing moves, preload spring 40 N vs 5 N. *Check:*
free-body at every position of the range with friction x 3.

**R13 Release ordering.** Protective elements trip in a fixed order,
each at a level below the damage threshold of the next; reversible
before one-shot; passive before active; the last element is geometric.
See section C. *Check:* a written ladder per structure with trip
levels, reset method and the state left.

**R14 No single-point failure on beam confinement.** Two independent
release paths (F: solenoid pawl and bimetal snap disc; D: bistable wind
trip and normally-open vents) plus a passive geometric confinement
(F hood and park angle keep 300 suns inside the fenced volume for every
`el_b`). *Reason:* ECSS-E-ST-33-01C and NASA-STD-5017 single-failure
tolerance for hazardous functions. *Check:* FMEA: every single failure
still ends in the dumped state.

**R15 Beam-walk envelope contains no flexure.** The volume swept by the
spot during 10 min of loss of tracking (23 mm/min walk, 3.6 MJ) holds
only sacrificial or ceramic surfaces (IFB, alumina, Inconel sheet);
every flexure lies outside it. *Reason:* a 1.4 kg Ti pivot block under
150 kW/m2 absorbed would heat ~4 K/s. *Apply:* F pivots behind the hood
rim; the receiver at F; D and M5 see <= 5 kW/m2. *Check:* ray-trace of
the walk cone against the CAD.

**R16 Surface integrity of fatigue-critical blades.** Wire-EDM recast
removed (>= 0.05 mm, etch or polish), root fillets >= 2t, Kt <= 1.5,
no sheared or stamped edges, no scratches across the blade root.
*Reason:* fatigue limit of Ti-6Al-4V drops ~40 % with an EDM recast
layer; the memo already takes 300 MPa not 500. *Check:* process sheet
and a coupon fatigue test per batch.

**R17 Monolithic interfaces.** Pivot blades and their clamps are one
wire-EDM part where possible; bolted blade clamps only with ground
pads, angular error <= 0.1 mrad, torque-controlled. *Reason:* the LAFP
failure (R10). *Apply:* F 90 x 90 x 40 Ti blocks; D 300 mm leaves in
bolted clamps - the exception, so pad flatness is specified; M5 folded
blank per foot.

**R18 No polymer, elastomer or lubricant in a load path.** Damping is
eddy-current or structural; the polymers that remain (PET film, PEEK
nut) are listed with their temperature limit and are outside the
flexure loop. *Reason:* UV, heat and creep. *Apply:* D PET film Tg
~75 C is the dish's weakest element and fixes its release order; F PEEK
nut <= 250 C, outside the optical loop; M5 none.

**R19 No aluminium alloy in a cyclic flexure.** Al has no endurance
limit and 6061-T6 loses ~60 % of its yield after 1000 h at 200 C. Al is
used only for the mirror substrate and the monolithic facet shell.

**R20 Corrosion and dust.** Flexure materials are passive (Ti, PH or
austenitic stainless, Co-Cr alloys); galvanic couples (Al facet on
steel foot, Ti on steel) get an isolating washer or anodised
interface; no upward-facing pocket at a blade root; drain holes at
every low point; the pit has a sump. *Check:* galvanic table and a
salt-fog coupon for the pit parts.

**R21 Actuator margins.** Motorised DoF: torque/force margin >= 2 at
beginning of life with friction x 3 where unmeasured, spring x 1.2,
inertia x 1.1 (ECSS-E-ST-33-01C 4.7.4, NASA-STD-5017); self-locking
screws SF >= 1.5 against back-driving at survival load. *Apply:* D
Tr20x4 on the 0.8 m lever at 2.6 kNm; F 0.03 Nm screw torque vs
3.6 Nm hold; M5 M6x1 detent under 49 N.

**R22 Pointing error budget by RSS.** Each error source <= 1/3 of the
allocation; the sum is RSS (Slocum 1992 ch. 2). *Apply:* D 0.3 deg
hold: cable 0.076 deg/kN, rail 0.03, thermal 0.04; F 2.5 mrad: thermal
2, relaxation 0.25, screw 0.06; M5 10 mrad RSS 6.1 in the memo.

**R23 Verification-by-analysis before build.** Each stage passes the
analysis set of section D, and the first article is measured for
stiffness, centre shift and return torque before any second article.

## B. Material selection for flexures by zone

Values are typical handbook/data-sheet figures (annealed Ti-6Al-4V;
STA Inconel 718; CH900 17-7PH; cold-worked + aged Elgiloy); all to be
confirmed by the supplier certificate. sigma_y(T) at the zone's design
temperature; sigma_e = fully reversed endurance limit, smooth, RT.

| Zone / design T | Material | sigma_y RT / at T (MPa) | sigma_e (MPa) | Relaxation onset | CTE (ppm/K) | E (GPa) | Allowed working stress | Use here |
|---|---|---|---|---|---|---|---|---|
| Ambient outdoor, -10..+80 C (D) | 17-7PH CH900 | 1580 / 1500 | ~600 | >= 260 C | 11.0 | 200 | 0.30 sigma_y; sigma_a <= 400 | pitch leaves, bistable arch |
| | 301/302 CW stainless | 900-1300 / same | ~450 | >= 200 C | 17 | 190 | 0.30 sigma_y | parallelogram roller blades, preload springs |
| | S355 galvanised | 355 / 355 | ~180 welded | n/a | 12 | 210 | LCF-safe at 0.4 | rim ring (730 cycles/yr) |
| | Ti-6Al-4V | 880 / 830 | ~500 (300 after EDM) | >= 300 C | 8.8 | 114 | 0.30 sigma_y | alternative leaves if the yoke goes Ti |
| Post top, flexures <= 120 C, 250 C fault (F) | Ti-6Al-4V | 880 / 760 (120 C), 620 (300 C) | 500 (300 after EDM) | 300 C; ~5 % set at 300 C/1000 h | 8.8 | 114 | 0.25 sigma_y(T_fault) | cross-axis pivots, pushrod necks |
| | Inconel 718 STA | 1035 / 1000 (300 C), 900 (650 C) | ~500 | 600-650 C | 13.0 | 200 | 0.30 sigma_y(T) | upgrade if the fault soak exceeds 250 C; snap-disc spring |
| | Elgiloy (Co-Cr-Ni) | 1700 / 1500 (400 C) | ~700 | 450 C | 12.4 | 190 | 0.30 sigma_y | pawl spring, bumper leaf |
| | Alumina 99.5 / Si3N4 | 350 / 800 flexural | no fatigue, slow crack growth | none to 1000 C | 8.1 / 3.2 | 370 / 310 | 1/5 of characteristic strength (Weibull) | standoffs inside the beam-walk envelope |
| Pit, 5-75 C, condensation (M5) | 17-7PH CH900 | 1580 / 1560 | ~600 | >= 260 C | 11.0 | 200 | 0.30 sigma_y | bipod legs, carriage blades |
| | 316 / A4 CW | 700-900 / same | ~350 | >= 200 C | 16 | 193 | 0.30 sigma_y | screws, brackets, feet blanks (lower strength, better in standing water) |
| | Ti-6Al-4V | 880 / 870 | 500 | >= 300 C | 8.8 | 114 | 0.30 sigma_y | if galvanic isolation from the Al facet fails |
| Excluded | 6061-T6 / 5083 | 276 / 110 after 1000 h at 200 C | none | 150 C | 23.6 | 69 | facet shell and substrate only | R19 |
| | Be-Cu C17200 | 1100 | 350 | 150 C | 17 | 130 | - | ambient only, not for the fold |

Property derating: use MMPDS/MIL-HDBK-5 curves for sigma_y(T);
sigma_e knockdown = surface x size x temperature x reliability
(Marin factors, Shigley), giving ~0.5-0.6 of the smooth value for a
2 mm EDM-cut blade.

## C. Fail-safe and release ordering

Principle (from space-mechanism practice): a mechanism that must be
safe unattended is designed with a *release ladder*. Each rung trips
at a level below the damage threshold of the next rung, reversible
rungs sit below one-shot rungs, passive rungs below powered ones, and
the bottom rung is a geometry (a park angle, a flat membrane, a held
facet) that cannot be lost. Examples: launch locks are hold-down and
release mechanisms whose frangible element (pyro bolt cutter, SMA
Frangibolt, split-spool NEA) is the only thing designed to break, and
the released appendage goes to a spring-defined bistable stow;
fire-damper fusible links (UL 33: 74, 100, 141 C ratings) are the
canonical one-shot thermal release; bimetal snap discs are the
reversible thermal rung; Howell's bistable compliant beams give the
hysteresis band (D's 9/7 m/s) with no electronics.

| Event | Dish (D) | Fold (F) | Relay (M5) | Safe state |
|---|---|---|---|---|
| Power loss | vents normally open: membrane flat in ~2 min; drum brake spring-applied; pitch screw self-locks | solenoid pawl drops within 1 s; gravity + preload to 42.5 deg park | nothing moves; preload springs hold | no focus; beam in the fenced dump; facets held |
| Over-wind | 1: bistable trip vents (9 m/s, passive) 2: controller latches pitch neutral 3: stow latch offloads leaves 4: hard stops carry 25 m/s | hood limits wind torque to 0.3 Nm; park stop carries it | hatch closes by gravity; preload holds to 47 m/s | dumped, latched, stops loaded, blades unloaded |
| Over-temperature | film (PET, ~75 C) is the weakest element: vent before 70 C film by a snap disc on the rim; ring and leaves unaffected | 1: coating alarm (electronic) 2: snap disc 200 C in the pawl circuit (reversible) 3: fusible link (one-shot, ~140 C rating in the hood frame) opens the pawl 4: hood and park geometry (passive) | facets see <= 5 kW/m2; beam-walk cone lands on IFB, not on a foot | beam parked, flexures never above 0.25 sigma_y(T_fault) |
| Loss of tracking / spot walk | dump within 2 min by vent | 10 min envelope holds only IFB and ceramic (R15) | not in envelope | same |
| Controller fault | trip and vents work without it | pawl needs power AND a command to re-arm | none | deliberate re-arm only |

Order of yielding under an unforeseen overload: stops and latches take
the load (SF 1.5 on yield), the sacrificial bumper leaf (Elgiloy)
deforms next, the pushrod necks (F) or tow-wire limiter (D) yield
before any pivot blade, and the pivot blades are the last elements to
reach yield. Check: the load-path table lists each element's yield
load in ascending order and the mechanism state after each.

## D. Verification-by-analysis practice

1. Constraint: screw-algebra rank of every stage (done in `fact/`),
   plus over-constraint search by removing one flexure and checking
   the mobility count.
2. Pseudo-rigid-body model first (Howell ch. 5; Handbook appendix) for
   stiffness, stress and centre shift; then geometrically nonlinear FE
   at five positions across the range x three thermal cases (uniform
   +100 K, worst gradient, fault soak) x two load cases (working,
   survival with stops engaged). Mesh converged at fillets (Kt).
3. Fatigue: load spectrum from a Kaimal/von Karman gust spectrum
   rainflow-counted, Goodman with Marin knockdowns, SF 1.5 on
   sigma_a for infinite life; 4x life test of finite-life items.
4. Buckling: linear eigenvalue SF >= 3, nonlinear with 1 mrad clamp
   misalignment imposed.
5. Relaxation/creep: hold-time histogram over life at temperature,
   supplier relaxation curves or Larson-Miller, predicted set through
   the stage compliance -> position error vs budget.
6. Thermal: thermal-centre check (uniform dT gives zero rotation about
   the reference), loop inventory (R9), transient at spot arrival.
7. Modal: first mode vs gust and controller bandwidth; damping source
   named.
8. Margins: motorisation and return-torque margins with ECSS factors;
   back-drive check on self-locking screws.
9. FMEA on the release ladder: every single failure still ends in the
   dumped state.
10. First-article test: stiffness, centre shift, return torque, hot
    soak at the fault temperature followed by a re-measurement.

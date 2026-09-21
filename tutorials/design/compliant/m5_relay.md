# M5 relay mirror: compliant facet mounts, adjusters and athermalisation

Design memo, 2026-09-04. Scope: the mechanical side of the M5 ellipsoidal
relay of the Hashemi-frame tandoor machine (`tutorials/tandoor_hashemi_env.py`,
M5 construction lines 760-795, acceptance test line 333). Reference:
Howell, Magleby, Olsen, *Handbook of Compliant Mechanisms* (Wiley 2013).
Only the table of contents, the PRBM appendix listing and Chapter 1 were
available; citations below are ToC pointers (section, book page) and the
mechanics are supplied from my own knowledge, marked "(own)".

**Design stance (the user's framing).** Nuclear safety/arming ("set-off")
mechanisms are compliant mechanisms for a reason: no lubricant, no wear, no
backlash, one deterministic state in a hostile environment. M5 lives in a
sealed, dusty, occasionally wet pit for 20+ years with only a hex key on
site, so it gets the same class of design: monolithic flexures wherever a
flexure can do the job, no bearings, no screws-in-slots, athermal by
geometry. One rule follows from Chapter 1's warning on stress relaxation
(book p.7): a flexure held strained at temperature slowly forgets its
shape, so **no flexure defines a position here**. Positions are defined by
hard metal contacts (screw flank, ball tip); flexures only guide and
absorb, at low stress; polymers and adhesives stay out of the load path.

## 1. Functions and requirements

Geometry from the code: waist fW = (1.25, 0, 4.60), duct centre
fT = (0.42, 0, 0.14), patch vertex V0 = (1.25, 0, -0.10); ellipsoid
A = 2.78 m, B = 1.61 m; patch radius 1.11 m (3.9 m2), acceptance 1.5 r_m5.
Per-facet values from `m5_relay_geometry.py` beside this memo:

| quantity | value across the patch |
|---|---|
| incidence angle | 0-50 deg (37 deg at V0); surface tilt to horizontal 11-61 deg |
| conjugates s1 (waist) / s2 (duct) | 4.0-5.1 m / 0.51-1.6 m; demagnification 2.5-10x (5.4x at V0; the "3x" figure is the earlier 4.6/1.4 m layout) |
| principal radii R_t (plane of incidence) / R_s | 0.93-3.7 m / 0.93-1.5 m (1.83/1.17 m at V0); R_t/R_s = 1/cos^2 i |
| facet count and size | 43 facets: 0.32 m across-flats hexagons (0.089 m2) tile the circle in exactly 43; 0.30 m squares give 45. Design for 0.30-0.32 m, ~0.5 kg each (1.5 mm Al) |
| radius families | 15 (hex) / 16 (square) (R_t, R_s) pairs at +-5% binning, ~8 at +-10% |
| sensitivity: 1 mrad facet tilt | 1.7-3.6 mm spot shift at the duct (2 s2); duct radius 200 mm |
| sensitivity: 1 mm facet piston | 1.2 mm ray shift (2 sin i): optically loose; matters only for edge steps |
| whole-patch shift delta | image shifts 0.8-1.2 delta; a waist shift moves the image only 0.18 delta |

| requirement | number | basis |
|---|---|---|
| facet slope error, total | <= 10 mrad RMS (96% duct throughput, project verdict) | budget: forming 5, mount hold + alignment 3, thermal 1, gravity/wind 1, frame 1 -> RSS 6.1 |
| **a single-curvature strip cannot meet this** | flat along one axis over 0.30 m: 42-160 mrad edge slope, 25-93 mrad RMS | facets must be doubly curved (toroidal, two radii); strips would have to be 30-120 mm wide |
| facet radius accuracy | +-5% on each radius | 10% error = 8-16 mrad edge slope |
| tilt adjustment range / resolution | +-30 mrad / <= 0.5 mrad per step | range covers frame build (+-10) + forming mean slope (+-10) + margin |
| piston range / accuracy | +-4.5 mm / +-1 mm | edge steps at 50 deg incidence shade 1.2 mm per mm of step |
| hold over life | tilt drift < 2 mrad over 20 y, no backlash, no creep | 7300 daily thermal cycles, ~100 adjustment cycles |
| whole-patch position vs fW and fT | +-5 mm, tilt +-2 mrad; global correction range +-10 mrad, +-12 mm | settlement of pit vs tower/pot footing |
| thermal cycle | facet 5-75 C (daily 30 K typ, 40 K max); frame 20 K; facet-frame differential <= 15 K; seasonal 50 K | absorbed 5% of 1-5 kW/m2 = 50-250 W/m2 at h ~ 12 W/m2K -> 4-21 K over pit air |
| loads | facet weight 5 N; wind with the hatch open at 20/30 m/s: 22/49 N per facet, 0.9/2.1 kN on the patch; wiping 50 N; sealed pit: none | q = 0.6 v^2 |
| environment, life | dust, condensation, occasional standing water, 20+ y, hex key only | corrosion-resistant metals only |

## 2. Candidate compliant topologies

| need | candidate (handbook pointer) | one-line reason / verdict |
|---|---|---|
| (a) facet mount, 3 dof | three "feet" each = bipod of two wire/strip flexures, apex on the facet: each foot constrains 2 translations (n, t), leaves radial r and all rotations free -> 3 feet = 6 constraints, exact (spatial positioning 12.2.8 p.230; compliance-ellipsoid reasoning 9.4.2 p.127; FACT constraint spaces 6.2.3 p.86) (own) | **selected**: exactly constrained, athermal by symmetry, identical parts x3, wires carry load axially (no buckling problem) |
| (a) | trefoil of three wide tangential blades with a notch hinge (small-length flexural pivot A.1.1 p.66) for in-plane rotation | rejected: a notch thin enough to take 30 mrad at < 400 MPa buckles under 2 N; without the notch, imposed tilts stress the blades to > 1 GPa |
| (a) | FACT flexure ball joint at facet centre + two edge pushers (6.3.1 p.87) | rejected: three unlike parts, the edge pushers need their own radial compliance, no gravity symmetry |
| (a) | compliant gimbal of two cross-axis / cartwheel pivots (A.1.10 p.74, A.1.11 p.76) + piston stage | rejected: built for +-5-10 deg, we need +-1.7 deg plus piston |
| (b) adjuster | M6x1 screw on a parallel-motion carriage (12.2.4 p.214; fixed-guided beam A.1.4 p.69), 24-click compliant detent (ratchet 12.2.10 p.237) | **selected**: 0.28 mrad/click, +-30 mrad, screw is the latch |
| (b) | stroke-amplification lever run backwards as a 2:1 reducer (12.2.7 p.227) | fallback: clicks are already 7x finer than the 2 mrad alignment target |
| (b) | differential screw M6x1/M5x0.8 | fallback: 0.056 mrad/click, more parts |
| (b) latch | bistable latch (12.2.11 p.241) or wedge clamp | rejected: a clamp moves the setting; preloaded thread flank + detent holds without creep |
| (c) athermal | radial-compliant feet at 120 deg (the bipod's free direction is r): facet expansion absorbed with zero tilt (own) | **selected** |
| (c) | monolithic aluminium facet, no bonded dissimilar layers | **selected**: bonded Al/steel facet = 31-46 mrad at 40 K (Timoshenko, own) |
| (c) | electroformed nickel facets on a steel frame (alpha matched) | alternative if imported; expensive |
| (c) | constant-force preload (12.3.3 p.262); damping (12.3.5 p.267) | neither needed: thermal stroke 0.03 mm on an 8 mm spring; facet modes > 300 Hz vs wind < 1 Hz |
| (d) global steer | three large feet of the same pattern (blade + M20 jack), tip/tilt/piston of the whole frame | **selected**: 3 screws instead of 43x3 after settlement |
| (d) | single cartwheel hinge (A.1.11) about y with a lever drive | rejected: settlement needs both axes and piston |

## 3. Selected designs

### 3.1 Facet (43 off)

1.5 mm anodised/PVD aluminium mirror sheet (Alanod MIRO-SUN class,
solar reflectance 0.90-0.95, alpha 23e-6/K, E 69 GPa), press-formed to a
toroid (R_t, R_s) from the family table (`m5_relay_geometry.py`), 0.30 m square or 0.32 m hex,
sag 3-12 mm. Back: a riveted aluminium "Y" rib (15x15x1.5 angle) ending
in three bosses at r_s = 100 mm, 120 deg apart, each boss a ring around
an 8 mm hole through the mirror (tool access, 0.17% area). Same alloy
throughout: uniform heating scales the facet without changing slopes
(0.003 mrad/K). Facet-to-facet gap 3-4 mm: fill factor 0.975-0.98.

### 3.2 Foot (129 off): one folded flexure blank per foot

Coordinates per foot: n facet normal, t tangential, r radial (from the
facet centre). Load path facet -> bipod -> carriage -> screw tip -> bracket.

| element | geometry | PRBM / mechanics (own; small-deflection beam theory agrees with the PRBM within 4%) | numbers |
|---|---|---|---|
| bipod legs (x2) | strips 2.5 x 0.5 x 40 mm at +-35 deg to n in the (n,t) plane, thin direction r, apex at the boss | axial EA/L; free directions by bending 12EI/L^3; buckling 4 pi^2 EI/L^2 | 6.3 MN/m per leg -> 8.4 MN/m along n, 4.1 MN/m along t; 1.0 kN/m along r (ratio 6400); buckling 129 N/leg vs 10 N max load |
| bipod leg stress at imposed facet tilt | end rotation th, clamped-clamped: sigma = 2E(b/2)th/L | | 62 MPa at 5 mrad, 125 at 10, 375 at 30 (full range); out-of-plane 12-75 MPa |
| carriage (parallel-motion stage, A.1.4 / 12.2.4) | two blades 12 x 0.5 x 60 mm, thin direction n, length along r | k = 12EI/L^3 per blade (PRBM 4 K_theta/gamma EI/L^3: 1.44 vs 1.39 kN/m); sigma = 3Etd/L^2; parasitic 0.6 d^2/L along r, absorbed by the bipod | 2.8 kN/m pair; 62 MPa at 0.75 mm, 375 MPa at 4.5 mm; parasitic 0.2 mm max; in-plane 1.6 MN/m |
| screw | M6x1 A4 stainless in a brass nut pressed into the carriage; hardened ball tip on a hardened stainless pad on the bracket; head with 4 mm hex socket, reached through the facet hole | tilt = d/(1.5 r_s) = 6.7 mrad/mm | 30 deg = 0.083 mm = 0.56 mrad; 24-tooth detent: 0.28 mrad/click; +-4.5 mm = +-30 mrad |
| preload | 302 stainless tension spring carriage-to-bracket, 40 N at 8 mm | holds contact against 1.3 kPa suction = 47 m/s on an open pit; 1 g shock = 5 N | force only: spring relaxation cannot move the facet |
| thermal (facet 15 K over frame) | facet boss circle grows 0.017-0.035 mm relative to steel | radial bending of the legs | 6.6 MPa, 0.07 N: no tilt by 120 deg symmetry |
| resonances (0.5 kg facet) | | | ~900 Hz piston, ~300 Hz in-plane, shell drum mode 250-400 Hz |

Blank: one thickness, 0.5 mm 301 full-hard (or 17-7PH CH900) stainless,
laser-cut, two 90 deg folds in the rigid regions only (3t radius), none
in a flexure. Yield 1.0-1.5 GPa: the worst permanent stress (375 MPa at
full range) is <= 35% of yield, the typical one (< 125 MPa) < 12%, so the
relaxation concern of p.7 is met at 75 C, and the daily 7 MPa thermal
cycle is infinite-life.

### 3.3 Adjuster and latch

Tilt about the axis through feet B, C: turn screw A; piston: all three
equally. The thread flanks are loaded one way by the 40 N preload (no
backlash); the detent (stamped 24-tooth spring-steel star washer on a
serrated collar, ~0.1 N m) cannot be turned by anything in a pit; a
push-in stainless cap closes the mirror hole. Screw thermal mismatch (A4
vs steel over 20 mm): 2.4 um per 30 K. No threadlocker, no lubricant;
the brass nut prevents stainless galling.

### 3.4 Athermalisation, per degree

| mechanism | facet tilt per K | daily (30-40 K) |
|---|---|---|
| monolithic Al facet, uniform dT | 0.003 mrad/K | 0.1 mrad |
| foot kinematics (5 K between feet over 45 mm of steel) | 0.02 mrad total | 0.02 mrad |
| frame front-back gradient (100 mm section, 5 K) | 0.13 mrad/K at the rim | 0.66 mrad |
| **bonded 1 mm Al mirror on 1 mm steel** (not allowed) | 1.15 mrad/K | 46 mrad |
| 4 mm glass mirror on 1.5 mm Al (not allowed) | 0.48 mrad/K | 19 mrad |
| 0.1 mm silvered polymer film on 1.5 / 2.0 mm Al (fallback only) | 0.10 / 0.06 mrad/K | 4.0 / 2.2 mrad |

The material pairing is therefore: aluminium facet, stainless flexures,
galvanised-steel frame, brass nuts; the alpha mismatch between facet and
frame (11e-6/K) is absorbed by the feet's radial compliance, the mismatch
between frame and masonry (2e-6/K) by the three global feet.

### 3.5 Global fine-steer

Welded 40x40x3 RHS galvanised frame (~110 kg + 22 kg facets) on three
feet at r_s = 0.8 m: blade 3 x 60 x 80 mm (thin direction radial from the
frame centroid; 167 kN buckling, 0.07 mm radial mismatch = 20 MPa) +
M20x2.5 A4 jack in a bronze nut + a 1.5 kN Belleville tie-down.
30 deg = 0.21 mm = 0.17 mrad = 0.3 mm image shift; +-12 mm = +-10 mrad =
+-17 mm at the duct. This is where settlement is taken out before any
facet is touched.

### 3.6 Manufacturing (village level)

- Bracket positions: the ellipsoid is a surface of revolution about the
  fW-fT line, so a wooden sweep template (elliptical arc A = 2.78,
  B = 1.61 m) pivoted on a bar along that line sets all 129 bracket seats
  to +-3 mm / +-5 mrad; tack, check, weld, then hot-dip galvanise.
- Facet dies: 15-16 toroidal plaster/concrete dies swept with a two-radius
  arc jig; facets formed on a 20 t shop press with a rubber pad (strain
  0.3-0.5%, mirror face protected by its peel film), spring-back
  calibrated on the first die with a 240 mm three-leg sag gauge
  (sag 3.9-12 mm, +-0.3 mm = +-5% radius). Each facet carries its cell
  label; clocking of the toroid axes to +-5 deg is enough.
- Feet: one laser-cut blank folded in a fixture; springs, screws, nuts
  and detent washers are catalogue parts; 10% spares.

### 3.7 Alignment on site (10 min per facet)

1. Frame in the pit on its three feet at mid-range; facets installed by
   cell label; piston set with a straightedge across neighbours (+-1 mm).
2. A 3 mm LED at the waist point (permanent lamp port with a locating
   sleeve on the tube at z = 4.6 m) and a translucent bull's-eye at the
   duct centre. A lamp placement error of 10 mm moves images 1.8 mm.
3. Cover all facets but one; turn its screws by counted clicks until its
   image sits on the bull's-eye (1 click = 0.5-0.9 mm there). Record the
   counts: the log book is the machine's state.
4. Uncover all: the composite spot should be a centred blob <= 50 mm;
   if the centroid is off, steer the frame (3.5), not the facets.
5. Verify at dawn with the dish at its lowest pressure level, watching
   the duct lip with an IR thermometer. Re-check yearly with the lamp;
   normally only the global feet move.

## 4. What to add to the simulation

The trace treats M5 as a perfect ellipsoid; the facets cost a few
percent and the model should say how many. Everything below is a normal
perturbation at the M5 hit `h2`, cheap enough for the fused kernel:

| effect | model | magnitude (as-built / aged) |
|---|---|---|
| per-facet tilt | facet index from (u,v) = ((h2-V0).e_t, (h2-V0).e_s) on a 0.30 m grid; per-facet 2-vector, resampled per episode | N(0, 3 mrad) per axis / N(0, 5) |
| per-facet radius error | slope error growing linearly from the facet centre: dn = (dk_t u_loc, dk_s v_loc) | dk = N(0, 0.05/R) / 0.07/R (+-5% families, spring-back) |
| surface waviness | Gaussian slope noise per ray | 2 mrad RMS / 3 |
| fill factor | rays within 2 mm of a cell edge lost; 3 holes of 8 mm per facet | 0.975 (square, 4 mm gap) or 0.98 (hex); -0.2% holes |
| thermal drift | correlated radial tilt pattern proportional to the frame gradient, daily sinusoid | 0.66 mrad amplitude at the rim; a what-if of 1.15 mrad/K reproduces a bonded facet |
| global patch | tilt N(0, 1 mrad), shift N(0, 3 mm); settlement as a slow ramp to 10 mm | what the global feet remove |
| soiling | reflectance 0.95 -> 0.90 between cleanings | dust in a pit |
| duct acceptance | line 347 tests position only; near-vertex facets (u < -0.5 m, s2 = 0.5 m) enter the horizontal duct at ~78 deg to its axis | add an angular cutoff or a wall bounce; measure the real duct depth |

Expected result: 10 mrad RMS gave 96% in the project's own check, so the
as-built column should cost 3-5% (mostly fill factor), the number to weigh
against the m5_scale and duct-radius levers.

## 5. Risks and open questions

1. **Facet forming is the critical path**, not the mount: 15-16 families,
   spring-back unmeasured. Test plan: three facets on one die, sag gauge,
   then the lamp test on a mock frame before cutting the other dies.
2. The 43-facet count is a tiling choice: hexagons give 43 and better
   fill; squares give 45 and simpler dies. Decide before the frame.
3. Near-vertex facets (u <= -0.6 m) work at near-normal incidence, 0.5 m
   from a horizontal duct; if the duct vignettes them, drop 3-5 facets
   (they are also the ones with the tightest radii, 0.93 m).
4. Hatch-open wind: the 40 N preload covers 47 m/s, the 1.5 kN
   tie-downs 30 m/s, both assuming the hatch is the only opening.
5. Standing water at the bottom of the pit reaches the lowest facets
   (z = -0.36 m): drain before anything else; galvanic contact Al/steel is
   broken by the stainless flexure but wet dust is an electrolyte.
6. Silvered/PVD aluminium mirror sheet is an import; local polishing
   would give ~0.85 reflectance (the trace assumes 0.95).
7. The lamp port at the waist is a hole in a 300-sun bore: it needs a
   metal bayonet plug.
8. Not measured: pit air temperature (assumed 10-20 K over ambient),
   reflectance after 10 y of wiping, and the feel of a preloaded ball tip
   under adjustment (a 4 mm ball on a hardened pad is the usual cure).

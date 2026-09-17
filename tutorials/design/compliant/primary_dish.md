# Primary dish: compliant mechanisms (design memo)

**Scope.** The pumped-membrane primary (a = 2.10 m, 13.85 m², 50 µm silvered
PET, pretension T = 2000 N/m) on Hashemi's fixed-focus carriage
(`fixed-focus-ir.pdf` figs 6-7, 14-17: dish + arc-rail segment on four
bearings, elevation by a tow-wire loop over a motor drum, azimuth by a rubber
roller on a ring rail, dish attitude a *static* threaded-rod setting).
Placement law (`tandoor_mount_batch.py`): `Cd = P_fold − g·ub`, dish axis
`naim ∝ u + ub`, so the dish must be pitched by **β/2** about the horizontal
axis normal to the arc plane - the degree of freedom the carriage lacks.

**Stance (the user's framing).** Nuclear safety/arming ("set-off") devices are
compliant because a flexure has no lubricant, no wear, no backlash and one
deterministic unpowered state. A machine on a village roof for decades -
dusty, rained on, thermally cycled - wants exactly that: monolithic metal
flexures wherever the stroke allows, rolling contact only where the stroke is
metres (the two rails), and a fail-safe that needs no electronics. Handbook
p. 7 (stress relaxation) rules out polymer flexures for any *held* position;
p. 8-10 (stiffness ≠ strength; flexibility from geometry and boundary
conditions) is the method throughout.

**Sources.** Handbook citations are ToC pointers (section, page); the library
entries were not in the excerpt, so the mechanics (PRBM, ring, buckling,
Goodman) are my own, marked *(own)*. Machine numbers: `tandoor_hashemi_env.py`,
`tandoor_rl_env.py`, `03_membrane_beamdown_tandoor.py`, `fvk2d_answers.py`.

## 1. Functions and requirements

Environment: outdoors, −5 to +60 °C metal temperature, dust, rain, UV,
30-year life; the primary is not hot. Wind in code: q = 0.6 v² Pa, diurnal
base 2.5-6 m/s plus OU gusts (σ 1.8 m/s), stow above 9 m/s, reset at 7.
Assembly mass 50 kg bare (ring 38, films 2, hub ~10) to ~140 kg with a
20 mm jam bed (6 kg/m²).

| # | Function | Range / stroke | Rate | Accuracy | Loads | Cycles | Notes |
|---|---|---|---|---|---|---|---|
| F1 | Pitch by β/2 about the arc-normal axis | ±18° (β_dev = 36 in `hashemi.ini`; ±10° covers β = 20) | ≤ 0.02°/s slaved to the schedule; the winter seam (el ≈ 40-48°) jumps up to 18° | 0.1° (share of the 0.3° hold) | wind moment ≈ 0.2·a·F: 0.34 kNm @ 9 m/s, 0.94 @ 15, 2.6 @ 25 (survival); gravity ≤ 30 Nm with the axis within 20 mm of the CG | ~730 sweeps/yr; 10⁷ gust micro-cycles/yr | a static per-season setting is acceptable |
| F2 | Toroid the figure against off-axis astigmatism (one squeeze DoF) | rim axis ratio a/b = 1/cos(β/2): 1.5 % @ 10°, 5.2 % @ 18° | slaved to F1 | 0.2 % ellipticity (≈ astigmatism of 4°) | hoop 4.2 kN from the film pull; axial pressure load p·A 2.8 kN (f 9.77) to 9.2 kN (f 3) | as F1 | uncorrected blur radius a·θ²/2: 32 mm @ 10°, 104 mm @ 18° |
| F3 | Elevation travel on the arc | 76°: 6.6 m at g = 5 m, 4 m at g = 3 | 0.025°/s = 2.2 mm/s | 0.3° hold; encoder noise 0.03° | tangential m·g·cos(el_b) ≤ 1.4 kN + wind ≤ 2.2 kN | 4.8 km/yr; rollers 2×10⁴ rev/yr | rolling stays; suspend and preload it |
| F4 | Azimuth on the ring rail | 180°/day | 0.035°/s | 0.3° | yaw ≈ 0.5·a·F: 0.85 kNm @ 9, 2.4 @ 15 m/s | 5 km/yr | friction drive = torque limiter |
| F5 | Gust rejection | jitter ≤ 0.1° rms at 6-9 m/s | 0.1-2 Hz | - | ΔF(6→9 m/s) = 0.75 kN | 10⁷/yr | contactless damping |
| F6 | Fail-safe: dump the beam, hold/stow | trip 9 m/s, reset 7; power loss → dump in 2 min | - | - | survival 25 m/s: 6.2 kN | ~10³ stows/yr | no electronics in the loop |
| F7 | Focus / jam (existing) | 7 levels 0.62-1.10 p₀; jam/release | - | - | - | few/day | interacts with F2, F6 |

## 2. Candidate compliant topologies

| Function | Candidates (Handbook section, page) | Reason | Pick |
|---|---|---|---|
| F1 pivot | A.1.10 cross-axis flexural pivot (p. 74); A.1.11 cartwheel (p. 76); 11.1.2 revolute elements incl. split-tube/torsion (p. 161); 12.2.2 rotational (p. 204) | cross-axis: largest clean rotation with in-plane load capacity; cartwheel concentrates stress at its hub over 36°; split tube warps under transverse load | **cross-axis pivot pair** |
| F1 hold/set | A.1.1 small-length pivot as PRBM (p. 66); 12.3.3 constant force (p. 262); 12.2.11 latch (p. 241) | the pivot's return moment preloads a self-locking screw, so thread play is moot | offset-neutral pivot + Tr screw + stow latch |
| F2 squeeze | A.1.6 initially curved beam (p. 70) - the ring *is* the flexure; 12.2.1 translational (p. 197); 12.2.4 parallel motion (p. 214) for the rim blades; 12.2.7 stroke amplification (p. 227) for a θ²-law crank; Ch. 6 FACT (p. 79) | a ring under one diametral load ovalises almost symmetrically (0.137 vs 0.149): one push makes the ellipse | **built-in ellipse + diametral screw**, four flexure attachments |
| F3 rollers | 12.2.4 parallelogram (p. 214); Ch. 3.4 case study (p. 38); A.1.4 fixed-guided beam (p. 69) | constant preload through rail waviness, zero play, no adjustment | **parallelogram per roller** |
| F3 tow wire | 12.3.3 constant force (p. 262); 12.3.1 energy storage (p. 245); 12.3.5 dampening (p. 267) | flat force caps cable load in gusts; contactless damping kills the pendulum mode | CF limiter + eddy damper |
| F6 trip | 12.3.2 stability/bistable (p. 252); 4.4.2 fixed-guided bistable beam (p. 49) | a snap-through arch has built-in hysteresis: the 9/7 m/s band for free | **bistable drag-plate trip** |
| F6 hold | 12.2.11 latch (p. 241); 12.2.10 ratchet (p. 237); 12.2.9 metamorphic (p. 233) | a latch changes the DoF set for survival: pitch locked, leaves offloaded | latch + spring-applied brake |

## 3. Selected designs

Leaf flexures: **17-7PH CH900 stainless** (E 204 GPa, σ_y ≈ 1500 MPa,
S_ut 1650, endurance derated to S_e ≈ 400 MPa, CTE 11 µm/m·K, no relaxation
below 100 °C; budget alternative 301 full-hard, σ_y ≈ 1200). Ring and yoke:
hot-dip-galvanised steel tube. Leaf edges polished; no crevices - dust is
harmless on an open leaf, lethal in a bearing.

### 3a. Pitch stage (F1): two cross-axis flexural pivots on a yoke

**Layout.** An aluminium spine (2.4 m) behind the dish, along the pitch axis,
carries the rim (3b). Two cross-axis pivots at ±0.8 m from the dish centre
join it to a U-yoke bolted where Hashemi's threaded rods were (fig. 16). Each
pivot: four leaves in two crossed planes, crossing at mid-length; the axis
passes through the assembly CG (ballast on the spine). Leaf **L = 300,
t = 2.0, w = 150 mm**; unstressed position at pitch −18°, so the range is
0-36° *from neutral* and the return moment never changes sign.

**PRBM** *(own; Jensen-Howell cross-axis model, symmetric crossing ≈ pure
bending)*: I = w t³/12 = 1.0×10⁻¹⁰ m⁴; K = n·EI/L (n = 4) = **272 Nm/rad
per pivot, 544 for the stage**; σ = E t Δθ/(2L); centre shift ≈ L Δθ²/12
(≤ 10 mm at 36°, harmless at f = 5-10 m).

| Quantity | Value |
|---|---|
| Return moment, both pivots, at 18° / 36° from neutral | 171 / 342 Nm - matches the 9 m/s wind moment, so the screw flank stays loaded most of the time |
| Leaf stress at 18° / 36° | 214 / 427 MPa, SF 3.5 on yield |
| Survival at 25 m/s and full tilt: 1.1 kN axial per leaf, P × (arc sag 24 mm) = 26 Nm on top of 43 Nm bending | 687 MPa, SF 2.2; leaf buckling P_cr = π²EI/(0.5L)² = 8.9 kN ≫ 1.1 kN |
| Fatigue, daily 0→36° sweep (R = 0, σ_a = σ_m = 214 MPa) | Goodman 214/400 + 214/1650 = 0.65 → SF 1.5 *against infinite life*; only 2×10⁴ cycles needed |
| Gust micro-cycles, Δθ ≈ 0.05° | σ_a < 1 MPa |

**Actuation.** Self-locking Tr20×4 screw between yoke and a 0.8 m lever on the
spine: 342 + 340 Nm (9 m/s) → 0.85 kN; 1.6 kN at 15 m/s. 0.29°/turn; 0.1 mm
thread play = 0.007°, 40× below budget - the flexure's value is deleting the
trunnion *bearing*, not the screw's play. Two builds, same hardware:
**static** - hand crank and locknut, set per season (the minimum answer to
the fold-shadow finding); **variable** - 24 V gearmotor following the env's
β schedule at ≤ 0.02°/s, 18° in ~15 min at the winter seam. The schedule
jumps there, so no cam on the arc can slave the pitch by linkage; it is
driven. **Sensing:** dual-axis MEMS inclinometer on the spine (0.01°,
absolute, blind to carriage errors) plus the beam-centroid sensor at the fold.

### 3b. Rim squeeze for astigmatism (F2): the ring as the flexure

**Physics** *(own; `fvk2d_answers.py` Q1 confirms it for the nonlinear
membrane)*: a membrane on an elliptical rim (semi-axes a > b) is a
two-curvature paraboloid with f_y/f_x = b²/a², whatever the tension
anisotropy. A sphere at half-angle θ = β/2 needs R_t/R_s = 1/cos²θ, i.e.
**a/b = 1/cos θ, long axis in the arc (tangential) plane**; the squeeze axis
is parallel to the pitch axis.

**The film sets the stroke, not the ring.** Inextensional ovalisation by
ellipticity ε changes the film tension by ±E t ε/(2(1+ν)) = ±0.36·E t·ε.
Pretension strain is only T/(E t) = 1.08 %, so the film slackens at ε = 3.0 %
and PET creeps above ~60 MPa. Therefore **build the rim as an ellipse at
ε₀ = 3.3 % (θ₀ = 14.5°) and squeeze ±1.5 % routinely (N_y ≥ 1000 N/m,
N_x ≤ 3000 N/m = 60 MPa), ±1.8 % at the limit**: that spans θ = 10-18°
(β = 20-36). Below β = 20 the dish is over-corrected by ≤ 1.8 %, the
astigmatism of θ ≈ 11°, which the 3× demagnifying relay already tolerates.
Full-range correction needs the fold toroid the code models
(`fold_toroid`): split the correction, do not ask the film for it.

**Ring.** Steel tube 60×2 mm, R = 2.1 m, EI = 30.7 kNm², 38 kg. Film pull
w = 2000 N/m → hoop 4.2 kN; buckling w_cr = 3EI/R³ = 9.9 kN/m, **SF 5**
(50×1.5 gives SF 2.2 at 24 kg - too close for a part that also sees gusts).
Diametral squeeze *(own; Roark)*: δ = 0.149 F R³/EI, perpendicular elongation
0.137 F R³/EI → 0.046 % ellipticity per mm.

| Sagittal-diameter squeeze | ±33 mm (ε ±1.5 %) | ±40 mm (ε ±1.8 %) |
|---|---|---|
| Force | 0.73 kN | 0.89 kN |
| Ring stress (M = 0.318 F R, + 18 MPa hoop) | 107 MPa | 128 MPa |
| Cycles | 730/yr; galvanised S355 (σ_y 355) SF 2.8, LCF-safe | |

**Rim-to-hub constraint (one DoF, FACT).** Four attachments at 0/90/180/270°.
Along the pitch axis two links: one carries the **Tr10×2 squeeze screw**, the
other is fixed (ring centre and focus shift δ/2 ≤ 20 mm - negligible against
r_fold ≈ 0.5 m). Along the tangential axis two **fixed-guided blades** (L 250,
t 1.2, w 120 mm), radially soft (k = 2.7 kN/m; ±15-20 mm → 176-235 MPa) and
axially stiff (> 100 kN for the 2.8-9.2 kN pressure load plus wind). The 45°
points, the mode's tangential antinodes, stay free; the plenum back film
seals to the ring by a skirt so nothing fights the squeeze.

**Slaving.** Required δ(θ) = 2.19·(1/cos θ − 1) − 72 mm. A crank on the pitch
trunnion, r(cos θ₀ − cos θ), matches to ±2 mm with r = 2.25 m; a stroke
amplifier (G = 4, r = 0.56 m) would push 2.9 kN, ≈ 0.5 kNm of coupling, into
the pitch stage. So the variable build **motorises the squeeze screw, slaved
in software** to the pitch command; the static build hand-sets both.
**Sensing:** ring strain gauge at the squeeze point (≈ 500 µε full scale) or a
scale on the screw. The same DoF nulls the ring's gravity ovalisation (17 mm
on two hangers, ≈ 4 mm on four) - the m = 2 "clamp astigmatism" flagged in
`fvk2d_cassegrain.py` - once the spot sensor closes the loop.

### 3c. Carriage rolling elements (F3-F5)

*Arc rail.* 6.6 m of travel cannot be a flexure; the honest replacement is a
**compliantly suspended roller**: each of Hashemi's four bearings becomes a
sealed polyurethane-tyred roller on a parallelogram (two fixed-guided blades,
L 150, t 1.5, w 80 mm): k = 24EI/L³ = 32.6 kN/m, preload 400 N at 12.3 mm
(σ_m 500 MPa), ±3 mm rail waviness → σ_a 122 MPa, Goodman 0.61 → SF 1.6 for
infinite life against 10⁵ cycles. No adjusting screws, no play; wipers ahead
of each roller.

*Tow wire.* **6 mm 7×19 galvanised** (k = EA/L ≈ 150 kN/m over 8 m): 1 kN
stretches 6.7 mm = 0.076° at g = 5 m; the 6→9 m/s gust (0.75 kN) gives 0.057°.
The pendulum mode (140 kg) sits at 5 Hz, quasi-static but undamped, so add a
**contactless eddy-current damper** on the drum (copper disc 200×6 mm between
eight NdFeB poles at 0.5 T ≈ 9 Nm·s/rad → ζ ≈ 0.1). Put the **elevation
encoder on the arc** (magnetic tape, read head on the sled), never on the
drum: static stretch (up to 0.3° with wind) then vanishes in closed loop. A
**constant-force limiter** (12.3.3) in the wire at 4 kN with 150 mm stroke
absorbs ~600 J and caps cable/drum loads; in 17-7PH leaves that is ~15 kg, so
a Belleville stack is the pragmatic substitute if mass matters.

*Ring rail.* Keep the friction roller, preloaded at 600 N by the same
parallelogram: traction 0.36 kN × 4.6 m = 1.65 kNm > 0.85 kNm at 9 m/s; slips
at ~12 m/s gusts - a torque limiter that loses the sun for a step instead of
a gearbox.

### 3d. Fail-safe (F6)

| Event | Beam | Dish | Element |
|---|---|---|---|
| Power loss | plenum **and jam-vacuum** vents open (normally-open valves); membrane relaxes toward flat, f = T/p → ∞: ~2 m³ through a 20 mm orifice ≈ 2 min, during which the beam walks 0.5° (4 cm at the fold) | drum brake spring-applied: holds; pitch screw self-locks | vent flaps as bistable arches (12.3.2), snapped closed by a solenoid pulse at start-up, released by a spring pin |
| Wind > 9 m/s, no electronics | same dump | same hold; a live controller drives pitch to neutral and sets the **stow latch** (12.2.11), offloading the leaves (SF 2.2 → > 5) | **bistable drag-plate trip**: 0.25 m² plate, drag 14.6 N @ 9 m/s, 8.8 N @ 7; cosine arch 17-7PH l 100, t 0.4, h 1.6 mm (Q = 4), w ≈ 8 mm, snap force ≈ 740 EIh/l³ ≈ 10 N *(own; Qiu-Lang-Slocum)* against a 5 N bias cantilever: trips ≈ 9, resets ≈ 7 m/s - the env's hysteresis is the arch's; peak strain 0.2 % (400 MPa, R = 0, 3×10⁴ cycles, Goodman 0.62) |
| Survival 25 m/s | dumped | held and latched | 6.2 kN goes through latch and yoke, not the leaves |

A jammed figure at power loss would keep ~300 suns walking off the fold at
0.004°/s: releasing the jam is part of the dump, not optional.

## 4. What to add to the simulation

| Effect | Where | Model / magnitude |
|---|---|---|
| Pitch DoF | mount solve | pitch = β_t/2 as now, with a 0.02°/s rate limit and a seam transit (18° in ~15 min, cosine tax while moving); static build: pitch constant per season, β_eff = 2·pitch |
| Pitch hysteresis | `_e_el` | ±0.007° step when the wind pitch moment (0.2·a·q·A·C_d) crosses the 342 Nm preload - negligible, keep as a flag |
| Thermal drift | boresight | slow 0.04° × (T_metal − T₀)/30 K (Al yoke vs steel leaf, 0.72 mrad): same order as the existing 0.035° tilt-flexure term |
| Cable stretch | `_e_el` | encoder on the drum: bias 0.076°/kN of tangential load (m g cos el_b + wind); on the arc: no static term, dynamic ±0.06° × (ΔF/0.75 kN), τ ≈ 0.3 s → white at dt = 15 s |
| Rail waviness | `_e_el`, `_e_az` | ±3 mm/5 m = ±0.03° periodic in position (replaces part of the 0.02° "backlash as rate noise") |
| Rim squeeze | optics | ε(t) = ε₀ + Δε tracking 1/cos(β/2) − 1 with a minutes-long lag (film viscoelasticity) and ±0.2 % setting error → residual astigmatism of θ_err ≈ 3.6°; replaces `fold_toroid` for β ≥ 20 |
| Pretension drift | plenum | steel ring vs PET: 28 N/m per 30 K = 1.4 % focal drift, insolation-correlated (the shape `p_dist` already has) |
| Trip statistics | wind/stow | keep 9/7 hysteresis; add ±0.5 m/s trip tolerance (bias drift) and a 30 s vent constant before DNI → 0 |
| Fail-safe walk | safety | the spot walks 0.5° during the 2 min relaxation: check the fold and post take it |

## 5. Risks and open questions

1. **The film strain budget binds F2.** 1.08 % pretension strain caps the
   variable squeeze at ±1.5-1.8 %; the numbers are linear-membrane, the
   nonlinear residual was not re-run at ratios 1.03-1.05, and creep at 60 MPa
   in the sun is the long-term unknown. Measure tension drift on a prototype
   ring.
2. **Cross-axis PRBM at 36° from neutral** is at the edge of the Jensen-Howell
   model (~10-15 % on stiffness; stress is cleaner). A ±10° build (β = 20)
   halves every stress and is the low-risk first article. Plate-width effect
   (w/t = 75) adds ~10 % to stress, inside the margins.
3. **Rain on a vented, face-up membrane.** Brake-hold leaves the dish where
   power failed; at noon it faces up and 50 mm of rain is 700 kg. Either the
   vented film sheds water (rim drain slit, self-weight sag) or the stow runs
   by gravity to the top of the arc (counterweight, spring-released brake, the
   CF element as end-stop buffer). Decide by climate.
4. **The winter seam.** The ±β sign flip is a 15-minute pitch transit twice a
   day in winter; a smoothed schedule in the env saves duty and lost sun.
5. **Survival load path.** The stow latch makes 25 m/s an SF > 5 event;
   without it the leaves sit at SF 2.2 with 60 % of their stress from axial
   load on the bent arc - acceptable, not "set-off" grade.
6. **Contactless costs mass**: ~5 kg of magnets and copper, ~15 kg of leaf for
   a 4 kN flat-force element; Belleville stacks and a friction damper are the
   fallbacks, with wear.
7. **Short-f layout (3-6 m).** Ellipticity is independent of f, but the rim
   slope reaches 20° and the axial load 9 kN at f = 3 (blades and ring are
   sized to 9.2 kN); the shorter arc and smaller receiver make F2 more
   valuable, not less.
8. **Nothing here is tested or FE-checked.** Ring ovalisation on four flexure
   attachments and pivot centre-shift under combined load are the two to FE
   before cutting metal.

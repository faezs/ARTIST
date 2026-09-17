# Beam-down fold mirror at F: compliant tilt mechanism (design memo)

**Sources.** *Handbook of Compliant Mechanisms* (Howell, Magleby, Olsen; Wiley 2013), 30-page excerpt: contents and Ch. 1 (book pp. 3-10). Code: `tutorials/tandoor_hashemi_env.py` (docstring, `_build_optics`, `_beta_now`), `tutorials/tandoor_mount_batch.py::mount_batch` (fold law `nf = ub + zhat`); Hashemi's fixed-focus paper figs 14-17 (carriage on a large bearing around the focal post). The handbook's library entries (Ch. 5 appendix, Ch. 11-12) are **not** in the excerpt: they are cited by section and page as pointers; the mechanics and numbers are my own, flagged where they rest on memory.

**Design stance (the user's framing).** Nuclear safety/arming ("set-off") mechanisms are compliant precisely for robustness: no lubricant, no wear, no backlash, deterministic behaviour in a hostile environment. This mirror sits at the hottest point of the machine and gets that class of design: monolithic flexures, no bearings where a flexure can do the job, an unpowered state that is safe by geometry rather than by control. The handbook's warning (Ch. 1 §1.3, p. 7) applies directly: a flexure held under stress at elevated temperature takes a set, so material and *held* stress are design variables.

## 0. Geometry recap (from the code)

Beam along `ub` (elevation `el_b`), fold normal `nf ∝ ub + ẑ`, output exactly vertical. The reflective face points **down and toward the dish**; tilt from horizontal = incidence angle = `θ = 45° − el_b/2`. The tilt plane is the carriage beam's vertical plane (`ub` stays in the plane of `ẑ` and the sun vector under the `beta` rotation), so **beam azimuth = carriage azimuth by construction**.

Deployed schedule (`hashemi.ini`: `beta_dev=36`, `beta_cap_z=10.6`; `z_fold=9.37 m`, 5.8 m above the roof deck), evaluated with `_beta_now`: `el_b` runs 8-60° over the year, with a **seam** at sun elevation ≈ 26° where the branch flips and `el_b` jumps 60° → 9°. With `beta_dev=0` (the brief) `el_b` = sun elevation, 12-88°.

```
            flexure module (shaded)          tilt axis y through F, in the face plane
      ┌───────┴────────┐  fins
  ────┤  mirror, face  ├────  IFB rim (white, 40 mm)      θ = 45 − el_b/2
       \  down       /   .                                   φ_out = −(2θ + el_b)   (angle from +x)
        \ ub  ↗    /    ↓ −ẑ  down the post bore             nominal: φ_out = −90° (vertical)
   dish  \  /      /                                          park:    beam swings toward the dish side
```

| | `beta_dev=36`, cap (deployed) | `beta_dev=0` (brief) |
|---|---|---|
| beam elevation `el_b` | 8-60° | 12-88° (gate at ≤ 60° for a safe stop envelope, see §3.7) |
| mirror tilt = incidence | **15-41°** (26° range, mid 28°) | 1-39° |
| daily duty | 2 slow arcs at 0.002°/s + 2 seam slews of 26° | 2 slow arcs |

The design below is sized for the deployed range with margin (working 13-43°, stops 13°/42.5°); the `beta_dev=0` case is the same hardware with the flexure neutral built 14° lower.

## 1. Functions and requirements

| Item | Requirement | Basis |
|---|---|---|
| Tilt dof | 15-41° working (design 13-43°), hard stops at 13° and 42.5° | `45 − el_b/2`, deployed schedule |
| Azimuth | inherited from the carriage (Hashemi's large bearing); **no** compliant azimuth (§2) | beam azimuth = carriage azimuth |
| Tracking rate | 0.002°/s (35 µrad/s); seam slew 26° in ≤ 5 min (0.09°/s) | half the sun's elevation rate; dish re-positions across the seam |
| Pointing | ≤ 2.5 mrad absolute, ≤ 0.5 mrad repeatability (mirror); beam error is 2× | relay tolerates 5-10 mrad |
| Spot / flux | r = 7-13 cm, 90-300 suns, 4.5-6 kW now, ≤ 9 kW upgraded | project optics |
| Footprint on mirror | ellipse ≤ 13 × 17 cm at i = 41°, +2 cm dish-aim wander → clear aperture 0.32 × 0.40 m | r/cos i |
| Absorbed heat | 3.5 % × 6 kW = 210 W nominal; 5 % × 9 kW = 450 W upgrade/degraded coating | silver 0.965-0.97 |
| Temperatures | mirror ≤ 100 °C (protected silver), flexures ≤ 120 °C in a fault, ambient up to 45 °C | coating life; relaxation |
| Life | 20 yr: ≈ 7,300 slow cycles + 7,300 seam slews (≈ 15 k major cycles), ≈ 100 trip/re-arm events | 2 cycles/day |
| Loss of tracking | beam walks 23 mm/min (0.25°/min × f = 5.3 m); spot centre leaves the aperture in 7-9 min; surroundings must take 6 kW at ≤ 300 suns for 10 min (3.6 MJ) | brief |
| Fail-safe | unpowered/faulted state reached by stored energy in ≤ 1 s; beam confined to the fenced beam volume for every `el_b` in range; re-arm needs power + a deliberate command | user's stance |
| Environment | 45 °C, dust, rain, gusts 20 m/s (stow > 25 m/s), UV | rooftop, hot climate |

## 2. Candidate topologies (handbook pointers)

| dof / function | Candidate | Handbook pointer | One-line verdict |
|---|---|---|---|
| Tilt | **Cross-axis flexural pivot** (two crossed blades, remote centre at the crossing) | A.1.10 p. 74; §11.1.2 Revolute p. 161 | ±20° at 200 MPa in Ti; centre can be put *on the mirror face*; monolithic by wire-EDM. **Selected.** |
| Tilt | Cartwheel flexure | A.1.11 p. 76; §11.1.2 | same family, smaller centre shift, hub in the way of a face-plane centre; drop-in alternative |
| Tilt | Small-length flexural pivot (notch hinge) | A.1.1 p. 66 | ±20° needs a 0.3 mm web at 400 MPa: too hot a stress to *hold* for hours (p. 7) |
| Tilt | Initially curved / large-deflection beams | A.1.6 p. 70; Ch. 4 p. 45 | wide range but poor axis definition, load-dependent centre: no |
| Tilt | Compliant rolling-contact (CORE) / LET torsion joints | §11.1.2 Revolute p. 161 | large angles, low off-axis stiffness, contact surfaces: reserve for a ≥ 90° dof if ever needed |
| Azimuth | any flexure | §11.1.2; §11.1.4 Universal p. 181 | 240°/day is out of reach: a 10 mm Ti torsion bar at half the shear-yield strain needs L = rθ/γ = 5 mm × 4.19 / 0.006 ≈ **3.5 m**; a cross pivot at ±120° sees 6-8× its ±20° stress. Inherit the carriage bearing (0.004°/s, 9,700 rev in 20 yr). |
| Actuator link | Two-notch compliant pushrod (small-length pivots at both ends) | A.1.1 p. 66; §8 rigid-body replacement p. 109 | replaces two pin joints; zero backlash under one-signed preload |
| Nut guidance | Parallel-guiding flexure | A.1.4 p. 69; §12.2.4 p. 214 | not needed: the pushrod's own stiffness anti-rotates the nut |
| Fail-safe return | Gravity bias + flexure preload ("constant force" return) | §12.3.3 Constant force p. 262; §12.3.1 Energy storage p. 245 | gravity never relaxes; the flexure adds a deterministic push. **Selected.** |
| Fail-safe latch | Compliant pawl held by a solenoid; bimetal snap-disc thermostat in series | §12.2.11 Latch p. 241; §12.3.2 Stability (bistable) p. 252 | powered = armed; any loss opens it |
| Impact stop | Leaf-spring bumper | A.1.3 p. 67; §12.3.5 Dampening p. 267 | absorbs the 1 J release swing without an elastomer |
| Constraint design | FACT / exact constraint | Ch. 6 p. 79 | one pivot gets an axial relief so the Al mirror can expand 0.2 mm against the Ti/steel frame |

## 3. Selected design

### 3.1 Architecture

- A two-arm **yoke** rises from the carriage's azimuth bearing to F and carries a fixed **hood**: an inverted cup rimmed with 40 mm of white insulating firebrick (IFB) facing the dish. The mirror is the hood's ceiling, face down; flexures, lever and radiator sit on its back in permanent shade (the beam always arrives from ≥ 8° below horizontal).
- The **tilt axis** is horizontal, perpendicular to the carriage beam, and lies **in the face plane**: two monolithic cross-axis pivots at y = ±0.22 m with blades crossing at the face (remote centre), so the spot does not walk on the mirror as it tilts (a centre 35 mm behind the face would walk it 18 mm).
- Mirror: 6061-T6 elliptical plate 0.36 × 0.44 m, 12 mm, integral fins (25 × 2 mm, 10 mm pitch): one billet, mirror + heat sink. Face: electroless Ni, polished, protected silver (R ≈ 0.965). Held on a Ti carrier bar by three bipod flexures (athermal).
- Actuation: lever r = 150 mm, **Invar pushrod in tension** with two blade necks, stepper + 2 mm lead screw with a dry polymer nut on the yoke cross-bar 0.6 m below F (cool, shaded, serviceable).
- Preload and return: the centre of mass sits 20 mm toward the low edge and 15 mm behind the face, so gravity torque `m g (d cos θ + h sin θ)` = 1.7-1.85 N·m toward the steep stop over the whole range (constant within 5 %); flexure neutral at 33°. The chain is always in tension (no backlash) and the mirror always wants the park stop.
- Latch: the pushrod hook sits in a Ti compliant pawl whose unstrained position is *open*; a 2 W solenoid holds it closed through a series chain (watchdog relay, 200 °C snap-disc thermostat on the hood ring, main power). Any break → pawl opens in ~10 ms → mirror swings to the 42.5° stop in ≈ 0.2 s onto a leaf-spring bumper.

### 3.2 Parametric dimensions

| Element | Value |
|---|---|
| Mirror clear aperture / substrate | 0.32 × 0.40 m ellipse / 0.36 × 0.44 m, 12 mm Al + 25 mm fins; moving mass m ≈ 7.5 kg, I ≈ 0.10 kg·m² |
| Pivots (×2) | Ti-6Al-4V block 90 × 90 × 40 mm, wire-EDM; blades t = 0.6 mm, L = 60 mm, w = 40 mm, crossing at midpoint, 90° |
| Pivot spacing | 0.44 m; one pivot with a y-axial relief blade pair (0.3 mm × 15 mm × 30 mm) |
| Flexure neutral / stops | 33° / 13° and 42.5° (park) |
| CoM offset from axis | d = 20 mm along the plate toward the low edge, h = 15 mm behind the face |
| Lever / pushrod | r = 150 mm; Invar 36 rod ⌀8 × 600 mm, necks 0.5 × 10 × 12 mm (Ti), rod in tension |
| Screw | 2 mm lead, rolled stainless, PEEK nut, 200-step motor, 16 µsteps |
| Bumper | stainless leaf, 10 mm stroke, ≈ 1.1 J |
| Hood rim | IFB ring 40 mm thick, inner edge overlapping the substrate edge by 10 mm at a 3 mm gap |

### 3.3 Pseudo-rigid-body model (own mechanics; A.1.10 is the handbook's PRBM for this element)

Each blade of a cross-axis pivot rotated by θ about the crossing bends to near-uniform curvature θ/L (the chord of the moving end rotates by θ/2, consistent with a circular arc):

- Stiffness: `K_pivot = 2 E I / L = E w t³ / (6 L)`; stress: `σ_max = E t θ / (2 L)`.
- Centre shift (λ = 0.5): `δ ≈ (0.05-0.1) L θ²` from the arc/chord length mismatch `L θ²/12`; exact coefficient depends on crossing ratio and lateral load.
- Blade buckling (fixed-fixed): `P_cr = π² E I / (L/2)²`; in-plane radial stiffness ≈ `E A / L` per blade.
- Pushrod neck (A.1.1): `K = E I / l`, `σ = E t θ_neck / (2 l)`, `θ_neck` = rod swing = stroke / rod length.

| Quantity | Value (Ti-6Al-4V, E = 114 GPa) |
|---|---|
| K per pivot / total | 2.74 / **5.5 N·m/rad** |
| Max deflection from neutral | −20° at the 13° stop (0.35 rad); working −18° … +8° |
| σ_max at the stop / working | **200 MPa** / 180 MPa (0.25 σ_y at 120 °C) |
| Fatigue | σ_a ≈ 130 MPa over ≈ 15 k cycles; Ti endurance ≈ 500 MPa smooth, 300 MPa allowed after EDM recast removal: Goodman 130/300 + 50/950 = 0.5 → unlimited life |
| Torque to hold (gravity + flexure), 41° / 15° / 13° | 1.1 / 3.5 / 3.6 N·m toward park; pushrod tension 7-24 N; screw torque ≈ 0.03 N·m |
| Net torque holding the park stop | 1.84 − 5.5 × 0.166 = **0.9 N·m** (wind on the hooded mirror ≤ 0.3 N·m at 20 m/s) |
| Centre shift at 0.35 rad | 0.4-0.7 mm, deterministic |
| Optical effect | a flat only translates: beam offset ≤ 2δ ≈ 1.2 mm at F (≈ 0.4 mm at the duct after the ellipsoid's ~3:1 demagnification); no pointing error |
| Blade buckling / load | P_cr = 900 N per blade vs ≤ 75 N (weight + bumper impact): SF 12 |
| Free tilt mode / held by chain | 1.2 Hz on the flexures; chain stiffness ≈ 1.1 × 10⁵ N·m/rad → 170 Hz; 0.3 N·m gust → 3 µrad |
| Release swing energy | gravity 0.86 J + flexure 0.20 J = 1.06 J; bumper peak ≈ 210 N at r = 150 mm; pivot reaction ≈ 150 N |
| Pushrod necks | swing ±0.06 rad → σ = 140 MPa, K = 1 N·m/rad (parasitic 0.06 N·m) |

### 3.4 Materials (properties from memory: verify against supplier data before cutting metal)

| Alloy | E (RT / 150 °C) | σ_y (RT / 150 °C / 400 °C) | α (10⁻⁶/K) | k (W/m·K) | Relaxation / creep | Role |
|---|---|---|---|---|---|---|
| **Ti-6Al-4V** annealed | 114 / 108 GPa | 880 / 760 / 650 MPa | 8.6-9.5 | 6.7 | negligible < 300 °C at ≤ 0.4 σ_y (RT creep only above ≈ 0.6 σ_y) | pivots, necks, pawl, bipods |
| Inconel 718 aged | 200 / 195 | 1050 / 1000 / 1000 (930 at 600 °C) | 13 | 11 | negligible to ≈ 550 °C | pivots if the fault case exceeds 200 °C |
| Elgiloy CW+aged strip | 190-200 | 1500-1900 (strip) | 12.4 | 12 | rated to ≈ 450 °C | strip springs (bumper, pawl spring) only; not EDM-monolithic |
| 17-7PH CH900 | 200 | 1500 | 11 | 16 | relaxes above ≈ 200 °C | no |
| 7075-T6 Al | 71 | 500 | 23 | 130 | over-ages / creeps above ≈ 120 °C; no fatigue limit | no (mirror substrate is 6061, not a flexure) |

Why Ti-6Al-4V: at equal t/L its stress is 57 % of Inconel's (E ratio), so the pivot runs at 0.25 σ_y where 718 would run at 0.35; its low conductivity makes the pivots a thermal barrier (four blades leak 0.5 W at ΔT = 50 K); it does not corrode on a roof. The *held* stress matters more than the peak: the flexure spends midday at −18° (180 MPa) and the night parked (+9.5°, 90 MPa); at ≤ 120 °C and 0.25 σ_y Ti-6Al-4V takes no measurable set in 20 yr, so p. 7's warning is met by margin. Inconel 718 is the fallback if the fault-case flexure temperature exceeds 200 °C.

### 3.5 Thermal design

Heat path: absorbed flux (peak 10 kW/m² at the spot centre) → 12 mm Al plate (through-thickness ΔT 0.75 K; in-plane spreading `q/(4π k t) ln(R/a)` ≈ 11 K) → fins (0.75 m² effective, h ≈ 15-30 W/m²K with 0-3 m/s wind) → air. The flexures are decoupled by the Ti bipods and pivots.

| Case | Mirror centre above ambient | Flexure module | Notes |
|---|---|---|---|
| 210 W, still air | +35 K (≈ 80 °C at 45 °C ambient) | ambient +15 K | passive, no water |
| 450 W (9 kW, 5 % absorption) | +55 K (≈ 100 °C) | +20 K | at the silver coating's comfortable limit; add the water jacket for the upgrade |
| 3 m/s wind | −40 % of the above | | |
| Loss of tracking, 10 min | spot on the IFB rim: surface 900-1000 °C (equilibrium at 105 kW/m² absorbed, α ≈ 0.35), thermal wave 32 mm < 40 mm thickness, tray < 150 °C | ≤ 120 °C behind a polished shield | the other 65 % scatters diffusely: < 160 W/m² beyond 2 m |
| Figure | through-thickness gradient → R ≈ 800 m, slope error 0.16 mrad at r = 13 cm; gravity sag 0.3 µm | | flat mirror is forgiving |

Active cooling (water up the yoke, 0.5 L/min for 210 W at ΔT 6 K) buys 30 K and would allow polymer silver films, at the cost of a pump, a hose across the azimuth bearing and a freeze/boil failure mode. The passive billet wins on robustness; the yoke keeps mounting points for a jacket for the 9 kW upgrade. Air through the post is unavailable (the bore is the beam).

### 3.6 Actuation and sensing

| Option | Verdict |
|---|---|
| **Stepper + lead screw, dry PEEK nut** | selected: self-locking (holds unpowered, never moves uncommanded); 10 µm/full step = 0.07 mrad (35× margin); 12 rpm for the seam slew; 1.7 km of nut travel in 20 yr at 7-24 N, wear negligible; bellows boot for dust. The one sliding contact, at the cool end. |
| Spring-return pneumatic bellows | any pressure loss parks, no sliding contact, but soft holding and 0.2 % pressure control; alternative if dust defeats the screw |
| Piezo / SMA / voice coil | µm range only / hysteretic, thermally hostile / continuous hold power at the hot end: no |

Sensing: (1) beam-centroid loop, four thermopiles around the beam entry at the hopper/relay, ≈ 0.5 mrad: closing on the optical quantity removes every mechanical drift in §4. (2) 14-bit off-axis magnetic encoder on the tilt axis (0.4 mrad) for the seam slew, beam-off tracking and fault detection (tilt error > 0.5° for 10 s → trip). (3) Thermocouple in the IFB ring (electronic trip) beside the snap-disc (mechanical trip).

### 3.7 Fail-safe

**Why no fixed park angle dumps into a cavity.** At tilt θ the beam leaves at `φ_out = −(2θ + el_b)`; over a 52° span of `el_b` no single θ sends it to one place, a carriage-mounted cavity would have to span a 52° fan, and for θ ≥ 45° the fan crosses the incoming beam (retro at `el_b = 90° − θ`). Swinging the mirror out of the beam needs ≥ 50° of rotation: a bearing job. The safe state is therefore **stops plus a park angle**, and its safety is a geometric envelope:

- Stops at 13° / 42.5° with `el_b` ∈ [8°, 60°] give `2θ + el_b` ∈ [34°, 145°]: the beam can **never** leave shallower than 34° below horizontal, whatever the controller, the wind or the actuator do.
- Park = the 42.5° stop: deviation from vertical = `el_b − 5°` toward the dish side; never toward +x.

| `el_b` | 8° | 20° | 30° | 36-59° | 60° |
|---|---|---|---|---|---|
| deviation from vertical | 3° | 15° | 25° | 31-54° | 55° |
| where it lands (F is 5.8 m above the deck) | down the bore | deck, 1.5 m out | deck, 2.7 m out | **on the dish** (within its ±23° half-angle): re-collimated back toward the sun at ≈ 0.4 sun | deck, 8.2 m out (fence at 7.1 m) |

Flux along the parked beam (half-angle a/f ≈ 0.4): ≤ 3 suns at 2 m from F, ≤ 0.35 sun at 5 m, 0.1 sun at 8 m.

Trips (all open the latch): power loss; watchdog (tilt error, hopper sensor loss, carriage tracking fault); IFB ring > 200 °C (snap-disc, no electronics); wind > 25 m/s. Re-arm: nut to the seat, solenoid closes the pawl, then tracking; automatic 60 s after power and tracking return, manual after a thermal trip. Recommended above it as the machine's primary energy kill: a normally-open membrane vent (solenoid-held, spring-open) collapses the concentration in ≈ 10 s (a 10 % pressure drop grows the spot 4-9×); the 10-minute hood rating is then a backstop, not the plan.

## 4. What to add to the simulation

| Term | Magnitude (mirror; beam = 2×) | Model |
|---|---|---|
| Alignment bias | 1.0 mrad open-loop after build alignment; 0.3 mrad closed-loop residual | fixed per env, drawn once |
| Hysteresis | 0 in the monolithic flexure; ≤ 0.05 mrad screw/nut under one-signed preload | direction-reversal offset at the seam |
| Thermal drift, open-loop | yoke thermal bending 2 mrad (1.5 m steel arm, 7 K across 60 mm), Invar pushrod 0.2, pivot asymmetry 0.1; τ ≈ 20-30 min | ∝ sun-on-yoke; closed-loop 0.3 mrad |
| Wind jitter | held chain 0.003 mrad; yoke sway 0.3 mrad at 20 m/s (∝ v²); azimuth-bearing wobble 0.5 mrad rms at 20 m/s (unknown for Hashemi's bearing, ∝ v) | rms per step, bandwidth < 0.5 Hz |
| Actuator quantisation | 0.07 mrad | uniform |
| Centre shift | 0.5 mm translation → 1 mm beam offset at F | deterministic, optional |
| Seam slew | 26° in ≤ 5 min; no beam delivered while the dish re-positions | dead time |
| Parked state | θ = 42.5°, beam deviation `el_b − 5°` toward the dish, duct power 0; entered on power loss / watchdog / hood > 200 °C / wind > 25 m/s; exit after 60 s + re-acquisition (manual after thermal) | discrete state |
| Tracking-loss walk | 23 mm/min (f = 5.3 m); aperture edge at 3.5 min (spot edge) / 8 min (spot centre); IFB rim absorbs, mirror unharmed | drives the thermal trip |

## 5. Risks and open questions

- **Which fold?** The brief puts the mirror at focus (spot 7-13 cm); the current env puts the flat `δ = z_fold − z_waist` above the waist with `r_fold = 1.08 a δ/f + 0.06` (≈ 1.2 m at the default waist). The compliant design closes for r ≤ ≈ 0.35 m (mass ∝ r², wind torque ∝ r³); a 1.2 m flat is a bearing-and-counterweight design. Decide the waist height first.
- Property values are from memory (Ti/718/Elgiloy derating, EDM fatigue knock-down, IFB α); confirm with supplier data and one blade coupon test at 120 °C.
- The azimuth bearing's tilt play is inherited 1:1; Hashemi's "large bearing" is unspecified. Budget ≤ 0.5 mrad or the loop must track gusts.
- Open-loop pointing is thermally dominated (≈ 2-3 mrad from the yoke); the beam-centroid sensor is not optional at the 2.5 mrad target.
- Dust: a dirty silver face absorbs ≈ 8 % (480 W, mirror ≈ 100 °C): weekly washing or the jacket. Silver on Ni-plated Al at 80-100 °C for 20 yr is plausible, not proven; enhanced Al (R ≈ 0.92, 300 °C tolerant) is the fallback at −5 % throughput.
- The park footprint reaches 8.2 m at `el_b = 60°` (1 m past the fence, 0.1 sun): accept, cap the negative-branch `el_b` at 58°, or move the stop to 40° and lose 1° of low-sun range.
- The latch is the one sub-assembly whose failure is not benign both ways: a stuck-closed pawl defeats the trip. Test the trip weekly (a 0.2 s event) and log it.
- Not analysed: hail on the face-down mirror (the hood helps), lightning at the mast top, icing of the IFB rim, and the beam-centroid loop across the seam (beam absent during the dish move; the encoder carries the slew).

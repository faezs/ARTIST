# Compliant mechanisms for the tandoor concentrator's mirrors

Design memos for the three mirrors of the Hashemi-frame solar tandoor
machine, each built as a compliant (flexure-based) mechanism. The
motivation is the one used in nuclear safety/arming devices: flexures
have no lubricant, no wear, no backlash and a deterministic default
state, which is what a machine that runs hot, dusty and unattended for
decades needs. Reference: Howell, Magleby, Olsen, *Handbook of
Compliant Mechanisms* (Wiley 2013); the excerpt available to the
designers held the full library taxonomy (ToC), the pseudo-rigid-body
appendix listing and Chapter 1 (stiffness vs strength; stress
relaxation at temperature, p. 7). Library mechanics beyond that come
from the designers' own knowledge and are marked as such.

| mirror | memo | duty in one line |
|---|---|---|
| primary pumped-membrane dish, a = 2.10 m | [primary_dish.md](primary_dish.md) | orbits the focus on Hashemi's carriage; needs a beta/2 pitch and a rim squeeze for astigmatism |
| beam-down fold at the focus F | [beam_down_fold.md](beam_down_fold.md) | ~40 deg tilt tracking the sun's elevation at 90-300 suns; fail-safe dump |
| M5 ellipsoidal relay, 43 rolled facets | [m5_relay.md](m5_relay.md) | per-facet tip/tilt/piston held to 10 mrad through daily thermal cycling |

Requirements in the memos are taken from the environment model
(`tutorials/tandoor_hashemi_env.py`, `tutorials/tandoor_mount_batch.py`)
and from the optical budget measured on it (delivered power 4.5-6 kW,
spot 7-13 cm radius at F, duct radius 0.20 m, M5 patch 1.11 m today).

## Summaries

### Primary dish ([primary_dish.md](primary_dish.md))
- **Pitch stage for the beta/2 tilt**: two cross-axis flexural pivots
  (Handbook A.1.10) in 17-7PH CH900, leaves 300 x 2.0 x 150 mm, neutral
  offset -18 deg so the 0-36 deg range never crosses zero moment;
  427 MPa at full tilt (SF 3.5 on yield), 687 MPa at 25 m/s survival
  (SF 2.2), pivot centre shift <= 10 mm. Held by a self-locking Tr20x4
  screw on a 0.8 m lever; driven (the beta schedule's winter seam is a
  jump no cam can follow); sensed by an inclinometer plus the fold spot.
- **Rim squeeze (toroid) for astigmatism**: the elastic ring is the
  flexure (A.1.6). The film's 1.08 % pretension strain, not the ring,
  caps the stroke (slack at 3.0 % ellipticity), so the rim is built as a
  3.3 % ellipse and squeezed +-1.5 %, covering beta 20-36; galvanised
  60 x 2 mm tube ring, 38 kg, buckling SF 5, squeeze force ~0.8 kN.
- **Carriage**: the 6.6 m arc travel must roll, so each of Hashemi's
  four bearings becomes a sealed roller on a parallelogram flexure
  suspension (12.2.4); the 6 mm tow wire gets an arc-side encoder, an
  eddy-current damper and a 4 kN constant-force limiter (12.3.3).
- **Fail-safe**: power loss opens the plenum and jam-vacuum vents so the
  membrane relaxes to flat in ~2 min (a jammed figure would keep 300
  suns walking); a bistable cosine-arch wind trip (12.3.2) on a drag
  plate gives the 9/7 m/s band with no electronics; a compliant stow
  latch (12.2.11) takes the survival load off the leaves.
- **For the simulation**: a pitch dof rate-limited at 0.02 deg/s,
  0.04 deg boresight drift per 30 K, cable stretch 0.076 deg/kN,
  +-0.03 deg rail waviness, 1.4 % focal drift per 30 K, rim ellipticity
  tracking 1/cos(beta/2) - 1 with minutes of lag.
- **Risks**: PET creep and the film strain budget; the cross-axis PRBM
  at 36 deg is at the model's edge; rain pooling on a vented face-up dish.


### M5 relay ([m5_relay.md](m5_relay.md), geometry in [m5_relay_geometry.py](m5_relay_geometry.py))
- **Facets must be doubly curved**: at the code's conjugates (waist
  4.0-5.1 m, duct 0.5-1.6 m, incidence 0-50 deg) the principal radii are
  R_t 0.93-3.7 m / R_s 0.93-1.5 m; a single-curvature strip 0.30 m long
  has 25-93 mrad RMS slope error, so the 43 facets (0.32 m hex) are
  press-formed toroids in 15 die families at +-5% radius, in monolithic
  1.5 mm anodised aluminium: a bonded Al/steel or glass/Al facet bends
  19-46 mrad over a 40 K day, a monolithic one 0.1 mrad.
- **Facet mount**: three identical feet, each one folded 0.5 mm 301/17-7PH
  blank = a bipod of two 2.5 x 0.5 x 40 mm strips (constrains n and t,
  free radially: 6 constraints, exact, athermal by symmetry) on a
  parallel-motion carriage (two 12 x 0.5 x 60 mm blades, 12.2.4/A.1.4).
  Worst permanent stress 375 MPa at the +-30 mrad range end, < 125 MPa
  typical; buckling 129 N/leg vs 10 N; facet modes 300-900 Hz.
- **Adjuster / latch**: M6x1 A4 screw in a brass nut on the carriage,
  ball tip on a hardened pad, 40 N preload spring, 24-click detent:
  0.28 mrad/click (0.5-0.9 mm at the duct), +-30 mrad, hex key from the
  front through an 8 mm hole in the mirror; position is a hard contact,
  no flexure holds a setting (the p.7 relaxation rule).
- **Global steer**: the frame (~130 kg, galvanised RHS) on three
  blade-plus-M20 feet: 0.17 mrad/click, +-10 mrad / +-12 mm (+-17 mm at
  the duct) for pit settlement, corrected before any facet is touched.
- **Build and align**: brackets set by a sweep template about the fW-fT
  axis (+-5 mrad), dies swept from two-radius arc jigs, spring-back
  calibrated with a 240 mm sag gauge; on site an LED at the waist and a
  bull's-eye at the duct centre, one facet at a time, 10 min each,
  click counts logged.
- **For the simulation**: per-facet tilt N(0, 3 mrad), radius error
  5-7%, 2 mrad waviness, fill factor 0.975-0.98, correlated thermal
  drift 0.7 mrad, global tilt 1 mrad / shift 3 mm, soiling 0.95 -> 0.90;
  expected cost 3-5%. The duct test at line 347 is positional only and
  the near-vertex facets enter it at ~78 deg: add an angular cutoff.
- **Risks**: facet forming (spring-back, 15 dies) is the critical path;
  imported mirror sheet; standing water at z = -0.36 m; the waist lamp
  port in a 300-sun bore.

### Beam-down fold at F ([beam_down_fold.md](beam_down_fold.md))
- **Kinematics from the code**: mirror tilt = 45 deg - el_b/2; with the
  deployed beta schedule the working tilt is 15-41 deg (26 deg range,
  with a 26 deg seam slew twice a day). Azimuth is inherited from the
  carriage bearing (beam azimuth = carriage azimuth by construction);
  a compliant azimuth is ruled out with numbers (a 10 mm Ti torsion bar
  for 240 deg/day would need ~3.5 m).
- **Tilt dof**: two monolithic wire-EDM cross-axis flexural pivots
  (Handbook A.1.10), Ti-6Al-4V blades 0.6 x 40 x 60 mm crossing in the
  mirror face plane (remote centre, the spot does not walk); K 5.5 N m/rad,
  neutral 33 deg, stops 13 / 42.5 deg; 200 MPa at the stop (0.25 sigma_y
  at 120 C), unlimited fatigue life, centre shift 0.4-0.7 mm.
- **Thermal**: the mirror hangs face-down at F inside a fixed hood on a
  two-arm yoke, so the flexures on its back are never illuminated; the
  hood rim is 40 mm of insulating firebrick that takes a lost-tracking
  spot walk for 10 min. 6061-T6 billet mirror 0.36 x 0.44 m with integral
  fins, protected silver: +35 K at 210 W passively, water jacket reserved
  for the 9 kW optics upgrade; flexures at ambient +15 K. Ti-6Al-4V meets
  the p. 7 stress-relaxation warning by margin; Inconel 718 is the fallback.
- **Actuation and preload**: stepper + 2 mm lead screw on the cool yoke,
  Invar pushrod, 0.07 mrad per full step; gravity preload (CoM offset)
  gives 1.7-1.85 N m toward the park stop over the whole range: zero
  backlash, deterministic unpowered state.
- **Fail-safe**: solenoid-held compliant pawl in series with a watchdog
  and a 200 C snap-disc; any break parks the mirror at 42.5 deg in 0.2 s;
  the stop envelope keeps the beam >= 34 deg below horizontal; a
  normally-open membrane vent is the machine-level energy kill.
- **For the simulation**: bias 1 mrad open-loop / 0.3 closed-loop,
  hysteresis <= 0.05 mrad, thermal drift 2-3 mrad open-loop (yoke bending
  dominates, so the beam-centroid sensor is not optional), wind jitter
  0.3-0.5 mrad, a discrete parked state, spot-walk timing.
- **Open question**: the compliant design closes for a fold of radius
  <= ~0.35 m, i.e. the fold AT the focus; the env's default 1.2 m flat
  4.8 m before the focus is a bearing-and-counterweight job.

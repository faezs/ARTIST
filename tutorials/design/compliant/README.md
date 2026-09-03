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


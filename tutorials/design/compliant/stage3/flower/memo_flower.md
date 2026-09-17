# The pneumatic sunflower: Hashemi's machine turned upside down

Concept study from the brief of 2026-09-05: a water hose as the frame, actuated like a vine robot so the machine
sets itself up and tracks by itself; the structural dual of Hashemi's fixed-focus machine, with the assembly
below the primary like a flower; fractal, so the same stem and the same skin serve at every scale. Numbers from
`physics_flower.py` (`out/checks.txt`), geometry from `model_flower.py` (`out/flower.json`, `bouquet.json`,
`flower_scales.json`), drawings `out/*_views.svg`.

## 1. The reading

Hashemi keeps the receiver fixed on a tower at F and swings the 4.2 m primary around it on an arc rail, held in
a carriage, tilted off-axis by beta/2 so the fold at F can see it. Everything that positions the mirror is
around and above it, and the fold's shadow costs a third of the aperture.

The dual puts everything below the mirror and lets the light come down through the structure:

| element | what it is | what it replaces |
|---|---|---|
| root | a ring on the pit; the mast base, the beam's entry, the winches' anchor | the tower at F, the arc rail, the carriage |
| stem | a straight water hose at 2 bar, hollow: it is the mast and the beam duct | the fold tower and the beam-down duct |
| neck | a 0.5 m vine section of the same hose, bent by three tendons at 120 deg | the carriage's two motors |
| head | an inflated rim toroid carrying the reflective skin on the inside of a spherical cap, a back plenum behind it (the pumped membrane we already have, now on-axis) | the 140 kg rigid-rim dish |
| secondary | the same skin used from outside, a convex dome on three mini-stems (the same hose, smaller) | the fold at F |
| M3, M4 | two small flexure-mounted folds: at the vertex hole and at the mast top, steered by the beam-centroid loop | the M5 relay's job of finding the pot |

The head points at the sun. The primary skin sends the light to the convex secondary, the secondary sends it back
through the vertex hole, M3 aims it down the chord of the bent neck, M4 aims it down the mast, a periscope in
the root takes it 1.2 m sideways and down into the pot. Setup is inflation: the hose everts or unrolls from the
root, the head fills, the tendons take up. Storm survival is venting: the flower lies flat.

## 2. Why the module is fractal

At constant pressure an inflated structure is scale-free: the wind moment on the head goes as q Cd D² times
the height, which is itself about 0.9 D, so as D³; the hose's wrinkling moment (π/2) p r³ with r proportional
to D also goes as D³. The safety factor does not depend on the size. What does depend on size is the hoop
tension p r, linear in D, so the fabric must get heavier with scale or the pressure lower, and the free-hose
pointing error F h² / (2 E t π r³), also linear in D. Small flowers point better and use lighter fabric. The
optics push the same way: with the focus forced down the mast, the back focal distance is fixed by the height,
so a single large head needs either a large secondary or a long effective focal length.

| D | flowers for 13.9 m² | f1 | secondary shadow | f_eff | spot at the pot | hose r | hoop | wrinkle SF at 9 m/s | pointing with cables | kW total |
|---|---|---|---|---|---|---|---|---|---|---|
| 4.2 m | 1 | 7.98 m | 14 % | 22.8 m | 0.32 m | 0.34 m | 68 kN/m (over the 60 kN/m fabric) | 7.1 | 11.7 mrad | 6.9 |
| 2.1 m | 4 | 3.78 m | 12 % | 14.3 m | 0.21 m | 0.21 m | 42 kN/m | 11.6 | 3.0 mrad | 7.0 |
| 1.4 m | 9 | 2.38 m | 11 % | 12.0 m | 0.19 m | 0.16 m | 33 kN/m | 15.3 | 1.5 mrad | 7.2 |

The 4.2 m single flower fails the spot budget and the fabric; four 2.1 m flowers or nine 1.4 m flowers meet
both. The design point below is the 2.1 m flower; the bouquet of four is today's collector area.

## 3. The 2.1 m flower

| item | value |
|---|---|
| primary skin | spherical cap R 7.56 m (f1 3.78 m, f/1.8), sag 73 mm, vertex hole r 0.22 m; marginal-ray aberration 10 mm at the prime focus against a 35 mm solar image |
| rim | inflated toroid r 0.06 m; back plenum film; head mass about 5 kg |
| secondary | convex skin r 0.37 m at 2.46 m on three mini-stems; magnification 3.8, f_eff 14.3 m |
| beam | r 0.19 m at the vertex hole, 0.15 m at the mast top, 0.21 m diameter spot at the pot mouth, 5.0 m from the secondary |
| stem | hose r 0.21 m, mast 0.83 m, neck 0.50 m; vertex at 1.33 m so the rim clears the ground at 80 deg tilt |
| hose at 2 bar | wrinkling moment 2.9 kN m, collapse 5.8 kN m; hoop 42 kN/m; EI 11.6 kN m² |
| wind 9 m/s | 188 N, 251 N m at the base: SF 11.6 on wrinkling; free-hose head rotation 0.8 deg, which is useless, so three 4 mm stay cables from the rim to ground winches: 3.0 mrad at 188 N pretension each |
| wind 25 m/s | 1.45 kN, 1.9 kN m: below collapse, but the rule is vent and lie flat before it |
| column | mast axial 414 N against 16 kN Euler and 28 kN of pressure capacity |
| optics | 0.88 x 0.90 x 0.95 x 0.95 x (1 - 0.12) x 0.90 intercept = 56 %: 1.8 kW per flower at 900 W/m², 7.0 kW for four against 4.5-6 kW delivered today |

## 4. Kinematics and the two folds

A constant-curvature neck of length L bent by the sun's zenith angle z carries the head's axis to the sun but
moves the vertex off the mast axis by L(1 - cos z)/z and lowers it to L sin z / z. Nothing in the optics cares,
because M3 on the head aims the beam along the neck's chord and M4 on the mast aims it down the mast; both are
small mirrors with milliradian ranges, which is exactly the regime where wire and blade flexures belong (the
lesson of the fold-saddle audit). The chord of a circular arc makes the angle z/2 with both end tangents, so
M3 turns by z/4 relative to the head and M4 by z/4 relative to the mast; a tendon-driven linkage can do it open
loop, the beam-centroid sensor at the root closes it. The chord's sagitta inside the neck is L/z (1 - cos z/2):
84 mm at 80 deg, 58 mm at 65 deg; with the beam at r 0.15 m and the hose at r 0.21 m the neck is clear to about
65 deg and needs a slightly fatter neck hose, r 0.25 m, to reach 80 deg.

Azimuth: either the whole flower turns on a root turntable (the pit already has one in the focus-receiver
design) and the neck bends in one plane, or the three tendons bend the neck in any direction and M3, M4 become
two-axis. The first is simpler and keeps the periscope fixed.

## 5. What the flower removes and what it adds

Removed: the tower at F, the arc rail and carriage, the off-axis beta tilt and with it the astigmatism and the
rim squeeze, the 34 % fold shadow, the M5 relay's search for the pot, the vertical-bore conflict at high sun
(the beam is always vertical in the mast). Survival becomes a valve.

Added: pressure as a utility (a small compressor, leak-down at night is the fail-safe direction), fabric in
the sun (UV-stable coated polyester or PVDF films; the current membrane is already film), a concentrated beam
inside a fabric duct (r 0.15 in r 0.21 leaves 60 mm; a spill burns the hose, so M3 and M4 park onto a
sacrificial target on any centroid fault and the duct is lined with reflective foil), and the pointing loop as
a necessity rather than a refinement: the head's own budget is a few milliradians and the passive hose has 0.8
degrees, so the cables and the loop carry the accuracy.

## 6. Open

- Eversion of a 2 bar, 0.42 m fabric hose is not established; unrolling from a drum at the root under pressure
  is the fallback and gives the same automatic setup.
- Head-to-head clearance in the bouquet over the day; four root ducts into one chamber; the cook's access.
- The Hencky shape of the pressurised skin against the spherical cap assumed here; the back-plenum pressure
  loop replaces the zone control of the present membrane.
- The right test is the ray tracer: a Cassegrain head on a tilting mount with receiver='focus' at the root,
  run through a Quetta year against the Hashemi orbit. That comparison decides it, not this memo.

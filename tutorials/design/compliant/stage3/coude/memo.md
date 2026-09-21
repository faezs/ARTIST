# Fourth pass: everything behind the dish

The complaint that stands since the first message is shading, and the first three passes never met it: the
second and third kept Hashemi's near method, a vertical focal tube through a slot in the membrane with the strip
at its top, because the optics were taken as the other fork's and only the mount was kept out of the light. The
tube alone shades a tenth of the aperture at el 59, the strip's ring another 1.5 %, the hole 5.7 %, the open slot
8 % (`../setup_sim/out/shading.txt`, `optics.py`). The brief said to move everything behind the dish, the
supports of the secondary included. This pass does that and nothing else is new.

## The optics (`optics.py`, `out/optics.txt`)

A Cassegrain on the same membrane (a 2.1 m, f 4.0, the zoned figure at 0.5 mrad): a hyperboloid secondary of
radius 0.34 m at 3.35 m from the vertex (magnification 6.7, f_eff 26.8 m) sends the beam back through a hole of
r 0.12 m to an image of radius 0.14 m one metre behind the vertex. The secondary stands on the style: a conical
shell from the hole's rim to the secondary's rim, whose projection along the sun line lies inside the secondary's
own disc, so it shades nothing more, and whose inner surface stays outside the return cone, so it obstructs
nothing; it carries the secondary and shields the beam. Behind the vertex the beam meets M3 on the head, an
ellipsoidal fold that turns it 90 degrees along the neck (the elevation axis, 1.8 m behind the vertex) and relays
the image 1:1 to a point inside the trunnion; the beam runs along the neck axis through the hollow pivot to M4 at
the stalk, 1.4 m to one side of the dish axis, which turns it 90 degrees down the stalk and relays the image to
the cass machine's F2 at env z 6.14, so the bore, the underground ellipsoid and the pot below the deck are the
other fork's unchanged. Both folds sit at 45 degrees at every elevation: M3 between the dish axis and the neck axis,
which are always perpendicular, M4 between the neck axis and the vertical. A single fold at the stalk would have
had to turn the beam by 90 - el degrees and would have grazed at the zenith; the offset of the stalk from the head
is what makes two fixed folds possible.

Shading above the deck, fraction of the aperture (`shading.py` rasters the model along the sun line): secondary
2.3-2.6 %, hole 0.3 %, style 0, mount 0, folds 0; total 3 % against 17 % (slot shut) to 25 % (slot open) for
the machine with the tube. Reflections above ground 4 instead of 2; at 0.94 each the net light at the pot is
1.03 to 1.14 times the tube machine's, and the tube, the strip, its slaved ring, the slot and its flaps are gone.

## The mount (`synth.py`, `out/synth.txt`)

FACT unchanged in kind, moved behind the membrane:

- Elevation: a two-stage hollow cartwheel pivot on the neck axis between the head and the stalk. The constraint
  space of a rotation is every line meeting its axis, and a blade whose plane contains the axis supplies three of
  them whether or not the blade reaches the axis; six radial blades 250 x 1.0 x 120 mm per stage around a 0.6 m
  bore give rank 5, DOF 1, the rotation about the neck, with the axis line itself empty for the beam. Range
  +-25.8 deg per stage at 0.25 sigma_y, 0.17 sigma_y at el 12 and 83; spring 208 N m/rad for the series pair.
  Loads: the side-mounted head's weight and the crosswind about the vertical through the pivot, 3.2 kN m at 9 m/s
  and 10.2 at 25, become ring forces at r 0.45: 1.8 and 5.7 kN per blade in plane against 11.4 kN buckling, SF
  6.5 and 2.0.
- Azimuth: a slew ring at the stalk top under M4's yoke; the beam down the stalk's axis is the azimuth axis, so
  F2 is fixed at every hour. Not a flexure and not called one.
- Head: dish, style, secondary and M3 as one optical unit on the diaphragm fine stage (three tangential blades,
  three water columns, 3 DOF Type 1, `../fact_mount/synth.py`), on a short frame from the neck bar. Counterweights
  of water: 151 kg 1.6 m behind the neck (about the elevation axis) and 267 kg 1.6 m beyond the stalk on the yoke
  (the head and its own counterweight both sit 1.4 m from the stalk; an earlier draft balanced the head alone, 136 kg)
  (about the azimuth axis), both in the dish's shadow. A screw jack from the yoke (0.8 m from the neck along the
  axis, 0.6 m down-sun, 1.2 m below it) to a 0.8 m crank on the neck bar 20 deg from -n toward the dish: 1.40-2.11 m
  over el 12-83 (stroke 0.71 m, a single-stage screw), moment arm at least 0.39 m, so 4.0 kN at 9 m/s and 31 at 25.
  The crank's angle matters: leaning the crank the other way puts the jack's dead centre at el 34, inside the range.
- Stalk: a 1.0 m tube from the deck to the yoke with the beam inside; neck at env z 6.94 so that F3 = F2; at el 12
  the lowest rim point is 0.2 m over the deck. The head sweeps 7.9 m about the neck; the roof is a circle of about
  8.5 m about the stalk, and with no F to keep the whole machine scales with the dish.

## What the flower gains

The style is now literal: the secondary's support rises from the centre of the corolla as a pistil does, and the
light goes down inside the stalk to the ovary. The head hangs on one side of the stalk on a hollow neck, the way a
sunflower's head nods from its stem. The second-pass stem and the third-pass fork are kept as the record.

## Open

- The self-setup simulation of `../setup_sim/` is to be moved to this geometry: one inflatable stalk around a
  rigid beam duct, the head pre-hung on the neck, counterweight tubes behind; the fine stage as before.
- M3 and M4 as ellipsoids relaying a 0.14 m image with NA 0.25: their aberration and the spot at F2 are the other
  fork's ray tracer to confirm; the etendue check passes with a factor 4.
- The style's wind load and the secondary's alignment on it; the hollow pivot's centre shift over 71 deg.
- Wind on the side-mounted head about the stalk: the jack and the pivot carry it; a stay from the yoke to the
  stalk base is available behind the dish.

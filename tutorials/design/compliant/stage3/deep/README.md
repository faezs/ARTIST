# The deep dish, traced (2026-09-12), kept separate from the flower's configs

Everything here runs the flower's own megakernel on the built machine (tri receiver, the strip, the vertical bore, M3 at
the inlet, the collar) with the primary replaced for the study by a FORMED paraboloid of focal length f, the head's orbit
set to f and the receiver block's f_dish set to f (design-table columns 53, 55, 32 - the last so the crossing test blocks
the bore's rays with the deep bowl). Nothing is written back. Scripts: `deep_trace.py` (the built strip),
`deep_greg.py` (the Gregorian cap), `deep_greg_near.py` (F2 brought in), `deep_year.py` / `deep_year2.py` (three days
by nine hours), `deep_blur.py` (figure tolerance). Logs: `deep_year2.log` (a perfect film), `deep_year2_sig43.log` (the
envs' 4.3 mrad static figure, the honest one). Quetta, 512 rays, 128-256 agents.

## 1. The strip's shadow does not grow with depth

8.5 % of the sun's rays hit the strip (either face) on their way to the primary at every f, and 2.6 % of them would have
hit the film - the rest were falling into the 0.5 m hole. The shadow is the strip's own projected area.

## 2. The Cassegrain strip cannot catch a deep cone, wherever it sits

A hyperboloid with foci F and F2 intercepts only the rays inside its asymptotic cone, acos(a/c) = acos(1 - d/c): 22 deg
for the built strip (d 0.3, c 4.16), 18 deg at d 0.1. A paraboloid at f 1.05 sends its rays through F over +-90 deg. The
ledger's 'beam misses the strip' at f 1.05 is 64-72 %, and moving or enlarging the strip cannot change the asymptote.
The kernel's other secondary, the ellipsoid beyond F (`sec_side = greg`, a = c + d), has a closed F-sheet: every ray
through F meets it, at a distance b = sqrt(2 c d) to the side at worst, and goes to F2 with magnification (2c + d)/d.
Made a full cap (every azimuth and polar angle, since a deep bowl fills the cone around F), it catches everything:

| secondary | shadow | rays through, midsummer noon | where the rest goes |
|---|---|---|---|
| built Cassegrain strip, f 4.05 | 8.2 % | 5.8 % | crossing 35, bore 16, collar 6, slot 8 |
| built strip, f 1.05 | 8.2 % | 17.3 % | misses the strip 64 |
| Gregorian cap 0.1 m beyond F, F2 on M4 (8.3 m), f 1.05 | 19.1 % | 67.5 % | shadow 20, slot 6, strut 1 |
| Gregorian cap 0.1 m beyond F, F2 3 m from F, f 1.05 | 7.0 % | 76.6 % | shadow 7, slot 8, strut 2 |
| Gregorian cap 0.1 m beyond F, F2 1.2 m from F, f 1.05 | 2.9 % | 33.1 % | collar 32, M3 9 - the chain below F2 is the wrong chain for a beam that fast |

(a perfect film in this table; the built machine's noon is its worst hour.) The cap's trade is one line: b^2 = 2 c d
and m = 2 c / d, so b^2 m = 4 c^2 - the shadow times the magnification is set by the distance to F2 alone. F2 at 3 m
gives a 0.56 m cap, 7 % shade, magnification 31 and a 61 cm sun image at F2 with the 4.3 mrad figure adding 28 cm, and the
kernel's bore, M3 and collar pass all of it. F2 at 1.2 m - the vertex's own height below F - gives 2.9 % shade,
magnification 13, a 25 cm image with 12 cm of figure blur, which passes the 0.5 m hole; but then the beam must be relayed
AT F2 (the fourth pass's neck), which this kernel does not trace.

## 3. The vertical bore is what a deep bowl breaks, not the light

'crossing' - rays the cap sends down the vertical bore that meet the film on the way - is 70-90 % of the rays at f 1.05
whenever the sun is more than about 30 deg from the zenith, because the bowl, 1.05 m deep, wraps round the bore when the
axis leans. At noon in summer and within two hours of it at the equinox it is nothing. A deep dish needs the beam down
its own axis: the stalk and neck of the fourth pass (`../coude/`), where F2 sits on the neck and the beam turns down the
stalk through the elevation pivot. The year table gives that machine as 'axis', the crossing rays counted as passed -
an upper bound, since those rays are not traced past the bowl (at noon, where everything is traced, the chain below
the cap loses about a fifth to the figure, so discount the off-noon 'axis' figures by that).

## 4. The year, with the envs' own 4.3 mrad figure on every ray (`deep_year2_sig43.log`)

Rays through, the Gregorian cap with F2 at 3 m, f 1.05:

| day | hour | sun el | built f 4 | deep, vertical bore | deep, beam down the axis |
|---|---|---|---|---|---|
| midwinter | 9 | 21 | 25 % | 0 | 63 % |
| midwinter | 12 | 36 | 19 % | 0 | 70 % |
| equinox | 9 | 37 | 16 % | 0 | 70 % |
| equinox | 12 | 59 | 11 % | 52 % | 52 % |
| equinox | 15 | 37 | 20 % | 0 | 76 % |
| midsummer | 9 | 50 | 12 % | 0 | 80 % |
| midsummer | 12 | 83 | 8 % | 56 % | 56 % |
| midsummer | 15 | 50 | 15 % | 0 | 86 % |

Summed over nine hours weighted by sin(el), relative to the built machine: midwinter 3.1x, equinox 4.3x, midsummer
6.1x (f 1.5: 3.3, 4.3, 5.3). The built machine is worst when the sun is high, where its vertical tube crosses the light
and the slot opens; the deep dish is worst there too, for the figure.

## 5. What the deep dish is sensitive to that the shallow one is not: the film's figure

Midsummer noon, rays through against the per-ray slope error (`deep_blur.py`):

| figure, mrad rms | built f 4 | deep f 1.5 | deep f 1.05 |
|---|---|---|---|
| 0 | 5.8 % | 72.7 % | 76.6 % |
| 3 | 7 % | 50 % | 67 % |
| 4.3 (the envs) | 8 % | 38 % | 56 % |
| 6 | 9 % | 26 % | 43 % |
| 8 | 9 % | 17 % | 30 % |
| 12 | 7 % | 9 % | 16 % |

The built machine is flat because its losses are geometric. The deep machine pays about five points per milliradian
through the cap's magnification (a 4.3 mrad figure is 28 cm at F2 against a 61 cm image), and the shorter f is the more
tolerant, as the blur at F scales with the path. This is where the formed film's price lands: at a third of yield its
wind figure is 3.1x today's table, which at the site's 99th-percentile 5.2 m/s is 0.25 mrad on the common attitudes
(total 4.3, nothing) and 3.7 mrad at the worst (total 5.7 mrad, 45 % instead of 56); at 9 m/s the worst attitude gives
11 mrad and the cap delivers 16 %. The deep machine wants the zones and the fine stage for the figure, and a stow at
lower wind than 15 m/s on the worst attitudes; a film formed at a higher tension than a third of yield buys figure back
at the cost of life.

## 6. The mount and the film, for the record

The rod's 6 x 6 with the boom in proportion to the orbit (`tandoor_screws.pedicel_scalars`, the same head and tubes):

| orbit f | boom | walk um/N | tilt urad/N | image walk um/N | first mode | 690 N (9 m/s on the back) |
|---|---|---|---|---|---|---|
| 4.0 | 5.8 m | 31.5 | 5.8 | 58.8 | 2.0 Hz | 21.7 mm, 4.0 mrad |
| 1.5 | 2.2 m | 5.7 | 1.8 | 8.8 | 4.6 Hz | 3.9 mm, 1.2 mrad |
| 1.05 | 1.5 m | 3.7 | 1.3 | 5.2 | 5.7 Hz | 2.5 mm, 0.9 mrad |

Eleven times less image walk per newton at f 1.05, not the 64x of the cube law, because the vertex's 1.8 m lever and the
stem do not shrink with the boom. The film: a flat PET disc cannot be pumped to f 1.05 (15 % strain against 2.4 % at
yield); the formed film at 1576 N/m needs 1576 Pa of shape pressure at f 1.05, so the wind's n = 0 load moves the focus
8 cm with the valve open at 12 m/s instead of 42; the sealed plenum resists it 33x as before.

## 7. The machine this points to

A 4.2 m formed paraboloid at f 1.05, F in the rim plane, a Gregorian cap 0.1 m beyond F imaging onto F2 at the vertex's
height with a 25 cm image (2.9 % shade, magnification 13), a relay at F2 sending the beam down the dish's own axis
through the neck and stalk, the pipe's shadow inside the film's hole, a mount eleven times stiffer against the wind.
Traced here to the cap, at 52-56 % of the sun's rays at noon with today's film figure and 3 to 6 times the built
machine's daily light; below F2 it is the fourth pass's optics, which this kernel does not carry. What it still lacks:
the relay's trace, a deep cup's wind loads (the LES table is the shallow bowl's), the reflectance of the cap at the rim
rays' incidence, and a formed film's manufacture and figure.

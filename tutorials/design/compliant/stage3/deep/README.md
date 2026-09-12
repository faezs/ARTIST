# The deep dish, traced (2026-09-12), kept separate from the flower's configs

Everything here runs the flower's own megakernel on the built machine (tri receiver, the strip, the vertical bore, M3 at
the inlet, the collar) with the primary replaced for the study by a FORMED paraboloid of focal length f, the head's orbit
set to f and the receiver block's f_dish set to f (design-table columns 53, 55, 32 - the last so the crossing test blocks
the bore's rays with the deep bowl). Nothing is written back. Scripts: `deep_trace.py` (the built strip),
`deep_greg.py` (the Gregorian cap), `deep_greg_near.py` (F2 brought in), `deep_year.py` / `deep_year2.py` (three days
by nine hours; `D_CAP` and `SIGB` env vars), `deep_blur.py` (figure tolerance), `deep_greg_cap.py` (the cap the rays
actually meet), `deep_greg_d.py` (the cap's distance beyond F). Logs: `deep_year2.log` (a perfect film, the cap's shadow
sphere at the semi-minor axis), `deep_year2_sig43.log` (the envs' 4.3 mrad static figure, same sphere),
`deep_year2_cap_sig43.log` (4.3 mrad, the true cap footprint), `deep_year2_d15_sig43.log` (4.3 mrad, the cap at 0.15 m),
`deep_greg_d.log`. Quetta, 512 rays, 128-256 agents.

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

(a perfect film in this table; the built machine's noon is its worst hour.) The 'shadow' column for the cap rows is
the shadow sphere those runs gave the kernel, the ellipsoid's semi-minor axis b = sqrt(2 c d) - which is wrong, and
too large. The rays from F meet the F-sheet at r(theta) = a (1 - e^2) / (1 + e cos theta): d on the axis and
a (1 - e^2) = b^2 / a ~ 2 d for the rim ray at 90 deg, so the cap the light uses is a dome about 2 d across from the
axis at F's level (`deep_greg_cap.py`): 0.19 m at d 0.1, not 0.56, which lies 1.5 m towards F2 where no ray goes.
With `r_strip` = a (1 - e^2) the cap's shadow falls inside the 0.5 m hole and shades nothing off the film; the rays
through at noon move only from 76.6 to 77.9 % (perfect film) and 56 to 57 % (4.3 mrad), because the ring b took was
mostly the hole. The trade is then r_cap ~ 2 d and m ~ 2 c / d, so the shadow no longer prices the magnification:
the hole hides a cap out to d ~ 0.25, and a farther cap with the same F2 has a smaller magnification and a smaller
image at F2 for nothing - the sweep is section 2b. F2 at 1.2 m - the vertex's own height below F - gives magnification
13 and a 25 cm image with 12 cm of figure blur, which passes the 0.5 m hole; but then the beam must be relayed AT F2
(the fourth pass's neck), which this kernel does not trace.

### 2b. The cap's distance beyond F, with the shadow inside the hole (`deep_greg_d.log`)

F2 3 m from F, f 1.05, midsummer noon, the true footprint as the kernel's shadow sphere:

| d beyond F | cap half-width | shade (all inside the hole) | magnification | sun image at F2 | through, perfect film | through, 4.3 mrad | where the rest goes at 4.3 mrad |
|---|---|---|---|---|---|---|---|
| 0.10 | 0.19 m | 0.9 % | 31 | 61 cm | 77.9 % | 56.6 % | collar 15, slot 9, M3 2, bore 2 |
| 0.15 | 0.29 m | 1.9 % | 21 | 41 cm | 83.8 % | 71.1 % | collar 12, slot 9 |
| 0.20 | 0.38 m | 3.2 % | 16 | 31 cm | 77.5 % | 67.9 % | collar 15, slot 9 |
| 0.25 | 0.46 m | 4.9 % | 13 | 25 cm | 62.7 % | 58.3 % | collar 24, slot 9 |
| 0.30 | 0.55 m | 6.9 % (1.2 % off the film) | 11 | 21 cm | 44.7 % | 44.5 % | collar 34, slot 9 |

Two losses cross. A nearer cap magnifies more, so the film's 4.3 mrad blur at F2 (28 cm at d 0.1) overfills the
image and the collar below F2 clips it; a farther cap sends a faster cone to F2 (its half-angle is the cap's
half-width over 2 c: 3.7 deg at d 0.1, 10 deg at 0.3), and the same collar clips that even with a perfect film. The
kernel's chain below F2 is the built machine's collar and slot, so the optimum is that chain's acceptance, not the
cap's: with it, d 0.15 - a 0.57 m cap, magnification 21, a 41 cm image, 84 % through with a perfect film and 71 % with
the envs' figure, against 57 % at d 0.1. The slot's 9 % is the hub slot the tri receiver opens with the sun high, and
is not the deep machine's.

## 3. The vertical bore is what a deep bowl breaks, not the light

'crossing' - rays the cap sends down the vertical bore that meet the film on the way - is 70-90 % of the rays at f 1.05
whenever the sun is more than about 30 deg from the zenith, because the bowl, 1.05 m deep, wraps round the bore when the
axis leans. At noon in summer and within two hours of it at the equinox it is nothing. A deep dish needs the beam down
its own axis: the stalk and neck of the fourth pass (`../coude/`), where F2 sits on the neck and the beam turns down the
stalk through the elevation pivot. The year table gives that machine as 'axis', the crossing rays counted as passed -
an upper bound, since those rays are not traced past the bowl (at noon, where everything is traced, the chain below
the cap loses about a fifth to the figure, so discount the off-noon 'axis' figures by that).

## 4. The year, with the envs' own 4.3 mrad figure on every ray (`deep_year2_d15_sig43.log`)

Rays through, the Gregorian cap 0.15 m beyond F with F2 3 m from F, f 1.05:

| day | hour | sun el | built f 4 | deep, vertical bore | deep, beam down the axis |
|---|---|---|---|---|---|
| midwinter | 9 | 21 | 25 % | 0 | 80 % |
| midwinter | 12 | 36 | 19 % | 0 | 84 % |
| equinox | 9 | 37 | 16 % | 0 | 86 % |
| equinox | 12 | 59 | 11 % | 66 % | 66 % |
| equinox | 15 | 37 | 20 % | 0 | 87 % |
| midsummer | 9 | 50 | 12 % | 0 | 92 % |
| midsummer | 12 | 83 | 8 % | 71 % | 71 % |
| midsummer | 15 | 50 | 15 % | 0 | 92 % |

Summed over nine hours weighted by sin(el), relative to the built machine: midwinter 3.8x, equinox 5.1x, midsummer
7.2x (f 1.5: 3.8, 5.3, 6.9). With the cap at 0.1 m and its true footprint (`deep_year2_cap_sig43.log`) it is 3.2, 4.3,
6.1x, and 3.1, 4.3, 6.1 with the oversized shadow sphere the first runs used (`deep_year2_sig43.log`). The built
machine is worst when the sun is high, where its vertical tube crosses the light and the slot opens; the deep dish is
worst there too, for the figure. The off-noon 'axis' column counts the crossing rays as passed and is not traced past
the bowl; section 3's discount applies.

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

A 4.2 m formed paraboloid at f 1.05, F in the rim plane, a Gregorian cap 0.15 m beyond F - a 0.57 m dome whose
shadow falls inside the film's hole - imaging onto F2 3 m from F, 1.95 m below the vertex, with magnification 21 and
a 41 cm image; a relay at F2 sending the beam down the dish's own axis through the neck and stalk, the pipe's shadow
inside the hole, a mount eleven times stiffer against the wind. Traced here to the cap and through the built machine's
collar: 84 % of the sun's rays at noon with a perfect film, 71 % with today's figure, and (section 4) 3.2 to 6.1 times
the built machine's daily light with the cap at 0.1 m, more with the cap at 0.15. The cap's optics are benign: the
rays from F meet it at 0 deg on the axis and 42 deg for the rim ray (F2 at 3 m; 41-44 deg for F2 anywhere from 1.2 to
8 m), where aluminium is within 5 % of its normal reflectance - no grazing; its flux is 36-44 kW/m^2 at d 0.15 (77-99 at
d 0.1), against 125-160 on the built strip 0.3 m before F, and it absorbs about 0.9 kW of the 11.8 collected at 8 %,
so it is a cooled metal mirror as the strip already is. Below F2 it is the fourth pass's optics, which this kernel does
not carry, and the optimum d it found is the built collar's acceptance, to be redone with the relay's. What it still
lacks: the relay's trace, a deep cup's wind loads (the LES table is the shallow bowl's), and a formed film's
manufacture and figure.

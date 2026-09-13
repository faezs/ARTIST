# The deep dish, traced (2026-09-12), kept separate from the flower's configs

Everything here runs the flower's own megakernel on the built machine (tri receiver, the strip, the vertical bore, M3 at
the inlet, the collar) with the primary replaced for the study by a FORMED paraboloid of focal length f, the head's orbit
set to f and the receiver block's f_dish set to f (design-table columns 53, 55, 32 - the last so the crossing test blocks
the bore's rays with the deep bowl). Nothing is written back. Scripts: `deep_trace.py` (the built strip),
`deep_greg.py` (the Gregorian cap), `deep_greg_near.py` (F2 brought in), `deep_year.py` / `deep_year2.py` (three days
by nine hours; `D_CAP` and `SIGB` env vars), `deep_blur.py` (figure tolerance), `deep_greg_cap.py` (the cap the rays
actually meet), `deep_greg_d.py` (the cap's distance beyond F), `deep_relay.py` / `deep_relay_year.py` (the relay at F2 down the axis, a\nvalidated torch twin of the kernel's ray model with the fourth pass's folds; section 8). Logs: `deep_year2.log` (a perfect film, the cap's shadow
sphere at the semi-minor axis), `deep_year2_sig43.log` (the envs' 4.3 mrad static figure, same sphere),
`deep_year2_cap_sig43.log` (4.3 mrad, the true cap footprint), `deep_year2_d15_sig43.log` (4.3 mrad, the cap at 0.15 m),
`deep_greg_d.log`, `deep_relay.log` (the relay's validation, sweep and year), `deep_relay_year_neck18.log`,
`deep_relay_year_neck18_lv475.log` (the corrected year, erratum). Quetta, 512 rays,\n128-256 agents.

## Erratum (2026-09-13): the built machine's baseline was traced at the wrong pump level

Every 'built machine' number in the first version of this study (sections 4, 5, 7, 8 and the logs `deep_year2*.log`,
`deep_relay.log`, `deep_relay_year_neck18.log`) was traced at the film ladder's middle level (3, f 4.30) instead of the
fast env's working level (4.75, f 4.05). The strip magnifies F's image 27 times into the bore, so 25 cm of focal length
put most of the light on the bore wall: the built machine read 8-28 % through where it passes 48-80 %. The deep rows
were not affected (the formed paraboloid replaced every level), so the deep machine's absolute numbers stand and the
RATIOS were wrong by three to four times: the coude machine is 1.2 / 1.4 / 1.6x the built one in rays through
(midwinter / equinox / midsummer) and 1.06 / 1.25 / 1.43x in net light after its two extra reflections, not 4-8x.
The sections below are corrected in place; `deep_relay_year_neck18_lv475.log` is the corrected year. The check that
found it: the fast env's own loop reaches 89.8 % through at equinox 8 h, and the kernel at the mount-law pose gives
89.8 % at level 4.75 with a perfect film and 21.9 % at level 3. Trace the baseline at the level the machine runs at.

## Erratum 2 (2026-09-13): the hyperboloid's asymptote does not limit a Cassegrain secondary

Section 2 says a hyperboloid with foci F and F2 intercepts only the rays inside its asymptotic cone acos(a / c). That
is the view from the hyperboloid's centre; from the dish's side every ray converging to F crosses the F-sheet, which
is a complete surface of revolution with its vertex d before F (from the focus, r = a (e^2 - 1) / (1 + e cos theta) is
finite out to theta = acos(-1/e) = 158 deg). The 64-72 % 'off strip' the ledger showed at f 1.05 was the BUILT strip's
window - a 1.2 m band over 0-100 deg of polar angle - not the sheet. Traced with a full hyperboloid shell (`w_strip
50, strip_wk 0, strip_th_hi 180`, shadow sphere 0.65 m, d 0.3) at midsummer noon: f 1.05 passes 72.0 % with a perfect
film and 71.3 % at 4.3 mrad (shadow 9.9 %, crossing 9 %), against the built band's 17 %. The Gregorian cap remains the
better secondary for a deep dish - its shadow sits inside the hole and it magnifies 8-21 against the shell's 27 - but
the reason given in section 2 was wrong, and the cap was not the only way.

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

## 4. The year, with the envs' own 4.3 mrad figure on every ray (`deep_year2_d15_sig43.log`, built column from `deep_relay_year_neck18_lv475.log`)

Rays through, the Gregorian cap 0.15 m beyond F with F2 3 m from F, f 1.05; the built machine at its working level:

| day | hour | sun el | built f 4 | deep, vertical bore | deep, beam down the axis |
|---|---|---|---|---|---|
| midwinter | 9 | 21 | 80 % | 0 | 80 % |
| midwinter | 12 | 36 | 71 % | 0 | 84 % |
| equinox | 9 | 37 | 73 % | 0 | 86 % |
| equinox | 12 | 59 | 55 % | 66 % | 66 % |
| equinox | 15 | 37 | 66 % | 0 | 87 % |
| midsummer | 9 | 50 | 66 % | 0 | 92 % |
| midsummer | 12 | 83 | 50 % | 71 % | 71 % |
| midsummer | 15 | 50 | 61 % | 0 | 92 % |

Summed over nine hours weighted by sin(el), relative to the built machine: midwinter 1.13x, equinox
1.23x, midsummer 1.38x (f 1.5: 1.14, 1.27, 1.32). The built machine is worst when the sun is high,
where its vertical tube crosses the light and the slot opens, and the deep dish is worst there too, for the figure. The
off-noon 'axis' column counts the crossing rays as passed and is not traced past the bowl; section 8 traces that chain.

## 5. What the deep dish is sensitive to, and the built one too: the film's figure

Midsummer noon, rays through against the per-ray slope error (`deep_blur.py`; the built column at its working level):

| figure, mrad rms | built f 4 | deep f 1.5 | deep f 1.05 |
|---|---|---|---|
| 0 | 81.9 % | 72.7 % | 76.6 % |
| 2 | 74.3 % | - | - |
| 3 | - | 50 % | 67 % |
| 4.3 (the envs) | 50.2 % | 38 % | 56 % |
| 6 | 35.2 % | 26 % | 43 % |
| 8 | 23.6 % | 17 % | 30 % |
| 12 | 12.3 % | 9 % | 16 % |

The first version of this table had the built machine flat at 6-9 %, an artefact of the wrong pump level (erratum): at
its working level the built machine is the MORE sensitive of the two, seven points per milliradian against the deep
dish's five, because its strip magnifies F's image 27 times ((2c - d)/d at d 0.3) into a 0.7 m bore and a 0.55 m collar,
where the cap at d 0.15 magnifies 21 and at d 0.2 only 8. The film's figure is the throughput lever of the machine as
built: a perfect film passes 82 % at midsummer noon and 90 % at equinox 8 h, the envs' 4.3 mrad 50 and 78. This is where
the formed film's price lands: at a third of yield its wind figure is 3.1x today's table, which at the site's
99th-percentile 5.2 m/s is 0.25 mrad on the common attitudes (total 4.3, nothing) and 3.7 mrad at the worst (total 5.7
mrad, 45 instead of 56 for the deep dish, about 38 instead of 50 for the built one); at 9 m/s the worst attitude gives
11 mrad. Both machines want the zones (0.5 mrad static) before anything else; the deep one also wants a stow at lower
wind than 15 m/s on the worst attitudes.

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

## 7. The machine this points to, corrected

With the built machine traced at its working level (erratum), the deep coude machine of section 8 - a formed
paraboloid at f 1.05, the Gregorian cap 0.20 m beyond F on three blades, the fourth pass's folds, the built chain below
the deck - passes 82-88 % of the sun's rays at every hour against the built machine's 48-80 %: 1.2 / 1.4 / 1.6x in rays
(midwinter / equinox / midsummer) and 1.06 / 1.25 / 1.43x in net light after its two extra reflections. Its gain is
where the built machine's vertical tube crosses the light with the sun high; in winter it is nothing. For that it needs
a formed film, two fold mirrors of 1.1 x 1.55 and 1.2 x 1.7 m, a 600 kW/m^2 image in the head, a relay through the pivot,
and a receiver redone for its source. The user's call is that this is not the play, and the numbers agree: the machine
stays the tri machine at f 4, and what the deep study leaves it is section 5 - the film's figure is its throughput
lever (82 % with a perfect film, 50 at 4.3 mrad at midsummer noon), which the zones and a film that is not at yield
address directly. The cap's optics, for the record: incidence 0-44 deg, flux 30-45 kW/m^2, a cooled metal mirror.

## 8. The relay at F2, down the axis, traced (`deep_relay.py`, `deep_relay.log`)

The fourth pass's chain (`../coude/memo.md`) put behind the deep dish: the cap images F onto F2 on the dish's own axis
behind the vertex; M3 on the head at the neck, an ellipsoidal fold, turns the beam 90 deg along the neck axis - the
elevation axis, horizontal, turning with the yoke - and relays F2 to F3 inside the hollow cartwheel pivot (bore r 0.30 m,
0.4-1.0 m from the stalk); M4 on the yoke at the stalk, 1.4 m to one side of the dish axis, turns it 90 deg down the
stalk - the azimuth axis, a tube of r 0.46 - and relays F3 to F2c on the built bore's axis; below the deck the built
chain is unchanged (the tri machine's mirror at the turn, the way, the inlet collar r 0.55). Both folds sit at 45 deg at
every elevation because the head turns about the neck axis. The stalk is 1.3 m here, not the fourth pass's 1.0: the deep
head's rim is 1.05 m ahead of its vertex and clears the deck by 0.3 m at el 12 only with the neck at z 5.35. The cap
hangs on three blades in the rim plane (F's plane), 4 mm thick and 50 mm tall, from the rim ring to the cap's edge:
the converging beam is wholly below that plane and the return beam wholly inside the cap's radius, so the blades
cross no light and shade 0.17 % on the sun leg; the fourth pass's style from the hole does not work for a Gregorian,
whose return beam is wide exactly where the hole's dark cone is narrow.

The kernel does not carry this chain, so the trace is a torch twin of the kernel's ray model - the same 512-point
grid, the same canonical-ray rotation, the same per-ray Gaussian on the incident ray, the same ellipsoid, way and
collar tests - validated first on the kernel's own vertical-bore deep machine with the same noise draws:

| day / hour | who | through | cap shade | hole | crossing | bore | turn mirror | collar |
|---|---|---|---|---|---|---|---|---|
| midsummer noon | kernel | 80.6 % | 1.8 | 4.0 | 0 | 0.1 | 0.8 | 12.6 |
| | twin | 80.0 % | 1.8 | 4.0 | 0 | 0.1 | 0.8 | 13.2 |
| equinox noon | kernel | 8.2 % | 1.8 | 4.0 | 84.8 | 0.1 | 0.1 | 1.0 |
| | twin | 8.2 % | 1.8 | 4.0 | 84.8 | 0.1 | 0.1 | 1.0 |
| equinox 9 h, midwinter noon | both | 0 | 1.8 | 4.0 | 94.2 | 0 | 0 | 0 |

(no slot, no strut, 4.3 mrad, 128 x 512 rays.) Found on the way: the fast env's trace has no sun. `trace_setup` sets
`upick = us = 0.5`, so the kernel's sun table gives every ray the same 3.2 mrad offset in one direction - a pointing
error, not the 4.65 mrad limb-darkened disc the slow env samples. The year logs above are all so. The built machine
hardly notices (its losses are geometric: 25.4 instead of 24.6 % at midwinter 9 h with the disc, 7.9 instead of 8.4 at
midsummer noon), a machine that magnifies the sun twentyfold does, so the relay is traced both ways and the honest
column is the disc's.

The first sweep, with F2 1.2-1.5 m behind the vertex (2c 2.25-2.55) and M3 relaying 1:1 or magnifying, lost 33-70 %
of the rays in the pivot's bore and a further 7-40 % at M4: the cap's image at magnification 16-26 is 10-14 cm rms
before the sun's disc is added, and the fold cannot pass it through a 0.30 m bore with the cone it carries. The
etendue says where the optimum is: a conduit of radius R over +-L about a focus passes an image of radius r with a cone
theta when r + L theta < R, and r theta is fixed by the dish and the figure, so the image at F3 wants r ~ sqrt(L r theta),
about 7 cm - the cap's image demagnified by half, which means F2 nearer the vertex (a longer run to M3) and a slower
cone at F2c for the built bore below (M4 magnifying again). So the second sweep brought 2c to 1.5-1.8 and had M3
demagnify and M4 magnify:

| neck | F2 behind the vertex (2c) | cap d, r, magnification | M3 in -> out | M4 in -> out | hole | through at noon, disc | beam rms at M3, M4 |
|---|---|---|---|---|---|---|---|
| 1.3 | 0.15 m (1.2) | 0.20, 0.35 m, 7 | 1.15 -> 0.80 | 0.60 -> 3.5 | 0.4 | 88.7 % | 31, 28 cm |
| 1.8 | 0.45 m (1.5) | 0.20, 0.36 m, 8 | 1.35 -> 0.80 | 0.60 -> 3.5 | 0.4 | 87.9 % | 32, 29 cm |
| 1.3 | 0.30 m (1.35) | 0.25, 0.43 m, 6 | 1.00 -> 0.80 | 0.60 -> 3.5 | 0.5 | 87.9 % | 29, 27 cm |
| 1.8 | 0.45 m (1.5) | 0.20, 0.36 m, 8 | 1.35 -> 0.70 | 0.70 -> 2.8 | 0.5 | 80.7 % | 32, 35 cm |
| 1.8 | 0.45 m (1.5) | 0.15, 0.28 m, 11 | 1.35 -> 0.70 | 0.70 -> 0.8 | 0.5 | 11.7 % | 30, 33 cm |
| 1.8 | 1.20 m (2.25) | 0.15, 0.29 m, 16 | 0.60 -> 0.60 | 0.80 -> 0.8 | 0.5 | 4.2 % | - |

(432 designs in `deep_relay.log`; the last two rows are the first sweep's, `SIGB=0.0043`, 65 536 rays with the sun's
disc.) The machine taken forward keeps the fourth pass's neck at 1.8 m (the second row): F2 0.45 m behind the vertex,
the cap 0.20 m beyond F (a 0.72 m dome, magnification 8, its shadow inside a 0.4 m hole), M3 demagnifying 0.59 onto
F3 at 0.6 m from the stalk inside the pivot, M4 magnifying 5.8 onto F2c 3.5 m below the neck axis - at env z 1.85,
1.75 m below the deck, 1.7 m above the turn - so the cone down the stalk and the built bore is slow. Its ledger at
midsummer noon: cap shade 2.8 % (inside the hole), hole 0.8, M3 patch (r 0.55) 3.4, pivot bore 1.6, M4 patch (r 0.6)
2.2, stalk 0, turn mirror 0.3, collar 1.0, through 87.9. The images: 7.7 cm rms at F2 (11 kW in open air, about
600 kW/m^2 within that radius, 0.45 m behind the film - nothing may stand there, and the plenum's back needs a clear
duct of r 0.15 from the hole to M3), 4.9 cm at F3, 21 cm at F2c, 10 cm at the deck. The beams: 32 cm rms at M3 and
29 cm at M4, so the patches of r 0.55 and 0.6 are ellipses of 1.1 x 1.55 m and 1.2 x 1.7 m at 45 deg and still lose
3-6 % between them; this is the etendue price of the 4.3 mrad figure (the fourth pass's M3 carried a 0.34 m beam at
0.5 mrad), and the pivot's 0.30 m bore, which the first sweep could not pass, loses 1.6 %.

The year (`deep_relay_year_neck18.log`), rays through with the sun's disc, and the spot's rms radius at the collar
plane (the built machine's from the kernel's `out6`):

| day | hour | sun el | built, fixed | built, disc | built spot | coude, fixed | coude, disc | coude spot | spot at the bread |
|---|---|---|---|---|---|---|---|---|---|
| midwinter | 9 | 21 | 79.5 % | 73.9 % | 32 cm | 89.8 % | 85.4 % | 21 cm | 58 cm |
| midwinter | 12 | 36 | 70.5 | 67.8 | 35 | 89.2 | 84.6 | 22 | 44 |
| midwinter | 15 | 21 | 74.7 | 74.5 | 32 | 86.7 | 82.2 | 22 | 38 |
| equinox | 9 | 37 | 72.6 | 66.3 | 35 | 91.3 | 86.8 | 21 | 59 |
| equinox | 12 | 59 | 54.5 | 52.4 | 36 | 90.4 | 86.5 | 22 | 44 |
| equinox | 15 | 37 | 66.0 | 66.4 | 35 | 87.9 | 84.2 | 22 | 39 |
| midsummer | 9 | 50 | 66.4 | 60.5 | 36 | 92.6 | 87.6 | 20 | 60 |
| midsummer | 12 | 83 | 49.9 | 48.1 | 37 | 91.0 | 87.9 | 21 | 47 |
| midsummer | 15 | 50 | 60.5 | 60.7 | 36 | 88.9 | 86.1 | 21 | 43 |

(the built machine at its working level 4.75, `deep_relay_year_neck18_lv475.log`; the first version of this table had it
at level 3, erratum.) Summed over nine hours weighted by sin(el), relative to the built machine: rays through 1.2x
midwinter, 1.4x equinox, 1.6x midsummer (the same with the kernel's fixed offset); net light with 0.94 per reflection,
five against three, 1.06x, 1.25x, 1.43x. Every hour of the coude machine's year is between 82 and 88 % because the beam
goes down the dish's own axis: no crossing, no slot, no strut. The built machine at its working level passes 66-80 %
with the sun low and 48-55 % with it high, where its vertical tube crosses the light and the slot opens; that high-sun
gap is the whole of the coude machine's gain. The neck at 1.3 m with F2 0.15 m behind the vertex adds one point
(`deep_relay.log`'s year) and puts the 600 kW/m^2 image at the film's back; it is not taken.

What the spot columns say. The deep machine's beam at the collar is smaller than the built one's (21 cm rms against
32-37), so the receiver below the deck sees a smaller source; but the tri mirror at the turn
images F2c onto the loaf with L_out / u_f2 = 1.8 here (F2c 1.7 m above the turn, the loaf 3.1 m from it), and the 21 cm
image at F2c becomes 38-60 cm rms on the bread. 'Through' is the collar, as it is for the built machine, and the
loaf's flux is the receiver's own design - the other fork's - to redo for this source: a smaller image at F2c costs a
faster cone in the built bore (r 0.7) and the trade sits below the deck. The relay above it is traced end to end.

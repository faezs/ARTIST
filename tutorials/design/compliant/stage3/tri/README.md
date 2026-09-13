# The tri machine, the production architecture (2026-09-13)

The machine is the tri receiver at f 4 (dish, strip, an actuated M3 on the bread, the vertical bore, the collar): the
user's call after the deep-dish study (`../deep/README.md`, erratum). Four things were asked in order: the zones on and
the year re-traced at the working level; the rim-fed film in the envs; the LES pressure field traced on the film; the
receiver's box searched again with the film model corrected.

## 1. The zones were already on; the figure that is left is the film's own

`flowerfast.ini` and `hashemi.ini` carry `n_zones 5, zone_c 0.4` (the zoned plenum, 0.5 mrad of shape residual), so every
trace of the deep study and of this page had the zones. The 4.3 mrad the envs put on every ray is not the shape: it is
`sig_static` = sqrt((2 x 2.0 mrad film slope)^2 + (2 x 0.8 mrad print)^2), the film's own slope error and its grain
print-through, doubled on reflection. The tri machine at its working level (4.75, f 4.05), the mount-law pose, the
kernel's fixed sun offset, rays through against that figure:

| reflected figure, mrad rms | film slope | equinox 8 h (el 25) | equinox noon | midsummer noon | midwinter noon |
|---|---|---|---|---|---|
| 0 | perfect | 89.8 % | 80.4 % | 81.9 % | 90.1 % |
| 2.0 | ~0.7 mrad | 89.5 | 76.2 | 74.3 | 88.1 |
| 2.6 | 1 mrad | ~86 | ~68 | ~66 | ~83 |
| 4.3 (the envs) | 2 mrad | 78.4 | 54.5 | 50.2 | 70.5 |
| 8.0 | 4 mrad | 46.4 | 27.1 | 23.6 | 39.6 |

Seven points per milliradian at high sun, because the strip images F 27 times ((2c - d)/d at d 0.3) into a 0.7 m bore
and a 0.55 m collar. With a perfect film what remains at high sun is geometric and fixed: the tube crossing the bowl
(15-20 %), the slot (8 %), the collar (12 %). The fast loop's pointing is closed (run 4: 0.09 cm, `../flower_fast/README.md`).

## 2. The rim-fed film in the envs

`film_T` and `film_slope` in the base env, the flower envs and both flower inis (2100 N/m): the rim a spool dispensing
the 2.4 cm of meridional length the dome asks for at f 4, the film carrying only Gauss's hoop strain, 42 MPa (83 at
the hole) against the flat disc's 98 (196); the same sphere at 410 Pa instead of 961, the wind figure 2.3x the LES
table, the n = 0 defocus 2.3x for the same wind (the valve stays sealed in wind), the cook's own wind blur scaled
through `sp[7]`. It cannot go deeper than f 3 at yield or f 4 at half of it without wrinkling, and a wrinkled annulus is
optically dead (`../wind/README.md`, 'The rim-fed film'). Run 4's controller, trained at 4922, evaluated on the rim-fed
env (`../flower_fast/runs/reeval_run4_fed.log`): 0.09 cm, 89.8 % through, reward 0.0044 per step - the same to the digit
as on the flat film at the site's wind, so the pointing policy transfers; the fed film's 2.3x shows only in stronger wind,
which `fast_eval` does not sweep.

## 3. The LES pressure field on the film, through the kernel (`../wind/film_field.py`)

The year at the site's 99th-percentile 5.2 m/s and at 9 m/s, the wind from the west, sin(el)-weighted rays through:
62.0 % with the static figure alone; 61.3 with the field at the working tension; 58.6 rim-fed; 58.3 with an isotropic
Gaussian of the field's rms (the coherent shape passes the strip's 27x like a blur, so the table's rms is enough);
45.5 rim-fed at 9 m/s (the mornings, theta_w 117-135, lose 40-50 points at 7-8 mrad); 74.1 with the film at 1 mrad of
slope and the field at 5.2 m/s; 56.1 at 9. The film's smoothness is worth four times what the wind takes at 5 m/s.

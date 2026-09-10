# Beta on the machine as flower.ini configures it (tri, r_duct 0.55, roof deck, post_offset 0.5)

Scripts: beta_flux54.py (36..72), beta_flux_low.py (0..36), beta_cap.py (36 under rim caps), beta_ledger.py (per-ray fates).
Harness as beta_flux.py: perfect tracking, n_rays 256, zero sun-cone noise, 16 identical agents, delivered kW at the bread.

## The ladder is monotonic toward retro

day means, kW:            0      9     18     27     36     45     54     63     72
  midwinter (355)      5.82   5.36   4.28   3.34   2.36   2.46   2.46   2.46   2.45   (cap holds eff beta <= 38 past 36)
  equinox (80)         7.78   7.38   5.61   4.26   3.17   2.52   2.20   1.94   1.94
  midsummer (172)      7.65   7.30   5.29   3.70   2.38   1.61   1.25   0.95   0.89
54 against 36: +4 / -31 / -48 %. 36 against 0: -59 / -59 / -69 %. The 36 optimum (out/beta_flux.txt) was the OLD
machine: default cass receiver, deck 1.4 m above the roof, no post offset - where retro measured -30 %.

## The rim cap is not it
beta 36 under beta_cap_z 10.6 / 9.6 / 9.2 / 8.8 / 8.5 / none: day means 2.36 2.54 1.76 0.76 0.76 1.82 (midwinter),
3.17 3.19 2.53 2.76 1.92 2.79 (equinox), 2.38 2.69 2.93 2.08 1.54 2.38 (midsummer). Lower caps push the schedule onto
its negative branch and lose whole hours; nothing recovers the retro level.

## What the trace shades, read off the ledger (percent of rays)
retro, equinox noon (el 59):  through 81.6 . strip shadow 8.2 . slot 7.8 . arm 2.3
retro, midwinter noon (el 36): through 90.2 . strip shadow 8.2 . arm 1.6           (slot closed below slot_el)
beta 36, equinox noon:         through 26.6 . missed M3 23.8 . collar 16.8 . outside the bore 12.1 . slot 7.4 . hole 5.5
                               . off the strip's extent 5.1 . strip shadow 1.6 . arm 1.2
beta 36, midwinter noon:       through 35.9 . off the strip's extent 33.2 . collar 12.5 . hole 5.5 . missed M3 5.1 . bore 3.1
                               . arm 2.0 . strip shadow 1.6 . re-crossed 1.2
The strip's shadow is 8.2 % at retro (a 0.6 m sphere at the dish's centre, exactly pi 0.36 / pi 4.41) and 1.2-2 % at 36.
Everything beta costs is on the REFLECTED leg: the strip's extent, the collar, the bore mouth, M3.

## What the cass/tri core does and does not shade (tandoor_hashemi_env.py:719-744, tandoor_metal_kernel.py:571-591)
sun leg, four terms, kept apart for the ledger (codes 11-14): the secondary as a SPHERE r_strip at Hc = F - d_strip*ud on the
dish axis; the dish's hole r_hole; the slot w_slot when the sun is above slot_el; the arm Ps -> F as a line of radius r_strut.
reflected leg: the strip's extent (on_strip), the arm (graze), the dish itself and the arm again (crossing), then the bore,
M3, way and collar gates. NO pipe, tower, mast or column above the deck: the _hits_column terms exist only in the FOLD core
(lines 190-196). The bore below the deck is a gate, not a shadow caster. The strip -> deck down-leg tests nothing.
So a duct above the roof, if the flower is built with one, is unshaded in every tri trace; and a dish standing on the axis
(retro, sun above ~41 deg) is passed through - Hashemi's dish has a 0.5 m hole for exactly that, the flower's has none.
The flower inis leave r_hole 0.5 and the slot on: 5.5 % + 7.4-7.8 % charged to a dish that has neither.

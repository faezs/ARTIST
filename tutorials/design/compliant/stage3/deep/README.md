# The deep dish in the trace (2026-09-12), kept separate

`deep_trace.py` runs the flower's own kernel with the primary replaced by a FORMED paraboloid of focal length f and the
head's orbit set to f (the vertex f from F on the aim law's sphere), everything else the built machine: the strip r 0.6 m
at 0.3 m below F on the vertical bore, the bore, M3 at the inlet, the collar. Nothing written back. Midsummer, Quetta,
512 rays, 256 agents; the miss ledger says where each ray died. Fractions of the sun's rays:

| hour | f | cone at F | through | power vs f 4 | strip shadow | of it, would have hit the film | beam misses the strip | crossing (the bore through the bowl) | misses bore / M3 / collar |
|---|---|---|---|---|---|---|---|---|---|
| 9 | 4.05 | 58 | 8.0 % | 1.00 | 8.5 % | 2.6 % | 12.8 % | 6.5 % | 41.7 / 3.4 / 17.4 |
| 9 | 2.0 | 111 | 0.0 % | 0.00 | 8.5 % | 2.6 % | 30.2 % | 59.6 % | 0 |
| 9 | 1.5 | 140 | 1.2 % | 0.29 | 8.5 % | 2.6 % | 47.7 % | 40.9 % | 0 |
| 9 | 1.2 | 165 | 7.6 % | 1.16 | 8.5 % | 2.6 % | 64.1 % | 18.1 % | 0 |
| 9 | 1.05 | 180 | 6.8 % | 1.00 | 8.5 % | 2.6 % | 72.4 % | 10.6 % | 0 |
| 12 | 4.05 | 58 | 5.8 % | 1.00 | 8.5 % | 2.6 % | 17.3 % | 35.1 % | 15.7 / 2.4 / 5.6, slot 8.1 |
| 12 | 2.0 | 111 | 40.5 % | 6.94 | 8.5 % | 2.6 % | 41.4 % | 0 | 0, slot 8.1 |
| 12 | 1.5 | 140 | 27.2 % | 4.66 | 8.5 % | 2.6 % | 54.7 % | 0 | 0, slot 8.1 |
| 12 | 1.05 | 180 | 17.4 % | 2.99 | 8.5 % | 2.6 % | 63.7 % | 0.7 % | 0, slot 8.1 |

What it says:
- THE STRIP'S SHADOW DOES NOT GROW WITH DEPTH. 8.5 % of the sun's rays hit the strip, either face, on their way in, at
  every f, because the shadow is the strip's own projected area; 2.6 % of them would have hit the film, the rest were
  falling into the 0.5 m hole anyway. A deeper dish changes this not at all.
- THE STRIP AT 0.3 M IS THE WRONG STRIP FOR A DEEP CONE. From F it subtends 63 deg; a paraboloid's rim ray arrives at F
  at 111 deg (f 2) to 180 deg (f 1.05), so the strip catches the dish out to r 1.85 m at f 1.5, 1.48 at f 1.2, 1.30 at
  f 1.05 - 77, 47, 34 % of the film's area - and the ledger's 'beam misses the strip' is exactly that (48, 64, 72 %).
  The strip must move in proportion to f (0.075 m at f 1.05 for the same 0.6 % shade it costs today) with a stronger
  hyperboloid; the study cannot move it because the chain's a_h, c_h are built at construction, so these numbers are the
  geometry's, not a design's.
- THE VERTICAL BORE THROUGH A DEEP BOWL IS THE REAL LOSS. 'crossing' - the rays sent down the bore by the strip that
  meet the film on the way - is 60 % at f 2 and 41 % at f 1.5 in the morning and afternoon, when the dish axis leans
  40 deg from the vertical and the bowl, 0.55-0.73 m deep, wraps round the bore. At noon it is nothing. A deep dish needs
  the beam down its own axis (the fourth pass's stalk and neck) or a slot the height of the bowl, which is not a slot.
- Where the strip does catch the rays, the rest of the chain passes them all: no bore, M3 or collar losses at any f,
  against 42 + 3 + 17 % for the shallow machine in the morning. At noon the deep dish delivers 3-7x the shallow one even
  with two thirds of its rays missing the strip, because the shallow machine at el 83 loses 35 % to crossing and 8 % to
  the slot.
- Grazing incidence on the strip does not appear as a rejection (the kernel's 'graze' is the strut's), so the
  reflectance loss at the rim rays' angles is still unaccounted for.

So: the deep dish is a receiver redesign (the strip in close, the beam down the axis), not a shading problem. With those
two, the ledger has nothing left to lose but the strip's own 2.6 % and the strut's 1.8 %.

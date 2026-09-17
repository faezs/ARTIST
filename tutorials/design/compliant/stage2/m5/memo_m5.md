# M5 relay: the facet pad as an exact-constraint adjustable mount, and the patch

Second-pass design for the 43-facet ellipsoidal relay in the pit.
Requirements: `../../brief.md` section 2.3 (43 pressed-toroid Al
facets, 0.32 m hex, ~0.5 kg; hold each to 10 mrad through +-40 K daily
cycles for 20 yr; 49 N per facet with the hatch open at 47 m/s; pit
zone up to ~200 C) and `../../brief_robustness.md`. Numbers from
`model_m5.py` (`out/checks.txt`); geometry `out/m5_pad.json` (one
pad) and `out/m5_patch.json` (the 43 facets on their truss, world
frame); drawing `out/m5_pad.svg`.

## 1. What a pad is

Each facet sits on three hard contacts (the tips of three M6 fine
adjuster screws in the frame, 120 deg apart on a 100 mm circle) and is
held in its plane by six Ti-6Al-4V wires: at each of the three
stations a pair of 65 mm, 1.0 mm wires runs tangentially from a frame
post to the facet boss, the two wires of a pair 6 mm apart radially.
A central Inconel X-750 coil (120 N at 12 mm) pulls the facet onto its
contacts. Nothing slides, nothing is bonded across dissimilar metals,
and the facet's own thermal growth is radial about the pad centre.

| item | value |
|---|---|
| in-plane constraint | 6 tangential wires Ti-6Al-4V d 1.0 x 65 mm, 3 stations at 120 deg, r 100 mm |
| out-of-plane definition | 3 screw-tip contacts on the same circle, preloaded by the central coil |
| adjustment window | +-15 mrad tip/tilt, +-2 mm piston (the frame's machining tolerance, 1.5x the 10 mrad slope budget) |
| facet | monolithic pressed Al toroid, 0.32 m hex, ~0.5 kg, boss machined on the back |
| mass added per facet | wires 0.002 kg, posts and boss ~0.15 kg, screws and spring ~0.1 kg |

## 2. FACT

Freedom to leave to the adjusters: tip, tilt, piston (two rotations in
the facet plane through the pad centre and the normal translation).
Constraint space: every line in the facet plane, 3-D. Six tangential
in-plane wires span it: rank 3, DOF 3, exactly the three intended
(`out/checks.txt`). Adding the three contacts (normal lines at the
stations) gives rank 6, DOF 0: an exact-constraint, adjustable mount.
Any single wire removed leaves rank 3 (R-DCM-1); the pair at each
station is the redundancy, and it is what stops the facet spinning
about its normal if one wire is lost.

## 3. Numbers

| quantity | value | requirement |
|---|---|---|
| eigen-stiffness ratio, soft (tip, tilt, piston) vs stiff (in-plane) | 3.9 x 10^-4 | R11 (wires only; the contacts close the soft directions) |
| wire stress at +-15 mrad tilt (held 20 yr) | 121 MPa = 0.14 sigma_y, 0.17 sigma_y at 200 C | R3 held <= 0.25 sigma_y(T) |
| wire stress at +-2 mm piston | 162 MPa = 0.22 sigma_y at 200 C | R3 |
| buckling, 49 N in-plane shared by six wires | 8.2 N vs P_cr 27 N: SF 3.3 | R10 >= 3 |
| in-plane motion under a 49 N gust | 12 um (three wires axial at 1.4 kN/mm) | hold 10 mrad: trivial |
| preload vs the 49 N suction case | 120 N: SF 2.4, contacts never open; +-2 mm piston changes it +-20 N | R4 |
| athermal, +40 K | Al facet vs Ti wires and frame differ by 0.058 mm radially at r 100; taken by wire bending at 4.7 MPa; symmetric, no tilt | R7 < 2 mrad, R8, R9 |
| set-and-forget | adjusters locked by a jam nut and a dab of ceramic cement; the wires hold the set for 20 yr at 0.17-0.22 sigma_y(T), below the relaxation threshold for Ti | R6 |

The first-pass memo's rolled strips fail the 10 mrad budget; pressed
toroids with a single machined boss are the facet baseline (see
`../../m5_relay.md`), so the pad has no bimetal layer to walk.

## 4. The patch

`out/m5_patch.json` shows the 43 facets from `../../m5_relay_geometry.py`
on the pit truss with the two foci: the waist fW (1.25, 0, 4.606) above
and the duct fT (0.42, 0, 0.14) beside. Each facet is drawn with its
local toroid tilt about y; incidence runs 8.9-50.9 deg. The truss is a
rectangular base with diagonals, thermal centre at the chief-ray facet
(x ~ 0.74 m, y 0), feet radial-free (R8). Five south facets fall inside
the modelled pot sphere; the brief lists trimming them or moving the
wall as an open item.

## 5. Weak-link order

1. Wind with the hatch open: 49 N per facet. In plane the wires carry
   it at SF 3.3 on buckling; normal to the facet the contacts carry
   pressure and the preload carries suction at SF 2.4. The hatch
   interlock (close before 25 m/s) keeps this a survival case, not a
   duty case.
2. Over-temperature: the pit zone is bounded by the pot; a facet that
   sees 5 suns runs +30 K, within the athermal budget. A wire never
   sees the beam.
3. A lost wire: rank unchanged, the pair's partner holds; a lost
   contact (screw backs out) tips the facet onto the hood of the
   truss, not into the beam; the cement on the jam nuts is the guard.
4. The frame and the facet are the strong links.

## 6. Manufacture

Frame posts and facet boss machined (Ti posts, Al boss integral with
the pressed facet); six wires laser-welded into pilot holes; three M6
fine-thread adjusters with hardened ball tips into conical seats on the
boss; central spring on a Ti hook. Alignment on the truss by a
theodolite or a laser at fW through the duct; set, lock, cement.

## 7. Open

The facet-to-facet gap at the patch edge where incidence reaches 51
deg; the pot-sphere interference for the five south facets; the truss
member sizes against the 1.5 kN tie-down (first memo's estimate).

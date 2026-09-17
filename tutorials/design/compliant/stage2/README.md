# Stage 2: the three mirror structures as directionally compliant lattices

The first-pass memos (`../primary_dish.md`, `../beam_down_fold.md`,
`../m5_relay.md`) chose flexure types from the handbook and sized
them one pivot at a time. Stage 2 treats each mirror's support as one
full-scale structure designed by FACT/DCM (Hopkins; Shaw et al. 2019):
write the freedom the mirror needs, take the reciprocal constraint
space, fill it with wires or blades in a periodic block between rigid
layers, check exactness by rank, redundancy by removal, stiffness and
modes by a frame FE, stress and buckling at range, then draw the whole
thing in 3-D. The tooling is `../fact/dcm_core.py` and
`../3d/`; the rules are `../brief_robustness.md`; the world frame and
requirements are `../brief.md`.

| structure | freedom | lattice | exactness | K about the freedom | range / stress | buckling SF | first mode | memo |
|---|---|---|---|---|---|---|---|---|
| primary dish pitch stage | 1R about the axis through the CG | 12 cross-axis blade cells (24 blades 17-7PH 150 x 0.8) in a 2 m row between the yoke and rim-carrier beams | rank 5 / DOF 1; one blade lost: unchanged, -4.2 % | 261 N m/rad; stiff directions 2.4-7.6 MN/mm | 38 deg at 0.30 sigma_y; 213 MPa = 0.14 sigma_y at the 18 deg working limit | 52 working, 12.5 survival | 0.19 Hz free on the blades; tens of Hz on the locked screw | `dish/memo_dish.md` |
| beam-down fold at F | 1R about the face-plane axis through F | 5 Ti frames, 4 interfaces x 40 oblique Ti wires d 1.0, 40 mm gaps, on the mirror's back | rank 5 / DOF 1 per interface and for the stack; one wire lost: unchanged, -2.5 % | 86.9 N m/rad at F; 2.4-7.4 kN/mm across | 30.6 deg at 0.25 sigma_y(120 C); working 27 deg | 141 | 4.1 Hz | `fold/memo_fold.md` |
| M5 facet pad (x 43) | tip, tilt, piston left to three adjusters | 6 tangential Ti wires d 1.0 x 65 mm at r 100 + 3 screw contacts + 120 N central spring | rank 3 / DOF 3 wires alone; rank 6 / DOF 0 with contacts; one wire lost: unchanged | in-plane 1.4 kN/mm per wire; 12 um under 49 N | +-15 mrad / +-2 mm held at 0.17-0.22 sigma_y(200 C) | 3.3 under 49 N | contact-defined | `m5/memo_m5.md` |

## What changed from the first pass

- The dish gives up its two rim pivots for a distributed bearing along
  its whole width: 24 blades sharing the load, none of them near
  yield, and the loss of any one costs stiffness only.
- The fold gives up its two cross-axis pivots for a lattice on the
  mirror's back that has no material at the axis at all: the axis is
  a virtual line in the reflective face plane through F, which is
  what the fixed-focus frame needs.
- The M5 facets get an exact-constraint mount whose held stress is a
  fifth of yield at pit temperature, replacing the +-30 mrad, 40 mm
  wire draft that reached 0.95 sigma_y (recorded in `m5/model_m5.py`).

## Method checks

- Every block prints its rank per interface and for the stack
  (`*/out/checks.txt`); the stack builder generates each interface's
  elements at its true height after a draft in which shifted wires met
  the axis at the wrong height and gave the stack a translation.
- The blade element in the FE reproduces the Jensen-Howell cross-axis
  stiffness 2EI/L to three figures; the wire element is a 3-D
  Euler-Bernoulli beam of true length. Stiffness is condensed to the
  moving layer and re-expressed at the mirror's reference point.
- Stress at range is the fixed-guided beam formula 3Edδ/L² for a wire
  and the cross-axis PRBM bending stress for a blade, both at the
  design deflection; buckling is Euler with K = 0.7 for wires (welded
  ends, one end guided) and pinned in-plane for blades.

## Open items

- Dish: a damping estimate for the 0.19 Hz free mode during slews;
  the CG alignment to 20 mm once the jam-bed mass is known; the rim
  toroid squeeze and roller suspensions are still the first memo's.
- Fold: the 4.1 Hz mode against the beam-centroid pointing loop; the
  relief pad detail; the lever clearance inside the hood.
- M5: five south facets inside the pot sphere; edge facets at 51 deg
  incidence; truss member sizes against the 1.5 kN tie-down.
- All three: FE with real section models (shell or solid) of the
  rigid layers, which the frame FE treats as rigid; a fatigue check
  with the site's gust spectrum; the manufacturing route for the
  welded-wire lattices (fixture drawings).

## Files

```
stage2/
  README.md            this file
  dish/model_dish.py   -> dish/out/{dish_pitch.json, dish_elevation.svg, checks.txt}
  dish/memo_dish.md
  fold/model_fold.py   -> fold/out/{fold_saddle.json, fold_elevation.svg, checks.txt}
  fold/memo_fold.md
  m5/model_m5.py       -> m5/out/{m5_pad.json, m5_patch.json, m5_pad.svg, checks.txt}
  m5/memo_m5.md
```

Run any model with the tandoor venv python from its own directory;
each regenerates its `out/` and the page builder (`../build_page.py`)
embeds the JSON models as the 3-D plates.

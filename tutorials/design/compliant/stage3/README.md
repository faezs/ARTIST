# Stage 3: the mount

Third pass, `fact_mount/`: the mount synthesized by FACT to the end and built from blades. Azimuth: a ring beam on
the deck rail (Hashemi's ring rail) carrying a fork. Elevation: two two-stage cross-blade flexural pivots ON the
axis through F but OUTSIDE the aperture, at |y| 3.25 m (the constraint space of a rotation is the same everywhere
along its axis; there the blades shade nothing and the 6.5 m between them turns the crosswind's moment into a
pair of forces); 71 deg at 0.17 sigma_y, blade SF 10 / 4.7 at 9 / 25 m/s. The dish in a cradle (side arms outside
the rim, C-frame behind, water counterweights up-sun), the tangential-blade diaphragm fine stage (Hopkins
Fig. 4.3) for microradians. Shading by the mount: 0.000 m2 (rasterised along the sun line). The first draft of
this pass (one block at F, struts to the dish) shaded 2.9 % and its blades were overloaded by the crosswind's
moment; the memo keeps both faults beside the correction. `fact_mount/synth.py` prints the six steps with their
checks; `geometry.py` is the member list that `model.py` draws and `synth.py`/`shading.py` check; `memo.md`;
`flower_organs.py` recolours the model organ by organ and writes the botanical drawing; sheets 34-44 on the
register. The pneumatic passes below are kept as the record of how it got there.

## Earlier: the pneumatic mount

The brief of 2026-09-05: a water hose for the frame, actuated like a vine robot so setup and tracking are
automatic; the structural dual of Hashemi's machine, the assembly below the primary like a flower; fractal, the
same stem and skin at every scale. The machine it applies to is the Cassegrain-receiver Hashemi machine on
nix-support (f 4.05, orbit 4 m about F, hyperboloid strip, vertical beam to the ellipsoid M4).

- `hashemi_pneumatic/memo_hp.md`: the mount as a freedom, actuation and constraint topology (Hopkins 2010), coarse-fine:
  a fine exact-constraint flexure stage (three tangential rods + three water columns, `fine_stage.py`) holds the
  dish to microradians behind the pneumatic coarse stage; no deck tendons, so the roof is the dish's sweep.
  Coarse stage:
  freedom space the sphere of rotations about F; constraints four wires through F from an outrigger ring
  (Hashemi's near method puts F on the focal tube through the slot); actuation by pure couples from a flexing
  water-filled stem, plus four pretensioned tendons routed by a clearance solver in the DCM paper's style.
  Checked over 59 Quetta sun positions at 9 and 25 m/s; stays deployed in the survival wind.
- `hashemi_pneumatic/screw_mount.py`: rank and reciprocity checks, unilateral statics, TWSM stiffness,
  actuation space, clearances; `tendon_solver.py`: the line enumeration; `water_stem.py`; `physics_hp.py`
  (sweep, root); `model_hp2.py`: CadQuery scenes; `model_hp.py`, `physics_hp.py`'s rod concept: superseded
  (a compression rod from the deck and hand-routed tendons; its sheets `hp_*` remain).
- register sheets 28-31.
- `flower/`: the first reading of the brief as a self-contained sunflower with a Cassegrain head and the beam
  down its own stem. Superseded: it redesigned the optics, which is the other fork's, and its secondary
  shadow was the wrong turn. Kept for the inflated-hose scale law and the hose sizing.

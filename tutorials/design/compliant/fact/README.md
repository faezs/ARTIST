# FACT synthesis of the mirror mechanisms

Second pass, replacing the catalogue-picked elements of the first memos
with mechanisms synthesized from their freedom spaces by Hopkins'
Freedom and Constraint Topologies method (Handbook of Compliant
Mechanisms ch. 6; Hopkins & Culpepper, Precision Engineering 2010/2011).
`fact_core.py` is the screw algebra: twists `[w; v]`, wrenches
`[f; tau]`, the reciprocal product `w.tau + v.f`, constraint spaces as
reciprocal complements, and an exactness check (rank of the chosen
constraint lines, freedoms left, desired freedoms preserved).
`fact_synthesis.py` designs the three mechanisms and draws the FACT
constraint-line spaces beside the synthesized flexures; its verified
output is in `synthesis_log.txt`.

| mechanism | desired freedom space | constraint space (FACT shape) | synthesized flexure | check |
|---|---|---|---|---|
| beam-down fold tilt | 1 rotation about an axis lying IN the mirror face plane | every line meeting the axis (fans of planes through it, 5-D) | 5 wire flexures: two A-frames standing across the axis with apexes on it, plus one diagonal stay through F | rank 5, 1 DOF left, the rotation about the face-plane axis |
| dish pitch | 1 rotation about the pitch axis through the dish CG | same shape, load-bearing version | two blade planes containing the axis (cross-axis pivot, 6 lines rank 5); two such stages in series about one axis for double range | rank 5, 1 DOF |
| M5 facet | tip + tilt + piston (2 rotations in the facet plane + 1 translation normal to it) | every line lying in the facet plane (3-D) | 3 tangential in-plane wires (exact 3 DOF), then 3 screw contacts take those 3 freedoms: a 6-constraint adjustable mount | rank 3 wires + 3 screws = 6, 0 DOF, adjustable |

What the algebra caught while designing (and a first draft got wrong):
a bipod whose apex sits on the axis spans the whole pencil of lines
through that point in the bipod's plane; if that plane contains the
axis, the axis line is inside the span, two such bipods share it, and
five wires only reach rank 4 (two freedoms left, one of them a
parasitic rotation). Standing each A-frame in a plane transverse to
the axis removes the shared line: 2 + 2 + 1 = rank 5.

Why these are the sophisticated versions: the fold's rotation axis is
remote and material-free, so it can lie in the reflective face plane
where the focal spot is, with no hinge or blade near the beam; the
facet mount has three flexures and three screws instead of three
bipod-carriage assemblies; the dish pitch keeps blades (constraint
planes) for load and gains range the way the butterfly/RCC-series
pivots do, by putting identical 1-DOF stages about one axis in series.

Range ladder for 1-DOF rotational flexures, from the literature
surveyed: cross-spring/cross-axis pivots ~±10-20 deg; the CSEM
butterfly pivot (series of four RCC pivots) ±15 deg at ±50 urad
accuracy and 6 million cycles; Flex-16 monolithic hinge 90 deg; the
large-angle flexure pivot for optical payloads (EPFL/CSEM, 2019)
±90 deg with centre shift under 35 um; LLNL cross-pivot combinations
for enhanced range and load; compliant rolling-contact (CORE) joints
and Hopkins' compliant rolling-contact architected materials (CRAM),
whose strapped rolling surfaces give very large rotations at low
stress but with a moving contact point.

UCLA Flexible Research Group software page (flexible.seas.ucla.edu/
software), checked 2026-09-04: no FACT synthesis tool is distributed
there. Its MATLAB tools are CRAMtool (compliant rolling-contact
architected materials, Shaw et al. 2018), MaterialDesignGUI
(directionally compliant metamaterials, Shaw et al. 2019), an optical
forces simulator (Chizari et al. 2019), Metamaterial.m (Farzaneh et al.
2022) and a mattress-panel design GUI (Yang et al. 2025), all on Google
Drive with no stated licence. The FACT library of freedom/constraint
shapes lives in the papers and the "FACTs of Mechanism Design"
channel; `fact_core.py` reproduces its algebra so the shapes can be
computed rather than looked up.

## Comparison with the authors' tool (MaterialDesignGUI.m, downloaded 2026-09-04)

The supplementary software of Shaw et al. 2019 (repository
jonathanbhopkins/Computationally-Efficient-Design-of-Directionally-Compliant-Metamaterials,
kept untracked under `../resources/`) was read against `dcm_core.py`.

Same in both:
- twist = [omega; c x omega (+ p omega)], wrench = [F; r x F], swap
  matrix Delta = [[0, I], [I, 0]], reciprocity omega.tau + v.f; the
  constraint space of each intermediate freedom space is the null space
  of T * Delta (`null(Tmat*del,'r')` there, `constraint_space` here);
- a wire is admissible iff its line lies in that space: they test it at
  a point R by the 3 x C matrix `R x F_i - M_i` whose null space is the
  pencil of constraint lines through R (`FullMat`/`Cap`); `elements_1R*`
  here generate the same pencils analytically for lines meeting an axis;
- exactness by rank of the wrench set (LU pivot test there, SVD rank
  here); the stack keeps the freedoms of its interfaces in series;
- stiffness: each wire an Euler beam (EA, EI, GJ; their 6 x 6 free-end
  compliance inverted and transformed by [n; r x n], our 12 x 12 beam
  condensed) between rigid stages with six DOF each (`EulerStiffnessMatrix`
  there, `frame_fe` here); a rigid layer per stage.

Different:
- generation: they sweep random points on the cell's top face and random
  directions in the pencil, project to the bottom face, reject lines that
  leave the cell or come closer than 2r to another wire, and stop at
  exactly 6 - n independent wires per cell (minimal); when no line fits
  between the faces after `dropdown_threshold` tries they grow a side
  wall ("dropdown") of depth d from the layer and land wires on it. We
  generate deterministic oblique families (+-45 and +-35 deg in two
  plane sets) with 5 wires per cell, redundant by design (R-DCM-1), and
  never needed dropdowns because a 1R space always has lines through
  both faces.
- dynamics: they build a mass matrix from each layer as a slab and solve
  eig(M \ K) for the block's own modes (twist mode shapes); we report
  the eigen-stiffness ratio of the condensed 6 x 6 and the first mode
  with the mirror's inertia, which is the mode that matters here.
- materials: their defaults are E 200 GPa, G 70 GPa, rho 2700 for the
  demo; ours are per structure (Ti-6Al-4V, 17-7PH).
- output: STL of the block there; JSON parts for the register page's
  three.js viewer here.

Nothing in the tool changes the stage-2 numbers; the port's algebra is
the paper's, and the check that ours reproduces its Examples 2-3 stands.

# Beam-down fold at F: the saddle as a directionally compliant lattice

Second-pass design, replacing the two cross-axis pivots of the first
memo. Requirements from `../../brief.md` section 2.2 and the rules in
`../../brief_robustness.md`; method from `../../fact/dcm_core.py` (Shaw
et al. 2019); numbers from `model_fold.py`, whose printed checks are in
`out/checks.txt`; geometry in `out/fold_saddle.json` (page viewer) and
`out/fold_elevation.svg`.

## 1. What it is

The mirror (0.36 x 0.44 m elliptical 6061 plate, 12 mm, integral fins,
protected silver, ~7.5 kg) hangs face-down at F from the bottom rigid
layer of a lattice block on its back. The block is five open Ti-6Al-4V
frames (rigid layers, 12 mm) separated by four 40 mm gaps; every gap is
bridged by 40 oblique Ti wires (d 1.0 mm), five per 100 x 100 mm cell,
each wire's line meeting the tilt axis, which is the y axis lying IN the
mirror face plane through F. The top frame bolts to the yoke that hangs
from the carriage's azimuth bearing at the post top; the hood (fixed to
the yoke) surrounds the mirror with a 40 mm insulating-firebrick rim.
Azimuth is the carriage's; the block provides exactly one rotation.

| block | value |
|---|---|
| footprint / height | 400 x 200 mm / 220 mm (z 60..280 above the face plane) |
| layers / interfaces | 5 / 4; gap 40 mm; layer 12 mm, 35 % open frames |
| wires | 160 (40 per interface, 8 cells x 5), Ti-6Al-4V d 1.0 mm |
| tilt axis | y through F at z = 0, in the reflective face plane; nothing at the axis |
| range | 7.6 deg per interface at 190 MPa (0.25 sigma_y at 120 C) -> 30.6 deg for 4 interfaces, working 27 deg (15-42 deg tilt) |
| neutral state | the park stop (42.5 deg, beam onto the hood rim): power loss returns the mirror to park (R-DCM-2) |
| mass | lattice 7.5 kg (wires 0.02 kg, frames the rest), mirror 7.5 kg |

## 2. Why this topology (FACT)

Freedom space: one rotation about the y axis through F. Constraint space
(5-D): every line meeting that axis. Per interface the 40 wire lines
span it exactly (rank 5, one DOF left, the rotation about the axis
through the origin); the stack of four interfaces in series keeps the
same single freedom. The algebra, printed in `out/checks.txt`, also
records the trap of the first draft: wires generated at one interface
height and then shifted keep their directions and meet the axis at
another height, so the stack gains a translation (DOF 2); the stack
builder now generates each interface's wires at its true gap centre.
Redundancy: removing any one wire leaves rank 5 and changes the
interface stiffness by 2.5 % (R-DCM-1).

## 3. Numbers from the frame FE

Rigid frames as bodies with six DOF, each wire a 3-D Euler-Bernoulli
beam of its true length, bottom frame fixed, condensed to the top
frame, then expressed at F.

| quantity | value | requirement |
|---|---|---|
| softest direction | rotation about y with the centre at F (eigenvector u_x/(theta_y L) = 0.68 = z_top/L) | the intended DOF |
| compliant / stiffest eigen-stiffness | 5.0 x 10^-5 | R11 ratio >= 1000: met 20x |
| K_theta about the face-plane axis | 86.9 N m/rad (same along the softest mode) | |
| actuator torque at 27 deg from park | 41 N m; 205 N on a 200 mm lever; stored energy 9.7 J | stepper + 2 mm-lead self-locking screw (R6) |
| stiff directions at F | k_x 2.4, k_y 2.4, k_z 7.4 kN/mm; K_thx 88, K_thz 65 kN m/rad | mirror weight sags 10 um |
| first mode, 7.5 kg mirror about the axis | 4.1 Hz | gust band 0.1-2 Hz: 2x above its top; raise with 1.2 mm wires (x2) if the pointing loop needs it |
| wire stress | 190 MPa at full range (by sizing); axial 2.4 MPa hanging | R3 0.25 sigma_y(T) |
| buckling | P_cr 70 N per wire vs 0.5 N reversal from a 20 N gust on the sheltered mirror: SF 141 | R10 >= 3 |
| thermal, +40 K uniform | virtual axis moves 0.06 mm, no tilt (symmetric lattice); Al mirror grows 0.40 mm, taken by radial relief pads between the backplate and the bottom frame | R7 < 2 mrad, R8, R9 |

## 4. Heat

The lattice sits behind the mirror's back plate and fins; the beam
never reaches it (the mirror is face-down and the hood rim takes any
spot walk). With 210 W absorbed and the finned back the plate runs
ambient +35 K; the bottom frame is coupled to it through the relief
pads and reaches perhaps +20 K, the upper frames ambient. Ti-6Al-4V at
120 C keeps 760 MPa yield and shows no stress relaxation at 0.25
sigma_y; the wires are never above ~60 C. A 250 C fault soak (10-minute
loss of tracking) is taken by the hood rim, not the lattice.

## 5. Weak-link order and safe state

1. Power loss or controller fault: the actuator's self-locking screw
   holds; if the pawl/latch is released (watchdog, 200 C snap-disc), the
   lattice returns the mirror to its neutral position, the park stop,
   in a fraction of a second; the beam lands on the firebrick rim.
2. Over-temperature at the mirror: the snap-disc opens the latch before
   the silver or the pads are damaged.
3. Over-wind: the hood, on the yoke, carries the wind; the lattice sees
   the sheltered mirror only. A 25 m/s case loads the yoke, not the
   flexures.
4. Structural overload: individual wires fail first, each costing 2.5 %
   stiffness and no freedom; the frames and the yoke are the strong
   links.

## 6. Manufacture

Frames wire-EDM or milled from 12 mm Ti plate (five identical parts);
wires 1.0 mm Ti-6Al-4V drawn wire, laser-welded or brazed into pilot
holes whose axes are set by a drilling fixture from the same CAD
(the oblique angles are +-45 deg and +-35 deg families in two plane
sets); alternatively the whole block as one additive Ti part with the
wires printed at 1.0 mm (needs a printer that holds 45 deg overhangs at
that diameter; the welded-wire route is the low-risk one). Mirror
plate machined from 6061 billet with fins; radial relief pads (three
slotted Ti pads) between backplate and bottom frame.

## 7. Open

The 4.1 Hz first mode against a beam-centroid pointing loop; the pad
relief detail; the actuator lever clearance inside the hood; the
receiver-at-focus chain downstream (M3/M4/chase) is not this memo's.

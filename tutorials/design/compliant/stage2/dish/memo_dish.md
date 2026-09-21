# Primary dish pitch stage: a distributed cross-axis blade bearing

Second-pass design for the beta/2 pitch of the 2.10 m pumped-membrane
dish. Requirements: `../../brief.md` section 2.1 (pitch +-18 deg about
the axis through the CG; 0.34-2.6 kN m; 9 / 25 m/s wind; 140 kg design
mass, 250 survival) and `../../brief_robustness.md`. Numbers from
`model_dish.py` (`out/checks.txt`); geometry `out/dish_pitch.json`,
drawing `out/dish_elevation.svg`.

## 1. What it is

Between the yoke beam (ground, carried by the arc-rail followers) and
the rim carrier beam (stage, bolted to the rim ring and backing) runs a
2 m long row of twelve cells; each cell is a pair of thin 17-7PH blades
crossing ON the pitch axis at +-45 deg. Every cell is an exact one-DOF
pivot; the row is one monolithic distributed bearing along the whole
width of the dish instead of two pivots at its ends.

| item | value |
|---|---|
| blades | 24, 17-7PH CH900, 150 x 0.8 mm, 120 mm long at 45 deg, crossing on the axis |
| cells / span | 12 at 165 mm pitch, 1.98 m along the axis |
| beams | yoke 40 x 60 mm, carrier 40 x 60 mm, 2 m, 40 % open; 85 mm gap |
| range | 38 deg from neutral at 0.30 sigma_y (need +-18) |
| neutral state | beta = 0, the retro orbit: shadowed but safe |
| mass | blades 2.7 kg, beams 30 kg |

## 2. FACT

Freedom: one rotation about the axis through the CG (y). Constraint
space: every line meeting the axis. Two blade planes containing the
axis give six lines of rank 5 per cell; the row of 12 cells is 72
lines, rank 5, one DOF left, the rotation about the crossing line
(`out/checks.txt`). One blade removed: rank 5, no new freedom, 4.2 %
less stiffness (R-DCM-1).

## 3. Frame FE (blade beams with true section, matched to the PRBM)

The blade element reproduces the Jensen-Howell cross-axis stiffness
2 EI/L = 21.3 N m/rad per pair to three figures, so the numbers below
are the PRBM's, computed for the whole row at once.

| quantity | value | requirement |
|---|---|---|
| K_theta about the pitch axis | 261 N m/rad | |
| spring torque at 18 deg | 82 N m | |
| actuator: spring + 9 m/s wind moment + gravity | 512 N m = 640 N on the 0.8 m lever; Tr20x4 self-locking screw | R6: position by the screw |
| stiff directions | 2.4 MN/mm across, 7.6 MN/mm along the axis; MN m/rad about x and z | ratio 9 x 10^-9 |
| blade bending stress at 18 deg | 213 MPa = 0.14 sigma_y; daily Goodman with sigma_a = sigma_m = 107 MPa | R3 <= 0.30, R5 |
| in-plane load per blade | 68 N at 9 m/s (dish weight + drag through 24 blades at 45 deg); 286 N at 25 m/s survival | |
| buckling | P_cr 3.57 kN per blade: SF 52 working, 12.5 survival | R10 >= 3 |
| free pitch mode, 140 kg dish (I 185 kg m2) | 0.19 Hz, inside the 0.1-2 Hz gust band | see below |
| thermal +40 K | steel blades and beams grow together, the axis stays on the crossing line by symmetry; the Al rim differs from the steel carrier by 1.0 mm over 2 m: radial relief at the carrier-rim bolts | R8, R9 |

The 0.19 Hz is the mode of the dish on the blades alone. While
tracking, the pitch is defined by the self-locking screw on its 0.8 m
lever (R6), and the mode that matters is the dish on the screw chain
(~kN/mm at 0.8 m: tens of Hz); the blade mode exists only during a
pitch slew, when the drive is the damper. The eddy-current damper of
the first memo stays on the tow-wire drum, not here.

## 4. Loads and weak-link order

The dish weight and wind drag pass through the blades IN PLANE at 45
deg, where a 150 x 0.8 mm strip is stiff and strong; the only bending
is the pitch itself. Survival (25 m/s, 3.05 kN m) engages the hard
stops (R4): the blades then see 286 N in-plane, SF 12.5 on buckling,
and no extra bending. Order of release: the wind trip (bistable arch,
first memo) vents the membrane and commands stow before any blade
approaches its limit; a blade that fails leaves 23 and one DOF; the
beams and the screw are the strong links.

## 5. Manufacture

Two 2 m beams (steel, welded or machined), 24 blades laser-cut from
0.8 mm 17-7PH sheet and clamped in milled 45 deg seats with keeper
bars (or a single wire-EDM'd monolith per cell from 90 mm plate, six
parts along the beam). Assembly on a jig that fixes the crossing line
to the carrier's CG datum within 20 mm (R8).

## 6. Open

The rim toroid squeeze and the roller suspensions are unchanged from
the first memo; a pitch slew's transient at 0.19 Hz against the drive
needs a damping estimate; the 20 mm CG alignment must be re-checked
once the real jam-bed and hub masses are known.

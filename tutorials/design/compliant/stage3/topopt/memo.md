# The Handbook's algorithms, used (chapter 6 FACT, chapter 7 topology optimization), and the head as it is built

The user's instruction after reading chapters 6 and 7 from their pictures: "i need you to use their algorithms". What was
done, what it found, and what it changed.

## Chapter 6, Hopkins: FACT on the strut joints (`fact_ball.py`, sheet 60)

Hopkins's four steps run in screw algebra (`fact/fact_core.py`) for a strut end: the DOFs are three rotations about the
joint centre; the freedom space is the sphere of rotation lines (3-DOF Type 3, Fig. 6.8b); its constraint space, by
reciprocity, is every pure-force line through the centre (a wire missing the centre by 1 mm resists a rotation and is
rejected by the test); three independent lines not coplanar are the wire tripod of Fig. 6.8c (rank 3, exactly the three
rotations; two wires leave a screw, three coplanar wires are dependent, as the chapter says on p. 85); step 4 is the
equivalence of Fig. 6.7a, each wire replaced by two orthogonal blades in series, checked to have exactly a wire's five
freedoms. The decisive design fact is kinematic: both rings of the hexapod are defined from the head pose, so the six leg
lengths are constant over the day and the joints only turn with the loop's corrections (the production runs used 7 mm of
leg stroke at most, 0.4 deg at the calyx end; the loop's clip is the joint's design variable). The audit corrected the
first sizing: a blade riding the body's rotation theta about C also has its end displaced by theta x s, so its worst
curvature is (1 + 6 s_mid/L) theta/L, four times pure bending for a blade starting at C and eleven for the second of a
stacked pair; at the old +-40 mm clip no blade meets bending and buckling at once. At +-15 mm (twice the runs' usage)
stacked Ti blades 0.8 x 120 x 20 mm at 13 and 36 mm from C hold 388 MPa and SF 9.8 on Euler at the 14 kN survival strut
load, and the joint is 2.9 x the strut's EA/L (the leg keeps 59 % of its stiffness, the crown 12 Hz). Wire tripods cannot
carry the survival compression at any length that bends. Both simulations' clip is now +-15 mm. Sizing is outside FACT
(the chapter keeps to kinematics, p. 82) and says so.

## The flexure ball, built (`fact_ball_cad.py`, `fact_ball_views.py`, sheet 60)

The user asked for a drawing good enough to 3D print. Building the solid refuted three things the section drawing could not see.

1. **The blade widths were impossible.** The section sizing chose 120 mm wide blades 36 mm from C. Three legs on a 35 deg cone
   share an arc of 43 mm there, so a blade whose width runs circumferentially can be 37 mm at most. Only ONE blade of each pair
   has its width circumferential (the other's lies in the meridional plane and is free), so the sizing is per blade.
2. **The hub pushes the blades out.** The hub carries the 85 mm strut tube. The strut is above C and the legs below it, so the hub
   can neck down to 14 mm at C and the legs can start there; if it does not, the inner blade sits inside the hub and the
   (1 + 6 s/L) amplification, which grows with the station, eats the whole stress budget. At 35 deg with a fat hub, nothing fits.
3. **The cone angle is a result, not a given.** A shallower cone reaches the flange radius further out along the leg (more
   amplification); a wider one loses cos^2(alpha) of axial stiffness. Searched, the answer is 30 deg.

The objective also had to change. Maximising stiffness inflates the joint without limit; the requirement is that the joint not
dominate the leg, so the objective is the SMALLEST joint that reaches twice the strut's own EA/L. As built: cone 30 deg, blades
2.2 mm thick, 68 mm wide circumferentially and 140 mm meridionally, 65 mm free, at 71 and 140 mm from C, 438 MPa at the loop's
+-15 mm clip, Euler SF 12, 385 MN/m = 2.1 x EA/L, 266 x 293 mm and 2.88 kg of Ti. Twelve of them add 35 kg to a crown whose
struts weigh 62 kg.

**And building it argued for a different part.** The same three rotations about C come from one turned waist 8.0 mm across and
14.8 mm long: 440 MPa at the same rotation, the same 368 MN/m, 109 x 123 mm, 1.19 kg. Its price is a restoring moment of 22 N m
per joint (15 N at the strut, against loads of kN) and 282 MPa of compression at the 40 m/s gust on top of the bending, which is
0.8 of yield. For this duty - a rotation of a degree and an axial load of kilonewtons - the waist wins on every count. The tripod
remains the chapter's construction and the one that makes the constraint topology visible, which is why both are drawn and both
are exported.

Printing: one monolithic body each (the first three builds came out in two and three loose pieces, which is the check that
matters), flange down, no support anywhere; blades within 35 deg of vertical and the waist's cones at 45. Four files in `out/`:
two machine parts in Ti as STEP and STL, two demonstrators in PLA whose sections are scaled by (sigma_allow/E)_pla /
(sigma_allow/E)_ti = 1.8 so the printed part reaches its rotation at the same fraction of its own yield - the tripod at +-1.5 deg
over 213 x 120 mm, the waist at +-4 deg over 109 x 139 mm. Three stops on the tripod touch at 1.5 x the design rotation; a groove
marks the C plane on both, because the whole point is the point everything turns about.

## Chapter 7, Frecker: ground structure and SIMP (`ground_truss.py`, `simp_cm.py`, `mma1.py`, sheet 61)

A dense truss ground structure with member areas as variables, a volume fraction, and MMA (Svanberg 1987, one constraint,
our own 60 lines: the closed-form primal x(lambda), lambda by bisection); objectives: minimum compliance (Fig. 7.2) and the
compliant-mechanism objective of Eq. 7.5 (maximise u_out against input and output springs) by the adjoint. Validated on
the chapter's own examples: the displacement inverter of Fig. 7.3a (the diamond appears; output opposite to input) and the
half pliers of Fig. 7.5 (a compliant pivot pair over the symmetry line). SIMP (sec. 7.4.1, Eq. 7.3-7.5, the 88-line
structure: Q4 elements, density filter, penalty 3) reproduces Fig. 7.8's inverter. Lessons: the optimality-criteria update
cannot take the mixed-sign sensitivities of a mechanism objective, hence MMA; the output's sign must be asked for (a
"maximise u_out" without a direction gives a pusher, not an inverter); coincident nodes make zero-length members and NaN.

Applied to the flower as stiffness parts: the calyx (rim to the six anchors under the 15 m/s peak load) and the receptacle
(six anchors to the wrist under alternating 3.5 kN): both come out stress-trivial (5-20 MPa) and stiffness-sized; their
mass is whatever volume fraction one asks for, which is the method's honest limit.

## The head as it is built (`ring_calyx.py`, `membrane_wind.py`, sheet 62)

The user's corrections in order: "the annular plate must be modelled accurately not ideally"; "before you commit to
annular, the production model is a beam-down that doesn't pass through the dish" (no hole: the drag area in both
simulations was corrected to the full disc); "it's not solid, it's a mylar membrane, you can find how it's modelled
already" (the repo's FvK solvers); "we're using RL to control the membrane"; "shouldn't wind gust cancelling be ideal for a
compliant mechanism?".

So the head is a 50 um aluminised Mylar film on a ring, pumped to f 4 (1-D axisymmetric FvK, hashemi.ini's five zones,
zone_c 0.4, T_pre 2000 N/m: centre pressure 1370 Pa, sag 276 mm, rim tension 4.5 kN/m). Its pull on the ring is 4.4 kN/m
inward (9.2 kN of hoop compression, 7.6 MPa in a 100 x 4 Al tube) and 1.1 kN/m toward the vertex (15 kN in all, the
pressure integral). The ring as frame elements and a spider by ground structure to the six anchors: 24 kg, and the ring's
motion under the 15 m/s gust is 0.4 mm of n = 1 (0.15 cm at F) and 0.1 mm of n >= 2 (0.06 cm): the structure is not the
problem.

The film is. Its figure follows its differential pressure p_plenum - p_face: df/dp = -1.4 mm/Pa, 3.6 mrad rms of slope
change per 50 Pa, and a 9 m/s wind is 58 Pa mean with 29 Pa rms of gust; 12 m/s is 104 and 52; 15 m/s 162 and 81. On a
constant-pressure supply (a blower holding the plenum's gauge pressure) the wind passes one to one: the mean alone
defocuses 3-9 cm at F; the RL policy's one action per 20 s trims the mean and leaves 79-86 % of the gust variance; a local
pressure loop at 0.5 Hz leaves 0.5 / 1.1 / 1.8 cm rms. The first version proposed a constant-force regulator on a
diaphragm as the compliant canceller; the audit refuted it twice over: a regulator on the plenum holds p_plenum against
ambient and cannot see the face, so the wind still drops the differential by its full pressure, and a 140 kg bell is a
second-order system with a corner near 0.2 Hz. The compliant canceller is the opposite: SEAL the plenum between the pump's
trims. The trapped air is then a constant-volume regulator: the film cannot change its volume (0.73 L/Pa from the rim
plane) without compressing 1.9 m3 of air at 82.7 kPa, a gas spring 32 times stiffer than the film, so the differential
pressure rises to meet the wind and 3 % of it reaches the figure: 0.1-0.3 cm of defocus for the mean, 0.05-0.14 cm rms for
the gusts, the whole spectrum, at acoustic speed, with no moving part, no sensor, no port. The seal's cost is thermal: 1 K
on the trapped air is 282 Pa, 9 Pa of differential after the film yields, slow, and the RL policy's pump trims it and the
leakage at its 20 s step. The five zones are five sealed volumes with the same argument each.

What no pressure can touch: the pitching moment as a pressure gradient 8 c_M q x/a. The linear membrane response
w1 = p1 r (a^2 - r^2) cos(theta) / (8 T a) has zero mean slope over the disc (w1 vanishes on the rim), so it moves no image
centroid and hands the head loop nothing; its rms slope is 0.0425 mrad/Pa at the working tension, all blur: 2.1 / 3.8 /
5.9 mrad rms at 9 / 12 / 15 m/s, 1.7 / 3.0 / 4.7 cm at F. The 2-D FvK difference of two solves on one mesh gives 4.6 mrad
at 15 m/s against the linear 5.4 on the same inner-95 % mask (the disc-wide mean vanishes only over the whole disc). That is
the membrane's floor under wind, and the simulations' membrane term now uses it (slope 2.63e-5 V^2 rad) in place of the
audit's scaled formula, which assumed T 20 kN/m.

## The audit of this work (opus workflow, 99 agents, `out/audit_findings.json`)

Five auditors, one per script, prompted to refute against the chapter pages, the code and the outputs; two verifiers per
finding (mathematics, reproduction). 47 findings, 36 stood. Applied: the blade stress rule and the joint's rotation and
clip (above); the survival load citation (wind_size.py's 16.6 kN drag, 7.7 kN lift, 16.7 kN m, not a "60 kN drag" that was
the stem's root moment misread) and the runs' logged strut maximum (5.0 kN, not 3.5); "stiffness and dynamics" as the
chapter's exclusion, not strength; the calyx's hinge moment on the audit's peak constant (10.07 N m per (m/s)^2) applied
once, not twice; the receptacle's weight share (256 N per strut, not 1 kN); one threshold (5 % of the cap) for the drawn and
counted members; the inverter's docstring (the actuator pushes into the domain; Fig. 7.3a mirrored) and the pliers as a
pliers-like problem, not Fig. 7.5's cells; the density filter attributed to Bruns-Tortorelli and Bourdin, the chapter's own
remedy for hinges being the robust formulation; the ring's wind load built from the 1-D solver's change of vertical line
load (uniform part) and linear theory (n = 1), the 2-D readout's sign convention being the 1-D solver's opposite; the ring's
stress read from the solved frame elements (13.8 kN, 14.8 MPa, not the free ring's 9.2 kN); the spider's mass stated as
the volume fraction asked for; the volume per pascal from the fixed rim plane (0.73 L/Pa, not 0.61 from the moving
vertex); a first-order controller's residual weight f^2/(fc^2 + f^2) in place of a brick wall; the 2-D check compared with
linear theory on the same mask; and the constant-pressure regulator replaced by the sealed plenum.

The 2-D FvK solver is mesh-limited at this sag (6-7 mrad of discretization slope error at 121-161 cells; the env's own
figure numbers come from the 1-D solver), so absolute figures are taken from the 1-D solver and the 2-D solver is used only
for differences on one mesh.

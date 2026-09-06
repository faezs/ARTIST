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
lengths are constant over the day and the joints only turn with the loop's stroke, +-1.6 deg. Wire tripods of 6 mm Ti
hold the 40 m/s survival load but halve the leg's stiffness; stacked Ti blades 1.0 x 50 x 15 mm make a joint twice as
stiff as the strut with SF 14 on buckling. Twelve joints, 72 blades, no bearings. Sizing is outside FACT (p. 82) and says so.

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

The film is. Its figure follows its differential pressure: df/dp = -1.4 mm/Pa, 3.6 mrad rms of slope change per 50 Pa,
and a 9 m/s wind is 58 Pa mean with 29 Pa rms of gust; 12 m/s is 104 and 52; 15 m/s 162 and 81. Uncontrolled, the mean
alone defocuses 3-9 cm at F. The RL policy trims the mean and the slow gusts (one action per 20 s leaves 85-91 % of the gust
power). A local pressure loop at 0.5 Hz leaves 0.5 / 0.9 / 1.6 cm rms. The compliant answer is better than either: a
constant-force element (Handbook 12.3.3) on a rolling diaphragm holds the plenum's differential pressure at the policy's
setpoint while air flows to and from the film's changing volume (0.61 L/Pa: 18-50 L per 1-sigma gust, 150 L at the 3-sigma
peak of 15 m/s; a 1 m2 diaphragm with +-22 cm of stroke at 1.37 kN, or the gasometer's 140 kg bell; a 0.15 m duct), at
acoustic speed, with no sensor, no electronics, no hysteresis. The RL sets the setpoint, the mechanism holds it.

What no pressure can touch: the pitching moment as a pressure gradient 8 c_M q x/a. The linear membrane response
w1 = p1 r (a^2 - r^2) cos(theta) / (8 T a) has zero mean slope over the disc (w1 vanishes on the rim), so it moves no image
centroid and hands the head loop nothing; its rms slope is 0.0425 mrad/Pa at the working tension, all blur: 2.1 / 3.8 /
5.9 mrad rms at 9 / 12 / 15 m/s, 1.7 / 3.0 / 4.7 cm at F. The 2-D FvK difference of two solves on one mesh gives 4.6 mrad
at 15 m/s against the linear 5.9. That is the membrane's floor under wind, and the simulations' membrane term now uses it
(slope 2.63e-5 V^2 rad) in place of the audit's scaled formula, which assumed T 20 kN/m.

The 2-D FvK solver is mesh-limited at this sag (6-7 mrad of discretization slope error at 121-161 cells; the env's own
figure numbers come from the 1-D solver), so absolute figures are taken from the 1-D solver and the 2-D solver is used only
for differences on one mesh.

# Fifth pass: the flower proper. One stem, the membrane on the crown, F on the light pipe

The user's words (2026-09-06): "one trunk and lots of branches that form a scatter pattern and are all rooted on
that single flower trunk ... the foliage is oddly shaped in one direction only, and it has not a parabolic but a
spherical section cut out of it, a volumetric section, which is the only geometry that is fixed focus on the
target ... it would need a 1 m stem ... the light pipe will be on the roof itself separate of this. it's not a
cassegrain so much as a masdar hyperboloid beamdown. look at the actual geometry i'm using in hashemi.ini ...
you're putting our membrane on the foliage for the exact primary dish."

## The reading

- The reflector is the exact primary of `hashemi.ini` and the env: the pumped membrane, a spherical cap of radius
  8 m (a 2.1 m, f = g_orbit = 4 m). The env's docstring says why the sphere: "the primary is a SPHERE, it has no
  optical axis". The crown of branches is the dish's frame: the tips of the twigs lie on the sphere and the membrane
  rests on them, so the concave inner surface of the foliage is the spherical section, and it is the same sphere
  wherever the head goes. The foliage is shaped in one direction because the head always sits on the anti-sun side
  of F: north of the pipe, and east or west of it morning and evening.
- The light pipe is the cass machine as it is: the bore r 0.7 (r_bore) up to the fold F at z_deck + 0.35 +
  max(g sin el + a cos el) = 4.87 m over the deck, the hyperboloid strip d_strip 0.6 m before F (r_strip 0.6), M4
  and the duct below. It stands on the roof, separate of the tree; the head's images land on the strip and go down
  the pipe, a Masdar beam-down in miniature. Hashemi's north arm (arm_north 3.0) is not needed: the strip sits on
  the pipe.
- The one trunk is a 1 m stem, r 0.15 m, 2 m north of the pipe; the branches root at its top (the receptacle):
  six primaries to r 0.8 on the head's back, twelve secondaries to r 1.45, sixty twigs whose tips carry the
  membrane (a Vogel scatter over the aperture). No fork, no neck, no yoke, no counterweight arms.
- Why one stem is enough here and was not in the second pass: the second pass's lesson was derived for a
  paraboloid, which needs both the vertex at F - 4 s and the axis along s. The sphere needs only its centre of
  curvature at F + 4 s; its attitude about that centre is free, and the env's beta_dev schedule already spends that
  freedom (the head off the retro point of the orbit, its axis the bisector of the sun and the line to F).

## The head's path as the env drives it (`sweep.py`, `out/sweep.txt`)

With the ini's beta_dev 0 the head is retro: hub at F - 4 s, axis along s (the env's `_beta_now`; beta_cap_z 7.6
is inert at beta_dev 0). Over the year the hub moves in a box 4.1 x 7.7 x 3.1 m (x -0.9..3.2 m north of the pipe,
y +-3.9 m, z 0.9..4.0 m over the deck), the head axis follows the sun's elevation 12-83 deg, the rim runs from 0.35
to 6.1 m over the deck. The primaries from the receptacle are 0.7-1.1 m at equinox noon and 4.2-5.6 m at 8 and 16 h:
the crown is not a fixed shape but a mechanism that carries the head around a quarter of the orbit sphere.
The pipe and strip shadow the aperture by 24.3 % mean at retro on this pass's own model (audit F6: the env's 33 % is the fold machine's); beta_dev 36 takes it to about 1.6 %.

## What gates it: wind (`sweep.py`)

Drag on the 13.9 m2 head with Cd 1.3 at 1680 m: 0.75 kN at 9 m/s, 1.34 kN at 12, 5.8 kN at 25. The image at F
walks 1:1 with the head's centre of curvature (half power at 0.7 deg of head rotation = 4.9 cm at F, from the
env), so the crown must hold the head to about 5 cm: a stiffness of 15 kN/m at 9 m/s and 27 kN/m at 12 m/s before
gusts. A 5 m cantilever needs EI 630 kN m2 for that: one 150 x 5 mm steel tube is 380 kN m2; an inflated hose of
r 0.25 m at 40 kPa wrinkles at 1.0 kN m, i.e. carries 0.2 kN at 5 m. The crown of a flower this size in Quetta's
wind is wood or steel, not hose, unless the head is parked low and still. That is the trade the sphere offers: a
head that stays near the bottom of the orbit sphere and turns only half the sun's motion (beta = half the sun's
angle from the park direction) shortens the branches to 1-3 m and keeps the rim under 2.6 m (beta_cap_z), at the
price of beta up to 40 deg at low sun and the sphere's off-axis blur 8 (1 - cos(beta/2)) that the relay must eat;
`path.py` explores that family. Which point on that trade the machine takes is the optics fork's call.


## The crown sized for wind (`wind_size.py`, `out/wind_size.txt`)

Loads are the audit's: the mean-wind pressure with a peak factor of 3 (Iu 0.2-0.3 at 8 m over a roof), Cd 1.3,
the hinge moment c_M 0.34 and lift, giving on the 13.85 m2 head 3.05 kN, 0.82 kN m and 1.41 kN at a 9 m/s mean,
5.4 / 1.45 / 2.5 at 12, 8.5 / 2.3 / 3.9 at 15 (the stow decision), and for survival a 40 m/s 3-s gust: 16.6 kN,
16.7 kN m and 7.7 kN unstowed, or 1.0 kN, 3.9 kN m and 17.5 kN of uplift stowed face-up over the deck. The pointing
criterion is the env's: the image at F walks with the head's centre of curvature C = P + 8 n, half power at 4.9 cm.

A crown of cantilever branches cannot hold that: the Leonardo tree has a sixth of the trunk's second moment at
every branching. The crown that can is a hexapod: the six primaries become six struts from a receptacle ring at the
stem top (r 1.0 m) to the head's back ring (r 1.5 m), extensible (screw or hydraulic), which is also the mechanism
that moves the head. Solving the hexapod's statics and compliance at the still-head schedule's poses:

- on the env-law poses the worst is day 50 at 10 h (hub 3.0 m north, 2.1 m west, 3.1 m up; legs 1.3-5.2 m).
  Receptacle r 1.5: leg forces 13 kN at the 9 m/s peak, 35 kN at 15 m/s, 28 kN stowed in the gust, 128 kN
  tracking through it; steel CHS 85 x 5.3 mm (225 kg for six) holds the image within 1.2 / 2.2 / 3.4 cm at 9 / 12 /
  15 m/s with a first mode at 16 Hz; 115 x 7.2 (413 kg) to track through the gust. A receptacle of r 1.0 needs
  115 x 7.2 for the same duty and walks 3.3 / 5.8 / 9.1 cm; r 0.6 fails (10 cm at 9 m/s). At equinox noon the legs
  are 0.8-1.8 m and 45 x 3 would do: the mornings size the crown.
- water columns as legs fail by two orders of magnitude: a fabric hose (E t 500 kN/m) has a column modulus of
  2 MPa from its wall's hoop compliance, 69 m of image walk at the 9 m/s peak; a steel-wound hose 7 m. The legs are
  rigid struts; the water may drive them but cannot be them.
- the stem: root moment 12 kN m at the 9 m/s peak, 34 at 15 m/s or the stowed gust, 56 unstowed: steel CHS 215 x 9
  mm (44 kg), whose 2 mrad of tip rotation at the 9 m/s peak is 2 cm at F over the 9.7 m lever to C; an inflated
  stem of r 0.4 needs 3.4 bar to avoid wrinkling and turns 121 mrad: it is a hinge, not a stem.
- the calyx under the membrane: 74 N per tip at the 9 m/s peak (405 N in the unstowed gust): twigs 18 mm (34) and
  secondaries 40 mm (72) in aluminium; the membrane sees 320 Pa (1750 Pa) of pressure difference.

Total image walk at the 9 m/s peak, receptacle r 1.5 and steel legs: 1.2 (legs) + 1.8 (stem) = 3.0 cm of the 4.9;
at 12 m/s 5.6 cm, so the stow decision sits near 11 m/s mean unless the stem grows to 273 mm or the legs to 115 x 7.2.

Where the hexapod can carry the head, on the env's own law (`path.py`, rewritten after audit F2: the head on the
orbit sphere |P - F| = 4 with its axis the bisector of the sun and the line to F, beta within the env's validated
36 deg; the hub within 1.0-3.0 m of a receptacle 3 m north of the pipe; the rim 0.3 m over the deck): 351 of 479
daylight samples over the year; the hours before 9 and after 15 are beyond reach, and so is the winter-solstice
noon. On the reachable part beta is 20 deg mean and 36 max, the hub moves in a 3.5 x 4.9 x 2.8 m box (x 0.2-3.8 m
north of the pipe, y +-2.4 m, z 0.9-3.7 m), and the pipe and strip shadow the aperture 12.7 % on average (21 % at
worst) against 24 % at retro: staying within 36 deg of retro keeps the pipe in the light. The hexapod therefore
gives about three quarters of the day from one fixed stem; the rest needs the pedicel (a luffing, slewing arm from
the stem top to the receptacle) or the rail. Sheets `tw_*`.

## Audited (the seventh auditor, on this pass; `../audit/findings.md`)

- F2, blocking: the family P + R n = F + (R/2) s is the sphere's PARAXIAL focus, the focus of the zone straddling the
  axis through C parallel to s; a cap mounted off that axis by theta does not image at F (traced: 0.22 m rms at
  theta 15, 0.37 at 20). The exact law is the env's: the head on the orbit sphere |P - F| = R/2 with its axis the
  bisector of s and the line to F, blur a (beta/2)^2 (0.10 m rms at beta 25, 0.15 at 36). So the sphere's freedom is
  the whole orbit sphere (ub free), not "attitude free about C", and a head that does not move pays the FULL sun
  angle as beta (60 deg at 8 and 16 h at the equinox: 0.29 m rms, dead). The still-head schedule of `path.py` is
  withdrawn; the head must travel the orbit sphere within about 36 deg of retro.
- F3, blocking: a vertical pipe r 0.7 through F lies inside the membrane's swept shell (4.00-4.27 m from F) in
  30 % of the year's poses, worst 11 % of the aperture inside it at summer noon. The env already carries the
  answer: arm_north 3.0, F on an arm from a tower outside the orbit shell; the drawing must show that tower and arm,
  not a pipe under F.
- F13/F9: the reach from a fixed receptacle to the env-family hub is 1.3-5.7 m over the year; a hexapod's legs would
  need 2.4-3.5 m of stroke each at up to 14:1 extension. The crown sized below holds the head in wind; it cannot
  also carry it around the orbit from one fixed stem. What can: a luffing, slewing pedicel (a boom from the stem top
  to the hexapod's receptacle, 4-5 m, +-60 deg luff, +-110 deg slew, counterweighted) or Hashemi's rail.
- F4/F5: the hashemi.ini primary has a 0.5 m hole (aperture 13.07 m2, drag 0.71 kN at 9 m/s) and the env's target
  sphere is R 8.10 for cass (f_design 4.05), so |P - F| = 4.05, not 4.00.
- F6: the retro shadow on the same model is 24.3 % mean (14.3-24.7 %), not the fold machine's 33 %.
- F7/F8: a 150 x 5 CHS is EI 1199 kN m2, not 380; and the image error of a cantilever crown is translation PLUS
  tip rotation times f: EI >= F L^2 (L/3 + f)/0.05 = 2128 kN m2 at 9 m/s and L 5 m, 2926 at the worst lever 5.74 m.
- F10-F12: compare moments to moments (the hose is 6.9x short at 9 m/s, 33x at 25); every load needs the gust
  factor (now in `wind_size.py`); "turns half the sun's motion" was the axis, not beta.
- F14: 8 (1 - cos(beta/2)) is the longitudinal defocus of C, not the blur; the blur is a (beta/2)^2.
- F15/F16: the stem at 2.0 m north pierces the membrane by 7 cm at some poses; the head goes 0.9 m south of the pipe
  at the low-sun ends of summer.

## Open

- The crown as a mechanism: how sixty twigs, twelve secondaries and six primaries move the head 4 m across the
  orbit (bending hoses at the vine curvature bound, or rigid branches on a moving receptacle); their stiffness
  against the 5 cm budget in gusts; the fine stage between the tips and the membrane.
- The still-head family: the env's optics run with |P - F| = g on the orbit; the exact-focus family
  (P + 8 n = F + 4 s off the orbit) is not in the env yet.
- Facets or one membrane: the tips could also carry steered facets on a sphere about F (a fixed field); the
  user's words say the membrane.

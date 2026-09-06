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
The pipe and strip shadow the aperture by 33 % at retro (the env's measured table); beta_dev 36 takes it to 1.6 %
with the head riding higher and further out.

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

## Sheets

`model.py` -> `out/tr_*.json`, sheets `out/tr_*_views.svg/png` (`3d/cad_views.py`): equinox noon (with the detail
of the stem, receptacle and branches), winter noon, equinox 9 h, summer noon, and the year's sweep (8, 12, 16 h
equinox and the solstice noons). The fourth-pass stalk machine, run with the dish's drag in the simulation
(`../setup_sim/out/wind9.log`, `wind25.log`): the stalk leans 1.0 deg at 9 m/s and 21 deg at 25 m/s; the fine
stage's whole range is spent on the mean wind at 9 m/s, which is the wind gating the user named.

## Open

- The crown as a mechanism: how sixty twigs, twelve secondaries and six primaries move the head 4 m across the
  orbit (bending hoses at the vine curvature bound, or rigid branches on a moving receptacle); their stiffness
  against the 5 cm budget in gusts; the fine stage between the tips and the membrane.
- The still-head family: the env's optics run with |P - F| = g on the orbit; the exact-focus family
  (P + 8 n = F + 4 s off the orbit) is not in the env yet.
- Facets or one membrane: the tips could also carry steered facets on a sphere about F (a fixed field); the
  user's words say the membrane.

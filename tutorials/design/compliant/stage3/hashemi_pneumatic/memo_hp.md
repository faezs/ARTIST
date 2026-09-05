# The pneumatic mount for the Cassegrain Hashemi machine

The machine is the one on nix-support (working config of 2026-09-05): dish a 2.1 m, pumped membrane as a sphere
R 8.2 m (f 4.05, five pressure zones), orbiting its focus F = (1.25, 0, 9.87) at 4.0 m, square to the sun, a
0.5 m centre hole and a 0.7 m radial slot toward the sun side (flaps closed below 54 deg), a strip of the
hyperboloid with foci F and F2 0.8 m below F, the beam down the vertical through the deck hole (r 0.9) to an
ellipsoid M4 at the turn and the duct. Frame x north, y east, z up; wall line x 1.25; roof deck z 5.0. None of
that is changed here. This memo is only about what holds the dish and F up, and it applies the brief: a water
hose as the frame, actuated like a vine robot, the assembly below the primary like a flower, nothing added in
front of the mirror.

Numbers from `physics_hp.py` (`out/checks.txt`); drawings `out/hp_*_views.svg`; models `out/hp_*.json`.

## 1. The dual of Hashemi's mount

Hashemi hangs the dish on a rod from F, tows its elevation with a wire and turns it on a ring rail; the env's
version rides a carriage on an arc rail with a ring rail of 4.6 m radius. In every case the dish's attitude is
slaved by construction: axis through F, vertex on the 4 m sphere.

The dual puts the rod below the dish and makes it a vine:

| element | value |
|---|---|
| root | one fixed point on the deck at x 2.50, y 0: 1.25 m north of the wall line, 1.15 m clear of the beam column at every sun position |
| rod | an inflated hose r 0.30 m at 0.15-0.17 bar (hoop 4.5-5 kN/m: light fabric), everted from a reel at the root; length 0.84-5.58 m and tilt 2-58 deg over the year; the reel is the elevation actuator |
| tip | a spreader ring r 0.8 m on the dish's back, around the hole; the rod meets it on its north side so the beam through the hole is never crossed |
| deck tendons | three, from the spreader ring to winches at r 7 m around the root; they steer the dish over the orbit sphere and give the lateral stiffness |
| attitude tendons | three short ones from a collar 0.5 m down the rod to a 2.4 m back ring; they hold the dish's axis through F |
| setup | inflate: the rod grows from the reel and lifts the dish off the deck; the tendons take up; the beam-centroid loop at F2 / M4 closes the pointing |
| storm | vent the rod and the plenum: the dish lies face-up on the deck around the root, tendons slack; nothing to break |

Nothing of this is in front of the mirror. The shading is the strip and the arm, as in the env.

## 2. What the year demands of it

59 sun positions at Quetta (three seasons, half-hourly, el >= 12 deg): vertex x 0.12-4.47, |y| <= 3.86,
z 5.90-8.99 m; the rim sweeps to x 5.72 m north and |y| 4.52 m; the lowest rim point is 0.35 m above the deck.
The root at x 2.5 gives the shortest maximum rod (5.58 m) that keeps 1.15 m from the beam column.

Force balance at 9 m/s (750 N on the dish, four wind directions, 45 kg head, tendons never below 200 N), rod
thrust along the rod, three tendons: feasible at every position. The worst case is the dish at full reach at
dawn or dusk in summer:

| winch radius | worst rod thrust | worst tendon |
|---|---|---|
| 5 m | 4.3 kN | 3.1 kN |
| 7 m | 3.3 kN | 2.7 kN |
| 9 m | 2.7 kN | 2.5 kN |

At 7 m the rod needs 3.3 kN: r 0.30 m at 0.15 bar supplies 4.2 kN of thrust with an Euler load of 13.4 kN at
5.58 m (pinned at the root bend, pinned at the tendon-held tip): SF 4. A 0.25 m rod at 0.2 bar gives SF 2.3;
a 0.2 m rod cannot do it.

Stiffness at 9 m/s: attitude 0.8 mrad (three 4 mm tendons, 1.3 m, on a 1.2 m radius: 415 kN m/rad against a
316 N m wind torque); position 24 mm along the sphere under the 750 N gust, which walks the spot 24 mm on the
strip and 88 mm at F2, inside the 1.0 m M4. Survival wind gives 5.8 kN: the machine is vented and flat before
that.

## 3. F's support

The env holds F on a horizontal arm from a tower 3 m north (x 4.25). The vertical through that tower lies
inside the dish disc at 14 of the 59 positions and passes through the membrane, not the hole, at 13 of them
(worst: equinox 10:30, el 53 deg, 1.9 m from the vertex). A tower must stand north of x 6.2 m or the support
must come from the sides. The pneumatic version: two inflated masts r 0.30 m at 1 bar, 5.5 m tall, at
y = +-5.2 m on the wall line (outside the 4.52 m sweep), a cable between their tops through F, a guy south to
the courtyard; the strip's bearing ring and the arm end hang there. Euler for a guyed mast 29 kN, wrinkling
4.2 kN m against 0.45 kN m of wind; the south guy clears the dish except below el 15 deg at the summer
solstice's ends, where there is no energy anyway.

## 4. What is unchanged and what is open

- The optics, the ladder (182/193/149 MJ per 8 h summer/equinox/winter) and the strip's winter behaviour
  belong to the other fork and are not touched by the mount.
- The 45 kg head assumes a fabric plenum with five zones behind the membrane and an inflated rim; the
  present rigid ring and jam bed are not needed on-axis (no beta tilt, no astigmatism, no rim squeeze).
- The slot flaps and the slot's edge effects on the membrane figure are the membrane fork's item.
- The reel: everting a 0.6 m hose of light fabric at 0.15 bar is within what vine robots do; the reel also
  retracts it, since a pushed tip does not re-invert on its own.
- Head-to-tendon geometry near the deck at dawn and dusk (the dish's lower rim 0.35 m above the deck) needs the
  tendon paths checked against the rim through the day; the sweep sheet is the input.
- The concept study of the self-contained sunflower (Cassegrain head, beam down its own stem) is kept under
  `../flower/` for the scale law and the hose sizing; it is not the machine.

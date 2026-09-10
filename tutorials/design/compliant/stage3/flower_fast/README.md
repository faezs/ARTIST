# The flower's own controller: 1 kHz, its own actuators, a flux camera

These are copies of files that LIVE in the shared checkout, where pufferlib can see them:

    ~/ARTIST/tutorials/tandoor_flower_fast.py          the env
    ~/ARTIST/tutorials/puffer_tandoor/policy.py        FluxConv, the convolutional policy
    ~/ARTIST/tutorials/puffer_tandoor/flowerfast.ini   the config (symlinked into pufferlib/config)

Kept here so the design branch carries them; edit the originals, not these.

    puffer train puffer_flower_fast

## What it is

Hashemi's policy commands an aim every 15 s and a servo follows it. This is the other half: the flower's inner loop at
1 ms, driving the actuators the flower actually has, looking at the only thing a real one could look at - a camera
watching the flux land at the fold. Eleven heads: the pedicel's six joints as rate commands, the crown's three fine
axes, the plenum's level and its valve. The reward is Hashemi's own, resampled - his terms at his weights times dt/15,
so a second here pays what a second of his does. The primary is his membrane, actuated his way: his seven exact FvK
setpoints, his pump slew, his DNI-correlated plenum disturbance.

## AGAINST THE RAY TRACE, the numbers below were wrong by thirty times

The first version scored the beam with a closed form fitted to "half power at a 4.9 cm miss". Driving the megakernel
from the flower's own head pose - one launch, 3.9 ms at 8192 agents by 64 rays, i.e. 2.1 M agent-steps/s, CHEAPER than
the closed form it replaced - gives the real acceptance:

| beam moves | traced power, per loaf |
|---|---|
| 8 mm | 100.0 % |
| 32 mm | 99.4 % |
| 96 mm | 93.6 % |
| 240 mm | 52.2 % |

Half power is at about 24 cm, not 4.9. So nulling the standing 2.5 cm aim error is worth **+0.4 %**, not the +12.4 %
the fitted curve reported. The duct is r 0.2 m and the traced spot is 3 cm rms: the optics were built with margin, and
the margin swallows everything a fast loop could fix.

Two things the trace also forced:
* the flux camera is now the histogram of where the traced rays actually land at the receiver, not a Gaussian - it has
  whatever coma, astigmatism and clipping the optics produce, and the duct's rim in frame as its fixed reference;
* the dough term reads the megakernel's PER-LOAF bins, as Hashemi's own reward does. Scoring total throughput hid the
  only spatially sensitive thing in the machine: which loaf the energy lands on. It is what makes the curve above bend
  at all - on total throughput it is still 91 % at 160 mm.

## What running it established

Measured, not assumed:

| | miss at F | reward / step | |
|---|---|---|---|
| open loop | 2.55 cm | 7.39e-5 | the outer loop's standing aim error |
| integral control on the camera centroid | 0.03 cm | 7.42e-5 | **+0.4 %** (traced) |

So there IS a job worth about an eighth of the delivered power, and it is a job a camera can see. But it is NOT the job
the fast loop was proposed for. At 12 m/s the head deflects 0.85 mm and the image moves about 0.03 mm - a thousand times
less than the standing error - because the ring carriage made the boom short (2.7 m) and stiff (6.6 Hz). The 2.4 cm of
gust walk that motivated a kilohertz stage belonged to the 4.7 m boom on the fixed deck stem, at 60 um/N and 2 Hz.

The honest reading: on this machine the 1 kHz loop earns its keep by trimming the outer loop's aim, not by fighting
gusts. Integral control already gets 99 % of that. A learned policy has to beat integral control to be worth its silicon.

## Three bugs the tests found, and what they cost

* Re-allocating the PufferEnv buffers detached the env from the vector backend's SHARED buffer. The trainer would have
  read zeros forever and reported healthy losses over nothing.
* The fine stage's heads were position commands on a 7-bin discrete head, so the smallest non-zero correction was a
  third of full stroke - 17 mrad, 8 cm of image. Every small correction quantised to neutral, and a proportional
  controller measured EXACTLY the same as doing nothing. They command a rate now.
* The wind force was not projected onto the boom's bending plane. Only the transverse part bends a cantilever, and from
  a carriage that rides round to the head's own meridian the boom often lies along the wind - where the world-frame
  version threw the tilt away entirely, and tilt outweighs translation 5:1 at the image.

## Vortex shedding, and the wind speed nobody would have guessed

The boom is a 0.219 m tube. It sheds at St U / d with St 0.20, and its own bending mode is 6.56 Hz. Those cross at

    U = f_n d / St = 6.56 x 0.219 / 0.20 = 7.2 m/s

which is not a storm - it is an ordinary working afternoon, and the lock-in band runs roughly 6 to 9 m/s. A forced
sinusoid at St U / d would miss the whole phenomenon: what matters is that the shedding CAPTURES the structure's
frequency and then feeds on its motion. So the model is Facchinetti's wake oscillator (2004) - a Van der Pol variable
driven by the structure's acceleration and driving the lift back:

    q'' + eps w_s (q^2 - 1) q' + w_s^2 q = (A/D) y''      F_lift = 0.5 rho U_n^2 D L (C_L0/2) q

with eps 0.3, A 12, C_L0 0.3, and only the CROSS-flow component of the wind shedding. q = 0 is an exact equilibrium,
so it is seeded with noise at reset.

AND THE ANSWER IS THAT THIS MACHINE DOES NOT LOCK IN. Swept from 3 to 18 m/s, the wake variable sits at 1.27 at every
wind - which is exactly the FREE Van der Pol limit cycle, mean |2 sin| = 4/pi - and the shedding frequency tracks
St U / d exactly (2.66, 4.45, 6.25, 8.06, 12.64 Hz) with no capture anywhere. The response grows monotonically as U^2
with no peak at the crossing:

| wind | sheds at | wake q | deflection | beam at the receiver |
|---|---|---|---|---|
| 6 m/s | 5.35 Hz | 1.277 | 0.27 mm | 0.81 mm |
| 7.5 m/s (the crossing) | 6.70 Hz | 1.275 | 0.42 mm | 1.27 mm |
| 9 m/s | 8.06 Hz | 1.274 | 0.61 mm | 1.85 mm |
| 18 m/s | 16.33 Hz | 1.267 | 2.52 mm | 7.61 mm |

The reason is amplitude. Capture needs the structure to move on the order of 5 % of the tube's diameter, about 11 mm
here; the boom moves 0.4 mm, two parts in a thousand of D. The coupling term (A/D) y'' comes to about 37 against a
restoring term w_s^2 q of about 2180 - under 2 %, so the wake never feels the structure and runs free.

A WARNING FOR ANYONE READING THE FIRST DRAFT OF THIS FILE: at 7.2 m/s St U / d is 6.58 Hz and the mode is 6.57 Hz, so
a single run at that wind shows the two frequencies agreeing. That is the CROSSING, by construction - not capture.
Reading it as lock-in is the obvious mistake and it was made here before the sweep was run. The test for capture is
that the shedding frequency stops tracking St U / d, and it never does.

The dish sheds too, at St 0.135, which is 0.39 Hz at 12 m/s - far below both the bending mode (6.6 Hz) and the tilt
mode (14.3 Hz), so it cannot lock in. It is carried as a narrowband cross-wind force because it still sits in the band
the coarse loop has to hold.

What it costs: at 7.2 m/s the deflection is 0.38-0.48 mm against the 0.32 mm the drag alone would give - so lock-in is
real, is captured, and adds tens of percent to a sub-millimetre number. It does not threaten the hyperboloid. The boom
tube's projected area is 0.59 m2 against the dish's 13.85, and that ratio is why.

## What the 0.5 m post offset is, and what straightening it would cost

It did not. The bore runs from the hyperboloid at F down to the turn mirror P4, and P4 is fixed over the chase, so
`post_offset` - the distance F stands north of the wall - TILTS the bore rather than sliding it. The stock 0.5 m put
F at x 1.750 against a borehole at x 1.250:

    horizontal offset  0.500 m over a 9.728 m drop  ->  bore tilt 2.94 deg,  F sitting 0.71 bore radii off axis

and the env's own comment called that "the derived vertical-bore geometry". It is not vertical, and that comment is
corrected in place - it is what makes the tilt invisible.

Note that the wall tower and the chase are the SAME x: `X_TOWER = CO.X_CHASE = 1.25`, "chase centreline: inside the
wall". The chase runs down inside the tower, so "F above the borehole" and "F above the wall tower" are one constraint,
and `post_offset = 0` satisfies both.

THE OFFSET IS KEPT at the stock 0.5 m. Straightening it was measured and it costs more than the alignment is worth:

What it costs, traced at Quetta with perfect tracking (midwinter / equinox / midsummer):

| post_offset | bore tilt | midwinter | equinox | midsummer |
|---|---|---|---|---|
| 0.50 | 2.94 deg | 1.374 kW | 2.722 kW | 3.846 kW |
| 0.25 | 1.47 deg | 1.151 | 2.676 | 3.890 |
| **0.00** | **0.00 deg** | **1.116** | **2.608** | **3.897** |

Straightening costs 18.8 % at midwinter, 4.2 % at equinox, and gains 1.3 % at midsummer - about 4 % on the year. The
offset buys low sun: at midwinter the dish swings low and the offset is what lets it clear the wall tower. So the
default stands, and it now stands for a measured reason rather than an unexamined one.

One thing this did surface and it is still open: with the offset REMOVED, F sits directly over the tower and the
dish's high-sun clearance past it becomes load-bearing - and neither tandoor_flower_env.py nor the fast env checks
clearance at all. path.py in the tree folder tests the aperture against the pipe (>= R_PIPE + 0.3) and the rim against
the deck; nothing equivalent runs in the envs. With the offset restored that check is not urgent, but it is missing.

## Why the eval drew the room and the pot and nothing else

The renderer's whole optical half - the dish, the rays, the fold, the duct, the ladder - hangs off `self._hv`, and
`_hv` is filled by `_render_trace()`. That call existed in exactly one place:

    def step(self):        ...  if self.render_mode == "human": self._sync_from_gpu(); self._render_trace()
    def step_torch(self):  ...  (nothing)

and `puffer_tandoor/__init__.py` installs `tandoor_fast_collect`, which routes evaluation through `env.step_torch`
whenever the env exposes it - "keeps policy<->env exchange on MPS". So every eval took the one path that never built
the trace. `_hv` stayed None, and the renderer drew the room and the pot.

Fixed by giving `step_torch` the same two lines under the same `render_mode == "human"` gate, so training never pays
for it. Verified: after one step_torch in human mode `_hv` carries 256 rays at dish, fold, m5 and duct, and the ladder
is populated. This was not a flower bug - any `puffer eval` on the megakernel path had it.

Separately, `_draw_flower` opened with `if H is None: return`, so a missing trace took the STEM with it - the mount
vanished entirely rather than being drawn unlit. `_flower_geom` now falls back to the mount's own solve
(`_fl_head_pose`), and to a parked pose on the orbit if nothing has stepped, so the frame is drawn whether or not
there is light in it.

## The frames of all three mirrors

`_draw_chain` draws them from the machine's own conic constants rather than sketching them:

* **secondary** - the hyperboloid strip at F, swept from `cs_O`, `cs_A`, `cs_a`, `cs_c` with b = sqrt(c^2 - a^2), over
  `w_strip` and clipped at `r_strip`, plus the post from the wall tower (`cs_Ps`) that holds it - the only structure
  standing in the beam.
* **tertiary** - M3's patch at `cs_P4`, radius `r_m4`, its normal `cs_n4` carried through the ACTUAL turn angle read
  from `_spot_view`, so on tri it swings with the aim head; with a pointer along its normal, a line to what it is
  aiming at (`cs_F4`), and its stub into the chase wall.
* **the bore** between them as a wireframe tube on its real axis, so the 2.94 deg tilt is visible rather than
  described, and the beam can be seen inside it.

## Three more things wrong with the eval's trace

Having given step_torch the trace, the ladder still said every ray was lost while the kernel delivered kilowatts.
Three separate faults, each measured:

**The level index was inverted against a table it does not fit.** `_trace_power` recovered the pressure level with a
LINEAR inverse, but `level_frac` is (0.70, 0.82, 0.90, 0.96, 1.00, 1.04, 1.10) - the steps tighten around the nominal.
So p_eff = p0, the nominal, mapped to level **4.5** instead of 4, half a step of defocus on every render trace, and
`mems[4]` is the level the secondary was designed for. Now `np.interp` against the table itself.

**The Cassegrain's last two rungs were fold-chain tests it can never pass.** Measured at equinox noon, pointed:

| | lit | ~graze | pre_tube | post_tube | ok | through_b | kernel deposit |
|---|---|---|---|---|---|---|---|
| cass | 85.7 | 85.7 | 76.0 | 28.1 | **0.0** | **0.0** | 2.741 kW |
| fold | 93.0 | 87.1 | 87.1 | 59.8 | 45.5 | 41.0 | 5.426 kW |

`ok` is the fold chain's M5 acceptance and `through_b` is gated on it. This chain has no M5, so both sit at exactly
zero however well the machine works, and the renderer - which colours rays by them - drew every ray as lost. The
Cassegrain now gets its own ladder ending at the stage it actually has (post_tube), and the per-ray flags follow.
Equinox noon went from `through 0.0 %` to **27.7 %**.

**verify_megakernel() passes vacuously here.** It reported 0 mask mismatches and 0.00e+00 max difference - because
BOTH cores return through_b = 0 on the Cassegrain. Two cores agreeing on nothing is not parity, and the check cannot
tell the difference.

Still unverified: at midsummer and midwinter my harness still reads 0 % through, but that same harness also has
midwinter delivering 5.585 kW against equinox's 2.741, which is backwards - so it is misconfiguring something (it
already had to be caught twice, once for an unzoned membrane and once for tracing a different day than it stepped).
Not claimed as a fourth bug. The test that settles it is running the eval.

## The boom's compliance, exploited - and what the exploit turned out to be

The full study is in `../boom/` (nine scripts and a README). The short form:

**The walk is signed, and the env computes it that way now.** Image walk is g_rot*theta + g_tr*delta with the two gains
of opposite sign at every pose. At a 7 m boom the signed figure is 6.1 um/N against 42.8 for the old unsigned sum -
the 7x cancellation is real and is what `_fl_after_step` uses. Two corrections landed on the way:

* `miss_gains(..., lever=D_REC*n)`: the boom bends at its TIP and the vertex rides 1.8 m in front of it, so a tip
  rotation also slides the dish in its own plane. Taken about the vertex the rotation gain was 34 % low
  (5.46 um/N where the machine walks 8.28).
* `compliance(..., m_tip=D_REC*(n.bu))`: the drag acts at the dish, so the tip also sees a moment. The head leans back
  over the boom (n.bu -0.07..-0.65 all year) and the moment UNBENDS the chain: 6.34 um/N as built. f_n rises 5-15 %.

**No passive shape exploits it further.** The neutral point - the centre a wind-bent chain would have to rotate about
to leave the image still - is a property of the pose: 1.9 m below the boom root in the median and anywhere from inside
the boom to 7 m below the roof across the year. The tapered "reversed" telescope that measured 2.4x was a 45x stiffer
arm in disguise (a uniformly 45x stiffer boom measures 2.86x) with a root at 443-3268 MPa against 438 allowed; a root
pivot, a stem-base pivot and remote centres down to 8 m below the roof all land within 1.14x of the boom as built.
`boom_kind` is back to `uniform` in both inis.

**The stem is already the good part; the boom's bending is the walk.** Rigid boom on the built stem: 3.2x less walk.
Rigid stem on the built boom: 1.23x. Only EI moves it - 2x buys 1.56x, 4x buys 2.14x.

**What CAN be exploited is the stem as a load cell.** Two strain gauges at its foot read the wind's moment as the gust
arrives, a quarter-period before the boom's 2-7 Hz mode has moved the image, and whether or not the spot is in the
frame. `obs_strain=1` appends the two readings to the tail (14 numbers after the frame instead of 12; FluxConv picks
the width up from the env). Off by default so the observation the running training was started on is unchanged.
Whether the policy uses it is a training away, and that training has not been run.

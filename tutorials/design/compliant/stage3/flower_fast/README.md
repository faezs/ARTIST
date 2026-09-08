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

## The hyperboloid now sits vertically above the borehole

It did not. The bore runs from the hyperboloid at F down to the turn mirror P4, and P4 is fixed over the chase, so
`post_offset` - the distance F stands north of the wall - TILTS the bore rather than sliding it. The stock 0.5 m put
F at x 1.750 against a borehole at x 1.250:

    horizontal offset  0.500 m over a 9.728 m drop  ->  bore tilt 2.94 deg,  F sitting 0.71 bore radii off axis

and the env's own comment called that "the derived vertical-bore geometry". It is not vertical. Comment corrected in
place; `post_offset = 0.0` in flowerfast.ini puts F at x 1.250, exactly above the borehole, tilt 0.0000 deg.

What it costs, traced at Quetta with perfect tracking (midwinter / equinox / midsummer):

| post_offset | bore tilt | midwinter | equinox | midsummer |
|---|---|---|---|---|
| 0.50 | 2.94 deg | 1.374 kW | 2.722 kW | 3.846 kW |
| 0.25 | 1.47 deg | 1.151 | 2.676 | 3.890 |
| **0.00** | **0.00 deg** | **1.116** | **2.608** | **3.897** |

So straightening the bore costs 18.8 % at midwinter, 4.2 % at equinox, and GAINS 1.3 % at midsummer - about 4 % on the
year. The offset was buying low sun: at midwinter the dish swings low and the tilt is what lets it clear the wall
tower. That is the trade, and it is now made deliberately rather than by an unexamined default.

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

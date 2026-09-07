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

## What running it established

Measured, not assumed:

| | miss at F | reward / step | |
|---|---|---|---|
| open loop | 2.16 cm | 1.107e-4 | the outer loop's standing aim error |
| integral control on the camera centroid | 0.03 cm | 1.245e-4 | **+12.4 %** |

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

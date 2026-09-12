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

## The mechanism from its screws, in the eval

`flower_eval.py` now prints, once at start, every joint of the machine written as a screw and realised as flexures by
`tandoor_screw_render.realise` (the pure function; the copy beside the envs is what the env imports, `fact/screw_render.py`
is the same file), scored by its `evaluate`. Travel comes from the machine's own year - the kernel's aim law swept over
170 poses the way `tree/path.py` does, angles taken on the circle so the slew's continuous limit does not read as
360 deg - and load from the worst moment at the joint over the blade standoff (gravity at full reach plus drag at the
15 m/s tracking limit for the root; the head hung 1.8 m past the wrist plus the pitching moment for the wrist; wind at
40 m/s on the strip; 5x its weight for M3). The renderer draws what comes out - blades as their planes, M-52 slaving
links, pins where the travel beat the elastica - and `--flexures all|m23|off` chooses how much of it.

| joint | travel | load | realised as | blade t x w x L | mass | softness |
|---|---|---|---|---|---|---|
| $1 slew | 264 deg | 123.5 kN | 19 stations | 48 x 571 x 9090 mm | 74 t | 3729 |
| $2 luff | 71 deg | 123.5 kN | 5 stations | 48 x 580 x 9386 mm | 21 t | 242 |
| $3 extend | 6.72 m | 2.2 kN | rigid slide | - | - | - |
| $4 pitch | 44 deg | 11.0 kN | 3 stations | 15 x 178 x 2968 mm | 371 kg | 2844 |
| $5 yaw | 98 deg | 11.0 kN | 7 stations | 14 x 172 x 2764 mm | 750 kg | 4199 |
| **M2 strip** | 202 deg | 1.2 kN | 14 stations, hollow ring r 0.85 | 4.9 x 58 x 967 mm | **121 kg** | **47354** |
| **M3 turn** | 63 deg | 4.0 kN | 5 stations | 7.8 x 93 x 1343 mm | **76 kg** | **35182** |

Read it the way the numbers ask to be read. Kinematically every stack is a pivot - the softness ratio, the stiffest
constrained direction over the freedom asked for, is in the thousands - but the pedicel's root joints carry 37 kN m
and come out as 9 m blades weighing 74 and 21 tonnes: the elastica sizes a blade to its load, and the machine's root
load is a 14 m2 sail on an 8.6 m arm. Those two stay bearings. The two mirrors' pivots are the compliant candidates
the whole time: the strip's, a hollow ring of radial blades round the bore mouth (the beam goes down the middle), 121 kg
for 202 deg of travel at a softness of 47000; M3's, 76 kg under its patch for its 63 deg. Same synthesis, same rules,
radically different parts, because the inputs are.

Two things the wiring found:

* `evaluate()` was not frame-invariant. It took moments about the world origin, so the translation part of the scaled
  twist swamped the rotation for any joint far from it: M3 scored 13 at its real position and 35249 at the origin.
  Moments are now taken about the screw's own point and the score is the same wherever the joint stands.
* The travel depends on the episode's formed declination (the mount's aim law does), by a few degrees between resets;
  the report is for the day the env was reset on.

The renderer also draws the stem and boom as the compliant members they are: their elastic curve under the step's
drag, exaggerated 200x, the point the bent chain actually turns about, and the optical NEUTRAL POINT the image would
need it to turn about. The gap between the two markers is the walk, and the HUD says so.

## The fast loop's own job (the miss reward, the fine-stage heads, and a camera that can see it)

Trained on Hashemi's cooking reward the 1 kHz policy stayed uniform random after 240 epochs and, integrated on the fine
stage's rate commands, walked the image 20 cm off (`fast_eval.py`: no-op 2.7 cm, random 5.6, the policy 20). The reward
is 3e-7 a step and the loop's share of it is smaller still. Three changes, all switches in `flowerfast.ini`:

- `fine_only = 1`: the policy drives the crown's three fine-stage heads; the pedicel's joints, the plenum level and the
  valve stay at neutral, where the 15 s policy owns them.
- `reward = miss`: -|image miss at F| per step, -1 at `miss_scale` 0.20 m. No-op pays -0.125 (2.5 cm).
- `cam_plane = F`: the camera looks at the plane the reward is paid on. MEASURED with the receiver camera: a millimetre
  of miss at F moves the frame's centroid 0.0005 px - at the bread the beam is a pupil image that dims with the miss
  but does not shift, so no controller on that frame can know which way to push. The F camera bins the same 64
  membrane rays, reflected off the normals of the level the pump has reached with the film's slope error on each,
  where they cross the plane through F normal to the chief ray: 0.03 px a step of full-rate command, 60x more.

| controller (site wind, 128 agents, 2 s) | miss cm | rays through |
|---|---|---|
| no-op | 2.50 | 68 % |
| random | 6.6 | 46 % |
| integral on the receiver camera | 5.2 | 79 % (it cannot see the sign) |
| integral on the F camera | 0.34 | 87 % |
| integral on the true miss (the ceiling) | 0.03 | 87 % |

Nulling the standing 2.5 cm takes the delivered rays from 68 to 87 %: the tri chain's acceptance at the collar is what
the earlier +0.4 % (per-loaf power, broad acceptance) hid. The training on this job is the next entry.

## The miss policy, run 1: uniform for 74 epochs, then NaN

`puffer train puffer_flower_fast` on the job above (8192 agents, 129K SPS after the profiler fix, 300 M steps): the
policy's action entropy went 5.83 -> 5.71 over 74 epochs against 5.84 for uniform over 7^3 bins, approx_kl 0.000, and
the value loss climbed 4.6 -> 24 -> 51 -> 71 -> 116 -> 135 with explained variance 0.03 and turned NaN at epoch 75
(14 NaN parameters in `model_000100.pt`; the run kept stepping the NaN weights to 300 M). The two checkpoints the
watcher evaluated, against the baselines above:

| epoch | reward/step | miss cm | rays through |
|---|---|---|---|
| 20 | -0.78 | 15.6 | 10 % |
| 100 (NaN weights) | -0.42 | 8.4 | 37 % (= random) |

The cause is the reward's scale, not the camera or the heads. -|miss|/0.2 is -0.13 a step at the no-op miss and
-0.4 once the integrated random commands have walked the image, and at gamma 0.999 that is a return of order -100
per sample with reward_div 1.0: the critic never fitted it, the advantages were the critic's noise, the policy
gradient had nothing to follow (KL 0.000) while vf_coef 2 kept pushing the value head until it overflowed.

Run 2 (`reward = miss`, v2) changes the reward's shape and horizon, nothing else:

- potential-based shaping on the same quantity: reward = -|miss|/scale + 20 (|miss|_prev - |miss|)/scale, the credit
  for having moved the image the right way THIS step, which is what a 1 ms rate command can earn. Shaping on a
  potential leaves the optimal policy unchanged (Ng, Harada, Russell 1999).
- gamma 0.99: a 100 ms horizon, the fine stage's own response time, in place of a 1 s one.
- reward_div 10: returns of order one for the critic.
- `nan_to_num` on the reward and the observation, so a stray NaN in one agent cannot poison a 2 M-sample batch.

Five minutes in: value loss 0.001, explained variance 0.97, entropy 5.65 and falling, KL 0.002. The critic fits and
the policy is moving; whether it moves the right way is the epoch-20 eval below.

Epoch 20 of run 2 (42 M steps, six minutes), the watcher's eval with the baselines re-run alongside it (256 agents, 3 s,
seed 11, site wind, actions sampled, not argmax):

| controller | reward/step | miss cm (2nd half) | rays through |
|---|---|---|---|
| no-op | -0.0134 | 2.67 | 67.5 % |
| random | -0.0423 | 8.41 | 37.6 % |
| integral on the F camera | -0.0017 | 0.34 | 87.2 % |
| integral on the true miss | -0.0002 | 0.03 | 86.8 % |
| **policy, epoch 20** | -0.0014 | **0.28** | 82.6 % |

Ten times the no-op's miss removed and the camera integral controller beaten on miss at the first checkpoint; the
throughput sits 4.6 points under the integral's at a smaller mean miss, and the eval samples the policy's 7-bin heads
at full rate, so the gap is most likely the dither of a stochastic policy at 1 kHz clipping at the collar rather than
its aim. The remaining checkpoints (every 20 epochs to 300 M steps) land in `runs/eval_miss.log` as the watcher
reaches them.

### Run 2 to the end: the tilts at the ceiling, the piston in the null space

The watcher's evals of run 2's checkpoints (256 agents, 3 s, seed 11, site wind; baselines re-run each time: no-op
2.67 cm / 67.5 %, integral on the F camera 0.34 / 87.2 %, integral on the true miss 0.03 / 86.8 %):

| epoch | miss cm (2nd half) | rays through | |piston| mm |
|---|---|---|---|
| 20 | 0.28 | 82.6 % | |
| 60 | 0.11 | 85.6 % | |
| 100 | 0.09 | 81.3 % | |
| 144 (end), sampled | 0.10 | 74.7 % | 49.5 |
| 144, greedy | 0.07 | 74.3 % | 50.0 |
| 144, sampled, piston held at neutral | 0.08 | **87.2 %** | 0 |

The miss converges to a millimetre by epoch 100 and stays there; the throughput falls after epoch 60 while the miss
does not move. Greedy actions change nothing, so it is not the dither. `fast_eval.py --heads 2` holds the third head at
neutral and the same weights deliver 87.2 %, the integral controller's figure and the true-miss ceiling's, at a quarter
of the integral's miss. The crown's third head is the PISTON: it moves the focus along the chief ray and the image's
centroid not at all, so the miss reward has a null space along it, and the policy - paid nothing either way - walked it
to the 50 mm stop (|piston| 49.5 mm at the end of an episode, throughput 79.9 % in the first half and 74.7 in the
second: a random walk in the null space, integrated by the rate command, defocusing the beam at the collar).

Run 3 puts the collar's acceptance into the reward: `thru_w = 1.0`, `thru_ref = 0.85`, reward += thru_w x (fraction of
the traced rays reaching the bread - thru_ref), everything else as run 2. The F camera sees the spot's spread as well
as its centre, and the piston is the one actuator that can refocus at 1 kHz when the wind softens the film, so the
term gives the third head a job rather than taking it away (`--heads 2` is the eval's way of showing what holding it
would give; a `fine_only = 2` env would be the other fix). Eleven epochs in: explained variance 0.94.

## Every checkpoint re-evaluated on the fixed wind table (runs 2 and 3)

`runs/reeval_all.sh`, after run 3 ended (it hung at exit like run 2; the script killed it): 256 agents, 3 s, seed 11,
site wind, actions sampled unless marked, the table serving every incidence. Baselines: no-op 2.67 cm / 67.5 %, random
7.93 / 40.5, integral on the F camera 0.34 / 87.2, integral on the true miss 0.03 / 86.8 - unchanged to the printed
digit from before the coverage fix: at the site's winds the back-of-dish loads move the image by less than 0.01 cm.

| checkpoint | miss cm (2nd half) | rays through | \|tilt\| mrad | \|piston\| mm |
|---|---|---|---|---|
| run 2 ep 20 | 0.28 | 82.6 % | 2.1 | 43.9 |
| run 2 ep 40 | 0.12 | 86.4 % | 2.1 | 7.8 |
| run 2 ep 60 | 0.11 | 85.6 % | 2.1 | 12.2 |
| run 2 ep 80 | 0.11 | 77.6 % | 2.1 | 41.3 |
| run 2 ep 100 | 0.09 | 81.5 % | 2.1 | 30.3 |
| run 2 ep 120 | 0.09 | 74.7 % | 2.1 | 49.3 |
| run 2 ep 144 | 0.10 | 74.7 % | 2.1 | 49.5 |
| run 2 ep 144, greedy | 0.07 | 74.3 % | 2.1 | 50.0 |
| **run 2 ep 144, piston held** | **0.08** | **87.1 %** | 2.1 | 0 |
| run 3 ep 20 | 0.37 | 87.3 % | 2.2 | 14.3 |
| run 3 ep 40 | 0.34 | 86.1 % | 2.2 | 7.5 |
| run 3 ep 60 | 7.17 | 76.5 % | 7.9 | 15.5 |
| run 3 ep 80 | 25.4 | 48.1 % | 23.5 | 24.9 |
| run 3 ep 100 | 14.6 | 64.8 % | 14.0 | 9.6 |
| run 3 ep 120 | 13.2 | 65.8 % | 12.7 | 13.2 |
| run 3 ep 144 | 15.6 | 62.7 % | 14.8 | 10.5 |
| run 3 ep 144, greedy | 17.2 | 60.0 % | 16.1 | 29.1 |
| run 3 ep 144, piston held | 16.0 | 62.1 % | 15.1 | 0 |

Run 2 is as before: the tilts converge by epoch 40 and the piston wanders in the miss's null space; with the piston
held its last checkpoint is the best controller on the page. Run 3 (the throughput term) did what it was added for
through epoch 40 - piston 7-14 mm instead of 44, throughput 86-87 % - and then COLLAPSED: from epoch 60 the tilt
commands run to 8, then 23 mrad, the image 7-25 cm off, half the rays lost, and it never recovers. Three checks say
the collapse is the policy's and not the eval's: the epoch-80 checkpoint gives the same 25.4 cm on the old coverage
mask (its training conditions), over 8 s episodes (the training length) and on another seed (21.6 cm). The trainer
showed none of it: explained variance 0.94-0.98, value loss 0.007-0.02, entropy falling smoothly 5.32 -> 4.59, KL
0.001 - the critic tracked a return that was getting worse, and the fast env emits no per-episode statistics, so the
dashboard's User Stats stayed empty. The cause is not established. What is known: the reward's only new ingredient is
the throughput term, which near the optimum is flat and quantised (the ceiling controller at 0.03 cm gets 86.8 %, the
camera integral at 0.34 cm gets 87.2 %) so its per-step noise (+-1-2 rays of 64) exceeds the level term's signal
(0.5 mm of miss pays 0.0005 a step); and an episode end resets only the clock, the shaping memory and the plenum
energy - the fine stage, the gusts and the day carry over, so `done` is a bookkeeping cut with the bootstrap set to
zero, in both runs. Before any run 4: give the fast env infos (miss, rays through, |tilt|, |piston| per episode) so the
trainer's dashboard shows a collapse when it happens, and keep the best checkpoint by eval rather than the last.

## Correction (2026-09-12): the trace's sun was frozen to the dish

The fast env's `trace()` froze `Acan` - the sun's direction in the dish's frame - at reset while the dish frame moved
every step, so a tilt of the crown turned the traced beam by theta instead of 2 theta: rays through were half as
sensitive to the fine stage as the miss. Found by the kernel-mount path (`../screws/`), which re-solves it every step.
Re-run under the corrected trace: no-op 2.67 cm / 67.5 % (unchanged), random 7.98 / 16.8 (was 40.5), integral on the
F camera 0.34 / 89.8 (was 87.2), integral on the true miss 0.03 / 89.8 (was 86.8), run 2 ep 144 with the piston held
0.08 / 89.8 (was 87.1). The tables above carry the old throughput; the miss columns are unaffected, the conclusions
stand, and the ceiling is 89.8 %.

## The wind as a field (2026-09-12)

The fast env's structure is a rod now (`../screws/README.md`): the tubes' drag and the boom's shedding as densities
along the stem and boom from the log profile, the bowl's force and its signed mean pitching moment at the vertex, two
rod solutions a step rung on the bending and pitching modes from the chain's 6 x 6 (3.0 and 10.5 Hz, not 4 and 14).
At the site's winds the tables above do not move; at 9 m/s the no-op's head twists 8.7 mm and 2.3 mrad.

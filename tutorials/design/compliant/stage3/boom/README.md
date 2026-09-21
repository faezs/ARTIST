# The boom's compliance, exploited - what survived

"Exploit the stem and boom being already compliant." Nine scripts, run in this order; each one corrected the one before.

| script | question | answer |
|---|---|---|
| `boom_compensate.py` | are the image's sensitivities to head tilt and head translation of the same sign? | No. Opposite at every one of 170 poses, so a bent shape CAN cancel in the image. The optics want theta/delta = 0.178 rad/m (median); a uniform cantilever gives 3/(2Lb) = 0.245 at 6 m. |
| `boom_tune.py` | tune a two-stage telescope (root EI, arm EI, split) for the least year-rms walk | "reversed" telescope, 0.25 m root under an arm 45x stiffer: 2.31 um/N vs 5.46 built, 2.36x. Parallelogram boom (theta = 0) worse: 17.6. |
| `boom_limit.py` | how far can the ratio go? | the optimiser wants the arm as stiff as it can get; the split barely matters |
| `root_check.py` | what does a 45x-soft root do under the 15 m/s tracking limit? | 443 MPa (12 m/s) / 692 MPa (15 m/s) against 438 allowed. Overstressed. |
| `boom_stress_tune.py` | re-tune with the arm pinned to the built tube and the root under the 438 MPa cap | nothing beats 1.00x. Ratio 3 survives (429 MPa) at 0.88x; ratio 5 fails. Maraging steel at 20: 1779 MPa, fails. |
| `decompose.py` | was the 2.36x the SHAPE or the arm being 45x stiffer? | Stiffness. "Uniform, 45x stiffer everywhere" 2.86x; "uniform, 6.7x stiffer" 2.44x; the stem alone under a rigid boom 2.93x. The shape bought nothing the stiffness did not. |
| `pivot_tune.py` | where is the optical NEUTRAL POINT, and can a lumped pivot at the boom root sit on it? | First look, gains about the vertex: neutral 0.73 m past the root. Best root pivot: rigid (1.00x); 75 % of poses would need a negative pivot stiffness. |
| `pivot2.py` | the same with the rotation gain taken about the boom's TIP (the vertex rides D_REC = 1.8 m in front of it, so a tip rotation also slides the dish in its own plane) | walk as built 8.28 um/N, not 5.46 - the vertex-referenced gain understated it by 34 %. Neutral point 1.91 m past the root (median), 10-90 % -0.91..+7.24 m: it wanders 8 m over the year. Stem alone (rigid boom) 2.16 um/N = 3.83x; stem rigid only 1.23x; boom 2x EI 1.65x, 4x 2.38x. Best pivot anywhere on the stem line: 8 m BELOW the roof, 1.14x. |
| `tipmoment.py` | the drag acts at the dish, not at the tip: the tip also sees a moment P*D_REC*(n.bu) | n.bu is -0.07..-0.65 (the head leans back over the boom), so the moment UNBENDS the chain: 6.34 um/N, 0.77x of force-only. Boom 2x 1.56x, 4x 2.14x, rigid 3.20x. The boom's own centre moves from 3.44 to 3.74 m behind the tip; neutral is 6.94. |

## What it means

1. The walk is signed and it does cancel - the env now computes it that way (`miss_gains`, `_fl_after_step`), and at a 7 m boom the signed figure is 6.1 um/N against 42.8 for the old unsigned sum. That 7x was real and is kept.
2. No PASSIVE shape exploits it further. The neutral point is a property of the pose, not the structure, and it moves from inside the boom to 7 m below the roof across the year. Every tube taper, root pivot and remote centre tried lands within 1.14x of the boom as built, and the one that measured 2.4x was a 45x stiffer arm wearing a soft root that yields.
3. The stem is already the good part. Its bending centre sits close to the median neutral point; a rigid boom on the built stem walks 3.2x less than the machine as built, a rigid stem on the built boom only 1.23x less. The boom's bending IS the walk. Only EI moves it: 2x buys 1.56x, 4x buys 2.14x - a 219x8 CHS to a 310 mm tube, or a truss.
4. The compliance that CAN be exploited is the stem's as a sensor. Two strain gauges at its foot read the wind's moment the instant the gust arrives, a quarter-period before the boom's 2-7 Hz mode has moved the image, and whether or not the spot is in the frame. `TandoorFlowerFastEnv(obs_strain=1)` appends the two readings to the proprioceptive tail (14 numbers after the 24x24 frame instead of 12), scaled by the moment at the 15 m/s limit with the boom at full reach. Off by default so the running training's observation is unchanged. Untrained: whether the policy uses it is a training away.

## What changed in the envs

- `miss_gains(..., lever=)`: the rotation gain about the tip, with the vertex's D_REC lever. Both call sites pass it.
- `compliance(..., m_tip=)`: the drag's tip moment, D_REC*(n.bu) per newton. Both envs pass it; f_n rises 5-15 % with it.
- `flower.ini`, `flowerfast.ini`: `boom_kind = uniform` again (the reversed block and a duplicated, mangled comment removed).
- `TandoorFlowerFastEnv(obs_strain=0)`: the gauges, opt-in.

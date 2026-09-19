# Hashemi.lean, compiled: the megakernel of his machine

`~/manifold-pareto/lean/RequestProject/Hashemi.lean` is the master design of Ebrahim Hashemi's
fixed-focus concentrator, read off his build video stage by stage (see the stage 3 register). This
directory is that file compiled - every definition and every theorem statement - into one Metal
kernel, one thread per agent, and the puffer env of his machine that runs on it. The compiler is
Conal Elliott's *compiling to categories*, done the Lean way: a `MetaM` translator reads each
definition's `Expr` as it stands, into a hash-consed dataflow graph, and printers off the graph
give C (Metal/CUDA device functions), NumPy, Graphviz, a Lean `Float` twin and a Lean `ℝ` round
trip proved by `rfl`.

## What is here

| file | what |
|---|---|
| `lean/Hashemi.lean` | the design (mirror; the source lives in the user's Lean repo, never committed there) |
| `lean/Ccc.lean` | the translator and the printers |
| `lean/HashemiStep.lean` | one step of the machine, composed from the file's definitions: the wire's length is the state's carrier (bisection for the swing, the dead point, slack, the `HoldsDish` gate on the winch) |
| `lean/HashemiPropsGen.lean` → `lean/HashemiProps.lean` | every theorem's statement as a predicate `prop_X`, each proved by `X` itself (`prop_X_ok`) - the theorem compiler's round trip, checked by Lean |
| `lean/HashemiMega.lean` | the megakernel: six functions applying every definition and every `prop_X` at the machine's state; `megaNames` names the 226 columns; `megaParams` holds the eight values the video did not give |
| `lean/HashemiCcc.lean` | the driver: enumerates the namespace, compiles, writes everything below |
| `lean/HashemiCccRound.lean` | generated: the `rfl` round trip (the Float twin `HashemiCccFloat.lean` is regenerated, not mirrored) |
| `lean/MetalBridge.lean`, `bridge/` | Lean calls Metal: the shim, its build, the recorded tandoor scene, the emitted kernel sources |
| `lean/HashemiTrace.lean`, `hashemi_trace_kernel.py` | his dish's trace and the conic homotopy from the file; the Metal kernels around them |
| `lean/Feedback.lean` | bounded feedback attains its fixed point |
| `lean/TraceCheck.lean` | `lake exe trace_check`: the optics theorems measured on the GPU |
| `lean/PropsGenCore.lean`, `HashemiPropsGen.lean`, `HashemiTracePropsGen.lean` | the theorem-to-predicate generator and its two drivers |
| `hashemi_ccc.h` | 347 device functions: 110 definitions, 122 predicates (the Props and the theorem statements), 115 theorem checks |
| `hashemi_ccc.py` | the same graphs for NumPy (the reference twin) |
| `hashemi_ccc.json`, `hashemi_mega.json` | the table of what compiled (inputs, shapes, samples), and the megakernel's manifest (columns, input order, offsets) |
| `dot/` | the dataflow graph of each function |
| `hashemi_kernel.py` | the MSL/CUDA kernel `hashemi_mega` around the six functions, `HashemiMetal` (MPS), `mega_numpy`; `python hashemi_kernel.py` = Metal vs NumPy on 4096 random states |
| `hashemi_env.py` | `HashemiMachineEnv`: his machine as a puffer env (`puffer_hashemi_ccc`, `puffer_tandoor/hashemi_ccc.ini`); the sensor loop of the video as a policy |
| `hashemi_reward.metal`, `hashemi_reward.json`, `hashemi_reward_kernel.py` | the trainer's reward as its own kernel (`rewardStep`, HashemiReward.lean): 3 columns, the ini's constants as inputs; `python hashemi_reward_kernel.py` = Metal vs NumPy |
| `test_reward_columns.py` | R1 gluing, R2 units, R3 non-negativity - the reward measured on a day rolled on both paths |
| `test_ccc.py` | the C header (double) against the Lean `Float` twin on the same samples, all 315 functions |
| `test_mega_day.py` | a day at Quetta under the sensor loop: tracking, the reach, every theorem column at every state |

## Regenerate

```
cd ~/manifold-pareto/lean
lake build RequestProject.HashemiPropsGen    # writes HashemiProps.lean (the theorems as predicates)
lake build RequestProject.HashemiProps       # Lean checks each prop_X against its theorem
lake build RequestProject.HashemiCcc         # writes the header, the twins, the manifest, dot/
lake build RequestProject.HashemiCccRound    # the rfl round trip of every definition
cd ~/ARTIST-compliant/tutorials/hashemi_ccc
.venv/bin/python test_ccc.py                 # C vs Float twin
.venv/bin/python hashemi_kernel.py           # Metal vs NumPy
.venv/bin/python test_mega_day.py            # the machine through two days
```

## The verification layers

1. **Theorem round trip, in Lean.** `prop_X_ok : ∀ data, prop_X data := X` for all 115 compiled
   theorems (109 of the design, 6 of the trace): the printed statement is the theorem's, up to unfolding (`simpa` with the file's
   definitions, `funext_iff`, `Prod.ext_iff`, `Fin.forall_fin_succ`, `Matrix.cons_val`).
2. **Definition round trip, in Lean.** `f_ccc : f = fun … => printed := rfl` for 196 definitions and
   predicates (the seven structure instances have no `ℝ` printing).
   The 24-fold bisection (`swingOfLength`, `step`, `megaStep`) is beyond a single `rfl`: `isDefEq`
   zeta-reduces the printed `let`s, so the shared graph becomes a term that doubles at every level
   (measured 2.2x per level; 4M heartbeats are gone by level 16). Their statement is the same - the
   whole flat graph - but the proof is STAGED: `lift_lets` turns the twin's `let`s into local
   definitions, `intro` names them as the printer did, and one `have` per bisection level relates
   the composite to them, each level seeing the previous one as the same local on both sides
   (`stagedProof` in `lean/HashemiCcc.lean`). 12-15 s each, against a timeout before.
   `dishPower` - the whole optical pipeline of one ray, sampler through capture - needs the same
   `lift_lets` but no chain: it is flat, not iterated, so once the shared subgraph is a local
   context instead of a zeta-expanded tree the single `rfl` closes it (`chain := false` in its
   `stagedCfg` row; ~134 s, against a timeout before).
3. **C against Float.** 1041 samples over 347 functions agree to 1e-12; the 115 theorem checks are
   true in double.
4. **Metal against NumPy.** The whole 226-column row over 4096 random states in the tracker's range
   agrees to 1e-3 (single precision; a boolean column may flip at an exact boundary in a handful of
   agents).
5. **The theorems at the machine's states.** Through two days at Quetta, every one of the 106
   theorem columns of the row is 1 at every step of every agent.

## The competing env: his concentrator on the tandoor (`puffer_hashemi_ccc`)

`hashemi_tandoor_env.py`, `puffer_tandoor/hashemi_ccc.ini` (hashemi.ini with `gpu = 0`,
`trace_rays = 64`). The tandoor env is kept whole - its pot, wall chain, bread, guillotine,
observations and reward are what `puffer_hashemi` and `puffer_flower` score on. Two things come
from Hashemi.lean through Ccc instead: the pose (the state (az, t, slack) advanced by `hk_step`,
the parent's motors still and its pose set from the Lean state) and the power into the pot (his
1.6 m satellite dish traced by `hk_traceRayK` with the sun on its disc and 2 + 1 mrad errors, the
capture on a 12 cm aperture at F, times the dish's area, reflectance and the DNI, delivered along
the parent's own beam profile over the floor and belt). The parent's level head is pinned and its
jam head held on, since this dish has no membrane. `test_tandoor_env.py`, a naive cook on day 172:
1.1 to 1.4 kW into the pot, the belt at 410 to 420 K, about 100 rotis by 16:00, 4 ms per step at
16 agents. Training is `puffer train --config hashemi_ccc.ini`; the metric is the parent's.

## Speed (`bench_kernels.py`, Apple GPU over MPS, single precision)

| kernel | agents | per launch or step | per agent-step |
|---|---|---|---|
| `hashemi_mega`, the generated kernel: 226 columns, 315 inlined functions, the 24-step bisection | 8 192 | 0.30 ms | 37 ns |
| same | 65 536 | 1.06 ms | 16 ns |
| same | 262 144 and up | 3.2 ms per 262 144 | 12 ns (83 M agent-steps/s) |
| the handwritten mount solve alone (`MetalGeo.mount`, one launch) | 8 192 | 0.29 ms | 36 ns |
| `HashemiMachineEnv.step` (the generated kernel plus the sun, the observation and the reward in NumPy, host copies each step) | 8 192 | 4.2 ms | 506 ns |
| `TandoorHashemiEnv.step` on hashemi.ini (the handwritten megakernel: motors, mount, 512-ray trace, thermal, reward) | 8 192 | 34.5 ms | 4 209 ns |
| the NumPy twin of the row (the reference) | 8 192 | 24 ms | 2 971 ns |

Like for like - the mount - the generated kernel costs what the handwritten launch costs (both are at
the launch floor at 8 192 agents), while computing every definition and theorem of the file rather than
one frame; at a quarter million agents it runs at 12 ns per agent-step. The tandoor step is a hundred
times dearer per agent because it traces 512 rays per agent through three mirrors and steps a thermal
pot; the Lean gives the mount, the loads and the optics as closed forms, which is why the row is cheap.
The env around the generated kernel is fourteen times its kernel: the observation, the sun and the
host-to-GPU copies are still NumPy, the next thing to move into the kernel.

## Lean calls the GPU: the bridge, his dish's trace, the measured theorems

`bridge/metal_bridge.m` is one C function, `lean_mtl_run`, in Objective-C: it JIT-compiles an MSL
source, binds Lean `FloatArray`s as float32 or int32 buffers, dispatches, waits and returns them.
`lean/MetalBridge.lean` binds it with `@[extern]`; `bridge/build.sh` builds the dylib against the
project's toolchain and the lakefile links it. Any kernel of the project runs from Lean through
it: `lake exe bridge_smoke` is a two-line kernel, `lake exe trace_check` the measured theorems.

`lean/HashemiTrace.lean` is his dish's ray trace composed from the file: the exact sphere
(`sphereHit`, the law of `TandoorSphere.reflect` in three components), the flat 5 cm facet
tangent to the sphere at its centre (`traceFacet`, `traceRay`), the coil's plane at F, the dish's
frame from the swing and azimuth (`dishAxes`, `sunInDish`) and its equivariance theorem
`sunInDish_equivariant`, PROVED: the machine and the sun turned together leave every ray in the
dish's frame unchanged - the fixed focus at the level of the trace. The same file holds the
conic homotopy (below). `lean/Feedback.lean` is the fixed-point lemma: a bounded feedback whose
`done` states are fixed attains its least fixed point at stage N (`iterate_stationary`), the
theorem a bounce cap silently assumes; every ray here terminates after one bounce
(`single_bounce`). `hashemi_trace_kernel.py` wraps `hk_traceRay` and friends as Metal kernels and
samples rays (a facet, a point in it, the sun's disc); the env's reward now comes from the
traced capture (`trace_rays` per agent per step) with the added model kept beside it.

`bridge/export_scene.py` records one real dispatch of the handwritten tandoor kernels (the mount
solve and the 31-buffer trace, hashemi.ini at 16 agents, deterministic) so `trace_check` can
replay them with edited inputs. `lean/TraceCheck.lean` then measures, on the GPU, from Lean (24 checks; the tri ones in the next section):

| measured theorem | result |
|---|---|
| the sphere trace misses the plane by `dev R h c` and crosses the axis at `focal R h` (OpticsSphere) | 0 m difference over 8 heights, 2 planes |
| the caustic: the paraxial spot is `blur R H`; the best plane is within half (`paraxial_focus_not_best_witness`) | 0.0982 m = blur; 0.0491 m at z 0.954, exactly half |
| every ray of the panel has one fate (`Feedback.single_bounce`) | 25 600 rays, 14 452 captured on axis |
| the facet spot at F against `facetSpot` | traced 1.13 m across vs 0.059 m: the panel's corners are 1.13 m out on the R 2 m sphere; 56 % of the on-axis rays on the coil, 76 % at the best plane |
| capture is antitone in the pointing error (`power_antitone_duct`) | 0.60, 0.59, 0.46, 0.11, 0.03, 0, 0 at 0, 0.5, 1, 1.5, 2, 3, 4 deg; the added model said 1.0 to 1.7 deg |
| the fixed focus at the trace (`sunInDish_equivariant`, proved; here in float32) | 0 |
| the conic at k = 0 is the sphere (`conicZ_sphere`, proved), at k = -1 the paraboloid (`conicZ_paraboloid`) | 0 m; 0 m |
| a cap that does not turn toward the sun: the best conic along the homotopy is interior | best k -0.75, -0.5, -0.5, -0.5 at 5, 10, 20, 30 deg of tilt |
| the sphere is indifferent to the sun's direction when the cap faces it (the fixed focus by translation alone) | J = 0.034835 m at every tilt |
| the paraboloid is not: coma | J(-1, alpha) 0, 0.031, 0.114, 0.457, 0.955 m |
| the replay reproduces the recorded mount and trace | 1e-6 |
| totality and conservation on the tandoor trace | 8 192 rays, one fate each; absorbed 96.1 of 104.0 m² per unit DNI delivered |
| blur is antitone for the rays focused inside the entry (`power_antitone`, same draws); the total first rises (`exists_blur_captures`) | 102.6, 100.9, 98.3, 89.5, 60.7 vs all rays 95.9, 95.8, 96.1, 92.2, 67.0 at sigma x 0.25..4 |
| pointing is antitone (`power_antitone_duct`); the half-power angle | 96.1 to 0.17 over 0..2 deg; half power at 0.73 deg |
| the site turned 20 deg with the machine | 1.06 % change: the beam is the same, the fold, slot and horizon do not turn |

The two days with the traced capture in the reward (64 agents, 15 s, the sensor loop): 38.6 MJ on
the coil in June and 16.1 in December, against 67 and 31 under the added model; the 106 theorem
columns still never false.

## The tri machine along the homotopy (the receiver that matters)

The tri train takes the film's shape as buffers: the aperture points on the membrane per pressure
level and their normals, from the env's FvK/NURBS solve. `trace_check` fits the conic family to
those points and replays the train with conic primaries of the same vertex curvature along k.

| measured, through strip, M4 and pot | result |
|---|---|
| the film's shape at the working level is a conic | c 0.123 (f 4.065 m), k = -0.80, rms 0.087 mm: a near-paraboloid, not a sphere; over the seven levels k stays in -1.15..-0.80 while f runs 4.85 to 3.91 m, so pressure moves the curvature, not the conic constant |
| the conic at the fitted k reproduces the film's power | 96.38 vs 96.10 m² per unit DNI, 0.29 % |
| the capture at the pot along k, same vertex curvature | k -1: 92.4, -0.9: 93.9, -0.8 (the film): 96.4, -0.5: 103.9, -0.25: 111.7, 0 (the sphere): 116.7 - a 21 % gain the sphere end would give |
| the pointing budget along k | half power at 0.736 deg (the film) and 0.750 deg (the sphere): the strip's acceptance, not the primary, sets it |

So the homotopy parameter is the lever and the pressure is not the knob for it: pumping changes
the focal length by a quarter and the conic constant by a tenth. Moving the film toward the sphere
needs a shaping boundary - the rim tension, the strings of the user's description - and that is
the learning problem's real control on the tri machine, with the traced capture at the pot as the
reward and the fitted k per level as the observation.

## Radiometry, not geometry: the three SolTrace objections, fixed (30 measured theorems)

- **The sun and the statistics.** `mcRays` in TraceCheck.lean draws each ray Monte Carlo from Lean's own
  generator: a facet, a point in it, the direction on the sun's 4.65 mrad pillbox disc. Capture is a
  Bernoulli estimate quoted with its standard error. With zero errors the error-bearing trace agrees
  with the trace on 40 000 of 40 000 fates.
- **Optical errors.** `traceRayErr` tilts the facet's normal by a Gaussian slope error and the reflected
  direction by a specularity error, SolTrace's model. On axis, N = 40 000: 0.591 +- 0.002 with no
  errors, 0.590, 0.589, 0.584 at 1, 2, 4 mrad of slope, 0.589 at 2 mrad slope with 1 mrad specularity.
  His dish is aberration-limited: 4 mrad is 8 mm at F against a 1.13 m spot. The pointing cliff with a
  sampled sun and 2 + 1 mrad errors: 0.596, 0.551, 0.376, 0.145, 0.034, 0.000 at 0, 0.5, 1, 1.5, 2, 3
  deg, each +- 0.003 or less, antitone within its error bars.
- **The stage model.** His dish is an instance of the train in Feedback.lean (`facetStage`, `coilStage`,
  `dishTrain`), and `dishTrain_fate` PROVES the train's fate after its length is `traceRay`'s fate
  code. So the fixed-point theorem is about the compiled trace, `train_done` covers every receiver's
  sequence of surfaces, and "every ray has one fate" on the GPU is its measured side.

## The day as a path, and the rim-shaping family (27 measured theorems)

**The admissible set is a path.** The film's seven recorded pressure levels through the tri train,
tracked exactly at each hour: the best level is 5 at every hour, not the design's 4, which is 17 to
20 % below at midday and within 5 % only in the morning and afternoon; levels 0 to 2 capture nothing.
The admissible set is an interval at every hour, so the day's path is one class: {4, 5}, then {5},
then {4, 5}.

**Every receiver is a train** (`lean/Feedback.lean`): a ray with a stage and a fate, a step that
lets the stage's surface set a fate or pass the ray on, and the theorems `train_done` and
`train_fixed`: after as many steps as there are surfaces every ray has a fate and the iterate is
stationary. The kernel's fixed sequence of surfaces is that fixed point, and "every ray has one
fate" is it measured.

**The rim-shaping control as a NURBS family** (`bridge/film_family.py`): the film's own zoned solve
at per-zone pressures, re-bisected to the design focal length, fitted into ARTIST control points
warm-started from the working level, evaluated at the env's aperture, consumed by the trace.

| control (f held at 4.05 m) | power at the pot, m² per unit DNI |
|---|---|
| uniform pressure (zoned law at 0) | 48.0 |
| zoned law at 0.2 | 82.8 |
| **zoned law at 0.4, the design** | **96.1** (refit of the record: 96.103 vs 96.103) |
| zoned law at 0.6 | 76.2 |
| zoned law at 0.8 | 46.7 |
| rim zone pressed softer (x0.6) | 85.1 |
| rim zone pressed harder (x1.4) | 73.0 |
| a ring pressed in, one zone short of the rim | 35.3 |

The design's zone law is a sharp optimum for the strip and M4 as built: at 5 % it is the only
admissible member of this family. Caveat kept with the numbers: the fits of shapes far from the
warm start converged worse (20 to 45 mdeg mean slope error against 12 for the baseline, local
maxima over a degree), so part of those losses is fit noise; the baseline's exactness is the
method's, the far shapes want longer fits from their own warm starts.

## The homotopy: from the paraboloid to the sphere, without a film model

The user's problem (2026-09-18): the sphere is the fixed-point set of the rotations about its
centre, any cap of it has the fixed-focus property, and a pumped film is a continuous distension
of one; the learning problem lives on the homotopy of shapes and the pressure is a chart onto it.
`HashemiTrace.lean` gives the path the trace theorems need: the conic of revolution
`z = c r² / (1 + sqrt(1 - (1 + k) c² r²))`, `k` from -1 (the paraboloid) to 0 (the sphere), a
closed-form ray hit, `conicZ_continuous` in `k` (proved), the endpoints proved. No FvK: the film
model would only supply the chart from pressure to `k`, which the sensor measures; what FvK still
holds that topology cannot is the reachable set and the knob's monotonicity. The table above is
the first use: for a cap that cannot turn, the admissible `k` at each tilt is an interval around an
interior optimum, one homotopy class, and the sphere's advantage appears only when the cap faces
the sun - which is what the orbit does for the tandoor and the swing does for his dish.

## What the kernel does NOT take from Hashemi.lean

Said in the code where it happens: the sun (the tandoor's `solar_position` and Meinel DNI); the
motors' full-command rates (a 0.5 deg/s yaw slew, a 1 cm/s wire speed); the coil capture law
(`coilCapture`, two discs' overlap: the spot is `facetSpot`, its shift `TandoorMount.spot`, the coil
12 cm - the only law added, marked as a model); `megaParams` (drum radius, the dish's weight and
centre of mass, the wire's rating, the mosaic's reflectance, the drive force, the bearing rating,
the rod length). Thirteen declarations do not compile and are reported by the driver: the
higher-order `AlwaysTangent` and its two theorems, the three `LinearIndependent` statements, the
two span memberships, `setLength_surj` (an existential), the three exact-tracking theorems (a
binder `θ : ℕ → ℝ`) and `swingFocus_fixed_iff` (a `∀` over `ℝ` inside an `↔`).

## The two days (64 agents, 15 s steps, the sensor loop)

| day | the sun above the wire's reach | in the tracker budget (of sun-up steps) | stalled at the reach | energy on the coil |
|---|---|---|---|---|
| 172 (June) | 07:20-16:40 | 70 % | 1022 steps | 67 MJ |
| 355 (December) | 09:50-14:10 | 45 % | 1435 steps | 31 MJ |

The wire's dead point is 61.73 deg of swing (`deadPoint`, `deadTan_at_ym`), the sun at 28.27 deg;
with the assumed 2 kN of pull the winch stops where `HoldsDish` stops holding, 61.14 deg (the sun at
28.86), the tension there 1.75 kN against the 934 kN the formula gives at the dead point itself.
Tracking is within 0.05 deg in elevation and 0.06 in azimuth (the budget: `TrackerBudget`, 1.7 deg),
the capture 1.00 and the power 1.65-2.06 kW on the coil while the sun is in reach; below it the
dish waits at the reach and the capture falls through 0.44 at 3.5 deg of error to 0 - the video's
closing shot, the dish pulled up and the sun on the horizon. The winch's power `elPower` is under
0.02 W while tracking (`tracking_power_tiny`).

## Running it from the stock CLI

`puffer train puffer_hashemi_ccc` needs two symlinks in the venv's pufferlib, both pinned to THIS worktree
(the user's `tandoor` package symlink points at the main checkout, which has no `hashemi_ccc/`):

```bash
SP=$(tutorials/puffer_tandoor/.venv/bin/python -c "import pufferlib,os;print(os.path.dirname(pufferlib.__file__))")
ln -sfn $PWD/tutorials/puffer_tandoor $SP/environments/tandoor_ccc
ln -sfn $PWD/tutorials/puffer_tandoor/hashemi_ccc.ini $SP/config/hashemi_ccc.ini
```

The ini says `package = tandoor_ccc`. pufferlib promotes RuntimeWarnings to errors, so the NumPy twins run
under `np.errstate`. The numpy path costs ~0.5 s/step at the ini's 8192 agents (the parent's numpy step);
lower `num_envs`/agents for a first run, or wait for the fused gpu path with the traced power injected.

## The fused GPU path (`gpu = 1`, the training path)

The parent's whole step runs in Metal (mount, step_pre, trace, step_post on one packed state).
`HashemiTandoorEnv._gpu_full_step` advances the Lean state by `hk_step` from the action heads,
writes the pose into the packed state's motor columns before the mount, and `tandoor_fused_step`
calls `env._fused_power(F, aux, soil_eff)` in place of the tandoor's trace: `sunInDish` compiled
(one thread per agent), the facet/disc sampler on the device, `hk_traceRayK` at k = -1, and
`F.per` = dish area x reflectance x capture x shading, along the tandoor beam's node profile
(recorded from the parent's own trace on the first fused step). Cut agents (step_post re-parks
their motors) and the day-over park resync the Lean state from the motors. The slope and
specularity errors are folded into each ray as one Gaussian tilt of sqrt((2 s_slope)^2 + s_spec^2)
on both paths (the k-trace takes no error inputs; the error trace is sphere-only).

Day 172, 16 agents, the naive cook: numpy 99 rotis at 4.8 ms/step, fused 92 at 7.3 ms/step;
capture 0.96-0.97 on both. Fused at the ini's 8192 agents: ~7.5 ms/step (numpy: 526).
`test_tandoor_env.py --gpu 1` runs the fused day.

## The optics as one morphism, the conditions as Ω-columns

`dishPower` (HashemiTrace.lean) is the sampler (`sampleRay`, a function of six uniforms), the
conic trace with the optical errors at the surface (`traceRayKErr`, SolTrace's treatment) and the
delivery, composed: draws × pose × sun × parameters → (captured, m² per unit DNI, fate). Ccc
carries it to the C twin (`dish_numpy`, the env's numpy path) and to Metal (`hashemi_dish`, the
fused path); the env supplies the draws and takes the mean over the rays. The translator learned
`⌊·⌋` for the facet grid. Its parts round-trip by `rfl`; the composite by the twins (1083/1083).

`SunReachable` (π/2 − tDead ≤ elSun) and `LostSun` (reachable and the pointing error past the
1.7° budget) are two Ω-valued columns of the megakernel (`sun_reachable`, `lost_sun`, 228 columns
now), with `lostSun_unreachable` and `lostSun_within_budget` proved. The parent's day and cut are
pulled back along them: its `el_min` and `lost_deg` are set to the spec's constants, and the day
test counts the parent's flags against the columns (100 % on day 172, both paths).

Day 172, 16 agents: numpy 95 rotis, fused 94; fused at 8192 agents 5.5 ms/step. Day 355 (the sun
under the winch's reach until mid-morning and again by 14:00): no cut, no bake - three hours of
1.4 kW do not bring the cold pit to temperature.

## One morphism, one megakernel (the current shape)

`hashemiEnv` (HashemiEnv.lean) is the env's whole step as one Lean definition: `megaStep` (the
mount) then, on the new pose, 64 rays of `dishPower` and their sum, then `heatStep` (the coil at
F, hot oil in insulated copper pipes, the exchanger in the pot's wall; HashemiHeat.lean). The rays
are independent, so they TENSOR: Ccc's reduction layer takes a binder `Fin P → Fin m → ℝ` as a ray
table and `∑ i : Fin P` as a sum node, and every printer splits into the agent-level prelude, the
ray level and what follows the reduction. The optics and the heat are dependent, so they COMPOSE.
Ccc prints the one graph three ways:

* `hk_hashemiEnv` in C - the rays as a loop - and its NumPy twin (a `(B, P)` axis, `np.sum`);
* `hashemi_env` in Metal (`printMslMega`): a threadgroup per agent, a thread per ray, the two sums
  through threadgroup memory, thread 0 writes the 27 columns. `hashemi_env_kernel.py` runs it:
  0.36 ms/step at 2048 agents, Metal == NumPy on every column;
* its tangent and box (the Modula layer) with the ray tables as points.

The env (`hashemi_tandoor_env.py`) launches it once per step on both paths; the exchanger's power
enters the parent's pot through the parent's own gate (`per = q_pot / (gate x 0.85)` along the
beam's node profile; the exchanger opens with the gate). Nothing optical or thermal lives in the
host any more. Day 172, 16 agents: 77 rotis on both paths, the oil at 465-487 K, the pot fed
1.0-1.2 kW; the fused env at 8192 agents 4.2 ms/step (one machine launch beside the parent's four).

Proved in HashemiHeat.lean: `qNet_antitone`, `steady_unique`, `steady_exists` (IVT),
`steady_conservation` / `steady_pot_le_abs`, `qNet_lipschitz` and `oilStep_lipschitz` (the step's
modulus, `1 + dt K / Coil`). In HashemiEnv.lean: the capture in `[0, 1]`, the pot's bound, the
oil's limit. All of it compiled (396 functions, 138 theorem checks, 1188/1188 samples C vs Float,
247 rfl round trips; the composite by the twins).

`bridge/derivation.py` is the runner after Nix: a kernel run is a derivation (sources hashed, a
builder, inputs from other derivations, outputs in a content-addressed `bridge/store/`) walked in
phases - unpack, configure, build, check, install - and not rebuilt while its inputs are unchanged.
Ccc composes the physics into one kernel; the derivation composes the build around it.

## The policy, from the spec (HashemiPolicy.lean)

His machine is one mirror on two motors, so its policy interface is a fact of the spec, not of
the tandoor's nineteen heads. HashemiPolicy.lean states it and Ccc extracts it:

* the actuation: `driveAz` / `driveEl` (full command = `azFull` / `elFull` of the dish, the drum's
  rate at the wire's current lever arm), the seven-level head through `headToCmd`;
  `quantum_outruns_sun` and `quantum_within_budget` prove the finest step is faster than the sun
  and inside the tracker's 0.03 rad budget - the property the first training run lacked (the
  drum was scaled 22x too fast);
* the sensing `obsOf`: the rim sensor's two pointing errors, the swing, the wire's state, the
  oil, the two smooth gates;
* the reference `follower` (Mount.lean's saturated follower per axis): `follower_step_az/el`,
  one step inside the budget zeroes the error; `tracks_exactly` keeps the sun at the drives' rates;
* `mlpPolicy`: 16 tanh units over the 8 observations, its weights INPUTS shared by every agent
  (the translator reads `fun i : Fin n => …` as an n-vector and unrolls a sum that does not touch
  a ray table's row, so a matrix-vector product needs no new node); `mlpPolicy_bounded`;
* `hashemiLoop`: observation, policy, drives, the env's step - one morphism, `hashemi_loop`
  one Metal kernel (2175 nodes, 37 columns, Metal == NumPy), its tangent and box with it.

`hashemi_policy.json` is the description the env reads: the motor heads, the levels, the
observation and command names, the loop's columns. The env maps its heads through the compiled
`headToDriveAz` / `headToDriveEl` (the NumPy twin on one path, the same formula on the device on
the other). `hashemi_loop_kernel.py` runs the loop and shows the follower expressed as weights of
the interface.

`hashemi_policy.py` is emitted by the driver too: `observation_space()` (a Box with the spec's
`obsLo` / `obsHi`), `action_space()` (the two commands in `[-1, 1]`), `action_space_heads()` (the
seven levels), and `heads_to_commands` / `commands_to_drives` through the compiled `headToCmd`,
`driveAz`, `driveEl`. The env exposes them as `machine_observation_space`, `machine_action_space`
and serves `machine_obs` from the kernel's own observation columns. In the megakernel the
prelude runs once on thread 0 and the values the ray level reads are broadcast through
threadgroup memory; the rays run on every thread; thread 0 reduces, finishes, writes.

The policy learns to point; no sensor closes the loop (the follower in HashemiPolicy.lean is a
proved reference, not the controller). The shaping that makes that learnable is the light
arriving at the receiver, the spec's `p_in` column, paid every step in roti units: energy per
step over the roti's energy, times `capture_shaping` (0.2) times the parent's 5 per roti, only
while the sun is within the winch's reach. It is delay-free where the oil loop lags minutes and
the rotis hours, it is the physical quantity the rotis are made of, and it is non-negative, so
the guillotine can never be an exit. Both shaping terms go in in the parent's raw units before
its `reward_div` on both paths (`roll_checkpoint.py` shows a checkpoint's day hour by hour; the
epoch-260 policy of the first run was found riding a 1.4 deg lag and leaving at the noon
keyhole because the earlier per-step penalty entered raw on the fused path and divided on the
numpy path, 75x apart, and made being cut cheaper than a day near the cliff).

## The loop as a field (HashemiField.lean)

The energy density along the loop, `u = ρ c A T`, and the power flux, `Φ = v u`, obey
`∂ₜ u + ∂ₛ Φ = σ - λ (T - Tₐ)`; the lumped balance of HashemiHeat.lean is its zero mode. Two
transports are linear with closed Green's functions and the kernel carries them:

* the pipe: `δ(s - s' - v (t - t')) e^{-a (t - t')}`, plug flow with attenuation - the oil at
  the pot is the coil's outlet two steps ago scaled by `pipeGreen = e^{-U/mcp}` (`pipeGreen_pos`,
  `pipeGreen_le_one`, `pipeGreen_semigroup`: two runs attenuate by the product; `delivered_le`).
  The state along the pipe is the history of outlet temperatures, `shift`ed a station per step;
* the coil: the oil crosses it in a second, so its field along the eight turns is a fold from
  the inlet through each turn's source and loss (`coilProfile`, `coilProfile_balance`: the
  discrete continuity law, telescoped);
* the receiver's flux: the trace's landing radii binned into eight annuli (`inBin`,
  `bins_partition`: the annuli partition the aperture), sums over the rays in the megakernel.

`hashemiEnv` carries all of it as columns: `flux_0..7` (W per annulus), `coil_0..7` (K along the
turns), `hist_0..15` and `ret_0..15` (the two histories, K). The pot wall's Green's function
(Duhamel's half-order integral of the flux) is the parent oven's physics and stays there.

## The beam-down receiver (HashemiBeamdown.lean)

The coil at F gives way to a hyperboloidal secondary inside the coil's envelope: far focus F, near
focus F₂ below, the return beam through the slot into the tunnel; the tri chain is dish,
hyperboloid, tunnel. `hyperbola_reflects` certifies the focal property (a polynomial identity,
sympy's certificate in `linear_combination`); `traceBeam` is one ray from the dish's reflection to
the secondary, the slot test at the dish crossing, the landing at F₂; `FitsReceiver` the cap's
volume; `hashemiEnvBeam` the env's step with it (`hashemi_beam` kernel, 31 columns). The env runs
it with `machine_receiver = beam` (`beam_dm`, `beam_rm`, `beam_slot`, `beam_rt`, `beam_L`,
`beam_beta`).

What the trace says (`beam_design.py`, day 172): inside the coil's volume the cap is 6 cm at 6 cm
from F, the magnification `(L - dm)/dm` is 20, a third of the dish's cone misses the cap because
the facets' blur at F is 6 cm; the day's capture is 0.14 through the 6 cm slot, 0.41 through a
60 cm slot, 0.46 with no dish in the way; tilting the axis to the azimuth tube halves the hit. In
the env: 2.5 rotis a day through the 6 cm slot, 36 through 60 cm, against the oil loop's 79. The
shape is exact; the facets and the slot are what decide the chain.

## The receivers as one GADT

`RequestProject/OpticGadt.lean` (mirrored in `lean/OpticGadt.lean`). Every receiver chain the
project has - the two already in Lean and the three in the simulator's cores - as values of ONE
indexed family, with a ray-trace interpreter over it.

**The type.** `Optic : Port → Port → Type`, indexed by what a stage takes and what it delivers:
`sky` (the sun's rays at the aperture), `cone` (a ray in open air), `bore` (a beam inside a bore,
tube or light pipe), `spot` (a landing on the receiver). `St : Port → Type` is the state at a port
(a ray, or a landing); a chain only typechecks when its elements meet. It is a SPEC-level object -
`trace` erases the indices at every concrete chain, so the translator still sees a plain function of
reals (`oilCapture : ℝ → … → ℝ`, `#check`ed at the foot of the file).

**Constructors.** `nil`; `primary` (faceted conic dish, `conicZ`'s `k`, SolTrace's σ_slope/σ_spec);
`flatMirror` (the fold at F, the flat M4 of `u_f2 = 0`); `hyperStrip` (the rotating hyperboloid
strip); `gregStrip` (the ellipsoid beyond F); `ellipMirror` (the ellipsoid M4/M5); `actuatedM3`
(the same figure rigidly turned by ψ - `_m3_figure`); `slot` (the flapped slot in the membrane);
`stop`; `boreTube`; `lightPipe` (ρⁿ); `cpcLip` (the Winston lip, eight conical segments); `elbow`;
and the terminals `coil`, `beamDown`, `pot`, `bread`; `seq` is composition - the Modula product.

**The chains**, with their sources (`tutorials/`):

| chain | elements | numbers |
|---|---|---|
| `cass` | dish, slot, hyperboloid strip, bore, M4 (ellipsoid), elbow, pot | `w_slot 0.7`, `slot_el 54°`, `d_strip 0.6`, `r_bore 0.7`, `r_m4 1.3`, `r_duct 0.20` — tandoor_hashemi_env.py:996-1004, 1179; `_build_cass_chain` :1789 |
| `tri` | as `cass` but M3 actuated onto the loaf, no elbow at the end | `tri_target` :1761, `_m3_figure` :1781, `receiver == "tri"` :1067 |
| `focus` | dish, M1 flat at F, off-axis collimator M2, flat M3, chase, off-axis M4, pot | `r_m1 0.15`, `col_dist 0.75`, `col_radius 0.5`, `r_m3 1.0` — `_build_focus_chain` :1653 |
| `fold` | dish, flat fold at F, tube, CPC lip (8 cones), pipe, M5 ellipsoid, pot | `_geo_core` :150-380, `z_m5 -0.10` :995 |
| `flower` | head membrane, the light pipe's mouth as F, the pipe down (Masdar beam-down) | tandoor_flower_env.py:374 |
| `deepDish` | dish, Gregorian cap past F, bore, coudé ellipsoid relay, pot | hashemi_relay.py:1-28 (the relay must be an ellipsoid: a sphere at 20° blurs 104-128 mm) |
| `hashemiOil` | his faceted satellite dish, the copper coil at F | `dishR 2`, `dishF 1`, `dishHalf 0.8`, facets 0.05, `rc 0.06` — Hashemi.lean:1225, HashemiTrace `traceParams` |
| `hashemiBeam` | his dish, the hyperboloidal secondary, the slot, the tunnel | `beam_L 1.25`, `beam_dm/rm 0.06`, `beam_rt 0.55`, `beam_slot 0.06` — hashemi_tandoor_env.py:59 |

The quadric hits are the twins' own: `hypHit` is `_hyp_hit` (tandoor_hashemi_env.py:561, smallest
positive root on the F sheet), `ellipHit` is `_ellip_hit` (:600, the far root). Fates are the miss
ledger's codes (2 no secondary, 3 off the strip, 6 the bore, 7 M4, 8 the way to the pot, 9 the
collar, 13 the slot).

**Theorems, no `sorry`.** `clip_seq`: the throughput of a composite is the product of its factors -
the Modula composition rule for the one quantity every stage multiplies; `clip_nonneg`,
`clip_le_one`. `toTrain` / `throughput_toTrain`: the forgetful map into `Optics.lean`'s paraxial
`Train` preserves the throughput, so Liouville's theorems there are theorems about these chains -
`etendue_le` (the étendue never increases) and `etendue_conserve` (in = out + every loss).
`trace_seq_inl` / `trace_seq_inr` (a fate on the way is the chain's fate), `trace_nil_seq`,
`trace_seq_nil`, `trace_seq_assoc`, `clip_assoc`: `seq` is a category with `nil` as its identity.
Agreement with what was already traced in Lean: `hashemiBeam_agrees` is `rfl` - the beam-down
terminal IS `HashemiBeamdown.traceBeam`; `oil_agrees` (via `oil_through_iff` and `oil_capture_iff`)
proves the dish-plus-coil chain delivers exactly the rays `HashemiTrace.traceRayKErr` calls
captured, which is `dishPower`'s column 0.

**What is not pinned down.** No interpreter has a `sorry`, but two stages carry their throughput and
leave the ray as they found it, and say so in their docstrings: `cpcLip` (the traced bounce off the
eight conical segments of `_geo_core`) and `lightPipe` (the tunnel's bounces). Their geometry lives
in the Python core and the kernel; the family carries their clip, which is what the étendue
bookkeeping needs.

## The trainer's reward, printed (`HashemiReward.lean` -> `hashemi_reward`)

The physics of this env was a compiled morphism and the REWARD was not: it was assembled by hand
on each path, and on 2026-09-19 it was wrong twice - the per-step shaping went in raw on the fused
path and divided on the NumPy path (a factor of `reward_div` between two restrictions of the same
section: it did not glue), and a per-step PENALTY made the guillotine an exit. TOPOS_REWARD.md is
the design; `lean/RewardTopos.lean` its 21 statements. This is the part the driver now compiles.

`lean/HashemiReward.lean`, namespace `TandoorHashemi`:

* `rewardShapeRaw dt pIn reach capShaping rotiReward rotiEnergy` - the light at the receiver
  (`hashemiEnv`'s `p_in`, gated by `sun_reachable`) as a step's energy in roti units, at the
  parent's raw price of a roti;
* `rewardStep parentRaw dt pIn reach rewardDiv capShaping rotiReward rotiEnergy : Fin 3 → ℝ` -
  `rewardNames` = `r_shape_raw`, `r_raw`, `r_trainer`. **Every constant is an INPUT**, so the
  ini's `reward_div = 75`, `capture_shaping`, the parent's 5 raw per roti and `roti_kj` are
  handed to the kernel; nothing is frozen into the spec and nothing is arithmetic on a host.
  `reward_div` occurs ONCE, in the third column.
* `rewardStep_units` (R2, the naturality square) and `rewardStep_nonneg` (R3) are compiled with
  the other theorem checks and measured by `test_ccc.py`.

The driver prints it like every other definition - `hk_rewardStep` in `hashemi_ccc.h` /
`hashemi_ccc.py`, the Float twin, the round trip (`rewardStep_ccc`, `rfl`) - and as its own tiny
kernel `hashemi_reward.metal` (8 inputs, 3 columns, 15 nodes, one thread per agent) with
`hashemi_reward.json` its manifest. It is a separate launch rather than three more columns of
`hashemi_env` because the parent's own reward for the step exists only AFTER the machine's step.
`hashemi_reward_kernel.py` runs Metal against the NumPy twin (`METAL == NUMPY over the reward`).

`hashemi_tandoor_env.py` takes `r_shape_raw` / `r_raw` / `r_trainer` from that function on both
paths (`_reward_cols`, `self.r_cols`): the fused path hands the kernel the parent's raw `rew_t`
and returns `r_raw` (the parent's own division after `_finish_step` IS the third column); the
numpy path lifts `self.rewards` back into the raw fibre once - the change of base `scale_natural`
licenses - and writes back `r_trainer`. The capture shaping is now IN the spec. The potential-based
pointing term (`pointing_shaping`, 0 in every ini) and `lost_shaping` stay host-side: they are a
coboundary and a gate, not units, and when they are on they are folded into the morphism's
`parentRaw` input so the division still happens once, inside the printed function.

**The measured checks** are `test_reward_columns.py` (a day rolled on both paths):

* **R1, gluing** - `|r_trainer_numpy − r_trainer_fused|` per step, and the hour means where the
  two paths' draws differ. A units bug shows here as a factor of `reward_div` at once.
* **R2, the units** - `r_trainer · reward_div − parentRaw = r_shape_raw`, per step, per path.
* **R3, non-negativity** - `min r_shape_raw ≥ 0` over the day, so `cut_never_pays` applies.

They are a Python script and not TraceCheck rows because the bridge drives a Metal kernel with
given inputs; it cannot roll a day of the puffer env on two paths, which is what R1 is. The Lean
statements behind R2 and R3 are compiled and are checked with the other theorem checks.

## The oil loop, realistically

Until 2026-09-19 the loop was six constants (`heatParams`: `α ε Ac hC Upipe UAx`), a fixed
`mcp = 0.02 kg/s x 2100 J/kgK`, a pipe delay frozen at two steps and a cap written at 593 K that
the 2 m machine simply sat on. The oil had no name, no properties, nothing moved it, and at the
2 m reflector the env ran it to **930 K** while the trainer reported **433 rotis a day** on that
number. A fluid at 930 K is not a fluid.

`RequestProject/HashemiOil.lean` replaces the constants with a loop a builder could buy. Every
definition has its source in its docstring and every one of them is compiled by the same driver
into the same kernels (`hashemi_ccc.h`, `hashemi_ccc.py`, `hashemi_env.metal`,
`hashemi_loop.metal`) and round-trips in `HashemiCccRound.lean`.

### The fluid

**Therminol 66** (Eastman, hydrogenated terphenyl). The property correlations are the published
ones (Eastman technical bulletin; the same fits carried in the NREL/SAM fluid library), `Tc` in
°C: `ρ = 1020.62 - 0.614254 Tc - 0.000321 Tc²` kg/m³, `cp = 1.496005 + 0.003313 Tc +
8.970757e-7 Tc²` kJ/kg K, `k = 0.118294 - 3.3e-5 Tc - 1.5e-7 Tc²` W/m K,
`μ = exp(586.375/(Tc + 62.5) - 2.2809)` mPa s. Its ratings are the two limits the loop is now
written against: **345 °C bulk (618.15 K)** and **375 °C film (648.15 K)**, pour point -25 °C.
They are quoted, not re-derived here.

### The parameters, and where each comes from

| input | value | what it is | source |
|---|---|---|---|
| `alpha` | 0.9 | the coil's absorptance | a blackened copper spiral; assumed, as before |
| `eps` | 0.8 | its emissivity | assumed, as before |
| `Ac` | 0.03 m² | the coil's wetted surface | 8 turns of 10 mm tube on the 12 cm spiral the video shows |
| `Qmax` | 6.0e-5 m³/s | the pump at full command | **this file's choice** - the video shows no pump |
| `Dp` | 0.012 m | the bore of the run | 12 mm copper; **chosen**, the video shows no diameter |
| `Lp` | 6.0 m | the run | down the post, along the carriage, to the pot and back; **estimated** from the geometry the frames do show |
| `Dins`, `kIns` | 0.062 m, 0.045 W/mK | 25 mm of mineral wool | "insulated copper pipes" is his; the thickness is **chosen** |
| `etaP` | 0.25 | the pump's wire-to-water efficiency | a small DC pump; **typical, not a datasheet** |
| `Pidle` | 8.0 W | the pump motor's standing draw | **no source**; a 12 V circulation pump's order of magnitude, and see the budget below |
| `Axch` | 0.20 m² | the exchanger in the pot's wall band | **chosen**: ~3 m of 20 mm tube |
| `UAxMax` | 60 W/K | the wall-side ceiling on `UA` | **chosen** |
| `Ccoil` | 216 J/K | the coil's own inventory | 0.068 kg of oil + 0.19 kg of copper tube, from `Ac` and the bore |
| `degA`, `degEa` | 5.73e8 /s, 190 kJ/mol | the Arrhenius damage law | **an order of magnitude, normalised**, see below |

### What the flow now does (one head, six laws)

The pump is the parent tandoor env's **pinned head 0** - the membrane's level head, which his dish
does not have, so it was inert. `hashemi_tandoor_env.py` reads it BEFORE `neutral` overwrites it
and `HashemiPolicy.pumpOf : Fin 7 → ℝ` maps the seven levels to `0, 1/6, …, 1` of `Qmax`. From
that one number:

* the velocity in the bore, the **Reynolds number**, the friction factor (laminar `64/Re` written
  Hagen-Poiseuille so that it is zero, not `∞·0`, at rest; Blasius above 2300), the pressure drop
  and the **pump's electrical power** `p_pump`;
* the **Nusselt number** (laminar 4.364, constant-flux circular duct, Incropera table 8.1; else
  Dittus-Boelter `0.023 Re^0.8 Pr^0.4`), so `h = Nu k / D`, so the **exchanger's `UA`** and the
  **film temperature** both move with the flow;
* the **transit delay** `L/v` in steps - a real number, read out of the 16-step history by
  `lerp8` between stations - instead of HashemiField's fixed two;
* the **exchanger** as effectiveness-NTU against the pot's wall band (`effNtu`, the Cr → 0 branch:
  over a 15 s step the firebrick's capacity rate is far above the oil's).

Two capacity rates, and the difference is the whole of what a stopped pump means: `mcpF` is the
flow, genuinely zero at rest, so nothing is delivered and nothing crosses the exchanger; `mcpC` is
`mcpF + Ccoil/dt`, what the coil's own balance divides by, which at rest turns `coilProfile` into a
lumped-capacity step instead of a division by nothing. The coil's inlet is the mixing cup of the
two.

The coil's convection is now the **hour's wind** (`hWind V = 5.7 + 3.8 V`, McAdams), not a constant
15 W/m²K, and the pipe's conductance is the **cylindrical-insulation series** (conduction through
the sleeve plus outside convection over it) rather than a flat 0.92 W/K.

### The limits, and the honest findings

`T_film` is the wall the oil touches: the convective superheat `q''/h` over the bulk, **capped at
the radiative ceiling** `εσ(T⁴-Ta⁴) = q''` - because `Tbulk + q''/h` at a high flux and a low film
coefficient runs to fifteen thousand kelvin, which is not a wall temperature, it is the
correlation saying it is out of range. Three things follow, and none of them is comfortable:

1. **The cap binds.** `film_limit_reachable` is proved in Lean: at the 2 m reflector, in full sun,
   with no flow, the net heat into the coil *at the film limit* is still above 4 kW. Measured
   through the Metal bridge by `lake exe trace_check`: stopped, `T_film` 1639 K against a limit of
   648 K; at full flow 986 K.
2. **The 12 cm coil is too small for either dish.** Even at full flow the film sits ~340 K over the
   limit at `a = 2` and ~430 K over at `a = 0.8`. The pump reduces the excess and cuts the damage
   by three to five orders of magnitude, but no flow this loop can command keeps a bare 12 cm coil
   under 375 °C at these concentrations. **The receiver, not the pump, is the next thing to fix.**
   (His own machine is a *demonstration* - he says the coil is temporary.)
3. **The pump does not fit on his panel.** `pumpElec` is milliwatts of hydraulic work plus the
   motor's standing draw. `PumpWithinBudget` is a compiled Prop and it FAILS: 8 W against the 5 W
   panel of `tracking_power_tiny`. Stated, priced in the reward, not hidden.

Degradation is an Arrhenius counter on the film temperature. **The datasheet gives a maximum film
temperature, not a rate constant**: `degEa = 190 kJ/mol` is the order of magnitude of C-C scission
in an aromatic heat transfer fluid and `degA` is normalised so the rate at the film limit is one
unit per thousand hours. That normalisation is a stated convention, not a measurement, and the
column is a relative damage accumulator, not a percentage of cracked fluid.

### The reward pays for it

`rewardStep` (HashemiReward.lean) has five columns now: `r_shape_raw`, `r_pump_raw`, `r_deg_raw`,
`r_raw`, `r_trainer`. The two new ones are costs in the same roti currency, with their rates as
kernel inputs: `pumpPrice = 1` prices an electrical joule exactly as the shaping prices a thermal
one (the most favourable accounting a pump can get), and `degPrice = 5e-7` rotis' reward per
kelvin-second over the film limit - about one roti for a day pinned 50 K over. The capture term
stays non-negative on its own (`rewardStep_nonneg`), which is what `cut_never_pays` needs; the
bills are paid out of `r_raw`. `test_reward_columns.py` measures R1-R4.

### The policy sees it

`obsOf` went from eight observations to eleven: the film margin (scaled by 300 K), the flow it is
running, and the damage so far. A policy cannot modulate a pump whose consequences it cannot see.
The spec's own closed loop `hashemiLoop` gained a third output for the pump (`mlpPolicy` is
11 → 16 → 3 now, `pumpCmd` maps its `tanh` to `[0,1]`).

### Measured: the pump is worth the whole machine

`test_tandoor_env.py --pump off|rule|max`, day 172, Quetta, the follower pointing, 8 agents, the
`hashemi_ccc.ini` tandoor. "rule" is bang-bang: open the pump when the film margin is under 50 K
or the oil is 20 K above the pot's wall.

| dish | pump | rotis/day | max bulk [K] | max film [K] | min margin [K] | damage | pump energy | fault steps |
|---|---|---|---|---|---|---|---|---|
| 0.8 m | off  | **0.0**   | 618.1 (cap) | 1147 | -499  | 5.3e3 | 0 kJ    | 1880/1921 |
| 0.8 m | rule | **52.0**  | 476.6       | 1078 | -430  | 3.4e1 | 248 kJ  | 0/1921 |
| 0.8 m | max  | **51.9**  | 476.5       | 1078 | -430  | 4.0e1 | 249 kJ  | 0/1921 |
| 2.0 m | off  | **0.0**   | 618.1 (cap) | 1792 | -1143 | 9.0e6 | 0 kJ    | 1920/1921 |
| 2.0 m | rule | **211.1** | 618.1 (cap) | 1590 | -942  | 8.3e3 | 242 kJ  | 1546/1921 |
| 2.0 m | max  | **210.6** | 618.1 (cap) | 1599 | -951  | 1.6e4 | 243 kJ  | 1543/1921 |

With the pump shut the oil pins at its cap, delivers **nothing**, and the day is zero at both
sizes: the cap binds, exactly as the Lean says. With it open the 2 m machine makes 211 rotis
against the **433 the old, capless loop claimed** - the honest loop costs half the day, and the
half it costs was the half that ran the oil to 930 K. The rule and full flow score the same here
(the follower's day is flux-limited, not flow-limited) but the rule pays a fifth of the damage at
2 m and leaves the 0.8 m loop at zero fault steps.

### A trained checkpoint under the new loop

`roll_checkpoint.py experiments/178982018014/model_000180.pt --day 172 --agents 16` (the newest
checkpoint of the newest run; its head 0 was INERT when it trained, so what it emits is drift):

```
return +25.82; rotis 0.00
  hr  ...  pump_lvl  T_oil  T_film
   8        2.44      566    1163
  12        2.52      471     845
  15        2.76      583    1142
  THE LOOP: max bulk 618.1 K (limit 618.1), max film 1772 K (limit 648.1),
            min margin -1124 K, damage 1.5e6, pump energy 192 kJ, mean pump level 2.6 of 6
```

It holds the pump at about **2.6 of 6** - a number it never chose - pins the oil at its cap,
carries 1.5e6 of damage and bakes **nothing**. That is the readout that says the policy has to be
retrained against the loop it now lives in. (No training run was launched.)

### Verification

* `hashemi_env_kernel.py`, `hashemi_loop_kernel.py`, `hashemi_reward_kernel.py`: **METAL == NUMPY**
  over the env's 96 columns, the loop's 110 and the reward's 5.
* `test_ccc.py`: 535 functions, 1605 samples, 0 disagreeing; **193** theorem checks true.
* `HashemiCccRound.lean`: **round-trip errors 0**, 336 theorems (285 before) - every new definition
  states and proves its own round trip, and `hashemiEnv`/`hashemiLoop` still prove modularly.
* `lake exe trace_check`: **42 of 42** measured theorems (36 before), the six new ones the oil
  loop's: UA monotone in the flow, the delay antitone, the pump's bill increasing and zero at rest,
  the film never below the bulk, the columns' energy identity, and the cap binding at 2 m.


## The machine at any reflector size, and the design that makes it sound

`Hashemi.lean` is one machine at one size - `dishR = 2`, `dishF = 1`, `dishHalf = 0.8` - and two
hundred declarations that DERIVE the rest from those three: the sag (`HD_eq`), the screw length
(`FH_eq`), the deepest reach F-C (`FC_eq`), the bar through `dish_between_posts`/`sideGap_eq`, the
hanger (`hangerLength_halfEdge`), the pulley (`pulley_above_pivot`), the mast (`mastClears_hashemi`),
the dead point (`deadTan_at_ym`), the arm (`wireLever_rest_at_ym`), the post (`receiverPost_height`),
the spot (`facetSpot_hashemi`). Each of those is a FUNCTION of the givens applied at one point.
`RequestProject/HashemiScale.lean` names the point, runs them forwards - and then runs the
constraints BACKWARDS, which is what makes a resize a design rather than a warning.

* **`structure Givens`** - the reflector's half-side `a`, the proportions his figures fix against
  it (`pR = R/a = 2.5`, `sideGap/a = 0.15`, `apexH/a = 1`, `(upright - FC)/a = 0.18125`,
  `holeDown/a`, `(ym - FC)/a`, `hp/a = 0.425`, the rim hole at `a/2`, the leg's triangle as a
  SIMILAR triangle - similarity is what preserves `brace_cuts_moment` and `brace_stiffens`
  exactly), and **the held set**: the numbers the file fixes with no law attached, each marked
  `-- held: the spec gives no law`.
* **`derive : Givens -> Machine`** - sixty-odd dependent dimensions, each field the file's own
  definition (`TandoorSphere.sag`, `screwLength`, `rollerRadius`, the bound of `edgeDepth_le`,
  `braceHeight`, `hangerLength`, `rodTan`, `facetSpot`, `tiltOfMismatch`, `boltStress`, and now
  `HashemiOil.lean`'s `pumpElec`, `hCoil`, `filmTemp`, `expansionFrac`, `pipeArea`) with the
  constants replaced by the fields. Nothing is invented.
* **`Sound = SoundGeom /\ SoundLoop`** - sixteen build conjuncts and three loop ones.

### The held set

| held | his value | why it is held |
|---|---|---|
| `w` | 0.05 m | a mirror tile (14): a bigger dish is more tiles, not bigger ones |
| `rc` | 0.06 m | the coil, "a bigger spiral tube placed here is temporary" (14, 15) |
| `tanEps` | 0.03 (1.72 deg) | `tracker_margin_hashemi`, the sensor his receiver allowed |
| `azDeg`, `elDeg` | 0.035, 0.025 deg/s | the video gives neither drum nor ratios |
| `W`, `Tmax`, `rDrum`, `rDrive`, `Fdrive`, `L10`, `rho` | 300 N, 2000 N, 0.03, 0.05, 10 N, 1e6, 0.85 | "a one-man lift"; no law from area to mass |
| `dRod`, `dBolt`, `pitch`, `eyeOffset` | M10, M12, 1.5 mm | "M12, the user" |
| `panelW`, `volts` | 5 W, 12 V | "a small 5 watt panel" |
| `Ac`, `Dc`, `Dp`, `Lp`, `Qmax`, `etaP`, `Pidle`, `alphaC`, `Vtank` | 0.03 m2, 10 mm, 12 mm, 6 m, 6e-5 m3/s, 0.25, 8 W, 0.9, 1 L | **the video names no oil, no pump and no pipe diameter**: `LOOP_PARAMS` |

### His machine's verdicts, including the loop

`sound_his : SoundGeom (derive his)` is **proved**, so nothing about his build moves. The loop is
reported, not weakened:

* **`tank_holds_his`** (proved): the loop is 0.75 litre, Therminol 66 grows 30.9 % from the cold
  fill to its bulk limit, so 0.23 litre must be taken and his 1 litre tank takes it.
* **`pump_over_budget_his`** (proved): `pumpElec` at full flow is **8.54 W** against a panel of
  5 W less the winch's 20 mW. His panel does not pay for a circulation pump. `pumpElec`'s own
  honesty note said the standing draw is "of the order of the panel itself"; this is the
  constraint that says so.
* **`film_over_limit_his`** (proved, for any film coefficient under 1958 W/m2K; the Float twin
  measures **1173**): his 0.03 m2 coil under his own 1958 W of sunlight puts the wall the oil
  touches at **668 K**, over Therminol 66's 648 K film limit. His coil is too small for his own
  sun - which is the same fact `film_limit_reachable` proves at the 2 m dish, at his own.
* and therefore **`not_sound_his : ~ Sound (derive his)`** is a theorem.

### Solving the held set: `#design`

Every conjunct is an inequality in ONE held quantity. Solved for it, it is a design rule, and each
solved value comes with a theorem that it satisfies its conjunct by construction:

| solved | the rule | the theorem |
|---|---|---|
| `rcMin` | `rc >= spotW/2 + f tanEps` | `tracker_holds_of_rc` |
| `epsMax` | `tanEps <= margin / f` (the sensor the coil allows) | `tracker_holds_of_eps` |
| `wMax` | `w <= 2(rc - f tanEps) - 0.0093 f` (the facet it allows) | `tracker_holds_of_w` |
| `panelMin` | `panelW >= pumpElec + trackW` | `pump_holds_of_panel` |
| `AcMin`, `coilLenMin` | `Ac >= alpha Pin / (h (Tfilm_max - Tbulk_max))` | `film_holds_of_Ac` |
| `tankMin` | `Vtank >= Vloop * expansion` | `tank_holds_of_tank` |

`design : Givens -> Givens` is the pointwise maximum of the held value and its floor - the MINIMAL
change - and `design_tracker`, `design_pump`, `design_film`, `design_tank` are proved of it.
`film_fails_of_Ac_lt` is its converse, the finding at a coil that is too small.

```
$ lake exe machine_scale 2.0 --design
#design 2.000000
  held -> designed:
  rc         0.060000 -> 0.111625   (TrackerBudget)
  panelW     5.000000 -> 8.588642   (PumpWithinBudget)
  Ac         0.030000 -> 0.313176   (FilmLimit)
  the same budget, the other way: the sensor the coil allows is tanEps <= 0.009350
  (0.5357 deg, his is 1.7184); the facet it allows is w <= -0.053250 (his is 0.05)
  the coil the film limit demands is 0.313176 m2 = 9.97 m of 0.010 m tube
  ... the designed machine: constraints (19 of 20 hold)   [only ReachesVertical, as ever]
```

The facet's floor is **negative** at `a = 2`: `f tanEps = 0.075` already exceeds the 12 cm coil's
radius, so no facet, however fine, puts the beam inside it. That is the lever going dead, and the
table says so rather than offering it.

`#machine 2.0` reports the held machine; `#design 2.0` the designed one; and
`#machine 2.0 with rc := 0.112, panelW := 13` is a what-if on any of the held names beside them.

| | a = 0.8 (his) | a = 2.0 |
|---|---|---|
| R, f | 2.000, 1.000 | 5.000, 2.500 |
| sag, FH (rim below F) | 0.1670, 0.8330 | 0.4174, 2.0826 |
| side, bar, rail | 1.600, 1.840, 1.219 | 4.000, 4.600, 3.048 |
| F-C, upright, post to F | 1.1550, 1.3000, 1.2500 | 2.8874, 3.2499, 3.1249 |
| mast station, pulley, stand | 1.2200, 0.3400, 1.5900 | 3.0499, 0.8500, 3.9749 |
| hanger, rod lean | 0.8845, 27.0 deg | 2.2112, 27.0 deg |
| dead point, arm at rest, wire taken in | 61.73 deg, 1.034, 1.134 | 61.73 deg, 2.585, 2.836 |
| slot exit | 43.84 deg | 43.84 deg |
| spot at F, coil margin, budget (HELD) | 0.0593, 0.0303, 1.74 deg | 0.0733, 0.0234, **0.54 deg** |
| **designed** coil, panel, coil area | 0.060, 8.56 W, 0.0501 m2 | **0.1116**, 8.59 W, **0.3132 m2** |

Every angle is invariant and every length scales by `a/0.8`, because the derivation is a
similarity on everything the file gives a proportion for. **What breaks is what the file holds
fixed**, and `design` is what the file's own inequalities say to do about it.

* **`ReachesVertical` fails at both sizes**, unchanged: `wire_short_of_vertical`.
* The load constraints hold at `a = 2` only because of the file's silence: with the dish's weight
  HELD at 300 N, `HoldsDish` keeps its factor of 7.7, `m12_carries_dish` falls from 3.6 to 1.44
  and `tracking_power_tiny` from 3.7 to 1.52. Scale the mass as the area (6.25x) and the bolt
  goes over at once. The honest reading is that they are untested, not satisfied - `design` does
  not touch them, because no constraint of the file names the mass.
* `one_turn_tilt` is invariant (`f/side` does not move): 0.94 mm at F at any size, 93 % of the
  1 mm allowance.

### In the env

`hashemi_tandoor_env.py`'s `dish_half` READS `hashemi_machine_<a>.json` (or
`hashemi_machine_<a>_designed.json`), feeds `kernel` (`R f a w rc`), `mount`
(`rDrum W rcm Tmax rho Fdrive L10 rodLen`) and now `loop` (`Ac Qmax Dp Lp etaP Pidle alpha`) to
`env_params`/`beam_params`, and prints either the constraints the spec does not call `holds` or,
when designed, what had to change.

**`dish_design` (the ini's knob) defaults to 1: a resize should be sound by default.** Set it to
0 for the held machine and the warning, as before. Measured on day 172, lat 30.2, eight agents,
the sensor loop with discrete heads, the bang-bang pump:

| | rotis/day | capture | p_in (9 h) | max film | min margin | damage | P_pump | verdict |
|---|---|---|---|---|---|---|---|---|
| a = 0.8 held | 52.0 | 0.996 | 1451 W | 1078 K | -430 K | 3.4e+1 | 8.6 W | COOKS |
| a = 0.8 designed | 48.0 | 0.996 | 1406 W | 949 K | -301 K | **1.7e+0** | 8.6 W | COOKS |
| a = 2.0 held | 211.1 | 0.87 | 5711 W | 1590 K | -942 K | 8.3e+3 | 8.4 W | **DOES NOT COOK** |
| a = 2.0 designed | 200.6 | **1.000** | 5740 W | 895 K | **-247 K** | **7.8e-2** | 8.4 W | **COOKS** |

The designed coil is 10 times the held one's area, so it captures everything the bigger dish
sends it (0.87 -> 1.000: `rc` at 0.112 m finally covers the 7.3 cm spot plus the sensor's error)
and it radiates and convects away more of what it absorbs - which is why the rotis fall 5 % while
the damage the fluid takes falls by **five orders of magnitude** and the machine goes from failing
the day's test to passing it. The pump's power is unchanged (nothing in `design` moves `Qmax`);
what moved is the panel that pays for it. Metal == NumPy on the same day (`--gpu 1`: 202 rotis
against 200.6, the ray draws differing), 539 compiled functions agree, the round trip has 0 errors
and 337 theorems, and every generated kernel is byte-identical for the held 0.8 machine.

The one number the derivation carries as a proportion rather than a formula is `rcm` (the centre
of mass below the bolt line): `megaParams` gives 0.9 m with the file's own reason - "the panel
hangs between its vertex 1 m down and its rim 0.83 m down" - and both of those scale with `a`, so
`rcm = 1.125 a` reproduces his 0.9 exactly (`derive_his_rcm`) and stays between `ze` and `f`
(`derive_his_rcm_between`) at every size.

**Not scaled in the kernel**: the wire's geometry (`ym`, `hp`, `ze`, `a`) is compiled into
`megaStep` at his literals, so the kernel's elevation lever arm and dead point stay his; the JSON
carries the derived ones for the host and for the build. Scaling those means recompiling the
mount with `a` as an input.

## The scene as a printer

There is no such thing as a Hashemi scene.  There is a scene.

A drawing of a machine is not another model of it: it is a *functor to drawings* applied to the
definitions that are already there.  `Hashemi.lean` names about seventy point-valued definitions —
`rot`, `postTop`, `swungPt`, `pulleyAt`, `edgeClipAt`, `swingFocus`, `dishAxes`, `traceConic`,
`hyperHit`, `dishReflect` — each written in whatever frame its section works in.  Objects of that
category go to vertices; the frame morphisms that relate one section's coordinates to another's go
to the composition that places those vertices in the roof frame.  A "scene definition" with
coordinates written into it would be the geometry written a second time, and a second copy is a
copy that can disagree.

So the renderer is a **printer of the compiler**, not a hand-written scene:

| file | what it is |
| --- | --- |
| `RequestProject/Scene.lean` | the vocabulary, machine-independent: `Leaf` (a definition, its frame, a renaming of its binders), `Shape` (`one`, `seg`, `rayOf`, `axesOf`), `Entry`, `Scene`; and `vertex_bound` — every vertex of every scene is bounded by its inputs' bound, whatever the frames are |
| `RequestProject/CccScene.lean` | the printer.  It binds each distinct binder name once, applies each definition to those inputs, applies the frame to that **in the graph** (composition in the CCC: the frame's nodes are emitted over the leaf's outputs and hash-consed with everything else), and hands the single resulting `Ccc.Fun` to `Ccc.lean`'s own printers — `printSceneC`, `printNumpyScene` and `printMslScene`, the last a threadgroup per frame and a thread per ray.  It contains no machine's vocabulary at all |
| `RequestProject/HashemiSceneInst.lean` | the instance: three frames (`roofOfCarriage`, `roofOfBolt`, `roofOfDish`, each a composition of `rot`, `swungPt` and `dishAxes`, each tied by a theorem to `megaGeom`), a handful of projections that name three columns of a nine-column trace, `sunAt`, the ray leaves over the megakernel's table, and then FOUR lists of **data** — the machine, the beam-down, one chain of the optic GADT, and the same machine composed with the env morphism |
| `RequestProject/SceneCcc.lean` | the driver: `lake build RequestProject.SceneCcc` writes `render/scene_{hashemi,beam,optic,env}.{h,metal,py,json}`, `scene_registry.h` and `scene_sun.{h,py}` |
| `render/scene_kernel.py` | the FFI.  `SceneMetal` compiles `render/scene_<name>.metal` and dispatches it exactly as `HashemiEnvMetal` does the env's step — one threadgroup per frame, one thread per ray — and returns the two vertex buffers; `scene_numpy` and `scene_c` are the other two printings of the same graph |
| `render/view.py`, `render/scene_draw.py` | the viewer, on **pyray**.  An orbit camera; the pose from the printed `hk_megaStep` driven by the proved `hk_follower` or by the keyboard through `hk_headToDriveAz/El`; the sun from the printed `sunAt`; the vertices from the kernel; the HUD's capture, p_in and oil temperature from the env megakernel's own columns over the SAME draws |
| `render/main.c` | what is left of the C side: the C twin's harness (`--eval`, `--sun`), so `check.py` can compare the third printing.  No window, no raylib — it is not installed on this machine — and no geometry; there never was any |

**The rays come from the megakernel through the FFI; the viewer is pyray.**  A ray leaf is a
definition of one extra binder, an index over the ray TABLE `dr : Fin 64 → Fin 10 → ℝ` — six
uniforms and four normals per row, the layout `hashemiEnv` and `hashemiEnvBeam` already trace —
sampled through the spec's own `sampleRay`, and `CccScene` compiles it against the ray index
itself, the very `.rayIn` nodes a `∑ i : Fin P` makes.  A scene therefore has two regions, read
off the graph's layers and declared nowhere: the static vertices, one per frame, and the ray
vertices, one per row.  There is no `rays.csv`; the draws are generated on the device.

And the scene is composed with the env morphism, not recomputed beside it: `envScene`'s leaves
take `hashemiEnv`'s own binders and read the pose out of `megaStep`, so `scene_env.metal` is one
kernel whose vertices and whose env columns come out of one graph over one table of rays.  That
is what `puffer eval puffer_hashemi_ccc --render-mode human` draws — the step the policy acted
on, not a second walk of the mount in Python.

    cd render
    make check     # C == NumPy == Metal for the four scenes; the sun; one frame from view.py
    make           # the window (view.py on pyray)
    python view.py --scene hashemi --frames 1 --out .      # headless, no display needed
    python dump_day.py && python view.py --replay day.csv

`make check` compares the three printings of each scene at random inputs and the megakernel's
own draws (C and NumPy are double and agree to the last bit; the kernel is float32 and is held
to 2e-3 relative), `sunAt` against the trainer's own `solar_position` at twenty random instants
(3e-16 rad), and — the one that matters — **the env scene's ray vertices against the standalone
scene's at the pose `megaStep` stepped to: 0.0e+00**.  The committed frames are
`render/frame_hashemi_000.png` (the viewer) and `render/frame_env_000.png` (the env's own step).

  hashemi  16 entries,  51 static + 64 x 10 ray doubles, 28 inputs, 1 table,  1248 nodes
  beam     11 entries,   3 static + 64 x 19 ray doubles, 20 inputs, 1 table,  1247 nodes
  optic     9 entries,   0 static + 64 x 27 ray doubles, 20 inputs, 1 table,  1247 nodes
  env      19 entries,  50 static + 64 x 10 ray doubles, 56 inputs, 3 tables, 2367 nodes


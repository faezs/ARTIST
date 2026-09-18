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
   predicates (the seven structure instances have no `ℝ` printing);
   the 24-fold bisection (`swingOfLength`, `step`, `megaStep`) is beyond `rfl`'s budget - a term
   that doubles at every level - so its one step `bisectStep` round-trips, the iterate rule is
   checked on a 3-fold instance, and the twins cover the three.
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

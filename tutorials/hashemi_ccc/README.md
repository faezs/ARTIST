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
replay them with edited inputs. `lean/TraceCheck.lean` then measures, on the GPU, from Lean:

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

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
| `hashemi_ccc.h` | 315 device functions: 90 definitions, 116 predicates (the file's 7 Props and the 109 theorem statements), 109 theorem checks |
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

1. **Theorem round trip, in Lean.** `prop_X_ok : ∀ data, prop_X data := X` for all 109 compiled
   theorems: the printed statement is the theorem's, up to unfolding (`simpa` with the file's
   definitions, `funext_iff`, `Prod.ext_iff`, `Fin.forall_fin_succ`, `Matrix.cons_val`).
2. **Definition round trip, in Lean.** `f_ccc : f = fun … => printed := rfl` for 196 definitions and
   predicates (the seven structure instances have no `ℝ` printing);
   the 24-fold bisection (`swingOfLength`, `step`, `megaStep`) is beyond `rfl`'s budget - a term
   that doubles at every level - so its one step `bisectStep` round-trips, the iterate rule is
   checked on a 3-fold instance, and the twins cover the three.
3. **C against Float.** 945 samples over 315 functions agree to 1e-12; the 109 theorem checks are
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

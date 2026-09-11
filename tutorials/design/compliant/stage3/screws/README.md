# The mount as screws, inside the megakernel

A mirror is where its foci are. A mount is a list of screws and a 6 x 6. This folder is the PR that lets the kernel
trace any optic on any mount the register has drawn, with the frame type named in the ini.

## What was already there, in three dialects

| dialect | where | what it says |
|---|---|---|
| optics | `tandoor_metal_kernel.py`, `tandoor_mount_batch.py` | every mirror a conic named by its foci and axis; the dish as sampled points in a body frame with a rotation and a vertex per agent; M2 a point and an axis in the view rows; M3 in design-table columns; M4 one shared quadric |
| mechanisms | `tandoor_screw_render.py`, `tandoor_flower_env.py` | a mechanism is a list of screws; `realise` turns screws into blades, pins and torsion bars, `evaluate` into a 6 x 6 at the screw's point; `pedicel_fk/ik` a closed-form chain; `hexapod_jacobian`; `compliance` the beams |
| sensitivity | `tandoor_flower_env.miss_gains` | the image walk at F per metre and per radian of head motion, by finite differences on the reflection law |

FACT (Hopkins) is the instantaneous half of screw theory: freedom, constraint and actuation spaces, the twist-wrench
stiffness at one pose. What it never needed and the kernel does is the finite-motion half: the exponential of a twist
(Chasles: every rigid motion is a screw motion), the adjoint that moves twists, wrenches and 6 x 6s between points, and
the product of exponentials over a chain. That is `tandoor_screws.py`.

## `tandoor_screws.py`

Conventions: twist (v; omega), wrench (f; m), world orientation unless said local, the plain dot product the reciprocal
product. Functions: `hat`, `rodrigues`, `exp_screw` (revolute or slide by the pitch), `ad_twist`, `ad_wrench`
(= `ad_twist(T^-1)^T`, checked), `transport_compliance` (A C A^T), `poe` (product of exponentials, screw 0 the base),
`apply_twist`, `beam_compliance` (Euler-Bernoulli 6 x 6 at a cantilever's tip), `series_at` and `parallel_at`
(compliances add, stiffnesses add, at one point), `stiffness_from_members` (the realiser's blades as a 6 x 6),
`invert_compliance` (a freedom held by its actuator).

The catalogue, each as screws at home plus a compliance builder:

| type | screws | compliance |
|---|---|---|
| `hashemi` | azimuth and elevation about F, beta about F, minus beta/2 about the vertex (the kernel's bisector law) | rails: rigid |
| `pedicel` | slew, luff, extend, pitch, yaw from the stem top (`pedicel_fk`'s five) | stem and boom in series, the beam 6 x 6 with torsion and axial |
| `crown` | tip about +yl, tilt about -xl, piston along the axis, at the vertex | the diaphragm's 77 MN m/rad, 60 MN/m (fact_mount memo) |
| `fork` | the ring about the vertical through F, the trunnions about the horizontal through F | two blade blocks at F +- 3.25 m realised by `tandoor_screw_render`, in parallel at F, the elevation held by the jacks |
| `coude` | the stalk's azimuth, the neck pivot | library only: the kernel does not trace the coude's optics |

## The kernel

`mount_solve` takes buffer 12, one row of MECHW = 136 floats per agent (`mech_rows`): the screw count, flags, what the
strip follows, up to eight screws (w, q, pitch, theta), the home vertex and axis, an elastic twist, a 6 x 6 and its
wrench. With a chain the kernel walks the screws innermost first, applies the twist and C W at the vertex as one small
screw motion, and derives what Hashemi's law derived from the pointing: the beam direction is the line to F, the
pointing the mirror's reflection of it, beta the angle between (atan2). Every line after is unchanged. A row of zeros
is the old path, so the cook env is untouched. `tandoor_mount_batch` carries the torch twin for CUDA and CPU; the CUDA
transpile of the new source is clean.

M4 is per agent too: `ellM/ellS/ellC/V0` are (B, ...) rows the trace indexes by agent, a shared M4 expanded once and
cached, and `TandoorHashemiEnv.set_m4_frame(T)` moves the built ellipsoid's foci, centre, vertex and axes by a rigid
motion per agent, shape unchanged.

The strip's frame follows the link it is mounted on (row [2]): Hashemi's tube and the fork's follow the mount's
pointing; the flower's strip sits on the pipe and turns to face the head, so it follows the line from F to the head
and never sees the crown's tilts, which the pointing would double.

## In the envs

- `tandoor_hashemi_env._mount(..., mech=)`: None takes the env's standing rows (`_mech_rows`), False forces the law.
  The fused step hands the rows to the kernel.
- `tandoor_flower_env`: `mount = hashemi | pedicel | fork` (flower.ini). `pedicel` sends the achieved joints as the
  chain and the residual walk as a twist about the boom's tip, so the kernel traces the head where the pedicel put it,
  where the old path injected an equivalent el/az error into the motors. `fork` sends Hashemi's chain with the gust
  through the blocks' 6 x 6 at F. Stowed agents park through the old path. A checkout whose kernel lacks the chain
  falls back to `hashemi` and says so.
- `tandoor_flower_fast`: `mech_kernel = 1` (flowerfast.ini) sends the joints as the chain and the structure's
  deflection with the crown's tilts as one exact twist; the receiver rows follow the head instead of staying as at
  reset. One extra launch a step: 15.4 -> 16.5 ms at 256 agents on the numpy path.

## Tests, all passing

- `test_screws.py`: adjoints and power invariance; exp_screw; the pedicel chain against `pedicel_fk` (4e-15); the
  hashemi chain against the kernel's arithmetic and back through `pointing_from_frame`; the beam 6 x 6 against
  `compliance()` for the boom (the scalar omits the stem's axial strain under a vertical load, 12 % of a half-metre
  boom's bending; and its stem term is a planar idealisation - under a crosswind the stem carries the boom's root
  moment in torsion); the crown's signs; `apply_rows` against `poe`; the fork's 6 x 6.
- `test_kernel_parity.py`: Hashemi's machine as a chain reproduces `mount_solve`'s own law to 2e-7 (Mt), 5e-7 (Cd),
  1e-6 (vp); the pedicel chain reproduces `pedicel_fk` to 2e-6 m and the trace to 2e-7; the elastic twist and C W
  match `apply_rows`; the torch twin matches the kernel to 2e-6. Note: the Metal mount returns views of cached
  buffers, so results are snapshotted - the first version of this test compared a buffer with itself.
- `test_env_mount.py`: the slow env with `mount = pedicel` against `hashemi`, wind off and the walk's floor off:
  obs to 9e-5, reward to 1e-6 (float32, and the 5e-7 rad the pedicel leaves carried two ways); the fork runs finite;
  the fast env with `mech_kernel` against without: miss to 3e-6 m, rays through to one ray of 64, obs mean 4e-7.

The harness lesson, again: pufferlib's `package = tandoor` is a symlink into the shared checkout, so `load_env` builds
the shared checkout's classes whatever `sys.path` says. The tests pin `pufferlib.environments.tandoor` to this tree's
package and the kernel modules to this tree's files, and assert every module's provenance.

## What the kernel mount found in the fast env

`test_env_mount` disagreed on rays through by 69 % at first. The cause was not the chain. The fast env's own trace
path froze `Acan` - the sun's direction in the dish's frame, which the kernel uses to turn its canonical sun ray into
the incident direction before reflecting - at reset, while the dish frame `Mt` moved every step. So the sun rode with
the head: a tilt of the crown turned the traced beam by theta, not 2 theta, and the trace's rays through were half as
sensitive to the fine stage as the miss the reward is paid on. The kernel mount re-solves `Acan` every step and was
right; the host path now does the same (`trace()`).

What it changes, the baselines re-run (256 agents, 3 s, seed 11, site wind):

| controller | miss cm | rays through, before | after |
|---|---|---|---|
| no-op | 2.67 | 67.5 % | 67.5 % |
| random | 7.98 | 40.5 % | 16.8 % |
| integral on the F camera | 0.34 | 87.2 % | 89.8 % |
| integral on the true miss | 0.03 | 86.8 % | 89.8 % |
| run 2 ep 144, piston held | 0.08 | 87.1 % | 89.8 % |

The no-op does not move, so it is unchanged; random tilting was 2.4x too kind; the controllers that null the miss with
about 2 mrad of tilt were 2.6 points too harsh, because the trace's beam lagged the tilt by half. The conclusions of
`flower_fast/README.md` stand (the miss converges, the piston wanders, run 3 collapsed), and the throughput ceiling is
89.8 %, not 87.

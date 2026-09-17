# The mount as screws, inside the megakernel

A mirror is where its foci are. A mount is a list of screws and a 6 x 6. This folder is the PR that lets the kernel
trace any optic on any mount the register has drawn, with the frame type named in the ini.

## What was already there, in three dialects

| dialect | where | what it says |
|---|---|---|
| optics | `tandoor_metal_kernel.py`, `tandoor_mount_batch.py` | every mirror a conic named by its foci and axis; the dish as sampled points in a body frame with a rotation and a vertex per agent; M2 a point and an axis in the view rows; M3 and the cass M4 in design-table columns per agent; the fold chain's relay one shared quadric |
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

The optics beyond the head, per agent: the cass/tri chain's M2 (the strip), M3 and M4 already live in the design table
(columns 0..38, per agent, the aim head turning M3 in 21..26), so a mount for them is a rewrite of those columns - the
next step, not this one. The fold chain's relay ellipsoid (`ellM/ellS/ellC/V0`, "M5 far root" in the kernel) was the
one shared quadric left: it is now (B, ...) rows the trace indexes by agent, a shared relay expanded once and cached,
and `TandoorHashemiEnv.set_relay_frame(T)` moves the built ellipsoid's foci, centre, vertex and axes by a rigid motion
per agent, shape unchanged (test E: identity is bit-identical, a 20 mrad tilt moves the power between the pot's nodes).

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

## The wind as a field: the rod (2026-09-12)

The stem and boom are a curve g(s) in SE(3); its derivative g⁻¹ dg/ds is a twist per unit length, the strain. The wind
is a velocity field; along the curve it is a wrench density w(s), and the balance is dF/ds + ad*_ξ F + w = 0. That is
now the library and the fast env:

- `rod_twist(elements, loads, P_ref)`: N cantilever elements, each with its own 6 x 6 and its own uniform density; the
  internal wrench at an element's tip is every load outboard of it carried there by the adjoint, the element's own
  density bends it by the closed form (q L^4/8EI, q L^3/6EI), and the elements' twists are carried to the point asked
  for. A point load at the end with one element per member is `series_at`; the density is what the lumped wrench
  never had. Vectorised over elements and loads, a dozen tensor ops. Plus `tube_density` (the crossflow principle:
  only the velocity normal to a tube loads it), `wind_profile` (the log law from ERA5's 10 m reference, z0 0.3 m),
  `rod_elements` (the pedicel as stem + boom), `pedicel_scalars` (the slow env's compliance() interface from the 6 x 6).
- Tests (`test_screws.py` 9): a tip point load through 8 elements equals the 6 x 6 to 1e-16; a uniform density gives
  q L^4/8EI and q L^3/6EI exactly with 1, 3 or 8 elements; the foot's load cell; the record that the 3/8 tip lump the
  fast env used for the boom's shedding is right for the deflection and 9/8 for the rotation, and the image answers
  rotation five to one.
- The fast env (section 4): the log profile at the head and at each element, the same gust at every height; the
  tubes' crossflow drag as a density on the stem and the boom, the shedding lift as a density along the boom; at the
  vertex the LES force at the head's own height and the MEAN pitching moment, signed, from the table's new `Cm_s`
  about n x w_hat, with its gust about the same axis. Two rod solutions a step, the force-type loads and the
  moment-type, each rung on its own mode per bending plane, the modes from the chain's 6 x 6 at the vertex (the
  head's transverse and rotational stiffness, with the vertex's lever and the stem in torsion): 3.0 Hz and 10.5 Hz
  where the planar scalars said 4 and 14. The geometry and the 6 x 6 are refreshed every 8 steps, the loads every
  step; 15 -> 23 ms a step at 256 agents on the numpy path.
- The slow env (step 4): `compliance()`'s planar pair replaced by `pedicel_scalars`, the 6 x 6 with a unit crosswind at
  the vertex: 14 um of image per newton on the reset poses where the scalar said 6.3, the difference being the
  vertex's lever on the tip's rotation and the stem's torsion path.

What it does to the numbers. At the site's own winds nothing visible: no-op 2.67 cm / 67.5 %, the integral controllers
0.34 and 0.03 cm at 89.8 %, run 2's best checkpoint 0.08 cm at 89.8 %, as before the rod. At 9 m/s from the west on
the no-op (theta 149 deg, the boom at 5.8 m) the head's twist is 8.7 mm and 2.3 mrad, the foot carries 2.8 kN m, and
the miss is 2.97 cm against 2.67 in calm air - the signed walk, the rotation and the translation partly cancelling as
the boom study found.

The film. The LES table now carries, per attitude, the n = 1 harmonic's deflection plane (`tilt1`, 0.8-2.3 mrad at
12 m/s into the bowl, signed along the wind's projection, the across component ~0 by symmetry), the figure residual
(`k_fig`) and the signed mean moment (`Cm_s`). The tilt is NOT applied as a pointing bias, and the reason is a
theorem: a film fixed at its rim has zero aperture-mean slope for any harmonic (Gauss - the integral of the gradient
over the disc is the boundary integral of w, which vanishes), so the n = 1 harmonic moves no centroid and is figure,
which `k_film` already carries as slope rms. The step this does not take is the deterministic slope FIELD per ray in
the trace (the n = 1..3 profiles per attitude with the wind's azimuth in the dish frame, as a new per-agent buffer
the kernel would sample at each ray's (r, phi)); the isotropic rms has the right second moment and the wrong shape at
the collar, and that is the next thing to build. Also still absent: wind on the strip and on M3, the dish's wake over
the boom, motion-induced aerodynamic damping, the building's flow field.

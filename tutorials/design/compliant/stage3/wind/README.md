# The dish in the wind: LES, and what the membrane's theory was missing

`mem_theory.py` sizes the membrane model's gaps (modes with the air's added mass, gust admittance and resonance, the
aeroelastic limit, thermal and creep tension drift, the pressure map's harmonics). `dish_setup.cpp` is the FluidX3D case
(append to `src/setup.cpp` of a headless build: BENCHMARK off, VOLUME_FORCE + FORCE_FIELD + EQUILIBRIUM_BOUNDARIES + SUBGRID
on, the macOS X11 link flags emptied; note `make.sh` RUNS the binary after building, use `make macOS` to rebuild).
The tool is checked out untracked at `resources/FluidX3D` in the worktree (M1 Max: ~1 GLUPS at 16 M cells).

The case: a paraboloid shell (a 2.1 m, f 4.0 m) with its axis at the sun (retro), wall-modelled Smagorinsky LES on a
uniform 12 m/s inflow in a 24 x 12 x 12 m box, dx 0.06 m (16 M cells, dt 0.5 ms), 3 s settle then 10 s sampled: force
and torque about the vertex every 10 ms, the pressure on both faces of the film on a 24 x 48 polar grid every 0.25 s.
`cp_harmonics.py` turns front minus back into azimuthal harmonics per ring and solves the prestressed-membrane response
per harmonic for the film's slope error; `dish_table.py` tabulates the runs; `dish_matrix.sh` runs the year's retro
attitudes; `slice_plot.py` draws the mid-plane.

## Equinox-noon retro (el 59, wind from the south into the bowl), 12 m/s

| | coarse dx 0.15 | dx 0.06 | the envs assume |
|---|---|---|---|
| Cd on the disc, along the wind | 0.67 | 0.78 | 0.56 (0.25 + 1.15 cos^2) |
| Cl (vertical) | -0.82 | -1.38 | - |
| force along the dish axis, C_n | - | -1.59 | - |
| steady Cm about the vertex | (wrong centre) | 0.145 | 0.15 rms, no mean |
| Cm fluctuation rms, steady inflow | - | 0.006 | 0.15 (ABL turbulence, not in this LES) |
| net film load, mean Cp | 1.07 | 1.67 | 1.40 (q Cd uniform) |
| film load harmonics n = 0 / 1 / 2 / 3 (Cp) | 1.08 / 0.27 / 0.04 / 0.03 | 1.68 / 0.58 / 0.22 / 0.13 | n = 0, n = 1 only |
| film slope error from n >= 1, mrad rms | 2.1 | 5.6 | 3.8 (n = 1 only, 2.63e-5 V^2) |

Not converged between 0.15 and 0.06 m (n = 2 grew 5x); a 0.04 m run is queued. The flow at this attitude is a cambered
plate at 31 deg: windward concave face pressurised with a thin stagnant pocket, leeward convex back with attached fast flow
and suction, one shear layer off the trailing rim. With steady inflow the loads are nearly steady (Cd rms 0.5 %); the
fluctuating part in service is the boundary layer's turbulence, to be added as synthetic inflow.

## Corrections and what went into the envs (same day)

- The film's WORKING tension is 4922 N/m area-mean (rim 4526, centre 5334) from the 1-D FvK solve at f 4, not the 2000 N/m
  pretension and not the 3000 first used here. At that tension the LES harmonics give **3.42 mrad** of figure error at
  12 m/s (n = 1 / 2 / 3: 3.2 / 1.0 / 0.5) against the env constant's 3.79: the same to 10 % at this attitude, differently
  composed. The constant stays until the year's matrix gives the attitude dependence the env now lacks entirely.
- 4922 N/m in 50 um PET is **98 MPa, at the film's yield** (~90). The pretension figure of 40 MPa quoted in the membrane
  memo is the unpressurised state. Either the film is 100 um (49 MPa) or the tension budget is wrong. Flagged, not changed:
  t_mem is the optics fork's.
- The thermal tension drift claimed earlier (30 K, 3 %, 0.13 m of focal length) assumed no convection. With McAdams
  convection on both faces the film runs 1-5 K above the air: 0.06-0.3 % of tension, 0.2-1.2 cm of f. Negligible. Creep
  (~1 %/decade of hours at this stress) remains, slow.
- Aeroelastic softening at the real tension: 4 / 6 / 10 % at 9 / 12 / 15 m/s, divergence near 48 m/s (was 37 at 3 kN/m).
- INTO THE ENVS: `film_soften(V) = 1/(1 - q D/T)` multiplies the film's figure term in both envs (`sig_mem`, `sig_film`);
  the fast env's head loads (drag, side, pitching moment) now see the gust through Vickery's admittance, a first-order lag
  at U/(2 sqrt A) = 1.6 Hz at 12 m/s (state `ua`, `va`), which cuts the force spectrum at the boom's 2-7 Hz mode 4-5x; the
  film keeps the point gust. Measured: the filtered gust's total rms is 7 % below the point gust's, the change is spectral.

## The year's retro attitudes (12 m/s, dx 0.06, steady inflow; theta_w = the wind's incidence on the bowl, 0 = straight in)

| pose | el | az | theta_w | Cd (env) | Cl | Cn | Cm | net Cp | n1 / n2 / n3 | film mrad (env const 3.79) |
|---|---|---|---|---|---|---|---|---|---|---|
| midwinter noon | 36 | 8 | 37 | 1.24 (0.99) | -0.92 | -1.55 | 0.078 | 1.66 | 0.37 / 0.04 / 0.03 | 1.83 |
| equinox noon | 59 | 0 | 59 | 0.78 (0.56) | -1.38 | -1.59 | 0.145 | 1.67 | 0.58 / 0.22 / 0.13 | 3.41 |
| equinox 09:30 | 43 | 56 | 66 | 0.46 (0.44) | -0.72 | -1.07 | 0.088 | 1.07 | 0.30 / 0.03 / 0.03 | 1.54 |
| equinox 08:00 | 25 | 73 | 75 | 0.22 (0.33) | -0.27 | -0.68 | 0.066 | 0.65 | 0.25 / 0.04 / 0.03 | 1.23 |
| midsummer noon | 80 | 46 | 83 | 0.11 (0.27) | -0.33 | -0.34 | 0.015 | 0.37 | 0.07 / 0.04 / 0.03 | 0.32 |
| midsummer 08:00 | 37 | 98 | 96 | 0.10 (0.26) | +0.08 | +0.14 | 0.039 | -0.14 | 0.17 / 0.09 / 0.03 | 0.96 |

Read across: the load on a bowl facing the wind is a NORMAL force along its axis, Cn -1.55 to -1.59 on the disc area from
37 to 59 deg of incidence, falling to -0.34 by 83 and changing sign past 90; the tangential part stays under 0.1. The
vertical force is downward at every bowl-facing pose, up to 1.4 q A, where the env's heuristic gave +0.4 upward. The env's
drag interpolation is 20-25 % low at low incidence and 2x high at grazing. The film's figure error runs from 3.4 mrad at
equinox noon down to 0.3 at midsummer noon: the constant the env carried (3.79 at 12 m/s) was the worst pose. All of this
is in `tandoor_wind_table.json` beside the envs, piecewise-linear in theta_w, flat beyond 96 deg, and both envs now take
the head's force and the film's figure constant from it wherever theta_w <= 100. Mean and rms of the steady-inflow Cm are
at most 0.145 and 0.015: the 0.15 rms the envs assume for the fluctuating moment is the boundary layer's turbulence, which
these runs do not carry, and which the quasi-steady incidence model should now provide from the table's slopes
(dCn/dtheta, dCm/dtheta) and the gust's lateral and vertical components.

## The real wind: west and northwest across a bowl that faces the sun (4 cm, 6 s sampled, 12 m/s)

theta_w is the wind's incidence on the dish axis: under 90 the wind is on the bowl's face, over 90 on its back.

| pose | wind | el | az | theta_w | Cd (env) | Cn | Cm | net Cp | film mrad |
|---|---|---|---|---|---|---|---|---|---|
| equinox 15:30 | W | 43 | 34 | 53 | 1.15 (0.67) | -2.02 | 0.204 | 2.08 | 6.3 |
| equinox 15:30 | NW | 43 | 79 | 82 | 0.10 (0.27) | -0.38 | 0.016 | 0.40 | 0.4 |
| midsummer noon | W | 80 | 44 | 83 | 0.10 (0.27) | -0.38 | 0.014 | 0.42 | 0.3 |
| equinox noon | W | 59 | 76 | 83 | 0.10 (0.27) | -0.36 | 0.008 | 0.38 | 0.3 |
| midwinter noon | W | 36 | 82 | 84 | 0.09 (0.27) | -0.33 | 0.002 | 0.36 | 0.3 |
| midsummer noon | NW | 80 | 89 | 90 | 0.06 (0.25) | -0.05 | 0.037 | 0.08 | 0.6 |
| equinox noon | NW | 59 | 121 | 105 | 0.17 (0.31) | +0.35 | 0.064 | -0.34 | 1.4 |
| midwinter noon | NW | 36 | 127 | 119 | 0.44 (0.44) | +0.76 | 0.094 | -0.81 | 2.1 |
| equinox 09:30 | W | 43 | 146 | 127 | 0.66 (0.54) | +0.99 | 0.107 | -1.04 | 2.6 |
| equinox 09:30 | NW | 43 | 169 | 136 | 0.85 (0.66) | +1.11 | 0.105 | -1.20 | 2.9 |
| midsummer 08:00 | W | 37 | 172 | 142 | 0.96 (0.75) | +1.15 | 0.093 | -1.28 | 2.5 |
| midwinter 09:30 | NW | 25 | 173 | 154 | 1.28 (0.90) | +1.40 | 0.081 | -1.59 | 2.0 |

Plus the southerly poses re-run at 4 cm: midwinter noon (theta 37) Cn -1.77, film 2.0 mrad; equinox noon (59) Cn -1.69, film
5.3 (was 3.4 at 6 cm: the harmonics are not converged at 6 cm, hence the 4 cm table). The table has 18 attitudes from 37 to
154 deg, and `tandoor_wind_table` takes the finest grid per attitude.

What the real wind does: at noon it is a crosswind (theta 82-90) and the load is 3-4x smaller than the env's drag
interpolation gave, with the film's figure error 0.3-0.6 mrad; in the mornings and afternoons, when the sun is east or
west, the westerlies land on the BACK of the bowl (theta 105-154) with a normal force of +0.35 to +1.40 q A pushing the
dish toward the sun and 1.4-2.9 mrad of figure error - as loaded as the old southerly cases, and the env's back-of-dish
model was 20-40 % low there. The one pose where a west wind enters the bowl squarely, equinox 15:30 (theta 53), is the
worst of the year: Cn -2.0, 6.3 mrad. All of it is now in the table both envs read.

## Turbulent inflow (W equinox noon, theta 83, 6 cm, the sub-box turbulence at 0.7 m/s rms = 6 % of U)

|F| 0.323 +- 0.065 q A against 0.366 +- 0.005 with steady inflow; |Cm| 0.014 +- 0.010 against 0.008 +- 0.001. The moment
fluctuation is 0.0095 rms for 6 % inflow turbulence; the site's gust ratio at U >= 6 is ~0.7, and scaling linearly gives
~0.11 - the CM_RMS 0.15 the envs carry is the right order for this convective site. Spectral peaks at 0.4-1.0 Hz.

## Coverage fix (2026-09-11 evening)

`tandoor_wind_table.head_aero` still masked incidence beyond 100 deg as uncovered from before the W/NW runs took the table
to 154 deg, so both envs ran the old drag model (1.4-1.7x low on the back of the dish) and the old 4 mrad film constant
(1.4-3x high there) for the morning and afternoon poses with the wind on the back. The mask is gone (`COVER_DEG` 180):
the table serves every incidence, held flat beyond its ends (below 37 deg and above 154). Both flat ends are pessimistic
for the film - the n = 1 harmonic vanishes by symmetry at 0 and 180 deg and the table holds 0.39 / 0.36 there - and
within ~10 % for the force of a dish this shallow. In the envs' own site-wind draw (seed 11, three steps after reset)
20 % of the fast env's 256 agents and 25 % of the slow env's 64 sit beyond 100 deg, with the film constant there
9.6e-6 to 2.0e-5 rad/(m/s)^2 against the old 2.63e-5. The watcher's evals of run 3 from this point run with slightly
different loads from the run's training, so the fair comparison is a re-eval of every checkpoint after run 3 ends.

## Three more columns (2026-09-12): `tilt1`, `k_fig`, `Cm_s`

`dish_table.py` now solves each harmonic's membrane response and writes the n = 1 deflection plane (`tilt1`, rad per
(m/s)^2 along the wind's projection on the dish; `tilt1_x` across it, ~0 by symmetry: +0.77 mrad at 37 deg, +2.33 at
53, +1.98 at 59, falling through zero near grazing to -0.8..-1.1 on the back), the figure residual with that plane
removed from n = 1 (`k_fig`), and the mean pitching moment SIGNED about n x w_hat (`Cm_s`: -0.08..-0.20 with the wind
into the bowl, +0.03..+0.11 on the back). `tilt1` is information, not a pointing bias: a rim-fixed film's aperture-mean
slope is zero by Gauss, so the n = 1 harmonic moves no centroid. `Cm_s` is what the fast env applies at the vertex.

## The film itself (2026-09-12)

The head is 50 um PET, flat, inflated to f = 4. That shape costs strain before any wind blows: a flat disc pulled into a
paraboloid stretches its area by a^2/16f^2, half of that as biaxial strain, plus the pretension's 1.08 %.

| f m | f/D | sag m | dome strain | total strain | stress MPa | of yield | shape pressure Pa |
|---|---|---|---|---|---|---|---|
| 4 | 0.95 | 0.276 | 0.86 % | 1.94 % | 116 | 1.29 | 1449 |
| 5 | 1.19 | 0.221 | 0.55 % | 1.63 % | 97 | 1.08 | 974 |
| 6 | 1.43 | 0.184 | 0.38 % | 1.46 % | 87 | 0.97 | 728 |
| 8 | 1.90 | 0.138 | 0.22 % | 1.30 % | 77 | 0.86 | 484 |

(the FvK solve says 98 MPa area-mean at f 4, 106 at the centre: the same story with the real strain distribution). PET
yields at ~90 MPa, 2.4 % strain. A flat PET film at f 4 is AT YIELD by geometry, and the strain is set by the shape, so a
thicker film changes the stress not at all. The hub hole concentrates it 2x: 196 MPa at its edge, above PET's ultimate
(~170). PET creeps ~1 % per decade of hours at 60 MPa; near yield it runs away: the shape drifts, the pump raises the
pressure to hold f, the stress rises with it. This is the fragility, and it is a design fact, not a wind fact.

The ways out, with their cost:
- a longer focal length: f 6 is at yield still, f 8 at 0.86 of it; the receiver geometry is built around f 4.
- a PRE-FORMED film, thermoformed to the paraboloid or sewn from gores like a balloon: the elastic strain is then only
  what the pretension asks, and the pretension only has to beat the wind's suction on the film (net Cp up to 1.7 q) with
  a margin. Holding to 15 m/s with a margin of 2 needs 394 Pa, 1576 N/m, 32 MPa - a third of yield, 55 at the hole - and
  the wind figure, which goes as 1/T, is 3.1x today's: 3.4 mrad at the worst attitude in 5 m/s, 11 in 9 m/s, with the
  modes at 0.57x (6.5 Hz for (0,1), still far above the gust). Holding to 9 m/s and stowing above it needs 11 MPa and
  gives 9.5 mrad at 5 m/s. The trade is the film's life against its figure in wind, and the five plenum zones and the
  fine stage are what buy the figure back.
- a stiffer film (polyimide, PEN) moves the yield strain, not the geometry.

Two model errors found on the way, both fixed in the envs:
- the sealed plenum's gas spring resists a change of VOLUME; the n >= 1 harmonics of the wind's pressure change none, so
  the valve does nothing to the figure error. The fast env multiplied the whole figure by 0.03 when sealed (the default):
  a 33x understatement; the slow env multiplied it by 33 when open. Now k_film V^2 softened, sealed or not.
- the n = 0 load, Cp_net q, DOES change the volume: sealed it is resisted 33x, open it reaches the focal length one to
  one - 42 cm of f at 12 m/s with the valve open, 1.3 cm sealed, 7 cm open at 5 m/s. The fast env now adds it to the
  plenum pressure the level and the focal length are read from (`film_load`, the table's `Cp_net` by incidence); the slow
  env carries it as a defocus blur in its readout. Opening the valve in wind is a focus hazard the policy can now see.

What the envs read out: `film_sig`, the tension over the thickness following the pressure as p^(2/3) from 98 MPa at the
design pressure, and `film_yield` past 90. The slow env's HUD says AT YIELD, which at f 4 it always is. The cook's fused
step still traces with its own wind blur (`sigw` in step_pre), not with this figure; that is the next seam.

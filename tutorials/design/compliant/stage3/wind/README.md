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

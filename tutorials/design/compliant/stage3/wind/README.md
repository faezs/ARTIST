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

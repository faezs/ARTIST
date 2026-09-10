# Weather for any spot on earth, and what Quetta's actually is

## Tools (venv `design/compliant/.venv-weather`, uv; GraphCast from the renamed `google-deepmind/graphcast` = `weathernext` repo
## checked out untracked at `resources/graphcast`, plus `resources/xarray_jax`; set PYTHONPATH to both)

- `weather_at.py history LAT LON START END` - ERA5 hourly at a point since 1940 (10 m wind, direction, 3 s gusts, 100 m wind,
  2 m temperature, GHI) through Open-Meteo's archive API. No account.
- `weather_at.py forecast LAT LON YYYY-MM-DDTHH STEPS` - GraphCast_small (Google DeepMind's public weights: 1 deg, 13 levels,
  mesh 2-5) run on this Mac's CPU from an initial state built out of Google's public ERA5 archive (ARCO-ERA5 on GCS,
  anonymous, 1959-2022): 2 analyses 6 h apart, the 13 levels picked from 37, 0.25 deg subsampled to 1 deg. A 24 h forecast
  costs 54 s of CPU including the JIT; the ERA5 reads for one initial state cost longer than the forecast.
- `run_small.py` - the same model on Google's own example input, scored against the ERA5 targets in the file.
- `quetta_wind.py` - ten years of ERA5 at the site against the envs' assumptions.

Three things that bit: the repo is now the `weathernext` package (`weathernext.weathernext1_graph.graphcast`,
`weathernext.utils.{checkpoint,data_utils,rollout,...}`) and pins a private dependency, so install it with `--no-deps` and
supply chex, dm-haiku, jraph, dm-tree, trimesh, rtree, fiddle, h5netcdf, absl-py, xarray_jax (from its git repo) by hand;
xarray >= 2025 no longer decodes timedeltas by default (`decode_timedelta=True` or the lead-time arithmetic fails); and
`make.sh` is not involved here, that one is FluidX3D's.

## GraphCast_small on the CPU, checked (run_small.py, 2022-01-01 00Z, Google's example input)

At Quetta, +6/+12/+18/+24 h: 10 m wind 1.79/0.63/0.85/1.33 m/s against ERA5's 1.65/0.48/0.79/1.87; 2 m temperature within
1.5 K; global 10 m wind RMSE at +24 h 1.31 m/s against a field rms of 6.94. It runs.

## Quetta's wind (ERA5 2013-2022, grid point 30.25 N 67.0 E at 1667 m, working day 07:30-16:30 local)

| | value | the envs assume |
|---|---|---|
| 10 m wind, mean / median / 95 % / 99 % / max | 1.9 / 1.7 / 4.2 / 5.2 / 6.9 m/s | 9-12 m/s mean for design |
| working hours with the hourly mean >= 9 / 12 / 15 m/s | 0 / 0 / 0 % | stow above 15 |
| working hours with a 3 s gust >= 9 / 12 / 15 m/s | 26 / 9 / 2.3 % | - |
| gust factor (3 s gust over the hourly mean), median | 3.7 (0.69 as an Iu at U >= 6) | 1.75 (Iu 0.25, sheared) |
| where the load comes from (U^2-weighted rose) | W 49 %, NW 29 %, SW 10 %, SE 7 %, S 4 % | from the SOUTH |
| diurnal | 0.9 m/s at 06-09 h, 2.7 m/s at 14-17 h | one mean |
| season | May peaks (2.6 mean, 5.1 at 95 %), Aug-Sep calmest | - |

Two consequences. The working-day wind at the site is a calm, convective regime with gusts, not the 9-12 m/s sheared
boundary layer the envs train on and the structure was sized for: at the 15 m/s stow limit the hourly mean never arrives
and the gusts do 2 % of the time. And the load comes from the west and northwest across a bowl that faces south, which is
the crosswind incidence the LES matrix touched only at its 96 deg point; the matrix should be re-planned for W/NW winds.
ERA5's 10 m wind in a 28 km cell of complex terrain is known to run low against valley stations, so the numbers are a
floor on the local means, not a ceiling on the gusts.

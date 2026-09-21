"""GraphCast_small (1 deg, 13 levels, public weights) on CPU: a 24 h forecast from Google's example ERA5 input, and the
10 m wind at a point compared with the ERA5 targets in the same file. The demo's model construction, verbatim in spirit."""
import sys, time, functools, numpy as np, pandas as pd, xarray as xr, jax, haiku as hk
from weathernext.weathernext1_graph import graphcast
from weathernext.utils import checkpoint, data_utils, rollout, normalization, autoregressive, casting
D = sys.argv[1]; lat, lon = float(sys.argv[2]), float(sys.argv[3])
with open(f"{D}/GraphCast_small.npz", "rb") as f: ckpt = checkpoint.load(f, graphcast.CheckPoint)
params, state = ckpt.params, {}; model_config, task_config = ckpt.model_config, ckpt.task_config
print("model:", ckpt.description[:80], "| resolution", model_config.resolution, "| levels", len(task_config.pressure_levels))
ex = xr.load_dataset(f"{D}/era5_2022-01-01_res1_l13_steps04.nc", decode_timedelta=True).compute()   # xarray >= 2025 no longer decodes timedeltas by default
diffs_stddev = xr.load_dataset(f"{D}/diffs_stddev_by_level.nc").compute(); mean_by = xr.load_dataset(f"{D}/mean_by_level.nc").compute(); stddev_by = xr.load_dataset(f"{D}/stddev_by_level.nc").compute()
inputs, targets, forcings = data_utils.extract_inputs_targets_forcings(ex, target_lead_times=slice(pd.Timedelta("6h"), pd.Timedelta("24h")), **{k: getattr(task_config, k) for k in ("input_variables", "target_variables", "forcing_variables", "pressure_levels", "input_duration")})
print("inputs", dict(inputs.sizes), "| targets", dict(targets.sizes))
def construct_wrapped_graphcast(model_config, task_config):
    predictor = graphcast.GraphCast(model_config, task_config)
    predictor = casting.Bfloat16Cast(predictor)
    predictor = normalization.InputsAndResiduals(predictor, diffs_stddev_by_level=diffs_stddev, mean_by_level=mean_by, stddev_by_level=stddev_by)
    predictor = autoregressive.Predictor(predictor, gradient_checkpointing=True)
    return predictor
@hk.transform_with_state
def run_forward(model_config, task_config, inputs, targets_template, forcings):
    predictor = construct_wrapped_graphcast(model_config, task_config)
    return predictor(inputs, targets_template=targets_template, forcings=forcings)
def with_configs(fn): return functools.partial(fn, model_config=model_config, task_config=task_config)
def with_params(fn): return functools.partial(fn, params=params, state=state)
def drop_state(fn): return lambda **kw: fn(**kw)[0]
run_forward_jitted = drop_state(with_params(jax.jit(with_configs(run_forward.apply))))
t0 = time.time()
pred = rollout.chunked_prediction(run_forward_jitted, rng=jax.random.PRNGKey(0), inputs=inputs, targets_template=targets*np.nan, forcings=forcings)
print(f"24 h forecast, 4 steps of 6 h, on CPU: {time.time() - t0:.0f} s")
def at(ds, name):
    v = ds[name].sel(lat=lat, lon=lon % 360, method="nearest"); return v.squeeze()
for name in ("10m_u_component_of_wind", "10m_v_component_of_wind", "2m_temperature"):
    p = at(pred, name).values.ravel(); t = at(targets, name).values.ravel()
    print(f"   {name:<26} forecast {np.round(p, 2)}  era5 {np.round(t, 2)}")
sp = np.hypot(at(pred, "10m_u_component_of_wind").values.ravel(), at(pred, "10m_v_component_of_wind").values.ravel())
st = np.hypot(at(targets, "10m_u_component_of_wind").values.ravel(), at(targets, "10m_v_component_of_wind").values.ravel())
print(f"   10 m wind speed at {lat} N {lon} E, +6..+24 h: forecast {np.round(sp, 2)} m/s, era5 {np.round(st, 2)}")
g = np.hypot(pred["10m_u_component_of_wind"].isel(time=-1).values, pred["10m_v_component_of_wind"].isel(time=-1).values)
print(f"   global 10 m wind at +24 h: mean {np.nanmean(g):.2f} m/s, max {np.nanmax(g):.1f}; grid {pred.sizes['lat']} x {pred.sizes['lon']}")
pred.to_netcdf(f"{D}/forecast_small_2022-01-01.nc"); print("->", f"{D}/forecast_small_2022-01-01.nc")

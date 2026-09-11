"""WEATHER FOR ANY SPOT ON EARTH. Two backends, one call:
  history   ERA5 hourly at the point (Open-Meteo's archive: 10 m wind, direction, gusts, 100 m wind), any date since 1940
  forecast  GraphCast_small (Google DeepMind, public weights, 1 deg, 13 levels) run here on the CPU from an initial state
            built out of Google's public ERA5 archive (ARCO-ERA5 on GCS, anonymous): any date 1959-2022, 6-hourly, 10 days

    weather_at.py history  LAT LON START END            -> CSV of the hourly series
    weather_at.py forecast LAT LON YYYY-MM-DDTHH STEPS  -> the point's 6-hourly forecast (and the global fields as netCDF)

The initial state: 2 analyses 6 h apart, the 13 GraphCast levels picked from ERA5's 37, 0.25 deg subsampled to 1 deg
(every 4th point), latitude flipped to ascending, precipitation summed to 6 h accumulations, TISR left to the model's own
solar-radiation code. The target slots are NaN with real datetimes so the forcings (solar, day/year progress) are exact."""
import sys, os, json, time, functools, urllib.request, concurrent.futures as cf, numpy as np, pandas as pd, xarray as xr
D = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")      # weights, stats, inputs and forecasts live here (untracked)
os.makedirs(D, exist_ok=True)
LEVELS = [50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000]
SURF = ["2m_temperature", "mean_sea_level_pressure", "10m_v_component_of_wind", "10m_u_component_of_wind"]
ATM = ["temperature", "geopotential", "u_component_of_wind", "v_component_of_wind", "vertical_velocity", "specific_humidity"]
ARCO = "gs://gcp-public-data-arco-era5/ar/full_37-1h-0p25deg-chunk-1.zarr-v3"

def history(lat, lon, start, end):
    url = (f"https://archive-api.open-meteo.com/v1/archive?latitude={lat}&longitude={lon}&start_date={start}&end_date={end}"
           "&hourly=wind_speed_10m,wind_direction_10m,wind_gusts_10m,wind_speed_100m,temperature_2m,shortwave_radiation&wind_speed_unit=ms&timezone=auto&models=era5")
    j = json.load(urllib.request.urlopen(url, timeout=120)); h = j["hourly"]
    return pd.DataFrame(dict(t=pd.to_datetime(h["time"]), U10=h["wind_speed_10m"], dir10=h["wind_direction_10m"], gust10=h["wind_gusts_10m"],
                             U100=h["wind_speed_100m"], T2=h["temperature_2m"], ghi=h["shortwave_radiation"])), j["timezone"], j["elevation"]

def _sub(a):                                                     # 0.25 deg (721 lat descending, 1440 lon) -> 1 deg ascending lat
    return a[::-4, ::4] if a.ndim == 2 else a[..., ::-4, ::4]

def era5_initial_state(t0, n_steps, workers=8):
    """the GraphCast_small input dataset for analyses at t0 - 6 h and t0, plus n_steps NaN target slots every 6 h"""
    ds = xr.open_zarr(ARCO, chunks=None, storage_options=dict(token="anon"), decode_timedelta=True)
    t0 = pd.Timestamp(t0); times_in = [t0 - pd.Timedelta("6h"), t0]; times_all = times_in + [t0 + pd.Timedelta(6*(k + 1), "h") for k in range(n_steps)]
    lat = np.arange(-90.0, 91.0, 1.0, dtype=np.float32); lon = np.arange(0.0, 360.0, 1.0, dtype=np.float32)
    jobs = [("static", v, None, None) for v in ("geopotential_at_surface", "land_sea_mask")]
    for ti, t in enumerate(times_in):
        jobs += [("surf", v, ti, t) for v in SURF] + [("atm", v, ti, t) for v in ATM]
        jobs += [("tp", None, ti, t)]
    def fetch(job):
        kind, v, ti, t = job
        if kind == "static": return job, _sub(ds[v].values.astype(np.float32))
        if kind == "surf": return job, _sub(ds[v].sel(time=t).values.astype(np.float32))
        if kind == "atm": return job, _sub(ds[v].sel(time=t, level=LEVELS).values.astype(np.float32))
        tp = ds["total_precipitation"].sel(time=slice(t - pd.Timedelta("5h"), t)).values.astype(np.float32).sum(0); return job, _sub(tp)
    out = {}; t_start = time.time()
    with cf.ThreadPoolExecutor(workers) as ex:
        for job, arr in ex.map(fetch, jobs): out[job] = arr
    print(f"   {len(jobs)} ERA5 fields read from Google's archive in {time.time() - t_start:.0f} s", flush=True)
    nt = len(times_all); nan2 = np.full((1, nt, 181, 360), np.nan, np.float32); nan3 = np.full((1, nt, 13, 181, 360), np.nan, np.float32)
    data = {}
    for v in SURF + ["total_precipitation_6hr"]:
        a = nan2.copy()
        for ti in range(2): a[0, ti] = out[("surf", v, ti, times_in[ti])] if v != "total_precipitation_6hr" else out[("tp", None, ti, times_in[ti])]
        data[v] = (("batch", "time", "lat", "lon"), a)
    for v in ATM:
        a = nan3.copy()
        for ti in range(2): a[0, ti] = out[("atm", v, ti, times_in[ti])]
        data[v] = (("batch", "time", "level", "lat", "lon"), a)
    data["geopotential_at_surface"] = (("lat", "lon"), out[("static", "geopotential_at_surface", None, None)])
    data["land_sea_mask"] = (("lat", "lon"), out[("static", "land_sea_mask", None, None)])
    time_td = np.array([(t - times_in[0]).to_timedelta64() for t in times_all], dtype="timedelta64[ns]")
    coords = dict(lat=lat, lon=lon, level=np.array(LEVELS, np.int32), time=time_td,
                  datetime=(("batch", "time"), np.array([[t.to_datetime64() for t in times_all]], dtype="datetime64[ns]")))
    return xr.Dataset(data, coords=coords)

def forecast(lat, lon, t0, n_steps):
    import jax, haiku as hk
    from weathernext.weathernext1_graph import graphcast
    from weathernext.utils import checkpoint, data_utils, rollout, normalization, autoregressive, casting
    with open(f"{D}/GraphCast_small.npz", "rb") as f: ckpt = checkpoint.load(f, graphcast.CheckPoint)
    params, state, model_config, task_config = ckpt.params, {}, ckpt.model_config, ckpt.task_config
    diffs_stddev = xr.load_dataset(f"{D}/diffs_stddev_by_level.nc").compute(); mean_by = xr.load_dataset(f"{D}/mean_by_level.nc").compute(); stddev_by = xr.load_dataset(f"{D}/stddev_by_level.nc").compute()
    cache = f"{D}/init_{pd.Timestamp(t0).strftime('%Y%m%dT%H')}_{n_steps}.nc"
    if os.path.exists(cache):
        ex = xr.load_dataset(cache, decode_timedelta=True); print(f"initial state from cache {cache}", flush=True)
    else:
        print(f"building the initial state for {t0} from ARCO-ERA5 ...", flush=True)
        ex = era5_initial_state(t0, n_steps); ex.to_netcdf(cache); print(f"   cached -> {cache}", flush=True)
    print("   input sanity: T2 mean %.1f K, msl mean %.0f Pa, u10 rms %.2f, tp6 mean %.2e m, z_sfc mean %.0f" % (
        float(ex["2m_temperature"].isel(time=1).mean()), float(ex["mean_sea_level_pressure"].isel(time=1).mean()),
        float(np.sqrt((ex["10m_u_component_of_wind"].isel(time=1)**2).mean())), float(ex["total_precipitation_6hr"].isel(time=1).mean()), float(ex["geopotential_at_surface"].mean())), flush=True)
    tc = {k: getattr(task_config, k) for k in ("input_variables", "target_variables", "forcing_variables", "pressure_levels", "input_duration")}
    inputs, targets, forcings = data_utils.extract_inputs_targets_forcings(ex, target_lead_times=slice(pd.Timedelta("6h"), pd.Timedelta(6*n_steps, "h")), **tc)
    def construct(model_config, task_config):
        p = graphcast.GraphCast(model_config, task_config); p = casting.Bfloat16Cast(p)
        p = normalization.InputsAndResiduals(p, diffs_stddev_by_level=diffs_stddev, mean_by_level=mean_by, stddev_by_level=stddev_by)
        return autoregressive.Predictor(p, gradient_checkpointing=True)
    @hk.transform_with_state
    def run_forward(model_config, task_config, inputs, targets_template, forcings):
        return construct(model_config, task_config)(inputs, targets_template=targets_template, forcings=forcings)
    fwd = functools.partial(run_forward.apply, params=params, state=state, model_config=model_config, task_config=task_config)
    fwd_j = jax.jit(fwd); step = lambda **kw: fwd_j(**kw)[0]
    t_s = time.time()
    pred = rollout.chunked_prediction(step, rng=jax.random.PRNGKey(0), inputs=inputs, targets_template=targets*np.nan, forcings=forcings)
    print(f"GraphCast_small: {n_steps} steps of 6 h ({6*n_steps/24:.1f} days) on the CPU in {time.time() - t_s:.0f} s", flush=True)
    tag = pd.Timestamp(t0).strftime("%Y%m%dT%H"); pred.to_netcdf(f"{D}/forecast_{tag}_{n_steps}steps.nc")
    at = lambda v: pred[v].sel(lat=lat, lon=lon % 360, method="nearest").values.ravel()
    u, v = at("10m_u_component_of_wind"), at("10m_v_component_of_wind"); sp = np.hypot(u, v); dr = (np.degrees(np.arctan2(-u, -v)) + 360) % 360
    T2 = at("2m_temperature") - 273.15
    rows = pd.DataFrame(dict(datetime=pred.datetime.values.ravel(), U10=sp.round(2), dir10=dr.round(0), T2=T2.round(1), msl_hPa=(at("mean_sea_level_pressure")/100).round(1)))
    rows.to_csv(f"{D}/forecast_{tag}_{n_steps}steps_{lat}_{lon}.csv", index=False); return rows

if __name__ == "__main__":
    mode, lat, lon = sys.argv[1], float(sys.argv[2]), float(sys.argv[3])
    if mode == "history":
        d, tz, elev = history(lat, lon, sys.argv[4], sys.argv[5]); p = f"{D}/history_{lat}_{lon}_{sys.argv[4]}_{sys.argv[5]}.csv"; d.to_csv(p, index=False)
        print(f"{len(d)} hours at {lat} N {lon} E (elevation {elev} m, {tz}): U10 mean {d.U10.mean():.2f} m/s, 95 % {d.U10.quantile(0.95):.2f}, gust 95 % {d.gust10.quantile(0.95):.2f} -> {p}")
    else:
        rows = forecast(lat, lon, sys.argv[4], int(sys.argv[5])); print(rows.to_string(index=False))

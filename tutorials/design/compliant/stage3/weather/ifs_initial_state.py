"""GraphCast_small's initial state from TODAY's analyses: ECMWF open data (IFS HRES, 0.25 deg, free,
no account), the two latest 6-hourly cycles at step 0, subsampled to 1 deg. The model was trained on
ERA5, and an IFS analysis is not ERA5 - close enough for a forecast, and the only current analysis
that is free. The 6 h precipitation before each analysis is the previous cycle's 6 h forecast total.
Static fields (surface geopotential, land-sea mask) come from Google's ERA5 example file, the same
1 deg grid the weights were trained with.

    ifs_initial_state(t0=None, n_steps=40) -> dataset in the package layout (2 inputs + n_steps NaN targets)
"""
import os, sys, time, numpy as np, pandas as pd, xarray as xr
HERE = os.path.dirname(os.path.abspath(__file__)); D = os.path.join(HERE, "data"); G0 = 9.80665
LEVELS = [50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000]
PL = {"t": "temperature", "gh": "geopotential", "u": "u_component_of_wind", "v": "v_component_of_wind", "w": "vertical_velocity", "q": "specific_humidity"}
SFC = {"2t": "2m_temperature", "msl": "mean_sea_level_pressure", "10u": "10m_u_component_of_wind", "10v": "10m_v_component_of_wind"}
STATIC = f"{D}/era5_2022-01-01_res1_l13_steps04.nc"


def _client():
    from ecmwf.opendata import Client
    return Client(source="ecmwf", model="ifs", resol="0p25")


def latest_cycle():
    """the latest 00/06/12/18 cycle whose step-0 fields are published"""
    return pd.Timestamp(_client().latest(type="fc", step=0, param="2t"))


CF = {"2t": "t2m", "10u": "u10", "10v": "v10", "msl": "msl", "tp": "tp"}   # GRIB shortName -> cfgrib variable name (pressure-level names are unchanged)


def _grib(path):
    """every hypercube in the file (cfgrib splits by level type), as one name -> DataArray map"""
    import cfgrib
    out = {}
    for ds in cfgrib.open_datasets(path, backend_kwargs=dict(indexpath=""), decode_timedelta=True):
        for v in ds.data_vars: out.setdefault(v, ds[v])
    return out


def _regrid(da, lat, lon):
    """the GRIB field (whatever its latitude order and longitude origin: the open data runs 90..-90 and
    -180..179.75) onto the target grid by exact coordinate match. Rotating the planet by 180 deg is the
    silent failure this guards against."""
    glat, glon = np.asarray(da.latitude.values, np.float64), np.mod(np.asarray(da.longitude.values, np.float64), 360.0)
    ilat = np.array([int(np.argmin(np.abs(glat - x))) for x in lat]); ilon = np.array([int(np.argmin(np.abs(glon - x))) for x in lon])
    assert np.abs(glat[ilat] - lat).max() < 1e-6 and np.abs(glon[ilon] - lon).max() < 1e-6, "the target grid is not a subset of the GRIB grid"
    a = np.asarray(da.values, np.float32)
    return a[..., ilat, :][..., :, ilon]


LAT1 = np.arange(-90.0, 91.0, 1.0); LON1 = np.arange(0.0, 360.0, 1.0)
def _sub(da): return _regrid(da, LAT1, LON1)


def fetch_cycle(t, workdir, retries=3):
    """the step-0 analysis of cycle t (surface + pressure levels) and the 6 h precipitation ending at t
    (the previous cycle's step 6), as dicts of 1 deg arrays"""
    c = _client(); os.makedirs(workdir, exist_ok=True); tag = t.strftime("%Y%m%d%H")
    sfc, pl, tp = [f"{workdir}/{tag}_{k}.grib2" for k in ("sfc", "pl", "tp")]
    prev = t - pd.Timedelta("6h")
    jobs = [(sfc, dict(date=t.strftime("%Y-%m-%d"), time=t.hour, step=0, type="fc", param=list(SFC) + ["lsm"])),
            (pl, dict(date=t.strftime("%Y-%m-%d"), time=t.hour, step=0, type="fc", param=list(PL), levelist=LEVELS)),
            (tp, dict(date=prev.strftime("%Y-%m-%d"), time=prev.hour, step=6, type="fc", param=["tp"]))]
    for path, req in jobs:
        if os.path.exists(path) and os.path.getsize(path) > 0: continue
        for k in range(retries):
            try: c.retrieve(target=path, **req); break
            except Exception as e:
                if k == retries - 1: raise
                print(f"   retry {k + 1} for {os.path.basename(path)}: {e}", flush=True); time.sleep(10)
    out = {}
    ds = _grib(sfc)
    for short, name in SFC.items(): out[name] = _sub(ds[CF[short]])
    out["lsm_ifs"] = _sub(ds["lsm"])
    ds = _grib(pl)
    for short, name in PL.items():
        out[name] = _sub(ds[short].sel(isobaricInhPa=LEVELS)) * (G0 if short == "gh" else 1.0)
    out["total_precipitation_6hr"] = _sub(_grib(tp)["tp"])
    return out


def ifs_initial_state(t0=None, n_steps=40, workdir=None):
    t0 = pd.Timestamp(t0) if t0 is not None else latest_cycle()
    workdir = workdir or f"{D}/ifs"
    times_in = [t0 - pd.Timedelta("6h"), t0]; times_all = times_in + [t0 + pd.Timedelta(6 * (k + 1), "h") for k in range(n_steps)]
    st = xr.load_dataset(STATIC, decode_timedelta=True)
    lat, lon = st.lat.values.astype(np.float32), st.lon.values.astype(np.float32)
    fields = [fetch_cycle(t, workdir) for t in times_in]
    nt = len(times_all); nan2 = np.full((1, nt, lat.size, lon.size), np.nan, np.float32); nan3 = np.full((1, nt, len(LEVELS), lat.size, lon.size), np.nan, np.float32)
    data = {}
    for name in list(SFC.values()) + ["total_precipitation_6hr"]:
        a = nan2.copy(); a[0, 0], a[0, 1] = fields[0][name], fields[1][name]; data[name] = (("batch", "time", "lat", "lon"), a)
    for name in PL.values():
        a = nan3.copy(); a[0, 0], a[0, 1] = fields[0][name], fields[1][name]; data[name] = (("batch", "time", "level", "lat", "lon"), a)
    data["geopotential_at_surface"] = (("lat", "lon"), st["geopotential_at_surface"].values.astype(np.float32))
    data["land_sea_mask"] = (("lat", "lon"), st["land_sea_mask"].values.astype(np.float32))
    # the orientation check: IFS's own land-sea mask must land on ERA5's
    agree = float(np.mean((fields[1]["lsm_ifs"] > 0.5) == (st["land_sea_mask"].values > 0.5)))
    assert agree > 0.97, f"IFS and ERA5 land-sea masks agree on only {100 * agree:.1f} % of points: the regridding is wrong"
    time_td = np.array([(t - times_in[0]).to_timedelta64() for t in times_all], dtype="timedelta64[ns]")
    coords = dict(lat=lat, lon=lon, level=np.array(LEVELS, np.int32), time=time_td,
                  datetime=(("batch", "time"), np.array([[t.to_datetime64() for t in times_all]], dtype="datetime64[ns]")))
    return xr.Dataset(data, coords=coords)


if __name__ == "__main__":
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 40
    t = time.time(); ds = ifs_initial_state(n_steps=n); t0 = pd.Timestamp(ds.datetime.values[0, 1])
    p = f"{D}/init_ifs_{t0.strftime('%Y%m%dT%H')}_{n}.nc"; ds.to_netcdf(p)
    print(f"initial state {t0} from ECMWF open data in {time.time() - t:.0f} s -> {p}")
    print("   T2 mean %.1f K, msl mean %.0f Pa, u10 rms %.2f, tp6 mean %.2e m, z500 mean %.0f" % (
        float(ds["2m_temperature"].isel(time=1).mean()), float(ds["mean_sea_level_pressure"].isel(time=1).mean()),
        float(np.sqrt((ds["10m_u_component_of_wind"].isel(time=1) ** 2).mean())), float(ds["total_precipitation_6hr"].isel(time=1).mean()),
        float(ds["geopotential"].isel(time=1).sel(level=500).mean())))

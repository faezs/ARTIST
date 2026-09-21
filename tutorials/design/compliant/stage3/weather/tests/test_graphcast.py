"""Does GraphCast work here? The MLX port against the JAX reference, the graphs, the features, the
skill against ERA5, the point readout, and the two initial-state builders.

    ../../.venv-weather/bin/python -m pytest tests -q                 # offline tests (~1 min; the JAX references are cached)
    ../../.venv-weather/bin/python -m pytest tests -q -m network      # + ECMWF open data and Google's ERA5 archive
"""
import os, sys, json, time, numpy as np, pandas as pd, xarray as xr, pytest
HERE = os.path.dirname(os.path.abspath(__file__)); W = os.path.dirname(HERE); D = os.path.join(W, "data")
sys.path.insert(0, W)
import mlx.core as mx
import graphcast_mlx as G, jax_reference as J

EXAMPLE = f"{D}/era5_2022-01-01_res1_l13_steps04.nc"
QUETTA = (30.2, 67.0)
network = pytest.mark.network


@pytest.fixture(scope="session")
def ds():
    return xr.load_dataset(EXAMPLE, decode_timedelta=True)


@pytest.fixture(scope="session")
def model(ds):
    return G.load_model(dtype=mx.float32, grid_lat=ds.lat.values, grid_lon=ds.lon.values)


@pytest.fixture(scope="session")
def tc():
    return json.loads(str(np.load(f"{D}/GraphCast_small_mlx.npz")["__config__"]))["task"]


def test_checkpoint_converts_and_matches_the_published_model(model):
    assert model.n_params == 35_979_347, model.n_params
    assert model.mc == dict(resolution=1.0, mesh_size=5, latent_size=512, gnn_msg_steps=16, hidden_layers=1,
                            radius_query_fraction_edge_length=0.6, mesh2grid_edge_normalization_factor=pytest.approx(0.6180338738074472))
    assert list(model.tc["pressure_levels"]) == [50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000]
    assert len(model.tc["target_variables"]) == 11 and len(model.tc["forcing_variables"]) == 5
    assert model.p["mesh2grid_gnn/~_networks_builder/decoder_nodes_grid_nodes_mlp/~/linear_1|w"].shape == (512, 83)   # 5 surface + 6 x 13 levels


def test_graphs_are_the_papers(model):
    assert model.n_grid == 181 * 360 and model.n_mesh == 10242                      # 1 deg grid, icosahedron split 5 times
    g = model.np_graphs
    for s, r, e in (g["g2m"], g["mesh"], g["m2g"]):
        assert s.shape == r.shape and e.shape == (s.shape[0], 4) and np.isfinite(e).all()
        assert np.abs(e[:, 0]).max() <= 1.0 + 1e-5                                   # edge length normalised by the longest
    assert g["g2m"][0].max() < model.n_grid and g["g2m"][1].max() < model.n_mesh
    assert g["mesh"][0].shape[0] == 81900                                            # the multimesh: every level's edges, both directions
    assert np.array_equal(np.bincount(g["m2g"][1], minlength=model.n_grid), np.full(model.n_grid, 3))   # each grid point in one triangle
    assert (np.bincount(g["g2m"][1], minlength=model.n_mesh) > 0).all()              # every mesh node hears some grid
    assert g["g_feat"].shape == (model.n_grid, 3) and np.allclose(np.linalg.norm(g["g_feat"][:, 1:], axis=1), 1.0, atol=1e-5)   # cos/sin lon


def test_features_are_stacked_as_the_model_expects(ds, model, tc):
    inputs, targets, forcings = G.extract(ds, tc, 1)
    mean, std, _ = G.load_stats()
    f = G.grid_features(G.normalize(inputs, mean, std), G.normalize(forcings, mean, std))
    assert f.shape == (model.n_grid, 1, 183)                                        # + 3 spatial = 186, the encoder's fan-in
    assert model.p["grid2mesh_gnn/~_networks_builder/encoder_nodes_grid_nodes_mlp/~/linear_0|w"].shape[0] == 183 + 3
    assert np.isfinite(f).all() and np.abs(f).mean() < 3                             # normalised: order one
    assert sorted(inputs.data_vars) == list(sorted(inputs.data_vars))               # channel order is sorted names (dataset_to_stacked)


def test_mlx_float32_matches_jax_float32(ds, model):
    ref = J.cached(EXAMPLE, 1, bf16=False)
    pred = G.predict(model, ds, 1)
    worst = {}
    for v in pred.data_vars:
        a, b = pred[v].values, ref[v].values
        worst[v] = float(np.sqrt(((a - b) ** 2).mean()) / b.std())
    assert max(worst.values()) < 1e-4, worst                                        # float rounding, nothing else
    assert float(np.abs(pred["2m_temperature"].values - ref["2m_temperature"].values).max()) < 1e-3


def test_mlx_bfloat16_is_within_bfloat16_of_the_demo(ds):
    """the demo construction (Bfloat16Cast) as stored by run_small.py, 4 steps, vs MLX bf16"""
    ref = xr.load_dataset(f"{D}/forecast_small_2022-01-01.nc", decode_timedelta=True)
    m = G.load_model(dtype=mx.bfloat16, grid_lat=ds.lat.values, grid_lon=ds.lon.values)
    pred = G.predict(m, ds, 4)
    for v in ("2m_temperature", "10m_u_component_of_wind", "mean_sea_level_pressure", "geopotential"):
        a, b = pred[v].values, ref[v].transpose(*pred[v].dims).values      # the JAX rollout writes (time, batch, ...)
        assert a.shape == b.shape, (a.shape, b.shape)
        rel = np.sqrt(((a - b) ** 2).mean()) / b.std()
        assert rel < 0.05, (v, rel)


def test_forecast_beats_persistence_against_era5(ds, model, tc):
    pred = G.predict(model, ds, 4)
    inputs, targets, _ = G.extract(ds, tc, 4)
    for v in ("2m_temperature", "10m_u_component_of_wind", "mean_sea_level_pressure", "temperature", "geopotential"):
        last = inputs[v].isel(time=-1).values
        for k in range(4):
            e_model = np.sqrt(((pred[v].isel(time=k).values - targets[v].isel(time=k).values) ** 2).mean())
            e_persist = np.sqrt(((last - targets[v].isel(time=k).values) ** 2).mean())
            assert e_model < 0.8 * e_persist, (v, k, e_model, e_persist)


def test_point_readout_quetta_matches_the_readme(ds, model):
    pred = G.predict(model, ds, 4)
    at = lambda v: pred[v].sel(lat=QUETTA[0], lon=QUETTA[1], method="nearest").values.ravel()
    sp = np.hypot(at("10m_u_component_of_wind"), at("10m_v_component_of_wind"))
    assert sp.shape == (4,) and np.allclose(sp, [1.79, 0.63, 0.85, 1.33], atol=0.25), sp     # README: the JAX bf16 run's numbers
    T2 = at("2m_temperature") - 273.15
    assert (-15 < T2).all() and (T2 < 30).all(), T2                                            # Quetta, 1 January


def test_rollout_never_sees_the_targets(ds, model):
    """the file's own analyses at the target times must not leak into the forecast: NaN them out and
    the forecast must not change (extract anchors the inputs on the END of the file: 4 times -> inputs 0, 1)"""
    d4 = ds.isel(time=slice(0, 4)); d4n = d4.copy(deep=True)
    for v in model.tc["target_variables"]: d4n[v].values[:, 2:] = np.nan
    p1 = G.predict(model, d4, 2); p2 = G.predict(model, d4n, 2)
    assert np.isfinite(p2["2m_temperature"].values).all()
    assert np.allclose(p1["2m_temperature"].values, p2["2m_temperature"].values)
    assert not np.allclose(p1["2m_temperature"].isel(time=0).values, p1["2m_temperature"].isel(time=1).values)   # the state moves


@network
def test_ecmwf_open_data_initial_state():
    import ifs_initial_state as I
    t0 = I.latest_cycle(); assert (pd.Timestamp.utcnow().tz_localize(None) - t0) < pd.Timedelta("36h"), t0
    st = I.ifs_initial_state(t0=t0, n_steps=1)
    assert st.sizes == {"batch": 1, "time": 3, "lat": 181, "lon": 360, "level": 13}
    for v in ("2m_temperature", "temperature", "geopotential", "specific_humidity", "vertical_velocity", "total_precipitation_6hr"):
        a = st[v].isel(time=slice(0, 2)).values; assert np.isfinite(a).all(), v
        assert np.isnan(st[v].isel(time=2).values).all(), v
    T2 = st["2m_temperature"].isel(time=1).values; assert 180 < T2.min() and T2.max() < 335      # Antarctic September nights reach 195 K
    msl = st["mean_sea_level_pressure"].isel(time=1).values; assert 87000 < msl.min() and msl.max() < 108000
    z500 = st["geopotential"].isel(time=1).sel(level=500).values; assert 48000 < z500.mean() < 58000
    assert (st["total_precipitation_6hr"].isel(time=1).values >= -1e-6).all()
    # the orientation guard itself: a field rolled by 180 deg must be rejected
    fields = I.fetch_cycle(t0, f"{D}/ifs"); era5 = xr.load_dataset(I.STATIC)["land_sea_mask"].values > 0.5
    assert np.mean((fields["lsm_ifs"] > 0.5) == era5) > 0.97
    assert np.mean((np.roll(fields["lsm_ifs"], 180, axis=-1) > 0.5) == era5) < 0.9


@network
def test_graphcast_agrees_with_ifs_at_short_lead():
    """from the same analysis, GraphCast's +6 h and ECMWF's own +6 h must be close: a rotated or
    mis-scaled initial state shows up here as several kelvin"""
    import ifs_initial_state as I
    t0 = I.latest_cycle(); st = I.ifs_initial_state(t0=t0, n_steps=2)
    m = G.load_model(dtype=mx.float32, grid_lat=st.lat.values, grid_lon=st.lon.values); pred = G.predict(m, st, 2)
    p = f"{D}/ifs/{t0.strftime('%Y%m%d%H')}_fc12_sfc.grib2"
    if not os.path.exists(p): I._client().retrieve(target=p, date=t0.strftime("%Y-%m-%d"), time=t0.hour, step=[6, 12], type="fc", param=["2t", "msl"])
    ifs = I._grib(p)
    for k, lead in enumerate((6, 12)):
        t_ifs = I._sub(ifs["t2m"].sel(step=pd.Timedelta(lead, "h"))); t_gc = pred["2m_temperature"].isel(time=k).values[0]
        rmse = float(np.sqrt(((t_gc - t_ifs) ** 2).mean())); assert rmse < 2.5, (lead, rmse)
        m_ifs = I._sub(ifs["msl"].sel(step=pd.Timedelta(lead, "h"))); m_gc = pred["mean_sea_level_pressure"].isel(time=k).values[0]
        assert float(np.sqrt(((m_gc - m_ifs) ** 2).mean())) < 300, lead


@network
def test_arco_era5_archive_reads():
    sys.path.insert(0, W); import weather_at as WA
    ds = xr.open_zarr(WA.ARCO, chunks=None, storage_options=dict(token="anon"), decode_timedelta=True)
    a = ds["2m_temperature"].sel(time="2022-06-01T00").values
    assert a.shape == (721, 1440) and 200 < np.nanmean(a) < 320

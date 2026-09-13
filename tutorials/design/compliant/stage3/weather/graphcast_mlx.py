"""GraphCast on the Apple GPU: Google DeepMind's model re-expressed in MLX.

The public JAX/haiku implementation (the `weathernext` package) cannot reach the M1's GPU: jax-metal
is pinned to an old StableHLO and jax 0.10 rejects it. The network itself is small - MLPs with a
LayerNorm, a gather, a scatter-add - so it is re-expressed here in MLX, weight for weight, and the
graph tables (icosahedral multimesh, radius query, triangle containment, the spatial features) are
the package's own numpy code. The JAX model is the reference: tests/test_graphcast.py runs both on
the same input and compares.

  convert_checkpoint()           GraphCast_small.npz (haiku) -> GraphCast_small_mlx.npz (flat, + configs)
  GraphCastMLX(npz, lat, lon)    the model on a grid; .step(features) is one 6 h step on the grid nodes
  predict(model, ds, n_steps)    the autoregressive rollout from a dataset in the package's layout
                                 (2 input times, n_steps NaN target slots), returns the predictions

Faithful to the reference: the residual is on both nodes and edges, the grid2mesh aggregation is in
float32 even in bfloat16 mode (f32_aggregation), the mesh2grid edge normalisation is the checkpoint's
constant, LayerNorm eps 1e-5, swish activations, targets = last input + residual x diffs_stddev.
"""
import os, sys, json, time, dataclasses
import numpy as np, pandas as pd, xarray as xr
import mlx.core as mx

HERE = os.path.dirname(os.path.abspath(__file__)); D = os.path.join(HERE, "data")
sys.path.insert(0, "/Users/faezs/ARTIST-compliant/resources/xarray_jax")
from weathernext.utils import icosahedral_mesh, model_utils, data_utils
from weathernext.utils.legacy import grid_mesh_connectivity

TASK_KEYS = ("input_variables", "target_variables", "forcing_variables", "pressure_levels", "input_duration")


def convert_checkpoint(src=None, dst=None):
    """The haiku checkpoint as a flat npz: 'module|param' -> array, plus '__config__' (json)."""
    src = src or f"{D}/GraphCast_small.npz"; dst = dst or src.replace(".npz", "_mlx.npz")
    from weathernext.weathernext1_graph import graphcast
    from weathernext.utils import checkpoint
    with open(src, "rb") as f: ckpt = checkpoint.load(f, graphcast.CheckPoint)
    flat = {f"{k}|{n}": np.asarray(v, np.float32) for k, g in ckpt.params.items() for n, v in g.items()}
    tc = ckpt.task_config
    tcd = {k: (list(v) if isinstance(v, (tuple, list)) else v) for k, v in ((k, getattr(tc, k)) for k in TASK_KEYS)}
    cfg = {"model": dataclasses.asdict(ckpt.model_config), "task": tcd, "description": ckpt.description}
    np.savez(dst, __config__=np.array(json.dumps(cfg)), **flat)
    return dst


class GraphCastMLX:
    def __init__(self, params_npz, grid_lat, grid_lon, dtype=mx.float32):
        z = np.load(params_npz); cfg = json.loads(str(z["__config__"]))
        self.mc, self.tc, self.description = cfg["model"], cfg["task"], cfg.get("description", "")
        self.dtype = dtype
        self.p = {k: mx.array(z[k]).astype(dtype) for k in z.files if k != "__config__"}
        self.n_params = sum(int(np.prod(z[k].shape)) for k in z.files if k != "__config__")
        self.grid_lat = np.asarray(grid_lat, np.float32); self.grid_lon = np.asarray(grid_lon, np.float32)
        self._build_graphs()

    # ---- the three graphs, exactly as graphcast.GraphCast._init_* builds them (numpy) ----
    def _build_graphs(self):
        mc = self.mc
        meshes = icosahedral_mesh.get_hierarchy_of_triangular_meshes_for_sphere(splits=mc["mesh_size"])
        finest = meshes[-1]
        s, r = icosahedral_mesh.faces_to_edges(finest.faces)
        radius = np.linalg.norm(finest.vertices[s] - finest.vertices[r], axis=-1).max() * mc["radius_query_fraction_edge_length"]
        phi, theta = model_utils.cartesian_to_spherical(finest.vertices[:, 0], finest.vertices[:, 1], finest.vertices[:, 2])
        mesh_lat, mesh_lon = model_utils.spherical_to_lat_lon(phi=phi, theta=theta)
        mesh_lat, mesh_lon = mesh_lat.astype(np.float32), mesh_lon.astype(np.float32)
        glon, glat = np.meshgrid(self.grid_lon, self.grid_lat)
        glon, glat = glon.reshape(-1).astype(np.float32), glat.reshape(-1).astype(np.float32)
        kw = dict(add_node_positions=False, add_node_latitude=True, add_node_longitude=True, add_relative_positions=True,
                  relative_longitude_local_coordinates=True, relative_latitude_local_coordinates=True)
        gi, mi = grid_mesh_connectivity.radius_query_indices(grid_latitude=self.grid_lat, grid_longitude=self.grid_lon, mesh=finest, radius=radius)
        g_feat, m_feat, g2m_e = model_utils.get_bipartite_graph_spatial_features(
            senders_node_lat=glat, senders_node_lon=glon, receivers_node_lat=mesh_lat, receivers_node_lon=mesh_lon,
            senders=gi, receivers=mi, edge_normalization_factor=None, **kw)
        merged = icosahedral_mesh.merge_meshes(meshes); ms, mr = icosahedral_mesh.faces_to_edges(merged.faces)
        _, mesh_e = model_utils.get_graph_spatial_features(node_lat=mesh_lat, node_lon=mesh_lon, senders=ms, receivers=mr, **kw)
        gi2, mi2 = grid_mesh_connectivity.in_mesh_triangle_indices(grid_latitude=self.grid_lat, grid_longitude=self.grid_lon, mesh=finest)
        _, _, m2g_e = model_utils.get_bipartite_graph_spatial_features(
            senders_node_lat=mesh_lat, senders_node_lon=mesh_lon, receivers_node_lat=glat, receivers_node_lon=glon,
            senders=mi2, receivers=gi2, edge_normalization_factor=mc["mesh2grid_edge_normalization_factor"], **kw)
        self.n_grid, self.n_mesh = glat.shape[0], mesh_lat.shape[0]
        self.mesh_lat, self.mesh_lon = mesh_lat, mesh_lon
        self.np_graphs = dict(g_feat=g_feat, m_feat=m_feat, g2m=(gi, mi, g2m_e), mesh=(ms, mr, mesh_e), m2g=(mi2, gi2, m2g_e))
        f = lambda a: mx.array(np.asarray(a, np.float32)).astype(self.dtype); i = lambda a: mx.array(np.asarray(a, np.int32))
        self.g_feat, self.m_feat = f(g_feat), f(m_feat)
        self.g2m_s, self.g2m_r, self.g2m_e = i(gi), i(mi), f(g2m_e)
        self.mesh_s, self.mesh_r, self.mesh_e = i(ms), i(mr), f(mesh_e)
        self.m2g_s, self.m2g_r, self.m2g_e = i(mi2), i(gi2), f(m2g_e)

    # ---- the haiku modules: MLP(hidden, out) with swish, then LayerNorm ----
    def _mlp(self, x, name):
        p = self.p
        h = x @ p[f"{name}_mlp/~/linear_0|w"] + p[f"{name}_mlp/~/linear_0|b"]
        h = h * mx.sigmoid(h)
        return h @ p[f"{name}_mlp/~/linear_1|w"] + p[f"{name}_mlp/~/linear_1|b"]

    def _mlp_ln(self, x, name):
        return mx.fast.layer_norm(self._mlp(x, name), self.p[f"{name}_layer_norm|scale"], self.p[f"{name}_layer_norm|offset"], 1e-5)

    @staticmethod
    def _segsum(e, idx, n, f32):
        x = e.astype(mx.float32) if f32 else e
        return mx.zeros((n, x.shape[1]), x.dtype).at[idx].add(x).astype(e.dtype)

    def step(self, grid_feats):
        """grid_feats (n_grid, C) normalised inputs+forcings -> (n_grid, n_out) normalised residuals."""
        dt = self.dtype; x = grid_feats.astype(dt)
        P = "grid2mesh_gnn/~_networks_builder/"
        g = mx.concatenate([x, self.g_feat], -1)
        m = mx.concatenate([mx.zeros((self.n_mesh, x.shape[1]), dt), self.m_feat], -1)
        g = self._mlp_ln(g, P + "encoder_nodes_grid_nodes"); m = self._mlp_ln(m, P + "encoder_nodes_mesh_nodes"); e = self._mlp_ln(self.g2m_e, P + "encoder_edges_grid2mesh")
        e_new = self._mlp_ln(mx.concatenate([e, g[self.g2m_s], m[self.g2m_r]], -1), P + "processor_edges_0_grid2mesh")
        agg = self._segsum(e_new, self.g2m_r, self.n_mesh, f32=True)                    # f32_aggregation=True in the encoder
        m = m + self._mlp_ln(mx.concatenate([m, agg], -1), P + "processor_nodes_0_mesh_nodes")
        g = g + self._mlp_ln(g, P + "processor_nodes_0_grid_nodes")
        mx.eval(g, m)
        P = "mesh_gnn/~_networks_builder/"
        e = self._mlp_ln(self.mesh_e, P + "encoder_edges_mesh")
        for k in range(self.mc["gnn_msg_steps"]):
            e_new = self._mlp_ln(mx.concatenate([e, m[self.mesh_s], m[self.mesh_r]], -1), P + f"processor_edges_{k}_mesh")
            agg = self._segsum(e_new, self.mesh_r, self.n_mesh, f32=False)
            m = m + self._mlp_ln(mx.concatenate([m, agg], -1), P + f"processor_nodes_{k}_mesh_nodes")
            e = e + e_new
            mx.eval(m, e)
        P = "mesh2grid_gnn/~_networks_builder/"
        e = self._mlp_ln(self.m2g_e, P + "encoder_edges_mesh2grid")
        e_new = self._mlp_ln(mx.concatenate([e, m[self.m2g_s], g[self.m2g_r]], -1), P + "processor_edges_0_mesh2grid")
        agg = self._segsum(e_new, self.m2g_r, self.n_grid, f32=False)
        g = g + self._mlp_ln(mx.concatenate([g, agg], -1), P + "processor_nodes_0_grid_nodes")
        out = self._mlp(g, P + "decoder_nodes_grid_nodes")
        mx.eval(out)
        return out


# ---- data: the package's own stacking, the normalisation in plain xarray ----
def load_stats(d=D):
    return (xr.load_dataset(f"{d}/mean_by_level.nc"), xr.load_dataset(f"{d}/stddev_by_level.nc"), xr.load_dataset(f"{d}/diffs_stddev_by_level.nc"))


def normalize(ds, mean, std):
    out = {}
    for name, da in ds.data_vars.items():
        if name in mean: da = da - mean[name].astype(da.dtype)
        if name in std: da = da / std[name].astype(da.dtype)
        out[name] = da
    return xr.Dataset(out)


def grid_features(norm_inputs, norm_forcings):
    """(n_grid, batch, channels) in the model's channel order (sorted names, time-major, then level)."""
    s = xr.concat([model_utils.dataset_to_stacked(norm_inputs), model_utils.dataset_to_stacked(norm_forcings)], dim="channels")
    s = model_utils.lat_lon_to_leading_axes(s)
    a = np.asarray(s.data, np.float32); return a.reshape((-1,) + a.shape[2:])


def outputs_to_dataset(out, template, grid_shape):
    a = np.asarray(out, np.float32).reshape(grid_shape + out.shape[1:])
    da = model_utils.restore_leading_axes(xr.DataArray(a, dims=("lat", "lon", "batch", "channels")))
    return model_utils.stacked_to_dataset(da.variable, template)


def extract(ds, tc, n_steps):
    return data_utils.extract_inputs_targets_forcings(
        ds, target_lead_times=slice(pd.Timedelta("6h"), pd.Timedelta(6 * n_steps, "h")),
        **{k: (tuple(v) if isinstance(v, list) else v) for k, v in tc.items()})


def predict(model, ds, n_steps, stats=None, verbose=False):
    """The rollout: ds is the package layout (batch 1, times = 2 inputs + n_steps targets). Returns the
    predictions dataset (batch, time, [level], lat, lon) for the n_steps lead times."""
    mean, std, dstd = stats or load_stats()
    inputs, targets, forcings = extract(ds, model.tc, n_steps)
    assert inputs.sizes.get("batch", 1) == 1, "one batch member at a time"
    grid_shape = (inputs.sizes["lat"], inputs.sizes["lon"])
    static = inputs[[v for v in inputs.data_vars if "time" not in inputs[v].dims]]
    cur = inputs; preds = []
    for k in range(n_steps):
        t0 = time.time()
        f_k = forcings.isel(time=[k]); tmpl = targets.isel(time=[k])
        feats = grid_features(normalize(cur, mean, std), normalize(f_k, mean, std))[:, 0]
        out = np.asarray(model.step(mx.array(feats)).astype(mx.float32))
        nrm = outputs_to_dataset(out[:, None], tmpl, grid_shape)
        pred = {}
        for name, da in nrm.data_vars.items():
            if name in cur: pred[name] = da * dstd[name].astype(da.dtype) + cur[name].isel(time=-1)
            else: pred[name] = da * std[name].astype(da.dtype) + mean[name].astype(da.dtype)
        pred = xr.Dataset(pred).transpose(*tmpl[list(pred)[0]].dims[:2], ...)
        preds.append(pred)
        nxt = xr.merge([pred, f_k], compat="override")
        tdep = [v for v in cur.data_vars if "time" in cur[v].dims]
        rolled = xr.concat([cur[tdep], nxt[tdep]], dim="time").tail(time=cur.sizes["time"]).assign_coords(time=cur.coords["time"])
        cur = xr.merge([static, rolled])
        if verbose: print(f"   step {k + 1}/{n_steps} (+{6 * (k + 1)} h) {time.time() - t0:.1f} s", flush=True)
    return xr.concat(preds, dim="time")


def load_model(d=D, dtype=mx.float32, grid_lat=None, grid_lon=None):
    npz = f"{d}/GraphCast_small_mlx.npz"
    if not os.path.exists(npz): convert_checkpoint(f"{d}/GraphCast_small.npz", npz)
    lat = np.arange(-90.0, 91.0, 1.0, np.float32) if grid_lat is None else grid_lat
    lon = np.arange(0.0, 360.0, 1.0, np.float32) if grid_lon is None else grid_lon
    return GraphCastMLX(npz, lat, lon, dtype=dtype)


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser(); ap.add_argument("dataset"); ap.add_argument("--steps", type=int, default=4); ap.add_argument("--bf16", action="store_true"); ap.add_argument("--out")
    a = ap.parse_args()
    ds = xr.load_dataset(a.dataset, decode_timedelta=True)
    model = load_model(dtype=mx.bfloat16 if a.bf16 else mx.float32, grid_lat=ds.lat.values, grid_lon=ds.lon.values)
    print(f"{model.description[:60]} | {model.n_params:,} params | grid {model.n_grid} mesh {model.n_mesh} | {mx.default_device()} {model.dtype}")
    t = time.time(); pred = predict(model, ds, a.steps, verbose=True); print(f"{a.steps} steps in {time.time() - t:.1f} s")
    if a.out: pred.to_netcdf(a.out); print("->", a.out)

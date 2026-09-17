"""The JAX/haiku GraphCast_small as the reference for the MLX port: one forward pass, float32 (no
Bfloat16Cast) or bfloat16 (the demo's construction), from the same dataset layout. Cached to netCDF
because a jitted CPU run costs a minute."""
import os, sys, functools, numpy as np, pandas as pd, xarray as xr
HERE = os.path.dirname(os.path.abspath(__file__)); D = os.path.join(HERE, "data")
sys.path.insert(0, "/Users/faezs/ARTIST-compliant/resources/xarray_jax")


def run(ds, n_steps, bf16, d=D):
    import jax, haiku as hk
    from weathernext.weathernext1_graph import graphcast
    from weathernext.utils import checkpoint, data_utils, rollout, normalization, autoregressive, casting
    with open(f"{d}/GraphCast_small.npz", "rb") as f: ckpt = checkpoint.load(f, graphcast.CheckPoint)
    params, model_config, task_config = ckpt.params, ckpt.model_config, ckpt.task_config
    stats = [xr.load_dataset(f"{d}/{n}.nc").compute() for n in ("diffs_stddev_by_level", "mean_by_level", "stddev_by_level")]
    tc = {k: getattr(task_config, k) for k in ("input_variables", "target_variables", "forcing_variables", "pressure_levels", "input_duration")}
    inputs, targets, forcings = data_utils.extract_inputs_targets_forcings(ds, target_lead_times=slice(pd.Timedelta("6h"), pd.Timedelta(6 * n_steps, "h")), **tc)
    def construct(model_config, task_config):
        p = graphcast.GraphCast(model_config, task_config)
        if bf16: p = casting.Bfloat16Cast(p)
        p = normalization.InputsAndResiduals(p, diffs_stddev_by_level=stats[0], mean_by_level=stats[1], stddev_by_level=stats[2])
        return autoregressive.Predictor(p, gradient_checkpointing=True)
    @hk.transform_with_state
    def fwd(model_config, task_config, inputs, targets_template, forcings):
        return construct(model_config, task_config)(inputs, targets_template=targets_template, forcings=forcings)
    f = jax.jit(functools.partial(fwd.apply, params=params, state={}, model_config=model_config, task_config=task_config))
    step = lambda **kw: f(**kw)[0]
    return rollout.chunked_prediction(step, rng=jax.random.PRNGKey(0), inputs=inputs, targets_template=targets * np.nan, forcings=forcings), targets


def cached(ds_path, n_steps, bf16, d=D):
    tag = os.path.basename(ds_path).replace(".nc", ""); p = f"{d}/ref_jax_{'bf16' if bf16 else 'f32'}_{tag}_{n_steps}steps.nc"
    if not os.path.exists(p):
        ds = xr.load_dataset(ds_path, decode_timedelta=True)
        pred, _ = run(ds, n_steps, bf16); pred.to_netcdf(p)
    return xr.load_dataset(p, decode_timedelta=True)


if __name__ == "__main__":
    ds_path, n, bf16 = sys.argv[1], int(sys.argv[2]), sys.argv[3] == "bf16"
    import time; t = time.time(); pred = cached(ds_path, n, bf16); print(f"reference {'bf16' if bf16 else 'f32'} {n} steps: {time.time() - t:.0f} s ->", pred.sizes)

"""Record one real dispatch of the handwritten kernels and write it out for Lean.

Instantiates the hashemi.ini env (gpu=1, a few agents), wraps its compiled Metal library so that
every kernel call is recorded - the buffers in binding order, their dtypes, the thread count - and
runs one deterministic trace. Writes scene/manifest.json and one float64 file per buffer, plus the
MSL source, so `lake exe trace_check` can replay the mount solve and the trace with the inputs a
theorem varies (pointing, blur, the site's azimuth) and read the outputs (per-ray weights, fates,
per-node power).
    python export_scene.py [--agents 16]
"""
import argparse
import configparser
import json
import os
import sys

import numpy as np
import torch

HERE = os.path.dirname(os.path.abspath(__file__))
CCC = os.path.dirname(HERE)
TUT = os.path.dirname(CCC)
ROOT = os.path.dirname(TUT)
for p in (ROOT, TUT):
    if p not in sys.path:
        sys.path.insert(0, p)


def ini_env_kwargs(path):
    cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#"))
    cp.read(path)
    kw = {}
    for k, v in cp["env"].items():
        v = v.strip()
        if k in ("num_agents",):
            continue
        try:
            kw[k] = int(v)
        except ValueError:
            try:
                kw[k] = float(v)
            except ValueError:
                kw[k] = v
    return kw


class Recorder:
    """wraps the compiled library: records each kernel call's tensors (binding order) and forwards it"""

    def __init__(self, lib, out_dir):
        self._lib = lib
        self.out_dir = out_dir
        self.calls = []

    def __getattr__(self, name):
        real = getattr(self._lib, name)

        def call(*tensors, **kw):
            rec = dict(kernel=name, buffers=[], grid=int(tensors[0].numel()))
            for i, t in enumerate(tensors):
                t = t.contiguous()
                kind = 1 if t.dtype in (torch.int32, torch.int64) else 0
                arr = t.detach().cpu().numpy().astype(np.float64).reshape(-1)
                fn = f"{name}_{len(self.calls)}_{i}.f64"
                arr.tofile(os.path.join(self.out_dir, fn))
                rec["buffers"].append(dict(index=i, file=fn, n=int(arr.size), kind=kind, shape=list(t.shape)))
            real(*tensors, **kw)
            # the outputs after the call, for the replay's reference
            for i, t in enumerate(tensors):
                arr = t.detach().cpu().numpy().astype(np.float64).reshape(-1)
                arr.tofile(os.path.join(self.out_dir, f"{name}_{len(self.calls)}_{i}_after.f64"))
            self.calls.append(rec)
        return call


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--agents", type=int, default=16)
    ap.add_argument("--hour", type=float, default=10.0)
    ap.add_argument("--day", type=int, default=172)
    args = ap.parse_args()
    from tandoor_hashemi_env import TandoorHashemiEnv
    import tandoor_metal_kernel as TMK
    kw = ini_env_kwargs(os.path.join(TUT, "puffer_tandoor", "hashemi.ini"))
    kw["day_random"] = 0
    kw["lat_random"] = 0
    env = TandoorHashemiEnv(num_agents=args.agents, lat=30.2, day_of_year=args.day, **kw)
    env.reset()
    env.t_solar[:] = args.hour
    B = args.agents
    out_dir = os.path.join(HERE, "scene")
    for f in os.listdir(out_dir):
        os.remove(os.path.join(out_dir, f))
    with open(os.path.join(out_dir, "tandoor.metal"), "w") as f:
        f.write(TMK.MSL)
    # the trace at the sun (pnt = the sun's own el/az: the tracked machine), deterministic rays but
    # WITH the blur draws, drawn once here so the blur theorems can be replayed with the same draws
    import tandoor_rl_env as _base
    el0, az0, _ = _base._sim.solar_position(env.lat, env.day, args.hour)
    env.el_m[:] = el0
    env.az_m[:] = np.degrees(az0 - env._ds_azs)
    env._e_el[:] = 0.0
    env._e_az[:] = 0.0
    env.el_dish_deg = lambda el_m, wind: np.asarray(el_m, dtype=np.float64)   # the dish AT the sun, no drum sag
    env._det_trace = False
    env._gen = torch.Generator(device=env.device); env._gen.manual_seed(7)
    rec = Recorder(env._metal.lib, out_dir)
    env._metal.lib = rec
    # the mount solve through the Metal kernel too (the env's numpy path solves it in torch): the
    # replay varies the pointing through it - same day/lat/hour, pnt = the dish's (el, az) in degrees
    dev = env.device
    day_t = torch.as_tensor(env.day_v, dtype=torch.float32, device=dev)
    lat_t = torch.as_tensor(env.lat_v, dtype=torch.float32, device=dev)
    pnt = torch.as_tensor(np.stack([np.full(B, el0), np.degrees(az0 - env._ds_azs)], 1), dtype=torch.float32, device=dev)
    env._mount(day_t, lat_t, args.hour, pnt=pnt)
    p_eff = np.full(B, float(env.p0))          # the nominal pressure: the design level (the film is unpumped at reset)
    sigma_b = np.full(B, 2.0e-3)
    with torch.no_grad():
        per = env._trace_power(p_eff, sigma_b, env.bore, env.soil)
    env._metal.lib = rec._lib
    manifest = dict(agents=B, rays=int(env._ray_pw.numel()) if hasattr(env, "_ray_pw") else None,
                    hour=args.hour, day=args.day, lat=env.lat, sun_el_deg=float(el0), sun_az_rad=float(az0),
                    site_az_rad=float(np.mean(env._ds_azs)), n_nodes=int(env.n_nodes), n_belt=int(env.n_belt),
                    f_design=float(env._fct[0, 53]), power_W=float(per.sum(1).mean()),
                    ds_azs_col=75, calls=rec.calls)
    with open(os.path.join(out_dir, "manifest.json"), "w") as f:
        json.dump(manifest, f, indent=1)
    print("recorded", [(c["kernel"], len(c["buffers"]), c["grid"]) for c in rec.calls])
    print(f"sun el {el0:.2f} deg az {np.degrees(az0):.2f}; power {manifest['power_W']:.1f} W/agent; wrote {len(os.listdir(out_dir))} files")
    # torch's own thread-count convention, for the replay
    try:
        print("torch kernel call doc:", (type(rec._lib.tandoor_trace).__call__.__doc__ or "")[:300].replace("\n", " "))
    except Exception as e:
        print("no doc:", e)


if __name__ == "__main__":
    main()

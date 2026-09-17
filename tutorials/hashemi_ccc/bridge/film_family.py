"""The rim-shaping control as a NURBS family the trace can consume.

The film's own solve (03_membrane_beamdown_tandoor.solve_membrane) takes a per-zone pressure
vector: the membrane as a K-DOF adaptive mirror. Each control here is such a vector - the env's
zoned law p (1 - zc (r/a)^2) for several zc, and a rim zone pressed harder or softer - re-bisected
in overall pressure so the fitted focal length stays the design's (the strip and M4 are built for
it), solved, fitted into ARTIST NURBS control points warm-started from the working level (the
env's own representation: the surface and its normal from one spline), and evaluated at the env's
own aperture samples. Written as float64 rows per control into family/, with a manifest, so
`lake exe trace_check` replays the tri train with each shape.
    python film_family.py [--epochs 600]
"""
import argparse
import json
import os
import sys
import time

import numpy as np
import torch

HERE = os.path.dirname(os.path.abspath(__file__))
CCC = os.path.dirname(HERE)
TUT = os.path.dirname(CCC)
ROOT = os.path.dirname(TUT)
for p in (ROOT, TUT):
    if p not in sys.path:
        sys.path.insert(0, p)
from export_scene import ini_env_kwargs   # noqa: E402


def conic_fit(x, y, z):
    r = np.hypot(x, y)
    best = None
    for k in np.linspace(-1.3, 0.3, 65):
        for c in np.linspace(0.08, 0.2, 121):
            model = c * r**2 / (1 + np.sqrt(np.maximum(1 - (1 + k) * c**2 * r**2, 0)))
            z0 = (z - model).mean()
            rms = np.sqrt(((z - model - z0)**2).mean())
            if best is None or rms < best[0]:
                best = (rms, c, k)
    return best


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--agents", type=int, default=16)
    ap.add_argument("--epochs", type=int, default=600)
    args = ap.parse_args()
    from tandoor_hashemi_env import TandoorHashemiEnv
    import tandoor_rl_env as _base
    from artist.util.nurbs import NURBSSurface
    _sim = _base._sim
    kw = ini_env_kwargs(os.path.join(TUT, "puffer_tandoor", "hashemi.ini"))
    kw["day_random"] = 0; kw["lat_random"] = 0
    env = TandoorHashemiEnv(num_agents=args.agents, lat=30.2, day_of_year=172, **kw)
    cfg = env.cfg
    a = float(cfg.a)
    K = int(getattr(env, "n_zones", 1) or 1)
    edges = np.linspace(0.0, a, K + 1)
    rc = 0.5 * (edges[:-1] + edges[1:])
    f_design = float(env.f_nom)
    dev = env.device
    mem = env.primary.membrane
    ctrl0 = mem.ctrl[4].detach().clone().to(_sim.DEVICE)        # the working level's control points, on the fitter's device
    u = torch.as_tensor(env._hx / (2 * a) + 0.5, dtype=torch.float32).clamp(1e-5, 1 - 1e-5).to(dev)
    v = torch.as_tensor(env._hy / (2 * a) + 0.5, dtype=torch.float32).clamp(1e-5, 1 - 1e-5).to(dev)
    print(f"zones {K}, a {a}, f_design {f_design:.3f}, p0 {env.p0:.1f}, ctrl {tuple(ctrl0.shape)}, aperture {len(env._hx)} samples")

    def solve_shape(shape):
        """bisect the overall pressure so the fitted focal length is the design's, for a zone shape"""
        lo, hi = cfg.T_pre / (4 * f_design), cfg.T_pre / (0.25 * f_design) * 3.0
        for _ in range(24):
            mid = 0.5 * (lo + hi)
            m = _sim.solve_membrane(cfg, mid * shape, n=400, zone_edges=edges)
            if m["z0"] + m["f_fit"] > f_design:
                lo = mid
            else:
                hi = mid
        p = 0.5 * (lo + hi)
        return p, _sim.solve_membrane(cfg, p * shape, n=400, zone_edges=edges)

    controls = []
    for zc in (0.0, 0.2, 0.4, 0.6, 0.8):
        controls.append((f"zc_{zc:.1f}", 1.0 - zc * (rc / a) ** 2))
    base = 1.0 - 0.4 * (rc / a) ** 2                              # the env's own law (zone_c 0.4)
    for rim in (0.6, 1.4):
        sh = base.copy(); sh[-1] *= rim
        controls.append((f"rim_x{rim:.1f}", sh))
    sh = base.copy(); sh[-2] *= 1.4; sh[-1] *= 0.6                # a ring pressed in one zone short of the rim
    controls.append(("ring_in", sh))
    manifest = dict(agents=args.agents, aperture=len(env._hx), f_design=f_design, zones=K, edges=edges.tolist(),
                    p0=float(env.p0), controls=[])
    for name, shape in controls:
        t0 = time.time()
        p, m = solve_shape(shape)
        ctrl, _ = _sim.fit_nurbs(cfg, m, ctrl_init=ctrl0, epochs=args.epochs, log_name=f"nurbs {name}")
        surf = NURBSSurface(3, 3, u, v, ctrl.to(dev), device=dev)
        pts, nrm = surf.calculate_surface_points_and_normals(device=dev)
        pts = pts[:, :3].detach().cpu().numpy().astype(np.float64)
        nrm = nrm[:, :3].detach().cpu().numpy().astype(np.float64)
        rms, c, k = conic_fit(pts[:, 0], pts[:, 1], pts[:, 2])
        pts.tofile(os.path.join(HERE, "family", f"{name}_pts.f64"))
        nrm.tofile(os.path.join(HERE, "family", f"{name}_nrm.f64"))
        rec = dict(name=name, shape=[float(x) for x in shape], p=float(p), f_fit=float(m["z0"] + m["f_fit"]), w0=float(m["w0"]),
                   conic_c=float(c), conic_k=float(k), conic_rms_mm=float(1e3 * rms),
                   pts=f"{name}_pts.f64", nrm=f"{name}_nrm.f64", seconds=time.time() - t0)
        manifest["controls"].append(rec)
        print(f"  {name:10s} p {p:8.1f} Pa  f_fit {rec['f_fit']:.3f}  w0 {rec['w0']:.4f}  conic c {c:.4f} k {k:+.3f} rms {1e3 * rms:.3f} mm  ({rec['seconds']:.0f} s)")
        with open(os.path.join(HERE, "family", "manifest.json"), "w") as f:
            json.dump(manifest, f, indent=1)
    print("FAMILY DONE")


if __name__ == "__main__":
    main()

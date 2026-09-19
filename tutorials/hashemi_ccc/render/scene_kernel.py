"""The scene as a Metal kernel, and the FFI that runs it.

The rays come from the megakernel.  `render/scene_<name>.metal` is printed by
`RequestProject/CccScene.lean`'s `printMslScene` from the same hash-consed graph as
`scene_<name>.h` (C) and `scene_<name>.py` (NumPy): one threadgroup per frame, one thread per
ray, the agent level computed once on thread 0 and broadcast through threadgroup memory, each
thread writing its own ray's vertices and thread 0 the static ones.  `SceneMetal` compiles and
dispatches it exactly as `HashemiEnvMetal` does the env's step, and the draws are generated on
the device by torch — there is no CSV of rays anywhere.

    .venv/bin/python scene_kernel.py        # Metal == NumPy == C for the three scenes
"""
import json
import os
import subprocess
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
PARENT = os.path.dirname(HERE)
for p in (HERE, PARENT):
    if p not in sys.path:
        sys.path.insert(0, p)

from hashemi_kernel import MSL_PRELUDE                                  # noqa: E402

SCENES = ["hashemi", "beam", "optic"]


def manifest(name):
    return json.load(open(os.path.join(HERE, "scene_%s.json" % name)))


def scene_source(name):
    with open(os.path.join(HERE, "scene_%s.metal" % name)) as fh:
        return MSL_PRELUDE + fh.read()


def draws(rng, B, P=64, m=10):
    """the ray table, exactly as the env kernel's: six uniforms then four normals per ray"""
    return np.concatenate([rng.random((B, P, 6)), rng.standard_normal((B, P, m - 6))], axis=2)


def device_draws(torch, B, seed, P=64, m=10):
    """the SAME table, generated on the device: a seeded torch generator on mps.

    The viewer and the env both take their draws this way; the check seeds it so that the
    comparison is reproducible without a file."""
    g = torch.Generator(device="mps")
    g.manual_seed(int(seed))
    u = torch.rand((B, P, 6), generator=g, device="mps", dtype=torch.float32)
    n = torch.randn((B, P, m - 6), generator=g, device="mps", dtype=torch.float32)
    return torch.cat([u, n], dim=2)


class SceneMetal:
    """one printed scene kernel, compiled and dispatched like the env's megakernel"""

    def __init__(self, name):
        import torch
        self.torch = torch
        self.name = name
        self.man = manifest(name)
        self.kernel = self.man["kernel"]
        self.inputs = self.man["inputs"]
        self.n_in = len(self.inputs)
        self.n_static = int(self.man["n_static"])
        self.n_ray = int(self.man["n_ray"])
        self.P = int(self.man["rays"])
        self.arrays = self.man["arrays"]
        self.lib = torch.mps.compile_shader(scene_source(name))
        self.fn = getattr(self.lib, self.kernel)
        self._buf = {}

    def index(self, name):
        return self.inputs.index(name)

    def row(self, values, B=1):
        """the (B, n_in) input row from a dict of named values (missing ones are 0)"""
        x = np.zeros((B, self.n_in), dtype=np.float32)
        for k, v in values.items():
            if k in self.inputs:
                x[:, self.inputs.index(k)] = v
        return x

    def __call__(self, x, dr):
        """x (B, n_in) and dr (B, P, m) on mps -> (vs (B, n_static), vr (B, P, n_ray))"""
        torch = self.torch
        B = x.shape[0]
        bufs = self._buf.get(B)
        if bufs is None:
            bufs = (torch.empty(B, max(self.n_static, 1), dtype=torch.float32, device="mps"),
                    torch.empty(B, self.P, max(self.n_ray, 1), dtype=torch.float32, device="mps"),
                    torch.tensor([B], dtype=torch.int32, device="mps"))
            self._buf[B] = bufs
        vs, vr, nB = bufs
        self.fn(x.contiguous(), dr.contiguous(), vs, vr, nB, threads=B * self.P, group_size=self.P)
        return vs, vr


def scene_numpy(name, x, dr):
    """the NumPy twin of the same graph: x (B, n_in), dr (B, P, m) -> (vs, vr)"""
    mod = __import__("scene_%s" % name)
    man = manifest(name)
    fn = getattr(mod, man["c"])
    with np.errstate(all="ignore"):
        return fn(*[np.asarray(x[:, k], dtype=float) for k in range(x.shape[1])],
                  np.asarray(dr, dtype=float))


def scene_c(name, x, dr, exe=None):
    """the C twin, through `hashemi_frame --scene <name> --eval` (one row per line)"""
    exe = exe or os.path.join(HERE, "hashemi_frame")
    lines = []
    for b in range(x.shape[0]):
        lines.append(",".join("%.17g" % v for v in x[b]) + ";" +
                     ",".join("%.17g" % v for v in np.asarray(dr[b], dtype=float).ravel()))
    out = subprocess.run([exe, "--scene", name, "--eval"], input="\n".join(lines) + "\n",
                         capture_output=True, text=True, cwd=HERE)
    if out.returncode:
        raise RuntimeError(out.stderr)
    man = manifest(name)
    ns, nr, P = int(man["n_static"]), int(man["n_ray"]), int(man["rays"])
    rows = [ln for ln in out.stdout.strip().split("\n") if ln]
    vs = np.zeros((len(rows), ns))
    vr = np.zeros((len(rows), P, nr))
    for b, ln in enumerate(rows):
        v = np.array([float(t) for t in ln.split(",")])
        vs[b] = v[:ns]
        vr[b] = v[ns:].reshape(P, nr)
    return vs, vr


def sample(name, rng):
    """a plausible value for a scene input, by name: angles small, lengths metres"""
    if name in ("az", "azSun"):
        return rng.uniform(0, 2 * np.pi)
    if name in ("t", "beta"):
        return rng.uniform(0.05, 1.2)
    if name == "elSun":
        return rng.uniform(0.1, 1.4)
    if name in ("sgL", "sgR"):
        return 1.0 if name == "sgL" else -1.0
    if name in ("lat",):
        return rng.uniform(-60, 60)
    if name == "doy":
        return float(rng.integers(1, 366))
    if name == "hour":
        return rng.uniform(6, 18)
    if name in ("R",):
        return rng.uniform(4.0, 6.0)
    if name in ("f", "apexH", "zBolt", "zBar", "ym", "a", "ze", "dnut", "L"):
        return rng.uniform(0.5, 3.5)
    if name in ("k",):
        return rng.uniform(-1.0, 0.0)
    if name == "hsun":
        return 4.65e-3
    if name in ("w", "rc", "rm", "rt", "slotW", "dm", "sigmaslope", "sigmaspec", "hp"):
        return rng.uniform(0.02, 0.3)
    return rng.uniform(-1.0, 1.0)


def random_inputs(name, rng, B):
    man = manifest(name)
    return np.array([[sample(v, rng) for v in man["inputs"]] for _ in range(B)], dtype=np.float64)


def _rel(a, b):
    fin = np.isfinite(a) & np.isfinite(b)
    if not fin.any():
        return 0.0
    return float(np.max(np.abs(a[fin] - b[fin]) / np.maximum(1.0, np.abs(b[fin]))))


def main():
    import torch
    rng = np.random.default_rng(20260919)
    B = 8
    have_c = os.path.exists(os.path.join(HERE, "hashemi_frame"))
    ok = True
    for name in SCENES:
        man = manifest(name)
        x = random_inputs(name, rng, B)
        dr = draws(rng, B, int(man["rays"]), int(man["arrays"][0]["m"]))
        k = SceneMetal(name)
        xt = torch.as_tensor(x.astype(np.float32), device="mps")
        drt = torch.as_tensor(dr.astype(np.float32), device="mps")
        vs, vr = k(xt, drt)
        vs, vr = vs.cpu().numpy()[:, :k.n_static], vr.cpu().numpy()[:, :, :k.n_ray]
        rs, rr = scene_numpy(name, x, dr)
        d_static = _rel(vs, rs) if k.n_static else 0.0
        d_ray = _rel(vr, rr)
        line = ("  %-8s %2d entries  %3d static + %d x %-3d ray   Metal vs NumPy %.2e / %.2e"
                % (name, len(man["entries"]), k.n_static, k.P, k.n_ray, d_static, d_ray))
        if have_c:
            cs, cr = scene_c(name, x, dr)
            c_static = _rel(cs, rs) if k.n_static else 0.0
            c_ray = _rel(cr, rr)
            line += "   C vs NumPy %.2e / %.2e" % (c_static, c_ray)
            ok = ok and max(c_static, c_ray) <= 1e-9
        ok = ok and max(d_static, d_ray) <= 2e-3
        print(line)
    print("METAL == NUMPY == C over the three scenes" if ok else "MISMATCH")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())

"""Kernels as derivations: the runner, after Nix.

A kernel run is a DERIVATION: sources (hashed), a builder, inputs (other derivations' outputs or
literal buffers), outputs; realising it walks the phases a Nix derivation walks - `unpack`
(read the sources), `configure` (the buffer layout from the manifest Ccc wrote), `build` (compile
the Metal library, keyed by the hash of everything that went in), `check` (the twin: Metal
against NumPy on the same inputs), `install` (the outputs into a content-addressed store). A
derivation whose inputs are unchanged is not rebuilt: its store path already exists. Composition
is by reference: the env's step depends on the header the Lean driver wrote, which depends on
the Lean sources; the store path of a result carries the hash of the whole chain.

The categorical shape is the same as Ccc's: independent derivations are tensored (they realise
in any order), dependent ones compose (an output is the next one's input). Ccc composes the
PHYSICS into one kernel; the derivation composes the BUILD around it.

    .venv/bin/python bridge/derivation.py      # realise the env kernel's derivation, twice
"""
import hashlib
import json
import os
import subprocess
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
CCC = os.path.dirname(HERE)
STORE = os.path.join(HERE, "store")
for _p in (CCC,):
    if _p not in sys.path:
        sys.path.insert(0, _p)


def sha(*parts):
    h = hashlib.sha256()
    for p in parts:
        if isinstance(p, bytes):
            h.update(p)
        elif isinstance(p, np.ndarray):
            h.update(np.ascontiguousarray(p).tobytes())
        else:
            h.update(str(p).encode())
        h.update(b"\0")
    return h.hexdigest()[:16]


class Derivation:
    """name; srcs: files whose content is hashed; inputs: {name: Derivation | np.ndarray | scalar};
    phases: functions of the derivation, run in order; each returns a dict merged into `env`"""

    def __init__(self, name, srcs=(), inputs=None, phases=None, meta=None):
        self.name = name
        self.srcs = list(srcs)
        self.inputs = dict(inputs or {})
        self.phases = list(phases or [])
        self.meta = dict(meta or {})
        self.env = {}
        self.out_path = None

    # ---- the hash: sources, literal inputs, and the hashes of the input derivations
    def drv_hash(self):
        parts = [self.name, json.dumps(self.meta, sort_keys=True)]
        for s in self.srcs:
            with open(s, "rb") as f:
                parts.append(f.read())
        for k in sorted(self.inputs):
            v = self.inputs[k]
            parts.append(k)
            parts.append(v.drv_hash() if isinstance(v, Derivation) else v)
        return sha(*parts)

    def store_path(self):
        return os.path.join(STORE, f"{self.drv_hash()}-{self.name}")

    def realise(self, log=print, force=False):
        """realise the inputs, then this one; a store path that exists is reused"""
        for k, v in self.inputs.items():
            if isinstance(v, Derivation):
                v.realise(log=log, force=force)
        self.out_path = self.store_path()
        if os.path.isdir(self.out_path) and not force and os.path.exists(os.path.join(self.out_path, "outputs.npz")):
            self.env = dict(np.load(os.path.join(self.out_path, "outputs.npz"), allow_pickle=True))
            log(f"  [{self.name}] cached  {os.path.basename(self.out_path)}")
            return self
        os.makedirs(self.out_path, exist_ok=True)
        t0 = time.time()
        for phase in self.phases:
            got = phase(self) or {}
            self.env.update(got)
            log(f"  [{self.name}] {phase.__name__:<10} {time.time() - t0:6.2f} s")
        np.savez(os.path.join(self.out_path, "outputs.npz"), **{k: v for k, v in self.env.items() if isinstance(v, (np.ndarray, float, int, str))})
        with open(os.path.join(self.out_path, "drv.json"), "w") as f:
            json.dump(dict(name=self.name, hash=self.drv_hash(), srcs=self.srcs, meta=self.meta,
                           inputs={k: (v.drv_hash() if isinstance(v, Derivation) else "literal") for k, v in self.inputs.items()}), f, indent=1)
        return self

    def output(self, key):
        return self.env[key]


# ---------------------------------------------------------------------------- the env kernel's derivation
def lean_sources():
    """the Lean the driver compiles: the chain's inputs"""
    lean = os.path.join(CCC, "lean")
    return [os.path.join(lean, f) for f in ("Ccc.lean", "Hashemi.lean", "HashemiStep.lean", "HashemiMega.lean",
                                            "HashemiTrace.lean", "HashemiHeat.lean", "HashemiEnv.lean", "HashemiCcc.lean")]


def header_derivation():
    """the header + kernels the driver wrote: a derivation whose builder is `lake build HashemiCcc`.
    Realised here by checking the outputs exist and are newer than the sources (the build is the
    Lean driver's, run by the chain); the hash is the sources'"""
    def unpack(d):
        return dict(sources=np.array(d.srcs))

    def build(d):
        outs = [os.path.join(CCC, f) for f in ("hashemi_ccc.h", "hashemi_env.metal", "hashemi_env.json", "hashemi_ccc.py")]
        missing = [o for o in outs if not os.path.exists(o)]
        if missing:
            raise FileNotFoundError(f"the driver's outputs are missing: {missing} (run `lake build RequestProject.HashemiCcc`)")
        newest_src = max(os.path.getmtime(s) for s in d.srcs)
        stale = [o for o in outs if os.path.getmtime(o) < newest_src]
        return dict(header=outs[0], metal=outs[1], manifest=outs[2], twin=outs[3], stale=np.array(stale))

    return Derivation("hashemi-ccc-header", srcs=lean_sources(), phases=[unpack, build])


def env_kernel_derivation(header, B=1024, seed=0):
    """the env's step: configure the layout from the manifest, build the Metal library (cached by
    the source hash), check Metal against the NumPy twin on seeded inputs, install the outputs"""
    def unpack(d):
        with open(d.inputs["header"].output("metal") if False else os.path.join(CCC, "hashemi_env.metal")) as f:
            return dict(metal_bytes=len(f.read()))

    def configure(d):
        m = json.load(open(os.path.join(CCC, "hashemi_env.json")))
        return dict(n_in=len(m["inputs"]), n_out=m["n_columns"], rays=m["rays"], columns=np.array(m["columns"]))

    def build(d):
        from hashemi_env_kernel import HashemiEnvMetal
        t0 = time.time()
        d.env["kernel"] = HashemiEnvMetal()
        return dict(compile_s=time.time() - t0)

    def check(d):
        import torch
        from hashemi_env_kernel import pack, draws, env_numpy, ECOL
        rng = np.random.default_rng(seed)
        state = np.stack([rng.uniform(0, 2 * np.pi, B), rng.uniform(0, 1.07, B), np.zeros(B)], 1)
        cmd = np.stack([rng.uniform(-2, 2, B), rng.uniform(-0.5, 0.5, B)], 1)
        el = np.clip(np.pi / 2 - state[:, 1] + rng.uniform(-0.05, 0.05, B), 0.05, 1.5)
        sun = np.stack([el, state[:, 0] + rng.uniform(-0.05, 0.05, B), rng.uniform(300, 1000, B)], 1)
        x = pack(B, state, cmd, 15.0, sun, rng.uniform(0.8, 1, B), rng.uniform(300, 550, B), rng.uniform(300, 500, B), 300.0)
        dr = draws(rng, B)
        ref = env_numpy(x, dr)
        out = d.env["kernel"].step(torch.as_tensor(x.astype(np.float32), device="mps"),
                                   torch.as_tensor(dr.astype(np.float32), device="mps")).cpu().numpy().astype(np.float64)
        err = np.nanmax(np.abs(out - ref) / np.maximum(1.0, np.abs(ref)), axis=0)
        if np.any(err > 1e-2):
            raise AssertionError(f"Metal != NumPy: {dict(zip(d.env['columns'], err))}")
        return dict(max_rel_err=float(err.max()), capture_mean=float(out[:, ECOL["capture"]].mean()), rows=out)

    def install(d):
        return dict(installed=1)

    return Derivation("hashemi-env-kernel", srcs=[os.path.join(CCC, "hashemi_env.metal"), os.path.join(CCC, "hashemi_ccc.h")],
                      inputs=dict(header=header), phases=[unpack, configure, build, check, install], meta=dict(B=B, seed=seed))


if __name__ == "__main__":
    hdr = header_derivation()
    drv = env_kernel_derivation(hdr)
    print("realising", drv.name, drv.drv_hash())
    drv.realise()
    print(f"  store: {os.path.relpath(drv.out_path, CCC)}; Metal vs NumPy max rel err {drv.output('max_rel_err'):.2e}; capture mean {drv.output('capture_mean'):.3f}")
    print("realising again (unchanged inputs):")
    drv2 = env_kernel_derivation(hdr)
    drv2.realise()
    print("  same store path:", drv2.out_path == drv.out_path)

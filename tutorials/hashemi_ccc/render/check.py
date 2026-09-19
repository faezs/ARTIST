#!/usr/bin/env python
"""The headless acceptance of the scene printer.

Two things, neither of which knows any geometry:

1. **the scenes**, C against the NumPy twin against the Metal kernel.  All three are
   printed from the SAME hash-consed graph by `RequestProject/Ccc.lean`'s own printers
   (`printSceneC`, `printNumpyScene`, `printMslScene`), so a difference is a bug in one printer,
   not in the model.  The rays are the megakernel's table, generated here and handed to all
   three; there is no file of rays.  C and NumPy are double and agree to the last bit; the Metal
   kernel is float32 and is held to 2e-3 relative.
2. **the sun**, `hk_sceneSunAt` (the spec's `sunAt`) against the trainer's own
   `tandoor_rl_env._sim.solar_position`, at 20 random instants, to 1e-3 rad.  The spec's wins:
   any difference is reported, not patched.

    make check
"""
import os
import subprocess
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
sys.path.insert(0, os.path.dirname(os.path.dirname(HERE)))

import scene_kernel                                            # noqa: E402

EXE = os.path.join(HERE, "hashemi_frame")
SUN_TOL = 1e-3


def check_sun(rng, n=20):
    try:
        from tandoor_rl_env import _sim
    except Exception as exc:                                   # pragma: no cover
        print("  sun: the trainer's solar_position is not importable (%s)" % exc)
        return None, None
    lats = rng.uniform(-55, 55, n)
    doys = rng.integers(1, 366, n).astype(float)
    hours = rng.uniform(6.5, 17.5, n)
    stdin = "".join("%.17g,%.17g,%.17g\n" % (a, b, c) for a, b, c in zip(lats, doys, hours))
    out = subprocess.run([EXE, "--sun"], input=stdin, capture_output=True, text=True, cwd=HERE)
    got = np.array([[float(v) for v in ln.split(",")] for ln in out.stdout.strip().split("\n")])
    ref = np.array([[np.radians(_sim.solar_position(a, b, c)[0]),
                     _sim.solar_position(a, b, c)[1]] for a, b, c in zip(lats, doys, hours)])
    del_ = np.abs(got[:, 0] - ref[:, 0]).max()
    daz = np.abs((got[:, 1] - ref[:, 1] + np.pi) % (2 * np.pi) - np.pi).max()
    print("  sun      %d instants   |del el| = %.3e rad   |del az| = %.3e rad   %s"
          % (n, del_, daz, "ok" if max(del_, daz) <= SUN_TOL else "FAIL"))
    return del_, daz


def main():
    rng = np.random.default_rng(20260919)
    print("the scenes: C == NumPy == Metal, over the megakernel's own ray table")
    ok = scene_kernel.main() == 0
    print("the sun, against the trainer (tol %.0e rad):" % SUN_TOL)
    de, da = check_sun(rng)
    if de is not None:
        ok = ok and max(de, da) <= SUN_TOL
    print("CHECK", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())

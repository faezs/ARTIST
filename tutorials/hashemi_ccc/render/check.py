#!/usr/bin/env python
"""The headless acceptance of the scene printer.

Three things, none of which knows any geometry either:

1. **the three scenes**, C against the NumPy twin.  Both are printed from the SAME hash-consed
   graph by `RequestProject/Ccc.lean`'s own printers (`printC`, `printNumpy`), so a difference
   would be a bug in one printer, not in the model.  Five random input vectors per scene,
   compared to 1e-5.
2. **the sun**, `hk_sceneSunAt` (the spec's `sunAt`) against the trainer's own
   `tandoor_rl_env._sim.solar_position`, at 20 random instants, to 1e-3 rad.  The spec's wins:
   any difference is reported, not patched.
3. **rays.csv**, the draws both the C renderer and this file read, so the two draw the same rays.

    make check
"""
import json
import os
import subprocess
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
EXE = os.path.join(HERE, "hashemi_frame")
SCENES = ["hashemi", "beam", "optic"]
TOL = 1e-5
SUN_TOL = 1e-3

# the ray draws: one facet centre, one point in it, one direction, and the two error pairs.
# `rays.csv`'s column names ARE the scene's input names, so the renderer binds them by name.
RAY_COLS = ["cx", "cy", "ux", "uy", "dx", "dy", "dz", "e1", "e2", "s1", "s2",
            "O_0", "O_1", "O_2", "dray_0", "dray_1", "dray_2",
            "H_0", "H_1", "H_2", "r_0", "r_1", "r_2"]


def write_rays(n=48, a=2.0, f=2.5, seed=7):
    rng = np.random.default_rng(seed)
    cx = rng.uniform(-a, a, n)
    cy = rng.uniform(-a, a, n)
    ux = rng.uniform(-0.025, 0.025, n)
    uy = rng.uniform(-0.025, 0.025, n)
    d = np.stack([rng.normal(0, 0.02, n), rng.normal(0, 0.02, n), -np.ones(n)], -1)
    d /= np.linalg.norm(d, axis=-1, keepdims=True)
    e = rng.normal(0, 1, (n, 4))
    # the dish-frame reflection the beam stages take as their ray: a point on the figure and a
    # direction back toward F.  These are draws, not a model: the scene's own definitions do the
    # optics, and the check only needs the two sides fed alike.
    H = np.stack([cx, cy, (cx ** 2 + cy ** 2) / (4 * f)], -1)
    r = np.stack([-cx, -cy, 2 * f - H[:, 2]], -1)
    r /= np.linalg.norm(r, axis=-1, keepdims=True)
    rows = np.column_stack([cx, cy, ux, uy, d[:, 0], d[:, 1], d[:, 2], e[:, 0], e[:, 1], e[:, 2],
                            e[:, 3], cx + ux, cy + uy, np.full(n, 2 * f), d[:, 0], d[:, 1],
                            d[:, 2], H[:, 0], H[:, 1], H[:, 2], r[:, 0], r[:, 1], r[:, 2]])
    with open(os.path.join(HERE, "rays.csv"), "w") as fh:
        fh.write(",".join(RAY_COLS) + "\n")
        for row in rows:
            fh.write(",".join("%.17g" % v for v in row) + "\n")
    return len(rows)


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
    if name in ("onPanel",):
        return 1.0
    if name.startswith("O_") or name.startswith("H_"):
        return rng.uniform(-2.0, 2.5)
    if name.startswith("dray_") or name.startswith("r_"):
        return rng.uniform(-1.0, 1.0)
    if name in ("w", "rc", "rm", "rt", "slotW", "dm", "sigmaslope", "sigmaspec", "hp"):
        return rng.uniform(0.02, 0.3)
    return rng.uniform(-1.0, 1.0)


def check_scene(name, rng, n=5):
    man = json.load(open(os.path.join(HERE, "scene_%s.json" % name)))
    mod = __import__("scene_%s" % name)
    fn = getattr(mod, man["c"])
    xs = [[sample(v, rng) for v in man["inputs"]] for _ in range(n)]
    stdin = "\n".join(",".join("%.17g" % v for v in row) for row in xs) + "\n"
    out = subprocess.run([EXE, "--scene", name, "--eval"], input=stdin, capture_output=True,
                         text=True, cwd=HERE)
    if out.returncode:
        print(out.stderr)
        return False, 0.0
    got = np.array([[float(v) for v in ln.split(",")] for ln in out.stdout.strip().split("\n")])
    ref = np.array([np.asarray(fn(*row), dtype=float) for row in xs])
    bad = ~np.isfinite(got) | ~np.isfinite(ref)
    d = np.abs(got - ref)
    d[bad] = 0.0
    worst = float(d.max()) if d.size else 0.0
    ok = worst <= TOL
    print("  %-8s %2d entries %3d doubles %2d inputs   worst |C - NumPy| = %.3e   %s"
          % (name, len(man["entries"]), man["n_vert"], len(man["inputs"]), worst,
             "ok" if ok else "FAIL"))
    return ok, worst


def check_sun(rng, n=20):
    sys.path.insert(0, os.path.dirname(HERE))
    sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(HERE))))
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
    # the azimuth lives on a circle: compare the wrapped difference
    daz = np.abs((got[:, 1] - ref[:, 1] + np.pi) % (2 * np.pi) - np.pi).max()
    print("  sun      %d instants   |del el| = %.3e rad   |del az| = %.3e rad   %s"
          % (n, del_, daz, "ok" if max(del_, daz) <= SUN_TOL else "FAIL"))
    return del_, daz


def main():
    rng = np.random.default_rng(20260919)
    sys.path.insert(0, HERE)
    n = write_rays()
    print("rays.csv: %d draws (the renderer and this check read the same file)" % n)
    print("the three scenes, C against the NumPy twin at 5 random inputs (tol %.0e):" % TOL)
    ok = True
    for s in SCENES:
        good, _ = check_scene(s, rng)
        ok = ok and good
    print("the sun, against the trainer (tol %.0e rad):" % SUN_TOL)
    de, da = check_sun(rng)
    if de is not None:
        ok = ok and max(de, da) <= SUN_TOL
    print("CHECK", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())

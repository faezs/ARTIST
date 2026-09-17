"""Parity of the compiled Hashemi.lean: the C header against the Float twin, on the same samples.

Two printers off one graph must agree: hashemi_ccc.h (compiled here as a shared library in double
precision) and HashemiCccFloat.lean (Lean's 64-bit Float, run with `lake env lean`). The samples
are in hashemi_ccc.json. The closed theorem statements are also evaluated as checks - true in exact
arithmetic, and reported as they come out in double.

    python test_ccc.py            # compares, prints a summary, exits non-zero on disagreement
"""
import ctypes, json, math, os, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
LEAN = os.path.expanduser("~/manifold-pareto/lean")
TOL = 1e-12


def build_lib():
    shim = os.path.join(HERE, "hk_shim.c")
    with open(shim, "w") as f:
        f.write('#define HK_STATIC\n#define hk_real double\n#include "hashemi_ccc.h"\n')
    lib = os.path.join(tempfile.gettempdir(), "libhashemi_ccc.dylib")
    subprocess.check_call(["cc", "-O1", "-shared", "-fPIC", "-I", HERE, "-o", lib, shim, "-lm"])
    return ctypes.CDLL(lib)


def run_twin():
    out = subprocess.run(["lake", "env", "lean", "RequestProject/HashemiCccFloat.lean"], cwd=LEAN,
                         capture_output=True, text=True)
    vals = {}
    for line in out.stdout.splitlines():
        parts = line.split(" ", 1)
        if len(parts) == 2:
            vals.setdefault(parts[0], []).append(parts[1].strip())
    if out.returncode != 0:
        sys.stderr.write(out.stderr[-2000:])
    return vals


def bits_to_float(s):
    import struct
    return struct.unpack("<d", struct.pack("<Q", int(s.strip())))[0]


def parse_twin(s):
    """the twin prints Float values bit-exactly (Float.toBits), booleans as words"""
    s = s.strip()
    if s in ("true", "false"):
        return [1.0 if s == "true" else 0.0]
    if s.startswith("#["):
        return [bits_to_float(x) for x in s[2:-1].split(",")] if len(s) > 3 else []
    return [bits_to_float(s)]


def call_c(lib, fn, inputs, n_out, shape):
    f = getattr(lib, fn["c"])
    args = [ctypes.c_double(x) for x in inputs]
    if shape == "real":
        f.restype = ctypes.c_double
        f.argtypes = [ctypes.c_double] * len(inputs)
        return [f(*args)]
    if shape == "bool":
        f.restype = ctypes.c_bool
        f.argtypes = [ctypes.c_double] * len(inputs)
        return [1.0 if f(*args) else 0.0]
    f.restype = None
    f.argtypes = [ctypes.c_double] * len(inputs) + [ctypes.POINTER(ctypes.c_double)]
    out = (ctypes.c_double * n_out)()
    f(*args, out)
    return list(out)


def same(a, b):
    if math.isnan(a) and math.isnan(b):
        return True
    if math.isinf(a) or math.isinf(b):
        return a == b
    return abs(a - b) <= TOL * max(1.0, abs(a), abs(b))


def main():
    table = json.load(open(os.path.join(HERE, "hashemi_ccc.json")))
    lib = build_lib()
    twin = run_twin()
    n_fn = n_ok = n_bad = n_missing = 0
    checks_true, checks_false = [], []
    for fn in table["functions"]:
        name = fn["name"]
        key = ("check_" + name) if fn["kind"] == "theorem" else name
        got = twin.get(key)
        if got is None:
            n_missing += 1
            print(f"MISSING twin output for {key}")
            continue
        n_fn += 1
        for sample, tv in zip(fn["samples"], got):
            tvals = parse_twin(tv)
            cvals = call_c(lib, fn, [float(x) for x in sample], fn["n_out"], fn["shape"])
            if len(tvals) != len(cvals) or not all(same(a, b) for a, b in zip(tvals, cvals)):
                n_bad += 1
                print(f"DISAGREE {key} {sample}: twin {tvals} C {cvals}")
            else:
                n_ok += 1
            if fn["kind"] == "theorem":
                (checks_true if cvals[0] == 1.0 else checks_false).append(name)
    checks_false = sorted(set(checks_false))
    print(f"functions compared: {n_fn}, samples agreeing: {n_ok}, disagreeing: {n_bad}, missing: {n_missing}")
    print(f"theorem checks true in double: {len(set(checks_true))}, false: {len(checks_false)} {checks_false}")
    sys.exit(1 if (n_bad or n_missing) else 0)


if __name__ == "__main__":
    main()

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
# the NumPy twin is double and the scene's frames are isometries, so the drawing and the compiled
# length would agree to the last bit; what limits this is that `hashemi_machine_<a>.json` writes
# `ym`, `hp` and `ze` to six decimals, and a half-micron on `ym` is a quarter-micron on the span.
WIRE_TOL = 1e-5


def _entry_points(vs, man, label):
    """the vertices of one scene entry, (n, 3)"""
    e = [x for x in man["entries"] if x["label"] == label][0]
    return np.asarray(vs[e["offset"]:e["offset"] + e["width"]], dtype=np.float64).reshape(-1, 3)


def check_wire(scene="hashemi", sizes=(0.8, 2.0), swings=(0.0, 0.5, 1.0)):
    """**the drawn tow wire is the compiled path**, drum -> pulley -> clip.

    The wire is not a picture with two ends chosen by hand: `winch_drum` is `HashemiWire.drumAt`,
    `pulley` is `Hashemi.pulleyAt` and `clip` is `Hashemi.edgeClipAt`, all three carried into the
    roof by the same frame, and the two drawn legs are measured here against the compiled lengths
    at three swings and two reflector sizes.  Five things, none of which writes a cosine:

      1. the span, pulley to clip, IS `wireLen` (HashemiStep) at that swing;
      2. the mast leg, drum to pulley, does not move with the swing — which is
         `payOut_eq_run` (HashemiWire): the drum pays the whole change of the run and the first
         leg cancels;
      3. the drawn pay-out between two swings IS `payOut`;
      4. the clip end is ON THE RIM: |C - F| = √(a² + ze²) = F-C at every swing
         (`edgeClip_radius`), and the drawn `clip` point is that same end;
      5. the pulley end sits on the drawn mast's top (`mastTop_is_pulley`) and the drum end on
         the drawn winch bracket (`drumFoot_is_drumAt`) — the two stations that were 2.00 m out
         at a = 2 m until 2026-09-20, which is what left the wire hanging off the pulley.

    The machine's own numbers (`ym`, `hp`, `ze`, `FC`) are read from `hashemi_machine_<a>.json`,
    which is Lean's own `machine_scale` derivation, not a table in this file.
    """
    import json
    import hashemi_ccc as H
    from hashemi_tandoor_env import load_machine
    mod = __import__("scene_%s" % scene)
    fn = getattr(mod, [n for n in dir(mod) if n.startswith("hk_scene")][0])
    man = json.load(open(os.path.join(HERE, "scene_%s.json" % scene)))
    ok = True
    for a in sizes:
        m = load_machine(a)["machine"]
        ym, hp, ze, FC = (float(m[k]) for k in ("ym", "hp", "ze", "FC"))
        legs, spans = [], []
        for t in swings:
            vals = dict(a=a, f=float(m["f"]), R=float(m["R"]), rc=float(m["rc"]), w=float(m["w"]),
                        az=0.0, t=t, dt=1.0, elSun=0.9, azSun=0.3, dni=900.0, rho=0.85,
                        rDrum=float(m["rDrum"]), W=float(m["W"]), rcm=float(m["rcm"]),
                        Tmax=float(m["Tmax"]), Fdrive=float(m["Fdrive"]), L10=float(m["L10"]),
                        rodLen=float(m["rodLen"]), hsun=4.65e-3, lat=30.2, doy=172.0, hour=12.0)
            args = [np.array([vals.get(n, 0.0)]) for n in mod.INPUTS]
            with np.errstate(all="ignore"):
                vs, _ = fn(*args, np.zeros((1, man["rays"], man["arrays"][0]["m"])))
            vs = np.asarray(vs).reshape(-1)
            P = lambda lab: _entry_points(vs, man, lab)                       # noqa: E731
            span_pts, leg_pts = P("tow_wire"), P("tow_wire_mast")
            span, leg = (np.linalg.norm(q[1] - q[0]) for q in (span_pts, leg_pts))
            spans.append(span); legs.append(leg)
            ref = float(H.hk_wireLen(ym, hp, a, ze, t))
            d_span = abs(span - ref)
            # the clip end, on the rim about F
            d_rim = abs(np.linalg.norm(span_pts[1] - P("focus")[0]) - FC)
            d_clip = np.linalg.norm(span_pts[1] - P("clip")[0])
            # the pulley end on the mast's top, the drum end on the winch bracket
            d_mast = np.linalg.norm(span_pts[0] - P("mast")[1])
            d_drum = np.linalg.norm(leg_pts[0] - P("winch_bracket")[0])
            bad = max(d_span, d_rim, d_clip, d_mast, d_drum)
            ok = ok and bad <= WIRE_TOL
            print("  wire a=%.1f t=%.2f  span %.6f m (wireLen %.6f, d %.1e)  mast leg %.6f m   "
                  "rim %.1e  clip %.1e  onMast %.1e  onDrum %.1e  %s"
                  % (a, t, span, ref, d_span, leg, d_rim, d_clip, d_mast, d_drum,
                     "ok" if bad <= WIRE_TOL else "FAIL"))
        # while we have the scene open: the hangers, which hold F on the bolt line, are drawn at
        # the spec's own `hangerLength R a rimHole 0` = `derive`'s `hanger` (`hanger_drawn_length`)
        d_hang = max(abs(np.linalg.norm(q[1] - q[0]) - float(m["hanger"]))
                     for q in (P(l) for l in ("hanger_vertexside_left", "hanger_rimside_left",
                                              "hanger_vertexside_right", "hanger_rimside_right")))
        ok = ok and d_hang <= WIRE_TOL
        print("  hang a=%.1f       the four drawn hangers == hangerLength (%.6f m) to %.1e m   %s"
              % (a, float(m["hanger"]), d_hang, "ok" if d_hang <= WIRE_TOL else "FAIL"))
        # the mast leg is the same at every swing, and the drawn pay-out is `payOut`
        d_fixed = float(np.ptp(legs))
        d_pay = max(abs((spans[i] - spans[j]) - float(H.hk_payOut(ym, hp, a, ze, swings[i], swings[j])))
                    for i in range(len(swings)) for j in range(len(swings)))
        ok = ok and max(d_fixed, d_pay) <= WIRE_TOL
        print("  wire a=%.1f       mast leg fixed to %.1e m over the swings; drawn pay-out == payOut to %.1e m   %s"
              % (a, d_fixed, d_pay, "ok" if max(d_fixed, d_pay) <= WIRE_TOL else "FAIL"))
    return ok


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
    print("the tow wire: the drawn path == the compiled path (tol %.0e m):" % WIRE_TOL)
    ok = check_wire() and ok
    print("the sun, against the trainer (tol %.0e rad):" % SUN_TOL)
    de, da = check_sun(rng)
    if de is not None:
        ok = ok and max(de, da) <= SUN_TOL
    print("CHECK", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())

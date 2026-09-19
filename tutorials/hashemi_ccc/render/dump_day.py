#!/usr/bin/env python
"""Write a day of poses for `main.c --replay day.csv`.

Standalone on purpose: it does not touch roll_checkpoint.py.  It walks the spec's own mount
(`hashemi_ccc.hk_megaStep`, through the generated NumPy module) under the spec's own sun
(`scene_sun.hk_sceneSunAt`), with the heads held by a plain proportional follower on the encoders
— the renderer replays the poses, it does not grade them.

    python dump_day.py --lat 30.2 --doy 172 --out day.csv
"""
import argparse
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))

import hashemi_ccc as H          # noqa: E402  the machine's own printed NumPy twin
import scene_sun                 # noqa: E402  the spec's sunAt, printed


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lat", type=float, default=30.2)
    ap.add_argument("--doy", type=float, default=172)
    ap.add_argument("--start", type=float, default=6.0)
    ap.add_argument("--end", type=float, default=18.0)
    ap.add_argument("--dt", type=float, default=60.0, help="seconds per frame")
    ap.add_argument("--out", default=os.path.join(HERE, "day.csv"))
    a = ap.parse_args()

    mount = dict(rDrum=0.03, W=300.0, rcm=2.25, Tmax=2000.0, rho=0.85, Fdrive=10.0,
                 L10=1e6, rodLen=2.5)
    az, t, slack = np.pi, 0.6, 0.0
    hour = a.start
    rows = []
    while hour < a.end:
        sun = np.asarray(scene_sun.hk_sceneSunAt(a.lat, a.doy, hour), dtype=float)
        elSun, azSun = float(sun[0]), float(sun[1])
        s = np.asarray(H.hk_megaStep(az, t, slack, 0.0, 0.0, 0.0, elSun, azSun, 0.0,
                                     **mount), dtype=float)
        arm = float(s[8])
        # a plain follower on the encoders: the head is the saturated error, in [0, 6]
        eAz = (azSun - az + np.pi) % (2 * np.pi) - np.pi
        eEl = (np.pi / 2 - elSun) - t
        hAz = float(np.clip(3 + 60 * eAz, 0, 6))
        hEl = float(np.clip(3 + 60 * eEl, 0, 6))
        R = float(H.hk_rollerRadius(4.6, 2.0, 2.45, 0.975, 0.3375, 0.02))
        wm = float(H.hk_headToDriveAz(hAz, 0.02, R))
        wd = float(H.hk_headToDriveEl(hEl, arm, mount["rDrum"]))
        s = np.asarray(H.hk_megaStep(az, t, slack, wm, wd, a.dt, elSun, azSun, 0.0,
                                     **mount), dtype=float)
        az, t, slack = float(s[0]), float(s[1]), float(s[2])
        rows.append((hour, az, t, slack, a.lat, a.doy))
        hour += a.dt / 3600.0

    with open(a.out, "w") as fh:
        fh.write("hour,az,t,slack,lat,doy\n")
        for r in rows:
            fh.write(",".join("%.17g" % v for v in r) + "\n")
    print("%s: %d frames" % (a.out, len(rows)))


if __name__ == "__main__":
    main()

"""The beam-down's shape against the day: what the coil's volume and the slot allow.

Design variables: the vertex distance dm from F (the cap must intercept the dish's cone, radius
~ dm tan 44 deg), the cap radius rm (FitsReceiver: pi rm^2 sag <= the coil's volume), the near
focus L (the tunnel mouth's distance), the axis tilt beta toward the tube, the slot width slotW,
the mouth radius rt. The figure of merit: the day's captured aperture (per unit DNI) integrated
over the hours the winch reaches, on the Metal kernel; the constraints as the spec's Props.

    .venv/bin/python beam_design.py [--day 172] [--rays 256]
"""
import argparse
import itertools
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
for _p in (os.path.dirname(os.path.dirname(HERE)), os.path.dirname(HERE), HERE):
    sys.path.insert(0, _p)
from hashemi_beam_kernel import HashemiBeamMetal, aimed_rows, BCOL, DESIGN   # noqa: E402
from hashemi_env_kernel import draws                                         # noqa: E402
import hashemi_ccc as H                                                      # noqa: E402


def fits(dm, rm, L):
    """FitsReceiver of HashemiBeamdown.lean, through the twin"""
    c = L / 2; a = c - dm; b2 = c * c - a * a
    return bool(H.hk_FitsReceiver(a, b2, rm)), float(H.hk_capSag(a, b2, rm)), float(math.pi * rm * rm * H.hk_capSag(a, b2, rm))


def day_capture(k, rng, design, day, lat, rays, hours):
    import torch
    import tandoor_hashemi_env as _m
    f32 = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32), device="mps")
    caps, hits, passes, spots = [], [], [], []
    B = rays
    for h in hours:
        el, az, _ = _m._sim.solar_position(lat, day, h)
        el = math.radians(el)
        if el < math.radians(28.3):                     # under the winch's reach: the machine's, not the design's
            continue
        x = aimed_rows(B, rng, el, design)
        out = k.step(f32(x), f32(draws(rng, B))).cpu().numpy()
        caps.append(out[:, BCOL["capture"]].mean()); hits.append(out[:, BCOL["hit_secondary"]].mean())
        passes.append(out[:, BCOL["passes_dish"]].mean()); spots.append(out[:, BCOL["spot"]].mean())
    return dict(capture=float(np.mean(caps)), hit=float(np.mean(hits)), passed=float(np.mean(passes)), spot=float(np.mean(spots)), hours=len(caps))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--day", type=int, default=172)
    ap.add_argument("--lat", type=float, default=30.2)
    ap.add_argument("--rays", type=int, default=256)
    args = ap.parse_args()
    rng = np.random.default_rng(1)
    k = HashemiBeamMetal()
    hours = [8 + 0.5 * i for i in range(17)]
    coil = float(H.hk_coilVolume())
    print(f"the coil's volume {coil * 1e6:.0f} cm^3; the day {args.day}, {len(hours)} half-hours from 8:00, {args.rays} rays per stage")
    print("  the axis: F2 at the bar (L 1.25, beta 0) unless said; the mouth 0.55 m (the tandoor's duct)")
    print("  dm[m]  rm[m]  slot[m]  fits   sag[mm]  vol[cm3]  mag   hit    passed  captured  spot[m]")
    rows = []
    for dm, rm, slotW in itertools.product((0.04, 0.06, 0.10, 0.15, 0.25), (0.04, 0.06, 0.10, 0.15, 0.25), (0.06, 0.20, 0.60, 1.6)):
        L = DESIGN["L"]
        ok, sag, vol = fits(dm, rm, L)
        mag = (L - dm) / dm
        d = dict(dm=dm, rm=rm, slotW=slotW)
        r = day_capture(k, rng, d, args.day, args.lat, args.rays, hours)
        rows.append((dm, rm, slotW, ok, sag, vol, mag, r))
        print(f"  {dm:5.2f}  {rm:5.2f}  {slotW:5.2f}   {'yes' if ok else 'no '}   {sag * 1e3:6.1f}  {vol * 1e6:7.0f}  {mag:5.1f}  {r['hit']:.3f}  {r['passed']:.3f}   {r['captured'] if 'captured' in r else r['capture']:.3f}     {r['spot']:.3f}")
    best_fit = max((row for row in rows if row[3]), key=lambda row: row[7]["capture"])
    best_any = max(rows, key=lambda row: row[7]["capture"])
    print(f"\nbest within the coil's volume: dm {best_fit[0]}, rm {best_fit[1]}, slot {best_fit[2]}: captured {best_fit[7]['capture']:.3f} (hit {best_fit[7]['hit']:.3f}, passed {best_fit[7]['passed']:.3f}), magnification {best_fit[6]:.1f}")
    print(f"best of all: dm {best_any[0]}, rm {best_any[1]}, slot {best_any[2]}: captured {best_any[7]['capture']:.3f} (volume {best_any[5] * 1e6:.0f} cm3, {'fits' if best_any[3] else 'does not fit'})")
    # the tilt toward the tube and the mouth: at the best fitting shape
    print("\nthe axis tilted toward the tube (F2 on the azimuth axis needs ~36 deg at L 1.36) and the mouth, at the best fitting shape:")
    for beta, L, rt in ((0.0, 1.25, 0.55), (math.radians(36), 1.36, 0.55), (0.0, 1.25, 0.2), (0.0, 1.25, 0.1)):
        d = dict(dm=best_fit[0], rm=best_fit[1], slotW=best_fit[2], beta=beta, L=L, rt=rt)
        r = day_capture(k, rng, d, args.day, args.lat, args.rays, hours)
        print(f"  beta {math.degrees(beta):4.0f} deg, L {L:.2f}, mouth {rt:.2f}: hit {r['hit']:.3f} passed {r['passed']:.3f} captured {r['capture']:.3f} spot {r['spot']:.3f}")


if __name__ == "__main__":
    main()

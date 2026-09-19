#!/usr/bin/env python
"""The viewer: the scene kernel's vertices, drawn by pyray.

Every number on the screen came out of the compiler.  The pose is the specification's own mount
(`hashemi_ccc.hk_megaStep`, the printed NumPy twin), driven by the keyboard through the printed
`hk_headToDriveAz` / `hk_headToDriveEl` or by the proved `hk_follower`; the sun is the printed
`hk_sceneSunAt`; the vertices are `render/scene_<name>.metal` dispatched on the GPU by
`scene_kernel.SceneMetal` over the megakernel's own ray table, generated on the device; and the
captured fraction in the HUD is the env megakernel's own `capture` column, one step per frame,
over the SAME draws.  The dimensions come from `hashemi_machine_<a>.json` and from the spec's own
printed constants — nothing geometric is computed in this file.

    view.py --scene hashemi                      the window
    view.py --scene beam --machine hashemi_machine_0.8.json
    view.py --replay day.csv                     a day from dump_day.py
    view.py --frames 1 --out .                   headless: one image, no display needed

keys: arrows / drag orbit, wheel zooms, F toggles the proved follower, A/D and W/S drive the
heads by hand, +/- the clock's speed, R resets, SPACE pauses, TAB cycles the scene.
"""
import argparse
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
PARENT = os.path.dirname(HERE)
for p in (HERE, PARENT, os.path.dirname(PARENT)):
    if p not in sys.path:
        sys.path.insert(0, p)

import hashemi_ccc as H                      # noqa: E402  the machine's printed NumPy twin
import scene_sun                             # noqa: E402  the spec's sunAt, printed
import scene_draw                            # noqa: E402
import scene_kernel                          # noqa: E402

SCENES = scene_kernel.SCENES


# ---------------------------------------------------------------------------- the dimensions
def pool(machine_path, az=np.pi, t=0.6):
    """every scene input's value, by name: the machine JSON, then the spec's own constants.

    This is `main.c`'s old pooling, in Python and unchanged in substance: the JSON is the only
    source of dimensions, and what it does not carry (`zBar`, `zBolt`, `ym`, `hp`, `ze`) is a
    printed constant of the specification, never arithmetic here."""
    j = json.load(open(machine_path))
    m = dict(j.get("machine", {}))
    m.update(j.get("kernel", {}))
    m.update(j.get("mount", {}))
    p = {k: float(v) for k, v in m.items() if isinstance(v, (int, float))}
    p.setdefault("k", 0.0)
    # the drawing's own conventions: which end of the bar, and the two posts
    p.update(sgL=1.0, sgR=-1.0, endIn=0.0)
    g = np.asarray(H.hk_megaGeom(az, t, 0, 0, 0, 0, 0, 0, 0, p["rDrum"], p["W"], p["rcm"],
                                 p["Tmax"], p["rho"], p["Fdrive"], p["L10"], p["rodLen"]),
                   dtype=float)
    p["zBar"] = float(g[13])
    p["zBolt"] = float(H.hk_zBoltHashemi())
    p.setdefault("ym", float(H.hk_ymHashemi()))
    p.setdefault("hp", float(H.hk_hpHashemi()))
    p.setdefault("ze", float(H.hk_zeHashemi()))
    p["dnut"] = p["f"]                      # the rim nuts at the focal length
    p["P_1"] = p["P_2"] = 0.0               # the pivot of `swingFocus`: the bolt line
    # the secondary, as hashemi_tandoor_env.py sets it
    p.update(L=1.25, dm=0.06, rm=0.06, rt=0.55, slotW=0.06, beta=0.0, onPanel=1.0, hsun=0.00465)
    p.setdefault("sigmaslope", 2e-3)
    p.setdefault("sigmaspec", 1e-3)
    return p


# ---------------------------------------------------------------------------- the pose
class Pose:
    """the specification's own mount, stepped.  No geometry: `hk_megaStep` is the step."""

    def __init__(self, p, lat=30.2, doy=172.0, hour=9.0):
        self.p = p
        self.az, self.t, self.slack = np.pi, 0.6, 0.0
        self.lat, self.doy, self.hour = lat, doy, hour
        self.follow = True
        self.hAz, self.hEl = 3.0, 3.0
        self.mount = dict(rDrum=p["rDrum"], W=p["W"], rcm=p["rcm"], Tmax=p["Tmax"],
                          rho=p["rho"], Fdrive=p["Fdrive"], L10=p["L10"], rodLen=p["rodLen"])
        self.R = float(H.hk_rollerRadius(p.get("chord", 4.6), p.get("apexH", 2.0),
                                         p.get("aBase", 2.45), p.get("cross", 0.975),
                                         p.get("barW", 0.3375), p.get("rDrive", 0.02)))
        self.state = np.zeros(17)

    def sun(self):
        s = np.asarray(scene_sun.hk_sceneSunAt(self.lat, self.doy, self.hour), dtype=float)
        return float(s[0]), float(s[1])

    def step(self, dt):
        elSun, azSun = self.sun()
        s = np.asarray(H.hk_megaStep(self.az, self.t, self.slack, 0.0, 0.0, 0.0, elSun, azSun,
                                     0.0, **self.mount), dtype=float)
        arm = float(s[8])
        if self.follow:
            eAz = (azSun - self.az + np.pi) % (2 * np.pi) - np.pi
            eEl = (np.pi / 2 - elSun) - self.t
            u = np.asarray(H.hk_follower(eAz, eEl, max(dt, 1e-6)), dtype=float)
            self.hAz = float(np.clip(3 + 3 * u[0], 0, 6))
            # the drum pays wire OUT as the head rises, and the dish swings DOWN with it
            self.hEl = float(np.clip(3 - 3 * u[1], 0, 6))
        wm = float(H.hk_headToDriveAz(self.hAz, 0.02, self.R))
        wd = float(H.hk_headToDriveEl(self.hEl, arm, self.mount["rDrum"]))
        s = np.asarray(H.hk_megaStep(self.az, self.t, self.slack, wm, wd, dt, elSun, azSun, 0.0,
                                     **self.mount), dtype=float)
        self.az, self.t, self.slack = float(s[0]), float(s[1]), float(s[2])
        self.state = s
        return s


# ---------------------------------------------------------------------------- the frame
def scene_row(kern, p, pose):
    elSun, azSun = pose.sun()
    vals = dict(p)
    vals.update(az=pose.az, t=pose.t, elSun=elSun, azSun=azSun,
                lat=pose.lat, doy=pose.doy, hour=pose.hour)
    return kern.row(vals, 1)


def env_capture(envk, p, pose, dr, torch):
    """the env megakernel's own capture column, one step, over the SAME draws"""
    import hashemi_env_kernel as EK
    elSun, azSun = pose.sun()
    state = np.array([[pose.az, pose.t, pose.slack]])
    cmd = np.zeros((1, 2))
    sun = np.array([[elSun, azSun, 900.0]])
    x = EK.pack(1, state, cmd, 1.0, sun, 0.95, 400.0, 300.0)
    f32 = lambda a: torch.as_tensor(np.asarray(a, dtype=np.float32), device="mps")
    hist = np.full((1, EK.N_HIST), 420.0)
    out = envk.step(f32(x), f32(hist), f32(hist), dr).cpu().numpy()[0]
    return {n: float(out[EK.ECOL[n]]) for n in ("capture", "p_in", "T_oil", "pointing_err")}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scene", default="hashemi", choices=SCENES)
    ap.add_argument("--machine", default="hashemi_machine_2.0.json")
    ap.add_argument("--lat", type=float, default=30.2)
    ap.add_argument("--doy", type=float, default=172.0)
    ap.add_argument("--hour", type=float, default=9.0)
    ap.add_argument("--replay", default=None, help="a day from dump_day.py")
    ap.add_argument("--frames", type=int, default=0, help="headless: N frames, then quit")
    ap.add_argument("--out", default=None, help="where the headless frames go")
    ap.add_argument("--seed", type=int, default=20260919)
    ap.add_argument("--settle", type=int, default=900,
                    help="follower steps (10 s each) before the first frame, so the machine is on sun")
    ap.add_argument("--no-env", action="store_true", help="skip the env kernel's HUD columns")
    a = ap.parse_args()

    import torch
    mach = a.machine if os.path.isabs(a.machine) else os.path.join(PARENT, a.machine)
    p = pool(mach)
    name = a.scene
    kern = scene_kernel.SceneMetal(name)
    man = kern.man
    pose = Pose(p, a.lat, a.doy, a.hour)
    for _ in range(a.settle):
        pose.step(10.0)
    replay = None
    if a.replay:
        rows = [ln.split(",") for ln in open(a.replay).read().strip().split("\n")[1:]]
        replay = np.array([[float(v) for v in r] for r in rows])

    envk = None
    if not a.no_env:
        try:
            from hashemi_env_kernel import HashemiEnvMetal
            envk = HashemiEnvMetal()
        except Exception as exc:
            print("the env kernel is not available for the HUD (%s)" % exc)

    headless = a.frames > 0
    WARM = 5                 # raylib's first frames are the buffer before it has been presented
    out_dir = a.out or HERE
    os.makedirs(out_dir, exist_ok=True)
    win = scene_draw.SceneWindow("hashemi — %s" % name, hidden=False) if True else None
    if headless and not win.ok:
        print("no window could open; writing the SVG of the same vertices instead")

    speed = 120.0          # simulated seconds per frame
    paused = False
    frame = 0
    made = []
    while True:
        if replay is not None and frame < len(replay):
            r = replay[frame % len(replay)]
            pose.hour, pose.az, pose.t, pose.slack = r[0], r[1], r[2], r[3]
            pose.lat, pose.doy = r[4], r[5]
        elif not paused:
            pose.step(1.0)
            pose.hour += speed / 3600.0
            if pose.hour > 19.0:
                pose.hour = 5.0

        dr = scene_kernel.device_draws(torch, 1, a.seed + frame, kern.P,
                                       int(man["arrays"][0]["m"]))
        x = scene_row(kern, p, pose)
        vs, vr = kern(torch.as_tensor(x, device="mps"), dr)
        vs = vs.cpu().numpy()[0, :kern.n_static]
        vr = vr.cpu().numpy()[0, :, :kern.n_ray]

        elSun, azSun = pose.sun()
        hud = ["scene %s   %d entries   %d static + %d x %d ray doubles"
               % (name, len(man["entries"]), kern.n_static, kern.P, kern.n_ray),
               "pose   az %7.2f deg   t %6.2f deg   slack %6.4f m"
               % (np.degrees(pose.az), np.degrees(pose.t), pose.slack),
               "sun    el %7.2f deg   az %6.2f deg   %02d:%02.0f  lat %.1f doy %d"
               % (np.degrees(elSun), np.degrees(azSun), int(pose.hour),
                  (pose.hour % 1) * 60, pose.lat, pose.doy),
               "heads  az %.2f  el %.2f   follower %s   speed %.0f s/frame"
               % (pose.hAz, pose.hEl, "on" if pose.follow else "off", speed)]
        if envk is not None:
            try:
                c = env_capture(envk, p, pose, dr, torch)
                hud.append("env    capture %.3f   p_in %6.0f W   T_oil %6.1f K   point %.3f deg"
                           % (c["capture"], c["p_in"], c["T_oil"], np.degrees(c["pointing_err"])))
            except Exception as exc:
                hud.append("env    unavailable (%s)" % exc)
                envk = None

        if win.ok:
            win.draw(man, vs, vr, hud)
            rl = win.rl
            if rl.is_key_pressed(rl.KEY_F):
                pose.follow = not pose.follow
            if rl.is_key_pressed(rl.KEY_SPACE):
                paused = not paused
            if rl.is_key_pressed(rl.KEY_TAB):
                name = SCENES[(SCENES.index(name) + 1) % len(SCENES)]
                kern = scene_kernel.SceneMetal(name)
                man = kern.man
            if rl.is_key_pressed(rl.KEY_R):
                pose = Pose(p, a.lat, a.doy, a.hour)
                for _ in range(a.settle):
                    pose.step(10.0)
            if rl.is_key_down(rl.KEY_A):
                pose.follow = False; pose.hAz = max(0.0, pose.hAz - 0.1)
            if rl.is_key_down(rl.KEY_D):
                pose.follow = False; pose.hAz = min(6.0, pose.hAz + 0.1)
            if rl.is_key_down(rl.KEY_W):
                pose.follow = False; pose.hEl = min(6.0, pose.hEl + 0.1)
            if rl.is_key_down(rl.KEY_S):
                pose.follow = False; pose.hEl = max(0.0, pose.hEl - 0.1)
            if rl.is_key_pressed(rl.KEY_EQUAL) or rl.is_key_pressed(rl.KEY_KP_ADD):
                speed *= 2
            if rl.is_key_pressed(rl.KEY_MINUS) or rl.is_key_pressed(rl.KEY_KP_SUBTRACT):
                speed = max(1.0, speed / 2)
            if headless and frame >= WARM:
                path = os.path.join(out_dir, "frame_%s_%03d.png" % (name, frame - WARM))
                if win.screenshot(path):
                    made.append(path)
        elif headless and frame >= WARM:
            path = os.path.join(out_dir, "frame_%s.svg" % name)
            scene_draw.to_svg(man, vs, vr, path)
            made.append(path)

        frame += 1
        if headless and frame >= a.frames + WARM:
            break
        if win.ok and win.should_close():
            break
        if not win.ok and not headless:
            print("no window could open (pyray could not initialise a display).")
            print("run with --frames N --out DIR for the headless frames.")
            return 1
    win.close()
    for m in made:
        print("wrote %s" % m)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

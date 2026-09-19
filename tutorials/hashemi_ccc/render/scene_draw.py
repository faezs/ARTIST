"""The window, on pyray — shared by `view.py` and the env's `render_mode="human"`.

Nothing here knows any geometry either.  It is given a manifest (which entry is a point, a
segment, a ray or a scalar; which colour; where its doubles are in the static region or in the
ray region) and the two vertex buffers the scene kernel wrote, and it draws them.  The vertices
came from the Metal kernel through `scene_kernel.SceneMetal`; this file never computes one.

The roof frame is the specification's — x north, y east, z up — and raylib's is y-up, so the one
mapping in this file is `(x, y, z) -> (y, z, x)`.  That is the whole of its geometry.
"""
import os

import numpy as np

PALETTE = [
    (230, 230, 230), (120, 200, 255), (255, 190, 80), (140, 255, 170),
    (255, 120, 120), (200, 150, 255), (255, 240, 120), (255, 255, 255),
]
FATE = {0: (120, 120, 130), 1: (255, 120, 120), 2: (255, 190, 80), 3: (140, 255, 170)}

KIND_POINT, KIND_SEGMENT, KIND_RAY, KIND_AXES, KIND_SCALAR = 0, 1, 2, 3, 4
KIND_OF = {"Scene.Kind.point": KIND_POINT, "Scene.Kind.segment": KIND_SEGMENT,
           "Scene.Kind.ray": KIND_RAY, "Scene.Kind.axes": KIND_AXES,
           "Scene.Kind.scalar": KIND_SCALAR}


def entry_kind(e):
    return KIND_OF[e["kind"]]


def colour(e):
    return PALETTE[e["colour"] % len(PALETTE)]


def entry_slice(e, vs, vr):
    """the doubles of one entry: (n,) from the static region, or (P, n) from the ray region"""
    o, w = e["offset"], e["width"]
    return (vr[:, o:o + w] if e["ray"] else vs[o:o + w])


class SceneWindow:
    """an orbit camera over one scene's vertices.  `ok` is False when no window could open."""

    def __init__(self, title="hashemi", width=1280, height=800, hidden=False):
        self.ok = False
        self.width, self.height = width, height
        self.yaw, self.pitch, self.dist = 2.3, 0.45, 12.0
        self.target = [0.0, 1.5, 0.0]
        try:
            import pyray as rl
        except Exception:
            return
        self.rl = rl
        try:
            rl.set_trace_log_level(rl.LOG_WARNING)
            if hidden:
                rl.set_config_flags(rl.FLAG_WINDOW_HIDDEN)
            rl.init_window(width, height, title)
            if not rl.is_window_ready():
                return
            rl.set_target_fps(60)
            self.cam = rl.Camera3D(rl.Vector3(8, 6, 8), rl.Vector3(*self.target),
                                   rl.Vector3(0, 1, 0), 50.0, rl.CAMERA_PERSPECTIVE)
            self.ok = True
        except Exception:
            self.ok = False

    # ---- the camera -------------------------------------------------------------------
    def orbit(self):
        rl = self.rl
        if rl.is_mouse_button_down(rl.MOUSE_BUTTON_LEFT):
            d = rl.get_mouse_delta()
            self.yaw -= d.x * 0.006
            self.pitch = float(np.clip(self.pitch + d.y * 0.006, -1.4, 1.4))
        self.dist = float(np.clip(self.dist - rl.get_mouse_wheel_move() * 0.8, 2.0, 60.0))
        if rl.is_key_down(rl.KEY_LEFT):
            self.yaw -= 0.03
        if rl.is_key_down(rl.KEY_RIGHT):
            self.yaw += 0.03
        if rl.is_key_down(rl.KEY_UP):
            self.pitch = float(np.clip(self.pitch + 0.02, -1.4, 1.4))
        if rl.is_key_down(rl.KEY_DOWN):
            self.pitch = float(np.clip(self.pitch - 0.02, -1.4, 1.4))
        c = np.cos(self.pitch)
        self.cam.position = self.rl.Vector3(self.target[0] + self.dist * c * np.sin(self.yaw),
                                            self.target[1] + self.dist * np.sin(self.pitch),
                                            self.target[2] + self.dist * c * np.cos(self.yaw))
        self.cam.target = self.rl.Vector3(*self.target)

    # ---- the drawing ------------------------------------------------------------------
    def v3(self, p):
        return self.rl.Vector3(float(p[1]), float(p[2]), float(p[0]))

    def draw(self, man, vs, vr, hud=(), ray_stride=1):
        rl = self.rl
        self.orbit()
        rl.begin_drawing()
        rl.clear_background(rl.Color(14, 16, 22, 255))
        rl.begin_mode_3d(self.cam)
        rl.draw_grid(24, 1.0)
        for e in man["entries"]:
            k = entry_kind(e)
            if k == KIND_SCALAR:
                continue
            col = rl.Color(*colour(e), 255)
            d = entry_slice(e, vs, vr)
            rows = d if e["ray"] else d[None, :]
            for i in range(0, rows.shape[0], ray_stride if e["ray"] else 1):
                r = rows[i]
                if not np.all(np.isfinite(r)):
                    continue
                if k == KIND_POINT:
                    rl.draw_sphere(self.v3(r[0:3]), 0.06, col)
                elif k == KIND_SEGMENT:
                    rl.draw_line_3d(self.v3(r[0:3]), self.v3(r[3:6]), col)
                elif k == KIND_RAY:
                    fc = rl.Color(*FATE.get(int(round(r[9])) if len(r) > 9 else 3, (200, 200, 200)), 255)
                    rl.draw_line_3d(self.v3(r[0:3]), self.v3(r[3:6]), fc)
                    rl.draw_line_3d(self.v3(r[3:6]), self.v3(r[6:9]), fc)
                elif k == KIND_AXES:
                    o = self.v3(r[0:3])
                    for j, ac in enumerate([(255, 90, 90), (90, 255, 90), (90, 160, 255)]):
                        rl.draw_line_3d(o, self.v3(r[0:3] + r[3 + 3 * j:6 + 3 * j]),
                                        rl.Color(*ac, 255))
        rl.end_mode_3d()
        y = 10
        for line in hud:
            rl.draw_text(line, 12, y, 18, rl.Color(220, 230, 240, 255))
            y += 22
        # the scalars of the scene, by their own labels, down the right-hand side
        y = 10
        for e in man["entries"]:
            if entry_kind(e) != KIND_SCALAR:
                continue
            d = entry_slice(e, vs, vr)
            v = float(np.nanmean(d)) if e["ray"] else float(d[0])
            txt = "%-22s %9.4g" % (e["label"], v)
            rl.draw_text(txt, self.width - 320, y, 18, rl.Color(*colour(e), 255))
            y += 20
        rl.end_drawing()

    def should_close(self):
        return self.rl.window_should_close()

    def screenshot(self, path):
        """raylib writes into its working directory, so save under it and move"""
        self.rl.take_screenshot(os.path.basename(path))
        cwd = os.getcwd()
        src = os.path.join(cwd, os.path.basename(path))
        if os.path.abspath(src) != os.path.abspath(path) and os.path.exists(src):
            os.replace(src, path)
        return os.path.exists(path)

    def close(self):
        if self.ok:
            self.rl.close_window()
            self.ok = False


# ---------------------------------------------------------------------------------------
# the fallback, when no window can open: the same manifest, the same vertices, an SVG


def to_svg(man, vs, vr, path, width=1200, height=800, yaw=2.3, pitch=0.45, ray_stride=1):
    """an orthographic projection of the very same buffers — no pyray, no display"""
    cy, sy = np.cos(yaw), np.sin(yaw)
    cp, sp = np.cos(pitch), np.sin(pitch)

    def proj(p):
        x, y, z = float(p[0]), float(p[1]), float(p[2])
        u = x * cy - y * sy
        v = x * sy + y * cy
        return (u, v * sp + z * cp)

    segs, pts, texts = [], [], []
    for e in man["entries"]:
        k = entry_kind(e)
        if k == KIND_SCALAR:
            d = entry_slice(e, vs, vr)
            val = float(np.nanmean(d)) if e["ray"] else float(d[0])
            texts.append((e["label"], val, colour(e)))
            continue
        col = colour(e)
        d = entry_slice(e, vs, vr)
        rows = d if e["ray"] else d[None, :]
        for i in range(0, rows.shape[0], ray_stride if e["ray"] else 1):
            r = rows[i]
            if not np.all(np.isfinite(r)):
                continue
            if k == KIND_POINT:
                pts.append((proj(r[0:3]), col))
            elif k == KIND_SEGMENT:
                segs.append((proj(r[0:3]), proj(r[3:6]), col))
            elif k == KIND_RAY:
                fc = FATE.get(int(round(r[9])) if len(r) > 9 else 3, (200, 200, 200))
                segs.append((proj(r[0:3]), proj(r[3:6]), fc))
                segs.append((proj(r[3:6]), proj(r[6:9]), fc))
            elif k == KIND_AXES:
                for j in range(3):
                    segs.append((proj(r[0:3]), proj(r[0:3] + r[3 + 3 * j:6 + 3 * j]), col))
    allp = [p for s in segs for p in s[:2]] + [p for p, _ in pts]
    if not allp:
        allp = [(0.0, 0.0)]
    xs = [p[0] for p in allp]
    ys = [p[1] for p in allp]
    lo, hi = min(xs), max(xs)
    lo2, hi2 = min(ys), max(ys)
    sc = 0.86 * min(width / max(hi - lo, 1e-6), height / max(hi2 - lo2, 1e-6))
    ox, oy = (lo + hi) / 2, (lo2 + hi2) / 2

    def sx(p):
        return width / 2 + (p[0] - ox) * sc

    def sy(p):
        return height / 2 - (p[1] - oy) * sc

    out = ['<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" '
           'viewBox="0 0 %d %d"><rect width="100%%" height="100%%" fill="#0e1016"/>'
           % (width, height, width, height)]
    for a, b, c in segs:
        out.append('<line x1="%.2f" y1="%.2f" x2="%.2f" y2="%.2f" stroke="rgb(%d,%d,%d)" '
                   'stroke-width="1.2"/>' % (sx(a), sy(a), sx(b), sy(b), *c))
    for p, c in pts:
        out.append('<circle cx="%.2f" cy="%.2f" r="3.2" fill="rgb(%d,%d,%d)"/>'
                   % (sx(p), sy(p), *c))
    y = 22
    for label, val, c in texts:
        out.append('<text x="12" y="%d" fill="rgb(%d,%d,%d)" font-family="monospace" '
                   'font-size="15">%s %.4g</text>' % (y, *c, label, val))
        y += 19
    out.append("</svg>")
    with open(path, "w") as fh:
        fh.write("\n".join(out))
    return path

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
    # 8..13: the oven and the earth.  Every index the scenes already used is below 8 and
    # `colour()` indexes modulo the palette's length, so extending it moves nothing.
    (196, 150, 110),   # 8  the pit's clay
    (255, 140, 60),    # 9  the hearth and the belt's nodes
    (150, 150, 160),   # 10 masonry: the deck, the parapet, the shadow
    (255, 240, 170),   # 11 the sun, its rays
    (222, 196, 150),   # 12 the roti on the wall
    (120, 220, 235),   # 13 the tunnel and the duct's mouth
]
SKY_TOP, SKY_LOW = (26, 44, 78), (96, 118, 146)
GROUND = (120, 104, 84, 255)
# entries drawn at a sky distance: they never drive the opening camera by themselves
FAR_LABELS = ("sun", "sky")
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

    def _named(self, man, vs, vr, prefix):
        """the static three-vectors of the entries `<prefix>_pp/pm/mm/mp`, in that order"""
        out = {}
        for e in man["entries"]:
            if e["ray"]:
                continue
            for tag in ("pp", "pm", "mm", "mp"):
                if e["label"] == prefix + "_" + tag:
                    c = entry_slice(e, vs, vr)
                    if np.all(np.isfinite(c[:3])):
                        out[tag] = c[:3]
        return out if len(out) == 4 else None

    def _mesh(self, q, col, n=12):
        """a plane as a grid of lines through four named corners - the parent env's own way of
        drawing its roof deck (`tandoor_hashemi_env.py:4292-4297`).  A FILLED plane would hide the
        oven under it, and an oven in a pit is only ever seen through its own ground."""
        pp, pm, mm, mp = (np.asarray(q[t], dtype=float) for t in ("pp", "pm", "mm", "mp"))
        for i in range(n + 1):
            u = i / n
            self.rl.draw_line_3d(self.v3(pp + u * (pm - pp)), self.v3(mp + u * (mm - mp)), col)
            self.rl.draw_line_3d(self.v3(pp + u * (mp - pp)), self.v3(pm + u * (mm - pm)), col)

    def _quad(self, q, col):
        """a filled quadrilateral through four named points, both windings"""
        pp, pm, mm, mp = (self.v3(q[t]) for t in ("pp", "pm", "mm", "mp"))
        for tri in ((pp, pm, mm), (mm, mp, pp), (mm, pm, pp), (pp, mp, mm)):
            self.rl.draw_triangle_3d(*tri, col)

    def frame_on(self, man, vs, vr):
        """put the whole machine in view once, when the scene is first drawn.  The composed scene
        spans a pit five metres under the deck and a sun overhead; the opening camera of a
        machine-only scene showed neither.  The fit is over the NEAR vertices — a body drawn at a
        sky distance must never shrink the machine to a pixel — and the far ones (the sun, its
        rim) join it only when they barely widen the box.  Drawing only: the user's orbit takes
        over from here."""
        near, far = [], []
        for e in man["entries"]:
            if e["ray"] or entry_kind(e) == KIND_SCALAR:
                continue                      # the ray region moves every frame; it never fits
            d = entry_slice(e, vs, vr)
            tgt = far if e["label"].startswith(FAR_LABELS) else near
            for j in range(0, len(d) - 2, 3):
                q = d[j:j + 3]
                if np.all(np.isfinite(q)):    # a scene may hand back NaN for a missed ray
                    tgt.append(q)
        if not near:
            near = far
        if not near:
            return
        a = np.asarray(near, dtype=float)
        lo, hi = a.min(0), a.max(0)
        if far:
            b = np.asarray(far, dtype=float)
            lo2, hi2 = np.minimum(lo, b.min(0)), np.maximum(hi, b.max(0))
            if float(np.max(hi2 - lo2)) <= 1.6 * float(np.max(hi - lo)):
                lo, hi = lo2, hi2
        c = 0.5 * (lo + hi)
        # raylib's fovy is vertical: the visible height at a distance d is 0.93 d
        self.dist = float(np.clip(1.45 * float(np.max(hi - lo)), 4.0, 60.0))
        # and the HUD covers the top sixth, so the scene is aimed a little high in it
        self.target = [float(c[1]), float(c[2]) + 0.10 * self.dist, float(c[0])]
        self.pitch = 0.30         # a tall scene (the sun up, the pit down) needs a flatter eye
        if os.environ.get("SCENE_FIT_DEBUG"):
            print("scene fit: target %s  dist %.2f  box x[%.2f %.2f] y[%.2f %.2f] z[%.2f %.2f]"
                  % (np.round(self.target, 2).tolist(), self.dist,
                     lo[0], hi[0], lo[1], hi[1], lo[2], hi[2]))

    def draw(self, man, vs, vr, hud=(), ray_stride=1):
        rl = self.rl
        if not getattr(self, "_framed", False):
            self.frame_on(man, vs, vr)
            self._framed = True
        self.orbit()
        rl.begin_drawing()
        rl.clear_background(rl.Color(14, 16, 22, 255))
        # the sky: a gradient behind everything, so the machine stands under one
        rl.draw_rectangle_gradient_v(0, 0, self.width, self.height,
                                     rl.Color(*SKY_TOP, 255), rl.Color(*SKY_LOW, 255))
        rl.begin_mode_3d(self.cam)
        # the earth: the ground the building rises from, at the level the scene names, and the
        # deck's own grid over it
        gq = self._named(man, vs, vr, "ground")
        if gq is not None:
            self._mesh(gq, rl.Color(*GROUND), 10)
        dq = self._named(man, vs, vr, "deck")
        if dq is None:
            rl.draw_grid(24, 1.0)          # a scene with no deck keeps the old reference grid
        else:
            self._mesh(dq, rl.Color(116, 112, 104, 255), 12)
        # the panel as a surface: the four corners the scene names, two translucent triangles
        corners = {}
        for e in man["entries"]:
            if e["label"] in ("corner_pp", "corner_pm", "corner_mm", "corner_mp") and not e["ray"]:
                c = entry_slice(e, vs, vr)
                if np.all(np.isfinite(c[:3])):
                    corners[e["label"]] = self.v3(c[:3])
        if len(corners) == 4:
            pp, pm, mm, mp = corners["corner_pp"], corners["corner_pm"], corners["corner_mm"], corners["corner_mp"]
            face = rl.Color(120, 170, 230, 70)
            for tri in ((pp, pm, mm), (mm, mp, pp), (mm, pm, pp), (pp, mp, mm)):   # both windings
                rl.draw_triangle_3d(*tri, face)
        # the sun's body: a disc through its own rim, at the distance and half-angle the scene
        # computed - never a radius chosen here
        sc = ring0 = None
        for e in man["entries"]:
            if e["ray"]:
                continue
            if e["label"] == "sun":
                sc = entry_slice(e, vs, vr)[:3]
            elif e["label"] == "sun_rim_00":
                ring0 = entry_slice(e, vs, vr)[:3]
        if sc is not None and ring0 is not None and np.all(np.isfinite(sc)) and np.all(np.isfinite(ring0)):
            rl.draw_sphere(self.v3(sc), float(np.linalg.norm(np.asarray(ring0) - np.asarray(sc))),
                           rl.Color(*PALETTE[11], 255))
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
                    rl.draw_sphere(self.v3(r[0:3]), 0.035, col)
                elif k == KIND_SEGMENT:
                    # a member: a thin cylinder, so the machine reads as parts rather than
                    # hairlines.  Its radius follows the camera, because the composed scene is
                    # seen from three times as far as the machine-only one was and a 12 mm tube
                    # at that range is sub-pixel.
                    rr = max(0.012, 0.0022 * self.dist)
                    rl.draw_cylinder_ex(self.v3(r[0:3]), self.v3(r[3:6]), rr, rr, 6, col)
                elif k == KIND_RAY:
                    fc = FATE.get(int(round(r[9])) if len(r) > 9 else 3, (200, 200, 200))
                    hit, land = r[3:6], r[6:9]
                    o = r[0:3]
                    # the incoming leg drawn from 1.2 m above the facet, not from the sky
                    dirn = o - hit
                    n = float(np.linalg.norm(dirn))
                    if n > 1e-9:
                        o = hit + dirn / n * min(n, 1.2)
                    rl.draw_line_3d(self.v3(o), self.v3(hit), rl.Color(*fc, 160))
                    rl.draw_line_3d(self.v3(hit), self.v3(land), rl.Color(*fc, 255))
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

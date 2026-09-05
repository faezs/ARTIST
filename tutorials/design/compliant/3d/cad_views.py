#!/usr/bin/env python
"""Hidden-line engineering views of the stage-2 structures, straight from their CadQuery geometry.

Runs a model script, captures every CadQuery shape it hands to mesh_export.Scene (and the line parts it
appends), groups the parts by colour, projects ALL groups through one OCCT hidden-line projector (so a wire
behind a frame is hidden by that frame, whatever group it belongs to), and writes one square SVG sheet per
Scene: an isometric, an enlarged detail, and plan / front / side views each with its own scale bar, plus a
legend. A PNG is rasterised with macOS qlmanage when it is available (it always returns a square image,
which is why the sheet is square).

    python cad_views.py ../stage2/fold/model_fold.py
    python cad_views.py ../stage2/m5/model_m5.py          # writes one sheet per Scene the script wrote

Outputs land next to the model's JSON: <name>_views.svg / .png.
"""
import os, sys, time, runpy, math, re, subprocess, shutil
import cadquery as cq
from OCP.HLRBRep import HLRBRep_Algo, HLRBRep_HLRToShape
from OCP.HLRAlgo import HLRAlgo_Projector
from OCP.gp import gp_Ax2, gp_Pnt, gp_Dir
from OCP.BRepLib import BRepLib

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mesh_export

# ---------------------------------------------------------------- per-model presentation
# exclude: parts left out of the drawing (and of the occlusion) by name substring; context: parts drawn with
# visible lines only, lighter; detail: (x0,x1,y0,y1,z0,z1) box enlarged under the isometric.
CONFIG = {
    "fold_saddle": dict(title="Beam-down fold at F: the saddle lattice on the mirror's back",
                        iso=(1.0, -0.9, 0.45), context=("hood", "yoke frame"),
                        detail=(-135, 135, -140, 140, 66, 176), detail_label="detail: the lower two interfaces, wires between the frames"),
    "dish_pitch": dict(title="Dish pitch stage: a 2 m row of cross-axis blade cells",
                       iso=(1.0, -0.8, 0.5), exclude=("rim backing",),
                       detail=(-90, 90, -340, 20, -95, 95), detail_label="detail: three cells, blades crossing on the pitch axis"),
    "m5_pad": dict(title="M5 facet pad: six tangential wires, three screw contacts",
                   iso=(1.0, -0.9, 0.55), bounds_exclude=("axes",),
                   detail=(55, 125, -85, -15, -34, 14), detail_label="detail: one station, the wire pair and the adjuster"),
    "m5_patch": dict(title="M5 patch: 43 toroid facets on the pit truss (world frame)",
                     iso=(1.0, -0.9, 0.6), detail=None, bounds_exclude=("foci",)),
    "flower": dict(title="Pneumatic sunflower, D 2.1 m: hose mast, vine neck, skin head, beam down the stem",
                   iso=(1.0, -1.0, 0.5), bounds_exclude=("sun",), context=("winch", "cable"),
                   detail=(-500, 1000, -450, 450, 400, 2000), detail_label="detail: neck, M3 at the vertex hole, M4 at the mast top, the chord"),
    "bouquet": dict(title="Bouquet: four 2.1 m flowers around one oven chamber (13.9 m2, today's collector area)",
                    iso=(1.0, -1.0, 0.6), detail=None, bounds_exclude=("sun",)),
    "flower_scales": dict(title="The same module at 1.4, 2.1 and 4.2 m: constant pressure, constant safety factor",
                          iso=(1.0, -1.0, 0.5), detail=None, bounds_exclude=("sun",)),
    "hp_equinox_noon": dict(title="Cassegrain Hashemi machine on the pneumatic mount: equinox noon, sun el 60 deg south",
                            iso=(-1.0, -1.0, 0.55), bounds_exclude=("sun", "env's", "guy", "suspension"), context=("deck", "wall", "column", "pot", "reel", "env's"),
                            detail=(1500, 4500, -1500, 1500, 5000, 7800), detail_label="detail: the root, the vine rod, the spreader ring and the attitude tendons"),
    "hp_summer_noon": dict(title="Summer noon, sun el 83 deg: the dish under F, the beam through its hole and slot", iso=(-1.0, -1.0, 0.55),
                           bounds_exclude=("sun", "env's", "guy", "suspension"), context=("deck", "wall", "column", "pot", "reel", "env's"), detail=None),
    "hp_morning": dict(title="Equinox 9 h, sun el 38 deg east-south-east: the rod at full reach to the west", iso=(-1.0, -1.0, 0.55),
                       bounds_exclude=("sun", "env's", "guy", "suspension"), context=("deck", "wall", "column", "pot", "reel", "env's"), detail=None),
    "hp_sweep": dict(title="The orbit the mount serves: rim positions and rod lines through an equinox day", iso=(-1.0, -1.0, 0.7),
                     bounds_exclude=("sun", "env's", "guy", "suspension"), context=("deck", "wall", "column", "pot", "env's"), detail=None),
    "hp2_equinox_noon": dict(title="Screw-designed mount, equinox noon: bridle through F, flexing stem, antagonist tendons, focal tube",
                             iso=(-1.0, -1.0, 0.55), bounds_exclude=("sun",), context=("deck", "wall", "column", "pot", "root"),
                             detail=(-500, 4500, -3500, 3500, 5000, 10200), detail_label="detail: focal tube and strip, bridle apex at F, stem clamp, outrigger ring"),
    "hp2_summer_noon": dict(title="Screw-designed mount, summer noon: the tube through the slot, the stem short and upright", iso=(-1.0, -1.0, 0.55),
                            bounds_exclude=("sun",), context=("deck", "wall", "column", "pot", "root"), detail=None),
    "hp2_morning": dict(title="Screw-designed mount, equinox 9 h: the stem flexed at full reach, bridle still through F", iso=(-1.0, -1.0, 0.55),
                        bounds_exclude=("sun",), context=("deck", "wall", "column", "pot", "root"), detail=None),
    "hp2_sweep": dict(title="Equinox day: rims, stem axes and bridle lines, all converging on F", iso=(-1.0, -1.0, 0.7),
                      bounds_exclude=("sun",), context=("deck", "wall", "column", "pot"), detail=None),
}
DASHED = ("axis", "axes", "foci", "sun direction", "env's")          # line parts drawn dashed in their own colour, never hidden


# ---------------------------------------------------------------- capture the geometry a model script builds
def capture(script):
    """Run the script; return [(json_path, bodies[(name,color,shape)], lineparts[dict])] per Scene written."""
    rec, order = {}, []
    orig_add, orig_write = mesh_export.Scene.add, mesh_export.Scene.write

    def add(self, shape, name, color="#9aa5b1", *a, **k):
        rec.setdefault(id(self), []).append((name, color, shape))
        return orig_add(self, shape, name, color, *a, **k)

    def write(self, path):
        order.append((path, self)); return orig_write(self, path)

    mesh_export.Scene.add, mesh_export.Scene.write = add, write
    script = os.path.abspath(script)
    cwd = os.getcwd(); os.chdir(os.path.dirname(script))
    try:
        runpy.run_path(script, run_name="__main__")
    finally:
        os.chdir(cwd); mesh_export.Scene.add, mesh_export.Scene.write = orig_add, orig_write
    out = []
    for path, sc in order:
        lines = [p for p in sc.parts if "lines" in p]
        out.append((path, rec.get(id(sc), []), lines))
    return out


def group_parts(bodies, lineparts, cfg):
    """One group per colour; solids merged into a compound, line parts into an edge compound. Legend labels
    collapse numbered names ('blade 0'..'blade 23' -> 'blade (24)')."""
    excl = tuple(s.lower() for s in cfg.get("exclude", ()))
    ctx = tuple(s.lower() for s in cfg.get("context", ()))
    groups = {}
    for name, color, shape in bodies:
        if any(s in name.lower() for s in excl): continue
        g = groups.setdefault(color, dict(color=color, names=[], solids=[], edges=[], kind="body"))
        g["names"].append(name); g["solids"].append(shape)
    for p in lineparts:
        if any(s in p["name"].lower() for s in excl): continue
        g = groups.setdefault(p["color"], dict(color=p["color"], names=[], solids=[], edges=[], kind="lines"))
        g["names"].append(p["name"])
        for a, b in p["lines"]:
            if a == b: continue
            g["edges"].append(cq.Edge.makeLine(cq.Vector(*a), cq.Vector(*b)))
    out = []
    for g in groups.values():
        items = [s if isinstance(s, cq.Shape) else s.val() for s in g["solids"]] + g["edges"]
        g["shape"] = cq.Compound.makeCompound(items) if len(items) != 1 else items[0]
        base = [re.sub(r"(\s+(\d+|[A-Z]\d+))+\s*$", "", n) for n in g["names"]]
        seen = []
        for b in base:
            if b not in seen: seen.append(b)
        lab = []
        for b in seen:
            n = base.count(b); lab.append(f"{b} ({n})" if n > 1 else b)
        g["label"] = "; ".join(lab)
        if len(g["label"]) > 92: g["label"] = g["label"][:89] + "..."
        joined = " ".join(g["names"]).lower()
        g["dashed"] = g["kind"] == "lines" and any(k in joined for k in DASHED)
        g["context"] = any(s in joined for s in ctx)
        out.append(g)
    return out


# ---------------------------------------------------------------- hidden-line projection
def unit(v):
    n = math.sqrt(sum(x * x for x in v)); return tuple(x / n for x in v)


def cross(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def view_axes(N, up=(0, 0, 1)):
    N = unit(N)
    X = cross(up, N)
    if math.sqrt(sum(x * x for x in X)) < 1e-9:      # plan view: looking along z
        X = (1.0, 0.0, 0.0)
    return N, unit(X)


def polylines(compound, n=24):
    """Discretise an HLR output compound (edges lying in the projection plane) into 2-D polylines."""
    if compound is None or compound.IsNull(): return []
    BRepLib.BuildCurves3d_s(compound, 1e-3)
    out = []
    for e in cq.Shape.cast(compound).Edges():
        try:
            if e.geomType() == "LINE":
                pts = [e.startPoint(), e.endPoint()]
            else:
                pts = [e.positionAt(i / n) for i in range(n + 1)]
        except Exception:
            continue
        out.append([(p.x, p.y) for p in pts])
    return out


def project(groups, N, X):
    """Global HLR of every group at once; per group -> (visible polylines, hidden polylines)."""
    algo = HLRBRep_Algo()
    for g in groups: algo.Add(g["shape"].wrapped)
    algo.Projector(HLRAlgo_Projector(gp_Ax2(gp_Pnt(0, 0, 0), gp_Dir(*N), gp_Dir(*X))))
    algo.Update(); algo.Hide()
    h = HLRBRep_HLRToShape(algo)
    res = []
    for g in groups:
        s = g["shape"].wrapped
        vis = polylines(h.VCompound(s)) + polylines(h.Rg1LineVCompound(s)) + polylines(h.OutLineVCompound(s))
        hid = polylines(h.HCompound(s)) + polylines(h.Rg1LineHCompound(s)) + polylines(h.OutLineHCompound(s))
        if g["dashed"]:
            vis, hid = vis + hid, []
        if g["context"]:
            hid = []
        res.append((vis, hid))
    return res


def bounds(res, groups, exclude=()):
    xs, ys = [], []
    for g, (vis, hid) in zip(groups, res):
        if any(k in g["label"].lower() for k in exclude): continue
        for pl in vis + hid:
            for x, y in pl: xs.append(x); ys.append(y)
    return min(xs), max(xs), min(ys), max(ys)


def project_point(p, N, X):
    Y = cross(N, X)
    return (sum(a * b for a, b in zip(p, X)), sum(a * b for a, b in zip(p, Y)))


# ---------------------------------------------------------------- SVG sheet
def stroke_colour(hexcol):
    """Near-white model colours (mirror faces) vanish in a line drawing: blend them toward slate for strokes."""
    r, g, b = (int(hexcol[i:i + 2], 16) for i in (1, 3, 5))
    lum = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    if lum < 0.72: return hexcol
    t = 0.55
    r, g, b = (round(c * (1 - t) + k * t) for c, k in zip((r, g, b), (0x4b, 0x55, 0x63)))
    return f"#{r:02x}{g:02x}{b:02x}"


def path_d(pl):
    return "M" + " L".join(f"{x:.2f},{y:.2f}" for x, y in pl)


def view_svg(res, groups, cell, scale, centre, clip_id, stroke_body=0.9, stroke_line=1.5):
    ox, oy, w, h = cell
    cx, cy = centre
    parts = [f'<g clip-path="url(#{clip_id})"><g transform="translate({ox + w / 2:.1f},{oy + h / 2:.1f}) scale({scale:.6f},{-scale:.6f}) translate({-cx:.3f},{-cy:.3f})">']
    for g, (vis, hid) in zip(groups, res):
        sw = stroke_line if g["kind"] == "lines" else stroke_body
        col = stroke_colour(g["color"])
        if hid:
            if g["kind"] == "lines":     # a wire behind a frame: same colour, lighter, unbroken, so the lattice reads whole
                parts.append(f'<path d="{" ".join(path_d(pl) for pl in hid)}" fill="none" stroke="{col}" stroke-opacity="0.38" stroke-width="{sw:.2f}" stroke-linecap="round" vector-effect="non-scaling-stroke"/>')
            else:
                parts.append(f'<path d="{" ".join(path_d(pl) for pl in hid)}" fill="none" stroke="{col}" stroke-opacity="0.30" stroke-width="{sw * 0.7:.2f}" stroke-dasharray="4 3" vector-effect="non-scaling-stroke"/>')
        if vis:
            dash = ' stroke-dasharray="8 5"' if g["dashed"] else ""
            op = ' stroke-opacity="0.55"' if g["context"] else ""
            parts.append(f'<path d="{" ".join(path_d(pl) for pl in vis)}" fill="none" stroke="{col}" stroke-width="{sw:.2f}"{dash}{op} stroke-linecap="round" stroke-linejoin="round" vector-effect="non-scaling-stroke"/>')
    parts.append("</g></g>")
    return "\n".join(parts)


def fit(b, w, h, pad=0.07):
    x0, x1, y0, y1 = b
    ex, ey = max(x1 - x0, 1e-6), max(y1 - y0, 1e-6)
    return min(w * (1 - 2 * pad) / ex, h * (1 - 2 * pad) / ey), ((x0 + x1) / 2, (y0 + y1) / 2)


def nice_bar(px_per_mm, target_px):
    for L in (1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000):
        if L * px_per_mm >= target_px: return L
    return 2000


def scale_bar(svg, cell, s):
    x, y, w, h = cell
    L = nice_bar(s, 70)
    bx, by = x + w - 24 - L * s, y + h - 18
    svg.append(f'<line x1="{bx:.1f}" y1="{by:.1f}" x2="{bx + L * s:.1f}" y2="{by:.1f}" stroke="#111827" stroke-width="2"/>')
    svg.append(f'<line x1="{bx:.1f}" y1="{by - 4:.1f}" x2="{bx:.1f}" y2="{by + 4:.1f}" stroke="#111827" stroke-width="1.5"/>')
    svg.append(f'<line x1="{bx + L * s:.1f}" y1="{by - 4:.1f}" x2="{bx + L * s:.1f}" y2="{by + 4:.1f}" stroke="#111827" stroke-width="1.5"/>')
    svg.append(f'<text x="{bx + L * s / 2:.1f}" y="{by - 7:.1f}" font-size="16" fill="#111827" text-anchor="middle">{L} mm</text>')


def sheet(name, groups, cfg, out_svg):
    S = 1700                                  # square sheet (qlmanage rasterises square)
    M, header, legend_h = 24, 64, 30 + 24 * math.ceil(len(groups) / 2)
    views = [("isometric", cfg["iso"]), ("plan (from +z)", (0, 0, 1)), ("front (from -y)", (0, -1, 0)), ("side (from +x)", (1, 0, 0))]
    proj = {}
    for label, N in views:
        Nn, X = view_axes(N)
        t = time.time(); res = project(groups, Nn, X); proj[label] = (res, Nn, X)
        print(f"  {label:16s} {sum(len(v) + len(h) for v, h in res):6d} polylines  {time.time() - t:5.1f} s")
    excl = cfg.get("bounds_exclude", ())
    body_h = S - header - legend_h - 3 * M
    left_w = 1040
    right_x = M + left_w + M
    right_w = S - right_x - M
    cell_h_r = (body_h - 2 * 10) / 3
    cells_r = [(right_x, header + M + i * (cell_h_r + 10), right_w, cell_h_r) for i in range(3)]
    has_det = bool(cfg.get("detail"))
    iso_h = body_h if not has_det else body_h * 0.60
    cell_iso = (M, header + M, left_w, iso_h)
    cell_det = (M, header + M + iso_h + 10, left_w, body_h - iso_h - 10) if has_det else None
    ortho = [l for l, _ in views[1:]]
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{S}" height="{S}" viewBox="0 0 {S} {S}" font-family="Helvetica, Arial, sans-serif">',
           f'<rect width="{S}" height="{S}" fill="#ffffff"/>', "<defs>"]
    allcells = [("iso", cell_iso)] + [(f"o{i}", c) for i, c in enumerate(cells_r)] + ([("det", cell_det)] if has_det else [])
    for cid, (x, y, w, h) in allcells:
        svg.append(f'<clipPath id="clip_{cid}"><rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}"/></clipPath>')
    svg.append("</defs>")
    svg.append(f'<text x="{M}" y="40" font-size="32" font-weight="bold" fill="#1f2937">{cfg["title"]}</text>')
    svg.append(f'<text x="{S - M}" y="{S - 6}" font-size="14" fill="#9ca3af" text-anchor="end">hidden-line projection of the CadQuery model · {name} · mm</text>')

    def frame(c, label):
        svg.append(f'<rect x="{c[0]:.1f}" y="{c[1]:.1f}" width="{c[2]:.1f}" height="{c[3]:.1f}" fill="none" stroke="#d1d5db"/>')
        svg.append(f'<text x="{c[0] + 12:.1f}" y="{c[1] + 28:.1f}" font-size="21" fill="#374151">{label}</text>')

    # isometric
    res, Nn, X = proj["isometric"]
    s_iso, c_iso = fit(bounds(res, groups, excl), cell_iso[2], cell_iso[3])
    frame(cell_iso, f'isometric, view direction ({", ".join(f"{v:g}" for v in cfg["iso"])})')
    svg.append(view_svg(res, groups, cell_iso, s_iso, c_iso, "clip_iso"))
    scale_bar(svg, cell_iso, s_iso)
    # detail
    if has_det:
        x0, x1, y0, y1, z0, z1 = cfg["detail"]
        pp = [project_point((x, y, z), Nn, X) for x in (x0, x1) for y in (y0, y1) for z in (z0, z1)]
        b = (min(p[0] for p in pp), max(p[0] for p in pp), min(p[1] for p in pp), max(p[1] for p in pp))
        s_det, c_det = fit(b, cell_det[2], cell_det[3], pad=0.03)
        frame(cell_det, f'{cfg.get("detail_label", "detail")} · {s_det / s_iso:.1f}x')
        svg.append(view_svg(res, groups, cell_det, s_det, c_det, "clip_det", stroke_body=1.1, stroke_line=2.0))
        scale_bar(svg, cell_det, s_det)
        cx, cy = cell_iso[0] + cell_iso[2] / 2, cell_iso[1] + cell_iso[3] / 2
        rx0, ry0 = cx + s_iso * (b[0] - c_iso[0]), cy - s_iso * (b[3] - c_iso[1])
        svg.append(f'<rect x="{rx0:.1f}" y="{ry0:.1f}" width="{s_iso * (b[1] - b[0]):.1f}" height="{s_iso * (b[3] - b[2]):.1f}" fill="none" stroke="#0e7490" stroke-dasharray="5 4"/>')
    # orthographic views, each at its own scale with its own bar
    for i, (l, c) in enumerate(zip(ortho, cells_r)):
        res, Nn, X = proj[l]
        s, centre = fit(bounds(res, groups, excl), c[2], c[3])
        frame(c, l)
        svg.append(view_svg(res, groups, c, s, centre, f"clip_o{i}"))
        scale_bar(svg, c, s)
    # legend strip
    ly0 = S - M - legend_h + 18
    svg.append(f'<text x="{M}" y="{ly0 - 2}" font-size="15" fill="#6b7280">solid: visible edges · dashed: hidden edges · lighter unbroken orange: wires behind a frame · lighter grey: context parts, visible edges only</text>')
    for i, g in enumerate(groups):
        col, row = i % 2, i // 2
        x = M + col * (S - 2 * M) / 2; y = ly0 + 24 + 24 * row
        svg.append(f'<rect x="{x:.1f}" y="{y - 13}" width="16" height="13" fill="{g["color"]}"/>')
        svg.append(f'<text x="{x + 23:.1f}" y="{y}" font-size="17" fill="#374151">{g["label"]}</text>')
    svg.append("</svg>")
    open(out_svg, "w").write("\n".join(svg))
    print("wrote", out_svg, os.path.getsize(out_svg) // 1024, "KB")


def rasterise(svg_path, px=2400):
    if not shutil.which("qlmanage"): return None
    d = os.path.dirname(svg_path)
    subprocess.run(["qlmanage", "-t", "-s", str(px), "-o", d, svg_path], capture_output=True)
    src = svg_path + ".png"; dst = svg_path[:-4] + ".png"
    if os.path.exists(src):
        os.replace(src, dst); print("wrote", dst, os.path.getsize(dst) // 1024, "KB"); return dst
    return None


if __name__ == "__main__":
    script = sys.argv[1]
    for json_path, bodies, lineparts in capture(script):
        name = os.path.splitext(os.path.basename(json_path))[0]
        cfg = CONFIG.get(name, dict(title=name, iso=(1.0, -1.0, 0.8)))
        groups = group_parts(bodies, lineparts, cfg)
        print(f"{name}: {len(bodies)} solids, {sum(len(p['lines']) for p in lineparts)} lines, {len(groups)} groups")
        out_svg = os.path.join(os.path.dirname(json_path), name + "_views.svg")
        sheet(name, groups, cfg, out_svg)
        rasterise(out_svg)

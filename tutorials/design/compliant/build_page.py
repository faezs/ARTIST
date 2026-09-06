"""Assemble the drawing-register page: inline every plate SVG next to
its title block. Run from tutorials/design/compliant; writes
flexure_register.html into the given output dir."""
import re, os, sys, html, json
OUT = sys.argv[1]; FIG = "figures"
def svg(name):
    if name.endswith(".png"):                                   # raster sheets (the tree's hidden-line SVGs are too large for the page)
        import base64
        return '<img style="width:100%;height:auto;display:block" src="data:image/png;base64,' + base64.b64encode(open(name, "rb").read()).decode() + '">'
    s = open(os.path.join(FIG, name) if not name.startswith(("fact/", "stage2/", "stage3/")) else name).read()
    s = s[s.index("<svg"):]
    s = re.sub(r'<svg([^>]*?)\swidth="[^"]*"\sheight="[^"]*"', r'<svg\1', s, count=1)
    s = s.replace("<svg", '<svg style="width:100%;height:auto;display:block"', 1)
    return re.sub(r"(-?\d+\.\d{2,})", lambda m: f"{float(m.group(1)):.1f}", s)
def plate(num, title, fig, ref, rows, note=""):
    tb = "".join(f'<div class="k">{html.escape(k)}</div><div class="v">{v}</div>' for k, v in rows)
    return f'''<article class="plate" id="pl{num}">
  <div class="paper">{svg(fig)}</div>
  <aside class="block">
    <div class="sheet">SHEET {num:02d}</div>
    <h3>{html.escape(title)}</h3>
    <div class="ref">{html.escape(ref)}</div>
    <div class="tb">{tb}</div>
    {f'<p class="note">{note}</p>' if note else ''}
  </aside>
</article>'''
VIEWER_JS = open(os.path.join("3d", "viewer.js")).read()
def plate3d(num, title, json_path, ref, rows, note="", model_js=None, export=None):
    model = model_js if model_js else open(json_path).read()
    if export: model = f"window.{export} = " + model
    tb = "".join(f'<div class="k">{html.escape(k)}</div><div class="v">{v}</div>' for k, v in rows)
    vid = f"view{num}"
    return f'''<article class="plate" id="pl{num}">
  <div class="paper paper3d"><div class="view3d" id="{vid}"></div><div class="hint">drag to orbit · shift-drag or right-drag to pan · wheel to zoom</div></div>
  <aside class="block">
    <div class="sheet">SHEET {num:02d} · 3-D</div>
    <h3>{html.escape(title)}</h3>
    <div class="ref">{html.escape(ref)}</div>
    <div class="tb">{tb}</div>
    {f'<p class="note">{note}</p>' if note else ''}
  </aside>
</article>
<script>(function(){{ const model = {model}; const el = document.getElementById("{vid}"); const go = () => mountViewer(el, model, {{up:'z'}}); if (window.THREE) go(); else window.addEventListener('load', go); }})();</script>'''
S = []
S.append(plate(1, "Pitch stage: two cross-axis flexural pivots", "dish_cross_axis_pivot.svg", "Handbook A.1.10 cross-axis flexural pivot, p. 74; §11.1.2 revolute elements",
  [("part", "primary dish yoke, 2 pivots at ±0.8 m"), ("leaves", "300 × 2.0 × 150 mm, 17-7PH CH900"), ("stiffness", "272 N·m/rad per pivot"), ("range", "0–36° (neutral offset −18°)"),
   ("stress @36°", "427 MPa, SF 3.5 on yield"), ("survival 25 m/s", "687 MPa, SF 2.2"), ("centre shift", "≤ 10 mm"), ("hold / drive", "Tr20×4 screw on 0.8 m lever, 0.29° per turn")],
  "Gives the dish the β/2 tilt the shadow-slide needs; the return moment never changes sign across the range."))
S.append(plate(2, "Rim as the toroid squeeze", "dish_rim_toroid_squeeze.svg", "Handbook A.1.6 initially curved beam, p. 70",
  [("ring", "60 × 2 mm galvanised tube, 38 kg, buckling SF 5"), ("law", "a/b = 1 / cos(β/2)"), ("as built", "3.3 % ellipse"), ("squeeze", "±1.5 % (±33 mm), 0.73–0.89 kN"),
   ("covers", "β = 20–36°"), ("limit", "film pretension strain 1.08 %, slack at 3.0 %"), ("links", "Tr10×2 screw + fixed link on the pitch axis; 2 radially soft blades")],
  "The film, not the ring, sets the stroke. Ellipticity is drawn to true scale with a 10× exaggerated overlay."))
S.append(plate(3, "Arc-rail roller suspension", "dish_roller_suspension.svg", "Handbook 12.2.4 parallel motion, p. 214",
  [("count", "4, one per Hashemi bearing"), ("blades", "150 × 1.5 × 80 mm, 17-7PH"), ("stiffness", "32.6 kN/m"), ("preload", "400 N"), ("rail waviness", "±3 mm → Goodman 0.61, SF 1.6 infinite life")],
  "The 6.6 m arc travel must roll; the flexure carries the roller so the bearing never sees the rail's waviness."))
S.append(plate(4, "Bistable arch wind trip", "dish_bistable_wind_trip.svg", "Handbook 12.3.2 stability, p. 252; 4.4.2 fixed-guided bistable beam, p. 49",
  [("input", "0.25 m² drag plate: 14.6 N at 9 m/s"), ("snap", "~10 N + 5 N bias"), ("hysteresis", "trips at 9, resets at 7 m/s, no electronics"), ("action", "dump beam (vent membrane), stow latch takes the survival load"),
   ("drawn", "span 200, rise 12, t 0.8 mm: illustrative proportions")]))
S.append(plate(5, "Fold tilt pivot, wire-EDM monolith", "fold_cross_axis_pivot.svg", "Handbook A.1.10 cross-axis flexural pivot, p. 74",
  [("block", "90 × 90 × 40 mm Ti-6Al-4V, ×2"), ("blades", "0.6 × 40 × 60 mm crossing at 90°"), ("stiffness", "5.5 N·m/rad total"), ("neutral / stops", "33° / 13° and 42.5°"),
   ("stress @stop", "200 MPa = 0.25 σy at 120 °C"), ("fatigue", "~15 k cycles in 20 yr: unlimited"), ("centre shift", "0.4–0.7 mm, no pointing error for a flat")],
  "Remote centre lies in the mirror face plane, so the spot does not walk as the mirror tilts."))
S.append(plate(6, "Cartwheel alternative", "fold_cartwheel_alternative.svg", "Handbook A.1.11 cartwheel flexure, p. 76",
  [("status", "drop-in alternative"), ("pro", "smaller centre shift"), ("con", "hub sits where the face-plane centre must be")]))
S.append(plate(7, "Beam-down fold assembly", "fold_assembly_side.svg", "Fold law nf ∝ ub + ẑ (tandoor_mount_batch.mount_batch)",
  [("tilt", "45° − el_b/2 → 15–41° working"), ("azimuth", "inherited from the carriage bearing"), ("mirror", "6061-T6 0.36 × 0.44 m, 12 mm + integral fins, protected silver"),
   ("thermal", "+35 K at 210 W passive; water jacket reserved for 9 kW"), ("hood rim", "40 mm insulating firebrick"), ("drive", "stepper + 2 mm lead screw, 0.07 mrad/step"),
   ("preload", "gravity, 1.7–1.85 N·m toward the park stop"), ("fail-safe", "solenoid pawl + 200 °C snap-disc, parks at 42.5° in 0.2 s")]))
S.append(plate(8, "Facet foot carriage", "m5_carriage_parallel_motion.svg", "Handbook 12.2.4 parallel motion, p. 214; A.1.4 fixed-guided beam, p. 69",
  [("blades", "12 × 0.5 × 60 mm, ×2 per foot"), ("adjuster", "M6×1 in brass nut, ball tip on hardened pad"), ("detent", "24 clicks → 0.28 mrad per click"), ("range", "±30 mrad"), ("preload", "40 N, holds to 47 m/s hatch-open wind")],
  "Position is a hard contact: the held alignment never relies on a stressed flexure (Handbook p. 7)."))
S.append(plate(9, "Facet on three bipod feet", "m5_facet_feet.svg", "Handbook §11.1.4 universal elements, p. 181; Ch. 6 FACT flexure ball joint, p. 87",
  [("facet", "1.5 mm anodised Al, pressed toroid, 0.32 m hex, ×43"), ("feet", "129, each one folded 0.5 mm 301 blank"), ("strips", "2.5 × 0.5 × 40 mm bipod"),
   ("constraint", "normal + tangent held, radial free: exact, athermal"), ("stress", "62 / 125 / 375 MPa at 5 / 10 / 30 mrad"), ("thermal tilt", "0.02 mrad per mount")],
  "Rolled single-curvature strips would carry 25–93 mrad of slope error; the facets must be pressed toroids."))
FACT = []
def fact(num, title, fig, ref, rows, note=""):
    return plate(num, title, "fact/figures/" + fig, ref, rows, note)
FACT.append(fact(1, "Fold tilt: remote axis in the mirror face plane", "fact_fold_remote_axis.svg", "Freedom space: 1 rotation. Constraint space: every line meeting the axis (Hopkins, Handbook ch. 6)",
  [("elements", "5 wire flexures"), ("arrangement", "two A-frames standing across the axis, apexes on it; one diagonal stay through F"), ("check", "rank 5, 1 DOF left: rotation about the face-plane axis"),
   ("why", "the axis is material-free, so it sits in the reflective plane at the focal spot"), ("caught", "A-frames in planes containing the axis share the axis line: rank 3")],
  "The first-pass cross-axis blades put a pivot block at each end of the axis; this puts nothing there."))
FACT.append(fact(2, "Dish pitch: constraint planes, stages in series", "fact_dish_pitch_series.svg", "Freedom space: 1 rotation about the pitch axis through the CG. Constraint space: lines meeting the axis, realised as blade planes",
  [("one stage", "two blade planes containing the axis: 6 lines, rank 5"), ("series", "two identical stages about one axis through an intermediate body: still 1 DOF, double range"),
   ("principle", "the butterfly / RCC-series pivots (CSEM ±15°, LAFP ±90°) extend range exactly this way"), ("load", "blades keep the capacity wires cannot")]))
FACT.append(fact(3, "Facet mount: three tangential wires, three screws", "fact_facet_tangential_wires.svg", "Freedom space: tip + tilt + piston. Constraint space: every line in the facet plane",
  [("flexure", "3 wires tangential to a 130 mm circle, in the facet plane"), ("check", "rank 3: exactly the three adjusted freedoms left; in-plane motions and spin held"),
   ("adjusters", "3 screw contacts along the normal take those 3 freedoms: 6 constraints, 0 DOF, adjustable"), ("thermal", "radial expansion only bends the wires; symmetric, no tilt")],
  "Replaces three bipod-and-carriage assemblies per facet with three wires and three screws."))
C = []
def cad(num, title, fig, rows, note=""):
    return plate(num, title, fig, "Parametric solid, cadquery 2.8; isometric line render, hidden lines removed; dimensions as designed", rows, note)
C.append(cad(10, "Pitch stage, solids", "cad_dish_pitch_stage.svg", [("yoke", "1.8 m beam between the two leaf pivots"), ("pivots", "leaves 300 × 2.0 × 150 mm crossing at 90°"), ("above", "rim attachment stub")]))
C.append(cad(11, "Wind trip, solids", "cad_dish_wind_trip.svg", [("arch", "span 200, rise 12, t 0.8 mm (illustrative proportions)"), ("plate", "0.25 m² drag plate on a stem"), ("posts", "clamped ends")]))
C.append(cad(12, "Fold tilt pivot, wire-EDM monolith", "cad_fold_cross_axis_pivot.svg", [("block", "90 × 90 × 40 mm Ti-6Al-4V"), ("blades", "0.6 mm, crossing at 90°; head carried by the blades alone"), ("cut", "wire-EDM slots from one billet")]))
C.append(cad(13, "Fold assembly, solids", "cad_fold_assembly.svg", [("mirror", "0.36 × 0.44 m elliptical 6061 plate, 12 mm, 17 integral fins"), ("pivots", "two 90 mm blocks on the back, in the face plane"), ("hood", "ring 0.66 m over the mirror on a two-arm yoke")]))
C.append(cad(14, "Facet on its feet, from above and below", "cad_m5_facet_feet.svg", [("facet", "0.30 m, 1.5 mm, with the rib cross"), ("feet", "three bipods on parallel-motion carriages, M6 adjusters"), ("frame", "0.38 m sub-frame plate")]))
C.append(cad(15, "Facet feet, underside", "cad_m5_feet_underside.svg", [("view", "from below: the three carriages, their blades and the bipod strips"), ("constraint", "each foot holds normal + tangent, free radially")]))
D3 = []
D3.append(plate3d(20, "Fold saddle: DCM block, one rotation about the face-plane axis", "stage2/fold/out/fold_saddle.json",
  "Second pass. dcm_core stack: 4 interfaces x 40 oblique Ti wires, all meeting the y axis through F; frame FE for stiffness",
  [("block", "400 x 200 x 220 mm, 5 open Ti frames, 4 gaps of 40 mm"), ("wires", "160 x d 1.0 mm Ti-6Al-4V, 5 per 100 mm cell"), ("check", "rank 5 per interface, stack DOF 1 about F's face-plane axis"),
   ("range", "7.6 deg per interface at 190 MPa -> 30.6 deg; working 27 deg"), ("K_theta", "87 N m/rad; 41 N m at 27 deg; 9.7 J stored"), ("stiff dirs", "2.4-7.4 kN/mm; 65-88 kN m/rad; ratio 5e-5"),
   ("first mode", "4.1 Hz with the 7.5 kg mirror"), ("redundancy", "one wire lost: 2.5 % stiffness, no new DOF"), ("thermal +40 K", "axis moves 0.06 mm, no tilt"), ("safe state", "neutral = park stop: power loss returns to park")],
  "Orange lines are the wires; grey frames the rigid layers; the light plate with fins is the mirror, face down; the ring is the hood; teal is the tilt axis in the face plane."))

def legend(json_path):
    import json as _json
    parts = _json.load(open(json_path))["parts"]; seen = []
    for p in parts:
        key = re.sub(r"(\s+(\d+|[A-Z]\d+))+\s*$", "", p["name"])
        for s in seen:
            if s[0] == key: s[2] += 1; break
        else: seen.append([key, p.get("color", "#888"), 1])
    return "Legend: " + "; ".join(f'<span style="display:inline-block;width:10px;height:10px;border-radius:2px;vertical-align:middle;background:{c}"></span> {html.escape(k)}{f" ({n})" if n > 1 else ""}' for k, c, n in seen)

D3.append(plate(21, 'Fold saddle: engineering views', 'stage2/fold/out/fold_saddle_views.svg', 'isometric (1, -0.9, 0.45), detail of the lower two interfaces, plan, front, side', [('shows', 'five Ti frames with their windows, 160 oblique wires in four 40 mm gaps, the mirror plate face-down below, the hood ring and yoke frame as context'), ('axis', 'teal dashed: the tilt axis in the face plane through F; nothing of the structure lies on it'), ('side view', "each interface's wires cross in X pairs: the two plane families of the 1R cell")], "Hidden-line projection of the same CadQuery model as the plate above (3d/cad_views.py): solid = visible edges, dashed = hidden, lighter orange = wires behind a frame, lighter grey = context parts. Each view carries its own scale bar."))
D3.append(plate3d(22, "Dish pitch stage: a 2 m distributed cross-axis blade bearing", "stage2/dish/out/dish_pitch.json",
  "Second pass. 12 cells x 2 blades 17-7PH crossing ON the pitch axis through the CG; blade beams in the frame FE match the PRBM 2EI/L",
  [("row", "yoke beam 40 x 60 below, rim carrier 40 x 60 above, 85 mm gap, 1.98 m along the axis"), ("blades", "24 x 150 x 0.8 mm, 120 mm at +-45 deg, 165 mm pitch"), ("check", "rank 5 / DOF 1: rotation about the crossing line"),
   ("range", "38 deg from neutral at 0.30 sigma_y; working +-18 deg at 213 MPa = 0.14 sigma_y"), ("K_theta", "261 N m/rad; 82 N m at 18 deg; actuator 512 N m = 640 N on the 0.8 m lever"), ("stiff dirs", "2.4 MN/mm across, 7.6 MN/mm along; ratio 9e-9"),
   ("buckling", "P_cr 3.57 kN per blade: SF 52 working, 12.5 survival"), ("first mode", "0.19 Hz free on the blades (140 kg dish); tens of Hz on the locked screw"), ("redundancy", "one blade lost: 4.2 % stiffness, no new DOF"), ("thermal +40 K", "axis stays on the crossing line; 1.0 mm Al/steel relief at the rim bolts")],
  legend("stage2/dish/out/dish_pitch.json")))
D3.append(plate(23, 'Dish pitch stage: engineering views', 'stage2/dish/out/dish_pitch_views.svg', 'isometric (1, -0.8, 0.5), detail of three cells, plan, front (end view), side; rim backing omitted', [('shows', 'the yoke beam below and the rim carrier above, 24 blades in 12 cells crossing on the teal pitch axis'), ('end view', 'the blade X between the two 40 x 60 beams across the 85 mm gap'), ('scale', 'the 2 m side view and the 160 mm end view each carry their own bar')], "Hidden-line projection of the same CadQuery model as the plate above (3d/cad_views.py): solid = visible edges, dashed = hidden, lighter orange = wires behind a frame, lighter grey = context parts. Each view carries its own scale bar."))
D3.append(plate3d(24, "M5 facet pad: six tangential wires, three contacts, one spring", "stage2/m5/out/m5_pad.json",
  "Second pass. Exact-constraint adjustable mount: the wires leave tip, tilt and piston (rank 3), the screw contacts take them (rank 6)",
  [("wires", "6 x Ti-6Al-4V d 1.0 x 65 mm, pairs 6 mm apart at three stations, r 100 mm"), ("contacts", "3 x M6 fine adjusters, ball tips on the same circle; 120 N Inconel coil preload"), ("check", "wires: rank 3 / DOF 3 (tip, tilt, piston); with contacts rank 6 / DOF 0"),
   ("window", "+-15 mrad, +-2 mm held 20 yr at 121-162 MPa = 0.17-0.22 sigma_y(200 C)"), ("in-plane", "each wire 1.4 kN/mm axial; 49 N gust moves the facet 12 um"), ("buckling", "8.2 N per wire vs P_cr 27 N: SF 3.3"),
   ("preload", "120 N vs 49 N suction: SF 2.4; piston changes it +-20 N"), ("redundancy", "one wire lost: rank unchanged"), ("thermal +40 K", "Al vs Ti 0.058 mm radial at 4.7 MPa in the wires; symmetric, no tilt")],
  legend("stage2/m5/out/m5_pad.json")))
D3.append(plate(25, 'M5 facet pad: engineering views', 'stage2/m5/out/m5_pad_views.svg', 'isometric (1, -0.9, 0.55), detail of one station, plan, front, side', [('shows', 'the 0.32 m hex facet with its boss ring, three Ti post pairs, six tangential wires (orange) and three M6 adjusters (purple) between the posts'), ('plan', 'the three wire pairs tangent to the 100 mm station circle, the tip/tilt axes through the pad centre')], "Hidden-line projection of the same CadQuery model as the plate above (3d/cad_views.py): solid = visible edges, dashed = hidden, lighter orange = wires behind a frame, lighter grey = context parts. Each view carries its own scale bar."))
D3.append(plate3d(26, "M5 patch: 43 toroid facets on the pit truss, world frame", "stage2/m5/out/m5_patch.json",
  "m5_relay_geometry.py facets (0.32 m hex, R_t 0.97-3.72 m, R_s 0.94-1.48 m, incidence 8.9-50.9 deg) with the waist fW above and the duct fT beside",
  [("patch", "r 1.11 m about V0 (1.25, 0, -0.10) m; projected x -0.06..1.97 m"), ("foci", "fW (1.25, 0, 4.606), fT (0.42, 0, 0.14)"), ("truss", "rectangular base with diagonals; thermal centre at the chief-ray facet (x ~ 0.74 m); radial-free feet"),
   ("per facet", "one pad of SHEET 24; 10 mrad budget; 49 N hatch-open wind"), ("open", "5 south facets inside the modelled pot sphere; 51 deg incidence at the edge")],
  legend("stage2/m5/out/m5_patch.json")))

D3.append(plate(27, 'M5 patch: engineering views', 'stage2/m5/out/m5_patch_views.svg', 'isometric (1, -0.9, 0.6), plan, front, side, world frame in mm', [('shows', '43 hex facets with their pads on posts from the pit truss base; the dashed teal lines run to the waist focus fW above and the duct focus fT beside'), ('plan', 'the patch footprint x -0.06..1.97 m, y +-1.1 m, denser toward the east where incidence reaches 51 deg')], "Hidden-line projection of the same CadQuery model as the plate above (3d/cad_views.py): solid = visible edges, dashed = hidden, lighter orange = wires behind a frame, lighter grey = context parts. Each view carries its own scale bar."))


D3.append(plate3d(28, "Coarse-fine mount: bridle through F, flexing stem, fine flexure stage (equinox noon)", "stage3/hashemi_pneumatic/out/hp2_equinox_noon.json",
  "Stage 3. Hopkins's serial synthesis: intermediate space 1 = the sphere of rotations about F (coarse, pneumatic, whole sky); intermediate space 2 = 3 DOF Type 1 about the vertex (fine, exact-constraint flexure, microradians). Optics untouched.",
  [("coarse", "four 8 mm bridle wires through F on the focal tube (Hashemi's near method); stem r 1.0 m at 0.8 bar clamped to the back frame hub, bending couples by water turgor; no deck tendons: the roof is the dish's sweep, 9.2 x 7.8 m"),
   ("fine", "three tangential 12 mm rods at r 1.4 m (one constraint line each: rank 3 = tip, tilt, focus) and three sealed water columns at r 1.6 m in the actuation space (box of normals, thesis Fig. 4.3); locked: rank 6"),
   ("accuracy", "fine stage 77 MN m/rad: 4 urad at 9 m/s, 32 urad at 25 m/s; 62 urad per mL; range +-20 mrad, +-32 mm focus; coarse error 1.7 mrad at 9 m/s sits inside it"),
   ("wind", "9 m/s: 0 infeasible of 531, stem SF 17; 25 m/s: SF 2.8, rope SF 5.9, stays deployed; single wire loss keeps the pivot"),
   ("water", "turgor 0.1-0.2 bar -> 3-7 kN m of coarse couple; 2 m in the root = 4 t of foundation; water columns lock the fine stage with a valve")],
  legend("stage3/hashemi_pneumatic/out/hp2_equinox_noon.json")))
D3.append(plate(29, "Equinox noon, engineering views: the fine stage in detail", "stage3/hashemi_pneumatic/out/hp2_equinox_noon_views.svg", "isometric from the south-west; detail: back frame hub and ring, tangential rods (orange), water columns (purple), outrigger struts outside the rim; plan, front, side",
  [("shows", "beam rim -> strip -> F2 down the tube; bridle (blue) meeting F; stem from the root to the hub; the dish riding the fine stage 0.3 m in front of the frame"), ("slot", "open above 54 deg")],
  "Hidden-line projection of the CadQuery model (3d/cad_views.py). Light grey: deck, wall, column, pot, root housing."))
D3.append(plate(30, "Summer noon and equinox morning", "stage3/hashemi_pneumatic/out/hp2_summer_noon_views.svg", "summer noon, el 83 deg: the dish under F with the tube through its slot, the stem short and upright",
  [("morning sheet", "stage3/hashemi_pneumatic/out/hp2_morning_views.svg: el 38 deg ESE, the dish 3.5 m west of F, the stem at full reach"), ("both", "same members; only the stem's length and curvature change")],
  "The morning sheet is committed beside this one."))
D3.append(plate(31, "Equinox day: rims, stem axes and bridle lines", "stage3/hashemi_pneumatic/out/hp2_sweep_views.svg", "nine hours; every bridle line meets F, every stem axis leaves one root",
  [("orbit", "vertex x 0.1-4.5 m, |y| to 3.9 m, z 5.9-9.0 m over the year; rim to x 5.8 m and |y| 4.6 m: the roof the machine needs"), ("scaling", "at the same f/D: 3.0 m dish 6.5 x 5.6 m, 2.1 m dish 4.6 x 3.9 m; the inflated structure scales with it at constant pressure")],
  "Rims drawn thin; bridle in blue, stem axes dark."))
D3.append(plate3d(32, "The fine stage: 3 DOF Type 1 about the vertex, exactly constrained, water-actuated", "stage3/hashemi_pneumatic/out/hp2_fine_stage.json",
  "Hopkins ch. 2 serial synthesis: intermediate space 2 between the back frame (coarse stage) and the dish. Constraint space of 3 DOF Type 1 = every line in the back plane + a torque normal to it (Fig. 3.38); actuation space = the box of lines normal to the plane (Fig. 4.3).",
  [("constraints", "three tangential 12 mm 17-7PH rods, 0.9 m, at r 1.4 m: rank 3, DOF 3 = tip, tilt, focus; reciprocal products 0; athermal (0.62 mm Al/steel radial growth bends them at 5 MPa)"),
   ("actuators", "three sealed water columns d 0.12 m at r 1.6 m on the normals: displacement actuators; 62 urad per mL; locked by a valve: rank 6, 77 MN m/rad, 60 MN/m focus"),
   ("range", "+-20 mrad (rod S-bend 249 MPa = 0.17 sigma_y, Euler SF 11), +-32 mm focus: trims the vertex onto the true focal circle R/2"),
   ("wind", "drag asymmetry 315 N m at 9 m/s -> 4 urad; 2.4 kN m at 25 m/s -> 32 urad; columns carry 0.25-1.9 kN"),
   ("lineage", "the M5 facet pad of stage 2 scaled to the primary, screws replaced by water columns: the flexure work belongs at the accuracy end of the machine")],
  legend("stage3/hashemi_pneumatic/out/hp2_fine_stage.json")))
D3.append(plate(33, "Fine stage, engineering views from behind the dish", "stage3/hashemi_pneumatic/out/hp2_fine_stage_views.svg", "isometric from behind and below (the sun side is +z); detail of one station: rod to its post, column on the frame ring; plan, front, side",
  [("green", "tangential rods, the three constraint lines of the back plane"), ("brown", "water columns on the normals, the three displacement inputs"), ("grey", "back frame: hub (stem clamp), spokes, ring r 1.75 m; the dish's back ring r 1.46 m rides on rods and columns")],
  "Hidden-line projection of the CadQuery model. The rim toroid, plenum film and the stem stub are context."))

def legend_organs(json_path):
    import json as _json
    parts = _json.load(open(json_path))["parts"]; seen = []
    for p in parts:
        organ = p["name"].split(" | ")[0]
        if organ not in [o for o, c in seen]: seen.append((organ, p.get("color", "#888")))
    return "Legend: " + "; ".join(f'<span class="organ" style="background:{c}"></span>{html.escape(o)}' for o, c in seen)
FM = "stage3/fact_mount/out/"
MOUNT = []
MOUNT.append(plate3d(34, "The FACT mount: fork on the deck ring, blade trunnions on the axis through F, cradle, diaphragm fine stage (equinox noon)", FM + "fm_machine.json",
  "Third pass. Hopkins Fig. 2.7 to the end: ground the deck and the tube; stage 1 the fork (1R vertical, a ring bearing); stage 2 the cradle on two cross-blade trunnion blocks (1R horizontal through F, flexure); stage 3 the dish on the fine stage (3 DOF Type 1 about the vertex, flexure). 1 + 1 + 3 = 5 twists, the five wanted. Optics untouched.",
  [("elevation", "two blocks of 12 blades 17-7PH 200 x 1.0 x 120 mm, planes through the axis through F, at |y| 3.25 m: rank 5 / DOF 1 each and together; 71 deg at 0.17 sigma_y; 167 N m/rad"),
   ("why there", "the constraint space of a rotation is the same set of lines everywhere along its axis (thesis 3.2.1): at F the blocks and their struts cross the aperture in projection and the tube's reach; at |y| 3.25 m they do neither, and the 6.5 m between them turns the wind's moment about F into a pair of forces"),
   ("wind", "worst blade 906 N in plane at 9 m/s, 1940 N at 25 m/s (crosswind, el 44) vs 9.1 kN buckling: SF 10 / 4.7; the single block at F of the first draft would have seen 3.2 kN at 9 m/s"),
   ("cradle", "side arms 150 x 5 at |y| 2.45 m (155 mm outside the rim toroid), C-frame r 1.75 m 0.6 m behind the vertex, 131 L of water 2.6 m up each arm (the drawn 91 L tank is undersized, audit R-12): balanced about the axis; 650 kg"),
   ("shading", "0.000 m2 of the 13.07 m2 annulus at equinox noon, summer noon and 9 h (shading.py, 1 cm raster along the sun line); the tube's own 10 %, the strip ring's 1.5 % are the cass machine's"),
   ("clearance", "tube vs cradle over 59 Quetta positions: 71 mm worst (back ring end, summer 11 h, el 75); rings open 80 deg at the slot"),
   ("hold", "crank 1.0 m + Tr40 screw jack per post: lever 0.81-1.00 m over el 12-83, 1.9 kN at 9 m/s, 14 kN at 25, self-locking; ~30 urad under the mean wind; 46 L pumped to the frame cancels it"),
   ("fine stage", "three tangential blades (rank 3: tip, tilt, focus) + three water columns on the normals (rank 6): 90 MN m/rad, 4 urad at 9 m/s, 62 urad per mL, +-20 mrad")],
  legend(FM + "fm_machine.json"), export="fmMachine"))
MOUNT.append(plate(35, "FACT mount, equinox noon: engineering views", FM + "fm_machine_views.svg", "isometric from the south-west; detail of the west trunnion block on its post with the arm clamp, crank and jack; plan, front, side",
  [("plan", "the ring beam r 3.6 m about the tube, the posts on it, the arms outside the rim, the tanks up-sun"), ("side", "both posts, the axis through F between them, the cradle hanging in the light's shadow of nothing")],
  "Hidden-line projection of the CadQuery model (3d/cad_views.py); light grey: deck, wall, column, pot, rail."))
MOUNT.append(plate3d(36, "Trunnion block: twelve blades in two cross-blade stages on the elevation axis, exact 1R", FM + "fm_pivot.json",
  "Constraint space of 1R: every line meeting the axis. A blade whose plane contains the axis is three such lines; three cells of two blades at +-45 deg crossing on the axis per stage; two stages in series through the intermediate bar. Post below (ground), arm inboard (moving).",
  [("check", "18 lines per stage, rank 5, DOF 1 = rotation about the axis; reciprocal products 0; the two blocks in parallel: rank 5, DOF 1"), ("range", "+-25.8 deg per stage at 0.25 sigma_y; +-17.8 needed; 258 MPa = 0.17 sigma_y at el 12 and 83"),
   ("loads", "gravity 3.2 kN and the wind's pair of forces along the dish axis, resolved into the +-45 deg families: SF 10 / 4.7 on 9.1 kN fixed-fixed buckling"), ("thermal", "both blocks hold y; 1.0 mm over 6.5 m goes into the posts at 166 N; axes aligned to 0.2 mrad")],
  legend(FM + "fm_pivot.json")))
MOUNT.append(plate(37, "Trunnion block: engineering views", FM + "fm_pivot_views.svg", "isometric; detail of stage B over the moving bar; plan, front (the X of a cell on the axis), side (six cells along the axis)",
  [("orange", "the 12 blades, planes through the axis"), ("dark", "ground bar and post saddle below stage A, intermediate bar above both, moving bar and arm clamp below stage B")], "Hidden-line projection of the same model."))
MOUNT.append(plate3d(38, "The fine stage: 3 DOF Type 1 about the vertex, three tangential blades, three water columns, C-rings open at the slot", FM + "fm_fine.json",
  "Hopkins ch. 2 serial synthesis, intermediate space 3, between the cradle's frame and the dish. Constraint space = every line in the back plane + a normal torque (Fig. 3.38); actuation space = the box of lines normal to the plane (Fig. 4.3).",
  [("constraints", "three flat blades 450 x 60 x 1.5 mm tangential at r 1.46 m, 60/180/300 deg from the slot: 9 lines in the plane, rank 3, DOF 3 = tip, tilt, focus; athermal (Al/steel 0.62 mm bends them in-plane at 114 MPa)"),
   ("actuators", "three flexure struts with 8 mm necks on the normals at r 1.6 m (90/210/315 deg) on sealed water columns d 0.12 m: rank 6 locked; 62 urad per mL; 90 MN m/rad"),
   ("range", "+-20 mrad (130 MPa = 0.09 sigma_y), +-30 mm focus"), ("wind", "drag asymmetry 315 N m at 9 m/s -> 4 urad"), ("the slot", "back ring and frame ring open 80 deg about the slot, no station within |y| 0.5 m of it: the tube passes anywhere along the slot at el 55-83")],
  legend(FM + "fm_fine.json")))
MOUNT.append(plate(39, "Fine stage: engineering views from behind the dish", FM + "fm_fine_views.svg", "isometric from behind and below (+z is the sun side); detail of one station; plan, front, side",
  [("green", "the tangential blades, three constraint lines each in the back plane"), ("blue", "water columns on the normals"), ("dark", "the C-frame with its spokes and diagonals to the arm points; the C-ring gap at +x, the slot direction")], "Hidden-line projection of the same model."))
MOUNT.append(plate(40, "Summer noon, el 83", FM + "fm_summer_views.svg", "the dish flat under F, the tube through the slot and the C-rings' gap, the arms upright beside it, the tanks 12.8 m up",
  [("clearance", "the cradle's lowest members 0.3 m over the deck; the ring beam outside them"), ("shading", "0.000 m2 from the mount; the tube 1.7 %, the strip ring 1.3 % (theirs)")], "Hidden-line projection."))
MOUNT.append(plate(41, "Equinox 9 h, el 38 ESE", FM + "fm_morning_views.svg", "the fork turned 63 deg from south, the cradle tilted; the tube stands beside the dish's lower rim, outside it",
  [("shading", "0.000 m2 from the mount; the tube 10 % (Hashemi's near method stands it in the light at every elevation but the highest: the other fork's number, printed so the two are not confused)")], "Hidden-line projection."))
MOUNT.append(plate(42, "Equinox day, 8-16 h", FM + "fm_sweep_views.svg", "rims, arms, posts and the elevation axis at each hour: every axis through F, every arm outside its rim, every post outside the sweep",
  [("footprint (audit R-22: 1.94 m stalk instead of two 4.34 m posts reaching an axis 4.87 m over the deck)", "the dish's sweep, 9.2 x 7.8 m for a 2.1 m dish at f 4.0; ring beam 7.5 m; at el 12 the tank ends reach 1.6 m south of the tube at z 10.5"), ("scale", "at the same f/D: 1.5 m dish 6.5 x 5.6 m, 1.05 m dish 4.6 x 3.9 m; blade range and stress unchanged at constant t/L, wind SF unchanged (loads and buckling both ~L^2)")], "Hidden-line projection; rims thin, arms and posts dark, axes dashed."))
FLOWER = []
FLOWER.append(plate(43, "The flower, drawn: a heliotropic bowl flower with an inferior ovary", "flower_botany.svg", "Side view along the elevation axis at spring noon, el 60; every organ is one part of sheet 34",
  [("corolla", "the bowl: membrane and rim"), ("stigma", "the strip under F, where the light lands"), ("style", "the focal tube up the middle of the bowl; the light conducted down inside it"), ("ovary", "the tandoor pot, inferior, below the deck"),
   ("pulvinus", "the trunnion blocks: the joint that turns the head"), ("turgor", "water at the arms' ends; pumped to lean against the wind"), ("calyx", "the cradle: arms beside the bowl, frame behind it"), ("stalk", "the ring beam and the two posts"), ("roots", "the deck and its ring rail")],
  "Kevan 1975 (Science 189:723) measured Arctic poppies and Dryas warming their gynoecium by tracking the sun with a parabolic corolla; a pulvinus moves a leaf by moving water between its cells."))
ORGAN_JS = """(function(){ const O = [["sunlight","#f6ad55",["beam:","sun direction"]],["heliotropism: the two rotation axes through F","#4a5568",["f-f2 axis"]],["stigma: the strip under F where the light lands, F and F2","#6b46c1",["hyperboloid strip","=F","=F2"]],["ovary and fruit: the tandoor pot, inferior, below the ground","#9b2c2c",["tandoor pot"]],["roots: the deck, its rail, the beam column and M4 below","#7c4a1e",["deck ring rail","roof deck","beam column","m4"]],["style: the focal tube up the middle of the bowl, carrying the light down to the ovary","#2f855a",["focal tube","strip ring"]],["stalk: the ring beam turning on the rail and the two posts up to the head's axis","#276749",["post","ring beam","saddle","upright","jack bracket"]],["pulvinus: the trunnion blocks, the joint that bends the head toward the sun","#dd6b20",["pivot blade","ground bar","intermediate bar","moving bar","arm clamp"]],["turgor: the water at the arms' ends that balances and trims the head; the jacks that hold it","#2b6cb0",["water tank","screw jack","crank"]],["calyx: the cradle, two arms beside the bowl and a frame behind it","#6b8e23",["side arm","back frame","post to the back frame","frame spoke","frame diagonal"]],["motor cells: the fine stage, blades and water columns that trim the head by microradians","#15803d",["fine stage","flexure","water column","dish back c-ring","strut foot"]],["corolla: the bowl of petals, the membrane and its rim","#d69e2e",["membrane","rim toroid","back plenum"]],["the ground","#c9cfd6",["south wall"]]];
  const organ = n => { const l = n.toLowerCase(); for (const [o, c, ks] of O) for (const k of ks) { if (k[0] === "=" ? n === k.slice(1) : l.includes(k)) return [o, c]; } return ["other", "#a0aec0"]; };
  return Object.assign({}, window.fmMachine, {parts: window.fmMachine.parts.map(p => { const [o, c] = organ(p.name); return Object.assign({}, p, {color: c, name: o + " | " + p.name}); })}); })()"""
FLOWER.append(plate3d(44, "The same machine, coloured by organ", FM + "flower_organs.json", "Sheet 34's model with each part recoloured by the organ it plays (flower_organs.py); rotate it and pick the organs out",
  [("head", "corolla (yellow) on its calyx (olive) with the motor cells (green) between them; the stigma (purple) at the focus above"), ("joint", "pulvinus (orange) at the ends of the axis through F; turgor (blue) at the arms' up-sun ends"),
   ("stalk and root", "two posts and the ring beam (dark green) on the deck rail (brown); the style (green) up the middle from the ovary (red) below the ground")],
  legend_organs(FM + "flower_organs.json"), model_js=ORGAN_JS))
CORR = """<table class="corr"><tr><th>organ</th><th>in the plant</th><th>in the machine</th><th>the numbers</th></tr>
<tr><td><span class="organ" style="background:#7c4a1e"></span>roots</td><td>anchor and water</td><td>the deck, its ring rail, the beam column below</td><td>ring 7.5 m inside the 7.8 m the dish's sweep needs</td></tr>
<tr><td><span class="organ" style="background:#276749"></span>stalk</td><td>holds the head up and turns it</td><td>the ring beam on rollers and two 250 x 8 posts, 4.3 m, up to the head's axis</td><td>azimuth 220 deg; 328 kN/m each, the trunnion pair's thermal compliance (166 N per 13 K)</td></tr>
<tr><td><span class="organ" style="background:#dd6b20"></span>pulvinus</td><td>the motor joint just below the head</td><td>two trunnion blocks of twelve blades on the axis through F, 3.25 m to either side</td><td>rank 5, DOF 1; 71 deg at 0.17 sigma_y; blade SF 10 at 9 m/s, 4.7 at 25</td></tr>
<tr><td><span class="organ" style="background:#2b6cb0"></span>turgor</td><td>water moved between cells to lean</td><td>131 L at each arm (audit R-12)'s up-sun end; 46 L pumped to the frame cancels the 9 m/s mean torque; the jacks hold the gusts</td><td>1.9 kN per jack at 9 m/s, 14 at 25; ~30 urad</td></tr>
<tr><td><span class="organ" style="background:#6b8e23"></span>calyx</td><td>cups the corolla from behind and beside</td><td>two side arms at |y| 2.45 m and the C-frame 0.6 m behind the vertex</td><td>0.000 m2 of shading; 71 mm worst tube clearance over the year</td></tr>
<tr><td><span class="organ" style="background:#d69e2e"></span>corolla</td><td>the parabolic bowl that gathers the light</td><td>the pumped membrane a 2.1 m, R 8.2 m, and its rim toroid</td><td>the other fork's; untouched</td></tr>
<tr><td><span class="organ" style="background:#15803d"></span>motor cells</td><td>fine turgor movement</td><td>three tangential blades and three water columns between calyx and corolla, 3 DOF Type 1</td><td>62 urad per mL; 4 urad at 9 m/s; +-20 mrad</td></tr>
<tr><td><span class="organ" style="background:#2f855a"></span>style</td><td>conducts the pollen tube down to the ovary</td><td>the focal tube up the middle of the bowl through its hole and slot; the light goes down inside it</td><td>Hashemi's near method; its own shadow 10 % at el 59 is the cass machine's</td></tr>
<tr><td><span class="organ" style="background:#6b46c1"></span>stigma</td><td>where the pollen lands, at the bowl's focus</td><td>the hyperboloid strip 0.8 m under F</td><td>the Cassegrain secondary; the other fork's</td></tr>
<tr><td><span class="organ" style="background:#9b2c2c"></span>ovary and fruit</td><td>inferior: below the receptacle</td><td>the tandoor pot below the deck</td><td>where the light ends</td></tr>
<tr><td><span class="organ" style="background:#4a5568"></span>heliotropism</td><td>the head follows the sun</td><td>azimuth on the ring, elevation on the trunnions, the fine stage closing the loop on the beam centroid</td><td>59 Quetta positions checked for clearance; 9 and 25 m/s for load</td></tr>
</table>
<table class="corr"><tr><th>the same flower at three sizes (f/a 1.9, f/D 0.95)</th><th>dish a</th><th>roof</th><th>fine stage</th><th>blades</th></tr>
<tr><td>as drawn</td><td>2.1 m</td><td>9.2 x 7.8 m</td><td>62 urad per mL</td><td>200 x 1.0 x 120 mm, SF 4.7 at 25 m/s</td></tr>
<tr><td>a smaller roof</td><td>1.5 m</td><td>6.5 x 5.6 m</td><td>170 urad per mL</td><td>same t/L: same range, same stress, same wind SF</td></tr>
<tr><td>a small roof</td><td>1.05 m</td><td>4.6 x 3.9 m</td><td>496 urad per mL</td><td>same; lighter on its blades (weight ~L^3, buckling ~L^2)</td></tr>
</table>"""

ANIM_JS = open(os.path.join("3d", "anim.js")).read()
def plate_anim(num, title, json_path, ref, rows, note=""):
    anim = open(json_path).read()
    tb = "".join(f'<div class="k">{html.escape(k)}</div><div class="v">{v}</div>' for k, v in rows)
    vid = f"anim{num}"
    return f'''<article class="plate" id="pl{num}">
  <div class="paper paper3d"><div class="view3d" id="{vid}"></div><div class="hint">plays on load · drag to orbit · shift-drag to pan · wheel to zoom · slider to scrub</div></div>
  <aside class="block">
    <div class="sheet">SHEET {num:02d} · SIMULATION</div>
    <h3>{html.escape(title)}</h3>
    <div class="ref">{html.escape(ref)}</div>
    <div class="tb">{tb}</div>
    {f'<p class="note">{note}</p>' if note else ''}
  </aside>
</article>
<script>(function(){{ const anim = {anim}; const el = document.getElementById("{vid}"); const go = () => mountAnim(el, anim); if (window.THREE) go(); else window.addEventListener('load', go); }})();</script>'''
def setup_rows(log_path, anim_path):
    import json as _json
    L = _json.load(open(log_path)); An = _json.load(open(anim_path)); T = An["t_setup"]
    setup = [l for l in L if l["t"] <= T]; track = [l for l in L if l["t"] > T]; end = setup[-1]
    t_axis = next((l["t"] for l in setup if abs(l["z_axis"] - 4.868) < 0.05), None)
    mus = max(max(l["muscles"]) for l in L)
    def mean(k, S): return sum(l[k] for l in S)/max(1, len(S))
    return [("what runs", f"{An['n_particles']} particles, {len(An['tris'])//3} membrane triangles, {An['n_frames']} frames at {1/An['dt']:.0f} fps: one stalk r 0.5 m and two counterweight hoses r 0.35 m as closed fabric tubes; the yoke, the head (frame group 74 kg, dish group 113 kg including the 15 kg secondary, as the simulation actually weights them, audit SIM-05) as spring trusses; the hollow neck as a hinge on its axis"),
            ("air", "STILL AIR: this run has --wind 0; the wind runs (9 m/s gusting: stalk lean 1.0 deg, frame 0.27 deg, dish 0.21 deg; 25 m/s: lean 21 deg) are in stage3/setup_sim/out/wind9.log and wind25.log and in the Audit section"),
            ("stow", "stalk 0.5 m, head face-up over the neck, counterweight hoses as stubs, empty; nothing is placed by hand"),
            ("stalk", f"grows at the blower's rate from t {0.08*T:.0f} s with feedback on the neck height; neck at env z {end['z_axis'] + 5:.2f} m (target 6.94) at the end of setup"),
            ("water", f"counterweight hoses grow {0.42*T:.0f}-{0.66*T:.0f} s behind the neck and beyond the stalk; {An.get('m_cw1', 0):.0f} and {An.get('m_cw2', 0):.0f} L pumped into them {0.6*T:.0f}-{0.74*T:.0f} s (the hose walls carry the mass; the amounts come from the built moment balance about the neck and about the stalk)"),
            ("turn", f"the jack from the yoke to a 0.8 m crank on the neck bar (15 kN cap) turns the head from el 90 to the morning sun {0.74*T:.0f}-{0.98*T:.0f} s; jack peak {max(max(l['muscles']) for l in L if 0.74*T <= l['t'] <= T)/1e3:.1f} kN in the turn (cap 15 kN; the uncapped spring readout at t 0 is a start-up artefact, audit SIM-07)"),
            ("arrives", f"at t {T:.0f} s the vertex is {end['err']:.2f} m from F - 4 s and the dish axis {end['point']:.1f} deg from the sun"),
            ("tracks", f"sun {An['h0']:.0f}-{An['h1']:.0f} h over {An['t_day']:.0f} s: vertex error mean {mean('err', track):.2f} m; the frame on the yoke (coarse stage: jack and deck ring on a sun sensor) points {mean('coarse', track):.2f} deg from the sun on average, max {max(l.get('coarse', 0) for l in track):.1f} deg") if track else ("tracks", "no tracking phase in this run"),
            ("to microradians", f"the flexure fine stage between frame and dish (three tangential rods, rank 3: tip, tilt, focus; three water columns on the normals, commanded from the dish-axis error and the focal distance) holds the dish, in still air, {mean('point', [l for l in track if l['t'] > T + 0.15*An['t_day']])*17.45:.2f} mrad from the sun on average while the frame on the inflated stalk holds {mean('coarse', [l for l in track if l['t'] > T + 0.15*An['t_day']])*17.45:.2f} mrad; columns within +-{max(max(abs(v) for v in l['fine_mm']) for l in L):.0f} mm of their +-30 mm (sheet 38). The residual is the control loop's at 7.5 fps, not float precision (audit SIM-04); the 90 MN m/rad and 62 urad per mL of sheets 38-39 are a stiffness and an actuator resolution, not a demonstrated pointing accuracy, and the stage is anisotropic (63.5 MN m/rad on its soft axis, audit MS-15)") if track and 'fine_mm' in L[0] else ("to microradians", "the flexure fine stage of sheets 38-39 rides between frame and dish"),
            ("pressure", f"the tubes' hoop strain reads {mean('p_eq', L) if False else ''}{max(max(l['p_eq']) for l in L)/1e3:.0f} kPa at most (3.5 % over-volume prestress, EPS_V; the readout is the solver's hoop diagnostic, not a design pressure, audit R-11); Coad's crushing and buckling forces and McFarland's collapse moment give SF 9 / 1.8 / 1.0 (post / arm / counterweight tube) at 40 kPa and double at the design's 80 kPa (inflated_beam.py)"),
            ("solver", "Gauss-Seidel XPBD in NVIDIA Warp kernels (graph-coloured constraints), tension-only membrane springs with axial pre-tension, one volume constraint per closed tube (the pressure), long-range attachments for growth, deck contact; warp.sim's own XPBD (Jacobi, unnormalised) and an averaged-Jacobi version both failed on this net, which is recorded in the memo"),
            ("controller model", (lambda k: k[0] + "; " + k[1] if len(k) > 1 else k[0])(open("stage3/setup_sim/out/koopman4.txt").read().strip().splitlines()) + " (pykoopman; only the identity lift, i.e. ordinary linear system identification, predicts; the degree-2 Koopman lift diverges after 6 s, and no MPC is implemented, audit R-15/SIM-09; the approach of Bruder et al.: the lifted linear model a model-predictive controller runs at the struts' valves and the ring drive)")]
SETUP = []
SETUP.append(plate_anim(45, "The machine sets itself up: the stalk grows, the counterweight hoses grow and fill, the jack turns the head to the sun, the fine stage holds it", "stage3/setup_sim/out/setup4_anim.json",
  "3-D soft-body simulation of the fourth-pass machine: one inflatable stalk grown like an everting vine (Blumenschein 2019, Coad 2021) lifts the yoke, the hollow neck and the head; two counterweight hoses grow and fill with water; a jack on the yoke turns the head about the neck; the stalk turns the azimuth; the flexure fine stage (sheets 38-39) holds the dish on the sun",
  setup_rows("stage3/setup_sim/out/setup4_log.json", "stage3/setup_sim/out/setup4_anim.json"),
  "Blue membranes: the stalk and the two counterweight hoses. Yellow: the dish, with the style and secondary as lines above it; dark truss: the neck bar and back frame; green: the fine stage's tangential rods; brown: its water columns. Orange: the axle bodies and cranks on the elevation axis; red: the struts; blue spheres: the water. Purple: F. Orange ring: the vertex's ideal position F - 4 s for the current sun; dashed teal: the sun line. Deck at env z 5.0."))

CD = "stage3/coude/out/"
import json as _j
_O = _j.load(open(CD + "optics.json")); _sh = open(CD + "shading.txt").read()
BEHIND = []
BEHIND.append(plate(47, "Equinox noon: engineering views", CD + "cd_equinox_noon_views.svg", "isometric from the south-west; detail of M3 at the neck, the hollow pivot and M4 in the yoke; plan, front, side",
  [("plan", "one stalk, the head 1.4 m to its side, the counterweights on the far side and behind the neck"), ("side", "the beam from the dish axis along the neck and down the stalk to F2 below the yoke")], "Hidden-line projection of the CadQuery model; light grey: deck, wall, bore, pot, underground mirror."))
BEHIND.append(plate(49, "Hollow cartwheel trunnion: engineering views", CD + "cd_pivot_views.svg", "isometric; detail of stage A; plan, front (the six blades as spokes around the bore), side", [("orange", "12 radial blades"), ("dark", "ground ring on the yoke arm, intermediate ring across both stages, moving ring to the neck bar")], "Hidden-line projection of the same model."))
BEHIND.append(plate(50, "Summer noon and equinox morning", CD + "cd_summer_noon_views.svg", "el 83: the dish flat over the neck, only the style and the secondary above it; the morning sheet stage3/coude/out/cd_morning_views.svg shows el 38 with everything behind",
  [("shading at el 83", "2.45 %, the same as at noon and in the morning: the shadow is the secondary's alone at every hour")], "Hidden-line projection."))
BEHIND.append(plate(51, "Equinox day, 8-16 h", CD + "cd_sweep_views.svg", "rims, neck bars, spines and secondary axes about one stalk (the counterweight arms are not drawn, audit R-27)",
  [("footprint", "the head's sweep about the neck 7.9 m, about the stalk a circle of about 8.5 m; the stalk 2 m tall instead of two 4.9 m posts")], "Hidden-line projection."))
SHADE_TABLE = """<table class="corr"><tr><th>blocked, fraction of the full aperture pi a^2 = 13.85 m2 (audit SH-3, SH-4, OPT-04, OPT-11, R-04..R-06)</th><th>tube machine (cass, third-pass mount)</th><th>fourth pass</th></tr>
<tr><td>the tube / the secondary disc (sag-correct r 0.367)</td><td>9.2 % at el 59, 1.7 % at el 83</td><td>3.05 %</td></tr>
<tr><td>the strip ring / the hole (inside the secondary's disc)</td><td>1.4 %</td><td>0 (already in the disc)</td></tr>
<tr><td>the hole in the membrane</td><td>5.7 %</td><td>0.32 % (inside the disc)</td></tr>
<tr><td>the slot when open (el above 54)</td><td>adds nothing: it lies under the tube's shadow</td><td>none</td></tr>
<tr><td>rim toroid</td><td>0.14 % (a mesh artefact, SH-12)</td><td>0.13 % (same)</td></tr>
<tr><td><b>total in front of the membrane</b></td><td><b>14.6 % (el 83) to 16.0 % (el 37)</b></td><td><b>3.1-3.3 %</b></td></tr>
<tr><td>the converging beam intercepted on its way to the secondary</td><td>the focal tube: a further 20.9 % (SH-9)</td><td>the style intercepts the whole field-widened cone and the spine on the axis 36.5 % of the return beam as drawn (SH-1, OPT-02, OPT-05)</td></tr>
<tr><td>reflections above ground</td><td>2</td><td>4</td></tr>
<tr><td>light at the pot, relative, at reflectivity rho</td><td>1.00</td><td>(1 - 0.033)/(1 - 0.155) x rho^2: 1.03 at rho 0.94, 1.00 at 0.925, 0.89 at 0.88 (R-06), before the style's interception</td></tr>
</table>"""
TR = "stage3/tree/out/"
_sw = open(TR + "sweep.txt").read().strip().splitlines()
TREE = []
TREE.append(plate(52, "The flower proper: one stem, a crown of branches carrying the exact spherical membrane, F on the light pipe (equinox noon)", TR + "tr_equinox_noon_views_small.png",
  "isometric from the south-west; detail of the stem, the receptacle and the branches under the head; plan, front, side. The head sits on the env's orbit about F (hashemi.ini: beta_dev 0, retro), 4 m from F along the sun line; the beam converges on the strip 0.6 m before F and goes down the pipe.",
  [("primary", "the exact hashemi.ini membrane: a spherical cap a 2.1 m, R 8 m, f = g = 4 m, no hole, no slot; the crown's tips carry it"),
   ("crown", "one stem 1 m (r 0.15) 2 m north of the pipe; from its top six primaries to r 0.8 on the head's back, twelve secondaries to r 1.45, sixty twigs to a Vogel scatter of tips on the sphere: the foliage whose inner surface is the spherical section"),
   ("F", "on the light pipe, the cass machine's bore r 0.7 to z_deck + 0.35 + max(g sin el + a cos el) = 4.87 m over the deck; the hyperboloid strip r 0.6 at F - 0.6: a Masdar beam-down; the pipe is separate of the tree"),
   ("why one stem", "the sphere has no axis: only its centre of curvature must be at F + 4 s, the attitude about it is free (the env's beta_dev); the paraboloid needed vertex and axis, which is what defeated the second pass's stem")],
  "Hidden-line projection of the CadQuery model; mm. The branches are drawn as smooth curves from the receptacle; their lengths at each sun are in the sweep sheet."))
_ws = open(TR + "wind_size.txt").read().strip().splitlines()
TREE.append(plate(56, "The crown sized for wind: a hexapod of six steel struts from a receptacle ring r 1.5 m, the calyx under the membrane, a 215 mm steel stem (equinox noon on the env's law)", TR + "tw_equinox_noon_views_small.png",
  "The audit's loads (peak factor 3 on the mean wind; 40 m/s 3-s gust; lift and hinge moment) applied to the one-stem flower. A cantilever crown cannot hold the head to 5 cm at F (its tip rotation alone costs 2 f theta, audit F8); a hexapod can. The pipe is drawn as the env has it: the bore from F through the membrane's 0.5 m hole to the chase, the strip on an arm from a tower 3 m north (arm_north), not a tube under F (audit F3).",
  [("loads", "9 m/s mean: 3.05 kN, 0.82 kN m, lift 1.41 kN at the peak; 12 m/s: 5.4 / 1.45 / 2.5; 15 m/s: 8.5 / 2.3 / 3.9; 40 m/s gust: 16.6 kN, 16.7 kN m, 7.7 kN unstowed, or 1.0 kN, 3.9 kN m and 17.5 kN uplift stowed face-up"),
   ("legs", "on the env-law poses the worst is day 50 at 10 h (hub 3.0 m north, 2.1 m west, 3.1 m up; legs 1.3-5.2 m). Receptacle ring r 1.5 m: leg forces 13 kN at the 9 m/s peak, 35 kN at 15 m/s, 28 kN stowed in the gust, 128 kN tracking through it; steel CHS 85 x 5.3 (225 kg for six) holds the image within 1.2 / 2.2 / 3.4 cm at 9 / 12 / 15 m/s, first mode 16 Hz; 115 x 7.2 (413 kg) to track through the gust. A receptacle of r 1.0 needs 115 x 7.2 for the same duty and walks 3.3 / 5.8 / 9.1 cm; r 0.6 fails (10 cm at 9 m/s). At equinox noon the legs are 0.8-1.8 m and 45 x 3 would do: the mornings size the crown"),
   ("not hoses", "a water column in a fabric hose (E t 500 kN/m) has a column modulus of 2 MPa: 69 m of image walk at the 9 m/s peak; steel-wound hose 7 m. The water may drive the struts; it cannot be them"),
   ("stem", "root 12 kN m at the 9 m/s peak, 34 at 15 m/s or the stowed gust, 56 unstowed: steel CHS 215 x 9 mm, 2 mrad = 2 cm at F; an inflated stem r 0.4 at 3.4 bar turns 121 mrad: a hinge"),
   ("calyx", "74 N per tip at the 9 m/s peak (405 N unstowed gust): twigs 18 mm, secondaries 40 mm aluminium (34 / 72 mm for the unstowed gust); membrane pressure difference 320 Pa (1750)"),
   ("budget", "image walk at F at the 9 m/s peak: legs 1.2 + stem 1.8 = 3.0 cm of the 4.9 half-power; 5.6 cm at 12 m/s, so the stow decision sits near 11 m/s mean unless the stem grows to 273 mm (1.0 cm) or the legs to 115 x 7.2")],
  "Hidden-line projection of the CadQuery model; mm. The legs' lengths at each sun are the actuation; the still-head schedule keeps them within 1.7-4.9 m."))
_pt = open(TR + "path.txt").read().strip().splitlines()
TREE.append(plate(57, "Where the hexapod can carry the head on the env's own law (orbit sphere, axis the bisector, beta within 36 deg): 9, 12 and 15 h at the equinox, winter and summer noon", TR + "tw_sweep_views_small.png",
  _pt[0],
  [("reach", _pt[1]), ("hub", _pt[2]), ("shadow", _pt[3]), ("rim", _pt[4]),
   ("audited", "the still-head family first drawn here (P + R n = F + R/2 s) was the sphere's paraxial focus only and is withdrawn (audit F2); a head that does not move pays the full sun angle as beta and is optically dead by mid-morning. The head must travel the orbit sphere; from one fixed receptacle the hub lies 1.3-5.7 m away over the year, beyond a hexapod's stroke (F13). What can carry it: a luffing, slewing pedicel from the stem top to the hexapod's receptacle, or Hashemi's rail")],
  "Hidden-line projection of the CadQuery model; mm. The poses drawn are those the hexapod reaches; the rest of the day needs the pedicel."))
def plate_gif(num, title, gif_path, ref, rows, note=""):
    import base64 as _b64
    tb = "".join(f'<div class="k">{html.escape(k)}</div><div class="v">{v}</div>' for k, v in rows)
    img = '<img style="width:100%;height:auto;display:block" src="data:image/gif;base64,' + _b64.b64encode(open(gif_path, "rb").read()).decode() + '">'
    return f'''<article class="plate" id="pl{num}">
  <div class="paper">{img}</div>
  <aside class="block">
    <div class="sheet">SHEET {num:02d}</div>
    <h3>{html.escape(title)}</h3>
    <div class="ref">{html.escape(ref)}</div>
    <div class="tb">{tb}</div>
    {f'<p class="note">{note}</p>' if note else ''}
  </aside>
</article>'''
_i5 = open("stage3/setup_sim/out/setup5_ident.txt").read().strip().splitlines(); _i5c = open("stage3/setup_sim/out/setup5_calm_ident.txt").read().strip().splitlines(); _i9 = open("stage3/setup_sim/out/setup5_w9_ident.txt").read().strip().splitlines()
TREE.append(plate_gif(58, "The flower sets itself up, identifies itself and tracks: six struts pumped from the stow, a calibration dither, the day at 12 m/s mean from the south with gusts to 21", "stage3/setup_sim/out/setup5.gif",
  "3-D soft-body simulation (NVIDIA Warp, the fourth pass's solver): the hashemi.ini membrane as a 130 kg rigid clique on six bilateral force-capped struts from a receptacle ring carried by a kinematic pedicel; the env's head law; the dish's drag and pitching moment with gusts (peak pressure 3 x mean). The loop closes through the machine's own identified static gain.",
  [("setup", _i5[1].split(": ", 1)[1]), ("identification", _i5[2].split(": ", 1)[1]), ("the day, 12 m/s S", _i5[3].split("): ", 1)[1]), ("the day, 9 m/s S", _i9[3].split("): ", 1)[1]), ("the day, still air", _i5c[3].split("): ", 1)[1]),
   ("what is not in it", "the pedicel's and the stem's compliance (the stem alone 2 mrad = 1.8 cm at F), front/back asymmetry of the drag, the membrane's own figure under wind, real gust spectra; the quarter-hour pose steps of the schedule become jumps in a day compressed to 60 s")],
  "Film: legs (brown), rim (grey), the receptacle ring on its stem, the pipe, F (violet), the beam (orange), the head's axis (teal). The memo lists the eight defects the first version had, each visible in a run, and the one that decided the architecture: a fixed receptacle leaves the hexapod five well-conditioned islands a day; the pedicel is the stage the kinematics demanded."))
TREE.append(plate(53, "The year's sweep: the head on the orbit sphere at 8, 12 and 16 h equinox and at the solstice noons", TR + "tr_sweep_views_small.png",
  "rims, membranes and crowns at five suns about one stem and one pipe",
  [("hub", _sw[0].split(": ", 1)[1]), ("branches", _sw[2].split(": ", 1)[1]), ("shadow", _sw[3]), ("rim", _sw[1].split("; ")[1])],
  "The crown is a mechanism, not a shape: it carries the head around a quarter of the orbit sphere. With the head parked low and turning half the sun's motion (the sphere's freedom) the branches shorten to 1-3 m at the price of beta up to 40 deg; stage3/tree/path.py."))
TREE.append(plate(54, "Winter noon and equinox morning", TR + "tr_winter_noon_views_small.png", "el 36: the head 3.2 m north and 2.5 m up; the morning sheet stage3/tree/out/tr_equinox_morning_views.png has it 2.8 m west of the meridian",
  [("winter noon", "hub 3.2 m north, 2.5 m up; primaries 1.5-2.9 m"), ("equinox 9 h", "hub 1.45 m north, 2.8 m west, 2.4 m up; primaries 3.0-4.6 m; the crown turns about the stem")], "Hidden-line projection of the CadQuery model; mm."))
TREE.append(plate(55, "Summer noon, el 83: the head 0.9 m over the deck beside the pipe, looking up", TR + "tr_summer_noon_views_small.png", "the lowest position of the year: the hub 0.5 m north of the pipe's axis",
  [("wind", _sw[4].split("; ")[0].split(": ", 1)[1]), ("stiffness", _sw[4].split("; ")[1])], "The gating load. The fourth-pass stalk machine with the dish's drag in its simulation: stalk lean 1.0 deg at 9 m/s (the fine stage's whole range), 21 deg at 25 m/s."))

# ---- the audit (opus workflow): the blocking and material findings, the wind verdicts
import json as _ja
_AU = _ja.load(open("stage3/audit/findings.json")); _AF = [f for f in _AU["findings"] if f["tag"] != "REFUTED"]
_APPLIED = {"R-01", "R-02", "R-03", "R-04", "R-05", "R-06", "R-10", "R-11", "R-12", "R-13", "R-14", "R-15", "R-16", "R-18", "R-19", "R-21", "R-22", "R-23", "R-25", "R-28", "SIM-05", "SIM-07", "SIM-09", "SH-3", "SH-4", "OPT-04", "OPT-11", "OPT-06", "MS-12", "SH-10", "OPT-15", "R-26", "R-27"}
def _short(t, n=230):
    t = re.sub(r"\s+", " ", t).strip(); return html.escape(t if len(t) <= n else t[:n].rsplit(" ", 1)[0] + " ...")
def audit_table(sev):
    rows = [f for f in _AF if f["sev"] == sev]
    tr = "".join(f"<tr><td>{f['id']}</td><td>{html.escape((f.get('file') or '').split('compliant/')[-1])}:{f.get('line') or ''}</td><td>{_short(f['claim'], 150)}</td><td>{_short(f['problem'], 260)}</td><td>{_short(f['fix'], 260)}</td><td>{'applied' if f['id'] in _APPLIED else 'recorded'}</td></tr>" for f in rows)
    return f'<table class="corr audit"><tr><th>id</th><th>where</th><th>the claim</th><th>the problem</th><th>the correction</th><th>status</th></tr>{tr}</table>'
_WC = _AU["winds"][-1]                                   # the wind critic's reconciliation
def wind_table():
    tr = "".join(f"<tr><td>{_short(d['design'], 90)}</td><td>{_short(d.get('gating_element',''), 200)}</td><td>{_short(d.get('operating_limit',''), 160)}</td><td>{_short(d.get('survival',''), 160)}</td><td>{_short(d.get('verdict',''), 260)}</td></tr>" for d in _WC.get("per_design", []))
    nums = "".join(f"<tr><td>{_short(n['item'], 120)}</td><td>{_short(n['value'], 160)}</td><td>{_short(n['basis'], 160)}</td></tr>" for n in _WC.get("numbers", [])[:24])
    return (f'<table class="corr audit"><tr><th>machine</th><th>what wind sizes first</th><th>operating</th><th>survival</th><th>verdict</th></tr>{tr}</table>'
            f'<p class="note">The critic\'s reconciled numbers (first 24 of {len(_WC.get("numbers", []))}):</p><table class="corr audit"><tr><th>item</th><th>value</th><th>basis</th></tr>{nums}</table>')
_counts = {k: sum(1 for f in _AF if f["sev"] == k) for k in ("blocking", "material", "minor")}
AUDIT_HTML = (f'<p class="intro">Six opus auditors (optics, shading, mount structures, simulation physics, inflated beams, the page\'s own claims) each read the files and recomputed; two independent verifiers judged every finding. {_counts["blocking"]} blocking, {_counts["material"]} material and {_counts["minor"]} minor findings were confirmed; 4 were refuted. The full record with every recomputation is <code>stage3/audit/findings.md</code>. What it means for the passes: the fourth pass\'s optics fail as drawn (its style intercepts the converging beam, its spine lies on the beam axis, its hole is undersized, and its light-gain claim was measured against a double-counted baseline: at a mirror reflectivity of 0.88 it delivers less light than the tube machine), its pivot arithmetic used the wrong axis and the wrong blade model, and every wind number in this branch was a mean-only number without a gust factor; the third pass\'s structure is the soundest of the moving machines; the self-setup film was run in still air. The fourth pass stands on the register as a record, superseded by the fifth; the sheets below the fifth pass carry their original numbers with these corrections beside them.</p>'
              f'<h3>Blocking</h3>{audit_table("blocking")}<h3>Material</h3>{audit_table("material")}'
              f'<h3>Wind: what gates each machine</h3><p class="intro">{_short(_WC["summary"], 1200)}</p>{wind_table()}')

page = open("page_template.html").read().replace("<!--PLATES_TREE-->", "\n".join(TREE)).replace("<!--AUDIT-->", AUDIT_HTML).replace("<!--PLATES_BEHIND-->", "\n".join(BEHIND)).replace("<!--SHADE_TABLE-->", SHADE_TABLE).replace("<!--PLATES_SETUP-->", "\n".join(SETUP)).replace("<!--ANIM_JS-->", ANIM_JS).replace("<!--PLATES_MOUNT-->", "\n".join(MOUNT)).replace("<!--PLATES_FLOWER-->", "\n".join(FLOWER)).replace("<!--FLOWER_TABLE-->", CORR).replace("<!--PLATES_3D-->", "\n".join(D3)).replace("<!--VIEWER_JS-->", VIEWER_JS).replace("<!--PLATES_FACT-->", "\n".join(FACT)).replace("<!--PLATES_M5-->", "\n".join(S[7:] + C[4:])).replace("<!--PLATES_DISH-->", "\n".join(S[:4] + C[:2])).replace("<!--PLATES_FOLD-->", "\n".join(S[4:7] + C[2:4]))
open(os.path.join(OUT, "flexure_register.html"), "w").write(page); print("page:", os.path.getsize(os.path.join(OUT, "flexure_register.html"))//1024, "KB")

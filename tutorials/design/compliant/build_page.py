"""Assemble the drawing-register page: inline every plate SVG next to
its title block. Run from tutorials/design/compliant; writes
flexure_register.html into the given output dir."""
import re, os, sys, html, json
OUT = sys.argv[1]; FIG = "figures"
def svg(name):
    s = open(os.path.join(FIG, name) if not name.startswith(("fact/", "stage2/", "stage3/")) else name).read()
    s = s[s.index("<svg"):]
    s = re.sub(r'<svg([^>]*?)\swidth="[^"]*"\sheight="[^"]*"', r'<svg\1', s, count=1)
    s = s.replace("<svg", '<svg style="width:100%;height:auto;display:block"', 1)
    return s
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
def plate3d(num, title, json_path, ref, rows, note=""):
    model = open(json_path).read()
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
    parts = _json.load(open(json_path))["parts"]
    return "Legend: " + "; ".join(f'<span style="display:inline-block;width:10px;height:10px;border-radius:2px;vertical-align:middle;background:{p.get("color","#888")}"></span> {html.escape(p["name"])}' for p in parts)

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


D3.append(plate3d(28, "The dish mount as a freedom, actuation and constraint topology (equinox noon)", "stage3/hashemi_pneumatic/out/hp2_equinox_noon.json",
  "Stage 3. The nix-support Cassegrain Hashemi machine, optics untouched; the mount designed by Hopkins's FACT process and checked over 59 Quetta sun positions",
  [("freedom space", "the sphere of rotations about F (3 DOF, Fig. 2.2 of the thesis); the tracking pair at any instant is 2 DOF Type 1"), ("constraints", "four 8 mm wires from an outrigger ring r 3.2 m to the spigot at F: lines of the constraint space, rank 3, one redundant; 0.14 m clear of the strip all year"),
   ("ground", "Hashemi's near method: the focal tube through the slot carries the strip and the bridle apex; the env's north tower pierces the membrane at 13 of 59 positions"), ("actuation", "pure couples: the flexing stem r 0.80 m at 1.0 bar clamped to the back ring, turgor by pumping water between side chambers; four pretensioned tendons to deck anchors chosen by the clearance solver (44 of 828 lines survive the year)"),
   ("wind", "9 m/s: 0 infeasible of 531 cases, stem SF 9.6, 0.38 mrad, F moves 0.1 mm, first mode 13 Hz; 25 m/s: stays deployed, stem SF 1.8, rope SF 7.6"), ("water", "2 m in the root: +16 kN m of wrinkling moment, 4 t of ballast = the 25 m/s overturning demand, slosh 0.75 Hz")],
  legend("stage3/hashemi_pneumatic/out/hp2_equinox_noon.json")))
D3.append(plate(29, "Equinox noon, engineering views", "stage3/hashemi_pneumatic/out/hp2_equinox_noon_views.svg", "isometric from the south-west, detail of the tube, strip, bridle apex and stem clamp; plan, front, side; env frame, mm",
  [("shows", "beam rim -> strip -> F2 down the tube; bridle wires (blue) meeting F; stem from the root; tendons to the far deck anchors"), ("slot", "open above 54 deg: the keyhole toward the sun")],
  "Hidden-line projection of the CadQuery model (3d/cad_views.py). Light grey: deck, wall, column, pot, root housing."))
D3.append(plate(30, "Summer noon and equinox morning", "stage3/hashemi_pneumatic/out/hp2_summer_noon_views.svg", "summer noon, el 83 deg: the dish under F with the tube through its slot, the stem short and upright",
  [("morning sheet", "stage3/hashemi_pneumatic/out/hp2_morning_views.svg: el 38 deg ESE, the dish 3.5 m west of F, the stem at 5 m reach"), ("both", "same lines, same anchors; only lengths change")],
  "The morning sheet is committed beside this one."))
D3.append(plate(31, "Equinox day: rims, stem axes and bridle lines", "stage3/hashemi_pneumatic/out/hp2_sweep_views.svg", "nine hours; every bridle line meets F, every stem axis leaves one root",
  [("orbit", "vertex x 0.1-4.5 m, |y| to 3.9 m, z 5.9-9.0 m over the year; rim to x 5.7 m and |y| 4.5 m"), ("why it matters", "the dish-fixed attachments sweep 220 deg of azimuth relative to the ground in a day: any tendon route must be checked at every hour, which is what the solver does")],
  "Rims drawn thin; bridle in blue, stem axes dark."))
page = open("page_template.html").read().replace("<!--PLATES_3D-->", "\n".join(D3)).replace("<!--VIEWER_JS-->", VIEWER_JS).replace("<!--PLATES_FACT-->", "\n".join(FACT)).replace("<!--PLATES_M5-->", "\n".join(S[7:] + C[4:])).replace("<!--PLATES_DISH-->", "\n".join(S[:4] + C[:2])).replace("<!--PLATES_FOLD-->", "\n".join(S[4:7] + C[2:4]))
open(os.path.join(OUT, "flexure_register.html"), "w").write(page); print("page:", os.path.getsize(os.path.join(OUT, "flexure_register.html"))//1024, "KB")

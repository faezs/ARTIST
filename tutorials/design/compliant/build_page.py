"""Assemble the drawing-register page: inline every plate SVG next to
its title block. Run from tutorials/design/compliant; writes
flexure_register.html into the given output dir."""
import re, os, sys, html
OUT = sys.argv[1]; FIG = "figures"
def svg(name):
    s = open(os.path.join(FIG, name) if not name.startswith("fact/") else name).read()
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
page = open("page_template.html").read().replace("<!--PLATES_FACT-->", "\n".join(FACT)).replace("<!--PLATES_M5-->", "\n".join(S[7:] + C[4:])).replace("<!--PLATES_DISH-->", "\n".join(S[:4] + C[:2])).replace("<!--PLATES_FOLD-->", "\n".join(S[4:7] + C[2:4]))
open(os.path.join(OUT, "flexure_register.html"), "w").write(page); print("page:", os.path.getsize(os.path.join(OUT, "flexure_register.html"))//1024, "KB")

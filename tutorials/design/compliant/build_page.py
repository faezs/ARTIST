"""Assemble the drawing-register page: the fifth pass (sheets 52-59) and the wind verdict, nothing superseded. Run from
tutorials/design/compliant; writes flexure_register.html into the given output dir."""
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
TR = "stage3/tree/out/"
_sw = open(TR + "sweep.txt").read().strip().splitlines()
TREE = []
_ws = open(TR + "wind_size.txt").read().strip().splitlines()
_pt = open(TR + "path.txt").read().strip().splitlines()
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
_fe = open("stage3/setup_sim/out/flower_ident.txt").read().strip().splitlines(); _fec = open("stage3/setup_sim/out/flower_calm_ident.txt").read().strip().splitlines(); _fe9 = open("stage3/setup_sim/out/flower_w9_ident.txt").read().strip().splitlines()

TREE.append(plate(52, "The flower proper: one stem, a crown of branches carrying the exact spherical membrane, F on the light pipe (equinox noon)", TR + "tr_equinox_noon_views_small.png",
  "isometric from the south-west; detail of the stem, the receptacle and the branches under the head; plan, front, side. The head sits on the env's orbit about F (hashemi.ini: beta_dev 0, retro), 4 m from F along the sun line; the beam converges on the strip 0.6 m before F and goes down the pipe.",
  [("primary", "the exact hashemi.ini membrane: a spherical cap a 2.1 m, R 8 m, f = g = 4 m, no hole, no slot; the crown's tips carry it"),
   ("crown", "one stem 1 m (r 0.15) 2 m north of the pipe; from its top six primaries to r 0.8 on the head's back, twelve secondaries to r 1.45, sixty twigs to a Vogel scatter of tips on the sphere: the foliage whose inner surface is the spherical section"),
   ("F", "on the light pipe, the cass machine's bore r 0.7 to z_deck + 0.35 + max(g sin el + a cos el) = 4.87 m over the deck; the hyperboloid strip r 0.6 at F - 0.6: a Masdar beam-down; the pipe is separate of the tree"),
   ("why one stem", "the sphere has no axis: only its centre of curvature must be at F + 4 s, the attitude about it is free (the env's beta_dev); the paraboloid needed vertex and axis, which is what defeated the second pass's stem")],
  "Hidden-line projection of the CadQuery model; mm. The branches are drawn as smooth curves from the receptacle; their lengths at each sun are in the sweep sheet."))
TREE.append(plate(53, "The year's sweep: the head on the orbit sphere at 8, 12 and 16 h equinox and at the solstice noons", TR + "tr_sweep_views_small.png",
  "rims, membranes and crowns at five suns about one stem and one pipe",
  [("hub", _sw[0].split(": ", 1)[1]), ("branches", _sw[2].split(": ", 1)[1]), ("shadow", _sw[3]), ("rim", _sw[1].split("; ")[1])],
  "The crown is a mechanism, not a shape: it carries the head around a quarter of the orbit sphere. With the head parked low and turning half the sun's motion (the sphere's freedom) the branches shorten to 1-3 m at the price of beta up to 40 deg; stage3/tree/path.py."))
TREE.append(plate(54, "Winter noon and equinox morning", TR + "tr_winter_noon_views_small.png", "el 36: the head 3.2 m north and 2.5 m up; the morning sheet stage3/tree/out/tr_equinox_morning_views.png has it 2.8 m west of the meridian",
  [("winter noon", "hub 3.2 m north, 2.5 m up; primaries 1.5-2.9 m"), ("equinox 9 h", "hub 1.45 m north, 2.8 m west, 2.4 m up; primaries 3.0-4.6 m; the crown turns about the stem")], "Hidden-line projection of the CadQuery model; mm."))
TREE.append(plate(55, "Summer noon, el 83: the head 0.9 m over the deck beside the pipe, looking up", TR + "tr_summer_noon_views_small.png", "the lowest position of the year: the hub 0.5 m north of the pipe's axis",
  [("wind", _sw[4].split("; ")[0].split(": ", 1)[1]), ("stiffness", _sw[4].split("; ")[1])], "The gating load. The fourth-pass stalk machine with the dish's drag in its simulation: stalk lean 1.0 deg at 9 m/s (the fine stage's whole range), 21 deg at 25 m/s."))
TREE.append(plate(56, "The crown sized for wind: a hexapod of six steel struts from a receptacle ring r 1.5 m, the calyx under the membrane, a 215 mm steel stem (equinox noon on the env's law)", TR + "tw_equinox_noon_views_small.png",
  "The audit's loads (peak factor 3 on the mean wind; 40 m/s 3-s gust; lift and hinge moment) applied to the one-stem flower. A cantilever crown cannot hold the head to 5 cm at F (its tip rotation alone costs 2 f theta, audit F8); a hexapod can. The pipe is drawn as the env has it: the bore from F through the membrane's 0.5 m hole to the chase, the strip on an arm from a tower 3 m north (arm_north), not a tube under F (audit F3).",
  [("loads", "9 m/s mean: 3.05 kN, 0.82 kN m, lift 1.41 kN at the peak; 12 m/s: 5.4 / 1.45 / 2.5; 15 m/s: 8.5 / 2.3 / 3.9; 40 m/s gust: 16.6 kN, 16.7 kN m, 7.7 kN unstowed, or 1.0 kN, 3.9 kN m and 17.5 kN uplift stowed face-up"),
   ("legs", "on the env-law poses the worst is day 50 at 10 h (hub 3.0 m north, 2.1 m west, 3.1 m up; legs 1.3-5.2 m). Receptacle ring r 1.5 m: leg forces 13 kN at the 9 m/s peak, 35 kN at 15 m/s, 28 kN stowed in the gust, 128 kN tracking through it; steel CHS 85 x 5.3 (225 kg for six) holds the image within 1.2 / 2.2 / 3.4 cm at 9 / 12 / 15 m/s, first mode 16 Hz; 115 x 7.2 (413 kg) to track through the gust. A receptacle of r 1.0 needs 115 x 7.2 for the same duty and walks 3.3 / 5.8 / 9.1 cm; r 0.6 fails (10 cm at 9 m/s). At equinox noon the legs are 0.8-1.8 m and 45 x 3 would do: the mornings size the crown"),
   ("not hoses", "a water column in a fabric hose (E t 500 kN/m) has a column modulus of 2 MPa: 69 m of image walk at the 9 m/s peak; steel-wound hose 7 m. The water may drive the struts; it cannot be them"),
   ("stem", "root 12 kN m at the 9 m/s peak, 34 at 15 m/s or the stowed gust, 56 unstowed: steel CHS 215 x 9 mm, 2 mrad = 2 cm at F; an inflated stem r 0.4 at 3.4 bar turns 121 mrad: a hinge"),
   ("calyx", "74 N per tip at the 9 m/s peak (405 N unstowed gust): twigs 18 mm, secondaries 40 mm aluminium (34 / 72 mm for the unstowed gust); membrane pressure difference 320 Pa (1750)"),
   ("budget", "image walk at F at the 9 m/s peak: legs 1.2 + stem 1.8 = 3.0 cm of the 4.9 half-power; 5.6 cm at 12 m/s, so the stow decision sits near 11 m/s mean unless the stem grows to 273 mm (1.0 cm) or the legs to 115 x 7.2")],
  "Hidden-line projection of the CadQuery model; mm. The legs' lengths at each sun are the actuation; the still-head schedule keeps them within 1.7-4.9 m."))
TREE.append(plate(57, "Where the hexapod can carry the head on the env's own law (orbit sphere, axis the bisector, beta within 36 deg): 9, 12 and 15 h at the equinox, winter and summer noon", TR + "tw_sweep_views_small.png",
  _pt[0],
  [("reach", _pt[1]), ("hub", _pt[2]), ("shadow", _pt[3]), ("rim", _pt[4]),
   ("audited", "the still-head family first drawn here (P + R n = F + R/2 s) was the sphere's paraxial focus only and is withdrawn (audit F2); a head that does not move pays the full sun angle as beta and is optically dead by mid-morning. The head must travel the orbit sphere; from one fixed receptacle the hub lies 1.3-5.7 m away over the year, beyond a hexapod's stroke (F13). What can carry it: a luffing, slewing pedicel from the stem top to the hexapod's receptacle, or Hashemi's rail")],
  "Hidden-line projection of the CadQuery model; mm. The poses drawn are those the hexapod reaches; the rest of the day needs the pedicel."))
TREE.append(plate_gif(58, "The flower sets itself up, identifies itself and tracks: six struts pumped from the stow, a calibration dither, the day at 12 m/s mean from the south with von Karman gusts to 18", "stage3/setup_sim/out/setup5.gif",
  "3-D soft-body simulation (NVIDIA Warp, the fourth pass's solver): the hashemi.ini membrane as a 130 kg rigid clique on six bilateral force-capped struts from a receptacle ring carried by a pedicel whose compliance (200 kN/m at the receptacle: the 219 x 8 boom on the 215 x 9 stem) is a sprung clique; the env's head law; drag with front/back asymmetry and lift, the pitching moment, the membrane's own figure under wind, von Karman gusts (Iu 0.25, L 50 m). The loop closes through the identified static gain when the fit has skill, else through the analytic Jacobian.",
  [("setup", _i5[1].split(": ", 1)[1]), ("identification", _i5[2].split(": ", 1)[1]), ("the day, 12 m/s S", _i5[3].split("): ", 1)[1]), ("the day, 9 m/s S", _i9[3].split("): ", 1)[1]), ("the day, still air", _i5c[3].split("): ", 1)[1]),
   ("the fit", "with a rigid pedicel the DMDc fit had skill 0.96 over persistence; with the pedicel's compliance and gusts the +-2 mm dither is buried in buffeting and receptacle wobble (skill 0.1-0.4, gain 40-190 % off), the loop falls back to the analytic Jacobian and still holds; the remedy is a larger dither and the wind as a second measured input"),
   ("what is not in it", "the quarter-hour pose steps of the schedule become jumps in a day compressed to 60 s; the stem's bending is a lumped spring here and a rod on sheet 59")],
  "Film: legs (brown), rim (grey), the receptacle ring on its stem, the pipe, F (violet), the beam (orange), the head's axis (teal). The memo lists the eight defects the first version had, each visible in a run, and the one that decided the architecture: a fixed receptacle leaves the hexapod five well-conditioned islands a day; the pedicel is the stage the kinematics demanded."))
TREE.append(plate_gif(59, "The same flower as Cosserat rods: the representation soft robots are actually built in (PyElastica), with the stem's and the pedicel's flexibility in the rods themselves", "stage3/setup_sim/out/flower.gif",
  "Cosserat-rod simulation (PyElastica 1.0): stem 215 x 9 and telescoping boom 219 x 8 as rods, two relative servo joints (slew and luff at the stem top, the wrist at the boom tip), the receptacle ring and the head as rigid bodies, six 85 x 5.3 struts on ball joints at offsets; the same schedule, dither, DMDc identification, integral loop, drag with asymmetry and lift, membrane figure and von Karman gusts as sheet 58. dt 1e-5 s, 4.4 million explicit steps per run.",
  [("setup", _fe[1].split(": ", 1)[1]), ("identification", _fe[2].split(": ", 1)[1]), ("the day, 12 m/s S", _fe[3].split("): ", 1)[1]), ("the day, 9 m/s S", _fe9[3].split("): ", 1)[1]), ("the day, still air", _fec[3].split("): ", 1)[1]),
   ("the fit", "DMDc on the increments with three command lags: skill 0.44 at 12 m/s (the loop ran through the analytic Jacobian), 0.50 at 9 m/s and 0.53 in still air (the loop ran through the identified gain, 39-50 % from the Jacobian, and hunted +-4 cm in yaw at the struts while F held: one-step skill does not qualify a gain for the loop, the gate is now 30 %). Offline on the saved calibration pairs (ident_offline.py) a Hankel DMDc, the Koopman time-delay embedding, predicts one step ahead with skill 0.95 in 12 m/s gusts and 0.97 calm, but its settled gain is ill-determined in wind: the gain the loop needs wants a richer excitation than a +-2 mm dither"),
   ("what the rods taught", "the explicit step is set by the Timoshenko shear cut-off of the thinnest tube (1.5e5 rad/s for 60 x 4), not the axial CFL; cantilever spokes bend 10 cm under 5 kN, so crowns are rings and plates; a command that steps once per frame is a 100 kN hammer on a steel strut (ramp it, damp the axial mode); a servo referenced to the flexing stem's actual attitude pumps energy and flutters, a relative servo does not")],
  "Film: the stem and boom (brown, thick), the receptacle ring, the six struts and the platform ring through their heads, the head's rim (grey), the pipe, F (violet), the beam (orange), the head's axis (teal). The rods carry their own compliance: the receptacle's error against its command is the stem's and boom's bending under the crown's weight and the wind, and the loop through the struts absorbs it. stage3/setup_sim/flower_elastica.py, memo.md."))
# ---- the Handbook's algorithms used: chapter 6 (FACT) on the strut joints, chapter 7 (topology optimization) on the calyx, the head as built
TP = "stage3/topopt/out/"; import json as _jt
_fb = _jt.load(open(TP + "fact_ball.json")); _gt = _jt.load(open(TP + "ground_truss.json")); _rc = _jt.load(open(TP + "ring_calyx.json")); _mw = _jt.load(open(TP + "membrane_wind.json"))
_fbl = _fb["lines"]; _rcl = _rc["lines"]; _mwl = _mw["lines"]
def _find(lines, start): return next((l.strip() for l in lines if l.strip().startswith(start)), "")
TREE.append(plate(60, "Chapter 6 used: Hopkins's four FACT steps on the flower's twelve strut joints, a flexure ball at each strut end", TP + "fact_ball.png",
  "Step 1 the DOFs (three rotations about the joint centre); step 2 the freedom space (the sphere of rotation lines, 3-DOF Type 3) and its constraint space by screw reciprocity (every line through the centre); step 3 three independent lines, the wire tripod of Fig. 6.8c; step 4 the equivalence of Fig. 6.7a, each wire as two orthogonal blades in series (Fig. 6.8d). Every step checked in screw algebra (fact/fact_core.py); sizing is outside FACT and says so.",
  [("motion", f"the six leg lengths are constant over the day (both rings are defined from the head pose), so each ball turns only with the loop's corrections: the production runs used {_fb['dl_run_mm']:.0f} mm at most ({_fb['theta_run_deg']:.2f} deg at the calyx end); the loop's clip is the joint's design variable and becomes +-{_fb['clip_mm']:.0f} mm ({_fb['theta_deg']:.2f} deg for one leg at full stroke)"),
   ("check", "tripod rank 3, DOF 3, the three rotations through C and nothing else; two wires leave a screw, three coplanar wires are dependent (p. 85); a stacked-blade leg has exactly a wire's five freedoms"),
   ("load", f"{_fb['P_leg']:.0f} N per leg at the runs' logged maximum strut force ({_fb['P_strut_run']/1e3:.1f} kN), {_fb['P_leg_survival']:.0f} N at the 40 m/s survival gust (14 kN per strut: wind_size.py's 16.6 kN drag, 7.7 kN lift and 16.7 kN m hinge moment through the hexapod)"),
   ("the stress rule", "a blade riding the body's rotation theta about C also has its end moved by theta x s, so its worst curvature is (1 + 6 s_mid/L) theta/L, four times pure bending for a blade starting at C and eleven for the second of a stacked pair; at the old +-40 mm clip no blade meets bending and buckling at once"),
   ("blades", f"Ti 6Al-4V {_fb['blade']['t_mm']:.1f} x {_fb['blade']['w_mm']:.0f} mm, {_fb['blade']['L_mm']:.0f} mm free, the pair at {_fb['blade']['s1_mm']:.0f} and {_fb['blade']['s2_mm']:.0f} mm from C: outer blade {_fb['blade']['sigma_MPa']:.0f} MPa at the clip, Euler {_fb['blade']['P_cr']/1e3:.1f} kN (SF 3 at survival); the joint {_fb['k_joint_MN_m']:.0f} MN/m axially, {_fb['k_ratio']:.1f} x the strut's own EA/L"),
   ("why not wires", _find(_fbl, "  the wire tripod holds").lstrip())],
  "Twelve joints, 72 blades, no bearings, no backlash, no lubrication: the joints the flower wanted from the start. An opus audit (two verifiers per finding) corrected the stress rule, the rotation and the load citations of the first version; stage3/topopt/fact_ball.py, out/audit_findings.json."))
TREE.append(plate(61, "Chapter 7 used: Frecker's ground-structure method on the book's own examples, then on the flower's calyx and receptacle", TP + "ground_truss.png",
  "A dense truss ground structure, the members' areas as design variables between a near-zero floor and a cap, a volume fraction, MMA (sec. 7.6, single constraint, our own); the compliant-mechanism objective (maximise the output displacement against input and output springs, Eq. 7.5) for the book's displacement inverter (Fig. 7.3a) and half pliers (Fig. 7.5); minimum compliance for the two stiffness parts. Members at the floor are void; the rest in grey scale of area as in Fig. 7.5d. The SIMP continuum method (sec. 7.4.1, Sigmund's 88-line structure) reproduces the inverter of Fig. 7.8 in stage3/topopt/out/simp_cm.png.",
  [("inverter", f"u_out {_gt['inverter']['u_out']:+.2f} for u_in {_gt['inverter']['u_in']:+.2f}: the diamond of Fig. 7.3a (mirrored), output against input"),
   ("pliers", f"jaw {_gt['pliers']['u_out']:+.3f} for handle {_gt['pliers']['u_in']:+.2f}: a compliant pivot pair over the symmetry line, a pliers-like problem after Fig. 7.5 rather than its cells"),
   ("calyx", f"rim (24 nodes) to the six platform anchors under the audit's 15 m/s peak drag and hinge moment (37.63 and 10.07 per (m/s)^2) and the head's 130 kg: {_gt['calyx']['n_members']} members above 5 % of the cap, {_gt['calyx']['mass']:.0f} kg Al at the volume fraction asked (the mass is an input of this method, not a result), rim tilt {_gt['calyx']['rim_tilt_mrad']:.2f} mrad, stress {_gt['calyx']['max_stress']/1e6:.0f} MPa"),
   ("receptacle", f"six anchors to the wrist under +-3.5 kN alternating plus the head's weight share: {_gt['receptacle']['n_members']} members, {_gt['receptacle']['mass']:.0f} kg, anchor displacement {_gt['receptacle']['anchor_disp_mm']:.1f} mm, stress {_gt['receptacle']['max_stress']/1e6:.0f} MPa"),
   ("what it is not", "a truss of pinned bars; the ring itself is a continuous beam and the membrane is a film, which is sheet 62's model")],
  "stage3/topopt/ground_truss.py, simp_cm.py, mma1.py."))
TREE.append(plate(62, "The head as built, not as a plate: Mylar on a ring, pumped to f 4, the wind through the film into the ring and the spider, and the film's own figure under gusts: a sealed plenum is the compliant canceller", TP + "membrane_wind.png",
  "The repo's own membrane solvers (tutorials/03_membrane_beamdown_tandoor.py, 1-D axisymmetric FvK, zoned as hashemi.ini: five plenum zones, zone_c 0.4, T_pre 2000 N/m; tutorials/membrane_fvk2d.py for the non-axisymmetric part). The wind on the bowl is q Cd uniform plus the pitching moment as a gradient 8 c_M q x/a. The ring is an aluminium tube of frame elements, the spider a ground structure to the six anchors (stage3/topopt/out/ring_calyx.png).",
  [("at work", _find(_mwl, "1. the membrane").split(": ", 1)[1]),
   ("the film's pull", _find(_rcl, "the film's pull").split(": ", 1)[1]),
   ("uniform part", _find(_mwl, "2. a uniform").split(": ", 1)[1]),
   ("on a constant-pressure supply", "a blower holding the plenum's gauge pressure lets the wind through one to one: the 9 m/s mean alone defocuses 3.3 cm, the gusts 1.7 cm rms (6.0 and 3.0 at 12 m/s); the RL policy's one action per 20 s trims the mean and leaves 79-86 % of the gust variance; a local pressure loop at 0.5 Hz leaves 0.5 / 1.1 / 1.8 cm at 9 / 12 / 15 m/s"),
   ("the compliant canceller", "seal the plenum between the pump's trims. " + _find(_mwl, "   the film's volume from the rim plane").strip()),
   ("sealed, at 9 / 12 / 15 m/s", "; ".join(_find(_mwl, f"   U {u:4.1f} m/s, sealed").split(": ", 1)[1] for u in (9.0, 12.0, 15.0))),
   ("what the seal costs", _find(_mwl, "   what the seal costs").strip()),
   ("the gradient", _find(_mwl, "   linear theory").strip()),
   ("blur floor", "; ".join(_find(_mwl, f"   U {u:4.1f}: p1").strip() for u in (9.0, 12.0, 15.0))),
   ("2-D check", _find(_mwl, "   2-D FvK check").strip()),
   ("ring and spider", _find(_rcl, "4. spider").split(": ", 1)[1] + "; " + _find(_rcl, "   the gust adds").strip())],
  "The first version proposed a constant-force regulator on a diaphragm; the audit refuted it (a regulator on the plenum cannot see the face, and a 140 kg bell has a corner near 0.2 Hz). The compliant canceller is the opposite: the trapped air of a sealed plenum is a constant-volume regulator, the film cannot change volume without compressing it, so the differential pressure rises to meet the wind, to within the gas compressibility, with no moving part; the RL policy trims temperature and leakage at its 20 s step. What no pressure can touch is the pitching moment's gradient, an n = 1 mode with zero mean slope: no pointing error, only blur, the membrane's floor under wind. stage3/topopt/membrane_wind.py, ring_calyx.py, out/audit_findings.json."))
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
AUDIT_HTML_FULL = (f'<p class="intro">Six opus auditors (optics, shading, mount structures, simulation physics, inflated beams, the page\'s own claims) each read the files and recomputed; two independent verifiers judged every finding. {_counts["blocking"]} blocking, {_counts["material"]} material and {_counts["minor"]} minor findings were confirmed; 4 were refuted. The full record with every recomputation is <code>stage3/audit/findings.md</code>. What it means for the passes: the fourth pass\'s optics fail as drawn (its style intercepts the converging beam, its spine lies on the beam axis, its hole is undersized, and its light-gain claim was measured against a double-counted baseline: at a mirror reflectivity of 0.88 it delivers less light than the tube machine), its pivot arithmetic used the wrong axis and the wrong blade model, and every wind number in this branch was a mean-only number without a gust factor; the third pass\'s structure is the soundest of the moving machines; the self-setup film was run in still air. The fourth pass stands on the register as a record, superseded by the fifth; the sheets below the fifth pass carry their original numbers with these corrections beside them.</p>'
              f'<h3>Blocking</h3>{audit_table("blocking")}<h3>Material</h3>{audit_table("material")}'
              f'<h3>Wind: what gates each machine</h3><p class="intro">{_short(_WC["summary"], 1200)}</p>{wind_table()}')

AUDIT_HTML = (f'<p class="intro">{_short(_WC["summary"], 1200)}</p>{wind_table()}')
page = open("page_template.html").read().replace("<!--PLATES_TREE-->", "\n".join(TREE)).replace("<!--AUDIT-->", AUDIT_HTML)
open(os.path.join(OUT, "flexure_register.html"), "w").write(page); print("page:", os.path.getsize(os.path.join(OUT, "flexure_register.html"))//1024, "KB")

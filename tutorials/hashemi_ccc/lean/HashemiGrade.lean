/-
# The grading: what every column of every compiled morphism IS

`hashemiEnv : … → Fin 326 → ℝ` is one tensor, and every one of its columns is a different kind of
thing: a length in the bolt plane, an angle about the roof's vertical, a temperature of the oil, a
power at the pot, a truth value of a theorem.  The row does not say so, and every defect of the
week was a column whose meaning the row could not carry:

* the reward that differed by 75x between the two paths — a column in the trainer's units summed
  with a column in raw units;
* scene inputs pooled in the wrong frame — a `dish`-frame point placed by a `roof`-frame
  embedding;
* the mount pinned to his 0.8 m constants while the optics scaled — a `length` that was a
  constant and should have been a definition of `a`;
* an exchanger conductance that was a bare number with no law — a `W/K` with no declaration
  behind it;
* a figure pinned at the favourable end of its own interval — a `dimensionless` with no interval.

So: **a grade per column**, and it is not decoration.  `Ccc.printCBox` reads the `truth` kind and
stops computing a Lipschitz bound for an indicator (a number that is meaningless: 0 when the gate
is decided and ∞ when it is straddled, never a sensitivity).  The runtime reads `subsystem` and
`kind` and selects its observation, reward and HUD columns by them, so 230 mount columns landing
underneath cannot shift anything.  The scene printer reads `frame` and refuses to place a point
in an embedding whose domain it is not.

## What is derived and what is stated

DERIVED, mechanically, by the driver (`HashemiCcc.lean`), never written here:

* the **truth** kind.  A column is truth-valued exactly when its node is a boolean or `b2r`
  (`ite` on a boolean with the literals `1` and `0`) — which is what `b2r` compiles to, and
  `b2r` is what every `Prop` column of `megaReqs`, `megaThmsClosed` and `megaThmsState` is made
  of.  The derivation is checked against every grade stated below that claims `truth`: a column
  that stops being an indicator, or starts being one, fails the emit.
* the **declaration**.  `megaNames`' proposition columns are named after their own theorems, so
  `TandoorHashemi.prop_<name>` (or `TandoorHashemi.<name>`) is looked up in the environment and
  is the column's defining declaration.  That covers the 113 proposition columns and about 40 of
  the geometry's, with no table.
* the **subsystem and kind of an ungraded proposition column**: `omega`, `truth`.  A column added
  to `megaThmsState` tomorrow is graded the day it is added.
* the **frame morphisms' domain and codomain**, from their names: `roofOfDish` is `dish → roof`,
  `envSkyOfDish` is `dish → sky`.  The scenes name every embedding `<cod>Of<Dom>`.

STATED, below, in one place:

* the subsystem, kind, unit and frame of every column that is not a proposition — 150-odd of
  them, grouped by grade so that no grade is typed twice;
* the defining declaration of the columns whose name is not their declaration's (`capture` is
  `dishPower`'s, `T_oil` is `coilProfile`'s);
* the frame every vertex-producing definition of the scenes writes its coordinates in.

## Two notes on the vocabulary

`kind` names the column's BASE dimension, and `unit` is exact.  An area (`per_dni`, m²) is a
`length` with the unit `m^2`, a stress a `force` with `Pa`; a volt and an ampere have no kind in
this vocabulary and are `dimensionless` with an exact unit.  Nothing checks kinds against each
other — the checks compare units — so the base dimension is a classification, not a claim.

`Frame` carries `carriage` and `sky` beyond the four the machine's columns need (`roof`, `dish`,
`bolt`, `pot`): the scenes write points in the carriage's own frame and draw the sun's body in a
frame translated along the line of sight, and folding either into `roof` would make the frame
check pass on two embeddings that are not the same morphism.
-/

namespace HashemiGrade

/-! ## The vocabulary -/

/-- which part of the machine a column belongs to.  `omega` is the subobject classifier's: a
column that is the truth value of a proposition of the specification. -/
inductive Sub where
  | mount | optics | receiver | loop | pot | policy | reward | omega | scene
  deriving BEq, Repr, Inhabited

def Sub.name : Sub → String
  | .mount => "mount" | .optics => "optics" | .receiver => "receiver" | .loop => "loop"
  | .pot => "pot" | .policy => "policy" | .reward => "reward" | .omega => "omega"
  | .scene => "scene"

/-- the base dimension.  `truth` is the one the printers act on. -/
inductive Kind where
  | length | angle | temperature | power | energy | mass | force | moment | rate
  | dimensionless | truth
  deriving BEq, Repr, Inhabited

def Kind.name : Kind → String
  | .length => "length" | .angle => "angle" | .temperature => "temperature"
  | .power => "power" | .energy => "energy" | .mass => "mass" | .force => "force"
  | .moment => "moment" | .rate => "rate" | .dimensionless => "dimensionless"
  | .truth => "truth"

/-- the frame a column's coordinates are written in.  `none`: the column is a scalar, or is
already in the world (roof) frame. -/
inductive Frame where
  | roof | dish | bolt | pot | carriage | sky | none
  deriving BEq, Repr, Inhabited

def Frame.name : Frame → String
  | .roof => "roof" | .dish => "dish" | .bolt => "bolt" | .pot => "pot"
  | .carriage => "carriage" | .sky => "sky" | .none => "none"

def Frame.ofName : String → Option Frame
  | "roof" => some .roof | "dish" => some .dish | "bolt" => some .bolt | "pot" => some .pot
  | "carriage" => some .carriage | "sky" => some .sky | "none" => some .none
  | _ => none

/-- **one column's grade**.  `decl` empty means "derive it": the driver looks the name up in the
environment and falls back to the morphism the column is a column of. -/
structure Grade where
  sub : Sub
  kind : Kind
  unit : String
  frame : Frame := .none
  decl : String := ""
  deriving Repr, Inhabited

/-- the stated table's row: one grade and the columns that carry it -/
abbrev Row := Sub × Kind × String × Frame × List String

/-! ## The stated grades

Grouped by grade: a row is one (subsystem, kind, unit, frame) and every column that has it.  The
name is the column's name in `envNames` / `megaNames` / `loopNames` / `beamNames` /
`rewardNames` — the mount's `mount_` prefix and an observation's `obs_` prefix are stripped by
`lookup` below, and an indexed family (`flux_3`) is written once as `flux_*`. -/

def rows : List Row := [
  -- ---- the mount's state (megaStep, and the first 17 of every morphism that calls it)
  (.mount, .angle, "rad", .roof, ["az_next", "pointing_err", "el_dish"]),
  (.mount, .angle, "rad", .bolt, ["t_next", "t_dead", "t_achieved", "droop", "t_wind"]),
  -- THE WIND, which reached the kernel only as a convection coefficient until 2026-09-20
  (.mount, .moment, "N m", .bolt, ["wind_moment"]),
  (.mount, .force, "N", .none, ["wire_tension_w"]),
  (.mount, .truth, "", .none, ["taut_w"]),
  (.mount, .length, "m", .none, ["slack_next", "wire_len", "wire_run", "wire_paid"]),
  (.mount, .length, "m", .bolt, ["arm", "wire_bight"]),
  -- the slack wound back onto the drum is an ANGLE of the drum, not a length: `windBack`
  (.mount, .angle, "rad", .none, ["wire_wind"]),
  (.mount, .truth, "", .none, ["stalled", "taut", "wire_holds"]),
  (.mount, .rate, "rad/s", .bolt, ["swing_rate"]),
  (.mount, .rate, "rad/s", .roof, ["az_rate"]),
  -- the two gates the day and the cut are pulled back along, and their smooth companions
  (.omega, .truth, "", .none, ["sun_reachable", "lost_sun"]),
  (.omega, .dimensionless, "gate [0,1]", .none, ["sun_reachable_s", "lost_sun_s"]),

  -- ---- the optics (the 64 rays of dishPower, on the new pose)
  (.optics, .dimensionless, "fraction of rays", .none,
    ["capture", "capture_s", "hit_secondary", "passes_dish"]),
  (.optics, .length, "m^2", .none, ["per_dni"]),
  (.optics, .power, "W", .none, ["p_in", "power_W"]),
  (.optics, .length, "m", .dish, ["spot", "spotShift", "spotW"]),

  -- ---- the receiver: the flux that lands in the coil's annuli, and what the coil absorbs
  (.receiver, .power, "W", .dish, ["flux_*"]),
  (.receiver, .power, "W", .none, ["q_abs", "q_coil_loss"]),

  -- ---- the oil loop (HashemiOil.lean)
  (.loop, .temperature, "K", .none,
    ["T_oil", "T_film", "film_margin", "coil_*", "hist_*", "ret_*"]),
  (.loop, .power, "W", .none, ["q_pipe", "q_net", "p_pump"]),
  (.loop, .power, "W/K", .none, ["mcp"]),
  (.loop, .rate, "m^3/s", .none, ["flow"]),
  (.loop, .dimensionless, "fraction of life", .none, ["deg"]),
  (.loop, .dimensionless, "steps", .none, ["delay"]),
  (.loop, .dimensionless, "fraction of volume", .none, ["expansion"]),
  (.loop, .truth, "", .none, ["fault"]),

  -- ---- the pot: what crosses the exchanger into the wall band
  (.pot, .power, "W", .pot, ["q_pot"]),
  (.pot, .power, "W/K", .pot, ["UA_x"]),

  -- ---- the machine's geometry (megaGeom 0..19): lengths of the specification, not coordinates
  (.mount, .length, "m", .none,
    ["dishR", "dishF", "dishHalf", "dishSide", "sag", "ze", "screwLength", "hangerLength",
     "rollerRadius", "chord", "footLong", "standPost", "standFoot", "wireLen", "slotExit",
     "clearance", "sideGap", "bolt_over_bar", "Froof_r", "F_wander_ok", "F_wander_1cm",
     "focusShift_plumb", "hanger_set", "helixAdvance", "hM12", "rimDepth", "postCross",
     "edgeDepth", "wireLever"]),
  (.mount, .length, "m", .carriage, ["apexH", "zRail", "zBearing", "braceHeight", "outriggerEnd"]),
  (.mount, .dimensionless, "-", .none, ["rodTan", "cosTubeCut", "strutStrain"]),
  (.mount, .dimensionless, "V", .none, ["cableDrop"]),
  (.mount, .dimensionless, "A", .none, ["panel_amps"]),
  -- the pose, as coordinates of the bolt line's meridional plane and of the roof
  (.mount, .length, "m", .bolt, ["V_y", "V_z", "V8_y", "V8_z", "P_y", "P_z", "C_y", "C_z"]),
  (.mount, .dimensionless, "unit vector", .bolt, ["N_y", "N_z", "N8_y", "N8_z"]),
  (.mount, .length, "m", .roof, ["Froof_x", "Froof_y"]),
  (.mount, .angle, "rad", .bolt, ["deadPoint"]),
  (.mount, .angle, "rad", .none, ["tilt_one_turn"]),
  (.mount, .force, "N", .none, ["wireTension"]),
  (.mount, .force, "Pa", .none, ["boltStress"]),
  (.mount, .power, "W", .none, ["elPower", "elPower_screw"]),
  (.mount, .rate, "rpm", .none, ["az_rpm", "roller_rpm"]),
  (.mount, .length, "m", .dish, ["slackSpot"]),

  -- ---- the screw theory (megaScrew): reciprocal products of a wrench with a unit twist, and
  -- the velocity of the focus under a unit twist
  (.mount, .moment, "N m (at unit twist)", .none,
    ["recip_c0_yaw", "recip_c1_yaw", "recip_c2_yaw", "recip_c3_yaw", "recip_c4_yaw",
     "recip_g0_yaw", "recip_g1_yaw", "recip_g2_yaw", "recip_g3_yaw", "recip_g4_yaw",
     "recip_g5_yaw", "recip_g6_yaw", "drive_work_yaw",
     "recip_sw_h0", "recip_sw_h1", "recip_sw_h2", "recip_sw_h3", "recip_sw_h4",
     "recip_st_s0", "recip_st_s1", "recip_st_s2", "recip_st_s3", "recip_st_s4",
     "recip_roll_h0", "recip_roll_h1", "recip_roll_h2", "wire_moment"]),
  (.mount, .length, "m/rad", .roof,
    ["vF_yaw_x", "vF_yaw_y", "vF_yaw_z", "vF_swing_x", "vF_swing_y", "vF_swing_z", "v_roll_z"]),

  -- ---- the policy's observations (obsOf) and its commands.  `obs_X` of the env's row and `X`
  -- of the loop's row are the same column: `lookup` sends both here.
  (.policy, .angle, "rad", .roof, ["e_az"]),
  (.policy, .angle, "rad", .none, ["e_el"]),
  (.policy, .angle, "rad", .bolt, ["swing"]),
  -- the SAME quantity, twice, and the grading has to tell them apart.  `obs_taut` of the env's
  -- row is the machine's own indicator this step (`b2r (Taut …)`, so the graph says truth);
  -- `taut_obs` of the closed loop's row is LAST step's flag handed back in as an input, a real
  -- that carries 0 or 1 and whose box bound is the identity's.  Grading both `truth` made the
  -- emit refuse - correctly - because the loop's column is not an indicator of anything the
  -- kernel computed.
  (.policy, .truth, "", .none, ["obs_taut", "obs_holds"]),
  (.policy, .dimensionless, "flag {0,1}", .none, ["taut_obs", "holds_obs"]),
  (.policy, .dimensionless, "(K - 300) / 300", .none, ["oil"]),
  (.policy, .dimensionless, "gate [0,1]", .none, ["reach_s", "lost_s"]),
  (.policy, .dimensionless, "K / 300", .none, ["margin"]),
  (.policy, .dimensionless, "fraction of Qmax", .none, ["flow_obs"]),
  (.policy, .dimensionless, "fraction of life", .none, ["deg_obs"]),
  (.policy, .dimensionless, "command [-1,1]", .none, ["u_az", "u_el", "u_pump"]),

  -- ---- the trainer's reward.  THE UNITS ARE THE POINT: four columns in the parent's raw units
  -- and ONE in the trainer's, and the only difference between them is `reward_div`.  A host that
  -- adds a raw term to `r_trainer` is adding `reward_div` roti to the trainer's reward, which is
  -- the 75x of 2026-09-19.
  (.reward, .dimensionless, "roti (raw)", .none,
    ["r_shape_raw", "r_pump_raw", "r_deg_raw", "r_raw"]),
  (.reward, .dimensionless, "roti (raw) / reward_div", .none, ["r_trainer"])]

/-- the raw reward's unit, and the trainer's: the unit check reads these two strings and nothing
else, so the two names of the same quantity cannot drift apart -/
def rewardRawUnit : String := "roti (raw)"
def rewardTrainerUnit : String := "roti (raw) / reward_div"

/-- **the declarations that are not their column's name.**  The driver looks a column's name up
in the environment first; these are the columns whose defining declaration is called something
else, and they are the whole of what the environment cannot answer. -/
def declOf : List (String × String) := [
  ("az_next", "step"), ("t_next", "step"), ("slack_next", "step"), ("wire_len", "wireLen"),
  ("t_dead", "deadPoint"), ("stalled", "step"), ("taut", "step"), ("wire_holds", "step"),
  ("arm", "leverAt"), ("swing_rate", "elRate"), ("az_rate", "azRate"),
  ("wire_run", "wireRun"), ("wire_paid", "wireRun"), ("wire_bight", "bightDepth"),
  ("droop", "droopAt"), ("t_achieved", "swingAchieved"),
  ("wind_moment", "windMomentAt"), ("wire_tension_w", "wireTensionW"),
  ("taut_w", "wire_tautW_iff"), ("t_wind", "swingWind"),
  ("wire_wind", "windBack"),
  ("pointing_err", "pointingError"), ("el_dish", "megaStep"),
  ("sun_reachable", "SunReachable"), ("lost_sun", "LostSun"),
  ("sun_reachable_s", "sunReachableS"), ("lost_sun_s", "lostSunS"),
  ("capture", "dishPower"), ("capture_s", "dishPower"), ("per_dni", "dishPower"),
  ("p_in", "dishPower"), ("spot", "traceBeam"), ("hit_secondary", "traceBeam"),
  ("passes_dish", "traceBeam"), ("spotShift", "TandoorMount.spot"), ("spotW", "facetSpot"),
  ("power_W", "coilCapture"), ("sag", "TandoorSphere.sag"),
  ("flux_*", "inBin"), ("coil_*", "coilProfile"), ("T_oil", "coilProfile"),
  ("q_abs", "coilProfile"), ("q_coil_loss", "coilProfile"), ("q_pipe", "delivered"),
  ("q_pot", "effNtu"), ("q_net", "hashemiEnv"), ("hist_*", "shift"), ("ret_*", "shift"),
  ("T_film", "wallTemp"), ("film_margin", "oilFilmMax"), ("flow", "pumpCmd"),
  ("deg", "degradStep"), ("p_pump", "pumpElec"), ("mcp", "oilCp"), ("UA_x", "uaOf"),
  ("delay", "delayOf"), ("fault", "oilBulkMax"), ("expansion", "expansionFrac"),
  ("e_az", "obsOf"), ("e_el", "obsOf"), ("swing", "obsOf"), ("taut_obs", "obsOf"),
  ("holds_obs", "obsOf"), ("oil", "obsOf"), ("reach_s", "obsOf"), ("lost_s", "obsOf"),
  ("obs_taut", "step"), ("obs_holds", "step"),
  ("margin", "obsOf"), ("flow_obs", "obsOf"), ("deg_obs", "obsOf"),
  ("u_az", "mlpPolicy"), ("u_el", "mlpPolicy"), ("u_pump", "pumpCmd"),
  ("r_shape_raw", "rewardShapeRaw"), ("r_pump_raw", "pumpCostRaw"), ("r_deg_raw", "degCostRaw"),
  ("r_raw", "rewardStep"), ("r_trainer", "rewardStep"),
  ("V_y", "swungPt"), ("V_z", "swungPt"), ("N_y", "swungPt"), ("N_z", "swungPt"),
  ("V8_y", "swingVertex"), ("V8_z", "swingVertex"), ("N8_y", "swingNormal"),
  ("N8_z", "swingNormal"), ("F_wander_ok", "swingFocus"), ("F_wander_1cm", "swingFocus"),
  ("P_y", "pulleyAt"), ("P_z", "pulleyAt"), ("C_y", "edgeClipAt"), ("C_z", "edgeClipAt"),
  ("Froof_x", "rot"), ("Froof_y", "rot"), ("Froof_r", "rot"),
  ("postCross", "megaGeom"), ("rimDepth", "megaGeom"), ("bolt_over_bar", "megaGeom"),
  ("focusShift_plumb", "focusShift"), ("tilt_one_turn", "tiltOfMismatch"),
  ("hanger_set", "setLength"), ("panel_amps", "systemVolts"), ("cableDrop", "cableDrop"),
  ("elPower_screw", "elPower"), ("az_rpm", "azRate"), ("roller_rpm", "megaScrew"),
  ("drive_work_yaw", "recip"), ("wire_moment", "recip"), ("hM12", "hM12"),
  ("footLong", "Leg.footLong"), ("standPost", "hashemiStand"), ("standFoot", "hashemiStand"),
  ("outriggerEnd", "hashemiOutrigger"), ("zRail", "hashemiBase"), ("zBearing", "hashemiBase"),
  ("chord", "hashemi"), ("apexH", "hashemi"), ("ze", "zeHashemi"), ("sideGap", "sideGap"),
  ("t_dead", "deadPoint"), ("swing", "obsOf")]

/-! ## The lookup

Four rules, in order: the name itself; the mount's prefix; an observation's prefix (and the
`_obs` spelling the loop's row uses); an indexed family.  Nothing else — a name that survives all
four is ungraded, and the driver refuses to emit. -/

def sDrop (s : String) (n : Nat) : String := String.mk (s.toList.drop n)

/-- `flux_3` ↦ `flux_*`; a name that does not end in `_<digits>` is unchanged -/
def family (n : String) : Option String :=
  let cs := n.toList
  let ds := cs.reverse.takeWhile Char.isDigit
  if ds.isEmpty then none
  else
    let head := cs.take (cs.length - ds.length)
    if head.isEmpty || head.getLast! != '_' then none else some (String.mk head ++ "*")

def ofRows (n : String) : Option Grade :=
  rows.findSome? fun (s, k, u, fr, ns) => if ns.contains n then some ⟨s, k, u, fr, ""⟩ else none

/-- and the families that share one declaration: the 26 reciprocal products are `recip`, the
seven focus velocities are `pointVel` -/
def declPrefix : List (String × String) :=
  [("recip_", "recip"), ("vF_", "pointVel"), ("v_roll", "pointVel")]

/-- the declaration stated for a name (or for its family, or for its prefix) -/
def statedDecl (n : String) : Option String :=
  match (declOf.find? (·.1 == n)).map (·.2) with
  | some d => some d
  | none =>
    match (declPrefix.find? (fun p => n.startsWith p.1)).map (·.2) with
    | some d => some d
    | none => match family n with
      | some f => (declOf.find? (·.1 == f)).map (·.2)
      | none => none

/-- **the grade of a column**, by name.  `decl` is left empty: the driver fills it from the
environment, from `declOf`, or from the morphism the column belongs to. -/
partial def lookup (n : String) : Option Grade :=
  match ofRows n with
  | some g => some { g with decl := (statedDecl n).getD "" }
  | none =>
    if n.startsWith "mount_" then lookup (sDrop n 6)
    else if n.startsWith "obs_" then
      let b := sDrop n 4
      match lookup b with
      | some g => some { g with sub := .policy }
      | none => match lookup (b ++ "_obs") with
        | some g => some { g with sub := .policy }
        | none => none
    else match family n with
      | some f => lookup f
      | none => none

/-- **the name a column is graded under**: the mount's and the observation's prefixes stripped,
an indexed family folded.  The driver looks THIS up in the environment when a column's defining
declaration is not stated — `mount_HoldsDish` is `HoldsDish`, `mount_AH_bounds` is
`prop_AH_bounds`. -/
partial def base (n : String) : String :=
  if (ofRows n).isSome then n
  else if n.startsWith "mount_" then base (sDrop n 6)
  else if n.startsWith "obs_" then
    let b := sDrop n 4
    if (lookup b).isSome then base b
    else if (lookup (b ++ "_obs")).isSome then base (b ++ "_obs")
    else b
  else match family n with
    | some f => f
    | none => n

/-- the columns of a morphism that no rule grades.  The driver grades the propositions itself
(they are derived, not stated), so this is what it reports when a column has no grade at all. -/
def ungraded (cols : Array String) : Array String :=
  cols.filter fun c => (lookup c).isNone

/-! ## The scenes' frames

A scene leaf is a definition of the specification drawn through an embedding.  The embedding's
name says which frames it goes between (`roofOfDish` is `dish → roof`); the leaf's own frame is
stated here, definition by definition, because nothing else in the specification says it — and
that is exactly the check: a point of the dish placed by the carriage's embedding is a frame
error, and the printer refuses it. -/

/-- `roofOfDish` ↦ `(dish, roof)`, `envSkyOfDish` ↦ `(dish, sky)`.  The `env` prefix marks the
same morphism at the pose the env's own step produced, and carries the same frames. -/
def frameMorphism (n : String) : Option (Frame × Frame) :=
  let n := if n.startsWith "env" then
      let r := sDrop n 3
      String.mk (r.toList.head!.toLower :: r.toList.tail!)
    else n
  let parts := n.splitOn "Of"
  match parts with
  | [cod, dom] =>
    match Frame.ofName cod, Frame.ofName (String.mk (dom.toList.head!.toLower :: dom.toList.tail!)) with
    | some c, some d => some (d, c)
    | _, _ => none
  | _ => none

/-- **the frame every vertex-producing definition of the scenes writes its coordinates in.**
The `M` / `D` / `T` suffixes of the instance's own names agree with this table, and the driver
checks that they do — but the table is what the printer believes, because the `Pt` names do not
agree with anything (`crownPt` is the pot's, `boreFootPt` the roof's). -/
def sceneFrames : List (Frame × List String) := [
  (.carriage,
    ["postTopM", "postBaseM", "railPtM", "boltLineM", "drumFootM", "hangerEyeM", "hangerHoleM",
     "envHangerHoleM", "legBraceM", "legFootM", "legShortM", "mastFootM", "mastTopM",
     "outrigEndM", "outrigRootM", "receiverBaseM", "receiverTopM", "standBarM", "tubeFootM",
     "tubeTopM"]),
  (.bolt,
    ["boltOriginPt", "drumAt", "pulleyAt", "edgeClipAt", "envEdgeClipAt", "dishVertexPt",
     "envDishVertexPt", "envRimPt", "towBightPt", "envTowBightPt", "rimPt",
     "rimAchievedPt", "envRimAchievedPt", "vertexAchievedPt", "envVertexAchievedPt"]),
  (.dish,
    ["coilPtD", "panelCornerD", "panelEdgeUD", "panelEdgeVD", "sagArcUD", "sagArcVD", "slotEndD",
     "rayStartT", "rayHitT", "rayLandT", "envRayStartT", "envRayHitT", "envRayLandT", "dishHitT",
     "dishDirT", "beamHitT", "beamAxis", "beamNormalT"]),
  (.pot,
    ["beltLoPt", "crownPt", "exchangerPt", "floorPt", "hearthPt", "hearthBandPt", "mouthPt",
     "potMeridPt", "potRingPt", "rotiCornerPt", "slotCentrePt"]),
  (.roof,
    ["boreFootPt", "boreTopPt", "deckCornerPt", "ductMouthPt", "ductRingPt", "groundCornerPt",
     "parapetCornerPt", "sunCentrePt", "sunDiscPt", "sunDir",
     "triAtBread", "triAtDeck", "triAtInlet", "triAtM3", "triAtStrip", "triBorePt", "triFocus",
     "triLoaf", "triM3AxisPt", "triRayOrigin", "triStripCentre", "triTurn"])]

def sceneFrameOf (d : String) : Option Frame :=
  sceneFrames.findSome? fun (f, ns) => if ns.contains d then some f else none

/-- the suffix convention, as a CROSS-CHECK of the table above and nothing more: `…M` is the
carriage's, `…D` and `…T` the dish's.  `…Pt` says nothing, so it is not a rule. -/
def suffixFrame (d : String) : Option Frame :=
  match d.toList.reverse with
  | 'M' :: _ => some .carriage
  | 'D' :: _ => some .dish
  | 'T' :: _ => some .dish
  | _ => none

/-- **the frame check**: a leaf of `defn`, drawn through the embedding `frame` (`none`: drawn as
it stands), is placed correctly exactly when the embedding's DOMAIN is the leaf's own frame — and
a leaf drawn with no embedding must already be in the world frame.  `Except` rather than `Bool`,
because the printer's refusal has to say what it refused. -/
def checkLeaf (defn : String) (frame : Option String) : Except String Unit :=
  match sceneFrameOf defn with
  | none => .error s!"the leaf {defn} declares no frame (add it to HashemiGrade.sceneFrames)"
  | some own =>
    match frame with
    | none =>
      if own == .roof then .ok ()
      else .error s!"{defn} is written in the {own.name} frame and is drawn with no embedding: \
        only a {Frame.roof.name}-frame point may be"
    | some f =>
      match frameMorphism f with
      | none => .error s!"the embedding {f} is not named <cod>Of<Dom>, so its frames are unknown"
      | some (dom, cod) =>
        if dom == own then .ok ()
        else .error s!"{defn} is written in the {own.name} frame and is placed by {f}, which \
          embeds {dom.name} in {cod.name}"

end HashemiGrade

import Std
namespace HashemiCccFloat
set_option maxRecDepth 4000
/-- `=` on ℝ, in floating point -/
def feq (a b : Float) : Bool := Float.abs (a - b) <= 1e-9 * max 1.0 (max (Float.abs a) (Float.abs b))

def check_AH_bounds  : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((1.833 : Float) < v2) && (v2 < (1.8331 : Float)))

#eval IO.println ("check_AH_bounds " ++ toString (check_AH_bounds))
#eval IO.println ("check_AH_bounds " ++ toString (check_AH_bounds))
#eval IO.println ("check_AH_bounds " ++ toString (check_AH_bounds))

def check_FC_bounds  : Bool :=
  let v7 := (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float)))))
  (((1.154 : Float) < v7) && (v7 < (1.1551 : Float)))

#eval IO.println ("check_FC_bounds " ++ toString (check_FC_bounds))
#eval IO.println ("check_FC_bounds " ++ toString (check_FC_bounds))
#eval IO.println ("check_FC_bounds " ++ toString (check_FC_bounds))

def check_FC_eq  : Bool :=
  let v4 := ((0.8 : Float) ^ 2)
  (feq (Float.sqrt ((((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - v4)))) ^ 2) + v4)) (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))

#eval IO.println ("check_FC_eq " ++ toString (check_FC_eq))
#eval IO.println ("check_FC_eq " ++ toString (check_FC_eq))
#eval IO.println ("check_FC_eq " ++ toString (check_FC_eq))

def check_FH_bounds  : Bool :=
  let v9 := (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  (((0.833 : Float) < v9) && (v9 < (0.8331 : Float)))

#eval IO.println ("check_FH_bounds " ++ toString (check_FH_bounds))
#eval IO.println ("check_FH_bounds " ++ toString (check_FH_bounds))
#eval IO.println ("check_FH_bounds " ++ toString (check_FH_bounds))

def check_FH_eq  : Bool :=
  (feq (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))) ((Float.sqrt (3.36 : Float)) - (1 : Float)))

#eval IO.println ("check_FH_eq " ++ toString (check_FH_eq))
#eval IO.println ("check_FH_eq " ++ toString (check_FH_eq))
#eval IO.println ("check_FH_eq " ++ toString (check_FH_eq))

def Fits (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  (feq b_rRail (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))))

#eval IO.println ("Fits " ++ toString (Fits 0.921475 0.862926 0.804377 0.745828 0.687280 0.628731 0.570182 0.511633 0.453084 0.394536 0.335987 0.277438))
#eval IO.println ("Fits " ++ toString (Fits 0.590283 0.531734 0.473185 0.414636 0.356088 0.297539 0.238990 1.780441 1.721892 1.663344 1.604795 1.546246))
#eval IO.println ("Fits " ++ toString (Fits 0.259091 0.200542 1.741993 1.683444 1.624896 1.566347 1.507798 1.449249 1.390700 1.332152 1.273603 1.215054))

def check_HD_bounds  : Bool :=
  let v7 := ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))
  (((0.166 : Float) < v7) && (v7 < (0.168 : Float)))

#eval IO.println ("check_HD_bounds " ++ toString (check_HD_bounds))
#eval IO.println ("check_HD_bounds " ++ toString (check_HD_bounds))
#eval IO.println ("check_HD_bounds " ++ toString (check_HD_bounds))

def check_HD_eq  : Bool :=
  (feq ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))) ((2 : Float) - (Float.sqrt (3.36 : Float))))

#eval IO.println ("check_HD_eq " ++ toString (check_HD_eq))
#eval IO.println ("check_HD_eq " ++ toString (check_HD_eq))
#eval IO.println ("check_HD_eq " ++ toString (check_HD_eq))

def HangerClearsPost (eyeOffset : Float) (dRod : Float) : Bool :=
  ((dRod / (2 : Float)) < eyeOffset)

#eval IO.println ("HangerClearsPost " ++ toString (HangerClearsPost 0.363019 0.304470))
#eval IO.println ("HangerClearsPost " ++ toString (HangerClearsPost 1.631827 1.573278))
#eval IO.println ("HangerClearsPost " ++ toString (HangerClearsPost 1.300635 1.242086))

def HoldsDish (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) : Bool :=
  ((W * rcm) <= (Tmax * rw))

#eval IO.println ("HoldsDish " ++ toString (HoldsDish 1.776867 1.718318 1.659769 1.601220))
#eval IO.println ("HoldsDish " ++ toString (HoldsDish 1.445675 1.387126 1.328577 1.270028))
#eval IO.println ("HoldsDish " ++ toString (HoldsDish 1.114483 1.055934 0.997385 0.938836))

def Leg_footLong (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (l_foot - l_footShort)

#eval IO.println ("Leg_footLong " ++ toString (Leg_footLong 1.590715 1.532166 1.473617 1.415068 1.356520).toBits)
#eval IO.println ("Leg_footLong " ++ toString (Leg_footLong 1.259523 1.200974 1.142425 1.083876 1.025328).toBits)
#eval IO.println ("Leg_footLong " ++ toString (Leg_footLong 0.928331 0.869782 0.811233 0.752684 0.694136).toBits)

def LostSun (tDead : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (eps : Float) : Bool :=
  let v8 := ((3.141592653589793 : Float) / (2 : Float))
  let v11 := (Float.sin t)
  let v13 := (v11 * (Float.cos az))
  let v15 := (v11 * (Float.sin az))
  let v16 := (Float.cos t)
  let v17 := (Float.cos elSun)
  let v19 := (v17 * (Float.cos azSun))
  let v21 := (v17 * (Float.sin azSun))
  let v22 := (Float.sin elSun)
  let v27 := (((v13 * v19) + (v15 * v21)) + (v16 * v22))
  let v42 := (Float.sqrt (((((v15 * v22) - (v16 * v21)) ^ 2) + (((v16 * v19) - (v13 * v22)) ^ 2)) + (((v13 * v21) - (v15 * v19)) ^ 2)))
  (((v8 - tDead) <= elSun) && (eps < (if (v27 <= (0 : Float)) then (v8 + (Float.atan ((-v27) / (max v42 (0.000000000001 : Float))))) else (Float.atan (v42 / v27)))))

#eval IO.println ("LostSun " ++ toString (LostSun 1.404563 1.346014 1.287465 1.228916 1.170368 1.111819))
#eval IO.println ("LostSun " ++ toString (LostSun 1.073371 1.014822 0.956273 0.897724 0.839176 0.780627))
#eval IO.println ("LostSun " ++ toString (LostSun 0.742179 0.683630 0.625081 0.566532 0.507984 0.449435))

def MastClears (ym : Float) (a : Float) (ze : Float) : Bool :=
  ((Float.sqrt ((a ^ 2) + (ze ^ 2))) < ym)

#eval IO.println ("MastClears " ++ toString (MastClears 1.218411 1.159862 1.101313))
#eval IO.println ("MastClears " ++ toString (MastClears 0.887219 0.828670 0.770121))
#eval IO.println ("MastClears " ++ toString (MastClears 0.556027 0.497478 0.438929))

def ReachesVertical (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  ((ym * a) <= (hp * ze))

#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 1.032259 0.973710 0.915161 0.856612))
#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 0.701067 0.642518 0.583969 0.525420))
#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 0.369875 0.311326 0.252777 1.794228))

def SlackHarmless (f : Float) (eps : Float) (delta : Float) (h : Float) : Bool :=
  (((f * (Float.tan eps)) + delta) <= h)

#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 0.846107 0.787558 0.729009 0.670460))
#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 0.514915 0.456366 0.397817 0.339268))
#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 1.783723 1.725174 1.666625 1.608076))

def SunReachable (tDead : Float) (elSun : Float) : Bool :=
  ((((3.141592653589793 : Float) / (2 : Float)) - tDead) <= elSun)

#eval IO.println ("SunReachable " ++ toString (SunReachable 0.659955 0.601406))
#eval IO.println ("SunReachable " ++ toString (SunReachable 0.328763 0.270214))
#eval IO.println ("SunReachable " ++ toString (SunReachable 1.597571 1.539022))

def TrackerBudget (f : Float) (eps : Float) (h : Float) : Bool :=
  ((f * (Float.tan eps)) <= h)

#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 0.473803 0.415254 0.356705))
#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 1.742611 1.684062 1.625513))
#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 1.411419 1.352870 1.294321))

def azFull  : Float :=
  (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))

#eval IO.println ("azFull " ++ toString (azFull).toBits)
#eval IO.println ("azFull " ++ toString (azFull).toBits)
#eval IO.println ("azFull " ++ toString (azFull).toBits)

def check_azFull_pos  : Bool :=
  ((0 : Float) < (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)))

#eval IO.println ("check_azFull_pos " ++ toString (check_azFull_pos))
#eval IO.println ("check_azFull_pos " ++ toString (check_azFull_pos))
#eval IO.println ("check_azFull_pos " ++ toString (check_azFull_pos))

def azRate (omegam : Float) (rw : Float) (R : Float) : Float :=
  ((omegam * rw) / R)

#eval IO.println ("azRate " ++ toString (azRate 1.515347 1.456798 1.398249).toBits)
#eval IO.println ("azRate " ++ toString (azRate 1.184155 1.125606 1.067057).toBits)
#eval IO.println ("azRate " ++ toString (azRate 0.852963 0.794414 0.735865).toBits)

def check_azRate_pos (omegam : Float) (rw : Float) (R : Float) : Bool :=
  (!((0 : Float) < omegam) || (!((0 : Float) < rw) || (!((0 : Float) < R) || ((0 : Float) < ((omegam * rw) / R)))))

#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 1.329195 1.270646 1.212097))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 0.998003 0.939454 0.880905))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 0.666811 0.608262 0.549713))

def check_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 1.143043))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 0.811851))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 0.480659))

def bisectStep (ym : Float) (hp : Float) (a : Float) (ze : Float) (L : Float) (lohi_1 : Float) (lohi_2 : Float) : Array Float :=
  let v9 := ((lohi_1 + lohi_2) / (2 : Float))
  let v11 := (-a)
  let v12 := (Float.cos v9)
  let v14 := (-ze)
  let v15 := (Float.sin v9)
  let v28 := (L < (Float.sqrt (((((v11 * v12) + (v14 * v15)) - (-ym)) ^ 2) + (((((-v11) * v15) + (v14 * v12)) - hp) ^ 2))))
  #[(if v28 then v9 else lohi_1), (if v28 then lohi_2 else v9)]

#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.956891 0.898342 0.839793 0.781244 0.722696 0.664147 0.605598).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.625699 0.567150 0.508601 0.450052 0.391504 0.332955 0.274406).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.294507 0.235958 1.777409 1.718860 1.660312 1.601763 1.543214).map Float.toBits))

def boltStress (W : Float) (reach : Float) (d : Float) : Float :=
  (((W / (2 : Float)) * reach) / (((3.141592653589793 : Float) * (d ^ 3)) / (32 : Float)))

#eval IO.println ("boltStress " ++ toString (boltStress 0.770739 0.712190 0.653641).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 0.439547 0.380998 0.322449).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 1.708355 1.649806 1.591257).toBits)

def braceHeight (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (Float.sqrt ((l_brace ^ 2) - ((l_foot - l_footShort) ^ 2)))

#eval IO.println ("braceHeight " ++ toString (braceHeight 0.584587 0.526038 0.467489 0.408940 0.350392).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 0.253395 1.794846 1.736297 1.677748 1.619200).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 1.522203 1.463654 1.405105 1.346556 1.288008).toBits)

def check_braceHeight_hashemi  : Bool :=
  let v10 := (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))
  (((0.85 : Float) < v10) && (v10 < (0.851 : Float)))

#eval IO.println ("check_braceHeight_hashemi " ++ toString (check_braceHeight_hashemi))
#eval IO.println ("check_braceHeight_hashemi " ++ toString (check_braceHeight_hashemi))
#eval IO.println ("check_braceHeight_hashemi " ++ toString (check_braceHeight_hashemi))

def check_brace_cuts_moment  : Bool :=
  ((((1.30 : Float) - (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))) / (1.30 : Float)) < (0.35 : Float))

#eval IO.println ("check_brace_cuts_moment " ++ toString (check_brace_cuts_moment))
#eval IO.println ("check_brace_cuts_moment " ++ toString (check_brace_cuts_moment))
#eval IO.println ("check_brace_cuts_moment " ++ toString (check_brace_cuts_moment))

def check_brace_stiffens  : Bool :=
  (((((1.30 : Float) - (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))) / (1.30 : Float)) ^ 3) < ((1 : Float) / (24 : Float)))

#eval IO.println ("check_brace_stiffens " ++ toString (check_brace_stiffens))
#eval IO.println ("check_brace_stiffens " ++ toString (check_brace_stiffens))
#eval IO.println ("check_brace_stiffens " ++ toString (check_brace_stiffens))

def cableArea  : Float :=
  (0.0000015 : Float)

#eval IO.println ("cableArea " ++ toString (cableArea).toBits)
#eval IO.println ("cableArea " ++ toString (cableArea).toBits)
#eval IO.println ("cableArea " ++ toString (cableArea).toBits)

def cableDrop (L : Float) (I : Float) : Float :=
  ((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float))

#eval IO.println ("cableDrop " ++ toString (cableDrop 1.253827 1.195278).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 0.922635 0.864086).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 0.591443 0.532894).toBits)

def check_cable_drop_small (L : Float) (I : Float) : Bool :=
  (!(L <= (4 : Float)) || (!((0 : Float) <= I) || (!(I <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float)) < (0.1 : Float)))))

#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.067675 1.009126))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.736483 0.677934))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.405291 0.346742))

def captureS (rc : Float) (rad : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((rc - rad) / (0.005 : Float)))))

#eval IO.println ("captureS " ++ toString (captureS 0.881523 0.822974).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.550331 0.491782).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.219139 1.760590).toBits)

def check_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.695371 0.636822 0.578273))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.364179 0.305630 0.247081))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 1.632987 1.574438 1.515889))

def clearance (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (holeDown : Float) (reach : Float) : Float :=
  ((l_upright - holeDown) - reach)

#eval IO.println ("clearance " ++ toString (clearance 0.509219 0.450670 0.392121 0.333572 0.275024 0.216475 1.757926).toBits)
#eval IO.println ("clearance " ++ toString (clearance 1.778027 1.719478 1.660929 1.602380 1.543832 1.485283 1.426734).toBits)
#eval IO.println ("clearance " ++ toString (clearance 1.446835 1.388286 1.329737 1.271188 1.212640 1.154091 1.095542).toBits)

def check_clearance_hashemi (holeDown : Float) : Bool :=
  let v16 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v16) && (v16 < ((0.146 : Float) - holeDown)))

#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.323067))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.591875))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.260683))

def coilCapture (rs : Float) (rc : Float) (d : Float) : Float :=
  let v9 := (rs ^ 2)
  let v10 := (d ^ 2)
  let v12 := (rc ^ 2)
  let v15 := ((2 : Float) * d)
  let v30 := (d + rs)
  (if ((rs + rc) <= d) then (0 : Float) else (if (d <= (rc - rs)) then (1 : Float) else ((((v9 * (Float.acos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Float.acos (((v10 + v12) - v9) / (v15 * rc))))) - ((Float.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : Float))) / ((3.141592653589793 : Float) * v9))))

#eval IO.println ("coilCapture " ++ toString (coilCapture 1.736915 1.678366 1.619817).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.405723 1.347174 1.288625).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.074531 1.015982 0.957433).toBits)

def conicHitS (c : Float) (k : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Float :=
  let v9 := ((1 : Float) + k)
  let v27 := ((((2 : Float) * c) * (((O_0 * d_0) + (O_1 * d_1)) + ((v9 * O_2) * d_2))) - ((2 : Float) * d_2))
  let v36 := ((c * (((O_0 ^ 2) + (O_1 ^ 2)) + (v9 * (O_2 ^ 2)))) - ((2 : Float) * O_2))
  (((2 : Float) * v36) / ((-v27) - (Float.sqrt (max ((v27 ^ 2) - (((4 : Float) * (c * (((d_0 ^ 2) + (d_1 ^ 2)) + (v9 * (d_2 ^ 2))))) * v36)) (0 : Float)))))

#eval IO.println ("conicHitS " ++ toString (conicHitS 1.550763 1.492214 1.433665 1.375116 1.316568 1.258019 1.199470 1.140921).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 1.219571 1.161022 1.102473 1.043924 0.985376 0.926827 0.868278 0.809729).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 0.888379 0.829830 0.771281 0.712732 0.654184 0.595635 0.537086 0.478537).toBits)

def conicSlope (c : Float) (k : Float) (r : Float) : Float :=
  ((c * r) / (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : Float))))

#eval IO.println ("conicSlope " ++ toString (conicSlope 1.364611 1.306062 1.247513).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.033419 0.974870 0.916321).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 0.702227 0.643678 0.585129).toBits)

def conicZ (c : Float) (k : Float) (r : Float) : Float :=
  let v3 := (r ^ 2)
  ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * v3)) (0 : Float)))))

#eval IO.println ("conicZ " ++ toString (conicZ 1.178459 1.119910 1.061361).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 0.847267 0.788718 0.730169).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 0.516075 0.457526 0.398977).toBits)

def check_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.992307 0.933758))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.661115 0.602566))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.329923 0.271374))

def check_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v4 := (c ^ 2)
  let v5 := (r ^ 2)
  let v18 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v4 * v5) <= (1 : Float)) || (feq ((c * v5) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v4) * v5)) (0 : Float))))) (v18 - (Float.sqrt ((v18 ^ 2) - v5))))))

#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.806155 0.747606))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.474963 0.416414))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.743771 1.685222))

def constraints (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := ((0 : Float) * (0 : Float))
  let v15 := (b_zBearing * (0 : Float))
  let v17 := (b_zBearing * (1 : Float))
  let v19 := ((0 : Float) * (1 : Float))
  let v28 := (c_chord / (2 : Float))
  let v30 := (b_zRail * (0 : Float))
  let v34 := (c_apexH * (0 : Float))
  let v37 := (-v28)
  #[(1 : Float), (0 : Float), (0 : Float), (v14 - v15), (v17 - v14), (v14 - v19), (0 : Float), (1 : Float), (0 : Float), (v14 - v17), (v15 - v14), (v19 - v14), (0 : Float), (0 : Float), (1 : Float), (v19 - v15), (v15 - v19), (v14 - v14), (0 : Float), (0 : Float), (1 : Float), ((v28 * (1 : Float)) - v30), (v30 - (c_apexH * (1 : Float))), (v34 - (v28 * (0 : Float))), (0 : Float), (0 : Float), (1 : Float), ((v37 * (1 : Float)) - v30), (v30 - (c_apexH * (1 : Float))), (v34 - (v37 * (0 : Float)))]

#eval IO.println ("constraints " ++ toString ((constraints 0.620003 0.561454 0.502905 0.444356 0.385808 0.327259 0.268710 0.210161 1.751612 1.693064 1.634515 1.575966).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.288811 0.230262 1.771713 1.713164 1.654616 1.596067 1.537518 1.478969 1.420420 1.361872 1.303323 1.244774).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 1.557619 1.499070 1.440521 1.381972 1.323424 1.264875 1.206326 1.147777 1.089228 1.030680 0.972131 0.913582).map Float.toBits))

def constraintsGrooved (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := ((0 : Float) * (0 : Float))
  let v15 := (b_zBearing * (0 : Float))
  let v17 := (b_zBearing * (1 : Float))
  let v19 := ((0 : Float) * (1 : Float))
  let v28 := (c_chord / (2 : Float))
  let v30 := (b_zRail * (0 : Float))
  let v34 := (c_apexH * (0 : Float))
  let v35 := (v28 * (0 : Float))
  let v37 := (-v28)
  let v40 := (v37 * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v14 - v15), (v17 - v14), (v14 - v19), (0 : Float), (1 : Float), (0 : Float), (v14 - v17), (v15 - v14), (v19 - v14), (0 : Float), (0 : Float), (1 : Float), (v19 - v15), (v15 - v19), (v14 - v14), (0 : Float), (0 : Float), (1 : Float), ((v28 * (1 : Float)) - v30), (v30 - (c_apexH * (1 : Float))), (v34 - v35), (0 : Float), (0 : Float), (1 : Float), ((v37 * (1 : Float)) - v30), (v30 - (c_apexH * (1 : Float))), (v34 - v40), c_apexH, v28, (0 : Float), (v35 - (b_zRail * v28)), ((b_zRail * c_apexH) - v34), ((c_apexH * v28) - (v28 * c_apexH)), c_apexH, v37, (0 : Float), (v40 - (b_zRail * v37)), ((b_zRail * c_apexH) - v34), ((c_apexH * v37) - (v37 * c_apexH))]

#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.433851 0.375302 0.316753 0.258204 1.799656 1.741107 1.682558 1.624009 1.565460 1.506912 1.448363 1.389814).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.702659 1.644110 1.585561 1.527012 1.468464 1.409915 1.351366 1.292817 1.234268 1.175720 1.117171 1.058622).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.371467 1.312918 1.254369 1.195820 1.137272 1.078723 1.020174 0.961625 0.903076 0.844528 0.785979 0.727430).map Float.toBits))

def check_constraints_reciprocal_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v14 := ((0 : Float) * (0 : Float))
  let v15 := (b_zBearing * (0 : Float))
  let v17 := (b_zBearing * (1 : Float))
  let v19 := ((0 : Float) * (1 : Float))
  let v28 := (c_chord / (2 : Float))
  let v30 := (b_zRail * (0 : Float))
  let v34 := (c_apexH * (0 : Float))
  let v37 := (-v28)
  let v70 := ((0 : Float) * (v30 - (c_apexH * (1 : Float))))
  ((feq (((((((0 : Float) * (v14 - v15)) + ((0 : Float) * (v17 - v14))) + ((1 : Float) * (v14 - v19))) + v19) + v14) + v14) (0 : Float)) && ((feq (((((((0 : Float) * (v14 - v17)) + ((0 : Float) * (v15 - v14))) + ((1 : Float) * (v19 - v14))) + v14) + v19) + v14) (0 : Float)) && ((feq (((((((0 : Float) * (v19 - v15)) + ((0 : Float) * (v15 - v19))) + ((1 : Float) * (v14 - v14))) + v14) + v14) + v19) (0 : Float)) && ((feq (((((((0 : Float) * ((v28 * (1 : Float)) - v30)) + v70) + ((1 : Float) * (v34 - (v28 * (0 : Float))))) + v14) + v14) + v19) (0 : Float)) && (feq (((((((0 : Float) * ((v37 * (1 : Float)) - v30)) + v70) + ((1 : Float) * (v34 - (v37 * (0 : Float))))) + v14) + v14) + v19) (0 : Float))))))

#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.247699 1.789150 1.730601 1.672052 1.613504 1.554955 1.496406 1.437857 1.379308 1.320760 1.262211 1.203662))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.516507 1.457958 1.399409 1.340860 1.282312 1.223763 1.165214 1.106665 1.048116 0.989568 0.931019 0.872470))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.185315 1.126766 1.068217 1.009668 0.951120 0.892571 0.834022 0.775473 0.716924 0.658376 0.599827 0.541278))

def cosTubeCut  : Float :=
  let v2 := (Float.sqrt (3.2 : Float))
  (((3.36 : Float) - v2) / ((2 : Float) * (Float.sqrt ((4.36 : Float) - ((2 : Float) * v2)))))

#eval IO.println ("cosTubeCut " ++ toString (cosTubeCut).toBits)
#eval IO.println ("cosTubeCut " ++ toString (cosTubeCut).toBits)
#eval IO.println ("cosTubeCut " ++ toString (cosTubeCut).toBits)

def check_cosTubeCut_bounds  : Bool :=
  let v3 := (Float.sqrt (3.2 : Float))
  let v11 := (((3.36 : Float) - v3) / ((2 : Float) * (Float.sqrt ((4.36 : Float) - ((2 : Float) * v3)))))
  (((0.888 : Float) < v11) && (v11 < (0.889 : Float)))

#eval IO.println ("check_cosTubeCut_bounds " ++ toString (check_cosTubeCut_bounds))
#eval IO.println ("check_cosTubeCut_bounds " ++ toString (check_cosTubeCut_bounds))
#eval IO.println ("check_cosTubeCut_bounds " ++ toString (check_cosTubeCut_bounds))

def cross3 (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  #[((u_1 * v_2) - (u_2 * v_1)), ((u_2 * v_0) - (u_0 * v_2)), ((u_0 * v_1) - (u_1 * v_0))]

#eval IO.println ("cross3 " ++ toString ((cross3 1.289243 1.230694 1.172145 1.113596 1.055048 0.996499).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 0.958051 0.899502 0.840953 0.782404 0.723856 0.665307).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 0.626859 0.568310 0.509761 0.451212 0.392664 0.334115).map Float.toBits))

def deadPoint (ym : Float) (hp : Float) (a : Float) (ze : Float) : Float :=
  let v4 := (ym * a)
  let v5 := (hp * ze)
  (if (v4 <= v5) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v4 - v5))))

#eval IO.println ("deadPoint " ++ toString (deadPoint 1.103091 1.044542 0.985993 0.927444).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 0.771899 0.713350 0.654801 0.596252).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 0.440707 0.382158 0.323609 0.265060).toBits)

def check_deadTan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v14 := ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5)))
  (((1.859 : Float) < v14) && (v14 < (1.86 : Float)))

#eval IO.println ("check_deadTan_at_ym " ++ toString (check_deadTan_at_ym))
#eval IO.println ("check_deadTan_at_ym " ++ toString (check_deadTan_at_ym))
#eval IO.println ("check_deadTan_at_ym " ++ toString (check_deadTan_at_ym))

def check_deadTan_hashemi  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v14 := ((((1.2 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.2 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5)))
  (((1.878 : Float) < v14) && (v14 < (1.88 : Float)))

#eval IO.println ("check_deadTan_hashemi " ++ toString (check_deadTan_hashemi))
#eval IO.println ("check_deadTan_hashemi " ++ toString (check_deadTan_hashemi))
#eval IO.println ("check_deadTan_hashemi " ++ toString (check_deadTan_hashemi))

def dishAxes (az : Float) (t : Float) : Array Float :=
  let v2 := (Float.sin t)
  let v3 := (Float.cos az)
  let v4 := (v2 * v3)
  let v5 := (Float.sin az)
  let v6 := (v2 * v5)
  let v7 := (Float.cos t)
  let v8 := (v7 * v3)
  let v9 := (v7 * v5)
  let v10 := (-v2)
  #[((v9 * v7) - (v10 * v6)), ((v10 * v4) - (v8 * v7)), ((v8 * v6) - (v9 * v4)), v8, v9, v10, v4, v6, v7]

#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.544635 0.486086).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.213443 1.754894).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.482251 1.423702).map Float.toBits))

def check_dishAxes_rot (az : Float) (t : Float) (delta : Float) : Bool :=
  let v3 := (Float.sin t)
  let v4 := (az + delta)
  let v5 := (Float.cos v4)
  let v6 := (v3 * v5)
  let v7 := (Float.sin v4)
  let v8 := (v3 * v7)
  let v9 := (Float.cos t)
  let v10 := (v9 * v5)
  let v11 := (v9 * v7)
  let v12 := (-v3)
  let v22 := (Float.cos delta)
  let v23 := (Float.cos az)
  let v24 := (v3 * v23)
  let v25 := (Float.sin az)
  let v26 := (v3 * v25)
  let v27 := (v9 * v23)
  let v28 := (v9 * v25)
  let v31 := ((v28 * v9) - (v12 * v26))
  let v34 := ((v12 * v24) - (v27 * v9))
  let v39 := (Float.sin delta)
  (((feq ((v11 * v9) - (v12 * v8)) ((v22 * v31) - (v39 * v34))) && ((feq ((v12 * v6) - (v10 * v9)) ((v39 * v31) + (v22 * v34))) && (feq ((v10 * v8) - (v11 * v6)) ((v27 * v26) - (v28 * v24))))) && (((feq v10 ((v22 * v27) - (v39 * v28))) && ((feq v11 ((v39 * v27) + (v22 * v28))) && (feq v12 v12))) && ((feq v6 ((v22 * v24) - (v39 * v26))) && ((feq v8 ((v39 * v24) + (v22 * v26))) && (feq v9 v9)))))

#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.358483 0.299934 0.241385))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.627291 1.568742 1.510193))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.296099 1.237550 1.179001))

def dishF  : Float :=
  (1 : Float)

#eval IO.println ("dishF " ++ toString (dishF).toBits)
#eval IO.println ("dishF " ++ toString (dishF).toBits)
#eval IO.println ("dishF " ++ toString (dishF).toBits)

def dishHalf  : Float :=
  (0.8 : Float)

#eval IO.println ("dishHalf " ++ toString (dishHalf).toBits)
#eval IO.println ("dishHalf " ++ toString (dishHalf).toBits)
#eval IO.println ("dishHalf " ++ toString (dishHalf).toBits)

def dishPower (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (rho : Float) (hsun : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (u1 : Float) (u2 : Float) (u3 : Float) (u4 : Float) (u5 : Float) (u6 : Float) (e1 : Float) (e2 : Float) (s1 : Float) (s2 : Float) : Array Float :=
  let v24 := (Float.sin t)
  let v25 := (Float.cos az)
  let v26 := (v24 * v25)
  let v27 := (Float.sin az)
  let v28 := (v24 * v27)
  let v29 := (Float.cos t)
  let v30 := (v29 * v25)
  let v31 := (v29 * v27)
  let v32 := (-v24)
  let v42 := (Float.cos elSun)
  let v44 := (v42 * (Float.cos azSun))
  let v46 := (v42 * (Float.sin azSun))
  let v47 := (Float.sin elSun)
  let v64 := ((2 : Float) * a)
  let v65 := (v64 / w)
  let v67 := (w / (2 : Float))
  let v68 := ((-a) + v67)
  let v72 := (v68 + (w * (Float.floor (u1 * v65))))
  let v76 := (v68 + (w * (Float.floor (u2 * v65))))
  let v78 := ((1 : Float) / (2 : Float))
  let v80 := ((u3 - v78) * w)
  let v82 := ((u4 - v78) * w)
  let v83 := (-(((((v31 * v29) - (v32 * v28)) * v44) + (((v32 * v26) - (v30 * v29)) * v46)) + (((v30 * v28) - (v31 * v26)) * v47)))
  let v84 := (-(((v30 * v44) + (v31 * v46)) + (v32 * v47)))
  let v85 := (-(((v26 * v44) + (v28 * v46)) + (v29 * v47)))
  let v90 := ((Float.abs v85) < ((9 : Float) / (10 : Float)))
  let v92 := (if v90 then (0 : Float) else (1 : Float))
  let v93 := (if v90 then (1 : Float) else (0 : Float))
  let v96 := ((v84 * v93) - (v85 * (0 : Float)))
  let v99 := ((v85 * v92) - (v83 * v93))
  let v102 := ((v83 * (0 : Float)) - (v84 * v92))
  let v110 := (Float.sqrt (max (((v96 ^ 2) + (v99 ^ 2)) + (v102 ^ 2)) (0.000000000000000001 : Float)))
  let v111 := (v96 / v110)
  let v112 := (v99 / v110)
  let v113 := (v102 / v110)
  let v124 := (hsun * (Float.sqrt u5))
  let v127 := (((2 : Float) * (3.141592653589793 : Float)) * u6)
  let v128 := (Float.cos v124)
  let v130 := (Float.sin v124)
  let v131 := (Float.cos v127)
  let v133 := (Float.sin v127)
  let v137 := ((v128 * v83) + (v130 * ((v131 * v111) + (v133 * ((v84 * v113) - (v85 * v112))))))
  let v143 := ((v128 * v84) + (v130 * ((v131 * v112) + (v133 * ((v85 * v111) - (v83 * v113))))))
  let v149 := ((v128 * v85) + (v130 * ((v131 * v113) + (v133 * ((v83 * v112) - (v84 * v111))))))
  let v160 := (((Float.abs v72) <= a) && (((Float.abs v76) <= a) && (((Float.abs v80) <= v67) && ((Float.abs v82) <= v67))))
  let v161 := (v72 + v80)
  let v162 := (v76 + v82)
  let v163 := ((2 : Float) * f)
  let v164 := ((1 : Float) / R)
  let v169 := (Float.sqrt (max ((v72 ^ 2) + (v76 ^ 2)) (0.000000000000000001 : Float)))
  let v170 := (v169 ^ 2)
  let v176 := ((1 : Float) - ((((1 : Float) + k) * (v164 ^ 2)) * v170))
  let v184 := ((v164 * v169) / (Float.sqrt (max v176 (0.000000000000000001 : Float))))
  let v187 := (Float.sqrt ((1 : Float) + (v184 ^ 2)))
  let v188 := (-v184)
  let v191 := (((v188 * v72) / v169) / v187)
  let v194 := (((v188 * v76) / v169) / v187)
  let v195 := ((1 : Float) / v187)
  let v197 := (v191 + (sigmaslope * e1))
  let v199 := (v194 + (sigmaslope * e2))
  let v205 := (Float.sqrt (((v197 ^ 2) + (v199 ^ 2)) + (v195 ^ 2)))
  let v206 := (v197 / v205)
  let v207 := (v199 / v205)
  let v208 := (v195 / v205)
  let v222 := (((((v72 - v161) * v191) + ((v76 - v162) * v194)) + ((((v164 * v170) / ((1 : Float) + (Float.sqrt (max v176 (0 : Float))))) - v163) * v195)) / (((v137 * v191) + (v143 * v194)) + (v149 * v195)))
  let v234 := ((2 : Float) * (((v137 * v206) + (v143 * v207)) + (v149 * v208)))
  let v240 := (v149 - (v234 * v208))
  let v242 := ((v137 - (v234 * v206)) + (sigmaspec * s1))
  let v244 := ((v143 - (v234 * v207)) + (sigmaspec * s2))
  let v250 := (Float.sqrt (((v242 ^ 2) + (v244 ^ 2)) + (v240 ^ 2)))
  let v253 := (v240 / v250)
  let v255 := ((f - (v163 + (v222 * v149))) / v253)
  let v263 := (Float.sqrt ((((v161 + (v222 * v137)) + (v255 * (v242 / v250))) ^ 2) + (((v162 + (v222 * v143)) + (v255 * (v244 / v250))) ^ 2)))
  let v265 := ((0 : Float) < v253)
  let v266 := ((v263 <= rc) && v265)
  #[(if (v160 && v266) then (1 : Float) else (0 : Float)), (((v64 ^ 2) * rho) * (if (v160 && v266) then (1 : Float) else (0 : Float))), (if (!v160) then (0 : Float) else (if v266 then (2 : Float) else (1 : Float))), v263, (1.0 / (1.0 + Float.exp (-((rc - v263) / (0.005 : Float)))))]

#eval IO.println ("dishPower " ++ toString ((dishPower 1.400027 1.341478 1.282929 1.224380 1.165832 1.107283 1.048734 0.990185 0.931636 0.873088 0.814539 0.755990 0.697441 0.638892 0.580344 0.521795 0.463246 0.404697 0.346148 0.287600 0.229051 1.770502 1.711953 1.653404).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.068835 1.010286 0.951737 0.893188 0.834640 0.776091 0.717542 0.658993 0.600444 0.541896 0.483347 0.424798 0.366249 0.307700 0.249152 1.790603 1.732054 1.673505 1.614956 1.556408 1.497859 1.439310 1.380761 1.322212).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 0.737643 0.679094 0.620545 0.561996 0.503448 0.444899 0.386350 0.327801 0.269252 0.210704 1.752155 1.693606 1.635057 1.576508 1.517960 1.459411 1.400862 1.342313 1.283764 1.225216 1.166667 1.108118 1.049569 0.991020).map Float.toBits))

def check_dishPower_captured (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (rho : Float) (hsun : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (u1 : Float) (u2 : Float) (u3 : Float) (u4 : Float) (u5 : Float) (u6 : Float) (e1 : Float) (e2 : Float) (s1 : Float) (s2 : Float) : Bool :=
  let v24 := (Float.sin t)
  let v25 := (Float.cos az)
  let v26 := (v24 * v25)
  let v27 := (Float.sin az)
  let v28 := (v24 * v27)
  let v29 := (Float.cos t)
  let v30 := (v29 * v25)
  let v31 := (v29 * v27)
  let v32 := (-v24)
  let v42 := (Float.cos elSun)
  let v44 := (v42 * (Float.cos azSun))
  let v46 := (v42 * (Float.sin azSun))
  let v47 := (Float.sin elSun)
  let v64 := ((2 : Float) * a)
  let v65 := (v64 / w)
  let v67 := (w / (2 : Float))
  let v68 := ((-a) + v67)
  let v72 := (v68 + (w * (Float.floor (u1 * v65))))
  let v76 := (v68 + (w * (Float.floor (u2 * v65))))
  let v78 := ((1 : Float) / (2 : Float))
  let v80 := ((u3 - v78) * w)
  let v82 := ((u4 - v78) * w)
  let v83 := (-(((((v31 * v29) - (v32 * v28)) * v44) + (((v32 * v26) - (v30 * v29)) * v46)) + (((v30 * v28) - (v31 * v26)) * v47)))
  let v84 := (-(((v30 * v44) + (v31 * v46)) + (v32 * v47)))
  let v85 := (-(((v26 * v44) + (v28 * v46)) + (v29 * v47)))
  let v90 := ((Float.abs v85) < ((9 : Float) / (10 : Float)))
  let v92 := (if v90 then (0 : Float) else (1 : Float))
  let v93 := (if v90 then (1 : Float) else (0 : Float))
  let v96 := ((v84 * v93) - (v85 * (0 : Float)))
  let v99 := ((v85 * v92) - (v83 * v93))
  let v102 := ((v83 * (0 : Float)) - (v84 * v92))
  let v110 := (Float.sqrt (max (((v96 ^ 2) + (v99 ^ 2)) + (v102 ^ 2)) (0.000000000000000001 : Float)))
  let v111 := (v96 / v110)
  let v112 := (v99 / v110)
  let v113 := (v102 / v110)
  let v124 := (hsun * (Float.sqrt u5))
  let v127 := (((2 : Float) * (3.141592653589793 : Float)) * u6)
  let v128 := (Float.cos v124)
  let v130 := (Float.sin v124)
  let v131 := (Float.cos v127)
  let v133 := (Float.sin v127)
  let v137 := ((v128 * v83) + (v130 * ((v131 * v111) + (v133 * ((v84 * v113) - (v85 * v112))))))
  let v143 := ((v128 * v84) + (v130 * ((v131 * v112) + (v133 * ((v85 * v111) - (v83 * v113))))))
  let v149 := ((v128 * v85) + (v130 * ((v131 * v113) + (v133 * ((v83 * v112) - (v84 * v111))))))
  let v160 := (((Float.abs v72) <= a) && (((Float.abs v76) <= a) && (((Float.abs v80) <= v67) && ((Float.abs v82) <= v67))))
  let v161 := (v72 + v80)
  let v162 := (v76 + v82)
  let v163 := ((2 : Float) * f)
  let v164 := ((1 : Float) / R)
  let v169 := (Float.sqrt (max ((v72 ^ 2) + (v76 ^ 2)) (0.000000000000000001 : Float)))
  let v170 := (v169 ^ 2)
  let v176 := ((1 : Float) - ((((1 : Float) + k) * (v164 ^ 2)) * v170))
  let v184 := ((v164 * v169) / (Float.sqrt (max v176 (0.000000000000000001 : Float))))
  let v187 := (Float.sqrt ((1 : Float) + (v184 ^ 2)))
  let v188 := (-v184)
  let v191 := (((v188 * v72) / v169) / v187)
  let v194 := (((v188 * v76) / v169) / v187)
  let v195 := ((1 : Float) / v187)
  let v197 := (v191 + (sigmaslope * e1))
  let v199 := (v194 + (sigmaslope * e2))
  let v205 := (Float.sqrt (((v197 ^ 2) + (v199 ^ 2)) + (v195 ^ 2)))
  let v206 := (v197 / v205)
  let v207 := (v199 / v205)
  let v208 := (v195 / v205)
  let v222 := (((((v72 - v161) * v191) + ((v76 - v162) * v194)) + ((((v164 * v170) / ((1 : Float) + (Float.sqrt (max v176 (0 : Float))))) - v163) * v195)) / (((v137 * v191) + (v143 * v194)) + (v149 * v195)))
  let v234 := ((2 : Float) * (((v137 * v206) + (v143 * v207)) + (v149 * v208)))
  let v240 := (v149 - (v234 * v208))
  let v242 := ((v137 - (v234 * v206)) + (sigmaspec * s1))
  let v244 := ((v143 - (v234 * v207)) + (sigmaspec * s2))
  let v250 := (Float.sqrt (((v242 ^ 2) + (v244 ^ 2)) + (v240 ^ 2)))
  let v253 := (v240 / v250)
  let v255 := ((f - (v163 + (v222 * v149))) / v253)
  let v263 := (Float.sqrt ((((v161 + (v222 * v137)) + (v255 * (v242 / v250))) ^ 2) + (((v162 + (v222 * v143)) + (v255 * (v244 / v250))) ^ 2)))
  let v265 := ((0 : Float) < v253)
  let v266 := ((v263 <= rc) && v265)
  let v268 := (if (v160 && v266) then (1 : Float) else (0 : Float))
  ((feq v268 (0 : Float)) || (feq v268 (1 : Float)))

#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.213875 1.155326 1.096777 1.038228 0.979680 0.921131 0.862582 0.804033 0.745484 0.686936 0.628387 0.569838 0.511289 0.452740 0.394192 0.335643 0.277094 0.218545 1.759996 1.701448 1.642899 1.584350 1.525801 1.467252))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.882683 0.824134 0.765585 0.707036 0.648488 0.589939 0.531390 0.472841 0.414292 0.355744 0.297195 0.238646 1.780097 1.721548 1.663000 1.604451 1.545902 1.487353 1.428804 1.370256 1.311707 1.253158 1.194609 1.136060))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.551491 0.492942 0.434393 0.375844 0.317296 0.258747 0.200198 1.741649 1.683100 1.624552 1.566003 1.507454 1.448905 1.390356 1.331808 1.273259 1.214710 1.156161 1.097612 1.039064 0.980515 0.921966 0.863417 0.804868))

def check_dishPower_le (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (rho : Float) (hsun : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (u1 : Float) (u2 : Float) (u3 : Float) (u4 : Float) (u5 : Float) (u6 : Float) (e1 : Float) (e2 : Float) (s1 : Float) (s2 : Float) : Bool :=
  let v26 := (Float.sin t)
  let v27 := (Float.cos az)
  let v28 := (v26 * v27)
  let v29 := (Float.sin az)
  let v30 := (v26 * v29)
  let v31 := (Float.cos t)
  let v32 := (v31 * v27)
  let v33 := (v31 * v29)
  let v34 := (-v26)
  let v44 := (Float.cos elSun)
  let v46 := (v44 * (Float.cos azSun))
  let v48 := (v44 * (Float.sin azSun))
  let v49 := (Float.sin elSun)
  let v66 := ((2 : Float) * a)
  let v67 := (v66 / w)
  let v69 := (w / (2 : Float))
  let v70 := ((-a) + v69)
  let v74 := (v70 + (w * (Float.floor (u1 * v67))))
  let v78 := (v70 + (w * (Float.floor (u2 * v67))))
  let v80 := ((1 : Float) / (2 : Float))
  let v82 := ((u3 - v80) * w)
  let v84 := ((u4 - v80) * w)
  let v85 := (-(((((v33 * v31) - (v34 * v30)) * v46) + (((v34 * v28) - (v32 * v31)) * v48)) + (((v32 * v30) - (v33 * v28)) * v49)))
  let v86 := (-(((v32 * v46) + (v33 * v48)) + (v34 * v49)))
  let v87 := (-(((v28 * v46) + (v30 * v48)) + (v31 * v49)))
  let v92 := ((Float.abs v87) < ((9 : Float) / (10 : Float)))
  let v93 := (if v92 then (0 : Float) else (1 : Float))
  let v94 := (if v92 then (1 : Float) else (0 : Float))
  let v97 := ((v86 * v94) - (v87 * (0 : Float)))
  let v100 := ((v87 * v93) - (v85 * v94))
  let v103 := ((v85 * (0 : Float)) - (v86 * v93))
  let v111 := (Float.sqrt (max (((v97 ^ 2) + (v100 ^ 2)) + (v103 ^ 2)) (0.000000000000000001 : Float)))
  let v112 := (v97 / v111)
  let v113 := (v100 / v111)
  let v114 := (v103 / v111)
  let v125 := (hsun * (Float.sqrt u5))
  let v128 := (((2 : Float) * (3.141592653589793 : Float)) * u6)
  let v129 := (Float.cos v125)
  let v131 := (Float.sin v125)
  let v132 := (Float.cos v128)
  let v134 := (Float.sin v128)
  let v138 := ((v129 * v85) + (v131 * ((v132 * v112) + (v134 * ((v86 * v114) - (v87 * v113))))))
  let v144 := ((v129 * v86) + (v131 * ((v132 * v113) + (v134 * ((v87 * v112) - (v85 * v114))))))
  let v150 := ((v129 * v87) + (v131 * ((v132 * v114) + (v134 * ((v85 * v113) - (v86 * v112))))))
  let v161 := (((Float.abs v74) <= a) && (((Float.abs v78) <= a) && (((Float.abs v82) <= v69) && ((Float.abs v84) <= v69))))
  let v162 := (v74 + v82)
  let v163 := (v78 + v84)
  let v164 := ((2 : Float) * f)
  let v165 := ((1 : Float) / R)
  let v170 := (Float.sqrt (max ((v74 ^ 2) + (v78 ^ 2)) (0.000000000000000001 : Float)))
  let v171 := (v170 ^ 2)
  let v177 := ((1 : Float) - ((((1 : Float) + k) * (v165 ^ 2)) * v171))
  let v185 := ((v165 * v170) / (Float.sqrt (max v177 (0.000000000000000001 : Float))))
  let v188 := (Float.sqrt ((1 : Float) + (v185 ^ 2)))
  let v189 := (-v185)
  let v192 := (((v189 * v74) / v170) / v188)
  let v195 := (((v189 * v78) / v170) / v188)
  let v196 := ((1 : Float) / v188)
  let v198 := (v192 + (sigmaslope * e1))
  let v200 := (v195 + (sigmaslope * e2))
  let v206 := (Float.sqrt (((v198 ^ 2) + (v200 ^ 2)) + (v196 ^ 2)))
  let v207 := (v198 / v206)
  let v208 := (v200 / v206)
  let v209 := (v196 / v206)
  let v223 := (((((v74 - v162) * v192) + ((v78 - v163) * v195)) + ((((v165 * v171) / ((1 : Float) + (Float.sqrt (max v177 (0 : Float))))) - v164) * v196)) / (((v138 * v192) + (v144 * v195)) + (v150 * v196)))
  let v235 := ((2 : Float) * (((v138 * v207) + (v144 * v208)) + (v150 * v209)))
  let v241 := (v150 - (v235 * v209))
  let v243 := ((v138 - (v235 * v207)) + (sigmaspec * s1))
  let v245 := ((v144 - (v235 * v208)) + (sigmaspec * s2))
  let v251 := (Float.sqrt (((v243 ^ 2) + (v245 ^ 2)) + (v241 ^ 2)))
  let v254 := (v241 / v251)
  let v256 := ((f - (v164 + (v223 * v150))) / v254)
  let v264 := (Float.sqrt ((((v162 + (v223 * v138)) + (v256 * (v243 / v251))) ^ 2) + (((v163 + (v223 * v144)) + (v256 * (v245 / v251))) ^ 2)))
  let v266 := ((0 : Float) < v254)
  let v267 := ((v264 <= rc) && v266)
  let v275 := ((v66 ^ 2) * rho)
  (!((0 : Float) <= rho) || ((v275 * (if (v161 && v267) then (1 : Float) else (0 : Float))) <= v275))

#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.027723 0.969174 0.910625 0.852076 0.793528 0.734979 0.676430 0.617881 0.559332 0.500784 0.442235 0.383686 0.325137 0.266588 0.208040 1.749491 1.690942 1.632393 1.573844 1.515296 1.456747 1.398198 1.339649 1.281100))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.696531 0.637982 0.579433 0.520884 0.462336 0.403787 0.345238 0.286689 0.228140 1.769592 1.711043 1.652494 1.593945 1.535396 1.476848 1.418299 1.359750 1.301201 1.242652 1.184104 1.125555 1.067006 1.008457 0.949908))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.365339 0.306790 0.248241 1.789692 1.731144 1.672595 1.614046 1.555497 1.496948 1.438400 1.379851 1.321302 1.262753 1.204204 1.145656 1.087107 1.028558 0.970009 0.911460 0.852912 0.794363 0.735814 0.677265 0.618716))

def dishR  : Float :=
  (2 : Float)

#eval IO.println ("dishR " ++ toString (dishR).toBits)
#eval IO.println ("dishR " ++ toString (dishR).toBits)
#eval IO.println ("dishR " ++ toString (dishR).toBits)

def dishSide  : Float :=
  ((2 : Float) * (0.8 : Float))

#eval IO.println ("dishSide " ++ toString (dishSide).toBits)
#eval IO.println ("dishSide " ++ toString (dishSide).toBits)
#eval IO.println ("dishSide " ++ toString (dishSide).toBits)

def check_dish_between_posts  : Bool :=
  (((2 : Float) * (0.8 : Float)) < (1.84 : Float))

#eval IO.println ("check_dish_between_posts " ++ toString (check_dish_between_posts))
#eval IO.println ("check_dish_between_posts " ++ toString (check_dish_between_posts))
#eval IO.println ("check_dish_between_posts " ++ toString (check_dish_between_posts))

def check_dish_swings_to_vertical  : Bool :=
  ((0.8 : Float) < ((1.30 : Float) - (0.05 : Float)))

#eval IO.println ("check_dish_swings_to_vertical " ++ toString (check_dish_swings_to_vertical))
#eval IO.println ("check_dish_swings_to_vertical " ++ toString (check_dish_swings_to_vertical))
#eval IO.println ("check_dish_swings_to_vertical " ++ toString (check_dish_swings_to_vertical))

def dot3 (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Float :=
  (((u_0 * v_0) + (u_1 * v_1)) + (u_2 * v_2))

#eval IO.println ("dot3 " ++ toString (dot3 1.696963 1.638414 1.579865 1.521316 1.462768 1.404219).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.365771 1.307222 1.248673 1.190124 1.131576 1.073027).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.034579 0.976030 0.917481 0.858932 0.800384 0.741835).toBits)

def driveAz (u : Float) (rw : Float) (R : Float) : Float :=
  (((u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("driveAz " ++ toString (driveAz 1.510811 1.452262 1.393713).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 1.179619 1.121070 1.062521).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 0.848427 0.789878 0.731329).toBits)

def check_driveAz_rate (u : Float) (rw : Float) (R : Float) : Bool :=
  let v11 := (u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rw (0 : Float))) || (!(!(feq R (0 : Float))) || (feq ((((v11 * R) / rw) * rw) / R) v11)))

#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 1.324659 1.266110 1.207561))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 0.993467 0.934918 0.876369))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 0.662275 0.603726 0.545177))

def driveEl (u : Float) (arm : Float) (rDrum : Float) : Float :=
  (((u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("driveEl " ++ toString (driveEl 1.138507 1.079958 1.021409).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 0.807315 0.748766 0.690217).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 0.476123 0.417574 0.359025).toBits)

def check_driveEl_rate (u : Float) (arm : Float) (rDrum : Float) : Bool :=
  let v11 := (u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rDrum (0 : Float))) || (!(!(feq arm (0 : Float))) || (feq ((((v11 * arm) / rDrum) * rDrum) / arm) v11)))

#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.952355 0.893806 0.835257))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.621163 0.562614 0.504065))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.289971 0.231422 1.772873))

def check_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v21 := (Float.sqrt ((v16 ^ 2) + (c_apexH ^ 2)))
  let v23 := (-((F * v16) / v21))
  let v25 := ((F * c_apexH) / v21)
  (feq (((((((0 : Float) * ((v16 * (0 : Float)) - (b_zRail * v25))) + ((0 : Float) * ((b_zRail * v23) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v25) - (v16 * v23)))) + ((0 : Float) * v23)) + ((0 : Float) * v25)) + ((0 : Float) * (0 : Float))) (F * v21))

#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.766203 0.707654 0.649105 0.590556 0.532008 0.473459 0.414910 0.356361 0.297812 0.239264 1.780715 1.722166 1.663617))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.435011 0.376462 0.317913 0.259364 0.200816 1.742267 1.683718 1.625169 1.566620 1.508072 1.449523 1.390974 1.332425))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.703819 1.645270 1.586721 1.528172 1.469624 1.411075 1.352526 1.293977 1.235428 1.176880 1.118331 1.059782 1.001233))

def check_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v17 := (c_chord / (2 : Float))
  let v22 := (Float.sqrt ((v17 ^ 2) + (c_apexH ^ 2)))
  let v24 := (-((F * v17) / v22))
  let v26 := ((F * c_apexH) / v22)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v17 * (0 : Float)) - (b_zRail * v26))) + ((0 : Float) * ((b_zRail * v24) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v26) - (v17 * v24)))) + ((0 : Float) * v24)) + ((0 : Float) * v26)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.580051 0.521502 0.462953 0.404404 0.345856 0.287307 0.228758 1.770209 1.711660 1.653112 1.594563 1.536014 1.477465))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.248859 1.790310 1.731761 1.673212 1.614664 1.556115 1.497566 1.439017 1.380468 1.321920 1.263371 1.204822 1.146273))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.517667 1.459118 1.400569 1.342020 1.283472 1.224923 1.166374 1.107825 1.049276 0.990728 0.932179 0.873630 0.815081))

def edgeClipAt (a : Float) (ze : Float) (t : Float) : Array Float :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  #[((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))]

#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.393899 0.335350 0.276801).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.662707 1.604158 1.545609).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.331515 1.272966 1.214417).map Float.toBits))

def check_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (feq (((-ym) * (((-v6) * v10) + (v9 * v7))) - (hp * ((v6 * v7) + (v9 * v10)))) ((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)))

#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.207747 1.749198 1.690649 1.632100 1.573552))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.476555 1.418006 1.359457 1.300908 1.242360))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.145363 1.086814 1.028265 0.969716 0.911168))

def check_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  (feq ((((v3 * v4) + (v6 * v7)) ^ 2) + ((((-v3) * v7) + (v6 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.621595 1.563046 1.504497))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.290403 1.231854 1.173305))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.959211 0.900662 0.842113))

def check_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v6 := (Float.sqrt (3.36 : Float))
  let v9 := (-(v6 - (1 : Float)))
  let v10 := (Float.sin t)
  (feq ((((v2 * v3) + (v9 * v10)) ^ 2) + ((((-v2) * v10) + (v9 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v6)))

#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.435443))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.104251))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.773059))

def check_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  ((Float.abs ((v3 * v4) + (v6 * v7))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.249291 1.190742 1.132193))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.918099 0.859550 0.801001))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.586907 0.528358 0.469809))

def edgeDepth (f : Float) (a : Float) (sag : Float) (el : Float) : Float :=
  (((f - sag) * (Float.sin el)) + (a * (Float.cos el)))

#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.063139 1.004590 0.946041 0.887492).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.731947 0.673398 0.614849 0.556300).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.400755 0.342206 0.283657 0.225108).toBits)

def check_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.876987 0.818438 0.759889))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.545795 0.487246 0.428697))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.214603 1.756054 1.697505))

def check_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.690835 0.632286 0.573737 0.515188))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.359643 0.301094 0.242545 1.783996))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.628451 1.569902 1.511353 1.452804))

def check_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.504683 0.446134 0.387585))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.773491 1.714942 1.656393))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.442299 1.383750 1.325201))

def check_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v10 := (Float.cos t)
  let v17 := (-a)
  let v19 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v10 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v17) * v5) + (v19 * v10))) - (hp * ((v17 * v10) + (v19 * v5)))) (0 : Float)))

#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.318531 0.259982 0.201433 1.742884 1.684336))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.587339 1.528790 1.470241 1.411692 1.353144))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.256147 1.197598 1.139049 1.080500 1.021952))

def check_edgeLever_pos_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  let v17 := (-ym)
  let v22 := (((v12 - v17) ^ 2) + ((v16 - hp) ^ 2))
  (!((0 : Float) < v22) || (((0 : Float) < (((v17 * v16) - (hp * v12)) / (Float.sqrt v22))) == ((v10 * ((ym * a) - (hp * ze))) < (v7 * ((ym * ze) + (hp * a))))))

#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.732379 1.673830 1.615281 1.556732 1.498184))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.401187 1.342638 1.284089 1.225540 1.166992))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.069995 1.011446 0.952897 0.894348 0.835800))

def elFull  : Float :=
  (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))

#eval IO.println ("elFull " ++ toString (elFull).toBits)
#eval IO.println ("elFull " ++ toString (elFull).toBits)
#eval IO.println ("elFull " ++ toString (elFull).toBits)

def check_elFull_pos  : Bool :=
  ((0 : Float) < (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)))

#eval IO.println ("check_elFull_pos " ++ toString (check_elFull_pos))
#eval IO.println ("check_elFull_pos " ++ toString (check_elFull_pos))
#eval IO.println ("check_elFull_pos " ++ toString (check_elFull_pos))

def elPower (W : Float) (rcm : Float) (t : Float) (omega : Float) : Float :=
  (((W * rcm) * (Float.sin t)) * omega)

#eval IO.println ("elPower " ++ toString (elPower 1.173923 1.115374 1.056825 0.998276).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.842731 0.784182 0.725633 0.667084).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.511539 0.452990 0.394441 0.335892).toBits)

def check_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v9 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v9 / rw) * (rw * omega)) (v9 * omega)))

#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.987771 0.929222 0.870673 0.812124 0.753576))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.656579 0.598030 0.539481 0.480932 0.422384))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.325387 0.266838 0.208289 1.749740 1.691192))

def check_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v8 * (Float.sin t)) * omega) <= (v8 * omega)))))

#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.801619 0.743070 0.684521 0.625972))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.470427 0.411878 0.353329 0.294780))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.739235 1.680686 1.622137 1.563588))

def elRate (omegad : Float) (rDrum : Float) (rw : Float) : Float :=
  ((omegad * rDrum) / rw)

#eval IO.println ("elRate " ++ toString (elRate 0.615467 0.556918 0.498369).toBits)
#eval IO.println ("elRate " ++ toString (elRate 0.284275 0.225726 1.767177).toBits)
#eval IO.println ("elRate " ++ toString (elRate 1.553083 1.494534 1.435985).toBits)

def facetSpot (w : Float) (f : Float) : Float :=
  (w + (f * (0.0093 : Float)))

#eval IO.println ("facetSpot " ++ toString (facetSpot 0.429315 0.370766).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.698123 1.639574).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.366931 1.308382).toBits)

def check_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))

def focusShift (h : Float) (eps : Float) : Float :=
  (h * (Float.sin eps))

#eval IO.println ("focusShift " ++ toString (focusShift 1.657011 1.598462).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.325819 1.267270).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 0.994627 0.936078).toBits)

def check_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v1 := (Float.cos psi)
  let v7 := (Float.sin psi)
  (!(!(feq v1 (1 : Float))) || (!((feq ((v1 * p_1) - (v7 * p_2)) p_1) && (feq ((v7 * p_1) + (v1 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.470859 1.412310 1.353761))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.139667 1.081118 1.022569))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 0.808475 0.749926 0.691377))

def gateTau  : Float :=
  (0.01 : Float)

#eval IO.println ("gateTau " ++ toString (gateTau).toBits)
#eval IO.println ("gateTau " ++ toString (gateTau).toBits)
#eval IO.println ("gateTau " ++ toString (gateTau).toBits)

def check_grooved_reciprocal_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v14 := ((0 : Float) * (0 : Float))
  let v15 := (b_zBearing * (0 : Float))
  let v17 := (b_zBearing * (1 : Float))
  let v19 := ((0 : Float) * (1 : Float))
  let v28 := (c_chord / (2 : Float))
  let v30 := (b_zRail * (0 : Float))
  let v34 := (c_apexH * (0 : Float))
  let v35 := (v28 * (0 : Float))
  let v37 := (-v28)
  let v40 := (v37 * (0 : Float))
  let v82 := ((0 : Float) * (v30 - (c_apexH * (1 : Float))))
  let v99 := ((0 : Float) * ((b_zRail * c_apexH) - v34))
  let v103 := ((0 : Float) * c_apexH)
  ((feq (((((((0 : Float) * (v14 - v15)) + ((0 : Float) * (v17 - v14))) + ((1 : Float) * (v14 - v19))) + v19) + v14) + v14) (0 : Float)) && ((feq (((((((0 : Float) * (v14 - v17)) + ((0 : Float) * (v15 - v14))) + ((1 : Float) * (v19 - v14))) + v14) + v19) + v14) (0 : Float)) && ((feq (((((((0 : Float) * (v19 - v15)) + ((0 : Float) * (v15 - v19))) + ((1 : Float) * (v14 - v14))) + v14) + v14) + v19) (0 : Float)) && ((feq (((((((0 : Float) * ((v28 * (1 : Float)) - v30)) + v82) + ((1 : Float) * (v34 - v35))) + v14) + v14) + v19) (0 : Float)) && ((feq (((((((0 : Float) * ((v37 * (1 : Float)) - v30)) + v82) + ((1 : Float) * (v34 - v40))) + v14) + v14) + v19) (0 : Float)) && ((feq (((((((0 : Float) * (v35 - (b_zRail * v28))) + v99) + ((1 : Float) * ((c_apexH * v28) - (v28 * c_apexH)))) + v103) + ((0 : Float) * v28)) + v14) (0 : Float)) && (feq (((((((0 : Float) * (v40 - (b_zRail * v37))) + v99) + ((1 : Float) * ((c_apexH * v37) - (v37 * c_apexH)))) + v103) + ((0 : Float) * v37)) + v14) (0 : Float))))))))

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.098555 1.040006 0.981457 0.922908 0.864360 0.805811 0.747262 0.688713 0.630164 0.571616 0.513067 0.454518))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.767363 0.708814 0.650265 0.591716 0.533168 0.474619 0.416070 0.357521 0.298972 0.240424 1.781875 1.723326))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.436171 0.377622 0.319073 0.260524 0.201976 1.743427 1.684878 1.626329 1.567780 1.509232 1.450683 1.392134))

def check_grooved_relation_x (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v15 := (v13 * (0 : Float))
  let v19 := (c_apexH * (0 : Float))
  let v20 := ((b_zRail * c_apexH) - v19)
  let v24 := (-v13)
  let v25 := (v24 * (0 : Float))
  let v33 := ((0 : Float) + (0 : Float))
  let v37 := ((2 : Float) * c_apexH)
  let v39 := ((0 : Float) * (0 : Float))
  let v40 := (b_zBearing * (0 : Float))
  let v44 := ((0 : Float) * (1 : Float))
  let v47 := (v37 * (0 : Float))
  let v57 := (b_zRail - b_zBearing)
  let v59 := (b_zRail * (0 : Float))
  let v62 := (v59 - (c_apexH * (1 : Float)))
  let v84 := (v57 * (v33 - ((2 : Float) * (0 : Float))))
  ((feq (((c_apexH + c_apexH) - (v37 * (1 : Float))) + v84) (0 : Float)) && ((feq (((v13 + v24) - v47) + v84) (0 : Float)) && ((feq ((v33 - v47) + (v57 * (((1 : Float) + (1 : Float)) - ((2 : Float) * (1 : Float))))) (0 : Float)) && ((feq ((((v15 - (b_zRail * v13)) + (v25 - (b_zRail * v24))) - (v37 * (v39 - v40))) + (v57 * ((((v13 * (1 : Float)) - v59) + ((v24 * (1 : Float)) - v59)) - ((2 : Float) * (v44 - v40))))) (0 : Float)) && ((feq (((v20 + v20) - (v37 * ((b_zBearing * (1 : Float)) - v39))) + (v57 * ((v62 + v62) - ((2 : Float) * (v40 - v44))))) (0 : Float)) && (feq (((((c_apexH * v13) - (v13 * c_apexH)) + ((c_apexH * v24) - (v24 * c_apexH))) - (v37 * (v39 - v44))) + (v57 * (((v19 - v15) + (v19 - v25)) - ((2 : Float) * (v39 - v39))))) (0 : Float)))))))

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.912403 0.853854 0.795305 0.736756 0.678208 0.619659 0.561110 0.502561 0.444012 0.385464 0.326915 0.268366))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.581211 0.522662 0.464113 0.405564 0.347016 0.288467 0.229918 1.771369 1.712820 1.654272 1.595723 1.537174))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.250019 1.791470 1.732921 1.674372 1.615824 1.557275 1.498726 1.440177 1.381628 1.323080 1.264531 1.205982))

def check_grooved_relation_y (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v15 := (v13 * (0 : Float))
  let v19 := (c_apexH * (0 : Float))
  let v20 := ((b_zRail * c_apexH) - v19)
  let v24 := (-v13)
  let v25 := (v24 * (0 : Float))
  let v33 := ((0 : Float) - (0 : Float))
  let v38 := ((0 : Float) * (0 : Float))
  let v45 := (c_chord * (0 : Float))
  let v56 := (b_zBearing - b_zRail)
  let v58 := (b_zRail * (0 : Float))
  let v61 := (v58 - (c_apexH * (1 : Float)))
  let v70 := (v56 * v33)
  ((feq (((c_apexH - c_apexH) - v45) - v70) (0 : Float)) && ((feq (((v13 - v24) - (c_chord * (1 : Float))) - v70) (0 : Float)) && ((feq ((v33 - v45) - (v56 * ((1 : Float) - (1 : Float)))) (0 : Float)) && ((feq ((((v15 - (b_zRail * v13)) - (v25 - (b_zRail * v24))) - (c_chord * (v38 - (b_zBearing * (1 : Float))))) - (v56 * (((v13 * (1 : Float)) - v58) - ((v24 * (1 : Float)) - v58)))) (0 : Float)) && ((feq (((v20 - v20) - (c_chord * ((b_zBearing * (0 : Float)) - v38))) - (v56 * (v61 - v61))) (0 : Float)) && (feq (((((c_apexH * v13) - (v13 * c_apexH)) - ((c_apexH * v24) - (v24 * c_apexH))) - (c_chord * (((0 : Float) * (1 : Float)) - v38))) - (v56 * ((v19 - v15) - (v19 - v25)))) (0 : Float)))))))

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.726251 0.667702 0.609153 0.550604 0.492056 0.433507 0.374958 0.316409 0.257860 1.799312 1.740763 1.682214))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.395059 0.336510 0.277961 0.219412 1.760864 1.702315 1.643766 1.585217 1.526668 1.468120 1.409571 1.351022))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.663867 1.605318 1.546769 1.488220 1.429672 1.371123 1.312574 1.254025 1.195476 1.136928 1.078379 1.019830))

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 0.353947 0.295398 0.236849 1.778300).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.622755 1.564206 1.505657 1.447108).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.291563 1.233014 1.174465 1.115916).toBits)

def check_hangerLength_bounds  : Bool :=
  let v7 := (Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float)))))
  (((0.884 : Float) < v7) && (v7 < (0.8846 : Float)))

#eval IO.println ("check_hangerLength_bounds " ++ toString (check_hangerLength_bounds))
#eval IO.println ("check_hangerLength_bounds " ++ toString (check_hangerLength_bounds))
#eval IO.println ("check_hangerLength_bounds " ++ toString (check_hangerLength_bounds))

def check_hangerLength_halfEdge  : Bool :=
  let v3 := ((0.4 : Float) ^ 2)
  (feq (Float.sqrt ((((0 : Float) ^ 2) + v3) + ((((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((Float.sqrt (((0.8 : Float) ^ 2) + v3)) ^ 2))))) ^ 2))) (Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float))))))

#eval IO.println ("check_hangerLength_halfEdge " ++ toString (check_hangerLength_halfEdge))
#eval IO.println ("check_hangerLength_halfEdge " ++ toString (check_hangerLength_halfEdge))
#eval IO.println ("check_hangerLength_halfEdge " ++ toString (check_hangerLength_halfEdge))

def hashemi  : Array Float :=
  #[(1.84 : Float), (0.80 : Float), (0.98 : Float), (0.39 : Float), (0.135 : Float), (0.05 : Float)]

#eval IO.println ("hashemi " ++ toString ((hashemi).map Float.toBits))
#eval IO.println ("hashemi " ++ toString ((hashemi).map Float.toBits))
#eval IO.println ("hashemi " ++ toString ((hashemi).map Float.toBits))

def hashemiBase  : Array Float :=
  #[(Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.55 : Float), (0.75 : Float), (0.62 : Float), (0.02 : Float), (8 : Float)]

#eval IO.println ("hashemiBase " ++ toString ((hashemiBase).map Float.toBits))
#eval IO.println ("hashemiBase " ++ toString ((hashemiBase).map Float.toBits))
#eval IO.println ("hashemiBase " ++ toString ((hashemiBase).map Float.toBits))

def hashemiEnv (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dr : Array Float) : Array Float :=
  let v688 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v700 := ((1.22 : Float) * (0.8 : Float))
  let v701 := ((0.34 : Float) * v688)
  let v704 := ((3.141592653589793 : Float) / (2 : Float))
  let v711 := (if (v700 <= v701) then v704 else (Float.atan ((((1.22 : Float) * v688) + ((0.34 : Float) * (0.8 : Float))) / (v700 - v701))))
  let v712 := (-(1.22 : Float))
  let v713 := (-(0.8 : Float))
  let v715 := (Float.cos (0 : Float))
  let v717 := (-v688)
  let v718 := (Float.sin (0 : Float))
  let v721 := (-v713)
  let v730 := (Float.sqrt (((((v713 * v715) + (v717 * v718)) - v712) ^ 2) + ((((v721 * v718) + (v717 * v715)) - (0.34 : Float)) ^ 2)))
  let v731 := (Float.cos v711)
  let v733 := (Float.sin v711)
  let v744 := (Float.sqrt (((((v713 * v731) + (v717 * v733)) - v712) ^ 2) + ((((v721 * v733) + (v717 * v731)) - (0.34 : Float)) ^ 2)))
  let v745 := (Float.cos t)
  let v747 := (Float.sin t)
  let v749 := ((v713 * v745) + (v717 * v747))
  let v752 := ((v721 * v747) + (v717 * v745))
  let v758 := (Float.sqrt (((v749 - v712) ^ 2) + ((v752 - (0.34 : Float)) ^ 2)))
  let v760 := (omegad * rDrum)
  let v762 := ((v758 + slack) - (v760 * dt))
  let v763 := (v762 < v744)
  let v764 := (v730 < v762)
  let v766 := (if v763 then v744 else (if v764 then v730 else v762))
  let v771 := (((0 : Float) + v711) / (2 : Float))
  let v772 := (Float.cos v771)
  let v774 := (Float.sin v771)
  let v786 := (v766 < (Float.sqrt (((((v713 * v772) + (v717 * v774)) - v712) ^ 2) + ((((v721 * v774) + (v717 * v772)) - (0.34 : Float)) ^ 2))))
  let v787 := (if v786 then v771 else (0 : Float))
  let v788 := (if v786 then v711 else v771)
  let v790 := ((v787 + v788) / (2 : Float))
  let v791 := (Float.cos v790)
  let v793 := (Float.sin v790)
  let v805 := (v766 < (Float.sqrt (((((v713 * v791) + (v717 * v793)) - v712) ^ 2) + ((((v721 * v793) + (v717 * v791)) - (0.34 : Float)) ^ 2))))
  let v806 := (if v805 then v790 else v787)
  let v807 := (if v805 then v788 else v790)
  let v809 := ((v806 + v807) / (2 : Float))
  let v810 := (Float.cos v809)
  let v812 := (Float.sin v809)
  let v824 := (v766 < (Float.sqrt (((((v713 * v810) + (v717 * v812)) - v712) ^ 2) + ((((v721 * v812) + (v717 * v810)) - (0.34 : Float)) ^ 2))))
  let v825 := (if v824 then v809 else v806)
  let v826 := (if v824 then v807 else v809)
  let v828 := ((v825 + v826) / (2 : Float))
  let v829 := (Float.cos v828)
  let v831 := (Float.sin v828)
  let v843 := (v766 < (Float.sqrt (((((v713 * v829) + (v717 * v831)) - v712) ^ 2) + ((((v721 * v831) + (v717 * v829)) - (0.34 : Float)) ^ 2))))
  let v844 := (if v843 then v828 else v825)
  let v845 := (if v843 then v826 else v828)
  let v847 := ((v844 + v845) / (2 : Float))
  let v848 := (Float.cos v847)
  let v850 := (Float.sin v847)
  let v862 := (v766 < (Float.sqrt (((((v713 * v848) + (v717 * v850)) - v712) ^ 2) + ((((v721 * v850) + (v717 * v848)) - (0.34 : Float)) ^ 2))))
  let v863 := (if v862 then v847 else v844)
  let v864 := (if v862 then v845 else v847)
  let v866 := ((v863 + v864) / (2 : Float))
  let v867 := (Float.cos v866)
  let v869 := (Float.sin v866)
  let v881 := (v766 < (Float.sqrt (((((v713 * v867) + (v717 * v869)) - v712) ^ 2) + ((((v721 * v869) + (v717 * v867)) - (0.34 : Float)) ^ 2))))
  let v882 := (if v881 then v866 else v863)
  let v883 := (if v881 then v864 else v866)
  let v885 := ((v882 + v883) / (2 : Float))
  let v886 := (Float.cos v885)
  let v888 := (Float.sin v885)
  let v900 := (v766 < (Float.sqrt (((((v713 * v886) + (v717 * v888)) - v712) ^ 2) + ((((v721 * v888) + (v717 * v886)) - (0.34 : Float)) ^ 2))))
  let v901 := (if v900 then v885 else v882)
  let v902 := (if v900 then v883 else v885)
  let v904 := ((v901 + v902) / (2 : Float))
  let v905 := (Float.cos v904)
  let v907 := (Float.sin v904)
  let v919 := (v766 < (Float.sqrt (((((v713 * v905) + (v717 * v907)) - v712) ^ 2) + ((((v721 * v907) + (v717 * v905)) - (0.34 : Float)) ^ 2))))
  let v920 := (if v919 then v904 else v901)
  let v921 := (if v919 then v902 else v904)
  let v923 := ((v920 + v921) / (2 : Float))
  let v924 := (Float.cos v923)
  let v926 := (Float.sin v923)
  let v938 := (v766 < (Float.sqrt (((((v713 * v924) + (v717 * v926)) - v712) ^ 2) + ((((v721 * v926) + (v717 * v924)) - (0.34 : Float)) ^ 2))))
  let v939 := (if v938 then v923 else v920)
  let v940 := (if v938 then v921 else v923)
  let v942 := ((v939 + v940) / (2 : Float))
  let v943 := (Float.cos v942)
  let v945 := (Float.sin v942)
  let v957 := (v766 < (Float.sqrt (((((v713 * v943) + (v717 * v945)) - v712) ^ 2) + ((((v721 * v945) + (v717 * v943)) - (0.34 : Float)) ^ 2))))
  let v958 := (if v957 then v942 else v939)
  let v959 := (if v957 then v940 else v942)
  let v961 := ((v958 + v959) / (2 : Float))
  let v962 := (Float.cos v961)
  let v964 := (Float.sin v961)
  let v976 := (v766 < (Float.sqrt (((((v713 * v962) + (v717 * v964)) - v712) ^ 2) + ((((v721 * v964) + (v717 * v962)) - (0.34 : Float)) ^ 2))))
  let v977 := (if v976 then v961 else v958)
  let v978 := (if v976 then v959 else v961)
  let v980 := ((v977 + v978) / (2 : Float))
  let v981 := (Float.cos v980)
  let v983 := (Float.sin v980)
  let v995 := (v766 < (Float.sqrt (((((v713 * v981) + (v717 * v983)) - v712) ^ 2) + ((((v721 * v983) + (v717 * v981)) - (0.34 : Float)) ^ 2))))
  let v996 := (if v995 then v980 else v977)
  let v997 := (if v995 then v978 else v980)
  let v999 := ((v996 + v997) / (2 : Float))
  let v1000 := (Float.cos v999)
  let v1002 := (Float.sin v999)
  let v1014 := (v766 < (Float.sqrt (((((v713 * v1000) + (v717 * v1002)) - v712) ^ 2) + ((((v721 * v1002) + (v717 * v1000)) - (0.34 : Float)) ^ 2))))
  let v1015 := (if v1014 then v999 else v996)
  let v1016 := (if v1014 then v997 else v999)
  let v1018 := ((v1015 + v1016) / (2 : Float))
  let v1019 := (Float.cos v1018)
  let v1021 := (Float.sin v1018)
  let v1033 := (v766 < (Float.sqrt (((((v713 * v1019) + (v717 * v1021)) - v712) ^ 2) + ((((v721 * v1021) + (v717 * v1019)) - (0.34 : Float)) ^ 2))))
  let v1034 := (if v1033 then v1018 else v1015)
  let v1035 := (if v1033 then v1016 else v1018)
  let v1037 := ((v1034 + v1035) / (2 : Float))
  let v1038 := (Float.cos v1037)
  let v1040 := (Float.sin v1037)
  let v1052 := (v766 < (Float.sqrt (((((v713 * v1038) + (v717 * v1040)) - v712) ^ 2) + ((((v721 * v1040) + (v717 * v1038)) - (0.34 : Float)) ^ 2))))
  let v1053 := (if v1052 then v1037 else v1034)
  let v1054 := (if v1052 then v1035 else v1037)
  let v1056 := ((v1053 + v1054) / (2 : Float))
  let v1057 := (Float.cos v1056)
  let v1059 := (Float.sin v1056)
  let v1071 := (v766 < (Float.sqrt (((((v713 * v1057) + (v717 * v1059)) - v712) ^ 2) + ((((v721 * v1059) + (v717 * v1057)) - (0.34 : Float)) ^ 2))))
  let v1072 := (if v1071 then v1056 else v1053)
  let v1073 := (if v1071 then v1054 else v1056)
  let v1075 := ((v1072 + v1073) / (2 : Float))
  let v1076 := (Float.cos v1075)
  let v1078 := (Float.sin v1075)
  let v1090 := (v766 < (Float.sqrt (((((v713 * v1076) + (v717 * v1078)) - v712) ^ 2) + ((((v721 * v1078) + (v717 * v1076)) - (0.34 : Float)) ^ 2))))
  let v1091 := (if v1090 then v1075 else v1072)
  let v1092 := (if v1090 then v1073 else v1075)
  let v1094 := ((v1091 + v1092) / (2 : Float))
  let v1095 := (Float.cos v1094)
  let v1097 := (Float.sin v1094)
  let v1109 := (v766 < (Float.sqrt (((((v713 * v1095) + (v717 * v1097)) - v712) ^ 2) + ((((v721 * v1097) + (v717 * v1095)) - (0.34 : Float)) ^ 2))))
  let v1110 := (if v1109 then v1094 else v1091)
  let v1111 := (if v1109 then v1092 else v1094)
  let v1113 := ((v1110 + v1111) / (2 : Float))
  let v1114 := (Float.cos v1113)
  let v1116 := (Float.sin v1113)
  let v1128 := (v766 < (Float.sqrt (((((v713 * v1114) + (v717 * v1116)) - v712) ^ 2) + ((((v721 * v1116) + (v717 * v1114)) - (0.34 : Float)) ^ 2))))
  let v1129 := (if v1128 then v1113 else v1110)
  let v1130 := (if v1128 then v1111 else v1113)
  let v1132 := ((v1129 + v1130) / (2 : Float))
  let v1133 := (Float.cos v1132)
  let v1135 := (Float.sin v1132)
  let v1147 := (v766 < (Float.sqrt (((((v713 * v1133) + (v717 * v1135)) - v712) ^ 2) + ((((v721 * v1135) + (v717 * v1133)) - (0.34 : Float)) ^ 2))))
  let v1148 := (if v1147 then v1132 else v1129)
  let v1149 := (if v1147 then v1130 else v1132)
  let v1151 := ((v1148 + v1149) / (2 : Float))
  let v1152 := (Float.cos v1151)
  let v1154 := (Float.sin v1151)
  let v1166 := (v766 < (Float.sqrt (((((v713 * v1152) + (v717 * v1154)) - v712) ^ 2) + ((((v721 * v1154) + (v717 * v1152)) - (0.34 : Float)) ^ 2))))
  let v1167 := (if v1166 then v1151 else v1148)
  let v1168 := (if v1166 then v1149 else v1151)
  let v1170 := ((v1167 + v1168) / (2 : Float))
  let v1171 := (Float.cos v1170)
  let v1173 := (Float.sin v1170)
  let v1185 := (v766 < (Float.sqrt (((((v713 * v1171) + (v717 * v1173)) - v712) ^ 2) + ((((v721 * v1173) + (v717 * v1171)) - (0.34 : Float)) ^ 2))))
  let v1186 := (if v1185 then v1170 else v1167)
  let v1187 := (if v1185 then v1168 else v1170)
  let v1189 := ((v1186 + v1187) / (2 : Float))
  let v1190 := (Float.cos v1189)
  let v1192 := (Float.sin v1189)
  let v1204 := (v766 < (Float.sqrt (((((v713 * v1190) + (v717 * v1192)) - v712) ^ 2) + ((((v721 * v1192) + (v717 * v1190)) - (0.34 : Float)) ^ 2))))
  let v1205 := (if v1204 then v1189 else v1186)
  let v1206 := (if v1204 then v1187 else v1189)
  let v1208 := ((v1205 + v1206) / (2 : Float))
  let v1209 := (Float.cos v1208)
  let v1211 := (Float.sin v1208)
  let v1223 := (v766 < (Float.sqrt (((((v713 * v1209) + (v717 * v1211)) - v712) ^ 2) + ((((v721 * v1211) + (v717 * v1209)) - (0.34 : Float)) ^ 2))))
  let v1228 := (if (v730 <= v762) then (0 : Float) else (((if v1223 then v1208 else v1205) + (if v1223 then v1206 else v1208)) / (2 : Float)))
  let v1229 := (W * rcm)
  let v1230 := (Float.cos v1228)
  let v1232 := (Float.sin v1228)
  let v1234 := ((v713 * v1230) + (v717 * v1232))
  let v1237 := ((v721 * v1232) + (v717 * v1230))
  let v1252 := ((t < v1228) && (!(v1229 <= (Tmax * (((v712 * v1237) - ((0.34 : Float) * v1234)) / (Float.sqrt (((v1234 - v712) ^ 2) + ((v1237 - (0.34 : Float)) ^ 2))))))))
  let v1253 := (if v1252 then t else v1228)
  let v1258 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1263 := (Float.cos v1253)
  let v1265 := (Float.sin v1253)
  let v1267 := ((v713 * v1263) + (v717 * v1265))
  let v1270 := ((v721 * v1265) + (v717 * v1263))
  let v1290 := (v747 * (Float.cos az))
  let v1292 := (v747 * (Float.sin az))
  let v1293 := (Float.cos elSun)
  let v1295 := (v1293 * (Float.cos azSun))
  let v1297 := (v1293 * (Float.sin azSun))
  let v1298 := (Float.sin elSun)
  let v1303 := (((v1290 * v1295) + (v1292 * v1297)) + (v745 * v1298))
  let v1318 := (Float.sqrt (((((v1292 * v1298) - (v745 * v1297)) ^ 2) + (((v745 * v1295) - (v1290 * v1298)) ^ 2)) + (((v1290 * v1297) - (v1292 * v1295)) ^ 2)))
  let v1328 := (if (v1303 <= (0 : Float)) then (v704 + (Float.atan ((-v1303) / (max v1318 (0.000000000001 : Float))))) else (Float.atan (v1318 / v1303)))
  let v1330 := (v704 - v711)
  let v1331 := (v1330 <= elSun)
  let v1345 := (Float.cos v1258)
  let v1346 := (v1265 * v1345)
  let v1347 := (Float.sin v1258)
  let v1348 := (v1265 * v1347)
  let v1349 := (v1263 * v1345)
  let v1350 := (v1263 * v1347)
  let v1351 := (-v1265)
  let v1376 := ((2 : Float) * a)
  let v1377 := (v1376 / w)
  let v1379 := (w / (2 : Float))
  let v1380 := ((-a) + v1379)
  let v1399 := ((1 : Float) / (2 : Float))
  let v1404 := (-(((((v1350 * v1263) - (v1351 * v1348)) * v1295) + (((v1351 * v1346) - (v1349 * v1263)) * v1297)) + (((v1349 * v1348) - (v1350 * v1346)) * v1298)))
  let v1405 := (-(((v1349 * v1295) + (v1350 * v1297)) + (v1351 * v1298)))
  let v1406 := (-(((v1346 * v1295) + (v1348 * v1297)) + (v1263 * v1298)))
  let v1411 := ((Float.abs v1406) < ((9 : Float) / (10 : Float)))
  let v1412 := (if v1411 then (0 : Float) else (1 : Float))
  let v1413 := (if v1411 then (1 : Float) else (0 : Float))
  let v1416 := ((v1405 * v1413) - (v1406 * (0 : Float)))
  let v1419 := ((v1406 * v1412) - (v1404 * v1413))
  let v1422 := ((v1404 * (0 : Float)) - (v1405 * v1412))
  let v1430 := (Float.sqrt (max (((v1416 ^ 2) + (v1419 ^ 2)) + (v1422 ^ 2)) (0.000000000000000001 : Float)))
  let v1431 := (v1416 / v1430)
  let v1432 := (v1419 / v1430)
  let v1433 := (v1422 / v1430)
  let v1482 := ((2 : Float) * f)
  let v1483 := ((1 : Float) / R)
  let v1593 := ((v1376 ^ 2) * rho)
  let v1599 := ((List.range 64).foldl (fun acc i => acc + (let v1394 := (v1380 + (w * (Float.floor (dr[i * 10 + 0]! * v1377)))); let v1398 := (v1380 + (w * (Float.floor (dr[i * 10 + 1]! * v1377)))); let v1401 := ((dr[i * 10 + 2]! - v1399) * w); let v1403 := ((dr[i * 10 + 3]! - v1399) * w); let v1444 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1446 := (((2 : Float) * (3.141592653589793 : Float)) * dr[i * 10 + 5]!); let v1447 := (Float.cos v1444); let v1449 := (Float.sin v1444); let v1450 := (Float.cos v1446); let v1452 := (Float.sin v1446); let v1456 := ((v1447 * v1404) + (v1449 * ((v1450 * v1431) + (v1452 * ((v1405 * v1433) - (v1406 * v1432)))))); let v1462 := ((v1447 * v1405) + (v1449 * ((v1450 * v1432) + (v1452 * ((v1406 * v1431) - (v1404 * v1433)))))); let v1468 := ((v1447 * v1406) + (v1449 * ((v1450 * v1433) + (v1452 * ((v1404 * v1432) - (v1405 * v1431)))))); let v1479 := (((Float.abs v1394) <= a) && (((Float.abs v1398) <= a) && (((Float.abs v1401) <= v1379) && ((Float.abs v1403) <= v1379)))); let v1480 := (v1394 + v1401); let v1481 := (v1398 + v1403); let v1488 := (Float.sqrt (max ((v1394 ^ 2) + (v1398 ^ 2)) (0.000000000000000001 : Float))); let v1489 := (v1488 ^ 2); let v1495 := ((1 : Float) - ((((1 : Float) + k) * (v1483 ^ 2)) * v1489)); let v1503 := ((v1483 * v1488) / (Float.sqrt (max v1495 (0.000000000000000001 : Float)))); let v1506 := (Float.sqrt ((1 : Float) + (v1503 ^ 2))); let v1507 := (-v1503); let v1510 := (((v1507 * v1394) / v1488) / v1506); let v1513 := (((v1507 * v1398) / v1488) / v1506); let v1514 := ((1 : Float) / v1506); let v1516 := (v1510 + (sigmaslope * dr[i * 10 + 6]!)); let v1518 := (v1513 + (sigmaslope * dr[i * 10 + 7]!)); let v1524 := (Float.sqrt (((v1516 ^ 2) + (v1518 ^ 2)) + (v1514 ^ 2))); let v1525 := (v1516 / v1524); let v1526 := (v1518 / v1524); let v1527 := (v1514 / v1524); let v1541 := (((((v1394 - v1480) * v1510) + ((v1398 - v1481) * v1513)) + ((((v1483 * v1489) / ((1 : Float) + (Float.sqrt (max v1495 (0 : Float))))) - v1482) * v1514)) / (((v1456 * v1510) + (v1462 * v1513)) + (v1468 * v1514))); let v1553 := ((2 : Float) * (((v1456 * v1525) + (v1462 * v1526)) + (v1468 * v1527))); let v1559 := (v1468 - (v1553 * v1527)); let v1561 := ((v1456 - (v1553 * v1525)) + (sigmaspec * dr[i * 10 + 8]!)); let v1563 := ((v1462 - (v1553 * v1526)) + (sigmaspec * dr[i * 10 + 9]!)); let v1569 := (Float.sqrt (((v1561 ^ 2) + (v1563 ^ 2)) + (v1559 ^ 2))); let v1572 := (v1559 / v1569); let v1574 := ((f - (v1482 + (v1541 * v1468))) / v1572); let v1582 := (Float.sqrt ((((v1480 + (v1541 * v1456)) + (v1574 * (v1561 / v1569))) ^ 2) + (((v1481 + (v1541 * v1462)) + (v1574 * (v1563 / v1569))) ^ 2))); let v1584 := ((0 : Float) < v1572); let v1585 := ((v1582 <= rc) && v1584); let v1587 := (if (v1479 && v1585) then (1 : Float) else (0 : Float)); v1587)) 0.0)
  let v1602 := ((List.range 64).foldl (fun acc i => acc + (let v1394 := (v1380 + (w * (Float.floor (dr[i * 10 + 0]! * v1377)))); let v1398 := (v1380 + (w * (Float.floor (dr[i * 10 + 1]! * v1377)))); let v1401 := ((dr[i * 10 + 2]! - v1399) * w); let v1403 := ((dr[i * 10 + 3]! - v1399) * w); let v1444 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1446 := (((2 : Float) * (3.141592653589793 : Float)) * dr[i * 10 + 5]!); let v1447 := (Float.cos v1444); let v1449 := (Float.sin v1444); let v1450 := (Float.cos v1446); let v1452 := (Float.sin v1446); let v1456 := ((v1447 * v1404) + (v1449 * ((v1450 * v1431) + (v1452 * ((v1405 * v1433) - (v1406 * v1432)))))); let v1462 := ((v1447 * v1405) + (v1449 * ((v1450 * v1432) + (v1452 * ((v1406 * v1431) - (v1404 * v1433)))))); let v1468 := ((v1447 * v1406) + (v1449 * ((v1450 * v1433) + (v1452 * ((v1404 * v1432) - (v1405 * v1431)))))); let v1479 := (((Float.abs v1394) <= a) && (((Float.abs v1398) <= a) && (((Float.abs v1401) <= v1379) && ((Float.abs v1403) <= v1379)))); let v1480 := (v1394 + v1401); let v1481 := (v1398 + v1403); let v1488 := (Float.sqrt (max ((v1394 ^ 2) + (v1398 ^ 2)) (0.000000000000000001 : Float))); let v1489 := (v1488 ^ 2); let v1495 := ((1 : Float) - ((((1 : Float) + k) * (v1483 ^ 2)) * v1489)); let v1503 := ((v1483 * v1488) / (Float.sqrt (max v1495 (0.000000000000000001 : Float)))); let v1506 := (Float.sqrt ((1 : Float) + (v1503 ^ 2))); let v1507 := (-v1503); let v1510 := (((v1507 * v1394) / v1488) / v1506); let v1513 := (((v1507 * v1398) / v1488) / v1506); let v1514 := ((1 : Float) / v1506); let v1516 := (v1510 + (sigmaslope * dr[i * 10 + 6]!)); let v1518 := (v1513 + (sigmaslope * dr[i * 10 + 7]!)); let v1524 := (Float.sqrt (((v1516 ^ 2) + (v1518 ^ 2)) + (v1514 ^ 2))); let v1525 := (v1516 / v1524); let v1526 := (v1518 / v1524); let v1527 := (v1514 / v1524); let v1541 := (((((v1394 - v1480) * v1510) + ((v1398 - v1481) * v1513)) + ((((v1483 * v1489) / ((1 : Float) + (Float.sqrt (max v1495 (0 : Float))))) - v1482) * v1514)) / (((v1456 * v1510) + (v1462 * v1513)) + (v1468 * v1514))); let v1553 := ((2 : Float) * (((v1456 * v1525) + (v1462 * v1526)) + (v1468 * v1527))); let v1559 := (v1468 - (v1553 * v1527)); let v1561 := ((v1456 - (v1553 * v1525)) + (sigmaspec * dr[i * 10 + 8]!)); let v1563 := ((v1462 - (v1553 * v1526)) + (sigmaspec * dr[i * 10 + 9]!)); let v1569 := (Float.sqrt (((v1561 ^ 2) + (v1563 ^ 2)) + (v1559 ^ 2))); let v1572 := (v1559 / v1569); let v1574 := ((f - (v1482 + (v1541 * v1468))) / v1572); let v1582 := (Float.sqrt ((((v1480 + (v1541 * v1456)) + (v1574 * (v1561 / v1569))) ^ 2) + (((v1481 + (v1541 * v1462)) + (v1574 * (v1563 / v1569))) ^ 2))); let v1584 := ((0 : Float) < v1572); let v1585 := ((v1582 <= rc) && v1584); let v1587 := (if (v1479 && v1585) then (1 : Float) else (0 : Float)); (1.0 / (1.0 + Float.exp (-((rc - v1582) / (0.005 : Float))))))) 0.0)
  let v1616 := (Toil - Ta)
  #[v1258, v1253, (if v764 then (v762 - v730) else (0 : Float)), (if v1252 then v758 else v766), v711, (if (v763 || v1252) then (1 : Float) else (0 : Float)), (if (feq (if v764 then (v762 - v730) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1229 <= (Tmax * (((v712 * v1270) - ((0.34 : Float) * v1267)) / (Float.sqrt (((v1267 - v712) ^ 2) + ((v1270 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (((v712 * v752) - ((0.34 : Float) * v749)) / v758), (v760 / (((v712 * v752) - ((0.34 : Float) * v749)) / v758)), ((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))), v1328, (v704 - t), (if v1331 then (1 : Float) else (0 : Float)), (if (v1331 && ((0.03 : Float) < v1328)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1330) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1330) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1328 - (0.03 : Float)) / (0.01 : Float)))))), (v1599 / (64 : Float)), (v1602 / (64 : Float)), (v1593 * (v1599 / (64 : Float))), (((v1593 * (v1599 / (64 : Float))) * dni) * soil), (min ToilMax (Toil + ((dt * ((((alpha * (((v1593 * (v1599 / (64 : Float))) * dni) * soil)) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v1616))) - (Upipe * v1616)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * (((v1593 * (v1599 / (64 : Float))) * dni) * soil)), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v1616)), (Upipe * v1616), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * (((v1593 * (v1599 / (64 : Float))) * dni) * soil)) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v1616))) - (Upipe * v1616)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.023187 0.964638 0.906089 0.847540 0.788992 0.730443 0.671894 0.613345 0.554796 0.496248 0.437699 0.379150 0.320601 0.262052 0.203504 1.744955 1.686406 1.627857 1.569308 1.510760 1.452211 1.393662 1.335113 1.276564 1.218016 1.159467 1.100918 1.042369 0.983820 0.925272 0.866723 0.808174 0.749625 0.691076 0.632528 0.573979 0.515430 0.456881 #[1.299803, 1.241254, 1.182705, 1.124156, 1.065608, 1.007059, 0.948510, 0.889961, 0.831412, 0.772864, 0.714315, 0.655766, 0.597217, 0.538668, 0.480120, 0.421571, 0.363022, 0.304473, 0.245924, 1.787376, 1.728827, 1.670278, 1.611729, 1.553180, 1.494632, 1.436083, 1.377534, 1.318985, 1.260436, 1.201888, 1.143339, 1.084790, 1.026241, 0.967692, 0.909144, 0.850595, 0.792046, 0.733497, 0.674948, 0.616400, 0.557851, 0.499302, 0.440753, 0.382204, 0.323656, 0.265107, 0.206558, 1.748009, 1.689460, 1.630912, 1.572363, 1.513814, 1.455265, 1.396716, 1.338168, 1.279619, 1.221070, 1.162521, 1.103972, 1.045424, 0.986875, 0.928326, 0.869777, 0.811228, 0.752680, 0.694131, 0.635582, 0.577033, 0.518484, 0.459936, 0.401387, 0.342838, 0.284289, 0.225740, 1.767192, 1.708643, 1.650094, 1.591545, 1.532996, 1.474448, 1.415899, 1.357350, 1.298801, 1.240252, 1.181704, 1.123155, 1.064606, 1.006057, 0.947508, 0.888960, 0.830411, 0.771862, 0.713313, 0.654764, 0.596216, 0.537667, 0.479118, 0.420569, 0.362020, 0.303472, 0.244923, 1.786374, 1.727825, 1.669276, 1.610728, 1.552179, 1.493630, 1.435081, 1.376532, 1.317984, 1.259435, 1.200886, 1.142337, 1.083788, 1.025240, 0.966691, 0.908142, 0.849593, 0.791044, 0.732496, 0.673947, 0.615398, 0.556849, 0.498300, 0.439752, 0.381203, 0.322654, 0.264105, 0.205556, 1.747008, 1.688459, 1.629910, 1.571361, 1.512812, 1.454264, 1.395715, 1.337166, 1.278617, 1.220068, 1.161520, 1.102971, 1.044422, 0.985873, 0.927324, 0.868776, 0.810227, 0.751678, 0.693129, 0.634580, 0.576032, 0.517483, 0.458934, 0.400385, 0.341836, 0.283288, 0.224739, 1.766190, 1.707641, 1.649092, 1.590544, 1.531995, 1.473446, 1.414897, 1.356348, 1.297800, 1.239251, 1.180702, 1.122153, 1.063604, 1.005056, 0.946507, 0.887958, 0.829409, 0.770860, 0.712312, 0.653763, 0.595214, 0.536665, 0.478116, 0.419568, 0.361019, 0.302470, 0.243921, 1.785372, 1.726824, 1.668275, 1.609726, 1.551177, 1.492628, 1.434080, 1.375531, 1.316982, 1.258433, 1.199884, 1.141336, 1.082787, 1.024238, 0.965689, 0.907140, 0.848592, 0.790043, 0.731494, 0.672945, 0.614396, 0.555848, 0.497299, 0.438750, 0.380201, 0.321652, 0.263104, 0.204555, 1.746006, 1.687457, 1.628908, 1.570360, 1.511811, 1.453262, 1.394713, 1.336164, 1.277616, 1.219067, 1.160518, 1.101969, 1.043420, 0.984872, 0.926323, 0.867774, 0.809225, 0.750676, 0.692128, 0.633579, 0.575030, 0.516481, 0.457932, 0.399384, 0.340835, 0.282286, 0.223737, 1.765188, 1.706640, 1.648091, 1.589542, 1.530993, 1.472444, 1.413896, 1.355347, 1.296798, 1.238249, 1.179700, 1.121152, 1.062603, 1.004054, 0.945505, 0.886956, 0.828408, 0.769859, 0.711310, 0.652761, 0.594212, 0.535664, 0.477115, 0.418566, 0.360017, 0.301468, 0.242920, 1.784371, 1.725822, 1.667273, 1.608724, 1.550176, 1.491627, 1.433078, 1.374529, 1.315980, 1.257432, 1.198883, 1.140334, 1.081785, 1.023236, 0.964688, 0.906139, 0.847590, 0.789041, 0.730492, 0.671944, 0.613395, 0.554846, 0.496297, 0.437748, 0.379200, 0.320651, 0.262102, 0.203553, 1.745004, 1.686456, 1.627907, 1.569358, 1.510809, 1.452260, 1.393712, 1.335163, 1.276614, 1.218065, 1.159516, 1.100968, 1.042419, 0.983870, 0.925321, 0.866772, 0.808224, 0.749675, 0.691126, 0.632577, 0.574028, 0.515480, 0.456931, 0.398382, 0.339833, 0.281284, 0.222736, 1.764187, 1.705638, 1.647089, 1.588540, 1.529992, 1.471443, 1.412894, 1.354345, 1.295796, 1.237248, 1.178699, 1.120150, 1.061601, 1.003052, 0.944504, 0.885955, 0.827406, 0.768857, 0.710308, 0.651760, 0.593211, 0.534662, 0.476113, 0.417564, 0.359016, 0.300467, 0.241918, 1.783369, 1.724820, 1.666272, 1.607723, 1.549174, 1.490625, 1.432076, 1.373528, 1.314979, 1.256430, 1.197881, 1.139332, 1.080784, 1.022235, 0.963686, 0.905137, 0.846588, 0.788040, 0.729491, 0.670942, 0.612393, 0.553844, 0.495296, 0.436747, 0.378198, 0.319649, 0.261100, 0.202552, 1.744003, 1.685454, 1.626905, 1.568356, 1.509808, 1.451259, 1.392710, 1.334161, 1.275612, 1.217064, 1.158515, 1.099966, 1.041417, 0.982868, 0.924320, 0.865771, 0.807222, 0.748673, 0.690124, 0.631576, 0.573027, 0.514478, 0.455929, 0.397380, 0.338832, 0.280283, 0.221734, 1.763185, 1.704636, 1.646088, 1.587539, 1.528990, 1.470441, 1.411892, 1.353344, 1.294795, 1.236246, 1.177697, 1.119148, 1.060600, 1.002051, 0.943502, 0.884953, 0.826404, 0.767856, 0.709307, 0.650758, 0.592209, 0.533660, 0.475112, 0.416563, 0.358014, 0.299465, 0.240916, 1.782368, 1.723819, 1.665270, 1.606721, 1.548172, 1.489624, 1.431075, 1.372526, 1.313977, 1.255428, 1.196880, 1.138331, 1.079782, 1.021233, 0.962684, 0.904136, 0.845587, 0.787038, 0.728489, 0.669940, 0.611392, 0.552843, 0.494294, 0.435745, 0.377196, 0.318648, 0.260099, 0.201550, 1.743001, 1.684452, 1.625904, 1.567355, 1.508806, 1.450257, 1.391708, 1.333160, 1.274611, 1.216062, 1.157513, 1.098964, 1.040416, 0.981867, 0.923318, 0.864769, 0.806220, 0.747672, 0.689123, 0.630574, 0.572025, 0.513476, 0.454928, 0.396379, 0.337830, 0.279281, 0.220732, 1.762184, 1.703635, 1.645086, 1.586537, 1.527988, 1.469440, 1.410891, 1.352342, 1.293793, 1.235244, 1.176696, 1.118147, 1.059598, 1.001049, 0.942500, 0.883952, 0.825403, 0.766854, 0.708305, 0.649756, 0.591208, 0.532659, 0.474110, 0.415561, 0.357012, 0.298464, 0.239915, 1.781366, 1.722817, 1.664268, 1.605720, 1.547171, 1.488622, 1.430073, 1.371524, 1.312976, 1.254427, 1.195878, 1.137329, 1.078780, 1.020232, 0.961683, 0.903134, 0.844585, 0.786036, 0.727488, 0.668939, 0.610390, 0.551841, 0.493292, 0.434744, 0.376195, 0.317646, 0.259097, 0.200548, 1.742000, 1.683451, 1.624902, 1.566353, 1.507804, 1.449256, 1.390707, 1.332158, 1.273609, 1.215060, 1.156512, 1.097963, 1.039414, 0.980865, 0.922316, 0.863768, 0.805219, 0.746670, 0.688121, 0.629572, 0.571024, 0.512475, 0.453926, 0.395377, 0.336828, 0.278280, 0.219731, 1.761182, 1.702633, 1.644084, 1.585536, 1.526987, 1.468438, 1.409889, 1.351340, 1.292792, 1.234243, 1.175694, 1.117145, 1.058596, 1.000048, 0.941499, 0.882950, 0.824401, 0.765852, 0.707304, 0.648755, 0.590206, 0.531657, 0.473108, 0.414560, 0.356011, 0.297462, 0.238913, 1.780364, 1.721816, 1.663267, 1.604718, 1.546169, 1.487620, 1.429072, 1.370523, 1.311974, 1.253425, 1.194876, 1.136328, 1.077779, 1.019230, 0.960681, 0.902132, 0.843584, 0.785035, 0.726486, 0.667937, 0.609388, 0.550840, 0.492291, 0.433742, 0.375193, 0.316644, 0.258096, 1.799547, 1.740998, 1.682449, 1.623900, 1.565352, 1.506803, 1.448254, 1.389705, 1.331156, 1.272608, 1.214059, 1.155510, 1.096961, 1.038412, 0.979864, 0.921315, 0.862766, 0.804217, 0.745668, 0.687120]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.691995 0.633446 0.574897 0.516348 0.457800 0.399251 0.340702 0.282153 0.223604 1.765056 1.706507 1.647958 1.589409 1.530860 1.472312 1.413763 1.355214 1.296665 1.238116 1.179568 1.121019 1.062470 1.003921 0.945372 0.886824 0.828275 0.769726 0.711177 0.652628 0.594080 0.535531 0.476982 0.418433 0.359884 0.301336 0.242787 1.784238 1.725689 #[0.968611, 0.910062, 0.851513, 0.792964, 0.734416, 0.675867, 0.617318, 0.558769, 0.500220, 0.441672, 0.383123, 0.324574, 0.266025, 0.207476, 1.748928, 1.690379, 1.631830, 1.573281, 1.514732, 1.456184, 1.397635, 1.339086, 1.280537, 1.221988, 1.163440, 1.104891, 1.046342, 0.987793, 0.929244, 0.870696, 0.812147, 0.753598, 0.695049, 0.636500, 0.577952, 0.519403, 0.460854, 0.402305, 0.343756, 0.285208, 0.226659, 1.768110, 1.709561, 1.651012, 1.592464, 1.533915, 1.475366, 1.416817, 1.358268, 1.299720, 1.241171, 1.182622, 1.124073, 1.065524, 1.006976, 0.948427, 0.889878, 0.831329, 0.772780, 0.714232, 0.655683, 0.597134, 0.538585, 0.480036, 0.421488, 0.362939, 0.304390, 0.245841, 1.787292, 1.728744, 1.670195, 1.611646, 1.553097, 1.494548, 1.436000, 1.377451, 1.318902, 1.260353, 1.201804, 1.143256, 1.084707, 1.026158, 0.967609, 0.909060, 0.850512, 0.791963, 0.733414, 0.674865, 0.616316, 0.557768, 0.499219, 0.440670, 0.382121, 0.323572, 0.265024, 0.206475, 1.747926, 1.689377, 1.630828, 1.572280, 1.513731, 1.455182, 1.396633, 1.338084, 1.279536, 1.220987, 1.162438, 1.103889, 1.045340, 0.986792, 0.928243, 0.869694, 0.811145, 0.752596, 0.694048, 0.635499, 0.576950, 0.518401, 0.459852, 0.401304, 0.342755, 0.284206, 0.225657, 1.767108, 1.708560, 1.650011, 1.591462, 1.532913, 1.474364, 1.415816, 1.357267, 1.298718, 1.240169, 1.181620, 1.123072, 1.064523, 1.005974, 0.947425, 0.888876, 0.830328, 0.771779, 0.713230, 0.654681, 0.596132, 0.537584, 0.479035, 0.420486, 0.361937, 0.303388, 0.244840, 1.786291, 1.727742, 1.669193, 1.610644, 1.552096, 1.493547, 1.434998, 1.376449, 1.317900, 1.259352, 1.200803, 1.142254, 1.083705, 1.025156, 0.966608, 0.908059, 0.849510, 0.790961, 0.732412, 0.673864, 0.615315, 0.556766, 0.498217, 0.439668, 0.381120, 0.322571, 0.264022, 0.205473, 1.746924, 1.688376, 1.629827, 1.571278, 1.512729, 1.454180, 1.395632, 1.337083, 1.278534, 1.219985, 1.161436, 1.102888, 1.044339, 0.985790, 0.927241, 0.868692, 0.810144, 0.751595, 0.693046, 0.634497, 0.575948, 0.517400, 0.458851, 0.400302, 0.341753, 0.283204, 0.224656, 1.766107, 1.707558, 1.649009, 1.590460, 1.531912, 1.473363, 1.414814, 1.356265, 1.297716, 1.239168, 1.180619, 1.122070, 1.063521, 1.004972, 0.946424, 0.887875, 0.829326, 0.770777, 0.712228, 0.653680, 0.595131, 0.536582, 0.478033, 0.419484, 0.360936, 0.302387, 0.243838, 1.785289, 1.726740, 1.668192, 1.609643, 1.551094, 1.492545, 1.433996, 1.375448, 1.316899, 1.258350, 1.199801, 1.141252, 1.082704, 1.024155, 0.965606, 0.907057, 0.848508, 0.789960, 0.731411, 0.672862, 0.614313, 0.555764, 0.497216, 0.438667, 0.380118, 0.321569, 0.263020, 0.204472, 1.745923, 1.687374, 1.628825, 1.570276, 1.511728, 1.453179, 1.394630, 1.336081, 1.277532, 1.218984, 1.160435, 1.101886, 1.043337, 0.984788, 0.926240, 0.867691, 0.809142, 0.750593, 0.692044, 0.633496, 0.574947, 0.516398, 0.457849, 0.399300, 0.340752, 0.282203, 0.223654, 1.765105, 1.706556, 1.648008, 1.589459, 1.530910, 1.472361, 1.413812, 1.355264, 1.296715, 1.238166, 1.179617, 1.121068, 1.062520, 1.003971, 0.945422, 0.886873, 0.828324, 0.769776, 0.711227, 0.652678, 0.594129, 0.535580, 0.477032, 0.418483, 0.359934, 0.301385, 0.242836, 1.784288, 1.725739, 1.667190, 1.608641, 1.550092, 1.491544, 1.432995, 1.374446, 1.315897, 1.257348, 1.198800, 1.140251, 1.081702, 1.023153, 0.964604, 0.906056, 0.847507, 0.788958, 0.730409, 0.671860, 0.613312, 0.554763, 0.496214, 0.437665, 0.379116, 0.320568, 0.262019, 0.203470, 1.744921, 1.686372, 1.627824, 1.569275, 1.510726, 1.452177, 1.393628, 1.335080, 1.276531, 1.217982, 1.159433, 1.100884, 1.042336, 0.983787, 0.925238, 0.866689, 0.808140, 0.749592, 0.691043, 0.632494, 0.573945, 0.515396, 0.456848, 0.398299, 0.339750, 0.281201, 0.222652, 1.764104, 1.705555, 1.647006, 1.588457, 1.529908, 1.471360, 1.412811, 1.354262, 1.295713, 1.237164, 1.178616, 1.120067, 1.061518, 1.002969, 0.944420, 0.885872, 0.827323, 0.768774, 0.710225, 0.651676, 0.593128, 0.534579, 0.476030, 0.417481, 0.358932, 0.300384, 0.241835, 1.783286, 1.724737, 1.666188, 1.607640, 1.549091, 1.490542, 1.431993, 1.373444, 1.314896, 1.256347, 1.197798, 1.139249, 1.080700, 1.022152, 0.963603, 0.905054, 0.846505, 0.787956, 0.729408, 0.670859, 0.612310, 0.553761, 0.495212, 0.436664, 0.378115, 0.319566, 0.261017, 0.202468, 1.743920, 1.685371, 1.626822, 1.568273, 1.509724, 1.451176, 1.392627, 1.334078, 1.275529, 1.216980, 1.158432, 1.099883, 1.041334, 0.982785, 0.924236, 0.865688, 0.807139, 0.748590, 0.690041, 0.631492, 0.572944, 0.514395, 0.455846, 0.397297, 0.338748, 0.280200, 0.221651, 1.763102, 1.704553, 1.646004, 1.587456, 1.528907, 1.470358, 1.411809, 1.353260, 1.294712, 1.236163, 1.177614, 1.119065, 1.060516, 1.001968, 0.943419, 0.884870, 0.826321, 0.767772, 0.709224, 0.650675, 0.592126, 0.533577, 0.475028, 0.416480, 0.357931, 0.299382, 0.240833, 1.782284, 1.723736, 1.665187, 1.606638, 1.548089, 1.489540, 1.430992, 1.372443, 1.313894, 1.255345, 1.196796, 1.138248, 1.079699, 1.021150, 0.962601, 0.904052, 0.845504, 0.786955, 0.728406, 0.669857, 0.611308, 0.552760, 0.494211, 0.435662, 0.377113, 0.318564, 0.260016, 0.201467, 1.742918, 1.684369, 1.625820, 1.567272, 1.508723, 1.450174, 1.391625, 1.333076, 1.274528, 1.215979, 1.157430, 1.098881, 1.040332, 0.981784, 0.923235, 0.864686, 0.806137, 0.747588, 0.689040, 0.630491, 0.571942, 0.513393, 0.454844, 0.396296, 0.337747, 0.279198, 0.220649, 1.762100, 1.703552, 1.645003, 1.586454, 1.527905, 1.469356, 1.410808, 1.352259, 1.293710, 1.235161, 1.176612, 1.118064, 1.059515, 1.000966, 0.942417, 0.883868, 0.825320, 0.766771, 0.708222, 0.649673, 0.591124, 0.532576, 0.474027, 0.415478, 0.356929, 0.298380, 0.239832, 1.781283, 1.722734, 1.664185, 1.605636, 1.547088, 1.488539, 1.429990, 1.371441, 1.312892, 1.254344, 1.195795, 1.137246, 1.078697, 1.020148, 0.961600, 0.903051, 0.844502, 0.785953, 0.727404, 0.668856, 0.610307, 0.551758, 0.493209, 0.434660, 0.376112, 0.317563, 0.259014, 0.200465, 1.741916, 1.683368, 1.624819, 1.566270, 1.507721, 1.449172, 1.390624, 1.332075, 1.273526, 1.214977, 1.156428, 1.097880, 1.039331, 0.980782, 0.922233, 0.863684, 0.805136, 0.746587, 0.688038, 0.629489, 0.570940, 0.512392, 0.453843, 0.395294, 0.336745, 0.278196, 0.219648, 1.761099, 1.702550, 1.644001, 1.585452, 1.526904, 1.468355, 1.409806, 1.351257, 1.292708, 1.234160, 1.175611, 1.117062, 1.058513, 0.999964, 0.941416, 0.882867, 0.824318, 0.765769, 0.707220, 0.648672, 0.590123, 0.531574, 0.473025, 0.414476, 0.355928]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.360803 0.302254 0.243705 1.785156 1.726608 1.668059 1.609510 1.550961 1.492412 1.433864 1.375315 1.316766 1.258217 1.199668 1.141120 1.082571 1.024022 0.965473 0.906924 0.848376 0.789827 0.731278 0.672729 0.614180 0.555632 0.497083 0.438534 0.379985 0.321436 0.262888 0.204339 1.745790 1.687241 1.628692 1.570144 1.511595 1.453046 1.394497 #[0.637419, 0.578870, 0.520321, 0.461772, 0.403224, 0.344675, 0.286126, 0.227577, 1.769028, 1.710480, 1.651931, 1.593382, 1.534833, 1.476284, 1.417736, 1.359187, 1.300638, 1.242089, 1.183540, 1.124992, 1.066443, 1.007894, 0.949345, 0.890796, 0.832248, 0.773699, 0.715150, 0.656601, 0.598052, 0.539504, 0.480955, 0.422406, 0.363857, 0.305308, 0.246760, 1.788211, 1.729662, 1.671113, 1.612564, 1.554016, 1.495467, 1.436918, 1.378369, 1.319820, 1.261272, 1.202723, 1.144174, 1.085625, 1.027076, 0.968528, 0.909979, 0.851430, 0.792881, 0.734332, 0.675784, 0.617235, 0.558686, 0.500137, 0.441588, 0.383040, 0.324491, 0.265942, 0.207393, 1.748844, 1.690296, 1.631747, 1.573198, 1.514649, 1.456100, 1.397552, 1.339003, 1.280454, 1.221905, 1.163356, 1.104808, 1.046259, 0.987710, 0.929161, 0.870612, 0.812064, 0.753515, 0.694966, 0.636417, 0.577868, 0.519320, 0.460771, 0.402222, 0.343673, 0.285124, 0.226576, 1.768027, 1.709478, 1.650929, 1.592380, 1.533832, 1.475283, 1.416734, 1.358185, 1.299636, 1.241088, 1.182539, 1.123990, 1.065441, 1.006892, 0.948344, 0.889795, 0.831246, 0.772697, 0.714148, 0.655600, 0.597051, 0.538502, 0.479953, 0.421404, 0.362856, 0.304307, 0.245758, 1.787209, 1.728660, 1.670112, 1.611563, 1.553014, 1.494465, 1.435916, 1.377368, 1.318819, 1.260270, 1.201721, 1.143172, 1.084624, 1.026075, 0.967526, 0.908977, 0.850428, 0.791880, 0.733331, 0.674782, 0.616233, 0.557684, 0.499136, 0.440587, 0.382038, 0.323489, 0.264940, 0.206392, 1.747843, 1.689294, 1.630745, 1.572196, 1.513648, 1.455099, 1.396550, 1.338001, 1.279452, 1.220904, 1.162355, 1.103806, 1.045257, 0.986708, 0.928160, 0.869611, 0.811062, 0.752513, 0.693964, 0.635416, 0.576867, 0.518318, 0.459769, 0.401220, 0.342672, 0.284123, 0.225574, 1.767025, 1.708476, 1.649928, 1.591379, 1.532830, 1.474281, 1.415732, 1.357184, 1.298635, 1.240086, 1.181537, 1.122988, 1.064440, 1.005891, 0.947342, 0.888793, 0.830244, 0.771696, 0.713147, 0.654598, 0.596049, 0.537500, 0.478952, 0.420403, 0.361854, 0.303305, 0.244756, 1.786208, 1.727659, 1.669110, 1.610561, 1.552012, 1.493464, 1.434915, 1.376366, 1.317817, 1.259268, 1.200720, 1.142171, 1.083622, 1.025073, 0.966524, 0.907976, 0.849427, 0.790878, 0.732329, 0.673780, 0.615232, 0.556683, 0.498134, 0.439585, 0.381036, 0.322488, 0.263939, 0.205390, 1.746841, 1.688292, 1.629744, 1.571195, 1.512646, 1.454097, 1.395548, 1.337000, 1.278451, 1.219902, 1.161353, 1.102804, 1.044256, 0.985707, 0.927158, 0.868609, 0.810060, 0.751512, 0.692963, 0.634414, 0.575865, 0.517316, 0.458768, 0.400219, 0.341670, 0.283121, 0.224572, 1.766024, 1.707475, 1.648926, 1.590377, 1.531828, 1.473280, 1.414731, 1.356182, 1.297633, 1.239084, 1.180536, 1.121987, 1.063438, 1.004889, 0.946340, 0.887792, 0.829243, 0.770694, 0.712145, 0.653596, 0.595048, 0.536499, 0.477950, 0.419401, 0.360852, 0.302304, 0.243755, 1.785206, 1.726657, 1.668108, 1.609560, 1.551011, 1.492462, 1.433913, 1.375364, 1.316816, 1.258267, 1.199718, 1.141169, 1.082620, 1.024072, 0.965523, 0.906974, 0.848425, 0.789876, 0.731328, 0.672779, 0.614230, 0.555681, 0.497132, 0.438584, 0.380035, 0.321486, 0.262937, 0.204388, 1.745840, 1.687291, 1.628742, 1.570193, 1.511644, 1.453096, 1.394547, 1.335998, 1.277449, 1.218900, 1.160352, 1.101803, 1.043254, 0.984705, 0.926156, 0.867608, 0.809059, 0.750510, 0.691961, 0.633412, 0.574864, 0.516315, 0.457766, 0.399217, 0.340668, 0.282120, 0.223571, 1.765022, 1.706473, 1.647924, 1.589376, 1.530827, 1.472278, 1.413729, 1.355180, 1.296632, 1.238083, 1.179534, 1.120985, 1.062436, 1.003888, 0.945339, 0.886790, 0.828241, 0.769692, 0.711144, 0.652595, 0.594046, 0.535497, 0.476948, 0.418400, 0.359851, 0.301302, 0.242753, 1.784204, 1.725656, 1.667107, 1.608558, 1.550009, 1.491460, 1.432912, 1.374363, 1.315814, 1.257265, 1.198716, 1.140168, 1.081619, 1.023070, 0.964521, 0.905972, 0.847424, 0.788875, 0.730326, 0.671777, 0.613228, 0.554680, 0.496131, 0.437582, 0.379033, 0.320484, 0.261936, 0.203387, 1.744838, 1.686289, 1.627740, 1.569192, 1.510643, 1.452094, 1.393545, 1.334996, 1.276448, 1.217899, 1.159350, 1.100801, 1.042252, 0.983704, 0.925155, 0.866606, 0.808057, 0.749508, 0.690960, 0.632411, 0.573862, 0.515313, 0.456764, 0.398216, 0.339667, 0.281118, 0.222569, 1.764020, 1.705472, 1.646923, 1.588374, 1.529825, 1.471276, 1.412728, 1.354179, 1.295630, 1.237081, 1.178532, 1.119984, 1.061435, 1.002886, 0.944337, 0.885788, 0.827240, 0.768691, 0.710142, 0.651593, 0.593044, 0.534496, 0.475947, 0.417398, 0.358849, 0.300300, 0.241752, 1.783203, 1.724654, 1.666105, 1.607556, 1.549008, 1.490459, 1.431910, 1.373361, 1.314812, 1.256264, 1.197715, 1.139166, 1.080617, 1.022068, 0.963520, 0.904971, 0.846422, 0.787873, 0.729324, 0.670776, 0.612227, 0.553678, 0.495129, 0.436580, 0.378032, 0.319483, 0.260934, 0.202385, 1.743836, 1.685288, 1.626739, 1.568190, 1.509641, 1.451092, 1.392544, 1.333995, 1.275446, 1.216897, 1.158348, 1.099800, 1.041251, 0.982702, 0.924153, 0.865604, 0.807056, 0.748507, 0.689958, 0.631409, 0.572860, 0.514312, 0.455763, 0.397214, 0.338665, 0.280116, 0.221568, 1.763019, 1.704470, 1.645921, 1.587372, 1.528824, 1.470275, 1.411726, 1.353177, 1.294628, 1.236080, 1.177531, 1.118982, 1.060433, 1.001884, 0.943336, 0.884787, 0.826238, 0.767689, 0.709140, 0.650592, 0.592043, 0.533494, 0.474945, 0.416396, 0.357848, 0.299299, 0.240750, 1.782201, 1.723652, 1.665104, 1.606555, 1.548006, 1.489457, 1.430908, 1.372360, 1.313811, 1.255262, 1.196713, 1.138164, 1.079616, 1.021067, 0.962518, 0.903969, 0.845420, 0.786872, 0.728323, 0.669774, 0.611225, 0.552676, 0.494128, 0.435579, 0.377030, 0.318481, 0.259932, 0.201384, 1.742835, 1.684286, 1.625737, 1.567188, 1.508640, 1.450091, 1.391542, 1.332993, 1.274444, 1.215896, 1.157347, 1.098798, 1.040249, 0.981700, 0.923152, 0.864603, 0.806054, 0.747505, 0.688956, 0.630408, 0.571859, 0.513310, 0.454761, 0.396212, 0.337664, 0.279115, 0.220566, 1.762017, 1.703468, 1.644920, 1.586371, 1.527822, 1.469273, 1.410724, 1.352176, 1.293627, 1.235078, 1.176529, 1.117980, 1.059432, 1.000883, 0.942334, 0.883785, 0.825236, 0.766688, 0.708139, 0.649590, 0.591041, 0.532492, 0.473944, 0.415395, 0.356846, 0.298297, 0.239748, 1.781200, 1.722651, 1.664102, 1.605553, 1.547004, 1.488456, 1.429907, 1.371358, 1.312809, 1.254260, 1.195712, 1.137163, 1.078614, 1.020065, 0.961516, 0.902968, 0.844419, 0.785870, 0.727321, 0.668772, 0.610224, 0.551675, 0.493126, 0.434577, 0.376028, 0.317480, 0.258931, 0.200382, 1.741833, 1.683284, 1.624736]).map Float.toBits))

def check_hashemiEnv_capture_mem (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dr : Array Float) : Bool :=
  let v689 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v701 := ((1.22 : Float) * (0.8 : Float))
  let v702 := ((0.34 : Float) * v689)
  let v705 := ((3.141592653589793 : Float) / (2 : Float))
  let v712 := (if (v701 <= v702) then v705 else (Float.atan ((((1.22 : Float) * v689) + ((0.34 : Float) * (0.8 : Float))) / (v701 - v702))))
  let v713 := (-(1.22 : Float))
  let v714 := (-(0.8 : Float))
  let v715 := (Float.cos (0 : Float))
  let v717 := (-v689)
  let v718 := (Float.sin (0 : Float))
  let v721 := (-v714)
  let v730 := (Float.sqrt (((((v714 * v715) + (v717 * v718)) - v713) ^ 2) + ((((v721 * v718) + (v717 * v715)) - (0.34 : Float)) ^ 2)))
  let v731 := (Float.cos v712)
  let v733 := (Float.sin v712)
  let v744 := (Float.sqrt (((((v714 * v731) + (v717 * v733)) - v713) ^ 2) + ((((v721 * v733) + (v717 * v731)) - (0.34 : Float)) ^ 2)))
  let v745 := (Float.cos t)
  let v747 := (Float.sin t)
  let v749 := ((v714 * v745) + (v717 * v747))
  let v752 := ((v721 * v747) + (v717 * v745))
  let v758 := (Float.sqrt (((v749 - v713) ^ 2) + ((v752 - (0.34 : Float)) ^ 2)))
  let v760 := (omegad * rDrum)
  let v762 := ((v758 + slack) - (v760 * dt))
  let v763 := (v762 < v744)
  let v764 := (v730 < v762)
  let v766 := (if v763 then v744 else (if v764 then v730 else v762))
  let v771 := (((0 : Float) + v712) / (2 : Float))
  let v772 := (Float.cos v771)
  let v774 := (Float.sin v771)
  let v786 := (v766 < (Float.sqrt (((((v714 * v772) + (v717 * v774)) - v713) ^ 2) + ((((v721 * v774) + (v717 * v772)) - (0.34 : Float)) ^ 2))))
  let v787 := (if v786 then v771 else (0 : Float))
  let v788 := (if v786 then v712 else v771)
  let v790 := ((v787 + v788) / (2 : Float))
  let v791 := (Float.cos v790)
  let v793 := (Float.sin v790)
  let v805 := (v766 < (Float.sqrt (((((v714 * v791) + (v717 * v793)) - v713) ^ 2) + ((((v721 * v793) + (v717 * v791)) - (0.34 : Float)) ^ 2))))
  let v806 := (if v805 then v790 else v787)
  let v807 := (if v805 then v788 else v790)
  let v809 := ((v806 + v807) / (2 : Float))
  let v810 := (Float.cos v809)
  let v812 := (Float.sin v809)
  let v824 := (v766 < (Float.sqrt (((((v714 * v810) + (v717 * v812)) - v713) ^ 2) + ((((v721 * v812) + (v717 * v810)) - (0.34 : Float)) ^ 2))))
  let v825 := (if v824 then v809 else v806)
  let v826 := (if v824 then v807 else v809)
  let v828 := ((v825 + v826) / (2 : Float))
  let v829 := (Float.cos v828)
  let v831 := (Float.sin v828)
  let v843 := (v766 < (Float.sqrt (((((v714 * v829) + (v717 * v831)) - v713) ^ 2) + ((((v721 * v831) + (v717 * v829)) - (0.34 : Float)) ^ 2))))
  let v844 := (if v843 then v828 else v825)
  let v845 := (if v843 then v826 else v828)
  let v847 := ((v844 + v845) / (2 : Float))
  let v848 := (Float.cos v847)
  let v850 := (Float.sin v847)
  let v862 := (v766 < (Float.sqrt (((((v714 * v848) + (v717 * v850)) - v713) ^ 2) + ((((v721 * v850) + (v717 * v848)) - (0.34 : Float)) ^ 2))))
  let v863 := (if v862 then v847 else v844)
  let v864 := (if v862 then v845 else v847)
  let v866 := ((v863 + v864) / (2 : Float))
  let v867 := (Float.cos v866)
  let v869 := (Float.sin v866)
  let v881 := (v766 < (Float.sqrt (((((v714 * v867) + (v717 * v869)) - v713) ^ 2) + ((((v721 * v869) + (v717 * v867)) - (0.34 : Float)) ^ 2))))
  let v882 := (if v881 then v866 else v863)
  let v883 := (if v881 then v864 else v866)
  let v885 := ((v882 + v883) / (2 : Float))
  let v886 := (Float.cos v885)
  let v888 := (Float.sin v885)
  let v900 := (v766 < (Float.sqrt (((((v714 * v886) + (v717 * v888)) - v713) ^ 2) + ((((v721 * v888) + (v717 * v886)) - (0.34 : Float)) ^ 2))))
  let v901 := (if v900 then v885 else v882)
  let v902 := (if v900 then v883 else v885)
  let v904 := ((v901 + v902) / (2 : Float))
  let v905 := (Float.cos v904)
  let v907 := (Float.sin v904)
  let v919 := (v766 < (Float.sqrt (((((v714 * v905) + (v717 * v907)) - v713) ^ 2) + ((((v721 * v907) + (v717 * v905)) - (0.34 : Float)) ^ 2))))
  let v920 := (if v919 then v904 else v901)
  let v921 := (if v919 then v902 else v904)
  let v923 := ((v920 + v921) / (2 : Float))
  let v924 := (Float.cos v923)
  let v926 := (Float.sin v923)
  let v938 := (v766 < (Float.sqrt (((((v714 * v924) + (v717 * v926)) - v713) ^ 2) + ((((v721 * v926) + (v717 * v924)) - (0.34 : Float)) ^ 2))))
  let v939 := (if v938 then v923 else v920)
  let v940 := (if v938 then v921 else v923)
  let v942 := ((v939 + v940) / (2 : Float))
  let v943 := (Float.cos v942)
  let v945 := (Float.sin v942)
  let v957 := (v766 < (Float.sqrt (((((v714 * v943) + (v717 * v945)) - v713) ^ 2) + ((((v721 * v945) + (v717 * v943)) - (0.34 : Float)) ^ 2))))
  let v958 := (if v957 then v942 else v939)
  let v959 := (if v957 then v940 else v942)
  let v961 := ((v958 + v959) / (2 : Float))
  let v962 := (Float.cos v961)
  let v964 := (Float.sin v961)
  let v976 := (v766 < (Float.sqrt (((((v714 * v962) + (v717 * v964)) - v713) ^ 2) + ((((v721 * v964) + (v717 * v962)) - (0.34 : Float)) ^ 2))))
  let v977 := (if v976 then v961 else v958)
  let v978 := (if v976 then v959 else v961)
  let v980 := ((v977 + v978) / (2 : Float))
  let v981 := (Float.cos v980)
  let v983 := (Float.sin v980)
  let v995 := (v766 < (Float.sqrt (((((v714 * v981) + (v717 * v983)) - v713) ^ 2) + ((((v721 * v983) + (v717 * v981)) - (0.34 : Float)) ^ 2))))
  let v996 := (if v995 then v980 else v977)
  let v997 := (if v995 then v978 else v980)
  let v999 := ((v996 + v997) / (2 : Float))
  let v1000 := (Float.cos v999)
  let v1002 := (Float.sin v999)
  let v1014 := (v766 < (Float.sqrt (((((v714 * v1000) + (v717 * v1002)) - v713) ^ 2) + ((((v721 * v1002) + (v717 * v1000)) - (0.34 : Float)) ^ 2))))
  let v1015 := (if v1014 then v999 else v996)
  let v1016 := (if v1014 then v997 else v999)
  let v1018 := ((v1015 + v1016) / (2 : Float))
  let v1019 := (Float.cos v1018)
  let v1021 := (Float.sin v1018)
  let v1033 := (v766 < (Float.sqrt (((((v714 * v1019) + (v717 * v1021)) - v713) ^ 2) + ((((v721 * v1021) + (v717 * v1019)) - (0.34 : Float)) ^ 2))))
  let v1034 := (if v1033 then v1018 else v1015)
  let v1035 := (if v1033 then v1016 else v1018)
  let v1037 := ((v1034 + v1035) / (2 : Float))
  let v1038 := (Float.cos v1037)
  let v1040 := (Float.sin v1037)
  let v1052 := (v766 < (Float.sqrt (((((v714 * v1038) + (v717 * v1040)) - v713) ^ 2) + ((((v721 * v1040) + (v717 * v1038)) - (0.34 : Float)) ^ 2))))
  let v1053 := (if v1052 then v1037 else v1034)
  let v1054 := (if v1052 then v1035 else v1037)
  let v1056 := ((v1053 + v1054) / (2 : Float))
  let v1057 := (Float.cos v1056)
  let v1059 := (Float.sin v1056)
  let v1071 := (v766 < (Float.sqrt (((((v714 * v1057) + (v717 * v1059)) - v713) ^ 2) + ((((v721 * v1059) + (v717 * v1057)) - (0.34 : Float)) ^ 2))))
  let v1072 := (if v1071 then v1056 else v1053)
  let v1073 := (if v1071 then v1054 else v1056)
  let v1075 := ((v1072 + v1073) / (2 : Float))
  let v1076 := (Float.cos v1075)
  let v1078 := (Float.sin v1075)
  let v1090 := (v766 < (Float.sqrt (((((v714 * v1076) + (v717 * v1078)) - v713) ^ 2) + ((((v721 * v1078) + (v717 * v1076)) - (0.34 : Float)) ^ 2))))
  let v1091 := (if v1090 then v1075 else v1072)
  let v1092 := (if v1090 then v1073 else v1075)
  let v1094 := ((v1091 + v1092) / (2 : Float))
  let v1095 := (Float.cos v1094)
  let v1097 := (Float.sin v1094)
  let v1109 := (v766 < (Float.sqrt (((((v714 * v1095) + (v717 * v1097)) - v713) ^ 2) + ((((v721 * v1097) + (v717 * v1095)) - (0.34 : Float)) ^ 2))))
  let v1110 := (if v1109 then v1094 else v1091)
  let v1111 := (if v1109 then v1092 else v1094)
  let v1113 := ((v1110 + v1111) / (2 : Float))
  let v1114 := (Float.cos v1113)
  let v1116 := (Float.sin v1113)
  let v1128 := (v766 < (Float.sqrt (((((v714 * v1114) + (v717 * v1116)) - v713) ^ 2) + ((((v721 * v1116) + (v717 * v1114)) - (0.34 : Float)) ^ 2))))
  let v1129 := (if v1128 then v1113 else v1110)
  let v1130 := (if v1128 then v1111 else v1113)
  let v1132 := ((v1129 + v1130) / (2 : Float))
  let v1133 := (Float.cos v1132)
  let v1135 := (Float.sin v1132)
  let v1147 := (v766 < (Float.sqrt (((((v714 * v1133) + (v717 * v1135)) - v713) ^ 2) + ((((v721 * v1135) + (v717 * v1133)) - (0.34 : Float)) ^ 2))))
  let v1148 := (if v1147 then v1132 else v1129)
  let v1149 := (if v1147 then v1130 else v1132)
  let v1151 := ((v1148 + v1149) / (2 : Float))
  let v1152 := (Float.cos v1151)
  let v1154 := (Float.sin v1151)
  let v1166 := (v766 < (Float.sqrt (((((v714 * v1152) + (v717 * v1154)) - v713) ^ 2) + ((((v721 * v1154) + (v717 * v1152)) - (0.34 : Float)) ^ 2))))
  let v1167 := (if v1166 then v1151 else v1148)
  let v1168 := (if v1166 then v1149 else v1151)
  let v1170 := ((v1167 + v1168) / (2 : Float))
  let v1171 := (Float.cos v1170)
  let v1173 := (Float.sin v1170)
  let v1185 := (v766 < (Float.sqrt (((((v714 * v1171) + (v717 * v1173)) - v713) ^ 2) + ((((v721 * v1173) + (v717 * v1171)) - (0.34 : Float)) ^ 2))))
  let v1186 := (if v1185 then v1170 else v1167)
  let v1187 := (if v1185 then v1168 else v1170)
  let v1189 := ((v1186 + v1187) / (2 : Float))
  let v1190 := (Float.cos v1189)
  let v1192 := (Float.sin v1189)
  let v1204 := (v766 < (Float.sqrt (((((v714 * v1190) + (v717 * v1192)) - v713) ^ 2) + ((((v721 * v1192) + (v717 * v1190)) - (0.34 : Float)) ^ 2))))
  let v1205 := (if v1204 then v1189 else v1186)
  let v1206 := (if v1204 then v1187 else v1189)
  let v1208 := ((v1205 + v1206) / (2 : Float))
  let v1209 := (Float.cos v1208)
  let v1211 := (Float.sin v1208)
  let v1223 := (v766 < (Float.sqrt (((((v714 * v1209) + (v717 * v1211)) - v713) ^ 2) + ((((v721 * v1211) + (v717 * v1209)) - (0.34 : Float)) ^ 2))))
  let v1228 := (if (v730 <= v762) then (0 : Float) else (((if v1223 then v1208 else v1205) + (if v1223 then v1206 else v1208)) / (2 : Float)))
  let v1229 := (W * rcm)
  let v1230 := (Float.cos v1228)
  let v1232 := (Float.sin v1228)
  let v1234 := ((v714 * v1230) + (v717 * v1232))
  let v1237 := ((v721 * v1232) + (v717 * v1230))
  let v1252 := ((t < v1228) && (!(v1229 <= (Tmax * (((v713 * v1237) - ((0.34 : Float) * v1234)) / (Float.sqrt (((v1234 - v713) ^ 2) + ((v1237 - (0.34 : Float)) ^ 2))))))))
  let v1253 := (if v1252 then t else v1228)
  let v1258 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1263 := (Float.cos v1253)
  let v1265 := (Float.sin v1253)
  let v1293 := (Float.cos elSun)
  let v1295 := (v1293 * (Float.cos azSun))
  let v1297 := (v1293 * (Float.sin azSun))
  let v1298 := (Float.sin elSun)
  let v1345 := (Float.cos v1258)
  let v1346 := (v1265 * v1345)
  let v1347 := (Float.sin v1258)
  let v1348 := (v1265 * v1347)
  let v1349 := (v1263 * v1345)
  let v1350 := (v1263 * v1347)
  let v1351 := (-v1265)
  let v1376 := ((2 : Float) * a)
  let v1377 := (v1376 / w)
  let v1379 := (w / (2 : Float))
  let v1380 := ((-a) + v1379)
  let v1399 := ((1 : Float) / (2 : Float))
  let v1404 := (-(((((v1350 * v1263) - (v1351 * v1348)) * v1295) + (((v1351 * v1346) - (v1349 * v1263)) * v1297)) + (((v1349 * v1348) - (v1350 * v1346)) * v1298)))
  let v1405 := (-(((v1349 * v1295) + (v1350 * v1297)) + (v1351 * v1298)))
  let v1406 := (-(((v1346 * v1295) + (v1348 * v1297)) + (v1263 * v1298)))
  let v1411 := ((Float.abs v1406) < ((9 : Float) / (10 : Float)))
  let v1412 := (if v1411 then (0 : Float) else (1 : Float))
  let v1413 := (if v1411 then (1 : Float) else (0 : Float))
  let v1416 := ((v1405 * v1413) - (v1406 * (0 : Float)))
  let v1419 := ((v1406 * v1412) - (v1404 * v1413))
  let v1422 := ((v1404 * (0 : Float)) - (v1405 * v1412))
  let v1430 := (Float.sqrt (max (((v1416 ^ 2) + (v1419 ^ 2)) + (v1422 ^ 2)) (0.000000000000000001 : Float)))
  let v1431 := (v1416 / v1430)
  let v1432 := (v1419 / v1430)
  let v1433 := (v1422 / v1430)
  let v1482 := ((2 : Float) * f)
  let v1483 := ((1 : Float) / R)
  let v1599 := ((List.range 64).foldl (fun acc i => acc + (let v1394 := (v1380 + (w * (Float.floor (dr[i * 10 + 0]! * v1377)))); let v1398 := (v1380 + (w * (Float.floor (dr[i * 10 + 1]! * v1377)))); let v1401 := ((dr[i * 10 + 2]! - v1399) * w); let v1403 := ((dr[i * 10 + 3]! - v1399) * w); let v1444 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1446 := (((2 : Float) * (3.141592653589793 : Float)) * dr[i * 10 + 5]!); let v1447 := (Float.cos v1444); let v1449 := (Float.sin v1444); let v1450 := (Float.cos v1446); let v1452 := (Float.sin v1446); let v1456 := ((v1447 * v1404) + (v1449 * ((v1450 * v1431) + (v1452 * ((v1405 * v1433) - (v1406 * v1432)))))); let v1462 := ((v1447 * v1405) + (v1449 * ((v1450 * v1432) + (v1452 * ((v1406 * v1431) - (v1404 * v1433)))))); let v1468 := ((v1447 * v1406) + (v1449 * ((v1450 * v1433) + (v1452 * ((v1404 * v1432) - (v1405 * v1431)))))); let v1479 := (((Float.abs v1394) <= a) && (((Float.abs v1398) <= a) && (((Float.abs v1401) <= v1379) && ((Float.abs v1403) <= v1379)))); let v1480 := (v1394 + v1401); let v1481 := (v1398 + v1403); let v1488 := (Float.sqrt (max ((v1394 ^ 2) + (v1398 ^ 2)) (0.000000000000000001 : Float))); let v1489 := (v1488 ^ 2); let v1495 := ((1 : Float) - ((((1 : Float) + k) * (v1483 ^ 2)) * v1489)); let v1503 := ((v1483 * v1488) / (Float.sqrt (max v1495 (0.000000000000000001 : Float)))); let v1506 := (Float.sqrt ((1 : Float) + (v1503 ^ 2))); let v1507 := (-v1503); let v1510 := (((v1507 * v1394) / v1488) / v1506); let v1513 := (((v1507 * v1398) / v1488) / v1506); let v1514 := ((1 : Float) / v1506); let v1516 := (v1510 + (sigmaslope * dr[i * 10 + 6]!)); let v1518 := (v1513 + (sigmaslope * dr[i * 10 + 7]!)); let v1524 := (Float.sqrt (((v1516 ^ 2) + (v1518 ^ 2)) + (v1514 ^ 2))); let v1525 := (v1516 / v1524); let v1526 := (v1518 / v1524); let v1527 := (v1514 / v1524); let v1541 := (((((v1394 - v1480) * v1510) + ((v1398 - v1481) * v1513)) + ((((v1483 * v1489) / ((1 : Float) + (Float.sqrt (max v1495 (0 : Float))))) - v1482) * v1514)) / (((v1456 * v1510) + (v1462 * v1513)) + (v1468 * v1514))); let v1553 := ((2 : Float) * (((v1456 * v1525) + (v1462 * v1526)) + (v1468 * v1527))); let v1559 := (v1468 - (v1553 * v1527)); let v1561 := ((v1456 - (v1553 * v1525)) + (sigmaspec * dr[i * 10 + 8]!)); let v1563 := ((v1462 - (v1553 * v1526)) + (sigmaspec * dr[i * 10 + 9]!)); let v1569 := (Float.sqrt (((v1561 ^ 2) + (v1563 ^ 2)) + (v1559 ^ 2))); let v1572 := (v1559 / v1569); let v1574 := ((f - (v1482 + (v1541 * v1468))) / v1572); let v1582 := (Float.sqrt ((((v1480 + (v1541 * v1456)) + (v1574 * (v1561 / v1569))) ^ 2) + (((v1481 + (v1541 * v1462)) + (v1574 * (v1563 / v1569))) ^ 2))); let v1584 := ((0 : Float) < v1572); let v1585 := ((v1582 <= rc) && v1584); let v1587 := (if (v1479 && v1585) then (1 : Float) else (0 : Float)); v1587)) 0.0)
  let v1601 := (v1599 / (64 : Float))
  (((0 : Float) <= v1601) && (v1601 <= (1 : Float)))

#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.837035 0.778486 0.719937 0.661388 0.602840 0.544291 0.485742 0.427193 0.368644 0.310096 0.251547 1.792998 1.734449 1.675900 1.617352 1.558803 1.500254 1.441705 1.383156 1.324608 1.266059 1.207510 1.148961 1.090412 1.031864 0.973315 0.914766 0.856217 0.797668 0.739120 0.680571 0.622022 0.563473 0.504924 0.446376 0.387827 0.329278 0.270729 #[1.113651, 1.055102, 0.996553, 0.938004, 0.879456, 0.820907, 0.762358, 0.703809, 0.645260, 0.586712, 0.528163, 0.469614, 0.411065, 0.352516, 0.293968, 0.235419, 1.776870, 1.718321, 1.659772, 1.601224, 1.542675, 1.484126, 1.425577, 1.367028, 1.308480, 1.249931, 1.191382, 1.132833, 1.074284, 1.015736, 0.957187, 0.898638, 0.840089, 0.781540, 0.722992, 0.664443, 0.605894, 0.547345, 0.488796, 0.430248, 0.371699, 0.313150, 0.254601, 1.796052, 1.737504, 1.678955, 1.620406, 1.561857, 1.503308, 1.444760, 1.386211, 1.327662, 1.269113, 1.210564, 1.152016, 1.093467, 1.034918, 0.976369, 0.917820, 0.859272, 0.800723, 0.742174, 0.683625, 0.625076, 0.566528, 0.507979, 0.449430, 0.390881, 0.332332, 0.273784, 0.215235, 1.756686, 1.698137, 1.639588, 1.581040, 1.522491, 1.463942, 1.405393, 1.346844, 1.288296, 1.229747, 1.171198, 1.112649, 1.054100, 0.995552, 0.937003, 0.878454, 0.819905, 0.761356, 0.702808, 0.644259, 0.585710, 0.527161, 0.468612, 0.410064, 0.351515, 0.292966, 0.234417, 1.775868, 1.717320, 1.658771, 1.600222, 1.541673, 1.483124, 1.424576, 1.366027, 1.307478, 1.248929, 1.190380, 1.131832, 1.073283, 1.014734, 0.956185, 0.897636, 0.839088, 0.780539, 0.721990, 0.663441, 0.604892, 0.546344, 0.487795, 0.429246, 0.370697, 0.312148, 0.253600, 1.795051, 1.736502, 1.677953, 1.619404, 1.560856, 1.502307, 1.443758, 1.385209, 1.326660, 1.268112, 1.209563, 1.151014, 1.092465, 1.033916, 0.975368, 0.916819, 0.858270, 0.799721, 0.741172, 0.682624, 0.624075, 0.565526, 0.506977, 0.448428, 0.389880, 0.331331, 0.272782, 0.214233, 1.755684, 1.697136, 1.638587, 1.580038, 1.521489, 1.462940, 1.404392, 1.345843, 1.287294, 1.228745, 1.170196, 1.111648, 1.053099, 0.994550, 0.936001, 0.877452, 0.818904, 0.760355, 0.701806, 0.643257, 0.584708, 0.526160, 0.467611, 0.409062, 0.350513, 0.291964, 0.233416, 1.774867, 1.716318, 1.657769, 1.599220, 1.540672, 1.482123, 1.423574, 1.365025, 1.306476, 1.247928, 1.189379, 1.130830, 1.072281, 1.013732, 0.955184, 0.896635, 0.838086, 0.779537, 0.720988, 0.662440, 0.603891, 0.545342, 0.486793, 0.428244, 0.369696, 0.311147, 0.252598, 1.794049, 1.735500, 1.676952, 1.618403, 1.559854, 1.501305, 1.442756, 1.384208, 1.325659, 1.267110, 1.208561, 1.150012, 1.091464, 1.032915, 0.974366, 0.915817, 0.857268, 0.798720, 0.740171, 0.681622, 0.623073, 0.564524, 0.505976, 0.447427, 0.388878, 0.330329, 0.271780, 0.213232, 1.754683, 1.696134, 1.637585, 1.579036, 1.520488, 1.461939, 1.403390, 1.344841, 1.286292, 1.227744, 1.169195, 1.110646, 1.052097, 0.993548, 0.935000, 0.876451, 0.817902, 0.759353, 0.700804, 0.642256, 0.583707, 0.525158, 0.466609, 0.408060, 0.349512, 0.290963, 0.232414, 1.773865, 1.715316, 1.656768, 1.598219, 1.539670, 1.481121, 1.422572, 1.364024, 1.305475, 1.246926, 1.188377, 1.129828, 1.071280, 1.012731, 0.954182, 0.895633, 0.837084, 0.778536, 0.719987, 0.661438, 0.602889, 0.544340, 0.485792, 0.427243, 0.368694, 0.310145, 0.251596, 1.793048, 1.734499, 1.675950, 1.617401, 1.558852, 1.500304, 1.441755, 1.383206, 1.324657, 1.266108, 1.207560, 1.149011, 1.090462, 1.031913, 0.973364, 0.914816, 0.856267, 0.797718, 0.739169, 0.680620, 0.622072, 0.563523, 0.504974, 0.446425, 0.387876, 0.329328, 0.270779, 0.212230, 1.753681, 1.695132, 1.636584, 1.578035, 1.519486, 1.460937, 1.402388, 1.343840, 1.285291, 1.226742, 1.168193, 1.109644, 1.051096, 0.992547, 0.933998, 0.875449, 0.816900, 0.758352, 0.699803, 0.641254, 0.582705, 0.524156, 0.465608, 0.407059, 0.348510, 0.289961, 0.231412, 1.772864, 1.714315, 1.655766, 1.597217, 1.538668, 1.480120, 1.421571, 1.363022, 1.304473, 1.245924, 1.187376, 1.128827, 1.070278, 1.011729, 0.953180, 0.894632, 0.836083, 0.777534, 0.718985, 0.660436, 0.601888, 0.543339, 0.484790, 0.426241, 0.367692, 0.309144, 0.250595, 1.792046, 1.733497, 1.674948, 1.616400, 1.557851, 1.499302, 1.440753, 1.382204, 1.323656, 1.265107, 1.206558, 1.148009, 1.089460, 1.030912, 0.972363, 0.913814, 0.855265, 0.796716, 0.738168, 0.679619, 0.621070, 0.562521, 0.503972, 0.445424, 0.386875, 0.328326, 0.269777, 0.211228, 1.752680, 1.694131, 1.635582, 1.577033, 1.518484, 1.459936, 1.401387, 1.342838, 1.284289, 1.225740, 1.167192, 1.108643, 1.050094, 0.991545, 0.932996, 0.874448, 0.815899, 0.757350, 0.698801, 0.640252, 0.581704, 0.523155, 0.464606, 0.406057, 0.347508, 0.288960, 0.230411, 1.771862, 1.713313, 1.654764, 1.596216, 1.537667, 1.479118, 1.420569, 1.362020, 1.303472, 1.244923, 1.186374, 1.127825, 1.069276, 1.010728, 0.952179, 0.893630, 0.835081, 0.776532, 0.717984, 0.659435, 0.600886, 0.542337, 0.483788, 0.425240, 0.366691, 0.308142, 0.249593, 1.791044, 1.732496, 1.673947, 1.615398, 1.556849, 1.498300, 1.439752, 1.381203, 1.322654, 1.264105, 1.205556, 1.147008, 1.088459, 1.029910, 0.971361, 0.912812, 0.854264, 0.795715, 0.737166, 0.678617, 0.620068, 0.561520, 0.502971, 0.444422, 0.385873, 0.327324, 0.268776, 0.210227, 1.751678, 1.693129, 1.634580, 1.576032, 1.517483, 1.458934, 1.400385, 1.341836, 1.283288, 1.224739, 1.166190, 1.107641, 1.049092, 0.990544, 0.931995, 0.873446, 0.814897, 0.756348, 0.697800, 0.639251, 0.580702, 0.522153, 0.463604, 0.405056, 0.346507, 0.287958, 0.229409, 1.770860, 1.712312, 1.653763, 1.595214, 1.536665, 1.478116, 1.419568, 1.361019, 1.302470, 1.243921, 1.185372, 1.126824, 1.068275, 1.009726, 0.951177, 0.892628, 0.834080, 0.775531, 0.716982, 0.658433, 0.599884, 0.541336, 0.482787, 0.424238, 0.365689, 0.307140, 0.248592, 1.790043, 1.731494, 1.672945, 1.614396, 1.555848, 1.497299, 1.438750, 1.380201, 1.321652, 1.263104, 1.204555, 1.146006, 1.087457, 1.028908, 0.970360, 0.911811, 0.853262, 0.794713, 0.736164, 0.677616, 0.619067, 0.560518, 0.501969, 0.443420, 0.384872, 0.326323, 0.267774, 0.209225, 1.750676, 1.692128, 1.633579, 1.575030, 1.516481, 1.457932, 1.399384, 1.340835, 1.282286, 1.223737, 1.165188, 1.106640, 1.048091, 0.989542, 0.930993, 0.872444, 0.813896, 0.755347, 0.696798, 0.638249, 0.579700, 0.521152, 0.462603, 0.404054, 0.345505, 0.286956, 0.228408, 1.769859, 1.711310, 1.652761, 1.594212, 1.535664, 1.477115, 1.418566, 1.360017, 1.301468, 1.242920, 1.184371, 1.125822, 1.067273, 1.008724, 0.950176, 0.891627, 0.833078, 0.774529, 0.715980, 0.657432, 0.598883, 0.540334, 0.481785, 0.423236, 0.364688, 0.306139, 0.247590, 1.789041, 1.730492, 1.671944, 1.613395, 1.554846, 1.496297, 1.437748, 1.379200, 1.320651, 1.262102, 1.203553, 1.145004, 1.086456, 1.027907, 0.969358, 0.910809, 0.852260, 0.793712, 0.735163, 0.676614, 0.618065, 0.559516, 0.500968]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.505843 0.447294 0.388745 0.330196 0.271648 0.213099 1.754550 1.696001 1.637452 1.578904 1.520355 1.461806 1.403257 1.344708 1.286160 1.227611 1.169062 1.110513 1.051964 0.993416 0.934867 0.876318 0.817769 0.759220 0.700672 0.642123 0.583574 0.525025 0.466476 0.407928 0.349379 0.290830 0.232281 1.773732 1.715184 1.656635 1.598086 1.539537 #[0.782459, 0.723910, 0.665361, 0.606812, 0.548264, 0.489715, 0.431166, 0.372617, 0.314068, 0.255520, 1.796971, 1.738422, 1.679873, 1.621324, 1.562776, 1.504227, 1.445678, 1.387129, 1.328580, 1.270032, 1.211483, 1.152934, 1.094385, 1.035836, 0.977288, 0.918739, 0.860190, 0.801641, 0.743092, 0.684544, 0.625995, 0.567446, 0.508897, 0.450348, 0.391800, 0.333251, 0.274702, 0.216153, 1.757604, 1.699056, 1.640507, 1.581958, 1.523409, 1.464860, 1.406312, 1.347763, 1.289214, 1.230665, 1.172116, 1.113568, 1.055019, 0.996470, 0.937921, 0.879372, 0.820824, 0.762275, 0.703726, 0.645177, 0.586628, 0.528080, 0.469531, 0.410982, 0.352433, 0.293884, 0.235336, 1.776787, 1.718238, 1.659689, 1.601140, 1.542592, 1.484043, 1.425494, 1.366945, 1.308396, 1.249848, 1.191299, 1.132750, 1.074201, 1.015652, 0.957104, 0.898555, 0.840006, 0.781457, 0.722908, 0.664360, 0.605811, 0.547262, 0.488713, 0.430164, 0.371616, 0.313067, 0.254518, 1.795969, 1.737420, 1.678872, 1.620323, 1.561774, 1.503225, 1.444676, 1.386128, 1.327579, 1.269030, 1.210481, 1.151932, 1.093384, 1.034835, 0.976286, 0.917737, 0.859188, 0.800640, 0.742091, 0.683542, 0.624993, 0.566444, 0.507896, 0.449347, 0.390798, 0.332249, 0.273700, 0.215152, 1.756603, 1.698054, 1.639505, 1.580956, 1.522408, 1.463859, 1.405310, 1.346761, 1.288212, 1.229664, 1.171115, 1.112566, 1.054017, 0.995468, 0.936920, 0.878371, 0.819822, 0.761273, 0.702724, 0.644176, 0.585627, 0.527078, 0.468529, 0.409980, 0.351432, 0.292883, 0.234334, 1.775785, 1.717236, 1.658688, 1.600139, 1.541590, 1.483041, 1.424492, 1.365944, 1.307395, 1.248846, 1.190297, 1.131748, 1.073200, 1.014651, 0.956102, 0.897553, 0.839004, 0.780456, 0.721907, 0.663358, 0.604809, 0.546260, 0.487712, 0.429163, 0.370614, 0.312065, 0.253516, 1.794968, 1.736419, 1.677870, 1.619321, 1.560772, 1.502224, 1.443675, 1.385126, 1.326577, 1.268028, 1.209480, 1.150931, 1.092382, 1.033833, 0.975284, 0.916736, 0.858187, 0.799638, 0.741089, 0.682540, 0.623992, 0.565443, 0.506894, 0.448345, 0.389796, 0.331248, 0.272699, 0.214150, 1.755601, 1.697052, 1.638504, 1.579955, 1.521406, 1.462857, 1.404308, 1.345760, 1.287211, 1.228662, 1.170113, 1.111564, 1.053016, 0.994467, 0.935918, 0.877369, 0.818820, 0.760272, 0.701723, 0.643174, 0.584625, 0.526076, 0.467528, 0.408979, 0.350430, 0.291881, 0.233332, 1.774784, 1.716235, 1.657686, 1.599137, 1.540588, 1.482040, 1.423491, 1.364942, 1.306393, 1.247844, 1.189296, 1.130747, 1.072198, 1.013649, 0.955100, 0.896552, 0.838003, 0.779454, 0.720905, 0.662356, 0.603808, 0.545259, 0.486710, 0.428161, 0.369612, 0.311064, 0.252515, 1.793966, 1.735417, 1.676868, 1.618320, 1.559771, 1.501222, 1.442673, 1.384124, 1.325576, 1.267027, 1.208478, 1.149929, 1.091380, 1.032832, 0.974283, 0.915734, 0.857185, 0.798636, 0.740088, 0.681539, 0.622990, 0.564441, 0.505892, 0.447344, 0.388795, 0.330246, 0.271697, 0.213148, 1.754600, 1.696051, 1.637502, 1.578953, 1.520404, 1.461856, 1.403307, 1.344758, 1.286209, 1.227660, 1.169112, 1.110563, 1.052014, 0.993465, 0.934916, 0.876368, 0.817819, 0.759270, 0.700721, 0.642172, 0.583624, 0.525075, 0.466526, 0.407977, 0.349428, 0.290880, 0.232331, 1.773782, 1.715233, 1.656684, 1.598136, 1.539587, 1.481038, 1.422489, 1.363940, 1.305392, 1.246843, 1.188294, 1.129745, 1.071196, 1.012648, 0.954099, 0.895550, 0.837001, 0.778452, 0.719904, 0.661355, 0.602806, 0.544257, 0.485708, 0.427160, 0.368611, 0.310062, 0.251513, 1.792964, 1.734416, 1.675867, 1.617318, 1.558769, 1.500220, 1.441672, 1.383123, 1.324574, 1.266025, 1.207476, 1.148928, 1.090379, 1.031830, 0.973281, 0.914732, 0.856184, 0.797635, 0.739086, 0.680537, 0.621988, 0.563440, 0.504891, 0.446342, 0.387793, 0.329244, 0.270696, 0.212147, 1.753598, 1.695049, 1.636500, 1.577952, 1.519403, 1.460854, 1.402305, 1.343756, 1.285208, 1.226659, 1.168110, 1.109561, 1.051012, 0.992464, 0.933915, 0.875366, 0.816817, 0.758268, 0.699720, 0.641171, 0.582622, 0.524073, 0.465524, 0.406976, 0.348427, 0.289878, 0.231329, 1.772780, 1.714232, 1.655683, 1.597134, 1.538585, 1.480036, 1.421488, 1.362939, 1.304390, 1.245841, 1.187292, 1.128744, 1.070195, 1.011646, 0.953097, 0.894548, 0.836000, 0.777451, 0.718902, 0.660353, 0.601804, 0.543256, 0.484707, 0.426158, 0.367609, 0.309060, 0.250512, 1.791963, 1.733414, 1.674865, 1.616316, 1.557768, 1.499219, 1.440670, 1.382121, 1.323572, 1.265024, 1.206475, 1.147926, 1.089377, 1.030828, 0.972280, 0.913731, 0.855182, 0.796633, 0.738084, 0.679536, 0.620987, 0.562438, 0.503889, 0.445340, 0.386792, 0.328243, 0.269694, 0.211145, 1.752596, 1.694048, 1.635499, 1.576950, 1.518401, 1.459852, 1.401304, 1.342755, 1.284206, 1.225657, 1.167108, 1.108560, 1.050011, 0.991462, 0.932913, 0.874364, 0.815816, 0.757267, 0.698718, 0.640169, 0.581620, 0.523072, 0.464523, 0.405974, 0.347425, 0.288876, 0.230328, 1.771779, 1.713230, 1.654681, 1.596132, 1.537584, 1.479035, 1.420486, 1.361937, 1.303388, 1.244840, 1.186291, 1.127742, 1.069193, 1.010644, 0.952096, 0.893547, 0.834998, 0.776449, 0.717900, 0.659352, 0.600803, 0.542254, 0.483705, 0.425156, 0.366608, 0.308059, 0.249510, 1.790961, 1.732412, 1.673864, 1.615315, 1.556766, 1.498217, 1.439668, 1.381120, 1.322571, 1.264022, 1.205473, 1.146924, 1.088376, 1.029827, 0.971278, 0.912729, 0.854180, 0.795632, 0.737083, 0.678534, 0.619985, 0.561436, 0.502888, 0.444339, 0.385790, 0.327241, 0.268692, 0.210144, 1.751595, 1.693046, 1.634497, 1.575948, 1.517400, 1.458851, 1.400302, 1.341753, 1.283204, 1.224656, 1.166107, 1.107558, 1.049009, 0.990460, 0.931912, 0.873363, 0.814814, 0.756265, 0.697716, 0.639168, 0.580619, 0.522070, 0.463521, 0.404972, 0.346424, 0.287875, 0.229326, 1.770777, 1.712228, 1.653680, 1.595131, 1.536582, 1.478033, 1.419484, 1.360936, 1.302387, 1.243838, 1.185289, 1.126740, 1.068192, 1.009643, 0.951094, 0.892545, 0.833996, 0.775448, 0.716899, 0.658350, 0.599801, 0.541252, 0.482704, 0.424155, 0.365606, 0.307057, 0.248508, 1.789960, 1.731411, 1.672862, 1.614313, 1.555764, 1.497216, 1.438667, 1.380118, 1.321569, 1.263020, 1.204472, 1.145923, 1.087374, 1.028825, 0.970276, 0.911728, 0.853179, 0.794630, 0.736081, 0.677532, 0.618984, 0.560435, 0.501886, 0.443337, 0.384788, 0.326240, 0.267691, 0.209142, 1.750593, 1.692044, 1.633496, 1.574947, 1.516398, 1.457849, 1.399300, 1.340752, 1.282203, 1.223654, 1.165105, 1.106556, 1.048008, 0.989459, 0.930910, 0.872361, 0.813812, 0.755264, 0.696715, 0.638166, 0.579617, 0.521068, 0.462520, 0.403971, 0.345422, 0.286873, 0.228324, 1.769776]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.774651 1.716102 1.657553 1.599004 1.540456 1.481907 1.423358 1.364809 1.306260 1.247712 1.189163 1.130614 1.072065 1.013516 0.954968 0.896419 0.837870 0.779321 0.720772 0.662224 0.603675 0.545126 0.486577 0.428028 0.369480 0.310931 0.252382 1.793833 1.735284 1.676736 1.618187 1.559638 1.501089 1.442540 1.383992 1.325443 1.266894 1.208345 #[0.451267, 0.392718, 0.334169, 0.275620, 0.217072, 1.758523, 1.699974, 1.641425, 1.582876, 1.524328, 1.465779, 1.407230, 1.348681, 1.290132, 1.231584, 1.173035, 1.114486, 1.055937, 0.997388, 0.938840, 0.880291, 0.821742, 0.763193, 0.704644, 0.646096, 0.587547, 0.528998, 0.470449, 0.411900, 0.353352, 0.294803, 0.236254, 1.777705, 1.719156, 1.660608, 1.602059, 1.543510, 1.484961, 1.426412, 1.367864, 1.309315, 1.250766, 1.192217, 1.133668, 1.075120, 1.016571, 0.958022, 0.899473, 0.840924, 0.782376, 0.723827, 0.665278, 0.606729, 0.548180, 0.489632, 0.431083, 0.372534, 0.313985, 0.255436, 1.796888, 1.738339, 1.679790, 1.621241, 1.562692, 1.504144, 1.445595, 1.387046, 1.328497, 1.269948, 1.211400, 1.152851, 1.094302, 1.035753, 0.977204, 0.918656, 0.860107, 0.801558, 0.743009, 0.684460, 0.625912, 0.567363, 0.508814, 0.450265, 0.391716, 0.333168, 0.274619, 0.216070, 1.757521, 1.698972, 1.640424, 1.581875, 1.523326, 1.464777, 1.406228, 1.347680, 1.289131, 1.230582, 1.172033, 1.113484, 1.054936, 0.996387, 0.937838, 0.879289, 0.820740, 0.762192, 0.703643, 0.645094, 0.586545, 0.527996, 0.469448, 0.410899, 0.352350, 0.293801, 0.235252, 1.776704, 1.718155, 1.659606, 1.601057, 1.542508, 1.483960, 1.425411, 1.366862, 1.308313, 1.249764, 1.191216, 1.132667, 1.074118, 1.015569, 0.957020, 0.898472, 0.839923, 0.781374, 0.722825, 0.664276, 0.605728, 0.547179, 0.488630, 0.430081, 0.371532, 0.312984, 0.254435, 1.795886, 1.737337, 1.678788, 1.620240, 1.561691, 1.503142, 1.444593, 1.386044, 1.327496, 1.268947, 1.210398, 1.151849, 1.093300, 1.034752, 0.976203, 0.917654, 0.859105, 0.800556, 0.742008, 0.683459, 0.624910, 0.566361, 0.507812, 0.449264, 0.390715, 0.332166, 0.273617, 0.215068, 1.756520, 1.697971, 1.639422, 1.580873, 1.522324, 1.463776, 1.405227, 1.346678, 1.288129, 1.229580, 1.171032, 1.112483, 1.053934, 0.995385, 0.936836, 0.878288, 0.819739, 0.761190, 0.702641, 0.644092, 0.585544, 0.526995, 0.468446, 0.409897, 0.351348, 0.292800, 0.234251, 1.775702, 1.717153, 1.658604, 1.600056, 1.541507, 1.482958, 1.424409, 1.365860, 1.307312, 1.248763, 1.190214, 1.131665, 1.073116, 1.014568, 0.956019, 0.897470, 0.838921, 0.780372, 0.721824, 0.663275, 0.604726, 0.546177, 0.487628, 0.429080, 0.370531, 0.311982, 0.253433, 1.794884, 1.736336, 1.677787, 1.619238, 1.560689, 1.502140, 1.443592, 1.385043, 1.326494, 1.267945, 1.209396, 1.150848, 1.092299, 1.033750, 0.975201, 0.916652, 0.858104, 0.799555, 0.741006, 0.682457, 0.623908, 0.565360, 0.506811, 0.448262, 0.389713, 0.331164, 0.272616, 0.214067, 1.755518, 1.696969, 1.638420, 1.579872, 1.521323, 1.462774, 1.404225, 1.345676, 1.287128, 1.228579, 1.170030, 1.111481, 1.052932, 0.994384, 0.935835, 0.877286, 0.818737, 0.760188, 0.701640, 0.643091, 0.584542, 0.525993, 0.467444, 0.408896, 0.350347, 0.291798, 0.233249, 1.774700, 1.716152, 1.657603, 1.599054, 1.540505, 1.481956, 1.423408, 1.364859, 1.306310, 1.247761, 1.189212, 1.130664, 1.072115, 1.013566, 0.955017, 0.896468, 0.837920, 0.779371, 0.720822, 0.662273, 0.603724, 0.545176, 0.486627, 0.428078, 0.369529, 0.310980, 0.252432, 1.793883, 1.735334, 1.676785, 1.618236, 1.559688, 1.501139, 1.442590, 1.384041, 1.325492, 1.266944, 1.208395, 1.149846, 1.091297, 1.032748, 0.974200, 0.915651, 0.857102, 0.798553, 0.740004, 0.681456, 0.622907, 0.564358, 0.505809, 0.447260, 0.388712, 0.330163, 0.271614, 0.213065, 1.754516, 1.695968, 1.637419, 1.578870, 1.520321, 1.461772, 1.403224, 1.344675, 1.286126, 1.227577, 1.169028, 1.110480, 1.051931, 0.993382, 0.934833, 0.876284, 0.817736, 0.759187, 0.700638, 0.642089, 0.583540, 0.524992, 0.466443, 0.407894, 0.349345, 0.290796, 0.232248, 1.773699, 1.715150, 1.656601, 1.598052, 1.539504, 1.480955, 1.422406, 1.363857, 1.305308, 1.246760, 1.188211, 1.129662, 1.071113, 1.012564, 0.954016, 0.895467, 0.836918, 0.778369, 0.719820, 0.661272, 0.602723, 0.544174, 0.485625, 0.427076, 0.368528, 0.309979, 0.251430, 1.792881, 1.734332, 1.675784, 1.617235, 1.558686, 1.500137, 1.441588, 1.383040, 1.324491, 1.265942, 1.207393, 1.148844, 1.090296, 1.031747, 0.973198, 0.914649, 0.856100, 0.797552, 0.739003, 0.680454, 0.621905, 0.563356, 0.504808, 0.446259, 0.387710, 0.329161, 0.270612, 0.212064, 1.753515, 1.694966, 1.636417, 1.577868, 1.519320, 1.460771, 1.402222, 1.343673, 1.285124, 1.226576, 1.168027, 1.109478, 1.050929, 0.992380, 0.933832, 0.875283, 0.816734, 0.758185, 0.699636, 0.641088, 0.582539, 0.523990, 0.465441, 0.406892, 0.348344, 0.289795, 0.231246, 1.772697, 1.714148, 1.655600, 1.597051, 1.538502, 1.479953, 1.421404, 1.362856, 1.304307, 1.245758, 1.187209, 1.128660, 1.070112, 1.011563, 0.953014, 0.894465, 0.835916, 0.777368, 0.718819, 0.660270, 0.601721, 0.543172, 0.484624, 0.426075, 0.367526, 0.308977, 0.250428, 1.791880, 1.733331, 1.674782, 1.616233, 1.557684, 1.499136, 1.440587, 1.382038, 1.323489, 1.264940, 1.206392, 1.147843, 1.089294, 1.030745, 0.972196, 0.913648, 0.855099, 0.796550, 0.738001, 0.679452, 0.620904, 0.562355, 0.503806, 0.445257, 0.386708, 0.328160, 0.269611, 0.211062, 1.752513, 1.693964, 1.635416, 1.576867, 1.518318, 1.459769, 1.401220, 1.342672, 1.284123, 1.225574, 1.167025, 1.108476, 1.049928, 0.991379, 0.932830, 0.874281, 0.815732, 0.757184, 0.698635, 0.640086, 0.581537, 0.522988, 0.464440, 0.405891, 0.347342, 0.288793, 0.230244, 1.771696, 1.713147, 1.654598, 1.596049, 1.537500, 1.478952, 1.420403, 1.361854, 1.303305, 1.244756, 1.186208, 1.127659, 1.069110, 1.010561, 0.952012, 0.893464, 0.834915, 0.776366, 0.717817, 0.659268, 0.600720, 0.542171, 0.483622, 0.425073, 0.366524, 0.307976, 0.249427, 1.790878, 1.732329, 1.673780, 1.615232, 1.556683, 1.498134, 1.439585, 1.381036, 1.322488, 1.263939, 1.205390, 1.146841, 1.088292, 1.029744, 0.971195, 0.912646, 0.854097, 0.795548, 0.737000, 0.678451, 0.619902, 0.561353, 0.502804, 0.444256, 0.385707, 0.327158, 0.268609, 0.210060, 1.751512, 1.692963, 1.634414, 1.575865, 1.517316, 1.458768, 1.400219, 1.341670, 1.283121, 1.224572, 1.166024, 1.107475, 1.048926, 0.990377, 0.931828, 0.873280, 0.814731, 0.756182, 0.697633, 0.639084, 0.580536, 0.521987, 0.463438, 0.404889, 0.346340, 0.287792, 0.229243, 1.770694, 1.712145, 1.653596, 1.595048, 1.536499, 1.477950, 1.419401, 1.360852, 1.302304, 1.243755, 1.185206, 1.126657, 1.068108, 1.009560, 0.951011, 0.892462, 0.833913, 0.775364, 0.716816, 0.658267, 0.599718, 0.541169, 0.482620, 0.424072, 0.365523, 0.306974, 0.248425, 1.789876, 1.731328, 1.672779, 1.614230, 1.555681, 1.497132, 1.438584]))

def check_hashemiEnv_oil_le (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dr : Array Float) : Bool :=
  let v688 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v700 := ((1.22 : Float) * (0.8 : Float))
  let v701 := ((0.34 : Float) * v688)
  let v704 := ((3.141592653589793 : Float) / (2 : Float))
  let v711 := (if (v700 <= v701) then v704 else (Float.atan ((((1.22 : Float) * v688) + ((0.34 : Float) * (0.8 : Float))) / (v700 - v701))))
  let v712 := (-(1.22 : Float))
  let v713 := (-(0.8 : Float))
  let v715 := (Float.cos (0 : Float))
  let v717 := (-v688)
  let v718 := (Float.sin (0 : Float))
  let v721 := (-v713)
  let v730 := (Float.sqrt (((((v713 * v715) + (v717 * v718)) - v712) ^ 2) + ((((v721 * v718) + (v717 * v715)) - (0.34 : Float)) ^ 2)))
  let v731 := (Float.cos v711)
  let v733 := (Float.sin v711)
  let v744 := (Float.sqrt (((((v713 * v731) + (v717 * v733)) - v712) ^ 2) + ((((v721 * v733) + (v717 * v731)) - (0.34 : Float)) ^ 2)))
  let v745 := (Float.cos t)
  let v747 := (Float.sin t)
  let v749 := ((v713 * v745) + (v717 * v747))
  let v752 := ((v721 * v747) + (v717 * v745))
  let v758 := (Float.sqrt (((v749 - v712) ^ 2) + ((v752 - (0.34 : Float)) ^ 2)))
  let v760 := (omegad * rDrum)
  let v762 := ((v758 + slack) - (v760 * dt))
  let v763 := (v762 < v744)
  let v764 := (v730 < v762)
  let v766 := (if v763 then v744 else (if v764 then v730 else v762))
  let v771 := (((0 : Float) + v711) / (2 : Float))
  let v772 := (Float.cos v771)
  let v774 := (Float.sin v771)
  let v786 := (v766 < (Float.sqrt (((((v713 * v772) + (v717 * v774)) - v712) ^ 2) + ((((v721 * v774) + (v717 * v772)) - (0.34 : Float)) ^ 2))))
  let v787 := (if v786 then v771 else (0 : Float))
  let v788 := (if v786 then v711 else v771)
  let v790 := ((v787 + v788) / (2 : Float))
  let v791 := (Float.cos v790)
  let v793 := (Float.sin v790)
  let v805 := (v766 < (Float.sqrt (((((v713 * v791) + (v717 * v793)) - v712) ^ 2) + ((((v721 * v793) + (v717 * v791)) - (0.34 : Float)) ^ 2))))
  let v806 := (if v805 then v790 else v787)
  let v807 := (if v805 then v788 else v790)
  let v809 := ((v806 + v807) / (2 : Float))
  let v810 := (Float.cos v809)
  let v812 := (Float.sin v809)
  let v824 := (v766 < (Float.sqrt (((((v713 * v810) + (v717 * v812)) - v712) ^ 2) + ((((v721 * v812) + (v717 * v810)) - (0.34 : Float)) ^ 2))))
  let v825 := (if v824 then v809 else v806)
  let v826 := (if v824 then v807 else v809)
  let v828 := ((v825 + v826) / (2 : Float))
  let v829 := (Float.cos v828)
  let v831 := (Float.sin v828)
  let v843 := (v766 < (Float.sqrt (((((v713 * v829) + (v717 * v831)) - v712) ^ 2) + ((((v721 * v831) + (v717 * v829)) - (0.34 : Float)) ^ 2))))
  let v844 := (if v843 then v828 else v825)
  let v845 := (if v843 then v826 else v828)
  let v847 := ((v844 + v845) / (2 : Float))
  let v848 := (Float.cos v847)
  let v850 := (Float.sin v847)
  let v862 := (v766 < (Float.sqrt (((((v713 * v848) + (v717 * v850)) - v712) ^ 2) + ((((v721 * v850) + (v717 * v848)) - (0.34 : Float)) ^ 2))))
  let v863 := (if v862 then v847 else v844)
  let v864 := (if v862 then v845 else v847)
  let v866 := ((v863 + v864) / (2 : Float))
  let v867 := (Float.cos v866)
  let v869 := (Float.sin v866)
  let v881 := (v766 < (Float.sqrt (((((v713 * v867) + (v717 * v869)) - v712) ^ 2) + ((((v721 * v869) + (v717 * v867)) - (0.34 : Float)) ^ 2))))
  let v882 := (if v881 then v866 else v863)
  let v883 := (if v881 then v864 else v866)
  let v885 := ((v882 + v883) / (2 : Float))
  let v886 := (Float.cos v885)
  let v888 := (Float.sin v885)
  let v900 := (v766 < (Float.sqrt (((((v713 * v886) + (v717 * v888)) - v712) ^ 2) + ((((v721 * v888) + (v717 * v886)) - (0.34 : Float)) ^ 2))))
  let v901 := (if v900 then v885 else v882)
  let v902 := (if v900 then v883 else v885)
  let v904 := ((v901 + v902) / (2 : Float))
  let v905 := (Float.cos v904)
  let v907 := (Float.sin v904)
  let v919 := (v766 < (Float.sqrt (((((v713 * v905) + (v717 * v907)) - v712) ^ 2) + ((((v721 * v907) + (v717 * v905)) - (0.34 : Float)) ^ 2))))
  let v920 := (if v919 then v904 else v901)
  let v921 := (if v919 then v902 else v904)
  let v923 := ((v920 + v921) / (2 : Float))
  let v924 := (Float.cos v923)
  let v926 := (Float.sin v923)
  let v938 := (v766 < (Float.sqrt (((((v713 * v924) + (v717 * v926)) - v712) ^ 2) + ((((v721 * v926) + (v717 * v924)) - (0.34 : Float)) ^ 2))))
  let v939 := (if v938 then v923 else v920)
  let v940 := (if v938 then v921 else v923)
  let v942 := ((v939 + v940) / (2 : Float))
  let v943 := (Float.cos v942)
  let v945 := (Float.sin v942)
  let v957 := (v766 < (Float.sqrt (((((v713 * v943) + (v717 * v945)) - v712) ^ 2) + ((((v721 * v945) + (v717 * v943)) - (0.34 : Float)) ^ 2))))
  let v958 := (if v957 then v942 else v939)
  let v959 := (if v957 then v940 else v942)
  let v961 := ((v958 + v959) / (2 : Float))
  let v962 := (Float.cos v961)
  let v964 := (Float.sin v961)
  let v976 := (v766 < (Float.sqrt (((((v713 * v962) + (v717 * v964)) - v712) ^ 2) + ((((v721 * v964) + (v717 * v962)) - (0.34 : Float)) ^ 2))))
  let v977 := (if v976 then v961 else v958)
  let v978 := (if v976 then v959 else v961)
  let v980 := ((v977 + v978) / (2 : Float))
  let v981 := (Float.cos v980)
  let v983 := (Float.sin v980)
  let v995 := (v766 < (Float.sqrt (((((v713 * v981) + (v717 * v983)) - v712) ^ 2) + ((((v721 * v983) + (v717 * v981)) - (0.34 : Float)) ^ 2))))
  let v996 := (if v995 then v980 else v977)
  let v997 := (if v995 then v978 else v980)
  let v999 := ((v996 + v997) / (2 : Float))
  let v1000 := (Float.cos v999)
  let v1002 := (Float.sin v999)
  let v1014 := (v766 < (Float.sqrt (((((v713 * v1000) + (v717 * v1002)) - v712) ^ 2) + ((((v721 * v1002) + (v717 * v1000)) - (0.34 : Float)) ^ 2))))
  let v1015 := (if v1014 then v999 else v996)
  let v1016 := (if v1014 then v997 else v999)
  let v1018 := ((v1015 + v1016) / (2 : Float))
  let v1019 := (Float.cos v1018)
  let v1021 := (Float.sin v1018)
  let v1033 := (v766 < (Float.sqrt (((((v713 * v1019) + (v717 * v1021)) - v712) ^ 2) + ((((v721 * v1021) + (v717 * v1019)) - (0.34 : Float)) ^ 2))))
  let v1034 := (if v1033 then v1018 else v1015)
  let v1035 := (if v1033 then v1016 else v1018)
  let v1037 := ((v1034 + v1035) / (2 : Float))
  let v1038 := (Float.cos v1037)
  let v1040 := (Float.sin v1037)
  let v1052 := (v766 < (Float.sqrt (((((v713 * v1038) + (v717 * v1040)) - v712) ^ 2) + ((((v721 * v1040) + (v717 * v1038)) - (0.34 : Float)) ^ 2))))
  let v1053 := (if v1052 then v1037 else v1034)
  let v1054 := (if v1052 then v1035 else v1037)
  let v1056 := ((v1053 + v1054) / (2 : Float))
  let v1057 := (Float.cos v1056)
  let v1059 := (Float.sin v1056)
  let v1071 := (v766 < (Float.sqrt (((((v713 * v1057) + (v717 * v1059)) - v712) ^ 2) + ((((v721 * v1059) + (v717 * v1057)) - (0.34 : Float)) ^ 2))))
  let v1072 := (if v1071 then v1056 else v1053)
  let v1073 := (if v1071 then v1054 else v1056)
  let v1075 := ((v1072 + v1073) / (2 : Float))
  let v1076 := (Float.cos v1075)
  let v1078 := (Float.sin v1075)
  let v1090 := (v766 < (Float.sqrt (((((v713 * v1076) + (v717 * v1078)) - v712) ^ 2) + ((((v721 * v1078) + (v717 * v1076)) - (0.34 : Float)) ^ 2))))
  let v1091 := (if v1090 then v1075 else v1072)
  let v1092 := (if v1090 then v1073 else v1075)
  let v1094 := ((v1091 + v1092) / (2 : Float))
  let v1095 := (Float.cos v1094)
  let v1097 := (Float.sin v1094)
  let v1109 := (v766 < (Float.sqrt (((((v713 * v1095) + (v717 * v1097)) - v712) ^ 2) + ((((v721 * v1097) + (v717 * v1095)) - (0.34 : Float)) ^ 2))))
  let v1110 := (if v1109 then v1094 else v1091)
  let v1111 := (if v1109 then v1092 else v1094)
  let v1113 := ((v1110 + v1111) / (2 : Float))
  let v1114 := (Float.cos v1113)
  let v1116 := (Float.sin v1113)
  let v1128 := (v766 < (Float.sqrt (((((v713 * v1114) + (v717 * v1116)) - v712) ^ 2) + ((((v721 * v1116) + (v717 * v1114)) - (0.34 : Float)) ^ 2))))
  let v1129 := (if v1128 then v1113 else v1110)
  let v1130 := (if v1128 then v1111 else v1113)
  let v1132 := ((v1129 + v1130) / (2 : Float))
  let v1133 := (Float.cos v1132)
  let v1135 := (Float.sin v1132)
  let v1147 := (v766 < (Float.sqrt (((((v713 * v1133) + (v717 * v1135)) - v712) ^ 2) + ((((v721 * v1135) + (v717 * v1133)) - (0.34 : Float)) ^ 2))))
  let v1148 := (if v1147 then v1132 else v1129)
  let v1149 := (if v1147 then v1130 else v1132)
  let v1151 := ((v1148 + v1149) / (2 : Float))
  let v1152 := (Float.cos v1151)
  let v1154 := (Float.sin v1151)
  let v1166 := (v766 < (Float.sqrt (((((v713 * v1152) + (v717 * v1154)) - v712) ^ 2) + ((((v721 * v1154) + (v717 * v1152)) - (0.34 : Float)) ^ 2))))
  let v1167 := (if v1166 then v1151 else v1148)
  let v1168 := (if v1166 then v1149 else v1151)
  let v1170 := ((v1167 + v1168) / (2 : Float))
  let v1171 := (Float.cos v1170)
  let v1173 := (Float.sin v1170)
  let v1185 := (v766 < (Float.sqrt (((((v713 * v1171) + (v717 * v1173)) - v712) ^ 2) + ((((v721 * v1173) + (v717 * v1171)) - (0.34 : Float)) ^ 2))))
  let v1186 := (if v1185 then v1170 else v1167)
  let v1187 := (if v1185 then v1168 else v1170)
  let v1189 := ((v1186 + v1187) / (2 : Float))
  let v1190 := (Float.cos v1189)
  let v1192 := (Float.sin v1189)
  let v1204 := (v766 < (Float.sqrt (((((v713 * v1190) + (v717 * v1192)) - v712) ^ 2) + ((((v721 * v1192) + (v717 * v1190)) - (0.34 : Float)) ^ 2))))
  let v1205 := (if v1204 then v1189 else v1186)
  let v1206 := (if v1204 then v1187 else v1189)
  let v1208 := ((v1205 + v1206) / (2 : Float))
  let v1209 := (Float.cos v1208)
  let v1211 := (Float.sin v1208)
  let v1223 := (v766 < (Float.sqrt (((((v713 * v1209) + (v717 * v1211)) - v712) ^ 2) + ((((v721 * v1211) + (v717 * v1209)) - (0.34 : Float)) ^ 2))))
  let v1228 := (if (v730 <= v762) then (0 : Float) else (((if v1223 then v1208 else v1205) + (if v1223 then v1206 else v1208)) / (2 : Float)))
  let v1229 := (W * rcm)
  let v1230 := (Float.cos v1228)
  let v1232 := (Float.sin v1228)
  let v1234 := ((v713 * v1230) + (v717 * v1232))
  let v1237 := ((v721 * v1232) + (v717 * v1230))
  let v1252 := ((t < v1228) && (!(v1229 <= (Tmax * (((v712 * v1237) - ((0.34 : Float) * v1234)) / (Float.sqrt (((v1234 - v712) ^ 2) + ((v1237 - (0.34 : Float)) ^ 2))))))))
  let v1253 := (if v1252 then t else v1228)
  let v1258 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1263 := (Float.cos v1253)
  let v1265 := (Float.sin v1253)
  let v1293 := (Float.cos elSun)
  let v1295 := (v1293 * (Float.cos azSun))
  let v1297 := (v1293 * (Float.sin azSun))
  let v1298 := (Float.sin elSun)
  let v1345 := (Float.cos v1258)
  let v1346 := (v1265 * v1345)
  let v1347 := (Float.sin v1258)
  let v1348 := (v1265 * v1347)
  let v1349 := (v1263 * v1345)
  let v1350 := (v1263 * v1347)
  let v1351 := (-v1265)
  let v1376 := ((2 : Float) * a)
  let v1377 := (v1376 / w)
  let v1379 := (w / (2 : Float))
  let v1380 := ((-a) + v1379)
  let v1399 := ((1 : Float) / (2 : Float))
  let v1404 := (-(((((v1350 * v1263) - (v1351 * v1348)) * v1295) + (((v1351 * v1346) - (v1349 * v1263)) * v1297)) + (((v1349 * v1348) - (v1350 * v1346)) * v1298)))
  let v1405 := (-(((v1349 * v1295) + (v1350 * v1297)) + (v1351 * v1298)))
  let v1406 := (-(((v1346 * v1295) + (v1348 * v1297)) + (v1263 * v1298)))
  let v1411 := ((Float.abs v1406) < ((9 : Float) / (10 : Float)))
  let v1412 := (if v1411 then (0 : Float) else (1 : Float))
  let v1413 := (if v1411 then (1 : Float) else (0 : Float))
  let v1416 := ((v1405 * v1413) - (v1406 * (0 : Float)))
  let v1419 := ((v1406 * v1412) - (v1404 * v1413))
  let v1422 := ((v1404 * (0 : Float)) - (v1405 * v1412))
  let v1430 := (Float.sqrt (max (((v1416 ^ 2) + (v1419 ^ 2)) + (v1422 ^ 2)) (0.000000000000000001 : Float)))
  let v1431 := (v1416 / v1430)
  let v1432 := (v1419 / v1430)
  let v1433 := (v1422 / v1430)
  let v1482 := ((2 : Float) * f)
  let v1483 := ((1 : Float) / R)
  let v1593 := ((v1376 ^ 2) * rho)
  let v1599 := ((List.range 64).foldl (fun acc i => acc + (let v1394 := (v1380 + (w * (Float.floor (dr[i * 10 + 0]! * v1377)))); let v1398 := (v1380 + (w * (Float.floor (dr[i * 10 + 1]! * v1377)))); let v1401 := ((dr[i * 10 + 2]! - v1399) * w); let v1403 := ((dr[i * 10 + 3]! - v1399) * w); let v1444 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1446 := (((2 : Float) * (3.141592653589793 : Float)) * dr[i * 10 + 5]!); let v1447 := (Float.cos v1444); let v1449 := (Float.sin v1444); let v1450 := (Float.cos v1446); let v1452 := (Float.sin v1446); let v1456 := ((v1447 * v1404) + (v1449 * ((v1450 * v1431) + (v1452 * ((v1405 * v1433) - (v1406 * v1432)))))); let v1462 := ((v1447 * v1405) + (v1449 * ((v1450 * v1432) + (v1452 * ((v1406 * v1431) - (v1404 * v1433)))))); let v1468 := ((v1447 * v1406) + (v1449 * ((v1450 * v1433) + (v1452 * ((v1404 * v1432) - (v1405 * v1431)))))); let v1479 := (((Float.abs v1394) <= a) && (((Float.abs v1398) <= a) && (((Float.abs v1401) <= v1379) && ((Float.abs v1403) <= v1379)))); let v1480 := (v1394 + v1401); let v1481 := (v1398 + v1403); let v1488 := (Float.sqrt (max ((v1394 ^ 2) + (v1398 ^ 2)) (0.000000000000000001 : Float))); let v1489 := (v1488 ^ 2); let v1495 := ((1 : Float) - ((((1 : Float) + k) * (v1483 ^ 2)) * v1489)); let v1503 := ((v1483 * v1488) / (Float.sqrt (max v1495 (0.000000000000000001 : Float)))); let v1506 := (Float.sqrt ((1 : Float) + (v1503 ^ 2))); let v1507 := (-v1503); let v1510 := (((v1507 * v1394) / v1488) / v1506); let v1513 := (((v1507 * v1398) / v1488) / v1506); let v1514 := ((1 : Float) / v1506); let v1516 := (v1510 + (sigmaslope * dr[i * 10 + 6]!)); let v1518 := (v1513 + (sigmaslope * dr[i * 10 + 7]!)); let v1524 := (Float.sqrt (((v1516 ^ 2) + (v1518 ^ 2)) + (v1514 ^ 2))); let v1525 := (v1516 / v1524); let v1526 := (v1518 / v1524); let v1527 := (v1514 / v1524); let v1541 := (((((v1394 - v1480) * v1510) + ((v1398 - v1481) * v1513)) + ((((v1483 * v1489) / ((1 : Float) + (Float.sqrt (max v1495 (0 : Float))))) - v1482) * v1514)) / (((v1456 * v1510) + (v1462 * v1513)) + (v1468 * v1514))); let v1553 := ((2 : Float) * (((v1456 * v1525) + (v1462 * v1526)) + (v1468 * v1527))); let v1559 := (v1468 - (v1553 * v1527)); let v1561 := ((v1456 - (v1553 * v1525)) + (sigmaspec * dr[i * 10 + 8]!)); let v1563 := ((v1462 - (v1553 * v1526)) + (sigmaspec * dr[i * 10 + 9]!)); let v1569 := (Float.sqrt (((v1561 ^ 2) + (v1563 ^ 2)) + (v1559 ^ 2))); let v1572 := (v1559 / v1569); let v1574 := ((f - (v1482 + (v1541 * v1468))) / v1572); let v1582 := (Float.sqrt ((((v1480 + (v1541 * v1456)) + (v1574 * (v1561 / v1569))) ^ 2) + (((v1481 + (v1541 * v1462)) + (v1574 * (v1563 / v1569))) ^ 2))); let v1584 := ((0 : Float) < v1572); let v1585 := ((v1582 <= rc) && v1584); let v1587 := (if (v1479 && v1585) then (1 : Float) else (0 : Float)); v1587)) 0.0)
  let v1616 := (Toil - Ta)
  ((min ToilMax (Toil + ((dt * ((((alpha * (((v1593 * (v1599 / (64 : Float))) * dni) * soil)) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v1616))) - (Upipe * v1616)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))) <= ToilMax)

#eval IO.println ("check_hashemiEnv_oil_le " ++ toString (check_hashemiEnv_oil_le 0.650883 0.592334 0.533785 0.475236 0.416688 0.358139 0.299590 0.241041 1.782492 1.723944 1.665395 1.606846 1.548297 1.489748 1.431200 1.372651 1.314102 1.255553 1.197004 1.138456 1.079907 1.021358 0.962809 0.904260 0.845712 0.787163 0.728614 0.670065 0.611516 0.552968 0.494419 0.435870 0.377321 0.318772 0.260224 0.201675 1.743126 1.684577 #[0.927499, 0.868950, 0.810401, 0.751852, 0.693304, 0.634755, 0.576206, 0.517657, 0.459108, 0.400560, 0.342011, 0.283462, 0.224913, 1.766364, 1.707816, 1.649267, 1.590718, 1.532169, 1.473620, 1.415072, 1.356523, 1.297974, 1.239425, 1.180876, 1.122328, 1.063779, 1.005230, 0.946681, 0.888132, 0.829584, 0.771035, 0.712486, 0.653937, 0.595388, 0.536840, 0.478291, 0.419742, 0.361193, 0.302644, 0.244096, 1.785547, 1.726998, 1.668449, 1.609900, 1.551352, 1.492803, 1.434254, 1.375705, 1.317156, 1.258608, 1.200059, 1.141510, 1.082961, 1.024412, 0.965864, 0.907315, 0.848766, 0.790217, 0.731668, 0.673120, 0.614571, 0.556022, 0.497473, 0.438924, 0.380376, 0.321827, 0.263278, 0.204729, 1.746180, 1.687632, 1.629083, 1.570534, 1.511985, 1.453436, 1.394888, 1.336339, 1.277790, 1.219241, 1.160692, 1.102144, 1.043595, 0.985046, 0.926497, 0.867948, 0.809400, 0.750851, 0.692302, 0.633753, 0.575204, 0.516656, 0.458107, 0.399558, 0.341009, 0.282460, 0.223912, 1.765363, 1.706814, 1.648265, 1.589716, 1.531168, 1.472619, 1.414070, 1.355521, 1.296972, 1.238424, 1.179875, 1.121326, 1.062777, 1.004228, 0.945680, 0.887131, 0.828582, 0.770033, 0.711484, 0.652936, 0.594387, 0.535838, 0.477289, 0.418740, 0.360192, 0.301643, 0.243094, 1.784545, 1.725996, 1.667448, 1.608899, 1.550350, 1.491801, 1.433252, 1.374704, 1.316155, 1.257606, 1.199057, 1.140508, 1.081960, 1.023411, 0.964862, 0.906313, 0.847764, 0.789216, 0.730667, 0.672118, 0.613569, 0.555020, 0.496472, 0.437923, 0.379374, 0.320825, 0.262276, 0.203728, 1.745179, 1.686630, 1.628081, 1.569532, 1.510984, 1.452435, 1.393886, 1.335337, 1.276788, 1.218240, 1.159691, 1.101142, 1.042593, 0.984044, 0.925496, 0.866947, 0.808398, 0.749849, 0.691300, 0.632752, 0.574203, 0.515654, 0.457105, 0.398556, 0.340008, 0.281459, 0.222910, 1.764361, 1.705812, 1.647264, 1.588715, 1.530166, 1.471617, 1.413068, 1.354520, 1.295971, 1.237422, 1.178873, 1.120324, 1.061776, 1.003227, 0.944678, 0.886129, 0.827580, 0.769032, 0.710483, 0.651934, 0.593385, 0.534836, 0.476288, 0.417739, 0.359190, 0.300641, 0.242092, 1.783544, 1.724995, 1.666446, 1.607897, 1.549348, 1.490800, 1.432251, 1.373702, 1.315153, 1.256604, 1.198056, 1.139507, 1.080958, 1.022409, 0.963860, 0.905312, 0.846763, 0.788214, 0.729665, 0.671116, 0.612568, 0.554019, 0.495470, 0.436921, 0.378372, 0.319824, 0.261275, 0.202726, 1.744177, 1.685628, 1.627080, 1.568531, 1.509982, 1.451433, 1.392884, 1.334336, 1.275787, 1.217238, 1.158689, 1.100140, 1.041592, 0.983043, 0.924494, 0.865945, 0.807396, 0.748848, 0.690299, 0.631750, 0.573201, 0.514652, 0.456104, 0.397555, 0.339006, 0.280457, 0.221908, 1.763360, 1.704811, 1.646262, 1.587713, 1.529164, 1.470616, 1.412067, 1.353518, 1.294969, 1.236420, 1.177872, 1.119323, 1.060774, 1.002225, 0.943676, 0.885128, 0.826579, 0.768030, 0.709481, 0.650932, 0.592384, 0.533835, 0.475286, 0.416737, 0.358188, 0.299640, 0.241091, 1.782542, 1.723993, 1.665444, 1.606896, 1.548347, 1.489798, 1.431249, 1.372700, 1.314152, 1.255603, 1.197054, 1.138505, 1.079956, 1.021408, 0.962859, 0.904310, 0.845761, 0.787212, 0.728664, 0.670115, 0.611566, 0.553017, 0.494468, 0.435920, 0.377371, 0.318822, 0.260273, 0.201724, 1.743176, 1.684627, 1.626078, 1.567529, 1.508980, 1.450432, 1.391883, 1.333334, 1.274785, 1.216236, 1.157688, 1.099139, 1.040590, 0.982041, 0.923492, 0.864944, 0.806395, 0.747846, 0.689297, 0.630748, 0.572200, 0.513651, 0.455102, 0.396553, 0.338004, 0.279456, 0.220907, 1.762358, 1.703809, 1.645260, 1.586712, 1.528163, 1.469614, 1.411065, 1.352516, 1.293968, 1.235419, 1.176870, 1.118321, 1.059772, 1.001224, 0.942675, 0.884126, 0.825577, 0.767028, 0.708480, 0.649931, 0.591382, 0.532833, 0.474284, 0.415736, 0.357187, 0.298638, 0.240089, 1.781540, 1.722992, 1.664443, 1.605894, 1.547345, 1.488796, 1.430248, 1.371699, 1.313150, 1.254601, 1.196052, 1.137504, 1.078955, 1.020406, 0.961857, 0.903308, 0.844760, 0.786211, 0.727662, 0.669113, 0.610564, 0.552016, 0.493467, 0.434918, 0.376369, 0.317820, 0.259272, 0.200723, 1.742174, 1.683625, 1.625076, 1.566528, 1.507979, 1.449430, 1.390881, 1.332332, 1.273784, 1.215235, 1.156686, 1.098137, 1.039588, 0.981040, 0.922491, 0.863942, 0.805393, 0.746844, 0.688296, 0.629747, 0.571198, 0.512649, 0.454100, 0.395552, 0.337003, 0.278454, 0.219905, 1.761356, 1.702808, 1.644259, 1.585710, 1.527161, 1.468612, 1.410064, 1.351515, 1.292966, 1.234417, 1.175868, 1.117320, 1.058771, 1.000222, 0.941673, 0.883124, 0.824576, 0.766027, 0.707478, 0.648929, 0.590380, 0.531832, 0.473283, 0.414734, 0.356185, 0.297636, 0.239088, 1.780539, 1.721990, 1.663441, 1.604892, 1.546344, 1.487795, 1.429246, 1.370697, 1.312148, 1.253600, 1.195051, 1.136502, 1.077953, 1.019404, 0.960856, 0.902307, 0.843758, 0.785209, 0.726660, 0.668112, 0.609563, 0.551014, 0.492465, 0.433916, 0.375368, 0.316819, 0.258270, 1.799721, 1.741172, 1.682624, 1.624075, 1.565526, 1.506977, 1.448428, 1.389880, 1.331331, 1.272782, 1.214233, 1.155684, 1.097136, 1.038587, 0.980038, 0.921489, 0.862940, 0.804392, 0.745843, 0.687294, 0.628745, 0.570196, 0.511648, 0.453099, 0.394550, 0.336001, 0.277452, 0.218904, 1.760355, 1.701806, 1.643257, 1.584708, 1.526160, 1.467611, 1.409062, 1.350513, 1.291964, 1.233416, 1.174867, 1.116318, 1.057769, 0.999220, 0.940672, 0.882123, 0.823574, 0.765025, 0.706476, 0.647928, 0.589379, 0.530830, 0.472281, 0.413732, 0.355184, 0.296635, 0.238086, 1.779537, 1.720988, 1.662440, 1.603891, 1.545342, 1.486793, 1.428244, 1.369696, 1.311147, 1.252598, 1.194049, 1.135500, 1.076952, 1.018403, 0.959854, 0.901305, 0.842756, 0.784208, 0.725659, 0.667110, 0.608561, 0.550012, 0.491464, 0.432915, 0.374366, 0.315817, 0.257268, 1.798720, 1.740171, 1.681622, 1.623073, 1.564524, 1.505976, 1.447427, 1.388878, 1.330329, 1.271780, 1.213232, 1.154683, 1.096134, 1.037585, 0.979036, 0.920488, 0.861939, 0.803390, 0.744841, 0.686292, 0.627744, 0.569195, 0.510646, 0.452097, 0.393548, 0.335000, 0.276451, 0.217902, 1.759353, 1.700804, 1.642256, 1.583707, 1.525158, 1.466609, 1.408060, 1.349512, 1.290963, 1.232414, 1.173865, 1.115316, 1.056768, 0.998219, 0.939670, 0.881121, 0.822572, 0.764024, 0.705475, 0.646926, 0.588377, 0.529828, 0.471280, 0.412731, 0.354182, 0.295633, 0.237084, 1.778536, 1.719987, 1.661438, 1.602889, 1.544340, 1.485792, 1.427243, 1.368694, 1.310145, 1.251596, 1.193048, 1.134499, 1.075950, 1.017401, 0.958852, 0.900304, 0.841755, 0.783206, 0.724657, 0.666108, 0.607560, 0.549011, 0.490462, 0.431913, 0.373364, 0.314816]))
#eval IO.println ("check_hashemiEnv_oil_le " ++ toString (check_hashemiEnv_oil_le 0.319691 0.261142 0.202593 1.744044 1.685496 1.626947 1.568398 1.509849 1.451300 1.392752 1.334203 1.275654 1.217105 1.158556 1.100008 1.041459 0.982910 0.924361 0.865812 0.807264 0.748715 0.690166 0.631617 0.573068 0.514520 0.455971 0.397422 0.338873 0.280324 0.221776 1.763227 1.704678 1.646129 1.587580 1.529032 1.470483 1.411934 1.353385 #[0.596307, 0.537758, 0.479209, 0.420660, 0.362112, 0.303563, 0.245014, 1.786465, 1.727916, 1.669368, 1.610819, 1.552270, 1.493721, 1.435172, 1.376624, 1.318075, 1.259526, 1.200977, 1.142428, 1.083880, 1.025331, 0.966782, 0.908233, 0.849684, 0.791136, 0.732587, 0.674038, 0.615489, 0.556940, 0.498392, 0.439843, 0.381294, 0.322745, 0.264196, 0.205648, 1.747099, 1.688550, 1.630001, 1.571452, 1.512904, 1.454355, 1.395806, 1.337257, 1.278708, 1.220160, 1.161611, 1.103062, 1.044513, 0.985964, 0.927416, 0.868867, 0.810318, 0.751769, 0.693220, 0.634672, 0.576123, 0.517574, 0.459025, 0.400476, 0.341928, 0.283379, 0.224830, 1.766281, 1.707732, 1.649184, 1.590635, 1.532086, 1.473537, 1.414988, 1.356440, 1.297891, 1.239342, 1.180793, 1.122244, 1.063696, 1.005147, 0.946598, 0.888049, 0.829500, 0.770952, 0.712403, 0.653854, 0.595305, 0.536756, 0.478208, 0.419659, 0.361110, 0.302561, 0.244012, 1.785464, 1.726915, 1.668366, 1.609817, 1.551268, 1.492720, 1.434171, 1.375622, 1.317073, 1.258524, 1.199976, 1.141427, 1.082878, 1.024329, 0.965780, 0.907232, 0.848683, 0.790134, 0.731585, 0.673036, 0.614488, 0.555939, 0.497390, 0.438841, 0.380292, 0.321744, 0.263195, 0.204646, 1.746097, 1.687548, 1.629000, 1.570451, 1.511902, 1.453353, 1.394804, 1.336256, 1.277707, 1.219158, 1.160609, 1.102060, 1.043512, 0.984963, 0.926414, 0.867865, 0.809316, 0.750768, 0.692219, 0.633670, 0.575121, 0.516572, 0.458024, 0.399475, 0.340926, 0.282377, 0.223828, 1.765280, 1.706731, 1.648182, 1.589633, 1.531084, 1.472536, 1.413987, 1.355438, 1.296889, 1.238340, 1.179792, 1.121243, 1.062694, 1.004145, 0.945596, 0.887048, 0.828499, 0.769950, 0.711401, 0.652852, 0.594304, 0.535755, 0.477206, 0.418657, 0.360108, 0.301560, 0.243011, 1.784462, 1.725913, 1.667364, 1.608816, 1.550267, 1.491718, 1.433169, 1.374620, 1.316072, 1.257523, 1.198974, 1.140425, 1.081876, 1.023328, 0.964779, 0.906230, 0.847681, 0.789132, 0.730584, 0.672035, 0.613486, 0.554937, 0.496388, 0.437840, 0.379291, 0.320742, 0.262193, 0.203644, 1.745096, 1.686547, 1.627998, 1.569449, 1.510900, 1.452352, 1.393803, 1.335254, 1.276705, 1.218156, 1.159608, 1.101059, 1.042510, 0.983961, 0.925412, 0.866864, 0.808315, 0.749766, 0.691217, 0.632668, 0.574120, 0.515571, 0.457022, 0.398473, 0.339924, 0.281376, 0.222827, 1.764278, 1.705729, 1.647180, 1.588632, 1.530083, 1.471534, 1.412985, 1.354436, 1.295888, 1.237339, 1.178790, 1.120241, 1.061692, 1.003144, 0.944595, 0.886046, 0.827497, 0.768948, 0.710400, 0.651851, 0.593302, 0.534753, 0.476204, 0.417656, 0.359107, 0.300558, 0.242009, 1.783460, 1.724912, 1.666363, 1.607814, 1.549265, 1.490716, 1.432168, 1.373619, 1.315070, 1.256521, 1.197972, 1.139424, 1.080875, 1.022326, 0.963777, 0.905228, 0.846680, 0.788131, 0.729582, 0.671033, 0.612484, 0.553936, 0.495387, 0.436838, 0.378289, 0.319740, 0.261192, 0.202643, 1.744094, 1.685545, 1.626996, 1.568448, 1.509899, 1.451350, 1.392801, 1.334252, 1.275704, 1.217155, 1.158606, 1.100057, 1.041508, 0.982960, 0.924411, 0.865862, 0.807313, 0.748764, 0.690216, 0.631667, 0.573118, 0.514569, 0.456020, 0.397472, 0.338923, 0.280374, 0.221825, 1.763276, 1.704728, 1.646179, 1.587630, 1.529081, 1.470532, 1.411984, 1.353435, 1.294886, 1.236337, 1.177788, 1.119240, 1.060691, 1.002142, 0.943593, 0.885044, 0.826496, 0.767947, 0.709398, 0.650849, 0.592300, 0.533752, 0.475203, 0.416654, 0.358105, 0.299556, 0.241008, 1.782459, 1.723910, 1.665361, 1.606812, 1.548264, 1.489715, 1.431166, 1.372617, 1.314068, 1.255520, 1.196971, 1.138422, 1.079873, 1.021324, 0.962776, 0.904227, 0.845678, 0.787129, 0.728580, 0.670032, 0.611483, 0.552934, 0.494385, 0.435836, 0.377288, 0.318739, 0.260190, 0.201641, 1.743092, 1.684544, 1.625995, 1.567446, 1.508897, 1.450348, 1.391800, 1.333251, 1.274702, 1.216153, 1.157604, 1.099056, 1.040507, 0.981958, 0.923409, 0.864860, 0.806312, 0.747763, 0.689214, 0.630665, 0.572116, 0.513568, 0.455019, 0.396470, 0.337921, 0.279372, 0.220824, 1.762275, 1.703726, 1.645177, 1.586628, 1.528080, 1.469531, 1.410982, 1.352433, 1.293884, 1.235336, 1.176787, 1.118238, 1.059689, 1.001140, 0.942592, 0.884043, 0.825494, 0.766945, 0.708396, 0.649848, 0.591299, 0.532750, 0.474201, 0.415652, 0.357104, 0.298555, 0.240006, 1.781457, 1.722908, 1.664360, 1.605811, 1.547262, 1.488713, 1.430164, 1.371616, 1.313067, 1.254518, 1.195969, 1.137420, 1.078872, 1.020323, 0.961774, 0.903225, 0.844676, 0.786128, 0.727579, 0.669030, 0.610481, 0.551932, 0.493384, 0.434835, 0.376286, 0.317737, 0.259188, 0.200640, 1.742091, 1.683542, 1.624993, 1.566444, 1.507896, 1.449347, 1.390798, 1.332249, 1.273700, 1.215152, 1.156603, 1.098054, 1.039505, 0.980956, 0.922408, 0.863859, 0.805310, 0.746761, 0.688212, 0.629664, 0.571115, 0.512566, 0.454017, 0.395468, 0.336920, 0.278371, 0.219822, 1.761273, 1.702724, 1.644176, 1.585627, 1.527078, 1.468529, 1.409980, 1.351432, 1.292883, 1.234334, 1.175785, 1.117236, 1.058688, 1.000139, 0.941590, 0.883041, 0.824492, 0.765944, 0.707395, 0.648846, 0.590297, 0.531748, 0.473200, 0.414651, 0.356102, 0.297553, 0.239004, 1.780456, 1.721907, 1.663358, 1.604809, 1.546260, 1.487712, 1.429163, 1.370614, 1.312065, 1.253516, 1.194968, 1.136419, 1.077870, 1.019321, 0.960772, 0.902224, 0.843675, 0.785126, 0.726577, 0.668028, 0.609480, 0.550931, 0.492382, 0.433833, 0.375284, 0.316736, 0.258187, 1.799638, 1.741089, 1.682540, 1.623992, 1.565443, 1.506894, 1.448345, 1.389796, 1.331248, 1.272699, 1.214150, 1.155601, 1.097052, 1.038504, 0.979955, 0.921406, 0.862857, 0.804308, 0.745760, 0.687211, 0.628662, 0.570113, 0.511564, 0.453016, 0.394467, 0.335918, 0.277369, 0.218820, 1.760272, 1.701723, 1.643174, 1.584625, 1.526076, 1.467528, 1.408979, 1.350430, 1.291881, 1.233332, 1.174784, 1.116235, 1.057686, 0.999137, 0.940588, 0.882040, 0.823491, 0.764942, 0.706393, 0.647844, 0.589296, 0.530747, 0.472198, 0.413649, 0.355100, 0.296552, 0.238003, 1.779454, 1.720905, 1.662356, 1.603808, 1.545259, 1.486710, 1.428161, 1.369612, 1.311064, 1.252515, 1.193966, 1.135417, 1.076868, 1.018320, 0.959771, 0.901222, 0.842673, 0.784124, 0.725576, 0.667027, 0.608478, 0.549929, 0.491380, 0.432832, 0.374283, 0.315734, 0.257185, 1.798636, 1.740088, 1.681539, 1.622990, 1.564441, 1.505892, 1.447344, 1.388795, 1.330246, 1.271697, 1.213148, 1.154600, 1.096051, 1.037502, 0.978953, 0.920404, 0.861856, 0.803307, 0.744758, 0.686209, 0.627660, 0.569112, 0.510563, 0.452014, 0.393465, 0.334916, 0.276368, 0.217819, 1.759270, 1.700721, 1.642172, 1.583624]))
#eval IO.println ("check_hashemiEnv_oil_le " ++ toString (check_hashemiEnv_oil_le 1.588499 1.529950 1.471401 1.412852 1.354304 1.295755 1.237206 1.178657 1.120108 1.061560 1.003011 0.944462 0.885913 0.827364 0.768816 0.710267 0.651718 0.593169 0.534620 0.476072 0.417523 0.358974 0.300425 0.241876 1.783328 1.724779 1.666230 1.607681 1.549132 1.490584 1.432035 1.373486 1.314937 1.256388 1.197840 1.139291 1.080742 1.022193 #[0.265115, 0.206566, 1.748017, 1.689468, 1.630920, 1.572371, 1.513822, 1.455273, 1.396724, 1.338176, 1.279627, 1.221078, 1.162529, 1.103980, 1.045432, 0.986883, 0.928334, 0.869785, 0.811236, 0.752688, 0.694139, 0.635590, 0.577041, 0.518492, 0.459944, 0.401395, 0.342846, 0.284297, 0.225748, 1.767200, 1.708651, 1.650102, 1.591553, 1.533004, 1.474456, 1.415907, 1.357358, 1.298809, 1.240260, 1.181712, 1.123163, 1.064614, 1.006065, 0.947516, 0.888968, 0.830419, 0.771870, 0.713321, 0.654772, 0.596224, 0.537675, 0.479126, 0.420577, 0.362028, 0.303480, 0.244931, 1.786382, 1.727833, 1.669284, 1.610736, 1.552187, 1.493638, 1.435089, 1.376540, 1.317992, 1.259443, 1.200894, 1.142345, 1.083796, 1.025248, 0.966699, 0.908150, 0.849601, 0.791052, 0.732504, 0.673955, 0.615406, 0.556857, 0.498308, 0.439760, 0.381211, 0.322662, 0.264113, 0.205564, 1.747016, 1.688467, 1.629918, 1.571369, 1.512820, 1.454272, 1.395723, 1.337174, 1.278625, 1.220076, 1.161528, 1.102979, 1.044430, 0.985881, 0.927332, 0.868784, 0.810235, 0.751686, 0.693137, 0.634588, 0.576040, 0.517491, 0.458942, 0.400393, 0.341844, 0.283296, 0.224747, 1.766198, 1.707649, 1.649100, 1.590552, 1.532003, 1.473454, 1.414905, 1.356356, 1.297808, 1.239259, 1.180710, 1.122161, 1.063612, 1.005064, 0.946515, 0.887966, 0.829417, 0.770868, 0.712320, 0.653771, 0.595222, 0.536673, 0.478124, 0.419576, 0.361027, 0.302478, 0.243929, 1.785380, 1.726832, 1.668283, 1.609734, 1.551185, 1.492636, 1.434088, 1.375539, 1.316990, 1.258441, 1.199892, 1.141344, 1.082795, 1.024246, 0.965697, 0.907148, 0.848600, 0.790051, 0.731502, 0.672953, 0.614404, 0.555856, 0.497307, 0.438758, 0.380209, 0.321660, 0.263112, 0.204563, 1.746014, 1.687465, 1.628916, 1.570368, 1.511819, 1.453270, 1.394721, 1.336172, 1.277624, 1.219075, 1.160526, 1.101977, 1.043428, 0.984880, 0.926331, 0.867782, 0.809233, 0.750684, 0.692136, 0.633587, 0.575038, 0.516489, 0.457940, 0.399392, 0.340843, 0.282294, 0.223745, 1.765196, 1.706648, 1.648099, 1.589550, 1.531001, 1.472452, 1.413904, 1.355355, 1.296806, 1.238257, 1.179708, 1.121160, 1.062611, 1.004062, 0.945513, 0.886964, 0.828416, 0.769867, 0.711318, 0.652769, 0.594220, 0.535672, 0.477123, 0.418574, 0.360025, 0.301476, 0.242928, 1.784379, 1.725830, 1.667281, 1.608732, 1.550184, 1.491635, 1.433086, 1.374537, 1.315988, 1.257440, 1.198891, 1.140342, 1.081793, 1.023244, 0.964696, 0.906147, 0.847598, 0.789049, 0.730500, 0.671952, 0.613403, 0.554854, 0.496305, 0.437756, 0.379208, 0.320659, 0.262110, 0.203561, 1.745012, 1.686464, 1.627915, 1.569366, 1.510817, 1.452268, 1.393720, 1.335171, 1.276622, 1.218073, 1.159524, 1.100976, 1.042427, 0.983878, 0.925329, 0.866780, 0.808232, 0.749683, 0.691134, 0.632585, 0.574036, 0.515488, 0.456939, 0.398390, 0.339841, 0.281292, 0.222744, 1.764195, 1.705646, 1.647097, 1.588548, 1.530000, 1.471451, 1.412902, 1.354353, 1.295804, 1.237256, 1.178707, 1.120158, 1.061609, 1.003060, 0.944512, 0.885963, 0.827414, 0.768865, 0.710316, 0.651768, 0.593219, 0.534670, 0.476121, 0.417572, 0.359024, 0.300475, 0.241926, 1.783377, 1.724828, 1.666280, 1.607731, 1.549182, 1.490633, 1.432084, 1.373536, 1.314987, 1.256438, 1.197889, 1.139340, 1.080792, 1.022243, 0.963694, 0.905145, 0.846596, 0.788048, 0.729499, 0.670950, 0.612401, 0.553852, 0.495304, 0.436755, 0.378206, 0.319657, 0.261108, 0.202560, 1.744011, 1.685462, 1.626913, 1.568364, 1.509816, 1.451267, 1.392718, 1.334169, 1.275620, 1.217072, 1.158523, 1.099974, 1.041425, 0.982876, 0.924328, 0.865779, 0.807230, 0.748681, 0.690132, 0.631584, 0.573035, 0.514486, 0.455937, 0.397388, 0.338840, 0.280291, 0.221742, 1.763193, 1.704644, 1.646096, 1.587547, 1.528998, 1.470449, 1.411900, 1.353352, 1.294803, 1.236254, 1.177705, 1.119156, 1.060608, 1.002059, 0.943510, 0.884961, 0.826412, 0.767864, 0.709315, 0.650766, 0.592217, 0.533668, 0.475120, 0.416571, 0.358022, 0.299473, 0.240924, 1.782376, 1.723827, 1.665278, 1.606729, 1.548180, 1.489632, 1.431083, 1.372534, 1.313985, 1.255436, 1.196888, 1.138339, 1.079790, 1.021241, 0.962692, 0.904144, 0.845595, 0.787046, 0.728497, 0.669948, 0.611400, 0.552851, 0.494302, 0.435753, 0.377204, 0.318656, 0.260107, 0.201558, 1.743009, 1.684460, 1.625912, 1.567363, 1.508814, 1.450265, 1.391716, 1.333168, 1.274619, 1.216070, 1.157521, 1.098972, 1.040424, 0.981875, 0.923326, 0.864777, 0.806228, 0.747680, 0.689131, 0.630582, 0.572033, 0.513484, 0.454936, 0.396387, 0.337838, 0.279289, 0.220740, 1.762192, 1.703643, 1.645094, 1.586545, 1.527996, 1.469448, 1.410899, 1.352350, 1.293801, 1.235252, 1.176704, 1.118155, 1.059606, 1.001057, 0.942508, 0.883960, 0.825411, 0.766862, 0.708313, 0.649764, 0.591216, 0.532667, 0.474118, 0.415569, 0.357020, 0.298472, 0.239923, 1.781374, 1.722825, 1.664276, 1.605728, 1.547179, 1.488630, 1.430081, 1.371532, 1.312984, 1.254435, 1.195886, 1.137337, 1.078788, 1.020240, 0.961691, 0.903142, 0.844593, 0.786044, 0.727496, 0.668947, 0.610398, 0.551849, 0.493300, 0.434752, 0.376203, 0.317654, 0.259105, 0.200556, 1.742008, 1.683459, 1.624910, 1.566361, 1.507812, 1.449264, 1.390715, 1.332166, 1.273617, 1.215068, 1.156520, 1.097971, 1.039422, 0.980873, 0.922324, 0.863776, 0.805227, 0.746678, 0.688129, 0.629580, 0.571032, 0.512483, 0.453934, 0.395385, 0.336836, 0.278288, 0.219739, 1.761190, 1.702641, 1.644092, 1.585544, 1.526995, 1.468446, 1.409897, 1.351348, 1.292800, 1.234251, 1.175702, 1.117153, 1.058604, 1.000056, 0.941507, 0.882958, 0.824409, 0.765860, 0.707312, 0.648763, 0.590214, 0.531665, 0.473116, 0.414568, 0.356019, 0.297470, 0.238921, 1.780372, 1.721824, 1.663275, 1.604726, 1.546177, 1.487628, 1.429080, 1.370531, 1.311982, 1.253433, 1.194884, 1.136336, 1.077787, 1.019238, 0.960689, 0.902140, 0.843592, 0.785043, 0.726494, 0.667945, 0.609396, 0.550848, 0.492299, 0.433750, 0.375201, 0.316652, 0.258104, 1.799555, 1.741006, 1.682457, 1.623908, 1.565360, 1.506811, 1.448262, 1.389713, 1.331164, 1.272616, 1.214067, 1.155518, 1.096969, 1.038420, 0.979872, 0.921323, 0.862774, 0.804225, 0.745676, 0.687128, 0.628579, 0.570030, 0.511481, 0.452932, 0.394384, 0.335835, 0.277286, 0.218737, 1.760188, 1.701640, 1.643091, 1.584542, 1.525993, 1.467444, 1.408896, 1.350347, 1.291798, 1.233249, 1.174700, 1.116152, 1.057603, 0.999054, 0.940505, 0.881956, 0.823408, 0.764859, 0.706310, 0.647761, 0.589212, 0.530664, 0.472115, 0.413566, 0.355017, 0.296468, 0.237920, 1.779371, 1.720822, 1.662273, 1.603724, 1.545176, 1.486627, 1.428078, 1.369529, 1.310980, 1.252432]))

def check_hashemiEnv_pot_le (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dr : Array Float) : Bool :=
  let v1623 := (Toil - Twall)
  let v1625 := (max (0 : Float) (UAx * v1623))
  (!((0 : Float) <= UAx) || (v1625 <= (UAx * (max (0 : Float) v1623))))

#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 0.464731 0.406182 0.347633 0.289084 0.230536 1.771987 1.713438 1.654889 1.596340 1.537792 1.479243 1.420694 1.362145 1.303596 1.245048 1.186499 1.127950 1.069401 1.010852 0.952304 0.893755 0.835206 0.776657 0.718108 0.659560 0.601011 0.542462 0.483913 0.425364 0.366816 0.308267 0.249718 1.791169 1.732620 1.674072 1.615523 1.556974 1.498425 #[0.741347, 0.682798, 0.624249, 0.565700, 0.507152, 0.448603, 0.390054, 0.331505, 0.272956, 0.214408, 1.755859, 1.697310, 1.638761, 1.580212, 1.521664, 1.463115, 1.404566, 1.346017, 1.287468, 1.228920, 1.170371, 1.111822, 1.053273, 0.994724, 0.936176, 0.877627, 0.819078, 0.760529, 0.701980, 0.643432, 0.584883, 0.526334, 0.467785, 0.409236, 0.350688, 0.292139, 0.233590, 1.775041, 1.716492, 1.657944, 1.599395, 1.540846, 1.482297, 1.423748, 1.365200, 1.306651, 1.248102, 1.189553, 1.131004, 1.072456, 1.013907, 0.955358, 0.896809, 0.838260, 0.779712, 0.721163, 0.662614, 0.604065, 0.545516, 0.486968, 0.428419, 0.369870, 0.311321, 0.252772, 1.794224, 1.735675, 1.677126, 1.618577, 1.560028, 1.501480, 1.442931, 1.384382, 1.325833, 1.267284, 1.208736, 1.150187, 1.091638, 1.033089, 0.974540, 0.915992, 0.857443, 0.798894, 0.740345, 0.681796, 0.623248, 0.564699, 0.506150, 0.447601, 0.389052, 0.330504, 0.271955, 0.213406, 1.754857, 1.696308, 1.637760, 1.579211, 1.520662, 1.462113, 1.403564, 1.345016, 1.286467, 1.227918, 1.169369, 1.110820, 1.052272, 0.993723, 0.935174, 0.876625, 0.818076, 0.759528, 0.700979, 0.642430, 0.583881, 0.525332, 0.466784, 0.408235, 0.349686, 0.291137, 0.232588, 1.774040, 1.715491, 1.656942, 1.598393, 1.539844, 1.481296, 1.422747, 1.364198, 1.305649, 1.247100, 1.188552, 1.130003, 1.071454, 1.012905, 0.954356, 0.895808, 0.837259, 0.778710, 0.720161, 0.661612, 0.603064, 0.544515, 0.485966, 0.427417, 0.368868, 0.310320, 0.251771, 1.793222, 1.734673, 1.676124, 1.617576, 1.559027, 1.500478, 1.441929, 1.383380, 1.324832, 1.266283, 1.207734, 1.149185, 1.090636, 1.032088, 0.973539, 0.914990, 0.856441, 0.797892, 0.739344, 0.680795, 0.622246, 0.563697, 0.505148, 0.446600, 0.388051, 0.329502, 0.270953, 0.212404, 1.753856, 1.695307, 1.636758, 1.578209, 1.519660, 1.461112, 1.402563, 1.344014, 1.285465, 1.226916, 1.168368, 1.109819, 1.051270, 0.992721, 0.934172, 0.875624, 0.817075, 0.758526, 0.699977, 0.641428, 0.582880, 0.524331, 0.465782, 0.407233, 0.348684, 0.290136, 0.231587, 1.773038, 1.714489, 1.655940, 1.597392, 1.538843, 1.480294, 1.421745, 1.363196, 1.304648, 1.246099, 1.187550, 1.129001, 1.070452, 1.011904, 0.953355, 0.894806, 0.836257, 0.777708, 0.719160, 0.660611, 0.602062, 0.543513, 0.484964, 0.426416, 0.367867, 0.309318, 0.250769, 1.792220, 1.733672, 1.675123, 1.616574, 1.558025, 1.499476, 1.440928, 1.382379, 1.323830, 1.265281, 1.206732, 1.148184, 1.089635, 1.031086, 0.972537, 0.913988, 0.855440, 0.796891, 0.738342, 0.679793, 0.621244, 0.562696, 0.504147, 0.445598, 0.387049, 0.328500, 0.269952, 0.211403, 1.752854, 1.694305, 1.635756, 1.577208, 1.518659, 1.460110, 1.401561, 1.343012, 1.284464, 1.225915, 1.167366, 1.108817, 1.050268, 0.991720, 0.933171, 0.874622, 0.816073, 0.757524, 0.698976, 0.640427, 0.581878, 0.523329, 0.464780, 0.406232, 0.347683, 0.289134, 0.230585, 1.772036, 1.713488, 1.654939, 1.596390, 1.537841, 1.479292, 1.420744, 1.362195, 1.303646, 1.245097, 1.186548, 1.128000, 1.069451, 1.010902, 0.952353, 0.893804, 0.835256, 0.776707, 0.718158, 0.659609, 0.601060, 0.542512, 0.483963, 0.425414, 0.366865, 0.308316, 0.249768, 1.791219, 1.732670, 1.674121, 1.615572, 1.557024, 1.498475, 1.439926, 1.381377, 1.322828, 1.264280, 1.205731, 1.147182, 1.088633, 1.030084, 0.971536, 0.912987, 0.854438, 0.795889, 0.737340, 0.678792, 0.620243, 0.561694, 0.503145, 0.444596, 0.386048, 0.327499, 0.268950, 0.210401, 1.751852, 1.693304, 1.634755, 1.576206, 1.517657, 1.459108, 1.400560, 1.342011, 1.283462, 1.224913, 1.166364, 1.107816, 1.049267, 0.990718, 0.932169, 0.873620, 0.815072, 0.756523, 0.697974, 0.639425, 0.580876, 0.522328, 0.463779, 0.405230, 0.346681, 0.288132, 0.229584, 1.771035, 1.712486, 1.653937, 1.595388, 1.536840, 1.478291, 1.419742, 1.361193, 1.302644, 1.244096, 1.185547, 1.126998, 1.068449, 1.009900, 0.951352, 0.892803, 0.834254, 0.775705, 0.717156, 0.658608, 0.600059, 0.541510, 0.482961, 0.424412, 0.365864, 0.307315, 0.248766, 1.790217, 1.731668, 1.673120, 1.614571, 1.556022, 1.497473, 1.438924, 1.380376, 1.321827, 1.263278, 1.204729, 1.146180, 1.087632, 1.029083, 0.970534, 0.911985, 0.853436, 0.794888, 0.736339, 0.677790, 0.619241, 0.560692, 0.502144, 0.443595, 0.385046, 0.326497, 0.267948, 0.209400, 1.750851, 1.692302, 1.633753, 1.575204, 1.516656, 1.458107, 1.399558, 1.341009, 1.282460, 1.223912, 1.165363, 1.106814, 1.048265, 0.989716, 0.931168, 0.872619, 0.814070, 0.755521, 0.696972, 0.638424, 0.579875, 0.521326, 0.462777, 0.404228, 0.345680, 0.287131, 0.228582, 1.770033, 1.711484, 1.652936, 1.594387, 1.535838, 1.477289, 1.418740, 1.360192, 1.301643, 1.243094, 1.184545, 1.125996, 1.067448, 1.008899, 0.950350, 0.891801, 0.833252, 0.774704, 0.716155, 0.657606, 0.599057, 0.540508, 0.481960, 0.423411, 0.364862, 0.306313, 0.247764, 1.789216, 1.730667, 1.672118, 1.613569, 1.555020, 1.496472, 1.437923, 1.379374, 1.320825, 1.262276, 1.203728, 1.145179, 1.086630, 1.028081, 0.969532, 0.910984, 0.852435, 0.793886, 0.735337, 0.676788, 0.618240, 0.559691, 0.501142, 0.442593, 0.384044, 0.325496, 0.266947, 0.208398, 1.749849, 1.691300, 1.632752, 1.574203, 1.515654, 1.457105, 1.398556, 1.340008, 1.281459, 1.222910, 1.164361, 1.105812, 1.047264, 0.988715, 0.930166, 0.871617, 0.813068, 0.754520, 0.695971, 0.637422, 0.578873, 0.520324, 0.461776, 0.403227, 0.344678, 0.286129, 0.227580, 1.769032, 1.710483, 1.651934, 1.593385, 1.534836, 1.476288, 1.417739, 1.359190, 1.300641, 1.242092, 1.183544, 1.124995, 1.066446, 1.007897, 0.949348, 0.890800, 0.832251, 0.773702, 0.715153, 0.656604, 0.598056, 0.539507, 0.480958, 0.422409, 0.363860, 0.305312, 0.246763, 1.788214, 1.729665, 1.671116, 1.612568, 1.554019, 1.495470, 1.436921, 1.378372, 1.319824, 1.261275, 1.202726, 1.144177, 1.085628, 1.027080, 0.968531, 0.909982, 0.851433, 0.792884, 0.734336, 0.675787, 0.617238, 0.558689, 0.500140, 0.441592, 0.383043, 0.324494, 0.265945, 0.207396, 1.748848, 1.690299, 1.631750, 1.573201, 1.514652, 1.456104, 1.397555, 1.339006, 1.280457, 1.221908, 1.163360, 1.104811, 1.046262, 0.987713, 0.929164, 0.870616, 0.812067, 0.753518, 0.694969, 0.636420, 0.577872, 0.519323, 0.460774, 0.402225, 0.343676, 0.285128, 0.226579, 1.768030, 1.709481, 1.650932, 1.592384, 1.533835, 1.475286, 1.416737, 1.358188, 1.299640, 1.241091, 1.182542, 1.123993, 1.065444, 1.006896, 0.948347, 0.889798, 0.831249, 0.772700, 0.714152, 0.655603, 0.597054, 0.538505, 0.479956, 0.421408, 0.362859, 0.304310, 0.245761, 1.787212, 1.728664]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 1.733539 1.674990 1.616441 1.557892 1.499344 1.440795 1.382246 1.323697 1.265148 1.206600 1.148051 1.089502 1.030953 0.972404 0.913856 0.855307 0.796758 0.738209 0.679660 0.621112 0.562563 0.504014 0.445465 0.386916 0.328368 0.269819 0.211270 1.752721 1.694172 1.635624 1.577075 1.518526 1.459977 1.401428 1.342880 1.284331 1.225782 1.167233 #[0.410155, 0.351606, 0.293057, 0.234508, 1.775960, 1.717411, 1.658862, 1.600313, 1.541764, 1.483216, 1.424667, 1.366118, 1.307569, 1.249020, 1.190472, 1.131923, 1.073374, 1.014825, 0.956276, 0.897728, 0.839179, 0.780630, 0.722081, 0.663532, 0.604984, 0.546435, 0.487886, 0.429337, 0.370788, 0.312240, 0.253691, 1.795142, 1.736593, 1.678044, 1.619496, 1.560947, 1.502398, 1.443849, 1.385300, 1.326752, 1.268203, 1.209654, 1.151105, 1.092556, 1.034008, 0.975459, 0.916910, 0.858361, 0.799812, 0.741264, 0.682715, 0.624166, 0.565617, 0.507068, 0.448520, 0.389971, 0.331422, 0.272873, 0.214324, 1.755776, 1.697227, 1.638678, 1.580129, 1.521580, 1.463032, 1.404483, 1.345934, 1.287385, 1.228836, 1.170288, 1.111739, 1.053190, 0.994641, 0.936092, 0.877544, 0.818995, 0.760446, 0.701897, 0.643348, 0.584800, 0.526251, 0.467702, 0.409153, 0.350604, 0.292056, 0.233507, 1.774958, 1.716409, 1.657860, 1.599312, 1.540763, 1.482214, 1.423665, 1.365116, 1.306568, 1.248019, 1.189470, 1.130921, 1.072372, 1.013824, 0.955275, 0.896726, 0.838177, 0.779628, 0.721080, 0.662531, 0.603982, 0.545433, 0.486884, 0.428336, 0.369787, 0.311238, 0.252689, 1.794140, 1.735592, 1.677043, 1.618494, 1.559945, 1.501396, 1.442848, 1.384299, 1.325750, 1.267201, 1.208652, 1.150104, 1.091555, 1.033006, 0.974457, 0.915908, 0.857360, 0.798811, 0.740262, 0.681713, 0.623164, 0.564616, 0.506067, 0.447518, 0.388969, 0.330420, 0.271872, 0.213323, 1.754774, 1.696225, 1.637676, 1.579128, 1.520579, 1.462030, 1.403481, 1.344932, 1.286384, 1.227835, 1.169286, 1.110737, 1.052188, 0.993640, 0.935091, 0.876542, 0.817993, 0.759444, 0.700896, 0.642347, 0.583798, 0.525249, 0.466700, 0.408152, 0.349603, 0.291054, 0.232505, 1.773956, 1.715408, 1.656859, 1.598310, 1.539761, 1.481212, 1.422664, 1.364115, 1.305566, 1.247017, 1.188468, 1.129920, 1.071371, 1.012822, 0.954273, 0.895724, 0.837176, 0.778627, 0.720078, 0.661529, 0.602980, 0.544432, 0.485883, 0.427334, 0.368785, 0.310236, 0.251688, 1.793139, 1.734590, 1.676041, 1.617492, 1.558944, 1.500395, 1.441846, 1.383297, 1.324748, 1.266200, 1.207651, 1.149102, 1.090553, 1.032004, 0.973456, 0.914907, 0.856358, 0.797809, 0.739260, 0.680712, 0.622163, 0.563614, 0.505065, 0.446516, 0.387968, 0.329419, 0.270870, 0.212321, 1.753772, 1.695224, 1.636675, 1.578126, 1.519577, 1.461028, 1.402480, 1.343931, 1.285382, 1.226833, 1.168284, 1.109736, 1.051187, 0.992638, 0.934089, 0.875540, 0.816992, 0.758443, 0.699894, 0.641345, 0.582796, 0.524248, 0.465699, 0.407150, 0.348601, 0.290052, 0.231504, 1.772955, 1.714406, 1.655857, 1.597308, 1.538760, 1.480211, 1.421662, 1.363113, 1.304564, 1.246016, 1.187467, 1.128918, 1.070369, 1.011820, 0.953272, 0.894723, 0.836174, 0.777625, 0.719076, 0.660528, 0.601979, 0.543430, 0.484881, 0.426332, 0.367784, 0.309235, 0.250686, 1.792137, 1.733588, 1.675040, 1.616491, 1.557942, 1.499393, 1.440844, 1.382296, 1.323747, 1.265198, 1.206649, 1.148100, 1.089552, 1.031003, 0.972454, 0.913905, 0.855356, 0.796808, 0.738259, 0.679710, 0.621161, 0.562612, 0.504064, 0.445515, 0.386966, 0.328417, 0.269868, 0.211320, 1.752771, 1.694222, 1.635673, 1.577124, 1.518576, 1.460027, 1.401478, 1.342929, 1.284380, 1.225832, 1.167283, 1.108734, 1.050185, 0.991636, 0.933088, 0.874539, 0.815990, 0.757441, 0.698892, 0.640344, 0.581795, 0.523246, 0.464697, 0.406148, 0.347600, 0.289051, 0.230502, 1.771953, 1.713404, 1.654856, 1.596307, 1.537758, 1.479209, 1.420660, 1.362112, 1.303563, 1.245014, 1.186465, 1.127916, 1.069368, 1.010819, 0.952270, 0.893721, 0.835172, 0.776624, 0.718075, 0.659526, 0.600977, 0.542428, 0.483880, 0.425331, 0.366782, 0.308233, 0.249684, 1.791136, 1.732587, 1.674038, 1.615489, 1.556940, 1.498392, 1.439843, 1.381294, 1.322745, 1.264196, 1.205648, 1.147099, 1.088550, 1.030001, 0.971452, 0.912904, 0.854355, 0.795806, 0.737257, 0.678708, 0.620160, 0.561611, 0.503062, 0.444513, 0.385964, 0.327416, 0.268867, 0.210318, 1.751769, 1.693220, 1.634672, 1.576123, 1.517574, 1.459025, 1.400476, 1.341928, 1.283379, 1.224830, 1.166281, 1.107732, 1.049184, 0.990635, 0.932086, 0.873537, 0.814988, 0.756440, 0.697891, 0.639342, 0.580793, 0.522244, 0.463696, 0.405147, 0.346598, 0.288049, 0.229500, 1.770952, 1.712403, 1.653854, 1.595305, 1.536756, 1.478208, 1.419659, 1.361110, 1.302561, 1.244012, 1.185464, 1.126915, 1.068366, 1.009817, 0.951268, 0.892720, 0.834171, 0.775622, 0.717073, 0.658524, 0.599976, 0.541427, 0.482878, 0.424329, 0.365780, 0.307232, 0.248683, 1.790134, 1.731585, 1.673036, 1.614488, 1.555939, 1.497390, 1.438841, 1.380292, 1.321744, 1.263195, 1.204646, 1.146097, 1.087548, 1.029000, 0.970451, 0.911902, 0.853353, 0.794804, 0.736256, 0.677707, 0.619158, 0.560609, 0.502060, 0.443512, 0.384963, 0.326414, 0.267865, 0.209316, 1.750768, 1.692219, 1.633670, 1.575121, 1.516572, 1.458024, 1.399475, 1.340926, 1.282377, 1.223828, 1.165280, 1.106731, 1.048182, 0.989633, 0.931084, 0.872536, 0.813987, 0.755438, 0.696889, 0.638340, 0.579792, 0.521243, 0.462694, 0.404145, 0.345596, 0.287048, 0.228499, 1.769950, 1.711401, 1.652852, 1.594304, 1.535755, 1.477206, 1.418657, 1.360108, 1.301560, 1.243011, 1.184462, 1.125913, 1.067364, 1.008816, 0.950267, 0.891718, 0.833169, 0.774620, 0.716072, 0.657523, 0.598974, 0.540425, 0.481876, 0.423328, 0.364779, 0.306230, 0.247681, 1.789132, 1.730584, 1.672035, 1.613486, 1.554937, 1.496388, 1.437840, 1.379291, 1.320742, 1.262193, 1.203644, 1.145096, 1.086547, 1.027998, 0.969449, 0.910900, 0.852352, 0.793803, 0.735254, 0.676705, 0.618156, 0.559608, 0.501059, 0.442510, 0.383961, 0.325412, 0.266864, 0.208315, 1.749766, 1.691217, 1.632668, 1.574120, 1.515571, 1.457022, 1.398473, 1.339924, 1.281376, 1.222827, 1.164278, 1.105729, 1.047180, 0.988632, 0.930083, 0.871534, 0.812985, 0.754436, 0.695888, 0.637339, 0.578790, 0.520241, 0.461692, 0.403144, 0.344595, 0.286046, 0.227497, 1.768948, 1.710400, 1.651851, 1.593302, 1.534753, 1.476204, 1.417656, 1.359107, 1.300558, 1.242009, 1.183460, 1.124912, 1.066363, 1.007814, 0.949265, 0.890716, 0.832168, 0.773619, 0.715070, 0.656521, 0.597972, 0.539424, 0.480875, 0.422326, 0.363777, 0.305228, 0.246680, 1.788131, 1.729582, 1.671033, 1.612484, 1.553936, 1.495387, 1.436838, 1.378289, 1.319740, 1.261192, 1.202643, 1.144094, 1.085545, 1.026996, 0.968448, 0.909899, 0.851350, 0.792801, 0.734252, 0.675704, 0.617155, 0.558606, 0.500057, 0.441508, 0.382960, 0.324411, 0.265862, 0.207313, 1.748764, 1.690216, 1.631667, 1.573118, 1.514569, 1.456020, 1.397472]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 1.402347 1.343798 1.285249 1.226700 1.168152 1.109603 1.051054 0.992505 0.933956 0.875408 0.816859 0.758310 0.699761 0.641212 0.582664 0.524115 0.465566 0.407017 0.348468 0.289920 0.231371 1.772822 1.714273 1.655724 1.597176 1.538627 1.480078 1.421529 1.362980 1.304432 1.245883 1.187334 1.128785 1.070236 1.011688 0.953139 0.894590 0.836041 #[1.678963, 1.620414, 1.561865, 1.503316, 1.444768, 1.386219, 1.327670, 1.269121, 1.210572, 1.152024, 1.093475, 1.034926, 0.976377, 0.917828, 0.859280, 0.800731, 0.742182, 0.683633, 0.625084, 0.566536, 0.507987, 0.449438, 0.390889, 0.332340, 0.273792, 0.215243, 1.756694, 1.698145, 1.639596, 1.581048, 1.522499, 1.463950, 1.405401, 1.346852, 1.288304, 1.229755, 1.171206, 1.112657, 1.054108, 0.995560, 0.937011, 0.878462, 0.819913, 0.761364, 0.702816, 0.644267, 0.585718, 0.527169, 0.468620, 0.410072, 0.351523, 0.292974, 0.234425, 1.775876, 1.717328, 1.658779, 1.600230, 1.541681, 1.483132, 1.424584, 1.366035, 1.307486, 1.248937, 1.190388, 1.131840, 1.073291, 1.014742, 0.956193, 0.897644, 0.839096, 0.780547, 0.721998, 0.663449, 0.604900, 0.546352, 0.487803, 0.429254, 0.370705, 0.312156, 0.253608, 1.795059, 1.736510, 1.677961, 1.619412, 1.560864, 1.502315, 1.443766, 1.385217, 1.326668, 1.268120, 1.209571, 1.151022, 1.092473, 1.033924, 0.975376, 0.916827, 0.858278, 0.799729, 0.741180, 0.682632, 0.624083, 0.565534, 0.506985, 0.448436, 0.389888, 0.331339, 0.272790, 0.214241, 1.755692, 1.697144, 1.638595, 1.580046, 1.521497, 1.462948, 1.404400, 1.345851, 1.287302, 1.228753, 1.170204, 1.111656, 1.053107, 0.994558, 0.936009, 0.877460, 0.818912, 0.760363, 0.701814, 0.643265, 0.584716, 0.526168, 0.467619, 0.409070, 0.350521, 0.291972, 0.233424, 1.774875, 1.716326, 1.657777, 1.599228, 1.540680, 1.482131, 1.423582, 1.365033, 1.306484, 1.247936, 1.189387, 1.130838, 1.072289, 1.013740, 0.955192, 0.896643, 0.838094, 0.779545, 0.720996, 0.662448, 0.603899, 0.545350, 0.486801, 0.428252, 0.369704, 0.311155, 0.252606, 1.794057, 1.735508, 1.676960, 1.618411, 1.559862, 1.501313, 1.442764, 1.384216, 1.325667, 1.267118, 1.208569, 1.150020, 1.091472, 1.032923, 0.974374, 0.915825, 0.857276, 0.798728, 0.740179, 0.681630, 0.623081, 0.564532, 0.505984, 0.447435, 0.388886, 0.330337, 0.271788, 0.213240, 1.754691, 1.696142, 1.637593, 1.579044, 1.520496, 1.461947, 1.403398, 1.344849, 1.286300, 1.227752, 1.169203, 1.110654, 1.052105, 0.993556, 0.935008, 0.876459, 0.817910, 0.759361, 0.700812, 0.642264, 0.583715, 0.525166, 0.466617, 0.408068, 0.349520, 0.290971, 0.232422, 1.773873, 1.715324, 1.656776, 1.598227, 1.539678, 1.481129, 1.422580, 1.364032, 1.305483, 1.246934, 1.188385, 1.129836, 1.071288, 1.012739, 0.954190, 0.895641, 0.837092, 0.778544, 0.719995, 0.661446, 0.602897, 0.544348, 0.485800, 0.427251, 0.368702, 0.310153, 0.251604, 1.793056, 1.734507, 1.675958, 1.617409, 1.558860, 1.500312, 1.441763, 1.383214, 1.324665, 1.266116, 1.207568, 1.149019, 1.090470, 1.031921, 0.973372, 0.914824, 0.856275, 0.797726, 0.739177, 0.680628, 0.622080, 0.563531, 0.504982, 0.446433, 0.387884, 0.329336, 0.270787, 0.212238, 1.753689, 1.695140, 1.636592, 1.578043, 1.519494, 1.460945, 1.402396, 1.343848, 1.285299, 1.226750, 1.168201, 1.109652, 1.051104, 0.992555, 0.934006, 0.875457, 0.816908, 0.758360, 0.699811, 0.641262, 0.582713, 0.524164, 0.465616, 0.407067, 0.348518, 0.289969, 0.231420, 1.772872, 1.714323, 1.655774, 1.597225, 1.538676, 1.480128, 1.421579, 1.363030, 1.304481, 1.245932, 1.187384, 1.128835, 1.070286, 1.011737, 0.953188, 0.894640, 0.836091, 0.777542, 0.718993, 0.660444, 0.601896, 0.543347, 0.484798, 0.426249, 0.367700, 0.309152, 0.250603, 1.792054, 1.733505, 1.674956, 1.616408, 1.557859, 1.499310, 1.440761, 1.382212, 1.323664, 1.265115, 1.206566, 1.148017, 1.089468, 1.030920, 0.972371, 0.913822, 0.855273, 0.796724, 0.738176, 0.679627, 0.621078, 0.562529, 0.503980, 0.445432, 0.386883, 0.328334, 0.269785, 0.211236, 1.752688, 1.694139, 1.635590, 1.577041, 1.518492, 1.459944, 1.401395, 1.342846, 1.284297, 1.225748, 1.167200, 1.108651, 1.050102, 0.991553, 0.933004, 0.874456, 0.815907, 0.757358, 0.698809, 0.640260, 0.581712, 0.523163, 0.464614, 0.406065, 0.347516, 0.288968, 0.230419, 1.771870, 1.713321, 1.654772, 1.596224, 1.537675, 1.479126, 1.420577, 1.362028, 1.303480, 1.244931, 1.186382, 1.127833, 1.069284, 1.010736, 0.952187, 0.893638, 0.835089, 0.776540, 0.717992, 0.659443, 0.600894, 0.542345, 0.483796, 0.425248, 0.366699, 0.308150, 0.249601, 1.791052, 1.732504, 1.673955, 1.615406, 1.556857, 1.498308, 1.439760, 1.381211, 1.322662, 1.264113, 1.205564, 1.147016, 1.088467, 1.029918, 0.971369, 0.912820, 0.854272, 0.795723, 0.737174, 0.678625, 0.620076, 0.561528, 0.502979, 0.444430, 0.385881, 0.327332, 0.268784, 0.210235, 1.751686, 1.693137, 1.634588, 1.576040, 1.517491, 1.458942, 1.400393, 1.341844, 1.283296, 1.224747, 1.166198, 1.107649, 1.049100, 0.990552, 0.932003, 0.873454, 0.814905, 0.756356, 0.697808, 0.639259, 0.580710, 0.522161, 0.463612, 0.405064, 0.346515, 0.287966, 0.229417, 1.770868, 1.712320, 1.653771, 1.595222, 1.536673, 1.478124, 1.419576, 1.361027, 1.302478, 1.243929, 1.185380, 1.126832, 1.068283, 1.009734, 0.951185, 0.892636, 0.834088, 0.775539, 0.716990, 0.658441, 0.599892, 0.541344, 0.482795, 0.424246, 0.365697, 0.307148, 0.248600, 1.790051, 1.731502, 1.672953, 1.614404, 1.555856, 1.497307, 1.438758, 1.380209, 1.321660, 1.263112, 1.204563, 1.146014, 1.087465, 1.028916, 0.970368, 0.911819, 0.853270, 0.794721, 0.736172, 0.677624, 0.619075, 0.560526, 0.501977, 0.443428, 0.384880, 0.326331, 0.267782, 0.209233, 1.750684, 1.692136, 1.633587, 1.575038, 1.516489, 1.457940, 1.399392, 1.340843, 1.282294, 1.223745, 1.165196, 1.106648, 1.048099, 0.989550, 0.931001, 0.872452, 0.813904, 0.755355, 0.696806, 0.638257, 0.579708, 0.521160, 0.462611, 0.404062, 0.345513, 0.286964, 0.228416, 1.769867, 1.711318, 1.652769, 1.594220, 1.535672, 1.477123, 1.418574, 1.360025, 1.301476, 1.242928, 1.184379, 1.125830, 1.067281, 1.008732, 0.950184, 0.891635, 0.833086, 0.774537, 0.715988, 0.657440, 0.598891, 0.540342, 0.481793, 0.423244, 0.364696, 0.306147, 0.247598, 1.789049, 1.730500, 1.671952, 1.613403, 1.554854, 1.496305, 1.437756, 1.379208, 1.320659, 1.262110, 1.203561, 1.145012, 1.086464, 1.027915, 0.969366, 0.910817, 0.852268, 0.793720, 0.735171, 0.676622, 0.618073, 0.559524, 0.500976, 0.442427, 0.383878, 0.325329, 0.266780, 0.208232, 1.749683, 1.691134, 1.632585, 1.574036, 1.515488, 1.456939, 1.398390, 1.339841, 1.281292, 1.222744, 1.164195, 1.105646, 1.047097, 0.988548, 0.930000, 0.871451, 0.812902, 0.754353, 0.695804, 0.637256, 0.578707, 0.520158, 0.461609, 0.403060, 0.344512, 0.285963, 0.227414, 1.768865, 1.710316, 1.651768, 1.593219, 1.534670, 1.476121, 1.417572, 1.359024, 1.300475, 1.241926, 1.183377, 1.124828, 1.066280]))

def hashemiHanger  : Array Float :=
  #[(Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float))))), (0.010 : Float)]

#eval IO.println ("hashemiHanger " ++ toString ((hashemiHanger).map Float.toBits))
#eval IO.println ("hashemiHanger " ++ toString ((hashemiHanger).map Float.toBits))
#eval IO.println ("hashemiHanger " ++ toString ((hashemiHanger).map Float.toBits))

def check_hashemiHanger_length  : Bool :=
  let v11 := ((0.4 : Float) ^ 2)
  (feq (Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float))))) (Float.sqrt ((((0 : Float) ^ 2) + v11) + ((((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((Float.sqrt (((0.8 : Float) ^ 2) + v11)) ^ 2))))) ^ 2))))

#eval IO.println ("check_hashemiHanger_length " ++ toString (check_hashemiHanger_length))
#eval IO.println ("check_hashemiHanger_length " ++ toString (check_hashemiHanger_length))
#eval IO.println ("check_hashemiHanger_length " ++ toString (check_hashemiHanger_length))

def hashemiLeg  : Array Float :=
  #[(1.30 : Float), (0.62 : Float), (0.96 : Float), (0.175 : Float), (4 : Float)]

#eval IO.println ("hashemiLeg " ++ toString ((hashemiLeg).map Float.toBits))
#eval IO.println ("hashemiLeg " ++ toString ((hashemiLeg).map Float.toBits))
#eval IO.println ("hashemiLeg " ++ toString ((hashemiLeg).map Float.toBits))

def hashemiLoop (az : Float) (t : Float) (slack : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Toil : Float) (Twall : Float) (Ta : Float) (tautPrev : Float) (holdsPrev : Float) (tDead : Float) (b2_0 : Float) (b2_1 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) (dr : Array Float) : Array Float :=
  let v857 := (azSun - az)
  let v860 := ((2 : Float) * (3.141592653589793 : Float))
  let v865 := (v857 - (v860 * (Float.floor ((v857 + (3.141592653589793 : Float)) / v860))))
  let v866 := ((3.141592653589793 : Float) / (2 : Float))
  let v868 := ((v866 - t) - elSun)
  let v871 := ((Toil - (300 : Float)) / (300 : Float))
  let v876 := (1.0 / (1.0 + Float.exp (-((elSun - (v866 - tDead)) / (0.01 : Float)))))
  let v877 := (Float.sin t)
  let v879 := (v877 * (Float.cos az))
  let v881 := (v877 * (Float.sin az))
  let v882 := (Float.cos t)
  let v883 := (Float.cos elSun)
  let v885 := (v883 * (Float.cos azSun))
  let v887 := (v883 * (Float.sin azSun))
  let v888 := (Float.sin elSun)
  let v893 := (((v879 * v885) + (v881 * v887)) + (v882 * v888))
  let v908 := (Float.sqrt (((((v881 * v888) - (v882 * v887)) ^ 2) + (((v882 * v885) - (v879 * v888)) ^ 2)) + (((v879 * v887) - (v881 * v885)) ^ 2)))
  let v919 := (if (v893 <= (0 : Float)) then (v866 + (Float.atan ((-v893) / (max v908 (0.000000000001 : Float))))) else (Float.atan (v908 / v893)))
  let v923 := (1.0 / (1.0 + Float.exp (-((v919 - (0.03 : Float)) / (0.01 : Float)))))
  let v924 := (v876 * v923)
  let v941 := (Float.tanh (((((((((W1[0 * 8 + 0]! * v865) + (W1[0 * 8 + 1]! * v868)) + (W1[0 * 8 + 2]! * t)) + (W1[0 * 8 + 3]! * tautPrev)) + (W1[0 * 8 + 4]! * holdsPrev)) + (W1[0 * 8 + 5]! * v871)) + (W1[0 * 8 + 6]! * v876)) + (W1[0 * 8 + 7]! * v924)) + b1[0]!))
  let v958 := (Float.tanh (((((((((W1[1 * 8 + 0]! * v865) + (W1[1 * 8 + 1]! * v868)) + (W1[1 * 8 + 2]! * t)) + (W1[1 * 8 + 3]! * tautPrev)) + (W1[1 * 8 + 4]! * holdsPrev)) + (W1[1 * 8 + 5]! * v871)) + (W1[1 * 8 + 6]! * v876)) + (W1[1 * 8 + 7]! * v924)) + b1[1]!))
  let v975 := (Float.tanh (((((((((W1[2 * 8 + 0]! * v865) + (W1[2 * 8 + 1]! * v868)) + (W1[2 * 8 + 2]! * t)) + (W1[2 * 8 + 3]! * tautPrev)) + (W1[2 * 8 + 4]! * holdsPrev)) + (W1[2 * 8 + 5]! * v871)) + (W1[2 * 8 + 6]! * v876)) + (W1[2 * 8 + 7]! * v924)) + b1[2]!))
  let v992 := (Float.tanh (((((((((W1[3 * 8 + 0]! * v865) + (W1[3 * 8 + 1]! * v868)) + (W1[3 * 8 + 2]! * t)) + (W1[3 * 8 + 3]! * tautPrev)) + (W1[3 * 8 + 4]! * holdsPrev)) + (W1[3 * 8 + 5]! * v871)) + (W1[3 * 8 + 6]! * v876)) + (W1[3 * 8 + 7]! * v924)) + b1[3]!))
  let v1009 := (Float.tanh (((((((((W1[4 * 8 + 0]! * v865) + (W1[4 * 8 + 1]! * v868)) + (W1[4 * 8 + 2]! * t)) + (W1[4 * 8 + 3]! * tautPrev)) + (W1[4 * 8 + 4]! * holdsPrev)) + (W1[4 * 8 + 5]! * v871)) + (W1[4 * 8 + 6]! * v876)) + (W1[4 * 8 + 7]! * v924)) + b1[4]!))
  let v1026 := (Float.tanh (((((((((W1[5 * 8 + 0]! * v865) + (W1[5 * 8 + 1]! * v868)) + (W1[5 * 8 + 2]! * t)) + (W1[5 * 8 + 3]! * tautPrev)) + (W1[5 * 8 + 4]! * holdsPrev)) + (W1[5 * 8 + 5]! * v871)) + (W1[5 * 8 + 6]! * v876)) + (W1[5 * 8 + 7]! * v924)) + b1[5]!))
  let v1043 := (Float.tanh (((((((((W1[6 * 8 + 0]! * v865) + (W1[6 * 8 + 1]! * v868)) + (W1[6 * 8 + 2]! * t)) + (W1[6 * 8 + 3]! * tautPrev)) + (W1[6 * 8 + 4]! * holdsPrev)) + (W1[6 * 8 + 5]! * v871)) + (W1[6 * 8 + 6]! * v876)) + (W1[6 * 8 + 7]! * v924)) + b1[6]!))
  let v1060 := (Float.tanh (((((((((W1[7 * 8 + 0]! * v865) + (W1[7 * 8 + 1]! * v868)) + (W1[7 * 8 + 2]! * t)) + (W1[7 * 8 + 3]! * tautPrev)) + (W1[7 * 8 + 4]! * holdsPrev)) + (W1[7 * 8 + 5]! * v871)) + (W1[7 * 8 + 6]! * v876)) + (W1[7 * 8 + 7]! * v924)) + b1[7]!))
  let v1077 := (Float.tanh (((((((((W1[8 * 8 + 0]! * v865) + (W1[8 * 8 + 1]! * v868)) + (W1[8 * 8 + 2]! * t)) + (W1[8 * 8 + 3]! * tautPrev)) + (W1[8 * 8 + 4]! * holdsPrev)) + (W1[8 * 8 + 5]! * v871)) + (W1[8 * 8 + 6]! * v876)) + (W1[8 * 8 + 7]! * v924)) + b1[8]!))
  let v1094 := (Float.tanh (((((((((W1[9 * 8 + 0]! * v865) + (W1[9 * 8 + 1]! * v868)) + (W1[9 * 8 + 2]! * t)) + (W1[9 * 8 + 3]! * tautPrev)) + (W1[9 * 8 + 4]! * holdsPrev)) + (W1[9 * 8 + 5]! * v871)) + (W1[9 * 8 + 6]! * v876)) + (W1[9 * 8 + 7]! * v924)) + b1[9]!))
  let v1111 := (Float.tanh (((((((((W1[10 * 8 + 0]! * v865) + (W1[10 * 8 + 1]! * v868)) + (W1[10 * 8 + 2]! * t)) + (W1[10 * 8 + 3]! * tautPrev)) + (W1[10 * 8 + 4]! * holdsPrev)) + (W1[10 * 8 + 5]! * v871)) + (W1[10 * 8 + 6]! * v876)) + (W1[10 * 8 + 7]! * v924)) + b1[10]!))
  let v1128 := (Float.tanh (((((((((W1[11 * 8 + 0]! * v865) + (W1[11 * 8 + 1]! * v868)) + (W1[11 * 8 + 2]! * t)) + (W1[11 * 8 + 3]! * tautPrev)) + (W1[11 * 8 + 4]! * holdsPrev)) + (W1[11 * 8 + 5]! * v871)) + (W1[11 * 8 + 6]! * v876)) + (W1[11 * 8 + 7]! * v924)) + b1[11]!))
  let v1145 := (Float.tanh (((((((((W1[12 * 8 + 0]! * v865) + (W1[12 * 8 + 1]! * v868)) + (W1[12 * 8 + 2]! * t)) + (W1[12 * 8 + 3]! * tautPrev)) + (W1[12 * 8 + 4]! * holdsPrev)) + (W1[12 * 8 + 5]! * v871)) + (W1[12 * 8 + 6]! * v876)) + (W1[12 * 8 + 7]! * v924)) + b1[12]!))
  let v1162 := (Float.tanh (((((((((W1[13 * 8 + 0]! * v865) + (W1[13 * 8 + 1]! * v868)) + (W1[13 * 8 + 2]! * t)) + (W1[13 * 8 + 3]! * tautPrev)) + (W1[13 * 8 + 4]! * holdsPrev)) + (W1[13 * 8 + 5]! * v871)) + (W1[13 * 8 + 6]! * v876)) + (W1[13 * 8 + 7]! * v924)) + b1[13]!))
  let v1179 := (Float.tanh (((((((((W1[14 * 8 + 0]! * v865) + (W1[14 * 8 + 1]! * v868)) + (W1[14 * 8 + 2]! * t)) + (W1[14 * 8 + 3]! * tautPrev)) + (W1[14 * 8 + 4]! * holdsPrev)) + (W1[14 * 8 + 5]! * v871)) + (W1[14 * 8 + 6]! * v876)) + (W1[14 * 8 + 7]! * v924)) + b1[14]!))
  let v1196 := (Float.tanh (((((((((W1[15 * 8 + 0]! * v865) + (W1[15 * 8 + 1]! * v868)) + (W1[15 * 8 + 2]! * t)) + (W1[15 * 8 + 3]! * tautPrev)) + (W1[15 * 8 + 4]! * holdsPrev)) + (W1[15 * 8 + 5]! * v871)) + (W1[15 * 8 + 6]! * v876)) + (W1[15 * 8 + 7]! * v924)) + b1[15]!))
  let v1264 := (-(1.22 : Float))
  let v1267 := (-(0.8 : Float))
  let v1275 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v1276 := (-v1275)
  let v1278 := ((v1267 * v882) + (v1276 * v877))
  let v1279 := (-v1267)
  let v1282 := ((v1279 * v877) + (v1276 * v882))
  let v1291 := (Float.sqrt (((v1278 - v1264) ^ 2) + ((v1282 - (0.34 : Float)) ^ 2)))
  let v1292 := (((v1264 * v1282) - ((0.34 : Float) * v1278)) / v1291)
  let v1308 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  let v1317 := ((1.22 : Float) * (0.8 : Float))
  let v1318 := ((0.34 : Float) * v1275)
  let v1326 := (if (v1317 <= v1318) then v866 else (Float.atan ((((1.22 : Float) * v1275) + ((0.34 : Float) * (0.8 : Float))) / (v1317 - v1318))))
  let v1327 := (Float.cos (0 : Float))
  let v1329 := (Float.sin (0 : Float))
  let v1340 := (Float.sqrt (((((v1267 * v1327) + (v1276 * v1329)) - v1264) ^ 2) + ((((v1279 * v1329) + (v1276 * v1327)) - (0.34 : Float)) ^ 2)))
  let v1341 := (Float.cos v1326)
  let v1343 := (Float.sin v1326)
  let v1354 := (Float.sqrt (((((v1267 * v1341) + (v1276 * v1343)) - v1264) ^ 2) + ((((v1279 * v1343) + (v1276 * v1341)) - (0.34 : Float)) ^ 2)))
  let v1356 := (((((Float.tanh (((((((((((((((((W2[1 * 16 + 0]! * v941) + (W2[1 * 16 + 1]! * v958)) + (W2[1 * 16 + 2]! * v975)) + (W2[1 * 16 + 3]! * v992)) + (W2[1 * 16 + 4]! * v1009)) + (W2[1 * 16 + 5]! * v1026)) + (W2[1 * 16 + 6]! * v1043)) + (W2[1 * 16 + 7]! * v1060)) + (W2[1 * 16 + 8]! * v1077)) + (W2[1 * 16 + 9]! * v1094)) + (W2[1 * 16 + 10]! * v1111)) + (W2[1 * 16 + 11]! * v1128)) + (W2[1 * 16 + 12]! * v1145)) + (W2[1 * 16 + 13]! * v1162)) + (W2[1 * 16 + 14]! * v1179)) + (W2[1 * 16 + 15]! * v1196)) + b2_1)) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1292) / rDrum) * rDrum)
  let v1358 := ((v1291 + slack) - (v1356 * dt))
  let v1359 := (v1358 < v1354)
  let v1360 := (v1340 < v1358)
  let v1362 := (if v1359 then v1354 else (if v1360 then v1340 else v1358))
  let v1367 := (((0 : Float) + v1326) / (2 : Float))
  let v1368 := (Float.cos v1367)
  let v1370 := (Float.sin v1367)
  let v1382 := (v1362 < (Float.sqrt (((((v1267 * v1368) + (v1276 * v1370)) - v1264) ^ 2) + ((((v1279 * v1370) + (v1276 * v1368)) - (0.34 : Float)) ^ 2))))
  let v1383 := (if v1382 then v1367 else (0 : Float))
  let v1384 := (if v1382 then v1326 else v1367)
  let v1386 := ((v1383 + v1384) / (2 : Float))
  let v1387 := (Float.cos v1386)
  let v1389 := (Float.sin v1386)
  let v1401 := (v1362 < (Float.sqrt (((((v1267 * v1387) + (v1276 * v1389)) - v1264) ^ 2) + ((((v1279 * v1389) + (v1276 * v1387)) - (0.34 : Float)) ^ 2))))
  let v1402 := (if v1401 then v1386 else v1383)
  let v1403 := (if v1401 then v1384 else v1386)
  let v1405 := ((v1402 + v1403) / (2 : Float))
  let v1406 := (Float.cos v1405)
  let v1408 := (Float.sin v1405)
  let v1420 := (v1362 < (Float.sqrt (((((v1267 * v1406) + (v1276 * v1408)) - v1264) ^ 2) + ((((v1279 * v1408) + (v1276 * v1406)) - (0.34 : Float)) ^ 2))))
  let v1421 := (if v1420 then v1405 else v1402)
  let v1422 := (if v1420 then v1403 else v1405)
  let v1424 := ((v1421 + v1422) / (2 : Float))
  let v1425 := (Float.cos v1424)
  let v1427 := (Float.sin v1424)
  let v1439 := (v1362 < (Float.sqrt (((((v1267 * v1425) + (v1276 * v1427)) - v1264) ^ 2) + ((((v1279 * v1427) + (v1276 * v1425)) - (0.34 : Float)) ^ 2))))
  let v1440 := (if v1439 then v1424 else v1421)
  let v1441 := (if v1439 then v1422 else v1424)
  let v1443 := ((v1440 + v1441) / (2 : Float))
  let v1444 := (Float.cos v1443)
  let v1446 := (Float.sin v1443)
  let v1458 := (v1362 < (Float.sqrt (((((v1267 * v1444) + (v1276 * v1446)) - v1264) ^ 2) + ((((v1279 * v1446) + (v1276 * v1444)) - (0.34 : Float)) ^ 2))))
  let v1459 := (if v1458 then v1443 else v1440)
  let v1460 := (if v1458 then v1441 else v1443)
  let v1462 := ((v1459 + v1460) / (2 : Float))
  let v1463 := (Float.cos v1462)
  let v1465 := (Float.sin v1462)
  let v1477 := (v1362 < (Float.sqrt (((((v1267 * v1463) + (v1276 * v1465)) - v1264) ^ 2) + ((((v1279 * v1465) + (v1276 * v1463)) - (0.34 : Float)) ^ 2))))
  let v1478 := (if v1477 then v1462 else v1459)
  let v1479 := (if v1477 then v1460 else v1462)
  let v1481 := ((v1478 + v1479) / (2 : Float))
  let v1482 := (Float.cos v1481)
  let v1484 := (Float.sin v1481)
  let v1496 := (v1362 < (Float.sqrt (((((v1267 * v1482) + (v1276 * v1484)) - v1264) ^ 2) + ((((v1279 * v1484) + (v1276 * v1482)) - (0.34 : Float)) ^ 2))))
  let v1497 := (if v1496 then v1481 else v1478)
  let v1498 := (if v1496 then v1479 else v1481)
  let v1500 := ((v1497 + v1498) / (2 : Float))
  let v1501 := (Float.cos v1500)
  let v1503 := (Float.sin v1500)
  let v1515 := (v1362 < (Float.sqrt (((((v1267 * v1501) + (v1276 * v1503)) - v1264) ^ 2) + ((((v1279 * v1503) + (v1276 * v1501)) - (0.34 : Float)) ^ 2))))
  let v1516 := (if v1515 then v1500 else v1497)
  let v1517 := (if v1515 then v1498 else v1500)
  let v1519 := ((v1516 + v1517) / (2 : Float))
  let v1520 := (Float.cos v1519)
  let v1522 := (Float.sin v1519)
  let v1534 := (v1362 < (Float.sqrt (((((v1267 * v1520) + (v1276 * v1522)) - v1264) ^ 2) + ((((v1279 * v1522) + (v1276 * v1520)) - (0.34 : Float)) ^ 2))))
  let v1535 := (if v1534 then v1519 else v1516)
  let v1536 := (if v1534 then v1517 else v1519)
  let v1538 := ((v1535 + v1536) / (2 : Float))
  let v1539 := (Float.cos v1538)
  let v1541 := (Float.sin v1538)
  let v1553 := (v1362 < (Float.sqrt (((((v1267 * v1539) + (v1276 * v1541)) - v1264) ^ 2) + ((((v1279 * v1541) + (v1276 * v1539)) - (0.34 : Float)) ^ 2))))
  let v1554 := (if v1553 then v1538 else v1535)
  let v1555 := (if v1553 then v1536 else v1538)
  let v1557 := ((v1554 + v1555) / (2 : Float))
  let v1558 := (Float.cos v1557)
  let v1560 := (Float.sin v1557)
  let v1572 := (v1362 < (Float.sqrt (((((v1267 * v1558) + (v1276 * v1560)) - v1264) ^ 2) + ((((v1279 * v1560) + (v1276 * v1558)) - (0.34 : Float)) ^ 2))))
  let v1573 := (if v1572 then v1557 else v1554)
  let v1574 := (if v1572 then v1555 else v1557)
  let v1576 := ((v1573 + v1574) / (2 : Float))
  let v1577 := (Float.cos v1576)
  let v1579 := (Float.sin v1576)
  let v1591 := (v1362 < (Float.sqrt (((((v1267 * v1577) + (v1276 * v1579)) - v1264) ^ 2) + ((((v1279 * v1579) + (v1276 * v1577)) - (0.34 : Float)) ^ 2))))
  let v1592 := (if v1591 then v1576 else v1573)
  let v1593 := (if v1591 then v1574 else v1576)
  let v1595 := ((v1592 + v1593) / (2 : Float))
  let v1596 := (Float.cos v1595)
  let v1598 := (Float.sin v1595)
  let v1610 := (v1362 < (Float.sqrt (((((v1267 * v1596) + (v1276 * v1598)) - v1264) ^ 2) + ((((v1279 * v1598) + (v1276 * v1596)) - (0.34 : Float)) ^ 2))))
  let v1611 := (if v1610 then v1595 else v1592)
  let v1612 := (if v1610 then v1593 else v1595)
  let v1614 := ((v1611 + v1612) / (2 : Float))
  let v1615 := (Float.cos v1614)
  let v1617 := (Float.sin v1614)
  let v1629 := (v1362 < (Float.sqrt (((((v1267 * v1615) + (v1276 * v1617)) - v1264) ^ 2) + ((((v1279 * v1617) + (v1276 * v1615)) - (0.34 : Float)) ^ 2))))
  let v1630 := (if v1629 then v1614 else v1611)
  let v1631 := (if v1629 then v1612 else v1614)
  let v1633 := ((v1630 + v1631) / (2 : Float))
  let v1634 := (Float.cos v1633)
  let v1636 := (Float.sin v1633)
  let v1648 := (v1362 < (Float.sqrt (((((v1267 * v1634) + (v1276 * v1636)) - v1264) ^ 2) + ((((v1279 * v1636) + (v1276 * v1634)) - (0.34 : Float)) ^ 2))))
  let v1649 := (if v1648 then v1633 else v1630)
  let v1650 := (if v1648 then v1631 else v1633)
  let v1652 := ((v1649 + v1650) / (2 : Float))
  let v1653 := (Float.cos v1652)
  let v1655 := (Float.sin v1652)
  let v1667 := (v1362 < (Float.sqrt (((((v1267 * v1653) + (v1276 * v1655)) - v1264) ^ 2) + ((((v1279 * v1655) + (v1276 * v1653)) - (0.34 : Float)) ^ 2))))
  let v1668 := (if v1667 then v1652 else v1649)
  let v1669 := (if v1667 then v1650 else v1652)
  let v1671 := ((v1668 + v1669) / (2 : Float))
  let v1672 := (Float.cos v1671)
  let v1674 := (Float.sin v1671)
  let v1686 := (v1362 < (Float.sqrt (((((v1267 * v1672) + (v1276 * v1674)) - v1264) ^ 2) + ((((v1279 * v1674) + (v1276 * v1672)) - (0.34 : Float)) ^ 2))))
  let v1687 := (if v1686 then v1671 else v1668)
  let v1688 := (if v1686 then v1669 else v1671)
  let v1690 := ((v1687 + v1688) / (2 : Float))
  let v1691 := (Float.cos v1690)
  let v1693 := (Float.sin v1690)
  let v1705 := (v1362 < (Float.sqrt (((((v1267 * v1691) + (v1276 * v1693)) - v1264) ^ 2) + ((((v1279 * v1693) + (v1276 * v1691)) - (0.34 : Float)) ^ 2))))
  let v1706 := (if v1705 then v1690 else v1687)
  let v1707 := (if v1705 then v1688 else v1690)
  let v1709 := ((v1706 + v1707) / (2 : Float))
  let v1710 := (Float.cos v1709)
  let v1712 := (Float.sin v1709)
  let v1724 := (v1362 < (Float.sqrt (((((v1267 * v1710) + (v1276 * v1712)) - v1264) ^ 2) + ((((v1279 * v1712) + (v1276 * v1710)) - (0.34 : Float)) ^ 2))))
  let v1725 := (if v1724 then v1709 else v1706)
  let v1726 := (if v1724 then v1707 else v1709)
  let v1728 := ((v1725 + v1726) / (2 : Float))
  let v1729 := (Float.cos v1728)
  let v1731 := (Float.sin v1728)
  let v1743 := (v1362 < (Float.sqrt (((((v1267 * v1729) + (v1276 * v1731)) - v1264) ^ 2) + ((((v1279 * v1731) + (v1276 * v1729)) - (0.34 : Float)) ^ 2))))
  let v1744 := (if v1743 then v1728 else v1725)
  let v1745 := (if v1743 then v1726 else v1728)
  let v1747 := ((v1744 + v1745) / (2 : Float))
  let v1748 := (Float.cos v1747)
  let v1750 := (Float.sin v1747)
  let v1762 := (v1362 < (Float.sqrt (((((v1267 * v1748) + (v1276 * v1750)) - v1264) ^ 2) + ((((v1279 * v1750) + (v1276 * v1748)) - (0.34 : Float)) ^ 2))))
  let v1763 := (if v1762 then v1747 else v1744)
  let v1764 := (if v1762 then v1745 else v1747)
  let v1766 := ((v1763 + v1764) / (2 : Float))
  let v1767 := (Float.cos v1766)
  let v1769 := (Float.sin v1766)
  let v1781 := (v1362 < (Float.sqrt (((((v1267 * v1767) + (v1276 * v1769)) - v1264) ^ 2) + ((((v1279 * v1769) + (v1276 * v1767)) - (0.34 : Float)) ^ 2))))
  let v1782 := (if v1781 then v1766 else v1763)
  let v1783 := (if v1781 then v1764 else v1766)
  let v1785 := ((v1782 + v1783) / (2 : Float))
  let v1786 := (Float.cos v1785)
  let v1788 := (Float.sin v1785)
  let v1800 := (v1362 < (Float.sqrt (((((v1267 * v1786) + (v1276 * v1788)) - v1264) ^ 2) + ((((v1279 * v1788) + (v1276 * v1786)) - (0.34 : Float)) ^ 2))))
  let v1801 := (if v1800 then v1785 else v1782)
  let v1802 := (if v1800 then v1783 else v1785)
  let v1804 := ((v1801 + v1802) / (2 : Float))
  let v1805 := (Float.cos v1804)
  let v1807 := (Float.sin v1804)
  let v1819 := (v1362 < (Float.sqrt (((((v1267 * v1805) + (v1276 * v1807)) - v1264) ^ 2) + ((((v1279 * v1807) + (v1276 * v1805)) - (0.34 : Float)) ^ 2))))
  let v1824 := (if (v1340 <= v1358) then (0 : Float) else (((if v1819 then v1804 else v1801) + (if v1819 then v1802 else v1804)) / (2 : Float)))
  let v1825 := (W * rcm)
  let v1826 := (Float.cos v1824)
  let v1828 := (Float.sin v1824)
  let v1830 := ((v1267 * v1826) + (v1276 * v1828))
  let v1833 := ((v1279 * v1828) + (v1276 * v1826))
  let v1848 := ((t < v1824) && (!(v1825 <= (Tmax * (((v1264 * v1833) - ((0.34 : Float) * v1830)) / (Float.sqrt (((v1830 - v1264) ^ 2) + ((v1833 - (0.34 : Float)) ^ 2))))))))
  let v1849 := (if v1848 then t else v1824)
  let v1854 := (az + (((((((Float.tanh (((((((((((((((((W2[0 * 16 + 0]! * v941) + (W2[0 * 16 + 1]! * v958)) + (W2[0 * 16 + 2]! * v975)) + (W2[0 * 16 + 3]! * v992)) + (W2[0 * 16 + 4]! * v1009)) + (W2[0 * 16 + 5]! * v1026)) + (W2[0 * 16 + 6]! * v1043)) + (W2[0 * 16 + 7]! * v1060)) + (W2[0 * 16 + 8]! * v1077)) + (W2[0 * 16 + 9]! * v1094)) + (W2[0 * 16 + 10]! * v1111)) + (W2[0 * 16 + 11]! * v1128)) + (W2[0 * 16 + 12]! * v1145)) + (W2[0 * 16 + 13]! * v1162)) + (W2[0 * 16 + 14]! * v1179)) + (W2[0 * 16 + 15]! * v1196)) + b2_0)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1308) / (0.05 : Float)) * (0.05 : Float)) / v1308) * dt))
  let v1859 := (Float.cos v1849)
  let v1861 := (Float.sin v1849)
  let v1863 := ((v1267 * v1859) + (v1276 * v1861))
  let v1866 := ((v1279 * v1861) + (v1276 * v1859))
  let v1881 := (v866 - v1326)
  let v1882 := (v1881 <= elSun)
  let v1891 := (Float.cos v1854)
  let v1892 := (v1861 * v1891)
  let v1893 := (Float.sin v1854)
  let v1894 := (v1861 * v1893)
  let v1895 := (v1859 * v1891)
  let v1896 := (v1859 * v1893)
  let v1897 := (-v1861)
  let v1922 := ((2 : Float) * a)
  let v1923 := (v1922 / w)
  let v1925 := (w / (2 : Float))
  let v1926 := ((-a) + v1925)
  let v1945 := ((1 : Float) / (2 : Float))
  let v1950 := (-(((((v1896 * v1859) - (v1897 * v1894)) * v885) + (((v1897 * v1892) - (v1895 * v1859)) * v887)) + (((v1895 * v1894) - (v1896 * v1892)) * v888)))
  let v1951 := (-(((v1895 * v885) + (v1896 * v887)) + (v1897 * v888)))
  let v1952 := (-(((v1892 * v885) + (v1894 * v887)) + (v1859 * v888)))
  let v1957 := ((Float.abs v1952) < ((9 : Float) / (10 : Float)))
  let v1958 := (if v1957 then (0 : Float) else (1 : Float))
  let v1959 := (if v1957 then (1 : Float) else (0 : Float))
  let v1962 := ((v1951 * v1959) - (v1952 * (0 : Float)))
  let v1965 := ((v1952 * v1958) - (v1950 * v1959))
  let v1968 := ((v1950 * (0 : Float)) - (v1951 * v1958))
  let v1976 := (Float.sqrt (max (((v1962 ^ 2) + (v1965 ^ 2)) + (v1968 ^ 2)) (0.000000000000000001 : Float)))
  let v1977 := (v1962 / v1976)
  let v1978 := (v1965 / v1976)
  let v1979 := (v1968 / v1976)
  let v2027 := ((2 : Float) * f)
  let v2028 := ((1 : Float) / R)
  let v2138 := ((v1922 ^ 2) * rho)
  let v2144 := ((List.range 64).foldl (fun acc i => acc + (let v1940 := (v1926 + (w * (Float.floor (dr[i * 10 + 0]! * v1923)))); let v1944 := (v1926 + (w * (Float.floor (dr[i * 10 + 1]! * v1923)))); let v1947 := ((dr[i * 10 + 2]! - v1945) * w); let v1949 := ((dr[i * 10 + 3]! - v1945) * w); let v1990 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1991 := (v860 * dr[i * 10 + 5]!); let v1992 := (Float.cos v1990); let v1994 := (Float.sin v1990); let v1995 := (Float.cos v1991); let v1997 := (Float.sin v1991); let v2001 := ((v1992 * v1950) + (v1994 * ((v1995 * v1977) + (v1997 * ((v1951 * v1979) - (v1952 * v1978)))))); let v2007 := ((v1992 * v1951) + (v1994 * ((v1995 * v1978) + (v1997 * ((v1952 * v1977) - (v1950 * v1979)))))); let v2013 := ((v1992 * v1952) + (v1994 * ((v1995 * v1979) + (v1997 * ((v1950 * v1978) - (v1951 * v1977)))))); let v2024 := (((Float.abs v1940) <= a) && (((Float.abs v1944) <= a) && (((Float.abs v1947) <= v1925) && ((Float.abs v1949) <= v1925)))); let v2025 := (v1940 + v1947); let v2026 := (v1944 + v1949); let v2033 := (Float.sqrt (max ((v1940 ^ 2) + (v1944 ^ 2)) (0.000000000000000001 : Float))); let v2034 := (v2033 ^ 2); let v2040 := ((1 : Float) - ((((1 : Float) + k) * (v2028 ^ 2)) * v2034)); let v2048 := ((v2028 * v2033) / (Float.sqrt (max v2040 (0.000000000000000001 : Float)))); let v2051 := (Float.sqrt ((1 : Float) + (v2048 ^ 2))); let v2052 := (-v2048); let v2055 := (((v2052 * v1940) / v2033) / v2051); let v2058 := (((v2052 * v1944) / v2033) / v2051); let v2059 := ((1 : Float) / v2051); let v2061 := (v2055 + (sigmaslope * dr[i * 10 + 6]!)); let v2063 := (v2058 + (sigmaslope * dr[i * 10 + 7]!)); let v2069 := (Float.sqrt (((v2061 ^ 2) + (v2063 ^ 2)) + (v2059 ^ 2))); let v2070 := (v2061 / v2069); let v2071 := (v2063 / v2069); let v2072 := (v2059 / v2069); let v2086 := (((((v1940 - v2025) * v2055) + ((v1944 - v2026) * v2058)) + ((((v2028 * v2034) / ((1 : Float) + (Float.sqrt (max v2040 (0 : Float))))) - v2027) * v2059)) / (((v2001 * v2055) + (v2007 * v2058)) + (v2013 * v2059))); let v2098 := ((2 : Float) * (((v2001 * v2070) + (v2007 * v2071)) + (v2013 * v2072))); let v2104 := (v2013 - (v2098 * v2072)); let v2106 := ((v2001 - (v2098 * v2070)) + (sigmaspec * dr[i * 10 + 8]!)); let v2108 := ((v2007 - (v2098 * v2071)) + (sigmaspec * dr[i * 10 + 9]!)); let v2114 := (Float.sqrt (((v2106 ^ 2) + (v2108 ^ 2)) + (v2104 ^ 2))); let v2117 := (v2104 / v2114); let v2119 := ((f - (v2027 + (v2086 * v2013))) / v2117); let v2127 := (Float.sqrt ((((v2025 + (v2086 * v2001)) + (v2119 * (v2106 / v2114))) ^ 2) + (((v2026 + (v2086 * v2007)) + (v2119 * (v2108 / v2114))) ^ 2))); let v2129 := ((0 : Float) < v2117); let v2130 := ((v2127 <= rc) && v2129); let v2132 := (if (v2024 && v2130) then (1 : Float) else (0 : Float)); v2132)) 0.0)
  let v2147 := ((List.range 64).foldl (fun acc i => acc + (let v1940 := (v1926 + (w * (Float.floor (dr[i * 10 + 0]! * v1923)))); let v1944 := (v1926 + (w * (Float.floor (dr[i * 10 + 1]! * v1923)))); let v1947 := ((dr[i * 10 + 2]! - v1945) * w); let v1949 := ((dr[i * 10 + 3]! - v1945) * w); let v1990 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1991 := (v860 * dr[i * 10 + 5]!); let v1992 := (Float.cos v1990); let v1994 := (Float.sin v1990); let v1995 := (Float.cos v1991); let v1997 := (Float.sin v1991); let v2001 := ((v1992 * v1950) + (v1994 * ((v1995 * v1977) + (v1997 * ((v1951 * v1979) - (v1952 * v1978)))))); let v2007 := ((v1992 * v1951) + (v1994 * ((v1995 * v1978) + (v1997 * ((v1952 * v1977) - (v1950 * v1979)))))); let v2013 := ((v1992 * v1952) + (v1994 * ((v1995 * v1979) + (v1997 * ((v1950 * v1978) - (v1951 * v1977)))))); let v2024 := (((Float.abs v1940) <= a) && (((Float.abs v1944) <= a) && (((Float.abs v1947) <= v1925) && ((Float.abs v1949) <= v1925)))); let v2025 := (v1940 + v1947); let v2026 := (v1944 + v1949); let v2033 := (Float.sqrt (max ((v1940 ^ 2) + (v1944 ^ 2)) (0.000000000000000001 : Float))); let v2034 := (v2033 ^ 2); let v2040 := ((1 : Float) - ((((1 : Float) + k) * (v2028 ^ 2)) * v2034)); let v2048 := ((v2028 * v2033) / (Float.sqrt (max v2040 (0.000000000000000001 : Float)))); let v2051 := (Float.sqrt ((1 : Float) + (v2048 ^ 2))); let v2052 := (-v2048); let v2055 := (((v2052 * v1940) / v2033) / v2051); let v2058 := (((v2052 * v1944) / v2033) / v2051); let v2059 := ((1 : Float) / v2051); let v2061 := (v2055 + (sigmaslope * dr[i * 10 + 6]!)); let v2063 := (v2058 + (sigmaslope * dr[i * 10 + 7]!)); let v2069 := (Float.sqrt (((v2061 ^ 2) + (v2063 ^ 2)) + (v2059 ^ 2))); let v2070 := (v2061 / v2069); let v2071 := (v2063 / v2069); let v2072 := (v2059 / v2069); let v2086 := (((((v1940 - v2025) * v2055) + ((v1944 - v2026) * v2058)) + ((((v2028 * v2034) / ((1 : Float) + (Float.sqrt (max v2040 (0 : Float))))) - v2027) * v2059)) / (((v2001 * v2055) + (v2007 * v2058)) + (v2013 * v2059))); let v2098 := ((2 : Float) * (((v2001 * v2070) + (v2007 * v2071)) + (v2013 * v2072))); let v2104 := (v2013 - (v2098 * v2072)); let v2106 := ((v2001 - (v2098 * v2070)) + (sigmaspec * dr[i * 10 + 8]!)); let v2108 := ((v2007 - (v2098 * v2071)) + (sigmaspec * dr[i * 10 + 9]!)); let v2114 := (Float.sqrt (((v2106 ^ 2) + (v2108 ^ 2)) + (v2104 ^ 2))); let v2117 := (v2104 / v2114); let v2119 := ((f - (v2027 + (v2086 * v2013))) / v2117); let v2127 := (Float.sqrt ((((v2025 + (v2086 * v2001)) + (v2119 * (v2106 / v2114))) ^ 2) + (((v2026 + (v2086 * v2007)) + (v2119 * (v2108 / v2114))) ^ 2))); let v2129 := ((0 : Float) < v2117); let v2130 := ((v2127 <= rc) && v2129); let v2132 := (if (v2024 && v2130) then (1 : Float) else (0 : Float)); (1.0 / (1.0 + Float.exp (-((rc - v2127) / (0.005 : Float))))))) 0.0)
  let v2161 := (Toil - Ta)
  #[v1854, v1849, (if v1360 then (v1358 - v1340) else (0 : Float)), (if v1848 then v1291 else v1362), v1326, (if (v1359 || v1848) then (1 : Float) else (0 : Float)), (if (feq (if v1360 then (v1358 - v1340) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1825 <= (Tmax * (((v1264 * v1866) - ((0.34 : Float) * v1863)) / (Float.sqrt (((v1863 - v1264) ^ 2) + ((v1866 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), v1292, (v1356 / v1292), ((((((Float.tanh (((((((((((((((((W2[0 * 16 + 0]! * v941) + (W2[0 * 16 + 1]! * v958)) + (W2[0 * 16 + 2]! * v975)) + (W2[0 * 16 + 3]! * v992)) + (W2[0 * 16 + 4]! * v1009)) + (W2[0 * 16 + 5]! * v1026)) + (W2[0 * 16 + 6]! * v1043)) + (W2[0 * 16 + 7]! * v1060)) + (W2[0 * 16 + 8]! * v1077)) + (W2[0 * 16 + 9]! * v1094)) + (W2[0 * 16 + 10]! * v1111)) + (W2[0 * 16 + 11]! * v1128)) + (W2[0 * 16 + 12]! * v1145)) + (W2[0 * 16 + 13]! * v1162)) + (W2[0 * 16 + 14]! * v1179)) + (W2[0 * 16 + 15]! * v1196)) + b2_0)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1308) / (0.05 : Float)) * (0.05 : Float)) / v1308), v919, (v866 - t), (if v1882 then (1 : Float) else (0 : Float)), (if (v1882 && ((0.03 : Float) < v919)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1881) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1881) / (0.01 : Float))))) * v923), (v2144 / (64 : Float)), (v2147 / (64 : Float)), (v2138 * (v2144 / (64 : Float))), (((v2138 * (v2144 / (64 : Float))) * dni) * soil), (min ToilMax (Toil + ((dt * ((((alpha * (((v2138 * (v2144 / (64 : Float))) * dni) * soil)) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v2161))) - (Upipe * v2161)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * (((v2138 * (v2144 / (64 : Float))) * dni) * soil)), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v2161)), (Upipe * v2161), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * (((v2138 * (v2144 / (64 : Float))) * dni) * soil)) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v2161))) - (Upipe * v2161)) - (max (0 : Float) (UAx * (Toil - Twall)))), v865, v868, t, tautPrev, holdsPrev, v871, v876, v924, (Float.tanh (((((((((((((((((W2[0 * 16 + 0]! * v941) + (W2[0 * 16 + 1]! * v958)) + (W2[0 * 16 + 2]! * v975)) + (W2[0 * 16 + 3]! * v992)) + (W2[0 * 16 + 4]! * v1009)) + (W2[0 * 16 + 5]! * v1026)) + (W2[0 * 16 + 6]! * v1043)) + (W2[0 * 16 + 7]! * v1060)) + (W2[0 * 16 + 8]! * v1077)) + (W2[0 * 16 + 9]! * v1094)) + (W2[0 * 16 + 10]! * v1111)) + (W2[0 * 16 + 11]! * v1128)) + (W2[0 * 16 + 12]! * v1145)) + (W2[0 * 16 + 13]! * v1162)) + (W2[0 * 16 + 14]! * v1179)) + (W2[0 * 16 + 15]! * v1196)) + b2_0)), (Float.tanh (((((((((((((((((W2[1 * 16 + 0]! * v941) + (W2[1 * 16 + 1]! * v958)) + (W2[1 * 16 + 2]! * v975)) + (W2[1 * 16 + 3]! * v992)) + (W2[1 * 16 + 4]! * v1009)) + (W2[1 * 16 + 5]! * v1026)) + (W2[1 * 16 + 6]! * v1043)) + (W2[1 * 16 + 7]! * v1060)) + (W2[1 * 16 + 8]! * v1077)) + (W2[1 * 16 + 9]! * v1094)) + (W2[1 * 16 + 10]! * v1111)) + (W2[1 * 16 + 11]! * v1128)) + (W2[1 * 16 + 12]! * v1145)) + (W2[1 * 16 + 13]! * v1162)) + (W2[1 * 16 + 14]! * v1179)) + (W2[1 * 16 + 15]! * v1196)) + b2_1))]

#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.320123 1.261574 1.203025 1.144476 1.085928 1.027379 0.968830 0.910281 0.851732 0.793184 0.734635 0.676086 0.617537 0.558988 0.500440 0.441891 0.383342 0.324793 0.266244 0.207696 1.749147 1.690598 1.632049 1.573500 1.514952 1.456403 1.397854 1.339305 1.280756 1.222208 1.163659 1.105110 1.046561 0.988012 0.929464 0.870915 0.812366 0.753817 0.695268 0.636720 0.578171 #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507, 0.659958, 0.601409, 0.542860, 0.484312, 0.425763, 0.367214, 0.308665, 0.250116, 1.791568, 1.733019, 1.674470, 1.615921, 1.557372, 1.498824, 1.440275, 1.381726, 1.323177, 1.264628, 1.206080, 1.147531, 1.088982, 1.030433, 0.971884, 0.913336, 0.854787, 0.796238, 0.737689, 0.679140, 0.620592, 0.562043, 0.503494, 0.444945, 0.386396, 0.327848, 0.269299, 0.210750, 1.752201, 1.693652, 1.635104, 1.576555, 1.518006, 1.459457, 1.400908, 1.342360, 1.283811, 1.225262, 1.166713, 1.108164, 1.049616, 0.991067, 0.932518, 0.873969, 0.815420, 0.756872, 0.698323, 0.639774, 0.581225, 0.522676, 0.464128, 0.405579, 0.347030, 0.288481, 0.229932, 1.771384, 1.712835, 1.654286, 1.595737, 1.537188, 1.478640, 1.420091, 1.361542, 1.302993, 1.244444, 1.185896, 1.127347, 1.068798, 1.010249, 0.951700, 0.893152, 0.834603, 0.776054, 0.717505, 0.658956, 0.600408, 0.541859, 0.483310, 0.424761, 0.366212, 0.307664, 0.249115, 1.790566, 1.732017, 1.673468, 1.614920, 1.556371, 1.497822, 1.439273, 1.380724, 1.322176, 1.263627, 1.205078, 1.146529, 1.087980, 1.029432, 0.970883, 0.912334, 0.853785, 0.795236, 0.736688, 0.678139, 0.619590, 0.561041] #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507] #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507, 0.659958, 0.601409, 0.542860, 0.484312, 0.425763, 0.367214, 0.308665, 0.250116, 1.791568, 1.733019, 1.674470, 1.615921, 1.557372, 1.498824, 1.440275, 1.381726] #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507, 0.659958, 0.601409, 0.542860, 0.484312, 0.425763, 0.367214, 0.308665, 0.250116, 1.791568, 1.733019, 1.674470, 1.615921, 1.557372, 1.498824, 1.440275, 1.381726, 1.323177, 1.264628, 1.206080, 1.147531, 1.088982, 1.030433, 0.971884, 0.913336, 0.854787, 0.796238, 0.737689, 0.679140, 0.620592, 0.562043, 0.503494, 0.444945, 0.386396, 0.327848, 0.269299, 0.210750, 1.752201, 1.693652, 1.635104, 1.576555, 1.518006, 1.459457, 1.400908, 1.342360, 1.283811, 1.225262, 1.166713, 1.108164, 1.049616, 0.991067, 0.932518, 0.873969, 0.815420, 0.756872, 0.698323, 0.639774, 0.581225, 0.522676, 0.464128, 0.405579, 0.347030, 0.288481, 0.229932, 1.771384, 1.712835, 1.654286, 1.595737, 1.537188, 1.478640, 1.420091, 1.361542, 1.302993, 1.244444, 1.185896, 1.127347, 1.068798, 1.010249, 0.951700, 0.893152, 0.834603, 0.776054, 0.717505, 0.658956, 0.600408, 0.541859, 0.483310, 0.424761, 0.366212, 0.307664, 0.249115, 1.790566, 1.732017, 1.673468, 1.614920, 1.556371, 1.497822, 1.439273, 1.380724, 1.322176, 1.263627, 1.205078, 1.146529, 1.087980, 1.029432, 0.970883, 0.912334, 0.853785, 0.795236, 0.736688, 0.678139, 0.619590, 0.561041, 0.502492, 0.443944, 0.385395, 0.326846, 0.268297, 0.209748, 1.751200, 1.692651, 1.634102, 1.575553, 1.517004, 1.458456, 1.399907, 1.341358, 1.282809, 1.224260, 1.165712, 1.107163, 1.048614, 0.990065, 0.931516, 0.872968, 0.814419, 0.755870, 0.697321, 0.638772, 0.580224, 0.521675, 0.463126, 0.404577, 0.346028, 0.287480, 0.228931, 1.770382, 1.711833, 1.653284, 1.594736, 1.536187, 1.477638, 1.419089, 1.360540, 1.301992, 1.243443, 1.184894, 1.126345, 1.067796, 1.009248, 0.950699, 0.892150, 0.833601, 0.775052, 0.716504, 0.657955, 0.599406, 0.540857, 0.482308, 0.423760, 0.365211, 0.306662, 0.248113, 1.789564, 1.731016, 1.672467, 1.613918, 1.555369, 1.496820, 1.438272, 1.379723, 1.321174, 1.262625, 1.204076, 1.145528, 1.086979, 1.028430, 0.969881, 0.911332, 0.852784, 0.794235, 0.735686, 0.677137, 0.618588, 0.560040, 0.501491, 0.442942, 0.384393, 0.325844, 0.267296, 0.208747, 1.750198, 1.691649, 1.633100, 1.574552, 1.516003, 1.457454, 1.398905, 1.340356, 1.281808, 1.223259, 1.164710, 1.106161, 1.047612, 0.989064, 0.930515, 0.871966, 0.813417, 0.754868, 0.696320, 0.637771, 0.579222, 0.520673, 0.462124, 0.403576, 0.345027, 0.286478, 0.227929, 1.769380, 1.710832, 1.652283, 1.593734, 1.535185, 1.476636, 1.418088, 1.359539, 1.300990, 1.242441, 1.183892, 1.125344, 1.066795, 1.008246, 0.949697, 0.891148, 0.832600, 0.774051, 0.715502, 0.656953, 0.598404, 0.539856, 0.481307, 0.422758, 0.364209, 0.305660, 0.247112, 1.788563, 1.730014, 1.671465, 1.612916, 1.554368, 1.495819, 1.437270, 1.378721, 1.320172, 1.261624, 1.203075, 1.144526, 1.085977, 1.027428, 0.968880, 0.910331, 0.851782, 0.793233, 0.734684, 0.676136, 0.617587, 0.559038, 0.500489, 0.441940, 0.383392, 0.324843, 0.266294, 0.207745, 1.749196, 1.690648, 1.632099, 1.573550, 1.515001, 1.456452, 1.397904, 1.339355, 1.280806, 1.222257, 1.163708, 1.105160, 1.046611, 0.988062, 0.929513, 0.870964, 0.812416, 0.753867, 0.695318, 0.636769, 0.578220, 0.519672, 0.461123, 0.402574, 0.344025, 0.285476, 0.226928, 1.768379, 1.709830, 1.651281, 1.592732, 1.534184, 1.475635, 1.417086, 1.358537, 1.299988, 1.241440, 1.182891, 1.124342, 1.065793, 1.007244, 0.948696, 0.890147, 0.831598, 0.773049, 0.714500, 0.655952, 0.597403, 0.538854, 0.480305, 0.421756, 0.363208, 0.304659, 0.246110, 1.787561, 1.729012, 1.670464, 1.611915, 1.553366, 1.494817, 1.436268, 1.377720, 1.319171, 1.260622, 1.202073, 1.143524, 1.084976, 1.026427, 0.967878, 0.909329, 0.850780, 0.792232, 0.733683, 0.675134, 0.616585, 0.558036, 0.499488, 0.440939, 0.382390, 0.323841, 0.265292, 0.206744, 1.748195, 1.689646, 1.631097, 1.572548, 1.514000, 1.455451, 1.396902, 1.338353, 1.279804, 1.221256, 1.162707, 1.104158, 1.045609, 0.987060, 0.928512, 0.869963, 0.811414, 0.752865, 0.694316, 0.635768, 0.577219, 0.518670, 0.460121, 0.401572, 0.343024, 0.284475, 0.225926, 1.767377, 1.708828, 1.650280, 1.591731, 1.533182, 1.474633, 1.416084, 1.357536, 1.298987, 1.240438, 1.181889, 1.123340, 1.064792, 1.006243, 0.947694, 0.889145, 0.830596, 0.772048, 0.713499, 0.654950, 0.596401, 0.537852, 0.479304, 0.420755, 0.362206, 0.303657, 0.245108, 1.786560, 1.728011, 1.669462, 1.610913, 1.552364, 1.493816, 1.435267, 1.376718, 1.318169, 1.259620, 1.201072, 1.142523, 1.083974, 1.025425, 0.966876, 0.908328, 0.849779, 0.791230, 0.732681, 0.674132, 0.615584, 0.557035, 0.498486, 0.439937, 0.381388, 0.322840, 0.264291, 0.205742, 1.747193, 1.688644, 1.630096, 1.571547, 1.512998, 1.454449, 1.395900, 1.337352, 1.278803, 1.220254, 1.161705, 1.103156, 1.044608, 0.986059, 0.927510, 0.868961, 0.810412, 0.751864, 0.693315, 0.634766, 0.576217, 0.517668, 0.459120, 0.400571, 0.342022, 0.283473, 0.224924, 1.766376, 1.707827, 1.649278, 1.590729, 1.532180, 1.473632, 1.415083, 1.356534, 1.297985, 1.239436, 1.180888, 1.122339, 1.063790, 1.005241, 0.946692, 0.888144, 0.829595, 0.771046, 0.712497, 0.653948, 0.595400, 0.536851, 0.478302, 0.419753, 0.361204, 0.302656, 0.244107, 1.785558, 1.727009, 1.668460, 1.609912, 1.551363, 1.492814, 1.434265, 1.375716, 1.317168, 1.258619, 1.200070, 1.141521, 1.082972, 1.024424, 0.965875, 0.907326, 0.848777, 0.790228, 0.731680, 0.673131, 0.614582, 0.556033, 0.497484, 0.438936, 0.380387, 0.321838, 0.263289, 0.204740, 1.746192, 1.687643, 1.629094, 1.570545, 1.511996, 1.453448, 1.394899, 1.336350, 1.277801, 1.219252, 1.160704, 1.102155, 1.043606, 0.985057, 0.926508, 0.867960, 0.809411, 0.750862, 0.692313, 0.633764, 0.575216, 0.516667, 0.458118, 0.399569, 0.341020, 0.282472, 0.223923, 1.765374, 1.706825, 1.648276, 1.589728, 1.531179, 1.472630, 1.414081, 1.355532, 1.296984, 1.238435, 1.179886, 1.121337, 1.062788, 1.004240, 0.945691, 0.887142, 0.828593, 0.770044, 0.711496, 0.652947, 0.594398, 0.535849, 0.477300, 0.418752, 0.360203, 0.301654, 0.243105, 1.784556, 1.726008, 1.667459, 1.608910, 1.550361, 1.491812, 1.433264, 1.374715, 1.316166, 1.257617, 1.199068, 1.140520, 1.081971, 1.023422, 0.964873, 0.906324, 0.847776, 0.789227, 0.730678, 0.672129, 0.613580, 0.555032, 0.496483, 0.437934, 0.379385, 0.320836, 0.262288, 0.203739, 1.745190, 1.686641, 1.628092, 1.569544, 1.510995, 1.452446, 1.393897, 1.335348, 1.276800, 1.218251, 1.159702, 1.101153, 1.042604, 0.984056]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.988931 0.930382 0.871833 0.813284 0.754736 0.696187 0.637638 0.579089 0.520540 0.461992 0.403443 0.344894 0.286345 0.227796 1.769248 1.710699 1.652150 1.593601 1.535052 1.476504 1.417955 1.359406 1.300857 1.242308 1.183760 1.125211 1.066662 1.008113 0.949564 0.891016 0.832467 0.773918 0.715369 0.656820 0.598272 0.539723 0.481174 0.422625 0.364076 0.305528 0.246979 #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315, 0.328766, 0.270217, 0.211668, 1.753120, 1.694571, 1.636022, 1.577473, 1.518924, 1.460376, 1.401827, 1.343278, 1.284729, 1.226180, 1.167632, 1.109083, 1.050534, 0.991985, 0.933436, 0.874888, 0.816339, 0.757790, 0.699241, 0.640692, 0.582144, 0.523595, 0.465046, 0.406497, 0.347948, 0.289400, 0.230851, 1.772302, 1.713753, 1.655204, 1.596656, 1.538107, 1.479558, 1.421009, 1.362460, 1.303912, 1.245363, 1.186814, 1.128265, 1.069716, 1.011168, 0.952619, 0.894070, 0.835521, 0.776972, 0.718424, 0.659875, 0.601326, 0.542777, 0.484228, 0.425680, 0.367131, 0.308582, 0.250033, 1.791484, 1.732936, 1.674387, 1.615838, 1.557289, 1.498740, 1.440192, 1.381643, 1.323094, 1.264545, 1.205996, 1.147448, 1.088899, 1.030350, 0.971801, 0.913252, 0.854704, 0.796155, 0.737606, 0.679057, 0.620508, 0.561960, 0.503411, 0.444862, 0.386313, 0.327764, 0.269216, 0.210667, 1.752118, 1.693569, 1.635020, 1.576472, 1.517923, 1.459374, 1.400825, 1.342276, 1.283728, 1.225179, 1.166630, 1.108081, 1.049532, 0.990984, 0.932435, 0.873886, 0.815337, 0.756788, 0.698240, 0.639691, 0.581142, 0.522593, 0.464044, 0.405496, 0.346947, 0.288398, 0.229849] #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315] #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315, 0.328766, 0.270217, 0.211668, 1.753120, 1.694571, 1.636022, 1.577473, 1.518924, 1.460376, 1.401827, 1.343278, 1.284729, 1.226180, 1.167632, 1.109083, 1.050534] #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315, 0.328766, 0.270217, 0.211668, 1.753120, 1.694571, 1.636022, 1.577473, 1.518924, 1.460376, 1.401827, 1.343278, 1.284729, 1.226180, 1.167632, 1.109083, 1.050534, 0.991985, 0.933436, 0.874888, 0.816339, 0.757790, 0.699241, 0.640692, 0.582144, 0.523595, 0.465046, 0.406497, 0.347948, 0.289400, 0.230851, 1.772302, 1.713753, 1.655204, 1.596656, 1.538107, 1.479558, 1.421009, 1.362460, 1.303912, 1.245363, 1.186814, 1.128265, 1.069716, 1.011168, 0.952619, 0.894070, 0.835521, 0.776972, 0.718424, 0.659875, 0.601326, 0.542777, 0.484228, 0.425680, 0.367131, 0.308582, 0.250033, 1.791484, 1.732936, 1.674387, 1.615838, 1.557289, 1.498740, 1.440192, 1.381643, 1.323094, 1.264545, 1.205996, 1.147448, 1.088899, 1.030350, 0.971801, 0.913252, 0.854704, 0.796155, 0.737606, 0.679057, 0.620508, 0.561960, 0.503411, 0.444862, 0.386313, 0.327764, 0.269216, 0.210667, 1.752118, 1.693569, 1.635020, 1.576472, 1.517923, 1.459374, 1.400825, 1.342276, 1.283728, 1.225179, 1.166630, 1.108081, 1.049532, 0.990984, 0.932435, 0.873886, 0.815337, 0.756788, 0.698240, 0.639691, 0.581142, 0.522593, 0.464044, 0.405496, 0.346947, 0.288398, 0.229849, 1.771300, 1.712752, 1.654203, 1.595654, 1.537105, 1.478556, 1.420008, 1.361459, 1.302910, 1.244361, 1.185812, 1.127264, 1.068715, 1.010166, 0.951617, 0.893068, 0.834520, 0.775971, 0.717422, 0.658873, 0.600324, 0.541776, 0.483227, 0.424678, 0.366129, 0.307580, 0.249032, 1.790483, 1.731934, 1.673385, 1.614836, 1.556288, 1.497739, 1.439190, 1.380641, 1.322092, 1.263544, 1.204995, 1.146446, 1.087897, 1.029348, 0.970800, 0.912251, 0.853702, 0.795153, 0.736604, 0.678056, 0.619507, 0.560958, 0.502409, 0.443860, 0.385312, 0.326763, 0.268214, 0.209665, 1.751116, 1.692568, 1.634019, 1.575470, 1.516921, 1.458372, 1.399824, 1.341275, 1.282726, 1.224177, 1.165628, 1.107080, 1.048531, 0.989982, 0.931433, 0.872884, 0.814336, 0.755787, 0.697238, 0.638689, 0.580140, 0.521592, 0.463043, 0.404494, 0.345945, 0.287396, 0.228848, 1.770299, 1.711750, 1.653201, 1.594652, 1.536104, 1.477555, 1.419006, 1.360457, 1.301908, 1.243360, 1.184811, 1.126262, 1.067713, 1.009164, 0.950616, 0.892067, 0.833518, 0.774969, 0.716420, 0.657872, 0.599323, 0.540774, 0.482225, 0.423676, 0.365128, 0.306579, 0.248030, 1.789481, 1.730932, 1.672384, 1.613835, 1.555286, 1.496737, 1.438188, 1.379640, 1.321091, 1.262542, 1.203993, 1.145444, 1.086896, 1.028347, 0.969798, 0.911249, 0.852700, 0.794152, 0.735603, 0.677054, 0.618505, 0.559956, 0.501408, 0.442859, 0.384310, 0.325761, 0.267212, 0.208664, 1.750115, 1.691566, 1.633017, 1.574468, 1.515920, 1.457371, 1.398822, 1.340273, 1.281724, 1.223176, 1.164627, 1.106078, 1.047529, 0.988980, 0.930432, 0.871883, 0.813334, 0.754785, 0.696236, 0.637688, 0.579139, 0.520590, 0.462041, 0.403492, 0.344944, 0.286395, 0.227846, 1.769297, 1.710748, 1.652200, 1.593651, 1.535102, 1.476553, 1.418004, 1.359456, 1.300907, 1.242358, 1.183809, 1.125260, 1.066712, 1.008163, 0.949614, 0.891065, 0.832516, 0.773968, 0.715419, 0.656870, 0.598321, 0.539772, 0.481224, 0.422675, 0.364126, 0.305577, 0.247028, 1.788480, 1.729931, 1.671382, 1.612833, 1.554284, 1.495736, 1.437187, 1.378638, 1.320089, 1.261540, 1.202992, 1.144443, 1.085894, 1.027345, 0.968796, 0.910248, 0.851699, 0.793150, 0.734601, 0.676052, 0.617504, 0.558955, 0.500406, 0.441857, 0.383308, 0.324760, 0.266211, 0.207662, 1.749113, 1.690564, 1.632016, 1.573467, 1.514918, 1.456369, 1.397820, 1.339272, 1.280723, 1.222174, 1.163625, 1.105076, 1.046528, 0.987979, 0.929430, 0.870881, 0.812332, 0.753784, 0.695235, 0.636686, 0.578137, 0.519588, 0.461040, 0.402491, 0.343942, 0.285393, 0.226844, 1.768296, 1.709747, 1.651198, 1.592649, 1.534100, 1.475552, 1.417003, 1.358454, 1.299905, 1.241356, 1.182808, 1.124259, 1.065710, 1.007161, 0.948612, 0.890064, 0.831515, 0.772966, 0.714417, 0.655868, 0.597320, 0.538771, 0.480222, 0.421673, 0.363124, 0.304576, 0.246027, 1.787478, 1.728929, 1.670380, 1.611832, 1.553283, 1.494734, 1.436185, 1.377636, 1.319088, 1.260539, 1.201990, 1.143441, 1.084892, 1.026344, 0.967795, 0.909246, 0.850697, 0.792148, 0.733600, 0.675051, 0.616502, 0.557953, 0.499404, 0.440856, 0.382307, 0.323758, 0.265209, 0.206660, 1.748112, 1.689563, 1.631014, 1.572465, 1.513916, 1.455368, 1.396819, 1.338270, 1.279721, 1.221172, 1.162624, 1.104075, 1.045526, 0.986977, 0.928428, 0.869880, 0.811331, 0.752782, 0.694233, 0.635684, 0.577136, 0.518587, 0.460038, 0.401489, 0.342940, 0.284392, 0.225843, 1.767294, 1.708745, 1.650196, 1.591648, 1.533099, 1.474550, 1.416001, 1.357452, 1.298904, 1.240355, 1.181806, 1.123257, 1.064708, 1.006160, 0.947611, 0.889062, 0.830513, 0.771964, 0.713416, 0.654867, 0.596318, 0.537769, 0.479220, 0.420672, 0.362123, 0.303574, 0.245025, 1.786476, 1.727928, 1.669379, 1.610830, 1.552281, 1.493732, 1.435184, 1.376635, 1.318086, 1.259537, 1.200988, 1.142440, 1.083891, 1.025342, 0.966793, 0.908244, 0.849696, 0.791147, 0.732598, 0.674049, 0.615500, 0.556952, 0.498403, 0.439854, 0.381305, 0.322756, 0.264208, 0.205659, 1.747110, 1.688561, 1.630012, 1.571464, 1.512915, 1.454366, 1.395817, 1.337268, 1.278720, 1.220171, 1.161622, 1.103073, 1.044524, 0.985976, 0.927427, 0.868878, 0.810329, 0.751780, 0.693232, 0.634683, 0.576134, 0.517585, 0.459036, 0.400488, 0.341939, 0.283390, 0.224841, 1.766292, 1.707744, 1.649195, 1.590646, 1.532097, 1.473548, 1.415000, 1.356451, 1.297902, 1.239353, 1.180804, 1.122256, 1.063707, 1.005158, 0.946609, 0.888060, 0.829512, 0.770963, 0.712414, 0.653865, 0.595316, 0.536768, 0.478219, 0.419670, 0.361121, 0.302572, 0.244024, 1.785475, 1.726926, 1.668377, 1.609828, 1.551280, 1.492731, 1.434182, 1.375633, 1.317084, 1.258536, 1.199987, 1.141438, 1.082889, 1.024340, 0.965792, 0.907243, 0.848694, 0.790145, 0.731596, 0.673048, 0.614499, 0.555950, 0.497401, 0.438852, 0.380304, 0.321755, 0.263206, 0.204657, 1.746108, 1.687560, 1.629011, 1.570462, 1.511913, 1.453364, 1.394816, 1.336267, 1.277718, 1.219169, 1.160620, 1.102072, 1.043523, 0.984974, 0.926425, 0.867876, 0.809328, 0.750779, 0.692230, 0.633681, 0.575132, 0.516584, 0.458035, 0.399486, 0.340937, 0.282388, 0.223840, 1.765291, 1.706742, 1.648193, 1.589644, 1.531096, 1.472547, 1.413998, 1.355449, 1.296900, 1.238352, 1.179803, 1.121254, 1.062705, 1.004156, 0.945608, 0.887059, 0.828510, 0.769961, 0.711412, 0.652864]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.657739 0.599190 0.540641 0.482092 0.423544 0.364995 0.306446 0.247897 1.789348 1.730800 1.672251 1.613702 1.555153 1.496604 1.438056 1.379507 1.320958 1.262409 1.203860 1.145312 1.086763 1.028214 0.969665 0.911116 0.852568 0.794019 0.735470 0.676921 0.618372 0.559824 0.501275 0.442726 0.384177 0.325628 0.267080 0.208531 1.749982 1.691433 1.632884 1.574336 1.515787 #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123, 1.597574, 1.539025, 1.480476, 1.421928, 1.363379, 1.304830, 1.246281, 1.187732, 1.129184, 1.070635, 1.012086, 0.953537, 0.894988, 0.836440, 0.777891, 0.719342, 0.660793, 0.602244, 0.543696, 0.485147, 0.426598, 0.368049, 0.309500, 0.250952, 1.792403, 1.733854, 1.675305, 1.616756, 1.558208, 1.499659, 1.441110, 1.382561, 1.324012, 1.265464, 1.206915, 1.148366, 1.089817, 1.031268, 0.972720, 0.914171, 0.855622, 0.797073, 0.738524, 0.679976, 0.621427, 0.562878, 0.504329, 0.445780, 0.387232, 0.328683, 0.270134, 0.211585, 1.753036, 1.694488, 1.635939, 1.577390, 1.518841, 1.460292, 1.401744, 1.343195, 1.284646, 1.226097, 1.167548, 1.109000, 1.050451, 0.991902, 0.933353, 0.874804, 0.816256, 0.757707, 0.699158, 0.640609, 0.582060, 0.523512, 0.464963, 0.406414, 0.347865, 0.289316, 0.230768, 1.772219, 1.713670, 1.655121, 1.596572, 1.538024, 1.479475, 1.420926, 1.362377, 1.303828, 1.245280, 1.186731, 1.128182, 1.069633, 1.011084, 0.952536, 0.893987, 0.835438, 0.776889, 0.718340, 0.659792, 0.601243, 0.542694, 0.484145, 0.425596, 0.367048, 0.308499, 0.249950, 1.791401, 1.732852, 1.674304, 1.615755, 1.557206, 1.498657] #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123] #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123, 1.597574, 1.539025, 1.480476, 1.421928, 1.363379, 1.304830, 1.246281, 1.187732, 1.129184, 1.070635, 1.012086, 0.953537, 0.894988, 0.836440, 0.777891, 0.719342] #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123, 1.597574, 1.539025, 1.480476, 1.421928, 1.363379, 1.304830, 1.246281, 1.187732, 1.129184, 1.070635, 1.012086, 0.953537, 0.894988, 0.836440, 0.777891, 0.719342, 0.660793, 0.602244, 0.543696, 0.485147, 0.426598, 0.368049, 0.309500, 0.250952, 1.792403, 1.733854, 1.675305, 1.616756, 1.558208, 1.499659, 1.441110, 1.382561, 1.324012, 1.265464, 1.206915, 1.148366, 1.089817, 1.031268, 0.972720, 0.914171, 0.855622, 0.797073, 0.738524, 0.679976, 0.621427, 0.562878, 0.504329, 0.445780, 0.387232, 0.328683, 0.270134, 0.211585, 1.753036, 1.694488, 1.635939, 1.577390, 1.518841, 1.460292, 1.401744, 1.343195, 1.284646, 1.226097, 1.167548, 1.109000, 1.050451, 0.991902, 0.933353, 0.874804, 0.816256, 0.757707, 0.699158, 0.640609, 0.582060, 0.523512, 0.464963, 0.406414, 0.347865, 0.289316, 0.230768, 1.772219, 1.713670, 1.655121, 1.596572, 1.538024, 1.479475, 1.420926, 1.362377, 1.303828, 1.245280, 1.186731, 1.128182, 1.069633, 1.011084, 0.952536, 0.893987, 0.835438, 0.776889, 0.718340, 0.659792, 0.601243, 0.542694, 0.484145, 0.425596, 0.367048, 0.308499, 0.249950, 1.791401, 1.732852, 1.674304, 1.615755, 1.557206, 1.498657, 1.440108, 1.381560, 1.323011, 1.264462, 1.205913, 1.147364, 1.088816, 1.030267, 0.971718, 0.913169, 0.854620, 0.796072, 0.737523, 0.678974, 0.620425, 0.561876, 0.503328, 0.444779, 0.386230, 0.327681, 0.269132, 0.210584, 1.752035, 1.693486, 1.634937, 1.576388, 1.517840, 1.459291, 1.400742, 1.342193, 1.283644, 1.225096, 1.166547, 1.107998, 1.049449, 0.990900, 0.932352, 0.873803, 0.815254, 0.756705, 0.698156, 0.639608, 0.581059, 0.522510, 0.463961, 0.405412, 0.346864, 0.288315, 0.229766, 1.771217, 1.712668, 1.654120, 1.595571, 1.537022, 1.478473, 1.419924, 1.361376, 1.302827, 1.244278, 1.185729, 1.127180, 1.068632, 1.010083, 0.951534, 0.892985, 0.834436, 0.775888, 0.717339, 0.658790, 0.600241, 0.541692, 0.483144, 0.424595, 0.366046, 0.307497, 0.248948, 1.790400, 1.731851, 1.673302, 1.614753, 1.556204, 1.497656, 1.439107, 1.380558, 1.322009, 1.263460, 1.204912, 1.146363, 1.087814, 1.029265, 0.970716, 0.912168, 0.853619, 0.795070, 0.736521, 0.677972, 0.619424, 0.560875, 0.502326, 0.443777, 0.385228, 0.326680, 0.268131, 0.209582, 1.751033, 1.692484, 1.633936, 1.575387, 1.516838, 1.458289, 1.399740, 1.341192, 1.282643, 1.224094, 1.165545, 1.106996, 1.048448, 0.989899, 0.931350, 0.872801, 0.814252, 0.755704, 0.697155, 0.638606, 0.580057, 0.521508, 0.462960, 0.404411, 0.345862, 0.287313, 0.228764, 1.770216, 1.711667, 1.653118, 1.594569, 1.536020, 1.477472, 1.418923, 1.360374, 1.301825, 1.243276, 1.184728, 1.126179, 1.067630, 1.009081, 0.950532, 0.891984, 0.833435, 0.774886, 0.716337, 0.657788, 0.599240, 0.540691, 0.482142, 0.423593, 0.365044, 0.306496, 0.247947, 1.789398, 1.730849, 1.672300, 1.613752, 1.555203, 1.496654, 1.438105, 1.379556, 1.321008, 1.262459, 1.203910, 1.145361, 1.086812, 1.028264, 0.969715, 0.911166, 0.852617, 0.794068, 0.735520, 0.676971, 0.618422, 0.559873, 0.501324, 0.442776, 0.384227, 0.325678, 0.267129, 0.208580, 1.750032, 1.691483, 1.632934, 1.574385, 1.515836, 1.457288, 1.398739, 1.340190, 1.281641, 1.223092, 1.164544, 1.105995, 1.047446, 0.988897, 0.930348, 0.871800, 0.813251, 0.754702, 0.696153, 0.637604, 0.579056, 0.520507, 0.461958, 0.403409, 0.344860, 0.286312, 0.227763, 1.769214, 1.710665, 1.652116, 1.593568, 1.535019, 1.476470, 1.417921, 1.359372, 1.300824, 1.242275, 1.183726, 1.125177, 1.066628, 1.008080, 0.949531, 0.890982, 0.832433, 0.773884, 0.715336, 0.656787, 0.598238, 0.539689, 0.481140, 0.422592, 0.364043, 0.305494, 0.246945, 1.788396, 1.729848, 1.671299, 1.612750, 1.554201, 1.495652, 1.437104, 1.378555, 1.320006, 1.261457, 1.202908, 1.144360, 1.085811, 1.027262, 0.968713, 0.910164, 0.851616, 0.793067, 0.734518, 0.675969, 0.617420, 0.558872, 0.500323, 0.441774, 0.383225, 0.324676, 0.266128, 0.207579, 1.749030, 1.690481, 1.631932, 1.573384, 1.514835, 1.456286, 1.397737, 1.339188, 1.280640, 1.222091, 1.163542, 1.104993, 1.046444, 0.987896, 0.929347, 0.870798, 0.812249, 0.753700, 0.695152, 0.636603, 0.578054, 0.519505, 0.460956, 0.402408, 0.343859, 0.285310, 0.226761, 1.768212, 1.709664, 1.651115, 1.592566, 1.534017, 1.475468, 1.416920, 1.358371, 1.299822, 1.241273, 1.182724, 1.124176, 1.065627, 1.007078, 0.948529, 0.889980, 0.831432, 0.772883, 0.714334, 0.655785, 0.597236, 0.538688, 0.480139, 0.421590, 0.363041, 0.304492, 0.245944, 1.787395, 1.728846, 1.670297, 1.611748, 1.553200, 1.494651, 1.436102, 1.377553, 1.319004, 1.260456, 1.201907, 1.143358, 1.084809, 1.026260, 0.967712, 0.909163, 0.850614, 0.792065, 0.733516, 0.674968, 0.616419, 0.557870, 0.499321, 0.440772, 0.382224, 0.323675, 0.265126, 0.206577, 1.748028, 1.689480, 1.630931, 1.572382, 1.513833, 1.455284, 1.396736, 1.338187, 1.279638, 1.221089, 1.162540, 1.103992, 1.045443, 0.986894, 0.928345, 0.869796, 0.811248, 0.752699, 0.694150, 0.635601, 0.577052, 0.518504, 0.459955, 0.401406, 0.342857, 0.284308, 0.225760, 1.767211, 1.708662, 1.650113, 1.591564, 1.533016, 1.474467, 1.415918, 1.357369, 1.298820, 1.240272, 1.181723, 1.123174, 1.064625, 1.006076, 0.947528, 0.888979, 0.830430, 0.771881, 0.713332, 0.654784, 0.596235, 0.537686, 0.479137, 0.420588, 0.362040, 0.303491, 0.244942, 1.786393, 1.727844, 1.669296, 1.610747, 1.552198, 1.493649, 1.435100, 1.376552, 1.318003, 1.259454, 1.200905, 1.142356, 1.083808, 1.025259, 0.966710, 0.908161, 0.849612, 0.791064, 0.732515, 0.673966, 0.615417, 0.556868, 0.498320, 0.439771, 0.381222, 0.322673, 0.264124, 0.205576, 1.747027, 1.688478, 1.629929, 1.571380, 1.512832, 1.454283, 1.395734, 1.337185, 1.278636, 1.220088, 1.161539, 1.102990, 1.044441, 0.985892, 0.927344, 0.868795, 0.810246, 0.751697, 0.693148, 0.634600, 0.576051, 0.517502, 0.458953, 0.400404, 0.341856, 0.283307, 0.224758, 1.766209, 1.707660, 1.649112, 1.590563, 1.532014, 1.473465, 1.414916, 1.356368, 1.297819, 1.239270, 1.180721, 1.122172, 1.063624, 1.005075, 0.946526, 0.887977, 0.829428, 0.770880, 0.712331, 0.653782, 0.595233, 0.536684, 0.478136, 0.419587, 0.361038, 0.302489, 0.243940, 1.785392, 1.726843, 1.668294, 1.609745, 1.551196, 1.492648, 1.434099, 1.375550, 1.317001, 1.258452, 1.199904, 1.141355, 1.082806, 1.024257, 0.965708, 0.907160, 0.848611, 0.790062, 0.731513, 0.672964, 0.614416, 0.555867, 0.497318, 0.438769, 0.380220, 0.321672]).map Float.toBits))

def hashemiOutrigger  : Array Float :=
  #[(0.98 : Float), (1.22 : Float), (1.35 : Float), (0.25 : Float)]

#eval IO.println ("hashemiOutrigger " ++ toString ((hashemiOutrigger).map Float.toBits))
#eval IO.println ("hashemiOutrigger " ++ toString ((hashemiOutrigger).map Float.toBits))
#eval IO.println ("hashemiOutrigger " ++ toString ((hashemiOutrigger).map Float.toBits))

def hashemiPanel  : Array Float :=
  #[(5 : Float)]

#eval IO.println ("hashemiPanel " ++ toString ((hashemiPanel).map Float.toBits))
#eval IO.println ("hashemiPanel " ++ toString ((hashemiPanel).map Float.toBits))
#eval IO.println ("hashemiPanel " ++ toString ((hashemiPanel).map Float.toBits))

def hashemiStand  : Array Float :=
  #[(1.59 : Float), (1.84 : Float), (0.41 : Float)]

#eval IO.println ("hashemiStand " ++ toString ((hashemiStand).map Float.toBits))
#eval IO.println ("hashemiStand " ++ toString ((hashemiStand).map Float.toBits))
#eval IO.println ("hashemiStand " ++ toString ((hashemiStand).map Float.toBits))

def check_hashemi_clearance  : Bool :=
  let v13 := ((1.30 : Float) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  (((0.1449 : Float) < v13) && (v13 < (0.146 : Float)))

#eval IO.println ("check_hashemi_clearance " ++ toString (check_hashemi_clearance))
#eval IO.println ("check_hashemi_clearance " ++ toString (check_hashemi_clearance))
#eval IO.println ("check_hashemi_clearance " ++ toString (check_hashemi_clearance))

def check_hashemi_eyes_clear  : Bool :=
  (((0.010 : Float) / (2 : Float)) < (0.010 : Float))

#eval IO.println ("check_hashemi_eyes_clear " ++ toString (check_hashemi_eyes_clear))
#eval IO.println ("check_hashemi_eyes_clear " ++ toString (check_hashemi_eyes_clear))
#eval IO.println ("check_hashemi_eyes_clear " ++ toString (check_hashemi_eyes_clear))

def check_hashemi_fits  : Bool :=
  let v11 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  (feq v11 v11)

#eval IO.println ("check_hashemi_fits " ++ toString (check_hashemi_fits))
#eval IO.println ("check_hashemi_fits " ++ toString (check_hashemi_fits))
#eval IO.println ("check_hashemi_fits " ++ toString (check_hashemi_fits))

def headToCmd (h : Float) : Float :=
  (((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float))

#eval IO.println ("headToCmd " ++ toString (headToCmd 1.617059).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 1.285867).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 0.954675).toBits)

def headToDriveAz (h : Float) (rw : Float) (R : Float) : Float :=
  ((((((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.430907 1.372358 1.313809).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.099715 1.041166 0.982617).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 0.768523 0.709974 0.651425).toBits)

def headToDriveEl (h : Float) (arm : Float) (rDrum : Float) : Float :=
  ((((-(((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float))) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.244755 1.186206 1.127657).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 0.913563 0.855014 0.796465).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 0.582371 0.523822 0.465273).toBits)

def heatParams  : Array Float :=
  #[(0.9 : Float), (0.8 : Float), (0.03 : Float), (15 : Float), (0.92 : Float), (15 : Float), (6300 : Float), (593 : Float)]

#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))

def heatStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Array Float :=
  let v22 := (Toil - Ta)
  #[(min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * Pin), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("heatStep " ++ toString ((heatStep 0.872451 0.813902 0.755353 0.696804 0.638256 0.579707 0.521158 0.462609 0.404060 0.345512 0.286963 0.228414 1.769865).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.541259 0.482710 0.424161 0.365612 0.307064 0.248515 1.789966 1.731417 1.672868 1.614320 1.555771 1.497222 1.438673).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.210067 1.751518 1.692969 1.634420 1.575872 1.517323 1.458774 1.400225 1.341676 1.283128 1.224579 1.166030 1.107481).map Float.toBits))

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.686299 0.627750).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.355107 0.296558).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.623915 1.565366).toBits)

def check_helixAdvance_small  : Bool :=
  ((((0.00175 : Float) * (((62 : Float) * (3.141592653589793 : Float)) / (180 : Float))) / ((2 : Float) * (3.141592653589793 : Float))) < (0.00031 : Float))

#eval IO.println ("check_helixAdvance_small " ++ toString (check_helixAdvance_small))
#eval IO.println ("check_helixAdvance_small " ++ toString (check_helixAdvance_small))
#eval IO.println ("check_helixAdvance_small " ++ toString (check_helixAdvance_small))

def hingeWrench (xh : Float) (zBolt : Float) : Array Float :=
  let v4 := ((0 : Float) * (0 : Float))
  let v5 := (zBolt * (0 : Float))
  let v7 := (zBolt * (1 : Float))
  let v8 := (xh * (0 : Float))
  let v10 := ((0 : Float) * (1 : Float))
  let v14 := (xh * (1 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v4 - v5), (v7 - v8), (v8 - v10), (0 : Float), (1 : Float), (0 : Float), (v4 - v7), (v5 - v8), (v14 - v4), (0 : Float), (0 : Float), (1 : Float), (v10 - v5), (v5 - v14), (v8 - v4), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float)]

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.313995 0.255446).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.582803 1.524254).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.251611 1.193062).map Float.toBits))

def check_hinge_freedom (xh : Float) (zBolt : Float) (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) : Bool :=
  let v10 := ((0 : Float) * (0 : Float))
  let v11 := (zBolt * (0 : Float))
  let v13 := (zBolt * (1 : Float))
  let v14 := (xh * (0 : Float))
  let v16 := ((0 : Float) * (1 : Float))
  let v20 := (xh * (1 : Float))
  let v32 := (t_4 * (0 : Float))
  let v34 := (t_5 * (0 : Float))
  let v42 := (t_3 * (0 : Float))
  let v58 := (t_0 * (0 : Float))
  (!((feq ((((((t_0 * (v10 - v11)) + (t_1 * (v13 - v14))) + (t_2 * (v14 - v16))) + (t_3 * (1 : Float))) + v32) + v34) (0 : Float)) && ((feq ((((((t_0 * (v10 - v13)) + (t_1 * (v11 - v14))) + (t_2 * (v20 - v10))) + v42) + (t_4 * (1 : Float))) + v34) (0 : Float)) && ((feq ((((((t_0 * (v16 - v11)) + (t_1 * (v11 - v20))) + (t_2 * (v14 - v10))) + v42) + v32) + (t_5 * (1 : Float))) (0 : Float)) && ((feq (((((v58 + (t_1 * (1 : Float))) + (t_2 * (0 : Float))) + v42) + v32) + v34) (0 : Float)) && (feq (((((v58 + (t_1 * (0 : Float))) + (t_2 * (1 : Float))) + v42) + v32) + v34) (0 : Float)))))) || ((feq t_1 (0 : Float)) && ((feq t_2 (0 : Float)) && ((feq t_3 (0 : Float)) && ((feq t_4 (t_0 * zBolt)) && (feq t_5 (0 : Float)))))))

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.727843 1.669294 1.610745 1.552196 1.493648 1.435099 1.376550 1.318001))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.396651 1.338102 1.279553 1.221004 1.162456 1.103907 1.045358 0.986809))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.065459 1.006910 0.948361 0.889812 0.831264 0.772715 0.714166 0.655617))

def check_hinge_freedom_smul (xh : Float) (zBolt : Float) (apexH : Float) (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) : Bool :=
  let v11 := ((0 : Float) * (0 : Float))
  let v12 := (zBolt * (0 : Float))
  let v14 := (zBolt * (1 : Float))
  let v15 := (xh * (0 : Float))
  let v17 := ((0 : Float) * (1 : Float))
  let v21 := (xh * (1 : Float))
  let v26 := (t_0 * (v11 - v12))
  let v33 := (t_4 * (0 : Float))
  let v35 := (t_5 * (0 : Float))
  let v43 := (t_3 * (0 : Float))
  let v59 := (t_0 * (0 : Float))
  let v80 := (apexH * (0 : Float))
  (!((feq (((((v26 + (t_1 * (v14 - v15))) + (t_2 * (v15 - v17))) + (t_3 * (1 : Float))) + v33) + v35) (0 : Float)) && ((feq ((((((t_0 * (v11 - v14)) + (t_1 * (v12 - v15))) + (t_2 * (v21 - v11))) + v43) + (t_4 * (1 : Float))) + v35) (0 : Float)) && ((feq ((((((t_0 * (v17 - v12)) + (t_1 * (v12 - v21))) + (t_2 * (v15 - v11))) + v43) + v33) + (t_5 * (1 : Float))) (0 : Float)) && ((feq (((((v59 + (t_1 * (1 : Float))) + (t_2 * (0 : Float))) + v43) + v33) + v35) (0 : Float)) && (feq (((((v59 + (t_1 * (0 : Float))) + (t_2 * (1 : Float))) + v43) + v33) + v35) (0 : Float)))))) || ((feq t_0 (t_0 * (1 : Float))) && ((feq t_1 v59) && ((feq t_2 v59) && ((feq t_3 v26) && ((feq t_4 (t_0 * (v14 - v80))) && (feq t_5 (t_0 * (v80 - v17)))))))))

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.541691 1.483142 1.424593 1.366044 1.307496 1.248947 1.190398 1.131849 1.073300))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.210499 1.151950 1.093401 1.034852 0.976304 0.917755 0.859206 0.800657 0.742108))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.879307 0.820758 0.762209 0.703660 0.645112 0.586563 0.528014 0.469465 0.410916))

def check_hinge_reciprocal_swing (xh : Float) (zBolt : Float) (apexH : Float) : Bool :=
  let v5 := ((0 : Float) * (0 : Float))
  let v6 := (zBolt * (0 : Float))
  let v7 := (v5 - v6)
  let v8 := (zBolt * (1 : Float))
  let v9 := (apexH * (0 : Float))
  let v10 := (v8 - v9)
  let v11 := ((0 : Float) * (1 : Float))
  let v12 := (v9 - v11)
  let v13 := (xh * (0 : Float))
  let v18 := (xh * (1 : Float))
  let v30 := (v10 * (0 : Float))
  let v32 := (v12 * (0 : Float))
  let v40 := (v7 * (0 : Float))
  let v56 := ((1 : Float) * (0 : Float))
  ((feq (((((((1 : Float) * v7) + ((0 : Float) * (v8 - v13))) + ((0 : Float) * (v13 - v11))) + (v7 * (1 : Float))) + v30) + v32) (0 : Float)) && ((feq (((((((1 : Float) * (v5 - v8)) + ((0 : Float) * (v6 - v13))) + ((0 : Float) * (v18 - v5))) + v40) + (v10 * (1 : Float))) + v32) (0 : Float)) && ((feq (((((((1 : Float) * (v11 - v6)) + ((0 : Float) * (v6 - v18))) + ((0 : Float) * (v13 - v5))) + v40) + v30) + (v12 * (1 : Float))) (0 : Float)) && ((feq (((((v56 + v11) + v5) + v40) + v30) + v32) (0 : Float)) && (feq (((((v56 + v5) + v11) + v40) + v30) + v32) (0 : Float))))))

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.355539 1.296990 1.238441))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.024347 0.965798 0.907249))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.693155 0.634606 0.576057))

def hpHashemi  : Float :=
  (0.34 : Float)

#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 0.983235 0.924686 0.866137 0.807588 0.749040 0.690491 0.631942).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.652043 0.593494 0.534945 0.476396 0.417848 0.359299 0.300750).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.320851 0.262302 0.203753 1.745204 1.686656 1.628107 1.569558).map Float.toBits))

def check_lean_one_degree  : Bool :=
  ((0.02 : Float) < ((1.25 : Float) * (Float.sin ((3.141592653589793 : Float) / (180 : Float)))))

#eval IO.println ("check_lean_one_degree " ++ toString (check_lean_one_degree))
#eval IO.println ("check_lean_one_degree " ++ toString (check_lean_one_degree))
#eval IO.println ("check_lean_one_degree " ++ toString (check_lean_one_degree))

def leverAt (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Float :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2))))

#eval IO.println ("leverAt " ++ toString (leverAt 0.610931 0.552382 0.493833 0.435284 0.376736).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.279739 0.221190 1.762641 1.704092 1.645544).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 1.548547 1.489998 1.431449 1.372900 1.314352).toBits)

def lostSunS (tDead : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (eps : Float) : Float :=
  let v8 := ((3.141592653589793 : Float) / (2 : Float))
  let v14 := (Float.sin t)
  let v16 := (v14 * (Float.cos az))
  let v18 := (v14 * (Float.sin az))
  let v19 := (Float.cos t)
  let v20 := (Float.cos elSun)
  let v22 := (v20 * (Float.cos azSun))
  let v24 := (v20 * (Float.sin azSun))
  let v25 := (Float.sin elSun)
  let v30 := (((v16 * v22) + (v18 * v24)) + (v19 * v25))
  let v45 := (Float.sqrt (((((v18 * v25) - (v19 * v24)) ^ 2) + (((v19 * v22) - (v16 * v25)) ^ 2)) + (((v16 * v24) - (v18 * v22)) ^ 2)))
  ((1.0 / (1.0 + Float.exp (-((elSun - (v8 - tDead)) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-(((if (v30 <= (0 : Float)) then (v8 + (Float.atan ((-v30) / (max v45 (0.000000000001 : Float))))) else (Float.atan (v45 / v30))) - eps) / (0.01 : Float))))))

#eval IO.println ("lostSunS " ++ toString (lostSunS 0.424779 0.366230 0.307681 0.249132 1.790584 1.732035).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 1.693587 1.635038 1.576489 1.517940 1.459392 1.400843).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 1.362395 1.303846 1.245297 1.186748 1.128200 1.069651).toBits)

def check_lostSunS_le_reach (tDead : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (eps : Float) : Bool :=
  let v8 := ((3.141592653589793 : Float) / (2 : Float))
  let v13 := (1.0 / (1.0 + Float.exp (-((elSun - (v8 - tDead)) / (0.01 : Float)))))
  let v14 := (Float.sin t)
  let v16 := (v14 * (Float.cos az))
  let v18 := (v14 * (Float.sin az))
  let v19 := (Float.cos t)
  let v20 := (Float.cos elSun)
  let v22 := (v20 * (Float.cos azSun))
  let v24 := (v20 * (Float.sin azSun))
  let v25 := (Float.sin elSun)
  let v30 := (((v16 * v22) + (v18 * v24)) + (v19 * v25))
  let v45 := (Float.sqrt (((((v18 * v25) - (v19 * v24)) ^ 2) + (((v19 * v22) - (v16 * v25)) ^ 2)) + (((v16 * v24) - (v18 * v22)) ^ 2)))
  ((v13 * (1.0 / (1.0 + Float.exp (-(((if (v30 <= (0 : Float)) then (v8 + (Float.atan ((-v30) / (max v45 (0.000000000001 : Float))))) else (Float.atan (v45 / v30))) - eps) / (0.01 : Float)))))) <= v13)

#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.238627 1.780078 1.721529 1.662980 1.604432 1.545883))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.507435 1.448886 1.390337 1.331788 1.273240 1.214691))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.176243 1.117694 1.059145 1.000596 0.942048 0.883499))

def check_lostSun_unreachable (tDead : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (eps : Float) : Bool :=
  let v8 := ((3.141592653589793 : Float) / (2 : Float))
  let v10 := ((v8 - tDead) <= elSun)
  let v12 := (Float.sin t)
  let v14 := (v12 * (Float.cos az))
  let v16 := (v12 * (Float.sin az))
  let v17 := (Float.cos t)
  let v18 := (Float.cos elSun)
  let v20 := (v18 * (Float.cos azSun))
  let v22 := (v18 * (Float.sin azSun))
  let v23 := (Float.sin elSun)
  let v28 := (((v14 * v20) + (v16 * v22)) + (v17 * v23))
  let v43 := (Float.sqrt (((((v16 * v23) - (v17 * v22)) ^ 2) + (((v17 * v20) - (v14 * v23)) ^ 2)) + (((v14 * v22) - (v16 * v20)) ^ 2)))
  (!(!v10) || (!(v10 && (eps < (if (v28 <= (0 : Float)) then (v8 + (Float.atan ((-v28) / (max v43 (0.000000000001 : Float))))) else (Float.atan (v43 / v28)))))))

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.652475 1.593926 1.535377 1.476828 1.418280 1.359731))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.321283 1.262734 1.204185 1.145636 1.087088 1.028539))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.990091 0.931542 0.872993 0.814444 0.755896 0.697347))

def check_lostSun_within_budget (tDead : Float) (az : Float) (t : Float) (elSun : Float) (azSun : Float) (eps : Float) : Bool :=
  let v6 := (Float.sin t)
  let v8 := (v6 * (Float.cos az))
  let v10 := (v6 * (Float.sin az))
  let v11 := (Float.cos t)
  let v12 := (Float.cos elSun)
  let v14 := (v12 * (Float.cos azSun))
  let v16 := (v12 * (Float.sin azSun))
  let v17 := (Float.sin elSun)
  let v22 := (((v8 * v14) + (v10 * v16)) + (v11 * v17))
  let v37 := (Float.sqrt (((((v10 * v17) - (v11 * v16)) ^ 2) + (((v11 * v14) - (v8 * v17)) ^ 2)) + (((v8 * v16) - (v10 * v14)) ^ 2)))
  let v42 := ((3.141592653589793 : Float) / (2 : Float))
  let v51 := (if (v22 <= (0 : Float)) then (v42 + (Float.atan ((-v22) / (max v37 (0.000000000001 : Float))))) else (Float.atan (v37 / v22)))
  (!(v51 <= eps) || (!(((v42 - tDead) <= elSun) && (eps < v51))))

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.466323 1.407774 1.349225 1.290676 1.232128 1.173579))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.135131 1.076582 1.018033 0.959484 0.900936 0.842387))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.803939 0.745390 0.686841 0.628292 0.569744 0.511195))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.094019))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.762827))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.431635))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.721715))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.390523))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.659331))

def check_mast_beyond_ring  : Bool :=
  ((Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))) < ((0.80 : Float) + (1.22 : Float)))

#eval IO.println ("check_mast_beyond_ring " ++ toString (check_mast_beyond_ring))
#eval IO.println ("check_mast_beyond_ring " ++ toString (check_mast_beyond_ring))
#eval IO.println ("check_mast_beyond_ring " ++ toString (check_mast_beyond_ring))

def check_mast_for_vertical_hashemi  : Bool :=
  ((1.17 : Float) < (((1.22 : Float) * (0.8 : Float)) / ((Float.sqrt (3.36 : Float)) - (1 : Float))))

#eval IO.println ("check_mast_for_vertical_hashemi " ++ toString (check_mast_for_vertical_hashemi))
#eval IO.println ("check_mast_for_vertical_hashemi " ++ toString (check_mast_for_vertical_hashemi))
#eval IO.println ("check_mast_for_vertical_hashemi " ++ toString (check_mast_for_vertical_hashemi))

def megaGeom (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) : Array Float :=
  let v21 := ((2 : Float) ^ 2)
  let v22 := ((0.8 : Float) ^ 2)
  let v25 := ((2 : Float) - (Float.sqrt (v21 - v22)))
  let v27 := ((1 : Float) - v25)
  let v28 := (-(1.22 : Float))
  let v29 := (-(0.8 : Float))
  let v30 := (Float.cos t)
  let v32 := (-v27)
  let v33 := (Float.sin t)
  let v35 := ((v29 * v30) + (v32 * v33))
  let v39 := (((-v29) * v33) + (v32 * v30))
  let v49 := (((v28 * v39) - ((0.34 : Float) * v35)) / (Float.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : Float)) ^ 2))))
  let v52 := (Float.cos az)
  let v53 := (v33 * v52)
  let v54 := (Float.sin az)
  let v55 := (v33 * v54)
  let v56 := (Float.cos elSun)
  let v58 := (v56 * (Float.cos azSun))
  let v60 := (v56 * (Float.sin azSun))
  let v61 := (Float.sin elSun)
  let v66 := (((v53 * v58) + (v55 * v60)) + (v30 * v61))
  let v81 := (Float.sqrt (((((v55 * v61) - (v30 * v60)) ^ 2) + (((v30 * v58) - (v53 * v61)) ^ 2)) + (((v53 * v60) - (v55 * v58)) ^ 2)))
  let v85 := ((3.141592653589793 : Float) / (2 : Float))
  let v95 := (v85 - t)
  let v96 := ((0 : Float) * v30)
  let v97 := (-(1 : Float))
  let v101 := ((-(0 : Float)) * v33)
  let v108 := (-t)
  let v109 := (Float.sin v108)
  let v112 := (Float.cos v108)
  let v113 := ((1 : Float) * v112)
  let v116 := ((1 : Float) * (-v109))
  let v120 := ((1 : Float) + (0.01 : Float))
  let v128 := ((1 : Float) * (Float.tan (if (v66 <= (0 : Float)) then (v85 + (Float.atan ((-v66) / (max v81 (0.000000000001 : Float))))) else (Float.atan (v81 / v66)))))
  let v133 := (((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) / (2 : Float))
  let v139 := (v133 ^ 2)
  let v140 := (v128 ^ 2)
  let v142 := ((0.06 : Float) ^ 2)
  let v144 := ((2 : Float) * v128)
  let v159 := (v128 + v133)
  let v175 := ((2 : Float) * (0.8 : Float))
  let v192 := ((1.84 : Float) / (2 : Float))
  let v205 := ((2 : Float) / (2 : Float))
  let v209 := ((0.4 : Float) ^ 2)
  let v222 := (Float.sqrt (3.2 : Float))
  let v230 := (Float.sqrt ((4.36 : Float) - ((2 : Float) * v222)))
  let v256 := ((1.22 : Float) * (0.8 : Float))
  let v257 := ((0.34 : Float) * v27)
  let v267 := ((W * rcm) * v33)
  #[(2 : Float), (1 : Float), (0.8 : Float), v175, v25, v27, (v205 - v25), (Float.sqrt ((((0 : Float) ^ 2) + v209) + ((v205 - ((2 : Float) - (Float.sqrt (v21 - ((Float.sqrt (v22 + v209)) ^ 2))))) ^ 2))), ((0.4 : Float) / (v222 - (1 : Float))), (((3.36 : Float) - v222) / ((2 : Float) * v230)), (Float.sqrt ((v192 ^ 2) + ((0.80 : Float) ^ 2))), (1.84 : Float), (0.80 : Float), (0.55 : Float), (0.62 : Float), ((0.62 : Float) - (0.175 : Float)), (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2))), (1.59 : Float), (1.84 : Float), (1.35 : Float), (v96 + (v97 * v33)), (v101 + (v97 * v30)), (v96 + ((1 : Float) * v33)), (v101 + ((1 : Float) * v30)), ((0 : Float) + ((1 : Float) * v109)), ((0 : Float) - v113), (-v109), v112, (Float.sqrt (((((0 : Float) + ((1 : Float) * v109)) + v116) ^ 2) + ((((0 : Float) - v113) + v113) ^ 2))), (Float.sqrt (((((0 : Float) + (v120 * v109)) + v116) ^ 2) + ((((0 : Float) - (v120 * v112)) + v113) ^ 2))), v28, (0.34 : Float), v35, v39, v49, (if (v256 <= v257) then v85 else (Float.atan ((((1.22 : Float) * v27) + ((0.34 : Float) * (0.8 : Float))) / (v256 - v257)))), (Float.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : Float)) ^ 2))), (v267 / v49), (v267 * ((omegad * rDrum) / v49)), ((((2 : Float) * (1 : Float)) * slack) / v49), (Float.atan ((0.8 : Float) / v27)), ((1 : Float) * (Float.tan t)), ((v27 * (Float.sin v95)) + ((0.8 : Float) * (Float.cos v95))), (((1.30 : Float) - (0.05 : Float)) - ((v27 * (Float.sin v95)) + ((0.8 : Float) * (Float.cos v95)))), (((0.8 : Float) * v33) + (v27 * v30)), (((1.84 : Float) - v175) / (2 : Float)), ((1.30 : Float) - (0.05 : Float)), ((v52 * (0.80 : Float)) - (v54 * (0 : Float))), ((v54 * (0.80 : Float)) + (v52 * (0 : Float))), (Float.sqrt ((((v52 * (0.80 : Float)) - (v54 * (0 : Float))) ^ 2) + (((v54 * (0.80 : Float)) + (v52 * (0 : Float))) ^ 2))), v128, ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))), (if ((v133 + (0.06 : Float)) <= v128) then (0 : Float) else (if (v128 <= ((0.06 : Float) - v133)) then (1 : Float) else ((((v139 * (Float.acos (((v140 + v139) - v142) / (v144 * v133)))) + (v142 * (Float.acos (((v140 + v142) - v139) / (v144 * (0.06 : Float)))))) - ((Float.sqrt ((((((-v128) + v133) + (0.06 : Float)) * (v159 - (0.06 : Float))) * ((v128 - v133) + (0.06 : Float))) * (v159 + (0.06 : Float)))) / (2 : Float))) / ((3.141592653589793 : Float) * v139)))), (if ((0 : Float) < elSun) then (((dni * (v175 ^ 2)) * rho) * (if ((v133 + (0.06 : Float)) <= v128) then (0 : Float) else (if (v128 <= ((0.06 : Float) - v133)) then (1 : Float) else ((((v139 * (Float.acos (((v140 + v139) - v142) / (v144 * v133)))) + (v142 * (Float.acos (((v140 + v142) - v139) / (v144 * (0.06 : Float)))))) - ((Float.sqrt ((((((-v128) + v133) + (0.06 : Float)) * (v159 - (0.06 : Float))) * ((v128 - v133) + (0.06 : Float))) * (v159 + (0.06 : Float)))) / (2 : Float))) / ((3.141592653589793 : Float) * v139))))) else (0 : Float)), ((1.25 : Float) * (Float.sin (0.0005 : Float))), ((0.0015 : Float) / v175), (rodLen - (rodLen - v230)), (((0.00175 : Float) * t) / ((2 : Float) * (3.141592653589793 : Float))), ((((0.0000000172 : Float) * ((2 : Float) * (4 : Float))) * ((5 : Float) / (12 : Float))) / (0.0000015 : Float)), (((((0.80 : Float) - ((0.80 : Float) + (1.22 : Float))) * (-(0.0005 : Float))) + ((((1 : Float) * (v192 - (0 : Float))) - (0 : Float)) * (0 : Float))) + (((1.30 : Float) - (0 : Float)) * (0 : Float)))]

#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.763259 1.704710 1.646161 1.587612 1.529064 1.470515 1.411966 1.353417 1.294868 1.236320 1.177771 1.119222 1.060673 1.002124 0.943576 0.885027 0.826478).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.432067 1.373518 1.314969 1.256420 1.197872 1.139323 1.080774 1.022225 0.963676 0.905128 0.846579 0.788030 0.729481 0.670932 0.612384 0.553835 0.495286).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.100875 1.042326 0.983777 0.925228 0.866680 0.808131 0.749582 0.691033 0.632484 0.573936 0.515387 0.456838 0.398289 0.339740 0.281192 0.222643 1.764094).map Float.toBits))

def megaParams  : Array Float :=
  #[(0.03 : Float), (300 : Float), (0.9 : Float), (2000 : Float), (0.85 : Float), (10 : Float), (1000000 : Float), (1 : Float)]

#eval IO.println ("megaParams " ++ toString ((megaParams).map Float.toBits))
#eval IO.println ("megaParams " ++ toString ((megaParams).map Float.toBits))
#eval IO.println ("megaParams " ++ toString ((megaParams).map Float.toBits))

def megaReqs (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) : Array Float :=
  let v23 := ((0.8 : Float) ^ 2)
  let v27 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - v23))))
  let v28 := (-(1.22 : Float))
  let v29 := (-(0.8 : Float))
  let v30 := (Float.cos t)
  let v32 := (-v27)
  let v33 := (Float.sin t)
  let v35 := ((v29 * v30) + (v32 * v33))
  let v39 := (((-v29) * v33) + (v32 * v30))
  let v49 := (((v28 * v39) - ((0.34 : Float) * v35)) / (Float.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : Float)) ^ 2))))
  let v51 := (v33 * (Float.cos az))
  let v53 := (v33 * (Float.sin az))
  let v54 := (Float.cos elSun)
  let v56 := (v54 * (Float.cos azSun))
  let v58 := (v54 * (Float.sin azSun))
  let v59 := (Float.sin elSun)
  let v64 := (((v51 * v56) + (v53 * v58)) + (v30 * v59))
  let v79 := (Float.sqrt (((((v53 * v59) - (v30 * v58)) ^ 2) + (((v30 * v56) - (v51 * v59)) ^ 2)) + (((v51 * v58) - (v53 * v56)) ^ 2)))
  let v103 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  let v135 := ((1 : Float) * (Float.tan (if (v64 <= (0 : Float)) then (((3.141592653589793 : Float) / (2 : Float)) + (Float.atan ((-v64) / (max v79 (0.000000000001 : Float))))) else (Float.atan (v79 / v64)))))
  #[(if (feq v103 v103) then (1 : Float) else (0 : Float)), (if (((0.010 : Float) / (2 : Float)) < (0.010 : Float)) then (1 : Float) else (0 : Float)), (if ((W * rcm) <= (Tmax * v49)) then (1 : Float) else (0 : Float)), (if ((Float.sqrt (v23 + (v27 ^ 2))) < (1.22 : Float)) then (1 : Float) else (0 : Float)), (if (((1.22 : Float) * (0.8 : Float)) <= ((0.34 : Float) * v27)) then (1 : Float) else (0 : Float)), (if ((v135 + ((((2 : Float) * (1 : Float)) * slack) / v49)) <= (0.03 : Float)) then (1 : Float) else (0 : Float)), (if (v135 <= (0.03 : Float)) then (1 : Float) else (0 : Float))]

#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.390955 1.332406 1.273857 1.215308 1.156760 1.098211 1.039662 0.981113 0.922564 0.864016 0.805467 0.746918 0.688369 0.629820 0.571272 0.512723 0.454174).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.059763 1.001214 0.942665 0.884116 0.825568 0.767019 0.708470 0.649921 0.591372 0.532824 0.474275 0.415726 0.357177 0.298628 0.240080 1.781531 1.722982).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.728571 0.670022 0.611473 0.552924 0.494376 0.435827 0.377278 0.318729 0.260180 0.201632 1.743083 1.684534 1.625985 1.567436 1.508888 1.450339 1.391790).map Float.toBits))

def megaScrew (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) : Array Float :=
  let v28 := (-(1.22 : Float))
  let v29 := (-(0.8 : Float))
  let v30 := (Float.cos t)
  let v32 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v33 := (Float.sin t)
  let v35 := ((v29 * v30) + (v32 * v33))
  let v39 := (((-v29) * v33) + (v32 * v30))
  let v48 := (Float.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : Float)) ^ 2)))
  let v49 := (((v28 * v39) - ((0.34 : Float) * v35)) / v48)
  let v56 := ((1.84 : Float) / (2 : Float))
  let v60 := (Float.sqrt ((v56 ^ 2) + ((0.80 : Float) ^ 2)))
  let v71 := (((0.55 : Float) + (1.30 : Float)) - (0.05 : Float))
  let v73 := (v56 - (0.03 : Float))
  let v75 := ((0 : Float) * (0 : Float))
  let v76 := ((0.62 : Float) * (0 : Float))
  let v78 := ((0.62 : Float) * (1 : Float))
  let v80 := ((0 : Float) * (1 : Float))
  let v89 := ((0.55 : Float) * (0 : Float))
  let v91 := ((0.80 : Float) * (1 : Float))
  let v93 := ((0.80 : Float) * (0 : Float))
  let v94 := (v56 * (0 : Float))
  let v96 := (-v56)
  let v99 := (v96 * (0 : Float))
  let v113 := (v71 * (0 : Float))
  let v114 := (v75 - v113)
  let v115 := (v71 * (1 : Float))
  let v116 := (v115 - v93)
  let v117 := (v93 - v80)
  let v120 := ((2 : Float) * (3.141592653589793 : Float))
  let v121 := ((0.00175 : Float) / v120)
  let v122 := (v73 * (0 : Float))
  let v123 := (v115 - v122)
  let v125 := (v75 - v115)
  let v126 := (v113 - v122)
  let v127 := (v73 * (1 : Float))
  let v129 := (v80 - v113)
  let v130 := (v113 - v127)
  let v133 := ((0 : Float) * v71)
  let v134 := ((1 : Float) * (0 : Float))
  let v137 := ((1 : Float) * (0.80 : Float))
  let v140 := ((0 : Float) * (0.80 : Float))
  let v145 := ((1 : Float) * v71)
  let v150 := (v113 - v93)
  let v151 := (v91 - v75)
  let v153 := ((0 : Float) * (0.3 : Float))
  let v160 := ((0.80 : Float) - v35)
  let v161 := (v71 + v39)
  let v163 := ((W * rcm) * v33)
  let v164 := (v163 / v49)
  let v168 := ((v164 * (-(v28 - v35))) / v48)
  let v171 := ((v164 * ((0.34 : Float) - v39)) / v48)
  let v172 := (v134 + v75)
  let v189 := ((v75 + v75) + v134)
  let v198 := ((v89 - v91) * (0 : Float))
  let v211 := ((((0.55 : Float) * (0.80 : Float)) - v93) * (0 : Float))
  let v224 := (-((Fdrive * v56) / v60))
  let v226 := ((Fdrive * (0.80 : Float)) / v60)
  let v247 := ((0 : Float) * (v122 - v80))
  let v251 := (v116 * (0 : Float))
  let v253 := (v117 * (0 : Float))
  let v258 := ((0 : Float) * (v127 - v75))
  let v259 := ((((1 : Float) * v125) + ((0 : Float) * v126)) + v258)
  let v260 := (v114 * (0 : Float))
  let v268 := ((0 : Float) * (v122 - v75))
  let v269 := ((((1 : Float) * v129) + ((0 : Float) * v130)) + v268)
  let v275 := ((v134 + v80) + v75)
  let v279 := (v172 + v80)
  let v283 := (v121 * (0 : Float))
  let v309 := (v150 * (0 : Float))
  let v311 := (v151 * (0 : Float))
  let v317 := (v125 * (0 : Float))
  #[((((v172 + v75) + ((v75 - v76) * (0 : Float))) + ((v78 - v75) * (0 : Float))) + ((v75 - v80) * (1 : Float))), (((((v75 + v134) + v75) + ((v75 - v78) * (0 : Float))) + ((v76 - v75) * (0 : Float))) + ((v80 - v75) * (1 : Float))), (((v189 + ((v80 - v76) * (0 : Float))) + ((v76 - v80) * (0 : Float))) + ((v75 - v75) * (1 : Float))), (((v189 + (((v56 * (1 : Float)) - v89) * (0 : Float))) + v198) + ((v93 - v94) * (1 : Float))), (((v189 + (((v96 * (1 : Float)) - v89) * (0 : Float))) + v198) + ((v93 - v99) * (1 : Float))), ((((v172 + v75) + ((v75 - v76) * (0 : Float))) + ((v78 - v75) * (0 : Float))) + ((v75 - v80) * (1 : Float))), (((((v75 + v134) + v75) + ((v75 - v78) * (0 : Float))) + ((v76 - v75) * (0 : Float))) + ((v80 - v75) * (1 : Float))), (((v189 + ((v80 - v76) * (0 : Float))) + ((v76 - v80) * (0 : Float))) + ((v75 - v75) * (1 : Float))), (((v189 + (((v56 * (1 : Float)) - v89) * (0 : Float))) + v198) + ((v93 - v94) * (1 : Float))), (((v189 + (((v96 * (1 : Float)) - v89) * (0 : Float))) + v198) + ((v93 - v99) * (1 : Float))), (((((v93 + v94) + v75) + ((v94 - ((0.55 : Float) * v56)) * (0 : Float))) + v211) + ((((0.80 : Float) * v56) - (v56 * (0.80 : Float))) * (1 : Float))), (((((v93 + v99) + v75) + ((v99 - ((0.55 : Float) * v96)) * (0 : Float))) + v211) + ((((0.80 : Float) * v96) - (v96 * (0.80 : Float))) * (1 : Float))), (((((((0 : Float) * (v94 - ((0.55 : Float) * v226))) + ((0 : Float) * (((0.55 : Float) * v224) - v93))) + ((1 : Float) * (((0.80 : Float) * v226) - (v56 * v224)))) + ((0 : Float) * v224)) + ((0 : Float) * v226)) + v75), (((((((1 : Float) * v114) + ((0 : Float) * v123)) + v247) + (v114 * (1 : Float))) + v251) + v253), (((v259 + v260) + (v116 * (1 : Float))) + v253), (((v269 + v260) + v251) + (v117 * (1 : Float))), (((v275 + v260) + v251) + v253), (((v279 + v260) + v251) + v253), (((v259 + v283) + v115) + v75), (((v269 + v283) + v113) + v80), (((v275 + v283) + v113) + v75), (((v279 + v283) + v113) + v75), (((((((1 : Float) * (-v121)) + v133) + v75) + (v121 * (1 : Float))) + v113) + v75), (((((((0 : Float) * v114) + ((1 : Float) * v123)) + v247) + (v125 * (1 : Float))) + v309) + v311), (((((((0 : Float) * v125) + ((1 : Float) * v126)) + v258) + v317) + (v150 * (1 : Float))) + v311), (((((((0 : Float) * v129) + ((1 : Float) * v130)) + v268) + v317) + v309) + (v151 * (1 : Float))), ((v133 - v134) + (0 : Float)), ((v137 - v133) + (0 : Float)), ((v75 - v140) + (0 : Float)), ((v133 - v75) + v114), ((v140 - v145) + v116), ((v134 - v140) + v117), ((v153 - v137) + v151), (((((((1 : Float) * (((0 : Float) * v171) - (v161 * (0 : Float)))) + ((0 : Float) * ((v161 * v168) - (v160 * v171)))) + ((0 : Float) * ((v160 * (0 : Float)) - ((0 : Float) * v168)))) + (v114 * v168)) + v251) + (v117 * v171)), (((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))), v121, ((5 : Float) / (12 : Float)), (v163 * ((omegad * rDrum) / v49)), ((((omegam * (0.05 : Float)) / v60) * (60 : Float)) / v120), ((omegam * (60 : Float)) / v120)]

#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.204803 1.146254 1.087705 1.029156 0.970608 0.912059 0.853510 0.794961 0.736412 0.677864 0.619315 0.560766 0.502217 0.443668 0.385120 0.326571 0.268022).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.873611 0.815062 0.756513 0.697964 0.639416 0.580867 0.522318 0.463769 0.405220 0.346672 0.288123 0.229574 1.771025 1.712476 1.653928 1.595379 1.536830).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.542419 0.483870 0.425321 0.366772 0.308224 0.249675 1.791126 1.732577 1.674028 1.615480 1.556931 1.498382 1.439833 1.381284 1.322736 1.264187 1.205638).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.018651 0.960102 0.901553).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.687459 0.628910 0.570361).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.356267 0.297718 0.239169).toBits)

def megaStep (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) : Array Float :=
  let v27 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v39 := ((1.22 : Float) * (0.8 : Float))
  let v40 := ((0.34 : Float) * v27)
  let v43 := ((3.141592653589793 : Float) / (2 : Float))
  let v50 := (if (v39 <= v40) then v43 else (Float.atan ((((1.22 : Float) * v27) + ((0.34 : Float) * (0.8 : Float))) / (v39 - v40))))
  let v51 := (-(1.22 : Float))
  let v52 := (-(0.8 : Float))
  let v54 := (Float.cos (0 : Float))
  let v56 := (-v27)
  let v57 := (Float.sin (0 : Float))
  let v60 := (-v52)
  let v69 := (Float.sqrt (((((v52 * v54) + (v56 * v57)) - v51) ^ 2) + ((((v60 * v57) + (v56 * v54)) - (0.34 : Float)) ^ 2)))
  let v70 := (Float.cos v50)
  let v72 := (Float.sin v50)
  let v83 := (Float.sqrt (((((v52 * v70) + (v56 * v72)) - v51) ^ 2) + ((((v60 * v72) + (v56 * v70)) - (0.34 : Float)) ^ 2)))
  let v84 := (Float.cos t)
  let v86 := (Float.sin t)
  let v88 := ((v52 * v84) + (v56 * v86))
  let v91 := ((v60 * v86) + (v56 * v84))
  let v97 := (Float.sqrt (((v88 - v51) ^ 2) + ((v91 - (0.34 : Float)) ^ 2)))
  let v99 := (omegad * rDrum)
  let v101 := ((v97 + slack) - (v99 * dt))
  let v102 := (v101 < v83)
  let v103 := (v69 < v101)
  let v105 := (if v102 then v83 else (if v103 then v69 else v101))
  let v110 := (((0 : Float) + v50) / (2 : Float))
  let v111 := (Float.cos v110)
  let v113 := (Float.sin v110)
  let v125 := (v105 < (Float.sqrt (((((v52 * v111) + (v56 * v113)) - v51) ^ 2) + ((((v60 * v113) + (v56 * v111)) - (0.34 : Float)) ^ 2))))
  let v126 := (if v125 then v110 else (0 : Float))
  let v127 := (if v125 then v50 else v110)
  let v129 := ((v126 + v127) / (2 : Float))
  let v130 := (Float.cos v129)
  let v132 := (Float.sin v129)
  let v144 := (v105 < (Float.sqrt (((((v52 * v130) + (v56 * v132)) - v51) ^ 2) + ((((v60 * v132) + (v56 * v130)) - (0.34 : Float)) ^ 2))))
  let v145 := (if v144 then v129 else v126)
  let v146 := (if v144 then v127 else v129)
  let v148 := ((v145 + v146) / (2 : Float))
  let v149 := (Float.cos v148)
  let v151 := (Float.sin v148)
  let v163 := (v105 < (Float.sqrt (((((v52 * v149) + (v56 * v151)) - v51) ^ 2) + ((((v60 * v151) + (v56 * v149)) - (0.34 : Float)) ^ 2))))
  let v164 := (if v163 then v148 else v145)
  let v165 := (if v163 then v146 else v148)
  let v167 := ((v164 + v165) / (2 : Float))
  let v168 := (Float.cos v167)
  let v170 := (Float.sin v167)
  let v182 := (v105 < (Float.sqrt (((((v52 * v168) + (v56 * v170)) - v51) ^ 2) + ((((v60 * v170) + (v56 * v168)) - (0.34 : Float)) ^ 2))))
  let v183 := (if v182 then v167 else v164)
  let v184 := (if v182 then v165 else v167)
  let v186 := ((v183 + v184) / (2 : Float))
  let v187 := (Float.cos v186)
  let v189 := (Float.sin v186)
  let v201 := (v105 < (Float.sqrt (((((v52 * v187) + (v56 * v189)) - v51) ^ 2) + ((((v60 * v189) + (v56 * v187)) - (0.34 : Float)) ^ 2))))
  let v202 := (if v201 then v186 else v183)
  let v203 := (if v201 then v184 else v186)
  let v205 := ((v202 + v203) / (2 : Float))
  let v206 := (Float.cos v205)
  let v208 := (Float.sin v205)
  let v220 := (v105 < (Float.sqrt (((((v52 * v206) + (v56 * v208)) - v51) ^ 2) + ((((v60 * v208) + (v56 * v206)) - (0.34 : Float)) ^ 2))))
  let v221 := (if v220 then v205 else v202)
  let v222 := (if v220 then v203 else v205)
  let v224 := ((v221 + v222) / (2 : Float))
  let v225 := (Float.cos v224)
  let v227 := (Float.sin v224)
  let v239 := (v105 < (Float.sqrt (((((v52 * v225) + (v56 * v227)) - v51) ^ 2) + ((((v60 * v227) + (v56 * v225)) - (0.34 : Float)) ^ 2))))
  let v240 := (if v239 then v224 else v221)
  let v241 := (if v239 then v222 else v224)
  let v243 := ((v240 + v241) / (2 : Float))
  let v244 := (Float.cos v243)
  let v246 := (Float.sin v243)
  let v258 := (v105 < (Float.sqrt (((((v52 * v244) + (v56 * v246)) - v51) ^ 2) + ((((v60 * v246) + (v56 * v244)) - (0.34 : Float)) ^ 2))))
  let v259 := (if v258 then v243 else v240)
  let v260 := (if v258 then v241 else v243)
  let v262 := ((v259 + v260) / (2 : Float))
  let v263 := (Float.cos v262)
  let v265 := (Float.sin v262)
  let v277 := (v105 < (Float.sqrt (((((v52 * v263) + (v56 * v265)) - v51) ^ 2) + ((((v60 * v265) + (v56 * v263)) - (0.34 : Float)) ^ 2))))
  let v278 := (if v277 then v262 else v259)
  let v279 := (if v277 then v260 else v262)
  let v281 := ((v278 + v279) / (2 : Float))
  let v282 := (Float.cos v281)
  let v284 := (Float.sin v281)
  let v296 := (v105 < (Float.sqrt (((((v52 * v282) + (v56 * v284)) - v51) ^ 2) + ((((v60 * v284) + (v56 * v282)) - (0.34 : Float)) ^ 2))))
  let v297 := (if v296 then v281 else v278)
  let v298 := (if v296 then v279 else v281)
  let v300 := ((v297 + v298) / (2 : Float))
  let v301 := (Float.cos v300)
  let v303 := (Float.sin v300)
  let v315 := (v105 < (Float.sqrt (((((v52 * v301) + (v56 * v303)) - v51) ^ 2) + ((((v60 * v303) + (v56 * v301)) - (0.34 : Float)) ^ 2))))
  let v316 := (if v315 then v300 else v297)
  let v317 := (if v315 then v298 else v300)
  let v319 := ((v316 + v317) / (2 : Float))
  let v320 := (Float.cos v319)
  let v322 := (Float.sin v319)
  let v334 := (v105 < (Float.sqrt (((((v52 * v320) + (v56 * v322)) - v51) ^ 2) + ((((v60 * v322) + (v56 * v320)) - (0.34 : Float)) ^ 2))))
  let v335 := (if v334 then v319 else v316)
  let v336 := (if v334 then v317 else v319)
  let v338 := ((v335 + v336) / (2 : Float))
  let v339 := (Float.cos v338)
  let v341 := (Float.sin v338)
  let v353 := (v105 < (Float.sqrt (((((v52 * v339) + (v56 * v341)) - v51) ^ 2) + ((((v60 * v341) + (v56 * v339)) - (0.34 : Float)) ^ 2))))
  let v354 := (if v353 then v338 else v335)
  let v355 := (if v353 then v336 else v338)
  let v357 := ((v354 + v355) / (2 : Float))
  let v358 := (Float.cos v357)
  let v360 := (Float.sin v357)
  let v372 := (v105 < (Float.sqrt (((((v52 * v358) + (v56 * v360)) - v51) ^ 2) + ((((v60 * v360) + (v56 * v358)) - (0.34 : Float)) ^ 2))))
  let v373 := (if v372 then v357 else v354)
  let v374 := (if v372 then v355 else v357)
  let v376 := ((v373 + v374) / (2 : Float))
  let v377 := (Float.cos v376)
  let v379 := (Float.sin v376)
  let v391 := (v105 < (Float.sqrt (((((v52 * v377) + (v56 * v379)) - v51) ^ 2) + ((((v60 * v379) + (v56 * v377)) - (0.34 : Float)) ^ 2))))
  let v392 := (if v391 then v376 else v373)
  let v393 := (if v391 then v374 else v376)
  let v395 := ((v392 + v393) / (2 : Float))
  let v396 := (Float.cos v395)
  let v398 := (Float.sin v395)
  let v410 := (v105 < (Float.sqrt (((((v52 * v396) + (v56 * v398)) - v51) ^ 2) + ((((v60 * v398) + (v56 * v396)) - (0.34 : Float)) ^ 2))))
  let v411 := (if v410 then v395 else v392)
  let v412 := (if v410 then v393 else v395)
  let v414 := ((v411 + v412) / (2 : Float))
  let v415 := (Float.cos v414)
  let v417 := (Float.sin v414)
  let v429 := (v105 < (Float.sqrt (((((v52 * v415) + (v56 * v417)) - v51) ^ 2) + ((((v60 * v417) + (v56 * v415)) - (0.34 : Float)) ^ 2))))
  let v430 := (if v429 then v414 else v411)
  let v431 := (if v429 then v412 else v414)
  let v433 := ((v430 + v431) / (2 : Float))
  let v434 := (Float.cos v433)
  let v436 := (Float.sin v433)
  let v448 := (v105 < (Float.sqrt (((((v52 * v434) + (v56 * v436)) - v51) ^ 2) + ((((v60 * v436) + (v56 * v434)) - (0.34 : Float)) ^ 2))))
  let v449 := (if v448 then v433 else v430)
  let v450 := (if v448 then v431 else v433)
  let v452 := ((v449 + v450) / (2 : Float))
  let v453 := (Float.cos v452)
  let v455 := (Float.sin v452)
  let v467 := (v105 < (Float.sqrt (((((v52 * v453) + (v56 * v455)) - v51) ^ 2) + ((((v60 * v455) + (v56 * v453)) - (0.34 : Float)) ^ 2))))
  let v468 := (if v467 then v452 else v449)
  let v469 := (if v467 then v450 else v452)
  let v471 := ((v468 + v469) / (2 : Float))
  let v472 := (Float.cos v471)
  let v474 := (Float.sin v471)
  let v486 := (v105 < (Float.sqrt (((((v52 * v472) + (v56 * v474)) - v51) ^ 2) + ((((v60 * v474) + (v56 * v472)) - (0.34 : Float)) ^ 2))))
  let v487 := (if v486 then v471 else v468)
  let v488 := (if v486 then v469 else v471)
  let v490 := ((v487 + v488) / (2 : Float))
  let v491 := (Float.cos v490)
  let v493 := (Float.sin v490)
  let v505 := (v105 < (Float.sqrt (((((v52 * v491) + (v56 * v493)) - v51) ^ 2) + ((((v60 * v493) + (v56 * v491)) - (0.34 : Float)) ^ 2))))
  let v506 := (if v505 then v490 else v487)
  let v507 := (if v505 then v488 else v490)
  let v509 := ((v506 + v507) / (2 : Float))
  let v510 := (Float.cos v509)
  let v512 := (Float.sin v509)
  let v524 := (v105 < (Float.sqrt (((((v52 * v510) + (v56 * v512)) - v51) ^ 2) + ((((v60 * v512) + (v56 * v510)) - (0.34 : Float)) ^ 2))))
  let v525 := (if v524 then v509 else v506)
  let v526 := (if v524 then v507 else v509)
  let v528 := ((v525 + v526) / (2 : Float))
  let v529 := (Float.cos v528)
  let v531 := (Float.sin v528)
  let v543 := (v105 < (Float.sqrt (((((v52 * v529) + (v56 * v531)) - v51) ^ 2) + ((((v60 * v531) + (v56 * v529)) - (0.34 : Float)) ^ 2))))
  let v544 := (if v543 then v528 else v525)
  let v545 := (if v543 then v526 else v528)
  let v547 := ((v544 + v545) / (2 : Float))
  let v548 := (Float.cos v547)
  let v550 := (Float.sin v547)
  let v562 := (v105 < (Float.sqrt (((((v52 * v548) + (v56 * v550)) - v51) ^ 2) + ((((v60 * v550) + (v56 * v548)) - (0.34 : Float)) ^ 2))))
  let v567 := (if (v69 <= v101) then (0 : Float) else (((if v562 then v547 else v544) + (if v562 then v545 else v547)) / (2 : Float)))
  let v568 := (W * rcm)
  let v569 := (Float.cos v567)
  let v571 := (Float.sin v567)
  let v573 := ((v52 * v569) + (v56 * v571))
  let v576 := ((v60 * v571) + (v56 * v569))
  let v591 := ((t < v567) && (!(v568 <= (Tmax * (((v51 * v576) - ((0.34 : Float) * v573)) / (Float.sqrt (((v573 - v51) ^ 2) + ((v576 - (0.34 : Float)) ^ 2))))))))
  let v592 := (if v591 then t else v567)
  let v602 := (Float.cos v592)
  let v604 := (Float.sin v592)
  let v606 := ((v52 * v602) + (v56 * v604))
  let v609 := ((v60 * v604) + (v56 * v602))
  let v629 := (v86 * (Float.cos az))
  let v631 := (v86 * (Float.sin az))
  let v632 := (Float.cos elSun)
  let v634 := (v632 * (Float.cos azSun))
  let v636 := (v632 * (Float.sin azSun))
  let v637 := (Float.sin elSun)
  let v642 := (((v629 * v634) + (v631 * v636)) + (v84 * v637))
  let v657 := (Float.sqrt (((((v631 * v637) - (v84 * v636)) ^ 2) + (((v84 * v634) - (v629 * v637)) ^ 2)) + (((v629 * v636) - (v631 * v634)) ^ 2)))
  let v667 := (if (v642 <= (0 : Float)) then (v43 + (Float.atan ((-v642) / (max v657 (0.000000000001 : Float))))) else (Float.atan (v657 / v642)))
  let v669 := (v43 - v50)
  let v670 := (v669 <= elSun)
  #[(az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt)), v592, (if v103 then (v101 - v69) else (0 : Float)), (if v591 then v97 else v105), v50, (if (v102 || v591) then (1 : Float) else (0 : Float)), (if (feq (if v103 then (v101 - v69) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v568 <= (Tmax * (((v51 * v609) - ((0.34 : Float) * v606)) / (Float.sqrt (((v606 - v51) ^ 2) + ((v609 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (((v51 * v91) - ((0.34 : Float) * v88)) / v97), (v99 / (((v51 * v91) - ((0.34 : Float) * v88)) / v97)), ((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))), v667, (v43 - t), (if v670 then (1 : Float) else (0 : Float)), (if (v670 && ((0.03 : Float) < v667)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v669) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v669) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v667 - (0.03 : Float)) / (0.01 : Float))))))]

#eval IO.println ("megaStep " ++ toString ((megaStep 0.832499 0.773950 0.715401 0.656852 0.598304 0.539755 0.481206 0.422657 0.364108 0.305560 0.247011 1.788462 1.729913 1.671364 1.612816 1.554267 1.495718).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.501307 0.442758 0.384209 0.325660 0.267112 0.208563 1.750014 1.691465 1.632916 1.574368 1.515819 1.457270 1.398721 1.340172 1.281624 1.223075 1.164526).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.770115 1.711566 1.653017 1.594468 1.535920 1.477371 1.418822 1.360273 1.301724 1.243176 1.184627 1.126078 1.067529 1.008980 0.950432 0.891883 0.833334).map Float.toBits))

def megaThmsClosed (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) : Array Float :=
  let v18 := (Float.sqrt (3.36 : Float))
  let v30 := ((5 : Float) - ((2 : Float) * v18))
  let v31 := (Float.sqrt v30)
  let v39 := ((0.8 : Float) ^ 2)
  let v40 := ((2 : Float) ^ 2)
  let v43 := ((2 : Float) - (Float.sqrt (v40 - v39)))
  let v50 := ((2 : Float) / (2 : Float))
  let v51 := (v50 - v43)
  let v58 := (v18 - (1 : Float))
  let v77 := (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))
  let v86 := (((1.30 : Float) - v77) / (1.30 : Float))
  let v96 := (Float.sqrt (3.2 : Float))
  let v101 := (Float.sqrt ((4.36 : Float) - ((2 : Float) * v96)))
  let v103 := (((3.36 : Float) - v96) / ((2 : Float) * v101))
  let v113 := ((0.34 : Float) * (0.8 : Float))
  let v114 := (((1.22 : Float) * v58) + v113)
  let v115 := ((1.22 : Float) * (0.8 : Float))
  let v116 := ((0.34 : Float) * v58)
  let v118 := (v114 / (v115 - v116))
  let v127 := (((1.2 : Float) * v58) + v113)
  let v129 := (((1.2 : Float) * (0.8 : Float)) - v116)
  let v130 := (v127 / v129)
  let v137 := ((2 : Float) * (0.8 : Float))
  let v142 := ((1.30 : Float) - (0.05 : Float))
  let v158 := ((0.4 : Float) ^ 2)
  let v170 := (Float.sqrt ((((0 : Float) ^ 2) + v158) + ((v50 - ((2 : Float) - (Float.sqrt (v40 - ((Float.sqrt (v39 + v158)) ^ 2))))) ^ 2)))
  let v175 := ((1.30 : Float) - v31)
  let v191 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  let v213 := ((1 : Float) / v118)
  let v223 := ((Float.sqrt (v39 + (v58 ^ 2))) < (1.22 : Float))
  let v233 := ((0.0015 : Float) / v137)
  let v246 := ((5 : Float) / (12 : Float))
  let v257 := ((0.4 : Float) / (v96 - (1 : Float)))
  let v278 := ((((2 : Float) / (360 : Float)) * (1.2192 : Float)) / (0.05 : Float))
  let v289 := (v50 - ((2 : Float) - (Float.sqrt (v40 - ((1 : Float) ^ 2)))))
  let v312 := ((3.141592653589793 : Float) / (3 : Float))
  let v313 := (Float.sin v312)
  let v315 := (Float.cos v312)
  let v319 := ((0.8 : Float) / v58)
  let v336 := ((Float.sqrt (((1.22 : Float) ^ 2) + ((0.34 : Float) ^ 2))) - v31)
  let v349 := (v114 / (Float.sqrt ((((1.22 : Float) - (0.8 : Float)) ^ 2) + (((0.34 : Float) + v58) ^ 2))))
  let v356 := (-(1.22 : Float))
  let v357 := (-(0.8 : Float))
  let v358 := (-v58)
  let v361 := ((v357 * v315) + (v358 * v313))
  let v362 := (-v357)
  let v365 := ((v362 * v313) + (v358 * v315))
  let v375 := (((v356 * v365) - ((0.34 : Float) * v361)) / (Float.sqrt (((v361 - v356) ^ 2) + ((v365 - (0.34 : Float)) ^ 2))))
  let v387 := (v142 - v31)
  let v394 := (Float.cos t)
  let v395 := (Float.sin t)
  let v408 := (v395 * (Float.cos az))
  let v410 := (v395 * (Float.sin az))
  let v411 := (Float.cos elSun)
  let v413 := (v411 * (Float.cos azSun))
  let v415 := (v411 * (Float.sin azSun))
  let v416 := (Float.sin elSun)
  let v421 := (((v408 * v413) + (v410 * v415)) + (v394 * v416))
  let v436 := (Float.sqrt (((((v410 * v416) - (v394 * v415)) ^ 2) + (((v394 * v413) - (v408 * v416)) ^ 2)) + (((v408 * v415) - (v410 * v413)) ^ 2)))
  let v448 := (Float.tan (if (v421 <= (0 : Float)) then (((3.141592653589793 : Float) / (2 : Float)) + (Float.atan ((-v421) / (max v436 (0.000000000001 : Float))))) else (Float.atan (v436 / v421))))
  #[(if (((1.833 : Float) < v18) && (v18 < (1.8331 : Float))) then (1 : Float) else (0 : Float)), (if (((1.154 : Float) < v31) && (v31 < (1.1551 : Float))) then (1 : Float) else (0 : Float)), (if (feq (Float.sqrt ((((1 : Float) - v43) ^ 2) + v39)) v31) then (1 : Float) else (0 : Float)), (if (((0.833 : Float) < v51) && (v51 < (0.8331 : Float))) then (1 : Float) else (0 : Float)), (if (feq v51 v58) then (1 : Float) else (0 : Float)), (if (((0.166 : Float) < v43) && (v43 < (0.168 : Float))) then (1 : Float) else (0 : Float)), (if (feq v43 ((2 : Float) - v18)) then (1 : Float) else (0 : Float)), (if (((0.85 : Float) < v77) && (v77 < (0.851 : Float))) then (1 : Float) else (0 : Float)), (if (v86 < (0.35 : Float)) then (1 : Float) else (0 : Float)), (if ((v86 ^ 3) < ((1 : Float) / (24 : Float))) then (1 : Float) else (0 : Float)), (if (((0.888 : Float) < v103) && (v103 < (0.889 : Float))) then (1 : Float) else (0 : Float)), (if (((1.859 : Float) < v118) && (v118 < (1.86 : Float))) then (1 : Float) else (0 : Float)), (if (((1.878 : Float) < v130) && (v130 < (1.88 : Float))) then (1 : Float) else (0 : Float)), (if (v137 < (1.84 : Float)) then (1 : Float) else (0 : Float)), (if ((0.8 : Float) < v142) then (1 : Float) else (0 : Float)), (if (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float)) then (1 : Float) else (0 : Float)), (if (((0.884 : Float) < v101) && (v101 < (0.8846 : Float))) then (1 : Float) else (0 : Float)), (if (feq v170 v101) then (1 : Float) else (0 : Float)), (if (feq v101 v170) then (1 : Float) else (0 : Float)), (if (((0.1449 : Float) < v175) && (v175 < (0.146 : Float))) then (1 : Float) else (0 : Float)), (if (((0.010 : Float) / (2 : Float)) < (0.010 : Float)) then (1 : Float) else (0 : Float)), (if (feq v191 v191) then (1 : Float) else (0 : Float)), (if ((((0.00175 : Float) * (((62 : Float) * (3.141592653589793 : Float)) / (180 : Float))) / ((2 : Float) * (3.141592653589793 : Float))) < (0.00031 : Float)) then (1 : Float) else (0 : Float)), (if ((0.02 : Float) < ((1.25 : Float) * (Float.sin ((3.141592653589793 : Float) / (180 : Float))))) then (1 : Float) else (0 : Float)), (if (((0.537 : Float) < v213) && (v213 < (0.538 : Float))) then (1 : Float) else (0 : Float)), (if v223 then (1 : Float) else (0 : Float)), (if (v191 < ((0.80 : Float) + (1.22 : Float))) then (1 : Float) else (0 : Float)), (if ((1.17 : Float) < (v115 / v58)) then (1 : Float) else (0 : Float)), (if ((v233 < (0.001 : Float)) && ((((4 : Float) * v233) < (0.00465 : Float)) && (((1 : Float) * v233) < (0.001 : Float)))) then (1 : Float) else (0 : Float)), (if (v246 < (0.5 : Float)) then (1 : Float) else (0 : Float)), (if (feq ((1.59 : Float) - v142) (0.34 : Float)) then (1 : Float) else (0 : Float)), (if (feq v142 (1.25 : Float)) then (1 : Float) else (0 : Float)), (if (((0.507 : Float) < v257) && (v257 < (0.5072 : Float))) then (1 : Float) else (0 : Float)), (if (feq v191 (Float.sqrt (1.4864 : Float))) then (1 : Float) else (0 : Float)), (if (((1.219 : Float) < v191) && (v191 < (1.2195 : Float))) then (1 : Float) else (0 : Float)), (if (((0.13 : Float) < v278) && (v278 < (0.14 : Float))) then (1 : Float) else (0 : Float)), (if (feq v289 ((Float.sqrt (3 : Float)) - (1 : Float))) then (1 : Float) else (0 : Float)), (if (((0.732 : Float) < v289) && (v289 < (0.7321 : Float))) then (1 : Float) else (0 : Float)), (if ((0.0005 : Float) < ((0.01 : Float) * (0.06 : Float))) then (1 : Float) else (0 : Float)), (if (feq (((1.84 : Float) - v137) / (2 : Float)) (0.12 : Float)) then (1 : Float) else (0 : Float)), (if ((v313 * v129) < (v315 * v127)) then (1 : Float) else (0 : Float)), (if (((0.960 : Float) < v319) && (v319 < (0.9605 : Float))) then (1 : Float) else (0 : Float)), (if (((1.7888 : Float) < v96) && (v96 < (1.78886 : Float))) then (1 : Float) else (0 : Float)), (if (((0.111 : Float) < v336) && (v336 < (0.113 : Float))) then (1 : Float) else (0 : Float)), (if (((1.033 : Float) < v349) && (v349 < (1.035 : Float))) then (1 : Float) else (0 : Float)), (if (((0.37 : Float) < v375) && (v375 < (0.38 : Float))) then (1 : Float) else (0 : Float)), (if ((v116 - v115) < (0 : Float)) then (1 : Float) else (0 : Float)), (if (feq (1.22 : Float) (1.22 : Float)) then (1 : Float) else (0 : Float)), (if ((((0.1449 : Float) - (0.05 : Float)) < v387) && (v387 < ((0.146 : Float) - (0.05 : Float)))) then (1 : Float) else (0 : Float)), (if (feq ((((v357 * v394) + (v358 * v395)) ^ 2) + (((v362 * v395) + (v358 * v394)) ^ 2)) v30) then (1 : Float) else (0 : Float)), (if ((((1 : Float) * v448) <= (0.03 : Float)) == (v448 <= (0.03 : Float))) then (1 : Float) else (0 : Float)), (if (v223 == (v31 < (1.22 : Float))) then (1 : Float) else (0 : Float)), (if (!((0 : Float) <= (0.0005 : Float)) || (!((0.0005 : Float) <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin (0.0005 : Float))) <= (0.00065 : Float)))) then (1 : Float) else (0 : Float)), (if (!((4 : Float) <= (4 : Float)) || (!((0 : Float) <= v246) || (!(v246 <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * (4 : Float))) * v246) / (0.0000015 : Float)) < (0.1 : Float))))) then (1 : Float) else (0 : Float)), (if (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10)) then (1 : Float) else (0 : Float)), (if (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float))) then (1 : Float) else (0 : Float))]

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.646347 0.587798 0.529249 0.470700 0.412152 0.353603 0.295054 0.236505 1.777956 1.719408 1.660859 1.602310 1.543761 1.485212 1.426664 1.368115 1.309566).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.315155 0.256606 1.798057 1.739508 1.680960 1.622411 1.563862 1.505313 1.446764 1.388216 1.329667 1.271118 1.212569 1.154020 1.095472 1.036923 0.978374).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.583963 1.525414 1.466865 1.408316 1.349768 1.291219 1.232670 1.174121 1.115572 1.057024 0.998475 0.939926 0.881377 0.822828 0.764280 0.705731 0.647182).map Float.toBits))

def megaThmsState (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) : Array Float :=
  let v22 := ((0.8 : Float) ^ 2)
  let v25 := ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - v22)))
  let v27 := ((1 : Float) - v25)
  let v28 := (-(1.22 : Float))
  let v29 := (-(0.8 : Float))
  let v30 := (Float.cos t)
  let v32 := (-v27)
  let v33 := (Float.sin t)
  let v34 := (v32 * v33)
  let v35 := ((v29 * v30) + v34)
  let v36 := (-v29)
  let v39 := ((v36 * v33) + (v32 * v30))
  let v42 := ((v28 * v39) - ((0.34 : Float) * v35))
  let v47 := (((v35 - v28) ^ 2) + ((v39 - (0.34 : Float)) ^ 2))
  let v48 := (Float.sqrt v47)
  let v49 := (v42 / v48)
  let v51 := ((omegad * rDrum) / v49)
  let v52 := (Float.cos az)
  let v53 := (v33 * v52)
  let v54 := (Float.sin az)
  let v55 := (v33 * v54)
  let v56 := (Float.cos elSun)
  let v58 := (v56 * (Float.cos azSun))
  let v60 := (v56 * (Float.sin azSun))
  let v61 := (Float.sin elSun)
  let v66 := (((v53 * v58) + (v55 * v60)) + (v30 * v61))
  let v81 := (Float.sqrt (((((v55 * v61) - (v30 * v60)) ^ 2) + (((v30 * v58) - (v53 * v61)) ^ 2)) + (((v53 * v60) - (v55 * v58)) ^ 2)))
  let v85 := ((3.141592653589793 : Float) / (2 : Float))
  let v95 := (v85 - t)
  let v102 := ((1.84 : Float) / (2 : Float))
  let v104 := ((0.80 : Float) ^ 2)
  let v105 := ((v102 ^ 2) + v104)
  let v106 := (Float.sqrt v105)
  let v117 := (((0.55 : Float) + (1.30 : Float)) - (0.05 : Float))
  let v119 := (v102 - (0.03 : Float))
  let v120 := ((0 : Float) * (0 : Float))
  let v121 := (v117 * (0 : Float))
  let v122 := (v120 - v121)
  let v123 := (v117 * (1 : Float))
  let v124 := ((0.80 : Float) * (0 : Float))
  let v125 := (v123 - v124)
  let v126 := ((0 : Float) * (1 : Float))
  let v127 := (v124 - v126)
  let v130 := ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))
  let v131 := (W * rcm)
  let v132 := (v131 * v33)
  let v133 := (v132 / v49)
  let v134 := ((0.80 : Float) - v35)
  let v135 := (v117 + v39)
  let v139 := ((v133 * (-(v28 - v35))) / v48)
  let v142 := ((v133 * ((0.34 : Float) - v39)) / v48)
  let v143 := (v102 - (0 : Float))
  let v144 := ((1 : Float) * v143)
  let v147 := ((0.80 : Float) + (1.22 : Float))
  let v149 := (-(0.0005 : Float))
  let v152 := ((0 : Float) < v106)
  let v162 := (-((Fdrive * v102) / v106))
  let v164 := ((Fdrive * (0.80 : Float)) / v106)
  let v165 := (v102 * (0 : Float))
  let v182 := (((((((0 : Float) * (v165 - ((0.55 : Float) * v164))) + ((0 : Float) * (((0.55 : Float) * v162) - v124))) + ((1 : Float) * (((0.80 : Float) * v164) - (v102 * v162)))) + ((0 : Float) * v162)) + ((0 : Float) * v164)) + v120)
  let v192 := (((1.22 : Float) * v27) + ((0.34 : Float) * (0.8 : Float)))
  let v194 := ((0.34 : Float) * v27)
  let v195 := ((1.22 : Float) * (0.8 : Float))
  let v198 := ((v192 * v30) + ((v194 - v195) * v33))
  let v204 := (v27 ^ 2)
  let v205 := (v22 + v204)
  let v212 := (Float.sin (0 : Float))
  let v214 := (Float.cos (0 : Float))
  let v236 := (v33 * (v195 - v194))
  let v237 := (v30 * v192)
  let v242 := ((0 : Float) < v47)
  let v243 := ((0 : Float) < v49)
  let v251 := (v132 * v51)
  let v255 := ((0 : Float) <= W)
  let v256 := ((0 : Float) <= rcm)
  let v257 := ((0 : Float) <= v51)
  let v275 := (feq (0 : Float) (0 : Float))
  let v281 := (((0.55 : Float) * (0.80 : Float)) - v124)
  let v282 := (-v102)
  let v283 := (v282 * (0 : Float))
  let v284 := ((0 : Float) + (0 : Float))
  let v285 := ((2 : Float) * (0.80 : Float))
  let v286 := ((0.62 : Float) * (0 : Float))
  let v287 := (v285 * (0 : Float))
  let v288 := ((0.55 : Float) - (0.62 : Float))
  let v289 := ((0.55 : Float) * (0 : Float))
  let v291 := (v289 - ((0.80 : Float) * (1 : Float)))
  let v292 := ((2 : Float) * (0 : Float))
  let v294 := (v288 * (v284 - v292))
  let v306 := ((2 : Float) * (1 : Float))
  let v312 := (v165 - ((0.55 : Float) * v102))
  let v314 := (v283 - ((0.55 : Float) * v282))
  let v320 := ((v102 * (1 : Float)) - v289)
  let v322 := ((v282 * (1 : Float)) - v289)
  let v331 := ((0.62 : Float) * (1 : Float))
  let v344 := (((0.80 : Float) * v102) - (v102 * (0.80 : Float)))
  let v347 := (((0.80 : Float) * v282) - (v282 * (0.80 : Float)))
  let v352 := (v124 - v165)
  let v353 := (v124 - v283)
  let v367 := ((0 : Float) - (0 : Float))
  let v368 := ((1.84 : Float) * (0 : Float))
  let v369 := ((0.62 : Float) - (0.55 : Float))
  let v370 := (v369 * v367)
  let v381 := ((1 : Float) - (1 : Float))
  let v415 := (v119 * (0 : Float))
  let v416 := (v119 * (1 : Float))
  let v417 := (v125 * (0 : Float))
  let v418 := (v127 * (0 : Float))
  let v419 := (v122 * (0 : Float))
  let v420 := ((1 : Float) * (0 : Float))
  let v421 := ((1 : Float) * v122)
  let v440 := ((((1 : Float) * (v120 - v123)) + ((0 : Float) * (v121 - v415))) + ((0 : Float) * (v416 - v120)))
  let v453 := ((((1 : Float) * (v126 - v121)) + ((0 : Float) * (v121 - v416))) + ((0 : Float) * (v415 - v120)))
  let v460 := ((v420 + v126) + v120)
  let v466 := ((v420 + v120) + v126)
  let v474 := ((feq (((((v421 + ((0 : Float) * (v123 - v415))) + ((0 : Float) * (v415 - v126))) + (v122 * (1 : Float))) + v417) + v418) (0 : Float)) && ((feq (((v440 + v419) + (v125 * (1 : Float))) + v418) (0 : Float)) && ((feq (((v453 + v419) + v417) + (v127 * (1 : Float))) (0 : Float)) && ((feq (((v460 + v419) + v417) + v418) (0 : Float)) && (feq (((v466 + v419) + v417) + v418) (0 : Float))))))
  let v476 := ((1 : Float) * v117)
  let v487 := (feq (0 : Float) v420)
  let v500 := (v28 * (0.34 : Float))
  let v502 := (v28 - (0.01 : Float))
  let v503 := (v502 < v28)
  let v504 := (v28 + (0.01 : Float))
  let v505 := (v28 < v504)
  let v506 := (v504 <= (0 : Float))
  let v507 := ((0.34 : Float) - (0.01 : Float))
  let v509 := ((0.34 : Float) + (0.01 : Float))
  let v524 := ((0.8 : Float) * v27)
  let v525 := ((0.8 : Float) - (0.01 : Float))
  let v527 := ((0.8 : Float) + (0.01 : Float))
  let v530 := (v27 - (0.01 : Float))
  let v532 := (v27 + (0.01 : Float))
  let v547 := (Float.tan (if (v66 <= (0 : Float)) then (v85 + (Float.atan ((-v66) / (max v81 (0.000000000001 : Float))))) else (Float.atan (v81 / v66))))
  let v548 := ((1 : Float) * v547)
  let v550 := ((v306 * slack) / v49)
  let v557 := ((1 : Float) ^ 2)
  let v561 := (v106 ^ 2)
  let v575 := ((0 : Float) < v27)
  let v583 := ((0.8 : Float) * v30)
  let v617 := (v130 * (0 : Float))
  let v657 := (v28 ^ 2)
  let v685 := (-t)
  let v686 := (Float.sin v685)
  let v687 := (Float.cos v685)
  let v689 := ((0 : Float) + ((1 : Float) * v686))
  let v690 := (-v686)
  let v695 := ((1 : Float) * v687)
  let v696 := ((0 : Float) - v695)
  let v716 := ((0 : Float) * (0.80 : Float))
  let v775 := ((v29 * v214) + (v32 * v212))
  let v778 := ((v36 * v212) + (v32 * v214))
  let v798 := ((0 : Float) * v142)
  #[(if (!((0 : Float) < omegam) || (!((0 : Float) < (0.05 : Float)) || (!v152 || ((0 : Float) < ((omegam * (0.05 : Float)) / v106))))) then (1 : Float) else (0 : Float)), (if (feq v182 (Fdrive * v106)) then (1 : Float) else (0 : Float)), (if (!(!(feq Fdrive (0 : Float))) || (!(feq v182 (0 : Float)))) then (1 : Float) else (0 : Float)), (if (feq v42 v198) then (1 : Float) else (0 : Float)), (if (feq ((v35 ^ 2) + (v39 ^ 2)) v205) then (1 : Float) else (0 : Float)), (if ((Float.abs v35) <= (Float.sqrt v205)) then (1 : Float) else (0 : Float)), (if (feq ((v27 * v212) + ((0.8 : Float) * v214)) (0.8 : Float)) then (1 : Float) else (0 : Float)), (if (((v27 * (Float.sin v95)) + ((0.8 : Float) * (Float.cos v95))) <= (Float.sqrt (v204 + v22))) then (1 : Float) else (0 : Float)), (if (feq ((v27 * (Float.sin v85)) + ((0.8 : Float) * (Float.cos v85))) v27) then (1 : Float) else (0 : Float)), (if (!(feq v236 v237) || (feq v42 (0 : Float))) then (1 : Float) else (0 : Float)), (if (!v242 || (v243 == (v236 < v237))) then (1 : Float) else (0 : Float)), (if (!(!(feq v49 (0 : Float))) || (feq (v133 * (v49 * v51)) v251)) then (1 : Float) else (0 : Float)), (if (!v255 || (!v256 || (!v257 || (v251 <= (v131 * v51))))) then (1 : Float) else (0 : Float)), (if (!(!(feq v52 (1 : Float))) || (!((feq ((v52 * (0.80 : Float)) - (v54 * (0 : Float))) (0.80 : Float)) && (feq ((v54 * (0.80 : Float)) + (v52 * (0 : Float))) (0 : Float))) || ((feq (0.80 : Float) (0 : Float)) && v275))) then (1 : Float) else (0 : Float)), (if ((feq ((((0.80 : Float) + (0.80 : Float)) - (v285 * (1 : Float))) + v294) (0 : Float)) && ((feq (((v102 + v282) - v287) + v294) (0 : Float)) && ((feq ((v284 - v287) + (v288 * (((1 : Float) + (1 : Float)) - v306))) (0 : Float)) && ((feq (((v312 + v314) - (v285 * (v120 - v286))) + (v288 * ((v320 + v322) - ((2 : Float) * (v126 - v286))))) (0 : Float)) && ((feq (((v281 + v281) - (v285 * (v331 - v120))) + (v288 * ((v291 + v291) - ((2 : Float) * (v286 - v126))))) (0 : Float)) && (feq (((v344 + v347) - (v285 * (v120 - v126))) + (v288 * ((v352 + v353) - ((2 : Float) * (v120 - v120))))) (0 : Float))))))) then (1 : Float) else (0 : Float)), (if ((feq ((((0.80 : Float) - (0.80 : Float)) - v368) - v370) (0 : Float)) && ((feq (((v102 - v282) - ((1.84 : Float) * (1 : Float))) - v370) (0 : Float)) && ((feq ((v367 - v368) - (v369 * v381)) (0 : Float)) && ((feq (((v312 - v314) - ((1.84 : Float) * (v120 - v331))) - (v369 * (v320 - v322))) (0 : Float)) && ((feq (((v281 - v281) - ((1.84 : Float) * (v286 - v120))) - (v369 * (v291 - v291))) (0 : Float)) && (feq (((v344 - v347) - ((1.84 : Float) * (v126 - v120))) - (v369 * (v352 - v353))) (0 : Float))))))) then (1 : Float) else (0 : Float)), (if (!v474 || (v275 && (v275 && ((feq v122 (0 : Float)) && ((feq v125 v476) && (feq v127 (0 : Float))))))) then (1 : Float) else (0 : Float)), (if (!v474 || ((feq (1 : Float) ((1 : Float) * (1 : Float))) && (v487 && (v487 && ((feq v122 v421) && ((feq v125 ((1 : Float) * v125)) && (feq v127 ((1 : Float) * v127)))))))) then (1 : Float) else (0 : Float)), (if (!v503 || (!v505 || (!v506 || (!(v507 < (0.34 : Float)) || (!((0.34 : Float) < v509) || (!((0 : Float) <= v507) || (((v502 * v509) < v500) && (v500 < (v504 * v507))))))))) then (1 : Float) else (0 : Float)), (if (!(v525 < (0.8 : Float)) || (!((0.8 : Float) < v527) || (!((0 : Float) <= v525) || (!(v530 < v27) || (!(v27 < v532) || (!((0 : Float) <= v530) || (((v525 * v530) < v524) && (v524 < (v527 * v532))))))))) then (1 : Float) else (0 : Float)), (if (!(v548 <= ((0.03 : Float) - v550)) || ((v548 + v550) <= (0.03 : Float))) then (1 : Float) else (0 : Float)), (if (!(feq v557 (1 : Float)) || (feq (v104 + (v144 ^ 2)) v561)) then (1 : Float) else (0 : Float)), (if (feq (v144 - ((-(1 : Float)) * v143)) ((1.84 : Float) - v292)) then (1 : Float) else (0 : Float)), (if (feq (1.30 : Float) (1.30 : Float)) then (1 : Float) else (0 : Float)), (if (feq (0.80 : Float) (0.80 : Float)) then (1 : Float) else (0 : Float)), (if (!v575 || ((v195 <= v194) == ((v195 / v27) <= (0.34 : Float)))) then (1 : Float) else (0 : Float)), (if (!v575 || (!((0 : Float) < v30) || ((feq (v583 + v34) (0 : Float)) == (feq (Float.tan t) ((0.8 : Float) / v27))))) then (1 : Float) else (0 : Float)), (if v152 then (1 : Float) else (0 : Float)), (if (feq v561 v105) then (1 : Float) else (0 : Float)), (if (feq (((2 : Float) / (2 : Float)) - v25) (((2 : Float) - ((2 : Float) / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / (2 : Float))))))) - v25)) then (1 : Float) else (0 : Float)), (if ((feq (1 : Float) (1 : Float)) && (v275 && (v275 && ((feq (0 : Float) v122) && ((feq v117 v125) && (feq (0 : Float) v127)))))) then (1 : Float) else (0 : Float)), (if (!((feq (((v440 + v617) + v123) + v120) (0 : Float)) && ((feq (((v453 + v617) + v121) + v126) (0 : Float)) && ((feq (((v460 + v617) + v121) + v120) (0 : Float)) && ((feq (((v466 + v617) + v121) + v120) (0 : Float)) && (feq (((((((1 : Float) * (-v130)) + ((0 : Float) * v117)) + v120) + (v130 * (1 : Float))) + v121) + v120) (0 : Float)))))) || (v275 && (v275 && ((feq v130 ((1 : Float) * v130)) && ((feq v117 v476) && v275))))) then (1 : Float) else (0 : Float)), (if (!(v548 <= ((0.03 : Float) - v550)) || ((v548 + v550) <= (0.03 : Float))) then (1 : Float) else (0 : Float)), (if (!(v548 <= ((0.03 : Float) - v550)) || ((v548 + v550) <= (0.03 : Float))) then (1 : Float) else (0 : Float)), (if (!v503 || (!v505 || (!v506 || (((v504 ^ 2) < v657) && (v657 < (v502 ^ 2)))))) then (1 : Float) else (0 : Float)), (if (!((0 : Float) < (0.0005 : Float)) || (!(v147 < (0.80 : Float)) || (!(feq v149 v149) || (!v275 || (!v275 || ((((((0.80 : Float) - v147) * v149) + ((v144 - (0 : Float)) * (0 : Float))) + (((1.30 : Float) - (0 : Float)) * (0 : Float))) < (0 : Float))))))) then (1 : Float) else (0 : Float)), (if (feq ((((v689 + ((1 : Float) * v690)) - (0 : Float)) ^ 2) + (((v696 + v695) - (0 : Float)) ^ 2)) (v381 ^ 2)) then (1 : Float) else (0 : Float)), (if (feq ((v690 ^ 2) + (v687 ^ 2)) (1 : Float)) then (1 : Float) else (0 : Float)), (if (feq (((v689 - (0 : Float)) ^ 2) + ((v696 - (0 : Float)) ^ 2)) v557) then (1 : Float) else (0 : Float)), (if (feq ((v420 - v716) + v127) (0 : Float)) then (1 : Float) else (0 : Float)), (if (!v255 || (!v256 || (!v243 || (!(v131 <= (Tmax * v49)) || (v133 <= Tmax))))) then (1 : Float) else (0 : Float)), (if (!((0 : Float) < (1 : Float)) || ((v548 <= (0.03 : Float)) == (v547 <= ((0.03 : Float) / (1 : Float))))) then (1 : Float) else (0 : Float)), (if (!v255 || (!(W <= (1000 : Float)) || (!v256 || (!(rcm <= (1 : Float)) || (!v257 || (!(v51 <= (0.000073 : Float)) || ((v251 <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float)))))))))) then (1 : Float) else (0 : Float)), (if (feq v49 (v198 / (Float.sqrt (((((1.22 : Float) - v583) - (v27 * v33)) ^ 2) + (((((0.8 : Float) * v33) - (v27 * v30)) - (0.34 : Float)) ^ 2))))) then (1 : Float) else (0 : Float)), (if (!v242 || (v243 == ((0 : Float) < v42))) then (1 : Float) else (0 : Float)), (if (feq (((v28 * v778) - ((0.34 : Float) * v775)) / (Float.sqrt (((v775 - v28) ^ 2) + ((v778 - (0.34 : Float)) ^ 2)))) (v192 / (Float.sqrt ((((1.22 : Float) - (0.8 : Float)) ^ 2) + (((0.34 : Float) + v27) ^ 2))))) then (1 : Float) else (0 : Float)), (if (feq (((((((1 : Float) * (v798 - (v135 * (0 : Float)))) + ((0 : Float) * ((v135 * v139) - (v134 * v142)))) + ((0 : Float) * ((v134 * (0 : Float)) - ((0 : Float) * v139)))) + (v122 * v139)) + v417) + (v127 * v142)) (v798 - ((v135 - v117) * (0 : Float)))) then (1 : Float) else (0 : Float)), (if (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!v243 || (((0 : Float) <= v133) == ((0 : Float) <= v33))))) then (1 : Float) else (0 : Float)), (if (feq ((v120 - v716) + (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10)) then (1 : Float) else (0 : Float))]

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.460195 0.401646 0.343097 0.284548 0.226000 1.767451 1.708902 1.650353 1.591804 1.533256 1.474707 1.416158 1.357609 1.299060 1.240512 1.181963 1.123414).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.729003 1.670454 1.611905 1.553356 1.494808 1.436259 1.377710 1.319161 1.260612 1.202064 1.143515 1.084966 1.026417 0.967868 0.909320 0.850771 0.792222).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.397811 1.339262 1.280713 1.222164 1.163616 1.105067 1.046518 0.987969 0.929420 0.870872 0.812323 0.753774 0.695225 0.636676 0.578128 0.519579 0.461030).map Float.toBits))

def mlpPolicy (b2_0 : Float) (b2_1 : Float) (o_0 : Float) (o_1 : Float) (o_2 : Float) (o_3 : Float) (o_4 : Float) (o_5 : Float) (o_6 : Float) (o_7 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) : Array Float :=
  let v202 := (Float.tanh (((((((((W1[0 * 8 + 0]! * o_0) + (W1[0 * 8 + 1]! * o_1)) + (W1[0 * 8 + 2]! * o_2)) + (W1[0 * 8 + 3]! * o_3)) + (W1[0 * 8 + 4]! * o_4)) + (W1[0 * 8 + 5]! * o_5)) + (W1[0 * 8 + 6]! * o_6)) + (W1[0 * 8 + 7]! * o_7)) + b1[0]!))
  let v219 := (Float.tanh (((((((((W1[1 * 8 + 0]! * o_0) + (W1[1 * 8 + 1]! * o_1)) + (W1[1 * 8 + 2]! * o_2)) + (W1[1 * 8 + 3]! * o_3)) + (W1[1 * 8 + 4]! * o_4)) + (W1[1 * 8 + 5]! * o_5)) + (W1[1 * 8 + 6]! * o_6)) + (W1[1 * 8 + 7]! * o_7)) + b1[1]!))
  let v236 := (Float.tanh (((((((((W1[2 * 8 + 0]! * o_0) + (W1[2 * 8 + 1]! * o_1)) + (W1[2 * 8 + 2]! * o_2)) + (W1[2 * 8 + 3]! * o_3)) + (W1[2 * 8 + 4]! * o_4)) + (W1[2 * 8 + 5]! * o_5)) + (W1[2 * 8 + 6]! * o_6)) + (W1[2 * 8 + 7]! * o_7)) + b1[2]!))
  let v253 := (Float.tanh (((((((((W1[3 * 8 + 0]! * o_0) + (W1[3 * 8 + 1]! * o_1)) + (W1[3 * 8 + 2]! * o_2)) + (W1[3 * 8 + 3]! * o_3)) + (W1[3 * 8 + 4]! * o_4)) + (W1[3 * 8 + 5]! * o_5)) + (W1[3 * 8 + 6]! * o_6)) + (W1[3 * 8 + 7]! * o_7)) + b1[3]!))
  let v270 := (Float.tanh (((((((((W1[4 * 8 + 0]! * o_0) + (W1[4 * 8 + 1]! * o_1)) + (W1[4 * 8 + 2]! * o_2)) + (W1[4 * 8 + 3]! * o_3)) + (W1[4 * 8 + 4]! * o_4)) + (W1[4 * 8 + 5]! * o_5)) + (W1[4 * 8 + 6]! * o_6)) + (W1[4 * 8 + 7]! * o_7)) + b1[4]!))
  let v287 := (Float.tanh (((((((((W1[5 * 8 + 0]! * o_0) + (W1[5 * 8 + 1]! * o_1)) + (W1[5 * 8 + 2]! * o_2)) + (W1[5 * 8 + 3]! * o_3)) + (W1[5 * 8 + 4]! * o_4)) + (W1[5 * 8 + 5]! * o_5)) + (W1[5 * 8 + 6]! * o_6)) + (W1[5 * 8 + 7]! * o_7)) + b1[5]!))
  let v304 := (Float.tanh (((((((((W1[6 * 8 + 0]! * o_0) + (W1[6 * 8 + 1]! * o_1)) + (W1[6 * 8 + 2]! * o_2)) + (W1[6 * 8 + 3]! * o_3)) + (W1[6 * 8 + 4]! * o_4)) + (W1[6 * 8 + 5]! * o_5)) + (W1[6 * 8 + 6]! * o_6)) + (W1[6 * 8 + 7]! * o_7)) + b1[6]!))
  let v321 := (Float.tanh (((((((((W1[7 * 8 + 0]! * o_0) + (W1[7 * 8 + 1]! * o_1)) + (W1[7 * 8 + 2]! * o_2)) + (W1[7 * 8 + 3]! * o_3)) + (W1[7 * 8 + 4]! * o_4)) + (W1[7 * 8 + 5]! * o_5)) + (W1[7 * 8 + 6]! * o_6)) + (W1[7 * 8 + 7]! * o_7)) + b1[7]!))
  let v338 := (Float.tanh (((((((((W1[8 * 8 + 0]! * o_0) + (W1[8 * 8 + 1]! * o_1)) + (W1[8 * 8 + 2]! * o_2)) + (W1[8 * 8 + 3]! * o_3)) + (W1[8 * 8 + 4]! * o_4)) + (W1[8 * 8 + 5]! * o_5)) + (W1[8 * 8 + 6]! * o_6)) + (W1[8 * 8 + 7]! * o_7)) + b1[8]!))
  let v355 := (Float.tanh (((((((((W1[9 * 8 + 0]! * o_0) + (W1[9 * 8 + 1]! * o_1)) + (W1[9 * 8 + 2]! * o_2)) + (W1[9 * 8 + 3]! * o_3)) + (W1[9 * 8 + 4]! * o_4)) + (W1[9 * 8 + 5]! * o_5)) + (W1[9 * 8 + 6]! * o_6)) + (W1[9 * 8 + 7]! * o_7)) + b1[9]!))
  let v372 := (Float.tanh (((((((((W1[10 * 8 + 0]! * o_0) + (W1[10 * 8 + 1]! * o_1)) + (W1[10 * 8 + 2]! * o_2)) + (W1[10 * 8 + 3]! * o_3)) + (W1[10 * 8 + 4]! * o_4)) + (W1[10 * 8 + 5]! * o_5)) + (W1[10 * 8 + 6]! * o_6)) + (W1[10 * 8 + 7]! * o_7)) + b1[10]!))
  let v389 := (Float.tanh (((((((((W1[11 * 8 + 0]! * o_0) + (W1[11 * 8 + 1]! * o_1)) + (W1[11 * 8 + 2]! * o_2)) + (W1[11 * 8 + 3]! * o_3)) + (W1[11 * 8 + 4]! * o_4)) + (W1[11 * 8 + 5]! * o_5)) + (W1[11 * 8 + 6]! * o_6)) + (W1[11 * 8 + 7]! * o_7)) + b1[11]!))
  let v406 := (Float.tanh (((((((((W1[12 * 8 + 0]! * o_0) + (W1[12 * 8 + 1]! * o_1)) + (W1[12 * 8 + 2]! * o_2)) + (W1[12 * 8 + 3]! * o_3)) + (W1[12 * 8 + 4]! * o_4)) + (W1[12 * 8 + 5]! * o_5)) + (W1[12 * 8 + 6]! * o_6)) + (W1[12 * 8 + 7]! * o_7)) + b1[12]!))
  let v423 := (Float.tanh (((((((((W1[13 * 8 + 0]! * o_0) + (W1[13 * 8 + 1]! * o_1)) + (W1[13 * 8 + 2]! * o_2)) + (W1[13 * 8 + 3]! * o_3)) + (W1[13 * 8 + 4]! * o_4)) + (W1[13 * 8 + 5]! * o_5)) + (W1[13 * 8 + 6]! * o_6)) + (W1[13 * 8 + 7]! * o_7)) + b1[13]!))
  let v440 := (Float.tanh (((((((((W1[14 * 8 + 0]! * o_0) + (W1[14 * 8 + 1]! * o_1)) + (W1[14 * 8 + 2]! * o_2)) + (W1[14 * 8 + 3]! * o_3)) + (W1[14 * 8 + 4]! * o_4)) + (W1[14 * 8 + 5]! * o_5)) + (W1[14 * 8 + 6]! * o_6)) + (W1[14 * 8 + 7]! * o_7)) + b1[14]!))
  let v457 := (Float.tanh (((((((((W1[15 * 8 + 0]! * o_0) + (W1[15 * 8 + 1]! * o_1)) + (W1[15 * 8 + 2]! * o_2)) + (W1[15 * 8 + 3]! * o_3)) + (W1[15 * 8 + 4]! * o_4)) + (W1[15 * 8 + 5]! * o_5)) + (W1[15 * 8 + 6]! * o_6)) + (W1[15 * 8 + 7]! * o_7)) + b1[15]!))
  #[(Float.tanh (((((((((((((((((W2[0 * 16 + 0]! * v202) + (W2[0 * 16 + 1]! * v219)) + (W2[0 * 16 + 2]! * v236)) + (W2[0 * 16 + 3]! * v253)) + (W2[0 * 16 + 4]! * v270)) + (W2[0 * 16 + 5]! * v287)) + (W2[0 * 16 + 6]! * v304)) + (W2[0 * 16 + 7]! * v321)) + (W2[0 * 16 + 8]! * v338)) + (W2[0 * 16 + 9]! * v355)) + (W2[0 * 16 + 10]! * v372)) + (W2[0 * 16 + 11]! * v389)) + (W2[0 * 16 + 12]! * v406)) + (W2[0 * 16 + 13]! * v423)) + (W2[0 * 16 + 14]! * v440)) + (W2[0 * 16 + 15]! * v457)) + b2_0)), (Float.tanh (((((((((((((((((W2[1 * 16 + 0]! * v202) + (W2[1 * 16 + 1]! * v219)) + (W2[1 * 16 + 2]! * v236)) + (W2[1 * 16 + 3]! * v253)) + (W2[1 * 16 + 4]! * v270)) + (W2[1 * 16 + 5]! * v287)) + (W2[1 * 16 + 6]! * v304)) + (W2[1 * 16 + 7]! * v321)) + (W2[1 * 16 + 8]! * v338)) + (W2[1 * 16 + 9]! * v355)) + (W2[1 * 16 + 10]! * v372)) + (W2[1 * 16 + 11]! * v389)) + (W2[1 * 16 + 12]! * v406)) + (W2[1 * 16 + 13]! * v423)) + (W2[1 * 16 + 14]! * v440)) + (W2[1 * 16 + 15]! * v457)) + b2_1))]

#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.274043 0.215494 1.756945 1.698396 1.639848 1.581299 1.522750 1.464201 1.405652 1.347104 #[0.550659, 0.492110, 0.433561, 0.375012, 0.316464, 0.257915, 1.799366, 1.740817, 1.682268, 1.623720, 1.565171, 1.506622, 1.448073, 1.389524, 1.330976, 1.272427, 1.213878, 1.155329, 1.096780, 1.038232, 0.979683, 0.921134, 0.862585, 0.804036, 0.745488, 0.686939, 0.628390, 0.569841, 0.511292, 0.452744, 0.394195, 0.335646, 0.277097, 0.218548, 1.760000, 1.701451, 1.642902, 1.584353, 1.525804, 1.467256, 1.408707, 1.350158, 1.291609, 1.233060, 1.174512, 1.115963, 1.057414, 0.998865, 0.940316, 0.881768, 0.823219, 0.764670, 0.706121, 0.647572, 0.589024, 0.530475, 0.471926, 0.413377, 0.354828, 0.296280, 0.237731, 1.779182, 1.720633, 1.662084, 1.603536, 1.544987, 1.486438, 1.427889, 1.369340, 1.310792, 1.252243, 1.193694, 1.135145, 1.076596, 1.018048, 0.959499, 0.900950, 0.842401, 0.783852, 0.725304, 0.666755, 0.608206, 0.549657, 0.491108, 0.432560, 0.374011, 0.315462, 0.256913, 1.798364, 1.739816, 1.681267, 1.622718, 1.564169, 1.505620, 1.447072, 1.388523, 1.329974, 1.271425, 1.212876, 1.154328, 1.095779, 1.037230, 0.978681, 0.920132, 0.861584, 0.803035, 0.744486, 0.685937, 0.627388, 0.568840, 0.510291, 0.451742, 0.393193, 0.334644, 0.276096, 0.217547, 1.758998, 1.700449, 1.641900, 1.583352, 1.524803, 1.466254, 1.407705, 1.349156, 1.290608, 1.232059, 1.173510, 1.114961] #[0.550659, 0.492110, 0.433561, 0.375012, 0.316464, 0.257915, 1.799366, 1.740817, 1.682268, 1.623720, 1.565171, 1.506622, 1.448073, 1.389524, 1.330976, 1.272427] #[0.550659, 0.492110, 0.433561, 0.375012, 0.316464, 0.257915, 1.799366, 1.740817, 1.682268, 1.623720, 1.565171, 1.506622, 1.448073, 1.389524, 1.330976, 1.272427, 1.213878, 1.155329, 1.096780, 1.038232, 0.979683, 0.921134, 0.862585, 0.804036, 0.745488, 0.686939, 0.628390, 0.569841, 0.511292, 0.452744, 0.394195, 0.335646]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 1.542851 1.484302 1.425753 1.367204 1.308656 1.250107 1.191558 1.133009 1.074460 1.015912 #[0.219467, 1.760918, 1.702369, 1.643820, 1.585272, 1.526723, 1.468174, 1.409625, 1.351076, 1.292528, 1.233979, 1.175430, 1.116881, 1.058332, 0.999784, 0.941235, 0.882686, 0.824137, 0.765588, 0.707040, 0.648491, 0.589942, 0.531393, 0.472844, 0.414296, 0.355747, 0.297198, 0.238649, 1.780100, 1.721552, 1.663003, 1.604454, 1.545905, 1.487356, 1.428808, 1.370259, 1.311710, 1.253161, 1.194612, 1.136064, 1.077515, 1.018966, 0.960417, 0.901868, 0.843320, 0.784771, 0.726222, 0.667673, 0.609124, 0.550576, 0.492027, 0.433478, 0.374929, 0.316380, 0.257832, 1.799283, 1.740734, 1.682185, 1.623636, 1.565088, 1.506539, 1.447990, 1.389441, 1.330892, 1.272344, 1.213795, 1.155246, 1.096697, 1.038148, 0.979600, 0.921051, 0.862502, 0.803953, 0.745404, 0.686856, 0.628307, 0.569758, 0.511209, 0.452660, 0.394112, 0.335563, 0.277014, 0.218465, 1.759916, 1.701368, 1.642819, 1.584270, 1.525721, 1.467172, 1.408624, 1.350075, 1.291526, 1.232977, 1.174428, 1.115880, 1.057331, 0.998782, 0.940233, 0.881684, 0.823136, 0.764587, 0.706038, 0.647489, 0.588940, 0.530392, 0.471843, 0.413294, 0.354745, 0.296196, 0.237648, 1.779099, 1.720550, 1.662001, 1.603452, 1.544904, 1.486355, 1.427806, 1.369257, 1.310708, 1.252160, 1.193611, 1.135062, 1.076513, 1.017964, 0.959416, 0.900867, 0.842318, 0.783769] #[0.219467, 1.760918, 1.702369, 1.643820, 1.585272, 1.526723, 1.468174, 1.409625, 1.351076, 1.292528, 1.233979, 1.175430, 1.116881, 1.058332, 0.999784, 0.941235] #[0.219467, 1.760918, 1.702369, 1.643820, 1.585272, 1.526723, 1.468174, 1.409625, 1.351076, 1.292528, 1.233979, 1.175430, 1.116881, 1.058332, 0.999784, 0.941235, 0.882686, 0.824137, 0.765588, 0.707040, 0.648491, 0.589942, 0.531393, 0.472844, 0.414296, 0.355747, 0.297198, 0.238649, 1.780100, 1.721552, 1.663003, 1.604454]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 1.211659 1.153110 1.094561 1.036012 0.977464 0.918915 0.860366 0.801817 0.743268 0.684720 #[1.488275, 1.429726, 1.371177, 1.312628, 1.254080, 1.195531, 1.136982, 1.078433, 1.019884, 0.961336, 0.902787, 0.844238, 0.785689, 0.727140, 0.668592, 0.610043, 0.551494, 0.492945, 0.434396, 0.375848, 0.317299, 0.258750, 0.200201, 1.741652, 1.683104, 1.624555, 1.566006, 1.507457, 1.448908, 1.390360, 1.331811, 1.273262, 1.214713, 1.156164, 1.097616, 1.039067, 0.980518, 0.921969, 0.863420, 0.804872, 0.746323, 0.687774, 0.629225, 0.570676, 0.512128, 0.453579, 0.395030, 0.336481, 0.277932, 0.219384, 1.760835, 1.702286, 1.643737, 1.585188, 1.526640, 1.468091, 1.409542, 1.350993, 1.292444, 1.233896, 1.175347, 1.116798, 1.058249, 0.999700, 0.941152, 0.882603, 0.824054, 0.765505, 0.706956, 0.648408, 0.589859, 0.531310, 0.472761, 0.414212, 0.355664, 0.297115, 0.238566, 1.780017, 1.721468, 1.662920, 1.604371, 1.545822, 1.487273, 1.428724, 1.370176, 1.311627, 1.253078, 1.194529, 1.135980, 1.077432, 1.018883, 0.960334, 0.901785, 0.843236, 0.784688, 0.726139, 0.667590, 0.609041, 0.550492, 0.491944, 0.433395, 0.374846, 0.316297, 0.257748, 1.799200, 1.740651, 1.682102, 1.623553, 1.565004, 1.506456, 1.447907, 1.389358, 1.330809, 1.272260, 1.213712, 1.155163, 1.096614, 1.038065, 0.979516, 0.920968, 0.862419, 0.803870, 0.745321, 0.686772, 0.628224, 0.569675, 0.511126, 0.452577] #[1.488275, 1.429726, 1.371177, 1.312628, 1.254080, 1.195531, 1.136982, 1.078433, 1.019884, 0.961336, 0.902787, 0.844238, 0.785689, 0.727140, 0.668592, 0.610043] #[1.488275, 1.429726, 1.371177, 1.312628, 1.254080, 1.195531, 1.136982, 1.078433, 1.019884, 0.961336, 0.902787, 0.844238, 0.785689, 0.727140, 0.668592, 0.610043, 0.551494, 0.492945, 0.434396, 0.375848, 0.317299, 0.258750, 0.200201, 1.741652, 1.683104, 1.624555, 1.566006, 1.507457, 1.448908, 1.390360, 1.331811, 1.273262]).map Float.toBits))

def check_mlpPolicy_bounded (b2_0 : Float) (b2_1 : Float) (o_0 : Float) (o_1 : Float) (o_2 : Float) (o_3 : Float) (o_4 : Float) (o_5 : Float) (o_6 : Float) (o_7 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) : Bool :=
  let v202 := (Float.tanh (((((((((W1[0 * 8 + 0]! * o_0) + (W1[0 * 8 + 1]! * o_1)) + (W1[0 * 8 + 2]! * o_2)) + (W1[0 * 8 + 3]! * o_3)) + (W1[0 * 8 + 4]! * o_4)) + (W1[0 * 8 + 5]! * o_5)) + (W1[0 * 8 + 6]! * o_6)) + (W1[0 * 8 + 7]! * o_7)) + b1[0]!))
  let v219 := (Float.tanh (((((((((W1[1 * 8 + 0]! * o_0) + (W1[1 * 8 + 1]! * o_1)) + (W1[1 * 8 + 2]! * o_2)) + (W1[1 * 8 + 3]! * o_3)) + (W1[1 * 8 + 4]! * o_4)) + (W1[1 * 8 + 5]! * o_5)) + (W1[1 * 8 + 6]! * o_6)) + (W1[1 * 8 + 7]! * o_7)) + b1[1]!))
  let v236 := (Float.tanh (((((((((W1[2 * 8 + 0]! * o_0) + (W1[2 * 8 + 1]! * o_1)) + (W1[2 * 8 + 2]! * o_2)) + (W1[2 * 8 + 3]! * o_3)) + (W1[2 * 8 + 4]! * o_4)) + (W1[2 * 8 + 5]! * o_5)) + (W1[2 * 8 + 6]! * o_6)) + (W1[2 * 8 + 7]! * o_7)) + b1[2]!))
  let v253 := (Float.tanh (((((((((W1[3 * 8 + 0]! * o_0) + (W1[3 * 8 + 1]! * o_1)) + (W1[3 * 8 + 2]! * o_2)) + (W1[3 * 8 + 3]! * o_3)) + (W1[3 * 8 + 4]! * o_4)) + (W1[3 * 8 + 5]! * o_5)) + (W1[3 * 8 + 6]! * o_6)) + (W1[3 * 8 + 7]! * o_7)) + b1[3]!))
  let v270 := (Float.tanh (((((((((W1[4 * 8 + 0]! * o_0) + (W1[4 * 8 + 1]! * o_1)) + (W1[4 * 8 + 2]! * o_2)) + (W1[4 * 8 + 3]! * o_3)) + (W1[4 * 8 + 4]! * o_4)) + (W1[4 * 8 + 5]! * o_5)) + (W1[4 * 8 + 6]! * o_6)) + (W1[4 * 8 + 7]! * o_7)) + b1[4]!))
  let v287 := (Float.tanh (((((((((W1[5 * 8 + 0]! * o_0) + (W1[5 * 8 + 1]! * o_1)) + (W1[5 * 8 + 2]! * o_2)) + (W1[5 * 8 + 3]! * o_3)) + (W1[5 * 8 + 4]! * o_4)) + (W1[5 * 8 + 5]! * o_5)) + (W1[5 * 8 + 6]! * o_6)) + (W1[5 * 8 + 7]! * o_7)) + b1[5]!))
  let v304 := (Float.tanh (((((((((W1[6 * 8 + 0]! * o_0) + (W1[6 * 8 + 1]! * o_1)) + (W1[6 * 8 + 2]! * o_2)) + (W1[6 * 8 + 3]! * o_3)) + (W1[6 * 8 + 4]! * o_4)) + (W1[6 * 8 + 5]! * o_5)) + (W1[6 * 8 + 6]! * o_6)) + (W1[6 * 8 + 7]! * o_7)) + b1[6]!))
  let v321 := (Float.tanh (((((((((W1[7 * 8 + 0]! * o_0) + (W1[7 * 8 + 1]! * o_1)) + (W1[7 * 8 + 2]! * o_2)) + (W1[7 * 8 + 3]! * o_3)) + (W1[7 * 8 + 4]! * o_4)) + (W1[7 * 8 + 5]! * o_5)) + (W1[7 * 8 + 6]! * o_6)) + (W1[7 * 8 + 7]! * o_7)) + b1[7]!))
  let v338 := (Float.tanh (((((((((W1[8 * 8 + 0]! * o_0) + (W1[8 * 8 + 1]! * o_1)) + (W1[8 * 8 + 2]! * o_2)) + (W1[8 * 8 + 3]! * o_3)) + (W1[8 * 8 + 4]! * o_4)) + (W1[8 * 8 + 5]! * o_5)) + (W1[8 * 8 + 6]! * o_6)) + (W1[8 * 8 + 7]! * o_7)) + b1[8]!))
  let v355 := (Float.tanh (((((((((W1[9 * 8 + 0]! * o_0) + (W1[9 * 8 + 1]! * o_1)) + (W1[9 * 8 + 2]! * o_2)) + (W1[9 * 8 + 3]! * o_3)) + (W1[9 * 8 + 4]! * o_4)) + (W1[9 * 8 + 5]! * o_5)) + (W1[9 * 8 + 6]! * o_6)) + (W1[9 * 8 + 7]! * o_7)) + b1[9]!))
  let v372 := (Float.tanh (((((((((W1[10 * 8 + 0]! * o_0) + (W1[10 * 8 + 1]! * o_1)) + (W1[10 * 8 + 2]! * o_2)) + (W1[10 * 8 + 3]! * o_3)) + (W1[10 * 8 + 4]! * o_4)) + (W1[10 * 8 + 5]! * o_5)) + (W1[10 * 8 + 6]! * o_6)) + (W1[10 * 8 + 7]! * o_7)) + b1[10]!))
  let v389 := (Float.tanh (((((((((W1[11 * 8 + 0]! * o_0) + (W1[11 * 8 + 1]! * o_1)) + (W1[11 * 8 + 2]! * o_2)) + (W1[11 * 8 + 3]! * o_3)) + (W1[11 * 8 + 4]! * o_4)) + (W1[11 * 8 + 5]! * o_5)) + (W1[11 * 8 + 6]! * o_6)) + (W1[11 * 8 + 7]! * o_7)) + b1[11]!))
  let v406 := (Float.tanh (((((((((W1[12 * 8 + 0]! * o_0) + (W1[12 * 8 + 1]! * o_1)) + (W1[12 * 8 + 2]! * o_2)) + (W1[12 * 8 + 3]! * o_3)) + (W1[12 * 8 + 4]! * o_4)) + (W1[12 * 8 + 5]! * o_5)) + (W1[12 * 8 + 6]! * o_6)) + (W1[12 * 8 + 7]! * o_7)) + b1[12]!))
  let v423 := (Float.tanh (((((((((W1[13 * 8 + 0]! * o_0) + (W1[13 * 8 + 1]! * o_1)) + (W1[13 * 8 + 2]! * o_2)) + (W1[13 * 8 + 3]! * o_3)) + (W1[13 * 8 + 4]! * o_4)) + (W1[13 * 8 + 5]! * o_5)) + (W1[13 * 8 + 6]! * o_6)) + (W1[13 * 8 + 7]! * o_7)) + b1[13]!))
  let v440 := (Float.tanh (((((((((W1[14 * 8 + 0]! * o_0) + (W1[14 * 8 + 1]! * o_1)) + (W1[14 * 8 + 2]! * o_2)) + (W1[14 * 8 + 3]! * o_3)) + (W1[14 * 8 + 4]! * o_4)) + (W1[14 * 8 + 5]! * o_5)) + (W1[14 * 8 + 6]! * o_6)) + (W1[14 * 8 + 7]! * o_7)) + b1[14]!))
  let v457 := (Float.tanh (((((((((W1[15 * 8 + 0]! * o_0) + (W1[15 * 8 + 1]! * o_1)) + (W1[15 * 8 + 2]! * o_2)) + (W1[15 * 8 + 3]! * o_3)) + (W1[15 * 8 + 4]! * o_4)) + (W1[15 * 8 + 5]! * o_5)) + (W1[15 * 8 + 6]! * o_6)) + (W1[15 * 8 + 7]! * o_7)) + b1[15]!))
  (((Float.abs (Float.tanh (((((((((((((((((W2[0 * 16 + 0]! * v202) + (W2[0 * 16 + 1]! * v219)) + (W2[0 * 16 + 2]! * v236)) + (W2[0 * 16 + 3]! * v253)) + (W2[0 * 16 + 4]! * v270)) + (W2[0 * 16 + 5]! * v287)) + (W2[0 * 16 + 6]! * v304)) + (W2[0 * 16 + 7]! * v321)) + (W2[0 * 16 + 8]! * v338)) + (W2[0 * 16 + 9]! * v355)) + (W2[0 * 16 + 10]! * v372)) + (W2[0 * 16 + 11]! * v389)) + (W2[0 * 16 + 12]! * v406)) + (W2[0 * 16 + 13]! * v423)) + (W2[0 * 16 + 14]! * v440)) + (W2[0 * 16 + 15]! * v457)) + b2_0))) <= (1 : Float)) && ((Float.abs (Float.tanh (((((((((((((((((W2[1 * 16 + 0]! * v202) + (W2[1 * 16 + 1]! * v219)) + (W2[1 * 16 + 2]! * v236)) + (W2[1 * 16 + 3]! * v253)) + (W2[1 * 16 + 4]! * v270)) + (W2[1 * 16 + 5]! * v287)) + (W2[1 * 16 + 6]! * v304)) + (W2[1 * 16 + 7]! * v321)) + (W2[1 * 16 + 8]! * v338)) + (W2[1 * 16 + 9]! * v355)) + (W2[1 * 16 + 10]! * v372)) + (W2[1 * 16 + 11]! * v389)) + (W2[1 * 16 + 12]! * v406)) + (W2[1 * 16 + 13]! * v423)) + (W2[1 * 16 + 14]! * v440)) + (W2[1 * 16 + 15]! * v457)) + b2_1))) <= (1 : Float)))

#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.687891 1.629342 1.570793 1.512244 1.453696 1.395147 1.336598 1.278049 1.219500 1.160952 #[0.364507, 0.305958, 0.247409, 1.788860, 1.730312, 1.671763, 1.613214, 1.554665, 1.496116, 1.437568, 1.379019, 1.320470, 1.261921, 1.203372, 1.144824, 1.086275, 1.027726, 0.969177, 0.910628, 0.852080, 0.793531, 0.734982, 0.676433, 0.617884, 0.559336, 0.500787, 0.442238, 0.383689, 0.325140, 0.266592, 0.208043, 1.749494, 1.690945, 1.632396, 1.573848, 1.515299, 1.456750, 1.398201, 1.339652, 1.281104, 1.222555, 1.164006, 1.105457, 1.046908, 0.988360, 0.929811, 0.871262, 0.812713, 0.754164, 0.695616, 0.637067, 0.578518, 0.519969, 0.461420, 0.402872, 0.344323, 0.285774, 0.227225, 1.768676, 1.710128, 1.651579, 1.593030, 1.534481, 1.475932, 1.417384, 1.358835, 1.300286, 1.241737, 1.183188, 1.124640, 1.066091, 1.007542, 0.948993, 0.890444, 0.831896, 0.773347, 0.714798, 0.656249, 0.597700, 0.539152, 0.480603, 0.422054, 0.363505, 0.304956, 0.246408, 1.787859, 1.729310, 1.670761, 1.612212, 1.553664, 1.495115, 1.436566, 1.378017, 1.319468, 1.260920, 1.202371, 1.143822, 1.085273, 1.026724, 0.968176, 0.909627, 0.851078, 0.792529, 0.733980, 0.675432, 0.616883, 0.558334, 0.499785, 0.441236, 0.382688, 0.324139, 0.265590, 0.207041, 1.748492, 1.689944, 1.631395, 1.572846, 1.514297, 1.455748, 1.397200, 1.338651, 1.280102, 1.221553, 1.163004, 1.104456, 1.045907, 0.987358, 0.928809] #[0.364507, 0.305958, 0.247409, 1.788860, 1.730312, 1.671763, 1.613214, 1.554665, 1.496116, 1.437568, 1.379019, 1.320470, 1.261921, 1.203372, 1.144824, 1.086275] #[0.364507, 0.305958, 0.247409, 1.788860, 1.730312, 1.671763, 1.613214, 1.554665, 1.496116, 1.437568, 1.379019, 1.320470, 1.261921, 1.203372, 1.144824, 1.086275, 1.027726, 0.969177, 0.910628, 0.852080, 0.793531, 0.734982, 0.676433, 0.617884, 0.559336, 0.500787, 0.442238, 0.383689, 0.325140, 0.266592, 0.208043, 1.749494]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.356699 1.298150 1.239601 1.181052 1.122504 1.063955 1.005406 0.946857 0.888308 0.829760 #[1.633315, 1.574766, 1.516217, 1.457668, 1.399120, 1.340571, 1.282022, 1.223473, 1.164924, 1.106376, 1.047827, 0.989278, 0.930729, 0.872180, 0.813632, 0.755083, 0.696534, 0.637985, 0.579436, 0.520888, 0.462339, 0.403790, 0.345241, 0.286692, 0.228144, 1.769595, 1.711046, 1.652497, 1.593948, 1.535400, 1.476851, 1.418302, 1.359753, 1.301204, 1.242656, 1.184107, 1.125558, 1.067009, 1.008460, 0.949912, 0.891363, 0.832814, 0.774265, 0.715716, 0.657168, 0.598619, 0.540070, 0.481521, 0.422972, 0.364424, 0.305875, 0.247326, 1.788777, 1.730228, 1.671680, 1.613131, 1.554582, 1.496033, 1.437484, 1.378936, 1.320387, 1.261838, 1.203289, 1.144740, 1.086192, 1.027643, 0.969094, 0.910545, 0.851996, 0.793448, 0.734899, 0.676350, 0.617801, 0.559252, 0.500704, 0.442155, 0.383606, 0.325057, 0.266508, 0.207960, 1.749411, 1.690862, 1.632313, 1.573764, 1.515216, 1.456667, 1.398118, 1.339569, 1.281020, 1.222472, 1.163923, 1.105374, 1.046825, 0.988276, 0.929728, 0.871179, 0.812630, 0.754081, 0.695532, 0.636984, 0.578435, 0.519886, 0.461337, 0.402788, 0.344240, 0.285691, 0.227142, 1.768593, 1.710044, 1.651496, 1.592947, 1.534398, 1.475849, 1.417300, 1.358752, 1.300203, 1.241654, 1.183105, 1.124556, 1.066008, 1.007459, 0.948910, 0.890361, 0.831812, 0.773264, 0.714715, 0.656166, 0.597617] #[1.633315, 1.574766, 1.516217, 1.457668, 1.399120, 1.340571, 1.282022, 1.223473, 1.164924, 1.106376, 1.047827, 0.989278, 0.930729, 0.872180, 0.813632, 0.755083] #[1.633315, 1.574766, 1.516217, 1.457668, 1.399120, 1.340571, 1.282022, 1.223473, 1.164924, 1.106376, 1.047827, 0.989278, 0.930729, 0.872180, 0.813632, 0.755083, 0.696534, 0.637985, 0.579436, 0.520888, 0.462339, 0.403790, 0.345241, 0.286692, 0.228144, 1.769595, 1.711046, 1.652497, 1.593948, 1.535400, 1.476851, 1.418302]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.025507 0.966958 0.908409 0.849860 0.791312 0.732763 0.674214 0.615665 0.557116 0.498568 #[1.302123, 1.243574, 1.185025, 1.126476, 1.067928, 1.009379, 0.950830, 0.892281, 0.833732, 0.775184, 0.716635, 0.658086, 0.599537, 0.540988, 0.482440, 0.423891, 0.365342, 0.306793, 0.248244, 1.789696, 1.731147, 1.672598, 1.614049, 1.555500, 1.496952, 1.438403, 1.379854, 1.321305, 1.262756, 1.204208, 1.145659, 1.087110, 1.028561, 0.970012, 0.911464, 0.852915, 0.794366, 0.735817, 0.677268, 0.618720, 0.560171, 0.501622, 0.443073, 0.384524, 0.325976, 0.267427, 0.208878, 1.750329, 1.691780, 1.633232, 1.574683, 1.516134, 1.457585, 1.399036, 1.340488, 1.281939, 1.223390, 1.164841, 1.106292, 1.047744, 0.989195, 0.930646, 0.872097, 0.813548, 0.755000, 0.696451, 0.637902, 0.579353, 0.520804, 0.462256, 0.403707, 0.345158, 0.286609, 0.228060, 1.769512, 1.710963, 1.652414, 1.593865, 1.535316, 1.476768, 1.418219, 1.359670, 1.301121, 1.242572, 1.184024, 1.125475, 1.066926, 1.008377, 0.949828, 0.891280, 0.832731, 0.774182, 0.715633, 0.657084, 0.598536, 0.539987, 0.481438, 0.422889, 0.364340, 0.305792, 0.247243, 1.788694, 1.730145, 1.671596, 1.613048, 1.554499, 1.495950, 1.437401, 1.378852, 1.320304, 1.261755, 1.203206, 1.144657, 1.086108, 1.027560, 0.969011, 0.910462, 0.851913, 0.793364, 0.734816, 0.676267, 0.617718, 0.559169, 0.500620, 0.442072, 0.383523, 0.324974, 0.266425] #[1.302123, 1.243574, 1.185025, 1.126476, 1.067928, 1.009379, 0.950830, 0.892281, 0.833732, 0.775184, 0.716635, 0.658086, 0.599537, 0.540988, 0.482440, 0.423891] #[1.302123, 1.243574, 1.185025, 1.126476, 1.067928, 1.009379, 0.950830, 0.892281, 0.833732, 0.775184, 0.716635, 0.658086, 0.599537, 0.540988, 0.482440, 0.423891, 0.365342, 0.306793, 0.248244, 1.789696, 1.731147, 1.672598, 1.614049, 1.555500, 1.496952, 1.438403, 1.379854, 1.321305, 1.262756, 1.204208, 1.145659, 1.087110]))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.501739 1.443190 1.384641 1.326092 1.267544 1.208995))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.170547 1.111998 1.053449 0.994900 0.936352 0.877803))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.839355 0.780806 0.722257 0.663708 0.605160 0.546611))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.315587 1.257038 1.198489 1.139940 1.081392 1.022843))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.984395 0.925846 0.867297 0.808748 0.750200 0.691651))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.653203 0.594654 0.536105 0.477556 0.419008 0.360459))

def obsOf (az : Float) (t : Float) (elSun : Float) (azSun : Float) (taut : Float) (holds : Float) (Toil : Float) (tDead : Float) : Array Float :=
  let v8 := (azSun - az)
  let v11 := ((2 : Float) * (3.141592653589793 : Float))
  let v17 := ((3.141592653589793 : Float) / (2 : Float))
  let v28 := (Float.sin t)
  let v30 := (v28 * (Float.cos az))
  let v32 := (v28 * (Float.sin az))
  let v33 := (Float.cos t)
  let v34 := (Float.cos elSun)
  let v36 := (v34 * (Float.cos azSun))
  let v38 := (v34 * (Float.sin azSun))
  let v39 := (Float.sin elSun)
  let v44 := (((v30 * v36) + (v32 * v38)) + (v33 * v39))
  let v59 := (Float.sqrt (((((v32 * v39) - (v33 * v38)) ^ 2) + (((v33 * v36) - (v30 * v39)) ^ 2)) + (((v30 * v38) - (v32 * v36)) ^ 2)))
  #[(v8 - (v11 * (Float.floor ((v8 + (3.141592653589793 : Float)) / v11)))), ((v17 - t) - elSun), t, taut, holds, ((Toil - (300 : Float)) / (300 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - (v17 - tDead)) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - (v17 - tDead)) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-(((if (v44 <= (0 : Float)) then (v17 + (Float.atan ((-v44) / (max v59 (0.000000000001 : Float))))) else (Float.atan (v59 / v44))) - (0.03 : Float)) / (0.01 : Float))))))]

#eval IO.println ("obsOf " ++ toString ((obsOf 1.129435 1.070886 1.012337 0.953788 0.895240 0.836691 0.778142 0.719593).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.798243 0.739694 0.681145 0.622596 0.564048 0.505499 0.446950 0.388401).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.467051 0.408502 0.349953 0.291404 0.232856 1.774307 1.715758 1.657209).map Float.toBits))

def oilStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Float :=
  let v22 := (Toil - Ta)
  (min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil)))

#eval IO.println ("oilStep " ++ toString (oilStep 0.943283 0.884734 0.826185 0.767636 0.709088 0.650539 0.591990 0.533441 0.474892 0.416344 0.357795 0.299246 0.240697).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.612091 0.553542 0.494993 0.436444 0.377896 0.319347 0.260798 0.202249 1.743700 1.685152 1.626603 1.568054 1.509505).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.280899 0.222350 1.763801 1.705252 1.646704 1.588155 1.529606 1.471057 1.412508 1.353960 1.295411 1.236862 1.178313).toBits)

def check_oilStep_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Twall : Float) (Ta : Float) (dt : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v27 := (alpha * Pin)
  let v30 := ((eps * (0.0000000567 : Float)) * Ac)
  let v32 := (Ta ^ 4)
  let v35 := (hC * Ac)
  let v36 := (T1 - Ta)
  let v53 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) < Coil) || (!((0 : Float) <= dt) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((min ToilMax (T1 + ((dt * (((v27 - ((v30 * ((T1 ^ 4) - v32)) + (v35 * v36))) - (Upipe * v36)) - (max (0 : Float) (UAx * (T1 - Twall))))) / Coil))) - (min ToilMax (T2 + ((dt * (((v27 - ((v30 * ((T2 ^ 4) - v32)) + (v35 * v53))) - (Upipe * v53)) - (max (0 : Float) (UAx * (T2 - Twall))))) / Coil))))) <= (((1 : Float) + ((dt * ((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v35) + Upipe) + UAx)) / Coil)) * (Float.abs (T1 - T2)))))))))))))))

#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.757131 0.698582 0.640033 0.581484 0.522936 0.464387 0.405838 0.347289 0.288740 0.230192 1.771643 1.713094 1.654545 1.595996 1.537448))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.425939 0.367390 0.308841 0.250292 1.791744 1.733195 1.674646 1.616097 1.557548 1.499000 1.440451 1.381902 1.323353 1.264804 1.206256))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.694747 1.636198 1.577649 1.519100 1.460552 1.402003 1.343454 1.284905 1.226356 1.167808 1.109259 1.050710 0.992161 0.933612 0.875064))

def check_one_turn_tilt  : Bool :=
  let v4 := ((0.0015 : Float) / ((2 : Float) * (0.8 : Float)))
  ((v4 < (0.001 : Float)) && ((((4 : Float) * v4) < (0.00465 : Float)) && (((1 : Float) * v4) < (0.001 : Float))))

#eval IO.println ("check_one_turn_tilt " ++ toString (check_one_turn_tilt))
#eval IO.println ("check_one_turn_tilt " ++ toString (check_one_turn_tilt))
#eval IO.println ("check_one_turn_tilt " ++ toString (check_one_turn_tilt))

def check_panel_current  : Bool :=
  (((5 : Float) / (12 : Float)) < (0.5 : Float))

#eval IO.println ("check_panel_current " ++ toString (check_panel_current))
#eval IO.println ("check_panel_current " ++ toString (check_panel_current))
#eval IO.println ("check_panel_current " ++ toString (check_panel_current))

def check_play_budget (f : Float) (eps : Float) (h : Float) (delta : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.798675 1.740126 1.681577 1.623028))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.467483 1.408934 1.350385 1.291836))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.136291 1.077742 1.019193 0.960644))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.612523))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.281331))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.950139))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 1.426371 1.367822 1.309273 1.250724 1.192176 1.133627 1.075078 1.016529 0.957980).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 1.095179 1.036630 0.978081 0.919532 0.860984 0.802435 0.743886 0.685337 0.626788).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.763987 0.705438 0.646889 0.588340 0.529792 0.471243 0.412694 0.354145 0.295596).map Float.toBits))

def pointingError (az : Float) (t : Float) (elSun : Float) (azSun : Float) : Float :=
  let v4 := (Float.sin t)
  let v6 := (v4 * (Float.cos az))
  let v8 := (v4 * (Float.sin az))
  let v9 := (Float.cos t)
  let v10 := (Float.cos elSun)
  let v12 := (v10 * (Float.cos azSun))
  let v14 := (v10 * (Float.sin azSun))
  let v15 := (Float.sin elSun)
  let v20 := (((v6 * v12) + (v8 * v14)) + (v9 * v15))
  let v35 := (Float.sqrt (((((v8 * v15) - (v9 * v14)) ^ 2) + (((v9 * v12) - (v6 * v15)) ^ 2)) + (((v6 * v14) - (v8 * v12)) ^ 2)))
  (if (v20 <= (0 : Float)) then (((3.141592653589793 : Float) / (2 : Float)) + (Float.atan ((-v20) / (max v35 (0.000000000001 : Float))))) else (Float.atan (v35 / v20)))

#eval IO.println ("pointingError " ++ toString (pointingError 1.240219 1.181670 1.123121 1.064572).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.909027 0.850478 0.791929 0.733380).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.577835 0.519286 0.460737 0.402188).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 1.054067 0.995518 0.936969 0.878420 0.819872 0.761323 0.702774 0.644225 0.585676 0.527128 0.468579 0.410030 0.351481).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 0.722875 0.664326 0.605777 0.547228 0.488680 0.430131 0.371582 0.313033 0.254484 1.795936 1.737387 1.678838 1.620289).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 0.391683 0.333134 0.274585 0.216036 1.757488 1.698939 1.640390 1.581841 1.523292 1.464744 1.406195 1.347646 1.289097).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.867915 0.809366 0.750817 0.692268 0.633720 0.575171 0.516622 0.458073 0.399524 0.340976 0.282427 0.223878))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.536723 0.478174 0.419625 0.361076 0.302528 0.243979 1.785430 1.726881 1.668332 1.609784 1.551235 1.492686))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.205531 1.746982 1.688433 1.629884 1.571336 1.512787 1.454238 1.395689 1.337140 1.278592 1.220043 1.161494))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.681763 0.623214 0.564665 0.506116 0.447568 0.389019 0.330470 0.271921 0.213372 1.754824 1.696275 1.637726))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.350571 0.292022 0.233473 1.774924 1.716376 1.657827 1.599278 1.540729 1.482180 1.423632 1.365083 1.306534))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.619379 1.560830 1.502281 1.443732 1.385184 1.326635 1.268086 1.209537 1.150988 1.092440 1.033891 0.975342))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.495611 0.437062 0.378513 0.319964 0.261416 0.202867 1.744318 1.685769 1.627220 1.568672 1.510123 1.451574))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.764419 1.705870 1.647321 1.588772 1.530224 1.471675 1.413126 1.354577 1.296028 1.237480 1.178931 1.120382))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.433227 1.374678 1.316129 1.257580 1.199032 1.140483 1.081934 1.023385 0.964836 0.906288 0.847739 0.789190))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.309459 0.250910 1.792361 1.733812 1.675264 1.616715 1.558166 1.499617 1.441068 1.382520 1.323971 1.265422 1.206873))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.578267 1.519718 1.461169 1.402620 1.344072 1.285523 1.226974 1.168425 1.109876 1.051328 0.992779 0.934230 0.875681))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.247075 1.188526 1.129977 1.071428 1.012880 0.954331 0.895782 0.837233 0.778684 0.720136 0.661587 0.603038 0.544489))

def check_pow4_lipschitz (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((T1 ^ 4) - (T2 ^ 4))) <= (((4 : Float) * (M ^ 3)) * (Float.abs (T1 - T2))))))))

#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.723307 1.664758 1.606209))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.392115 1.333566 1.275017))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.060923 1.002374 0.943825))

def prop_AH_bounds  : Bool :=
  let v1 := (Float.sqrt (3.36 : Float))
  (((1.833 : Float) < v1) && (v1 < (1.8331 : Float)))

#eval IO.println ("prop_AH_bounds " ++ toString (prop_AH_bounds))
#eval IO.println ("prop_AH_bounds " ++ toString (prop_AH_bounds))
#eval IO.println ("prop_AH_bounds " ++ toString (prop_AH_bounds))

def prop_FC_bounds  : Bool :=
  let v6 := (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float)))))
  (((1.154 : Float) < v6) && (v6 < (1.1551 : Float)))

#eval IO.println ("prop_FC_bounds " ++ toString (prop_FC_bounds))
#eval IO.println ("prop_FC_bounds " ++ toString (prop_FC_bounds))
#eval IO.println ("prop_FC_bounds " ++ toString (prop_FC_bounds))

def prop_FC_eq  : Bool :=
  let v1 := ((0.8 : Float) ^ 2)
  (feq (Float.sqrt ((((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - v1)))) ^ 2) + v1)) (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))

#eval IO.println ("prop_FC_eq " ++ toString (prop_FC_eq))
#eval IO.println ("prop_FC_eq " ++ toString (prop_FC_eq))
#eval IO.println ("prop_FC_eq " ++ toString (prop_FC_eq))

def prop_FH_bounds  : Bool :=
  let v8 := (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  (((0.833 : Float) < v8) && (v8 < (0.8331 : Float)))

#eval IO.println ("prop_FH_bounds " ++ toString (prop_FH_bounds))
#eval IO.println ("prop_FH_bounds " ++ toString (prop_FH_bounds))
#eval IO.println ("prop_FH_bounds " ++ toString (prop_FH_bounds))

def prop_FH_eq  : Bool :=
  (feq (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))) ((Float.sqrt (3.36 : Float)) - (1 : Float)))

#eval IO.println ("prop_FH_eq " ++ toString (prop_FH_eq))
#eval IO.println ("prop_FH_eq " ++ toString (prop_FH_eq))
#eval IO.println ("prop_FH_eq " ++ toString (prop_FH_eq))

def prop_HD_bounds  : Bool :=
  let v6 := ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))
  (((0.166 : Float) < v6) && (v6 < (0.168 : Float)))

#eval IO.println ("prop_HD_bounds " ++ toString (prop_HD_bounds))
#eval IO.println ("prop_HD_bounds " ++ toString (prop_HD_bounds))
#eval IO.println ("prop_HD_bounds " ++ toString (prop_HD_bounds))

def prop_HD_eq  : Bool :=
  (feq ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))) ((2 : Float) - (Float.sqrt (3.36 : Float))))

#eval IO.println ("prop_HD_eq " ++ toString (prop_HD_eq))
#eval IO.println ("prop_HD_eq " ++ toString (prop_HD_eq))
#eval IO.println ("prop_HD_eq " ++ toString (prop_HD_eq))

def prop_azRate_pos (omegam : Float) (rw : Float) (R : Float) : Bool :=
  (!((0 : Float) < omegam) || (!((0 : Float) < rw) || (!((0 : Float) < R) || ((0 : Float) < ((omegam * rw) / R)))))

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.234091 1.775542 1.716993))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.502899 1.444350 1.385801))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.171707 1.113158 1.054609))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.647939))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.316747))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.985555))

def prop_braceHeight_hashemi  : Bool :=
  let v7 := (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))
  (((0.85 : Float) < v7) && (v7 < (0.851 : Float)))

#eval IO.println ("prop_braceHeight_hashemi " ++ toString (prop_braceHeight_hashemi))
#eval IO.println ("prop_braceHeight_hashemi " ++ toString (prop_braceHeight_hashemi))
#eval IO.println ("prop_braceHeight_hashemi " ++ toString (prop_braceHeight_hashemi))

def prop_brace_cuts_moment  : Bool :=
  ((((1.30 : Float) - (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))) / (1.30 : Float)) < (0.35 : Float))

#eval IO.println ("prop_brace_cuts_moment " ++ toString (prop_brace_cuts_moment))
#eval IO.println ("prop_brace_cuts_moment " ++ toString (prop_brace_cuts_moment))
#eval IO.println ("prop_brace_cuts_moment " ++ toString (prop_brace_cuts_moment))

def prop_brace_stiffens  : Bool :=
  (((((1.30 : Float) - (Float.sqrt (((0.96 : Float) ^ 2) - (((0.62 : Float) - (0.175 : Float)) ^ 2)))) / (1.30 : Float)) ^ 3) < ((1 : Float) / (24 : Float)))

#eval IO.println ("prop_brace_stiffens " ++ toString (prop_brace_stiffens))
#eval IO.println ("prop_brace_stiffens " ++ toString (prop_brace_stiffens))
#eval IO.println ("prop_brace_stiffens " ++ toString (prop_brace_stiffens))

def prop_cable_drop_small (L : Float) (I : Float) : Bool :=
  (!(L <= (4 : Float)) || (!((0 : Float) <= I) || (!(I <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float)) < (0.1 : Float)))))

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.903331 0.844782))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.572139 0.513590))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.240947 1.782398))

def prop_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.717179 0.658630 0.600081))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.385987 0.327438 0.268889))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.654795 1.596246 1.537697))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.531027))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.799835))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.468643))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.344875 0.286326))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.613683 1.555134))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.282491 1.223942))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.758723 1.700174))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.427531 1.368982))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.096339 1.037790))

def prop_constraints_reciprocal_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v13 := ((0 : Float) * (0 : Float))
  let v14 := (b_zBearing * (0 : Float))
  let v16 := (b_zBearing * (1 : Float))
  let v17 := ((0 : Float) * (1 : Float))
  let v19 := (c_chord / (2 : Float))
  let v20 := (b_zRail * (0 : Float))
  let v21 := (c_apexH * (0 : Float))
  let v22 := (-v19)
  let v25 := ((0 : Float) * (v20 - (c_apexH * (1 : Float))))
  ((feq (((((((0 : Float) * (v13 - v14)) + ((0 : Float) * (v16 - v13))) + ((1 : Float) * (v13 - v17))) + v17) + v13) + v13) (0 : Float)) && ((feq (((((((0 : Float) * (v13 - v16)) + ((0 : Float) * (v14 - v13))) + ((1 : Float) * (v17 - v13))) + v13) + v17) + v13) (0 : Float)) && ((feq (((((((0 : Float) * (v17 - v14)) + ((0 : Float) * (v14 - v17))) + ((1 : Float) * (v13 - v13))) + v13) + v13) + v17) (0 : Float)) && ((feq (((((((0 : Float) * ((v19 * (1 : Float)) - v20)) + v25) + ((1 : Float) * (v21 - (v19 * (0 : Float))))) + v13) + v13) + v17) (0 : Float)) && (feq (((((((0 : Float) * ((v22 * (1 : Float)) - v20)) + v25) + ((1 : Float) * (v21 - (v22 * (0 : Float))))) + v13) + v13) + v17) (0 : Float))))))

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.572571 1.514022 1.455473 1.396924 1.338376 1.279827 1.221278 1.162729 1.104180 1.045632 0.987083 0.928534))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.241379 1.182830 1.124281 1.065732 1.007184 0.948635 0.890086 0.831537 0.772988 0.714440 0.655891 0.597342))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.910187 0.851638 0.793089 0.734540 0.675992 0.617443 0.558894 0.500345 0.441796 0.383248 0.324699 0.266150))

def prop_cosTubeCut_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  let v10 := (((3.36 : Float) - v1) / ((2 : Float) * (Float.sqrt ((4.36 : Float) - ((2 : Float) * v1)))))
  (((0.888 : Float) < v10) && (v10 < (0.889 : Float)))

#eval IO.println ("prop_cosTubeCut_bounds " ++ toString (prop_cosTubeCut_bounds))
#eval IO.println ("prop_cosTubeCut_bounds " ++ toString (prop_cosTubeCut_bounds))
#eval IO.println ("prop_cosTubeCut_bounds " ++ toString (prop_cosTubeCut_bounds))

def prop_deadTan_at_ym  : Bool :=
  let v3 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v13 := ((((1.22 : Float) * v3) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v3)))
  (((1.859 : Float) < v13) && (v13 < (1.86 : Float)))

#eval IO.println ("prop_deadTan_at_ym " ++ toString (prop_deadTan_at_ym))
#eval IO.println ("prop_deadTan_at_ym " ++ toString (prop_deadTan_at_ym))
#eval IO.println ("prop_deadTan_at_ym " ++ toString (prop_deadTan_at_ym))

def prop_deadTan_hashemi  : Bool :=
  let v3 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v13 := ((((1.2 : Float) * v3) + ((0.34 : Float) * (0.8 : Float))) / (((1.2 : Float) * (0.8 : Float)) - ((0.34 : Float) * v3)))
  (((1.878 : Float) < v13) && (v13 < (1.88 : Float)))

#eval IO.println ("prop_deadTan_hashemi " ++ toString (prop_deadTan_hashemi))
#eval IO.println ("prop_deadTan_hashemi " ++ toString (prop_deadTan_hashemi))
#eval IO.println ("prop_deadTan_hashemi " ++ toString (prop_deadTan_hashemi))

def prop_dishAxes_rot (az : Float) (t : Float) (delta : Float) : Bool :=
  let v3 := (Float.sin t)
  let v4 := (az + delta)
  let v5 := (Float.cos v4)
  let v6 := (v3 * v5)
  let v7 := (Float.sin v4)
  let v8 := (v3 * v7)
  let v9 := (Float.cos t)
  let v10 := (v9 * v5)
  let v11 := (v9 * v7)
  let v12 := (-v3)
  let v13 := (Float.cos delta)
  let v14 := (Float.cos az)
  let v15 := (v3 * v14)
  let v16 := (Float.sin az)
  let v17 := (v3 * v16)
  let v18 := (v9 * v14)
  let v19 := (v9 * v16)
  let v22 := ((v19 * v9) - (v12 * v17))
  let v25 := ((v12 * v15) - (v18 * v9))
  let v26 := (Float.sin delta)
  (((feq ((v11 * v9) - (v12 * v8)) ((v13 * v22) - (v26 * v25))) && ((feq ((v12 * v6) - (v10 * v9)) ((v26 * v22) + (v13 * v25))) && (feq ((v10 * v8) - (v11 * v6)) ((v18 * v17) - (v19 * v15))))) && (((feq v10 ((v13 * v18) - (v26 * v19))) && ((feq v11 ((v26 * v18) + (v13 * v19))) && (feq v12 v12))) && ((feq v6 ((v13 * v15) - (v26 * v17))) && ((feq v8 ((v26 * v15) + (v13 * v17))) && (feq v9 v9)))))

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.827963 0.769414 0.710865))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.496771 0.438222 0.379673))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.765579 1.707030 1.648481))

def prop_dish_between_posts  : Bool :=
  (((2 : Float) * (0.8 : Float)) < (1.84 : Float))

#eval IO.println ("prop_dish_between_posts " ++ toString (prop_dish_between_posts))
#eval IO.println ("prop_dish_between_posts " ++ toString (prop_dish_between_posts))
#eval IO.println ("prop_dish_between_posts " ++ toString (prop_dish_between_posts))

def prop_dish_swings_to_vertical  : Bool :=
  ((0.8 : Float) < ((1.30 : Float) - (0.05 : Float)))

#eval IO.println ("prop_dish_swings_to_vertical " ++ toString (prop_dish_swings_to_vertical))
#eval IO.println ("prop_dish_swings_to_vertical " ++ toString (prop_dish_swings_to_vertical))
#eval IO.println ("prop_dish_swings_to_vertical " ++ toString (prop_dish_swings_to_vertical))

def prop_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (F * v18))

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.269507 0.210958 1.752409 1.693860 1.635312 1.576763 1.518214 1.459665 1.401116 1.342568 1.284019 1.225470 1.166921))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.538315 1.479766 1.421217 1.362668 1.304120 1.245571 1.187022 1.128473 1.069924 1.011376 0.952827 0.894278 0.835729))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.207123 1.148574 1.090025 1.031476 0.972928 0.914379 0.855830 0.797281 0.738732 0.680184 0.621635 0.563086 0.504537))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.683355 1.624806 1.566257 1.507708 1.449160 1.390611 1.332062 1.273513 1.214964 1.156416 1.097867 1.039318 0.980769))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.352163 1.293614 1.235065 1.176516 1.117968 1.059419 1.000870 0.942321 0.883772 0.825224 0.766675 0.708126 0.649577))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.020971 0.962422 0.903873 0.845324 0.786776 0.728227 0.669678 0.611129 0.552580 0.494032 0.435483 0.376934 0.318385))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.497203 1.438654 1.380105 1.321556 1.263008))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.166011 1.107462 1.048913 0.990364 0.931816))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.834819 0.776270 0.717721 0.659172 0.600624))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.311051 1.252502 1.193953))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.979859 0.921310 0.862761))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.648667 0.590118 0.531569))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.124899))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.793707))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.462515))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.938747 0.880198 0.821649))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.607555 0.549006 0.490457))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.276363 0.217814 1.759265))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.752595 0.694046 0.635497))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.421403 0.362854 0.304305))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.690211 1.631662 1.573113))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.566443 0.507894 0.449345 0.390796))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.235251 1.776702 1.718153 1.659604))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.504059 1.445510 1.386961 1.328412))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.380291 0.321742 0.263193))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.649099 1.590550 1.532001))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.317907 1.259358 1.200809))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.794139 1.735590 1.677041 1.618492 1.559944))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.462947 1.404398 1.345849 1.287300 1.228752))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.131755 1.073206 1.014657 0.956108 0.897560))

def prop_edgeLever_pos_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  let v11 := ((v5 * v6) + (v7 * v8))
  let v15 := (((-v5) * v8) + (v7 * v6))
  let v16 := (-ym)
  let v21 := (((v11 - v16) ^ 2) + ((v15 - hp) ^ 2))
  (!((0 : Float) < v21) || (((0 : Float) < (((v16 * v15) - (hp * v11)) / (Float.sqrt v21))) == ((v8 * ((ym * a) - (hp * ze))) < (v6 * ((ym * ze) + (hp * a))))))

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.607987 1.549438 1.490889 1.432340 1.373792))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.276795 1.218246 1.159697 1.101148 1.042600))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.945603 0.887054 0.828505 0.769956 0.711408))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.421835 1.363286 1.304737 1.246188 1.187640))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.090643 1.032094 0.973545 0.914996 0.856448))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.759451 0.700902 0.642353 0.583804 0.525256))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.235683 1.177134 1.118585 1.060036))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.904491 0.845942 0.787393 0.728844))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.573299 0.514750 0.456201 0.397652))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.863379 0.804830 0.746281))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.532187 0.473638 0.415089))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.200995 1.742446 1.683897))

def prop_grooved_reciprocal_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v13 := ((0 : Float) * (0 : Float))
  let v14 := (b_zBearing * (0 : Float))
  let v16 := (b_zBearing * (1 : Float))
  let v17 := ((0 : Float) * (1 : Float))
  let v19 := (c_chord / (2 : Float))
  let v20 := (b_zRail * (0 : Float))
  let v21 := (c_apexH * (0 : Float))
  let v22 := (v19 * (0 : Float))
  let v23 := (-v19)
  let v24 := (v23 * (0 : Float))
  let v27 := ((0 : Float) * (v20 - (c_apexH * (1 : Float))))
  let v30 := ((0 : Float) * ((b_zRail * c_apexH) - v21))
  let v31 := ((0 : Float) * c_apexH)
  ((feq (((((((0 : Float) * (v13 - v14)) + ((0 : Float) * (v16 - v13))) + ((1 : Float) * (v13 - v17))) + v17) + v13) + v13) (0 : Float)) && ((feq (((((((0 : Float) * (v13 - v16)) + ((0 : Float) * (v14 - v13))) + ((1 : Float) * (v17 - v13))) + v13) + v17) + v13) (0 : Float)) && ((feq (((((((0 : Float) * (v17 - v14)) + ((0 : Float) * (v14 - v17))) + ((1 : Float) * (v13 - v13))) + v13) + v13) + v17) (0 : Float)) && ((feq (((((((0 : Float) * ((v19 * (1 : Float)) - v20)) + v27) + ((1 : Float) * (v21 - v22))) + v13) + v13) + v17) (0 : Float)) && ((feq (((((((0 : Float) * ((v23 * (1 : Float)) - v20)) + v27) + ((1 : Float) * (v21 - v24))) + v13) + v13) + v17) (0 : Float)) && ((feq (((((((0 : Float) * (v22 - (b_zRail * v19))) + v30) + ((1 : Float) * ((c_apexH * v19) - (v19 * c_apexH)))) + v31) + ((0 : Float) * v19)) + v13) (0 : Float)) && (feq (((((((0 : Float) * (v24 - (b_zRail * v23))) + v30) + ((1 : Float) * ((c_apexH * v23) - (v23 * c_apexH)))) + v31) + ((0 : Float) * v23)) + v13) (0 : Float))))))))

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.677227 0.618678 0.560129 0.501580 0.443032 0.384483 0.325934 0.267385 0.208836 1.750288 1.691739 1.633190))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.346035 0.287486 0.228937 1.770388 1.711840 1.653291 1.594742 1.536193 1.477644 1.419096 1.360547 1.301998))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.614843 1.556294 1.497745 1.439196 1.380648 1.322099 1.263550 1.205001 1.146452 1.087904 1.029355 0.970806))

def prop_grooved_relation_x (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v15 := (v13 * (0 : Float))
  let v16 := (c_apexH * (0 : Float))
  let v18 := ((b_zRail * c_apexH) - v16)
  let v19 := (-v13)
  let v20 := (v19 * (0 : Float))
  let v21 := ((0 : Float) + (0 : Float))
  let v22 := ((2 : Float) * c_apexH)
  let v23 := ((0 : Float) * (0 : Float))
  let v24 := (b_zBearing * (0 : Float))
  let v26 := ((0 : Float) * (1 : Float))
  let v27 := (v22 * (0 : Float))
  let v28 := (b_zRail - b_zBearing)
  let v29 := (b_zRail * (0 : Float))
  let v31 := (v29 - (c_apexH * (1 : Float)))
  let v34 := (v28 * (v21 - ((2 : Float) * (0 : Float))))
  ((feq (((c_apexH + c_apexH) - (v22 * (1 : Float))) + v34) (0 : Float)) && ((feq (((v13 + v19) - v27) + v34) (0 : Float)) && ((feq ((v21 - v27) + (v28 * (((1 : Float) + (1 : Float)) - ((2 : Float) * (1 : Float))))) (0 : Float)) && ((feq ((((v15 - (b_zRail * v13)) + (v20 - (b_zRail * v19))) - (v22 * (v23 - v24))) + (v28 * ((((v13 * (1 : Float)) - v29) + ((v19 * (1 : Float)) - v29)) - ((2 : Float) * (v26 - v24))))) (0 : Float)) && ((feq (((v18 + v18) - (v22 * ((b_zBearing * (1 : Float)) - v23))) + (v28 * ((v31 + v31) - ((2 : Float) * (v24 - v26))))) (0 : Float)) && (feq (((((c_apexH * v13) - (v13 * c_apexH)) + ((c_apexH * v19) - (v19 * c_apexH))) - (v22 * (v23 - v26))) + (v28 * (((v16 - v15) + (v16 - v20)) - ((2 : Float) * (v23 - v23))))) (0 : Float)))))))

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.491075 0.432526 0.373977 0.315428 0.256880 1.798331 1.739782 1.681233 1.622684 1.564136 1.505587 1.447038))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.759883 1.701334 1.642785 1.584236 1.525688 1.467139 1.408590 1.350041 1.291492 1.232944 1.174395 1.115846))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.428691 1.370142 1.311593 1.253044 1.194496 1.135947 1.077398 1.018849 0.960300 0.901752 0.843203 0.784654))

def prop_grooved_relation_y (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v15 := (v13 * (0 : Float))
  let v16 := (c_apexH * (0 : Float))
  let v18 := ((b_zRail * c_apexH) - v16)
  let v19 := (-v13)
  let v20 := (v19 * (0 : Float))
  let v21 := ((0 : Float) - (0 : Float))
  let v22 := ((0 : Float) * (0 : Float))
  let v23 := (c_chord * (0 : Float))
  let v24 := (b_zBearing - b_zRail)
  let v25 := (b_zRail * (0 : Float))
  let v28 := (v25 - (c_apexH * (1 : Float)))
  let v29 := (v24 * v21)
  ((feq (((c_apexH - c_apexH) - v23) - v29) (0 : Float)) && ((feq (((v13 - v19) - (c_chord * (1 : Float))) - v29) (0 : Float)) && ((feq ((v21 - v23) - (v24 * ((1 : Float) - (1 : Float)))) (0 : Float)) && ((feq ((((v15 - (b_zRail * v13)) - (v20 - (b_zRail * v19))) - (c_chord * (v22 - (b_zBearing * (1 : Float))))) - (v24 * (((v13 * (1 : Float)) - v25) - ((v19 * (1 : Float)) - v25)))) (0 : Float)) && ((feq (((v18 - v18) - (c_chord * ((b_zBearing * (0 : Float)) - v22))) - (v24 * (v28 - v28))) (0 : Float)) && (feq (((((c_apexH * v13) - (v13 * c_apexH)) - ((c_apexH * v19) - (v19 * c_apexH))) - (c_chord * (((0 : Float) * (1 : Float)) - v22))) - (v24 * ((v16 - v15) - (v16 - v20)))) (0 : Float)))))))

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.304923 0.246374 1.787825 1.729276 1.670728 1.612179 1.553630 1.495081 1.436532 1.377984 1.319435 1.260886))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.573731 1.515182 1.456633 1.398084 1.339536 1.280987 1.222438 1.163889 1.105340 1.046792 0.988243 0.929694))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.242539 1.183990 1.125441 1.066892 1.008344 0.949795 0.891246 0.832697 0.774148 0.715600 0.657051 0.598502))

def prop_hangerLength_bounds  : Bool :=
  let v6 := (Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float)))))
  (((0.884 : Float) < v6) && (v6 < (0.8846 : Float)))

#eval IO.println ("prop_hangerLength_bounds " ++ toString (prop_hangerLength_bounds))
#eval IO.println ("prop_hangerLength_bounds " ++ toString (prop_hangerLength_bounds))
#eval IO.println ("prop_hangerLength_bounds " ++ toString (prop_hangerLength_bounds))

def prop_hangerLength_halfEdge  : Bool :=
  let v1 := ((0.4 : Float) ^ 2)
  (feq (Float.sqrt ((((0 : Float) ^ 2) + v1) + ((((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((Float.sqrt (((0.8 : Float) ^ 2) + v1)) ^ 2))))) ^ 2))) (Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float))))))

#eval IO.println ("prop_hangerLength_halfEdge " ++ toString (prop_hangerLength_halfEdge))
#eval IO.println ("prop_hangerLength_halfEdge " ++ toString (prop_hangerLength_halfEdge))
#eval IO.println ("prop_hangerLength_halfEdge " ++ toString (prop_hangerLength_halfEdge))

def prop_hashemiHanger_length  : Bool :=
  let v1 := ((0.4 : Float) ^ 2)
  (feq (Float.sqrt ((4.36 : Float) - ((2 : Float) * (Float.sqrt (3.2 : Float))))) (Float.sqrt ((((0 : Float) ^ 2) + v1) + ((((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((Float.sqrt (((0.8 : Float) ^ 2) + v1)) ^ 2))))) ^ 2))))

#eval IO.println ("prop_hashemiHanger_length " ++ toString (prop_hashemiHanger_length))
#eval IO.println ("prop_hashemiHanger_length " ++ toString (prop_hashemiHanger_length))
#eval IO.println ("prop_hashemiHanger_length " ++ toString (prop_hashemiHanger_length))

def prop_hashemi_clearance  : Bool :=
  let v8 := ((1.30 : Float) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  (((0.1449 : Float) < v8) && (v8 < (0.146 : Float)))

#eval IO.println ("prop_hashemi_clearance " ++ toString (prop_hashemi_clearance))
#eval IO.println ("prop_hashemi_clearance " ++ toString (prop_hashemi_clearance))
#eval IO.println ("prop_hashemi_clearance " ++ toString (prop_hashemi_clearance))

def prop_hashemi_eyes_clear  : Bool :=
  (((0.010 : Float) / (2 : Float)) < (0.010 : Float))

#eval IO.println ("prop_hashemi_eyes_clear " ++ toString (prop_hashemi_eyes_clear))
#eval IO.println ("prop_hashemi_eyes_clear " ++ toString (prop_hashemi_eyes_clear))
#eval IO.println ("prop_hashemi_eyes_clear " ++ toString (prop_hashemi_eyes_clear))

def prop_hashemi_fits  : Bool :=
  let v7 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  (feq v7 v7)

#eval IO.println ("prop_hashemi_fits " ++ toString (prop_hashemi_fits))
#eval IO.println ("prop_hashemi_fits " ++ toString (prop_hashemi_fits))
#eval IO.println ("prop_hashemi_fits " ++ toString (prop_hashemi_fits))

def prop_helixAdvance_small  : Bool :=
  ((((0.00175 : Float) * (((62 : Float) * (3.141592653589793 : Float)) / (180 : Float))) / ((2 : Float) * (3.141592653589793 : Float))) < (0.00031 : Float))

#eval IO.println ("prop_helixAdvance_small " ++ toString (prop_helixAdvance_small))
#eval IO.println ("prop_helixAdvance_small " ++ toString (prop_helixAdvance_small))
#eval IO.println ("prop_helixAdvance_small " ++ toString (prop_helixAdvance_small))

def prop_hinge_freedom (xh : Float) (zBolt : Float) (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) : Bool :=
  let v9 := ((0 : Float) * (0 : Float))
  let v10 := (zBolt * (0 : Float))
  let v12 := (zBolt * (1 : Float))
  let v13 := (xh * (0 : Float))
  let v14 := ((0 : Float) * (1 : Float))
  let v15 := (xh * (1 : Float))
  let v16 := (t_4 * (0 : Float))
  let v17 := (t_5 * (0 : Float))
  let v18 := (t_3 * (0 : Float))
  let v19 := (t_0 * (0 : Float))
  (!((feq ((((((t_0 * (v9 - v10)) + (t_1 * (v12 - v13))) + (t_2 * (v13 - v14))) + (t_3 * (1 : Float))) + v16) + v17) (0 : Float)) && ((feq ((((((t_0 * (v9 - v12)) + (t_1 * (v10 - v13))) + (t_2 * (v15 - v9))) + v18) + (t_4 * (1 : Float))) + v17) (0 : Float)) && ((feq ((((((t_0 * (v14 - v10)) + (t_1 * (v10 - v15))) + (t_2 * (v13 - v9))) + v18) + v16) + (t_5 * (1 : Float))) (0 : Float)) && ((feq (((((v19 + (t_1 * (1 : Float))) + (t_2 * (0 : Float))) + v18) + v16) + v17) (0 : Float)) && (feq (((((v19 + (t_1 * (0 : Float))) + (t_2 * (1 : Float))) + v18) + v16) + v17) (0 : Float)))))) || ((feq t_1 (0 : Float)) && ((feq t_2 (0 : Float)) && ((feq t_3 (0 : Float)) && ((feq t_4 (t_0 * zBolt)) && (feq t_5 (0 : Float)))))))

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.415707 0.357158 0.298609 0.240060 1.781512 1.722963 1.664414 1.605865))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.684515 1.625966 1.567417 1.508868 1.450320 1.391771 1.333222 1.274673))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.353323 1.294774 1.236225 1.177676 1.119128 1.060579 1.002030 0.943481))

def prop_hinge_freedom_smul (xh : Float) (zBolt : Float) (apexH : Float) (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) : Bool :=
  let v10 := ((0 : Float) * (0 : Float))
  let v11 := (zBolt * (0 : Float))
  let v13 := (zBolt * (1 : Float))
  let v14 := (xh * (0 : Float))
  let v15 := ((0 : Float) * (1 : Float))
  let v16 := (xh * (1 : Float))
  let v18 := (t_0 * (v10 - v11))
  let v19 := (t_4 * (0 : Float))
  let v20 := (t_5 * (0 : Float))
  let v21 := (t_3 * (0 : Float))
  let v22 := (t_0 * (0 : Float))
  let v23 := (apexH * (0 : Float))
  (!((feq (((((v18 + (t_1 * (v13 - v14))) + (t_2 * (v14 - v15))) + (t_3 * (1 : Float))) + v19) + v20) (0 : Float)) && ((feq ((((((t_0 * (v10 - v13)) + (t_1 * (v11 - v14))) + (t_2 * (v16 - v10))) + v21) + (t_4 * (1 : Float))) + v20) (0 : Float)) && ((feq ((((((t_0 * (v15 - v11)) + (t_1 * (v11 - v16))) + (t_2 * (v14 - v10))) + v21) + v19) + (t_5 * (1 : Float))) (0 : Float)) && ((feq (((((v22 + (t_1 * (1 : Float))) + (t_2 * (0 : Float))) + v21) + v19) + v20) (0 : Float)) && (feq (((((v22 + (t_1 * (0 : Float))) + (t_2 * (1 : Float))) + v21) + v19) + v20) (0 : Float)))))) || ((feq t_0 (t_0 * (1 : Float))) && ((feq t_1 v22) && ((feq t_2 v22) && ((feq t_3 v18) && ((feq t_4 (t_0 * (v13 - v23))) && (feq t_5 (t_0 * (v23 - v15)))))))))

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.229555 1.771006 1.712457 1.653908 1.595360 1.536811 1.478262 1.419713 1.361164))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.498363 1.439814 1.381265 1.322716 1.264168 1.205619 1.147070 1.088521 1.029972))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.167171 1.108622 1.050073 0.991524 0.932976 0.874427 0.815878 0.757329 0.698780))

def prop_hinge_reciprocal_swing (xh : Float) (zBolt : Float) (apexH : Float) : Bool :=
  let v4 := ((0 : Float) * (0 : Float))
  let v5 := (zBolt * (0 : Float))
  let v6 := (v4 - v5)
  let v8 := (zBolt * (1 : Float))
  let v9 := (apexH * (0 : Float))
  let v10 := (v8 - v9)
  let v11 := ((0 : Float) * (1 : Float))
  let v12 := (v9 - v11)
  let v13 := (xh * (0 : Float))
  let v14 := (xh * (1 : Float))
  let v15 := (v10 * (0 : Float))
  let v16 := (v12 * (0 : Float))
  let v17 := (v6 * (0 : Float))
  let v18 := ((1 : Float) * (0 : Float))
  ((feq (((((((1 : Float) * v6) + ((0 : Float) * (v8 - v13))) + ((0 : Float) * (v13 - v11))) + (v6 * (1 : Float))) + v15) + v16) (0 : Float)) && ((feq (((((((1 : Float) * (v4 - v8)) + ((0 : Float) * (v5 - v13))) + ((0 : Float) * (v14 - v4))) + v17) + (v10 * (1 : Float))) + v16) (0 : Float)) && ((feq (((((((1 : Float) * (v11 - v5)) + ((0 : Float) * (v5 - v14))) + ((0 : Float) * (v13 - v4))) + v17) + v15) + (v12 * (1 : Float))) (0 : Float)) && ((feq (((((v18 + v11) + v4) + v17) + v15) + v16) (0 : Float)) && (feq (((((v18 + v4) + v11) + v17) + v15) + v16) (0 : Float))))))

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.643403 1.584854 1.526305))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.312211 1.253662 1.195113))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.981019 0.922470 0.863921))

def prop_lean_one_degree  : Bool :=
  ((0.02 : Float) < ((1.25 : Float) * (Float.sin ((3.141592653589793 : Float) / (180 : Float)))))

#eval IO.println ("prop_lean_one_degree " ++ toString (prop_lean_one_degree))
#eval IO.println ("prop_lean_one_degree " ++ toString (prop_lean_one_degree))
#eval IO.println ("prop_lean_one_degree " ++ toString (prop_lean_one_degree))

def prop_lowestSun_tan_at_ym  : Bool :=
  let v3 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v14 := ((1 : Float) / ((((1.22 : Float) * v3) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v3))))
  (((0.537 : Float) < v14) && (v14 < (0.538 : Float)))

#eval IO.println ("prop_lowestSun_tan_at_ym " ++ toString (prop_lowestSun_tan_at_ym))
#eval IO.println ("prop_lowestSun_tan_at_ym " ++ toString (prop_lowestSun_tan_at_ym))
#eval IO.println ("prop_lowestSun_tan_at_ym " ++ toString (prop_lowestSun_tan_at_ym))

def prop_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.084947))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.753755))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.422563))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.712643))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.381451))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.650259))

def prop_mast_beyond_ring  : Bool :=
  ((Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))) < ((0.80 : Float) + (1.22 : Float)))

#eval IO.println ("prop_mast_beyond_ring " ++ toString (prop_mast_beyond_ring))
#eval IO.println ("prop_mast_beyond_ring " ++ toString (prop_mast_beyond_ring))
#eval IO.println ("prop_mast_beyond_ring " ++ toString (prop_mast_beyond_ring))

def prop_mast_for_vertical_hashemi  : Bool :=
  ((1.17 : Float) < (((1.22 : Float) * (0.8 : Float)) / ((Float.sqrt (3.36 : Float)) - (1 : Float))))

#eval IO.println ("prop_mast_for_vertical_hashemi " ++ toString (prop_mast_for_vertical_hashemi))
#eval IO.println ("prop_mast_for_vertical_hashemi " ++ toString (prop_mast_for_vertical_hashemi))
#eval IO.println ("prop_mast_for_vertical_hashemi " ++ toString (prop_mast_for_vertical_hashemi))

def prop_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v6) && (v6 < (bhi * rlo)))))))))

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.754187 1.695638 1.637089 1.578540 1.519992 1.461443))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.422995 1.364446 1.305897 1.247348 1.188800 1.130251))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.091803 1.033254 0.974705 0.916156 0.857608 0.799059))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.568035 1.509486 1.450937 1.392388 1.333840 1.275291))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.236843 1.178294 1.119745 1.061196 1.002648 0.944099))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.905651 0.847102 0.788553 0.730004 0.671456 0.612907))

def prop_one_turn_tilt  : Bool :=
  let v4 := ((0.0015 : Float) / ((2 : Float) * (0.8 : Float)))
  ((v4 < (0.001 : Float)) && ((((4 : Float) * v4) < (0.00465 : Float)) && (((1 : Float) * v4) < (0.001 : Float))))

#eval IO.println ("prop_one_turn_tilt " ++ toString (prop_one_turn_tilt))
#eval IO.println ("prop_one_turn_tilt " ++ toString (prop_one_turn_tilt))
#eval IO.println ("prop_one_turn_tilt " ++ toString (prop_one_turn_tilt))

def prop_panel_current  : Bool :=
  (((5 : Float) / (12 : Float)) < (0.5 : Float))

#eval IO.println ("prop_panel_current " ++ toString (prop_panel_current))
#eval IO.println ("prop_panel_current " ++ toString (prop_panel_current))
#eval IO.println ("prop_panel_current " ++ toString (prop_panel_current))

def prop_play_budget (f : Float) (eps : Float) (h : Float) (delta : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.009579 0.951030 0.892481 0.833932))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.678387 0.619838 0.561289 0.502740))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.347195 0.288646 0.230097 1.771548))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.823427))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.492235))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.761043))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.637275 0.578726 0.520177 0.461628 0.403080 0.344531 0.285982 0.227433 1.768884 1.710336 1.651787 1.593238))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.306083 0.247534 1.788985 1.730436 1.671888 1.613339 1.554790 1.496241 1.437692 1.379144 1.320595 1.262046))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.574891 1.516342 1.457793 1.399244 1.340696 1.282147 1.223598 1.165049 1.106500 1.047952 0.989403 0.930854))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.451123 0.392574 0.334025 0.275476 0.216928 1.758379 1.699830 1.641281 1.582732 1.524184 1.465635 1.407086))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.719931 1.661382 1.602833 1.544284 1.485736 1.427187 1.368638 1.310089 1.251540 1.192992 1.134443 1.075894))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.388739 1.330190 1.271641 1.213092 1.154544 1.095995 1.037446 0.978897 0.920348 0.861800 0.803251 0.744702))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.264971 0.206422 1.747873 1.689324 1.630776 1.572227 1.513678 1.455129 1.396580 1.338032 1.279483 1.220934))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.533779 1.475230 1.416681 1.358132 1.299584 1.241035 1.182486 1.123937 1.065388 1.006840 0.948291 0.889742))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.202587 1.144038 1.085489 1.026940 0.968392 0.909843 0.851294 0.792745 0.734196 0.675648 0.617099 0.558550))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.678819 1.620270 1.561721 1.503172 1.444624 1.386075 1.327526 1.268977 1.210428 1.151880 1.093331 1.034782 0.976233))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.347627 1.289078 1.230529 1.171980 1.113432 1.054883 0.996334 0.937785 0.879236 0.820688 0.762139 0.703590 0.645041))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.016435 0.957886 0.899337 0.840788 0.782240 0.723691 0.665142 0.606593 0.548044 0.489496 0.430947 0.372398 0.313849))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.306515 1.247966 1.189417 1.130868))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.975323 0.916774 0.858225 0.799676))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.644131 0.585582 0.527033 0.468484))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.934211 0.875662 0.817113))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.603019 0.544470 0.485921))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.271827 0.213278 1.754729))

def prop_rodTan_bounds  : Bool :=
  let v5 := ((0.4 : Float) / ((Float.sqrt (3.2 : Float)) - (1 : Float)))
  (((0.507 : Float) < v5) && (v5 < (0.5072 : Float)))

#eval IO.println ("prop_rodTan_bounds " ++ toString (prop_rodTan_bounds))
#eval IO.println ("prop_rodTan_bounds " ++ toString (prop_rodTan_bounds))
#eval IO.println ("prop_rodTan_bounds " ++ toString (prop_rodTan_bounds))

def prop_rollerRadius_hashemi  : Bool :=
  (feq (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))) (Float.sqrt (1.4864 : Float)))

#eval IO.println ("prop_rollerRadius_hashemi " ++ toString (prop_rollerRadius_hashemi))
#eval IO.println ("prop_rollerRadius_hashemi " ++ toString (prop_rollerRadius_hashemi))
#eval IO.println ("prop_rollerRadius_hashemi " ++ toString (prop_rollerRadius_hashemi))

def prop_rollerRadius_hashemi_bounds  : Bool :=
  let v7 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  (((1.219 : Float) < v7) && (v7 < (1.2195 : Float)))

#eval IO.println ("prop_rollerRadius_hashemi_bounds " ++ toString (prop_rollerRadius_hashemi_bounds))
#eval IO.println ("prop_rollerRadius_hashemi_bounds " ++ toString (prop_rollerRadius_hashemi_bounds))
#eval IO.println ("prop_rollerRadius_hashemi_bounds " ++ toString (prop_rollerRadius_hashemi_bounds))

def prop_rollerRadius_pos (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  ((0 : Float) < (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))))

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.789603 1.731054 1.672505 1.613956 1.555408 1.496859))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.458411 1.399862 1.341313 1.282764 1.224216 1.165667))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.127219 1.068670 1.010121 0.951572 0.893024 0.834475))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.603451 1.544902 1.486353 1.427804 1.369256 1.310707))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.272259 1.213710 1.155161 1.096612 1.038064 0.979515))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.941067 0.882518 0.823969 0.765420 0.706872 0.648323))

def prop_roller_rpm_hashemi  : Bool :=
  let v6 := ((((2 : Float) / (360 : Float)) * (1.2192 : Float)) / (0.05 : Float))
  (((0.13 : Float) < v6) && (v6 < (0.14 : Float)))

#eval IO.println ("prop_roller_rpm_hashemi " ++ toString (prop_roller_rpm_hashemi))
#eval IO.println ("prop_roller_rpm_hashemi " ++ toString (prop_roller_rpm_hashemi))
#eval IO.println ("prop_roller_rpm_hashemi " ++ toString (prop_roller_rpm_hashemi))

def prop_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v8 := (Float.sin delta)
  let v9 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v8 * u_1)) * ((v7 * v_0) - (v8 * v_1))) + (((v8 * u_0) + (v7 * u_1)) * ((v8 * v_0) + (v7 * v_1)))) + v9) (((u_0 * v_0) + (u_1 * v_1)) + v9))

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.231147 1.172598 1.114049 1.055500 0.996952 0.938403 0.879854))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.899955 0.841406 0.782857 0.724308 0.665760 0.607211 0.548662))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.568763 0.510214 0.451665 0.393116 0.334568 0.276019 0.217470))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.044995 0.986446))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.713803 0.655254))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.382611 0.324062))

def prop_screwLength_hashemi  : Bool :=
  (feq (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((1 : Float) ^ 2))))) ((Float.sqrt (3 : Float)) - (1 : Float)))

#eval IO.println ("prop_screwLength_hashemi " ++ toString (prop_screwLength_hashemi))
#eval IO.println ("prop_screwLength_hashemi " ++ toString (prop_screwLength_hashemi))
#eval IO.println ("prop_screwLength_hashemi " ++ toString (prop_screwLength_hashemi))

def prop_screwLength_hashemi_bounds  : Bool :=
  let v8 := (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((1 : Float) ^ 2)))))
  (((0.732 : Float) < v8) && (v8 < (0.7321 : Float)))

#eval IO.println ("prop_screwLength_hashemi_bounds " ++ toString (prop_screwLength_hashemi_bounds))
#eval IO.println ("prop_screwLength_hashemi_bounds " ++ toString (prop_screwLength_hashemi_bounds))
#eval IO.println ("prop_screwLength_hashemi_bounds " ++ toString (prop_screwLength_hashemi_bounds))

def prop_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v3 := (apexH * (0 : Float))
  let v4 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v4 && (v4 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v3)) && (feq (0 : Float) (v3 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.486539 0.427990))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.755347 1.696798))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.424155 1.365606))

def prop_screw_freedom (xh : Float) (zBolt : Float) (h : Float) (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) : Bool :=
  let v10 := ((0 : Float) * (0 : Float))
  let v11 := (zBolt * (0 : Float))
  let v12 := (xh * (0 : Float))
  let v14 := (xh * (1 : Float))
  let v15 := (t_3 * (0 : Float))
  let v16 := (t_5 * (0 : Float))
  let v17 := (t_4 * (0 : Float))
  let v18 := (t_0 * (0 : Float))
  let v19 := (t_2 * (0 : Float))
  (!((feq ((((((t_0 * (v10 - (zBolt * (1 : Float)))) + (t_1 * (v11 - v12))) + (t_2 * (v14 - v10))) + v15) + (t_4 * (1 : Float))) + v16) (0 : Float)) && ((feq ((((((t_0 * (((0 : Float) * (1 : Float)) - v11)) + (t_1 * (v11 - v14))) + (t_2 * (v12 - v10))) + v15) + v17) + (t_5 * (1 : Float))) (0 : Float)) && ((feq (((((v18 + (t_1 * (1 : Float))) + v19) + v15) + v17) + v16) (0 : Float)) && ((feq (((((v18 + (t_1 * (0 : Float))) + (t_2 * (1 : Float))) + v15) + v17) + v16) (0 : Float)) && (feq ((((((t_0 * (-h)) + (t_1 * zBolt)) + v19) + (t_3 * (1 : Float))) + v17) + v16) (0 : Float)))))) || ((feq t_1 (0 : Float)) && ((feq t_2 (0 : Float)) && ((feq t_3 (t_0 * h)) && ((feq t_4 (t_0 * zBolt)) && (feq t_5 (0 : Float)))))))

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.300387 0.241838 1.783289 1.724740 1.666192 1.607643 1.549094 1.490545 1.431996))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.569195 1.510646 1.452097 1.393548 1.335000 1.276451 1.217902 1.159353 1.100804))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.238003 1.179454 1.120905 1.062356 1.003808 0.945259 0.886710 0.828161 0.769612))

def prop_screw_reciprocal (xh : Float) (zBolt : Float) (h : Float) : Bool :=
  let v4 := ((0 : Float) * (0 : Float))
  let v6 := (zBolt * (1 : Float))
  let v7 := (zBolt * (0 : Float))
  let v8 := (xh * (0 : Float))
  let v9 := (xh * (1 : Float))
  let v10 := ((0 : Float) * (1 : Float))
  let v11 := (h * (0 : Float))
  let v12 := ((1 : Float) * (0 : Float))
  ((feq (((((((1 : Float) * (v4 - v6)) + ((0 : Float) * (v7 - v8))) + ((0 : Float) * (v9 - v4))) + v11) + v6) + v4) (0 : Float)) && ((feq (((((((1 : Float) * (v10 - v7)) + ((0 : Float) * (v7 - v9))) + ((0 : Float) * (v8 - v4))) + v11) + v7) + v10) (0 : Float)) && ((feq (((((v12 + v10) + v4) + v11) + v7) + v4) (0 : Float)) && ((feq (((((v12 + v4) + v10) + v11) + v7) + v4) (0 : Float)) && (feq (((((((1 : Float) * (-h)) + ((0 : Float) * zBolt)) + v4) + (h * (1 : Float))) + v7) + v4) (0 : Float))))))

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.714235 1.655686 1.597137))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.383043 1.324494 1.265945))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.051851 0.993302 0.934753))

def prop_shim_negligible  : Bool :=
  ((0.0005 : Float) < ((0.01 : Float) * (0.06 : Float)))

#eval IO.println ("prop_shim_negligible " ++ toString (prop_shim_negligible))
#eval IO.println ("prop_shim_negligible " ++ toString (prop_shim_negligible))
#eval IO.println ("prop_shim_negligible " ++ toString (prop_shim_negligible))

def prop_sideGap_eq  : Bool :=
  (feq (((1.84 : Float) - ((2 : Float) * (0.8 : Float))) / (2 : Float)) (0.12 : Float))

#eval IO.println ("prop_sideGap_eq " ++ toString (prop_sideGap_eq))
#eval IO.println ("prop_sideGap_eq " ++ toString (prop_sideGap_eq))
#eval IO.println ("prop_sideGap_eq " ++ toString (prop_sideGap_eq))

def prop_sixty_reachable  : Bool :=
  let v2 := ((3.141592653589793 : Float) / (3 : Float))
  let v6 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  (((Float.sin v2) * (((1.2 : Float) * (0.8 : Float)) - ((0.34 : Float) * v6))) < ((Float.cos v2) * (((1.2 : Float) * v6) + ((0.34 : Float) * (0.8 : Float)))))

#eval IO.println ("prop_sixty_reachable " ++ toString (prop_sixty_reachable))
#eval IO.println ("prop_sixty_reachable " ++ toString (prop_sixty_reachable))
#eval IO.println ("prop_sixty_reachable " ++ toString (prop_sixty_reachable))

def prop_slackHarmless_of_budget (f : Float) (eps : Float) (delta : Float) (h : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.969627 0.911078 0.852529 0.793980))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.638435 0.579886 0.521337 0.462788))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.307243 0.248694 1.790145 1.731596))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.783475 0.724926 0.666377 0.607828 0.549280))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.452283 0.393734 0.335185 0.276636 0.218088))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.721091 1.662542 1.603993 1.545444 1.486896))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.411171 0.352622 0.294073))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.679979 1.621430 1.562881))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.348787 1.290238 1.231689))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.638867 1.580318 1.521769 1.463220 1.404672 1.346123 1.287574 1.229025 1.170476 1.111928))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.307675 1.249126 1.190577 1.132028 1.073480 1.014931 0.956382 0.897833 0.839284 0.780736))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.976483 0.917934 0.859385 0.800836 0.742288 0.683739 0.625190 0.566641 0.508092 0.449544))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.452715 1.394166 1.335617))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.121523 1.062974 1.004425))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.790331 0.731782 0.673233))

def prop_sunInDish_equivariant (az : Float) (t : Float) (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (az + delta)
  let v7 := (Float.cos v6)
  let v8 := (v5 * v7)
  let v9 := (Float.sin v6)
  let v10 := (v5 * v9)
  let v11 := (Float.cos t)
  let v12 := (v11 * v7)
  let v13 := (v11 * v9)
  let v14 := (-v5)
  let v15 := (Float.cos elSun)
  let v16 := (azSun + delta)
  let v18 := (v15 * (Float.cos v16))
  let v20 := (v15 * (Float.sin v16))
  let v21 := (Float.sin elSun)
  let v22 := (v14 * v21)
  let v23 := (v11 * v21)
  let v24 := (Float.cos az)
  let v25 := (v5 * v24)
  let v26 := (Float.sin az)
  let v27 := (v5 * v26)
  let v28 := (v11 * v24)
  let v29 := (v11 * v26)
  let v31 := (v15 * (Float.cos azSun))
  let v33 := (v15 * (Float.sin azSun))
  ((feq (((((v13 * v11) - (v14 * v10)) * v18) + (((v14 * v8) - (v12 * v11)) * v20)) + (((v12 * v10) - (v13 * v8)) * v21)) (((((v29 * v11) - (v14 * v27)) * v31) + (((v14 * v25) - (v28 * v11)) * v33)) + (((v28 * v27) - (v29 * v25)) * v21))) && ((feq (((v12 * v18) + (v13 * v20)) + v22) (((v28 * v31) + (v29 * v33)) + v22)) && (feq (((v8 * v18) + (v10 * v20)) + v23) (((v25 * v31) + (v27 * v33)) + v23))))

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.266563 1.208014 1.149465 1.090916 1.032368))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.935371 0.876822 0.818273 0.759724 0.701176))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.604179 0.545630 0.487081 0.428532 0.369984))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.080411 1.021862 0.963313 0.904764 0.846216))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.749219 0.690670 0.632121 0.573572 0.515024))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.418027 0.359478 0.300929 0.242380 1.783832))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.894259))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.563067))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.231875))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.708107 0.649558 0.591009 0.532460))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.376915 0.318366 0.259817 0.201268))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.645723 1.587174 1.528625 1.470076))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.521955 0.463406 0.404857 0.346308 0.287760))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.790763 1.732214 1.673665 1.615116 1.556568))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.459571 1.401022 1.342473 1.283924 1.225376))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.335803 0.277254 0.218705 1.760156 1.701608))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.604611 1.546062 1.487513 1.428964 1.370416))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.273419 1.214870 1.156321 1.097772 1.039224))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.749651 1.691102 1.632553))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.418459 1.359910 1.301361))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.087267 1.028718 0.970169))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.563499))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.232307))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.901115))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.377347 1.318798 1.260249 1.201700))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.046155 0.987606 0.929057 0.870508))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.714963 0.656414 0.597865 0.539316))

def prop_wireLeft_at_ym  : Bool :=
  let v13 := ((Float.sqrt (((1.22 : Float) ^ 2) + ((0.34 : Float) ^ 2))) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  (((0.111 : Float) < v13) && (v13 < (0.113 : Float)))

#eval IO.println ("prop_wireLeft_at_ym " ++ toString (prop_wireLeft_at_ym))
#eval IO.println ("prop_wireLeft_at_ym " ++ toString (prop_wireLeft_at_ym))
#eval IO.println ("prop_wireLeft_at_ym " ++ toString (prop_wireLeft_at_ym))

def prop_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v8 := (-ze)
  let v9 := (Float.sin t)
  let v12 := ((v6 * v7) + (v8 * v9))
  let v16 := (((-v6) * v9) + (v8 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v9)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v9)) ^ 2) + ((((a * v9) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.005043 0.946494 0.887945 0.829396 0.770848))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.673851 0.615302 0.556753 0.498204 0.439656))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.342659 0.284110 0.225561 1.767012 1.708464))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.818891 0.760342 0.701793 0.643244))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.487699 0.429150 0.370601 0.312052))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.756507 1.697958 1.639409 1.580860))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.632739 0.574190 0.515641 0.457092))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.301547 0.242998 1.784449 1.725900))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.570355 1.511806 1.453257 1.394708))

def prop_wireLever_rest_at_ym  : Bool :=
  let v3 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v16 := ((((1.22 : Float) * v3) + ((0.34 : Float) * (0.8 : Float))) / (Float.sqrt ((((1.22 : Float) - (0.8 : Float)) ^ 2) + (((0.34 : Float) + v3) ^ 2))))
  (((1.033 : Float) < v16) && (v16 < (1.035 : Float)))

#eval IO.println ("prop_wireLever_rest_at_ym " ++ toString (prop_wireLever_rest_at_ym))
#eval IO.println ("prop_wireLever_rest_at_ym " ++ toString (prop_wireLever_rest_at_ym))
#eval IO.println ("prop_wireLever_rest_at_ym " ++ toString (prop_wireLever_rest_at_ym))

def prop_wireLever_sixty_at_ym  : Bool :=
  let v1 := (-(1.22 : Float))
  let v3 := (-(0.8 : Float))
  let v6 := ((3.141592653589793 : Float) / (3 : Float))
  let v7 := (Float.cos v6)
  let v12 := (-((Float.sqrt (3.36 : Float)) - (1 : Float)))
  let v13 := (Float.sin v6)
  let v16 := ((v3 * v7) + (v12 * v13))
  let v20 := (((-v3) * v13) + (v12 * v7))
  let v31 := (((v1 * v20) - ((0.34 : Float) * v16)) / (Float.sqrt (((v16 - v1) ^ 2) + ((v20 - (0.34 : Float)) ^ 2))))
  (((0.37 : Float) < v31) && (v31 < (0.38 : Float)))

#eval IO.println ("prop_wireLever_sixty_at_ym " ++ toString (prop_wireLever_sixty_at_ym))
#eval IO.println ("prop_wireLever_sixty_at_ym " ++ toString (prop_wireLever_sixty_at_ym))
#eval IO.println ("prop_wireLever_sixty_at_ym " ++ toString (prop_wireLever_sixty_at_ym))

def prop_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v9 := (apexH * (0 : Float))
  let v10 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v10 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v9) * f_1)) + ((v9 - ((0 : Float) * (1 : Float))) * f_2)) (v10 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.674283 1.615734 1.557185 1.498636 1.440088 1.381539 1.322990 1.264441))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.343091 1.284542 1.225993 1.167444 1.108896 1.050347 0.991798 0.933249))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.011899 0.953350 0.894801 0.836252 0.777704 0.719155 0.660606 0.602057))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.301979 1.243430 1.184881 1.126332))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.970787 0.912238 0.853689 0.795140))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.639595 0.581046 0.522497 0.463948))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.115827 1.057278 0.998729))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.784635 0.726086 0.667537))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.453443 0.394894 0.336345))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.743523 0.684974).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.412331 0.353782).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.681139 1.622590).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def qAbs (alpha : Float) (Pin : Float) : Float :=
  (alpha * Pin)

#eval IO.println ("qAbs " ++ toString (qAbs 0.371219 0.312670).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 1.640027 1.581478).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 1.308835 1.250286).toBits)

def qCoilLoss (eps : Float) (Ac : Float) (hC : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.785067 1.726518 1.667969 1.609420 1.550872).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.453875 1.395326 1.336777 1.278228 1.219680).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.122683 1.064134 1.005585 0.947036 0.888488).toBits)

def qNet (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Float :=
  let v19 := (Toil - Ta)
  ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("qNet " ++ toString (qNet 1.598915 1.540366 1.481817 1.423268 1.364720 1.306171 1.247622 1.189073 1.130524 1.071976).toBits)
#eval IO.println ("qNet " ++ toString (qNet 1.267723 1.209174 1.150625 1.092076 1.033528 0.974979 0.916430 0.857881 0.799332 0.740784).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.936531 0.877982 0.819433 0.760884 0.702336 0.643787 0.585238 0.526689 0.468140 0.409592).toBits)

def check_qNet_antitone (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) <= (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.412763 1.354214 1.295665 1.237116 1.178568 1.120019 1.061470 1.002921 0.944372 0.885824 0.827275))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.081571 1.023022 0.964473 0.905924 0.847376 0.788827 0.730278 0.671729 0.613180 0.554632 0.496083))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.750379 0.691830 0.633281 0.574732 0.516184 0.457635 0.399086 0.340537 0.281988 0.223440 1.764891))

def check_qNet_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v22 := (alpha * Pin)
  let v25 := ((eps * (0.0000000567 : Float)) * Ac)
  let v27 := (Ta ^ 4)
  let v30 := (hC * Ac)
  let v31 := (T1 - Ta)
  let v44 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((((v22 - ((v25 * ((T1 ^ 4) - v27)) + (v30 * v31))) - (Upipe * v31)) - (max (0 : Float) (UAx * (T1 - Twall)))) - (((v22 - ((v25 * ((T2 ^ 4) - v27)) + (v30 * v44))) - (Upipe * v44)) - (max (0 : Float) (UAx * (T2 - Twall)))))) <= (((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v30) + Upipe) + UAx) * (Float.abs (T1 - T2)))))))))))))

#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.226611 1.168062 1.109513 1.050964 0.992416 0.933867 0.875318 0.816769 0.758220 0.699672 0.641123 0.582574))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.895419 0.836870 0.778321 0.719772 0.661224 0.602675 0.544126 0.485577 0.427028 0.368480 0.309931 0.251382))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.564227 0.505678 0.447129 0.388580 0.330032 0.271483 0.212934 1.754385 1.695836 1.637288 1.578739 1.520190))

def check_qNet_strictAnti (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 < T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) < (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.040459 0.981910 0.923361 0.864812 0.806264 0.747715 0.689166 0.630617 0.572068 0.513520 0.454971))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.709267 0.650718 0.592169 0.533620 0.475072 0.416523 0.357974 0.299425 0.240876 1.782328 1.723779))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.378075 0.319526 0.260977 0.202428 1.743880 1.685331 1.626782 1.568233 1.509684 1.451136 1.392587))

def qPipe (Upipe : Float) (Toil : Float) (Ta : Float) : Float :=
  (Upipe * (Toil - Ta))

#eval IO.println ("qPipe " ++ toString (qPipe 0.854307 0.795758 0.737209).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 0.523115 0.464566 0.406017).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.791923 1.733374 1.674825).toBits)

def qPot (UAx : Float) (Toil : Float) (Twall : Float) : Float :=
  (max (0 : Float) (UAx * (Toil - Twall)))

#eval IO.println ("qPot " ++ toString (qPot 0.668155 0.609606 0.551057).toBits)
#eval IO.println ("qPot " ++ toString (qPot 0.336963 0.278414 0.219865).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.605771 1.547222 1.488673).toBits)

def check_qPot_le (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  let v5 := (Toil - Twall)
  (!((0 : Float) <= UAx) || ((max (0 : Float) (UAx * v5)) <= (UAx * (max (0 : Float) v5))))

#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.482003 0.423454 0.364905))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.750811 1.692262 1.633713))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.419619 1.361070 1.302521))

def check_qPot_nonneg (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  ((0 : Float) <= (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.295851 0.237302 1.778753))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.564659 1.506110 1.447561))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.233467 1.174918 1.116369))

def check_quantum_outruns_sun  : Bool :=
  (((0.000073 : Float) < ((((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)) / (3 : Float))) && ((0.000073 : Float) < ((((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)) / (3 : Float))))

#eval IO.println ("check_quantum_outruns_sun " ++ toString (check_quantum_outruns_sun))
#eval IO.println ("check_quantum_outruns_sun " ++ toString (check_quantum_outruns_sun))
#eval IO.println ("check_quantum_outruns_sun " ++ toString (check_quantum_outruns_sun))

def check_quantum_within_budget  : Bool :=
  (((((((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)) / (3 : Float)) * (15 : Float)) < (0.03 : Float)) && ((((((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)) / (3 : Float)) * (15 : Float)) < (0.03 : Float)))

#eval IO.println ("check_quantum_within_budget " ++ toString (check_quantum_within_budget))
#eval IO.println ("check_quantum_within_budget " ++ toString (check_quantum_within_budget))
#eval IO.println ("check_quantum_within_budget " ++ toString (check_quantum_within_budget))

def check_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v6 := (ym * a)
  (!((0 : Float) < ze) || ((v6 <= (hp * ze)) == ((v6 / ze) <= hp)))

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.337395 1.278846 1.220297 1.161748))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.006203 0.947654 0.889105 0.830556))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.675011 0.616462 0.557913 0.499364))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 0.965091 0.906542 0.847993 0.789444 0.730896 0.672347 0.613798 0.555249 0.496700 0.438152 0.379603 0.321054).toBits)
#eval IO.println ("recip " ++ toString (recip 0.633899 0.575350 0.516801 0.458252 0.399704 0.341155 0.282606 0.224057 1.765508 1.706960 1.648411 1.589862).toBits)
#eval IO.println ("recip " ++ toString (recip 0.302707 0.244158 1.785609 1.727060 1.668512 1.609963 1.551414 1.492865 1.434316 1.375768 1.317219 1.258670).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 0.778939 0.720390 0.661841 0.603292 0.544744 0.486195).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 0.447747 0.389198 0.330649 0.272100 0.213552 1.755003).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.716555 1.658006 1.599457 1.540908 1.482360 1.423811).map Float.toBits))

def rhoCu  : Float :=
  (0.0000000172 : Float)

#eval IO.println ("rhoCu " ++ toString (rhoCu).toBits)
#eval IO.println ("rhoCu " ++ toString (rhoCu).toBits)
#eval IO.println ("rhoCu " ++ toString (rhoCu).toBits)

def check_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.cos t)
  let v8 := (-ze)
  let v9 := (Float.sin t)
  (!((0 : Float) < ze) || (!((0 : Float) < v5) || ((feq ((a * v5) + (v8 * v9)) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.406635 0.348086 0.289537))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.675443 1.616894 1.558345))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.344251 1.285702 1.227153))

def rodTan  : Float :=
  ((0.4 : Float) / ((Float.sqrt (3.2 : Float)) - (1 : Float)))

#eval IO.println ("rodTan " ++ toString (rodTan).toBits)
#eval IO.println ("rodTan " ++ toString (rodTan).toBits)
#eval IO.println ("rodTan " ++ toString (rodTan).toBits)

def check_rodTan_bounds  : Bool :=
  let v6 := ((0.4 : Float) / ((Float.sqrt (3.2 : Float)) - (1 : Float)))
  (((0.507 : Float) < v6) && (v6 < (0.5072 : Float)))

#eval IO.println ("check_rodTan_bounds " ++ toString (check_rodTan_bounds))
#eval IO.println ("check_rodTan_bounds " ++ toString (check_rodTan_bounds))
#eval IO.println ("check_rodTan_bounds " ++ toString (check_rodTan_bounds))

def rollY (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  let v5 := (p_1 * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (p_2 * (1 : Float))), ((p_2 * (0 : Float)) - (p_0 * (0 : Float))), ((p_0 * (1 : Float)) - v5)]

#eval IO.println ("rollY " ++ toString ((rollY 1.448179 1.389630 1.331081).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 1.116987 1.058438 0.999889).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.785795 0.727246 0.668697).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.262027 1.203478 1.144929 1.086380 1.027832 0.969283).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.930835 0.872286 0.813737 0.755188 0.696640 0.638091).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.599643 0.541094 0.482545 0.423996 0.365448 0.306899).toBits)

def check_rollerRadius_hashemi  : Bool :=
  (feq (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))) (Float.sqrt (1.4864 : Float)))

#eval IO.println ("check_rollerRadius_hashemi " ++ toString (check_rollerRadius_hashemi))
#eval IO.println ("check_rollerRadius_hashemi " ++ toString (check_rollerRadius_hashemi))
#eval IO.println ("check_rollerRadius_hashemi " ++ toString (check_rollerRadius_hashemi))

def check_rollerRadius_hashemi_bounds  : Bool :=
  let v12 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  (((1.219 : Float) < v12) && (v12 < (1.2195 : Float)))

#eval IO.println ("check_rollerRadius_hashemi_bounds " ++ toString (check_rollerRadius_hashemi_bounds))
#eval IO.println ("check_rollerRadius_hashemi_bounds " ++ toString (check_rollerRadius_hashemi_bounds))
#eval IO.println ("check_rollerRadius_hashemi_bounds " ++ toString (check_rollerRadius_hashemi_bounds))

def check_rollerRadius_pos (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  ((0 : Float) < (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))))

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.703571 0.645022 0.586473 0.527924 0.469376 0.410827))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.372379 0.313830 0.255281 1.796732 1.738184 1.679635))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.641187 1.582638 1.524089 1.465540 1.406992 1.348443))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.517419 0.458870 0.400321 0.341772 0.283224 0.224675))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.786227 1.727678 1.669129 1.610580 1.552032 1.493483))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.455035 1.396486 1.337937 1.279388 1.220840 1.162291))

def check_roller_rpm_hashemi  : Bool :=
  let v7 := ((((2 : Float) / (360 : Float)) * (1.2192 : Float)) / (0.05 : Float))
  (((0.13 : Float) < v7) && (v7 < (0.14 : Float)))

#eval IO.println ("check_roller_rpm_hashemi " ++ toString (check_roller_rpm_hashemi))
#eval IO.println ("check_roller_rpm_hashemi " ++ toString (check_roller_rpm_hashemi))
#eval IO.println ("check_roller_rpm_hashemi " ++ toString (check_roller_rpm_hashemi))

def rot (psi : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  let v3 := (Float.cos psi)
  let v5 := (Float.sin psi)
  #[((v3 * p_1) - (v5 * p_2)), ((v5 * p_1) + (v3 * p_2))]

#eval IO.println ("rot " ++ toString ((rot 1.745115 1.686566 1.628017).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.413923 1.355374 1.296825).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.082731 1.024182 0.965633).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 1.558963 1.500414 1.441865 1.383316).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 1.227771 1.169222 1.110673 1.052124).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.896579 0.838030 0.779481 0.720932).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.372811 1.314262 1.255713 1.197164 1.138616 1.080067 1.021518))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.041619 0.983070 0.924521 0.865972 0.807424 0.748875 0.690326))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.710427 0.651878 0.593329 0.534780 0.476232 0.417683 0.359134))

def sampleRay (a : Float) (w : Float) (hsun : Float) (sd_0 : Float) (sd_1 : Float) (sd_2 : Float) (u1 : Float) (u2 : Float) (u3 : Float) (u4 : Float) (u5 : Float) (u6 : Float) : Array Float :=
  let v14 := (((2 : Float) * a) / w)
  let v17 := ((-a) + (w / (2 : Float)))
  let v27 := ((1 : Float) / (2 : Float))
  let v32 := (-sd_0)
  let v33 := (-sd_1)
  let v34 := (-sd_2)
  let v39 := ((Float.abs v34) < ((9 : Float) / (10 : Float)))
  let v41 := (if v39 then (0 : Float) else (1 : Float))
  let v42 := (if v39 then (1 : Float) else (0 : Float))
  let v45 := ((v33 * v42) - (v34 * (0 : Float)))
  let v48 := ((v34 * v41) - (v32 * v42))
  let v51 := ((v32 * (0 : Float)) - (v33 * v41))
  let v59 := (Float.sqrt (max (((v45 ^ 2) + (v48 ^ 2)) + (v51 ^ 2)) (0.000000000000000001 : Float)))
  let v60 := (v45 / v59)
  let v61 := (v48 / v59)
  let v62 := (v51 / v59)
  let v73 := (hsun * (Float.sqrt u5))
  let v76 := (((2 : Float) * (3.141592653589793 : Float)) * u6)
  let v77 := (Float.cos v73)
  let v79 := (Float.sin v73)
  let v80 := (Float.cos v76)
  let v82 := (Float.sin v76)
  #[(v17 + (w * (Float.floor (u1 * v14)))), (v17 + (w * (Float.floor (u2 * v14)))), ((u3 - v27) * w), ((u4 - v27) * w), ((v77 * v32) + (v79 * ((v80 * v60) + (v82 * ((v33 * v62) - (v34 * v61)))))), ((v77 * v33) + (v79 * ((v80 * v61) + (v82 * ((v34 * v60) - (v32 * v62)))))), ((v77 * v34) + (v79 * ((v80 * v62) + (v82 * ((v32 * v61) - (v33 * v60))))))]

#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.186659 1.128110 1.069561 1.011012 0.952464 0.893915 0.835366 0.776817 0.718268 0.659720 0.601171 0.542622).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.855467 0.796918 0.738369 0.679820 0.621272 0.562723 0.504174 0.445625 0.387076 0.328528 0.269979 0.211430).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.524275 0.465726 0.407177 0.348628 0.290080 0.231531 1.772982 1.714433 1.655884 1.597336 1.538787 1.480238).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 1.000507 0.941958).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.669315 0.610766).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.338123 0.279574).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.814355 0.755806))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.483163 0.424614))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.751971 1.693422))

def check_screwLength_hashemi  : Bool :=
  (feq (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((1 : Float) ^ 2))))) ((Float.sqrt (3 : Float)) - (1 : Float)))

#eval IO.println ("check_screwLength_hashemi " ++ toString (check_screwLength_hashemi))
#eval IO.println ("check_screwLength_hashemi " ++ toString (check_screwLength_hashemi))
#eval IO.println ("check_screwLength_hashemi " ++ toString (check_screwLength_hashemi))

def check_screwLength_hashemi_bounds  : Bool :=
  let v9 := (((2 : Float) / (2 : Float)) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((1 : Float) ^ 2)))))
  (((0.732 : Float) < v9) && (v9 < (0.7321 : Float)))

#eval IO.println ("check_screwLength_hashemi_bounds " ++ toString (check_screwLength_hashemi_bounds))
#eval IO.println ("check_screwLength_hashemi_bounds " ++ toString (check_screwLength_hashemi_bounds))
#eval IO.println ("check_screwLength_hashemi_bounds " ++ toString (check_screwLength_hashemi_bounds))

def screwTwist (h : Float) (zBolt : Float) : Array Float :=
  #[(1 : Float), (0 : Float), (0 : Float), h, zBolt, (0 : Float)]

#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.255899 1.797350).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.524707 1.466158).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.193515 1.134966).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.669747 1.611198))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.338555 1.280006))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.007363 0.948814))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.483595 1.425046 1.366497).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.152403 1.093854 1.035305).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.821211 0.762662 0.704113).map Float.toBits))

def check_screw_freedom (xh : Float) (zBolt : Float) (h : Float) (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) : Bool :=
  let v11 := ((0 : Float) * (0 : Float))
  let v14 := (zBolt * (0 : Float))
  let v15 := (xh * (0 : Float))
  let v17 := (xh * (1 : Float))
  let v29 := (t_3 * (0 : Float))
  let v33 := (t_5 * (0 : Float))
  let v42 := (t_4 * (0 : Float))
  let v47 := (t_0 * (0 : Float))
  let v50 := (t_2 * (0 : Float))
  (!((feq ((((((t_0 * (v11 - (zBolt * (1 : Float)))) + (t_1 * (v14 - v15))) + (t_2 * (v17 - v11))) + v29) + (t_4 * (1 : Float))) + v33) (0 : Float)) && ((feq ((((((t_0 * (((0 : Float) * (1 : Float)) - v14)) + (t_1 * (v14 - v17))) + (t_2 * (v15 - v11))) + v29) + v42) + (t_5 * (1 : Float))) (0 : Float)) && ((feq (((((v47 + (t_1 * (1 : Float))) + v50) + v29) + v42) + v33) (0 : Float)) && ((feq (((((v47 + (t_1 * (0 : Float))) + (t_2 * (1 : Float))) + v29) + v42) + v33) (0 : Float)) && (feq ((((((t_0 * (-h)) + (t_1 * zBolt)) + v50) + (t_3 * (1 : Float))) + v42) + v33) (0 : Float)))))) || ((feq t_1 (0 : Float)) && ((feq t_2 (0 : Float)) && ((feq t_3 (t_0 * h)) && ((feq t_4 (t_0 * zBolt)) && (feq t_5 (0 : Float)))))))

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.297443 1.238894 1.180345 1.121796 1.063248 1.004699 0.946150 0.887601 0.829052))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.966251 0.907702 0.849153 0.790604 0.732056 0.673507 0.614958 0.556409 0.497860))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.635059 0.576510 0.517961 0.459412 0.400864 0.342315 0.283766 0.225217 1.766668))

def check_screw_reciprocal (xh : Float) (zBolt : Float) (h : Float) : Bool :=
  let v5 := ((0 : Float) * (0 : Float))
  let v6 := (zBolt * (1 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  let v13 := ((0 : Float) * (1 : Float))
  let v23 := (h * (0 : Float))
  let v37 := ((1 : Float) * (0 : Float))
  ((feq (((((((1 : Float) * (v5 - v6)) + ((0 : Float) * (v8 - v9))) + ((0 : Float) * (v11 - v5))) + v23) + v6) + v5) (0 : Float)) && ((feq (((((((1 : Float) * (v13 - v8)) + ((0 : Float) * (v8 - v11))) + ((0 : Float) * (v9 - v5))) + v23) + v8) + v13) (0 : Float)) && ((feq (((((v37 + v13) + v5) + v23) + v8) + v5) (0 : Float)) && ((feq (((((v37 + v5) + v13) + v23) + v8) + v5) (0 : Float)) && (feq (((((((1 : Float) * (-h)) + ((0 : Float) * zBolt)) + v5) + (h * (1 : Float))) + v8) + v5) (0 : Float))))))

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.111291 1.052742 0.994193))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.780099 0.721550 0.663001))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.448907 0.390358 0.331809))

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 0.925139 0.866590).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.593947 0.535398).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.262755 0.204206).toBits)

def check_shim_negligible  : Bool :=
  ((0.0005 : Float) < ((0.01 : Float) * (0.06 : Float)))

#eval IO.println ("check_shim_negligible " ++ toString (check_shim_negligible))
#eval IO.println ("check_shim_negligible " ++ toString (check_shim_negligible))
#eval IO.println ("check_shim_negligible " ++ toString (check_shim_negligible))

def sideGap  : Float :=
  (((1.84 : Float) - ((2 : Float) * (0.8 : Float))) / (2 : Float))

#eval IO.println ("sideGap " ++ toString (sideGap).toBits)
#eval IO.println ("sideGap " ++ toString (sideGap).toBits)
#eval IO.println ("sideGap " ++ toString (sideGap).toBits)

def check_sideGap_eq  : Bool :=
  (feq (((1.84 : Float) - ((2 : Float) * (0.8 : Float))) / (2 : Float)) (0.12 : Float))

#eval IO.println ("check_sideGap_eq " ++ toString (check_sideGap_eq))
#eval IO.println ("check_sideGap_eq " ++ toString (check_sideGap_eq))
#eval IO.println ("check_sideGap_eq " ++ toString (check_sideGap_eq))

def sigmaSB  : Float :=
  (0.0000000567 : Float)

#eval IO.println ("sigmaSB " ++ toString (sigmaSB).toBits)
#eval IO.println ("sigmaSB " ++ toString (sigmaSB).toBits)
#eval IO.println ("sigmaSB " ++ toString (sigmaSB).toBits)

def check_sigmoid_ge_of_nonneg (x : Float) : Bool :=
  (!((0 : Float) <= x) || (((1 : Float) - ((1 : Float) / ((2 : Float) + x))) <= (1.0 / (1.0 + Float.exp (-x)))))

#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.594379))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.263187))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.931995))

def check_sigmoid_slope_le (x : Float) : Bool :=
  let v1 := (1.0 / (1.0 + Float.exp (-x)))
  ((v1 * ((1 : Float) - v1)) <= ((1 : Float) / (4 : Float)))

#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.408227))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.077035))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.745843))

def check_sixty_reachable  : Bool :=
  let v2 := ((3.141592653589793 : Float) / (3 : Float))
  let v11 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  (((Float.sin v2) * (((1.2 : Float) * (0.8 : Float)) - ((0.34 : Float) * v11))) < ((Float.cos v2) * (((1.2 : Float) * v11) + ((0.34 : Float) * (0.8 : Float)))))

#eval IO.println ("check_sixty_reachable " ++ toString (check_sixty_reachable))
#eval IO.println ("check_sixty_reachable " ++ toString (check_sixty_reachable))
#eval IO.println ("check_sixty_reachable " ++ toString (check_sixty_reachable))

def check_slackHarmless_of_budget (f : Float) (eps : Float) (delta : Float) (h : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.035923 0.977374 0.918825 0.860276))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.704731 0.646182 0.587633 0.529084))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.373539 0.314990 0.256441 1.797892))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.849771 0.791222 0.732673 0.674124 0.615576))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.518579 0.460030 0.401481 0.342932 0.284384))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.787387 1.728838 1.670289 1.611740 1.553192))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 0.663619 0.605070 0.546521).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.332427 0.273878 0.215329).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 1.601235 1.542686 1.484137).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 0.477467 0.418918).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.746275 1.687726).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.415083 1.356534).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.705163 1.646614).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.373971 1.315422).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.042779 0.984230).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.519011 1.460462).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.187819 1.129270).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.856627 0.798078).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 1.332859 1.274310 1.215761).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.001667 0.943118 0.884569).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 0.670475 0.611926 0.553377).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.146707 1.088158).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.815515 0.756966).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.484323 0.425774).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.960555 0.902006 0.843457 0.784908 0.726360 0.667811 0.609262).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.629363 0.570814 0.512265 0.453716 0.395168 0.336619 0.278070).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.298171 0.239622 1.781073 1.722524 1.663976 1.605427 1.546878).map Float.toBits))

def spotTau  : Float :=
  (0.005 : Float)

#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.588251 0.529702 0.471153))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.257059 1.798510 1.739961))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.525867 1.467318 1.408769))

def check_sqrt32_bounds  : Bool :=
  let v2 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v2) && (v2 < (1.78886 : Float)))

#eval IO.println ("check_sqrt32_bounds " ++ toString (check_sqrt32_bounds))
#eval IO.println ("check_sqrt32_bounds " ++ toString (check_sqrt32_bounds))
#eval IO.println ("check_sqrt32_bounds " ++ toString (check_sqrt32_bounds))

def check_steady_conservation (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v19 := (Toil - Ta)
  let v24 := (((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19))
  let v28 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!(feq (v24 - v28) (0 : Float)) || (feq v28 v24))

#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.215947 1.757398 1.698849 1.640300 1.581752 1.523203 1.464654 1.406105 1.347556 1.289008))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.484755 1.426206 1.367657 1.309108 1.250560 1.192011 1.133462 1.074913 1.016364 0.957816))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.153563 1.095014 1.036465 0.977916 0.919368 0.860819 0.802270 0.743721 0.685172 0.626624))

def check_steady_pot_le_abs (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v17 := (alpha * Pin)
  let v26 := (Toil - Ta)
  let v34 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= Ta) || (!(Ta <= Toil) || (!(feq (((v17 - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v26))) - (Upipe * v26)) - v34) (0 : Float)) || (v34 <= v17))))))))

#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.629795 1.571246 1.512697 1.454148 1.395600 1.337051 1.278502 1.219953 1.161404 1.102856))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.298603 1.240054 1.181505 1.122956 1.064408 1.005859 0.947310 0.888761 0.830212 0.771664))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.967411 0.908862 0.850313 0.791764 0.733216 0.674667 0.616118 0.557569 0.499020 0.440472))

def check_steady_unique (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T1 - Ta)
  let v42 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!((0 : Float) <= T2) || (!(feq (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T1 - Twall)))) (0 : Float)) || (!(feq (((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v42))) - (Upipe * v42)) - (max (0 : Float) (UAx * (T2 - Twall)))) (0 : Float)) || (feq T1 T2))))))))))

#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.443643 1.385094 1.326545 1.267996 1.209448 1.150899 1.092350 1.033801 0.975252 0.916704 0.858155))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.112451 1.053902 0.995353 0.936804 0.878256 0.819707 0.761158 0.702609 0.644060 0.585512 0.526963))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.781259 0.722710 0.664161 0.605612 0.547064 0.488515 0.429966 0.371417 0.312868 0.254320 1.795771))

def step (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (rw : Float) (R : Float) (rDrum : Float) (ym : Float) (hp : Float) (a : Float) (ze : Float) (W : Float) (rcm : Float) (Tmax : Float) : Array Float :=
  let v16 := (ym * a)
  let v17 := (hp * ze)
  let v28 := (if (v16 <= v17) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v16 - v17))))
  let v29 := (-ym)
  let v30 := (-a)
  let v32 := (Float.cos (0 : Float))
  let v34 := (-ze)
  let v35 := (Float.sin (0 : Float))
  let v38 := (-v30)
  let v47 := (Float.sqrt (((((v30 * v32) + (v34 * v35)) - v29) ^ 2) + ((((v38 * v35) + (v34 * v32)) - hp) ^ 2)))
  let v48 := (Float.cos v28)
  let v50 := (Float.sin v28)
  let v61 := (Float.sqrt (((((v30 * v48) + (v34 * v50)) - v29) ^ 2) + ((((v38 * v50) + (v34 * v48)) - hp) ^ 2)))
  let v62 := (Float.cos t)
  let v64 := (Float.sin t)
  let v75 := (Float.sqrt (((((v30 * v62) + (v34 * v64)) - v29) ^ 2) + ((((v38 * v64) + (v34 * v62)) - hp) ^ 2)))
  let v79 := ((v75 + slack) - ((omegad * rDrum) * dt))
  let v80 := (v79 < v61)
  let v81 := (v47 < v79)
  let v83 := (if v80 then v61 else (if v81 then v47 else v79))
  let v88 := (((0 : Float) + v28) / (2 : Float))
  let v89 := (Float.cos v88)
  let v91 := (Float.sin v88)
  let v103 := (v83 < (Float.sqrt (((((v30 * v89) + (v34 * v91)) - v29) ^ 2) + ((((v38 * v91) + (v34 * v89)) - hp) ^ 2))))
  let v104 := (if v103 then v88 else (0 : Float))
  let v105 := (if v103 then v28 else v88)
  let v107 := ((v104 + v105) / (2 : Float))
  let v108 := (Float.cos v107)
  let v110 := (Float.sin v107)
  let v122 := (v83 < (Float.sqrt (((((v30 * v108) + (v34 * v110)) - v29) ^ 2) + ((((v38 * v110) + (v34 * v108)) - hp) ^ 2))))
  let v123 := (if v122 then v107 else v104)
  let v124 := (if v122 then v105 else v107)
  let v126 := ((v123 + v124) / (2 : Float))
  let v127 := (Float.cos v126)
  let v129 := (Float.sin v126)
  let v141 := (v83 < (Float.sqrt (((((v30 * v127) + (v34 * v129)) - v29) ^ 2) + ((((v38 * v129) + (v34 * v127)) - hp) ^ 2))))
  let v142 := (if v141 then v126 else v123)
  let v143 := (if v141 then v124 else v126)
  let v145 := ((v142 + v143) / (2 : Float))
  let v146 := (Float.cos v145)
  let v148 := (Float.sin v145)
  let v160 := (v83 < (Float.sqrt (((((v30 * v146) + (v34 * v148)) - v29) ^ 2) + ((((v38 * v148) + (v34 * v146)) - hp) ^ 2))))
  let v161 := (if v160 then v145 else v142)
  let v162 := (if v160 then v143 else v145)
  let v164 := ((v161 + v162) / (2 : Float))
  let v165 := (Float.cos v164)
  let v167 := (Float.sin v164)
  let v179 := (v83 < (Float.sqrt (((((v30 * v165) + (v34 * v167)) - v29) ^ 2) + ((((v38 * v167) + (v34 * v165)) - hp) ^ 2))))
  let v180 := (if v179 then v164 else v161)
  let v181 := (if v179 then v162 else v164)
  let v183 := ((v180 + v181) / (2 : Float))
  let v184 := (Float.cos v183)
  let v186 := (Float.sin v183)
  let v198 := (v83 < (Float.sqrt (((((v30 * v184) + (v34 * v186)) - v29) ^ 2) + ((((v38 * v186) + (v34 * v184)) - hp) ^ 2))))
  let v199 := (if v198 then v183 else v180)
  let v200 := (if v198 then v181 else v183)
  let v202 := ((v199 + v200) / (2 : Float))
  let v203 := (Float.cos v202)
  let v205 := (Float.sin v202)
  let v217 := (v83 < (Float.sqrt (((((v30 * v203) + (v34 * v205)) - v29) ^ 2) + ((((v38 * v205) + (v34 * v203)) - hp) ^ 2))))
  let v218 := (if v217 then v202 else v199)
  let v219 := (if v217 then v200 else v202)
  let v221 := ((v218 + v219) / (2 : Float))
  let v222 := (Float.cos v221)
  let v224 := (Float.sin v221)
  let v236 := (v83 < (Float.sqrt (((((v30 * v222) + (v34 * v224)) - v29) ^ 2) + ((((v38 * v224) + (v34 * v222)) - hp) ^ 2))))
  let v237 := (if v236 then v221 else v218)
  let v238 := (if v236 then v219 else v221)
  let v240 := ((v237 + v238) / (2 : Float))
  let v241 := (Float.cos v240)
  let v243 := (Float.sin v240)
  let v255 := (v83 < (Float.sqrt (((((v30 * v241) + (v34 * v243)) - v29) ^ 2) + ((((v38 * v243) + (v34 * v241)) - hp) ^ 2))))
  let v256 := (if v255 then v240 else v237)
  let v257 := (if v255 then v238 else v240)
  let v259 := ((v256 + v257) / (2 : Float))
  let v260 := (Float.cos v259)
  let v262 := (Float.sin v259)
  let v274 := (v83 < (Float.sqrt (((((v30 * v260) + (v34 * v262)) - v29) ^ 2) + ((((v38 * v262) + (v34 * v260)) - hp) ^ 2))))
  let v275 := (if v274 then v259 else v256)
  let v276 := (if v274 then v257 else v259)
  let v278 := ((v275 + v276) / (2 : Float))
  let v279 := (Float.cos v278)
  let v281 := (Float.sin v278)
  let v293 := (v83 < (Float.sqrt (((((v30 * v279) + (v34 * v281)) - v29) ^ 2) + ((((v38 * v281) + (v34 * v279)) - hp) ^ 2))))
  let v294 := (if v293 then v278 else v275)
  let v295 := (if v293 then v276 else v278)
  let v297 := ((v294 + v295) / (2 : Float))
  let v298 := (Float.cos v297)
  let v300 := (Float.sin v297)
  let v312 := (v83 < (Float.sqrt (((((v30 * v298) + (v34 * v300)) - v29) ^ 2) + ((((v38 * v300) + (v34 * v298)) - hp) ^ 2))))
  let v313 := (if v312 then v297 else v294)
  let v314 := (if v312 then v295 else v297)
  let v316 := ((v313 + v314) / (2 : Float))
  let v317 := (Float.cos v316)
  let v319 := (Float.sin v316)
  let v331 := (v83 < (Float.sqrt (((((v30 * v317) + (v34 * v319)) - v29) ^ 2) + ((((v38 * v319) + (v34 * v317)) - hp) ^ 2))))
  let v332 := (if v331 then v316 else v313)
  let v333 := (if v331 then v314 else v316)
  let v335 := ((v332 + v333) / (2 : Float))
  let v336 := (Float.cos v335)
  let v338 := (Float.sin v335)
  let v350 := (v83 < (Float.sqrt (((((v30 * v336) + (v34 * v338)) - v29) ^ 2) + ((((v38 * v338) + (v34 * v336)) - hp) ^ 2))))
  let v351 := (if v350 then v335 else v332)
  let v352 := (if v350 then v333 else v335)
  let v354 := ((v351 + v352) / (2 : Float))
  let v355 := (Float.cos v354)
  let v357 := (Float.sin v354)
  let v369 := (v83 < (Float.sqrt (((((v30 * v355) + (v34 * v357)) - v29) ^ 2) + ((((v38 * v357) + (v34 * v355)) - hp) ^ 2))))
  let v370 := (if v369 then v354 else v351)
  let v371 := (if v369 then v352 else v354)
  let v373 := ((v370 + v371) / (2 : Float))
  let v374 := (Float.cos v373)
  let v376 := (Float.sin v373)
  let v388 := (v83 < (Float.sqrt (((((v30 * v374) + (v34 * v376)) - v29) ^ 2) + ((((v38 * v376) + (v34 * v374)) - hp) ^ 2))))
  let v389 := (if v388 then v373 else v370)
  let v390 := (if v388 then v371 else v373)
  let v392 := ((v389 + v390) / (2 : Float))
  let v393 := (Float.cos v392)
  let v395 := (Float.sin v392)
  let v407 := (v83 < (Float.sqrt (((((v30 * v393) + (v34 * v395)) - v29) ^ 2) + ((((v38 * v395) + (v34 * v393)) - hp) ^ 2))))
  let v408 := (if v407 then v392 else v389)
  let v409 := (if v407 then v390 else v392)
  let v411 := ((v408 + v409) / (2 : Float))
  let v412 := (Float.cos v411)
  let v414 := (Float.sin v411)
  let v426 := (v83 < (Float.sqrt (((((v30 * v412) + (v34 * v414)) - v29) ^ 2) + ((((v38 * v414) + (v34 * v412)) - hp) ^ 2))))
  let v427 := (if v426 then v411 else v408)
  let v428 := (if v426 then v409 else v411)
  let v430 := ((v427 + v428) / (2 : Float))
  let v431 := (Float.cos v430)
  let v433 := (Float.sin v430)
  let v445 := (v83 < (Float.sqrt (((((v30 * v431) + (v34 * v433)) - v29) ^ 2) + ((((v38 * v433) + (v34 * v431)) - hp) ^ 2))))
  let v446 := (if v445 then v430 else v427)
  let v447 := (if v445 then v428 else v430)
  let v449 := ((v446 + v447) / (2 : Float))
  let v450 := (Float.cos v449)
  let v452 := (Float.sin v449)
  let v464 := (v83 < (Float.sqrt (((((v30 * v450) + (v34 * v452)) - v29) ^ 2) + ((((v38 * v452) + (v34 * v450)) - hp) ^ 2))))
  let v465 := (if v464 then v449 else v446)
  let v466 := (if v464 then v447 else v449)
  let v468 := ((v465 + v466) / (2 : Float))
  let v469 := (Float.cos v468)
  let v471 := (Float.sin v468)
  let v483 := (v83 < (Float.sqrt (((((v30 * v469) + (v34 * v471)) - v29) ^ 2) + ((((v38 * v471) + (v34 * v469)) - hp) ^ 2))))
  let v484 := (if v483 then v468 else v465)
  let v485 := (if v483 then v466 else v468)
  let v487 := ((v484 + v485) / (2 : Float))
  let v488 := (Float.cos v487)
  let v490 := (Float.sin v487)
  let v502 := (v83 < (Float.sqrt (((((v30 * v488) + (v34 * v490)) - v29) ^ 2) + ((((v38 * v490) + (v34 * v488)) - hp) ^ 2))))
  let v503 := (if v502 then v487 else v484)
  let v504 := (if v502 then v485 else v487)
  let v506 := ((v503 + v504) / (2 : Float))
  let v507 := (Float.cos v506)
  let v509 := (Float.sin v506)
  let v521 := (v83 < (Float.sqrt (((((v30 * v507) + (v34 * v509)) - v29) ^ 2) + ((((v38 * v509) + (v34 * v507)) - hp) ^ 2))))
  let v522 := (if v521 then v506 else v503)
  let v523 := (if v521 then v504 else v506)
  let v525 := ((v522 + v523) / (2 : Float))
  let v526 := (Float.cos v525)
  let v528 := (Float.sin v525)
  let v540 := (v83 < (Float.sqrt (((((v30 * v526) + (v34 * v528)) - v29) ^ 2) + ((((v38 * v528) + (v34 * v526)) - hp) ^ 2))))
  let v545 := (if (v47 <= v79) then (0 : Float) else (((if v540 then v525 else v522) + (if v540 then v523 else v525)) / (2 : Float)))
  let v546 := (W * rcm)
  let v547 := (Float.cos v545)
  let v549 := (Float.sin v545)
  let v551 := ((v30 * v547) + (v34 * v549))
  let v554 := ((v38 * v549) + (v34 * v547))
  let v569 := ((t < v545) && (!(v546 <= (Tmax * (((v29 * v554) - (hp * v551)) / (Float.sqrt (((v551 - v29) ^ 2) + ((v554 - hp) ^ 2))))))))
  let v570 := (if v569 then t else v545)
  let v581 := (Float.cos v570)
  let v583 := (Float.sin v570)
  let v585 := ((v30 * v581) + (v34 * v583))
  let v588 := ((v38 * v583) + (v34 * v581))
  #[(az + (((omegam * rw) / R) * dt)), v570, (if v81 then (v79 - v47) else (0 : Float)), (if v569 then v75 else v83), v28, (if (v80 || v569) then (1 : Float) else (0 : Float)), (if (feq (if v81 then (v79 - v47) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v546 <= (Tmax * (((v29 * v588) - (hp * v585)) / (Float.sqrt (((v585 - v29) ^ 2) + ((v588 - hp) ^ 2)))))) then (1 : Float) else (0 : Float))]

#eval IO.println ("step " ++ toString ((step 1.257491 1.198942 1.140393 1.081844 1.023296 0.964747 0.906198 0.847649 0.789100 0.730552 0.672003 0.613454 0.554905 0.496356 0.437808 0.379259).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.926299 0.867750 0.809201 0.750652 0.692104 0.633555 0.575006 0.516457 0.457908 0.399360 0.340811 0.282262 0.223713 1.765164 1.706616 1.648067).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.595107 0.536558 0.478009 0.419460 0.360912 0.302363 0.243814 1.785265 1.726716 1.668168 1.609619 1.551070 1.492521 1.433972 1.375424 1.316875).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 0.885187 0.826638 0.768089 0.709540 0.650992 0.592443 0.533894 0.475345 0.416796).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.553995 0.495446 0.436897 0.378348 0.319800 0.261251 0.202702 1.744153 1.685604).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.222803 1.764254 1.705705 1.647156 1.588608 1.530059 1.471510 1.412961 1.354412).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.699035 0.640486 0.581937 0.523388 0.464840 0.406291 0.347742 0.289193 0.230644 1.772096))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.367843 0.309294 0.250745 1.792196 1.733648 1.675099 1.616550 1.558001 1.499452 1.440904))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.636651 1.578102 1.519553 1.461004 1.402456 1.343907 1.285358 1.226809 1.168260 1.109712))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 0.512883 0.454334).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.781691 1.723142).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.450499 1.391950).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.326731 0.268182 0.209633))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.595539 1.536990 1.478441))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.264347 1.205798 1.147249))

def sunInDish (az : Float) (t : Float) (elSun : Float) (azSun : Float) : Array Float :=
  let v4 := (Float.sin t)
  let v5 := (Float.cos az)
  let v6 := (v4 * v5)
  let v7 := (Float.sin az)
  let v8 := (v4 * v7)
  let v9 := (Float.cos t)
  let v10 := (v9 * v5)
  let v11 := (v9 * v7)
  let v12 := (-v4)
  let v22 := (Float.cos elSun)
  let v24 := (v22 * (Float.cos azSun))
  let v26 := (v22 * (Float.sin azSun))
  let v27 := (Float.sin elSun)
  #[(((((v11 * v9) - (v12 * v8)) * v24) + (((v12 * v6) - (v10 * v9)) * v26)) + (((v10 * v8) - (v11 * v6)) * v27)), (((v10 * v24) + (v11 * v26)) + (v12 * v27)), (((v6 * v24) + (v8 * v26)) + (v9 * v27))]

#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.740579 1.682030 1.623481 1.564932).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.409387 1.350838 1.292289 1.233740).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.078195 1.019646 0.961097 0.902548).map Float.toBits))

def check_sunInDish_equivariant (az : Float) (t : Float) (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (az + delta)
  let v7 := (Float.cos v6)
  let v8 := (v5 * v7)
  let v9 := (Float.sin v6)
  let v10 := (v5 * v9)
  let v11 := (Float.cos t)
  let v12 := (v11 * v7)
  let v13 := (v11 * v9)
  let v14 := (-v5)
  let v24 := (Float.cos elSun)
  let v25 := (azSun + delta)
  let v27 := (v24 * (Float.cos v25))
  let v29 := (v24 * (Float.sin v25))
  let v30 := (Float.sin elSun)
  let v39 := (v14 * v30)
  let v44 := (v11 * v30)
  let v46 := (Float.cos az)
  let v47 := (v5 * v46)
  let v48 := (Float.sin az)
  let v49 := (v5 * v48)
  let v50 := (v11 * v46)
  let v51 := (v11 * v48)
  let v62 := (v24 * (Float.cos azSun))
  let v64 := (v24 * (Float.sin azSun))
  ((feq (((((v13 * v11) - (v14 * v10)) * v27) + (((v14 * v8) - (v12 * v11)) * v29)) + (((v12 * v10) - (v13 * v8)) * v30)) (((((v51 * v11) - (v14 * v49)) * v62) + (((v14 * v47) - (v50 * v11)) * v64)) + (((v50 * v49) - (v51 * v47)) * v30))) && ((feq (((v12 * v27) + (v13 * v29)) + v39) (((v50 * v62) + (v51 * v64)) + v39)) && (feq (((v8 * v27) + (v10 * v29)) + v44) (((v47 * v62) + (v49 * v64)) + v44))))

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.554427 1.495878 1.437329 1.378780 1.320232))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.223235 1.164686 1.106137 1.047588 0.989040))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.892043 0.833494 0.774945 0.716396 0.657848))

def sunRate  : Float :=
  (0.000073 : Float)

#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)

def sunReachableS (tDead : Float) (elSun : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))

#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.182123 1.123574).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.850931 0.792382).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.519739 0.461190).toBits)

def check_sunReachableS_mem (tDead : Float) (elSun : Float) : Bool :=
  let v10 := (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))
  (((0 : Float) <= v10) && (v10 <= (1 : Float)))

#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.995971 0.937422))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.664779 0.606230))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.333587 0.275038))

def check_sunReachableS_slope (tDead : Float) (e1 : Float) (e2 : Float) : Bool :=
  let v6 := (((3.141592653589793 : Float) / (2 : Float)) - tDead)
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((e1 - v6) / (0.01 : Float))))) - (1.0 / (1.0 + Float.exp (-((e2 - v6) / (0.01 : Float))))))) <= ((Float.abs (e1 - e2)) / ((4 : Float) * (0.01 : Float))))

#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.809819 0.751270 0.692721))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.478627 0.420078 0.361529))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.747435 1.688886 1.630337))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.623667 0.565118 0.506569 0.448020 0.389472).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.292475 0.233926 1.775377 1.716828 1.658280).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.561283 1.502734 1.444185 1.385636 1.327088).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.437515 0.378966 0.320417 0.261868 0.203320))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.706323 1.647774 1.589225 1.530676 1.472128))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.375131 1.316582 1.258033 1.199484 1.140936))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.251363).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.520171).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.188979).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.665211))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.334019))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.002827))

def swingOfLength (ym : Float) (hp : Float) (a : Float) (ze : Float) (tDead : Float) (L : Float) : Float :=
  let v9 := (((0 : Float) + tDead) / (2 : Float))
  let v10 := (-ym)
  let v11 := (-a)
  let v12 := (Float.cos v9)
  let v14 := (-ze)
  let v15 := (Float.sin v9)
  let v18 := (-v11)
  let v28 := (L < (Float.sqrt (((((v11 * v12) + (v14 * v15)) - v10) ^ 2) + ((((v18 * v15) + (v14 * v12)) - hp) ^ 2))))
  let v29 := (if v28 then v9 else (0 : Float))
  let v30 := (if v28 then tDead else v9)
  let v32 := ((v29 + v30) / (2 : Float))
  let v33 := (Float.cos v32)
  let v35 := (Float.sin v32)
  let v47 := (L < (Float.sqrt (((((v11 * v33) + (v14 * v35)) - v10) ^ 2) + ((((v18 * v35) + (v14 * v33)) - hp) ^ 2))))
  let v48 := (if v47 then v32 else v29)
  let v49 := (if v47 then v30 else v32)
  let v51 := ((v48 + v49) / (2 : Float))
  let v52 := (Float.cos v51)
  let v54 := (Float.sin v51)
  let v66 := (L < (Float.sqrt (((((v11 * v52) + (v14 * v54)) - v10) ^ 2) + ((((v18 * v54) + (v14 * v52)) - hp) ^ 2))))
  let v67 := (if v66 then v51 else v48)
  let v68 := (if v66 then v49 else v51)
  let v70 := ((v67 + v68) / (2 : Float))
  let v71 := (Float.cos v70)
  let v73 := (Float.sin v70)
  let v85 := (L < (Float.sqrt (((((v11 * v71) + (v14 * v73)) - v10) ^ 2) + ((((v18 * v73) + (v14 * v71)) - hp) ^ 2))))
  let v86 := (if v85 then v70 else v67)
  let v87 := (if v85 then v68 else v70)
  let v89 := ((v86 + v87) / (2 : Float))
  let v90 := (Float.cos v89)
  let v92 := (Float.sin v89)
  let v104 := (L < (Float.sqrt (((((v11 * v90) + (v14 * v92)) - v10) ^ 2) + ((((v18 * v92) + (v14 * v90)) - hp) ^ 2))))
  let v105 := (if v104 then v89 else v86)
  let v106 := (if v104 then v87 else v89)
  let v108 := ((v105 + v106) / (2 : Float))
  let v109 := (Float.cos v108)
  let v111 := (Float.sin v108)
  let v123 := (L < (Float.sqrt (((((v11 * v109) + (v14 * v111)) - v10) ^ 2) + ((((v18 * v111) + (v14 * v109)) - hp) ^ 2))))
  let v124 := (if v123 then v108 else v105)
  let v125 := (if v123 then v106 else v108)
  let v127 := ((v124 + v125) / (2 : Float))
  let v128 := (Float.cos v127)
  let v130 := (Float.sin v127)
  let v142 := (L < (Float.sqrt (((((v11 * v128) + (v14 * v130)) - v10) ^ 2) + ((((v18 * v130) + (v14 * v128)) - hp) ^ 2))))
  let v143 := (if v142 then v127 else v124)
  let v144 := (if v142 then v125 else v127)
  let v146 := ((v143 + v144) / (2 : Float))
  let v147 := (Float.cos v146)
  let v149 := (Float.sin v146)
  let v161 := (L < (Float.sqrt (((((v11 * v147) + (v14 * v149)) - v10) ^ 2) + ((((v18 * v149) + (v14 * v147)) - hp) ^ 2))))
  let v162 := (if v161 then v146 else v143)
  let v163 := (if v161 then v144 else v146)
  let v165 := ((v162 + v163) / (2 : Float))
  let v166 := (Float.cos v165)
  let v168 := (Float.sin v165)
  let v180 := (L < (Float.sqrt (((((v11 * v166) + (v14 * v168)) - v10) ^ 2) + ((((v18 * v168) + (v14 * v166)) - hp) ^ 2))))
  let v181 := (if v180 then v165 else v162)
  let v182 := (if v180 then v163 else v165)
  let v184 := ((v181 + v182) / (2 : Float))
  let v185 := (Float.cos v184)
  let v187 := (Float.sin v184)
  let v199 := (L < (Float.sqrt (((((v11 * v185) + (v14 * v187)) - v10) ^ 2) + ((((v18 * v187) + (v14 * v185)) - hp) ^ 2))))
  let v200 := (if v199 then v184 else v181)
  let v201 := (if v199 then v182 else v184)
  let v203 := ((v200 + v201) / (2 : Float))
  let v204 := (Float.cos v203)
  let v206 := (Float.sin v203)
  let v218 := (L < (Float.sqrt (((((v11 * v204) + (v14 * v206)) - v10) ^ 2) + ((((v18 * v206) + (v14 * v204)) - hp) ^ 2))))
  let v219 := (if v218 then v203 else v200)
  let v220 := (if v218 then v201 else v203)
  let v222 := ((v219 + v220) / (2 : Float))
  let v223 := (Float.cos v222)
  let v225 := (Float.sin v222)
  let v237 := (L < (Float.sqrt (((((v11 * v223) + (v14 * v225)) - v10) ^ 2) + ((((v18 * v225) + (v14 * v223)) - hp) ^ 2))))
  let v238 := (if v237 then v222 else v219)
  let v239 := (if v237 then v220 else v222)
  let v241 := ((v238 + v239) / (2 : Float))
  let v242 := (Float.cos v241)
  let v244 := (Float.sin v241)
  let v256 := (L < (Float.sqrt (((((v11 * v242) + (v14 * v244)) - v10) ^ 2) + ((((v18 * v244) + (v14 * v242)) - hp) ^ 2))))
  let v257 := (if v256 then v241 else v238)
  let v258 := (if v256 then v239 else v241)
  let v260 := ((v257 + v258) / (2 : Float))
  let v261 := (Float.cos v260)
  let v263 := (Float.sin v260)
  let v275 := (L < (Float.sqrt (((((v11 * v261) + (v14 * v263)) - v10) ^ 2) + ((((v18 * v263) + (v14 * v261)) - hp) ^ 2))))
  let v276 := (if v275 then v260 else v257)
  let v277 := (if v275 then v258 else v260)
  let v279 := ((v276 + v277) / (2 : Float))
  let v280 := (Float.cos v279)
  let v282 := (Float.sin v279)
  let v294 := (L < (Float.sqrt (((((v11 * v280) + (v14 * v282)) - v10) ^ 2) + ((((v18 * v282) + (v14 * v280)) - hp) ^ 2))))
  let v295 := (if v294 then v279 else v276)
  let v296 := (if v294 then v277 else v279)
  let v298 := ((v295 + v296) / (2 : Float))
  let v299 := (Float.cos v298)
  let v301 := (Float.sin v298)
  let v313 := (L < (Float.sqrt (((((v11 * v299) + (v14 * v301)) - v10) ^ 2) + ((((v18 * v301) + (v14 * v299)) - hp) ^ 2))))
  let v314 := (if v313 then v298 else v295)
  let v315 := (if v313 then v296 else v298)
  let v317 := ((v314 + v315) / (2 : Float))
  let v318 := (Float.cos v317)
  let v320 := (Float.sin v317)
  let v332 := (L < (Float.sqrt (((((v11 * v318) + (v14 * v320)) - v10) ^ 2) + ((((v18 * v320) + (v14 * v318)) - hp) ^ 2))))
  let v333 := (if v332 then v317 else v314)
  let v334 := (if v332 then v315 else v317)
  let v336 := ((v333 + v334) / (2 : Float))
  let v337 := (Float.cos v336)
  let v339 := (Float.sin v336)
  let v351 := (L < (Float.sqrt (((((v11 * v337) + (v14 * v339)) - v10) ^ 2) + ((((v18 * v339) + (v14 * v337)) - hp) ^ 2))))
  let v352 := (if v351 then v336 else v333)
  let v353 := (if v351 then v334 else v336)
  let v355 := ((v352 + v353) / (2 : Float))
  let v356 := (Float.cos v355)
  let v358 := (Float.sin v355)
  let v370 := (L < (Float.sqrt (((((v11 * v356) + (v14 * v358)) - v10) ^ 2) + ((((v18 * v358) + (v14 * v356)) - hp) ^ 2))))
  let v371 := (if v370 then v355 else v352)
  let v372 := (if v370 then v353 else v355)
  let v374 := ((v371 + v372) / (2 : Float))
  let v375 := (Float.cos v374)
  let v377 := (Float.sin v374)
  let v389 := (L < (Float.sqrt (((((v11 * v375) + (v14 * v377)) - v10) ^ 2) + ((((v18 * v377) + (v14 * v375)) - hp) ^ 2))))
  let v390 := (if v389 then v374 else v371)
  let v391 := (if v389 then v372 else v374)
  let v393 := ((v390 + v391) / (2 : Float))
  let v394 := (Float.cos v393)
  let v396 := (Float.sin v393)
  let v408 := (L < (Float.sqrt (((((v11 * v394) + (v14 * v396)) - v10) ^ 2) + ((((v18 * v396) + (v14 * v394)) - hp) ^ 2))))
  let v409 := (if v408 then v393 else v390)
  let v410 := (if v408 then v391 else v393)
  let v412 := ((v409 + v410) / (2 : Float))
  let v413 := (Float.cos v412)
  let v415 := (Float.sin v412)
  let v427 := (L < (Float.sqrt (((((v11 * v413) + (v14 * v415)) - v10) ^ 2) + ((((v18 * v415) + (v14 * v413)) - hp) ^ 2))))
  let v428 := (if v427 then v412 else v409)
  let v429 := (if v427 then v410 else v412)
  let v431 := ((v428 + v429) / (2 : Float))
  let v432 := (Float.cos v431)
  let v434 := (Float.sin v431)
  let v446 := (L < (Float.sqrt (((((v11 * v432) + (v14 * v434)) - v10) ^ 2) + ((((v18 * v434) + (v14 * v432)) - hp) ^ 2))))
  let v447 := (if v446 then v431 else v428)
  let v448 := (if v446 then v429 else v431)
  let v450 := ((v447 + v448) / (2 : Float))
  let v451 := (Float.cos v450)
  let v453 := (Float.sin v450)
  let v465 := (L < (Float.sqrt (((((v11 * v451) + (v14 * v453)) - v10) ^ 2) + ((((v18 * v453) + (v14 * v451)) - hp) ^ 2))))
  (((if v465 then v450 else v447) + (if v465 then v448 else v450)) / (2 : Float))

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.479059 1.420510 1.361961 1.303412 1.244864 1.186315).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.147867 1.089318 1.030769 0.972220 0.913672 0.855123).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.816675 0.758126 0.699577 0.641028 0.582480 0.523931).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.292907 1.234358).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.961715 0.903166).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.630523 0.571974).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.106755 1.048206 0.989657 0.931108).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.775563 0.717014 0.658465 0.599916).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.444371 0.385822 0.327273 0.268724).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.920603 0.862054 0.803505 0.744956).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.589411 0.530862 0.472313 0.413764).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.258219 1.799670 1.741121 1.682572).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.734451 0.675902 0.617353 0.558804))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.403259 0.344710 0.286161 0.227612))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.672067 1.613518 1.554969 1.496420))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.548299 0.489750 0.431201 0.372652 0.314104))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.217107 1.758558 1.700009 1.641460 1.582912))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.485915 1.427366 1.368817 1.310268 1.251720))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 0.362147 0.303598 0.245049).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.630955 1.572406 1.513857).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.299763 1.241214 1.182665).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tanh_abs_lt_one (x : Float) : Bool :=
  ((Float.abs (Float.tanh x)) < (1 : Float))

#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.589843))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.258651))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.927459))

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.403691 1.345142 1.286593 1.228044 1.169496))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.072499 1.013950 0.955401 0.896852 0.838304))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.741307 0.682758 0.624209 0.565660 0.507112))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 1.217539 1.158990 1.100441 1.041892 0.983344).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 0.886347 0.827798 0.769249 0.710700 0.652152).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 0.555155 0.496606 0.438057 0.379508 0.320960).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.031387).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.700195).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.369003).toBits)

def traceConic (c : Float) (k : Float) (p : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v10 := ((1 : Float) + k)
  let v28 := ((((2 : Float) * c) * (((O_0 * d_0) + (O_1 * d_1)) + ((v10 * O_2) * d_2))) - ((2 : Float) * d_2))
  let v37 := ((c * (((O_0 ^ 2) + (O_1 ^ 2)) + (v10 * (O_2 ^ 2)))) - ((2 : Float) * O_2))
  let v49 := (((2 : Float) * v37) / ((-v28) - (Float.sqrt (max ((v28 ^ 2) - (((4 : Float) * (c * (((d_0 ^ 2) + (d_1 ^ 2)) + (v10 * (d_2 ^ 2))))) * v37)) (0 : Float)))))
  let v51 := (O_0 + (v49 * d_0))
  let v53 := (O_1 + (v49 * d_1))
  let v55 := (O_2 + (v49 * d_2))
  let v61 := (Float.sqrt (max ((v51 ^ 2) + (v53 ^ 2)) (0.000000000000000001 : Float)))
  let v65 := (v61 ^ 2)
  let v67 := ((1 : Float) - ((v10 * (c ^ 2)) * v65))
  let v70 := ((c * v61) / (Float.sqrt (max v67 (0.000000000000000001 : Float))))
  let v73 := (Float.sqrt ((1 : Float) + (v70 ^ 2)))
  let v74 := (-v70)
  let v77 := (((v74 * v51) / v61) / v73)
  let v80 := (((v74 * v53) / v61) / v73)
  let v81 := ((1 : Float) / v73)
  let v87 := ((2 : Float) * (((d_0 * v77) + (d_1 * v80)) + (d_2 * v81)))
  let v95 := ((p - v55) / (d_2 - (v87 * v81)))
  #[v51, v53, v55, (d_0 - (v87 * v77)), (d_1 - (v87 * v80)), (d_2 - (v87 * v81)), (v51 + (v95 * (d_0 - (v87 * v77)))), (v53 + (v95 * (d_1 - (v87 * v80)))), (((c * v65) / ((1 : Float) + (Float.sqrt (max v67 (0 : Float))))) - v55)]

#eval IO.println ("traceConic " ++ toString ((traceConic 0.845235 0.786686 0.728137 0.669588 0.611040 0.552491 0.493942 0.435393 0.376844).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.514043 0.455494 0.396945 0.338396 0.279848 0.221299 1.762750 1.704201 1.645652).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 1.782851 1.724302 1.665753 1.607204 1.548656 1.490107 1.431558 1.373009 1.314460).map Float.toBits))

def traceFacet (R : Float) (p : Float) (cx : Float) (cy : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v18 := (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((cx ^ 2) + (cy ^ 2))) ^ 2))))
  let v20 := ((-cx) / R)
  let v22 := ((-cy) / R)
  let v24 := ((R - v18) / R)
  let v37 := (((d_0 * v20) + (d_1 * v22)) + (d_2 * v24))
  let v38 := (((((cx - O_0) * v20) + ((cy - O_1) * v22)) + ((v18 - O_2) * v24)) / v37)
  let v46 := ((2 : Float) * v37)
  let v52 := (d_2 - (v46 * v24))
  let v54 := ((p - (O_2 + (v38 * d_2))) / v52)
  #[((O_0 + (v38 * d_0)) + (v54 * (d_0 - (v46 * v20)))), ((O_1 + (v38 * d_1)) + (v54 * (d_1 - (v46 * v22)))), (Float.sqrt ((((O_0 + (v38 * d_0)) + (v54 * (d_0 - (v46 * v20)))) ^ 2) + (((O_1 + (v38 * d_1)) + (v54 * (d_1 - (v46 * v22)))) ^ 2))), (O_2 + (v38 * d_2)), (if ((0 : Float) < v52) then (1 : Float) else (0 : Float))]

#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.659083 0.600534 0.541985 0.483436 0.424888 0.366339 0.307790 0.249241 1.790692 1.732144).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.327891 0.269342 0.210793 1.752244 1.693696 1.635147 1.576598 1.518049 1.459500 1.400952).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.596699 1.538150 1.479601 1.421052 1.362504 1.303955 1.245406 1.186857 1.128308 1.069760).map Float.toBits))

def traceParams  : Array Float :=
  #[(2 : Float), (1 : Float), (0.8 : Float), (0.05 : Float), (0.06 : Float)]

#eval IO.println ("traceParams " ++ toString ((traceParams).map Float.toBits))
#eval IO.println ("traceParams " ++ toString ((traceParams).map Float.toBits))
#eval IO.println ("traceParams " ++ toString ((traceParams).map Float.toBits))

def traceRay (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (cx : Float) (cy : Float) (ux : Float) (uy : Float) (dx : Float) (dy : Float) (dz : Float) : Array Float :=
  let v18 := (w / (2 : Float))
  let v24 := (((Float.abs cx) <= a) && (((Float.abs cy) <= a) && (((Float.abs ux) <= v18) && ((Float.abs uy) <= v18))))
  let v25 := (cx + ux)
  let v26 := (cy + uy)
  let v27 := ((2 : Float) * f)
  let v36 := (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((cx ^ 2) + (cy ^ 2))) ^ 2))))
  let v38 := ((-cx) / R)
  let v40 := ((-cy) / R)
  let v42 := ((R - v36) / R)
  let v55 := (((dx * v38) + (dy * v40)) + (dz * v42))
  let v56 := (((((cx - v25) * v38) + ((cy - v26) * v40)) + ((v36 - v27) * v42)) / v55)
  let v63 := ((2 : Float) * v55)
  let v69 := (dz - (v63 * v42))
  let v71 := ((f - (v27 + (v56 * dz))) / v69)
  let v86 := (((Float.sqrt ((((v25 + (v56 * dx)) + (v71 * (dx - (v63 * v38)))) ^ 2) + (((v26 + (v56 * dy)) + (v71 * (dy - (v63 * v40)))) ^ 2))) <= rc) && ((0 : Float) < (if ((0 : Float) < v69) then (1 : Float) else (0 : Float))))
  #[((v25 + (v56 * dx)) + (v71 * (dx - (v63 * v38)))), ((v26 + (v56 * dy)) + (v71 * (dy - (v63 * v40)))), (Float.sqrt ((((v25 + (v56 * dx)) + (v71 * (dx - (v63 * v38)))) ^ 2) + (((v26 + (v56 * dy)) + (v71 * (dy - (v63 * v40)))) ^ 2))), (if (v24 && v86) then (1 : Float) else (0 : Float)), (if (!v24) then (0 : Float) else (if v86 then (2 : Float) else (1 : Float))), (v27 + (v56 * dz)), (Float.sqrt ((cx ^ 2) + (cy ^ 2))), (if ((0 : Float) < v69) then (1 : Float) else (0 : Float))]

#eval IO.println ("traceRay " ++ toString ((traceRay 0.286779 0.228230 1.769681 1.711132 1.652584 1.594035 1.535486 1.476937 1.418388 1.359840 1.301291 1.242742).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.555587 1.497038 1.438489 1.379940 1.321392 1.262843 1.204294 1.145745 1.087196 1.028648 0.970099 0.911550).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.224395 1.165846 1.107297 1.048748 0.990200 0.931651 0.873102 0.814553 0.756004 0.697456 0.638907 0.580358).map Float.toBits))

def traceRayErr (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (cx : Float) (cy : Float) (ux : Float) (uy : Float) (dx : Float) (dy : Float) (dz : Float) (sigmaslope : Float) (sigmaspec : Float) (e1 : Float) (e2 : Float) (s1 : Float) (s2 : Float) : Array Float :=
  let v24 := (w / (2 : Float))
  let v30 := (((Float.abs cx) <= a) && (((Float.abs cy) <= a) && (((Float.abs ux) <= v24) && ((Float.abs uy) <= v24))))
  let v31 := (cx + ux)
  let v32 := (cy + uy)
  let v33 := ((2 : Float) * f)
  let v42 := (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((cx ^ 2) + (cy ^ 2))) ^ 2))))
  let v44 := ((-cx) / R)
  let v46 := ((-cy) / R)
  let v48 := ((R - v42) / R)
  let v50 := (v44 + (sigmaslope * e1))
  let v52 := (v46 + (sigmaslope * e2))
  let v58 := (Float.sqrt (((v50 ^ 2) + (v52 ^ 2)) + (v48 ^ 2)))
  let v59 := (v50 / v58)
  let v60 := (v52 / v58)
  let v61 := (v48 / v58)
  let v75 := (((((cx - v31) * v44) + ((cy - v32) * v46)) + ((v42 - v33) * v48)) / (((dx * v44) + (dy * v46)) + (dz * v48)))
  let v87 := ((2 : Float) * (((dx * v59) + (dy * v60)) + (dz * v61)))
  let v93 := (dz - (v87 * v61))
  let v95 := ((dx - (v87 * v59)) + (sigmaspec * s1))
  let v97 := ((dy - (v87 * v60)) + (sigmaspec * s2))
  let v103 := (Float.sqrt (((v95 ^ 2) + (v97 ^ 2)) + (v93 ^ 2)))
  let v106 := (v93 / v103)
  let v108 := ((f - (v33 + (v75 * dz))) / v106)
  let v119 := ((0 : Float) < v106)
  let v120 := (((Float.sqrt ((((v31 + (v75 * dx)) + (v108 * (v95 / v103))) ^ 2) + (((v32 + (v75 * dy)) + (v108 * (v97 / v103))) ^ 2))) <= rc) && v119)
  #[((v31 + (v75 * dx)) + (v108 * (v95 / v103))), ((v32 + (v75 * dy)) + (v108 * (v97 / v103))), (Float.sqrt ((((v31 + (v75 * dx)) + (v108 * (v95 / v103))) ^ 2) + (((v32 + (v75 * dy)) + (v108 * (v97 / v103))) ^ 2))), (if (v30 && v120) then (1 : Float) else (0 : Float)), (if (!v30) then (0 : Float) else (if v120 then (2 : Float) else (1 : Float))), (v33 + (v75 * dz)), (Float.sqrt ((cx ^ 2) + (cy ^ 2))), (if v119 then (1 : Float) else (0 : Float))]

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.700627 1.642078 1.583529 1.524980 1.466432 1.407883 1.349334 1.290785 1.232236 1.173688 1.115139 1.056590 0.998041 0.939492 0.880944 0.822395 0.763846 0.705297).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.369435 1.310886 1.252337 1.193788 1.135240 1.076691 1.018142 0.959593 0.901044 0.842496 0.783947 0.725398 0.666849 0.608300 0.549752 0.491203 0.432654 0.374105).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.038243 0.979694 0.921145 0.862596 0.804048 0.745499 0.686950 0.628401 0.569852 0.511304 0.452755 0.394206 0.335657 0.277108 0.218560 1.760011 1.701462 1.642913).map Float.toBits))

def traceRayK (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (cx : Float) (cy : Float) (ux : Float) (uy : Float) (dx : Float) (dy : Float) (dz : Float) : Array Float :=
  let v19 := (w / (2 : Float))
  let v25 := (((Float.abs cx) <= a) && (((Float.abs cy) <= a) && (((Float.abs ux) <= v19) && ((Float.abs uy) <= v19))))
  let v26 := (cx + ux)
  let v27 := (cy + uy)
  let v28 := ((2 : Float) * f)
  let v30 := ((1 : Float) / R)
  let v36 := (Float.sqrt (max ((cx ^ 2) + (cy ^ 2)) (0.000000000000000001 : Float)))
  let v37 := (v36 ^ 2)
  let v43 := ((1 : Float) - ((((1 : Float) + k) * (v30 ^ 2)) * v37))
  let v52 := ((v30 * v36) / (Float.sqrt (max v43 (0.000000000000000001 : Float))))
  let v55 := (Float.sqrt ((1 : Float) + (v52 ^ 2)))
  let v56 := (-v52)
  let v59 := (((v56 * cx) / v36) / v55)
  let v62 := (((v56 * cy) / v36) / v55)
  let v63 := ((1 : Float) / v55)
  let v76 := (((dx * v59) + (dy * v62)) + (dz * v63))
  let v77 := (((((cx - v26) * v59) + ((cy - v27) * v62)) + ((((v30 * v37) / ((1 : Float) + (Float.sqrt (max v43 (0 : Float))))) - v28) * v63)) / v76)
  let v84 := ((2 : Float) * v76)
  let v90 := (dz - (v84 * v63))
  let v92 := ((f - (v28 + (v77 * dz))) / v90)
  let v102 := ((0 : Float) < v90)
  let v103 := (((Float.sqrt ((((v26 + (v77 * dx)) + (v92 * (dx - (v84 * v59)))) ^ 2) + (((v27 + (v77 * dy)) + (v92 * (dy - (v84 * v62)))) ^ 2))) <= rc) && v102)
  #[((v26 + (v77 * dx)) + (v92 * (dx - (v84 * v59)))), ((v27 + (v77 * dy)) + (v92 * (dy - (v84 * v62)))), (Float.sqrt ((((v26 + (v77 * dx)) + (v92 * (dx - (v84 * v59)))) ^ 2) + (((v27 + (v77 * dy)) + (v92 * (dy - (v84 * v62)))) ^ 2))), (if (v25 && v103) then (1 : Float) else (0 : Float)), (if (!v25) then (0 : Float) else (if v103 then (2 : Float) else (1 : Float))), (v28 + (v77 * dz)), v36, (if v102 then (1 : Float) else (0 : Float))]

#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.514475 1.455926 1.397377 1.338828 1.280280 1.221731 1.163182 1.104633 1.046084 0.987536 0.928987 0.870438 0.811889).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.183283 1.124734 1.066185 1.007636 0.949088 0.890539 0.831990 0.773441 0.714892 0.656344 0.597795 0.539246 0.480697).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.852091 0.793542 0.734993 0.676444 0.617896 0.559347 0.500798 0.442249 0.383700 0.325152 0.266603 0.208054 1.749505).map Float.toBits))

def traceRayKErr (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (cx : Float) (cy : Float) (ux : Float) (uy : Float) (dx : Float) (dy : Float) (dz : Float) (e1 : Float) (e2 : Float) (s1 : Float) (s2 : Float) : Array Float :=
  let v25 := (w / (2 : Float))
  let v31 := (((Float.abs cx) <= a) && (((Float.abs cy) <= a) && (((Float.abs ux) <= v25) && ((Float.abs uy) <= v25))))
  let v32 := (cx + ux)
  let v33 := (cy + uy)
  let v34 := ((2 : Float) * f)
  let v36 := ((1 : Float) / R)
  let v42 := (Float.sqrt (max ((cx ^ 2) + (cy ^ 2)) (0.000000000000000001 : Float)))
  let v43 := (v42 ^ 2)
  let v49 := ((1 : Float) - ((((1 : Float) + k) * (v36 ^ 2)) * v43))
  let v58 := ((v36 * v42) / (Float.sqrt (max v49 (0.000000000000000001 : Float))))
  let v61 := (Float.sqrt ((1 : Float) + (v58 ^ 2)))
  let v62 := (-v58)
  let v65 := (((v62 * cx) / v42) / v61)
  let v68 := (((v62 * cy) / v42) / v61)
  let v69 := ((1 : Float) / v61)
  let v71 := (v65 + (sigmaslope * e1))
  let v73 := (v68 + (sigmaslope * e2))
  let v79 := (Float.sqrt (((v71 ^ 2) + (v73 ^ 2)) + (v69 ^ 2)))
  let v80 := (v71 / v79)
  let v81 := (v73 / v79)
  let v82 := (v69 / v79)
  let v96 := (((((cx - v32) * v65) + ((cy - v33) * v68)) + ((((v36 * v43) / ((1 : Float) + (Float.sqrt (max v49 (0 : Float))))) - v34) * v69)) / (((dx * v65) + (dy * v68)) + (dz * v69)))
  let v108 := ((2 : Float) * (((dx * v80) + (dy * v81)) + (dz * v82)))
  let v114 := (dz - (v108 * v82))
  let v116 := ((dx - (v108 * v80)) + (sigmaspec * s1))
  let v118 := ((dy - (v108 * v81)) + (sigmaspec * s2))
  let v124 := (Float.sqrt (((v116 ^ 2) + (v118 ^ 2)) + (v114 ^ 2)))
  let v127 := (v114 / v124)
  let v129 := ((f - (v34 + (v96 * dz))) / v127)
  let v139 := ((0 : Float) < v127)
  let v140 := (((Float.sqrt ((((v32 + (v96 * dx)) + (v129 * (v116 / v124))) ^ 2) + (((v33 + (v96 * dy)) + (v129 * (v118 / v124))) ^ 2))) <= rc) && v139)
  #[((v32 + (v96 * dx)) + (v129 * (v116 / v124))), ((v33 + (v96 * dy)) + (v129 * (v118 / v124))), (Float.sqrt ((((v32 + (v96 * dx)) + (v129 * (v116 / v124))) ^ 2) + (((v33 + (v96 * dy)) + (v129 * (v118 / v124))) ^ 2))), (if (v31 && v140) then (1 : Float) else (0 : Float)), (if (!v31) then (0 : Float) else (if v140 then (2 : Float) else (1 : Float))), (v34 + (v96 * dz)), v42, (if v139 then (1 : Float) else (0 : Float))]

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.328323 1.269774 1.211225 1.152676 1.094128 1.035579 0.977030 0.918481 0.859932 0.801384 0.742835 0.684286 0.625737 0.567188 0.508640 0.450091 0.391542 0.332993 0.274444).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.997131 0.938582 0.880033 0.821484 0.762936 0.704387 0.645838 0.587289 0.528740 0.470192 0.411643 0.353094 0.294545 0.235996 1.777448 1.718899 1.660350 1.601801 1.543252).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.665939 0.607390 0.548841 0.490292 0.431744 0.373195 0.314646 0.256097 1.797548 1.739000 1.680451 1.621902 1.563353 1.504804 1.446256 1.387707 1.329158 1.270609 1.212060).map Float.toBits))

def traceSphere (R : Float) (p : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v8 := (O_2 - R)
  let v13 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v8))
  let v25 := ((-v13) + (Float.sqrt ((v13 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v8 ^ 2)) - (R ^ 2)))))
  let v27 := (O_0 + (v25 * d_0))
  let v29 := (O_1 + (v25 * d_1))
  let v31 := (O_2 + (v25 * d_2))
  let v33 := ((-v27) / R)
  let v35 := ((-v29) / R)
  let v37 := ((R - v31) / R)
  let v44 := ((2 : Float) * (((d_0 * v33) + (d_1 * v35)) + (d_2 * v37)))
  let v50 := (d_2 - (v44 * v37))
  let v52 := ((p - v31) / v50)
  #[(v27 + (v52 * (d_0 - (v44 * v33)))), (v29 + (v52 * (d_1 - (v44 * v35)))), (Float.sqrt (((v27 + (v52 * (d_0 - (v44 * v33)))) ^ 2) + ((v29 + (v52 * (d_1 - (v44 * v35)))) ^ 2))), v31, (if ((0 : Float) < v50) then (1 : Float) else (0 : Float))]

#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.142171 1.083622 1.025073 0.966524 0.907976 0.849427 0.790878 0.732329).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.810979 0.752430 0.693881 0.635332 0.576784 0.518235 0.459686 0.401137).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.479787 0.421238 0.362689 0.304140 0.245592 1.787043 1.728494 1.669945).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.956019 0.897470 0.838921))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.624827 0.566278 0.507729))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.293635 0.235086 1.776537))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.769867))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.438675))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.707483))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.583715 0.525166 0.466617 0.408068))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.252523 1.793974 1.735425 1.676876))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 1.521331 1.462782 1.404233 1.345684))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 0.397563 0.339014 0.280465).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.666371 1.607822 1.549273).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.335179 1.276630 1.218081).map Float.toBits))

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 0.211411 1.752862 1.694313 1.635764 1.577216 1.518667).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.480219 1.421670 1.363121 1.304572 1.246024 1.187475).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.149027 1.090478 1.031929 0.973380 0.914832 0.856283).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 1.625259 1.566710 1.508161 1.449612 1.391064 1.332515).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.294067 1.235518 1.176969 1.118420 1.059872 1.001323).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 0.962875 0.904326 0.845777 0.787228 0.728680 0.670131).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 1.439107 1.380558 1.322009 1.263460 1.204912 1.146363 1.087814 1.029265 0.970716 0.912168 0.853619 0.795070 0.736521).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.107915 1.049366 0.990817 0.932268 0.873720 0.815171 0.756622 0.698073 0.639524 0.580976 0.522427 0.463878 0.405329).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 0.776723 0.718174 0.659625 0.601076 0.542528 0.483979 0.425430 0.366881 0.308332 0.249784 1.791235 1.732686 1.674137).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 1.252955 1.194406 1.135857 1.077308 1.018760 0.960211 0.901662 0.843113 0.784564 0.726016 0.667467 0.608918).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.921763 0.863214 0.804665 0.746116 0.687568 0.629019 0.570470 0.511921 0.453372 0.394824 0.336275 0.277726).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.590571 0.532022 0.473473 0.414924 0.356376 0.297827 0.239278 1.780729 1.722180 1.663632 1.605083 1.546534).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.066803 1.008254 0.949705 0.891156 0.832608 0.774059 0.715510 0.656961 0.598412 0.539864 0.481315 0.422766).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.735611 0.677062 0.618513 0.559964 0.501416 0.442867 0.384318 0.325769 0.267220 0.208672 1.750123 1.691574).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.404419 0.345870 0.287321 0.228772 1.770224 1.711675 1.653126 1.594577 1.536028 1.477480 1.418931 1.360382).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 0.880651 0.822102 0.763553 0.705004 0.646456 0.587907 0.529358 0.470809 0.412260 0.353712 0.295163 0.236614).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.549459 0.490910 0.432361 0.373812 0.315264 0.256715 1.798166 1.739617 1.681068 1.622520 1.563971 1.505422).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.218267 1.759718 1.701169 1.642620 1.584072 1.525523 1.466974 1.408425 1.349876 1.291328 1.232779 1.174230).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.694499 0.635950 0.577401 0.518852 0.460304 0.401755 0.343206 0.284657 0.226108 1.767560 1.709011 1.650462).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.363307 0.304758 0.246209 1.787660 1.729112 1.670563 1.612014 1.553465 1.494916 1.436368 1.377819 1.319270).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.632115 1.573566 1.515017 1.456468 1.397920 1.339371 1.280822 1.222273 1.163724 1.105176 1.046627 0.988078).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 0.508347 0.449798 0.391249 0.332700 0.274152 0.215603).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.777155 1.718606 1.660057 1.601508 1.542960 1.484411).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.445963 1.387414 1.328865 1.270316 1.211768 1.153219).map Float.toBits))

def check_wireLeft_at_ym  : Bool :=
  let v14 := ((Float.sqrt (((1.22 : Float) ^ 2) + ((0.34 : Float) ^ 2))) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  (((0.111 : Float) < v14) && (v14 < (0.113 : Float)))

#eval IO.println ("check_wireLeft_at_ym " ++ toString (check_wireLeft_at_ym))
#eval IO.println ("check_wireLeft_at_ym " ++ toString (check_wireLeft_at_ym))
#eval IO.println ("check_wireLeft_at_ym " ++ toString (check_wireLeft_at_ym))

def wireLen (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Float :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (Float.sqrt (((((v6 * v7) + (v9 * v10)) - (-ym)) ^ 2) + (((((-v6) * v10) + (v9 * v7)) - hp) ^ 2)))

#eval IO.println ("wireLen " ++ toString (wireLen 1.736043 1.677494 1.618945 1.560396 1.501848).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.404851 1.346302 1.287753 1.229204 1.170656).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.073659 1.015110 0.956561 0.898012 0.839464).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 1.549891 1.491342 1.432793 1.374244).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.218699 1.160150 1.101601 1.043052).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 0.887507 0.828958 0.770409 0.711860).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.363739 1.305190 1.246641 1.188092 1.129544))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.032547 0.973998 0.915449 0.856900 0.798352))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.701355 0.642806 0.584257 0.525708 0.467160))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.177587 1.119038 1.060489 1.001940))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.846395 0.787846 0.729297 0.670748))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.515203 0.456654 0.398105 0.339556))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.991435 0.932886 0.874337 0.815788))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.660243 0.601694 0.543145 0.484596))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.329051 0.270502 0.211953 1.753404))

def check_wireLever_rest_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v17 := ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (Float.sqrt ((((1.22 : Float) - (0.8 : Float)) ^ 2) + (((0.34 : Float) + v5) ^ 2))))
  (((1.033 : Float) < v17) && (v17 < (1.035 : Float)))

#eval IO.println ("check_wireLever_rest_at_ym " ++ toString (check_wireLever_rest_at_ym))
#eval IO.println ("check_wireLever_rest_at_ym " ++ toString (check_wireLever_rest_at_ym))
#eval IO.println ("check_wireLever_rest_at_ym " ++ toString (check_wireLever_rest_at_ym))

def check_wireLever_sixty_at_ym  : Bool :=
  let v2 := (-(1.22 : Float))
  let v5 := (-(0.8 : Float))
  let v8 := ((3.141592653589793 : Float) / (3 : Float))
  let v9 := (Float.cos v8)
  let v15 := (-((Float.sqrt (3.36 : Float)) - (1 : Float)))
  let v16 := (Float.sin v8)
  let v18 := ((v5 * v9) + (v15 * v16))
  let v22 := (((-v5) * v16) + (v15 * v9))
  let v32 := (((v2 * v22) - ((0.34 : Float) * v18)) / (Float.sqrt (((v18 - v2) ^ 2) + ((v22 - (0.34 : Float)) ^ 2))))
  (((0.37 : Float) < v32) && (v32 < (0.38 : Float)))

#eval IO.println ("check_wireLever_sixty_at_ym " ++ toString (check_wireLever_sixty_at_ym))
#eval IO.println ("check_wireLever_sixty_at_ym " ++ toString (check_wireLever_sixty_at_ym))
#eval IO.println ("check_wireLever_sixty_at_ym " ++ toString (check_wireLever_sixty_at_ym))

def wireTension (W : Float) (rcm : Float) (rw : Float) (t : Float) : Float :=
  (((W * rcm) * (Float.sin t)) / rw)

#eval IO.println ("wireTension " ++ toString (wireTension 0.432979 0.374430 0.315881 0.257332).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.701787 1.643238 1.584689 1.526140).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.370595 1.312046 1.253497 1.194948).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.246827 1.788278 1.729729 1.671180 1.612632 1.554083 1.495534 1.436985))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.515635 1.457086 1.398537 1.339988 1.281440 1.222891 1.164342 1.105793))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.184443 1.125894 1.067345 1.008796 0.950248 0.891699 0.833150 0.774601))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.474523 1.415974 1.357425 1.298876))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.143331 1.084782 1.026233 0.967684))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.812139 0.753590 0.695041 0.636492))

def wrapRad (d : Float) : Float :=
  let v3 := ((2 : Float) * (3.141592653589793 : Float))
  (d - (v3 * (Float.floor ((d + (3.141592653589793 : Float)) / v3))))

#eval IO.println ("wrapRad " ++ toString (wrapRad 1.288371).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.957179).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.625987).toBits)

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.102219 1.043670 0.985121 0.926572 0.868024 0.809475).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.771027 0.712478 0.653929 0.595380 0.536832 0.478283).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.439835 0.381286 0.322737 0.264188 0.205640 1.747091).map Float.toBits))

def xhHashemi  : Float :=
  (((1.84 : Float) / (2 : Float)) - (0.03 : Float))

#eval IO.println ("xhHashemi " ++ toString (xhHashemi).toBits)
#eval IO.println ("xhHashemi " ++ toString (xhHashemi).toBits)
#eval IO.println ("xhHashemi " ++ toString (xhHashemi).toBits)

def yaw  : Array Float :=
  #[(0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float)]

#eval IO.println ("yaw " ++ toString ((yaw).map Float.toBits))
#eval IO.println ("yaw " ++ toString ((yaw).map Float.toBits))
#eval IO.println ("yaw " ++ toString ((yaw).map Float.toBits))

def check_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.543763 0.485214 0.426665))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.212571 1.754022 1.695473))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.481379 1.422830 1.364281))

def ymHashemi  : Float :=
  (1.22 : Float)

#eval IO.println ("ymHashemi " ++ toString (ymHashemi).toBits)
#eval IO.println ("ymHashemi " ++ toString (ymHashemi).toBits)
#eval IO.println ("ymHashemi " ++ toString (ymHashemi).toBits)

def check_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("check_ym_is_standStation " ++ toString (check_ym_is_standStation))
#eval IO.println ("check_ym_is_standStation " ++ toString (check_ym_is_standStation))
#eval IO.println ("check_ym_is_standStation " ++ toString (check_ym_is_standStation))

def zBoltHashemi  : Float :=
  (((0.55 : Float) + (1.30 : Float)) - (0.05 : Float))

#eval IO.println ("zBoltHashemi " ++ toString (zBoltHashemi).toBits)
#eval IO.println ("zBoltHashemi " ++ toString (zBoltHashemi).toBits)
#eval IO.println ("zBoltHashemi " ++ toString (zBoltHashemi).toBits)

def zeHashemi  : Float :=
  ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))

#eval IO.println ("zeHashemi " ++ toString (zeHashemi).toBits)
#eval IO.println ("zeHashemi " ++ toString (zeHashemi).toBits)
#eval IO.println ("zeHashemi " ++ toString (zeHashemi).toBits)

end HashemiCccFloat
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

def check_bins_partition (rc : Float) (r : Float) : Bool :=
  (!((0 : Float) < rc) || (!((0 : Float) <= r) || (feq ((((((((if (((((0 : Float) * rc) / (8 : Float)) <= r) && (r < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float)) + (if (((((1 : Float) * rc) / (8 : Float)) <= r) && (r < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((2 : Float) * rc) / (8 : Float)) <= r) && (r < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((3 : Float) * rc) / (8 : Float)) <= r) && (r < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((4 : Float) * rc) / (8 : Float)) <= r) && (r < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((5 : Float) * rc) / (8 : Float)) <= r) && (r < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((6 : Float) * rc) / (8 : Float)) <= r) && (r < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((7 : Float) * rc) / (8 : Float)) <= r) && (r < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) (if (r < rc) then (1 : Float) else (0 : Float)))))

#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 0.956891 0.898342))
#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 0.625699 0.567150))
#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 0.294507 0.235958))

def bisectStep (ym : Float) (hp : Float) (a : Float) (ze : Float) (L : Float) (lohi_1 : Float) (lohi_2 : Float) : Array Float :=
  let v9 := ((lohi_1 + lohi_2) / (2 : Float))
  let v11 := (-a)
  let v12 := (Float.cos v9)
  let v14 := (-ze)
  let v15 := (Float.sin v9)
  let v28 := (L < (Float.sqrt (((((v11 * v12) + (v14 * v15)) - (-ym)) ^ 2) + (((((-v11) * v15) + (v14 * v12)) - hp) ^ 2))))
  #[(if v28 then v9 else lohi_1), (if v28 then lohi_2 else v9)]

#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.770739 0.712190 0.653641 0.595092 0.536544 0.477995 0.419446).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.439547 0.380998 0.322449 0.263900 0.205352 1.746803 1.688254).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 1.708355 1.649806 1.591257 1.532708 1.474160 1.415611 1.357062).map Float.toBits))

def boltStress (W : Float) (reach : Float) (d : Float) : Float :=
  (((W / (2 : Float)) * reach) / (((3.141592653589793 : Float) * (d ^ 3)) / (32 : Float)))

#eval IO.println ("boltStress " ++ toString (boltStress 0.584587 0.526038 0.467489).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 0.253395 1.794846 1.736297).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 1.522203 1.463654 1.405105).toBits)

def braceHeight (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (Float.sqrt ((l_brace ^ 2) - ((l_foot - l_footShort) ^ 2)))

#eval IO.println ("braceHeight " ++ toString (braceHeight 0.398435 0.339886 0.281337 0.222788 1.764240).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 1.667243 1.608694 1.550145 1.491596 1.433048).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 1.336051 1.277502 1.218953 1.160404 1.101856).toBits)

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

#eval IO.println ("cableDrop " ++ toString (cableDrop 1.067675 1.009126).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 0.736483 0.677934).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 0.405291 0.346742).toBits)

def check_cable_drop_small (L : Float) (I : Float) : Bool :=
  (!(L <= (4 : Float)) || (!((0 : Float) <= I) || (!(I <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float)) < (0.1 : Float)))))

#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.881523 0.822974))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.550331 0.491782))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.219139 1.760590))

def captureS (rc : Float) (rad : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((rc - rad) / (0.005 : Float)))))

#eval IO.println ("captureS " ++ toString (captureS 0.695371 0.636822).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.364179 0.305630).toBits)
#eval IO.println ("captureS " ++ toString (captureS 1.632987 1.574438).toBits)

def check_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.509219 0.450670 0.392121))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 1.778027 1.719478 1.660929))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 1.446835 1.388286 1.329737))

def clearance (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (holeDown : Float) (reach : Float) : Float :=
  ((l_upright - holeDown) - reach)

#eval IO.println ("clearance " ++ toString (clearance 0.323067 0.264518 0.205969 1.747420 1.688872 1.630323 1.571774).toBits)
#eval IO.println ("clearance " ++ toString (clearance 1.591875 1.533326 1.474777 1.416228 1.357680 1.299131 1.240582).toBits)
#eval IO.println ("clearance " ++ toString (clearance 1.260683 1.202134 1.143585 1.085036 1.026488 0.967939 0.909390).toBits)

def check_clearance_hashemi (holeDown : Float) : Bool :=
  let v16 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v16) && (v16 < ((0.146 : Float) - holeDown)))

#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.736915))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.405723))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.074531))

def coilCapture (rs : Float) (rc : Float) (d : Float) : Float :=
  let v9 := (rs ^ 2)
  let v10 := (d ^ 2)
  let v12 := (rc ^ 2)
  let v15 := ((2 : Float) * d)
  let v30 := (d + rs)
  (if ((rs + rc) <= d) then (0 : Float) else (if (d <= (rc - rs)) then (1 : Float) else ((((v9 * (Float.acos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Float.acos (((v10 + v12) - v9) / (v15 * rc))))) - ((Float.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : Float))) / ((3.141592653589793 : Float) * v9))))

#eval IO.println ("coilCapture " ++ toString (coilCapture 1.550763 1.492214 1.433665).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.219571 1.161022 1.102473).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 0.888379 0.829830 0.771281).toBits)

def coilProfile (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (Tin : Float) (P_0 : Float) (P_1 : Float) (P_2 : Float) (P_3 : Float) (P_4 : Float) (P_5 : Float) (P_6 : Float) (P_7 : Float) : Array Float :=
  let v19 := (Ac / (8 : Float))
  let v20 := ((eps * (0.0000000567 : Float)) * v19)
  let v22 := (Ta ^ 4)
  let v25 := (hC * v19)
  let v31 := (Tin + (((alpha * P_0) - ((v20 * ((Tin ^ 4) - v22)) + (v25 * (Tin - Ta)))) / mcp))
  let v41 := (v31 + (((alpha * P_1) - ((v20 * ((v31 ^ 4) - v22)) + (v25 * (v31 - Ta)))) / mcp))
  let v51 := (v41 + (((alpha * P_2) - ((v20 * ((v41 ^ 4) - v22)) + (v25 * (v41 - Ta)))) / mcp))
  let v61 := (v51 + (((alpha * P_3) - ((v20 * ((v51 ^ 4) - v22)) + (v25 * (v51 - Ta)))) / mcp))
  let v71 := (v61 + (((alpha * P_4) - ((v20 * ((v61 ^ 4) - v22)) + (v25 * (v61 - Ta)))) / mcp))
  let v81 := (v71 + (((alpha * P_5) - ((v20 * ((v71 ^ 4) - v22)) + (v25 * (v71 - Ta)))) / mcp))
  let v91 := (v81 + (((alpha * P_6) - ((v20 * ((v81 ^ 4) - v22)) + (v25 * (v81 - Ta)))) / mcp))
  #[v31, v41, v51, v61, v71, v81, v91, (v91 + (((alpha * P_7) - ((v20 * ((v91 ^ 4) - v22)) + (v25 * (v91 - Ta)))) / mcp))]

#eval IO.println ("coilProfile " ++ toString ((coilProfile 1.364611 1.306062 1.247513 1.188964 1.130416 1.071867 1.013318 0.954769 0.896220 0.837672 0.779123 0.720574 0.662025 0.603476 0.544928).map Float.toBits))
#eval IO.println ("coilProfile " ++ toString ((coilProfile 1.033419 0.974870 0.916321 0.857772 0.799224 0.740675 0.682126 0.623577 0.565028 0.506480 0.447931 0.389382 0.330833 0.272284 0.213736).map Float.toBits))
#eval IO.println ("coilProfile " ++ toString ((coilProfile 0.702227 0.643678 0.585129 0.526580 0.468032 0.409483 0.350934 0.292385 0.233836 1.775288 1.716739 1.658190 1.599641 1.541092 1.482544).map Float.toBits))

def check_coilProfile_balance (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (Tin : Float) (P_0 : Float) (P_1 : Float) (P_2 : Float) (P_3 : Float) (P_4 : Float) (P_5 : Float) (P_6 : Float) (P_7 : Float) : Bool :=
  let v21 := (Ac / (8 : Float))
  let v22 := ((eps * (0.0000000567 : Float)) * v21)
  let v24 := (Ta ^ 4)
  let v27 := (hC * v21)
  let v30 := ((v22 * ((Tin ^ 4) - v24)) + (v27 * (Tin - Ta)))
  let v33 := (Tin + (((alpha * P_0) - v30) / mcp))
  let v40 := ((v22 * ((v33 ^ 4) - v24)) + (v27 * (v33 - Ta)))
  let v43 := (v33 + (((alpha * P_1) - v40) / mcp))
  let v50 := ((v22 * ((v43 ^ 4) - v24)) + (v27 * (v43 - Ta)))
  let v53 := (v43 + (((alpha * P_2) - v50) / mcp))
  let v60 := ((v22 * ((v53 ^ 4) - v24)) + (v27 * (v53 - Ta)))
  let v63 := (v53 + (((alpha * P_3) - v60) / mcp))
  let v70 := ((v22 * ((v63 ^ 4) - v24)) + (v27 * (v63 - Ta)))
  let v73 := (v63 + (((alpha * P_4) - v70) / mcp))
  let v80 := ((v22 * ((v73 ^ 4) - v24)) + (v27 * (v73 - Ta)))
  let v83 := (v73 + (((alpha * P_5) - v80) / mcp))
  let v90 := ((v22 * ((v83 ^ 4) - v24)) + (v27 * (v83 - Ta)))
  let v93 := (v83 + (((alpha * P_6) - v90) / mcp))
  let v100 := ((v22 * ((v93 ^ 4) - v24)) + (v27 * (v93 - Ta)))
  (!(!(feq mcp (0 : Float))) || (feq (mcp * ((v93 + (((alpha * P_7) - v100) / mcp)) - Tin)) ((alpha * (P_0 + (P_1 + (P_2 + (P_3 + (P_4 + (P_5 + (P_6 + (P_7 + (0 : Float)))))))))) - (((((((v30 + v40) + v50) + v60) + v70) + v80) + v90) + v100))))

#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 1.178459 1.119910 1.061361 1.002812 0.944264 0.885715 0.827166 0.768617 0.710068 0.651520 0.592971 0.534422 0.475873 0.417324 0.358776))
#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 0.847267 0.788718 0.730169 0.671620 0.613072 0.554523 0.495974 0.437425 0.378876 0.320328 0.261779 0.203230 1.744681 1.686132 1.627584))
#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 0.516075 0.457526 0.398977 0.340428 0.281880 0.223331 1.764782 1.706233 1.647684 1.589136 1.530587 1.472038 1.413489 1.354940 1.296392))

def conicHitS (c : Float) (k : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Float :=
  let v9 := ((1 : Float) + k)
  let v27 := ((((2 : Float) * c) * (((O_0 * d_0) + (O_1 * d_1)) + ((v9 * O_2) * d_2))) - ((2 : Float) * d_2))
  let v36 := ((c * (((O_0 ^ 2) + (O_1 ^ 2)) + (v9 * (O_2 ^ 2)))) - ((2 : Float) * O_2))
  (((2 : Float) * v36) / ((-v27) - (Float.sqrt (max ((v27 ^ 2) - (((4 : Float) * (c * (((d_0 ^ 2) + (d_1 ^ 2)) + (v9 * (d_2 ^ 2))))) * v36)) (0 : Float)))))

#eval IO.println ("conicHitS " ++ toString (conicHitS 0.992307 0.933758 0.875209 0.816660 0.758112 0.699563 0.641014 0.582465).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 0.661115 0.602566 0.544017 0.485468 0.426920 0.368371 0.309822 0.251273).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 0.329923 0.271374 0.212825 1.754276 1.695728 1.637179 1.578630 1.520081).toBits)

def conicSlope (c : Float) (k : Float) (r : Float) : Float :=
  ((c * r) / (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : Float))))

#eval IO.println ("conicSlope " ++ toString (conicSlope 0.806155 0.747606 0.689057).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 0.474963 0.416414 0.357865).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.743771 1.685222 1.626673).toBits)

def conicZ (c : Float) (k : Float) (r : Float) : Float :=
  let v3 := (r ^ 2)
  ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * v3)) (0 : Float)))))

#eval IO.println ("conicZ " ++ toString (conicZ 0.620003 0.561454 0.502905).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 0.288811 0.230262 1.771713).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 1.557619 1.499070 1.440521).toBits)

def check_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.433851 0.375302))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.702659 1.644110))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.371467 1.312918))

def check_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v4 := (c ^ 2)
  let v5 := (r ^ 2)
  let v18 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v4 * v5) <= (1 : Float)) || (feq ((c * v5) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v4) * v5)) (0 : Float))))) (v18 - (Float.sqrt ((v18 ^ 2) - v5))))))

#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.247699 1.789150))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.516507 1.457958))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.185315 1.126766))

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

#eval IO.println ("constraints " ++ toString ((constraints 1.661547 1.602998 1.544449 1.485900 1.427352 1.368803 1.310254 1.251705 1.193156 1.134608 1.076059 1.017510).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 1.330355 1.271806 1.213257 1.154708 1.096160 1.037611 0.979062 0.920513 0.861964 0.803416 0.744867 0.686318).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.999163 0.940614 0.882065 0.823516 0.764968 0.706419 0.647870 0.589321 0.530772 0.472224 0.413675 0.355126).map Float.toBits))

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

#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.475395 1.416846 1.358297 1.299748 1.241200 1.182651 1.124102 1.065553 1.007004 0.948456 0.889907 0.831358).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.144203 1.085654 1.027105 0.968556 0.910008 0.851459 0.792910 0.734361 0.675812 0.617264 0.558715 0.500166).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.813011 0.754462 0.695913 0.637364 0.578816 0.520267 0.461718 0.403169 0.344620 0.286072 0.227523 1.768974).map Float.toBits))

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

#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.289243 1.230694 1.172145 1.113596 1.055048 0.996499 0.937950 0.879401 0.820852 0.762304 0.703755 0.645206))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.958051 0.899502 0.840953 0.782404 0.723856 0.665307 0.606758 0.548209 0.489660 0.431112 0.372563 0.314014))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.626859 0.568310 0.509761 0.451212 0.392664 0.334115 0.275566 0.217017 1.758468 1.699920 1.641371 1.582822))

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

#eval IO.println ("cross3 " ++ toString ((cross3 0.730787 0.672238 0.613689 0.555140 0.496592 0.438043).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 0.399595 0.341046 0.282497 0.223948 1.765400 1.706851).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 1.668403 1.609854 1.551305 1.492756 1.434208 1.375659).map Float.toBits))

def deadPoint (ym : Float) (hp : Float) (a : Float) (ze : Float) : Float :=
  let v4 := (ym * a)
  let v5 := (hp * ze)
  (if (v4 <= v5) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v4 - v5))))

#eval IO.println ("deadPoint " ++ toString (deadPoint 0.544635 0.486086 0.427537 0.368988).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 0.213443 1.754894 1.696345 1.637796).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.482251 1.423702 1.365153 1.306604).toBits)

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

def delaySteps  : Float :=
  (2 : Float)

#eval IO.println ("delaySteps " ++ toString (delaySteps).toBits)
#eval IO.println ("delaySteps " ++ toString (delaySteps).toBits)
#eval IO.println ("delaySteps " ++ toString (delaySteps).toBits)

def delivered (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Float :=
  (Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp))))

#eval IO.println ("delivered " ++ toString (delivered 1.400027 1.341478 1.282929 1.224380).toBits)
#eval IO.println ("delivered " ++ toString (delivered 1.068835 1.010286 0.951737 0.893188).toBits)
#eval IO.println ("delivered " ++ toString (delivered 0.737643 0.679094 0.620545 0.561996).toBits)

def check_delivered_ge_amb (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Bool :=
  (!(Ta <= Tin) || (Ta <= (Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp))))))

#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 1.213875 1.155326 1.096777 1.038228))
#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 0.882683 0.824134 0.765585 0.707036))
#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 0.551491 0.492942 0.434393 0.375844))

def check_delivered_le (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || (!(Ta <= Tin) || ((Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp)))) <= Tin))))

#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 1.027723 0.969174 0.910625 0.852076))
#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 0.696531 0.637982 0.579433 0.520884))
#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 0.365339 0.306790 0.248241 1.789692))

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

#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.841571 0.783022).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.510379 0.451830).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.779187 1.720638).map Float.toBits))

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

#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.655419 0.596870 0.538321))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.324227 0.265678 0.207129))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.593035 1.534486 1.475937))

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

#eval IO.println ("dishPower " ++ toString ((dishPower 1.696963 1.638414 1.579865 1.521316 1.462768 1.404219 1.345670 1.287121 1.228572 1.170024 1.111475 1.052926 0.994377 0.935828 0.877280 0.818731 0.760182 0.701633 0.643084 0.584536 0.525987 0.467438 0.408889 0.350340).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.365771 1.307222 1.248673 1.190124 1.131576 1.073027 1.014478 0.955929 0.897380 0.838832 0.780283 0.721734 0.663185 0.604636 0.546088 0.487539 0.428990 0.370441 0.311892 0.253344 1.794795 1.736246 1.677697 1.619148).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.034579 0.976030 0.917481 0.858932 0.800384 0.741835 0.683286 0.624737 0.566188 0.507640 0.449091 0.390542 0.331993 0.273444 0.214896 1.756347 1.697798 1.639249 1.580700 1.522152 1.463603 1.405054 1.346505 1.287956).map Float.toBits))

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

#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.510811 1.452262 1.393713 1.335164 1.276616 1.218067 1.159518 1.100969 1.042420 0.983872 0.925323 0.866774 0.808225 0.749676 0.691128 0.632579 0.574030 0.515481 0.456932 0.398384 0.339835 0.281286 0.222737 1.764188))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.179619 1.121070 1.062521 1.003972 0.945424 0.886875 0.828326 0.769777 0.711228 0.652680 0.594131 0.535582 0.477033 0.418484 0.359936 0.301387 0.242838 1.784289 1.725740 1.667192 1.608643 1.550094 1.491545 1.432996))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.848427 0.789878 0.731329 0.672780 0.614232 0.555683 0.497134 0.438585 0.380036 0.321488 0.262939 0.204390 1.745841 1.687292 1.628744 1.570195 1.511646 1.453097 1.394548 1.336000 1.277451 1.218902 1.160353 1.101804))

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

#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.324659 1.266110 1.207561 1.149012 1.090464 1.031915 0.973366 0.914817 0.856268 0.797720 0.739171 0.680622 0.622073 0.563524 0.504976 0.446427 0.387878 0.329329 0.270780 0.212232 1.753683 1.695134 1.636585 1.578036))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.993467 0.934918 0.876369 0.817820 0.759272 0.700723 0.642174 0.583625 0.525076 0.466528 0.407979 0.349430 0.290881 0.232332 1.773784 1.715235 1.656686 1.598137 1.539588 1.481040 1.422491 1.363942 1.305393 1.246844))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.662275 0.603726 0.545177 0.486628 0.428080 0.369531 0.310982 0.252433 1.793884 1.735336 1.676787 1.618238 1.559689 1.501140 1.442592 1.384043 1.325494 1.266945 1.208396 1.149848 1.091299 1.032750 0.974201 0.915652))

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

#eval IO.println ("dot3 " ++ toString (dot3 0.393899 0.335350 0.276801 0.218252 1.759704 1.701155).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.662707 1.604158 1.545609 1.487060 1.428512 1.369963).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.331515 1.272966 1.214417 1.155868 1.097320 1.038771).toBits)

def driveAz (u : Float) (rw : Float) (R : Float) : Float :=
  (((u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("driveAz " ++ toString (driveAz 0.207747 1.749198 1.690649).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 1.476555 1.418006 1.359457).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 1.145363 1.086814 1.028265).toBits)

def check_driveAz_rate (u : Float) (rw : Float) (R : Float) : Bool :=
  let v11 := (u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rw (0 : Float))) || (!(!(feq R (0 : Float))) || (feq ((((v11 * R) / rw) * rw) / R) v11)))

#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 1.621595 1.563046 1.504497))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 1.290403 1.231854 1.173305))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 0.959211 0.900662 0.842113))

def driveEl (u : Float) (arm : Float) (rDrum : Float) : Float :=
  (((u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("driveEl " ++ toString (driveEl 1.435443 1.376894 1.318345).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 1.104251 1.045702 0.987153).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 0.773059 0.714510 0.655961).toBits)

def check_driveEl_rate (u : Float) (arm : Float) (rDrum : Float) : Bool :=
  let v11 := (u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rDrum (0 : Float))) || (!(!(feq arm (0 : Float))) || (feq ((((v11 * arm) / rDrum) * rDrum) / arm) v11)))

#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 1.249291 1.190742 1.132193))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.918099 0.859550 0.801001))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.586907 0.528358 0.469809))

def check_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v21 := (Float.sqrt ((v16 ^ 2) + (c_apexH ^ 2)))
  let v23 := (-((F * v16) / v21))
  let v25 := ((F * c_apexH) / v21)
  (feq (((((((0 : Float) * ((v16 * (0 : Float)) - (b_zRail * v25))) + ((0 : Float) * ((b_zRail * v23) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v25) - (v16 * v23)))) + ((0 : Float) * v23)) + ((0 : Float) * v25)) + ((0 : Float) * (0 : Float))) (F * v21))

#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.063139 1.004590 0.946041 0.887492 0.828944 0.770395 0.711846 0.653297 0.594748 0.536200 0.477651 0.419102 0.360553))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.731947 0.673398 0.614849 0.556300 0.497752 0.439203 0.380654 0.322105 0.263556 0.205008 1.746459 1.687910 1.629361))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.400755 0.342206 0.283657 0.225108 1.766560 1.708011 1.649462 1.590913 1.532364 1.473816 1.415267 1.356718 1.298169))

def check_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v17 := (c_chord / (2 : Float))
  let v22 := (Float.sqrt ((v17 ^ 2) + (c_apexH ^ 2)))
  let v24 := (-((F * v17) / v22))
  let v26 := ((F * c_apexH) / v22)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v17 * (0 : Float)) - (b_zRail * v26))) + ((0 : Float) * ((b_zRail * v24) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v26) - (v17 * v24)))) + ((0 : Float) * v24)) + ((0 : Float) * v26)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.876987 0.818438 0.759889 0.701340 0.642792 0.584243 0.525694 0.467145 0.408596 0.350048 0.291499 0.232950 1.774401))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.545795 0.487246 0.428697 0.370148 0.311600 0.253051 1.794502 1.735953 1.677404 1.618856 1.560307 1.501758 1.443209))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.214603 1.756054 1.697505 1.638956 1.580408 1.521859 1.463310 1.404761 1.346212 1.287664 1.229115 1.170566 1.112017))

def edgeClipAt (a : Float) (ze : Float) (t : Float) : Array Float :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  #[((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))]

#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.690835 0.632286 0.573737).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.359643 0.301094 0.242545).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.628451 1.569902 1.511353).map Float.toBits))

def check_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (feq (((-ym) * (((-v6) * v10) + (v9 * v7))) - (hp * ((v6 * v7) + (v9 * v10)))) ((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)))

#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.504683 0.446134 0.387585 0.329036 0.270488))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.773491 1.714942 1.656393 1.597844 1.539296))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.442299 1.383750 1.325201 1.266652 1.208104))

def check_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  (feq ((((v3 * v4) + (v6 * v7)) ^ 2) + ((((-v3) * v7) + (v6 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.318531 0.259982 0.201433))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.587339 1.528790 1.470241))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.256147 1.197598 1.139049))

def check_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v6 := (Float.sqrt (3.36 : Float))
  let v9 := (-(v6 - (1 : Float)))
  let v10 := (Float.sin t)
  (feq ((((v2 * v3) + (v9 * v10)) ^ 2) + ((((-v2) * v10) + (v9 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v6)))

#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.732379))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.401187))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.069995))

def check_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  ((Float.abs ((v3 * v4) + (v6 * v7))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.546227 1.487678 1.429129))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.215035 1.156486 1.097937))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.883843 0.825294 0.766745))

def edgeDepth (f : Float) (a : Float) (sag : Float) (el : Float) : Float :=
  (((f - sag) * (Float.sin el)) + (a * (Float.cos el)))

#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.360075 1.301526 1.242977 1.184428).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.028883 0.970334 0.911785 0.853236).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.697691 0.639142 0.580593 0.522044).toBits)

def check_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.173923 1.115374 1.056825))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.842731 0.784182 0.725633))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.511539 0.452990 0.394441))

def check_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.987771 0.929222 0.870673 0.812124))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.656579 0.598030 0.539481 0.480932))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.325387 0.266838 0.208289 1.749740))

def check_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.801619 0.743070 0.684521))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.470427 0.411878 0.353329))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.739235 1.680686 1.622137))

def check_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v10 := (Float.cos t)
  let v17 := (-a)
  let v19 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v10 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v17) * v5) + (v19 * v10))) - (hp * ((v17 * v10) + (v19 * v5)))) (0 : Float)))

#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.615467 0.556918 0.498369 0.439820 0.381272))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.284275 0.225726 1.767177 1.708628 1.650080))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.553083 1.494534 1.435985 1.377436 1.318888))

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

#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.429315 0.370766 0.312217 0.253668 1.795120))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.698123 1.639574 1.581025 1.522476 1.463928))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.366931 1.308382 1.249833 1.191284 1.132736))

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

#eval IO.println ("elPower " ++ toString (elPower 1.470859 1.412310 1.353761 1.295212).toBits)
#eval IO.println ("elPower " ++ toString (elPower 1.139667 1.081118 1.022569 0.964020).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.808475 0.749926 0.691377 0.632828).toBits)

def check_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v9 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v9 / rw) * (rw * omega)) (v9 * omega)))

#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 1.284707 1.226158 1.167609 1.109060 1.050512))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.953515 0.894966 0.836417 0.777868 0.719320))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.622323 0.563774 0.505225 0.446676 0.388128))

def check_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v8 * (Float.sin t)) * omega) <= (v8 * omega)))))

#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.098555 1.040006 0.981457 0.922908))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.767363 0.708814 0.650265 0.591716))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.436171 0.377622 0.319073 0.260524))

def elRate (omegad : Float) (rDrum : Float) (rw : Float) : Float :=
  ((omegad * rDrum) / rw)

#eval IO.println ("elRate " ++ toString (elRate 0.912403 0.853854 0.795305).toBits)
#eval IO.println ("elRate " ++ toString (elRate 0.581211 0.522662 0.464113).toBits)
#eval IO.println ("elRate " ++ toString (elRate 0.250019 1.791470 1.732921).toBits)

def facetSpot (w : Float) (f : Float) : Float :=
  (w + (f * (0.0093 : Float)))

#eval IO.println ("facetSpot " ++ toString (facetSpot 0.726251 0.667702).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 0.395059 0.336510).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.663867 1.605318).toBits)

def check_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))

def focusShift (h : Float) (eps : Float) : Float :=
  (h * (Float.sin eps))

#eval IO.println ("focusShift " ++ toString (focusShift 0.353947 0.295398).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.622755 1.564206).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.291563 1.233014).toBits)

def check_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v1 := (Float.cos psi)
  let v7 := (Float.sin psi)
  (!(!(feq v1 (1 : Float))) || (!((feq ((v1 * p_1) - (v7 * p_2)) p_1) && (feq ((v7 * p_1) + (v1 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.767795 1.709246 1.650697))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.436603 1.378054 1.319505))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.105411 1.046862 0.988313))

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

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.395491 1.336942 1.278393 1.219844 1.161296 1.102747 1.044198 0.985649 0.927100 0.868552 0.810003 0.751454))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.064299 1.005750 0.947201 0.888652 0.830104 0.771555 0.713006 0.654457 0.595908 0.537360 0.478811 0.420262))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.733107 0.674558 0.616009 0.557460 0.498912 0.440363 0.381814 0.323265 0.264716 0.206168 1.747619 1.689070))

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

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.209339 1.150790 1.092241 1.033692 0.975144 0.916595 0.858046 0.799497 0.740948 0.682400 0.623851 0.565302))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.878147 0.819598 0.761049 0.702500 0.643952 0.585403 0.526854 0.468305 0.409756 0.351208 0.292659 0.234110))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.546955 0.488406 0.429857 0.371308 0.312760 0.254211 1.795662 1.737113 1.678564 1.620016 1.561467 1.502918))

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

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.023187 0.964638 0.906089 0.847540 0.788992 0.730443 0.671894 0.613345 0.554796 0.496248 0.437699 0.379150))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.691995 0.633446 0.574897 0.516348 0.457800 0.399251 0.340702 0.282153 0.223604 1.765056 1.706507 1.647958))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.360803 0.302254 0.243705 1.785156 1.726608 1.668059 1.609510 1.550961 1.492412 1.433864 1.375315 1.316766))

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 0.650883 0.592334 0.533785 0.475236).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 0.319691 0.261142 0.202593 1.744044).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.588499 1.529950 1.471401 1.412852).toBits)

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

def hashemiEnv (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (mcp : Float) (Twall : Float) (Ta : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Array Float :=
  let v718 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v730 := ((1.22 : Float) * (0.8 : Float))
  let v731 := ((0.34 : Float) * v718)
  let v734 := ((3.141592653589793 : Float) / (2 : Float))
  let v741 := (if (v730 <= v731) then v734 else (Float.atan ((((1.22 : Float) * v718) + ((0.34 : Float) * (0.8 : Float))) / (v730 - v731))))
  let v742 := (-(1.22 : Float))
  let v743 := (-(0.8 : Float))
  let v745 := (Float.cos (0 : Float))
  let v747 := (-v718)
  let v748 := (Float.sin (0 : Float))
  let v751 := (-v743)
  let v760 := (Float.sqrt (((((v743 * v745) + (v747 * v748)) - v742) ^ 2) + ((((v751 * v748) + (v747 * v745)) - (0.34 : Float)) ^ 2)))
  let v761 := (Float.cos v741)
  let v763 := (Float.sin v741)
  let v774 := (Float.sqrt (((((v743 * v761) + (v747 * v763)) - v742) ^ 2) + ((((v751 * v763) + (v747 * v761)) - (0.34 : Float)) ^ 2)))
  let v775 := (Float.cos t)
  let v777 := (Float.sin t)
  let v779 := ((v743 * v775) + (v747 * v777))
  let v782 := ((v751 * v777) + (v747 * v775))
  let v788 := (Float.sqrt (((v779 - v742) ^ 2) + ((v782 - (0.34 : Float)) ^ 2)))
  let v790 := (omegad * rDrum)
  let v792 := ((v788 + slack) - (v790 * dt))
  let v793 := (v792 < v774)
  let v794 := (v760 < v792)
  let v796 := (if v793 then v774 else (if v794 then v760 else v792))
  let v801 := (((0 : Float) + v741) / (2 : Float))
  let v802 := (Float.cos v801)
  let v804 := (Float.sin v801)
  let v816 := (v796 < (Float.sqrt (((((v743 * v802) + (v747 * v804)) - v742) ^ 2) + ((((v751 * v804) + (v747 * v802)) - (0.34 : Float)) ^ 2))))
  let v817 := (if v816 then v801 else (0 : Float))
  let v818 := (if v816 then v741 else v801)
  let v820 := ((v817 + v818) / (2 : Float))
  let v821 := (Float.cos v820)
  let v823 := (Float.sin v820)
  let v835 := (v796 < (Float.sqrt (((((v743 * v821) + (v747 * v823)) - v742) ^ 2) + ((((v751 * v823) + (v747 * v821)) - (0.34 : Float)) ^ 2))))
  let v836 := (if v835 then v820 else v817)
  let v837 := (if v835 then v818 else v820)
  let v839 := ((v836 + v837) / (2 : Float))
  let v840 := (Float.cos v839)
  let v842 := (Float.sin v839)
  let v854 := (v796 < (Float.sqrt (((((v743 * v840) + (v747 * v842)) - v742) ^ 2) + ((((v751 * v842) + (v747 * v840)) - (0.34 : Float)) ^ 2))))
  let v855 := (if v854 then v839 else v836)
  let v856 := (if v854 then v837 else v839)
  let v858 := ((v855 + v856) / (2 : Float))
  let v859 := (Float.cos v858)
  let v861 := (Float.sin v858)
  let v873 := (v796 < (Float.sqrt (((((v743 * v859) + (v747 * v861)) - v742) ^ 2) + ((((v751 * v861) + (v747 * v859)) - (0.34 : Float)) ^ 2))))
  let v874 := (if v873 then v858 else v855)
  let v875 := (if v873 then v856 else v858)
  let v877 := ((v874 + v875) / (2 : Float))
  let v878 := (Float.cos v877)
  let v880 := (Float.sin v877)
  let v892 := (v796 < (Float.sqrt (((((v743 * v878) + (v747 * v880)) - v742) ^ 2) + ((((v751 * v880) + (v747 * v878)) - (0.34 : Float)) ^ 2))))
  let v893 := (if v892 then v877 else v874)
  let v894 := (if v892 then v875 else v877)
  let v896 := ((v893 + v894) / (2 : Float))
  let v897 := (Float.cos v896)
  let v899 := (Float.sin v896)
  let v911 := (v796 < (Float.sqrt (((((v743 * v897) + (v747 * v899)) - v742) ^ 2) + ((((v751 * v899) + (v747 * v897)) - (0.34 : Float)) ^ 2))))
  let v912 := (if v911 then v896 else v893)
  let v913 := (if v911 then v894 else v896)
  let v915 := ((v912 + v913) / (2 : Float))
  let v916 := (Float.cos v915)
  let v918 := (Float.sin v915)
  let v930 := (v796 < (Float.sqrt (((((v743 * v916) + (v747 * v918)) - v742) ^ 2) + ((((v751 * v918) + (v747 * v916)) - (0.34 : Float)) ^ 2))))
  let v931 := (if v930 then v915 else v912)
  let v932 := (if v930 then v913 else v915)
  let v934 := ((v931 + v932) / (2 : Float))
  let v935 := (Float.cos v934)
  let v937 := (Float.sin v934)
  let v949 := (v796 < (Float.sqrt (((((v743 * v935) + (v747 * v937)) - v742) ^ 2) + ((((v751 * v937) + (v747 * v935)) - (0.34 : Float)) ^ 2))))
  let v950 := (if v949 then v934 else v931)
  let v951 := (if v949 then v932 else v934)
  let v953 := ((v950 + v951) / (2 : Float))
  let v954 := (Float.cos v953)
  let v956 := (Float.sin v953)
  let v968 := (v796 < (Float.sqrt (((((v743 * v954) + (v747 * v956)) - v742) ^ 2) + ((((v751 * v956) + (v747 * v954)) - (0.34 : Float)) ^ 2))))
  let v969 := (if v968 then v953 else v950)
  let v970 := (if v968 then v951 else v953)
  let v972 := ((v969 + v970) / (2 : Float))
  let v973 := (Float.cos v972)
  let v975 := (Float.sin v972)
  let v987 := (v796 < (Float.sqrt (((((v743 * v973) + (v747 * v975)) - v742) ^ 2) + ((((v751 * v975) + (v747 * v973)) - (0.34 : Float)) ^ 2))))
  let v988 := (if v987 then v972 else v969)
  let v989 := (if v987 then v970 else v972)
  let v991 := ((v988 + v989) / (2 : Float))
  let v992 := (Float.cos v991)
  let v994 := (Float.sin v991)
  let v1006 := (v796 < (Float.sqrt (((((v743 * v992) + (v747 * v994)) - v742) ^ 2) + ((((v751 * v994) + (v747 * v992)) - (0.34 : Float)) ^ 2))))
  let v1007 := (if v1006 then v991 else v988)
  let v1008 := (if v1006 then v989 else v991)
  let v1010 := ((v1007 + v1008) / (2 : Float))
  let v1011 := (Float.cos v1010)
  let v1013 := (Float.sin v1010)
  let v1025 := (v796 < (Float.sqrt (((((v743 * v1011) + (v747 * v1013)) - v742) ^ 2) + ((((v751 * v1013) + (v747 * v1011)) - (0.34 : Float)) ^ 2))))
  let v1026 := (if v1025 then v1010 else v1007)
  let v1027 := (if v1025 then v1008 else v1010)
  let v1029 := ((v1026 + v1027) / (2 : Float))
  let v1030 := (Float.cos v1029)
  let v1032 := (Float.sin v1029)
  let v1044 := (v796 < (Float.sqrt (((((v743 * v1030) + (v747 * v1032)) - v742) ^ 2) + ((((v751 * v1032) + (v747 * v1030)) - (0.34 : Float)) ^ 2))))
  let v1045 := (if v1044 then v1029 else v1026)
  let v1046 := (if v1044 then v1027 else v1029)
  let v1048 := ((v1045 + v1046) / (2 : Float))
  let v1049 := (Float.cos v1048)
  let v1051 := (Float.sin v1048)
  let v1063 := (v796 < (Float.sqrt (((((v743 * v1049) + (v747 * v1051)) - v742) ^ 2) + ((((v751 * v1051) + (v747 * v1049)) - (0.34 : Float)) ^ 2))))
  let v1064 := (if v1063 then v1048 else v1045)
  let v1065 := (if v1063 then v1046 else v1048)
  let v1067 := ((v1064 + v1065) / (2 : Float))
  let v1068 := (Float.cos v1067)
  let v1070 := (Float.sin v1067)
  let v1082 := (v796 < (Float.sqrt (((((v743 * v1068) + (v747 * v1070)) - v742) ^ 2) + ((((v751 * v1070) + (v747 * v1068)) - (0.34 : Float)) ^ 2))))
  let v1083 := (if v1082 then v1067 else v1064)
  let v1084 := (if v1082 then v1065 else v1067)
  let v1086 := ((v1083 + v1084) / (2 : Float))
  let v1087 := (Float.cos v1086)
  let v1089 := (Float.sin v1086)
  let v1101 := (v796 < (Float.sqrt (((((v743 * v1087) + (v747 * v1089)) - v742) ^ 2) + ((((v751 * v1089) + (v747 * v1087)) - (0.34 : Float)) ^ 2))))
  let v1102 := (if v1101 then v1086 else v1083)
  let v1103 := (if v1101 then v1084 else v1086)
  let v1105 := ((v1102 + v1103) / (2 : Float))
  let v1106 := (Float.cos v1105)
  let v1108 := (Float.sin v1105)
  let v1120 := (v796 < (Float.sqrt (((((v743 * v1106) + (v747 * v1108)) - v742) ^ 2) + ((((v751 * v1108) + (v747 * v1106)) - (0.34 : Float)) ^ 2))))
  let v1121 := (if v1120 then v1105 else v1102)
  let v1122 := (if v1120 then v1103 else v1105)
  let v1124 := ((v1121 + v1122) / (2 : Float))
  let v1125 := (Float.cos v1124)
  let v1127 := (Float.sin v1124)
  let v1139 := (v796 < (Float.sqrt (((((v743 * v1125) + (v747 * v1127)) - v742) ^ 2) + ((((v751 * v1127) + (v747 * v1125)) - (0.34 : Float)) ^ 2))))
  let v1140 := (if v1139 then v1124 else v1121)
  let v1141 := (if v1139 then v1122 else v1124)
  let v1143 := ((v1140 + v1141) / (2 : Float))
  let v1144 := (Float.cos v1143)
  let v1146 := (Float.sin v1143)
  let v1158 := (v796 < (Float.sqrt (((((v743 * v1144) + (v747 * v1146)) - v742) ^ 2) + ((((v751 * v1146) + (v747 * v1144)) - (0.34 : Float)) ^ 2))))
  let v1159 := (if v1158 then v1143 else v1140)
  let v1160 := (if v1158 then v1141 else v1143)
  let v1162 := ((v1159 + v1160) / (2 : Float))
  let v1163 := (Float.cos v1162)
  let v1165 := (Float.sin v1162)
  let v1177 := (v796 < (Float.sqrt (((((v743 * v1163) + (v747 * v1165)) - v742) ^ 2) + ((((v751 * v1165) + (v747 * v1163)) - (0.34 : Float)) ^ 2))))
  let v1178 := (if v1177 then v1162 else v1159)
  let v1179 := (if v1177 then v1160 else v1162)
  let v1181 := ((v1178 + v1179) / (2 : Float))
  let v1182 := (Float.cos v1181)
  let v1184 := (Float.sin v1181)
  let v1196 := (v796 < (Float.sqrt (((((v743 * v1182) + (v747 * v1184)) - v742) ^ 2) + ((((v751 * v1184) + (v747 * v1182)) - (0.34 : Float)) ^ 2))))
  let v1197 := (if v1196 then v1181 else v1178)
  let v1198 := (if v1196 then v1179 else v1181)
  let v1200 := ((v1197 + v1198) / (2 : Float))
  let v1201 := (Float.cos v1200)
  let v1203 := (Float.sin v1200)
  let v1215 := (v796 < (Float.sqrt (((((v743 * v1201) + (v747 * v1203)) - v742) ^ 2) + ((((v751 * v1203) + (v747 * v1201)) - (0.34 : Float)) ^ 2))))
  let v1216 := (if v1215 then v1200 else v1197)
  let v1217 := (if v1215 then v1198 else v1200)
  let v1219 := ((v1216 + v1217) / (2 : Float))
  let v1220 := (Float.cos v1219)
  let v1222 := (Float.sin v1219)
  let v1234 := (v796 < (Float.sqrt (((((v743 * v1220) + (v747 * v1222)) - v742) ^ 2) + ((((v751 * v1222) + (v747 * v1220)) - (0.34 : Float)) ^ 2))))
  let v1235 := (if v1234 then v1219 else v1216)
  let v1236 := (if v1234 then v1217 else v1219)
  let v1238 := ((v1235 + v1236) / (2 : Float))
  let v1239 := (Float.cos v1238)
  let v1241 := (Float.sin v1238)
  let v1253 := (v796 < (Float.sqrt (((((v743 * v1239) + (v747 * v1241)) - v742) ^ 2) + ((((v751 * v1241) + (v747 * v1239)) - (0.34 : Float)) ^ 2))))
  let v1258 := (if (v760 <= v792) then (0 : Float) else (((if v1253 then v1238 else v1235) + (if v1253 then v1236 else v1238)) / (2 : Float)))
  let v1259 := (W * rcm)
  let v1260 := (Float.cos v1258)
  let v1262 := (Float.sin v1258)
  let v1264 := ((v743 * v1260) + (v747 * v1262))
  let v1267 := ((v751 * v1262) + (v747 * v1260))
  let v1282 := ((t < v1258) && (!(v1259 <= (Tmax * (((v742 * v1267) - ((0.34 : Float) * v1264)) / (Float.sqrt (((v1264 - v742) ^ 2) + ((v1267 - (0.34 : Float)) ^ 2))))))))
  let v1283 := (if v1282 then t else v1258)
  let v1288 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1293 := (Float.cos v1283)
  let v1295 := (Float.sin v1283)
  let v1297 := ((v743 * v1293) + (v747 * v1295))
  let v1300 := ((v751 * v1295) + (v747 * v1293))
  let v1320 := (v777 * (Float.cos az))
  let v1322 := (v777 * (Float.sin az))
  let v1323 := (Float.cos elSun)
  let v1325 := (v1323 * (Float.cos azSun))
  let v1327 := (v1323 * (Float.sin azSun))
  let v1328 := (Float.sin elSun)
  let v1333 := (((v1320 * v1325) + (v1322 * v1327)) + (v775 * v1328))
  let v1348 := (Float.sqrt (((((v1322 * v1328) - (v775 * v1327)) ^ 2) + (((v775 * v1325) - (v1320 * v1328)) ^ 2)) + (((v1320 * v1327) - (v1322 * v1325)) ^ 2)))
  let v1358 := (if (v1333 <= (0 : Float)) then (v734 + (Float.atan ((-v1333) / (max v1348 (0.000000000001 : Float))))) else (Float.atan (v1348 / v1333)))
  let v1360 := (v734 - v741)
  let v1361 := (v1360 <= elSun)
  let v1375 := (Float.cos v1288)
  let v1376 := (v1295 * v1375)
  let v1377 := (Float.sin v1288)
  let v1378 := (v1295 * v1377)
  let v1379 := (v1293 * v1375)
  let v1380 := (v1293 * v1377)
  let v1381 := (-v1295)
  let v1406 := ((2 : Float) * a)
  let v1407 := (v1406 / w)
  let v1409 := (w / (2 : Float))
  let v1410 := ((-a) + v1409)
  let v1429 := ((1 : Float) / (2 : Float))
  let v1434 := (-(((((v1380 * v1293) - (v1381 * v1378)) * v1325) + (((v1381 * v1376) - (v1379 * v1293)) * v1327)) + (((v1379 * v1378) - (v1380 * v1376)) * v1328)))
  let v1435 := (-(((v1379 * v1325) + (v1380 * v1327)) + (v1381 * v1328)))
  let v1436 := (-(((v1376 * v1325) + (v1378 * v1327)) + (v1293 * v1328)))
  let v1441 := ((Float.abs v1436) < ((9 : Float) / (10 : Float)))
  let v1442 := (if v1441 then (0 : Float) else (1 : Float))
  let v1443 := (if v1441 then (1 : Float) else (0 : Float))
  let v1446 := ((v1435 * v1443) - (v1436 * (0 : Float)))
  let v1449 := ((v1436 * v1442) - (v1434 * v1443))
  let v1452 := ((v1434 * (0 : Float)) - (v1435 * v1442))
  let v1460 := (Float.sqrt (max (((v1446 ^ 2) + (v1449 ^ 2)) + (v1452 ^ 2)) (0.000000000000000001 : Float)))
  let v1461 := (v1446 / v1460)
  let v1462 := (v1449 / v1460)
  let v1463 := (v1452 / v1460)
  let v1475 := ((2 : Float) * (3.141592653589793 : Float))
  let v1512 := ((2 : Float) * f)
  let v1513 := ((1 : Float) / R)
  let v1622 := (v1406 ^ 2)
  let v1623 := (v1622 * rho)
  let v1629 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); v1617)) 0.0)
  let v1632 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (1.0 / (1.0 + Float.exp (-((rc - v1612) / (0.005 : Float))))))) 0.0)
  let v1650 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((0 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1655 := (((((v1650 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1666 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((1 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1671 := (((((v1666 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1682 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((2 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1687 := (((((v1682 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1699 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((3 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1704 := (((((v1699 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1716 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((4 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1721 := (((((v1716 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1733 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((5 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1738 := (((((v1733 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1750 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((6 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1755 := (((((v1750 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1767 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((7 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1772 := (((((v1767 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1777 := (Float.exp ((-(Upipe / (2 : Float))) / mcp))
  let v1779 := (Ta + ((hist[1]! - Ta) * v1777))
  let v1783 := ((min UAx mcp) * (max (0 : Float) (v1779 - Twall)))
  let v1788 := (Ta + ((ret[1]! - Ta) * v1777))
  let v1792 := (Ac / (8 : Float))
  let v1793 := ((eps * (0.0000000567 : Float)) * v1792)
  let v1795 := (Ta ^ 4)
  let v1798 := (hC * v1792)
  let v1804 := (v1788 + (((alpha * v1655) - ((v1793 * ((v1788 ^ 4) - v1795)) + (v1798 * (v1788 - Ta)))) / mcp))
  let v1814 := (v1804 + (((alpha * v1671) - ((v1793 * ((v1804 ^ 4) - v1795)) + (v1798 * (v1804 - Ta)))) / mcp))
  let v1824 := (v1814 + (((alpha * v1687) - ((v1793 * ((v1814 ^ 4) - v1795)) + (v1798 * (v1814 - Ta)))) / mcp))
  let v1834 := (v1824 + (((alpha * v1704) - ((v1793 * ((v1824 ^ 4) - v1795)) + (v1798 * (v1824 - Ta)))) / mcp))
  let v1844 := (v1834 + (((alpha * v1721) - ((v1793 * ((v1834 ^ 4) - v1795)) + (v1798 * (v1834 - Ta)))) / mcp))
  let v1854 := (v1844 + (((alpha * v1738) - ((v1793 * ((v1844 ^ 4) - v1795)) + (v1798 * (v1844 - Ta)))) / mcp))
  let v1864 := (v1854 + (((alpha * v1755) - ((v1793 * ((v1854 ^ 4) - v1795)) + (v1798 * (v1854 - Ta)))) / mcp))
  let v1874 := (v1864 + (((alpha * v1772) - ((v1793 * ((v1864 ^ 4) - v1795)) + (v1798 * (v1864 - Ta)))) / mcp))
  let v1882 := (alpha * (((((((v1655 + v1671) + v1687) + v1704) + v1721) + v1738) + v1755) + v1772))
  let v1893 := (azSun - v1288)
  #[v1288, v1283, (if v794 then (v792 - v760) else (0 : Float)), (if v1282 then v788 else v796), v741, (if (v793 || v1282) then (1 : Float) else (0 : Float)), (if (feq (if v794 then (v792 - v760) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1259 <= (Tmax * (((v742 * v1300) - ((0.34 : Float) * v1297)) / (Float.sqrt (((v1297 - v742) ^ 2) + ((v1300 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (((v742 * v782) - ((0.34 : Float) * v779)) / v788), (v790 / (((v742 * v782) - ((0.34 : Float) * v779)) / v788)), ((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))), v1358, (v734 - t), (if v1361 then (1 : Float) else (0 : Float)), (if (v1361 && ((0.03 : Float) < v1358)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1360) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1360) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1358 - (0.03 : Float)) / (0.01 : Float)))))), (v1629 / (64 : Float)), (v1632 / (64 : Float)), (v1623 * (v1629 / (64 : Float))), (((v1623 * (v1629 / (64 : Float))) * dni) * soil), v1874, v1882, (v1882 - (mcp * (v1874 - v1788))), (mcp * ((hist[1]! - v1779) + (ret[1]! - v1788))), v1783, (((v1882 - (v1882 - (mcp * (v1874 - v1788)))) - (mcp * ((hist[1]! - v1779) + (ret[1]! - v1788)))) - v1783), (v1893 - (v1475 * (Float.floor ((v1893 + (3.141592653589793 : Float)) / v1475)))), ((v734 - v1283) - elSun), v1283, (if (feq (if v794 then (v792 - v760) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1259 <= (Tmax * (((v742 * v1300) - ((0.34 : Float) * v1297)) / (Float.sqrt (((v1297 - v742) ^ 2) + ((v1300 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), ((v1874 - (300 : Float)) / (300 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1360) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1360) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1358 - (0.03 : Float)) / (0.01 : Float)))))), v1655, v1671, v1687, v1704, v1721, v1738, v1755, v1772, v1804, v1814, v1824, v1834, v1844, v1854, v1864, v1874, v1874, hist[0]!, hist[1]!, hist[2]!, hist[3]!, hist[4]!, hist[5]!, hist[6]!, hist[7]!, hist[8]!, hist[9]!, hist[10]!, hist[11]!, hist[12]!, hist[13]!, hist[14]!, (v1779 - (v1783 / mcp)), ret[0]!, ret[1]!, ret[2]!, ret[3]!, ret[4]!, ret[5]!, ret[6]!, ret[7]!, ret[8]!, ret[9]!, ret[10]!, ret[11]!, ret[12]!, ret[13]!, ret[14]!]

#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.320123 1.261574 1.203025 1.144476 1.085928 1.027379 0.968830 0.910281 0.851732 0.793184 0.734635 0.676086 0.617537 0.558988 0.500440 0.441891 0.383342 0.324793 0.266244 0.207696 1.749147 1.690598 1.632049 1.573500 1.514952 1.456403 1.397854 1.339305 1.280756 1.222208 1.163659 1.105110 1.046561 0.988012 0.929464 0.870915 #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507] #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507] #[1.596739, 1.538190, 1.479641, 1.421092, 1.362544, 1.303995, 1.245446, 1.186897, 1.128348, 1.069800, 1.011251, 0.952702, 0.894153, 0.835604, 0.777056, 0.718507, 0.659958, 0.601409, 0.542860, 0.484312, 0.425763, 0.367214, 0.308665, 0.250116, 1.791568, 1.733019, 1.674470, 1.615921, 1.557372, 1.498824, 1.440275, 1.381726, 1.323177, 1.264628, 1.206080, 1.147531, 1.088982, 1.030433, 0.971884, 0.913336, 0.854787, 0.796238, 0.737689, 0.679140, 0.620592, 0.562043, 0.503494, 0.444945, 0.386396, 0.327848, 0.269299, 0.210750, 1.752201, 1.693652, 1.635104, 1.576555, 1.518006, 1.459457, 1.400908, 1.342360, 1.283811, 1.225262, 1.166713, 1.108164, 1.049616, 0.991067, 0.932518, 0.873969, 0.815420, 0.756872, 0.698323, 0.639774, 0.581225, 0.522676, 0.464128, 0.405579, 0.347030, 0.288481, 0.229932, 1.771384, 1.712835, 1.654286, 1.595737, 1.537188, 1.478640, 1.420091, 1.361542, 1.302993, 1.244444, 1.185896, 1.127347, 1.068798, 1.010249, 0.951700, 0.893152, 0.834603, 0.776054, 0.717505, 0.658956, 0.600408, 0.541859, 0.483310, 0.424761, 0.366212, 0.307664, 0.249115, 1.790566, 1.732017, 1.673468, 1.614920, 1.556371, 1.497822, 1.439273, 1.380724, 1.322176, 1.263627, 1.205078, 1.146529, 1.087980, 1.029432, 0.970883, 0.912334, 0.853785, 0.795236, 0.736688, 0.678139, 0.619590, 0.561041, 0.502492, 0.443944, 0.385395, 0.326846, 0.268297, 0.209748, 1.751200, 1.692651, 1.634102, 1.575553, 1.517004, 1.458456, 1.399907, 1.341358, 1.282809, 1.224260, 1.165712, 1.107163, 1.048614, 0.990065, 0.931516, 0.872968, 0.814419, 0.755870, 0.697321, 0.638772, 0.580224, 0.521675, 0.463126, 0.404577, 0.346028, 0.287480, 0.228931, 1.770382, 1.711833, 1.653284, 1.594736, 1.536187, 1.477638, 1.419089, 1.360540, 1.301992, 1.243443, 1.184894, 1.126345, 1.067796, 1.009248, 0.950699, 0.892150, 0.833601, 0.775052, 0.716504, 0.657955, 0.599406, 0.540857, 0.482308, 0.423760, 0.365211, 0.306662, 0.248113, 1.789564, 1.731016, 1.672467, 1.613918, 1.555369, 1.496820, 1.438272, 1.379723, 1.321174, 1.262625, 1.204076, 1.145528, 1.086979, 1.028430, 0.969881, 0.911332, 0.852784, 0.794235, 0.735686, 0.677137, 0.618588, 0.560040, 0.501491, 0.442942, 0.384393, 0.325844, 0.267296, 0.208747, 1.750198, 1.691649, 1.633100, 1.574552, 1.516003, 1.457454, 1.398905, 1.340356, 1.281808, 1.223259, 1.164710, 1.106161, 1.047612, 0.989064, 0.930515, 0.871966, 0.813417, 0.754868, 0.696320, 0.637771, 0.579222, 0.520673, 0.462124, 0.403576, 0.345027, 0.286478, 0.227929, 1.769380, 1.710832, 1.652283, 1.593734, 1.535185, 1.476636, 1.418088, 1.359539, 1.300990, 1.242441, 1.183892, 1.125344, 1.066795, 1.008246, 0.949697, 0.891148, 0.832600, 0.774051, 0.715502, 0.656953, 0.598404, 0.539856, 0.481307, 0.422758, 0.364209, 0.305660, 0.247112, 1.788563, 1.730014, 1.671465, 1.612916, 1.554368, 1.495819, 1.437270, 1.378721, 1.320172, 1.261624, 1.203075, 1.144526, 1.085977, 1.027428, 0.968880, 0.910331, 0.851782, 0.793233, 0.734684, 0.676136, 0.617587, 0.559038, 0.500489, 0.441940, 0.383392, 0.324843, 0.266294, 0.207745, 1.749196, 1.690648, 1.632099, 1.573550, 1.515001, 1.456452, 1.397904, 1.339355, 1.280806, 1.222257, 1.163708, 1.105160, 1.046611, 0.988062, 0.929513, 0.870964, 0.812416, 0.753867, 0.695318, 0.636769, 0.578220, 0.519672, 0.461123, 0.402574, 0.344025, 0.285476, 0.226928, 1.768379, 1.709830, 1.651281, 1.592732, 1.534184, 1.475635, 1.417086, 1.358537, 1.299988, 1.241440, 1.182891, 1.124342, 1.065793, 1.007244, 0.948696, 0.890147, 0.831598, 0.773049, 0.714500, 0.655952, 0.597403, 0.538854, 0.480305, 0.421756, 0.363208, 0.304659, 0.246110, 1.787561, 1.729012, 1.670464, 1.611915, 1.553366, 1.494817, 1.436268, 1.377720, 1.319171, 1.260622, 1.202073, 1.143524, 1.084976, 1.026427, 0.967878, 0.909329, 0.850780, 0.792232, 0.733683, 0.675134, 0.616585, 0.558036, 0.499488, 0.440939, 0.382390, 0.323841, 0.265292, 0.206744, 1.748195, 1.689646, 1.631097, 1.572548, 1.514000, 1.455451, 1.396902, 1.338353, 1.279804, 1.221256, 1.162707, 1.104158, 1.045609, 0.987060, 0.928512, 0.869963, 0.811414, 0.752865, 0.694316, 0.635768, 0.577219, 0.518670, 0.460121, 0.401572, 0.343024, 0.284475, 0.225926, 1.767377, 1.708828, 1.650280, 1.591731, 1.533182, 1.474633, 1.416084, 1.357536, 1.298987, 1.240438, 1.181889, 1.123340, 1.064792, 1.006243, 0.947694, 0.889145, 0.830596, 0.772048, 0.713499, 0.654950, 0.596401, 0.537852, 0.479304, 0.420755, 0.362206, 0.303657, 0.245108, 1.786560, 1.728011, 1.669462, 1.610913, 1.552364, 1.493816, 1.435267, 1.376718, 1.318169, 1.259620, 1.201072, 1.142523, 1.083974, 1.025425, 0.966876, 0.908328, 0.849779, 0.791230, 0.732681, 0.674132, 0.615584, 0.557035, 0.498486, 0.439937, 0.381388, 0.322840, 0.264291, 0.205742, 1.747193, 1.688644, 1.630096, 1.571547, 1.512998, 1.454449, 1.395900, 1.337352, 1.278803, 1.220254, 1.161705, 1.103156, 1.044608, 0.986059, 0.927510, 0.868961, 0.810412, 0.751864, 0.693315, 0.634766, 0.576217, 0.517668, 0.459120, 0.400571, 0.342022, 0.283473, 0.224924, 1.766376, 1.707827, 1.649278, 1.590729, 1.532180, 1.473632, 1.415083, 1.356534, 1.297985, 1.239436, 1.180888, 1.122339, 1.063790, 1.005241, 0.946692, 0.888144, 0.829595, 0.771046, 0.712497, 0.653948, 0.595400, 0.536851, 0.478302, 0.419753, 0.361204, 0.302656, 0.244107, 1.785558, 1.727009, 1.668460, 1.609912, 1.551363, 1.492814, 1.434265, 1.375716, 1.317168, 1.258619, 1.200070, 1.141521, 1.082972, 1.024424, 0.965875, 0.907326, 0.848777, 0.790228, 0.731680, 0.673131, 0.614582, 0.556033, 0.497484, 0.438936, 0.380387, 0.321838, 0.263289, 0.204740, 1.746192, 1.687643, 1.629094, 1.570545, 1.511996, 1.453448, 1.394899, 1.336350, 1.277801, 1.219252, 1.160704, 1.102155, 1.043606, 0.985057, 0.926508, 0.867960, 0.809411, 0.750862, 0.692313, 0.633764, 0.575216, 0.516667, 0.458118, 0.399569, 0.341020, 0.282472, 0.223923, 1.765374, 1.706825, 1.648276, 1.589728, 1.531179, 1.472630, 1.414081, 1.355532, 1.296984, 1.238435, 1.179886, 1.121337, 1.062788, 1.004240, 0.945691, 0.887142, 0.828593, 0.770044, 0.711496, 0.652947, 0.594398, 0.535849, 0.477300, 0.418752, 0.360203, 0.301654, 0.243105, 1.784556, 1.726008, 1.667459, 1.608910, 1.550361, 1.491812, 1.433264, 1.374715, 1.316166, 1.257617, 1.199068, 1.140520, 1.081971, 1.023422, 0.964873, 0.906324, 0.847776, 0.789227, 0.730678, 0.672129, 0.613580, 0.555032, 0.496483, 0.437934, 0.379385, 0.320836, 0.262288, 0.203739, 1.745190, 1.686641, 1.628092, 1.569544, 1.510995, 1.452446, 1.393897, 1.335348, 1.276800, 1.218251, 1.159702, 1.101153, 1.042604, 0.984056]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.988931 0.930382 0.871833 0.813284 0.754736 0.696187 0.637638 0.579089 0.520540 0.461992 0.403443 0.344894 0.286345 0.227796 1.769248 1.710699 1.652150 1.593601 1.535052 1.476504 1.417955 1.359406 1.300857 1.242308 1.183760 1.125211 1.066662 1.008113 0.949564 0.891016 0.832467 0.773918 0.715369 0.656820 0.598272 0.539723 #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315] #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315] #[1.265547, 1.206998, 1.148449, 1.089900, 1.031352, 0.972803, 0.914254, 0.855705, 0.797156, 0.738608, 0.680059, 0.621510, 0.562961, 0.504412, 0.445864, 0.387315, 0.328766, 0.270217, 0.211668, 1.753120, 1.694571, 1.636022, 1.577473, 1.518924, 1.460376, 1.401827, 1.343278, 1.284729, 1.226180, 1.167632, 1.109083, 1.050534, 0.991985, 0.933436, 0.874888, 0.816339, 0.757790, 0.699241, 0.640692, 0.582144, 0.523595, 0.465046, 0.406497, 0.347948, 0.289400, 0.230851, 1.772302, 1.713753, 1.655204, 1.596656, 1.538107, 1.479558, 1.421009, 1.362460, 1.303912, 1.245363, 1.186814, 1.128265, 1.069716, 1.011168, 0.952619, 0.894070, 0.835521, 0.776972, 0.718424, 0.659875, 0.601326, 0.542777, 0.484228, 0.425680, 0.367131, 0.308582, 0.250033, 1.791484, 1.732936, 1.674387, 1.615838, 1.557289, 1.498740, 1.440192, 1.381643, 1.323094, 1.264545, 1.205996, 1.147448, 1.088899, 1.030350, 0.971801, 0.913252, 0.854704, 0.796155, 0.737606, 0.679057, 0.620508, 0.561960, 0.503411, 0.444862, 0.386313, 0.327764, 0.269216, 0.210667, 1.752118, 1.693569, 1.635020, 1.576472, 1.517923, 1.459374, 1.400825, 1.342276, 1.283728, 1.225179, 1.166630, 1.108081, 1.049532, 0.990984, 0.932435, 0.873886, 0.815337, 0.756788, 0.698240, 0.639691, 0.581142, 0.522593, 0.464044, 0.405496, 0.346947, 0.288398, 0.229849, 1.771300, 1.712752, 1.654203, 1.595654, 1.537105, 1.478556, 1.420008, 1.361459, 1.302910, 1.244361, 1.185812, 1.127264, 1.068715, 1.010166, 0.951617, 0.893068, 0.834520, 0.775971, 0.717422, 0.658873, 0.600324, 0.541776, 0.483227, 0.424678, 0.366129, 0.307580, 0.249032, 1.790483, 1.731934, 1.673385, 1.614836, 1.556288, 1.497739, 1.439190, 1.380641, 1.322092, 1.263544, 1.204995, 1.146446, 1.087897, 1.029348, 0.970800, 0.912251, 0.853702, 0.795153, 0.736604, 0.678056, 0.619507, 0.560958, 0.502409, 0.443860, 0.385312, 0.326763, 0.268214, 0.209665, 1.751116, 1.692568, 1.634019, 1.575470, 1.516921, 1.458372, 1.399824, 1.341275, 1.282726, 1.224177, 1.165628, 1.107080, 1.048531, 0.989982, 0.931433, 0.872884, 0.814336, 0.755787, 0.697238, 0.638689, 0.580140, 0.521592, 0.463043, 0.404494, 0.345945, 0.287396, 0.228848, 1.770299, 1.711750, 1.653201, 1.594652, 1.536104, 1.477555, 1.419006, 1.360457, 1.301908, 1.243360, 1.184811, 1.126262, 1.067713, 1.009164, 0.950616, 0.892067, 0.833518, 0.774969, 0.716420, 0.657872, 0.599323, 0.540774, 0.482225, 0.423676, 0.365128, 0.306579, 0.248030, 1.789481, 1.730932, 1.672384, 1.613835, 1.555286, 1.496737, 1.438188, 1.379640, 1.321091, 1.262542, 1.203993, 1.145444, 1.086896, 1.028347, 0.969798, 0.911249, 0.852700, 0.794152, 0.735603, 0.677054, 0.618505, 0.559956, 0.501408, 0.442859, 0.384310, 0.325761, 0.267212, 0.208664, 1.750115, 1.691566, 1.633017, 1.574468, 1.515920, 1.457371, 1.398822, 1.340273, 1.281724, 1.223176, 1.164627, 1.106078, 1.047529, 0.988980, 0.930432, 0.871883, 0.813334, 0.754785, 0.696236, 0.637688, 0.579139, 0.520590, 0.462041, 0.403492, 0.344944, 0.286395, 0.227846, 1.769297, 1.710748, 1.652200, 1.593651, 1.535102, 1.476553, 1.418004, 1.359456, 1.300907, 1.242358, 1.183809, 1.125260, 1.066712, 1.008163, 0.949614, 0.891065, 0.832516, 0.773968, 0.715419, 0.656870, 0.598321, 0.539772, 0.481224, 0.422675, 0.364126, 0.305577, 0.247028, 1.788480, 1.729931, 1.671382, 1.612833, 1.554284, 1.495736, 1.437187, 1.378638, 1.320089, 1.261540, 1.202992, 1.144443, 1.085894, 1.027345, 0.968796, 0.910248, 0.851699, 0.793150, 0.734601, 0.676052, 0.617504, 0.558955, 0.500406, 0.441857, 0.383308, 0.324760, 0.266211, 0.207662, 1.749113, 1.690564, 1.632016, 1.573467, 1.514918, 1.456369, 1.397820, 1.339272, 1.280723, 1.222174, 1.163625, 1.105076, 1.046528, 0.987979, 0.929430, 0.870881, 0.812332, 0.753784, 0.695235, 0.636686, 0.578137, 0.519588, 0.461040, 0.402491, 0.343942, 0.285393, 0.226844, 1.768296, 1.709747, 1.651198, 1.592649, 1.534100, 1.475552, 1.417003, 1.358454, 1.299905, 1.241356, 1.182808, 1.124259, 1.065710, 1.007161, 0.948612, 0.890064, 0.831515, 0.772966, 0.714417, 0.655868, 0.597320, 0.538771, 0.480222, 0.421673, 0.363124, 0.304576, 0.246027, 1.787478, 1.728929, 1.670380, 1.611832, 1.553283, 1.494734, 1.436185, 1.377636, 1.319088, 1.260539, 1.201990, 1.143441, 1.084892, 1.026344, 0.967795, 0.909246, 0.850697, 0.792148, 0.733600, 0.675051, 0.616502, 0.557953, 0.499404, 0.440856, 0.382307, 0.323758, 0.265209, 0.206660, 1.748112, 1.689563, 1.631014, 1.572465, 1.513916, 1.455368, 1.396819, 1.338270, 1.279721, 1.221172, 1.162624, 1.104075, 1.045526, 0.986977, 0.928428, 0.869880, 0.811331, 0.752782, 0.694233, 0.635684, 0.577136, 0.518587, 0.460038, 0.401489, 0.342940, 0.284392, 0.225843, 1.767294, 1.708745, 1.650196, 1.591648, 1.533099, 1.474550, 1.416001, 1.357452, 1.298904, 1.240355, 1.181806, 1.123257, 1.064708, 1.006160, 0.947611, 0.889062, 0.830513, 0.771964, 0.713416, 0.654867, 0.596318, 0.537769, 0.479220, 0.420672, 0.362123, 0.303574, 0.245025, 1.786476, 1.727928, 1.669379, 1.610830, 1.552281, 1.493732, 1.435184, 1.376635, 1.318086, 1.259537, 1.200988, 1.142440, 1.083891, 1.025342, 0.966793, 0.908244, 0.849696, 0.791147, 0.732598, 0.674049, 0.615500, 0.556952, 0.498403, 0.439854, 0.381305, 0.322756, 0.264208, 0.205659, 1.747110, 1.688561, 1.630012, 1.571464, 1.512915, 1.454366, 1.395817, 1.337268, 1.278720, 1.220171, 1.161622, 1.103073, 1.044524, 0.985976, 0.927427, 0.868878, 0.810329, 0.751780, 0.693232, 0.634683, 0.576134, 0.517585, 0.459036, 0.400488, 0.341939, 0.283390, 0.224841, 1.766292, 1.707744, 1.649195, 1.590646, 1.532097, 1.473548, 1.415000, 1.356451, 1.297902, 1.239353, 1.180804, 1.122256, 1.063707, 1.005158, 0.946609, 0.888060, 0.829512, 0.770963, 0.712414, 0.653865, 0.595316, 0.536768, 0.478219, 0.419670, 0.361121, 0.302572, 0.244024, 1.785475, 1.726926, 1.668377, 1.609828, 1.551280, 1.492731, 1.434182, 1.375633, 1.317084, 1.258536, 1.199987, 1.141438, 1.082889, 1.024340, 0.965792, 0.907243, 0.848694, 0.790145, 0.731596, 0.673048, 0.614499, 0.555950, 0.497401, 0.438852, 0.380304, 0.321755, 0.263206, 0.204657, 1.746108, 1.687560, 1.629011, 1.570462, 1.511913, 1.453364, 1.394816, 1.336267, 1.277718, 1.219169, 1.160620, 1.102072, 1.043523, 0.984974, 0.926425, 0.867876, 0.809328, 0.750779, 0.692230, 0.633681, 0.575132, 0.516584, 0.458035, 0.399486, 0.340937, 0.282388, 0.223840, 1.765291, 1.706742, 1.648193, 1.589644, 1.531096, 1.472547, 1.413998, 1.355449, 1.296900, 1.238352, 1.179803, 1.121254, 1.062705, 1.004156, 0.945608, 0.887059, 0.828510, 0.769961, 0.711412, 0.652864]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.657739 0.599190 0.540641 0.482092 0.423544 0.364995 0.306446 0.247897 1.789348 1.730800 1.672251 1.613702 1.555153 1.496604 1.438056 1.379507 1.320958 1.262409 1.203860 1.145312 1.086763 1.028214 0.969665 0.911116 0.852568 0.794019 0.735470 0.676921 0.618372 0.559824 0.501275 0.442726 0.384177 0.325628 0.267080 0.208531 #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123] #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123] #[0.934355, 0.875806, 0.817257, 0.758708, 0.700160, 0.641611, 0.583062, 0.524513, 0.465964, 0.407416, 0.348867, 0.290318, 0.231769, 1.773220, 1.714672, 1.656123, 1.597574, 1.539025, 1.480476, 1.421928, 1.363379, 1.304830, 1.246281, 1.187732, 1.129184, 1.070635, 1.012086, 0.953537, 0.894988, 0.836440, 0.777891, 0.719342, 0.660793, 0.602244, 0.543696, 0.485147, 0.426598, 0.368049, 0.309500, 0.250952, 1.792403, 1.733854, 1.675305, 1.616756, 1.558208, 1.499659, 1.441110, 1.382561, 1.324012, 1.265464, 1.206915, 1.148366, 1.089817, 1.031268, 0.972720, 0.914171, 0.855622, 0.797073, 0.738524, 0.679976, 0.621427, 0.562878, 0.504329, 0.445780, 0.387232, 0.328683, 0.270134, 0.211585, 1.753036, 1.694488, 1.635939, 1.577390, 1.518841, 1.460292, 1.401744, 1.343195, 1.284646, 1.226097, 1.167548, 1.109000, 1.050451, 0.991902, 0.933353, 0.874804, 0.816256, 0.757707, 0.699158, 0.640609, 0.582060, 0.523512, 0.464963, 0.406414, 0.347865, 0.289316, 0.230768, 1.772219, 1.713670, 1.655121, 1.596572, 1.538024, 1.479475, 1.420926, 1.362377, 1.303828, 1.245280, 1.186731, 1.128182, 1.069633, 1.011084, 0.952536, 0.893987, 0.835438, 0.776889, 0.718340, 0.659792, 0.601243, 0.542694, 0.484145, 0.425596, 0.367048, 0.308499, 0.249950, 1.791401, 1.732852, 1.674304, 1.615755, 1.557206, 1.498657, 1.440108, 1.381560, 1.323011, 1.264462, 1.205913, 1.147364, 1.088816, 1.030267, 0.971718, 0.913169, 0.854620, 0.796072, 0.737523, 0.678974, 0.620425, 0.561876, 0.503328, 0.444779, 0.386230, 0.327681, 0.269132, 0.210584, 1.752035, 1.693486, 1.634937, 1.576388, 1.517840, 1.459291, 1.400742, 1.342193, 1.283644, 1.225096, 1.166547, 1.107998, 1.049449, 0.990900, 0.932352, 0.873803, 0.815254, 0.756705, 0.698156, 0.639608, 0.581059, 0.522510, 0.463961, 0.405412, 0.346864, 0.288315, 0.229766, 1.771217, 1.712668, 1.654120, 1.595571, 1.537022, 1.478473, 1.419924, 1.361376, 1.302827, 1.244278, 1.185729, 1.127180, 1.068632, 1.010083, 0.951534, 0.892985, 0.834436, 0.775888, 0.717339, 0.658790, 0.600241, 0.541692, 0.483144, 0.424595, 0.366046, 0.307497, 0.248948, 1.790400, 1.731851, 1.673302, 1.614753, 1.556204, 1.497656, 1.439107, 1.380558, 1.322009, 1.263460, 1.204912, 1.146363, 1.087814, 1.029265, 0.970716, 0.912168, 0.853619, 0.795070, 0.736521, 0.677972, 0.619424, 0.560875, 0.502326, 0.443777, 0.385228, 0.326680, 0.268131, 0.209582, 1.751033, 1.692484, 1.633936, 1.575387, 1.516838, 1.458289, 1.399740, 1.341192, 1.282643, 1.224094, 1.165545, 1.106996, 1.048448, 0.989899, 0.931350, 0.872801, 0.814252, 0.755704, 0.697155, 0.638606, 0.580057, 0.521508, 0.462960, 0.404411, 0.345862, 0.287313, 0.228764, 1.770216, 1.711667, 1.653118, 1.594569, 1.536020, 1.477472, 1.418923, 1.360374, 1.301825, 1.243276, 1.184728, 1.126179, 1.067630, 1.009081, 0.950532, 0.891984, 0.833435, 0.774886, 0.716337, 0.657788, 0.599240, 0.540691, 0.482142, 0.423593, 0.365044, 0.306496, 0.247947, 1.789398, 1.730849, 1.672300, 1.613752, 1.555203, 1.496654, 1.438105, 1.379556, 1.321008, 1.262459, 1.203910, 1.145361, 1.086812, 1.028264, 0.969715, 0.911166, 0.852617, 0.794068, 0.735520, 0.676971, 0.618422, 0.559873, 0.501324, 0.442776, 0.384227, 0.325678, 0.267129, 0.208580, 1.750032, 1.691483, 1.632934, 1.574385, 1.515836, 1.457288, 1.398739, 1.340190, 1.281641, 1.223092, 1.164544, 1.105995, 1.047446, 0.988897, 0.930348, 0.871800, 0.813251, 0.754702, 0.696153, 0.637604, 0.579056, 0.520507, 0.461958, 0.403409, 0.344860, 0.286312, 0.227763, 1.769214, 1.710665, 1.652116, 1.593568, 1.535019, 1.476470, 1.417921, 1.359372, 1.300824, 1.242275, 1.183726, 1.125177, 1.066628, 1.008080, 0.949531, 0.890982, 0.832433, 0.773884, 0.715336, 0.656787, 0.598238, 0.539689, 0.481140, 0.422592, 0.364043, 0.305494, 0.246945, 1.788396, 1.729848, 1.671299, 1.612750, 1.554201, 1.495652, 1.437104, 1.378555, 1.320006, 1.261457, 1.202908, 1.144360, 1.085811, 1.027262, 0.968713, 0.910164, 0.851616, 0.793067, 0.734518, 0.675969, 0.617420, 0.558872, 0.500323, 0.441774, 0.383225, 0.324676, 0.266128, 0.207579, 1.749030, 1.690481, 1.631932, 1.573384, 1.514835, 1.456286, 1.397737, 1.339188, 1.280640, 1.222091, 1.163542, 1.104993, 1.046444, 0.987896, 0.929347, 0.870798, 0.812249, 0.753700, 0.695152, 0.636603, 0.578054, 0.519505, 0.460956, 0.402408, 0.343859, 0.285310, 0.226761, 1.768212, 1.709664, 1.651115, 1.592566, 1.534017, 1.475468, 1.416920, 1.358371, 1.299822, 1.241273, 1.182724, 1.124176, 1.065627, 1.007078, 0.948529, 0.889980, 0.831432, 0.772883, 0.714334, 0.655785, 0.597236, 0.538688, 0.480139, 0.421590, 0.363041, 0.304492, 0.245944, 1.787395, 1.728846, 1.670297, 1.611748, 1.553200, 1.494651, 1.436102, 1.377553, 1.319004, 1.260456, 1.201907, 1.143358, 1.084809, 1.026260, 0.967712, 0.909163, 0.850614, 0.792065, 0.733516, 0.674968, 0.616419, 0.557870, 0.499321, 0.440772, 0.382224, 0.323675, 0.265126, 0.206577, 1.748028, 1.689480, 1.630931, 1.572382, 1.513833, 1.455284, 1.396736, 1.338187, 1.279638, 1.221089, 1.162540, 1.103992, 1.045443, 0.986894, 0.928345, 0.869796, 0.811248, 0.752699, 0.694150, 0.635601, 0.577052, 0.518504, 0.459955, 0.401406, 0.342857, 0.284308, 0.225760, 1.767211, 1.708662, 1.650113, 1.591564, 1.533016, 1.474467, 1.415918, 1.357369, 1.298820, 1.240272, 1.181723, 1.123174, 1.064625, 1.006076, 0.947528, 0.888979, 0.830430, 0.771881, 0.713332, 0.654784, 0.596235, 0.537686, 0.479137, 0.420588, 0.362040, 0.303491, 0.244942, 1.786393, 1.727844, 1.669296, 1.610747, 1.552198, 1.493649, 1.435100, 1.376552, 1.318003, 1.259454, 1.200905, 1.142356, 1.083808, 1.025259, 0.966710, 0.908161, 0.849612, 0.791064, 0.732515, 0.673966, 0.615417, 0.556868, 0.498320, 0.439771, 0.381222, 0.322673, 0.264124, 0.205576, 1.747027, 1.688478, 1.629929, 1.571380, 1.512832, 1.454283, 1.395734, 1.337185, 1.278636, 1.220088, 1.161539, 1.102990, 1.044441, 0.985892, 0.927344, 0.868795, 0.810246, 0.751697, 0.693148, 0.634600, 0.576051, 0.517502, 0.458953, 0.400404, 0.341856, 0.283307, 0.224758, 1.766209, 1.707660, 1.649112, 1.590563, 1.532014, 1.473465, 1.414916, 1.356368, 1.297819, 1.239270, 1.180721, 1.122172, 1.063624, 1.005075, 0.946526, 0.887977, 0.829428, 0.770880, 0.712331, 0.653782, 0.595233, 0.536684, 0.478136, 0.419587, 0.361038, 0.302489, 0.243940, 1.785392, 1.726843, 1.668294, 1.609745, 1.551196, 1.492648, 1.434099, 1.375550, 1.317001, 1.258452, 1.199904, 1.141355, 1.082806, 1.024257, 0.965708, 0.907160, 0.848611, 0.790062, 0.731513, 0.672964, 0.614416, 0.555867, 0.497318, 0.438769, 0.380220, 0.321672]).map Float.toBits))

def check_hashemiEnv_capture_mem (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (mcp : Float) (Twall : Float) (Ta : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v719 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v731 := ((1.22 : Float) * (0.8 : Float))
  let v732 := ((0.34 : Float) * v719)
  let v735 := ((3.141592653589793 : Float) / (2 : Float))
  let v742 := (if (v731 <= v732) then v735 else (Float.atan ((((1.22 : Float) * v719) + ((0.34 : Float) * (0.8 : Float))) / (v731 - v732))))
  let v743 := (-(1.22 : Float))
  let v744 := (-(0.8 : Float))
  let v745 := (Float.cos (0 : Float))
  let v747 := (-v719)
  let v748 := (Float.sin (0 : Float))
  let v751 := (-v744)
  let v760 := (Float.sqrt (((((v744 * v745) + (v747 * v748)) - v743) ^ 2) + ((((v751 * v748) + (v747 * v745)) - (0.34 : Float)) ^ 2)))
  let v761 := (Float.cos v742)
  let v763 := (Float.sin v742)
  let v774 := (Float.sqrt (((((v744 * v761) + (v747 * v763)) - v743) ^ 2) + ((((v751 * v763) + (v747 * v761)) - (0.34 : Float)) ^ 2)))
  let v775 := (Float.cos t)
  let v777 := (Float.sin t)
  let v779 := ((v744 * v775) + (v747 * v777))
  let v782 := ((v751 * v777) + (v747 * v775))
  let v788 := (Float.sqrt (((v779 - v743) ^ 2) + ((v782 - (0.34 : Float)) ^ 2)))
  let v790 := (omegad * rDrum)
  let v792 := ((v788 + slack) - (v790 * dt))
  let v793 := (v792 < v774)
  let v794 := (v760 < v792)
  let v796 := (if v793 then v774 else (if v794 then v760 else v792))
  let v801 := (((0 : Float) + v742) / (2 : Float))
  let v802 := (Float.cos v801)
  let v804 := (Float.sin v801)
  let v816 := (v796 < (Float.sqrt (((((v744 * v802) + (v747 * v804)) - v743) ^ 2) + ((((v751 * v804) + (v747 * v802)) - (0.34 : Float)) ^ 2))))
  let v817 := (if v816 then v801 else (0 : Float))
  let v818 := (if v816 then v742 else v801)
  let v820 := ((v817 + v818) / (2 : Float))
  let v821 := (Float.cos v820)
  let v823 := (Float.sin v820)
  let v835 := (v796 < (Float.sqrt (((((v744 * v821) + (v747 * v823)) - v743) ^ 2) + ((((v751 * v823) + (v747 * v821)) - (0.34 : Float)) ^ 2))))
  let v836 := (if v835 then v820 else v817)
  let v837 := (if v835 then v818 else v820)
  let v839 := ((v836 + v837) / (2 : Float))
  let v840 := (Float.cos v839)
  let v842 := (Float.sin v839)
  let v854 := (v796 < (Float.sqrt (((((v744 * v840) + (v747 * v842)) - v743) ^ 2) + ((((v751 * v842) + (v747 * v840)) - (0.34 : Float)) ^ 2))))
  let v855 := (if v854 then v839 else v836)
  let v856 := (if v854 then v837 else v839)
  let v858 := ((v855 + v856) / (2 : Float))
  let v859 := (Float.cos v858)
  let v861 := (Float.sin v858)
  let v873 := (v796 < (Float.sqrt (((((v744 * v859) + (v747 * v861)) - v743) ^ 2) + ((((v751 * v861) + (v747 * v859)) - (0.34 : Float)) ^ 2))))
  let v874 := (if v873 then v858 else v855)
  let v875 := (if v873 then v856 else v858)
  let v877 := ((v874 + v875) / (2 : Float))
  let v878 := (Float.cos v877)
  let v880 := (Float.sin v877)
  let v892 := (v796 < (Float.sqrt (((((v744 * v878) + (v747 * v880)) - v743) ^ 2) + ((((v751 * v880) + (v747 * v878)) - (0.34 : Float)) ^ 2))))
  let v893 := (if v892 then v877 else v874)
  let v894 := (if v892 then v875 else v877)
  let v896 := ((v893 + v894) / (2 : Float))
  let v897 := (Float.cos v896)
  let v899 := (Float.sin v896)
  let v911 := (v796 < (Float.sqrt (((((v744 * v897) + (v747 * v899)) - v743) ^ 2) + ((((v751 * v899) + (v747 * v897)) - (0.34 : Float)) ^ 2))))
  let v912 := (if v911 then v896 else v893)
  let v913 := (if v911 then v894 else v896)
  let v915 := ((v912 + v913) / (2 : Float))
  let v916 := (Float.cos v915)
  let v918 := (Float.sin v915)
  let v930 := (v796 < (Float.sqrt (((((v744 * v916) + (v747 * v918)) - v743) ^ 2) + ((((v751 * v918) + (v747 * v916)) - (0.34 : Float)) ^ 2))))
  let v931 := (if v930 then v915 else v912)
  let v932 := (if v930 then v913 else v915)
  let v934 := ((v931 + v932) / (2 : Float))
  let v935 := (Float.cos v934)
  let v937 := (Float.sin v934)
  let v949 := (v796 < (Float.sqrt (((((v744 * v935) + (v747 * v937)) - v743) ^ 2) + ((((v751 * v937) + (v747 * v935)) - (0.34 : Float)) ^ 2))))
  let v950 := (if v949 then v934 else v931)
  let v951 := (if v949 then v932 else v934)
  let v953 := ((v950 + v951) / (2 : Float))
  let v954 := (Float.cos v953)
  let v956 := (Float.sin v953)
  let v968 := (v796 < (Float.sqrt (((((v744 * v954) + (v747 * v956)) - v743) ^ 2) + ((((v751 * v956) + (v747 * v954)) - (0.34 : Float)) ^ 2))))
  let v969 := (if v968 then v953 else v950)
  let v970 := (if v968 then v951 else v953)
  let v972 := ((v969 + v970) / (2 : Float))
  let v973 := (Float.cos v972)
  let v975 := (Float.sin v972)
  let v987 := (v796 < (Float.sqrt (((((v744 * v973) + (v747 * v975)) - v743) ^ 2) + ((((v751 * v975) + (v747 * v973)) - (0.34 : Float)) ^ 2))))
  let v988 := (if v987 then v972 else v969)
  let v989 := (if v987 then v970 else v972)
  let v991 := ((v988 + v989) / (2 : Float))
  let v992 := (Float.cos v991)
  let v994 := (Float.sin v991)
  let v1006 := (v796 < (Float.sqrt (((((v744 * v992) + (v747 * v994)) - v743) ^ 2) + ((((v751 * v994) + (v747 * v992)) - (0.34 : Float)) ^ 2))))
  let v1007 := (if v1006 then v991 else v988)
  let v1008 := (if v1006 then v989 else v991)
  let v1010 := ((v1007 + v1008) / (2 : Float))
  let v1011 := (Float.cos v1010)
  let v1013 := (Float.sin v1010)
  let v1025 := (v796 < (Float.sqrt (((((v744 * v1011) + (v747 * v1013)) - v743) ^ 2) + ((((v751 * v1013) + (v747 * v1011)) - (0.34 : Float)) ^ 2))))
  let v1026 := (if v1025 then v1010 else v1007)
  let v1027 := (if v1025 then v1008 else v1010)
  let v1029 := ((v1026 + v1027) / (2 : Float))
  let v1030 := (Float.cos v1029)
  let v1032 := (Float.sin v1029)
  let v1044 := (v796 < (Float.sqrt (((((v744 * v1030) + (v747 * v1032)) - v743) ^ 2) + ((((v751 * v1032) + (v747 * v1030)) - (0.34 : Float)) ^ 2))))
  let v1045 := (if v1044 then v1029 else v1026)
  let v1046 := (if v1044 then v1027 else v1029)
  let v1048 := ((v1045 + v1046) / (2 : Float))
  let v1049 := (Float.cos v1048)
  let v1051 := (Float.sin v1048)
  let v1063 := (v796 < (Float.sqrt (((((v744 * v1049) + (v747 * v1051)) - v743) ^ 2) + ((((v751 * v1051) + (v747 * v1049)) - (0.34 : Float)) ^ 2))))
  let v1064 := (if v1063 then v1048 else v1045)
  let v1065 := (if v1063 then v1046 else v1048)
  let v1067 := ((v1064 + v1065) / (2 : Float))
  let v1068 := (Float.cos v1067)
  let v1070 := (Float.sin v1067)
  let v1082 := (v796 < (Float.sqrt (((((v744 * v1068) + (v747 * v1070)) - v743) ^ 2) + ((((v751 * v1070) + (v747 * v1068)) - (0.34 : Float)) ^ 2))))
  let v1083 := (if v1082 then v1067 else v1064)
  let v1084 := (if v1082 then v1065 else v1067)
  let v1086 := ((v1083 + v1084) / (2 : Float))
  let v1087 := (Float.cos v1086)
  let v1089 := (Float.sin v1086)
  let v1101 := (v796 < (Float.sqrt (((((v744 * v1087) + (v747 * v1089)) - v743) ^ 2) + ((((v751 * v1089) + (v747 * v1087)) - (0.34 : Float)) ^ 2))))
  let v1102 := (if v1101 then v1086 else v1083)
  let v1103 := (if v1101 then v1084 else v1086)
  let v1105 := ((v1102 + v1103) / (2 : Float))
  let v1106 := (Float.cos v1105)
  let v1108 := (Float.sin v1105)
  let v1120 := (v796 < (Float.sqrt (((((v744 * v1106) + (v747 * v1108)) - v743) ^ 2) + ((((v751 * v1108) + (v747 * v1106)) - (0.34 : Float)) ^ 2))))
  let v1121 := (if v1120 then v1105 else v1102)
  let v1122 := (if v1120 then v1103 else v1105)
  let v1124 := ((v1121 + v1122) / (2 : Float))
  let v1125 := (Float.cos v1124)
  let v1127 := (Float.sin v1124)
  let v1139 := (v796 < (Float.sqrt (((((v744 * v1125) + (v747 * v1127)) - v743) ^ 2) + ((((v751 * v1127) + (v747 * v1125)) - (0.34 : Float)) ^ 2))))
  let v1140 := (if v1139 then v1124 else v1121)
  let v1141 := (if v1139 then v1122 else v1124)
  let v1143 := ((v1140 + v1141) / (2 : Float))
  let v1144 := (Float.cos v1143)
  let v1146 := (Float.sin v1143)
  let v1158 := (v796 < (Float.sqrt (((((v744 * v1144) + (v747 * v1146)) - v743) ^ 2) + ((((v751 * v1146) + (v747 * v1144)) - (0.34 : Float)) ^ 2))))
  let v1159 := (if v1158 then v1143 else v1140)
  let v1160 := (if v1158 then v1141 else v1143)
  let v1162 := ((v1159 + v1160) / (2 : Float))
  let v1163 := (Float.cos v1162)
  let v1165 := (Float.sin v1162)
  let v1177 := (v796 < (Float.sqrt (((((v744 * v1163) + (v747 * v1165)) - v743) ^ 2) + ((((v751 * v1165) + (v747 * v1163)) - (0.34 : Float)) ^ 2))))
  let v1178 := (if v1177 then v1162 else v1159)
  let v1179 := (if v1177 then v1160 else v1162)
  let v1181 := ((v1178 + v1179) / (2 : Float))
  let v1182 := (Float.cos v1181)
  let v1184 := (Float.sin v1181)
  let v1196 := (v796 < (Float.sqrt (((((v744 * v1182) + (v747 * v1184)) - v743) ^ 2) + ((((v751 * v1184) + (v747 * v1182)) - (0.34 : Float)) ^ 2))))
  let v1197 := (if v1196 then v1181 else v1178)
  let v1198 := (if v1196 then v1179 else v1181)
  let v1200 := ((v1197 + v1198) / (2 : Float))
  let v1201 := (Float.cos v1200)
  let v1203 := (Float.sin v1200)
  let v1215 := (v796 < (Float.sqrt (((((v744 * v1201) + (v747 * v1203)) - v743) ^ 2) + ((((v751 * v1203) + (v747 * v1201)) - (0.34 : Float)) ^ 2))))
  let v1216 := (if v1215 then v1200 else v1197)
  let v1217 := (if v1215 then v1198 else v1200)
  let v1219 := ((v1216 + v1217) / (2 : Float))
  let v1220 := (Float.cos v1219)
  let v1222 := (Float.sin v1219)
  let v1234 := (v796 < (Float.sqrt (((((v744 * v1220) + (v747 * v1222)) - v743) ^ 2) + ((((v751 * v1222) + (v747 * v1220)) - (0.34 : Float)) ^ 2))))
  let v1235 := (if v1234 then v1219 else v1216)
  let v1236 := (if v1234 then v1217 else v1219)
  let v1238 := ((v1235 + v1236) / (2 : Float))
  let v1239 := (Float.cos v1238)
  let v1241 := (Float.sin v1238)
  let v1253 := (v796 < (Float.sqrt (((((v744 * v1239) + (v747 * v1241)) - v743) ^ 2) + ((((v751 * v1241) + (v747 * v1239)) - (0.34 : Float)) ^ 2))))
  let v1258 := (if (v760 <= v792) then (0 : Float) else (((if v1253 then v1238 else v1235) + (if v1253 then v1236 else v1238)) / (2 : Float)))
  let v1259 := (W * rcm)
  let v1260 := (Float.cos v1258)
  let v1262 := (Float.sin v1258)
  let v1264 := ((v744 * v1260) + (v747 * v1262))
  let v1267 := ((v751 * v1262) + (v747 * v1260))
  let v1282 := ((t < v1258) && (!(v1259 <= (Tmax * (((v743 * v1267) - ((0.34 : Float) * v1264)) / (Float.sqrt (((v1264 - v743) ^ 2) + ((v1267 - (0.34 : Float)) ^ 2))))))))
  let v1283 := (if v1282 then t else v1258)
  let v1288 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1293 := (Float.cos v1283)
  let v1295 := (Float.sin v1283)
  let v1323 := (Float.cos elSun)
  let v1325 := (v1323 * (Float.cos azSun))
  let v1327 := (v1323 * (Float.sin azSun))
  let v1328 := (Float.sin elSun)
  let v1375 := (Float.cos v1288)
  let v1376 := (v1295 * v1375)
  let v1377 := (Float.sin v1288)
  let v1378 := (v1295 * v1377)
  let v1379 := (v1293 * v1375)
  let v1380 := (v1293 * v1377)
  let v1381 := (-v1295)
  let v1406 := ((2 : Float) * a)
  let v1407 := (v1406 / w)
  let v1409 := (w / (2 : Float))
  let v1410 := ((-a) + v1409)
  let v1429 := ((1 : Float) / (2 : Float))
  let v1434 := (-(((((v1380 * v1293) - (v1381 * v1378)) * v1325) + (((v1381 * v1376) - (v1379 * v1293)) * v1327)) + (((v1379 * v1378) - (v1380 * v1376)) * v1328)))
  let v1435 := (-(((v1379 * v1325) + (v1380 * v1327)) + (v1381 * v1328)))
  let v1436 := (-(((v1376 * v1325) + (v1378 * v1327)) + (v1293 * v1328)))
  let v1441 := ((Float.abs v1436) < ((9 : Float) / (10 : Float)))
  let v1442 := (if v1441 then (0 : Float) else (1 : Float))
  let v1443 := (if v1441 then (1 : Float) else (0 : Float))
  let v1446 := ((v1435 * v1443) - (v1436 * (0 : Float)))
  let v1449 := ((v1436 * v1442) - (v1434 * v1443))
  let v1452 := ((v1434 * (0 : Float)) - (v1435 * v1442))
  let v1460 := (Float.sqrt (max (((v1446 ^ 2) + (v1449 ^ 2)) + (v1452 ^ 2)) (0.000000000000000001 : Float)))
  let v1461 := (v1446 / v1460)
  let v1462 := (v1449 / v1460)
  let v1463 := (v1452 / v1460)
  let v1475 := ((2 : Float) * (3.141592653589793 : Float))
  let v1512 := ((2 : Float) * f)
  let v1513 := ((1 : Float) / R)
  let v1629 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); v1617)) 0.0)
  let v1631 := (v1629 / (64 : Float))
  (((0 : Float) <= v1631) && (v1631 <= (1 : Float)))

#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.133971 1.075422 1.016873 0.958324 0.899776 0.841227 0.782678 0.724129 0.665580 0.607032 0.548483 0.489934 0.431385 0.372836 0.314288 0.255739 1.797190 1.738641 1.680092 1.621544 1.562995 1.504446 1.445897 1.387348 1.328800 1.270251 1.211702 1.153153 1.094604 1.036056 0.977507 0.918958 0.860409 0.801860 0.743312 0.684763 #[1.410587, 1.352038, 1.293489, 1.234940, 1.176392, 1.117843, 1.059294, 1.000745, 0.942196, 0.883648, 0.825099, 0.766550, 0.708001, 0.649452, 0.590904, 0.532355] #[1.410587, 1.352038, 1.293489, 1.234940, 1.176392, 1.117843, 1.059294, 1.000745, 0.942196, 0.883648, 0.825099, 0.766550, 0.708001, 0.649452, 0.590904, 0.532355] #[1.410587, 1.352038, 1.293489, 1.234940, 1.176392, 1.117843, 1.059294, 1.000745, 0.942196, 0.883648, 0.825099, 0.766550, 0.708001, 0.649452, 0.590904, 0.532355, 0.473806, 0.415257, 0.356708, 0.298160, 0.239611, 1.781062, 1.722513, 1.663964, 1.605416, 1.546867, 1.488318, 1.429769, 1.371220, 1.312672, 1.254123, 1.195574, 1.137025, 1.078476, 1.019928, 0.961379, 0.902830, 0.844281, 0.785732, 0.727184, 0.668635, 0.610086, 0.551537, 0.492988, 0.434440, 0.375891, 0.317342, 0.258793, 0.200244, 1.741696, 1.683147, 1.624598, 1.566049, 1.507500, 1.448952, 1.390403, 1.331854, 1.273305, 1.214756, 1.156208, 1.097659, 1.039110, 0.980561, 0.922012, 0.863464, 0.804915, 0.746366, 0.687817, 0.629268, 0.570720, 0.512171, 0.453622, 0.395073, 0.336524, 0.277976, 0.219427, 1.760878, 1.702329, 1.643780, 1.585232, 1.526683, 1.468134, 1.409585, 1.351036, 1.292488, 1.233939, 1.175390, 1.116841, 1.058292, 0.999744, 0.941195, 0.882646, 0.824097, 0.765548, 0.707000, 0.648451, 0.589902, 0.531353, 0.472804, 0.414256, 0.355707, 0.297158, 0.238609, 1.780060, 1.721512, 1.662963, 1.604414, 1.545865, 1.487316, 1.428768, 1.370219, 1.311670, 1.253121, 1.194572, 1.136024, 1.077475, 1.018926, 0.960377, 0.901828, 0.843280, 0.784731, 0.726182, 0.667633, 0.609084, 0.550536, 0.491987, 0.433438, 0.374889, 0.316340, 0.257792, 1.799243, 1.740694, 1.682145, 1.623596, 1.565048, 1.506499, 1.447950, 1.389401, 1.330852, 1.272304, 1.213755, 1.155206, 1.096657, 1.038108, 0.979560, 0.921011, 0.862462, 0.803913, 0.745364, 0.686816, 0.628267, 0.569718, 0.511169, 0.452620, 0.394072, 0.335523, 0.276974, 0.218425, 1.759876, 1.701328, 1.642779, 1.584230, 1.525681, 1.467132, 1.408584, 1.350035, 1.291486, 1.232937, 1.174388, 1.115840, 1.057291, 0.998742, 0.940193, 0.881644, 0.823096, 0.764547, 0.705998, 0.647449, 0.588900, 0.530352, 0.471803, 0.413254, 0.354705, 0.296156, 0.237608, 1.779059, 1.720510, 1.661961, 1.603412, 1.544864, 1.486315, 1.427766, 1.369217, 1.310668, 1.252120, 1.193571, 1.135022, 1.076473, 1.017924, 0.959376, 0.900827, 0.842278, 0.783729, 0.725180, 0.666632, 0.608083, 0.549534, 0.490985, 0.432436, 0.373888, 0.315339, 0.256790, 1.798241, 1.739692, 1.681144, 1.622595, 1.564046, 1.505497, 1.446948, 1.388400, 1.329851, 1.271302, 1.212753, 1.154204, 1.095656, 1.037107, 0.978558, 0.920009, 0.861460, 0.802912, 0.744363, 0.685814, 0.627265, 0.568716, 0.510168, 0.451619, 0.393070, 0.334521, 0.275972, 0.217424, 1.758875, 1.700326, 1.641777, 1.583228, 1.524680, 1.466131, 1.407582, 1.349033, 1.290484, 1.231936, 1.173387, 1.114838, 1.056289, 0.997740, 0.939192, 0.880643, 0.822094, 0.763545, 0.704996, 0.646448, 0.587899, 0.529350, 0.470801, 0.412252, 0.353704, 0.295155, 0.236606, 1.778057, 1.719508, 1.660960, 1.602411, 1.543862, 1.485313, 1.426764, 1.368216, 1.309667, 1.251118, 1.192569, 1.134020, 1.075472, 1.016923, 0.958374, 0.899825, 0.841276, 0.782728, 0.724179, 0.665630, 0.607081, 0.548532, 0.489984, 0.431435, 0.372886, 0.314337, 0.255788, 1.797240, 1.738691, 1.680142, 1.621593, 1.563044, 1.504496, 1.445947, 1.387398, 1.328849, 1.270300, 1.211752, 1.153203, 1.094654, 1.036105, 0.977556, 0.919008, 0.860459, 0.801910, 0.743361, 0.684812, 0.626264, 0.567715, 0.509166, 0.450617, 0.392068, 0.333520, 0.274971, 0.216422, 1.757873, 1.699324, 1.640776, 1.582227, 1.523678, 1.465129, 1.406580, 1.348032, 1.289483, 1.230934, 1.172385, 1.113836, 1.055288, 0.996739, 0.938190, 0.879641, 0.821092, 0.762544, 0.703995, 0.645446, 0.586897, 0.528348, 0.469800, 0.411251, 0.352702, 0.294153, 0.235604, 1.777056, 1.718507, 1.659958, 1.601409, 1.542860, 1.484312, 1.425763, 1.367214, 1.308665, 1.250116, 1.191568, 1.133019, 1.074470, 1.015921, 0.957372, 0.898824, 0.840275, 0.781726, 0.723177, 0.664628, 0.606080, 0.547531, 0.488982, 0.430433, 0.371884, 0.313336, 0.254787, 1.796238, 1.737689, 1.679140, 1.620592, 1.562043, 1.503494, 1.444945, 1.386396, 1.327848, 1.269299, 1.210750, 1.152201, 1.093652, 1.035104, 0.976555, 0.918006, 0.859457, 0.800908, 0.742360, 0.683811, 0.625262, 0.566713, 0.508164, 0.449616, 0.391067, 0.332518, 0.273969, 0.215420, 1.756872, 1.698323, 1.639774, 1.581225, 1.522676, 1.464128, 1.405579, 1.347030, 1.288481, 1.229932, 1.171384, 1.112835, 1.054286, 0.995737, 0.937188, 0.878640, 0.820091, 0.761542, 0.702993, 0.644444, 0.585896, 0.527347, 0.468798, 0.410249, 0.351700, 0.293152, 0.234603, 1.776054, 1.717505, 1.658956, 1.600408, 1.541859, 1.483310, 1.424761, 1.366212, 1.307664, 1.249115, 1.190566, 1.132017, 1.073468, 1.014920, 0.956371, 0.897822, 0.839273, 0.780724, 0.722176, 0.663627, 0.605078, 0.546529, 0.487980, 0.429432, 0.370883, 0.312334, 0.253785, 1.795236, 1.736688, 1.678139, 1.619590, 1.561041, 1.502492, 1.443944, 1.385395, 1.326846, 1.268297, 1.209748, 1.151200, 1.092651, 1.034102, 0.975553, 0.917004, 0.858456, 0.799907, 0.741358, 0.682809, 0.624260, 0.565712, 0.507163, 0.448614, 0.390065, 0.331516, 0.272968, 0.214419, 1.755870, 1.697321, 1.638772, 1.580224, 1.521675, 1.463126, 1.404577, 1.346028, 1.287480, 1.228931, 1.170382, 1.111833, 1.053284, 0.994736, 0.936187, 0.877638, 0.819089, 0.760540, 0.701992, 0.643443, 0.584894, 0.526345, 0.467796, 0.409248, 0.350699, 0.292150, 0.233601, 1.775052, 1.716504, 1.657955, 1.599406, 1.540857, 1.482308, 1.423760, 1.365211, 1.306662, 1.248113, 1.189564, 1.131016, 1.072467, 1.013918, 0.955369, 0.896820, 0.838272, 0.779723, 0.721174, 0.662625, 0.604076, 0.545528, 0.486979, 0.428430, 0.369881, 0.311332, 0.252784, 1.794235, 1.735686, 1.677137, 1.618588, 1.560040, 1.501491, 1.442942, 1.384393, 1.325844, 1.267296, 1.208747, 1.150198, 1.091649, 1.033100, 0.974552, 0.916003, 0.857454, 0.798905, 0.740356, 0.681808, 0.623259, 0.564710, 0.506161, 0.447612, 0.389064, 0.330515, 0.271966, 0.213417, 1.754868, 1.696320, 1.637771, 1.579222, 1.520673, 1.462124, 1.403576, 1.345027, 1.286478, 1.227929, 1.169380, 1.110832, 1.052283, 0.993734, 0.935185, 0.876636, 0.818088, 0.759539, 0.700990, 0.642441, 0.583892, 0.525344, 0.466795, 0.408246, 0.349697, 0.291148, 0.232600, 1.774051, 1.715502, 1.656953, 1.598404, 1.539856, 1.481307, 1.422758, 1.364209, 1.305660, 1.247112, 1.188563, 1.130014, 1.071465, 1.012916, 0.954368, 0.895819, 0.837270, 0.778721, 0.720172, 0.661624, 0.603075, 0.544526, 0.485977, 0.427428, 0.368880, 0.310331, 0.251782, 1.793233, 1.734684, 1.676136, 1.617587, 1.559038, 1.500489, 1.441940, 1.383392, 1.324843, 1.266294, 1.207745, 1.149196, 1.090648, 1.032099, 0.973550, 0.915001, 0.856452, 0.797904]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.802779 0.744230 0.685681 0.627132 0.568584 0.510035 0.451486 0.392937 0.334388 0.275840 0.217291 1.758742 1.700193 1.641644 1.583096 1.524547 1.465998 1.407449 1.348900 1.290352 1.231803 1.173254 1.114705 1.056156 0.997608 0.939059 0.880510 0.821961 0.763412 0.704864 0.646315 0.587766 0.529217 0.470668 0.412120 0.353571 #[1.079395, 1.020846, 0.962297, 0.903748, 0.845200, 0.786651, 0.728102, 0.669553, 0.611004, 0.552456, 0.493907, 0.435358, 0.376809, 0.318260, 0.259712, 0.201163] #[1.079395, 1.020846, 0.962297, 0.903748, 0.845200, 0.786651, 0.728102, 0.669553, 0.611004, 0.552456, 0.493907, 0.435358, 0.376809, 0.318260, 0.259712, 0.201163] #[1.079395, 1.020846, 0.962297, 0.903748, 0.845200, 0.786651, 0.728102, 0.669553, 0.611004, 0.552456, 0.493907, 0.435358, 0.376809, 0.318260, 0.259712, 0.201163, 1.742614, 1.684065, 1.625516, 1.566968, 1.508419, 1.449870, 1.391321, 1.332772, 1.274224, 1.215675, 1.157126, 1.098577, 1.040028, 0.981480, 0.922931, 0.864382, 0.805833, 0.747284, 0.688736, 0.630187, 0.571638, 0.513089, 0.454540, 0.395992, 0.337443, 0.278894, 0.220345, 1.761796, 1.703248, 1.644699, 1.586150, 1.527601, 1.469052, 1.410504, 1.351955, 1.293406, 1.234857, 1.176308, 1.117760, 1.059211, 1.000662, 0.942113, 0.883564, 0.825016, 0.766467, 0.707918, 0.649369, 0.590820, 0.532272, 0.473723, 0.415174, 0.356625, 0.298076, 0.239528, 1.780979, 1.722430, 1.663881, 1.605332, 1.546784, 1.488235, 1.429686, 1.371137, 1.312588, 1.254040, 1.195491, 1.136942, 1.078393, 1.019844, 0.961296, 0.902747, 0.844198, 0.785649, 0.727100, 0.668552, 0.610003, 0.551454, 0.492905, 0.434356, 0.375808, 0.317259, 0.258710, 0.200161, 1.741612, 1.683064, 1.624515, 1.565966, 1.507417, 1.448868, 1.390320, 1.331771, 1.273222, 1.214673, 1.156124, 1.097576, 1.039027, 0.980478, 0.921929, 0.863380, 0.804832, 0.746283, 0.687734, 0.629185, 0.570636, 0.512088, 0.453539, 0.394990, 0.336441, 0.277892, 0.219344, 1.760795, 1.702246, 1.643697, 1.585148, 1.526600, 1.468051, 1.409502, 1.350953, 1.292404, 1.233856, 1.175307, 1.116758, 1.058209, 0.999660, 0.941112, 0.882563, 0.824014, 0.765465, 0.706916, 0.648368, 0.589819, 0.531270, 0.472721, 0.414172, 0.355624, 0.297075, 0.238526, 1.779977, 1.721428, 1.662880, 1.604331, 1.545782, 1.487233, 1.428684, 1.370136, 1.311587, 1.253038, 1.194489, 1.135940, 1.077392, 1.018843, 0.960294, 0.901745, 0.843196, 0.784648, 0.726099, 0.667550, 0.609001, 0.550452, 0.491904, 0.433355, 0.374806, 0.316257, 0.257708, 1.799160, 1.740611, 1.682062, 1.623513, 1.564964, 1.506416, 1.447867, 1.389318, 1.330769, 1.272220, 1.213672, 1.155123, 1.096574, 1.038025, 0.979476, 0.920928, 0.862379, 0.803830, 0.745281, 0.686732, 0.628184, 0.569635, 0.511086, 0.452537, 0.393988, 0.335440, 0.276891, 0.218342, 1.759793, 1.701244, 1.642696, 1.584147, 1.525598, 1.467049, 1.408500, 1.349952, 1.291403, 1.232854, 1.174305, 1.115756, 1.057208, 0.998659, 0.940110, 0.881561, 0.823012, 0.764464, 0.705915, 0.647366, 0.588817, 0.530268, 0.471720, 0.413171, 0.354622, 0.296073, 0.237524, 1.778976, 1.720427, 1.661878, 1.603329, 1.544780, 1.486232, 1.427683, 1.369134, 1.310585, 1.252036, 1.193488, 1.134939, 1.076390, 1.017841, 0.959292, 0.900744, 0.842195, 0.783646, 0.725097, 0.666548, 0.608000, 0.549451, 0.490902, 0.432353, 0.373804, 0.315256, 0.256707, 1.798158, 1.739609, 1.681060, 1.622512, 1.563963, 1.505414, 1.446865, 1.388316, 1.329768, 1.271219, 1.212670, 1.154121, 1.095572, 1.037024, 0.978475, 0.919926, 0.861377, 0.802828, 0.744280, 0.685731, 0.627182, 0.568633, 0.510084, 0.451536, 0.392987, 0.334438, 0.275889, 0.217340, 1.758792, 1.700243, 1.641694, 1.583145, 1.524596, 1.466048, 1.407499, 1.348950, 1.290401, 1.231852, 1.173304, 1.114755, 1.056206, 0.997657, 0.939108, 0.880560, 0.822011, 0.763462, 0.704913, 0.646364, 0.587816, 0.529267, 0.470718, 0.412169, 0.353620, 0.295072, 0.236523, 1.777974, 1.719425, 1.660876, 1.602328, 1.543779, 1.485230, 1.426681, 1.368132, 1.309584, 1.251035, 1.192486, 1.133937, 1.075388, 1.016840, 0.958291, 0.899742, 0.841193, 0.782644, 0.724096, 0.665547, 0.606998, 0.548449, 0.489900, 0.431352, 0.372803, 0.314254, 0.255705, 1.797156, 1.738608, 1.680059, 1.621510, 1.562961, 1.504412, 1.445864, 1.387315, 1.328766, 1.270217, 1.211668, 1.153120, 1.094571, 1.036022, 0.977473, 0.918924, 0.860376, 0.801827, 0.743278, 0.684729, 0.626180, 0.567632, 0.509083, 0.450534, 0.391985, 0.333436, 0.274888, 0.216339, 1.757790, 1.699241, 1.640692, 1.582144, 1.523595, 1.465046, 1.406497, 1.347948, 1.289400, 1.230851, 1.172302, 1.113753, 1.055204, 0.996656, 0.938107, 0.879558, 0.821009, 0.762460, 0.703912, 0.645363, 0.586814, 0.528265, 0.469716, 0.411168, 0.352619, 0.294070, 0.235521, 1.776972, 1.718424, 1.659875, 1.601326, 1.542777, 1.484228, 1.425680, 1.367131, 1.308582, 1.250033, 1.191484, 1.132936, 1.074387, 1.015838, 0.957289, 0.898740, 0.840192, 0.781643, 0.723094, 0.664545, 0.605996, 0.547448, 0.488899, 0.430350, 0.371801, 0.313252, 0.254704, 1.796155, 1.737606, 1.679057, 1.620508, 1.561960, 1.503411, 1.444862, 1.386313, 1.327764, 1.269216, 1.210667, 1.152118, 1.093569, 1.035020, 0.976472, 0.917923, 0.859374, 0.800825, 0.742276, 0.683728, 0.625179, 0.566630, 0.508081, 0.449532, 0.390984, 0.332435, 0.273886, 0.215337, 1.756788, 1.698240, 1.639691, 1.581142, 1.522593, 1.464044, 1.405496, 1.346947, 1.288398, 1.229849, 1.171300, 1.112752, 1.054203, 0.995654, 0.937105, 0.878556, 0.820008, 0.761459, 0.702910, 0.644361, 0.585812, 0.527264, 0.468715, 0.410166, 0.351617, 0.293068, 0.234520, 1.775971, 1.717422, 1.658873, 1.600324, 1.541776, 1.483227, 1.424678, 1.366129, 1.307580, 1.249032, 1.190483, 1.131934, 1.073385, 1.014836, 0.956288, 0.897739, 0.839190, 0.780641, 0.722092, 0.663544, 0.604995, 0.546446, 0.487897, 0.429348, 0.370800, 0.312251, 0.253702, 1.795153, 1.736604, 1.678056, 1.619507, 1.560958, 1.502409, 1.443860, 1.385312, 1.326763, 1.268214, 1.209665, 1.151116, 1.092568, 1.034019, 0.975470, 0.916921, 0.858372, 0.799824, 0.741275, 0.682726, 0.624177, 0.565628, 0.507080, 0.448531, 0.389982, 0.331433, 0.272884, 0.214336, 1.755787, 1.697238, 1.638689, 1.580140, 1.521592, 1.463043, 1.404494, 1.345945, 1.287396, 1.228848, 1.170299, 1.111750, 1.053201, 0.994652, 0.936104, 0.877555, 0.819006, 0.760457, 0.701908, 0.643360, 0.584811, 0.526262, 0.467713, 0.409164, 0.350616, 0.292067, 0.233518, 1.774969, 1.716420, 1.657872, 1.599323, 1.540774, 1.482225, 1.423676, 1.365128, 1.306579, 1.248030, 1.189481, 1.130932, 1.072384, 1.013835, 0.955286, 0.896737, 0.838188, 0.779640, 0.721091, 0.662542, 0.603993, 0.545444, 0.486896, 0.428347, 0.369798, 0.311249, 0.252700, 1.794152, 1.735603, 1.677054, 1.618505, 1.559956, 1.501408, 1.442859, 1.384310, 1.325761, 1.267212, 1.208664, 1.150115, 1.091566, 1.033017, 0.974468, 0.915920, 0.857371, 0.798822, 0.740273, 0.681724, 0.623176, 0.564627, 0.506078, 0.447529, 0.388980, 0.330432, 0.271883, 0.213334, 1.754785, 1.696236, 1.637688, 1.579139, 1.520590, 1.462041, 1.403492, 1.344944, 1.286395, 1.227846, 1.169297, 1.110748, 1.052200, 0.993651, 0.935102, 0.876553, 0.818004, 0.759456, 0.700907, 0.642358, 0.583809, 0.525260, 0.466712]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.471587 0.413038 0.354489 0.295940 0.237392 1.778843 1.720294 1.661745 1.603196 1.544648 1.486099 1.427550 1.369001 1.310452 1.251904 1.193355 1.134806 1.076257 1.017708 0.959160 0.900611 0.842062 0.783513 0.724964 0.666416 0.607867 0.549318 0.490769 0.432220 0.373672 0.315123 0.256574 1.798025 1.739476 1.680928 1.622379 #[0.748203, 0.689654, 0.631105, 0.572556, 0.514008, 0.455459, 0.396910, 0.338361, 0.279812, 0.221264, 1.762715, 1.704166, 1.645617, 1.587068, 1.528520, 1.469971] #[0.748203, 0.689654, 0.631105, 0.572556, 0.514008, 0.455459, 0.396910, 0.338361, 0.279812, 0.221264, 1.762715, 1.704166, 1.645617, 1.587068, 1.528520, 1.469971] #[0.748203, 0.689654, 0.631105, 0.572556, 0.514008, 0.455459, 0.396910, 0.338361, 0.279812, 0.221264, 1.762715, 1.704166, 1.645617, 1.587068, 1.528520, 1.469971, 1.411422, 1.352873, 1.294324, 1.235776, 1.177227, 1.118678, 1.060129, 1.001580, 0.943032, 0.884483, 0.825934, 0.767385, 0.708836, 0.650288, 0.591739, 0.533190, 0.474641, 0.416092, 0.357544, 0.298995, 0.240446, 1.781897, 1.723348, 1.664800, 1.606251, 1.547702, 1.489153, 1.430604, 1.372056, 1.313507, 1.254958, 1.196409, 1.137860, 1.079312, 1.020763, 0.962214, 0.903665, 0.845116, 0.786568, 0.728019, 0.669470, 0.610921, 0.552372, 0.493824, 0.435275, 0.376726, 0.318177, 0.259628, 0.201080, 1.742531, 1.683982, 1.625433, 1.566884, 1.508336, 1.449787, 1.391238, 1.332689, 1.274140, 1.215592, 1.157043, 1.098494, 1.039945, 0.981396, 0.922848, 0.864299, 0.805750, 0.747201, 0.688652, 0.630104, 0.571555, 0.513006, 0.454457, 0.395908, 0.337360, 0.278811, 0.220262, 1.761713, 1.703164, 1.644616, 1.586067, 1.527518, 1.468969, 1.410420, 1.351872, 1.293323, 1.234774, 1.176225, 1.117676, 1.059128, 1.000579, 0.942030, 0.883481, 0.824932, 0.766384, 0.707835, 0.649286, 0.590737, 0.532188, 0.473640, 0.415091, 0.356542, 0.297993, 0.239444, 1.780896, 1.722347, 1.663798, 1.605249, 1.546700, 1.488152, 1.429603, 1.371054, 1.312505, 1.253956, 1.195408, 1.136859, 1.078310, 1.019761, 0.961212, 0.902664, 0.844115, 0.785566, 0.727017, 0.668468, 0.609920, 0.551371, 0.492822, 0.434273, 0.375724, 0.317176, 0.258627, 0.200078, 1.741529, 1.682980, 1.624432, 1.565883, 1.507334, 1.448785, 1.390236, 1.331688, 1.273139, 1.214590, 1.156041, 1.097492, 1.038944, 0.980395, 0.921846, 0.863297, 0.804748, 0.746200, 0.687651, 0.629102, 0.570553, 0.512004, 0.453456, 0.394907, 0.336358, 0.277809, 0.219260, 1.760712, 1.702163, 1.643614, 1.585065, 1.526516, 1.467968, 1.409419, 1.350870, 1.292321, 1.233772, 1.175224, 1.116675, 1.058126, 0.999577, 0.941028, 0.882480, 0.823931, 0.765382, 0.706833, 0.648284, 0.589736, 0.531187, 0.472638, 0.414089, 0.355540, 0.296992, 0.238443, 1.779894, 1.721345, 1.662796, 1.604248, 1.545699, 1.487150, 1.428601, 1.370052, 1.311504, 1.252955, 1.194406, 1.135857, 1.077308, 1.018760, 0.960211, 0.901662, 0.843113, 0.784564, 0.726016, 0.667467, 0.608918, 0.550369, 0.491820, 0.433272, 0.374723, 0.316174, 0.257625, 1.799076, 1.740528, 1.681979, 1.623430, 1.564881, 1.506332, 1.447784, 1.389235, 1.330686, 1.272137, 1.213588, 1.155040, 1.096491, 1.037942, 0.979393, 0.920844, 0.862296, 0.803747, 0.745198, 0.686649, 0.628100, 0.569552, 0.511003, 0.452454, 0.393905, 0.335356, 0.276808, 0.218259, 1.759710, 1.701161, 1.642612, 1.584064, 1.525515, 1.466966, 1.408417, 1.349868, 1.291320, 1.232771, 1.174222, 1.115673, 1.057124, 0.998576, 0.940027, 0.881478, 0.822929, 0.764380, 0.705832, 0.647283, 0.588734, 0.530185, 0.471636, 0.413088, 0.354539, 0.295990, 0.237441, 1.778892, 1.720344, 1.661795, 1.603246, 1.544697, 1.486148, 1.427600, 1.369051, 1.310502, 1.251953, 1.193404, 1.134856, 1.076307, 1.017758, 0.959209, 0.900660, 0.842112, 0.783563, 0.725014, 0.666465, 0.607916, 0.549368, 0.490819, 0.432270, 0.373721, 0.315172, 0.256624, 1.798075, 1.739526, 1.680977, 1.622428, 1.563880, 1.505331, 1.446782, 1.388233, 1.329684, 1.271136, 1.212587, 1.154038, 1.095489, 1.036940, 0.978392, 0.919843, 0.861294, 0.802745, 0.744196, 0.685648, 0.627099, 0.568550, 0.510001, 0.451452, 0.392904, 0.334355, 0.275806, 0.217257, 1.758708, 1.700160, 1.641611, 1.583062, 1.524513, 1.465964, 1.407416, 1.348867, 1.290318, 1.231769, 1.173220, 1.114672, 1.056123, 0.997574, 0.939025, 0.880476, 0.821928, 0.763379, 0.704830, 0.646281, 0.587732, 0.529184, 0.470635, 0.412086, 0.353537, 0.294988, 0.236440, 1.777891, 1.719342, 1.660793, 1.602244, 1.543696, 1.485147, 1.426598, 1.368049, 1.309500, 1.250952, 1.192403, 1.133854, 1.075305, 1.016756, 0.958208, 0.899659, 0.841110, 0.782561, 0.724012, 0.665464, 0.606915, 0.548366, 0.489817, 0.431268, 0.372720, 0.314171, 0.255622, 1.797073, 1.738524, 1.679976, 1.621427, 1.562878, 1.504329, 1.445780, 1.387232, 1.328683, 1.270134, 1.211585, 1.153036, 1.094488, 1.035939, 0.977390, 0.918841, 0.860292, 0.801744, 0.743195, 0.684646, 0.626097, 0.567548, 0.509000, 0.450451, 0.391902, 0.333353, 0.274804, 0.216256, 1.757707, 1.699158, 1.640609, 1.582060, 1.523512, 1.464963, 1.406414, 1.347865, 1.289316, 1.230768, 1.172219, 1.113670, 1.055121, 0.996572, 0.938024, 0.879475, 0.820926, 0.762377, 0.703828, 0.645280, 0.586731, 0.528182, 0.469633, 0.411084, 0.352536, 0.293987, 0.235438, 1.776889, 1.718340, 1.659792, 1.601243, 1.542694, 1.484145, 1.425596, 1.367048, 1.308499, 1.249950, 1.191401, 1.132852, 1.074304, 1.015755, 0.957206, 0.898657, 0.840108, 0.781560, 0.723011, 0.664462, 0.605913, 0.547364, 0.488816, 0.430267, 0.371718, 0.313169, 0.254620, 1.796072, 1.737523, 1.678974, 1.620425, 1.561876, 1.503328, 1.444779, 1.386230, 1.327681, 1.269132, 1.210584, 1.152035, 1.093486, 1.034937, 0.976388, 0.917840, 0.859291, 0.800742, 0.742193, 0.683644, 0.625096, 0.566547, 0.507998, 0.449449, 0.390900, 0.332352, 0.273803, 0.215254, 1.756705, 1.698156, 1.639608, 1.581059, 1.522510, 1.463961, 1.405412, 1.346864, 1.288315, 1.229766, 1.171217, 1.112668, 1.054120, 0.995571, 0.937022, 0.878473, 0.819924, 0.761376, 0.702827, 0.644278, 0.585729, 0.527180, 0.468632, 0.410083, 0.351534, 0.292985, 0.234436, 1.775888, 1.717339, 1.658790, 1.600241, 1.541692, 1.483144, 1.424595, 1.366046, 1.307497, 1.248948, 1.190400, 1.131851, 1.073302, 1.014753, 0.956204, 0.897656, 0.839107, 0.780558, 0.722009, 0.663460, 0.604912, 0.546363, 0.487814, 0.429265, 0.370716, 0.312168, 0.253619, 1.795070, 1.736521, 1.677972, 1.619424, 1.560875, 1.502326, 1.443777, 1.385228, 1.326680, 1.268131, 1.209582, 1.151033, 1.092484, 1.033936, 0.975387, 0.916838, 0.858289, 0.799740, 0.741192, 0.682643, 0.624094, 0.565545, 0.506996, 0.448448, 0.389899, 0.331350, 0.272801, 0.214252, 1.755704, 1.697155, 1.638606, 1.580057, 1.521508, 1.462960, 1.404411, 1.345862, 1.287313, 1.228764, 1.170216, 1.111667, 1.053118, 0.994569, 0.936020, 0.877472, 0.818923, 0.760374, 0.701825, 0.643276, 0.584728, 0.526179, 0.467630, 0.409081, 0.350532, 0.291984, 0.233435, 1.774886, 1.716337, 1.657788, 1.599240, 1.540691, 1.482142, 1.423593, 1.365044, 1.306496, 1.247947, 1.189398, 1.130849, 1.072300, 1.013752, 0.955203, 0.896654, 0.838105, 0.779556, 0.721008, 0.662459, 0.603910, 0.545361, 0.486812, 0.428264, 0.369715, 0.311166, 0.252617, 1.794068, 1.735520]))

def check_hashemiEnv_hist_head (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (mcp : Float) (Twall : Float) (Ta : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v718 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v730 := ((1.22 : Float) * (0.8 : Float))
  let v731 := ((0.34 : Float) * v718)
  let v734 := ((3.141592653589793 : Float) / (2 : Float))
  let v741 := (if (v730 <= v731) then v734 else (Float.atan ((((1.22 : Float) * v718) + ((0.34 : Float) * (0.8 : Float))) / (v730 - v731))))
  let v742 := (-(1.22 : Float))
  let v743 := (-(0.8 : Float))
  let v745 := (Float.cos (0 : Float))
  let v747 := (-v718)
  let v748 := (Float.sin (0 : Float))
  let v751 := (-v743)
  let v760 := (Float.sqrt (((((v743 * v745) + (v747 * v748)) - v742) ^ 2) + ((((v751 * v748) + (v747 * v745)) - (0.34 : Float)) ^ 2)))
  let v761 := (Float.cos v741)
  let v763 := (Float.sin v741)
  let v774 := (Float.sqrt (((((v743 * v761) + (v747 * v763)) - v742) ^ 2) + ((((v751 * v763) + (v747 * v761)) - (0.34 : Float)) ^ 2)))
  let v775 := (Float.cos t)
  let v777 := (Float.sin t)
  let v779 := ((v743 * v775) + (v747 * v777))
  let v782 := ((v751 * v777) + (v747 * v775))
  let v788 := (Float.sqrt (((v779 - v742) ^ 2) + ((v782 - (0.34 : Float)) ^ 2)))
  let v790 := (omegad * rDrum)
  let v792 := ((v788 + slack) - (v790 * dt))
  let v793 := (v792 < v774)
  let v794 := (v760 < v792)
  let v796 := (if v793 then v774 else (if v794 then v760 else v792))
  let v801 := (((0 : Float) + v741) / (2 : Float))
  let v802 := (Float.cos v801)
  let v804 := (Float.sin v801)
  let v816 := (v796 < (Float.sqrt (((((v743 * v802) + (v747 * v804)) - v742) ^ 2) + ((((v751 * v804) + (v747 * v802)) - (0.34 : Float)) ^ 2))))
  let v817 := (if v816 then v801 else (0 : Float))
  let v818 := (if v816 then v741 else v801)
  let v820 := ((v817 + v818) / (2 : Float))
  let v821 := (Float.cos v820)
  let v823 := (Float.sin v820)
  let v835 := (v796 < (Float.sqrt (((((v743 * v821) + (v747 * v823)) - v742) ^ 2) + ((((v751 * v823) + (v747 * v821)) - (0.34 : Float)) ^ 2))))
  let v836 := (if v835 then v820 else v817)
  let v837 := (if v835 then v818 else v820)
  let v839 := ((v836 + v837) / (2 : Float))
  let v840 := (Float.cos v839)
  let v842 := (Float.sin v839)
  let v854 := (v796 < (Float.sqrt (((((v743 * v840) + (v747 * v842)) - v742) ^ 2) + ((((v751 * v842) + (v747 * v840)) - (0.34 : Float)) ^ 2))))
  let v855 := (if v854 then v839 else v836)
  let v856 := (if v854 then v837 else v839)
  let v858 := ((v855 + v856) / (2 : Float))
  let v859 := (Float.cos v858)
  let v861 := (Float.sin v858)
  let v873 := (v796 < (Float.sqrt (((((v743 * v859) + (v747 * v861)) - v742) ^ 2) + ((((v751 * v861) + (v747 * v859)) - (0.34 : Float)) ^ 2))))
  let v874 := (if v873 then v858 else v855)
  let v875 := (if v873 then v856 else v858)
  let v877 := ((v874 + v875) / (2 : Float))
  let v878 := (Float.cos v877)
  let v880 := (Float.sin v877)
  let v892 := (v796 < (Float.sqrt (((((v743 * v878) + (v747 * v880)) - v742) ^ 2) + ((((v751 * v880) + (v747 * v878)) - (0.34 : Float)) ^ 2))))
  let v893 := (if v892 then v877 else v874)
  let v894 := (if v892 then v875 else v877)
  let v896 := ((v893 + v894) / (2 : Float))
  let v897 := (Float.cos v896)
  let v899 := (Float.sin v896)
  let v911 := (v796 < (Float.sqrt (((((v743 * v897) + (v747 * v899)) - v742) ^ 2) + ((((v751 * v899) + (v747 * v897)) - (0.34 : Float)) ^ 2))))
  let v912 := (if v911 then v896 else v893)
  let v913 := (if v911 then v894 else v896)
  let v915 := ((v912 + v913) / (2 : Float))
  let v916 := (Float.cos v915)
  let v918 := (Float.sin v915)
  let v930 := (v796 < (Float.sqrt (((((v743 * v916) + (v747 * v918)) - v742) ^ 2) + ((((v751 * v918) + (v747 * v916)) - (0.34 : Float)) ^ 2))))
  let v931 := (if v930 then v915 else v912)
  let v932 := (if v930 then v913 else v915)
  let v934 := ((v931 + v932) / (2 : Float))
  let v935 := (Float.cos v934)
  let v937 := (Float.sin v934)
  let v949 := (v796 < (Float.sqrt (((((v743 * v935) + (v747 * v937)) - v742) ^ 2) + ((((v751 * v937) + (v747 * v935)) - (0.34 : Float)) ^ 2))))
  let v950 := (if v949 then v934 else v931)
  let v951 := (if v949 then v932 else v934)
  let v953 := ((v950 + v951) / (2 : Float))
  let v954 := (Float.cos v953)
  let v956 := (Float.sin v953)
  let v968 := (v796 < (Float.sqrt (((((v743 * v954) + (v747 * v956)) - v742) ^ 2) + ((((v751 * v956) + (v747 * v954)) - (0.34 : Float)) ^ 2))))
  let v969 := (if v968 then v953 else v950)
  let v970 := (if v968 then v951 else v953)
  let v972 := ((v969 + v970) / (2 : Float))
  let v973 := (Float.cos v972)
  let v975 := (Float.sin v972)
  let v987 := (v796 < (Float.sqrt (((((v743 * v973) + (v747 * v975)) - v742) ^ 2) + ((((v751 * v975) + (v747 * v973)) - (0.34 : Float)) ^ 2))))
  let v988 := (if v987 then v972 else v969)
  let v989 := (if v987 then v970 else v972)
  let v991 := ((v988 + v989) / (2 : Float))
  let v992 := (Float.cos v991)
  let v994 := (Float.sin v991)
  let v1006 := (v796 < (Float.sqrt (((((v743 * v992) + (v747 * v994)) - v742) ^ 2) + ((((v751 * v994) + (v747 * v992)) - (0.34 : Float)) ^ 2))))
  let v1007 := (if v1006 then v991 else v988)
  let v1008 := (if v1006 then v989 else v991)
  let v1010 := ((v1007 + v1008) / (2 : Float))
  let v1011 := (Float.cos v1010)
  let v1013 := (Float.sin v1010)
  let v1025 := (v796 < (Float.sqrt (((((v743 * v1011) + (v747 * v1013)) - v742) ^ 2) + ((((v751 * v1013) + (v747 * v1011)) - (0.34 : Float)) ^ 2))))
  let v1026 := (if v1025 then v1010 else v1007)
  let v1027 := (if v1025 then v1008 else v1010)
  let v1029 := ((v1026 + v1027) / (2 : Float))
  let v1030 := (Float.cos v1029)
  let v1032 := (Float.sin v1029)
  let v1044 := (v796 < (Float.sqrt (((((v743 * v1030) + (v747 * v1032)) - v742) ^ 2) + ((((v751 * v1032) + (v747 * v1030)) - (0.34 : Float)) ^ 2))))
  let v1045 := (if v1044 then v1029 else v1026)
  let v1046 := (if v1044 then v1027 else v1029)
  let v1048 := ((v1045 + v1046) / (2 : Float))
  let v1049 := (Float.cos v1048)
  let v1051 := (Float.sin v1048)
  let v1063 := (v796 < (Float.sqrt (((((v743 * v1049) + (v747 * v1051)) - v742) ^ 2) + ((((v751 * v1051) + (v747 * v1049)) - (0.34 : Float)) ^ 2))))
  let v1064 := (if v1063 then v1048 else v1045)
  let v1065 := (if v1063 then v1046 else v1048)
  let v1067 := ((v1064 + v1065) / (2 : Float))
  let v1068 := (Float.cos v1067)
  let v1070 := (Float.sin v1067)
  let v1082 := (v796 < (Float.sqrt (((((v743 * v1068) + (v747 * v1070)) - v742) ^ 2) + ((((v751 * v1070) + (v747 * v1068)) - (0.34 : Float)) ^ 2))))
  let v1083 := (if v1082 then v1067 else v1064)
  let v1084 := (if v1082 then v1065 else v1067)
  let v1086 := ((v1083 + v1084) / (2 : Float))
  let v1087 := (Float.cos v1086)
  let v1089 := (Float.sin v1086)
  let v1101 := (v796 < (Float.sqrt (((((v743 * v1087) + (v747 * v1089)) - v742) ^ 2) + ((((v751 * v1089) + (v747 * v1087)) - (0.34 : Float)) ^ 2))))
  let v1102 := (if v1101 then v1086 else v1083)
  let v1103 := (if v1101 then v1084 else v1086)
  let v1105 := ((v1102 + v1103) / (2 : Float))
  let v1106 := (Float.cos v1105)
  let v1108 := (Float.sin v1105)
  let v1120 := (v796 < (Float.sqrt (((((v743 * v1106) + (v747 * v1108)) - v742) ^ 2) + ((((v751 * v1108) + (v747 * v1106)) - (0.34 : Float)) ^ 2))))
  let v1121 := (if v1120 then v1105 else v1102)
  let v1122 := (if v1120 then v1103 else v1105)
  let v1124 := ((v1121 + v1122) / (2 : Float))
  let v1125 := (Float.cos v1124)
  let v1127 := (Float.sin v1124)
  let v1139 := (v796 < (Float.sqrt (((((v743 * v1125) + (v747 * v1127)) - v742) ^ 2) + ((((v751 * v1127) + (v747 * v1125)) - (0.34 : Float)) ^ 2))))
  let v1140 := (if v1139 then v1124 else v1121)
  let v1141 := (if v1139 then v1122 else v1124)
  let v1143 := ((v1140 + v1141) / (2 : Float))
  let v1144 := (Float.cos v1143)
  let v1146 := (Float.sin v1143)
  let v1158 := (v796 < (Float.sqrt (((((v743 * v1144) + (v747 * v1146)) - v742) ^ 2) + ((((v751 * v1146) + (v747 * v1144)) - (0.34 : Float)) ^ 2))))
  let v1159 := (if v1158 then v1143 else v1140)
  let v1160 := (if v1158 then v1141 else v1143)
  let v1162 := ((v1159 + v1160) / (2 : Float))
  let v1163 := (Float.cos v1162)
  let v1165 := (Float.sin v1162)
  let v1177 := (v796 < (Float.sqrt (((((v743 * v1163) + (v747 * v1165)) - v742) ^ 2) + ((((v751 * v1165) + (v747 * v1163)) - (0.34 : Float)) ^ 2))))
  let v1178 := (if v1177 then v1162 else v1159)
  let v1179 := (if v1177 then v1160 else v1162)
  let v1181 := ((v1178 + v1179) / (2 : Float))
  let v1182 := (Float.cos v1181)
  let v1184 := (Float.sin v1181)
  let v1196 := (v796 < (Float.sqrt (((((v743 * v1182) + (v747 * v1184)) - v742) ^ 2) + ((((v751 * v1184) + (v747 * v1182)) - (0.34 : Float)) ^ 2))))
  let v1197 := (if v1196 then v1181 else v1178)
  let v1198 := (if v1196 then v1179 else v1181)
  let v1200 := ((v1197 + v1198) / (2 : Float))
  let v1201 := (Float.cos v1200)
  let v1203 := (Float.sin v1200)
  let v1215 := (v796 < (Float.sqrt (((((v743 * v1201) + (v747 * v1203)) - v742) ^ 2) + ((((v751 * v1203) + (v747 * v1201)) - (0.34 : Float)) ^ 2))))
  let v1216 := (if v1215 then v1200 else v1197)
  let v1217 := (if v1215 then v1198 else v1200)
  let v1219 := ((v1216 + v1217) / (2 : Float))
  let v1220 := (Float.cos v1219)
  let v1222 := (Float.sin v1219)
  let v1234 := (v796 < (Float.sqrt (((((v743 * v1220) + (v747 * v1222)) - v742) ^ 2) + ((((v751 * v1222) + (v747 * v1220)) - (0.34 : Float)) ^ 2))))
  let v1235 := (if v1234 then v1219 else v1216)
  let v1236 := (if v1234 then v1217 else v1219)
  let v1238 := ((v1235 + v1236) / (2 : Float))
  let v1239 := (Float.cos v1238)
  let v1241 := (Float.sin v1238)
  let v1253 := (v796 < (Float.sqrt (((((v743 * v1239) + (v747 * v1241)) - v742) ^ 2) + ((((v751 * v1241) + (v747 * v1239)) - (0.34 : Float)) ^ 2))))
  let v1258 := (if (v760 <= v792) then (0 : Float) else (((if v1253 then v1238 else v1235) + (if v1253 then v1236 else v1238)) / (2 : Float)))
  let v1259 := (W * rcm)
  let v1260 := (Float.cos v1258)
  let v1262 := (Float.sin v1258)
  let v1264 := ((v743 * v1260) + (v747 * v1262))
  let v1267 := ((v751 * v1262) + (v747 * v1260))
  let v1282 := ((t < v1258) && (!(v1259 <= (Tmax * (((v742 * v1267) - ((0.34 : Float) * v1264)) / (Float.sqrt (((v1264 - v742) ^ 2) + ((v1267 - (0.34 : Float)) ^ 2))))))))
  let v1283 := (if v1282 then t else v1258)
  let v1288 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1293 := (Float.cos v1283)
  let v1295 := (Float.sin v1283)
  let v1323 := (Float.cos elSun)
  let v1325 := (v1323 * (Float.cos azSun))
  let v1327 := (v1323 * (Float.sin azSun))
  let v1328 := (Float.sin elSun)
  let v1375 := (Float.cos v1288)
  let v1376 := (v1295 * v1375)
  let v1377 := (Float.sin v1288)
  let v1378 := (v1295 * v1377)
  let v1379 := (v1293 * v1375)
  let v1380 := (v1293 * v1377)
  let v1381 := (-v1295)
  let v1406 := ((2 : Float) * a)
  let v1407 := (v1406 / w)
  let v1409 := (w / (2 : Float))
  let v1410 := ((-a) + v1409)
  let v1429 := ((1 : Float) / (2 : Float))
  let v1434 := (-(((((v1380 * v1293) - (v1381 * v1378)) * v1325) + (((v1381 * v1376) - (v1379 * v1293)) * v1327)) + (((v1379 * v1378) - (v1380 * v1376)) * v1328)))
  let v1435 := (-(((v1379 * v1325) + (v1380 * v1327)) + (v1381 * v1328)))
  let v1436 := (-(((v1376 * v1325) + (v1378 * v1327)) + (v1293 * v1328)))
  let v1441 := ((Float.abs v1436) < ((9 : Float) / (10 : Float)))
  let v1442 := (if v1441 then (0 : Float) else (1 : Float))
  let v1443 := (if v1441 then (1 : Float) else (0 : Float))
  let v1446 := ((v1435 * v1443) - (v1436 * (0 : Float)))
  let v1449 := ((v1436 * v1442) - (v1434 * v1443))
  let v1452 := ((v1434 * (0 : Float)) - (v1435 * v1442))
  let v1460 := (Float.sqrt (max (((v1446 ^ 2) + (v1449 ^ 2)) + (v1452 ^ 2)) (0.000000000000000001 : Float)))
  let v1461 := (v1446 / v1460)
  let v1462 := (v1449 / v1460)
  let v1463 := (v1452 / v1460)
  let v1475 := ((2 : Float) * (3.141592653589793 : Float))
  let v1512 := ((2 : Float) * f)
  let v1513 := ((1 : Float) / R)
  let v1622 := (v1406 ^ 2)
  let v1650 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((0 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1655 := (((((v1650 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1666 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((1 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1671 := (((((v1666 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1682 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((2 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1687 := (((((v1682 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1699 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((3 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1704 := (((((v1699 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1716 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((4 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1721 := (((((v1716 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1733 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((5 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1738 := (((((v1733 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1750 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((6 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1755 := (((((v1750 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1767 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1509 := (((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); let v1614 := ((0 : Float) < v1602); let v1615 := ((v1612 <= rc) && v1614); let v1617 := (if (v1509 && v1615) then (1 : Float) else (0 : Float)); let v1647 := (v1617 > (0.5 : Float)); (if ((((((7 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v1647) then (1 : Float) else (0 : Float)))) 0.0)
  let v1772 := (((((v1767 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1777 := (Float.exp ((-(Upipe / (2 : Float))) / mcp))
  let v1788 := (Ta + ((ret[1]! - Ta) * v1777))
  let v1792 := (Ac / (8 : Float))
  let v1793 := ((eps * (0.0000000567 : Float)) * v1792)
  let v1795 := (Ta ^ 4)
  let v1798 := (hC * v1792)
  let v1804 := (v1788 + (((alpha * v1655) - ((v1793 * ((v1788 ^ 4) - v1795)) + (v1798 * (v1788 - Ta)))) / mcp))
  let v1814 := (v1804 + (((alpha * v1671) - ((v1793 * ((v1804 ^ 4) - v1795)) + (v1798 * (v1804 - Ta)))) / mcp))
  let v1824 := (v1814 + (((alpha * v1687) - ((v1793 * ((v1814 ^ 4) - v1795)) + (v1798 * (v1814 - Ta)))) / mcp))
  let v1834 := (v1824 + (((alpha * v1704) - ((v1793 * ((v1824 ^ 4) - v1795)) + (v1798 * (v1824 - Ta)))) / mcp))
  let v1844 := (v1834 + (((alpha * v1721) - ((v1793 * ((v1834 ^ 4) - v1795)) + (v1798 * (v1834 - Ta)))) / mcp))
  let v1854 := (v1844 + (((alpha * v1738) - ((v1793 * ((v1844 ^ 4) - v1795)) + (v1798 * (v1844 - Ta)))) / mcp))
  let v1864 := (v1854 + (((alpha * v1755) - ((v1793 * ((v1854 ^ 4) - v1795)) + (v1798 * (v1854 - Ta)))) / mcp))
  let v1874 := (v1864 + (((alpha * v1772) - ((v1793 * ((v1864 ^ 4) - v1795)) + (v1798 * (v1864 - Ta)))) / mcp))
  (feq v1874 v1874)

#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.947819 0.889270 0.830721 0.772172 0.713624 0.655075 0.596526 0.537977 0.479428 0.420880 0.362331 0.303782 0.245233 1.786684 1.728136 1.669587 1.611038 1.552489 1.493940 1.435392 1.376843 1.318294 1.259745 1.201196 1.142648 1.084099 1.025550 0.967001 0.908452 0.849904 0.791355 0.732806 0.674257 0.615708 0.557160 0.498611 #[1.224435, 1.165886, 1.107337, 1.048788, 0.990240, 0.931691, 0.873142, 0.814593, 0.756044, 0.697496, 0.638947, 0.580398, 0.521849, 0.463300, 0.404752, 0.346203] #[1.224435, 1.165886, 1.107337, 1.048788, 0.990240, 0.931691, 0.873142, 0.814593, 0.756044, 0.697496, 0.638947, 0.580398, 0.521849, 0.463300, 0.404752, 0.346203] #[1.224435, 1.165886, 1.107337, 1.048788, 0.990240, 0.931691, 0.873142, 0.814593, 0.756044, 0.697496, 0.638947, 0.580398, 0.521849, 0.463300, 0.404752, 0.346203, 0.287654, 0.229105, 1.770556, 1.712008, 1.653459, 1.594910, 1.536361, 1.477812, 1.419264, 1.360715, 1.302166, 1.243617, 1.185068, 1.126520, 1.067971, 1.009422, 0.950873, 0.892324, 0.833776, 0.775227, 0.716678, 0.658129, 0.599580, 0.541032, 0.482483, 0.423934, 0.365385, 0.306836, 0.248288, 1.789739, 1.731190, 1.672641, 1.614092, 1.555544, 1.496995, 1.438446, 1.379897, 1.321348, 1.262800, 1.204251, 1.145702, 1.087153, 1.028604, 0.970056, 0.911507, 0.852958, 0.794409, 0.735860, 0.677312, 0.618763, 0.560214, 0.501665, 0.443116, 0.384568, 0.326019, 0.267470, 0.208921, 1.750372, 1.691824, 1.633275, 1.574726, 1.516177, 1.457628, 1.399080, 1.340531, 1.281982, 1.223433, 1.164884, 1.106336, 1.047787, 0.989238, 0.930689, 0.872140, 0.813592, 0.755043, 0.696494, 0.637945, 0.579396, 0.520848, 0.462299, 0.403750, 0.345201, 0.286652, 0.228104, 1.769555, 1.711006, 1.652457, 1.593908, 1.535360, 1.476811, 1.418262, 1.359713, 1.301164, 1.242616, 1.184067, 1.125518, 1.066969, 1.008420, 0.949872, 0.891323, 0.832774, 0.774225, 0.715676, 0.657128, 0.598579, 0.540030, 0.481481, 0.422932, 0.364384, 0.305835, 0.247286, 1.788737, 1.730188, 1.671640, 1.613091, 1.554542, 1.495993, 1.437444, 1.378896, 1.320347, 1.261798, 1.203249, 1.144700, 1.086152, 1.027603, 0.969054, 0.910505, 0.851956, 0.793408, 0.734859, 0.676310, 0.617761, 0.559212, 0.500664, 0.442115, 0.383566, 0.325017, 0.266468, 0.207920, 1.749371, 1.690822, 1.632273, 1.573724, 1.515176, 1.456627, 1.398078, 1.339529, 1.280980, 1.222432, 1.163883, 1.105334, 1.046785, 0.988236, 0.929688, 0.871139, 0.812590, 0.754041, 0.695492, 0.636944, 0.578395, 0.519846, 0.461297, 0.402748, 0.344200, 0.285651, 0.227102, 1.768553, 1.710004, 1.651456, 1.592907, 1.534358, 1.475809, 1.417260, 1.358712, 1.300163, 1.241614, 1.183065, 1.124516, 1.065968, 1.007419, 0.948870, 0.890321, 0.831772, 0.773224, 0.714675, 0.656126, 0.597577, 0.539028, 0.480480, 0.421931, 0.363382, 0.304833, 0.246284, 1.787736, 1.729187, 1.670638, 1.612089, 1.553540, 1.494992, 1.436443, 1.377894, 1.319345, 1.260796, 1.202248, 1.143699, 1.085150, 1.026601, 0.968052, 0.909504, 0.850955, 0.792406, 0.733857, 0.675308, 0.616760, 0.558211, 0.499662, 0.441113, 0.382564, 0.324016, 0.265467, 0.206918, 1.748369, 1.689820, 1.631272, 1.572723, 1.514174, 1.455625, 1.397076, 1.338528, 1.279979, 1.221430, 1.162881, 1.104332, 1.045784, 0.987235, 0.928686, 0.870137, 0.811588, 0.753040, 0.694491, 0.635942, 0.577393, 0.518844, 0.460296, 0.401747, 0.343198, 0.284649, 0.226100, 1.767552, 1.709003, 1.650454, 1.591905, 1.533356, 1.474808, 1.416259, 1.357710, 1.299161, 1.240612, 1.182064, 1.123515, 1.064966, 1.006417, 0.947868, 0.889320, 0.830771, 0.772222, 0.713673, 0.655124, 0.596576, 0.538027, 0.479478, 0.420929, 0.362380, 0.303832, 0.245283, 1.786734, 1.728185, 1.669636, 1.611088, 1.552539, 1.493990, 1.435441, 1.376892, 1.318344, 1.259795, 1.201246, 1.142697, 1.084148, 1.025600, 0.967051, 0.908502, 0.849953, 0.791404, 0.732856, 0.674307, 0.615758, 0.557209, 0.498660, 0.440112, 0.381563, 0.323014, 0.264465, 0.205916, 1.747368, 1.688819, 1.630270, 1.571721, 1.513172, 1.454624, 1.396075, 1.337526, 1.278977, 1.220428, 1.161880, 1.103331, 1.044782, 0.986233, 0.927684, 0.869136, 0.810587, 0.752038, 0.693489, 0.634940, 0.576392, 0.517843, 0.459294, 0.400745, 0.342196, 0.283648, 0.225099, 1.766550, 1.708001, 1.649452, 1.590904, 1.532355, 1.473806, 1.415257, 1.356708, 1.298160, 1.239611, 1.181062, 1.122513, 1.063964, 1.005416, 0.946867, 0.888318, 0.829769, 0.771220, 0.712672, 0.654123, 0.595574, 0.537025, 0.478476, 0.419928, 0.361379, 0.302830, 0.244281, 1.785732, 1.727184, 1.668635, 1.610086, 1.551537, 1.492988, 1.434440, 1.375891, 1.317342, 1.258793, 1.200244, 1.141696, 1.083147, 1.024598, 0.966049, 0.907500, 0.848952, 0.790403, 0.731854, 0.673305, 0.614756, 0.556208, 0.497659, 0.439110, 0.380561, 0.322012, 0.263464, 0.204915, 1.746366, 1.687817, 1.629268, 1.570720, 1.512171, 1.453622, 1.395073, 1.336524, 1.277976, 1.219427, 1.160878, 1.102329, 1.043780, 0.985232, 0.926683, 0.868134, 0.809585, 0.751036, 0.692488, 0.633939, 0.575390, 0.516841, 0.458292, 0.399744, 0.341195, 0.282646, 0.224097, 1.765548, 1.707000, 1.648451, 1.589902, 1.531353, 1.472804, 1.414256, 1.355707, 1.297158, 1.238609, 1.180060, 1.121512, 1.062963, 1.004414, 0.945865, 0.887316, 0.828768, 0.770219, 0.711670, 0.653121, 0.594572, 0.536024, 0.477475, 0.418926, 0.360377, 0.301828, 0.243280, 1.784731, 1.726182, 1.667633, 1.609084, 1.550536, 1.491987, 1.433438, 1.374889, 1.316340, 1.257792, 1.199243, 1.140694, 1.082145, 1.023596, 0.965048, 0.906499, 0.847950, 0.789401, 0.730852, 0.672304, 0.613755, 0.555206, 0.496657, 0.438108, 0.379560, 0.321011, 0.262462, 0.203913, 1.745364, 1.686816, 1.628267, 1.569718, 1.511169, 1.452620, 1.394072, 1.335523, 1.276974, 1.218425, 1.159876, 1.101328, 1.042779, 0.984230, 0.925681, 0.867132, 0.808584, 0.750035, 0.691486, 0.632937, 0.574388, 0.515840, 0.457291, 0.398742, 0.340193, 0.281644, 0.223096, 1.764547, 1.705998, 1.647449, 1.588900, 1.530352, 1.471803, 1.413254, 1.354705, 1.296156, 1.237608, 1.179059, 1.120510, 1.061961, 1.003412, 0.944864, 0.886315, 0.827766, 0.769217, 0.710668, 0.652120, 0.593571, 0.535022, 0.476473, 0.417924, 0.359376, 0.300827, 0.242278, 1.783729, 1.725180, 1.666632, 1.608083, 1.549534, 1.490985, 1.432436, 1.373888, 1.315339, 1.256790, 1.198241, 1.139692, 1.081144, 1.022595, 0.964046, 0.905497, 0.846948, 0.788400, 0.729851, 0.671302, 0.612753, 0.554204, 0.495656, 0.437107, 0.378558, 0.320009, 0.261460, 0.202912, 1.744363, 1.685814, 1.627265, 1.568716, 1.510168, 1.451619, 1.393070, 1.334521, 1.275972, 1.217424, 1.158875, 1.100326, 1.041777, 0.983228, 0.924680, 0.866131, 0.807582, 0.749033, 0.690484, 0.631936, 0.573387, 0.514838, 0.456289, 0.397740, 0.339192, 0.280643, 0.222094, 1.763545, 1.704996, 1.646448, 1.587899, 1.529350, 1.470801, 1.412252, 1.353704, 1.295155, 1.236606, 1.178057, 1.119508, 1.060960, 1.002411, 0.943862, 0.885313, 0.826764, 0.768216, 0.709667, 0.651118, 0.592569, 0.534020, 0.475472, 0.416923, 0.358374, 0.299825, 0.241276, 1.782728, 1.724179, 1.665630, 1.607081, 1.548532, 1.489984, 1.431435, 1.372886, 1.314337, 1.255788, 1.197240, 1.138691, 1.080142, 1.021593, 0.963044, 0.904496, 0.845947, 0.787398, 0.728849, 0.670300, 0.611752]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.616627 0.558078 0.499529 0.440980 0.382432 0.323883 0.265334 0.206785 1.748236 1.689688 1.631139 1.572590 1.514041 1.455492 1.396944 1.338395 1.279846 1.221297 1.162748 1.104200 1.045651 0.987102 0.928553 0.870004 0.811456 0.752907 0.694358 0.635809 0.577260 0.518712 0.460163 0.401614 0.343065 0.284516 0.225968 1.767419 #[0.893243, 0.834694, 0.776145, 0.717596, 0.659048, 0.600499, 0.541950, 0.483401, 0.424852, 0.366304, 0.307755, 0.249206, 1.790657, 1.732108, 1.673560, 1.615011] #[0.893243, 0.834694, 0.776145, 0.717596, 0.659048, 0.600499, 0.541950, 0.483401, 0.424852, 0.366304, 0.307755, 0.249206, 1.790657, 1.732108, 1.673560, 1.615011] #[0.893243, 0.834694, 0.776145, 0.717596, 0.659048, 0.600499, 0.541950, 0.483401, 0.424852, 0.366304, 0.307755, 0.249206, 1.790657, 1.732108, 1.673560, 1.615011, 1.556462, 1.497913, 1.439364, 1.380816, 1.322267, 1.263718, 1.205169, 1.146620, 1.088072, 1.029523, 0.970974, 0.912425, 0.853876, 0.795328, 0.736779, 0.678230, 0.619681, 0.561132, 0.502584, 0.444035, 0.385486, 0.326937, 0.268388, 0.209840, 1.751291, 1.692742, 1.634193, 1.575644, 1.517096, 1.458547, 1.399998, 1.341449, 1.282900, 1.224352, 1.165803, 1.107254, 1.048705, 0.990156, 0.931608, 0.873059, 0.814510, 0.755961, 0.697412, 0.638864, 0.580315, 0.521766, 0.463217, 0.404668, 0.346120, 0.287571, 0.229022, 1.770473, 1.711924, 1.653376, 1.594827, 1.536278, 1.477729, 1.419180, 1.360632, 1.302083, 1.243534, 1.184985, 1.126436, 1.067888, 1.009339, 0.950790, 0.892241, 0.833692, 0.775144, 0.716595, 0.658046, 0.599497, 0.540948, 0.482400, 0.423851, 0.365302, 0.306753, 0.248204, 1.789656, 1.731107, 1.672558, 1.614009, 1.555460, 1.496912, 1.438363, 1.379814, 1.321265, 1.262716, 1.204168, 1.145619, 1.087070, 1.028521, 0.969972, 0.911424, 0.852875, 0.794326, 0.735777, 0.677228, 0.618680, 0.560131, 0.501582, 0.443033, 0.384484, 0.325936, 0.267387, 0.208838, 1.750289, 1.691740, 1.633192, 1.574643, 1.516094, 1.457545, 1.398996, 1.340448, 1.281899, 1.223350, 1.164801, 1.106252, 1.047704, 0.989155, 0.930606, 0.872057, 0.813508, 0.754960, 0.696411, 0.637862, 0.579313, 0.520764, 0.462216, 0.403667, 0.345118, 0.286569, 0.228020, 1.769472, 1.710923, 1.652374, 1.593825, 1.535276, 1.476728, 1.418179, 1.359630, 1.301081, 1.242532, 1.183984, 1.125435, 1.066886, 1.008337, 0.949788, 0.891240, 0.832691, 0.774142, 0.715593, 0.657044, 0.598496, 0.539947, 0.481398, 0.422849, 0.364300, 0.305752, 0.247203, 1.788654, 1.730105, 1.671556, 1.613008, 1.554459, 1.495910, 1.437361, 1.378812, 1.320264, 1.261715, 1.203166, 1.144617, 1.086068, 1.027520, 0.968971, 0.910422, 0.851873, 0.793324, 0.734776, 0.676227, 0.617678, 0.559129, 0.500580, 0.442032, 0.383483, 0.324934, 0.266385, 0.207836, 1.749288, 1.690739, 1.632190, 1.573641, 1.515092, 1.456544, 1.397995, 1.339446, 1.280897, 1.222348, 1.163800, 1.105251, 1.046702, 0.988153, 0.929604, 0.871056, 0.812507, 0.753958, 0.695409, 0.636860, 0.578312, 0.519763, 0.461214, 0.402665, 0.344116, 0.285568, 0.227019, 1.768470, 1.709921, 1.651372, 1.592824, 1.534275, 1.475726, 1.417177, 1.358628, 1.300080, 1.241531, 1.182982, 1.124433, 1.065884, 1.007336, 0.948787, 0.890238, 0.831689, 0.773140, 0.714592, 0.656043, 0.597494, 0.538945, 0.480396, 0.421848, 0.363299, 0.304750, 0.246201, 1.787652, 1.729104, 1.670555, 1.612006, 1.553457, 1.494908, 1.436360, 1.377811, 1.319262, 1.260713, 1.202164, 1.143616, 1.085067, 1.026518, 0.967969, 0.909420, 0.850872, 0.792323, 0.733774, 0.675225, 0.616676, 0.558128, 0.499579, 0.441030, 0.382481, 0.323932, 0.265384, 0.206835, 1.748286, 1.689737, 1.631188, 1.572640, 1.514091, 1.455542, 1.396993, 1.338444, 1.279896, 1.221347, 1.162798, 1.104249, 1.045700, 0.987152, 0.928603, 0.870054, 0.811505, 0.752956, 0.694408, 0.635859, 0.577310, 0.518761, 0.460212, 0.401664, 0.343115, 0.284566, 0.226017, 1.767468, 1.708920, 1.650371, 1.591822, 1.533273, 1.474724, 1.416176, 1.357627, 1.299078, 1.240529, 1.181980, 1.123432, 1.064883, 1.006334, 0.947785, 0.889236, 0.830688, 0.772139, 0.713590, 0.655041, 0.596492, 0.537944, 0.479395, 0.420846, 0.362297, 0.303748, 0.245200, 1.786651, 1.728102, 1.669553, 1.611004, 1.552456, 1.493907, 1.435358, 1.376809, 1.318260, 1.259712, 1.201163, 1.142614, 1.084065, 1.025516, 0.966968, 0.908419, 0.849870, 0.791321, 0.732772, 0.674224, 0.615675, 0.557126, 0.498577, 0.440028, 0.381480, 0.322931, 0.264382, 0.205833, 1.747284, 1.688736, 1.630187, 1.571638, 1.513089, 1.454540, 1.395992, 1.337443, 1.278894, 1.220345, 1.161796, 1.103248, 1.044699, 0.986150, 0.927601, 0.869052, 0.810504, 0.751955, 0.693406, 0.634857, 0.576308, 0.517760, 0.459211, 0.400662, 0.342113, 0.283564, 0.225016, 1.766467, 1.707918, 1.649369, 1.590820, 1.532272, 1.473723, 1.415174, 1.356625, 1.298076, 1.239528, 1.180979, 1.122430, 1.063881, 1.005332, 0.946784, 0.888235, 0.829686, 0.771137, 0.712588, 0.654040, 0.595491, 0.536942, 0.478393, 0.419844, 0.361296, 0.302747, 0.244198, 1.785649, 1.727100, 1.668552, 1.610003, 1.551454, 1.492905, 1.434356, 1.375808, 1.317259, 1.258710, 1.200161, 1.141612, 1.083064, 1.024515, 0.965966, 0.907417, 0.848868, 0.790320, 0.731771, 0.673222, 0.614673, 0.556124, 0.497576, 0.439027, 0.380478, 0.321929, 0.263380, 0.204832, 1.746283, 1.687734, 1.629185, 1.570636, 1.512088, 1.453539, 1.394990, 1.336441, 1.277892, 1.219344, 1.160795, 1.102246, 1.043697, 0.985148, 0.926600, 0.868051, 0.809502, 0.750953, 0.692404, 0.633856, 0.575307, 0.516758, 0.458209, 0.399660, 0.341112, 0.282563, 0.224014, 1.765465, 1.706916, 1.648368, 1.589819, 1.531270, 1.472721, 1.414172, 1.355624, 1.297075, 1.238526, 1.179977, 1.121428, 1.062880, 1.004331, 0.945782, 0.887233, 0.828684, 0.770136, 0.711587, 0.653038, 0.594489, 0.535940, 0.477392, 0.418843, 0.360294, 0.301745, 0.243196, 1.784648, 1.726099, 1.667550, 1.609001, 1.550452, 1.491904, 1.433355, 1.374806, 1.316257, 1.257708, 1.199160, 1.140611, 1.082062, 1.023513, 0.964964, 0.906416, 0.847867, 0.789318, 0.730769, 0.672220, 0.613672, 0.555123, 0.496574, 0.438025, 0.379476, 0.320928, 0.262379, 0.203830, 1.745281, 1.686732, 1.628184, 1.569635, 1.511086, 1.452537, 1.393988, 1.335440, 1.276891, 1.218342, 1.159793, 1.101244, 1.042696, 0.984147, 0.925598, 0.867049, 0.808500, 0.749952, 0.691403, 0.632854, 0.574305, 0.515756, 0.457208, 0.398659, 0.340110, 0.281561, 0.223012, 1.764464, 1.705915, 1.647366, 1.588817, 1.530268, 1.471720, 1.413171, 1.354622, 1.296073, 1.237524, 1.178976, 1.120427, 1.061878, 1.003329, 0.944780, 0.886232, 0.827683, 0.769134, 0.710585, 0.652036, 0.593488, 0.534939, 0.476390, 0.417841, 0.359292, 0.300744, 0.242195, 1.783646, 1.725097, 1.666548, 1.608000, 1.549451, 1.490902, 1.432353, 1.373804, 1.315256, 1.256707, 1.198158, 1.139609, 1.081060, 1.022512, 0.963963, 0.905414, 0.846865, 0.788316, 0.729768, 0.671219, 0.612670, 0.554121, 0.495572, 0.437024, 0.378475, 0.319926, 0.261377, 0.202828, 1.744280, 1.685731, 1.627182, 1.568633, 1.510084, 1.451536, 1.392987, 1.334438, 1.275889, 1.217340, 1.158792, 1.100243, 1.041694, 0.983145, 0.924596, 0.866048, 0.807499, 0.748950, 0.690401, 0.631852, 0.573304, 0.514755, 0.456206, 0.397657, 0.339108, 0.280560]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.285435 0.226886 1.768337 1.709788 1.651240 1.592691 1.534142 1.475593 1.417044 1.358496 1.299947 1.241398 1.182849 1.124300 1.065752 1.007203 0.948654 0.890105 0.831556 0.773008 0.714459 0.655910 0.597361 0.538812 0.480264 0.421715 0.363166 0.304617 0.246068 1.787520 1.728971 1.670422 1.611873 1.553324 1.494776 1.436227 #[0.562051, 0.503502, 0.444953, 0.386404, 0.327856, 0.269307, 0.210758, 1.752209, 1.693660, 1.635112, 1.576563, 1.518014, 1.459465, 1.400916, 1.342368, 1.283819] #[0.562051, 0.503502, 0.444953, 0.386404, 0.327856, 0.269307, 0.210758, 1.752209, 1.693660, 1.635112, 1.576563, 1.518014, 1.459465, 1.400916, 1.342368, 1.283819] #[0.562051, 0.503502, 0.444953, 0.386404, 0.327856, 0.269307, 0.210758, 1.752209, 1.693660, 1.635112, 1.576563, 1.518014, 1.459465, 1.400916, 1.342368, 1.283819, 1.225270, 1.166721, 1.108172, 1.049624, 0.991075, 0.932526, 0.873977, 0.815428, 0.756880, 0.698331, 0.639782, 0.581233, 0.522684, 0.464136, 0.405587, 0.347038, 0.288489, 0.229940, 1.771392, 1.712843, 1.654294, 1.595745, 1.537196, 1.478648, 1.420099, 1.361550, 1.303001, 1.244452, 1.185904, 1.127355, 1.068806, 1.010257, 0.951708, 0.893160, 0.834611, 0.776062, 0.717513, 0.658964, 0.600416, 0.541867, 0.483318, 0.424769, 0.366220, 0.307672, 0.249123, 1.790574, 1.732025, 1.673476, 1.614928, 1.556379, 1.497830, 1.439281, 1.380732, 1.322184, 1.263635, 1.205086, 1.146537, 1.087988, 1.029440, 0.970891, 0.912342, 0.853793, 0.795244, 0.736696, 0.678147, 0.619598, 0.561049, 0.502500, 0.443952, 0.385403, 0.326854, 0.268305, 0.209756, 1.751208, 1.692659, 1.634110, 1.575561, 1.517012, 1.458464, 1.399915, 1.341366, 1.282817, 1.224268, 1.165720, 1.107171, 1.048622, 0.990073, 0.931524, 0.872976, 0.814427, 0.755878, 0.697329, 0.638780, 0.580232, 0.521683, 0.463134, 0.404585, 0.346036, 0.287488, 0.228939, 1.770390, 1.711841, 1.653292, 1.594744, 1.536195, 1.477646, 1.419097, 1.360548, 1.302000, 1.243451, 1.184902, 1.126353, 1.067804, 1.009256, 0.950707, 0.892158, 0.833609, 0.775060, 0.716512, 0.657963, 0.599414, 0.540865, 0.482316, 0.423768, 0.365219, 0.306670, 0.248121, 1.789572, 1.731024, 1.672475, 1.613926, 1.555377, 1.496828, 1.438280, 1.379731, 1.321182, 1.262633, 1.204084, 1.145536, 1.086987, 1.028438, 0.969889, 0.911340, 0.852792, 0.794243, 0.735694, 0.677145, 0.618596, 0.560048, 0.501499, 0.442950, 0.384401, 0.325852, 0.267304, 0.208755, 1.750206, 1.691657, 1.633108, 1.574560, 1.516011, 1.457462, 1.398913, 1.340364, 1.281816, 1.223267, 1.164718, 1.106169, 1.047620, 0.989072, 0.930523, 0.871974, 0.813425, 0.754876, 0.696328, 0.637779, 0.579230, 0.520681, 0.462132, 0.403584, 0.345035, 0.286486, 0.227937, 1.769388, 1.710840, 1.652291, 1.593742, 1.535193, 1.476644, 1.418096, 1.359547, 1.300998, 1.242449, 1.183900, 1.125352, 1.066803, 1.008254, 0.949705, 0.891156, 0.832608, 0.774059, 0.715510, 0.656961, 0.598412, 0.539864, 0.481315, 0.422766, 0.364217, 0.305668, 0.247120, 1.788571, 1.730022, 1.671473, 1.612924, 1.554376, 1.495827, 1.437278, 1.378729, 1.320180, 1.261632, 1.203083, 1.144534, 1.085985, 1.027436, 0.968888, 0.910339, 0.851790, 0.793241, 0.734692, 0.676144, 0.617595, 0.559046, 0.500497, 0.441948, 0.383400, 0.324851, 0.266302, 0.207753, 1.749204, 1.690656, 1.632107, 1.573558, 1.515009, 1.456460, 1.397912, 1.339363, 1.280814, 1.222265, 1.163716, 1.105168, 1.046619, 0.988070, 0.929521, 0.870972, 0.812424, 0.753875, 0.695326, 0.636777, 0.578228, 0.519680, 0.461131, 0.402582, 0.344033, 0.285484, 0.226936, 1.768387, 1.709838, 1.651289, 1.592740, 1.534192, 1.475643, 1.417094, 1.358545, 1.299996, 1.241448, 1.182899, 1.124350, 1.065801, 1.007252, 0.948704, 0.890155, 0.831606, 0.773057, 0.714508, 0.655960, 0.597411, 0.538862, 0.480313, 0.421764, 0.363216, 0.304667, 0.246118, 1.787569, 1.729020, 1.670472, 1.611923, 1.553374, 1.494825, 1.436276, 1.377728, 1.319179, 1.260630, 1.202081, 1.143532, 1.084984, 1.026435, 0.967886, 0.909337, 0.850788, 0.792240, 0.733691, 0.675142, 0.616593, 0.558044, 0.499496, 0.440947, 0.382398, 0.323849, 0.265300, 0.206752, 1.748203, 1.689654, 1.631105, 1.572556, 1.514008, 1.455459, 1.396910, 1.338361, 1.279812, 1.221264, 1.162715, 1.104166, 1.045617, 0.987068, 0.928520, 0.869971, 0.811422, 0.752873, 0.694324, 0.635776, 0.577227, 0.518678, 0.460129, 0.401580, 0.343032, 0.284483, 0.225934, 1.767385, 1.708836, 1.650288, 1.591739, 1.533190, 1.474641, 1.416092, 1.357544, 1.298995, 1.240446, 1.181897, 1.123348, 1.064800, 1.006251, 0.947702, 0.889153, 0.830604, 0.772056, 0.713507, 0.654958, 0.596409, 0.537860, 0.479312, 0.420763, 0.362214, 0.303665, 0.245116, 1.786568, 1.728019, 1.669470, 1.610921, 1.552372, 1.493824, 1.435275, 1.376726, 1.318177, 1.259628, 1.201080, 1.142531, 1.083982, 1.025433, 0.966884, 0.908336, 0.849787, 0.791238, 0.732689, 0.674140, 0.615592, 0.557043, 0.498494, 0.439945, 0.381396, 0.322848, 0.264299, 0.205750, 1.747201, 1.688652, 1.630104, 1.571555, 1.513006, 1.454457, 1.395908, 1.337360, 1.278811, 1.220262, 1.161713, 1.103164, 1.044616, 0.986067, 0.927518, 0.868969, 0.810420, 0.751872, 0.693323, 0.634774, 0.576225, 0.517676, 0.459128, 0.400579, 0.342030, 0.283481, 0.224932, 1.766384, 1.707835, 1.649286, 1.590737, 1.532188, 1.473640, 1.415091, 1.356542, 1.297993, 1.239444, 1.180896, 1.122347, 1.063798, 1.005249, 0.946700, 0.888152, 0.829603, 0.771054, 0.712505, 0.653956, 0.595408, 0.536859, 0.478310, 0.419761, 0.361212, 0.302664, 0.244115, 1.785566, 1.727017, 1.668468, 1.609920, 1.551371, 1.492822, 1.434273, 1.375724, 1.317176, 1.258627, 1.200078, 1.141529, 1.082980, 1.024432, 0.965883, 0.907334, 0.848785, 0.790236, 0.731688, 0.673139, 0.614590, 0.556041, 0.497492, 0.438944, 0.380395, 0.321846, 0.263297, 0.204748, 1.746200, 1.687651, 1.629102, 1.570553, 1.512004, 1.453456, 1.394907, 1.336358, 1.277809, 1.219260, 1.160712, 1.102163, 1.043614, 0.985065, 0.926516, 0.867968, 0.809419, 0.750870, 0.692321, 0.633772, 0.575224, 0.516675, 0.458126, 0.399577, 0.341028, 0.282480, 0.223931, 1.765382, 1.706833, 1.648284, 1.589736, 1.531187, 1.472638, 1.414089, 1.355540, 1.296992, 1.238443, 1.179894, 1.121345, 1.062796, 1.004248, 0.945699, 0.887150, 0.828601, 0.770052, 0.711504, 0.652955, 0.594406, 0.535857, 0.477308, 0.418760, 0.360211, 0.301662, 0.243113, 1.784564, 1.726016, 1.667467, 1.608918, 1.550369, 1.491820, 1.433272, 1.374723, 1.316174, 1.257625, 1.199076, 1.140528, 1.081979, 1.023430, 0.964881, 0.906332, 0.847784, 0.789235, 0.730686, 0.672137, 0.613588, 0.555040, 0.496491, 0.437942, 0.379393, 0.320844, 0.262296, 0.203747, 1.745198, 1.686649, 1.628100, 1.569552, 1.511003, 1.452454, 1.393905, 1.335356, 1.276808, 1.218259, 1.159710, 1.101161, 1.042612, 0.984064, 0.925515, 0.866966, 0.808417, 0.749868, 0.691320, 0.632771, 0.574222, 0.515673, 0.457124, 0.398576, 0.340027, 0.281478, 0.222929, 1.764380, 1.705832, 1.647283, 1.588734, 1.530185, 1.471636, 1.413088, 1.354539, 1.295990, 1.237441, 1.178892, 1.120344, 1.061795, 1.003246, 0.944697, 0.886148, 0.827600, 0.769051, 0.710502, 0.651953, 0.593404, 0.534856, 0.476307, 0.417758, 0.359209, 0.300660, 0.242112, 1.783563, 1.725014, 1.666465, 1.607916, 1.549368]))

def check_hashemiEnv_pot_le (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (mcp : Float) (Twall : Float) (Ta : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v1779 := (Float.exp ((-(Upipe / (2 : Float))) / mcp))
  let v1781 := (Ta + ((hist[1]! - Ta) * v1779))
  let v1784 := (max (0 : Float) (v1781 - Twall))
  let v1785 := ((min UAx mcp) * v1784)
  (!((0 : Float) <= UAx) || (!((0 : Float) <= mcp) || (v1785 <= (UAx * v1784))))

#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 0.761667 0.703118 0.644569 0.586020 0.527472 0.468923 0.410374 0.351825 0.293276 0.234728 1.776179 1.717630 1.659081 1.600532 1.541984 1.483435 1.424886 1.366337 1.307788 1.249240 1.190691 1.132142 1.073593 1.015044 0.956496 0.897947 0.839398 0.780849 0.722300 0.663752 0.605203 0.546654 0.488105 0.429556 0.371008 0.312459 #[1.038283, 0.979734, 0.921185, 0.862636, 0.804088, 0.745539, 0.686990, 0.628441, 0.569892, 0.511344, 0.452795, 0.394246, 0.335697, 0.277148, 0.218600, 1.760051] #[1.038283, 0.979734, 0.921185, 0.862636, 0.804088, 0.745539, 0.686990, 0.628441, 0.569892, 0.511344, 0.452795, 0.394246, 0.335697, 0.277148, 0.218600, 1.760051] #[1.038283, 0.979734, 0.921185, 0.862636, 0.804088, 0.745539, 0.686990, 0.628441, 0.569892, 0.511344, 0.452795, 0.394246, 0.335697, 0.277148, 0.218600, 1.760051, 1.701502, 1.642953, 1.584404, 1.525856, 1.467307, 1.408758, 1.350209, 1.291660, 1.233112, 1.174563, 1.116014, 1.057465, 0.998916, 0.940368, 0.881819, 0.823270, 0.764721, 0.706172, 0.647624, 0.589075, 0.530526, 0.471977, 0.413428, 0.354880, 0.296331, 0.237782, 1.779233, 1.720684, 1.662136, 1.603587, 1.545038, 1.486489, 1.427940, 1.369392, 1.310843, 1.252294, 1.193745, 1.135196, 1.076648, 1.018099, 0.959550, 0.901001, 0.842452, 0.783904, 0.725355, 0.666806, 0.608257, 0.549708, 0.491160, 0.432611, 0.374062, 0.315513, 0.256964, 1.798416, 1.739867, 1.681318, 1.622769, 1.564220, 1.505672, 1.447123, 1.388574, 1.330025, 1.271476, 1.212928, 1.154379, 1.095830, 1.037281, 0.978732, 0.920184, 0.861635, 0.803086, 0.744537, 0.685988, 0.627440, 0.568891, 0.510342, 0.451793, 0.393244, 0.334696, 0.276147, 0.217598, 1.759049, 1.700500, 1.641952, 1.583403, 1.524854, 1.466305, 1.407756, 1.349208, 1.290659, 1.232110, 1.173561, 1.115012, 1.056464, 0.997915, 0.939366, 0.880817, 0.822268, 0.763720, 0.705171, 0.646622, 0.588073, 0.529524, 0.470976, 0.412427, 0.353878, 0.295329, 0.236780, 1.778232, 1.719683, 1.661134, 1.602585, 1.544036, 1.485488, 1.426939, 1.368390, 1.309841, 1.251292, 1.192744, 1.134195, 1.075646, 1.017097, 0.958548, 0.900000, 0.841451, 0.782902, 0.724353, 0.665804, 0.607256, 0.548707, 0.490158, 0.431609, 0.373060, 0.314512, 0.255963, 1.797414, 1.738865, 1.680316, 1.621768, 1.563219, 1.504670, 1.446121, 1.387572, 1.329024, 1.270475, 1.211926, 1.153377, 1.094828, 1.036280, 0.977731, 0.919182, 0.860633, 0.802084, 0.743536, 0.684987, 0.626438, 0.567889, 0.509340, 0.450792, 0.392243, 0.333694, 0.275145, 0.216596, 1.758048, 1.699499, 1.640950, 1.582401, 1.523852, 1.465304, 1.406755, 1.348206, 1.289657, 1.231108, 1.172560, 1.114011, 1.055462, 0.996913, 0.938364, 0.879816, 0.821267, 0.762718, 0.704169, 0.645620, 0.587072, 0.528523, 0.469974, 0.411425, 0.352876, 0.294328, 0.235779, 1.777230, 1.718681, 1.660132, 1.601584, 1.543035, 1.484486, 1.425937, 1.367388, 1.308840, 1.250291, 1.191742, 1.133193, 1.074644, 1.016096, 0.957547, 0.898998, 0.840449, 0.781900, 0.723352, 0.664803, 0.606254, 0.547705, 0.489156, 0.430608, 0.372059, 0.313510, 0.254961, 1.796412, 1.737864, 1.679315, 1.620766, 1.562217, 1.503668, 1.445120, 1.386571, 1.328022, 1.269473, 1.210924, 1.152376, 1.093827, 1.035278, 0.976729, 0.918180, 0.859632, 0.801083, 0.742534, 0.683985, 0.625436, 0.566888, 0.508339, 0.449790, 0.391241, 0.332692, 0.274144, 0.215595, 1.757046, 1.698497, 1.639948, 1.581400, 1.522851, 1.464302, 1.405753, 1.347204, 1.288656, 1.230107, 1.171558, 1.113009, 1.054460, 0.995912, 0.937363, 0.878814, 0.820265, 0.761716, 0.703168, 0.644619, 0.586070, 0.527521, 0.468972, 0.410424, 0.351875, 0.293326, 0.234777, 1.776228, 1.717680, 1.659131, 1.600582, 1.542033, 1.483484, 1.424936, 1.366387, 1.307838, 1.249289, 1.190740, 1.132192, 1.073643, 1.015094, 0.956545, 0.897996, 0.839448, 0.780899, 0.722350, 0.663801, 0.605252, 0.546704, 0.488155, 0.429606, 0.371057, 0.312508, 0.253960, 1.795411, 1.736862, 1.678313, 1.619764, 1.561216, 1.502667, 1.444118, 1.385569, 1.327020, 1.268472, 1.209923, 1.151374, 1.092825, 1.034276, 0.975728, 0.917179, 0.858630, 0.800081, 0.741532, 0.682984, 0.624435, 0.565886, 0.507337, 0.448788, 0.390240, 0.331691, 0.273142, 0.214593, 1.756044, 1.697496, 1.638947, 1.580398, 1.521849, 1.463300, 1.404752, 1.346203, 1.287654, 1.229105, 1.170556, 1.112008, 1.053459, 0.994910, 0.936361, 0.877812, 0.819264, 0.760715, 0.702166, 0.643617, 0.585068, 0.526520, 0.467971, 0.409422, 0.350873, 0.292324, 0.233776, 1.775227, 1.716678, 1.658129, 1.599580, 1.541032, 1.482483, 1.423934, 1.365385, 1.306836, 1.248288, 1.189739, 1.131190, 1.072641, 1.014092, 0.955544, 0.896995, 0.838446, 0.779897, 0.721348, 0.662800, 0.604251, 0.545702, 0.487153, 0.428604, 0.370056, 0.311507, 0.252958, 1.794409, 1.735860, 1.677312, 1.618763, 1.560214, 1.501665, 1.443116, 1.384568, 1.326019, 1.267470, 1.208921, 1.150372, 1.091824, 1.033275, 0.974726, 0.916177, 0.857628, 0.799080, 0.740531, 0.681982, 0.623433, 0.564884, 0.506336, 0.447787, 0.389238, 0.330689, 0.272140, 0.213592, 1.755043, 1.696494, 1.637945, 1.579396, 1.520848, 1.462299, 1.403750, 1.345201, 1.286652, 1.228104, 1.169555, 1.111006, 1.052457, 0.993908, 0.935360, 0.876811, 0.818262, 0.759713, 0.701164, 0.642616, 0.584067, 0.525518, 0.466969, 0.408420, 0.349872, 0.291323, 0.232774, 1.774225, 1.715676, 1.657128, 1.598579, 1.540030, 1.481481, 1.422932, 1.364384, 1.305835, 1.247286, 1.188737, 1.130188, 1.071640, 1.013091, 0.954542, 0.895993, 0.837444, 0.778896, 0.720347, 0.661798, 0.603249, 0.544700, 0.486152, 0.427603, 0.369054, 0.310505, 0.251956, 1.793408, 1.734859, 1.676310, 1.617761, 1.559212, 1.500664, 1.442115, 1.383566, 1.325017, 1.266468, 1.207920, 1.149371, 1.090822, 1.032273, 0.973724, 0.915176, 0.856627, 0.798078, 0.739529, 0.680980, 0.622432, 0.563883, 0.505334, 0.446785, 0.388236, 0.329688, 0.271139, 0.212590, 1.754041, 1.695492, 1.636944, 1.578395, 1.519846, 1.461297, 1.402748, 1.344200, 1.285651, 1.227102, 1.168553, 1.110004, 1.051456, 0.992907, 0.934358, 0.875809, 0.817260, 0.758712, 0.700163, 0.641614, 0.583065, 0.524516, 0.465968, 0.407419, 0.348870, 0.290321, 0.231772, 1.773224, 1.714675, 1.656126, 1.597577, 1.539028, 1.480480, 1.421931, 1.363382, 1.304833, 1.246284, 1.187736, 1.129187, 1.070638, 1.012089, 0.953540, 0.894992, 0.836443, 0.777894, 0.719345, 0.660796, 0.602248, 0.543699, 0.485150, 0.426601, 0.368052, 0.309504, 0.250955, 1.792406, 1.733857, 1.675308, 1.616760, 1.558211, 1.499662, 1.441113, 1.382564, 1.324016, 1.265467, 1.206918, 1.148369, 1.089820, 1.031272, 0.972723, 0.914174, 0.855625, 0.797076, 0.738528, 0.679979, 0.621430, 0.562881, 0.504332, 0.445784, 0.387235, 0.328686, 0.270137, 0.211588, 1.753040, 1.694491, 1.635942, 1.577393, 1.518844, 1.460296, 1.401747, 1.343198, 1.284649, 1.226100, 1.167552, 1.109003, 1.050454, 0.991905, 0.933356, 0.874808, 0.816259, 0.757710, 0.699161, 0.640612, 0.582064, 0.523515, 0.464966, 0.406417, 0.347868, 0.289320, 0.230771, 1.772222, 1.713673, 1.655124, 1.596576, 1.538027, 1.479478, 1.420929, 1.362380, 1.303832, 1.245283, 1.186734, 1.128185, 1.069636, 1.011088, 0.952539, 0.893990, 0.835441, 0.776892, 0.718344, 0.659795, 0.601246, 0.542697, 0.484148, 0.425600]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 0.430475 0.371926 0.313377 0.254828 1.796280 1.737731 1.679182 1.620633 1.562084 1.503536 1.444987 1.386438 1.327889 1.269340 1.210792 1.152243 1.093694 1.035145 0.976596 0.918048 0.859499 0.800950 0.742401 0.683852 0.625304 0.566755 0.508206 0.449657 0.391108 0.332560 0.274011 0.215462 1.756913 1.698364 1.639816 1.581267 #[0.707091, 0.648542, 0.589993, 0.531444, 0.472896, 0.414347, 0.355798, 0.297249, 0.238700, 1.780152, 1.721603, 1.663054, 1.604505, 1.545956, 1.487408, 1.428859] #[0.707091, 0.648542, 0.589993, 0.531444, 0.472896, 0.414347, 0.355798, 0.297249, 0.238700, 1.780152, 1.721603, 1.663054, 1.604505, 1.545956, 1.487408, 1.428859] #[0.707091, 0.648542, 0.589993, 0.531444, 0.472896, 0.414347, 0.355798, 0.297249, 0.238700, 1.780152, 1.721603, 1.663054, 1.604505, 1.545956, 1.487408, 1.428859, 1.370310, 1.311761, 1.253212, 1.194664, 1.136115, 1.077566, 1.019017, 0.960468, 0.901920, 0.843371, 0.784822, 0.726273, 0.667724, 0.609176, 0.550627, 0.492078, 0.433529, 0.374980, 0.316432, 0.257883, 1.799334, 1.740785, 1.682236, 1.623688, 1.565139, 1.506590, 1.448041, 1.389492, 1.330944, 1.272395, 1.213846, 1.155297, 1.096748, 1.038200, 0.979651, 0.921102, 0.862553, 0.804004, 0.745456, 0.686907, 0.628358, 0.569809, 0.511260, 0.452712, 0.394163, 0.335614, 0.277065, 0.218516, 1.759968, 1.701419, 1.642870, 1.584321, 1.525772, 1.467224, 1.408675, 1.350126, 1.291577, 1.233028, 1.174480, 1.115931, 1.057382, 0.998833, 0.940284, 0.881736, 0.823187, 0.764638, 0.706089, 0.647540, 0.588992, 0.530443, 0.471894, 0.413345, 0.354796, 0.296248, 0.237699, 1.779150, 1.720601, 1.662052, 1.603504, 1.544955, 1.486406, 1.427857, 1.369308, 1.310760, 1.252211, 1.193662, 1.135113, 1.076564, 1.018016, 0.959467, 0.900918, 0.842369, 0.783820, 0.725272, 0.666723, 0.608174, 0.549625, 0.491076, 0.432528, 0.373979, 0.315430, 0.256881, 1.798332, 1.739784, 1.681235, 1.622686, 1.564137, 1.505588, 1.447040, 1.388491, 1.329942, 1.271393, 1.212844, 1.154296, 1.095747, 1.037198, 0.978649, 0.920100, 0.861552, 0.803003, 0.744454, 0.685905, 0.627356, 0.568808, 0.510259, 0.451710, 0.393161, 0.334612, 0.276064, 0.217515, 1.758966, 1.700417, 1.641868, 1.583320, 1.524771, 1.466222, 1.407673, 1.349124, 1.290576, 1.232027, 1.173478, 1.114929, 1.056380, 0.997832, 0.939283, 0.880734, 0.822185, 0.763636, 0.705088, 0.646539, 0.587990, 0.529441, 0.470892, 0.412344, 0.353795, 0.295246, 0.236697, 1.778148, 1.719600, 1.661051, 1.602502, 1.543953, 1.485404, 1.426856, 1.368307, 1.309758, 1.251209, 1.192660, 1.134112, 1.075563, 1.017014, 0.958465, 0.899916, 0.841368, 0.782819, 0.724270, 0.665721, 0.607172, 0.548624, 0.490075, 0.431526, 0.372977, 0.314428, 0.255880, 1.797331, 1.738782, 1.680233, 1.621684, 1.563136, 1.504587, 1.446038, 1.387489, 1.328940, 1.270392, 1.211843, 1.153294, 1.094745, 1.036196, 0.977648, 0.919099, 0.860550, 0.802001, 0.743452, 0.684904, 0.626355, 0.567806, 0.509257, 0.450708, 0.392160, 0.333611, 0.275062, 0.216513, 1.757964, 1.699416, 1.640867, 1.582318, 1.523769, 1.465220, 1.406672, 1.348123, 1.289574, 1.231025, 1.172476, 1.113928, 1.055379, 0.996830, 0.938281, 0.879732, 0.821184, 0.762635, 0.704086, 0.645537, 0.586988, 0.528440, 0.469891, 0.411342, 0.352793, 0.294244, 0.235696, 1.777147, 1.718598, 1.660049, 1.601500, 1.542952, 1.484403, 1.425854, 1.367305, 1.308756, 1.250208, 1.191659, 1.133110, 1.074561, 1.016012, 0.957464, 0.898915, 0.840366, 0.781817, 0.723268, 0.664720, 0.606171, 0.547622, 0.489073, 0.430524, 0.371976, 0.313427, 0.254878, 1.796329, 1.737780, 1.679232, 1.620683, 1.562134, 1.503585, 1.445036, 1.386488, 1.327939, 1.269390, 1.210841, 1.152292, 1.093744, 1.035195, 0.976646, 0.918097, 0.859548, 0.801000, 0.742451, 0.683902, 0.625353, 0.566804, 0.508256, 0.449707, 0.391158, 0.332609, 0.274060, 0.215512, 1.756963, 1.698414, 1.639865, 1.581316, 1.522768, 1.464219, 1.405670, 1.347121, 1.288572, 1.230024, 1.171475, 1.112926, 1.054377, 0.995828, 0.937280, 0.878731, 0.820182, 0.761633, 0.703084, 0.644536, 0.585987, 0.527438, 0.468889, 0.410340, 0.351792, 0.293243, 0.234694, 1.776145, 1.717596, 1.659048, 1.600499, 1.541950, 1.483401, 1.424852, 1.366304, 1.307755, 1.249206, 1.190657, 1.132108, 1.073560, 1.015011, 0.956462, 0.897913, 0.839364, 0.780816, 0.722267, 0.663718, 0.605169, 0.546620, 0.488072, 0.429523, 0.370974, 0.312425, 0.253876, 1.795328, 1.736779, 1.678230, 1.619681, 1.561132, 1.502584, 1.444035, 1.385486, 1.326937, 1.268388, 1.209840, 1.151291, 1.092742, 1.034193, 0.975644, 0.917096, 0.858547, 0.799998, 0.741449, 0.682900, 0.624352, 0.565803, 0.507254, 0.448705, 0.390156, 0.331608, 0.273059, 0.214510, 1.755961, 1.697412, 1.638864, 1.580315, 1.521766, 1.463217, 1.404668, 1.346120, 1.287571, 1.229022, 1.170473, 1.111924, 1.053376, 0.994827, 0.936278, 0.877729, 0.819180, 0.760632, 0.702083, 0.643534, 0.584985, 0.526436, 0.467888, 0.409339, 0.350790, 0.292241, 0.233692, 1.775144, 1.716595, 1.658046, 1.599497, 1.540948, 1.482400, 1.423851, 1.365302, 1.306753, 1.248204, 1.189656, 1.131107, 1.072558, 1.014009, 0.955460, 0.896912, 0.838363, 0.779814, 0.721265, 0.662716, 0.604168, 0.545619, 0.487070, 0.428521, 0.369972, 0.311424, 0.252875, 1.794326, 1.735777, 1.677228, 1.618680, 1.560131, 1.501582, 1.443033, 1.384484, 1.325936, 1.267387, 1.208838, 1.150289, 1.091740, 1.033192, 0.974643, 0.916094, 0.857545, 0.798996, 0.740448, 0.681899, 0.623350, 0.564801, 0.506252, 0.447704, 0.389155, 0.330606, 0.272057, 0.213508, 1.754960, 1.696411, 1.637862, 1.579313, 1.520764, 1.462216, 1.403667, 1.345118, 1.286569, 1.228020, 1.169472, 1.110923, 1.052374, 0.993825, 0.935276, 0.876728, 0.818179, 0.759630, 0.701081, 0.642532, 0.583984, 0.525435, 0.466886, 0.408337, 0.349788, 0.291240, 0.232691, 1.774142, 1.715593, 1.657044, 1.598496, 1.539947, 1.481398, 1.422849, 1.364300, 1.305752, 1.247203, 1.188654, 1.130105, 1.071556, 1.013008, 0.954459, 0.895910, 0.837361, 0.778812, 0.720264, 0.661715, 0.603166, 0.544617, 0.486068, 0.427520, 0.368971, 0.310422, 0.251873, 1.793324, 1.734776, 1.676227, 1.617678, 1.559129, 1.500580, 1.442032, 1.383483, 1.324934, 1.266385, 1.207836, 1.149288, 1.090739, 1.032190, 0.973641, 0.915092, 0.856544, 0.797995, 0.739446, 0.680897, 0.622348, 0.563800, 0.505251, 0.446702, 0.388153, 0.329604, 0.271056, 0.212507, 1.753958, 1.695409, 1.636860, 1.578312, 1.519763, 1.461214, 1.402665, 1.344116, 1.285568, 1.227019, 1.168470, 1.109921, 1.051372, 0.992824, 0.934275, 0.875726, 0.817177, 0.758628, 0.700080, 0.641531, 0.582982, 0.524433, 0.465884, 0.407336, 0.348787, 0.290238, 0.231689, 1.773140, 1.714592, 1.656043, 1.597494, 1.538945, 1.480396, 1.421848, 1.363299, 1.304750, 1.246201, 1.187652, 1.129104, 1.070555, 1.012006, 0.953457, 0.894908, 0.836360, 0.777811, 0.719262, 0.660713, 0.602164, 0.543616, 0.485067, 0.426518, 0.367969, 0.309420, 0.250872, 1.792323, 1.733774, 1.675225, 1.616676, 1.558128, 1.499579, 1.441030, 1.382481, 1.323932, 1.265384, 1.206835, 1.148286, 1.089737, 1.031188, 0.972640, 0.914091, 0.855542, 0.796993, 0.738444, 0.679896, 0.621347, 0.562798, 0.504249, 0.445700, 0.387152, 0.328603, 0.270054, 0.211505, 1.752956, 1.694408]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 1.699283 1.640734 1.582185 1.523636 1.465088 1.406539 1.347990 1.289441 1.230892 1.172344 1.113795 1.055246 0.996697 0.938148 0.879600 0.821051 0.762502 0.703953 0.645404 0.586856 0.528307 0.469758 0.411209 0.352660 0.294112 0.235563 1.777014 1.718465 1.659916 1.601368 1.542819 1.484270 1.425721 1.367172 1.308624 1.250075 #[0.375899, 0.317350, 0.258801, 0.200252, 1.741704, 1.683155, 1.624606, 1.566057, 1.507508, 1.448960, 1.390411, 1.331862, 1.273313, 1.214764, 1.156216, 1.097667] #[0.375899, 0.317350, 0.258801, 0.200252, 1.741704, 1.683155, 1.624606, 1.566057, 1.507508, 1.448960, 1.390411, 1.331862, 1.273313, 1.214764, 1.156216, 1.097667] #[0.375899, 0.317350, 0.258801, 0.200252, 1.741704, 1.683155, 1.624606, 1.566057, 1.507508, 1.448960, 1.390411, 1.331862, 1.273313, 1.214764, 1.156216, 1.097667, 1.039118, 0.980569, 0.922020, 0.863472, 0.804923, 0.746374, 0.687825, 0.629276, 0.570728, 0.512179, 0.453630, 0.395081, 0.336532, 0.277984, 0.219435, 1.760886, 1.702337, 1.643788, 1.585240, 1.526691, 1.468142, 1.409593, 1.351044, 1.292496, 1.233947, 1.175398, 1.116849, 1.058300, 0.999752, 0.941203, 0.882654, 0.824105, 0.765556, 0.707008, 0.648459, 0.589910, 0.531361, 0.472812, 0.414264, 0.355715, 0.297166, 0.238617, 1.780068, 1.721520, 1.662971, 1.604422, 1.545873, 1.487324, 1.428776, 1.370227, 1.311678, 1.253129, 1.194580, 1.136032, 1.077483, 1.018934, 0.960385, 0.901836, 0.843288, 0.784739, 0.726190, 0.667641, 0.609092, 0.550544, 0.491995, 0.433446, 0.374897, 0.316348, 0.257800, 1.799251, 1.740702, 1.682153, 1.623604, 1.565056, 1.506507, 1.447958, 1.389409, 1.330860, 1.272312, 1.213763, 1.155214, 1.096665, 1.038116, 0.979568, 0.921019, 0.862470, 0.803921, 0.745372, 0.686824, 0.628275, 0.569726, 0.511177, 0.452628, 0.394080, 0.335531, 0.276982, 0.218433, 1.759884, 1.701336, 1.642787, 1.584238, 1.525689, 1.467140, 1.408592, 1.350043, 1.291494, 1.232945, 1.174396, 1.115848, 1.057299, 0.998750, 0.940201, 0.881652, 0.823104, 0.764555, 0.706006, 0.647457, 0.588908, 0.530360, 0.471811, 0.413262, 0.354713, 0.296164, 0.237616, 1.779067, 1.720518, 1.661969, 1.603420, 1.544872, 1.486323, 1.427774, 1.369225, 1.310676, 1.252128, 1.193579, 1.135030, 1.076481, 1.017932, 0.959384, 0.900835, 0.842286, 0.783737, 0.725188, 0.666640, 0.608091, 0.549542, 0.490993, 0.432444, 0.373896, 0.315347, 0.256798, 1.798249, 1.739700, 1.681152, 1.622603, 1.564054, 1.505505, 1.446956, 1.388408, 1.329859, 1.271310, 1.212761, 1.154212, 1.095664, 1.037115, 0.978566, 0.920017, 0.861468, 0.802920, 0.744371, 0.685822, 0.627273, 0.568724, 0.510176, 0.451627, 0.393078, 0.334529, 0.275980, 0.217432, 1.758883, 1.700334, 1.641785, 1.583236, 1.524688, 1.466139, 1.407590, 1.349041, 1.290492, 1.231944, 1.173395, 1.114846, 1.056297, 0.997748, 0.939200, 0.880651, 0.822102, 0.763553, 0.705004, 0.646456, 0.587907, 0.529358, 0.470809, 0.412260, 0.353712, 0.295163, 0.236614, 1.778065, 1.719516, 1.660968, 1.602419, 1.543870, 1.485321, 1.426772, 1.368224, 1.309675, 1.251126, 1.192577, 1.134028, 1.075480, 1.016931, 0.958382, 0.899833, 0.841284, 0.782736, 0.724187, 0.665638, 0.607089, 0.548540, 0.489992, 0.431443, 0.372894, 0.314345, 0.255796, 1.797248, 1.738699, 1.680150, 1.621601, 1.563052, 1.504504, 1.445955, 1.387406, 1.328857, 1.270308, 1.211760, 1.153211, 1.094662, 1.036113, 0.977564, 0.919016, 0.860467, 0.801918, 0.743369, 0.684820, 0.626272, 0.567723, 0.509174, 0.450625, 0.392076, 0.333528, 0.274979, 0.216430, 1.757881, 1.699332, 1.640784, 1.582235, 1.523686, 1.465137, 1.406588, 1.348040, 1.289491, 1.230942, 1.172393, 1.113844, 1.055296, 0.996747, 0.938198, 0.879649, 0.821100, 0.762552, 0.704003, 0.645454, 0.586905, 0.528356, 0.469808, 0.411259, 0.352710, 0.294161, 0.235612, 1.777064, 1.718515, 1.659966, 1.601417, 1.542868, 1.484320, 1.425771, 1.367222, 1.308673, 1.250124, 1.191576, 1.133027, 1.074478, 1.015929, 0.957380, 0.898832, 0.840283, 0.781734, 0.723185, 0.664636, 0.606088, 0.547539, 0.488990, 0.430441, 0.371892, 0.313344, 0.254795, 1.796246, 1.737697, 1.679148, 1.620600, 1.562051, 1.503502, 1.444953, 1.386404, 1.327856, 1.269307, 1.210758, 1.152209, 1.093660, 1.035112, 0.976563, 0.918014, 0.859465, 0.800916, 0.742368, 0.683819, 0.625270, 0.566721, 0.508172, 0.449624, 0.391075, 0.332526, 0.273977, 0.215428, 1.756880, 1.698331, 1.639782, 1.581233, 1.522684, 1.464136, 1.405587, 1.347038, 1.288489, 1.229940, 1.171392, 1.112843, 1.054294, 0.995745, 0.937196, 0.878648, 0.820099, 0.761550, 0.703001, 0.644452, 0.585904, 0.527355, 0.468806, 0.410257, 0.351708, 0.293160, 0.234611, 1.776062, 1.717513, 1.658964, 1.600416, 1.541867, 1.483318, 1.424769, 1.366220, 1.307672, 1.249123, 1.190574, 1.132025, 1.073476, 1.014928, 0.956379, 0.897830, 0.839281, 0.780732, 0.722184, 0.663635, 0.605086, 0.546537, 0.487988, 0.429440, 0.370891, 0.312342, 0.253793, 1.795244, 1.736696, 1.678147, 1.619598, 1.561049, 1.502500, 1.443952, 1.385403, 1.326854, 1.268305, 1.209756, 1.151208, 1.092659, 1.034110, 0.975561, 0.917012, 0.858464, 0.799915, 0.741366, 0.682817, 0.624268, 0.565720, 0.507171, 0.448622, 0.390073, 0.331524, 0.272976, 0.214427, 1.755878, 1.697329, 1.638780, 1.580232, 1.521683, 1.463134, 1.404585, 1.346036, 1.287488, 1.228939, 1.170390, 1.111841, 1.053292, 0.994744, 0.936195, 0.877646, 0.819097, 0.760548, 0.702000, 0.643451, 0.584902, 0.526353, 0.467804, 0.409256, 0.350707, 0.292158, 0.233609, 1.775060, 1.716512, 1.657963, 1.599414, 1.540865, 1.482316, 1.423768, 1.365219, 1.306670, 1.248121, 1.189572, 1.131024, 1.072475, 1.013926, 0.955377, 0.896828, 0.838280, 0.779731, 0.721182, 0.662633, 0.604084, 0.545536, 0.486987, 0.428438, 0.369889, 0.311340, 0.252792, 1.794243, 1.735694, 1.677145, 1.618596, 1.560048, 1.501499, 1.442950, 1.384401, 1.325852, 1.267304, 1.208755, 1.150206, 1.091657, 1.033108, 0.974560, 0.916011, 0.857462, 0.798913, 0.740364, 0.681816, 0.623267, 0.564718, 0.506169, 0.447620, 0.389072, 0.330523, 0.271974, 0.213425, 1.754876, 1.696328, 1.637779, 1.579230, 1.520681, 1.462132, 1.403584, 1.345035, 1.286486, 1.227937, 1.169388, 1.110840, 1.052291, 0.993742, 0.935193, 0.876644, 0.818096, 0.759547, 0.700998, 0.642449, 0.583900, 0.525352, 0.466803, 0.408254, 0.349705, 0.291156, 0.232608, 1.774059, 1.715510, 1.656961, 1.598412, 1.539864, 1.481315, 1.422766, 1.364217, 1.305668, 1.247120, 1.188571, 1.130022, 1.071473, 1.012924, 0.954376, 0.895827, 0.837278, 0.778729, 0.720180, 0.661632, 0.603083, 0.544534, 0.485985, 0.427436, 0.368888, 0.310339, 0.251790, 1.793241, 1.734692, 1.676144, 1.617595, 1.559046, 1.500497, 1.441948, 1.383400, 1.324851, 1.266302, 1.207753, 1.149204, 1.090656, 1.032107, 0.973558, 0.915009, 0.856460, 0.797912, 0.739363, 0.680814, 0.622265, 0.563716, 0.505168, 0.446619, 0.388070, 0.329521, 0.270972, 0.212424, 1.753875, 1.695326, 1.636777, 1.578228, 1.519680, 1.461131, 1.402582, 1.344033, 1.285484, 1.226936, 1.168387, 1.109838, 1.051289, 0.992740, 0.934192, 0.875643, 0.817094, 0.758545, 0.699996, 0.641448, 0.582899, 0.524350, 0.465801, 0.407252, 0.348704, 0.290155, 0.231606, 1.773057, 1.714508, 1.655960, 1.597411, 1.538862, 1.480313, 1.421764, 1.363216]))

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

def hashemiLoop (az : Float) (t : Float) (slack : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (mcp : Float) (Twall : Float) (Ta : Float) (tautPrev : Float) (holdsPrev : Float) (tDead : Float) (b2_0 : Float) (b2_1 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Array Float :=
  let v887 := (azSun - az)
  let v890 := ((2 : Float) * (3.141592653589793 : Float))
  let v895 := (v887 - (v890 * (Float.floor ((v887 + (3.141592653589793 : Float)) / v890))))
  let v896 := ((3.141592653589793 : Float) / (2 : Float))
  let v898 := ((v896 - t) - elSun)
  let v901 := ((hist[0]! - (300 : Float)) / (300 : Float))
  let v906 := (1.0 / (1.0 + Float.exp (-((elSun - (v896 - tDead)) / (0.01 : Float)))))
  let v907 := (Float.sin t)
  let v909 := (v907 * (Float.cos az))
  let v911 := (v907 * (Float.sin az))
  let v912 := (Float.cos t)
  let v913 := (Float.cos elSun)
  let v915 := (v913 * (Float.cos azSun))
  let v917 := (v913 * (Float.sin azSun))
  let v918 := (Float.sin elSun)
  let v923 := (((v909 * v915) + (v911 * v917)) + (v912 * v918))
  let v938 := (Float.sqrt (((((v911 * v918) - (v912 * v917)) ^ 2) + (((v912 * v915) - (v909 * v918)) ^ 2)) + (((v909 * v917) - (v911 * v915)) ^ 2)))
  let v949 := (if (v923 <= (0 : Float)) then (v896 + (Float.atan ((-v923) / (max v938 (0.000000000001 : Float))))) else (Float.atan (v938 / v923)))
  let v953 := (1.0 / (1.0 + Float.exp (-((v949 - (0.03 : Float)) / (0.01 : Float)))))
  let v954 := (v906 * v953)
  let v972 := (Float.tanh (((W1[0 * 8 + 0]! * v895) + ((W1[0 * 8 + 1]! * v898) + ((W1[0 * 8 + 2]! * t) + ((W1[0 * 8 + 3]! * tautPrev) + ((W1[0 * 8 + 4]! * holdsPrev) + ((W1[0 * 8 + 5]! * v901) + ((W1[0 * 8 + 6]! * v906) + ((W1[0 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[0]!))
  let v990 := (Float.tanh (((W1[1 * 8 + 0]! * v895) + ((W1[1 * 8 + 1]! * v898) + ((W1[1 * 8 + 2]! * t) + ((W1[1 * 8 + 3]! * tautPrev) + ((W1[1 * 8 + 4]! * holdsPrev) + ((W1[1 * 8 + 5]! * v901) + ((W1[1 * 8 + 6]! * v906) + ((W1[1 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[1]!))
  let v1008 := (Float.tanh (((W1[2 * 8 + 0]! * v895) + ((W1[2 * 8 + 1]! * v898) + ((W1[2 * 8 + 2]! * t) + ((W1[2 * 8 + 3]! * tautPrev) + ((W1[2 * 8 + 4]! * holdsPrev) + ((W1[2 * 8 + 5]! * v901) + ((W1[2 * 8 + 6]! * v906) + ((W1[2 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[2]!))
  let v1026 := (Float.tanh (((W1[3 * 8 + 0]! * v895) + ((W1[3 * 8 + 1]! * v898) + ((W1[3 * 8 + 2]! * t) + ((W1[3 * 8 + 3]! * tautPrev) + ((W1[3 * 8 + 4]! * holdsPrev) + ((W1[3 * 8 + 5]! * v901) + ((W1[3 * 8 + 6]! * v906) + ((W1[3 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[3]!))
  let v1044 := (Float.tanh (((W1[4 * 8 + 0]! * v895) + ((W1[4 * 8 + 1]! * v898) + ((W1[4 * 8 + 2]! * t) + ((W1[4 * 8 + 3]! * tautPrev) + ((W1[4 * 8 + 4]! * holdsPrev) + ((W1[4 * 8 + 5]! * v901) + ((W1[4 * 8 + 6]! * v906) + ((W1[4 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[4]!))
  let v1062 := (Float.tanh (((W1[5 * 8 + 0]! * v895) + ((W1[5 * 8 + 1]! * v898) + ((W1[5 * 8 + 2]! * t) + ((W1[5 * 8 + 3]! * tautPrev) + ((W1[5 * 8 + 4]! * holdsPrev) + ((W1[5 * 8 + 5]! * v901) + ((W1[5 * 8 + 6]! * v906) + ((W1[5 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[5]!))
  let v1080 := (Float.tanh (((W1[6 * 8 + 0]! * v895) + ((W1[6 * 8 + 1]! * v898) + ((W1[6 * 8 + 2]! * t) + ((W1[6 * 8 + 3]! * tautPrev) + ((W1[6 * 8 + 4]! * holdsPrev) + ((W1[6 * 8 + 5]! * v901) + ((W1[6 * 8 + 6]! * v906) + ((W1[6 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[6]!))
  let v1098 := (Float.tanh (((W1[7 * 8 + 0]! * v895) + ((W1[7 * 8 + 1]! * v898) + ((W1[7 * 8 + 2]! * t) + ((W1[7 * 8 + 3]! * tautPrev) + ((W1[7 * 8 + 4]! * holdsPrev) + ((W1[7 * 8 + 5]! * v901) + ((W1[7 * 8 + 6]! * v906) + ((W1[7 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[7]!))
  let v1116 := (Float.tanh (((W1[8 * 8 + 0]! * v895) + ((W1[8 * 8 + 1]! * v898) + ((W1[8 * 8 + 2]! * t) + ((W1[8 * 8 + 3]! * tautPrev) + ((W1[8 * 8 + 4]! * holdsPrev) + ((W1[8 * 8 + 5]! * v901) + ((W1[8 * 8 + 6]! * v906) + ((W1[8 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[8]!))
  let v1134 := (Float.tanh (((W1[9 * 8 + 0]! * v895) + ((W1[9 * 8 + 1]! * v898) + ((W1[9 * 8 + 2]! * t) + ((W1[9 * 8 + 3]! * tautPrev) + ((W1[9 * 8 + 4]! * holdsPrev) + ((W1[9 * 8 + 5]! * v901) + ((W1[9 * 8 + 6]! * v906) + ((W1[9 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[9]!))
  let v1152 := (Float.tanh (((W1[10 * 8 + 0]! * v895) + ((W1[10 * 8 + 1]! * v898) + ((W1[10 * 8 + 2]! * t) + ((W1[10 * 8 + 3]! * tautPrev) + ((W1[10 * 8 + 4]! * holdsPrev) + ((W1[10 * 8 + 5]! * v901) + ((W1[10 * 8 + 6]! * v906) + ((W1[10 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[10]!))
  let v1170 := (Float.tanh (((W1[11 * 8 + 0]! * v895) + ((W1[11 * 8 + 1]! * v898) + ((W1[11 * 8 + 2]! * t) + ((W1[11 * 8 + 3]! * tautPrev) + ((W1[11 * 8 + 4]! * holdsPrev) + ((W1[11 * 8 + 5]! * v901) + ((W1[11 * 8 + 6]! * v906) + ((W1[11 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[11]!))
  let v1188 := (Float.tanh (((W1[12 * 8 + 0]! * v895) + ((W1[12 * 8 + 1]! * v898) + ((W1[12 * 8 + 2]! * t) + ((W1[12 * 8 + 3]! * tautPrev) + ((W1[12 * 8 + 4]! * holdsPrev) + ((W1[12 * 8 + 5]! * v901) + ((W1[12 * 8 + 6]! * v906) + ((W1[12 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[12]!))
  let v1206 := (Float.tanh (((W1[13 * 8 + 0]! * v895) + ((W1[13 * 8 + 1]! * v898) + ((W1[13 * 8 + 2]! * t) + ((W1[13 * 8 + 3]! * tautPrev) + ((W1[13 * 8 + 4]! * holdsPrev) + ((W1[13 * 8 + 5]! * v901) + ((W1[13 * 8 + 6]! * v906) + ((W1[13 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[13]!))
  let v1224 := (Float.tanh (((W1[14 * 8 + 0]! * v895) + ((W1[14 * 8 + 1]! * v898) + ((W1[14 * 8 + 2]! * t) + ((W1[14 * 8 + 3]! * tautPrev) + ((W1[14 * 8 + 4]! * holdsPrev) + ((W1[14 * 8 + 5]! * v901) + ((W1[14 * 8 + 6]! * v906) + ((W1[14 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[14]!))
  let v1242 := (Float.tanh (((W1[15 * 8 + 0]! * v895) + ((W1[15 * 8 + 1]! * v898) + ((W1[15 * 8 + 2]! * t) + ((W1[15 * 8 + 3]! * tautPrev) + ((W1[15 * 8 + 4]! * holdsPrev) + ((W1[15 * 8 + 5]! * v901) + ((W1[15 * 8 + 6]! * v906) + ((W1[15 * 8 + 7]! * v954) + (0 : Float))))))))) + b1[15]!))
  let v1312 := (-(1.22 : Float))
  let v1315 := (-(0.8 : Float))
  let v1323 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v1324 := (-v1323)
  let v1326 := ((v1315 * v912) + (v1324 * v907))
  let v1327 := (-v1315)
  let v1330 := ((v1327 * v907) + (v1324 * v912))
  let v1339 := (Float.sqrt (((v1326 - v1312) ^ 2) + ((v1330 - (0.34 : Float)) ^ 2)))
  let v1340 := (((v1312 * v1330) - ((0.34 : Float) * v1326)) / v1339)
  let v1356 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  let v1365 := ((1.22 : Float) * (0.8 : Float))
  let v1366 := ((0.34 : Float) * v1323)
  let v1374 := (if (v1365 <= v1366) then v896 else (Float.atan ((((1.22 : Float) * v1323) + ((0.34 : Float) * (0.8 : Float))) / (v1365 - v1366))))
  let v1375 := (Float.cos (0 : Float))
  let v1377 := (Float.sin (0 : Float))
  let v1388 := (Float.sqrt (((((v1315 * v1375) + (v1324 * v1377)) - v1312) ^ 2) + ((((v1327 * v1377) + (v1324 * v1375)) - (0.34 : Float)) ^ 2)))
  let v1389 := (Float.cos v1374)
  let v1391 := (Float.sin v1374)
  let v1402 := (Float.sqrt (((((v1315 * v1389) + (v1324 * v1391)) - v1312) ^ 2) + ((((v1327 * v1391) + (v1324 * v1389)) - (0.34 : Float)) ^ 2)))
  let v1404 := (((((Float.tanh (((W2[1 * 16 + 0]! * v972) + ((W2[1 * 16 + 1]! * v990) + ((W2[1 * 16 + 2]! * v1008) + ((W2[1 * 16 + 3]! * v1026) + ((W2[1 * 16 + 4]! * v1044) + ((W2[1 * 16 + 5]! * v1062) + ((W2[1 * 16 + 6]! * v1080) + ((W2[1 * 16 + 7]! * v1098) + ((W2[1 * 16 + 8]! * v1116) + ((W2[1 * 16 + 9]! * v1134) + ((W2[1 * 16 + 10]! * v1152) + ((W2[1 * 16 + 11]! * v1170) + ((W2[1 * 16 + 12]! * v1188) + ((W2[1 * 16 + 13]! * v1206) + ((W2[1 * 16 + 14]! * v1224) + ((W2[1 * 16 + 15]! * v1242) + (0 : Float))))))))))))))))) + b2_1)) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1340) / rDrum) * rDrum)
  let v1406 := ((v1339 + slack) - (v1404 * dt))
  let v1407 := (v1406 < v1402)
  let v1408 := (v1388 < v1406)
  let v1410 := (if v1407 then v1402 else (if v1408 then v1388 else v1406))
  let v1415 := (((0 : Float) + v1374) / (2 : Float))
  let v1416 := (Float.cos v1415)
  let v1418 := (Float.sin v1415)
  let v1430 := (v1410 < (Float.sqrt (((((v1315 * v1416) + (v1324 * v1418)) - v1312) ^ 2) + ((((v1327 * v1418) + (v1324 * v1416)) - (0.34 : Float)) ^ 2))))
  let v1431 := (if v1430 then v1415 else (0 : Float))
  let v1432 := (if v1430 then v1374 else v1415)
  let v1434 := ((v1431 + v1432) / (2 : Float))
  let v1435 := (Float.cos v1434)
  let v1437 := (Float.sin v1434)
  let v1449 := (v1410 < (Float.sqrt (((((v1315 * v1435) + (v1324 * v1437)) - v1312) ^ 2) + ((((v1327 * v1437) + (v1324 * v1435)) - (0.34 : Float)) ^ 2))))
  let v1450 := (if v1449 then v1434 else v1431)
  let v1451 := (if v1449 then v1432 else v1434)
  let v1453 := ((v1450 + v1451) / (2 : Float))
  let v1454 := (Float.cos v1453)
  let v1456 := (Float.sin v1453)
  let v1468 := (v1410 < (Float.sqrt (((((v1315 * v1454) + (v1324 * v1456)) - v1312) ^ 2) + ((((v1327 * v1456) + (v1324 * v1454)) - (0.34 : Float)) ^ 2))))
  let v1469 := (if v1468 then v1453 else v1450)
  let v1470 := (if v1468 then v1451 else v1453)
  let v1472 := ((v1469 + v1470) / (2 : Float))
  let v1473 := (Float.cos v1472)
  let v1475 := (Float.sin v1472)
  let v1487 := (v1410 < (Float.sqrt (((((v1315 * v1473) + (v1324 * v1475)) - v1312) ^ 2) + ((((v1327 * v1475) + (v1324 * v1473)) - (0.34 : Float)) ^ 2))))
  let v1488 := (if v1487 then v1472 else v1469)
  let v1489 := (if v1487 then v1470 else v1472)
  let v1491 := ((v1488 + v1489) / (2 : Float))
  let v1492 := (Float.cos v1491)
  let v1494 := (Float.sin v1491)
  let v1506 := (v1410 < (Float.sqrt (((((v1315 * v1492) + (v1324 * v1494)) - v1312) ^ 2) + ((((v1327 * v1494) + (v1324 * v1492)) - (0.34 : Float)) ^ 2))))
  let v1507 := (if v1506 then v1491 else v1488)
  let v1508 := (if v1506 then v1489 else v1491)
  let v1510 := ((v1507 + v1508) / (2 : Float))
  let v1511 := (Float.cos v1510)
  let v1513 := (Float.sin v1510)
  let v1525 := (v1410 < (Float.sqrt (((((v1315 * v1511) + (v1324 * v1513)) - v1312) ^ 2) + ((((v1327 * v1513) + (v1324 * v1511)) - (0.34 : Float)) ^ 2))))
  let v1526 := (if v1525 then v1510 else v1507)
  let v1527 := (if v1525 then v1508 else v1510)
  let v1529 := ((v1526 + v1527) / (2 : Float))
  let v1530 := (Float.cos v1529)
  let v1532 := (Float.sin v1529)
  let v1544 := (v1410 < (Float.sqrt (((((v1315 * v1530) + (v1324 * v1532)) - v1312) ^ 2) + ((((v1327 * v1532) + (v1324 * v1530)) - (0.34 : Float)) ^ 2))))
  let v1545 := (if v1544 then v1529 else v1526)
  let v1546 := (if v1544 then v1527 else v1529)
  let v1548 := ((v1545 + v1546) / (2 : Float))
  let v1549 := (Float.cos v1548)
  let v1551 := (Float.sin v1548)
  let v1563 := (v1410 < (Float.sqrt (((((v1315 * v1549) + (v1324 * v1551)) - v1312) ^ 2) + ((((v1327 * v1551) + (v1324 * v1549)) - (0.34 : Float)) ^ 2))))
  let v1564 := (if v1563 then v1548 else v1545)
  let v1565 := (if v1563 then v1546 else v1548)
  let v1567 := ((v1564 + v1565) / (2 : Float))
  let v1568 := (Float.cos v1567)
  let v1570 := (Float.sin v1567)
  let v1582 := (v1410 < (Float.sqrt (((((v1315 * v1568) + (v1324 * v1570)) - v1312) ^ 2) + ((((v1327 * v1570) + (v1324 * v1568)) - (0.34 : Float)) ^ 2))))
  let v1583 := (if v1582 then v1567 else v1564)
  let v1584 := (if v1582 then v1565 else v1567)
  let v1586 := ((v1583 + v1584) / (2 : Float))
  let v1587 := (Float.cos v1586)
  let v1589 := (Float.sin v1586)
  let v1601 := (v1410 < (Float.sqrt (((((v1315 * v1587) + (v1324 * v1589)) - v1312) ^ 2) + ((((v1327 * v1589) + (v1324 * v1587)) - (0.34 : Float)) ^ 2))))
  let v1602 := (if v1601 then v1586 else v1583)
  let v1603 := (if v1601 then v1584 else v1586)
  let v1605 := ((v1602 + v1603) / (2 : Float))
  let v1606 := (Float.cos v1605)
  let v1608 := (Float.sin v1605)
  let v1620 := (v1410 < (Float.sqrt (((((v1315 * v1606) + (v1324 * v1608)) - v1312) ^ 2) + ((((v1327 * v1608) + (v1324 * v1606)) - (0.34 : Float)) ^ 2))))
  let v1621 := (if v1620 then v1605 else v1602)
  let v1622 := (if v1620 then v1603 else v1605)
  let v1624 := ((v1621 + v1622) / (2 : Float))
  let v1625 := (Float.cos v1624)
  let v1627 := (Float.sin v1624)
  let v1639 := (v1410 < (Float.sqrt (((((v1315 * v1625) + (v1324 * v1627)) - v1312) ^ 2) + ((((v1327 * v1627) + (v1324 * v1625)) - (0.34 : Float)) ^ 2))))
  let v1640 := (if v1639 then v1624 else v1621)
  let v1641 := (if v1639 then v1622 else v1624)
  let v1643 := ((v1640 + v1641) / (2 : Float))
  let v1644 := (Float.cos v1643)
  let v1646 := (Float.sin v1643)
  let v1658 := (v1410 < (Float.sqrt (((((v1315 * v1644) + (v1324 * v1646)) - v1312) ^ 2) + ((((v1327 * v1646) + (v1324 * v1644)) - (0.34 : Float)) ^ 2))))
  let v1659 := (if v1658 then v1643 else v1640)
  let v1660 := (if v1658 then v1641 else v1643)
  let v1662 := ((v1659 + v1660) / (2 : Float))
  let v1663 := (Float.cos v1662)
  let v1665 := (Float.sin v1662)
  let v1677 := (v1410 < (Float.sqrt (((((v1315 * v1663) + (v1324 * v1665)) - v1312) ^ 2) + ((((v1327 * v1665) + (v1324 * v1663)) - (0.34 : Float)) ^ 2))))
  let v1678 := (if v1677 then v1662 else v1659)
  let v1679 := (if v1677 then v1660 else v1662)
  let v1681 := ((v1678 + v1679) / (2 : Float))
  let v1682 := (Float.cos v1681)
  let v1684 := (Float.sin v1681)
  let v1696 := (v1410 < (Float.sqrt (((((v1315 * v1682) + (v1324 * v1684)) - v1312) ^ 2) + ((((v1327 * v1684) + (v1324 * v1682)) - (0.34 : Float)) ^ 2))))
  let v1697 := (if v1696 then v1681 else v1678)
  let v1698 := (if v1696 then v1679 else v1681)
  let v1700 := ((v1697 + v1698) / (2 : Float))
  let v1701 := (Float.cos v1700)
  let v1703 := (Float.sin v1700)
  let v1715 := (v1410 < (Float.sqrt (((((v1315 * v1701) + (v1324 * v1703)) - v1312) ^ 2) + ((((v1327 * v1703) + (v1324 * v1701)) - (0.34 : Float)) ^ 2))))
  let v1716 := (if v1715 then v1700 else v1697)
  let v1717 := (if v1715 then v1698 else v1700)
  let v1719 := ((v1716 + v1717) / (2 : Float))
  let v1720 := (Float.cos v1719)
  let v1722 := (Float.sin v1719)
  let v1734 := (v1410 < (Float.sqrt (((((v1315 * v1720) + (v1324 * v1722)) - v1312) ^ 2) + ((((v1327 * v1722) + (v1324 * v1720)) - (0.34 : Float)) ^ 2))))
  let v1735 := (if v1734 then v1719 else v1716)
  let v1736 := (if v1734 then v1717 else v1719)
  let v1738 := ((v1735 + v1736) / (2 : Float))
  let v1739 := (Float.cos v1738)
  let v1741 := (Float.sin v1738)
  let v1753 := (v1410 < (Float.sqrt (((((v1315 * v1739) + (v1324 * v1741)) - v1312) ^ 2) + ((((v1327 * v1741) + (v1324 * v1739)) - (0.34 : Float)) ^ 2))))
  let v1754 := (if v1753 then v1738 else v1735)
  let v1755 := (if v1753 then v1736 else v1738)
  let v1757 := ((v1754 + v1755) / (2 : Float))
  let v1758 := (Float.cos v1757)
  let v1760 := (Float.sin v1757)
  let v1772 := (v1410 < (Float.sqrt (((((v1315 * v1758) + (v1324 * v1760)) - v1312) ^ 2) + ((((v1327 * v1760) + (v1324 * v1758)) - (0.34 : Float)) ^ 2))))
  let v1773 := (if v1772 then v1757 else v1754)
  let v1774 := (if v1772 then v1755 else v1757)
  let v1776 := ((v1773 + v1774) / (2 : Float))
  let v1777 := (Float.cos v1776)
  let v1779 := (Float.sin v1776)
  let v1791 := (v1410 < (Float.sqrt (((((v1315 * v1777) + (v1324 * v1779)) - v1312) ^ 2) + ((((v1327 * v1779) + (v1324 * v1777)) - (0.34 : Float)) ^ 2))))
  let v1792 := (if v1791 then v1776 else v1773)
  let v1793 := (if v1791 then v1774 else v1776)
  let v1795 := ((v1792 + v1793) / (2 : Float))
  let v1796 := (Float.cos v1795)
  let v1798 := (Float.sin v1795)
  let v1810 := (v1410 < (Float.sqrt (((((v1315 * v1796) + (v1324 * v1798)) - v1312) ^ 2) + ((((v1327 * v1798) + (v1324 * v1796)) - (0.34 : Float)) ^ 2))))
  let v1811 := (if v1810 then v1795 else v1792)
  let v1812 := (if v1810 then v1793 else v1795)
  let v1814 := ((v1811 + v1812) / (2 : Float))
  let v1815 := (Float.cos v1814)
  let v1817 := (Float.sin v1814)
  let v1829 := (v1410 < (Float.sqrt (((((v1315 * v1815) + (v1324 * v1817)) - v1312) ^ 2) + ((((v1327 * v1817) + (v1324 * v1815)) - (0.34 : Float)) ^ 2))))
  let v1830 := (if v1829 then v1814 else v1811)
  let v1831 := (if v1829 then v1812 else v1814)
  let v1833 := ((v1830 + v1831) / (2 : Float))
  let v1834 := (Float.cos v1833)
  let v1836 := (Float.sin v1833)
  let v1848 := (v1410 < (Float.sqrt (((((v1315 * v1834) + (v1324 * v1836)) - v1312) ^ 2) + ((((v1327 * v1836) + (v1324 * v1834)) - (0.34 : Float)) ^ 2))))
  let v1849 := (if v1848 then v1833 else v1830)
  let v1850 := (if v1848 then v1831 else v1833)
  let v1852 := ((v1849 + v1850) / (2 : Float))
  let v1853 := (Float.cos v1852)
  let v1855 := (Float.sin v1852)
  let v1867 := (v1410 < (Float.sqrt (((((v1315 * v1853) + (v1324 * v1855)) - v1312) ^ 2) + ((((v1327 * v1855) + (v1324 * v1853)) - (0.34 : Float)) ^ 2))))
  let v1872 := (if (v1388 <= v1406) then (0 : Float) else (((if v1867 then v1852 else v1849) + (if v1867 then v1850 else v1852)) / (2 : Float)))
  let v1873 := (W * rcm)
  let v1874 := (Float.cos v1872)
  let v1876 := (Float.sin v1872)
  let v1878 := ((v1315 * v1874) + (v1324 * v1876))
  let v1881 := ((v1327 * v1876) + (v1324 * v1874))
  let v1896 := ((t < v1872) && (!(v1873 <= (Tmax * (((v1312 * v1881) - ((0.34 : Float) * v1878)) / (Float.sqrt (((v1878 - v1312) ^ 2) + ((v1881 - (0.34 : Float)) ^ 2))))))))
  let v1897 := (if v1896 then t else v1872)
  let v1902 := (az + (((((((Float.tanh (((W2[0 * 16 + 0]! * v972) + ((W2[0 * 16 + 1]! * v990) + ((W2[0 * 16 + 2]! * v1008) + ((W2[0 * 16 + 3]! * v1026) + ((W2[0 * 16 + 4]! * v1044) + ((W2[0 * 16 + 5]! * v1062) + ((W2[0 * 16 + 6]! * v1080) + ((W2[0 * 16 + 7]! * v1098) + ((W2[0 * 16 + 8]! * v1116) + ((W2[0 * 16 + 9]! * v1134) + ((W2[0 * 16 + 10]! * v1152) + ((W2[0 * 16 + 11]! * v1170) + ((W2[0 * 16 + 12]! * v1188) + ((W2[0 * 16 + 13]! * v1206) + ((W2[0 * 16 + 14]! * v1224) + ((W2[0 * 16 + 15]! * v1242) + (0 : Float))))))))))))))))) + b2_0)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1356) / (0.05 : Float)) * (0.05 : Float)) / v1356) * dt))
  let v1907 := (Float.cos v1897)
  let v1909 := (Float.sin v1897)
  let v1911 := ((v1315 * v1907) + (v1324 * v1909))
  let v1914 := ((v1327 * v1909) + (v1324 * v1907))
  let v1929 := (v896 - v1374)
  let v1930 := (v1929 <= elSun)
  let v1939 := (Float.cos v1902)
  let v1940 := (v1909 * v1939)
  let v1941 := (Float.sin v1902)
  let v1942 := (v1909 * v1941)
  let v1943 := (v1907 * v1939)
  let v1944 := (v1907 * v1941)
  let v1945 := (-v1909)
  let v1970 := ((2 : Float) * a)
  let v1971 := (v1970 / w)
  let v1973 := (w / (2 : Float))
  let v1974 := ((-a) + v1973)
  let v1993 := ((1 : Float) / (2 : Float))
  let v1998 := (-(((((v1944 * v1907) - (v1945 * v1942)) * v915) + (((v1945 * v1940) - (v1943 * v1907)) * v917)) + (((v1943 * v1942) - (v1944 * v1940)) * v918)))
  let v1999 := (-(((v1943 * v915) + (v1944 * v917)) + (v1945 * v918)))
  let v2000 := (-(((v1940 * v915) + (v1942 * v917)) + (v1907 * v918)))
  let v2005 := ((Float.abs v2000) < ((9 : Float) / (10 : Float)))
  let v2006 := (if v2005 then (0 : Float) else (1 : Float))
  let v2007 := (if v2005 then (1 : Float) else (0 : Float))
  let v2010 := ((v1999 * v2007) - (v2000 * (0 : Float)))
  let v2013 := ((v2000 * v2006) - (v1998 * v2007))
  let v2016 := ((v1998 * (0 : Float)) - (v1999 * v2006))
  let v2024 := (Float.sqrt (max (((v2010 ^ 2) + (v2013 ^ 2)) + (v2016 ^ 2)) (0.000000000000000001 : Float)))
  let v2025 := (v2010 / v2024)
  let v2026 := (v2013 / v2024)
  let v2027 := (v2016 / v2024)
  let v2075 := ((2 : Float) * f)
  let v2076 := ((1 : Float) / R)
  let v2185 := (v1970 ^ 2)
  let v2186 := (v2185 * rho)
  let v2192 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); v2180)) 0.0)
  let v2195 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (1.0 / (1.0 + Float.exp (-((rc - v2175) / (0.005 : Float))))))) 0.0)
  let v2213 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((0 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2218 := (((((v2213 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2229 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((1 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2234 := (((((v2229 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2245 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((2 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2250 := (((((v2245 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2262 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((3 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2267 := (((((v2262 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2279 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((4 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2284 := (((((v2279 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2296 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((5 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2301 := (((((v2296 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2313 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((6 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2318 := (((((v2313 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2330 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2072 := (((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); let v2177 := ((0 : Float) < v2165); let v2178 := ((v2175 <= rc) && v2177); let v2180 := (if (v2072 && v2178) then (1 : Float) else (0 : Float)); let v2210 := (v2180 > (0.5 : Float)); (if ((((((7 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && v2210) then (1 : Float) else (0 : Float)))) 0.0)
  let v2335 := (((((v2330 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2340 := (Float.exp ((-(Upipe / (2 : Float))) / mcp))
  let v2342 := (Ta + ((hist[1]! - Ta) * v2340))
  let v2346 := ((min UAx mcp) * (max (0 : Float) (v2342 - Twall)))
  let v2351 := (Ta + ((ret[1]! - Ta) * v2340))
  let v2355 := (Ac / (8 : Float))
  let v2356 := ((eps * (0.0000000567 : Float)) * v2355)
  let v2358 := (Ta ^ 4)
  let v2361 := (hC * v2355)
  let v2367 := (v2351 + (((alpha * v2218) - ((v2356 * ((v2351 ^ 4) - v2358)) + (v2361 * (v2351 - Ta)))) / mcp))
  let v2377 := (v2367 + (((alpha * v2234) - ((v2356 * ((v2367 ^ 4) - v2358)) + (v2361 * (v2367 - Ta)))) / mcp))
  let v2387 := (v2377 + (((alpha * v2250) - ((v2356 * ((v2377 ^ 4) - v2358)) + (v2361 * (v2377 - Ta)))) / mcp))
  let v2397 := (v2387 + (((alpha * v2267) - ((v2356 * ((v2387 ^ 4) - v2358)) + (v2361 * (v2387 - Ta)))) / mcp))
  let v2407 := (v2397 + (((alpha * v2284) - ((v2356 * ((v2397 ^ 4) - v2358)) + (v2361 * (v2397 - Ta)))) / mcp))
  let v2417 := (v2407 + (((alpha * v2301) - ((v2356 * ((v2407 ^ 4) - v2358)) + (v2361 * (v2407 - Ta)))) / mcp))
  let v2427 := (v2417 + (((alpha * v2318) - ((v2356 * ((v2417 ^ 4) - v2358)) + (v2361 * (v2417 - Ta)))) / mcp))
  let v2437 := (v2427 + (((alpha * v2335) - ((v2356 * ((v2427 ^ 4) - v2358)) + (v2361 * (v2427 - Ta)))) / mcp))
  let v2445 := (alpha * (((((((v2218 + v2234) + v2250) + v2267) + v2284) + v2301) + v2318) + v2335))
  let v2456 := (azSun - v1902)
  #[v1902, v1897, (if v1408 then (v1406 - v1388) else (0 : Float)), (if v1896 then v1339 else v1410), v1374, (if (v1407 || v1896) then (1 : Float) else (0 : Float)), (if (feq (if v1408 then (v1406 - v1388) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1873 <= (Tmax * (((v1312 * v1914) - ((0.34 : Float) * v1911)) / (Float.sqrt (((v1911 - v1312) ^ 2) + ((v1914 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), v1340, (v1404 / v1340), ((((((Float.tanh (((W2[0 * 16 + 0]! * v972) + ((W2[0 * 16 + 1]! * v990) + ((W2[0 * 16 + 2]! * v1008) + ((W2[0 * 16 + 3]! * v1026) + ((W2[0 * 16 + 4]! * v1044) + ((W2[0 * 16 + 5]! * v1062) + ((W2[0 * 16 + 6]! * v1080) + ((W2[0 * 16 + 7]! * v1098) + ((W2[0 * 16 + 8]! * v1116) + ((W2[0 * 16 + 9]! * v1134) + ((W2[0 * 16 + 10]! * v1152) + ((W2[0 * 16 + 11]! * v1170) + ((W2[0 * 16 + 12]! * v1188) + ((W2[0 * 16 + 13]! * v1206) + ((W2[0 * 16 + 14]! * v1224) + ((W2[0 * 16 + 15]! * v1242) + (0 : Float))))))))))))))))) + b2_0)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1356) / (0.05 : Float)) * (0.05 : Float)) / v1356), v949, (v896 - t), (if v1930 then (1 : Float) else (0 : Float)), (if (v1930 && ((0.03 : Float) < v949)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1929) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1929) / (0.01 : Float))))) * v953), (v2192 / (64 : Float)), (v2195 / (64 : Float)), (v2186 * (v2192 / (64 : Float))), (((v2186 * (v2192 / (64 : Float))) * dni) * soil), v2437, v2445, (v2445 - (mcp * (v2437 - v2351))), (mcp * ((hist[1]! - v2342) + (ret[1]! - v2351))), v2346, (((v2445 - (v2445 - (mcp * (v2437 - v2351)))) - (mcp * ((hist[1]! - v2342) + (ret[1]! - v2351)))) - v2346), (v2456 - (v890 * (Float.floor ((v2456 + (3.141592653589793 : Float)) / v890)))), ((v896 - v1897) - elSun), v1897, (if (feq (if v1408 then (v1406 - v1388) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1873 <= (Tmax * (((v1312 * v1914) - ((0.34 : Float) * v1911)) / (Float.sqrt (((v1911 - v1312) ^ 2) + ((v1914 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), ((v2437 - (300 : Float)) / (300 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1929) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1929) / (0.01 : Float))))) * v953), v2218, v2234, v2250, v2267, v2284, v2301, v2318, v2335, v2367, v2377, v2387, v2397, v2407, v2417, v2427, v2437, v2437, hist[0]!, hist[1]!, hist[2]!, hist[3]!, hist[4]!, hist[5]!, hist[6]!, hist[7]!, hist[8]!, hist[9]!, hist[10]!, hist[11]!, hist[12]!, hist[13]!, hist[14]!, (v2342 - (v2346 / mcp)), ret[0]!, ret[1]!, ret[2]!, ret[3]!, ret[4]!, ret[5]!, ret[6]!, ret[7]!, ret[8]!, ret[9]!, ret[10]!, ret[11]!, ret[12]!, ret[13]!, ret[14]!, v895, v898, t, tautPrev, holdsPrev, v901, v906, v954, (Float.tanh (((W2[0 * 16 + 0]! * v972) + ((W2[0 * 16 + 1]! * v990) + ((W2[0 * 16 + 2]! * v1008) + ((W2[0 * 16 + 3]! * v1026) + ((W2[0 * 16 + 4]! * v1044) + ((W2[0 * 16 + 5]! * v1062) + ((W2[0 * 16 + 6]! * v1080) + ((W2[0 * 16 + 7]! * v1098) + ((W2[0 * 16 + 8]! * v1116) + ((W2[0 * 16 + 9]! * v1134) + ((W2[0 * 16 + 10]! * v1152) + ((W2[0 * 16 + 11]! * v1170) + ((W2[0 * 16 + 12]! * v1188) + ((W2[0 * 16 + 13]! * v1206) + ((W2[0 * 16 + 14]! * v1224) + ((W2[0 * 16 + 15]! * v1242) + (0 : Float))))))))))))))))) + b2_0)), (Float.tanh (((W2[1 * 16 + 0]! * v972) + ((W2[1 * 16 + 1]! * v990) + ((W2[1 * 16 + 2]! * v1008) + ((W2[1 * 16 + 3]! * v1026) + ((W2[1 * 16 + 4]! * v1044) + ((W2[1 * 16 + 5]! * v1062) + ((W2[1 * 16 + 6]! * v1080) + ((W2[1 * 16 + 7]! * v1098) + ((W2[1 * 16 + 8]! * v1116) + ((W2[1 * 16 + 9]! * v1134) + ((W2[1 * 16 + 10]! * v1152) + ((W2[1 * 16 + 11]! * v1170) + ((W2[1 * 16 + 12]! * v1188) + ((W2[1 * 16 + 13]! * v1206) + ((W2[1 * 16 + 14]! * v1224) + ((W2[1 * 16 + 15]! * v1242) + (0 : Float))))))))))))))))) + b2_1))]

#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.617059 1.558510 1.499961 1.441412 1.382864 1.324315 1.265766 1.207217 1.148668 1.090120 1.031571 0.973022 0.914473 0.855924 0.797376 0.738827 0.680278 0.621729 0.563180 0.504632 0.446083 0.387534 0.328985 0.270436 0.211888 1.753339 1.694790 1.636241 1.577692 1.519144 1.460595 1.402046 1.343497 1.284948 1.226400 1.167851 1.109302 1.050753 0.992204 #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443, 0.956894, 0.898345, 0.839796, 0.781248, 0.722699, 0.664150, 0.605601, 0.547052, 0.488504, 0.429955, 0.371406, 0.312857, 0.254308, 1.795760, 1.737211, 1.678662, 1.620113, 1.561564, 1.503016, 1.444467, 1.385918, 1.327369, 1.268820, 1.210272, 1.151723, 1.093174, 1.034625, 0.976076, 0.917528, 0.858979, 0.800430, 0.741881, 0.683332, 0.624784, 0.566235, 0.507686, 0.449137, 0.390588, 0.332040, 0.273491, 0.214942, 1.756393, 1.697844, 1.639296, 1.580747, 1.522198, 1.463649, 1.405100, 1.346552, 1.288003, 1.229454, 1.170905, 1.112356, 1.053808, 0.995259, 0.936710, 0.878161, 0.819612, 0.761064, 0.702515, 0.643966, 0.585417, 0.526868, 0.468320, 0.409771, 0.351222, 0.292673, 0.234124, 1.775576, 1.717027, 1.658478, 1.599929, 1.541380, 1.482832, 1.424283, 1.365734, 1.307185, 1.248636, 1.190088, 1.131539, 1.072990, 1.014441, 0.955892, 0.897344, 0.838795, 0.780246, 0.721697, 0.663148, 0.604600, 0.546051, 0.487502, 0.428953, 0.370404, 0.311856, 0.253307, 1.794758, 1.736209, 1.677660, 1.619112, 1.560563, 1.502014, 1.443465, 1.384916, 1.326368, 1.267819, 1.209270, 1.150721, 1.092172, 1.033624, 0.975075, 0.916526, 0.857977] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443, 0.956894, 0.898345, 0.839796, 0.781248, 0.722699, 0.664150, 0.605601, 0.547052, 0.488504, 0.429955, 0.371406, 0.312857, 0.254308, 1.795760, 1.737211, 1.678662] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443, 0.956894, 0.898345, 0.839796, 0.781248, 0.722699, 0.664150, 0.605601, 0.547052, 0.488504, 0.429955, 0.371406, 0.312857, 0.254308, 1.795760, 1.737211, 1.678662, 1.620113, 1.561564, 1.503016, 1.444467, 1.385918, 1.327369, 1.268820, 1.210272, 1.151723, 1.093174, 1.034625, 0.976076, 0.917528, 0.858979, 0.800430, 0.741881, 0.683332, 0.624784, 0.566235, 0.507686, 0.449137, 0.390588, 0.332040, 0.273491, 0.214942, 1.756393, 1.697844, 1.639296, 1.580747, 1.522198, 1.463649, 1.405100, 1.346552, 1.288003, 1.229454, 1.170905, 1.112356, 1.053808, 0.995259, 0.936710, 0.878161, 0.819612, 0.761064, 0.702515, 0.643966, 0.585417, 0.526868, 0.468320, 0.409771, 0.351222, 0.292673, 0.234124, 1.775576, 1.717027, 1.658478, 1.599929, 1.541380, 1.482832, 1.424283, 1.365734, 1.307185, 1.248636, 1.190088, 1.131539, 1.072990, 1.014441, 0.955892, 0.897344, 0.838795, 0.780246, 0.721697, 0.663148, 0.604600, 0.546051, 0.487502, 0.428953, 0.370404, 0.311856, 0.253307, 1.794758, 1.736209, 1.677660, 1.619112, 1.560563, 1.502014, 1.443465, 1.384916, 1.326368, 1.267819, 1.209270, 1.150721, 1.092172, 1.033624, 0.975075, 0.916526, 0.857977, 0.799428, 0.740880, 0.682331, 0.623782, 0.565233, 0.506684, 0.448136, 0.389587, 0.331038, 0.272489, 0.213940, 1.755392, 1.696843, 1.638294, 1.579745, 1.521196, 1.462648, 1.404099, 1.345550, 1.287001, 1.228452, 1.169904, 1.111355, 1.052806, 0.994257, 0.935708, 0.877160, 0.818611, 0.760062, 0.701513, 0.642964, 0.584416, 0.525867, 0.467318, 0.408769, 0.350220, 0.291672, 0.233123, 1.774574, 1.716025, 1.657476, 1.598928, 1.540379, 1.481830, 1.423281, 1.364732, 1.306184, 1.247635, 1.189086, 1.130537, 1.071988, 1.013440, 0.954891, 0.896342, 0.837793, 0.779244, 0.720696, 0.662147, 0.603598, 0.545049, 0.486500, 0.427952, 0.369403, 0.310854, 0.252305, 1.793756, 1.735208, 1.676659, 1.618110, 1.559561, 1.501012, 1.442464, 1.383915, 1.325366, 1.266817, 1.208268, 1.149720, 1.091171, 1.032622, 0.974073, 0.915524, 0.856976, 0.798427, 0.739878, 0.681329, 0.622780, 0.564232, 0.505683, 0.447134, 0.388585, 0.330036, 0.271488, 0.212939, 1.754390, 1.695841, 1.637292, 1.578744, 1.520195, 1.461646, 1.403097, 1.344548, 1.286000, 1.227451, 1.168902, 1.110353, 1.051804, 0.993256, 0.934707, 0.876158, 0.817609, 0.759060, 0.700512, 0.641963, 0.583414, 0.524865, 0.466316, 0.407768, 0.349219, 0.290670, 0.232121, 1.773572, 1.715024, 1.656475, 1.597926, 1.539377, 1.480828, 1.422280, 1.363731, 1.305182, 1.246633, 1.188084, 1.129536, 1.070987, 1.012438, 0.953889, 0.895340, 0.836792, 0.778243, 0.719694, 0.661145, 0.602596, 0.544048, 0.485499, 0.426950, 0.368401, 0.309852, 0.251304, 1.792755, 1.734206, 1.675657, 1.617108, 1.558560, 1.500011, 1.441462, 1.382913, 1.324364, 1.265816, 1.207267, 1.148718, 1.090169, 1.031620, 0.973072, 0.914523, 0.855974, 0.797425, 0.738876, 0.680328, 0.621779, 0.563230, 0.504681, 0.446132, 0.387584, 0.329035, 0.270486, 0.211937, 1.753388, 1.694840, 1.636291, 1.577742, 1.519193, 1.460644, 1.402096, 1.343547, 1.284998, 1.226449, 1.167900, 1.109352, 1.050803, 0.992254, 0.933705, 0.875156, 0.816608, 0.758059, 0.699510, 0.640961, 0.582412, 0.523864, 0.465315, 0.406766, 0.348217, 0.289668, 0.231120, 1.772571, 1.714022, 1.655473, 1.596924, 1.538376, 1.479827, 1.421278, 1.362729, 1.304180, 1.245632, 1.187083, 1.128534, 1.069985, 1.011436, 0.952888, 0.894339, 0.835790, 0.777241, 0.718692, 0.660144, 0.601595, 0.543046, 0.484497, 0.425948, 0.367400, 0.308851, 0.250302, 1.791753, 1.733204, 1.674656, 1.616107, 1.557558, 1.499009, 1.440460, 1.381912, 1.323363, 1.264814, 1.206265, 1.147716, 1.089168, 1.030619, 0.972070, 0.913521, 0.854972, 0.796424, 0.737875, 0.679326, 0.620777, 0.562228, 0.503680, 0.445131, 0.386582, 0.328033, 0.269484, 0.210936, 1.752387, 1.693838, 1.635289, 1.576740, 1.518192, 1.459643, 1.401094, 1.342545, 1.283996, 1.225448, 1.166899, 1.108350, 1.049801, 0.991252, 0.932704, 0.874155, 0.815606, 0.757057, 0.698508, 0.639960, 0.581411, 0.522862, 0.464313, 0.405764, 0.347216, 0.288667, 0.230118, 1.771569, 1.713020, 1.654472, 1.595923, 1.537374, 1.478825, 1.420276, 1.361728, 1.303179, 1.244630, 1.186081, 1.127532, 1.068984, 1.010435, 0.951886, 0.893337, 0.834788, 0.776240, 0.717691, 0.659142, 0.600593, 0.542044, 0.483496, 0.424947, 0.366398, 0.307849, 0.249300, 1.790752, 1.732203, 1.673654, 1.615105, 1.556556, 1.498008, 1.439459, 1.380910, 1.322361, 1.263812, 1.205264, 1.146715, 1.088166, 1.029617, 0.971068, 0.912520, 0.853971, 0.795422, 0.736873, 0.678324, 0.619776, 0.561227, 0.502678, 0.444129, 0.385580, 0.327032, 0.268483, 0.209934, 1.751385, 1.692836, 1.634288, 1.575739, 1.517190, 1.458641, 1.400092, 1.341544, 1.282995, 1.224446, 1.165897, 1.107348, 1.048800, 0.990251, 0.931702, 0.873153, 0.814604, 0.756056, 0.697507, 0.638958, 0.580409, 0.521860, 0.463312, 0.404763, 0.346214, 0.287665, 0.229116, 1.770568, 1.712019, 1.653470, 1.594921, 1.536372, 1.477824, 1.419275, 1.360726, 1.302177, 1.243628, 1.185080, 1.126531, 1.067982, 1.009433, 0.950884, 0.892336, 0.833787, 0.775238, 0.716689, 0.658140, 0.599592, 0.541043, 0.482494, 0.423945, 0.365396, 0.306848, 0.248299, 1.789750, 1.731201, 1.672652, 1.614104, 1.555555, 1.497006, 1.438457, 1.379908, 1.321360, 1.262811, 1.204262, 1.145713, 1.087164, 1.028616, 0.970067, 0.911518, 0.852969, 0.794420, 0.735872, 0.677323, 0.618774, 0.560225, 0.501676, 0.443128, 0.384579, 0.326030, 0.267481, 0.208932, 1.750384, 1.691835, 1.633286, 1.574737, 1.516188, 1.457640, 1.399091, 1.340542, 1.281993, 1.223444, 1.164896, 1.106347, 1.047798, 0.989249, 0.930700, 0.872152, 0.813603, 0.755054, 0.696505, 0.637956, 0.579408, 0.520859, 0.462310, 0.403761, 0.345212, 0.286664, 0.228115, 1.769566, 1.711017, 1.652468, 1.593920, 1.535371, 1.476822, 1.418273, 1.359724, 1.301176, 1.242627, 1.184078, 1.125529, 1.066980, 1.008432, 0.949883, 0.891334, 0.832785, 0.774236, 0.715688, 0.657139, 0.598590, 0.540041, 0.481492, 0.422944, 0.364395, 0.305846, 0.247297, 1.788748, 1.730200, 1.671651, 1.613102, 1.554553, 1.496004, 1.437456, 1.378907, 1.320358, 1.261809, 1.203260, 1.144712, 1.086163, 1.027614, 0.969065, 0.910516, 0.851968, 0.793419, 0.734870, 0.676321, 0.617772, 0.559224, 0.500675, 0.442126, 0.383577, 0.325028, 0.266480, 0.207931, 1.749382, 1.690833, 1.632284, 1.573736, 1.515187, 1.456638, 1.398089, 1.339540, 1.280992]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.285867 1.227318 1.168769 1.110220 1.051672 0.993123 0.934574 0.876025 0.817476 0.758928 0.700379 0.641830 0.583281 0.524732 0.466184 0.407635 0.349086 0.290537 0.231988 1.773440 1.714891 1.656342 1.597793 1.539244 1.480696 1.422147 1.363598 1.305049 1.246500 1.187952 1.129403 1.070854 1.012305 0.953756 0.895208 0.836659 0.778110 0.719561 0.661012 #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251, 0.625702, 0.567153, 0.508604, 0.450056, 0.391507, 0.332958, 0.274409, 0.215860, 1.757312, 1.698763, 1.640214, 1.581665, 1.523116, 1.464568, 1.406019, 1.347470, 1.288921, 1.230372, 1.171824, 1.113275, 1.054726, 0.996177, 0.937628, 0.879080, 0.820531, 0.761982, 0.703433, 0.644884, 0.586336, 0.527787, 0.469238, 0.410689, 0.352140, 0.293592, 0.235043, 1.776494, 1.717945, 1.659396, 1.600848, 1.542299, 1.483750, 1.425201, 1.366652, 1.308104, 1.249555, 1.191006, 1.132457, 1.073908, 1.015360, 0.956811, 0.898262, 0.839713, 0.781164, 0.722616, 0.664067, 0.605518, 0.546969, 0.488420, 0.429872, 0.371323, 0.312774, 0.254225, 1.795676, 1.737128, 1.678579, 1.620030, 1.561481, 1.502932, 1.444384, 1.385835, 1.327286, 1.268737, 1.210188, 1.151640, 1.093091, 1.034542, 0.975993, 0.917444, 0.858896, 0.800347, 0.741798, 0.683249, 0.624700, 0.566152, 0.507603, 0.449054, 0.390505, 0.331956, 0.273408, 0.214859, 1.756310, 1.697761, 1.639212, 1.580664, 1.522115, 1.463566, 1.405017, 1.346468, 1.287920, 1.229371, 1.170822, 1.112273, 1.053724, 0.995176, 0.936627, 0.878078, 0.819529, 0.760980, 0.702432, 0.643883, 0.585334, 0.526785] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251, 0.625702, 0.567153, 0.508604, 0.450056, 0.391507, 0.332958, 0.274409, 0.215860, 1.757312, 1.698763, 1.640214, 1.581665, 1.523116, 1.464568, 1.406019, 1.347470] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251, 0.625702, 0.567153, 0.508604, 0.450056, 0.391507, 0.332958, 0.274409, 0.215860, 1.757312, 1.698763, 1.640214, 1.581665, 1.523116, 1.464568, 1.406019, 1.347470, 1.288921, 1.230372, 1.171824, 1.113275, 1.054726, 0.996177, 0.937628, 0.879080, 0.820531, 0.761982, 0.703433, 0.644884, 0.586336, 0.527787, 0.469238, 0.410689, 0.352140, 0.293592, 0.235043, 1.776494, 1.717945, 1.659396, 1.600848, 1.542299, 1.483750, 1.425201, 1.366652, 1.308104, 1.249555, 1.191006, 1.132457, 1.073908, 1.015360, 0.956811, 0.898262, 0.839713, 0.781164, 0.722616, 0.664067, 0.605518, 0.546969, 0.488420, 0.429872, 0.371323, 0.312774, 0.254225, 1.795676, 1.737128, 1.678579, 1.620030, 1.561481, 1.502932, 1.444384, 1.385835, 1.327286, 1.268737, 1.210188, 1.151640, 1.093091, 1.034542, 0.975993, 0.917444, 0.858896, 0.800347, 0.741798, 0.683249, 0.624700, 0.566152, 0.507603, 0.449054, 0.390505, 0.331956, 0.273408, 0.214859, 1.756310, 1.697761, 1.639212, 1.580664, 1.522115, 1.463566, 1.405017, 1.346468, 1.287920, 1.229371, 1.170822, 1.112273, 1.053724, 0.995176, 0.936627, 0.878078, 0.819529, 0.760980, 0.702432, 0.643883, 0.585334, 0.526785, 0.468236, 0.409688, 0.351139, 0.292590, 0.234041, 1.775492, 1.716944, 1.658395, 1.599846, 1.541297, 1.482748, 1.424200, 1.365651, 1.307102, 1.248553, 1.190004, 1.131456, 1.072907, 1.014358, 0.955809, 0.897260, 0.838712, 0.780163, 0.721614, 0.663065, 0.604516, 0.545968, 0.487419, 0.428870, 0.370321, 0.311772, 0.253224, 1.794675, 1.736126, 1.677577, 1.619028, 1.560480, 1.501931, 1.443382, 1.384833, 1.326284, 1.267736, 1.209187, 1.150638, 1.092089, 1.033540, 0.974992, 0.916443, 0.857894, 0.799345, 0.740796, 0.682248, 0.623699, 0.565150, 0.506601, 0.448052, 0.389504, 0.330955, 0.272406, 0.213857, 1.755308, 1.696760, 1.638211, 1.579662, 1.521113, 1.462564, 1.404016, 1.345467, 1.286918, 1.228369, 1.169820, 1.111272, 1.052723, 0.994174, 0.935625, 0.877076, 0.818528, 0.759979, 0.701430, 0.642881, 0.584332, 0.525784, 0.467235, 0.408686, 0.350137, 0.291588, 0.233040, 1.774491, 1.715942, 1.657393, 1.598844, 1.540296, 1.481747, 1.423198, 1.364649, 1.306100, 1.247552, 1.189003, 1.130454, 1.071905, 1.013356, 0.954808, 0.896259, 0.837710, 0.779161, 0.720612, 0.662064, 0.603515, 0.544966, 0.486417, 0.427868, 0.369320, 0.310771, 0.252222, 1.793673, 1.735124, 1.676576, 1.618027, 1.559478, 1.500929, 1.442380, 1.383832, 1.325283, 1.266734, 1.208185, 1.149636, 1.091088, 1.032539, 0.973990, 0.915441, 0.856892, 0.798344, 0.739795, 0.681246, 0.622697, 0.564148, 0.505600, 0.447051, 0.388502, 0.329953, 0.271404, 0.212856, 1.754307, 1.695758, 1.637209, 1.578660, 1.520112, 1.461563, 1.403014, 1.344465, 1.285916, 1.227368, 1.168819, 1.110270, 1.051721, 0.993172, 0.934624, 0.876075, 0.817526, 0.758977, 0.700428, 0.641880, 0.583331, 0.524782, 0.466233, 0.407684, 0.349136, 0.290587, 0.232038, 1.773489, 1.714940, 1.656392, 1.597843, 1.539294, 1.480745, 1.422196, 1.363648, 1.305099, 1.246550, 1.188001, 1.129452, 1.070904, 1.012355, 0.953806, 0.895257, 0.836708, 0.778160, 0.719611, 0.661062, 0.602513, 0.543964, 0.485416, 0.426867, 0.368318, 0.309769, 0.251220, 1.792672, 1.734123, 1.675574, 1.617025, 1.558476, 1.499928, 1.441379, 1.382830, 1.324281, 1.265732, 1.207184, 1.148635, 1.090086, 1.031537, 0.972988, 0.914440, 0.855891, 0.797342, 0.738793, 0.680244, 0.621696, 0.563147, 0.504598, 0.446049, 0.387500, 0.328952, 0.270403, 0.211854, 1.753305, 1.694756, 1.636208, 1.577659, 1.519110, 1.460561, 1.402012, 1.343464, 1.284915, 1.226366, 1.167817, 1.109268, 1.050720, 0.992171, 0.933622, 0.875073, 0.816524, 0.757976, 0.699427, 0.640878, 0.582329, 0.523780, 0.465232, 0.406683, 0.348134, 0.289585, 0.231036, 1.772488, 1.713939, 1.655390, 1.596841, 1.538292, 1.479744, 1.421195, 1.362646, 1.304097, 1.245548, 1.187000, 1.128451, 1.069902, 1.011353, 0.952804, 0.894256, 0.835707, 0.777158, 0.718609, 0.660060, 0.601512, 0.542963, 0.484414, 0.425865, 0.367316, 0.308768, 0.250219, 1.791670, 1.733121, 1.674572, 1.616024, 1.557475, 1.498926, 1.440377, 1.381828, 1.323280, 1.264731, 1.206182, 1.147633, 1.089084, 1.030536, 0.971987, 0.913438, 0.854889, 0.796340, 0.737792, 0.679243, 0.620694, 0.562145, 0.503596, 0.445048, 0.386499, 0.327950, 0.269401, 0.210852, 1.752304, 1.693755, 1.635206, 1.576657, 1.518108, 1.459560, 1.401011, 1.342462, 1.283913, 1.225364, 1.166816, 1.108267, 1.049718, 0.991169, 0.932620, 0.874072, 0.815523, 0.756974, 0.698425, 0.639876, 0.581328, 0.522779, 0.464230, 0.405681, 0.347132, 0.288584, 0.230035, 1.771486, 1.712937, 1.654388, 1.595840, 1.537291, 1.478742, 1.420193, 1.361644, 1.303096, 1.244547, 1.185998, 1.127449, 1.068900, 1.010352, 0.951803, 0.893254, 0.834705, 0.776156, 0.717608, 0.659059, 0.600510, 0.541961, 0.483412, 0.424864, 0.366315, 0.307766, 0.249217, 1.790668, 1.732120, 1.673571, 1.615022, 1.556473, 1.497924, 1.439376, 1.380827, 1.322278, 1.263729, 1.205180, 1.146632, 1.088083, 1.029534, 0.970985, 0.912436, 0.853888, 0.795339, 0.736790, 0.678241, 0.619692, 0.561144, 0.502595, 0.444046, 0.385497, 0.326948, 0.268400, 0.209851, 1.751302, 1.692753, 1.634204, 1.575656, 1.517107, 1.458558, 1.400009, 1.341460, 1.282912, 1.224363, 1.165814, 1.107265, 1.048716, 0.990168, 0.931619, 0.873070, 0.814521, 0.755972, 0.697424, 0.638875, 0.580326, 0.521777, 0.463228, 0.404680, 0.346131, 0.287582, 0.229033, 1.770484, 1.711936, 1.653387, 1.594838, 1.536289, 1.477740, 1.419192, 1.360643, 1.302094, 1.243545, 1.184996, 1.126448, 1.067899, 1.009350, 0.950801, 0.892252, 0.833704, 0.775155, 0.716606, 0.658057, 0.599508, 0.540960, 0.482411, 0.423862, 0.365313, 0.306764, 0.248216, 1.789667, 1.731118, 1.672569, 1.614020, 1.555472, 1.496923, 1.438374, 1.379825, 1.321276, 1.262728, 1.204179, 1.145630, 1.087081, 1.028532, 0.969984, 0.911435, 0.852886, 0.794337, 0.735788, 0.677240, 0.618691, 0.560142, 0.501593, 0.443044, 0.384496, 0.325947, 0.267398, 0.208849, 1.750300, 1.691752, 1.633203, 1.574654, 1.516105, 1.457556, 1.399008, 1.340459, 1.281910, 1.223361, 1.164812, 1.106264, 1.047715, 0.989166, 0.930617, 0.872068, 0.813520, 0.754971, 0.696422, 0.637873, 0.579324, 0.520776, 0.462227, 0.403678, 0.345129, 0.286580, 0.228032, 1.769483, 1.710934, 1.652385, 1.593836, 1.535288, 1.476739, 1.418190, 1.359641, 1.301092, 1.242544, 1.183995, 1.125446, 1.066897, 1.008348, 0.949800]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.954675 0.896126 0.837577 0.779028 0.720480 0.661931 0.603382 0.544833 0.486284 0.427736 0.369187 0.310638 0.252089 1.793540 1.734992 1.676443 1.617894 1.559345 1.500796 1.442248 1.383699 1.325150 1.266601 1.208052 1.149504 1.090955 1.032406 0.973857 0.915308 0.856760 0.798211 0.739662 0.681113 0.622564 0.564016 0.505467 0.446918 0.388369 0.329820 #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059, 0.294510, 0.235961, 1.777412, 1.718864, 1.660315, 1.601766, 1.543217, 1.484668, 1.426120, 1.367571, 1.309022, 1.250473, 1.191924, 1.133376, 1.074827, 1.016278, 0.957729, 0.899180, 0.840632, 0.782083, 0.723534, 0.664985, 0.606436, 0.547888, 0.489339, 0.430790, 0.372241, 0.313692, 0.255144, 1.796595, 1.738046, 1.679497, 1.620948, 1.562400, 1.503851, 1.445302, 1.386753, 1.328204, 1.269656, 1.211107, 1.152558, 1.094009, 1.035460, 0.976912, 0.918363, 0.859814, 0.801265, 0.742716, 0.684168, 0.625619, 0.567070, 0.508521, 0.449972, 0.391424, 0.332875, 0.274326, 0.215777, 1.757228, 1.698680, 1.640131, 1.581582, 1.523033, 1.464484, 1.405936, 1.347387, 1.288838, 1.230289, 1.171740, 1.113192, 1.054643, 0.996094, 0.937545, 0.878996, 0.820448, 0.761899, 0.703350, 0.644801, 0.586252, 0.527704, 0.469155, 0.410606, 0.352057, 0.293508, 0.234960, 1.776411, 1.717862, 1.659313, 1.600764, 1.542216, 1.483667, 1.425118, 1.366569, 1.308020, 1.249472, 1.190923, 1.132374, 1.073825, 1.015276, 0.956728, 0.898179, 0.839630, 0.781081, 0.722532, 0.663984, 0.605435, 0.546886, 0.488337, 0.429788, 0.371240, 0.312691, 0.254142, 1.795593] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059, 0.294510, 0.235961, 1.777412, 1.718864, 1.660315, 1.601766, 1.543217, 1.484668, 1.426120, 1.367571, 1.309022, 1.250473, 1.191924, 1.133376, 1.074827, 1.016278] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059, 0.294510, 0.235961, 1.777412, 1.718864, 1.660315, 1.601766, 1.543217, 1.484668, 1.426120, 1.367571, 1.309022, 1.250473, 1.191924, 1.133376, 1.074827, 1.016278, 0.957729, 0.899180, 0.840632, 0.782083, 0.723534, 0.664985, 0.606436, 0.547888, 0.489339, 0.430790, 0.372241, 0.313692, 0.255144, 1.796595, 1.738046, 1.679497, 1.620948, 1.562400, 1.503851, 1.445302, 1.386753, 1.328204, 1.269656, 1.211107, 1.152558, 1.094009, 1.035460, 0.976912, 0.918363, 0.859814, 0.801265, 0.742716, 0.684168, 0.625619, 0.567070, 0.508521, 0.449972, 0.391424, 0.332875, 0.274326, 0.215777, 1.757228, 1.698680, 1.640131, 1.581582, 1.523033, 1.464484, 1.405936, 1.347387, 1.288838, 1.230289, 1.171740, 1.113192, 1.054643, 0.996094, 0.937545, 0.878996, 0.820448, 0.761899, 0.703350, 0.644801, 0.586252, 0.527704, 0.469155, 0.410606, 0.352057, 0.293508, 0.234960, 1.776411, 1.717862, 1.659313, 1.600764, 1.542216, 1.483667, 1.425118, 1.366569, 1.308020, 1.249472, 1.190923, 1.132374, 1.073825, 1.015276, 0.956728, 0.898179, 0.839630, 0.781081, 0.722532, 0.663984, 0.605435, 0.546886, 0.488337, 0.429788, 0.371240, 0.312691, 0.254142, 1.795593, 1.737044, 1.678496, 1.619947, 1.561398, 1.502849, 1.444300, 1.385752, 1.327203, 1.268654, 1.210105, 1.151556, 1.093008, 1.034459, 0.975910, 0.917361, 0.858812, 0.800264, 0.741715, 0.683166, 0.624617, 0.566068, 0.507520, 0.448971, 0.390422, 0.331873, 0.273324, 0.214776, 1.756227, 1.697678, 1.639129, 1.580580, 1.522032, 1.463483, 1.404934, 1.346385, 1.287836, 1.229288, 1.170739, 1.112190, 1.053641, 0.995092, 0.936544, 0.877995, 0.819446, 0.760897, 0.702348, 0.643800, 0.585251, 0.526702, 0.468153, 0.409604, 0.351056, 0.292507, 0.233958, 1.775409, 1.716860, 1.658312, 1.599763, 1.541214, 1.482665, 1.424116, 1.365568, 1.307019, 1.248470, 1.189921, 1.131372, 1.072824, 1.014275, 0.955726, 0.897177, 0.838628, 0.780080, 0.721531, 0.662982, 0.604433, 0.545884, 0.487336, 0.428787, 0.370238, 0.311689, 0.253140, 1.794592, 1.736043, 1.677494, 1.618945, 1.560396, 1.501848, 1.443299, 1.384750, 1.326201, 1.267652, 1.209104, 1.150555, 1.092006, 1.033457, 0.974908, 0.916360, 0.857811, 0.799262, 0.740713, 0.682164, 0.623616, 0.565067, 0.506518, 0.447969, 0.389420, 0.330872, 0.272323, 0.213774, 1.755225, 1.696676, 1.638128, 1.579579, 1.521030, 1.462481, 1.403932, 1.345384, 1.286835, 1.228286, 1.169737, 1.111188, 1.052640, 0.994091, 0.935542, 0.876993, 0.818444, 0.759896, 0.701347, 0.642798, 0.584249, 0.525700, 0.467152, 0.408603, 0.350054, 0.291505, 0.232956, 1.774408, 1.715859, 1.657310, 1.598761, 1.540212, 1.481664, 1.423115, 1.364566, 1.306017, 1.247468, 1.188920, 1.130371, 1.071822, 1.013273, 0.954724, 0.896176, 0.837627, 0.779078, 0.720529, 0.661980, 0.603432, 0.544883, 0.486334, 0.427785, 0.369236, 0.310688, 0.252139, 1.793590, 1.735041, 1.676492, 1.617944, 1.559395, 1.500846, 1.442297, 1.383748, 1.325200, 1.266651, 1.208102, 1.149553, 1.091004, 1.032456, 0.973907, 0.915358, 0.856809, 0.798260, 0.739712, 0.681163, 0.622614, 0.564065, 0.505516, 0.446968, 0.388419, 0.329870, 0.271321, 0.212772, 1.754224, 1.695675, 1.637126, 1.578577, 1.520028, 1.461480, 1.402931, 1.344382, 1.285833, 1.227284, 1.168736, 1.110187, 1.051638, 0.993089, 0.934540, 0.875992, 0.817443, 0.758894, 0.700345, 0.641796, 0.583248, 0.524699, 0.466150, 0.407601, 0.349052, 0.290504, 0.231955, 1.773406, 1.714857, 1.656308, 1.597760, 1.539211, 1.480662, 1.422113, 1.363564, 1.305016, 1.246467, 1.187918, 1.129369, 1.070820, 1.012272, 0.953723, 0.895174, 0.836625, 0.778076, 0.719528, 0.660979, 0.602430, 0.543881, 0.485332, 0.426784, 0.368235, 0.309686, 0.251137, 1.792588, 1.734040, 1.675491, 1.616942, 1.558393, 1.499844, 1.441296, 1.382747, 1.324198, 1.265649, 1.207100, 1.148552, 1.090003, 1.031454, 0.972905, 0.914356, 0.855808, 0.797259, 0.738710, 0.680161, 0.621612, 0.563064, 0.504515, 0.445966, 0.387417, 0.328868, 0.270320, 0.211771, 1.753222, 1.694673, 1.636124, 1.577576, 1.519027, 1.460478, 1.401929, 1.343380, 1.284832, 1.226283, 1.167734, 1.109185, 1.050636, 0.992088, 0.933539, 0.874990, 0.816441, 0.757892, 0.699344, 0.640795, 0.582246, 0.523697, 0.465148, 0.406600, 0.348051, 0.289502, 0.230953, 1.772404, 1.713856, 1.655307, 1.596758, 1.538209, 1.479660, 1.421112, 1.362563, 1.304014, 1.245465, 1.186916, 1.128368, 1.069819, 1.011270, 0.952721, 0.894172, 0.835624, 0.777075, 0.718526, 0.659977, 0.601428, 0.542880, 0.484331, 0.425782, 0.367233, 0.308684, 0.250136, 1.791587, 1.733038, 1.674489, 1.615940, 1.557392, 1.498843, 1.440294, 1.381745, 1.323196, 1.264648, 1.206099, 1.147550, 1.089001, 1.030452, 0.971904, 0.913355, 0.854806, 0.796257, 0.737708, 0.679160, 0.620611, 0.562062, 0.503513, 0.444964, 0.386416, 0.327867, 0.269318, 0.210769, 1.752220, 1.693672, 1.635123, 1.576574, 1.518025, 1.459476, 1.400928, 1.342379, 1.283830, 1.225281, 1.166732, 1.108184, 1.049635, 0.991086, 0.932537, 0.873988, 0.815440, 0.756891, 0.698342, 0.639793, 0.581244, 0.522696, 0.464147, 0.405598, 0.347049, 0.288500, 0.229952, 1.771403, 1.712854, 1.654305, 1.595756, 1.537208, 1.478659, 1.420110, 1.361561, 1.303012, 1.244464, 1.185915, 1.127366, 1.068817, 1.010268, 0.951720, 0.893171, 0.834622, 0.776073, 0.717524, 0.658976, 0.600427, 0.541878, 0.483329, 0.424780, 0.366232, 0.307683, 0.249134, 1.790585, 1.732036, 1.673488, 1.614939, 1.556390, 1.497841, 1.439292, 1.380744, 1.322195, 1.263646, 1.205097, 1.146548, 1.088000, 1.029451, 0.970902, 0.912353, 0.853804, 0.795256, 0.736707, 0.678158, 0.619609, 0.561060, 0.502512, 0.443963, 0.385414, 0.326865, 0.268316, 0.209768, 1.751219, 1.692670, 1.634121, 1.575572, 1.517024, 1.458475, 1.399926, 1.341377, 1.282828, 1.224280, 1.165731, 1.107182, 1.048633, 0.990084, 0.931536, 0.872987, 0.814438, 0.755889, 0.697340, 0.638792, 0.580243, 0.521694, 0.463145, 0.404596, 0.346048, 0.287499, 0.228950, 1.770401, 1.711852, 1.653304, 1.594755, 1.536206, 1.477657, 1.419108, 1.360560, 1.302011, 1.243462, 1.184913, 1.126364, 1.067816, 1.009267, 0.950718, 0.892169, 0.833620, 0.775072, 0.716523, 0.657974, 0.599425, 0.540876, 0.482328, 0.423779, 0.365230, 0.306681, 0.248132, 1.789584, 1.731035, 1.672486, 1.613937, 1.555388, 1.496840, 1.438291, 1.379742, 1.321193, 1.262644, 1.204096, 1.145547, 1.086998, 1.028449, 0.969900, 0.911352, 0.852803, 0.794254, 0.735705, 0.677156, 0.618608]).map Float.toBits))

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

#eval IO.println ("headToCmd " ++ toString (headToCmd 0.313995).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 1.582803).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 1.251611).toBits)

def headToDriveAz (h : Float) (rw : Float) (R : Float) : Float :=
  ((((((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.727843 1.669294 1.610745).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.396651 1.338102 1.279553).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.065459 1.006910 0.948361).toBits)

def headToDriveEl (h : Float) (arm : Float) (rDrum : Float) : Float :=
  ((((-(((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float))) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.541691 1.483142 1.424593).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.210499 1.151950 1.093401).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 0.879307 0.820758 0.762209).toBits)

def heatParams  : Array Float :=
  #[(0.9 : Float), (0.8 : Float), (0.03 : Float), (15 : Float), (0.92 : Float), (15 : Float), (6300 : Float), (593 : Float)]

#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))

def heatStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Array Float :=
  let v22 := (Toil - Ta)
  #[(min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * Pin), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("heatStep " ++ toString ((heatStep 1.169387 1.110838 1.052289 0.993740 0.935192 0.876643 0.818094 0.759545 0.700996 0.642448 0.583899 0.525350 0.466801).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.838195 0.779646 0.721097 0.662548 0.604000 0.545451 0.486902 0.428353 0.369804 0.311256 0.252707 1.794158 1.735609).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.507003 0.448454 0.389905 0.331356 0.272808 0.214259 1.755710 1.697161 1.638612 1.580064 1.521515 1.462966 1.404417).map Float.toBits))

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.983235 0.924686).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.652043 0.593494).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.320851 0.262302).toBits)

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

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.610931 0.552382).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.279739 0.221190).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.548547 1.489998).map Float.toBits))

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

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.424779 0.366230 0.307681 0.249132 1.790584 1.732035 1.673486 1.614937))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.693587 1.635038 1.576489 1.517940 1.459392 1.400843 1.342294 1.283745))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.362395 1.303846 1.245297 1.186748 1.128200 1.069651 1.011102 0.952553))

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

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.238627 1.780078 1.721529 1.662980 1.604432 1.545883 1.487334 1.428785 1.370236))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.507435 1.448886 1.390337 1.331788 1.273240 1.214691 1.156142 1.097593 1.039044))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.176243 1.117694 1.059145 1.000596 0.942048 0.883499 0.824950 0.766401 0.707852))

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

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.652475 1.593926 1.535377))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.321283 1.262734 1.204185))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.990091 0.931542 0.872993))

def hpHashemi  : Float :=
  (0.34 : Float)

#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 1.280171 1.221622 1.163073 1.104524 1.045976 0.987427 0.928878).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.948979 0.890430 0.831881 0.773332 0.714784 0.656235 0.597686).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.617787 0.559238 0.500689 0.442140 0.383592 0.325043 0.266494).map Float.toBits))

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

#eval IO.println ("leverAt " ++ toString (leverAt 0.907867 0.849318 0.790769 0.732220 0.673672).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.576675 0.518126 0.459577 0.401028 0.342480).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.245483 1.786934 1.728385 1.669836 1.611288).toBits)

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

#eval IO.println ("lostSunS " ++ toString (lostSunS 0.721715 0.663166 0.604617 0.546068 0.487520 0.428971).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.390523 0.331974 0.273425 0.214876 1.756328 1.697779).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 1.659331 1.600782 1.542233 1.483684 1.425136 1.366587).toBits)

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

#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.535563 0.477014 0.418465 0.359916 0.301368 0.242819))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.204371 1.745822 1.687273 1.628724 1.570176 1.511627))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.473179 1.414630 1.356081 1.297532 1.238984 1.180435))

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

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.349411 0.290862 0.232313 1.773764 1.715216 1.656667))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.618219 1.559670 1.501121 1.442572 1.384024 1.325475))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.287027 1.228478 1.169929 1.111380 1.052832 0.994283))

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

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.763259 1.704710 1.646161 1.587612 1.529064 1.470515))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.432067 1.373518 1.314969 1.256420 1.197872 1.139323))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.100875 1.042326 0.983777 0.925228 0.866680 0.808131))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.390955))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.059763))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.728571))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.018651))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.687459))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.356267))

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

#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.460195 0.401646 0.343097 0.284548 0.226000 1.767451 1.708902 1.650353 1.591804 1.533256 1.474707 1.416158 1.357609 1.299060 1.240512 1.181963 1.123414).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.729003 1.670454 1.611905 1.553356 1.494808 1.436259 1.377710 1.319161 1.260612 1.202064 1.143515 1.084966 1.026417 0.967868 0.909320 0.850771 0.792222).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.397811 1.339262 1.280713 1.222164 1.163616 1.105067 1.046518 0.987969 0.929420 0.870872 0.812323 0.753774 0.695225 0.636676 0.578128 0.519579 0.461030).map Float.toBits))

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

#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.687891 1.629342 1.570793 1.512244 1.453696 1.395147 1.336598 1.278049 1.219500 1.160952 1.102403 1.043854 0.985305 0.926756 0.868208 0.809659 0.751110).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.356699 1.298150 1.239601 1.181052 1.122504 1.063955 1.005406 0.946857 0.888308 0.829760 0.771211 0.712662 0.654113 0.595564 0.537016 0.478467 0.419918).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.025507 0.966958 0.908409 0.849860 0.791312 0.732763 0.674214 0.615665 0.557116 0.498568 0.440019 0.381470 0.322921 0.264372 0.205824 1.747275 1.688726).map Float.toBits))

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

#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.501739 1.443190 1.384641 1.326092 1.267544 1.208995 1.150446 1.091897 1.033348 0.974800 0.916251 0.857702 0.799153 0.740604 0.682056 0.623507 0.564958).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.170547 1.111998 1.053449 0.994900 0.936352 0.877803 0.819254 0.760705 0.702156 0.643608 0.585059 0.526510 0.467961 0.409412 0.350864 0.292315 0.233766).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.839355 0.780806 0.722257 0.663708 0.605160 0.546611 0.488062 0.429513 0.370964 0.312416 0.253867 1.795318 1.736769 1.678220 1.619672 1.561123 1.502574).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.315587 1.257038 1.198489).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.984395 0.925846 0.867297).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.653203 0.594654 0.536105).toBits)

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

#eval IO.println ("megaStep " ++ toString ((megaStep 1.129435 1.070886 1.012337 0.953788 0.895240 0.836691 0.778142 0.719593 0.661044 0.602496 0.543947 0.485398 0.426849 0.368300 0.309752 0.251203 1.792654).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.798243 0.739694 0.681145 0.622596 0.564048 0.505499 0.446950 0.388401 0.329852 0.271304 0.212755 1.754206 1.695657 1.637108 1.578560 1.520011 1.461462).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.467051 0.408502 0.349953 0.291404 0.232856 1.774307 1.715758 1.657209 1.598660 1.540112 1.481563 1.423014 1.364465 1.305916 1.247368 1.188819 1.130270).map Float.toBits))

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

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.943283 0.884734 0.826185 0.767636 0.709088 0.650539 0.591990 0.533441 0.474892 0.416344 0.357795 0.299246 0.240697 1.782148 1.723600 1.665051 1.606502).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.612091 0.553542 0.494993 0.436444 0.377896 0.319347 0.260798 0.202249 1.743700 1.685152 1.626603 1.568054 1.509505 1.450956 1.392408 1.333859 1.275310).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.280899 0.222350 1.763801 1.705252 1.646704 1.588155 1.529606 1.471057 1.412508 1.353960 1.295411 1.236862 1.178313 1.119764 1.061216 1.002667 0.944118).map Float.toBits))

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

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.757131 0.698582 0.640033 0.581484 0.522936 0.464387 0.405838 0.347289 0.288740 0.230192 1.771643 1.713094 1.654545 1.595996 1.537448 1.478899 1.420350).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.425939 0.367390 0.308841 0.250292 1.791744 1.733195 1.674646 1.616097 1.557548 1.499000 1.440451 1.381902 1.323353 1.264804 1.206256 1.147707 1.089158).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.694747 1.636198 1.577649 1.519100 1.460552 1.402003 1.343454 1.284905 1.226356 1.167808 1.109259 1.050710 0.992161 0.933612 0.875064 0.816515 0.757966).map Float.toBits))

def mlpPolicy (b2_0 : Float) (b2_1 : Float) (o_0 : Float) (o_1 : Float) (o_2 : Float) (o_3 : Float) (o_4 : Float) (o_5 : Float) (o_6 : Float) (o_7 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) : Array Float :=
  let v204 := (Float.tanh (((W1[0 * 8 + 0]! * o_0) + ((W1[0 * 8 + 1]! * o_1) + ((W1[0 * 8 + 2]! * o_2) + ((W1[0 * 8 + 3]! * o_3) + ((W1[0 * 8 + 4]! * o_4) + ((W1[0 * 8 + 5]! * o_5) + ((W1[0 * 8 + 6]! * o_6) + ((W1[0 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[0]!))
  let v222 := (Float.tanh (((W1[1 * 8 + 0]! * o_0) + ((W1[1 * 8 + 1]! * o_1) + ((W1[1 * 8 + 2]! * o_2) + ((W1[1 * 8 + 3]! * o_3) + ((W1[1 * 8 + 4]! * o_4) + ((W1[1 * 8 + 5]! * o_5) + ((W1[1 * 8 + 6]! * o_6) + ((W1[1 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[1]!))
  let v240 := (Float.tanh (((W1[2 * 8 + 0]! * o_0) + ((W1[2 * 8 + 1]! * o_1) + ((W1[2 * 8 + 2]! * o_2) + ((W1[2 * 8 + 3]! * o_3) + ((W1[2 * 8 + 4]! * o_4) + ((W1[2 * 8 + 5]! * o_5) + ((W1[2 * 8 + 6]! * o_6) + ((W1[2 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[2]!))
  let v258 := (Float.tanh (((W1[3 * 8 + 0]! * o_0) + ((W1[3 * 8 + 1]! * o_1) + ((W1[3 * 8 + 2]! * o_2) + ((W1[3 * 8 + 3]! * o_3) + ((W1[3 * 8 + 4]! * o_4) + ((W1[3 * 8 + 5]! * o_5) + ((W1[3 * 8 + 6]! * o_6) + ((W1[3 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[3]!))
  let v276 := (Float.tanh (((W1[4 * 8 + 0]! * o_0) + ((W1[4 * 8 + 1]! * o_1) + ((W1[4 * 8 + 2]! * o_2) + ((W1[4 * 8 + 3]! * o_3) + ((W1[4 * 8 + 4]! * o_4) + ((W1[4 * 8 + 5]! * o_5) + ((W1[4 * 8 + 6]! * o_6) + ((W1[4 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[4]!))
  let v294 := (Float.tanh (((W1[5 * 8 + 0]! * o_0) + ((W1[5 * 8 + 1]! * o_1) + ((W1[5 * 8 + 2]! * o_2) + ((W1[5 * 8 + 3]! * o_3) + ((W1[5 * 8 + 4]! * o_4) + ((W1[5 * 8 + 5]! * o_5) + ((W1[5 * 8 + 6]! * o_6) + ((W1[5 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[5]!))
  let v312 := (Float.tanh (((W1[6 * 8 + 0]! * o_0) + ((W1[6 * 8 + 1]! * o_1) + ((W1[6 * 8 + 2]! * o_2) + ((W1[6 * 8 + 3]! * o_3) + ((W1[6 * 8 + 4]! * o_4) + ((W1[6 * 8 + 5]! * o_5) + ((W1[6 * 8 + 6]! * o_6) + ((W1[6 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[6]!))
  let v330 := (Float.tanh (((W1[7 * 8 + 0]! * o_0) + ((W1[7 * 8 + 1]! * o_1) + ((W1[7 * 8 + 2]! * o_2) + ((W1[7 * 8 + 3]! * o_3) + ((W1[7 * 8 + 4]! * o_4) + ((W1[7 * 8 + 5]! * o_5) + ((W1[7 * 8 + 6]! * o_6) + ((W1[7 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[7]!))
  let v348 := (Float.tanh (((W1[8 * 8 + 0]! * o_0) + ((W1[8 * 8 + 1]! * o_1) + ((W1[8 * 8 + 2]! * o_2) + ((W1[8 * 8 + 3]! * o_3) + ((W1[8 * 8 + 4]! * o_4) + ((W1[8 * 8 + 5]! * o_5) + ((W1[8 * 8 + 6]! * o_6) + ((W1[8 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[8]!))
  let v366 := (Float.tanh (((W1[9 * 8 + 0]! * o_0) + ((W1[9 * 8 + 1]! * o_1) + ((W1[9 * 8 + 2]! * o_2) + ((W1[9 * 8 + 3]! * o_3) + ((W1[9 * 8 + 4]! * o_4) + ((W1[9 * 8 + 5]! * o_5) + ((W1[9 * 8 + 6]! * o_6) + ((W1[9 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[9]!))
  let v384 := (Float.tanh (((W1[10 * 8 + 0]! * o_0) + ((W1[10 * 8 + 1]! * o_1) + ((W1[10 * 8 + 2]! * o_2) + ((W1[10 * 8 + 3]! * o_3) + ((W1[10 * 8 + 4]! * o_4) + ((W1[10 * 8 + 5]! * o_5) + ((W1[10 * 8 + 6]! * o_6) + ((W1[10 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[10]!))
  let v402 := (Float.tanh (((W1[11 * 8 + 0]! * o_0) + ((W1[11 * 8 + 1]! * o_1) + ((W1[11 * 8 + 2]! * o_2) + ((W1[11 * 8 + 3]! * o_3) + ((W1[11 * 8 + 4]! * o_4) + ((W1[11 * 8 + 5]! * o_5) + ((W1[11 * 8 + 6]! * o_6) + ((W1[11 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[11]!))
  let v420 := (Float.tanh (((W1[12 * 8 + 0]! * o_0) + ((W1[12 * 8 + 1]! * o_1) + ((W1[12 * 8 + 2]! * o_2) + ((W1[12 * 8 + 3]! * o_3) + ((W1[12 * 8 + 4]! * o_4) + ((W1[12 * 8 + 5]! * o_5) + ((W1[12 * 8 + 6]! * o_6) + ((W1[12 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[12]!))
  let v438 := (Float.tanh (((W1[13 * 8 + 0]! * o_0) + ((W1[13 * 8 + 1]! * o_1) + ((W1[13 * 8 + 2]! * o_2) + ((W1[13 * 8 + 3]! * o_3) + ((W1[13 * 8 + 4]! * o_4) + ((W1[13 * 8 + 5]! * o_5) + ((W1[13 * 8 + 6]! * o_6) + ((W1[13 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[13]!))
  let v456 := (Float.tanh (((W1[14 * 8 + 0]! * o_0) + ((W1[14 * 8 + 1]! * o_1) + ((W1[14 * 8 + 2]! * o_2) + ((W1[14 * 8 + 3]! * o_3) + ((W1[14 * 8 + 4]! * o_4) + ((W1[14 * 8 + 5]! * o_5) + ((W1[14 * 8 + 6]! * o_6) + ((W1[14 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[14]!))
  let v474 := (Float.tanh (((W1[15 * 8 + 0]! * o_0) + ((W1[15 * 8 + 1]! * o_1) + ((W1[15 * 8 + 2]! * o_2) + ((W1[15 * 8 + 3]! * o_3) + ((W1[15 * 8 + 4]! * o_4) + ((W1[15 * 8 + 5]! * o_5) + ((W1[15 * 8 + 6]! * o_6) + ((W1[15 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[15]!))
  #[(Float.tanh (((W2[0 * 16 + 0]! * v204) + ((W2[0 * 16 + 1]! * v222) + ((W2[0 * 16 + 2]! * v240) + ((W2[0 * 16 + 3]! * v258) + ((W2[0 * 16 + 4]! * v276) + ((W2[0 * 16 + 5]! * v294) + ((W2[0 * 16 + 6]! * v312) + ((W2[0 * 16 + 7]! * v330) + ((W2[0 * 16 + 8]! * v348) + ((W2[0 * 16 + 9]! * v366) + ((W2[0 * 16 + 10]! * v384) + ((W2[0 * 16 + 11]! * v402) + ((W2[0 * 16 + 12]! * v420) + ((W2[0 * 16 + 13]! * v438) + ((W2[0 * 16 + 14]! * v456) + ((W2[0 * 16 + 15]! * v474) + (0 : Float))))))))))))))))) + b2_0)), (Float.tanh (((W2[1 * 16 + 0]! * v204) + ((W2[1 * 16 + 1]! * v222) + ((W2[1 * 16 + 2]! * v240) + ((W2[1 * 16 + 3]! * v258) + ((W2[1 * 16 + 4]! * v276) + ((W2[1 * 16 + 5]! * v294) + ((W2[1 * 16 + 6]! * v312) + ((W2[1 * 16 + 7]! * v330) + ((W2[1 * 16 + 8]! * v348) + ((W2[1 * 16 + 9]! * v366) + ((W2[1 * 16 + 10]! * v384) + ((W2[1 * 16 + 11]! * v402) + ((W2[1 * 16 + 12]! * v420) + ((W2[1 * 16 + 13]! * v438) + ((W2[1 * 16 + 14]! * v456) + ((W2[1 * 16 + 15]! * v474) + (0 : Float))))))))))))))))) + b2_1))]

#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.570979 0.512430 0.453881 0.395332 0.336784 0.278235 0.219686 1.761137 1.702588 1.644040 #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363, 1.510814, 1.452265, 1.393716, 1.335168, 1.276619, 1.218070, 1.159521, 1.100972, 1.042424, 0.983875, 0.925326, 0.866777, 0.808228, 0.749680, 0.691131, 0.632582, 0.574033, 0.515484, 0.456936, 0.398387, 0.339838, 0.281289, 0.222740, 1.764192, 1.705643, 1.647094, 1.588545, 1.529996, 1.471448, 1.412899, 1.354350, 1.295801, 1.237252, 1.178704, 1.120155, 1.061606, 1.003057, 0.944508, 0.885960, 0.827411, 0.768862, 0.710313, 0.651764, 0.593216, 0.534667, 0.476118, 0.417569, 0.359020, 0.300472, 0.241923, 1.783374, 1.724825, 1.666276, 1.607728, 1.549179, 1.490630, 1.432081, 1.373532, 1.314984, 1.256435, 1.197886, 1.139337, 1.080788, 1.022240, 0.963691, 0.905142, 0.846593, 0.788044, 0.729496, 0.670947, 0.612398, 0.553849, 0.495300, 0.436752, 0.378203, 0.319654, 0.261105, 0.202556, 1.744008, 1.685459, 1.626910, 1.568361, 1.509812, 1.451264, 1.392715, 1.334166, 1.275617, 1.217068, 1.158520, 1.099971, 1.041422, 0.982873, 0.924324, 0.865776, 0.807227, 0.748678, 0.690129, 0.631580, 0.573032, 0.514483, 0.455934, 0.397385, 0.338836, 0.280288, 0.221739, 1.763190, 1.704641, 1.646092, 1.587544, 1.528995, 1.470446, 1.411897] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363, 1.510814, 1.452265, 1.393716, 1.335168, 1.276619, 1.218070, 1.159521, 1.100972, 1.042424, 0.983875, 0.925326, 0.866777, 0.808228, 0.749680, 0.691131, 0.632582]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.239787 1.781238 1.722689 1.664140 1.605592 1.547043 1.488494 1.429945 1.371396 1.312848 #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171, 1.179622, 1.121073, 1.062524, 1.003976, 0.945427, 0.886878, 0.828329, 0.769780, 0.711232, 0.652683, 0.594134, 0.535585, 0.477036, 0.418488, 0.359939, 0.301390, 0.242841, 1.784292, 1.725744, 1.667195, 1.608646, 1.550097, 1.491548, 1.433000, 1.374451, 1.315902, 1.257353, 1.198804, 1.140256, 1.081707, 1.023158, 0.964609, 0.906060, 0.847512, 0.788963, 0.730414, 0.671865, 0.613316, 0.554768, 0.496219, 0.437670, 0.379121, 0.320572, 0.262024, 0.203475, 1.744926, 1.686377, 1.627828, 1.569280, 1.510731, 1.452182, 1.393633, 1.335084, 1.276536, 1.217987, 1.159438, 1.100889, 1.042340, 0.983792, 0.925243, 0.866694, 0.808145, 0.749596, 0.691048, 0.632499, 0.573950, 0.515401, 0.456852, 0.398304, 0.339755, 0.281206, 0.222657, 1.764108, 1.705560, 1.647011, 1.588462, 1.529913, 1.471364, 1.412816, 1.354267, 1.295718, 1.237169, 1.178620, 1.120072, 1.061523, 1.002974, 0.944425, 0.885876, 0.827328, 0.768779, 0.710230, 0.651681, 0.593132, 0.534584, 0.476035, 0.417486, 0.358937, 0.300388, 0.241840, 1.783291, 1.724742, 1.666193, 1.607644, 1.549096, 1.490547, 1.431998, 1.373449, 1.314900, 1.256352, 1.197803, 1.139254, 1.080705] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171, 1.179622, 1.121073, 1.062524, 1.003976, 0.945427, 0.886878, 0.828329, 0.769780, 0.711232, 0.652683, 0.594134, 0.535585, 0.477036, 0.418488, 0.359939, 0.301390]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 1.508595 1.450046 1.391497 1.332948 1.274400 1.215851 1.157302 1.098753 1.040204 0.981656 #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979, 0.848430, 0.789881, 0.731332, 0.672784, 0.614235, 0.555686, 0.497137, 0.438588, 0.380040, 0.321491, 0.262942, 0.204393, 1.745844, 1.687296, 1.628747, 1.570198, 1.511649, 1.453100, 1.394552, 1.336003, 1.277454, 1.218905, 1.160356, 1.101808, 1.043259, 0.984710, 0.926161, 0.867612, 0.809064, 0.750515, 0.691966, 0.633417, 0.574868, 0.516320, 0.457771, 0.399222, 0.340673, 0.282124, 0.223576, 1.765027, 1.706478, 1.647929, 1.589380, 1.530832, 1.472283, 1.413734, 1.355185, 1.296636, 1.238088, 1.179539, 1.120990, 1.062441, 1.003892, 0.945344, 0.886795, 0.828246, 0.769697, 0.711148, 0.652600, 0.594051, 0.535502, 0.476953, 0.418404, 0.359856, 0.301307, 0.242758, 1.784209, 1.725660, 1.667112, 1.608563, 1.550014, 1.491465, 1.432916, 1.374368, 1.315819, 1.257270, 1.198721, 1.140172, 1.081624, 1.023075, 0.964526, 0.905977, 0.847428, 0.788880, 0.730331, 0.671782, 0.613233, 0.554684, 0.496136, 0.437587, 0.379038, 0.320489, 0.261940, 0.203392, 1.744843, 1.686294, 1.627745, 1.569196, 1.510648, 1.452099, 1.393550, 1.335001, 1.276452, 1.217904, 1.159355, 1.100806, 1.042257, 0.983708, 0.925160, 0.866611, 0.808062, 0.749513] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979, 0.848430, 0.789881, 0.731332, 0.672784, 0.614235, 0.555686, 0.497137, 0.438588, 0.380040, 0.321491, 0.262942, 0.204393, 1.745844, 1.687296, 1.628747, 1.570198]).map Float.toBits))

def check_mlpPolicy_bounded (b2_0 : Float) (b2_1 : Float) (o_0 : Float) (o_1 : Float) (o_2 : Float) (o_3 : Float) (o_4 : Float) (o_5 : Float) (o_6 : Float) (o_7 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) : Bool :=
  let v204 := (Float.tanh (((W1[0 * 8 + 0]! * o_0) + ((W1[0 * 8 + 1]! * o_1) + ((W1[0 * 8 + 2]! * o_2) + ((W1[0 * 8 + 3]! * o_3) + ((W1[0 * 8 + 4]! * o_4) + ((W1[0 * 8 + 5]! * o_5) + ((W1[0 * 8 + 6]! * o_6) + ((W1[0 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[0]!))
  let v222 := (Float.tanh (((W1[1 * 8 + 0]! * o_0) + ((W1[1 * 8 + 1]! * o_1) + ((W1[1 * 8 + 2]! * o_2) + ((W1[1 * 8 + 3]! * o_3) + ((W1[1 * 8 + 4]! * o_4) + ((W1[1 * 8 + 5]! * o_5) + ((W1[1 * 8 + 6]! * o_6) + ((W1[1 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[1]!))
  let v240 := (Float.tanh (((W1[2 * 8 + 0]! * o_0) + ((W1[2 * 8 + 1]! * o_1) + ((W1[2 * 8 + 2]! * o_2) + ((W1[2 * 8 + 3]! * o_3) + ((W1[2 * 8 + 4]! * o_4) + ((W1[2 * 8 + 5]! * o_5) + ((W1[2 * 8 + 6]! * o_6) + ((W1[2 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[2]!))
  let v258 := (Float.tanh (((W1[3 * 8 + 0]! * o_0) + ((W1[3 * 8 + 1]! * o_1) + ((W1[3 * 8 + 2]! * o_2) + ((W1[3 * 8 + 3]! * o_3) + ((W1[3 * 8 + 4]! * o_4) + ((W1[3 * 8 + 5]! * o_5) + ((W1[3 * 8 + 6]! * o_6) + ((W1[3 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[3]!))
  let v276 := (Float.tanh (((W1[4 * 8 + 0]! * o_0) + ((W1[4 * 8 + 1]! * o_1) + ((W1[4 * 8 + 2]! * o_2) + ((W1[4 * 8 + 3]! * o_3) + ((W1[4 * 8 + 4]! * o_4) + ((W1[4 * 8 + 5]! * o_5) + ((W1[4 * 8 + 6]! * o_6) + ((W1[4 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[4]!))
  let v294 := (Float.tanh (((W1[5 * 8 + 0]! * o_0) + ((W1[5 * 8 + 1]! * o_1) + ((W1[5 * 8 + 2]! * o_2) + ((W1[5 * 8 + 3]! * o_3) + ((W1[5 * 8 + 4]! * o_4) + ((W1[5 * 8 + 5]! * o_5) + ((W1[5 * 8 + 6]! * o_6) + ((W1[5 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[5]!))
  let v312 := (Float.tanh (((W1[6 * 8 + 0]! * o_0) + ((W1[6 * 8 + 1]! * o_1) + ((W1[6 * 8 + 2]! * o_2) + ((W1[6 * 8 + 3]! * o_3) + ((W1[6 * 8 + 4]! * o_4) + ((W1[6 * 8 + 5]! * o_5) + ((W1[6 * 8 + 6]! * o_6) + ((W1[6 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[6]!))
  let v330 := (Float.tanh (((W1[7 * 8 + 0]! * o_0) + ((W1[7 * 8 + 1]! * o_1) + ((W1[7 * 8 + 2]! * o_2) + ((W1[7 * 8 + 3]! * o_3) + ((W1[7 * 8 + 4]! * o_4) + ((W1[7 * 8 + 5]! * o_5) + ((W1[7 * 8 + 6]! * o_6) + ((W1[7 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[7]!))
  let v348 := (Float.tanh (((W1[8 * 8 + 0]! * o_0) + ((W1[8 * 8 + 1]! * o_1) + ((W1[8 * 8 + 2]! * o_2) + ((W1[8 * 8 + 3]! * o_3) + ((W1[8 * 8 + 4]! * o_4) + ((W1[8 * 8 + 5]! * o_5) + ((W1[8 * 8 + 6]! * o_6) + ((W1[8 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[8]!))
  let v366 := (Float.tanh (((W1[9 * 8 + 0]! * o_0) + ((W1[9 * 8 + 1]! * o_1) + ((W1[9 * 8 + 2]! * o_2) + ((W1[9 * 8 + 3]! * o_3) + ((W1[9 * 8 + 4]! * o_4) + ((W1[9 * 8 + 5]! * o_5) + ((W1[9 * 8 + 6]! * o_6) + ((W1[9 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[9]!))
  let v384 := (Float.tanh (((W1[10 * 8 + 0]! * o_0) + ((W1[10 * 8 + 1]! * o_1) + ((W1[10 * 8 + 2]! * o_2) + ((W1[10 * 8 + 3]! * o_3) + ((W1[10 * 8 + 4]! * o_4) + ((W1[10 * 8 + 5]! * o_5) + ((W1[10 * 8 + 6]! * o_6) + ((W1[10 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[10]!))
  let v402 := (Float.tanh (((W1[11 * 8 + 0]! * o_0) + ((W1[11 * 8 + 1]! * o_1) + ((W1[11 * 8 + 2]! * o_2) + ((W1[11 * 8 + 3]! * o_3) + ((W1[11 * 8 + 4]! * o_4) + ((W1[11 * 8 + 5]! * o_5) + ((W1[11 * 8 + 6]! * o_6) + ((W1[11 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[11]!))
  let v420 := (Float.tanh (((W1[12 * 8 + 0]! * o_0) + ((W1[12 * 8 + 1]! * o_1) + ((W1[12 * 8 + 2]! * o_2) + ((W1[12 * 8 + 3]! * o_3) + ((W1[12 * 8 + 4]! * o_4) + ((W1[12 * 8 + 5]! * o_5) + ((W1[12 * 8 + 6]! * o_6) + ((W1[12 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[12]!))
  let v438 := (Float.tanh (((W1[13 * 8 + 0]! * o_0) + ((W1[13 * 8 + 1]! * o_1) + ((W1[13 * 8 + 2]! * o_2) + ((W1[13 * 8 + 3]! * o_3) + ((W1[13 * 8 + 4]! * o_4) + ((W1[13 * 8 + 5]! * o_5) + ((W1[13 * 8 + 6]! * o_6) + ((W1[13 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[13]!))
  let v456 := (Float.tanh (((W1[14 * 8 + 0]! * o_0) + ((W1[14 * 8 + 1]! * o_1) + ((W1[14 * 8 + 2]! * o_2) + ((W1[14 * 8 + 3]! * o_3) + ((W1[14 * 8 + 4]! * o_4) + ((W1[14 * 8 + 5]! * o_5) + ((W1[14 * 8 + 6]! * o_6) + ((W1[14 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[14]!))
  let v474 := (Float.tanh (((W1[15 * 8 + 0]! * o_0) + ((W1[15 * 8 + 1]! * o_1) + ((W1[15 * 8 + 2]! * o_2) + ((W1[15 * 8 + 3]! * o_3) + ((W1[15 * 8 + 4]! * o_4) + ((W1[15 * 8 + 5]! * o_5) + ((W1[15 * 8 + 6]! * o_6) + ((W1[15 * 8 + 7]! * o_7) + (0 : Float))))))))) + b1[15]!))
  (((Float.abs (Float.tanh (((W2[0 * 16 + 0]! * v204) + ((W2[0 * 16 + 1]! * v222) + ((W2[0 * 16 + 2]! * v240) + ((W2[0 * 16 + 3]! * v258) + ((W2[0 * 16 + 4]! * v276) + ((W2[0 * 16 + 5]! * v294) + ((W2[0 * 16 + 6]! * v312) + ((W2[0 * 16 + 7]! * v330) + ((W2[0 * 16 + 8]! * v348) + ((W2[0 * 16 + 9]! * v366) + ((W2[0 * 16 + 10]! * v384) + ((W2[0 * 16 + 11]! * v402) + ((W2[0 * 16 + 12]! * v420) + ((W2[0 * 16 + 13]! * v438) + ((W2[0 * 16 + 14]! * v456) + ((W2[0 * 16 + 15]! * v474) + (0 : Float))))))))))))))))) + b2_0))) <= (1 : Float)) && ((Float.abs (Float.tanh (((W2[1 * 16 + 0]! * v204) + ((W2[1 * 16 + 1]! * v222) + ((W2[1 * 16 + 2]! * v240) + ((W2[1 * 16 + 3]! * v258) + ((W2[1 * 16 + 4]! * v276) + ((W2[1 * 16 + 5]! * v294) + ((W2[1 * 16 + 6]! * v312) + ((W2[1 * 16 + 7]! * v330) + ((W2[1 * 16 + 8]! * v348) + ((W2[1 * 16 + 9]! * v366) + ((W2[1 * 16 + 10]! * v384) + ((W2[1 * 16 + 11]! * v402) + ((W2[1 * 16 + 12]! * v420) + ((W2[1 * 16 + 13]! * v438) + ((W2[1 * 16 + 14]! * v456) + ((W2[1 * 16 + 15]! * v474) + (0 : Float))))))))))))))))) + b2_1))) <= (1 : Float)))

#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 0.384827 0.326278 0.267729 0.209180 1.750632 1.692083 1.633534 1.574985 1.516436 1.457888 #[0.661443, 0.602894, 0.544345, 0.485796, 0.427248, 0.368699, 0.310150, 0.251601, 1.793052, 1.734504, 1.675955, 1.617406, 1.558857, 1.500308, 1.441760, 1.383211, 1.324662, 1.266113, 1.207564, 1.149016, 1.090467, 1.031918, 0.973369, 0.914820, 0.856272, 0.797723, 0.739174, 0.680625, 0.622076, 0.563528, 0.504979, 0.446430, 0.387881, 0.329332, 0.270784, 0.212235, 1.753686, 1.695137, 1.636588, 1.578040, 1.519491, 1.460942, 1.402393, 1.343844, 1.285296, 1.226747, 1.168198, 1.109649, 1.051100, 0.992552, 0.934003, 0.875454, 0.816905, 0.758356, 0.699808, 0.641259, 0.582710, 0.524161, 0.465612, 0.407064, 0.348515, 0.289966, 0.231417, 1.772868, 1.714320, 1.655771, 1.597222, 1.538673, 1.480124, 1.421576, 1.363027, 1.304478, 1.245929, 1.187380, 1.128832, 1.070283, 1.011734, 0.953185, 0.894636, 0.836088, 0.777539, 0.718990, 0.660441, 0.601892, 0.543344, 0.484795, 0.426246, 0.367697, 0.309148, 0.250600, 1.792051, 1.733502, 1.674953, 1.616404, 1.557856, 1.499307, 1.440758, 1.382209, 1.323660, 1.265112, 1.206563, 1.148014, 1.089465, 1.030916, 0.972368, 0.913819, 0.855270, 0.796721, 0.738172, 0.679624, 0.621075, 0.562526, 0.503977, 0.445428, 0.386880, 0.328331, 0.269782, 0.211233, 1.752684, 1.694136, 1.635587, 1.577038, 1.518489, 1.459940, 1.401392, 1.342843, 1.284294, 1.225745] #[0.661443, 0.602894, 0.544345, 0.485796, 0.427248, 0.368699, 0.310150, 0.251601, 1.793052, 1.734504, 1.675955, 1.617406, 1.558857, 1.500308, 1.441760, 1.383211] #[0.661443, 0.602894, 0.544345, 0.485796, 0.427248, 0.368699, 0.310150, 0.251601, 1.793052, 1.734504, 1.675955, 1.617406, 1.558857, 1.500308, 1.441760, 1.383211, 1.324662, 1.266113, 1.207564, 1.149016, 1.090467, 1.031918, 0.973369, 0.914820, 0.856272, 0.797723, 0.739174, 0.680625, 0.622076, 0.563528, 0.504979, 0.446430]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.653635 1.595086 1.536537 1.477988 1.419440 1.360891 1.302342 1.243793 1.185244 1.126696 #[0.330251, 0.271702, 0.213153, 1.754604, 1.696056, 1.637507, 1.578958, 1.520409, 1.461860, 1.403312, 1.344763, 1.286214, 1.227665, 1.169116, 1.110568, 1.052019, 0.993470, 0.934921, 0.876372, 0.817824, 0.759275, 0.700726, 0.642177, 0.583628, 0.525080, 0.466531, 0.407982, 0.349433, 0.290884, 0.232336, 1.773787, 1.715238, 1.656689, 1.598140, 1.539592, 1.481043, 1.422494, 1.363945, 1.305396, 1.246848, 1.188299, 1.129750, 1.071201, 1.012652, 0.954104, 0.895555, 0.837006, 0.778457, 0.719908, 0.661360, 0.602811, 0.544262, 0.485713, 0.427164, 0.368616, 0.310067, 0.251518, 1.792969, 1.734420, 1.675872, 1.617323, 1.558774, 1.500225, 1.441676, 1.383128, 1.324579, 1.266030, 1.207481, 1.148932, 1.090384, 1.031835, 0.973286, 0.914737, 0.856188, 0.797640, 0.739091, 0.680542, 0.621993, 0.563444, 0.504896, 0.446347, 0.387798, 0.329249, 0.270700, 0.212152, 1.753603, 1.695054, 1.636505, 1.577956, 1.519408, 1.460859, 1.402310, 1.343761, 1.285212, 1.226664, 1.168115, 1.109566, 1.051017, 0.992468, 0.933920, 0.875371, 0.816822, 0.758273, 0.699724, 0.641176, 0.582627, 0.524078, 0.465529, 0.406980, 0.348432, 0.289883, 0.231334, 1.772785, 1.714236, 1.655688, 1.597139, 1.538590, 1.480041, 1.421492, 1.362944, 1.304395, 1.245846, 1.187297, 1.128748, 1.070200, 1.011651, 0.953102, 0.894553] #[0.330251, 0.271702, 0.213153, 1.754604, 1.696056, 1.637507, 1.578958, 1.520409, 1.461860, 1.403312, 1.344763, 1.286214, 1.227665, 1.169116, 1.110568, 1.052019] #[0.330251, 0.271702, 0.213153, 1.754604, 1.696056, 1.637507, 1.578958, 1.520409, 1.461860, 1.403312, 1.344763, 1.286214, 1.227665, 1.169116, 1.110568, 1.052019, 0.993470, 0.934921, 0.876372, 0.817824, 0.759275, 0.700726, 0.642177, 0.583628, 0.525080, 0.466531, 0.407982, 0.349433, 0.290884, 0.232336, 1.773787, 1.715238]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.322443 1.263894 1.205345 1.146796 1.088248 1.029699 0.971150 0.912601 0.854052 0.795504 #[1.599059, 1.540510, 1.481961, 1.423412, 1.364864, 1.306315, 1.247766, 1.189217, 1.130668, 1.072120, 1.013571, 0.955022, 0.896473, 0.837924, 0.779376, 0.720827, 0.662278, 0.603729, 0.545180, 0.486632, 0.428083, 0.369534, 0.310985, 0.252436, 1.793888, 1.735339, 1.676790, 1.618241, 1.559692, 1.501144, 1.442595, 1.384046, 1.325497, 1.266948, 1.208400, 1.149851, 1.091302, 1.032753, 0.974204, 0.915656, 0.857107, 0.798558, 0.740009, 0.681460, 0.622912, 0.564363, 0.505814, 0.447265, 0.388716, 0.330168, 0.271619, 0.213070, 1.754521, 1.695972, 1.637424, 1.578875, 1.520326, 1.461777, 1.403228, 1.344680, 1.286131, 1.227582, 1.169033, 1.110484, 1.051936, 0.993387, 0.934838, 0.876289, 0.817740, 0.759192, 0.700643, 0.642094, 0.583545, 0.524996, 0.466448, 0.407899, 0.349350, 0.290801, 0.232252, 1.773704, 1.715155, 1.656606, 1.598057, 1.539508, 1.480960, 1.422411, 1.363862, 1.305313, 1.246764, 1.188216, 1.129667, 1.071118, 1.012569, 0.954020, 0.895472, 0.836923, 0.778374, 0.719825, 0.661276, 0.602728, 0.544179, 0.485630, 0.427081, 0.368532, 0.309984, 0.251435, 1.792886, 1.734337, 1.675788, 1.617240, 1.558691, 1.500142, 1.441593, 1.383044, 1.324496, 1.265947, 1.207398, 1.148849, 1.090300, 1.031752, 0.973203, 0.914654, 0.856105, 0.797556, 0.739008, 0.680459, 0.621910, 0.563361] #[1.599059, 1.540510, 1.481961, 1.423412, 1.364864, 1.306315, 1.247766, 1.189217, 1.130668, 1.072120, 1.013571, 0.955022, 0.896473, 0.837924, 0.779376, 0.720827] #[1.599059, 1.540510, 1.481961, 1.423412, 1.364864, 1.306315, 1.247766, 1.189217, 1.130668, 1.072120, 1.013571, 0.955022, 0.896473, 0.837924, 0.779376, 0.720827, 0.662278, 0.603729, 0.545180, 0.486632, 0.428083, 0.369534, 0.310985, 0.252436, 1.793888, 1.735339, 1.676790, 1.618241, 1.559692, 1.501144, 1.442595, 1.384046]))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.798675 1.740126 1.681577 1.623028 1.564480 1.505931))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.467483 1.408934 1.350385 1.291836 1.233288 1.174739))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.136291 1.077742 1.019193 0.960644 0.902096 0.843547))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.612523 1.553974 1.495425 1.436876 1.378328 1.319779))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.281331 1.222782 1.164233 1.105684 1.047136 0.988587))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.950139 0.891590 0.833041 0.774492 0.715944 0.657395))

def obsHi  : Array Float :=
  #[(3.141592653589793 : Float), ((3.141592653589793 : Float) / (2 : Float)), ((3.141592653589793 : Float) / (2 : Float)), (1 : Float), (1 : Float), ((293 : Float) / (300 : Float)), (1 : Float), (1 : Float)]

#eval IO.println ("obsHi " ++ toString ((obsHi).map Float.toBits))
#eval IO.println ("obsHi " ++ toString ((obsHi).map Float.toBits))
#eval IO.println ("obsHi " ++ toString ((obsHi).map Float.toBits))

def obsLo  : Array Float :=
  #[(-(3.141592653589793 : Float)), ((-(3.141592653589793 : Float)) / (2 : Float)), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float)]

#eval IO.println ("obsLo " ++ toString ((obsLo).map Float.toBits))
#eval IO.println ("obsLo " ++ toString ((obsLo).map Float.toBits))
#eval IO.println ("obsLo " ++ toString ((obsLo).map Float.toBits))

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

#eval IO.println ("obsOf " ++ toString ((obsOf 1.054067 0.995518 0.936969 0.878420 0.819872 0.761323 0.702774 0.644225).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.722875 0.664326 0.605777 0.547228 0.488680 0.430131 0.371582 0.313033).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.391683 0.333134 0.274585 0.216036 1.757488 1.698939 1.640390 1.581841).map Float.toBits))

def oilStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Float :=
  let v22 := (Toil - Ta)
  (min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil)))

#eval IO.println ("oilStep " ++ toString (oilStep 0.867915 0.809366 0.750817 0.692268 0.633720 0.575171 0.516622 0.458073 0.399524 0.340976 0.282427 0.223878 1.765329).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.536723 0.478174 0.419625 0.361076 0.302528 0.243979 1.785430 1.726881 1.668332 1.609784 1.551235 1.492686 1.434137).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.205531 1.746982 1.688433 1.629884 1.571336 1.512787 1.454238 1.395689 1.337140 1.278592 1.220043 1.161494 1.102945).toBits)

def check_oilStep_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Twall : Float) (Ta : Float) (dt : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v27 := (alpha * Pin)
  let v30 := ((eps * (0.0000000567 : Float)) * Ac)
  let v32 := (Ta ^ 4)
  let v35 := (hC * Ac)
  let v36 := (T1 - Ta)
  let v53 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) < Coil) || (!((0 : Float) <= dt) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((min ToilMax (T1 + ((dt * (((v27 - ((v30 * ((T1 ^ 4) - v32)) + (v35 * v36))) - (Upipe * v36)) - (max (0 : Float) (UAx * (T1 - Twall))))) / Coil))) - (min ToilMax (T2 + ((dt * (((v27 - ((v30 * ((T2 ^ 4) - v32)) + (v35 * v53))) - (Upipe * v53)) - (max (0 : Float) (UAx * (T2 - Twall))))) / Coil))))) <= (((1 : Float) + ((dt * ((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v35) + Upipe) + UAx)) / Coil)) * (Float.abs (T1 - T2)))))))))))))))

#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.681763 0.623214 0.564665 0.506116 0.447568 0.389019 0.330470 0.271921 0.213372 1.754824 1.696275 1.637726 1.579177 1.520628 1.462080))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.350571 0.292022 0.233473 1.774924 1.716376 1.657827 1.599278 1.540729 1.482180 1.423632 1.365083 1.306534 1.247985 1.189436 1.130888))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.619379 1.560830 1.502281 1.443732 1.385184 1.326635 1.268086 1.209537 1.150988 1.092440 1.033891 0.975342 0.916793 0.858244 0.799696))

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

def pipeGreen (Upipe : Float) (mcp : Float) : Float :=
  (Float.exp ((-Upipe) / mcp))

#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.723307 1.664758).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.392115 1.333566).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.060923 1.002374).toBits)

def check_pipeGreen_le_one (Upipe : Float) (mcp : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || ((Float.exp ((-Upipe) / mcp)) <= (1 : Float))))

#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.537155 1.478606))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.205963 1.147414))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 0.874771 0.816222))

def check_pipeGreen_pos (Upipe : Float) (mcp : Float) : Bool :=
  ((0 : Float) < (Float.exp ((-Upipe) / mcp)))

#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.351003 1.292454))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.019811 0.961262))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 0.688619 0.630070))

def check_pipeGreen_semigroup (U1 : Float) (U2 : Float) (mcp : Float) : Bool :=
  (feq (Float.exp ((-(U1 + U2)) / mcp)) ((Float.exp ((-U1) / mcp)) * (Float.exp ((-U2) / mcp))))

#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 1.164851 1.106302 1.047753))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 0.833659 0.775110 0.716561))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 0.502467 0.443918 0.385369))

def check_play_budget (f : Float) (eps : Float) (h : Float) (delta : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.978699 0.920150 0.861601 0.803052))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.647507 0.588958 0.530409 0.471860))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.316315 0.257766 1.799217 1.740668))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.792547))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.461355))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.730163))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 0.606395 0.547846 0.489297 0.430748 0.372200 0.313651 0.255102 1.796553 1.738004).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.275203 0.216654 1.758105 1.699556 1.641008 1.582459 1.523910 1.465361 1.406812).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 1.544011 1.485462 1.426913 1.368364 1.309816 1.251267 1.192718 1.134169 1.075620).map Float.toBits))

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

#eval IO.println ("pointingError " ++ toString (pointingError 0.420243 0.361694 0.303145 0.244596).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 1.689051 1.630502 1.571953 1.513404).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 1.357859 1.299310 1.240761 1.182212).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 0.234091 1.775542 1.716993 1.658444 1.599896 1.541347 1.482798 1.424249 1.365700 1.307152 1.248603 1.190054 1.131505).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.502899 1.444350 1.385801 1.327252 1.268704 1.210155 1.151606 1.093057 1.034508 0.975960 0.917411 0.858862 0.800313).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.171707 1.113158 1.054609 0.996060 0.937512 0.878963 0.820414 0.761865 0.703316 0.644768 0.586219 0.527670 0.469121).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.647939 1.589390 1.530841 1.472292 1.413744 1.355195 1.296646 1.238097 1.179548 1.121000 1.062451 1.003902))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.316747 1.258198 1.199649 1.141100 1.082552 1.024003 0.965454 0.906905 0.848356 0.789808 0.731259 0.672710))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.985555 0.927006 0.868457 0.809908 0.751360 0.692811 0.634262 0.575713 0.517164 0.458616 0.400067 0.341518))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.461787 1.403238 1.344689 1.286140 1.227592 1.169043 1.110494 1.051945 0.993396 0.934848 0.876299 0.817750))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.130595 1.072046 1.013497 0.954948 0.896400 0.837851 0.779302 0.720753 0.662204 0.603656 0.545107 0.486558))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.799403 0.740854 0.682305 0.623756 0.565208 0.506659 0.448110 0.389561 0.331012 0.272464 0.213915 1.755366))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.275635 1.217086 1.158537 1.099988 1.041440 0.982891 0.924342 0.865793 0.807244 0.748696 0.690147 0.631598))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.944443 0.885894 0.827345 0.768796 0.710248 0.651699 0.593150 0.534601 0.476052 0.417504 0.358955 0.300406))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.613251 0.554702 0.496153 0.437604 0.379056 0.320507 0.261958 0.203409 1.744860 1.686312 1.627763 1.569214))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.089483 1.030934 0.972385 0.913836 0.855288 0.796739 0.738190 0.679641 0.621092 0.562544 0.503995 0.445446 0.386897))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.758291 0.699742 0.641193 0.582644 0.524096 0.465547 0.406998 0.348449 0.289900 0.231352 1.772803 1.714254 1.655705))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.427099 0.368550 0.310001 0.251452 1.792904 1.734355 1.675806 1.617257 1.558708 1.500160 1.441611 1.383062 1.324513))

def check_pow4_lipschitz (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((T1 ^ 4) - (T2 ^ 4))) <= (((4 : Float) * (M ^ 3)) * (Float.abs (T1 - T2))))))))

#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.903331 0.844782 0.786233))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.572139 0.513590 0.455041))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.240947 1.782398 1.723849))

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

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.014115 0.955566 0.897017))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.682923 0.624374 0.565825))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.351731 0.293182 0.234633))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.827963))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.496771))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.765579))

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

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.683355 1.624806))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.352163 1.293614))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.020971 0.962422))

def prop_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.497203 1.438654 1.380105))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.166011 1.107462 1.048913))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.834819 0.776270 0.717721))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.311051))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.979859))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.648667))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.124899 1.066350))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.793707 0.735158))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.462515 0.403966))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.938747 0.880198))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.607555 0.549006))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.276363 0.217814))

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

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.752595 0.694046 0.635497 0.576948 0.518400 0.459851 0.401302 0.342753 0.284204 0.225656 1.767107 1.708558))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.421403 0.362854 0.304305 0.245756 1.787208 1.728659 1.670110 1.611561 1.553012 1.494464 1.435915 1.377366))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.690211 1.631662 1.573113 1.514564 1.456016 1.397467 1.338918 1.280369 1.221820 1.163272 1.104723 1.046174))

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

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.607987 1.549438 1.490889))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.276795 1.218246 1.159697))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.945603 0.887054 0.828505))

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

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.049531 0.990982 0.932433 0.873884 0.815336 0.756787 0.698238 0.639689 0.581140 0.522592 0.464043 0.405494 0.346945))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.718339 0.659790 0.601241 0.542692 0.484144 0.425595 0.367046 0.308497 0.249948 1.791400 1.732851 1.674302 1.615753))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.387147 0.328598 0.270049 0.211500 1.752952 1.694403 1.635854 1.577305 1.518756 1.460208 1.401659 1.343110 1.284561))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.863379 0.804830 0.746281 0.687732 0.629184 0.570635 0.512086 0.453537 0.394988 0.336440 0.277891 0.219342 1.760793))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.532187 0.473638 0.415089 0.356540 0.297992 0.239443 1.780894 1.722345 1.663796 1.605248 1.546699 1.488150 1.429601))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.200995 1.742446 1.683897 1.625348 1.566800 1.508251 1.449702 1.391153 1.332604 1.274056 1.215507 1.156958 1.098409))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.677227 0.618678 0.560129 0.501580 0.443032))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.346035 0.287486 0.228937 1.770388 1.711840))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.614843 1.556294 1.497745 1.439196 1.380648))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.491075 0.432526 0.373977))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.759883 1.701334 1.642785))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.428691 1.370142 1.311593))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.304923))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.573731))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.242539))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.718771 1.660222 1.601673))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.387579 1.329030 1.270481))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.056387 0.997838 0.939289))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.532619 1.474070 1.415521))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.201427 1.142878 1.084329))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.870235 0.811686 0.753137))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.346467 1.287918 1.229369 1.170820))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.015275 0.956726 0.898177 0.839628))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.684083 0.625534 0.566985 0.508436))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.160315 1.101766 1.043217))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.829123 0.770574 0.712025))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.497931 0.439382 0.380833))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.974163 0.915614 0.857065 0.798516 0.739968))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.642971 0.584422 0.525873 0.467324 0.408776))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.311779 0.253230 1.794681 1.736132 1.677584))

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

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.788011 0.729462 0.670913 0.612364 0.553816))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.456819 0.398270 0.339721 0.281172 0.222624))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.725627 1.667078 1.608529 1.549980 1.491432))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.601859 0.543310 0.484761 0.426212 0.367664))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.270667 0.212118 1.753569 1.695020 1.636472))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.539475 1.480926 1.422377 1.363828 1.305280))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.415707 0.357158 0.298609 0.240060))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.684515 1.625966 1.567417 1.508868))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.353323 1.294774 1.236225 1.177676))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.643403 1.584854 1.526305))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.312211 1.253662 1.195113))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.981019 0.922470 0.863921))

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

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.457251 1.398702 1.340153 1.281604 1.223056 1.164507 1.105958 1.047409 0.988860 0.930312 0.871763 0.813214))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.126059 1.067510 1.008961 0.950412 0.891864 0.833315 0.774766 0.716217 0.657668 0.599120 0.540571 0.482022))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.794867 0.736318 0.677769 0.619220 0.560672 0.502123 0.443574 0.385025 0.326476 0.267928 0.209379 1.750830))

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

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.271099 1.212550 1.154001 1.095452 1.036904 0.978355 0.919806 0.861257 0.802708 0.744160 0.685611 0.627062))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.939907 0.881358 0.822809 0.764260 0.705712 0.647163 0.588614 0.530065 0.471516 0.412968 0.354419 0.295870))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.608715 0.550166 0.491617 0.433068 0.374520 0.315971 0.257422 1.798873 1.740324 1.681776 1.623227 1.564678))

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

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.084947 1.026398 0.967849 0.909300 0.850752 0.792203 0.733654 0.675105 0.616556 0.558008 0.499459 0.440910))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.753755 0.695206 0.636657 0.578108 0.519560 0.461011 0.402462 0.343913 0.285364 0.226816 1.768267 1.709718))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.422563 0.364014 0.305465 0.246916 1.788368 1.729819 1.671270 1.612721 1.554172 1.495624 1.437075 1.378526))

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

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.195731 1.137182 1.078633 1.020084 0.961536 0.902987 0.844438 0.785889))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.864539 0.805990 0.747441 0.688892 0.630344 0.571795 0.513246 0.454697))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.533347 0.474798 0.416249 0.357700 0.299152 0.240603 1.782054 1.723505))

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

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.009579 0.951030 0.892481 0.833932 0.775384 0.716835 0.658286 0.599737 0.541188))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.678387 0.619838 0.561289 0.502740 0.444192 0.385643 0.327094 0.268545 0.209996))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.347195 0.288646 0.230097 1.771548 1.713000 1.654451 1.595902 1.537353 1.478804))

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

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.823427 0.764878 0.706329))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.492235 0.433686 0.375137))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.761043 1.702494 1.643945))

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

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.264971))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.533779))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.202587))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.492667))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.161475))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.830283))

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

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.934211 0.875662 0.817113 0.758564 0.700016 0.641467))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.603019 0.544470 0.485921 0.427372 0.368824 0.310275))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.271827 0.213278 1.754729 1.696180 1.637632 1.579083))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.748059 0.689510 0.630961 0.572412 0.513864 0.455315))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.416867 0.358318 0.299769 0.241220 1.782672 1.724123))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.685675 1.627126 1.568577 1.510028 1.451480 1.392931))

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

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.789603 1.731054 1.672505 1.613956))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.458411 1.399862 1.341313 1.282764))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.127219 1.068670 1.010121 0.951572))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.603451))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.272259))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.941067))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.417299 1.358750 1.300201 1.241652 1.183104 1.124555 1.066006 1.007457 0.948908 0.890360 0.831811 0.773262))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.086107 1.027558 0.969009 0.910460 0.851912 0.793363 0.734814 0.676265 0.617716 0.559168 0.500619 0.442070))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.754915 0.696366 0.637817 0.579268 0.520720 0.462171 0.403622 0.345073 0.286524 0.227976 1.769427 1.710878))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.231147 1.172598 1.114049 1.055500 0.996952 0.938403 0.879854 0.821305 0.762756 0.704208 0.645659 0.587110))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.899955 0.841406 0.782857 0.724308 0.665760 0.607211 0.548662 0.490113 0.431564 0.373016 0.314467 0.255918))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.568763 0.510214 0.451665 0.393116 0.334568 0.276019 0.217470 1.758921 1.700372 1.641824 1.583275 1.524726))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.044995 0.986446 0.927897 0.869348 0.810800 0.752251 0.693702 0.635153 0.576604 0.518056 0.459507 0.400958))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.713803 0.655254 0.596705 0.538156 0.479608 0.421059 0.362510 0.303961 0.245412 1.786864 1.728315 1.669766))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.382611 0.324062 0.265513 0.206964 1.748416 1.689867 1.631318 1.572769 1.514220 1.455672 1.397123 1.338574))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.858843 0.800294 0.741745 0.683196 0.624648 0.566099 0.507550 0.449001 0.390452 0.331904 0.273355 0.214806 1.756257))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.527651 0.469102 0.410553 0.352004 0.293456 0.234907 1.776358 1.717809 1.659260 1.600712 1.542163 1.483614 1.425065))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.796459 1.737910 1.679361 1.620812 1.562264 1.503715 1.445166 1.386617 1.328068 1.269520 1.210971 1.152422 1.093873))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.486539 0.427990 0.369441 0.310892))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.755347 1.696798 1.638249 1.579700))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.424155 1.365606 1.307057 1.248508))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.714235 1.655686 1.597137))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.383043 1.324494 1.265945))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.051851 0.993302 0.934753))

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

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.969627 0.911078 0.852529 0.793980 0.735432 0.676883))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.638435 0.579886 0.521337 0.462788 0.404240 0.345691))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.307243 0.248694 1.790145 1.731596 1.673048 1.614499))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.783475 0.724926 0.666377 0.607828 0.549280 0.490731))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.452283 0.393734 0.335185 0.276636 0.218088 1.759539))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.721091 1.662542 1.603993 1.545444 1.486896 1.428347))

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

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.411171 0.352622 0.294073 0.235524 1.776976 1.718427 1.659878))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.679979 1.621430 1.562881 1.504332 1.445784 1.387235 1.328686))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.348787 1.290238 1.231689 1.173140 1.114592 1.056043 0.997494))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.225019 1.766470))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.493827 1.435278))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.162635 1.104086))

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

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.266563 1.208014))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.935371 0.876822))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.604179 0.545630))

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

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.080411 1.021862 0.963313 0.904764 0.846216 0.787667 0.729118 0.670569 0.612020))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.749219 0.690670 0.632121 0.573572 0.515024 0.456475 0.397926 0.339377 0.280828))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.418027 0.359478 0.300929 0.242380 1.783832 1.725283 1.666734 1.608185 1.549636))

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

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.894259 0.835710 0.777161))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.563067 0.504518 0.445969))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.231875 1.773326 1.714777))

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

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.749651 1.691102 1.632553 1.574004))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.418459 1.359910 1.301361 1.242812))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.087267 1.028718 0.970169 0.911620))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.563499 1.504950 1.446401 1.387852 1.329304))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.232307 1.173758 1.115209 1.056660 0.998112))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.901115 0.842566 0.784017 0.725468 0.666920))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.191195 1.132646 1.074097))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.860003 0.801454 0.742905))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.528811 0.470262 0.411713))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.818891 0.760342 0.701793 0.643244 0.584696 0.526147 0.467598 0.409049 0.350500 0.291952))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.487699 0.429150 0.370601 0.312052 0.253504 1.794955 1.736406 1.677857 1.619308 1.560760))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.756507 1.697958 1.639409 1.580860 1.522312 1.463763 1.405214 1.346665 1.288116 1.229568))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.632739 0.574190 0.515641))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.301547 0.242998 1.784449))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.570355 1.511806 1.453257))

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

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.446587 0.388038 0.329489 0.270940 0.212392))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.715395 1.656846 1.598297 1.539748 1.481200))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.384203 1.325654 1.267105 1.208556 1.150008))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.260435 0.201886 1.743337 1.684788 1.626240))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.529243 1.470694 1.412145 1.353596 1.295048))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.198051 1.139502 1.080953 1.022404 0.963856))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.674283))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.343091))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.011899))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.488131 1.429582 1.371033 1.312484))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.156939 1.098390 1.039841 0.981292))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.825747 0.767198 0.708649 0.650100))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.301979 1.243430 1.184881 1.126332 1.067784))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.970787 0.912238 0.853689 0.795140 0.736592))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.639595 0.581046 0.522497 0.463948 0.405400))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.115827 1.057278 0.998729 0.940180 0.881632))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.784635 0.726086 0.667537 0.608988 0.550440))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.453443 0.394894 0.336345 0.277796 0.219248))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.929675 0.871126 0.812577))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.598483 0.539934 0.481385))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.267291 0.208742 1.750193))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.743523))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.412331))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.681139))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.557371 0.498822 0.440273 0.381724))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.226179 1.767630 1.709081 1.650532))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.494987 1.436438 1.377889 1.319340))

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

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.785067 1.726518 1.667969 1.609420 1.550872))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.453875 1.395326 1.336777 1.278228 1.219680))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.122683 1.064134 1.005585 0.947036 0.888488))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.598915 1.540366 1.481817 1.423268))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.267723 1.209174 1.150625 1.092076))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.936531 0.877982 0.819433 0.760884))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.412763 1.354214 1.295665 1.237116))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.081571 1.023022 0.964473 0.905924))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.750379 0.691830 0.633281 0.574732))

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

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.854307 0.795758 0.737209 0.678660 0.620112 0.561563 0.503014 0.444465))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.523115 0.464566 0.406017 0.347468 0.288920 0.230371 1.771822 1.713273))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.791923 1.733374 1.674825 1.616276 1.557728 1.499179 1.440630 1.382081))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.482003 0.423454 0.364905 0.306356))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.750811 1.692262 1.633713 1.575164))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.419619 1.361070 1.302521 1.243972))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.295851 0.237302 1.778753))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.564659 1.506110 1.447561))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.233467 1.174918 1.116369))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.523547 1.464998).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.192355 1.133806).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.861163 0.802614).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def qAbs (alpha : Float) (Pin : Float) : Float :=
  (alpha * Pin)

#eval IO.println ("qAbs " ++ toString (qAbs 1.151243 1.092694).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 0.820051 0.761502).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 0.488859 0.430310).toBits)

def qCoilLoss (eps : Float) (Ac : Float) (hC : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.965091 0.906542 0.847993 0.789444 0.730896).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.633899 0.575350 0.516801 0.458252 0.399704).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.302707 0.244158 1.785609 1.727060 1.668512).toBits)

def qNet (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Float :=
  let v19 := (Toil - Ta)
  ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("qNet " ++ toString (qNet 0.778939 0.720390 0.661841 0.603292 0.544744 0.486195 0.427646 0.369097 0.310548 0.252000).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.447747 0.389198 0.330649 0.272100 0.213552 1.755003 1.696454 1.637905 1.579356 1.520808).toBits)
#eval IO.println ("qNet " ++ toString (qNet 1.716555 1.658006 1.599457 1.540908 1.482360 1.423811 1.365262 1.306713 1.248164 1.189616).toBits)

def check_qNet_antitone (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) <= (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.592787 0.534238 0.475689 0.417140 0.358592 0.300043 0.241494 1.782945 1.724396 1.665848 1.607299))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.261595 0.203046 1.744497 1.685948 1.627400 1.568851 1.510302 1.451753 1.393204 1.334656 1.276107))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.530403 1.471854 1.413305 1.354756 1.296208 1.237659 1.179110 1.120561 1.062012 1.003464 0.944915))

def check_qNet_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v22 := (alpha * Pin)
  let v25 := ((eps * (0.0000000567 : Float)) * Ac)
  let v27 := (Ta ^ 4)
  let v30 := (hC * Ac)
  let v31 := (T1 - Ta)
  let v44 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((((v22 - ((v25 * ((T1 ^ 4) - v27)) + (v30 * v31))) - (Upipe * v31)) - (max (0 : Float) (UAx * (T1 - Twall)))) - (((v22 - ((v25 * ((T2 ^ 4) - v27)) + (v30 * v44))) - (Upipe * v44)) - (max (0 : Float) (UAx * (T2 - Twall)))))) <= (((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v30) + Upipe) + UAx) * (Float.abs (T1 - T2)))))))))))))

#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.406635 0.348086 0.289537 0.230988 1.772440 1.713891 1.655342 1.596793 1.538244 1.479696 1.421147 1.362598))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.675443 1.616894 1.558345 1.499796 1.441248 1.382699 1.324150 1.265601 1.207052 1.148504 1.089955 1.031406))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.344251 1.285702 1.227153 1.168604 1.110056 1.051507 0.992958 0.934409 0.875860 0.817312 0.758763 0.700214))

def check_qNet_strictAnti (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 < T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) < (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.220483 1.761934 1.703385 1.644836 1.586288 1.527739 1.469190 1.410641 1.352092 1.293544 1.234995))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.489291 1.430742 1.372193 1.313644 1.255096 1.196547 1.137998 1.079449 1.020900 0.962352 0.903803))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.158099 1.099550 1.041001 0.982452 0.923904 0.865355 0.806806 0.748257 0.689708 0.631160 0.572611))

def qPipe (Upipe : Float) (Toil : Float) (Ta : Float) : Float :=
  (Upipe * (Toil - Ta))

#eval IO.println ("qPipe " ++ toString (qPipe 1.634331 1.575782 1.517233).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.303139 1.244590 1.186041).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 0.971947 0.913398 0.854849).toBits)

def qPot (UAx : Float) (Toil : Float) (Twall : Float) : Float :=
  (max (0 : Float) (UAx * (Toil - Twall)))

#eval IO.println ("qPot " ++ toString (qPot 1.448179 1.389630 1.331081).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.116987 1.058438 0.999889).toBits)
#eval IO.println ("qPot " ++ toString (qPot 0.785795 0.727246 0.668697).toBits)

def check_qPot_le (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  let v5 := (Toil - Twall)
  (!((0 : Float) <= UAx) || ((max (0 : Float) (UAx * v5)) <= (UAx * (max (0 : Float) v5))))

#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.262027 1.203478 1.144929))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.930835 0.872286 0.813737))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.599643 0.541094 0.482545))

def check_qPot_nonneg (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  ((0 : Float) <= (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.075875 1.017326 0.958777))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.744683 0.686134 0.627585))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.413491 0.354942 0.296393))

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

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.517419 0.458870 0.400321 0.341772))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.786227 1.727678 1.669129 1.610580))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.455035 1.396486 1.337937 1.279388))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 1.745115 1.686566 1.628017 1.569468 1.510920 1.452371 1.393822 1.335273 1.276724 1.218176 1.159627 1.101078).toBits)
#eval IO.println ("recip " ++ toString (recip 1.413923 1.355374 1.296825 1.238276 1.179728 1.121179 1.062630 1.004081 0.945532 0.886984 0.828435 0.769886).toBits)
#eval IO.println ("recip " ++ toString (recip 1.082731 1.024182 0.965633 0.907084 0.848536 0.789987 0.731438 0.672889 0.614340 0.555792 0.497243 0.438694).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 1.558963 1.500414 1.441865 1.383316 1.324768 1.266219).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.227771 1.169222 1.110673 1.052124 0.993576 0.935027).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 0.896579 0.838030 0.779481 0.720932 0.662384 0.603835).map Float.toBits))

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

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.186659 1.128110 1.069561))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.855467 0.796918 0.738369))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.524275 0.465726 0.407177))

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

#eval IO.println ("rollY " ++ toString ((rollY 0.628203 0.569654 0.511105).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.297011 0.238462 1.779913).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 1.565819 1.507270 1.448721).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.442051 0.383502 0.324953 0.266404 0.207856 1.749307).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.710859 1.652310 1.593761 1.535212 1.476664 1.418115).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.379667 1.321118 1.262569 1.204020 1.145472 1.086923).toBits)

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

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.483595 1.425046 1.366497 1.307948 1.249400 1.190851))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.152403 1.093854 1.035305 0.976756 0.918208 0.859659))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.821211 0.762662 0.704113 0.645564 0.587016 0.528467))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.297443 1.238894 1.180345 1.121796 1.063248 1.004699))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.966251 0.907702 0.849153 0.790604 0.732056 0.673507))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.635059 0.576510 0.517961 0.459412 0.400864 0.342315))

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

#eval IO.println ("rot " ++ toString ((rot 0.925139 0.866590 0.808041).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.593947 0.535398 0.476849).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.262755 0.204206 1.745657).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 0.738987 0.680438 0.621889 0.563340).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.407795 0.349246 0.290697 0.232148).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 1.676603 1.618054 1.559505 1.500956).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.552835 0.494286 0.435737 0.377188 0.318640 0.260091 0.201542))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.221643 1.763094 1.704545 1.645996 1.587448 1.528899 1.470350))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.490451 1.431902 1.373353 1.314804 1.256256 1.197707 1.139158))

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

#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.366683 0.308134 0.249585 1.791036 1.732488 1.673939 1.615390 1.556841 1.498292 1.439744 1.381195 1.322646).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.635491 1.576942 1.518393 1.459844 1.401296 1.342747 1.284198 1.225649 1.167100 1.108552 1.050003 0.991454).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.304299 1.245750 1.187201 1.128652 1.070104 1.011555 0.953006 0.894457 0.835908 0.777360 0.718811 0.660262).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 1.780531 1.721982).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.449339 1.390790).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.118147 1.059598).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.594379 1.535830))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.263187 1.204638))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.931995 0.873446))

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

#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.035923 0.977374).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.704731 0.646182).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.373539 0.314990).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.849771 0.791222))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.518579 0.460030))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.787387 1.728838))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.663619 0.605070 0.546521).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.332427 0.273878 0.215329).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.601235 1.542686 1.484137).map Float.toBits))

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

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.477467 0.418918 0.360369 0.301820 0.243272 1.784723 1.726174 1.667625 1.609076))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.746275 1.687726 1.629177 1.570628 1.512080 1.453531 1.394982 1.336433 1.277884))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.415083 1.356534 1.297985 1.239436 1.180888 1.122339 1.063790 1.005241 0.946692))

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

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.291315 0.232766 1.774217))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.560123 1.501574 1.443025))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.228931 1.170382 1.111833))

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 1.705163 1.646614).toBits)
#eval IO.println ("setLength " ++ toString (setLength 1.373971 1.315422).toBits)
#eval IO.println ("setLength " ++ toString (setLength 1.042779 0.984230).toBits)

def shift (x : Float) (h : Array Float) : Array Float :=
  #[x, h[0]!, h[1]!, h[2]!, h[3]!, h[4]!, h[5]!, h[6]!, h[7]!, h[8]!, h[9]!, h[10]!, h[11]!, h[12]!, h[13]!, h[14]!]

#eval IO.println ("shift " ++ toString ((shift 1.519011 #[1.795627, 1.737078, 1.678529, 1.619980, 1.561432, 1.502883, 1.444334, 1.385785, 1.327236, 1.268688, 1.210139, 1.151590, 1.093041, 1.034492, 0.975944, 0.917395]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 1.187819 #[1.464435, 1.405886, 1.347337, 1.288788, 1.230240, 1.171691, 1.113142, 1.054593, 0.996044, 0.937496, 0.878947, 0.820398, 0.761849, 0.703300, 0.644752, 0.586203]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 0.856627 #[1.133243, 1.074694, 1.016145, 0.957596, 0.899048, 0.840499, 0.781950, 0.723401, 0.664852, 0.606304, 0.547755, 0.489206, 0.430657, 0.372108, 0.313560, 0.255011]).map Float.toBits))

def check_shift_head (x : Float) (h : Array Float) : Bool :=
  (feq x x)

#eval IO.println ("check_shift_head " ++ toString (check_shift_head 1.332859 #[1.609475, 1.550926, 1.492377, 1.433828, 1.375280, 1.316731, 1.258182, 1.199633, 1.141084, 1.082536, 1.023987, 0.965438, 0.906889, 0.848340, 0.789792, 0.731243]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 1.001667 #[1.278283, 1.219734, 1.161185, 1.102636, 1.044088, 0.985539, 0.926990, 0.868441, 0.809892, 0.751344, 0.692795, 0.634246, 0.575697, 0.517148, 0.458600, 0.400051]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 0.670475 #[0.947091, 0.888542, 0.829993, 0.771444, 0.712896, 0.654347, 0.595798, 0.537249, 0.478700, 0.420152, 0.361603, 0.303054, 0.244505, 1.785956, 1.727408, 1.668859]))

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

#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.402099))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.670907))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.339715))

def check_sigmoid_slope_le (x : Float) : Bool :=
  let v1 := (1.0 / (1.0 + Float.exp (-x)))
  ((v1 * ((1 : Float) - v1)) <= ((1 : Float) / (4 : Float)))

#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.215947))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.484755))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.153563))

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

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.443643 1.385094 1.326545 1.267996))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.112451 1.053902 0.995353 0.936804))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.781259 0.722710 0.664161 0.605612))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.257491 1.198942 1.140393 1.081844 1.023296))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.926299 0.867750 0.809201 0.750652 0.692104))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.595107 0.536558 0.478009 0.419460 0.360912))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 1.071339 1.012790 0.954241).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.740147 0.681598 0.623049).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.408955 0.350406 0.291857).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 0.885187 0.826638).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 0.553995 0.495446).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 0.222803 1.764254).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.512883 0.454334).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.781691 1.723142).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.450499 1.391950).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.326731 0.268182).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.595539 1.536990).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.264347 1.205798).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 1.740579 1.682030 1.623481).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.409387 1.350838 1.292289).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.078195 1.019646 0.961097).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.554427 1.495878).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.223235 1.164686).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.892043 0.833494).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.368275 1.309726 1.251177 1.192628 1.134080 1.075531 1.016982).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.037083 0.978534 0.919985 0.861436 0.802888 0.744339 0.685790).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.705891 0.647342 0.588793 0.530244 0.471696 0.413147 0.354598).map Float.toBits))

def spotTau  : Float :=
  (0.005 : Float)

#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.995971 0.937422 0.878873))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.664779 0.606230 0.547681))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.333587 0.275038 0.216489))

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

#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.623667 0.565118 0.506569 0.448020 0.389472 0.330923 0.272374 0.213825 1.755276 1.696728))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.292475 0.233926 1.775377 1.716828 1.658280 1.599731 1.541182 1.482633 1.424084 1.365536))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.561283 1.502734 1.444185 1.385636 1.327088 1.268539 1.209990 1.151441 1.092892 1.034344))

def check_steady_pot_le_abs (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v17 := (alpha * Pin)
  let v26 := (Toil - Ta)
  let v34 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= Ta) || (!(Ta <= Toil) || (!(feq (((v17 - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v26))) - (Upipe * v26)) - v34) (0 : Float)) || (v34 <= v17))))))))

#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.437515 0.378966 0.320417 0.261868 0.203320 1.744771 1.686222 1.627673 1.569124 1.510576))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.706323 1.647774 1.589225 1.530676 1.472128 1.413579 1.355030 1.296481 1.237932 1.179384))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.375131 1.316582 1.258033 1.199484 1.140936 1.082387 1.023838 0.965289 0.906740 0.848192))

def check_steady_unique (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T1 - Ta)
  let v42 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!((0 : Float) <= T2) || (!(feq (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T1 - Twall)))) (0 : Float)) || (!(feq (((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v42))) - (Upipe * v42)) - (max (0 : Float) (UAx * (T2 - Twall)))) (0 : Float)) || (feq T1 T2))))))))))

#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.251363 1.792814 1.734265 1.675716 1.617168 1.558619 1.500070 1.441521 1.382972 1.324424 1.265875))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.520171 1.461622 1.403073 1.344524 1.285976 1.227427 1.168878 1.110329 1.051780 0.993232 0.934683))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.188979 1.130430 1.071881 1.013332 0.954784 0.896235 0.837686 0.779137 0.720588 0.662040 0.603491))

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

#eval IO.println ("step " ++ toString ((step 1.665211 1.606662 1.548113 1.489564 1.431016 1.372467 1.313918 1.255369 1.196820 1.138272 1.079723 1.021174 0.962625 0.904076 0.845528 0.786979).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 1.334019 1.275470 1.216921 1.158372 1.099824 1.041275 0.982726 0.924177 0.865628 0.807080 0.748531 0.689982 0.631433 0.572884 0.514336 0.455787).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 1.002827 0.944278 0.885729 0.827180 0.768632 0.710083 0.651534 0.592985 0.534436 0.475888 0.417339 0.358790 0.300241 0.241692 1.783144 1.724595).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 1.292907 1.234358 1.175809 1.117260 1.058712 1.000163 0.941614 0.883065 0.824516).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.961715 0.903166 0.844617 0.786068 0.727520 0.668971 0.610422 0.551873 0.493324).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.630523 0.571974 0.513425 0.454876 0.396328 0.337779 0.279230 0.220681 1.762132).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.106755 1.048206 0.989657 0.931108 0.872560 0.814011 0.755462 0.696913 0.638364 0.579816))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.775563 0.717014 0.658465 0.599916 0.541368 0.482819 0.424270 0.365721 0.307172 0.248624))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.444371 0.385822 0.327273 0.268724 0.210176 1.751627 1.693078 1.634529 1.575980 1.517432))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 0.920603 0.862054).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.589411 0.530862).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.258219 1.799670).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.734451 0.675902 0.617353))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.403259 0.344710 0.286161))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.672067 1.613518 1.554969))

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

#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.548299 0.489750 0.431201 0.372652).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.217107 1.758558 1.700009 1.641460).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.485915 1.427366 1.368817 1.310268).map Float.toBits))

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

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.362147 0.303598 0.245049 1.786500 1.727952))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.630955 1.572406 1.513857 1.455308 1.396760))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.299763 1.241214 1.182665 1.124116 1.065568))

def sunRate  : Float :=
  (0.000073 : Float)

#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)

def sunReachableS (tDead : Float) (elSun : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))

#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.589843 1.531294).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.258651 1.200102).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.927459 0.868910).toBits)

def check_sunReachableS_mem (tDead : Float) (elSun : Float) : Bool :=
  let v10 := (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))
  (((0 : Float) <= v10) && (v10 <= (1 : Float)))

#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.403691 1.345142))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.072499 1.013950))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.741307 0.682758))

def check_sunReachableS_slope (tDead : Float) (e1 : Float) (e2 : Float) : Bool :=
  let v6 := (((3.141592653589793 : Float) / (2 : Float)) - tDead)
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((e1 - v6) / (0.01 : Float))))) - (1.0 / (1.0 + Float.exp (-((e2 - v6) / (0.01 : Float))))))) <= ((Float.abs (e1 - e2)) / ((4 : Float) * (0.01 : Float))))

#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.217539 1.158990 1.100441))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.886347 0.827798 0.769249))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.555155 0.496606 0.438057))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.031387 0.972838 0.914289 0.855740 0.797192).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.700195 0.641646 0.583097 0.524548 0.466000).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.369003 0.310454 0.251905 1.793356 1.734808).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.845235 0.786686 0.728137 0.669588 0.611040))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.514043 0.455494 0.396945 0.338396 0.279848))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.782851 1.724302 1.665753 1.607204 1.548656))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.659083).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.327891).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.596699).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.472931))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.741739))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.410547))

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

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.286779 0.228230 1.769681 1.711132 1.652584 1.594035).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.555587 1.497038 1.438489 1.379940 1.321392 1.262843).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.224395 1.165846 1.107297 1.048748 0.990200 0.931651).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.700627 1.642078).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.369435 1.310886).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.038243 0.979694).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.514475 1.455926 1.397377 1.338828).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.183283 1.124734 1.066185 1.007636).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.852091 0.793542 0.734993 0.676444).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.328323 1.269774 1.211225 1.152676).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.997131 0.938582 0.880033 0.821484).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.665939 0.607390 0.548841 0.490292).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.142171 1.083622 1.025073 0.966524))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.810979 0.752430 0.693881 0.635332))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.479787 0.421238 0.362689 0.304140))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.956019 0.897470 0.838921 0.780372 0.721824))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.624827 0.566278 0.507729 0.449180 0.390632))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.293635 0.235086 1.776537 1.717988 1.659440))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 0.769867 0.711318 0.652769).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 0.438675 0.380126 0.321577).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.707483 1.648934 1.590385).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tanh_abs_lt_one (x : Float) : Bool :=
  ((Float.abs (Float.tanh x)) < (1 : Float))

#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.397563))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.666371))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.335179))

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.211411 1.752862 1.694313 1.635764 1.577216))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.480219 1.421670 1.363121 1.304572 1.246024))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.149027 1.090478 1.031929 0.973380 0.914832))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 1.625259 1.566710 1.508161 1.449612 1.391064).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.294067 1.235518 1.176969 1.118420 1.059872).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 0.962875 0.904326 0.845777 0.787228 0.728680).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.439107).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.107915).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.776723).toBits)

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

#eval IO.println ("traceConic " ++ toString ((traceConic 1.252955 1.194406 1.135857 1.077308 1.018760 0.960211 0.901662 0.843113 0.784564).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.921763 0.863214 0.804665 0.746116 0.687568 0.629019 0.570470 0.511921 0.453372).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.590571 0.532022 0.473473 0.414924 0.356376 0.297827 0.239278 1.780729 1.722180).map Float.toBits))

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

#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.066803 1.008254 0.949705 0.891156 0.832608 0.774059 0.715510 0.656961 0.598412 0.539864).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.735611 0.677062 0.618513 0.559964 0.501416 0.442867 0.384318 0.325769 0.267220 0.208672).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.404419 0.345870 0.287321 0.228772 1.770224 1.711675 1.653126 1.594577 1.536028 1.477480).map Float.toBits))

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

#eval IO.println ("traceRay " ++ toString ((traceRay 0.694499 0.635950 0.577401 0.518852 0.460304 0.401755 0.343206 0.284657 0.226108 1.767560 1.709011 1.650462).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 0.363307 0.304758 0.246209 1.787660 1.729112 1.670563 1.612014 1.553465 1.494916 1.436368 1.377819 1.319270).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.632115 1.573566 1.515017 1.456468 1.397920 1.339371 1.280822 1.222273 1.163724 1.105176 1.046627 0.988078).map Float.toBits))

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

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.508347 0.449798 0.391249 0.332700 0.274152 0.215603 1.757054 1.698505 1.639956 1.581408 1.522859 1.464310 1.405761 1.347212 1.288664 1.230115 1.171566 1.113017).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.777155 1.718606 1.660057 1.601508 1.542960 1.484411 1.425862 1.367313 1.308764 1.250216 1.191667 1.133118 1.074569 1.016020 0.957472 0.898923 0.840374 0.781825).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.445963 1.387414 1.328865 1.270316 1.211768 1.153219 1.094670 1.036121 0.977572 0.919024 0.860475 0.801926 0.743377 0.684828 0.626280 0.567731 0.509182 0.450633).map Float.toBits))

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

#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.322195 0.263646 0.205097 1.746548 1.688000 1.629451 1.570902 1.512353 1.453804 1.395256 1.336707 1.278158 1.219609).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.591003 1.532454 1.473905 1.415356 1.356808 1.298259 1.239710 1.181161 1.122612 1.064064 1.005515 0.946966 0.888417).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.259811 1.201262 1.142713 1.084164 1.025616 0.967067 0.908518 0.849969 0.791420 0.732872 0.674323 0.615774 0.557225).map Float.toBits))

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

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.736043 1.677494 1.618945 1.560396 1.501848 1.443299 1.384750 1.326201 1.267652 1.209104 1.150555 1.092006 1.033457 0.974908 0.916360 0.857811 0.799262 0.740713 0.682164).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.404851 1.346302 1.287753 1.229204 1.170656 1.112107 1.053558 0.995009 0.936460 0.877912 0.819363 0.760814 0.702265 0.643716 0.585168 0.526619 0.468070 0.409521 0.350972).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.073659 1.015110 0.956561 0.898012 0.839464 0.780915 0.722366 0.663817 0.605268 0.546720 0.488171 0.429622 0.371073 0.312524 0.253976 1.795427 1.736878 1.678329 1.619780).map Float.toBits))

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

#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.549891 1.491342 1.432793 1.374244 1.315696 1.257147 1.198598 1.140049).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.218699 1.160150 1.101601 1.043052 0.984504 0.925955 0.867406 0.808857).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.887507 0.828958 0.770409 0.711860 0.653312 0.594763 0.536214 0.477665).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.363739 1.305190 1.246641))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.032547 0.973998 0.915449))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.701355 0.642806 0.584257))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.177587))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.846395))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.515203))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.991435 0.932886 0.874337 0.815788))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.660243 0.601694 0.543145 0.484596))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.329051 0.270502 0.211953 1.753404))

def turnLoss (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (Tin : Float) : Float :=
  let v8 := (Ac / (8 : Float))
  ((((eps * (0.0000000567 : Float)) * v8) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v8) * (Tin - Ta)))

#eval IO.println ("turnLoss " ++ toString (turnLoss 0.805283 0.746734 0.688185 0.629636 0.571088).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 0.474091 0.415542 0.356993 0.298444 0.239896).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 1.742899 1.684350 1.625801 1.567252 1.508704).toBits)

def turnOut (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Float :=
  let v12 := (Ac / (8 : Float))
  (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))

#eval IO.println ("turnOut " ++ toString (turnOut 0.619131 0.560582 0.502033 0.443484 0.384936 0.326387 0.267838 0.209289).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 0.287939 0.229390 1.770841 1.712292 1.653744 1.595195 1.536646 1.478097).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 1.556747 1.498198 1.439649 1.381100 1.322552 1.264003 1.205454 1.146905).toBits)

def check_turnOut_eq (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Bool :=
  let v12 := (Ac / (8 : Float))
  let v24 := (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))
  (feq v24 v24)

#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 0.432979 0.374430 0.315881 0.257332 1.798784 1.740235 1.681686 1.623137))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.701787 1.643238 1.584689 1.526140 1.467592 1.409043 1.350494 1.291945))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.370595 1.312046 1.253497 1.194948 1.136400 1.077851 1.019302 0.960753))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 0.246827 1.788278 1.729729).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.515635 1.457086 1.398537).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.184443 1.125894 1.067345).map Float.toBits))

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 1.660675 1.602126 1.543577 1.485028 1.426480 1.367931).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.329483 1.270934 1.212385 1.153836 1.095288 1.036739).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.998291 0.939742 0.881193 0.822644 0.764096 0.705547).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 1.474523 1.415974 1.357425 1.298876 1.240328 1.181779).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.143331 1.084782 1.026233 0.967684 0.909136 0.850587).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 0.812139 0.753590 0.695041 0.636492 0.577944 0.519395).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 1.288371 1.229822 1.171273 1.112724 1.054176 0.995627 0.937078 0.878529 0.819980 0.761432 0.702883 0.644334 0.585785).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 0.957179 0.898630 0.840081 0.781532 0.722984 0.664435 0.605886 0.547337 0.488788 0.430240 0.371691 0.313142 0.254593).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 0.625987 0.567438 0.508889 0.450340 0.391792 0.333243 0.274694 0.216145 1.757596 1.699048 1.640499 1.581950 1.523401).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 1.102219 1.043670 0.985121 0.926572 0.868024 0.809475 0.750926 0.692377 0.633828 0.575280 0.516731 0.458182).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.771027 0.712478 0.653929 0.595380 0.536832 0.478283 0.419734 0.361185 0.302636 0.244088 1.785539 1.726990).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.439835 0.381286 0.322737 0.264188 0.205640 1.747091 1.688542 1.629993 1.571444 1.512896 1.454347 1.395798).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.916067 0.857518 0.798969 0.740420 0.681872 0.623323 0.564774 0.506225 0.447676 0.389128 0.330579 0.272030).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.584875 0.526326 0.467777 0.409228 0.350680 0.292131 0.233582 1.775033 1.716484 1.657936 1.599387 1.540838).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.253683 1.795134 1.736585 1.678036 1.619488 1.560939 1.502390 1.443841 1.385292 1.326744 1.268195 1.209646).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 0.729915 0.671366 0.612817 0.554268 0.495720 0.437171 0.378622 0.320073 0.261524 0.202976 1.744427 1.685878).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.398723 0.340174 0.281625 0.223076 1.764528 1.705979 1.647430 1.588881 1.530332 1.471784 1.413235 1.354686).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 1.667531 1.608982 1.550433 1.491884 1.433336 1.374787 1.316238 1.257689 1.199140 1.140592 1.082043 1.023494).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.543763 0.485214 0.426665 0.368116 0.309568 0.251019 1.792470 1.733921 1.675372 1.616824 1.558275 1.499726).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.212571 1.754022 1.695473 1.636924 1.578376 1.519827 1.461278 1.402729 1.344180 1.285632 1.227083 1.168534).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.481379 1.422830 1.364281 1.305732 1.247184 1.188635 1.130086 1.071537 1.012988 0.954440 0.895891 0.837342).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 0.357611 0.299062 0.240513 1.781964 1.723416 1.664867).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.626419 1.567870 1.509321 1.450772 1.392224 1.333675).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.295227 1.236678 1.178129 1.119580 1.061032 1.002483).map Float.toBits))

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

#eval IO.println ("wireLen " ++ toString (wireLen 1.585307 1.526758 1.468209 1.409660 1.351112).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.254115 1.195566 1.137017 1.078468 1.019920).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 0.922923 0.864374 0.805825 0.747276 0.688728).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 1.399155 1.340606 1.282057 1.223508).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.067963 1.009414 0.950865 0.892316).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 0.736771 0.678222 0.619673 0.561124).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.213003 1.154454 1.095905 1.037356 0.978808))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.881811 0.823262 0.764713 0.706164 0.647616))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.550619 0.492070 0.433521 0.374972 0.316424))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.026851 0.968302 0.909753 0.851204))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.695659 0.637110 0.578561 0.520012))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.364467 0.305918 0.247369 1.788820))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.840699 0.782150 0.723601 0.665052))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.509507 0.450958 0.392409 0.333860))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.778315 1.719766 1.661217 1.602668))

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

#eval IO.println ("wireTension " ++ toString (wireTension 0.282243 0.223694 1.765145 1.706596).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.551051 1.492502 1.433953 1.375404).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.219859 1.161310 1.102761 1.044212).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.696091 1.637542 1.578993 1.520444 1.461896 1.403347 1.344798 1.286249))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.364899 1.306350 1.247801 1.189252 1.130704 1.072155 1.013606 0.955057))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.033707 0.975158 0.916609 0.858060 0.799512 0.740963 0.682414 0.623865))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.323787 1.265238 1.206689 1.148140))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.992595 0.934046 0.875497 0.816948))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.661403 0.602854 0.544305 0.485756))

def wrapRad (d : Float) : Float :=
  let v3 := ((2 : Float) * (3.141592653589793 : Float))
  (d - (v3 * (Float.floor ((d + (3.141592653589793 : Float)) / v3))))

#eval IO.println ("wrapRad " ++ toString (wrapRad 1.137635).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.806443).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.475251).toBits)

def check_wrapRad_mem (d : Float) : Bool :=
  let v4 := ((2 : Float) * (3.141592653589793 : Float))
  let v9 := (d - (v4 * (Float.floor ((d + (3.141592653589793 : Float)) / v4))))
  (((-(3.141592653589793 : Float)) <= v9) && (v9 < (3.141592653589793 : Float)))

#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.951483))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.620291))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.289099))

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.765331 0.706782 0.648233 0.589684 0.531136 0.472587).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.434139 0.375590 0.317041 0.258492 1.799944 1.741395).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.702947 1.644398 1.585849 1.527300 1.468752 1.410203).map Float.toBits))

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

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.206875 1.748326 1.689777))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.475683 1.417134 1.358585))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.144491 1.085942 1.027393))

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
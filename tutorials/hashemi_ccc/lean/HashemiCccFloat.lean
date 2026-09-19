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

def FitsReceiver (a : Float) (b2 : Float) (rm : Float) : Bool :=
  let v4 := (rm ^ 2)
  ((((3.141592653589793 : Float) * v4) * ((a * (Float.sqrt ((1 : Float) + (v4 / b2)))) - a)) <= (((3.141592653589793 : Float) * ((0.06 : Float) ^ 2)) * (0.04 : Float)))

#eval IO.println ("FitsReceiver " ++ toString (FitsReceiver 0.735323 0.676774 0.618225))
#eval IO.println ("FitsReceiver " ++ toString (FitsReceiver 0.404131 0.345582 0.287033))
#eval IO.println ("FitsReceiver " ++ toString (FitsReceiver 1.672939 1.614390 1.555841))

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

#eval IO.println ("HangerClearsPost " ++ toString (HangerClearsPost 1.776867 1.718318))
#eval IO.println ("HangerClearsPost " ++ toString (HangerClearsPost 1.445675 1.387126))
#eval IO.println ("HangerClearsPost " ++ toString (HangerClearsPost 1.114483 1.055934))

def HoldsDish (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) : Bool :=
  ((W * rcm) <= (Tmax * rw))

#eval IO.println ("HoldsDish " ++ toString (HoldsDish 1.590715 1.532166 1.473617 1.415068))
#eval IO.println ("HoldsDish " ++ toString (HoldsDish 1.259523 1.200974 1.142425 1.083876))
#eval IO.println ("HoldsDish " ++ toString (HoldsDish 0.928331 0.869782 0.811233 0.752684))

def Leg_footLong (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (l_foot - l_footShort)

#eval IO.println ("Leg_footLong " ++ toString (Leg_footLong 1.404563 1.346014 1.287465 1.228916 1.170368).toBits)
#eval IO.println ("Leg_footLong " ++ toString (Leg_footLong 1.073371 1.014822 0.956273 0.897724 0.839176).toBits)
#eval IO.println ("Leg_footLong " ++ toString (Leg_footLong 0.742179 0.683630 0.625081 0.566532 0.507984).toBits)

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

#eval IO.println ("LostSun " ++ toString (LostSun 1.218411 1.159862 1.101313 1.042764 0.984216 0.925667))
#eval IO.println ("LostSun " ++ toString (LostSun 0.887219 0.828670 0.770121 0.711572 0.653024 0.594475))
#eval IO.println ("LostSun " ++ toString (LostSun 0.556027 0.497478 0.438929 0.380380 0.321832 0.263283))

def MastClears (ym : Float) (a : Float) (ze : Float) : Bool :=
  ((Float.sqrt ((a ^ 2) + (ze ^ 2))) < ym)

#eval IO.println ("MastClears " ++ toString (MastClears 1.032259 0.973710 0.915161))
#eval IO.println ("MastClears " ++ toString (MastClears 0.701067 0.642518 0.583969))
#eval IO.println ("MastClears " ++ toString (MastClears 0.369875 0.311326 0.252777))

def ReachesVertical (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  ((ym * a) <= (hp * ze))

#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 0.846107 0.787558 0.729009 0.670460))
#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 0.514915 0.456366 0.397817 0.339268))
#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 1.783723 1.725174 1.666625 1.608076))

def SlackHarmless (f : Float) (eps : Float) (delta : Float) (h : Float) : Bool :=
  (((f * (Float.tan eps)) + delta) <= h)

#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 0.659955 0.601406 0.542857 0.484308))
#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 0.328763 0.270214 0.211665 1.753116))
#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 1.597571 1.539022 1.480473 1.421924))

def SunReachable (tDead : Float) (elSun : Float) : Bool :=
  ((((3.141592653589793 : Float) / (2 : Float)) - tDead) <= elSun)

#eval IO.println ("SunReachable " ++ toString (SunReachable 0.473803 0.415254))
#eval IO.println ("SunReachable " ++ toString (SunReachable 1.742611 1.684062))
#eval IO.println ("SunReachable " ++ toString (SunReachable 1.411419 1.352870))

def TrackerBudget (f : Float) (eps : Float) (h : Float) : Bool :=
  ((f * (Float.tan eps)) <= h)

#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 0.287651 0.229102 1.770553))
#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 1.556459 1.497910 1.439361))
#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 1.225267 1.166718 1.108169))

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

#eval IO.println ("azRate " ++ toString (azRate 1.329195 1.270646 1.212097).toBits)
#eval IO.println ("azRate " ++ toString (azRate 0.998003 0.939454 0.880905).toBits)
#eval IO.println ("azRate " ++ toString (azRate 0.666811 0.608262 0.549713).toBits)

def check_azRate_pos (omegam : Float) (rw : Float) (R : Float) : Bool :=
  (!((0 : Float) < omegam) || (!((0 : Float) < rw) || (!((0 : Float) < R) || ((0 : Float) < ((omegam * rw) / R)))))

#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 1.143043 1.084494 1.025945))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 0.811851 0.753302 0.694753))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 0.480659 0.422110 0.363561))

def beamAxis (t : Float) (beta : Float) : Array Float :=
  let v2 := (t + beta)
  #[(Float.sin v2), (0 : Float), (-(Float.cos v2))]

#eval IO.println ("beamAxis " ++ toString ((beamAxis 0.956891 0.898342).map Float.toBits))
#eval IO.println ("beamAxis " ++ toString ((beamAxis 0.625699 0.567150).map Float.toBits))
#eval IO.println ("beamAxis " ++ toString ((beamAxis 0.294507 0.235958).map Float.toBits))

def check_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 0.770739))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 0.439547))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 1.708355))

def check_bins_partition (rc : Float) (r : Float) : Bool :=
  (!((0 : Float) < rc) || (!((0 : Float) <= r) || (feq ((((((((if (((((0 : Float) * rc) / (8 : Float)) <= r) && (r < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float)) + (if (((((1 : Float) * rc) / (8 : Float)) <= r) && (r < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((2 : Float) * rc) / (8 : Float)) <= r) && (r < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((3 : Float) * rc) / (8 : Float)) <= r) && (r < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((4 : Float) * rc) / (8 : Float)) <= r) && (r < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((5 : Float) * rc) / (8 : Float)) <= r) && (r < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((6 : Float) * rc) / (8 : Float)) <= r) && (r < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((7 : Float) * rc) / (8 : Float)) <= r) && (r < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) (if (r < rc) then (1 : Float) else (0 : Float)))))

#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 0.584587 0.526038))
#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 0.253395 1.794846))
#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 1.522203 1.463654))

def bisectStep (ym : Float) (hp : Float) (a : Float) (ze : Float) (L : Float) (lohi_1 : Float) (lohi_2 : Float) : Array Float :=
  let v9 := ((lohi_1 + lohi_2) / (2 : Float))
  let v11 := (-a)
  let v12 := (Float.cos v9)
  let v14 := (-ze)
  let v15 := (Float.sin v9)
  let v28 := (L < (Float.sqrt (((((v11 * v12) + (v14 * v15)) - (-ym)) ^ 2) + (((((-v11) * v15) + (v14 * v12)) - hp) ^ 2))))
  #[(if v28 then v9 else lohi_1), (if v28 then lohi_2 else v9)]

#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.398435 0.339886 0.281337 0.222788 1.764240 1.705691 1.647142).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 1.667243 1.608694 1.550145 1.491596 1.433048 1.374499 1.315950).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 1.336051 1.277502 1.218953 1.160404 1.101856 1.043307 0.984758).map Float.toBits))

def boltStress (W : Float) (reach : Float) (d : Float) : Float :=
  (((W / (2 : Float)) * reach) / (((3.141592653589793 : Float) * (d ^ 3)) / (32 : Float)))

#eval IO.println ("boltStress " ++ toString (boltStress 0.212283 1.753734 1.695185).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 1.481091 1.422542 1.363993).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 1.149899 1.091350 1.032801).toBits)

def braceHeight (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (Float.sqrt ((l_brace ^ 2) - ((l_foot - l_footShort) ^ 2)))

#eval IO.println ("braceHeight " ++ toString (braceHeight 1.626131 1.567582 1.509033 1.450484 1.391936).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 1.294939 1.236390 1.177841 1.119292 1.060744).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 0.963747 0.905198 0.846649 0.788100 0.729552).toBits)

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

#eval IO.println ("cableDrop " ++ toString (cableDrop 0.695371 0.636822).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 0.364179 0.305630).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 1.632987 1.574438).toBits)

def check_cable_drop_small (L : Float) (I : Float) : Bool :=
  (!(L <= (4 : Float)) || (!((0 : Float) <= I) || (!(I <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float)) < (0.1 : Float)))))

#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.509219 0.450670))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.778027 1.719478))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.446835 1.388286))

def capSag (a : Float) (b2 : Float) (rm : Float) : Float :=
  ((a * (Float.sqrt ((1 : Float) + ((rm ^ 2) / b2)))) - a)

#eval IO.println ("capSag " ++ toString (capSag 0.323067 0.264518 0.205969).toBits)
#eval IO.println ("capSag " ++ toString (capSag 1.591875 1.533326 1.474777).toBits)
#eval IO.println ("capSag " ++ toString (capSag 1.260683 1.202134 1.143585).toBits)

def captureS (rc : Float) (rad : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((rc - rad) / (0.005 : Float)))))

#eval IO.println ("captureS " ++ toString (captureS 1.736915 1.678366).toBits)
#eval IO.println ("captureS " ++ toString (captureS 1.405723 1.347174).toBits)
#eval IO.println ("captureS " ++ toString (captureS 1.074531 1.015982).toBits)

def check_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 1.550763 1.492214 1.433665))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 1.219571 1.161022 1.102473))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.888379 0.829830 0.771281))

def clearance (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (holeDown : Float) (reach : Float) : Float :=
  ((l_upright - holeDown) - reach)

#eval IO.println ("clearance " ++ toString (clearance 1.364611 1.306062 1.247513 1.188964 1.130416 1.071867 1.013318).toBits)
#eval IO.println ("clearance " ++ toString (clearance 1.033419 0.974870 0.916321 0.857772 0.799224 0.740675 0.682126).toBits)
#eval IO.println ("clearance " ++ toString (clearance 0.702227 0.643678 0.585129 0.526580 0.468032 0.409483 0.350934).toBits)

def check_clearance_hashemi (holeDown : Float) : Bool :=
  let v16 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v16) && (v16 < ((0.146 : Float) - holeDown)))

#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.178459))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.847267))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.516075))

def coilCapture (rs : Float) (rc : Float) (d : Float) : Float :=
  let v9 := (rs ^ 2)
  let v10 := (d ^ 2)
  let v12 := (rc ^ 2)
  let v15 := ((2 : Float) * d)
  let v30 := (d + rs)
  (if ((rs + rc) <= d) then (0 : Float) else (if (d <= (rc - rs)) then (1 : Float) else ((((v9 * (Float.acos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Float.acos (((v10 + v12) - v9) / (v15 * rc))))) - ((Float.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : Float))) / ((3.141592653589793 : Float) * v9))))

#eval IO.println ("coilCapture " ++ toString (coilCapture 0.992307 0.933758 0.875209).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 0.661115 0.602566 0.544017).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 0.329923 0.271374 0.212825).toBits)

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

#eval IO.println ("coilProfile " ++ toString ((coilProfile 0.806155 0.747606 0.689057 0.630508 0.571960 0.513411 0.454862 0.396313 0.337764 0.279216 0.220667 1.762118 1.703569 1.645020 1.586472).map Float.toBits))
#eval IO.println ("coilProfile " ++ toString ((coilProfile 0.474963 0.416414 0.357865 0.299316 0.240768 1.782219 1.723670 1.665121 1.606572 1.548024 1.489475 1.430926 1.372377 1.313828 1.255280).map Float.toBits))
#eval IO.println ("coilProfile " ++ toString ((coilProfile 1.743771 1.685222 1.626673 1.568124 1.509576 1.451027 1.392478 1.333929 1.275380 1.216832 1.158283 1.099734 1.041185 0.982636 0.924088).map Float.toBits))

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

#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 0.620003 0.561454 0.502905 0.444356 0.385808 0.327259 0.268710 0.210161 1.751612 1.693064 1.634515 1.575966 1.517417 1.458868 1.400320))
#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 0.288811 0.230262 1.771713 1.713164 1.654616 1.596067 1.537518 1.478969 1.420420 1.361872 1.303323 1.244774 1.186225 1.127676 1.069128))
#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 1.557619 1.499070 1.440521 1.381972 1.323424 1.264875 1.206326 1.147777 1.089228 1.030680 0.972131 0.913582 0.855033 0.796484 0.737936))

def coilVolume  : Float :=
  (((3.141592653589793 : Float) * ((0.06 : Float) ^ 2)) * (0.04 : Float))

#eval IO.println ("coilVolume " ++ toString (coilVolume).toBits)
#eval IO.println ("coilVolume " ++ toString (coilVolume).toBits)
#eval IO.println ("coilVolume " ++ toString (coilVolume).toBits)

def conicHitS (c : Float) (k : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Float :=
  let v9 := ((1 : Float) + k)
  let v27 := ((((2 : Float) * c) * (((O_0 * d_0) + (O_1 * d_1)) + ((v9 * O_2) * d_2))) - ((2 : Float) * d_2))
  let v36 := ((c * (((O_0 ^ 2) + (O_1 ^ 2)) + (v9 * (O_2 ^ 2)))) - ((2 : Float) * O_2))
  (((2 : Float) * v36) / ((-v27) - (Float.sqrt (max ((v27 ^ 2) - (((4 : Float) * (c * (((d_0 ^ 2) + (d_1 ^ 2)) + (v9 * (d_2 ^ 2))))) * v36)) (0 : Float)))))

#eval IO.println ("conicHitS " ++ toString (conicHitS 0.247699 1.789150 1.730601 1.672052 1.613504 1.554955 1.496406 1.437857).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 1.516507 1.457958 1.399409 1.340860 1.282312 1.223763 1.165214 1.106665).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 1.185315 1.126766 1.068217 1.009668 0.951120 0.892571 0.834022 0.775473).toBits)

def conicSlope (c : Float) (k : Float) (r : Float) : Float :=
  ((c * r) / (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : Float))))

#eval IO.println ("conicSlope " ++ toString (conicSlope 1.661547 1.602998 1.544449).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.330355 1.271806 1.213257).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 0.999163 0.940614 0.882065).toBits)

def conicZ (c : Float) (k : Float) (r : Float) : Float :=
  let v3 := (r ^ 2)
  ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * v3)) (0 : Float)))))

#eval IO.println ("conicZ " ++ toString (conicZ 1.475395 1.416846 1.358297).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 1.144203 1.085654 1.027105).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 0.813011 0.754462 0.695913).toBits)

def check_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.289243 1.230694))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.958051 0.899502))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.626859 0.568310))

def check_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v4 := (c ^ 2)
  let v5 := (r ^ 2)
  let v18 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v4 * v5) <= (1 : Float)) || (feq ((c * v5) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v4) * v5)) (0 : Float))))) (v18 - (Float.sqrt ((v18 ^ 2) - v5))))))

#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.103091 1.044542))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.771899 0.713350))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.440707 0.382158))

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

#eval IO.println ("constraints " ++ toString ((constraints 0.916939 0.858390 0.799841 0.741292 0.682744 0.624195 0.565646 0.507097 0.448548 0.390000 0.331451 0.272902).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.585747 0.527198 0.468649 0.410100 0.351552 0.293003 0.234454 1.775905 1.717356 1.658808 1.600259 1.541710).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.254555 1.796006 1.737457 1.678908 1.620360 1.561811 1.503262 1.444713 1.386164 1.327616 1.269067 1.210518).map Float.toBits))

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

#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.730787 0.672238 0.613689 0.555140 0.496592 0.438043 0.379494 0.320945 0.262396 0.203848 1.745299 1.686750).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.399595 0.341046 0.282497 0.223948 1.765400 1.706851 1.648302 1.589753 1.531204 1.472656 1.414107 1.355558).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.668403 1.609854 1.551305 1.492756 1.434208 1.375659 1.317110 1.258561 1.200012 1.141464 1.082915 1.024366).map Float.toBits))

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

#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.544635 0.486086 0.427537 0.368988 0.310440 0.251891 1.793342 1.734793 1.676244 1.617696 1.559147 1.500598))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.213443 1.754894 1.696345 1.637796 1.579248 1.520699 1.462150 1.403601 1.345052 1.286504 1.227955 1.169406))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.482251 1.423702 1.365153 1.306604 1.248056 1.189507 1.130958 1.072409 1.013860 0.955312 0.896763 0.838214))

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

#eval IO.println ("cross3 " ++ toString ((cross3 1.586179 1.527630 1.469081 1.410532 1.351984 1.293435).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 1.254987 1.196438 1.137889 1.079340 1.020792 0.962243).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 0.923795 0.865246 0.806697 0.748148 0.689600 0.631051).map Float.toBits))

def deadPoint (ym : Float) (hp : Float) (a : Float) (ze : Float) : Float :=
  let v4 := (ym * a)
  let v5 := (hp * ze)
  (if (v4 <= v5) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v4 - v5))))

#eval IO.println ("deadPoint " ++ toString (deadPoint 1.400027 1.341478 1.282929 1.224380).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.068835 1.010286 0.951737 0.893188).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 0.737643 0.679094 0.620545 0.561996).toBits)

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

#eval IO.println ("delivered " ++ toString (delivered 0.655419 0.596870 0.538321 0.479772).toBits)
#eval IO.println ("delivered " ++ toString (delivered 0.324227 0.265678 0.207129 1.748580).toBits)
#eval IO.println ("delivered " ++ toString (delivered 1.593035 1.534486 1.475937 1.417388).toBits)

def check_delivered_ge_amb (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Bool :=
  (!(Ta <= Tin) || (Ta <= (Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp))))))

#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 0.469267 0.410718 0.352169 0.293620))
#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 1.738075 1.679526 1.620977 1.562428))
#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 1.406883 1.348334 1.289785 1.231236))

def check_delivered_le (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || (!(Ta <= Tin) || ((Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp)))) <= Tin))))

#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 0.283115 0.224566 1.766017 1.707468))
#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 1.551923 1.493374 1.434825 1.376276))
#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 1.220731 1.162182 1.103633 1.045084))

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

#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.696963 1.638414).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.365771 1.307222).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.034579 0.976030).map Float.toBits))

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

#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.510811 1.452262 1.393713))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.179619 1.121070 1.062521))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.848427 0.789878 0.731329))

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

#eval IO.println ("dishPower " ++ toString ((dishPower 0.952355 0.893806 0.835257 0.776708 0.718160 0.659611 0.601062 0.542513 0.483964 0.425416 0.366867 0.308318 0.249769 1.791220 1.732672 1.674123 1.615574 1.557025 1.498476 1.439928 1.381379 1.322830 1.264281 1.205732).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 0.621163 0.562614 0.504065 0.445516 0.386968 0.328419 0.269870 0.211321 1.752772 1.694224 1.635675 1.577126 1.518577 1.460028 1.401480 1.342931 1.284382 1.225833 1.167284 1.108736 1.050187 0.991638 0.933089 0.874540).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 0.289971 0.231422 1.772873 1.714324 1.655776 1.597227 1.538678 1.480129 1.421580 1.363032 1.304483 1.245934 1.187385 1.128836 1.070288 1.011739 0.953190 0.894641 0.836092 0.777544 0.718995 0.660446 0.601897 0.543348).map Float.toBits))

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

#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.766203 0.707654 0.649105 0.590556 0.532008 0.473459 0.414910 0.356361 0.297812 0.239264 1.780715 1.722166 1.663617 1.605068 1.546520 1.487971 1.429422 1.370873 1.312324 1.253776 1.195227 1.136678 1.078129 1.019580))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.435011 0.376462 0.317913 0.259364 0.200816 1.742267 1.683718 1.625169 1.566620 1.508072 1.449523 1.390974 1.332425 1.273876 1.215328 1.156779 1.098230 1.039681 0.981132 0.922584 0.864035 0.805486 0.746937 0.688388))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.703819 1.645270 1.586721 1.528172 1.469624 1.411075 1.352526 1.293977 1.235428 1.176880 1.118331 1.059782 1.001233 0.942684 0.884136 0.825587 0.767038 0.708489 0.649940 0.591392 0.532843 0.474294 0.415745 0.357196))

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

#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.580051 0.521502 0.462953 0.404404 0.345856 0.287307 0.228758 1.770209 1.711660 1.653112 1.594563 1.536014 1.477465 1.418916 1.360368 1.301819 1.243270 1.184721 1.126172 1.067624 1.009075 0.950526 0.891977 0.833428))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.248859 1.790310 1.731761 1.673212 1.614664 1.556115 1.497566 1.439017 1.380468 1.321920 1.263371 1.204822 1.146273 1.087724 1.029176 0.970627 0.912078 0.853529 0.794980 0.736432 0.677883 0.619334 0.560785 0.502236))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.517667 1.459118 1.400569 1.342020 1.283472 1.224923 1.166374 1.107825 1.049276 0.990728 0.932179 0.873630 0.815081 0.756532 0.697984 0.639435 0.580886 0.522337 0.463788 0.405240 0.346691 0.288142 0.229593 1.771044))

def dishR  : Float :=
  (2 : Float)

#eval IO.println ("dishR " ++ toString (dishR).toBits)
#eval IO.println ("dishR " ++ toString (dishR).toBits)
#eval IO.println ("dishR " ++ toString (dishR).toBits)

def dishReflect (R : Float) (f : Float) (a : Float) (w : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (cx : Float) (cy : Float) (ux : Float) (uy : Float) (dx : Float) (dy : Float) (dz : Float) (e1 : Float) (e2 : Float) (s1 : Float) (s2 : Float) : Array Float :=
  let v24 := (w / (2 : Float))
  let v31 := (cx + ux)
  let v32 := (cy + uy)
  let v33 := ((2 : Float) * f)
  let v35 := ((1 : Float) / R)
  let v41 := (Float.sqrt (max ((cx ^ 2) + (cy ^ 2)) (0.000000000000000001 : Float)))
  let v42 := (v41 ^ 2)
  let v48 := ((1 : Float) - ((((1 : Float) + k) * (v35 ^ 2)) * v42))
  let v57 := ((v35 * v41) / (Float.sqrt (max v48 (0.000000000000000001 : Float))))
  let v60 := (Float.sqrt ((1 : Float) + (v57 ^ 2)))
  let v61 := (-v57)
  let v64 := (((v61 * cx) / v41) / v60)
  let v67 := (((v61 * cy) / v41) / v60)
  let v68 := ((1 : Float) / v60)
  let v70 := (v64 + (sigmaslope * e1))
  let v72 := (v67 + (sigmaslope * e2))
  let v78 := (Float.sqrt (((v70 ^ 2) + (v72 ^ 2)) + (v68 ^ 2)))
  let v79 := (v70 / v78)
  let v80 := (v72 / v78)
  let v81 := (v68 / v78)
  let v95 := (((((cx - v31) * v64) + ((cy - v32) * v67)) + ((((v35 * v42) / ((1 : Float) + (Float.sqrt (max v48 (0 : Float))))) - v33) * v68)) / (((dx * v64) + (dy * v67)) + (dz * v68)))
  let v107 := ((2 : Float) * (((dx * v79) + (dy * v80)) + (dz * v81)))
  let v113 := (dz - (v107 * v81))
  let v115 := ((dx - (v107 * v79)) + (sigmaspec * s1))
  let v117 := ((dy - (v107 * v80)) + (sigmaspec * s2))
  let v123 := (Float.sqrt (((v115 ^ 2) + (v117 ^ 2)) + (v113 ^ 2)))
  #[(v31 + (v95 * dx)), (v32 + (v95 * dy)), (v33 + (v95 * dz)), (v115 / v123), (v117 / v123), (v113 / v123), (if (((Float.abs cx) <= a) && (((Float.abs cy) <= a) && (((Float.abs ux) <= v24) && ((Float.abs uy) <= v24)))) then (1 : Float) else (0 : Float))]

#eval IO.println ("dishReflect " ++ toString ((dishReflect 0.207747 1.749198 1.690649 1.632100 1.573552 1.515003 1.456454 1.397905 1.339356 1.280808 1.222259 1.163710 1.105161 1.046612 0.988064 0.929515 0.870966 0.812417).map Float.toBits))
#eval IO.println ("dishReflect " ++ toString ((dishReflect 1.476555 1.418006 1.359457 1.300908 1.242360 1.183811 1.125262 1.066713 1.008164 0.949616 0.891067 0.832518 0.773969 0.715420 0.656872 0.598323 0.539774 0.481225).map Float.toBits))
#eval IO.println ("dishReflect " ++ toString ((dishReflect 1.145363 1.086814 1.028265 0.969716 0.911168 0.852619 0.794070 0.735521 0.676972 0.618424 0.559875 0.501326 0.442777 0.384228 0.325680 0.267131 0.208582 1.750033).map Float.toBits))

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

#eval IO.println ("dot3 " ++ toString (dot3 1.063139 1.004590 0.946041 0.887492 0.828944 0.770395).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 0.731947 0.673398 0.614849 0.556300 0.497752 0.439203).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 0.400755 0.342206 0.283657 0.225108 1.766560 1.708011).toBits)

def driveAz (u : Float) (rw : Float) (R : Float) : Float :=
  (((u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("driveAz " ++ toString (driveAz 0.876987 0.818438 0.759889).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 0.545795 0.487246 0.428697).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 0.214603 1.756054 1.697505).toBits)

def check_driveAz_rate (u : Float) (rw : Float) (R : Float) : Bool :=
  let v11 := (u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rw (0 : Float))) || (!(!(feq R (0 : Float))) || (feq ((((v11 * R) / rw) * rw) / R) v11)))

#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 0.690835 0.632286 0.573737))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 0.359643 0.301094 0.242545))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 1.628451 1.569902 1.511353))

def driveEl (u : Float) (arm : Float) (rDrum : Float) : Float :=
  (((u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("driveEl " ++ toString (driveEl 0.504683 0.446134 0.387585).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 1.773491 1.714942 1.656393).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 1.442299 1.383750 1.325201).toBits)

def check_driveEl_rate (u : Float) (arm : Float) (rDrum : Float) : Bool :=
  let v11 := (u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rDrum (0 : Float))) || (!(!(feq arm (0 : Float))) || (feq ((((v11 * arm) / rDrum) * rDrum) / arm) v11)))

#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.318531 0.259982 0.201433))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 1.587339 1.528790 1.470241))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 1.256147 1.197598 1.139049))

def check_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v21 := (Float.sqrt ((v16 ^ 2) + (c_apexH ^ 2)))
  let v23 := (-((F * v16) / v21))
  let v25 := ((F * c_apexH) / v21)
  (feq (((((((0 : Float) * ((v16 * (0 : Float)) - (b_zRail * v25))) + ((0 : Float) * ((b_zRail * v23) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v25) - (v16 * v23)))) + ((0 : Float) * v23)) + ((0 : Float) * v25)) + ((0 : Float) * (0 : Float))) (F * v21))

#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.732379 1.673830 1.615281 1.556732 1.498184 1.439635 1.381086 1.322537 1.263988 1.205440 1.146891 1.088342 1.029793))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.401187 1.342638 1.284089 1.225540 1.166992 1.108443 1.049894 0.991345 0.932796 0.874248 0.815699 0.757150 0.698601))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.069995 1.011446 0.952897 0.894348 0.835800 0.777251 0.718702 0.660153 0.601604 0.543056 0.484507 0.425958 0.367409))

def check_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v17 := (c_chord / (2 : Float))
  let v22 := (Float.sqrt ((v17 ^ 2) + (c_apexH ^ 2)))
  let v24 := (-((F * v17) / v22))
  let v26 := ((F * c_apexH) / v22)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v17 * (0 : Float)) - (b_zRail * v26))) + ((0 : Float) * ((b_zRail * v24) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v26) - (v17 * v24)))) + ((0 : Float) * v24)) + ((0 : Float) * v26)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.546227 1.487678 1.429129 1.370580 1.312032 1.253483 1.194934 1.136385 1.077836 1.019288 0.960739 0.902190 0.843641))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.215035 1.156486 1.097937 1.039388 0.980840 0.922291 0.863742 0.805193 0.746644 0.688096 0.629547 0.570998 0.512449))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.883843 0.825294 0.766745 0.708196 0.649648 0.591099 0.532550 0.474001 0.415452 0.356904 0.298355 0.239806 1.781257))

def edgeClipAt (a : Float) (ze : Float) (t : Float) : Array Float :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  #[((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))]

#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.360075 1.301526 1.242977).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.028883 0.970334 0.911785).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.697691 0.639142 0.580593).map Float.toBits))

def check_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (feq (((-ym) * (((-v6) * v10) + (v9 * v7))) - (hp * ((v6 * v7) + (v9 * v10)))) ((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)))

#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.173923 1.115374 1.056825 0.998276 0.939728))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.842731 0.784182 0.725633 0.667084 0.608536))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.511539 0.452990 0.394441 0.335892 0.277344))

def check_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  (feq ((((v3 * v4) + (v6 * v7)) ^ 2) + ((((-v3) * v7) + (v6 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.987771 0.929222 0.870673))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.656579 0.598030 0.539481))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.325387 0.266838 0.208289))

def check_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v6 := (Float.sqrt (3.36 : Float))
  let v9 := (-(v6 - (1 : Float)))
  let v10 := (Float.sin t)
  (feq ((((v2 * v3) + (v9 * v10)) ^ 2) + ((((-v2) * v10) + (v9 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v6)))

#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.801619))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.470427))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.739235))

def check_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  ((Float.abs ((v3 * v4) + (v6 * v7))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.615467 0.556918 0.498369))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.284275 0.225726 1.767177))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.553083 1.494534 1.435985))

def edgeDepth (f : Float) (a : Float) (sag : Float) (el : Float) : Float :=
  (((f - sag) * (Float.sin el)) + (a * (Float.cos el)))

#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.429315 0.370766 0.312217 0.253668).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.698123 1.639574 1.581025 1.522476).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.366931 1.308382 1.249833 1.191284).toBits)

def check_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.243163 1.784614 1.726065))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.511971 1.453422 1.394873))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.180779 1.122230 1.063681))

def check_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.657011 1.598462 1.539913 1.481364))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.325819 1.267270 1.208721 1.150172))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.994627 0.936078 0.877529 0.818980))

def check_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.470859 1.412310 1.353761))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.139667 1.081118 1.022569))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.808475 0.749926 0.691377))

def check_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v10 := (Float.cos t)
  let v17 := (-a)
  let v19 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v10 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v17) * v5) + (v19 * v10))) - (hp * ((v17 * v10) + (v19 * v5)))) (0 : Float)))

#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.284707 1.226158 1.167609 1.109060 1.050512))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.953515 0.894966 0.836417 0.777868 0.719320))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.622323 0.563774 0.505225 0.446676 0.388128))

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

#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.098555 1.040006 0.981457 0.922908 0.864360))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.767363 0.708814 0.650265 0.591716 0.533168))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.436171 0.377622 0.319073 0.260524 0.201976))

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

#eval IO.println ("elPower " ++ toString (elPower 0.540099 0.481550 0.423001 0.364452).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.208907 1.750358 1.691809 1.633260).toBits)
#eval IO.println ("elPower " ++ toString (elPower 1.477715 1.419166 1.360617 1.302068).toBits)

def check_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v9 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v9 / rw) * (rw * omega)) (v9 * omega)))

#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.353947 0.295398 0.236849 1.778300 1.719752))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 1.622755 1.564206 1.505657 1.447108 1.388560))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 1.291563 1.233014 1.174465 1.115916 1.057368))

def check_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v8 * (Float.sin t)) * omega) <= (v8 * omega)))))

#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.767795 1.709246 1.650697 1.592148))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.436603 1.378054 1.319505 1.260956))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.105411 1.046862 0.988313 0.929764))

def elRate (omegad : Float) (rDrum : Float) (rw : Float) : Float :=
  ((omegad * rDrum) / rw)

#eval IO.println ("elRate " ++ toString (elRate 1.581643 1.523094 1.464545).toBits)
#eval IO.println ("elRate " ++ toString (elRate 1.250451 1.191902 1.133353).toBits)
#eval IO.println ("elRate " ++ toString (elRate 0.919259 0.860710 0.802161).toBits)

def facetSpot (w : Float) (f : Float) : Float :=
  (w + (f * (0.0093 : Float)))

#eval IO.println ("facetSpot " ++ toString (facetSpot 1.395491 1.336942).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.064299 1.005750).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 0.733107 0.674558).toBits)

def check_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))

def focusShift (h : Float) (eps : Float) : Float :=
  (h * (Float.sin eps))

#eval IO.println ("focusShift " ++ toString (focusShift 1.023187 0.964638).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 0.691995 0.633446).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 0.360803 0.302254).toBits)

def check_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v1 := (Float.cos psi)
  let v7 := (Float.sin psi)
  (!(!(feq v1 (1 : Float))) || (!((feq ((v1 * p_1) - (v7 * p_2)) p_1) && (feq ((v7 * p_1) + (v1 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 0.837035 0.778486 0.719937))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 0.505843 0.447294 0.388745))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.774651 1.716102 1.657553))

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

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.464731 0.406182 0.347633 0.289084 0.230536 1.771987 1.713438 1.654889 1.596340 1.537792 1.479243 1.420694))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.733539 1.674990 1.616441 1.557892 1.499344 1.440795 1.382246 1.323697 1.265148 1.206600 1.148051 1.089502))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.402347 1.343798 1.285249 1.226700 1.168152 1.109603 1.051054 0.992505 0.933956 0.875408 0.816859 0.758310))

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

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.278579 0.220030 1.761481 1.702932 1.644384 1.585835 1.527286 1.468737 1.410188 1.351640 1.293091 1.234542))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.547387 1.488838 1.430289 1.371740 1.313192 1.254643 1.196094 1.137545 1.078996 1.020448 0.961899 0.903350))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.216195 1.157646 1.099097 1.040548 0.982000 0.923451 0.864902 0.806353 0.747804 0.689256 0.630707 0.572158))

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

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.692427 1.633878 1.575329 1.516780 1.458232 1.399683 1.341134 1.282585 1.224036 1.165488 1.106939 1.048390))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.361235 1.302686 1.244137 1.185588 1.127040 1.068491 1.009942 0.951393 0.892844 0.834296 0.775747 0.717198))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.030043 0.971494 0.912945 0.854396 0.795848 0.737299 0.678750 0.620201 0.561652 0.503104 0.444555 0.386006))

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 1.320123 1.261574 1.203025 1.144476).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 0.988931 0.930382 0.871833 0.813284).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 0.657739 0.599190 0.540641 0.482092).toBits)

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
  let v1629 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); (if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && (((Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))) <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1632 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + ((dr[i * 10 + 2]! - v1429) * w)); let v1511 := (v1428 + ((dr[i * 10 + 3]! - v1429) * w)); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1604 := ((f - (v1512 + (v1571 * v1498))) / (v1589 / v1599)); (1.0 / (1.0 + Float.exp (-((rc - (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2)))) / (0.005 : Float))))))) 0.0)
  let v1650 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((0 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1655 := (((((v1650 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1666 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((1 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1671 := (((((v1666 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1682 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((2 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1687 := (((((v1682 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1699 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((3 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1704 := (((((v1699 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1716 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((4 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1721 := (((((v1716 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1733 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((5 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1738 := (((((v1733 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1750 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((6 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1755 := (((((v1750 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1767 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((7 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
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

#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.389363 0.330814 0.272265 0.213716 1.755168 1.696619 1.638070 1.579521 1.520972 1.462424 1.403875 1.345326 1.286777 1.228228 1.169680 1.111131 1.052582 0.994033 0.935484 0.876936 0.818387 0.759838 0.701289 0.642740 0.584192 0.525643 0.467094 0.408545 0.349996 0.291448 0.232899 1.774350 1.715801 1.657252 1.598704 1.540155 #[0.665979, 0.607430, 0.548881, 0.490332, 0.431784, 0.373235, 0.314686, 0.256137, 1.797588, 1.739040, 1.680491, 1.621942, 1.563393, 1.504844, 1.446296, 1.387747] #[0.665979, 0.607430, 0.548881, 0.490332, 0.431784, 0.373235, 0.314686, 0.256137, 1.797588, 1.739040, 1.680491, 1.621942, 1.563393, 1.504844, 1.446296, 1.387747] #[0.665979, 0.607430, 0.548881, 0.490332, 0.431784, 0.373235, 0.314686, 0.256137, 1.797588, 1.739040, 1.680491, 1.621942, 1.563393, 1.504844, 1.446296, 1.387747, 1.329198, 1.270649, 1.212100, 1.153552, 1.095003, 1.036454, 0.977905, 0.919356, 0.860808, 0.802259, 0.743710, 0.685161, 0.626612, 0.568064, 0.509515, 0.450966, 0.392417, 0.333868, 0.275320, 0.216771, 1.758222, 1.699673, 1.641124, 1.582576, 1.524027, 1.465478, 1.406929, 1.348380, 1.289832, 1.231283, 1.172734, 1.114185, 1.055636, 0.997088, 0.938539, 0.879990, 0.821441, 0.762892, 0.704344, 0.645795, 0.587246, 0.528697, 0.470148, 0.411600, 0.353051, 0.294502, 0.235953, 1.777404, 1.718856, 1.660307, 1.601758, 1.543209, 1.484660, 1.426112, 1.367563, 1.309014, 1.250465, 1.191916, 1.133368, 1.074819, 1.016270, 0.957721, 0.899172, 0.840624, 0.782075, 0.723526, 0.664977, 0.606428, 0.547880, 0.489331, 0.430782, 0.372233, 0.313684, 0.255136, 1.796587, 1.738038, 1.679489, 1.620940, 1.562392, 1.503843, 1.445294, 1.386745, 1.328196, 1.269648, 1.211099, 1.152550, 1.094001, 1.035452, 0.976904, 0.918355, 0.859806, 0.801257, 0.742708, 0.684160, 0.625611, 0.567062, 0.508513, 0.449964, 0.391416, 0.332867, 0.274318, 0.215769, 1.757220, 1.698672, 1.640123, 1.581574, 1.523025, 1.464476, 1.405928, 1.347379, 1.288830, 1.230281, 1.171732, 1.113184, 1.054635, 0.996086, 0.937537, 0.878988, 0.820440, 0.761891, 0.703342, 0.644793, 0.586244, 0.527696, 0.469147, 0.410598, 0.352049, 0.293500, 0.234952, 1.776403, 1.717854, 1.659305, 1.600756, 1.542208, 1.483659, 1.425110, 1.366561, 1.308012, 1.249464, 1.190915, 1.132366, 1.073817, 1.015268, 0.956720, 0.898171, 0.839622, 0.781073, 0.722524, 0.663976, 0.605427, 0.546878, 0.488329, 0.429780, 0.371232, 0.312683, 0.254134, 1.795585, 1.737036, 1.678488, 1.619939, 1.561390, 1.502841, 1.444292, 1.385744, 1.327195, 1.268646, 1.210097, 1.151548, 1.093000, 1.034451, 0.975902, 0.917353, 0.858804, 0.800256, 0.741707, 0.683158, 0.624609, 0.566060, 0.507512, 0.448963, 0.390414, 0.331865, 0.273316, 0.214768, 1.756219, 1.697670, 1.639121, 1.580572, 1.522024, 1.463475, 1.404926, 1.346377, 1.287828, 1.229280, 1.170731, 1.112182, 1.053633, 0.995084, 0.936536, 0.877987, 0.819438, 0.760889, 0.702340, 0.643792, 0.585243, 0.526694, 0.468145, 0.409596, 0.351048, 0.292499, 0.233950, 1.775401, 1.716852, 1.658304, 1.599755, 1.541206, 1.482657, 1.424108, 1.365560, 1.307011, 1.248462, 1.189913, 1.131364, 1.072816, 1.014267, 0.955718, 0.897169, 0.838620, 0.780072, 0.721523, 0.662974, 0.604425, 0.545876, 0.487328, 0.428779, 0.370230, 0.311681, 0.253132, 1.794584, 1.736035, 1.677486, 1.618937, 1.560388, 1.501840, 1.443291, 1.384742, 1.326193, 1.267644, 1.209096, 1.150547, 1.091998, 1.033449, 0.974900, 0.916352, 0.857803, 0.799254, 0.740705, 0.682156, 0.623608, 0.565059, 0.506510, 0.447961, 0.389412, 0.330864, 0.272315, 0.213766, 1.755217, 1.696668, 1.638120, 1.579571, 1.521022, 1.462473, 1.403924, 1.345376, 1.286827, 1.228278, 1.169729, 1.111180, 1.052632, 0.994083, 0.935534, 0.876985, 0.818436, 0.759888, 0.701339, 0.642790, 0.584241, 0.525692, 0.467144, 0.408595, 0.350046, 0.291497, 0.232948, 1.774400, 1.715851, 1.657302, 1.598753, 1.540204, 1.481656, 1.423107, 1.364558, 1.306009, 1.247460, 1.188912, 1.130363, 1.071814, 1.013265, 0.954716, 0.896168, 0.837619, 0.779070, 0.720521, 0.661972, 0.603424, 0.544875, 0.486326, 0.427777, 0.369228, 0.310680, 0.252131, 1.793582, 1.735033, 1.676484, 1.617936, 1.559387, 1.500838, 1.442289, 1.383740, 1.325192, 1.266643, 1.208094, 1.149545, 1.090996, 1.032448, 0.973899, 0.915350, 0.856801, 0.798252, 0.739704, 0.681155, 0.622606, 0.564057, 0.505508, 0.446960, 0.388411, 0.329862, 0.271313, 0.212764, 1.754216, 1.695667, 1.637118, 1.578569, 1.520020, 1.461472, 1.402923, 1.344374, 1.285825, 1.227276, 1.168728, 1.110179, 1.051630, 0.993081, 0.934532, 0.875984, 0.817435, 0.758886, 0.700337, 0.641788, 0.583240, 0.524691, 0.466142, 0.407593, 0.349044, 0.290496, 0.231947, 1.773398, 1.714849, 1.656300, 1.597752, 1.539203, 1.480654, 1.422105, 1.363556, 1.305008, 1.246459, 1.187910, 1.129361, 1.070812, 1.012264, 0.953715, 0.895166, 0.836617, 0.778068, 0.719520, 0.660971, 0.602422, 0.543873, 0.485324, 0.426776, 0.368227, 0.309678, 0.251129, 1.792580, 1.734032, 1.675483, 1.616934, 1.558385, 1.499836, 1.441288, 1.382739, 1.324190, 1.265641, 1.207092, 1.148544, 1.089995, 1.031446, 0.972897, 0.914348, 0.855800, 0.797251, 0.738702, 0.680153, 0.621604, 0.563056, 0.504507, 0.445958, 0.387409, 0.328860, 0.270312, 0.211763, 1.753214, 1.694665, 1.636116, 1.577568, 1.519019, 1.460470, 1.401921, 1.343372, 1.284824, 1.226275, 1.167726, 1.109177, 1.050628, 0.992080, 0.933531, 0.874982, 0.816433, 0.757884, 0.699336, 0.640787, 0.582238, 0.523689, 0.465140, 0.406592, 0.348043, 0.289494, 0.230945, 1.772396, 1.713848, 1.655299, 1.596750, 1.538201, 1.479652, 1.421104, 1.362555, 1.304006, 1.245457, 1.186908, 1.128360, 1.069811, 1.011262, 0.952713, 0.894164, 0.835616, 0.777067, 0.718518, 0.659969, 0.601420, 0.542872, 0.484323, 0.425774, 0.367225, 0.308676, 0.250128, 1.791579, 1.733030, 1.674481, 1.615932, 1.557384, 1.498835, 1.440286, 1.381737, 1.323188, 1.264640, 1.206091, 1.147542, 1.088993, 1.030444, 0.971896, 0.913347, 0.854798, 0.796249, 0.737700, 0.679152, 0.620603, 0.562054, 0.503505, 0.444956, 0.386408, 0.327859, 0.269310, 0.210761, 1.752212, 1.693664, 1.635115, 1.576566, 1.518017, 1.459468, 1.400920, 1.342371, 1.283822, 1.225273, 1.166724, 1.108176, 1.049627, 0.991078, 0.932529, 0.873980, 0.815432, 0.756883, 0.698334, 0.639785, 0.581236, 0.522688, 0.464139, 0.405590, 0.347041, 0.288492, 0.229944, 1.771395, 1.712846, 1.654297, 1.595748, 1.537200, 1.478651, 1.420102, 1.361553, 1.303004, 1.244456, 1.185907, 1.127358, 1.068809, 1.010260, 0.951712, 0.893163, 0.834614, 0.776065, 0.717516, 0.658968, 0.600419, 0.541870, 0.483321, 0.424772, 0.366224, 0.307675, 0.249126, 1.790577, 1.732028, 1.673480, 1.614931, 1.556382, 1.497833, 1.439284, 1.380736, 1.322187, 1.263638, 1.205089, 1.146540, 1.087992, 1.029443, 0.970894, 0.912345, 0.853796, 0.795248, 0.736699, 0.678150, 0.619601, 0.561052, 0.502504, 0.443955, 0.385406, 0.326857, 0.268308, 0.209760, 1.751211, 1.692662, 1.634113, 1.575564, 1.517016, 1.458467, 1.399918, 1.341369, 1.282820, 1.224272, 1.165723, 1.107174, 1.048625, 0.990076, 0.931528, 0.872979, 0.814430, 0.755881, 0.697332, 0.638784, 0.580235, 0.521686, 0.463137, 0.404588, 0.346040, 0.287491, 0.228942, 1.770393, 1.711844, 1.653296]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.658171 1.599622 1.541073 1.482524 1.423976 1.365427 1.306878 1.248329 1.189780 1.131232 1.072683 1.014134 0.955585 0.897036 0.838488 0.779939 0.721390 0.662841 0.604292 0.545744 0.487195 0.428646 0.370097 0.311548 0.253000 1.794451 1.735902 1.677353 1.618804 1.560256 1.501707 1.443158 1.384609 1.326060 1.267512 1.208963 #[0.334787, 0.276238, 0.217689, 1.759140, 1.700592, 1.642043, 1.583494, 1.524945, 1.466396, 1.407848, 1.349299, 1.290750, 1.232201, 1.173652, 1.115104, 1.056555] #[0.334787, 0.276238, 0.217689, 1.759140, 1.700592, 1.642043, 1.583494, 1.524945, 1.466396, 1.407848, 1.349299, 1.290750, 1.232201, 1.173652, 1.115104, 1.056555] #[0.334787, 0.276238, 0.217689, 1.759140, 1.700592, 1.642043, 1.583494, 1.524945, 1.466396, 1.407848, 1.349299, 1.290750, 1.232201, 1.173652, 1.115104, 1.056555, 0.998006, 0.939457, 0.880908, 0.822360, 0.763811, 0.705262, 0.646713, 0.588164, 0.529616, 0.471067, 0.412518, 0.353969, 0.295420, 0.236872, 1.778323, 1.719774, 1.661225, 1.602676, 1.544128, 1.485579, 1.427030, 1.368481, 1.309932, 1.251384, 1.192835, 1.134286, 1.075737, 1.017188, 0.958640, 0.900091, 0.841542, 0.782993, 0.724444, 0.665896, 0.607347, 0.548798, 0.490249, 0.431700, 0.373152, 0.314603, 0.256054, 1.797505, 1.738956, 1.680408, 1.621859, 1.563310, 1.504761, 1.446212, 1.387664, 1.329115, 1.270566, 1.212017, 1.153468, 1.094920, 1.036371, 0.977822, 0.919273, 0.860724, 0.802176, 0.743627, 0.685078, 0.626529, 0.567980, 0.509432, 0.450883, 0.392334, 0.333785, 0.275236, 0.216688, 1.758139, 1.699590, 1.641041, 1.582492, 1.523944, 1.465395, 1.406846, 1.348297, 1.289748, 1.231200, 1.172651, 1.114102, 1.055553, 0.997004, 0.938456, 0.879907, 0.821358, 0.762809, 0.704260, 0.645712, 0.587163, 0.528614, 0.470065, 0.411516, 0.352968, 0.294419, 0.235870, 1.777321, 1.718772, 1.660224, 1.601675, 1.543126, 1.484577, 1.426028, 1.367480, 1.308931, 1.250382, 1.191833, 1.133284, 1.074736, 1.016187, 0.957638, 0.899089, 0.840540, 0.781992, 0.723443, 0.664894, 0.606345, 0.547796, 0.489248, 0.430699, 0.372150, 0.313601, 0.255052, 1.796504, 1.737955, 1.679406, 1.620857, 1.562308, 1.503760, 1.445211, 1.386662, 1.328113, 1.269564, 1.211016, 1.152467, 1.093918, 1.035369, 0.976820, 0.918272, 0.859723, 0.801174, 0.742625, 0.684076, 0.625528, 0.566979, 0.508430, 0.449881, 0.391332, 0.332784, 0.274235, 0.215686, 1.757137, 1.698588, 1.640040, 1.581491, 1.522942, 1.464393, 1.405844, 1.347296, 1.288747, 1.230198, 1.171649, 1.113100, 1.054552, 0.996003, 0.937454, 0.878905, 0.820356, 0.761808, 0.703259, 0.644710, 0.586161, 0.527612, 0.469064, 0.410515, 0.351966, 0.293417, 0.234868, 1.776320, 1.717771, 1.659222, 1.600673, 1.542124, 1.483576, 1.425027, 1.366478, 1.307929, 1.249380, 1.190832, 1.132283, 1.073734, 1.015185, 0.956636, 0.898088, 0.839539, 0.780990, 0.722441, 0.663892, 0.605344, 0.546795, 0.488246, 0.429697, 0.371148, 0.312600, 0.254051, 1.795502, 1.736953, 1.678404, 1.619856, 1.561307, 1.502758, 1.444209, 1.385660, 1.327112, 1.268563, 1.210014, 1.151465, 1.092916, 1.034368, 0.975819, 0.917270, 0.858721, 0.800172, 0.741624, 0.683075, 0.624526, 0.565977, 0.507428, 0.448880, 0.390331, 0.331782, 0.273233, 0.214684, 1.756136, 1.697587, 1.639038, 1.580489, 1.521940, 1.463392, 1.404843, 1.346294, 1.287745, 1.229196, 1.170648, 1.112099, 1.053550, 0.995001, 0.936452, 0.877904, 0.819355, 0.760806, 0.702257, 0.643708, 0.585160, 0.526611, 0.468062, 0.409513, 0.350964, 0.292416, 0.233867, 1.775318, 1.716769, 1.658220, 1.599672, 1.541123, 1.482574, 1.424025, 1.365476, 1.306928, 1.248379, 1.189830, 1.131281, 1.072732, 1.014184, 0.955635, 0.897086, 0.838537, 0.779988, 0.721440, 0.662891, 0.604342, 0.545793, 0.487244, 0.428696, 0.370147, 0.311598, 0.253049, 1.794500, 1.735952, 1.677403, 1.618854, 1.560305, 1.501756, 1.443208, 1.384659, 1.326110, 1.267561, 1.209012, 1.150464, 1.091915, 1.033366, 0.974817, 0.916268, 0.857720, 0.799171, 0.740622, 0.682073, 0.623524, 0.564976, 0.506427, 0.447878, 0.389329, 0.330780, 0.272232, 0.213683, 1.755134, 1.696585, 1.638036, 1.579488, 1.520939, 1.462390, 1.403841, 1.345292, 1.286744, 1.228195, 1.169646, 1.111097, 1.052548, 0.994000, 0.935451, 0.876902, 0.818353, 0.759804, 0.701256, 0.642707, 0.584158, 0.525609, 0.467060, 0.408512, 0.349963, 0.291414, 0.232865, 1.774316, 1.715768, 1.657219, 1.598670, 1.540121, 1.481572, 1.423024, 1.364475, 1.305926, 1.247377, 1.188828, 1.130280, 1.071731, 1.013182, 0.954633, 0.896084, 0.837536, 0.778987, 0.720438, 0.661889, 0.603340, 0.544792, 0.486243, 0.427694, 0.369145, 0.310596, 0.252048, 1.793499, 1.734950, 1.676401, 1.617852, 1.559304, 1.500755, 1.442206, 1.383657, 1.325108, 1.266560, 1.208011, 1.149462, 1.090913, 1.032364, 0.973816, 0.915267, 0.856718, 0.798169, 0.739620, 0.681072, 0.622523, 0.563974, 0.505425, 0.446876, 0.388328, 0.329779, 0.271230, 0.212681, 1.754132, 1.695584, 1.637035, 1.578486, 1.519937, 1.461388, 1.402840, 1.344291, 1.285742, 1.227193, 1.168644, 1.110096, 1.051547, 0.992998, 0.934449, 0.875900, 0.817352, 0.758803, 0.700254, 0.641705, 0.583156, 0.524608, 0.466059, 0.407510, 0.348961, 0.290412, 0.231864, 1.773315, 1.714766, 1.656217, 1.597668, 1.539120, 1.480571, 1.422022, 1.363473, 1.304924, 1.246376, 1.187827, 1.129278, 1.070729, 1.012180, 0.953632, 0.895083, 0.836534, 0.777985, 0.719436, 0.660888, 0.602339, 0.543790, 0.485241, 0.426692, 0.368144, 0.309595, 0.251046, 1.792497, 1.733948, 1.675400, 1.616851, 1.558302, 1.499753, 1.441204, 1.382656, 1.324107, 1.265558, 1.207009, 1.148460, 1.089912, 1.031363, 0.972814, 0.914265, 0.855716, 0.797168, 0.738619, 0.680070, 0.621521, 0.562972, 0.504424, 0.445875, 0.387326, 0.328777, 0.270228, 0.211680, 1.753131, 1.694582, 1.636033, 1.577484, 1.518936, 1.460387, 1.401838, 1.343289, 1.284740, 1.226192, 1.167643, 1.109094, 1.050545, 0.991996, 0.933448, 0.874899, 0.816350, 0.757801, 0.699252, 0.640704, 0.582155, 0.523606, 0.465057, 0.406508, 0.347960, 0.289411, 0.230862, 1.772313, 1.713764, 1.655216, 1.596667, 1.538118, 1.479569, 1.421020, 1.362472, 1.303923, 1.245374, 1.186825, 1.128276, 1.069728, 1.011179, 0.952630, 0.894081, 0.835532, 0.776984, 0.718435, 0.659886, 0.601337, 0.542788, 0.484240, 0.425691, 0.367142, 0.308593, 0.250044, 1.791496, 1.732947, 1.674398, 1.615849, 1.557300, 1.498752, 1.440203, 1.381654, 1.323105, 1.264556, 1.206008, 1.147459, 1.088910, 1.030361, 0.971812, 0.913264, 0.854715, 0.796166, 0.737617, 0.679068, 0.620520, 0.561971, 0.503422, 0.444873, 0.386324, 0.327776, 0.269227, 0.210678, 1.752129, 1.693580, 1.635032, 1.576483, 1.517934, 1.459385, 1.400836, 1.342288, 1.283739, 1.225190, 1.166641, 1.108092, 1.049544, 0.990995, 0.932446, 0.873897, 0.815348, 0.756800, 0.698251, 0.639702, 0.581153, 0.522604, 0.464056, 0.405507, 0.346958, 0.288409, 0.229860, 1.771312, 1.712763, 1.654214, 1.595665, 1.537116, 1.478568, 1.420019, 1.361470, 1.302921, 1.244372, 1.185824, 1.127275, 1.068726, 1.010177, 0.951628, 0.893080, 0.834531, 0.775982, 0.717433, 0.658884, 0.600336, 0.541787, 0.483238, 0.424689, 0.366140, 0.307592, 0.249043, 1.790494, 1.731945, 1.673396, 1.614848, 1.556299, 1.497750, 1.439201, 1.380652, 1.322104]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.326979 1.268430 1.209881 1.151332 1.092784 1.034235 0.975686 0.917137 0.858588 0.800040 0.741491 0.682942 0.624393 0.565844 0.507296 0.448747 0.390198 0.331649 0.273100 0.214552 1.756003 1.697454 1.638905 1.580356 1.521808 1.463259 1.404710 1.346161 1.287612 1.229064 1.170515 1.111966 1.053417 0.994868 0.936320 0.877771 #[1.603595, 1.545046, 1.486497, 1.427948, 1.369400, 1.310851, 1.252302, 1.193753, 1.135204, 1.076656, 1.018107, 0.959558, 0.901009, 0.842460, 0.783912, 0.725363] #[1.603595, 1.545046, 1.486497, 1.427948, 1.369400, 1.310851, 1.252302, 1.193753, 1.135204, 1.076656, 1.018107, 0.959558, 0.901009, 0.842460, 0.783912, 0.725363] #[1.603595, 1.545046, 1.486497, 1.427948, 1.369400, 1.310851, 1.252302, 1.193753, 1.135204, 1.076656, 1.018107, 0.959558, 0.901009, 0.842460, 0.783912, 0.725363, 0.666814, 0.608265, 0.549716, 0.491168, 0.432619, 0.374070, 0.315521, 0.256972, 1.798424, 1.739875, 1.681326, 1.622777, 1.564228, 1.505680, 1.447131, 1.388582, 1.330033, 1.271484, 1.212936, 1.154387, 1.095838, 1.037289, 0.978740, 0.920192, 0.861643, 0.803094, 0.744545, 0.685996, 0.627448, 0.568899, 0.510350, 0.451801, 0.393252, 0.334704, 0.276155, 0.217606, 1.759057, 1.700508, 1.641960, 1.583411, 1.524862, 1.466313, 1.407764, 1.349216, 1.290667, 1.232118, 1.173569, 1.115020, 1.056472, 0.997923, 0.939374, 0.880825, 0.822276, 0.763728, 0.705179, 0.646630, 0.588081, 0.529532, 0.470984, 0.412435, 0.353886, 0.295337, 0.236788, 1.778240, 1.719691, 1.661142, 1.602593, 1.544044, 1.485496, 1.426947, 1.368398, 1.309849, 1.251300, 1.192752, 1.134203, 1.075654, 1.017105, 0.958556, 0.900008, 0.841459, 0.782910, 0.724361, 0.665812, 0.607264, 0.548715, 0.490166, 0.431617, 0.373068, 0.314520, 0.255971, 1.797422, 1.738873, 1.680324, 1.621776, 1.563227, 1.504678, 1.446129, 1.387580, 1.329032, 1.270483, 1.211934, 1.153385, 1.094836, 1.036288, 0.977739, 0.919190, 0.860641, 0.802092, 0.743544, 0.684995, 0.626446, 0.567897, 0.509348, 0.450800, 0.392251, 0.333702, 0.275153, 0.216604, 1.758056, 1.699507, 1.640958, 1.582409, 1.523860, 1.465312, 1.406763, 1.348214, 1.289665, 1.231116, 1.172568, 1.114019, 1.055470, 0.996921, 0.938372, 0.879824, 0.821275, 0.762726, 0.704177, 0.645628, 0.587080, 0.528531, 0.469982, 0.411433, 0.352884, 0.294336, 0.235787, 1.777238, 1.718689, 1.660140, 1.601592, 1.543043, 1.484494, 1.425945, 1.367396, 1.308848, 1.250299, 1.191750, 1.133201, 1.074652, 1.016104, 0.957555, 0.899006, 0.840457, 0.781908, 0.723360, 0.664811, 0.606262, 0.547713, 0.489164, 0.430616, 0.372067, 0.313518, 0.254969, 1.796420, 1.737872, 1.679323, 1.620774, 1.562225, 1.503676, 1.445128, 1.386579, 1.328030, 1.269481, 1.210932, 1.152384, 1.093835, 1.035286, 0.976737, 0.918188, 0.859640, 0.801091, 0.742542, 0.683993, 0.625444, 0.566896, 0.508347, 0.449798, 0.391249, 0.332700, 0.274152, 0.215603, 1.757054, 1.698505, 1.639956, 1.581408, 1.522859, 1.464310, 1.405761, 1.347212, 1.288664, 1.230115, 1.171566, 1.113017, 1.054468, 0.995920, 0.937371, 0.878822, 0.820273, 0.761724, 0.703176, 0.644627, 0.586078, 0.527529, 0.468980, 0.410432, 0.351883, 0.293334, 0.234785, 1.776236, 1.717688, 1.659139, 1.600590, 1.542041, 1.483492, 1.424944, 1.366395, 1.307846, 1.249297, 1.190748, 1.132200, 1.073651, 1.015102, 0.956553, 0.898004, 0.839456, 0.780907, 0.722358, 0.663809, 0.605260, 0.546712, 0.488163, 0.429614, 0.371065, 0.312516, 0.253968, 1.795419, 1.736870, 1.678321, 1.619772, 1.561224, 1.502675, 1.444126, 1.385577, 1.327028, 1.268480, 1.209931, 1.151382, 1.092833, 1.034284, 0.975736, 0.917187, 0.858638, 0.800089, 0.741540, 0.682992, 0.624443, 0.565894, 0.507345, 0.448796, 0.390248, 0.331699, 0.273150, 0.214601, 1.756052, 1.697504, 1.638955, 1.580406, 1.521857, 1.463308, 1.404760, 1.346211, 1.287662, 1.229113, 1.170564, 1.112016, 1.053467, 0.994918, 0.936369, 0.877820, 0.819272, 0.760723, 0.702174, 0.643625, 0.585076, 0.526528, 0.467979, 0.409430, 0.350881, 0.292332, 0.233784, 1.775235, 1.716686, 1.658137, 1.599588, 1.541040, 1.482491, 1.423942, 1.365393, 1.306844, 1.248296, 1.189747, 1.131198, 1.072649, 1.014100, 0.955552, 0.897003, 0.838454, 0.779905, 0.721356, 0.662808, 0.604259, 0.545710, 0.487161, 0.428612, 0.370064, 0.311515, 0.252966, 1.794417, 1.735868, 1.677320, 1.618771, 1.560222, 1.501673, 1.443124, 1.384576, 1.326027, 1.267478, 1.208929, 1.150380, 1.091832, 1.033283, 0.974734, 0.916185, 0.857636, 0.799088, 0.740539, 0.681990, 0.623441, 0.564892, 0.506344, 0.447795, 0.389246, 0.330697, 0.272148, 0.213600, 1.755051, 1.696502, 1.637953, 1.579404, 1.520856, 1.462307, 1.403758, 1.345209, 1.286660, 1.228112, 1.169563, 1.111014, 1.052465, 0.993916, 0.935368, 0.876819, 0.818270, 0.759721, 0.701172, 0.642624, 0.584075, 0.525526, 0.466977, 0.408428, 0.349880, 0.291331, 0.232782, 1.774233, 1.715684, 1.657136, 1.598587, 1.540038, 1.481489, 1.422940, 1.364392, 1.305843, 1.247294, 1.188745, 1.130196, 1.071648, 1.013099, 0.954550, 0.896001, 0.837452, 0.778904, 0.720355, 0.661806, 0.603257, 0.544708, 0.486160, 0.427611, 0.369062, 0.310513, 0.251964, 1.793416, 1.734867, 1.676318, 1.617769, 1.559220, 1.500672, 1.442123, 1.383574, 1.325025, 1.266476, 1.207928, 1.149379, 1.090830, 1.032281, 0.973732, 0.915184, 0.856635, 0.798086, 0.739537, 0.680988, 0.622440, 0.563891, 0.505342, 0.446793, 0.388244, 0.329696, 0.271147, 0.212598, 1.754049, 1.695500, 1.636952, 1.578403, 1.519854, 1.461305, 1.402756, 1.344208, 1.285659, 1.227110, 1.168561, 1.110012, 1.051464, 0.992915, 0.934366, 0.875817, 0.817268, 0.758720, 0.700171, 0.641622, 0.583073, 0.524524, 0.465976, 0.407427, 0.348878, 0.290329, 0.231780, 1.773232, 1.714683, 1.656134, 1.597585, 1.539036, 1.480488, 1.421939, 1.363390, 1.304841, 1.246292, 1.187744, 1.129195, 1.070646, 1.012097, 0.953548, 0.895000, 0.836451, 0.777902, 0.719353, 0.660804, 0.602256, 0.543707, 0.485158, 0.426609, 0.368060, 0.309512, 0.250963, 1.792414, 1.733865, 1.675316, 1.616768, 1.558219, 1.499670, 1.441121, 1.382572, 1.324024, 1.265475, 1.206926, 1.148377, 1.089828, 1.031280, 0.972731, 0.914182, 0.855633, 0.797084, 0.738536, 0.679987, 0.621438, 0.562889, 0.504340, 0.445792, 0.387243, 0.328694, 0.270145, 0.211596, 1.753048, 1.694499, 1.635950, 1.577401, 1.518852, 1.460304, 1.401755, 1.343206, 1.284657, 1.226108, 1.167560, 1.109011, 1.050462, 0.991913, 0.933364, 0.874816, 0.816267, 0.757718, 0.699169, 0.640620, 0.582072, 0.523523, 0.464974, 0.406425, 0.347876, 0.289328, 0.230779, 1.772230, 1.713681, 1.655132, 1.596584, 1.538035, 1.479486, 1.420937, 1.362388, 1.303840, 1.245291, 1.186742, 1.128193, 1.069644, 1.011096, 0.952547, 0.893998, 0.835449, 0.776900, 0.718352, 0.659803, 0.601254, 0.542705, 0.484156, 0.425608, 0.367059, 0.308510, 0.249961, 1.791412, 1.732864, 1.674315, 1.615766, 1.557217, 1.498668, 1.440120, 1.381571, 1.323022, 1.264473, 1.205924, 1.147376, 1.088827, 1.030278, 0.971729, 0.913180, 0.854632, 0.796083, 0.737534, 0.678985, 0.620436, 0.561888, 0.503339, 0.444790, 0.386241, 0.327692, 0.269144, 0.210595, 1.752046, 1.693497, 1.634948, 1.576400, 1.517851, 1.459302, 1.400753, 1.342204, 1.283656, 1.225107, 1.166558, 1.108009, 1.049460, 0.990912]).map Float.toBits))

def hashemiEnvBeam (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (L : Float) (dm : Float) (rm : Float) (rt : Float) (slotW : Float) (beta : Float) (dr : Array Float) : Array Float :=
  let v683 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v695 := ((1.22 : Float) * (0.8 : Float))
  let v696 := ((0.34 : Float) * v683)
  let v699 := ((3.141592653589793 : Float) / (2 : Float))
  let v706 := (if (v695 <= v696) then v699 else (Float.atan ((((1.22 : Float) * v683) + ((0.34 : Float) * (0.8 : Float))) / (v695 - v696))))
  let v707 := (-(1.22 : Float))
  let v708 := (-(0.8 : Float))
  let v710 := (Float.cos (0 : Float))
  let v712 := (-v683)
  let v713 := (Float.sin (0 : Float))
  let v716 := (-v708)
  let v725 := (Float.sqrt (((((v708 * v710) + (v712 * v713)) - v707) ^ 2) + ((((v716 * v713) + (v712 * v710)) - (0.34 : Float)) ^ 2)))
  let v726 := (Float.cos v706)
  let v728 := (Float.sin v706)
  let v739 := (Float.sqrt (((((v708 * v726) + (v712 * v728)) - v707) ^ 2) + ((((v716 * v728) + (v712 * v726)) - (0.34 : Float)) ^ 2)))
  let v740 := (Float.cos t)
  let v742 := (Float.sin t)
  let v744 := ((v708 * v740) + (v712 * v742))
  let v747 := ((v716 * v742) + (v712 * v740))
  let v753 := (Float.sqrt (((v744 - v707) ^ 2) + ((v747 - (0.34 : Float)) ^ 2)))
  let v755 := (omegad * rDrum)
  let v757 := ((v753 + slack) - (v755 * dt))
  let v758 := (v757 < v739)
  let v759 := (v725 < v757)
  let v761 := (if v758 then v739 else (if v759 then v725 else v757))
  let v766 := (((0 : Float) + v706) / (2 : Float))
  let v767 := (Float.cos v766)
  let v769 := (Float.sin v766)
  let v781 := (v761 < (Float.sqrt (((((v708 * v767) + (v712 * v769)) - v707) ^ 2) + ((((v716 * v769) + (v712 * v767)) - (0.34 : Float)) ^ 2))))
  let v782 := (if v781 then v766 else (0 : Float))
  let v783 := (if v781 then v706 else v766)
  let v785 := ((v782 + v783) / (2 : Float))
  let v786 := (Float.cos v785)
  let v788 := (Float.sin v785)
  let v800 := (v761 < (Float.sqrt (((((v708 * v786) + (v712 * v788)) - v707) ^ 2) + ((((v716 * v788) + (v712 * v786)) - (0.34 : Float)) ^ 2))))
  let v801 := (if v800 then v785 else v782)
  let v802 := (if v800 then v783 else v785)
  let v804 := ((v801 + v802) / (2 : Float))
  let v805 := (Float.cos v804)
  let v807 := (Float.sin v804)
  let v819 := (v761 < (Float.sqrt (((((v708 * v805) + (v712 * v807)) - v707) ^ 2) + ((((v716 * v807) + (v712 * v805)) - (0.34 : Float)) ^ 2))))
  let v820 := (if v819 then v804 else v801)
  let v821 := (if v819 then v802 else v804)
  let v823 := ((v820 + v821) / (2 : Float))
  let v824 := (Float.cos v823)
  let v826 := (Float.sin v823)
  let v838 := (v761 < (Float.sqrt (((((v708 * v824) + (v712 * v826)) - v707) ^ 2) + ((((v716 * v826) + (v712 * v824)) - (0.34 : Float)) ^ 2))))
  let v839 := (if v838 then v823 else v820)
  let v840 := (if v838 then v821 else v823)
  let v842 := ((v839 + v840) / (2 : Float))
  let v843 := (Float.cos v842)
  let v845 := (Float.sin v842)
  let v857 := (v761 < (Float.sqrt (((((v708 * v843) + (v712 * v845)) - v707) ^ 2) + ((((v716 * v845) + (v712 * v843)) - (0.34 : Float)) ^ 2))))
  let v858 := (if v857 then v842 else v839)
  let v859 := (if v857 then v840 else v842)
  let v861 := ((v858 + v859) / (2 : Float))
  let v862 := (Float.cos v861)
  let v864 := (Float.sin v861)
  let v876 := (v761 < (Float.sqrt (((((v708 * v862) + (v712 * v864)) - v707) ^ 2) + ((((v716 * v864) + (v712 * v862)) - (0.34 : Float)) ^ 2))))
  let v877 := (if v876 then v861 else v858)
  let v878 := (if v876 then v859 else v861)
  let v880 := ((v877 + v878) / (2 : Float))
  let v881 := (Float.cos v880)
  let v883 := (Float.sin v880)
  let v895 := (v761 < (Float.sqrt (((((v708 * v881) + (v712 * v883)) - v707) ^ 2) + ((((v716 * v883) + (v712 * v881)) - (0.34 : Float)) ^ 2))))
  let v896 := (if v895 then v880 else v877)
  let v897 := (if v895 then v878 else v880)
  let v899 := ((v896 + v897) / (2 : Float))
  let v900 := (Float.cos v899)
  let v902 := (Float.sin v899)
  let v914 := (v761 < (Float.sqrt (((((v708 * v900) + (v712 * v902)) - v707) ^ 2) + ((((v716 * v902) + (v712 * v900)) - (0.34 : Float)) ^ 2))))
  let v915 := (if v914 then v899 else v896)
  let v916 := (if v914 then v897 else v899)
  let v918 := ((v915 + v916) / (2 : Float))
  let v919 := (Float.cos v918)
  let v921 := (Float.sin v918)
  let v933 := (v761 < (Float.sqrt (((((v708 * v919) + (v712 * v921)) - v707) ^ 2) + ((((v716 * v921) + (v712 * v919)) - (0.34 : Float)) ^ 2))))
  let v934 := (if v933 then v918 else v915)
  let v935 := (if v933 then v916 else v918)
  let v937 := ((v934 + v935) / (2 : Float))
  let v938 := (Float.cos v937)
  let v940 := (Float.sin v937)
  let v952 := (v761 < (Float.sqrt (((((v708 * v938) + (v712 * v940)) - v707) ^ 2) + ((((v716 * v940) + (v712 * v938)) - (0.34 : Float)) ^ 2))))
  let v953 := (if v952 then v937 else v934)
  let v954 := (if v952 then v935 else v937)
  let v956 := ((v953 + v954) / (2 : Float))
  let v957 := (Float.cos v956)
  let v959 := (Float.sin v956)
  let v971 := (v761 < (Float.sqrt (((((v708 * v957) + (v712 * v959)) - v707) ^ 2) + ((((v716 * v959) + (v712 * v957)) - (0.34 : Float)) ^ 2))))
  let v972 := (if v971 then v956 else v953)
  let v973 := (if v971 then v954 else v956)
  let v975 := ((v972 + v973) / (2 : Float))
  let v976 := (Float.cos v975)
  let v978 := (Float.sin v975)
  let v990 := (v761 < (Float.sqrt (((((v708 * v976) + (v712 * v978)) - v707) ^ 2) + ((((v716 * v978) + (v712 * v976)) - (0.34 : Float)) ^ 2))))
  let v991 := (if v990 then v975 else v972)
  let v992 := (if v990 then v973 else v975)
  let v994 := ((v991 + v992) / (2 : Float))
  let v995 := (Float.cos v994)
  let v997 := (Float.sin v994)
  let v1009 := (v761 < (Float.sqrt (((((v708 * v995) + (v712 * v997)) - v707) ^ 2) + ((((v716 * v997) + (v712 * v995)) - (0.34 : Float)) ^ 2))))
  let v1010 := (if v1009 then v994 else v991)
  let v1011 := (if v1009 then v992 else v994)
  let v1013 := ((v1010 + v1011) / (2 : Float))
  let v1014 := (Float.cos v1013)
  let v1016 := (Float.sin v1013)
  let v1028 := (v761 < (Float.sqrt (((((v708 * v1014) + (v712 * v1016)) - v707) ^ 2) + ((((v716 * v1016) + (v712 * v1014)) - (0.34 : Float)) ^ 2))))
  let v1029 := (if v1028 then v1013 else v1010)
  let v1030 := (if v1028 then v1011 else v1013)
  let v1032 := ((v1029 + v1030) / (2 : Float))
  let v1033 := (Float.cos v1032)
  let v1035 := (Float.sin v1032)
  let v1047 := (v761 < (Float.sqrt (((((v708 * v1033) + (v712 * v1035)) - v707) ^ 2) + ((((v716 * v1035) + (v712 * v1033)) - (0.34 : Float)) ^ 2))))
  let v1048 := (if v1047 then v1032 else v1029)
  let v1049 := (if v1047 then v1030 else v1032)
  let v1051 := ((v1048 + v1049) / (2 : Float))
  let v1052 := (Float.cos v1051)
  let v1054 := (Float.sin v1051)
  let v1066 := (v761 < (Float.sqrt (((((v708 * v1052) + (v712 * v1054)) - v707) ^ 2) + ((((v716 * v1054) + (v712 * v1052)) - (0.34 : Float)) ^ 2))))
  let v1067 := (if v1066 then v1051 else v1048)
  let v1068 := (if v1066 then v1049 else v1051)
  let v1070 := ((v1067 + v1068) / (2 : Float))
  let v1071 := (Float.cos v1070)
  let v1073 := (Float.sin v1070)
  let v1085 := (v761 < (Float.sqrt (((((v708 * v1071) + (v712 * v1073)) - v707) ^ 2) + ((((v716 * v1073) + (v712 * v1071)) - (0.34 : Float)) ^ 2))))
  let v1086 := (if v1085 then v1070 else v1067)
  let v1087 := (if v1085 then v1068 else v1070)
  let v1089 := ((v1086 + v1087) / (2 : Float))
  let v1090 := (Float.cos v1089)
  let v1092 := (Float.sin v1089)
  let v1104 := (v761 < (Float.sqrt (((((v708 * v1090) + (v712 * v1092)) - v707) ^ 2) + ((((v716 * v1092) + (v712 * v1090)) - (0.34 : Float)) ^ 2))))
  let v1105 := (if v1104 then v1089 else v1086)
  let v1106 := (if v1104 then v1087 else v1089)
  let v1108 := ((v1105 + v1106) / (2 : Float))
  let v1109 := (Float.cos v1108)
  let v1111 := (Float.sin v1108)
  let v1123 := (v761 < (Float.sqrt (((((v708 * v1109) + (v712 * v1111)) - v707) ^ 2) + ((((v716 * v1111) + (v712 * v1109)) - (0.34 : Float)) ^ 2))))
  let v1124 := (if v1123 then v1108 else v1105)
  let v1125 := (if v1123 then v1106 else v1108)
  let v1127 := ((v1124 + v1125) / (2 : Float))
  let v1128 := (Float.cos v1127)
  let v1130 := (Float.sin v1127)
  let v1142 := (v761 < (Float.sqrt (((((v708 * v1128) + (v712 * v1130)) - v707) ^ 2) + ((((v716 * v1130) + (v712 * v1128)) - (0.34 : Float)) ^ 2))))
  let v1143 := (if v1142 then v1127 else v1124)
  let v1144 := (if v1142 then v1125 else v1127)
  let v1146 := ((v1143 + v1144) / (2 : Float))
  let v1147 := (Float.cos v1146)
  let v1149 := (Float.sin v1146)
  let v1161 := (v761 < (Float.sqrt (((((v708 * v1147) + (v712 * v1149)) - v707) ^ 2) + ((((v716 * v1149) + (v712 * v1147)) - (0.34 : Float)) ^ 2))))
  let v1162 := (if v1161 then v1146 else v1143)
  let v1163 := (if v1161 then v1144 else v1146)
  let v1165 := ((v1162 + v1163) / (2 : Float))
  let v1166 := (Float.cos v1165)
  let v1168 := (Float.sin v1165)
  let v1180 := (v761 < (Float.sqrt (((((v708 * v1166) + (v712 * v1168)) - v707) ^ 2) + ((((v716 * v1168) + (v712 * v1166)) - (0.34 : Float)) ^ 2))))
  let v1181 := (if v1180 then v1165 else v1162)
  let v1182 := (if v1180 then v1163 else v1165)
  let v1184 := ((v1181 + v1182) / (2 : Float))
  let v1185 := (Float.cos v1184)
  let v1187 := (Float.sin v1184)
  let v1199 := (v761 < (Float.sqrt (((((v708 * v1185) + (v712 * v1187)) - v707) ^ 2) + ((((v716 * v1187) + (v712 * v1185)) - (0.34 : Float)) ^ 2))))
  let v1200 := (if v1199 then v1184 else v1181)
  let v1201 := (if v1199 then v1182 else v1184)
  let v1203 := ((v1200 + v1201) / (2 : Float))
  let v1204 := (Float.cos v1203)
  let v1206 := (Float.sin v1203)
  let v1218 := (v761 < (Float.sqrt (((((v708 * v1204) + (v712 * v1206)) - v707) ^ 2) + ((((v716 * v1206) + (v712 * v1204)) - (0.34 : Float)) ^ 2))))
  let v1223 := (if (v725 <= v757) then (0 : Float) else (((if v1218 then v1203 else v1200) + (if v1218 then v1201 else v1203)) / (2 : Float)))
  let v1224 := (W * rcm)
  let v1225 := (Float.cos v1223)
  let v1227 := (Float.sin v1223)
  let v1229 := ((v708 * v1225) + (v712 * v1227))
  let v1232 := ((v716 * v1227) + (v712 * v1225))
  let v1247 := ((t < v1223) && (!(v1224 <= (Tmax * (((v707 * v1232) - ((0.34 : Float) * v1229)) / (Float.sqrt (((v1229 - v707) ^ 2) + ((v1232 - (0.34 : Float)) ^ 2))))))))
  let v1248 := (if v1247 then t else v1223)
  let v1253 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1258 := (Float.cos v1248)
  let v1260 := (Float.sin v1248)
  let v1262 := ((v708 * v1258) + (v712 * v1260))
  let v1265 := ((v716 * v1260) + (v712 * v1258))
  let v1285 := (v742 * (Float.cos az))
  let v1287 := (v742 * (Float.sin az))
  let v1288 := (Float.cos elSun)
  let v1290 := (v1288 * (Float.cos azSun))
  let v1292 := (v1288 * (Float.sin azSun))
  let v1293 := (Float.sin elSun)
  let v1298 := (((v1285 * v1290) + (v1287 * v1292)) + (v740 * v1293))
  let v1313 := (Float.sqrt (((((v1287 * v1293) - (v740 * v1292)) ^ 2) + (((v740 * v1290) - (v1285 * v1293)) ^ 2)) + (((v1285 * v1292) - (v1287 * v1290)) ^ 2)))
  let v1323 := (if (v1298 <= (0 : Float)) then (v699 + (Float.atan ((-v1298) / (max v1313 (0.000000000001 : Float))))) else (Float.atan (v1313 / v1298)))
  let v1325 := (v699 - v706)
  let v1326 := (v1325 <= elSun)
  let v1340 := (Float.cos v1253)
  let v1341 := (v1260 * v1340)
  let v1342 := (Float.sin v1253)
  let v1343 := (v1260 * v1342)
  let v1344 := (v1258 * v1340)
  let v1345 := (v1258 * v1342)
  let v1346 := (-v1260)
  let v1371 := ((2 : Float) * a)
  let v1372 := (v1371 / w)
  let v1374 := (w / (2 : Float))
  let v1375 := ((-a) + v1374)
  let v1394 := ((1 : Float) / (2 : Float))
  let v1399 := (-(((((v1345 * v1258) - (v1346 * v1343)) * v1290) + (((v1346 * v1341) - (v1344 * v1258)) * v1292)) + (((v1344 * v1343) - (v1345 * v1341)) * v1293)))
  let v1400 := (-(((v1344 * v1290) + (v1345 * v1292)) + (v1346 * v1293)))
  let v1401 := (-(((v1341 * v1290) + (v1343 * v1292)) + (v1258 * v1293)))
  let v1406 := ((Float.abs v1401) < ((9 : Float) / (10 : Float)))
  let v1407 := (if v1406 then (0 : Float) else (1 : Float))
  let v1408 := (if v1406 then (1 : Float) else (0 : Float))
  let v1411 := ((v1400 * v1408) - (v1401 * (0 : Float)))
  let v1414 := ((v1401 * v1407) - (v1399 * v1408))
  let v1417 := ((v1399 * (0 : Float)) - (v1400 * v1407))
  let v1425 := (Float.sqrt (max (((v1411 ^ 2) + (v1414 ^ 2)) + (v1417 ^ 2)) (0.000000000000000001 : Float)))
  let v1426 := (v1411 / v1425)
  let v1427 := (v1414 / v1425)
  let v1428 := (v1417 / v1425)
  let v1440 := ((2 : Float) * (3.141592653589793 : Float))
  let v1477 := ((2 : Float) * f)
  let v1478 := ((1 : Float) / R)
  let v1486 := ((1 : Float) + k)
  let v1569 := (v1248 + beta)
  let v1570 := (Float.sin v1569)
  let v1572 := (-(Float.cos v1569))
  let v1573 := (L / (2 : Float))
  let v1576 := ((v1573 - dm) ^ 2)
  let v1577 := ((v1573 ^ 2) - v1576)
  let v1578 := (v1570 * v1573)
  let v1579 := ((0 : Float) * v1573)
  let v1581 := (f + (v1572 * v1573))
  let v1599 := (((1 : Float) / v1576) + ((1 : Float) / v1577))
  let v1778 := (v1570 * L)
  let v1779 := ((0 : Float) * L)
  let v1781 := (f + (v1572 * L))
  let v1827 := ((List.range 64).foldl (fun acc i => acc + (let v1389 := (v1375 + (w * (Float.floor (dr[i * 10 + 0]! * v1372)))); let v1393 := (v1375 + (w * (Float.floor (dr[i * 10 + 1]! * v1372)))); let v1396 := ((dr[i * 10 + 2]! - v1394) * w); let v1398 := ((dr[i * 10 + 3]! - v1394) * w); let v1439 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1441 := (v1440 * dr[i * 10 + 5]!); let v1442 := (Float.cos v1439); let v1444 := (Float.sin v1439); let v1445 := (Float.cos v1441); let v1447 := (Float.sin v1441); let v1451 := ((v1442 * v1399) + (v1444 * ((v1445 * v1426) + (v1447 * ((v1400 * v1428) - (v1401 * v1427)))))); let v1457 := ((v1442 * v1400) + (v1444 * ((v1445 * v1427) + (v1447 * ((v1401 * v1426) - (v1399 * v1428)))))); let v1463 := ((v1442 * v1401) + (v1444 * ((v1445 * v1428) + (v1447 * ((v1399 * v1427) - (v1400 * v1426)))))); let v1475 := (v1389 + v1396); let v1476 := (v1393 + v1398); let v1483 := (Float.sqrt (max ((v1389 ^ 2) + (v1393 ^ 2)) (0.000000000000000001 : Float))); let v1484 := (v1483 ^ 2); let v1490 := ((1 : Float) - ((v1486 * (v1478 ^ 2)) * v1484)); let v1498 := ((v1478 * v1483) / (Float.sqrt (max v1490 (0.000000000000000001 : Float)))); let v1501 := (Float.sqrt ((1 : Float) + (v1498 ^ 2))); let v1502 := (-v1498); let v1505 := (((v1502 * v1389) / v1483) / v1501); let v1508 := (((v1502 * v1393) / v1483) / v1501); let v1509 := ((1 : Float) / v1501); let v1511 := (v1505 + (sigmaslope * dr[i * 10 + 6]!)); let v1513 := (v1508 + (sigmaslope * dr[i * 10 + 7]!)); let v1519 := (Float.sqrt (((v1511 ^ 2) + (v1513 ^ 2)) + (v1509 ^ 2))); let v1520 := (v1511 / v1519); let v1521 := (v1513 / v1519); let v1522 := (v1509 / v1519); let v1536 := (((((v1389 - v1475) * v1505) + ((v1393 - v1476) * v1508)) + ((((v1478 * v1484) / ((1 : Float) + (Float.sqrt (max v1490 (0 : Float))))) - v1477) * v1509)) / (((v1451 * v1505) + (v1457 * v1508)) + (v1463 * v1509))); let v1538 := (v1475 + (v1536 * v1451)); let v1540 := (v1476 + (v1536 * v1457)); let v1542 := (v1477 + (v1536 * v1463)); let v1548 := ((2 : Float) * (((v1451 * v1520) + (v1457 * v1521)) + (v1463 * v1522))); let v1554 := (v1463 - (v1548 * v1522)); let v1556 := ((v1451 - (v1548 * v1520)) + (sigmaspec * dr[i * 10 + 8]!)); let v1558 := ((v1457 - (v1548 * v1521)) + (sigmaspec * dr[i * 10 + 9]!)); let v1564 := (Float.sqrt (((v1556 ^ 2) + (v1558 ^ 2)) + (v1554 ^ 2))); let v1565 := (v1556 / v1564); let v1566 := (v1558 / v1564); let v1567 := (v1554 / v1564); let v1582 := (v1538 - v1578); let v1583 := (v1540 - v1579); let v1584 := (v1542 - v1581); let v1590 := (-(((v1582 * v1570) + (v1583 * (0 : Float))) + (v1584 * v1572))); let v1596 := (-(((v1565 * v1570) + (v1566 * (0 : Float))) + (v1567 * v1572))); let v1608 := (((v1596 ^ 2) * v1599) - ((((v1565 * v1565) + (v1566 * v1566)) + (v1567 * v1567)) / v1577)); let v1619 := (((((2 : Float) * v1590) * v1596) * v1599) - (((2 : Float) * (((v1582 * v1565) + (v1583 * v1566)) + (v1584 * v1567))) / v1577)); let v1636 := (Float.sqrt (max ((v1619 ^ 2) - (((4 : Float) * v1608) * ((((v1590 ^ 2) * v1599) - ((((v1582 * v1582) + (v1583 * v1583)) + (v1584 * v1584)) / v1577)) - (1 : Float)))) (0 : Float))); let v1637 := (-v1619); let v1639 := ((2 : Float) * v1608); let v1640 := ((v1637 - v1636) / v1639); let v1642 := ((v1637 + v1636) / v1639); let v1648 := ((v1640 > (0.000001 : Float)) && ((v1590 + (v1640 * v1596)) > (0 : Float))); let v1653 := ((v1642 > (0.000001 : Float)) && ((v1590 + (v1642 * v1596)) > (0 : Float))); let v1659 := (if (v1648 && v1653) then (min v1640 v1642) else (if v1648 then v1640 else (if v1653 then v1642 else (-(1 : Float))))); let v1661 := (v1538 + (v1659 * v1565)); let v1663 := (v1540 + (v1659 * v1566)); let v1665 := (v1542 + (v1659 * v1567)); let v1667 := (v1590 + (v1659 * v1596)); let v1670 := ((v1661 - v1578) + (v1667 * v1570)); let v1673 := ((v1663 - v1579) + (v1667 * (0 : Float))); let v1676 := ((v1665 - v1581) + (v1667 * v1572)); let v1685 := (-(v1667 / v1576)); let v1688 := ((v1685 * v1570) - (v1670 / v1577)); let v1691 := ((v1685 * (0 : Float)) - (v1673 / v1577)); let v1694 := ((v1685 * v1572) - (v1676 / v1577)); let v1701 := (Float.sqrt (max (((v1688 * v1688) + (v1691 * v1691)) + (v1694 * v1694)) (0.000000000000000001 : Float))); let v1702 := (v1688 / v1701); let v1703 := (v1691 / v1701); let v1704 := (v1694 / v1701); let v1716 := ((2 : Float) * (((v1565 * v1702) + (v1566 * v1703)) + (v1567 * v1704))); let v1718 := (v1565 - (v1716 * v1702)); let v1720 := (v1566 - (v1716 * v1703)); let v1722 := (v1567 - (v1716 * v1704)); let v1739 := ((((2 : Float) * v1478) * (((v1661 * v1718) + (v1663 * v1720)) + ((v1486 * v1665) * v1722))) - ((2 : Float) * v1722)); let v1748 := ((v1478 * (((v1661 ^ 2) + (v1663 ^ 2)) + (v1486 * (v1665 ^ 2)))) - ((2 : Float) * v1665)); let v1758 := (((2 : Float) * v1748) / ((-v1739) - (Float.sqrt (max ((v1739 ^ 2) - (((4 : Float) * (v1478 * (((v1718 ^ 2) + (v1720 ^ 2)) + (v1486 * (v1722 ^ 2))))) * v1748)) (0 : Float))))); let v1760 := (v1661 + (v1758 * v1718)); let v1767 := (Float.abs (v1663 + (v1758 * v1720))); let v1795 := (((((v1778 - v1661) * v1570) + ((v1779 - v1663) * (0 : Float))) + ((v1781 - v1665) * v1572)) / (((v1718 * v1570) + (v1720 * (0 : Float))) + (v1722 * v1572))); (if ((((if (((Float.abs v1389) <= a) && (((Float.abs v1393) <= a) && (((Float.abs v1396) <= v1374) && ((Float.abs v1398) <= v1374)))) then (1 : Float) else (0 : Float)) > (0.5 : Float)) && ((v1659 > (0 : Float)) && ((Float.sqrt (max (((v1670 * v1670) + (v1673 * v1673)) + (v1676 * v1676)) (0.000000000000000001 : Float))) <= rm))) && ((!(v1758 > (0 : Float)) || ((!(((Float.abs v1760) <= a) && (v1767 <= a))) || ((v1767 <= (slotW / (2 : Float))) && (v1760 >= (0 : Float))))) && (((Float.sqrt (((((v1661 + (v1795 * v1718)) - v1778) ^ 2) + (((v1663 + (v1795 * v1720)) - v1779) ^ 2)) + (((v1665 + (v1795 * v1722)) - v1781) ^ 2))) <= rt) && (v1795 > (0 : Float))))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1830 := ((List.range 64).foldl (fun acc i => acc + (let v1389 := (v1375 + (w * (Float.floor (dr[i * 10 + 0]! * v1372)))); let v1393 := (v1375 + (w * (Float.floor (dr[i * 10 + 1]! * v1372)))); let v1396 := ((dr[i * 10 + 2]! - v1394) * w); let v1398 := ((dr[i * 10 + 3]! - v1394) * w); let v1439 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1441 := (v1440 * dr[i * 10 + 5]!); let v1442 := (Float.cos v1439); let v1444 := (Float.sin v1439); let v1445 := (Float.cos v1441); let v1447 := (Float.sin v1441); let v1451 := ((v1442 * v1399) + (v1444 * ((v1445 * v1426) + (v1447 * ((v1400 * v1428) - (v1401 * v1427)))))); let v1457 := ((v1442 * v1400) + (v1444 * ((v1445 * v1427) + (v1447 * ((v1401 * v1426) - (v1399 * v1428)))))); let v1463 := ((v1442 * v1401) + (v1444 * ((v1445 * v1428) + (v1447 * ((v1399 * v1427) - (v1400 * v1426)))))); let v1475 := (v1389 + v1396); let v1476 := (v1393 + v1398); let v1483 := (Float.sqrt (max ((v1389 ^ 2) + (v1393 ^ 2)) (0.000000000000000001 : Float))); let v1484 := (v1483 ^ 2); let v1490 := ((1 : Float) - ((v1486 * (v1478 ^ 2)) * v1484)); let v1498 := ((v1478 * v1483) / (Float.sqrt (max v1490 (0.000000000000000001 : Float)))); let v1501 := (Float.sqrt ((1 : Float) + (v1498 ^ 2))); let v1502 := (-v1498); let v1505 := (((v1502 * v1389) / v1483) / v1501); let v1508 := (((v1502 * v1393) / v1483) / v1501); let v1509 := ((1 : Float) / v1501); let v1511 := (v1505 + (sigmaslope * dr[i * 10 + 6]!)); let v1513 := (v1508 + (sigmaslope * dr[i * 10 + 7]!)); let v1519 := (Float.sqrt (((v1511 ^ 2) + (v1513 ^ 2)) + (v1509 ^ 2))); let v1520 := (v1511 / v1519); let v1521 := (v1513 / v1519); let v1522 := (v1509 / v1519); let v1536 := (((((v1389 - v1475) * v1505) + ((v1393 - v1476) * v1508)) + ((((v1478 * v1484) / ((1 : Float) + (Float.sqrt (max v1490 (0 : Float))))) - v1477) * v1509)) / (((v1451 * v1505) + (v1457 * v1508)) + (v1463 * v1509))); let v1538 := (v1475 + (v1536 * v1451)); let v1540 := (v1476 + (v1536 * v1457)); let v1542 := (v1477 + (v1536 * v1463)); let v1548 := ((2 : Float) * (((v1451 * v1520) + (v1457 * v1521)) + (v1463 * v1522))); let v1554 := (v1463 - (v1548 * v1522)); let v1556 := ((v1451 - (v1548 * v1520)) + (sigmaspec * dr[i * 10 + 8]!)); let v1558 := ((v1457 - (v1548 * v1521)) + (sigmaspec * dr[i * 10 + 9]!)); let v1564 := (Float.sqrt (((v1556 ^ 2) + (v1558 ^ 2)) + (v1554 ^ 2))); let v1565 := (v1556 / v1564); let v1566 := (v1558 / v1564); let v1567 := (v1554 / v1564); let v1582 := (v1538 - v1578); let v1583 := (v1540 - v1579); let v1584 := (v1542 - v1581); let v1590 := (-(((v1582 * v1570) + (v1583 * (0 : Float))) + (v1584 * v1572))); let v1596 := (-(((v1565 * v1570) + (v1566 * (0 : Float))) + (v1567 * v1572))); let v1608 := (((v1596 ^ 2) * v1599) - ((((v1565 * v1565) + (v1566 * v1566)) + (v1567 * v1567)) / v1577)); let v1619 := (((((2 : Float) * v1590) * v1596) * v1599) - (((2 : Float) * (((v1582 * v1565) + (v1583 * v1566)) + (v1584 * v1567))) / v1577)); let v1636 := (Float.sqrt (max ((v1619 ^ 2) - (((4 : Float) * v1608) * ((((v1590 ^ 2) * v1599) - ((((v1582 * v1582) + (v1583 * v1583)) + (v1584 * v1584)) / v1577)) - (1 : Float)))) (0 : Float))); let v1637 := (-v1619); let v1639 := ((2 : Float) * v1608); let v1640 := ((v1637 - v1636) / v1639); let v1642 := ((v1637 + v1636) / v1639); let v1648 := ((v1640 > (0.000001 : Float)) && ((v1590 + (v1640 * v1596)) > (0 : Float))); let v1653 := ((v1642 > (0.000001 : Float)) && ((v1590 + (v1642 * v1596)) > (0 : Float))); let v1659 := (if (v1648 && v1653) then (min v1640 v1642) else (if v1648 then v1640 else (if v1653 then v1642 else (-(1 : Float))))); let v1667 := (v1590 + (v1659 * v1596)); let v1670 := (((v1538 + (v1659 * v1565)) - v1578) + (v1667 * v1570)); let v1673 := (((v1540 + (v1659 * v1566)) - v1579) + (v1667 * (0 : Float))); let v1676 := (((v1542 + (v1659 * v1567)) - v1581) + (v1667 * v1572)); (if (((if (((Float.abs v1389) <= a) && (((Float.abs v1393) <= a) && (((Float.abs v1396) <= v1374) && ((Float.abs v1398) <= v1374)))) then (1 : Float) else (0 : Float)) > (0.5 : Float)) && ((v1659 > (0 : Float)) && ((Float.sqrt (max (((v1670 * v1670) + (v1673 * v1673)) + (v1676 * v1676)) (0.000000000000000001 : Float))) <= rm))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1832 := ((List.range 64).foldl (fun acc i => acc + (let v1389 := (v1375 + (w * (Float.floor (dr[i * 10 + 0]! * v1372)))); let v1393 := (v1375 + (w * (Float.floor (dr[i * 10 + 1]! * v1372)))); let v1396 := ((dr[i * 10 + 2]! - v1394) * w); let v1398 := ((dr[i * 10 + 3]! - v1394) * w); let v1439 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1441 := (v1440 * dr[i * 10 + 5]!); let v1442 := (Float.cos v1439); let v1444 := (Float.sin v1439); let v1445 := (Float.cos v1441); let v1447 := (Float.sin v1441); let v1451 := ((v1442 * v1399) + (v1444 * ((v1445 * v1426) + (v1447 * ((v1400 * v1428) - (v1401 * v1427)))))); let v1457 := ((v1442 * v1400) + (v1444 * ((v1445 * v1427) + (v1447 * ((v1401 * v1426) - (v1399 * v1428)))))); let v1463 := ((v1442 * v1401) + (v1444 * ((v1445 * v1428) + (v1447 * ((v1399 * v1427) - (v1400 * v1426)))))); let v1475 := (v1389 + v1396); let v1476 := (v1393 + v1398); let v1483 := (Float.sqrt (max ((v1389 ^ 2) + (v1393 ^ 2)) (0.000000000000000001 : Float))); let v1484 := (v1483 ^ 2); let v1490 := ((1 : Float) - ((v1486 * (v1478 ^ 2)) * v1484)); let v1498 := ((v1478 * v1483) / (Float.sqrt (max v1490 (0.000000000000000001 : Float)))); let v1501 := (Float.sqrt ((1 : Float) + (v1498 ^ 2))); let v1502 := (-v1498); let v1505 := (((v1502 * v1389) / v1483) / v1501); let v1508 := (((v1502 * v1393) / v1483) / v1501); let v1509 := ((1 : Float) / v1501); let v1511 := (v1505 + (sigmaslope * dr[i * 10 + 6]!)); let v1513 := (v1508 + (sigmaslope * dr[i * 10 + 7]!)); let v1519 := (Float.sqrt (((v1511 ^ 2) + (v1513 ^ 2)) + (v1509 ^ 2))); let v1520 := (v1511 / v1519); let v1521 := (v1513 / v1519); let v1522 := (v1509 / v1519); let v1536 := (((((v1389 - v1475) * v1505) + ((v1393 - v1476) * v1508)) + ((((v1478 * v1484) / ((1 : Float) + (Float.sqrt (max v1490 (0 : Float))))) - v1477) * v1509)) / (((v1451 * v1505) + (v1457 * v1508)) + (v1463 * v1509))); let v1538 := (v1475 + (v1536 * v1451)); let v1540 := (v1476 + (v1536 * v1457)); let v1542 := (v1477 + (v1536 * v1463)); let v1548 := ((2 : Float) * (((v1451 * v1520) + (v1457 * v1521)) + (v1463 * v1522))); let v1554 := (v1463 - (v1548 * v1522)); let v1556 := ((v1451 - (v1548 * v1520)) + (sigmaspec * dr[i * 10 + 8]!)); let v1558 := ((v1457 - (v1548 * v1521)) + (sigmaspec * dr[i * 10 + 9]!)); let v1564 := (Float.sqrt (((v1556 ^ 2) + (v1558 ^ 2)) + (v1554 ^ 2))); let v1565 := (v1556 / v1564); let v1566 := (v1558 / v1564); let v1567 := (v1554 / v1564); let v1582 := (v1538 - v1578); let v1583 := (v1540 - v1579); let v1584 := (v1542 - v1581); let v1590 := (-(((v1582 * v1570) + (v1583 * (0 : Float))) + (v1584 * v1572))); let v1596 := (-(((v1565 * v1570) + (v1566 * (0 : Float))) + (v1567 * v1572))); let v1608 := (((v1596 ^ 2) * v1599) - ((((v1565 * v1565) + (v1566 * v1566)) + (v1567 * v1567)) / v1577)); let v1619 := (((((2 : Float) * v1590) * v1596) * v1599) - (((2 : Float) * (((v1582 * v1565) + (v1583 * v1566)) + (v1584 * v1567))) / v1577)); let v1636 := (Float.sqrt (max ((v1619 ^ 2) - (((4 : Float) * v1608) * ((((v1590 ^ 2) * v1599) - ((((v1582 * v1582) + (v1583 * v1583)) + (v1584 * v1584)) / v1577)) - (1 : Float)))) (0 : Float))); let v1637 := (-v1619); let v1639 := ((2 : Float) * v1608); let v1640 := ((v1637 - v1636) / v1639); let v1642 := ((v1637 + v1636) / v1639); let v1648 := ((v1640 > (0.000001 : Float)) && ((v1590 + (v1640 * v1596)) > (0 : Float))); let v1653 := ((v1642 > (0.000001 : Float)) && ((v1590 + (v1642 * v1596)) > (0 : Float))); let v1659 := (if (v1648 && v1653) then (min v1640 v1642) else (if v1648 then v1640 else (if v1653 then v1642 else (-(1 : Float))))); let v1661 := (v1538 + (v1659 * v1565)); let v1663 := (v1540 + (v1659 * v1566)); let v1665 := (v1542 + (v1659 * v1567)); let v1667 := (v1590 + (v1659 * v1596)); let v1670 := ((v1661 - v1578) + (v1667 * v1570)); let v1673 := ((v1663 - v1579) + (v1667 * (0 : Float))); let v1676 := ((v1665 - v1581) + (v1667 * v1572)); let v1685 := (-(v1667 / v1576)); let v1688 := ((v1685 * v1570) - (v1670 / v1577)); let v1691 := ((v1685 * (0 : Float)) - (v1673 / v1577)); let v1694 := ((v1685 * v1572) - (v1676 / v1577)); let v1701 := (Float.sqrt (max (((v1688 * v1688) + (v1691 * v1691)) + (v1694 * v1694)) (0.000000000000000001 : Float))); let v1702 := (v1688 / v1701); let v1703 := (v1691 / v1701); let v1704 := (v1694 / v1701); let v1716 := ((2 : Float) * (((v1565 * v1702) + (v1566 * v1703)) + (v1567 * v1704))); let v1718 := (v1565 - (v1716 * v1702)); let v1720 := (v1566 - (v1716 * v1703)); let v1722 := (v1567 - (v1716 * v1704)); let v1739 := ((((2 : Float) * v1478) * (((v1661 * v1718) + (v1663 * v1720)) + ((v1486 * v1665) * v1722))) - ((2 : Float) * v1722)); let v1748 := ((v1478 * (((v1661 ^ 2) + (v1663 ^ 2)) + (v1486 * (v1665 ^ 2)))) - ((2 : Float) * v1665)); let v1758 := (((2 : Float) * v1748) / ((-v1739) - (Float.sqrt (max ((v1739 ^ 2) - (((4 : Float) * (v1478 * (((v1718 ^ 2) + (v1720 ^ 2)) + (v1486 * (v1722 ^ 2))))) * v1748)) (0 : Float))))); let v1760 := (v1661 + (v1758 * v1718)); let v1767 := (Float.abs (v1663 + (v1758 * v1720))); (if ((((if (((Float.abs v1389) <= a) && (((Float.abs v1393) <= a) && (((Float.abs v1396) <= v1374) && ((Float.abs v1398) <= v1374)))) then (1 : Float) else (0 : Float)) > (0.5 : Float)) && ((v1659 > (0 : Float)) && ((Float.sqrt (max (((v1670 * v1670) + (v1673 * v1673)) + (v1676 * v1676)) (0.000000000000000001 : Float))) <= rm))) && (!(v1758 > (0 : Float)) || ((!(((Float.abs v1760) <= a) && (v1767 <= a))) || ((v1767 <= (slotW / (2 : Float))) && (v1760 >= (0 : Float)))))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1836 := ((List.range 64).foldl (fun acc i => acc + (let v1389 := (v1375 + (w * (Float.floor (dr[i * 10 + 0]! * v1372)))); let v1393 := (v1375 + (w * (Float.floor (dr[i * 10 + 1]! * v1372)))); let v1396 := ((dr[i * 10 + 2]! - v1394) * w); let v1398 := ((dr[i * 10 + 3]! - v1394) * w); let v1439 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1441 := (v1440 * dr[i * 10 + 5]!); let v1442 := (Float.cos v1439); let v1444 := (Float.sin v1439); let v1445 := (Float.cos v1441); let v1447 := (Float.sin v1441); let v1451 := ((v1442 * v1399) + (v1444 * ((v1445 * v1426) + (v1447 * ((v1400 * v1428) - (v1401 * v1427)))))); let v1457 := ((v1442 * v1400) + (v1444 * ((v1445 * v1427) + (v1447 * ((v1401 * v1426) - (v1399 * v1428)))))); let v1463 := ((v1442 * v1401) + (v1444 * ((v1445 * v1428) + (v1447 * ((v1399 * v1427) - (v1400 * v1426)))))); let v1475 := (v1389 + v1396); let v1476 := (v1393 + v1398); let v1483 := (Float.sqrt (max ((v1389 ^ 2) + (v1393 ^ 2)) (0.000000000000000001 : Float))); let v1484 := (v1483 ^ 2); let v1490 := ((1 : Float) - ((v1486 * (v1478 ^ 2)) * v1484)); let v1498 := ((v1478 * v1483) / (Float.sqrt (max v1490 (0.000000000000000001 : Float)))); let v1501 := (Float.sqrt ((1 : Float) + (v1498 ^ 2))); let v1502 := (-v1498); let v1505 := (((v1502 * v1389) / v1483) / v1501); let v1508 := (((v1502 * v1393) / v1483) / v1501); let v1509 := ((1 : Float) / v1501); let v1511 := (v1505 + (sigmaslope * dr[i * 10 + 6]!)); let v1513 := (v1508 + (sigmaslope * dr[i * 10 + 7]!)); let v1519 := (Float.sqrt (((v1511 ^ 2) + (v1513 ^ 2)) + (v1509 ^ 2))); let v1520 := (v1511 / v1519); let v1521 := (v1513 / v1519); let v1522 := (v1509 / v1519); let v1536 := (((((v1389 - v1475) * v1505) + ((v1393 - v1476) * v1508)) + ((((v1478 * v1484) / ((1 : Float) + (Float.sqrt (max v1490 (0 : Float))))) - v1477) * v1509)) / (((v1451 * v1505) + (v1457 * v1508)) + (v1463 * v1509))); let v1538 := (v1475 + (v1536 * v1451)); let v1540 := (v1476 + (v1536 * v1457)); let v1542 := (v1477 + (v1536 * v1463)); let v1548 := ((2 : Float) * (((v1451 * v1520) + (v1457 * v1521)) + (v1463 * v1522))); let v1554 := (v1463 - (v1548 * v1522)); let v1556 := ((v1451 - (v1548 * v1520)) + (sigmaspec * dr[i * 10 + 8]!)); let v1558 := ((v1457 - (v1548 * v1521)) + (sigmaspec * dr[i * 10 + 9]!)); let v1564 := (Float.sqrt (((v1556 ^ 2) + (v1558 ^ 2)) + (v1554 ^ 2))); let v1565 := (v1556 / v1564); let v1566 := (v1558 / v1564); let v1567 := (v1554 / v1564); let v1582 := (v1538 - v1578); let v1583 := (v1540 - v1579); let v1584 := (v1542 - v1581); let v1590 := (-(((v1582 * v1570) + (v1583 * (0 : Float))) + (v1584 * v1572))); let v1596 := (-(((v1565 * v1570) + (v1566 * (0 : Float))) + (v1567 * v1572))); let v1608 := (((v1596 ^ 2) * v1599) - ((((v1565 * v1565) + (v1566 * v1566)) + (v1567 * v1567)) / v1577)); let v1619 := (((((2 : Float) * v1590) * v1596) * v1599) - (((2 : Float) * (((v1582 * v1565) + (v1583 * v1566)) + (v1584 * v1567))) / v1577)); let v1636 := (Float.sqrt (max ((v1619 ^ 2) - (((4 : Float) * v1608) * ((((v1590 ^ 2) * v1599) - ((((v1582 * v1582) + (v1583 * v1583)) + (v1584 * v1584)) / v1577)) - (1 : Float)))) (0 : Float))); let v1637 := (-v1619); let v1639 := ((2 : Float) * v1608); let v1640 := ((v1637 - v1636) / v1639); let v1642 := ((v1637 + v1636) / v1639); let v1648 := ((v1640 > (0.000001 : Float)) && ((v1590 + (v1640 * v1596)) > (0 : Float))); let v1653 := ((v1642 > (0.000001 : Float)) && ((v1590 + (v1642 * v1596)) > (0 : Float))); let v1659 := (if (v1648 && v1653) then (min v1640 v1642) else (if v1648 then v1640 else (if v1653 then v1642 else (-(1 : Float))))); let v1661 := (v1538 + (v1659 * v1565)); let v1663 := (v1540 + (v1659 * v1566)); let v1665 := (v1542 + (v1659 * v1567)); let v1667 := (v1590 + (v1659 * v1596)); let v1670 := ((v1661 - v1578) + (v1667 * v1570)); let v1673 := ((v1663 - v1579) + (v1667 * (0 : Float))); let v1676 := ((v1665 - v1581) + (v1667 * v1572)); let v1685 := (-(v1667 / v1576)); let v1688 := ((v1685 * v1570) - (v1670 / v1577)); let v1691 := ((v1685 * (0 : Float)) - (v1673 / v1577)); let v1694 := ((v1685 * v1572) - (v1676 / v1577)); let v1701 := (Float.sqrt (max (((v1688 * v1688) + (v1691 * v1691)) + (v1694 * v1694)) (0.000000000000000001 : Float))); let v1702 := (v1688 / v1701); let v1703 := (v1691 / v1701); let v1704 := (v1694 / v1701); let v1716 := ((2 : Float) * (((v1565 * v1702) + (v1566 * v1703)) + (v1567 * v1704))); let v1718 := (v1565 - (v1716 * v1702)); let v1720 := (v1566 - (v1716 * v1703)); let v1722 := (v1567 - (v1716 * v1704)); let v1739 := ((((2 : Float) * v1478) * (((v1661 * v1718) + (v1663 * v1720)) + ((v1486 * v1665) * v1722))) - ((2 : Float) * v1722)); let v1748 := ((v1478 * (((v1661 ^ 2) + (v1663 ^ 2)) + (v1486 * (v1665 ^ 2)))) - ((2 : Float) * v1665)); let v1758 := (((2 : Float) * v1748) / ((-v1739) - (Float.sqrt (max ((v1739 ^ 2) - (((4 : Float) * (v1478 * (((v1718 ^ 2) + (v1720 ^ 2)) + (v1486 * (v1722 ^ 2))))) * v1748)) (0 : Float))))); let v1760 := (v1661 + (v1758 * v1718)); let v1767 := (Float.abs (v1663 + (v1758 * v1720))); let v1795 := (((((v1778 - v1661) * v1570) + ((v1779 - v1663) * (0 : Float))) + ((v1781 - v1665) * v1572)) / (((v1718 * v1570) + (v1720 * (0 : Float))) + (v1722 * v1572))); ((if ((((if (((Float.abs v1389) <= a) && (((Float.abs v1393) <= a) && (((Float.abs v1396) <= v1374) && ((Float.abs v1398) <= v1374)))) then (1 : Float) else (0 : Float)) > (0.5 : Float)) && ((v1659 > (0 : Float)) && ((Float.sqrt (max (((v1670 * v1670) + (v1673 * v1673)) + (v1676 * v1676)) (0.000000000000000001 : Float))) <= rm))) && (!(v1758 > (0 : Float)) || ((!(((Float.abs v1760) <= a) && (v1767 <= a))) || ((v1767 <= (slotW / (2 : Float))) && (v1760 >= (0 : Float)))))) then (1 : Float) else (0 : Float)) * (min (Float.sqrt (((((v1661 + (v1795 * v1718)) - v1778) ^ 2) + (((v1663 + (v1795 * v1720)) - v1779) ^ 2)) + (((v1665 + (v1795 * v1722)) - v1781) ^ 2))) (2 : Float))))) 0.0)
  let v1847 := (azSun - v1253)
  #[v1253, v1248, (if v759 then (v757 - v725) else (0 : Float)), (if v1247 then v753 else v761), v706, (if (v758 || v1247) then (1 : Float) else (0 : Float)), (if (feq (if v759 then (v757 - v725) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1224 <= (Tmax * (((v707 * v1265) - ((0.34 : Float) * v1262)) / (Float.sqrt (((v1262 - v707) ^ 2) + ((v1265 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (((v707 * v747) - ((0.34 : Float) * v744)) / v753), (v755 / (((v707 * v747) - ((0.34 : Float) * v744)) / v753)), ((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))), v1323, (v699 - t), (if v1326 then (1 : Float) else (0 : Float)), (if (v1326 && ((0.03 : Float) < v1323)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1325) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1325) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1323 - (0.03 : Float)) / (0.01 : Float)))))), (v1827 / (64 : Float)), (v1830 / (64 : Float)), (v1832 / (64 : Float)), ((((v1371 ^ 2) * rho) * (v1827 / (64 : Float))) * ((0.94 : Float) * (0.96 : Float))), ((((((v1371 ^ 2) * rho) * (v1827 / (64 : Float))) * ((0.94 : Float) * (0.96 : Float))) * dni) * soil), (v1836 / (64 : Float)), (v1847 - (v1440 * (Float.floor ((v1847 + (3.141592653589793 : Float)) / v1440)))), ((v699 - v1248) - elSun), v1248, (if (feq (if v759 then (v757 - v725) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1224 <= (Tmax * (((v707 * v1265) - ((0.34 : Float) * v1262)) / (Float.sqrt (((v1262 - v707) ^ 2) + ((v1265 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (0 : Float), (1.0 / (1.0 + Float.exp (-((elSun - v1325) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1325) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1323 - (0.03 : Float)) / (0.01 : Float))))))]

#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 0.203211 1.744662 1.686113 1.627564 1.569016 1.510467 1.451918 1.393369 1.334820 1.276272 1.217723 1.159174 1.100625 1.042076 0.983528 0.924979 0.866430 0.807881 0.749332 0.690784 0.632235 0.573686 0.515137 0.456588 0.398040 0.339491 0.280942 0.222393 1.763844 1.705296 1.646747 1.588198 1.529649 #[0.479827, 0.421278, 0.362729, 0.304180, 0.245632, 1.787083, 1.728534, 1.669985, 1.611436, 1.552888, 1.494339, 1.435790, 1.377241, 1.318692, 1.260144, 1.201595, 1.143046, 1.084497, 1.025948, 0.967400, 0.908851, 0.850302, 0.791753, 0.733204, 0.674656, 0.616107, 0.557558, 0.499009, 0.440460, 0.381912, 0.323363, 0.264814, 0.206265, 1.747716, 1.689168, 1.630619, 1.572070, 1.513521, 1.454972, 1.396424, 1.337875, 1.279326, 1.220777, 1.162228, 1.103680, 1.045131, 0.986582, 0.928033, 0.869484, 0.810936, 0.752387, 0.693838, 0.635289, 0.576740, 0.518192, 0.459643, 0.401094, 0.342545, 0.283996, 0.225448, 1.766899, 1.708350, 1.649801, 1.591252, 1.532704, 1.474155, 1.415606, 1.357057, 1.298508, 1.239960, 1.181411, 1.122862, 1.064313, 1.005764, 0.947216, 0.888667, 0.830118, 0.771569, 0.713020, 0.654472, 0.595923, 0.537374, 0.478825, 0.420276, 0.361728, 0.303179, 0.244630, 1.786081, 1.727532, 1.668984, 1.610435, 1.551886, 1.493337, 1.434788, 1.376240, 1.317691, 1.259142, 1.200593, 1.142044, 1.083496, 1.024947, 0.966398, 0.907849, 0.849300, 0.790752, 0.732203, 0.673654, 0.615105, 0.556556, 0.498008, 0.439459, 0.380910, 0.322361, 0.263812, 0.205264, 1.746715, 1.688166, 1.629617, 1.571068, 1.512520, 1.453971, 1.395422, 1.336873, 1.278324, 1.219776, 1.161227, 1.102678, 1.044129, 0.985580, 0.927032, 0.868483, 0.809934, 0.751385, 0.692836, 0.634288, 0.575739, 0.517190, 0.458641, 0.400092, 0.341544, 0.282995, 0.224446, 1.765897, 1.707348, 1.648800, 1.590251, 1.531702, 1.473153, 1.414604, 1.356056, 1.297507, 1.238958, 1.180409, 1.121860, 1.063312, 1.004763, 0.946214, 0.887665, 0.829116, 0.770568, 0.712019, 0.653470, 0.594921, 0.536372, 0.477824, 0.419275, 0.360726, 0.302177, 0.243628, 1.785080, 1.726531, 1.667982, 1.609433, 1.550884, 1.492336, 1.433787, 1.375238, 1.316689, 1.258140, 1.199592, 1.141043, 1.082494, 1.023945, 0.965396, 0.906848, 0.848299, 0.789750, 0.731201, 0.672652, 0.614104, 0.555555, 0.497006, 0.438457, 0.379908, 0.321360, 0.262811, 0.204262, 1.745713, 1.687164, 1.628616, 1.570067, 1.511518, 1.452969, 1.394420, 1.335872, 1.277323, 1.218774, 1.160225, 1.101676, 1.043128, 0.984579, 0.926030, 0.867481, 0.808932, 0.750384, 0.691835, 0.633286, 0.574737, 0.516188, 0.457640, 0.399091, 0.340542, 0.281993, 0.223444, 1.764896, 1.706347, 1.647798, 1.589249, 1.530700, 1.472152, 1.413603, 1.355054, 1.296505, 1.237956, 1.179408, 1.120859, 1.062310, 1.003761, 0.945212, 0.886664, 0.828115, 0.769566, 0.711017, 0.652468, 0.593920, 0.535371, 0.476822, 0.418273, 0.359724, 0.301176, 0.242627, 1.784078, 1.725529, 1.666980, 1.608432, 1.549883, 1.491334, 1.432785, 1.374236, 1.315688, 1.257139, 1.198590, 1.140041, 1.081492, 1.022944, 0.964395, 0.905846, 0.847297, 0.788748, 0.730200, 0.671651, 0.613102, 0.554553, 0.496004, 0.437456, 0.378907, 0.320358, 0.261809, 0.203260, 1.744712, 1.686163, 1.627614, 1.569065, 1.510516, 1.451968, 1.393419, 1.334870, 1.276321, 1.217772, 1.159224, 1.100675, 1.042126, 0.983577, 0.925028, 0.866480, 0.807931, 0.749382, 0.690833, 0.632284, 0.573736, 0.515187, 0.456638, 0.398089, 0.339540, 0.280992, 0.222443, 1.763894, 1.705345, 1.646796, 1.588248, 1.529699, 1.471150, 1.412601, 1.354052, 1.295504, 1.236955, 1.178406, 1.119857, 1.061308, 1.002760, 0.944211, 0.885662, 0.827113, 0.768564, 0.710016, 0.651467, 0.592918, 0.534369, 0.475820, 0.417272, 0.358723, 0.300174, 0.241625, 1.783076, 1.724528, 1.665979, 1.607430, 1.548881, 1.490332, 1.431784, 1.373235, 1.314686, 1.256137, 1.197588, 1.139040, 1.080491, 1.021942, 0.963393, 0.904844, 0.846296, 0.787747, 0.729198, 0.670649, 0.612100, 0.553552, 0.495003, 0.436454, 0.377905, 0.319356, 0.260808, 0.202259, 1.743710, 1.685161, 1.626612, 1.568064, 1.509515, 1.450966, 1.392417, 1.333868, 1.275320, 1.216771, 1.158222, 1.099673, 1.041124, 0.982576, 0.924027, 0.865478, 0.806929, 0.748380, 0.689832, 0.631283, 0.572734, 0.514185, 0.455636, 0.397088, 0.338539, 0.279990, 0.221441, 1.762892, 1.704344, 1.645795, 1.587246, 1.528697, 1.470148, 1.411600, 1.353051, 1.294502, 1.235953, 1.177404, 1.118856, 1.060307, 1.001758, 0.943209, 0.884660, 0.826112, 0.767563, 0.709014, 0.650465, 0.591916, 0.533368, 0.474819, 0.416270, 0.357721, 0.299172, 0.240624, 1.782075, 1.723526, 1.664977, 1.606428, 1.547880, 1.489331, 1.430782, 1.372233, 1.313684, 1.255136, 1.196587, 1.138038, 1.079489, 1.020940, 0.962392, 0.903843, 0.845294, 0.786745, 0.728196, 0.669648, 0.611099, 0.552550, 0.494001, 0.435452, 0.376904, 0.318355, 0.259806, 0.201257, 1.742708, 1.684160, 1.625611, 1.567062, 1.508513, 1.449964, 1.391416, 1.332867, 1.274318, 1.215769, 1.157220, 1.098672, 1.040123, 0.981574, 0.923025, 0.864476, 0.805928, 0.747379, 0.688830, 0.630281, 0.571732, 0.513184, 0.454635, 0.396086, 0.337537, 0.278988, 0.220440, 1.761891, 1.703342, 1.644793, 1.586244, 1.527696, 1.469147, 1.410598, 1.352049, 1.293500, 1.234952, 1.176403, 1.117854, 1.059305, 1.000756, 0.942208, 0.883659, 0.825110, 0.766561, 0.708012, 0.649464, 0.590915, 0.532366, 0.473817, 0.415268, 0.356720, 0.298171, 0.239622, 1.781073, 1.722524, 1.663976, 1.605427, 1.546878, 1.488329, 1.429780, 1.371232, 1.312683, 1.254134, 1.195585, 1.137036, 1.078488, 1.019939, 0.961390, 0.902841, 0.844292, 0.785744, 0.727195, 0.668646, 0.610097, 0.551548, 0.493000, 0.434451, 0.375902, 0.317353, 0.258804, 0.200256, 1.741707, 1.683158, 1.624609, 1.566060, 1.507512, 1.448963, 1.390414, 1.331865, 1.273316, 1.214768, 1.156219, 1.097670, 1.039121, 0.980572, 0.922024, 0.863475, 0.804926, 0.746377, 0.687828, 0.629280, 0.570731, 0.512182, 0.453633, 0.395084, 0.336536, 0.277987, 0.219438, 1.760889, 1.702340, 1.643792, 1.585243, 1.526694, 1.468145, 1.409596, 1.351048, 1.292499, 1.233950, 1.175401, 1.116852, 1.058304, 0.999755, 0.941206, 0.882657, 0.824108, 0.765560, 0.707011, 0.648462, 0.589913, 0.531364, 0.472816, 0.414267, 0.355718, 0.297169, 0.238620, 1.780072, 1.721523, 1.662974, 1.604425, 1.545876, 1.487328, 1.428779, 1.370230, 1.311681, 1.253132, 1.194584, 1.136035, 1.077486, 1.018937, 0.960388, 0.901840, 0.843291, 0.784742, 0.726193, 0.667644, 0.609096, 0.550547, 0.491998, 0.433449, 0.374900, 0.316352, 0.257803, 1.799254, 1.740705, 1.682156, 1.623608, 1.565059, 1.506510, 1.447961, 1.389412, 1.330864, 1.272315, 1.213766, 1.155217, 1.096668, 1.038120, 0.979571, 0.921022, 0.862473, 0.803924, 0.745376, 0.686827, 0.628278, 0.569729, 0.511180, 0.452632, 0.394083, 0.335534, 0.276985, 0.218436, 1.759888, 1.701339, 1.642790, 1.584241, 1.525692, 1.467144]).map Float.toBits))
#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 1.472019 1.413470 1.354921 1.296372 1.237824 1.179275 1.120726 1.062177 1.003628 0.945080 0.886531 0.827982 0.769433 0.710884 0.652336 0.593787 0.535238 0.476689 0.418140 0.359592 0.301043 0.242494 1.783945 1.725396 1.666848 1.608299 1.549750 1.491201 1.432652 1.374104 1.315555 1.257006 1.198457 #[1.748635, 1.690086, 1.631537, 1.572988, 1.514440, 1.455891, 1.397342, 1.338793, 1.280244, 1.221696, 1.163147, 1.104598, 1.046049, 0.987500, 0.928952, 0.870403, 0.811854, 0.753305, 0.694756, 0.636208, 0.577659, 0.519110, 0.460561, 0.402012, 0.343464, 0.284915, 0.226366, 1.767817, 1.709268, 1.650720, 1.592171, 1.533622, 1.475073, 1.416524, 1.357976, 1.299427, 1.240878, 1.182329, 1.123780, 1.065232, 1.006683, 0.948134, 0.889585, 0.831036, 0.772488, 0.713939, 0.655390, 0.596841, 0.538292, 0.479744, 0.421195, 0.362646, 0.304097, 0.245548, 1.787000, 1.728451, 1.669902, 1.611353, 1.552804, 1.494256, 1.435707, 1.377158, 1.318609, 1.260060, 1.201512, 1.142963, 1.084414, 1.025865, 0.967316, 0.908768, 0.850219, 0.791670, 0.733121, 0.674572, 0.616024, 0.557475, 0.498926, 0.440377, 0.381828, 0.323280, 0.264731, 0.206182, 1.747633, 1.689084, 1.630536, 1.571987, 1.513438, 1.454889, 1.396340, 1.337792, 1.279243, 1.220694, 1.162145, 1.103596, 1.045048, 0.986499, 0.927950, 0.869401, 0.810852, 0.752304, 0.693755, 0.635206, 0.576657, 0.518108, 0.459560, 0.401011, 0.342462, 0.283913, 0.225364, 1.766816, 1.708267, 1.649718, 1.591169, 1.532620, 1.474072, 1.415523, 1.356974, 1.298425, 1.239876, 1.181328, 1.122779, 1.064230, 1.005681, 0.947132, 0.888584, 0.830035, 0.771486, 0.712937, 0.654388, 0.595840, 0.537291, 0.478742, 0.420193, 0.361644, 0.303096, 0.244547, 1.785998, 1.727449, 1.668900, 1.610352, 1.551803, 1.493254, 1.434705, 1.376156, 1.317608, 1.259059, 1.200510, 1.141961, 1.083412, 1.024864, 0.966315, 0.907766, 0.849217, 0.790668, 0.732120, 0.673571, 0.615022, 0.556473, 0.497924, 0.439376, 0.380827, 0.322278, 0.263729, 0.205180, 1.746632, 1.688083, 1.629534, 1.570985, 1.512436, 1.453888, 1.395339, 1.336790, 1.278241, 1.219692, 1.161144, 1.102595, 1.044046, 0.985497, 0.926948, 0.868400, 0.809851, 0.751302, 0.692753, 0.634204, 0.575656, 0.517107, 0.458558, 0.400009, 0.341460, 0.282912, 0.224363, 1.765814, 1.707265, 1.648716, 1.590168, 1.531619, 1.473070, 1.414521, 1.355972, 1.297424, 1.238875, 1.180326, 1.121777, 1.063228, 1.004680, 0.946131, 0.887582, 0.829033, 0.770484, 0.711936, 0.653387, 0.594838, 0.536289, 0.477740, 0.419192, 0.360643, 0.302094, 0.243545, 1.784996, 1.726448, 1.667899, 1.609350, 1.550801, 1.492252, 1.433704, 1.375155, 1.316606, 1.258057, 1.199508, 1.140960, 1.082411, 1.023862, 0.965313, 0.906764, 0.848216, 0.789667, 0.731118, 0.672569, 0.614020, 0.555472, 0.496923, 0.438374, 0.379825, 0.321276, 0.262728, 0.204179, 1.745630, 1.687081, 1.628532, 1.569984, 1.511435, 1.452886, 1.394337, 1.335788, 1.277240, 1.218691, 1.160142, 1.101593, 1.043044, 0.984496, 0.925947, 0.867398, 0.808849, 0.750300, 0.691752, 0.633203, 0.574654, 0.516105, 0.457556, 0.399008, 0.340459, 0.281910, 0.223361, 1.764812, 1.706264, 1.647715, 1.589166, 1.530617, 1.472068, 1.413520, 1.354971, 1.296422, 1.237873, 1.179324, 1.120776, 1.062227, 1.003678, 0.945129, 0.886580, 0.828032, 0.769483, 0.710934, 0.652385, 0.593836, 0.535288, 0.476739, 0.418190, 0.359641, 0.301092, 0.242544, 1.783995, 1.725446, 1.666897, 1.608348, 1.549800, 1.491251, 1.432702, 1.374153, 1.315604, 1.257056, 1.198507, 1.139958, 1.081409, 1.022860, 0.964312, 0.905763, 0.847214, 0.788665, 0.730116, 0.671568, 0.613019, 0.554470, 0.495921, 0.437372, 0.378824, 0.320275, 0.261726, 0.203177, 1.744628, 1.686080, 1.627531, 1.568982, 1.510433, 1.451884, 1.393336, 1.334787, 1.276238, 1.217689, 1.159140, 1.100592, 1.042043, 0.983494, 0.924945, 0.866396, 0.807848, 0.749299, 0.690750, 0.632201, 0.573652, 0.515104, 0.456555, 0.398006, 0.339457, 0.280908, 0.222360, 1.763811, 1.705262, 1.646713, 1.588164, 1.529616, 1.471067, 1.412518, 1.353969, 1.295420, 1.236872, 1.178323, 1.119774, 1.061225, 1.002676, 0.944128, 0.885579, 0.827030, 0.768481, 0.709932, 0.651384, 0.592835, 0.534286, 0.475737, 0.417188, 0.358640, 0.300091, 0.241542, 1.782993, 1.724444, 1.665896, 1.607347, 1.548798, 1.490249, 1.431700, 1.373152, 1.314603, 1.256054, 1.197505, 1.138956, 1.080408, 1.021859, 0.963310, 0.904761, 0.846212, 0.787664, 0.729115, 0.670566, 0.612017, 0.553468, 0.494920, 0.436371, 0.377822, 0.319273, 0.260724, 0.202176, 1.743627, 1.685078, 1.626529, 1.567980, 1.509432, 1.450883, 1.392334, 1.333785, 1.275236, 1.216688, 1.158139, 1.099590, 1.041041, 0.982492, 0.923944, 0.865395, 0.806846, 0.748297, 0.689748, 0.631200, 0.572651, 0.514102, 0.455553, 0.397004, 0.338456, 0.279907, 0.221358, 1.762809, 1.704260, 1.645712, 1.587163, 1.528614, 1.470065, 1.411516, 1.352968, 1.294419, 1.235870, 1.177321, 1.118772, 1.060224, 1.001675, 0.943126, 0.884577, 0.826028, 0.767480, 0.708931, 0.650382, 0.591833, 0.533284, 0.474736, 0.416187, 0.357638, 0.299089, 0.240540, 1.781992, 1.723443, 1.664894, 1.606345, 1.547796, 1.489248, 1.430699, 1.372150, 1.313601, 1.255052, 1.196504, 1.137955, 1.079406, 1.020857, 0.962308, 0.903760, 0.845211, 0.786662, 0.728113, 0.669564, 0.611016, 0.552467, 0.493918, 0.435369, 0.376820, 0.318272, 0.259723, 0.201174, 1.742625, 1.684076, 1.625528, 1.566979, 1.508430, 1.449881, 1.391332, 1.332784, 1.274235, 1.215686, 1.157137, 1.098588, 1.040040, 0.981491, 0.922942, 0.864393, 0.805844, 0.747296, 0.688747, 0.630198, 0.571649, 0.513100, 0.454552, 0.396003, 0.337454, 0.278905, 0.220356, 1.761808, 1.703259, 1.644710, 1.586161, 1.527612, 1.469064, 1.410515, 1.351966, 1.293417, 1.234868, 1.176320, 1.117771, 1.059222, 1.000673, 0.942124, 0.883576, 0.825027, 0.766478, 0.707929, 0.649380, 0.590832, 0.532283, 0.473734, 0.415185, 0.356636, 0.298088, 0.239539, 1.780990, 1.722441, 1.663892, 1.605344, 1.546795, 1.488246, 1.429697, 1.371148, 1.312600, 1.254051, 1.195502, 1.136953, 1.078404, 1.019856, 0.961307, 0.902758, 0.844209, 0.785660, 0.727112, 0.668563, 0.610014, 0.551465, 0.492916, 0.434368, 0.375819, 0.317270, 0.258721, 0.200172, 1.741624, 1.683075, 1.624526, 1.565977, 1.507428, 1.448880, 1.390331, 1.331782, 1.273233, 1.214684, 1.156136, 1.097587, 1.039038, 0.980489, 0.921940, 0.863392, 0.804843, 0.746294, 0.687745, 0.629196, 0.570648, 0.512099, 0.453550, 0.395001, 0.336452, 0.277904, 0.219355, 1.760806, 1.702257, 1.643708, 1.585160, 1.526611, 1.468062, 1.409513, 1.350964, 1.292416, 1.233867, 1.175318, 1.116769, 1.058220, 0.999672, 0.941123, 0.882574, 0.824025, 0.765476, 0.706928, 0.648379, 0.589830, 0.531281, 0.472732, 0.414184, 0.355635, 0.297086, 0.238537, 1.779988, 1.721440, 1.662891, 1.604342, 1.545793, 1.487244, 1.428696, 1.370147, 1.311598, 1.253049, 1.194500, 1.135952]).map Float.toBits))
#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 1.140827 1.082278 1.023729 0.965180 0.906632 0.848083 0.789534 0.730985 0.672436 0.613888 0.555339 0.496790 0.438241 0.379692 0.321144 0.262595 0.204046 1.745497 1.686948 1.628400 1.569851 1.511302 1.452753 1.394204 1.335656 1.277107 1.218558 1.160009 1.101460 1.042912 0.984363 0.925814 0.867265 #[1.417443, 1.358894, 1.300345, 1.241796, 1.183248, 1.124699, 1.066150, 1.007601, 0.949052, 0.890504, 0.831955, 0.773406, 0.714857, 0.656308, 0.597760, 0.539211, 0.480662, 0.422113, 0.363564, 0.305016, 0.246467, 1.787918, 1.729369, 1.670820, 1.612272, 1.553723, 1.495174, 1.436625, 1.378076, 1.319528, 1.260979, 1.202430, 1.143881, 1.085332, 1.026784, 0.968235, 0.909686, 0.851137, 0.792588, 0.734040, 0.675491, 0.616942, 0.558393, 0.499844, 0.441296, 0.382747, 0.324198, 0.265649, 0.207100, 1.748552, 1.690003, 1.631454, 1.572905, 1.514356, 1.455808, 1.397259, 1.338710, 1.280161, 1.221612, 1.163064, 1.104515, 1.045966, 0.987417, 0.928868, 0.870320, 0.811771, 0.753222, 0.694673, 0.636124, 0.577576, 0.519027, 0.460478, 0.401929, 0.343380, 0.284832, 0.226283, 1.767734, 1.709185, 1.650636, 1.592088, 1.533539, 1.474990, 1.416441, 1.357892, 1.299344, 1.240795, 1.182246, 1.123697, 1.065148, 1.006600, 0.948051, 0.889502, 0.830953, 0.772404, 0.713856, 0.655307, 0.596758, 0.538209, 0.479660, 0.421112, 0.362563, 0.304014, 0.245465, 1.786916, 1.728368, 1.669819, 1.611270, 1.552721, 1.494172, 1.435624, 1.377075, 1.318526, 1.259977, 1.201428, 1.142880, 1.084331, 1.025782, 0.967233, 0.908684, 0.850136, 0.791587, 0.733038, 0.674489, 0.615940, 0.557392, 0.498843, 0.440294, 0.381745, 0.323196, 0.264648, 0.206099, 1.747550, 1.689001, 1.630452, 1.571904, 1.513355, 1.454806, 1.396257, 1.337708, 1.279160, 1.220611, 1.162062, 1.103513, 1.044964, 0.986416, 0.927867, 0.869318, 0.810769, 0.752220, 0.693672, 0.635123, 0.576574, 0.518025, 0.459476, 0.400928, 0.342379, 0.283830, 0.225281, 1.766732, 1.708184, 1.649635, 1.591086, 1.532537, 1.473988, 1.415440, 1.356891, 1.298342, 1.239793, 1.181244, 1.122696, 1.064147, 1.005598, 0.947049, 0.888500, 0.829952, 0.771403, 0.712854, 0.654305, 0.595756, 0.537208, 0.478659, 0.420110, 0.361561, 0.303012, 0.244464, 1.785915, 1.727366, 1.668817, 1.610268, 1.551720, 1.493171, 1.434622, 1.376073, 1.317524, 1.258976, 1.200427, 1.141878, 1.083329, 1.024780, 0.966232, 0.907683, 0.849134, 0.790585, 0.732036, 0.673488, 0.614939, 0.556390, 0.497841, 0.439292, 0.380744, 0.322195, 0.263646, 0.205097, 1.746548, 1.688000, 1.629451, 1.570902, 1.512353, 1.453804, 1.395256, 1.336707, 1.278158, 1.219609, 1.161060, 1.102512, 1.043963, 0.985414, 0.926865, 0.868316, 0.809768, 0.751219, 0.692670, 0.634121, 0.575572, 0.517024, 0.458475, 0.399926, 0.341377, 0.282828, 0.224280, 1.765731, 1.707182, 1.648633, 1.590084, 1.531536, 1.472987, 1.414438, 1.355889, 1.297340, 1.238792, 1.180243, 1.121694, 1.063145, 1.004596, 0.946048, 0.887499, 0.828950, 0.770401, 0.711852, 0.653304, 0.594755, 0.536206, 0.477657, 0.419108, 0.360560, 0.302011, 0.243462, 1.784913, 1.726364, 1.667816, 1.609267, 1.550718, 1.492169, 1.433620, 1.375072, 1.316523, 1.257974, 1.199425, 1.140876, 1.082328, 1.023779, 0.965230, 0.906681, 0.848132, 0.789584, 0.731035, 0.672486, 0.613937, 0.555388, 0.496840, 0.438291, 0.379742, 0.321193, 0.262644, 0.204096, 1.745547, 1.686998, 1.628449, 1.569900, 1.511352, 1.452803, 1.394254, 1.335705, 1.277156, 1.218608, 1.160059, 1.101510, 1.042961, 0.984412, 0.925864, 0.867315, 0.808766, 0.750217, 0.691668, 0.633120, 0.574571, 0.516022, 0.457473, 0.398924, 0.340376, 0.281827, 0.223278, 1.764729, 1.706180, 1.647632, 1.589083, 1.530534, 1.471985, 1.413436, 1.354888, 1.296339, 1.237790, 1.179241, 1.120692, 1.062144, 1.003595, 0.945046, 0.886497, 0.827948, 0.769400, 0.710851, 0.652302, 0.593753, 0.535204, 0.476656, 0.418107, 0.359558, 0.301009, 0.242460, 1.783912, 1.725363, 1.666814, 1.608265, 1.549716, 1.491168, 1.432619, 1.374070, 1.315521, 1.256972, 1.198424, 1.139875, 1.081326, 1.022777, 0.964228, 0.905680, 0.847131, 0.788582, 0.730033, 0.671484, 0.612936, 0.554387, 0.495838, 0.437289, 0.378740, 0.320192, 0.261643, 0.203094, 1.744545, 1.685996, 1.627448, 1.568899, 1.510350, 1.451801, 1.393252, 1.334704, 1.276155, 1.217606, 1.159057, 1.100508, 1.041960, 0.983411, 0.924862, 0.866313, 0.807764, 0.749216, 0.690667, 0.632118, 0.573569, 0.515020, 0.456472, 0.397923, 0.339374, 0.280825, 0.222276, 1.763728, 1.705179, 1.646630, 1.588081, 1.529532, 1.470984, 1.412435, 1.353886, 1.295337, 1.236788, 1.178240, 1.119691, 1.061142, 1.002593, 0.944044, 0.885496, 0.826947, 0.768398, 0.709849, 0.651300, 0.592752, 0.534203, 0.475654, 0.417105, 0.358556, 0.300008, 0.241459, 1.782910, 1.724361, 1.665812, 1.607264, 1.548715, 1.490166, 1.431617, 1.373068, 1.314520, 1.255971, 1.197422, 1.138873, 1.080324, 1.021776, 0.963227, 0.904678, 0.846129, 0.787580, 0.729032, 0.670483, 0.611934, 0.553385, 0.494836, 0.436288, 0.377739, 0.319190, 0.260641, 0.202092, 1.743544, 1.684995, 1.626446, 1.567897, 1.509348, 1.450800, 1.392251, 1.333702, 1.275153, 1.216604, 1.158056, 1.099507, 1.040958, 0.982409, 0.923860, 0.865312, 0.806763, 0.748214, 0.689665, 0.631116, 0.572568, 0.514019, 0.455470, 0.396921, 0.338372, 0.279824, 0.221275, 1.762726, 1.704177, 1.645628, 1.587080, 1.528531, 1.469982, 1.411433, 1.352884, 1.294336, 1.235787, 1.177238, 1.118689, 1.060140, 1.001592, 0.943043, 0.884494, 0.825945, 0.767396, 0.708848, 0.650299, 0.591750, 0.533201, 0.474652, 0.416104, 0.357555, 0.299006, 0.240457, 1.781908, 1.723360, 1.664811, 1.606262, 1.547713, 1.489164, 1.430616, 1.372067, 1.313518, 1.254969, 1.196420, 1.137872, 1.079323, 1.020774, 0.962225, 0.903676, 0.845128, 0.786579, 0.728030, 0.669481, 0.610932, 0.552384, 0.493835, 0.435286, 0.376737, 0.318188, 0.259640, 0.201091, 1.742542, 1.683993, 1.625444, 1.566896, 1.508347, 1.449798, 1.391249, 1.332700, 1.274152, 1.215603, 1.157054, 1.098505, 1.039956, 0.981408, 0.922859, 0.864310, 0.805761, 0.747212, 0.688664, 0.630115, 0.571566, 0.513017, 0.454468, 0.395920, 0.337371, 0.278822, 0.220273, 1.761724, 1.703176, 1.644627, 1.586078, 1.527529, 1.468980, 1.410432, 1.351883, 1.293334, 1.234785, 1.176236, 1.117688, 1.059139, 1.000590, 0.942041, 0.883492, 0.824944, 0.766395, 0.707846, 0.649297, 0.590748, 0.532200, 0.473651, 0.415102, 0.356553, 0.298004, 0.239456, 1.780907, 1.722358, 1.663809, 1.605260, 1.546712, 1.488163, 1.429614, 1.371065, 1.312516, 1.253968, 1.195419, 1.136870, 1.078321, 1.019772, 0.961224, 0.902675, 0.844126, 0.785577, 0.727028, 0.668480, 0.609931, 0.551382, 0.492833, 0.434284, 0.375736, 0.317187, 0.258638, 0.200089, 1.741540, 1.682992, 1.624443, 1.565894, 1.507345, 1.448796, 1.390248, 1.331699, 1.273150, 1.214601, 1.156052, 1.097504, 1.038955, 0.980406, 0.921857, 0.863308, 0.804760]).map Float.toBits))

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
  let v1629 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); (if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && (((Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))) <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1631 := (v1629 / (64 : Float))
  (((0 : Float) <= v1631) && (v1631 <= (1 : Float)))

#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.617059 1.558510 1.499961 1.441412 1.382864 1.324315 1.265766 1.207217 1.148668 1.090120 1.031571 0.973022 0.914473 0.855924 0.797376 0.738827 0.680278 0.621729 0.563180 0.504632 0.446083 0.387534 0.328985 0.270436 0.211888 1.753339 1.694790 1.636241 1.577692 1.519144 1.460595 1.402046 1.343497 1.284948 1.226400 1.167851 #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443] #[0.293675, 0.235126, 1.776577, 1.718028, 1.659480, 1.600931, 1.542382, 1.483833, 1.425284, 1.366736, 1.308187, 1.249638, 1.191089, 1.132540, 1.073992, 1.015443, 0.956894, 0.898345, 0.839796, 0.781248, 0.722699, 0.664150, 0.605601, 0.547052, 0.488504, 0.429955, 0.371406, 0.312857, 0.254308, 1.795760, 1.737211, 1.678662, 1.620113, 1.561564, 1.503016, 1.444467, 1.385918, 1.327369, 1.268820, 1.210272, 1.151723, 1.093174, 1.034625, 0.976076, 0.917528, 0.858979, 0.800430, 0.741881, 0.683332, 0.624784, 0.566235, 0.507686, 0.449137, 0.390588, 0.332040, 0.273491, 0.214942, 1.756393, 1.697844, 1.639296, 1.580747, 1.522198, 1.463649, 1.405100, 1.346552, 1.288003, 1.229454, 1.170905, 1.112356, 1.053808, 0.995259, 0.936710, 0.878161, 0.819612, 0.761064, 0.702515, 0.643966, 0.585417, 0.526868, 0.468320, 0.409771, 0.351222, 0.292673, 0.234124, 1.775576, 1.717027, 1.658478, 1.599929, 1.541380, 1.482832, 1.424283, 1.365734, 1.307185, 1.248636, 1.190088, 1.131539, 1.072990, 1.014441, 0.955892, 0.897344, 0.838795, 0.780246, 0.721697, 0.663148, 0.604600, 0.546051, 0.487502, 0.428953, 0.370404, 0.311856, 0.253307, 1.794758, 1.736209, 1.677660, 1.619112, 1.560563, 1.502014, 1.443465, 1.384916, 1.326368, 1.267819, 1.209270, 1.150721, 1.092172, 1.033624, 0.975075, 0.916526, 0.857977, 0.799428, 0.740880, 0.682331, 0.623782, 0.565233, 0.506684, 0.448136, 0.389587, 0.331038, 0.272489, 0.213940, 1.755392, 1.696843, 1.638294, 1.579745, 1.521196, 1.462648, 1.404099, 1.345550, 1.287001, 1.228452, 1.169904, 1.111355, 1.052806, 0.994257, 0.935708, 0.877160, 0.818611, 0.760062, 0.701513, 0.642964, 0.584416, 0.525867, 0.467318, 0.408769, 0.350220, 0.291672, 0.233123, 1.774574, 1.716025, 1.657476, 1.598928, 1.540379, 1.481830, 1.423281, 1.364732, 1.306184, 1.247635, 1.189086, 1.130537, 1.071988, 1.013440, 0.954891, 0.896342, 0.837793, 0.779244, 0.720696, 0.662147, 0.603598, 0.545049, 0.486500, 0.427952, 0.369403, 0.310854, 0.252305, 1.793756, 1.735208, 1.676659, 1.618110, 1.559561, 1.501012, 1.442464, 1.383915, 1.325366, 1.266817, 1.208268, 1.149720, 1.091171, 1.032622, 0.974073, 0.915524, 0.856976, 0.798427, 0.739878, 0.681329, 0.622780, 0.564232, 0.505683, 0.447134, 0.388585, 0.330036, 0.271488, 0.212939, 1.754390, 1.695841, 1.637292, 1.578744, 1.520195, 1.461646, 1.403097, 1.344548, 1.286000, 1.227451, 1.168902, 1.110353, 1.051804, 0.993256, 0.934707, 0.876158, 0.817609, 0.759060, 0.700512, 0.641963, 0.583414, 0.524865, 0.466316, 0.407768, 0.349219, 0.290670, 0.232121, 1.773572, 1.715024, 1.656475, 1.597926, 1.539377, 1.480828, 1.422280, 1.363731, 1.305182, 1.246633, 1.188084, 1.129536, 1.070987, 1.012438, 0.953889, 0.895340, 0.836792, 0.778243, 0.719694, 0.661145, 0.602596, 0.544048, 0.485499, 0.426950, 0.368401, 0.309852, 0.251304, 1.792755, 1.734206, 1.675657, 1.617108, 1.558560, 1.500011, 1.441462, 1.382913, 1.324364, 1.265816, 1.207267, 1.148718, 1.090169, 1.031620, 0.973072, 0.914523, 0.855974, 0.797425, 0.738876, 0.680328, 0.621779, 0.563230, 0.504681, 0.446132, 0.387584, 0.329035, 0.270486, 0.211937, 1.753388, 1.694840, 1.636291, 1.577742, 1.519193, 1.460644, 1.402096, 1.343547, 1.284998, 1.226449, 1.167900, 1.109352, 1.050803, 0.992254, 0.933705, 0.875156, 0.816608, 0.758059, 0.699510, 0.640961, 0.582412, 0.523864, 0.465315, 0.406766, 0.348217, 0.289668, 0.231120, 1.772571, 1.714022, 1.655473, 1.596924, 1.538376, 1.479827, 1.421278, 1.362729, 1.304180, 1.245632, 1.187083, 1.128534, 1.069985, 1.011436, 0.952888, 0.894339, 0.835790, 0.777241, 0.718692, 0.660144, 0.601595, 0.543046, 0.484497, 0.425948, 0.367400, 0.308851, 0.250302, 1.791753, 1.733204, 1.674656, 1.616107, 1.557558, 1.499009, 1.440460, 1.381912, 1.323363, 1.264814, 1.206265, 1.147716, 1.089168, 1.030619, 0.972070, 0.913521, 0.854972, 0.796424, 0.737875, 0.679326, 0.620777, 0.562228, 0.503680, 0.445131, 0.386582, 0.328033, 0.269484, 0.210936, 1.752387, 1.693838, 1.635289, 1.576740, 1.518192, 1.459643, 1.401094, 1.342545, 1.283996, 1.225448, 1.166899, 1.108350, 1.049801, 0.991252, 0.932704, 0.874155, 0.815606, 0.757057, 0.698508, 0.639960, 0.581411, 0.522862, 0.464313, 0.405764, 0.347216, 0.288667, 0.230118, 1.771569, 1.713020, 1.654472, 1.595923, 1.537374, 1.478825, 1.420276, 1.361728, 1.303179, 1.244630, 1.186081, 1.127532, 1.068984, 1.010435, 0.951886, 0.893337, 0.834788, 0.776240, 0.717691, 0.659142, 0.600593, 0.542044, 0.483496, 0.424947, 0.366398, 0.307849, 0.249300, 1.790752, 1.732203, 1.673654, 1.615105, 1.556556, 1.498008, 1.439459, 1.380910, 1.322361, 1.263812, 1.205264, 1.146715, 1.088166, 1.029617, 0.971068, 0.912520, 0.853971, 0.795422, 0.736873, 0.678324, 0.619776, 0.561227, 0.502678, 0.444129, 0.385580, 0.327032, 0.268483, 0.209934, 1.751385, 1.692836, 1.634288, 1.575739, 1.517190, 1.458641, 1.400092, 1.341544, 1.282995, 1.224446, 1.165897, 1.107348, 1.048800, 0.990251, 0.931702, 0.873153, 0.814604, 0.756056, 0.697507, 0.638958, 0.580409, 0.521860, 0.463312, 0.404763, 0.346214, 0.287665, 0.229116, 1.770568, 1.712019, 1.653470, 1.594921, 1.536372, 1.477824, 1.419275, 1.360726, 1.302177, 1.243628, 1.185080, 1.126531, 1.067982, 1.009433, 0.950884, 0.892336, 0.833787, 0.775238, 0.716689, 0.658140, 0.599592, 0.541043, 0.482494, 0.423945, 0.365396, 0.306848, 0.248299, 1.789750, 1.731201, 1.672652, 1.614104, 1.555555, 1.497006, 1.438457, 1.379908, 1.321360, 1.262811, 1.204262, 1.145713, 1.087164, 1.028616, 0.970067, 0.911518, 0.852969, 0.794420, 0.735872, 0.677323, 0.618774, 0.560225, 0.501676, 0.443128, 0.384579, 0.326030, 0.267481, 0.208932, 1.750384, 1.691835, 1.633286, 1.574737, 1.516188, 1.457640, 1.399091, 1.340542, 1.281993, 1.223444, 1.164896, 1.106347, 1.047798, 0.989249, 0.930700, 0.872152, 0.813603, 0.755054, 0.696505, 0.637956, 0.579408, 0.520859, 0.462310, 0.403761, 0.345212, 0.286664, 0.228115, 1.769566, 1.711017, 1.652468, 1.593920, 1.535371, 1.476822, 1.418273, 1.359724, 1.301176, 1.242627, 1.184078, 1.125529, 1.066980, 1.008432, 0.949883, 0.891334, 0.832785, 0.774236, 0.715688, 0.657139, 0.598590, 0.540041, 0.481492, 0.422944, 0.364395, 0.305846, 0.247297, 1.788748, 1.730200, 1.671651, 1.613102, 1.554553, 1.496004, 1.437456, 1.378907, 1.320358, 1.261809, 1.203260, 1.144712, 1.086163, 1.027614, 0.969065, 0.910516, 0.851968, 0.793419, 0.734870, 0.676321, 0.617772, 0.559224, 0.500675, 0.442126, 0.383577, 0.325028, 0.266480, 0.207931, 1.749382, 1.690833, 1.632284, 1.573736, 1.515187, 1.456638, 1.398089, 1.339540, 1.280992]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.285867 1.227318 1.168769 1.110220 1.051672 0.993123 0.934574 0.876025 0.817476 0.758928 0.700379 0.641830 0.583281 0.524732 0.466184 0.407635 0.349086 0.290537 0.231988 1.773440 1.714891 1.656342 1.597793 1.539244 1.480696 1.422147 1.363598 1.305049 1.246500 1.187952 1.129403 1.070854 1.012305 0.953756 0.895208 0.836659 #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251] #[1.562483, 1.503934, 1.445385, 1.386836, 1.328288, 1.269739, 1.211190, 1.152641, 1.094092, 1.035544, 0.976995, 0.918446, 0.859897, 0.801348, 0.742800, 0.684251, 0.625702, 0.567153, 0.508604, 0.450056, 0.391507, 0.332958, 0.274409, 0.215860, 1.757312, 1.698763, 1.640214, 1.581665, 1.523116, 1.464568, 1.406019, 1.347470, 1.288921, 1.230372, 1.171824, 1.113275, 1.054726, 0.996177, 0.937628, 0.879080, 0.820531, 0.761982, 0.703433, 0.644884, 0.586336, 0.527787, 0.469238, 0.410689, 0.352140, 0.293592, 0.235043, 1.776494, 1.717945, 1.659396, 1.600848, 1.542299, 1.483750, 1.425201, 1.366652, 1.308104, 1.249555, 1.191006, 1.132457, 1.073908, 1.015360, 0.956811, 0.898262, 0.839713, 0.781164, 0.722616, 0.664067, 0.605518, 0.546969, 0.488420, 0.429872, 0.371323, 0.312774, 0.254225, 1.795676, 1.737128, 1.678579, 1.620030, 1.561481, 1.502932, 1.444384, 1.385835, 1.327286, 1.268737, 1.210188, 1.151640, 1.093091, 1.034542, 0.975993, 0.917444, 0.858896, 0.800347, 0.741798, 0.683249, 0.624700, 0.566152, 0.507603, 0.449054, 0.390505, 0.331956, 0.273408, 0.214859, 1.756310, 1.697761, 1.639212, 1.580664, 1.522115, 1.463566, 1.405017, 1.346468, 1.287920, 1.229371, 1.170822, 1.112273, 1.053724, 0.995176, 0.936627, 0.878078, 0.819529, 0.760980, 0.702432, 0.643883, 0.585334, 0.526785, 0.468236, 0.409688, 0.351139, 0.292590, 0.234041, 1.775492, 1.716944, 1.658395, 1.599846, 1.541297, 1.482748, 1.424200, 1.365651, 1.307102, 1.248553, 1.190004, 1.131456, 1.072907, 1.014358, 0.955809, 0.897260, 0.838712, 0.780163, 0.721614, 0.663065, 0.604516, 0.545968, 0.487419, 0.428870, 0.370321, 0.311772, 0.253224, 1.794675, 1.736126, 1.677577, 1.619028, 1.560480, 1.501931, 1.443382, 1.384833, 1.326284, 1.267736, 1.209187, 1.150638, 1.092089, 1.033540, 0.974992, 0.916443, 0.857894, 0.799345, 0.740796, 0.682248, 0.623699, 0.565150, 0.506601, 0.448052, 0.389504, 0.330955, 0.272406, 0.213857, 1.755308, 1.696760, 1.638211, 1.579662, 1.521113, 1.462564, 1.404016, 1.345467, 1.286918, 1.228369, 1.169820, 1.111272, 1.052723, 0.994174, 0.935625, 0.877076, 0.818528, 0.759979, 0.701430, 0.642881, 0.584332, 0.525784, 0.467235, 0.408686, 0.350137, 0.291588, 0.233040, 1.774491, 1.715942, 1.657393, 1.598844, 1.540296, 1.481747, 1.423198, 1.364649, 1.306100, 1.247552, 1.189003, 1.130454, 1.071905, 1.013356, 0.954808, 0.896259, 0.837710, 0.779161, 0.720612, 0.662064, 0.603515, 0.544966, 0.486417, 0.427868, 0.369320, 0.310771, 0.252222, 1.793673, 1.735124, 1.676576, 1.618027, 1.559478, 1.500929, 1.442380, 1.383832, 1.325283, 1.266734, 1.208185, 1.149636, 1.091088, 1.032539, 0.973990, 0.915441, 0.856892, 0.798344, 0.739795, 0.681246, 0.622697, 0.564148, 0.505600, 0.447051, 0.388502, 0.329953, 0.271404, 0.212856, 1.754307, 1.695758, 1.637209, 1.578660, 1.520112, 1.461563, 1.403014, 1.344465, 1.285916, 1.227368, 1.168819, 1.110270, 1.051721, 0.993172, 0.934624, 0.876075, 0.817526, 0.758977, 0.700428, 0.641880, 0.583331, 0.524782, 0.466233, 0.407684, 0.349136, 0.290587, 0.232038, 1.773489, 1.714940, 1.656392, 1.597843, 1.539294, 1.480745, 1.422196, 1.363648, 1.305099, 1.246550, 1.188001, 1.129452, 1.070904, 1.012355, 0.953806, 0.895257, 0.836708, 0.778160, 0.719611, 0.661062, 0.602513, 0.543964, 0.485416, 0.426867, 0.368318, 0.309769, 0.251220, 1.792672, 1.734123, 1.675574, 1.617025, 1.558476, 1.499928, 1.441379, 1.382830, 1.324281, 1.265732, 1.207184, 1.148635, 1.090086, 1.031537, 0.972988, 0.914440, 0.855891, 0.797342, 0.738793, 0.680244, 0.621696, 0.563147, 0.504598, 0.446049, 0.387500, 0.328952, 0.270403, 0.211854, 1.753305, 1.694756, 1.636208, 1.577659, 1.519110, 1.460561, 1.402012, 1.343464, 1.284915, 1.226366, 1.167817, 1.109268, 1.050720, 0.992171, 0.933622, 0.875073, 0.816524, 0.757976, 0.699427, 0.640878, 0.582329, 0.523780, 0.465232, 0.406683, 0.348134, 0.289585, 0.231036, 1.772488, 1.713939, 1.655390, 1.596841, 1.538292, 1.479744, 1.421195, 1.362646, 1.304097, 1.245548, 1.187000, 1.128451, 1.069902, 1.011353, 0.952804, 0.894256, 0.835707, 0.777158, 0.718609, 0.660060, 0.601512, 0.542963, 0.484414, 0.425865, 0.367316, 0.308768, 0.250219, 1.791670, 1.733121, 1.674572, 1.616024, 1.557475, 1.498926, 1.440377, 1.381828, 1.323280, 1.264731, 1.206182, 1.147633, 1.089084, 1.030536, 0.971987, 0.913438, 0.854889, 0.796340, 0.737792, 0.679243, 0.620694, 0.562145, 0.503596, 0.445048, 0.386499, 0.327950, 0.269401, 0.210852, 1.752304, 1.693755, 1.635206, 1.576657, 1.518108, 1.459560, 1.401011, 1.342462, 1.283913, 1.225364, 1.166816, 1.108267, 1.049718, 0.991169, 0.932620, 0.874072, 0.815523, 0.756974, 0.698425, 0.639876, 0.581328, 0.522779, 0.464230, 0.405681, 0.347132, 0.288584, 0.230035, 1.771486, 1.712937, 1.654388, 1.595840, 1.537291, 1.478742, 1.420193, 1.361644, 1.303096, 1.244547, 1.185998, 1.127449, 1.068900, 1.010352, 0.951803, 0.893254, 0.834705, 0.776156, 0.717608, 0.659059, 0.600510, 0.541961, 0.483412, 0.424864, 0.366315, 0.307766, 0.249217, 1.790668, 1.732120, 1.673571, 1.615022, 1.556473, 1.497924, 1.439376, 1.380827, 1.322278, 1.263729, 1.205180, 1.146632, 1.088083, 1.029534, 0.970985, 0.912436, 0.853888, 0.795339, 0.736790, 0.678241, 0.619692, 0.561144, 0.502595, 0.444046, 0.385497, 0.326948, 0.268400, 0.209851, 1.751302, 1.692753, 1.634204, 1.575656, 1.517107, 1.458558, 1.400009, 1.341460, 1.282912, 1.224363, 1.165814, 1.107265, 1.048716, 0.990168, 0.931619, 0.873070, 0.814521, 0.755972, 0.697424, 0.638875, 0.580326, 0.521777, 0.463228, 0.404680, 0.346131, 0.287582, 0.229033, 1.770484, 1.711936, 1.653387, 1.594838, 1.536289, 1.477740, 1.419192, 1.360643, 1.302094, 1.243545, 1.184996, 1.126448, 1.067899, 1.009350, 0.950801, 0.892252, 0.833704, 0.775155, 0.716606, 0.658057, 0.599508, 0.540960, 0.482411, 0.423862, 0.365313, 0.306764, 0.248216, 1.789667, 1.731118, 1.672569, 1.614020, 1.555472, 1.496923, 1.438374, 1.379825, 1.321276, 1.262728, 1.204179, 1.145630, 1.087081, 1.028532, 0.969984, 0.911435, 0.852886, 0.794337, 0.735788, 0.677240, 0.618691, 0.560142, 0.501593, 0.443044, 0.384496, 0.325947, 0.267398, 0.208849, 1.750300, 1.691752, 1.633203, 1.574654, 1.516105, 1.457556, 1.399008, 1.340459, 1.281910, 1.223361, 1.164812, 1.106264, 1.047715, 0.989166, 0.930617, 0.872068, 0.813520, 0.754971, 0.696422, 0.637873, 0.579324, 0.520776, 0.462227, 0.403678, 0.345129, 0.286580, 0.228032, 1.769483, 1.710934, 1.652385, 1.593836, 1.535288, 1.476739, 1.418190, 1.359641, 1.301092, 1.242544, 1.183995, 1.125446, 1.066897, 1.008348, 0.949800]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.954675 0.896126 0.837577 0.779028 0.720480 0.661931 0.603382 0.544833 0.486284 0.427736 0.369187 0.310638 0.252089 1.793540 1.734992 1.676443 1.617894 1.559345 1.500796 1.442248 1.383699 1.325150 1.266601 1.208052 1.149504 1.090955 1.032406 0.973857 0.915308 0.856760 0.798211 0.739662 0.681113 0.622564 0.564016 0.505467 #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059] #[1.231291, 1.172742, 1.114193, 1.055644, 0.997096, 0.938547, 0.879998, 0.821449, 0.762900, 0.704352, 0.645803, 0.587254, 0.528705, 0.470156, 0.411608, 0.353059, 0.294510, 0.235961, 1.777412, 1.718864, 1.660315, 1.601766, 1.543217, 1.484668, 1.426120, 1.367571, 1.309022, 1.250473, 1.191924, 1.133376, 1.074827, 1.016278, 0.957729, 0.899180, 0.840632, 0.782083, 0.723534, 0.664985, 0.606436, 0.547888, 0.489339, 0.430790, 0.372241, 0.313692, 0.255144, 1.796595, 1.738046, 1.679497, 1.620948, 1.562400, 1.503851, 1.445302, 1.386753, 1.328204, 1.269656, 1.211107, 1.152558, 1.094009, 1.035460, 0.976912, 0.918363, 0.859814, 0.801265, 0.742716, 0.684168, 0.625619, 0.567070, 0.508521, 0.449972, 0.391424, 0.332875, 0.274326, 0.215777, 1.757228, 1.698680, 1.640131, 1.581582, 1.523033, 1.464484, 1.405936, 1.347387, 1.288838, 1.230289, 1.171740, 1.113192, 1.054643, 0.996094, 0.937545, 0.878996, 0.820448, 0.761899, 0.703350, 0.644801, 0.586252, 0.527704, 0.469155, 0.410606, 0.352057, 0.293508, 0.234960, 1.776411, 1.717862, 1.659313, 1.600764, 1.542216, 1.483667, 1.425118, 1.366569, 1.308020, 1.249472, 1.190923, 1.132374, 1.073825, 1.015276, 0.956728, 0.898179, 0.839630, 0.781081, 0.722532, 0.663984, 0.605435, 0.546886, 0.488337, 0.429788, 0.371240, 0.312691, 0.254142, 1.795593, 1.737044, 1.678496, 1.619947, 1.561398, 1.502849, 1.444300, 1.385752, 1.327203, 1.268654, 1.210105, 1.151556, 1.093008, 1.034459, 0.975910, 0.917361, 0.858812, 0.800264, 0.741715, 0.683166, 0.624617, 0.566068, 0.507520, 0.448971, 0.390422, 0.331873, 0.273324, 0.214776, 1.756227, 1.697678, 1.639129, 1.580580, 1.522032, 1.463483, 1.404934, 1.346385, 1.287836, 1.229288, 1.170739, 1.112190, 1.053641, 0.995092, 0.936544, 0.877995, 0.819446, 0.760897, 0.702348, 0.643800, 0.585251, 0.526702, 0.468153, 0.409604, 0.351056, 0.292507, 0.233958, 1.775409, 1.716860, 1.658312, 1.599763, 1.541214, 1.482665, 1.424116, 1.365568, 1.307019, 1.248470, 1.189921, 1.131372, 1.072824, 1.014275, 0.955726, 0.897177, 0.838628, 0.780080, 0.721531, 0.662982, 0.604433, 0.545884, 0.487336, 0.428787, 0.370238, 0.311689, 0.253140, 1.794592, 1.736043, 1.677494, 1.618945, 1.560396, 1.501848, 1.443299, 1.384750, 1.326201, 1.267652, 1.209104, 1.150555, 1.092006, 1.033457, 0.974908, 0.916360, 0.857811, 0.799262, 0.740713, 0.682164, 0.623616, 0.565067, 0.506518, 0.447969, 0.389420, 0.330872, 0.272323, 0.213774, 1.755225, 1.696676, 1.638128, 1.579579, 1.521030, 1.462481, 1.403932, 1.345384, 1.286835, 1.228286, 1.169737, 1.111188, 1.052640, 0.994091, 0.935542, 0.876993, 0.818444, 0.759896, 0.701347, 0.642798, 0.584249, 0.525700, 0.467152, 0.408603, 0.350054, 0.291505, 0.232956, 1.774408, 1.715859, 1.657310, 1.598761, 1.540212, 1.481664, 1.423115, 1.364566, 1.306017, 1.247468, 1.188920, 1.130371, 1.071822, 1.013273, 0.954724, 0.896176, 0.837627, 0.779078, 0.720529, 0.661980, 0.603432, 0.544883, 0.486334, 0.427785, 0.369236, 0.310688, 0.252139, 1.793590, 1.735041, 1.676492, 1.617944, 1.559395, 1.500846, 1.442297, 1.383748, 1.325200, 1.266651, 1.208102, 1.149553, 1.091004, 1.032456, 0.973907, 0.915358, 0.856809, 0.798260, 0.739712, 0.681163, 0.622614, 0.564065, 0.505516, 0.446968, 0.388419, 0.329870, 0.271321, 0.212772, 1.754224, 1.695675, 1.637126, 1.578577, 1.520028, 1.461480, 1.402931, 1.344382, 1.285833, 1.227284, 1.168736, 1.110187, 1.051638, 0.993089, 0.934540, 0.875992, 0.817443, 0.758894, 0.700345, 0.641796, 0.583248, 0.524699, 0.466150, 0.407601, 0.349052, 0.290504, 0.231955, 1.773406, 1.714857, 1.656308, 1.597760, 1.539211, 1.480662, 1.422113, 1.363564, 1.305016, 1.246467, 1.187918, 1.129369, 1.070820, 1.012272, 0.953723, 0.895174, 0.836625, 0.778076, 0.719528, 0.660979, 0.602430, 0.543881, 0.485332, 0.426784, 0.368235, 0.309686, 0.251137, 1.792588, 1.734040, 1.675491, 1.616942, 1.558393, 1.499844, 1.441296, 1.382747, 1.324198, 1.265649, 1.207100, 1.148552, 1.090003, 1.031454, 0.972905, 0.914356, 0.855808, 0.797259, 0.738710, 0.680161, 0.621612, 0.563064, 0.504515, 0.445966, 0.387417, 0.328868, 0.270320, 0.211771, 1.753222, 1.694673, 1.636124, 1.577576, 1.519027, 1.460478, 1.401929, 1.343380, 1.284832, 1.226283, 1.167734, 1.109185, 1.050636, 0.992088, 0.933539, 0.874990, 0.816441, 0.757892, 0.699344, 0.640795, 0.582246, 0.523697, 0.465148, 0.406600, 0.348051, 0.289502, 0.230953, 1.772404, 1.713856, 1.655307, 1.596758, 1.538209, 1.479660, 1.421112, 1.362563, 1.304014, 1.245465, 1.186916, 1.128368, 1.069819, 1.011270, 0.952721, 0.894172, 0.835624, 0.777075, 0.718526, 0.659977, 0.601428, 0.542880, 0.484331, 0.425782, 0.367233, 0.308684, 0.250136, 1.791587, 1.733038, 1.674489, 1.615940, 1.557392, 1.498843, 1.440294, 1.381745, 1.323196, 1.264648, 1.206099, 1.147550, 1.089001, 1.030452, 0.971904, 0.913355, 0.854806, 0.796257, 0.737708, 0.679160, 0.620611, 0.562062, 0.503513, 0.444964, 0.386416, 0.327867, 0.269318, 0.210769, 1.752220, 1.693672, 1.635123, 1.576574, 1.518025, 1.459476, 1.400928, 1.342379, 1.283830, 1.225281, 1.166732, 1.108184, 1.049635, 0.991086, 0.932537, 0.873988, 0.815440, 0.756891, 0.698342, 0.639793, 0.581244, 0.522696, 0.464147, 0.405598, 0.347049, 0.288500, 0.229952, 1.771403, 1.712854, 1.654305, 1.595756, 1.537208, 1.478659, 1.420110, 1.361561, 1.303012, 1.244464, 1.185915, 1.127366, 1.068817, 1.010268, 0.951720, 0.893171, 0.834622, 0.776073, 0.717524, 0.658976, 0.600427, 0.541878, 0.483329, 0.424780, 0.366232, 0.307683, 0.249134, 1.790585, 1.732036, 1.673488, 1.614939, 1.556390, 1.497841, 1.439292, 1.380744, 1.322195, 1.263646, 1.205097, 1.146548, 1.088000, 1.029451, 0.970902, 0.912353, 0.853804, 0.795256, 0.736707, 0.678158, 0.619609, 0.561060, 0.502512, 0.443963, 0.385414, 0.326865, 0.268316, 0.209768, 1.751219, 1.692670, 1.634121, 1.575572, 1.517024, 1.458475, 1.399926, 1.341377, 1.282828, 1.224280, 1.165731, 1.107182, 1.048633, 0.990084, 0.931536, 0.872987, 0.814438, 0.755889, 0.697340, 0.638792, 0.580243, 0.521694, 0.463145, 0.404596, 0.346048, 0.287499, 0.228950, 1.770401, 1.711852, 1.653304, 1.594755, 1.536206, 1.477657, 1.419108, 1.360560, 1.302011, 1.243462, 1.184913, 1.126364, 1.067816, 1.009267, 0.950718, 0.892169, 0.833620, 0.775072, 0.716523, 0.657974, 0.599425, 0.540876, 0.482328, 0.423779, 0.365230, 0.306681, 0.248132, 1.789584, 1.731035, 1.672486, 1.613937, 1.555388, 1.496840, 1.438291, 1.379742, 1.321193, 1.262644, 1.204096, 1.145547, 1.086998, 1.028449, 0.969900, 0.911352, 0.852803, 0.794254, 0.735705, 0.677156, 0.618608]))

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
  let v1650 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((0 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1655 := (((((v1650 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1666 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((1 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1671 := (((((v1666 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1682 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((2 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1687 := (((((v1682 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1699 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((3 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1704 := (((((v1699 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1716 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((4 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1721 := (((((v1716 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1733 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((5 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1738 := (((((v1733 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1750 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((6 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1755 := (((((v1750 / (64 : Float)) * v1622) * rho) * dni) * soil)
  let v1767 := ((List.range 64).foldl (fun acc i => acc + (let v1424 := (v1410 + (w * (Float.floor (dr[i * 10 + 0]! * v1407)))); let v1428 := (v1410 + (w * (Float.floor (dr[i * 10 + 1]! * v1407)))); let v1431 := ((dr[i * 10 + 2]! - v1429) * w); let v1433 := ((dr[i * 10 + 3]! - v1429) * w); let v1474 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1476 := (v1475 * dr[i * 10 + 5]!); let v1477 := (Float.cos v1474); let v1479 := (Float.sin v1474); let v1480 := (Float.cos v1476); let v1482 := (Float.sin v1476); let v1486 := ((v1477 * v1434) + (v1479 * ((v1480 * v1461) + (v1482 * ((v1435 * v1463) - (v1436 * v1462)))))); let v1492 := ((v1477 * v1435) + (v1479 * ((v1480 * v1462) + (v1482 * ((v1436 * v1461) - (v1434 * v1463)))))); let v1498 := ((v1477 * v1436) + (v1479 * ((v1480 * v1463) + (v1482 * ((v1434 * v1462) - (v1435 * v1461)))))); let v1510 := (v1424 + v1431); let v1511 := (v1428 + v1433); let v1518 := (Float.sqrt (max ((v1424 ^ 2) + (v1428 ^ 2)) (0.000000000000000001 : Float))); let v1519 := (v1518 ^ 2); let v1525 := ((1 : Float) - ((((1 : Float) + k) * (v1513 ^ 2)) * v1519)); let v1533 := ((v1513 * v1518) / (Float.sqrt (max v1525 (0.000000000000000001 : Float)))); let v1536 := (Float.sqrt ((1 : Float) + (v1533 ^ 2))); let v1537 := (-v1533); let v1540 := (((v1537 * v1424) / v1518) / v1536); let v1543 := (((v1537 * v1428) / v1518) / v1536); let v1544 := ((1 : Float) / v1536); let v1546 := (v1540 + (sigmaslope * dr[i * 10 + 6]!)); let v1548 := (v1543 + (sigmaslope * dr[i * 10 + 7]!)); let v1554 := (Float.sqrt (((v1546 ^ 2) + (v1548 ^ 2)) + (v1544 ^ 2))); let v1555 := (v1546 / v1554); let v1556 := (v1548 / v1554); let v1557 := (v1544 / v1554); let v1571 := (((((v1424 - v1510) * v1540) + ((v1428 - v1511) * v1543)) + ((((v1513 * v1519) / ((1 : Float) + (Float.sqrt (max v1525 (0 : Float))))) - v1512) * v1544)) / (((v1486 * v1540) + (v1492 * v1543)) + (v1498 * v1544))); let v1583 := ((2 : Float) * (((v1486 * v1555) + (v1492 * v1556)) + (v1498 * v1557))); let v1589 := (v1498 - (v1583 * v1557)); let v1591 := ((v1486 - (v1583 * v1555)) + (sigmaspec * dr[i * 10 + 8]!)); let v1593 := ((v1492 - (v1583 * v1556)) + (sigmaspec * dr[i * 10 + 9]!)); let v1599 := (Float.sqrt (((v1591 ^ 2) + (v1593 ^ 2)) + (v1589 ^ 2))); let v1602 := (v1589 / v1599); let v1604 := ((f - (v1512 + (v1571 * v1498))) / v1602); let v1612 := (Float.sqrt ((((v1510 + (v1571 * v1486)) + (v1604 * (v1591 / v1599))) ^ 2) + (((v1511 + (v1571 * v1492)) + (v1604 * (v1593 / v1599))) ^ 2))); (if ((((((7 : Float) * rc) / (8 : Float)) <= v1612) && (v1612 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1424) <= a) && (((Float.abs v1428) <= a) && (((Float.abs v1431) <= v1409) && ((Float.abs v1433) <= v1409)))) && ((v1612 <= rc) && ((0 : Float) < v1602))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
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

#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 1.430907 1.372358 1.313809 1.255260 1.196712 1.138163 1.079614 1.021065 0.962516 0.903968 0.845419 0.786870 0.728321 0.669772 0.611224 0.552675 0.494126 0.435577 0.377028 0.318480 0.259931 0.201382 1.742833 1.684284 1.625736 1.567187 1.508638 1.450089 1.391540 1.332992 1.274443 1.215894 1.157345 1.098796 1.040248 0.981699 #[1.707523, 1.648974, 1.590425, 1.531876, 1.473328, 1.414779, 1.356230, 1.297681, 1.239132, 1.180584, 1.122035, 1.063486, 1.004937, 0.946388, 0.887840, 0.829291] #[1.707523, 1.648974, 1.590425, 1.531876, 1.473328, 1.414779, 1.356230, 1.297681, 1.239132, 1.180584, 1.122035, 1.063486, 1.004937, 0.946388, 0.887840, 0.829291] #[1.707523, 1.648974, 1.590425, 1.531876, 1.473328, 1.414779, 1.356230, 1.297681, 1.239132, 1.180584, 1.122035, 1.063486, 1.004937, 0.946388, 0.887840, 0.829291, 0.770742, 0.712193, 0.653644, 0.595096, 0.536547, 0.477998, 0.419449, 0.360900, 0.302352, 0.243803, 1.785254, 1.726705, 1.668156, 1.609608, 1.551059, 1.492510, 1.433961, 1.375412, 1.316864, 1.258315, 1.199766, 1.141217, 1.082668, 1.024120, 0.965571, 0.907022, 0.848473, 0.789924, 0.731376, 0.672827, 0.614278, 0.555729, 0.497180, 0.438632, 0.380083, 0.321534, 0.262985, 0.204436, 1.745888, 1.687339, 1.628790, 1.570241, 1.511692, 1.453144, 1.394595, 1.336046, 1.277497, 1.218948, 1.160400, 1.101851, 1.043302, 0.984753, 0.926204, 0.867656, 0.809107, 0.750558, 0.692009, 0.633460, 0.574912, 0.516363, 0.457814, 0.399265, 0.340716, 0.282168, 0.223619, 1.765070, 1.706521, 1.647972, 1.589424, 1.530875, 1.472326, 1.413777, 1.355228, 1.296680, 1.238131, 1.179582, 1.121033, 1.062484, 1.003936, 0.945387, 0.886838, 0.828289, 0.769740, 0.711192, 0.652643, 0.594094, 0.535545, 0.476996, 0.418448, 0.359899, 0.301350, 0.242801, 1.784252, 1.725704, 1.667155, 1.608606, 1.550057, 1.491508, 1.432960, 1.374411, 1.315862, 1.257313, 1.198764, 1.140216, 1.081667, 1.023118, 0.964569, 0.906020, 0.847472, 0.788923, 0.730374, 0.671825, 0.613276, 0.554728, 0.496179, 0.437630, 0.379081, 0.320532, 0.261984, 0.203435, 1.744886, 1.686337, 1.627788, 1.569240, 1.510691, 1.452142, 1.393593, 1.335044, 1.276496, 1.217947, 1.159398, 1.100849, 1.042300, 0.983752, 0.925203, 0.866654, 0.808105, 0.749556, 0.691008, 0.632459, 0.573910, 0.515361, 0.456812, 0.398264, 0.339715, 0.281166, 0.222617, 1.764068, 1.705520, 1.646971, 1.588422, 1.529873, 1.471324, 1.412776, 1.354227, 1.295678, 1.237129, 1.178580, 1.120032, 1.061483, 1.002934, 0.944385, 0.885836, 0.827288, 0.768739, 0.710190, 0.651641, 0.593092, 0.534544, 0.475995, 0.417446, 0.358897, 0.300348, 0.241800, 1.783251, 1.724702, 1.666153, 1.607604, 1.549056, 1.490507, 1.431958, 1.373409, 1.314860, 1.256312, 1.197763, 1.139214, 1.080665, 1.022116, 0.963568, 0.905019, 0.846470, 0.787921, 0.729372, 0.670824, 0.612275, 0.553726, 0.495177, 0.436628, 0.378080, 0.319531, 0.260982, 0.202433, 1.743884, 1.685336, 1.626787, 1.568238, 1.509689, 1.451140, 1.392592, 1.334043, 1.275494, 1.216945, 1.158396, 1.099848, 1.041299, 0.982750, 0.924201, 0.865652, 0.807104, 0.748555, 0.690006, 0.631457, 0.572908, 0.514360, 0.455811, 0.397262, 0.338713, 0.280164, 0.221616, 1.763067, 1.704518, 1.645969, 1.587420, 1.528872, 1.470323, 1.411774, 1.353225, 1.294676, 1.236128, 1.177579, 1.119030, 1.060481, 1.001932, 0.943384, 0.884835, 0.826286, 0.767737, 0.709188, 0.650640, 0.592091, 0.533542, 0.474993, 0.416444, 0.357896, 0.299347, 0.240798, 1.782249, 1.723700, 1.665152, 1.606603, 1.548054, 1.489505, 1.430956, 1.372408, 1.313859, 1.255310, 1.196761, 1.138212, 1.079664, 1.021115, 0.962566, 0.904017, 0.845468, 0.786920, 0.728371, 0.669822, 0.611273, 0.552724, 0.494176, 0.435627, 0.377078, 0.318529, 0.259980, 0.201432, 1.742883, 1.684334, 1.625785, 1.567236, 1.508688, 1.450139, 1.391590, 1.333041, 1.274492, 1.215944, 1.157395, 1.098846, 1.040297, 0.981748, 0.923200, 0.864651, 0.806102, 0.747553, 0.689004, 0.630456, 0.571907, 0.513358, 0.454809, 0.396260, 0.337712, 0.279163, 0.220614, 1.762065, 1.703516, 1.644968, 1.586419, 1.527870, 1.469321, 1.410772, 1.352224, 1.293675, 1.235126, 1.176577, 1.118028, 1.059480, 1.000931, 0.942382, 0.883833, 0.825284, 0.766736, 0.708187, 0.649638, 0.591089, 0.532540, 0.473992, 0.415443, 0.356894, 0.298345, 0.239796, 1.781248, 1.722699, 1.664150, 1.605601, 1.547052, 1.488504, 1.429955, 1.371406, 1.312857, 1.254308, 1.195760, 1.137211, 1.078662, 1.020113, 0.961564, 0.903016, 0.844467, 0.785918, 0.727369, 0.668820, 0.610272, 0.551723, 0.493174, 0.434625, 0.376076, 0.317528, 0.258979, 0.200430, 1.741881, 1.683332, 1.624784, 1.566235, 1.507686, 1.449137, 1.390588, 1.332040, 1.273491, 1.214942, 1.156393, 1.097844, 1.039296, 0.980747, 0.922198, 0.863649, 0.805100, 0.746552, 0.688003, 0.629454, 0.570905, 0.512356, 0.453808, 0.395259, 0.336710, 0.278161, 0.219612, 1.761064, 1.702515, 1.643966, 1.585417, 1.526868, 1.468320, 1.409771, 1.351222, 1.292673, 1.234124, 1.175576, 1.117027, 1.058478, 0.999929, 0.941380, 0.882832, 0.824283, 0.765734, 0.707185, 0.648636, 0.590088, 0.531539, 0.472990, 0.414441, 0.355892, 0.297344, 0.238795, 1.780246, 1.721697, 1.663148, 1.604600, 1.546051, 1.487502, 1.428953, 1.370404, 1.311856, 1.253307, 1.194758, 1.136209, 1.077660, 1.019112, 0.960563, 0.902014, 0.843465, 0.784916, 0.726368, 0.667819, 0.609270, 0.550721, 0.492172, 0.433624, 0.375075, 0.316526, 0.257977, 1.799428, 1.740880, 1.682331, 1.623782, 1.565233, 1.506684, 1.448136, 1.389587, 1.331038, 1.272489, 1.213940, 1.155392, 1.096843, 1.038294, 0.979745, 0.921196, 0.862648, 0.804099, 0.745550, 0.687001, 0.628452, 0.569904, 0.511355, 0.452806, 0.394257, 0.335708, 0.277160, 0.218611, 1.760062, 1.701513, 1.642964, 1.584416, 1.525867, 1.467318, 1.408769, 1.350220, 1.291672, 1.233123, 1.174574, 1.116025, 1.057476, 0.998928, 0.940379, 0.881830, 0.823281, 0.764732, 0.706184, 0.647635, 0.589086, 0.530537, 0.471988, 0.413440, 0.354891, 0.296342, 0.237793, 1.779244, 1.720696, 1.662147, 1.603598, 1.545049, 1.486500, 1.427952, 1.369403, 1.310854, 1.252305, 1.193756, 1.135208, 1.076659, 1.018110, 0.959561, 0.901012, 0.842464, 0.783915, 0.725366, 0.666817, 0.608268, 0.549720, 0.491171, 0.432622, 0.374073, 0.315524, 0.256976, 1.798427, 1.739878, 1.681329, 1.622780, 1.564232, 1.505683, 1.447134, 1.388585, 1.330036, 1.271488, 1.212939, 1.154390, 1.095841, 1.037292, 0.978744, 0.920195, 0.861646, 0.803097, 0.744548, 0.686000, 0.627451, 0.568902, 0.510353, 0.451804, 0.393256, 0.334707, 0.276158, 0.217609, 1.759060, 1.700512, 1.641963, 1.583414, 1.524865, 1.466316, 1.407768, 1.349219, 1.290670, 1.232121, 1.173572, 1.115024, 1.056475, 0.997926, 0.939377, 0.880828, 0.822280, 0.763731, 0.705182, 0.646633, 0.588084, 0.529536, 0.470987, 0.412438, 0.353889, 0.295340, 0.236792, 1.778243, 1.719694, 1.661145, 1.602596, 1.544048, 1.485499, 1.426950, 1.368401, 1.309852, 1.251304, 1.192755, 1.134206, 1.075657, 1.017108, 0.958560, 0.900011, 0.841462, 0.782913, 0.724364, 0.665816, 0.607267, 0.548718, 0.490169, 0.431620, 0.373072, 0.314523, 0.255974, 1.797425, 1.738876, 1.680328, 1.621779, 1.563230, 1.504681, 1.446132, 1.387584, 1.329035, 1.270486, 1.211937, 1.153388, 1.094840]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 1.099715 1.041166 0.982617 0.924068 0.865520 0.806971 0.748422 0.689873 0.631324 0.572776 0.514227 0.455678 0.397129 0.338580 0.280032 0.221483 1.762934 1.704385 1.645836 1.587288 1.528739 1.470190 1.411641 1.353092 1.294544 1.235995 1.177446 1.118897 1.060348 1.001800 0.943251 0.884702 0.826153 0.767604 0.709056 0.650507 #[1.376331, 1.317782, 1.259233, 1.200684, 1.142136, 1.083587, 1.025038, 0.966489, 0.907940, 0.849392, 0.790843, 0.732294, 0.673745, 0.615196, 0.556648, 0.498099] #[1.376331, 1.317782, 1.259233, 1.200684, 1.142136, 1.083587, 1.025038, 0.966489, 0.907940, 0.849392, 0.790843, 0.732294, 0.673745, 0.615196, 0.556648, 0.498099] #[1.376331, 1.317782, 1.259233, 1.200684, 1.142136, 1.083587, 1.025038, 0.966489, 0.907940, 0.849392, 0.790843, 0.732294, 0.673745, 0.615196, 0.556648, 0.498099, 0.439550, 0.381001, 0.322452, 0.263904, 0.205355, 1.746806, 1.688257, 1.629708, 1.571160, 1.512611, 1.454062, 1.395513, 1.336964, 1.278416, 1.219867, 1.161318, 1.102769, 1.044220, 0.985672, 0.927123, 0.868574, 0.810025, 0.751476, 0.692928, 0.634379, 0.575830, 0.517281, 0.458732, 0.400184, 0.341635, 0.283086, 0.224537, 1.765988, 1.707440, 1.648891, 1.590342, 1.531793, 1.473244, 1.414696, 1.356147, 1.297598, 1.239049, 1.180500, 1.121952, 1.063403, 1.004854, 0.946305, 0.887756, 0.829208, 0.770659, 0.712110, 0.653561, 0.595012, 0.536464, 0.477915, 0.419366, 0.360817, 0.302268, 0.243720, 1.785171, 1.726622, 1.668073, 1.609524, 1.550976, 1.492427, 1.433878, 1.375329, 1.316780, 1.258232, 1.199683, 1.141134, 1.082585, 1.024036, 0.965488, 0.906939, 0.848390, 0.789841, 0.731292, 0.672744, 0.614195, 0.555646, 0.497097, 0.438548, 0.380000, 0.321451, 0.262902, 0.204353, 1.745804, 1.687256, 1.628707, 1.570158, 1.511609, 1.453060, 1.394512, 1.335963, 1.277414, 1.218865, 1.160316, 1.101768, 1.043219, 0.984670, 0.926121, 0.867572, 0.809024, 0.750475, 0.691926, 0.633377, 0.574828, 0.516280, 0.457731, 0.399182, 0.340633, 0.282084, 0.223536, 1.764987, 1.706438, 1.647889, 1.589340, 1.530792, 1.472243, 1.413694, 1.355145, 1.296596, 1.238048, 1.179499, 1.120950, 1.062401, 1.003852, 0.945304, 0.886755, 0.828206, 0.769657, 0.711108, 0.652560, 0.594011, 0.535462, 0.476913, 0.418364, 0.359816, 0.301267, 0.242718, 1.784169, 1.725620, 1.667072, 1.608523, 1.549974, 1.491425, 1.432876, 1.374328, 1.315779, 1.257230, 1.198681, 1.140132, 1.081584, 1.023035, 0.964486, 0.905937, 0.847388, 0.788840, 0.730291, 0.671742, 0.613193, 0.554644, 0.496096, 0.437547, 0.378998, 0.320449, 0.261900, 0.203352, 1.744803, 1.686254, 1.627705, 1.569156, 1.510608, 1.452059, 1.393510, 1.334961, 1.276412, 1.217864, 1.159315, 1.100766, 1.042217, 0.983668, 0.925120, 0.866571, 0.808022, 0.749473, 0.690924, 0.632376, 0.573827, 0.515278, 0.456729, 0.398180, 0.339632, 0.281083, 0.222534, 1.763985, 1.705436, 1.646888, 1.588339, 1.529790, 1.471241, 1.412692, 1.354144, 1.295595, 1.237046, 1.178497, 1.119948, 1.061400, 1.002851, 0.944302, 0.885753, 0.827204, 0.768656, 0.710107, 0.651558, 0.593009, 0.534460, 0.475912, 0.417363, 0.358814, 0.300265, 0.241716, 1.783168, 1.724619, 1.666070, 1.607521, 1.548972, 1.490424, 1.431875, 1.373326, 1.314777, 1.256228, 1.197680, 1.139131, 1.080582, 1.022033, 0.963484, 0.904936, 0.846387, 0.787838, 0.729289, 0.670740, 0.612192, 0.553643, 0.495094, 0.436545, 0.377996, 0.319448, 0.260899, 0.202350, 1.743801, 1.685252, 1.626704, 1.568155, 1.509606, 1.451057, 1.392508, 1.333960, 1.275411, 1.216862, 1.158313, 1.099764, 1.041216, 0.982667, 0.924118, 0.865569, 0.807020, 0.748472, 0.689923, 0.631374, 0.572825, 0.514276, 0.455728, 0.397179, 0.338630, 0.280081, 0.221532, 1.762984, 1.704435, 1.645886, 1.587337, 1.528788, 1.470240, 1.411691, 1.353142, 1.294593, 1.236044, 1.177496, 1.118947, 1.060398, 1.001849, 0.943300, 0.884752, 0.826203, 0.767654, 0.709105, 0.650556, 0.592008, 0.533459, 0.474910, 0.416361, 0.357812, 0.299264, 0.240715, 1.782166, 1.723617, 1.665068, 1.606520, 1.547971, 1.489422, 1.430873, 1.372324, 1.313776, 1.255227, 1.196678, 1.138129, 1.079580, 1.021032, 0.962483, 0.903934, 0.845385, 0.786836, 0.728288, 0.669739, 0.611190, 0.552641, 0.494092, 0.435544, 0.376995, 0.318446, 0.259897, 0.201348, 1.742800, 1.684251, 1.625702, 1.567153, 1.508604, 1.450056, 1.391507, 1.332958, 1.274409, 1.215860, 1.157312, 1.098763, 1.040214, 0.981665, 0.923116, 0.864568, 0.806019, 0.747470, 0.688921, 0.630372, 0.571824, 0.513275, 0.454726, 0.396177, 0.337628, 0.279080, 0.220531, 1.761982, 1.703433, 1.644884, 1.586336, 1.527787, 1.469238, 1.410689, 1.352140, 1.293592, 1.235043, 1.176494, 1.117945, 1.059396, 1.000848, 0.942299, 0.883750, 0.825201, 0.766652, 0.708104, 0.649555, 0.591006, 0.532457, 0.473908, 0.415360, 0.356811, 0.298262, 0.239713, 1.781164, 1.722616, 1.664067, 1.605518, 1.546969, 1.488420, 1.429872, 1.371323, 1.312774, 1.254225, 1.195676, 1.137128, 1.078579, 1.020030, 0.961481, 0.902932, 0.844384, 0.785835, 0.727286, 0.668737, 0.610188, 0.551640, 0.493091, 0.434542, 0.375993, 0.317444, 0.258896, 0.200347, 1.741798, 1.683249, 1.624700, 1.566152, 1.507603, 1.449054, 1.390505, 1.331956, 1.273408, 1.214859, 1.156310, 1.097761, 1.039212, 0.980664, 0.922115, 0.863566, 0.805017, 0.746468, 0.687920, 0.629371, 0.570822, 0.512273, 0.453724, 0.395176, 0.336627, 0.278078, 0.219529, 1.760980, 1.702432, 1.643883, 1.585334, 1.526785, 1.468236, 1.409688, 1.351139, 1.292590, 1.234041, 1.175492, 1.116944, 1.058395, 0.999846, 0.941297, 0.882748, 0.824200, 0.765651, 0.707102, 0.648553, 0.590004, 0.531456, 0.472907, 0.414358, 0.355809, 0.297260, 0.238712, 1.780163, 1.721614, 1.663065, 1.604516, 1.545968, 1.487419, 1.428870, 1.370321, 1.311772, 1.253224, 1.194675, 1.136126, 1.077577, 1.019028, 0.960480, 0.901931, 0.843382, 0.784833, 0.726284, 0.667736, 0.609187, 0.550638, 0.492089, 0.433540, 0.374992, 0.316443, 0.257894, 1.799345, 1.740796, 1.682248, 1.623699, 1.565150, 1.506601, 1.448052, 1.389504, 1.330955, 1.272406, 1.213857, 1.155308, 1.096760, 1.038211, 0.979662, 0.921113, 0.862564, 0.804016, 0.745467, 0.686918, 0.628369, 0.569820, 0.511272, 0.452723, 0.394174, 0.335625, 0.277076, 0.218528, 1.759979, 1.701430, 1.642881, 1.584332, 1.525784, 1.467235, 1.408686, 1.350137, 1.291588, 1.233040, 1.174491, 1.115942, 1.057393, 0.998844, 0.940296, 0.881747, 0.823198, 0.764649, 0.706100, 0.647552, 0.589003, 0.530454, 0.471905, 0.413356, 0.354808, 0.296259, 0.237710, 1.779161, 1.720612, 1.662064, 1.603515, 1.544966, 1.486417, 1.427868, 1.369320, 1.310771, 1.252222, 1.193673, 1.135124, 1.076576, 1.018027, 0.959478, 0.900929, 0.842380, 0.783832, 0.725283, 0.666734, 0.608185, 0.549636, 0.491088, 0.432539, 0.373990, 0.315441, 0.256892, 1.798344, 1.739795, 1.681246, 1.622697, 1.564148, 1.505600, 1.447051, 1.388502, 1.329953, 1.271404, 1.212856, 1.154307, 1.095758, 1.037209, 0.978660, 0.920112, 0.861563, 0.803014, 0.744465, 0.685916, 0.627368, 0.568819, 0.510270, 0.451721, 0.393172, 0.334624, 0.276075, 0.217526, 1.758977, 1.700428, 1.641880, 1.583331, 1.524782, 1.466233, 1.407684, 1.349136, 1.290587, 1.232038, 1.173489, 1.114940, 1.056392, 0.997843, 0.939294, 0.880745, 0.822196, 0.763648]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.768523 0.709974 0.651425 0.592876 0.534328 0.475779 0.417230 0.358681 0.300132 0.241584 1.783035 1.724486 1.665937 1.607388 1.548840 1.490291 1.431742 1.373193 1.314644 1.256096 1.197547 1.138998 1.080449 1.021900 0.963352 0.904803 0.846254 0.787705 0.729156 0.670608 0.612059 0.553510 0.494961 0.436412 0.377864 0.319315 #[1.045139, 0.986590, 0.928041, 0.869492, 0.810944, 0.752395, 0.693846, 0.635297, 0.576748, 0.518200, 0.459651, 0.401102, 0.342553, 0.284004, 0.225456, 1.766907] #[1.045139, 0.986590, 0.928041, 0.869492, 0.810944, 0.752395, 0.693846, 0.635297, 0.576748, 0.518200, 0.459651, 0.401102, 0.342553, 0.284004, 0.225456, 1.766907] #[1.045139, 0.986590, 0.928041, 0.869492, 0.810944, 0.752395, 0.693846, 0.635297, 0.576748, 0.518200, 0.459651, 0.401102, 0.342553, 0.284004, 0.225456, 1.766907, 1.708358, 1.649809, 1.591260, 1.532712, 1.474163, 1.415614, 1.357065, 1.298516, 1.239968, 1.181419, 1.122870, 1.064321, 1.005772, 0.947224, 0.888675, 0.830126, 0.771577, 0.713028, 0.654480, 0.595931, 0.537382, 0.478833, 0.420284, 0.361736, 0.303187, 0.244638, 1.786089, 1.727540, 1.668992, 1.610443, 1.551894, 1.493345, 1.434796, 1.376248, 1.317699, 1.259150, 1.200601, 1.142052, 1.083504, 1.024955, 0.966406, 0.907857, 0.849308, 0.790760, 0.732211, 0.673662, 0.615113, 0.556564, 0.498016, 0.439467, 0.380918, 0.322369, 0.263820, 0.205272, 1.746723, 1.688174, 1.629625, 1.571076, 1.512528, 1.453979, 1.395430, 1.336881, 1.278332, 1.219784, 1.161235, 1.102686, 1.044137, 0.985588, 0.927040, 0.868491, 0.809942, 0.751393, 0.692844, 0.634296, 0.575747, 0.517198, 0.458649, 0.400100, 0.341552, 0.283003, 0.224454, 1.765905, 1.707356, 1.648808, 1.590259, 1.531710, 1.473161, 1.414612, 1.356064, 1.297515, 1.238966, 1.180417, 1.121868, 1.063320, 1.004771, 0.946222, 0.887673, 0.829124, 0.770576, 0.712027, 0.653478, 0.594929, 0.536380, 0.477832, 0.419283, 0.360734, 0.302185, 0.243636, 1.785088, 1.726539, 1.667990, 1.609441, 1.550892, 1.492344, 1.433795, 1.375246, 1.316697, 1.258148, 1.199600, 1.141051, 1.082502, 1.023953, 0.965404, 0.906856, 0.848307, 0.789758, 0.731209, 0.672660, 0.614112, 0.555563, 0.497014, 0.438465, 0.379916, 0.321368, 0.262819, 0.204270, 1.745721, 1.687172, 1.628624, 1.570075, 1.511526, 1.452977, 1.394428, 1.335880, 1.277331, 1.218782, 1.160233, 1.101684, 1.043136, 0.984587, 0.926038, 0.867489, 0.808940, 0.750392, 0.691843, 0.633294, 0.574745, 0.516196, 0.457648, 0.399099, 0.340550, 0.282001, 0.223452, 1.764904, 1.706355, 1.647806, 1.589257, 1.530708, 1.472160, 1.413611, 1.355062, 1.296513, 1.237964, 1.179416, 1.120867, 1.062318, 1.003769, 0.945220, 0.886672, 0.828123, 0.769574, 0.711025, 0.652476, 0.593928, 0.535379, 0.476830, 0.418281, 0.359732, 0.301184, 0.242635, 1.784086, 1.725537, 1.666988, 1.608440, 1.549891, 1.491342, 1.432793, 1.374244, 1.315696, 1.257147, 1.198598, 1.140049, 1.081500, 1.022952, 0.964403, 0.905854, 0.847305, 0.788756, 0.730208, 0.671659, 0.613110, 0.554561, 0.496012, 0.437464, 0.378915, 0.320366, 0.261817, 0.203268, 1.744720, 1.686171, 1.627622, 1.569073, 1.510524, 1.451976, 1.393427, 1.334878, 1.276329, 1.217780, 1.159232, 1.100683, 1.042134, 0.983585, 0.925036, 0.866488, 0.807939, 0.749390, 0.690841, 0.632292, 0.573744, 0.515195, 0.456646, 0.398097, 0.339548, 0.281000, 0.222451, 1.763902, 1.705353, 1.646804, 1.588256, 1.529707, 1.471158, 1.412609, 1.354060, 1.295512, 1.236963, 1.178414, 1.119865, 1.061316, 1.002768, 0.944219, 0.885670, 0.827121, 0.768572, 0.710024, 0.651475, 0.592926, 0.534377, 0.475828, 0.417280, 0.358731, 0.300182, 0.241633, 1.783084, 1.724536, 1.665987, 1.607438, 1.548889, 1.490340, 1.431792, 1.373243, 1.314694, 1.256145, 1.197596, 1.139048, 1.080499, 1.021950, 0.963401, 0.904852, 0.846304, 0.787755, 0.729206, 0.670657, 0.612108, 0.553560, 0.495011, 0.436462, 0.377913, 0.319364, 0.260816, 0.202267, 1.743718, 1.685169, 1.626620, 1.568072, 1.509523, 1.450974, 1.392425, 1.333876, 1.275328, 1.216779, 1.158230, 1.099681, 1.041132, 0.982584, 0.924035, 0.865486, 0.806937, 0.748388, 0.689840, 0.631291, 0.572742, 0.514193, 0.455644, 0.397096, 0.338547, 0.279998, 0.221449, 1.762900, 1.704352, 1.645803, 1.587254, 1.528705, 1.470156, 1.411608, 1.353059, 1.294510, 1.235961, 1.177412, 1.118864, 1.060315, 1.001766, 0.943217, 0.884668, 0.826120, 0.767571, 0.709022, 0.650473, 0.591924, 0.533376, 0.474827, 0.416278, 0.357729, 0.299180, 0.240632, 1.782083, 1.723534, 1.664985, 1.606436, 1.547888, 1.489339, 1.430790, 1.372241, 1.313692, 1.255144, 1.196595, 1.138046, 1.079497, 1.020948, 0.962400, 0.903851, 0.845302, 0.786753, 0.728204, 0.669656, 0.611107, 0.552558, 0.494009, 0.435460, 0.376912, 0.318363, 0.259814, 0.201265, 1.742716, 1.684168, 1.625619, 1.567070, 1.508521, 1.449972, 1.391424, 1.332875, 1.274326, 1.215777, 1.157228, 1.098680, 1.040131, 0.981582, 0.923033, 0.864484, 0.805936, 0.747387, 0.688838, 0.630289, 0.571740, 0.513192, 0.454643, 0.396094, 0.337545, 0.278996, 0.220448, 1.761899, 1.703350, 1.644801, 1.586252, 1.527704, 1.469155, 1.410606, 1.352057, 1.293508, 1.234960, 1.176411, 1.117862, 1.059313, 1.000764, 0.942216, 0.883667, 0.825118, 0.766569, 0.708020, 0.649472, 0.590923, 0.532374, 0.473825, 0.415276, 0.356728, 0.298179, 0.239630, 1.781081, 1.722532, 1.663984, 1.605435, 1.546886, 1.488337, 1.429788, 1.371240, 1.312691, 1.254142, 1.195593, 1.137044, 1.078496, 1.019947, 0.961398, 0.902849, 0.844300, 0.785752, 0.727203, 0.668654, 0.610105, 0.551556, 0.493008, 0.434459, 0.375910, 0.317361, 0.258812, 0.200264, 1.741715, 1.683166, 1.624617, 1.566068, 1.507520, 1.448971, 1.390422, 1.331873, 1.273324, 1.214776, 1.156227, 1.097678, 1.039129, 0.980580, 0.922032, 0.863483, 0.804934, 0.746385, 0.687836, 0.629288, 0.570739, 0.512190, 0.453641, 0.395092, 0.336544, 0.277995, 0.219446, 1.760897, 1.702348, 1.643800, 1.585251, 1.526702, 1.468153, 1.409604, 1.351056, 1.292507, 1.233958, 1.175409, 1.116860, 1.058312, 0.999763, 0.941214, 0.882665, 0.824116, 0.765568, 0.707019, 0.648470, 0.589921, 0.531372, 0.472824, 0.414275, 0.355726, 0.297177, 0.238628, 1.780080, 1.721531, 1.662982, 1.604433, 1.545884, 1.487336, 1.428787, 1.370238, 1.311689, 1.253140, 1.194592, 1.136043, 1.077494, 1.018945, 0.960396, 0.901848, 0.843299, 0.784750, 0.726201, 0.667652, 0.609104, 0.550555, 0.492006, 0.433457, 0.374908, 0.316360, 0.257811, 1.799262, 1.740713, 1.682164, 1.623616, 1.565067, 1.506518, 1.447969, 1.389420, 1.330872, 1.272323, 1.213774, 1.155225, 1.096676, 1.038128, 0.979579, 0.921030, 0.862481, 0.803932, 0.745384, 0.686835, 0.628286, 0.569737, 0.511188, 0.452640, 0.394091, 0.335542, 0.276993, 0.218444, 1.759896, 1.701347, 1.642798, 1.584249, 1.525700, 1.467152, 1.408603, 1.350054, 1.291505, 1.232956, 1.174408, 1.115859, 1.057310, 0.998761, 0.940212, 0.881664, 0.823115, 0.764566, 0.706017, 0.647468, 0.588920, 0.530371, 0.471822, 0.413273, 0.354724, 0.296176, 0.237627, 1.779078, 1.720529, 1.661980, 1.603432, 1.544883, 1.486334, 1.427785, 1.369236, 1.310688, 1.252139, 1.193590, 1.135041, 1.076492, 1.017944, 0.959395, 0.900846, 0.842297, 0.783748, 0.725200, 0.666651, 0.608102, 0.549553, 0.491004, 0.432456]))

def check_hashemiEnv_pot_le (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (mcp : Float) (Twall : Float) (Ta : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v1779 := (Float.exp ((-(Upipe / (2 : Float))) / mcp))
  let v1781 := (Ta + ((hist[1]! - Ta) * v1779))
  let v1784 := (max (0 : Float) (v1781 - Twall))
  let v1785 := ((min UAx mcp) * v1784)
  (!((0 : Float) <= UAx) || (!((0 : Float) <= mcp) || (v1785 <= (UAx * v1784))))

#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 1.244755 1.186206 1.127657 1.069108 1.010560 0.952011 0.893462 0.834913 0.776364 0.717816 0.659267 0.600718 0.542169 0.483620 0.425072 0.366523 0.307974 0.249425 1.790876 1.732328 1.673779 1.615230 1.556681 1.498132 1.439584 1.381035 1.322486 1.263937 1.205388 1.146840 1.088291 1.029742 0.971193 0.912644 0.854096 0.795547 #[1.521371, 1.462822, 1.404273, 1.345724, 1.287176, 1.228627, 1.170078, 1.111529, 1.052980, 0.994432, 0.935883, 0.877334, 0.818785, 0.760236, 0.701688, 0.643139] #[1.521371, 1.462822, 1.404273, 1.345724, 1.287176, 1.228627, 1.170078, 1.111529, 1.052980, 0.994432, 0.935883, 0.877334, 0.818785, 0.760236, 0.701688, 0.643139] #[1.521371, 1.462822, 1.404273, 1.345724, 1.287176, 1.228627, 1.170078, 1.111529, 1.052980, 0.994432, 0.935883, 0.877334, 0.818785, 0.760236, 0.701688, 0.643139, 0.584590, 0.526041, 0.467492, 0.408944, 0.350395, 0.291846, 0.233297, 1.774748, 1.716200, 1.657651, 1.599102, 1.540553, 1.482004, 1.423456, 1.364907, 1.306358, 1.247809, 1.189260, 1.130712, 1.072163, 1.013614, 0.955065, 0.896516, 0.837968, 0.779419, 0.720870, 0.662321, 0.603772, 0.545224, 0.486675, 0.428126, 0.369577, 0.311028, 0.252480, 1.793931, 1.735382, 1.676833, 1.618284, 1.559736, 1.501187, 1.442638, 1.384089, 1.325540, 1.266992, 1.208443, 1.149894, 1.091345, 1.032796, 0.974248, 0.915699, 0.857150, 0.798601, 0.740052, 0.681504, 0.622955, 0.564406, 0.505857, 0.447308, 0.388760, 0.330211, 0.271662, 0.213113, 1.754564, 1.696016, 1.637467, 1.578918, 1.520369, 1.461820, 1.403272, 1.344723, 1.286174, 1.227625, 1.169076, 1.110528, 1.051979, 0.993430, 0.934881, 0.876332, 0.817784, 0.759235, 0.700686, 0.642137, 0.583588, 0.525040, 0.466491, 0.407942, 0.349393, 0.290844, 0.232296, 1.773747, 1.715198, 1.656649, 1.598100, 1.539552, 1.481003, 1.422454, 1.363905, 1.305356, 1.246808, 1.188259, 1.129710, 1.071161, 1.012612, 0.954064, 0.895515, 0.836966, 0.778417, 0.719868, 0.661320, 0.602771, 0.544222, 0.485673, 0.427124, 0.368576, 0.310027, 0.251478, 1.792929, 1.734380, 1.675832, 1.617283, 1.558734, 1.500185, 1.441636, 1.383088, 1.324539, 1.265990, 1.207441, 1.148892, 1.090344, 1.031795, 0.973246, 0.914697, 0.856148, 0.797600, 0.739051, 0.680502, 0.621953, 0.563404, 0.504856, 0.446307, 0.387758, 0.329209, 0.270660, 0.212112, 1.753563, 1.695014, 1.636465, 1.577916, 1.519368, 1.460819, 1.402270, 1.343721, 1.285172, 1.226624, 1.168075, 1.109526, 1.050977, 0.992428, 0.933880, 0.875331, 0.816782, 0.758233, 0.699684, 0.641136, 0.582587, 0.524038, 0.465489, 0.406940, 0.348392, 0.289843, 0.231294, 1.772745, 1.714196, 1.655648, 1.597099, 1.538550, 1.480001, 1.421452, 1.362904, 1.304355, 1.245806, 1.187257, 1.128708, 1.070160, 1.011611, 0.953062, 0.894513, 0.835964, 0.777416, 0.718867, 0.660318, 0.601769, 0.543220, 0.484672, 0.426123, 0.367574, 0.309025, 0.250476, 1.791928, 1.733379, 1.674830, 1.616281, 1.557732, 1.499184, 1.440635, 1.382086, 1.323537, 1.264988, 1.206440, 1.147891, 1.089342, 1.030793, 0.972244, 0.913696, 0.855147, 0.796598, 0.738049, 0.679500, 0.620952, 0.562403, 0.503854, 0.445305, 0.386756, 0.328208, 0.269659, 0.211110, 1.752561, 1.694012, 1.635464, 1.576915, 1.518366, 1.459817, 1.401268, 1.342720, 1.284171, 1.225622, 1.167073, 1.108524, 1.049976, 0.991427, 0.932878, 0.874329, 0.815780, 0.757232, 0.698683, 0.640134, 0.581585, 0.523036, 0.464488, 0.405939, 0.347390, 0.288841, 0.230292, 1.771744, 1.713195, 1.654646, 1.596097, 1.537548, 1.479000, 1.420451, 1.361902, 1.303353, 1.244804, 1.186256, 1.127707, 1.069158, 1.010609, 0.952060, 0.893512, 0.834963, 0.776414, 0.717865, 0.659316, 0.600768, 0.542219, 0.483670, 0.425121, 0.366572, 0.308024, 0.249475, 1.790926, 1.732377, 1.673828, 1.615280, 1.556731, 1.498182, 1.439633, 1.381084, 1.322536, 1.263987, 1.205438, 1.146889, 1.088340, 1.029792, 0.971243, 0.912694, 0.854145, 0.795596, 0.737048, 0.678499, 0.619950, 0.561401, 0.502852, 0.444304, 0.385755, 0.327206, 0.268657, 0.210108, 1.751560, 1.693011, 1.634462, 1.575913, 1.517364, 1.458816, 1.400267, 1.341718, 1.283169, 1.224620, 1.166072, 1.107523, 1.048974, 0.990425, 0.931876, 0.873328, 0.814779, 0.756230, 0.697681, 0.639132, 0.580584, 0.522035, 0.463486, 0.404937, 0.346388, 0.287840, 0.229291, 1.770742, 1.712193, 1.653644, 1.595096, 1.536547, 1.477998, 1.419449, 1.360900, 1.302352, 1.243803, 1.185254, 1.126705, 1.068156, 1.009608, 0.951059, 0.892510, 0.833961, 0.775412, 0.716864, 0.658315, 0.599766, 0.541217, 0.482668, 0.424120, 0.365571, 0.307022, 0.248473, 1.789924, 1.731376, 1.672827, 1.614278, 1.555729, 1.497180, 1.438632, 1.380083, 1.321534, 1.262985, 1.204436, 1.145888, 1.087339, 1.028790, 0.970241, 0.911692, 0.853144, 0.794595, 0.736046, 0.677497, 0.618948, 0.560400, 0.501851, 0.443302, 0.384753, 0.326204, 0.267656, 0.209107, 1.750558, 1.692009, 1.633460, 1.574912, 1.516363, 1.457814, 1.399265, 1.340716, 1.282168, 1.223619, 1.165070, 1.106521, 1.047972, 0.989424, 0.930875, 0.872326, 0.813777, 0.755228, 0.696680, 0.638131, 0.579582, 0.521033, 0.462484, 0.403936, 0.345387, 0.286838, 0.228289, 1.769740, 1.711192, 1.652643, 1.594094, 1.535545, 1.476996, 1.418448, 1.359899, 1.301350, 1.242801, 1.184252, 1.125704, 1.067155, 1.008606, 0.950057, 0.891508, 0.832960, 0.774411, 0.715862, 0.657313, 0.598764, 0.540216, 0.481667, 0.423118, 0.364569, 0.306020, 0.247472, 1.788923, 1.730374, 1.671825, 1.613276, 1.554728, 1.496179, 1.437630, 1.379081, 1.320532, 1.261984, 1.203435, 1.144886, 1.086337, 1.027788, 0.969240, 0.910691, 0.852142, 0.793593, 0.735044, 0.676496, 0.617947, 0.559398, 0.500849, 0.442300, 0.383752, 0.325203, 0.266654, 0.208105, 1.749556, 1.691008, 1.632459, 1.573910, 1.515361, 1.456812, 1.398264, 1.339715, 1.281166, 1.222617, 1.164068, 1.105520, 1.046971, 0.988422, 0.929873, 0.871324, 0.812776, 0.754227, 0.695678, 0.637129, 0.578580, 0.520032, 0.461483, 0.402934, 0.344385, 0.285836, 0.227288, 1.768739, 1.710190, 1.651641, 1.593092, 1.534544, 1.475995, 1.417446, 1.358897, 1.300348, 1.241800, 1.183251, 1.124702, 1.066153, 1.007604, 0.949056, 0.890507, 0.831958, 0.773409, 0.714860, 0.656312, 0.597763, 0.539214, 0.480665, 0.422116, 0.363568, 0.305019, 0.246470, 1.787921, 1.729372, 1.670824, 1.612275, 1.553726, 1.495177, 1.436628, 1.378080, 1.319531, 1.260982, 1.202433, 1.143884, 1.085336, 1.026787, 0.968238, 0.909689, 0.851140, 0.792592, 0.734043, 0.675494, 0.616945, 0.558396, 0.499848, 0.441299, 0.382750, 0.324201, 0.265652, 0.207104, 1.748555, 1.690006, 1.631457, 1.572908, 1.514360, 1.455811, 1.397262, 1.338713, 1.280164, 1.221616, 1.163067, 1.104518, 1.045969, 0.987420, 0.928872, 0.870323, 0.811774, 0.753225, 0.694676, 0.636128, 0.577579, 0.519030, 0.460481, 0.401932, 0.343384, 0.284835, 0.226286, 1.767737, 1.709188, 1.650640, 1.592091, 1.533542, 1.474993, 1.416444, 1.357896, 1.299347, 1.240798, 1.182249, 1.123700, 1.065152, 1.006603, 0.948054, 0.889505, 0.830956, 0.772408, 0.713859, 0.655310, 0.596761, 0.538212, 0.479664, 0.421115, 0.362566, 0.304017, 0.245468, 1.786920, 1.728371, 1.669822, 1.611273, 1.552724, 1.494176, 1.435627, 1.377078, 1.318529, 1.259980, 1.201432, 1.142883, 1.084334, 1.025785, 0.967236, 0.908688]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 0.913563 0.855014 0.796465 0.737916 0.679368 0.620819 0.562270 0.503721 0.445172 0.386624 0.328075 0.269526 0.210977 1.752428 1.693880 1.635331 1.576782 1.518233 1.459684 1.401136 1.342587 1.284038 1.225489 1.166940 1.108392 1.049843 0.991294 0.932745 0.874196 0.815648 0.757099 0.698550 0.640001 0.581452 0.522904 0.464355 #[1.190179, 1.131630, 1.073081, 1.014532, 0.955984, 0.897435, 0.838886, 0.780337, 0.721788, 0.663240, 0.604691, 0.546142, 0.487593, 0.429044, 0.370496, 0.311947] #[1.190179, 1.131630, 1.073081, 1.014532, 0.955984, 0.897435, 0.838886, 0.780337, 0.721788, 0.663240, 0.604691, 0.546142, 0.487593, 0.429044, 0.370496, 0.311947] #[1.190179, 1.131630, 1.073081, 1.014532, 0.955984, 0.897435, 0.838886, 0.780337, 0.721788, 0.663240, 0.604691, 0.546142, 0.487593, 0.429044, 0.370496, 0.311947, 0.253398, 1.794849, 1.736300, 1.677752, 1.619203, 1.560654, 1.502105, 1.443556, 1.385008, 1.326459, 1.267910, 1.209361, 1.150812, 1.092264, 1.033715, 0.975166, 0.916617, 0.858068, 0.799520, 0.740971, 0.682422, 0.623873, 0.565324, 0.506776, 0.448227, 0.389678, 0.331129, 0.272580, 0.214032, 1.755483, 1.696934, 1.638385, 1.579836, 1.521288, 1.462739, 1.404190, 1.345641, 1.287092, 1.228544, 1.169995, 1.111446, 1.052897, 0.994348, 0.935800, 0.877251, 0.818702, 0.760153, 0.701604, 0.643056, 0.584507, 0.525958, 0.467409, 0.408860, 0.350312, 0.291763, 0.233214, 1.774665, 1.716116, 1.657568, 1.599019, 1.540470, 1.481921, 1.423372, 1.364824, 1.306275, 1.247726, 1.189177, 1.130628, 1.072080, 1.013531, 0.954982, 0.896433, 0.837884, 0.779336, 0.720787, 0.662238, 0.603689, 0.545140, 0.486592, 0.428043, 0.369494, 0.310945, 0.252396, 1.793848, 1.735299, 1.676750, 1.618201, 1.559652, 1.501104, 1.442555, 1.384006, 1.325457, 1.266908, 1.208360, 1.149811, 1.091262, 1.032713, 0.974164, 0.915616, 0.857067, 0.798518, 0.739969, 0.681420, 0.622872, 0.564323, 0.505774, 0.447225, 0.388676, 0.330128, 0.271579, 0.213030, 1.754481, 1.695932, 1.637384, 1.578835, 1.520286, 1.461737, 1.403188, 1.344640, 1.286091, 1.227542, 1.168993, 1.110444, 1.051896, 0.993347, 0.934798, 0.876249, 0.817700, 0.759152, 0.700603, 0.642054, 0.583505, 0.524956, 0.466408, 0.407859, 0.349310, 0.290761, 0.232212, 1.773664, 1.715115, 1.656566, 1.598017, 1.539468, 1.480920, 1.422371, 1.363822, 1.305273, 1.246724, 1.188176, 1.129627, 1.071078, 1.012529, 0.953980, 0.895432, 0.836883, 0.778334, 0.719785, 0.661236, 0.602688, 0.544139, 0.485590, 0.427041, 0.368492, 0.309944, 0.251395, 1.792846, 1.734297, 1.675748, 1.617200, 1.558651, 1.500102, 1.441553, 1.383004, 1.324456, 1.265907, 1.207358, 1.148809, 1.090260, 1.031712, 0.973163, 0.914614, 0.856065, 0.797516, 0.738968, 0.680419, 0.621870, 0.563321, 0.504772, 0.446224, 0.387675, 0.329126, 0.270577, 0.212028, 1.753480, 1.694931, 1.636382, 1.577833, 1.519284, 1.460736, 1.402187, 1.343638, 1.285089, 1.226540, 1.167992, 1.109443, 1.050894, 0.992345, 0.933796, 0.875248, 0.816699, 0.758150, 0.699601, 0.641052, 0.582504, 0.523955, 0.465406, 0.406857, 0.348308, 0.289760, 0.231211, 1.772662, 1.714113, 1.655564, 1.597016, 1.538467, 1.479918, 1.421369, 1.362820, 1.304272, 1.245723, 1.187174, 1.128625, 1.070076, 1.011528, 0.952979, 0.894430, 0.835881, 0.777332, 0.718784, 0.660235, 0.601686, 0.543137, 0.484588, 0.426040, 0.367491, 0.308942, 0.250393, 1.791844, 1.733296, 1.674747, 1.616198, 1.557649, 1.499100, 1.440552, 1.382003, 1.323454, 1.264905, 1.206356, 1.147808, 1.089259, 1.030710, 0.972161, 0.913612, 0.855064, 0.796515, 0.737966, 0.679417, 0.620868, 0.562320, 0.503771, 0.445222, 0.386673, 0.328124, 0.269576, 0.211027, 1.752478, 1.693929, 1.635380, 1.576832, 1.518283, 1.459734, 1.401185, 1.342636, 1.284088, 1.225539, 1.166990, 1.108441, 1.049892, 0.991344, 0.932795, 0.874246, 0.815697, 0.757148, 0.698600, 0.640051, 0.581502, 0.522953, 0.464404, 0.405856, 0.347307, 0.288758, 0.230209, 1.771660, 1.713112, 1.654563, 1.596014, 1.537465, 1.478916, 1.420368, 1.361819, 1.303270, 1.244721, 1.186172, 1.127624, 1.069075, 1.010526, 0.951977, 0.893428, 0.834880, 0.776331, 0.717782, 0.659233, 0.600684, 0.542136, 0.483587, 0.425038, 0.366489, 0.307940, 0.249392, 1.790843, 1.732294, 1.673745, 1.615196, 1.556648, 1.498099, 1.439550, 1.381001, 1.322452, 1.263904, 1.205355, 1.146806, 1.088257, 1.029708, 0.971160, 0.912611, 0.854062, 0.795513, 0.736964, 0.678416, 0.619867, 0.561318, 0.502769, 0.444220, 0.385672, 0.327123, 0.268574, 0.210025, 1.751476, 1.692928, 1.634379, 1.575830, 1.517281, 1.458732, 1.400184, 1.341635, 1.283086, 1.224537, 1.165988, 1.107440, 1.048891, 0.990342, 0.931793, 0.873244, 0.814696, 0.756147, 0.697598, 0.639049, 0.580500, 0.521952, 0.463403, 0.404854, 0.346305, 0.287756, 0.229208, 1.770659, 1.712110, 1.653561, 1.595012, 1.536464, 1.477915, 1.419366, 1.360817, 1.302268, 1.243720, 1.185171, 1.126622, 1.068073, 1.009524, 0.950976, 0.892427, 0.833878, 0.775329, 0.716780, 0.658232, 0.599683, 0.541134, 0.482585, 0.424036, 0.365488, 0.306939, 0.248390, 1.789841, 1.731292, 1.672744, 1.614195, 1.555646, 1.497097, 1.438548, 1.380000, 1.321451, 1.262902, 1.204353, 1.145804, 1.087256, 1.028707, 0.970158, 0.911609, 0.853060, 0.794512, 0.735963, 0.677414, 0.618865, 0.560316, 0.501768, 0.443219, 0.384670, 0.326121, 0.267572, 0.209024, 1.750475, 1.691926, 1.633377, 1.574828, 1.516280, 1.457731, 1.399182, 1.340633, 1.282084, 1.223536, 1.164987, 1.106438, 1.047889, 0.989340, 0.930792, 0.872243, 0.813694, 0.755145, 0.696596, 0.638048, 0.579499, 0.520950, 0.462401, 0.403852, 0.345304, 0.286755, 0.228206, 1.769657, 1.711108, 1.652560, 1.594011, 1.535462, 1.476913, 1.418364, 1.359816, 1.301267, 1.242718, 1.184169, 1.125620, 1.067072, 1.008523, 0.949974, 0.891425, 0.832876, 0.774328, 0.715779, 0.657230, 0.598681, 0.540132, 0.481584, 0.423035, 0.364486, 0.305937, 0.247388, 1.788840, 1.730291, 1.671742, 1.613193, 1.554644, 1.496096, 1.437547, 1.378998, 1.320449, 1.261900, 1.203352, 1.144803, 1.086254, 1.027705, 0.969156, 0.910608, 0.852059, 0.793510, 0.734961, 0.676412, 0.617864, 0.559315, 0.500766, 0.442217, 0.383668, 0.325120, 0.266571, 0.208022, 1.749473, 1.690924, 1.632376, 1.573827, 1.515278, 1.456729, 1.398180, 1.339632, 1.281083, 1.222534, 1.163985, 1.105436, 1.046888, 0.988339, 0.929790, 0.871241, 0.812692, 0.754144, 0.695595, 0.637046, 0.578497, 0.519948, 0.461400, 0.402851, 0.344302, 0.285753, 0.227204, 1.768656, 1.710107, 1.651558, 1.593009, 1.534460, 1.475912, 1.417363, 1.358814, 1.300265, 1.241716, 1.183168, 1.124619, 1.066070, 1.007521, 0.948972, 0.890424, 0.831875, 0.773326, 0.714777, 0.656228, 0.597680, 0.539131, 0.480582, 0.422033, 0.363484, 0.304936, 0.246387, 1.787838, 1.729289, 1.670740, 1.612192, 1.553643, 1.495094, 1.436545, 1.377996, 1.319448, 1.260899, 1.202350, 1.143801, 1.085252, 1.026704, 0.968155, 0.909606, 0.851057, 0.792508, 0.733960, 0.675411, 0.616862, 0.558313, 0.499764, 0.441216, 0.382667, 0.324118, 0.265569, 0.207020, 1.748472, 1.689923, 1.631374, 1.572825, 1.514276, 1.455728, 1.397179, 1.338630, 1.280081, 1.221532, 1.162984, 1.104435, 1.045886, 0.987337, 0.928788, 0.870240, 0.811691, 0.753142, 0.694593, 0.636044, 0.577496]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 0.582371 0.523822 0.465273 0.406724 0.348176 0.289627 0.231078 1.772529 1.713980 1.655432 1.596883 1.538334 1.479785 1.421236 1.362688 1.304139 1.245590 1.187041 1.128492 1.069944 1.011395 0.952846 0.894297 0.835748 0.777200 0.718651 0.660102 0.601553 0.543004 0.484456 0.425907 0.367358 0.308809 0.250260 1.791712 1.733163 #[0.858987, 0.800438, 0.741889, 0.683340, 0.624792, 0.566243, 0.507694, 0.449145, 0.390596, 0.332048, 0.273499, 0.214950, 1.756401, 1.697852, 1.639304, 1.580755] #[0.858987, 0.800438, 0.741889, 0.683340, 0.624792, 0.566243, 0.507694, 0.449145, 0.390596, 0.332048, 0.273499, 0.214950, 1.756401, 1.697852, 1.639304, 1.580755] #[0.858987, 0.800438, 0.741889, 0.683340, 0.624792, 0.566243, 0.507694, 0.449145, 0.390596, 0.332048, 0.273499, 0.214950, 1.756401, 1.697852, 1.639304, 1.580755, 1.522206, 1.463657, 1.405108, 1.346560, 1.288011, 1.229462, 1.170913, 1.112364, 1.053816, 0.995267, 0.936718, 0.878169, 0.819620, 0.761072, 0.702523, 0.643974, 0.585425, 0.526876, 0.468328, 0.409779, 0.351230, 0.292681, 0.234132, 1.775584, 1.717035, 1.658486, 1.599937, 1.541388, 1.482840, 1.424291, 1.365742, 1.307193, 1.248644, 1.190096, 1.131547, 1.072998, 1.014449, 0.955900, 0.897352, 0.838803, 0.780254, 0.721705, 0.663156, 0.604608, 0.546059, 0.487510, 0.428961, 0.370412, 0.311864, 0.253315, 1.794766, 1.736217, 1.677668, 1.619120, 1.560571, 1.502022, 1.443473, 1.384924, 1.326376, 1.267827, 1.209278, 1.150729, 1.092180, 1.033632, 0.975083, 0.916534, 0.857985, 0.799436, 0.740888, 0.682339, 0.623790, 0.565241, 0.506692, 0.448144, 0.389595, 0.331046, 0.272497, 0.213948, 1.755400, 1.696851, 1.638302, 1.579753, 1.521204, 1.462656, 1.404107, 1.345558, 1.287009, 1.228460, 1.169912, 1.111363, 1.052814, 0.994265, 0.935716, 0.877168, 0.818619, 0.760070, 0.701521, 0.642972, 0.584424, 0.525875, 0.467326, 0.408777, 0.350228, 0.291680, 0.233131, 1.774582, 1.716033, 1.657484, 1.598936, 1.540387, 1.481838, 1.423289, 1.364740, 1.306192, 1.247643, 1.189094, 1.130545, 1.071996, 1.013448, 0.954899, 0.896350, 0.837801, 0.779252, 0.720704, 0.662155, 0.603606, 0.545057, 0.486508, 0.427960, 0.369411, 0.310862, 0.252313, 1.793764, 1.735216, 1.676667, 1.618118, 1.559569, 1.501020, 1.442472, 1.383923, 1.325374, 1.266825, 1.208276, 1.149728, 1.091179, 1.032630, 0.974081, 0.915532, 0.856984, 0.798435, 0.739886, 0.681337, 0.622788, 0.564240, 0.505691, 0.447142, 0.388593, 0.330044, 0.271496, 0.212947, 1.754398, 1.695849, 1.637300, 1.578752, 1.520203, 1.461654, 1.403105, 1.344556, 1.286008, 1.227459, 1.168910, 1.110361, 1.051812, 0.993264, 0.934715, 0.876166, 0.817617, 0.759068, 0.700520, 0.641971, 0.583422, 0.524873, 0.466324, 0.407776, 0.349227, 0.290678, 0.232129, 1.773580, 1.715032, 1.656483, 1.597934, 1.539385, 1.480836, 1.422288, 1.363739, 1.305190, 1.246641, 1.188092, 1.129544, 1.070995, 1.012446, 0.953897, 0.895348, 0.836800, 0.778251, 0.719702, 0.661153, 0.602604, 0.544056, 0.485507, 0.426958, 0.368409, 0.309860, 0.251312, 1.792763, 1.734214, 1.675665, 1.617116, 1.558568, 1.500019, 1.441470, 1.382921, 1.324372, 1.265824, 1.207275, 1.148726, 1.090177, 1.031628, 0.973080, 0.914531, 0.855982, 0.797433, 0.738884, 0.680336, 0.621787, 0.563238, 0.504689, 0.446140, 0.387592, 0.329043, 0.270494, 0.211945, 1.753396, 1.694848, 1.636299, 1.577750, 1.519201, 1.460652, 1.402104, 1.343555, 1.285006, 1.226457, 1.167908, 1.109360, 1.050811, 0.992262, 0.933713, 0.875164, 0.816616, 0.758067, 0.699518, 0.640969, 0.582420, 0.523872, 0.465323, 0.406774, 0.348225, 0.289676, 0.231128, 1.772579, 1.714030, 1.655481, 1.596932, 1.538384, 1.479835, 1.421286, 1.362737, 1.304188, 1.245640, 1.187091, 1.128542, 1.069993, 1.011444, 0.952896, 0.894347, 0.835798, 0.777249, 0.718700, 0.660152, 0.601603, 0.543054, 0.484505, 0.425956, 0.367408, 0.308859, 0.250310, 1.791761, 1.733212, 1.674664, 1.616115, 1.557566, 1.499017, 1.440468, 1.381920, 1.323371, 1.264822, 1.206273, 1.147724, 1.089176, 1.030627, 0.972078, 0.913529, 0.854980, 0.796432, 0.737883, 0.679334, 0.620785, 0.562236, 0.503688, 0.445139, 0.386590, 0.328041, 0.269492, 0.210944, 1.752395, 1.693846, 1.635297, 1.576748, 1.518200, 1.459651, 1.401102, 1.342553, 1.284004, 1.225456, 1.166907, 1.108358, 1.049809, 0.991260, 0.932712, 0.874163, 0.815614, 0.757065, 0.698516, 0.639968, 0.581419, 0.522870, 0.464321, 0.405772, 0.347224, 0.288675, 0.230126, 1.771577, 1.713028, 1.654480, 1.595931, 1.537382, 1.478833, 1.420284, 1.361736, 1.303187, 1.244638, 1.186089, 1.127540, 1.068992, 1.010443, 0.951894, 0.893345, 0.834796, 0.776248, 0.717699, 0.659150, 0.600601, 0.542052, 0.483504, 0.424955, 0.366406, 0.307857, 0.249308, 1.790760, 1.732211, 1.673662, 1.615113, 1.556564, 1.498016, 1.439467, 1.380918, 1.322369, 1.263820, 1.205272, 1.146723, 1.088174, 1.029625, 0.971076, 0.912528, 0.853979, 0.795430, 0.736881, 0.678332, 0.619784, 0.561235, 0.502686, 0.444137, 0.385588, 0.327040, 0.268491, 0.209942, 1.751393, 1.692844, 1.634296, 1.575747, 1.517198, 1.458649, 1.400100, 1.341552, 1.283003, 1.224454, 1.165905, 1.107356, 1.048808, 0.990259, 0.931710, 0.873161, 0.814612, 0.756064, 0.697515, 0.638966, 0.580417, 0.521868, 0.463320, 0.404771, 0.346222, 0.287673, 0.229124, 1.770576, 1.712027, 1.653478, 1.594929, 1.536380, 1.477832, 1.419283, 1.360734, 1.302185, 1.243636, 1.185088, 1.126539, 1.067990, 1.009441, 0.950892, 0.892344, 0.833795, 0.775246, 0.716697, 0.658148, 0.599600, 0.541051, 0.482502, 0.423953, 0.365404, 0.306856, 0.248307, 1.789758, 1.731209, 1.672660, 1.614112, 1.555563, 1.497014, 1.438465, 1.379916, 1.321368, 1.262819, 1.204270, 1.145721, 1.087172, 1.028624, 0.970075, 0.911526, 0.852977, 0.794428, 0.735880, 0.677331, 0.618782, 0.560233, 0.501684, 0.443136, 0.384587, 0.326038, 0.267489, 0.208940, 1.750392, 1.691843, 1.633294, 1.574745, 1.516196, 1.457648, 1.399099, 1.340550, 1.282001, 1.223452, 1.164904, 1.106355, 1.047806, 0.989257, 0.930708, 0.872160, 0.813611, 0.755062, 0.696513, 0.637964, 0.579416, 0.520867, 0.462318, 0.403769, 0.345220, 0.286672, 0.228123, 1.769574, 1.711025, 1.652476, 1.593928, 1.535379, 1.476830, 1.418281, 1.359732, 1.301184, 1.242635, 1.184086, 1.125537, 1.066988, 1.008440, 0.949891, 0.891342, 0.832793, 0.774244, 0.715696, 0.657147, 0.598598, 0.540049, 0.481500, 0.422952, 0.364403, 0.305854, 0.247305, 1.788756, 1.730208, 1.671659, 1.613110, 1.554561, 1.496012, 1.437464, 1.378915, 1.320366, 1.261817, 1.203268, 1.144720, 1.086171, 1.027622, 0.969073, 0.910524, 0.851976, 0.793427, 0.734878, 0.676329, 0.617780, 0.559232, 0.500683, 0.442134, 0.383585, 0.325036, 0.266488, 0.207939, 1.749390, 1.690841, 1.632292, 1.573744, 1.515195, 1.456646, 1.398097, 1.339548, 1.281000, 1.222451, 1.163902, 1.105353, 1.046804, 0.988256, 0.929707, 0.871158, 0.812609, 0.754060, 0.695512, 0.636963, 0.578414, 0.519865, 0.461316, 0.402768, 0.344219, 0.285670, 0.227121, 1.768572, 1.710024, 1.651475, 1.592926, 1.534377, 1.475828, 1.417280, 1.358731, 1.300182, 1.241633, 1.183084, 1.124536, 1.065987, 1.007438, 0.948889, 0.890340, 0.831792, 0.773243, 0.714694, 0.656145, 0.597596, 0.539048, 0.480499, 0.421950, 0.363401, 0.304852, 0.246304]))

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
  let v2192 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); (if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && (((Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))) <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2195 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + ((dr[i * 10 + 2]! - v1993) * w)); let v2074 := (v1992 + ((dr[i * 10 + 3]! - v1993) * w)); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2167 := ((f - (v2075 + (v2134 * v2061))) / (v2152 / v2162)); (1.0 / (1.0 + Float.exp (-((rc - (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2)))) / (0.005 : Float))))))) 0.0)
  let v2213 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((0 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2218 := (((((v2213 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2229 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((1 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2234 := (((((v2229 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2245 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((2 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2250 := (((((v2245 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2262 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((3 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2267 := (((((v2262 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2279 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((4 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2284 := (((((v2279 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2296 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((5 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2301 := (((((v2296 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2313 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((6 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2318 := (((((v2313 / (64 : Float)) * v2185) * rho) * dni) * soil)
  let v2330 := ((List.range 64).foldl (fun acc i => acc + (let v1988 := (v1974 + (w * (Float.floor (dr[i * 10 + 0]! * v1971)))); let v1992 := (v1974 + (w * (Float.floor (dr[i * 10 + 1]! * v1971)))); let v1995 := ((dr[i * 10 + 2]! - v1993) * w); let v1997 := ((dr[i * 10 + 3]! - v1993) * w); let v2038 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2039 := (v890 * dr[i * 10 + 5]!); let v2040 := (Float.cos v2038); let v2042 := (Float.sin v2038); let v2043 := (Float.cos v2039); let v2045 := (Float.sin v2039); let v2049 := ((v2040 * v1998) + (v2042 * ((v2043 * v2025) + (v2045 * ((v1999 * v2027) - (v2000 * v2026)))))); let v2055 := ((v2040 * v1999) + (v2042 * ((v2043 * v2026) + (v2045 * ((v2000 * v2025) - (v1998 * v2027)))))); let v2061 := ((v2040 * v2000) + (v2042 * ((v2043 * v2027) + (v2045 * ((v1998 * v2026) - (v1999 * v2025)))))); let v2073 := (v1988 + v1995); let v2074 := (v1992 + v1997); let v2081 := (Float.sqrt (max ((v1988 ^ 2) + (v1992 ^ 2)) (0.000000000000000001 : Float))); let v2082 := (v2081 ^ 2); let v2088 := ((1 : Float) - ((((1 : Float) + k) * (v2076 ^ 2)) * v2082)); let v2096 := ((v2076 * v2081) / (Float.sqrt (max v2088 (0.000000000000000001 : Float)))); let v2099 := (Float.sqrt ((1 : Float) + (v2096 ^ 2))); let v2100 := (-v2096); let v2103 := (((v2100 * v1988) / v2081) / v2099); let v2106 := (((v2100 * v1992) / v2081) / v2099); let v2107 := ((1 : Float) / v2099); let v2109 := (v2103 + (sigmaslope * dr[i * 10 + 6]!)); let v2111 := (v2106 + (sigmaslope * dr[i * 10 + 7]!)); let v2117 := (Float.sqrt (((v2109 ^ 2) + (v2111 ^ 2)) + (v2107 ^ 2))); let v2118 := (v2109 / v2117); let v2119 := (v2111 / v2117); let v2120 := (v2107 / v2117); let v2134 := (((((v1988 - v2073) * v2103) + ((v1992 - v2074) * v2106)) + ((((v2076 * v2082) / ((1 : Float) + (Float.sqrt (max v2088 (0 : Float))))) - v2075) * v2107)) / (((v2049 * v2103) + (v2055 * v2106)) + (v2061 * v2107))); let v2146 := ((2 : Float) * (((v2049 * v2118) + (v2055 * v2119)) + (v2061 * v2120))); let v2152 := (v2061 - (v2146 * v2120)); let v2154 := ((v2049 - (v2146 * v2118)) + (sigmaspec * dr[i * 10 + 8]!)); let v2156 := ((v2055 - (v2146 * v2119)) + (sigmaspec * dr[i * 10 + 9]!)); let v2162 := (Float.sqrt (((v2154 ^ 2) + (v2156 ^ 2)) + (v2152 ^ 2))); let v2165 := (v2152 / v2162); let v2167 := ((f - (v2075 + (v2134 * v2061))) / v2165); let v2175 := (Float.sqrt ((((v2073 + (v2134 * v2049)) + (v2167 * (v2154 / v2162))) ^ 2) + (((v2074 + (v2134 * v2055)) + (v2167 * (v2156 / v2162))) ^ 2))); (if ((((((7 : Float) * rc) / (8 : Float)) <= v2175) && (v2175 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1988) <= a) && (((Float.abs v1992) <= a) && (((Float.abs v1995) <= v1973) && ((Float.abs v1997) <= v1973)))) && ((v2175 <= rc) && ((0 : Float) < v2165))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
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

#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.500147 0.441598 0.383049 0.324500 0.265952 0.207403 1.748854 1.690305 1.631756 1.573208 1.514659 1.456110 1.397561 1.339012 1.280464 1.221915 1.163366 1.104817 1.046268 0.987720 0.929171 0.870622 0.812073 0.753524 0.694976 0.636427 0.577878 0.519329 0.460780 0.402232 0.343683 0.285134 0.226585 1.768036 1.709488 1.650939 1.592390 1.533841 1.475292 #[0.776763, 0.718214, 0.659665, 0.601116, 0.542568, 0.484019, 0.425470, 0.366921, 0.308372, 0.249824, 1.791275, 1.732726, 1.674177, 1.615628, 1.557080, 1.498531, 1.439982, 1.381433, 1.322884, 1.264336, 1.205787, 1.147238, 1.088689, 1.030140, 0.971592, 0.913043, 0.854494, 0.795945, 0.737396, 0.678848, 0.620299, 0.561750, 0.503201, 0.444652, 0.386104, 0.327555, 0.269006, 0.210457, 1.751908, 1.693360, 1.634811, 1.576262, 1.517713, 1.459164, 1.400616, 1.342067, 1.283518, 1.224969, 1.166420, 1.107872, 1.049323, 0.990774, 0.932225, 0.873676, 0.815128, 0.756579, 0.698030, 0.639481, 0.580932, 0.522384, 0.463835, 0.405286, 0.346737, 0.288188, 0.229640, 1.771091, 1.712542, 1.653993, 1.595444, 1.536896, 1.478347, 1.419798, 1.361249, 1.302700, 1.244152, 1.185603, 1.127054, 1.068505, 1.009956, 0.951408, 0.892859, 0.834310, 0.775761, 0.717212, 0.658664, 0.600115, 0.541566, 0.483017, 0.424468, 0.365920, 0.307371, 0.248822, 1.790273, 1.731724, 1.673176, 1.614627, 1.556078, 1.497529, 1.438980, 1.380432, 1.321883, 1.263334, 1.204785, 1.146236, 1.087688, 1.029139, 0.970590, 0.912041, 0.853492, 0.794944, 0.736395, 0.677846, 0.619297, 0.560748, 0.502200, 0.443651, 0.385102, 0.326553, 0.268004, 0.209456, 1.750907, 1.692358, 1.633809, 1.575260, 1.516712, 1.458163, 1.399614, 1.341065] #[0.776763, 0.718214, 0.659665, 0.601116, 0.542568, 0.484019, 0.425470, 0.366921, 0.308372, 0.249824, 1.791275, 1.732726, 1.674177, 1.615628, 1.557080, 1.498531] #[0.776763, 0.718214, 0.659665, 0.601116, 0.542568, 0.484019, 0.425470, 0.366921, 0.308372, 0.249824, 1.791275, 1.732726, 1.674177, 1.615628, 1.557080, 1.498531, 1.439982, 1.381433, 1.322884, 1.264336, 1.205787, 1.147238, 1.088689, 1.030140, 0.971592, 0.913043, 0.854494, 0.795945, 0.737396, 0.678848, 0.620299, 0.561750] #[0.776763, 0.718214, 0.659665, 0.601116, 0.542568, 0.484019, 0.425470, 0.366921, 0.308372, 0.249824, 1.791275, 1.732726, 1.674177, 1.615628, 1.557080, 1.498531] #[0.776763, 0.718214, 0.659665, 0.601116, 0.542568, 0.484019, 0.425470, 0.366921, 0.308372, 0.249824, 1.791275, 1.732726, 1.674177, 1.615628, 1.557080, 1.498531] #[0.776763, 0.718214, 0.659665, 0.601116, 0.542568, 0.484019, 0.425470, 0.366921, 0.308372, 0.249824, 1.791275, 1.732726, 1.674177, 1.615628, 1.557080, 1.498531, 1.439982, 1.381433, 1.322884, 1.264336, 1.205787, 1.147238, 1.088689, 1.030140, 0.971592, 0.913043, 0.854494, 0.795945, 0.737396, 0.678848, 0.620299, 0.561750, 0.503201, 0.444652, 0.386104, 0.327555, 0.269006, 0.210457, 1.751908, 1.693360, 1.634811, 1.576262, 1.517713, 1.459164, 1.400616, 1.342067, 1.283518, 1.224969, 1.166420, 1.107872, 1.049323, 0.990774, 0.932225, 0.873676, 0.815128, 0.756579, 0.698030, 0.639481, 0.580932, 0.522384, 0.463835, 0.405286, 0.346737, 0.288188, 0.229640, 1.771091, 1.712542, 1.653993, 1.595444, 1.536896, 1.478347, 1.419798, 1.361249, 1.302700, 1.244152, 1.185603, 1.127054, 1.068505, 1.009956, 0.951408, 0.892859, 0.834310, 0.775761, 0.717212, 0.658664, 0.600115, 0.541566, 0.483017, 0.424468, 0.365920, 0.307371, 0.248822, 1.790273, 1.731724, 1.673176, 1.614627, 1.556078, 1.497529, 1.438980, 1.380432, 1.321883, 1.263334, 1.204785, 1.146236, 1.087688, 1.029139, 0.970590, 0.912041, 0.853492, 0.794944, 0.736395, 0.677846, 0.619297, 0.560748, 0.502200, 0.443651, 0.385102, 0.326553, 0.268004, 0.209456, 1.750907, 1.692358, 1.633809, 1.575260, 1.516712, 1.458163, 1.399614, 1.341065, 1.282516, 1.223968, 1.165419, 1.106870, 1.048321, 0.989772, 0.931224, 0.872675, 0.814126, 0.755577, 0.697028, 0.638480, 0.579931, 0.521382, 0.462833, 0.404284, 0.345736, 0.287187, 0.228638, 1.770089, 1.711540, 1.652992, 1.594443, 1.535894, 1.477345, 1.418796, 1.360248, 1.301699, 1.243150, 1.184601, 1.126052, 1.067504, 1.008955, 0.950406, 0.891857, 0.833308, 0.774760, 0.716211, 0.657662, 0.599113, 0.540564, 0.482016, 0.423467, 0.364918, 0.306369, 0.247820, 1.789272, 1.730723, 1.672174, 1.613625, 1.555076, 1.496528, 1.437979, 1.379430, 1.320881, 1.262332, 1.203784, 1.145235, 1.086686, 1.028137, 0.969588, 0.911040, 0.852491, 0.793942, 0.735393, 0.676844, 0.618296, 0.559747, 0.501198, 0.442649, 0.384100, 0.325552, 0.267003, 0.208454, 1.749905, 1.691356, 1.632808, 1.574259, 1.515710, 1.457161, 1.398612, 1.340064, 1.281515, 1.222966, 1.164417, 1.105868, 1.047320, 0.988771, 0.930222, 0.871673, 0.813124, 0.754576, 0.696027, 0.637478, 0.578929, 0.520380, 0.461832, 0.403283, 0.344734, 0.286185, 0.227636, 1.769088, 1.710539, 1.651990, 1.593441, 1.534892, 1.476344, 1.417795, 1.359246, 1.300697, 1.242148, 1.183600, 1.125051, 1.066502, 1.007953, 0.949404, 0.890856, 0.832307, 0.773758, 0.715209, 0.656660, 0.598112, 0.539563, 0.481014, 0.422465, 0.363916, 0.305368, 0.246819, 1.788270, 1.729721, 1.671172, 1.612624, 1.554075, 1.495526, 1.436977, 1.378428, 1.319880, 1.261331, 1.202782, 1.144233, 1.085684, 1.027136, 0.968587, 0.910038, 0.851489, 0.792940, 0.734392, 0.675843, 0.617294, 0.558745, 0.500196, 0.441648, 0.383099, 0.324550, 0.266001, 0.207452, 1.748904, 1.690355, 1.631806, 1.573257, 1.514708, 1.456160, 1.397611, 1.339062, 1.280513, 1.221964, 1.163416, 1.104867, 1.046318, 0.987769, 0.929220, 0.870672, 0.812123, 0.753574, 0.695025, 0.636476, 0.577928, 0.519379, 0.460830, 0.402281, 0.343732, 0.285184, 0.226635, 1.768086, 1.709537, 1.650988, 1.592440, 1.533891, 1.475342, 1.416793, 1.358244, 1.299696, 1.241147, 1.182598, 1.124049, 1.065500, 1.006952, 0.948403, 0.889854, 0.831305, 0.772756, 0.714208, 0.655659, 0.597110, 0.538561, 0.480012, 0.421464, 0.362915, 0.304366, 0.245817, 1.787268, 1.728720, 1.670171, 1.611622, 1.553073, 1.494524, 1.435976, 1.377427, 1.318878, 1.260329, 1.201780, 1.143232, 1.084683, 1.026134, 0.967585, 0.909036, 0.850488, 0.791939, 0.733390, 0.674841, 0.616292, 0.557744, 0.499195, 0.440646, 0.382097, 0.323548, 0.265000, 0.206451, 1.747902, 1.689353, 1.630804, 1.572256, 1.513707, 1.455158, 1.396609, 1.338060, 1.279512, 1.220963, 1.162414, 1.103865, 1.045316, 0.986768, 0.928219, 0.869670, 0.811121, 0.752572, 0.694024, 0.635475, 0.576926, 0.518377, 0.459828, 0.401280, 0.342731, 0.284182, 0.225633, 1.767084, 1.708536, 1.649987, 1.591438, 1.532889, 1.474340, 1.415792, 1.357243, 1.298694, 1.240145, 1.181596, 1.123048, 1.064499, 1.005950, 0.947401, 0.888852, 0.830304, 0.771755, 0.713206, 0.654657, 0.596108, 0.537560, 0.479011, 0.420462, 0.361913, 0.303364, 0.244816, 1.786267, 1.727718, 1.669169, 1.610620, 1.552072, 1.493523, 1.434974, 1.376425, 1.317876, 1.259328, 1.200779, 1.142230, 1.083681, 1.025132, 0.966584, 0.908035, 0.849486, 0.790937, 0.732388, 0.673840, 0.615291, 0.556742, 0.498193, 0.439644, 0.381096, 0.322547, 0.263998, 0.205449, 1.746900, 1.688352, 1.629803, 1.571254, 1.512705, 1.454156, 1.395608, 1.337059, 1.278510, 1.219961, 1.161412, 1.102864, 1.044315, 0.985766, 0.927217, 0.868668, 0.810120, 0.751571, 0.693022, 0.634473, 0.575924, 0.517376, 0.458827, 0.400278, 0.341729, 0.283180, 0.224632, 1.766083, 1.707534, 1.648985, 1.590436, 1.531888, 1.473339, 1.414790, 1.356241, 1.297692, 1.239144, 1.180595, 1.122046, 1.063497, 1.004948, 0.946400, 0.887851, 0.829302, 0.770753, 0.712204, 0.653656, 0.595107, 0.536558, 0.478009, 0.419460, 0.360912, 0.302363, 0.243814, 1.785265, 1.726716, 1.668168, 1.609619, 1.551070, 1.492521, 1.433972, 1.375424, 1.316875, 1.258326, 1.199777, 1.141228, 1.082680, 1.024131, 0.965582, 0.907033, 0.848484, 0.789936, 0.731387, 0.672838, 0.614289, 0.555740, 0.497192, 0.438643, 0.380094, 0.321545, 0.262996, 0.204448, 1.745899, 1.687350, 1.628801, 1.570252, 1.511704, 1.453155, 1.394606, 1.336057, 1.277508, 1.218960, 1.160411, 1.101862, 1.043313, 0.984764, 0.926216, 0.867667, 0.809118, 0.750569, 0.692020, 0.633472, 0.574923, 0.516374, 0.457825, 0.399276, 0.340728, 0.282179, 0.223630, 1.765081, 1.706532, 1.647984, 1.589435, 1.530886, 1.472337, 1.413788, 1.355240, 1.296691, 1.238142, 1.179593, 1.121044, 1.062496, 1.003947, 0.945398, 0.886849, 0.828300, 0.769752, 0.711203, 0.652654, 0.594105, 0.535556, 0.477008, 0.418459, 0.359910, 0.301361, 0.242812, 1.784264, 1.725715, 1.667166, 1.608617, 1.550068, 1.491520, 1.432971, 1.374422, 1.315873, 1.257324, 1.198776, 1.140227, 1.081678, 1.023129, 0.964580, 0.906032, 0.847483, 0.788934, 0.730385, 0.671836, 0.613288, 0.554739, 0.496190, 0.437641, 0.379092, 0.320544, 0.261995, 0.203446, 1.744897, 1.686348, 1.627800, 1.569251, 1.510702, 1.452153, 1.393604, 1.335056, 1.276507, 1.217958, 1.159409, 1.100860, 1.042312, 0.983763, 0.925214, 0.866665, 0.808116, 0.749568, 0.691019, 0.632470, 0.573921, 0.515372, 0.456824, 0.398275, 0.339726, 0.281177, 0.222628, 1.764080]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.768955 1.710406 1.651857 1.593308 1.534760 1.476211 1.417662 1.359113 1.300564 1.242016 1.183467 1.124918 1.066369 1.007820 0.949272 0.890723 0.832174 0.773625 0.715076 0.656528 0.597979 0.539430 0.480881 0.422332 0.363784 0.305235 0.246686 1.788137 1.729588 1.671040 1.612491 1.553942 1.495393 1.436844 1.378296 1.319747 1.261198 1.202649 1.144100 #[0.445571, 0.387022, 0.328473, 0.269924, 0.211376, 1.752827, 1.694278, 1.635729, 1.577180, 1.518632, 1.460083, 1.401534, 1.342985, 1.284436, 1.225888, 1.167339, 1.108790, 1.050241, 0.991692, 0.933144, 0.874595, 0.816046, 0.757497, 0.698948, 0.640400, 0.581851, 0.523302, 0.464753, 0.406204, 0.347656, 0.289107, 0.230558, 1.772009, 1.713460, 1.654912, 1.596363, 1.537814, 1.479265, 1.420716, 1.362168, 1.303619, 1.245070, 1.186521, 1.127972, 1.069424, 1.010875, 0.952326, 0.893777, 0.835228, 0.776680, 0.718131, 0.659582, 0.601033, 0.542484, 0.483936, 0.425387, 0.366838, 0.308289, 0.249740, 1.791192, 1.732643, 1.674094, 1.615545, 1.556996, 1.498448, 1.439899, 1.381350, 1.322801, 1.264252, 1.205704, 1.147155, 1.088606, 1.030057, 0.971508, 0.912960, 0.854411, 0.795862, 0.737313, 0.678764, 0.620216, 0.561667, 0.503118, 0.444569, 0.386020, 0.327472, 0.268923, 0.210374, 1.751825, 1.693276, 1.634728, 1.576179, 1.517630, 1.459081, 1.400532, 1.341984, 1.283435, 1.224886, 1.166337, 1.107788, 1.049240, 0.990691, 0.932142, 0.873593, 0.815044, 0.756496, 0.697947, 0.639398, 0.580849, 0.522300, 0.463752, 0.405203, 0.346654, 0.288105, 0.229556, 1.771008, 1.712459, 1.653910, 1.595361, 1.536812, 1.478264, 1.419715, 1.361166, 1.302617, 1.244068, 1.185520, 1.126971, 1.068422, 1.009873] #[0.445571, 0.387022, 0.328473, 0.269924, 0.211376, 1.752827, 1.694278, 1.635729, 1.577180, 1.518632, 1.460083, 1.401534, 1.342985, 1.284436, 1.225888, 1.167339] #[0.445571, 0.387022, 0.328473, 0.269924, 0.211376, 1.752827, 1.694278, 1.635729, 1.577180, 1.518632, 1.460083, 1.401534, 1.342985, 1.284436, 1.225888, 1.167339, 1.108790, 1.050241, 0.991692, 0.933144, 0.874595, 0.816046, 0.757497, 0.698948, 0.640400, 0.581851, 0.523302, 0.464753, 0.406204, 0.347656, 0.289107, 0.230558] #[0.445571, 0.387022, 0.328473, 0.269924, 0.211376, 1.752827, 1.694278, 1.635729, 1.577180, 1.518632, 1.460083, 1.401534, 1.342985, 1.284436, 1.225888, 1.167339] #[0.445571, 0.387022, 0.328473, 0.269924, 0.211376, 1.752827, 1.694278, 1.635729, 1.577180, 1.518632, 1.460083, 1.401534, 1.342985, 1.284436, 1.225888, 1.167339] #[0.445571, 0.387022, 0.328473, 0.269924, 0.211376, 1.752827, 1.694278, 1.635729, 1.577180, 1.518632, 1.460083, 1.401534, 1.342985, 1.284436, 1.225888, 1.167339, 1.108790, 1.050241, 0.991692, 0.933144, 0.874595, 0.816046, 0.757497, 0.698948, 0.640400, 0.581851, 0.523302, 0.464753, 0.406204, 0.347656, 0.289107, 0.230558, 1.772009, 1.713460, 1.654912, 1.596363, 1.537814, 1.479265, 1.420716, 1.362168, 1.303619, 1.245070, 1.186521, 1.127972, 1.069424, 1.010875, 0.952326, 0.893777, 0.835228, 0.776680, 0.718131, 0.659582, 0.601033, 0.542484, 0.483936, 0.425387, 0.366838, 0.308289, 0.249740, 1.791192, 1.732643, 1.674094, 1.615545, 1.556996, 1.498448, 1.439899, 1.381350, 1.322801, 1.264252, 1.205704, 1.147155, 1.088606, 1.030057, 0.971508, 0.912960, 0.854411, 0.795862, 0.737313, 0.678764, 0.620216, 0.561667, 0.503118, 0.444569, 0.386020, 0.327472, 0.268923, 0.210374, 1.751825, 1.693276, 1.634728, 1.576179, 1.517630, 1.459081, 1.400532, 1.341984, 1.283435, 1.224886, 1.166337, 1.107788, 1.049240, 0.990691, 0.932142, 0.873593, 0.815044, 0.756496, 0.697947, 0.639398, 0.580849, 0.522300, 0.463752, 0.405203, 0.346654, 0.288105, 0.229556, 1.771008, 1.712459, 1.653910, 1.595361, 1.536812, 1.478264, 1.419715, 1.361166, 1.302617, 1.244068, 1.185520, 1.126971, 1.068422, 1.009873, 0.951324, 0.892776, 0.834227, 0.775678, 0.717129, 0.658580, 0.600032, 0.541483, 0.482934, 0.424385, 0.365836, 0.307288, 0.248739, 1.790190, 1.731641, 1.673092, 1.614544, 1.555995, 1.497446, 1.438897, 1.380348, 1.321800, 1.263251, 1.204702, 1.146153, 1.087604, 1.029056, 0.970507, 0.911958, 0.853409, 0.794860, 0.736312, 0.677763, 0.619214, 0.560665, 0.502116, 0.443568, 0.385019, 0.326470, 0.267921, 0.209372, 1.750824, 1.692275, 1.633726, 1.575177, 1.516628, 1.458080, 1.399531, 1.340982, 1.282433, 1.223884, 1.165336, 1.106787, 1.048238, 0.989689, 0.931140, 0.872592, 0.814043, 0.755494, 0.696945, 0.638396, 0.579848, 0.521299, 0.462750, 0.404201, 0.345652, 0.287104, 0.228555, 1.770006, 1.711457, 1.652908, 1.594360, 1.535811, 1.477262, 1.418713, 1.360164, 1.301616, 1.243067, 1.184518, 1.125969, 1.067420, 1.008872, 0.950323, 0.891774, 0.833225, 0.774676, 0.716128, 0.657579, 0.599030, 0.540481, 0.481932, 0.423384, 0.364835, 0.306286, 0.247737, 1.789188, 1.730640, 1.672091, 1.613542, 1.554993, 1.496444, 1.437896, 1.379347, 1.320798, 1.262249, 1.203700, 1.145152, 1.086603, 1.028054, 0.969505, 0.910956, 0.852408, 0.793859, 0.735310, 0.676761, 0.618212, 0.559664, 0.501115, 0.442566, 0.384017, 0.325468, 0.266920, 0.208371, 1.749822, 1.691273, 1.632724, 1.574176, 1.515627, 1.457078, 1.398529, 1.339980, 1.281432, 1.222883, 1.164334, 1.105785, 1.047236, 0.988688, 0.930139, 0.871590, 0.813041, 0.754492, 0.695944, 0.637395, 0.578846, 0.520297, 0.461748, 0.403200, 0.344651, 0.286102, 0.227553, 1.769004, 1.710456, 1.651907, 1.593358, 1.534809, 1.476260, 1.417712, 1.359163, 1.300614, 1.242065, 1.183516, 1.124968, 1.066419, 1.007870, 0.949321, 0.890772, 0.832224, 0.773675, 0.715126, 0.656577, 0.598028, 0.539480, 0.480931, 0.422382, 0.363833, 0.305284, 0.246736, 1.788187, 1.729638, 1.671089, 1.612540, 1.553992, 1.495443, 1.436894, 1.378345, 1.319796, 1.261248, 1.202699, 1.144150, 1.085601, 1.027052, 0.968504, 0.909955, 0.851406, 0.792857, 0.734308, 0.675760, 0.617211, 0.558662, 0.500113, 0.441564, 0.383016, 0.324467, 0.265918, 0.207369, 1.748820, 1.690272, 1.631723, 1.573174, 1.514625, 1.456076, 1.397528, 1.338979, 1.280430, 1.221881, 1.163332, 1.104784, 1.046235, 0.987686, 0.929137, 0.870588, 0.812040, 0.753491, 0.694942, 0.636393, 0.577844, 0.519296, 0.460747, 0.402198, 0.343649, 0.285100, 0.226552, 1.768003, 1.709454, 1.650905, 1.592356, 1.533808, 1.475259, 1.416710, 1.358161, 1.299612, 1.241064, 1.182515, 1.123966, 1.065417, 1.006868, 0.948320, 0.889771, 0.831222, 0.772673, 0.714124, 0.655576, 0.597027, 0.538478, 0.479929, 0.421380, 0.362832, 0.304283, 0.245734, 1.787185, 1.728636, 1.670088, 1.611539, 1.552990, 1.494441, 1.435892, 1.377344, 1.318795, 1.260246, 1.201697, 1.143148, 1.084600, 1.026051, 0.967502, 0.908953, 0.850404, 0.791856, 0.733307, 0.674758, 0.616209, 0.557660, 0.499112, 0.440563, 0.382014, 0.323465, 0.264916, 0.206368, 1.747819, 1.689270, 1.630721, 1.572172, 1.513624, 1.455075, 1.396526, 1.337977, 1.279428, 1.220880, 1.162331, 1.103782, 1.045233, 0.986684, 0.928136, 0.869587, 0.811038, 0.752489, 0.693940, 0.635392, 0.576843, 0.518294, 0.459745, 0.401196, 0.342648, 0.284099, 0.225550, 1.767001, 1.708452, 1.649904, 1.591355, 1.532806, 1.474257, 1.415708, 1.357160, 1.298611, 1.240062, 1.181513, 1.122964, 1.064416, 1.005867, 0.947318, 0.888769, 0.830220, 0.771672, 0.713123, 0.654574, 0.596025, 0.537476, 0.478928, 0.420379, 0.361830, 0.303281, 0.244732, 1.786184, 1.727635, 1.669086, 1.610537, 1.551988, 1.493440, 1.434891, 1.376342, 1.317793, 1.259244, 1.200696, 1.142147, 1.083598, 1.025049, 0.966500, 0.907952, 0.849403, 0.790854, 0.732305, 0.673756, 0.615208, 0.556659, 0.498110, 0.439561, 0.381012, 0.322464, 0.263915, 0.205366, 1.746817, 1.688268, 1.629720, 1.571171, 1.512622, 1.454073, 1.395524, 1.336976, 1.278427, 1.219878, 1.161329, 1.102780, 1.044232, 0.985683, 0.927134, 0.868585, 0.810036, 0.751488, 0.692939, 0.634390, 0.575841, 0.517292, 0.458744, 0.400195, 0.341646, 0.283097, 0.224548, 1.766000, 1.707451, 1.648902, 1.590353, 1.531804, 1.473256, 1.414707, 1.356158, 1.297609, 1.239060, 1.180512, 1.121963, 1.063414, 1.004865, 0.946316, 0.887768, 0.829219, 0.770670, 0.712121, 0.653572, 0.595024, 0.536475, 0.477926, 0.419377, 0.360828, 0.302280, 0.243731, 1.785182, 1.726633, 1.668084, 1.609536, 1.550987, 1.492438, 1.433889, 1.375340, 1.316792, 1.258243, 1.199694, 1.141145, 1.082596, 1.024048, 0.965499, 0.906950, 0.848401, 0.789852, 0.731304, 0.672755, 0.614206, 0.555657, 0.497108, 0.438560, 0.380011, 0.321462, 0.262913, 0.204364, 1.745816, 1.687267, 1.628718, 1.570169, 1.511620, 1.453072, 1.394523, 1.335974, 1.277425, 1.218876, 1.160328, 1.101779, 1.043230, 0.984681, 0.926132, 0.867584, 0.809035, 0.750486, 0.691937, 0.633388, 0.574840, 0.516291, 0.457742, 0.399193, 0.340644, 0.282096, 0.223547, 1.764998, 1.706449, 1.647900, 1.589352, 1.530803, 1.472254, 1.413705, 1.355156, 1.296608, 1.238059, 1.179510, 1.120961, 1.062412, 1.003864, 0.945315, 0.886766, 0.828217, 0.769668, 0.711120, 0.652571, 0.594022, 0.535473, 0.476924, 0.418376, 0.359827, 0.301278, 0.242729, 1.784180, 1.725632, 1.667083, 1.608534, 1.549985, 1.491436, 1.432888]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.437763 1.379214 1.320665 1.262116 1.203568 1.145019 1.086470 1.027921 0.969372 0.910824 0.852275 0.793726 0.735177 0.676628 0.618080 0.559531 0.500982 0.442433 0.383884 0.325336 0.266787 0.208238 1.749689 1.691140 1.632592 1.574043 1.515494 1.456945 1.398396 1.339848 1.281299 1.222750 1.164201 1.105652 1.047104 0.988555 0.930006 0.871457 0.812908 #[1.714379, 1.655830, 1.597281, 1.538732, 1.480184, 1.421635, 1.363086, 1.304537, 1.245988, 1.187440, 1.128891, 1.070342, 1.011793, 0.953244, 0.894696, 0.836147, 0.777598, 0.719049, 0.660500, 0.601952, 0.543403, 0.484854, 0.426305, 0.367756, 0.309208, 0.250659, 1.792110, 1.733561, 1.675012, 1.616464, 1.557915, 1.499366, 1.440817, 1.382268, 1.323720, 1.265171, 1.206622, 1.148073, 1.089524, 1.030976, 0.972427, 0.913878, 0.855329, 0.796780, 0.738232, 0.679683, 0.621134, 0.562585, 0.504036, 0.445488, 0.386939, 0.328390, 0.269841, 0.211292, 1.752744, 1.694195, 1.635646, 1.577097, 1.518548, 1.460000, 1.401451, 1.342902, 1.284353, 1.225804, 1.167256, 1.108707, 1.050158, 0.991609, 0.933060, 0.874512, 0.815963, 0.757414, 0.698865, 0.640316, 0.581768, 0.523219, 0.464670, 0.406121, 0.347572, 0.289024, 0.230475, 1.771926, 1.713377, 1.654828, 1.596280, 1.537731, 1.479182, 1.420633, 1.362084, 1.303536, 1.244987, 1.186438, 1.127889, 1.069340, 1.010792, 0.952243, 0.893694, 0.835145, 0.776596, 0.718048, 0.659499, 0.600950, 0.542401, 0.483852, 0.425304, 0.366755, 0.308206, 0.249657, 1.791108, 1.732560, 1.674011, 1.615462, 1.556913, 1.498364, 1.439816, 1.381267, 1.322718, 1.264169, 1.205620, 1.147072, 1.088523, 1.029974, 0.971425, 0.912876, 0.854328, 0.795779, 0.737230, 0.678681] #[1.714379, 1.655830, 1.597281, 1.538732, 1.480184, 1.421635, 1.363086, 1.304537, 1.245988, 1.187440, 1.128891, 1.070342, 1.011793, 0.953244, 0.894696, 0.836147] #[1.714379, 1.655830, 1.597281, 1.538732, 1.480184, 1.421635, 1.363086, 1.304537, 1.245988, 1.187440, 1.128891, 1.070342, 1.011793, 0.953244, 0.894696, 0.836147, 0.777598, 0.719049, 0.660500, 0.601952, 0.543403, 0.484854, 0.426305, 0.367756, 0.309208, 0.250659, 1.792110, 1.733561, 1.675012, 1.616464, 1.557915, 1.499366] #[1.714379, 1.655830, 1.597281, 1.538732, 1.480184, 1.421635, 1.363086, 1.304537, 1.245988, 1.187440, 1.128891, 1.070342, 1.011793, 0.953244, 0.894696, 0.836147] #[1.714379, 1.655830, 1.597281, 1.538732, 1.480184, 1.421635, 1.363086, 1.304537, 1.245988, 1.187440, 1.128891, 1.070342, 1.011793, 0.953244, 0.894696, 0.836147] #[1.714379, 1.655830, 1.597281, 1.538732, 1.480184, 1.421635, 1.363086, 1.304537, 1.245988, 1.187440, 1.128891, 1.070342, 1.011793, 0.953244, 0.894696, 0.836147, 0.777598, 0.719049, 0.660500, 0.601952, 0.543403, 0.484854, 0.426305, 0.367756, 0.309208, 0.250659, 1.792110, 1.733561, 1.675012, 1.616464, 1.557915, 1.499366, 1.440817, 1.382268, 1.323720, 1.265171, 1.206622, 1.148073, 1.089524, 1.030976, 0.972427, 0.913878, 0.855329, 0.796780, 0.738232, 0.679683, 0.621134, 0.562585, 0.504036, 0.445488, 0.386939, 0.328390, 0.269841, 0.211292, 1.752744, 1.694195, 1.635646, 1.577097, 1.518548, 1.460000, 1.401451, 1.342902, 1.284353, 1.225804, 1.167256, 1.108707, 1.050158, 0.991609, 0.933060, 0.874512, 0.815963, 0.757414, 0.698865, 0.640316, 0.581768, 0.523219, 0.464670, 0.406121, 0.347572, 0.289024, 0.230475, 1.771926, 1.713377, 1.654828, 1.596280, 1.537731, 1.479182, 1.420633, 1.362084, 1.303536, 1.244987, 1.186438, 1.127889, 1.069340, 1.010792, 0.952243, 0.893694, 0.835145, 0.776596, 0.718048, 0.659499, 0.600950, 0.542401, 0.483852, 0.425304, 0.366755, 0.308206, 0.249657, 1.791108, 1.732560, 1.674011, 1.615462, 1.556913, 1.498364, 1.439816, 1.381267, 1.322718, 1.264169, 1.205620, 1.147072, 1.088523, 1.029974, 0.971425, 0.912876, 0.854328, 0.795779, 0.737230, 0.678681, 0.620132, 0.561584, 0.503035, 0.444486, 0.385937, 0.327388, 0.268840, 0.210291, 1.751742, 1.693193, 1.634644, 1.576096, 1.517547, 1.458998, 1.400449, 1.341900, 1.283352, 1.224803, 1.166254, 1.107705, 1.049156, 0.990608, 0.932059, 0.873510, 0.814961, 0.756412, 0.697864, 0.639315, 0.580766, 0.522217, 0.463668, 0.405120, 0.346571, 0.288022, 0.229473, 1.770924, 1.712376, 1.653827, 1.595278, 1.536729, 1.478180, 1.419632, 1.361083, 1.302534, 1.243985, 1.185436, 1.126888, 1.068339, 1.009790, 0.951241, 0.892692, 0.834144, 0.775595, 0.717046, 0.658497, 0.599948, 0.541400, 0.482851, 0.424302, 0.365753, 0.307204, 0.248656, 1.790107, 1.731558, 1.673009, 1.614460, 1.555912, 1.497363, 1.438814, 1.380265, 1.321716, 1.263168, 1.204619, 1.146070, 1.087521, 1.028972, 0.970424, 0.911875, 0.853326, 0.794777, 0.736228, 0.677680, 0.619131, 0.560582, 0.502033, 0.443484, 0.384936, 0.326387, 0.267838, 0.209289, 1.750740, 1.692192, 1.633643, 1.575094, 1.516545, 1.457996, 1.399448, 1.340899, 1.282350, 1.223801, 1.165252, 1.106704, 1.048155, 0.989606, 0.931057, 0.872508, 0.813960, 0.755411, 0.696862, 0.638313, 0.579764, 0.521216, 0.462667, 0.404118, 0.345569, 0.287020, 0.228472, 1.769923, 1.711374, 1.652825, 1.594276, 1.535728, 1.477179, 1.418630, 1.360081, 1.301532, 1.242984, 1.184435, 1.125886, 1.067337, 1.008788, 0.950240, 0.891691, 0.833142, 0.774593, 0.716044, 0.657496, 0.598947, 0.540398, 0.481849, 0.423300, 0.364752, 0.306203, 0.247654, 1.789105, 1.730556, 1.672008, 1.613459, 1.554910, 1.496361, 1.437812, 1.379264, 1.320715, 1.262166, 1.203617, 1.145068, 1.086520, 1.027971, 0.969422, 0.910873, 0.852324, 0.793776, 0.735227, 0.676678, 0.618129, 0.559580, 0.501032, 0.442483, 0.383934, 0.325385, 0.266836, 0.208288, 1.749739, 1.691190, 1.632641, 1.574092, 1.515544, 1.456995, 1.398446, 1.339897, 1.281348, 1.222800, 1.164251, 1.105702, 1.047153, 0.988604, 0.930056, 0.871507, 0.812958, 0.754409, 0.695860, 0.637312, 0.578763, 0.520214, 0.461665, 0.403116, 0.344568, 0.286019, 0.227470, 1.768921, 1.710372, 1.651824, 1.593275, 1.534726, 1.476177, 1.417628, 1.359080, 1.300531, 1.241982, 1.183433, 1.124884, 1.066336, 1.007787, 0.949238, 0.890689, 0.832140, 0.773592, 0.715043, 0.656494, 0.597945, 0.539396, 0.480848, 0.422299, 0.363750, 0.305201, 0.246652, 1.788104, 1.729555, 1.671006, 1.612457, 1.553908, 1.495360, 1.436811, 1.378262, 1.319713, 1.261164, 1.202616, 1.144067, 1.085518, 1.026969, 0.968420, 0.909872, 0.851323, 0.792774, 0.734225, 0.675676, 0.617128, 0.558579, 0.500030, 0.441481, 0.382932, 0.324384, 0.265835, 0.207286, 1.748737, 1.690188, 1.631640, 1.573091, 1.514542, 1.455993, 1.397444, 1.338896, 1.280347, 1.221798, 1.163249, 1.104700, 1.046152, 0.987603, 0.929054, 0.870505, 0.811956, 0.753408, 0.694859, 0.636310, 0.577761, 0.519212, 0.460664, 0.402115, 0.343566, 0.285017, 0.226468, 1.767920, 1.709371, 1.650822, 1.592273, 1.533724, 1.475176, 1.416627, 1.358078, 1.299529, 1.240980, 1.182432, 1.123883, 1.065334, 1.006785, 0.948236, 0.889688, 0.831139, 0.772590, 0.714041, 0.655492, 0.596944, 0.538395, 0.479846, 0.421297, 0.362748, 0.304200, 0.245651, 1.787102, 1.728553, 1.670004, 1.611456, 1.552907, 1.494358, 1.435809, 1.377260, 1.318712, 1.260163, 1.201614, 1.143065, 1.084516, 1.025968, 0.967419, 0.908870, 0.850321, 0.791772, 0.733224, 0.674675, 0.616126, 0.557577, 0.499028, 0.440480, 0.381931, 0.323382, 0.264833, 0.206284, 1.747736, 1.689187, 1.630638, 1.572089, 1.513540, 1.454992, 1.396443, 1.337894, 1.279345, 1.220796, 1.162248, 1.103699, 1.045150, 0.986601, 0.928052, 0.869504, 0.810955, 0.752406, 0.693857, 0.635308, 0.576760, 0.518211, 0.459662, 0.401113, 0.342564, 0.284016, 0.225467, 1.766918, 1.708369, 1.649820, 1.591272, 1.532723, 1.474174, 1.415625, 1.357076, 1.298528, 1.239979, 1.181430, 1.122881, 1.064332, 1.005784, 0.947235, 0.888686, 0.830137, 0.771588, 0.713040, 0.654491, 0.595942, 0.537393, 0.478844, 0.420296, 0.361747, 0.303198, 0.244649, 1.786100, 1.727552, 1.669003, 1.610454, 1.551905, 1.493356, 1.434808, 1.376259, 1.317710, 1.259161, 1.200612, 1.142064, 1.083515, 1.024966, 0.966417, 0.907868, 0.849320, 0.790771, 0.732222, 0.673673, 0.615124, 0.556576, 0.498027, 0.439478, 0.380929, 0.322380, 0.263832, 0.205283, 1.746734, 1.688185, 1.629636, 1.571088, 1.512539, 1.453990, 1.395441, 1.336892, 1.278344, 1.219795, 1.161246, 1.102697, 1.044148, 0.985600, 0.927051, 0.868502, 0.809953, 0.751404, 0.692856, 0.634307, 0.575758, 0.517209, 0.458660, 0.400112, 0.341563, 0.283014, 0.224465, 1.765916, 1.707368, 1.648819, 1.590270, 1.531721, 1.473172, 1.414624, 1.356075, 1.297526, 1.238977, 1.180428, 1.121880, 1.063331, 1.004782, 0.946233, 0.887684, 0.829136, 0.770587, 0.712038, 0.653489, 0.594940, 0.536392, 0.477843, 0.419294, 0.360745, 0.302196, 0.243648, 1.785099, 1.726550, 1.668001, 1.609452, 1.550904, 1.492355, 1.433806, 1.375257, 1.316708, 1.258160, 1.199611, 1.141062, 1.082513, 1.023964, 0.965416, 0.906867, 0.848318, 0.789769, 0.731220, 0.672672, 0.614123, 0.555574, 0.497025, 0.438476, 0.379928, 0.321379, 0.262830, 0.204281, 1.745732, 1.687184, 1.628635, 1.570086, 1.511537, 1.452988, 1.394440, 1.335891, 1.277342, 1.218793, 1.160244, 1.101696]).map Float.toBits))

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

#eval IO.println ("headToCmd " ++ toString (headToCmd 0.797083).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 0.465891).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 1.734699).toBits)

def headToDriveAz (h : Float) (rw : Float) (R : Float) : Float :=
  ((((((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 0.610931 0.552382 0.493833).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 0.279739 0.221190 1.762641).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.548547 1.489998 1.431449).toBits)

def headToDriveEl (h : Float) (arm : Float) (rDrum : Float) : Float :=
  ((((-(((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float))) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 0.424779 0.366230 0.307681).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.693587 1.635038 1.576489).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.362395 1.303846 1.245297).toBits)

def heatParams  : Array Float :=
  #[(0.9 : Float), (0.8 : Float), (0.03 : Float), (15 : Float), (0.92 : Float), (15 : Float), (6300 : Float), (593 : Float)]

#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))

def heatStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Array Float :=
  let v22 := (Toil - Ta)
  #[(min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * Pin), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("heatStep " ++ toString ((heatStep 1.652475 1.593926 1.535377 1.476828 1.418280 1.359731 1.301182 1.242633 1.184084 1.125536 1.066987 1.008438 0.949889).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 1.321283 1.262734 1.204185 1.145636 1.087088 1.028539 0.969990 0.911441 0.852892 0.794344 0.735795 0.677246 0.618697).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.990091 0.931542 0.872993 0.814444 0.755896 0.697347 0.638798 0.580249 0.521700 0.463152 0.404603 0.346054 0.287505).map Float.toBits))

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.466323 1.407774).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.135131 1.076582).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.803939 0.745390).toBits)

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

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.094019 1.035470).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.762827 0.704278).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.431635 0.373086).map Float.toBits))

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

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.907867 0.849318 0.790769 0.732220 0.673672 0.615123 0.556574 0.498025))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.576675 0.518126 0.459577 0.401028 0.342480 0.283931 0.225382 1.766833))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.245483 1.786934 1.728385 1.669836 1.611288 1.552739 1.494190 1.435641))

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

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.721715 0.663166 0.604617 0.546068 0.487520 0.428971 0.370422 0.311873 0.253324))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.390523 0.331974 0.273425 0.214876 1.756328 1.697779 1.639230 1.580681 1.522132))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.659331 1.600782 1.542233 1.483684 1.425136 1.366587 1.308038 1.249489 1.190940))

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

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.535563 0.477014 0.418465))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.204371 1.745822 1.687273))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.473179 1.414630 1.356081))

def hpHashemi  : Float :=
  (0.34 : Float)

#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)

def hyperHit (f : Float) (L : Float) (dm : Float) (t : Float) (beta : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v11 := (t + beta)
  let v12 := (Float.sin v11)
  let v15 := (-(Float.cos v11))
  let v17 := (L / (2 : Float))
  let v20 := ((v17 - dm) ^ 2)
  let v21 := ((v17 ^ 2) - v20)
  let v22 := (v12 * v17)
  let v23 := ((0 : Float) * v17)
  let v25 := (f + (v15 * v17))
  let v26 := (O_0 - v22)
  let v27 := (O_1 - v23)
  let v28 := (O_2 - v25)
  let v34 := (-(((v26 * v12) + (v27 * (0 : Float))) + (v28 * v15)))
  let v40 := (-(((d_0 * v12) + (d_1 * (0 : Float))) + (d_2 * v15)))
  let v44 := (((1 : Float) / v20) + ((1 : Float) / v21))
  let v53 := (((v40 ^ 2) * v44) - ((((d_0 * d_0) + (d_1 * d_1)) + (d_2 * d_2)) / v21))
  let v64 := (((((2 : Float) * v34) * v40) * v44) - (((2 : Float) * (((v26 * d_0) + (v27 * d_1)) + (v28 * d_2))) / v21))
  let v81 := (Float.sqrt (max ((v64 ^ 2) - (((4 : Float) * v53) * ((((v34 ^ 2) * v44) - ((((v26 * v26) + (v27 * v27)) + (v28 * v28)) / v21)) - (1 : Float)))) (0 : Float)))
  let v82 := (-v64)
  let v84 := ((2 : Float) * v53)
  let v85 := ((v82 - v81) / v84)
  let v87 := ((v82 + v81) / v84)
  let v93 := ((v85 > (0.000001 : Float)) && ((v34 + (v85 * v40)) > (0 : Float)))
  let v98 := ((v87 > (0.000001 : Float)) && ((v34 + (v87 * v40)) > (0 : Float)))
  let v104 := (if (v93 && v98) then (min v85 v87) else (if v93 then v85 else (if v98 then v87 else (-(1 : Float)))))
  let v112 := (v34 + (v104 * v40))
  let v115 := (((O_0 + (v104 * d_0)) - v22) + (v112 * v12))
  let v118 := (((O_1 + (v104 * d_1)) - v23) + (v112 * (0 : Float)))
  let v121 := (((O_2 + (v104 * d_2)) - v25) + (v112 * v15))
  let v131 := (-(v112 / v20))
  let v134 := ((v131 * v12) - (v115 / v21))
  let v137 := ((v131 * (0 : Float)) - (v118 / v21))
  let v140 := ((v131 * v15) - (v121 / v21))
  let v147 := (Float.sqrt (max (((v134 * v134) + (v137 * v137)) + (v140 * v140)) (0.000000000000000001 : Float)))
  #[(O_0 + (v104 * d_0)), (O_1 + (v104 * d_1)), (O_2 + (v104 * d_2)), v104, (Float.sqrt (max (((v115 * v115) + (v118 * v118)) + (v121 * v121)) (0.000000000000000001 : Float))), (v134 / v147), (v137 / v147), (v140 / v147)]

#eval IO.println ("hyperHit " ++ toString ((hyperHit 1.763259 1.704710 1.646161 1.587612 1.529064 1.470515 1.411966 1.353417 1.294868 1.236320 1.177771).map Float.toBits))
#eval IO.println ("hyperHit " ++ toString ((hyperHit 1.432067 1.373518 1.314969 1.256420 1.197872 1.139323 1.080774 1.022225 0.963676 0.905128 0.846579).map Float.toBits))
#eval IO.println ("hyperHit " ++ toString ((hyperHit 1.100875 1.042326 0.983777 0.925228 0.866680 0.808131 0.749582 0.691033 0.632484 0.573936 0.515387).map Float.toBits))

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 1.577107 1.518558 1.460009 1.401460 1.342912 1.284363 1.225814).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 1.245915 1.187366 1.128817 1.070268 1.011720 0.953171 0.894622).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.914723 0.856174 0.797625 0.739076 0.680528 0.621979 0.563430).map Float.toBits))

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

#eval IO.println ("leverAt " ++ toString (leverAt 1.204803 1.146254 1.087705 1.029156 0.970608).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.873611 0.815062 0.756513 0.697964 0.639416).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.542419 0.483870 0.425321 0.366772 0.308224).toBits)

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

#eval IO.println ("lostSunS " ++ toString (lostSunS 1.018651 0.960102 0.901553 0.843004 0.784456 0.725907).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.687459 0.628910 0.570361 0.511812 0.453264 0.394715).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.356267 0.297718 0.239169 1.780620 1.722072 1.663523).toBits)

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

#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.832499 0.773950 0.715401 0.656852 0.598304 0.539755))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.501307 0.442758 0.384209 0.325660 0.267112 0.208563))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.770115 1.711566 1.653017 1.594468 1.535920 1.477371))

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

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.646347 0.587798 0.529249 0.470700 0.412152 0.353603))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.315155 0.256606 1.798057 1.739508 1.680960 1.622411))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.583963 1.525414 1.466865 1.408316 1.349768 1.291219))

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

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.460195 0.401646 0.343097 0.284548 0.226000 1.767451))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.729003 1.670454 1.611905 1.553356 1.494808 1.436259))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.397811 1.339262 1.280713 1.222164 1.163616 1.105067))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.687891))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.356699))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.025507))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.315587))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.984395))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.653203))

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

#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.757131 0.698582 0.640033 0.581484 0.522936 0.464387 0.405838 0.347289 0.288740 0.230192 1.771643 1.713094 1.654545 1.595996 1.537448 1.478899 1.420350).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.425939 0.367390 0.308841 0.250292 1.791744 1.733195 1.674646 1.616097 1.557548 1.499000 1.440451 1.381902 1.323353 1.264804 1.206256 1.147707 1.089158).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.694747 1.636198 1.577649 1.519100 1.460552 1.402003 1.343454 1.284905 1.226356 1.167808 1.109259 1.050710 0.992161 0.933612 0.875064 0.816515 0.757966).map Float.toBits))

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

#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.384827 0.326278 0.267729 0.209180 1.750632 1.692083 1.633534 1.574985 1.516436 1.457888 1.399339 1.340790 1.282241 1.223692 1.165144 1.106595 1.048046).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.653635 1.595086 1.536537 1.477988 1.419440 1.360891 1.302342 1.243793 1.185244 1.126696 1.068147 1.009598 0.951049 0.892500 0.833952 0.775403 0.716854).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.322443 1.263894 1.205345 1.146796 1.088248 1.029699 0.971150 0.912601 0.854052 0.795504 0.736955 0.678406 0.619857 0.561308 0.502760 0.444211 0.385662).map Float.toBits))

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

#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.798675 1.740126 1.681577 1.623028 1.564480 1.505931 1.447382 1.388833 1.330284 1.271736 1.213187 1.154638 1.096089 1.037540 0.978992 0.920443 0.861894).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.467483 1.408934 1.350385 1.291836 1.233288 1.174739 1.116190 1.057641 0.999092 0.940544 0.881995 0.823446 0.764897 0.706348 0.647800 0.589251 0.530702).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.136291 1.077742 1.019193 0.960644 0.902096 0.843547 0.784998 0.726449 0.667900 0.609352 0.550803 0.492254 0.433705 0.375156 0.316608 0.258059 1.799510).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.612523 1.553974 1.495425).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.281331 1.222782 1.164233).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.950139 0.891590 0.833041).toBits)

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

#eval IO.println ("megaStep " ++ toString ((megaStep 1.426371 1.367822 1.309273 1.250724 1.192176 1.133627 1.075078 1.016529 0.957980 0.899432 0.840883 0.782334 0.723785 0.665236 0.606688 0.548139 0.489590).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.095179 1.036630 0.978081 0.919532 0.860984 0.802435 0.743886 0.685337 0.626788 0.568240 0.509691 0.451142 0.392593 0.334044 0.275496 0.216947 1.758398).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.763987 0.705438 0.646889 0.588340 0.529792 0.471243 0.412694 0.354145 0.295596 0.237048 1.778499 1.719950 1.661401 1.602852 1.544304 1.485755 1.427206).map Float.toBits))

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

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.240219 1.181670 1.123121 1.064572 1.006024 0.947475 0.888926 0.830377 0.771828 0.713280 0.654731 0.596182 0.537633 0.479084 0.420536 0.361987 0.303438).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.909027 0.850478 0.791929 0.733380 0.674832 0.616283 0.557734 0.499185 0.440636 0.382088 0.323539 0.264990 0.206441 1.747892 1.689344 1.630795 1.572246).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.577835 0.519286 0.460737 0.402188 0.343640 0.285091 0.226542 1.767993 1.709444 1.650896 1.592347 1.533798 1.475249 1.416700 1.358152 1.299603 1.241054).map Float.toBits))

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

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.054067 0.995518 0.936969 0.878420 0.819872 0.761323 0.702774 0.644225 0.585676 0.527128 0.468579 0.410030 0.351481 0.292932 0.234384 1.775835 1.717286).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.722875 0.664326 0.605777 0.547228 0.488680 0.430131 0.371582 0.313033 0.254484 1.795936 1.737387 1.678838 1.620289 1.561740 1.503192 1.444643 1.386094).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.391683 0.333134 0.274585 0.216036 1.757488 1.698939 1.640390 1.581841 1.523292 1.464744 1.406195 1.347646 1.289097 1.230548 1.172000 1.113451 1.054902).map Float.toBits))

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

#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.867915 0.809366 0.750817 0.692268 0.633720 0.575171 0.516622 0.458073 0.399524 0.340976 #[1.144531, 1.085982, 1.027433, 0.968884, 0.910336, 0.851787, 0.793238, 0.734689, 0.676140, 0.617592, 0.559043, 0.500494, 0.441945, 0.383396, 0.324848, 0.266299, 0.207750, 1.749201, 1.690652, 1.632104, 1.573555, 1.515006, 1.456457, 1.397908, 1.339360, 1.280811, 1.222262, 1.163713, 1.105164, 1.046616, 0.988067, 0.929518, 0.870969, 0.812420, 0.753872, 0.695323, 0.636774, 0.578225, 0.519676, 0.461128, 0.402579, 0.344030, 0.285481, 0.226932, 1.768384, 1.709835, 1.651286, 1.592737, 1.534188, 1.475640, 1.417091, 1.358542, 1.299993, 1.241444, 1.182896, 1.124347, 1.065798, 1.007249, 0.948700, 0.890152, 0.831603, 0.773054, 0.714505, 0.655956, 0.597408, 0.538859, 0.480310, 0.421761, 0.363212, 0.304664, 0.246115, 1.787566, 1.729017, 1.670468, 1.611920, 1.553371, 1.494822, 1.436273, 1.377724, 1.319176, 1.260627, 1.202078, 1.143529, 1.084980, 1.026432, 0.967883, 0.909334, 0.850785, 0.792236, 0.733688, 0.675139, 0.616590, 0.558041, 0.499492, 0.440944, 0.382395, 0.323846, 0.265297, 0.206748, 1.748200, 1.689651, 1.631102, 1.572553, 1.514004, 1.455456, 1.396907, 1.338358, 1.279809, 1.221260, 1.162712, 1.104163, 1.045614, 0.987065, 0.928516, 0.869968, 0.811419, 0.752870, 0.694321, 0.635772, 0.577224, 0.518675, 0.460126, 0.401577, 0.343028, 0.284480, 0.225931, 1.767382, 1.708833] #[1.144531, 1.085982, 1.027433, 0.968884, 0.910336, 0.851787, 0.793238, 0.734689, 0.676140, 0.617592, 0.559043, 0.500494, 0.441945, 0.383396, 0.324848, 0.266299] #[1.144531, 1.085982, 1.027433, 0.968884, 0.910336, 0.851787, 0.793238, 0.734689, 0.676140, 0.617592, 0.559043, 0.500494, 0.441945, 0.383396, 0.324848, 0.266299, 0.207750, 1.749201, 1.690652, 1.632104, 1.573555, 1.515006, 1.456457, 1.397908, 1.339360, 1.280811, 1.222262, 1.163713, 1.105164, 1.046616, 0.988067, 0.929518]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.536723 0.478174 0.419625 0.361076 0.302528 0.243979 1.785430 1.726881 1.668332 1.609784 #[0.813339, 0.754790, 0.696241, 0.637692, 0.579144, 0.520595, 0.462046, 0.403497, 0.344948, 0.286400, 0.227851, 1.769302, 1.710753, 1.652204, 1.593656, 1.535107, 1.476558, 1.418009, 1.359460, 1.300912, 1.242363, 1.183814, 1.125265, 1.066716, 1.008168, 0.949619, 0.891070, 0.832521, 0.773972, 0.715424, 0.656875, 0.598326, 0.539777, 0.481228, 0.422680, 0.364131, 0.305582, 0.247033, 1.788484, 1.729936, 1.671387, 1.612838, 1.554289, 1.495740, 1.437192, 1.378643, 1.320094, 1.261545, 1.202996, 1.144448, 1.085899, 1.027350, 0.968801, 0.910252, 0.851704, 0.793155, 0.734606, 0.676057, 0.617508, 0.558960, 0.500411, 0.441862, 0.383313, 0.324764, 0.266216, 0.207667, 1.749118, 1.690569, 1.632020, 1.573472, 1.514923, 1.456374, 1.397825, 1.339276, 1.280728, 1.222179, 1.163630, 1.105081, 1.046532, 0.987984, 0.929435, 0.870886, 0.812337, 0.753788, 0.695240, 0.636691, 0.578142, 0.519593, 0.461044, 0.402496, 0.343947, 0.285398, 0.226849, 1.768300, 1.709752, 1.651203, 1.592654, 1.534105, 1.475556, 1.417008, 1.358459, 1.299910, 1.241361, 1.182812, 1.124264, 1.065715, 1.007166, 0.948617, 0.890068, 0.831520, 0.772971, 0.714422, 0.655873, 0.597324, 0.538776, 0.480227, 0.421678, 0.363129, 0.304580, 0.246032, 1.787483, 1.728934, 1.670385, 1.611836, 1.553288, 1.494739, 1.436190, 1.377641] #[0.813339, 0.754790, 0.696241, 0.637692, 0.579144, 0.520595, 0.462046, 0.403497, 0.344948, 0.286400, 0.227851, 1.769302, 1.710753, 1.652204, 1.593656, 1.535107] #[0.813339, 0.754790, 0.696241, 0.637692, 0.579144, 0.520595, 0.462046, 0.403497, 0.344948, 0.286400, 0.227851, 1.769302, 1.710753, 1.652204, 1.593656, 1.535107, 1.476558, 1.418009, 1.359460, 1.300912, 1.242363, 1.183814, 1.125265, 1.066716, 1.008168, 0.949619, 0.891070, 0.832521, 0.773972, 0.715424, 0.656875, 0.598326]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.205531 1.746982 1.688433 1.629884 1.571336 1.512787 1.454238 1.395689 1.337140 1.278592 #[0.482147, 0.423598, 0.365049, 0.306500, 0.247952, 1.789403, 1.730854, 1.672305, 1.613756, 1.555208, 1.496659, 1.438110, 1.379561, 1.321012, 1.262464, 1.203915, 1.145366, 1.086817, 1.028268, 0.969720, 0.911171, 0.852622, 0.794073, 0.735524, 0.676976, 0.618427, 0.559878, 0.501329, 0.442780, 0.384232, 0.325683, 0.267134, 0.208585, 1.750036, 1.691488, 1.632939, 1.574390, 1.515841, 1.457292, 1.398744, 1.340195, 1.281646, 1.223097, 1.164548, 1.106000, 1.047451, 0.988902, 0.930353, 0.871804, 0.813256, 0.754707, 0.696158, 0.637609, 0.579060, 0.520512, 0.461963, 0.403414, 0.344865, 0.286316, 0.227768, 1.769219, 1.710670, 1.652121, 1.593572, 1.535024, 1.476475, 1.417926, 1.359377, 1.300828, 1.242280, 1.183731, 1.125182, 1.066633, 1.008084, 0.949536, 0.890987, 0.832438, 0.773889, 0.715340, 0.656792, 0.598243, 0.539694, 0.481145, 0.422596, 0.364048, 0.305499, 0.246950, 1.788401, 1.729852, 1.671304, 1.612755, 1.554206, 1.495657, 1.437108, 1.378560, 1.320011, 1.261462, 1.202913, 1.144364, 1.085816, 1.027267, 0.968718, 0.910169, 0.851620, 0.793072, 0.734523, 0.675974, 0.617425, 0.558876, 0.500328, 0.441779, 0.383230, 0.324681, 0.266132, 0.207584, 1.749035, 1.690486, 1.631937, 1.573388, 1.514840, 1.456291, 1.397742, 1.339193, 1.280644, 1.222096, 1.163547, 1.104998, 1.046449] #[0.482147, 0.423598, 0.365049, 0.306500, 0.247952, 1.789403, 1.730854, 1.672305, 1.613756, 1.555208, 1.496659, 1.438110, 1.379561, 1.321012, 1.262464, 1.203915] #[0.482147, 0.423598, 0.365049, 0.306500, 0.247952, 1.789403, 1.730854, 1.672305, 1.613756, 1.555208, 1.496659, 1.438110, 1.379561, 1.321012, 1.262464, 1.203915, 1.145366, 1.086817, 1.028268, 0.969720, 0.911171, 0.852622, 0.794073, 0.735524, 0.676976, 0.618427, 0.559878, 0.501329, 0.442780, 0.384232, 0.325683, 0.267134]).map Float.toBits))

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

#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 0.681763 0.623214 0.564665 0.506116 0.447568 0.389019 0.330470 0.271921 0.213372 1.754824 #[0.958379, 0.899830, 0.841281, 0.782732, 0.724184, 0.665635, 0.607086, 0.548537, 0.489988, 0.431440, 0.372891, 0.314342, 0.255793, 1.797244, 1.738696, 1.680147, 1.621598, 1.563049, 1.504500, 1.445952, 1.387403, 1.328854, 1.270305, 1.211756, 1.153208, 1.094659, 1.036110, 0.977561, 0.919012, 0.860464, 0.801915, 0.743366, 0.684817, 0.626268, 0.567720, 0.509171, 0.450622, 0.392073, 0.333524, 0.274976, 0.216427, 1.757878, 1.699329, 1.640780, 1.582232, 1.523683, 1.465134, 1.406585, 1.348036, 1.289488, 1.230939, 1.172390, 1.113841, 1.055292, 0.996744, 0.938195, 0.879646, 0.821097, 0.762548, 0.704000, 0.645451, 0.586902, 0.528353, 0.469804, 0.411256, 0.352707, 0.294158, 0.235609, 1.777060, 1.718512, 1.659963, 1.601414, 1.542865, 1.484316, 1.425768, 1.367219, 1.308670, 1.250121, 1.191572, 1.133024, 1.074475, 1.015926, 0.957377, 0.898828, 0.840280, 0.781731, 0.723182, 0.664633, 0.606084, 0.547536, 0.488987, 0.430438, 0.371889, 0.313340, 0.254792, 1.796243, 1.737694, 1.679145, 1.620596, 1.562048, 1.503499, 1.444950, 1.386401, 1.327852, 1.269304, 1.210755, 1.152206, 1.093657, 1.035108, 0.976560, 0.918011, 0.859462, 0.800913, 0.742364, 0.683816, 0.625267, 0.566718, 0.508169, 0.449620, 0.391072, 0.332523, 0.273974, 0.215425, 1.756876, 1.698328, 1.639779, 1.581230, 1.522681] #[0.958379, 0.899830, 0.841281, 0.782732, 0.724184, 0.665635, 0.607086, 0.548537, 0.489988, 0.431440, 0.372891, 0.314342, 0.255793, 1.797244, 1.738696, 1.680147] #[0.958379, 0.899830, 0.841281, 0.782732, 0.724184, 0.665635, 0.607086, 0.548537, 0.489988, 0.431440, 0.372891, 0.314342, 0.255793, 1.797244, 1.738696, 1.680147, 1.621598, 1.563049, 1.504500, 1.445952, 1.387403, 1.328854, 1.270305, 1.211756, 1.153208, 1.094659, 1.036110, 0.977561, 0.919012, 0.860464, 0.801915, 0.743366]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 0.350571 0.292022 0.233473 1.774924 1.716376 1.657827 1.599278 1.540729 1.482180 1.423632 #[0.627187, 0.568638, 0.510089, 0.451540, 0.392992, 0.334443, 0.275894, 0.217345, 1.758796, 1.700248, 1.641699, 1.583150, 1.524601, 1.466052, 1.407504, 1.348955, 1.290406, 1.231857, 1.173308, 1.114760, 1.056211, 0.997662, 0.939113, 0.880564, 0.822016, 0.763467, 0.704918, 0.646369, 0.587820, 0.529272, 0.470723, 0.412174, 0.353625, 0.295076, 0.236528, 1.777979, 1.719430, 1.660881, 1.602332, 1.543784, 1.485235, 1.426686, 1.368137, 1.309588, 1.251040, 1.192491, 1.133942, 1.075393, 1.016844, 0.958296, 0.899747, 0.841198, 0.782649, 0.724100, 0.665552, 0.607003, 0.548454, 0.489905, 0.431356, 0.372808, 0.314259, 0.255710, 1.797161, 1.738612, 1.680064, 1.621515, 1.562966, 1.504417, 1.445868, 1.387320, 1.328771, 1.270222, 1.211673, 1.153124, 1.094576, 1.036027, 0.977478, 0.918929, 0.860380, 0.801832, 0.743283, 0.684734, 0.626185, 0.567636, 0.509088, 0.450539, 0.391990, 0.333441, 0.274892, 0.216344, 1.757795, 1.699246, 1.640697, 1.582148, 1.523600, 1.465051, 1.406502, 1.347953, 1.289404, 1.230856, 1.172307, 1.113758, 1.055209, 0.996660, 0.938112, 0.879563, 0.821014, 0.762465, 0.703916, 0.645368, 0.586819, 0.528270, 0.469721, 0.411172, 0.352624, 0.294075, 0.235526, 1.776977, 1.718428, 1.659880, 1.601331, 1.542782, 1.484233, 1.425684, 1.367136, 1.308587, 1.250038, 1.191489] #[0.627187, 0.568638, 0.510089, 0.451540, 0.392992, 0.334443, 0.275894, 0.217345, 1.758796, 1.700248, 1.641699, 1.583150, 1.524601, 1.466052, 1.407504, 1.348955] #[0.627187, 0.568638, 0.510089, 0.451540, 0.392992, 0.334443, 0.275894, 0.217345, 1.758796, 1.700248, 1.641699, 1.583150, 1.524601, 1.466052, 1.407504, 1.348955, 1.290406, 1.231857, 1.173308, 1.114760, 1.056211, 0.997662, 0.939113, 0.880564, 0.822016, 0.763467, 0.704918, 0.646369, 0.587820, 0.529272, 0.470723, 0.412174]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.619379 1.560830 1.502281 1.443732 1.385184 1.326635 1.268086 1.209537 1.150988 1.092440 #[0.295995, 0.237446, 1.778897, 1.720348, 1.661800, 1.603251, 1.544702, 1.486153, 1.427604, 1.369056, 1.310507, 1.251958, 1.193409, 1.134860, 1.076312, 1.017763, 0.959214, 0.900665, 0.842116, 0.783568, 0.725019, 0.666470, 0.607921, 0.549372, 0.490824, 0.432275, 0.373726, 0.315177, 0.256628, 1.798080, 1.739531, 1.680982, 1.622433, 1.563884, 1.505336, 1.446787, 1.388238, 1.329689, 1.271140, 1.212592, 1.154043, 1.095494, 1.036945, 0.978396, 0.919848, 0.861299, 0.802750, 0.744201, 0.685652, 0.627104, 0.568555, 0.510006, 0.451457, 0.392908, 0.334360, 0.275811, 0.217262, 1.758713, 1.700164, 1.641616, 1.583067, 1.524518, 1.465969, 1.407420, 1.348872, 1.290323, 1.231774, 1.173225, 1.114676, 1.056128, 0.997579, 0.939030, 0.880481, 0.821932, 0.763384, 0.704835, 0.646286, 0.587737, 0.529188, 0.470640, 0.412091, 0.353542, 0.294993, 0.236444, 1.777896, 1.719347, 1.660798, 1.602249, 1.543700, 1.485152, 1.426603, 1.368054, 1.309505, 1.250956, 1.192408, 1.133859, 1.075310, 1.016761, 0.958212, 0.899664, 0.841115, 0.782566, 0.724017, 0.665468, 0.606920, 0.548371, 0.489822, 0.431273, 0.372724, 0.314176, 0.255627, 1.797078, 1.738529, 1.679980, 1.621432, 1.562883, 1.504334, 1.445785, 1.387236, 1.328688, 1.270139, 1.211590, 1.153041, 1.094492, 1.035944, 0.977395, 0.918846, 0.860297] #[0.295995, 0.237446, 1.778897, 1.720348, 1.661800, 1.603251, 1.544702, 1.486153, 1.427604, 1.369056, 1.310507, 1.251958, 1.193409, 1.134860, 1.076312, 1.017763] #[0.295995, 0.237446, 1.778897, 1.720348, 1.661800, 1.603251, 1.544702, 1.486153, 1.427604, 1.369056, 1.310507, 1.251958, 1.193409, 1.134860, 1.076312, 1.017763, 0.959214, 0.900665, 0.842116, 0.783568, 0.725019, 0.666470, 0.607921, 0.549372, 0.490824, 0.432275, 0.373726, 0.315177, 0.256628, 1.798080, 1.739531, 1.680982]))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.495611 0.437062 0.378513 0.319964 0.261416 0.202867))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.764419 1.705870 1.647321 1.588772 1.530224 1.471675))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.433227 1.374678 1.316129 1.257580 1.199032 1.140483))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.309459 0.250910 1.792361 1.733812 1.675264 1.616715))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.578267 1.519718 1.461169 1.402620 1.344072 1.285523))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.247075 1.188526 1.129977 1.071428 1.012880 0.954331))

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

#eval IO.println ("obsOf " ++ toString ((obsOf 1.351003 1.292454 1.233905 1.175356 1.116808 1.058259 0.999710 0.941161).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 1.019811 0.961262 0.902713 0.844164 0.785616 0.727067 0.668518 0.609969).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.688619 0.630070 0.571521 0.512972 0.454424 0.395875 0.337326 0.278777).map Float.toBits))

def oilStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Float :=
  let v22 := (Toil - Ta)
  (min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil)))

#eval IO.println ("oilStep " ++ toString (oilStep 1.164851 1.106302 1.047753 0.989204 0.930656 0.872107 0.813558 0.755009 0.696460 0.637912 0.579363 0.520814 0.462265).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.833659 0.775110 0.716561 0.658012 0.599464 0.540915 0.482366 0.423817 0.365268 0.306720 0.248171 1.789622 1.731073).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.502467 0.443918 0.385369 0.326820 0.268272 0.209723 1.751174 1.692625 1.634076 1.575528 1.516979 1.458430 1.399881).toBits)

def check_oilStep_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Twall : Float) (Ta : Float) (dt : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v27 := (alpha * Pin)
  let v30 := ((eps * (0.0000000567 : Float)) * Ac)
  let v32 := (Ta ^ 4)
  let v35 := (hC * Ac)
  let v36 := (T1 - Ta)
  let v53 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) < Coil) || (!((0 : Float) <= dt) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((min ToilMax (T1 + ((dt * (((v27 - ((v30 * ((T1 ^ 4) - v32)) + (v35 * v36))) - (Upipe * v36)) - (max (0 : Float) (UAx * (T1 - Twall))))) / Coil))) - (min ToilMax (T2 + ((dt * (((v27 - ((v30 * ((T2 ^ 4) - v32)) + (v35 * v53))) - (Upipe * v53)) - (max (0 : Float) (UAx * (T2 - Twall))))) / Coil))))) <= (((1 : Float) + ((dt * ((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v35) + Upipe) + UAx)) / Coil)) * (Float.abs (T1 - T2)))))))))))))))

#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.978699 0.920150 0.861601 0.803052 0.744504 0.685955 0.627406 0.568857 0.510308 0.451760 0.393211 0.334662 0.276113 0.217564 1.759016))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.647507 0.588958 0.530409 0.471860 0.413312 0.354763 0.296214 0.237665 1.779116 1.720568 1.662019 1.603470 1.544921 1.486372 1.427824))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.316315 0.257766 1.799217 1.740668 1.682120 1.623571 1.565022 1.506473 1.447924 1.389376 1.330827 1.272278 1.213729 1.155180 1.096632))

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

#eval IO.println ("pipeGreen " ++ toString (pipeGreen 0.420243 0.361694).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.689051 1.630502).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.357859 1.299310).toBits)

def check_pipeGreen_le_one (Upipe : Float) (mcp : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || ((Float.exp ((-Upipe) / mcp)) <= (1 : Float))))

#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 0.234091 1.775542))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.502899 1.444350))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.171707 1.113158))

def check_pipeGreen_pos (Upipe : Float) (mcp : Float) : Bool :=
  ((0 : Float) < (Float.exp ((-Upipe) / mcp)))

#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.647939 1.589390))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.316747 1.258198))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 0.985555 0.927006))

def check_pipeGreen_semigroup (U1 : Float) (U2 : Float) (mcp : Float) : Bool :=
  (feq (Float.exp ((-(U1 + U2)) / mcp)) ((Float.exp ((-U1) / mcp)) * (Float.exp ((-U2) / mcp))))

#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 1.461787 1.403238 1.344689))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 1.130595 1.072046 1.013497))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 0.799403 0.740854 0.682305))

def check_play_budget (f : Float) (eps : Float) (h : Float) (delta : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.275635 1.217086 1.158537 1.099988))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.944443 0.885894 0.827345 0.768796))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.613251 0.554702 0.496153 0.437604))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.089483))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.758291))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.427099))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 0.903331 0.844782 0.786233 0.727684 0.669136 0.610587 0.552038 0.493489 0.434940).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.572139 0.513590 0.455041 0.396492 0.337944 0.279395 0.220846 1.762297 1.703748).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.240947 1.782398 1.723849 1.665300 1.606752 1.548203 1.489654 1.431105 1.372556).map Float.toBits))

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

#eval IO.println ("pointingError " ++ toString (pointingError 0.717179 0.658630 0.600081 0.541532).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.385987 0.327438 0.268889 0.210340).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 1.654795 1.596246 1.537697 1.479148).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 0.531027 0.472478 0.413929 0.355380 0.296832 0.238283 1.779734 1.721185 1.662636 1.604088 1.545539 1.486990 1.428441).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.799835 1.741286 1.682737 1.624188 1.565640 1.507091 1.448542 1.389993 1.331444 1.272896 1.214347 1.155798 1.097249).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.468643 1.410094 1.351545 1.292996 1.234448 1.175899 1.117350 1.058801 1.000252 0.941704 0.883155 0.824606 0.766057).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.344875 0.286326 0.227777 1.769228 1.710680 1.652131 1.593582 1.535033 1.476484 1.417936 1.359387 1.300838))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.613683 1.555134 1.496585 1.438036 1.379488 1.320939 1.262390 1.203841 1.145292 1.086744 1.028195 0.969646))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.282491 1.223942 1.165393 1.106844 1.048296 0.989747 0.931198 0.872649 0.814100 0.755552 0.697003 0.638454))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.758723 1.700174 1.641625 1.583076 1.524528 1.465979 1.407430 1.348881 1.290332 1.231784 1.173235 1.114686))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.427531 1.368982 1.310433 1.251884 1.193336 1.134787 1.076238 1.017689 0.959140 0.900592 0.842043 0.783494))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.096339 1.037790 0.979241 0.920692 0.862144 0.803595 0.745046 0.686497 0.627948 0.569400 0.510851 0.452302))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.572571 1.514022 1.455473 1.396924 1.338376 1.279827 1.221278 1.162729 1.104180 1.045632 0.987083 0.928534))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.241379 1.182830 1.124281 1.065732 1.007184 0.948635 0.890086 0.831537 0.772988 0.714440 0.655891 0.597342))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.910187 0.851638 0.793089 0.734540 0.675992 0.617443 0.558894 0.500345 0.441796 0.383248 0.324699 0.266150))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.386419 1.327870 1.269321 1.210772 1.152224 1.093675 1.035126 0.976577 0.918028 0.859480 0.800931 0.742382 0.683833))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.055227 0.996678 0.938129 0.879580 0.821032 0.762483 0.703934 0.645385 0.586836 0.528288 0.469739 0.411190 0.352641))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.724035 0.665486 0.606937 0.548388 0.489840 0.431291 0.372742 0.314193 0.255644 1.797096 1.738547 1.679998 1.621449))

def check_pow4_lipschitz (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((T1 ^ 4) - (T2 ^ 4))) <= (((4 : Float) * (M ^ 3)) * (Float.abs (T1 - T2))))))))

#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.200267 1.141718 1.083169))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.869075 0.810526 0.751977))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.537883 0.479334 0.420785))

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

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.311051 1.252502 1.193953))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.979859 0.921310 0.862761))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.648667 0.590118 0.531569))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.124899))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.793707))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.462515))

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

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.380291 0.321742))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.649099 1.590550))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.317907 1.259358))

def prop_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.794139 1.735590 1.677041))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.462947 1.404398 1.345849))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.131755 1.073206 1.014657))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.607987))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.276795))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.945603))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.421835 1.363286))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.090643 1.032094))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.759451 0.700902))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.235683 1.177134))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.904491 0.845942))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.573299 0.514750))

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

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.049531 0.990982 0.932433 0.873884 0.815336 0.756787 0.698238 0.639689 0.581140 0.522592 0.464043 0.405494))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.718339 0.659790 0.601241 0.542692 0.484144 0.425595 0.367046 0.308497 0.249948 1.791400 1.732851 1.674302))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.387147 0.328598 0.270049 0.211500 1.752952 1.694403 1.635854 1.577305 1.518756 1.460208 1.401659 1.343110))

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

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.304923 0.246374 1.787825))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.573731 1.515182 1.456633))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.242539 1.183990 1.125441))

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

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.346467 1.287918 1.229369 1.170820 1.112272 1.053723 0.995174 0.936625 0.878076 0.819528 0.760979 0.702430 0.643881))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.015275 0.956726 0.898177 0.839628 0.781080 0.722531 0.663982 0.605433 0.546884 0.488336 0.429787 0.371238 0.312689))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.684083 0.625534 0.566985 0.508436 0.449888 0.391339 0.332790 0.274241 0.215692 1.757144 1.698595 1.640046 1.581497))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.160315 1.101766 1.043217 0.984668 0.926120 0.867571 0.809022 0.750473 0.691924 0.633376 0.574827 0.516278 0.457729))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.829123 0.770574 0.712025 0.653476 0.594928 0.536379 0.477830 0.419281 0.360732 0.302184 0.243635 1.785086 1.726537))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.497931 0.439382 0.380833 0.322284 0.263736 0.205187 1.746638 1.688089 1.629540 1.570992 1.512443 1.453894 1.395345))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.974163 0.915614 0.857065 0.798516 0.739968))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.642971 0.584422 0.525873 0.467324 0.408776))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.311779 0.253230 1.794681 1.736132 1.677584))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.788011 0.729462 0.670913))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.456819 0.398270 0.339721))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.725627 1.667078 1.608529))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.601859))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.270667))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.539475))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.415707 0.357158 0.298609))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.684515 1.625966 1.567417))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.353323 1.294774 1.236225))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.229555 1.771006 1.712457))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.498363 1.439814 1.381265))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.167171 1.108622 1.050073))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.643403 1.584854 1.526305 1.467756))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.312211 1.253662 1.195113 1.136564))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.981019 0.922470 0.863921 0.805372))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.457251 1.398702 1.340153))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.126059 1.067510 1.008961))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.794867 0.736318 0.677769))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.271099 1.212550 1.154001 1.095452 1.036904))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.939907 0.881358 0.822809 0.764260 0.705712))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.608715 0.550166 0.491617 0.433068 0.374520))

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

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.084947 1.026398 0.967849 0.909300 0.850752))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.753755 0.695206 0.636657 0.578108 0.519560))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.422563 0.364014 0.305465 0.246916 1.788368))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.898795 0.840246 0.781697 0.723148 0.664600))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.567603 0.509054 0.450505 0.391956 0.333408))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.236411 1.777862 1.719313 1.660764 1.602216))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.712643 0.654094 0.595545 0.536996))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.381451 0.322902 0.264353 0.205804))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.650259 1.591710 1.533161 1.474612))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.340339 0.281790 0.223241))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.609147 1.550598 1.492049))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.277955 1.219406 1.160857))

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

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.754187 1.695638 1.637089 1.578540 1.519992 1.461443 1.402894 1.344345 1.285796 1.227248 1.168699 1.110150))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.422995 1.364446 1.305897 1.247348 1.188800 1.130251 1.071702 1.013153 0.954604 0.896056 0.837507 0.778958))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.091803 1.033254 0.974705 0.916156 0.857608 0.799059 0.740510 0.681961 0.623412 0.564864 0.506315 0.447766))

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

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.568035 1.509486 1.450937 1.392388 1.333840 1.275291 1.216742 1.158193 1.099644 1.041096 0.982547 0.923998))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.236843 1.178294 1.119745 1.061196 1.002648 0.944099 0.885550 0.827001 0.768452 0.709904 0.651355 0.592806))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.905651 0.847102 0.788553 0.730004 0.671456 0.612907 0.554358 0.495809 0.437260 0.378712 0.320163 0.261614))

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

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.381883 1.323334 1.264785 1.206236 1.147688 1.089139 1.030590 0.972041 0.913492 0.854944 0.796395 0.737846))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.050691 0.992142 0.933593 0.875044 0.816496 0.757947 0.699398 0.640849 0.582300 0.523752 0.465203 0.406654))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.719499 0.660950 0.602401 0.543852 0.485304 0.426755 0.368206 0.309657 0.251108 1.792560 1.734011 1.675462))

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

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.492667 1.434118 1.375569 1.317020 1.258472 1.199923 1.141374 1.082825))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.161475 1.102926 1.044377 0.985828 0.927280 0.868731 0.810182 0.751633))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.830283 0.771734 0.713185 0.654636 0.596088 0.537539 0.478990 0.420441))

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

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.306515 1.247966 1.189417 1.130868 1.072320 1.013771 0.955222 0.896673 0.838124))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.975323 0.916774 0.858225 0.799676 0.741128 0.682579 0.624030 0.565481 0.506932))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.644131 0.585582 0.527033 0.468484 0.409936 0.351387 0.292838 0.234289 1.775740))

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

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.120363 1.061814 1.003265))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.789171 0.730622 0.672073))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.457979 0.399430 0.340881))

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

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.561907))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.230715))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.499523))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.789603))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.458411))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.127219))

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

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.231147 1.172598 1.114049 1.055500 0.996952 0.938403))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.899955 0.841406 0.782857 0.724308 0.665760 0.607211))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.568763 0.510214 0.451665 0.393116 0.334568 0.276019))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.044995 0.986446 0.927897 0.869348 0.810800 0.752251))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.713803 0.655254 0.596705 0.538156 0.479608 0.421059))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.382611 0.324062 0.265513 0.206964 1.748416 1.689867))

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

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.486539 0.427990 0.369441 0.310892))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.755347 1.696798 1.638249 1.579700))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.424155 1.365606 1.307057 1.248508))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.300387))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.569195))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.238003))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.714235 1.655686 1.597137 1.538588 1.480040 1.421491 1.362942 1.304393 1.245844 1.187296 1.128747 1.070198))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.383043 1.324494 1.265945 1.207396 1.148848 1.090299 1.031750 0.973201 0.914652 0.856104 0.797555 0.739006))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.051851 0.993302 0.934753 0.876204 0.817656 0.759107 0.700558 0.642009 0.583460 0.524912 0.466363 0.407814))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.528083 1.469534 1.410985 1.352436 1.293888 1.235339 1.176790 1.118241 1.059692 1.001144 0.942595 0.884046))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.196891 1.138342 1.079793 1.021244 0.962696 0.904147 0.845598 0.787049 0.728500 0.669952 0.611403 0.552854))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.865699 0.807150 0.748601 0.690052 0.631504 0.572955 0.514406 0.455857 0.397308 0.338760 0.280211 0.221662))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.341931 1.283382 1.224833 1.166284 1.107736 1.049187 0.990638 0.932089 0.873540 0.814992 0.756443 0.697894))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.010739 0.952190 0.893641 0.835092 0.776544 0.717995 0.659446 0.600897 0.542348 0.483800 0.425251 0.366702))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.679547 0.620998 0.562449 0.503900 0.445352 0.386803 0.328254 0.269705 0.211156 1.752608 1.694059 1.635510))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.155779 1.097230 1.038681 0.980132 0.921584 0.863035 0.804486 0.745937 0.687388 0.628840 0.570291 0.511742 0.453193))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.824587 0.766038 0.707489 0.648940 0.590392 0.531843 0.473294 0.414745 0.356196 0.297648 0.239099 1.780550 1.722001))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.493395 0.434846 0.376297 0.317748 0.259200 0.200651 1.742102 1.683553 1.625004 1.566456 1.507907 1.449358 1.390809))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.783475 0.724926 0.666377 0.607828))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.452283 0.393734 0.335185 0.276636))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.721091 1.662542 1.603993 1.545444))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.411171 0.352622 0.294073))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.679979 1.621430 1.562881))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.348787 1.290238 1.231689))

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

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.266563 1.208014 1.149465 1.090916 1.032368 0.973819))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.935371 0.876822 0.818273 0.759724 0.701176 0.642627))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.604179 0.545630 0.487081 0.428532 0.369984 0.311435))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.080411 1.021862 0.963313 0.904764 0.846216 0.787667))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.749219 0.690670 0.632121 0.573572 0.515024 0.456475))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.418027 0.359478 0.300929 0.242380 1.783832 1.725283))

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

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.708107 0.649558 0.591009 0.532460 0.473912 0.415363 0.356814))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.376915 0.318366 0.259817 0.201268 1.742720 1.684171 1.625622))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.645723 1.587174 1.528625 1.470076 1.411528 1.352979 1.294430))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.521955 0.463406))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.790763 1.732214))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.459571 1.401022))

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

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.563499 1.504950))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.232307 1.173758))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.901115 0.842566))

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

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.377347 1.318798 1.260249 1.201700 1.143152 1.084603 1.026054 0.967505 0.908956))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.046155 0.987606 0.929057 0.870508 0.811960 0.753411 0.694862 0.636313 0.577764))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.714963 0.656414 0.597865 0.539316 0.480768 0.422219 0.363670 0.305121 0.246572))

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

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.191195 1.132646 1.074097))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.860003 0.801454 0.742905))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.528811 0.470262 0.411713))

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

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.446587 0.388038 0.329489 0.270940))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.715395 1.656846 1.598297 1.539748))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.384203 1.325654 1.267105 1.208556))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.260435 0.201886 1.743337 1.684788 1.626240))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.529243 1.470694 1.412145 1.353596 1.295048))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.198051 1.139502 1.080953 1.022404 0.963856))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.488131 1.429582 1.371033))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.156939 1.098390 1.039841))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.825747 0.767198 0.708649))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.115827 1.057278 0.998729 0.940180 0.881632 0.823083 0.764534 0.705985 0.647436 0.588888))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.784635 0.726086 0.667537 0.608988 0.550440 0.491891 0.433342 0.374793 0.316244 0.257696))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.453443 0.394894 0.336345 0.277796 0.219248 1.760699 1.702150 1.643601 1.585052 1.526504))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.929675 0.871126 0.812577))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.598483 0.539934 0.481385))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.267291 0.208742 1.750193))

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

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.743523 0.684974 0.626425 0.567876 0.509328))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.412331 0.353782 0.295233 0.236684 1.778136))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.681139 1.622590 1.564041 1.505492 1.446944))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.557371 0.498822 0.440273 0.381724 0.323176))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.226179 1.767630 1.709081 1.650532 1.591984))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.494987 1.436438 1.377889 1.319340 1.260792))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.371219))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.640027))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.308835))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.785067 1.726518 1.667969 1.609420))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.453875 1.395326 1.336777 1.278228))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.122683 1.064134 1.005585 0.947036))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.598915 1.540366 1.481817 1.423268 1.364720))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.267723 1.209174 1.150625 1.092076 1.033528))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.936531 0.877982 0.819433 0.760884 0.702336))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.412763 1.354214 1.295665 1.237116 1.178568))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.081571 1.023022 0.964473 0.905924 0.847376))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.750379 0.691830 0.633281 0.574732 0.516184))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.226611 1.168062 1.109513))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.895419 0.836870 0.778321))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.564227 0.505678 0.447129))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.040459))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.709267))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.378075))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.854307 0.795758 0.737209 0.678660))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.523115 0.464566 0.406017 0.347468))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.791923 1.733374 1.674825 1.616276))

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

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.482003 0.423454 0.364905 0.306356 0.247808))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.750811 1.692262 1.633713 1.575164 1.516616))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.419619 1.361070 1.302521 1.243972 1.185424))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.295851 0.237302 1.778753 1.720204))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.564659 1.506110 1.447561 1.389012))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.233467 1.174918 1.116369 1.057820))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.709699 1.651150 1.592601 1.534052))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.378507 1.319958 1.261409 1.202860))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.047315 0.988766 0.930217 0.871668))

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

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.151243 1.092694 1.034145 0.975596 0.917048 0.858499 0.799950 0.741401))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.820051 0.761502 0.702953 0.644404 0.585856 0.527307 0.468758 0.410209))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.488859 0.430310 0.371761 0.313212 0.254664 1.796115 1.737566 1.679017))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.778939 0.720390 0.661841 0.603292))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.447747 0.389198 0.330649 0.272100))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.716555 1.658006 1.599457 1.540908))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.592787 0.534238 0.475689))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.261595 0.203046 1.744497))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.530403 1.471854 1.413305))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.220483 1.761934).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.489291 1.430742).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.158099 1.099550).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def qAbs (alpha : Float) (Pin : Float) : Float :=
  (alpha * Pin)

#eval IO.println ("qAbs " ++ toString (qAbs 1.448179 1.389630).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 1.116987 1.058438).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 0.785795 0.727246).toBits)

def qCoilLoss (eps : Float) (Ac : Float) (hC : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.262027 1.203478 1.144929 1.086380 1.027832).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.930835 0.872286 0.813737 0.755188 0.696640).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.599643 0.541094 0.482545 0.423996 0.365448).toBits)

def qNet (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Float :=
  let v19 := (Toil - Ta)
  ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("qNet " ++ toString (qNet 1.075875 1.017326 0.958777 0.900228 0.841680 0.783131 0.724582 0.666033 0.607484 0.548936).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.744683 0.686134 0.627585 0.569036 0.510488 0.451939 0.393390 0.334841 0.276292 0.217744).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.413491 0.354942 0.296393 0.237844 1.779296 1.720747 1.662198 1.603649 1.545100 1.486552).toBits)

def check_qNet_antitone (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) <= (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.889723 0.831174 0.772625 0.714076 0.655528 0.596979 0.538430 0.479881 0.421332 0.362784 0.304235))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.558531 0.499982 0.441433 0.382884 0.324336 0.265787 0.207238 1.748689 1.690140 1.631592 1.573043))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.227339 1.768790 1.710241 1.651692 1.593144 1.534595 1.476046 1.417497 1.358948 1.300400 1.241851))

def check_qNet_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v22 := (alpha * Pin)
  let v25 := ((eps * (0.0000000567 : Float)) * Ac)
  let v27 := (Ta ^ 4)
  let v30 := (hC * Ac)
  let v31 := (T1 - Ta)
  let v44 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((((v22 - ((v25 * ((T1 ^ 4) - v27)) + (v30 * v31))) - (Upipe * v31)) - (max (0 : Float) (UAx * (T1 - Twall)))) - (((v22 - ((v25 * ((T2 ^ 4) - v27)) + (v30 * v44))) - (Upipe * v44)) - (max (0 : Float) (UAx * (T2 - Twall)))))) <= (((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v30) + Upipe) + UAx) * (Float.abs (T1 - T2)))))))))))))

#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.703571 0.645022 0.586473 0.527924 0.469376 0.410827 0.352278 0.293729 0.235180 1.776632 1.718083 1.659534))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.372379 0.313830 0.255281 1.796732 1.738184 1.679635 1.621086 1.562537 1.503988 1.445440 1.386891 1.328342))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.641187 1.582638 1.524089 1.465540 1.406992 1.348443 1.289894 1.231345 1.172796 1.114248 1.055699 0.997150))

def check_qNet_strictAnti (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 < T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) < (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.517419 0.458870 0.400321 0.341772 0.283224 0.224675 1.766126 1.707577 1.649028 1.590480 1.531931))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.786227 1.727678 1.669129 1.610580 1.552032 1.493483 1.434934 1.376385 1.317836 1.259288 1.200739))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.455035 1.396486 1.337937 1.279388 1.220840 1.162291 1.103742 1.045193 0.986644 0.928096 0.869547))

def qPipe (Upipe : Float) (Toil : Float) (Ta : Float) : Float :=
  (Upipe * (Toil - Ta))

#eval IO.println ("qPipe " ++ toString (qPipe 0.331267 0.272718 0.214169).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.600075 1.541526 1.482977).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.268883 1.210334 1.151785).toBits)

def qPot (UAx : Float) (Toil : Float) (Twall : Float) : Float :=
  (max (0 : Float) (UAx * (Toil - Twall)))

#eval IO.println ("qPot " ++ toString (qPot 1.745115 1.686566 1.628017).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.413923 1.355374 1.296825).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.082731 1.024182 0.965633).toBits)

def check_qPot_le (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  let v5 := (Toil - Twall)
  (!((0 : Float) <= UAx) || ((max (0 : Float) (UAx * v5)) <= (UAx * (max (0 : Float) v5))))

#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.558963 1.500414 1.441865))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.227771 1.169222 1.110673))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.896579 0.838030 0.779481))

def check_qPot_nonneg (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  ((0 : Float) <= (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.372811 1.314262 1.255713))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.041619 0.983070 0.924521))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.710427 0.651878 0.593329))

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

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.814355 0.755806 0.697257 0.638708))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.483163 0.424614 0.366065 0.307516))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.751971 1.693422 1.634873 1.576324))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 0.442051 0.383502 0.324953 0.266404 0.207856 1.749307 1.690758 1.632209 1.573660 1.515112 1.456563 1.398014).toBits)
#eval IO.println ("recip " ++ toString (recip 1.710859 1.652310 1.593761 1.535212 1.476664 1.418115 1.359566 1.301017 1.242468 1.183920 1.125371 1.066822).toBits)
#eval IO.println ("recip " ++ toString (recip 1.379667 1.321118 1.262569 1.204020 1.145472 1.086923 1.028374 0.969825 0.911276 0.852728 0.794179 0.735630).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 0.255899 1.797350 1.738801 1.680252 1.621704 1.563155).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.524707 1.466158 1.407609 1.349060 1.290512 1.231963).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.193515 1.134966 1.076417 1.017868 0.959320 0.900771).map Float.toBits))

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

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.483595 1.425046 1.366497))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.152403 1.093854 1.035305))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.821211 0.762662 0.704113))

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

#eval IO.println ("rollY " ++ toString ((rollY 0.925139 0.866590 0.808041).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.593947 0.535398 0.476849).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.262755 0.204206 1.745657).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.738987 0.680438 0.621889 0.563340 0.504792 0.446243).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.407795 0.349246 0.290697 0.232148 1.773600 1.715051).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.676603 1.618054 1.559505 1.500956 1.442408 1.383859).toBits)

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

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.780531 1.721982 1.663433 1.604884 1.546336 1.487787))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.449339 1.390790 1.332241 1.273692 1.215144 1.156595))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.118147 1.059598 1.001049 0.942500 0.883952 0.825403))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.594379 1.535830 1.477281 1.418732 1.360184 1.301635))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.263187 1.204638 1.146089 1.087540 1.028992 0.970443))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.931995 0.873446 0.814897 0.756348 0.697800 0.639251))

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

#eval IO.println ("rot " ++ toString ((rot 1.222075 1.163526 1.104977).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.890883 0.832334 0.773785).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.559691 0.501142 0.442593).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 1.035923 0.977374 0.918825 0.860276).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.704731 0.646182 0.587633 0.529084).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.373539 0.314990 0.256441 1.797892).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.849771 0.791222 0.732673 0.674124 0.615576 0.557027 0.498478))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.518579 0.460030 0.401481 0.342932 0.284384 0.225835 1.767286))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.787387 1.728838 1.670289 1.611740 1.553192 1.494643 1.436094))

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

#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.663619 0.605070 0.546521 0.487972 0.429424 0.370875 0.312326 0.253777 1.795228 1.736680 1.678131 1.619582).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.332427 0.273878 0.215329 1.756780 1.698232 1.639683 1.581134 1.522585 1.464036 1.405488 1.346939 1.288390).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.601235 1.542686 1.484137 1.425588 1.367040 1.308491 1.249942 1.191393 1.132844 1.074296 1.015747 0.957198).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 0.477467 0.418918).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.746275 1.687726).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.415083 1.356534).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.291315 0.232766))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.560123 1.501574))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.228931 1.170382))

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

#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.332859 1.274310).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.001667 0.943118).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.670475 0.611926).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.146707 1.088158))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.815515 0.756966))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.484323 0.425774))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.960555 0.902006 0.843457).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.629363 0.570814 0.512265).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.298171 0.239622 1.781073).map Float.toBits))

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

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.774403 0.715854 0.657305 0.598756 0.540208 0.481659 0.423110 0.364561 0.306012))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.443211 0.384662 0.326113 0.267564 0.209016 1.750467 1.691918 1.633369 1.574820))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.712019 1.653470 1.594921 1.536372 1.477824 1.419275 1.360726 1.302177 1.243628))

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

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.588251 0.529702 0.471153))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.257059 1.798510 1.739961))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.525867 1.467318 1.408769))

def secondaryMag (L : Float) (dm : Float) : Float :=
  ((L - dm) / dm)

#eval IO.println ("secondaryMag " ++ toString (secondaryMag 0.402099 0.343550).toBits)
#eval IO.println ("secondaryMag " ++ toString (secondaryMag 1.670907 1.612358).toBits)
#eval IO.println ("secondaryMag " ++ toString (secondaryMag 1.339715 1.281166).toBits)

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 0.215947 1.757398).toBits)
#eval IO.println ("setLength " ++ toString (setLength 1.484755 1.426206).toBits)
#eval IO.println ("setLength " ++ toString (setLength 1.153563 1.095014).toBits)

def shift (x : Float) (h : Array Float) : Array Float :=
  #[x, h[0]!, h[1]!, h[2]!, h[3]!, h[4]!, h[5]!, h[6]!, h[7]!, h[8]!, h[9]!, h[10]!, h[11]!, h[12]!, h[13]!, h[14]!]

#eval IO.println ("shift " ++ toString ((shift 1.629795 #[0.306411, 0.247862, 1.789313, 1.730764, 1.672216, 1.613667, 1.555118, 1.496569, 1.438020, 1.379472, 1.320923, 1.262374, 1.203825, 1.145276, 1.086728, 1.028179]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 1.298603 #[1.575219, 1.516670, 1.458121, 1.399572, 1.341024, 1.282475, 1.223926, 1.165377, 1.106828, 1.048280, 0.989731, 0.931182, 0.872633, 0.814084, 0.755536, 0.696987]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 0.967411 #[1.244027, 1.185478, 1.126929, 1.068380, 1.009832, 0.951283, 0.892734, 0.834185, 0.775636, 0.717088, 0.658539, 0.599990, 0.541441, 0.482892, 0.424344, 0.365795]).map Float.toBits))

def check_shift_head (x : Float) (h : Array Float) : Bool :=
  (feq x x)

#eval IO.println ("check_shift_head " ++ toString (check_shift_head 1.443643 #[1.720259, 1.661710, 1.603161, 1.544612, 1.486064, 1.427515, 1.368966, 1.310417, 1.251868, 1.193320, 1.134771, 1.076222, 1.017673, 0.959124, 0.900576, 0.842027]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 1.112451 #[1.389067, 1.330518, 1.271969, 1.213420, 1.154872, 1.096323, 1.037774, 0.979225, 0.920676, 0.862128, 0.803579, 0.745030, 0.686481, 0.627932, 0.569384, 0.510835]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 0.781259 #[1.057875, 0.999326, 0.940777, 0.882228, 0.823680, 0.765131, 0.706582, 0.648033, 0.589484, 0.530936, 0.472387, 0.413838, 0.355289, 0.296740, 0.238192, 1.779643]))

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

#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.512883))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.781691))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.450499))

def check_sigmoid_slope_le (x : Float) : Bool :=
  let v1 := (1.0 / (1.0 + Float.exp (-x)))
  ((v1 * ((1 : Float) - v1)) <= ((1 : Float) / (4 : Float)))

#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.326731))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.595539))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.264347))

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

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.554427 1.495878 1.437329 1.378780))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.223235 1.164686 1.106137 1.047588))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.892043 0.833494 0.774945 0.716396))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.368275 1.309726 1.251177 1.192628 1.134080))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.037083 0.978534 0.919985 0.861436 0.802888))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.705891 0.647342 0.588793 0.530244 0.471696))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 1.182123 1.123574 1.065025).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.850931 0.792382 0.733833).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.519739 0.461190 0.402641).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 0.995971 0.937422).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 0.664779 0.606230).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 0.333587 0.275038).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.623667 0.565118).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.292475 0.233926).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.561283 1.502734).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.437515 0.378966).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.706323 1.647774).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.375131 1.316582).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 0.251363 1.792814 1.734265).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.520171 1.461622 1.403073).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.188979 1.130430 1.071881).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.665211 1.606662).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.334019 1.275470).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.002827 0.944278).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.479059 1.420510 1.361961 1.303412 1.244864 1.186315 1.127766).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.147867 1.089318 1.030769 0.972220 0.913672 0.855123 0.796574).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.816675 0.758126 0.699577 0.641028 0.582480 0.523931 0.465382).map Float.toBits))

def spotTau  : Float :=
  (0.005 : Float)

#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.106755 1.048206 0.989657))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.775563 0.717014 0.658465))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.444371 0.385822 0.327273))

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

#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.734451 0.675902 0.617353 0.558804 0.500256 0.441707 0.383158 0.324609 0.266060 0.207512))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.403259 0.344710 0.286161 0.227612 1.769064 1.710515 1.651966 1.593417 1.534868 1.476320))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.672067 1.613518 1.554969 1.496420 1.437872 1.379323 1.320774 1.262225 1.203676 1.145128))

def check_steady_pot_le_abs (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v17 := (alpha * Pin)
  let v26 := (Toil - Ta)
  let v34 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= Ta) || (!(Ta <= Toil) || (!(feq (((v17 - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v26))) - (Upipe * v26)) - v34) (0 : Float)) || (v34 <= v17))))))))

#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.548299 0.489750 0.431201 0.372652 0.314104 0.255555 1.797006 1.738457 1.679908 1.621360))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.217107 1.758558 1.700009 1.641460 1.582912 1.524363 1.465814 1.407265 1.348716 1.290168))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.485915 1.427366 1.368817 1.310268 1.251720 1.193171 1.134622 1.076073 1.017524 0.958976))

def check_steady_unique (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T1 - Ta)
  let v42 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!((0 : Float) <= T2) || (!(feq (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T1 - Twall)))) (0 : Float)) || (!(feq (((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v42))) - (Upipe * v42)) - (max (0 : Float) (UAx * (T2 - Twall)))) (0 : Float)) || (feq T1 T2))))))))))

#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.362147 0.303598 0.245049 1.786500 1.727952 1.669403 1.610854 1.552305 1.493756 1.435208 1.376659))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.630955 1.572406 1.513857 1.455308 1.396760 1.338211 1.279662 1.221113 1.162564 1.104016 1.045467))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.299763 1.241214 1.182665 1.124116 1.065568 1.007019 0.948470 0.889921 0.831372 0.772824 0.714275))

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

#eval IO.println ("step " ++ toString ((step 1.775995 1.717446 1.658897 1.600348 1.541800 1.483251 1.424702 1.366153 1.307604 1.249056 1.190507 1.131958 1.073409 1.014860 0.956312 0.897763).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 1.444803 1.386254 1.327705 1.269156 1.210608 1.152059 1.093510 1.034961 0.976412 0.917864 0.859315 0.800766 0.742217 0.683668 0.625120 0.566571).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 1.113611 1.055062 0.996513 0.937964 0.879416 0.820867 0.762318 0.703769 0.645220 0.586672 0.528123 0.469574 0.411025 0.352476 0.293928 0.235379).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 1.403691 1.345142 1.286593 1.228044 1.169496 1.110947 1.052398 0.993849 0.935300).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 1.072499 1.013950 0.955401 0.896852 0.838304 0.779755 0.721206 0.662657 0.604108).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.741307 0.682758 0.624209 0.565660 0.507112 0.448563 0.390014 0.331465 0.272916).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.217539 1.158990 1.100441 1.041892 0.983344 0.924795 0.866246 0.807697 0.749148 0.690600))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.886347 0.827798 0.769249 0.710700 0.652152 0.593603 0.535054 0.476505 0.417956 0.359408))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.555155 0.496606 0.438057 0.379508 0.320960 0.262411 0.203862 1.745313 1.686764 1.628216))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 1.031387 0.972838).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.700195 0.641646).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.369003 0.310454).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.845235 0.786686 0.728137))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.514043 0.455494 0.396945))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.782851 1.724302 1.665753))

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

#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.659083 0.600534 0.541985 0.483436).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.327891 0.269342 0.210793 1.752244).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.596699 1.538150 1.479601 1.421052).map Float.toBits))

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

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.472931 0.414382 0.355833 0.297284 0.238736))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.741739 1.683190 1.624641 1.566092 1.507544))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.410547 1.351998 1.293449 1.234900 1.176352))

def sunRate  : Float :=
  (0.000073 : Float)

#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)

def sunReachableS (tDead : Float) (elSun : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))

#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.700627 1.642078).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.369435 1.310886).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.038243 0.979694).toBits)

def check_sunReachableS_mem (tDead : Float) (elSun : Float) : Bool :=
  let v10 := (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))
  (((0 : Float) <= v10) && (v10 <= (1 : Float)))

#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.514475 1.455926))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.183283 1.124734))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.852091 0.793542))

def check_sunReachableS_slope (tDead : Float) (e1 : Float) (e2 : Float) : Bool :=
  let v6 := (((3.141592653589793 : Float) / (2 : Float)) - tDead)
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((e1 - v6) / (0.01 : Float))))) - (1.0 / (1.0 + Float.exp (-((e2 - v6) / (0.01 : Float))))))) <= ((Float.abs (e1 - e2)) / ((4 : Float) * (0.01 : Float))))

#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.328323 1.269774 1.211225))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.997131 0.938582 0.880033))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.665939 0.607390 0.548841))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.142171 1.083622 1.025073 0.966524 0.907976).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.810979 0.752430 0.693881 0.635332 0.576784).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.479787 0.421238 0.362689 0.304140 0.245592).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.956019 0.897470 0.838921 0.780372 0.721824))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.624827 0.566278 0.507729 0.449180 0.390632))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.293635 0.235086 1.776537 1.717988 1.659440))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.769867).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.438675).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.707483).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.583715))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.252523))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.521331))

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

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.397563 0.339014 0.280465 0.221916 1.763368 1.704819).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.666371 1.607822 1.549273 1.490724 1.432176 1.373627).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.335179 1.276630 1.218081 1.159532 1.100984 1.042435).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.211411 1.752862).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.480219 1.421670).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.149027 1.090478).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.625259 1.566710 1.508161 1.449612).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.294067 1.235518 1.176969 1.118420).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.962875 0.904326 0.845777 0.787228).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.439107 1.380558 1.322009 1.263460).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.107915 1.049366 0.990817 0.932268).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.776723 0.718174 0.659625 0.601076).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.252955 1.194406 1.135857 1.077308))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.921763 0.863214 0.804665 0.746116))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.590571 0.532022 0.473473 0.414924))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.066803 1.008254 0.949705 0.891156 0.832608))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.735611 0.677062 0.618513 0.559964 0.501416))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.404419 0.345870 0.287321 0.228772 1.770224))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 0.880651 0.822102 0.763553).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 0.549459 0.490910 0.432361).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 0.218267 1.759718 1.701169).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tanh_abs_lt_one (x : Float) : Bool :=
  ((Float.abs (Float.tanh x)) < (1 : Float))

#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.508347))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.777155))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.445963))

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.322195 0.263646 0.205097 1.746548 1.688000))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.591003 1.532454 1.473905 1.415356 1.356808))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.259811 1.201262 1.142713 1.084164 1.025616))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 1.736043 1.677494 1.618945 1.560396 1.501848).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.404851 1.346302 1.287753 1.229204 1.170656).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.073659 1.015110 0.956561 0.898012 0.839464).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.549891).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.218699).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.887507).toBits)

def traceBeam (R : Float) (f : Float) (a : Float) (k : Float) (L : Float) (dm : Float) (rm : Float) (rt : Float) (slotW : Float) (t : Float) (beta : Float) (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (onPanel : Float) : Array Float :=
  let v18 := (t + beta)
  let v19 := (Float.sin v18)
  let v22 := (-(Float.cos v18))
  let v24 := (L / (2 : Float))
  let v27 := ((v24 - dm) ^ 2)
  let v28 := ((v24 ^ 2) - v27)
  let v29 := (v19 * v24)
  let v30 := ((0 : Float) * v24)
  let v32 := (f + (v22 * v24))
  let v33 := (H_0 - v29)
  let v34 := (H_1 - v30)
  let v35 := (H_2 - v32)
  let v41 := (-(((v33 * v19) + (v34 * (0 : Float))) + (v35 * v22)))
  let v47 := (-(((r_0 * v19) + (r_1 * (0 : Float))) + (r_2 * v22)))
  let v51 := (((1 : Float) / v27) + ((1 : Float) / v28))
  let v60 := (((v47 ^ 2) * v51) - ((((r_0 * r_0) + (r_1 * r_1)) + (r_2 * r_2)) / v28))
  let v71 := (((((2 : Float) * v41) * v47) * v51) - (((2 : Float) * (((v33 * r_0) + (v34 * r_1)) + (v35 * r_2))) / v28))
  let v88 := (Float.sqrt (max ((v71 ^ 2) - (((4 : Float) * v60) * ((((v41 ^ 2) * v51) - ((((v33 * v33) + (v34 * v34)) + (v35 * v35)) / v28)) - (1 : Float)))) (0 : Float)))
  let v89 := (-v71)
  let v91 := ((2 : Float) * v60)
  let v92 := ((v89 - v88) / v91)
  let v94 := ((v89 + v88) / v91)
  let v100 := ((v92 > (0.000001 : Float)) && ((v41 + (v92 * v47)) > (0 : Float)))
  let v105 := ((v94 > (0.000001 : Float)) && ((v41 + (v94 * v47)) > (0 : Float)))
  let v111 := (if (v100 && v105) then (min v92 v94) else (if v100 then v92 else (if v105 then v94 else (-(1 : Float)))))
  let v113 := (H_0 + (v111 * r_0))
  let v115 := (H_1 + (v111 * r_1))
  let v117 := (H_2 + (v111 * r_2))
  let v119 := (v41 + (v111 * v47))
  let v122 := ((v113 - v29) + (v119 * v19))
  let v125 := ((v115 - v30) + (v119 * (0 : Float)))
  let v128 := ((v117 - v32) + (v119 * v22))
  let v138 := (-(v119 / v27))
  let v141 := ((v138 * v19) - (v122 / v28))
  let v144 := ((v138 * (0 : Float)) - (v125 / v28))
  let v147 := ((v138 * v22) - (v128 / v28))
  let v154 := (Float.sqrt (max (((v141 * v141) + (v144 * v144)) + (v147 * v147)) (0.000000000000000001 : Float)))
  let v155 := (v141 / v154)
  let v156 := (v144 / v154)
  let v157 := (v147 / v154)
  let v163 := ((onPanel > (0.5 : Float)) && ((v111 > (0 : Float)) && ((Float.sqrt (max (((v122 * v122) + (v125 * v125)) + (v128 * v128)) (0.000000000000000001 : Float))) <= rm)))
  let v169 := ((2 : Float) * (((r_0 * v155) + (r_1 * v156)) + (r_2 * v157)))
  let v171 := (r_0 - (v169 * v155))
  let v173 := (r_1 - (v169 * v156))
  let v175 := (r_2 - (v169 * v157))
  let v176 := ((1 : Float) + k)
  let v177 := ((1 : Float) / R)
  let v194 := ((((2 : Float) * v177) * (((v113 * v171) + (v115 * v173)) + ((v176 * v117) * v175))) - ((2 : Float) * v175))
  let v203 := ((v177 * (((v113 ^ 2) + (v115 ^ 2)) + (v176 * (v117 ^ 2)))) - ((2 : Float) * v117))
  let v213 := (((2 : Float) * v203) / ((-v194) - (Float.sqrt (max ((v194 ^ 2) - (((4 : Float) * (v177 * (((v171 ^ 2) + (v173 ^ 2)) + (v176 * (v175 ^ 2))))) * v203)) (0 : Float)))))
  let v215 := (v113 + (v213 * v171))
  let v222 := (Float.abs (v115 + (v213 * v173)))
  let v232 := (!(v213 > (0 : Float)) || ((!(((Float.abs v215) <= a) && (v222 <= a))) || ((v222 <= (slotW / (2 : Float))) && (v215 >= (0 : Float)))))
  let v233 := (v19 * L)
  let v234 := ((0 : Float) * L)
  let v236 := (f + (v22 * L))
  let v250 := (((((v233 - v113) * v19) + ((v234 - v115) * (0 : Float))) + ((v236 - v117) * v22)) / (((v171 * v19) + (v173 * (0 : Float))) + (v175 * v22)))
  let v268 := (((Float.sqrt (((((v113 + (v250 * v171)) - v233) ^ 2) + (((v115 + (v250 * v173)) - v234) ^ 2)) + (((v117 + (v250 * v175)) - v236) ^ 2))) <= rt) && (v250 > (0 : Float)))
  #[(if (v163 && (v232 && v268)) then (1 : Float) else (0 : Float)), (if v163 then (1 : Float) else (0 : Float)), (if (v163 && v232) then (1 : Float) else (0 : Float)), (Float.sqrt (((((v113 + (v250 * v171)) - v233) ^ 2) + (((v115 + (v250 * v173)) - v234) ^ 2)) + (((v117 + (v250 * v175)) - v236) ^ 2))), v215, (v115 + (v213 * v173)), (Float.sqrt (max (((v122 * v122) + (v125 * v125)) + (v128 * v128)) (0.000000000000000001 : Float))), (if (!v163) then (0 : Float) else (if (!v232) then (1 : Float) else (if (!v268) then (2 : Float) else (3 : Float))))]

#eval IO.println ("traceBeam " ++ toString ((traceBeam 1.363739 1.305190 1.246641 1.188092 1.129544 1.070995 1.012446 0.953897 0.895348 0.836800 0.778251 0.719702 0.661153 0.602604 0.544056 0.485507 0.426958 0.368409).map Float.toBits))
#eval IO.println ("traceBeam " ++ toString ((traceBeam 1.032547 0.973998 0.915449 0.856900 0.798352 0.739803 0.681254 0.622705 0.564156 0.505608 0.447059 0.388510 0.329961 0.271412 0.212864 1.754315 1.695766 1.637217).map Float.toBits))
#eval IO.println ("traceBeam " ++ toString ((traceBeam 0.701355 0.642806 0.584257 0.525708 0.467160 0.408611 0.350062 0.291513 0.232964 1.774416 1.715867 1.657318 1.598769 1.540220 1.481672 1.423123 1.364574 1.306025).map Float.toBits))

def check_traceBeam_captured (R : Float) (f : Float) (a : Float) (k : Float) (L : Float) (dm : Float) (rm : Float) (rt : Float) (slotW : Float) (t : Float) (beta : Float) (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (onPanel : Float) : Bool :=
  let v18 := (t + beta)
  let v19 := (Float.sin v18)
  let v22 := (-(Float.cos v18))
  let v24 := (L / (2 : Float))
  let v27 := ((v24 - dm) ^ 2)
  let v28 := ((v24 ^ 2) - v27)
  let v29 := (v19 * v24)
  let v30 := ((0 : Float) * v24)
  let v32 := (f + (v22 * v24))
  let v33 := (H_0 - v29)
  let v34 := (H_1 - v30)
  let v35 := (H_2 - v32)
  let v41 := (-(((v33 * v19) + (v34 * (0 : Float))) + (v35 * v22)))
  let v47 := (-(((r_0 * v19) + (r_1 * (0 : Float))) + (r_2 * v22)))
  let v51 := (((1 : Float) / v27) + ((1 : Float) / v28))
  let v60 := (((v47 ^ 2) * v51) - ((((r_0 * r_0) + (r_1 * r_1)) + (r_2 * r_2)) / v28))
  let v71 := (((((2 : Float) * v41) * v47) * v51) - (((2 : Float) * (((v33 * r_0) + (v34 * r_1)) + (v35 * r_2))) / v28))
  let v88 := (Float.sqrt (max ((v71 ^ 2) - (((4 : Float) * v60) * ((((v41 ^ 2) * v51) - ((((v33 * v33) + (v34 * v34)) + (v35 * v35)) / v28)) - (1 : Float)))) (0 : Float)))
  let v89 := (-v71)
  let v91 := ((2 : Float) * v60)
  let v92 := ((v89 - v88) / v91)
  let v94 := ((v89 + v88) / v91)
  let v100 := ((v92 > (0.000001 : Float)) && ((v41 + (v92 * v47)) > (0 : Float)))
  let v105 := ((v94 > (0.000001 : Float)) && ((v41 + (v94 * v47)) > (0 : Float)))
  let v111 := (if (v100 && v105) then (min v92 v94) else (if v100 then v92 else (if v105 then v94 else (-(1 : Float)))))
  let v113 := (H_0 + (v111 * r_0))
  let v115 := (H_1 + (v111 * r_1))
  let v117 := (H_2 + (v111 * r_2))
  let v119 := (v41 + (v111 * v47))
  let v122 := ((v113 - v29) + (v119 * v19))
  let v125 := ((v115 - v30) + (v119 * (0 : Float)))
  let v128 := ((v117 - v32) + (v119 * v22))
  let v138 := (-(v119 / v27))
  let v141 := ((v138 * v19) - (v122 / v28))
  let v144 := ((v138 * (0 : Float)) - (v125 / v28))
  let v147 := ((v138 * v22) - (v128 / v28))
  let v154 := (Float.sqrt (max (((v141 * v141) + (v144 * v144)) + (v147 * v147)) (0.000000000000000001 : Float)))
  let v155 := (v141 / v154)
  let v156 := (v144 / v154)
  let v157 := (v147 / v154)
  let v163 := ((onPanel > (0.5 : Float)) && ((v111 > (0 : Float)) && ((Float.sqrt (max (((v122 * v122) + (v125 * v125)) + (v128 * v128)) (0.000000000000000001 : Float))) <= rm)))
  let v169 := ((2 : Float) * (((r_0 * v155) + (r_1 * v156)) + (r_2 * v157)))
  let v171 := (r_0 - (v169 * v155))
  let v173 := (r_1 - (v169 * v156))
  let v175 := (r_2 - (v169 * v157))
  let v176 := ((1 : Float) + k)
  let v177 := ((1 : Float) / R)
  let v194 := ((((2 : Float) * v177) * (((v113 * v171) + (v115 * v173)) + ((v176 * v117) * v175))) - ((2 : Float) * v175))
  let v203 := ((v177 * (((v113 ^ 2) + (v115 ^ 2)) + (v176 * (v117 ^ 2)))) - ((2 : Float) * v117))
  let v213 := (((2 : Float) * v203) / ((-v194) - (Float.sqrt (max ((v194 ^ 2) - (((4 : Float) * (v177 * (((v171 ^ 2) + (v173 ^ 2)) + (v176 * (v175 ^ 2))))) * v203)) (0 : Float)))))
  let v215 := (v113 + (v213 * v171))
  let v222 := (Float.abs (v115 + (v213 * v173)))
  let v232 := (!(v213 > (0 : Float)) || ((!(((Float.abs v215) <= a) && (v222 <= a))) || ((v222 <= (slotW / (2 : Float))) && (v215 >= (0 : Float)))))
  let v233 := (v19 * L)
  let v234 := ((0 : Float) * L)
  let v236 := (f + (v22 * L))
  let v250 := (((((v233 - v113) * v19) + ((v234 - v115) * (0 : Float))) + ((v236 - v117) * v22)) / (((v171 * v19) + (v173 * (0 : Float))) + (v175 * v22)))
  let v268 := (((Float.sqrt (((((v113 + (v250 * v171)) - v233) ^ 2) + (((v115 + (v250 * v173)) - v234) ^ 2)) + (((v117 + (v250 * v175)) - v236) ^ 2))) <= rt) && (v250 > (0 : Float)))
  let v271 := (if (v163 && (v232 && v268)) then (1 : Float) else (0 : Float))
  ((feq v271 (0 : Float)) || (feq v271 (1 : Float)))

#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 1.177587 1.119038 1.060489 1.001940 0.943392 0.884843 0.826294 0.767745 0.709196 0.650648 0.592099 0.533550 0.475001 0.416452 0.357904 0.299355 0.240806 1.782257))
#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 0.846395 0.787846 0.729297 0.670748 0.612200 0.553651 0.495102 0.436553 0.378004 0.319456 0.260907 0.202358 1.743809 1.685260 1.626712 1.568163 1.509614 1.451065))
#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 0.515203 0.456654 0.398105 0.339556 0.281008 0.222459 1.763910 1.705361 1.646812 1.588264 1.529715 1.471166 1.412617 1.354068 1.295520 1.236971 1.178422 1.119873))

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

#eval IO.println ("traceConic " ++ toString ((traceConic 0.991435 0.932886 0.874337 0.815788 0.757240 0.698691 0.640142 0.581593 0.523044).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.660243 0.601694 0.543145 0.484596 0.426048 0.367499 0.308950 0.250401 1.791852).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.329051 0.270502 0.211953 1.753404 1.694856 1.636307 1.577758 1.519209 1.460660).map Float.toBits))

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

#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.805283 0.746734 0.688185 0.629636 0.571088 0.512539 0.453990 0.395441 0.336892 0.278344).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.474091 0.415542 0.356993 0.298444 0.239896 1.781347 1.722798 1.664249 1.605700 1.547152).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.742899 1.684350 1.625801 1.567252 1.508704 1.450155 1.391606 1.333057 1.274508 1.215960).map Float.toBits))

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

#eval IO.println ("traceRay " ++ toString ((traceRay 0.432979 0.374430 0.315881 0.257332 1.798784 1.740235 1.681686 1.623137 1.564588 1.506040 1.447491 1.388942).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.701787 1.643238 1.584689 1.526140 1.467592 1.409043 1.350494 1.291945 1.233396 1.174848 1.116299 1.057750).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.370595 1.312046 1.253497 1.194948 1.136400 1.077851 1.019302 0.960753 0.902204 0.843656 0.785107 0.726558).map Float.toBits))

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

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.246827 1.788278 1.729729 1.671180 1.612632 1.554083 1.495534 1.436985 1.378436 1.319888 1.261339 1.202790 1.144241 1.085692 1.027144 0.968595 0.910046 0.851497).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.515635 1.457086 1.398537 1.339988 1.281440 1.222891 1.164342 1.105793 1.047244 0.988696 0.930147 0.871598 0.813049 0.754500 0.695952 0.637403 0.578854 0.520305).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.184443 1.125894 1.067345 1.008796 0.950248 0.891699 0.833150 0.774601 0.716052 0.657504 0.598955 0.540406 0.481857 0.423308 0.364760 0.306211 0.247662 1.789113).map Float.toBits))

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

#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.660675 1.602126 1.543577 1.485028 1.426480 1.367931 1.309382 1.250833 1.192284 1.133736 1.075187 1.016638 0.958089).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.329483 1.270934 1.212385 1.153836 1.095288 1.036739 0.978190 0.919641 0.861092 0.802544 0.743995 0.685446 0.626897).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.998291 0.939742 0.881193 0.822644 0.764096 0.705547 0.646998 0.588449 0.529900 0.471352 0.412803 0.354254 0.295705).map Float.toBits))

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

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.474523 1.415974 1.357425 1.298876 1.240328 1.181779 1.123230 1.064681 1.006132 0.947584 0.889035 0.830486 0.771937 0.713388 0.654840 0.596291 0.537742 0.479193 0.420644).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.143331 1.084782 1.026233 0.967684 0.909136 0.850587 0.792038 0.733489 0.674940 0.616392 0.557843 0.499294 0.440745 0.382196 0.323648 0.265099 0.206550 1.748001 1.689452).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.812139 0.753590 0.695041 0.636492 0.577944 0.519395 0.460846 0.402297 0.343748 0.285200 0.226651 1.768102 1.709553 1.651004 1.592456 1.533907 1.475358 1.416809 1.358260).map Float.toBits))

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

#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.288371 1.229822 1.171273 1.112724 1.054176 0.995627 0.937078 0.878529).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.957179 0.898630 0.840081 0.781532 0.722984 0.664435 0.605886 0.547337).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.625987 0.567438 0.508889 0.450340 0.391792 0.333243 0.274694 0.216145).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.102219 1.043670 0.985121))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.771027 0.712478 0.653929))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.439835 0.381286 0.322737))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.916067))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.584875))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.253683))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.729915 0.671366 0.612817 0.554268))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.398723 0.340174 0.281625 0.223076))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 1.667531 1.608982 1.550433 1.491884))

def tunnelThroughput  : Float :=
  ((0.94 : Float) * (0.96 : Float))

#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)
#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)
#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)

def turnLoss (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (Tin : Float) : Float :=
  let v8 := (Ac / (8 : Float))
  ((((eps * (0.0000000567 : Float)) * v8) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v8) * (Tin - Ta)))

#eval IO.println ("turnLoss " ++ toString (turnLoss 0.357611 0.299062 0.240513 1.781964 1.723416).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 1.626419 1.567870 1.509321 1.450772 1.392224).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 1.295227 1.236678 1.178129 1.119580 1.061032).toBits)

def turnOut (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Float :=
  let v12 := (Ac / (8 : Float))
  (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))

#eval IO.println ("turnOut " ++ toString (turnOut 1.771459 1.712910 1.654361 1.595812 1.537264 1.478715 1.420166 1.361617).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 1.440267 1.381718 1.323169 1.264620 1.206072 1.147523 1.088974 1.030425).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 1.109075 1.050526 0.991977 0.933428 0.874880 0.816331 0.757782 0.699233).toBits)

def check_turnOut_eq (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Bool :=
  let v12 := (Ac / (8 : Float))
  let v24 := (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))
  (feq v24 v24)

#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.585307 1.526758 1.468209 1.409660 1.351112 1.292563 1.234014 1.175465))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.254115 1.195566 1.137017 1.078468 1.019920 0.961371 0.902822 0.844273))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 0.922923 0.864374 0.805825 0.747276 0.688728 0.630179 0.571630 0.513081))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 1.399155 1.340606 1.282057).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.067963 1.009414 0.950865).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 0.736771 0.678222 0.619673).map Float.toBits))

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 1.213003 1.154454 1.095905 1.037356 0.978808 0.920259).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.881811 0.823262 0.764713 0.706164 0.647616 0.589067).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.550619 0.492070 0.433521 0.374972 0.316424 0.257875).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 1.026851 0.968302 0.909753 0.851204 0.792656 0.734107).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 0.695659 0.637110 0.578561 0.520012 0.461464 0.402915).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 0.364467 0.305918 0.247369 1.788820 1.730272 1.671723).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 0.840699 0.782150 0.723601 0.665052 0.606504 0.547955 0.489406 0.430857 0.372308 0.313760 0.255211 1.796662 1.738113).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 0.509507 0.450958 0.392409 0.333860 0.275312 0.216763 1.758214 1.699665 1.641116 1.582568 1.524019 1.465470 1.406921).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.778315 1.719766 1.661217 1.602668 1.544120 1.485571 1.427022 1.368473 1.309924 1.251376 1.192827 1.134278 1.075729).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 0.654547 0.595998 0.537449 0.478900 0.420352 0.361803 0.303254 0.244705 1.786156 1.727608 1.669059 1.610510).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.323355 0.264806 0.206257 1.747708 1.689160 1.630611 1.572062 1.513513 1.454964 1.396416 1.337867 1.279318).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 1.592163 1.533614 1.475065 1.416516 1.357968 1.299419 1.240870 1.182321 1.123772 1.065224 1.006675 0.948126).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.468395 0.409846 0.351297 0.292748 0.234200 1.775651 1.717102 1.658553 1.600004 1.541456 1.482907 1.424358).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.737203 1.678654 1.620105 1.561556 1.503008 1.444459 1.385910 1.327361 1.268812 1.210264 1.151715 1.093166).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.406011 1.347462 1.288913 1.230364 1.171816 1.113267 1.054718 0.996169 0.937620 0.879072 0.820523 0.761974).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 0.282243 0.223694 1.765145 1.706596 1.648048 1.589499 1.530950 1.472401 1.413852 1.355304 1.296755 1.238206).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 1.551051 1.492502 1.433953 1.375404 1.316856 1.258307 1.199758 1.141209 1.082660 1.024112 0.965563 0.907014).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 1.219859 1.161310 1.102761 1.044212 0.985664 0.927115 0.868566 0.810017 0.751468 0.692920 0.634371 0.575822).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.696091 1.637542 1.578993 1.520444 1.461896 1.403347 1.344798 1.286249 1.227700 1.169152 1.110603 1.052054).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.364899 1.306350 1.247801 1.189252 1.130704 1.072155 1.013606 0.955057 0.896508 0.837960 0.779411 0.720862).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.033707 0.975158 0.916609 0.858060 0.799512 0.740963 0.682414 0.623865 0.565316 0.506768 0.448219 0.389670).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 1.509939 1.451390 1.392841 1.334292 1.275744 1.217195).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.178747 1.120198 1.061649 1.003100 0.944552 0.886003).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 0.847555 0.789006 0.730457 0.671908 0.613360 0.554811).map Float.toBits))

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

#eval IO.println ("wireLen " ++ toString (wireLen 1.137635 1.079086 1.020537 0.961988 0.903440).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 0.806443 0.747894 0.689345 0.630796 0.572248).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 0.475251 0.416702 0.358153 0.299604 0.241056).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 0.951483 0.892934 0.834385 0.775836).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 0.620291 0.561742 0.503193 0.444644).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 0.289099 0.230550 1.772001 1.713452).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.765331 0.706782 0.648233 0.589684 0.531136))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.434139 0.375590 0.317041 0.258492 1.799944))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.702947 1.644398 1.585849 1.527300 1.468752))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.579179 0.520630 0.462081 0.403532))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.247987 1.789438 1.730889 1.672340))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.516795 1.458246 1.399697 1.341148))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.393027 0.334478 0.275929 0.217380))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.661835 1.603286 1.544737 1.486188))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.330643 1.272094 1.213545 1.154996))

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

#eval IO.println ("wireTension " ++ toString (wireTension 1.434571 1.376022 1.317473 1.258924).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.103379 1.044830 0.986281 0.927732).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 0.772187 0.713638 0.655089 0.596540).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.248419 1.189870 1.131321 1.072772 1.014224 0.955675 0.897126 0.838577))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.917227 0.858678 0.800129 0.741580 0.683032 0.624483 0.565934 0.507385))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.586035 0.527486 0.468937 0.410388 0.351840 0.293291 0.234742 1.776193))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.876115 0.817566 0.759017 0.700468))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.544923 0.486374 0.427825 0.369276))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.213731 1.755182 1.696633 1.638084))

def wrapRad (d : Float) : Float :=
  let v3 := ((2 : Float) * (3.141592653589793 : Float))
  (d - (v3 * (Float.floor ((d + (3.141592653589793 : Float)) / v3))))

#eval IO.println ("wrapRad " ++ toString (wrapRad 0.689963).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.358771).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 1.627579).toBits)

def check_wrapRad_mem (d : Float) : Bool :=
  let v4 := ((2 : Float) * (3.141592653589793 : Float))
  let v9 := (d - (v4 * (Float.floor ((d + (3.141592653589793 : Float)) / v4))))
  (((-(3.141592653589793 : Float)) <= v9) && (v9 < (3.141592653589793 : Float)))

#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.503811))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 1.772619))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 1.441427))

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.317659 0.259110 0.200561 1.742012 1.683464 1.624915).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.586467 1.527918 1.469369 1.410820 1.352272 1.293723).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.255275 1.196726 1.138177 1.079628 1.021080 0.962531).map Float.toBits))

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

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.359203 1.300654 1.242105))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.028011 0.969462 0.910913))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.696819 0.638270 0.579721))

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
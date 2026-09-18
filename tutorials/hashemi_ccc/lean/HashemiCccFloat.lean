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

def azRate (omegam : Float) (rw : Float) (R : Float) : Float :=
  ((omegam * rw) / R)

#eval IO.println ("azRate " ++ toString (azRate 0.287651 0.229102 1.770553).toBits)
#eval IO.println ("azRate " ++ toString (azRate 1.556459 1.497910 1.439361).toBits)
#eval IO.println ("azRate " ++ toString (azRate 1.225267 1.166718 1.108169).toBits)

def check_azRate_pos (omegam : Float) (rw : Float) (R : Float) : Bool :=
  (!((0 : Float) < omegam) || (!((0 : Float) < rw) || (!((0 : Float) < R) || ((0 : Float) < ((omegam * rw) / R)))))

#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 1.701499 1.642950 1.584401))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 1.370307 1.311758 1.253209))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 1.039115 0.980566 0.922017))

def check_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 1.515347))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 1.184155))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 0.852963))

def bisectStep (ym : Float) (hp : Float) (a : Float) (ze : Float) (L : Float) (lohi_1 : Float) (lohi_2 : Float) : Array Float :=
  let v9 := ((lohi_1 + lohi_2) / (2 : Float))
  let v11 := (-a)
  let v12 := (Float.cos v9)
  let v14 := (-ze)
  let v15 := (Float.sin v9)
  let v28 := (L < (Float.sqrt (((((v11 * v12) + (v14 * v15)) - (-ym)) ^ 2) + (((((-v11) * v15) + (v14 * v12)) - hp) ^ 2))))
  #[(if v28 then v9 else lohi_1), (if v28 then lohi_2 else v9)]

#eval IO.println ("bisectStep " ++ toString ((bisectStep 1.329195 1.270646 1.212097 1.153548 1.095000 1.036451 0.977902).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.998003 0.939454 0.880905 0.822356 0.763808 0.705259 0.646710).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.666811 0.608262 0.549713 0.491164 0.432616 0.374067 0.315518).map Float.toBits))

def boltStress (W : Float) (reach : Float) (d : Float) : Float :=
  (((W / (2 : Float)) * reach) / (((3.141592653589793 : Float) * (d ^ 3)) / (32 : Float)))

#eval IO.println ("boltStress " ++ toString (boltStress 1.143043 1.084494 1.025945).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 0.811851 0.753302 0.694753).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 0.480659 0.422110 0.363561).toBits)

def braceHeight (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (Float.sqrt ((l_brace ^ 2) - ((l_foot - l_footShort) ^ 2)))

#eval IO.println ("braceHeight " ++ toString (braceHeight 0.956891 0.898342 0.839793 0.781244 0.722696).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 0.625699 0.567150 0.508601 0.450052 0.391504).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 0.294507 0.235958 1.777409 1.718860 1.660312).toBits)

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

#eval IO.println ("cableDrop " ++ toString (cableDrop 1.626131 1.567582).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 1.294939 1.236390).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 0.963747 0.905198).toBits)

def check_cable_drop_small (L : Float) (I : Float) : Bool :=
  (!(L <= (4 : Float)) || (!((0 : Float) <= I) || (!(I <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float)) < (0.1 : Float)))))

#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.439979 1.381430))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.108787 1.050238))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.777595 0.719046))

def captureS (rc : Float) (rad : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((rc - rad) / (0.005 : Float)))))

#eval IO.println ("captureS " ++ toString (captureS 1.253827 1.195278).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.922635 0.864086).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.591443 0.532894).toBits)

def check_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 1.067675 1.009126 0.950577))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.736483 0.677934 0.619385))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.405291 0.346742 0.288193))

def clearance (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (holeDown : Float) (reach : Float) : Float :=
  ((l_upright - holeDown) - reach)

#eval IO.println ("clearance " ++ toString (clearance 0.881523 0.822974 0.764425 0.705876 0.647328 0.588779 0.530230).toBits)
#eval IO.println ("clearance " ++ toString (clearance 0.550331 0.491782 0.433233 0.374684 0.316136 0.257587 1.799038).toBits)
#eval IO.println ("clearance " ++ toString (clearance 0.219139 1.760590 1.702041 1.643492 1.584944 1.526395 1.467846).toBits)

def check_clearance_hashemi (holeDown : Float) : Bool :=
  let v16 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v16) && (v16 < ((0.146 : Float) - holeDown)))

#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.695371))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.364179))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.632987))

def coilCapture (rs : Float) (rc : Float) (d : Float) : Float :=
  let v9 := (rs ^ 2)
  let v10 := (d ^ 2)
  let v12 := (rc ^ 2)
  let v15 := ((2 : Float) * d)
  let v30 := (d + rs)
  (if ((rs + rc) <= d) then (0 : Float) else (if (d <= (rc - rs)) then (1 : Float) else ((((v9 * (Float.acos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Float.acos (((v10 + v12) - v9) / (v15 * rc))))) - ((Float.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : Float))) / ((3.141592653589793 : Float) * v9))))

#eval IO.println ("coilCapture " ++ toString (coilCapture 0.509219 0.450670 0.392121).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.778027 1.719478 1.660929).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.446835 1.388286 1.329737).toBits)

def conicHitS (c : Float) (k : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Float :=
  let v9 := ((1 : Float) + k)
  let v27 := ((((2 : Float) * c) * (((O_0 * d_0) + (O_1 * d_1)) + ((v9 * O_2) * d_2))) - ((2 : Float) * d_2))
  let v36 := ((c * (((O_0 ^ 2) + (O_1 ^ 2)) + (v9 * (O_2 ^ 2)))) - ((2 : Float) * O_2))
  (((2 : Float) * v36) / ((-v27) - (Float.sqrt (max ((v27 ^ 2) - (((4 : Float) * (c * (((d_0 ^ 2) + (d_1 ^ 2)) + (v9 * (d_2 ^ 2))))) * v36)) (0 : Float)))))

#eval IO.println ("conicHitS " ++ toString (conicHitS 0.323067 0.264518 0.205969 1.747420 1.688872 1.630323 1.571774 1.513225).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 1.591875 1.533326 1.474777 1.416228 1.357680 1.299131 1.240582 1.182033).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 1.260683 1.202134 1.143585 1.085036 1.026488 0.967939 0.909390 0.850841).toBits)

def conicSlope (c : Float) (k : Float) (r : Float) : Float :=
  ((c * r) / (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : Float))))

#eval IO.println ("conicSlope " ++ toString (conicSlope 1.736915 1.678366 1.619817).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.405723 1.347174 1.288625).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.074531 1.015982 0.957433).toBits)

def conicZ (c : Float) (k : Float) (r : Float) : Float :=
  let v3 := (r ^ 2)
  ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * v3)) (0 : Float)))))

#eval IO.println ("conicZ " ++ toString (conicZ 1.550763 1.492214 1.433665).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 1.219571 1.161022 1.102473).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 0.888379 0.829830 0.771281).toBits)

def check_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.364611 1.306062))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.033419 0.974870))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.702227 0.643678))

def check_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v4 := (c ^ 2)
  let v5 := (r ^ 2)
  let v18 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v4 * v5) <= (1 : Float)) || (feq ((c * v5) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v4) * v5)) (0 : Float))))) (v18 - (Float.sqrt ((v18 ^ 2) - v5))))))

#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.178459 1.119910))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.847267 0.788718))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.516075 0.457526))

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

#eval IO.println ("constraints " ++ toString ((constraints 0.992307 0.933758 0.875209 0.816660 0.758112 0.699563 0.641014 0.582465 0.523916 0.465368 0.406819 0.348270).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.661115 0.602566 0.544017 0.485468 0.426920 0.368371 0.309822 0.251273 1.792724 1.734176 1.675627 1.617078).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.329923 0.271374 0.212825 1.754276 1.695728 1.637179 1.578630 1.520081 1.461532 1.402984 1.344435 1.285886).map Float.toBits))

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

#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.806155 0.747606 0.689057 0.630508 0.571960 0.513411 0.454862 0.396313 0.337764 0.279216 0.220667 1.762118).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.474963 0.416414 0.357865 0.299316 0.240768 1.782219 1.723670 1.665121 1.606572 1.548024 1.489475 1.430926).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.743771 1.685222 1.626673 1.568124 1.509576 1.451027 1.392478 1.333929 1.275380 1.216832 1.158283 1.099734).map Float.toBits))

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

#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.620003 0.561454 0.502905 0.444356 0.385808 0.327259 0.268710 0.210161 1.751612 1.693064 1.634515 1.575966))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.288811 0.230262 1.771713 1.713164 1.654616 1.596067 1.537518 1.478969 1.420420 1.361872 1.303323 1.244774))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.557619 1.499070 1.440521 1.381972 1.323424 1.264875 1.206326 1.147777 1.089228 1.030680 0.972131 0.913582))

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

#eval IO.println ("cross3 " ++ toString ((cross3 1.661547 1.602998 1.544449 1.485900 1.427352 1.368803).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 1.330355 1.271806 1.213257 1.154708 1.096160 1.037611).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 0.999163 0.940614 0.882065 0.823516 0.764968 0.706419).map Float.toBits))

def deadPoint (ym : Float) (hp : Float) (a : Float) (ze : Float) : Float :=
  let v4 := (ym * a)
  let v5 := (hp * ze)
  (if (v4 <= v5) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v4 - v5))))

#eval IO.println ("deadPoint " ++ toString (deadPoint 1.475395 1.416846 1.358297 1.299748).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.144203 1.085654 1.027105 0.968556).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 0.813011 0.754462 0.695913 0.637364).toBits)

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

#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.916939 0.858390).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.585747 0.527198).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.254555 1.796006).map Float.toBits))

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

#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.730787 0.672238 0.613689))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.399595 0.341046 0.282497))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.668403 1.609854 1.551305))

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

#eval IO.println ("dishPower " ++ toString ((dishPower 1.772331 1.713782 1.655233 1.596684 1.538136 1.479587 1.421038 1.362489 1.303940 1.245392 1.186843 1.128294 1.069745 1.011196 0.952648 0.894099 0.835550 0.777001 0.718452 0.659904 0.601355 0.542806 0.484257 0.425708).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.441139 1.382590 1.324041 1.265492 1.206944 1.148395 1.089846 1.031297 0.972748 0.914200 0.855651 0.797102 0.738553 0.680004 0.621456 0.562907 0.504358 0.445809 0.387260 0.328712 0.270163 0.211614 1.753065 1.694516).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.109947 1.051398 0.992849 0.934300 0.875752 0.817203 0.758654 0.700105 0.641556 0.583008 0.524459 0.465910 0.407361 0.348812 0.290264 0.231715 1.773166 1.714617 1.656068 1.597520 1.538971 1.480422 1.421873 1.363324).map Float.toBits))

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

#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.586179 1.527630 1.469081 1.410532 1.351984 1.293435 1.234886 1.176337 1.117788 1.059240 1.000691 0.942142 0.883593 0.825044 0.766496 0.707947 0.649398 0.590849 0.532300 0.473752 0.415203 0.356654 0.298105 0.239556))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.254987 1.196438 1.137889 1.079340 1.020792 0.962243 0.903694 0.845145 0.786596 0.728048 0.669499 0.610950 0.552401 0.493852 0.435304 0.376755 0.318206 0.259657 0.201108 1.742560 1.684011 1.625462 1.566913 1.508364))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.923795 0.865246 0.806697 0.748148 0.689600 0.631051 0.572502 0.513953 0.455404 0.396856 0.338307 0.279758 0.221209 1.762660 1.704112 1.645563 1.587014 1.528465 1.469916 1.411368 1.352819 1.294270 1.235721 1.177172))

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

#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.400027 1.341478 1.282929 1.224380 1.165832 1.107283 1.048734 0.990185 0.931636 0.873088 0.814539 0.755990 0.697441 0.638892 0.580344 0.521795 0.463246 0.404697 0.346148 0.287600 0.229051 1.770502 1.711953 1.653404))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.068835 1.010286 0.951737 0.893188 0.834640 0.776091 0.717542 0.658993 0.600444 0.541896 0.483347 0.424798 0.366249 0.307700 0.249152 1.790603 1.732054 1.673505 1.614956 1.556408 1.497859 1.439310 1.380761 1.322212))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.737643 0.679094 0.620545 0.561996 0.503448 0.444899 0.386350 0.327801 0.269252 0.210704 1.752155 1.693606 1.635057 1.576508 1.517960 1.459411 1.400862 1.342313 1.283764 1.225216 1.166667 1.108118 1.049569 0.991020))

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

#eval IO.println ("dot3 " ++ toString (dot3 0.469267 0.410718 0.352169 0.293620 0.235072 1.776523).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.738075 1.679526 1.620977 1.562428 1.503880 1.445331).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.406883 1.348334 1.289785 1.231236 1.172688 1.114139).toBits)

def check_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v21 := (Float.sqrt ((v16 ^ 2) + (c_apexH ^ 2)))
  let v23 := (-((F * v16) / v21))
  let v25 := ((F * c_apexH) / v21)
  (feq (((((((0 : Float) * ((v16 * (0 : Float)) - (b_zRail * v25))) + ((0 : Float) * ((b_zRail * v23) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v25) - (v16 * v23)))) + ((0 : Float) * v23)) + ((0 : Float) * v25)) + ((0 : Float) * (0 : Float))) (F * v21))

#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.283115 0.224566 1.766017 1.707468 1.648920 1.590371 1.531822 1.473273 1.414724 1.356176 1.297627 1.239078 1.180529))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.551923 1.493374 1.434825 1.376276 1.317728 1.259179 1.200630 1.142081 1.083532 1.024984 0.966435 0.907886 0.849337))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.220731 1.162182 1.103633 1.045084 0.986536 0.927987 0.869438 0.810889 0.752340 0.693792 0.635243 0.576694 0.518145))

def check_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v17 := (c_chord / (2 : Float))
  let v22 := (Float.sqrt ((v17 ^ 2) + (c_apexH ^ 2)))
  let v24 := (-((F * v17) / v22))
  let v26 := ((F * c_apexH) / v22)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v17 * (0 : Float)) - (b_zRail * v26))) + ((0 : Float) * ((b_zRail * v24) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v26) - (v17 * v24)))) + ((0 : Float) * v24)) + ((0 : Float) * v26)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.696963 1.638414 1.579865 1.521316 1.462768 1.404219 1.345670 1.287121 1.228572 1.170024 1.111475 1.052926 0.994377))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.365771 1.307222 1.248673 1.190124 1.131576 1.073027 1.014478 0.955929 0.897380 0.838832 0.780283 0.721734 0.663185))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.034579 0.976030 0.917481 0.858932 0.800384 0.741835 0.683286 0.624737 0.566188 0.507640 0.449091 0.390542 0.331993))

def edgeClipAt (a : Float) (ze : Float) (t : Float) : Array Float :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  #[((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))]

#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.510811 1.452262 1.393713).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.179619 1.121070 1.062521).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.848427 0.789878 0.731329).map Float.toBits))

def check_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (feq (((-ym) * (((-v6) * v10) + (v9 * v7))) - (hp * ((v6 * v7) + (v9 * v10)))) ((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)))

#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.324659 1.266110 1.207561 1.149012 1.090464))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.993467 0.934918 0.876369 0.817820 0.759272))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.662275 0.603726 0.545177 0.486628 0.428080))

def check_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  (feq ((((v3 * v4) + (v6 * v7)) ^ 2) + ((((-v3) * v7) + (v6 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.138507 1.079958 1.021409))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.807315 0.748766 0.690217))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.476123 0.417574 0.359025))

def check_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v6 := (Float.sqrt (3.36 : Float))
  let v9 := (-(v6 - (1 : Float)))
  let v10 := (Float.sin t)
  (feq ((((v2 * v3) + (v9 * v10)) ^ 2) + ((((-v2) * v10) + (v9 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v6)))

#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.952355))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.621163))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.289971))

def check_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  ((Float.abs ((v3 * v4) + (v6 * v7))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.766203 0.707654 0.649105))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.435011 0.376462 0.317913))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.703819 1.645270 1.586721))

def edgeDepth (f : Float) (a : Float) (sag : Float) (el : Float) : Float :=
  (((f - sag) * (Float.sin el)) + (a * (Float.cos el)))

#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.580051 0.521502 0.462953 0.404404).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.248859 1.790310 1.731761 1.673212).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.517667 1.459118 1.400569 1.342020).toBits)

def check_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.393899 0.335350 0.276801))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.662707 1.604158 1.545609))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.331515 1.272966 1.214417))

def check_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.207747 1.749198 1.690649 1.632100))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.476555 1.418006 1.359457 1.300908))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.145363 1.086814 1.028265 0.969716))

def check_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.621595 1.563046 1.504497))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.290403 1.231854 1.173305))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.959211 0.900662 0.842113))

def check_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v10 := (Float.cos t)
  let v17 := (-a)
  let v19 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v10 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v17) * v5) + (v19 * v10))) - (hp * ((v17 * v10) + (v19 * v5)))) (0 : Float)))

#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.435443 1.376894 1.318345 1.259796 1.201248))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.104251 1.045702 0.987153 0.928604 0.870056))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.773059 0.714510 0.655961 0.597412 0.538864))

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

#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.249291 1.190742 1.132193 1.073644 1.015096))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.918099 0.859550 0.801001 0.742452 0.683904))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.586907 0.528358 0.469809 0.411260 0.352712))

def elPower (W : Float) (rcm : Float) (t : Float) (omega : Float) : Float :=
  (((W * rcm) * (Float.sin t)) * omega)

#eval IO.println ("elPower " ++ toString (elPower 1.063139 1.004590 0.946041 0.887492).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.731947 0.673398 0.614849 0.556300).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.400755 0.342206 0.283657 0.225108).toBits)

def check_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v9 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v9 / rw) * (rw * omega)) (v9 * omega)))

#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.876987 0.818438 0.759889 0.701340 0.642792))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.545795 0.487246 0.428697 0.370148 0.311600))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.214603 1.756054 1.697505 1.638956 1.580408))

def check_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v8 * (Float.sin t)) * omega) <= (v8 * omega)))))

#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.690835 0.632286 0.573737 0.515188))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.359643 0.301094 0.242545 1.783996))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.628451 1.569902 1.511353 1.452804))

def elRate (omegad : Float) (rDrum : Float) (rw : Float) : Float :=
  ((omegad * rDrum) / rw)

#eval IO.println ("elRate " ++ toString (elRate 0.504683 0.446134 0.387585).toBits)
#eval IO.println ("elRate " ++ toString (elRate 1.773491 1.714942 1.656393).toBits)
#eval IO.println ("elRate " ++ toString (elRate 1.442299 1.383750 1.325201).toBits)

def facetSpot (w : Float) (f : Float) : Float :=
  (w + (f * (0.0093 : Float)))

#eval IO.println ("facetSpot " ++ toString (facetSpot 0.318531 0.259982).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.587339 1.528790).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.256147 1.197598).toBits)

def check_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))

def focusShift (h : Float) (eps : Float) : Float :=
  (h * (Float.sin eps))

#eval IO.println ("focusShift " ++ toString (focusShift 1.546227 1.487678).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.215035 1.156486).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 0.883843 0.825294).toBits)

def check_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v1 := (Float.cos psi)
  let v7 := (Float.sin psi)
  (!(!(feq v1 (1 : Float))) || (!((feq ((v1 * p_1) - (v7 * p_2)) p_1) && (feq ((v7 * p_1) + (v1 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.360075 1.301526 1.242977))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.028883 0.970334 0.911785))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 0.697691 0.639142 0.580593))

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

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.987771 0.929222 0.870673 0.812124 0.753576 0.695027 0.636478 0.577929 0.519380 0.460832 0.402283 0.343734))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.656579 0.598030 0.539481 0.480932 0.422384 0.363835 0.305286 0.246737 1.788188 1.729640 1.671091 1.612542))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.325387 0.266838 0.208289 1.749740 1.691192 1.632643 1.574094 1.515545 1.456996 1.398448 1.339899 1.281350))

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

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.801619 0.743070 0.684521 0.625972 0.567424 0.508875 0.450326 0.391777 0.333228 0.274680 0.216131 1.757582))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.470427 0.411878 0.353329 0.294780 0.236232 1.777683 1.719134 1.660585 1.602036 1.543488 1.484939 1.426390))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.739235 1.680686 1.622137 1.563588 1.505040 1.446491 1.387942 1.329393 1.270844 1.212296 1.153747 1.095198))

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

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.615467 0.556918 0.498369 0.439820 0.381272 0.322723 0.264174 0.205625 1.747076 1.688528 1.629979 1.571430))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.284275 0.225726 1.767177 1.708628 1.650080 1.591531 1.532982 1.474433 1.415884 1.357336 1.298787 1.240238))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.553083 1.494534 1.435985 1.377436 1.318888 1.260339 1.201790 1.143241 1.084692 1.026144 0.967595 0.909046))

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 0.243163 1.784614 1.726065 1.667516).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.511971 1.453422 1.394873 1.336324).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.180779 1.122230 1.063681 1.005132).toBits)

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

#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.912403 0.853854 0.795305 0.736756 0.678208 0.619659 0.561110 0.502561 0.444012 0.385464 0.326915 0.268366 0.209817 1.751268 1.692720 1.634171 1.575622 1.517073 1.458524 1.399976 1.341427 1.282878 1.224329 1.165780 1.107232 1.048683 0.990134 0.931585 0.873036 0.814488 0.755939 0.697390 0.638841 0.580292 0.521744 0.463195 0.404646 0.346097 #[1.189019, 1.130470, 1.071921, 1.013372, 0.954824, 0.896275, 0.837726, 0.779177, 0.720628, 0.662080, 0.603531, 0.544982, 0.486433, 0.427884, 0.369336, 0.310787, 0.252238, 1.793689, 1.735140, 1.676592, 1.618043, 1.559494, 1.500945, 1.442396, 1.383848, 1.325299, 1.266750, 1.208201, 1.149652, 1.091104, 1.032555, 0.974006, 0.915457, 0.856908, 0.798360, 0.739811, 0.681262, 0.622713, 0.564164, 0.505616, 0.447067, 0.388518, 0.329969, 0.271420, 0.212872, 1.754323, 1.695774, 1.637225, 1.578676, 1.520128, 1.461579, 1.403030, 1.344481, 1.285932, 1.227384, 1.168835, 1.110286, 1.051737, 0.993188, 0.934640, 0.876091, 0.817542, 0.758993, 0.700444, 0.641896, 0.583347, 0.524798, 0.466249, 0.407700, 0.349152, 0.290603, 0.232054, 1.773505, 1.714956, 1.656408, 1.597859, 1.539310, 1.480761, 1.422212, 1.363664, 1.305115, 1.246566, 1.188017, 1.129468, 1.070920, 1.012371, 0.953822, 0.895273, 0.836724, 0.778176, 0.719627, 0.661078, 0.602529, 0.543980, 0.485432, 0.426883, 0.368334, 0.309785, 0.251236, 1.792688, 1.734139, 1.675590, 1.617041, 1.558492, 1.499944, 1.441395, 1.382846, 1.324297, 1.265748, 1.207200, 1.148651, 1.090102, 1.031553, 0.973004, 0.914456, 0.855907, 0.797358, 0.738809, 0.680260, 0.621712, 0.563163, 0.504614, 0.446065, 0.387516, 0.328968, 0.270419, 0.211870, 1.753321, 1.694772, 1.636224, 1.577675, 1.519126, 1.460577, 1.402028, 1.343480, 1.284931, 1.226382, 1.167833, 1.109284, 1.050736, 0.992187, 0.933638, 0.875089, 0.816540, 0.757992, 0.699443, 0.640894, 0.582345, 0.523796, 0.465248, 0.406699, 0.348150, 0.289601, 0.231052, 1.772504, 1.713955, 1.655406, 1.596857, 1.538308, 1.479760, 1.421211, 1.362662, 1.304113, 1.245564, 1.187016, 1.128467, 1.069918, 1.011369, 0.952820, 0.894272, 0.835723, 0.777174, 0.718625, 0.660076, 0.601528, 0.542979, 0.484430, 0.425881, 0.367332, 0.308784, 0.250235, 1.791686, 1.733137, 1.674588, 1.616040, 1.557491, 1.498942, 1.440393, 1.381844, 1.323296, 1.264747, 1.206198, 1.147649, 1.089100, 1.030552, 0.972003, 0.913454, 0.854905, 0.796356, 0.737808, 0.679259, 0.620710, 0.562161, 0.503612, 0.445064, 0.386515, 0.327966, 0.269417, 0.210868, 1.752320, 1.693771, 1.635222, 1.576673, 1.518124, 1.459576, 1.401027, 1.342478, 1.283929, 1.225380, 1.166832, 1.108283, 1.049734, 0.991185, 0.932636, 0.874088, 0.815539, 0.756990, 0.698441, 0.639892, 0.581344, 0.522795, 0.464246, 0.405697, 0.347148, 0.288600, 0.230051, 1.771502, 1.712953, 1.654404, 1.595856, 1.537307, 1.478758, 1.420209, 1.361660, 1.303112, 1.244563, 1.186014, 1.127465, 1.068916, 1.010368, 0.951819, 0.893270, 0.834721, 0.776172, 0.717624, 0.659075, 0.600526, 0.541977, 0.483428, 0.424880, 0.366331, 0.307782, 0.249233, 1.790684, 1.732136, 1.673587, 1.615038, 1.556489, 1.497940, 1.439392, 1.380843, 1.322294, 1.263745, 1.205196, 1.146648, 1.088099, 1.029550, 0.971001, 0.912452, 0.853904, 0.795355, 0.736806, 0.678257, 0.619708, 0.561160, 0.502611, 0.444062, 0.385513, 0.326964, 0.268416, 0.209867, 1.751318, 1.692769, 1.634220, 1.575672, 1.517123, 1.458574, 1.400025, 1.341476, 1.282928, 1.224379, 1.165830, 1.107281, 1.048732, 0.990184, 0.931635, 0.873086, 0.814537, 0.755988, 0.697440, 0.638891, 0.580342, 0.521793, 0.463244, 0.404696, 0.346147, 0.287598, 0.229049, 1.770500, 1.711952, 1.653403, 1.594854, 1.536305, 1.477756, 1.419208, 1.360659, 1.302110, 1.243561, 1.185012, 1.126464, 1.067915, 1.009366, 0.950817, 0.892268, 0.833720, 0.775171, 0.716622, 0.658073, 0.599524, 0.540976, 0.482427, 0.423878, 0.365329, 0.306780, 0.248232, 1.789683, 1.731134, 1.672585, 1.614036, 1.555488, 1.496939, 1.438390, 1.379841, 1.321292, 1.262744, 1.204195, 1.145646, 1.087097, 1.028548, 0.970000, 0.911451, 0.852902, 0.794353, 0.735804, 0.677256, 0.618707, 0.560158, 0.501609, 0.443060, 0.384512, 0.325963, 0.267414, 0.208865, 1.750316, 1.691768, 1.633219, 1.574670, 1.516121, 1.457572, 1.399024, 1.340475, 1.281926, 1.223377, 1.164828, 1.106280, 1.047731, 0.989182, 0.930633, 0.872084, 0.813536, 0.754987, 0.696438, 0.637889, 0.579340, 0.520792, 0.462243, 0.403694, 0.345145, 0.286596, 0.228048, 1.769499, 1.710950, 1.652401, 1.593852, 1.535304, 1.476755, 1.418206, 1.359657, 1.301108, 1.242560, 1.184011, 1.125462, 1.066913, 1.008364, 0.949816, 0.891267, 0.832718, 0.774169, 0.715620, 0.657072, 0.598523, 0.539974, 0.481425, 0.422876, 0.364328, 0.305779, 0.247230, 1.788681, 1.730132, 1.671584, 1.613035, 1.554486, 1.495937, 1.437388, 1.378840, 1.320291, 1.261742, 1.203193, 1.144644, 1.086096, 1.027547, 0.968998, 0.910449, 0.851900, 0.793352, 0.734803, 0.676254, 0.617705, 0.559156, 0.500608, 0.442059, 0.383510, 0.324961, 0.266412, 0.207864, 1.749315, 1.690766, 1.632217, 1.573668, 1.515120, 1.456571, 1.398022, 1.339473, 1.280924, 1.222376, 1.163827, 1.105278, 1.046729, 0.988180, 0.929632, 0.871083, 0.812534, 0.753985, 0.695436, 0.636888, 0.578339, 0.519790, 0.461241, 0.402692, 0.344144, 0.285595, 0.227046, 1.768497, 1.709948, 1.651400, 1.592851, 1.534302, 1.475753, 1.417204, 1.358656, 1.300107, 1.241558, 1.183009, 1.124460, 1.065912, 1.007363, 0.948814, 0.890265, 0.831716, 0.773168, 0.714619, 0.656070, 0.597521, 0.538972, 0.480424, 0.421875, 0.363326, 0.304777, 0.246228, 1.787680, 1.729131, 1.670582, 1.612033, 1.553484, 1.494936, 1.436387, 1.377838, 1.319289, 1.260740, 1.202192, 1.143643, 1.085094, 1.026545, 0.967996, 0.909448, 0.850899, 0.792350, 0.733801, 0.675252, 0.616704, 0.558155, 0.499606, 0.441057, 0.382508, 0.323960, 0.265411, 0.206862, 1.748313, 1.689764, 1.631216, 1.572667, 1.514118, 1.455569, 1.397020, 1.338472, 1.279923, 1.221374, 1.162825, 1.104276, 1.045728, 0.987179, 0.928630, 0.870081, 0.811532, 0.752984, 0.694435, 0.635886, 0.577337, 0.518788, 0.460240, 0.401691, 0.343142, 0.284593, 0.226044, 1.767496, 1.708947, 1.650398, 1.591849, 1.533300, 1.474752, 1.416203, 1.357654, 1.299105, 1.240556, 1.182008, 1.123459, 1.064910, 1.006361, 0.947812, 0.889264, 0.830715, 0.772166, 0.713617, 0.655068, 0.596520, 0.537971, 0.479422, 0.420873, 0.362324, 0.303776, 0.245227, 1.786678, 1.728129, 1.669580, 1.611032, 1.552483, 1.493934, 1.435385, 1.376836, 1.318288, 1.259739, 1.201190, 1.142641, 1.084092, 1.025544, 0.966995, 0.908446, 0.849897, 0.791348, 0.732800, 0.674251, 0.615702, 0.557153, 0.498604, 0.440056, 0.381507, 0.322958, 0.264409, 0.205860, 1.747312, 1.688763, 1.630214, 1.571665, 1.513116, 1.454568, 1.396019, 1.337470, 1.278921, 1.220372, 1.161824, 1.103275, 1.044726, 0.986177, 0.927628, 0.869080, 0.810531, 0.751982, 0.693433, 0.634884, 0.576336]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.581211 0.522662 0.464113 0.405564 0.347016 0.288467 0.229918 1.771369 1.712820 1.654272 1.595723 1.537174 1.478625 1.420076 1.361528 1.302979 1.244430 1.185881 1.127332 1.068784 1.010235 0.951686 0.893137 0.834588 0.776040 0.717491 0.658942 0.600393 0.541844 0.483296 0.424747 0.366198 0.307649 0.249100 1.790552 1.732003 1.673454 1.614905 #[0.857827, 0.799278, 0.740729, 0.682180, 0.623632, 0.565083, 0.506534, 0.447985, 0.389436, 0.330888, 0.272339, 0.213790, 1.755241, 1.696692, 1.638144, 1.579595, 1.521046, 1.462497, 1.403948, 1.345400, 1.286851, 1.228302, 1.169753, 1.111204, 1.052656, 0.994107, 0.935558, 0.877009, 0.818460, 0.759912, 0.701363, 0.642814, 0.584265, 0.525716, 0.467168, 0.408619, 0.350070, 0.291521, 0.232972, 1.774424, 1.715875, 1.657326, 1.598777, 1.540228, 1.481680, 1.423131, 1.364582, 1.306033, 1.247484, 1.188936, 1.130387, 1.071838, 1.013289, 0.954740, 0.896192, 0.837643, 0.779094, 0.720545, 0.661996, 0.603448, 0.544899, 0.486350, 0.427801, 0.369252, 0.310704, 0.252155, 1.793606, 1.735057, 1.676508, 1.617960, 1.559411, 1.500862, 1.442313, 1.383764, 1.325216, 1.266667, 1.208118, 1.149569, 1.091020, 1.032472, 0.973923, 0.915374, 0.856825, 0.798276, 0.739728, 0.681179, 0.622630, 0.564081, 0.505532, 0.446984, 0.388435, 0.329886, 0.271337, 0.212788, 1.754240, 1.695691, 1.637142, 1.578593, 1.520044, 1.461496, 1.402947, 1.344398, 1.285849, 1.227300, 1.168752, 1.110203, 1.051654, 0.993105, 0.934556, 0.876008, 0.817459, 0.758910, 0.700361, 0.641812, 0.583264, 0.524715, 0.466166, 0.407617, 0.349068, 0.290520, 0.231971, 1.773422, 1.714873, 1.656324, 1.597776, 1.539227, 1.480678, 1.422129, 1.363580, 1.305032, 1.246483, 1.187934, 1.129385, 1.070836, 1.012288, 0.953739, 0.895190, 0.836641, 0.778092, 0.719544, 0.660995, 0.602446, 0.543897, 0.485348, 0.426800, 0.368251, 0.309702, 0.251153, 1.792604, 1.734056, 1.675507, 1.616958, 1.558409, 1.499860, 1.441312, 1.382763, 1.324214, 1.265665, 1.207116, 1.148568, 1.090019, 1.031470, 0.972921, 0.914372, 0.855824, 0.797275, 0.738726, 0.680177, 0.621628, 0.563080, 0.504531, 0.445982, 0.387433, 0.328884, 0.270336, 0.211787, 1.753238, 1.694689, 1.636140, 1.577592, 1.519043, 1.460494, 1.401945, 1.343396, 1.284848, 1.226299, 1.167750, 1.109201, 1.050652, 0.992104, 0.933555, 0.875006, 0.816457, 0.757908, 0.699360, 0.640811, 0.582262, 0.523713, 0.465164, 0.406616, 0.348067, 0.289518, 0.230969, 1.772420, 1.713872, 1.655323, 1.596774, 1.538225, 1.479676, 1.421128, 1.362579, 1.304030, 1.245481, 1.186932, 1.128384, 1.069835, 1.011286, 0.952737, 0.894188, 0.835640, 0.777091, 0.718542, 0.659993, 0.601444, 0.542896, 0.484347, 0.425798, 0.367249, 0.308700, 0.250152, 1.791603, 1.733054, 1.674505, 1.615956, 1.557408, 1.498859, 1.440310, 1.381761, 1.323212, 1.264664, 1.206115, 1.147566, 1.089017, 1.030468, 0.971920, 0.913371, 0.854822, 0.796273, 0.737724, 0.679176, 0.620627, 0.562078, 0.503529, 0.444980, 0.386432, 0.327883, 0.269334, 0.210785, 1.752236, 1.693688, 1.635139, 1.576590, 1.518041, 1.459492, 1.400944, 1.342395, 1.283846, 1.225297, 1.166748, 1.108200, 1.049651, 0.991102, 0.932553, 0.874004, 0.815456, 0.756907, 0.698358, 0.639809, 0.581260, 0.522712, 0.464163, 0.405614, 0.347065, 0.288516, 0.229968, 1.771419, 1.712870, 1.654321, 1.595772, 1.537224, 1.478675, 1.420126, 1.361577, 1.303028, 1.244480, 1.185931, 1.127382, 1.068833, 1.010284, 0.951736, 0.893187, 0.834638, 0.776089, 0.717540, 0.658992, 0.600443, 0.541894, 0.483345, 0.424796, 0.366248, 0.307699, 0.249150, 1.790601, 1.732052, 1.673504, 1.614955, 1.556406, 1.497857, 1.439308, 1.380760, 1.322211, 1.263662, 1.205113, 1.146564, 1.088016, 1.029467, 0.970918, 0.912369, 0.853820, 0.795272, 0.736723, 0.678174, 0.619625, 0.561076, 0.502528, 0.443979, 0.385430, 0.326881, 0.268332, 0.209784, 1.751235, 1.692686, 1.634137, 1.575588, 1.517040, 1.458491, 1.399942, 1.341393, 1.282844, 1.224296, 1.165747, 1.107198, 1.048649, 0.990100, 0.931552, 0.873003, 0.814454, 0.755905, 0.697356, 0.638808, 0.580259, 0.521710, 0.463161, 0.404612, 0.346064, 0.287515, 0.228966, 1.770417, 1.711868, 1.653320, 1.594771, 1.536222, 1.477673, 1.419124, 1.360576, 1.302027, 1.243478, 1.184929, 1.126380, 1.067832, 1.009283, 0.950734, 0.892185, 0.833636, 0.775088, 0.716539, 0.657990, 0.599441, 0.540892, 0.482344, 0.423795, 0.365246, 0.306697, 0.248148, 1.789600, 1.731051, 1.672502, 1.613953, 1.555404, 1.496856, 1.438307, 1.379758, 1.321209, 1.262660, 1.204112, 1.145563, 1.087014, 1.028465, 0.969916, 0.911368, 0.852819, 0.794270, 0.735721, 0.677172, 0.618624, 0.560075, 0.501526, 0.442977, 0.384428, 0.325880, 0.267331, 0.208782, 1.750233, 1.691684, 1.633136, 1.574587, 1.516038, 1.457489, 1.398940, 1.340392, 1.281843, 1.223294, 1.164745, 1.106196, 1.047648, 0.989099, 0.930550, 0.872001, 0.813452, 0.754904, 0.696355, 0.637806, 0.579257, 0.520708, 0.462160, 0.403611, 0.345062, 0.286513, 0.227964, 1.769416, 1.710867, 1.652318, 1.593769, 1.535220, 1.476672, 1.418123, 1.359574, 1.301025, 1.242476, 1.183928, 1.125379, 1.066830, 1.008281, 0.949732, 0.891184, 0.832635, 0.774086, 0.715537, 0.656988, 0.598440, 0.539891, 0.481342, 0.422793, 0.364244, 0.305696, 0.247147, 1.788598, 1.730049, 1.671500, 1.612952, 1.554403, 1.495854, 1.437305, 1.378756, 1.320208, 1.261659, 1.203110, 1.144561, 1.086012, 1.027464, 0.968915, 0.910366, 0.851817, 0.793268, 0.734720, 0.676171, 0.617622, 0.559073, 0.500524, 0.441976, 0.383427, 0.324878, 0.266329, 0.207780, 1.749232, 1.690683, 1.632134, 1.573585, 1.515036, 1.456488, 1.397939, 1.339390, 1.280841, 1.222292, 1.163744, 1.105195, 1.046646, 0.988097, 0.929548, 0.871000, 0.812451, 0.753902, 0.695353, 0.636804, 0.578256, 0.519707, 0.461158, 0.402609, 0.344060, 0.285512, 0.226963, 1.768414, 1.709865, 1.651316, 1.592768, 1.534219, 1.475670, 1.417121, 1.358572, 1.300024, 1.241475, 1.182926, 1.124377, 1.065828, 1.007280, 0.948731, 0.890182, 0.831633, 0.773084, 0.714536, 0.655987, 0.597438, 0.538889, 0.480340, 0.421792, 0.363243, 0.304694, 0.246145, 1.787596, 1.729048, 1.670499, 1.611950, 1.553401, 1.494852, 1.436304, 1.377755, 1.319206, 1.260657, 1.202108, 1.143560, 1.085011, 1.026462, 0.967913, 0.909364, 0.850816, 0.792267, 0.733718, 0.675169, 0.616620, 0.558072, 0.499523, 0.440974, 0.382425, 0.323876, 0.265328, 0.206779, 1.748230, 1.689681, 1.631132, 1.572584, 1.514035, 1.455486, 1.396937, 1.338388, 1.279840, 1.221291, 1.162742, 1.104193, 1.045644, 0.987096, 0.928547, 0.869998, 0.811449, 0.752900, 0.694352, 0.635803, 0.577254, 0.518705, 0.460156, 0.401608, 0.343059, 0.284510, 0.225961, 1.767412, 1.708864, 1.650315, 1.591766, 1.533217, 1.474668, 1.416120, 1.357571, 1.299022, 1.240473, 1.181924, 1.123376, 1.064827, 1.006278, 0.947729, 0.889180, 0.830632, 0.772083, 0.713534, 0.654985, 0.596436, 0.537888, 0.479339, 0.420790, 0.362241, 0.303692, 0.245144]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.250019 1.791470 1.732921 1.674372 1.615824 1.557275 1.498726 1.440177 1.381628 1.323080 1.264531 1.205982 1.147433 1.088884 1.030336 0.971787 0.913238 0.854689 0.796140 0.737592 0.679043 0.620494 0.561945 0.503396 0.444848 0.386299 0.327750 0.269201 0.210652 1.752104 1.693555 1.635006 1.576457 1.517908 1.459360 1.400811 1.342262 1.283713 #[0.526635, 0.468086, 0.409537, 0.350988, 0.292440, 0.233891, 1.775342, 1.716793, 1.658244, 1.599696, 1.541147, 1.482598, 1.424049, 1.365500, 1.306952, 1.248403, 1.189854, 1.131305, 1.072756, 1.014208, 0.955659, 0.897110, 0.838561, 0.780012, 0.721464, 0.662915, 0.604366, 0.545817, 0.487268, 0.428720, 0.370171, 0.311622, 0.253073, 1.794524, 1.735976, 1.677427, 1.618878, 1.560329, 1.501780, 1.443232, 1.384683, 1.326134, 1.267585, 1.209036, 1.150488, 1.091939, 1.033390, 0.974841, 0.916292, 0.857744, 0.799195, 0.740646, 0.682097, 0.623548, 0.565000, 0.506451, 0.447902, 0.389353, 0.330804, 0.272256, 0.213707, 1.755158, 1.696609, 1.638060, 1.579512, 1.520963, 1.462414, 1.403865, 1.345316, 1.286768, 1.228219, 1.169670, 1.111121, 1.052572, 0.994024, 0.935475, 0.876926, 0.818377, 0.759828, 0.701280, 0.642731, 0.584182, 0.525633, 0.467084, 0.408536, 0.349987, 0.291438, 0.232889, 1.774340, 1.715792, 1.657243, 1.598694, 1.540145, 1.481596, 1.423048, 1.364499, 1.305950, 1.247401, 1.188852, 1.130304, 1.071755, 1.013206, 0.954657, 0.896108, 0.837560, 0.779011, 0.720462, 0.661913, 0.603364, 0.544816, 0.486267, 0.427718, 0.369169, 0.310620, 0.252072, 1.793523, 1.734974, 1.676425, 1.617876, 1.559328, 1.500779, 1.442230, 1.383681, 1.325132, 1.266584, 1.208035, 1.149486, 1.090937, 1.032388, 0.973840, 0.915291, 0.856742, 0.798193, 0.739644, 0.681096, 0.622547, 0.563998, 0.505449, 0.446900, 0.388352, 0.329803, 0.271254, 0.212705, 1.754156, 1.695608, 1.637059, 1.578510, 1.519961, 1.461412, 1.402864, 1.344315, 1.285766, 1.227217, 1.168668, 1.110120, 1.051571, 0.993022, 0.934473, 0.875924, 0.817376, 0.758827, 0.700278, 0.641729, 0.583180, 0.524632, 0.466083, 0.407534, 0.348985, 0.290436, 0.231888, 1.773339, 1.714790, 1.656241, 1.597692, 1.539144, 1.480595, 1.422046, 1.363497, 1.304948, 1.246400, 1.187851, 1.129302, 1.070753, 1.012204, 0.953656, 0.895107, 0.836558, 0.778009, 0.719460, 0.660912, 0.602363, 0.543814, 0.485265, 0.426716, 0.368168, 0.309619, 0.251070, 1.792521, 1.733972, 1.675424, 1.616875, 1.558326, 1.499777, 1.441228, 1.382680, 1.324131, 1.265582, 1.207033, 1.148484, 1.089936, 1.031387, 0.972838, 0.914289, 0.855740, 0.797192, 0.738643, 0.680094, 0.621545, 0.562996, 0.504448, 0.445899, 0.387350, 0.328801, 0.270252, 0.211704, 1.753155, 1.694606, 1.636057, 1.577508, 1.518960, 1.460411, 1.401862, 1.343313, 1.284764, 1.226216, 1.167667, 1.109118, 1.050569, 0.992020, 0.933472, 0.874923, 0.816374, 0.757825, 0.699276, 0.640728, 0.582179, 0.523630, 0.465081, 0.406532, 0.347984, 0.289435, 0.230886, 1.772337, 1.713788, 1.655240, 1.596691, 1.538142, 1.479593, 1.421044, 1.362496, 1.303947, 1.245398, 1.186849, 1.128300, 1.069752, 1.011203, 0.952654, 0.894105, 0.835556, 0.777008, 0.718459, 0.659910, 0.601361, 0.542812, 0.484264, 0.425715, 0.367166, 0.308617, 0.250068, 1.791520, 1.732971, 1.674422, 1.615873, 1.557324, 1.498776, 1.440227, 1.381678, 1.323129, 1.264580, 1.206032, 1.147483, 1.088934, 1.030385, 0.971836, 0.913288, 0.854739, 0.796190, 0.737641, 0.679092, 0.620544, 0.561995, 0.503446, 0.444897, 0.386348, 0.327800, 0.269251, 0.210702, 1.752153, 1.693604, 1.635056, 1.576507, 1.517958, 1.459409, 1.400860, 1.342312, 1.283763, 1.225214, 1.166665, 1.108116, 1.049568, 0.991019, 0.932470, 0.873921, 0.815372, 0.756824, 0.698275, 0.639726, 0.581177, 0.522628, 0.464080, 0.405531, 0.346982, 0.288433, 0.229884, 1.771336, 1.712787, 1.654238, 1.595689, 1.537140, 1.478592, 1.420043, 1.361494, 1.302945, 1.244396, 1.185848, 1.127299, 1.068750, 1.010201, 0.951652, 0.893104, 0.834555, 0.776006, 0.717457, 0.658908, 0.600360, 0.541811, 0.483262, 0.424713, 0.366164, 0.307616, 0.249067, 1.790518, 1.731969, 1.673420, 1.614872, 1.556323, 1.497774, 1.439225, 1.380676, 1.322128, 1.263579, 1.205030, 1.146481, 1.087932, 1.029384, 0.970835, 0.912286, 0.853737, 0.795188, 0.736640, 0.678091, 0.619542, 0.560993, 0.502444, 0.443896, 0.385347, 0.326798, 0.268249, 0.209700, 1.751152, 1.692603, 1.634054, 1.575505, 1.516956, 1.458408, 1.399859, 1.341310, 1.282761, 1.224212, 1.165664, 1.107115, 1.048566, 0.990017, 0.931468, 0.872920, 0.814371, 0.755822, 0.697273, 0.638724, 0.580176, 0.521627, 0.463078, 0.404529, 0.345980, 0.287432, 0.228883, 1.770334, 1.711785, 1.653236, 1.594688, 1.536139, 1.477590, 1.419041, 1.360492, 1.301944, 1.243395, 1.184846, 1.126297, 1.067748, 1.009200, 0.950651, 0.892102, 0.833553, 0.775004, 0.716456, 0.657907, 0.599358, 0.540809, 0.482260, 0.423712, 0.365163, 0.306614, 0.248065, 1.789516, 1.730968, 1.672419, 1.613870, 1.555321, 1.496772, 1.438224, 1.379675, 1.321126, 1.262577, 1.204028, 1.145480, 1.086931, 1.028382, 0.969833, 0.911284, 0.852736, 0.794187, 0.735638, 0.677089, 0.618540, 0.559992, 0.501443, 0.442894, 0.384345, 0.325796, 0.267248, 0.208699, 1.750150, 1.691601, 1.633052, 1.574504, 1.515955, 1.457406, 1.398857, 1.340308, 1.281760, 1.223211, 1.164662, 1.106113, 1.047564, 0.989016, 0.930467, 0.871918, 0.813369, 0.754820, 0.696272, 0.637723, 0.579174, 0.520625, 0.462076, 0.403528, 0.344979, 0.286430, 0.227881, 1.769332, 1.710784, 1.652235, 1.593686, 1.535137, 1.476588, 1.418040, 1.359491, 1.300942, 1.242393, 1.183844, 1.125296, 1.066747, 1.008198, 0.949649, 0.891100, 0.832552, 0.774003, 0.715454, 0.656905, 0.598356, 0.539808, 0.481259, 0.422710, 0.364161, 0.305612, 0.247064, 1.788515, 1.729966, 1.671417, 1.612868, 1.554320, 1.495771, 1.437222, 1.378673, 1.320124, 1.261576, 1.203027, 1.144478, 1.085929, 1.027380, 0.968832, 0.910283, 0.851734, 0.793185, 0.734636, 0.676088, 0.617539, 0.558990, 0.500441, 0.441892, 0.383344, 0.324795, 0.266246, 0.207697, 1.749148, 1.690600, 1.632051, 1.573502, 1.514953, 1.456404, 1.397856, 1.339307, 1.280758, 1.222209, 1.163660, 1.105112, 1.046563, 0.988014, 0.929465, 0.870916, 0.812368, 0.753819, 0.695270, 0.636721, 0.578172, 0.519624, 0.461075, 0.402526, 0.343977, 0.285428, 0.226880, 1.768331, 1.709782, 1.651233, 1.592684, 1.534136, 1.475587, 1.417038, 1.358489, 1.299940, 1.241392, 1.182843, 1.124294, 1.065745, 1.007196, 0.948648, 0.890099, 0.831550, 0.773001, 0.714452, 0.655904, 0.597355, 0.538806, 0.480257, 0.421708, 0.363160, 0.304611, 0.246062, 1.787513, 1.728964, 1.670416, 1.611867, 1.553318, 1.494769, 1.436220, 1.377672, 1.319123, 1.260574, 1.202025, 1.143476, 1.084928, 1.026379, 0.967830, 0.909281, 0.850732, 0.792184, 0.733635, 0.675086, 0.616537, 0.557988, 0.499440, 0.440891, 0.382342, 0.323793, 0.265244, 0.206696, 1.748147, 1.689598, 1.631049, 1.572500, 1.513952]).map Float.toBits))

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

#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.726251 0.667702 0.609153 0.550604 0.492056 0.433507 0.374958 0.316409 0.257860 1.799312 1.740763 1.682214 1.623665 1.565116 1.506568 1.448019 1.389470 1.330921 1.272372 1.213824 1.155275 1.096726 1.038177 0.979628 0.921080 0.862531 0.803982 0.745433 0.686884 0.628336 0.569787 0.511238 0.452689 0.394140 0.335592 0.277043 0.218494 1.759945 #[1.002867, 0.944318, 0.885769, 0.827220, 0.768672, 0.710123, 0.651574, 0.593025, 0.534476, 0.475928, 0.417379, 0.358830, 0.300281, 0.241732, 1.783184, 1.724635, 1.666086, 1.607537, 1.548988, 1.490440, 1.431891, 1.373342, 1.314793, 1.256244, 1.197696, 1.139147, 1.080598, 1.022049, 0.963500, 0.904952, 0.846403, 0.787854, 0.729305, 0.670756, 0.612208, 0.553659, 0.495110, 0.436561, 0.378012, 0.319464, 0.260915, 0.202366, 1.743817, 1.685268, 1.626720, 1.568171, 1.509622, 1.451073, 1.392524, 1.333976, 1.275427, 1.216878, 1.158329, 1.099780, 1.041232, 0.982683, 0.924134, 0.865585, 0.807036, 0.748488, 0.689939, 0.631390, 0.572841, 0.514292, 0.455744, 0.397195, 0.338646, 0.280097, 0.221548, 1.763000, 1.704451, 1.645902, 1.587353, 1.528804, 1.470256, 1.411707, 1.353158, 1.294609, 1.236060, 1.177512, 1.118963, 1.060414, 1.001865, 0.943316, 0.884768, 0.826219, 0.767670, 0.709121, 0.650572, 0.592024, 0.533475, 0.474926, 0.416377, 0.357828, 0.299280, 0.240731, 1.782182, 1.723633, 1.665084, 1.606536, 1.547987, 1.489438, 1.430889, 1.372340, 1.313792, 1.255243, 1.196694, 1.138145, 1.079596, 1.021048, 0.962499, 0.903950, 0.845401, 0.786852, 0.728304, 0.669755, 0.611206, 0.552657, 0.494108, 0.435560, 0.377011, 0.318462, 0.259913, 0.201364, 1.742816, 1.684267, 1.625718, 1.567169, 1.508620, 1.450072, 1.391523, 1.332974, 1.274425, 1.215876, 1.157328, 1.098779, 1.040230, 0.981681, 0.923132, 0.864584, 0.806035, 0.747486, 0.688937, 0.630388, 0.571840, 0.513291, 0.454742, 0.396193, 0.337644, 0.279096, 0.220547, 1.761998, 1.703449, 1.644900, 1.586352, 1.527803, 1.469254, 1.410705, 1.352156, 1.293608, 1.235059, 1.176510, 1.117961, 1.059412, 1.000864, 0.942315, 0.883766, 0.825217, 0.766668, 0.708120, 0.649571, 0.591022, 0.532473, 0.473924, 0.415376, 0.356827, 0.298278, 0.239729, 1.781180, 1.722632, 1.664083, 1.605534, 1.546985, 1.488436, 1.429888, 1.371339, 1.312790, 1.254241, 1.195692, 1.137144, 1.078595, 1.020046, 0.961497, 0.902948, 0.844400, 0.785851, 0.727302, 0.668753, 0.610204, 0.551656, 0.493107, 0.434558, 0.376009, 0.317460, 0.258912, 0.200363, 1.741814, 1.683265, 1.624716, 1.566168, 1.507619, 1.449070, 1.390521, 1.331972, 1.273424, 1.214875, 1.156326, 1.097777, 1.039228, 0.980680, 0.922131, 0.863582, 0.805033, 0.746484, 0.687936, 0.629387, 0.570838, 0.512289, 0.453740, 0.395192, 0.336643, 0.278094, 0.219545, 1.760996, 1.702448, 1.643899, 1.585350, 1.526801, 1.468252, 1.409704, 1.351155, 1.292606, 1.234057, 1.175508, 1.116960, 1.058411, 0.999862, 0.941313, 0.882764, 0.824216, 0.765667, 0.707118, 0.648569, 0.590020, 0.531472, 0.472923, 0.414374, 0.355825, 0.297276, 0.238728, 1.780179, 1.721630, 1.663081, 1.604532, 1.545984, 1.487435, 1.428886, 1.370337, 1.311788, 1.253240, 1.194691, 1.136142, 1.077593, 1.019044, 0.960496, 0.901947, 0.843398, 0.784849, 0.726300, 0.667752, 0.609203, 0.550654, 0.492105, 0.433556, 0.375008, 0.316459, 0.257910, 1.799361, 1.740812, 1.682264, 1.623715, 1.565166, 1.506617, 1.448068, 1.389520, 1.330971, 1.272422, 1.213873, 1.155324, 1.096776, 1.038227, 0.979678, 0.921129, 0.862580, 0.804032, 0.745483, 0.686934, 0.628385, 0.569836, 0.511288, 0.452739, 0.394190, 0.335641, 0.277092, 0.218544, 1.759995, 1.701446, 1.642897, 1.584348, 1.525800, 1.467251, 1.408702, 1.350153, 1.291604, 1.233056, 1.174507, 1.115958, 1.057409, 0.998860, 0.940312, 0.881763, 0.823214, 0.764665, 0.706116, 0.647568, 0.589019, 0.530470, 0.471921, 0.413372, 0.354824, 0.296275, 0.237726, 1.779177, 1.720628, 1.662080, 1.603531, 1.544982, 1.486433, 1.427884, 1.369336, 1.310787, 1.252238, 1.193689, 1.135140, 1.076592, 1.018043, 0.959494, 0.900945, 0.842396, 0.783848, 0.725299, 0.666750, 0.608201, 0.549652, 0.491104, 0.432555, 0.374006, 0.315457, 0.256908, 1.798360, 1.739811, 1.681262, 1.622713, 1.564164, 1.505616, 1.447067, 1.388518, 1.329969, 1.271420, 1.212872, 1.154323, 1.095774, 1.037225, 0.978676, 0.920128, 0.861579, 0.803030, 0.744481, 0.685932, 0.627384, 0.568835, 0.510286, 0.451737, 0.393188, 0.334640, 0.276091, 0.217542, 1.758993, 1.700444, 1.641896, 1.583347, 1.524798, 1.466249, 1.407700, 1.349152, 1.290603, 1.232054, 1.173505, 1.114956, 1.056408, 0.997859, 0.939310, 0.880761, 0.822212, 0.763664, 0.705115, 0.646566, 0.588017, 0.529468, 0.470920, 0.412371, 0.353822, 0.295273, 0.236724, 1.778176, 1.719627, 1.661078, 1.602529, 1.543980, 1.485432, 1.426883, 1.368334, 1.309785, 1.251236, 1.192688, 1.134139, 1.075590, 1.017041, 0.958492, 0.899944, 0.841395, 0.782846, 0.724297, 0.665748, 0.607200, 0.548651, 0.490102, 0.431553, 0.373004, 0.314456, 0.255907, 1.797358, 1.738809, 1.680260, 1.621712, 1.563163, 1.504614, 1.446065, 1.387516, 1.328968, 1.270419, 1.211870, 1.153321, 1.094772, 1.036224, 0.977675, 0.919126, 0.860577, 0.802028, 0.743480, 0.684931, 0.626382, 0.567833, 0.509284, 0.450736, 0.392187, 0.333638, 0.275089, 0.216540, 1.757992, 1.699443, 1.640894, 1.582345, 1.523796, 1.465248, 1.406699, 1.348150, 1.289601, 1.231052, 1.172504, 1.113955, 1.055406, 0.996857, 0.938308, 0.879760, 0.821211, 0.762662, 0.704113, 0.645564, 0.587016, 0.528467, 0.469918, 0.411369, 0.352820, 0.294272, 0.235723, 1.777174, 1.718625, 1.660076, 1.601528, 1.542979, 1.484430, 1.425881, 1.367332, 1.308784, 1.250235, 1.191686, 1.133137, 1.074588, 1.016040, 0.957491, 0.898942, 0.840393, 0.781844, 0.723296, 0.664747, 0.606198, 0.547649, 0.489100, 0.430552, 0.372003, 0.313454, 0.254905, 1.796356, 1.737808, 1.679259, 1.620710, 1.562161, 1.503612, 1.445064, 1.386515, 1.327966, 1.269417, 1.210868, 1.152320, 1.093771, 1.035222, 0.976673, 0.918124, 0.859576, 0.801027, 0.742478, 0.683929, 0.625380, 0.566832, 0.508283, 0.449734, 0.391185, 0.332636, 0.274088, 0.215539, 1.756990, 1.698441, 1.639892, 1.581344, 1.522795, 1.464246, 1.405697, 1.347148, 1.288600, 1.230051, 1.171502, 1.112953, 1.054404, 0.995856, 0.937307, 0.878758, 0.820209, 0.761660, 0.703112, 0.644563, 0.586014, 0.527465, 0.468916, 0.410368, 0.351819, 0.293270, 0.234721, 1.776172, 1.717624, 1.659075, 1.600526, 1.541977, 1.483428, 1.424880, 1.366331, 1.307782, 1.249233, 1.190684, 1.132136, 1.073587, 1.015038, 0.956489, 0.897940, 0.839392, 0.780843, 0.722294, 0.663745, 0.605196, 0.546648, 0.488099, 0.429550, 0.371001, 0.312452, 0.253904, 1.795355, 1.736806, 1.678257, 1.619708, 1.561160, 1.502611, 1.444062, 1.385513, 1.326964, 1.268416, 1.209867, 1.151318, 1.092769, 1.034220, 0.975672, 0.917123, 0.858574, 0.800025, 0.741476, 0.682928, 0.624379, 0.565830, 0.507281, 0.448732, 0.390184]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.395059 0.336510 0.277961 0.219412 1.760864 1.702315 1.643766 1.585217 1.526668 1.468120 1.409571 1.351022 1.292473 1.233924 1.175376 1.116827 1.058278 0.999729 0.941180 0.882632 0.824083 0.765534 0.706985 0.648436 0.589888 0.531339 0.472790 0.414241 0.355692 0.297144 0.238595 1.780046 1.721497 1.662948 1.604400 1.545851 1.487302 1.428753 #[0.671675, 0.613126, 0.554577, 0.496028, 0.437480, 0.378931, 0.320382, 0.261833, 0.203284, 1.744736, 1.686187, 1.627638, 1.569089, 1.510540, 1.451992, 1.393443, 1.334894, 1.276345, 1.217796, 1.159248, 1.100699, 1.042150, 0.983601, 0.925052, 0.866504, 0.807955, 0.749406, 0.690857, 0.632308, 0.573760, 0.515211, 0.456662, 0.398113, 0.339564, 0.281016, 0.222467, 1.763918, 1.705369, 1.646820, 1.588272, 1.529723, 1.471174, 1.412625, 1.354076, 1.295528, 1.236979, 1.178430, 1.119881, 1.061332, 1.002784, 0.944235, 0.885686, 0.827137, 0.768588, 0.710040, 0.651491, 0.592942, 0.534393, 0.475844, 0.417296, 0.358747, 0.300198, 0.241649, 1.783100, 1.724552, 1.666003, 1.607454, 1.548905, 1.490356, 1.431808, 1.373259, 1.314710, 1.256161, 1.197612, 1.139064, 1.080515, 1.021966, 0.963417, 0.904868, 0.846320, 0.787771, 0.729222, 0.670673, 0.612124, 0.553576, 0.495027, 0.436478, 0.377929, 0.319380, 0.260832, 0.202283, 1.743734, 1.685185, 1.626636, 1.568088, 1.509539, 1.450990, 1.392441, 1.333892, 1.275344, 1.216795, 1.158246, 1.099697, 1.041148, 0.982600, 0.924051, 0.865502, 0.806953, 0.748404, 0.689856, 0.631307, 0.572758, 0.514209, 0.455660, 0.397112, 0.338563, 0.280014, 0.221465, 1.762916, 1.704368, 1.645819, 1.587270, 1.528721, 1.470172, 1.411624, 1.353075, 1.294526, 1.235977, 1.177428, 1.118880, 1.060331, 1.001782, 0.943233, 0.884684, 0.826136, 0.767587, 0.709038, 0.650489, 0.591940, 0.533392, 0.474843, 0.416294, 0.357745, 0.299196, 0.240648, 1.782099, 1.723550, 1.665001, 1.606452, 1.547904, 1.489355, 1.430806, 1.372257, 1.313708, 1.255160, 1.196611, 1.138062, 1.079513, 1.020964, 0.962416, 0.903867, 0.845318, 0.786769, 0.728220, 0.669672, 0.611123, 0.552574, 0.494025, 0.435476, 0.376928, 0.318379, 0.259830, 0.201281, 1.742732, 1.684184, 1.625635, 1.567086, 1.508537, 1.449988, 1.391440, 1.332891, 1.274342, 1.215793, 1.157244, 1.098696, 1.040147, 0.981598, 0.923049, 0.864500, 0.805952, 0.747403, 0.688854, 0.630305, 0.571756, 0.513208, 0.454659, 0.396110, 0.337561, 0.279012, 0.220464, 1.761915, 1.703366, 1.644817, 1.586268, 1.527720, 1.469171, 1.410622, 1.352073, 1.293524, 1.234976, 1.176427, 1.117878, 1.059329, 1.000780, 0.942232, 0.883683, 0.825134, 0.766585, 0.708036, 0.649488, 0.590939, 0.532390, 0.473841, 0.415292, 0.356744, 0.298195, 0.239646, 1.781097, 1.722548, 1.664000, 1.605451, 1.546902, 1.488353, 1.429804, 1.371256, 1.312707, 1.254158, 1.195609, 1.137060, 1.078512, 1.019963, 0.961414, 0.902865, 0.844316, 0.785768, 0.727219, 0.668670, 0.610121, 0.551572, 0.493024, 0.434475, 0.375926, 0.317377, 0.258828, 0.200280, 1.741731, 1.683182, 1.624633, 1.566084, 1.507536, 1.448987, 1.390438, 1.331889, 1.273340, 1.214792, 1.156243, 1.097694, 1.039145, 0.980596, 0.922048, 0.863499, 0.804950, 0.746401, 0.687852, 0.629304, 0.570755, 0.512206, 0.453657, 0.395108, 0.336560, 0.278011, 0.219462, 1.760913, 1.702364, 1.643816, 1.585267, 1.526718, 1.468169, 1.409620, 1.351072, 1.292523, 1.233974, 1.175425, 1.116876, 1.058328, 0.999779, 0.941230, 0.882681, 0.824132, 0.765584, 0.707035, 0.648486, 0.589937, 0.531388, 0.472840, 0.414291, 0.355742, 0.297193, 0.238644, 1.780096, 1.721547, 1.662998, 1.604449, 1.545900, 1.487352, 1.428803, 1.370254, 1.311705, 1.253156, 1.194608, 1.136059, 1.077510, 1.018961, 0.960412, 0.901864, 0.843315, 0.784766, 0.726217, 0.667668, 0.609120, 0.550571, 0.492022, 0.433473, 0.374924, 0.316376, 0.257827, 1.799278, 1.740729, 1.682180, 1.623632, 1.565083, 1.506534, 1.447985, 1.389436, 1.330888, 1.272339, 1.213790, 1.155241, 1.096692, 1.038144, 0.979595, 0.921046, 0.862497, 0.803948, 0.745400, 0.686851, 0.628302, 0.569753, 0.511204, 0.452656, 0.394107, 0.335558, 0.277009, 0.218460, 1.759912, 1.701363, 1.642814, 1.584265, 1.525716, 1.467168, 1.408619, 1.350070, 1.291521, 1.232972, 1.174424, 1.115875, 1.057326, 0.998777, 0.940228, 0.881680, 0.823131, 0.764582, 0.706033, 0.647484, 0.588936, 0.530387, 0.471838, 0.413289, 0.354740, 0.296192, 0.237643, 1.779094, 1.720545, 1.661996, 1.603448, 1.544899, 1.486350, 1.427801, 1.369252, 1.310704, 1.252155, 1.193606, 1.135057, 1.076508, 1.017960, 0.959411, 0.900862, 0.842313, 0.783764, 0.725216, 0.666667, 0.608118, 0.549569, 0.491020, 0.432472, 0.373923, 0.315374, 0.256825, 1.798276, 1.739728, 1.681179, 1.622630, 1.564081, 1.505532, 1.446984, 1.388435, 1.329886, 1.271337, 1.212788, 1.154240, 1.095691, 1.037142, 0.978593, 0.920044, 0.861496, 0.802947, 0.744398, 0.685849, 0.627300, 0.568752, 0.510203, 0.451654, 0.393105, 0.334556, 0.276008, 0.217459, 1.758910, 1.700361, 1.641812, 1.583264, 1.524715, 1.466166, 1.407617, 1.349068, 1.290520, 1.231971, 1.173422, 1.114873, 1.056324, 0.997776, 0.939227, 0.880678, 0.822129, 0.763580, 0.705032, 0.646483, 0.587934, 0.529385, 0.470836, 0.412288, 0.353739, 0.295190, 0.236641, 1.778092, 1.719544, 1.660995, 1.602446, 1.543897, 1.485348, 1.426800, 1.368251, 1.309702, 1.251153, 1.192604, 1.134056, 1.075507, 1.016958, 0.958409, 0.899860, 0.841312, 0.782763, 0.724214, 0.665665, 0.607116, 0.548568, 0.490019, 0.431470, 0.372921, 0.314372, 0.255824, 1.797275, 1.738726, 1.680177, 1.621628, 1.563080, 1.504531, 1.445982, 1.387433, 1.328884, 1.270336, 1.211787, 1.153238, 1.094689, 1.036140, 0.977592, 0.919043, 0.860494, 0.801945, 0.743396, 0.684848, 0.626299, 0.567750, 0.509201, 0.450652, 0.392104, 0.333555, 0.275006, 0.216457, 1.757908, 1.699360, 1.640811, 1.582262, 1.523713, 1.465164, 1.406616, 1.348067, 1.289518, 1.230969, 1.172420, 1.113872, 1.055323, 0.996774, 0.938225, 0.879676, 0.821128, 0.762579, 0.704030, 0.645481, 0.586932, 0.528384, 0.469835, 0.411286, 0.352737, 0.294188, 0.235640, 1.777091, 1.718542, 1.659993, 1.601444, 1.542896, 1.484347, 1.425798, 1.367249, 1.308700, 1.250152, 1.191603, 1.133054, 1.074505, 1.015956, 0.957408, 0.898859, 0.840310, 0.781761, 0.723212, 0.664664, 0.606115, 0.547566, 0.489017, 0.430468, 0.371920, 0.313371, 0.254822, 1.796273, 1.737724, 1.679176, 1.620627, 1.562078, 1.503529, 1.444980, 1.386432, 1.327883, 1.269334, 1.210785, 1.152236, 1.093688, 1.035139, 0.976590, 0.918041, 0.859492, 0.800944, 0.742395, 0.683846, 0.625297, 0.566748, 0.508200, 0.449651, 0.391102, 0.332553, 0.274004, 0.215456, 1.756907, 1.698358, 1.639809, 1.581260, 1.522712, 1.464163, 1.405614, 1.347065, 1.288516, 1.229968, 1.171419, 1.112870, 1.054321, 0.995772, 0.937224, 0.878675, 0.820126, 0.761577, 0.703028, 0.644480, 0.585931, 0.527382, 0.468833, 0.410284, 0.351736, 0.293187, 0.234638, 1.776089, 1.717540, 1.658992]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.663867 1.605318 1.546769 1.488220 1.429672 1.371123 1.312574 1.254025 1.195476 1.136928 1.078379 1.019830 0.961281 0.902732 0.844184 0.785635 0.727086 0.668537 0.609988 0.551440 0.492891 0.434342 0.375793 0.317244 0.258696 0.200147 1.741598 1.683049 1.624500 1.565952 1.507403 1.448854 1.390305 1.331756 1.273208 1.214659 1.156110 1.097561 #[0.340483, 0.281934, 0.223385, 1.764836, 1.706288, 1.647739, 1.589190, 1.530641, 1.472092, 1.413544, 1.354995, 1.296446, 1.237897, 1.179348, 1.120800, 1.062251, 1.003702, 0.945153, 0.886604, 0.828056, 0.769507, 0.710958, 0.652409, 0.593860, 0.535312, 0.476763, 0.418214, 0.359665, 0.301116, 0.242568, 1.784019, 1.725470, 1.666921, 1.608372, 1.549824, 1.491275, 1.432726, 1.374177, 1.315628, 1.257080, 1.198531, 1.139982, 1.081433, 1.022884, 0.964336, 0.905787, 0.847238, 0.788689, 0.730140, 0.671592, 0.613043, 0.554494, 0.495945, 0.437396, 0.378848, 0.320299, 0.261750, 0.203201, 1.744652, 1.686104, 1.627555, 1.569006, 1.510457, 1.451908, 1.393360, 1.334811, 1.276262, 1.217713, 1.159164, 1.100616, 1.042067, 0.983518, 0.924969, 0.866420, 0.807872, 0.749323, 0.690774, 0.632225, 0.573676, 0.515128, 0.456579, 0.398030, 0.339481, 0.280932, 0.222384, 1.763835, 1.705286, 1.646737, 1.588188, 1.529640, 1.471091, 1.412542, 1.353993, 1.295444, 1.236896, 1.178347, 1.119798, 1.061249, 1.002700, 0.944152, 0.885603, 0.827054, 0.768505, 0.709956, 0.651408, 0.592859, 0.534310, 0.475761, 0.417212, 0.358664, 0.300115, 0.241566, 1.783017, 1.724468, 1.665920, 1.607371, 1.548822, 1.490273, 1.431724, 1.373176, 1.314627, 1.256078, 1.197529, 1.138980, 1.080432, 1.021883, 0.963334, 0.904785, 0.846236, 0.787688, 0.729139, 0.670590, 0.612041, 0.553492, 0.494944, 0.436395, 0.377846, 0.319297, 0.260748, 0.202200, 1.743651, 1.685102, 1.626553, 1.568004, 1.509456, 1.450907, 1.392358, 1.333809, 1.275260, 1.216712, 1.158163, 1.099614, 1.041065, 0.982516, 0.923968, 0.865419, 0.806870, 0.748321, 0.689772, 0.631224, 0.572675, 0.514126, 0.455577, 0.397028, 0.338480, 0.279931, 0.221382, 1.762833, 1.704284, 1.645736, 1.587187, 1.528638, 1.470089, 1.411540, 1.352992, 1.294443, 1.235894, 1.177345, 1.118796, 1.060248, 1.001699, 0.943150, 0.884601, 0.826052, 0.767504, 0.708955, 0.650406, 0.591857, 0.533308, 0.474760, 0.416211, 0.357662, 0.299113, 0.240564, 1.782016, 1.723467, 1.664918, 1.606369, 1.547820, 1.489272, 1.430723, 1.372174, 1.313625, 1.255076, 1.196528, 1.137979, 1.079430, 1.020881, 0.962332, 0.903784, 0.845235, 0.786686, 0.728137, 0.669588, 0.611040, 0.552491, 0.493942, 0.435393, 0.376844, 0.318296, 0.259747, 0.201198, 1.742649, 1.684100, 1.625552, 1.567003, 1.508454, 1.449905, 1.391356, 1.332808, 1.274259, 1.215710, 1.157161, 1.098612, 1.040064, 0.981515, 0.922966, 0.864417, 0.805868, 0.747320, 0.688771, 0.630222, 0.571673, 0.513124, 0.454576, 0.396027, 0.337478, 0.278929, 0.220380, 1.761832, 1.703283, 1.644734, 1.586185, 1.527636, 1.469088, 1.410539, 1.351990, 1.293441, 1.234892, 1.176344, 1.117795, 1.059246, 1.000697, 0.942148, 0.883600, 0.825051, 0.766502, 0.707953, 0.649404, 0.590856, 0.532307, 0.473758, 0.415209, 0.356660, 0.298112, 0.239563, 1.781014, 1.722465, 1.663916, 1.605368, 1.546819, 1.488270, 1.429721, 1.371172, 1.312624, 1.254075, 1.195526, 1.136977, 1.078428, 1.019880, 0.961331, 0.902782, 0.844233, 0.785684, 0.727136, 0.668587, 0.610038, 0.551489, 0.492940, 0.434392, 0.375843, 0.317294, 0.258745, 0.200196, 1.741648, 1.683099, 1.624550, 1.566001, 1.507452, 1.448904, 1.390355, 1.331806, 1.273257, 1.214708, 1.156160, 1.097611, 1.039062, 0.980513, 0.921964, 0.863416, 0.804867, 0.746318, 0.687769, 0.629220, 0.570672, 0.512123, 0.453574, 0.395025, 0.336476, 0.277928, 0.219379, 1.760830, 1.702281, 1.643732, 1.585184, 1.526635, 1.468086, 1.409537, 1.350988, 1.292440, 1.233891, 1.175342, 1.116793, 1.058244, 0.999696, 0.941147, 0.882598, 0.824049, 0.765500, 0.706952, 0.648403, 0.589854, 0.531305, 0.472756, 0.414208, 0.355659, 0.297110, 0.238561, 1.780012, 1.721464, 1.662915, 1.604366, 1.545817, 1.487268, 1.428720, 1.370171, 1.311622, 1.253073, 1.194524, 1.135976, 1.077427, 1.018878, 0.960329, 0.901780, 0.843232, 0.784683, 0.726134, 0.667585, 0.609036, 0.550488, 0.491939, 0.433390, 0.374841, 0.316292, 0.257744, 1.799195, 1.740646, 1.682097, 1.623548, 1.565000, 1.506451, 1.447902, 1.389353, 1.330804, 1.272256, 1.213707, 1.155158, 1.096609, 1.038060, 0.979512, 0.920963, 0.862414, 0.803865, 0.745316, 0.686768, 0.628219, 0.569670, 0.511121, 0.452572, 0.394024, 0.335475, 0.276926, 0.218377, 1.759828, 1.701280, 1.642731, 1.584182, 1.525633, 1.467084, 1.408536, 1.349987, 1.291438, 1.232889, 1.174340, 1.115792, 1.057243, 0.998694, 0.940145, 0.881596, 0.823048, 0.764499, 0.705950, 0.647401, 0.588852, 0.530304, 0.471755, 0.413206, 0.354657, 0.296108, 0.237560, 1.779011, 1.720462, 1.661913, 1.603364, 1.544816, 1.486267, 1.427718, 1.369169, 1.310620, 1.252072, 1.193523, 1.134974, 1.076425, 1.017876, 0.959328, 0.900779, 0.842230, 0.783681, 0.725132, 0.666584, 0.608035, 0.549486, 0.490937, 0.432388, 0.373840, 0.315291, 0.256742, 1.798193, 1.739644, 1.681096, 1.622547, 1.563998, 1.505449, 1.446900, 1.388352, 1.329803, 1.271254, 1.212705, 1.154156, 1.095608, 1.037059, 0.978510, 0.919961, 0.861412, 0.802864, 0.744315, 0.685766, 0.627217, 0.568668, 0.510120, 0.451571, 0.393022, 0.334473, 0.275924, 0.217376, 1.758827, 1.700278, 1.641729, 1.583180, 1.524632, 1.466083, 1.407534, 1.348985, 1.290436, 1.231888, 1.173339, 1.114790, 1.056241, 0.997692, 0.939144, 0.880595, 0.822046, 0.763497, 0.704948, 0.646400, 0.587851, 0.529302, 0.470753, 0.412204, 0.353656, 0.295107, 0.236558, 1.778009, 1.719460, 1.660912, 1.602363, 1.543814, 1.485265, 1.426716, 1.368168, 1.309619, 1.251070, 1.192521, 1.133972, 1.075424, 1.016875, 0.958326, 0.899777, 0.841228, 0.782680, 0.724131, 0.665582, 0.607033, 0.548484, 0.489936, 0.431387, 0.372838, 0.314289, 0.255740, 1.797192, 1.738643, 1.680094, 1.621545, 1.562996, 1.504448, 1.445899, 1.387350, 1.328801, 1.270252, 1.211704, 1.153155, 1.094606, 1.036057, 0.977508, 0.918960, 0.860411, 0.801862, 0.743313, 0.684764, 0.626216, 0.567667, 0.509118, 0.450569, 0.392020, 0.333472, 0.274923, 0.216374, 1.757825, 1.699276, 1.640728, 1.582179, 1.523630, 1.465081, 1.406532, 1.347984, 1.289435, 1.230886, 1.172337, 1.113788, 1.055240, 0.996691, 0.938142, 0.879593, 0.821044, 0.762496, 0.703947, 0.645398, 0.586849, 0.528300, 0.469752, 0.411203, 0.352654, 0.294105, 0.235556, 1.777008, 1.718459, 1.659910, 1.601361, 1.542812, 1.484264, 1.425715, 1.367166, 1.308617, 1.250068, 1.191520, 1.132971, 1.074422, 1.015873, 0.957324, 0.898776, 0.840227, 0.781678, 0.723129, 0.664580, 0.606032, 0.547483, 0.488934, 0.430385, 0.371836, 0.313288, 0.254739, 1.796190, 1.737641, 1.679092, 1.620544, 1.561995, 1.503446, 1.444897, 1.386348, 1.327800]))

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

#eval IO.println ("check_hashemiEnv_oil_le " ++ toString (check_hashemiEnv_oil_le 0.540099 0.481550 0.423001 0.364452 0.305904 0.247355 1.788806 1.730257 1.671708 1.613160 1.554611 1.496062 1.437513 1.378964 1.320416 1.261867 1.203318 1.144769 1.086220 1.027672 0.969123 0.910574 0.852025 0.793476 0.734928 0.676379 0.617830 0.559281 0.500732 0.442184 0.383635 0.325086 0.266537 0.207988 1.749440 1.690891 1.632342 1.573793 #[0.816715, 0.758166, 0.699617, 0.641068, 0.582520, 0.523971, 0.465422, 0.406873, 0.348324, 0.289776, 0.231227, 1.772678, 1.714129, 1.655580, 1.597032, 1.538483, 1.479934, 1.421385, 1.362836, 1.304288, 1.245739, 1.187190, 1.128641, 1.070092, 1.011544, 0.952995, 0.894446, 0.835897, 0.777348, 0.718800, 0.660251, 0.601702, 0.543153, 0.484604, 0.426056, 0.367507, 0.308958, 0.250409, 1.791860, 1.733312, 1.674763, 1.616214, 1.557665, 1.499116, 1.440568, 1.382019, 1.323470, 1.264921, 1.206372, 1.147824, 1.089275, 1.030726, 0.972177, 0.913628, 0.855080, 0.796531, 0.737982, 0.679433, 0.620884, 0.562336, 0.503787, 0.445238, 0.386689, 0.328140, 0.269592, 0.211043, 1.752494, 1.693945, 1.635396, 1.576848, 1.518299, 1.459750, 1.401201, 1.342652, 1.284104, 1.225555, 1.167006, 1.108457, 1.049908, 0.991360, 0.932811, 0.874262, 0.815713, 0.757164, 0.698616, 0.640067, 0.581518, 0.522969, 0.464420, 0.405872, 0.347323, 0.288774, 0.230225, 1.771676, 1.713128, 1.654579, 1.596030, 1.537481, 1.478932, 1.420384, 1.361835, 1.303286, 1.244737, 1.186188, 1.127640, 1.069091, 1.010542, 0.951993, 0.893444, 0.834896, 0.776347, 0.717798, 0.659249, 0.600700, 0.542152, 0.483603, 0.425054, 0.366505, 0.307956, 0.249408, 1.790859, 1.732310, 1.673761, 1.615212, 1.556664, 1.498115, 1.439566, 1.381017, 1.322468, 1.263920, 1.205371, 1.146822, 1.088273, 1.029724, 0.971176, 0.912627, 0.854078, 0.795529, 0.736980, 0.678432, 0.619883, 0.561334, 0.502785, 0.444236, 0.385688, 0.327139, 0.268590, 0.210041, 1.751492, 1.692944, 1.634395, 1.575846, 1.517297, 1.458748, 1.400200, 1.341651, 1.283102, 1.224553, 1.166004, 1.107456, 1.048907, 0.990358, 0.931809, 0.873260, 0.814712, 0.756163, 0.697614, 0.639065, 0.580516, 0.521968, 0.463419, 0.404870, 0.346321, 0.287772, 0.229224, 1.770675, 1.712126, 1.653577, 1.595028, 1.536480, 1.477931, 1.419382, 1.360833, 1.302284, 1.243736, 1.185187, 1.126638, 1.068089, 1.009540, 0.950992, 0.892443, 0.833894, 0.775345, 0.716796, 0.658248, 0.599699, 0.541150, 0.482601, 0.424052, 0.365504, 0.306955, 0.248406, 1.789857, 1.731308, 1.672760, 1.614211, 1.555662, 1.497113, 1.438564, 1.380016, 1.321467, 1.262918, 1.204369, 1.145820, 1.087272, 1.028723, 0.970174, 0.911625, 0.853076, 0.794528, 0.735979, 0.677430, 0.618881, 0.560332, 0.501784, 0.443235, 0.384686, 0.326137, 0.267588, 0.209040, 1.750491, 1.691942, 1.633393, 1.574844, 1.516296, 1.457747, 1.399198, 1.340649, 1.282100, 1.223552, 1.165003, 1.106454, 1.047905, 0.989356, 0.930808, 0.872259, 0.813710, 0.755161, 0.696612, 0.638064, 0.579515, 0.520966, 0.462417, 0.403868, 0.345320, 0.286771, 0.228222, 1.769673, 1.711124, 1.652576, 1.594027, 1.535478, 1.476929, 1.418380, 1.359832, 1.301283, 1.242734, 1.184185, 1.125636, 1.067088, 1.008539, 0.949990, 0.891441, 0.832892, 0.774344, 0.715795, 0.657246, 0.598697, 0.540148, 0.481600, 0.423051, 0.364502, 0.305953, 0.247404, 1.788856, 1.730307, 1.671758, 1.613209, 1.554660, 1.496112, 1.437563, 1.379014, 1.320465, 1.261916, 1.203368, 1.144819, 1.086270, 1.027721, 0.969172, 0.910624, 0.852075, 0.793526, 0.734977, 0.676428, 0.617880, 0.559331, 0.500782, 0.442233, 0.383684, 0.325136, 0.266587, 0.208038, 1.749489, 1.690940, 1.632392, 1.573843, 1.515294, 1.456745, 1.398196, 1.339648, 1.281099, 1.222550, 1.164001, 1.105452, 1.046904, 0.988355, 0.929806, 0.871257, 0.812708, 0.754160, 0.695611, 0.637062, 0.578513, 0.519964, 0.461416, 0.402867, 0.344318, 0.285769, 0.227220, 1.768672, 1.710123, 1.651574, 1.593025, 1.534476, 1.475928, 1.417379, 1.358830, 1.300281, 1.241732, 1.183184, 1.124635, 1.066086, 1.007537, 0.948988, 0.890440, 0.831891, 0.773342, 0.714793, 0.656244, 0.597696, 0.539147, 0.480598, 0.422049, 0.363500, 0.304952, 0.246403, 1.787854, 1.729305, 1.670756, 1.612208, 1.553659, 1.495110, 1.436561, 1.378012, 1.319464, 1.260915, 1.202366, 1.143817, 1.085268, 1.026720, 0.968171, 0.909622, 0.851073, 0.792524, 0.733976, 0.675427, 0.616878, 0.558329, 0.499780, 0.441232, 0.382683, 0.324134, 0.265585, 0.207036, 1.748488, 1.689939, 1.631390, 1.572841, 1.514292, 1.455744, 1.397195, 1.338646, 1.280097, 1.221548, 1.163000, 1.104451, 1.045902, 0.987353, 0.928804, 0.870256, 0.811707, 0.753158, 0.694609, 0.636060, 0.577512, 0.518963, 0.460414, 0.401865, 0.343316, 0.284768, 0.226219, 1.767670, 1.709121, 1.650572, 1.592024, 1.533475, 1.474926, 1.416377, 1.357828, 1.299280, 1.240731, 1.182182, 1.123633, 1.065084, 1.006536, 0.947987, 0.889438, 0.830889, 0.772340, 0.713792, 0.655243, 0.596694, 0.538145, 0.479596, 0.421048, 0.362499, 0.303950, 0.245401, 1.786852, 1.728304, 1.669755, 1.611206, 1.552657, 1.494108, 1.435560, 1.377011, 1.318462, 1.259913, 1.201364, 1.142816, 1.084267, 1.025718, 0.967169, 0.908620, 0.850072, 0.791523, 0.732974, 0.674425, 0.615876, 0.557328, 0.498779, 0.440230, 0.381681, 0.323132, 0.264584, 0.206035, 1.747486, 1.688937, 1.630388, 1.571840, 1.513291, 1.454742, 1.396193, 1.337644, 1.279096, 1.220547, 1.161998, 1.103449, 1.044900, 0.986352, 0.927803, 0.869254, 0.810705, 0.752156, 0.693608, 0.635059, 0.576510, 0.517961, 0.459412, 0.400864, 0.342315, 0.283766, 0.225217, 1.766668, 1.708120, 1.649571, 1.591022, 1.532473, 1.473924, 1.415376, 1.356827, 1.298278, 1.239729, 1.181180, 1.122632, 1.064083, 1.005534, 0.946985, 0.888436, 0.829888, 0.771339, 0.712790, 0.654241, 0.595692, 0.537144, 0.478595, 0.420046, 0.361497, 0.302948, 0.244400, 1.785851, 1.727302, 1.668753, 1.610204, 1.551656, 1.493107, 1.434558, 1.376009, 1.317460, 1.258912, 1.200363, 1.141814, 1.083265, 1.024716, 0.966168, 0.907619, 0.849070, 0.790521, 0.731972, 0.673424, 0.614875, 0.556326, 0.497777, 0.439228, 0.380680, 0.322131, 0.263582, 0.205033, 1.746484, 1.687936, 1.629387, 1.570838, 1.512289, 1.453740, 1.395192, 1.336643, 1.278094, 1.219545, 1.160996, 1.102448, 1.043899, 0.985350, 0.926801, 0.868252, 0.809704, 0.751155, 0.692606, 0.634057, 0.575508, 0.516960, 0.458411, 0.399862, 0.341313, 0.282764, 0.224216, 1.765667, 1.707118, 1.648569, 1.590020, 1.531472, 1.472923, 1.414374, 1.355825, 1.297276, 1.238728, 1.180179, 1.121630, 1.063081, 1.004532, 0.945984, 0.887435, 0.828886, 0.770337, 0.711788, 0.653240, 0.594691, 0.536142, 0.477593, 0.419044, 0.360496, 0.301947, 0.243398, 1.784849, 1.726300, 1.667752, 1.609203, 1.550654, 1.492105, 1.433556, 1.375008, 1.316459, 1.257910, 1.199361, 1.140812, 1.082264, 1.023715, 0.965166, 0.906617, 0.848068, 0.789520, 0.730971, 0.672422, 0.613873, 0.555324, 0.496776, 0.438227, 0.379678, 0.321129, 0.262580, 0.204032]))
#eval IO.println ("check_hashemiEnv_oil_le " ++ toString (check_hashemiEnv_oil_le 0.208907 1.750358 1.691809 1.633260 1.574712 1.516163 1.457614 1.399065 1.340516 1.281968 1.223419 1.164870 1.106321 1.047772 0.989224 0.930675 0.872126 0.813577 0.755028 0.696480 0.637931 0.579382 0.520833 0.462284 0.403736 0.345187 0.286638 0.228089 1.769540 1.710992 1.652443 1.593894 1.535345 1.476796 1.418248 1.359699 1.301150 1.242601 #[0.485523, 0.426974, 0.368425, 0.309876, 0.251328, 1.792779, 1.734230, 1.675681, 1.617132, 1.558584, 1.500035, 1.441486, 1.382937, 1.324388, 1.265840, 1.207291, 1.148742, 1.090193, 1.031644, 0.973096, 0.914547, 0.855998, 0.797449, 0.738900, 0.680352, 0.621803, 0.563254, 0.504705, 0.446156, 0.387608, 0.329059, 0.270510, 0.211961, 1.753412, 1.694864, 1.636315, 1.577766, 1.519217, 1.460668, 1.402120, 1.343571, 1.285022, 1.226473, 1.167924, 1.109376, 1.050827, 0.992278, 0.933729, 0.875180, 0.816632, 0.758083, 0.699534, 0.640985, 0.582436, 0.523888, 0.465339, 0.406790, 0.348241, 0.289692, 0.231144, 1.772595, 1.714046, 1.655497, 1.596948, 1.538400, 1.479851, 1.421302, 1.362753, 1.304204, 1.245656, 1.187107, 1.128558, 1.070009, 1.011460, 0.952912, 0.894363, 0.835814, 0.777265, 0.718716, 0.660168, 0.601619, 0.543070, 0.484521, 0.425972, 0.367424, 0.308875, 0.250326, 1.791777, 1.733228, 1.674680, 1.616131, 1.557582, 1.499033, 1.440484, 1.381936, 1.323387, 1.264838, 1.206289, 1.147740, 1.089192, 1.030643, 0.972094, 0.913545, 0.854996, 0.796448, 0.737899, 0.679350, 0.620801, 0.562252, 0.503704, 0.445155, 0.386606, 0.328057, 0.269508, 0.210960, 1.752411, 1.693862, 1.635313, 1.576764, 1.518216, 1.459667, 1.401118, 1.342569, 1.284020, 1.225472, 1.166923, 1.108374, 1.049825, 0.991276, 0.932728, 0.874179, 0.815630, 0.757081, 0.698532, 0.639984, 0.581435, 0.522886, 0.464337, 0.405788, 0.347240, 0.288691, 0.230142, 1.771593, 1.713044, 1.654496, 1.595947, 1.537398, 1.478849, 1.420300, 1.361752, 1.303203, 1.244654, 1.186105, 1.127556, 1.069008, 1.010459, 0.951910, 0.893361, 0.834812, 0.776264, 0.717715, 0.659166, 0.600617, 0.542068, 0.483520, 0.424971, 0.366422, 0.307873, 0.249324, 1.790776, 1.732227, 1.673678, 1.615129, 1.556580, 1.498032, 1.439483, 1.380934, 1.322385, 1.263836, 1.205288, 1.146739, 1.088190, 1.029641, 0.971092, 0.912544, 0.853995, 0.795446, 0.736897, 0.678348, 0.619800, 0.561251, 0.502702, 0.444153, 0.385604, 0.327056, 0.268507, 0.209958, 1.751409, 1.692860, 1.634312, 1.575763, 1.517214, 1.458665, 1.400116, 1.341568, 1.283019, 1.224470, 1.165921, 1.107372, 1.048824, 0.990275, 0.931726, 0.873177, 0.814628, 0.756080, 0.697531, 0.638982, 0.580433, 0.521884, 0.463336, 0.404787, 0.346238, 0.287689, 0.229140, 1.770592, 1.712043, 1.653494, 1.594945, 1.536396, 1.477848, 1.419299, 1.360750, 1.302201, 1.243652, 1.185104, 1.126555, 1.068006, 1.009457, 0.950908, 0.892360, 0.833811, 0.775262, 0.716713, 0.658164, 0.599616, 0.541067, 0.482518, 0.423969, 0.365420, 0.306872, 0.248323, 1.789774, 1.731225, 1.672676, 1.614128, 1.555579, 1.497030, 1.438481, 1.379932, 1.321384, 1.262835, 1.204286, 1.145737, 1.087188, 1.028640, 0.970091, 0.911542, 0.852993, 0.794444, 0.735896, 0.677347, 0.618798, 0.560249, 0.501700, 0.443152, 0.384603, 0.326054, 0.267505, 0.208956, 1.750408, 1.691859, 1.633310, 1.574761, 1.516212, 1.457664, 1.399115, 1.340566, 1.282017, 1.223468, 1.164920, 1.106371, 1.047822, 0.989273, 0.930724, 0.872176, 0.813627, 0.755078, 0.696529, 0.637980, 0.579432, 0.520883, 0.462334, 0.403785, 0.345236, 0.286688, 0.228139, 1.769590, 1.711041, 1.652492, 1.593944, 1.535395, 1.476846, 1.418297, 1.359748, 1.301200, 1.242651, 1.184102, 1.125553, 1.067004, 1.008456, 0.949907, 0.891358, 0.832809, 0.774260, 0.715712, 0.657163, 0.598614, 0.540065, 0.481516, 0.422968, 0.364419, 0.305870, 0.247321, 1.788772, 1.730224, 1.671675, 1.613126, 1.554577, 1.496028, 1.437480, 1.378931, 1.320382, 1.261833, 1.203284, 1.144736, 1.086187, 1.027638, 0.969089, 0.910540, 0.851992, 0.793443, 0.734894, 0.676345, 0.617796, 0.559248, 0.500699, 0.442150, 0.383601, 0.325052, 0.266504, 0.207955, 1.749406, 1.690857, 1.632308, 1.573760, 1.515211, 1.456662, 1.398113, 1.339564, 1.281016, 1.222467, 1.163918, 1.105369, 1.046820, 0.988272, 0.929723, 0.871174, 0.812625, 0.754076, 0.695528, 0.636979, 0.578430, 0.519881, 0.461332, 0.402784, 0.344235, 0.285686, 0.227137, 1.768588, 1.710040, 1.651491, 1.592942, 1.534393, 1.475844, 1.417296, 1.358747, 1.300198, 1.241649, 1.183100, 1.124552, 1.066003, 1.007454, 0.948905, 0.890356, 0.831808, 0.773259, 0.714710, 0.656161, 0.597612, 0.539064, 0.480515, 0.421966, 0.363417, 0.304868, 0.246320, 1.787771, 1.729222, 1.670673, 1.612124, 1.553576, 1.495027, 1.436478, 1.377929, 1.319380, 1.260832, 1.202283, 1.143734, 1.085185, 1.026636, 0.968088, 0.909539, 0.850990, 0.792441, 0.733892, 0.675344, 0.616795, 0.558246, 0.499697, 0.441148, 0.382600, 0.324051, 0.265502, 0.206953, 1.748404, 1.689856, 1.631307, 1.572758, 1.514209, 1.455660, 1.397112, 1.338563, 1.280014, 1.221465, 1.162916, 1.104368, 1.045819, 0.987270, 0.928721, 0.870172, 0.811624, 0.753075, 0.694526, 0.635977, 0.577428, 0.518880, 0.460331, 0.401782, 0.343233, 0.284684, 0.226136, 1.767587, 1.709038, 1.650489, 1.591940, 1.533392, 1.474843, 1.416294, 1.357745, 1.299196, 1.240648, 1.182099, 1.123550, 1.065001, 1.006452, 0.947904, 0.889355, 0.830806, 0.772257, 0.713708, 0.655160, 0.596611, 0.538062, 0.479513, 0.420964, 0.362416, 0.303867, 0.245318, 1.786769, 1.728220, 1.669672, 1.611123, 1.552574, 1.494025, 1.435476, 1.376928, 1.318379, 1.259830, 1.201281, 1.142732, 1.084184, 1.025635, 0.967086, 0.908537, 0.849988, 0.791440, 0.732891, 0.674342, 0.615793, 0.557244, 0.498696, 0.440147, 0.381598, 0.323049, 0.264500, 0.205952, 1.747403, 1.688854, 1.630305, 1.571756, 1.513208, 1.454659, 1.396110, 1.337561, 1.279012, 1.220464, 1.161915, 1.103366, 1.044817, 0.986268, 0.927720, 0.869171, 0.810622, 0.752073, 0.693524, 0.634976, 0.576427, 0.517878, 0.459329, 0.400780, 0.342232, 0.283683, 0.225134, 1.766585, 1.708036, 1.649488, 1.590939, 1.532390, 1.473841, 1.415292, 1.356744, 1.298195, 1.239646, 1.181097, 1.122548, 1.064000, 1.005451, 0.946902, 0.888353, 0.829804, 0.771256, 0.712707, 0.654158, 0.595609, 0.537060, 0.478512, 0.419963, 0.361414, 0.302865, 0.244316, 1.785768, 1.727219, 1.668670, 1.610121, 1.551572, 1.493024, 1.434475, 1.375926, 1.317377, 1.258828, 1.200280, 1.141731, 1.083182, 1.024633, 0.966084, 0.907536, 0.848987, 0.790438, 0.731889, 0.673340, 0.614792, 0.556243, 0.497694, 0.439145, 0.380596, 0.322048, 0.263499, 0.204950, 1.746401, 1.687852, 1.629304, 1.570755, 1.512206, 1.453657, 1.395108, 1.336560, 1.278011, 1.219462, 1.160913, 1.102364, 1.043816, 0.985267, 0.926718, 0.868169, 0.809620, 0.751072, 0.692523, 0.633974, 0.575425, 0.516876, 0.458328, 0.399779, 0.341230, 0.282681, 0.224132, 1.765584, 1.707035, 1.648486, 1.589937, 1.531388, 1.472840]))
#eval IO.println ("check_hashemiEnv_oil_le " ++ toString (check_hashemiEnv_oil_le 1.477715 1.419166 1.360617 1.302068 1.243520 1.184971 1.126422 1.067873 1.009324 0.950776 0.892227 0.833678 0.775129 0.716580 0.658032 0.599483 0.540934 0.482385 0.423836 0.365288 0.306739 0.248190 1.789641 1.731092 1.672544 1.613995 1.555446 1.496897 1.438348 1.379800 1.321251 1.262702 1.204153 1.145604 1.087056 1.028507 0.969958 0.911409 #[1.754331, 1.695782, 1.637233, 1.578684, 1.520136, 1.461587, 1.403038, 1.344489, 1.285940, 1.227392, 1.168843, 1.110294, 1.051745, 0.993196, 0.934648, 0.876099, 0.817550, 0.759001, 0.700452, 0.641904, 0.583355, 0.524806, 0.466257, 0.407708, 0.349160, 0.290611, 0.232062, 1.773513, 1.714964, 1.656416, 1.597867, 1.539318, 1.480769, 1.422220, 1.363672, 1.305123, 1.246574, 1.188025, 1.129476, 1.070928, 1.012379, 0.953830, 0.895281, 0.836732, 0.778184, 0.719635, 0.661086, 0.602537, 0.543988, 0.485440, 0.426891, 0.368342, 0.309793, 0.251244, 1.792696, 1.734147, 1.675598, 1.617049, 1.558500, 1.499952, 1.441403, 1.382854, 1.324305, 1.265756, 1.207208, 1.148659, 1.090110, 1.031561, 0.973012, 0.914464, 0.855915, 0.797366, 0.738817, 0.680268, 0.621720, 0.563171, 0.504622, 0.446073, 0.387524, 0.328976, 0.270427, 0.211878, 1.753329, 1.694780, 1.636232, 1.577683, 1.519134, 1.460585, 1.402036, 1.343488, 1.284939, 1.226390, 1.167841, 1.109292, 1.050744, 0.992195, 0.933646, 0.875097, 0.816548, 0.758000, 0.699451, 0.640902, 0.582353, 0.523804, 0.465256, 0.406707, 0.348158, 0.289609, 0.231060, 1.772512, 1.713963, 1.655414, 1.596865, 1.538316, 1.479768, 1.421219, 1.362670, 1.304121, 1.245572, 1.187024, 1.128475, 1.069926, 1.011377, 0.952828, 0.894280, 0.835731, 0.777182, 0.718633, 0.660084, 0.601536, 0.542987, 0.484438, 0.425889, 0.367340, 0.308792, 0.250243, 1.791694, 1.733145, 1.674596, 1.616048, 1.557499, 1.498950, 1.440401, 1.381852, 1.323304, 1.264755, 1.206206, 1.147657, 1.089108, 1.030560, 0.972011, 0.913462, 0.854913, 0.796364, 0.737816, 0.679267, 0.620718, 0.562169, 0.503620, 0.445072, 0.386523, 0.327974, 0.269425, 0.210876, 1.752328, 1.693779, 1.635230, 1.576681, 1.518132, 1.459584, 1.401035, 1.342486, 1.283937, 1.225388, 1.166840, 1.108291, 1.049742, 0.991193, 0.932644, 0.874096, 0.815547, 0.756998, 0.698449, 0.639900, 0.581352, 0.522803, 0.464254, 0.405705, 0.347156, 0.288608, 0.230059, 1.771510, 1.712961, 1.654412, 1.595864, 1.537315, 1.478766, 1.420217, 1.361668, 1.303120, 1.244571, 1.186022, 1.127473, 1.068924, 1.010376, 0.951827, 0.893278, 0.834729, 0.776180, 0.717632, 0.659083, 0.600534, 0.541985, 0.483436, 0.424888, 0.366339, 0.307790, 0.249241, 1.790692, 1.732144, 1.673595, 1.615046, 1.556497, 1.497948, 1.439400, 1.380851, 1.322302, 1.263753, 1.205204, 1.146656, 1.088107, 1.029558, 0.971009, 0.912460, 0.853912, 0.795363, 0.736814, 0.678265, 0.619716, 0.561168, 0.502619, 0.444070, 0.385521, 0.326972, 0.268424, 0.209875, 1.751326, 1.692777, 1.634228, 1.575680, 1.517131, 1.458582, 1.400033, 1.341484, 1.282936, 1.224387, 1.165838, 1.107289, 1.048740, 0.990192, 0.931643, 0.873094, 0.814545, 0.755996, 0.697448, 0.638899, 0.580350, 0.521801, 0.463252, 0.404704, 0.346155, 0.287606, 0.229057, 1.770508, 1.711960, 1.653411, 1.594862, 1.536313, 1.477764, 1.419216, 1.360667, 1.302118, 1.243569, 1.185020, 1.126472, 1.067923, 1.009374, 0.950825, 0.892276, 0.833728, 0.775179, 0.716630, 0.658081, 0.599532, 0.540984, 0.482435, 0.423886, 0.365337, 0.306788, 0.248240, 1.789691, 1.731142, 1.672593, 1.614044, 1.555496, 1.496947, 1.438398, 1.379849, 1.321300, 1.262752, 1.204203, 1.145654, 1.087105, 1.028556, 0.970008, 0.911459, 0.852910, 0.794361, 0.735812, 0.677264, 0.618715, 0.560166, 0.501617, 0.443068, 0.384520, 0.325971, 0.267422, 0.208873, 1.750324, 1.691776, 1.633227, 1.574678, 1.516129, 1.457580, 1.399032, 1.340483, 1.281934, 1.223385, 1.164836, 1.106288, 1.047739, 0.989190, 0.930641, 0.872092, 0.813544, 0.754995, 0.696446, 0.637897, 0.579348, 0.520800, 0.462251, 0.403702, 0.345153, 0.286604, 0.228056, 1.769507, 1.710958, 1.652409, 1.593860, 1.535312, 1.476763, 1.418214, 1.359665, 1.301116, 1.242568, 1.184019, 1.125470, 1.066921, 1.008372, 0.949824, 0.891275, 0.832726, 0.774177, 0.715628, 0.657080, 0.598531, 0.539982, 0.481433, 0.422884, 0.364336, 0.305787, 0.247238, 1.788689, 1.730140, 1.671592, 1.613043, 1.554494, 1.495945, 1.437396, 1.378848, 1.320299, 1.261750, 1.203201, 1.144652, 1.086104, 1.027555, 0.969006, 0.910457, 0.851908, 0.793360, 0.734811, 0.676262, 0.617713, 0.559164, 0.500616, 0.442067, 0.383518, 0.324969, 0.266420, 0.207872, 1.749323, 1.690774, 1.632225, 1.573676, 1.515128, 1.456579, 1.398030, 1.339481, 1.280932, 1.222384, 1.163835, 1.105286, 1.046737, 0.988188, 0.929640, 0.871091, 0.812542, 0.753993, 0.695444, 0.636896, 0.578347, 0.519798, 0.461249, 0.402700, 0.344152, 0.285603, 0.227054, 1.768505, 1.709956, 1.651408, 1.592859, 1.534310, 1.475761, 1.417212, 1.358664, 1.300115, 1.241566, 1.183017, 1.124468, 1.065920, 1.007371, 0.948822, 0.890273, 0.831724, 0.773176, 0.714627, 0.656078, 0.597529, 0.538980, 0.480432, 0.421883, 0.363334, 0.304785, 0.246236, 1.787688, 1.729139, 1.670590, 1.612041, 1.553492, 1.494944, 1.436395, 1.377846, 1.319297, 1.260748, 1.202200, 1.143651, 1.085102, 1.026553, 0.968004, 0.909456, 0.850907, 0.792358, 0.733809, 0.675260, 0.616712, 0.558163, 0.499614, 0.441065, 0.382516, 0.323968, 0.265419, 0.206870, 1.748321, 1.689772, 1.631224, 1.572675, 1.514126, 1.455577, 1.397028, 1.338480, 1.279931, 1.221382, 1.162833, 1.104284, 1.045736, 0.987187, 0.928638, 0.870089, 0.811540, 0.752992, 0.694443, 0.635894, 0.577345, 0.518796, 0.460248, 0.401699, 0.343150, 0.284601, 0.226052, 1.767504, 1.708955, 1.650406, 1.591857, 1.533308, 1.474760, 1.416211, 1.357662, 1.299113, 1.240564, 1.182016, 1.123467, 1.064918, 1.006369, 0.947820, 0.889272, 0.830723, 0.772174, 0.713625, 0.655076, 0.596528, 0.537979, 0.479430, 0.420881, 0.362332, 0.303784, 0.245235, 1.786686, 1.728137, 1.669588, 1.611040, 1.552491, 1.493942, 1.435393, 1.376844, 1.318296, 1.259747, 1.201198, 1.142649, 1.084100, 1.025552, 0.967003, 0.908454, 0.849905, 0.791356, 0.732808, 0.674259, 0.615710, 0.557161, 0.498612, 0.440064, 0.381515, 0.322966, 0.264417, 0.205868, 1.747320, 1.688771, 1.630222, 1.571673, 1.513124, 1.454576, 1.396027, 1.337478, 1.278929, 1.220380, 1.161832, 1.103283, 1.044734, 0.986185, 0.927636, 0.869088, 0.810539, 0.751990, 0.693441, 0.634892, 0.576344, 0.517795, 0.459246, 0.400697, 0.342148, 0.283600, 0.225051, 1.766502, 1.707953, 1.649404, 1.590856, 1.532307, 1.473758, 1.415209, 1.356660, 1.298112, 1.239563, 1.181014, 1.122465, 1.063916, 1.005368, 0.946819, 0.888270, 0.829721, 0.771172, 0.712624, 0.654075, 0.595526, 0.536977, 0.478428, 0.419880, 0.361331, 0.302782, 0.244233, 1.785684, 1.727136, 1.668587, 1.610038, 1.551489, 1.492940, 1.434392, 1.375843, 1.317294, 1.258745, 1.200196, 1.141648]))

def check_hashemiEnv_pot_le (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dr : Array Float) : Bool :=
  let v1623 := (Toil - Twall)
  let v1625 := (max (0 : Float) (UAx * v1623))
  (!((0 : Float) <= UAx) || (v1625 <= (UAx * (max (0 : Float) v1623))))

#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 0.353947 0.295398 0.236849 1.778300 1.719752 1.661203 1.602654 1.544105 1.485556 1.427008 1.368459 1.309910 1.251361 1.192812 1.134264 1.075715 1.017166 0.958617 0.900068 0.841520 0.782971 0.724422 0.665873 0.607324 0.548776 0.490227 0.431678 0.373129 0.314580 0.256032 1.797483 1.738934 1.680385 1.621836 1.563288 1.504739 1.446190 1.387641 #[0.630563, 0.572014, 0.513465, 0.454916, 0.396368, 0.337819, 0.279270, 0.220721, 1.762172, 1.703624, 1.645075, 1.586526, 1.527977, 1.469428, 1.410880, 1.352331, 1.293782, 1.235233, 1.176684, 1.118136, 1.059587, 1.001038, 0.942489, 0.883940, 0.825392, 0.766843, 0.708294, 0.649745, 0.591196, 0.532648, 0.474099, 0.415550, 0.357001, 0.298452, 0.239904, 1.781355, 1.722806, 1.664257, 1.605708, 1.547160, 1.488611, 1.430062, 1.371513, 1.312964, 1.254416, 1.195867, 1.137318, 1.078769, 1.020220, 0.961672, 0.903123, 0.844574, 0.786025, 0.727476, 0.668928, 0.610379, 0.551830, 0.493281, 0.434732, 0.376184, 0.317635, 0.259086, 0.200537, 1.741988, 1.683440, 1.624891, 1.566342, 1.507793, 1.449244, 1.390696, 1.332147, 1.273598, 1.215049, 1.156500, 1.097952, 1.039403, 0.980854, 0.922305, 0.863756, 0.805208, 0.746659, 0.688110, 0.629561, 0.571012, 0.512464, 0.453915, 0.395366, 0.336817, 0.278268, 0.219720, 1.761171, 1.702622, 1.644073, 1.585524, 1.526976, 1.468427, 1.409878, 1.351329, 1.292780, 1.234232, 1.175683, 1.117134, 1.058585, 1.000036, 0.941488, 0.882939, 0.824390, 0.765841, 0.707292, 0.648744, 0.590195, 0.531646, 0.473097, 0.414548, 0.356000, 0.297451, 0.238902, 1.780353, 1.721804, 1.663256, 1.604707, 1.546158, 1.487609, 1.429060, 1.370512, 1.311963, 1.253414, 1.194865, 1.136316, 1.077768, 1.019219, 0.960670, 0.902121, 0.843572, 0.785024, 0.726475, 0.667926, 0.609377, 0.550828, 0.492280, 0.433731, 0.375182, 0.316633, 0.258084, 1.799536, 1.740987, 1.682438, 1.623889, 1.565340, 1.506792, 1.448243, 1.389694, 1.331145, 1.272596, 1.214048, 1.155499, 1.096950, 1.038401, 0.979852, 0.921304, 0.862755, 0.804206, 0.745657, 0.687108, 0.628560, 0.570011, 0.511462, 0.452913, 0.394364, 0.335816, 0.277267, 0.218718, 1.760169, 1.701620, 1.643072, 1.584523, 1.525974, 1.467425, 1.408876, 1.350328, 1.291779, 1.233230, 1.174681, 1.116132, 1.057584, 0.999035, 0.940486, 0.881937, 0.823388, 0.764840, 0.706291, 0.647742, 0.589193, 0.530644, 0.472096, 0.413547, 0.354998, 0.296449, 0.237900, 1.779352, 1.720803, 1.662254, 1.603705, 1.545156, 1.486608, 1.428059, 1.369510, 1.310961, 1.252412, 1.193864, 1.135315, 1.076766, 1.018217, 0.959668, 0.901120, 0.842571, 0.784022, 0.725473, 0.666924, 0.608376, 0.549827, 0.491278, 0.432729, 0.374180, 0.315632, 0.257083, 1.798534, 1.739985, 1.681436, 1.622888, 1.564339, 1.505790, 1.447241, 1.388692, 1.330144, 1.271595, 1.213046, 1.154497, 1.095948, 1.037400, 0.978851, 0.920302, 0.861753, 0.803204, 0.744656, 0.686107, 0.627558, 0.569009, 0.510460, 0.451912, 0.393363, 0.334814, 0.276265, 0.217716, 1.759168, 1.700619, 1.642070, 1.583521, 1.524972, 1.466424, 1.407875, 1.349326, 1.290777, 1.232228, 1.173680, 1.115131, 1.056582, 0.998033, 0.939484, 0.880936, 0.822387, 0.763838, 0.705289, 0.646740, 0.588192, 0.529643, 0.471094, 0.412545, 0.353996, 0.295448, 0.236899, 1.778350, 1.719801, 1.661252, 1.602704, 1.544155, 1.485606, 1.427057, 1.368508, 1.309960, 1.251411, 1.192862, 1.134313, 1.075764, 1.017216, 0.958667, 0.900118, 0.841569, 0.783020, 0.724472, 0.665923, 0.607374, 0.548825, 0.490276, 0.431728, 0.373179, 0.314630, 0.256081, 1.797532, 1.738984, 1.680435, 1.621886, 1.563337, 1.504788, 1.446240, 1.387691, 1.329142, 1.270593, 1.212044, 1.153496, 1.094947, 1.036398, 0.977849, 0.919300, 0.860752, 0.802203, 0.743654, 0.685105, 0.626556, 0.568008, 0.509459, 0.450910, 0.392361, 0.333812, 0.275264, 0.216715, 1.758166, 1.699617, 1.641068, 1.582520, 1.523971, 1.465422, 1.406873, 1.348324, 1.289776, 1.231227, 1.172678, 1.114129, 1.055580, 0.997032, 0.938483, 0.879934, 0.821385, 0.762836, 0.704288, 0.645739, 0.587190, 0.528641, 0.470092, 0.411544, 0.352995, 0.294446, 0.235897, 1.777348, 1.718800, 1.660251, 1.601702, 1.543153, 1.484604, 1.426056, 1.367507, 1.308958, 1.250409, 1.191860, 1.133312, 1.074763, 1.016214, 0.957665, 0.899116, 0.840568, 0.782019, 0.723470, 0.664921, 0.606372, 0.547824, 0.489275, 0.430726, 0.372177, 0.313628, 0.255080, 1.796531, 1.737982, 1.679433, 1.620884, 1.562336, 1.503787, 1.445238, 1.386689, 1.328140, 1.269592, 1.211043, 1.152494, 1.093945, 1.035396, 0.976848, 0.918299, 0.859750, 0.801201, 0.742652, 0.684104, 0.625555, 0.567006, 0.508457, 0.449908, 0.391360, 0.332811, 0.274262, 0.215713, 1.757164, 1.698616, 1.640067, 1.581518, 1.522969, 1.464420, 1.405872, 1.347323, 1.288774, 1.230225, 1.171676, 1.113128, 1.054579, 0.996030, 0.937481, 0.878932, 0.820384, 0.761835, 0.703286, 0.644737, 0.586188, 0.527640, 0.469091, 0.410542, 0.351993, 0.293444, 0.234896, 1.776347, 1.717798, 1.659249, 1.600700, 1.542152, 1.483603, 1.425054, 1.366505, 1.307956, 1.249408, 1.190859, 1.132310, 1.073761, 1.015212, 0.956664, 0.898115, 0.839566, 0.781017, 0.722468, 0.663920, 0.605371, 0.546822, 0.488273, 0.429724, 0.371176, 0.312627, 0.254078, 1.795529, 1.736980, 1.678432, 1.619883, 1.561334, 1.502785, 1.444236, 1.385688, 1.327139, 1.268590, 1.210041, 1.151492, 1.092944, 1.034395, 0.975846, 0.917297, 0.858748, 0.800200, 0.741651, 0.683102, 0.624553, 0.566004, 0.507456, 0.448907, 0.390358, 0.331809, 0.273260, 0.214712, 1.756163, 1.697614, 1.639065, 1.580516, 1.521968, 1.463419, 1.404870, 1.346321, 1.287772, 1.229224, 1.170675, 1.112126, 1.053577, 0.995028, 0.936480, 0.877931, 0.819382, 0.760833, 0.702284, 0.643736, 0.585187, 0.526638, 0.468089, 0.409540, 0.350992, 0.292443, 0.233894, 1.775345, 1.716796, 1.658248, 1.599699, 1.541150, 1.482601, 1.424052, 1.365504, 1.306955, 1.248406, 1.189857, 1.131308, 1.072760, 1.014211, 0.955662, 0.897113, 0.838564, 0.780016, 0.721467, 0.662918, 0.604369, 0.545820, 0.487272, 0.428723, 0.370174, 0.311625, 0.253076, 1.794528, 1.735979, 1.677430, 1.618881, 1.560332, 1.501784, 1.443235, 1.384686, 1.326137, 1.267588, 1.209040, 1.150491, 1.091942, 1.033393, 0.974844, 0.916296, 0.857747, 0.799198, 0.740649, 0.682100, 0.623552, 0.565003, 0.506454, 0.447905, 0.389356, 0.330808, 0.272259, 0.213710, 1.755161, 1.696612, 1.638064, 1.579515, 1.520966, 1.462417, 1.403868, 1.345320, 1.286771, 1.228222, 1.169673, 1.111124, 1.052576, 0.994027, 0.935478, 0.876929, 0.818380, 0.759832, 0.701283, 0.642734, 0.584185, 0.525636, 0.467088, 0.408539, 0.349990, 0.291441, 0.232892, 1.774344, 1.715795, 1.657246, 1.598697, 1.540148, 1.481600, 1.423051, 1.364502, 1.305953, 1.247404, 1.188856, 1.130307, 1.071758, 1.013209, 0.954660, 0.896112, 0.837563, 0.779014, 0.720465, 0.661916, 0.603368, 0.544819, 0.486270, 0.427721, 0.369172, 0.310624, 0.252075, 1.793526, 1.734977, 1.676428, 1.617880]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 1.622755 1.564206 1.505657 1.447108 1.388560 1.330011 1.271462 1.212913 1.154364 1.095816 1.037267 0.978718 0.920169 0.861620 0.803072 0.744523 0.685974 0.627425 0.568876 0.510328 0.451779 0.393230 0.334681 0.276132 0.217584 1.759035 1.700486 1.641937 1.583388 1.524840 1.466291 1.407742 1.349193 1.290644 1.232096 1.173547 1.114998 1.056449 #[0.299371, 0.240822, 1.782273, 1.723724, 1.665176, 1.606627, 1.548078, 1.489529, 1.430980, 1.372432, 1.313883, 1.255334, 1.196785, 1.138236, 1.079688, 1.021139, 0.962590, 0.904041, 0.845492, 0.786944, 0.728395, 0.669846, 0.611297, 0.552748, 0.494200, 0.435651, 0.377102, 0.318553, 0.260004, 0.201456, 1.742907, 1.684358, 1.625809, 1.567260, 1.508712, 1.450163, 1.391614, 1.333065, 1.274516, 1.215968, 1.157419, 1.098870, 1.040321, 0.981772, 0.923224, 0.864675, 0.806126, 0.747577, 0.689028, 0.630480, 0.571931, 0.513382, 0.454833, 0.396284, 0.337736, 0.279187, 0.220638, 1.762089, 1.703540, 1.644992, 1.586443, 1.527894, 1.469345, 1.410796, 1.352248, 1.293699, 1.235150, 1.176601, 1.118052, 1.059504, 1.000955, 0.942406, 0.883857, 0.825308, 0.766760, 0.708211, 0.649662, 0.591113, 0.532564, 0.474016, 0.415467, 0.356918, 0.298369, 0.239820, 1.781272, 1.722723, 1.664174, 1.605625, 1.547076, 1.488528, 1.429979, 1.371430, 1.312881, 1.254332, 1.195784, 1.137235, 1.078686, 1.020137, 0.961588, 0.903040, 0.844491, 0.785942, 0.727393, 0.668844, 0.610296, 0.551747, 0.493198, 0.434649, 0.376100, 0.317552, 0.259003, 0.200454, 1.741905, 1.683356, 1.624808, 1.566259, 1.507710, 1.449161, 1.390612, 1.332064, 1.273515, 1.214966, 1.156417, 1.097868, 1.039320, 0.980771, 0.922222, 0.863673, 0.805124, 0.746576, 0.688027, 0.629478, 0.570929, 0.512380, 0.453832, 0.395283, 0.336734, 0.278185, 0.219636, 1.761088, 1.702539, 1.643990, 1.585441, 1.526892, 1.468344, 1.409795, 1.351246, 1.292697, 1.234148, 1.175600, 1.117051, 1.058502, 0.999953, 0.941404, 0.882856, 0.824307, 0.765758, 0.707209, 0.648660, 0.590112, 0.531563, 0.473014, 0.414465, 0.355916, 0.297368, 0.238819, 1.780270, 1.721721, 1.663172, 1.604624, 1.546075, 1.487526, 1.428977, 1.370428, 1.311880, 1.253331, 1.194782, 1.136233, 1.077684, 1.019136, 0.960587, 0.902038, 0.843489, 0.784940, 0.726392, 0.667843, 0.609294, 0.550745, 0.492196, 0.433648, 0.375099, 0.316550, 0.258001, 1.799452, 1.740904, 1.682355, 1.623806, 1.565257, 1.506708, 1.448160, 1.389611, 1.331062, 1.272513, 1.213964, 1.155416, 1.096867, 1.038318, 0.979769, 0.921220, 0.862672, 0.804123, 0.745574, 0.687025, 0.628476, 0.569928, 0.511379, 0.452830, 0.394281, 0.335732, 0.277184, 0.218635, 1.760086, 1.701537, 1.642988, 1.584440, 1.525891, 1.467342, 1.408793, 1.350244, 1.291696, 1.233147, 1.174598, 1.116049, 1.057500, 0.998952, 0.940403, 0.881854, 0.823305, 0.764756, 0.706208, 0.647659, 0.589110, 0.530561, 0.472012, 0.413464, 0.354915, 0.296366, 0.237817, 1.779268, 1.720720, 1.662171, 1.603622, 1.545073, 1.486524, 1.427976, 1.369427, 1.310878, 1.252329, 1.193780, 1.135232, 1.076683, 1.018134, 0.959585, 0.901036, 0.842488, 0.783939, 0.725390, 0.666841, 0.608292, 0.549744, 0.491195, 0.432646, 0.374097, 0.315548, 0.257000, 1.798451, 1.739902, 1.681353, 1.622804, 1.564256, 1.505707, 1.447158, 1.388609, 1.330060, 1.271512, 1.212963, 1.154414, 1.095865, 1.037316, 0.978768, 0.920219, 0.861670, 0.803121, 0.744572, 0.686024, 0.627475, 0.568926, 0.510377, 0.451828, 0.393280, 0.334731, 0.276182, 0.217633, 1.759084, 1.700536, 1.641987, 1.583438, 1.524889, 1.466340, 1.407792, 1.349243, 1.290694, 1.232145, 1.173596, 1.115048, 1.056499, 0.997950, 0.939401, 0.880852, 0.822304, 0.763755, 0.705206, 0.646657, 0.588108, 0.529560, 0.471011, 0.412462, 0.353913, 0.295364, 0.236816, 1.778267, 1.719718, 1.661169, 1.602620, 1.544072, 1.485523, 1.426974, 1.368425, 1.309876, 1.251328, 1.192779, 1.134230, 1.075681, 1.017132, 0.958584, 0.900035, 0.841486, 0.782937, 0.724388, 0.665840, 0.607291, 0.548742, 0.490193, 0.431644, 0.373096, 0.314547, 0.255998, 1.797449, 1.738900, 1.680352, 1.621803, 1.563254, 1.504705, 1.446156, 1.387608, 1.329059, 1.270510, 1.211961, 1.153412, 1.094864, 1.036315, 0.977766, 0.919217, 0.860668, 0.802120, 0.743571, 0.685022, 0.626473, 0.567924, 0.509376, 0.450827, 0.392278, 0.333729, 0.275180, 0.216632, 1.758083, 1.699534, 1.640985, 1.582436, 1.523888, 1.465339, 1.406790, 1.348241, 1.289692, 1.231144, 1.172595, 1.114046, 1.055497, 0.996948, 0.938400, 0.879851, 0.821302, 0.762753, 0.704204, 0.645656, 0.587107, 0.528558, 0.470009, 0.411460, 0.352912, 0.294363, 0.235814, 1.777265, 1.718716, 1.660168, 1.601619, 1.543070, 1.484521, 1.425972, 1.367424, 1.308875, 1.250326, 1.191777, 1.133228, 1.074680, 1.016131, 0.957582, 0.899033, 0.840484, 0.781936, 0.723387, 0.664838, 0.606289, 0.547740, 0.489192, 0.430643, 0.372094, 0.313545, 0.254996, 1.796448, 1.737899, 1.679350, 1.620801, 1.562252, 1.503704, 1.445155, 1.386606, 1.328057, 1.269508, 1.210960, 1.152411, 1.093862, 1.035313, 0.976764, 0.918216, 0.859667, 0.801118, 0.742569, 0.684020, 0.625472, 0.566923, 0.508374, 0.449825, 0.391276, 0.332728, 0.274179, 0.215630, 1.757081, 1.698532, 1.639984, 1.581435, 1.522886, 1.464337, 1.405788, 1.347240, 1.288691, 1.230142, 1.171593, 1.113044, 1.054496, 0.995947, 0.937398, 0.878849, 0.820300, 0.761752, 0.703203, 0.644654, 0.586105, 0.527556, 0.469008, 0.410459, 0.351910, 0.293361, 0.234812, 1.776264, 1.717715, 1.659166, 1.600617, 1.542068, 1.483520, 1.424971, 1.366422, 1.307873, 1.249324, 1.190776, 1.132227, 1.073678, 1.015129, 0.956580, 0.898032, 0.839483, 0.780934, 0.722385, 0.663836, 0.605288, 0.546739, 0.488190, 0.429641, 0.371092, 0.312544, 0.253995, 1.795446, 1.736897, 1.678348, 1.619800, 1.561251, 1.502702, 1.444153, 1.385604, 1.327056, 1.268507, 1.209958, 1.151409, 1.092860, 1.034312, 0.975763, 0.917214, 0.858665, 0.800116, 0.741568, 0.683019, 0.624470, 0.565921, 0.507372, 0.448824, 0.390275, 0.331726, 0.273177, 0.214628, 1.756080, 1.697531, 1.638982, 1.580433, 1.521884, 1.463336, 1.404787, 1.346238, 1.287689, 1.229140, 1.170592, 1.112043, 1.053494, 0.994945, 0.936396, 0.877848, 0.819299, 0.760750, 0.702201, 0.643652, 0.585104, 0.526555, 0.468006, 0.409457, 0.350908, 0.292360, 0.233811, 1.775262, 1.716713, 1.658164, 1.599616, 1.541067, 1.482518, 1.423969, 1.365420, 1.306872, 1.248323, 1.189774, 1.131225, 1.072676, 1.014128, 0.955579, 0.897030, 0.838481, 0.779932, 0.721384, 0.662835, 0.604286, 0.545737, 0.487188, 0.428640, 0.370091, 0.311542, 0.252993, 1.794444, 1.735896, 1.677347, 1.618798, 1.560249, 1.501700, 1.443152, 1.384603, 1.326054, 1.267505, 1.208956, 1.150408, 1.091859, 1.033310, 0.974761, 0.916212, 0.857664, 0.799115, 0.740566, 0.682017, 0.623468, 0.564920, 0.506371, 0.447822, 0.389273, 0.330724, 0.272176, 0.213627, 1.755078, 1.696529, 1.637980, 1.579432, 1.520883, 1.462334, 1.403785, 1.345236, 1.286688]))
#eval IO.println ("check_hashemiEnv_pot_le " ++ toString (check_hashemiEnv_pot_le 1.291563 1.233014 1.174465 1.115916 1.057368 0.998819 0.940270 0.881721 0.823172 0.764624 0.706075 0.647526 0.588977 0.530428 0.471880 0.413331 0.354782 0.296233 0.237684 1.779136 1.720587 1.662038 1.603489 1.544940 1.486392 1.427843 1.369294 1.310745 1.252196 1.193648 1.135099 1.076550 1.018001 0.959452 0.900904 0.842355 0.783806 0.725257 #[1.568179, 1.509630, 1.451081, 1.392532, 1.333984, 1.275435, 1.216886, 1.158337, 1.099788, 1.041240, 0.982691, 0.924142, 0.865593, 0.807044, 0.748496, 0.689947, 0.631398, 0.572849, 0.514300, 0.455752, 0.397203, 0.338654, 0.280105, 0.221556, 1.763008, 1.704459, 1.645910, 1.587361, 1.528812, 1.470264, 1.411715, 1.353166, 1.294617, 1.236068, 1.177520, 1.118971, 1.060422, 1.001873, 0.943324, 0.884776, 0.826227, 0.767678, 0.709129, 0.650580, 0.592032, 0.533483, 0.474934, 0.416385, 0.357836, 0.299288, 0.240739, 1.782190, 1.723641, 1.665092, 1.606544, 1.547995, 1.489446, 1.430897, 1.372348, 1.313800, 1.255251, 1.196702, 1.138153, 1.079604, 1.021056, 0.962507, 0.903958, 0.845409, 0.786860, 0.728312, 0.669763, 0.611214, 0.552665, 0.494116, 0.435568, 0.377019, 0.318470, 0.259921, 0.201372, 1.742824, 1.684275, 1.625726, 1.567177, 1.508628, 1.450080, 1.391531, 1.332982, 1.274433, 1.215884, 1.157336, 1.098787, 1.040238, 0.981689, 0.923140, 0.864592, 0.806043, 0.747494, 0.688945, 0.630396, 0.571848, 0.513299, 0.454750, 0.396201, 0.337652, 0.279104, 0.220555, 1.762006, 1.703457, 1.644908, 1.586360, 1.527811, 1.469262, 1.410713, 1.352164, 1.293616, 1.235067, 1.176518, 1.117969, 1.059420, 1.000872, 0.942323, 0.883774, 0.825225, 0.766676, 0.708128, 0.649579, 0.591030, 0.532481, 0.473932, 0.415384, 0.356835, 0.298286, 0.239737, 1.781188, 1.722640, 1.664091, 1.605542, 1.546993, 1.488444, 1.429896, 1.371347, 1.312798, 1.254249, 1.195700, 1.137152, 1.078603, 1.020054, 0.961505, 0.902956, 0.844408, 0.785859, 0.727310, 0.668761, 0.610212, 0.551664, 0.493115, 0.434566, 0.376017, 0.317468, 0.258920, 0.200371, 1.741822, 1.683273, 1.624724, 1.566176, 1.507627, 1.449078, 1.390529, 1.331980, 1.273432, 1.214883, 1.156334, 1.097785, 1.039236, 0.980688, 0.922139, 0.863590, 0.805041, 0.746492, 0.687944, 0.629395, 0.570846, 0.512297, 0.453748, 0.395200, 0.336651, 0.278102, 0.219553, 1.761004, 1.702456, 1.643907, 1.585358, 1.526809, 1.468260, 1.409712, 1.351163, 1.292614, 1.234065, 1.175516, 1.116968, 1.058419, 0.999870, 0.941321, 0.882772, 0.824224, 0.765675, 0.707126, 0.648577, 0.590028, 0.531480, 0.472931, 0.414382, 0.355833, 0.297284, 0.238736, 1.780187, 1.721638, 1.663089, 1.604540, 1.545992, 1.487443, 1.428894, 1.370345, 1.311796, 1.253248, 1.194699, 1.136150, 1.077601, 1.019052, 0.960504, 0.901955, 0.843406, 0.784857, 0.726308, 0.667760, 0.609211, 0.550662, 0.492113, 0.433564, 0.375016, 0.316467, 0.257918, 1.799369, 1.740820, 1.682272, 1.623723, 1.565174, 1.506625, 1.448076, 1.389528, 1.330979, 1.272430, 1.213881, 1.155332, 1.096784, 1.038235, 0.979686, 0.921137, 0.862588, 0.804040, 0.745491, 0.686942, 0.628393, 0.569844, 0.511296, 0.452747, 0.394198, 0.335649, 0.277100, 0.218552, 1.760003, 1.701454, 1.642905, 1.584356, 1.525808, 1.467259, 1.408710, 1.350161, 1.291612, 1.233064, 1.174515, 1.115966, 1.057417, 0.998868, 0.940320, 0.881771, 0.823222, 0.764673, 0.706124, 0.647576, 0.589027, 0.530478, 0.471929, 0.413380, 0.354832, 0.296283, 0.237734, 1.779185, 1.720636, 1.662088, 1.603539, 1.544990, 1.486441, 1.427892, 1.369344, 1.310795, 1.252246, 1.193697, 1.135148, 1.076600, 1.018051, 0.959502, 0.900953, 0.842404, 0.783856, 0.725307, 0.666758, 0.608209, 0.549660, 0.491112, 0.432563, 0.374014, 0.315465, 0.256916, 1.798368, 1.739819, 1.681270, 1.622721, 1.564172, 1.505624, 1.447075, 1.388526, 1.329977, 1.271428, 1.212880, 1.154331, 1.095782, 1.037233, 0.978684, 0.920136, 0.861587, 0.803038, 0.744489, 0.685940, 0.627392, 0.568843, 0.510294, 0.451745, 0.393196, 0.334648, 0.276099, 0.217550, 1.759001, 1.700452, 1.641904, 1.583355, 1.524806, 1.466257, 1.407708, 1.349160, 1.290611, 1.232062, 1.173513, 1.114964, 1.056416, 0.997867, 0.939318, 0.880769, 0.822220, 0.763672, 0.705123, 0.646574, 0.588025, 0.529476, 0.470928, 0.412379, 0.353830, 0.295281, 0.236732, 1.778184, 1.719635, 1.661086, 1.602537, 1.543988, 1.485440, 1.426891, 1.368342, 1.309793, 1.251244, 1.192696, 1.134147, 1.075598, 1.017049, 0.958500, 0.899952, 0.841403, 0.782854, 0.724305, 0.665756, 0.607208, 0.548659, 0.490110, 0.431561, 0.373012, 0.314464, 0.255915, 1.797366, 1.738817, 1.680268, 1.621720, 1.563171, 1.504622, 1.446073, 1.387524, 1.328976, 1.270427, 1.211878, 1.153329, 1.094780, 1.036232, 0.977683, 0.919134, 0.860585, 0.802036, 0.743488, 0.684939, 0.626390, 0.567841, 0.509292, 0.450744, 0.392195, 0.333646, 0.275097, 0.216548, 1.758000, 1.699451, 1.640902, 1.582353, 1.523804, 1.465256, 1.406707, 1.348158, 1.289609, 1.231060, 1.172512, 1.113963, 1.055414, 0.996865, 0.938316, 0.879768, 0.821219, 0.762670, 0.704121, 0.645572, 0.587024, 0.528475, 0.469926, 0.411377, 0.352828, 0.294280, 0.235731, 1.777182, 1.718633, 1.660084, 1.601536, 1.542987, 1.484438, 1.425889, 1.367340, 1.308792, 1.250243, 1.191694, 1.133145, 1.074596, 1.016048, 0.957499, 0.898950, 0.840401, 0.781852, 0.723304, 0.664755, 0.606206, 0.547657, 0.489108, 0.430560, 0.372011, 0.313462, 0.254913, 1.796364, 1.737816, 1.679267, 1.620718, 1.562169, 1.503620, 1.445072, 1.386523, 1.327974, 1.269425, 1.210876, 1.152328, 1.093779, 1.035230, 0.976681, 0.918132, 0.859584, 0.801035, 0.742486, 0.683937, 0.625388, 0.566840, 0.508291, 0.449742, 0.391193, 0.332644, 0.274096, 0.215547, 1.756998, 1.698449, 1.639900, 1.581352, 1.522803, 1.464254, 1.405705, 1.347156, 1.288608, 1.230059, 1.171510, 1.112961, 1.054412, 0.995864, 0.937315, 0.878766, 0.820217, 0.761668, 0.703120, 0.644571, 0.586022, 0.527473, 0.468924, 0.410376, 0.351827, 0.293278, 0.234729, 1.776180, 1.717632, 1.659083, 1.600534, 1.541985, 1.483436, 1.424888, 1.366339, 1.307790, 1.249241, 1.190692, 1.132144, 1.073595, 1.015046, 0.956497, 0.897948, 0.839400, 0.780851, 0.722302, 0.663753, 0.605204, 0.546656, 0.488107, 0.429558, 0.371009, 0.312460, 0.253912, 1.795363, 1.736814, 1.678265, 1.619716, 1.561168, 1.502619, 1.444070, 1.385521, 1.326972, 1.268424, 1.209875, 1.151326, 1.092777, 1.034228, 0.975680, 0.917131, 0.858582, 0.800033, 0.741484, 0.682936, 0.624387, 0.565838, 0.507289, 0.448740, 0.390192, 0.331643, 0.273094, 0.214545, 1.755996, 1.697448, 1.638899, 1.580350, 1.521801, 1.463252, 1.404704, 1.346155, 1.287606, 1.229057, 1.170508, 1.111960, 1.053411, 0.994862, 0.936313, 0.877764, 0.819216, 0.760667, 0.702118, 0.643569, 0.585020, 0.526472, 0.467923, 0.409374, 0.350825, 0.292276, 0.233728, 1.775179, 1.716630, 1.658081, 1.599532, 1.540984, 1.482435, 1.423886, 1.365337, 1.306788, 1.248240, 1.189691, 1.131142, 1.072593, 1.014044, 0.955496]))

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

def heatParams  : Array Float :=
  #[(0.9 : Float), (0.8 : Float), (0.03 : Float), (15 : Float), (0.92 : Float), (15 : Float), (6300 : Float), (593 : Float)]

#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))

def heatStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Array Float :=
  let v22 := (Toil - Ta)
  #[(min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * Pin), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("heatStep " ++ toString ((heatStep 1.506275 1.447726 1.389177 1.330628 1.272080 1.213531 1.154982 1.096433 1.037884 0.979336 0.920787 0.862238 0.803689).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 1.175083 1.116534 1.057985 0.999436 0.940888 0.882339 0.823790 0.765241 0.706692 0.648144 0.589595 0.531046 0.472497).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.843891 0.785342 0.726793 0.668244 0.609696 0.551147 0.492598 0.434049 0.375500 0.316952 0.258403 1.799854 1.741305).map Float.toBits))

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.320123 1.261574).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.988931 0.930382).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.657739 0.599190).toBits)

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

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.947819 0.889270).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.616627 0.558078).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.285435 0.226886).map Float.toBits))

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

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.761667 0.703118 0.644569 0.586020 0.527472 0.468923 0.410374 0.351825))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.430475 0.371926 0.313377 0.254828 1.796280 1.737731 1.679182 1.620633))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.699283 1.640734 1.582185 1.523636 1.465088 1.406539 1.347990 1.289441))

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

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.575515 0.516966 0.458417 0.399868 0.341320 0.282771 0.224222 1.765673 1.707124))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.244323 1.785774 1.727225 1.668676 1.610128 1.551579 1.493030 1.434481 1.375932))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.513131 1.454582 1.396033 1.337484 1.278936 1.220387 1.161838 1.103289 1.044740))

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

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.389363 0.330814 0.272265))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.658171 1.599622 1.541073))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.326979 1.268430 1.209881))

def hpHashemi  : Float :=
  (0.34 : Float)

#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 1.617059 1.558510 1.499961 1.441412 1.382864 1.324315 1.265766).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 1.285867 1.227318 1.168769 1.110220 1.051672 0.993123 0.934574).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.954675 0.896126 0.837577 0.779028 0.720480 0.661931 0.603382).map Float.toBits))

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

#eval IO.println ("leverAt " ++ toString (leverAt 1.244755 1.186206 1.127657 1.069108 1.010560).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.913563 0.855014 0.796465 0.737916 0.679368).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.582371 0.523822 0.465273 0.406724 0.348176).toBits)

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

#eval IO.println ("lostSunS " ++ toString (lostSunS 1.058603 1.000054 0.941505 0.882956 0.824408 0.765859).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.727411 0.668862 0.610313 0.551764 0.493216 0.434667).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.396219 0.337670 0.279121 0.220572 1.762024 1.703475).toBits)

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

#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.872451 0.813902 0.755353 0.696804 0.638256 0.579707))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.541259 0.482710 0.424161 0.365612 0.307064 0.248515))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.210067 1.751518 1.692969 1.634420 1.575872 1.517323))

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

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.686299 0.627750 0.569201 0.510652 0.452104 0.393555))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.355107 0.296558 0.238009 1.779460 1.720912 1.662363))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.623915 1.565366 1.506817 1.448268 1.389720 1.331171))

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

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.500147 0.441598 0.383049 0.324500 0.265952 0.207403))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.768955 1.710406 1.651857 1.593308 1.534760 1.476211))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.437763 1.379214 1.320665 1.262116 1.203568 1.145019))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.727843))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.396651))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.065459))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.355539))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.024347))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.693155))

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

#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.797083 0.738534 0.679985 0.621436 0.562888 0.504339 0.445790 0.387241 0.328692 0.270144 0.211595 1.753046 1.694497 1.635948 1.577400 1.518851 1.460302).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.465891 0.407342 0.348793 0.290244 0.231696 1.773147 1.714598 1.656049 1.597500 1.538952 1.480403 1.421854 1.363305 1.304756 1.246208 1.187659 1.129110).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.734699 1.676150 1.617601 1.559052 1.500504 1.441955 1.383406 1.324857 1.266308 1.207760 1.149211 1.090662 1.032113 0.973564 0.915016 0.856467 0.797918).map Float.toBits))

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

#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.424779 0.366230 0.307681 0.249132 1.790584 1.732035 1.673486 1.614937 1.556388 1.497840 1.439291 1.380742 1.322193 1.263644 1.205096 1.146547 1.087998).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.693587 1.635038 1.576489 1.517940 1.459392 1.400843 1.342294 1.283745 1.225196 1.166648 1.108099 1.049550 0.991001 0.932452 0.873904 0.815355 0.756806).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.362395 1.303846 1.245297 1.186748 1.128200 1.069651 1.011102 0.952553 0.894004 0.835456 0.776907 0.718358 0.659809 0.601260 0.542712 0.484163 0.425614).map Float.toBits))

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

#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.238627 1.780078 1.721529 1.662980 1.604432 1.545883 1.487334 1.428785 1.370236 1.311688 1.253139 1.194590 1.136041 1.077492 1.018944 0.960395 0.901846).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.507435 1.448886 1.390337 1.331788 1.273240 1.214691 1.156142 1.097593 1.039044 0.980496 0.921947 0.863398 0.804849 0.746300 0.687752 0.629203 0.570654).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.176243 1.117694 1.059145 1.000596 0.942048 0.883499 0.824950 0.766401 0.707852 0.649304 0.590755 0.532206 0.473657 0.415108 0.356560 0.298011 0.239462).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.652475 1.593926 1.535377).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.321283 1.262734 1.204185).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.990091 0.931542 0.872993).toBits)

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

#eval IO.println ("megaStep " ++ toString ((megaStep 1.466323 1.407774 1.349225 1.290676 1.232128 1.173579 1.115030 1.056481 0.997932 0.939384 0.880835 0.822286 0.763737 0.705188 0.646640 0.588091 0.529542).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.135131 1.076582 1.018033 0.959484 0.900936 0.842387 0.783838 0.725289 0.666740 0.608192 0.549643 0.491094 0.432545 0.373996 0.315448 0.256899 1.798350).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.803939 0.745390 0.686841 0.628292 0.569744 0.511195 0.452646 0.394097 0.335548 0.277000 0.218451 1.759902 1.701353 1.642804 1.584256 1.525707 1.467158).map Float.toBits))

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

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.280171 1.221622 1.163073 1.104524 1.045976 0.987427 0.928878 0.870329 0.811780 0.753232 0.694683 0.636134 0.577585 0.519036 0.460488 0.401939 0.343390).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.948979 0.890430 0.831881 0.773332 0.714784 0.656235 0.597686 0.539137 0.480588 0.422040 0.363491 0.304942 0.246393 1.787844 1.729296 1.670747 1.612198).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.617787 0.559238 0.500689 0.442140 0.383592 0.325043 0.266494 0.207945 1.749396 1.690848 1.632299 1.573750 1.515201 1.456652 1.398104 1.339555 1.281006).map Float.toBits))

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

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.094019 1.035470 0.976921 0.918372 0.859824 0.801275 0.742726 0.684177 0.625628 0.567080 0.508531 0.449982 0.391433 0.332884 0.274336 0.215787 1.757238).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.762827 0.704278 0.645729 0.587180 0.528632 0.470083 0.411534 0.352985 0.294436 0.235888 1.777339 1.718790 1.660241 1.601692 1.543144 1.484595 1.426046).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.431635 0.373086 0.314537 0.255988 1.797440 1.738891 1.680342 1.621793 1.563244 1.504696 1.446147 1.387598 1.329049 1.270500 1.211952 1.153403 1.094854).map Float.toBits))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.907867 0.849318 0.790769 0.732220 0.673672 0.615123))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.576675 0.518126 0.459577 0.401028 0.342480 0.283931))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.245483 1.786934 1.728385 1.669836 1.611288 1.552739))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.721715 0.663166 0.604617 0.546068 0.487520 0.428971))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.390523 0.331974 0.273425 0.214876 1.756328 1.697779))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.659331 1.600782 1.542233 1.483684 1.425136 1.366587))

def oilStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Float :=
  let v22 := (Toil - Ta)
  (min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil)))

#eval IO.println ("oilStep " ++ toString (oilStep 0.535563 0.477014 0.418465 0.359916 0.301368 0.242819 1.784270 1.725721 1.667172 1.608624 1.550075 1.491526 1.432977).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.204371 1.745822 1.687273 1.628724 1.570176 1.511627 1.453078 1.394529 1.335980 1.277432 1.218883 1.160334 1.101785).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 1.473179 1.414630 1.356081 1.297532 1.238984 1.180435 1.121886 1.063337 1.004788 0.946240 0.887691 0.829142 0.770593).toBits)

def check_oilStep_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Twall : Float) (Ta : Float) (dt : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v27 := (alpha * Pin)
  let v30 := ((eps * (0.0000000567 : Float)) * Ac)
  let v32 := (Ta ^ 4)
  let v35 := (hC * Ac)
  let v36 := (T1 - Ta)
  let v53 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) < Coil) || (!((0 : Float) <= dt) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((min ToilMax (T1 + ((dt * (((v27 - ((v30 * ((T1 ^ 4) - v32)) + (v35 * v36))) - (Upipe * v36)) - (max (0 : Float) (UAx * (T1 - Twall))))) / Coil))) - (min ToilMax (T2 + ((dt * (((v27 - ((v30 * ((T2 ^ 4) - v32)) + (v35 * v53))) - (Upipe * v53)) - (max (0 : Float) (UAx * (T2 - Twall))))) / Coil))))) <= (((1 : Float) + ((dt * ((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v35) + Upipe) + UAx)) / Coil)) * (Float.abs (T1 - T2)))))))))))))))

#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.349411 0.290862 0.232313 1.773764 1.715216 1.656667 1.598118 1.539569 1.481020 1.422472 1.363923 1.305374 1.246825 1.188276 1.129728))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.618219 1.559670 1.501121 1.442572 1.384024 1.325475 1.266926 1.208377 1.149828 1.091280 1.032731 0.974182 0.915633 0.857084 0.798536))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.287027 1.228478 1.169929 1.111380 1.052832 0.994283 0.935734 0.877185 0.818636 0.760088 0.701539 0.642990 0.584441 0.525892 0.467344))

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

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.390955 1.332406 1.273857 1.215308))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.059763 1.001214 0.942665 0.884116))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.728571 0.670022 0.611473 0.552924))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.204803))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.873611))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.542419))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 1.018651 0.960102 0.901553 0.843004 0.784456 0.725907 0.667358 0.608809 0.550260).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.687459 0.628910 0.570361 0.511812 0.453264 0.394715 0.336166 0.277617 0.219068).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.356267 0.297718 0.239169 1.780620 1.722072 1.663523 1.604974 1.546425 1.487876).map Float.toBits))

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

#eval IO.println ("pointingError " ++ toString (pointingError 0.832499 0.773950 0.715401 0.656852).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.501307 0.442758 0.384209 0.325660).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 1.770115 1.711566 1.653017 1.594468).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 0.646347 0.587798 0.529249 0.470700 0.412152 0.353603 0.295054 0.236505 1.777956 1.719408 1.660859 1.602310 1.543761).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 0.315155 0.256606 1.798057 1.739508 1.680960 1.622411 1.563862 1.505313 1.446764 1.388216 1.329667 1.271118 1.212569).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.583963 1.525414 1.466865 1.408316 1.349768 1.291219 1.232670 1.174121 1.115572 1.057024 0.998475 0.939926 0.881377).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.460195 0.401646 0.343097 0.284548 0.226000 1.767451 1.708902 1.650353 1.591804 1.533256 1.474707 1.416158))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.729003 1.670454 1.611905 1.553356 1.494808 1.436259 1.377710 1.319161 1.260612 1.202064 1.143515 1.084966))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.397811 1.339262 1.280713 1.222164 1.163616 1.105067 1.046518 0.987969 0.929420 0.870872 0.812323 0.753774))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.274043 0.215494 1.756945 1.698396 1.639848 1.581299 1.522750 1.464201 1.405652 1.347104 1.288555 1.230006))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.542851 1.484302 1.425753 1.367204 1.308656 1.250107 1.191558 1.133009 1.074460 1.015912 0.957363 0.898814))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.211659 1.153110 1.094561 1.036012 0.977464 0.918915 0.860366 0.801817 0.743268 0.684720 0.626171 0.567622))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.687891 1.629342 1.570793 1.512244 1.453696 1.395147 1.336598 1.278049 1.219500 1.160952 1.102403 1.043854))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.356699 1.298150 1.239601 1.181052 1.122504 1.063955 1.005406 0.946857 0.888308 0.829760 0.771211 0.712662))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.025507 0.966958 0.908409 0.849860 0.791312 0.732763 0.674214 0.615665 0.557116 0.498568 0.440019 0.381470))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.501739 1.443190 1.384641 1.326092 1.267544 1.208995 1.150446 1.091897 1.033348 0.974800 0.916251 0.857702 0.799153))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.170547 1.111998 1.053449 0.994900 0.936352 0.877803 0.819254 0.760705 0.702156 0.643608 0.585059 0.526510 0.467961))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.839355 0.780806 0.722257 0.663708 0.605160 0.546611 0.488062 0.429513 0.370964 0.312416 0.253867 1.795318 1.736769))

def check_pow4_lipschitz (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((T1 ^ 4) - (T2 ^ 4))) <= (((4 : Float) * (M ^ 3)) * (Float.abs (T1 - T2))))))))

#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.315587 1.257038 1.198489))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.984395 0.925846 0.867297))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.653203 0.594654 0.536105))

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

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.426371 1.367822 1.309273))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.095179 1.036630 0.978081))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.763987 0.705438 0.646889))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.240219))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.909027))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.577835))

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

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.495611 0.437062))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.764419 1.705870))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.433227 1.374678))

def prop_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.309459 0.250910 1.792361))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.578267 1.519718 1.461169))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.247075 1.188526 1.129977))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.723307))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.392115))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.060923))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.537155 1.478606))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.205963 1.147414))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.874771 0.816222))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.351003 1.292454))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.019811 0.961262))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.688619 0.630070))

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

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.164851 1.106302 1.047753 0.989204 0.930656 0.872107 0.813558 0.755009 0.696460 0.637912 0.579363 0.520814))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.833659 0.775110 0.716561 0.658012 0.599464 0.540915 0.482366 0.423817 0.365268 0.306720 0.248171 1.789622))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.502467 0.443918 0.385369 0.326820 0.268272 0.209723 1.751174 1.692625 1.634076 1.575528 1.516979 1.458430))

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

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.420243 0.361694 0.303145))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.689051 1.630502 1.571953))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.357859 1.299310 1.240761))

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

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.461787 1.403238 1.344689 1.286140 1.227592 1.169043 1.110494 1.051945 0.993396 0.934848 0.876299 0.817750 0.759201))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.130595 1.072046 1.013497 0.954948 0.896400 0.837851 0.779302 0.720753 0.662204 0.603656 0.545107 0.486558 0.428009))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.799403 0.740854 0.682305 0.623756 0.565208 0.506659 0.448110 0.389561 0.331012 0.272464 0.213915 1.755366 1.696817))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.275635 1.217086 1.158537 1.099988 1.041440 0.982891 0.924342 0.865793 0.807244 0.748696 0.690147 0.631598 0.573049))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.944443 0.885894 0.827345 0.768796 0.710248 0.651699 0.593150 0.534601 0.476052 0.417504 0.358955 0.300406 0.241857))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.613251 0.554702 0.496153 0.437604 0.379056 0.320507 0.261958 0.203409 1.744860 1.686312 1.627763 1.569214 1.510665))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.089483 1.030934 0.972385 0.913836 0.855288))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.758291 0.699742 0.641193 0.582644 0.524096))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.427099 0.368550 0.310001 0.251452 1.792904))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.903331 0.844782 0.786233))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.572139 0.513590 0.455041))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.240947 1.782398 1.723849))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.717179))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.385987))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.654795))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.531027 0.472478 0.413929))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.799835 1.741286 1.682737))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.468643 1.410094 1.351545))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.344875 0.286326 0.227777))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.613683 1.555134 1.496585))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.282491 1.223942 1.165393))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.758723 1.700174 1.641625 1.583076))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.427531 1.368982 1.310433 1.251884))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.096339 1.037790 0.979241 0.920692))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.572571 1.514022 1.455473))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.241379 1.182830 1.124281))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.910187 0.851638 0.793089))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.386419 1.327870 1.269321 1.210772 1.152224))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.055227 0.996678 0.938129 0.879580 0.821032))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.724035 0.665486 0.606937 0.548388 0.489840))

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

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.200267 1.141718 1.083169 1.024620 0.966072))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.869075 0.810526 0.751977 0.693428 0.634880))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.537883 0.479334 0.420785 0.362236 0.303688))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.014115 0.955566 0.897017 0.838468 0.779920))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.682923 0.624374 0.565825 0.507276 0.448728))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.351731 0.293182 0.234633 1.776084 1.717536))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.827963 0.769414 0.710865 0.652316))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.496771 0.438222 0.379673 0.321124))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.765579 1.707030 1.648481 1.589932))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.455659 0.397110 0.338561))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.724467 1.665918 1.607369))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.393275 1.334726 1.276177))

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

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.269507 0.210958 1.752409 1.693860 1.635312 1.576763 1.518214 1.459665 1.401116 1.342568 1.284019 1.225470))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.538315 1.479766 1.421217 1.362668 1.304120 1.245571 1.187022 1.128473 1.069924 1.011376 0.952827 0.894278))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.207123 1.148574 1.090025 1.031476 0.972928 0.914379 0.855830 0.797281 0.738732 0.680184 0.621635 0.563086))

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

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.683355 1.624806 1.566257 1.507708 1.449160 1.390611 1.332062 1.273513 1.214964 1.156416 1.097867 1.039318))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.352163 1.293614 1.235065 1.176516 1.117968 1.059419 1.000870 0.942321 0.883772 0.825224 0.766675 0.708126))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.020971 0.962422 0.903873 0.845324 0.786776 0.728227 0.669678 0.611129 0.552580 0.494032 0.435483 0.376934))

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

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.497203 1.438654 1.380105 1.321556 1.263008 1.204459 1.145910 1.087361 1.028812 0.970264 0.911715 0.853166))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.166011 1.107462 1.048913 0.990364 0.931816 0.873267 0.814718 0.756169 0.697620 0.639072 0.580523 0.521974))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.834819 0.776270 0.717721 0.659172 0.600624 0.542075 0.483526 0.424977 0.366428 0.307880 0.249331 1.790782))

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

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.607987 1.549438 1.490889 1.432340 1.373792 1.315243 1.256694 1.198145))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.276795 1.218246 1.159697 1.101148 1.042600 0.984051 0.925502 0.866953))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.945603 0.887054 0.828505 0.769956 0.711408 0.652859 0.594310 0.535761))

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

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.421835 1.363286 1.304737 1.246188 1.187640 1.129091 1.070542 1.011993 0.953444))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.090643 1.032094 0.973545 0.914996 0.856448 0.797899 0.739350 0.680801 0.622252))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.759451 0.700902 0.642353 0.583804 0.525256 0.466707 0.408158 0.349609 0.291060))

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

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.235683 1.177134 1.118585))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.904491 0.845942 0.787393))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.573299 0.514750 0.456201))

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

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.677227))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.346035))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.614843))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.304923))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.573731))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.242539))

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

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.346467 1.287918 1.229369 1.170820 1.112272 1.053723))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.015275 0.956726 0.898177 0.839628 0.781080 0.722531))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.684083 0.625534 0.566985 0.508436 0.449888 0.391339))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.160315 1.101766 1.043217 0.984668 0.926120 0.867571))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.829123 0.770574 0.712025 0.653476 0.594928 0.536379))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.497931 0.439382 0.380833 0.322284 0.263736 0.205187))

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

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.601859 0.543310 0.484761 0.426212))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.270667 0.212118 1.753569 1.695020))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.539475 1.480926 1.422377 1.363828))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.415707))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.684515))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.353323))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.229555 1.771006 1.712457 1.653908 1.595360 1.536811 1.478262 1.419713 1.361164 1.302616 1.244067 1.185518))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.498363 1.439814 1.381265 1.322716 1.264168 1.205619 1.147070 1.088521 1.029972 0.971424 0.912875 0.854326))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.167171 1.108622 1.050073 0.991524 0.932976 0.874427 0.815878 0.757329 0.698780 0.640232 0.581683 0.523134))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.643403 1.584854 1.526305 1.467756 1.409208 1.350659 1.292110 1.233561 1.175012 1.116464 1.057915 0.999366))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.312211 1.253662 1.195113 1.136564 1.078016 1.019467 0.960918 0.902369 0.843820 0.785272 0.726723 0.668174))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.981019 0.922470 0.863921 0.805372 0.746824 0.688275 0.629726 0.571177 0.512628 0.454080 0.395531 0.336982))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.457251 1.398702 1.340153 1.281604 1.223056 1.164507 1.105958 1.047409 0.988860 0.930312 0.871763 0.813214))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.126059 1.067510 1.008961 0.950412 0.891864 0.833315 0.774766 0.716217 0.657668 0.599120 0.540571 0.482022))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.794867 0.736318 0.677769 0.619220 0.560672 0.502123 0.443574 0.385025 0.326476 0.267928 0.209379 1.750830))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.271099 1.212550 1.154001 1.095452 1.036904 0.978355 0.919806 0.861257 0.802708 0.744160 0.685611 0.627062 0.568513))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.939907 0.881358 0.822809 0.764260 0.705712 0.647163 0.588614 0.530065 0.471516 0.412968 0.354419 0.295870 0.237321))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.608715 0.550166 0.491617 0.433068 0.374520 0.315971 0.257422 1.798873 1.740324 1.681776 1.623227 1.564678 1.506129))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.898795 0.840246 0.781697 0.723148))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.567603 0.509054 0.450505 0.391956))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.236411 1.777862 1.719313 1.660764))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.526491 0.467942 0.409393))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.795299 1.736750 1.678201))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.464107 1.405558 1.347009))

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

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.381883 1.323334 1.264785 1.206236 1.147688 1.089139))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.050691 0.992142 0.933593 0.875044 0.816496 0.757947))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.719499 0.660950 0.602401 0.543852 0.485304 0.426755))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.195731 1.137182 1.078633 1.020084 0.961536 0.902987))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.864539 0.805990 0.747441 0.688892 0.630344 0.571795))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.533347 0.474798 0.416249 0.357700 0.299152 0.240603))

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

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.823427 0.764878 0.706329 0.647780 0.589232 0.530683 0.472134))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.492235 0.433686 0.375137 0.316588 0.258040 1.799491 1.740942))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.761043 1.702494 1.643945 1.585396 1.526848 1.468299 1.409750))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.637275 0.578726))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.306083 0.247534))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.574891 1.516342))

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

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.678819 1.620270))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.347627 1.289078))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.016435 0.957886))

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

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.492667 1.434118 1.375569 1.317020 1.258472 1.199923 1.141374 1.082825 1.024276))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.161475 1.102926 1.044377 0.985828 0.927280 0.868731 0.810182 0.751633 0.693084))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.830283 0.771734 0.713185 0.654636 0.596088 0.537539 0.478990 0.420441 0.361892))

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

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.306515 1.247966 1.189417))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.975323 0.916774 0.858225))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.644131 0.585582 0.527033))

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

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.561907 0.503358 0.444809 0.386260))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.230715 1.772166 1.713617 1.655068))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.499523 1.440974 1.382425 1.323876))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.375755 0.317206 0.258657 0.200108 1.741560))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.644563 1.586014 1.527465 1.468916 1.410368))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.313371 1.254822 1.196273 1.137724 1.079176))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.603451 1.544902 1.486353))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.272259 1.213710 1.155161))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.941067 0.882518 0.823969))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.231147 1.172598 1.114049 1.055500 0.996952 0.938403 0.879854 0.821305 0.762756 0.704208))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.899955 0.841406 0.782857 0.724308 0.665760 0.607211 0.548662 0.490113 0.431564 0.373016))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.568763 0.510214 0.451665 0.393116 0.334568 0.276019 0.217470 1.758921 1.700372 1.641824))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.044995 0.986446 0.927897))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.713803 0.655254 0.596705))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.382611 0.324062 0.265513))

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

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.858843 0.800294 0.741745 0.683196 0.624648))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.527651 0.469102 0.410553 0.352004 0.293456))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.796459 1.737910 1.679361 1.620812 1.562264))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.672691 0.614142 0.555593 0.497044 0.438496))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.341499 0.282950 0.224401 1.765852 1.707304))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.610307 1.551758 1.493209 1.434660 1.376112))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.486539))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.755347))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.424155))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.300387 0.241838 1.783289 1.724740))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.569195 1.510646 1.452097 1.393548))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.238003 1.179454 1.120905 1.062356))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.714235 1.655686 1.597137 1.538588 1.480040))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.383043 1.324494 1.265945 1.207396 1.148848))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.051851 0.993302 0.934753 0.876204 0.817656))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.528083 1.469534 1.410985 1.352436 1.293888))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.196891 1.138342 1.079793 1.021244 0.962696))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.865699 0.807150 0.748601 0.690052 0.631504))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.341931 1.283382 1.224833))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.010739 0.952190 0.893641))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.679547 0.620998 0.562449))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.155779))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.824587))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.493395))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.969627 0.911078 0.852529 0.793980))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.638435 0.579886 0.521337 0.462788))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.307243 0.248694 1.790145 1.731596))

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

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.597323 0.538774 0.480225 0.421676 0.363128))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.266131 0.207582 1.749033 1.690484 1.631936))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.534939 1.476390 1.417841 1.359292 1.300744))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.411171 0.352622 0.294073 0.235524))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.679979 1.621430 1.562881 1.504332))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.348787 1.290238 1.231689 1.173140))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.225019 1.766470 1.707921 1.649372))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.493827 1.435278 1.376729 1.318180))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.162635 1.104086 1.045537 0.986988))

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

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.266563 1.208014 1.149465 1.090916 1.032368 0.973819 0.915270 0.856721))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.935371 0.876822 0.818273 0.759724 0.701176 0.642627 0.584078 0.525529))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.604179 0.545630 0.487081 0.428532 0.369984 0.311435 0.252886 1.794337))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.894259 0.835710 0.777161 0.718612))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.563067 0.504518 0.445969 0.387420))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.231875 1.773326 1.714777 1.656228))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.708107 0.649558 0.591009))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.376915 0.318366 0.259817))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.645723 1.587174 1.528625))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.335803 0.277254).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.604611 1.546062).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.273419 1.214870).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def qAbs (alpha : Float) (Pin : Float) : Float :=
  (alpha * Pin)

#eval IO.println ("qAbs " ++ toString (qAbs 1.563499 1.504950).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 1.232307 1.173758).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 0.901115 0.842566).toBits)

def qCoilLoss (eps : Float) (Ac : Float) (hC : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.377347 1.318798 1.260249 1.201700 1.143152).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.046155 0.987606 0.929057 0.870508 0.811960).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.714963 0.656414 0.597865 0.539316 0.480768).toBits)

def qNet (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Float :=
  let v19 := (Toil - Ta)
  ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("qNet " ++ toString (qNet 1.191195 1.132646 1.074097 1.015548 0.957000 0.898451 0.839902 0.781353 0.722804 0.664256).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.860003 0.801454 0.742905 0.684356 0.625808 0.567259 0.508710 0.450161 0.391612 0.333064).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.528811 0.470262 0.411713 0.353164 0.294616 0.236067 1.777518 1.718969 1.660420 1.601872).toBits)

def check_qNet_antitone (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) <= (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.005043 0.946494 0.887945 0.829396 0.770848 0.712299 0.653750 0.595201 0.536652 0.478104 0.419555))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.673851 0.615302 0.556753 0.498204 0.439656 0.381107 0.322558 0.264009 0.205460 1.746912 1.688363))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.342659 0.284110 0.225561 1.767012 1.708464 1.649915 1.591366 1.532817 1.474268 1.415720 1.357171))

def check_qNet_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v22 := (alpha * Pin)
  let v25 := ((eps * (0.0000000567 : Float)) * Ac)
  let v27 := (Ta ^ 4)
  let v30 := (hC * Ac)
  let v31 := (T1 - Ta)
  let v44 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((((v22 - ((v25 * ((T1 ^ 4) - v27)) + (v30 * v31))) - (Upipe * v31)) - (max (0 : Float) (UAx * (T1 - Twall)))) - (((v22 - ((v25 * ((T2 ^ 4) - v27)) + (v30 * v44))) - (Upipe * v44)) - (max (0 : Float) (UAx * (T2 - Twall)))))) <= (((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v30) + Upipe) + UAx) * (Float.abs (T1 - T2)))))))))))))

#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.818891 0.760342 0.701793 0.643244 0.584696 0.526147 0.467598 0.409049 0.350500 0.291952 0.233403 1.774854))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.487699 0.429150 0.370601 0.312052 0.253504 1.794955 1.736406 1.677857 1.619308 1.560760 1.502211 1.443662))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.756507 1.697958 1.639409 1.580860 1.522312 1.463763 1.405214 1.346665 1.288116 1.229568 1.171019 1.112470))

def check_qNet_strictAnti (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 < T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) < (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.632739 0.574190 0.515641 0.457092 0.398544 0.339995 0.281446 0.222897 1.764348 1.705800 1.647251))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.301547 0.242998 1.784449 1.725900 1.667352 1.608803 1.550254 1.491705 1.433156 1.374608 1.316059))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.570355 1.511806 1.453257 1.394708 1.336160 1.277611 1.219062 1.160513 1.101964 1.043416 0.984867))

def qPipe (Upipe : Float) (Toil : Float) (Ta : Float) : Float :=
  (Upipe * (Toil - Ta))

#eval IO.println ("qPipe " ++ toString (qPipe 0.446587 0.388038 0.329489).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.715395 1.656846 1.598297).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.384203 1.325654 1.267105).toBits)

def qPot (UAx : Float) (Toil : Float) (Twall : Float) : Float :=
  (max (0 : Float) (UAx * (Toil - Twall)))

#eval IO.println ("qPot " ++ toString (qPot 0.260435 0.201886 1.743337).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.529243 1.470694 1.412145).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.198051 1.139502 1.080953).toBits)

def check_qPot_le (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  let v5 := (Toil - Twall)
  (!((0 : Float) <= UAx) || ((max (0 : Float) (UAx * v5)) <= (UAx * (max (0 : Float) v5))))

#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.674283 1.615734 1.557185))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.343091 1.284542 1.225993))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.011899 0.953350 0.894801))

def check_qPot_nonneg (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  ((0 : Float) <= (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.488131 1.429582 1.371033))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.156939 1.098390 1.039841))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.825747 0.767198 0.708649))

def check_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v6 := (ym * a)
  (!((0 : Float) < ze) || ((v6 <= (hp * ze)) == ((v6 / ze) <= hp)))

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.301979 1.243430 1.184881 1.126332))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.970787 0.912238 0.853689 0.795140))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.639595 0.581046 0.522497 0.463948))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 0.929675 0.871126 0.812577 0.754028 0.695480 0.636931 0.578382 0.519833 0.461284 0.402736 0.344187 0.285638).toBits)
#eval IO.println ("recip " ++ toString (recip 0.598483 0.539934 0.481385 0.422836 0.364288 0.305739 0.247190 1.788641 1.730092 1.671544 1.612995 1.554446).toBits)
#eval IO.println ("recip " ++ toString (recip 0.267291 0.208742 1.750193 1.691644 1.633096 1.574547 1.515998 1.457449 1.398900 1.340352 1.281803 1.223254).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 0.743523 0.684974 0.626425 0.567876 0.509328 0.450779).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 0.412331 0.353782 0.295233 0.236684 1.778136 1.719587).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.681139 1.622590 1.564041 1.505492 1.446944 1.388395).map Float.toBits))

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

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.371219 0.312670 0.254121))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.640027 1.581478 1.522929))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.308835 1.250286 1.191737))

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

#eval IO.println ("rollY " ++ toString ((rollY 1.412763 1.354214 1.295665).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 1.081571 1.023022 0.964473).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.750379 0.691830 0.633281).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.226611 1.168062 1.109513 1.050964 0.992416 0.933867).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.895419 0.836870 0.778321 0.719772 0.661224 0.602675).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.564227 0.505678 0.447129 0.388580 0.330032 0.271483).toBits)

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

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.668155 0.609606 0.551057 0.492508 0.433960 0.375411))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.336963 0.278414 0.219865 1.761316 1.702768 1.644219))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.605771 1.547222 1.488673 1.430124 1.371576 1.313027))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.482003 0.423454 0.364905 0.306356 0.247808 1.789259))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.750811 1.692262 1.633713 1.575164 1.516616 1.458067))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.419619 1.361070 1.302521 1.243972 1.185424 1.126875))

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

#eval IO.println ("rot " ++ toString ((rot 1.709699 1.651150 1.592601).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.378507 1.319958 1.261409).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.047315 0.988766 0.930217).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 1.523547 1.464998 1.406449 1.347900).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 1.192355 1.133806 1.075257 1.016708).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.861163 0.802614 0.744065 0.685516).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.337395 1.278846 1.220297 1.161748 1.103200 1.044651 0.986102))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.006203 0.947654 0.889105 0.830556 0.772008 0.713459 0.654910))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.675011 0.616462 0.557913 0.499364 0.440816 0.382267 0.323718))

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

#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.151243 1.092694 1.034145 0.975596 0.917048 0.858499 0.799950 0.741401 0.682852 0.624304 0.565755 0.507206).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.820051 0.761502 0.702953 0.644404 0.585856 0.527307 0.468758 0.410209 0.351660 0.293112 0.234563 1.776014).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.488859 0.430310 0.371761 0.313212 0.254664 1.796115 1.737566 1.679017 1.620468 1.561920 1.503371 1.444822).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 0.965091 0.906542).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.633899 0.575350).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.302707 0.244158).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.778939 0.720390))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.447747 0.389198))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.716555 1.658006))

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

#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.220483 1.761934).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.489291 1.430742).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.158099 1.099550).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.634331 1.575782))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.303139 1.244590))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.971947 0.913398))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.448179 1.389630 1.331081).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.116987 1.058438 0.999889).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.785795 0.727246 0.668697).map Float.toBits))

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

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.262027 1.203478 1.144929 1.086380 1.027832 0.969283 0.910734 0.852185 0.793636))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.930835 0.872286 0.813737 0.755188 0.696640 0.638091 0.579542 0.520993 0.462444))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.599643 0.541094 0.482545 0.423996 0.365448 0.306899 0.248350 1.789801 1.731252))

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

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.075875 1.017326 0.958777))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.744683 0.686134 0.627585))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.413491 0.354942 0.296393))

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 0.889723 0.831174).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.558531 0.499982).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.227339 1.768790).toBits)

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

#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.558963))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.227771))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.896579))

def check_sigmoid_slope_le (x : Float) : Bool :=
  let v1 := (1.0 / (1.0 + Float.exp (-x)))
  ((v1 * ((1 : Float) - v1)) <= ((1 : Float) / (4 : Float)))

#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.372811))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.041619))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.710427))

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

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.000507 0.941958 0.883409 0.824860))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.669315 0.610766 0.552217 0.493668))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.338123 0.279574 0.221025 1.762476))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.814355 0.755806 0.697257 0.638708 0.580160))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.483163 0.424614 0.366065 0.307516 0.248968))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.751971 1.693422 1.634873 1.576324 1.517776))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 0.628203 0.569654 0.511105).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.297011 0.238462 1.779913).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 1.565819 1.507270 1.448721).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 0.442051 0.383502).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.710859 1.652310).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.379667 1.321118).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.669747 1.611198).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.338555 1.280006).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.007363 0.948814).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.483595 1.425046).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.152403 1.093854).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.821211 0.762662).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 1.297443 1.238894 1.180345).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 0.966251 0.907702 0.849153).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 0.635059 0.576510 0.517961).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.111291 1.052742).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.780099 0.721550).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.448907 0.390358).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.925139 0.866590 0.808041 0.749492 0.690944 0.632395 0.573846).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.593947 0.535398 0.476849 0.418300 0.359752 0.301203 0.242654).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.262755 0.204206 1.745657 1.687108 1.628560 1.570011 1.511462).map Float.toBits))

def spotTau  : Float :=
  (0.005 : Float)

#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.552835 0.494286 0.435737))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.221643 1.763094 1.704545))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.490451 1.431902 1.373353))

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

#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.780531 1.721982 1.663433 1.604884 1.546336 1.487787 1.429238 1.370689 1.312140 1.253592))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.449339 1.390790 1.332241 1.273692 1.215144 1.156595 1.098046 1.039497 0.980948 0.922400))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.118147 1.059598 1.001049 0.942500 0.883952 0.825403 0.766854 0.708305 0.649756 0.591208))

def check_steady_pot_le_abs (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v17 := (alpha * Pin)
  let v26 := (Toil - Ta)
  let v34 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= Ta) || (!(Ta <= Toil) || (!(feq (((v17 - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v26))) - (Upipe * v26)) - v34) (0 : Float)) || (v34 <= v17))))))))

#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.594379 1.535830 1.477281 1.418732 1.360184 1.301635 1.243086 1.184537 1.125988 1.067440))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.263187 1.204638 1.146089 1.087540 1.028992 0.970443 0.911894 0.853345 0.794796 0.736248))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.931995 0.873446 0.814897 0.756348 0.697800 0.639251 0.580702 0.522153 0.463604 0.405056))

def check_steady_unique (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T1 - Ta)
  let v42 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!((0 : Float) <= T2) || (!(feq (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T1 - Twall)))) (0 : Float)) || (!(feq (((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v42))) - (Upipe * v42)) - (max (0 : Float) (UAx * (T2 - Twall)))) (0 : Float)) || (feq T1 T2))))))))))

#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.408227 1.349678 1.291129 1.232580 1.174032 1.115483 1.056934 0.998385 0.939836 0.881288 0.822739))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.077035 1.018486 0.959937 0.901388 0.842840 0.784291 0.725742 0.667193 0.608644 0.550096 0.491547))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.745843 0.687294 0.628745 0.570196 0.511648 0.453099 0.394550 0.336001 0.277452 0.218904 1.760355))

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

#eval IO.println ("step " ++ toString ((step 1.222075 1.163526 1.104977 1.046428 0.987880 0.929331 0.870782 0.812233 0.753684 0.695136 0.636587 0.578038 0.519489 0.460940 0.402392 0.343843).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.890883 0.832334 0.773785 0.715236 0.656688 0.598139 0.539590 0.481041 0.422492 0.363944 0.305395 0.246846 1.788297 1.729748 1.671200 1.612651).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.559691 0.501142 0.442593 0.384044 0.325496 0.266947 0.208398 1.749849 1.691300 1.632752 1.574203 1.515654 1.457105 1.398556 1.340008 1.281459).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 0.849771 0.791222 0.732673 0.674124 0.615576 0.557027 0.498478 0.439929 0.381380).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.518579 0.460030 0.401481 0.342932 0.284384 0.225835 1.767286 1.708737 1.650188).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 1.787387 1.728838 1.670289 1.611740 1.553192 1.494643 1.436094 1.377545 1.318996).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.663619 0.605070 0.546521 0.487972 0.429424 0.370875 0.312326 0.253777 1.795228 1.736680))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.332427 0.273878 0.215329 1.756780 1.698232 1.639683 1.581134 1.522585 1.464036 1.405488))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.601235 1.542686 1.484137 1.425588 1.367040 1.308491 1.249942 1.191393 1.132844 1.074296))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 0.477467 0.418918).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.746275 1.687726).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.415083 1.356534).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.291315 0.232766 1.774217))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.560123 1.501574 1.443025))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.228931 1.170382 1.111833))

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

#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.705163 1.646614 1.588065 1.529516).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.373971 1.315422 1.256873 1.198324).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.042779 0.984230 0.925681 0.867132).map Float.toBits))

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

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.519011 1.460462 1.401913 1.343364 1.284816))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.187819 1.129270 1.070721 1.012172 0.953624))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.856627 0.798078 0.739529 0.680980 0.622432))

def sunReachableS (tDead : Float) (elSun : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))

#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.332859 1.274310).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.001667 0.943118).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.670475 0.611926).toBits)

def check_sunReachableS_mem (tDead : Float) (elSun : Float) : Bool :=
  let v10 := (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))
  (((0 : Float) <= v10) && (v10 <= (1 : Float)))

#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.146707 1.088158))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.815515 0.756966))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.484323 0.425774))

def check_sunReachableS_slope (tDead : Float) (e1 : Float) (e2 : Float) : Bool :=
  let v6 := (((3.141592653589793 : Float) / (2 : Float)) - tDead)
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((e1 - v6) / (0.01 : Float))))) - (1.0 / (1.0 + Float.exp (-((e2 - v6) / (0.01 : Float))))))) <= ((Float.abs (e1 - e2)) / ((4 : Float) * (0.01 : Float))))

#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.960555 0.902006 0.843457))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.629363 0.570814 0.512265))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.298171 0.239622 1.781073))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.774403 0.715854 0.657305 0.598756 0.540208).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.443211 0.384662 0.326113 0.267564 0.209016).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.712019 1.653470 1.594921 1.536372 1.477824).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.588251 0.529702 0.471153 0.412604 0.354056))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.257059 1.798510 1.739961 1.681412 1.622864))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.525867 1.467318 1.408769 1.350220 1.291672))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.402099).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.670907).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.339715).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.215947))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.484755))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.153563))

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

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.629795 1.571246 1.512697 1.454148 1.395600 1.337051).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.298603 1.240054 1.181505 1.122956 1.064408 1.005859).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.967411 0.908862 0.850313 0.791764 0.733216 0.674667).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.443643 1.385094).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.112451 1.053902).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.781259 0.722710).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.257491 1.198942 1.140393 1.081844).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.926299 0.867750 0.809201 0.750652).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.595107 0.536558 0.478009 0.419460).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.071339 1.012790 0.954241 0.895692).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.740147 0.681598 0.623049 0.564500).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.408955 0.350406 0.291857 0.233308).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.885187 0.826638 0.768089 0.709540))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.553995 0.495446 0.436897 0.378348))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.222803 1.764254 1.705705 1.647156))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.699035 0.640486 0.581937 0.523388 0.464840))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.367843 0.309294 0.250745 1.792196 1.733648))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.636651 1.578102 1.519553 1.461004 1.402456))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 0.512883 0.454334 0.395785).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.781691 1.723142 1.664593).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.450499 1.391950 1.333401).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.740579 1.682030 1.623481 1.564932 1.506384))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.409387 1.350838 1.292289 1.233740 1.175192))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.078195 1.019646 0.961097 0.902548 0.844000))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 1.554427 1.495878 1.437329 1.378780 1.320232).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.223235 1.164686 1.106137 1.047588 0.989040).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 0.892043 0.833494 0.774945 0.716396 0.657848).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.368275).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.037083).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.705891).toBits)

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

#eval IO.println ("traceConic " ++ toString ((traceConic 1.182123 1.123574 1.065025 1.006476 0.947928 0.889379 0.830830 0.772281 0.713732).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.850931 0.792382 0.733833 0.675284 0.616736 0.558187 0.499638 0.441089 0.382540).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.519739 0.461190 0.402641 0.344092 0.285544 0.226995 1.768446 1.709897 1.651348).map Float.toBits))

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

#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.995971 0.937422 0.878873 0.820324 0.761776 0.703227 0.644678 0.586129 0.527580 0.469032).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.664779 0.606230 0.547681 0.489132 0.430584 0.372035 0.313486 0.254937 1.796388 1.737840).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.333587 0.275038 0.216489 1.757940 1.699392 1.640843 1.582294 1.523745 1.465196 1.406648).map Float.toBits))

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

#eval IO.println ("traceRay " ++ toString ((traceRay 0.623667 0.565118 0.506569 0.448020 0.389472 0.330923 0.272374 0.213825 1.755276 1.696728 1.638179 1.579630).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 0.292475 0.233926 1.775377 1.716828 1.658280 1.599731 1.541182 1.482633 1.424084 1.365536 1.306987 1.248438).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.561283 1.502734 1.444185 1.385636 1.327088 1.268539 1.209990 1.151441 1.092892 1.034344 0.975795 0.917246).map Float.toBits))

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

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.437515 0.378966 0.320417 0.261868 0.203320 1.744771 1.686222 1.627673 1.569124 1.510576 1.452027 1.393478 1.334929 1.276380 1.217832 1.159283 1.100734 1.042185).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.706323 1.647774 1.589225 1.530676 1.472128 1.413579 1.355030 1.296481 1.237932 1.179384 1.120835 1.062286 1.003737 0.945188 0.886640 0.828091 0.769542 0.710993).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.375131 1.316582 1.258033 1.199484 1.140936 1.082387 1.023838 0.965289 0.906740 0.848192 0.789643 0.731094 0.672545 0.613996 0.555448 0.496899 0.438350 0.379801).map Float.toBits))

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

#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.251363 1.792814 1.734265 1.675716 1.617168 1.558619 1.500070 1.441521 1.382972 1.324424 1.265875 1.207326 1.148777).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.520171 1.461622 1.403073 1.344524 1.285976 1.227427 1.168878 1.110329 1.051780 0.993232 0.934683 0.876134 0.817585).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.188979 1.130430 1.071881 1.013332 0.954784 0.896235 0.837686 0.779137 0.720588 0.662040 0.603491 0.544942 0.486393).map Float.toBits))

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

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.665211 1.606662 1.548113 1.489564 1.431016 1.372467 1.313918 1.255369 1.196820 1.138272 1.079723 1.021174 0.962625 0.904076 0.845528 0.786979 0.728430 0.669881 0.611332).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.334019 1.275470 1.216921 1.158372 1.099824 1.041275 0.982726 0.924177 0.865628 0.807080 0.748531 0.689982 0.631433 0.572884 0.514336 0.455787 0.397238 0.338689 0.280140).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.002827 0.944278 0.885729 0.827180 0.768632 0.710083 0.651534 0.592985 0.534436 0.475888 0.417339 0.358790 0.300241 0.241692 1.783144 1.724595 1.666046 1.607497 1.548948).map Float.toBits))

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

#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.479059 1.420510 1.361961 1.303412 1.244864 1.186315 1.127766 1.069217).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.147867 1.089318 1.030769 0.972220 0.913672 0.855123 0.796574 0.738025).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.816675 0.758126 0.699577 0.641028 0.582480 0.523931 0.465382 0.406833).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.292907 1.234358 1.175809))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.961715 0.903166 0.844617))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.630523 0.571974 0.513425))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.106755))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.775563))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.444371))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.920603 0.862054 0.803505 0.744956))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.589411 0.530862 0.472313 0.413764))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.258219 1.799670 1.741121 1.682572))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 0.734451 0.675902 0.617353).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 0.403259 0.344710 0.286161).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.672067 1.613518 1.554969).map Float.toBits))

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 0.548299 0.489750 0.431201 0.372652 0.314104 0.255555).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.217107 1.758558 1.700009 1.641460 1.582912 1.524363).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.485915 1.427366 1.368817 1.310268 1.251720 1.193171).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 0.362147 0.303598 0.245049 1.786500 1.727952 1.669403).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.630955 1.572406 1.513857 1.455308 1.396760 1.338211).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.299763 1.241214 1.182665 1.124116 1.065568 1.007019).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 1.775995 1.717446 1.658897 1.600348 1.541800 1.483251 1.424702 1.366153 1.307604 1.249056 1.190507 1.131958 1.073409).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.444803 1.386254 1.327705 1.269156 1.210608 1.152059 1.093510 1.034961 0.976412 0.917864 0.859315 0.800766 0.742217).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.113611 1.055062 0.996513 0.937964 0.879416 0.820867 0.762318 0.703769 0.645220 0.586672 0.528123 0.469574 0.411025).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 1.589843 1.531294 1.472745 1.414196 1.355648 1.297099 1.238550 1.180001 1.121452 1.062904 1.004355 0.945806).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 1.258651 1.200102 1.141553 1.083004 1.024456 0.965907 0.907358 0.848809 0.790260 0.731712 0.673163 0.614614).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.927459 0.868910 0.810361 0.751812 0.693264 0.634715 0.576166 0.517617 0.459068 0.400520 0.341971 0.283422).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.403691 1.345142 1.286593 1.228044 1.169496 1.110947 1.052398 0.993849 0.935300 0.876752 0.818203 0.759654).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.072499 1.013950 0.955401 0.896852 0.838304 0.779755 0.721206 0.662657 0.604108 0.545560 0.487011 0.428462).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.741307 0.682758 0.624209 0.565660 0.507112 0.448563 0.390014 0.331465 0.272916 0.214368 1.755819 1.697270).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 1.217539 1.158990 1.100441 1.041892 0.983344 0.924795 0.866246 0.807697 0.749148 0.690600 0.632051 0.573502).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.886347 0.827798 0.769249 0.710700 0.652152 0.593603 0.535054 0.476505 0.417956 0.359408 0.300859 0.242310).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.555155 0.496606 0.438057 0.379508 0.320960 0.262411 0.203862 1.745313 1.686764 1.628216 1.569667 1.511118).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.031387 0.972838 0.914289 0.855740 0.797192 0.738643 0.680094 0.621545 0.562996 0.504448 0.445899 0.387350).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.700195 0.641646 0.583097 0.524548 0.466000 0.407451 0.348902 0.290353 0.231804 1.773256 1.714707 1.656158).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.369003 0.310454 0.251905 1.793356 1.734808 1.676259 1.617710 1.559161 1.500612 1.442064 1.383515 1.324966).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 0.845235 0.786686 0.728137 0.669588 0.611040 0.552491).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 0.514043 0.455494 0.396945 0.338396 0.279848 0.221299).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.782851 1.724302 1.665753 1.607204 1.548656 1.490107).map Float.toBits))

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

#eval IO.println ("wireLen " ++ toString (wireLen 0.472931 0.414382 0.355833 0.297284 0.238736).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.741739 1.683190 1.624641 1.566092 1.507544).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.410547 1.351998 1.293449 1.234900 1.176352).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 0.286779 0.228230 1.769681 1.711132).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.555587 1.497038 1.438489 1.379940).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.224395 1.165846 1.107297 1.048748).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.700627 1.642078 1.583529 1.524980 1.466432))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.369435 1.310886 1.252337 1.193788 1.135240))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.038243 0.979694 0.921145 0.862596 0.804048))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.514475 1.455926 1.397377 1.338828))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.183283 1.124734 1.066185 1.007636))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.852091 0.793542 0.734993 0.676444))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.328323 1.269774 1.211225 1.152676))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.997131 0.938582 0.880033 0.821484))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.665939 0.607390 0.548841 0.490292))

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

#eval IO.println ("wireTension " ++ toString (wireTension 0.769867 0.711318 0.652769 0.594220).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 0.438675 0.380126 0.321577 0.263028).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.707483 1.648934 1.590385 1.531836).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.583715 0.525166 0.466617 0.408068 0.349520 0.290971 0.232422 1.773873))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.252523 1.793974 1.735425 1.676876 1.618328 1.559779 1.501230 1.442681))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.521331 1.462782 1.404233 1.345684 1.287136 1.228587 1.170038 1.111489))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.211411 1.752862 1.694313 1.635764))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.480219 1.421670 1.363121 1.304572))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.149027 1.090478 1.031929 0.973380))

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.625259 1.566710 1.508161 1.449612 1.391064 1.332515).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.294067 1.235518 1.176969 1.118420 1.059872 1.001323).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.962875 0.904326 0.845777 0.787228 0.728680 0.670131).map Float.toBits))

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

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.066803 1.008254 0.949705))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.735611 0.677062 0.618513))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.404419 0.345870 0.287321))

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
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

def clearance (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (holeDown : Float) (reach : Float) : Float :=
  ((l_upright - holeDown) - reach)

#eval IO.println ("clearance " ++ toString (clearance 1.253827 1.195278 1.136729 1.078180 1.019632 0.961083 0.902534).toBits)
#eval IO.println ("clearance " ++ toString (clearance 0.922635 0.864086 0.805537 0.746988 0.688440 0.629891 0.571342).toBits)
#eval IO.println ("clearance " ++ toString (clearance 0.591443 0.532894 0.474345 0.415796 0.357248 0.298699 0.240150).toBits)

def check_clearance_hashemi (holeDown : Float) : Bool :=
  let v16 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v16) && (v16 < ((0.146 : Float) - holeDown)))

#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.067675))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.736483))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.405291))

def coilCapture (rs : Float) (rc : Float) (d : Float) : Float :=
  let v9 := (rs ^ 2)
  let v10 := (d ^ 2)
  let v12 := (rc ^ 2)
  let v15 := ((2 : Float) * d)
  let v30 := (d + rs)
  (if ((rs + rc) <= d) then (0 : Float) else (if (d <= (rc - rs)) then (1 : Float) else ((((v9 * (Float.acos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Float.acos (((v10 + v12) - v9) / (v15 * rc))))) - ((Float.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : Float))) / ((3.141592653589793 : Float) * v9))))

#eval IO.println ("coilCapture " ++ toString (coilCapture 0.881523 0.822974 0.764425).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 0.550331 0.491782 0.433233).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 0.219139 1.760590 1.702041).toBits)

def conicHitS (c : Float) (k : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Float :=
  let v9 := ((1 : Float) + k)
  let v27 := ((((2 : Float) * c) * (((O_0 * d_0) + (O_1 * d_1)) + ((v9 * O_2) * d_2))) - ((2 : Float) * d_2))
  let v36 := ((c * (((O_0 ^ 2) + (O_1 ^ 2)) + (v9 * (O_2 ^ 2)))) - ((2 : Float) * O_2))
  (((2 : Float) * v36) / ((-v27) - (Float.sqrt (max ((v27 ^ 2) - (((4 : Float) * (c * (((d_0 ^ 2) + (d_1 ^ 2)) + (v9 * (d_2 ^ 2))))) * v36)) (0 : Float)))))

#eval IO.println ("conicHitS " ++ toString (conicHitS 0.695371 0.636822 0.578273 0.519724 0.461176 0.402627 0.344078 0.285529).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 0.364179 0.305630 0.247081 1.788532 1.729984 1.671435 1.612886 1.554337).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 1.632987 1.574438 1.515889 1.457340 1.398792 1.340243 1.281694 1.223145).toBits)

def conicSlope (c : Float) (k : Float) (r : Float) : Float :=
  ((c * r) / (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : Float))))

#eval IO.println ("conicSlope " ++ toString (conicSlope 0.509219 0.450670 0.392121).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.778027 1.719478 1.660929).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 1.446835 1.388286 1.329737).toBits)

def conicZ (c : Float) (k : Float) (r : Float) : Float :=
  let v3 := (r ^ 2)
  ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * v3)) (0 : Float)))))

#eval IO.println ("conicZ " ++ toString (conicZ 0.323067 0.264518 0.205969).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 1.591875 1.533326 1.474777).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 1.260683 1.202134 1.143585).toBits)

def check_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.736915 1.678366))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.405723 1.347174))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.074531 1.015982))

def check_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v4 := (c ^ 2)
  let v5 := (r ^ 2)
  let v18 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v4 * v5) <= (1 : Float)) || (feq ((c * v5) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v4) * v5)) (0 : Float))))) (v18 - (Float.sqrt ((v18 ^ 2) - v5))))))

#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.550763 1.492214))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.219571 1.161022))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.888379 0.829830))

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

#eval IO.println ("constraints " ++ toString ((constraints 1.364611 1.306062 1.247513 1.188964 1.130416 1.071867 1.013318 0.954769 0.896220 0.837672 0.779123 0.720574).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 1.033419 0.974870 0.916321 0.857772 0.799224 0.740675 0.682126 0.623577 0.565028 0.506480 0.447931 0.389382).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 0.702227 0.643678 0.585129 0.526580 0.468032 0.409483 0.350934 0.292385 0.233836 1.775288 1.716739 1.658190).map Float.toBits))

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

#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.178459 1.119910 1.061361 1.002812 0.944264 0.885715 0.827166 0.768617 0.710068 0.651520 0.592971 0.534422).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.847267 0.788718 0.730169 0.671620 0.613072 0.554523 0.495974 0.437425 0.378876 0.320328 0.261779 0.203230).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.516075 0.457526 0.398977 0.340428 0.281880 0.223331 1.764782 1.706233 1.647684 1.589136 1.530587 1.472038).map Float.toBits))

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

#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.992307 0.933758 0.875209 0.816660 0.758112 0.699563 0.641014 0.582465 0.523916 0.465368 0.406819 0.348270))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.661115 0.602566 0.544017 0.485468 0.426920 0.368371 0.309822 0.251273 1.792724 1.734176 1.675627 1.617078))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.329923 0.271374 0.212825 1.754276 1.695728 1.637179 1.578630 1.520081 1.461532 1.402984 1.344435 1.285886))

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

#eval IO.println ("cross3 " ++ toString ((cross3 0.433851 0.375302 0.316753 0.258204 1.799656 1.741107).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 1.702659 1.644110 1.585561 1.527012 1.468464 1.409915).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 1.371467 1.312918 1.254369 1.195820 1.137272 1.078723).map Float.toBits))

def deadPoint (ym : Float) (hp : Float) (a : Float) (ze : Float) : Float :=
  let v4 := (ym * a)
  let v5 := (hp * ze)
  (if (v4 <= v5) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v4 - v5))))

#eval IO.println ("deadPoint " ++ toString (deadPoint 0.247699 1.789150 1.730601 1.672052).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.516507 1.457958 1.399409 1.340860).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.185315 1.126766 1.068217 1.009668).toBits)

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

#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.289243 1.230694).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.958051 0.899502).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.626859 0.568310).map Float.toBits))

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

#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.103091 1.044542 0.985993))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.771899 0.713350 0.654801))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.440707 0.382158 0.323609))

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
  let v265 := ((0 : Float) < v253)
  let v266 := (((Float.sqrt ((((v161 + (v222 * v137)) + (v255 * (v242 / v250))) ^ 2) + (((v162 + (v222 * v143)) + (v255 * (v244 / v250))) ^ 2))) <= rc) && v265)
  #[(if (v160 && v266) then (1 : Float) else (0 : Float)), (((v64 ^ 2) * rho) * (if (v160 && v266) then (1 : Float) else (0 : Float))), (if (!v160) then (0 : Float) else (if v266 then (2 : Float) else (1 : Float)))]

#eval IO.println ("dishPower " ++ toString ((dishPower 0.544635 0.486086 0.427537 0.368988 0.310440 0.251891 1.793342 1.734793 1.676244 1.617696 1.559147 1.500598 1.442049 1.383500 1.324952 1.266403 1.207854 1.149305 1.090756 1.032208 0.973659 0.915110 0.856561 0.798012).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 0.213443 1.754894 1.696345 1.637796 1.579248 1.520699 1.462150 1.403601 1.345052 1.286504 1.227955 1.169406 1.110857 1.052308 0.993760 0.935211 0.876662 0.818113 0.759564 0.701016 0.642467 0.583918 0.525369 0.466820).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.482251 1.423702 1.365153 1.306604 1.248056 1.189507 1.130958 1.072409 1.013860 0.955312 0.896763 0.838214 0.779665 0.721116 0.662568 0.604019 0.545470 0.486921 0.428372 0.369824 0.311275 0.252726 1.794177 1.735628).map Float.toBits))

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
  let v265 := ((0 : Float) < v253)
  let v266 := (((Float.sqrt ((((v161 + (v222 * v137)) + (v255 * (v242 / v250))) ^ 2) + (((v162 + (v222 * v143)) + (v255 * (v244 / v250))) ^ 2))) <= rc) && v265)
  let v268 := (if (v160 && v266) then (1 : Float) else (0 : Float))
  ((feq v268 (0 : Float)) || (feq v268 (1 : Float)))

#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.358483 0.299934 0.241385 1.782836 1.724288 1.665739 1.607190 1.548641 1.490092 1.431544 1.372995 1.314446 1.255897 1.197348 1.138800 1.080251 1.021702 0.963153 0.904604 0.846056 0.787507 0.728958 0.670409 0.611860))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.627291 1.568742 1.510193 1.451644 1.393096 1.334547 1.275998 1.217449 1.158900 1.100352 1.041803 0.983254 0.924705 0.866156 0.807608 0.749059 0.690510 0.631961 0.573412 0.514864 0.456315 0.397766 0.339217 0.280668))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.296099 1.237550 1.179001 1.120452 1.061904 1.003355 0.944806 0.886257 0.827708 0.769160 0.710611 0.652062 0.593513 0.534964 0.476416 0.417867 0.359318 0.300769 0.242220 1.783672 1.725123 1.666574 1.608025 1.549476))

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
  let v266 := ((0 : Float) < v254)
  let v267 := (((Float.sqrt ((((v162 + (v223 * v138)) + (v256 * (v243 / v251))) ^ 2) + (((v163 + (v223 * v144)) + (v256 * (v245 / v251))) ^ 2))) <= rc) && v266)
  let v275 := ((v66 ^ 2) * rho)
  (!((0 : Float) <= rho) || ((v275 * (if (v161 && v267) then (1 : Float) else (0 : Float))) <= v275))

#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.772331 1.713782 1.655233 1.596684 1.538136 1.479587 1.421038 1.362489 1.303940 1.245392 1.186843 1.128294 1.069745 1.011196 0.952648 0.894099 0.835550 0.777001 0.718452 0.659904 0.601355 0.542806 0.484257 0.425708))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.441139 1.382590 1.324041 1.265492 1.206944 1.148395 1.089846 1.031297 0.972748 0.914200 0.855651 0.797102 0.738553 0.680004 0.621456 0.562907 0.504358 0.445809 0.387260 0.328712 0.270163 0.211614 1.753065 1.694516))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 1.109947 1.051398 0.992849 0.934300 0.875752 0.817203 0.758654 0.700105 0.641556 0.583008 0.524459 0.465910 0.407361 0.348812 0.290264 0.231715 1.773166 1.714617 1.656068 1.597520 1.538971 1.480422 1.421873 1.363324))

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

#eval IO.println ("dot3 " ++ toString (dot3 0.841571 0.783022 0.724473 0.665924 0.607376 0.548827).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 0.510379 0.451830 0.393281 0.334732 0.276184 0.217635).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.779187 1.720638 1.662089 1.603540 1.544992 1.486443).toBits)

def check_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v21 := (Float.sqrt ((v16 ^ 2) + (c_apexH ^ 2)))
  let v23 := (-((F * v16) / v21))
  let v25 := ((F * c_apexH) / v21)
  (feq (((((((0 : Float) * ((v16 * (0 : Float)) - (b_zRail * v25))) + ((0 : Float) * ((b_zRail * v23) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v25) - (v16 * v23)))) + ((0 : Float) * v23)) + ((0 : Float) * v25)) + ((0 : Float) * (0 : Float))) (F * v21))

#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.655419 0.596870 0.538321 0.479772 0.421224 0.362675 0.304126 0.245577 1.787028 1.728480 1.669931 1.611382 1.552833))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.324227 0.265678 0.207129 1.748580 1.690032 1.631483 1.572934 1.514385 1.455836 1.397288 1.338739 1.280190 1.221641))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.593035 1.534486 1.475937 1.417388 1.358840 1.300291 1.241742 1.183193 1.124644 1.066096 1.007547 0.948998 0.890449))

def check_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v17 := (c_chord / (2 : Float))
  let v22 := (Float.sqrt ((v17 ^ 2) + (c_apexH ^ 2)))
  let v24 := (-((F * v17) / v22))
  let v26 := ((F * c_apexH) / v22)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v17 * (0 : Float)) - (b_zRail * v26))) + ((0 : Float) * ((b_zRail * v24) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v26) - (v17 * v24)))) + ((0 : Float) * v24)) + ((0 : Float) * v26)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.469267 0.410718 0.352169 0.293620 0.235072 1.776523 1.717974 1.659425 1.600876 1.542328 1.483779 1.425230 1.366681))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.738075 1.679526 1.620977 1.562428 1.503880 1.445331 1.386782 1.328233 1.269684 1.211136 1.152587 1.094038 1.035489))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.406883 1.348334 1.289785 1.231236 1.172688 1.114139 1.055590 0.997041 0.938492 0.879944 0.821395 0.762846 0.704297))

def edgeClipAt (a : Float) (ze : Float) (t : Float) : Array Float :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  #[((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))]

#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.283115 0.224566 1.766017).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.551923 1.493374 1.434825).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.220731 1.162182 1.103633).map Float.toBits))

def check_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (feq (((-ym) * (((-v6) * v10) + (v9 * v7))) - (hp * ((v6 * v7) + (v9 * v10)))) ((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)))

#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.696963 1.638414 1.579865 1.521316 1.462768))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.365771 1.307222 1.248673 1.190124 1.131576))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.034579 0.976030 0.917481 0.858932 0.800384))

def check_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  (feq ((((v3 * v4) + (v6 * v7)) ^ 2) + ((((-v3) * v7) + (v6 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.510811 1.452262 1.393713))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.179619 1.121070 1.062521))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.848427 0.789878 0.731329))

def check_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v6 := (Float.sqrt (3.36 : Float))
  let v9 := (-(v6 - (1 : Float)))
  let v10 := (Float.sin t)
  (feq ((((v2 * v3) + (v9 * v10)) ^ 2) + ((((-v2) * v10) + (v9 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v6)))

#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.324659))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.993467))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.662275))

def check_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  ((Float.abs ((v3 * v4) + (v6 * v7))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.138507 1.079958 1.021409))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.807315 0.748766 0.690217))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.476123 0.417574 0.359025))

def edgeDepth (f : Float) (a : Float) (sag : Float) (el : Float) : Float :=
  (((f - sag) * (Float.sin el)) + (a * (Float.cos el)))

#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.952355 0.893806 0.835257 0.776708).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.621163 0.562614 0.504065 0.445516).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 0.289971 0.231422 1.772873 1.714324).toBits)

def check_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.766203 0.707654 0.649105))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.435011 0.376462 0.317913))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.703819 1.645270 1.586721))

def check_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.580051 0.521502 0.462953 0.404404))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.248859 1.790310 1.731761 1.673212))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.517667 1.459118 1.400569 1.342020))

def check_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.393899 0.335350 0.276801))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.662707 1.604158 1.545609))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.331515 1.272966 1.214417))

def check_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v10 := (Float.cos t)
  let v17 := (-a)
  let v19 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v10 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v17) * v5) + (v19 * v10))) - (hp * ((v17 * v10) + (v19 * v5)))) (0 : Float)))

#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.207747 1.749198 1.690649 1.632100 1.573552))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.476555 1.418006 1.359457 1.300908 1.242360))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 1.145363 1.086814 1.028265 0.969716 0.911168))

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

#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.621595 1.563046 1.504497 1.445948 1.387400))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.290403 1.231854 1.173305 1.114756 1.056208))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.959211 0.900662 0.842113 0.783564 0.725016))

def elPower (W : Float) (rcm : Float) (t : Float) (omega : Float) : Float :=
  (((W * rcm) * (Float.sin t)) * omega)

#eval IO.println ("elPower " ++ toString (elPower 1.435443 1.376894 1.318345 1.259796).toBits)
#eval IO.println ("elPower " ++ toString (elPower 1.104251 1.045702 0.987153 0.928604).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.773059 0.714510 0.655961 0.597412).toBits)

def check_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v9 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v9 / rw) * (rw * omega)) (v9 * omega)))

#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 1.249291 1.190742 1.132193 1.073644 1.015096))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.918099 0.859550 0.801001 0.742452 0.683904))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.586907 0.528358 0.469809 0.411260 0.352712))

def check_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v8 * (Float.sin t)) * omega) <= (v8 * omega)))))

#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.063139 1.004590 0.946041 0.887492))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.731947 0.673398 0.614849 0.556300))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.400755 0.342206 0.283657 0.225108))

def elRate (omegad : Float) (rDrum : Float) (rw : Float) : Float :=
  ((omegad * rDrum) / rw)

#eval IO.println ("elRate " ++ toString (elRate 0.876987 0.818438 0.759889).toBits)
#eval IO.println ("elRate " ++ toString (elRate 0.545795 0.487246 0.428697).toBits)
#eval IO.println ("elRate " ++ toString (elRate 0.214603 1.756054 1.697505).toBits)

def facetSpot (w : Float) (f : Float) : Float :=
  (w + (f * (0.0093 : Float)))

#eval IO.println ("facetSpot " ++ toString (facetSpot 0.690835 0.632286).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 0.359643 0.301094).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.628451 1.569902).toBits)

def check_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))

def focusShift (h : Float) (eps : Float) : Float :=
  (h * (Float.sin eps))

#eval IO.println ("focusShift " ++ toString (focusShift 0.318531 0.259982).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.587339 1.528790).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.256147 1.197598).toBits)

def check_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v1 := (Float.cos psi)
  let v7 := (Float.sin psi)
  (!(!(feq v1 (1 : Float))) || (!((feq ((v1 * p_1) - (v7 * p_2)) p_1) && (feq ((v7 * p_1) + (v1 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.732379 1.673830 1.615281))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.401187 1.342638 1.284089))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.069995 1.011446 0.952897))

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

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.546227 1.487678 1.429129 1.370580 1.312032 1.253483 1.194934 1.136385 1.077836 1.019288 0.960739 0.902190))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.215035 1.156486 1.097937 1.039388 0.980840 0.922291 0.863742 0.805193 0.746644 0.688096 0.629547 0.570998))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.883843 0.825294 0.766745 0.708196 0.649648 0.591099 0.532550 0.474001 0.415452 0.356904 0.298355 0.239806))

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

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.360075 1.301526 1.242977 1.184428 1.125880 1.067331 1.008782 0.950233 0.891684 0.833136 0.774587 0.716038))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.028883 0.970334 0.911785 0.853236 0.794688 0.736139 0.677590 0.619041 0.560492 0.501944 0.443395 0.384846))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.697691 0.639142 0.580593 0.522044 0.463496 0.404947 0.346398 0.287849 0.229300 1.770752 1.712203 1.653654))

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

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.173923 1.115374 1.056825 0.998276 0.939728 0.881179 0.822630 0.764081 0.705532 0.646984 0.588435 0.529886))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.842731 0.784182 0.725633 0.667084 0.608536 0.549987 0.491438 0.432889 0.374340 0.315792 0.257243 1.798694))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.511539 0.452990 0.394441 0.335892 0.277344 0.218795 1.760246 1.701697 1.643148 1.584600 1.526051 1.467502))

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 0.801619 0.743070 0.684521 0.625972).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 0.470427 0.411878 0.353329 0.294780).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.739235 1.680686 1.622137 1.563588).toBits)

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

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.395491 1.336942).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.064299 1.005750).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.733107 0.674558).toBits)

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

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.023187 0.964638).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.691995 0.633446).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.360803 0.302254).map Float.toBits))

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

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.837035 0.778486 0.719937 0.661388 0.602840 0.544291 0.485742 0.427193))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.505843 0.447294 0.388745 0.330196 0.271648 0.213099 1.754550 1.696001))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.774651 1.716102 1.657553 1.599004 1.540456 1.481907 1.423358 1.364809))

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

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.650883 0.592334 0.533785 0.475236 0.416688 0.358139 0.299590 0.241041 1.782492))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.319691 0.261142 0.202593 1.744044 1.685496 1.626947 1.568398 1.509849 1.451300))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.588499 1.529950 1.471401 1.412852 1.354304 1.295755 1.237206 1.178657 1.120108))

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

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.464731 0.406182 0.347633))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.733539 1.674990 1.616441))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.402347 1.343798 1.285249))

def hpHashemi  : Float :=
  (0.34 : Float)

#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)
#eval IO.println ("hpHashemi " ++ toString (hpHashemi).toBits)

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 1.692427 1.633878 1.575329 1.516780 1.458232 1.399683 1.341134).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 1.361235 1.302686 1.244137 1.185588 1.127040 1.068491 1.009942).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 1.030043 0.971494 0.912945 0.854396 0.795848 0.737299 0.678750).map Float.toBits))

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

#eval IO.println ("leverAt " ++ toString (leverAt 1.320123 1.261574 1.203025 1.144476 1.085928).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.988931 0.930382 0.871833 0.813284 0.754736).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.657739 0.599190 0.540641 0.482092 0.423544).toBits)

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

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.133971 1.075422 1.016873 0.958324 0.899776 0.841227))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.802779 0.744230 0.685681 0.627132 0.568584 0.510035))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.471587 0.413038 0.354489 0.295940 0.237392 1.778843))

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

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.947819 0.889270 0.830721 0.772172 0.713624 0.655075))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.616627 0.558078 0.499529 0.440980 0.382432 0.323883))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.285435 0.226886 1.768337 1.709788 1.651240 1.592691))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.575515))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.244323))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.513131))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.203211))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.472019))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.140827))

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

#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.244755 1.186206 1.127657 1.069108 1.010560 0.952011 0.893462 0.834913 0.776364 0.717816 0.659267 0.600718 0.542169 0.483620 0.425072 0.366523 0.307974).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.913563 0.855014 0.796465 0.737916 0.679368 0.620819 0.562270 0.503721 0.445172 0.386624 0.328075 0.269526 0.210977 1.752428 1.693880 1.635331 1.576782).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.582371 0.523822 0.465273 0.406724 0.348176 0.289627 0.231078 1.772529 1.713980 1.655432 1.596883 1.538334 1.479785 1.421236 1.362688 1.304139 1.245590).map Float.toBits))

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

#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.872451 0.813902 0.755353 0.696804 0.638256 0.579707 0.521158 0.462609 0.404060 0.345512 0.286963 0.228414 1.769865 1.711316 1.652768 1.594219 1.535670).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.541259 0.482710 0.424161 0.365612 0.307064 0.248515 1.789966 1.731417 1.672868 1.614320 1.555771 1.497222 1.438673 1.380124 1.321576 1.263027 1.204478).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.210067 1.751518 1.692969 1.634420 1.575872 1.517323 1.458774 1.400225 1.341676 1.283128 1.224579 1.166030 1.107481 1.048932 0.990384 0.931835 0.873286).map Float.toBits))

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

#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.686299 0.627750 0.569201 0.510652 0.452104 0.393555 0.335006 0.276457 0.217908 1.759360 1.700811 1.642262 1.583713 1.525164 1.466616 1.408067 1.349518).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.355107 0.296558 0.238009 1.779460 1.720912 1.662363 1.603814 1.545265 1.486716 1.428168 1.369619 1.311070 1.252521 1.193972 1.135424 1.076875 1.018326).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.623915 1.565366 1.506817 1.448268 1.389720 1.331171 1.272622 1.214073 1.155524 1.096976 1.038427 0.979878 0.921329 0.862780 0.804232 0.745683 0.687134).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.500147 0.441598 0.383049).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.768955 1.710406 1.651857).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.437763 1.379214 1.320665).toBits)

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
  let v670 := ((v43 - v50) <= elSun)
  #[(az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt)), v592, (if v103 then (v101 - v69) else (0 : Float)), (if v591 then v97 else v105), v50, (if (v102 || v591) then (1 : Float) else (0 : Float)), (if (feq (if v103 then (v101 - v69) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v568 <= (Tmax * (((v51 * v609) - ((0.34 : Float) * v606)) / (Float.sqrt (((v606 - v51) ^ 2) + ((v609 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (((v51 * v91) - ((0.34 : Float) * v88)) / v97), (v99 / (((v51 * v91) - ((0.34 : Float) * v88)) / v97)), ((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))), (if (v642 <= (0 : Float)) then (v43 + (Float.atan ((-v642) / (max v657 (0.000000000001 : Float))))) else (Float.atan (v657 / v642))), (v43 - t), (if v670 then (1 : Float) else (0 : Float)), (if (v670 && ((0.03 : Float) < (if (v642 <= (0 : Float)) then (v43 + (Float.atan ((-v642) / (max v657 (0.000000000001 : Float))))) else (Float.atan (v657 / v642))))) then (1 : Float) else (0 : Float))]

#eval IO.println ("megaStep " ++ toString ((megaStep 0.313995 0.255446 1.796897 1.738348 1.679800 1.621251 1.562702 1.504153 1.445604 1.387056 1.328507 1.269958 1.211409 1.152860 1.094312 1.035763 0.977214).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.582803 1.524254 1.465705 1.407156 1.348608 1.290059 1.231510 1.172961 1.114412 1.055864 0.997315 0.938766 0.880217 0.821668 0.763120 0.704571 0.646022).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.251611 1.193062 1.134513 1.075964 1.017416 0.958867 0.900318 0.841769 0.783220 0.724672 0.666123 0.607574 0.549025 0.490476 0.431928 0.373379 0.314830).map Float.toBits))

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

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.727843 1.669294 1.610745 1.552196 1.493648 1.435099 1.376550 1.318001 1.259452 1.200904 1.142355 1.083806 1.025257 0.966708 0.908160 0.849611 0.791062).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.396651 1.338102 1.279553 1.221004 1.162456 1.103907 1.045358 0.986809 0.928260 0.869712 0.811163 0.752614 0.694065 0.635516 0.576968 0.518419 0.459870).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.065459 1.006910 0.948361 0.889812 0.831264 0.772715 0.714166 0.655617 0.597068 0.538520 0.479971 0.421422 0.362873 0.304324 0.245776 1.787227 1.728678).map Float.toBits))

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

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.541691 1.483142 1.424593 1.366044 1.307496 1.248947 1.190398 1.131849 1.073300 1.014752 0.956203 0.897654 0.839105 0.780556 0.722008 0.663459 0.604910).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.210499 1.151950 1.093401 1.034852 0.976304 0.917755 0.859206 0.800657 0.742108 0.683560 0.625011 0.566462 0.507913 0.449364 0.390816 0.332267 0.273718).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.879307 0.820758 0.762209 0.703660 0.645112 0.586563 0.528014 0.469465 0.410916 0.352368 0.293819 0.235270 1.776721 1.718172 1.659624 1.601075 1.542526).map Float.toBits))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.355539 1.296990 1.238441 1.179892 1.121344 1.062795))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.024347 0.965798 0.907249 0.848700 0.790152 0.731603))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.693155 0.634606 0.576057 0.517508 0.458960 0.400411))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.169387 1.110838 1.052289 0.993740 0.935192 0.876643))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.838195 0.779646 0.721097 0.662548 0.604000 0.545451))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.507003 0.448454 0.389905 0.331356 0.272808 0.214259))

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

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.610931 0.552382 0.493833 0.435284))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.279739 0.221190 1.762641 1.704092))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.548547 1.489998 1.431449 1.372900))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.424779))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.693587))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.362395))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 0.238627 1.780078 1.721529 1.662980 1.604432 1.545883 1.487334 1.428785 1.370236).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 1.507435 1.448886 1.390337 1.331788 1.273240 1.214691 1.156142 1.097593 1.039044).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 1.176243 1.117694 1.059145 1.000596 0.942048 0.883499 0.824950 0.766401 0.707852).map Float.toBits))

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

#eval IO.println ("pointingError " ++ toString (pointingError 1.652475 1.593926 1.535377 1.476828).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 1.321283 1.262734 1.204185 1.145636).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.990091 0.931542 0.872993 0.814444).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 1.466323 1.407774 1.349225 1.290676 1.232128 1.173579 1.115030 1.056481 0.997932 0.939384 0.880835 0.822286 0.763737).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.135131 1.076582 1.018033 0.959484 0.900936 0.842387 0.783838 0.725289 0.666740 0.608192 0.549643 0.491094 0.432545).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 0.803939 0.745390 0.686841 0.628292 0.569744 0.511195 0.452646 0.394097 0.335548 0.277000 0.218451 1.759902 1.701353).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.280171 1.221622 1.163073 1.104524 1.045976 0.987427 0.928878 0.870329 0.811780 0.753232 0.694683 0.636134))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.948979 0.890430 0.831881 0.773332 0.714784 0.656235 0.597686 0.539137 0.480588 0.422040 0.363491 0.304942))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.617787 0.559238 0.500689 0.442140 0.383592 0.325043 0.266494 0.207945 1.749396 1.690848 1.632299 1.573750))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.094019 1.035470 0.976921 0.918372 0.859824 0.801275 0.742726 0.684177 0.625628 0.567080 0.508531 0.449982))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.762827 0.704278 0.645729 0.587180 0.528632 0.470083 0.411534 0.352985 0.294436 0.235888 1.777339 1.718790))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.431635 0.373086 0.314537 0.255988 1.797440 1.738891 1.680342 1.621793 1.563244 1.504696 1.446147 1.387598))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.907867 0.849318 0.790769 0.732220 0.673672 0.615123 0.556574 0.498025 0.439476 0.380928 0.322379 0.263830))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.576675 0.518126 0.459577 0.401028 0.342480 0.283931 0.225382 1.766833 1.708284 1.649736 1.591187 1.532638))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.245483 1.786934 1.728385 1.669836 1.611288 1.552739 1.494190 1.435641 1.377092 1.318544 1.259995 1.201446))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.721715 0.663166 0.604617 0.546068 0.487520 0.428971 0.370422 0.311873 0.253324 1.794776 1.736227 1.677678 1.619129))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.390523 0.331974 0.273425 0.214876 1.756328 1.697779 1.639230 1.580681 1.522132 1.463584 1.405035 1.346486 1.287937))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.659331 1.600782 1.542233 1.483684 1.425136 1.366587 1.308038 1.249489 1.190940 1.132392 1.073843 1.015294 0.956745))

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

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.832499 0.773950 0.715401))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.501307 0.442758 0.384209))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.770115 1.711566 1.653017))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.646347))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.315155))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.583963))

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

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.501739 1.443190))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.170547 1.111998))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.839355 0.780806))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.315587))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.984395))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.653203))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.129435 1.070886))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.798243 0.739694))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.467051 0.408502))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.943283 0.884734))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.612091 0.553542))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.280899 0.222350))

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

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.757131 0.698582 0.640033 0.581484 0.522936 0.464387 0.405838 0.347289 0.288740 0.230192 1.771643 1.713094))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.425939 0.367390 0.308841 0.250292 1.791744 1.733195 1.674646 1.616097 1.557548 1.499000 1.440451 1.381902))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.694747 1.636198 1.577649 1.519100 1.460552 1.402003 1.343454 1.284905 1.226356 1.167808 1.109259 1.050710))

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

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.612523 1.553974 1.495425))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.281331 1.222782 1.164233))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.950139 0.891590 0.833041))

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

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.054067 0.995518 0.936969 0.878420 0.819872 0.761323 0.702774 0.644225 0.585676 0.527128 0.468579 0.410030 0.351481))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.722875 0.664326 0.605777 0.547228 0.488680 0.430131 0.371582 0.313033 0.254484 1.795936 1.737387 1.678838 1.620289))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.391683 0.333134 0.274585 0.216036 1.757488 1.698939 1.640390 1.581841 1.523292 1.464744 1.406195 1.347646 1.289097))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.867915 0.809366 0.750817 0.692268 0.633720 0.575171 0.516622 0.458073 0.399524 0.340976 0.282427 0.223878 1.765329))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.536723 0.478174 0.419625 0.361076 0.302528 0.243979 1.785430 1.726881 1.668332 1.609784 1.551235 1.492686 1.434137))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.205531 1.746982 1.688433 1.629884 1.571336 1.512787 1.454238 1.395689 1.337140 1.278592 1.220043 1.161494 1.102945))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.681763 0.623214 0.564665 0.506116 0.447568))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.350571 0.292022 0.233473 1.774924 1.716376))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.619379 1.560830 1.502281 1.443732 1.385184))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.495611 0.437062 0.378513))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.764419 1.705870 1.647321))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.433227 1.374678 1.316129))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.309459))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.578267))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.247075))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.723307 1.664758 1.606209))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.392115 1.333566 1.275017))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.060923 1.002374 0.943825))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.537155 1.478606 1.420057))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.205963 1.147414 1.088865))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.874771 0.816222 0.757673))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.351003 1.292454 1.233905 1.175356))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.019811 0.961262 0.902713 0.844164))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.688619 0.630070 0.571521 0.512972))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.164851 1.106302 1.047753))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.833659 0.775110 0.716561))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.502467 0.443918 0.385369))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.978699 0.920150 0.861601 0.803052 0.744504))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.647507 0.588958 0.530409 0.471860 0.413312))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.316315 0.257766 1.799217 1.740668 1.682120))

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

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.792547 0.733998 0.675449 0.616900 0.558352))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.461355 0.402806 0.344257 0.285708 0.227160))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.730163 1.671614 1.613065 1.554516 1.495968))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.606395 0.547846 0.489297 0.430748 0.372200))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.275203 0.216654 1.758105 1.699556 1.641008))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.544011 1.485462 1.426913 1.368364 1.309816))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.420243 0.361694 0.303145 0.244596))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.689051 1.630502 1.571953 1.513404))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.357859 1.299310 1.240761 1.182212))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.647939 1.589390 1.530841))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.316747 1.258198 1.199649))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.985555 0.927006 0.868457))

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

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.461787 1.403238 1.344689 1.286140 1.227592 1.169043 1.110494 1.051945 0.993396 0.934848 0.876299 0.817750))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.130595 1.072046 1.013497 0.954948 0.896400 0.837851 0.779302 0.720753 0.662204 0.603656 0.545107 0.486558))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.799403 0.740854 0.682305 0.623756 0.565208 0.506659 0.448110 0.389561 0.331012 0.272464 0.213915 1.755366))

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

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.275635 1.217086 1.158537 1.099988 1.041440 0.982891 0.924342 0.865793 0.807244 0.748696 0.690147 0.631598))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.944443 0.885894 0.827345 0.768796 0.710248 0.651699 0.593150 0.534601 0.476052 0.417504 0.358955 0.300406))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.613251 0.554702 0.496153 0.437604 0.379056 0.320507 0.261958 0.203409 1.744860 1.686312 1.627763 1.569214))

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

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.089483 1.030934 0.972385 0.913836 0.855288 0.796739 0.738190 0.679641 0.621092 0.562544 0.503995 0.445446))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.758291 0.699742 0.641193 0.582644 0.524096 0.465547 0.406998 0.348449 0.289900 0.231352 1.772803 1.714254))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.427099 0.368550 0.310001 0.251452 1.792904 1.734355 1.675806 1.617257 1.558708 1.500160 1.441611 1.383062))

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

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.200267 1.141718 1.083169 1.024620 0.966072 0.907523 0.848974 0.790425))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.869075 0.810526 0.751977 0.693428 0.634880 0.576331 0.517782 0.459233))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.537883 0.479334 0.420785 0.362236 0.303688 0.245139 1.786590 1.728041))

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

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.014115 0.955566 0.897017 0.838468 0.779920 0.721371 0.662822 0.604273 0.545724))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.682923 0.624374 0.565825 0.507276 0.448728 0.390179 0.331630 0.273081 0.214532))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.351731 0.293182 0.234633 1.776084 1.717536 1.658987 1.600438 1.541889 1.483340))

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

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.827963 0.769414 0.710865))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.496771 0.438222 0.379673))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.765579 1.707030 1.648481))

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

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.269507))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.538315))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.207123))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.497203))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.166011))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.834819))

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

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.938747 0.880198 0.821649 0.763100 0.704552 0.646003))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.607555 0.549006 0.490457 0.431908 0.373360 0.314811))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.276363 0.217814 1.759265 1.700716 1.642168 1.583619))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.752595 0.694046 0.635497 0.576948 0.518400 0.459851))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.421403 0.362854 0.304305 0.245756 1.787208 1.728659))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.690211 1.631662 1.573113 1.514564 1.456016 1.397467))

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

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.794139 1.735590 1.677041 1.618492))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.462947 1.404398 1.345849 1.287300))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.131755 1.073206 1.014657 0.956108))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.607987))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.276795))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.945603))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.421835 1.363286 1.304737 1.246188 1.187640 1.129091 1.070542 1.011993 0.953444 0.894896 0.836347 0.777798))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.090643 1.032094 0.973545 0.914996 0.856448 0.797899 0.739350 0.680801 0.622252 0.563704 0.505155 0.446606))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.759451 0.700902 0.642353 0.583804 0.525256 0.466707 0.408158 0.349609 0.291060 0.232512 1.773963 1.715414))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.235683 1.177134 1.118585 1.060036 1.001488 0.942939 0.884390 0.825841 0.767292 0.708744 0.650195 0.591646))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.904491 0.845942 0.787393 0.728844 0.670296 0.611747 0.553198 0.494649 0.436100 0.377552 0.319003 0.260454))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.573299 0.514750 0.456201 0.397652 0.339104 0.280555 0.222006 1.763457 1.704908 1.646360 1.587811 1.529262))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.049531 0.990982 0.932433 0.873884 0.815336 0.756787 0.698238 0.639689 0.581140 0.522592 0.464043 0.405494))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.718339 0.659790 0.601241 0.542692 0.484144 0.425595 0.367046 0.308497 0.249948 1.791400 1.732851 1.674302))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.387147 0.328598 0.270049 0.211500 1.752952 1.694403 1.635854 1.577305 1.518756 1.460208 1.401659 1.343110))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.863379 0.804830 0.746281 0.687732 0.629184 0.570635 0.512086 0.453537 0.394988 0.336440 0.277891 0.219342 1.760793))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.532187 0.473638 0.415089 0.356540 0.297992 0.239443 1.780894 1.722345 1.663796 1.605248 1.546699 1.488150 1.429601))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.200995 1.742446 1.683897 1.625348 1.566800 1.508251 1.449702 1.391153 1.332604 1.274056 1.215507 1.156958 1.098409))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.491075 0.432526 0.373977 0.315428))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.759883 1.701334 1.642785 1.584236))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.428691 1.370142 1.311593 1.253044))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.718771 1.660222 1.601673))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.387579 1.329030 1.270481))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.056387 0.997838 0.939289))

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

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.974163 0.915614 0.857065 0.798516 0.739968 0.681419))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.642971 0.584422 0.525873 0.467324 0.408776 0.350227))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.311779 0.253230 1.794681 1.736132 1.677584 1.619035))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.788011 0.729462 0.670913 0.612364 0.553816 0.495267))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.456819 0.398270 0.339721 0.281172 0.222624 1.764075))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.725627 1.667078 1.608529 1.549980 1.491432 1.432883))

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

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.415707 0.357158 0.298609 0.240060 1.781512 1.722963 1.664414))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.684515 1.625966 1.567417 1.508868 1.450320 1.391771 1.333222))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.353323 1.294774 1.236225 1.177676 1.119128 1.060579 1.002030))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.229555 1.771006))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.498363 1.439814))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.167171 1.108622))

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

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.271099 1.212550))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.939907 0.881358))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.608715 0.550166))

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

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.084947 1.026398 0.967849 0.909300 0.850752 0.792203 0.733654 0.675105 0.616556))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.753755 0.695206 0.636657 0.578108 0.519560 0.461011 0.402462 0.343913 0.285364))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.422563 0.364014 0.305465 0.246916 1.788368 1.729819 1.671270 1.612721 1.554172))

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

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.898795 0.840246 0.781697))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.567603 0.509054 0.450505))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.236411 1.777862 1.719313))

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

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.754187 1.695638 1.637089 1.578540))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.422995 1.364446 1.305897 1.247348))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.091803 1.033254 0.974705 0.916156))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.568035 1.509486 1.450937 1.392388 1.333840))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.236843 1.178294 1.119745 1.061196 1.002648))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.905651 0.847102 0.788553 0.730004 0.671456))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.195731 1.137182 1.078633))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.864539 0.805990 0.747441))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.533347 0.474798 0.416249))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.823427 0.764878 0.706329 0.647780 0.589232 0.530683 0.472134 0.413585 0.355036 0.296488))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.492235 0.433686 0.375137 0.316588 0.258040 1.799491 1.740942 1.682393 1.623844 1.565296))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.761043 1.702494 1.643945 1.585396 1.526848 1.468299 1.409750 1.351201 1.292652 1.234104))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.637275 0.578726 0.520177))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.306083 0.247534 1.788985))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.574891 1.516342 1.457793))

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

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.451123 0.392574 0.334025 0.275476 0.216928))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.719931 1.661382 1.602833 1.544284 1.485736))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.388739 1.330190 1.271641 1.213092 1.154544))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.264971 0.206422 1.747873 1.689324 1.630776))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.533779 1.475230 1.416681 1.358132 1.299584))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.202587 1.144038 1.085489 1.026940 0.968392))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.678819))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.347627))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.016435))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.492667 1.434118 1.375569 1.317020))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.161475 1.102926 1.044377 0.985828))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.830283 0.771734 0.713185 0.654636))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.306515 1.247966 1.189417 1.130868 1.072320))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.975323 0.916774 0.858225 0.799676 0.741128))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.644131 0.585582 0.527033 0.468484 0.409936))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.120363 1.061814 1.003265 0.944716 0.886168))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.789171 0.730622 0.672073 0.613524 0.554976))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.457979 0.399430 0.340881 0.282332 0.223784))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.934211 0.875662 0.817113))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.603019 0.544470 0.485921))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.271827 0.213278 1.754729))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.748059))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.416867))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.685675))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.561907 0.503358 0.444809 0.386260))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.230715 1.772166 1.713617 1.655068))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.499523 1.440974 1.382425 1.323876))

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

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.789603 1.731054 1.672505 1.613956 1.555408))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.458411 1.399862 1.341313 1.282764 1.224216))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.127219 1.068670 1.010121 0.951572 0.893024))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.603451 1.544902 1.486353 1.427804))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.272259 1.213710 1.155161 1.096612))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.941067 0.882518 0.823969 0.765420))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.417299 1.358750 1.300201 1.241652))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.086107 1.027558 0.969009 0.910460))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.754915 0.696366 0.637817 0.579268))

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

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.858843 0.800294 0.741745 0.683196 0.624648 0.566099 0.507550 0.449001))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.527651 0.469102 0.410553 0.352004 0.293456 0.234907 1.776358 1.717809))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.796459 1.737910 1.679361 1.620812 1.562264 1.503715 1.445166 1.386617))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.486539 0.427990 0.369441 0.310892))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.755347 1.696798 1.638249 1.579700))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.424155 1.365606 1.307057 1.248508))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.300387 0.241838 1.783289))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.569195 1.510646 1.452097))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.238003 1.179454 1.120905))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.528083 1.469534).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.196891 1.138342).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.865699 0.807150).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def check_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v6 := (ym * a)
  (!((0 : Float) < ze) || ((v6 <= (hp * ze)) == ((v6 / ze) <= hp)))

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.155779 1.097230 1.038681 0.980132))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.824587 0.766038 0.707489 0.648940))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.493395 0.434846 0.376297 0.317748))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 0.783475 0.724926 0.666377 0.607828 0.549280 0.490731 0.432182 0.373633 0.315084 0.256536 1.797987 1.739438).toBits)
#eval IO.println ("recip " ++ toString (recip 0.452283 0.393734 0.335185 0.276636 0.218088 1.759539 1.700990 1.642441 1.583892 1.525344 1.466795 1.408246).toBits)
#eval IO.println ("recip " ++ toString (recip 1.721091 1.662542 1.603993 1.545444 1.486896 1.428347 1.369798 1.311249 1.252700 1.194152 1.135603 1.077054).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 0.597323 0.538774 0.480225 0.421676 0.363128 0.304579).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 0.266131 0.207582 1.749033 1.690484 1.631936 1.573387).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.534939 1.476390 1.417841 1.359292 1.300744 1.242195).map Float.toBits))

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

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.225019 1.766470 1.707921))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.493827 1.435278 1.376729))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.162635 1.104086 1.045537))

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

#eval IO.println ("rollY " ++ toString ((rollY 1.266563 1.208014 1.149465).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.935371 0.876822 0.818273).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.604179 0.545630 0.487081).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.080411 1.021862 0.963313 0.904764 0.846216 0.787667).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.749219 0.690670 0.632121 0.573572 0.515024 0.456475).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.418027 0.359478 0.300929 0.242380 1.783832 1.725283).toBits)

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

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.521955 0.463406 0.404857 0.346308 0.287760 0.229211))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.790763 1.732214 1.673665 1.615116 1.556568 1.498019))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.459571 1.401022 1.342473 1.283924 1.225376 1.166827))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.335803 0.277254 0.218705 1.760156 1.701608 1.643059))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.604611 1.546062 1.487513 1.428964 1.370416 1.311867))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.273419 1.214870 1.156321 1.097772 1.039224 0.980675))

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

#eval IO.println ("rot " ++ toString ((rot 1.563499 1.504950 1.446401).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.232307 1.173758 1.115209).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.901115 0.842566 0.784017).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 1.377347 1.318798 1.260249 1.201700).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 1.046155 0.987606 0.929057 0.870508).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.714963 0.656414 0.597865 0.539316).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.191195 1.132646 1.074097 1.015548 0.957000 0.898451 0.839902))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.860003 0.801454 0.742905 0.684356 0.625808 0.567259 0.508710))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.528811 0.470262 0.411713 0.353164 0.294616 0.236067 1.777518))

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

#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.005043 0.946494 0.887945 0.829396 0.770848 0.712299 0.653750 0.595201 0.536652 0.478104 0.419555 0.361006).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.673851 0.615302 0.556753 0.498204 0.439656 0.381107 0.322558 0.264009 0.205460 1.746912 1.688363 1.629814).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.342659 0.284110 0.225561 1.767012 1.708464 1.649915 1.591366 1.532817 1.474268 1.415720 1.357171 1.298622).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 0.818891 0.760342).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.487699 0.429150).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.756507 1.697958).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.632739 0.574190))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.301547 0.242998))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.570355 1.511806))

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

#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.674283 1.615734).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.343091 1.284542).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.011899 0.953350).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.488131 1.429582))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.156939 1.098390))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.825747 0.767198))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.301979 1.243430 1.184881).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.970787 0.912238 0.853689).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.639595 0.581046 0.522497).map Float.toBits))

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

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.115827 1.057278 0.998729 0.940180 0.881632 0.823083 0.764534 0.705985 0.647436))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.784635 0.726086 0.667537 0.608988 0.550440 0.491891 0.433342 0.374793 0.316244))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.453443 0.394894 0.336345 0.277796 0.219248 1.760699 1.702150 1.643601 1.585052))

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

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.929675 0.871126 0.812577))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.598483 0.539934 0.481385))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.267291 0.208742 1.750193))

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 0.743523 0.684974).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.412331 0.353782).toBits)
#eval IO.println ("setLength " ++ toString (setLength 1.681139 1.622590).toBits)

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

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.412763 1.354214 1.295665 1.237116))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.081571 1.023022 0.964473 0.905924))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.750379 0.691830 0.633281 0.574732))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.226611 1.168062 1.109513 1.050964 0.992416))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.895419 0.836870 0.778321 0.719772 0.661224))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.564227 0.505678 0.447129 0.388580 0.330032))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 1.040459 0.981910 0.923361).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.709267 0.650718 0.592169).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.378075 0.319526 0.260977).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 0.854307 0.795758).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 0.523115 0.464566).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.791923 1.733374).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.482003 0.423454).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.750811 1.692262).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.419619 1.361070).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.295851 0.237302).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.564659 1.506110).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.233467 1.174918).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 1.709699 1.651150 1.592601).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.378507 1.319958 1.261409).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.047315 0.988766 0.930217).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.523547 1.464998).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.192355 1.133806).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.861163 0.802614).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.337395 1.278846 1.220297 1.161748 1.103200 1.044651 0.986102).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.006203 0.947654 0.889105 0.830556 0.772008 0.713459 0.654910).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.675011 0.616462 0.557913 0.499364 0.440816 0.382267 0.323718).map Float.toBits))

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.151243 1.092694 1.034145))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.820051 0.761502 0.702953))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.488859 0.430310 0.371761))

def check_sqrt32_bounds  : Bool :=
  let v2 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v2) && (v2 < (1.78886 : Float)))

#eval IO.println ("check_sqrt32_bounds " ++ toString (check_sqrt32_bounds))
#eval IO.println ("check_sqrt32_bounds " ++ toString (check_sqrt32_bounds))
#eval IO.println ("check_sqrt32_bounds " ++ toString (check_sqrt32_bounds))

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

#eval IO.println ("step " ++ toString ((step 0.778939 0.720390 0.661841 0.603292 0.544744 0.486195 0.427646 0.369097 0.310548 0.252000 1.793451 1.734902 1.676353 1.617804 1.559256 1.500707).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.447747 0.389198 0.330649 0.272100 0.213552 1.755003 1.696454 1.637905 1.579356 1.520808 1.462259 1.403710 1.345161 1.286612 1.228064 1.169515).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 1.716555 1.658006 1.599457 1.540908 1.482360 1.423811 1.365262 1.306713 1.248164 1.189616 1.131067 1.072518 1.013969 0.955420 0.896872 0.838323).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 0.406635 0.348086 0.289537 0.230988 1.772440 1.713891 1.655342 1.596793 1.538244).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 1.675443 1.616894 1.558345 1.499796 1.441248 1.382699 1.324150 1.265601 1.207052).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 1.344251 1.285702 1.227153 1.168604 1.110056 1.051507 0.992958 0.934409 0.875860).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.220483 1.761934 1.703385 1.644836 1.586288 1.527739 1.469190 1.410641 1.352092 1.293544))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.489291 1.430742 1.372193 1.313644 1.255096 1.196547 1.137998 1.079449 1.020900 0.962352))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.158099 1.099550 1.041001 0.982452 0.923904 0.865355 0.806806 0.748257 0.689708 0.631160))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 1.634331 1.575782).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.303139 1.244590).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.971947 0.913398).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.448179 1.389630 1.331081))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.116987 1.058438 0.999889))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.785795 0.727246 0.668697))

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

#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.262027 1.203478 1.144929 1.086380).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.930835 0.872286 0.813737 0.755188).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.599643 0.541094 0.482545 0.423996).map Float.toBits))

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

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.075875 1.017326 0.958777 0.900228 0.841680))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.744683 0.686134 0.627585 0.569036 0.510488))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.413491 0.354942 0.296393 0.237844 1.779296))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.889723 0.831174 0.772625 0.714076 0.655528).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.558531 0.499982 0.441433 0.382884 0.324336).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.227339 1.768790 1.710241 1.651692 1.593144).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.703571 0.645022 0.586473 0.527924 0.469376))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.372379 0.313830 0.255281 1.796732 1.738184))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.641187 1.582638 1.524089 1.465540 1.406992))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.517419).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.786227).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.455035).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.331267))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.600075))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.268883))

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

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.745115 1.686566 1.628017 1.569468 1.510920 1.452371).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.413923 1.355374 1.296825 1.238276 1.179728 1.121179).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.082731 1.024182 0.965633 0.907084 0.848536 0.789987).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.558963 1.500414).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.227771 1.169222).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.896579 0.838030).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.372811 1.314262 1.255713 1.197164).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.041619 0.983070 0.924521 0.865972).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.710427 0.651878 0.593329 0.534780).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.186659 1.128110 1.069561 1.011012).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.855467 0.796918 0.738369 0.679820).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.524275 0.465726 0.407177 0.348628).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.000507 0.941958 0.883409 0.824860))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.669315 0.610766 0.552217 0.493668))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.338123 0.279574 0.221025 1.762476))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.814355 0.755806 0.697257 0.638708 0.580160))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.483163 0.424614 0.366065 0.307516 0.248968))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.751971 1.693422 1.634873 1.576324 1.517776))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 0.628203 0.569654 0.511105).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 0.297011 0.238462 1.779913).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.565819 1.507270 1.448721).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.255899 1.797350 1.738801 1.680252 1.621704))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.524707 1.466158 1.407609 1.349060 1.290512))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.193515 1.134966 1.076417 1.017868 0.959320))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 1.669747 1.611198 1.552649 1.494100 1.435552).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.338555 1.280006 1.221457 1.162908 1.104360).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.007363 0.948814 0.890265 0.831716 0.773168).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.483595).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.152403).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.821211).toBits)

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

#eval IO.println ("traceConic " ++ toString ((traceConic 1.297443 1.238894 1.180345 1.121796 1.063248 1.004699 0.946150 0.887601 0.829052).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.966251 0.907702 0.849153 0.790604 0.732056 0.673507 0.614958 0.556409 0.497860).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.635059 0.576510 0.517961 0.459412 0.400864 0.342315 0.283766 0.225217 1.766668).map Float.toBits))

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

#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.111291 1.052742 0.994193 0.935644 0.877096 0.818547 0.759998 0.701449 0.642900 0.584352).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.780099 0.721550 0.663001 0.604452 0.545904 0.487355 0.428806 0.370257 0.311708 0.253160).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.448907 0.390358 0.331809 0.273260 0.214712 1.756163 1.697614 1.639065 1.580516 1.521968).map Float.toBits))

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

#eval IO.println ("traceRay " ++ toString ((traceRay 0.738987 0.680438 0.621889 0.563340 0.504792 0.446243 0.387694 0.329145 0.270596 0.212048 1.753499 1.694950).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 0.407795 0.349246 0.290697 0.232148 1.773600 1.715051 1.656502 1.597953 1.539404 1.480856 1.422307 1.363758).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.676603 1.618054 1.559505 1.500956 1.442408 1.383859 1.325310 1.266761 1.208212 1.149664 1.091115 1.032566).map Float.toBits))

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

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.552835 0.494286 0.435737 0.377188 0.318640 0.260091 0.201542 1.742993 1.684444 1.625896 1.567347 1.508798 1.450249 1.391700 1.333152 1.274603 1.216054 1.157505).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.221643 1.763094 1.704545 1.645996 1.587448 1.528899 1.470350 1.411801 1.353252 1.294704 1.236155 1.177606 1.119057 1.060508 1.001960 0.943411 0.884862 0.826313).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.490451 1.431902 1.373353 1.314804 1.256256 1.197707 1.139158 1.080609 1.022060 0.963512 0.904963 0.846414 0.787865 0.729316 0.670768 0.612219 0.553670 0.495121).map Float.toBits))

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

#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.366683 0.308134 0.249585 1.791036 1.732488 1.673939 1.615390 1.556841 1.498292 1.439744 1.381195 1.322646 1.264097).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.635491 1.576942 1.518393 1.459844 1.401296 1.342747 1.284198 1.225649 1.167100 1.108552 1.050003 0.991454 0.932905).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.304299 1.245750 1.187201 1.128652 1.070104 1.011555 0.953006 0.894457 0.835908 0.777360 0.718811 0.660262 0.601713).map Float.toBits))

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

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.780531 1.721982 1.663433 1.604884 1.546336 1.487787 1.429238 1.370689 1.312140 1.253592 1.195043 1.136494 1.077945 1.019396 0.960848 0.902299 0.843750 0.785201 0.726652).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.449339 1.390790 1.332241 1.273692 1.215144 1.156595 1.098046 1.039497 0.980948 0.922400 0.863851 0.805302 0.746753 0.688204 0.629656 0.571107 0.512558 0.454009 0.395460).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.118147 1.059598 1.001049 0.942500 0.883952 0.825403 0.766854 0.708305 0.649756 0.591208 0.532659 0.474110 0.415561 0.357012 0.298464 0.239915 1.781366 1.722817 1.664268).map Float.toBits))

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

#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.594379 1.535830 1.477281 1.418732 1.360184 1.301635 1.243086 1.184537).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.263187 1.204638 1.146089 1.087540 1.028992 0.970443 0.911894 0.853345).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.931995 0.873446 0.814897 0.756348 0.697800 0.639251 0.580702 0.522153).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.408227 1.349678 1.291129))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.077035 1.018486 0.959937))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.745843 0.687294 0.628745))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.222075))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.890883))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.559691))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 1.035923 0.977374 0.918825 0.860276))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.704731 0.646182 0.587633 0.529084))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.373539 0.314990 0.256441 1.797892))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 0.849771 0.791222 0.732673).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 0.518579 0.460030 0.401481).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.787387 1.728838 1.670289).map Float.toBits))

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 0.663619 0.605070 0.546521 0.487972 0.429424 0.370875).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.332427 0.273878 0.215329 1.756780 1.698232 1.639683).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.601235 1.542686 1.484137 1.425588 1.367040 1.308491).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 0.477467 0.418918 0.360369 0.301820 0.243272 1.784723).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.746275 1.687726 1.629177 1.570628 1.512080 1.453531).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.415083 1.356534 1.297985 1.239436 1.180888 1.122339).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 0.291315 0.232766 1.774217 1.715668 1.657120 1.598571 1.540022 1.481473 1.422924 1.364376 1.305827 1.247278 1.188729).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.560123 1.501574 1.443025 1.384476 1.325928 1.267379 1.208830 1.150281 1.091732 1.033184 0.974635 0.916086 0.857537).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.228931 1.170382 1.111833 1.053284 0.994736 0.936187 0.877638 0.819089 0.760540 0.701992 0.643443 0.584894 0.526345).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 1.705163 1.646614 1.588065 1.529516 1.470968 1.412419 1.353870 1.295321 1.236772 1.178224 1.119675 1.061126).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 1.373971 1.315422 1.256873 1.198324 1.139776 1.081227 1.022678 0.964129 0.905580 0.847032 0.788483 0.729934).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 1.042779 0.984230 0.925681 0.867132 0.808584 0.750035 0.691486 0.632937 0.574388 0.515840 0.457291 0.398742).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.519011 1.460462 1.401913 1.343364 1.284816 1.226267 1.167718 1.109169 1.050620 0.992072 0.933523 0.874974).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.187819 1.129270 1.070721 1.012172 0.953624 0.895075 0.836526 0.777977 0.719428 0.660880 0.602331 0.543782).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.856627 0.798078 0.739529 0.680980 0.622432 0.563883 0.505334 0.446785 0.388236 0.329688 0.271139 0.212590).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 1.332859 1.274310 1.215761 1.157212 1.098664 1.040115 0.981566 0.923017 0.864468 0.805920 0.747371 0.688822).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 1.001667 0.943118 0.884569 0.826020 0.767472 0.708923 0.650374 0.591825 0.533276 0.474728 0.416179 0.357630).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.670475 0.611926 0.553377 0.494828 0.436280 0.377731 0.319182 0.260633 0.202084 1.743536 1.684987 1.626438).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.146707 1.088158 1.029609 0.971060 0.912512 0.853963 0.795414 0.736865 0.678316 0.619768 0.561219 0.502670).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.815515 0.756966 0.698417 0.639868 0.581320 0.522771 0.464222 0.405673 0.347124 0.288576 0.230027 1.771478).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.484323 0.425774 0.367225 0.308676 0.250128 1.791579 1.733030 1.674481 1.615932 1.557384 1.498835 1.440286).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 0.960555 0.902006 0.843457 0.784908 0.726360 0.667811).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 0.629363 0.570814 0.512265 0.453716 0.395168 0.336619).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 0.298171 0.239622 1.781073 1.722524 1.663976 1.605427).map Float.toBits))

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

#eval IO.println ("wireLen " ++ toString (wireLen 0.588251 0.529702 0.471153 0.412604 0.354056).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 0.257059 1.798510 1.739961 1.681412 1.622864).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.525867 1.467318 1.408769 1.350220 1.291672).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 0.402099 0.343550 0.285001 0.226452).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.670907 1.612358 1.553809 1.495260).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.339715 1.281166 1.222617 1.164068).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.215947 1.757398 1.698849 1.640300 1.581752))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.484755 1.426206 1.367657 1.309108 1.250560))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.153563 1.095014 1.036465 0.977916 0.919368))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.629795 1.571246 1.512697 1.454148))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.298603 1.240054 1.181505 1.122956))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.967411 0.908862 0.850313 0.791764))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.443643 1.385094 1.326545 1.267996))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.112451 1.053902 0.995353 0.936804))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.781259 0.722710 0.664161 0.605612))

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

#eval IO.println ("wireTension " ++ toString (wireTension 0.885187 0.826638 0.768089 0.709540).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 0.553995 0.495446 0.436897 0.378348).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 0.222803 1.764254 1.705705 1.647156).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.699035 0.640486 0.581937 0.523388 0.464840 0.406291 0.347742 0.289193))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.367843 0.309294 0.250745 1.792196 1.733648 1.675099 1.616550 1.558001))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.636651 1.578102 1.519553 1.461004 1.402456 1.343907 1.285358 1.226809))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.326731 0.268182 0.209633 1.751084))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.595539 1.536990 1.478441 1.419892))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.264347 1.205798 1.147249 1.088700))

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.740579 1.682030 1.623481 1.564932 1.506384 1.447835).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.409387 1.350838 1.292289 1.233740 1.175192 1.116643).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.078195 1.019646 0.961097 0.902548 0.844000 0.785451).map Float.toBits))

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

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.182123 1.123574 1.065025))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.850931 0.792382 0.733833))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.519739 0.461190 0.402641))

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
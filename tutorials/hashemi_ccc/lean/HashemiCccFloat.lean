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

def PumpWithinBudget (Pelec : Float) (Pbudget : Float) : Bool :=
  (Pelec <= Pbudget)

#eval IO.println ("PumpWithinBudget " ++ toString (PumpWithinBudget 0.846107 0.787558))
#eval IO.println ("PumpWithinBudget " ++ toString (PumpWithinBudget 0.514915 0.456366))
#eval IO.println ("PumpWithinBudget " ++ toString (PumpWithinBudget 1.783723 1.725174))

def ReachesVertical (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  ((ym * a) <= (hp * ze))

#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 0.659955 0.601406 0.542857 0.484308))
#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 0.328763 0.270214 0.211665 1.753116))
#eval IO.println ("ReachesVertical " ++ toString (ReachesVertical 1.597571 1.539022 1.480473 1.421924))

def Rgas  : Float :=
  (8.314 : Float)

#eval IO.println ("Rgas " ++ toString (Rgas).toBits)
#eval IO.println ("Rgas " ++ toString (Rgas).toBits)
#eval IO.println ("Rgas " ++ toString (Rgas).toBits)

def SlackHarmless (f : Float) (eps : Float) (delta : Float) (h : Float) : Bool :=
  (((f * (Float.tan eps)) + delta) <= h)

#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 0.287651 0.229102 1.770553 1.712004))
#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 1.556459 1.497910 1.439361 1.380812))
#eval IO.println ("SlackHarmless " ++ toString (SlackHarmless 1.225267 1.166718 1.108169 1.049620))

def SunReachable (tDead : Float) (elSun : Float) : Bool :=
  ((((3.141592653589793 : Float) / (2 : Float)) - tDead) <= elSun)

#eval IO.println ("SunReachable " ++ toString (SunReachable 1.701499 1.642950))
#eval IO.println ("SunReachable " ++ toString (SunReachable 1.370307 1.311758))
#eval IO.println ("SunReachable " ++ toString (SunReachable 1.039115 0.980566))

def TankHolds (Vtank : Float) (Vloop : Float) (frac : Float) : Bool :=
  ((Vloop * frac) <= Vtank)

#eval IO.println ("TankHolds " ++ toString (TankHolds 1.515347 1.456798 1.398249))
#eval IO.println ("TankHolds " ++ toString (TankHolds 1.184155 1.125606 1.067057))
#eval IO.println ("TankHolds " ++ toString (TankHolds 0.852963 0.794414 0.735865))

def TrackerBudget (f : Float) (eps : Float) (h : Float) : Bool :=
  ((f * (Float.tan eps)) <= h)

#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 1.329195 1.270646 1.212097))
#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 0.998003 0.939454 0.880905))
#eval IO.println ("TrackerBudget " ++ toString (TrackerBudget 0.666811 0.608262 0.549713))

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

#eval IO.println ("azRate " ++ toString (azRate 0.770739 0.712190 0.653641).toBits)
#eval IO.println ("azRate " ++ toString (azRate 0.439547 0.380998 0.322449).toBits)
#eval IO.println ("azRate " ++ toString (azRate 1.708355 1.649806 1.591257).toBits)

def check_azRate_pos (omegam : Float) (rw : Float) (R : Float) : Bool :=
  (!((0 : Float) < omegam) || (!((0 : Float) < rw) || (!((0 : Float) < R) || ((0 : Float) < ((omegam * rw) / R)))))

#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 0.584587 0.526038 0.467489))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 0.253395 1.794846 1.736297))
#eval IO.println ("check_azRate_pos " ++ toString (check_azRate_pos 1.522203 1.463654 1.405105))

def beamAxis (t : Float) (beta : Float) : Array Float :=
  let v2 := (t + beta)
  #[(Float.sin v2), (0 : Float), (-(Float.cos v2))]

#eval IO.println ("beamAxis " ++ toString ((beamAxis 0.398435 0.339886).map Float.toBits))
#eval IO.println ("beamAxis " ++ toString ((beamAxis 1.667243 1.608694).map Float.toBits))
#eval IO.println ("beamAxis " ++ toString ((beamAxis 1.336051 1.277502).map Float.toBits))

def check_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 0.212283))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 1.481091))
#eval IO.println ("check_bearing_life " ++ toString (check_bearing_life 1.149899))

def check_bins_partition (rc : Float) (r : Float) : Bool :=
  (!((0 : Float) < rc) || (!((0 : Float) <= r) || (feq ((((((((if (((((0 : Float) * rc) / (8 : Float)) <= r) && (r < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float)) + (if (((((1 : Float) * rc) / (8 : Float)) <= r) && (r < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((2 : Float) * rc) / (8 : Float)) <= r) && (r < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((3 : Float) * rc) / (8 : Float)) <= r) && (r < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((4 : Float) * rc) / (8 : Float)) <= r) && (r < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((5 : Float) * rc) / (8 : Float)) <= r) && (r < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((6 : Float) * rc) / (8 : Float)) <= r) && (r < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) + (if (((((7 : Float) * rc) / (8 : Float)) <= r) && (r < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) then (1 : Float) else (0 : Float))) (if (r < rc) then (1 : Float) else (0 : Float)))))

#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 1.626131 1.567582))
#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 1.294939 1.236390))
#eval IO.println ("check_bins_partition " ++ toString (check_bins_partition 0.963747 0.905198))

def bisectStep (ym : Float) (hp : Float) (a : Float) (ze : Float) (L : Float) (lohi_1 : Float) (lohi_2 : Float) : Array Float :=
  let v9 := ((lohi_1 + lohi_2) / (2 : Float))
  let v11 := (-a)
  let v12 := (Float.cos v9)
  let v14 := (-ze)
  let v15 := (Float.sin v9)
  let v28 := (L < (Float.sqrt (((((v11 * v12) + (v14 * v15)) - (-ym)) ^ 2) + (((((-v11) * v15) + (v14 * v12)) - hp) ^ 2))))
  #[(if v28 then v9 else lohi_1), (if v28 then lohi_2 else v9)]

#eval IO.println ("bisectStep " ++ toString ((bisectStep 1.439979 1.381430 1.322881 1.264332 1.205784 1.147235 1.088686).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 1.108787 1.050238 0.991689 0.933140 0.874592 0.816043 0.757494).map Float.toBits))
#eval IO.println ("bisectStep " ++ toString ((bisectStep 0.777595 0.719046 0.660497 0.601948 0.543400 0.484851 0.426302).map Float.toBits))

def boltStress (W : Float) (reach : Float) (d : Float) : Float :=
  (((W / (2 : Float)) * reach) / (((3.141592653589793 : Float) * (d ^ 3)) / (32 : Float)))

#eval IO.println ("boltStress " ++ toString (boltStress 1.253827 1.195278 1.136729).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 0.922635 0.864086 0.805537).toBits)
#eval IO.println ("boltStress " ++ toString (boltStress 0.591443 0.532894 0.474345).toBits)

def braceHeight (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) : Float :=
  (Float.sqrt ((l_brace ^ 2) - ((l_foot - l_footShort) ^ 2)))

#eval IO.println ("braceHeight " ++ toString (braceHeight 1.067675 1.009126 0.950577 0.892028 0.833480).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 0.736483 0.677934 0.619385 0.560836 0.502288).toBits)
#eval IO.println ("braceHeight " ++ toString (braceHeight 0.405291 0.346742 0.288193 0.229644 1.771096).toBits)

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

#eval IO.println ("cableDrop " ++ toString (cableDrop 1.736915 1.678366).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 1.405723 1.347174).toBits)
#eval IO.println ("cableDrop " ++ toString (cableDrop 1.074531 1.015982).toBits)

def check_cable_drop_small (L : Float) (I : Float) : Bool :=
  (!(L <= (4 : Float)) || (!((0 : Float) <= I) || (!(I <= (1 : Float)) || (((((0.0000000172 : Float) * ((2 : Float) * L)) * I) / (0.0000015 : Float)) < (0.1 : Float)))))

#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.550763 1.492214))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 1.219571 1.161022))
#eval IO.println ("check_cable_drop_small " ++ toString (check_cable_drop_small 0.888379 0.829830))

def capSag (a : Float) (b2 : Float) (rm : Float) : Float :=
  ((a * (Float.sqrt ((1 : Float) + ((rm ^ 2) / b2)))) - a)

#eval IO.println ("capSag " ++ toString (capSag 1.364611 1.306062 1.247513).toBits)
#eval IO.println ("capSag " ++ toString (capSag 1.033419 0.974870 0.916321).toBits)
#eval IO.println ("capSag " ++ toString (capSag 0.702227 0.643678 0.585129).toBits)

def captureS (rc : Float) (rad : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((rc - rad) / (0.005 : Float)))))

#eval IO.println ("captureS " ++ toString (captureS 1.178459 1.119910).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.847267 0.788718).toBits)
#eval IO.println ("captureS " ++ toString (captureS 0.516075 0.457526).toBits)

def check_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.992307 0.933758 0.875209))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.661115 0.602566 0.544017))
#eval IO.println ("check_captureS_slope " ++ toString (check_captureS_slope 0.329923 0.271374 0.212825))

def celsius (T : Float) : Float :=
  (T - (273.15 : Float))

#eval IO.println ("celsius " ++ toString (celsius 0.806155).toBits)
#eval IO.println ("celsius " ++ toString (celsius 0.474963).toBits)
#eval IO.println ("celsius " ++ toString (celsius 1.743771).toBits)

def clearance (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (holeDown : Float) (reach : Float) : Float :=
  ((l_upright - holeDown) - reach)

#eval IO.println ("clearance " ++ toString (clearance 0.620003 0.561454 0.502905 0.444356 0.385808 0.327259 0.268710).toBits)
#eval IO.println ("clearance " ++ toString (clearance 0.288811 0.230262 1.771713 1.713164 1.654616 1.596067 1.537518).toBits)
#eval IO.println ("clearance " ++ toString (clearance 1.557619 1.499070 1.440521 1.381972 1.323424 1.264875 1.206326).toBits)

def check_clearance_hashemi (holeDown : Float) : Bool :=
  let v16 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v16) && (v16 < ((0.146 : Float) - holeDown)))

#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 0.433851))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.702659))
#eval IO.println ("check_clearance_hashemi " ++ toString (check_clearance_hashemi 1.371467))

def coilCapture (rs : Float) (rc : Float) (d : Float) : Float :=
  let v9 := (rs ^ 2)
  let v10 := (d ^ 2)
  let v12 := (rc ^ 2)
  let v15 := ((2 : Float) * d)
  let v30 := (d + rs)
  (if ((rs + rc) <= d) then (0 : Float) else (if (d <= (rc - rs)) then (1 : Float) else ((((v9 * (Float.acos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Float.acos (((v10 + v12) - v9) / (v15 * rc))))) - ((Float.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : Float))) / ((3.141592653589793 : Float) * v9))))

#eval IO.println ("coilCapture " ++ toString (coilCapture 0.247699 1.789150 1.730601).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.516507 1.457958 1.399409).toBits)
#eval IO.println ("coilCapture " ++ toString (coilCapture 1.185315 1.126766 1.068217).toBits)

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

#eval IO.println ("coilProfile " ++ toString ((coilProfile 1.661547 1.602998 1.544449 1.485900 1.427352 1.368803 1.310254 1.251705 1.193156 1.134608 1.076059 1.017510 0.958961 0.900412 0.841864).map Float.toBits))
#eval IO.println ("coilProfile " ++ toString ((coilProfile 1.330355 1.271806 1.213257 1.154708 1.096160 1.037611 0.979062 0.920513 0.861964 0.803416 0.744867 0.686318 0.627769 0.569220 0.510672).map Float.toBits))
#eval IO.println ("coilProfile " ++ toString ((coilProfile 0.999163 0.940614 0.882065 0.823516 0.764968 0.706419 0.647870 0.589321 0.530772 0.472224 0.413675 0.355126 0.296577 0.238028 1.779480).map Float.toBits))

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

#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 1.475395 1.416846 1.358297 1.299748 1.241200 1.182651 1.124102 1.065553 1.007004 0.948456 0.889907 0.831358 0.772809 0.714260 0.655712))
#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 1.144203 1.085654 1.027105 0.968556 0.910008 0.851459 0.792910 0.734361 0.675812 0.617264 0.558715 0.500166 0.441617 0.383068 0.324520))
#eval IO.println ("check_coilProfile_balance " ++ toString (check_coilProfile_balance 0.813011 0.754462 0.695913 0.637364 0.578816 0.520267 0.461718 0.403169 0.344620 0.286072 0.227523 1.768974 1.710425 1.651876 1.593328))

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

#eval IO.println ("conicHitS " ++ toString (conicHitS 1.103091 1.044542 0.985993 0.927444 0.868896 0.810347 0.751798 0.693249).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 0.771899 0.713350 0.654801 0.596252 0.537704 0.479155 0.420606 0.362057).toBits)
#eval IO.println ("conicHitS " ++ toString (conicHitS 0.440707 0.382158 0.323609 0.265060 0.206512 1.747963 1.689414 1.630865).toBits)

def conicSlope (c : Float) (k : Float) (r : Float) : Float :=
  ((c * r) / (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : Float))))

#eval IO.println ("conicSlope " ++ toString (conicSlope 0.916939 0.858390 0.799841).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 0.585747 0.527198 0.468649).toBits)
#eval IO.println ("conicSlope " ++ toString (conicSlope 0.254555 1.796006 1.737457).toBits)

def conicZ (c : Float) (k : Float) (r : Float) : Float :=
  let v3 := (r ^ 2)
  ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + k) * (c ^ 2)) * v3)) (0 : Float)))))

#eval IO.println ("conicZ " ++ toString (conicZ 0.730787 0.672238 0.613689).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 0.399595 0.341046 0.282497).toBits)
#eval IO.println ("conicZ " ++ toString (conicZ 1.668403 1.609854 1.551305).toBits)

def check_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.544635 0.486086))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 0.213443 1.754894))
#eval IO.println ("check_conicZ_paraboloid " ++ toString (check_conicZ_paraboloid 1.482251 1.423702))

def check_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v4 := (c ^ 2)
  let v5 := (r ^ 2)
  let v18 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v4 * v5) <= (1 : Float)) || (feq ((c * v5) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v4) * v5)) (0 : Float))))) (v18 - (Float.sqrt ((v18 ^ 2) - v5))))))

#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 0.358483 0.299934))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.627291 1.568742))
#eval IO.println ("check_conicZ_sphere " ++ toString (check_conicZ_sphere 1.296099 1.237550))

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

#eval IO.println ("constraints " ++ toString ((constraints 1.772331 1.713782 1.655233 1.596684 1.538136 1.479587 1.421038 1.362489 1.303940 1.245392 1.186843 1.128294).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 1.441139 1.382590 1.324041 1.265492 1.206944 1.148395 1.089846 1.031297 0.972748 0.914200 0.855651 0.797102).map Float.toBits))
#eval IO.println ("constraints " ++ toString ((constraints 1.109947 1.051398 0.992849 0.934300 0.875752 0.817203 0.758654 0.700105 0.641556 0.583008 0.524459 0.465910).map Float.toBits))

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

#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.586179 1.527630 1.469081 1.410532 1.351984 1.293435 1.234886 1.176337 1.117788 1.059240 1.000691 0.942142).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 1.254987 1.196438 1.137889 1.079340 1.020792 0.962243 0.903694 0.845145 0.786596 0.728048 0.669499 0.610950).map Float.toBits))
#eval IO.println ("constraintsGrooved " ++ toString ((constraintsGrooved 0.923795 0.865246 0.806697 0.748148 0.689600 0.631051 0.572502 0.513953 0.455404 0.396856 0.338307 0.279758).map Float.toBits))

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

#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.400027 1.341478 1.282929 1.224380 1.165832 1.107283 1.048734 0.990185 0.931636 0.873088 0.814539 0.755990))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 1.068835 1.010286 0.951737 0.893188 0.834640 0.776091 0.717542 0.658993 0.600444 0.541896 0.483347 0.424798))
#eval IO.println ("check_constraints_reciprocal_yaw " ++ toString (check_constraints_reciprocal_yaw 0.737643 0.679094 0.620545 0.561996 0.503448 0.444899 0.386350 0.327801 0.269252 0.210704 1.752155 1.693606))

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

#eval IO.println ("cross3 " ++ toString ((cross3 0.841571 0.783022 0.724473 0.665924 0.607376 0.548827).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 0.510379 0.451830 0.393281 0.334732 0.276184 0.217635).map Float.toBits))
#eval IO.println ("cross3 " ++ toString ((cross3 1.779187 1.720638 1.662089 1.603540 1.544992 1.486443).map Float.toBits))

def dPipe (Q : Float) (D : Float) (L : Float) (T : Float) : Float :=
  let v5 := (D ^ 2)
  let v9 := (Q / (((3.141592653589793 : Float) * v5) / (4 : Float)))
  let v11 := (T - (273.15 : Float))
  let v19 := (((1020.62 : Float) - ((0.614254 : Float) * v11)) - ((0.000321 : Float) * (v11 ^ 2)))
  let v30 := ((Float.exp (((586.375 : Float) / (v11 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v31 := (((v19 * v9) * D) / v30)
  (if (v31 < (2300 : Float)) then (((((32 : Float) * v30) * L) * v9) / v5) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt (max v31 (1 : Float))))) * (L / D)) * v19) * (v9 ^ 2)) / (2 : Float)))

#eval IO.println ("dPipe " ++ toString (dPipe 0.655419 0.596870 0.538321 0.479772).toBits)
#eval IO.println ("dPipe " ++ toString (dPipe 0.324227 0.265678 0.207129 1.748580).toBits)
#eval IO.println ("dPipe " ++ toString (dPipe 1.593035 1.534486 1.475937 1.417388).toBits)

def darcyF (Re : Float) : Float :=
  (if (Re < (2300 : Float)) then ((64 : Float) / (max Re (0.000000001 : Float))) else ((0.3164 : Float) / (Float.sqrt (Float.sqrt (max Re (1 : Float))))))

#eval IO.println ("darcyF " ++ toString (darcyF 0.469267).toBits)
#eval IO.println ("darcyF " ++ toString (darcyF 1.738075).toBits)
#eval IO.println ("darcyF " ++ toString (darcyF 1.406883).toBits)

def deadPoint (ym : Float) (hp : Float) (a : Float) (ze : Float) : Float :=
  let v4 := (ym * a)
  let v5 := (hp * ze)
  (if (v4 <= v5) then ((3.141592653589793 : Float) / (2 : Float)) else (Float.atan (((ym * ze) + (hp * a)) / (v4 - v5))))

#eval IO.println ("deadPoint " ++ toString (deadPoint 0.283115 0.224566 1.766017 1.707468).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.551923 1.493374 1.434825 1.376276).toBits)
#eval IO.println ("deadPoint " ++ toString (deadPoint 1.220731 1.162182 1.103633 1.045084).toBits)

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

def degCostRaw (dt : Float) (filmExcess : Float) (degPrice : Float) (rotiReward : Float) : Float :=
  (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))

#eval IO.println ("degCostRaw " ++ toString (degCostRaw 1.324659 1.266110 1.207561 1.149012).toBits)
#eval IO.println ("degCostRaw " ++ toString (degCostRaw 0.993467 0.934918 0.876369 0.817820).toBits)
#eval IO.println ("degCostRaw " ++ toString (degCostRaw 0.662275 0.603726 0.545177 0.486628).toBits)

def check_degCostRaw_nonneg (dt : Float) (filmExcess : Float) (degPrice : Float) (rotiReward : Float) : Bool :=
  (!((0 : Float) <= dt) || (!((0 : Float) <= degPrice) || (!((0 : Float) <= rotiReward) || ((0 : Float) <= (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))))))

#eval IO.println ("check_degCostRaw_nonneg " ++ toString (check_degCostRaw_nonneg 1.138507 1.079958 1.021409 0.962860))
#eval IO.println ("check_degCostRaw_nonneg " ++ toString (check_degCostRaw_nonneg 0.807315 0.748766 0.690217 0.631668))
#eval IO.println ("check_degCostRaw_nonneg " ++ toString (check_degCostRaw_nonneg 0.476123 0.417574 0.359025 0.300476))

def degradRate (degA : Float) (degEa : Float) (Tfilm : Float) : Float :=
  (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max Tfilm (1 : Float))))))

#eval IO.println ("degradRate " ++ toString (degradRate 0.952355 0.893806 0.835257).toBits)
#eval IO.println ("degradRate " ++ toString (degradRate 0.621163 0.562614 0.504065).toBits)
#eval IO.println ("degradRate " ++ toString (degradRate 0.289971 0.231422 1.772873).toBits)

def check_degradRate_mono (degA : Float) (degEa : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v8 := (-degEa)
  (!((0 : Float) <= degA) || (!((0 : Float) <= degEa) || (!(T1 <= T2) || ((degA * (Float.exp (v8 / ((8.314 : Float) * (max T1 (1 : Float)))))) <= (degA * (Float.exp (v8 / ((8.314 : Float) * (max T2 (1 : Float))))))))))

#eval IO.println ("check_degradRate_mono " ++ toString (check_degradRate_mono 0.766203 0.707654 0.649105 0.590556))
#eval IO.println ("check_degradRate_mono " ++ toString (check_degradRate_mono 0.435011 0.376462 0.317913 0.259364))
#eval IO.println ("check_degradRate_mono " ++ toString (check_degradRate_mono 1.703819 1.645270 1.586721 1.528172))

def check_degradRate_pos (degA : Float) (degEa : Float) (Tfilm : Float) : Bool :=
  (!((0 : Float) < degA) || ((0 : Float) < (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max Tfilm (1 : Float))))))))

#eval IO.println ("check_degradRate_pos " ++ toString (check_degradRate_pos 0.580051 0.521502 0.462953))
#eval IO.println ("check_degradRate_pos " ++ toString (check_degradRate_pos 0.248859 1.790310 1.731761))
#eval IO.println ("check_degradRate_pos " ++ toString (check_degradRate_pos 1.517667 1.459118 1.400569))

def degradStep (deg : Float) (dt : Float) (degA : Float) (degEa : Float) (Tfilm : Float) : Float :=
  (deg + (dt * (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max Tfilm (1 : Float))))))))

#eval IO.println ("degradStep " ++ toString (degradStep 0.393899 0.335350 0.276801 0.218252 1.759704).toBits)
#eval IO.println ("degradStep " ++ toString (degradStep 1.662707 1.604158 1.545609 1.487060 1.428512).toBits)
#eval IO.println ("degradStep " ++ toString (degradStep 1.331515 1.272966 1.214417 1.155868 1.097320).toBits)

def degraded (x : Float) (deg : Float) (knock : Float) : Float :=
  (x * ((1 : Float) - (knock * (min (max deg (0 : Float)) (1 : Float)))))

#eval IO.println ("degraded " ++ toString (degraded 0.207747 1.749198 1.690649).toBits)
#eval IO.println ("degraded " ++ toString (degraded 1.476555 1.418006 1.359457).toBits)
#eval IO.println ("degraded " ++ toString (degraded 1.145363 1.086814 1.028265).toBits)

def delayOf (L : Float) (Q : Float) (D : Float) (dt : Float) : Float :=
  ((L / (max (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))) (0.000001 : Float))) / dt)

#eval IO.println ("delayOf " ++ toString (delayOf 1.621595 1.563046 1.504497 1.445948).toBits)
#eval IO.println ("delayOf " ++ toString (delayOf 1.290403 1.231854 1.173305 1.114756).toBits)
#eval IO.println ("delayOf " ++ toString (delayOf 0.959211 0.900662 0.842113 0.783564).toBits)

def delaySteps  : Float :=
  (2 : Float)

#eval IO.println ("delaySteps " ++ toString (delaySteps).toBits)
#eval IO.println ("delaySteps " ++ toString (delaySteps).toBits)
#eval IO.println ("delaySteps " ++ toString (delaySteps).toBits)

def check_delay_antitone (L : Float) (Q1 : Float) (Q2 : Float) (D : Float) (dt : Float) : Bool :=
  let v14 := (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))
  (!((0 : Float) <= L) || (!((0 : Float) < dt) || (!((0 : Float) < D) || (!(Q1 <= Q2) || (((L / (max (Q2 / v14) (0.000001 : Float))) / dt) <= ((L / (max (Q1 / v14) (0.000001 : Float))) / dt))))))

#eval IO.println ("check_delay_antitone " ++ toString (check_delay_antitone 1.249291 1.190742 1.132193 1.073644 1.015096))
#eval IO.println ("check_delay_antitone " ++ toString (check_delay_antitone 0.918099 0.859550 0.801001 0.742452 0.683904))
#eval IO.println ("check_delay_antitone " ++ toString (check_delay_antitone 0.586907 0.528358 0.469809 0.411260 0.352712))

def delivered (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Float :=
  (Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp))))

#eval IO.println ("delivered " ++ toString (delivered 1.063139 1.004590 0.946041 0.887492).toBits)
#eval IO.println ("delivered " ++ toString (delivered 0.731947 0.673398 0.614849 0.556300).toBits)
#eval IO.println ("delivered " ++ toString (delivered 0.400755 0.342206 0.283657 0.225108).toBits)

def check_delivered_ge_amb (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Bool :=
  (!(Ta <= Tin) || (Ta <= (Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp))))))

#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 0.876987 0.818438 0.759889 0.701340))
#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 0.545795 0.487246 0.428697 0.370148))
#eval IO.println ("check_delivered_ge_amb " ++ toString (check_delivered_ge_amb 0.214603 1.756054 1.697505 1.638956))

def check_delivered_le (Upipe : Float) (mcp : Float) (Ta : Float) (Tin : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || (!(Ta <= Tin) || ((Ta + ((Tin - Ta) * (Float.exp ((-Upipe) / mcp)))) <= Tin))))

#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 0.690835 0.632286 0.573737 0.515188))
#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 0.359643 0.301094 0.242545 1.783996))
#eval IO.println ("check_delivered_le " ++ toString (check_delivered_le 1.628451 1.569902 1.511353 1.452804))

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

#eval IO.println ("dishAxes " ++ toString ((dishAxes 0.504683 0.446134).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.773491 1.714942).map Float.toBits))
#eval IO.println ("dishAxes " ++ toString ((dishAxes 1.442299 1.383750).map Float.toBits))

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

#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 0.318531 0.259982 0.201433))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.587339 1.528790 1.470241))
#eval IO.println ("check_dishAxes_rot " ++ toString (check_dishAxes_rot 1.256147 1.197598 1.139049))

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

#eval IO.println ("dishPower " ++ toString ((dishPower 1.360075 1.301526 1.242977 1.184428 1.125880 1.067331 1.008782 0.950233 0.891684 0.833136 0.774587 0.716038 0.657489 0.598940 0.540392 0.481843 0.423294 0.364745 0.306196 0.247648 1.789099 1.730550 1.672001 1.613452).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 1.028883 0.970334 0.911785 0.853236 0.794688 0.736139 0.677590 0.619041 0.560492 0.501944 0.443395 0.384846 0.326297 0.267748 0.209200 1.750651 1.692102 1.633553 1.575004 1.516456 1.457907 1.399358 1.340809 1.282260).map Float.toBits))
#eval IO.println ("dishPower " ++ toString ((dishPower 0.697691 0.639142 0.580593 0.522044 0.463496 0.404947 0.346398 0.287849 0.229300 1.770752 1.712203 1.653654 1.595105 1.536556 1.478008 1.419459 1.360910 1.302361 1.243812 1.185264 1.126715 1.068166 1.009617 0.951068).map Float.toBits))

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

#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 1.173923 1.115374 1.056825 0.998276 0.939728 0.881179 0.822630 0.764081 0.705532 0.646984 0.588435 0.529886 0.471337 0.412788 0.354240 0.295691 0.237142 1.778593 1.720044 1.661496 1.602947 1.544398 1.485849 1.427300))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.842731 0.784182 0.725633 0.667084 0.608536 0.549987 0.491438 0.432889 0.374340 0.315792 0.257243 1.798694 1.740145 1.681596 1.623048 1.564499 1.505950 1.447401 1.388852 1.330304 1.271755 1.213206 1.154657 1.096108))
#eval IO.println ("check_dishPower_captured " ++ toString (check_dishPower_captured 0.511539 0.452990 0.394441 0.335892 0.277344 0.218795 1.760246 1.701697 1.643148 1.584600 1.526051 1.467502 1.408953 1.350404 1.291856 1.233307 1.174758 1.116209 1.057660 0.999112 0.940563 0.882014 0.823465 0.764916))

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

#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.987771 0.929222 0.870673 0.812124 0.753576 0.695027 0.636478 0.577929 0.519380 0.460832 0.402283 0.343734 0.285185 0.226636 1.768088 1.709539 1.650990 1.592441 1.533892 1.475344 1.416795 1.358246 1.299697 1.241148))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.656579 0.598030 0.539481 0.480932 0.422384 0.363835 0.305286 0.246737 1.788188 1.729640 1.671091 1.612542 1.553993 1.495444 1.436896 1.378347 1.319798 1.261249 1.202700 1.144152 1.085603 1.027054 0.968505 0.909956))
#eval IO.println ("check_dishPower_le " ++ toString (check_dishPower_le 0.325387 0.266838 0.208289 1.749740 1.691192 1.632643 1.574094 1.515545 1.456996 1.398448 1.339899 1.281350 1.222801 1.164252 1.105704 1.047155 0.988606 0.930057 0.871508 0.812960 0.754411 0.695862 0.637313 0.578764))

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

#eval IO.println ("dishReflect " ++ toString ((dishReflect 0.615467 0.556918 0.498369 0.439820 0.381272 0.322723 0.264174 0.205625 1.747076 1.688528 1.629979 1.571430 1.512881 1.454332 1.395784 1.337235 1.278686 1.220137).map Float.toBits))
#eval IO.println ("dishReflect " ++ toString ((dishReflect 0.284275 0.225726 1.767177 1.708628 1.650080 1.591531 1.532982 1.474433 1.415884 1.357336 1.298787 1.240238 1.181689 1.123140 1.064592 1.006043 0.947494 0.888945).map Float.toBits))
#eval IO.println ("dishReflect " ++ toString ((dishReflect 1.553083 1.494534 1.435985 1.377436 1.318888 1.260339 1.201790 1.143241 1.084692 1.026144 0.967595 0.909046 0.850497 0.791948 0.733400 0.674851 0.616302 0.557753).map Float.toBits))

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

#eval IO.println ("dot3 " ++ toString (dot3 1.470859 1.412310 1.353761 1.295212 1.236664 1.178115).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 1.139667 1.081118 1.022569 0.964020 0.905472 0.846923).toBits)
#eval IO.println ("dot3 " ++ toString (dot3 0.808475 0.749926 0.691377 0.632828 0.574280 0.515731).toBits)

def dpLam (mu : Float) (L : Float) (v : Float) (D : Float) : Float :=
  (((((32 : Float) * mu) * L) * v) / (D ^ 2))

#eval IO.println ("dpLam " ++ toString (dpLam 1.284707 1.226158 1.167609 1.109060).toBits)
#eval IO.println ("dpLam " ++ toString (dpLam 0.953515 0.894966 0.836417 0.777868).toBits)
#eval IO.println ("dpLam " ++ toString (dpLam 0.622323 0.563774 0.505225 0.446676).toBits)

def check_dpLam_darcy (mu : Float) (L : Float) (v : Float) (D : Float) (rho : Float) : Bool :=
  (!((0 : Float) < mu) || (!((0 : Float) < D) || (!((0 : Float) < v) || (!((0 : Float) < rho) || (feq (((((32 : Float) * mu) * L) * v) / (D ^ 2)) ((((((64 : Float) / (((rho * v) * D) / mu)) * (L / D)) * rho) * (v ^ 2)) / (2 : Float)))))))

#eval IO.println ("check_dpLam_darcy " ++ toString (check_dpLam_darcy 1.098555 1.040006 0.981457 0.922908 0.864360))
#eval IO.println ("check_dpLam_darcy " ++ toString (check_dpLam_darcy 0.767363 0.708814 0.650265 0.591716 0.533168))
#eval IO.println ("check_dpLam_darcy " ++ toString (check_dpLam_darcy 0.436171 0.377622 0.319073 0.260524 0.201976))

def check_dpLam_mono (mu : Float) (L : Float) (D : Float) (v1 : Float) (v2 : Float) : Bool :=
  let v12 := (((32 : Float) * mu) * L)
  let v14 := (D ^ 2)
  (!((0 : Float) <= mu) || (!((0 : Float) <= L) || (!((0 : Float) < D) || (!(v1 <= v2) || (((v12 * v1) / v14) <= ((v12 * v2) / v14))))))

#eval IO.println ("check_dpLam_mono " ++ toString (check_dpLam_mono 0.912403 0.853854 0.795305 0.736756 0.678208))
#eval IO.println ("check_dpLam_mono " ++ toString (check_dpLam_mono 0.581211 0.522662 0.464113 0.405564 0.347016))
#eval IO.println ("check_dpLam_mono " ++ toString (check_dpLam_mono 0.250019 1.791470 1.732921 1.674372 1.615824))

def dpTurb (fD : Float) (L : Float) (D : Float) (rho : Float) (v : Float) : Float :=
  ((((fD * (L / D)) * rho) * (v ^ 2)) / (2 : Float))

#eval IO.println ("dpTurb " ++ toString (dpTurb 0.726251 0.667702 0.609153 0.550604 0.492056).toBits)
#eval IO.println ("dpTurb " ++ toString (dpTurb 0.395059 0.336510 0.277961 0.219412 1.760864).toBits)
#eval IO.println ("dpTurb " ++ toString (dpTurb 1.663867 1.605318 1.546769 1.488220 1.429672).toBits)

def driveAz (u : Float) (rw : Float) (R : Float) : Float :=
  (((u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("driveAz " ++ toString (driveAz 0.540099 0.481550 0.423001).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 0.208907 1.750358 1.691809).toBits)
#eval IO.println ("driveAz " ++ toString (driveAz 1.477715 1.419166 1.360617).toBits)

def check_driveAz_rate (u : Float) (rw : Float) (R : Float) : Bool :=
  let v11 := (u * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rw (0 : Float))) || (!(!(feq R (0 : Float))) || (feq ((((v11 * R) / rw) * rw) / R) v11)))

#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 0.353947 0.295398 0.236849))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 1.622755 1.564206 1.505657))
#eval IO.println ("check_driveAz_rate " ++ toString (check_driveAz_rate 1.291563 1.233014 1.174465))

def driveEl (u : Float) (arm : Float) (rDrum : Float) : Float :=
  (((u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("driveEl " ++ toString (driveEl 1.767795 1.709246 1.650697).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 1.436603 1.378054 1.319505).toBits)
#eval IO.println ("driveEl " ++ toString (driveEl 1.105411 1.046862 0.988313).toBits)

def check_driveEl_rate (u : Float) (arm : Float) (rDrum : Float) : Bool :=
  let v11 := (u * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)))
  (!(!(feq rDrum (0 : Float))) || (!(!(feq arm (0 : Float))) || (feq ((((v11 * arm) / rDrum) * rDrum) / arm) v11)))

#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 1.581643 1.523094 1.464545))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 1.250451 1.191902 1.133353))
#eval IO.println ("check_driveEl_rate " ++ toString (check_driveEl_rate 0.919259 0.860710 0.802161))

def check_drive_recip_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v21 := (Float.sqrt ((v16 ^ 2) + (c_apexH ^ 2)))
  let v23 := (-((F * v16) / v21))
  let v25 := ((F * c_apexH) / v21)
  (feq (((((((0 : Float) * ((v16 * (0 : Float)) - (b_zRail * v25))) + ((0 : Float) * ((b_zRail * v23) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v25) - (v16 * v23)))) + ((0 : Float) * v23)) + ((0 : Float) * v25)) + ((0 : Float) * (0 : Float))) (F * v21))

#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.395491 1.336942 1.278393 1.219844 1.161296 1.102747 1.044198 0.985649 0.927100 0.868552 0.810003 0.751454 0.692905))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 1.064299 1.005750 0.947201 0.888652 0.830104 0.771555 0.713006 0.654457 0.595908 0.537360 0.478811 0.420262 0.361713))
#eval IO.println ("check_drive_recip_yaw " ++ toString (check_drive_recip_yaw 0.733107 0.674558 0.616009 0.557460 0.498912 0.440363 0.381814 0.323265 0.264716 0.206168 1.747619 1.689070 1.630521))

def check_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v17 := (c_chord / (2 : Float))
  let v22 := (Float.sqrt ((v17 ^ 2) + (c_apexH ^ 2)))
  let v24 := (-((F * v17) / v22))
  let v26 := ((F * c_apexH) / v22)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v17 * (0 : Float)) - (b_zRail * v26))) + ((0 : Float) * ((b_zRail * v24) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v26) - (v17 * v24)))) + ((0 : Float) * v24)) + ((0 : Float) * v26)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 1.209339 1.150790 1.092241 1.033692 0.975144 0.916595 0.858046 0.799497 0.740948 0.682400 0.623851 0.565302 0.506753))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.878147 0.819598 0.761049 0.702500 0.643952 0.585403 0.526854 0.468305 0.409756 0.351208 0.292659 0.234110 1.775561))
#eval IO.println ("check_drive_works_on_yaw " ++ toString (check_drive_works_on_yaw 0.546955 0.488406 0.429857 0.371308 0.312760 0.254211 1.795662 1.737113 1.678564 1.620016 1.561467 1.502918 1.444369))

def edgeClipAt (a : Float) (ze : Float) (t : Float) : Array Float :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  #[((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))]

#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 1.023187 0.964638 0.906089).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.691995 0.633446 0.574897).map Float.toBits))
#eval IO.println ("edgeClipAt " ++ toString ((edgeClipAt 0.360803 0.302254 0.243705).map Float.toBits))

def check_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  (feq (((-ym) * (((-v6) * v10) + (v9 * v7))) - (hp * ((v6 * v7) + (v9 * v10)))) ((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)))

#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.837035 0.778486 0.719937 0.661388 0.602840))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 0.505843 0.447294 0.388745 0.330196 0.271648))
#eval IO.println ("check_edgeClip_cross " ++ toString (check_edgeClip_cross 1.774651 1.716102 1.657553 1.599004 1.540456))

def check_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  (feq ((((v3 * v4) + (v6 * v7)) ^ 2) + ((((-v3) * v7) + (v6 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.650883 0.592334 0.533785))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 0.319691 0.261142 0.202593))
#eval IO.println ("check_edgeClip_radius " ++ toString (check_edgeClip_radius 1.588499 1.529950 1.471401))

def check_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v6 := (Float.sqrt (3.36 : Float))
  let v9 := (-(v6 - (1 : Float)))
  let v10 := (Float.sin t)
  (feq ((((v2 * v3) + (v9 * v10)) ^ 2) + ((((-v2) * v10) + (v9 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v6)))

#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 0.464731))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.733539))
#eval IO.println ("check_edgeClip_radius_hashemi " ++ toString (check_edgeClip_radius_hashemi 1.402347))

def check_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v6 := (-ze)
  let v7 := (Float.sin t)
  ((Float.abs ((v3 * v4) + (v6 * v7))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 0.278579 0.220030 1.761481))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.547387 1.488838 1.430289))
#eval IO.println ("check_edgeClip_reach " ++ toString (check_edgeClip_reach 1.216195 1.157646 1.099097))

def edgeDepth (f : Float) (a : Float) (sag : Float) (el : Float) : Float :=
  (((f - sag) * (Float.sin el)) + (a * (Float.cos el)))

#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.692427 1.633878 1.575329 1.516780).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.361235 1.302686 1.244137 1.185588).toBits)
#eval IO.println ("edgeDepth " ++ toString (edgeDepth 1.030043 0.971494 0.912945 0.854396).toBits)

def check_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.506275 1.447726 1.389177))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 1.175083 1.116534 1.057985))
#eval IO.println ("check_edgeDepth_horizon " ++ toString (check_edgeDepth_horizon 0.843891 0.785342 0.726793))

def check_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 1.320123 1.261574 1.203025 1.144476))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.988931 0.930382 0.871833 0.813284))
#eval IO.println ("check_edgeDepth_le " ++ toString (check_edgeDepth_le 0.657739 0.599190 0.540641 0.482092))

def check_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 1.133971 1.075422 1.016873))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.802779 0.744230 0.685681))
#eval IO.println ("check_edgeDepth_noon " ++ toString (check_edgeDepth_noon 0.471587 0.413038 0.354489))

def check_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v10 := (Float.cos t)
  let v17 := (-a)
  let v19 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v10 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v17) * v5) + (v19 * v10))) - (hp * ((v17 * v10) + (v19 * v5)))) (0 : Float)))

#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.947819 0.889270 0.830721 0.772172 0.713624))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.616627 0.558078 0.499529 0.440980 0.382432))
#eval IO.println ("check_edgeLever_dead " ++ toString (check_edgeLever_dead 0.285435 0.226886 1.768337 1.709788 1.651240))

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

#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.761667 0.703118 0.644569 0.586020 0.527472))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 0.430475 0.371926 0.313377 0.254828 1.796280))
#eval IO.println ("check_edgeLever_pos_iff " ++ toString (check_edgeLever_pos_iff 1.699283 1.640734 1.582185 1.523636 1.465088))

def effCounter (NTU : Float) (Cr : Float) : Float :=
  let v10 := (Float.exp ((-NTU) * ((1 : Float) - Cr)))
  (if ((0.999 : Float) < Cr) then (NTU / ((1 : Float) + NTU)) else (((1 : Float) - v10) / ((1 : Float) - (Cr * v10))))

#eval IO.println ("effCounter " ++ toString (effCounter 0.575515 0.516966).toBits)
#eval IO.println ("effCounter " ++ toString (effCounter 0.244323 1.785774).toBits)
#eval IO.println ("effCounter " ++ toString (effCounter 1.513131 1.454582).toBits)

def effNtu (NTU : Float) : Float :=
  ((1 : Float) - (Float.exp (-NTU)))

#eval IO.println ("effNtu " ++ toString (effNtu 0.389363).toBits)
#eval IO.println ("effNtu " ++ toString (effNtu 1.658171).toBits)
#eval IO.println ("effNtu " ++ toString (effNtu 1.326979).toBits)

def check_effNtu_mem (NTU : Float) : Bool :=
  let v6 := ((1 : Float) - (Float.exp (-NTU)))
  (!((0 : Float) <= NTU) || (((0 : Float) <= v6) && (v6 <= (1 : Float))))

#eval IO.println ("check_effNtu_mem " ++ toString (check_effNtu_mem 0.203211))
#eval IO.println ("check_effNtu_mem " ++ toString (check_effNtu_mem 1.472019))
#eval IO.println ("check_effNtu_mem " ++ toString (check_effNtu_mem 1.140827))

def check_effNtu_mono (N1 : Float) (N2 : Float) : Bool :=
  (!(N1 <= N2) || (((1 : Float) - (Float.exp (-N1))) <= ((1 : Float) - (Float.exp (-N2)))))

#eval IO.println ("check_effNtu_mono " ++ toString (check_effNtu_mono 1.617059 1.558510))
#eval IO.println ("check_effNtu_mono " ++ toString (check_effNtu_mono 1.285867 1.227318))
#eval IO.println ("check_effNtu_mono " ++ toString (check_effNtu_mono 0.954675 0.896126))

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

#eval IO.println ("elPower " ++ toString (elPower 1.058603 1.000054 0.941505 0.882956).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.727411 0.668862 0.610313 0.551764).toBits)
#eval IO.println ("elPower " ++ toString (elPower 0.396219 0.337670 0.279121 0.220572).toBits)

def check_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v9 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v9 / rw) * (rw * omega)) (v9 * omega)))

#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.872451 0.813902 0.755353 0.696804 0.638256))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.541259 0.482710 0.424161 0.365612 0.307064))
#eval IO.println ("check_elPower_eq_wire " ++ toString (check_elPower_eq_wire 0.210067 1.751518 1.692969 1.634420 1.575872))

def check_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v8 * (Float.sin t)) * omega) <= (v8 * omega)))))

#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.686299 0.627750 0.569201 0.510652))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 0.355107 0.296558 0.238009 1.779460))
#eval IO.println ("check_elPower_le " ++ toString (check_elPower_le 1.623915 1.565366 1.506817 1.448268))

def elRate (omegad : Float) (rDrum : Float) (rw : Float) : Float :=
  ((omegad * rDrum) / rw)

#eval IO.println ("elRate " ++ toString (elRate 0.500147 0.441598 0.383049).toBits)
#eval IO.println ("elRate " ++ toString (elRate 1.768955 1.710406 1.651857).toBits)
#eval IO.println ("elRate " ++ toString (elRate 1.437763 1.379214 1.320665).toBits)

def expansionFrac (Tfill : Float) (T : Float) : Float :=
  let v3 := (Tfill - (273.15 : Float))
  let v12 := (T - (273.15 : Float))
  (((((1020.62 : Float) - ((0.614254 : Float) * v3)) - ((0.000321 : Float) * (v3 ^ 2))) / (((1020.62 : Float) - ((0.614254 : Float) * v12)) - ((0.000321 : Float) * (v12 ^ 2)))) - (1 : Float))

#eval IO.println ("expansionFrac " ++ toString (expansionFrac 0.313995 0.255446).toBits)
#eval IO.println ("expansionFrac " ++ toString (expansionFrac 1.582803 1.524254).toBits)
#eval IO.println ("expansionFrac " ++ toString (expansionFrac 1.251611 1.193062).toBits)

def facetSpot (w : Float) (f : Float) : Float :=
  (w + (f * (0.0093 : Float)))

#eval IO.println ("facetSpot " ++ toString (facetSpot 1.727843 1.669294).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.396651 1.338102).toBits)
#eval IO.println ("facetSpot " ++ toString (facetSpot 1.065459 1.006910).toBits)

def check_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))
#eval IO.println ("check_facetSpot_hashemi " ++ toString (check_facetSpot_hashemi))

def filmTemp (Tbulk : Float) (qFlux : Float) (h : Float) : Float :=
  (Tbulk + (qFlux / h))

#eval IO.println ("filmTemp " ++ toString (filmTemp 1.355539 1.296990 1.238441).toBits)
#eval IO.println ("filmTemp " ++ toString (filmTemp 1.024347 0.965798 0.907249).toBits)
#eval IO.println ("filmTemp " ++ toString (filmTemp 0.693155 0.634606 0.576057).toBits)

def check_filmTemp_ge_bulk (Tbulk : Float) (qFlux : Float) (h : Float) : Bool :=
  (!((0 : Float) <= qFlux) || (!((0 : Float) < h) || (Tbulk <= (Tbulk + (qFlux / h)))))

#eval IO.println ("check_filmTemp_ge_bulk " ++ toString (check_filmTemp_ge_bulk 1.169387 1.110838 1.052289))
#eval IO.println ("check_filmTemp_ge_bulk " ++ toString (check_filmTemp_ge_bulk 0.838195 0.779646 0.721097))
#eval IO.println ("check_filmTemp_ge_bulk " ++ toString (check_filmTemp_ge_bulk 0.507003 0.448454 0.389905))

def check_film_above_bulk  : Bool :=
  ((618.15 : Float) < (648.15 : Float))

#eval IO.println ("check_film_above_bulk " ++ toString (check_film_above_bulk))
#eval IO.println ("check_film_above_bulk " ++ toString (check_film_above_bulk))
#eval IO.println ("check_film_above_bulk " ++ toString (check_film_above_bulk))

def check_film_limit_reachable (alpha : Float) (eps : Float) (Ac : Float) (V : Float) (Pin : Float) (Ta : Float) : Bool :=
  (!((0.9 : Float) <= alpha) || (!(alpha <= (1 : Float)) || (!((0 : Float) <= eps) || (!(eps <= (1 : Float)) || (!((0 : Float) <= Ac) || (!(Ac <= (0.03 : Float)) || (!((0 : Float) <= V) || (!(V <= (9 : Float)) || (!((6000 : Float) <= Pin) || (!((280 : Float) <= Ta) || (!(Ta <= (320 : Float)) || ((4000 : Float) <= ((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * (((648.15 : Float) ^ 4) - (Ta ^ 4))) + ((((5.7 : Float) + ((3.8 : Float) * V)) * Ac) * ((648.15 : Float) - Ta))))))))))))))))

#eval IO.println ("check_film_limit_reachable " ++ toString (check_film_limit_reachable 0.797083 0.738534 0.679985 0.621436 0.562888 0.504339))
#eval IO.println ("check_film_limit_reachable " ++ toString (check_film_limit_reachable 0.465891 0.407342 0.348793 0.290244 0.231696 1.773147))
#eval IO.println ("check_film_limit_reachable " ++ toString (check_film_limit_reachable 1.734699 1.676150 1.617601 1.559052 1.500504 1.441955))

def focusShift (h : Float) (eps : Float) : Float :=
  (h * (Float.sin eps))

#eval IO.println ("focusShift " ++ toString (focusShift 0.610931 0.552382).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 0.279739 0.221190).toBits)
#eval IO.println ("focusShift " ++ toString (focusShift 1.548547 1.489998).toBits)

def check_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v1 := (Float.cos psi)
  let v7 := (Float.sin psi)
  (!(!(feq v1 (1 : Float))) || (!((feq ((v1 * p_1) - (v7 * p_2)) p_1) && (feq ((v7 * p_1) + (v1 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 0.424779 0.366230 0.307681))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.693587 1.635038 1.576489))
#eval IO.println ("check_focus_on_axis " ++ toString (check_focus_on_axis 1.362395 1.303846 1.245297))

def follower (eAz : Float) (eEl : Float) (dt : Float) : Array Float :=
  let v8 := ((((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)) * dt)
  let v16 := ((((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)) * dt)
  #[((max (-v8) (min eAz v8)) / v8), ((max (-v16) (min eEl v16)) / v16)]

#eval IO.println ("follower " ++ toString ((follower 0.238627 1.780078 1.721529).map Float.toBits))
#eval IO.println ("follower " ++ toString ((follower 1.507435 1.448886 1.390337).map Float.toBits))
#eval IO.println ("follower " ++ toString ((follower 1.176243 1.117694 1.059145).map Float.toBits))

def check_follower_bounded (eAz : Float) (eEl : Float) (dt : Float) : Bool :=
  let v10 := ((((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)) * dt)
  let v18 := ((((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)) * dt)
  (!((0 : Float) < dt) || (((Float.abs ((max (-v10) (min eAz v10)) / v10)) <= (1 : Float)) && ((Float.abs ((max (-v18) (min eEl v18)) / v18)) <= (1 : Float))))

#eval IO.println ("check_follower_bounded " ++ toString (check_follower_bounded 1.652475 1.593926 1.535377))
#eval IO.println ("check_follower_bounded " ++ toString (check_follower_bounded 1.321283 1.262734 1.204185))
#eval IO.println ("check_follower_bounded " ++ toString (check_follower_bounded 0.990091 0.931542 0.872993))

def check_follower_step_az (eAz : Float) (eEl : Float) (dt : Float) : Bool :=
  let v11 := ((((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float)) * dt)
  (!((0 : Float) < dt) || (!((Float.abs eAz) <= v11) || (feq (eAz - (v11 * ((max (-v11) (min eAz v11)) / v11))) (0 : Float))))

#eval IO.println ("check_follower_step_az " ++ toString (check_follower_step_az 1.466323 1.407774 1.349225))
#eval IO.println ("check_follower_step_az " ++ toString (check_follower_step_az 1.135131 1.076582 1.018033))
#eval IO.println ("check_follower_step_az " ++ toString (check_follower_step_az 0.803939 0.745390 0.686841))

def check_follower_step_el (eAz : Float) (eEl : Float) (dt : Float) : Bool :=
  let v11 := ((((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float)) * dt)
  (!((0 : Float) < dt) || (!((Float.abs eEl) <= v11) || (feq (eEl - (v11 * ((max (-v11) (min eEl v11)) / v11))) (0 : Float))))

#eval IO.println ("check_follower_step_el " ++ toString (check_follower_step_el 1.280171 1.221622 1.163073))
#eval IO.println ("check_follower_step_el " ++ toString (check_follower_step_el 0.948979 0.890430 0.831881))
#eval IO.println ("check_follower_step_el " ++ toString (check_follower_step_el 0.617787 0.559238 0.500689))

def frictionBlasius (Re : Float) : Float :=
  ((0.3164 : Float) / (Float.sqrt (Float.sqrt (max Re (1 : Float)))))

#eval IO.println ("frictionBlasius " ++ toString (frictionBlasius 1.094019).toBits)
#eval IO.println ("frictionBlasius " ++ toString (frictionBlasius 0.762827).toBits)
#eval IO.println ("frictionBlasius " ++ toString (frictionBlasius 0.431635).toBits)

def frictionLam (Re : Float) : Float :=
  ((64 : Float) / (max Re (0.000000001 : Float)))

#eval IO.println ("frictionLam " ++ toString (frictionLam 0.907867).toBits)
#eval IO.println ("frictionLam " ++ toString (frictionLam 0.576675).toBits)
#eval IO.println ("frictionLam " ++ toString (frictionLam 0.245483).toBits)

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

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.535563 0.477014 0.418465 0.359916 0.301368 0.242819 1.784270 1.725721 1.667172 1.608624 1.550075 1.491526))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.204371 1.745822 1.687273 1.628724 1.570176 1.511627 1.453078 1.394529 1.335980 1.277432 1.218883 1.160334))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.473179 1.414630 1.356081 1.297532 1.238984 1.180435 1.121886 1.063337 1.004788 0.946240 0.887691 0.829142))

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

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.349411 0.290862 0.232313 1.773764 1.715216 1.656667 1.598118 1.539569 1.481020 1.422472 1.363923 1.305374))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.618219 1.559670 1.501121 1.442572 1.384024 1.325475 1.266926 1.208377 1.149828 1.091280 1.032731 0.974182))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.287027 1.228478 1.169929 1.111380 1.052832 0.994283 0.935734 0.877185 0.818636 0.760088 0.701539 0.642990))

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

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.763259 1.704710 1.646161 1.587612 1.529064 1.470515 1.411966 1.353417 1.294868 1.236320 1.177771 1.119222))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.432067 1.373518 1.314969 1.256420 1.197872 1.139323 1.080774 1.022225 0.963676 0.905128 0.846579 0.788030))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 1.100875 1.042326 0.983777 0.925228 0.866680 0.808131 0.749582 0.691033 0.632484 0.573936 0.515387 0.456838))

def hCoil (Q : Float) (D : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  let v10 := (v4 ^ 2)
  let v29 := ((Float.exp (((586.375 : Float) / (v4 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v30 := ((((((1020.62 : Float) - ((0.614254 : Float) * v4)) - ((0.000321 : Float) * v10)) * (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))) * D) / v29)
  let v58 := (((0.118294 : Float) - ((0.000033 : Float) * v4)) - ((0.00000015 : Float) * v10))
  (((if (v30 < (2300 : Float)) then (4.364 : Float) else (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max v30 (1 : Float)))))) * (Float.exp ((0.4 : Float) * (Float.log (max ((v29 * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * v10)))) / v58) (0.01 : Float))))))) * v58) / D)

#eval IO.println ("hCoil " ++ toString (hCoil 1.577107 1.518558 1.460009).toBits)
#eval IO.println ("hCoil " ++ toString (hCoil 1.245915 1.187366 1.128817).toBits)
#eval IO.println ("hCoil " ++ toString (hCoil 0.914723 0.856174 0.797625).toBits)

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hWind (V : Float) : Float :=
  ((5.7 : Float) + ((3.8 : Float) * V))

#eval IO.println ("hWind " ++ toString (hWind 1.204803).toBits)
#eval IO.println ("hWind " ++ toString (hWind 0.873611).toBits)
#eval IO.println ("hWind " ++ toString (hWind 0.542419).toBits)

def check_hWind_mono (V1 : Float) (V2 : Float) : Bool :=
  (!(V1 <= V2) || (((5.7 : Float) + ((3.8 : Float) * V1)) <= ((5.7 : Float) + ((3.8 : Float) * V2))))

#eval IO.println ("check_hWind_mono " ++ toString (check_hWind_mono 1.018651 0.960102))
#eval IO.println ("check_hWind_mono " ++ toString (check_hWind_mono 0.687459 0.628910))
#eval IO.println ("check_hWind_mono " ++ toString (check_hWind_mono 0.356267 0.297718))

def check_hWind_pos (V : Float) : Bool :=
  (!((0 : Float) <= V) || ((0 : Float) < ((5.7 : Float) + ((3.8 : Float) * V))))

#eval IO.println ("check_hWind_pos " ++ toString (check_hWind_pos 0.832499))
#eval IO.println ("check_hWind_pos " ++ toString (check_hWind_pos 0.501307))
#eval IO.println ("check_hWind_pos " ++ toString (check_hWind_pos 1.770115))

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 0.646347 0.587798 0.529249 0.470700).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 0.315155 0.256606 1.798057 1.739508).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.583963 1.525414 1.466865 1.408316).toBits)

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

def hashemiEnv (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (Twall : Float) (Ta : Float) (uPump : Float) (Qmax : Float) (Dp : Float) (Lp : Float) (Dins : Float) (kIns : Float) (Vw : Float) (etaP : Float) (Pidle : Float) (Axch : Float) (UAxMax : Float) (Ccoil : Float) (degPrev : Float) (degA : Float) (degEa : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Array Float :=
  let v729 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v741 := ((1.22 : Float) * (0.8 : Float))
  let v742 := ((0.34 : Float) * v729)
  let v745 := ((3.141592653589793 : Float) / (2 : Float))
  let v752 := (if (v741 <= v742) then v745 else (Float.atan ((((1.22 : Float) * v729) + ((0.34 : Float) * (0.8 : Float))) / (v741 - v742))))
  let v753 := (-(1.22 : Float))
  let v754 := (-(0.8 : Float))
  let v756 := (Float.cos (0 : Float))
  let v758 := (-v729)
  let v759 := (Float.sin (0 : Float))
  let v762 := (-v754)
  let v771 := (Float.sqrt (((((v754 * v756) + (v758 * v759)) - v753) ^ 2) + ((((v762 * v759) + (v758 * v756)) - (0.34 : Float)) ^ 2)))
  let v772 := (Float.cos v752)
  let v774 := (Float.sin v752)
  let v785 := (Float.sqrt (((((v754 * v772) + (v758 * v774)) - v753) ^ 2) + ((((v762 * v774) + (v758 * v772)) - (0.34 : Float)) ^ 2)))
  let v786 := (Float.cos t)
  let v788 := (Float.sin t)
  let v790 := ((v754 * v786) + (v758 * v788))
  let v793 := ((v762 * v788) + (v758 * v786))
  let v799 := (Float.sqrt (((v790 - v753) ^ 2) + ((v793 - (0.34 : Float)) ^ 2)))
  let v801 := (omegad * rDrum)
  let v803 := ((v799 + slack) - (v801 * dt))
  let v804 := (v803 < v785)
  let v805 := (v771 < v803)
  let v807 := (if v804 then v785 else (if v805 then v771 else v803))
  let v812 := (((0 : Float) + v752) / (2 : Float))
  let v813 := (Float.cos v812)
  let v815 := (Float.sin v812)
  let v827 := (v807 < (Float.sqrt (((((v754 * v813) + (v758 * v815)) - v753) ^ 2) + ((((v762 * v815) + (v758 * v813)) - (0.34 : Float)) ^ 2))))
  let v828 := (if v827 then v812 else (0 : Float))
  let v829 := (if v827 then v752 else v812)
  let v831 := ((v828 + v829) / (2 : Float))
  let v832 := (Float.cos v831)
  let v834 := (Float.sin v831)
  let v846 := (v807 < (Float.sqrt (((((v754 * v832) + (v758 * v834)) - v753) ^ 2) + ((((v762 * v834) + (v758 * v832)) - (0.34 : Float)) ^ 2))))
  let v847 := (if v846 then v831 else v828)
  let v848 := (if v846 then v829 else v831)
  let v850 := ((v847 + v848) / (2 : Float))
  let v851 := (Float.cos v850)
  let v853 := (Float.sin v850)
  let v865 := (v807 < (Float.sqrt (((((v754 * v851) + (v758 * v853)) - v753) ^ 2) + ((((v762 * v853) + (v758 * v851)) - (0.34 : Float)) ^ 2))))
  let v866 := (if v865 then v850 else v847)
  let v867 := (if v865 then v848 else v850)
  let v869 := ((v866 + v867) / (2 : Float))
  let v870 := (Float.cos v869)
  let v872 := (Float.sin v869)
  let v884 := (v807 < (Float.sqrt (((((v754 * v870) + (v758 * v872)) - v753) ^ 2) + ((((v762 * v872) + (v758 * v870)) - (0.34 : Float)) ^ 2))))
  let v885 := (if v884 then v869 else v866)
  let v886 := (if v884 then v867 else v869)
  let v888 := ((v885 + v886) / (2 : Float))
  let v889 := (Float.cos v888)
  let v891 := (Float.sin v888)
  let v903 := (v807 < (Float.sqrt (((((v754 * v889) + (v758 * v891)) - v753) ^ 2) + ((((v762 * v891) + (v758 * v889)) - (0.34 : Float)) ^ 2))))
  let v904 := (if v903 then v888 else v885)
  let v905 := (if v903 then v886 else v888)
  let v907 := ((v904 + v905) / (2 : Float))
  let v908 := (Float.cos v907)
  let v910 := (Float.sin v907)
  let v922 := (v807 < (Float.sqrt (((((v754 * v908) + (v758 * v910)) - v753) ^ 2) + ((((v762 * v910) + (v758 * v908)) - (0.34 : Float)) ^ 2))))
  let v923 := (if v922 then v907 else v904)
  let v924 := (if v922 then v905 else v907)
  let v926 := ((v923 + v924) / (2 : Float))
  let v927 := (Float.cos v926)
  let v929 := (Float.sin v926)
  let v941 := (v807 < (Float.sqrt (((((v754 * v927) + (v758 * v929)) - v753) ^ 2) + ((((v762 * v929) + (v758 * v927)) - (0.34 : Float)) ^ 2))))
  let v942 := (if v941 then v926 else v923)
  let v943 := (if v941 then v924 else v926)
  let v945 := ((v942 + v943) / (2 : Float))
  let v946 := (Float.cos v945)
  let v948 := (Float.sin v945)
  let v960 := (v807 < (Float.sqrt (((((v754 * v946) + (v758 * v948)) - v753) ^ 2) + ((((v762 * v948) + (v758 * v946)) - (0.34 : Float)) ^ 2))))
  let v961 := (if v960 then v945 else v942)
  let v962 := (if v960 then v943 else v945)
  let v964 := ((v961 + v962) / (2 : Float))
  let v965 := (Float.cos v964)
  let v967 := (Float.sin v964)
  let v979 := (v807 < (Float.sqrt (((((v754 * v965) + (v758 * v967)) - v753) ^ 2) + ((((v762 * v967) + (v758 * v965)) - (0.34 : Float)) ^ 2))))
  let v980 := (if v979 then v964 else v961)
  let v981 := (if v979 then v962 else v964)
  let v983 := ((v980 + v981) / (2 : Float))
  let v984 := (Float.cos v983)
  let v986 := (Float.sin v983)
  let v998 := (v807 < (Float.sqrt (((((v754 * v984) + (v758 * v986)) - v753) ^ 2) + ((((v762 * v986) + (v758 * v984)) - (0.34 : Float)) ^ 2))))
  let v999 := (if v998 then v983 else v980)
  let v1000 := (if v998 then v981 else v983)
  let v1002 := ((v999 + v1000) / (2 : Float))
  let v1003 := (Float.cos v1002)
  let v1005 := (Float.sin v1002)
  let v1017 := (v807 < (Float.sqrt (((((v754 * v1003) + (v758 * v1005)) - v753) ^ 2) + ((((v762 * v1005) + (v758 * v1003)) - (0.34 : Float)) ^ 2))))
  let v1018 := (if v1017 then v1002 else v999)
  let v1019 := (if v1017 then v1000 else v1002)
  let v1021 := ((v1018 + v1019) / (2 : Float))
  let v1022 := (Float.cos v1021)
  let v1024 := (Float.sin v1021)
  let v1036 := (v807 < (Float.sqrt (((((v754 * v1022) + (v758 * v1024)) - v753) ^ 2) + ((((v762 * v1024) + (v758 * v1022)) - (0.34 : Float)) ^ 2))))
  let v1037 := (if v1036 then v1021 else v1018)
  let v1038 := (if v1036 then v1019 else v1021)
  let v1040 := ((v1037 + v1038) / (2 : Float))
  let v1041 := (Float.cos v1040)
  let v1043 := (Float.sin v1040)
  let v1055 := (v807 < (Float.sqrt (((((v754 * v1041) + (v758 * v1043)) - v753) ^ 2) + ((((v762 * v1043) + (v758 * v1041)) - (0.34 : Float)) ^ 2))))
  let v1056 := (if v1055 then v1040 else v1037)
  let v1057 := (if v1055 then v1038 else v1040)
  let v1059 := ((v1056 + v1057) / (2 : Float))
  let v1060 := (Float.cos v1059)
  let v1062 := (Float.sin v1059)
  let v1074 := (v807 < (Float.sqrt (((((v754 * v1060) + (v758 * v1062)) - v753) ^ 2) + ((((v762 * v1062) + (v758 * v1060)) - (0.34 : Float)) ^ 2))))
  let v1075 := (if v1074 then v1059 else v1056)
  let v1076 := (if v1074 then v1057 else v1059)
  let v1078 := ((v1075 + v1076) / (2 : Float))
  let v1079 := (Float.cos v1078)
  let v1081 := (Float.sin v1078)
  let v1093 := (v807 < (Float.sqrt (((((v754 * v1079) + (v758 * v1081)) - v753) ^ 2) + ((((v762 * v1081) + (v758 * v1079)) - (0.34 : Float)) ^ 2))))
  let v1094 := (if v1093 then v1078 else v1075)
  let v1095 := (if v1093 then v1076 else v1078)
  let v1097 := ((v1094 + v1095) / (2 : Float))
  let v1098 := (Float.cos v1097)
  let v1100 := (Float.sin v1097)
  let v1112 := (v807 < (Float.sqrt (((((v754 * v1098) + (v758 * v1100)) - v753) ^ 2) + ((((v762 * v1100) + (v758 * v1098)) - (0.34 : Float)) ^ 2))))
  let v1113 := (if v1112 then v1097 else v1094)
  let v1114 := (if v1112 then v1095 else v1097)
  let v1116 := ((v1113 + v1114) / (2 : Float))
  let v1117 := (Float.cos v1116)
  let v1119 := (Float.sin v1116)
  let v1131 := (v807 < (Float.sqrt (((((v754 * v1117) + (v758 * v1119)) - v753) ^ 2) + ((((v762 * v1119) + (v758 * v1117)) - (0.34 : Float)) ^ 2))))
  let v1132 := (if v1131 then v1116 else v1113)
  let v1133 := (if v1131 then v1114 else v1116)
  let v1135 := ((v1132 + v1133) / (2 : Float))
  let v1136 := (Float.cos v1135)
  let v1138 := (Float.sin v1135)
  let v1150 := (v807 < (Float.sqrt (((((v754 * v1136) + (v758 * v1138)) - v753) ^ 2) + ((((v762 * v1138) + (v758 * v1136)) - (0.34 : Float)) ^ 2))))
  let v1151 := (if v1150 then v1135 else v1132)
  let v1152 := (if v1150 then v1133 else v1135)
  let v1154 := ((v1151 + v1152) / (2 : Float))
  let v1155 := (Float.cos v1154)
  let v1157 := (Float.sin v1154)
  let v1169 := (v807 < (Float.sqrt (((((v754 * v1155) + (v758 * v1157)) - v753) ^ 2) + ((((v762 * v1157) + (v758 * v1155)) - (0.34 : Float)) ^ 2))))
  let v1170 := (if v1169 then v1154 else v1151)
  let v1171 := (if v1169 then v1152 else v1154)
  let v1173 := ((v1170 + v1171) / (2 : Float))
  let v1174 := (Float.cos v1173)
  let v1176 := (Float.sin v1173)
  let v1188 := (v807 < (Float.sqrt (((((v754 * v1174) + (v758 * v1176)) - v753) ^ 2) + ((((v762 * v1176) + (v758 * v1174)) - (0.34 : Float)) ^ 2))))
  let v1189 := (if v1188 then v1173 else v1170)
  let v1190 := (if v1188 then v1171 else v1173)
  let v1192 := ((v1189 + v1190) / (2 : Float))
  let v1193 := (Float.cos v1192)
  let v1195 := (Float.sin v1192)
  let v1207 := (v807 < (Float.sqrt (((((v754 * v1193) + (v758 * v1195)) - v753) ^ 2) + ((((v762 * v1195) + (v758 * v1193)) - (0.34 : Float)) ^ 2))))
  let v1208 := (if v1207 then v1192 else v1189)
  let v1209 := (if v1207 then v1190 else v1192)
  let v1211 := ((v1208 + v1209) / (2 : Float))
  let v1212 := (Float.cos v1211)
  let v1214 := (Float.sin v1211)
  let v1226 := (v807 < (Float.sqrt (((((v754 * v1212) + (v758 * v1214)) - v753) ^ 2) + ((((v762 * v1214) + (v758 * v1212)) - (0.34 : Float)) ^ 2))))
  let v1227 := (if v1226 then v1211 else v1208)
  let v1228 := (if v1226 then v1209 else v1211)
  let v1230 := ((v1227 + v1228) / (2 : Float))
  let v1231 := (Float.cos v1230)
  let v1233 := (Float.sin v1230)
  let v1245 := (v807 < (Float.sqrt (((((v754 * v1231) + (v758 * v1233)) - v753) ^ 2) + ((((v762 * v1233) + (v758 * v1231)) - (0.34 : Float)) ^ 2))))
  let v1246 := (if v1245 then v1230 else v1227)
  let v1247 := (if v1245 then v1228 else v1230)
  let v1249 := ((v1246 + v1247) / (2 : Float))
  let v1250 := (Float.cos v1249)
  let v1252 := (Float.sin v1249)
  let v1264 := (v807 < (Float.sqrt (((((v754 * v1250) + (v758 * v1252)) - v753) ^ 2) + ((((v762 * v1252) + (v758 * v1250)) - (0.34 : Float)) ^ 2))))
  let v1269 := (if (v771 <= v803) then (0 : Float) else (((if v1264 then v1249 else v1246) + (if v1264 then v1247 else v1249)) / (2 : Float)))
  let v1270 := (W * rcm)
  let v1271 := (Float.cos v1269)
  let v1273 := (Float.sin v1269)
  let v1275 := ((v754 * v1271) + (v758 * v1273))
  let v1278 := ((v762 * v1273) + (v758 * v1271))
  let v1293 := ((t < v1269) && (!(v1270 <= (Tmax * (((v753 * v1278) - ((0.34 : Float) * v1275)) / (Float.sqrt (((v1275 - v753) ^ 2) + ((v1278 - (0.34 : Float)) ^ 2))))))))
  let v1294 := (if v1293 then t else v1269)
  let v1299 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1304 := (Float.cos v1294)
  let v1306 := (Float.sin v1294)
  let v1308 := ((v754 * v1304) + (v758 * v1306))
  let v1311 := ((v762 * v1306) + (v758 * v1304))
  let v1331 := (v788 * (Float.cos az))
  let v1333 := (v788 * (Float.sin az))
  let v1334 := (Float.cos elSun)
  let v1336 := (v1334 * (Float.cos azSun))
  let v1338 := (v1334 * (Float.sin azSun))
  let v1339 := (Float.sin elSun)
  let v1344 := (((v1331 * v1336) + (v1333 * v1338)) + (v786 * v1339))
  let v1359 := (Float.sqrt (((((v1333 * v1339) - (v786 * v1338)) ^ 2) + (((v786 * v1336) - (v1331 * v1339)) ^ 2)) + (((v1331 * v1338) - (v1333 * v1336)) ^ 2)))
  let v1369 := (if (v1344 <= (0 : Float)) then (v745 + (Float.atan ((-v1344) / (max v1359 (0.000000000001 : Float))))) else (Float.atan (v1359 / v1344)))
  let v1371 := (v745 - v752)
  let v1372 := (v1371 <= elSun)
  let v1386 := (Float.cos v1299)
  let v1387 := (v1306 * v1386)
  let v1388 := (Float.sin v1299)
  let v1389 := (v1306 * v1388)
  let v1390 := (v1304 * v1386)
  let v1391 := (v1304 * v1388)
  let v1392 := (-v1306)
  let v1417 := ((2 : Float) * a)
  let v1418 := (v1417 / w)
  let v1420 := (w / (2 : Float))
  let v1421 := ((-a) + v1420)
  let v1440 := ((1 : Float) / (2 : Float))
  let v1445 := (-(((((v1391 * v1304) - (v1392 * v1389)) * v1336) + (((v1392 * v1387) - (v1390 * v1304)) * v1338)) + (((v1390 * v1389) - (v1391 * v1387)) * v1339)))
  let v1446 := (-(((v1390 * v1336) + (v1391 * v1338)) + (v1392 * v1339)))
  let v1447 := (-(((v1387 * v1336) + (v1389 * v1338)) + (v1304 * v1339)))
  let v1452 := ((Float.abs v1447) < ((9 : Float) / (10 : Float)))
  let v1453 := (if v1452 then (0 : Float) else (1 : Float))
  let v1454 := (if v1452 then (1 : Float) else (0 : Float))
  let v1457 := ((v1446 * v1454) - (v1447 * (0 : Float)))
  let v1460 := ((v1447 * v1453) - (v1445 * v1454))
  let v1463 := ((v1445 * (0 : Float)) - (v1446 * v1453))
  let v1471 := (Float.sqrt (max (((v1457 ^ 2) + (v1460 ^ 2)) + (v1463 ^ 2)) (0.000000000000000001 : Float)))
  let v1472 := (v1457 / v1471)
  let v1473 := (v1460 / v1471)
  let v1474 := (v1463 / v1471)
  let v1486 := ((2 : Float) * (3.141592653589793 : Float))
  let v1523 := ((2 : Float) * f)
  let v1524 := ((1 : Float) / R)
  let v1633 := (v1417 ^ 2)
  let v1634 := (v1633 * rho)
  let v1640 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); (if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && (((Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))) <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1643 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + ((dr[i * 10 + 2]! - v1440) * w)); let v1522 := (v1439 + ((dr[i * 10 + 3]! - v1440) * w)); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1615 := ((f - (v1523 + (v1582 * v1509))) / (v1600 / v1610)); (1.0 / (1.0 + Float.exp (-((rc - (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2)))) / (0.005 : Float))))))) 0.0)
  let v1661 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((0 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1666 := (((((v1661 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1677 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((1 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1682 := (((((v1677 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1693 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((2 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1698 := (((((v1693 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1710 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((3 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1715 := (((((v1710 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1727 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((4 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1732 := (((((v1727 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1744 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((5 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1749 := (((((v1744 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1761 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((6 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1766 := (((((v1761 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1778 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((7 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1783 := (((((v1778 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1786 := (Qmax * (min (max uPump (0 : Float)) (1 : Float)))
  let v1789 := (min (618.15 : Float) (max Ta hist[0]!))
  let v1791 := (v1789 - (273.15 : Float))
  let v1797 := (v1791 ^ 2)
  let v1799 := (((1020.62 : Float) - ((0.614254 : Float) * v1791)) - ((0.000321 : Float) * v1797))
  let v1809 := ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v1791)) + ((0.0000008970757 : Float) * v1797)))
  let v1810 := ((v1799 * v1786) * v1809)
  let v1812 := (max v1810 (0.000001 : Float))
  let v1813 := (Ccoil / dt)
  let v1814 := (v1810 + v1813)
  let v1824 := ((5.7 : Float) + ((3.8 : Float) * Vw))
  let v1830 := (Dp ^ 2)
  let v1833 := (v1786 / (((3.141592653589793 : Float) * v1830) / (4 : Float)))
  let v1838 := (min (max ((Lp / (max v1833 (0.000001 : Float))) / dt) (0 : Float)) (7 : Float))
  let v1839 := (v1838 < (1 : Float))
  let v1840 := (v1838 < (2 : Float))
  let v1841 := (v1838 < (3 : Float))
  let v1842 := (v1838 < (4 : Float))
  let v1843 := (v1838 < (5 : Float))
  let v1844 := (v1838 < (6 : Float))
  let v1845 := (v1838 < (7 : Float))
  let v1852 := (if v1839 then hist[0]! else (if v1840 then hist[1]! else (if v1841 then hist[2]! else (if v1842 then hist[3]! else (if v1843 then hist[4]! else (if v1844 then hist[5]! else (if v1845 then hist[6]! else hist[7]!)))))))
  let v1860 := (v1838 - (Float.floor v1838))
  let v1863 := (v1852 + (v1860 * ((if v1839 then hist[1]! else (if v1840 then hist[2]! else (if v1841 then hist[3]! else (if v1842 then hist[4]! else (if v1843 then hist[5]! else (if v1844 then hist[6]! else hist[7]!)))))) - v1852)))
  let v1870 := (if v1839 then ret[0]! else (if v1840 then ret[1]! else (if v1841 then ret[2]! else (if v1842 then ret[3]! else (if v1843 then ret[4]! else (if v1844 then ret[5]! else (if v1845 then ret[6]! else ret[7]!)))))))
  let v1879 := (v1870 + (v1860 * ((if v1839 then ret[1]! else (if v1840 then ret[2]! else (if v1841 then ret[3]! else (if v1842 then ret[4]! else (if v1843 then ret[5]! else (if v1844 then ret[6]! else ret[7]!)))))) - v1870)))
  let v1884 := (Float.exp ((-((Lp / (((Float.log (max (Dins / Dp) (1.0001 : Float))) / (v1486 * kIns)) + ((1 : Float) / ((v1824 * (3.141592653589793 : Float)) * Dins)))) / (2 : Float))) / v1812))
  let v1886 := (Ta + ((v1863 - Ta) * v1884))
  let v1896 := ((Float.exp (((586.375 : Float) / (v1791 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v1897 := (((v1799 * v1833) * Dp) / v1896)
  let v1899 := (v1897 < (2300 : Float))
  let v1902 := (max v1897 (1 : Float))
  let v1915 := (((0.118294 : Float) - ((0.000033 : Float) * v1791)) - ((0.00000015 : Float) * v1797))
  let v1924 := (((if v1899 then (4.364 : Float) else (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log v1902)))) * (Float.exp ((0.4 : Float) * (Float.log (max ((v1896 * v1809) / v1915) (0.01 : Float))))))) * v1915) / Dp)
  let v1935 := ((v1810 * ((1 : Float) - (Float.exp (-((min UAxMax (v1924 * Axch)) / (max v1812 (0.000001 : Float))))))) * (max (0 : Float) (v1886 - Twall)))
  let v1944 := (((v1810 * (Ta + ((v1879 - Ta) * v1884))) + (v1813 * v1789)) / v1814)
  let v1948 := (Ac / (8 : Float))
  let v1949 := ((eps * (0.0000000567 : Float)) * v1948)
  let v1951 := (Ta ^ 4)
  let v1954 := (v1824 * v1948)
  let v1960 := (v1944 + (((alpha * v1666) - ((v1949 * ((v1944 ^ 4) - v1951)) + (v1954 * (v1944 - Ta)))) / v1814))
  let v1970 := (v1960 + (((alpha * v1682) - ((v1949 * ((v1960 ^ 4) - v1951)) + (v1954 * (v1960 - Ta)))) / v1814))
  let v1980 := (v1970 + (((alpha * v1698) - ((v1949 * ((v1970 ^ 4) - v1951)) + (v1954 * (v1970 - Ta)))) / v1814))
  let v1990 := (v1980 + (((alpha * v1715) - ((v1949 * ((v1980 ^ 4) - v1951)) + (v1954 * (v1980 - Ta)))) / v1814))
  let v2000 := (v1990 + (((alpha * v1732) - ((v1949 * ((v1990 ^ 4) - v1951)) + (v1954 * (v1990 - Ta)))) / v1814))
  let v2010 := (v2000 + (((alpha * v1749) - ((v1949 * ((v2000 ^ 4) - v1951)) + (v1954 * (v2000 - Ta)))) / v1814))
  let v2020 := (v2010 + (((alpha * v1766) - ((v1949 * ((v2010 ^ 4) - v1951)) + (v1954 * (v2010 - Ta)))) / v1814))
  let v2030 := (v2020 + (((alpha * v1783) - ((v1949 * ((v2020 ^ 4) - v1951)) + (v1954 * (v2020 - Ta)))) / v1814))
  let v2032 := (min (618.15 : Float) (max Ta v2030))
  let v2040 := (alpha * (((((((v1666 + v1682) + v1698) + v1715) + v1732) + v1749) + v1766) + v1783))
  let v2051 := (v2040 / Ac)
  let v2064 := (max v2032 (min (v2032 + (v2051 / v1924)) (Float.sqrt (Float.sqrt (((max (0 : Float) v2051) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))))
  let v2099 := (azSun - v1299)
  let v2111 := ((293.15 : Float) - (273.15 : Float))
  let v2117 := (v2032 - (273.15 : Float))
  #[v1299, v1294, (if v805 then (v803 - v771) else (0 : Float)), (if v1293 then v799 else v807), v752, (if (v804 || v1293) then (1 : Float) else (0 : Float)), (if (feq (if v805 then (v803 - v771) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1270 <= (Tmax * (((v753 * v1311) - ((0.34 : Float) * v1308)) / (Float.sqrt (((v1308 - v753) ^ 2) + ((v1311 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), (((v753 * v793) - ((0.34 : Float) * v790)) / v799), (v801 / (((v753 * v793) - ((0.34 : Float) * v790)) / v799)), ((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))), v1369, (v745 - t), (if v1372 then (1 : Float) else (0 : Float)), (if (v1372 && ((0.03 : Float) < v1369)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1371) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1371) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1369 - (0.03 : Float)) / (0.01 : Float)))))), (v1640 / (64 : Float)), (v1643 / (64 : Float)), (v1634 * (v1640 / (64 : Float))), (((v1634 * (v1640 / (64 : Float))) * dni) * soil), v2032, v2040, (v2040 - (v1814 * (v2032 - v1944))), (v1810 * ((v1863 - v1886) + (v1879 - (v1886 - (v1935 / v1812))))), v1935, (((v2040 - (v2040 - (v1814 * (v2032 - v1944)))) - (v1810 * ((v1863 - v1886) + (v1879 - (v1886 - (v1935 / v1812)))))) - v1935), (v2099 - (v1486 * (Float.floor ((v2099 + (3.141592653589793 : Float)) / v1486)))), ((v745 - v1294) - elSun), v1294, (if (feq (if v805 then (v803 - v771) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v1270 <= (Tmax * (((v753 * v1311) - ((0.34 : Float) * v1308)) / (Float.sqrt (((v1308 - v753) ^ 2) + ((v1311 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), ((v2032 - (300 : Float)) / (300 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v1371) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v1371) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-((v1369 - (0.03 : Float)) / (0.01 : Float)))))), v1666, v1682, v1698, v1715, v1732, v1749, v1766, v1783, v1960, v1970, v1980, v1990, v2000, v2010, v2020, v2030, v2032, hist[0]!, hist[1]!, hist[2]!, hist[3]!, hist[4]!, hist[5]!, hist[6]!, hist[7]!, hist[8]!, hist[9]!, hist[10]!, hist[11]!, hist[12]!, hist[13]!, hist[14]!, (v1886 - (v1935 / v1812)), ret[0]!, ret[1]!, ret[2]!, ret[3]!, ret[4]!, ret[5]!, ret[6]!, ret[7]!, ret[8]!, ret[9]!, ret[10]!, ret[11]!, ret[12]!, ret[13]!, ret[14]!, v2064, ((648.15 : Float) - v2064), v1786, (degPrev + (dt * (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max v2064 (1 : Float)))))))), ((((if v1899 then (((((32 : Float) * v1896) * Lp) * v1833) / v1830) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt v1902))) * (Lp / Dp)) * v1799) * (v1833 ^ 2)) / (2 : Float))) * v1786) / etaP) + (if ((0 : Float) < v1786) then Pidle else (0 : Float))), v1810, (min UAxMax (v1924 * Axch)), ((Lp / (max v1833 (0.000001 : Float))) / dt), (if ((618.15 : Float) <= v2030) then (1 : Float) else (0 : Float)), (((((1020.62 : Float) - ((0.614254 : Float) * v2111)) - ((0.000321 : Float) * (v2111 ^ 2))) / (((1020.62 : Float) - ((0.614254 : Float) * v2117)) - ((0.000321 : Float) * (v2117 ^ 2)))) - (1 : Float)), (((648.15 : Float) - v2064) / (300 : Float)), (min (max uPump (0 : Float)) (1 : Float)), (min (max (degPrev + (dt * (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max v2064 (1 : Float)))))))) (0 : Float)) (1 : Float))]

#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.315587 1.257038 1.198489 1.139940 1.081392 1.022843 0.964294 0.905745 0.847196 0.788648 0.730099 0.671550 0.613001 0.554452 0.495904 0.437355 0.378806 0.320257 0.261708 0.203160 1.744611 1.686062 1.627513 1.568964 1.510416 1.451867 1.393318 1.334769 1.276220 1.217672 1.159123 1.100574 1.042025 0.983476 0.924928 0.866379 0.807830 0.749281 0.690732 0.632184 0.573635 0.515086 0.456537 0.397988 0.339440 0.280891 0.222342 #[1.592203, 1.533654, 1.475105, 1.416556, 1.358008, 1.299459, 1.240910, 1.182361, 1.123812, 1.065264, 1.006715, 0.948166, 0.889617, 0.831068, 0.772520, 0.713971] #[1.592203, 1.533654, 1.475105, 1.416556, 1.358008, 1.299459, 1.240910, 1.182361, 1.123812, 1.065264, 1.006715, 0.948166, 0.889617, 0.831068, 0.772520, 0.713971] #[1.592203, 1.533654, 1.475105, 1.416556, 1.358008, 1.299459, 1.240910, 1.182361, 1.123812, 1.065264, 1.006715, 0.948166, 0.889617, 0.831068, 0.772520, 0.713971, 0.655422, 0.596873, 0.538324, 0.479776, 0.421227, 0.362678, 0.304129, 0.245580, 1.787032, 1.728483, 1.669934, 1.611385, 1.552836, 1.494288, 1.435739, 1.377190, 1.318641, 1.260092, 1.201544, 1.142995, 1.084446, 1.025897, 0.967348, 0.908800, 0.850251, 0.791702, 0.733153, 0.674604, 0.616056, 0.557507, 0.498958, 0.440409, 0.381860, 0.323312, 0.264763, 0.206214, 1.747665, 1.689116, 1.630568, 1.572019, 1.513470, 1.454921, 1.396372, 1.337824, 1.279275, 1.220726, 1.162177, 1.103628, 1.045080, 0.986531, 0.927982, 0.869433, 0.810884, 0.752336, 0.693787, 0.635238, 0.576689, 0.518140, 0.459592, 0.401043, 0.342494, 0.283945, 0.225396, 1.766848, 1.708299, 1.649750, 1.591201, 1.532652, 1.474104, 1.415555, 1.357006, 1.298457, 1.239908, 1.181360, 1.122811, 1.064262, 1.005713, 0.947164, 0.888616, 0.830067, 0.771518, 0.712969, 0.654420, 0.595872, 0.537323, 0.478774, 0.420225, 0.361676, 0.303128, 0.244579, 1.786030, 1.727481, 1.668932, 1.610384, 1.551835, 1.493286, 1.434737, 1.376188, 1.317640, 1.259091, 1.200542, 1.141993, 1.083444, 1.024896, 0.966347, 0.907798, 0.849249, 0.790700, 0.732152, 0.673603, 0.615054, 0.556505, 0.497956, 0.439408, 0.380859, 0.322310, 0.263761, 0.205212, 1.746664, 1.688115, 1.629566, 1.571017, 1.512468, 1.453920, 1.395371, 1.336822, 1.278273, 1.219724, 1.161176, 1.102627, 1.044078, 0.985529, 0.926980, 0.868432, 0.809883, 0.751334, 0.692785, 0.634236, 0.575688, 0.517139, 0.458590, 0.400041, 0.341492, 0.282944, 0.224395, 1.765846, 1.707297, 1.648748, 1.590200, 1.531651, 1.473102, 1.414553, 1.356004, 1.297456, 1.238907, 1.180358, 1.121809, 1.063260, 1.004712, 0.946163, 0.887614, 0.829065, 0.770516, 0.711968, 0.653419, 0.594870, 0.536321, 0.477772, 0.419224, 0.360675, 0.302126, 0.243577, 1.785028, 1.726480, 1.667931, 1.609382, 1.550833, 1.492284, 1.433736, 1.375187, 1.316638, 1.258089, 1.199540, 1.140992, 1.082443, 1.023894, 0.965345, 0.906796, 0.848248, 0.789699, 0.731150, 0.672601, 0.614052, 0.555504, 0.496955, 0.438406, 0.379857, 0.321308, 0.262760, 0.204211, 1.745662, 1.687113, 1.628564, 1.570016, 1.511467, 1.452918, 1.394369, 1.335820, 1.277272, 1.218723, 1.160174, 1.101625, 1.043076, 0.984528, 0.925979, 0.867430, 0.808881, 0.750332, 0.691784, 0.633235, 0.574686, 0.516137, 0.457588, 0.399040, 0.340491, 0.281942, 0.223393, 1.764844, 1.706296, 1.647747, 1.589198, 1.530649, 1.472100, 1.413552, 1.355003, 1.296454, 1.237905, 1.179356, 1.120808, 1.062259, 1.003710, 0.945161, 0.886612, 0.828064, 0.769515, 0.710966, 0.652417, 0.593868, 0.535320, 0.476771, 0.418222, 0.359673, 0.301124, 0.242576, 1.784027, 1.725478, 1.666929, 1.608380, 1.549832, 1.491283, 1.432734, 1.374185, 1.315636, 1.257088, 1.198539, 1.139990, 1.081441, 1.022892, 0.964344, 0.905795, 0.847246, 0.788697, 0.730148, 0.671600, 0.613051, 0.554502, 0.495953, 0.437404, 0.378856, 0.320307, 0.261758, 0.203209, 1.744660, 1.686112, 1.627563, 1.569014, 1.510465, 1.451916, 1.393368, 1.334819, 1.276270, 1.217721, 1.159172, 1.100624, 1.042075, 0.983526, 0.924977, 0.866428, 0.807880, 0.749331, 0.690782, 0.632233, 0.573684, 0.515136, 0.456587, 0.398038, 0.339489, 0.280940, 0.222392, 1.763843, 1.705294, 1.646745, 1.588196, 1.529648, 1.471099, 1.412550, 1.354001, 1.295452, 1.236904, 1.178355, 1.119806, 1.061257, 1.002708, 0.944160, 0.885611, 0.827062, 0.768513, 0.709964, 0.651416, 0.592867, 0.534318, 0.475769, 0.417220, 0.358672, 0.300123, 0.241574, 1.783025, 1.724476, 1.665928, 1.607379, 1.548830, 1.490281, 1.431732, 1.373184, 1.314635, 1.256086, 1.197537, 1.138988, 1.080440, 1.021891, 0.963342, 0.904793, 0.846244, 0.787696, 0.729147, 0.670598, 0.612049, 0.553500, 0.494952, 0.436403, 0.377854, 0.319305, 0.260756, 0.202208, 1.743659, 1.685110, 1.626561, 1.568012, 1.509464, 1.450915, 1.392366, 1.333817, 1.275268, 1.216720, 1.158171, 1.099622, 1.041073, 0.982524, 0.923976, 0.865427, 0.806878, 0.748329, 0.689780, 0.631232, 0.572683, 0.514134, 0.455585, 0.397036, 0.338488, 0.279939, 0.221390, 1.762841, 1.704292, 1.645744, 1.587195, 1.528646, 1.470097, 1.411548, 1.353000, 1.294451, 1.235902, 1.177353, 1.118804, 1.060256, 1.001707, 0.943158, 0.884609, 0.826060, 0.767512, 0.708963, 0.650414, 0.591865, 0.533316, 0.474768, 0.416219, 0.357670, 0.299121, 0.240572, 1.782024, 1.723475, 1.664926, 1.606377, 1.547828, 1.489280, 1.430731, 1.372182, 1.313633, 1.255084, 1.196536, 1.137987, 1.079438, 1.020889, 0.962340, 0.903792, 0.845243, 0.786694, 0.728145, 0.669596, 0.611048, 0.552499, 0.493950, 0.435401, 0.376852, 0.318304, 0.259755, 0.201206, 1.742657, 1.684108, 1.625560, 1.567011, 1.508462, 1.449913, 1.391364, 1.332816, 1.274267, 1.215718, 1.157169, 1.098620, 1.040072, 0.981523, 0.922974, 0.864425, 0.805876, 0.747328, 0.688779, 0.630230, 0.571681, 0.513132, 0.454584, 0.396035, 0.337486, 0.278937, 0.220388, 1.761840, 1.703291, 1.644742, 1.586193, 1.527644, 1.469096, 1.410547, 1.351998, 1.293449, 1.234900, 1.176352, 1.117803, 1.059254, 1.000705, 0.942156, 0.883608, 0.825059, 0.766510, 0.707961, 0.649412, 0.590864, 0.532315, 0.473766, 0.415217, 0.356668, 0.298120, 0.239571, 1.781022, 1.722473, 1.663924, 1.605376, 1.546827, 1.488278, 1.429729, 1.371180, 1.312632, 1.254083, 1.195534, 1.136985, 1.078436, 1.019888, 0.961339, 0.902790, 0.844241, 0.785692, 0.727144, 0.668595, 0.610046, 0.551497, 0.492948, 0.434400, 0.375851, 0.317302, 0.258753, 0.200204, 1.741656, 1.683107, 1.624558, 1.566009, 1.507460, 1.448912, 1.390363, 1.331814, 1.273265, 1.214716, 1.156168, 1.097619, 1.039070, 0.980521, 0.921972, 0.863424, 0.804875, 0.746326, 0.687777, 0.629228, 0.570680, 0.512131, 0.453582, 0.395033, 0.336484, 0.277936, 0.219387, 1.760838, 1.702289, 1.643740, 1.585192, 1.526643, 1.468094, 1.409545, 1.350996, 1.292448, 1.233899, 1.175350, 1.116801, 1.058252, 0.999704, 0.941155, 0.882606, 0.824057, 0.765508, 0.706960, 0.648411, 0.589862, 0.531313, 0.472764, 0.414216, 0.355667, 0.297118, 0.238569, 1.780020, 1.721472, 1.662923, 1.604374, 1.545825, 1.487276, 1.428728, 1.370179, 1.311630, 1.253081, 1.194532, 1.135984, 1.077435, 1.018886, 0.960337, 0.901788, 0.843240, 0.784691, 0.726142, 0.667593, 0.609044, 0.550496, 0.491947, 0.433398, 0.374849, 0.316300, 0.257752, 1.799203, 1.740654, 1.682105, 1.623556, 1.565008, 1.506459, 1.447910, 1.389361, 1.330812, 1.272264, 1.213715, 1.155166, 1.096617, 1.038068, 0.979520]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.984395 0.925846 0.867297 0.808748 0.750200 0.691651 0.633102 0.574553 0.516004 0.457456 0.398907 0.340358 0.281809 0.223260 1.764712 1.706163 1.647614 1.589065 1.530516 1.471968 1.413419 1.354870 1.296321 1.237772 1.179224 1.120675 1.062126 1.003577 0.945028 0.886480 0.827931 0.769382 0.710833 0.652284 0.593736 0.535187 0.476638 0.418089 0.359540 0.300992 0.242443 1.783894 1.725345 1.666796 1.608248 1.549699 1.491150 #[1.261011, 1.202462, 1.143913, 1.085364, 1.026816, 0.968267, 0.909718, 0.851169, 0.792620, 0.734072, 0.675523, 0.616974, 0.558425, 0.499876, 0.441328, 0.382779] #[1.261011, 1.202462, 1.143913, 1.085364, 1.026816, 0.968267, 0.909718, 0.851169, 0.792620, 0.734072, 0.675523, 0.616974, 0.558425, 0.499876, 0.441328, 0.382779] #[1.261011, 1.202462, 1.143913, 1.085364, 1.026816, 0.968267, 0.909718, 0.851169, 0.792620, 0.734072, 0.675523, 0.616974, 0.558425, 0.499876, 0.441328, 0.382779, 0.324230, 0.265681, 0.207132, 1.748584, 1.690035, 1.631486, 1.572937, 1.514388, 1.455840, 1.397291, 1.338742, 1.280193, 1.221644, 1.163096, 1.104547, 1.045998, 0.987449, 0.928900, 0.870352, 0.811803, 0.753254, 0.694705, 0.636156, 0.577608, 0.519059, 0.460510, 0.401961, 0.343412, 0.284864, 0.226315, 1.767766, 1.709217, 1.650668, 1.592120, 1.533571, 1.475022, 1.416473, 1.357924, 1.299376, 1.240827, 1.182278, 1.123729, 1.065180, 1.006632, 0.948083, 0.889534, 0.830985, 0.772436, 0.713888, 0.655339, 0.596790, 0.538241, 0.479692, 0.421144, 0.362595, 0.304046, 0.245497, 1.786948, 1.728400, 1.669851, 1.611302, 1.552753, 1.494204, 1.435656, 1.377107, 1.318558, 1.260009, 1.201460, 1.142912, 1.084363, 1.025814, 0.967265, 0.908716, 0.850168, 0.791619, 0.733070, 0.674521, 0.615972, 0.557424, 0.498875, 0.440326, 0.381777, 0.323228, 0.264680, 0.206131, 1.747582, 1.689033, 1.630484, 1.571936, 1.513387, 1.454838, 1.396289, 1.337740, 1.279192, 1.220643, 1.162094, 1.103545, 1.044996, 0.986448, 0.927899, 0.869350, 0.810801, 0.752252, 0.693704, 0.635155, 0.576606, 0.518057, 0.459508, 0.400960, 0.342411, 0.283862, 0.225313, 1.766764, 1.708216, 1.649667, 1.591118, 1.532569, 1.474020, 1.415472, 1.356923, 1.298374, 1.239825, 1.181276, 1.122728, 1.064179, 1.005630, 0.947081, 0.888532, 0.829984, 0.771435, 0.712886, 0.654337, 0.595788, 0.537240, 0.478691, 0.420142, 0.361593, 0.303044, 0.244496, 1.785947, 1.727398, 1.668849, 1.610300, 1.551752, 1.493203, 1.434654, 1.376105, 1.317556, 1.259008, 1.200459, 1.141910, 1.083361, 1.024812, 0.966264, 0.907715, 0.849166, 0.790617, 0.732068, 0.673520, 0.614971, 0.556422, 0.497873, 0.439324, 0.380776, 0.322227, 0.263678, 0.205129, 1.746580, 1.688032, 1.629483, 1.570934, 1.512385, 1.453836, 1.395288, 1.336739, 1.278190, 1.219641, 1.161092, 1.102544, 1.043995, 0.985446, 0.926897, 0.868348, 0.809800, 0.751251, 0.692702, 0.634153, 0.575604, 0.517056, 0.458507, 0.399958, 0.341409, 0.282860, 0.224312, 1.765763, 1.707214, 1.648665, 1.590116, 1.531568, 1.473019, 1.414470, 1.355921, 1.297372, 1.238824, 1.180275, 1.121726, 1.063177, 1.004628, 0.946080, 0.887531, 0.828982, 0.770433, 0.711884, 0.653336, 0.594787, 0.536238, 0.477689, 0.419140, 0.360592, 0.302043, 0.243494, 1.784945, 1.726396, 1.667848, 1.609299, 1.550750, 1.492201, 1.433652, 1.375104, 1.316555, 1.258006, 1.199457, 1.140908, 1.082360, 1.023811, 0.965262, 0.906713, 0.848164, 0.789616, 0.731067, 0.672518, 0.613969, 0.555420, 0.496872, 0.438323, 0.379774, 0.321225, 0.262676, 0.204128, 1.745579, 1.687030, 1.628481, 1.569932, 1.511384, 1.452835, 1.394286, 1.335737, 1.277188, 1.218640, 1.160091, 1.101542, 1.042993, 0.984444, 0.925896, 0.867347, 0.808798, 0.750249, 0.691700, 0.633152, 0.574603, 0.516054, 0.457505, 0.398956, 0.340408, 0.281859, 0.223310, 1.764761, 1.706212, 1.647664, 1.589115, 1.530566, 1.472017, 1.413468, 1.354920, 1.296371, 1.237822, 1.179273, 1.120724, 1.062176, 1.003627, 0.945078, 0.886529, 0.827980, 0.769432, 0.710883, 0.652334, 0.593785, 0.535236, 0.476688, 0.418139, 0.359590, 0.301041, 0.242492, 1.783944, 1.725395, 1.666846, 1.608297, 1.549748, 1.491200, 1.432651, 1.374102, 1.315553, 1.257004, 1.198456, 1.139907, 1.081358, 1.022809, 0.964260, 0.905712, 0.847163, 0.788614, 0.730065, 0.671516, 0.612968, 0.554419, 0.495870, 0.437321, 0.378772, 0.320224, 0.261675, 0.203126, 1.744577, 1.686028, 1.627480, 1.568931, 1.510382, 1.451833, 1.393284, 1.334736, 1.276187, 1.217638, 1.159089, 1.100540, 1.041992, 0.983443, 0.924894, 0.866345, 0.807796, 0.749248, 0.690699, 0.632150, 0.573601, 0.515052, 0.456504, 0.397955, 0.339406, 0.280857, 0.222308, 1.763760, 1.705211, 1.646662, 1.588113, 1.529564, 1.471016, 1.412467, 1.353918, 1.295369, 1.236820, 1.178272, 1.119723, 1.061174, 1.002625, 0.944076, 0.885528, 0.826979, 0.768430, 0.709881, 0.651332, 0.592784, 0.534235, 0.475686, 0.417137, 0.358588, 0.300040, 0.241491, 1.782942, 1.724393, 1.665844, 1.607296, 1.548747, 1.490198, 1.431649, 1.373100, 1.314552, 1.256003, 1.197454, 1.138905, 1.080356, 1.021808, 0.963259, 0.904710, 0.846161, 0.787612, 0.729064, 0.670515, 0.611966, 0.553417, 0.494868, 0.436320, 0.377771, 0.319222, 0.260673, 0.202124, 1.743576, 1.685027, 1.626478, 1.567929, 1.509380, 1.450832, 1.392283, 1.333734, 1.275185, 1.216636, 1.158088, 1.099539, 1.040990, 0.982441, 0.923892, 0.865344, 0.806795, 0.748246, 0.689697, 0.631148, 0.572600, 0.514051, 0.455502, 0.396953, 0.338404, 0.279856, 0.221307, 1.762758, 1.704209, 1.645660, 1.587112, 1.528563, 1.470014, 1.411465, 1.352916, 1.294368, 1.235819, 1.177270, 1.118721, 1.060172, 1.001624, 0.943075, 0.884526, 0.825977, 0.767428, 0.708880, 0.650331, 0.591782, 0.533233, 0.474684, 0.416136, 0.357587, 0.299038, 0.240489, 1.781940, 1.723392, 1.664843, 1.606294, 1.547745, 1.489196, 1.430648, 1.372099, 1.313550, 1.255001, 1.196452, 1.137904, 1.079355, 1.020806, 0.962257, 0.903708, 0.845160, 0.786611, 0.728062, 0.669513, 0.610964, 0.552416, 0.493867, 0.435318, 0.376769, 0.318220, 0.259672, 0.201123, 1.742574, 1.684025, 1.625476, 1.566928, 1.508379, 1.449830, 1.391281, 1.332732, 1.274184, 1.215635, 1.157086, 1.098537, 1.039988, 0.981440, 0.922891, 0.864342, 0.805793, 0.747244, 0.688696, 0.630147, 0.571598, 0.513049, 0.454500, 0.395952, 0.337403, 0.278854, 0.220305, 1.761756, 1.703208, 1.644659, 1.586110, 1.527561, 1.469012, 1.410464, 1.351915, 1.293366, 1.234817, 1.176268, 1.117720, 1.059171, 1.000622, 0.942073, 0.883524, 0.824976, 0.766427, 0.707878, 0.649329, 0.590780, 0.532232, 0.473683, 0.415134, 0.356585, 0.298036, 0.239488, 1.780939, 1.722390, 1.663841, 1.605292, 1.546744, 1.488195, 1.429646, 1.371097, 1.312548, 1.254000, 1.195451, 1.136902, 1.078353, 1.019804, 0.961256, 0.902707, 0.844158, 0.785609, 0.727060, 0.668512, 0.609963, 0.551414, 0.492865, 0.434316, 0.375768, 0.317219, 0.258670, 0.200121, 1.741572, 1.683024, 1.624475, 1.565926, 1.507377, 1.448828, 1.390280, 1.331731, 1.273182, 1.214633, 1.156084, 1.097536, 1.038987, 0.980438, 0.921889, 0.863340, 0.804792, 0.746243, 0.687694, 0.629145, 0.570596, 0.512048, 0.453499, 0.394950, 0.336401, 0.277852, 0.219304, 1.760755, 1.702206, 1.643657, 1.585108, 1.526560, 1.468011, 1.409462, 1.350913, 1.292364, 1.233816, 1.175267, 1.116718, 1.058169, 0.999620, 0.941072, 0.882523, 0.823974, 0.765425, 0.706876, 0.648328]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.653203 0.594654 0.536105 0.477556 0.419008 0.360459 0.301910 0.243361 1.784812 1.726264 1.667715 1.609166 1.550617 1.492068 1.433520 1.374971 1.316422 1.257873 1.199324 1.140776 1.082227 1.023678 0.965129 0.906580 0.848032 0.789483 0.730934 0.672385 0.613836 0.555288 0.496739 0.438190 0.379641 0.321092 0.262544 0.203995 1.745446 1.686897 1.628348 1.569800 1.511251 1.452702 1.394153 1.335604 1.277056 1.218507 1.159958 #[0.929819, 0.871270, 0.812721, 0.754172, 0.695624, 0.637075, 0.578526, 0.519977, 0.461428, 0.402880, 0.344331, 0.285782, 0.227233, 1.768684, 1.710136, 1.651587] #[0.929819, 0.871270, 0.812721, 0.754172, 0.695624, 0.637075, 0.578526, 0.519977, 0.461428, 0.402880, 0.344331, 0.285782, 0.227233, 1.768684, 1.710136, 1.651587] #[0.929819, 0.871270, 0.812721, 0.754172, 0.695624, 0.637075, 0.578526, 0.519977, 0.461428, 0.402880, 0.344331, 0.285782, 0.227233, 1.768684, 1.710136, 1.651587, 1.593038, 1.534489, 1.475940, 1.417392, 1.358843, 1.300294, 1.241745, 1.183196, 1.124648, 1.066099, 1.007550, 0.949001, 0.890452, 0.831904, 0.773355, 0.714806, 0.656257, 0.597708, 0.539160, 0.480611, 0.422062, 0.363513, 0.304964, 0.246416, 1.787867, 1.729318, 1.670769, 1.612220, 1.553672, 1.495123, 1.436574, 1.378025, 1.319476, 1.260928, 1.202379, 1.143830, 1.085281, 1.026732, 0.968184, 0.909635, 0.851086, 0.792537, 0.733988, 0.675440, 0.616891, 0.558342, 0.499793, 0.441244, 0.382696, 0.324147, 0.265598, 0.207049, 1.748500, 1.689952, 1.631403, 1.572854, 1.514305, 1.455756, 1.397208, 1.338659, 1.280110, 1.221561, 1.163012, 1.104464, 1.045915, 0.987366, 0.928817, 0.870268, 0.811720, 0.753171, 0.694622, 0.636073, 0.577524, 0.518976, 0.460427, 0.401878, 0.343329, 0.284780, 0.226232, 1.767683, 1.709134, 1.650585, 1.592036, 1.533488, 1.474939, 1.416390, 1.357841, 1.299292, 1.240744, 1.182195, 1.123646, 1.065097, 1.006548, 0.948000, 0.889451, 0.830902, 0.772353, 0.713804, 0.655256, 0.596707, 0.538158, 0.479609, 0.421060, 0.362512, 0.303963, 0.245414, 1.786865, 1.728316, 1.669768, 1.611219, 1.552670, 1.494121, 1.435572, 1.377024, 1.318475, 1.259926, 1.201377, 1.142828, 1.084280, 1.025731, 0.967182, 0.908633, 0.850084, 0.791536, 0.732987, 0.674438, 0.615889, 0.557340, 0.498792, 0.440243, 0.381694, 0.323145, 0.264596, 0.206048, 1.747499, 1.688950, 1.630401, 1.571852, 1.513304, 1.454755, 1.396206, 1.337657, 1.279108, 1.220560, 1.162011, 1.103462, 1.044913, 0.986364, 0.927816, 0.869267, 0.810718, 0.752169, 0.693620, 0.635072, 0.576523, 0.517974, 0.459425, 0.400876, 0.342328, 0.283779, 0.225230, 1.766681, 1.708132, 1.649584, 1.591035, 1.532486, 1.473937, 1.415388, 1.356840, 1.298291, 1.239742, 1.181193, 1.122644, 1.064096, 1.005547, 0.946998, 0.888449, 0.829900, 0.771352, 0.712803, 0.654254, 0.595705, 0.537156, 0.478608, 0.420059, 0.361510, 0.302961, 0.244412, 1.785864, 1.727315, 1.668766, 1.610217, 1.551668, 1.493120, 1.434571, 1.376022, 1.317473, 1.258924, 1.200376, 1.141827, 1.083278, 1.024729, 0.966180, 0.907632, 0.849083, 0.790534, 0.731985, 0.673436, 0.614888, 0.556339, 0.497790, 0.439241, 0.380692, 0.322144, 0.263595, 0.205046, 1.746497, 1.687948, 1.629400, 1.570851, 1.512302, 1.453753, 1.395204, 1.336656, 1.278107, 1.219558, 1.161009, 1.102460, 1.043912, 0.985363, 0.926814, 0.868265, 0.809716, 0.751168, 0.692619, 0.634070, 0.575521, 0.516972, 0.458424, 0.399875, 0.341326, 0.282777, 0.224228, 1.765680, 1.707131, 1.648582, 1.590033, 1.531484, 1.472936, 1.414387, 1.355838, 1.297289, 1.238740, 1.180192, 1.121643, 1.063094, 1.004545, 0.945996, 0.887448, 0.828899, 0.770350, 0.711801, 0.653252, 0.594704, 0.536155, 0.477606, 0.419057, 0.360508, 0.301960, 0.243411, 1.784862, 1.726313, 1.667764, 1.609216, 1.550667, 1.492118, 1.433569, 1.375020, 1.316472, 1.257923, 1.199374, 1.140825, 1.082276, 1.023728, 0.965179, 0.906630, 0.848081, 0.789532, 0.730984, 0.672435, 0.613886, 0.555337, 0.496788, 0.438240, 0.379691, 0.321142, 0.262593, 0.204044, 1.745496, 1.686947, 1.628398, 1.569849, 1.511300, 1.452752, 1.394203, 1.335654, 1.277105, 1.218556, 1.160008, 1.101459, 1.042910, 0.984361, 0.925812, 0.867264, 0.808715, 0.750166, 0.691617, 0.633068, 0.574520, 0.515971, 0.457422, 0.398873, 0.340324, 0.281776, 0.223227, 1.764678, 1.706129, 1.647580, 1.589032, 1.530483, 1.471934, 1.413385, 1.354836, 1.296288, 1.237739, 1.179190, 1.120641, 1.062092, 1.003544, 0.944995, 0.886446, 0.827897, 0.769348, 0.710800, 0.652251, 0.593702, 0.535153, 0.476604, 0.418056, 0.359507, 0.300958, 0.242409, 1.783860, 1.725312, 1.666763, 1.608214, 1.549665, 1.491116, 1.432568, 1.374019, 1.315470, 1.256921, 1.198372, 1.139824, 1.081275, 1.022726, 0.964177, 0.905628, 0.847080, 0.788531, 0.729982, 0.671433, 0.612884, 0.554336, 0.495787, 0.437238, 0.378689, 0.320140, 0.261592, 0.203043, 1.744494, 1.685945, 1.627396, 1.568848, 1.510299, 1.451750, 1.393201, 1.334652, 1.276104, 1.217555, 1.159006, 1.100457, 1.041908, 0.983360, 0.924811, 0.866262, 0.807713, 0.749164, 0.690616, 0.632067, 0.573518, 0.514969, 0.456420, 0.397872, 0.339323, 0.280774, 0.222225, 1.763676, 1.705128, 1.646579, 1.588030, 1.529481, 1.470932, 1.412384, 1.353835, 1.295286, 1.236737, 1.178188, 1.119640, 1.061091, 1.002542, 0.943993, 0.885444, 0.826896, 0.768347, 0.709798, 0.651249, 0.592700, 0.534152, 0.475603, 0.417054, 0.358505, 0.299956, 0.241408, 1.782859, 1.724310, 1.665761, 1.607212, 1.548664, 1.490115, 1.431566, 1.373017, 1.314468, 1.255920, 1.197371, 1.138822, 1.080273, 1.021724, 0.963176, 0.904627, 0.846078, 0.787529, 0.728980, 0.670432, 0.611883, 0.553334, 0.494785, 0.436236, 0.377688, 0.319139, 0.260590, 0.202041, 1.743492, 1.684944, 1.626395, 1.567846, 1.509297, 1.450748, 1.392200, 1.333651, 1.275102, 1.216553, 1.158004, 1.099456, 1.040907, 0.982358, 0.923809, 0.865260, 0.806712, 0.748163, 0.689614, 0.631065, 0.572516, 0.513968, 0.455419, 0.396870, 0.338321, 0.279772, 0.221224, 1.762675, 1.704126, 1.645577, 1.587028, 1.528480, 1.469931, 1.411382, 1.352833, 1.294284, 1.235736, 1.177187, 1.118638, 1.060089, 1.001540, 0.942992, 0.884443, 0.825894, 0.767345, 0.708796, 0.650248, 0.591699, 0.533150, 0.474601, 0.416052, 0.357504, 0.298955, 0.240406, 1.781857, 1.723308, 1.664760, 1.606211, 1.547662, 1.489113, 1.430564, 1.372016, 1.313467, 1.254918, 1.196369, 1.137820, 1.079272, 1.020723, 0.962174, 0.903625, 0.845076, 0.786528, 0.727979, 0.669430, 0.610881, 0.552332, 0.493784, 0.435235, 0.376686, 0.318137, 0.259588, 0.201040, 1.742491, 1.683942, 1.625393, 1.566844, 1.508296, 1.449747, 1.391198, 1.332649, 1.274100, 1.215552, 1.157003, 1.098454, 1.039905, 0.981356, 0.922808, 0.864259, 0.805710, 0.747161, 0.688612, 0.630064, 0.571515, 0.512966, 0.454417, 0.395868, 0.337320, 0.278771, 0.220222, 1.761673, 1.703124, 1.644576, 1.586027, 1.527478, 1.468929, 1.410380, 1.351832, 1.293283, 1.234734, 1.176185, 1.117636, 1.059088, 1.000539, 0.941990, 0.883441, 0.824892, 0.766344, 0.707795, 0.649246, 0.590697, 0.532148, 0.473600, 0.415051, 0.356502, 0.297953, 0.239404, 1.780856, 1.722307, 1.663758, 1.605209, 1.546660, 1.488112, 1.429563, 1.371014, 1.312465, 1.253916, 1.195368, 1.136819, 1.078270, 1.019721, 0.961172, 0.902624, 0.844075, 0.785526, 0.726977, 0.668428, 0.609880, 0.551331, 0.492782, 0.434233, 0.375684, 0.317136]).map Float.toBits))

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

#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 1.129435 1.070886 1.012337 0.953788 0.895240 0.836691 0.778142 0.719593 0.661044 0.602496 0.543947 0.485398 0.426849 0.368300 0.309752 0.251203 1.792654 1.734105 1.675556 1.617008 1.558459 1.499910 1.441361 1.382812 1.324264 1.265715 1.207166 1.148617 1.090068 1.031520 0.972971 0.914422 0.855873 #[1.406051, 1.347502, 1.288953, 1.230404, 1.171856, 1.113307, 1.054758, 0.996209, 0.937660, 0.879112, 0.820563, 0.762014, 0.703465, 0.644916, 0.586368, 0.527819, 0.469270, 0.410721, 0.352172, 0.293624, 0.235075, 1.776526, 1.717977, 1.659428, 1.600880, 1.542331, 1.483782, 1.425233, 1.366684, 1.308136, 1.249587, 1.191038, 1.132489, 1.073940, 1.015392, 0.956843, 0.898294, 0.839745, 0.781196, 0.722648, 0.664099, 0.605550, 0.547001, 0.488452, 0.429904, 0.371355, 0.312806, 0.254257, 1.795708, 1.737160, 1.678611, 1.620062, 1.561513, 1.502964, 1.444416, 1.385867, 1.327318, 1.268769, 1.210220, 1.151672, 1.093123, 1.034574, 0.976025, 0.917476, 0.858928, 0.800379, 0.741830, 0.683281, 0.624732, 0.566184, 0.507635, 0.449086, 0.390537, 0.331988, 0.273440, 0.214891, 1.756342, 1.697793, 1.639244, 1.580696, 1.522147, 1.463598, 1.405049, 1.346500, 1.287952, 1.229403, 1.170854, 1.112305, 1.053756, 0.995208, 0.936659, 0.878110, 0.819561, 0.761012, 0.702464, 0.643915, 0.585366, 0.526817, 0.468268, 0.409720, 0.351171, 0.292622, 0.234073, 1.775524, 1.716976, 1.658427, 1.599878, 1.541329, 1.482780, 1.424232, 1.365683, 1.307134, 1.248585, 1.190036, 1.131488, 1.072939, 1.014390, 0.955841, 0.897292, 0.838744, 0.780195, 0.721646, 0.663097, 0.604548, 0.546000, 0.487451, 0.428902, 0.370353, 0.311804, 0.253256, 1.794707, 1.736158, 1.677609, 1.619060, 1.560512, 1.501963, 1.443414, 1.384865, 1.326316, 1.267768, 1.209219, 1.150670, 1.092121, 1.033572, 0.975024, 0.916475, 0.857926, 0.799377, 0.740828, 0.682280, 0.623731, 0.565182, 0.506633, 0.448084, 0.389536, 0.330987, 0.272438, 0.213889, 1.755340, 1.696792, 1.638243, 1.579694, 1.521145, 1.462596, 1.404048, 1.345499, 1.286950, 1.228401, 1.169852, 1.111304, 1.052755, 0.994206, 0.935657, 0.877108, 0.818560, 0.760011, 0.701462, 0.642913, 0.584364, 0.525816, 0.467267, 0.408718, 0.350169, 0.291620, 0.233072, 1.774523, 1.715974, 1.657425, 1.598876, 1.540328, 1.481779, 1.423230, 1.364681, 1.306132, 1.247584, 1.189035, 1.130486, 1.071937, 1.013388, 0.954840, 0.896291, 0.837742, 0.779193, 0.720644, 0.662096, 0.603547, 0.544998, 0.486449, 0.427900, 0.369352, 0.310803, 0.252254, 1.793705, 1.735156, 1.676608, 1.618059, 1.559510, 1.500961, 1.442412, 1.383864, 1.325315, 1.266766, 1.208217, 1.149668, 1.091120, 1.032571, 0.974022, 0.915473, 0.856924, 0.798376, 0.739827, 0.681278, 0.622729, 0.564180, 0.505632, 0.447083, 0.388534, 0.329985, 0.271436, 0.212888, 1.754339, 1.695790, 1.637241, 1.578692, 1.520144, 1.461595, 1.403046, 1.344497, 1.285948, 1.227400, 1.168851, 1.110302, 1.051753, 0.993204, 0.934656, 0.876107, 0.817558, 0.759009, 0.700460, 0.641912, 0.583363, 0.524814, 0.466265, 0.407716, 0.349168, 0.290619, 0.232070, 1.773521, 1.714972, 1.656424, 1.597875, 1.539326, 1.480777, 1.422228, 1.363680, 1.305131, 1.246582, 1.188033, 1.129484, 1.070936, 1.012387, 0.953838, 0.895289, 0.836740, 0.778192, 0.719643, 0.661094, 0.602545, 0.543996, 0.485448, 0.426899, 0.368350, 0.309801, 0.251252, 1.792704, 1.734155, 1.675606, 1.617057, 1.558508, 1.499960, 1.441411, 1.382862, 1.324313, 1.265764, 1.207216, 1.148667, 1.090118, 1.031569, 0.973020, 0.914472, 0.855923, 0.797374, 0.738825, 0.680276, 0.621728, 0.563179, 0.504630, 0.446081, 0.387532, 0.328984, 0.270435, 0.211886, 1.753337, 1.694788, 1.636240, 1.577691, 1.519142, 1.460593, 1.402044, 1.343496, 1.284947, 1.226398, 1.167849, 1.109300, 1.050752, 0.992203, 0.933654, 0.875105, 0.816556, 0.758008, 0.699459, 0.640910, 0.582361, 0.523812, 0.465264, 0.406715, 0.348166, 0.289617, 0.231068, 1.772520, 1.713971, 1.655422, 1.596873, 1.538324, 1.479776, 1.421227, 1.362678, 1.304129, 1.245580, 1.187032, 1.128483, 1.069934, 1.011385, 0.952836, 0.894288, 0.835739, 0.777190, 0.718641, 0.660092, 0.601544, 0.542995, 0.484446, 0.425897, 0.367348, 0.308800, 0.250251, 1.791702, 1.733153, 1.674604, 1.616056, 1.557507, 1.498958, 1.440409, 1.381860, 1.323312, 1.264763, 1.206214, 1.147665, 1.089116, 1.030568, 0.972019, 0.913470, 0.854921, 0.796372, 0.737824, 0.679275, 0.620726, 0.562177, 0.503628, 0.445080, 0.386531, 0.327982, 0.269433, 0.210884, 1.752336, 1.693787, 1.635238, 1.576689, 1.518140, 1.459592, 1.401043, 1.342494, 1.283945, 1.225396, 1.166848, 1.108299, 1.049750, 0.991201, 0.932652, 0.874104, 0.815555, 0.757006, 0.698457, 0.639908, 0.581360, 0.522811, 0.464262, 0.405713, 0.347164, 0.288616, 0.230067, 1.771518, 1.712969, 1.654420, 1.595872, 1.537323, 1.478774, 1.420225, 1.361676, 1.303128, 1.244579, 1.186030, 1.127481, 1.068932, 1.010384, 0.951835, 0.893286, 0.834737, 0.776188, 0.717640, 0.659091, 0.600542, 0.541993, 0.483444, 0.424896, 0.366347, 0.307798, 0.249249, 1.790700, 1.732152, 1.673603, 1.615054, 1.556505, 1.497956, 1.439408, 1.380859, 1.322310, 1.263761, 1.205212, 1.146664, 1.088115, 1.029566, 0.971017, 0.912468, 0.853920, 0.795371, 0.736822, 0.678273, 0.619724, 0.561176, 0.502627, 0.444078, 0.385529, 0.326980, 0.268432, 0.209883, 1.751334, 1.692785, 1.634236, 1.575688, 1.517139, 1.458590, 1.400041, 1.341492, 1.282944, 1.224395, 1.165846, 1.107297, 1.048748, 0.990200, 0.931651, 0.873102, 0.814553, 0.756004, 0.697456, 0.638907, 0.580358, 0.521809, 0.463260, 0.404712, 0.346163, 0.287614, 0.229065, 1.770516, 1.711968, 1.653419, 1.594870, 1.536321, 1.477772, 1.419224, 1.360675, 1.302126, 1.243577, 1.185028, 1.126480, 1.067931, 1.009382, 0.950833, 0.892284, 0.833736, 0.775187, 0.716638, 0.658089, 0.599540, 0.540992, 0.482443, 0.423894, 0.365345, 0.306796, 0.248248, 1.789699, 1.731150, 1.672601, 1.614052, 1.555504, 1.496955, 1.438406, 1.379857, 1.321308, 1.262760, 1.204211, 1.145662, 1.087113, 1.028564, 0.970016, 0.911467, 0.852918, 0.794369, 0.735820, 0.677272, 0.618723, 0.560174, 0.501625, 0.443076, 0.384528, 0.325979, 0.267430, 0.208881, 1.750332, 1.691784, 1.633235, 1.574686, 1.516137, 1.457588, 1.399040, 1.340491, 1.281942, 1.223393, 1.164844, 1.106296, 1.047747, 0.989198, 0.930649, 0.872100, 0.813552, 0.755003, 0.696454, 0.637905, 0.579356, 0.520808, 0.462259, 0.403710, 0.345161, 0.286612, 0.228064, 1.769515, 1.710966, 1.652417, 1.593868, 1.535320, 1.476771, 1.418222, 1.359673, 1.301124, 1.242576, 1.184027, 1.125478, 1.066929, 1.008380, 0.949832, 0.891283, 0.832734, 0.774185, 0.715636, 0.657088, 0.598539, 0.539990, 0.481441, 0.422892, 0.364344, 0.305795, 0.247246, 1.788697, 1.730148, 1.671600, 1.613051, 1.554502, 1.495953, 1.437404, 1.378856, 1.320307, 1.261758, 1.203209, 1.144660, 1.086112, 1.027563, 0.969014, 0.910465, 0.851916, 0.793368]).map Float.toBits))
#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 0.798243 0.739694 0.681145 0.622596 0.564048 0.505499 0.446950 0.388401 0.329852 0.271304 0.212755 1.754206 1.695657 1.637108 1.578560 1.520011 1.461462 1.402913 1.344364 1.285816 1.227267 1.168718 1.110169 1.051620 0.993072 0.934523 0.875974 0.817425 0.758876 0.700328 0.641779 0.583230 0.524681 #[1.074859, 1.016310, 0.957761, 0.899212, 0.840664, 0.782115, 0.723566, 0.665017, 0.606468, 0.547920, 0.489371, 0.430822, 0.372273, 0.313724, 0.255176, 1.796627, 1.738078, 1.679529, 1.620980, 1.562432, 1.503883, 1.445334, 1.386785, 1.328236, 1.269688, 1.211139, 1.152590, 1.094041, 1.035492, 0.976944, 0.918395, 0.859846, 0.801297, 0.742748, 0.684200, 0.625651, 0.567102, 0.508553, 0.450004, 0.391456, 0.332907, 0.274358, 0.215809, 1.757260, 1.698712, 1.640163, 1.581614, 1.523065, 1.464516, 1.405968, 1.347419, 1.288870, 1.230321, 1.171772, 1.113224, 1.054675, 0.996126, 0.937577, 0.879028, 0.820480, 0.761931, 0.703382, 0.644833, 0.586284, 0.527736, 0.469187, 0.410638, 0.352089, 0.293540, 0.234992, 1.776443, 1.717894, 1.659345, 1.600796, 1.542248, 1.483699, 1.425150, 1.366601, 1.308052, 1.249504, 1.190955, 1.132406, 1.073857, 1.015308, 0.956760, 0.898211, 0.839662, 0.781113, 0.722564, 0.664016, 0.605467, 0.546918, 0.488369, 0.429820, 0.371272, 0.312723, 0.254174, 1.795625, 1.737076, 1.678528, 1.619979, 1.561430, 1.502881, 1.444332, 1.385784, 1.327235, 1.268686, 1.210137, 1.151588, 1.093040, 1.034491, 0.975942, 0.917393, 0.858844, 0.800296, 0.741747, 0.683198, 0.624649, 0.566100, 0.507552, 0.449003, 0.390454, 0.331905, 0.273356, 0.214808, 1.756259, 1.697710, 1.639161, 1.580612, 1.522064, 1.463515, 1.404966, 1.346417, 1.287868, 1.229320, 1.170771, 1.112222, 1.053673, 0.995124, 0.936576, 0.878027, 0.819478, 0.760929, 0.702380, 0.643832, 0.585283, 0.526734, 0.468185, 0.409636, 0.351088, 0.292539, 0.233990, 1.775441, 1.716892, 1.658344, 1.599795, 1.541246, 1.482697, 1.424148, 1.365600, 1.307051, 1.248502, 1.189953, 1.131404, 1.072856, 1.014307, 0.955758, 0.897209, 0.838660, 0.780112, 0.721563, 0.663014, 0.604465, 0.545916, 0.487368, 0.428819, 0.370270, 0.311721, 0.253172, 1.794624, 1.736075, 1.677526, 1.618977, 1.560428, 1.501880, 1.443331, 1.384782, 1.326233, 1.267684, 1.209136, 1.150587, 1.092038, 1.033489, 0.974940, 0.916392, 0.857843, 0.799294, 0.740745, 0.682196, 0.623648, 0.565099, 0.506550, 0.448001, 0.389452, 0.330904, 0.272355, 0.213806, 1.755257, 1.696708, 1.638160, 1.579611, 1.521062, 1.462513, 1.403964, 1.345416, 1.286867, 1.228318, 1.169769, 1.111220, 1.052672, 0.994123, 0.935574, 0.877025, 0.818476, 0.759928, 0.701379, 0.642830, 0.584281, 0.525732, 0.467184, 0.408635, 0.350086, 0.291537, 0.232988, 1.774440, 1.715891, 1.657342, 1.598793, 1.540244, 1.481696, 1.423147, 1.364598, 1.306049, 1.247500, 1.188952, 1.130403, 1.071854, 1.013305, 0.954756, 0.896208, 0.837659, 0.779110, 0.720561, 0.662012, 0.603464, 0.544915, 0.486366, 0.427817, 0.369268, 0.310720, 0.252171, 1.793622, 1.735073, 1.676524, 1.617976, 1.559427, 1.500878, 1.442329, 1.383780, 1.325232, 1.266683, 1.208134, 1.149585, 1.091036, 1.032488, 0.973939, 0.915390, 0.856841, 0.798292, 0.739744, 0.681195, 0.622646, 0.564097, 0.505548, 0.447000, 0.388451, 0.329902, 0.271353, 0.212804, 1.754256, 1.695707, 1.637158, 1.578609, 1.520060, 1.461512, 1.402963, 1.344414, 1.285865, 1.227316, 1.168768, 1.110219, 1.051670, 0.993121, 0.934572, 0.876024, 0.817475, 0.758926, 0.700377, 0.641828, 0.583280, 0.524731, 0.466182, 0.407633, 0.349084, 0.290536, 0.231987, 1.773438, 1.714889, 1.656340, 1.597792, 1.539243, 1.480694, 1.422145, 1.363596, 1.305048, 1.246499, 1.187950, 1.129401, 1.070852, 1.012304, 0.953755, 0.895206, 0.836657, 0.778108, 0.719560, 0.661011, 0.602462, 0.543913, 0.485364, 0.426816, 0.368267, 0.309718, 0.251169, 1.792620, 1.734072, 1.675523, 1.616974, 1.558425, 1.499876, 1.441328, 1.382779, 1.324230, 1.265681, 1.207132, 1.148584, 1.090035, 1.031486, 0.972937, 0.914388, 0.855840, 0.797291, 0.738742, 0.680193, 0.621644, 0.563096, 0.504547, 0.445998, 0.387449, 0.328900, 0.270352, 0.211803, 1.753254, 1.694705, 1.636156, 1.577608, 1.519059, 1.460510, 1.401961, 1.343412, 1.284864, 1.226315, 1.167766, 1.109217, 1.050668, 0.992120, 0.933571, 0.875022, 0.816473, 0.757924, 0.699376, 0.640827, 0.582278, 0.523729, 0.465180, 0.406632, 0.348083, 0.289534, 0.230985, 1.772436, 1.713888, 1.655339, 1.596790, 1.538241, 1.479692, 1.421144, 1.362595, 1.304046, 1.245497, 1.186948, 1.128400, 1.069851, 1.011302, 0.952753, 0.894204, 0.835656, 0.777107, 0.718558, 0.660009, 0.601460, 0.542912, 0.484363, 0.425814, 0.367265, 0.308716, 0.250168, 1.791619, 1.733070, 1.674521, 1.615972, 1.557424, 1.498875, 1.440326, 1.381777, 1.323228, 1.264680, 1.206131, 1.147582, 1.089033, 1.030484, 0.971936, 0.913387, 0.854838, 0.796289, 0.737740, 0.679192, 0.620643, 0.562094, 0.503545, 0.444996, 0.386448, 0.327899, 0.269350, 0.210801, 1.752252, 1.693704, 1.635155, 1.576606, 1.518057, 1.459508, 1.400960, 1.342411, 1.283862, 1.225313, 1.166764, 1.108216, 1.049667, 0.991118, 0.932569, 0.874020, 0.815472, 0.756923, 0.698374, 0.639825, 0.581276, 0.522728, 0.464179, 0.405630, 0.347081, 0.288532, 0.229984, 1.771435, 1.712886, 1.654337, 1.595788, 1.537240, 1.478691, 1.420142, 1.361593, 1.303044, 1.244496, 1.185947, 1.127398, 1.068849, 1.010300, 0.951752, 0.893203, 0.834654, 0.776105, 0.717556, 0.659008, 0.600459, 0.541910, 0.483361, 0.424812, 0.366264, 0.307715, 0.249166, 1.790617, 1.732068, 1.673520, 1.614971, 1.556422, 1.497873, 1.439324, 1.380776, 1.322227, 1.263678, 1.205129, 1.146580, 1.088032, 1.029483, 0.970934, 0.912385, 0.853836, 0.795288, 0.736739, 0.678190, 0.619641, 0.561092, 0.502544, 0.443995, 0.385446, 0.326897, 0.268348, 0.209800, 1.751251, 1.692702, 1.634153, 1.575604, 1.517056, 1.458507, 1.399958, 1.341409, 1.282860, 1.224312, 1.165763, 1.107214, 1.048665, 0.990116, 0.931568, 0.873019, 0.814470, 0.755921, 0.697372, 0.638824, 0.580275, 0.521726, 0.463177, 0.404628, 0.346080, 0.287531, 0.228982, 1.770433, 1.711884, 1.653336, 1.594787, 1.536238, 1.477689, 1.419140, 1.360592, 1.302043, 1.243494, 1.184945, 1.126396, 1.067848, 1.009299, 0.950750, 0.892201, 0.833652, 0.775104, 0.716555, 0.658006, 0.599457, 0.540908, 0.482360, 0.423811, 0.365262, 0.306713, 0.248164, 1.789616, 1.731067, 1.672518, 1.613969, 1.555420, 1.496872, 1.438323, 1.379774, 1.321225, 1.262676, 1.204128, 1.145579, 1.087030, 1.028481, 0.969932, 0.911384, 0.852835, 0.794286, 0.735737, 0.677188, 0.618640, 0.560091, 0.501542, 0.442993, 0.384444, 0.325896, 0.267347, 0.208798, 1.750249, 1.691700, 1.633152, 1.574603, 1.516054, 1.457505, 1.398956, 1.340408, 1.281859, 1.223310, 1.164761, 1.106212, 1.047664, 0.989115, 0.930566, 0.872017, 0.813468, 0.754920, 0.696371, 0.637822, 0.579273, 0.520724, 0.462176]).map Float.toBits))
#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 0.467051 0.408502 0.349953 0.291404 0.232856 1.774307 1.715758 1.657209 1.598660 1.540112 1.481563 1.423014 1.364465 1.305916 1.247368 1.188819 1.130270 1.071721 1.013172 0.954624 0.896075 0.837526 0.778977 0.720428 0.661880 0.603331 0.544782 0.486233 0.427684 0.369136 0.310587 0.252038 1.793489 #[0.743667, 0.685118, 0.626569, 0.568020, 0.509472, 0.450923, 0.392374, 0.333825, 0.275276, 0.216728, 1.758179, 1.699630, 1.641081, 1.582532, 1.523984, 1.465435, 1.406886, 1.348337, 1.289788, 1.231240, 1.172691, 1.114142, 1.055593, 0.997044, 0.938496, 0.879947, 0.821398, 0.762849, 0.704300, 0.645752, 0.587203, 0.528654, 0.470105, 0.411556, 0.353008, 0.294459, 0.235910, 1.777361, 1.718812, 1.660264, 1.601715, 1.543166, 1.484617, 1.426068, 1.367520, 1.308971, 1.250422, 1.191873, 1.133324, 1.074776, 1.016227, 0.957678, 0.899129, 0.840580, 0.782032, 0.723483, 0.664934, 0.606385, 0.547836, 0.489288, 0.430739, 0.372190, 0.313641, 0.255092, 1.796544, 1.737995, 1.679446, 1.620897, 1.562348, 1.503800, 1.445251, 1.386702, 1.328153, 1.269604, 1.211056, 1.152507, 1.093958, 1.035409, 0.976860, 0.918312, 0.859763, 0.801214, 0.742665, 0.684116, 0.625568, 0.567019, 0.508470, 0.449921, 0.391372, 0.332824, 0.274275, 0.215726, 1.757177, 1.698628, 1.640080, 1.581531, 1.522982, 1.464433, 1.405884, 1.347336, 1.288787, 1.230238, 1.171689, 1.113140, 1.054592, 0.996043, 0.937494, 0.878945, 0.820396, 0.761848, 0.703299, 0.644750, 0.586201, 0.527652, 0.469104, 0.410555, 0.352006, 0.293457, 0.234908, 1.776360, 1.717811, 1.659262, 1.600713, 1.542164, 1.483616, 1.425067, 1.366518, 1.307969, 1.249420, 1.190872, 1.132323, 1.073774, 1.015225, 0.956676, 0.898128, 0.839579, 0.781030, 0.722481, 0.663932, 0.605384, 0.546835, 0.488286, 0.429737, 0.371188, 0.312640, 0.254091, 1.795542, 1.736993, 1.678444, 1.619896, 1.561347, 1.502798, 1.444249, 1.385700, 1.327152, 1.268603, 1.210054, 1.151505, 1.092956, 1.034408, 0.975859, 0.917310, 0.858761, 0.800212, 0.741664, 0.683115, 0.624566, 0.566017, 0.507468, 0.448920, 0.390371, 0.331822, 0.273273, 0.214724, 1.756176, 1.697627, 1.639078, 1.580529, 1.521980, 1.463432, 1.404883, 1.346334, 1.287785, 1.229236, 1.170688, 1.112139, 1.053590, 0.995041, 0.936492, 0.877944, 0.819395, 0.760846, 0.702297, 0.643748, 0.585200, 0.526651, 0.468102, 0.409553, 0.351004, 0.292456, 0.233907, 1.775358, 1.716809, 1.658260, 1.599712, 1.541163, 1.482614, 1.424065, 1.365516, 1.306968, 1.248419, 1.189870, 1.131321, 1.072772, 1.014224, 0.955675, 0.897126, 0.838577, 0.780028, 0.721480, 0.662931, 0.604382, 0.545833, 0.487284, 0.428736, 0.370187, 0.311638, 0.253089, 1.794540, 1.735992, 1.677443, 1.618894, 1.560345, 1.501796, 1.443248, 1.384699, 1.326150, 1.267601, 1.209052, 1.150504, 1.091955, 1.033406, 0.974857, 0.916308, 0.857760, 0.799211, 0.740662, 0.682113, 0.623564, 0.565016, 0.506467, 0.447918, 0.389369, 0.330820, 0.272272, 0.213723, 1.755174, 1.696625, 1.638076, 1.579528, 1.520979, 1.462430, 1.403881, 1.345332, 1.286784, 1.228235, 1.169686, 1.111137, 1.052588, 0.994040, 0.935491, 0.876942, 0.818393, 0.759844, 0.701296, 0.642747, 0.584198, 0.525649, 0.467100, 0.408552, 0.350003, 0.291454, 0.232905, 1.774356, 1.715808, 1.657259, 1.598710, 1.540161, 1.481612, 1.423064, 1.364515, 1.305966, 1.247417, 1.188868, 1.130320, 1.071771, 1.013222, 0.954673, 0.896124, 0.837576, 0.779027, 0.720478, 0.661929, 0.603380, 0.544832, 0.486283, 0.427734, 0.369185, 0.310636, 0.252088, 1.793539, 1.734990, 1.676441, 1.617892, 1.559344, 1.500795, 1.442246, 1.383697, 1.325148, 1.266600, 1.208051, 1.149502, 1.090953, 1.032404, 0.973856, 0.915307, 0.856758, 0.798209, 0.739660, 0.681112, 0.622563, 0.564014, 0.505465, 0.446916, 0.388368, 0.329819, 0.271270, 0.212721, 1.754172, 1.695624, 1.637075, 1.578526, 1.519977, 1.461428, 1.402880, 1.344331, 1.285782, 1.227233, 1.168684, 1.110136, 1.051587, 0.993038, 0.934489, 0.875940, 0.817392, 0.758843, 0.700294, 0.641745, 0.583196, 0.524648, 0.466099, 0.407550, 0.349001, 0.290452, 0.231904, 1.773355, 1.714806, 1.656257, 1.597708, 1.539160, 1.480611, 1.422062, 1.363513, 1.304964, 1.246416, 1.187867, 1.129318, 1.070769, 1.012220, 0.953672, 0.895123, 0.836574, 0.778025, 0.719476, 0.660928, 0.602379, 0.543830, 0.485281, 0.426732, 0.368184, 0.309635, 0.251086, 1.792537, 1.733988, 1.675440, 1.616891, 1.558342, 1.499793, 1.441244, 1.382696, 1.324147, 1.265598, 1.207049, 1.148500, 1.089952, 1.031403, 0.972854, 0.914305, 0.855756, 0.797208, 0.738659, 0.680110, 0.621561, 0.563012, 0.504464, 0.445915, 0.387366, 0.328817, 0.270268, 0.211720, 1.753171, 1.694622, 1.636073, 1.577524, 1.518976, 1.460427, 1.401878, 1.343329, 1.284780, 1.226232, 1.167683, 1.109134, 1.050585, 0.992036, 0.933488, 0.874939, 0.816390, 0.757841, 0.699292, 0.640744, 0.582195, 0.523646, 0.465097, 0.406548, 0.348000, 0.289451, 0.230902, 1.772353, 1.713804, 1.655256, 1.596707, 1.538158, 1.479609, 1.421060, 1.362512, 1.303963, 1.245414, 1.186865, 1.128316, 1.069768, 1.011219, 0.952670, 0.894121, 0.835572, 0.777024, 0.718475, 0.659926, 0.601377, 0.542828, 0.484280, 0.425731, 0.367182, 0.308633, 0.250084, 1.791536, 1.732987, 1.674438, 1.615889, 1.557340, 1.498792, 1.440243, 1.381694, 1.323145, 1.264596, 1.206048, 1.147499, 1.088950, 1.030401, 0.971852, 0.913304, 0.854755, 0.796206, 0.737657, 0.679108, 0.620560, 0.562011, 0.503462, 0.444913, 0.386364, 0.327816, 0.269267, 0.210718, 1.752169, 1.693620, 1.635072, 1.576523, 1.517974, 1.459425, 1.400876, 1.342328, 1.283779, 1.225230, 1.166681, 1.108132, 1.049584, 0.991035, 0.932486, 0.873937, 0.815388, 0.756840, 0.698291, 0.639742, 0.581193, 0.522644, 0.464096, 0.405547, 0.346998, 0.288449, 0.229900, 1.771352, 1.712803, 1.654254, 1.595705, 1.537156, 1.478608, 1.420059, 1.361510, 1.302961, 1.244412, 1.185864, 1.127315, 1.068766, 1.010217, 0.951668, 0.893120, 0.834571, 0.776022, 0.717473, 0.658924, 0.600376, 0.541827, 0.483278, 0.424729, 0.366180, 0.307632, 0.249083, 1.790534, 1.731985, 1.673436, 1.614888, 1.556339, 1.497790, 1.439241, 1.380692, 1.322144, 1.263595, 1.205046, 1.146497, 1.087948, 1.029400, 0.970851, 0.912302, 0.853753, 0.795204, 0.736656, 0.678107, 0.619558, 0.561009, 0.502460, 0.443912, 0.385363, 0.326814, 0.268265, 0.209716, 1.751168, 1.692619, 1.634070, 1.575521, 1.516972, 1.458424, 1.399875, 1.341326, 1.282777, 1.224228, 1.165680, 1.107131, 1.048582, 0.990033, 0.931484, 0.872936, 0.814387, 0.755838, 0.697289, 0.638740, 0.580192, 0.521643, 0.463094, 0.404545, 0.345996, 0.287448, 0.228899, 1.770350, 1.711801, 1.653252, 1.594704, 1.536155, 1.477606, 1.419057, 1.360508, 1.301960, 1.243411, 1.184862, 1.126313, 1.067764, 1.009216, 0.950667, 0.892118, 0.833569, 0.775020, 0.716472, 0.657923, 0.599374, 0.540825, 0.482276, 0.423728, 0.365179, 0.306630, 0.248081, 1.789532, 1.730984]).map Float.toBits))

def check_hashemiEnv_capture_mem (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (Twall : Float) (Ta : Float) (uPump : Float) (Qmax : Float) (Dp : Float) (Lp : Float) (Dins : Float) (kIns : Float) (Vw : Float) (etaP : Float) (Pidle : Float) (Axch : Float) (UAxMax : Float) (Ccoil : Float) (degPrev : Float) (degA : Float) (degEa : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v730 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v742 := ((1.22 : Float) * (0.8 : Float))
  let v743 := ((0.34 : Float) * v730)
  let v746 := ((3.141592653589793 : Float) / (2 : Float))
  let v753 := (if (v742 <= v743) then v746 else (Float.atan ((((1.22 : Float) * v730) + ((0.34 : Float) * (0.8 : Float))) / (v742 - v743))))
  let v754 := (-(1.22 : Float))
  let v755 := (-(0.8 : Float))
  let v756 := (Float.cos (0 : Float))
  let v758 := (-v730)
  let v759 := (Float.sin (0 : Float))
  let v762 := (-v755)
  let v771 := (Float.sqrt (((((v755 * v756) + (v758 * v759)) - v754) ^ 2) + ((((v762 * v759) + (v758 * v756)) - (0.34 : Float)) ^ 2)))
  let v772 := (Float.cos v753)
  let v774 := (Float.sin v753)
  let v785 := (Float.sqrt (((((v755 * v772) + (v758 * v774)) - v754) ^ 2) + ((((v762 * v774) + (v758 * v772)) - (0.34 : Float)) ^ 2)))
  let v786 := (Float.cos t)
  let v788 := (Float.sin t)
  let v790 := ((v755 * v786) + (v758 * v788))
  let v793 := ((v762 * v788) + (v758 * v786))
  let v799 := (Float.sqrt (((v790 - v754) ^ 2) + ((v793 - (0.34 : Float)) ^ 2)))
  let v801 := (omegad * rDrum)
  let v803 := ((v799 + slack) - (v801 * dt))
  let v804 := (v803 < v785)
  let v805 := (v771 < v803)
  let v807 := (if v804 then v785 else (if v805 then v771 else v803))
  let v812 := (((0 : Float) + v753) / (2 : Float))
  let v813 := (Float.cos v812)
  let v815 := (Float.sin v812)
  let v827 := (v807 < (Float.sqrt (((((v755 * v813) + (v758 * v815)) - v754) ^ 2) + ((((v762 * v815) + (v758 * v813)) - (0.34 : Float)) ^ 2))))
  let v828 := (if v827 then v812 else (0 : Float))
  let v829 := (if v827 then v753 else v812)
  let v831 := ((v828 + v829) / (2 : Float))
  let v832 := (Float.cos v831)
  let v834 := (Float.sin v831)
  let v846 := (v807 < (Float.sqrt (((((v755 * v832) + (v758 * v834)) - v754) ^ 2) + ((((v762 * v834) + (v758 * v832)) - (0.34 : Float)) ^ 2))))
  let v847 := (if v846 then v831 else v828)
  let v848 := (if v846 then v829 else v831)
  let v850 := ((v847 + v848) / (2 : Float))
  let v851 := (Float.cos v850)
  let v853 := (Float.sin v850)
  let v865 := (v807 < (Float.sqrt (((((v755 * v851) + (v758 * v853)) - v754) ^ 2) + ((((v762 * v853) + (v758 * v851)) - (0.34 : Float)) ^ 2))))
  let v866 := (if v865 then v850 else v847)
  let v867 := (if v865 then v848 else v850)
  let v869 := ((v866 + v867) / (2 : Float))
  let v870 := (Float.cos v869)
  let v872 := (Float.sin v869)
  let v884 := (v807 < (Float.sqrt (((((v755 * v870) + (v758 * v872)) - v754) ^ 2) + ((((v762 * v872) + (v758 * v870)) - (0.34 : Float)) ^ 2))))
  let v885 := (if v884 then v869 else v866)
  let v886 := (if v884 then v867 else v869)
  let v888 := ((v885 + v886) / (2 : Float))
  let v889 := (Float.cos v888)
  let v891 := (Float.sin v888)
  let v903 := (v807 < (Float.sqrt (((((v755 * v889) + (v758 * v891)) - v754) ^ 2) + ((((v762 * v891) + (v758 * v889)) - (0.34 : Float)) ^ 2))))
  let v904 := (if v903 then v888 else v885)
  let v905 := (if v903 then v886 else v888)
  let v907 := ((v904 + v905) / (2 : Float))
  let v908 := (Float.cos v907)
  let v910 := (Float.sin v907)
  let v922 := (v807 < (Float.sqrt (((((v755 * v908) + (v758 * v910)) - v754) ^ 2) + ((((v762 * v910) + (v758 * v908)) - (0.34 : Float)) ^ 2))))
  let v923 := (if v922 then v907 else v904)
  let v924 := (if v922 then v905 else v907)
  let v926 := ((v923 + v924) / (2 : Float))
  let v927 := (Float.cos v926)
  let v929 := (Float.sin v926)
  let v941 := (v807 < (Float.sqrt (((((v755 * v927) + (v758 * v929)) - v754) ^ 2) + ((((v762 * v929) + (v758 * v927)) - (0.34 : Float)) ^ 2))))
  let v942 := (if v941 then v926 else v923)
  let v943 := (if v941 then v924 else v926)
  let v945 := ((v942 + v943) / (2 : Float))
  let v946 := (Float.cos v945)
  let v948 := (Float.sin v945)
  let v960 := (v807 < (Float.sqrt (((((v755 * v946) + (v758 * v948)) - v754) ^ 2) + ((((v762 * v948) + (v758 * v946)) - (0.34 : Float)) ^ 2))))
  let v961 := (if v960 then v945 else v942)
  let v962 := (if v960 then v943 else v945)
  let v964 := ((v961 + v962) / (2 : Float))
  let v965 := (Float.cos v964)
  let v967 := (Float.sin v964)
  let v979 := (v807 < (Float.sqrt (((((v755 * v965) + (v758 * v967)) - v754) ^ 2) + ((((v762 * v967) + (v758 * v965)) - (0.34 : Float)) ^ 2))))
  let v980 := (if v979 then v964 else v961)
  let v981 := (if v979 then v962 else v964)
  let v983 := ((v980 + v981) / (2 : Float))
  let v984 := (Float.cos v983)
  let v986 := (Float.sin v983)
  let v998 := (v807 < (Float.sqrt (((((v755 * v984) + (v758 * v986)) - v754) ^ 2) + ((((v762 * v986) + (v758 * v984)) - (0.34 : Float)) ^ 2))))
  let v999 := (if v998 then v983 else v980)
  let v1000 := (if v998 then v981 else v983)
  let v1002 := ((v999 + v1000) / (2 : Float))
  let v1003 := (Float.cos v1002)
  let v1005 := (Float.sin v1002)
  let v1017 := (v807 < (Float.sqrt (((((v755 * v1003) + (v758 * v1005)) - v754) ^ 2) + ((((v762 * v1005) + (v758 * v1003)) - (0.34 : Float)) ^ 2))))
  let v1018 := (if v1017 then v1002 else v999)
  let v1019 := (if v1017 then v1000 else v1002)
  let v1021 := ((v1018 + v1019) / (2 : Float))
  let v1022 := (Float.cos v1021)
  let v1024 := (Float.sin v1021)
  let v1036 := (v807 < (Float.sqrt (((((v755 * v1022) + (v758 * v1024)) - v754) ^ 2) + ((((v762 * v1024) + (v758 * v1022)) - (0.34 : Float)) ^ 2))))
  let v1037 := (if v1036 then v1021 else v1018)
  let v1038 := (if v1036 then v1019 else v1021)
  let v1040 := ((v1037 + v1038) / (2 : Float))
  let v1041 := (Float.cos v1040)
  let v1043 := (Float.sin v1040)
  let v1055 := (v807 < (Float.sqrt (((((v755 * v1041) + (v758 * v1043)) - v754) ^ 2) + ((((v762 * v1043) + (v758 * v1041)) - (0.34 : Float)) ^ 2))))
  let v1056 := (if v1055 then v1040 else v1037)
  let v1057 := (if v1055 then v1038 else v1040)
  let v1059 := ((v1056 + v1057) / (2 : Float))
  let v1060 := (Float.cos v1059)
  let v1062 := (Float.sin v1059)
  let v1074 := (v807 < (Float.sqrt (((((v755 * v1060) + (v758 * v1062)) - v754) ^ 2) + ((((v762 * v1062) + (v758 * v1060)) - (0.34 : Float)) ^ 2))))
  let v1075 := (if v1074 then v1059 else v1056)
  let v1076 := (if v1074 then v1057 else v1059)
  let v1078 := ((v1075 + v1076) / (2 : Float))
  let v1079 := (Float.cos v1078)
  let v1081 := (Float.sin v1078)
  let v1093 := (v807 < (Float.sqrt (((((v755 * v1079) + (v758 * v1081)) - v754) ^ 2) + ((((v762 * v1081) + (v758 * v1079)) - (0.34 : Float)) ^ 2))))
  let v1094 := (if v1093 then v1078 else v1075)
  let v1095 := (if v1093 then v1076 else v1078)
  let v1097 := ((v1094 + v1095) / (2 : Float))
  let v1098 := (Float.cos v1097)
  let v1100 := (Float.sin v1097)
  let v1112 := (v807 < (Float.sqrt (((((v755 * v1098) + (v758 * v1100)) - v754) ^ 2) + ((((v762 * v1100) + (v758 * v1098)) - (0.34 : Float)) ^ 2))))
  let v1113 := (if v1112 then v1097 else v1094)
  let v1114 := (if v1112 then v1095 else v1097)
  let v1116 := ((v1113 + v1114) / (2 : Float))
  let v1117 := (Float.cos v1116)
  let v1119 := (Float.sin v1116)
  let v1131 := (v807 < (Float.sqrt (((((v755 * v1117) + (v758 * v1119)) - v754) ^ 2) + ((((v762 * v1119) + (v758 * v1117)) - (0.34 : Float)) ^ 2))))
  let v1132 := (if v1131 then v1116 else v1113)
  let v1133 := (if v1131 then v1114 else v1116)
  let v1135 := ((v1132 + v1133) / (2 : Float))
  let v1136 := (Float.cos v1135)
  let v1138 := (Float.sin v1135)
  let v1150 := (v807 < (Float.sqrt (((((v755 * v1136) + (v758 * v1138)) - v754) ^ 2) + ((((v762 * v1138) + (v758 * v1136)) - (0.34 : Float)) ^ 2))))
  let v1151 := (if v1150 then v1135 else v1132)
  let v1152 := (if v1150 then v1133 else v1135)
  let v1154 := ((v1151 + v1152) / (2 : Float))
  let v1155 := (Float.cos v1154)
  let v1157 := (Float.sin v1154)
  let v1169 := (v807 < (Float.sqrt (((((v755 * v1155) + (v758 * v1157)) - v754) ^ 2) + ((((v762 * v1157) + (v758 * v1155)) - (0.34 : Float)) ^ 2))))
  let v1170 := (if v1169 then v1154 else v1151)
  let v1171 := (if v1169 then v1152 else v1154)
  let v1173 := ((v1170 + v1171) / (2 : Float))
  let v1174 := (Float.cos v1173)
  let v1176 := (Float.sin v1173)
  let v1188 := (v807 < (Float.sqrt (((((v755 * v1174) + (v758 * v1176)) - v754) ^ 2) + ((((v762 * v1176) + (v758 * v1174)) - (0.34 : Float)) ^ 2))))
  let v1189 := (if v1188 then v1173 else v1170)
  let v1190 := (if v1188 then v1171 else v1173)
  let v1192 := ((v1189 + v1190) / (2 : Float))
  let v1193 := (Float.cos v1192)
  let v1195 := (Float.sin v1192)
  let v1207 := (v807 < (Float.sqrt (((((v755 * v1193) + (v758 * v1195)) - v754) ^ 2) + ((((v762 * v1195) + (v758 * v1193)) - (0.34 : Float)) ^ 2))))
  let v1208 := (if v1207 then v1192 else v1189)
  let v1209 := (if v1207 then v1190 else v1192)
  let v1211 := ((v1208 + v1209) / (2 : Float))
  let v1212 := (Float.cos v1211)
  let v1214 := (Float.sin v1211)
  let v1226 := (v807 < (Float.sqrt (((((v755 * v1212) + (v758 * v1214)) - v754) ^ 2) + ((((v762 * v1214) + (v758 * v1212)) - (0.34 : Float)) ^ 2))))
  let v1227 := (if v1226 then v1211 else v1208)
  let v1228 := (if v1226 then v1209 else v1211)
  let v1230 := ((v1227 + v1228) / (2 : Float))
  let v1231 := (Float.cos v1230)
  let v1233 := (Float.sin v1230)
  let v1245 := (v807 < (Float.sqrt (((((v755 * v1231) + (v758 * v1233)) - v754) ^ 2) + ((((v762 * v1233) + (v758 * v1231)) - (0.34 : Float)) ^ 2))))
  let v1246 := (if v1245 then v1230 else v1227)
  let v1247 := (if v1245 then v1228 else v1230)
  let v1249 := ((v1246 + v1247) / (2 : Float))
  let v1250 := (Float.cos v1249)
  let v1252 := (Float.sin v1249)
  let v1264 := (v807 < (Float.sqrt (((((v755 * v1250) + (v758 * v1252)) - v754) ^ 2) + ((((v762 * v1252) + (v758 * v1250)) - (0.34 : Float)) ^ 2))))
  let v1269 := (if (v771 <= v803) then (0 : Float) else (((if v1264 then v1249 else v1246) + (if v1264 then v1247 else v1249)) / (2 : Float)))
  let v1270 := (W * rcm)
  let v1271 := (Float.cos v1269)
  let v1273 := (Float.sin v1269)
  let v1275 := ((v755 * v1271) + (v758 * v1273))
  let v1278 := ((v762 * v1273) + (v758 * v1271))
  let v1293 := ((t < v1269) && (!(v1270 <= (Tmax * (((v754 * v1278) - ((0.34 : Float) * v1275)) / (Float.sqrt (((v1275 - v754) ^ 2) + ((v1278 - (0.34 : Float)) ^ 2))))))))
  let v1294 := (if v1293 then t else v1269)
  let v1299 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1304 := (Float.cos v1294)
  let v1306 := (Float.sin v1294)
  let v1334 := (Float.cos elSun)
  let v1336 := (v1334 * (Float.cos azSun))
  let v1338 := (v1334 * (Float.sin azSun))
  let v1339 := (Float.sin elSun)
  let v1386 := (Float.cos v1299)
  let v1387 := (v1306 * v1386)
  let v1388 := (Float.sin v1299)
  let v1389 := (v1306 * v1388)
  let v1390 := (v1304 * v1386)
  let v1391 := (v1304 * v1388)
  let v1392 := (-v1306)
  let v1417 := ((2 : Float) * a)
  let v1418 := (v1417 / w)
  let v1420 := (w / (2 : Float))
  let v1421 := ((-a) + v1420)
  let v1440 := ((1 : Float) / (2 : Float))
  let v1445 := (-(((((v1391 * v1304) - (v1392 * v1389)) * v1336) + (((v1392 * v1387) - (v1390 * v1304)) * v1338)) + (((v1390 * v1389) - (v1391 * v1387)) * v1339)))
  let v1446 := (-(((v1390 * v1336) + (v1391 * v1338)) + (v1392 * v1339)))
  let v1447 := (-(((v1387 * v1336) + (v1389 * v1338)) + (v1304 * v1339)))
  let v1452 := ((Float.abs v1447) < ((9 : Float) / (10 : Float)))
  let v1453 := (if v1452 then (0 : Float) else (1 : Float))
  let v1454 := (if v1452 then (1 : Float) else (0 : Float))
  let v1457 := ((v1446 * v1454) - (v1447 * (0 : Float)))
  let v1460 := ((v1447 * v1453) - (v1445 * v1454))
  let v1463 := ((v1445 * (0 : Float)) - (v1446 * v1453))
  let v1471 := (Float.sqrt (max (((v1457 ^ 2) + (v1460 ^ 2)) + (v1463 ^ 2)) (0.000000000000000001 : Float)))
  let v1472 := (v1457 / v1471)
  let v1473 := (v1460 / v1471)
  let v1474 := (v1463 / v1471)
  let v1486 := ((2 : Float) * (3.141592653589793 : Float))
  let v1523 := ((2 : Float) * f)
  let v1524 := ((1 : Float) / R)
  let v1640 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); (if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && (((Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))) <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1642 := (v1640 / (64 : Float))
  (((0 : Float) <= v1642) && (v1642 <= (1 : Float)))

#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.943283 0.884734 0.826185 0.767636 0.709088 0.650539 0.591990 0.533441 0.474892 0.416344 0.357795 0.299246 0.240697 1.782148 1.723600 1.665051 1.606502 1.547953 1.489404 1.430856 1.372307 1.313758 1.255209 1.196660 1.138112 1.079563 1.021014 0.962465 0.903916 0.845368 0.786819 0.728270 0.669721 0.611172 0.552624 0.494075 0.435526 0.376977 0.318428 0.259880 0.201331 1.742782 1.684233 1.625684 1.567136 1.508587 1.450038 #[1.219899, 1.161350, 1.102801, 1.044252, 0.985704, 0.927155, 0.868606, 0.810057, 0.751508, 0.692960, 0.634411, 0.575862, 0.517313, 0.458764, 0.400216, 0.341667] #[1.219899, 1.161350, 1.102801, 1.044252, 0.985704, 0.927155, 0.868606, 0.810057, 0.751508, 0.692960, 0.634411, 0.575862, 0.517313, 0.458764, 0.400216, 0.341667] #[1.219899, 1.161350, 1.102801, 1.044252, 0.985704, 0.927155, 0.868606, 0.810057, 0.751508, 0.692960, 0.634411, 0.575862, 0.517313, 0.458764, 0.400216, 0.341667, 0.283118, 0.224569, 1.766020, 1.707472, 1.648923, 1.590374, 1.531825, 1.473276, 1.414728, 1.356179, 1.297630, 1.239081, 1.180532, 1.121984, 1.063435, 1.004886, 0.946337, 0.887788, 0.829240, 0.770691, 0.712142, 0.653593, 0.595044, 0.536496, 0.477947, 0.419398, 0.360849, 0.302300, 0.243752, 1.785203, 1.726654, 1.668105, 1.609556, 1.551008, 1.492459, 1.433910, 1.375361, 1.316812, 1.258264, 1.199715, 1.141166, 1.082617, 1.024068, 0.965520, 0.906971, 0.848422, 0.789873, 0.731324, 0.672776, 0.614227, 0.555678, 0.497129, 0.438580, 0.380032, 0.321483, 0.262934, 0.204385, 1.745836, 1.687288, 1.628739, 1.570190, 1.511641, 1.453092, 1.394544, 1.335995, 1.277446, 1.218897, 1.160348, 1.101800, 1.043251, 0.984702, 0.926153, 0.867604, 0.809056, 0.750507, 0.691958, 0.633409, 0.574860, 0.516312, 0.457763, 0.399214, 0.340665, 0.282116, 0.223568, 1.765019, 1.706470, 1.647921, 1.589372, 1.530824, 1.472275, 1.413726, 1.355177, 1.296628, 1.238080, 1.179531, 1.120982, 1.062433, 1.003884, 0.945336, 0.886787, 0.828238, 0.769689, 0.711140, 0.652592, 0.594043, 0.535494, 0.476945, 0.418396, 0.359848, 0.301299, 0.242750, 1.784201, 1.725652, 1.667104, 1.608555, 1.550006, 1.491457, 1.432908, 1.374360, 1.315811, 1.257262, 1.198713, 1.140164, 1.081616, 1.023067, 0.964518, 0.905969, 0.847420, 0.788872, 0.730323, 0.671774, 0.613225, 0.554676, 0.496128, 0.437579, 0.379030, 0.320481, 0.261932, 0.203384, 1.744835, 1.686286, 1.627737, 1.569188, 1.510640, 1.452091, 1.393542, 1.334993, 1.276444, 1.217896, 1.159347, 1.100798, 1.042249, 0.983700, 0.925152, 0.866603, 0.808054, 0.749505, 0.690956, 0.632408, 0.573859, 0.515310, 0.456761, 0.398212, 0.339664, 0.281115, 0.222566, 1.764017, 1.705468, 1.646920, 1.588371, 1.529822, 1.471273, 1.412724, 1.354176, 1.295627, 1.237078, 1.178529, 1.119980, 1.061432, 1.002883, 0.944334, 0.885785, 0.827236, 0.768688, 0.710139, 0.651590, 0.593041, 0.534492, 0.475944, 0.417395, 0.358846, 0.300297, 0.241748, 1.783200, 1.724651, 1.666102, 1.607553, 1.549004, 1.490456, 1.431907, 1.373358, 1.314809, 1.256260, 1.197712, 1.139163, 1.080614, 1.022065, 0.963516, 0.904968, 0.846419, 0.787870, 0.729321, 0.670772, 0.612224, 0.553675, 0.495126, 0.436577, 0.378028, 0.319480, 0.260931, 0.202382, 1.743833, 1.685284, 1.626736, 1.568187, 1.509638, 1.451089, 1.392540, 1.333992, 1.275443, 1.216894, 1.158345, 1.099796, 1.041248, 0.982699, 0.924150, 0.865601, 0.807052, 0.748504, 0.689955, 0.631406, 0.572857, 0.514308, 0.455760, 0.397211, 0.338662, 0.280113, 0.221564, 1.763016, 1.704467, 1.645918, 1.587369, 1.528820, 1.470272, 1.411723, 1.353174, 1.294625, 1.236076, 1.177528, 1.118979, 1.060430, 1.001881, 0.943332, 0.884784, 0.826235, 0.767686, 0.709137, 0.650588, 0.592040, 0.533491, 0.474942, 0.416393, 0.357844, 0.299296, 0.240747, 1.782198, 1.723649, 1.665100, 1.606552, 1.548003, 1.489454, 1.430905, 1.372356, 1.313808, 1.255259, 1.196710, 1.138161, 1.079612, 1.021064, 0.962515, 0.903966, 0.845417, 0.786868, 0.728320, 0.669771, 0.611222, 0.552673, 0.494124, 0.435576, 0.377027, 0.318478, 0.259929, 0.201380, 1.742832, 1.684283, 1.625734, 1.567185, 1.508636, 1.450088, 1.391539, 1.332990, 1.274441, 1.215892, 1.157344, 1.098795, 1.040246, 0.981697, 0.923148, 0.864600, 0.806051, 0.747502, 0.688953, 0.630404, 0.571856, 0.513307, 0.454758, 0.396209, 0.337660, 0.279112, 0.220563, 1.762014, 1.703465, 1.644916, 1.586368, 1.527819, 1.469270, 1.410721, 1.352172, 1.293624, 1.235075, 1.176526, 1.117977, 1.059428, 1.000880, 0.942331, 0.883782, 0.825233, 0.766684, 0.708136, 0.649587, 0.591038, 0.532489, 0.473940, 0.415392, 0.356843, 0.298294, 0.239745, 1.781196, 1.722648, 1.664099, 1.605550, 1.547001, 1.488452, 1.429904, 1.371355, 1.312806, 1.254257, 1.195708, 1.137160, 1.078611, 1.020062, 0.961513, 0.902964, 0.844416, 0.785867, 0.727318, 0.668769, 0.610220, 0.551672, 0.493123, 0.434574, 0.376025, 0.317476, 0.258928, 0.200379, 1.741830, 1.683281, 1.624732, 1.566184, 1.507635, 1.449086, 1.390537, 1.331988, 1.273440, 1.214891, 1.156342, 1.097793, 1.039244, 0.980696, 0.922147, 0.863598, 0.805049, 0.746500, 0.687952, 0.629403, 0.570854, 0.512305, 0.453756, 0.395208, 0.336659, 0.278110, 0.219561, 1.761012, 1.702464, 1.643915, 1.585366, 1.526817, 1.468268, 1.409720, 1.351171, 1.292622, 1.234073, 1.175524, 1.116976, 1.058427, 0.999878, 0.941329, 0.882780, 0.824232, 0.765683, 0.707134, 0.648585, 0.590036, 0.531488, 0.472939, 0.414390, 0.355841, 0.297292, 0.238744, 1.780195, 1.721646, 1.663097, 1.604548, 1.546000, 1.487451, 1.428902, 1.370353, 1.311804, 1.253256, 1.194707, 1.136158, 1.077609, 1.019060, 0.960512, 0.901963, 0.843414, 0.784865, 0.726316, 0.667768, 0.609219, 0.550670, 0.492121, 0.433572, 0.375024, 0.316475, 0.257926, 1.799377, 1.740828, 1.682280, 1.623731, 1.565182, 1.506633, 1.448084, 1.389536, 1.330987, 1.272438, 1.213889, 1.155340, 1.096792, 1.038243, 0.979694, 0.921145, 0.862596, 0.804048, 0.745499, 0.686950, 0.628401, 0.569852, 0.511304, 0.452755, 0.394206, 0.335657, 0.277108, 0.218560, 1.760011, 1.701462, 1.642913, 1.584364, 1.525816, 1.467267, 1.408718, 1.350169, 1.291620, 1.233072, 1.174523, 1.115974, 1.057425, 0.998876, 0.940328, 0.881779, 0.823230, 0.764681, 0.706132, 0.647584, 0.589035, 0.530486, 0.471937, 0.413388, 0.354840, 0.296291, 0.237742, 1.779193, 1.720644, 1.662096, 1.603547, 1.544998, 1.486449, 1.427900, 1.369352, 1.310803, 1.252254, 1.193705, 1.135156, 1.076608, 1.018059, 0.959510, 0.900961, 0.842412, 0.783864, 0.725315, 0.666766, 0.608217, 0.549668, 0.491120, 0.432571, 0.374022, 0.315473, 0.256924, 1.798376, 1.739827, 1.681278, 1.622729, 1.564180, 1.505632, 1.447083, 1.388534, 1.329985, 1.271436, 1.212888, 1.154339, 1.095790, 1.037241, 0.978692, 0.920144, 0.861595, 0.803046, 0.744497, 0.685948, 0.627400, 0.568851, 0.510302, 0.451753, 0.393204, 0.334656, 0.276107, 0.217558, 1.759009, 1.700460, 1.641912, 1.583363, 1.524814, 1.466265, 1.407716, 1.349168, 1.290619, 1.232070, 1.173521, 1.114972, 1.056424, 0.997875, 0.939326, 0.880777, 0.822228, 0.763680, 0.705131, 0.646582, 0.588033, 0.529484, 0.470936, 0.412387, 0.353838, 0.295289, 0.236740, 1.778192, 1.719643, 1.661094, 1.602545, 1.543996, 1.485448, 1.426899, 1.368350, 1.309801, 1.251252, 1.192704, 1.134155, 1.075606, 1.017057, 0.958508, 0.899960, 0.841411, 0.782862, 0.724313, 0.665764, 0.607216]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.612091 0.553542 0.494993 0.436444 0.377896 0.319347 0.260798 0.202249 1.743700 1.685152 1.626603 1.568054 1.509505 1.450956 1.392408 1.333859 1.275310 1.216761 1.158212 1.099664 1.041115 0.982566 0.924017 0.865468 0.806920 0.748371 0.689822 0.631273 0.572724 0.514176 0.455627 0.397078 0.338529 0.279980 0.221432 1.762883 1.704334 1.645785 1.587236 1.528688 1.470139 1.411590 1.353041 1.294492 1.235944 1.177395 1.118846 #[0.888707, 0.830158, 0.771609, 0.713060, 0.654512, 0.595963, 0.537414, 0.478865, 0.420316, 0.361768, 0.303219, 0.244670, 1.786121, 1.727572, 1.669024, 1.610475] #[0.888707, 0.830158, 0.771609, 0.713060, 0.654512, 0.595963, 0.537414, 0.478865, 0.420316, 0.361768, 0.303219, 0.244670, 1.786121, 1.727572, 1.669024, 1.610475] #[0.888707, 0.830158, 0.771609, 0.713060, 0.654512, 0.595963, 0.537414, 0.478865, 0.420316, 0.361768, 0.303219, 0.244670, 1.786121, 1.727572, 1.669024, 1.610475, 1.551926, 1.493377, 1.434828, 1.376280, 1.317731, 1.259182, 1.200633, 1.142084, 1.083536, 1.024987, 0.966438, 0.907889, 0.849340, 0.790792, 0.732243, 0.673694, 0.615145, 0.556596, 0.498048, 0.439499, 0.380950, 0.322401, 0.263852, 0.205304, 1.746755, 1.688206, 1.629657, 1.571108, 1.512560, 1.454011, 1.395462, 1.336913, 1.278364, 1.219816, 1.161267, 1.102718, 1.044169, 0.985620, 0.927072, 0.868523, 0.809974, 0.751425, 0.692876, 0.634328, 0.575779, 0.517230, 0.458681, 0.400132, 0.341584, 0.283035, 0.224486, 1.765937, 1.707388, 1.648840, 1.590291, 1.531742, 1.473193, 1.414644, 1.356096, 1.297547, 1.238998, 1.180449, 1.121900, 1.063352, 1.004803, 0.946254, 0.887705, 0.829156, 0.770608, 0.712059, 0.653510, 0.594961, 0.536412, 0.477864, 0.419315, 0.360766, 0.302217, 0.243668, 1.785120, 1.726571, 1.668022, 1.609473, 1.550924, 1.492376, 1.433827, 1.375278, 1.316729, 1.258180, 1.199632, 1.141083, 1.082534, 1.023985, 0.965436, 0.906888, 0.848339, 0.789790, 0.731241, 0.672692, 0.614144, 0.555595, 0.497046, 0.438497, 0.379948, 0.321400, 0.262851, 0.204302, 1.745753, 1.687204, 1.628656, 1.570107, 1.511558, 1.453009, 1.394460, 1.335912, 1.277363, 1.218814, 1.160265, 1.101716, 1.043168, 0.984619, 0.926070, 0.867521, 0.808972, 0.750424, 0.691875, 0.633326, 0.574777, 0.516228, 0.457680, 0.399131, 0.340582, 0.282033, 0.223484, 1.764936, 1.706387, 1.647838, 1.589289, 1.530740, 1.472192, 1.413643, 1.355094, 1.296545, 1.237996, 1.179448, 1.120899, 1.062350, 1.003801, 0.945252, 0.886704, 0.828155, 0.769606, 0.711057, 0.652508, 0.593960, 0.535411, 0.476862, 0.418313, 0.359764, 0.301216, 0.242667, 1.784118, 1.725569, 1.667020, 1.608472, 1.549923, 1.491374, 1.432825, 1.374276, 1.315728, 1.257179, 1.198630, 1.140081, 1.081532, 1.022984, 0.964435, 0.905886, 0.847337, 0.788788, 0.730240, 0.671691, 0.613142, 0.554593, 0.496044, 0.437496, 0.378947, 0.320398, 0.261849, 0.203300, 1.744752, 1.686203, 1.627654, 1.569105, 1.510556, 1.452008, 1.393459, 1.334910, 1.276361, 1.217812, 1.159264, 1.100715, 1.042166, 0.983617, 0.925068, 0.866520, 0.807971, 0.749422, 0.690873, 0.632324, 0.573776, 0.515227, 0.456678, 0.398129, 0.339580, 0.281032, 0.222483, 1.763934, 1.705385, 1.646836, 1.588288, 1.529739, 1.471190, 1.412641, 1.354092, 1.295544, 1.236995, 1.178446, 1.119897, 1.061348, 1.002800, 0.944251, 0.885702, 0.827153, 0.768604, 0.710056, 0.651507, 0.592958, 0.534409, 0.475860, 0.417312, 0.358763, 0.300214, 0.241665, 1.783116, 1.724568, 1.666019, 1.607470, 1.548921, 1.490372, 1.431824, 1.373275, 1.314726, 1.256177, 1.197628, 1.139080, 1.080531, 1.021982, 0.963433, 0.904884, 0.846336, 0.787787, 0.729238, 0.670689, 0.612140, 0.553592, 0.495043, 0.436494, 0.377945, 0.319396, 0.260848, 0.202299, 1.743750, 1.685201, 1.626652, 1.568104, 1.509555, 1.451006, 1.392457, 1.333908, 1.275360, 1.216811, 1.158262, 1.099713, 1.041164, 0.982616, 0.924067, 0.865518, 0.806969, 0.748420, 0.689872, 0.631323, 0.572774, 0.514225, 0.455676, 0.397128, 0.338579, 0.280030, 0.221481, 1.762932, 1.704384, 1.645835, 1.587286, 1.528737, 1.470188, 1.411640, 1.353091, 1.294542, 1.235993, 1.177444, 1.118896, 1.060347, 1.001798, 0.943249, 0.884700, 0.826152, 0.767603, 0.709054, 0.650505, 0.591956, 0.533408, 0.474859, 0.416310, 0.357761, 0.299212, 0.240664, 1.782115, 1.723566, 1.665017, 1.606468, 1.547920, 1.489371, 1.430822, 1.372273, 1.313724, 1.255176, 1.196627, 1.138078, 1.079529, 1.020980, 0.962432, 0.903883, 0.845334, 0.786785, 0.728236, 0.669688, 0.611139, 0.552590, 0.494041, 0.435492, 0.376944, 0.318395, 0.259846, 0.201297, 1.742748, 1.684200, 1.625651, 1.567102, 1.508553, 1.450004, 1.391456, 1.332907, 1.274358, 1.215809, 1.157260, 1.098712, 1.040163, 0.981614, 0.923065, 0.864516, 0.805968, 0.747419, 0.688870, 0.630321, 0.571772, 0.513224, 0.454675, 0.396126, 0.337577, 0.279028, 0.220480, 1.761931, 1.703382, 1.644833, 1.586284, 1.527736, 1.469187, 1.410638, 1.352089, 1.293540, 1.234992, 1.176443, 1.117894, 1.059345, 1.000796, 0.942248, 0.883699, 0.825150, 0.766601, 0.708052, 0.649504, 0.590955, 0.532406, 0.473857, 0.415308, 0.356760, 0.298211, 0.239662, 1.781113, 1.722564, 1.664016, 1.605467, 1.546918, 1.488369, 1.429820, 1.371272, 1.312723, 1.254174, 1.195625, 1.137076, 1.078528, 1.019979, 0.961430, 0.902881, 0.844332, 0.785784, 0.727235, 0.668686, 0.610137, 0.551588, 0.493040, 0.434491, 0.375942, 0.317393, 0.258844, 0.200296, 1.741747, 1.683198, 1.624649, 1.566100, 1.507552, 1.449003, 1.390454, 1.331905, 1.273356, 1.214808, 1.156259, 1.097710, 1.039161, 0.980612, 0.922064, 0.863515, 0.804966, 0.746417, 0.687868, 0.629320, 0.570771, 0.512222, 0.453673, 0.395124, 0.336576, 0.278027, 0.219478, 1.760929, 1.702380, 1.643832, 1.585283, 1.526734, 1.468185, 1.409636, 1.351088, 1.292539, 1.233990, 1.175441, 1.116892, 1.058344, 0.999795, 0.941246, 0.882697, 0.824148, 0.765600, 0.707051, 0.648502, 0.589953, 0.531404, 0.472856, 0.414307, 0.355758, 0.297209, 0.238660, 1.780112, 1.721563, 1.663014, 1.604465, 1.545916, 1.487368, 1.428819, 1.370270, 1.311721, 1.253172, 1.194624, 1.136075, 1.077526, 1.018977, 0.960428, 0.901880, 0.843331, 0.784782, 0.726233, 0.667684, 0.609136, 0.550587, 0.492038, 0.433489, 0.374940, 0.316392, 0.257843, 1.799294, 1.740745, 1.682196, 1.623648, 1.565099, 1.506550, 1.448001, 1.389452, 1.330904, 1.272355, 1.213806, 1.155257, 1.096708, 1.038160, 0.979611, 0.921062, 0.862513, 0.803964, 0.745416, 0.686867, 0.628318, 0.569769, 0.511220, 0.452672, 0.394123, 0.335574, 0.277025, 0.218476, 1.759928, 1.701379, 1.642830, 1.584281, 1.525732, 1.467184, 1.408635, 1.350086, 1.291537, 1.232988, 1.174440, 1.115891, 1.057342, 0.998793, 0.940244, 0.881696, 0.823147, 0.764598, 0.706049, 0.647500, 0.588952, 0.530403, 0.471854, 0.413305, 0.354756, 0.296208, 0.237659, 1.779110, 1.720561, 1.662012, 1.603464, 1.544915, 1.486366, 1.427817, 1.369268, 1.310720, 1.252171, 1.193622, 1.135073, 1.076524, 1.017976, 0.959427, 0.900878, 0.842329, 0.783780, 0.725232, 0.666683, 0.608134, 0.549585, 0.491036, 0.432488, 0.373939, 0.315390, 0.256841, 1.798292, 1.739744, 1.681195, 1.622646, 1.564097, 1.505548, 1.447000, 1.388451, 1.329902, 1.271353, 1.212804, 1.154256, 1.095707, 1.037158, 0.978609, 0.920060, 0.861512, 0.802963, 0.744414, 0.685865, 0.627316, 0.568768, 0.510219, 0.451670, 0.393121, 0.334572, 0.276024]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 0.280899 0.222350 1.763801 1.705252 1.646704 1.588155 1.529606 1.471057 1.412508 1.353960 1.295411 1.236862 1.178313 1.119764 1.061216 1.002667 0.944118 0.885569 0.827020 0.768472 0.709923 0.651374 0.592825 0.534276 0.475728 0.417179 0.358630 0.300081 0.241532 1.782984 1.724435 1.665886 1.607337 1.548788 1.490240 1.431691 1.373142 1.314593 1.256044 1.197496 1.138947 1.080398 1.021849 0.963300 0.904752 0.846203 0.787654 #[0.557515, 0.498966, 0.440417, 0.381868, 0.323320, 0.264771, 0.206222, 1.747673, 1.689124, 1.630576, 1.572027, 1.513478, 1.454929, 1.396380, 1.337832, 1.279283] #[0.557515, 0.498966, 0.440417, 0.381868, 0.323320, 0.264771, 0.206222, 1.747673, 1.689124, 1.630576, 1.572027, 1.513478, 1.454929, 1.396380, 1.337832, 1.279283] #[0.557515, 0.498966, 0.440417, 0.381868, 0.323320, 0.264771, 0.206222, 1.747673, 1.689124, 1.630576, 1.572027, 1.513478, 1.454929, 1.396380, 1.337832, 1.279283, 1.220734, 1.162185, 1.103636, 1.045088, 0.986539, 0.927990, 0.869441, 0.810892, 0.752344, 0.693795, 0.635246, 0.576697, 0.518148, 0.459600, 0.401051, 0.342502, 0.283953, 0.225404, 1.766856, 1.708307, 1.649758, 1.591209, 1.532660, 1.474112, 1.415563, 1.357014, 1.298465, 1.239916, 1.181368, 1.122819, 1.064270, 1.005721, 0.947172, 0.888624, 0.830075, 0.771526, 0.712977, 0.654428, 0.595880, 0.537331, 0.478782, 0.420233, 0.361684, 0.303136, 0.244587, 1.786038, 1.727489, 1.668940, 1.610392, 1.551843, 1.493294, 1.434745, 1.376196, 1.317648, 1.259099, 1.200550, 1.142001, 1.083452, 1.024904, 0.966355, 0.907806, 0.849257, 0.790708, 0.732160, 0.673611, 0.615062, 0.556513, 0.497964, 0.439416, 0.380867, 0.322318, 0.263769, 0.205220, 1.746672, 1.688123, 1.629574, 1.571025, 1.512476, 1.453928, 1.395379, 1.336830, 1.278281, 1.219732, 1.161184, 1.102635, 1.044086, 0.985537, 0.926988, 0.868440, 0.809891, 0.751342, 0.692793, 0.634244, 0.575696, 0.517147, 0.458598, 0.400049, 0.341500, 0.282952, 0.224403, 1.765854, 1.707305, 1.648756, 1.590208, 1.531659, 1.473110, 1.414561, 1.356012, 1.297464, 1.238915, 1.180366, 1.121817, 1.063268, 1.004720, 0.946171, 0.887622, 0.829073, 0.770524, 0.711976, 0.653427, 0.594878, 0.536329, 0.477780, 0.419232, 0.360683, 0.302134, 0.243585, 1.785036, 1.726488, 1.667939, 1.609390, 1.550841, 1.492292, 1.433744, 1.375195, 1.316646, 1.258097, 1.199548, 1.141000, 1.082451, 1.023902, 0.965353, 0.906804, 0.848256, 0.789707, 0.731158, 0.672609, 0.614060, 0.555512, 0.496963, 0.438414, 0.379865, 0.321316, 0.262768, 0.204219, 1.745670, 1.687121, 1.628572, 1.570024, 1.511475, 1.452926, 1.394377, 1.335828, 1.277280, 1.218731, 1.160182, 1.101633, 1.043084, 0.984536, 0.925987, 0.867438, 0.808889, 0.750340, 0.691792, 0.633243, 0.574694, 0.516145, 0.457596, 0.399048, 0.340499, 0.281950, 0.223401, 1.764852, 1.706304, 1.647755, 1.589206, 1.530657, 1.472108, 1.413560, 1.355011, 1.296462, 1.237913, 1.179364, 1.120816, 1.062267, 1.003718, 0.945169, 0.886620, 0.828072, 0.769523, 0.710974, 0.652425, 0.593876, 0.535328, 0.476779, 0.418230, 0.359681, 0.301132, 0.242584, 1.784035, 1.725486, 1.666937, 1.608388, 1.549840, 1.491291, 1.432742, 1.374193, 1.315644, 1.257096, 1.198547, 1.139998, 1.081449, 1.022900, 0.964352, 0.905803, 0.847254, 0.788705, 0.730156, 0.671608, 0.613059, 0.554510, 0.495961, 0.437412, 0.378864, 0.320315, 0.261766, 0.203217, 1.744668, 1.686120, 1.627571, 1.569022, 1.510473, 1.451924, 1.393376, 1.334827, 1.276278, 1.217729, 1.159180, 1.100632, 1.042083, 0.983534, 0.924985, 0.866436, 0.807888, 0.749339, 0.690790, 0.632241, 0.573692, 0.515144, 0.456595, 0.398046, 0.339497, 0.280948, 0.222400, 1.763851, 1.705302, 1.646753, 1.588204, 1.529656, 1.471107, 1.412558, 1.354009, 1.295460, 1.236912, 1.178363, 1.119814, 1.061265, 1.002716, 0.944168, 0.885619, 0.827070, 0.768521, 0.709972, 0.651424, 0.592875, 0.534326, 0.475777, 0.417228, 0.358680, 0.300131, 0.241582, 1.783033, 1.724484, 1.665936, 1.607387, 1.548838, 1.490289, 1.431740, 1.373192, 1.314643, 1.256094, 1.197545, 1.138996, 1.080448, 1.021899, 0.963350, 0.904801, 0.846252, 0.787704, 0.729155, 0.670606, 0.612057, 0.553508, 0.494960, 0.436411, 0.377862, 0.319313, 0.260764, 0.202216, 1.743667, 1.685118, 1.626569, 1.568020, 1.509472, 1.450923, 1.392374, 1.333825, 1.275276, 1.216728, 1.158179, 1.099630, 1.041081, 0.982532, 0.923984, 0.865435, 0.806886, 0.748337, 0.689788, 0.631240, 0.572691, 0.514142, 0.455593, 0.397044, 0.338496, 0.279947, 0.221398, 1.762849, 1.704300, 1.645752, 1.587203, 1.528654, 1.470105, 1.411556, 1.353008, 1.294459, 1.235910, 1.177361, 1.118812, 1.060264, 1.001715, 0.943166, 0.884617, 0.826068, 0.767520, 0.708971, 0.650422, 0.591873, 0.533324, 0.474776, 0.416227, 0.357678, 0.299129, 0.240580, 1.782032, 1.723483, 1.664934, 1.606385, 1.547836, 1.489288, 1.430739, 1.372190, 1.313641, 1.255092, 1.196544, 1.137995, 1.079446, 1.020897, 0.962348, 0.903800, 0.845251, 0.786702, 0.728153, 0.669604, 0.611056, 0.552507, 0.493958, 0.435409, 0.376860, 0.318312, 0.259763, 0.201214, 1.742665, 1.684116, 1.625568, 1.567019, 1.508470, 1.449921, 1.391372, 1.332824, 1.274275, 1.215726, 1.157177, 1.098628, 1.040080, 0.981531, 0.922982, 0.864433, 0.805884, 0.747336, 0.688787, 0.630238, 0.571689, 0.513140, 0.454592, 0.396043, 0.337494, 0.278945, 0.220396, 1.761848, 1.703299, 1.644750, 1.586201, 1.527652, 1.469104, 1.410555, 1.352006, 1.293457, 1.234908, 1.176360, 1.117811, 1.059262, 1.000713, 0.942164, 0.883616, 0.825067, 0.766518, 0.707969, 0.649420, 0.590872, 0.532323, 0.473774, 0.415225, 0.356676, 0.298128, 0.239579, 1.781030, 1.722481, 1.663932, 1.605384, 1.546835, 1.488286, 1.429737, 1.371188, 1.312640, 1.254091, 1.195542, 1.136993, 1.078444, 1.019896, 0.961347, 0.902798, 0.844249, 0.785700, 0.727152, 0.668603, 0.610054, 0.551505, 0.492956, 0.434408, 0.375859, 0.317310, 0.258761, 0.200212, 1.741664, 1.683115, 1.624566, 1.566017, 1.507468, 1.448920, 1.390371, 1.331822, 1.273273, 1.214724, 1.156176, 1.097627, 1.039078, 0.980529, 0.921980, 0.863432, 0.804883, 0.746334, 0.687785, 0.629236, 0.570688, 0.512139, 0.453590, 0.395041, 0.336492, 0.277944, 0.219395, 1.760846, 1.702297, 1.643748, 1.585200, 1.526651, 1.468102, 1.409553, 1.351004, 1.292456, 1.233907, 1.175358, 1.116809, 1.058260, 0.999712, 0.941163, 0.882614, 0.824065, 0.765516, 0.706968, 0.648419, 0.589870, 0.531321, 0.472772, 0.414224, 0.355675, 0.297126, 0.238577, 1.780028, 1.721480, 1.662931, 1.604382, 1.545833, 1.487284, 1.428736, 1.370187, 1.311638, 1.253089, 1.194540, 1.135992, 1.077443, 1.018894, 0.960345, 0.901796, 0.843248, 0.784699, 0.726150, 0.667601, 0.609052, 0.550504, 0.491955, 0.433406, 0.374857, 0.316308, 0.257760, 1.799211, 1.740662, 1.682113, 1.623564, 1.565016, 1.506467, 1.447918, 1.389369, 1.330820, 1.272272, 1.213723, 1.155174, 1.096625, 1.038076, 0.979528, 0.920979, 0.862430, 0.803881, 0.745332, 0.686784, 0.628235, 0.569686, 0.511137, 0.452588, 0.394040, 0.335491, 0.276942, 0.218393, 1.759844, 1.701296, 1.642747, 1.584198, 1.525649, 1.467100, 1.408552, 1.350003, 1.291454, 1.232905, 1.174356, 1.115808, 1.057259, 0.998710, 0.940161, 0.881612, 0.823064, 0.764515, 0.705966, 0.647417, 0.588868, 0.530320, 0.471771, 0.413222, 0.354673, 0.296124, 0.237576, 1.779027, 1.720478, 1.661929, 1.603380, 1.544832]))

def check_hashemiEnv_flow_mem (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (Twall : Float) (Ta : Float) (uPump : Float) (Qmax : Float) (Dp : Float) (Lp : Float) (Dins : Float) (kIns : Float) (Vw : Float) (etaP : Float) (Pidle : Float) (Axch : Float) (UAxMax : Float) (Ccoil : Float) (degPrev : Float) (degA : Float) (degEa : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v1787 := (Qmax * (min (max uPump (0 : Float)) (1 : Float)))
  (!((0 : Float) <= Qmax) || (((0 : Float) <= v1787) && (v1787 <= Qmax)))

#eval IO.println ("check_hashemiEnv_flow_mem " ++ toString (check_hashemiEnv_flow_mem 0.757131 0.698582 0.640033 0.581484 0.522936 0.464387 0.405838 0.347289 0.288740 0.230192 1.771643 1.713094 1.654545 1.595996 1.537448 1.478899 1.420350 1.361801 1.303252 1.244704 1.186155 1.127606 1.069057 1.010508 0.951960 0.893411 0.834862 0.776313 0.717764 0.659216 0.600667 0.542118 0.483569 0.425020 0.366472 0.307923 0.249374 1.790825 1.732276 1.673728 1.615179 1.556630 1.498081 1.439532 1.380984 1.322435 1.263886 #[1.033747, 0.975198, 0.916649, 0.858100, 0.799552, 0.741003, 0.682454, 0.623905, 0.565356, 0.506808, 0.448259, 0.389710, 0.331161, 0.272612, 0.214064, 1.755515] #[1.033747, 0.975198, 0.916649, 0.858100, 0.799552, 0.741003, 0.682454, 0.623905, 0.565356, 0.506808, 0.448259, 0.389710, 0.331161, 0.272612, 0.214064, 1.755515] #[1.033747, 0.975198, 0.916649, 0.858100, 0.799552, 0.741003, 0.682454, 0.623905, 0.565356, 0.506808, 0.448259, 0.389710, 0.331161, 0.272612, 0.214064, 1.755515, 1.696966, 1.638417, 1.579868, 1.521320, 1.462771, 1.404222, 1.345673, 1.287124, 1.228576, 1.170027, 1.111478, 1.052929, 0.994380, 0.935832, 0.877283, 0.818734, 0.760185, 0.701636, 0.643088, 0.584539, 0.525990, 0.467441, 0.408892, 0.350344, 0.291795, 0.233246, 1.774697, 1.716148, 1.657600, 1.599051, 1.540502, 1.481953, 1.423404, 1.364856, 1.306307, 1.247758, 1.189209, 1.130660, 1.072112, 1.013563, 0.955014, 0.896465, 0.837916, 0.779368, 0.720819, 0.662270, 0.603721, 0.545172, 0.486624, 0.428075, 0.369526, 0.310977, 0.252428, 1.793880, 1.735331, 1.676782, 1.618233, 1.559684, 1.501136, 1.442587, 1.384038, 1.325489, 1.266940, 1.208392, 1.149843, 1.091294, 1.032745, 0.974196, 0.915648, 0.857099, 0.798550, 0.740001, 0.681452, 0.622904, 0.564355, 0.505806, 0.447257, 0.388708, 0.330160, 0.271611, 0.213062, 1.754513, 1.695964, 1.637416, 1.578867, 1.520318, 1.461769, 1.403220, 1.344672, 1.286123, 1.227574, 1.169025, 1.110476, 1.051928, 0.993379, 0.934830, 0.876281, 0.817732, 0.759184, 0.700635, 0.642086, 0.583537, 0.524988, 0.466440, 0.407891, 0.349342, 0.290793, 0.232244, 1.773696, 1.715147, 1.656598, 1.598049, 1.539500, 1.480952, 1.422403, 1.363854, 1.305305, 1.246756, 1.188208, 1.129659, 1.071110, 1.012561, 0.954012, 0.895464, 0.836915, 0.778366, 0.719817, 0.661268, 0.602720, 0.544171, 0.485622, 0.427073, 0.368524, 0.309976, 0.251427, 1.792878, 1.734329, 1.675780, 1.617232, 1.558683, 1.500134, 1.441585, 1.383036, 1.324488, 1.265939, 1.207390, 1.148841, 1.090292, 1.031744, 0.973195, 0.914646, 0.856097, 0.797548, 0.739000, 0.680451, 0.621902, 0.563353, 0.504804, 0.446256, 0.387707, 0.329158, 0.270609, 0.212060, 1.753512, 1.694963, 1.636414, 1.577865, 1.519316, 1.460768, 1.402219, 1.343670, 1.285121, 1.226572, 1.168024, 1.109475, 1.050926, 0.992377, 0.933828, 0.875280, 0.816731, 0.758182, 0.699633, 0.641084, 0.582536, 0.523987, 0.465438, 0.406889, 0.348340, 0.289792, 0.231243, 1.772694, 1.714145, 1.655596, 1.597048, 1.538499, 1.479950, 1.421401, 1.362852, 1.304304, 1.245755, 1.187206, 1.128657, 1.070108, 1.011560, 0.953011, 0.894462, 0.835913, 0.777364, 0.718816, 0.660267, 0.601718, 0.543169, 0.484620, 0.426072, 0.367523, 0.308974, 0.250425, 1.791876, 1.733328, 1.674779, 1.616230, 1.557681, 1.499132, 1.440584, 1.382035, 1.323486, 1.264937, 1.206388, 1.147840, 1.089291, 1.030742, 0.972193, 0.913644, 0.855096, 0.796547, 0.737998, 0.679449, 0.620900, 0.562352, 0.503803, 0.445254, 0.386705, 0.328156, 0.269608, 0.211059, 1.752510, 1.693961, 1.635412, 1.576864, 1.518315, 1.459766, 1.401217, 1.342668, 1.284120, 1.225571, 1.167022, 1.108473, 1.049924, 0.991376, 0.932827, 0.874278, 0.815729, 0.757180, 0.698632, 0.640083, 0.581534, 0.522985, 0.464436, 0.405888, 0.347339, 0.288790, 0.230241, 1.771692, 1.713144, 1.654595, 1.596046, 1.537497, 1.478948, 1.420400, 1.361851, 1.303302, 1.244753, 1.186204, 1.127656, 1.069107, 1.010558, 0.952009, 0.893460, 0.834912, 0.776363, 0.717814, 0.659265, 0.600716, 0.542168, 0.483619, 0.425070, 0.366521, 0.307972, 0.249424, 1.790875, 1.732326, 1.673777, 1.615228, 1.556680, 1.498131, 1.439582, 1.381033, 1.322484, 1.263936, 1.205387, 1.146838, 1.088289, 1.029740, 0.971192, 0.912643, 0.854094, 0.795545, 0.736996, 0.678448, 0.619899, 0.561350, 0.502801, 0.444252, 0.385704, 0.327155, 0.268606, 0.210057, 1.751508, 1.692960, 1.634411, 1.575862, 1.517313, 1.458764, 1.400216, 1.341667, 1.283118, 1.224569, 1.166020, 1.107472, 1.048923, 0.990374, 0.931825, 0.873276, 0.814728, 0.756179, 0.697630, 0.639081, 0.580532, 0.521984, 0.463435, 0.404886, 0.346337, 0.287788, 0.229240, 1.770691, 1.712142, 1.653593, 1.595044, 1.536496, 1.477947, 1.419398, 1.360849, 1.302300, 1.243752, 1.185203, 1.126654, 1.068105, 1.009556, 0.951008, 0.892459, 0.833910, 0.775361, 0.716812, 0.658264, 0.599715, 0.541166, 0.482617, 0.424068, 0.365520, 0.306971, 0.248422, 1.789873, 1.731324, 1.672776, 1.614227, 1.555678, 1.497129, 1.438580, 1.380032, 1.321483, 1.262934, 1.204385, 1.145836, 1.087288, 1.028739, 0.970190, 0.911641, 0.853092, 0.794544, 0.735995, 0.677446, 0.618897, 0.560348, 0.501800, 0.443251, 0.384702, 0.326153, 0.267604, 0.209056, 1.750507, 1.691958, 1.633409, 1.574860, 1.516312, 1.457763, 1.399214, 1.340665, 1.282116, 1.223568, 1.165019, 1.106470, 1.047921, 0.989372, 0.930824, 0.872275, 0.813726, 0.755177, 0.696628, 0.638080, 0.579531, 0.520982, 0.462433, 0.403884, 0.345336, 0.286787, 0.228238, 1.769689, 1.711140, 1.652592, 1.594043, 1.535494, 1.476945, 1.418396, 1.359848, 1.301299, 1.242750, 1.184201, 1.125652, 1.067104, 1.008555, 0.950006, 0.891457, 0.832908, 0.774360, 0.715811, 0.657262, 0.598713, 0.540164, 0.481616, 0.423067, 0.364518, 0.305969, 0.247420, 1.788872, 1.730323, 1.671774, 1.613225, 1.554676, 1.496128, 1.437579, 1.379030, 1.320481, 1.261932, 1.203384, 1.144835, 1.086286, 1.027737, 0.969188, 0.910640, 0.852091, 0.793542, 0.734993, 0.676444, 0.617896, 0.559347, 0.500798, 0.442249, 0.383700, 0.325152, 0.266603, 0.208054, 1.749505, 1.690956, 1.632408, 1.573859, 1.515310, 1.456761, 1.398212, 1.339664, 1.281115, 1.222566, 1.164017, 1.105468, 1.046920, 0.988371, 0.929822, 0.871273, 0.812724, 0.754176, 0.695627, 0.637078, 0.578529, 0.519980, 0.461432, 0.402883, 0.344334, 0.285785, 0.227236, 1.768688, 1.710139, 1.651590, 1.593041, 1.534492, 1.475944, 1.417395, 1.358846, 1.300297, 1.241748, 1.183200, 1.124651, 1.066102, 1.007553, 0.949004, 0.890456, 0.831907, 0.773358, 0.714809, 0.656260, 0.597712, 0.539163, 0.480614, 0.422065, 0.363516, 0.304968, 0.246419, 1.787870, 1.729321, 1.670772, 1.612224, 1.553675, 1.495126, 1.436577, 1.378028, 1.319480, 1.260931, 1.202382, 1.143833, 1.085284, 1.026736, 0.968187, 0.909638, 0.851089, 0.792540, 0.733992, 0.675443, 0.616894, 0.558345, 0.499796, 0.441248, 0.382699, 0.324150, 0.265601, 0.207052, 1.748504, 1.689955, 1.631406, 1.572857, 1.514308, 1.455760, 1.397211, 1.338662, 1.280113, 1.221564, 1.163016, 1.104467, 1.045918, 0.987369, 0.928820, 0.870272, 0.811723, 0.753174, 0.694625, 0.636076, 0.577528, 0.518979, 0.460430, 0.401881, 0.343332, 0.284784, 0.226235, 1.767686, 1.709137, 1.650588, 1.592040, 1.533491, 1.474942, 1.416393, 1.357844, 1.299296, 1.240747, 1.182198, 1.123649, 1.065100, 1.006552, 0.948003, 0.889454, 0.830905, 0.772356, 0.713808, 0.655259, 0.596710, 0.538161, 0.479612, 0.421064]))
#eval IO.println ("check_hashemiEnv_flow_mem " ++ toString (check_hashemiEnv_flow_mem 0.425939 0.367390 0.308841 0.250292 1.791744 1.733195 1.674646 1.616097 1.557548 1.499000 1.440451 1.381902 1.323353 1.264804 1.206256 1.147707 1.089158 1.030609 0.972060 0.913512 0.854963 0.796414 0.737865 0.679316 0.620768 0.562219 0.503670 0.445121 0.386572 0.328024 0.269475 0.210926 1.752377 1.693828 1.635280 1.576731 1.518182 1.459633 1.401084 1.342536 1.283987 1.225438 1.166889 1.108340 1.049792 0.991243 0.932694 #[0.702555, 0.644006, 0.585457, 0.526908, 0.468360, 0.409811, 0.351262, 0.292713, 0.234164, 1.775616, 1.717067, 1.658518, 1.599969, 1.541420, 1.482872, 1.424323] #[0.702555, 0.644006, 0.585457, 0.526908, 0.468360, 0.409811, 0.351262, 0.292713, 0.234164, 1.775616, 1.717067, 1.658518, 1.599969, 1.541420, 1.482872, 1.424323] #[0.702555, 0.644006, 0.585457, 0.526908, 0.468360, 0.409811, 0.351262, 0.292713, 0.234164, 1.775616, 1.717067, 1.658518, 1.599969, 1.541420, 1.482872, 1.424323, 1.365774, 1.307225, 1.248676, 1.190128, 1.131579, 1.073030, 1.014481, 0.955932, 0.897384, 0.838835, 0.780286, 0.721737, 0.663188, 0.604640, 0.546091, 0.487542, 0.428993, 0.370444, 0.311896, 0.253347, 1.794798, 1.736249, 1.677700, 1.619152, 1.560603, 1.502054, 1.443505, 1.384956, 1.326408, 1.267859, 1.209310, 1.150761, 1.092212, 1.033664, 0.975115, 0.916566, 0.858017, 0.799468, 0.740920, 0.682371, 0.623822, 0.565273, 0.506724, 0.448176, 0.389627, 0.331078, 0.272529, 0.213980, 1.755432, 1.696883, 1.638334, 1.579785, 1.521236, 1.462688, 1.404139, 1.345590, 1.287041, 1.228492, 1.169944, 1.111395, 1.052846, 0.994297, 0.935748, 0.877200, 0.818651, 0.760102, 0.701553, 0.643004, 0.584456, 0.525907, 0.467358, 0.408809, 0.350260, 0.291712, 0.233163, 1.774614, 1.716065, 1.657516, 1.598968, 1.540419, 1.481870, 1.423321, 1.364772, 1.306224, 1.247675, 1.189126, 1.130577, 1.072028, 1.013480, 0.954931, 0.896382, 0.837833, 0.779284, 0.720736, 0.662187, 0.603638, 0.545089, 0.486540, 0.427992, 0.369443, 0.310894, 0.252345, 1.793796, 1.735248, 1.676699, 1.618150, 1.559601, 1.501052, 1.442504, 1.383955, 1.325406, 1.266857, 1.208308, 1.149760, 1.091211, 1.032662, 0.974113, 0.915564, 0.857016, 0.798467, 0.739918, 0.681369, 0.622820, 0.564272, 0.505723, 0.447174, 0.388625, 0.330076, 0.271528, 0.212979, 1.754430, 1.695881, 1.637332, 1.578784, 1.520235, 1.461686, 1.403137, 1.344588, 1.286040, 1.227491, 1.168942, 1.110393, 1.051844, 0.993296, 0.934747, 0.876198, 0.817649, 0.759100, 0.700552, 0.642003, 0.583454, 0.524905, 0.466356, 0.407808, 0.349259, 0.290710, 0.232161, 1.773612, 1.715064, 1.656515, 1.597966, 1.539417, 1.480868, 1.422320, 1.363771, 1.305222, 1.246673, 1.188124, 1.129576, 1.071027, 1.012478, 0.953929, 0.895380, 0.836832, 0.778283, 0.719734, 0.661185, 0.602636, 0.544088, 0.485539, 0.426990, 0.368441, 0.309892, 0.251344, 1.792795, 1.734246, 1.675697, 1.617148, 1.558600, 1.500051, 1.441502, 1.382953, 1.324404, 1.265856, 1.207307, 1.148758, 1.090209, 1.031660, 0.973112, 0.914563, 0.856014, 0.797465, 0.738916, 0.680368, 0.621819, 0.563270, 0.504721, 0.446172, 0.387624, 0.329075, 0.270526, 0.211977, 1.753428, 1.694880, 1.636331, 1.577782, 1.519233, 1.460684, 1.402136, 1.343587, 1.285038, 1.226489, 1.167940, 1.109392, 1.050843, 0.992294, 0.933745, 0.875196, 0.816648, 0.758099, 0.699550, 0.641001, 0.582452, 0.523904, 0.465355, 0.406806, 0.348257, 0.289708, 0.231160, 1.772611, 1.714062, 1.655513, 1.596964, 1.538416, 1.479867, 1.421318, 1.362769, 1.304220, 1.245672, 1.187123, 1.128574, 1.070025, 1.011476, 0.952928, 0.894379, 0.835830, 0.777281, 0.718732, 0.660184, 0.601635, 0.543086, 0.484537, 0.425988, 0.367440, 0.308891, 0.250342, 1.791793, 1.733244, 1.674696, 1.616147, 1.557598, 1.499049, 1.440500, 1.381952, 1.323403, 1.264854, 1.206305, 1.147756, 1.089208, 1.030659, 0.972110, 0.913561, 0.855012, 0.796464, 0.737915, 0.679366, 0.620817, 0.562268, 0.503720, 0.445171, 0.386622, 0.328073, 0.269524, 0.210976, 1.752427, 1.693878, 1.635329, 1.576780, 1.518232, 1.459683, 1.401134, 1.342585, 1.284036, 1.225488, 1.166939, 1.108390, 1.049841, 0.991292, 0.932744, 0.874195, 0.815646, 0.757097, 0.698548, 0.640000, 0.581451, 0.522902, 0.464353, 0.405804, 0.347256, 0.288707, 0.230158, 1.771609, 1.713060, 1.654512, 1.595963, 1.537414, 1.478865, 1.420316, 1.361768, 1.303219, 1.244670, 1.186121, 1.127572, 1.069024, 1.010475, 0.951926, 0.893377, 0.834828, 0.776280, 0.717731, 0.659182, 0.600633, 0.542084, 0.483536, 0.424987, 0.366438, 0.307889, 0.249340, 1.790792, 1.732243, 1.673694, 1.615145, 1.556596, 1.498048, 1.439499, 1.380950, 1.322401, 1.263852, 1.205304, 1.146755, 1.088206, 1.029657, 0.971108, 0.912560, 0.854011, 0.795462, 0.736913, 0.678364, 0.619816, 0.561267, 0.502718, 0.444169, 0.385620, 0.327072, 0.268523, 0.209974, 1.751425, 1.692876, 1.634328, 1.575779, 1.517230, 1.458681, 1.400132, 1.341584, 1.283035, 1.224486, 1.165937, 1.107388, 1.048840, 0.990291, 0.931742, 0.873193, 0.814644, 0.756096, 0.697547, 0.638998, 0.580449, 0.521900, 0.463352, 0.404803, 0.346254, 0.287705, 0.229156, 1.770608, 1.712059, 1.653510, 1.594961, 1.536412, 1.477864, 1.419315, 1.360766, 1.302217, 1.243668, 1.185120, 1.126571, 1.068022, 1.009473, 0.950924, 0.892376, 0.833827, 0.775278, 0.716729, 0.658180, 0.599632, 0.541083, 0.482534, 0.423985, 0.365436, 0.306888, 0.248339, 1.789790, 1.731241, 1.672692, 1.614144, 1.555595, 1.497046, 1.438497, 1.379948, 1.321400, 1.262851, 1.204302, 1.145753, 1.087204, 1.028656, 0.970107, 0.911558, 0.853009, 0.794460, 0.735912, 0.677363, 0.618814, 0.560265, 0.501716, 0.443168, 0.384619, 0.326070, 0.267521, 0.208972, 1.750424, 1.691875, 1.633326, 1.574777, 1.516228, 1.457680, 1.399131, 1.340582, 1.282033, 1.223484, 1.164936, 1.106387, 1.047838, 0.989289, 0.930740, 0.872192, 0.813643, 0.755094, 0.696545, 0.637996, 0.579448, 0.520899, 0.462350, 0.403801, 0.345252, 0.286704, 0.228155, 1.769606, 1.711057, 1.652508, 1.593960, 1.535411, 1.476862, 1.418313, 1.359764, 1.301216, 1.242667, 1.184118, 1.125569, 1.067020, 1.008472, 0.949923, 0.891374, 0.832825, 0.774276, 0.715728, 0.657179, 0.598630, 0.540081, 0.481532, 0.422984, 0.364435, 0.305886, 0.247337, 1.788788, 1.730240, 1.671691, 1.613142, 1.554593, 1.496044, 1.437496, 1.378947, 1.320398, 1.261849, 1.203300, 1.144752, 1.086203, 1.027654, 0.969105, 0.910556, 0.852008, 0.793459, 0.734910, 0.676361, 0.617812, 0.559264, 0.500715, 0.442166, 0.383617, 0.325068, 0.266520, 0.207971, 1.749422, 1.690873, 1.632324, 1.573776, 1.515227, 1.456678, 1.398129, 1.339580, 1.281032, 1.222483, 1.163934, 1.105385, 1.046836, 0.988288, 0.929739, 0.871190, 0.812641, 0.754092, 0.695544, 0.636995, 0.578446, 0.519897, 0.461348, 0.402800, 0.344251, 0.285702, 0.227153, 1.768604, 1.710056, 1.651507, 1.592958, 1.534409, 1.475860, 1.417312, 1.358763, 1.300214, 1.241665, 1.183116, 1.124568, 1.066019, 1.007470, 0.948921, 0.890372, 0.831824, 0.773275, 0.714726, 0.656177, 0.597628, 0.539080, 0.480531, 0.421982, 0.363433, 0.304884, 0.246336, 1.787787, 1.729238, 1.670689, 1.612140, 1.553592, 1.495043, 1.436494, 1.377945, 1.319396, 1.260848, 1.202299, 1.143750, 1.085201, 1.026652, 0.968104, 0.909555, 0.851006, 0.792457, 0.733908, 0.675360, 0.616811, 0.558262, 0.499713, 0.441164, 0.382616, 0.324067, 0.265518, 0.206969, 1.748420, 1.689872]))
#eval IO.println ("check_hashemiEnv_flow_mem " ++ toString (check_hashemiEnv_flow_mem 1.694747 1.636198 1.577649 1.519100 1.460552 1.402003 1.343454 1.284905 1.226356 1.167808 1.109259 1.050710 0.992161 0.933612 0.875064 0.816515 0.757966 0.699417 0.640868 0.582320 0.523771 0.465222 0.406673 0.348124 0.289576 0.231027 1.772478 1.713929 1.655380 1.596832 1.538283 1.479734 1.421185 1.362636 1.304088 1.245539 1.186990 1.128441 1.069892 1.011344 0.952795 0.894246 0.835697 0.777148 0.718600 0.660051 0.601502 #[0.371363, 0.312814, 0.254265, 1.795716, 1.737168, 1.678619, 1.620070, 1.561521, 1.502972, 1.444424, 1.385875, 1.327326, 1.268777, 1.210228, 1.151680, 1.093131] #[0.371363, 0.312814, 0.254265, 1.795716, 1.737168, 1.678619, 1.620070, 1.561521, 1.502972, 1.444424, 1.385875, 1.327326, 1.268777, 1.210228, 1.151680, 1.093131] #[0.371363, 0.312814, 0.254265, 1.795716, 1.737168, 1.678619, 1.620070, 1.561521, 1.502972, 1.444424, 1.385875, 1.327326, 1.268777, 1.210228, 1.151680, 1.093131, 1.034582, 0.976033, 0.917484, 0.858936, 0.800387, 0.741838, 0.683289, 0.624740, 0.566192, 0.507643, 0.449094, 0.390545, 0.331996, 0.273448, 0.214899, 1.756350, 1.697801, 1.639252, 1.580704, 1.522155, 1.463606, 1.405057, 1.346508, 1.287960, 1.229411, 1.170862, 1.112313, 1.053764, 0.995216, 0.936667, 0.878118, 0.819569, 0.761020, 0.702472, 0.643923, 0.585374, 0.526825, 0.468276, 0.409728, 0.351179, 0.292630, 0.234081, 1.775532, 1.716984, 1.658435, 1.599886, 1.541337, 1.482788, 1.424240, 1.365691, 1.307142, 1.248593, 1.190044, 1.131496, 1.072947, 1.014398, 0.955849, 0.897300, 0.838752, 0.780203, 0.721654, 0.663105, 0.604556, 0.546008, 0.487459, 0.428910, 0.370361, 0.311812, 0.253264, 1.794715, 1.736166, 1.677617, 1.619068, 1.560520, 1.501971, 1.443422, 1.384873, 1.326324, 1.267776, 1.209227, 1.150678, 1.092129, 1.033580, 0.975032, 0.916483, 0.857934, 0.799385, 0.740836, 0.682288, 0.623739, 0.565190, 0.506641, 0.448092, 0.389544, 0.330995, 0.272446, 0.213897, 1.755348, 1.696800, 1.638251, 1.579702, 1.521153, 1.462604, 1.404056, 1.345507, 1.286958, 1.228409, 1.169860, 1.111312, 1.052763, 0.994214, 0.935665, 0.877116, 0.818568, 0.760019, 0.701470, 0.642921, 0.584372, 0.525824, 0.467275, 0.408726, 0.350177, 0.291628, 0.233080, 1.774531, 1.715982, 1.657433, 1.598884, 1.540336, 1.481787, 1.423238, 1.364689, 1.306140, 1.247592, 1.189043, 1.130494, 1.071945, 1.013396, 0.954848, 0.896299, 0.837750, 0.779201, 0.720652, 0.662104, 0.603555, 0.545006, 0.486457, 0.427908, 0.369360, 0.310811, 0.252262, 1.793713, 1.735164, 1.676616, 1.618067, 1.559518, 1.500969, 1.442420, 1.383872, 1.325323, 1.266774, 1.208225, 1.149676, 1.091128, 1.032579, 0.974030, 0.915481, 0.856932, 0.798384, 0.739835, 0.681286, 0.622737, 0.564188, 0.505640, 0.447091, 0.388542, 0.329993, 0.271444, 0.212896, 1.754347, 1.695798, 1.637249, 1.578700, 1.520152, 1.461603, 1.403054, 1.344505, 1.285956, 1.227408, 1.168859, 1.110310, 1.051761, 0.993212, 0.934664, 0.876115, 0.817566, 0.759017, 0.700468, 0.641920, 0.583371, 0.524822, 0.466273, 0.407724, 0.349176, 0.290627, 0.232078, 1.773529, 1.714980, 1.656432, 1.597883, 1.539334, 1.480785, 1.422236, 1.363688, 1.305139, 1.246590, 1.188041, 1.129492, 1.070944, 1.012395, 0.953846, 0.895297, 0.836748, 0.778200, 0.719651, 0.661102, 0.602553, 0.544004, 0.485456, 0.426907, 0.368358, 0.309809, 0.251260, 1.792712, 1.734163, 1.675614, 1.617065, 1.558516, 1.499968, 1.441419, 1.382870, 1.324321, 1.265772, 1.207224, 1.148675, 1.090126, 1.031577, 0.973028, 0.914480, 0.855931, 0.797382, 0.738833, 0.680284, 0.621736, 0.563187, 0.504638, 0.446089, 0.387540, 0.328992, 0.270443, 0.211894, 1.753345, 1.694796, 1.636248, 1.577699, 1.519150, 1.460601, 1.402052, 1.343504, 1.284955, 1.226406, 1.167857, 1.109308, 1.050760, 0.992211, 0.933662, 0.875113, 0.816564, 0.758016, 0.699467, 0.640918, 0.582369, 0.523820, 0.465272, 0.406723, 0.348174, 0.289625, 0.231076, 1.772528, 1.713979, 1.655430, 1.596881, 1.538332, 1.479784, 1.421235, 1.362686, 1.304137, 1.245588, 1.187040, 1.128491, 1.069942, 1.011393, 0.952844, 0.894296, 0.835747, 0.777198, 0.718649, 0.660100, 0.601552, 0.543003, 0.484454, 0.425905, 0.367356, 0.308808, 0.250259, 1.791710, 1.733161, 1.674612, 1.616064, 1.557515, 1.498966, 1.440417, 1.381868, 1.323320, 1.264771, 1.206222, 1.147673, 1.089124, 1.030576, 0.972027, 0.913478, 0.854929, 0.796380, 0.737832, 0.679283, 0.620734, 0.562185, 0.503636, 0.445088, 0.386539, 0.327990, 0.269441, 0.210892, 1.752344, 1.693795, 1.635246, 1.576697, 1.518148, 1.459600, 1.401051, 1.342502, 1.283953, 1.225404, 1.166856, 1.108307, 1.049758, 0.991209, 0.932660, 0.874112, 0.815563, 0.757014, 0.698465, 0.639916, 0.581368, 0.522819, 0.464270, 0.405721, 0.347172, 0.288624, 0.230075, 1.771526, 1.712977, 1.654428, 1.595880, 1.537331, 1.478782, 1.420233, 1.361684, 1.303136, 1.244587, 1.186038, 1.127489, 1.068940, 1.010392, 0.951843, 0.893294, 0.834745, 0.776196, 0.717648, 0.659099, 0.600550, 0.542001, 0.483452, 0.424904, 0.366355, 0.307806, 0.249257, 1.790708, 1.732160, 1.673611, 1.615062, 1.556513, 1.497964, 1.439416, 1.380867, 1.322318, 1.263769, 1.205220, 1.146672, 1.088123, 1.029574, 0.971025, 0.912476, 0.853928, 0.795379, 0.736830, 0.678281, 0.619732, 0.561184, 0.502635, 0.444086, 0.385537, 0.326988, 0.268440, 0.209891, 1.751342, 1.692793, 1.634244, 1.575696, 1.517147, 1.458598, 1.400049, 1.341500, 1.282952, 1.224403, 1.165854, 1.107305, 1.048756, 0.990208, 0.931659, 0.873110, 0.814561, 0.756012, 0.697464, 0.638915, 0.580366, 0.521817, 0.463268, 0.404720, 0.346171, 0.287622, 0.229073, 1.770524, 1.711976, 1.653427, 1.594878, 1.536329, 1.477780, 1.419232, 1.360683, 1.302134, 1.243585, 1.185036, 1.126488, 1.067939, 1.009390, 0.950841, 0.892292, 0.833744, 0.775195, 0.716646, 0.658097, 0.599548, 0.541000, 0.482451, 0.423902, 0.365353, 0.306804, 0.248256, 1.789707, 1.731158, 1.672609, 1.614060, 1.555512, 1.496963, 1.438414, 1.379865, 1.321316, 1.262768, 1.204219, 1.145670, 1.087121, 1.028572, 0.970024, 0.911475, 0.852926, 0.794377, 0.735828, 0.677280, 0.618731, 0.560182, 0.501633, 0.443084, 0.384536, 0.325987, 0.267438, 0.208889, 1.750340, 1.691792, 1.633243, 1.574694, 1.516145, 1.457596, 1.399048, 1.340499, 1.281950, 1.223401, 1.164852, 1.106304, 1.047755, 0.989206, 0.930657, 0.872108, 0.813560, 0.755011, 0.696462, 0.637913, 0.579364, 0.520816, 0.462267, 0.403718, 0.345169, 0.286620, 0.228072, 1.769523, 1.710974, 1.652425, 1.593876, 1.535328, 1.476779, 1.418230, 1.359681, 1.301132, 1.242584, 1.184035, 1.125486, 1.066937, 1.008388, 0.949840, 0.891291, 0.832742, 0.774193, 0.715644, 0.657096, 0.598547, 0.539998, 0.481449, 0.422900, 0.364352, 0.305803, 0.247254, 1.788705, 1.730156, 1.671608, 1.613059, 1.554510, 1.495961, 1.437412, 1.378864, 1.320315, 1.261766, 1.203217, 1.144668, 1.086120, 1.027571, 0.969022, 0.910473, 0.851924, 0.793376, 0.734827, 0.676278, 0.617729, 0.559180, 0.500632, 0.442083, 0.383534, 0.324985, 0.266436, 0.207888, 1.749339, 1.690790, 1.632241, 1.573692, 1.515144, 1.456595, 1.398046, 1.339497, 1.280948, 1.222400, 1.163851, 1.105302, 1.046753, 0.988204, 0.929656, 0.871107, 0.812558, 0.754009, 0.695460, 0.636912, 0.578363, 0.519814, 0.461265, 0.402716, 0.344168, 0.285619, 0.227070, 1.768521, 1.709972, 1.651424, 1.592875, 1.534326, 1.475777, 1.417228, 1.358680]))

def check_hashemiEnv_hist_head (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (Twall : Float) (Ta : Float) (uPump : Float) (Qmax : Float) (Dp : Float) (Lp : Float) (Dins : Float) (kIns : Float) (Vw : Float) (etaP : Float) (Pidle : Float) (Axch : Float) (UAxMax : Float) (Ccoil : Float) (degPrev : Float) (degA : Float) (degEa : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v729 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v741 := ((1.22 : Float) * (0.8 : Float))
  let v742 := ((0.34 : Float) * v729)
  let v745 := ((3.141592653589793 : Float) / (2 : Float))
  let v752 := (if (v741 <= v742) then v745 else (Float.atan ((((1.22 : Float) * v729) + ((0.34 : Float) * (0.8 : Float))) / (v741 - v742))))
  let v753 := (-(1.22 : Float))
  let v754 := (-(0.8 : Float))
  let v756 := (Float.cos (0 : Float))
  let v758 := (-v729)
  let v759 := (Float.sin (0 : Float))
  let v762 := (-v754)
  let v771 := (Float.sqrt (((((v754 * v756) + (v758 * v759)) - v753) ^ 2) + ((((v762 * v759) + (v758 * v756)) - (0.34 : Float)) ^ 2)))
  let v772 := (Float.cos v752)
  let v774 := (Float.sin v752)
  let v785 := (Float.sqrt (((((v754 * v772) + (v758 * v774)) - v753) ^ 2) + ((((v762 * v774) + (v758 * v772)) - (0.34 : Float)) ^ 2)))
  let v786 := (Float.cos t)
  let v788 := (Float.sin t)
  let v790 := ((v754 * v786) + (v758 * v788))
  let v793 := ((v762 * v788) + (v758 * v786))
  let v799 := (Float.sqrt (((v790 - v753) ^ 2) + ((v793 - (0.34 : Float)) ^ 2)))
  let v801 := (omegad * rDrum)
  let v803 := ((v799 + slack) - (v801 * dt))
  let v804 := (v803 < v785)
  let v805 := (v771 < v803)
  let v807 := (if v804 then v785 else (if v805 then v771 else v803))
  let v812 := (((0 : Float) + v752) / (2 : Float))
  let v813 := (Float.cos v812)
  let v815 := (Float.sin v812)
  let v827 := (v807 < (Float.sqrt (((((v754 * v813) + (v758 * v815)) - v753) ^ 2) + ((((v762 * v815) + (v758 * v813)) - (0.34 : Float)) ^ 2))))
  let v828 := (if v827 then v812 else (0 : Float))
  let v829 := (if v827 then v752 else v812)
  let v831 := ((v828 + v829) / (2 : Float))
  let v832 := (Float.cos v831)
  let v834 := (Float.sin v831)
  let v846 := (v807 < (Float.sqrt (((((v754 * v832) + (v758 * v834)) - v753) ^ 2) + ((((v762 * v834) + (v758 * v832)) - (0.34 : Float)) ^ 2))))
  let v847 := (if v846 then v831 else v828)
  let v848 := (if v846 then v829 else v831)
  let v850 := ((v847 + v848) / (2 : Float))
  let v851 := (Float.cos v850)
  let v853 := (Float.sin v850)
  let v865 := (v807 < (Float.sqrt (((((v754 * v851) + (v758 * v853)) - v753) ^ 2) + ((((v762 * v853) + (v758 * v851)) - (0.34 : Float)) ^ 2))))
  let v866 := (if v865 then v850 else v847)
  let v867 := (if v865 then v848 else v850)
  let v869 := ((v866 + v867) / (2 : Float))
  let v870 := (Float.cos v869)
  let v872 := (Float.sin v869)
  let v884 := (v807 < (Float.sqrt (((((v754 * v870) + (v758 * v872)) - v753) ^ 2) + ((((v762 * v872) + (v758 * v870)) - (0.34 : Float)) ^ 2))))
  let v885 := (if v884 then v869 else v866)
  let v886 := (if v884 then v867 else v869)
  let v888 := ((v885 + v886) / (2 : Float))
  let v889 := (Float.cos v888)
  let v891 := (Float.sin v888)
  let v903 := (v807 < (Float.sqrt (((((v754 * v889) + (v758 * v891)) - v753) ^ 2) + ((((v762 * v891) + (v758 * v889)) - (0.34 : Float)) ^ 2))))
  let v904 := (if v903 then v888 else v885)
  let v905 := (if v903 then v886 else v888)
  let v907 := ((v904 + v905) / (2 : Float))
  let v908 := (Float.cos v907)
  let v910 := (Float.sin v907)
  let v922 := (v807 < (Float.sqrt (((((v754 * v908) + (v758 * v910)) - v753) ^ 2) + ((((v762 * v910) + (v758 * v908)) - (0.34 : Float)) ^ 2))))
  let v923 := (if v922 then v907 else v904)
  let v924 := (if v922 then v905 else v907)
  let v926 := ((v923 + v924) / (2 : Float))
  let v927 := (Float.cos v926)
  let v929 := (Float.sin v926)
  let v941 := (v807 < (Float.sqrt (((((v754 * v927) + (v758 * v929)) - v753) ^ 2) + ((((v762 * v929) + (v758 * v927)) - (0.34 : Float)) ^ 2))))
  let v942 := (if v941 then v926 else v923)
  let v943 := (if v941 then v924 else v926)
  let v945 := ((v942 + v943) / (2 : Float))
  let v946 := (Float.cos v945)
  let v948 := (Float.sin v945)
  let v960 := (v807 < (Float.sqrt (((((v754 * v946) + (v758 * v948)) - v753) ^ 2) + ((((v762 * v948) + (v758 * v946)) - (0.34 : Float)) ^ 2))))
  let v961 := (if v960 then v945 else v942)
  let v962 := (if v960 then v943 else v945)
  let v964 := ((v961 + v962) / (2 : Float))
  let v965 := (Float.cos v964)
  let v967 := (Float.sin v964)
  let v979 := (v807 < (Float.sqrt (((((v754 * v965) + (v758 * v967)) - v753) ^ 2) + ((((v762 * v967) + (v758 * v965)) - (0.34 : Float)) ^ 2))))
  let v980 := (if v979 then v964 else v961)
  let v981 := (if v979 then v962 else v964)
  let v983 := ((v980 + v981) / (2 : Float))
  let v984 := (Float.cos v983)
  let v986 := (Float.sin v983)
  let v998 := (v807 < (Float.sqrt (((((v754 * v984) + (v758 * v986)) - v753) ^ 2) + ((((v762 * v986) + (v758 * v984)) - (0.34 : Float)) ^ 2))))
  let v999 := (if v998 then v983 else v980)
  let v1000 := (if v998 then v981 else v983)
  let v1002 := ((v999 + v1000) / (2 : Float))
  let v1003 := (Float.cos v1002)
  let v1005 := (Float.sin v1002)
  let v1017 := (v807 < (Float.sqrt (((((v754 * v1003) + (v758 * v1005)) - v753) ^ 2) + ((((v762 * v1005) + (v758 * v1003)) - (0.34 : Float)) ^ 2))))
  let v1018 := (if v1017 then v1002 else v999)
  let v1019 := (if v1017 then v1000 else v1002)
  let v1021 := ((v1018 + v1019) / (2 : Float))
  let v1022 := (Float.cos v1021)
  let v1024 := (Float.sin v1021)
  let v1036 := (v807 < (Float.sqrt (((((v754 * v1022) + (v758 * v1024)) - v753) ^ 2) + ((((v762 * v1024) + (v758 * v1022)) - (0.34 : Float)) ^ 2))))
  let v1037 := (if v1036 then v1021 else v1018)
  let v1038 := (if v1036 then v1019 else v1021)
  let v1040 := ((v1037 + v1038) / (2 : Float))
  let v1041 := (Float.cos v1040)
  let v1043 := (Float.sin v1040)
  let v1055 := (v807 < (Float.sqrt (((((v754 * v1041) + (v758 * v1043)) - v753) ^ 2) + ((((v762 * v1043) + (v758 * v1041)) - (0.34 : Float)) ^ 2))))
  let v1056 := (if v1055 then v1040 else v1037)
  let v1057 := (if v1055 then v1038 else v1040)
  let v1059 := ((v1056 + v1057) / (2 : Float))
  let v1060 := (Float.cos v1059)
  let v1062 := (Float.sin v1059)
  let v1074 := (v807 < (Float.sqrt (((((v754 * v1060) + (v758 * v1062)) - v753) ^ 2) + ((((v762 * v1062) + (v758 * v1060)) - (0.34 : Float)) ^ 2))))
  let v1075 := (if v1074 then v1059 else v1056)
  let v1076 := (if v1074 then v1057 else v1059)
  let v1078 := ((v1075 + v1076) / (2 : Float))
  let v1079 := (Float.cos v1078)
  let v1081 := (Float.sin v1078)
  let v1093 := (v807 < (Float.sqrt (((((v754 * v1079) + (v758 * v1081)) - v753) ^ 2) + ((((v762 * v1081) + (v758 * v1079)) - (0.34 : Float)) ^ 2))))
  let v1094 := (if v1093 then v1078 else v1075)
  let v1095 := (if v1093 then v1076 else v1078)
  let v1097 := ((v1094 + v1095) / (2 : Float))
  let v1098 := (Float.cos v1097)
  let v1100 := (Float.sin v1097)
  let v1112 := (v807 < (Float.sqrt (((((v754 * v1098) + (v758 * v1100)) - v753) ^ 2) + ((((v762 * v1100) + (v758 * v1098)) - (0.34 : Float)) ^ 2))))
  let v1113 := (if v1112 then v1097 else v1094)
  let v1114 := (if v1112 then v1095 else v1097)
  let v1116 := ((v1113 + v1114) / (2 : Float))
  let v1117 := (Float.cos v1116)
  let v1119 := (Float.sin v1116)
  let v1131 := (v807 < (Float.sqrt (((((v754 * v1117) + (v758 * v1119)) - v753) ^ 2) + ((((v762 * v1119) + (v758 * v1117)) - (0.34 : Float)) ^ 2))))
  let v1132 := (if v1131 then v1116 else v1113)
  let v1133 := (if v1131 then v1114 else v1116)
  let v1135 := ((v1132 + v1133) / (2 : Float))
  let v1136 := (Float.cos v1135)
  let v1138 := (Float.sin v1135)
  let v1150 := (v807 < (Float.sqrt (((((v754 * v1136) + (v758 * v1138)) - v753) ^ 2) + ((((v762 * v1138) + (v758 * v1136)) - (0.34 : Float)) ^ 2))))
  let v1151 := (if v1150 then v1135 else v1132)
  let v1152 := (if v1150 then v1133 else v1135)
  let v1154 := ((v1151 + v1152) / (2 : Float))
  let v1155 := (Float.cos v1154)
  let v1157 := (Float.sin v1154)
  let v1169 := (v807 < (Float.sqrt (((((v754 * v1155) + (v758 * v1157)) - v753) ^ 2) + ((((v762 * v1157) + (v758 * v1155)) - (0.34 : Float)) ^ 2))))
  let v1170 := (if v1169 then v1154 else v1151)
  let v1171 := (if v1169 then v1152 else v1154)
  let v1173 := ((v1170 + v1171) / (2 : Float))
  let v1174 := (Float.cos v1173)
  let v1176 := (Float.sin v1173)
  let v1188 := (v807 < (Float.sqrt (((((v754 * v1174) + (v758 * v1176)) - v753) ^ 2) + ((((v762 * v1176) + (v758 * v1174)) - (0.34 : Float)) ^ 2))))
  let v1189 := (if v1188 then v1173 else v1170)
  let v1190 := (if v1188 then v1171 else v1173)
  let v1192 := ((v1189 + v1190) / (2 : Float))
  let v1193 := (Float.cos v1192)
  let v1195 := (Float.sin v1192)
  let v1207 := (v807 < (Float.sqrt (((((v754 * v1193) + (v758 * v1195)) - v753) ^ 2) + ((((v762 * v1195) + (v758 * v1193)) - (0.34 : Float)) ^ 2))))
  let v1208 := (if v1207 then v1192 else v1189)
  let v1209 := (if v1207 then v1190 else v1192)
  let v1211 := ((v1208 + v1209) / (2 : Float))
  let v1212 := (Float.cos v1211)
  let v1214 := (Float.sin v1211)
  let v1226 := (v807 < (Float.sqrt (((((v754 * v1212) + (v758 * v1214)) - v753) ^ 2) + ((((v762 * v1214) + (v758 * v1212)) - (0.34 : Float)) ^ 2))))
  let v1227 := (if v1226 then v1211 else v1208)
  let v1228 := (if v1226 then v1209 else v1211)
  let v1230 := ((v1227 + v1228) / (2 : Float))
  let v1231 := (Float.cos v1230)
  let v1233 := (Float.sin v1230)
  let v1245 := (v807 < (Float.sqrt (((((v754 * v1231) + (v758 * v1233)) - v753) ^ 2) + ((((v762 * v1233) + (v758 * v1231)) - (0.34 : Float)) ^ 2))))
  let v1246 := (if v1245 then v1230 else v1227)
  let v1247 := (if v1245 then v1228 else v1230)
  let v1249 := ((v1246 + v1247) / (2 : Float))
  let v1250 := (Float.cos v1249)
  let v1252 := (Float.sin v1249)
  let v1264 := (v807 < (Float.sqrt (((((v754 * v1250) + (v758 * v1252)) - v753) ^ 2) + ((((v762 * v1252) + (v758 * v1250)) - (0.34 : Float)) ^ 2))))
  let v1269 := (if (v771 <= v803) then (0 : Float) else (((if v1264 then v1249 else v1246) + (if v1264 then v1247 else v1249)) / (2 : Float)))
  let v1270 := (W * rcm)
  let v1271 := (Float.cos v1269)
  let v1273 := (Float.sin v1269)
  let v1275 := ((v754 * v1271) + (v758 * v1273))
  let v1278 := ((v762 * v1273) + (v758 * v1271))
  let v1293 := ((t < v1269) && (!(v1270 <= (Tmax * (((v753 * v1278) - ((0.34 : Float) * v1275)) / (Float.sqrt (((v1275 - v753) ^ 2) + ((v1278 - (0.34 : Float)) ^ 2))))))))
  let v1294 := (if v1293 then t else v1269)
  let v1299 := (az + (((omegam * (0.05 : Float)) / (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))) * dt))
  let v1304 := (Float.cos v1294)
  let v1306 := (Float.sin v1294)
  let v1334 := (Float.cos elSun)
  let v1336 := (v1334 * (Float.cos azSun))
  let v1338 := (v1334 * (Float.sin azSun))
  let v1339 := (Float.sin elSun)
  let v1386 := (Float.cos v1299)
  let v1387 := (v1306 * v1386)
  let v1388 := (Float.sin v1299)
  let v1389 := (v1306 * v1388)
  let v1390 := (v1304 * v1386)
  let v1391 := (v1304 * v1388)
  let v1392 := (-v1306)
  let v1417 := ((2 : Float) * a)
  let v1418 := (v1417 / w)
  let v1420 := (w / (2 : Float))
  let v1421 := ((-a) + v1420)
  let v1440 := ((1 : Float) / (2 : Float))
  let v1445 := (-(((((v1391 * v1304) - (v1392 * v1389)) * v1336) + (((v1392 * v1387) - (v1390 * v1304)) * v1338)) + (((v1390 * v1389) - (v1391 * v1387)) * v1339)))
  let v1446 := (-(((v1390 * v1336) + (v1391 * v1338)) + (v1392 * v1339)))
  let v1447 := (-(((v1387 * v1336) + (v1389 * v1338)) + (v1304 * v1339)))
  let v1452 := ((Float.abs v1447) < ((9 : Float) / (10 : Float)))
  let v1453 := (if v1452 then (0 : Float) else (1 : Float))
  let v1454 := (if v1452 then (1 : Float) else (0 : Float))
  let v1457 := ((v1446 * v1454) - (v1447 * (0 : Float)))
  let v1460 := ((v1447 * v1453) - (v1445 * v1454))
  let v1463 := ((v1445 * (0 : Float)) - (v1446 * v1453))
  let v1471 := (Float.sqrt (max (((v1457 ^ 2) + (v1460 ^ 2)) + (v1463 ^ 2)) (0.000000000000000001 : Float)))
  let v1472 := (v1457 / v1471)
  let v1473 := (v1460 / v1471)
  let v1474 := (v1463 / v1471)
  let v1486 := ((2 : Float) * (3.141592653589793 : Float))
  let v1523 := ((2 : Float) * f)
  let v1524 := ((1 : Float) / R)
  let v1633 := (v1417 ^ 2)
  let v1661 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((0 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1666 := (((((v1661 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1677 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((1 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1682 := (((((v1677 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1693 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((2 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1698 := (((((v1693 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1710 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((3 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1715 := (((((v1710 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1727 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((4 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1732 := (((((v1727 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1744 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((5 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1749 := (((((v1744 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1761 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((6 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1766 := (((((v1761 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1778 := ((List.range 64).foldl (fun acc i => acc + (let v1435 := (v1421 + (w * (Float.floor (dr[i * 10 + 0]! * v1418)))); let v1439 := (v1421 + (w * (Float.floor (dr[i * 10 + 1]! * v1418)))); let v1442 := ((dr[i * 10 + 2]! - v1440) * w); let v1444 := ((dr[i * 10 + 3]! - v1440) * w); let v1485 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v1487 := (v1486 * dr[i * 10 + 5]!); let v1488 := (Float.cos v1485); let v1490 := (Float.sin v1485); let v1491 := (Float.cos v1487); let v1493 := (Float.sin v1487); let v1497 := ((v1488 * v1445) + (v1490 * ((v1491 * v1472) + (v1493 * ((v1446 * v1474) - (v1447 * v1473)))))); let v1503 := ((v1488 * v1446) + (v1490 * ((v1491 * v1473) + (v1493 * ((v1447 * v1472) - (v1445 * v1474)))))); let v1509 := ((v1488 * v1447) + (v1490 * ((v1491 * v1474) + (v1493 * ((v1445 * v1473) - (v1446 * v1472)))))); let v1521 := (v1435 + v1442); let v1522 := (v1439 + v1444); let v1529 := (Float.sqrt (max ((v1435 ^ 2) + (v1439 ^ 2)) (0.000000000000000001 : Float))); let v1530 := (v1529 ^ 2); let v1536 := ((1 : Float) - ((((1 : Float) + k) * (v1524 ^ 2)) * v1530)); let v1544 := ((v1524 * v1529) / (Float.sqrt (max v1536 (0.000000000000000001 : Float)))); let v1547 := (Float.sqrt ((1 : Float) + (v1544 ^ 2))); let v1548 := (-v1544); let v1551 := (((v1548 * v1435) / v1529) / v1547); let v1554 := (((v1548 * v1439) / v1529) / v1547); let v1555 := ((1 : Float) / v1547); let v1557 := (v1551 + (sigmaslope * dr[i * 10 + 6]!)); let v1559 := (v1554 + (sigmaslope * dr[i * 10 + 7]!)); let v1565 := (Float.sqrt (((v1557 ^ 2) + (v1559 ^ 2)) + (v1555 ^ 2))); let v1566 := (v1557 / v1565); let v1567 := (v1559 / v1565); let v1568 := (v1555 / v1565); let v1582 := (((((v1435 - v1521) * v1551) + ((v1439 - v1522) * v1554)) + ((((v1524 * v1530) / ((1 : Float) + (Float.sqrt (max v1536 (0 : Float))))) - v1523) * v1555)) / (((v1497 * v1551) + (v1503 * v1554)) + (v1509 * v1555))); let v1594 := ((2 : Float) * (((v1497 * v1566) + (v1503 * v1567)) + (v1509 * v1568))); let v1600 := (v1509 - (v1594 * v1568)); let v1602 := ((v1497 - (v1594 * v1566)) + (sigmaspec * dr[i * 10 + 8]!)); let v1604 := ((v1503 - (v1594 * v1567)) + (sigmaspec * dr[i * 10 + 9]!)); let v1610 := (Float.sqrt (((v1602 ^ 2) + (v1604 ^ 2)) + (v1600 ^ 2))); let v1613 := (v1600 / v1610); let v1615 := ((f - (v1523 + (v1582 * v1509))) / v1613); let v1623 := (Float.sqrt ((((v1521 + (v1582 * v1497)) + (v1615 * (v1602 / v1610))) ^ 2) + (((v1522 + (v1582 * v1503)) + (v1615 * (v1604 / v1610))) ^ 2))); (if ((((((7 : Float) * rc) / (8 : Float)) <= v1623) && (v1623 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v1435) <= a) && (((Float.abs v1439) <= a) && (((Float.abs v1442) <= v1420) && ((Float.abs v1444) <= v1420)))) && ((v1623 <= rc) && ((0 : Float) < v1613))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v1783 := (((((v1778 / (64 : Float)) * v1633) * rho) * dni) * soil)
  let v1786 := (Qmax * (min (max uPump (0 : Float)) (1 : Float)))
  let v1789 := (min (618.15 : Float) (max Ta hist[0]!))
  let v1791 := (v1789 - (273.15 : Float))
  let v1797 := (v1791 ^ 2)
  let v1799 := (((1020.62 : Float) - ((0.614254 : Float) * v1791)) - ((0.000321 : Float) * v1797))
  let v1809 := ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v1791)) + ((0.0000008970757 : Float) * v1797)))
  let v1810 := ((v1799 * v1786) * v1809)
  let v1812 := (max v1810 (0.000001 : Float))
  let v1813 := (Ccoil / dt)
  let v1814 := (v1810 + v1813)
  let v1824 := ((5.7 : Float) + ((3.8 : Float) * Vw))
  let v1830 := (Dp ^ 2)
  let v1833 := (v1786 / (((3.141592653589793 : Float) * v1830) / (4 : Float)))
  let v1838 := (min (max ((Lp / (max v1833 (0.000001 : Float))) / dt) (0 : Float)) (7 : Float))
  let v1839 := (v1838 < (1 : Float))
  let v1840 := (v1838 < (2 : Float))
  let v1841 := (v1838 < (3 : Float))
  let v1842 := (v1838 < (4 : Float))
  let v1843 := (v1838 < (5 : Float))
  let v1844 := (v1838 < (6 : Float))
  let v1845 := (v1838 < (7 : Float))
  let v1860 := (v1838 - (Float.floor v1838))
  let v1870 := (if v1839 then ret[0]! else (if v1840 then ret[1]! else (if v1841 then ret[2]! else (if v1842 then ret[3]! else (if v1843 then ret[4]! else (if v1844 then ret[5]! else (if v1845 then ret[6]! else ret[7]!)))))))
  let v1879 := (v1870 + (v1860 * ((if v1839 then ret[1]! else (if v1840 then ret[2]! else (if v1841 then ret[3]! else (if v1842 then ret[4]! else (if v1843 then ret[5]! else (if v1844 then ret[6]! else ret[7]!)))))) - v1870)))
  let v1884 := (Float.exp ((-((Lp / (((Float.log (max (Dins / Dp) (1.0001 : Float))) / (v1486 * kIns)) + ((1 : Float) / ((v1824 * (3.141592653589793 : Float)) * Dins)))) / (2 : Float))) / v1812))
  let v1944 := (((v1810 * (Ta + ((v1879 - Ta) * v1884))) + (v1813 * v1789)) / v1814)
  let v1948 := (Ac / (8 : Float))
  let v1949 := ((eps * (0.0000000567 : Float)) * v1948)
  let v1951 := (Ta ^ 4)
  let v1954 := (v1824 * v1948)
  let v1960 := (v1944 + (((alpha * v1666) - ((v1949 * ((v1944 ^ 4) - v1951)) + (v1954 * (v1944 - Ta)))) / v1814))
  let v1970 := (v1960 + (((alpha * v1682) - ((v1949 * ((v1960 ^ 4) - v1951)) + (v1954 * (v1960 - Ta)))) / v1814))
  let v1980 := (v1970 + (((alpha * v1698) - ((v1949 * ((v1970 ^ 4) - v1951)) + (v1954 * (v1970 - Ta)))) / v1814))
  let v1990 := (v1980 + (((alpha * v1715) - ((v1949 * ((v1980 ^ 4) - v1951)) + (v1954 * (v1980 - Ta)))) / v1814))
  let v2000 := (v1990 + (((alpha * v1732) - ((v1949 * ((v1990 ^ 4) - v1951)) + (v1954 * (v1990 - Ta)))) / v1814))
  let v2010 := (v2000 + (((alpha * v1749) - ((v1949 * ((v2000 ^ 4) - v1951)) + (v1954 * (v2000 - Ta)))) / v1814))
  let v2020 := (v2010 + (((alpha * v1766) - ((v1949 * ((v2010 ^ 4) - v1951)) + (v1954 * (v2010 - Ta)))) / v1814))
  let v2030 := (v2020 + (((alpha * v1783) - ((v1949 * ((v2020 ^ 4) - v1951)) + (v1954 * (v2020 - Ta)))) / v1814))
  let v2032 := (min (618.15 : Float) (max Ta v2030))
  (feq v2032 v2032)

#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.570979 0.512430 0.453881 0.395332 0.336784 0.278235 0.219686 1.761137 1.702588 1.644040 1.585491 1.526942 1.468393 1.409844 1.351296 1.292747 1.234198 1.175649 1.117100 1.058552 1.000003 0.941454 0.882905 0.824356 0.765808 0.707259 0.648710 0.590161 0.531612 0.473064 0.414515 0.355966 0.297417 0.238868 1.780320 1.721771 1.663222 1.604673 1.546124 1.487576 1.429027 1.370478 1.311929 1.253380 1.194832 1.136283 1.077734 #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363, 1.510814, 1.452265, 1.393716, 1.335168, 1.276619, 1.218070, 1.159521, 1.100972, 1.042424, 0.983875, 0.925326, 0.866777, 0.808228, 0.749680, 0.691131, 0.632582, 0.574033, 0.515484, 0.456936, 0.398387, 0.339838, 0.281289, 0.222740, 1.764192, 1.705643, 1.647094, 1.588545, 1.529996, 1.471448, 1.412899, 1.354350, 1.295801, 1.237252, 1.178704, 1.120155, 1.061606, 1.003057, 0.944508, 0.885960, 0.827411, 0.768862, 0.710313, 0.651764, 0.593216, 0.534667, 0.476118, 0.417569, 0.359020, 0.300472, 0.241923, 1.783374, 1.724825, 1.666276, 1.607728, 1.549179, 1.490630, 1.432081, 1.373532, 1.314984, 1.256435, 1.197886, 1.139337, 1.080788, 1.022240, 0.963691, 0.905142, 0.846593, 0.788044, 0.729496, 0.670947, 0.612398, 0.553849, 0.495300, 0.436752, 0.378203, 0.319654, 0.261105, 0.202556, 1.744008, 1.685459, 1.626910, 1.568361, 1.509812, 1.451264, 1.392715, 1.334166, 1.275617, 1.217068, 1.158520, 1.099971, 1.041422, 0.982873, 0.924324, 0.865776, 0.807227, 0.748678, 0.690129, 0.631580, 0.573032, 0.514483, 0.455934, 0.397385, 0.338836, 0.280288, 0.221739, 1.763190, 1.704641, 1.646092, 1.587544, 1.528995, 1.470446, 1.411897, 1.353348, 1.294800, 1.236251, 1.177702, 1.119153, 1.060604, 1.002056, 0.943507, 0.884958, 0.826409, 0.767860, 0.709312, 0.650763, 0.592214, 0.533665, 0.475116, 0.416568, 0.358019, 0.299470, 0.240921, 1.782372, 1.723824, 1.665275, 1.606726, 1.548177, 1.489628, 1.431080, 1.372531, 1.313982, 1.255433, 1.196884, 1.138336, 1.079787, 1.021238, 0.962689, 0.904140, 0.845592, 0.787043, 0.728494, 0.669945, 0.611396, 0.552848, 0.494299, 0.435750, 0.377201, 0.318652, 0.260104, 0.201555, 1.743006, 1.684457, 1.625908, 1.567360, 1.508811, 1.450262, 1.391713, 1.333164, 1.274616, 1.216067, 1.157518, 1.098969, 1.040420, 0.981872, 0.923323, 0.864774, 0.806225, 0.747676, 0.689128, 0.630579, 0.572030, 0.513481, 0.454932, 0.396384, 0.337835, 0.279286, 0.220737, 1.762188, 1.703640, 1.645091, 1.586542, 1.527993, 1.469444, 1.410896, 1.352347, 1.293798, 1.235249, 1.176700, 1.118152, 1.059603, 1.001054, 0.942505, 0.883956, 0.825408, 0.766859, 0.708310, 0.649761, 0.591212, 0.532664, 0.474115, 0.415566, 0.357017, 0.298468, 0.239920, 1.781371, 1.722822, 1.664273, 1.605724, 1.547176, 1.488627, 1.430078, 1.371529, 1.312980, 1.254432, 1.195883, 1.137334, 1.078785, 1.020236, 0.961688, 0.903139, 0.844590, 0.786041, 0.727492, 0.668944, 0.610395, 0.551846, 0.493297, 0.434748, 0.376200, 0.317651, 0.259102, 0.200553, 1.742004, 1.683456, 1.624907, 1.566358, 1.507809, 1.449260, 1.390712, 1.332163, 1.273614, 1.215065, 1.156516, 1.097968, 1.039419, 0.980870, 0.922321, 0.863772, 0.805224, 0.746675, 0.688126, 0.629577, 0.571028, 0.512480, 0.453931, 0.395382, 0.336833, 0.278284, 0.219736, 1.761187, 1.702638, 1.644089, 1.585540, 1.526992, 1.468443, 1.409894, 1.351345, 1.292796, 1.234248, 1.175699, 1.117150, 1.058601, 1.000052, 0.941504, 0.882955, 0.824406, 0.765857, 0.707308, 0.648760, 0.590211, 0.531662, 0.473113, 0.414564, 0.356016, 0.297467, 0.238918, 1.780369, 1.721820, 1.663272, 1.604723, 1.546174, 1.487625, 1.429076, 1.370528, 1.311979, 1.253430, 1.194881, 1.136332, 1.077784, 1.019235, 0.960686, 0.902137, 0.843588, 0.785040, 0.726491, 0.667942, 0.609393, 0.550844, 0.492296, 0.433747, 0.375198, 0.316649, 0.258100, 1.799552, 1.741003, 1.682454, 1.623905, 1.565356, 1.506808, 1.448259, 1.389710, 1.331161, 1.272612, 1.214064, 1.155515, 1.096966, 1.038417, 0.979868, 0.921320, 0.862771, 0.804222, 0.745673, 0.687124, 0.628576, 0.570027, 0.511478, 0.452929, 0.394380, 0.335832, 0.277283, 0.218734, 1.760185, 1.701636, 1.643088, 1.584539, 1.525990, 1.467441, 1.408892, 1.350344, 1.291795, 1.233246, 1.174697, 1.116148, 1.057600, 0.999051, 0.940502, 0.881953, 0.823404, 0.764856, 0.706307, 0.647758, 0.589209, 0.530660, 0.472112, 0.413563, 0.355014, 0.296465, 0.237916, 1.779368, 1.720819, 1.662270, 1.603721, 1.545172, 1.486624, 1.428075, 1.369526, 1.310977, 1.252428, 1.193880, 1.135331, 1.076782, 1.018233, 0.959684, 0.901136, 0.842587, 0.784038, 0.725489, 0.666940, 0.608392, 0.549843, 0.491294, 0.432745, 0.374196, 0.315648, 0.257099, 1.798550, 1.740001, 1.681452, 1.622904, 1.564355, 1.505806, 1.447257, 1.388708, 1.330160, 1.271611, 1.213062, 1.154513, 1.095964, 1.037416, 0.978867, 0.920318, 0.861769, 0.803220, 0.744672, 0.686123, 0.627574, 0.569025, 0.510476, 0.451928, 0.393379, 0.334830, 0.276281, 0.217732, 1.759184, 1.700635, 1.642086, 1.583537, 1.524988, 1.466440, 1.407891, 1.349342, 1.290793, 1.232244, 1.173696, 1.115147, 1.056598, 0.998049, 0.939500, 0.880952, 0.822403, 0.763854, 0.705305, 0.646756, 0.588208, 0.529659, 0.471110, 0.412561, 0.354012, 0.295464, 0.236915, 1.778366, 1.719817, 1.661268, 1.602720, 1.544171, 1.485622, 1.427073, 1.368524, 1.309976, 1.251427, 1.192878, 1.134329, 1.075780, 1.017232, 0.958683, 0.900134, 0.841585, 0.783036, 0.724488, 0.665939, 0.607390, 0.548841, 0.490292, 0.431744, 0.373195, 0.314646, 0.256097, 1.797548, 1.739000, 1.680451, 1.621902, 1.563353, 1.504804, 1.446256, 1.387707, 1.329158, 1.270609, 1.212060, 1.153512, 1.094963, 1.036414, 0.977865, 0.919316, 0.860768, 0.802219, 0.743670, 0.685121, 0.626572, 0.568024, 0.509475, 0.450926, 0.392377, 0.333828, 0.275280, 0.216731, 1.758182, 1.699633, 1.641084, 1.582536, 1.523987, 1.465438, 1.406889, 1.348340, 1.289792, 1.231243, 1.172694, 1.114145, 1.055596, 0.997048, 0.938499, 0.879950, 0.821401, 0.762852, 0.704304, 0.645755, 0.587206, 0.528657, 0.470108, 0.411560, 0.353011, 0.294462, 0.235913, 1.777364, 1.718816, 1.660267, 1.601718, 1.543169, 1.484620, 1.426072, 1.367523, 1.308974, 1.250425, 1.191876, 1.133328, 1.074779, 1.016230, 0.957681, 0.899132, 0.840584, 0.782035, 0.723486, 0.664937, 0.606388, 0.547840, 0.489291, 0.430742, 0.372193, 0.313644, 0.255096, 1.796547, 1.737998, 1.679449, 1.620900, 1.562352, 1.503803, 1.445254, 1.386705, 1.328156, 1.269608, 1.211059, 1.152510, 1.093961, 1.035412, 0.976864, 0.918315, 0.859766, 0.801217, 0.742668, 0.684120, 0.625571, 0.567022, 0.508473, 0.449924, 0.391376, 0.332827, 0.274278, 0.215729, 1.757180, 1.698632, 1.640083, 1.581534, 1.522985, 1.464436, 1.405888, 1.347339, 1.288790, 1.230241, 1.171692, 1.113144, 1.054595, 0.996046, 0.937497, 0.878948, 0.820400, 0.761851, 0.703302, 0.644753, 0.586204, 0.527656, 0.469107, 0.410558, 0.352009, 0.293460, 0.234912]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.239787 1.781238 1.722689 1.664140 1.605592 1.547043 1.488494 1.429945 1.371396 1.312848 1.254299 1.195750 1.137201 1.078652 1.020104 0.961555 0.903006 0.844457 0.785908 0.727360 0.668811 0.610262 0.551713 0.493164 0.434616 0.376067 0.317518 0.258969 0.200420 1.741872 1.683323 1.624774 1.566225 1.507676 1.449128 1.390579 1.332030 1.273481 1.214932 1.156384 1.097835 1.039286 0.980737 0.922188 0.863640 0.805091 0.746542 #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171, 1.179622, 1.121073, 1.062524, 1.003976, 0.945427, 0.886878, 0.828329, 0.769780, 0.711232, 0.652683, 0.594134, 0.535585, 0.477036, 0.418488, 0.359939, 0.301390, 0.242841, 1.784292, 1.725744, 1.667195, 1.608646, 1.550097, 1.491548, 1.433000, 1.374451, 1.315902, 1.257353, 1.198804, 1.140256, 1.081707, 1.023158, 0.964609, 0.906060, 0.847512, 0.788963, 0.730414, 0.671865, 0.613316, 0.554768, 0.496219, 0.437670, 0.379121, 0.320572, 0.262024, 0.203475, 1.744926, 1.686377, 1.627828, 1.569280, 1.510731, 1.452182, 1.393633, 1.335084, 1.276536, 1.217987, 1.159438, 1.100889, 1.042340, 0.983792, 0.925243, 0.866694, 0.808145, 0.749596, 0.691048, 0.632499, 0.573950, 0.515401, 0.456852, 0.398304, 0.339755, 0.281206, 0.222657, 1.764108, 1.705560, 1.647011, 1.588462, 1.529913, 1.471364, 1.412816, 1.354267, 1.295718, 1.237169, 1.178620, 1.120072, 1.061523, 1.002974, 0.944425, 0.885876, 0.827328, 0.768779, 0.710230, 0.651681, 0.593132, 0.534584, 0.476035, 0.417486, 0.358937, 0.300388, 0.241840, 1.783291, 1.724742, 1.666193, 1.607644, 1.549096, 1.490547, 1.431998, 1.373449, 1.314900, 1.256352, 1.197803, 1.139254, 1.080705, 1.022156, 0.963608, 0.905059, 0.846510, 0.787961, 0.729412, 0.670864, 0.612315, 0.553766, 0.495217, 0.436668, 0.378120, 0.319571, 0.261022, 0.202473, 1.743924, 1.685376, 1.626827, 1.568278, 1.509729, 1.451180, 1.392632, 1.334083, 1.275534, 1.216985, 1.158436, 1.099888, 1.041339, 0.982790, 0.924241, 0.865692, 0.807144, 0.748595, 0.690046, 0.631497, 0.572948, 0.514400, 0.455851, 0.397302, 0.338753, 0.280204, 0.221656, 1.763107, 1.704558, 1.646009, 1.587460, 1.528912, 1.470363, 1.411814, 1.353265, 1.294716, 1.236168, 1.177619, 1.119070, 1.060521, 1.001972, 0.943424, 0.884875, 0.826326, 0.767777, 0.709228, 0.650680, 0.592131, 0.533582, 0.475033, 0.416484, 0.357936, 0.299387, 0.240838, 1.782289, 1.723740, 1.665192, 1.606643, 1.548094, 1.489545, 1.430996, 1.372448, 1.313899, 1.255350, 1.196801, 1.138252, 1.079704, 1.021155, 0.962606, 0.904057, 0.845508, 0.786960, 0.728411, 0.669862, 0.611313, 0.552764, 0.494216, 0.435667, 0.377118, 0.318569, 0.260020, 0.201472, 1.742923, 1.684374, 1.625825, 1.567276, 1.508728, 1.450179, 1.391630, 1.333081, 1.274532, 1.215984, 1.157435, 1.098886, 1.040337, 0.981788, 0.923240, 0.864691, 0.806142, 0.747593, 0.689044, 0.630496, 0.571947, 0.513398, 0.454849, 0.396300, 0.337752, 0.279203, 0.220654, 1.762105, 1.703556, 1.645008, 1.586459, 1.527910, 1.469361, 1.410812, 1.352264, 1.293715, 1.235166, 1.176617, 1.118068, 1.059520, 1.000971, 0.942422, 0.883873, 0.825324, 0.766776, 0.708227, 0.649678, 0.591129, 0.532580, 0.474032, 0.415483, 0.356934, 0.298385, 0.239836, 1.781288, 1.722739, 1.664190, 1.605641, 1.547092, 1.488544, 1.429995, 1.371446, 1.312897, 1.254348, 1.195800, 1.137251, 1.078702, 1.020153, 0.961604, 0.903056, 0.844507, 0.785958, 0.727409, 0.668860, 0.610312, 0.551763, 0.493214, 0.434665, 0.376116, 0.317568, 0.259019, 0.200470, 1.741921, 1.683372, 1.624824, 1.566275, 1.507726, 1.449177, 1.390628, 1.332080, 1.273531, 1.214982, 1.156433, 1.097884, 1.039336, 0.980787, 0.922238, 0.863689, 0.805140, 0.746592, 0.688043, 0.629494, 0.570945, 0.512396, 0.453848, 0.395299, 0.336750, 0.278201, 0.219652, 1.761104, 1.702555, 1.644006, 1.585457, 1.526908, 1.468360, 1.409811, 1.351262, 1.292713, 1.234164, 1.175616, 1.117067, 1.058518, 0.999969, 0.941420, 0.882872, 0.824323, 0.765774, 0.707225, 0.648676, 0.590128, 0.531579, 0.473030, 0.414481, 0.355932, 0.297384, 0.238835, 1.780286, 1.721737, 1.663188, 1.604640, 1.546091, 1.487542, 1.428993, 1.370444, 1.311896, 1.253347, 1.194798, 1.136249, 1.077700, 1.019152, 0.960603, 0.902054, 0.843505, 0.784956, 0.726408, 0.667859, 0.609310, 0.550761, 0.492212, 0.433664, 0.375115, 0.316566, 0.258017, 1.799468, 1.740920, 1.682371, 1.623822, 1.565273, 1.506724, 1.448176, 1.389627, 1.331078, 1.272529, 1.213980, 1.155432, 1.096883, 1.038334, 0.979785, 0.921236, 0.862688, 0.804139, 0.745590, 0.687041, 0.628492, 0.569944, 0.511395, 0.452846, 0.394297, 0.335748, 0.277200, 0.218651, 1.760102, 1.701553, 1.643004, 1.584456, 1.525907, 1.467358, 1.408809, 1.350260, 1.291712, 1.233163, 1.174614, 1.116065, 1.057516, 0.998968, 0.940419, 0.881870, 0.823321, 0.764772, 0.706224, 0.647675, 0.589126, 0.530577, 0.472028, 0.413480, 0.354931, 0.296382, 0.237833, 1.779284, 1.720736, 1.662187, 1.603638, 1.545089, 1.486540, 1.427992, 1.369443, 1.310894, 1.252345, 1.193796, 1.135248, 1.076699, 1.018150, 0.959601, 0.901052, 0.842504, 0.783955, 0.725406, 0.666857, 0.608308, 0.549760, 0.491211, 0.432662, 0.374113, 0.315564, 0.257016, 1.798467, 1.739918, 1.681369, 1.622820, 1.564272, 1.505723, 1.447174, 1.388625, 1.330076, 1.271528, 1.212979, 1.154430, 1.095881, 1.037332, 0.978784, 0.920235, 0.861686, 0.803137, 0.744588, 0.686040, 0.627491, 0.568942, 0.510393, 0.451844, 0.393296, 0.334747, 0.276198, 0.217649, 1.759100, 1.700552, 1.642003, 1.583454, 1.524905, 1.466356, 1.407808, 1.349259, 1.290710, 1.232161, 1.173612, 1.115064, 1.056515, 0.997966, 0.939417, 0.880868, 0.822320, 0.763771, 0.705222, 0.646673, 0.588124, 0.529576, 0.471027, 0.412478, 0.353929, 0.295380, 0.236832, 1.778283, 1.719734, 1.661185, 1.602636, 1.544088, 1.485539, 1.426990, 1.368441, 1.309892, 1.251344, 1.192795, 1.134246, 1.075697, 1.017148, 0.958600, 0.900051, 0.841502, 0.782953, 0.724404, 0.665856, 0.607307, 0.548758, 0.490209, 0.431660, 0.373112, 0.314563, 0.256014, 1.797465, 1.738916, 1.680368, 1.621819, 1.563270, 1.504721, 1.446172, 1.387624, 1.329075, 1.270526, 1.211977, 1.153428, 1.094880, 1.036331, 0.977782, 0.919233, 0.860684, 0.802136, 0.743587, 0.685038, 0.626489, 0.567940, 0.509392, 0.450843, 0.392294, 0.333745, 0.275196, 0.216648, 1.758099, 1.699550, 1.641001, 1.582452, 1.523904, 1.465355, 1.406806, 1.348257, 1.289708, 1.231160, 1.172611, 1.114062, 1.055513, 0.996964, 0.938416, 0.879867, 0.821318, 0.762769, 0.704220, 0.645672, 0.587123, 0.528574, 0.470025, 0.411476, 0.352928, 0.294379, 0.235830, 1.777281, 1.718732, 1.660184, 1.601635, 1.543086, 1.484537, 1.425988, 1.367440, 1.308891, 1.250342, 1.191793, 1.133244, 1.074696, 1.016147, 0.957598, 0.899049, 0.840500, 0.781952, 0.723403, 0.664854, 0.606305, 0.547756, 0.489208, 0.430659, 0.372110, 0.313561, 0.255012, 1.796464, 1.737915, 1.679366, 1.620817, 1.562268, 1.503720]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 1.508595 1.450046 1.391497 1.332948 1.274400 1.215851 1.157302 1.098753 1.040204 0.981656 0.923107 0.864558 0.806009 0.747460 0.688912 0.630363 0.571814 0.513265 0.454716 0.396168 0.337619 0.279070 0.220521 1.761972 1.703424 1.644875 1.586326 1.527777 1.469228 1.410680 1.352131 1.293582 1.235033 1.176484 1.117936 1.059387 1.000838 0.942289 0.883740 0.825192 0.766643 0.708094 0.649545 0.590996 0.532448 0.473899 0.415350 #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979, 0.848430, 0.789881, 0.731332, 0.672784, 0.614235, 0.555686, 0.497137, 0.438588, 0.380040, 0.321491, 0.262942, 0.204393, 1.745844, 1.687296, 1.628747, 1.570198, 1.511649, 1.453100, 1.394552, 1.336003, 1.277454, 1.218905, 1.160356, 1.101808, 1.043259, 0.984710, 0.926161, 0.867612, 0.809064, 0.750515, 0.691966, 0.633417, 0.574868, 0.516320, 0.457771, 0.399222, 0.340673, 0.282124, 0.223576, 1.765027, 1.706478, 1.647929, 1.589380, 1.530832, 1.472283, 1.413734, 1.355185, 1.296636, 1.238088, 1.179539, 1.120990, 1.062441, 1.003892, 0.945344, 0.886795, 0.828246, 0.769697, 0.711148, 0.652600, 0.594051, 0.535502, 0.476953, 0.418404, 0.359856, 0.301307, 0.242758, 1.784209, 1.725660, 1.667112, 1.608563, 1.550014, 1.491465, 1.432916, 1.374368, 1.315819, 1.257270, 1.198721, 1.140172, 1.081624, 1.023075, 0.964526, 0.905977, 0.847428, 0.788880, 0.730331, 0.671782, 0.613233, 0.554684, 0.496136, 0.437587, 0.379038, 0.320489, 0.261940, 0.203392, 1.744843, 1.686294, 1.627745, 1.569196, 1.510648, 1.452099, 1.393550, 1.335001, 1.276452, 1.217904, 1.159355, 1.100806, 1.042257, 0.983708, 0.925160, 0.866611, 0.808062, 0.749513, 0.690964, 0.632416, 0.573867, 0.515318, 0.456769, 0.398220, 0.339672, 0.281123, 0.222574, 1.764025, 1.705476, 1.646928, 1.588379, 1.529830, 1.471281, 1.412732, 1.354184, 1.295635, 1.237086, 1.178537, 1.119988, 1.061440, 1.002891, 0.944342, 0.885793, 0.827244, 0.768696, 0.710147, 0.651598, 0.593049, 0.534500, 0.475952, 0.417403, 0.358854, 0.300305, 0.241756, 1.783208, 1.724659, 1.666110, 1.607561, 1.549012, 1.490464, 1.431915, 1.373366, 1.314817, 1.256268, 1.197720, 1.139171, 1.080622, 1.022073, 0.963524, 0.904976, 0.846427, 0.787878, 0.729329, 0.670780, 0.612232, 0.553683, 0.495134, 0.436585, 0.378036, 0.319488, 0.260939, 0.202390, 1.743841, 1.685292, 1.626744, 1.568195, 1.509646, 1.451097, 1.392548, 1.334000, 1.275451, 1.216902, 1.158353, 1.099804, 1.041256, 0.982707, 0.924158, 0.865609, 0.807060, 0.748512, 0.689963, 0.631414, 0.572865, 0.514316, 0.455768, 0.397219, 0.338670, 0.280121, 0.221572, 1.763024, 1.704475, 1.645926, 1.587377, 1.528828, 1.470280, 1.411731, 1.353182, 1.294633, 1.236084, 1.177536, 1.118987, 1.060438, 1.001889, 0.943340, 0.884792, 0.826243, 0.767694, 0.709145, 0.650596, 0.592048, 0.533499, 0.474950, 0.416401, 0.357852, 0.299304, 0.240755, 1.782206, 1.723657, 1.665108, 1.606560, 1.548011, 1.489462, 1.430913, 1.372364, 1.313816, 1.255267, 1.196718, 1.138169, 1.079620, 1.021072, 0.962523, 0.903974, 0.845425, 0.786876, 0.728328, 0.669779, 0.611230, 0.552681, 0.494132, 0.435584, 0.377035, 0.318486, 0.259937, 0.201388, 1.742840, 1.684291, 1.625742, 1.567193, 1.508644, 1.450096, 1.391547, 1.332998, 1.274449, 1.215900, 1.157352, 1.098803, 1.040254, 0.981705, 0.923156, 0.864608, 0.806059, 0.747510, 0.688961, 0.630412, 0.571864, 0.513315, 0.454766, 0.396217, 0.337668, 0.279120, 0.220571, 1.762022, 1.703473, 1.644924, 1.586376, 1.527827, 1.469278, 1.410729, 1.352180, 1.293632, 1.235083, 1.176534, 1.117985, 1.059436, 1.000888, 0.942339, 0.883790, 0.825241, 0.766692, 0.708144, 0.649595, 0.591046, 0.532497, 0.473948, 0.415400, 0.356851, 0.298302, 0.239753, 1.781204, 1.722656, 1.664107, 1.605558, 1.547009, 1.488460, 1.429912, 1.371363, 1.312814, 1.254265, 1.195716, 1.137168, 1.078619, 1.020070, 0.961521, 0.902972, 0.844424, 0.785875, 0.727326, 0.668777, 0.610228, 0.551680, 0.493131, 0.434582, 0.376033, 0.317484, 0.258936, 0.200387, 1.741838, 1.683289, 1.624740, 1.566192, 1.507643, 1.449094, 1.390545, 1.331996, 1.273448, 1.214899, 1.156350, 1.097801, 1.039252, 0.980704, 0.922155, 0.863606, 0.805057, 0.746508, 0.687960, 0.629411, 0.570862, 0.512313, 0.453764, 0.395216, 0.336667, 0.278118, 0.219569, 1.761020, 1.702472, 1.643923, 1.585374, 1.526825, 1.468276, 1.409728, 1.351179, 1.292630, 1.234081, 1.175532, 1.116984, 1.058435, 0.999886, 0.941337, 0.882788, 0.824240, 0.765691, 0.707142, 0.648593, 0.590044, 0.531496, 0.472947, 0.414398, 0.355849, 0.297300, 0.238752, 1.780203, 1.721654, 1.663105, 1.604556, 1.546008, 1.487459, 1.428910, 1.370361, 1.311812, 1.253264, 1.194715, 1.136166, 1.077617, 1.019068, 0.960520, 0.901971, 0.843422, 0.784873, 0.726324, 0.667776, 0.609227, 0.550678, 0.492129, 0.433580, 0.375032, 0.316483, 0.257934, 1.799385, 1.740836, 1.682288, 1.623739, 1.565190, 1.506641, 1.448092, 1.389544, 1.330995, 1.272446, 1.213897, 1.155348, 1.096800, 1.038251, 0.979702, 0.921153, 0.862604, 0.804056, 0.745507, 0.686958, 0.628409, 0.569860, 0.511312, 0.452763, 0.394214, 0.335665, 0.277116, 0.218568, 1.760019, 1.701470, 1.642921, 1.584372, 1.525824, 1.467275, 1.408726, 1.350177, 1.291628, 1.233080, 1.174531, 1.115982, 1.057433, 0.998884, 0.940336, 0.881787, 0.823238, 0.764689, 0.706140, 0.647592, 0.589043, 0.530494, 0.471945, 0.413396, 0.354848, 0.296299, 0.237750, 1.779201, 1.720652, 1.662104, 1.603555, 1.545006, 1.486457, 1.427908, 1.369360, 1.310811, 1.252262, 1.193713, 1.135164, 1.076616, 1.018067, 0.959518, 0.900969, 0.842420, 0.783872, 0.725323, 0.666774, 0.608225, 0.549676, 0.491128, 0.432579, 0.374030, 0.315481, 0.256932, 1.798384, 1.739835, 1.681286, 1.622737, 1.564188, 1.505640, 1.447091, 1.388542, 1.329993, 1.271444, 1.212896, 1.154347, 1.095798, 1.037249, 0.978700, 0.920152, 0.861603, 0.803054, 0.744505, 0.685956, 0.627408, 0.568859, 0.510310, 0.451761, 0.393212, 0.334664, 0.276115, 0.217566, 1.759017, 1.700468, 1.641920, 1.583371, 1.524822, 1.466273, 1.407724, 1.349176, 1.290627, 1.232078, 1.173529, 1.114980, 1.056432, 0.997883, 0.939334, 0.880785, 0.822236, 0.763688, 0.705139, 0.646590, 0.588041, 0.529492, 0.470944, 0.412395, 0.353846, 0.295297, 0.236748, 1.778200, 1.719651, 1.661102, 1.602553, 1.544004, 1.485456, 1.426907, 1.368358, 1.309809, 1.251260, 1.192712, 1.134163, 1.075614, 1.017065, 0.958516, 0.899968, 0.841419, 0.782870, 0.724321, 0.665772, 0.607224, 0.548675, 0.490126, 0.431577, 0.373028, 0.314480, 0.255931, 1.797382, 1.738833, 1.680284, 1.621736, 1.563187, 1.504638, 1.446089, 1.387540, 1.328992, 1.270443, 1.211894, 1.153345, 1.094796, 1.036248, 0.977699, 0.919150, 0.860601, 0.802052, 0.743504, 0.684955, 0.626406, 0.567857, 0.509308, 0.450760, 0.392211, 0.333662, 0.275113, 0.216564, 1.758016, 1.699467, 1.640918, 1.582369, 1.523820, 1.465272, 1.406723, 1.348174, 1.289625, 1.231076, 1.172528]))

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

def hashemiLoop (az : Float) (t : Float) (slack : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (Twall : Float) (Ta : Float) (Qmax : Float) (Dp : Float) (Lp : Float) (Dins : Float) (kIns : Float) (Vw : Float) (etaP : Float) (Pidle : Float) (Axch : Float) (UAxMax : Float) (Ccoil : Float) (degPrev : Float) (degA : Float) (degEa : Float) (tautPrev : Float) (holdsPrev : Float) (tDead : Float) (marginPrev : Float) (flowPrev : Float) (b2_0 : Float) (b2_1 : Float) (b2_2 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Array Float :=
  let v964 := (azSun - az)
  let v967 := ((2 : Float) * (3.141592653589793 : Float))
  let v972 := (v964 - (v967 * (Float.floor ((v964 + (3.141592653589793 : Float)) / v967))))
  let v973 := ((3.141592653589793 : Float) / (2 : Float))
  let v975 := ((v973 - t) - elSun)
  let v978 := ((hist[0]! - (300 : Float)) / (300 : Float))
  let v983 := (1.0 / (1.0 + Float.exp (-((elSun - (v973 - tDead)) / (0.01 : Float)))))
  let v984 := (Float.sin t)
  let v986 := (v984 * (Float.cos az))
  let v988 := (v984 * (Float.sin az))
  let v989 := (Float.cos t)
  let v990 := (Float.cos elSun)
  let v992 := (v990 * (Float.cos azSun))
  let v994 := (v990 * (Float.sin azSun))
  let v995 := (Float.sin elSun)
  let v1000 := (((v986 * v992) + (v988 * v994)) + (v989 * v995))
  let v1015 := (Float.sqrt (((((v988 * v995) - (v989 * v994)) ^ 2) + (((v989 * v992) - (v986 * v995)) ^ 2)) + (((v986 * v994) - (v988 * v992)) ^ 2)))
  let v1026 := (if (v1000 <= (0 : Float)) then (v973 + (Float.atan ((-v1000) / (max v1015 (0.000000000001 : Float))))) else (Float.atan (v1015 / v1000)))
  let v1030 := (1.0 / (1.0 + Float.exp (-((v1026 - (0.03 : Float)) / (0.01 : Float)))))
  let v1031 := (v983 * v1030)
  let v1055 := (Float.tanh (((W1[0 * 11 + 0]! * v972) + ((W1[0 * 11 + 1]! * v975) + ((W1[0 * 11 + 2]! * t) + ((W1[0 * 11 + 3]! * tautPrev) + ((W1[0 * 11 + 4]! * holdsPrev) + ((W1[0 * 11 + 5]! * v978) + ((W1[0 * 11 + 6]! * v983) + ((W1[0 * 11 + 7]! * v1031) + ((W1[0 * 11 + 8]! * marginPrev) + ((W1[0 * 11 + 9]! * flowPrev) + ((W1[0 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[0]!))
  let v1079 := (Float.tanh (((W1[1 * 11 + 0]! * v972) + ((W1[1 * 11 + 1]! * v975) + ((W1[1 * 11 + 2]! * t) + ((W1[1 * 11 + 3]! * tautPrev) + ((W1[1 * 11 + 4]! * holdsPrev) + ((W1[1 * 11 + 5]! * v978) + ((W1[1 * 11 + 6]! * v983) + ((W1[1 * 11 + 7]! * v1031) + ((W1[1 * 11 + 8]! * marginPrev) + ((W1[1 * 11 + 9]! * flowPrev) + ((W1[1 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[1]!))
  let v1103 := (Float.tanh (((W1[2 * 11 + 0]! * v972) + ((W1[2 * 11 + 1]! * v975) + ((W1[2 * 11 + 2]! * t) + ((W1[2 * 11 + 3]! * tautPrev) + ((W1[2 * 11 + 4]! * holdsPrev) + ((W1[2 * 11 + 5]! * v978) + ((W1[2 * 11 + 6]! * v983) + ((W1[2 * 11 + 7]! * v1031) + ((W1[2 * 11 + 8]! * marginPrev) + ((W1[2 * 11 + 9]! * flowPrev) + ((W1[2 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[2]!))
  let v1127 := (Float.tanh (((W1[3 * 11 + 0]! * v972) + ((W1[3 * 11 + 1]! * v975) + ((W1[3 * 11 + 2]! * t) + ((W1[3 * 11 + 3]! * tautPrev) + ((W1[3 * 11 + 4]! * holdsPrev) + ((W1[3 * 11 + 5]! * v978) + ((W1[3 * 11 + 6]! * v983) + ((W1[3 * 11 + 7]! * v1031) + ((W1[3 * 11 + 8]! * marginPrev) + ((W1[3 * 11 + 9]! * flowPrev) + ((W1[3 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[3]!))
  let v1151 := (Float.tanh (((W1[4 * 11 + 0]! * v972) + ((W1[4 * 11 + 1]! * v975) + ((W1[4 * 11 + 2]! * t) + ((W1[4 * 11 + 3]! * tautPrev) + ((W1[4 * 11 + 4]! * holdsPrev) + ((W1[4 * 11 + 5]! * v978) + ((W1[4 * 11 + 6]! * v983) + ((W1[4 * 11 + 7]! * v1031) + ((W1[4 * 11 + 8]! * marginPrev) + ((W1[4 * 11 + 9]! * flowPrev) + ((W1[4 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[4]!))
  let v1175 := (Float.tanh (((W1[5 * 11 + 0]! * v972) + ((W1[5 * 11 + 1]! * v975) + ((W1[5 * 11 + 2]! * t) + ((W1[5 * 11 + 3]! * tautPrev) + ((W1[5 * 11 + 4]! * holdsPrev) + ((W1[5 * 11 + 5]! * v978) + ((W1[5 * 11 + 6]! * v983) + ((W1[5 * 11 + 7]! * v1031) + ((W1[5 * 11 + 8]! * marginPrev) + ((W1[5 * 11 + 9]! * flowPrev) + ((W1[5 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[5]!))
  let v1199 := (Float.tanh (((W1[6 * 11 + 0]! * v972) + ((W1[6 * 11 + 1]! * v975) + ((W1[6 * 11 + 2]! * t) + ((W1[6 * 11 + 3]! * tautPrev) + ((W1[6 * 11 + 4]! * holdsPrev) + ((W1[6 * 11 + 5]! * v978) + ((W1[6 * 11 + 6]! * v983) + ((W1[6 * 11 + 7]! * v1031) + ((W1[6 * 11 + 8]! * marginPrev) + ((W1[6 * 11 + 9]! * flowPrev) + ((W1[6 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[6]!))
  let v1223 := (Float.tanh (((W1[7 * 11 + 0]! * v972) + ((W1[7 * 11 + 1]! * v975) + ((W1[7 * 11 + 2]! * t) + ((W1[7 * 11 + 3]! * tautPrev) + ((W1[7 * 11 + 4]! * holdsPrev) + ((W1[7 * 11 + 5]! * v978) + ((W1[7 * 11 + 6]! * v983) + ((W1[7 * 11 + 7]! * v1031) + ((W1[7 * 11 + 8]! * marginPrev) + ((W1[7 * 11 + 9]! * flowPrev) + ((W1[7 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[7]!))
  let v1247 := (Float.tanh (((W1[8 * 11 + 0]! * v972) + ((W1[8 * 11 + 1]! * v975) + ((W1[8 * 11 + 2]! * t) + ((W1[8 * 11 + 3]! * tautPrev) + ((W1[8 * 11 + 4]! * holdsPrev) + ((W1[8 * 11 + 5]! * v978) + ((W1[8 * 11 + 6]! * v983) + ((W1[8 * 11 + 7]! * v1031) + ((W1[8 * 11 + 8]! * marginPrev) + ((W1[8 * 11 + 9]! * flowPrev) + ((W1[8 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[8]!))
  let v1271 := (Float.tanh (((W1[9 * 11 + 0]! * v972) + ((W1[9 * 11 + 1]! * v975) + ((W1[9 * 11 + 2]! * t) + ((W1[9 * 11 + 3]! * tautPrev) + ((W1[9 * 11 + 4]! * holdsPrev) + ((W1[9 * 11 + 5]! * v978) + ((W1[9 * 11 + 6]! * v983) + ((W1[9 * 11 + 7]! * v1031) + ((W1[9 * 11 + 8]! * marginPrev) + ((W1[9 * 11 + 9]! * flowPrev) + ((W1[9 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[9]!))
  let v1295 := (Float.tanh (((W1[10 * 11 + 0]! * v972) + ((W1[10 * 11 + 1]! * v975) + ((W1[10 * 11 + 2]! * t) + ((W1[10 * 11 + 3]! * tautPrev) + ((W1[10 * 11 + 4]! * holdsPrev) + ((W1[10 * 11 + 5]! * v978) + ((W1[10 * 11 + 6]! * v983) + ((W1[10 * 11 + 7]! * v1031) + ((W1[10 * 11 + 8]! * marginPrev) + ((W1[10 * 11 + 9]! * flowPrev) + ((W1[10 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[10]!))
  let v1319 := (Float.tanh (((W1[11 * 11 + 0]! * v972) + ((W1[11 * 11 + 1]! * v975) + ((W1[11 * 11 + 2]! * t) + ((W1[11 * 11 + 3]! * tautPrev) + ((W1[11 * 11 + 4]! * holdsPrev) + ((W1[11 * 11 + 5]! * v978) + ((W1[11 * 11 + 6]! * v983) + ((W1[11 * 11 + 7]! * v1031) + ((W1[11 * 11 + 8]! * marginPrev) + ((W1[11 * 11 + 9]! * flowPrev) + ((W1[11 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[11]!))
  let v1343 := (Float.tanh (((W1[12 * 11 + 0]! * v972) + ((W1[12 * 11 + 1]! * v975) + ((W1[12 * 11 + 2]! * t) + ((W1[12 * 11 + 3]! * tautPrev) + ((W1[12 * 11 + 4]! * holdsPrev) + ((W1[12 * 11 + 5]! * v978) + ((W1[12 * 11 + 6]! * v983) + ((W1[12 * 11 + 7]! * v1031) + ((W1[12 * 11 + 8]! * marginPrev) + ((W1[12 * 11 + 9]! * flowPrev) + ((W1[12 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[12]!))
  let v1367 := (Float.tanh (((W1[13 * 11 + 0]! * v972) + ((W1[13 * 11 + 1]! * v975) + ((W1[13 * 11 + 2]! * t) + ((W1[13 * 11 + 3]! * tautPrev) + ((W1[13 * 11 + 4]! * holdsPrev) + ((W1[13 * 11 + 5]! * v978) + ((W1[13 * 11 + 6]! * v983) + ((W1[13 * 11 + 7]! * v1031) + ((W1[13 * 11 + 8]! * marginPrev) + ((W1[13 * 11 + 9]! * flowPrev) + ((W1[13 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[13]!))
  let v1391 := (Float.tanh (((W1[14 * 11 + 0]! * v972) + ((W1[14 * 11 + 1]! * v975) + ((W1[14 * 11 + 2]! * t) + ((W1[14 * 11 + 3]! * tautPrev) + ((W1[14 * 11 + 4]! * holdsPrev) + ((W1[14 * 11 + 5]! * v978) + ((W1[14 * 11 + 6]! * v983) + ((W1[14 * 11 + 7]! * v1031) + ((W1[14 * 11 + 8]! * marginPrev) + ((W1[14 * 11 + 9]! * flowPrev) + ((W1[14 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[14]!))
  let v1415 := (Float.tanh (((W1[15 * 11 + 0]! * v972) + ((W1[15 * 11 + 1]! * v975) + ((W1[15 * 11 + 2]! * t) + ((W1[15 * 11 + 3]! * tautPrev) + ((W1[15 * 11 + 4]! * holdsPrev) + ((W1[15 * 11 + 5]! * v978) + ((W1[15 * 11 + 6]! * v983) + ((W1[15 * 11 + 7]! * v1031) + ((W1[15 * 11 + 8]! * marginPrev) + ((W1[15 * 11 + 9]! * flowPrev) + ((W1[15 * 11 + 10]! * degPrev) + (0 : Float)))))))))))) + b1[15]!))
  let v1519 := (-(1.22 : Float))
  let v1522 := (-(0.8 : Float))
  let v1530 := ((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2)))))
  let v1531 := (-v1530)
  let v1533 := ((v1522 * v989) + (v1531 * v984))
  let v1534 := (-v1522)
  let v1537 := ((v1534 * v984) + (v1531 * v989))
  let v1546 := (Float.sqrt (((v1533 - v1519) ^ 2) + ((v1537 - (0.34 : Float)) ^ 2)))
  let v1547 := (((v1519 * v1537) - ((0.34 : Float) * v1533)) / v1546)
  let v1563 := (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2)))
  let v1576 := ((1.22 : Float) * (0.8 : Float))
  let v1577 := ((0.34 : Float) * v1530)
  let v1585 := (if (v1576 <= v1577) then v973 else (Float.atan ((((1.22 : Float) * v1530) + ((0.34 : Float) * (0.8 : Float))) / (v1576 - v1577))))
  let v1586 := (Float.cos (0 : Float))
  let v1588 := (Float.sin (0 : Float))
  let v1599 := (Float.sqrt (((((v1522 * v1586) + (v1531 * v1588)) - v1519) ^ 2) + ((((v1534 * v1588) + (v1531 * v1586)) - (0.34 : Float)) ^ 2)))
  let v1600 := (Float.cos v1585)
  let v1602 := (Float.sin v1585)
  let v1613 := (Float.sqrt (((((v1522 * v1600) + (v1531 * v1602)) - v1519) ^ 2) + ((((v1534 * v1602) + (v1531 * v1600)) - (0.34 : Float)) ^ 2)))
  let v1615 := (((((Float.tanh (((W2[1 * 16 + 0]! * v1055) + ((W2[1 * 16 + 1]! * v1079) + ((W2[1 * 16 + 2]! * v1103) + ((W2[1 * 16 + 3]! * v1127) + ((W2[1 * 16 + 4]! * v1151) + ((W2[1 * 16 + 5]! * v1175) + ((W2[1 * 16 + 6]! * v1199) + ((W2[1 * 16 + 7]! * v1223) + ((W2[1 * 16 + 8]! * v1247) + ((W2[1 * 16 + 9]! * v1271) + ((W2[1 * 16 + 10]! * v1295) + ((W2[1 * 16 + 11]! * v1319) + ((W2[1 * 16 + 12]! * v1343) + ((W2[1 * 16 + 13]! * v1367) + ((W2[1 * 16 + 14]! * v1391) + ((W2[1 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_1)) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1547) / rDrum) * rDrum)
  let v1617 := ((v1546 + slack) - (v1615 * dt))
  let v1618 := (v1617 < v1613)
  let v1619 := (v1599 < v1617)
  let v1621 := (if v1618 then v1613 else (if v1619 then v1599 else v1617))
  let v1626 := (((0 : Float) + v1585) / (2 : Float))
  let v1627 := (Float.cos v1626)
  let v1629 := (Float.sin v1626)
  let v1641 := (v1621 < (Float.sqrt (((((v1522 * v1627) + (v1531 * v1629)) - v1519) ^ 2) + ((((v1534 * v1629) + (v1531 * v1627)) - (0.34 : Float)) ^ 2))))
  let v1642 := (if v1641 then v1626 else (0 : Float))
  let v1643 := (if v1641 then v1585 else v1626)
  let v1645 := ((v1642 + v1643) / (2 : Float))
  let v1646 := (Float.cos v1645)
  let v1648 := (Float.sin v1645)
  let v1660 := (v1621 < (Float.sqrt (((((v1522 * v1646) + (v1531 * v1648)) - v1519) ^ 2) + ((((v1534 * v1648) + (v1531 * v1646)) - (0.34 : Float)) ^ 2))))
  let v1661 := (if v1660 then v1645 else v1642)
  let v1662 := (if v1660 then v1643 else v1645)
  let v1664 := ((v1661 + v1662) / (2 : Float))
  let v1665 := (Float.cos v1664)
  let v1667 := (Float.sin v1664)
  let v1679 := (v1621 < (Float.sqrt (((((v1522 * v1665) + (v1531 * v1667)) - v1519) ^ 2) + ((((v1534 * v1667) + (v1531 * v1665)) - (0.34 : Float)) ^ 2))))
  let v1680 := (if v1679 then v1664 else v1661)
  let v1681 := (if v1679 then v1662 else v1664)
  let v1683 := ((v1680 + v1681) / (2 : Float))
  let v1684 := (Float.cos v1683)
  let v1686 := (Float.sin v1683)
  let v1698 := (v1621 < (Float.sqrt (((((v1522 * v1684) + (v1531 * v1686)) - v1519) ^ 2) + ((((v1534 * v1686) + (v1531 * v1684)) - (0.34 : Float)) ^ 2))))
  let v1699 := (if v1698 then v1683 else v1680)
  let v1700 := (if v1698 then v1681 else v1683)
  let v1702 := ((v1699 + v1700) / (2 : Float))
  let v1703 := (Float.cos v1702)
  let v1705 := (Float.sin v1702)
  let v1717 := (v1621 < (Float.sqrt (((((v1522 * v1703) + (v1531 * v1705)) - v1519) ^ 2) + ((((v1534 * v1705) + (v1531 * v1703)) - (0.34 : Float)) ^ 2))))
  let v1718 := (if v1717 then v1702 else v1699)
  let v1719 := (if v1717 then v1700 else v1702)
  let v1721 := ((v1718 + v1719) / (2 : Float))
  let v1722 := (Float.cos v1721)
  let v1724 := (Float.sin v1721)
  let v1736 := (v1621 < (Float.sqrt (((((v1522 * v1722) + (v1531 * v1724)) - v1519) ^ 2) + ((((v1534 * v1724) + (v1531 * v1722)) - (0.34 : Float)) ^ 2))))
  let v1737 := (if v1736 then v1721 else v1718)
  let v1738 := (if v1736 then v1719 else v1721)
  let v1740 := ((v1737 + v1738) / (2 : Float))
  let v1741 := (Float.cos v1740)
  let v1743 := (Float.sin v1740)
  let v1755 := (v1621 < (Float.sqrt (((((v1522 * v1741) + (v1531 * v1743)) - v1519) ^ 2) + ((((v1534 * v1743) + (v1531 * v1741)) - (0.34 : Float)) ^ 2))))
  let v1756 := (if v1755 then v1740 else v1737)
  let v1757 := (if v1755 then v1738 else v1740)
  let v1759 := ((v1756 + v1757) / (2 : Float))
  let v1760 := (Float.cos v1759)
  let v1762 := (Float.sin v1759)
  let v1774 := (v1621 < (Float.sqrt (((((v1522 * v1760) + (v1531 * v1762)) - v1519) ^ 2) + ((((v1534 * v1762) + (v1531 * v1760)) - (0.34 : Float)) ^ 2))))
  let v1775 := (if v1774 then v1759 else v1756)
  let v1776 := (if v1774 then v1757 else v1759)
  let v1778 := ((v1775 + v1776) / (2 : Float))
  let v1779 := (Float.cos v1778)
  let v1781 := (Float.sin v1778)
  let v1793 := (v1621 < (Float.sqrt (((((v1522 * v1779) + (v1531 * v1781)) - v1519) ^ 2) + ((((v1534 * v1781) + (v1531 * v1779)) - (0.34 : Float)) ^ 2))))
  let v1794 := (if v1793 then v1778 else v1775)
  let v1795 := (if v1793 then v1776 else v1778)
  let v1797 := ((v1794 + v1795) / (2 : Float))
  let v1798 := (Float.cos v1797)
  let v1800 := (Float.sin v1797)
  let v1812 := (v1621 < (Float.sqrt (((((v1522 * v1798) + (v1531 * v1800)) - v1519) ^ 2) + ((((v1534 * v1800) + (v1531 * v1798)) - (0.34 : Float)) ^ 2))))
  let v1813 := (if v1812 then v1797 else v1794)
  let v1814 := (if v1812 then v1795 else v1797)
  let v1816 := ((v1813 + v1814) / (2 : Float))
  let v1817 := (Float.cos v1816)
  let v1819 := (Float.sin v1816)
  let v1831 := (v1621 < (Float.sqrt (((((v1522 * v1817) + (v1531 * v1819)) - v1519) ^ 2) + ((((v1534 * v1819) + (v1531 * v1817)) - (0.34 : Float)) ^ 2))))
  let v1832 := (if v1831 then v1816 else v1813)
  let v1833 := (if v1831 then v1814 else v1816)
  let v1835 := ((v1832 + v1833) / (2 : Float))
  let v1836 := (Float.cos v1835)
  let v1838 := (Float.sin v1835)
  let v1850 := (v1621 < (Float.sqrt (((((v1522 * v1836) + (v1531 * v1838)) - v1519) ^ 2) + ((((v1534 * v1838) + (v1531 * v1836)) - (0.34 : Float)) ^ 2))))
  let v1851 := (if v1850 then v1835 else v1832)
  let v1852 := (if v1850 then v1833 else v1835)
  let v1854 := ((v1851 + v1852) / (2 : Float))
  let v1855 := (Float.cos v1854)
  let v1857 := (Float.sin v1854)
  let v1869 := (v1621 < (Float.sqrt (((((v1522 * v1855) + (v1531 * v1857)) - v1519) ^ 2) + ((((v1534 * v1857) + (v1531 * v1855)) - (0.34 : Float)) ^ 2))))
  let v1870 := (if v1869 then v1854 else v1851)
  let v1871 := (if v1869 then v1852 else v1854)
  let v1873 := ((v1870 + v1871) / (2 : Float))
  let v1874 := (Float.cos v1873)
  let v1876 := (Float.sin v1873)
  let v1888 := (v1621 < (Float.sqrt (((((v1522 * v1874) + (v1531 * v1876)) - v1519) ^ 2) + ((((v1534 * v1876) + (v1531 * v1874)) - (0.34 : Float)) ^ 2))))
  let v1889 := (if v1888 then v1873 else v1870)
  let v1890 := (if v1888 then v1871 else v1873)
  let v1892 := ((v1889 + v1890) / (2 : Float))
  let v1893 := (Float.cos v1892)
  let v1895 := (Float.sin v1892)
  let v1907 := (v1621 < (Float.sqrt (((((v1522 * v1893) + (v1531 * v1895)) - v1519) ^ 2) + ((((v1534 * v1895) + (v1531 * v1893)) - (0.34 : Float)) ^ 2))))
  let v1908 := (if v1907 then v1892 else v1889)
  let v1909 := (if v1907 then v1890 else v1892)
  let v1911 := ((v1908 + v1909) / (2 : Float))
  let v1912 := (Float.cos v1911)
  let v1914 := (Float.sin v1911)
  let v1926 := (v1621 < (Float.sqrt (((((v1522 * v1912) + (v1531 * v1914)) - v1519) ^ 2) + ((((v1534 * v1914) + (v1531 * v1912)) - (0.34 : Float)) ^ 2))))
  let v1927 := (if v1926 then v1911 else v1908)
  let v1928 := (if v1926 then v1909 else v1911)
  let v1930 := ((v1927 + v1928) / (2 : Float))
  let v1931 := (Float.cos v1930)
  let v1933 := (Float.sin v1930)
  let v1945 := (v1621 < (Float.sqrt (((((v1522 * v1931) + (v1531 * v1933)) - v1519) ^ 2) + ((((v1534 * v1933) + (v1531 * v1931)) - (0.34 : Float)) ^ 2))))
  let v1946 := (if v1945 then v1930 else v1927)
  let v1947 := (if v1945 then v1928 else v1930)
  let v1949 := ((v1946 + v1947) / (2 : Float))
  let v1950 := (Float.cos v1949)
  let v1952 := (Float.sin v1949)
  let v1964 := (v1621 < (Float.sqrt (((((v1522 * v1950) + (v1531 * v1952)) - v1519) ^ 2) + ((((v1534 * v1952) + (v1531 * v1950)) - (0.34 : Float)) ^ 2))))
  let v1965 := (if v1964 then v1949 else v1946)
  let v1966 := (if v1964 then v1947 else v1949)
  let v1968 := ((v1965 + v1966) / (2 : Float))
  let v1969 := (Float.cos v1968)
  let v1971 := (Float.sin v1968)
  let v1983 := (v1621 < (Float.sqrt (((((v1522 * v1969) + (v1531 * v1971)) - v1519) ^ 2) + ((((v1534 * v1971) + (v1531 * v1969)) - (0.34 : Float)) ^ 2))))
  let v1984 := (if v1983 then v1968 else v1965)
  let v1985 := (if v1983 then v1966 else v1968)
  let v1987 := ((v1984 + v1985) / (2 : Float))
  let v1988 := (Float.cos v1987)
  let v1990 := (Float.sin v1987)
  let v2002 := (v1621 < (Float.sqrt (((((v1522 * v1988) + (v1531 * v1990)) - v1519) ^ 2) + ((((v1534 * v1990) + (v1531 * v1988)) - (0.34 : Float)) ^ 2))))
  let v2003 := (if v2002 then v1987 else v1984)
  let v2004 := (if v2002 then v1985 else v1987)
  let v2006 := ((v2003 + v2004) / (2 : Float))
  let v2007 := (Float.cos v2006)
  let v2009 := (Float.sin v2006)
  let v2021 := (v1621 < (Float.sqrt (((((v1522 * v2007) + (v1531 * v2009)) - v1519) ^ 2) + ((((v1534 * v2009) + (v1531 * v2007)) - (0.34 : Float)) ^ 2))))
  let v2022 := (if v2021 then v2006 else v2003)
  let v2023 := (if v2021 then v2004 else v2006)
  let v2025 := ((v2022 + v2023) / (2 : Float))
  let v2026 := (Float.cos v2025)
  let v2028 := (Float.sin v2025)
  let v2040 := (v1621 < (Float.sqrt (((((v1522 * v2026) + (v1531 * v2028)) - v1519) ^ 2) + ((((v1534 * v2028) + (v1531 * v2026)) - (0.34 : Float)) ^ 2))))
  let v2041 := (if v2040 then v2025 else v2022)
  let v2042 := (if v2040 then v2023 else v2025)
  let v2044 := ((v2041 + v2042) / (2 : Float))
  let v2045 := (Float.cos v2044)
  let v2047 := (Float.sin v2044)
  let v2059 := (v1621 < (Float.sqrt (((((v1522 * v2045) + (v1531 * v2047)) - v1519) ^ 2) + ((((v1534 * v2047) + (v1531 * v2045)) - (0.34 : Float)) ^ 2))))
  let v2060 := (if v2059 then v2044 else v2041)
  let v2061 := (if v2059 then v2042 else v2044)
  let v2063 := ((v2060 + v2061) / (2 : Float))
  let v2064 := (Float.cos v2063)
  let v2066 := (Float.sin v2063)
  let v2078 := (v1621 < (Float.sqrt (((((v1522 * v2064) + (v1531 * v2066)) - v1519) ^ 2) + ((((v1534 * v2066) + (v1531 * v2064)) - (0.34 : Float)) ^ 2))))
  let v2083 := (if (v1599 <= v1617) then (0 : Float) else (((if v2078 then v2063 else v2060) + (if v2078 then v2061 else v2063)) / (2 : Float)))
  let v2084 := (W * rcm)
  let v2085 := (Float.cos v2083)
  let v2087 := (Float.sin v2083)
  let v2089 := ((v1522 * v2085) + (v1531 * v2087))
  let v2092 := ((v1534 * v2087) + (v1531 * v2085))
  let v2107 := ((t < v2083) && (!(v2084 <= (Tmax * (((v1519 * v2092) - ((0.34 : Float) * v2089)) / (Float.sqrt (((v2089 - v1519) ^ 2) + ((v2092 - (0.34 : Float)) ^ 2))))))))
  let v2108 := (if v2107 then t else v2083)
  let v2113 := (az + (((((((Float.tanh (((W2[0 * 16 + 0]! * v1055) + ((W2[0 * 16 + 1]! * v1079) + ((W2[0 * 16 + 2]! * v1103) + ((W2[0 * 16 + 3]! * v1127) + ((W2[0 * 16 + 4]! * v1151) + ((W2[0 * 16 + 5]! * v1175) + ((W2[0 * 16 + 6]! * v1199) + ((W2[0 * 16 + 7]! * v1223) + ((W2[0 * 16 + 8]! * v1247) + ((W2[0 * 16 + 9]! * v1271) + ((W2[0 * 16 + 10]! * v1295) + ((W2[0 * 16 + 11]! * v1319) + ((W2[0 * 16 + 12]! * v1343) + ((W2[0 * 16 + 13]! * v1367) + ((W2[0 * 16 + 14]! * v1391) + ((W2[0 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_0)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1563) / (0.05 : Float)) * (0.05 : Float)) / v1563) * dt))
  let v2118 := (Float.cos v2108)
  let v2120 := (Float.sin v2108)
  let v2122 := ((v1522 * v2118) + (v1531 * v2120))
  let v2125 := ((v1534 * v2120) + (v1531 * v2118))
  let v2140 := (v973 - v1585)
  let v2141 := (v2140 <= elSun)
  let v2150 := (Float.cos v2113)
  let v2151 := (v2120 * v2150)
  let v2152 := (Float.sin v2113)
  let v2153 := (v2120 * v2152)
  let v2154 := (v2118 * v2150)
  let v2155 := (v2118 * v2152)
  let v2156 := (-v2120)
  let v2181 := ((2 : Float) * a)
  let v2182 := (v2181 / w)
  let v2184 := (w / (2 : Float))
  let v2185 := ((-a) + v2184)
  let v2204 := ((1 : Float) / (2 : Float))
  let v2209 := (-(((((v2155 * v2118) - (v2156 * v2153)) * v992) + (((v2156 * v2151) - (v2154 * v2118)) * v994)) + (((v2154 * v2153) - (v2155 * v2151)) * v995)))
  let v2210 := (-(((v2154 * v992) + (v2155 * v994)) + (v2156 * v995)))
  let v2211 := (-(((v2151 * v992) + (v2153 * v994)) + (v2118 * v995)))
  let v2216 := ((Float.abs v2211) < ((9 : Float) / (10 : Float)))
  let v2217 := (if v2216 then (0 : Float) else (1 : Float))
  let v2218 := (if v2216 then (1 : Float) else (0 : Float))
  let v2221 := ((v2210 * v2218) - (v2211 * (0 : Float)))
  let v2224 := ((v2211 * v2217) - (v2209 * v2218))
  let v2227 := ((v2209 * (0 : Float)) - (v2210 * v2217))
  let v2235 := (Float.sqrt (max (((v2221 ^ 2) + (v2224 ^ 2)) + (v2227 ^ 2)) (0.000000000000000001 : Float)))
  let v2236 := (v2221 / v2235)
  let v2237 := (v2224 / v2235)
  let v2238 := (v2227 / v2235)
  let v2286 := ((2 : Float) * f)
  let v2287 := ((1 : Float) / R)
  let v2396 := (v2181 ^ 2)
  let v2397 := (v2396 * rho)
  let v2403 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); (if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && (((Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))) <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2406 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + ((dr[i * 10 + 2]! - v2204) * w)); let v2285 := (v2203 + ((dr[i * 10 + 3]! - v2204) * w)); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2378 := ((f - (v2286 + (v2345 * v2272))) / (v2363 / v2373)); (1.0 / (1.0 + Float.exp (-((rc - (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2)))) / (0.005 : Float))))))) 0.0)
  let v2424 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((0 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((0 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2429 := (((((v2424 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2440 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((1 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((1 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2445 := (((((v2440 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2456 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((2 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((2 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2461 := (((((v2456 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2473 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((3 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((3 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2478 := (((((v2473 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2490 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((4 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((4 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2495 := (((((v2490 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2507 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((5 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((5 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2512 := (((((v2507 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2524 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((6 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((6 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2529 := (((((v2524 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2541 := ((List.range 64).foldl (fun acc i => acc + (let v2199 := (v2185 + (w * (Float.floor (dr[i * 10 + 0]! * v2182)))); let v2203 := (v2185 + (w * (Float.floor (dr[i * 10 + 1]! * v2182)))); let v2206 := ((dr[i * 10 + 2]! - v2204) * w); let v2208 := ((dr[i * 10 + 3]! - v2204) * w); let v2249 := (hsun * (Float.sqrt dr[i * 10 + 4]!)); let v2250 := (v967 * dr[i * 10 + 5]!); let v2251 := (Float.cos v2249); let v2253 := (Float.sin v2249); let v2254 := (Float.cos v2250); let v2256 := (Float.sin v2250); let v2260 := ((v2251 * v2209) + (v2253 * ((v2254 * v2236) + (v2256 * ((v2210 * v2238) - (v2211 * v2237)))))); let v2266 := ((v2251 * v2210) + (v2253 * ((v2254 * v2237) + (v2256 * ((v2211 * v2236) - (v2209 * v2238)))))); let v2272 := ((v2251 * v2211) + (v2253 * ((v2254 * v2238) + (v2256 * ((v2209 * v2237) - (v2210 * v2236)))))); let v2284 := (v2199 + v2206); let v2285 := (v2203 + v2208); let v2292 := (Float.sqrt (max ((v2199 ^ 2) + (v2203 ^ 2)) (0.000000000000000001 : Float))); let v2293 := (v2292 ^ 2); let v2299 := ((1 : Float) - ((((1 : Float) + k) * (v2287 ^ 2)) * v2293)); let v2307 := ((v2287 * v2292) / (Float.sqrt (max v2299 (0.000000000000000001 : Float)))); let v2310 := (Float.sqrt ((1 : Float) + (v2307 ^ 2))); let v2311 := (-v2307); let v2314 := (((v2311 * v2199) / v2292) / v2310); let v2317 := (((v2311 * v2203) / v2292) / v2310); let v2318 := ((1 : Float) / v2310); let v2320 := (v2314 + (sigmaslope * dr[i * 10 + 6]!)); let v2322 := (v2317 + (sigmaslope * dr[i * 10 + 7]!)); let v2328 := (Float.sqrt (((v2320 ^ 2) + (v2322 ^ 2)) + (v2318 ^ 2))); let v2329 := (v2320 / v2328); let v2330 := (v2322 / v2328); let v2331 := (v2318 / v2328); let v2345 := (((((v2199 - v2284) * v2314) + ((v2203 - v2285) * v2317)) + ((((v2287 * v2293) / ((1 : Float) + (Float.sqrt (max v2299 (0 : Float))))) - v2286) * v2318)) / (((v2260 * v2314) + (v2266 * v2317)) + (v2272 * v2318))); let v2357 := ((2 : Float) * (((v2260 * v2329) + (v2266 * v2330)) + (v2272 * v2331))); let v2363 := (v2272 - (v2357 * v2331)); let v2365 := ((v2260 - (v2357 * v2329)) + (sigmaspec * dr[i * 10 + 8]!)); let v2367 := ((v2266 - (v2357 * v2330)) + (sigmaspec * dr[i * 10 + 9]!)); let v2373 := (Float.sqrt (((v2365 ^ 2) + (v2367 ^ 2)) + (v2363 ^ 2))); let v2376 := (v2363 / v2373); let v2378 := ((f - (v2286 + (v2345 * v2272))) / v2376); let v2386 := (Float.sqrt ((((v2284 + (v2345 * v2260)) + (v2378 * (v2365 / v2373))) ^ 2) + (((v2285 + (v2345 * v2266)) + (v2378 * (v2367 / v2373))) ^ 2))); (if ((((((7 : Float) * rc) / (8 : Float)) <= v2386) && (v2386 < ((((7 : Float) + (1 : Float)) * rc) / (8 : Float)))) && ((if ((((Float.abs v2199) <= a) && (((Float.abs v2203) <= a) && (((Float.abs v2206) <= v2184) && ((Float.abs v2208) <= v2184)))) && ((v2386 <= rc) && ((0 : Float) < v2376))) then (1 : Float) else (0 : Float)) > (0.5 : Float))) then (1 : Float) else (0 : Float)))) 0.0)
  let v2546 := (((((v2541 / (64 : Float)) * v2396) * rho) * dni) * soil)
  let v2549 := (Qmax * (min (max (min (max (((Float.tanh (((W2[2 * 16 + 0]! * v1055) + ((W2[2 * 16 + 1]! * v1079) + ((W2[2 * 16 + 2]! * v1103) + ((W2[2 * 16 + 3]! * v1127) + ((W2[2 * 16 + 4]! * v1151) + ((W2[2 * 16 + 5]! * v1175) + ((W2[2 * 16 + 6]! * v1199) + ((W2[2 * 16 + 7]! * v1223) + ((W2[2 * 16 + 8]! * v1247) + ((W2[2 * 16 + 9]! * v1271) + ((W2[2 * 16 + 10]! * v1295) + ((W2[2 * 16 + 11]! * v1319) + ((W2[2 * 16 + 12]! * v1343) + ((W2[2 * 16 + 13]! * v1367) + ((W2[2 * 16 + 14]! * v1391) + ((W2[2 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_2)) + (1 : Float)) / (2 : Float)) (0 : Float)) (1 : Float)) (0 : Float)) (1 : Float)))
  let v2552 := (min (618.15 : Float) (max Ta hist[0]!))
  let v2554 := (v2552 - (273.15 : Float))
  let v2560 := (v2554 ^ 2)
  let v2562 := (((1020.62 : Float) - ((0.614254 : Float) * v2554)) - ((0.000321 : Float) * v2560))
  let v2572 := ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v2554)) + ((0.0000008970757 : Float) * v2560)))
  let v2573 := ((v2562 * v2549) * v2572)
  let v2575 := (max v2573 (0.000001 : Float))
  let v2576 := (Ccoil / dt)
  let v2577 := (v2573 + v2576)
  let v2587 := ((5.7 : Float) + ((3.8 : Float) * Vw))
  let v2593 := (Dp ^ 2)
  let v2596 := (v2549 / (((3.141592653589793 : Float) * v2593) / (4 : Float)))
  let v2601 := (min (max ((Lp / (max v2596 (0.000001 : Float))) / dt) (0 : Float)) (7 : Float))
  let v2602 := (v2601 < (1 : Float))
  let v2603 := (v2601 < (2 : Float))
  let v2604 := (v2601 < (3 : Float))
  let v2605 := (v2601 < (4 : Float))
  let v2606 := (v2601 < (5 : Float))
  let v2607 := (v2601 < (6 : Float))
  let v2608 := (v2601 < (7 : Float))
  let v2615 := (if v2602 then hist[0]! else (if v2603 then hist[1]! else (if v2604 then hist[2]! else (if v2605 then hist[3]! else (if v2606 then hist[4]! else (if v2607 then hist[5]! else (if v2608 then hist[6]! else hist[7]!)))))))
  let v2623 := (v2601 - (Float.floor v2601))
  let v2626 := (v2615 + (v2623 * ((if v2602 then hist[1]! else (if v2603 then hist[2]! else (if v2604 then hist[3]! else (if v2605 then hist[4]! else (if v2606 then hist[5]! else (if v2607 then hist[6]! else hist[7]!)))))) - v2615)))
  let v2633 := (if v2602 then ret[0]! else (if v2603 then ret[1]! else (if v2604 then ret[2]! else (if v2605 then ret[3]! else (if v2606 then ret[4]! else (if v2607 then ret[5]! else (if v2608 then ret[6]! else ret[7]!)))))))
  let v2642 := (v2633 + (v2623 * ((if v2602 then ret[1]! else (if v2603 then ret[2]! else (if v2604 then ret[3]! else (if v2605 then ret[4]! else (if v2606 then ret[5]! else (if v2607 then ret[6]! else ret[7]!)))))) - v2633)))
  let v2647 := (Float.exp ((-((Lp / (((Float.log (max (Dins / Dp) (1.0001 : Float))) / (v967 * kIns)) + ((1 : Float) / ((v2587 * (3.141592653589793 : Float)) * Dins)))) / (2 : Float))) / v2575))
  let v2649 := (Ta + ((v2626 - Ta) * v2647))
  let v2659 := ((Float.exp (((586.375 : Float) / (v2554 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v2660 := (((v2562 * v2596) * Dp) / v2659)
  let v2662 := (v2660 < (2300 : Float))
  let v2665 := (max v2660 (1 : Float))
  let v2678 := (((0.118294 : Float) - ((0.000033 : Float) * v2554)) - ((0.00000015 : Float) * v2560))
  let v2687 := (((if v2662 then (4.364 : Float) else (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log v2665)))) * (Float.exp ((0.4 : Float) * (Float.log (max ((v2659 * v2572) / v2678) (0.01 : Float))))))) * v2678) / Dp)
  let v2698 := ((v2573 * ((1 : Float) - (Float.exp (-((min UAxMax (v2687 * Axch)) / (max v2575 (0.000001 : Float))))))) * (max (0 : Float) (v2649 - Twall)))
  let v2707 := (((v2573 * (Ta + ((v2642 - Ta) * v2647))) + (v2576 * v2552)) / v2577)
  let v2711 := (Ac / (8 : Float))
  let v2712 := ((eps * (0.0000000567 : Float)) * v2711)
  let v2714 := (Ta ^ 4)
  let v2717 := (v2587 * v2711)
  let v2723 := (v2707 + (((alpha * v2429) - ((v2712 * ((v2707 ^ 4) - v2714)) + (v2717 * (v2707 - Ta)))) / v2577))
  let v2733 := (v2723 + (((alpha * v2445) - ((v2712 * ((v2723 ^ 4) - v2714)) + (v2717 * (v2723 - Ta)))) / v2577))
  let v2743 := (v2733 + (((alpha * v2461) - ((v2712 * ((v2733 ^ 4) - v2714)) + (v2717 * (v2733 - Ta)))) / v2577))
  let v2753 := (v2743 + (((alpha * v2478) - ((v2712 * ((v2743 ^ 4) - v2714)) + (v2717 * (v2743 - Ta)))) / v2577))
  let v2763 := (v2753 + (((alpha * v2495) - ((v2712 * ((v2753 ^ 4) - v2714)) + (v2717 * (v2753 - Ta)))) / v2577))
  let v2773 := (v2763 + (((alpha * v2512) - ((v2712 * ((v2763 ^ 4) - v2714)) + (v2717 * (v2763 - Ta)))) / v2577))
  let v2783 := (v2773 + (((alpha * v2529) - ((v2712 * ((v2773 ^ 4) - v2714)) + (v2717 * (v2773 - Ta)))) / v2577))
  let v2793 := (v2783 + (((alpha * v2546) - ((v2712 * ((v2783 ^ 4) - v2714)) + (v2717 * (v2783 - Ta)))) / v2577))
  let v2795 := (min (618.15 : Float) (max Ta v2793))
  let v2803 := (alpha * (((((((v2429 + v2445) + v2461) + v2478) + v2495) + v2512) + v2529) + v2546))
  let v2814 := (v2803 / Ac)
  let v2827 := (max v2795 (min (v2795 + (v2814 / v2687)) (Float.sqrt (Float.sqrt (((max (0 : Float) v2814) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))))
  let v2862 := (azSun - v2113)
  let v2873 := ((293.15 : Float) - (273.15 : Float))
  let v2879 := (v2795 - (273.15 : Float))
  #[v2113, v2108, (if v1619 then (v1617 - v1599) else (0 : Float)), (if v2107 then v1546 else v1621), v1585, (if (v1618 || v2107) then (1 : Float) else (0 : Float)), (if (feq (if v1619 then (v1617 - v1599) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v2084 <= (Tmax * (((v1519 * v2125) - ((0.34 : Float) * v2122)) / (Float.sqrt (((v2122 - v1519) ^ 2) + ((v2125 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), v1547, (v1615 / v1547), ((((((Float.tanh (((W2[0 * 16 + 0]! * v1055) + ((W2[0 * 16 + 1]! * v1079) + ((W2[0 * 16 + 2]! * v1103) + ((W2[0 * 16 + 3]! * v1127) + ((W2[0 * 16 + 4]! * v1151) + ((W2[0 * 16 + 5]! * v1175) + ((W2[0 * 16 + 6]! * v1199) + ((W2[0 * 16 + 7]! * v1223) + ((W2[0 * 16 + 8]! * v1247) + ((W2[0 * 16 + 9]! * v1271) + ((W2[0 * 16 + 10]! * v1295) + ((W2[0 * 16 + 11]! * v1319) + ((W2[0 * 16 + 12]! * v1343) + ((W2[0 * 16 + 13]! * v1367) + ((W2[0 * 16 + 14]! * v1391) + ((W2[0 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_0)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * v1563) / (0.05 : Float)) * (0.05 : Float)) / v1563), v1026, (v973 - t), (if v2141 then (1 : Float) else (0 : Float)), (if (v2141 && ((0.03 : Float) < v1026)) then (1 : Float) else (0 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v2140) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v2140) / (0.01 : Float))))) * v1030), (v2403 / (64 : Float)), (v2406 / (64 : Float)), (v2397 * (v2403 / (64 : Float))), (((v2397 * (v2403 / (64 : Float))) * dni) * soil), v2795, v2803, (v2803 - (v2577 * (v2795 - v2707))), (v2573 * ((v2626 - v2649) + (v2642 - (v2649 - (v2698 / v2575))))), v2698, (((v2803 - (v2803 - (v2577 * (v2795 - v2707)))) - (v2573 * ((v2626 - v2649) + (v2642 - (v2649 - (v2698 / v2575)))))) - v2698), (v2862 - (v967 * (Float.floor ((v2862 + (3.141592653589793 : Float)) / v967)))), ((v973 - v2108) - elSun), v2108, (if (feq (if v1619 then (v1617 - v1599) else (0 : Float)) (0 : Float)) then (1 : Float) else (0 : Float)), (if (v2084 <= (Tmax * (((v1519 * v2125) - ((0.34 : Float) * v2122)) / (Float.sqrt (((v2122 - v1519) ^ 2) + ((v2125 - (0.34 : Float)) ^ 2)))))) then (1 : Float) else (0 : Float)), ((v2795 - (300 : Float)) / (300 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - v2140) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - v2140) / (0.01 : Float))))) * v1030), v2429, v2445, v2461, v2478, v2495, v2512, v2529, v2546, v2723, v2733, v2743, v2753, v2763, v2773, v2783, v2793, v2795, hist[0]!, hist[1]!, hist[2]!, hist[3]!, hist[4]!, hist[5]!, hist[6]!, hist[7]!, hist[8]!, hist[9]!, hist[10]!, hist[11]!, hist[12]!, hist[13]!, hist[14]!, (v2649 - (v2698 / v2575)), ret[0]!, ret[1]!, ret[2]!, ret[3]!, ret[4]!, ret[5]!, ret[6]!, ret[7]!, ret[8]!, ret[9]!, ret[10]!, ret[11]!, ret[12]!, ret[13]!, ret[14]!, v2827, ((648.15 : Float) - v2827), v2549, (degPrev + (dt * (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max v2827 (1 : Float)))))))), ((((if v2662 then (((((32 : Float) * v2659) * Lp) * v2596) / v2593) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt v2665))) * (Lp / Dp)) * v2562) * (v2596 ^ 2)) / (2 : Float))) * v2549) / etaP) + (if ((0 : Float) < v2549) then Pidle else (0 : Float))), v2573, (min UAxMax (v2687 * Axch)), ((Lp / (max v2596 (0.000001 : Float))) / dt), (if ((618.15 : Float) <= v2793) then (1 : Float) else (0 : Float)), (((((1020.62 : Float) - ((0.614254 : Float) * v2873)) - ((0.000321 : Float) * (v2873 ^ 2))) / (((1020.62 : Float) - ((0.614254 : Float) * v2879)) - ((0.000321 : Float) * (v2879 ^ 2)))) - (1 : Float)), (((648.15 : Float) - v2827) / (300 : Float)), (min (max (min (max (((Float.tanh (((W2[2 * 16 + 0]! * v1055) + ((W2[2 * 16 + 1]! * v1079) + ((W2[2 * 16 + 2]! * v1103) + ((W2[2 * 16 + 3]! * v1127) + ((W2[2 * 16 + 4]! * v1151) + ((W2[2 * 16 + 5]! * v1175) + ((W2[2 * 16 + 6]! * v1199) + ((W2[2 * 16 + 7]! * v1223) + ((W2[2 * 16 + 8]! * v1247) + ((W2[2 * 16 + 9]! * v1271) + ((W2[2 * 16 + 10]! * v1295) + ((W2[2 * 16 + 11]! * v1319) + ((W2[2 * 16 + 12]! * v1343) + ((W2[2 * 16 + 13]! * v1367) + ((W2[2 * 16 + 14]! * v1391) + ((W2[2 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_2)) + (1 : Float)) / (2 : Float)) (0 : Float)) (1 : Float)) (0 : Float)) (1 : Float)), (min (max (degPrev + (dt * (degA * (Float.exp ((-degEa) / ((8.314 : Float) * (max v2827 (1 : Float)))))))) (0 : Float)) (1 : Float)), v972, v975, t, tautPrev, holdsPrev, v978, v983, v1031, marginPrev, flowPrev, degPrev, (Float.tanh (((W2[0 * 16 + 0]! * v1055) + ((W2[0 * 16 + 1]! * v1079) + ((W2[0 * 16 + 2]! * v1103) + ((W2[0 * 16 + 3]! * v1127) + ((W2[0 * 16 + 4]! * v1151) + ((W2[0 * 16 + 5]! * v1175) + ((W2[0 * 16 + 6]! * v1199) + ((W2[0 * 16 + 7]! * v1223) + ((W2[0 * 16 + 8]! * v1247) + ((W2[0 * 16 + 9]! * v1271) + ((W2[0 * 16 + 10]! * v1295) + ((W2[0 * 16 + 11]! * v1319) + ((W2[0 * 16 + 12]! * v1343) + ((W2[0 * 16 + 13]! * v1367) + ((W2[0 * 16 + 14]! * v1391) + ((W2[0 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_0)), (Float.tanh (((W2[1 * 16 + 0]! * v1055) + ((W2[1 * 16 + 1]! * v1079) + ((W2[1 * 16 + 2]! * v1103) + ((W2[1 * 16 + 3]! * v1127) + ((W2[1 * 16 + 4]! * v1151) + ((W2[1 * 16 + 5]! * v1175) + ((W2[1 * 16 + 6]! * v1199) + ((W2[1 * 16 + 7]! * v1223) + ((W2[1 * 16 + 8]! * v1247) + ((W2[1 * 16 + 9]! * v1271) + ((W2[1 * 16 + 10]! * v1295) + ((W2[1 * 16 + 11]! * v1319) + ((W2[1 * 16 + 12]! * v1343) + ((W2[1 * 16 + 13]! * v1367) + ((W2[1 * 16 + 14]! * v1391) + ((W2[1 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_1)), (Float.tanh (((W2[2 * 16 + 0]! * v1055) + ((W2[2 * 16 + 1]! * v1079) + ((W2[2 * 16 + 2]! * v1103) + ((W2[2 * 16 + 3]! * v1127) + ((W2[2 * 16 + 4]! * v1151) + ((W2[2 * 16 + 5]! * v1175) + ((W2[2 * 16 + 6]! * v1199) + ((W2[2 * 16 + 7]! * v1223) + ((W2[2 * 16 + 8]! * v1247) + ((W2[2 * 16 + 9]! * v1271) + ((W2[2 * 16 + 10]! * v1295) + ((W2[2 * 16 + 11]! * v1319) + ((W2[2 * 16 + 12]! * v1343) + ((W2[2 * 16 + 13]! * v1367) + ((W2[2 * 16 + 14]! * v1391) + ((W2[2 * 16 + 15]! * v1415) + (0 : Float))))))))))))))))) + b2_2))]

#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.426371 1.367822 1.309273 1.250724 1.192176 1.133627 1.075078 1.016529 0.957980 0.899432 0.840883 0.782334 0.723785 0.665236 0.606688 0.548139 0.489590 0.431041 0.372492 0.313944 0.255395 1.796846 1.738297 1.679748 1.621200 1.562651 1.504102 1.445553 1.387004 1.328456 1.269907 1.211358 1.152809 1.094260 1.035712 0.977163 0.918614 0.860065 0.801516 0.742968 0.684419 0.625870 0.567321 0.508772 0.450224 0.391675 0.333126 0.274577 0.216028 1.757480 1.698931 1.640382 #[1.702987, 1.644438, 1.585889, 1.527340, 1.468792, 1.410243, 1.351694, 1.293145, 1.234596, 1.176048, 1.117499, 1.058950, 1.000401, 0.941852, 0.883304, 0.824755, 0.766206, 0.707657, 0.649108, 0.590560, 0.532011, 0.473462, 0.414913, 0.356364, 0.297816, 0.239267, 1.780718, 1.722169, 1.663620, 1.605072, 1.546523, 1.487974, 1.429425, 1.370876, 1.312328, 1.253779, 1.195230, 1.136681, 1.078132, 1.019584, 0.961035, 0.902486, 0.843937, 0.785388, 0.726840, 0.668291, 0.609742, 0.551193, 0.492644, 0.434096, 0.375547, 0.316998, 0.258449, 1.799900, 1.741352, 1.682803, 1.624254, 1.565705, 1.507156, 1.448608, 1.390059, 1.331510, 1.272961, 1.214412, 1.155864, 1.097315, 1.038766, 0.980217, 0.921668, 0.863120, 0.804571, 0.746022, 0.687473, 0.628924, 0.570376, 0.511827, 0.453278, 0.394729, 0.336180, 0.277632, 0.219083, 1.760534, 1.701985, 1.643436, 1.584888, 1.526339, 1.467790, 1.409241, 1.350692, 1.292144, 1.233595, 1.175046, 1.116497, 1.057948, 0.999400, 0.940851, 0.882302, 0.823753, 0.765204, 0.706656, 0.648107, 0.589558, 0.531009, 0.472460, 0.413912, 0.355363, 0.296814, 0.238265, 1.779716, 1.721168, 1.662619, 1.604070, 1.545521, 1.486972, 1.428424, 1.369875, 1.311326, 1.252777, 1.194228, 1.135680, 1.077131, 1.018582, 0.960033, 0.901484, 0.842936, 0.784387, 0.725838, 0.667289, 0.608740, 0.550192, 0.491643, 0.433094, 0.374545, 0.315996, 0.257448, 1.798899, 1.740350, 1.681801, 1.623252, 1.564704, 1.506155, 1.447606, 1.389057, 1.330508, 1.271960, 1.213411, 1.154862, 1.096313, 1.037764, 0.979216, 0.920667, 0.862118, 0.803569, 0.745020, 0.686472, 0.627923, 0.569374, 0.510825, 0.452276, 0.393728, 0.335179, 0.276630, 0.218081, 1.759532, 1.700984, 1.642435, 1.583886, 1.525337, 1.466788, 1.408240, 1.349691, 1.291142, 1.232593, 1.174044, 1.115496, 1.056947] #[1.702987, 1.644438, 1.585889, 1.527340, 1.468792, 1.410243, 1.351694, 1.293145, 1.234596, 1.176048, 1.117499, 1.058950, 1.000401, 0.941852, 0.883304, 0.824755] #[1.702987, 1.644438, 1.585889, 1.527340, 1.468792, 1.410243, 1.351694, 1.293145, 1.234596, 1.176048, 1.117499, 1.058950, 1.000401, 0.941852, 0.883304, 0.824755, 0.766206, 0.707657, 0.649108, 0.590560, 0.532011, 0.473462, 0.414913, 0.356364, 0.297816, 0.239267, 1.780718, 1.722169, 1.663620, 1.605072, 1.546523, 1.487974, 1.429425, 1.370876, 1.312328, 1.253779, 1.195230, 1.136681, 1.078132, 1.019584, 0.961035, 0.902486, 0.843937, 0.785388, 0.726840, 0.668291, 0.609742, 0.551193] #[1.702987, 1.644438, 1.585889, 1.527340, 1.468792, 1.410243, 1.351694, 1.293145, 1.234596, 1.176048, 1.117499, 1.058950, 1.000401, 0.941852, 0.883304, 0.824755] #[1.702987, 1.644438, 1.585889, 1.527340, 1.468792, 1.410243, 1.351694, 1.293145, 1.234596, 1.176048, 1.117499, 1.058950, 1.000401, 0.941852, 0.883304, 0.824755] #[1.702987, 1.644438, 1.585889, 1.527340, 1.468792, 1.410243, 1.351694, 1.293145, 1.234596, 1.176048, 1.117499, 1.058950, 1.000401, 0.941852, 0.883304, 0.824755, 0.766206, 0.707657, 0.649108, 0.590560, 0.532011, 0.473462, 0.414913, 0.356364, 0.297816, 0.239267, 1.780718, 1.722169, 1.663620, 1.605072, 1.546523, 1.487974, 1.429425, 1.370876, 1.312328, 1.253779, 1.195230, 1.136681, 1.078132, 1.019584, 0.961035, 0.902486, 0.843937, 0.785388, 0.726840, 0.668291, 0.609742, 0.551193, 0.492644, 0.434096, 0.375547, 0.316998, 0.258449, 1.799900, 1.741352, 1.682803, 1.624254, 1.565705, 1.507156, 1.448608, 1.390059, 1.331510, 1.272961, 1.214412, 1.155864, 1.097315, 1.038766, 0.980217, 0.921668, 0.863120, 0.804571, 0.746022, 0.687473, 0.628924, 0.570376, 0.511827, 0.453278, 0.394729, 0.336180, 0.277632, 0.219083, 1.760534, 1.701985, 1.643436, 1.584888, 1.526339, 1.467790, 1.409241, 1.350692, 1.292144, 1.233595, 1.175046, 1.116497, 1.057948, 0.999400, 0.940851, 0.882302, 0.823753, 0.765204, 0.706656, 0.648107, 0.589558, 0.531009, 0.472460, 0.413912, 0.355363, 0.296814, 0.238265, 1.779716, 1.721168, 1.662619, 1.604070, 1.545521, 1.486972, 1.428424, 1.369875, 1.311326, 1.252777, 1.194228, 1.135680, 1.077131, 1.018582, 0.960033, 0.901484, 0.842936, 0.784387, 0.725838, 0.667289, 0.608740, 0.550192, 0.491643, 0.433094, 0.374545, 0.315996, 0.257448, 1.798899, 1.740350, 1.681801, 1.623252, 1.564704, 1.506155, 1.447606, 1.389057, 1.330508, 1.271960, 1.213411, 1.154862, 1.096313, 1.037764, 0.979216, 0.920667, 0.862118, 0.803569, 0.745020, 0.686472, 0.627923, 0.569374, 0.510825, 0.452276, 0.393728, 0.335179, 0.276630, 0.218081, 1.759532, 1.700984, 1.642435, 1.583886, 1.525337, 1.466788, 1.408240, 1.349691, 1.291142, 1.232593, 1.174044, 1.115496, 1.056947, 0.998398, 0.939849, 0.881300, 0.822752, 0.764203, 0.705654, 0.647105, 0.588556, 0.530008, 0.471459, 0.412910, 0.354361, 0.295812, 0.237264, 1.778715, 1.720166, 1.661617, 1.603068, 1.544520, 1.485971, 1.427422, 1.368873, 1.310324, 1.251776, 1.193227, 1.134678, 1.076129, 1.017580, 0.959032, 0.900483, 0.841934, 0.783385, 0.724836, 0.666288, 0.607739, 0.549190, 0.490641, 0.432092, 0.373544, 0.314995, 0.256446, 1.797897, 1.739348, 1.680800, 1.622251, 1.563702, 1.505153, 1.446604, 1.388056, 1.329507, 1.270958, 1.212409, 1.153860, 1.095312, 1.036763, 0.978214, 0.919665, 0.861116, 0.802568, 0.744019, 0.685470, 0.626921, 0.568372, 0.509824, 0.451275, 0.392726, 0.334177, 0.275628, 0.217080, 1.758531, 1.699982, 1.641433, 1.582884, 1.524336, 1.465787, 1.407238, 1.348689, 1.290140, 1.231592, 1.173043, 1.114494, 1.055945, 0.997396, 0.938848, 0.880299, 0.821750, 0.763201, 0.704652, 0.646104, 0.587555, 0.529006, 0.470457, 0.411908, 0.353360, 0.294811, 0.236262, 1.777713, 1.719164, 1.660616, 1.602067, 1.543518, 1.484969, 1.426420, 1.367872, 1.309323, 1.250774, 1.192225, 1.133676, 1.075128, 1.016579, 0.958030, 0.899481, 0.840932, 0.782384, 0.723835, 0.665286, 0.606737, 0.548188, 0.489640, 0.431091, 0.372542, 0.313993, 0.255444, 1.796896, 1.738347, 1.679798, 1.621249, 1.562700, 1.504152, 1.445603, 1.387054, 1.328505, 1.269956, 1.211408, 1.152859, 1.094310, 1.035761, 0.977212, 0.918664, 0.860115, 0.801566, 0.743017, 0.684468, 0.625920, 0.567371, 0.508822, 0.450273, 0.391724, 0.333176, 0.274627, 0.216078, 1.757529, 1.698980, 1.640432, 1.581883, 1.523334, 1.464785, 1.406236, 1.347688, 1.289139, 1.230590, 1.172041, 1.113492, 1.054944, 0.996395, 0.937846, 0.879297, 0.820748, 0.762200, 0.703651, 0.645102, 0.586553, 0.528004, 0.469456, 0.410907, 0.352358, 0.293809, 0.235260, 1.776712, 1.718163, 1.659614, 1.601065, 1.542516, 1.483968, 1.425419, 1.366870, 1.308321, 1.249772, 1.191224, 1.132675, 1.074126, 1.015577, 0.957028, 0.898480, 0.839931, 0.781382, 0.722833, 0.664284, 0.605736, 0.547187, 0.488638, 0.430089, 0.371540, 0.312992, 0.254443, 1.795894, 1.737345, 1.678796, 1.620248, 1.561699, 1.503150, 1.444601, 1.386052, 1.327504, 1.268955, 1.210406, 1.151857, 1.093308, 1.034760, 0.976211, 0.917662, 0.859113, 0.800564, 0.742016, 0.683467, 0.624918, 0.566369, 0.507820, 0.449272, 0.390723, 0.332174, 0.273625, 0.215076, 1.756528, 1.697979, 1.639430, 1.580881, 1.522332, 1.463784, 1.405235, 1.346686, 1.288137, 1.229588, 1.171040, 1.112491, 1.053942, 0.995393, 0.936844, 0.878296, 0.819747, 0.761198, 0.702649, 0.644100, 0.585552, 0.527003, 0.468454, 0.409905, 0.351356, 0.292808, 0.234259, 1.775710, 1.717161, 1.658612, 1.600064, 1.541515, 1.482966, 1.424417, 1.365868, 1.307320, 1.248771, 1.190222, 1.131673, 1.073124, 1.014576, 0.956027, 0.897478, 0.838929, 0.780380, 0.721832, 0.663283, 0.604734, 0.546185, 0.487636, 0.429088, 0.370539, 0.311990, 0.253441, 1.794892, 1.736344, 1.677795, 1.619246, 1.560697, 1.502148, 1.443600, 1.385051, 1.326502, 1.267953, 1.209404, 1.150856, 1.092307, 1.033758, 0.975209, 0.916660, 0.858112, 0.799563, 0.741014, 0.682465, 0.623916, 0.565368, 0.506819, 0.448270, 0.389721, 0.331172, 0.272624, 0.214075, 1.755526, 1.696977, 1.638428, 1.579880, 1.521331, 1.462782, 1.404233, 1.345684, 1.287136, 1.228587, 1.170038, 1.111489, 1.052940, 0.994392, 0.935843, 0.877294, 0.818745, 0.760196, 0.701648, 0.643099, 0.584550, 0.526001, 0.467452, 0.408904, 0.350355, 0.291806, 0.233257, 1.774708, 1.716160, 1.657611, 1.599062, 1.540513, 1.481964, 1.423416, 1.364867, 1.306318, 1.247769, 1.189220, 1.130672, 1.072123, 1.013574, 0.955025, 0.896476, 0.837928, 0.779379, 0.720830, 0.662281, 0.603732, 0.545184, 0.486635, 0.428086, 0.369537, 0.310988, 0.252440, 1.793891, 1.735342, 1.676793, 1.618244, 1.559696, 1.501147, 1.442598, 1.384049, 1.325500, 1.266952, 1.208403, 1.149854, 1.091305, 1.032756, 0.974208, 0.915659, 0.857110, 0.798561, 0.740012, 0.681464, 0.622915, 0.564366, 0.505817, 0.447268, 0.388720, 0.330171, 0.271622, 0.213073, 1.754524, 1.695976, 1.637427, 1.578878, 1.520329, 1.461780, 1.403232, 1.344683, 1.286134, 1.227585, 1.169036, 1.110488, 1.051939, 0.993390, 0.934841, 0.876292, 0.817744, 0.759195, 0.700646, 0.642097, 0.583548, 0.525000, 0.466451, 0.407902, 0.349353, 0.290804, 0.232256, 1.773707, 1.715158, 1.656609, 1.598060, 1.539512, 1.480963, 1.422414, 1.363865, 1.305316, 1.246768, 1.188219, 1.129670, 1.071121, 1.012572, 0.954024, 0.895475, 0.836926, 0.778377, 0.719828, 0.661280, 0.602731, 0.544182, 0.485633, 0.427084, 0.368536, 0.309987, 0.251438, 1.792889, 1.734340, 1.675792, 1.617243, 1.558694, 1.500145, 1.441596, 1.383048, 1.324499, 1.265950, 1.207401, 1.148852, 1.090304]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.095179 1.036630 0.978081 0.919532 0.860984 0.802435 0.743886 0.685337 0.626788 0.568240 0.509691 0.451142 0.392593 0.334044 0.275496 0.216947 1.758398 1.699849 1.641300 1.582752 1.524203 1.465654 1.407105 1.348556 1.290008 1.231459 1.172910 1.114361 1.055812 0.997264 0.938715 0.880166 0.821617 0.763068 0.704520 0.645971 0.587422 0.528873 0.470324 0.411776 0.353227 0.294678 0.236129 1.777580 1.719032 1.660483 1.601934 1.543385 1.484836 1.426288 1.367739 1.309190 #[1.371795, 1.313246, 1.254697, 1.196148, 1.137600, 1.079051, 1.020502, 0.961953, 0.903404, 0.844856, 0.786307, 0.727758, 0.669209, 0.610660, 0.552112, 0.493563, 0.435014, 0.376465, 0.317916, 0.259368, 0.200819, 1.742270, 1.683721, 1.625172, 1.566624, 1.508075, 1.449526, 1.390977, 1.332428, 1.273880, 1.215331, 1.156782, 1.098233, 1.039684, 0.981136, 0.922587, 0.864038, 0.805489, 0.746940, 0.688392, 0.629843, 0.571294, 0.512745, 0.454196, 0.395648, 0.337099, 0.278550, 0.220001, 1.761452, 1.702904, 1.644355, 1.585806, 1.527257, 1.468708, 1.410160, 1.351611, 1.293062, 1.234513, 1.175964, 1.117416, 1.058867, 1.000318, 0.941769, 0.883220, 0.824672, 0.766123, 0.707574, 0.649025, 0.590476, 0.531928, 0.473379, 0.414830, 0.356281, 0.297732, 0.239184, 1.780635, 1.722086, 1.663537, 1.604988, 1.546440, 1.487891, 1.429342, 1.370793, 1.312244, 1.253696, 1.195147, 1.136598, 1.078049, 1.019500, 0.960952, 0.902403, 0.843854, 0.785305, 0.726756, 0.668208, 0.609659, 0.551110, 0.492561, 0.434012, 0.375464, 0.316915, 0.258366, 1.799817, 1.741268, 1.682720, 1.624171, 1.565622, 1.507073, 1.448524, 1.389976, 1.331427, 1.272878, 1.214329, 1.155780, 1.097232, 1.038683, 0.980134, 0.921585, 0.863036, 0.804488, 0.745939, 0.687390, 0.628841, 0.570292, 0.511744, 0.453195, 0.394646, 0.336097, 0.277548, 0.219000, 1.760451, 1.701902, 1.643353, 1.584804, 1.526256, 1.467707, 1.409158, 1.350609, 1.292060, 1.233512, 1.174963, 1.116414, 1.057865, 0.999316, 0.940768, 0.882219, 0.823670, 0.765121, 0.706572, 0.648024, 0.589475, 0.530926, 0.472377, 0.413828, 0.355280, 0.296731, 0.238182, 1.779633, 1.721084, 1.662536, 1.603987, 1.545438, 1.486889, 1.428340, 1.369792, 1.311243, 1.252694, 1.194145, 1.135596, 1.077048, 1.018499, 0.959950, 0.901401, 0.842852, 0.784304, 0.725755] #[1.371795, 1.313246, 1.254697, 1.196148, 1.137600, 1.079051, 1.020502, 0.961953, 0.903404, 0.844856, 0.786307, 0.727758, 0.669209, 0.610660, 0.552112, 0.493563] #[1.371795, 1.313246, 1.254697, 1.196148, 1.137600, 1.079051, 1.020502, 0.961953, 0.903404, 0.844856, 0.786307, 0.727758, 0.669209, 0.610660, 0.552112, 0.493563, 0.435014, 0.376465, 0.317916, 0.259368, 0.200819, 1.742270, 1.683721, 1.625172, 1.566624, 1.508075, 1.449526, 1.390977, 1.332428, 1.273880, 1.215331, 1.156782, 1.098233, 1.039684, 0.981136, 0.922587, 0.864038, 0.805489, 0.746940, 0.688392, 0.629843, 0.571294, 0.512745, 0.454196, 0.395648, 0.337099, 0.278550, 0.220001] #[1.371795, 1.313246, 1.254697, 1.196148, 1.137600, 1.079051, 1.020502, 0.961953, 0.903404, 0.844856, 0.786307, 0.727758, 0.669209, 0.610660, 0.552112, 0.493563] #[1.371795, 1.313246, 1.254697, 1.196148, 1.137600, 1.079051, 1.020502, 0.961953, 0.903404, 0.844856, 0.786307, 0.727758, 0.669209, 0.610660, 0.552112, 0.493563] #[1.371795, 1.313246, 1.254697, 1.196148, 1.137600, 1.079051, 1.020502, 0.961953, 0.903404, 0.844856, 0.786307, 0.727758, 0.669209, 0.610660, 0.552112, 0.493563, 0.435014, 0.376465, 0.317916, 0.259368, 0.200819, 1.742270, 1.683721, 1.625172, 1.566624, 1.508075, 1.449526, 1.390977, 1.332428, 1.273880, 1.215331, 1.156782, 1.098233, 1.039684, 0.981136, 0.922587, 0.864038, 0.805489, 0.746940, 0.688392, 0.629843, 0.571294, 0.512745, 0.454196, 0.395648, 0.337099, 0.278550, 0.220001, 1.761452, 1.702904, 1.644355, 1.585806, 1.527257, 1.468708, 1.410160, 1.351611, 1.293062, 1.234513, 1.175964, 1.117416, 1.058867, 1.000318, 0.941769, 0.883220, 0.824672, 0.766123, 0.707574, 0.649025, 0.590476, 0.531928, 0.473379, 0.414830, 0.356281, 0.297732, 0.239184, 1.780635, 1.722086, 1.663537, 1.604988, 1.546440, 1.487891, 1.429342, 1.370793, 1.312244, 1.253696, 1.195147, 1.136598, 1.078049, 1.019500, 0.960952, 0.902403, 0.843854, 0.785305, 0.726756, 0.668208, 0.609659, 0.551110, 0.492561, 0.434012, 0.375464, 0.316915, 0.258366, 1.799817, 1.741268, 1.682720, 1.624171, 1.565622, 1.507073, 1.448524, 1.389976, 1.331427, 1.272878, 1.214329, 1.155780, 1.097232, 1.038683, 0.980134, 0.921585, 0.863036, 0.804488, 0.745939, 0.687390, 0.628841, 0.570292, 0.511744, 0.453195, 0.394646, 0.336097, 0.277548, 0.219000, 1.760451, 1.701902, 1.643353, 1.584804, 1.526256, 1.467707, 1.409158, 1.350609, 1.292060, 1.233512, 1.174963, 1.116414, 1.057865, 0.999316, 0.940768, 0.882219, 0.823670, 0.765121, 0.706572, 0.648024, 0.589475, 0.530926, 0.472377, 0.413828, 0.355280, 0.296731, 0.238182, 1.779633, 1.721084, 1.662536, 1.603987, 1.545438, 1.486889, 1.428340, 1.369792, 1.311243, 1.252694, 1.194145, 1.135596, 1.077048, 1.018499, 0.959950, 0.901401, 0.842852, 0.784304, 0.725755, 0.667206, 0.608657, 0.550108, 0.491560, 0.433011, 0.374462, 0.315913, 0.257364, 1.798816, 1.740267, 1.681718, 1.623169, 1.564620, 1.506072, 1.447523, 1.388974, 1.330425, 1.271876, 1.213328, 1.154779, 1.096230, 1.037681, 0.979132, 0.920584, 0.862035, 0.803486, 0.744937, 0.686388, 0.627840, 0.569291, 0.510742, 0.452193, 0.393644, 0.335096, 0.276547, 0.217998, 1.759449, 1.700900, 1.642352, 1.583803, 1.525254, 1.466705, 1.408156, 1.349608, 1.291059, 1.232510, 1.173961, 1.115412, 1.056864, 0.998315, 0.939766, 0.881217, 0.822668, 0.764120, 0.705571, 0.647022, 0.588473, 0.529924, 0.471376, 0.412827, 0.354278, 0.295729, 0.237180, 1.778632, 1.720083, 1.661534, 1.602985, 1.544436, 1.485888, 1.427339, 1.368790, 1.310241, 1.251692, 1.193144, 1.134595, 1.076046, 1.017497, 0.958948, 0.900400, 0.841851, 0.783302, 0.724753, 0.666204, 0.607656, 0.549107, 0.490558, 0.432009, 0.373460, 0.314912, 0.256363, 1.797814, 1.739265, 1.680716, 1.622168, 1.563619, 1.505070, 1.446521, 1.387972, 1.329424, 1.270875, 1.212326, 1.153777, 1.095228, 1.036680, 0.978131, 0.919582, 0.861033, 0.802484, 0.743936, 0.685387, 0.626838, 0.568289, 0.509740, 0.451192, 0.392643, 0.334094, 0.275545, 0.216996, 1.758448, 1.699899, 1.641350, 1.582801, 1.524252, 1.465704, 1.407155, 1.348606, 1.290057, 1.231508, 1.172960, 1.114411, 1.055862, 0.997313, 0.938764, 0.880216, 0.821667, 0.763118, 0.704569, 0.646020, 0.587472, 0.528923, 0.470374, 0.411825, 0.353276, 0.294728, 0.236179, 1.777630, 1.719081, 1.660532, 1.601984, 1.543435, 1.484886, 1.426337, 1.367788, 1.309240, 1.250691, 1.192142, 1.133593, 1.075044, 1.016496, 0.957947, 0.899398, 0.840849, 0.782300, 0.723752, 0.665203, 0.606654, 0.548105, 0.489556, 0.431008, 0.372459, 0.313910, 0.255361, 1.796812, 1.738264, 1.679715, 1.621166, 1.562617, 1.504068, 1.445520, 1.386971, 1.328422, 1.269873, 1.211324, 1.152776, 1.094227, 1.035678, 0.977129, 0.918580, 0.860032, 0.801483, 0.742934, 0.684385, 0.625836, 0.567288, 0.508739, 0.450190, 0.391641, 0.333092, 0.274544, 0.215995, 1.757446, 1.698897, 1.640348, 1.581800, 1.523251, 1.464702, 1.406153, 1.347604, 1.289056, 1.230507, 1.171958, 1.113409, 1.054860, 0.996312, 0.937763, 0.879214, 0.820665, 0.762116, 0.703568, 0.645019, 0.586470, 0.527921, 0.469372, 0.410824, 0.352275, 0.293726, 0.235177, 1.776628, 1.718080, 1.659531, 1.600982, 1.542433, 1.483884, 1.425336, 1.366787, 1.308238, 1.249689, 1.191140, 1.132592, 1.074043, 1.015494, 0.956945, 0.898396, 0.839848, 0.781299, 0.722750, 0.664201, 0.605652, 0.547104, 0.488555, 0.430006, 0.371457, 0.312908, 0.254360, 1.795811, 1.737262, 1.678713, 1.620164, 1.561616, 1.503067, 1.444518, 1.385969, 1.327420, 1.268872, 1.210323, 1.151774, 1.093225, 1.034676, 0.976128, 0.917579, 0.859030, 0.800481, 0.741932, 0.683384, 0.624835, 0.566286, 0.507737, 0.449188, 0.390640, 0.332091, 0.273542, 0.214993, 1.756444, 1.697896, 1.639347, 1.580798, 1.522249, 1.463700, 1.405152, 1.346603, 1.288054, 1.229505, 1.170956, 1.112408, 1.053859, 0.995310, 0.936761, 0.878212, 0.819664, 0.761115, 0.702566, 0.644017, 0.585468, 0.526920, 0.468371, 0.409822, 0.351273, 0.292724, 0.234176, 1.775627, 1.717078, 1.658529, 1.599980, 1.541432, 1.482883, 1.424334, 1.365785, 1.307236, 1.248688, 1.190139, 1.131590, 1.073041, 1.014492, 0.955944, 0.897395, 0.838846, 0.780297, 0.721748, 0.663200, 0.604651, 0.546102, 0.487553, 0.429004, 0.370456, 0.311907, 0.253358, 1.794809, 1.736260, 1.677712, 1.619163, 1.560614, 1.502065, 1.443516, 1.384968, 1.326419, 1.267870, 1.209321, 1.150772, 1.092224, 1.033675, 0.975126, 0.916577, 0.858028, 0.799480, 0.740931, 0.682382, 0.623833, 0.565284, 0.506736, 0.448187, 0.389638, 0.331089, 0.272540, 0.213992, 1.755443, 1.696894, 1.638345, 1.579796, 1.521248, 1.462699, 1.404150, 1.345601, 1.287052, 1.228504, 1.169955, 1.111406, 1.052857, 0.994308, 0.935760, 0.877211, 0.818662, 0.760113, 0.701564, 0.643016, 0.584467, 0.525918, 0.467369, 0.408820, 0.350272, 0.291723, 0.233174, 1.774625, 1.716076, 1.657528, 1.598979, 1.540430, 1.481881, 1.423332, 1.364784, 1.306235, 1.247686, 1.189137, 1.130588, 1.072040, 1.013491, 0.954942, 0.896393, 0.837844, 0.779296, 0.720747, 0.662198, 0.603649, 0.545100, 0.486552, 0.428003, 0.369454, 0.310905, 0.252356, 1.793808, 1.735259, 1.676710, 1.618161, 1.559612, 1.501064, 1.442515, 1.383966, 1.325417, 1.266868, 1.208320, 1.149771, 1.091222, 1.032673, 0.974124, 0.915576, 0.857027, 0.798478, 0.739929, 0.681380, 0.622832, 0.564283, 0.505734, 0.447185, 0.388636, 0.330088, 0.271539, 0.212990, 1.754441, 1.695892, 1.637344, 1.578795, 1.520246, 1.461697, 1.403148, 1.344600, 1.286051, 1.227502, 1.168953, 1.110404, 1.051856, 0.993307, 0.934758, 0.876209, 0.817660, 0.759112]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.763987 0.705438 0.646889 0.588340 0.529792 0.471243 0.412694 0.354145 0.295596 0.237048 1.778499 1.719950 1.661401 1.602852 1.544304 1.485755 1.427206 1.368657 1.310108 1.251560 1.193011 1.134462 1.075913 1.017364 0.958816 0.900267 0.841718 0.783169 0.724620 0.666072 0.607523 0.548974 0.490425 0.431876 0.373328 0.314779 0.256230 1.797681 1.739132 1.680584 1.622035 1.563486 1.504937 1.446388 1.387840 1.329291 1.270742 1.212193 1.153644 1.095096 1.036547 0.977998 #[1.040603, 0.982054, 0.923505, 0.864956, 0.806408, 0.747859, 0.689310, 0.630761, 0.572212, 0.513664, 0.455115, 0.396566, 0.338017, 0.279468, 0.220920, 1.762371, 1.703822, 1.645273, 1.586724, 1.528176, 1.469627, 1.411078, 1.352529, 1.293980, 1.235432, 1.176883, 1.118334, 1.059785, 1.001236, 0.942688, 0.884139, 0.825590, 0.767041, 0.708492, 0.649944, 0.591395, 0.532846, 0.474297, 0.415748, 0.357200, 0.298651, 0.240102, 1.781553, 1.723004, 1.664456, 1.605907, 1.547358, 1.488809, 1.430260, 1.371712, 1.313163, 1.254614, 1.196065, 1.137516, 1.078968, 1.020419, 0.961870, 0.903321, 0.844772, 0.786224, 0.727675, 0.669126, 0.610577, 0.552028, 0.493480, 0.434931, 0.376382, 0.317833, 0.259284, 0.200736, 1.742187, 1.683638, 1.625089, 1.566540, 1.507992, 1.449443, 1.390894, 1.332345, 1.273796, 1.215248, 1.156699, 1.098150, 1.039601, 0.981052, 0.922504, 0.863955, 0.805406, 0.746857, 0.688308, 0.629760, 0.571211, 0.512662, 0.454113, 0.395564, 0.337016, 0.278467, 0.219918, 1.761369, 1.702820, 1.644272, 1.585723, 1.527174, 1.468625, 1.410076, 1.351528, 1.292979, 1.234430, 1.175881, 1.117332, 1.058784, 1.000235, 0.941686, 0.883137, 0.824588, 0.766040, 0.707491, 0.648942, 0.590393, 0.531844, 0.473296, 0.414747, 0.356198, 0.297649, 0.239100, 1.780552, 1.722003, 1.663454, 1.604905, 1.546356, 1.487808, 1.429259, 1.370710, 1.312161, 1.253612, 1.195064, 1.136515, 1.077966, 1.019417, 0.960868, 0.902320, 0.843771, 0.785222, 0.726673, 0.668124, 0.609576, 0.551027, 0.492478, 0.433929, 0.375380, 0.316832, 0.258283, 1.799734, 1.741185, 1.682636, 1.624088, 1.565539, 1.506990, 1.448441, 1.389892, 1.331344, 1.272795, 1.214246, 1.155697, 1.097148, 1.038600, 0.980051, 0.921502, 0.862953, 0.804404, 0.745856, 0.687307, 0.628758, 0.570209, 0.511660, 0.453112, 0.394563] #[1.040603, 0.982054, 0.923505, 0.864956, 0.806408, 0.747859, 0.689310, 0.630761, 0.572212, 0.513664, 0.455115, 0.396566, 0.338017, 0.279468, 0.220920, 1.762371] #[1.040603, 0.982054, 0.923505, 0.864956, 0.806408, 0.747859, 0.689310, 0.630761, 0.572212, 0.513664, 0.455115, 0.396566, 0.338017, 0.279468, 0.220920, 1.762371, 1.703822, 1.645273, 1.586724, 1.528176, 1.469627, 1.411078, 1.352529, 1.293980, 1.235432, 1.176883, 1.118334, 1.059785, 1.001236, 0.942688, 0.884139, 0.825590, 0.767041, 0.708492, 0.649944, 0.591395, 0.532846, 0.474297, 0.415748, 0.357200, 0.298651, 0.240102, 1.781553, 1.723004, 1.664456, 1.605907, 1.547358, 1.488809] #[1.040603, 0.982054, 0.923505, 0.864956, 0.806408, 0.747859, 0.689310, 0.630761, 0.572212, 0.513664, 0.455115, 0.396566, 0.338017, 0.279468, 0.220920, 1.762371] #[1.040603, 0.982054, 0.923505, 0.864956, 0.806408, 0.747859, 0.689310, 0.630761, 0.572212, 0.513664, 0.455115, 0.396566, 0.338017, 0.279468, 0.220920, 1.762371] #[1.040603, 0.982054, 0.923505, 0.864956, 0.806408, 0.747859, 0.689310, 0.630761, 0.572212, 0.513664, 0.455115, 0.396566, 0.338017, 0.279468, 0.220920, 1.762371, 1.703822, 1.645273, 1.586724, 1.528176, 1.469627, 1.411078, 1.352529, 1.293980, 1.235432, 1.176883, 1.118334, 1.059785, 1.001236, 0.942688, 0.884139, 0.825590, 0.767041, 0.708492, 0.649944, 0.591395, 0.532846, 0.474297, 0.415748, 0.357200, 0.298651, 0.240102, 1.781553, 1.723004, 1.664456, 1.605907, 1.547358, 1.488809, 1.430260, 1.371712, 1.313163, 1.254614, 1.196065, 1.137516, 1.078968, 1.020419, 0.961870, 0.903321, 0.844772, 0.786224, 0.727675, 0.669126, 0.610577, 0.552028, 0.493480, 0.434931, 0.376382, 0.317833, 0.259284, 0.200736, 1.742187, 1.683638, 1.625089, 1.566540, 1.507992, 1.449443, 1.390894, 1.332345, 1.273796, 1.215248, 1.156699, 1.098150, 1.039601, 0.981052, 0.922504, 0.863955, 0.805406, 0.746857, 0.688308, 0.629760, 0.571211, 0.512662, 0.454113, 0.395564, 0.337016, 0.278467, 0.219918, 1.761369, 1.702820, 1.644272, 1.585723, 1.527174, 1.468625, 1.410076, 1.351528, 1.292979, 1.234430, 1.175881, 1.117332, 1.058784, 1.000235, 0.941686, 0.883137, 0.824588, 0.766040, 0.707491, 0.648942, 0.590393, 0.531844, 0.473296, 0.414747, 0.356198, 0.297649, 0.239100, 1.780552, 1.722003, 1.663454, 1.604905, 1.546356, 1.487808, 1.429259, 1.370710, 1.312161, 1.253612, 1.195064, 1.136515, 1.077966, 1.019417, 0.960868, 0.902320, 0.843771, 0.785222, 0.726673, 0.668124, 0.609576, 0.551027, 0.492478, 0.433929, 0.375380, 0.316832, 0.258283, 1.799734, 1.741185, 1.682636, 1.624088, 1.565539, 1.506990, 1.448441, 1.389892, 1.331344, 1.272795, 1.214246, 1.155697, 1.097148, 1.038600, 0.980051, 0.921502, 0.862953, 0.804404, 0.745856, 0.687307, 0.628758, 0.570209, 0.511660, 0.453112, 0.394563, 0.336014, 0.277465, 0.218916, 1.760368, 1.701819, 1.643270, 1.584721, 1.526172, 1.467624, 1.409075, 1.350526, 1.291977, 1.233428, 1.174880, 1.116331, 1.057782, 0.999233, 0.940684, 0.882136, 0.823587, 0.765038, 0.706489, 0.647940, 0.589392, 0.530843, 0.472294, 0.413745, 0.355196, 0.296648, 0.238099, 1.779550, 1.721001, 1.662452, 1.603904, 1.545355, 1.486806, 1.428257, 1.369708, 1.311160, 1.252611, 1.194062, 1.135513, 1.076964, 1.018416, 0.959867, 0.901318, 0.842769, 0.784220, 0.725672, 0.667123, 0.608574, 0.550025, 0.491476, 0.432928, 0.374379, 0.315830, 0.257281, 1.798732, 1.740184, 1.681635, 1.623086, 1.564537, 1.505988, 1.447440, 1.388891, 1.330342, 1.271793, 1.213244, 1.154696, 1.096147, 1.037598, 0.979049, 0.920500, 0.861952, 0.803403, 0.744854, 0.686305, 0.627756, 0.569208, 0.510659, 0.452110, 0.393561, 0.335012, 0.276464, 0.217915, 1.759366, 1.700817, 1.642268, 1.583720, 1.525171, 1.466622, 1.408073, 1.349524, 1.290976, 1.232427, 1.173878, 1.115329, 1.056780, 0.998232, 0.939683, 0.881134, 0.822585, 0.764036, 0.705488, 0.646939, 0.588390, 0.529841, 0.471292, 0.412744, 0.354195, 0.295646, 0.237097, 1.778548, 1.720000, 1.661451, 1.602902, 1.544353, 1.485804, 1.427256, 1.368707, 1.310158, 1.251609, 1.193060, 1.134512, 1.075963, 1.017414, 0.958865, 0.900316, 0.841768, 0.783219, 0.724670, 0.666121, 0.607572, 0.549024, 0.490475, 0.431926, 0.373377, 0.314828, 0.256280, 1.797731, 1.739182, 1.680633, 1.622084, 1.563536, 1.504987, 1.446438, 1.387889, 1.329340, 1.270792, 1.212243, 1.153694, 1.095145, 1.036596, 0.978048, 0.919499, 0.860950, 0.802401, 0.743852, 0.685304, 0.626755, 0.568206, 0.509657, 0.451108, 0.392560, 0.334011, 0.275462, 0.216913, 1.758364, 1.699816, 1.641267, 1.582718, 1.524169, 1.465620, 1.407072, 1.348523, 1.289974, 1.231425, 1.172876, 1.114328, 1.055779, 0.997230, 0.938681, 0.880132, 0.821584, 0.763035, 0.704486, 0.645937, 0.587388, 0.528840, 0.470291, 0.411742, 0.353193, 0.294644, 0.236096, 1.777547, 1.718998, 1.660449, 1.601900, 1.543352, 1.484803, 1.426254, 1.367705, 1.309156, 1.250608, 1.192059, 1.133510, 1.074961, 1.016412, 0.957864, 0.899315, 0.840766, 0.782217, 0.723668, 0.665120, 0.606571, 0.548022, 0.489473, 0.430924, 0.372376, 0.313827, 0.255278, 1.796729, 1.738180, 1.679632, 1.621083, 1.562534, 1.503985, 1.445436, 1.386888, 1.328339, 1.269790, 1.211241, 1.152692, 1.094144, 1.035595, 0.977046, 0.918497, 0.859948, 0.801400, 0.742851, 0.684302, 0.625753, 0.567204, 0.508656, 0.450107, 0.391558, 0.333009, 0.274460, 0.215912, 1.757363, 1.698814, 1.640265, 1.581716, 1.523168, 1.464619, 1.406070, 1.347521, 1.288972, 1.230424, 1.171875, 1.113326, 1.054777, 0.996228, 0.937680, 0.879131, 0.820582, 0.762033, 0.703484, 0.644936, 0.586387, 0.527838, 0.469289, 0.410740, 0.352192, 0.293643, 0.235094, 1.776545, 1.717996, 1.659448, 1.600899, 1.542350, 1.483801, 1.425252, 1.366704, 1.308155, 1.249606, 1.191057, 1.132508, 1.073960, 1.015411, 0.956862, 0.898313, 0.839764, 0.781216, 0.722667, 0.664118, 0.605569, 0.547020, 0.488472, 0.429923, 0.371374, 0.312825, 0.254276, 1.795728, 1.737179, 1.678630, 1.620081, 1.561532, 1.502984, 1.444435, 1.385886, 1.327337, 1.268788, 1.210240, 1.151691, 1.093142, 1.034593, 0.976044, 0.917496, 0.858947, 0.800398, 0.741849, 0.683300, 0.624752, 0.566203, 0.507654, 0.449105, 0.390556, 0.332008, 0.273459, 0.214910, 1.756361, 1.697812, 1.639264, 1.580715, 1.522166, 1.463617, 1.405068, 1.346520, 1.287971, 1.229422, 1.170873, 1.112324, 1.053776, 0.995227, 0.936678, 0.878129, 0.819580, 0.761032, 0.702483, 0.643934, 0.585385, 0.526836, 0.468288, 0.409739, 0.351190, 0.292641, 0.234092, 1.775544, 1.716995, 1.658446, 1.599897, 1.541348, 1.482800, 1.424251, 1.365702, 1.307153, 1.248604, 1.190056, 1.131507, 1.072958, 1.014409, 0.955860, 0.897312, 0.838763, 0.780214, 0.721665, 0.663116, 0.604568, 0.546019, 0.487470, 0.428921, 0.370372, 0.311824, 0.253275, 1.794726, 1.736177, 1.677628, 1.619080, 1.560531, 1.501982, 1.443433, 1.384884, 1.326336, 1.267787, 1.209238, 1.150689, 1.092140, 1.033592, 0.975043, 0.916494, 0.857945, 0.799396, 0.740848, 0.682299, 0.623750, 0.565201, 0.506652, 0.448104, 0.389555, 0.331006, 0.272457, 0.213908, 1.755360, 1.696811, 1.638262, 1.579713, 1.521164, 1.462616, 1.404067, 1.345518, 1.286969, 1.228420, 1.169872, 1.111323, 1.052774, 0.994225, 0.935676, 0.877128, 0.818579, 0.760030, 0.701481, 0.642932, 0.584384, 0.525835, 0.467286, 0.408737, 0.350188, 0.291640, 0.233091, 1.774542, 1.715993, 1.657444, 1.598896, 1.540347, 1.481798, 1.423249, 1.364700, 1.306152, 1.247603, 1.189054, 1.130505, 1.071956, 1.013408, 0.954859, 0.896310, 0.837761, 0.779212, 0.720664, 0.662115, 0.603566, 0.545017, 0.486468, 0.427920]).map Float.toBits))

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

#eval IO.println ("headToCmd " ++ toString (headToCmd 1.723307).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 1.392115).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 1.060923).toBits)

def headToDriveAz (h : Float) (rw : Float) (R : Float) : Float :=
  ((((((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.537155 1.478606 1.420057).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.205963 1.147414 1.088865).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 0.874771 0.816222 0.757673).toBits)

def headToDriveEl (h : Float) (arm : Float) (rDrum : Float) : Float :=
  ((((-(((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float))) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.351003 1.292454 1.233905).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.019811 0.961262 0.902713).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 0.688619 0.630070 0.571521).toBits)

def heatParams  : Array Float :=
  #[(0.9 : Float), (0.8 : Float), (0.03 : Float), (15 : Float), (0.92 : Float), (15 : Float), (6300 : Float), (593 : Float)]

#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))

def heatStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Array Float :=
  let v22 := (Toil - Ta)
  #[(min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * Pin), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("heatStep " ++ toString ((heatStep 0.978699 0.920150 0.861601 0.803052 0.744504 0.685955 0.627406 0.568857 0.510308 0.451760 0.393211 0.334662 0.276113).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.647507 0.588958 0.530409 0.471860 0.413312 0.354763 0.296214 0.237665 1.779116 1.720568 1.662019 1.603470 1.544921).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 0.316315 0.257766 1.799217 1.740668 1.682120 1.623571 1.565022 1.506473 1.447924 1.389376 1.330827 1.272278 1.213729).map Float.toBits))

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.792547 0.733998).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.461355 0.402806).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.730163 1.671614).toBits)

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

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.420243 0.361694).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.689051 1.630502).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.357859 1.299310).map Float.toBits))

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

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.234091 1.775542 1.716993 1.658444 1.599896 1.541347 1.482798 1.424249))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.502899 1.444350 1.385801 1.327252 1.268704 1.210155 1.151606 1.093057))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 1.171707 1.113158 1.054609 0.996060 0.937512 0.878963 0.820414 0.761865))

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

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.647939 1.589390 1.530841 1.472292 1.413744 1.355195 1.296646 1.238097 1.179548))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.316747 1.258198 1.199649 1.141100 1.082552 1.024003 0.965454 0.906905 0.848356))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.985555 0.927006 0.868457 0.809908 0.751360 0.692811 0.634262 0.575713 0.517164))

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

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.461787 1.403238 1.344689))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.130595 1.072046 1.013497))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.799403 0.740854 0.682305))

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

#eval IO.println ("hyperHit " ++ toString ((hyperHit 1.089483 1.030934 0.972385 0.913836 0.855288 0.796739 0.738190 0.679641 0.621092 0.562544 0.503995).map Float.toBits))
#eval IO.println ("hyperHit " ++ toString ((hyperHit 0.758291 0.699742 0.641193 0.582644 0.524096 0.465547 0.406998 0.348449 0.289900 0.231352 1.772803).map Float.toBits))
#eval IO.println ("hyperHit " ++ toString ((hyperHit 0.427099 0.368550 0.310001 0.251452 1.792904 1.734355 1.675806 1.617257 1.558708 1.500160 1.441611).map Float.toBits))

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 0.903331 0.844782 0.786233 0.727684 0.669136 0.610587 0.552038).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.572139 0.513590 0.455041 0.396492 0.337944 0.279395 0.220846).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.240947 1.782398 1.723849 1.665300 1.606752 1.548203 1.489654).map Float.toBits))

def check_lean_one_degree  : Bool :=
  ((0.02 : Float) < ((1.25 : Float) * (Float.sin ((3.141592653589793 : Float) / (180 : Float)))))

#eval IO.println ("check_lean_one_degree " ++ toString (check_lean_one_degree))
#eval IO.println ("check_lean_one_degree " ++ toString (check_lean_one_degree))
#eval IO.println ("check_lean_one_degree " ++ toString (check_lean_one_degree))

def lerp8 (h0 : Float) (h1 : Float) (h2 : Float) (h3 : Float) (h4 : Float) (h5 : Float) (h6 : Float) (h7 : Float) (d : Float) : Float :=
  let v12 := (min (max d (0 : Float)) (7 : Float))
  let v14 := (v12 < (1 : Float))
  let v16 := (v12 < (2 : Float))
  let v18 := (v12 < (3 : Float))
  let v20 := (v12 < (4 : Float))
  let v22 := (v12 < (5 : Float))
  let v24 := (v12 < (6 : Float))
  let v32 := (if v14 then h0 else (if v16 then h1 else (if v18 then h2 else (if v20 then h3 else (if v22 then h4 else (if v24 then h5 else (if (v12 < (7 : Float)) then h6 else h7)))))))
  (v32 + ((v12 - (Float.floor v12)) * ((if v14 then h1 else (if v16 then h2 else (if v18 then h3 else (if v20 then h4 else (if v22 then h5 else (if v24 then h6 else h7)))))) - v32)))

#eval IO.println ("lerp8 " ++ toString (lerp8 0.531027 0.472478 0.413929 0.355380 0.296832 0.238283 1.779734 1.721185 1.662636).toBits)
#eval IO.println ("lerp8 " ++ toString (lerp8 1.799835 1.741286 1.682737 1.624188 1.565640 1.507091 1.448542 1.389993 1.331444).toBits)
#eval IO.println ("lerp8 " ++ toString (lerp8 1.468643 1.410094 1.351545 1.292996 1.234448 1.175899 1.117350 1.058801 1.000252).toBits)

def check_lerp8_zero (h0 : Float) (h1 : Float) (h2 : Float) (h3 : Float) (h4 : Float) (h5 : Float) (h6 : Float) (h7 : Float) : Bool :=
  let v11 := (min (max (0 : Float) (0 : Float)) (7 : Float))
  let v13 := (v11 < (1 : Float))
  let v15 := (v11 < (2 : Float))
  let v17 := (v11 < (3 : Float))
  let v19 := (v11 < (4 : Float))
  let v21 := (v11 < (5 : Float))
  let v23 := (v11 < (6 : Float))
  let v31 := (if v13 then h0 else (if v15 then h1 else (if v17 then h2 else (if v19 then h3 else (if v21 then h4 else (if v23 then h5 else (if (v11 < (7 : Float)) then h6 else h7)))))))
  (feq (v31 + ((v11 - (Float.floor v11)) * ((if v13 then h1 else (if v15 then h2 else (if v17 then h3 else (if v19 then h4 else (if v21 then h5 else (if v23 then h6 else h7)))))) - v31))) h0)

#eval IO.println ("check_lerp8_zero " ++ toString (check_lerp8_zero 0.344875 0.286326 0.227777 1.769228 1.710680 1.652131 1.593582 1.535033))
#eval IO.println ("check_lerp8_zero " ++ toString (check_lerp8_zero 1.613683 1.555134 1.496585 1.438036 1.379488 1.320939 1.262390 1.203841))
#eval IO.println ("check_lerp8_zero " ++ toString (check_lerp8_zero 1.282491 1.223942 1.165393 1.106844 1.048296 0.989747 0.931198 0.872649))

def leverAt (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Float :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2))))

#eval IO.println ("leverAt " ++ toString (leverAt 1.758723 1.700174 1.641625 1.583076 1.524528).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 1.427531 1.368982 1.310433 1.251884 1.193336).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 1.096339 1.037790 0.979241 0.920692 0.862144).toBits)

def loopCap (mOil : Float) (mCu : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  ((mOil * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * (v4 ^ 2))))) + (mCu * (385 : Float)))

#eval IO.println ("loopCap " ++ toString (loopCap 1.572571 1.514022 1.455473).toBits)
#eval IO.println ("loopCap " ++ toString (loopCap 1.241379 1.182830 1.124281).toBits)
#eval IO.println ("loopCap " ++ toString (loopCap 0.910187 0.851638 0.793089).toBits)

def loopStep (Coil : Float) (qAbs : Float) (qLoss : Float) (qPipe : Float) (qPot : Float) (Toil : Float) (dt : Float) : Float :=
  (min (618.15 : Float) (Toil + ((dt * (((qAbs - qLoss) - qPipe) - qPot)) / Coil)))

#eval IO.println ("loopStep " ++ toString (loopStep 1.386419 1.327870 1.269321 1.210772 1.152224 1.093675 1.035126).toBits)
#eval IO.println ("loopStep " ++ toString (loopStep 1.055227 0.996678 0.938129 0.879580 0.821032 0.762483 0.703934).toBits)
#eval IO.println ("loopStep " ++ toString (loopStep 0.724035 0.665486 0.606937 0.548388 0.489840 0.431291 0.372742).toBits)

def check_loopStep_balance (Coil : Float) (qAbs : Float) (qLoss : Float) (qPipe : Float) (qPot : Float) (Toil : Float) (dt : Float) : Bool :=
  let v11 := (((qAbs - qLoss) - qPipe) - qPot)
  let v14 := (Toil + ((dt * v11) / Coil))
  (!(!(feq Coil (0 : Float))) || (!(v14 <= (618.15 : Float)) || ((feq ((Coil * ((min (618.15 : Float) v14) - Toil)) / dt) v11) || (feq dt (0 : Float)))))

#eval IO.println ("check_loopStep_balance " ++ toString (check_loopStep_balance 1.200267 1.141718 1.083169 1.024620 0.966072 0.907523 0.848974))
#eval IO.println ("check_loopStep_balance " ++ toString (check_loopStep_balance 0.869075 0.810526 0.751977 0.693428 0.634880 0.576331 0.517782))
#eval IO.println ("check_loopStep_balance " ++ toString (check_loopStep_balance 0.537883 0.479334 0.420785 0.362236 0.303688 0.245139 1.786590))

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

#eval IO.println ("lostSunS " ++ toString (lostSunS 1.014115 0.955566 0.897017 0.838468 0.779920 0.721371).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.682923 0.624374 0.565825 0.507276 0.448728 0.390179).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 0.351731 0.293182 0.234633 1.776084 1.717536 1.658987).toBits)

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

#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.827963 0.769414 0.710865 0.652316 0.593768 0.535219))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.496771 0.438222 0.379673 0.321124 0.262576 0.204027))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.765579 1.707030 1.648481 1.589932 1.531384 1.472835))

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

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.641811 0.583262 0.524713 0.466164 0.407616 0.349067))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.310619 0.252070 1.793521 1.734972 1.676424 1.617875))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.579427 1.520878 1.462329 1.403780 1.345232 1.286683))

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

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.455659 0.397110 0.338561 0.280012 0.221464 1.762915))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.724467 1.665918 1.607369 1.548820 1.490272 1.431723))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.393275 1.334726 1.276177 1.217628 1.159080 1.100531))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.683355))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.352163))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.020971))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.311051))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.979859))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.648667))

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

#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.752595 0.694046 0.635497 0.576948 0.518400 0.459851 0.401302 0.342753 0.284204 0.225656 1.767107 1.708558 1.650009 1.591460 1.532912 1.474363 1.415814).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.421403 0.362854 0.304305 0.245756 1.787208 1.728659 1.670110 1.611561 1.553012 1.494464 1.435915 1.377366 1.318817 1.260268 1.201720 1.143171 1.084622).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.690211 1.631662 1.573113 1.514564 1.456016 1.397467 1.338918 1.280369 1.221820 1.163272 1.104723 1.046174 0.987625 0.929076 0.870528 0.811979 0.753430).map Float.toBits))

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

#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.380291 0.321742 0.263193 0.204644 1.746096 1.687547 1.628998 1.570449 1.511900 1.453352 1.394803 1.336254 1.277705 1.219156 1.160608 1.102059 1.043510).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.649099 1.590550 1.532001 1.473452 1.414904 1.356355 1.297806 1.239257 1.180708 1.122160 1.063611 1.005062 0.946513 0.887964 0.829416 0.770867 0.712318).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.317907 1.259358 1.200809 1.142260 1.083712 1.025163 0.966614 0.908065 0.849516 0.790968 0.732419 0.673870 0.615321 0.556772 0.498224 0.439675 0.381126).map Float.toBits))

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

#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.794139 1.735590 1.677041 1.618492 1.559944 1.501395 1.442846 1.384297 1.325748 1.267200 1.208651 1.150102 1.091553 1.033004 0.974456 0.915907 0.857358).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.462947 1.404398 1.345849 1.287300 1.228752 1.170203 1.111654 1.053105 0.994556 0.936008 0.877459 0.818910 0.760361 0.701812 0.643264 0.584715 0.526166).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 1.131755 1.073206 1.014657 0.956108 0.897560 0.839011 0.780462 0.721913 0.663364 0.604816 0.546267 0.487718 0.429169 0.370620 0.312072 0.253523 1.794974).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.607987 1.549438 1.490889).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.276795 1.218246 1.159697).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.945603 0.887054 0.828505).toBits)

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

#eval IO.println ("megaStep " ++ toString ((megaStep 1.421835 1.363286 1.304737 1.246188 1.187640 1.129091 1.070542 1.011993 0.953444 0.894896 0.836347 0.777798 0.719249 0.660700 0.602152 0.543603 0.485054).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.090643 1.032094 0.973545 0.914996 0.856448 0.797899 0.739350 0.680801 0.622252 0.563704 0.505155 0.446606 0.388057 0.329508 0.270960 0.212411 1.753862).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.759451 0.700902 0.642353 0.583804 0.525256 0.466707 0.408158 0.349609 0.291060 0.232512 1.773963 1.715414 1.656865 1.598316 1.539768 1.481219 1.422670).map Float.toBits))

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

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.235683 1.177134 1.118585 1.060036 1.001488 0.942939 0.884390 0.825841 0.767292 0.708744 0.650195 0.591646 0.533097 0.474548 0.416000 0.357451 0.298902).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.904491 0.845942 0.787393 0.728844 0.670296 0.611747 0.553198 0.494649 0.436100 0.377552 0.319003 0.260454 0.201905 1.743356 1.684808 1.626259 1.567710).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.573299 0.514750 0.456201 0.397652 0.339104 0.280555 0.222006 1.763457 1.704908 1.646360 1.587811 1.529262 1.470713 1.412164 1.353616 1.295067 1.236518).map Float.toBits))

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

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.049531 0.990982 0.932433 0.873884 0.815336 0.756787 0.698238 0.639689 0.581140 0.522592 0.464043 0.405494 0.346945 0.288396 0.229848 1.771299 1.712750).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.718339 0.659790 0.601241 0.542692 0.484144 0.425595 0.367046 0.308497 0.249948 1.791400 1.732851 1.674302 1.615753 1.557204 1.498656 1.440107 1.381558).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 0.387147 0.328598 0.270049 0.211500 1.752952 1.694403 1.635854 1.577305 1.518756 1.460208 1.401659 1.343110 1.284561 1.226012 1.167464 1.108915 1.050366).map Float.toBits))

def mlpPolicy (b2_0 : Float) (b2_1 : Float) (b2_2 : Float) (o_0 : Float) (o_1 : Float) (o_2 : Float) (o_3 : Float) (o_4 : Float) (o_5 : Float) (o_6 : Float) (o_7 : Float) (o_8 : Float) (o_9 : Float) (o_10 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) : Array Float :=
  let v278 := (Float.tanh (((W1[0 * 11 + 0]! * o_0) + ((W1[0 * 11 + 1]! * o_1) + ((W1[0 * 11 + 2]! * o_2) + ((W1[0 * 11 + 3]! * o_3) + ((W1[0 * 11 + 4]! * o_4) + ((W1[0 * 11 + 5]! * o_5) + ((W1[0 * 11 + 6]! * o_6) + ((W1[0 * 11 + 7]! * o_7) + ((W1[0 * 11 + 8]! * o_8) + ((W1[0 * 11 + 9]! * o_9) + ((W1[0 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[0]!))
  let v302 := (Float.tanh (((W1[1 * 11 + 0]! * o_0) + ((W1[1 * 11 + 1]! * o_1) + ((W1[1 * 11 + 2]! * o_2) + ((W1[1 * 11 + 3]! * o_3) + ((W1[1 * 11 + 4]! * o_4) + ((W1[1 * 11 + 5]! * o_5) + ((W1[1 * 11 + 6]! * o_6) + ((W1[1 * 11 + 7]! * o_7) + ((W1[1 * 11 + 8]! * o_8) + ((W1[1 * 11 + 9]! * o_9) + ((W1[1 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[1]!))
  let v326 := (Float.tanh (((W1[2 * 11 + 0]! * o_0) + ((W1[2 * 11 + 1]! * o_1) + ((W1[2 * 11 + 2]! * o_2) + ((W1[2 * 11 + 3]! * o_3) + ((W1[2 * 11 + 4]! * o_4) + ((W1[2 * 11 + 5]! * o_5) + ((W1[2 * 11 + 6]! * o_6) + ((W1[2 * 11 + 7]! * o_7) + ((W1[2 * 11 + 8]! * o_8) + ((W1[2 * 11 + 9]! * o_9) + ((W1[2 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[2]!))
  let v350 := (Float.tanh (((W1[3 * 11 + 0]! * o_0) + ((W1[3 * 11 + 1]! * o_1) + ((W1[3 * 11 + 2]! * o_2) + ((W1[3 * 11 + 3]! * o_3) + ((W1[3 * 11 + 4]! * o_4) + ((W1[3 * 11 + 5]! * o_5) + ((W1[3 * 11 + 6]! * o_6) + ((W1[3 * 11 + 7]! * o_7) + ((W1[3 * 11 + 8]! * o_8) + ((W1[3 * 11 + 9]! * o_9) + ((W1[3 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[3]!))
  let v374 := (Float.tanh (((W1[4 * 11 + 0]! * o_0) + ((W1[4 * 11 + 1]! * o_1) + ((W1[4 * 11 + 2]! * o_2) + ((W1[4 * 11 + 3]! * o_3) + ((W1[4 * 11 + 4]! * o_4) + ((W1[4 * 11 + 5]! * o_5) + ((W1[4 * 11 + 6]! * o_6) + ((W1[4 * 11 + 7]! * o_7) + ((W1[4 * 11 + 8]! * o_8) + ((W1[4 * 11 + 9]! * o_9) + ((W1[4 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[4]!))
  let v398 := (Float.tanh (((W1[5 * 11 + 0]! * o_0) + ((W1[5 * 11 + 1]! * o_1) + ((W1[5 * 11 + 2]! * o_2) + ((W1[5 * 11 + 3]! * o_3) + ((W1[5 * 11 + 4]! * o_4) + ((W1[5 * 11 + 5]! * o_5) + ((W1[5 * 11 + 6]! * o_6) + ((W1[5 * 11 + 7]! * o_7) + ((W1[5 * 11 + 8]! * o_8) + ((W1[5 * 11 + 9]! * o_9) + ((W1[5 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[5]!))
  let v422 := (Float.tanh (((W1[6 * 11 + 0]! * o_0) + ((W1[6 * 11 + 1]! * o_1) + ((W1[6 * 11 + 2]! * o_2) + ((W1[6 * 11 + 3]! * o_3) + ((W1[6 * 11 + 4]! * o_4) + ((W1[6 * 11 + 5]! * o_5) + ((W1[6 * 11 + 6]! * o_6) + ((W1[6 * 11 + 7]! * o_7) + ((W1[6 * 11 + 8]! * o_8) + ((W1[6 * 11 + 9]! * o_9) + ((W1[6 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[6]!))
  let v446 := (Float.tanh (((W1[7 * 11 + 0]! * o_0) + ((W1[7 * 11 + 1]! * o_1) + ((W1[7 * 11 + 2]! * o_2) + ((W1[7 * 11 + 3]! * o_3) + ((W1[7 * 11 + 4]! * o_4) + ((W1[7 * 11 + 5]! * o_5) + ((W1[7 * 11 + 6]! * o_6) + ((W1[7 * 11 + 7]! * o_7) + ((W1[7 * 11 + 8]! * o_8) + ((W1[7 * 11 + 9]! * o_9) + ((W1[7 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[7]!))
  let v470 := (Float.tanh (((W1[8 * 11 + 0]! * o_0) + ((W1[8 * 11 + 1]! * o_1) + ((W1[8 * 11 + 2]! * o_2) + ((W1[8 * 11 + 3]! * o_3) + ((W1[8 * 11 + 4]! * o_4) + ((W1[8 * 11 + 5]! * o_5) + ((W1[8 * 11 + 6]! * o_6) + ((W1[8 * 11 + 7]! * o_7) + ((W1[8 * 11 + 8]! * o_8) + ((W1[8 * 11 + 9]! * o_9) + ((W1[8 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[8]!))
  let v494 := (Float.tanh (((W1[9 * 11 + 0]! * o_0) + ((W1[9 * 11 + 1]! * o_1) + ((W1[9 * 11 + 2]! * o_2) + ((W1[9 * 11 + 3]! * o_3) + ((W1[9 * 11 + 4]! * o_4) + ((W1[9 * 11 + 5]! * o_5) + ((W1[9 * 11 + 6]! * o_6) + ((W1[9 * 11 + 7]! * o_7) + ((W1[9 * 11 + 8]! * o_8) + ((W1[9 * 11 + 9]! * o_9) + ((W1[9 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[9]!))
  let v518 := (Float.tanh (((W1[10 * 11 + 0]! * o_0) + ((W1[10 * 11 + 1]! * o_1) + ((W1[10 * 11 + 2]! * o_2) + ((W1[10 * 11 + 3]! * o_3) + ((W1[10 * 11 + 4]! * o_4) + ((W1[10 * 11 + 5]! * o_5) + ((W1[10 * 11 + 6]! * o_6) + ((W1[10 * 11 + 7]! * o_7) + ((W1[10 * 11 + 8]! * o_8) + ((W1[10 * 11 + 9]! * o_9) + ((W1[10 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[10]!))
  let v542 := (Float.tanh (((W1[11 * 11 + 0]! * o_0) + ((W1[11 * 11 + 1]! * o_1) + ((W1[11 * 11 + 2]! * o_2) + ((W1[11 * 11 + 3]! * o_3) + ((W1[11 * 11 + 4]! * o_4) + ((W1[11 * 11 + 5]! * o_5) + ((W1[11 * 11 + 6]! * o_6) + ((W1[11 * 11 + 7]! * o_7) + ((W1[11 * 11 + 8]! * o_8) + ((W1[11 * 11 + 9]! * o_9) + ((W1[11 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[11]!))
  let v566 := (Float.tanh (((W1[12 * 11 + 0]! * o_0) + ((W1[12 * 11 + 1]! * o_1) + ((W1[12 * 11 + 2]! * o_2) + ((W1[12 * 11 + 3]! * o_3) + ((W1[12 * 11 + 4]! * o_4) + ((W1[12 * 11 + 5]! * o_5) + ((W1[12 * 11 + 6]! * o_6) + ((W1[12 * 11 + 7]! * o_7) + ((W1[12 * 11 + 8]! * o_8) + ((W1[12 * 11 + 9]! * o_9) + ((W1[12 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[12]!))
  let v590 := (Float.tanh (((W1[13 * 11 + 0]! * o_0) + ((W1[13 * 11 + 1]! * o_1) + ((W1[13 * 11 + 2]! * o_2) + ((W1[13 * 11 + 3]! * o_3) + ((W1[13 * 11 + 4]! * o_4) + ((W1[13 * 11 + 5]! * o_5) + ((W1[13 * 11 + 6]! * o_6) + ((W1[13 * 11 + 7]! * o_7) + ((W1[13 * 11 + 8]! * o_8) + ((W1[13 * 11 + 9]! * o_9) + ((W1[13 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[13]!))
  let v614 := (Float.tanh (((W1[14 * 11 + 0]! * o_0) + ((W1[14 * 11 + 1]! * o_1) + ((W1[14 * 11 + 2]! * o_2) + ((W1[14 * 11 + 3]! * o_3) + ((W1[14 * 11 + 4]! * o_4) + ((W1[14 * 11 + 5]! * o_5) + ((W1[14 * 11 + 6]! * o_6) + ((W1[14 * 11 + 7]! * o_7) + ((W1[14 * 11 + 8]! * o_8) + ((W1[14 * 11 + 9]! * o_9) + ((W1[14 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[14]!))
  let v638 := (Float.tanh (((W1[15 * 11 + 0]! * o_0) + ((W1[15 * 11 + 1]! * o_1) + ((W1[15 * 11 + 2]! * o_2) + ((W1[15 * 11 + 3]! * o_3) + ((W1[15 * 11 + 4]! * o_4) + ((W1[15 * 11 + 5]! * o_5) + ((W1[15 * 11 + 6]! * o_6) + ((W1[15 * 11 + 7]! * o_7) + ((W1[15 * 11 + 8]! * o_8) + ((W1[15 * 11 + 9]! * o_9) + ((W1[15 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[15]!))
  #[(Float.tanh (((W2[0 * 16 + 0]! * v278) + ((W2[0 * 16 + 1]! * v302) + ((W2[0 * 16 + 2]! * v326) + ((W2[0 * 16 + 3]! * v350) + ((W2[0 * 16 + 4]! * v374) + ((W2[0 * 16 + 5]! * v398) + ((W2[0 * 16 + 6]! * v422) + ((W2[0 * 16 + 7]! * v446) + ((W2[0 * 16 + 8]! * v470) + ((W2[0 * 16 + 9]! * v494) + ((W2[0 * 16 + 10]! * v518) + ((W2[0 * 16 + 11]! * v542) + ((W2[0 * 16 + 12]! * v566) + ((W2[0 * 16 + 13]! * v590) + ((W2[0 * 16 + 14]! * v614) + ((W2[0 * 16 + 15]! * v638) + (0 : Float))))))))))))))))) + b2_0)), (Float.tanh (((W2[1 * 16 + 0]! * v278) + ((W2[1 * 16 + 1]! * v302) + ((W2[1 * 16 + 2]! * v326) + ((W2[1 * 16 + 3]! * v350) + ((W2[1 * 16 + 4]! * v374) + ((W2[1 * 16 + 5]! * v398) + ((W2[1 * 16 + 6]! * v422) + ((W2[1 * 16 + 7]! * v446) + ((W2[1 * 16 + 8]! * v470) + ((W2[1 * 16 + 9]! * v494) + ((W2[1 * 16 + 10]! * v518) + ((W2[1 * 16 + 11]! * v542) + ((W2[1 * 16 + 12]! * v566) + ((W2[1 * 16 + 13]! * v590) + ((W2[1 * 16 + 14]! * v614) + ((W2[1 * 16 + 15]! * v638) + (0 : Float))))))))))))))))) + b2_1)), (Float.tanh (((W2[2 * 16 + 0]! * v278) + ((W2[2 * 16 + 1]! * v302) + ((W2[2 * 16 + 2]! * v326) + ((W2[2 * 16 + 3]! * v350) + ((W2[2 * 16 + 4]! * v374) + ((W2[2 * 16 + 5]! * v398) + ((W2[2 * 16 + 6]! * v422) + ((W2[2 * 16 + 7]! * v446) + ((W2[2 * 16 + 8]! * v470) + ((W2[2 * 16 + 9]! * v494) + ((W2[2 * 16 + 10]! * v518) + ((W2[2 * 16 + 11]! * v542) + ((W2[2 * 16 + 12]! * v566) + ((W2[2 * 16 + 13]! * v590) + ((W2[2 * 16 + 14]! * v614) + ((W2[2 * 16 + 15]! * v638) + (0 : Float))))))))))))))))) + b2_2))]

#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.863379 0.804830 0.746281 0.687732 0.629184 0.570635 0.512086 0.453537 0.394988 0.336440 0.277891 0.219342 1.760793 1.702244 #[1.139995, 1.081446, 1.022897, 0.964348, 0.905800, 0.847251, 0.788702, 0.730153, 0.671604, 0.613056, 0.554507, 0.495958, 0.437409, 0.378860, 0.320312, 0.261763, 0.203214, 1.744665, 1.686116, 1.627568, 1.569019, 1.510470, 1.451921, 1.393372, 1.334824, 1.276275, 1.217726, 1.159177, 1.100628, 1.042080, 0.983531, 0.924982, 0.866433, 0.807884, 0.749336, 0.690787, 0.632238, 0.573689, 0.515140, 0.456592, 0.398043, 0.339494, 0.280945, 0.222396, 1.763848, 1.705299, 1.646750, 1.588201, 1.529652, 1.471104, 1.412555, 1.354006, 1.295457, 1.236908, 1.178360, 1.119811, 1.061262, 1.002713, 0.944164, 0.885616, 0.827067, 0.768518, 0.709969, 0.651420, 0.592872, 0.534323, 0.475774, 0.417225, 0.358676, 0.300128, 0.241579, 1.783030, 1.724481, 1.665932, 1.607384, 1.548835, 1.490286, 1.431737, 1.373188, 1.314640, 1.256091, 1.197542, 1.138993, 1.080444, 1.021896, 0.963347, 0.904798, 0.846249, 0.787700, 0.729152, 0.670603, 0.612054, 0.553505, 0.494956, 0.436408, 0.377859, 0.319310, 0.260761, 0.202212, 1.743664, 1.685115, 1.626566, 1.568017, 1.509468, 1.450920, 1.392371, 1.333822, 1.275273, 1.216724, 1.158176, 1.099627, 1.041078, 0.982529, 0.923980, 0.865432, 0.806883, 0.748334, 0.689785, 0.631236, 0.572688, 0.514139, 0.455590, 0.397041, 0.338492, 0.279944, 0.221395, 1.762846, 1.704297, 1.645748, 1.587200, 1.528651, 1.470102, 1.411553, 1.353004, 1.294456, 1.235907, 1.177358, 1.118809, 1.060260, 1.001712, 0.943163, 0.884614, 0.826065, 0.767516, 0.708968, 0.650419, 0.591870, 0.533321, 0.474772, 0.416224, 0.357675, 0.299126, 0.240577, 1.782028, 1.723480, 1.664931, 1.606382, 1.547833, 1.489284, 1.430736, 1.372187, 1.313638, 1.255089, 1.196540, 1.137992, 1.079443, 1.020894, 0.962345, 0.903796, 0.845248, 0.786699, 0.728150, 0.669601, 0.611052, 0.552504, 0.493955] #[1.139995, 1.081446, 1.022897, 0.964348, 0.905800, 0.847251, 0.788702, 0.730153, 0.671604, 0.613056, 0.554507, 0.495958, 0.437409, 0.378860, 0.320312, 0.261763] #[1.139995, 1.081446, 1.022897, 0.964348, 0.905800, 0.847251, 0.788702, 0.730153, 0.671604, 0.613056, 0.554507, 0.495958, 0.437409, 0.378860, 0.320312, 0.261763, 0.203214, 1.744665, 1.686116, 1.627568, 1.569019, 1.510470, 1.451921, 1.393372, 1.334824, 1.276275, 1.217726, 1.159177, 1.100628, 1.042080, 0.983531, 0.924982, 0.866433, 0.807884, 0.749336, 0.690787, 0.632238, 0.573689, 0.515140, 0.456592, 0.398043, 0.339494, 0.280945, 0.222396, 1.763848, 1.705299, 1.646750, 1.588201]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.532187 0.473638 0.415089 0.356540 0.297992 0.239443 1.780894 1.722345 1.663796 1.605248 1.546699 1.488150 1.429601 1.371052 #[0.808803, 0.750254, 0.691705, 0.633156, 0.574608, 0.516059, 0.457510, 0.398961, 0.340412, 0.281864, 0.223315, 1.764766, 1.706217, 1.647668, 1.589120, 1.530571, 1.472022, 1.413473, 1.354924, 1.296376, 1.237827, 1.179278, 1.120729, 1.062180, 1.003632, 0.945083, 0.886534, 0.827985, 0.769436, 0.710888, 0.652339, 0.593790, 0.535241, 0.476692, 0.418144, 0.359595, 0.301046, 0.242497, 1.783948, 1.725400, 1.666851, 1.608302, 1.549753, 1.491204, 1.432656, 1.374107, 1.315558, 1.257009, 1.198460, 1.139912, 1.081363, 1.022814, 0.964265, 0.905716, 0.847168, 0.788619, 0.730070, 0.671521, 0.612972, 0.554424, 0.495875, 0.437326, 0.378777, 0.320228, 0.261680, 0.203131, 1.744582, 1.686033, 1.627484, 1.568936, 1.510387, 1.451838, 1.393289, 1.334740, 1.276192, 1.217643, 1.159094, 1.100545, 1.041996, 0.983448, 0.924899, 0.866350, 0.807801, 0.749252, 0.690704, 0.632155, 0.573606, 0.515057, 0.456508, 0.397960, 0.339411, 0.280862, 0.222313, 1.763764, 1.705216, 1.646667, 1.588118, 1.529569, 1.471020, 1.412472, 1.353923, 1.295374, 1.236825, 1.178276, 1.119728, 1.061179, 1.002630, 0.944081, 0.885532, 0.826984, 0.768435, 0.709886, 0.651337, 0.592788, 0.534240, 0.475691, 0.417142, 0.358593, 0.300044, 0.241496, 1.782947, 1.724398, 1.665849, 1.607300, 1.548752, 1.490203, 1.431654, 1.373105, 1.314556, 1.256008, 1.197459, 1.138910, 1.080361, 1.021812, 0.963264, 0.904715, 0.846166, 0.787617, 0.729068, 0.670520, 0.611971, 0.553422, 0.494873, 0.436324, 0.377776, 0.319227, 0.260678, 0.202129, 1.743580, 1.685032, 1.626483, 1.567934, 1.509385, 1.450836, 1.392288, 1.333739, 1.275190, 1.216641, 1.158092, 1.099544, 1.040995, 0.982446, 0.923897, 0.865348, 0.806800, 0.748251, 0.689702, 0.631153, 0.572604, 0.514056, 0.455507, 0.396958, 0.338409, 0.279860, 0.221312, 1.762763] #[0.808803, 0.750254, 0.691705, 0.633156, 0.574608, 0.516059, 0.457510, 0.398961, 0.340412, 0.281864, 0.223315, 1.764766, 1.706217, 1.647668, 1.589120, 1.530571] #[0.808803, 0.750254, 0.691705, 0.633156, 0.574608, 0.516059, 0.457510, 0.398961, 0.340412, 0.281864, 0.223315, 1.764766, 1.706217, 1.647668, 1.589120, 1.530571, 1.472022, 1.413473, 1.354924, 1.296376, 1.237827, 1.179278, 1.120729, 1.062180, 1.003632, 0.945083, 0.886534, 0.827985, 0.769436, 0.710888, 0.652339, 0.593790, 0.535241, 0.476692, 0.418144, 0.359595, 0.301046, 0.242497, 1.783948, 1.725400, 1.666851, 1.608302, 1.549753, 1.491204, 1.432656, 1.374107, 1.315558, 1.257009]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.200995 1.742446 1.683897 1.625348 1.566800 1.508251 1.449702 1.391153 1.332604 1.274056 1.215507 1.156958 1.098409 1.039860 #[0.477611, 0.419062, 0.360513, 0.301964, 0.243416, 1.784867, 1.726318, 1.667769, 1.609220, 1.550672, 1.492123, 1.433574, 1.375025, 1.316476, 1.257928, 1.199379, 1.140830, 1.082281, 1.023732, 0.965184, 0.906635, 0.848086, 0.789537, 0.730988, 0.672440, 0.613891, 0.555342, 0.496793, 0.438244, 0.379696, 0.321147, 0.262598, 0.204049, 1.745500, 1.686952, 1.628403, 1.569854, 1.511305, 1.452756, 1.394208, 1.335659, 1.277110, 1.218561, 1.160012, 1.101464, 1.042915, 0.984366, 0.925817, 0.867268, 0.808720, 0.750171, 0.691622, 0.633073, 0.574524, 0.515976, 0.457427, 0.398878, 0.340329, 0.281780, 0.223232, 1.764683, 1.706134, 1.647585, 1.589036, 1.530488, 1.471939, 1.413390, 1.354841, 1.296292, 1.237744, 1.179195, 1.120646, 1.062097, 1.003548, 0.945000, 0.886451, 0.827902, 0.769353, 0.710804, 0.652256, 0.593707, 0.535158, 0.476609, 0.418060, 0.359512, 0.300963, 0.242414, 1.783865, 1.725316, 1.666768, 1.608219, 1.549670, 1.491121, 1.432572, 1.374024, 1.315475, 1.256926, 1.198377, 1.139828, 1.081280, 1.022731, 0.964182, 0.905633, 0.847084, 0.788536, 0.729987, 0.671438, 0.612889, 0.554340, 0.495792, 0.437243, 0.378694, 0.320145, 0.261596, 0.203048, 1.744499, 1.685950, 1.627401, 1.568852, 1.510304, 1.451755, 1.393206, 1.334657, 1.276108, 1.217560, 1.159011, 1.100462, 1.041913, 0.983364, 0.924816, 0.866267, 0.807718, 0.749169, 0.690620, 0.632072, 0.573523, 0.514974, 0.456425, 0.397876, 0.339328, 0.280779, 0.222230, 1.763681, 1.705132, 1.646584, 1.588035, 1.529486, 1.470937, 1.412388, 1.353840, 1.295291, 1.236742, 1.178193, 1.119644, 1.061096, 1.002547, 0.943998, 0.885449, 0.826900, 0.768352, 0.709803, 0.651254, 0.592705, 0.534156, 0.475608, 0.417059, 0.358510, 0.299961, 0.241412, 1.782864, 1.724315, 1.665766, 1.607217, 1.548668, 1.490120, 1.431571] #[0.477611, 0.419062, 0.360513, 0.301964, 0.243416, 1.784867, 1.726318, 1.667769, 1.609220, 1.550672, 1.492123, 1.433574, 1.375025, 1.316476, 1.257928, 1.199379] #[0.477611, 0.419062, 0.360513, 0.301964, 0.243416, 1.784867, 1.726318, 1.667769, 1.609220, 1.550672, 1.492123, 1.433574, 1.375025, 1.316476, 1.257928, 1.199379, 1.140830, 1.082281, 1.023732, 0.965184, 0.906635, 0.848086, 0.789537, 0.730988, 0.672440, 0.613891, 0.555342, 0.496793, 0.438244, 0.379696, 0.321147, 0.262598, 0.204049, 1.745500, 1.686952, 1.628403, 1.569854, 1.511305, 1.452756, 1.394208, 1.335659, 1.277110, 1.218561, 1.160012, 1.101464, 1.042915, 0.984366, 0.925817]).map Float.toBits))

def check_mlpPolicy_bounded (b2_0 : Float) (b2_1 : Float) (b2_2 : Float) (o_0 : Float) (o_1 : Float) (o_2 : Float) (o_3 : Float) (o_4 : Float) (o_5 : Float) (o_6 : Float) (o_7 : Float) (o_8 : Float) (o_9 : Float) (o_10 : Float) (W1 : Array Float) (b1 : Array Float) (W2 : Array Float) : Bool :=
  let v278 := (Float.tanh (((W1[0 * 11 + 0]! * o_0) + ((W1[0 * 11 + 1]! * o_1) + ((W1[0 * 11 + 2]! * o_2) + ((W1[0 * 11 + 3]! * o_3) + ((W1[0 * 11 + 4]! * o_4) + ((W1[0 * 11 + 5]! * o_5) + ((W1[0 * 11 + 6]! * o_6) + ((W1[0 * 11 + 7]! * o_7) + ((W1[0 * 11 + 8]! * o_8) + ((W1[0 * 11 + 9]! * o_9) + ((W1[0 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[0]!))
  let v302 := (Float.tanh (((W1[1 * 11 + 0]! * o_0) + ((W1[1 * 11 + 1]! * o_1) + ((W1[1 * 11 + 2]! * o_2) + ((W1[1 * 11 + 3]! * o_3) + ((W1[1 * 11 + 4]! * o_4) + ((W1[1 * 11 + 5]! * o_5) + ((W1[1 * 11 + 6]! * o_6) + ((W1[1 * 11 + 7]! * o_7) + ((W1[1 * 11 + 8]! * o_8) + ((W1[1 * 11 + 9]! * o_9) + ((W1[1 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[1]!))
  let v326 := (Float.tanh (((W1[2 * 11 + 0]! * o_0) + ((W1[2 * 11 + 1]! * o_1) + ((W1[2 * 11 + 2]! * o_2) + ((W1[2 * 11 + 3]! * o_3) + ((W1[2 * 11 + 4]! * o_4) + ((W1[2 * 11 + 5]! * o_5) + ((W1[2 * 11 + 6]! * o_6) + ((W1[2 * 11 + 7]! * o_7) + ((W1[2 * 11 + 8]! * o_8) + ((W1[2 * 11 + 9]! * o_9) + ((W1[2 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[2]!))
  let v350 := (Float.tanh (((W1[3 * 11 + 0]! * o_0) + ((W1[3 * 11 + 1]! * o_1) + ((W1[3 * 11 + 2]! * o_2) + ((W1[3 * 11 + 3]! * o_3) + ((W1[3 * 11 + 4]! * o_4) + ((W1[3 * 11 + 5]! * o_5) + ((W1[3 * 11 + 6]! * o_6) + ((W1[3 * 11 + 7]! * o_7) + ((W1[3 * 11 + 8]! * o_8) + ((W1[3 * 11 + 9]! * o_9) + ((W1[3 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[3]!))
  let v374 := (Float.tanh (((W1[4 * 11 + 0]! * o_0) + ((W1[4 * 11 + 1]! * o_1) + ((W1[4 * 11 + 2]! * o_2) + ((W1[4 * 11 + 3]! * o_3) + ((W1[4 * 11 + 4]! * o_4) + ((W1[4 * 11 + 5]! * o_5) + ((W1[4 * 11 + 6]! * o_6) + ((W1[4 * 11 + 7]! * o_7) + ((W1[4 * 11 + 8]! * o_8) + ((W1[4 * 11 + 9]! * o_9) + ((W1[4 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[4]!))
  let v398 := (Float.tanh (((W1[5 * 11 + 0]! * o_0) + ((W1[5 * 11 + 1]! * o_1) + ((W1[5 * 11 + 2]! * o_2) + ((W1[5 * 11 + 3]! * o_3) + ((W1[5 * 11 + 4]! * o_4) + ((W1[5 * 11 + 5]! * o_5) + ((W1[5 * 11 + 6]! * o_6) + ((W1[5 * 11 + 7]! * o_7) + ((W1[5 * 11 + 8]! * o_8) + ((W1[5 * 11 + 9]! * o_9) + ((W1[5 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[5]!))
  let v422 := (Float.tanh (((W1[6 * 11 + 0]! * o_0) + ((W1[6 * 11 + 1]! * o_1) + ((W1[6 * 11 + 2]! * o_2) + ((W1[6 * 11 + 3]! * o_3) + ((W1[6 * 11 + 4]! * o_4) + ((W1[6 * 11 + 5]! * o_5) + ((W1[6 * 11 + 6]! * o_6) + ((W1[6 * 11 + 7]! * o_7) + ((W1[6 * 11 + 8]! * o_8) + ((W1[6 * 11 + 9]! * o_9) + ((W1[6 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[6]!))
  let v446 := (Float.tanh (((W1[7 * 11 + 0]! * o_0) + ((W1[7 * 11 + 1]! * o_1) + ((W1[7 * 11 + 2]! * o_2) + ((W1[7 * 11 + 3]! * o_3) + ((W1[7 * 11 + 4]! * o_4) + ((W1[7 * 11 + 5]! * o_5) + ((W1[7 * 11 + 6]! * o_6) + ((W1[7 * 11 + 7]! * o_7) + ((W1[7 * 11 + 8]! * o_8) + ((W1[7 * 11 + 9]! * o_9) + ((W1[7 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[7]!))
  let v470 := (Float.tanh (((W1[8 * 11 + 0]! * o_0) + ((W1[8 * 11 + 1]! * o_1) + ((W1[8 * 11 + 2]! * o_2) + ((W1[8 * 11 + 3]! * o_3) + ((W1[8 * 11 + 4]! * o_4) + ((W1[8 * 11 + 5]! * o_5) + ((W1[8 * 11 + 6]! * o_6) + ((W1[8 * 11 + 7]! * o_7) + ((W1[8 * 11 + 8]! * o_8) + ((W1[8 * 11 + 9]! * o_9) + ((W1[8 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[8]!))
  let v494 := (Float.tanh (((W1[9 * 11 + 0]! * o_0) + ((W1[9 * 11 + 1]! * o_1) + ((W1[9 * 11 + 2]! * o_2) + ((W1[9 * 11 + 3]! * o_3) + ((W1[9 * 11 + 4]! * o_4) + ((W1[9 * 11 + 5]! * o_5) + ((W1[9 * 11 + 6]! * o_6) + ((W1[9 * 11 + 7]! * o_7) + ((W1[9 * 11 + 8]! * o_8) + ((W1[9 * 11 + 9]! * o_9) + ((W1[9 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[9]!))
  let v518 := (Float.tanh (((W1[10 * 11 + 0]! * o_0) + ((W1[10 * 11 + 1]! * o_1) + ((W1[10 * 11 + 2]! * o_2) + ((W1[10 * 11 + 3]! * o_3) + ((W1[10 * 11 + 4]! * o_4) + ((W1[10 * 11 + 5]! * o_5) + ((W1[10 * 11 + 6]! * o_6) + ((W1[10 * 11 + 7]! * o_7) + ((W1[10 * 11 + 8]! * o_8) + ((W1[10 * 11 + 9]! * o_9) + ((W1[10 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[10]!))
  let v542 := (Float.tanh (((W1[11 * 11 + 0]! * o_0) + ((W1[11 * 11 + 1]! * o_1) + ((W1[11 * 11 + 2]! * o_2) + ((W1[11 * 11 + 3]! * o_3) + ((W1[11 * 11 + 4]! * o_4) + ((W1[11 * 11 + 5]! * o_5) + ((W1[11 * 11 + 6]! * o_6) + ((W1[11 * 11 + 7]! * o_7) + ((W1[11 * 11 + 8]! * o_8) + ((W1[11 * 11 + 9]! * o_9) + ((W1[11 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[11]!))
  let v566 := (Float.tanh (((W1[12 * 11 + 0]! * o_0) + ((W1[12 * 11 + 1]! * o_1) + ((W1[12 * 11 + 2]! * o_2) + ((W1[12 * 11 + 3]! * o_3) + ((W1[12 * 11 + 4]! * o_4) + ((W1[12 * 11 + 5]! * o_5) + ((W1[12 * 11 + 6]! * o_6) + ((W1[12 * 11 + 7]! * o_7) + ((W1[12 * 11 + 8]! * o_8) + ((W1[12 * 11 + 9]! * o_9) + ((W1[12 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[12]!))
  let v590 := (Float.tanh (((W1[13 * 11 + 0]! * o_0) + ((W1[13 * 11 + 1]! * o_1) + ((W1[13 * 11 + 2]! * o_2) + ((W1[13 * 11 + 3]! * o_3) + ((W1[13 * 11 + 4]! * o_4) + ((W1[13 * 11 + 5]! * o_5) + ((W1[13 * 11 + 6]! * o_6) + ((W1[13 * 11 + 7]! * o_7) + ((W1[13 * 11 + 8]! * o_8) + ((W1[13 * 11 + 9]! * o_9) + ((W1[13 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[13]!))
  let v614 := (Float.tanh (((W1[14 * 11 + 0]! * o_0) + ((W1[14 * 11 + 1]! * o_1) + ((W1[14 * 11 + 2]! * o_2) + ((W1[14 * 11 + 3]! * o_3) + ((W1[14 * 11 + 4]! * o_4) + ((W1[14 * 11 + 5]! * o_5) + ((W1[14 * 11 + 6]! * o_6) + ((W1[14 * 11 + 7]! * o_7) + ((W1[14 * 11 + 8]! * o_8) + ((W1[14 * 11 + 9]! * o_9) + ((W1[14 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[14]!))
  let v638 := (Float.tanh (((W1[15 * 11 + 0]! * o_0) + ((W1[15 * 11 + 1]! * o_1) + ((W1[15 * 11 + 2]! * o_2) + ((W1[15 * 11 + 3]! * o_3) + ((W1[15 * 11 + 4]! * o_4) + ((W1[15 * 11 + 5]! * o_5) + ((W1[15 * 11 + 6]! * o_6) + ((W1[15 * 11 + 7]! * o_7) + ((W1[15 * 11 + 8]! * o_8) + ((W1[15 * 11 + 9]! * o_9) + ((W1[15 * 11 + 10]! * o_10) + (0 : Float)))))))))))) + b1[15]!))
  (((Float.abs (Float.tanh (((W2[0 * 16 + 0]! * v278) + ((W2[0 * 16 + 1]! * v302) + ((W2[0 * 16 + 2]! * v326) + ((W2[0 * 16 + 3]! * v350) + ((W2[0 * 16 + 4]! * v374) + ((W2[0 * 16 + 5]! * v398) + ((W2[0 * 16 + 6]! * v422) + ((W2[0 * 16 + 7]! * v446) + ((W2[0 * 16 + 8]! * v470) + ((W2[0 * 16 + 9]! * v494) + ((W2[0 * 16 + 10]! * v518) + ((W2[0 * 16 + 11]! * v542) + ((W2[0 * 16 + 12]! * v566) + ((W2[0 * 16 + 13]! * v590) + ((W2[0 * 16 + 14]! * v614) + ((W2[0 * 16 + 15]! * v638) + (0 : Float))))))))))))))))) + b2_0))) <= (1 : Float)) && (((Float.abs (Float.tanh (((W2[1 * 16 + 0]! * v278) + ((W2[1 * 16 + 1]! * v302) + ((W2[1 * 16 + 2]! * v326) + ((W2[1 * 16 + 3]! * v350) + ((W2[1 * 16 + 4]! * v374) + ((W2[1 * 16 + 5]! * v398) + ((W2[1 * 16 + 6]! * v422) + ((W2[1 * 16 + 7]! * v446) + ((W2[1 * 16 + 8]! * v470) + ((W2[1 * 16 + 9]! * v494) + ((W2[1 * 16 + 10]! * v518) + ((W2[1 * 16 + 11]! * v542) + ((W2[1 * 16 + 12]! * v566) + ((W2[1 * 16 + 13]! * v590) + ((W2[1 * 16 + 14]! * v614) + ((W2[1 * 16 + 15]! * v638) + (0 : Float))))))))))))))))) + b2_1))) <= (1 : Float)) && ((Float.abs (Float.tanh (((W2[2 * 16 + 0]! * v278) + ((W2[2 * 16 + 1]! * v302) + ((W2[2 * 16 + 2]! * v326) + ((W2[2 * 16 + 3]! * v350) + ((W2[2 * 16 + 4]! * v374) + ((W2[2 * 16 + 5]! * v398) + ((W2[2 * 16 + 6]! * v422) + ((W2[2 * 16 + 7]! * v446) + ((W2[2 * 16 + 8]! * v470) + ((W2[2 * 16 + 9]! * v494) + ((W2[2 * 16 + 10]! * v518) + ((W2[2 * 16 + 11]! * v542) + ((W2[2 * 16 + 12]! * v566) + ((W2[2 * 16 + 13]! * v590) + ((W2[2 * 16 + 14]! * v614) + ((W2[2 * 16 + 15]! * v638) + (0 : Float))))))))))))))))) + b2_2))) <= (1 : Float))))

#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 0.677227 0.618678 0.560129 0.501580 0.443032 0.384483 0.325934 0.267385 0.208836 1.750288 1.691739 1.633190 1.574641 1.516092 #[0.953843, 0.895294, 0.836745, 0.778196, 0.719648, 0.661099, 0.602550, 0.544001, 0.485452, 0.426904, 0.368355, 0.309806, 0.251257, 1.792708, 1.734160, 1.675611, 1.617062, 1.558513, 1.499964, 1.441416, 1.382867, 1.324318, 1.265769, 1.207220, 1.148672, 1.090123, 1.031574, 0.973025, 0.914476, 0.855928, 0.797379, 0.738830, 0.680281, 0.621732, 0.563184, 0.504635, 0.446086, 0.387537, 0.328988, 0.270440, 0.211891, 1.753342, 1.694793, 1.636244, 1.577696, 1.519147, 1.460598, 1.402049, 1.343500, 1.284952, 1.226403, 1.167854, 1.109305, 1.050756, 0.992208, 0.933659, 0.875110, 0.816561, 0.758012, 0.699464, 0.640915, 0.582366, 0.523817, 0.465268, 0.406720, 0.348171, 0.289622, 0.231073, 1.772524, 1.713976, 1.655427, 1.596878, 1.538329, 1.479780, 1.421232, 1.362683, 1.304134, 1.245585, 1.187036, 1.128488, 1.069939, 1.011390, 0.952841, 0.894292, 0.835744, 0.777195, 0.718646, 0.660097, 0.601548, 0.543000, 0.484451, 0.425902, 0.367353, 0.308804, 0.250256, 1.791707, 1.733158, 1.674609, 1.616060, 1.557512, 1.498963, 1.440414, 1.381865, 1.323316, 1.264768, 1.206219, 1.147670, 1.089121, 1.030572, 0.972024, 0.913475, 0.854926, 0.796377, 0.737828, 0.679280, 0.620731, 0.562182, 0.503633, 0.445084, 0.386536, 0.327987, 0.269438, 0.210889, 1.752340, 1.693792, 1.635243, 1.576694, 1.518145, 1.459596, 1.401048, 1.342499, 1.283950, 1.225401, 1.166852, 1.108304, 1.049755, 0.991206, 0.932657, 0.874108, 0.815560, 0.757011, 0.698462, 0.639913, 0.581364, 0.522816, 0.464267, 0.405718, 0.347169, 0.288620, 0.230072, 1.771523, 1.712974, 1.654425, 1.595876, 1.537328, 1.478779, 1.420230, 1.361681, 1.303132, 1.244584, 1.186035, 1.127486, 1.068937, 1.010388, 0.951840, 0.893291, 0.834742, 0.776193, 0.717644, 0.659096, 0.600547, 0.541998, 0.483449, 0.424900, 0.366352, 0.307803] #[0.953843, 0.895294, 0.836745, 0.778196, 0.719648, 0.661099, 0.602550, 0.544001, 0.485452, 0.426904, 0.368355, 0.309806, 0.251257, 1.792708, 1.734160, 1.675611] #[0.953843, 0.895294, 0.836745, 0.778196, 0.719648, 0.661099, 0.602550, 0.544001, 0.485452, 0.426904, 0.368355, 0.309806, 0.251257, 1.792708, 1.734160, 1.675611, 1.617062, 1.558513, 1.499964, 1.441416, 1.382867, 1.324318, 1.265769, 1.207220, 1.148672, 1.090123, 1.031574, 0.973025, 0.914476, 0.855928, 0.797379, 0.738830, 0.680281, 0.621732, 0.563184, 0.504635, 0.446086, 0.387537, 0.328988, 0.270440, 0.211891, 1.753342, 1.694793, 1.636244, 1.577696, 1.519147, 1.460598, 1.402049]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 0.346035 0.287486 0.228937 1.770388 1.711840 1.653291 1.594742 1.536193 1.477644 1.419096 1.360547 1.301998 1.243449 1.184900 #[0.622651, 0.564102, 0.505553, 0.447004, 0.388456, 0.329907, 0.271358, 0.212809, 1.754260, 1.695712, 1.637163, 1.578614, 1.520065, 1.461516, 1.402968, 1.344419, 1.285870, 1.227321, 1.168772, 1.110224, 1.051675, 0.993126, 0.934577, 0.876028, 0.817480, 0.758931, 0.700382, 0.641833, 0.583284, 0.524736, 0.466187, 0.407638, 0.349089, 0.290540, 0.231992, 1.773443, 1.714894, 1.656345, 1.597796, 1.539248, 1.480699, 1.422150, 1.363601, 1.305052, 1.246504, 1.187955, 1.129406, 1.070857, 1.012308, 0.953760, 0.895211, 0.836662, 0.778113, 0.719564, 0.661016, 0.602467, 0.543918, 0.485369, 0.426820, 0.368272, 0.309723, 0.251174, 1.792625, 1.734076, 1.675528, 1.616979, 1.558430, 1.499881, 1.441332, 1.382784, 1.324235, 1.265686, 1.207137, 1.148588, 1.090040, 1.031491, 0.972942, 0.914393, 0.855844, 0.797296, 0.738747, 0.680198, 0.621649, 0.563100, 0.504552, 0.446003, 0.387454, 0.328905, 0.270356, 0.211808, 1.753259, 1.694710, 1.636161, 1.577612, 1.519064, 1.460515, 1.401966, 1.343417, 1.284868, 1.226320, 1.167771, 1.109222, 1.050673, 0.992124, 0.933576, 0.875027, 0.816478, 0.757929, 0.699380, 0.640832, 0.582283, 0.523734, 0.465185, 0.406636, 0.348088, 0.289539, 0.230990, 1.772441, 1.713892, 1.655344, 1.596795, 1.538246, 1.479697, 1.421148, 1.362600, 1.304051, 1.245502, 1.186953, 1.128404, 1.069856, 1.011307, 0.952758, 0.894209, 0.835660, 0.777112, 0.718563, 0.660014, 0.601465, 0.542916, 0.484368, 0.425819, 0.367270, 0.308721, 0.250172, 1.791624, 1.733075, 1.674526, 1.615977, 1.557428, 1.498880, 1.440331, 1.381782, 1.323233, 1.264684, 1.206136, 1.147587, 1.089038, 1.030489, 0.971940, 0.913392, 0.854843, 0.796294, 0.737745, 0.679196, 0.620648, 0.562099, 0.503550, 0.445001, 0.386452, 0.327904, 0.269355, 0.210806, 1.752257, 1.693708, 1.635160, 1.576611] #[0.622651, 0.564102, 0.505553, 0.447004, 0.388456, 0.329907, 0.271358, 0.212809, 1.754260, 1.695712, 1.637163, 1.578614, 1.520065, 1.461516, 1.402968, 1.344419] #[0.622651, 0.564102, 0.505553, 0.447004, 0.388456, 0.329907, 0.271358, 0.212809, 1.754260, 1.695712, 1.637163, 1.578614, 1.520065, 1.461516, 1.402968, 1.344419, 1.285870, 1.227321, 1.168772, 1.110224, 1.051675, 0.993126, 0.934577, 0.876028, 0.817480, 0.758931, 0.700382, 0.641833, 0.583284, 0.524736, 0.466187, 0.407638, 0.349089, 0.290540, 0.231992, 1.773443, 1.714894, 1.656345, 1.597796, 1.539248, 1.480699, 1.422150, 1.363601, 1.305052, 1.246504, 1.187955, 1.129406, 1.070857]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.614843 1.556294 1.497745 1.439196 1.380648 1.322099 1.263550 1.205001 1.146452 1.087904 1.029355 0.970806 0.912257 0.853708 #[0.291459, 0.232910, 1.774361, 1.715812, 1.657264, 1.598715, 1.540166, 1.481617, 1.423068, 1.364520, 1.305971, 1.247422, 1.188873, 1.130324, 1.071776, 1.013227, 0.954678, 0.896129, 0.837580, 0.779032, 0.720483, 0.661934, 0.603385, 0.544836, 0.486288, 0.427739, 0.369190, 0.310641, 0.252092, 1.793544, 1.734995, 1.676446, 1.617897, 1.559348, 1.500800, 1.442251, 1.383702, 1.325153, 1.266604, 1.208056, 1.149507, 1.090958, 1.032409, 0.973860, 0.915312, 0.856763, 0.798214, 0.739665, 0.681116, 0.622568, 0.564019, 0.505470, 0.446921, 0.388372, 0.329824, 0.271275, 0.212726, 1.754177, 1.695628, 1.637080, 1.578531, 1.519982, 1.461433, 1.402884, 1.344336, 1.285787, 1.227238, 1.168689, 1.110140, 1.051592, 0.993043, 0.934494, 0.875945, 0.817396, 0.758848, 0.700299, 0.641750, 0.583201, 0.524652, 0.466104, 0.407555, 0.349006, 0.290457, 0.231908, 1.773360, 1.714811, 1.656262, 1.597713, 1.539164, 1.480616, 1.422067, 1.363518, 1.304969, 1.246420, 1.187872, 1.129323, 1.070774, 1.012225, 0.953676, 0.895128, 0.836579, 0.778030, 0.719481, 0.660932, 0.602384, 0.543835, 0.485286, 0.426737, 0.368188, 0.309640, 0.251091, 1.792542, 1.733993, 1.675444, 1.616896, 1.558347, 1.499798, 1.441249, 1.382700, 1.324152, 1.265603, 1.207054, 1.148505, 1.089956, 1.031408, 0.972859, 0.914310, 0.855761, 0.797212, 0.738664, 0.680115, 0.621566, 0.563017, 0.504468, 0.445920, 0.387371, 0.328822, 0.270273, 0.211724, 1.753176, 1.694627, 1.636078, 1.577529, 1.518980, 1.460432, 1.401883, 1.343334, 1.284785, 1.226236, 1.167688, 1.109139, 1.050590, 0.992041, 0.933492, 0.874944, 0.816395, 0.757846, 0.699297, 0.640748, 0.582200, 0.523651, 0.465102, 0.406553, 0.348004, 0.289456, 0.230907, 1.772358, 1.713809, 1.655260, 1.596712, 1.538163, 1.479614, 1.421065, 1.362516, 1.303968, 1.245419] #[0.291459, 0.232910, 1.774361, 1.715812, 1.657264, 1.598715, 1.540166, 1.481617, 1.423068, 1.364520, 1.305971, 1.247422, 1.188873, 1.130324, 1.071776, 1.013227] #[0.291459, 0.232910, 1.774361, 1.715812, 1.657264, 1.598715, 1.540166, 1.481617, 1.423068, 1.364520, 1.305971, 1.247422, 1.188873, 1.130324, 1.071776, 1.013227, 0.954678, 0.896129, 0.837580, 0.779032, 0.720483, 0.661934, 0.603385, 0.544836, 0.486288, 0.427739, 0.369190, 0.310641, 0.252092, 1.793544, 1.734995, 1.676446, 1.617897, 1.559348, 1.500800, 1.442251, 1.383702, 1.325153, 1.266604, 1.208056, 1.149507, 1.090958, 1.032409, 0.973860, 0.915312, 0.856763, 0.798214, 0.739665]))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.491075 0.432526 0.373977 0.315428 0.256880 1.798331))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.759883 1.701334 1.642785 1.584236 1.525688 1.467139))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.428691 1.370142 1.311593 1.253044 1.194496 1.135947))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.304923 0.246374 1.787825 1.729276 1.670728 1.612179))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.573731 1.515182 1.456633 1.398084 1.339536 1.280987))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.242539 1.183990 1.125441 1.066892 1.008344 0.949795))

def ntuOf (UA : Float) (mcp : Float) : Float :=
  (UA / (max mcp (0.000001 : Float)))

#eval IO.println ("ntuOf " ++ toString (ntuOf 1.718771 1.660222).toBits)
#eval IO.println ("ntuOf " ++ toString (ntuOf 1.387579 1.329030).toBits)
#eval IO.println ("ntuOf " ++ toString (ntuOf 1.056387 0.997838).toBits)

def nusseltLam  : Float :=
  (4.364 : Float)

#eval IO.println ("nusseltLam " ++ toString (nusseltLam).toBits)
#eval IO.println ("nusseltLam " ++ toString (nusseltLam).toBits)
#eval IO.println ("nusseltLam " ++ toString (nusseltLam).toBits)

def nusseltOf (Q : Float) (D : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  let v10 := (v4 ^ 2)
  let v29 := ((Float.exp (((586.375 : Float) / (v4 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v30 := ((((((1020.62 : Float) - ((0.614254 : Float) * v4)) - ((0.000321 : Float) * v10)) * (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))) * D) / v29)
  (if (v30 < (2300 : Float)) then (4.364 : Float) else (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max v30 (1 : Float)))))) * (Float.exp ((0.4 : Float) * (Float.log (max ((v29 * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * v10)))) / (((0.118294 : Float) - ((0.000033 : Float) * v4)) - ((0.00000015 : Float) * v10))) (0.01 : Float)))))))

#eval IO.println ("nusseltOf " ++ toString (nusseltOf 1.346467 1.287918 1.229369).toBits)
#eval IO.println ("nusseltOf " ++ toString (nusseltOf 1.015275 0.956726 0.898177).toBits)
#eval IO.println ("nusseltOf " ++ toString (nusseltOf 0.684083 0.625534 0.566985).toBits)

def nusseltTurb (Re : Float) (Pr : Float) : Float :=
  (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max Re (1 : Float)))))) * (Float.exp ((0.4 : Float) * (Float.log (max Pr (0.01 : Float))))))

#eval IO.println ("nusseltTurb " ++ toString (nusseltTurb 1.160315 1.101766).toBits)
#eval IO.println ("nusseltTurb " ++ toString (nusseltTurb 0.829123 0.770574).toBits)
#eval IO.println ("nusseltTurb " ++ toString (nusseltTurb 0.497931 0.439382).toBits)

def check_nusseltTurb_mono (Re1 : Float) (Re2 : Float) (Pr : Float) : Bool :=
  let v17 := (Float.exp ((0.4 : Float) * (Float.log (max Pr (0.01 : Float)))))
  (!(Re1 <= Re2) || ((((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max Re1 (1 : Float)))))) * v17) <= (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max Re2 (1 : Float)))))) * v17)))

#eval IO.println ("check_nusseltTurb_mono " ++ toString (check_nusseltTurb_mono 0.974163 0.915614 0.857065))
#eval IO.println ("check_nusseltTurb_mono " ++ toString (check_nusseltTurb_mono 0.642971 0.584422 0.525873))
#eval IO.println ("check_nusseltTurb_mono " ++ toString (check_nusseltTurb_mono 0.311779 0.253230 1.794681))

def obsHi  : Array Float :=
  #[(3.141592653589793 : Float), ((3.141592653589793 : Float) / (2 : Float)), ((3.141592653589793 : Float) / (2 : Float)), (1 : Float), (1 : Float), ((318.15 : Float) / (300 : Float)), (1 : Float), (1 : Float), (1.2 : Float), (1 : Float), (1 : Float)]

#eval IO.println ("obsHi " ++ toString ((obsHi).map Float.toBits))
#eval IO.println ("obsHi " ++ toString ((obsHi).map Float.toBits))
#eval IO.println ("obsHi " ++ toString ((obsHi).map Float.toBits))

def obsLo  : Array Float :=
  #[(-(3.141592653589793 : Float)), ((-(3.141592653589793 : Float)) / (2 : Float)), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (-(2 : Float)), (0 : Float), (0 : Float)]

#eval IO.println ("obsLo " ++ toString ((obsLo).map Float.toBits))
#eval IO.println ("obsLo " ++ toString ((obsLo).map Float.toBits))
#eval IO.println ("obsLo " ++ toString ((obsLo).map Float.toBits))

def obsOf (az : Float) (t : Float) (elSun : Float) (azSun : Float) (taut : Float) (holds : Float) (Toil : Float) (tDead : Float) (margin : Float) (flow : Float) (deg : Float) : Array Float :=
  let v11 := (azSun - az)
  let v14 := ((2 : Float) * (3.141592653589793 : Float))
  let v20 := ((3.141592653589793 : Float) / (2 : Float))
  let v31 := (Float.sin t)
  let v33 := (v31 * (Float.cos az))
  let v35 := (v31 * (Float.sin az))
  let v36 := (Float.cos t)
  let v37 := (Float.cos elSun)
  let v39 := (v37 * (Float.cos azSun))
  let v41 := (v37 * (Float.sin azSun))
  let v42 := (Float.sin elSun)
  let v47 := (((v33 * v39) + (v35 * v41)) + (v36 * v42))
  let v62 := (Float.sqrt (((((v35 * v42) - (v36 * v41)) ^ 2) + (((v36 * v39) - (v33 * v42)) ^ 2)) + (((v33 * v41) - (v35 * v39)) ^ 2)))
  #[(v11 - (v14 * (Float.floor ((v11 + (3.141592653589793 : Float)) / v14)))), ((v20 - t) - elSun), t, taut, holds, ((Toil - (300 : Float)) / (300 : Float)), (1.0 / (1.0 + Float.exp (-((elSun - (v20 - tDead)) / (0.01 : Float))))), ((1.0 / (1.0 + Float.exp (-((elSun - (v20 - tDead)) / (0.01 : Float))))) * (1.0 / (1.0 + Float.exp (-(((if (v47 <= (0 : Float)) then (v20 + (Float.atan ((-v47) / (max v62 (0.000000000001 : Float))))) else (Float.atan (v62 / v47))) - (0.03 : Float)) / (0.01 : Float)))))), margin, flow, deg]

#eval IO.println ("obsOf " ++ toString ((obsOf 0.415707 0.357158 0.298609 0.240060 1.781512 1.722963 1.664414 1.605865 1.547316 1.488768 1.430219).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 1.684515 1.625966 1.567417 1.508868 1.450320 1.391771 1.333222 1.274673 1.216124 1.157576 1.099027).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 1.353323 1.294774 1.236225 1.177676 1.119128 1.060579 1.002030 0.943481 0.884932 0.826384 0.767835).map Float.toBits))

def oilBulkMax  : Float :=
  (618.15 : Float)

#eval IO.println ("oilBulkMax " ++ toString (oilBulkMax).toBits)
#eval IO.println ("oilBulkMax " ++ toString (oilBulkMax).toBits)
#eval IO.println ("oilBulkMax " ++ toString (oilBulkMax).toBits)

def oilCp (T : Float) : Float :=
  let v2 := (T - (273.15 : Float))
  ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v2)) + ((0.0000008970757 : Float) * (v2 ^ 2))))

#eval IO.println ("oilCp " ++ toString (oilCp 1.643403).toBits)
#eval IO.println ("oilCp " ++ toString (oilCp 1.312211).toBits)
#eval IO.println ("oilCp " ++ toString (oilCp 0.981019).toBits)

def check_oilCp_pos (T : Float) : Bool :=
  let v4 := (T - (273.15 : Float))
  (!((273.15 : Float) <= T) || ((0 : Float) < ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * (v4 ^ 2))))))

#eval IO.println ("check_oilCp_pos " ++ toString (check_oilCp_pos 1.457251))
#eval IO.println ("check_oilCp_pos " ++ toString (check_oilCp_pos 1.126059))
#eval IO.println ("check_oilCp_pos " ++ toString (check_oilCp_pos 0.794867))

def oilFilmMax  : Float :=
  (648.15 : Float)

#eval IO.println ("oilFilmMax " ++ toString (oilFilmMax).toBits)
#eval IO.println ("oilFilmMax " ++ toString (oilFilmMax).toBits)
#eval IO.println ("oilFilmMax " ++ toString (oilFilmMax).toBits)

def oilK (T : Float) : Float :=
  let v2 := (T - (273.15 : Float))
  (((0.118294 : Float) - ((0.000033 : Float) * v2)) - ((0.00000015 : Float) * (v2 ^ 2)))

#eval IO.println ("oilK " ++ toString (oilK 1.084947).toBits)
#eval IO.println ("oilK " ++ toString (oilK 0.753755).toBits)
#eval IO.println ("oilK " ++ toString (oilK 0.422563).toBits)

def check_oilK_pos (T : Float) : Bool :=
  let v6 := (T - (273.15 : Float))
  (!((273.15 : Float) <= T) || (!(T <= (618.15 : Float)) || ((0 : Float) < (((0.118294 : Float) - ((0.000033 : Float) * v6)) - ((0.00000015 : Float) * (v6 ^ 2))))))

#eval IO.println ("check_oilK_pos " ++ toString (check_oilK_pos 0.898795))
#eval IO.println ("check_oilK_pos " ++ toString (check_oilK_pos 0.567603))
#eval IO.println ("check_oilK_pos " ++ toString (check_oilK_pos 0.236411))

def oilMu (T : Float) : Float :=
  ((Float.exp (((586.375 : Float) / ((T - (273.15 : Float)) + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))

#eval IO.println ("oilMu " ++ toString (oilMu 0.712643).toBits)
#eval IO.println ("oilMu " ++ toString (oilMu 0.381451).toBits)
#eval IO.println ("oilMu " ++ toString (oilMu 1.650259).toBits)

def check_oilMu_pos (T : Float) : Bool :=
  ((0 : Float) < ((Float.exp (((586.375 : Float) / ((T - (273.15 : Float)) + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float)))

#eval IO.println ("check_oilMu_pos " ++ toString (check_oilMu_pos 0.526491))
#eval IO.println ("check_oilMu_pos " ++ toString (check_oilMu_pos 1.795299))
#eval IO.println ("check_oilMu_pos " ++ toString (check_oilMu_pos 1.464107))

def oilPourPoint  : Float :=
  (248.15 : Float)

#eval IO.println ("oilPourPoint " ++ toString (oilPourPoint).toBits)
#eval IO.println ("oilPourPoint " ++ toString (oilPourPoint).toBits)
#eval IO.println ("oilPourPoint " ++ toString (oilPourPoint).toBits)

def oilRho (T : Float) : Float :=
  let v2 := (T - (273.15 : Float))
  (((1020.62 : Float) - ((0.614254 : Float) * v2)) - ((0.000321 : Float) * (v2 ^ 2)))

#eval IO.println ("oilRho " ++ toString (oilRho 1.754187).toBits)
#eval IO.println ("oilRho " ++ toString (oilRho 1.422995).toBits)
#eval IO.println ("oilRho " ++ toString (oilRho 1.091803).toBits)

def check_oilRho_pos (T : Float) : Bool :=
  let v6 := (T - (273.15 : Float))
  (!((273.15 : Float) <= T) || (!(T <= (618.15 : Float)) || ((0 : Float) < (((1020.62 : Float) - ((0.614254 : Float) * v6)) - ((0.000321 : Float) * (v6 ^ 2))))))

#eval IO.println ("check_oilRho_pos " ++ toString (check_oilRho_pos 1.568035))
#eval IO.println ("check_oilRho_pos " ++ toString (check_oilRho_pos 1.236843))
#eval IO.println ("check_oilRho_pos " ++ toString (check_oilRho_pos 0.905651))

def oilStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Float :=
  let v22 := (Toil - Ta)
  (min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil)))

#eval IO.println ("oilStep " ++ toString (oilStep 1.381883 1.323334 1.264785 1.206236 1.147688 1.089139 1.030590 0.972041 0.913492 0.854944 0.796395 0.737846 0.679297).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 1.050691 0.992142 0.933593 0.875044 0.816496 0.757947 0.699398 0.640849 0.582300 0.523752 0.465203 0.406654 0.348105).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 0.719499 0.660950 0.602401 0.543852 0.485304 0.426755 0.368206 0.309657 0.251108 1.792560 1.734011 1.675462 1.616913).toBits)

def check_oilStep_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Twall : Float) (Ta : Float) (dt : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v27 := (alpha * Pin)
  let v30 := ((eps * (0.0000000567 : Float)) * Ac)
  let v32 := (Ta ^ 4)
  let v35 := (hC * Ac)
  let v36 := (T1 - Ta)
  let v53 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) < Coil) || (!((0 : Float) <= dt) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((min ToilMax (T1 + ((dt * (((v27 - ((v30 * ((T1 ^ 4) - v32)) + (v35 * v36))) - (Upipe * v36)) - (max (0 : Float) (UAx * (T1 - Twall))))) / Coil))) - (min ToilMax (T2 + ((dt * (((v27 - ((v30 * ((T2 ^ 4) - v32)) + (v35 * v53))) - (Upipe * v53)) - (max (0 : Float) (UAx * (T2 - Twall))))) / Coil))))) <= (((1 : Float) + ((dt * ((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v35) + Upipe) + UAx)) / Coil)) * (Float.abs (T1 - T2)))))))))))))))

#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.195731 1.137182 1.078633 1.020084 0.961536 0.902987 0.844438 0.785889 0.727340 0.668792 0.610243 0.551694 0.493145 0.434596 0.376048))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.864539 0.805990 0.747441 0.688892 0.630344 0.571795 0.513246 0.454697 0.396148 0.337600 0.279051 0.220502 1.761953 1.703404 1.644856))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.533347 0.474798 0.416249 0.357700 0.299152 0.240603 1.782054 1.723505 1.664956 1.606408 1.547859 1.489310 1.430761 1.372212 1.313664))

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

def pipeArea (D : Float) : Float :=
  (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))

#eval IO.println ("pipeArea " ++ toString (pipeArea 0.637275).toBits)
#eval IO.println ("pipeArea " ++ toString (pipeArea 0.306083).toBits)
#eval IO.println ("pipeArea " ++ toString (pipeArea 1.574891).toBits)

def check_pipeArea_pos (D : Float) : Bool :=
  (!((0 : Float) < D) || ((0 : Float) < (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))))

#eval IO.println ("check_pipeArea_pos " ++ toString (check_pipeArea_pos 0.451123))
#eval IO.println ("check_pipeArea_pos " ++ toString (check_pipeArea_pos 1.719931))
#eval IO.println ("check_pipeArea_pos " ++ toString (check_pipeArea_pos 1.388739))

def pipeGreen (Upipe : Float) (mcp : Float) : Float :=
  (Float.exp ((-Upipe) / mcp))

#eval IO.println ("pipeGreen " ++ toString (pipeGreen 0.264971 0.206422).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.533779 1.475230).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.202587 1.144038).toBits)

def check_pipeGreen_le_one (Upipe : Float) (mcp : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || ((Float.exp ((-Upipe) / mcp)) <= (1 : Float))))

#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.678819 1.620270))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.347627 1.289078))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.016435 0.957886))

def check_pipeGreen_pos (Upipe : Float) (mcp : Float) : Bool :=
  ((0 : Float) < (Float.exp ((-Upipe) / mcp)))

#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.492667 1.434118))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.161475 1.102926))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 0.830283 0.771734))

def check_pipeGreen_semigroup (U1 : Float) (U2 : Float) (mcp : Float) : Bool :=
  (feq (Float.exp ((-(U1 + U2)) / mcp)) ((Float.exp ((-U1) / mcp)) * (Float.exp ((-U2) / mcp))))

#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 1.306515 1.247966 1.189417))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 0.975323 0.916774 0.858225))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 0.644131 0.585582 0.527033))

def check_play_budget (f : Float) (eps : Float) (h : Float) (delta : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.120363 1.061814 1.003265 0.944716))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.789171 0.730622 0.672073 0.613524))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.457979 0.399430 0.340881 0.282332))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.934211))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.603019))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 0.271827))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 0.748059 0.689510 0.630961 0.572412 0.513864 0.455315 0.396766 0.338217 0.279668).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.416867 0.358318 0.299769 0.241220 1.782672 1.724123 1.665574 1.607025 1.548476).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 1.685675 1.627126 1.568577 1.510028 1.451480 1.392931 1.334382 1.275833 1.217284).map Float.toBits))

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

#eval IO.println ("pointingError " ++ toString (pointingError 0.561907 0.503358 0.444809 0.386260).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.230715 1.772166 1.713617 1.655068).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 1.499523 1.440974 1.382425 1.323876).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 0.375755 0.317206 0.258657 0.200108 1.741560 1.683011 1.624462 1.565913 1.507364 1.448816 1.390267 1.331718 1.273169).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.644563 1.586014 1.527465 1.468916 1.410368 1.351819 1.293270 1.234721 1.176172 1.117624 1.059075 1.000526 0.941977).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 1.313371 1.254822 1.196273 1.137724 1.079176 1.020627 0.962078 0.903529 0.844980 0.786432 0.727883 0.669334 0.610785).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.789603 1.731054 1.672505 1.613956 1.555408 1.496859 1.438310 1.379761 1.321212 1.262664 1.204115 1.145566))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.458411 1.399862 1.341313 1.282764 1.224216 1.165667 1.107118 1.048569 0.990020 0.931472 0.872923 0.814374))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 1.127219 1.068670 1.010121 0.951572 0.893024 0.834475 0.775926 0.717377 0.658828 0.600280 0.541731 0.483182))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.603451 1.544902 1.486353 1.427804 1.369256 1.310707 1.252158 1.193609 1.135060 1.076512 1.017963 0.959414))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.272259 1.213710 1.155161 1.096612 1.038064 0.979515 0.920966 0.862417 0.803868 0.745320 0.686771 0.628222))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.941067 0.882518 0.823969 0.765420 0.706872 0.648323 0.589774 0.531225 0.472676 0.414128 0.355579 0.297030))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.417299 1.358750 1.300201 1.241652 1.183104 1.124555 1.066006 1.007457 0.948908 0.890360 0.831811 0.773262))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.086107 1.027558 0.969009 0.910460 0.851912 0.793363 0.734814 0.676265 0.617716 0.559168 0.500619 0.442070))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.754915 0.696366 0.637817 0.579268 0.520720 0.462171 0.403622 0.345073 0.286524 0.227976 1.769427 1.710878))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.231147 1.172598 1.114049 1.055500 0.996952 0.938403 0.879854 0.821305 0.762756 0.704208 0.645659 0.587110 0.528561))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.899955 0.841406 0.782857 0.724308 0.665760 0.607211 0.548662 0.490113 0.431564 0.373016 0.314467 0.255918 1.797369))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.568763 0.510214 0.451665 0.393116 0.334568 0.276019 0.217470 1.758921 1.700372 1.641824 1.583275 1.524726 1.466177))

def check_pow4_lipschitz (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((T1 ^ 4) - (T2 ^ 4))) <= (((4 : Float) * (M ^ 3)) * (Float.abs (T1 - T2))))))))

#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.044995 0.986446 0.927897))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.713803 0.655254 0.596705))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 0.382611 0.324062 0.265513))

def prandtl (T : Float) : Float :=
  let v3 := (T - (273.15 : Float))
  let v17 := (v3 ^ 2)
  ((((Float.exp (((586.375 : Float) / (v3 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float)) * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v3)) + ((0.0000008970757 : Float) * v17)))) / (((0.118294 : Float) - ((0.000033 : Float) * v3)) - ((0.00000015 : Float) * v17)))

#eval IO.println ("prandtl " ++ toString (prandtl 0.858843).toBits)
#eval IO.println ("prandtl " ++ toString (prandtl 0.527651).toBits)
#eval IO.println ("prandtl " ++ toString (prandtl 1.796459).toBits)

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

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.969627 0.911078 0.852529))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.638435 0.579886 0.521337))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 0.307243 0.248694 1.790145))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.783475))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.452283))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.721091))

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

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.638867 1.580318))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.307675 1.249126))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.976483 0.917934))

def prop_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.452715 1.394166 1.335617))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.121523 1.062974 1.004425))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.790331 0.731782 0.673233))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.266563))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.935371))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.604179))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.080411 1.021862))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.749219 0.690670))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.418027 0.359478))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.894259 0.835710))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.563067 0.504518))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.231875 1.773326))

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

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.708107 0.649558 0.591009 0.532460 0.473912 0.415363 0.356814 0.298265 0.239716 1.781168 1.722619 1.664070))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.376915 0.318366 0.259817 0.201268 1.742720 1.684171 1.625622 1.567073 1.508524 1.449976 1.391427 1.332878))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.645723 1.587174 1.528625 1.470076 1.411528 1.352979 1.294430 1.235881 1.177332 1.118784 1.060235 1.001686))

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

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.563499 1.504950 1.446401))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.232307 1.173758 1.115209))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.901115 0.842566 0.784017))

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

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.005043 0.946494 0.887945 0.829396 0.770848 0.712299 0.653750 0.595201 0.536652 0.478104 0.419555 0.361006 0.302457))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.673851 0.615302 0.556753 0.498204 0.439656 0.381107 0.322558 0.264009 0.205460 1.746912 1.688363 1.629814 1.571265))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 0.342659 0.284110 0.225561 1.767012 1.708464 1.649915 1.591366 1.532817 1.474268 1.415720 1.357171 1.298622 1.240073))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.818891 0.760342 0.701793 0.643244 0.584696 0.526147 0.467598 0.409049 0.350500 0.291952 0.233403 1.774854 1.716305))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.487699 0.429150 0.370601 0.312052 0.253504 1.794955 1.736406 1.677857 1.619308 1.560760 1.502211 1.443662 1.385113))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.756507 1.697958 1.639409 1.580860 1.522312 1.463763 1.405214 1.346665 1.288116 1.229568 1.171019 1.112470 1.053921))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.632739 0.574190 0.515641 0.457092 0.398544))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.301547 0.242998 1.784449 1.725900 1.667352))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.570355 1.511806 1.453257 1.394708 1.336160))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.446587 0.388038 0.329489))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.715395 1.656846 1.598297))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.384203 1.325654 1.267105))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.260435))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.529243))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.198051))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.674283 1.615734 1.557185))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.343091 1.284542 1.225993))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.011899 0.953350 0.894801))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.488131 1.429582 1.371033))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.156939 1.098390 1.039841))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.825747 0.767198 0.708649))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.301979 1.243430 1.184881 1.126332))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.970787 0.912238 0.853689 0.795140))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.639595 0.581046 0.522497 0.463948))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.115827 1.057278 0.998729))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.784635 0.726086 0.667537))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.453443 0.394894 0.336345))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.929675 0.871126 0.812577 0.754028 0.695480))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.598483 0.539934 0.481385 0.422836 0.364288))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 0.267291 0.208742 1.750193 1.691644 1.633096))

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

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.743523 0.684974 0.626425 0.567876 0.509328))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.412331 0.353782 0.295233 0.236684 1.778136))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.681139 1.622590 1.564041 1.505492 1.446944))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.557371 0.498822 0.440273 0.381724 0.323176))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.226179 1.767630 1.709081 1.650532 1.591984))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.494987 1.436438 1.377889 1.319340 1.260792))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.371219 0.312670 0.254121 1.795572))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.640027 1.581478 1.522929 1.464380))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.308835 1.250286 1.191737 1.133188))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.598915 1.540366 1.481817))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.267723 1.209174 1.150625))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.936531 0.877982 0.819433))

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

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.412763 1.354214 1.295665 1.237116 1.178568 1.120019 1.061470 1.002921 0.944372 0.885824 0.827275 0.768726))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.081571 1.023022 0.964473 0.905924 0.847376 0.788827 0.730278 0.671729 0.613180 0.554632 0.496083 0.437534))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.750379 0.691830 0.633281 0.574732 0.516184 0.457635 0.399086 0.340537 0.281988 0.223440 1.764891 1.706342))

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

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.226611 1.168062 1.109513 1.050964 0.992416 0.933867 0.875318 0.816769 0.758220 0.699672 0.641123 0.582574))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.895419 0.836870 0.778321 0.719772 0.661224 0.602675 0.544126 0.485577 0.427028 0.368480 0.309931 0.251382))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.564227 0.505678 0.447129 0.388580 0.330032 0.271483 0.212934 1.754385 1.695836 1.637288 1.578739 1.520190))

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

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.040459 0.981910 0.923361 0.864812 0.806264 0.747715 0.689166 0.630617 0.572068 0.513520 0.454971 0.396422))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.709267 0.650718 0.592169 0.533620 0.475072 0.416523 0.357974 0.299425 0.240876 1.782328 1.723779 1.665230))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 0.378075 0.319526 0.260977 0.202428 1.743880 1.685331 1.626782 1.568233 1.509684 1.451136 1.392587 1.334038))

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

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.151243 1.092694 1.034145 0.975596 0.917048 0.858499 0.799950 0.741401))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.820051 0.761502 0.702953 0.644404 0.585856 0.527307 0.468758 0.410209))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.488859 0.430310 0.371761 0.313212 0.254664 1.796115 1.737566 1.679017))

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

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.965091 0.906542 0.847993 0.789444 0.730896 0.672347 0.613798 0.555249 0.496700))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.633899 0.575350 0.516801 0.458252 0.399704 0.341155 0.282606 0.224057 1.765508))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 0.302707 0.244158 1.785609 1.727060 1.668512 1.609963 1.551414 1.492865 1.434316))

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

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.778939 0.720390 0.661841))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.447747 0.389198 0.330649))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.716555 1.658006 1.599457))

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

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.220483))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.489291))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 1.158099))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.448179))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.116987))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.785795))

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

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.889723 0.831174 0.772625 0.714076 0.655528 0.596979))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.558531 0.499982 0.441433 0.382884 0.324336 0.265787))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.227339 1.768790 1.710241 1.651692 1.593144 1.534595))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.703571 0.645022 0.586473 0.527924 0.469376 0.410827))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.372379 0.313830 0.255281 1.796732 1.738184 1.679635))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.641187 1.582638 1.524089 1.465540 1.406992 1.348443))

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

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.745115 1.686566 1.628017 1.569468))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.413923 1.355374 1.296825 1.238276))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 1.082731 1.024182 0.965633 0.907084))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.558963))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.227771))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.896579))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.372811 1.314262 1.255713 1.197164 1.138616 1.080067 1.021518 0.962969 0.904420 0.845872 0.787323 0.728774))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.041619 0.983070 0.924521 0.865972 0.807424 0.748875 0.690326 0.631777 0.573228 0.514680 0.456131 0.397582))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.710427 0.651878 0.593329 0.534780 0.476232 0.417683 0.359134 0.300585 0.242036 1.783488 1.724939 1.666390))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.186659 1.128110 1.069561 1.011012 0.952464 0.893915 0.835366 0.776817 0.718268 0.659720 0.601171 0.542622))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.855467 0.796918 0.738369 0.679820 0.621272 0.562723 0.504174 0.445625 0.387076 0.328528 0.269979 0.211430))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.524275 0.465726 0.407177 0.348628 0.290080 0.231531 1.772982 1.714433 1.655884 1.597336 1.538787 1.480238))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.000507 0.941958 0.883409 0.824860 0.766312 0.707763 0.649214 0.590665 0.532116 0.473568 0.415019 0.356470))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.669315 0.610766 0.552217 0.493668 0.435120 0.376571 0.318022 0.259473 0.200924 1.742376 1.683827 1.625278))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 0.338123 0.279574 0.221025 1.762476 1.703928 1.645379 1.586830 1.528281 1.469732 1.411184 1.352635 1.294086))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.814355 0.755806 0.697257 0.638708 0.580160 0.521611 0.463062 0.404513 0.345964 0.287416 0.228867 1.770318 1.711769))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.483163 0.424614 0.366065 0.307516 0.248968 1.790419 1.731870 1.673321 1.614772 1.556224 1.497675 1.439126 1.380577))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.751971 1.693422 1.634873 1.576324 1.517776 1.459227 1.400678 1.342129 1.283580 1.225032 1.166483 1.107934 1.049385))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.442051 0.383502 0.324953 0.266404))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.710859 1.652310 1.593761 1.535212))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.379667 1.321118 1.262569 1.204020))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.669747 1.611198 1.552649))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.338555 1.280006 1.221457))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.007363 0.948814 0.890265))

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

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.925139 0.866590 0.808041 0.749492 0.690944 0.632395))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.593947 0.535398 0.476849 0.418300 0.359752 0.301203))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 0.262755 0.204206 1.745657 1.687108 1.628560 1.570011))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.738987 0.680438 0.621889 0.563340 0.504792 0.446243))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.407795 0.349246 0.290697 0.232148 1.773600 1.715051))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.676603 1.618054 1.559505 1.500956 1.442408 1.383859))

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

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.366683 0.308134 0.249585 1.791036 1.732488 1.673939 1.615390))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.635491 1.576942 1.518393 1.459844 1.401296 1.342747 1.284198))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.304299 1.245750 1.187201 1.128652 1.070104 1.011555 0.953006))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.780531 1.721982))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.449339 1.390790))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 1.118147 1.059598))

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

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.222075 1.163526))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.890883 0.832334))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.559691 0.501142))

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

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.035923 0.977374 0.918825 0.860276 0.801728 0.743179 0.684630 0.626081 0.567532))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.704731 0.646182 0.587633 0.529084 0.470536 0.411987 0.353438 0.294889 0.236340))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 0.373539 0.314990 0.256441 1.797892 1.739344 1.680795 1.622246 1.563697 1.505148))

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

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.849771 0.791222 0.732673))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.518579 0.460030 0.401481))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.787387 1.728838 1.670289))

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

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.705163 1.646614 1.588065 1.529516))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.373971 1.315422 1.256873 1.198324))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.042779 0.984230 0.925681 0.867132))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.519011 1.460462 1.401913 1.343364 1.284816))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.187819 1.129270 1.070721 1.012172 0.953624))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.856627 0.798078 0.739529 0.680980 0.622432))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.146707 1.088158 1.029609))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.815515 0.756966 0.698417))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.484323 0.425774 0.367225))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.774403 0.715854 0.657305 0.598756 0.540208 0.481659 0.423110 0.364561 0.306012 0.247464))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.443211 0.384662 0.326113 0.267564 0.209016 1.750467 1.691918 1.633369 1.574820 1.516272))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.712019 1.653470 1.594921 1.536372 1.477824 1.419275 1.360726 1.302177 1.243628 1.185080))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.588251 0.529702 0.471153))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.257059 1.798510 1.739961))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.525867 1.467318 1.408769))

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

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.402099 0.343550 0.285001 0.226452 1.767904))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.670907 1.612358 1.553809 1.495260 1.436712))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.339715 1.281166 1.222617 1.164068 1.105520))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.215947 1.757398 1.698849 1.640300 1.581752))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.484755 1.426206 1.367657 1.309108 1.250560))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 1.153563 1.095014 1.036465 0.977916 0.919368))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.629795))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.298603))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.967411))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.443643 1.385094 1.326545 1.267996))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.112451 1.053902 0.995353 0.936804))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.781259 0.722710 0.664161 0.605612))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.257491 1.198942 1.140393 1.081844 1.023296))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.926299 0.867750 0.809201 0.750652 0.692104))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.595107 0.536558 0.478009 0.419460 0.360912))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.071339 1.012790 0.954241 0.895692 0.837144))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.740147 0.681598 0.623049 0.564500 0.505952))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.408955 0.350406 0.291857 0.233308 1.774760))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.885187 0.826638 0.768089))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.553995 0.495446 0.436897))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.222803 1.764254 1.705705))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.699035))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.367843))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.636651))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.512883 0.454334 0.395785 0.337236))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.781691 1.723142 1.664593 1.606044))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.450499 1.391950 1.333401 1.274852))

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

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.740579 1.682030 1.623481 1.564932 1.506384))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.409387 1.350838 1.292289 1.233740 1.175192))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 1.078195 1.019646 0.961097 0.902548 0.844000))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.554427 1.495878 1.437329 1.378780))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.223235 1.164686 1.106137 1.047588))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.892043 0.833494 0.774945 0.716396))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.368275 1.309726 1.251177 1.192628))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.037083 0.978534 0.919985 0.861436))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.705891 0.647342 0.588793 0.530244))

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

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.809819 0.751270 0.692721 0.634172 0.575624 0.517075 0.458526 0.399977))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.478627 0.420078 0.361529 0.302980 0.244432 1.785883 1.727334 1.668785))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.747435 1.688886 1.630337 1.571788 1.513240 1.454691 1.396142 1.337593))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.437515 0.378966 0.320417 0.261868))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.706323 1.647774 1.589225 1.530676))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.375131 1.316582 1.258033 1.199484))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.251363 1.792814 1.734265))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.520171 1.461622 1.403073))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 1.188979 1.130430 1.071881))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.479059 1.420510).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.147867 1.089318).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.816675 0.758126).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def pumpCmd (u : Float) : Float :=
  (min (max ((u + (1 : Float)) / (2 : Float)) (0 : Float)) (1 : Float))

#eval IO.println ("pumpCmd " ++ toString (pumpCmd 1.106755).toBits)
#eval IO.println ("pumpCmd " ++ toString (pumpCmd 0.775563).toBits)
#eval IO.println ("pumpCmd " ++ toString (pumpCmd 0.444371).toBits)

def check_pumpCmd_mem (u : Float) : Bool :=
  let v7 := (min (max ((u + (1 : Float)) / (2 : Float)) (0 : Float)) (1 : Float))
  (((0 : Float) <= v7) && (v7 <= (1 : Float)))

#eval IO.println ("check_pumpCmd_mem " ++ toString (check_pumpCmd_mem 0.920603))
#eval IO.println ("check_pumpCmd_mem " ++ toString (check_pumpCmd_mem 0.589411))
#eval IO.println ("check_pumpCmd_mem " ++ toString (check_pumpCmd_mem 0.258219))

def pumpCostRaw (dt : Float) (pPump : Float) (pumpPrice : Float) (rotiReward : Float) (rotiEnergy : Float) : Float :=
  ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))

#eval IO.println ("pumpCostRaw " ++ toString (pumpCostRaw 0.734451 0.675902 0.617353 0.558804 0.500256).toBits)
#eval IO.println ("pumpCostRaw " ++ toString (pumpCostRaw 0.403259 0.344710 0.286161 0.227612 1.769064).toBits)
#eval IO.println ("pumpCostRaw " ++ toString (pumpCostRaw 1.672067 1.613518 1.554969 1.496420 1.437872).toBits)

def check_pumpCostRaw_nonneg (dt : Float) (pPump : Float) (pumpPrice : Float) (rotiReward : Float) (rotiEnergy : Float) : Bool :=
  (!((0 : Float) <= dt) || (!((0 : Float) <= pumpPrice) || (!((0 : Float) <= rotiReward) || (!((0 : Float) <= rotiEnergy) || ((0 : Float) <= ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump)))))))

#eval IO.println ("check_pumpCostRaw_nonneg " ++ toString (check_pumpCostRaw_nonneg 0.548299 0.489750 0.431201 0.372652 0.314104))
#eval IO.println ("check_pumpCostRaw_nonneg " ++ toString (check_pumpCostRaw_nonneg 0.217107 1.758558 1.700009 1.641460 1.582912))
#eval IO.println ("check_pumpCostRaw_nonneg " ++ toString (check_pumpCostRaw_nonneg 1.485915 1.427366 1.368817 1.310268 1.251720))

def pumpElec (Q : Float) (D : Float) (L : Float) (T : Float) (eta : Float) (Pidle : Float) : Float :=
  let v7 := (D ^ 2)
  let v11 := (Q / (((3.141592653589793 : Float) * v7) / (4 : Float)))
  let v13 := (T - (273.15 : Float))
  let v21 := (((1020.62 : Float) - ((0.614254 : Float) * v13)) - ((0.000321 : Float) * (v13 ^ 2)))
  let v32 := ((Float.exp (((586.375 : Float) / (v13 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v33 := (((v21 * v11) * D) / v32)
  ((((if (v33 < (2300 : Float)) then (((((32 : Float) * v32) * L) * v11) / v7) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt (max v33 (1 : Float))))) * (L / D)) * v21) * (v11 ^ 2)) / (2 : Float))) * Q) / eta) + (if ((0 : Float) < Q) then Pidle else (0 : Float)))

#eval IO.println ("pumpElec " ++ toString (pumpElec 0.362147 0.303598 0.245049 1.786500 1.727952 1.669403).toBits)
#eval IO.println ("pumpElec " ++ toString (pumpElec 1.630955 1.572406 1.513857 1.455308 1.396760 1.338211).toBits)
#eval IO.println ("pumpElec " ++ toString (pumpElec 1.299763 1.241214 1.182665 1.124116 1.065568 1.007019).toBits)

def pumpHyd (Q : Float) (D : Float) (L : Float) (T : Float) : Float :=
  let v5 := (D ^ 2)
  let v9 := (Q / (((3.141592653589793 : Float) * v5) / (4 : Float)))
  let v11 := (T - (273.15 : Float))
  let v19 := (((1020.62 : Float) - ((0.614254 : Float) * v11)) - ((0.000321 : Float) * (v11 ^ 2)))
  let v30 := ((Float.exp (((586.375 : Float) / (v11 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v31 := (((v19 * v9) * D) / v30)
  ((if (v31 < (2300 : Float)) then (((((32 : Float) * v30) * L) * v9) / v5) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt (max v31 (1 : Float))))) * (L / D)) * v19) * (v9 ^ 2)) / (2 : Float))) * Q)

#eval IO.println ("pumpHyd " ++ toString (pumpHyd 1.775995 1.717446 1.658897 1.600348).toBits)
#eval IO.println ("pumpHyd " ++ toString (pumpHyd 1.444803 1.386254 1.327705 1.269156).toBits)
#eval IO.println ("pumpHyd " ++ toString (pumpHyd 1.113611 1.055062 0.996513 0.937964).toBits)

def check_pumpLam_convex (c : Float) (Q1 : Float) (Q2 : Float) : Bool :=
  (!((0 : Float) <= c) || (!((0 : Float) <= Q1) || (!((0 : Float) <= Q2) || ((c * (((Q1 + Q2) / (2 : Float)) ^ 2)) <= (((c * (Q1 ^ 2)) + (c * (Q2 ^ 2))) / (2 : Float))))))

#eval IO.println ("check_pumpLam_convex " ++ toString (check_pumpLam_convex 1.589843 1.531294 1.472745))
#eval IO.println ("check_pumpLam_convex " ++ toString (check_pumpLam_convex 1.258651 1.200102 1.141553))
#eval IO.println ("check_pumpLam_convex " ++ toString (check_pumpLam_convex 0.927459 0.868910 0.810361))

def check_pumpLam_mono (mu : Float) (L : Float) (D : Float) (Q1 : Float) (Q2 : Float) : Bool :=
  let v13 := (((32 : Float) * mu) * L)
  let v15 := (D ^ 2)
  let v18 := (((3.141592653589793 : Float) * v15) / (4 : Float))
  (!((0 : Float) <= mu) || (!((0 : Float) <= L) || (!((0 : Float) < D) || (!((0 : Float) <= Q1) || (!(Q1 <= Q2) || ((((v13 * (Q1 / v18)) / v15) * Q1) <= (((v13 * (Q2 / v18)) / v15) * Q2)))))))

#eval IO.println ("check_pumpLam_mono " ++ toString (check_pumpLam_mono 1.403691 1.345142 1.286593 1.228044 1.169496))
#eval IO.println ("check_pumpLam_mono " ++ toString (check_pumpLam_mono 1.072499 1.013950 0.955401 0.896852 0.838304))
#eval IO.println ("check_pumpLam_mono " ++ toString (check_pumpLam_mono 0.741307 0.682758 0.624209 0.565660 0.507112))

def pumpOf  : Array Float :=
  #[(0 : Float), ((1 : Float) / (6 : Float)), ((2 : Float) / (6 : Float)), ((3 : Float) / (6 : Float)), ((4 : Float) / (6 : Float)), ((5 : Float) / (6 : Float)), (1 : Float)]

#eval IO.println ("pumpOf " ++ toString ((pumpOf).map Float.toBits))
#eval IO.println ("pumpOf " ++ toString ((pumpOf).map Float.toBits))
#eval IO.println ("pumpOf " ++ toString ((pumpOf).map Float.toBits))

def check_pumpOf_ends  : Bool :=
  ((feq (0 : Float) (0 : Float)) && (feq (1 : Float) (1 : Float)))

#eval IO.println ("check_pumpOf_ends " ++ toString (check_pumpOf_ends))
#eval IO.println ("check_pumpOf_ends " ++ toString (check_pumpOf_ends))
#eval IO.println ("check_pumpOf_ends " ++ toString (check_pumpOf_ends))

def check_pumpOf_mem  : Bool :=
  let v3 := ((1 : Float) / (6 : Float))
  let v5 := ((2 : Float) / (6 : Float))
  let v7 := ((3 : Float) / (6 : Float))
  let v9 := ((4 : Float) / (6 : Float))
  let v11 := ((5 : Float) / (6 : Float))
  let v13 := ((0 : Float) <= (1 : Float))
  ((((0 : Float) <= (0 : Float)) && v13) && ((((0 : Float) <= v3) && (v3 <= (1 : Float))) && ((((0 : Float) <= v5) && (v5 <= (1 : Float))) && ((((0 : Float) <= v7) && (v7 <= (1 : Float))) && ((((0 : Float) <= v9) && (v9 <= (1 : Float))) && ((((0 : Float) <= v11) && (v11 <= (1 : Float))) && (v13 && ((1 : Float) <= (1 : Float)))))))))

#eval IO.println ("check_pumpOf_mem " ++ toString (check_pumpOf_mem))
#eval IO.println ("check_pumpOf_mem " ++ toString (check_pumpOf_mem))
#eval IO.println ("check_pumpOf_mem " ++ toString (check_pumpOf_mem))

def qAbs (alpha : Float) (Pin : Float) : Float :=
  (alpha * Pin)

#eval IO.println ("qAbs " ++ toString (qAbs 0.659083 0.600534).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 0.327891 0.269342).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 1.596699 1.538150).toBits)

def qCoilLoss (eps : Float) (Ac : Float) (hC : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.472931 0.414382 0.355833 0.297284 0.238736).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.741739 1.683190 1.624641 1.566092 1.507544).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.410547 1.351998 1.293449 1.234900 1.176352).toBits)

def qCoilLossW (eps : Float) (Ac : Float) (V : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((((5.7 : Float) + ((3.8 : Float) * V)) * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLossW " ++ toString (qCoilLossW 0.286779 0.228230 1.769681 1.711132 1.652584).toBits)
#eval IO.println ("qCoilLossW " ++ toString (qCoilLossW 1.555587 1.497038 1.438489 1.379940 1.321392).toBits)
#eval IO.println ("qCoilLossW " ++ toString (qCoilLossW 1.224395 1.165846 1.107297 1.048748 0.990200).toBits)

def check_qCoilLossW_eq (eps : Float) (Ac : Float) (V : Float) (Toil : Float) (Ta : Float) : Bool :=
  let v19 := ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((((5.7 : Float) + ((3.8 : Float) * V)) * Ac) * (Toil - Ta)))
  (feq v19 v19)

#eval IO.println ("check_qCoilLossW_eq " ++ toString (check_qCoilLossW_eq 1.700627 1.642078 1.583529 1.524980 1.466432))
#eval IO.println ("check_qCoilLossW_eq " ++ toString (check_qCoilLossW_eq 1.369435 1.310886 1.252337 1.193788 1.135240))
#eval IO.println ("check_qCoilLossW_eq " ++ toString (check_qCoilLossW_eq 1.038243 0.979694 0.921145 0.862596 0.804048))

def qNet (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Float :=
  let v19 := (Toil - Ta)
  ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("qNet " ++ toString (qNet 1.514475 1.455926 1.397377 1.338828 1.280280 1.221731 1.163182 1.104633 1.046084 0.987536).toBits)
#eval IO.println ("qNet " ++ toString (qNet 1.183283 1.124734 1.066185 1.007636 0.949088 0.890539 0.831990 0.773441 0.714892 0.656344).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.852091 0.793542 0.734993 0.676444 0.617896 0.559347 0.500798 0.442249 0.383700 0.325152).toBits)

def check_qNet_antitone (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) <= (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.328323 1.269774 1.211225 1.152676 1.094128 1.035579 0.977030 0.918481 0.859932 0.801384 0.742835))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.997131 0.938582 0.880033 0.821484 0.762936 0.704387 0.645838 0.587289 0.528740 0.470192 0.411643))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.665939 0.607390 0.548841 0.490292 0.431744 0.373195 0.314646 0.256097 1.797548 1.739000 1.680451))

def check_qNet_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v22 := (alpha * Pin)
  let v25 := ((eps * (0.0000000567 : Float)) * Ac)
  let v27 := (Ta ^ 4)
  let v30 := (hC * Ac)
  let v31 := (T1 - Ta)
  let v44 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((((v22 - ((v25 * ((T1 ^ 4) - v27)) + (v30 * v31))) - (Upipe * v31)) - (max (0 : Float) (UAx * (T1 - Twall)))) - (((v22 - ((v25 * ((T2 ^ 4) - v27)) + (v30 * v44))) - (Upipe * v44)) - (max (0 : Float) (UAx * (T2 - Twall)))))) <= (((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v30) + Upipe) + UAx) * (Float.abs (T1 - T2)))))))))))))

#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.142171 1.083622 1.025073 0.966524 0.907976 0.849427 0.790878 0.732329 0.673780 0.615232 0.556683 0.498134))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.810979 0.752430 0.693881 0.635332 0.576784 0.518235 0.459686 0.401137 0.342588 0.284040 0.225491 1.766942))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.479787 0.421238 0.362689 0.304140 0.245592 1.787043 1.728494 1.669945 1.611396 1.552848 1.494299 1.435750))

def check_qNet_strictAnti (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 < T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) < (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.956019 0.897470 0.838921 0.780372 0.721824 0.663275 0.604726 0.546177 0.487628 0.429080 0.370531))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.624827 0.566278 0.507729 0.449180 0.390632 0.332083 0.273534 0.214985 1.756436 1.697888 1.639339))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 0.293635 0.235086 1.776537 1.717988 1.659440 1.600891 1.542342 1.483793 1.425244 1.366696 1.308147))

def qPipe (Upipe : Float) (Toil : Float) (Ta : Float) : Float :=
  (Upipe * (Toil - Ta))

#eval IO.println ("qPipe " ++ toString (qPipe 0.769867 0.711318 0.652769).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 0.438675 0.380126 0.321577).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.707483 1.648934 1.590385).toBits)

def qPot (UAx : Float) (Toil : Float) (Twall : Float) : Float :=
  (max (0 : Float) (UAx * (Toil - Twall)))

#eval IO.println ("qPot " ++ toString (qPot 0.583715 0.525166 0.466617).toBits)
#eval IO.println ("qPot " ++ toString (qPot 0.252523 1.793974 1.735425).toBits)
#eval IO.println ("qPot " ++ toString (qPot 1.521331 1.462782 1.404233).toBits)

def check_qPot_le (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  let v5 := (Toil - Twall)
  (!((0 : Float) <= UAx) || ((max (0 : Float) (UAx * v5)) <= (UAx * (max (0 : Float) v5))))

#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.397563 0.339014 0.280465))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.666371 1.607822 1.549273))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.335179 1.276630 1.218081))

def check_qPot_nonneg (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  ((0 : Float) <= (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.211411 1.752862 1.694313))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.480219 1.421670 1.363121))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 1.149027 1.090478 1.031929))

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

def radCeil (eps : Float) (qFlux : Float) (Ta : Float) : Float :=
  (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))

#eval IO.println ("radCeil " ++ toString (radCeil 1.252955 1.194406 1.135857).toBits)
#eval IO.println ("radCeil " ++ toString (radCeil 0.921763 0.863214 0.804665).toBits)
#eval IO.println ("radCeil " ++ toString (radCeil 0.590571 0.532022 0.473473).toBits)

def check_radCeil_nonneg (eps : Float) (qFlux : Float) (Ta : Float) : Bool :=
  ((0 : Float) <= (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4)))))

#eval IO.println ("check_radCeil_nonneg " ++ toString (check_radCeil_nonneg 1.066803 1.008254 0.949705))
#eval IO.println ("check_radCeil_nonneg " ++ toString (check_radCeil_nonneg 0.735611 0.677062 0.618513))
#eval IO.println ("check_radCeil_nonneg " ++ toString (check_radCeil_nonneg 0.404419 0.345870 0.287321))

def reCrit  : Float :=
  (2300 : Float)

#eval IO.println ("reCrit " ++ toString (reCrit).toBits)
#eval IO.println ("reCrit " ++ toString (reCrit).toBits)
#eval IO.println ("reCrit " ++ toString (reCrit).toBits)

def check_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v6 := (ym * a)
  (!((0 : Float) < ze) || ((v6 <= (hp * ze)) == ((v6 / ze) <= hp)))

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.694499 0.635950 0.577401 0.518852))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.363307 0.304758 0.246209 1.787660))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.632115 1.573566 1.515017 1.456468))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 0.322195 0.263646 0.205097 1.746548 1.688000 1.629451 1.570902 1.512353 1.453804 1.395256 1.336707 1.278158).toBits)
#eval IO.println ("recip " ++ toString (recip 1.591003 1.532454 1.473905 1.415356 1.356808 1.298259 1.239710 1.181161 1.122612 1.064064 1.005515 0.946966).toBits)
#eval IO.println ("recip " ++ toString (recip 1.259811 1.201262 1.142713 1.084164 1.025616 0.967067 0.908518 0.849969 0.791420 0.732872 0.674323 0.615774).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 1.736043 1.677494 1.618945 1.560396 1.501848 1.443299).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.404851 1.346302 1.287753 1.229204 1.170656 1.112107).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 1.073659 1.015110 0.956561 0.898012 0.839464 0.780915).map Float.toBits))

def rewardShapeRaw (dt : Float) (pIn : Float) (reach : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) : Float :=
  (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)

#eval IO.println ("rewardShapeRaw " ++ toString (rewardShapeRaw 1.549891 1.491342 1.432793 1.374244 1.315696 1.257147).toBits)
#eval IO.println ("rewardShapeRaw " ++ toString (rewardShapeRaw 1.218699 1.160150 1.101601 1.043052 0.984504 0.925955).toBits)
#eval IO.println ("rewardShapeRaw " ++ toString (rewardShapeRaw 0.887507 0.828958 0.770409 0.711860 0.653312 0.594763).toBits)

def rewardStep (parentRaw : Float) (dt : Float) (pIn : Float) (reach : Float) (rewardDiv : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) (pPump : Float) (filmExcess : Float) (pumpPrice : Float) (degPrice : Float) : Array Float :=
  #[(((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach), ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump)), (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess)), (((parentRaw + (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)) - ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))) - (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))), ((((parentRaw + (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)) - ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))) - (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))) / rewardDiv)]

#eval IO.println ("rewardStep " ++ toString ((rewardStep 1.363739 1.305190 1.246641 1.188092 1.129544 1.070995 1.012446 0.953897 0.895348 0.836800 0.778251 0.719702).map Float.toBits))
#eval IO.println ("rewardStep " ++ toString ((rewardStep 1.032547 0.973998 0.915449 0.856900 0.798352 0.739803 0.681254 0.622705 0.564156 0.505608 0.447059 0.388510).map Float.toBits))
#eval IO.println ("rewardStep " ++ toString ((rewardStep 0.701355 0.642806 0.584257 0.525708 0.467160 0.408611 0.350062 0.291513 0.232964 1.774416 1.715867 1.657318).map Float.toBits))

def check_rewardStep_nonneg (dt : Float) (pIn : Float) (reach : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) (parentRaw : Float) (rewardDiv : Float) (pPump : Float) (filmExcess : Float) (pumpPrice : Float) (degPrice : Float) : Bool :=
  let v23 := (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)
  (!((0 : Float) <= dt) || (!((0 : Float) <= pIn) || (!((0 : Float) <= reach) || (!((0 : Float) <= capShaping) || (!((0 : Float) <= rotiReward) || (!((0 : Float) <= rotiEnergy) || ((0 : Float) <= v23)))))))

#eval IO.println ("check_rewardStep_nonneg " ++ toString (check_rewardStep_nonneg 1.177587 1.119038 1.060489 1.001940 0.943392 0.884843 0.826294 0.767745 0.709196 0.650648 0.592099 0.533550))
#eval IO.println ("check_rewardStep_nonneg " ++ toString (check_rewardStep_nonneg 0.846395 0.787846 0.729297 0.670748 0.612200 0.553651 0.495102 0.436553 0.378004 0.319456 0.260907 0.202358))
#eval IO.println ("check_rewardStep_nonneg " ++ toString (check_rewardStep_nonneg 0.515203 0.456654 0.398105 0.339556 0.281008 0.222459 1.763910 1.705361 1.646812 1.588264 1.529715 1.471166))

def check_rewardStep_units (parentRaw : Float) (dt : Float) (pIn : Float) (reach : Float) (rewardDiv : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) (pPump : Float) (filmExcess : Float) (pumpPrice : Float) (degPrice : Float) : Bool :=
  let v18 := (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)
  let v23 := ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))
  let v27 := (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))
  (!(!(feq rewardDiv (0 : Float))) || (feq ((((((parentRaw + v18) - v23) - v27) / rewardDiv) * rewardDiv) - parentRaw) ((v18 - v23) - v27)))

#eval IO.println ("check_rewardStep_units " ++ toString (check_rewardStep_units 0.991435 0.932886 0.874337 0.815788 0.757240 0.698691 0.640142 0.581593 0.523044 0.464496 0.405947 0.347398))
#eval IO.println ("check_rewardStep_units " ++ toString (check_rewardStep_units 0.660243 0.601694 0.543145 0.484596 0.426048 0.367499 0.308950 0.250401 1.791852 1.733304 1.674755 1.616206))
#eval IO.println ("check_rewardStep_units " ++ toString (check_rewardStep_units 0.329051 0.270502 0.211953 1.753404 1.694856 1.636307 1.577758 1.519209 1.460660 1.402112 1.343563 1.285014))

def reynolds (Q : Float) (D : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  ((((((1020.62 : Float) - ((0.614254 : Float) * v4)) - ((0.000321 : Float) * (v4 ^ 2))) * (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))) * D) / ((Float.exp (((586.375 : Float) / (v4 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float)))

#eval IO.println ("reynolds " ++ toString (reynolds 0.805283 0.746734 0.688185).toBits)
#eval IO.println ("reynolds " ++ toString (reynolds 0.474091 0.415542 0.356993).toBits)
#eval IO.println ("reynolds " ++ toString (reynolds 1.742899 1.684350 1.625801).toBits)

def check_reynolds_mono (Q1 : Float) (Q2 : Float) (D : Float) (T : Float) : Bool :=
  let v7 := (T - (273.15 : Float))
  let v15 := (((1020.62 : Float) - ((0.614254 : Float) * v7)) - ((0.000321 : Float) * (v7 ^ 2)))
  let v22 := (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))
  let v34 := ((Float.exp (((586.375 : Float) / (v7 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  (!((0 : Float) < D) || (!((0 : Float) <= v15) || (!(Q1 <= Q2) || ((((v15 * (Q1 / v22)) * D) / v34) <= (((v15 * (Q2 / v22)) * D) / v34)))))

#eval IO.println ("check_reynolds_mono " ++ toString (check_reynolds_mono 0.619131 0.560582 0.502033 0.443484))
#eval IO.println ("check_reynolds_mono " ++ toString (check_reynolds_mono 0.287939 0.229390 1.770841 1.712292))
#eval IO.println ("check_reynolds_mono " ++ toString (check_reynolds_mono 1.556747 1.498198 1.439649 1.381100))

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

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.246827 1.788278 1.729729))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.515635 1.457086 1.398537))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 1.184443 1.125894 1.067345))

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

#eval IO.println ("rollY " ++ toString ((rollY 1.288371 1.229822 1.171273).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.957179 0.898630 0.840081).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 0.625987 0.567438 0.508889).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.102219 1.043670 0.985121 0.926572 0.868024 0.809475).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.771027 0.712478 0.653929 0.595380 0.536832 0.478283).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.439835 0.381286 0.322737 0.264188 0.205640 1.747091).toBits)

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

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.543763 0.485214 0.426665 0.368116 0.309568 0.251019))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.212571 1.754022 1.695473 1.636924 1.578376 1.519827))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.481379 1.422830 1.364281 1.305732 1.247184 1.188635))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.357611 0.299062 0.240513 1.781964 1.723416 1.664867))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.626419 1.567870 1.509321 1.450772 1.392224 1.333675))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.295227 1.236678 1.178129 1.119580 1.061032 1.002483))

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

#eval IO.println ("rot " ++ toString ((rot 1.585307 1.526758 1.468209).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.254115 1.195566 1.137017).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.922923 0.864374 0.805825).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 1.399155 1.340606 1.282057 1.223508).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 1.067963 1.009414 0.950865 0.892316).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.736771 0.678222 0.619673 0.561124).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.213003 1.154454 1.095905 1.037356 0.978808 0.920259 0.861710))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.881811 0.823262 0.764713 0.706164 0.647616 0.589067 0.530518))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.550619 0.492070 0.433521 0.374972 0.316424 0.257875 1.799326))

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

#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.026851 0.968302 0.909753 0.851204 0.792656 0.734107 0.675558 0.617009 0.558460 0.499912 0.441363 0.382814).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.695659 0.637110 0.578561 0.520012 0.461464 0.402915 0.344366 0.285817 0.227268 1.768720 1.710171 1.651622).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 0.364467 0.305918 0.247369 1.788820 1.730272 1.671723 1.613174 1.554625 1.496076 1.437528 1.378979 1.320430).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 0.840699 0.782150).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.509507 0.450958).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.778315 1.719766).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.654547 0.595998))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.323355 0.264806))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.592163 1.533614))

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

#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.696091 1.637542).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.364899 1.306350).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.033707 0.975158).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.509939 1.451390))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.178747 1.120198))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.847555 0.789006))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.323787 1.265238 1.206689).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.992595 0.934046 0.875497).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.661403 0.602854 0.544305).map Float.toBits))

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

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.137635 1.079086 1.020537 0.961988 0.903440 0.844891 0.786342 0.727793 0.669244))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.806443 0.747894 0.689345 0.630796 0.572248 0.513699 0.455150 0.396601 0.338052))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.475251 0.416702 0.358153 0.299604 0.241056 1.782507 1.723958 1.665409 1.606860))

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

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.951483 0.892934 0.834385))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.620291 0.561742 0.503193))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 0.289099 0.230550 1.772001))

def secondaryMag (L : Float) (dm : Float) : Float :=
  ((L - dm) / dm)

#eval IO.println ("secondaryMag " ++ toString (secondaryMag 0.765331 0.706782).toBits)
#eval IO.println ("secondaryMag " ++ toString (secondaryMag 0.434139 0.375590).toBits)
#eval IO.println ("secondaryMag " ++ toString (secondaryMag 1.702947 1.644398).toBits)

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 0.579179 0.520630).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.247987 1.789438).toBits)
#eval IO.println ("setLength " ++ toString (setLength 1.516795 1.458246).toBits)

def shift (x : Float) (h : Array Float) : Array Float :=
  #[x, h[0]!, h[1]!, h[2]!, h[3]!, h[4]!, h[5]!, h[6]!, h[7]!, h[8]!, h[9]!, h[10]!, h[11]!, h[12]!, h[13]!, h[14]!]

#eval IO.println ("shift " ++ toString ((shift 0.393027 #[0.669643, 0.611094, 0.552545, 0.493996, 0.435448, 0.376899, 0.318350, 0.259801, 0.201252, 1.742704, 1.684155, 1.625606, 1.567057, 1.508508, 1.449960, 1.391411]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 1.661835 #[0.338451, 0.279902, 0.221353, 1.762804, 1.704256, 1.645707, 1.587158, 1.528609, 1.470060, 1.411512, 1.352963, 1.294414, 1.235865, 1.177316, 1.118768, 1.060219]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 1.330643 #[1.607259, 1.548710, 1.490161, 1.431612, 1.373064, 1.314515, 1.255966, 1.197417, 1.138868, 1.080320, 1.021771, 0.963222, 0.904673, 0.846124, 0.787576, 0.729027]).map Float.toBits))

def check_shift_head (x : Float) (h : Array Float) : Bool :=
  (feq x x)

#eval IO.println ("check_shift_head " ++ toString (check_shift_head 0.206875 #[0.483491, 0.424942, 0.366393, 0.307844, 0.249296, 1.790747, 1.732198, 1.673649, 1.615100, 1.556552, 1.498003, 1.439454, 1.380905, 1.322356, 1.263808, 1.205259]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 1.475683 #[1.752299, 1.693750, 1.635201, 1.576652, 1.518104, 1.459555, 1.401006, 1.342457, 1.283908, 1.225360, 1.166811, 1.108262, 1.049713, 0.991164, 0.932616, 0.874067]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 1.144491 #[1.421107, 1.362558, 1.304009, 1.245460, 1.186912, 1.128363, 1.069814, 1.011265, 0.952716, 0.894168, 0.835619, 0.777070, 0.718521, 0.659972, 0.601424, 0.542875]))

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

#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.876115))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.544923))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.213731))

def check_sigmoid_slope_le (x : Float) : Bool :=
  let v1 := (1.0 / (1.0 + Float.exp (-x)))
  ((v1 * ((1 : Float) - v1)) <= ((1 : Float) / (4 : Float)))

#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.689963))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.358771))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.627579))

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

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.317659 0.259110 0.200561 1.742012))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.586467 1.527918 1.469369 1.410820))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.255275 1.196726 1.138177 1.079628))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.731507 1.672958 1.614409 1.555860 1.497312))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.400315 1.341766 1.283217 1.224668 1.166120))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 1.069123 1.010574 0.952025 0.893476 0.834928))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 1.545355 1.486806 1.428257).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 1.214163 1.155614 1.097065).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.882971 0.824422 0.765873).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 1.359203 1.300654).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.028011 0.969462).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 0.696819 0.638270).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.986899 0.928350).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.655707 0.597158).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 0.324515 0.265966).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.800747 0.742198).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.469555 0.411006).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.738363 1.679814).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 0.614595 0.556046 0.497497).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 0.283403 0.224854 1.766305).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.552211 1.493662 1.435113).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.428443 0.369894).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.697251 1.638702).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.366059 1.307510).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.242291 1.783742 1.725193 1.666644 1.608096 1.549547 1.490998).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.511099 1.452550 1.394001 1.335452 1.276904 1.218355 1.159806).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 1.179907 1.121358 1.062809 1.004260 0.945712 0.887163 0.828614).map Float.toBits))

def spotTau  : Float :=
  (0.005 : Float)

#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.469987 1.411438 1.352889))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.138795 1.080246 1.021697))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.807603 0.749054 0.690505))

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

#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.097683 1.039134 0.980585 0.922036 0.863488 0.804939 0.746390 0.687841 0.629292 0.570744))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.766491 0.707942 0.649393 0.590844 0.532296 0.473747 0.415198 0.356649 0.298100 0.239552))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.435299 0.376750 0.318201 0.259652 0.201104 1.742555 1.684006 1.625457 1.566908 1.508360))

def check_steady_pot_le_abs (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v17 := (alpha * Pin)
  let v26 := (Toil - Ta)
  let v34 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= Ta) || (!(Ta <= Toil) || (!(feq (((v17 - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v26))) - (Upipe * v26)) - v34) (0 : Float)) || (v34 <= v17))))))))

#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.911531 0.852982 0.794433 0.735884 0.677336 0.618787 0.560238 0.501689 0.443140 0.384592))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.580339 0.521790 0.463241 0.404692 0.346144 0.287595 0.229046 1.770497 1.711948 1.653400))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.249147 1.790598 1.732049 1.673500 1.614952 1.556403 1.497854 1.439305 1.380756 1.322208))

def check_steady_unique (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T1 - Ta)
  let v42 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!((0 : Float) <= T2) || (!(feq (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T1 - Twall)))) (0 : Float)) || (!(feq (((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v42))) - (Upipe * v42)) - (max (0 : Float) (UAx * (T2 - Twall)))) (0 : Float)) || (feq T1 T2))))))))))

#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.725379 0.666830 0.608281 0.549732 0.491184 0.432635 0.374086 0.315537 0.256988 1.798440 1.739891))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.394187 0.335638 0.277089 0.218540 1.759992 1.701443 1.642894 1.584345 1.525796 1.467248 1.408699))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.662995 1.604446 1.545897 1.487348 1.428800 1.370251 1.311702 1.253153 1.194604 1.136056 1.077507))

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

#eval IO.println ("step " ++ toString ((step 0.539227 0.480678 0.422129 0.363580 0.305032 0.246483 1.787934 1.729385 1.670836 1.612288 1.553739 1.495190 1.436641 1.378092 1.319544 1.260995).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.208035 1.749486 1.690937 1.632388 1.573840 1.515291 1.456742 1.398193 1.339644 1.281096 1.222547 1.163998 1.105449 1.046900 0.988352 0.929803).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 1.476843 1.418294 1.359745 1.301196 1.242648 1.184099 1.125550 1.067001 1.008452 0.949904 0.891355 0.832806 0.774257 0.715708 0.657160 0.598611).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 1.766923 1.708374 1.649825 1.591276 1.532728 1.474179 1.415630 1.357081 1.298532).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 1.435731 1.377182 1.318633 1.260084 1.201536 1.142987 1.084438 1.025889 0.967340).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 1.104539 1.045990 0.987441 0.928892 0.870344 0.811795 0.753246 0.694697 0.636148).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.580771 1.522222 1.463673 1.405124 1.346576 1.288027 1.229478 1.170929 1.112380 1.053832))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.249579 1.191030 1.132481 1.073932 1.015384 0.956835 0.898286 0.839737 0.781188 0.722640))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.918387 0.859838 0.801289 0.742740 0.684192 0.625643 0.567094 0.508545 0.449996 0.391448))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 1.394619 1.336070).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.063427 1.004878).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.732235 0.673686).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.208467 1.149918 1.091369))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.877275 0.818726 0.760177))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.546083 0.487534 0.428985))

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

#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.022315 0.963766 0.905217 0.846668).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.691123 0.632574 0.574025 0.515476).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 0.359931 0.301382 0.242833 1.784284).map Float.toBits))

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

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.836163 0.777614 0.719065 0.660516 0.601968))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.504971 0.446422 0.387873 0.329324 0.270776))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.773779 1.715230 1.656681 1.598132 1.539584))

def sunRate  : Float :=
  (0.000073 : Float)

#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)

def sunReachableS (tDead : Float) (elSun : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))

#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.463859 0.405310).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.732667 1.674118).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.401475 1.342926).toBits)

def check_sunReachableS_mem (tDead : Float) (elSun : Float) : Bool :=
  let v10 := (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))
  (((0 : Float) <= v10) && (v10 <= (1 : Float)))

#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.277707 0.219158))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.546515 1.487966))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.215323 1.156774))

def check_sunReachableS_slope (tDead : Float) (e1 : Float) (e2 : Float) : Bool :=
  let v6 := (((3.141592653589793 : Float) / (2 : Float)) - tDead)
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((e1 - v6) / (0.01 : Float))))) - (1.0 / (1.0 + Float.exp (-((e2 - v6) / (0.01 : Float))))))) <= ((Float.abs (e1 - e2)) / ((4 : Float) * (0.01 : Float))))

#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.691555 1.633006 1.574457))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.360363 1.301814 1.243265))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.029171 0.970622 0.912073))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.505403 1.446854 1.388305 1.329756 1.271208).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.174211 1.115662 1.057113 0.998564 0.940016).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.843019 0.784470 0.725921 0.667372 0.608824).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.319251 1.260702 1.202153 1.143604 1.085056))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.988059 0.929510 0.870961 0.812412 0.753864))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.656867 0.598318 0.539769 0.481220 0.422672))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.133099).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.801907).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.470715).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.946947))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.615755))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 0.284563))

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

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.760795 0.702246 0.643697 0.585148 0.526600 0.468051).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.429603 0.371054 0.312505 0.253956 1.795408 1.736859).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.698411 1.639862 1.581313 1.522764 1.464216 1.405667).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.574643 0.516094).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.243451 1.784902).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.512259 1.453710).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.388491 0.329942 0.271393 0.212844).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.657299 1.598750 1.540201 1.481652).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.326107 1.267558 1.209009 1.150460).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.202339 1.743790 1.685241 1.626692).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.471147 1.412598 1.354049 1.295500).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 1.139955 1.081406 1.022857 0.964308).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.616187 1.557638 1.499089 1.440540))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.284995 1.226446 1.167897 1.109348))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.953803 0.895254 0.836705 0.778156))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.430035 1.371486 1.312937 1.254388 1.195840))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.098843 1.040294 0.981745 0.923196 0.864648))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.767651 0.709102 0.650553 0.592004 0.533456))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 1.243883 1.185334 1.126785).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 0.912691 0.854142 0.795593).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 0.581499 0.522950 0.464401).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tanh_abs_lt_one (x : Float) : Bool :=
  ((Float.abs (Float.tanh x)) < (1 : Float))

#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.871579))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.540387))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.209195))

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.685427 0.626878 0.568329 0.509780 0.451232))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.354235 0.295686 0.237137 1.778588 1.720040))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.623043 1.564494 1.505945 1.447396 1.388848))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 0.499275 0.440726 0.382177 0.323628 0.265080).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.768083 1.709534 1.650985 1.592436 1.533888).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 1.436891 1.378342 1.319793 1.261244 1.202696).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.313123).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.581931).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.250739).toBits)

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

#eval IO.println ("traceBeam " ++ toString ((traceBeam 1.726971 1.668422 1.609873 1.551324 1.492776 1.434227 1.375678 1.317129 1.258580 1.200032 1.141483 1.082934 1.024385 0.965836 0.907288 0.848739 0.790190 0.731641).map Float.toBits))
#eval IO.println ("traceBeam " ++ toString ((traceBeam 1.395779 1.337230 1.278681 1.220132 1.161584 1.103035 1.044486 0.985937 0.927388 0.868840 0.810291 0.751742 0.693193 0.634644 0.576096 0.517547 0.458998 0.400449).map Float.toBits))
#eval IO.println ("traceBeam " ++ toString ((traceBeam 1.064587 1.006038 0.947489 0.888940 0.830392 0.771843 0.713294 0.654745 0.596196 0.537648 0.479099 0.420550 0.362001 0.303452 0.244904 1.786355 1.727806 1.669257).map Float.toBits))

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

#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 1.540819 1.482270 1.423721 1.365172 1.306624 1.248075 1.189526 1.130977 1.072428 1.013880 0.955331 0.896782 0.838233 0.779684 0.721136 0.662587 0.604038 0.545489))
#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 1.209627 1.151078 1.092529 1.033980 0.975432 0.916883 0.858334 0.799785 0.741236 0.682688 0.624139 0.565590 0.507041 0.448492 0.389944 0.331395 0.272846 0.214297))
#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 0.878435 0.819886 0.761337 0.702788 0.644240 0.585691 0.527142 0.468593 0.410044 0.351496 0.292947 0.234398 1.775849 1.717300 1.658752 1.600203 1.541654 1.483105))

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

#eval IO.println ("traceConic " ++ toString ((traceConic 1.354667 1.296118 1.237569 1.179020 1.120472 1.061923 1.003374 0.944825 0.886276).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 1.023475 0.964926 0.906377 0.847828 0.789280 0.730731 0.672182 0.613633 0.555084).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 0.692283 0.633734 0.575185 0.516636 0.458088 0.399539 0.340990 0.282441 0.223892).map Float.toBits))

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

#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.168515 1.109966 1.051417 0.992868 0.934320 0.875771 0.817222 0.758673 0.700124 0.641576).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.837323 0.778774 0.720225 0.661676 0.603128 0.544579 0.486030 0.427481 0.368932 0.310384).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.506131 0.447582 0.389033 0.330484 0.271936 0.213387 1.754838 1.696289 1.637740 1.579192).map Float.toBits))

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

#eval IO.println ("traceRay " ++ toString ((traceRay 0.796211 0.737662 0.679113 0.620564 0.562016 0.503467 0.444918 0.386369 0.327820 0.269272 0.210723 1.752174).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 0.465019 0.406470 0.347921 0.289372 0.230824 1.772275 1.713726 1.655177 1.596628 1.538080 1.479531 1.420982).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.733827 1.675278 1.616729 1.558180 1.499632 1.441083 1.382534 1.323985 1.265436 1.206888 1.148339 1.089790).map Float.toBits))

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

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.610059 0.551510 0.492961 0.434412 0.375864 0.317315 0.258766 0.200217 1.741668 1.683120 1.624571 1.566022 1.507473 1.448924 1.390376 1.331827 1.273278 1.214729).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.278867 0.220318 1.761769 1.703220 1.644672 1.586123 1.527574 1.469025 1.410476 1.351928 1.293379 1.234830 1.176281 1.117732 1.059184 1.000635 0.942086 0.883537).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.547675 1.489126 1.430577 1.372028 1.313480 1.254931 1.196382 1.137833 1.079284 1.020736 0.962187 0.903638 0.845089 0.786540 0.727992 0.669443 0.610894 0.552345).map Float.toBits))

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

#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.423907 0.365358 0.306809 0.248260 1.789712 1.731163 1.672614 1.614065 1.555516 1.496968 1.438419 1.379870 1.321321).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.692715 1.634166 1.575617 1.517068 1.458520 1.399971 1.341422 1.282873 1.224324 1.165776 1.107227 1.048678 0.990129).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.361523 1.302974 1.244425 1.185876 1.127328 1.068779 1.010230 0.951681 0.893132 0.834584 0.776035 0.717486 0.658937).map Float.toBits))

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

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.237755 1.779206 1.720657 1.662108 1.603560 1.545011 1.486462 1.427913 1.369364 1.310816 1.252267 1.193718 1.135169 1.076620 1.018072 0.959523 0.900974 0.842425 0.783876).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.506563 1.448014 1.389465 1.330916 1.272368 1.213819 1.155270 1.096721 1.038172 0.979624 0.921075 0.862526 0.803977 0.745428 0.686880 0.628331 0.569782 0.511233 0.452684).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 1.175371 1.116822 1.058273 0.999724 0.941176 0.882627 0.824078 0.765529 0.706980 0.648432 0.589883 0.531334 0.472785 0.414236 0.355688 0.297139 0.238590 1.780041 1.721492).map Float.toBits))

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

#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.651603 1.593054 1.534505 1.475956 1.417408 1.358859 1.300310 1.241761).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.320411 1.261862 1.203313 1.144764 1.086216 1.027667 0.969118 0.910569).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.989219 0.930670 0.872121 0.813572 0.755024 0.696475 0.637926 0.579377).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.465451 1.406902 1.348353))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.134259 1.075710 1.017161))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.803067 0.744518 0.685969))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.279299))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.948107))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.616915))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 1.093147 1.034598 0.976049 0.917500))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.761955 0.703406 0.644857 0.586308))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.430763 0.372214 0.313665 0.255116))

def transitTime (L : Float) (Q : Float) (D : Float) : Float :=
  (L / (max (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))) (0.000001 : Float)))

#eval IO.println ("transitTime " ++ toString (transitTime 0.906995 0.848446 0.789897).toBits)
#eval IO.println ("transitTime " ++ toString (transitTime 0.575803 0.517254 0.458705).toBits)
#eval IO.println ("transitTime " ++ toString (transitTime 0.244611 1.786062 1.727513).toBits)

def tunnelThroughput  : Float :=
  ((0.94 : Float) * (0.96 : Float))

#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)
#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)
#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)

def turnLoss (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (Tin : Float) : Float :=
  let v8 := (Ac / (8 : Float))
  ((((eps * (0.0000000567 : Float)) * v8) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v8) * (Tin - Ta)))

#eval IO.println ("turnLoss " ++ toString (turnLoss 0.534691 0.476142 0.417593 0.359044 0.300496).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 0.203499 1.744950 1.686401 1.627852 1.569304).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 1.472307 1.413758 1.355209 1.296660 1.238112).toBits)

def turnOut (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Float :=
  let v12 := (Ac / (8 : Float))
  (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))

#eval IO.println ("turnOut " ++ toString (turnOut 0.348539 0.289990 0.231441 1.772892 1.714344 1.655795 1.597246 1.538697).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 1.617347 1.558798 1.500249 1.441700 1.383152 1.324603 1.266054 1.207505).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 1.286155 1.227606 1.169057 1.110508 1.051960 0.993411 0.934862 0.876313).toBits)

def check_turnOut_eq (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Bool :=
  let v12 := (Ac / (8 : Float))
  let v24 := (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))
  (feq v24 v24)

#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.762387 1.703838 1.645289 1.586740 1.528192 1.469643 1.411094 1.352545))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.431195 1.372646 1.314097 1.255548 1.197000 1.138451 1.079902 1.021353))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 1.100003 1.041454 0.982905 0.924356 0.865808 0.807259 0.748710 0.690161))

def uPipeCyl (L : Float) (Do : Float) (Dins : Float) (kIns : Float) (V : Float) : Float :=
  (L / (((Float.log (max (Dins / Do) (1.0001 : Float))) / (((2 : Float) * (3.141592653589793 : Float)) * kIns)) + ((1 : Float) / ((((5.7 : Float) + ((3.8 : Float) * V)) * (3.141592653589793 : Float)) * Dins))))

#eval IO.println ("uPipeCyl " ++ toString (uPipeCyl 1.576235 1.517686 1.459137 1.400588 1.342040).toBits)
#eval IO.println ("uPipeCyl " ++ toString (uPipeCyl 1.245043 1.186494 1.127945 1.069396 1.010848).toBits)
#eval IO.println ("uPipeCyl " ++ toString (uPipeCyl 0.913851 0.855302 0.796753 0.738204 0.679656).toBits)

def check_uPipeCyl_pos (L : Float) (Do : Float) (Dins : Float) (kIns : Float) (V : Float) : Bool :=
  (!((0 : Float) < L) || (!((0 : Float) < kIns) || (!((0 : Float) < Dins) || (!((0 : Float) <= V) || ((0 : Float) < (L / (((Float.log (max (Dins / Do) (1.0001 : Float))) / (((2 : Float) * (3.141592653589793 : Float)) * kIns)) + ((1 : Float) / ((((5.7 : Float) + ((3.8 : Float) * V)) * (3.141592653589793 : Float)) * Dins)))))))))

#eval IO.println ("check_uPipeCyl_pos " ++ toString (check_uPipeCyl_pos 1.390083 1.331534 1.272985 1.214436 1.155888))
#eval IO.println ("check_uPipeCyl_pos " ++ toString (check_uPipeCyl_pos 1.058891 1.000342 0.941793 0.883244 0.824696))
#eval IO.println ("check_uPipeCyl_pos " ++ toString (check_uPipeCyl_pos 0.727699 0.669150 0.610601 0.552052 0.493504))

def uaOf (h : Float) (A : Float) : Float :=
  (h * A)

#eval IO.println ("uaOf " ++ toString (uaOf 1.203931 1.145382).toBits)
#eval IO.println ("uaOf " ++ toString (uaOf 0.872739 0.814190).toBits)
#eval IO.println ("uaOf " ++ toString (uaOf 0.541547 0.482998).toBits)

def check_uaOf_mono (h1 : Float) (h2 : Float) (A : Float) : Bool :=
  (!((0 : Float) <= A) || (!(h1 <= h2) || ((h1 * A) <= (h2 * A))))

#eval IO.println ("check_uaOf_mono " ++ toString (check_uaOf_mono 1.017779 0.959230 0.900681))
#eval IO.println ("check_uaOf_mono " ++ toString (check_uaOf_mono 0.686587 0.628038 0.569489))
#eval IO.println ("check_uaOf_mono " ++ toString (check_uaOf_mono 0.355395 0.296846 0.238297))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 0.831627 0.773078 0.714529).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 0.500435 0.441886 0.383337).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.769243 1.710694 1.652145).map Float.toBits))

def velOf (Q : Float) (D : Float) : Float :=
  (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))

#eval IO.println ("velOf " ++ toString (velOf 0.645475 0.586926).toBits)
#eval IO.println ("velOf " ++ toString (velOf 0.314283 0.255734).toBits)
#eval IO.println ("velOf " ++ toString (velOf 1.583091 1.524542).toBits)

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 0.459323 0.400774 0.342225 0.283676 0.225128 1.766579).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.728131 1.669582 1.611033 1.552484 1.493936 1.435387).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 1.396939 1.338390 1.279841 1.221292 1.162744 1.104195).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 0.273171 0.214622 1.756073 1.697524 1.638976 1.580427).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.541979 1.483430 1.424881 1.366332 1.307784 1.249235).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 1.210787 1.152238 1.093689 1.035140 0.976592 0.918043).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 1.687019 1.628470 1.569921 1.511372 1.452824 1.394275 1.335726 1.277177 1.218628 1.160080 1.101531 1.042982 0.984433).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.355827 1.297278 1.238729 1.180180 1.121632 1.063083 1.004534 0.945985 0.887436 0.828888 0.770339 0.711790 0.653241).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.024635 0.966086 0.907537 0.848988 0.790440 0.731891 0.673342 0.614793 0.556244 0.497696 0.439147 0.380598 0.322049).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 1.500867 1.442318 1.383769 1.325220 1.266672 1.208123 1.149574 1.091025 1.032476 0.973928 0.915379 0.856830).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 1.169675 1.111126 1.052577 0.994028 0.935480 0.876931 0.818382 0.759833 0.701284 0.642736 0.584187 0.525638).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.838483 0.779934 0.721385 0.662836 0.604288 0.545739 0.487190 0.428641 0.370092 0.311544 0.252995 1.794446).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.314715 1.256166 1.197617 1.139068 1.080520 1.021971 0.963422 0.904873 0.846324 0.787776 0.729227 0.670678).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.983523 0.924974 0.866425 0.807876 0.749328 0.690779 0.632230 0.573681 0.515132 0.456584 0.398035 0.339486).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.652331 0.593782 0.535233 0.476684 0.418136 0.359587 0.301038 0.242489 1.783940 1.725392 1.666843 1.608294).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 1.128563 1.070014 1.011465 0.952916 0.894368 0.835819 0.777270 0.718721 0.660172 0.601624 0.543075 0.484526).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.797371 0.738822 0.680273 0.621724 0.563176 0.504627 0.446078 0.387529 0.328980 0.270432 0.211883 1.753334).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 0.466179 0.407630 0.349081 0.290532 0.231984 1.773435 1.714886 1.656337 1.597788 1.539240 1.480691 1.422142).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.942411 0.883862 0.825313 0.766764 0.708216 0.649667 0.591118 0.532569 0.474020 0.415472 0.356923 0.298374).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.611219 0.552670 0.494121 0.435572 0.377024 0.318475 0.259926 0.201377 1.742828 1.684280 1.625731 1.567182).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 0.280027 0.221478 1.762929 1.704380 1.645832 1.587283 1.528734 1.470185 1.411636 1.353088 1.294539 1.235990).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 0.756259 0.697710 0.639161 0.580612 0.522064 0.463515).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 0.425067 0.366518 0.307969 0.249420 1.790872 1.732323).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.693875 1.635326 1.576777 1.518228 1.459680 1.401131).map Float.toBits))

def wallTemp (Tbulk : Float) (qFlux : Float) (h : Float) (eps : Float) (Ta : Float) : Float :=
  (max Tbulk (min (Tbulk + (qFlux / h)) (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))))

#eval IO.println ("wallTemp " ++ toString (wallTemp 0.570107 0.511558 0.453009 0.394460 0.335912).toBits)
#eval IO.println ("wallTemp " ++ toString (wallTemp 0.238915 1.780366 1.721817 1.663268 1.604720).toBits)
#eval IO.println ("wallTemp " ++ toString (wallTemp 1.507723 1.449174 1.390625 1.332076 1.273528).toBits)

def check_wallTemp_ge_bulk (Tbulk : Float) (qFlux : Float) (h : Float) (eps : Float) (Ta : Float) : Bool :=
  (Tbulk <= (max Tbulk (min (Tbulk + (qFlux / h)) (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4)))))))

#eval IO.println ("check_wallTemp_ge_bulk " ++ toString (check_wallTemp_ge_bulk 0.383955 0.325406 0.266857 0.208308 1.749760))
#eval IO.println ("check_wallTemp_ge_bulk " ++ toString (check_wallTemp_ge_bulk 1.652763 1.594214 1.535665 1.477116 1.418568))
#eval IO.println ("check_wallTemp_ge_bulk " ++ toString (check_wallTemp_ge_bulk 1.321571 1.263022 1.204473 1.145924 1.087376))

def check_wallTemp_le_rad (Tbulk : Float) (qFlux : Float) (h : Float) (eps : Float) (Ta : Float) : Bool :=
  let v16 := (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))
  (!(Tbulk <= v16) || ((max Tbulk (min (Tbulk + (qFlux / h)) v16)) <= v16))

#eval IO.println ("check_wallTemp_le_rad " ++ toString (check_wallTemp_le_rad 1.797803 1.739254 1.680705 1.622156 1.563608))
#eval IO.println ("check_wallTemp_le_rad " ++ toString (check_wallTemp_le_rad 1.466611 1.408062 1.349513 1.290964 1.232416))
#eval IO.println ("check_wallTemp_le_rad " ++ toString (check_wallTemp_le_rad 1.135419 1.076870 1.018321 0.959772 0.901224))

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

#eval IO.println ("wireLen " ++ toString (wireLen 1.425499 1.366950 1.308401 1.249852 1.191304).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.094307 1.035758 0.977209 0.918660 0.860112).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 0.763115 0.704566 0.646017 0.587468 0.528920).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 1.239347 1.180798 1.122249 1.063700).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 0.908155 0.849606 0.791057 0.732508).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 0.576963 0.518414 0.459865 0.401316).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.053195 0.994646 0.936097 0.877548 0.819000))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.722003 0.663454 0.604905 0.546356 0.487808))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 0.390811 0.332262 0.273713 0.215164 1.756616))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.867043 0.808494 0.749945 0.691396))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.535851 0.477302 0.418753 0.360204))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.204659 1.746110 1.687561 1.629012))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.680891 0.622342 0.563793 0.505244))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.349699 0.291150 0.232601 1.774052))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.618507 1.559958 1.501409 1.442860))

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

#eval IO.println ("wireTension " ++ toString (wireTension 1.722435 1.663886 1.605337 1.546788).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.391243 1.332694 1.274145 1.215596).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 1.060051 1.001502 0.942953 0.884404).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.536283 1.477734 1.419185 1.360636 1.302088 1.243539 1.184990 1.126441))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.205091 1.146542 1.087993 1.029444 0.970896 0.912347 0.853798 0.795249))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.873899 0.815350 0.756801 0.698252 0.639704 0.581155 0.522606 0.464057))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.163979 1.105430 1.046881 0.988332))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.832787 0.774238 0.715689 0.657140))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.501595 0.443046 0.384497 0.325948))

def wrapRad (d : Float) : Float :=
  let v3 := ((2 : Float) * (3.141592653589793 : Float))
  (d - (v3 * (Float.floor ((d + (3.141592653589793 : Float)) / v3))))

#eval IO.println ("wrapRad " ++ toString (wrapRad 0.977827).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.646635).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 0.315443).toBits)

def check_wrapRad_mem (d : Float) : Bool :=
  let v4 := ((2 : Float) * (3.141592653589793 : Float))
  let v9 := (d - (v4 * (Float.floor ((d + (3.141592653589793 : Float)) / v4))))
  (((-(3.141592653589793 : Float)) <= v9) && (v9 < (3.141592653589793 : Float)))

#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.791675))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.460483))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 1.729291))

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.605523 0.546974 0.488425 0.429876 0.371328 0.312779).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.274331 0.215782 1.757233 1.698684 1.640136 1.581587).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.543139 1.484590 1.426041 1.367492 1.308944 1.250395).map Float.toBits))

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

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.647067 1.588518 1.529969))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.315875 1.257326 1.198777))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.984683 0.926134 0.867585))

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
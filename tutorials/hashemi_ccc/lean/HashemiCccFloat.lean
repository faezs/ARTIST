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

def frictionBlasius (Re : Float) : Float :=
  ((0.3164 : Float) / (Float.sqrt (Float.sqrt (max Re (1 : Float)))))

#eval IO.println ("frictionBlasius " ++ toString (frictionBlasius 0.238627).toBits)
#eval IO.println ("frictionBlasius " ++ toString (frictionBlasius 1.507435).toBits)
#eval IO.println ("frictionBlasius " ++ toString (frictionBlasius 1.176243).toBits)

def frictionLam (Re : Float) : Float :=
  ((64 : Float) / (max Re (0.000000001 : Float)))

#eval IO.println ("frictionLam " ++ toString (frictionLam 1.652475).toBits)
#eval IO.println ("frictionLam " ++ toString (frictionLam 1.321283).toBits)
#eval IO.println ("frictionLam " ++ toString (frictionLam 0.990091).toBits)

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

#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 1.280171 1.221622 1.163073 1.104524 1.045976 0.987427 0.928878 0.870329 0.811780 0.753232 0.694683 0.636134))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.948979 0.890430 0.831881 0.773332 0.714784 0.656235 0.597686 0.539137 0.480588 0.422040 0.363491 0.304942))
#eval IO.println ("check_grooved_reciprocal_yaw " ++ toString (check_grooved_reciprocal_yaw 0.617787 0.559238 0.500689 0.442140 0.383592 0.325043 0.266494 0.207945 1.749396 1.690848 1.632299 1.573750))

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

#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 1.094019 1.035470 0.976921 0.918372 0.859824 0.801275 0.742726 0.684177 0.625628 0.567080 0.508531 0.449982))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.762827 0.704278 0.645729 0.587180 0.528632 0.470083 0.411534 0.352985 0.294436 0.235888 1.777339 1.718790))
#eval IO.println ("check_grooved_relation_x " ++ toString (check_grooved_relation_x 0.431635 0.373086 0.314537 0.255988 1.797440 1.738891 1.680342 1.621793 1.563244 1.504696 1.446147 1.387598))

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

#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.907867 0.849318 0.790769 0.732220 0.673672 0.615123 0.556574 0.498025 0.439476 0.380928 0.322379 0.263830))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.576675 0.518126 0.459577 0.401028 0.342480 0.283931 0.225382 1.766833 1.708284 1.649736 1.591187 1.532638))
#eval IO.println ("check_grooved_relation_y " ++ toString (check_grooved_relation_y 0.245483 1.786934 1.728385 1.669836 1.611288 1.552739 1.494190 1.435641 1.377092 1.318544 1.259995 1.201446))

def hCoil (Q : Float) (D : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  let v10 := (v4 ^ 2)
  let v29 := ((Float.exp (((586.375 : Float) / (v4 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v30 := ((((((1020.62 : Float) - ((0.614254 : Float) * v4)) - ((0.000321 : Float) * v10)) * (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))) * D) / v29)
  let v58 := (((0.118294 : Float) - ((0.000033 : Float) * v4)) - ((0.00000015 : Float) * v10))
  (((if (v30 < (2300 : Float)) then (4.364 : Float) else (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max v30 (1 : Float)))))) * (Float.exp ((0.4 : Float) * (Float.log (max ((v29 * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * v10)))) / v58) (0.01 : Float))))))) * v58) / D)

#eval IO.println ("hCoil " ++ toString (hCoil 0.721715 0.663166 0.604617).toBits)
#eval IO.println ("hCoil " ++ toString (hCoil 0.390523 0.331974 0.273425).toBits)
#eval IO.println ("hCoil " ++ toString (hCoil 1.659331 1.600782 1.542233).toBits)

def hM12  : Float :=
  ((0.00175 : Float) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)
#eval IO.println ("hM12 " ++ toString (hM12).toBits)

def hWind (V : Float) : Float :=
  ((5.7 : Float) + ((3.8 : Float) * V))

#eval IO.println ("hWind " ++ toString (hWind 0.349411).toBits)
#eval IO.println ("hWind " ++ toString (hWind 1.618219).toBits)
#eval IO.println ("hWind " ++ toString (hWind 1.287027).toBits)

def check_hWind_mono (V1 : Float) (V2 : Float) : Bool :=
  (!(V1 <= V2) || (((5.7 : Float) + ((3.8 : Float) * V1)) <= ((5.7 : Float) + ((3.8 : Float) * V2))))

#eval IO.println ("check_hWind_mono " ++ toString (check_hWind_mono 1.763259 1.704710))
#eval IO.println ("check_hWind_mono " ++ toString (check_hWind_mono 1.432067 1.373518))
#eval IO.println ("check_hWind_mono " ++ toString (check_hWind_mono 1.100875 1.042326))

def check_hWind_pos (V : Float) : Bool :=
  (!((0 : Float) <= V) || ((0 : Float) < ((5.7 : Float) + ((3.8 : Float) * V))))

#eval IO.println ("check_hWind_pos " ++ toString (check_hWind_pos 1.577107))
#eval IO.println ("check_hWind_pos " ++ toString (check_hWind_pos 1.245915))
#eval IO.println ("check_hWind_pos " ++ toString (check_hWind_pos 0.914723))

def hangerLength (R : Float) (a : Float) (yr : Float) (dx : Float) : Float :=
  let v5 := (yr ^ 2)
  (Float.sqrt (((dx ^ 2) + v5) + (((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - ((Float.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2)))

#eval IO.println ("hangerLength " ++ toString (hangerLength 1.390955 1.332406 1.273857 1.215308).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 1.059763 1.001214 0.942665 0.884116).toBits)
#eval IO.println ("hangerLength " ++ toString (hangerLength 0.728571 0.670022 0.611473 0.552924).toBits)

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

#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 0.460195 0.401646 0.343097 0.284548 0.226000 1.767451 1.708902 1.650353 1.591804 1.533256 1.474707 1.416158 1.357609 1.299060 1.240512 1.181963 1.123414 1.064865 1.006316 0.947768 0.889219 0.830670 0.772121 0.713572 0.655024 0.596475 0.537926 0.479377 0.420828 0.362280 0.303731 0.245182 1.786633 1.728084 1.669536 1.610987 1.552438 1.493889 1.435340 1.376792 1.318243 1.259694 1.201145 1.142596 1.084048 1.025499 0.966950 #[0.736811, 0.678262, 0.619713, 0.561164, 0.502616, 0.444067, 0.385518, 0.326969, 0.268420, 0.209872, 1.751323, 1.692774, 1.634225, 1.575676, 1.517128, 1.458579] #[0.736811, 0.678262, 0.619713, 0.561164, 0.502616, 0.444067, 0.385518, 0.326969, 0.268420, 0.209872, 1.751323, 1.692774, 1.634225, 1.575676, 1.517128, 1.458579] #[0.736811, 0.678262, 0.619713, 0.561164, 0.502616, 0.444067, 0.385518, 0.326969, 0.268420, 0.209872, 1.751323, 1.692774, 1.634225, 1.575676, 1.517128, 1.458579, 1.400030, 1.341481, 1.282932, 1.224384, 1.165835, 1.107286, 1.048737, 0.990188, 0.931640, 0.873091, 0.814542, 0.755993, 0.697444, 0.638896, 0.580347, 0.521798, 0.463249, 0.404700, 0.346152, 0.287603, 0.229054, 1.770505, 1.711956, 1.653408, 1.594859, 1.536310, 1.477761, 1.419212, 1.360664, 1.302115, 1.243566, 1.185017, 1.126468, 1.067920, 1.009371, 0.950822, 0.892273, 0.833724, 0.775176, 0.716627, 0.658078, 0.599529, 0.540980, 0.482432, 0.423883, 0.365334, 0.306785, 0.248236, 1.789688, 1.731139, 1.672590, 1.614041, 1.555492, 1.496944, 1.438395, 1.379846, 1.321297, 1.262748, 1.204200, 1.145651, 1.087102, 1.028553, 0.970004, 0.911456, 0.852907, 0.794358, 0.735809, 0.677260, 0.618712, 0.560163, 0.501614, 0.443065, 0.384516, 0.325968, 0.267419, 0.208870, 1.750321, 1.691772, 1.633224, 1.574675, 1.516126, 1.457577, 1.399028, 1.340480, 1.281931, 1.223382, 1.164833, 1.106284, 1.047736, 0.989187, 0.930638, 0.872089, 0.813540, 0.754992, 0.696443, 0.637894, 0.579345, 0.520796, 0.462248, 0.403699, 0.345150, 0.286601, 0.228052, 1.769504, 1.710955, 1.652406, 1.593857, 1.535308, 1.476760, 1.418211, 1.359662, 1.301113, 1.242564, 1.184016, 1.125467, 1.066918, 1.008369, 0.949820, 0.891272, 0.832723, 0.774174, 0.715625, 0.657076, 0.598528, 0.539979, 0.481430, 0.422881, 0.364332, 0.305784, 0.247235, 1.788686, 1.730137, 1.671588, 1.613040, 1.554491, 1.495942, 1.437393, 1.378844, 1.320296, 1.261747, 1.203198, 1.144649, 1.086100, 1.027552, 0.969003, 0.910454, 0.851905, 0.793356, 0.734808, 0.676259, 0.617710, 0.559161, 0.500612, 0.442064, 0.383515, 0.324966, 0.266417, 0.207868, 1.749320, 1.690771, 1.632222, 1.573673, 1.515124, 1.456576, 1.398027, 1.339478, 1.280929, 1.222380, 1.163832, 1.105283, 1.046734, 0.988185, 0.929636, 0.871088, 0.812539, 0.753990, 0.695441, 0.636892, 0.578344, 0.519795, 0.461246, 0.402697, 0.344148, 0.285600, 0.227051, 1.768502, 1.709953, 1.651404, 1.592856, 1.534307, 1.475758, 1.417209, 1.358660, 1.300112, 1.241563, 1.183014, 1.124465, 1.065916, 1.007368, 0.948819, 0.890270, 0.831721, 0.773172, 0.714624, 0.656075, 0.597526, 0.538977, 0.480428, 0.421880, 0.363331, 0.304782, 0.246233, 1.787684, 1.729136, 1.670587, 1.612038, 1.553489, 1.494940, 1.436392, 1.377843, 1.319294, 1.260745, 1.202196, 1.143648, 1.085099, 1.026550, 0.968001, 0.909452, 0.850904, 0.792355, 0.733806, 0.675257, 0.616708, 0.558160, 0.499611, 0.441062, 0.382513, 0.323964, 0.265416, 0.206867, 1.748318, 1.689769, 1.631220, 1.572672, 1.514123, 1.455574, 1.397025, 1.338476, 1.279928, 1.221379, 1.162830, 1.104281, 1.045732, 0.987184, 0.928635, 0.870086, 0.811537, 0.752988, 0.694440, 0.635891, 0.577342, 0.518793, 0.460244, 0.401696, 0.343147, 0.284598, 0.226049, 1.767500, 1.708952, 1.650403, 1.591854, 1.533305, 1.474756, 1.416208, 1.357659, 1.299110, 1.240561, 1.182012, 1.123464, 1.064915, 1.006366, 0.947817, 0.889268, 0.830720, 0.772171, 0.713622, 0.655073, 0.596524, 0.537976, 0.479427, 0.420878, 0.362329, 0.303780, 0.245232, 1.786683, 1.728134, 1.669585, 1.611036, 1.552488, 1.493939, 1.435390, 1.376841, 1.318292, 1.259744, 1.201195, 1.142646, 1.084097, 1.025548, 0.967000, 0.908451, 0.849902, 0.791353, 0.732804, 0.674256, 0.615707, 0.557158, 0.498609, 0.440060, 0.381512, 0.322963, 0.264414, 0.205865, 1.747316, 1.688768, 1.630219, 1.571670, 1.513121, 1.454572, 1.396024, 1.337475, 1.278926, 1.220377, 1.161828, 1.103280, 1.044731, 0.986182, 0.927633, 0.869084, 0.810536, 0.751987, 0.693438, 0.634889, 0.576340, 0.517792, 0.459243, 0.400694, 0.342145, 0.283596, 0.225048, 1.766499, 1.707950, 1.649401, 1.590852, 1.532304, 1.473755, 1.415206, 1.356657, 1.298108, 1.239560, 1.181011, 1.122462, 1.063913, 1.005364, 0.946816, 0.888267, 0.829718, 0.771169, 0.712620, 0.654072, 0.595523, 0.536974, 0.478425, 0.419876, 0.361328, 0.302779, 0.244230, 1.785681, 1.727132, 1.668584, 1.610035, 1.551486, 1.492937, 1.434388, 1.375840, 1.317291, 1.258742, 1.200193, 1.141644, 1.083096, 1.024547, 0.965998, 0.907449, 0.848900, 0.790352, 0.731803, 0.673254, 0.614705, 0.556156, 0.497608, 0.439059, 0.380510, 0.321961, 0.263412, 0.204864, 1.746315, 1.687766, 1.629217, 1.570668, 1.512120, 1.453571, 1.395022, 1.336473, 1.277924, 1.219376, 1.160827, 1.102278, 1.043729, 0.985180, 0.926632, 0.868083, 0.809534, 0.750985, 0.692436, 0.633888, 0.575339, 0.516790, 0.458241, 0.399692, 0.341144, 0.282595, 0.224046, 1.765497, 1.706948, 1.648400, 1.589851, 1.531302, 1.472753, 1.414204, 1.355656, 1.297107, 1.238558, 1.180009, 1.121460, 1.062912, 1.004363, 0.945814, 0.887265, 0.828716, 0.770168, 0.711619, 0.653070, 0.594521, 0.535972, 0.477424, 0.418875, 0.360326, 0.301777, 0.243228, 1.784680, 1.726131, 1.667582, 1.609033, 1.550484, 1.491936, 1.433387, 1.374838, 1.316289, 1.257740, 1.199192, 1.140643, 1.082094, 1.023545, 0.964996, 0.906448, 0.847899, 0.789350, 0.730801, 0.672252, 0.613704, 0.555155, 0.496606, 0.438057, 0.379508, 0.320960, 0.262411, 0.203862, 1.745313, 1.686764, 1.628216, 1.569667, 1.511118, 1.452569, 1.394020, 1.335472, 1.276923, 1.218374, 1.159825, 1.101276, 1.042728, 0.984179, 0.925630, 0.867081, 0.808532, 0.749984, 0.691435, 0.632886, 0.574337, 0.515788, 0.457240, 0.398691, 0.340142, 0.281593, 0.223044, 1.764496, 1.705947, 1.647398, 1.588849, 1.530300, 1.471752, 1.413203, 1.354654, 1.296105, 1.237556, 1.179008, 1.120459, 1.061910, 1.003361, 0.944812, 0.886264, 0.827715, 0.769166, 0.710617, 0.652068, 0.593520, 0.534971, 0.476422, 0.417873, 0.359324, 0.300776, 0.242227, 1.783678, 1.725129, 1.666580, 1.608032, 1.549483, 1.490934, 1.432385, 1.373836, 1.315288, 1.256739, 1.198190, 1.139641, 1.081092, 1.022544, 0.963995, 0.905446, 0.846897, 0.788348, 0.729800, 0.671251, 0.612702, 0.554153, 0.495604, 0.437056, 0.378507, 0.319958, 0.261409, 0.202860, 1.744312, 1.685763, 1.627214, 1.568665, 1.510116, 1.451568, 1.393019, 1.334470, 1.275921, 1.217372, 1.158824, 1.100275, 1.041726, 0.983177, 0.924628, 0.866080, 0.807531, 0.748982, 0.690433, 0.631884, 0.573336, 0.514787, 0.456238, 0.397689, 0.339140, 0.280592, 0.222043, 1.763494, 1.704945, 1.646396, 1.587848, 1.529299, 1.470750, 1.412201, 1.353652, 1.295104, 1.236555, 1.178006, 1.119457, 1.060908, 1.002360, 0.943811, 0.885262, 0.826713, 0.768164, 0.709616, 0.651067, 0.592518, 0.533969, 0.475420, 0.416872, 0.358323, 0.299774, 0.241225, 1.782676, 1.724128]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.729003 1.670454 1.611905 1.553356 1.494808 1.436259 1.377710 1.319161 1.260612 1.202064 1.143515 1.084966 1.026417 0.967868 0.909320 0.850771 0.792222 0.733673 0.675124 0.616576 0.558027 0.499478 0.440929 0.382380 0.323832 0.265283 0.206734 1.748185 1.689636 1.631088 1.572539 1.513990 1.455441 1.396892 1.338344 1.279795 1.221246 1.162697 1.104148 1.045600 0.987051 0.928502 0.869953 0.811404 0.752856 0.694307 0.635758 #[0.405619, 0.347070, 0.288521, 0.229972, 1.771424, 1.712875, 1.654326, 1.595777, 1.537228, 1.478680, 1.420131, 1.361582, 1.303033, 1.244484, 1.185936, 1.127387] #[0.405619, 0.347070, 0.288521, 0.229972, 1.771424, 1.712875, 1.654326, 1.595777, 1.537228, 1.478680, 1.420131, 1.361582, 1.303033, 1.244484, 1.185936, 1.127387] #[0.405619, 0.347070, 0.288521, 0.229972, 1.771424, 1.712875, 1.654326, 1.595777, 1.537228, 1.478680, 1.420131, 1.361582, 1.303033, 1.244484, 1.185936, 1.127387, 1.068838, 1.010289, 0.951740, 0.893192, 0.834643, 0.776094, 0.717545, 0.658996, 0.600448, 0.541899, 0.483350, 0.424801, 0.366252, 0.307704, 0.249155, 1.790606, 1.732057, 1.673508, 1.614960, 1.556411, 1.497862, 1.439313, 1.380764, 1.322216, 1.263667, 1.205118, 1.146569, 1.088020, 1.029472, 0.970923, 0.912374, 0.853825, 0.795276, 0.736728, 0.678179, 0.619630, 0.561081, 0.502532, 0.443984, 0.385435, 0.326886, 0.268337, 0.209788, 1.751240, 1.692691, 1.634142, 1.575593, 1.517044, 1.458496, 1.399947, 1.341398, 1.282849, 1.224300, 1.165752, 1.107203, 1.048654, 0.990105, 0.931556, 0.873008, 0.814459, 0.755910, 0.697361, 0.638812, 0.580264, 0.521715, 0.463166, 0.404617, 0.346068, 0.287520, 0.228971, 1.770422, 1.711873, 1.653324, 1.594776, 1.536227, 1.477678, 1.419129, 1.360580, 1.302032, 1.243483, 1.184934, 1.126385, 1.067836, 1.009288, 0.950739, 0.892190, 0.833641, 0.775092, 0.716544, 0.657995, 0.599446, 0.540897, 0.482348, 0.423800, 0.365251, 0.306702, 0.248153, 1.789604, 1.731056, 1.672507, 1.613958, 1.555409, 1.496860, 1.438312, 1.379763, 1.321214, 1.262665, 1.204116, 1.145568, 1.087019, 1.028470, 0.969921, 0.911372, 0.852824, 0.794275, 0.735726, 0.677177, 0.618628, 0.560080, 0.501531, 0.442982, 0.384433, 0.325884, 0.267336, 0.208787, 1.750238, 1.691689, 1.633140, 1.574592, 1.516043, 1.457494, 1.398945, 1.340396, 1.281848, 1.223299, 1.164750, 1.106201, 1.047652, 0.989104, 0.930555, 0.872006, 0.813457, 0.754908, 0.696360, 0.637811, 0.579262, 0.520713, 0.462164, 0.403616, 0.345067, 0.286518, 0.227969, 1.769420, 1.710872, 1.652323, 1.593774, 1.535225, 1.476676, 1.418128, 1.359579, 1.301030, 1.242481, 1.183932, 1.125384, 1.066835, 1.008286, 0.949737, 0.891188, 0.832640, 0.774091, 0.715542, 0.656993, 0.598444, 0.539896, 0.481347, 0.422798, 0.364249, 0.305700, 0.247152, 1.788603, 1.730054, 1.671505, 1.612956, 1.554408, 1.495859, 1.437310, 1.378761, 1.320212, 1.261664, 1.203115, 1.144566, 1.086017, 1.027468, 0.968920, 0.910371, 0.851822, 0.793273, 0.734724, 0.676176, 0.617627, 0.559078, 0.500529, 0.441980, 0.383432, 0.324883, 0.266334, 0.207785, 1.749236, 1.690688, 1.632139, 1.573590, 1.515041, 1.456492, 1.397944, 1.339395, 1.280846, 1.222297, 1.163748, 1.105200, 1.046651, 0.988102, 0.929553, 0.871004, 0.812456, 0.753907, 0.695358, 0.636809, 0.578260, 0.519712, 0.461163, 0.402614, 0.344065, 0.285516, 0.226968, 1.768419, 1.709870, 1.651321, 1.592772, 1.534224, 1.475675, 1.417126, 1.358577, 1.300028, 1.241480, 1.182931, 1.124382, 1.065833, 1.007284, 0.948736, 0.890187, 0.831638, 0.773089, 0.714540, 0.655992, 0.597443, 0.538894, 0.480345, 0.421796, 0.363248, 0.304699, 0.246150, 1.787601, 1.729052, 1.670504, 1.611955, 1.553406, 1.494857, 1.436308, 1.377760, 1.319211, 1.260662, 1.202113, 1.143564, 1.085016, 1.026467, 0.967918, 0.909369, 0.850820, 0.792272, 0.733723, 0.675174, 0.616625, 0.558076, 0.499528, 0.440979, 0.382430, 0.323881, 0.265332, 0.206784, 1.748235, 1.689686, 1.631137, 1.572588, 1.514040, 1.455491, 1.396942, 1.338393, 1.279844, 1.221296, 1.162747, 1.104198, 1.045649, 0.987100, 0.928552, 0.870003, 0.811454, 0.752905, 0.694356, 0.635808, 0.577259, 0.518710, 0.460161, 0.401612, 0.343064, 0.284515, 0.225966, 1.767417, 1.708868, 1.650320, 1.591771, 1.533222, 1.474673, 1.416124, 1.357576, 1.299027, 1.240478, 1.181929, 1.123380, 1.064832, 1.006283, 0.947734, 0.889185, 0.830636, 0.772088, 0.713539, 0.654990, 0.596441, 0.537892, 0.479344, 0.420795, 0.362246, 0.303697, 0.245148, 1.786600, 1.728051, 1.669502, 1.610953, 1.552404, 1.493856, 1.435307, 1.376758, 1.318209, 1.259660, 1.201112, 1.142563, 1.084014, 1.025465, 0.966916, 0.908368, 0.849819, 0.791270, 0.732721, 0.674172, 0.615624, 0.557075, 0.498526, 0.439977, 0.381428, 0.322880, 0.264331, 0.205782, 1.747233, 1.688684, 1.630136, 1.571587, 1.513038, 1.454489, 1.395940, 1.337392, 1.278843, 1.220294, 1.161745, 1.103196, 1.044648, 0.986099, 0.927550, 0.869001, 0.810452, 0.751904, 0.693355, 0.634806, 0.576257, 0.517708, 0.459160, 0.400611, 0.342062, 0.283513, 0.224964, 1.766416, 1.707867, 1.649318, 1.590769, 1.532220, 1.473672, 1.415123, 1.356574, 1.298025, 1.239476, 1.180928, 1.122379, 1.063830, 1.005281, 0.946732, 0.888184, 0.829635, 0.771086, 0.712537, 0.653988, 0.595440, 0.536891, 0.478342, 0.419793, 0.361244, 0.302696, 0.244147, 1.785598, 1.727049, 1.668500, 1.609952, 1.551403, 1.492854, 1.434305, 1.375756, 1.317208, 1.258659, 1.200110, 1.141561, 1.083012, 1.024464, 0.965915, 0.907366, 0.848817, 0.790268, 0.731720, 0.673171, 0.614622, 0.556073, 0.497524, 0.438976, 0.380427, 0.321878, 0.263329, 0.204780, 1.746232, 1.687683, 1.629134, 1.570585, 1.512036, 1.453488, 1.394939, 1.336390, 1.277841, 1.219292, 1.160744, 1.102195, 1.043646, 0.985097, 0.926548, 0.868000, 0.809451, 0.750902, 0.692353, 0.633804, 0.575256, 0.516707, 0.458158, 0.399609, 0.341060, 0.282512, 0.223963, 1.765414, 1.706865, 1.648316, 1.589768, 1.531219, 1.472670, 1.414121, 1.355572, 1.297024, 1.238475, 1.179926, 1.121377, 1.062828, 1.004280, 0.945731, 0.887182, 0.828633, 0.770084, 0.711536, 0.652987, 0.594438, 0.535889, 0.477340, 0.418792, 0.360243, 0.301694, 0.243145, 1.784596, 1.726048, 1.667499, 1.608950, 1.550401, 1.491852, 1.433304, 1.374755, 1.316206, 1.257657, 1.199108, 1.140560, 1.082011, 1.023462, 0.964913, 0.906364, 0.847816, 0.789267, 0.730718, 0.672169, 0.613620, 0.555072, 0.496523, 0.437974, 0.379425, 0.320876, 0.262328, 0.203779, 1.745230, 1.686681, 1.628132, 1.569584, 1.511035, 1.452486, 1.393937, 1.335388, 1.276840, 1.218291, 1.159742, 1.101193, 1.042644, 0.984096, 0.925547, 0.866998, 0.808449, 0.749900, 0.691352, 0.632803, 0.574254, 0.515705, 0.457156, 0.398608, 0.340059, 0.281510, 0.222961, 1.764412, 1.705864, 1.647315, 1.588766, 1.530217, 1.471668, 1.413120, 1.354571, 1.296022, 1.237473, 1.178924, 1.120376, 1.061827, 1.003278, 0.944729, 0.886180, 0.827632, 0.769083, 0.710534, 0.651985, 0.593436, 0.534888, 0.476339, 0.417790, 0.359241, 0.300692, 0.242144, 1.783595, 1.725046, 1.666497, 1.607948, 1.549400, 1.490851, 1.432302, 1.373753, 1.315204, 1.256656, 1.198107, 1.139558, 1.081009, 1.022460, 0.963912, 0.905363, 0.846814, 0.788265, 0.729716, 0.671168, 0.612619, 0.554070, 0.495521, 0.436972, 0.378424, 0.319875, 0.261326, 0.202777, 1.744228, 1.685680, 1.627131, 1.568582, 1.510033, 1.451484, 1.392936]).map Float.toBits))
#eval IO.println ("hashemiEnv " ++ toString ((hashemiEnv 1.397811 1.339262 1.280713 1.222164 1.163616 1.105067 1.046518 0.987969 0.929420 0.870872 0.812323 0.753774 0.695225 0.636676 0.578128 0.519579 0.461030 0.402481 0.343932 0.285384 0.226835 1.768286 1.709737 1.651188 1.592640 1.534091 1.475542 1.416993 1.358444 1.299896 1.241347 1.182798 1.124249 1.065700 1.007152 0.948603 0.890054 0.831505 0.772956 0.714408 0.655859 0.597310 0.538761 0.480212 0.421664 0.363115 0.304566 #[1.674427, 1.615878, 1.557329, 1.498780, 1.440232, 1.381683, 1.323134, 1.264585, 1.206036, 1.147488, 1.088939, 1.030390, 0.971841, 0.913292, 0.854744, 0.796195] #[1.674427, 1.615878, 1.557329, 1.498780, 1.440232, 1.381683, 1.323134, 1.264585, 1.206036, 1.147488, 1.088939, 1.030390, 0.971841, 0.913292, 0.854744, 0.796195] #[1.674427, 1.615878, 1.557329, 1.498780, 1.440232, 1.381683, 1.323134, 1.264585, 1.206036, 1.147488, 1.088939, 1.030390, 0.971841, 0.913292, 0.854744, 0.796195, 0.737646, 0.679097, 0.620548, 0.562000, 0.503451, 0.444902, 0.386353, 0.327804, 0.269256, 0.210707, 1.752158, 1.693609, 1.635060, 1.576512, 1.517963, 1.459414, 1.400865, 1.342316, 1.283768, 1.225219, 1.166670, 1.108121, 1.049572, 0.991024, 0.932475, 0.873926, 0.815377, 0.756828, 0.698280, 0.639731, 0.581182, 0.522633, 0.464084, 0.405536, 0.346987, 0.288438, 0.229889, 1.771340, 1.712792, 1.654243, 1.595694, 1.537145, 1.478596, 1.420048, 1.361499, 1.302950, 1.244401, 1.185852, 1.127304, 1.068755, 1.010206, 0.951657, 0.893108, 0.834560, 0.776011, 0.717462, 0.658913, 0.600364, 0.541816, 0.483267, 0.424718, 0.366169, 0.307620, 0.249072, 1.790523, 1.731974, 1.673425, 1.614876, 1.556328, 1.497779, 1.439230, 1.380681, 1.322132, 1.263584, 1.205035, 1.146486, 1.087937, 1.029388, 0.970840, 0.912291, 0.853742, 0.795193, 0.736644, 0.678096, 0.619547, 0.560998, 0.502449, 0.443900, 0.385352, 0.326803, 0.268254, 0.209705, 1.751156, 1.692608, 1.634059, 1.575510, 1.516961, 1.458412, 1.399864, 1.341315, 1.282766, 1.224217, 1.165668, 1.107120, 1.048571, 0.990022, 0.931473, 0.872924, 0.814376, 0.755827, 0.697278, 0.638729, 0.580180, 0.521632, 0.463083, 0.404534, 0.345985, 0.287436, 0.228888, 1.770339, 1.711790, 1.653241, 1.594692, 1.536144, 1.477595, 1.419046, 1.360497, 1.301948, 1.243400, 1.184851, 1.126302, 1.067753, 1.009204, 0.950656, 0.892107, 0.833558, 0.775009, 0.716460, 0.657912, 0.599363, 0.540814, 0.482265, 0.423716, 0.365168, 0.306619, 0.248070, 1.789521, 1.730972, 1.672424, 1.613875, 1.555326, 1.496777, 1.438228, 1.379680, 1.321131, 1.262582, 1.204033, 1.145484, 1.086936, 1.028387, 0.969838, 0.911289, 0.852740, 0.794192, 0.735643, 0.677094, 0.618545, 0.559996, 0.501448, 0.442899, 0.384350, 0.325801, 0.267252, 0.208704, 1.750155, 1.691606, 1.633057, 1.574508, 1.515960, 1.457411, 1.398862, 1.340313, 1.281764, 1.223216, 1.164667, 1.106118, 1.047569, 0.989020, 0.930472, 0.871923, 0.813374, 0.754825, 0.696276, 0.637728, 0.579179, 0.520630, 0.462081, 0.403532, 0.344984, 0.286435, 0.227886, 1.769337, 1.710788, 1.652240, 1.593691, 1.535142, 1.476593, 1.418044, 1.359496, 1.300947, 1.242398, 1.183849, 1.125300, 1.066752, 1.008203, 0.949654, 0.891105, 0.832556, 0.774008, 0.715459, 0.656910, 0.598361, 0.539812, 0.481264, 0.422715, 0.364166, 0.305617, 0.247068, 1.788520, 1.729971, 1.671422, 1.612873, 1.554324, 1.495776, 1.437227, 1.378678, 1.320129, 1.261580, 1.203032, 1.144483, 1.085934, 1.027385, 0.968836, 0.910288, 0.851739, 0.793190, 0.734641, 0.676092, 0.617544, 0.558995, 0.500446, 0.441897, 0.383348, 0.324800, 0.266251, 0.207702, 1.749153, 1.690604, 1.632056, 1.573507, 1.514958, 1.456409, 1.397860, 1.339312, 1.280763, 1.222214, 1.163665, 1.105116, 1.046568, 0.988019, 0.929470, 0.870921, 0.812372, 0.753824, 0.695275, 0.636726, 0.578177, 0.519628, 0.461080, 0.402531, 0.343982, 0.285433, 0.226884, 1.768336, 1.709787, 1.651238, 1.592689, 1.534140, 1.475592, 1.417043, 1.358494, 1.299945, 1.241396, 1.182848, 1.124299, 1.065750, 1.007201, 0.948652, 0.890104, 0.831555, 0.773006, 0.714457, 0.655908, 0.597360, 0.538811, 0.480262, 0.421713, 0.363164, 0.304616, 0.246067, 1.787518, 1.728969, 1.670420, 1.611872, 1.553323, 1.494774, 1.436225, 1.377676, 1.319128, 1.260579, 1.202030, 1.143481, 1.084932, 1.026384, 0.967835, 0.909286, 0.850737, 0.792188, 0.733640, 0.675091, 0.616542, 0.557993, 0.499444, 0.440896, 0.382347, 0.323798, 0.265249, 0.206700, 1.748152, 1.689603, 1.631054, 1.572505, 1.513956, 1.455408, 1.396859, 1.338310, 1.279761, 1.221212, 1.162664, 1.104115, 1.045566, 0.987017, 0.928468, 0.869920, 0.811371, 0.752822, 0.694273, 0.635724, 0.577176, 0.518627, 0.460078, 0.401529, 0.342980, 0.284432, 0.225883, 1.767334, 1.708785, 1.650236, 1.591688, 1.533139, 1.474590, 1.416041, 1.357492, 1.298944, 1.240395, 1.181846, 1.123297, 1.064748, 1.006200, 0.947651, 0.889102, 0.830553, 0.772004, 0.713456, 0.654907, 0.596358, 0.537809, 0.479260, 0.420712, 0.362163, 0.303614, 0.245065, 1.786516, 1.727968, 1.669419, 1.610870, 1.552321, 1.493772, 1.435224, 1.376675, 1.318126, 1.259577, 1.201028, 1.142480, 1.083931, 1.025382, 0.966833, 0.908284, 0.849736, 0.791187, 0.732638, 0.674089, 0.615540, 0.556992, 0.498443, 0.439894, 0.381345, 0.322796, 0.264248, 0.205699, 1.747150, 1.688601, 1.630052, 1.571504, 1.512955, 1.454406, 1.395857, 1.337308, 1.278760, 1.220211, 1.161662, 1.103113, 1.044564, 0.986016, 0.927467, 0.868918, 0.810369, 0.751820, 0.693272, 0.634723, 0.576174, 0.517625, 0.459076, 0.400528, 0.341979, 0.283430, 0.224881, 1.766332, 1.707784, 1.649235, 1.590686, 1.532137, 1.473588, 1.415040, 1.356491, 1.297942, 1.239393, 1.180844, 1.122296, 1.063747, 1.005198, 0.946649, 0.888100, 0.829552, 0.771003, 0.712454, 0.653905, 0.595356, 0.536808, 0.478259, 0.419710, 0.361161, 0.302612, 0.244064, 1.785515, 1.726966, 1.668417, 1.609868, 1.551320, 1.492771, 1.434222, 1.375673, 1.317124, 1.258576, 1.200027, 1.141478, 1.082929, 1.024380, 0.965832, 0.907283, 0.848734, 0.790185, 0.731636, 0.673088, 0.614539, 0.555990, 0.497441, 0.438892, 0.380344, 0.321795, 0.263246, 0.204697, 1.746148, 1.687600, 1.629051, 1.570502, 1.511953, 1.453404, 1.394856, 1.336307, 1.277758, 1.219209, 1.160660, 1.102112, 1.043563, 0.985014, 0.926465, 0.867916, 0.809368, 0.750819, 0.692270, 0.633721, 0.575172, 0.516624, 0.458075, 0.399526, 0.340977, 0.282428, 0.223880, 1.765331, 1.706782, 1.648233, 1.589684, 1.531136, 1.472587, 1.414038, 1.355489, 1.296940, 1.238392, 1.179843, 1.121294, 1.062745, 1.004196, 0.945648, 0.887099, 0.828550, 0.770001, 0.711452, 0.652904, 0.594355, 0.535806, 0.477257, 0.418708, 0.360160, 0.301611, 0.243062, 1.784513, 1.725964, 1.667416, 1.608867, 1.550318, 1.491769, 1.433220, 1.374672, 1.316123, 1.257574, 1.199025, 1.140476, 1.081928, 1.023379, 0.964830, 0.906281, 0.847732, 0.789184, 0.730635, 0.672086, 0.613537, 0.554988, 0.496440, 0.437891, 0.379342, 0.320793, 0.262244, 0.203696, 1.745147, 1.686598, 1.628049, 1.569500, 1.510952, 1.452403, 1.393854, 1.335305, 1.276756, 1.218208, 1.159659, 1.101110, 1.042561, 0.984012, 0.925464, 0.866915, 0.808366, 0.749817, 0.691268, 0.632720, 0.574171, 0.515622, 0.457073, 0.398524, 0.339976, 0.281427, 0.222878, 1.764329, 1.705780, 1.647232, 1.588683, 1.530134, 1.471585, 1.413036, 1.354488, 1.295939, 1.237390, 1.178841, 1.120292, 1.061744]).map Float.toBits))

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

#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 0.274043 0.215494 1.756945 1.698396 1.639848 1.581299 1.522750 1.464201 1.405652 1.347104 1.288555 1.230006 1.171457 1.112908 1.054360 0.995811 0.937262 0.878713 0.820164 0.761616 0.703067 0.644518 0.585969 0.527420 0.468872 0.410323 0.351774 0.293225 0.234676 1.776128 1.717579 1.659030 1.600481 #[0.550659, 0.492110, 0.433561, 0.375012, 0.316464, 0.257915, 1.799366, 1.740817, 1.682268, 1.623720, 1.565171, 1.506622, 1.448073, 1.389524, 1.330976, 1.272427, 1.213878, 1.155329, 1.096780, 1.038232, 0.979683, 0.921134, 0.862585, 0.804036, 0.745488, 0.686939, 0.628390, 0.569841, 0.511292, 0.452744, 0.394195, 0.335646, 0.277097, 0.218548, 1.760000, 1.701451, 1.642902, 1.584353, 1.525804, 1.467256, 1.408707, 1.350158, 1.291609, 1.233060, 1.174512, 1.115963, 1.057414, 0.998865, 0.940316, 0.881768, 0.823219, 0.764670, 0.706121, 0.647572, 0.589024, 0.530475, 0.471926, 0.413377, 0.354828, 0.296280, 0.237731, 1.779182, 1.720633, 1.662084, 1.603536, 1.544987, 1.486438, 1.427889, 1.369340, 1.310792, 1.252243, 1.193694, 1.135145, 1.076596, 1.018048, 0.959499, 0.900950, 0.842401, 0.783852, 0.725304, 0.666755, 0.608206, 0.549657, 0.491108, 0.432560, 0.374011, 0.315462, 0.256913, 1.798364, 1.739816, 1.681267, 1.622718, 1.564169, 1.505620, 1.447072, 1.388523, 1.329974, 1.271425, 1.212876, 1.154328, 1.095779, 1.037230, 0.978681, 0.920132, 0.861584, 0.803035, 0.744486, 0.685937, 0.627388, 0.568840, 0.510291, 0.451742, 0.393193, 0.334644, 0.276096, 0.217547, 1.758998, 1.700449, 1.641900, 1.583352, 1.524803, 1.466254, 1.407705, 1.349156, 1.290608, 1.232059, 1.173510, 1.114961, 1.056412, 0.997864, 0.939315, 0.880766, 0.822217, 0.763668, 0.705120, 0.646571, 0.588022, 0.529473, 0.470924, 0.412376, 0.353827, 0.295278, 0.236729, 1.778180, 1.719632, 1.661083, 1.602534, 1.543985, 1.485436, 1.426888, 1.368339, 1.309790, 1.251241, 1.192692, 1.134144, 1.075595, 1.017046, 0.958497, 0.899948, 0.841400, 0.782851, 0.724302, 0.665753, 0.607204, 0.548656, 0.490107, 0.431558, 0.373009, 0.314460, 0.255912, 1.797363, 1.738814, 1.680265, 1.621716, 1.563168, 1.504619, 1.446070, 1.387521, 1.328972, 1.270424, 1.211875, 1.153326, 1.094777, 1.036228, 0.977680, 0.919131, 0.860582, 0.802033, 0.743484, 0.684936, 0.626387, 0.567838, 0.509289, 0.450740, 0.392192, 0.333643, 0.275094, 0.216545, 1.757996, 1.699448, 1.640899, 1.582350, 1.523801, 1.465252, 1.406704, 1.348155, 1.289606, 1.231057, 1.172508, 1.113960, 1.055411, 0.996862, 0.938313, 0.879764, 0.821216, 0.762667, 0.704118, 0.645569, 0.587020, 0.528472, 0.469923, 0.411374, 0.352825, 0.294276, 0.235728, 1.777179, 1.718630, 1.660081, 1.601532, 1.542984, 1.484435, 1.425886, 1.367337, 1.308788, 1.250240, 1.191691, 1.133142, 1.074593, 1.016044, 0.957496, 0.898947, 0.840398, 0.781849, 0.723300, 0.664752, 0.606203, 0.547654, 0.489105, 0.430556, 0.372008, 0.313459, 0.254910, 1.796361, 1.737812, 1.679264, 1.620715, 1.562166, 1.503617, 1.445068, 1.386520, 1.327971, 1.269422, 1.210873, 1.152324, 1.093776, 1.035227, 0.976678, 0.918129, 0.859580, 0.801032, 0.742483, 0.683934, 0.625385, 0.566836, 0.508288, 0.449739, 0.391190, 0.332641, 0.274092, 0.215544, 1.756995, 1.698446, 1.639897, 1.581348, 1.522800, 1.464251, 1.405702, 1.347153, 1.288604, 1.230056, 1.171507, 1.112958, 1.054409, 0.995860, 0.937312, 0.878763, 0.820214, 0.761665, 0.703116, 0.644568, 0.586019, 0.527470, 0.468921, 0.410372, 0.351824, 0.293275, 0.234726, 1.776177, 1.717628, 1.659080, 1.600531, 1.541982, 1.483433, 1.424884, 1.366336, 1.307787, 1.249238, 1.190689, 1.132140, 1.073592, 1.015043, 0.956494, 0.897945, 0.839396, 0.780848, 0.722299, 0.663750, 0.605201, 0.546652, 0.488104, 0.429555, 0.371006, 0.312457, 0.253908, 1.795360, 1.736811, 1.678262, 1.619713, 1.561164, 1.502616, 1.444067, 1.385518, 1.326969, 1.268420, 1.209872, 1.151323, 1.092774, 1.034225, 0.975676, 0.917128, 0.858579, 0.800030, 0.741481, 0.682932, 0.624384, 0.565835, 0.507286, 0.448737, 0.390188, 0.331640, 0.273091, 0.214542, 1.755993, 1.697444, 1.638896, 1.580347, 1.521798, 1.463249, 1.404700, 1.346152, 1.287603, 1.229054, 1.170505, 1.111956, 1.053408, 0.994859, 0.936310, 0.877761, 0.819212, 0.760664, 0.702115, 0.643566, 0.585017, 0.526468, 0.467920, 0.409371, 0.350822, 0.292273, 0.233724, 1.775176, 1.716627, 1.658078, 1.599529, 1.540980, 1.482432, 1.423883, 1.365334, 1.306785, 1.248236, 1.189688, 1.131139, 1.072590, 1.014041, 0.955492, 0.896944, 0.838395, 0.779846, 0.721297, 0.662748, 0.604200, 0.545651, 0.487102, 0.428553, 0.370004, 0.311456, 0.252907, 1.794358, 1.735809, 1.677260, 1.618712, 1.560163, 1.501614, 1.443065, 1.384516, 1.325968, 1.267419, 1.208870, 1.150321, 1.091772, 1.033224, 0.974675, 0.916126, 0.857577, 0.799028, 0.740480, 0.681931, 0.623382, 0.564833, 0.506284, 0.447736, 0.389187, 0.330638, 0.272089, 0.213540, 1.754992, 1.696443, 1.637894, 1.579345, 1.520796, 1.462248, 1.403699, 1.345150, 1.286601, 1.228052, 1.169504, 1.110955, 1.052406, 0.993857, 0.935308, 0.876760, 0.818211, 0.759662, 0.701113, 0.642564, 0.584016, 0.525467, 0.466918, 0.408369, 0.349820, 0.291272, 0.232723, 1.774174, 1.715625, 1.657076, 1.598528, 1.539979, 1.481430, 1.422881, 1.364332, 1.305784, 1.247235, 1.188686, 1.130137, 1.071588, 1.013040, 0.954491, 0.895942, 0.837393, 0.778844, 0.720296, 0.661747, 0.603198, 0.544649, 0.486100, 0.427552, 0.369003, 0.310454, 0.251905, 1.793356, 1.734808, 1.676259, 1.617710, 1.559161, 1.500612, 1.442064, 1.383515, 1.324966, 1.266417, 1.207868, 1.149320, 1.090771, 1.032222, 0.973673, 0.915124, 0.856576, 0.798027, 0.739478, 0.680929, 0.622380, 0.563832, 0.505283, 0.446734, 0.388185, 0.329636, 0.271088, 0.212539, 1.753990, 1.695441, 1.636892, 1.578344, 1.519795, 1.461246, 1.402697, 1.344148, 1.285600, 1.227051, 1.168502, 1.109953, 1.051404, 0.992856, 0.934307, 0.875758, 0.817209, 0.758660, 0.700112, 0.641563, 0.583014, 0.524465, 0.465916, 0.407368, 0.348819, 0.290270, 0.231721, 1.773172, 1.714624, 1.656075, 1.597526, 1.538977, 1.480428, 1.421880, 1.363331, 1.304782, 1.246233, 1.187684, 1.129136, 1.070587, 1.012038, 0.953489, 0.894940, 0.836392, 0.777843, 0.719294, 0.660745, 0.602196, 0.543648, 0.485099, 0.426550, 0.368001, 0.309452, 0.250904, 1.792355, 1.733806, 1.675257, 1.616708, 1.558160, 1.499611, 1.441062, 1.382513, 1.323964, 1.265416, 1.206867, 1.148318, 1.089769, 1.031220, 0.972672, 0.914123, 0.855574, 0.797025, 0.738476, 0.679928, 0.621379, 0.562830, 0.504281, 0.445732, 0.387184, 0.328635, 0.270086, 0.211537, 1.752988, 1.694440, 1.635891, 1.577342, 1.518793, 1.460244, 1.401696, 1.343147, 1.284598, 1.226049, 1.167500, 1.108952, 1.050403, 0.991854, 0.933305, 0.874756, 0.816208, 0.757659, 0.699110, 0.640561, 0.582012, 0.523464, 0.464915, 0.406366, 0.347817, 0.289268, 0.230720, 1.772171, 1.713622, 1.655073, 1.596524, 1.537976]).map Float.toBits))
#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 1.542851 1.484302 1.425753 1.367204 1.308656 1.250107 1.191558 1.133009 1.074460 1.015912 0.957363 0.898814 0.840265 0.781716 0.723168 0.664619 0.606070 0.547521 0.488972 0.430424 0.371875 0.313326 0.254777 1.796228 1.737680 1.679131 1.620582 1.562033 1.503484 1.444936 1.386387 1.327838 1.269289 #[0.219467, 1.760918, 1.702369, 1.643820, 1.585272, 1.526723, 1.468174, 1.409625, 1.351076, 1.292528, 1.233979, 1.175430, 1.116881, 1.058332, 0.999784, 0.941235, 0.882686, 0.824137, 0.765588, 0.707040, 0.648491, 0.589942, 0.531393, 0.472844, 0.414296, 0.355747, 0.297198, 0.238649, 1.780100, 1.721552, 1.663003, 1.604454, 1.545905, 1.487356, 1.428808, 1.370259, 1.311710, 1.253161, 1.194612, 1.136064, 1.077515, 1.018966, 0.960417, 0.901868, 0.843320, 0.784771, 0.726222, 0.667673, 0.609124, 0.550576, 0.492027, 0.433478, 0.374929, 0.316380, 0.257832, 1.799283, 1.740734, 1.682185, 1.623636, 1.565088, 1.506539, 1.447990, 1.389441, 1.330892, 1.272344, 1.213795, 1.155246, 1.096697, 1.038148, 0.979600, 0.921051, 0.862502, 0.803953, 0.745404, 0.686856, 0.628307, 0.569758, 0.511209, 0.452660, 0.394112, 0.335563, 0.277014, 0.218465, 1.759916, 1.701368, 1.642819, 1.584270, 1.525721, 1.467172, 1.408624, 1.350075, 1.291526, 1.232977, 1.174428, 1.115880, 1.057331, 0.998782, 0.940233, 0.881684, 0.823136, 0.764587, 0.706038, 0.647489, 0.588940, 0.530392, 0.471843, 0.413294, 0.354745, 0.296196, 0.237648, 1.779099, 1.720550, 1.662001, 1.603452, 1.544904, 1.486355, 1.427806, 1.369257, 1.310708, 1.252160, 1.193611, 1.135062, 1.076513, 1.017964, 0.959416, 0.900867, 0.842318, 0.783769, 0.725220, 0.666672, 0.608123, 0.549574, 0.491025, 0.432476, 0.373928, 0.315379, 0.256830, 1.798281, 1.739732, 1.681184, 1.622635, 1.564086, 1.505537, 1.446988, 1.388440, 1.329891, 1.271342, 1.212793, 1.154244, 1.095696, 1.037147, 0.978598, 0.920049, 0.861500, 0.802952, 0.744403, 0.685854, 0.627305, 0.568756, 0.510208, 0.451659, 0.393110, 0.334561, 0.276012, 0.217464, 1.758915, 1.700366, 1.641817, 1.583268, 1.524720, 1.466171, 1.407622, 1.349073, 1.290524, 1.231976, 1.173427, 1.114878, 1.056329, 0.997780, 0.939232, 0.880683, 0.822134, 0.763585, 0.705036, 0.646488, 0.587939, 0.529390, 0.470841, 0.412292, 0.353744, 0.295195, 0.236646, 1.778097, 1.719548, 1.661000, 1.602451, 1.543902, 1.485353, 1.426804, 1.368256, 1.309707, 1.251158, 1.192609, 1.134060, 1.075512, 1.016963, 0.958414, 0.899865, 0.841316, 0.782768, 0.724219, 0.665670, 0.607121, 0.548572, 0.490024, 0.431475, 0.372926, 0.314377, 0.255828, 1.797280, 1.738731, 1.680182, 1.621633, 1.563084, 1.504536, 1.445987, 1.387438, 1.328889, 1.270340, 1.211792, 1.153243, 1.094694, 1.036145, 0.977596, 0.919048, 0.860499, 0.801950, 0.743401, 0.684852, 0.626304, 0.567755, 0.509206, 0.450657, 0.392108, 0.333560, 0.275011, 0.216462, 1.757913, 1.699364, 1.640816, 1.582267, 1.523718, 1.465169, 1.406620, 1.348072, 1.289523, 1.230974, 1.172425, 1.113876, 1.055328, 0.996779, 0.938230, 0.879681, 0.821132, 0.762584, 0.704035, 0.645486, 0.586937, 0.528388, 0.469840, 0.411291, 0.352742, 0.294193, 0.235644, 1.777096, 1.718547, 1.659998, 1.601449, 1.542900, 1.484352, 1.425803, 1.367254, 1.308705, 1.250156, 1.191608, 1.133059, 1.074510, 1.015961, 0.957412, 0.898864, 0.840315, 0.781766, 0.723217, 0.664668, 0.606120, 0.547571, 0.489022, 0.430473, 0.371924, 0.313376, 0.254827, 1.796278, 1.737729, 1.679180, 1.620632, 1.562083, 1.503534, 1.444985, 1.386436, 1.327888, 1.269339, 1.210790, 1.152241, 1.093692, 1.035144, 0.976595, 0.918046, 0.859497, 0.800948, 0.742400, 0.683851, 0.625302, 0.566753, 0.508204, 0.449656, 0.391107, 0.332558, 0.274009, 0.215460, 1.756912, 1.698363, 1.639814, 1.581265, 1.522716, 1.464168, 1.405619, 1.347070, 1.288521, 1.229972, 1.171424, 1.112875, 1.054326, 0.995777, 0.937228, 0.878680, 0.820131, 0.761582, 0.703033, 0.644484, 0.585936, 0.527387, 0.468838, 0.410289, 0.351740, 0.293192, 0.234643, 1.776094, 1.717545, 1.658996, 1.600448, 1.541899, 1.483350, 1.424801, 1.366252, 1.307704, 1.249155, 1.190606, 1.132057, 1.073508, 1.014960, 0.956411, 0.897862, 0.839313, 0.780764, 0.722216, 0.663667, 0.605118, 0.546569, 0.488020, 0.429472, 0.370923, 0.312374, 0.253825, 1.795276, 1.736728, 1.678179, 1.619630, 1.561081, 1.502532, 1.443984, 1.385435, 1.326886, 1.268337, 1.209788, 1.151240, 1.092691, 1.034142, 0.975593, 0.917044, 0.858496, 0.799947, 0.741398, 0.682849, 0.624300, 0.565752, 0.507203, 0.448654, 0.390105, 0.331556, 0.273008, 0.214459, 1.755910, 1.697361, 1.638812, 1.580264, 1.521715, 1.463166, 1.404617, 1.346068, 1.287520, 1.228971, 1.170422, 1.111873, 1.053324, 0.994776, 0.936227, 0.877678, 0.819129, 0.760580, 0.702032, 0.643483, 0.584934, 0.526385, 0.467836, 0.409288, 0.350739, 0.292190, 0.233641, 1.775092, 1.716544, 1.657995, 1.599446, 1.540897, 1.482348, 1.423800, 1.365251, 1.306702, 1.248153, 1.189604, 1.131056, 1.072507, 1.013958, 0.955409, 0.896860, 0.838312, 0.779763, 0.721214, 0.662665, 0.604116, 0.545568, 0.487019, 0.428470, 0.369921, 0.311372, 0.252824, 1.794275, 1.735726, 1.677177, 1.618628, 1.560080, 1.501531, 1.442982, 1.384433, 1.325884, 1.267336, 1.208787, 1.150238, 1.091689, 1.033140, 0.974592, 0.916043, 0.857494, 0.798945, 0.740396, 0.681848, 0.623299, 0.564750, 0.506201, 0.447652, 0.389104, 0.330555, 0.272006, 0.213457, 1.754908, 1.696360, 1.637811, 1.579262, 1.520713, 1.462164, 1.403616, 1.345067, 1.286518, 1.227969, 1.169420, 1.110872, 1.052323, 0.993774, 0.935225, 0.876676, 0.818128, 0.759579, 0.701030, 0.642481, 0.583932, 0.525384, 0.466835, 0.408286, 0.349737, 0.291188, 0.232640, 1.774091, 1.715542, 1.656993, 1.598444, 1.539896, 1.481347, 1.422798, 1.364249, 1.305700, 1.247152, 1.188603, 1.130054, 1.071505, 1.012956, 0.954408, 0.895859, 0.837310, 0.778761, 0.720212, 0.661664, 0.603115, 0.544566, 0.486017, 0.427468, 0.368920, 0.310371, 0.251822, 1.793273, 1.734724, 1.676176, 1.617627, 1.559078, 1.500529, 1.441980, 1.383432, 1.324883, 1.266334, 1.207785, 1.149236, 1.090688, 1.032139, 0.973590, 0.915041, 0.856492, 0.797944, 0.739395, 0.680846, 0.622297, 0.563748, 0.505200, 0.446651, 0.388102, 0.329553, 0.271004, 0.212456, 1.753907, 1.695358, 1.636809, 1.578260, 1.519712, 1.461163, 1.402614, 1.344065, 1.285516, 1.226968, 1.168419, 1.109870, 1.051321, 0.992772, 0.934224, 0.875675, 0.817126, 0.758577, 0.700028, 0.641480, 0.582931, 0.524382, 0.465833, 0.407284, 0.348736, 0.290187, 0.231638, 1.773089, 1.714540, 1.655992, 1.597443, 1.538894, 1.480345, 1.421796, 1.363248, 1.304699, 1.246150, 1.187601, 1.129052, 1.070504, 1.011955, 0.953406, 0.894857, 0.836308, 0.777760, 0.719211, 0.660662, 0.602113, 0.543564, 0.485016, 0.426467, 0.367918, 0.309369, 0.250820, 1.792272, 1.733723, 1.675174, 1.616625, 1.558076, 1.499528, 1.440979, 1.382430, 1.323881, 1.265332, 1.206784]).map Float.toBits))
#eval IO.println ("hashemiEnvBeam " ++ toString ((hashemiEnvBeam 1.211659 1.153110 1.094561 1.036012 0.977464 0.918915 0.860366 0.801817 0.743268 0.684720 0.626171 0.567622 0.509073 0.450524 0.391976 0.333427 0.274878 0.216329 1.757780 1.699232 1.640683 1.582134 1.523585 1.465036 1.406488 1.347939 1.289390 1.230841 1.172292 1.113744 1.055195 0.996646 0.938097 #[1.488275, 1.429726, 1.371177, 1.312628, 1.254080, 1.195531, 1.136982, 1.078433, 1.019884, 0.961336, 0.902787, 0.844238, 0.785689, 0.727140, 0.668592, 0.610043, 0.551494, 0.492945, 0.434396, 0.375848, 0.317299, 0.258750, 0.200201, 1.741652, 1.683104, 1.624555, 1.566006, 1.507457, 1.448908, 1.390360, 1.331811, 1.273262, 1.214713, 1.156164, 1.097616, 1.039067, 0.980518, 0.921969, 0.863420, 0.804872, 0.746323, 0.687774, 0.629225, 0.570676, 0.512128, 0.453579, 0.395030, 0.336481, 0.277932, 0.219384, 1.760835, 1.702286, 1.643737, 1.585188, 1.526640, 1.468091, 1.409542, 1.350993, 1.292444, 1.233896, 1.175347, 1.116798, 1.058249, 0.999700, 0.941152, 0.882603, 0.824054, 0.765505, 0.706956, 0.648408, 0.589859, 0.531310, 0.472761, 0.414212, 0.355664, 0.297115, 0.238566, 1.780017, 1.721468, 1.662920, 1.604371, 1.545822, 1.487273, 1.428724, 1.370176, 1.311627, 1.253078, 1.194529, 1.135980, 1.077432, 1.018883, 0.960334, 0.901785, 0.843236, 0.784688, 0.726139, 0.667590, 0.609041, 0.550492, 0.491944, 0.433395, 0.374846, 0.316297, 0.257748, 1.799200, 1.740651, 1.682102, 1.623553, 1.565004, 1.506456, 1.447907, 1.389358, 1.330809, 1.272260, 1.213712, 1.155163, 1.096614, 1.038065, 0.979516, 0.920968, 0.862419, 0.803870, 0.745321, 0.686772, 0.628224, 0.569675, 0.511126, 0.452577, 0.394028, 0.335480, 0.276931, 0.218382, 1.759833, 1.701284, 1.642736, 1.584187, 1.525638, 1.467089, 1.408540, 1.349992, 1.291443, 1.232894, 1.174345, 1.115796, 1.057248, 0.998699, 0.940150, 0.881601, 0.823052, 0.764504, 0.705955, 0.647406, 0.588857, 0.530308, 0.471760, 0.413211, 0.354662, 0.296113, 0.237564, 1.779016, 1.720467, 1.661918, 1.603369, 1.544820, 1.486272, 1.427723, 1.369174, 1.310625, 1.252076, 1.193528, 1.134979, 1.076430, 1.017881, 0.959332, 0.900784, 0.842235, 0.783686, 0.725137, 0.666588, 0.608040, 0.549491, 0.490942, 0.432393, 0.373844, 0.315296, 0.256747, 1.798198, 1.739649, 1.681100, 1.622552, 1.564003, 1.505454, 1.446905, 1.388356, 1.329808, 1.271259, 1.212710, 1.154161, 1.095612, 1.037064, 0.978515, 0.919966, 0.861417, 0.802868, 0.744320, 0.685771, 0.627222, 0.568673, 0.510124, 0.451576, 0.393027, 0.334478, 0.275929, 0.217380, 1.758832, 1.700283, 1.641734, 1.583185, 1.524636, 1.466088, 1.407539, 1.348990, 1.290441, 1.231892, 1.173344, 1.114795, 1.056246, 0.997697, 0.939148, 0.880600, 0.822051, 0.763502, 0.704953, 0.646404, 0.587856, 0.529307, 0.470758, 0.412209, 0.353660, 0.295112, 0.236563, 1.778014, 1.719465, 1.660916, 1.602368, 1.543819, 1.485270, 1.426721, 1.368172, 1.309624, 1.251075, 1.192526, 1.133977, 1.075428, 1.016880, 0.958331, 0.899782, 0.841233, 0.782684, 0.724136, 0.665587, 0.607038, 0.548489, 0.489940, 0.431392, 0.372843, 0.314294, 0.255745, 1.797196, 1.738648, 1.680099, 1.621550, 1.563001, 1.504452, 1.445904, 1.387355, 1.328806, 1.270257, 1.211708, 1.153160, 1.094611, 1.036062, 0.977513, 0.918964, 0.860416, 0.801867, 0.743318, 0.684769, 0.626220, 0.567672, 0.509123, 0.450574, 0.392025, 0.333476, 0.274928, 0.216379, 1.757830, 1.699281, 1.640732, 1.582184, 1.523635, 1.465086, 1.406537, 1.347988, 1.289440, 1.230891, 1.172342, 1.113793, 1.055244, 0.996696, 0.938147, 0.879598, 0.821049, 0.762500, 0.703952, 0.645403, 0.586854, 0.528305, 0.469756, 0.411208, 0.352659, 0.294110, 0.235561, 1.777012, 1.718464, 1.659915, 1.601366, 1.542817, 1.484268, 1.425720, 1.367171, 1.308622, 1.250073, 1.191524, 1.132976, 1.074427, 1.015878, 0.957329, 0.898780, 0.840232, 0.781683, 0.723134, 0.664585, 0.606036, 0.547488, 0.488939, 0.430390, 0.371841, 0.313292, 0.254744, 1.796195, 1.737646, 1.679097, 1.620548, 1.562000, 1.503451, 1.444902, 1.386353, 1.327804, 1.269256, 1.210707, 1.152158, 1.093609, 1.035060, 0.976512, 0.917963, 0.859414, 0.800865, 0.742316, 0.683768, 0.625219, 0.566670, 0.508121, 0.449572, 0.391024, 0.332475, 0.273926, 0.215377, 1.756828, 1.698280, 1.639731, 1.581182, 1.522633, 1.464084, 1.405536, 1.346987, 1.288438, 1.229889, 1.171340, 1.112792, 1.054243, 0.995694, 0.937145, 0.878596, 0.820048, 0.761499, 0.702950, 0.644401, 0.585852, 0.527304, 0.468755, 0.410206, 0.351657, 0.293108, 0.234560, 1.776011, 1.717462, 1.658913, 1.600364, 1.541816, 1.483267, 1.424718, 1.366169, 1.307620, 1.249072, 1.190523, 1.131974, 1.073425, 1.014876, 0.956328, 0.897779, 0.839230, 0.780681, 0.722132, 0.663584, 0.605035, 0.546486, 0.487937, 0.429388, 0.370840, 0.312291, 0.253742, 1.795193, 1.736644, 1.678096, 1.619547, 1.560998, 1.502449, 1.443900, 1.385352, 1.326803, 1.268254, 1.209705, 1.151156, 1.092608, 1.034059, 0.975510, 0.916961, 0.858412, 0.799864, 0.741315, 0.682766, 0.624217, 0.565668, 0.507120, 0.448571, 0.390022, 0.331473, 0.272924, 0.214376, 1.755827, 1.697278, 1.638729, 1.580180, 1.521632, 1.463083, 1.404534, 1.345985, 1.287436, 1.228888, 1.170339, 1.111790, 1.053241, 0.994692, 0.936144, 0.877595, 0.819046, 0.760497, 0.701948, 0.643400, 0.584851, 0.526302, 0.467753, 0.409204, 0.350656, 0.292107, 0.233558, 1.775009, 1.716460, 1.657912, 1.599363, 1.540814, 1.482265, 1.423716, 1.365168, 1.306619, 1.248070, 1.189521, 1.130972, 1.072424, 1.013875, 0.955326, 0.896777, 0.838228, 0.779680, 0.721131, 0.662582, 0.604033, 0.545484, 0.486936, 0.428387, 0.369838, 0.311289, 0.252740, 1.794192, 1.735643, 1.677094, 1.618545, 1.559996, 1.501448, 1.442899, 1.384350, 1.325801, 1.267252, 1.208704, 1.150155, 1.091606, 1.033057, 0.974508, 0.915960, 0.857411, 0.798862, 0.740313, 0.681764, 0.623216, 0.564667, 0.506118, 0.447569, 0.389020, 0.330472, 0.271923, 0.213374, 1.754825, 1.696276, 1.637728, 1.579179, 1.520630, 1.462081, 1.403532, 1.344984, 1.286435, 1.227886, 1.169337, 1.110788, 1.052240, 0.993691, 0.935142, 0.876593, 0.818044, 0.759496, 0.700947, 0.642398, 0.583849, 0.525300, 0.466752, 0.408203, 0.349654, 0.291105, 0.232556, 1.774008, 1.715459, 1.656910, 1.598361, 1.539812, 1.481264, 1.422715, 1.364166, 1.305617, 1.247068, 1.188520, 1.129971, 1.071422, 1.012873, 0.954324, 0.895776, 0.837227, 0.778678, 0.720129, 0.661580, 0.603032, 0.544483, 0.485934, 0.427385, 0.368836, 0.310288, 0.251739, 1.793190, 1.734641, 1.676092, 1.617544, 1.558995, 1.500446, 1.441897, 1.383348, 1.324800, 1.266251, 1.207702, 1.149153, 1.090604, 1.032056, 0.973507, 0.914958, 0.856409, 0.797860, 0.739312, 0.680763, 0.622214, 0.563665, 0.505116, 0.446568, 0.388019, 0.329470, 0.270921, 0.212372, 1.753824, 1.695275, 1.636726, 1.578177, 1.519628, 1.461080, 1.402531, 1.343982, 1.285433, 1.226884, 1.168336, 1.109787, 1.051238, 0.992689, 0.934140, 0.875592]).map Float.toBits))

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

#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.687891 1.629342 1.570793 1.512244 1.453696 1.395147 1.336598 1.278049 1.219500 1.160952 1.102403 1.043854 0.985305 0.926756 0.868208 0.809659 0.751110 0.692561 0.634012 0.575464 0.516915 0.458366 0.399817 0.341268 0.282720 0.224171 1.765622 1.707073 1.648524 1.589976 1.531427 1.472878 1.414329 1.355780 1.297232 1.238683 1.180134 1.121585 1.063036 1.004488 0.945939 0.887390 0.828841 0.770292 0.711744 0.653195 0.594646 #[0.364507, 0.305958, 0.247409, 1.788860, 1.730312, 1.671763, 1.613214, 1.554665, 1.496116, 1.437568, 1.379019, 1.320470, 1.261921, 1.203372, 1.144824, 1.086275] #[0.364507, 0.305958, 0.247409, 1.788860, 1.730312, 1.671763, 1.613214, 1.554665, 1.496116, 1.437568, 1.379019, 1.320470, 1.261921, 1.203372, 1.144824, 1.086275] #[0.364507, 0.305958, 0.247409, 1.788860, 1.730312, 1.671763, 1.613214, 1.554665, 1.496116, 1.437568, 1.379019, 1.320470, 1.261921, 1.203372, 1.144824, 1.086275, 1.027726, 0.969177, 0.910628, 0.852080, 0.793531, 0.734982, 0.676433, 0.617884, 0.559336, 0.500787, 0.442238, 0.383689, 0.325140, 0.266592, 0.208043, 1.749494, 1.690945, 1.632396, 1.573848, 1.515299, 1.456750, 1.398201, 1.339652, 1.281104, 1.222555, 1.164006, 1.105457, 1.046908, 0.988360, 0.929811, 0.871262, 0.812713, 0.754164, 0.695616, 0.637067, 0.578518, 0.519969, 0.461420, 0.402872, 0.344323, 0.285774, 0.227225, 1.768676, 1.710128, 1.651579, 1.593030, 1.534481, 1.475932, 1.417384, 1.358835, 1.300286, 1.241737, 1.183188, 1.124640, 1.066091, 1.007542, 0.948993, 0.890444, 0.831896, 0.773347, 0.714798, 0.656249, 0.597700, 0.539152, 0.480603, 0.422054, 0.363505, 0.304956, 0.246408, 1.787859, 1.729310, 1.670761, 1.612212, 1.553664, 1.495115, 1.436566, 1.378017, 1.319468, 1.260920, 1.202371, 1.143822, 1.085273, 1.026724, 0.968176, 0.909627, 0.851078, 0.792529, 0.733980, 0.675432, 0.616883, 0.558334, 0.499785, 0.441236, 0.382688, 0.324139, 0.265590, 0.207041, 1.748492, 1.689944, 1.631395, 1.572846, 1.514297, 1.455748, 1.397200, 1.338651, 1.280102, 1.221553, 1.163004, 1.104456, 1.045907, 0.987358, 0.928809, 0.870260, 0.811712, 0.753163, 0.694614, 0.636065, 0.577516, 0.518968, 0.460419, 0.401870, 0.343321, 0.284772, 0.226224, 1.767675, 1.709126, 1.650577, 1.592028, 1.533480, 1.474931, 1.416382, 1.357833, 1.299284, 1.240736, 1.182187, 1.123638, 1.065089, 1.006540, 0.947992, 0.889443, 0.830894, 0.772345, 0.713796, 0.655248, 0.596699, 0.538150, 0.479601, 0.421052, 0.362504, 0.303955, 0.245406, 1.786857, 1.728308, 1.669760, 1.611211, 1.552662, 1.494113, 1.435564, 1.377016, 1.318467, 1.259918, 1.201369, 1.142820, 1.084272, 1.025723, 0.967174, 0.908625, 0.850076, 0.791528, 0.732979, 0.674430, 0.615881, 0.557332, 0.498784, 0.440235, 0.381686, 0.323137, 0.264588, 0.206040, 1.747491, 1.688942, 1.630393, 1.571844, 1.513296, 1.454747, 1.396198, 1.337649, 1.279100, 1.220552, 1.162003, 1.103454, 1.044905, 0.986356, 0.927808, 0.869259, 0.810710, 0.752161, 0.693612, 0.635064, 0.576515, 0.517966, 0.459417, 0.400868, 0.342320, 0.283771, 0.225222, 1.766673, 1.708124, 1.649576, 1.591027, 1.532478, 1.473929, 1.415380, 1.356832, 1.298283, 1.239734, 1.181185, 1.122636, 1.064088, 1.005539, 0.946990, 0.888441, 0.829892, 0.771344, 0.712795, 0.654246, 0.595697, 0.537148, 0.478600, 0.420051, 0.361502, 0.302953, 0.244404, 1.785856, 1.727307, 1.668758, 1.610209, 1.551660, 1.493112, 1.434563, 1.376014, 1.317465, 1.258916, 1.200368, 1.141819, 1.083270, 1.024721, 0.966172, 0.907624, 0.849075, 0.790526, 0.731977, 0.673428, 0.614880, 0.556331, 0.497782, 0.439233, 0.380684, 0.322136, 0.263587, 0.205038, 1.746489, 1.687940, 1.629392, 1.570843, 1.512294, 1.453745, 1.395196, 1.336648, 1.278099, 1.219550, 1.161001, 1.102452, 1.043904, 0.985355, 0.926806, 0.868257, 0.809708, 0.751160, 0.692611, 0.634062, 0.575513, 0.516964, 0.458416, 0.399867, 0.341318, 0.282769, 0.224220, 1.765672, 1.707123, 1.648574, 1.590025, 1.531476, 1.472928, 1.414379, 1.355830, 1.297281, 1.238732, 1.180184, 1.121635, 1.063086, 1.004537, 0.945988, 0.887440, 0.828891, 0.770342, 0.711793, 0.653244, 0.594696, 0.536147, 0.477598, 0.419049, 0.360500, 0.301952, 0.243403, 1.784854, 1.726305, 1.667756, 1.609208, 1.550659, 1.492110, 1.433561, 1.375012, 1.316464, 1.257915, 1.199366, 1.140817, 1.082268, 1.023720, 0.965171, 0.906622, 0.848073, 0.789524, 0.730976, 0.672427, 0.613878, 0.555329, 0.496780, 0.438232, 0.379683, 0.321134, 0.262585, 0.204036, 1.745488, 1.686939, 1.628390, 1.569841, 1.511292, 1.452744, 1.394195, 1.335646, 1.277097, 1.218548, 1.160000, 1.101451, 1.042902, 0.984353, 0.925804, 0.867256, 0.808707, 0.750158, 0.691609, 0.633060, 0.574512, 0.515963, 0.457414, 0.398865, 0.340316, 0.281768, 0.223219, 1.764670, 1.706121, 1.647572, 1.589024, 1.530475, 1.471926, 1.413377, 1.354828, 1.296280, 1.237731, 1.179182, 1.120633, 1.062084, 1.003536, 0.944987, 0.886438, 0.827889, 0.769340, 0.710792, 0.652243, 0.593694, 0.535145, 0.476596, 0.418048, 0.359499, 0.300950, 0.242401, 1.783852, 1.725304, 1.666755, 1.608206, 1.549657, 1.491108, 1.432560, 1.374011, 1.315462, 1.256913, 1.198364, 1.139816, 1.081267, 1.022718, 0.964169, 0.905620, 0.847072, 0.788523, 0.729974, 0.671425, 0.612876, 0.554328, 0.495779, 0.437230, 0.378681, 0.320132, 0.261584, 0.203035, 1.744486, 1.685937, 1.627388, 1.568840, 1.510291, 1.451742, 1.393193, 1.334644, 1.276096, 1.217547, 1.158998, 1.100449, 1.041900, 0.983352, 0.924803, 0.866254, 0.807705, 0.749156, 0.690608, 0.632059, 0.573510, 0.514961, 0.456412, 0.397864, 0.339315, 0.280766, 0.222217, 1.763668, 1.705120, 1.646571, 1.588022, 1.529473, 1.470924, 1.412376, 1.353827, 1.295278, 1.236729, 1.178180, 1.119632, 1.061083, 1.002534, 0.943985, 0.885436, 0.826888, 0.768339, 0.709790, 0.651241, 0.592692, 0.534144, 0.475595, 0.417046, 0.358497, 0.299948, 0.241400, 1.782851, 1.724302, 1.665753, 1.607204, 1.548656, 1.490107, 1.431558, 1.373009, 1.314460, 1.255912, 1.197363, 1.138814, 1.080265, 1.021716, 0.963168, 0.904619, 0.846070, 0.787521, 0.728972, 0.670424, 0.611875, 0.553326, 0.494777, 0.436228, 0.377680, 0.319131, 0.260582, 0.202033, 1.743484, 1.684936, 1.626387, 1.567838, 1.509289, 1.450740, 1.392192, 1.333643, 1.275094, 1.216545, 1.157996, 1.099448, 1.040899, 0.982350, 0.923801, 0.865252, 0.806704, 0.748155, 0.689606, 0.631057, 0.572508, 0.513960, 0.455411, 0.396862, 0.338313, 0.279764, 0.221216, 1.762667, 1.704118, 1.645569, 1.587020, 1.528472, 1.469923, 1.411374, 1.352825, 1.294276, 1.235728, 1.177179, 1.118630, 1.060081, 1.001532, 0.942984, 0.884435, 0.825886, 0.767337, 0.708788, 0.650240, 0.591691, 0.533142, 0.474593, 0.416044, 0.357496, 0.298947, 0.240398, 1.781849, 1.723300, 1.664752, 1.606203, 1.547654, 1.489105, 1.430556, 1.372008, 1.313459, 1.254910, 1.196361, 1.137812, 1.079264, 1.020715, 0.962166, 0.903617, 0.845068, 0.786520, 0.727971, 0.669422, 0.610873, 0.552324, 0.493776, 0.435227, 0.376678, 0.318129, 0.259580, 0.201032, 1.742483, 1.683934, 1.625385, 1.566836, 1.508288, 1.449739, 1.391190, 1.332641, 1.274092, 1.215544, 1.156995, 1.098446, 1.039897, 0.981348, 0.922800, 0.864251, 0.805702, 0.747153, 0.688604, 0.630056, 0.571507, 0.512958, 0.454409, 0.395860, 0.337312, 0.278763, 0.220214, 1.761665, 1.703116, 1.644568, 1.586019, 1.527470, 1.468921, 1.410372, 1.351824]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.356699 1.298150 1.239601 1.181052 1.122504 1.063955 1.005406 0.946857 0.888308 0.829760 0.771211 0.712662 0.654113 0.595564 0.537016 0.478467 0.419918 0.361369 0.302820 0.244272 1.785723 1.727174 1.668625 1.610076 1.551528 1.492979 1.434430 1.375881 1.317332 1.258784 1.200235 1.141686 1.083137 1.024588 0.966040 0.907491 0.848942 0.790393 0.731844 0.673296 0.614747 0.556198 0.497649 0.439100 0.380552 0.322003 0.263454 #[1.633315, 1.574766, 1.516217, 1.457668, 1.399120, 1.340571, 1.282022, 1.223473, 1.164924, 1.106376, 1.047827, 0.989278, 0.930729, 0.872180, 0.813632, 0.755083] #[1.633315, 1.574766, 1.516217, 1.457668, 1.399120, 1.340571, 1.282022, 1.223473, 1.164924, 1.106376, 1.047827, 0.989278, 0.930729, 0.872180, 0.813632, 0.755083] #[1.633315, 1.574766, 1.516217, 1.457668, 1.399120, 1.340571, 1.282022, 1.223473, 1.164924, 1.106376, 1.047827, 0.989278, 0.930729, 0.872180, 0.813632, 0.755083, 0.696534, 0.637985, 0.579436, 0.520888, 0.462339, 0.403790, 0.345241, 0.286692, 0.228144, 1.769595, 1.711046, 1.652497, 1.593948, 1.535400, 1.476851, 1.418302, 1.359753, 1.301204, 1.242656, 1.184107, 1.125558, 1.067009, 1.008460, 0.949912, 0.891363, 0.832814, 0.774265, 0.715716, 0.657168, 0.598619, 0.540070, 0.481521, 0.422972, 0.364424, 0.305875, 0.247326, 1.788777, 1.730228, 1.671680, 1.613131, 1.554582, 1.496033, 1.437484, 1.378936, 1.320387, 1.261838, 1.203289, 1.144740, 1.086192, 1.027643, 0.969094, 0.910545, 0.851996, 0.793448, 0.734899, 0.676350, 0.617801, 0.559252, 0.500704, 0.442155, 0.383606, 0.325057, 0.266508, 0.207960, 1.749411, 1.690862, 1.632313, 1.573764, 1.515216, 1.456667, 1.398118, 1.339569, 1.281020, 1.222472, 1.163923, 1.105374, 1.046825, 0.988276, 0.929728, 0.871179, 0.812630, 0.754081, 0.695532, 0.636984, 0.578435, 0.519886, 0.461337, 0.402788, 0.344240, 0.285691, 0.227142, 1.768593, 1.710044, 1.651496, 1.592947, 1.534398, 1.475849, 1.417300, 1.358752, 1.300203, 1.241654, 1.183105, 1.124556, 1.066008, 1.007459, 0.948910, 0.890361, 0.831812, 0.773264, 0.714715, 0.656166, 0.597617, 0.539068, 0.480520, 0.421971, 0.363422, 0.304873, 0.246324, 1.787776, 1.729227, 1.670678, 1.612129, 1.553580, 1.495032, 1.436483, 1.377934, 1.319385, 1.260836, 1.202288, 1.143739, 1.085190, 1.026641, 0.968092, 0.909544, 0.850995, 0.792446, 0.733897, 0.675348, 0.616800, 0.558251, 0.499702, 0.441153, 0.382604, 0.324056, 0.265507, 0.206958, 1.748409, 1.689860, 1.631312, 1.572763, 1.514214, 1.455665, 1.397116, 1.338568, 1.280019, 1.221470, 1.162921, 1.104372, 1.045824, 0.987275, 0.928726, 0.870177, 0.811628, 0.753080, 0.694531, 0.635982, 0.577433, 0.518884, 0.460336, 0.401787, 0.343238, 0.284689, 0.226140, 1.767592, 1.709043, 1.650494, 1.591945, 1.533396, 1.474848, 1.416299, 1.357750, 1.299201, 1.240652, 1.182104, 1.123555, 1.065006, 1.006457, 0.947908, 0.889360, 0.830811, 0.772262, 0.713713, 0.655164, 0.596616, 0.538067, 0.479518, 0.420969, 0.362420, 0.303872, 0.245323, 1.786774, 1.728225, 1.669676, 1.611128, 1.552579, 1.494030, 1.435481, 1.376932, 1.318384, 1.259835, 1.201286, 1.142737, 1.084188, 1.025640, 0.967091, 0.908542, 0.849993, 0.791444, 0.732896, 0.674347, 0.615798, 0.557249, 0.498700, 0.440152, 0.381603, 0.323054, 0.264505, 0.205956, 1.747408, 1.688859, 1.630310, 1.571761, 1.513212, 1.454664, 1.396115, 1.337566, 1.279017, 1.220468, 1.161920, 1.103371, 1.044822, 0.986273, 0.927724, 0.869176, 0.810627, 0.752078, 0.693529, 0.634980, 0.576432, 0.517883, 0.459334, 0.400785, 0.342236, 0.283688, 0.225139, 1.766590, 1.708041, 1.649492, 1.590944, 1.532395, 1.473846, 1.415297, 1.356748, 1.298200, 1.239651, 1.181102, 1.122553, 1.064004, 1.005456, 0.946907, 0.888358, 0.829809, 0.771260, 0.712712, 0.654163, 0.595614, 0.537065, 0.478516, 0.419968, 0.361419, 0.302870, 0.244321, 1.785772, 1.727224, 1.668675, 1.610126, 1.551577, 1.493028, 1.434480, 1.375931, 1.317382, 1.258833, 1.200284, 1.141736, 1.083187, 1.024638, 0.966089, 0.907540, 0.848992, 0.790443, 0.731894, 0.673345, 0.614796, 0.556248, 0.497699, 0.439150, 0.380601, 0.322052, 0.263504, 0.204955, 1.746406, 1.687857, 1.629308, 1.570760, 1.512211, 1.453662, 1.395113, 1.336564, 1.278016, 1.219467, 1.160918, 1.102369, 1.043820, 0.985272, 0.926723, 0.868174, 0.809625, 0.751076, 0.692528, 0.633979, 0.575430, 0.516881, 0.458332, 0.399784, 0.341235, 0.282686, 0.224137, 1.765588, 1.707040, 1.648491, 1.589942, 1.531393, 1.472844, 1.414296, 1.355747, 1.297198, 1.238649, 1.180100, 1.121552, 1.063003, 1.004454, 0.945905, 0.887356, 0.828808, 0.770259, 0.711710, 0.653161, 0.594612, 0.536064, 0.477515, 0.418966, 0.360417, 0.301868, 0.243320, 1.784771, 1.726222, 1.667673, 1.609124, 1.550576, 1.492027, 1.433478, 1.374929, 1.316380, 1.257832, 1.199283, 1.140734, 1.082185, 1.023636, 0.965088, 0.906539, 0.847990, 0.789441, 0.730892, 0.672344, 0.613795, 0.555246, 0.496697, 0.438148, 0.379600, 0.321051, 0.262502, 0.203953, 1.745404, 1.686856, 1.628307, 1.569758, 1.511209, 1.452660, 1.394112, 1.335563, 1.277014, 1.218465, 1.159916, 1.101368, 1.042819, 0.984270, 0.925721, 0.867172, 0.808624, 0.750075, 0.691526, 0.632977, 0.574428, 0.515880, 0.457331, 0.398782, 0.340233, 0.281684, 0.223136, 1.764587, 1.706038, 1.647489, 1.588940, 1.530392, 1.471843, 1.413294, 1.354745, 1.296196, 1.237648, 1.179099, 1.120550, 1.062001, 1.003452, 0.944904, 0.886355, 0.827806, 0.769257, 0.710708, 0.652160, 0.593611, 0.535062, 0.476513, 0.417964, 0.359416, 0.300867, 0.242318, 1.783769, 1.725220, 1.666672, 1.608123, 1.549574, 1.491025, 1.432476, 1.373928, 1.315379, 1.256830, 1.198281, 1.139732, 1.081184, 1.022635, 0.964086, 0.905537, 0.846988, 0.788440, 0.729891, 0.671342, 0.612793, 0.554244, 0.495696, 0.437147, 0.378598, 0.320049, 0.261500, 0.202952, 1.744403, 1.685854, 1.627305, 1.568756, 1.510208, 1.451659, 1.393110, 1.334561, 1.276012, 1.217464, 1.158915, 1.100366, 1.041817, 0.983268, 0.924720, 0.866171, 0.807622, 0.749073, 0.690524, 0.631976, 0.573427, 0.514878, 0.456329, 0.397780, 0.339232, 0.280683, 0.222134, 1.763585, 1.705036, 1.646488, 1.587939, 1.529390, 1.470841, 1.412292, 1.353744, 1.295195, 1.236646, 1.178097, 1.119548, 1.061000, 1.002451, 0.943902, 0.885353, 0.826804, 0.768256, 0.709707, 0.651158, 0.592609, 0.534060, 0.475512, 0.416963, 0.358414, 0.299865, 0.241316, 1.782768, 1.724219, 1.665670, 1.607121, 1.548572, 1.490024, 1.431475, 1.372926, 1.314377, 1.255828, 1.197280, 1.138731, 1.080182, 1.021633, 0.963084, 0.904536, 0.845987, 0.787438, 0.728889, 0.670340, 0.611792, 0.553243, 0.494694, 0.436145, 0.377596, 0.319048, 0.260499, 0.201950, 1.743401, 1.684852, 1.626304, 1.567755, 1.509206, 1.450657, 1.392108, 1.333560, 1.275011, 1.216462, 1.157913, 1.099364, 1.040816, 0.982267, 0.923718, 0.865169, 0.806620, 0.748072, 0.689523, 0.630974, 0.572425, 0.513876, 0.455328, 0.396779, 0.338230, 0.279681, 0.221132, 1.762584, 1.704035, 1.645486, 1.586937, 1.528388, 1.469840, 1.411291, 1.352742, 1.294193, 1.235644, 1.177096, 1.118547, 1.059998, 1.001449, 0.942900, 0.884352, 0.825803, 0.767254, 0.708705, 0.650156, 0.591608, 0.533059, 0.474510, 0.415961, 0.357412, 0.298864, 0.240315, 1.781766, 1.723217, 1.664668, 1.606120, 1.547571, 1.489022, 1.430473, 1.371924, 1.313376, 1.254827, 1.196278, 1.137729, 1.079180, 1.020632]))
#eval IO.println ("check_hashemiEnv_capture_mem " ++ toString (check_hashemiEnv_capture_mem 1.025507 0.966958 0.908409 0.849860 0.791312 0.732763 0.674214 0.615665 0.557116 0.498568 0.440019 0.381470 0.322921 0.264372 0.205824 1.747275 1.688726 1.630177 1.571628 1.513080 1.454531 1.395982 1.337433 1.278884 1.220336 1.161787 1.103238 1.044689 0.986140 0.927592 0.869043 0.810494 0.751945 0.693396 0.634848 0.576299 0.517750 0.459201 0.400652 0.342104 0.283555 0.225006 1.766457 1.707908 1.649360 1.590811 1.532262 #[1.302123, 1.243574, 1.185025, 1.126476, 1.067928, 1.009379, 0.950830, 0.892281, 0.833732, 0.775184, 0.716635, 0.658086, 0.599537, 0.540988, 0.482440, 0.423891] #[1.302123, 1.243574, 1.185025, 1.126476, 1.067928, 1.009379, 0.950830, 0.892281, 0.833732, 0.775184, 0.716635, 0.658086, 0.599537, 0.540988, 0.482440, 0.423891] #[1.302123, 1.243574, 1.185025, 1.126476, 1.067928, 1.009379, 0.950830, 0.892281, 0.833732, 0.775184, 0.716635, 0.658086, 0.599537, 0.540988, 0.482440, 0.423891, 0.365342, 0.306793, 0.248244, 1.789696, 1.731147, 1.672598, 1.614049, 1.555500, 1.496952, 1.438403, 1.379854, 1.321305, 1.262756, 1.204208, 1.145659, 1.087110, 1.028561, 0.970012, 0.911464, 0.852915, 0.794366, 0.735817, 0.677268, 0.618720, 0.560171, 0.501622, 0.443073, 0.384524, 0.325976, 0.267427, 0.208878, 1.750329, 1.691780, 1.633232, 1.574683, 1.516134, 1.457585, 1.399036, 1.340488, 1.281939, 1.223390, 1.164841, 1.106292, 1.047744, 0.989195, 0.930646, 0.872097, 0.813548, 0.755000, 0.696451, 0.637902, 0.579353, 0.520804, 0.462256, 0.403707, 0.345158, 0.286609, 0.228060, 1.769512, 1.710963, 1.652414, 1.593865, 1.535316, 1.476768, 1.418219, 1.359670, 1.301121, 1.242572, 1.184024, 1.125475, 1.066926, 1.008377, 0.949828, 0.891280, 0.832731, 0.774182, 0.715633, 0.657084, 0.598536, 0.539987, 0.481438, 0.422889, 0.364340, 0.305792, 0.247243, 1.788694, 1.730145, 1.671596, 1.613048, 1.554499, 1.495950, 1.437401, 1.378852, 1.320304, 1.261755, 1.203206, 1.144657, 1.086108, 1.027560, 0.969011, 0.910462, 0.851913, 0.793364, 0.734816, 0.676267, 0.617718, 0.559169, 0.500620, 0.442072, 0.383523, 0.324974, 0.266425, 0.207876, 1.749328, 1.690779, 1.632230, 1.573681, 1.515132, 1.456584, 1.398035, 1.339486, 1.280937, 1.222388, 1.163840, 1.105291, 1.046742, 0.988193, 0.929644, 0.871096, 0.812547, 0.753998, 0.695449, 0.636900, 0.578352, 0.519803, 0.461254, 0.402705, 0.344156, 0.285608, 0.227059, 1.768510, 1.709961, 1.651412, 1.592864, 1.534315, 1.475766, 1.417217, 1.358668, 1.300120, 1.241571, 1.183022, 1.124473, 1.065924, 1.007376, 0.948827, 0.890278, 0.831729, 0.773180, 0.714632, 0.656083, 0.597534, 0.538985, 0.480436, 0.421888, 0.363339, 0.304790, 0.246241, 1.787692, 1.729144, 1.670595, 1.612046, 1.553497, 1.494948, 1.436400, 1.377851, 1.319302, 1.260753, 1.202204, 1.143656, 1.085107, 1.026558, 0.968009, 0.909460, 0.850912, 0.792363, 0.733814, 0.675265, 0.616716, 0.558168, 0.499619, 0.441070, 0.382521, 0.323972, 0.265424, 0.206875, 1.748326, 1.689777, 1.631228, 1.572680, 1.514131, 1.455582, 1.397033, 1.338484, 1.279936, 1.221387, 1.162838, 1.104289, 1.045740, 0.987192, 0.928643, 0.870094, 0.811545, 0.752996, 0.694448, 0.635899, 0.577350, 0.518801, 0.460252, 0.401704, 0.343155, 0.284606, 0.226057, 1.767508, 1.708960, 1.650411, 1.591862, 1.533313, 1.474764, 1.416216, 1.357667, 1.299118, 1.240569, 1.182020, 1.123472, 1.064923, 1.006374, 0.947825, 0.889276, 0.830728, 0.772179, 0.713630, 0.655081, 0.596532, 0.537984, 0.479435, 0.420886, 0.362337, 0.303788, 0.245240, 1.786691, 1.728142, 1.669593, 1.611044, 1.552496, 1.493947, 1.435398, 1.376849, 1.318300, 1.259752, 1.201203, 1.142654, 1.084105, 1.025556, 0.967008, 0.908459, 0.849910, 0.791361, 0.732812, 0.674264, 0.615715, 0.557166, 0.498617, 0.440068, 0.381520, 0.322971, 0.264422, 0.205873, 1.747324, 1.688776, 1.630227, 1.571678, 1.513129, 1.454580, 1.396032, 1.337483, 1.278934, 1.220385, 1.161836, 1.103288, 1.044739, 0.986190, 0.927641, 0.869092, 0.810544, 0.751995, 0.693446, 0.634897, 0.576348, 0.517800, 0.459251, 0.400702, 0.342153, 0.283604, 0.225056, 1.766507, 1.707958, 1.649409, 1.590860, 1.532312, 1.473763, 1.415214, 1.356665, 1.298116, 1.239568, 1.181019, 1.122470, 1.063921, 1.005372, 0.946824, 0.888275, 0.829726, 0.771177, 0.712628, 0.654080, 0.595531, 0.536982, 0.478433, 0.419884, 0.361336, 0.302787, 0.244238, 1.785689, 1.727140, 1.668592, 1.610043, 1.551494, 1.492945, 1.434396, 1.375848, 1.317299, 1.258750, 1.200201, 1.141652, 1.083104, 1.024555, 0.966006, 0.907457, 0.848908, 0.790360, 0.731811, 0.673262, 0.614713, 0.556164, 0.497616, 0.439067, 0.380518, 0.321969, 0.263420, 0.204872, 1.746323, 1.687774, 1.629225, 1.570676, 1.512128, 1.453579, 1.395030, 1.336481, 1.277932, 1.219384, 1.160835, 1.102286, 1.043737, 0.985188, 0.926640, 0.868091, 0.809542, 0.750993, 0.692444, 0.633896, 0.575347, 0.516798, 0.458249, 0.399700, 0.341152, 0.282603, 0.224054, 1.765505, 1.706956, 1.648408, 1.589859, 1.531310, 1.472761, 1.414212, 1.355664, 1.297115, 1.238566, 1.180017, 1.121468, 1.062920, 1.004371, 0.945822, 0.887273, 0.828724, 0.770176, 0.711627, 0.653078, 0.594529, 0.535980, 0.477432, 0.418883, 0.360334, 0.301785, 0.243236, 1.784688, 1.726139, 1.667590, 1.609041, 1.550492, 1.491944, 1.433395, 1.374846, 1.316297, 1.257748, 1.199200, 1.140651, 1.082102, 1.023553, 0.965004, 0.906456, 0.847907, 0.789358, 0.730809, 0.672260, 0.613712, 0.555163, 0.496614, 0.438065, 0.379516, 0.320968, 0.262419, 0.203870, 1.745321, 1.686772, 1.628224, 1.569675, 1.511126, 1.452577, 1.394028, 1.335480, 1.276931, 1.218382, 1.159833, 1.101284, 1.042736, 0.984187, 0.925638, 0.867089, 0.808540, 0.749992, 0.691443, 0.632894, 0.574345, 0.515796, 0.457248, 0.398699, 0.340150, 0.281601, 0.223052, 1.764504, 1.705955, 1.647406, 1.588857, 1.530308, 1.471760, 1.413211, 1.354662, 1.296113, 1.237564, 1.179016, 1.120467, 1.061918, 1.003369, 0.944820, 0.886272, 0.827723, 0.769174, 0.710625, 0.652076, 0.593528, 0.534979, 0.476430, 0.417881, 0.359332, 0.300784, 0.242235, 1.783686, 1.725137, 1.666588, 1.608040, 1.549491, 1.490942, 1.432393, 1.373844, 1.315296, 1.256747, 1.198198, 1.139649, 1.081100, 1.022552, 0.964003, 0.905454, 0.846905, 0.788356, 0.729808, 0.671259, 0.612710, 0.554161, 0.495612, 0.437064, 0.378515, 0.319966, 0.261417, 0.202868, 1.744320, 1.685771, 1.627222, 1.568673, 1.510124, 1.451576, 1.393027, 1.334478, 1.275929, 1.217380, 1.158832, 1.100283, 1.041734, 0.983185, 0.924636, 0.866088, 0.807539, 0.748990, 0.690441, 0.631892, 0.573344, 0.514795, 0.456246, 0.397697, 0.339148, 0.280600, 0.222051, 1.763502, 1.704953, 1.646404, 1.587856, 1.529307, 1.470758, 1.412209, 1.353660, 1.295112, 1.236563, 1.178014, 1.119465, 1.060916, 1.002368, 0.943819, 0.885270, 0.826721, 0.768172, 0.709624, 0.651075, 0.592526, 0.533977, 0.475428, 0.416880, 0.358331, 0.299782, 0.241233, 1.782684, 1.724136, 1.665587, 1.607038, 1.548489, 1.489940, 1.431392, 1.372843, 1.314294, 1.255745, 1.197196, 1.138648, 1.080099, 1.021550, 0.963001, 0.904452, 0.845904, 0.787355, 0.728806, 0.670257, 0.611708, 0.553160, 0.494611, 0.436062, 0.377513, 0.318964, 0.260416, 0.201867, 1.743318, 1.684769, 1.626220, 1.567672, 1.509123, 1.450574, 1.392025, 1.333476, 1.274928, 1.216379, 1.157830, 1.099281, 1.040732, 0.982184, 0.923635, 0.865086, 0.806537, 0.747988, 0.689440]))

def check_hashemiEnv_flow_mem (az : Float) (t : Float) (slack : Float) (omegam : Float) (omegad : Float) (dt : Float) (elSun : Float) (azSun : Float) (dni : Float) (rDrum : Float) (W : Float) (rcm : Float) (Tmax : Float) (rho : Float) (Fdrive : Float) (L10 : Float) (rodLen : Float) (R : Float) (f : Float) (a : Float) (w : Float) (rc : Float) (k : Float) (sigmaslope : Float) (sigmaspec : Float) (hsun : Float) (soil : Float) (alpha : Float) (eps : Float) (Ac : Float) (Twall : Float) (Ta : Float) (uPump : Float) (Qmax : Float) (Dp : Float) (Lp : Float) (Dins : Float) (kIns : Float) (Vw : Float) (etaP : Float) (Pidle : Float) (Axch : Float) (UAxMax : Float) (Ccoil : Float) (degPrev : Float) (degA : Float) (degEa : Float) (hist : Array Float) (ret : Array Float) (dr : Array Float) : Bool :=
  let v1787 := (Qmax * (min (max uPump (0 : Float)) (1 : Float)))
  (!((0 : Float) <= Qmax) || (((0 : Float) <= v1787) && (v1787 <= Qmax)))

#eval IO.println ("check_hashemiEnv_flow_mem " ++ toString (check_hashemiEnv_flow_mem 1.501739 1.443190 1.384641 1.326092 1.267544 1.208995 1.150446 1.091897 1.033348 0.974800 0.916251 0.857702 0.799153 0.740604 0.682056 0.623507 0.564958 0.506409 0.447860 0.389312 0.330763 0.272214 0.213665 1.755116 1.696568 1.638019 1.579470 1.520921 1.462372 1.403824 1.345275 1.286726 1.228177 1.169628 1.111080 1.052531 0.993982 0.935433 0.876884 0.818336 0.759787 0.701238 0.642689 0.584140 0.525592 0.467043 0.408494 #[1.778355, 1.719806, 1.661257, 1.602708, 1.544160, 1.485611, 1.427062, 1.368513, 1.309964, 1.251416, 1.192867, 1.134318, 1.075769, 1.017220, 0.958672, 0.900123] #[1.778355, 1.719806, 1.661257, 1.602708, 1.544160, 1.485611, 1.427062, 1.368513, 1.309964, 1.251416, 1.192867, 1.134318, 1.075769, 1.017220, 0.958672, 0.900123] #[1.778355, 1.719806, 1.661257, 1.602708, 1.544160, 1.485611, 1.427062, 1.368513, 1.309964, 1.251416, 1.192867, 1.134318, 1.075769, 1.017220, 0.958672, 0.900123, 0.841574, 0.783025, 0.724476, 0.665928, 0.607379, 0.548830, 0.490281, 0.431732, 0.373184, 0.314635, 0.256086, 1.797537, 1.738988, 1.680440, 1.621891, 1.563342, 1.504793, 1.446244, 1.387696, 1.329147, 1.270598, 1.212049, 1.153500, 1.094952, 1.036403, 0.977854, 0.919305, 0.860756, 0.802208, 0.743659, 0.685110, 0.626561, 0.568012, 0.509464, 0.450915, 0.392366, 0.333817, 0.275268, 0.216720, 1.758171, 1.699622, 1.641073, 1.582524, 1.523976, 1.465427, 1.406878, 1.348329, 1.289780, 1.231232, 1.172683, 1.114134, 1.055585, 0.997036, 0.938488, 0.879939, 0.821390, 0.762841, 0.704292, 0.645744, 0.587195, 0.528646, 0.470097, 0.411548, 0.353000, 0.294451, 0.235902, 1.777353, 1.718804, 1.660256, 1.601707, 1.543158, 1.484609, 1.426060, 1.367512, 1.308963, 1.250414, 1.191865, 1.133316, 1.074768, 1.016219, 0.957670, 0.899121, 0.840572, 0.782024, 0.723475, 0.664926, 0.606377, 0.547828, 0.489280, 0.430731, 0.372182, 0.313633, 0.255084, 1.796536, 1.737987, 1.679438, 1.620889, 1.562340, 1.503792, 1.445243, 1.386694, 1.328145, 1.269596, 1.211048, 1.152499, 1.093950, 1.035401, 0.976852, 0.918304, 0.859755, 0.801206, 0.742657, 0.684108, 0.625560, 0.567011, 0.508462, 0.449913, 0.391364, 0.332816, 0.274267, 0.215718, 1.757169, 1.698620, 1.640072, 1.581523, 1.522974, 1.464425, 1.405876, 1.347328, 1.288779, 1.230230, 1.171681, 1.113132, 1.054584, 0.996035, 0.937486, 0.878937, 0.820388, 0.761840, 0.703291, 0.644742, 0.586193, 0.527644, 0.469096, 0.410547, 0.351998, 0.293449, 0.234900, 1.776352, 1.717803, 1.659254, 1.600705, 1.542156, 1.483608, 1.425059, 1.366510, 1.307961, 1.249412, 1.190864, 1.132315, 1.073766, 1.015217, 0.956668, 0.898120, 0.839571, 0.781022, 0.722473, 0.663924, 0.605376, 0.546827, 0.488278, 0.429729, 0.371180, 0.312632, 0.254083, 1.795534, 1.736985, 1.678436, 1.619888, 1.561339, 1.502790, 1.444241, 1.385692, 1.327144, 1.268595, 1.210046, 1.151497, 1.092948, 1.034400, 0.975851, 0.917302, 0.858753, 0.800204, 0.741656, 0.683107, 0.624558, 0.566009, 0.507460, 0.448912, 0.390363, 0.331814, 0.273265, 0.214716, 1.756168, 1.697619, 1.639070, 1.580521, 1.521972, 1.463424, 1.404875, 1.346326, 1.287777, 1.229228, 1.170680, 1.112131, 1.053582, 0.995033, 0.936484, 0.877936, 0.819387, 0.760838, 0.702289, 0.643740, 0.585192, 0.526643, 0.468094, 0.409545, 0.350996, 0.292448, 0.233899, 1.775350, 1.716801, 1.658252, 1.599704, 1.541155, 1.482606, 1.424057, 1.365508, 1.306960, 1.248411, 1.189862, 1.131313, 1.072764, 1.014216, 0.955667, 0.897118, 0.838569, 0.780020, 0.721472, 0.662923, 0.604374, 0.545825, 0.487276, 0.428728, 0.370179, 0.311630, 0.253081, 1.794532, 1.735984, 1.677435, 1.618886, 1.560337, 1.501788, 1.443240, 1.384691, 1.326142, 1.267593, 1.209044, 1.150496, 1.091947, 1.033398, 0.974849, 0.916300, 0.857752, 0.799203, 0.740654, 0.682105, 0.623556, 0.565008, 0.506459, 0.447910, 0.389361, 0.330812, 0.272264, 0.213715, 1.755166, 1.696617, 1.638068, 1.579520, 1.520971, 1.462422, 1.403873, 1.345324, 1.286776, 1.228227, 1.169678, 1.111129, 1.052580, 0.994032, 0.935483, 0.876934, 0.818385, 0.759836, 0.701288, 0.642739, 0.584190, 0.525641, 0.467092, 0.408544, 0.349995, 0.291446, 0.232897, 1.774348, 1.715800, 1.657251, 1.598702, 1.540153, 1.481604, 1.423056, 1.364507, 1.305958, 1.247409, 1.188860, 1.130312, 1.071763, 1.013214, 0.954665, 0.896116, 0.837568, 0.779019, 0.720470, 0.661921, 0.603372, 0.544824, 0.486275, 0.427726, 0.369177, 0.310628, 0.252080, 1.793531, 1.734982, 1.676433, 1.617884, 1.559336, 1.500787, 1.442238, 1.383689, 1.325140, 1.266592, 1.208043, 1.149494, 1.090945, 1.032396, 0.973848, 0.915299, 0.856750, 0.798201, 0.739652, 0.681104, 0.622555, 0.564006, 0.505457, 0.446908, 0.388360, 0.329811, 0.271262, 0.212713, 1.754164, 1.695616, 1.637067, 1.578518, 1.519969, 1.461420, 1.402872, 1.344323, 1.285774, 1.227225, 1.168676, 1.110128, 1.051579, 0.993030, 0.934481, 0.875932, 0.817384, 0.758835, 0.700286, 0.641737, 0.583188, 0.524640, 0.466091, 0.407542, 0.348993, 0.290444, 0.231896, 1.773347, 1.714798, 1.656249, 1.597700, 1.539152, 1.480603, 1.422054, 1.363505, 1.304956, 1.246408, 1.187859, 1.129310, 1.070761, 1.012212, 0.953664, 0.895115, 0.836566, 0.778017, 0.719468, 0.660920, 0.602371, 0.543822, 0.485273, 0.426724, 0.368176, 0.309627, 0.251078, 1.792529, 1.733980, 1.675432, 1.616883, 1.558334, 1.499785, 1.441236, 1.382688, 1.324139, 1.265590, 1.207041, 1.148492, 1.089944, 1.031395, 0.972846, 0.914297, 0.855748, 0.797200, 0.738651, 0.680102, 0.621553, 0.563004, 0.504456, 0.445907, 0.387358, 0.328809, 0.270260, 0.211712, 1.753163, 1.694614, 1.636065, 1.577516, 1.518968, 1.460419, 1.401870, 1.343321, 1.284772, 1.226224, 1.167675, 1.109126, 1.050577, 0.992028, 0.933480, 0.874931, 0.816382, 0.757833, 0.699284, 0.640736, 0.582187, 0.523638, 0.465089, 0.406540, 0.347992, 0.289443, 0.230894, 1.772345, 1.713796, 1.655248, 1.596699, 1.538150, 1.479601, 1.421052, 1.362504, 1.303955, 1.245406, 1.186857, 1.128308, 1.069760, 1.011211, 0.952662, 0.894113, 0.835564, 0.777016, 0.718467, 0.659918, 0.601369, 0.542820, 0.484272, 0.425723, 0.367174, 0.308625, 0.250076, 1.791528, 1.732979, 1.674430, 1.615881, 1.557332, 1.498784, 1.440235, 1.381686, 1.323137, 1.264588, 1.206040, 1.147491, 1.088942, 1.030393, 0.971844, 0.913296, 0.854747, 0.796198, 0.737649, 0.679100, 0.620552, 0.562003, 0.503454, 0.444905, 0.386356, 0.327808, 0.269259, 0.210710, 1.752161, 1.693612, 1.635064, 1.576515, 1.517966, 1.459417, 1.400868, 1.342320, 1.283771, 1.225222, 1.166673, 1.108124, 1.049576, 0.991027, 0.932478, 0.873929, 0.815380, 0.756832, 0.698283, 0.639734, 0.581185, 0.522636, 0.464088, 0.405539, 0.346990, 0.288441, 0.229892, 1.771344, 1.712795, 1.654246, 1.595697, 1.537148, 1.478600, 1.420051, 1.361502, 1.302953, 1.244404, 1.185856, 1.127307, 1.068758, 1.010209, 0.951660, 0.893112, 0.834563, 0.776014, 0.717465, 0.658916, 0.600368, 0.541819, 0.483270, 0.424721, 0.366172, 0.307624, 0.249075, 1.790526, 1.731977, 1.673428, 1.614880, 1.556331, 1.497782, 1.439233, 1.380684, 1.322136, 1.263587, 1.205038, 1.146489, 1.087940, 1.029392, 0.970843, 0.912294, 0.853745, 0.795196, 0.736648, 0.678099, 0.619550, 0.561001, 0.502452, 0.443904, 0.385355, 0.326806, 0.268257, 0.209708, 1.751160, 1.692611, 1.634062, 1.575513, 1.516964, 1.458416, 1.399867, 1.341318, 1.282769, 1.224220, 1.165672]))
#eval IO.println ("check_hashemiEnv_flow_mem " ++ toString (check_hashemiEnv_flow_mem 1.170547 1.111998 1.053449 0.994900 0.936352 0.877803 0.819254 0.760705 0.702156 0.643608 0.585059 0.526510 0.467961 0.409412 0.350864 0.292315 0.233766 1.775217 1.716668 1.658120 1.599571 1.541022 1.482473 1.423924 1.365376 1.306827 1.248278 1.189729 1.131180 1.072632 1.014083 0.955534 0.896985 0.838436 0.779888 0.721339 0.662790 0.604241 0.545692 0.487144 0.428595 0.370046 0.311497 0.252948 1.794400 1.735851 1.677302 #[1.447163, 1.388614, 1.330065, 1.271516, 1.212968, 1.154419, 1.095870, 1.037321, 0.978772, 0.920224, 0.861675, 0.803126, 0.744577, 0.686028, 0.627480, 0.568931] #[1.447163, 1.388614, 1.330065, 1.271516, 1.212968, 1.154419, 1.095870, 1.037321, 0.978772, 0.920224, 0.861675, 0.803126, 0.744577, 0.686028, 0.627480, 0.568931] #[1.447163, 1.388614, 1.330065, 1.271516, 1.212968, 1.154419, 1.095870, 1.037321, 0.978772, 0.920224, 0.861675, 0.803126, 0.744577, 0.686028, 0.627480, 0.568931, 0.510382, 0.451833, 0.393284, 0.334736, 0.276187, 0.217638, 1.759089, 1.700540, 1.641992, 1.583443, 1.524894, 1.466345, 1.407796, 1.349248, 1.290699, 1.232150, 1.173601, 1.115052, 1.056504, 0.997955, 0.939406, 0.880857, 0.822308, 0.763760, 0.705211, 0.646662, 0.588113, 0.529564, 0.471016, 0.412467, 0.353918, 0.295369, 0.236820, 1.778272, 1.719723, 1.661174, 1.602625, 1.544076, 1.485528, 1.426979, 1.368430, 1.309881, 1.251332, 1.192784, 1.134235, 1.075686, 1.017137, 0.958588, 0.900040, 0.841491, 0.782942, 0.724393, 0.665844, 0.607296, 0.548747, 0.490198, 0.431649, 0.373100, 0.314552, 0.256003, 1.797454, 1.738905, 1.680356, 1.621808, 1.563259, 1.504710, 1.446161, 1.387612, 1.329064, 1.270515, 1.211966, 1.153417, 1.094868, 1.036320, 0.977771, 0.919222, 0.860673, 0.802124, 0.743576, 0.685027, 0.626478, 0.567929, 0.509380, 0.450832, 0.392283, 0.333734, 0.275185, 0.216636, 1.758088, 1.699539, 1.640990, 1.582441, 1.523892, 1.465344, 1.406795, 1.348246, 1.289697, 1.231148, 1.172600, 1.114051, 1.055502, 0.996953, 0.938404, 0.879856, 0.821307, 0.762758, 0.704209, 0.645660, 0.587112, 0.528563, 0.470014, 0.411465, 0.352916, 0.294368, 0.235819, 1.777270, 1.718721, 1.660172, 1.601624, 1.543075, 1.484526, 1.425977, 1.367428, 1.308880, 1.250331, 1.191782, 1.133233, 1.074684, 1.016136, 0.957587, 0.899038, 0.840489, 0.781940, 0.723392, 0.664843, 0.606294, 0.547745, 0.489196, 0.430648, 0.372099, 0.313550, 0.255001, 1.796452, 1.737904, 1.679355, 1.620806, 1.562257, 1.503708, 1.445160, 1.386611, 1.328062, 1.269513, 1.210964, 1.152416, 1.093867, 1.035318, 0.976769, 0.918220, 0.859672, 0.801123, 0.742574, 0.684025, 0.625476, 0.566928, 0.508379, 0.449830, 0.391281, 0.332732, 0.274184, 0.215635, 1.757086, 1.698537, 1.639988, 1.581440, 1.522891, 1.464342, 1.405793, 1.347244, 1.288696, 1.230147, 1.171598, 1.113049, 1.054500, 0.995952, 0.937403, 0.878854, 0.820305, 0.761756, 0.703208, 0.644659, 0.586110, 0.527561, 0.469012, 0.410464, 0.351915, 0.293366, 0.234817, 1.776268, 1.717720, 1.659171, 1.600622, 1.542073, 1.483524, 1.424976, 1.366427, 1.307878, 1.249329, 1.190780, 1.132232, 1.073683, 1.015134, 0.956585, 0.898036, 0.839488, 0.780939, 0.722390, 0.663841, 0.605292, 0.546744, 0.488195, 0.429646, 0.371097, 0.312548, 0.254000, 1.795451, 1.736902, 1.678353, 1.619804, 1.561256, 1.502707, 1.444158, 1.385609, 1.327060, 1.268512, 1.209963, 1.151414, 1.092865, 1.034316, 0.975768, 0.917219, 0.858670, 0.800121, 0.741572, 0.683024, 0.624475, 0.565926, 0.507377, 0.448828, 0.390280, 0.331731, 0.273182, 0.214633, 1.756084, 1.697536, 1.638987, 1.580438, 1.521889, 1.463340, 1.404792, 1.346243, 1.287694, 1.229145, 1.170596, 1.112048, 1.053499, 0.994950, 0.936401, 0.877852, 0.819304, 0.760755, 0.702206, 0.643657, 0.585108, 0.526560, 0.468011, 0.409462, 0.350913, 0.292364, 0.233816, 1.775267, 1.716718, 1.658169, 1.599620, 1.541072, 1.482523, 1.423974, 1.365425, 1.306876, 1.248328, 1.189779, 1.131230, 1.072681, 1.014132, 0.955584, 0.897035, 0.838486, 0.779937, 0.721388, 0.662840, 0.604291, 0.545742, 0.487193, 0.428644, 0.370096, 0.311547, 0.252998, 1.794449, 1.735900, 1.677352, 1.618803, 1.560254, 1.501705, 1.443156, 1.384608, 1.326059, 1.267510, 1.208961, 1.150412, 1.091864, 1.033315, 0.974766, 0.916217, 0.857668, 0.799120, 0.740571, 0.682022, 0.623473, 0.564924, 0.506376, 0.447827, 0.389278, 0.330729, 0.272180, 0.213632, 1.755083, 1.696534, 1.637985, 1.579436, 1.520888, 1.462339, 1.403790, 1.345241, 1.286692, 1.228144, 1.169595, 1.111046, 1.052497, 0.993948, 0.935400, 0.876851, 0.818302, 0.759753, 0.701204, 0.642656, 0.584107, 0.525558, 0.467009, 0.408460, 0.349912, 0.291363, 0.232814, 1.774265, 1.715716, 1.657168, 1.598619, 1.540070, 1.481521, 1.422972, 1.364424, 1.305875, 1.247326, 1.188777, 1.130228, 1.071680, 1.013131, 0.954582, 0.896033, 0.837484, 0.778936, 0.720387, 0.661838, 0.603289, 0.544740, 0.486192, 0.427643, 0.369094, 0.310545, 0.251996, 1.793448, 1.734899, 1.676350, 1.617801, 1.559252, 1.500704, 1.442155, 1.383606, 1.325057, 1.266508, 1.207960, 1.149411, 1.090862, 1.032313, 0.973764, 0.915216, 0.856667, 0.798118, 0.739569, 0.681020, 0.622472, 0.563923, 0.505374, 0.446825, 0.388276, 0.329728, 0.271179, 0.212630, 1.754081, 1.695532, 1.636984, 1.578435, 1.519886, 1.461337, 1.402788, 1.344240, 1.285691, 1.227142, 1.168593, 1.110044, 1.051496, 0.992947, 0.934398, 0.875849, 0.817300, 0.758752, 0.700203, 0.641654, 0.583105, 0.524556, 0.466008, 0.407459, 0.348910, 0.290361, 0.231812, 1.773264, 1.714715, 1.656166, 1.597617, 1.539068, 1.480520, 1.421971, 1.363422, 1.304873, 1.246324, 1.187776, 1.129227, 1.070678, 1.012129, 0.953580, 0.895032, 0.836483, 0.777934, 0.719385, 0.660836, 0.602288, 0.543739, 0.485190, 0.426641, 0.368092, 0.309544, 0.250995, 1.792446, 1.733897, 1.675348, 1.616800, 1.558251, 1.499702, 1.441153, 1.382604, 1.324056, 1.265507, 1.206958, 1.148409, 1.089860, 1.031312, 0.972763, 0.914214, 0.855665, 0.797116, 0.738568, 0.680019, 0.621470, 0.562921, 0.504372, 0.445824, 0.387275, 0.328726, 0.270177, 0.211628, 1.753080, 1.694531, 1.635982, 1.577433, 1.518884, 1.460336, 1.401787, 1.343238, 1.284689, 1.226140, 1.167592, 1.109043, 1.050494, 0.991945, 0.933396, 0.874848, 0.816299, 0.757750, 0.699201, 0.640652, 0.582104, 0.523555, 0.465006, 0.406457, 0.347908, 0.289360, 0.230811, 1.772262, 1.713713, 1.655164, 1.596616, 1.538067, 1.479518, 1.420969, 1.362420, 1.303872, 1.245323, 1.186774, 1.128225, 1.069676, 1.011128, 0.952579, 0.894030, 0.835481, 0.776932, 0.718384, 0.659835, 0.601286, 0.542737, 0.484188, 0.425640, 0.367091, 0.308542, 0.249993, 1.791444, 1.732896, 1.674347, 1.615798, 1.557249, 1.498700, 1.440152, 1.381603, 1.323054, 1.264505, 1.205956, 1.147408, 1.088859, 1.030310, 0.971761, 0.913212, 0.854664, 0.796115, 0.737566, 0.679017, 0.620468, 0.561920, 0.503371, 0.444822, 0.386273, 0.327724, 0.269176, 0.210627, 1.752078, 1.693529, 1.634980, 1.576432, 1.517883, 1.459334, 1.400785, 1.342236, 1.283688, 1.225139, 1.166590, 1.108041, 1.049492, 0.990944, 0.932395, 0.873846, 0.815297, 0.756748, 0.698200, 0.639651, 0.581102, 0.522553, 0.464004, 0.405456, 0.346907, 0.288358, 0.229809, 1.771260, 1.712712, 1.654163, 1.595614, 1.537065, 1.478516, 1.419968, 1.361419, 1.302870, 1.244321, 1.185772, 1.127224, 1.068675, 1.010126, 0.951577, 0.893028, 0.834480]))
#eval IO.println ("check_hashemiEnv_flow_mem " ++ toString (check_hashemiEnv_flow_mem 0.839355 0.780806 0.722257 0.663708 0.605160 0.546611 0.488062 0.429513 0.370964 0.312416 0.253867 1.795318 1.736769 1.678220 1.619672 1.561123 1.502574 1.444025 1.385476 1.326928 1.268379 1.209830 1.151281 1.092732 1.034184 0.975635 0.917086 0.858537 0.799988 0.741440 0.682891 0.624342 0.565793 0.507244 0.448696 0.390147 0.331598 0.273049 0.214500 1.755952 1.697403 1.638854 1.580305 1.521756 1.463208 1.404659 1.346110 #[1.115971, 1.057422, 0.998873, 0.940324, 0.881776, 0.823227, 0.764678, 0.706129, 0.647580, 0.589032, 0.530483, 0.471934, 0.413385, 0.354836, 0.296288, 0.237739] #[1.115971, 1.057422, 0.998873, 0.940324, 0.881776, 0.823227, 0.764678, 0.706129, 0.647580, 0.589032, 0.530483, 0.471934, 0.413385, 0.354836, 0.296288, 0.237739] #[1.115971, 1.057422, 0.998873, 0.940324, 0.881776, 0.823227, 0.764678, 0.706129, 0.647580, 0.589032, 0.530483, 0.471934, 0.413385, 0.354836, 0.296288, 0.237739, 1.779190, 1.720641, 1.662092, 1.603544, 1.544995, 1.486446, 1.427897, 1.369348, 1.310800, 1.252251, 1.193702, 1.135153, 1.076604, 1.018056, 0.959507, 0.900958, 0.842409, 0.783860, 0.725312, 0.666763, 0.608214, 0.549665, 0.491116, 0.432568, 0.374019, 0.315470, 0.256921, 1.798372, 1.739824, 1.681275, 1.622726, 1.564177, 1.505628, 1.447080, 1.388531, 1.329982, 1.271433, 1.212884, 1.154336, 1.095787, 1.037238, 0.978689, 0.920140, 0.861592, 0.803043, 0.744494, 0.685945, 0.627396, 0.568848, 0.510299, 0.451750, 0.393201, 0.334652, 0.276104, 0.217555, 1.759006, 1.700457, 1.641908, 1.583360, 1.524811, 1.466262, 1.407713, 1.349164, 1.290616, 1.232067, 1.173518, 1.114969, 1.056420, 0.997872, 0.939323, 0.880774, 0.822225, 0.763676, 0.705128, 0.646579, 0.588030, 0.529481, 0.470932, 0.412384, 0.353835, 0.295286, 0.236737, 1.778188, 1.719640, 1.661091, 1.602542, 1.543993, 1.485444, 1.426896, 1.368347, 1.309798, 1.251249, 1.192700, 1.134152, 1.075603, 1.017054, 0.958505, 0.899956, 0.841408, 0.782859, 0.724310, 0.665761, 0.607212, 0.548664, 0.490115, 0.431566, 0.373017, 0.314468, 0.255920, 1.797371, 1.738822, 1.680273, 1.621724, 1.563176, 1.504627, 1.446078, 1.387529, 1.328980, 1.270432, 1.211883, 1.153334, 1.094785, 1.036236, 0.977688, 0.919139, 0.860590, 0.802041, 0.743492, 0.684944, 0.626395, 0.567846, 0.509297, 0.450748, 0.392200, 0.333651, 0.275102, 0.216553, 1.758004, 1.699456, 1.640907, 1.582358, 1.523809, 1.465260, 1.406712, 1.348163, 1.289614, 1.231065, 1.172516, 1.113968, 1.055419, 0.996870, 0.938321, 0.879772, 0.821224, 0.762675, 0.704126, 0.645577, 0.587028, 0.528480, 0.469931, 0.411382, 0.352833, 0.294284, 0.235736, 1.777187, 1.718638, 1.660089, 1.601540, 1.542992, 1.484443, 1.425894, 1.367345, 1.308796, 1.250248, 1.191699, 1.133150, 1.074601, 1.016052, 0.957504, 0.898955, 0.840406, 0.781857, 0.723308, 0.664760, 0.606211, 0.547662, 0.489113, 0.430564, 0.372016, 0.313467, 0.254918, 1.796369, 1.737820, 1.679272, 1.620723, 1.562174, 1.503625, 1.445076, 1.386528, 1.327979, 1.269430, 1.210881, 1.152332, 1.093784, 1.035235, 0.976686, 0.918137, 0.859588, 0.801040, 0.742491, 0.683942, 0.625393, 0.566844, 0.508296, 0.449747, 0.391198, 0.332649, 0.274100, 0.215552, 1.757003, 1.698454, 1.639905, 1.581356, 1.522808, 1.464259, 1.405710, 1.347161, 1.288612, 1.230064, 1.171515, 1.112966, 1.054417, 0.995868, 0.937320, 0.878771, 0.820222, 0.761673, 0.703124, 0.644576, 0.586027, 0.527478, 0.468929, 0.410380, 0.351832, 0.293283, 0.234734, 1.776185, 1.717636, 1.659088, 1.600539, 1.541990, 1.483441, 1.424892, 1.366344, 1.307795, 1.249246, 1.190697, 1.132148, 1.073600, 1.015051, 0.956502, 0.897953, 0.839404, 0.780856, 0.722307, 0.663758, 0.605209, 0.546660, 0.488112, 0.429563, 0.371014, 0.312465, 0.253916, 1.795368, 1.736819, 1.678270, 1.619721, 1.561172, 1.502624, 1.444075, 1.385526, 1.326977, 1.268428, 1.209880, 1.151331, 1.092782, 1.034233, 0.975684, 0.917136, 0.858587, 0.800038, 0.741489, 0.682940, 0.624392, 0.565843, 0.507294, 0.448745, 0.390196, 0.331648, 0.273099, 0.214550, 1.756001, 1.697452, 1.638904, 1.580355, 1.521806, 1.463257, 1.404708, 1.346160, 1.287611, 1.229062, 1.170513, 1.111964, 1.053416, 0.994867, 0.936318, 0.877769, 0.819220, 0.760672, 0.702123, 0.643574, 0.585025, 0.526476, 0.467928, 0.409379, 0.350830, 0.292281, 0.233732, 1.775184, 1.716635, 1.658086, 1.599537, 1.540988, 1.482440, 1.423891, 1.365342, 1.306793, 1.248244, 1.189696, 1.131147, 1.072598, 1.014049, 0.955500, 0.896952, 0.838403, 0.779854, 0.721305, 0.662756, 0.604208, 0.545659, 0.487110, 0.428561, 0.370012, 0.311464, 0.252915, 1.794366, 1.735817, 1.677268, 1.618720, 1.560171, 1.501622, 1.443073, 1.384524, 1.325976, 1.267427, 1.208878, 1.150329, 1.091780, 1.033232, 0.974683, 0.916134, 0.857585, 0.799036, 0.740488, 0.681939, 0.623390, 0.564841, 0.506292, 0.447744, 0.389195, 0.330646, 0.272097, 0.213548, 1.755000, 1.696451, 1.637902, 1.579353, 1.520804, 1.462256, 1.403707, 1.345158, 1.286609, 1.228060, 1.169512, 1.110963, 1.052414, 0.993865, 0.935316, 0.876768, 0.818219, 0.759670, 0.701121, 0.642572, 0.584024, 0.525475, 0.466926, 0.408377, 0.349828, 0.291280, 0.232731, 1.774182, 1.715633, 1.657084, 1.598536, 1.539987, 1.481438, 1.422889, 1.364340, 1.305792, 1.247243, 1.188694, 1.130145, 1.071596, 1.013048, 0.954499, 0.895950, 0.837401, 0.778852, 0.720304, 0.661755, 0.603206, 0.544657, 0.486108, 0.427560, 0.369011, 0.310462, 0.251913, 1.793364, 1.734816, 1.676267, 1.617718, 1.559169, 1.500620, 1.442072, 1.383523, 1.324974, 1.266425, 1.207876, 1.149328, 1.090779, 1.032230, 0.973681, 0.915132, 0.856584, 0.798035, 0.739486, 0.680937, 0.622388, 0.563840, 0.505291, 0.446742, 0.388193, 0.329644, 0.271096, 0.212547, 1.753998, 1.695449, 1.636900, 1.578352, 1.519803, 1.461254, 1.402705, 1.344156, 1.285608, 1.227059, 1.168510, 1.109961, 1.051412, 0.992864, 0.934315, 0.875766, 0.817217, 0.758668, 0.700120, 0.641571, 0.583022, 0.524473, 0.465924, 0.407376, 0.348827, 0.290278, 0.231729, 1.773180, 1.714632, 1.656083, 1.597534, 1.538985, 1.480436, 1.421888, 1.363339, 1.304790, 1.246241, 1.187692, 1.129144, 1.070595, 1.012046, 0.953497, 0.894948, 0.836400, 0.777851, 0.719302, 0.660753, 0.602204, 0.543656, 0.485107, 0.426558, 0.368009, 0.309460, 0.250912, 1.792363, 1.733814, 1.675265, 1.616716, 1.558168, 1.499619, 1.441070, 1.382521, 1.323972, 1.265424, 1.206875, 1.148326, 1.089777, 1.031228, 0.972680, 0.914131, 0.855582, 0.797033, 0.738484, 0.679936, 0.621387, 0.562838, 0.504289, 0.445740, 0.387192, 0.328643, 0.270094, 0.211545, 1.752996, 1.694448, 1.635899, 1.577350, 1.518801, 1.460252, 1.401704, 1.343155, 1.284606, 1.226057, 1.167508, 1.108960, 1.050411, 0.991862, 0.933313, 0.874764, 0.816216, 0.757667, 0.699118, 0.640569, 0.582020, 0.523472, 0.464923, 0.406374, 0.347825, 0.289276, 0.230728, 1.772179, 1.713630, 1.655081, 1.596532, 1.537984, 1.479435, 1.420886, 1.362337, 1.303788, 1.245240, 1.186691, 1.128142, 1.069593, 1.011044, 0.952496, 0.893947, 0.835398, 0.776849, 0.718300, 0.659752, 0.601203, 0.542654, 0.484105, 0.425556, 0.367008, 0.308459, 0.249910, 1.791361, 1.732812, 1.674264, 1.615715, 1.557166, 1.498617, 1.440068, 1.381520, 1.322971, 1.264422, 1.205873, 1.147324, 1.088776, 1.030227, 0.971678, 0.913129, 0.854580, 0.796032, 0.737483, 0.678934, 0.620385, 0.561836, 0.503288]))

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

#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 1.315587 1.257038 1.198489 1.139940 1.081392 1.022843 0.964294 0.905745 0.847196 0.788648 0.730099 0.671550 0.613001 0.554452 0.495904 0.437355 0.378806 0.320257 0.261708 0.203160 1.744611 1.686062 1.627513 1.568964 1.510416 1.451867 1.393318 1.334769 1.276220 1.217672 1.159123 1.100574 1.042025 0.983476 0.924928 0.866379 0.807830 0.749281 0.690732 0.632184 0.573635 0.515086 0.456537 0.397988 0.339440 0.280891 0.222342 #[1.592203, 1.533654, 1.475105, 1.416556, 1.358008, 1.299459, 1.240910, 1.182361, 1.123812, 1.065264, 1.006715, 0.948166, 0.889617, 0.831068, 0.772520, 0.713971] #[1.592203, 1.533654, 1.475105, 1.416556, 1.358008, 1.299459, 1.240910, 1.182361, 1.123812, 1.065264, 1.006715, 0.948166, 0.889617, 0.831068, 0.772520, 0.713971] #[1.592203, 1.533654, 1.475105, 1.416556, 1.358008, 1.299459, 1.240910, 1.182361, 1.123812, 1.065264, 1.006715, 0.948166, 0.889617, 0.831068, 0.772520, 0.713971, 0.655422, 0.596873, 0.538324, 0.479776, 0.421227, 0.362678, 0.304129, 0.245580, 1.787032, 1.728483, 1.669934, 1.611385, 1.552836, 1.494288, 1.435739, 1.377190, 1.318641, 1.260092, 1.201544, 1.142995, 1.084446, 1.025897, 0.967348, 0.908800, 0.850251, 0.791702, 0.733153, 0.674604, 0.616056, 0.557507, 0.498958, 0.440409, 0.381860, 0.323312, 0.264763, 0.206214, 1.747665, 1.689116, 1.630568, 1.572019, 1.513470, 1.454921, 1.396372, 1.337824, 1.279275, 1.220726, 1.162177, 1.103628, 1.045080, 0.986531, 0.927982, 0.869433, 0.810884, 0.752336, 0.693787, 0.635238, 0.576689, 0.518140, 0.459592, 0.401043, 0.342494, 0.283945, 0.225396, 1.766848, 1.708299, 1.649750, 1.591201, 1.532652, 1.474104, 1.415555, 1.357006, 1.298457, 1.239908, 1.181360, 1.122811, 1.064262, 1.005713, 0.947164, 0.888616, 0.830067, 0.771518, 0.712969, 0.654420, 0.595872, 0.537323, 0.478774, 0.420225, 0.361676, 0.303128, 0.244579, 1.786030, 1.727481, 1.668932, 1.610384, 1.551835, 1.493286, 1.434737, 1.376188, 1.317640, 1.259091, 1.200542, 1.141993, 1.083444, 1.024896, 0.966347, 0.907798, 0.849249, 0.790700, 0.732152, 0.673603, 0.615054, 0.556505, 0.497956, 0.439408, 0.380859, 0.322310, 0.263761, 0.205212, 1.746664, 1.688115, 1.629566, 1.571017, 1.512468, 1.453920, 1.395371, 1.336822, 1.278273, 1.219724, 1.161176, 1.102627, 1.044078, 0.985529, 0.926980, 0.868432, 0.809883, 0.751334, 0.692785, 0.634236, 0.575688, 0.517139, 0.458590, 0.400041, 0.341492, 0.282944, 0.224395, 1.765846, 1.707297, 1.648748, 1.590200, 1.531651, 1.473102, 1.414553, 1.356004, 1.297456, 1.238907, 1.180358, 1.121809, 1.063260, 1.004712, 0.946163, 0.887614, 0.829065, 0.770516, 0.711968, 0.653419, 0.594870, 0.536321, 0.477772, 0.419224, 0.360675, 0.302126, 0.243577, 1.785028, 1.726480, 1.667931, 1.609382, 1.550833, 1.492284, 1.433736, 1.375187, 1.316638, 1.258089, 1.199540, 1.140992, 1.082443, 1.023894, 0.965345, 0.906796, 0.848248, 0.789699, 0.731150, 0.672601, 0.614052, 0.555504, 0.496955, 0.438406, 0.379857, 0.321308, 0.262760, 0.204211, 1.745662, 1.687113, 1.628564, 1.570016, 1.511467, 1.452918, 1.394369, 1.335820, 1.277272, 1.218723, 1.160174, 1.101625, 1.043076, 0.984528, 0.925979, 0.867430, 0.808881, 0.750332, 0.691784, 0.633235, 0.574686, 0.516137, 0.457588, 0.399040, 0.340491, 0.281942, 0.223393, 1.764844, 1.706296, 1.647747, 1.589198, 1.530649, 1.472100, 1.413552, 1.355003, 1.296454, 1.237905, 1.179356, 1.120808, 1.062259, 1.003710, 0.945161, 0.886612, 0.828064, 0.769515, 0.710966, 0.652417, 0.593868, 0.535320, 0.476771, 0.418222, 0.359673, 0.301124, 0.242576, 1.784027, 1.725478, 1.666929, 1.608380, 1.549832, 1.491283, 1.432734, 1.374185, 1.315636, 1.257088, 1.198539, 1.139990, 1.081441, 1.022892, 0.964344, 0.905795, 0.847246, 0.788697, 0.730148, 0.671600, 0.613051, 0.554502, 0.495953, 0.437404, 0.378856, 0.320307, 0.261758, 0.203209, 1.744660, 1.686112, 1.627563, 1.569014, 1.510465, 1.451916, 1.393368, 1.334819, 1.276270, 1.217721, 1.159172, 1.100624, 1.042075, 0.983526, 0.924977, 0.866428, 0.807880, 0.749331, 0.690782, 0.632233, 0.573684, 0.515136, 0.456587, 0.398038, 0.339489, 0.280940, 0.222392, 1.763843, 1.705294, 1.646745, 1.588196, 1.529648, 1.471099, 1.412550, 1.354001, 1.295452, 1.236904, 1.178355, 1.119806, 1.061257, 1.002708, 0.944160, 0.885611, 0.827062, 0.768513, 0.709964, 0.651416, 0.592867, 0.534318, 0.475769, 0.417220, 0.358672, 0.300123, 0.241574, 1.783025, 1.724476, 1.665928, 1.607379, 1.548830, 1.490281, 1.431732, 1.373184, 1.314635, 1.256086, 1.197537, 1.138988, 1.080440, 1.021891, 0.963342, 0.904793, 0.846244, 0.787696, 0.729147, 0.670598, 0.612049, 0.553500, 0.494952, 0.436403, 0.377854, 0.319305, 0.260756, 0.202208, 1.743659, 1.685110, 1.626561, 1.568012, 1.509464, 1.450915, 1.392366, 1.333817, 1.275268, 1.216720, 1.158171, 1.099622, 1.041073, 0.982524, 0.923976, 0.865427, 0.806878, 0.748329, 0.689780, 0.631232, 0.572683, 0.514134, 0.455585, 0.397036, 0.338488, 0.279939, 0.221390, 1.762841, 1.704292, 1.645744, 1.587195, 1.528646, 1.470097, 1.411548, 1.353000, 1.294451, 1.235902, 1.177353, 1.118804, 1.060256, 1.001707, 0.943158, 0.884609, 0.826060, 0.767512, 0.708963, 0.650414, 0.591865, 0.533316, 0.474768, 0.416219, 0.357670, 0.299121, 0.240572, 1.782024, 1.723475, 1.664926, 1.606377, 1.547828, 1.489280, 1.430731, 1.372182, 1.313633, 1.255084, 1.196536, 1.137987, 1.079438, 1.020889, 0.962340, 0.903792, 0.845243, 0.786694, 0.728145, 0.669596, 0.611048, 0.552499, 0.493950, 0.435401, 0.376852, 0.318304, 0.259755, 0.201206, 1.742657, 1.684108, 1.625560, 1.567011, 1.508462, 1.449913, 1.391364, 1.332816, 1.274267, 1.215718, 1.157169, 1.098620, 1.040072, 0.981523, 0.922974, 0.864425, 0.805876, 0.747328, 0.688779, 0.630230, 0.571681, 0.513132, 0.454584, 0.396035, 0.337486, 0.278937, 0.220388, 1.761840, 1.703291, 1.644742, 1.586193, 1.527644, 1.469096, 1.410547, 1.351998, 1.293449, 1.234900, 1.176352, 1.117803, 1.059254, 1.000705, 0.942156, 0.883608, 0.825059, 0.766510, 0.707961, 0.649412, 0.590864, 0.532315, 0.473766, 0.415217, 0.356668, 0.298120, 0.239571, 1.781022, 1.722473, 1.663924, 1.605376, 1.546827, 1.488278, 1.429729, 1.371180, 1.312632, 1.254083, 1.195534, 1.136985, 1.078436, 1.019888, 0.961339, 0.902790, 0.844241, 0.785692, 0.727144, 0.668595, 0.610046, 0.551497, 0.492948, 0.434400, 0.375851, 0.317302, 0.258753, 0.200204, 1.741656, 1.683107, 1.624558, 1.566009, 1.507460, 1.448912, 1.390363, 1.331814, 1.273265, 1.214716, 1.156168, 1.097619, 1.039070, 0.980521, 0.921972, 0.863424, 0.804875, 0.746326, 0.687777, 0.629228, 0.570680, 0.512131, 0.453582, 0.395033, 0.336484, 0.277936, 0.219387, 1.760838, 1.702289, 1.643740, 1.585192, 1.526643, 1.468094, 1.409545, 1.350996, 1.292448, 1.233899, 1.175350, 1.116801, 1.058252, 0.999704, 0.941155, 0.882606, 0.824057, 0.765508, 0.706960, 0.648411, 0.589862, 0.531313, 0.472764, 0.414216, 0.355667, 0.297118, 0.238569, 1.780020, 1.721472, 1.662923, 1.604374, 1.545825, 1.487276, 1.428728, 1.370179, 1.311630, 1.253081, 1.194532, 1.135984, 1.077435, 1.018886, 0.960337, 0.901788, 0.843240, 0.784691, 0.726142, 0.667593, 0.609044, 0.550496, 0.491947, 0.433398, 0.374849, 0.316300, 0.257752, 1.799203, 1.740654, 1.682105, 1.623556, 1.565008, 1.506459, 1.447910, 1.389361, 1.330812, 1.272264, 1.213715, 1.155166, 1.096617, 1.038068, 0.979520]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.984395 0.925846 0.867297 0.808748 0.750200 0.691651 0.633102 0.574553 0.516004 0.457456 0.398907 0.340358 0.281809 0.223260 1.764712 1.706163 1.647614 1.589065 1.530516 1.471968 1.413419 1.354870 1.296321 1.237772 1.179224 1.120675 1.062126 1.003577 0.945028 0.886480 0.827931 0.769382 0.710833 0.652284 0.593736 0.535187 0.476638 0.418089 0.359540 0.300992 0.242443 1.783894 1.725345 1.666796 1.608248 1.549699 1.491150 #[1.261011, 1.202462, 1.143913, 1.085364, 1.026816, 0.968267, 0.909718, 0.851169, 0.792620, 0.734072, 0.675523, 0.616974, 0.558425, 0.499876, 0.441328, 0.382779] #[1.261011, 1.202462, 1.143913, 1.085364, 1.026816, 0.968267, 0.909718, 0.851169, 0.792620, 0.734072, 0.675523, 0.616974, 0.558425, 0.499876, 0.441328, 0.382779] #[1.261011, 1.202462, 1.143913, 1.085364, 1.026816, 0.968267, 0.909718, 0.851169, 0.792620, 0.734072, 0.675523, 0.616974, 0.558425, 0.499876, 0.441328, 0.382779, 0.324230, 0.265681, 0.207132, 1.748584, 1.690035, 1.631486, 1.572937, 1.514388, 1.455840, 1.397291, 1.338742, 1.280193, 1.221644, 1.163096, 1.104547, 1.045998, 0.987449, 0.928900, 0.870352, 0.811803, 0.753254, 0.694705, 0.636156, 0.577608, 0.519059, 0.460510, 0.401961, 0.343412, 0.284864, 0.226315, 1.767766, 1.709217, 1.650668, 1.592120, 1.533571, 1.475022, 1.416473, 1.357924, 1.299376, 1.240827, 1.182278, 1.123729, 1.065180, 1.006632, 0.948083, 0.889534, 0.830985, 0.772436, 0.713888, 0.655339, 0.596790, 0.538241, 0.479692, 0.421144, 0.362595, 0.304046, 0.245497, 1.786948, 1.728400, 1.669851, 1.611302, 1.552753, 1.494204, 1.435656, 1.377107, 1.318558, 1.260009, 1.201460, 1.142912, 1.084363, 1.025814, 0.967265, 0.908716, 0.850168, 0.791619, 0.733070, 0.674521, 0.615972, 0.557424, 0.498875, 0.440326, 0.381777, 0.323228, 0.264680, 0.206131, 1.747582, 1.689033, 1.630484, 1.571936, 1.513387, 1.454838, 1.396289, 1.337740, 1.279192, 1.220643, 1.162094, 1.103545, 1.044996, 0.986448, 0.927899, 0.869350, 0.810801, 0.752252, 0.693704, 0.635155, 0.576606, 0.518057, 0.459508, 0.400960, 0.342411, 0.283862, 0.225313, 1.766764, 1.708216, 1.649667, 1.591118, 1.532569, 1.474020, 1.415472, 1.356923, 1.298374, 1.239825, 1.181276, 1.122728, 1.064179, 1.005630, 0.947081, 0.888532, 0.829984, 0.771435, 0.712886, 0.654337, 0.595788, 0.537240, 0.478691, 0.420142, 0.361593, 0.303044, 0.244496, 1.785947, 1.727398, 1.668849, 1.610300, 1.551752, 1.493203, 1.434654, 1.376105, 1.317556, 1.259008, 1.200459, 1.141910, 1.083361, 1.024812, 0.966264, 0.907715, 0.849166, 0.790617, 0.732068, 0.673520, 0.614971, 0.556422, 0.497873, 0.439324, 0.380776, 0.322227, 0.263678, 0.205129, 1.746580, 1.688032, 1.629483, 1.570934, 1.512385, 1.453836, 1.395288, 1.336739, 1.278190, 1.219641, 1.161092, 1.102544, 1.043995, 0.985446, 0.926897, 0.868348, 0.809800, 0.751251, 0.692702, 0.634153, 0.575604, 0.517056, 0.458507, 0.399958, 0.341409, 0.282860, 0.224312, 1.765763, 1.707214, 1.648665, 1.590116, 1.531568, 1.473019, 1.414470, 1.355921, 1.297372, 1.238824, 1.180275, 1.121726, 1.063177, 1.004628, 0.946080, 0.887531, 0.828982, 0.770433, 0.711884, 0.653336, 0.594787, 0.536238, 0.477689, 0.419140, 0.360592, 0.302043, 0.243494, 1.784945, 1.726396, 1.667848, 1.609299, 1.550750, 1.492201, 1.433652, 1.375104, 1.316555, 1.258006, 1.199457, 1.140908, 1.082360, 1.023811, 0.965262, 0.906713, 0.848164, 0.789616, 0.731067, 0.672518, 0.613969, 0.555420, 0.496872, 0.438323, 0.379774, 0.321225, 0.262676, 0.204128, 1.745579, 1.687030, 1.628481, 1.569932, 1.511384, 1.452835, 1.394286, 1.335737, 1.277188, 1.218640, 1.160091, 1.101542, 1.042993, 0.984444, 0.925896, 0.867347, 0.808798, 0.750249, 0.691700, 0.633152, 0.574603, 0.516054, 0.457505, 0.398956, 0.340408, 0.281859, 0.223310, 1.764761, 1.706212, 1.647664, 1.589115, 1.530566, 1.472017, 1.413468, 1.354920, 1.296371, 1.237822, 1.179273, 1.120724, 1.062176, 1.003627, 0.945078, 0.886529, 0.827980, 0.769432, 0.710883, 0.652334, 0.593785, 0.535236, 0.476688, 0.418139, 0.359590, 0.301041, 0.242492, 1.783944, 1.725395, 1.666846, 1.608297, 1.549748, 1.491200, 1.432651, 1.374102, 1.315553, 1.257004, 1.198456, 1.139907, 1.081358, 1.022809, 0.964260, 0.905712, 0.847163, 0.788614, 0.730065, 0.671516, 0.612968, 0.554419, 0.495870, 0.437321, 0.378772, 0.320224, 0.261675, 0.203126, 1.744577, 1.686028, 1.627480, 1.568931, 1.510382, 1.451833, 1.393284, 1.334736, 1.276187, 1.217638, 1.159089, 1.100540, 1.041992, 0.983443, 0.924894, 0.866345, 0.807796, 0.749248, 0.690699, 0.632150, 0.573601, 0.515052, 0.456504, 0.397955, 0.339406, 0.280857, 0.222308, 1.763760, 1.705211, 1.646662, 1.588113, 1.529564, 1.471016, 1.412467, 1.353918, 1.295369, 1.236820, 1.178272, 1.119723, 1.061174, 1.002625, 0.944076, 0.885528, 0.826979, 0.768430, 0.709881, 0.651332, 0.592784, 0.534235, 0.475686, 0.417137, 0.358588, 0.300040, 0.241491, 1.782942, 1.724393, 1.665844, 1.607296, 1.548747, 1.490198, 1.431649, 1.373100, 1.314552, 1.256003, 1.197454, 1.138905, 1.080356, 1.021808, 0.963259, 0.904710, 0.846161, 0.787612, 0.729064, 0.670515, 0.611966, 0.553417, 0.494868, 0.436320, 0.377771, 0.319222, 0.260673, 0.202124, 1.743576, 1.685027, 1.626478, 1.567929, 1.509380, 1.450832, 1.392283, 1.333734, 1.275185, 1.216636, 1.158088, 1.099539, 1.040990, 0.982441, 0.923892, 0.865344, 0.806795, 0.748246, 0.689697, 0.631148, 0.572600, 0.514051, 0.455502, 0.396953, 0.338404, 0.279856, 0.221307, 1.762758, 1.704209, 1.645660, 1.587112, 1.528563, 1.470014, 1.411465, 1.352916, 1.294368, 1.235819, 1.177270, 1.118721, 1.060172, 1.001624, 0.943075, 0.884526, 0.825977, 0.767428, 0.708880, 0.650331, 0.591782, 0.533233, 0.474684, 0.416136, 0.357587, 0.299038, 0.240489, 1.781940, 1.723392, 1.664843, 1.606294, 1.547745, 1.489196, 1.430648, 1.372099, 1.313550, 1.255001, 1.196452, 1.137904, 1.079355, 1.020806, 0.962257, 0.903708, 0.845160, 0.786611, 0.728062, 0.669513, 0.610964, 0.552416, 0.493867, 0.435318, 0.376769, 0.318220, 0.259672, 0.201123, 1.742574, 1.684025, 1.625476, 1.566928, 1.508379, 1.449830, 1.391281, 1.332732, 1.274184, 1.215635, 1.157086, 1.098537, 1.039988, 0.981440, 0.922891, 0.864342, 0.805793, 0.747244, 0.688696, 0.630147, 0.571598, 0.513049, 0.454500, 0.395952, 0.337403, 0.278854, 0.220305, 1.761756, 1.703208, 1.644659, 1.586110, 1.527561, 1.469012, 1.410464, 1.351915, 1.293366, 1.234817, 1.176268, 1.117720, 1.059171, 1.000622, 0.942073, 0.883524, 0.824976, 0.766427, 0.707878, 0.649329, 0.590780, 0.532232, 0.473683, 0.415134, 0.356585, 0.298036, 0.239488, 1.780939, 1.722390, 1.663841, 1.605292, 1.546744, 1.488195, 1.429646, 1.371097, 1.312548, 1.254000, 1.195451, 1.136902, 1.078353, 1.019804, 0.961256, 0.902707, 0.844158, 0.785609, 0.727060, 0.668512, 0.609963, 0.551414, 0.492865, 0.434316, 0.375768, 0.317219, 0.258670, 0.200121, 1.741572, 1.683024, 1.624475, 1.565926, 1.507377, 1.448828, 1.390280, 1.331731, 1.273182, 1.214633, 1.156084, 1.097536, 1.038987, 0.980438, 0.921889, 0.863340, 0.804792, 0.746243, 0.687694, 0.629145, 0.570596, 0.512048, 0.453499, 0.394950, 0.336401, 0.277852, 0.219304, 1.760755, 1.702206, 1.643657, 1.585108, 1.526560, 1.468011, 1.409462, 1.350913, 1.292364, 1.233816, 1.175267, 1.116718, 1.058169, 0.999620, 0.941072, 0.882523, 0.823974, 0.765425, 0.706876, 0.648328]))
#eval IO.println ("check_hashemiEnv_hist_head " ++ toString (check_hashemiEnv_hist_head 0.653203 0.594654 0.536105 0.477556 0.419008 0.360459 0.301910 0.243361 1.784812 1.726264 1.667715 1.609166 1.550617 1.492068 1.433520 1.374971 1.316422 1.257873 1.199324 1.140776 1.082227 1.023678 0.965129 0.906580 0.848032 0.789483 0.730934 0.672385 0.613836 0.555288 0.496739 0.438190 0.379641 0.321092 0.262544 0.203995 1.745446 1.686897 1.628348 1.569800 1.511251 1.452702 1.394153 1.335604 1.277056 1.218507 1.159958 #[0.929819, 0.871270, 0.812721, 0.754172, 0.695624, 0.637075, 0.578526, 0.519977, 0.461428, 0.402880, 0.344331, 0.285782, 0.227233, 1.768684, 1.710136, 1.651587] #[0.929819, 0.871270, 0.812721, 0.754172, 0.695624, 0.637075, 0.578526, 0.519977, 0.461428, 0.402880, 0.344331, 0.285782, 0.227233, 1.768684, 1.710136, 1.651587] #[0.929819, 0.871270, 0.812721, 0.754172, 0.695624, 0.637075, 0.578526, 0.519977, 0.461428, 0.402880, 0.344331, 0.285782, 0.227233, 1.768684, 1.710136, 1.651587, 1.593038, 1.534489, 1.475940, 1.417392, 1.358843, 1.300294, 1.241745, 1.183196, 1.124648, 1.066099, 1.007550, 0.949001, 0.890452, 0.831904, 0.773355, 0.714806, 0.656257, 0.597708, 0.539160, 0.480611, 0.422062, 0.363513, 0.304964, 0.246416, 1.787867, 1.729318, 1.670769, 1.612220, 1.553672, 1.495123, 1.436574, 1.378025, 1.319476, 1.260928, 1.202379, 1.143830, 1.085281, 1.026732, 0.968184, 0.909635, 0.851086, 0.792537, 0.733988, 0.675440, 0.616891, 0.558342, 0.499793, 0.441244, 0.382696, 0.324147, 0.265598, 0.207049, 1.748500, 1.689952, 1.631403, 1.572854, 1.514305, 1.455756, 1.397208, 1.338659, 1.280110, 1.221561, 1.163012, 1.104464, 1.045915, 0.987366, 0.928817, 0.870268, 0.811720, 0.753171, 0.694622, 0.636073, 0.577524, 0.518976, 0.460427, 0.401878, 0.343329, 0.284780, 0.226232, 1.767683, 1.709134, 1.650585, 1.592036, 1.533488, 1.474939, 1.416390, 1.357841, 1.299292, 1.240744, 1.182195, 1.123646, 1.065097, 1.006548, 0.948000, 0.889451, 0.830902, 0.772353, 0.713804, 0.655256, 0.596707, 0.538158, 0.479609, 0.421060, 0.362512, 0.303963, 0.245414, 1.786865, 1.728316, 1.669768, 1.611219, 1.552670, 1.494121, 1.435572, 1.377024, 1.318475, 1.259926, 1.201377, 1.142828, 1.084280, 1.025731, 0.967182, 0.908633, 0.850084, 0.791536, 0.732987, 0.674438, 0.615889, 0.557340, 0.498792, 0.440243, 0.381694, 0.323145, 0.264596, 0.206048, 1.747499, 1.688950, 1.630401, 1.571852, 1.513304, 1.454755, 1.396206, 1.337657, 1.279108, 1.220560, 1.162011, 1.103462, 1.044913, 0.986364, 0.927816, 0.869267, 0.810718, 0.752169, 0.693620, 0.635072, 0.576523, 0.517974, 0.459425, 0.400876, 0.342328, 0.283779, 0.225230, 1.766681, 1.708132, 1.649584, 1.591035, 1.532486, 1.473937, 1.415388, 1.356840, 1.298291, 1.239742, 1.181193, 1.122644, 1.064096, 1.005547, 0.946998, 0.888449, 0.829900, 0.771352, 0.712803, 0.654254, 0.595705, 0.537156, 0.478608, 0.420059, 0.361510, 0.302961, 0.244412, 1.785864, 1.727315, 1.668766, 1.610217, 1.551668, 1.493120, 1.434571, 1.376022, 1.317473, 1.258924, 1.200376, 1.141827, 1.083278, 1.024729, 0.966180, 0.907632, 0.849083, 0.790534, 0.731985, 0.673436, 0.614888, 0.556339, 0.497790, 0.439241, 0.380692, 0.322144, 0.263595, 0.205046, 1.746497, 1.687948, 1.629400, 1.570851, 1.512302, 1.453753, 1.395204, 1.336656, 1.278107, 1.219558, 1.161009, 1.102460, 1.043912, 0.985363, 0.926814, 0.868265, 0.809716, 0.751168, 0.692619, 0.634070, 0.575521, 0.516972, 0.458424, 0.399875, 0.341326, 0.282777, 0.224228, 1.765680, 1.707131, 1.648582, 1.590033, 1.531484, 1.472936, 1.414387, 1.355838, 1.297289, 1.238740, 1.180192, 1.121643, 1.063094, 1.004545, 0.945996, 0.887448, 0.828899, 0.770350, 0.711801, 0.653252, 0.594704, 0.536155, 0.477606, 0.419057, 0.360508, 0.301960, 0.243411, 1.784862, 1.726313, 1.667764, 1.609216, 1.550667, 1.492118, 1.433569, 1.375020, 1.316472, 1.257923, 1.199374, 1.140825, 1.082276, 1.023728, 0.965179, 0.906630, 0.848081, 0.789532, 0.730984, 0.672435, 0.613886, 0.555337, 0.496788, 0.438240, 0.379691, 0.321142, 0.262593, 0.204044, 1.745496, 1.686947, 1.628398, 1.569849, 1.511300, 1.452752, 1.394203, 1.335654, 1.277105, 1.218556, 1.160008, 1.101459, 1.042910, 0.984361, 0.925812, 0.867264, 0.808715, 0.750166, 0.691617, 0.633068, 0.574520, 0.515971, 0.457422, 0.398873, 0.340324, 0.281776, 0.223227, 1.764678, 1.706129, 1.647580, 1.589032, 1.530483, 1.471934, 1.413385, 1.354836, 1.296288, 1.237739, 1.179190, 1.120641, 1.062092, 1.003544, 0.944995, 0.886446, 0.827897, 0.769348, 0.710800, 0.652251, 0.593702, 0.535153, 0.476604, 0.418056, 0.359507, 0.300958, 0.242409, 1.783860, 1.725312, 1.666763, 1.608214, 1.549665, 1.491116, 1.432568, 1.374019, 1.315470, 1.256921, 1.198372, 1.139824, 1.081275, 1.022726, 0.964177, 0.905628, 0.847080, 0.788531, 0.729982, 0.671433, 0.612884, 0.554336, 0.495787, 0.437238, 0.378689, 0.320140, 0.261592, 0.203043, 1.744494, 1.685945, 1.627396, 1.568848, 1.510299, 1.451750, 1.393201, 1.334652, 1.276104, 1.217555, 1.159006, 1.100457, 1.041908, 0.983360, 0.924811, 0.866262, 0.807713, 0.749164, 0.690616, 0.632067, 0.573518, 0.514969, 0.456420, 0.397872, 0.339323, 0.280774, 0.222225, 1.763676, 1.705128, 1.646579, 1.588030, 1.529481, 1.470932, 1.412384, 1.353835, 1.295286, 1.236737, 1.178188, 1.119640, 1.061091, 1.002542, 0.943993, 0.885444, 0.826896, 0.768347, 0.709798, 0.651249, 0.592700, 0.534152, 0.475603, 0.417054, 0.358505, 0.299956, 0.241408, 1.782859, 1.724310, 1.665761, 1.607212, 1.548664, 1.490115, 1.431566, 1.373017, 1.314468, 1.255920, 1.197371, 1.138822, 1.080273, 1.021724, 0.963176, 0.904627, 0.846078, 0.787529, 0.728980, 0.670432, 0.611883, 0.553334, 0.494785, 0.436236, 0.377688, 0.319139, 0.260590, 0.202041, 1.743492, 1.684944, 1.626395, 1.567846, 1.509297, 1.450748, 1.392200, 1.333651, 1.275102, 1.216553, 1.158004, 1.099456, 1.040907, 0.982358, 0.923809, 0.865260, 0.806712, 0.748163, 0.689614, 0.631065, 0.572516, 0.513968, 0.455419, 0.396870, 0.338321, 0.279772, 0.221224, 1.762675, 1.704126, 1.645577, 1.587028, 1.528480, 1.469931, 1.411382, 1.352833, 1.294284, 1.235736, 1.177187, 1.118638, 1.060089, 1.001540, 0.942992, 0.884443, 0.825894, 0.767345, 0.708796, 0.650248, 0.591699, 0.533150, 0.474601, 0.416052, 0.357504, 0.298955, 0.240406, 1.781857, 1.723308, 1.664760, 1.606211, 1.547662, 1.489113, 1.430564, 1.372016, 1.313467, 1.254918, 1.196369, 1.137820, 1.079272, 1.020723, 0.962174, 0.903625, 0.845076, 0.786528, 0.727979, 0.669430, 0.610881, 0.552332, 0.493784, 0.435235, 0.376686, 0.318137, 0.259588, 0.201040, 1.742491, 1.683942, 1.625393, 1.566844, 1.508296, 1.449747, 1.391198, 1.332649, 1.274100, 1.215552, 1.157003, 1.098454, 1.039905, 0.981356, 0.922808, 0.864259, 0.805710, 0.747161, 0.688612, 0.630064, 0.571515, 0.512966, 0.454417, 0.395868, 0.337320, 0.278771, 0.220222, 1.761673, 1.703124, 1.644576, 1.586027, 1.527478, 1.468929, 1.410380, 1.351832, 1.293283, 1.234734, 1.176185, 1.117636, 1.059088, 1.000539, 0.941990, 0.883441, 0.824892, 0.766344, 0.707795, 0.649246, 0.590697, 0.532148, 0.473600, 0.415051, 0.356502, 0.297953, 0.239404, 1.780856, 1.722307, 1.663758, 1.605209, 1.546660, 1.488112, 1.429563, 1.371014, 1.312465, 1.253916, 1.195368, 1.136819, 1.078270, 1.019721, 0.961172, 0.902624, 0.844075, 0.785526, 0.726977, 0.668428, 0.609880, 0.551331, 0.492782, 0.434233, 0.375684, 0.317136]))

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

#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.570979 0.512430 0.453881 0.395332 0.336784 0.278235 0.219686 1.761137 1.702588 1.644040 1.585491 1.526942 1.468393 1.409844 1.351296 1.292747 1.234198 1.175649 1.117100 1.058552 1.000003 0.941454 0.882905 0.824356 0.765808 0.707259 0.648710 0.590161 0.531612 0.473064 0.414515 0.355966 0.297417 0.238868 1.780320 1.721771 1.663222 1.604673 1.546124 1.487576 1.429027 1.370478 1.311929 1.253380 1.194832 1.136283 1.077734 1.019185 0.960636 0.902088 0.843539 0.784990 #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363, 1.510814, 1.452265, 1.393716, 1.335168, 1.276619, 1.218070, 1.159521, 1.100972, 1.042424, 0.983875, 0.925326, 0.866777, 0.808228, 0.749680, 0.691131, 0.632582, 0.574033, 0.515484, 0.456936, 0.398387, 0.339838, 0.281289, 0.222740, 1.764192, 1.705643, 1.647094, 1.588545, 1.529996, 1.471448, 1.412899, 1.354350, 1.295801, 1.237252, 1.178704, 1.120155, 1.061606, 1.003057, 0.944508, 0.885960, 0.827411, 0.768862, 0.710313, 0.651764, 0.593216, 0.534667, 0.476118, 0.417569, 0.359020, 0.300472, 0.241923, 1.783374, 1.724825, 1.666276, 1.607728, 1.549179, 1.490630, 1.432081, 1.373532, 1.314984, 1.256435, 1.197886, 1.139337, 1.080788, 1.022240, 0.963691, 0.905142, 0.846593, 0.788044, 0.729496, 0.670947, 0.612398, 0.553849, 0.495300, 0.436752, 0.378203, 0.319654, 0.261105, 0.202556, 1.744008, 1.685459, 1.626910, 1.568361, 1.509812, 1.451264, 1.392715, 1.334166, 1.275617, 1.217068, 1.158520, 1.099971, 1.041422, 0.982873, 0.924324, 0.865776, 0.807227, 0.748678, 0.690129, 0.631580, 0.573032, 0.514483, 0.455934, 0.397385, 0.338836, 0.280288, 0.221739, 1.763190, 1.704641, 1.646092, 1.587544, 1.528995, 1.470446, 1.411897, 1.353348, 1.294800, 1.236251, 1.177702, 1.119153, 1.060604, 1.002056, 0.943507, 0.884958, 0.826409, 0.767860, 0.709312, 0.650763, 0.592214, 0.533665, 0.475116, 0.416568, 0.358019, 0.299470, 0.240921, 1.782372, 1.723824, 1.665275, 1.606726, 1.548177, 1.489628, 1.431080, 1.372531, 1.313982, 1.255433, 1.196884, 1.138336, 1.079787, 1.021238, 0.962689, 0.904140, 0.845592, 0.787043, 0.728494, 0.669945, 0.611396, 0.552848, 0.494299, 0.435750, 0.377201, 0.318652, 0.260104, 0.201555] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363, 1.510814, 1.452265, 1.393716, 1.335168, 1.276619, 1.218070, 1.159521, 1.100972, 1.042424, 0.983875, 0.925326, 0.866777, 0.808228, 0.749680, 0.691131, 0.632582, 0.574033, 0.515484, 0.456936, 0.398387, 0.339838, 0.281289, 0.222740, 1.764192, 1.705643, 1.647094, 1.588545, 1.529996, 1.471448, 1.412899, 1.354350, 1.295801] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363] #[0.847595, 0.789046, 0.730497, 0.671948, 0.613400, 0.554851, 0.496302, 0.437753, 0.379204, 0.320656, 0.262107, 0.203558, 1.745009, 1.686460, 1.627912, 1.569363, 1.510814, 1.452265, 1.393716, 1.335168, 1.276619, 1.218070, 1.159521, 1.100972, 1.042424, 0.983875, 0.925326, 0.866777, 0.808228, 0.749680, 0.691131, 0.632582, 0.574033, 0.515484, 0.456936, 0.398387, 0.339838, 0.281289, 0.222740, 1.764192, 1.705643, 1.647094, 1.588545, 1.529996, 1.471448, 1.412899, 1.354350, 1.295801, 1.237252, 1.178704, 1.120155, 1.061606, 1.003057, 0.944508, 0.885960, 0.827411, 0.768862, 0.710313, 0.651764, 0.593216, 0.534667, 0.476118, 0.417569, 0.359020, 0.300472, 0.241923, 1.783374, 1.724825, 1.666276, 1.607728, 1.549179, 1.490630, 1.432081, 1.373532, 1.314984, 1.256435, 1.197886, 1.139337, 1.080788, 1.022240, 0.963691, 0.905142, 0.846593, 0.788044, 0.729496, 0.670947, 0.612398, 0.553849, 0.495300, 0.436752, 0.378203, 0.319654, 0.261105, 0.202556, 1.744008, 1.685459, 1.626910, 1.568361, 1.509812, 1.451264, 1.392715, 1.334166, 1.275617, 1.217068, 1.158520, 1.099971, 1.041422, 0.982873, 0.924324, 0.865776, 0.807227, 0.748678, 0.690129, 0.631580, 0.573032, 0.514483, 0.455934, 0.397385, 0.338836, 0.280288, 0.221739, 1.763190, 1.704641, 1.646092, 1.587544, 1.528995, 1.470446, 1.411897, 1.353348, 1.294800, 1.236251, 1.177702, 1.119153, 1.060604, 1.002056, 0.943507, 0.884958, 0.826409, 0.767860, 0.709312, 0.650763, 0.592214, 0.533665, 0.475116, 0.416568, 0.358019, 0.299470, 0.240921, 1.782372, 1.723824, 1.665275, 1.606726, 1.548177, 1.489628, 1.431080, 1.372531, 1.313982, 1.255433, 1.196884, 1.138336, 1.079787, 1.021238, 0.962689, 0.904140, 0.845592, 0.787043, 0.728494, 0.669945, 0.611396, 0.552848, 0.494299, 0.435750, 0.377201, 0.318652, 0.260104, 0.201555, 1.743006, 1.684457, 1.625908, 1.567360, 1.508811, 1.450262, 1.391713, 1.333164, 1.274616, 1.216067, 1.157518, 1.098969, 1.040420, 0.981872, 0.923323, 0.864774, 0.806225, 0.747676, 0.689128, 0.630579, 0.572030, 0.513481, 0.454932, 0.396384, 0.337835, 0.279286, 0.220737, 1.762188, 1.703640, 1.645091, 1.586542, 1.527993, 1.469444, 1.410896, 1.352347, 1.293798, 1.235249, 1.176700, 1.118152, 1.059603, 1.001054, 0.942505, 0.883956, 0.825408, 0.766859, 0.708310, 0.649761, 0.591212, 0.532664, 0.474115, 0.415566, 0.357017, 0.298468, 0.239920, 1.781371, 1.722822, 1.664273, 1.605724, 1.547176, 1.488627, 1.430078, 1.371529, 1.312980, 1.254432, 1.195883, 1.137334, 1.078785, 1.020236, 0.961688, 0.903139, 0.844590, 0.786041, 0.727492, 0.668944, 0.610395, 0.551846, 0.493297, 0.434748, 0.376200, 0.317651, 0.259102, 0.200553, 1.742004, 1.683456, 1.624907, 1.566358, 1.507809, 1.449260, 1.390712, 1.332163, 1.273614, 1.215065, 1.156516, 1.097968, 1.039419, 0.980870, 0.922321, 0.863772, 0.805224, 0.746675, 0.688126, 0.629577, 0.571028, 0.512480, 0.453931, 0.395382, 0.336833, 0.278284, 0.219736, 1.761187, 1.702638, 1.644089, 1.585540, 1.526992, 1.468443, 1.409894, 1.351345, 1.292796, 1.234248, 1.175699, 1.117150, 1.058601, 1.000052, 0.941504, 0.882955, 0.824406, 0.765857, 0.707308, 0.648760, 0.590211, 0.531662, 0.473113, 0.414564, 0.356016, 0.297467, 0.238918, 1.780369, 1.721820, 1.663272, 1.604723, 1.546174, 1.487625, 1.429076, 1.370528, 1.311979, 1.253430, 1.194881, 1.136332, 1.077784, 1.019235, 0.960686, 0.902137, 0.843588, 0.785040, 0.726491, 0.667942, 0.609393, 0.550844, 0.492296, 0.433747, 0.375198, 0.316649, 0.258100, 1.799552, 1.741003, 1.682454, 1.623905, 1.565356, 1.506808, 1.448259, 1.389710, 1.331161, 1.272612, 1.214064, 1.155515, 1.096966, 1.038417, 0.979868, 0.921320, 0.862771, 0.804222, 0.745673, 0.687124, 0.628576, 0.570027, 0.511478, 0.452929, 0.394380, 0.335832, 0.277283, 0.218734, 1.760185, 1.701636, 1.643088, 1.584539, 1.525990, 1.467441, 1.408892, 1.350344, 1.291795, 1.233246, 1.174697, 1.116148, 1.057600, 0.999051, 0.940502, 0.881953, 0.823404, 0.764856, 0.706307, 0.647758, 0.589209, 0.530660, 0.472112, 0.413563, 0.355014, 0.296465, 0.237916, 1.779368, 1.720819, 1.662270, 1.603721, 1.545172, 1.486624, 1.428075, 1.369526, 1.310977, 1.252428, 1.193880, 1.135331, 1.076782, 1.018233, 0.959684, 0.901136, 0.842587, 0.784038, 0.725489, 0.666940, 0.608392, 0.549843, 0.491294, 0.432745, 0.374196, 0.315648, 0.257099, 1.798550, 1.740001, 1.681452, 1.622904, 1.564355, 1.505806, 1.447257, 1.388708, 1.330160, 1.271611, 1.213062, 1.154513, 1.095964, 1.037416, 0.978867, 0.920318, 0.861769, 0.803220, 0.744672, 0.686123, 0.627574, 0.569025, 0.510476, 0.451928, 0.393379, 0.334830, 0.276281, 0.217732, 1.759184, 1.700635, 1.642086, 1.583537, 1.524988, 1.466440, 1.407891, 1.349342, 1.290793, 1.232244, 1.173696, 1.115147, 1.056598, 0.998049, 0.939500, 0.880952, 0.822403, 0.763854, 0.705305, 0.646756, 0.588208, 0.529659, 0.471110, 0.412561, 0.354012, 0.295464, 0.236915, 1.778366, 1.719817, 1.661268, 1.602720, 1.544171, 1.485622, 1.427073, 1.368524, 1.309976, 1.251427, 1.192878, 1.134329, 1.075780, 1.017232, 0.958683, 0.900134, 0.841585, 0.783036, 0.724488, 0.665939, 0.607390, 0.548841, 0.490292, 0.431744, 0.373195, 0.314646, 0.256097, 1.797548, 1.739000, 1.680451, 1.621902, 1.563353, 1.504804, 1.446256, 1.387707, 1.329158, 1.270609, 1.212060, 1.153512, 1.094963, 1.036414, 0.977865, 0.919316, 0.860768, 0.802219, 0.743670, 0.685121, 0.626572, 0.568024, 0.509475, 0.450926, 0.392377, 0.333828, 0.275280, 0.216731, 1.758182, 1.699633, 1.641084, 1.582536, 1.523987, 1.465438, 1.406889, 1.348340, 1.289792, 1.231243, 1.172694, 1.114145, 1.055596, 0.997048, 0.938499, 0.879950, 0.821401, 0.762852, 0.704304, 0.645755, 0.587206, 0.528657, 0.470108, 0.411560, 0.353011, 0.294462, 0.235913, 1.777364, 1.718816, 1.660267, 1.601718, 1.543169, 1.484620, 1.426072, 1.367523, 1.308974, 1.250425, 1.191876, 1.133328, 1.074779, 1.016230, 0.957681, 0.899132, 0.840584, 0.782035, 0.723486, 0.664937, 0.606388, 0.547840, 0.489291, 0.430742, 0.372193, 0.313644, 0.255096, 1.796547, 1.737998, 1.679449, 1.620900, 1.562352, 1.503803, 1.445254, 1.386705, 1.328156, 1.269608, 1.211059, 1.152510, 1.093961, 1.035412, 0.976864, 0.918315, 0.859766, 0.801217, 0.742668, 0.684120, 0.625571, 0.567022, 0.508473, 0.449924, 0.391376, 0.332827, 0.274278, 0.215729, 1.757180, 1.698632, 1.640083, 1.581534, 1.522985, 1.464436, 1.405888, 1.347339, 1.288790, 1.230241, 1.171692, 1.113144, 1.054595, 0.996046, 0.937497, 0.878948, 0.820400, 0.761851, 0.703302, 0.644753, 0.586204, 0.527656, 0.469107, 0.410558, 0.352009, 0.293460, 0.234912]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 0.239787 1.781238 1.722689 1.664140 1.605592 1.547043 1.488494 1.429945 1.371396 1.312848 1.254299 1.195750 1.137201 1.078652 1.020104 0.961555 0.903006 0.844457 0.785908 0.727360 0.668811 0.610262 0.551713 0.493164 0.434616 0.376067 0.317518 0.258969 0.200420 1.741872 1.683323 1.624774 1.566225 1.507676 1.449128 1.390579 1.332030 1.273481 1.214932 1.156384 1.097835 1.039286 0.980737 0.922188 0.863640 0.805091 0.746542 0.687993 0.629444 0.570896 0.512347 0.453798 #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171, 1.179622, 1.121073, 1.062524, 1.003976, 0.945427, 0.886878, 0.828329, 0.769780, 0.711232, 0.652683, 0.594134, 0.535585, 0.477036, 0.418488, 0.359939, 0.301390, 0.242841, 1.784292, 1.725744, 1.667195, 1.608646, 1.550097, 1.491548, 1.433000, 1.374451, 1.315902, 1.257353, 1.198804, 1.140256, 1.081707, 1.023158, 0.964609, 0.906060, 0.847512, 0.788963, 0.730414, 0.671865, 0.613316, 0.554768, 0.496219, 0.437670, 0.379121, 0.320572, 0.262024, 0.203475, 1.744926, 1.686377, 1.627828, 1.569280, 1.510731, 1.452182, 1.393633, 1.335084, 1.276536, 1.217987, 1.159438, 1.100889, 1.042340, 0.983792, 0.925243, 0.866694, 0.808145, 0.749596, 0.691048, 0.632499, 0.573950, 0.515401, 0.456852, 0.398304, 0.339755, 0.281206, 0.222657, 1.764108, 1.705560, 1.647011, 1.588462, 1.529913, 1.471364, 1.412816, 1.354267, 1.295718, 1.237169, 1.178620, 1.120072, 1.061523, 1.002974, 0.944425, 0.885876, 0.827328, 0.768779, 0.710230, 0.651681, 0.593132, 0.534584, 0.476035, 0.417486, 0.358937, 0.300388, 0.241840, 1.783291, 1.724742, 1.666193, 1.607644, 1.549096, 1.490547, 1.431998, 1.373449, 1.314900, 1.256352, 1.197803, 1.139254, 1.080705, 1.022156, 0.963608, 0.905059, 0.846510, 0.787961, 0.729412, 0.670864, 0.612315, 0.553766, 0.495217, 0.436668, 0.378120, 0.319571, 0.261022, 0.202473, 1.743924, 1.685376, 1.626827, 1.568278, 1.509729, 1.451180, 1.392632, 1.334083, 1.275534, 1.216985, 1.158436, 1.099888, 1.041339, 0.982790, 0.924241, 0.865692, 0.807144, 0.748595, 0.690046, 0.631497, 0.572948, 0.514400, 0.455851, 0.397302, 0.338753, 0.280204, 0.221656, 1.763107, 1.704558, 1.646009, 1.587460, 1.528912, 1.470363] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171, 1.179622, 1.121073, 1.062524, 1.003976, 0.945427, 0.886878, 0.828329, 0.769780, 0.711232, 0.652683, 0.594134, 0.535585, 0.477036, 0.418488, 0.359939, 0.301390, 0.242841, 1.784292, 1.725744, 1.667195, 1.608646, 1.550097, 1.491548, 1.433000, 1.374451, 1.315902, 1.257353, 1.198804, 1.140256, 1.081707, 1.023158, 0.964609] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171] #[0.516403, 0.457854, 0.399305, 0.340756, 0.282208, 0.223659, 1.765110, 1.706561, 1.648012, 1.589464, 1.530915, 1.472366, 1.413817, 1.355268, 1.296720, 1.238171, 1.179622, 1.121073, 1.062524, 1.003976, 0.945427, 0.886878, 0.828329, 0.769780, 0.711232, 0.652683, 0.594134, 0.535585, 0.477036, 0.418488, 0.359939, 0.301390, 0.242841, 1.784292, 1.725744, 1.667195, 1.608646, 1.550097, 1.491548, 1.433000, 1.374451, 1.315902, 1.257353, 1.198804, 1.140256, 1.081707, 1.023158, 0.964609, 0.906060, 0.847512, 0.788963, 0.730414, 0.671865, 0.613316, 0.554768, 0.496219, 0.437670, 0.379121, 0.320572, 0.262024, 0.203475, 1.744926, 1.686377, 1.627828, 1.569280, 1.510731, 1.452182, 1.393633, 1.335084, 1.276536, 1.217987, 1.159438, 1.100889, 1.042340, 0.983792, 0.925243, 0.866694, 0.808145, 0.749596, 0.691048, 0.632499, 0.573950, 0.515401, 0.456852, 0.398304, 0.339755, 0.281206, 0.222657, 1.764108, 1.705560, 1.647011, 1.588462, 1.529913, 1.471364, 1.412816, 1.354267, 1.295718, 1.237169, 1.178620, 1.120072, 1.061523, 1.002974, 0.944425, 0.885876, 0.827328, 0.768779, 0.710230, 0.651681, 0.593132, 0.534584, 0.476035, 0.417486, 0.358937, 0.300388, 0.241840, 1.783291, 1.724742, 1.666193, 1.607644, 1.549096, 1.490547, 1.431998, 1.373449, 1.314900, 1.256352, 1.197803, 1.139254, 1.080705, 1.022156, 0.963608, 0.905059, 0.846510, 0.787961, 0.729412, 0.670864, 0.612315, 0.553766, 0.495217, 0.436668, 0.378120, 0.319571, 0.261022, 0.202473, 1.743924, 1.685376, 1.626827, 1.568278, 1.509729, 1.451180, 1.392632, 1.334083, 1.275534, 1.216985, 1.158436, 1.099888, 1.041339, 0.982790, 0.924241, 0.865692, 0.807144, 0.748595, 0.690046, 0.631497, 0.572948, 0.514400, 0.455851, 0.397302, 0.338753, 0.280204, 0.221656, 1.763107, 1.704558, 1.646009, 1.587460, 1.528912, 1.470363, 1.411814, 1.353265, 1.294716, 1.236168, 1.177619, 1.119070, 1.060521, 1.001972, 0.943424, 0.884875, 0.826326, 0.767777, 0.709228, 0.650680, 0.592131, 0.533582, 0.475033, 0.416484, 0.357936, 0.299387, 0.240838, 1.782289, 1.723740, 1.665192, 1.606643, 1.548094, 1.489545, 1.430996, 1.372448, 1.313899, 1.255350, 1.196801, 1.138252, 1.079704, 1.021155, 0.962606, 0.904057, 0.845508, 0.786960, 0.728411, 0.669862, 0.611313, 0.552764, 0.494216, 0.435667, 0.377118, 0.318569, 0.260020, 0.201472, 1.742923, 1.684374, 1.625825, 1.567276, 1.508728, 1.450179, 1.391630, 1.333081, 1.274532, 1.215984, 1.157435, 1.098886, 1.040337, 0.981788, 0.923240, 0.864691, 0.806142, 0.747593, 0.689044, 0.630496, 0.571947, 0.513398, 0.454849, 0.396300, 0.337752, 0.279203, 0.220654, 1.762105, 1.703556, 1.645008, 1.586459, 1.527910, 1.469361, 1.410812, 1.352264, 1.293715, 1.235166, 1.176617, 1.118068, 1.059520, 1.000971, 0.942422, 0.883873, 0.825324, 0.766776, 0.708227, 0.649678, 0.591129, 0.532580, 0.474032, 0.415483, 0.356934, 0.298385, 0.239836, 1.781288, 1.722739, 1.664190, 1.605641, 1.547092, 1.488544, 1.429995, 1.371446, 1.312897, 1.254348, 1.195800, 1.137251, 1.078702, 1.020153, 0.961604, 0.903056, 0.844507, 0.785958, 0.727409, 0.668860, 0.610312, 0.551763, 0.493214, 0.434665, 0.376116, 0.317568, 0.259019, 0.200470, 1.741921, 1.683372, 1.624824, 1.566275, 1.507726, 1.449177, 1.390628, 1.332080, 1.273531, 1.214982, 1.156433, 1.097884, 1.039336, 0.980787, 0.922238, 0.863689, 0.805140, 0.746592, 0.688043, 0.629494, 0.570945, 0.512396, 0.453848, 0.395299, 0.336750, 0.278201, 0.219652, 1.761104, 1.702555, 1.644006, 1.585457, 1.526908, 1.468360, 1.409811, 1.351262, 1.292713, 1.234164, 1.175616, 1.117067, 1.058518, 0.999969, 0.941420, 0.882872, 0.824323, 0.765774, 0.707225, 0.648676, 0.590128, 0.531579, 0.473030, 0.414481, 0.355932, 0.297384, 0.238835, 1.780286, 1.721737, 1.663188, 1.604640, 1.546091, 1.487542, 1.428993, 1.370444, 1.311896, 1.253347, 1.194798, 1.136249, 1.077700, 1.019152, 0.960603, 0.902054, 0.843505, 0.784956, 0.726408, 0.667859, 0.609310, 0.550761, 0.492212, 0.433664, 0.375115, 0.316566, 0.258017, 1.799468, 1.740920, 1.682371, 1.623822, 1.565273, 1.506724, 1.448176, 1.389627, 1.331078, 1.272529, 1.213980, 1.155432, 1.096883, 1.038334, 0.979785, 0.921236, 0.862688, 0.804139, 0.745590, 0.687041, 0.628492, 0.569944, 0.511395, 0.452846, 0.394297, 0.335748, 0.277200, 0.218651, 1.760102, 1.701553, 1.643004, 1.584456, 1.525907, 1.467358, 1.408809, 1.350260, 1.291712, 1.233163, 1.174614, 1.116065, 1.057516, 0.998968, 0.940419, 0.881870, 0.823321, 0.764772, 0.706224, 0.647675, 0.589126, 0.530577, 0.472028, 0.413480, 0.354931, 0.296382, 0.237833, 1.779284, 1.720736, 1.662187, 1.603638, 1.545089, 1.486540, 1.427992, 1.369443, 1.310894, 1.252345, 1.193796, 1.135248, 1.076699, 1.018150, 0.959601, 0.901052, 0.842504, 0.783955, 0.725406, 0.666857, 0.608308, 0.549760, 0.491211, 0.432662, 0.374113, 0.315564, 0.257016, 1.798467, 1.739918, 1.681369, 1.622820, 1.564272, 1.505723, 1.447174, 1.388625, 1.330076, 1.271528, 1.212979, 1.154430, 1.095881, 1.037332, 0.978784, 0.920235, 0.861686, 0.803137, 0.744588, 0.686040, 0.627491, 0.568942, 0.510393, 0.451844, 0.393296, 0.334747, 0.276198, 0.217649, 1.759100, 1.700552, 1.642003, 1.583454, 1.524905, 1.466356, 1.407808, 1.349259, 1.290710, 1.232161, 1.173612, 1.115064, 1.056515, 0.997966, 0.939417, 0.880868, 0.822320, 0.763771, 0.705222, 0.646673, 0.588124, 0.529576, 0.471027, 0.412478, 0.353929, 0.295380, 0.236832, 1.778283, 1.719734, 1.661185, 1.602636, 1.544088, 1.485539, 1.426990, 1.368441, 1.309892, 1.251344, 1.192795, 1.134246, 1.075697, 1.017148, 0.958600, 0.900051, 0.841502, 0.782953, 0.724404, 0.665856, 0.607307, 0.548758, 0.490209, 0.431660, 0.373112, 0.314563, 0.256014, 1.797465, 1.738916, 1.680368, 1.621819, 1.563270, 1.504721, 1.446172, 1.387624, 1.329075, 1.270526, 1.211977, 1.153428, 1.094880, 1.036331, 0.977782, 0.919233, 0.860684, 0.802136, 0.743587, 0.685038, 0.626489, 0.567940, 0.509392, 0.450843, 0.392294, 0.333745, 0.275196, 0.216648, 1.758099, 1.699550, 1.641001, 1.582452, 1.523904, 1.465355, 1.406806, 1.348257, 1.289708, 1.231160, 1.172611, 1.114062, 1.055513, 0.996964, 0.938416, 0.879867, 0.821318, 0.762769, 0.704220, 0.645672, 0.587123, 0.528574, 0.470025, 0.411476, 0.352928, 0.294379, 0.235830, 1.777281, 1.718732, 1.660184, 1.601635, 1.543086, 1.484537, 1.425988, 1.367440, 1.308891, 1.250342, 1.191793, 1.133244, 1.074696, 1.016147, 0.957598, 0.899049, 0.840500, 0.781952, 0.723403, 0.664854, 0.606305, 0.547756, 0.489208, 0.430659, 0.372110, 0.313561, 0.255012, 1.796464, 1.737915, 1.679366, 1.620817, 1.562268, 1.503720]).map Float.toBits))
#eval IO.println ("hashemiLoop " ++ toString ((hashemiLoop 1.508595 1.450046 1.391497 1.332948 1.274400 1.215851 1.157302 1.098753 1.040204 0.981656 0.923107 0.864558 0.806009 0.747460 0.688912 0.630363 0.571814 0.513265 0.454716 0.396168 0.337619 0.279070 0.220521 1.761972 1.703424 1.644875 1.586326 1.527777 1.469228 1.410680 1.352131 1.293582 1.235033 1.176484 1.117936 1.059387 1.000838 0.942289 0.883740 0.825192 0.766643 0.708094 0.649545 0.590996 0.532448 0.473899 0.415350 0.356801 0.298252 0.239704 1.781155 1.722606 #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979, 0.848430, 0.789881, 0.731332, 0.672784, 0.614235, 0.555686, 0.497137, 0.438588, 0.380040, 0.321491, 0.262942, 0.204393, 1.745844, 1.687296, 1.628747, 1.570198, 1.511649, 1.453100, 1.394552, 1.336003, 1.277454, 1.218905, 1.160356, 1.101808, 1.043259, 0.984710, 0.926161, 0.867612, 0.809064, 0.750515, 0.691966, 0.633417, 0.574868, 0.516320, 0.457771, 0.399222, 0.340673, 0.282124, 0.223576, 1.765027, 1.706478, 1.647929, 1.589380, 1.530832, 1.472283, 1.413734, 1.355185, 1.296636, 1.238088, 1.179539, 1.120990, 1.062441, 1.003892, 0.945344, 0.886795, 0.828246, 0.769697, 0.711148, 0.652600, 0.594051, 0.535502, 0.476953, 0.418404, 0.359856, 0.301307, 0.242758, 1.784209, 1.725660, 1.667112, 1.608563, 1.550014, 1.491465, 1.432916, 1.374368, 1.315819, 1.257270, 1.198721, 1.140172, 1.081624, 1.023075, 0.964526, 0.905977, 0.847428, 0.788880, 0.730331, 0.671782, 0.613233, 0.554684, 0.496136, 0.437587, 0.379038, 0.320489, 0.261940, 0.203392, 1.744843, 1.686294, 1.627745, 1.569196, 1.510648, 1.452099, 1.393550, 1.335001, 1.276452, 1.217904, 1.159355, 1.100806, 1.042257, 0.983708, 0.925160, 0.866611, 0.808062, 0.749513, 0.690964, 0.632416, 0.573867, 0.515318, 0.456769, 0.398220, 0.339672, 0.281123, 0.222574, 1.764025, 1.705476, 1.646928, 1.588379, 1.529830, 1.471281, 1.412732, 1.354184, 1.295635, 1.237086, 1.178537, 1.119988, 1.061440, 1.002891, 0.944342, 0.885793, 0.827244, 0.768696, 0.710147, 0.651598, 0.593049, 0.534500, 0.475952, 0.417403, 0.358854, 0.300305, 0.241756, 1.783208, 1.724659, 1.666110, 1.607561, 1.549012, 1.490464, 1.431915, 1.373366, 1.314817, 1.256268, 1.197720, 1.139171] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979, 0.848430, 0.789881, 0.731332, 0.672784, 0.614235, 0.555686, 0.497137, 0.438588, 0.380040, 0.321491, 0.262942, 0.204393, 1.745844, 1.687296, 1.628747, 1.570198, 1.511649, 1.453100, 1.394552, 1.336003, 1.277454, 1.218905, 1.160356, 1.101808, 1.043259, 0.984710, 0.926161, 0.867612, 0.809064, 0.750515, 0.691966, 0.633417] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979] #[1.785211, 1.726662, 1.668113, 1.609564, 1.551016, 1.492467, 1.433918, 1.375369, 1.316820, 1.258272, 1.199723, 1.141174, 1.082625, 1.024076, 0.965528, 0.906979, 0.848430, 0.789881, 0.731332, 0.672784, 0.614235, 0.555686, 0.497137, 0.438588, 0.380040, 0.321491, 0.262942, 0.204393, 1.745844, 1.687296, 1.628747, 1.570198, 1.511649, 1.453100, 1.394552, 1.336003, 1.277454, 1.218905, 1.160356, 1.101808, 1.043259, 0.984710, 0.926161, 0.867612, 0.809064, 0.750515, 0.691966, 0.633417, 0.574868, 0.516320, 0.457771, 0.399222, 0.340673, 0.282124, 0.223576, 1.765027, 1.706478, 1.647929, 1.589380, 1.530832, 1.472283, 1.413734, 1.355185, 1.296636, 1.238088, 1.179539, 1.120990, 1.062441, 1.003892, 0.945344, 0.886795, 0.828246, 0.769697, 0.711148, 0.652600, 0.594051, 0.535502, 0.476953, 0.418404, 0.359856, 0.301307, 0.242758, 1.784209, 1.725660, 1.667112, 1.608563, 1.550014, 1.491465, 1.432916, 1.374368, 1.315819, 1.257270, 1.198721, 1.140172, 1.081624, 1.023075, 0.964526, 0.905977, 0.847428, 0.788880, 0.730331, 0.671782, 0.613233, 0.554684, 0.496136, 0.437587, 0.379038, 0.320489, 0.261940, 0.203392, 1.744843, 1.686294, 1.627745, 1.569196, 1.510648, 1.452099, 1.393550, 1.335001, 1.276452, 1.217904, 1.159355, 1.100806, 1.042257, 0.983708, 0.925160, 0.866611, 0.808062, 0.749513, 0.690964, 0.632416, 0.573867, 0.515318, 0.456769, 0.398220, 0.339672, 0.281123, 0.222574, 1.764025, 1.705476, 1.646928, 1.588379, 1.529830, 1.471281, 1.412732, 1.354184, 1.295635, 1.237086, 1.178537, 1.119988, 1.061440, 1.002891, 0.944342, 0.885793, 0.827244, 0.768696, 0.710147, 0.651598, 0.593049, 0.534500, 0.475952, 0.417403, 0.358854, 0.300305, 0.241756, 1.783208, 1.724659, 1.666110, 1.607561, 1.549012, 1.490464, 1.431915, 1.373366, 1.314817, 1.256268, 1.197720, 1.139171, 1.080622, 1.022073, 0.963524, 0.904976, 0.846427, 0.787878, 0.729329, 0.670780, 0.612232, 0.553683, 0.495134, 0.436585, 0.378036, 0.319488, 0.260939, 0.202390, 1.743841, 1.685292, 1.626744, 1.568195, 1.509646, 1.451097, 1.392548, 1.334000, 1.275451, 1.216902, 1.158353, 1.099804, 1.041256, 0.982707, 0.924158, 0.865609, 0.807060, 0.748512, 0.689963, 0.631414, 0.572865, 0.514316, 0.455768, 0.397219, 0.338670, 0.280121, 0.221572, 1.763024, 1.704475, 1.645926, 1.587377, 1.528828, 1.470280, 1.411731, 1.353182, 1.294633, 1.236084, 1.177536, 1.118987, 1.060438, 1.001889, 0.943340, 0.884792, 0.826243, 0.767694, 0.709145, 0.650596, 0.592048, 0.533499, 0.474950, 0.416401, 0.357852, 0.299304, 0.240755, 1.782206, 1.723657, 1.665108, 1.606560, 1.548011, 1.489462, 1.430913, 1.372364, 1.313816, 1.255267, 1.196718, 1.138169, 1.079620, 1.021072, 0.962523, 0.903974, 0.845425, 0.786876, 0.728328, 0.669779, 0.611230, 0.552681, 0.494132, 0.435584, 0.377035, 0.318486, 0.259937, 0.201388, 1.742840, 1.684291, 1.625742, 1.567193, 1.508644, 1.450096, 1.391547, 1.332998, 1.274449, 1.215900, 1.157352, 1.098803, 1.040254, 0.981705, 0.923156, 0.864608, 0.806059, 0.747510, 0.688961, 0.630412, 0.571864, 0.513315, 0.454766, 0.396217, 0.337668, 0.279120, 0.220571, 1.762022, 1.703473, 1.644924, 1.586376, 1.527827, 1.469278, 1.410729, 1.352180, 1.293632, 1.235083, 1.176534, 1.117985, 1.059436, 1.000888, 0.942339, 0.883790, 0.825241, 0.766692, 0.708144, 0.649595, 0.591046, 0.532497, 0.473948, 0.415400, 0.356851, 0.298302, 0.239753, 1.781204, 1.722656, 1.664107, 1.605558, 1.547009, 1.488460, 1.429912, 1.371363, 1.312814, 1.254265, 1.195716, 1.137168, 1.078619, 1.020070, 0.961521, 0.902972, 0.844424, 0.785875, 0.727326, 0.668777, 0.610228, 0.551680, 0.493131, 0.434582, 0.376033, 0.317484, 0.258936, 0.200387, 1.741838, 1.683289, 1.624740, 1.566192, 1.507643, 1.449094, 1.390545, 1.331996, 1.273448, 1.214899, 1.156350, 1.097801, 1.039252, 0.980704, 0.922155, 0.863606, 0.805057, 0.746508, 0.687960, 0.629411, 0.570862, 0.512313, 0.453764, 0.395216, 0.336667, 0.278118, 0.219569, 1.761020, 1.702472, 1.643923, 1.585374, 1.526825, 1.468276, 1.409728, 1.351179, 1.292630, 1.234081, 1.175532, 1.116984, 1.058435, 0.999886, 0.941337, 0.882788, 0.824240, 0.765691, 0.707142, 0.648593, 0.590044, 0.531496, 0.472947, 0.414398, 0.355849, 0.297300, 0.238752, 1.780203, 1.721654, 1.663105, 1.604556, 1.546008, 1.487459, 1.428910, 1.370361, 1.311812, 1.253264, 1.194715, 1.136166, 1.077617, 1.019068, 0.960520, 0.901971, 0.843422, 0.784873, 0.726324, 0.667776, 0.609227, 0.550678, 0.492129, 0.433580, 0.375032, 0.316483, 0.257934, 1.799385, 1.740836, 1.682288, 1.623739, 1.565190, 1.506641, 1.448092, 1.389544, 1.330995, 1.272446, 1.213897, 1.155348, 1.096800, 1.038251, 0.979702, 0.921153, 0.862604, 0.804056, 0.745507, 0.686958, 0.628409, 0.569860, 0.511312, 0.452763, 0.394214, 0.335665, 0.277116, 0.218568, 1.760019, 1.701470, 1.642921, 1.584372, 1.525824, 1.467275, 1.408726, 1.350177, 1.291628, 1.233080, 1.174531, 1.115982, 1.057433, 0.998884, 0.940336, 0.881787, 0.823238, 0.764689, 0.706140, 0.647592, 0.589043, 0.530494, 0.471945, 0.413396, 0.354848, 0.296299, 0.237750, 1.779201, 1.720652, 1.662104, 1.603555, 1.545006, 1.486457, 1.427908, 1.369360, 1.310811, 1.252262, 1.193713, 1.135164, 1.076616, 1.018067, 0.959518, 0.900969, 0.842420, 0.783872, 0.725323, 0.666774, 0.608225, 0.549676, 0.491128, 0.432579, 0.374030, 0.315481, 0.256932, 1.798384, 1.739835, 1.681286, 1.622737, 1.564188, 1.505640, 1.447091, 1.388542, 1.329993, 1.271444, 1.212896, 1.154347, 1.095798, 1.037249, 0.978700, 0.920152, 0.861603, 0.803054, 0.744505, 0.685956, 0.627408, 0.568859, 0.510310, 0.451761, 0.393212, 0.334664, 0.276115, 0.217566, 1.759017, 1.700468, 1.641920, 1.583371, 1.524822, 1.466273, 1.407724, 1.349176, 1.290627, 1.232078, 1.173529, 1.114980, 1.056432, 0.997883, 0.939334, 0.880785, 0.822236, 0.763688, 0.705139, 0.646590, 0.588041, 0.529492, 0.470944, 0.412395, 0.353846, 0.295297, 0.236748, 1.778200, 1.719651, 1.661102, 1.602553, 1.544004, 1.485456, 1.426907, 1.368358, 1.309809, 1.251260, 1.192712, 1.134163, 1.075614, 1.017065, 0.958516, 0.899968, 0.841419, 0.782870, 0.724321, 0.665772, 0.607224, 0.548675, 0.490126, 0.431577, 0.373028, 0.314480, 0.255931, 1.797382, 1.738833, 1.680284, 1.621736, 1.563187, 1.504638, 1.446089, 1.387540, 1.328992, 1.270443, 1.211894, 1.153345, 1.094796, 1.036248, 0.977699, 0.919150, 0.860601, 0.802052, 0.743504, 0.684955, 0.626406, 0.567857, 0.509308, 0.450760, 0.392211, 0.333662, 0.275113, 0.216564, 1.758016, 1.699467, 1.640918, 1.582369, 1.523820, 1.465272, 1.406723, 1.348174, 1.289625, 1.231076, 1.172528]).map Float.toBits))

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

#eval IO.println ("headToCmd " ++ toString (headToCmd 0.867915).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 0.536723).toBits)
#eval IO.println ("headToCmd " ++ toString (headToCmd 0.205531).toBits)

def headToDriveAz (h : Float) (rw : Float) (R : Float) : Float :=
  ((((((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float)) * (((0.035 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * R) / rw)

#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 0.681763 0.623214 0.564665).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 0.350571 0.292022 0.233473).toBits)
#eval IO.println ("headToDriveAz " ++ toString (headToDriveAz 1.619379 1.560830 1.502281).toBits)

def headToDriveEl (h : Float) (arm : Float) (rDrum : Float) : Float :=
  ((((-(((min (max h (0 : Float)) (6 : Float)) - (3 : Float)) / (3 : Float))) * (((0.025 : Float) * (3.141592653589793 : Float)) / (180 : Float))) * arm) / rDrum)

#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 0.495611 0.437062 0.378513).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.764419 1.705870 1.647321).toBits)
#eval IO.println ("headToDriveEl " ++ toString (headToDriveEl 1.433227 1.374678 1.316129).toBits)

def heatParams  : Array Float :=
  #[(0.9 : Float), (0.8 : Float), (0.03 : Float), (15 : Float), (0.92 : Float), (15 : Float), (6300 : Float), (593 : Float)]

#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))
#eval IO.println ("heatParams " ++ toString ((heatParams).map Float.toBits))

def heatStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Array Float :=
  let v22 := (Toil - Ta)
  #[(min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil))), (alpha * Pin), ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : Float) (UAx * (Toil - Twall))), ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))]

#eval IO.println ("heatStep " ++ toString ((heatStep 1.723307 1.664758 1.606209 1.547660 1.489112 1.430563 1.372014 1.313465 1.254916 1.196368 1.137819 1.079270 1.020721).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 1.392115 1.333566 1.275017 1.216468 1.157920 1.099371 1.040822 0.982273 0.923724 0.865176 0.806627 0.748078 0.689529).map Float.toBits))
#eval IO.println ("heatStep " ++ toString ((heatStep 1.060923 1.002374 0.943825 0.885276 0.826728 0.768179 0.709630 0.651081 0.592532 0.533984 0.475435 0.416886 0.358337).map Float.toBits))

def helixAdvance (pitch : Float) (phi : Float) : Float :=
  ((pitch * phi) / ((2 : Float) * (3.141592653589793 : Float)))

#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.537155 1.478606).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 1.205963 1.147414).toBits)
#eval IO.println ("helixAdvance " ++ toString (helixAdvance 0.874771 0.816222).toBits)

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

#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 1.164851 1.106302).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.833659 0.775110).map Float.toBits))
#eval IO.println ("hingeWrench " ++ toString ((hingeWrench 0.502467 0.443918).map Float.toBits))

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

#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.978699 0.920150 0.861601 0.803052 0.744504 0.685955 0.627406 0.568857))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.647507 0.588958 0.530409 0.471860 0.413312 0.354763 0.296214 0.237665))
#eval IO.println ("check_hinge_freedom " ++ toString (check_hinge_freedom 0.316315 0.257766 1.799217 1.740668 1.682120 1.623571 1.565022 1.506473))

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

#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.792547 0.733998 0.675449 0.616900 0.558352 0.499803 0.441254 0.382705 0.324156))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 0.461355 0.402806 0.344257 0.285708 0.227160 1.768611 1.710062 1.651513 1.592964))
#eval IO.println ("check_hinge_freedom_smul " ++ toString (check_hinge_freedom_smul 1.730163 1.671614 1.613065 1.554516 1.495968 1.437419 1.378870 1.320321 1.261772))

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

#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.606395 0.547846 0.489297))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 0.275203 0.216654 1.758105))
#eval IO.println ("check_hinge_reciprocal_swing " ++ toString (check_hinge_reciprocal_swing 1.544011 1.485462 1.426913))

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

#eval IO.println ("hyperHit " ++ toString ((hyperHit 0.234091 1.775542 1.716993 1.658444 1.599896 1.541347 1.482798 1.424249 1.365700 1.307152 1.248603).map Float.toBits))
#eval IO.println ("hyperHit " ++ toString ((hyperHit 1.502899 1.444350 1.385801 1.327252 1.268704 1.210155 1.151606 1.093057 1.034508 0.975960 0.917411).map Float.toBits))
#eval IO.println ("hyperHit " ++ toString ((hyperHit 1.171707 1.113158 1.054609 0.996060 0.937512 0.878963 0.820414 0.761865 0.703316 0.644768 0.586219).map Float.toBits))

def landAt (H_0 : Float) (H_1 : Float) (H_2 : Float) (r_0 : Float) (r_1 : Float) (r_2 : Float) (p : Float) : Array Float :=
  let v8 := ((p - H_2) / r_2)
  #[(H_0 + (v8 * r_0)), (H_1 + (v8 * r_1))]

#eval IO.println ("landAt " ++ toString ((landAt 1.647939 1.589390 1.530841 1.472292 1.413744 1.355195 1.296646).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 1.316747 1.258198 1.199649 1.141100 1.082552 1.024003 0.965454).map Float.toBits))
#eval IO.println ("landAt " ++ toString ((landAt 0.985555 0.927006 0.868457 0.809908 0.751360 0.692811 0.634262).map Float.toBits))

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

#eval IO.println ("lerp8 " ++ toString (lerp8 1.275635 1.217086 1.158537 1.099988 1.041440 0.982891 0.924342 0.865793 0.807244).toBits)
#eval IO.println ("lerp8 " ++ toString (lerp8 0.944443 0.885894 0.827345 0.768796 0.710248 0.651699 0.593150 0.534601 0.476052).toBits)
#eval IO.println ("lerp8 " ++ toString (lerp8 0.613251 0.554702 0.496153 0.437604 0.379056 0.320507 0.261958 0.203409 1.744860).toBits)

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

#eval IO.println ("check_lerp8_zero " ++ toString (check_lerp8_zero 1.089483 1.030934 0.972385 0.913836 0.855288 0.796739 0.738190 0.679641))
#eval IO.println ("check_lerp8_zero " ++ toString (check_lerp8_zero 0.758291 0.699742 0.641193 0.582644 0.524096 0.465547 0.406998 0.348449))
#eval IO.println ("check_lerp8_zero " ++ toString (check_lerp8_zero 0.427099 0.368550 0.310001 0.251452 1.792904 1.734355 1.675806 1.617257))

def leverAt (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Float :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2))))

#eval IO.println ("leverAt " ++ toString (leverAt 0.903331 0.844782 0.786233 0.727684 0.669136).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.572139 0.513590 0.455041 0.396492 0.337944).toBits)
#eval IO.println ("leverAt " ++ toString (leverAt 0.240947 1.782398 1.723849 1.665300 1.606752).toBits)

def loopCap (mOil : Float) (mCu : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  ((mOil * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * (v4 ^ 2))))) + (mCu * (385 : Float)))

#eval IO.println ("loopCap " ++ toString (loopCap 0.717179 0.658630 0.600081).toBits)
#eval IO.println ("loopCap " ++ toString (loopCap 0.385987 0.327438 0.268889).toBits)
#eval IO.println ("loopCap " ++ toString (loopCap 1.654795 1.596246 1.537697).toBits)

def loopStep (Coil : Float) (qAbs : Float) (qLoss : Float) (qPipe : Float) (qPot : Float) (Toil : Float) (dt : Float) : Float :=
  (min (618.15 : Float) (Toil + ((dt * (((qAbs - qLoss) - qPipe) - qPot)) / Coil)))

#eval IO.println ("loopStep " ++ toString (loopStep 0.531027 0.472478 0.413929 0.355380 0.296832 0.238283 1.779734).toBits)
#eval IO.println ("loopStep " ++ toString (loopStep 1.799835 1.741286 1.682737 1.624188 1.565640 1.507091 1.448542).toBits)
#eval IO.println ("loopStep " ++ toString (loopStep 1.468643 1.410094 1.351545 1.292996 1.234448 1.175899 1.117350).toBits)

def check_loopStep_balance (Coil : Float) (qAbs : Float) (qLoss : Float) (qPipe : Float) (qPot : Float) (Toil : Float) (dt : Float) : Bool :=
  let v11 := (((qAbs - qLoss) - qPipe) - qPot)
  let v14 := (Toil + ((dt * v11) / Coil))
  (!(!(feq Coil (0 : Float))) || (!(v14 <= (618.15 : Float)) || ((feq ((Coil * ((min (618.15 : Float) v14) - Toil)) / dt) v11) || (feq dt (0 : Float)))))

#eval IO.println ("check_loopStep_balance " ++ toString (check_loopStep_balance 0.344875 0.286326 0.227777 1.769228 1.710680 1.652131 1.593582))
#eval IO.println ("check_loopStep_balance " ++ toString (check_loopStep_balance 1.613683 1.555134 1.496585 1.438036 1.379488 1.320939 1.262390))
#eval IO.println ("check_loopStep_balance " ++ toString (check_loopStep_balance 1.282491 1.223942 1.165393 1.106844 1.048296 0.989747 0.931198))

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

#eval IO.println ("lostSunS " ++ toString (lostSunS 1.758723 1.700174 1.641625 1.583076 1.524528 1.465979).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 1.427531 1.368982 1.310433 1.251884 1.193336 1.134787).toBits)
#eval IO.println ("lostSunS " ++ toString (lostSunS 1.096339 1.037790 0.979241 0.920692 0.862144 0.803595).toBits)

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

#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.572571 1.514022 1.455473 1.396924 1.338376 1.279827))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 1.241379 1.182830 1.124281 1.065732 1.007184 0.948635))
#eval IO.println ("check_lostSunS_le_reach " ++ toString (check_lostSunS_le_reach 0.910187 0.851638 0.793089 0.734540 0.675992 0.617443))

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

#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.386419 1.327870 1.269321 1.210772 1.152224 1.093675))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 1.055227 0.996678 0.938129 0.879580 0.821032 0.762483))
#eval IO.println ("check_lostSun_unreachable " ++ toString (check_lostSun_unreachable 0.724035 0.665486 0.606937 0.548388 0.489840 0.431291))

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

#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 1.200267 1.141718 1.083169 1.024620 0.966072 0.907523))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.869075 0.810526 0.751977 0.693428 0.634880 0.576331))
#eval IO.println ("check_lostSun_within_budget " ++ toString (check_lostSun_within_budget 0.537883 0.479334 0.420785 0.362236 0.303688 0.245139))

def check_lowestSun_tan_at_ym  : Bool :=
  let v5 := ((Float.sqrt (3.36 : Float)) - (1 : Float))
  let v15 := ((1 : Float) / ((((1.22 : Float) * v5) + ((0.34 : Float) * (0.8 : Float))) / (((1.22 : Float) * (0.8 : Float)) - ((0.34 : Float) * v5))))
  (((0.537 : Float) < v15) && (v15 < (0.538 : Float)))

#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))
#eval IO.println ("check_lowestSun_tan_at_ym " ++ toString (check_lowestSun_tan_at_ym))

def check_m12_carries_dish (W : Float) : Bool :=
  (!(W <= (1000 : Float)) || ((((W / (2 : Float)) * (0.03 : Float)) / (((3.141592653589793 : Float) * ((0.0101 : Float) ^ 3)) / (32 : Float))) < (16e7 : Float)))

#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.827963))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 0.496771))
#eval IO.println ("check_m12_carries_dish " ++ toString (check_m12_carries_dish 1.765579))

def check_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))
#eval IO.println ("check_mastClears_hashemi " ++ toString (check_mastClears_hashemi))

def check_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v4 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v4 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v4))) < ym))

#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 0.455659))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.724467))
#eval IO.println ("check_mastClears_hashemi_iff " ++ toString (check_mastClears_hashemi_iff 1.393275))

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

#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.497203 1.438654 1.380105 1.321556 1.263008 1.204459 1.145910 1.087361 1.028812 0.970264 0.911715 0.853166 0.794617 0.736068 0.677520 0.618971 0.560422).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 1.166011 1.107462 1.048913 0.990364 0.931816 0.873267 0.814718 0.756169 0.697620 0.639072 0.580523 0.521974 0.463425 0.404876 0.346328 0.287779 0.229230).map Float.toBits))
#eval IO.println ("megaGeom " ++ toString ((megaGeom 0.834819 0.776270 0.717721 0.659172 0.600624 0.542075 0.483526 0.424977 0.366428 0.307880 0.249331 1.790782 1.732233 1.673684 1.615136 1.556587 1.498038).map Float.toBits))

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

#eval IO.println ("megaReqs " ++ toString ((megaReqs 1.124899 1.066350 1.007801 0.949252 0.890704 0.832155 0.773606 0.715057 0.656508 0.597960 0.539411 0.480862 0.422313 0.363764 0.305216 0.246667 1.788118).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.793707 0.735158 0.676609 0.618060 0.559512 0.500963 0.442414 0.383865 0.325316 0.266768 0.208219 1.749670 1.691121 1.632572 1.574024 1.515475 1.456926).map Float.toBits))
#eval IO.println ("megaReqs " ++ toString ((megaReqs 0.462515 0.403966 0.345417 0.286868 0.228320 1.769771 1.711222 1.652673 1.594124 1.535576 1.477027 1.418478 1.359929 1.301380 1.242832 1.184283 1.125734).map Float.toBits))

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

#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.938747 0.880198 0.821649 0.763100 0.704552 0.646003 0.587454 0.528905 0.470356 0.411808 0.353259 0.294710 0.236161 1.777612 1.719064 1.660515 1.601966).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.607555 0.549006 0.490457 0.431908 0.373360 0.314811 0.256262 1.797713 1.739164 1.680616 1.622067 1.563518 1.504969 1.446420 1.387872 1.329323 1.270774).map Float.toBits))
#eval IO.println ("megaScrew " ++ toString ((megaScrew 0.276363 0.217814 1.759265 1.700716 1.642168 1.583619 1.525070 1.466521 1.407972 1.349424 1.290875 1.232326 1.173777 1.115228 1.056680 0.998131 0.939582).map Float.toBits))

def megaScrew_ω (t : Float) (omegad : Float) (rDrum : Float) : Float :=
  let v5 := (-(1.22 : Float))
  let v8 := (-(0.8 : Float))
  let v9 := (Float.cos t)
  let v19 := (-((1 : Float) - ((2 : Float) - (Float.sqrt (((2 : Float) ^ 2) - ((0.8 : Float) ^ 2))))))
  let v20 := (Float.sin t)
  let v22 := ((v8 * v9) + (v19 * v20))
  let v26 := (((-v8) * v20) + (v19 * v9))
  ((omegad * rDrum) / (((v5 * v26) - ((0.34 : Float) * v22)) / (Float.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : Float)) ^ 2)))))

#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.752595 0.694046 0.635497).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 0.421403 0.362854 0.304305).toBits)
#eval IO.println ("megaScrew_ω " ++ toString (megaScrew_ω 1.690211 1.631662 1.573113).toBits)

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

#eval IO.println ("megaStep " ++ toString ((megaStep 0.566443 0.507894 0.449345 0.390796 0.332248 0.273699 0.215150 1.756601 1.698052 1.639504 1.580955 1.522406 1.463857 1.405308 1.346760 1.288211 1.229662).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 0.235251 1.776702 1.718153 1.659604 1.601056 1.542507 1.483958 1.425409 1.366860 1.308312 1.249763 1.191214 1.132665 1.074116 1.015568 0.957019 0.898470).map Float.toBits))
#eval IO.println ("megaStep " ++ toString ((megaStep 1.504059 1.445510 1.386961 1.328412 1.269864 1.211315 1.152766 1.094217 1.035668 0.977120 0.918571 0.860022 0.801473 0.742924 0.684376 0.625827 0.567278).map Float.toBits))

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

#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 0.380291 0.321742 0.263193 0.204644 1.746096 1.687547 1.628998 1.570449 1.511900 1.453352 1.394803 1.336254 1.277705 1.219156 1.160608 1.102059 1.043510).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.649099 1.590550 1.532001 1.473452 1.414904 1.356355 1.297806 1.239257 1.180708 1.122160 1.063611 1.005062 0.946513 0.887964 0.829416 0.770867 0.712318).map Float.toBits))
#eval IO.println ("megaThmsClosed " ++ toString ((megaThmsClosed 1.317907 1.259358 1.200809 1.142260 1.083712 1.025163 0.966614 0.908065 0.849516 0.790968 0.732419 0.673870 0.615321 0.556772 0.498224 0.439675 0.381126).map Float.toBits))

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

#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.794139 1.735590 1.677041 1.618492 1.559944 1.501395 1.442846 1.384297 1.325748 1.267200 1.208651 1.150102 1.091553 1.033004 0.974456 0.915907 0.857358).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.462947 1.404398 1.345849 1.287300 1.228752 1.170203 1.111654 1.053105 0.994556 0.936008 0.877459 0.818910 0.760361 0.701812 0.643264 0.584715 0.526166).map Float.toBits))
#eval IO.println ("megaThmsState " ++ toString ((megaThmsState 1.131755 1.073206 1.014657 0.956108 0.897560 0.839011 0.780462 0.721913 0.663364 0.604816 0.546267 0.487718 0.429169 0.370620 0.312072 0.253523 1.794974).map Float.toBits))

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

#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 1.607987 1.549438 1.490889 1.432340 1.373792 1.315243 1.256694 1.198145 1.139596 1.081048 1.022499 0.963950 0.905401 0.846852 #[0.284603, 0.226054, 1.767505, 1.708956, 1.650408, 1.591859, 1.533310, 1.474761, 1.416212, 1.357664, 1.299115, 1.240566, 1.182017, 1.123468, 1.064920, 1.006371, 0.947822, 0.889273, 0.830724, 0.772176, 0.713627, 0.655078, 0.596529, 0.537980, 0.479432, 0.420883, 0.362334, 0.303785, 0.245236, 1.786688, 1.728139, 1.669590, 1.611041, 1.552492, 1.493944, 1.435395, 1.376846, 1.318297, 1.259748, 1.201200, 1.142651, 1.084102, 1.025553, 0.967004, 0.908456, 0.849907, 0.791358, 0.732809, 0.674260, 0.615712, 0.557163, 0.498614, 0.440065, 0.381516, 0.322968, 0.264419, 0.205870, 1.747321, 1.688772, 1.630224, 1.571675, 1.513126, 1.454577, 1.396028, 1.337480, 1.278931, 1.220382, 1.161833, 1.103284, 1.044736, 0.986187, 0.927638, 0.869089, 0.810540, 0.751992, 0.693443, 0.634894, 0.576345, 0.517796, 0.459248, 0.400699, 0.342150, 0.283601, 0.225052, 1.766504, 1.707955, 1.649406, 1.590857, 1.532308, 1.473760, 1.415211, 1.356662, 1.298113, 1.239564, 1.181016, 1.122467, 1.063918, 1.005369, 0.946820, 0.888272, 0.829723, 0.771174, 0.712625, 0.654076, 0.595528, 0.536979, 0.478430, 0.419881, 0.361332, 0.302784, 0.244235, 1.785686, 1.727137, 1.668588, 1.610040, 1.551491, 1.492942, 1.434393, 1.375844, 1.317296, 1.258747, 1.200198, 1.141649, 1.083100, 1.024552, 0.966003, 0.907454, 0.848905, 0.790356, 0.731808, 0.673259, 0.614710, 0.556161, 0.497612, 0.439064, 0.380515, 0.321966, 0.263417, 0.204868, 1.746320, 1.687771, 1.629222, 1.570673, 1.512124, 1.453576, 1.395027, 1.336478, 1.277929, 1.219380, 1.160832, 1.102283, 1.043734, 0.985185, 0.926636, 0.868088, 0.809539, 0.750990, 0.692441, 0.633892, 0.575344, 0.516795, 0.458246, 0.399697, 0.341148, 0.282600, 0.224051, 1.765502, 1.706953, 1.648404, 1.589856, 1.531307, 1.472758, 1.414209, 1.355660, 1.297112, 1.238563] #[0.284603, 0.226054, 1.767505, 1.708956, 1.650408, 1.591859, 1.533310, 1.474761, 1.416212, 1.357664, 1.299115, 1.240566, 1.182017, 1.123468, 1.064920, 1.006371] #[0.284603, 0.226054, 1.767505, 1.708956, 1.650408, 1.591859, 1.533310, 1.474761, 1.416212, 1.357664, 1.299115, 1.240566, 1.182017, 1.123468, 1.064920, 1.006371, 0.947822, 0.889273, 0.830724, 0.772176, 0.713627, 0.655078, 0.596529, 0.537980, 0.479432, 0.420883, 0.362334, 0.303785, 0.245236, 1.786688, 1.728139, 1.669590, 1.611041, 1.552492, 1.493944, 1.435395, 1.376846, 1.318297, 1.259748, 1.201200, 1.142651, 1.084102, 1.025553, 0.967004, 0.908456, 0.849907, 0.791358, 0.732809]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 1.276795 1.218246 1.159697 1.101148 1.042600 0.984051 0.925502 0.866953 0.808404 0.749856 0.691307 0.632758 0.574209 0.515660 #[1.553411, 1.494862, 1.436313, 1.377764, 1.319216, 1.260667, 1.202118, 1.143569, 1.085020, 1.026472, 0.967923, 0.909374, 0.850825, 0.792276, 0.733728, 0.675179, 0.616630, 0.558081, 0.499532, 0.440984, 0.382435, 0.323886, 0.265337, 0.206788, 1.748240, 1.689691, 1.631142, 1.572593, 1.514044, 1.455496, 1.396947, 1.338398, 1.279849, 1.221300, 1.162752, 1.104203, 1.045654, 0.987105, 0.928556, 0.870008, 0.811459, 0.752910, 0.694361, 0.635812, 0.577264, 0.518715, 0.460166, 0.401617, 0.343068, 0.284520, 0.225971, 1.767422, 1.708873, 1.650324, 1.591776, 1.533227, 1.474678, 1.416129, 1.357580, 1.299032, 1.240483, 1.181934, 1.123385, 1.064836, 1.006288, 0.947739, 0.889190, 0.830641, 0.772092, 0.713544, 0.654995, 0.596446, 0.537897, 0.479348, 0.420800, 0.362251, 0.303702, 0.245153, 1.786604, 1.728056, 1.669507, 1.610958, 1.552409, 1.493860, 1.435312, 1.376763, 1.318214, 1.259665, 1.201116, 1.142568, 1.084019, 1.025470, 0.966921, 0.908372, 0.849824, 0.791275, 0.732726, 0.674177, 0.615628, 0.557080, 0.498531, 0.439982, 0.381433, 0.322884, 0.264336, 0.205787, 1.747238, 1.688689, 1.630140, 1.571592, 1.513043, 1.454494, 1.395945, 1.337396, 1.278848, 1.220299, 1.161750, 1.103201, 1.044652, 0.986104, 0.927555, 0.869006, 0.810457, 0.751908, 0.693360, 0.634811, 0.576262, 0.517713, 0.459164, 0.400616, 0.342067, 0.283518, 0.224969, 1.766420, 1.707872, 1.649323, 1.590774, 1.532225, 1.473676, 1.415128, 1.356579, 1.298030, 1.239481, 1.180932, 1.122384, 1.063835, 1.005286, 0.946737, 0.888188, 0.829640, 0.771091, 0.712542, 0.653993, 0.595444, 0.536896, 0.478347, 0.419798, 0.361249, 0.302700, 0.244152, 1.785603, 1.727054, 1.668505, 1.609956, 1.551408, 1.492859, 1.434310, 1.375761, 1.317212, 1.258664, 1.200115, 1.141566, 1.083017, 1.024468, 0.965920, 0.907371] #[1.553411, 1.494862, 1.436313, 1.377764, 1.319216, 1.260667, 1.202118, 1.143569, 1.085020, 1.026472, 0.967923, 0.909374, 0.850825, 0.792276, 0.733728, 0.675179] #[1.553411, 1.494862, 1.436313, 1.377764, 1.319216, 1.260667, 1.202118, 1.143569, 1.085020, 1.026472, 0.967923, 0.909374, 0.850825, 0.792276, 0.733728, 0.675179, 0.616630, 0.558081, 0.499532, 0.440984, 0.382435, 0.323886, 0.265337, 0.206788, 1.748240, 1.689691, 1.631142, 1.572593, 1.514044, 1.455496, 1.396947, 1.338398, 1.279849, 1.221300, 1.162752, 1.104203, 1.045654, 0.987105, 0.928556, 0.870008, 0.811459, 0.752910, 0.694361, 0.635812, 0.577264, 0.518715, 0.460166, 0.401617]).map Float.toBits))
#eval IO.println ("mlpPolicy " ++ toString ((mlpPolicy 0.945603 0.887054 0.828505 0.769956 0.711408 0.652859 0.594310 0.535761 0.477212 0.418664 0.360115 0.301566 0.243017 1.784468 #[1.222219, 1.163670, 1.105121, 1.046572, 0.988024, 0.929475, 0.870926, 0.812377, 0.753828, 0.695280, 0.636731, 0.578182, 0.519633, 0.461084, 0.402536, 0.343987, 0.285438, 0.226889, 1.768340, 1.709792, 1.651243, 1.592694, 1.534145, 1.475596, 1.417048, 1.358499, 1.299950, 1.241401, 1.182852, 1.124304, 1.065755, 1.007206, 0.948657, 0.890108, 0.831560, 0.773011, 0.714462, 0.655913, 0.597364, 0.538816, 0.480267, 0.421718, 0.363169, 0.304620, 0.246072, 1.787523, 1.728974, 1.670425, 1.611876, 1.553328, 1.494779, 1.436230, 1.377681, 1.319132, 1.260584, 1.202035, 1.143486, 1.084937, 1.026388, 0.967840, 0.909291, 0.850742, 0.792193, 0.733644, 0.675096, 0.616547, 0.557998, 0.499449, 0.440900, 0.382352, 0.323803, 0.265254, 0.206705, 1.748156, 1.689608, 1.631059, 1.572510, 1.513961, 1.455412, 1.396864, 1.338315, 1.279766, 1.221217, 1.162668, 1.104120, 1.045571, 0.987022, 0.928473, 0.869924, 0.811376, 0.752827, 0.694278, 0.635729, 0.577180, 0.518632, 0.460083, 0.401534, 0.342985, 0.284436, 0.225888, 1.767339, 1.708790, 1.650241, 1.591692, 1.533144, 1.474595, 1.416046, 1.357497, 1.298948, 1.240400, 1.181851, 1.123302, 1.064753, 1.006204, 0.947656, 0.889107, 0.830558, 0.772009, 0.713460, 0.654912, 0.596363, 0.537814, 0.479265, 0.420716, 0.362168, 0.303619, 0.245070, 1.786521, 1.727972, 1.669424, 1.610875, 1.552326, 1.493777, 1.435228, 1.376680, 1.318131, 1.259582, 1.201033, 1.142484, 1.083936, 1.025387, 0.966838, 0.908289, 0.849740, 0.791192, 0.732643, 0.674094, 0.615545, 0.556996, 0.498448, 0.439899, 0.381350, 0.322801, 0.264252, 0.205704, 1.747155, 1.688606, 1.630057, 1.571508, 1.512960, 1.454411, 1.395862, 1.337313, 1.278764, 1.220216, 1.161667, 1.103118, 1.044569, 0.986020, 0.927472, 0.868923, 0.810374, 0.751825, 0.693276, 0.634728, 0.576179] #[1.222219, 1.163670, 1.105121, 1.046572, 0.988024, 0.929475, 0.870926, 0.812377, 0.753828, 0.695280, 0.636731, 0.578182, 0.519633, 0.461084, 0.402536, 0.343987] #[1.222219, 1.163670, 1.105121, 1.046572, 0.988024, 0.929475, 0.870926, 0.812377, 0.753828, 0.695280, 0.636731, 0.578182, 0.519633, 0.461084, 0.402536, 0.343987, 0.285438, 0.226889, 1.768340, 1.709792, 1.651243, 1.592694, 1.534145, 1.475596, 1.417048, 1.358499, 1.299950, 1.241401, 1.182852, 1.124304, 1.065755, 1.007206, 0.948657, 0.890108, 0.831560, 0.773011, 0.714462, 0.655913, 0.597364, 0.538816, 0.480267, 0.421718, 0.363169, 0.304620, 0.246072, 1.787523, 1.728974, 1.670425]).map Float.toBits))

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

#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.421835 1.363286 1.304737 1.246188 1.187640 1.129091 1.070542 1.011993 0.953444 0.894896 0.836347 0.777798 0.719249 0.660700 #[1.698451, 1.639902, 1.581353, 1.522804, 1.464256, 1.405707, 1.347158, 1.288609, 1.230060, 1.171512, 1.112963, 1.054414, 0.995865, 0.937316, 0.878768, 0.820219, 0.761670, 0.703121, 0.644572, 0.586024, 0.527475, 0.468926, 0.410377, 0.351828, 0.293280, 0.234731, 1.776182, 1.717633, 1.659084, 1.600536, 1.541987, 1.483438, 1.424889, 1.366340, 1.307792, 1.249243, 1.190694, 1.132145, 1.073596, 1.015048, 0.956499, 0.897950, 0.839401, 0.780852, 0.722304, 0.663755, 0.605206, 0.546657, 0.488108, 0.429560, 0.371011, 0.312462, 0.253913, 1.795364, 1.736816, 1.678267, 1.619718, 1.561169, 1.502620, 1.444072, 1.385523, 1.326974, 1.268425, 1.209876, 1.151328, 1.092779, 1.034230, 0.975681, 0.917132, 0.858584, 0.800035, 0.741486, 0.682937, 0.624388, 0.565840, 0.507291, 0.448742, 0.390193, 0.331644, 0.273096, 0.214547, 1.755998, 1.697449, 1.638900, 1.580352, 1.521803, 1.463254, 1.404705, 1.346156, 1.287608, 1.229059, 1.170510, 1.111961, 1.053412, 0.994864, 0.936315, 0.877766, 0.819217, 0.760668, 0.702120, 0.643571, 0.585022, 0.526473, 0.467924, 0.409376, 0.350827, 0.292278, 0.233729, 1.775180, 1.716632, 1.658083, 1.599534, 1.540985, 1.482436, 1.423888, 1.365339, 1.306790, 1.248241, 1.189692, 1.131144, 1.072595, 1.014046, 0.955497, 0.896948, 0.838400, 0.779851, 0.721302, 0.662753, 0.604204, 0.545656, 0.487107, 0.428558, 0.370009, 0.311460, 0.252912, 1.794363, 1.735814, 1.677265, 1.618716, 1.560168, 1.501619, 1.443070, 1.384521, 1.325972, 1.267424, 1.208875, 1.150326, 1.091777, 1.033228, 0.974680, 0.916131, 0.857582, 0.799033, 0.740484, 0.681936, 0.623387, 0.564838, 0.506289, 0.447740, 0.389192, 0.330643, 0.272094, 0.213545, 1.754996, 1.696448, 1.637899, 1.579350, 1.520801, 1.462252, 1.403704, 1.345155, 1.286606, 1.228057, 1.169508, 1.110960, 1.052411] #[1.698451, 1.639902, 1.581353, 1.522804, 1.464256, 1.405707, 1.347158, 1.288609, 1.230060, 1.171512, 1.112963, 1.054414, 0.995865, 0.937316, 0.878768, 0.820219] #[1.698451, 1.639902, 1.581353, 1.522804, 1.464256, 1.405707, 1.347158, 1.288609, 1.230060, 1.171512, 1.112963, 1.054414, 0.995865, 0.937316, 0.878768, 0.820219, 0.761670, 0.703121, 0.644572, 0.586024, 0.527475, 0.468926, 0.410377, 0.351828, 0.293280, 0.234731, 1.776182, 1.717633, 1.659084, 1.600536, 1.541987, 1.483438, 1.424889, 1.366340, 1.307792, 1.249243, 1.190694, 1.132145, 1.073596, 1.015048, 0.956499, 0.897950, 0.839401, 0.780852, 0.722304, 0.663755, 0.605206, 0.546657]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 1.090643 1.032094 0.973545 0.914996 0.856448 0.797899 0.739350 0.680801 0.622252 0.563704 0.505155 0.446606 0.388057 0.329508 #[1.367259, 1.308710, 1.250161, 1.191612, 1.133064, 1.074515, 1.015966, 0.957417, 0.898868, 0.840320, 0.781771, 0.723222, 0.664673, 0.606124, 0.547576, 0.489027, 0.430478, 0.371929, 0.313380, 0.254832, 1.796283, 1.737734, 1.679185, 1.620636, 1.562088, 1.503539, 1.444990, 1.386441, 1.327892, 1.269344, 1.210795, 1.152246, 1.093697, 1.035148, 0.976600, 0.918051, 0.859502, 0.800953, 0.742404, 0.683856, 0.625307, 0.566758, 0.508209, 0.449660, 0.391112, 0.332563, 0.274014, 0.215465, 1.756916, 1.698368, 1.639819, 1.581270, 1.522721, 1.464172, 1.405624, 1.347075, 1.288526, 1.229977, 1.171428, 1.112880, 1.054331, 0.995782, 0.937233, 0.878684, 0.820136, 0.761587, 0.703038, 0.644489, 0.585940, 0.527392, 0.468843, 0.410294, 0.351745, 0.293196, 0.234648, 1.776099, 1.717550, 1.659001, 1.600452, 1.541904, 1.483355, 1.424806, 1.366257, 1.307708, 1.249160, 1.190611, 1.132062, 1.073513, 1.014964, 0.956416, 0.897867, 0.839318, 0.780769, 0.722220, 0.663672, 0.605123, 0.546574, 0.488025, 0.429476, 0.370928, 0.312379, 0.253830, 1.795281, 1.736732, 1.678184, 1.619635, 1.561086, 1.502537, 1.443988, 1.385440, 1.326891, 1.268342, 1.209793, 1.151244, 1.092696, 1.034147, 0.975598, 0.917049, 0.858500, 0.799952, 0.741403, 0.682854, 0.624305, 0.565756, 0.507208, 0.448659, 0.390110, 0.331561, 0.273012, 0.214464, 1.755915, 1.697366, 1.638817, 1.580268, 1.521720, 1.463171, 1.404622, 1.346073, 1.287524, 1.228976, 1.170427, 1.111878, 1.053329, 0.994780, 0.936232, 0.877683, 0.819134, 0.760585, 0.702036, 0.643488, 0.584939, 0.526390, 0.467841, 0.409292, 0.350744, 0.292195, 0.233646, 1.775097, 1.716548, 1.658000, 1.599451, 1.540902, 1.482353, 1.423804, 1.365256, 1.306707, 1.248158, 1.189609, 1.131060, 1.072512, 1.013963, 0.955414, 0.896865, 0.838316, 0.779768, 0.721219] #[1.367259, 1.308710, 1.250161, 1.191612, 1.133064, 1.074515, 1.015966, 0.957417, 0.898868, 0.840320, 0.781771, 0.723222, 0.664673, 0.606124, 0.547576, 0.489027] #[1.367259, 1.308710, 1.250161, 1.191612, 1.133064, 1.074515, 1.015966, 0.957417, 0.898868, 0.840320, 0.781771, 0.723222, 0.664673, 0.606124, 0.547576, 0.489027, 0.430478, 0.371929, 0.313380, 0.254832, 1.796283, 1.737734, 1.679185, 1.620636, 1.562088, 1.503539, 1.444990, 1.386441, 1.327892, 1.269344, 1.210795, 1.152246, 1.093697, 1.035148, 0.976600, 0.918051, 0.859502, 0.800953, 0.742404, 0.683856, 0.625307, 0.566758, 0.508209, 0.449660, 0.391112, 0.332563, 0.274014, 0.215465]))
#eval IO.println ("check_mlpPolicy_bounded " ++ toString (check_mlpPolicy_bounded 0.759451 0.700902 0.642353 0.583804 0.525256 0.466707 0.408158 0.349609 0.291060 0.232512 1.773963 1.715414 1.656865 1.598316 #[1.036067, 0.977518, 0.918969, 0.860420, 0.801872, 0.743323, 0.684774, 0.626225, 0.567676, 0.509128, 0.450579, 0.392030, 0.333481, 0.274932, 0.216384, 1.757835, 1.699286, 1.640737, 1.582188, 1.523640, 1.465091, 1.406542, 1.347993, 1.289444, 1.230896, 1.172347, 1.113798, 1.055249, 0.996700, 0.938152, 0.879603, 0.821054, 0.762505, 0.703956, 0.645408, 0.586859, 0.528310, 0.469761, 0.411212, 0.352664, 0.294115, 0.235566, 1.777017, 1.718468, 1.659920, 1.601371, 1.542822, 1.484273, 1.425724, 1.367176, 1.308627, 1.250078, 1.191529, 1.132980, 1.074432, 1.015883, 0.957334, 0.898785, 0.840236, 0.781688, 0.723139, 0.664590, 0.606041, 0.547492, 0.488944, 0.430395, 0.371846, 0.313297, 0.254748, 1.796200, 1.737651, 1.679102, 1.620553, 1.562004, 1.503456, 1.444907, 1.386358, 1.327809, 1.269260, 1.210712, 1.152163, 1.093614, 1.035065, 0.976516, 0.917968, 0.859419, 0.800870, 0.742321, 0.683772, 0.625224, 0.566675, 0.508126, 0.449577, 0.391028, 0.332480, 0.273931, 0.215382, 1.756833, 1.698284, 1.639736, 1.581187, 1.522638, 1.464089, 1.405540, 1.346992, 1.288443, 1.229894, 1.171345, 1.112796, 1.054248, 0.995699, 0.937150, 0.878601, 0.820052, 0.761504, 0.702955, 0.644406, 0.585857, 0.527308, 0.468760, 0.410211, 0.351662, 0.293113, 0.234564, 1.776016, 1.717467, 1.658918, 1.600369, 1.541820, 1.483272, 1.424723, 1.366174, 1.307625, 1.249076, 1.190528, 1.131979, 1.073430, 1.014881, 0.956332, 0.897784, 0.839235, 0.780686, 0.722137, 0.663588, 0.605040, 0.546491, 0.487942, 0.429393, 0.370844, 0.312296, 0.253747, 1.795198, 1.736649, 1.678100, 1.619552, 1.561003, 1.502454, 1.443905, 1.385356, 1.326808, 1.268259, 1.209710, 1.151161, 1.092612, 1.034064, 0.975515, 0.916966, 0.858417, 0.799868, 0.741320, 0.682771, 0.624222, 0.565673, 0.507124, 0.448576, 0.390027] #[1.036067, 0.977518, 0.918969, 0.860420, 0.801872, 0.743323, 0.684774, 0.626225, 0.567676, 0.509128, 0.450579, 0.392030, 0.333481, 0.274932, 0.216384, 1.757835] #[1.036067, 0.977518, 0.918969, 0.860420, 0.801872, 0.743323, 0.684774, 0.626225, 0.567676, 0.509128, 0.450579, 0.392030, 0.333481, 0.274932, 0.216384, 1.757835, 1.699286, 1.640737, 1.582188, 1.523640, 1.465091, 1.406542, 1.347993, 1.289444, 1.230896, 1.172347, 1.113798, 1.055249, 0.996700, 0.938152, 0.879603, 0.821054, 0.762505, 0.703956, 0.645408, 0.586859, 0.528310, 0.469761, 0.411212, 0.352664, 0.294115, 0.235566, 1.777017, 1.718468, 1.659920, 1.601371, 1.542822, 1.484273]))

def check_mul_bounds_neg_pos (b : Float) (r : Float) (blo : Float) (bhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (b * r)
  (!(blo < b) || (!(b < bhi) || (!(bhi <= (0 : Float)) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((blo * rhi) < v14) && (v14 < (bhi * rlo)))))))))

#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 1.235683 1.177134 1.118585 1.060036 1.001488 0.942939))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.904491 0.845942 0.787393 0.728844 0.670296 0.611747))
#eval IO.println ("check_mul_bounds_neg_pos " ++ toString (check_mul_bounds_neg_pos 0.573299 0.514750 0.456201 0.397652 0.339104 0.280555))

def check_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v14 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v14) && (v14 < (xhi * rhi)))))))))

#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 1.049531 0.990982 0.932433 0.873884 0.815336 0.756787))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.718339 0.659790 0.601241 0.542692 0.484144 0.425595))
#eval IO.println ("check_mul_bounds_pos_pos " ++ toString (check_mul_bounds_pos_pos 0.387147 0.328598 0.270049 0.211500 1.752952 1.694403))

def ntuOf (UA : Float) (mcp : Float) : Float :=
  (UA / (max mcp (0.000001 : Float)))

#eval IO.println ("ntuOf " ++ toString (ntuOf 0.863379 0.804830).toBits)
#eval IO.println ("ntuOf " ++ toString (ntuOf 0.532187 0.473638).toBits)
#eval IO.println ("ntuOf " ++ toString (ntuOf 0.200995 1.742446).toBits)

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

#eval IO.println ("nusseltOf " ++ toString (nusseltOf 0.491075 0.432526 0.373977).toBits)
#eval IO.println ("nusseltOf " ++ toString (nusseltOf 1.759883 1.701334 1.642785).toBits)
#eval IO.println ("nusseltOf " ++ toString (nusseltOf 1.428691 1.370142 1.311593).toBits)

def nusseltTurb (Re : Float) (Pr : Float) : Float :=
  (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max Re (1 : Float)))))) * (Float.exp ((0.4 : Float) * (Float.log (max Pr (0.01 : Float))))))

#eval IO.println ("nusseltTurb " ++ toString (nusseltTurb 0.304923 0.246374).toBits)
#eval IO.println ("nusseltTurb " ++ toString (nusseltTurb 1.573731 1.515182).toBits)
#eval IO.println ("nusseltTurb " ++ toString (nusseltTurb 1.242539 1.183990).toBits)

def check_nusseltTurb_mono (Re1 : Float) (Re2 : Float) (Pr : Float) : Bool :=
  let v17 := (Float.exp ((0.4 : Float) * (Float.log (max Pr (0.01 : Float)))))
  (!(Re1 <= Re2) || ((((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max Re1 (1 : Float)))))) * v17) <= (((0.023 : Float) * (Float.exp ((0.8 : Float) * (Float.log (max Re2 (1 : Float)))))) * v17)))

#eval IO.println ("check_nusseltTurb_mono " ++ toString (check_nusseltTurb_mono 1.718771 1.660222 1.601673))
#eval IO.println ("check_nusseltTurb_mono " ++ toString (check_nusseltTurb_mono 1.387579 1.329030 1.270481))
#eval IO.println ("check_nusseltTurb_mono " ++ toString (check_nusseltTurb_mono 1.056387 0.997838 0.939289))

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

#eval IO.println ("obsOf " ++ toString ((obsOf 1.160315 1.101766 1.043217 0.984668 0.926120 0.867571 0.809022 0.750473 0.691924 0.633376 0.574827).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.829123 0.770574 0.712025 0.653476 0.594928 0.536379 0.477830 0.419281 0.360732 0.302184 0.243635).map Float.toBits))
#eval IO.println ("obsOf " ++ toString ((obsOf 0.497931 0.439382 0.380833 0.322284 0.263736 0.205187 1.746638 1.688089 1.629540 1.570992 1.512443).map Float.toBits))

def oilBulkMax  : Float :=
  (618.15 : Float)

#eval IO.println ("oilBulkMax " ++ toString (oilBulkMax).toBits)
#eval IO.println ("oilBulkMax " ++ toString (oilBulkMax).toBits)
#eval IO.println ("oilBulkMax " ++ toString (oilBulkMax).toBits)

def oilCp (T : Float) : Float :=
  let v2 := (T - (273.15 : Float))
  ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v2)) + ((0.0000008970757 : Float) * (v2 ^ 2))))

#eval IO.println ("oilCp " ++ toString (oilCp 0.788011).toBits)
#eval IO.println ("oilCp " ++ toString (oilCp 0.456819).toBits)
#eval IO.println ("oilCp " ++ toString (oilCp 1.725627).toBits)

def check_oilCp_pos (T : Float) : Bool :=
  let v4 := (T - (273.15 : Float))
  (!((273.15 : Float) <= T) || ((0 : Float) < ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v4)) + ((0.0000008970757 : Float) * (v4 ^ 2))))))

#eval IO.println ("check_oilCp_pos " ++ toString (check_oilCp_pos 0.601859))
#eval IO.println ("check_oilCp_pos " ++ toString (check_oilCp_pos 0.270667))
#eval IO.println ("check_oilCp_pos " ++ toString (check_oilCp_pos 1.539475))

def oilFilmMax  : Float :=
  (648.15 : Float)

#eval IO.println ("oilFilmMax " ++ toString (oilFilmMax).toBits)
#eval IO.println ("oilFilmMax " ++ toString (oilFilmMax).toBits)
#eval IO.println ("oilFilmMax " ++ toString (oilFilmMax).toBits)

def oilK (T : Float) : Float :=
  let v2 := (T - (273.15 : Float))
  (((0.118294 : Float) - ((0.000033 : Float) * v2)) - ((0.00000015 : Float) * (v2 ^ 2)))

#eval IO.println ("oilK " ++ toString (oilK 0.229555).toBits)
#eval IO.println ("oilK " ++ toString (oilK 1.498363).toBits)
#eval IO.println ("oilK " ++ toString (oilK 1.167171).toBits)

def check_oilK_pos (T : Float) : Bool :=
  let v6 := (T - (273.15 : Float))
  (!((273.15 : Float) <= T) || (!(T <= (618.15 : Float)) || ((0 : Float) < (((0.118294 : Float) - ((0.000033 : Float) * v6)) - ((0.00000015 : Float) * (v6 ^ 2))))))

#eval IO.println ("check_oilK_pos " ++ toString (check_oilK_pos 1.643403))
#eval IO.println ("check_oilK_pos " ++ toString (check_oilK_pos 1.312211))
#eval IO.println ("check_oilK_pos " ++ toString (check_oilK_pos 0.981019))

def oilMu (T : Float) : Float :=
  ((Float.exp (((586.375 : Float) / ((T - (273.15 : Float)) + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))

#eval IO.println ("oilMu " ++ toString (oilMu 1.457251).toBits)
#eval IO.println ("oilMu " ++ toString (oilMu 1.126059).toBits)
#eval IO.println ("oilMu " ++ toString (oilMu 0.794867).toBits)

def check_oilMu_pos (T : Float) : Bool :=
  ((0 : Float) < ((Float.exp (((586.375 : Float) / ((T - (273.15 : Float)) + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float)))

#eval IO.println ("check_oilMu_pos " ++ toString (check_oilMu_pos 1.271099))
#eval IO.println ("check_oilMu_pos " ++ toString (check_oilMu_pos 0.939907))
#eval IO.println ("check_oilMu_pos " ++ toString (check_oilMu_pos 0.608715))

def oilPourPoint  : Float :=
  (248.15 : Float)

#eval IO.println ("oilPourPoint " ++ toString (oilPourPoint).toBits)
#eval IO.println ("oilPourPoint " ++ toString (oilPourPoint).toBits)
#eval IO.println ("oilPourPoint " ++ toString (oilPourPoint).toBits)

def oilRho (T : Float) : Float :=
  let v2 := (T - (273.15 : Float))
  (((1020.62 : Float) - ((0.614254 : Float) * v2)) - ((0.000321 : Float) * (v2 ^ 2)))

#eval IO.println ("oilRho " ++ toString (oilRho 0.898795).toBits)
#eval IO.println ("oilRho " ++ toString (oilRho 0.567603).toBits)
#eval IO.println ("oilRho " ++ toString (oilRho 0.236411).toBits)

def check_oilRho_pos (T : Float) : Bool :=
  let v6 := (T - (273.15 : Float))
  (!((273.15 : Float) <= T) || (!(T <= (618.15 : Float)) || ((0 : Float) < (((1020.62 : Float) - ((0.614254 : Float) * v6)) - ((0.000321 : Float) * (v6 ^ 2))))))

#eval IO.println ("check_oilRho_pos " ++ toString (check_oilRho_pos 0.712643))
#eval IO.println ("check_oilRho_pos " ++ toString (check_oilRho_pos 0.381451))
#eval IO.println ("check_oilRho_pos " ++ toString (check_oilRho_pos 1.650259))

def oilStep (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) (dt : Float) : Float :=
  let v22 := (Toil - Ta)
  (min ToilMax (Toil + ((dt * ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : Float) (UAx * (Toil - Twall))))) / Coil)))

#eval IO.println ("oilStep " ++ toString (oilStep 0.526491 0.467942 0.409393 0.350844 0.292296 0.233747 1.775198 1.716649 1.658100 1.599552 1.541003 1.482454 1.423905).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 1.795299 1.736750 1.678201 1.619652 1.561104 1.502555 1.444006 1.385457 1.326908 1.268360 1.209811 1.151262 1.092713).toBits)
#eval IO.println ("oilStep " ++ toString (oilStep 1.464107 1.405558 1.347009 1.288460 1.229912 1.171363 1.112814 1.054265 0.995716 0.937168 0.878619 0.820070 0.761521).toBits)

def check_oilStep_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Coil : Float) (ToilMax : Float) (Pin : Float) (Twall : Float) (Ta : Float) (dt : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v27 := (alpha * Pin)
  let v30 := ((eps * (0.0000000567 : Float)) * Ac)
  let v32 := (Ta ^ 4)
  let v35 := (hC * Ac)
  let v36 := (T1 - Ta)
  let v53 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) < Coil) || (!((0 : Float) <= dt) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((min ToilMax (T1 + ((dt * (((v27 - ((v30 * ((T1 ^ 4) - v32)) + (v35 * v36))) - (Upipe * v36)) - (max (0 : Float) (UAx * (T1 - Twall))))) / Coil))) - (min ToilMax (T2 + ((dt * (((v27 - ((v30 * ((T2 ^ 4) - v32)) + (v35 * v53))) - (Upipe * v53)) - (max (0 : Float) (UAx * (T2 - Twall))))) / Coil))))) <= (((1 : Float) + ((dt * ((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v35) + Upipe) + UAx)) / Coil)) * (Float.abs (T1 - T2)))))))))))))))

#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 0.340339 0.281790 0.223241 1.764692 1.706144 1.647595 1.589046 1.530497 1.471948 1.413400 1.354851 1.296302 1.237753 1.179204 1.120656))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.609147 1.550598 1.492049 1.433500 1.374952 1.316403 1.257854 1.199305 1.140756 1.082208 1.023659 0.965110 0.906561 0.848012 0.789464))
#eval IO.println ("check_oilStep_lipschitz " ++ toString (check_oilStep_lipschitz 1.277955 1.219406 1.160857 1.102308 1.043760 0.985211 0.926662 0.868113 0.809564 0.751016 0.692467 0.633918 0.575369 0.516820 0.458272))

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

#eval IO.println ("pipeArea " ++ toString (pipeArea 1.381883).toBits)
#eval IO.println ("pipeArea " ++ toString (pipeArea 1.050691).toBits)
#eval IO.println ("pipeArea " ++ toString (pipeArea 0.719499).toBits)

def check_pipeArea_pos (D : Float) : Bool :=
  (!((0 : Float) < D) || ((0 : Float) < (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))))

#eval IO.println ("check_pipeArea_pos " ++ toString (check_pipeArea_pos 1.195731))
#eval IO.println ("check_pipeArea_pos " ++ toString (check_pipeArea_pos 0.864539))
#eval IO.println ("check_pipeArea_pos " ++ toString (check_pipeArea_pos 0.533347))

def pipeGreen (Upipe : Float) (mcp : Float) : Float :=
  (Float.exp ((-Upipe) / mcp))

#eval IO.println ("pipeGreen " ++ toString (pipeGreen 1.009579 0.951030).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 0.678387 0.619838).toBits)
#eval IO.println ("pipeGreen " ++ toString (pipeGreen 0.347195 0.288646).toBits)

def check_pipeGreen_le_one (Upipe : Float) (mcp : Float) : Bool :=
  (!((0 : Float) <= Upipe) || (!((0 : Float) < mcp) || ((Float.exp ((-Upipe) / mcp)) <= (1 : Float))))

#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 0.823427 0.764878))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 0.492235 0.433686))
#eval IO.println ("check_pipeGreen_le_one " ++ toString (check_pipeGreen_le_one 1.761043 1.702494))

def check_pipeGreen_pos (Upipe : Float) (mcp : Float) : Bool :=
  ((0 : Float) < (Float.exp ((-Upipe) / mcp)))

#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 0.637275 0.578726))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 0.306083 0.247534))
#eval IO.println ("check_pipeGreen_pos " ++ toString (check_pipeGreen_pos 1.574891 1.516342))

def check_pipeGreen_semigroup (U1 : Float) (U2 : Float) (mcp : Float) : Bool :=
  (feq (Float.exp ((-(U1 + U2)) / mcp)) ((Float.exp ((-U1) / mcp)) * (Float.exp ((-U2) / mcp))))

#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 0.451123 0.392574 0.334025))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 1.719931 1.661382 1.602833))
#eval IO.println ("check_pipeGreen_semigroup " ++ toString (check_pipeGreen_semigroup 1.388739 1.330190 1.271641))

def check_play_budget (f : Float) (eps : Float) (h : Float) (delta : Float) : Bool :=
  let v5 := (f * (Float.tan eps))
  (!(v5 <= (h - delta)) || ((v5 + delta) <= h))

#eval IO.println ("check_play_budget " ++ toString (check_play_budget 0.264971 0.206422 1.747873 1.689324))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.533779 1.475230 1.416681 1.358132))
#eval IO.println ("check_play_budget " ++ toString (check_play_budget 1.202587 1.144038 1.085489 1.026940))

def check_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.678819))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.347627))
#eval IO.println ("check_plumbed_shift " ++ toString (check_plumbed_shift 1.016435))

def pointVel (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Array Float :=
  #[(((t_1 * p_2) - (t_2 * p_1)) + t_3), (((t_2 * p_0) - (t_0 * p_2)) + t_4), (((t_0 * p_1) - (t_1 * p_0)) + t_5)]

#eval IO.println ("pointVel " ++ toString ((pointVel 1.492667 1.434118 1.375569 1.317020 1.258472 1.199923 1.141374 1.082825 1.024276).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 1.161475 1.102926 1.044377 0.985828 0.927280 0.868731 0.810182 0.751633 0.693084).map Float.toBits))
#eval IO.println ("pointVel " ++ toString ((pointVel 0.830283 0.771734 0.713185 0.654636 0.596088 0.537539 0.478990 0.420441 0.361892).map Float.toBits))

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

#eval IO.println ("pointingError " ++ toString (pointingError 1.306515 1.247966 1.189417 1.130868).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.975323 0.916774 0.858225 0.799676).toBits)
#eval IO.println ("pointingError " ++ toString (pointingError 0.644131 0.585582 0.527033 0.468484).toBits)

def postTop (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Array Float :=
  #[c_apexH, (sg * ((c_chord / (2 : Float)) - endIn)), l_upright]

#eval IO.println ("postTop " ++ toString ((postTop 1.120363 1.061814 1.003265 0.944716 0.886168 0.827619 0.769070 0.710521 0.651972 0.593424 0.534875 0.476326 0.417777).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 0.789171 0.730622 0.672073 0.613524 0.554976 0.496427 0.437878 0.379329 0.320780 0.262232 0.203683 1.745134 1.686585).map Float.toBits))
#eval IO.println ("postTop " ++ toString ((postTop 0.457979 0.399430 0.340881 0.282332 0.223784 1.765235 1.706686 1.648137 1.589588 1.531040 1.472491 1.413942 1.355393).map Float.toBits))

def check_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v16 := (c_chord / (2 : Float))
  let v20 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v20 + ((sg * (v16 - (0 : Float))) ^ 2)) ((Float.sqrt ((v16 ^ 2) + v20)) ^ 2)))

#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.934211 0.875662 0.817113 0.758564 0.700016 0.641467 0.582918 0.524369 0.465820 0.407272 0.348723 0.290174))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.603019 0.544470 0.485921 0.427372 0.368824 0.310275 0.251726 1.793177 1.734628 1.676080 1.617531 1.558982))
#eval IO.println ("check_postTop_on_rail " ++ toString (check_postTop_on_rail 0.271827 0.213278 1.754729 1.696180 1.637632 1.579083 1.520534 1.461985 1.403436 1.344888 1.286339 1.227790))

def check_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v15 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v15) - ((-(1 : Float)) * v15)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.748059 0.689510 0.630961 0.572412 0.513864 0.455315 0.396766 0.338217 0.279668 0.221120 1.762571 1.704022))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 0.416867 0.358318 0.299769 0.241220 1.782672 1.724123 1.665574 1.607025 1.548476 1.489928 1.431379 1.372830))
#eval IO.println ("check_postTops_apart " ++ toString (check_postTops_apart 1.685675 1.627126 1.568577 1.510028 1.451480 1.392931 1.334382 1.275833 1.217284 1.158736 1.100187 1.041638))

def check_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.561907 0.503358 0.444809 0.386260 0.327712 0.269163 0.210614 1.752065 1.693516 1.634968 1.576419 1.517870))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 0.230715 1.772166 1.713617 1.655068 1.596520 1.537971 1.479422 1.420873 1.362324 1.303776 1.245227 1.186678))
#eval IO.println ("check_postTops_level " ++ toString (check_postTops_level 1.499523 1.440974 1.382425 1.323876 1.265328 1.206779 1.148230 1.089681 1.031132 0.972584 0.914035 0.855486))

def check_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 0.375755 0.317206 0.258657 0.200108 1.741560 1.683011 1.624462 1.565913 1.507364 1.448816 1.390267 1.331718 1.273169))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.644563 1.586014 1.527465 1.468916 1.410368 1.351819 1.293270 1.234721 1.176172 1.117624 1.059075 1.000526 0.941977))
#eval IO.println ("check_postTops_offAxis " ++ toString (check_postTops_offAxis 1.313371 1.254822 1.196273 1.137724 1.079176 1.020627 0.962078 0.903529 0.844980 0.786432 0.727883 0.669334 0.610785))

def check_pow4_lipschitz (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((T1 ^ 4) - (T2 ^ 4))) <= (((4 : Float) * (M ^ 3)) * (Float.abs (T1 - T2))))))))

#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.789603 1.731054 1.672505))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.458411 1.399862 1.341313))
#eval IO.println ("check_pow4_lipschitz " ++ toString (check_pow4_lipschitz 1.127219 1.068670 1.010121))

def prandtl (T : Float) : Float :=
  let v3 := (T - (273.15 : Float))
  let v17 := (v3 ^ 2)
  ((((Float.exp (((586.375 : Float) / (v3 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float)) * ((1000 : Float) * (((1.496005 : Float) + ((0.003313 : Float) * v3)) + ((0.0000008970757 : Float) * v17)))) / (((0.118294 : Float) - ((0.000033 : Float) * v3)) - ((0.00000015 : Float) * v17)))

#eval IO.println ("prandtl " ++ toString (prandtl 1.603451).toBits)
#eval IO.println ("prandtl " ++ toString (prandtl 1.272259).toBits)
#eval IO.println ("prandtl " ++ toString (prandtl 0.941067).toBits)

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

#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.714235 1.655686 1.597137))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.383043 1.324494 1.265945))
#eval IO.println ("prop_azRate_pos " ++ toString (prop_azRate_pos 1.051851 0.993302 0.934753))

def prop_bearing_life (L10 : Float) : Bool :=
  (!(((10 : Float) ^ 6) <= L10) || (((100 : Float) * ((20 : Float) * (365.25 : Float))) < L10))

#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.528083))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 1.196891))
#eval IO.println ("prop_bearing_life " ++ toString (prop_bearing_life 0.865699))

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

#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.783475 0.724926))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 0.452283 0.393734))
#eval IO.println ("prop_cable_drop_small " ++ toString (prop_cable_drop_small 1.721091 1.662542))

def prop_captureS_slope (rc : Float) (r1 : Float) (r2 : Float) : Bool :=
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((rc - r1) / (0.005 : Float))))) - (1.0 / (1.0 + Float.exp (-((rc - r2) / (0.005 : Float))))))) <= ((Float.abs (r1 - r2)) / ((4 : Float) * (0.005 : Float))))

#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.597323 0.538774 0.480225))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 0.266131 0.207582 1.749033))
#eval IO.println ("prop_captureS_slope " ++ toString (prop_captureS_slope 1.534939 1.476390 1.417841))

def prop_clearance_hashemi (holeDown : Float) : Bool :=
  let v10 := (((1.30 : Float) - holeDown) - (Float.sqrt ((5 : Float) - ((2 : Float) * (Float.sqrt (3.36 : Float))))))
  ((((0.1449 : Float) - holeDown) < v10) && (v10 < ((0.146 : Float) - holeDown)))

#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 0.411171))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.679979))
#eval IO.println ("prop_clearance_hashemi " ++ toString (prop_clearance_hashemi 1.348787))

def prop_conicZ_paraboloid (c : Float) (r : Float) : Bool :=
  let v2 := (r ^ 2)
  let v3 := (c * v2)
  (feq (v3 / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (-(1 : Float))) * (c ^ 2)) * v2)) (0 : Float))))) (v3 / (2 : Float)))

#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 0.225019 1.766470))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.493827 1.435278))
#eval IO.println ("prop_conicZ_paraboloid " ++ toString (prop_conicZ_paraboloid 1.162635 1.104086))

def prop_conicZ_sphere (c : Float) (r : Float) : Bool :=
  let v2 := (c ^ 2)
  let v3 := (r ^ 2)
  let v5 := ((1 : Float) / c)
  (!((0 : Float) < c) || (!((v2 * v3) <= (1 : Float)) || (feq ((c * v3) / ((1 : Float) + (Float.sqrt (max ((1 : Float) - ((((1 : Float) + (0 : Float)) * v2) * v3)) (0 : Float))))) (v5 - (Float.sqrt ((v5 ^ 2) - v3))))))

#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.638867 1.580318))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 1.307675 1.249126))
#eval IO.println ("prop_conicZ_sphere " ++ toString (prop_conicZ_sphere 0.976483 0.917934))

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

#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.452715 1.394166 1.335617 1.277068 1.218520 1.159971 1.101422 1.042873 0.984324 0.925776 0.867227 0.808678))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 1.121523 1.062974 1.004425 0.945876 0.887328 0.828779 0.770230 0.711681 0.653132 0.594584 0.536035 0.477486))
#eval IO.println ("prop_constraints_reciprocal_yaw " ++ toString (prop_constraints_reciprocal_yaw 0.790331 0.731782 0.673233 0.614684 0.556136 0.497587 0.439038 0.380489 0.321940 0.263392 0.204843 1.746294))

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

#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.708107 0.649558 0.591009))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 0.376915 0.318366 0.259817))
#eval IO.println ("prop_dishAxes_rot " ++ toString (prop_dishAxes_rot 1.645723 1.587174 1.528625))

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

#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.749651 1.691102 1.632553 1.574004 1.515456 1.456907 1.398358 1.339809 1.281260 1.222712 1.164163 1.105614 1.047065))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.418459 1.359910 1.301361 1.242812 1.184264 1.125715 1.067166 1.008617 0.950068 0.891520 0.832971 0.774422 0.715873))
#eval IO.println ("prop_drive_recip_yaw " ++ toString (prop_drive_recip_yaw 1.087267 1.028718 0.970169 0.911620 0.853072 0.794523 0.735974 0.677425 0.618876 0.560328 0.501779 0.443230 0.384681))

def prop_drive_works_on_yaw (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Bool :=
  let v14 := (c_chord / (2 : Float))
  let v18 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v18))
  let v23 := ((F * c_apexH) / v18)
  (!(!(feq F (0 : Float))) || (!(feq (((((((0 : Float) * ((v14 * (0 : Float)) - (b_zRail * v23))) + ((0 : Float) * ((b_zRail * v21) - (c_apexH * (0 : Float))))) + ((1 : Float) * ((c_apexH * v23) - (v14 * v21)))) + ((0 : Float) * v21)) + ((0 : Float) * v23)) + ((0 : Float) * (0 : Float))) (0 : Float))))

#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.563499 1.504950 1.446401 1.387852 1.329304 1.270755 1.212206 1.153657 1.095108 1.036560 0.978011 0.919462 0.860913))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 1.232307 1.173758 1.115209 1.056660 0.998112 0.939563 0.881014 0.822465 0.763916 0.705368 0.646819 0.588270 0.529721))
#eval IO.println ("prop_drive_works_on_yaw " ++ toString (prop_drive_works_on_yaw 0.901115 0.842566 0.784017 0.725468 0.666920 0.608371 0.549822 0.491273 0.432724 0.374176 0.315627 0.257078 1.798529))

def prop_edgeClip_cross (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-a)
  let v6 := (Float.cos t)
  let v7 := (-ze)
  let v8 := (Float.sin t)
  (feq (((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8)))

#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.377347 1.318798 1.260249 1.201700 1.143152))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 1.046155 0.987606 0.929057 0.870508 0.811960))
#eval IO.println ("prop_edgeClip_cross " ++ toString (prop_edgeClip_cross 0.714963 0.656414 0.597865 0.539316 0.480768))

def prop_edgeClip_radius (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (-a)
  let v4 := (Float.cos t)
  let v5 := (-ze)
  let v6 := (Float.sin t)
  (feq ((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) ((a ^ 2) + (ze ^ 2)))

#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 1.191195 1.132646 1.074097))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.860003 0.801454 0.742905))
#eval IO.println ("prop_edgeClip_radius " ++ toString (prop_edgeClip_radius 0.528811 0.470262 0.411713))

def prop_edgeClip_radius_hashemi (t : Float) : Bool :=
  let v2 := (-(0.8 : Float))
  let v3 := (Float.cos t)
  let v5 := (Float.sqrt (3.36 : Float))
  let v8 := (-(v5 - (1 : Float)))
  let v9 := (Float.sin t)
  (feq ((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) ((5 : Float) - ((2 : Float) * v5)))

#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 1.005043))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.673851))
#eval IO.println ("prop_edgeClip_radius_hashemi " ++ toString (prop_edgeClip_radius_hashemi 0.342659))

def prop_edgeClip_reach (a : Float) (ze : Float) (t : Float) : Bool :=
  ((Float.abs (((-a) * (Float.cos t)) + ((-ze) * (Float.sin t)))) <= (Float.sqrt ((a ^ 2) + (ze ^ 2))))

#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.818891 0.760342 0.701793))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 0.487699 0.429150 0.370601))
#eval IO.println ("prop_edgeClip_reach " ++ toString (prop_edgeClip_reach 1.756507 1.697958 1.639409))

def prop_edgeDepth_horizon (f : Float) (a : Float) (sag : Float) : Bool :=
  (feq (((f - sag) * (Float.sin (0 : Float))) + (a * (Float.cos (0 : Float)))) a)

#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.632739 0.574190 0.515641))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 0.301547 0.242998 1.784449))
#eval IO.println ("prop_edgeDepth_horizon " ++ toString (prop_edgeDepth_horizon 1.570355 1.511806 1.453257))

def prop_edgeDepth_le (f : Float) (a : Float) (sag : Float) (el : Float) : Bool :=
  let v4 := (f - sag)
  (((v4 * (Float.sin el)) + (a * (Float.cos el))) <= (Float.sqrt ((v4 ^ 2) + (a ^ 2))))

#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 0.446587 0.388038 0.329489 0.270940))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.715395 1.656846 1.598297 1.539748))
#eval IO.println ("prop_edgeDepth_le " ++ toString (prop_edgeDepth_le 1.384203 1.325654 1.267105 1.208556))

def prop_edgeDepth_noon (f : Float) (a : Float) (sag : Float) : Bool :=
  let v3 := (f - sag)
  let v6 := ((3.141592653589793 : Float) / (2 : Float))
  (feq ((v3 * (Float.sin v6)) + (a * (Float.cos v6))) v3)

#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 0.260435 0.201886 1.743337))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.529243 1.470694 1.412145))
#eval IO.println ("prop_edgeDepth_noon " ++ toString (prop_edgeDepth_noon 1.198051 1.139502 1.080953))

def prop_edgeLever_dead (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  let v7 := (-a)
  let v8 := (-ze)
  (!(feq (v5 * ((ym * a) - (hp * ze))) (v6 * ((ym * ze) + (hp * a)))) || (feq (((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) (0 : Float)))

#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.674283 1.615734 1.557185 1.498636 1.440088))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.343091 1.284542 1.225993 1.167444 1.108896))
#eval IO.println ("prop_edgeLever_dead " ++ toString (prop_edgeLever_dead 1.011899 0.953350 0.894801 0.836252 0.777704))

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

#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.488131 1.429582 1.371033 1.312484 1.253936))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 1.156939 1.098390 1.039841 0.981292 0.922744))
#eval IO.println ("prop_edgeLever_pos_iff " ++ toString (prop_edgeLever_pos_iff 0.825747 0.767198 0.708649 0.650100 0.591552))

def prop_elPower_eq_wire (rw : Float) (W : Float) (rcm : Float) (t : Float) (omega : Float) : Bool :=
  let v7 := ((W * rcm) * (Float.sin t))
  (!(!(feq rw (0 : Float))) || (feq ((v7 / rw) * (rw * omega)) (v7 * omega)))

#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 1.301979 1.243430 1.184881 1.126332 1.067784))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.970787 0.912238 0.853689 0.795140 0.736592))
#eval IO.println ("prop_elPower_eq_wire " ++ toString (prop_elPower_eq_wire 0.639595 0.581046 0.522497 0.463948 0.405400))

def prop_elPower_le (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  let v4 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) <= omega) || (((v4 * (Float.sin t)) * omega) <= (v4 * omega)))))

#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 1.115827 1.057278 0.998729 0.940180))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.784635 0.726086 0.667537 0.608988))
#eval IO.println ("prop_elPower_le " ++ toString (prop_elPower_le 0.453443 0.394894 0.336345 0.277796))

def prop_facetSpot_hashemi  : Bool :=
  (feq ((0.05 : Float) + ((1 : Float) * (0.0093 : Float))) (0.0593 : Float))

#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))
#eval IO.println ("prop_facetSpot_hashemi " ++ toString (prop_facetSpot_hashemi))

def prop_focus_on_axis (psi : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v3 := (Float.cos psi)
  let v4 := (Float.sin psi)
  (!(!(feq v3 (1 : Float))) || (!((feq ((v3 * p_1) - (v4 * p_2)) p_1) && (feq ((v4 * p_1) + (v3 * p_2)) p_2)) || ((feq p_1 (0 : Float)) && (feq p_2 (0 : Float)))))

#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.743523 0.684974 0.626425))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 0.412331 0.353782 0.295233))
#eval IO.println ("prop_focus_on_axis " ++ toString (prop_focus_on_axis 1.681139 1.622590 1.564041))

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

#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.557371 0.498822 0.440273 0.381724 0.323176 0.264627 0.206078 1.747529 1.688980 1.630432 1.571883 1.513334))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 0.226179 1.767630 1.709081 1.650532 1.591984 1.533435 1.474886 1.416337 1.357788 1.299240 1.240691 1.182142))
#eval IO.println ("prop_grooved_reciprocal_yaw " ++ toString (prop_grooved_reciprocal_yaw 1.494987 1.436438 1.377889 1.319340 1.260792 1.202243 1.143694 1.085145 1.026596 0.968048 0.909499 0.850950))

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

#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 0.371219 0.312670 0.254121 1.795572 1.737024 1.678475 1.619926 1.561377 1.502828 1.444280 1.385731 1.327182))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.640027 1.581478 1.522929 1.464380 1.405832 1.347283 1.288734 1.230185 1.171636 1.113088 1.054539 0.995990))
#eval IO.println ("prop_grooved_relation_x " ++ toString (prop_grooved_relation_x 1.308835 1.250286 1.191737 1.133188 1.074640 1.016091 0.957542 0.898993 0.840444 0.781896 0.723347 0.664798))

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

#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.785067 1.726518 1.667969 1.609420 1.550872 1.492323 1.433774 1.375225 1.316676 1.258128 1.199579 1.141030))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.453875 1.395326 1.336777 1.278228 1.219680 1.161131 1.102582 1.044033 0.985484 0.926936 0.868387 0.809838))
#eval IO.println ("prop_grooved_relation_y " ++ toString (prop_grooved_relation_y 1.122683 1.064134 1.005585 0.947036 0.888488 0.829939 0.771390 0.712841 0.654292 0.595744 0.537195 0.478646))

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

#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 0.295851 0.237302 1.778753 1.720204 1.661656 1.603107 1.544558 1.486009))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.564659 1.506110 1.447561 1.389012 1.330464 1.271915 1.213366 1.154817))
#eval IO.println ("prop_hinge_freedom " ++ toString (prop_hinge_freedom 1.233467 1.174918 1.116369 1.057820 0.999272 0.940723 0.882174 0.823625))

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

#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.709699 1.651150 1.592601 1.534052 1.475504 1.416955 1.358406 1.299857 1.241308))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.378507 1.319958 1.261409 1.202860 1.144312 1.085763 1.027214 0.968665 0.910116))
#eval IO.println ("prop_hinge_freedom_smul " ++ toString (prop_hinge_freedom_smul 1.047315 0.988766 0.930217 0.871668 0.813120 0.754571 0.696022 0.637473 0.578924))

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

#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.523547 1.464998 1.406449))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 1.192355 1.133806 1.075257))
#eval IO.println ("prop_hinge_reciprocal_swing " ++ toString (prop_hinge_reciprocal_swing 0.861163 0.802614 0.744065))

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

#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.965091))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.633899))
#eval IO.println ("prop_m12_carries_dish " ++ toString (prop_m12_carries_dish 0.302707))

def prop_mastClears_hashemi  : Bool :=
  ((Float.sqrt (((0.8 : Float) ^ 2) + (((Float.sqrt (3.36 : Float)) - (1 : Float)) ^ 2))) < (1.22 : Float))

#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))
#eval IO.println ("prop_mastClears_hashemi " ++ toString (prop_mastClears_hashemi))

def prop_mastClears_hashemi_iff (ym : Float) : Bool :=
  let v2 := (Float.sqrt (3.36 : Float))
  (((Float.sqrt (((0.8 : Float) ^ 2) + ((v2 - (1 : Float)) ^ 2))) < ym) == ((Float.sqrt ((5 : Float) - ((2 : Float) * v2))) < ym))

#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.592787))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 0.261595))
#eval IO.println ("prop_mastClears_hashemi_iff " ++ toString (prop_mastClears_hashemi_iff 1.530403))

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

#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.634331 1.575782 1.517233 1.458684 1.400136 1.341587))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 1.303139 1.244590 1.186041 1.127492 1.068944 1.010395))
#eval IO.println ("prop_mul_bounds_neg_pos " ++ toString (prop_mul_bounds_neg_pos 0.971947 0.913398 0.854849 0.796300 0.737752 0.679203))

def prop_mul_bounds_pos_pos (x : Float) (r : Float) (xlo : Float) (xhi : Float) (rlo : Float) (rhi : Float) : Bool :=
  let v6 := (x * r)
  (!(xlo < x) || (!(x < xhi) || (!((0 : Float) <= xlo) || (!(rlo < r) || (!(r < rhi) || (!((0 : Float) <= rlo) || (((xlo * rlo) < v6) && (v6 < (xhi * rhi)))))))))

#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.448179 1.389630 1.331081 1.272532 1.213984 1.155435))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 1.116987 1.058438 0.999889 0.941340 0.882792 0.824243))
#eval IO.println ("prop_mul_bounds_pos_pos " ++ toString (prop_mul_bounds_pos_pos 0.785795 0.727246 0.668697 0.610148 0.551600 0.493051))

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

#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.889723 0.831174 0.772625 0.714076))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.558531 0.499982 0.441433 0.382884))
#eval IO.println ("prop_play_budget " ++ toString (prop_play_budget 0.227339 1.768790 1.710241 1.651692))

def prop_plumbed_shift (eps : Float) : Bool :=
  (!((0 : Float) <= eps) || (!(eps <= (0.0005 : Float)) || (((1.30 : Float) * (Float.sin eps)) <= (0.00065 : Float))))

#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.703571))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 0.372379))
#eval IO.println ("prop_plumbed_shift " ++ toString (prop_plumbed_shift 1.641187))

def prop_postTop_on_rail (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (sg : Float) : Bool :=
  let v13 := (c_chord / (2 : Float))
  let v14 := (c_apexH ^ 2)
  (!(feq (sg ^ 2) (1 : Float)) || (feq (v14 + ((sg * (v13 - (0 : Float))) ^ 2)) ((Float.sqrt ((v13 ^ 2) + v14)) ^ 2)))

#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 0.517419 0.458870 0.400321 0.341772 0.283224 0.224675 1.766126 1.707577 1.649028 1.590480 1.531931 1.473382))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.786227 1.727678 1.669129 1.610580 1.552032 1.493483 1.434934 1.376385 1.317836 1.259288 1.200739 1.142190))
#eval IO.println ("prop_postTop_on_rail " ++ toString (prop_postTop_on_rail 1.455035 1.396486 1.337937 1.279388 1.220840 1.162291 1.103742 1.045193 0.986644 0.928096 0.869547 0.810998))

def prop_postTops_apart (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  let v14 := ((c_chord / (2 : Float)) - endIn)
  (feq (((1 : Float) * v14) - ((-(1 : Float)) * v14)) (c_chord - ((2 : Float) * endIn)))

#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 0.331267 0.272718 0.214169 1.755620 1.697072 1.638523 1.579974 1.521425 1.462876 1.404328 1.345779 1.287230))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.600075 1.541526 1.482977 1.424428 1.365880 1.307331 1.248782 1.190233 1.131684 1.073136 1.014587 0.956038))
#eval IO.println ("prop_postTops_apart " ++ toString (prop_postTops_apart 1.268883 1.210334 1.151785 1.093236 1.034688 0.976139 0.917590 0.859041 0.800492 0.741944 0.683395 0.624846))

def prop_postTops_level (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) : Bool :=
  (feq l_upright l_upright)

#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.745115 1.686566 1.628017 1.569468 1.510920 1.452371 1.393822 1.335273 1.276724 1.218176 1.159627 1.101078))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.413923 1.355374 1.296825 1.238276 1.179728 1.121179 1.062630 1.004081 0.945532 0.886984 0.828435 0.769886))
#eval IO.println ("prop_postTops_level " ++ toString (prop_postTops_level 1.082731 1.024182 0.965633 0.907084 0.848536 0.789987 0.731438 0.672889 0.614340 0.555792 0.497243 0.438694))

def prop_postTops_offAxis (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (l_upright : Float) (l_foot : Float) (l_brace : Float) (l_footShort : Float) (l_holes : Float) (endIn : Float) (sg : Float) : Bool :=
  (feq c_apexH c_apexH)

#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.558963 1.500414 1.441865 1.383316 1.324768 1.266219 1.207670 1.149121 1.090572 1.032024 0.973475 0.914926 0.856377))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 1.227771 1.169222 1.110673 1.052124 0.993576 0.935027 0.876478 0.817929 0.759380 0.700832 0.642283 0.583734 0.525185))
#eval IO.println ("prop_postTops_offAxis " ++ toString (prop_postTops_offAxis 0.896579 0.838030 0.779481 0.720932 0.662384 0.603835 0.545286 0.486737 0.428188 0.369640 0.311091 0.252542 1.793993))

def prop_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))
#eval IO.println ("prop_pulley_above_pivot " ++ toString (prop_pulley_above_pivot))

def prop_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (ym * a)
  (!((0 : Float) < ze) || ((v4 <= (hp * ze)) == ((v4 / ze) <= hp)))

#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 1.186659 1.128110 1.069561 1.011012))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.855467 0.796918 0.738369 0.679820))
#eval IO.println ("prop_reachesVertical_iff " ++ toString (prop_reachesVertical_iff 0.524275 0.465726 0.407177 0.348628))

def prop_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))
#eval IO.println ("prop_receiverPost_height " ++ toString (prop_receiverPost_height))

def prop_rim_under_F_iff (a : Float) (ze : Float) (t : Float) : Bool :=
  let v3 := (Float.cos t)
  (!((0 : Float) < ze) || (!((0 : Float) < v3) || ((feq ((a * v3) + ((-ze) * (Float.sin t))) (0 : Float)) == (feq (Float.tan t) (a / ze)))))

#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.814355 0.755806 0.697257))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 0.483163 0.424614 0.366065))
#eval IO.println ("prop_rim_under_F_iff " ++ toString (prop_rim_under_F_iff 1.751971 1.693422 1.634873))

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

#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.669747 1.611198 1.552649 1.494100 1.435552 1.377003))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.338555 1.280006 1.221457 1.162908 1.104360 1.045811))
#eval IO.println ("prop_rollerRadius_pos " ++ toString (prop_rollerRadius_pos 1.007363 0.948814 0.890265 0.831716 0.773168 0.714619))

def prop_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.483595 1.425046 1.366497 1.307948 1.249400 1.190851))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 1.152403 1.093854 1.035305 0.976756 0.918208 0.859659))
#eval IO.println ("prop_rollerRadius_sq " ++ toString (prop_rollerRadius_sq 0.821211 0.762662 0.704113 0.645564 0.587016 0.528467))

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

#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 1.111291 1.052742 0.994193 0.935644 0.877096 0.818547 0.759998))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.780099 0.721550 0.663001 0.604452 0.545904 0.487355 0.428806))
#eval IO.println ("prop_rotz_dot " ++ toString (prop_rotz_dot 0.448907 0.390358 0.331809 0.273260 0.214712 1.756163 1.697614))

def prop_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v6 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v6) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v6))

#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.925139 0.866590))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.593947 0.535398))
#eval IO.println ("prop_screwLength_eq_focal " ++ toString (prop_screwLength_eq_focal 0.262755 0.204206))

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

#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 0.366683 0.308134))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.635491 1.576942))
#eval IO.println ("prop_screwTwist_zero " ++ toString (prop_screwTwist_zero 1.304299 1.245750))

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

#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.780531 1.721982 1.663433 1.604884 1.546336 1.487787 1.429238 1.370689 1.312140))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.449339 1.390790 1.332241 1.273692 1.215144 1.156595 1.098046 1.039497 0.980948))
#eval IO.println ("prop_screw_freedom " ++ toString (prop_screw_freedom 1.118147 1.059598 1.001049 0.942500 0.883952 0.825403 0.766854 0.708305 0.649756))

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

#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.594379 1.535830 1.477281))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 1.263187 1.204638 1.146089))
#eval IO.println ("prop_screw_reciprocal " ++ toString (prop_screw_reciprocal 0.931995 0.873446 0.814897))

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

#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.849771 0.791222 0.732673 0.674124))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 0.518579 0.460030 0.401481 0.342932))
#eval IO.println ("prop_slackHarmless_of_budget " ++ toString (prop_slackHarmless_of_budget 1.787387 1.728838 1.670289 1.611740))

def prop_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.663619 0.605070 0.546521 0.487972 0.429424))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 0.332427 0.273878 0.215329 1.756780 1.698232))
#eval IO.println ("prop_slackHarmless_of_lever " ++ toString (prop_slackHarmless_of_lever 1.601235 1.542686 1.484137 1.425588 1.367040))

def prop_slot_exit_hashemi  : Bool :=
  let v5 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v5) && (v5 < (0.9605 : Float)))

#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))
#eval IO.println ("prop_slot_exit_hashemi " ++ toString (prop_slot_exit_hashemi))

def prop_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v3 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v3) && (v3 < (lo ^ 2))))))

#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 0.291315 0.232766 1.774217))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.560123 1.501574 1.443025))
#eval IO.println ("prop_sq_bounds_neg " ++ toString (prop_sq_bounds_neg 1.228931 1.170382 1.111833))

def prop_sqrt32_bounds  : Bool :=
  let v1 := (Float.sqrt (3.2 : Float))
  (((1.7888 : Float) < v1) && (v1 < (1.78886 : Float)))

#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))
#eval IO.println ("prop_sqrt32_bounds " ++ toString (prop_sqrt32_bounds))

def prop_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.519011 1.460462 1.401913 1.343364 1.284816 1.226267 1.167718 1.109169 1.050620 0.992072))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 1.187819 1.129270 1.070721 1.012172 0.953624 0.895075 0.836526 0.777977 0.719428 0.660880))
#eval IO.println ("prop_strut_resists_lean " ++ toString (prop_strut_resists_lean 0.856627 0.798078 0.739529 0.680980 0.622432 0.563883 0.505334 0.446785 0.388236 0.329688))

def prop_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v5 := (Float.sin elSun)
  let v6 := (Float.cos delta)
  let v8 := (v3 * (Float.cos azSun))
  let v10 := (v3 * (Float.sin azSun))
  let v11 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v6 * v8) - (v11 * v10))) && ((feq (v3 * (Float.sin v4)) ((v11 * v8) + (v6 * v10))) && (feq v5 v5)))

#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.332859 1.274310 1.215761))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 1.001667 0.943118 0.884569))
#eval IO.println ("prop_sunDir_rot " ++ toString (prop_sunDir_rot 0.670475 0.611926 0.553377))

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

#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 1.146707 1.088158 1.029609 0.971060 0.912512))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.815515 0.756966 0.698417 0.639868 0.581320))
#eval IO.println ("prop_sunInDish_equivariant " ++ toString (prop_sunInDish_equivariant 0.484323 0.425774 0.367225 0.308676 0.250128))

def prop_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v6 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v6)) + (f * v6)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.960555 0.902006 0.843457 0.784908 0.726360))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.629363 0.570814 0.512265 0.453716 0.395168))
#eval IO.println ("prop_swingFocus_circle " ++ toString (prop_swingFocus_circle 0.298171 0.239622 1.781073 1.722524 1.663976))

def prop_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.774403))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 0.443211))
#eval IO.println ("prop_swingNormal_unit " ++ toString (prop_swingNormal_unit 1.712019))

def prop_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.588251 0.529702 0.471153 0.412604))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 0.257059 1.798510 1.739961 1.681412))
#eval IO.println ("prop_swing_focusCircle " ++ toString (prop_swing_focusCircle 1.525867 1.467318 1.408769 1.350220))

def prop_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((1 : Float) * p_1) - ((0 : Float) * p_0)) + ((apexH * (0 : Float)) - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 0.402099 0.343550 0.285001 0.226452 1.767904))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.670907 1.612358 1.553809 1.495260 1.436712))
#eval IO.println ("prop_swing_lift " ++ toString (prop_swing_lift 1.339715 1.281166 1.222617 1.164068 1.105520))

def prop_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v5 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v5 <= (Tmax * rw)) || (((v5 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 0.215947 1.757398 1.698849 1.640300 1.581752))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.484755 1.426206 1.367657 1.309108 1.250560))
#eval IO.println ("prop_tension_le_of_holds " ++ toString (prop_tension_le_of_holds 1.153563 1.095014 1.036465 0.977916 0.919368))

def prop_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v3 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v3) <= h) == (v3 <= (h / f))))

#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.629795 1.571246 1.512697))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 1.298603 1.240054 1.181505))
#eval IO.println ("prop_trackerBudget_iff " ++ toString (prop_trackerBudget_iff 0.967411 0.908862 0.850313))

def prop_tracker_margin_hashemi (eps : Float) : Bool :=
  let v1 := (Float.tan eps)
  ((((1 : Float) * v1) <= (0.03 : Float)) == (v1 <= (0.03 : Float)))

#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.443643))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 1.112451))
#eval IO.println ("prop_tracker_margin_hashemi " ++ toString (prop_tracker_margin_hashemi 0.781259))

def prop_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 1.257491 1.198942 1.140393 1.081844))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.926299 0.867750 0.809201 0.750652))
#eval IO.println ("prop_tracking_power_tiny " ++ toString (prop_tracking_power_tiny 0.595107 0.536558 0.478009 0.419460))

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

#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.885187 0.826638 0.768089 0.709540 0.650992))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.553995 0.495446 0.436897 0.378348 0.319800))
#eval IO.println ("prop_wireLever_edge_formula " ++ toString (prop_wireLever_edge_formula 0.222803 1.764254 1.705705 1.647156 1.588608))

def prop_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v8 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v11 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v8) || (((0 : Float) < (v11 / (Float.sqrt v8))) == ((0 : Float) < v11)))

#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.699035 0.640486 0.581937 0.523388))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 0.367843 0.309294 0.250745 1.792196))
#eval IO.println ("prop_wireLever_pos_iff " ++ toString (prop_wireLever_pos_iff 1.636651 1.578102 1.519553 1.461004))

def prop_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v8 := (-ze)
  let v9 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v8 * v9))
  let v16 := (((-v5) * v9) + (v8 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 0.512883 0.454334 0.395785 0.337236))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.781691 1.723142 1.664593 1.606044))
#eval IO.println ("prop_wireLever_rest " ++ toString (prop_wireLever_rest 1.450499 1.391950 1.333401 1.274852))

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

#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.554427 1.495878 1.437329 1.378780 1.320232 1.261683 1.203134 1.144585))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 1.223235 1.164686 1.106137 1.047588 0.989040 0.930491 0.871942 0.813393))
#eval IO.println ("prop_wire_recip_swing " ++ toString (prop_wire_recip_swing 0.892043 0.833494 0.774945 0.716396 0.657848 0.599299 0.540750 0.482201))

def prop_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))
#eval IO.println ("prop_wire_short_of_vertical " ++ toString (prop_wire_short_of_vertical))

def prop_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v4 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v4) / rw)) == ((0 : Float) <= v4)))))

#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 1.182123 1.123574 1.065025 1.006476))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.850931 0.792382 0.733833 0.675284))
#eval IO.println ("prop_wire_taut_iff " ++ toString (prop_wire_taut_iff 0.519739 0.461190 0.402641 0.344092))

def prop_yaw_lifts_nothing (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  (feq ((((0 : Float) * p_1) - ((0 : Float) * p_0)) + (0 : Float)) (0 : Float))

#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.995971 0.937422 0.878873))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.664779 0.606230 0.547681))
#eval IO.println ("prop_yaw_lifts_nothing " ++ toString (prop_yaw_lifts_nothing 0.333587 0.275038 0.216489))

def prop_ym_is_standStation  : Bool :=
  (feq (1.22 : Float) (1.22 : Float))

#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))
#eval IO.println ("prop_ym_is_standStation " ++ toString (prop_ym_is_standStation))

def pulleyAt (ym : Float) (hp : Float) : Array Float :=
  #[(-ym), hp]

#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.623667 0.565118).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 0.292475 0.233926).map Float.toBits))
#eval IO.println ("pulleyAt " ++ toString ((pulleyAt 1.561283 1.502734).map Float.toBits))

def check_pulley_above_pivot  : Bool :=
  (feq ((1.59 : Float) - ((1.30 : Float) - (0.05 : Float))) (0.34 : Float))

#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))
#eval IO.println ("check_pulley_above_pivot " ++ toString (check_pulley_above_pivot))

def pumpCmd (u : Float) : Float :=
  (min (max ((u + (1 : Float)) / (2 : Float)) (0 : Float)) (1 : Float))

#eval IO.println ("pumpCmd " ++ toString (pumpCmd 0.251363).toBits)
#eval IO.println ("pumpCmd " ++ toString (pumpCmd 1.520171).toBits)
#eval IO.println ("pumpCmd " ++ toString (pumpCmd 1.188979).toBits)

def check_pumpCmd_mem (u : Float) : Bool :=
  let v7 := (min (max ((u + (1 : Float)) / (2 : Float)) (0 : Float)) (1 : Float))
  (((0 : Float) <= v7) && (v7 <= (1 : Float)))

#eval IO.println ("check_pumpCmd_mem " ++ toString (check_pumpCmd_mem 1.665211))
#eval IO.println ("check_pumpCmd_mem " ++ toString (check_pumpCmd_mem 1.334019))
#eval IO.println ("check_pumpCmd_mem " ++ toString (check_pumpCmd_mem 1.002827))

def pumpCostRaw (dt : Float) (pPump : Float) (pumpPrice : Float) (rotiReward : Float) (rotiEnergy : Float) : Float :=
  ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))

#eval IO.println ("pumpCostRaw " ++ toString (pumpCostRaw 1.479059 1.420510 1.361961 1.303412 1.244864).toBits)
#eval IO.println ("pumpCostRaw " ++ toString (pumpCostRaw 1.147867 1.089318 1.030769 0.972220 0.913672).toBits)
#eval IO.println ("pumpCostRaw " ++ toString (pumpCostRaw 0.816675 0.758126 0.699577 0.641028 0.582480).toBits)

def check_pumpCostRaw_nonneg (dt : Float) (pPump : Float) (pumpPrice : Float) (rotiReward : Float) (rotiEnergy : Float) : Bool :=
  (!((0 : Float) <= dt) || (!((0 : Float) <= pumpPrice) || (!((0 : Float) <= rotiReward) || (!((0 : Float) <= rotiEnergy) || ((0 : Float) <= ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump)))))))

#eval IO.println ("check_pumpCostRaw_nonneg " ++ toString (check_pumpCostRaw_nonneg 1.292907 1.234358 1.175809 1.117260 1.058712))
#eval IO.println ("check_pumpCostRaw_nonneg " ++ toString (check_pumpCostRaw_nonneg 0.961715 0.903166 0.844617 0.786068 0.727520))
#eval IO.println ("check_pumpCostRaw_nonneg " ++ toString (check_pumpCostRaw_nonneg 0.630523 0.571974 0.513425 0.454876 0.396328))

def pumpElec (Q : Float) (D : Float) (L : Float) (T : Float) (eta : Float) (Pidle : Float) : Float :=
  let v7 := (D ^ 2)
  let v11 := (Q / (((3.141592653589793 : Float) * v7) / (4 : Float)))
  let v13 := (T - (273.15 : Float))
  let v21 := (((1020.62 : Float) - ((0.614254 : Float) * v13)) - ((0.000321 : Float) * (v13 ^ 2)))
  let v32 := ((Float.exp (((586.375 : Float) / (v13 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v33 := (((v21 * v11) * D) / v32)
  ((((if (v33 < (2300 : Float)) then (((((32 : Float) * v32) * L) * v11) / v7) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt (max v33 (1 : Float))))) * (L / D)) * v21) * (v11 ^ 2)) / (2 : Float))) * Q) / eta) + (if ((0 : Float) < Q) then Pidle else (0 : Float)))

#eval IO.println ("pumpElec " ++ toString (pumpElec 1.106755 1.048206 0.989657 0.931108 0.872560 0.814011).toBits)
#eval IO.println ("pumpElec " ++ toString (pumpElec 0.775563 0.717014 0.658465 0.599916 0.541368 0.482819).toBits)
#eval IO.println ("pumpElec " ++ toString (pumpElec 0.444371 0.385822 0.327273 0.268724 0.210176 1.751627).toBits)

def pumpHyd (Q : Float) (D : Float) (L : Float) (T : Float) : Float :=
  let v5 := (D ^ 2)
  let v9 := (Q / (((3.141592653589793 : Float) * v5) / (4 : Float)))
  let v11 := (T - (273.15 : Float))
  let v19 := (((1020.62 : Float) - ((0.614254 : Float) * v11)) - ((0.000321 : Float) * (v11 ^ 2)))
  let v30 := ((Float.exp (((586.375 : Float) / (v11 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  let v31 := (((v19 * v9) * D) / v30)
  ((if (v31 < (2300 : Float)) then (((((32 : Float) * v30) * L) * v9) / v5) else ((((((0.3164 : Float) / (Float.sqrt (Float.sqrt (max v31 (1 : Float))))) * (L / D)) * v19) * (v9 ^ 2)) / (2 : Float))) * Q)

#eval IO.println ("pumpHyd " ++ toString (pumpHyd 0.920603 0.862054 0.803505 0.744956).toBits)
#eval IO.println ("pumpHyd " ++ toString (pumpHyd 0.589411 0.530862 0.472313 0.413764).toBits)
#eval IO.println ("pumpHyd " ++ toString (pumpHyd 0.258219 1.799670 1.741121 1.682572).toBits)

def check_pumpLam_convex (c : Float) (Q1 : Float) (Q2 : Float) : Bool :=
  (!((0 : Float) <= c) || (!((0 : Float) <= Q1) || (!((0 : Float) <= Q2) || ((c * (((Q1 + Q2) / (2 : Float)) ^ 2)) <= (((c * (Q1 ^ 2)) + (c * (Q2 ^ 2))) / (2 : Float))))))

#eval IO.println ("check_pumpLam_convex " ++ toString (check_pumpLam_convex 0.734451 0.675902 0.617353))
#eval IO.println ("check_pumpLam_convex " ++ toString (check_pumpLam_convex 0.403259 0.344710 0.286161))
#eval IO.println ("check_pumpLam_convex " ++ toString (check_pumpLam_convex 1.672067 1.613518 1.554969))

def check_pumpLam_mono (mu : Float) (L : Float) (D : Float) (Q1 : Float) (Q2 : Float) : Bool :=
  let v13 := (((32 : Float) * mu) * L)
  let v15 := (D ^ 2)
  let v18 := (((3.141592653589793 : Float) * v15) / (4 : Float))
  (!((0 : Float) <= mu) || (!((0 : Float) <= L) || (!((0 : Float) < D) || (!((0 : Float) <= Q1) || (!(Q1 <= Q2) || ((((v13 * (Q1 / v18)) / v15) * Q1) <= (((v13 * (Q2 / v18)) / v15) * Q2)))))))

#eval IO.println ("check_pumpLam_mono " ++ toString (check_pumpLam_mono 0.548299 0.489750 0.431201 0.372652 0.314104))
#eval IO.println ("check_pumpLam_mono " ++ toString (check_pumpLam_mono 0.217107 1.758558 1.700009 1.641460 1.582912))
#eval IO.println ("check_pumpLam_mono " ++ toString (check_pumpLam_mono 1.485915 1.427366 1.368817 1.310268 1.251720))

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

#eval IO.println ("qAbs " ++ toString (qAbs 1.403691 1.345142).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 1.072499 1.013950).toBits)
#eval IO.println ("qAbs " ++ toString (qAbs 0.741307 0.682758).toBits)

def qCoilLoss (eps : Float) (Ac : Float) (hC : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 1.217539 1.158990 1.100441 1.041892 0.983344).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.886347 0.827798 0.769249 0.710700 0.652152).toBits)
#eval IO.println ("qCoilLoss " ++ toString (qCoilLoss 0.555155 0.496606 0.438057 0.379508 0.320960).toBits)

def qCoilLossW (eps : Float) (Ac : Float) (V : Float) (Toil : Float) (Ta : Float) : Float :=
  ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((((5.7 : Float) + ((3.8 : Float) * V)) * Ac) * (Toil - Ta)))

#eval IO.println ("qCoilLossW " ++ toString (qCoilLossW 1.031387 0.972838 0.914289 0.855740 0.797192).toBits)
#eval IO.println ("qCoilLossW " ++ toString (qCoilLossW 0.700195 0.641646 0.583097 0.524548 0.466000).toBits)
#eval IO.println ("qCoilLossW " ++ toString (qCoilLossW 0.369003 0.310454 0.251905 1.793356 1.734808).toBits)

def check_qCoilLossW_eq (eps : Float) (Ac : Float) (V : Float) (Toil : Float) (Ta : Float) : Bool :=
  let v19 := ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((((5.7 : Float) + ((3.8 : Float) * V)) * Ac) * (Toil - Ta)))
  (feq v19 v19)

#eval IO.println ("check_qCoilLossW_eq " ++ toString (check_qCoilLossW_eq 0.845235 0.786686 0.728137 0.669588 0.611040))
#eval IO.println ("check_qCoilLossW_eq " ++ toString (check_qCoilLossW_eq 0.514043 0.455494 0.396945 0.338396 0.279848))
#eval IO.println ("check_qCoilLossW_eq " ++ toString (check_qCoilLossW_eq 1.782851 1.724302 1.665753 1.607204 1.548656))

def qNet (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Float :=
  let v19 := (Toil - Ta)
  ((((alpha * Pin) - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("qNet " ++ toString (qNet 0.659083 0.600534 0.541985 0.483436 0.424888 0.366339 0.307790 0.249241 1.790692 1.732144).toBits)
#eval IO.println ("qNet " ++ toString (qNet 0.327891 0.269342 0.210793 1.752244 1.693696 1.635147 1.576598 1.518049 1.459500 1.400952).toBits)
#eval IO.println ("qNet " ++ toString (qNet 1.596699 1.538150 1.479601 1.421052 1.362504 1.303955 1.245406 1.186857 1.128308 1.069760).toBits)

def check_qNet_antitone (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) <= (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 0.472931 0.414382 0.355833 0.297284 0.238736 1.780187 1.721638 1.663089 1.604540 1.545992 1.487443))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.741739 1.683190 1.624641 1.566092 1.507544 1.448995 1.390446 1.331897 1.273348 1.214800 1.156251))
#eval IO.println ("check_qNet_antitone " ++ toString (check_qNet_antitone 1.410547 1.351998 1.293449 1.234900 1.176352 1.117803 1.059254 1.000705 0.942156 0.883608 0.825059))

def check_qNet_lipschitz (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) (M : Float) : Bool :=
  let v22 := (alpha * Pin)
  let v25 := ((eps * (0.0000000567 : Float)) * Ac)
  let v27 := (Ta ^ 4)
  let v30 := (hC * Ac)
  let v31 := (T1 - Ta)
  let v44 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 <= M) || (!((0 : Float) <= T2) || (!(T2 <= M) || ((Float.abs ((((v22 - ((v25 * ((T1 ^ 4) - v27)) + (v30 * v31))) - (Upipe * v31)) - (max (0 : Float) (UAx * (T1 - Twall)))) - (((v22 - ((v25 * ((T2 ^ 4) - v27)) + (v30 * v44))) - (Upipe * v44)) - (max (0 : Float) (UAx * (T2 - Twall)))))) <= (((((((((4 : Float) * eps) * (0.0000000567 : Float)) * Ac) * (M ^ 3)) + v30) + Upipe) + UAx) * (Float.abs (T1 - T2)))))))))))))

#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 0.286779 0.228230 1.769681 1.711132 1.652584 1.594035 1.535486 1.476937 1.418388 1.359840 1.301291 1.242742))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.555587 1.497038 1.438489 1.379940 1.321392 1.262843 1.204294 1.145745 1.087196 1.028648 0.970099 0.911550))
#eval IO.println ("check_qNet_lipschitz " ++ toString (check_qNet_lipschitz 1.224395 1.165846 1.107297 1.048748 0.990200 0.931651 0.873102 0.814553 0.756004 0.697456 0.638907 0.580358))

def check_qNet_strictAnti (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T2 - Ta)
  let v41 := (T1 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!(T1 < T2) || ((((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T2 - Twall)))) < (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v41))) - (Upipe * v41)) - (max (0 : Float) (UAx * (T1 - Twall))))))))))))

#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.700627 1.642078 1.583529 1.524980 1.466432 1.407883 1.349334 1.290785 1.232236 1.173688 1.115139))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.369435 1.310886 1.252337 1.193788 1.135240 1.076691 1.018142 0.959593 0.901044 0.842496 0.783947))
#eval IO.println ("check_qNet_strictAnti " ++ toString (check_qNet_strictAnti 1.038243 0.979694 0.921145 0.862596 0.804048 0.745499 0.686950 0.628401 0.569852 0.511304 0.452755))

def qPipe (Upipe : Float) (Toil : Float) (Ta : Float) : Float :=
  (Upipe * (Toil - Ta))

#eval IO.println ("qPipe " ++ toString (qPipe 1.514475 1.455926 1.397377).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 1.183283 1.124734 1.066185).toBits)
#eval IO.println ("qPipe " ++ toString (qPipe 0.852091 0.793542 0.734993).toBits)

def qPot (UAx : Float) (Toil : Float) (Twall : Float) : Float :=
  (max (0 : Float) (UAx * (Toil - Twall)))

#eval IO.println ("qPot " ++ toString (qPot 1.328323 1.269774 1.211225).toBits)
#eval IO.println ("qPot " ++ toString (qPot 0.997131 0.938582 0.880033).toBits)
#eval IO.println ("qPot " ++ toString (qPot 0.665939 0.607390 0.548841).toBits)

def check_qPot_le (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  let v5 := (Toil - Twall)
  (!((0 : Float) <= UAx) || ((max (0 : Float) (UAx * v5)) <= (UAx * (max (0 : Float) v5))))

#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 1.142171 1.083622 1.025073))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.810979 0.752430 0.693881))
#eval IO.println ("check_qPot_le " ++ toString (check_qPot_le 0.479787 0.421238 0.362689))

def check_qPot_nonneg (UAx : Float) (Toil : Float) (Twall : Float) : Bool :=
  ((0 : Float) <= (max (0 : Float) (UAx * (Toil - Twall))))

#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.956019 0.897470 0.838921))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.624827 0.566278 0.507729))
#eval IO.println ("check_qPot_nonneg " ++ toString (check_qPot_nonneg 0.293635 0.235086 1.776537))

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

#eval IO.println ("radCeil " ++ toString (radCeil 0.397563 0.339014 0.280465).toBits)
#eval IO.println ("radCeil " ++ toString (radCeil 1.666371 1.607822 1.549273).toBits)
#eval IO.println ("radCeil " ++ toString (radCeil 1.335179 1.276630 1.218081).toBits)

def check_radCeil_nonneg (eps : Float) (qFlux : Float) (Ta : Float) : Bool :=
  ((0 : Float) <= (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4)))))

#eval IO.println ("check_radCeil_nonneg " ++ toString (check_radCeil_nonneg 0.211411 1.752862 1.694313))
#eval IO.println ("check_radCeil_nonneg " ++ toString (check_radCeil_nonneg 1.480219 1.421670 1.363121))
#eval IO.println ("check_radCeil_nonneg " ++ toString (check_radCeil_nonneg 1.149027 1.090478 1.031929))

def reCrit  : Float :=
  (2300 : Float)

#eval IO.println ("reCrit " ++ toString (reCrit).toBits)
#eval IO.println ("reCrit " ++ toString (reCrit).toBits)
#eval IO.println ("reCrit " ++ toString (reCrit).toBits)

def check_reachesVertical_iff (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v6 := (ym * a)
  (!((0 : Float) < ze) || ((v6 <= (hp * ze)) == ((v6 / ze) <= hp)))

#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.439107 1.380558 1.322009 1.263460))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 1.107915 1.049366 0.990817 0.932268))
#eval IO.println ("check_reachesVertical_iff " ++ toString (check_reachesVertical_iff 0.776723 0.718174 0.659625 0.601076))

def check_receiverPost_height  : Bool :=
  (feq ((1.30 : Float) - (0.05 : Float)) (1.25 : Float))

#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))
#eval IO.println ("check_receiverPost_height " ++ toString (check_receiverPost_height))

def recip (t_0 : Float) (t_1 : Float) (t_2 : Float) (t_3 : Float) (t_4 : Float) (t_5 : Float) (w_0 : Float) (w_1 : Float) (w_2 : Float) (w_3 : Float) (w_4 : Float) (w_5 : Float) : Float :=
  ((((((t_0 * w_3) + (t_1 * w_4)) + (t_2 * w_5)) + (t_3 * w_0)) + (t_4 * w_1)) + (t_5 * w_2))

#eval IO.println ("recip " ++ toString (recip 1.066803 1.008254 0.949705 0.891156 0.832608 0.774059 0.715510 0.656961 0.598412 0.539864 0.481315 0.422766).toBits)
#eval IO.println ("recip " ++ toString (recip 0.735611 0.677062 0.618513 0.559964 0.501416 0.442867 0.384318 0.325769 0.267220 0.208672 1.750123 1.691574).toBits)
#eval IO.println ("recip " ++ toString (recip 0.404419 0.345870 0.287321 0.228772 1.770224 1.711675 1.653126 1.594577 1.536028 1.477480 1.418931 1.360382).toBits)

def reflect3 (n_0 : Float) (n_1 : Float) (n_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v12 := ((2 : Float) * (((d_0 * n_0) + (d_1 * n_1)) + (d_2 * n_2)))
  #[(d_0 - (v12 * n_0)), (d_1 - (v12 * n_1)), (d_2 - (v12 * n_2))]

#eval IO.println ("reflect3 " ++ toString ((reflect3 0.880651 0.822102 0.763553 0.705004 0.646456 0.587907).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 0.549459 0.490910 0.432361 0.373812 0.315264 0.256715).map Float.toBits))
#eval IO.println ("reflect3 " ++ toString ((reflect3 0.218267 1.759718 1.701169 1.642620 1.584072 1.525523).map Float.toBits))

def rewardShapeRaw (dt : Float) (pIn : Float) (reach : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) : Float :=
  (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)

#eval IO.println ("rewardShapeRaw " ++ toString (rewardShapeRaw 0.694499 0.635950 0.577401 0.518852 0.460304 0.401755).toBits)
#eval IO.println ("rewardShapeRaw " ++ toString (rewardShapeRaw 0.363307 0.304758 0.246209 1.787660 1.729112 1.670563).toBits)
#eval IO.println ("rewardShapeRaw " ++ toString (rewardShapeRaw 1.632115 1.573566 1.515017 1.456468 1.397920 1.339371).toBits)

def rewardStep (parentRaw : Float) (dt : Float) (pIn : Float) (reach : Float) (rewardDiv : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) (pPump : Float) (filmExcess : Float) (pumpPrice : Float) (degPrice : Float) : Array Float :=
  #[(((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach), ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump)), (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess)), (((parentRaw + (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)) - ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))) - (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))), ((((parentRaw + (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)) - ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))) - (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))) / rewardDiv)]

#eval IO.println ("rewardStep " ++ toString ((rewardStep 0.508347 0.449798 0.391249 0.332700 0.274152 0.215603 1.757054 1.698505 1.639956 1.581408 1.522859 1.464310).map Float.toBits))
#eval IO.println ("rewardStep " ++ toString ((rewardStep 1.777155 1.718606 1.660057 1.601508 1.542960 1.484411 1.425862 1.367313 1.308764 1.250216 1.191667 1.133118).map Float.toBits))
#eval IO.println ("rewardStep " ++ toString ((rewardStep 1.445963 1.387414 1.328865 1.270316 1.211768 1.153219 1.094670 1.036121 0.977572 0.919024 0.860475 0.801926).map Float.toBits))

def check_rewardStep_nonneg (dt : Float) (pIn : Float) (reach : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) (parentRaw : Float) (rewardDiv : Float) (pPump : Float) (filmExcess : Float) (pumpPrice : Float) (degPrice : Float) : Bool :=
  let v23 := (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)
  (!((0 : Float) <= dt) || (!((0 : Float) <= pIn) || (!((0 : Float) <= reach) || (!((0 : Float) <= capShaping) || (!((0 : Float) <= rotiReward) || (!((0 : Float) <= rotiEnergy) || ((0 : Float) <= v23)))))))

#eval IO.println ("check_rewardStep_nonneg " ++ toString (check_rewardStep_nonneg 0.322195 0.263646 0.205097 1.746548 1.688000 1.629451 1.570902 1.512353 1.453804 1.395256 1.336707 1.278158))
#eval IO.println ("check_rewardStep_nonneg " ++ toString (check_rewardStep_nonneg 1.591003 1.532454 1.473905 1.415356 1.356808 1.298259 1.239710 1.181161 1.122612 1.064064 1.005515 0.946966))
#eval IO.println ("check_rewardStep_nonneg " ++ toString (check_rewardStep_nonneg 1.259811 1.201262 1.142713 1.084164 1.025616 0.967067 0.908518 0.849969 0.791420 0.732872 0.674323 0.615774))

def check_rewardStep_units (parentRaw : Float) (dt : Float) (pIn : Float) (reach : Float) (rewardDiv : Float) (capShaping : Float) (rotiReward : Float) (rotiEnergy : Float) (pPump : Float) (filmExcess : Float) (pumpPrice : Float) (degPrice : Float) : Bool :=
  let v18 := (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)
  let v23 := ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : Float) pPump))
  let v27 := (((degPrice * rotiReward) * dt) * (max (0 : Float) filmExcess))
  (!(!(feq rewardDiv (0 : Float))) || (feq ((((((parentRaw + v18) - v23) - v27) / rewardDiv) * rewardDiv) - parentRaw) ((v18 - v23) - v27)))

#eval IO.println ("check_rewardStep_units " ++ toString (check_rewardStep_units 1.736043 1.677494 1.618945 1.560396 1.501848 1.443299 1.384750 1.326201 1.267652 1.209104 1.150555 1.092006))
#eval IO.println ("check_rewardStep_units " ++ toString (check_rewardStep_units 1.404851 1.346302 1.287753 1.229204 1.170656 1.112107 1.053558 0.995009 0.936460 0.877912 0.819363 0.760814))
#eval IO.println ("check_rewardStep_units " ++ toString (check_rewardStep_units 1.073659 1.015110 0.956561 0.898012 0.839464 0.780915 0.722366 0.663817 0.605268 0.546720 0.488171 0.429622))

def reynolds (Q : Float) (D : Float) (T : Float) : Float :=
  let v4 := (T - (273.15 : Float))
  ((((((1020.62 : Float) - ((0.614254 : Float) * v4)) - ((0.000321 : Float) * (v4 ^ 2))) * (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))) * D) / ((Float.exp (((586.375 : Float) / (v4 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float)))

#eval IO.println ("reynolds " ++ toString (reynolds 1.549891 1.491342 1.432793).toBits)
#eval IO.println ("reynolds " ++ toString (reynolds 1.218699 1.160150 1.101601).toBits)
#eval IO.println ("reynolds " ++ toString (reynolds 0.887507 0.828958 0.770409).toBits)

def check_reynolds_mono (Q1 : Float) (Q2 : Float) (D : Float) (T : Float) : Bool :=
  let v7 := (T - (273.15 : Float))
  let v15 := (((1020.62 : Float) - ((0.614254 : Float) * v7)) - ((0.000321 : Float) * (v7 ^ 2)))
  let v22 := (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))
  let v34 := ((Float.exp (((586.375 : Float) / (v7 + (62.5 : Float))) - (2.2809 : Float))) / (1000 : Float))
  (!((0 : Float) < D) || (!((0 : Float) <= v15) || (!(Q1 <= Q2) || ((((v15 * (Q1 / v22)) * D) / v34) <= (((v15 * (Q2 / v22)) * D) / v34)))))

#eval IO.println ("check_reynolds_mono " ++ toString (check_reynolds_mono 1.363739 1.305190 1.246641 1.188092))
#eval IO.println ("check_reynolds_mono " ++ toString (check_reynolds_mono 1.032547 0.973998 0.915449 0.856900))
#eval IO.println ("check_reynolds_mono " ++ toString (check_reynolds_mono 0.701355 0.642806 0.584257 0.525708))

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

#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.991435 0.932886 0.874337))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.660243 0.601694 0.543145))
#eval IO.println ("check_rim_under_F_iff " ++ toString (check_rim_under_F_iff 0.329051 0.270502 0.211953))

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

#eval IO.println ("rollY " ++ toString ((rollY 0.432979 0.374430 0.315881).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 1.701787 1.643238 1.584689).map Float.toBits))
#eval IO.println ("rollY " ++ toString ((rollY 1.370595 1.312046 1.253497).map Float.toBits))

def rollerRadius (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Float :=
  (Float.sqrt (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2)))

#eval IO.println ("rollerRadius " ++ toString (rollerRadius 0.246827 1.788278 1.729729 1.671180 1.612632 1.554083).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.515635 1.457086 1.398537 1.339988 1.281440 1.222891).toBits)
#eval IO.println ("rollerRadius " ++ toString (rollerRadius 1.184443 1.125894 1.067345 1.008796 0.950248 0.891699).toBits)

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

#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 1.288371 1.229822 1.171273 1.112724 1.054176 0.995627))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.957179 0.898630 0.840081 0.781532 0.722984 0.664435))
#eval IO.println ("check_rollerRadius_pos " ++ toString (check_rollerRadius_pos 0.625987 0.567438 0.508889 0.450340 0.391792 0.333243))

def check_rollerRadius_sq (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) : Bool :=
  let v10 := (((c_chord / (2 : Float)) ^ 2) + (c_apexH ^ 2))
  (feq ((Float.sqrt v10) ^ 2) v10)

#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 1.102219 1.043670 0.985121 0.926572 0.868024 0.809475))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.771027 0.712478 0.653929 0.595380 0.536832 0.478283))
#eval IO.println ("check_rollerRadius_sq " ++ toString (check_rollerRadius_sq 0.439835 0.381286 0.322737 0.264188 0.205640 1.747091))

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

#eval IO.println ("rot " ++ toString ((rot 0.729915 0.671366 0.612817).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 0.398723 0.340174 0.281625).map Float.toBits))
#eval IO.println ("rot " ++ toString ((rot 1.667531 1.608982 1.550433).map Float.toBits))

def rotz (delta : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v4 := (Float.cos delta)
  let v6 := (Float.sin delta)
  #[((v4 * v_0) - (v6 * v_1)), ((v6 * v_0) + (v4 * v_1)), v_2]

#eval IO.println ("rotz " ++ toString ((rotz 0.543763 0.485214 0.426665 0.368116).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 0.212571 1.754022 1.695473 1.636924).map Float.toBits))
#eval IO.println ("rotz " ++ toString ((rotz 1.481379 1.422830 1.364281 1.305732).map Float.toBits))

def check_rotz_dot (delta : Float) (u_0 : Float) (u_1 : Float) (u_2 : Float) (v_0 : Float) (v_1 : Float) (v_2 : Float) : Bool :=
  let v7 := (Float.cos delta)
  let v9 := (Float.sin delta)
  let v24 := (u_2 * v_2)
  (feq (((((v7 * u_0) - (v9 * u_1)) * ((v7 * v_0) - (v9 * v_1))) + (((v9 * u_0) + (v7 * u_1)) * ((v9 * v_0) + (v7 * v_1)))) + v24) (((u_0 * v_0) + (u_1 * v_1)) + v24))

#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 0.357611 0.299062 0.240513 1.781964 1.723416 1.664867 1.606318))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.626419 1.567870 1.509321 1.450772 1.392224 1.333675 1.275126))
#eval IO.println ("check_rotz_dot " ++ toString (check_rotz_dot 1.295227 1.236678 1.178129 1.119580 1.061032 1.002483 0.943934))

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

#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.771459 1.712910 1.654361 1.595812 1.537264 1.478715 1.420166 1.361617 1.303068 1.244520 1.185971 1.127422).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.440267 1.381718 1.323169 1.264620 1.206072 1.147523 1.088974 1.030425 0.971876 0.913328 0.854779 0.796230).map Float.toBits))
#eval IO.println ("sampleRay " ++ toString ((sampleRay 1.109075 1.050526 0.991977 0.933428 0.874880 0.816331 0.757782 0.699233 0.640684 0.582136 0.523587 0.465038).map Float.toBits))

def screwLength (R : Float) (a : Float) : Float :=
  ((R / (2 : Float)) - (R - (Float.sqrt ((R ^ 2) - (a ^ 2)))))

#eval IO.println ("screwLength " ++ toString (screwLength 1.585307 1.526758).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 1.254115 1.195566).toBits)
#eval IO.println ("screwLength " ++ toString (screwLength 0.922923 0.864374).toBits)

def check_screwLength_eq_focal (R : Float) (a : Float) : Bool :=
  let v8 := (R - (Float.sqrt ((R ^ 2) - (a ^ 2))))
  (feq ((R / (2 : Float)) - v8) ((R - (R / ((2 : Float) * (Float.cos (Float.asin ((0 : Float) / R)))))) - v8))

#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.399155 1.340606))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 1.067963 1.009414))
#eval IO.println ("check_screwLength_eq_focal " ++ toString (check_screwLength_eq_focal 0.736771 0.678222))

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

#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.840699 0.782150).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 0.509507 0.450958).map Float.toBits))
#eval IO.println ("screwTwist " ++ toString ((screwTwist 1.778315 1.719766).map Float.toBits))

def check_screwTwist_zero (apexH : Float) (zBolt : Float) : Bool :=
  let v8 := (apexH * (0 : Float))
  let v13 := (feq (0 : Float) (0 : Float))
  ((feq (1 : Float) (1 : Float)) && (v13 && (v13 && ((feq (0 : Float) (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float)))) && ((feq zBolt ((zBolt * (1 : Float)) - v8)) && (feq (0 : Float) (v8 - ((0 : Float) * (1 : Float)))))))))

#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.654547 0.595998))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 0.323355 0.264806))
#eval IO.println ("check_screwTwist_zero " ++ toString (check_screwTwist_zero 1.592163 1.533614))

def screwWrench (xh : Float) (zBolt : Float) (h : Float) : Array Float :=
  let v5 := ((0 : Float) * (0 : Float))
  let v8 := (zBolt * (0 : Float))
  let v9 := (xh * (0 : Float))
  let v11 := (xh * (1 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v5 - (zBolt * (1 : Float))), (v8 - v9), (v11 - v5), (0 : Float), (0 : Float), (1 : Float), (((0 : Float) * (1 : Float)) - v8), (v8 - v11), (v9 - v5), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (0 : Float), (1 : Float), (1 : Float), (0 : Float), (0 : Float), (-h), zBolt, (0 : Float)]

#eval IO.println ("screwWrench " ++ toString ((screwWrench 0.468395 0.409846 0.351297).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.737203 1.678654 1.620105).map Float.toBits))
#eval IO.println ("screwWrench " ++ toString ((screwWrench 1.406011 1.347462 1.288913).map Float.toBits))

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

#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 0.282243 0.223694 1.765145 1.706596 1.648048 1.589499 1.530950 1.472401 1.413852))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.551051 1.492502 1.433953 1.375404 1.316856 1.258307 1.199758 1.141209 1.082660))
#eval IO.println ("check_screw_freedom " ++ toString (check_screw_freedom 1.219859 1.161310 1.102761 1.044212 0.985664 0.927115 0.868566 0.810017 0.751468))

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

#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.696091 1.637542 1.578993))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.364899 1.306350 1.247801))
#eval IO.println ("check_screw_reciprocal " ++ toString (check_screw_reciprocal 1.033707 0.975158 0.916609))

def secondaryMag (L : Float) (dm : Float) : Float :=
  ((L - dm) / dm)

#eval IO.println ("secondaryMag " ++ toString (secondaryMag 1.509939 1.451390).toBits)
#eval IO.println ("secondaryMag " ++ toString (secondaryMag 1.178747 1.120198).toBits)
#eval IO.println ("secondaryMag " ++ toString (secondaryMag 0.847555 0.789006).toBits)

def setLength (rod : Float) (excess : Float) : Float :=
  (rod - excess)

#eval IO.println ("setLength " ++ toString (setLength 1.323787 1.265238).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.992595 0.934046).toBits)
#eval IO.println ("setLength " ++ toString (setLength 0.661403 0.602854).toBits)

def shift (x : Float) (h : Array Float) : Array Float :=
  #[x, h[0]!, h[1]!, h[2]!, h[3]!, h[4]!, h[5]!, h[6]!, h[7]!, h[8]!, h[9]!, h[10]!, h[11]!, h[12]!, h[13]!, h[14]!]

#eval IO.println ("shift " ++ toString ((shift 1.137635 #[1.414251, 1.355702, 1.297153, 1.238604, 1.180056, 1.121507, 1.062958, 1.004409, 0.945860, 0.887312, 0.828763, 0.770214, 0.711665, 0.653116, 0.594568, 0.536019]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 0.806443 #[1.083059, 1.024510, 0.965961, 0.907412, 0.848864, 0.790315, 0.731766, 0.673217, 0.614668, 0.556120, 0.497571, 0.439022, 0.380473, 0.321924, 0.263376, 0.204827]).map Float.toBits))
#eval IO.println ("shift " ++ toString ((shift 0.475251 #[0.751867, 0.693318, 0.634769, 0.576220, 0.517672, 0.459123, 0.400574, 0.342025, 0.283476, 0.224928, 1.766379, 1.707830, 1.649281, 1.590732, 1.532184, 1.473635]).map Float.toBits))

def check_shift_head (x : Float) (h : Array Float) : Bool :=
  (feq x x)

#eval IO.println ("check_shift_head " ++ toString (check_shift_head 0.951483 #[1.228099, 1.169550, 1.111001, 1.052452, 0.993904, 0.935355, 0.876806, 0.818257, 0.759708, 0.701160, 0.642611, 0.584062, 0.525513, 0.466964, 0.408416, 0.349867]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 0.620291 #[0.896907, 0.838358, 0.779809, 0.721260, 0.662712, 0.604163, 0.545614, 0.487065, 0.428516, 0.369968, 0.311419, 0.252870, 1.794321, 1.735772, 1.677224, 1.618675]))
#eval IO.println ("check_shift_head " ++ toString (check_shift_head 0.289099 #[0.565715, 0.507166, 0.448617, 0.390068, 0.331520, 0.272971, 0.214422, 1.755873, 1.697324, 1.638776, 1.580227, 1.521678, 1.463129, 1.404580, 1.346032, 1.287483]))

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

#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.620723))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 1.289531))
#eval IO.println ("check_sigmoid_ge_of_nonneg " ++ toString (check_sigmoid_ge_of_nonneg 0.958339))

def check_sigmoid_slope_le (x : Float) : Bool :=
  let v1 := (1.0 / (1.0 + Float.exp (-x)))
  ((v1 * ((1 : Float) - v1)) <= ((1 : Float) / (4 : Float)))

#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.434571))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 1.103379))
#eval IO.println ("check_sigmoid_slope_le " ++ toString (check_sigmoid_slope_le 0.772187))

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

#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 1.062267 1.003718 0.945169 0.886620))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.731075 0.672526 0.613977 0.555428))
#eval IO.println ("check_slackHarmless_of_budget " ++ toString (check_slackHarmless_of_budget 0.399883 0.341334 0.282785 0.224236))

def check_slackHarmless_of_lever (f : Float) (eps : Float) (delta : Float) (rw : Float) (h : Float) : Bool :=
  let v6 := (f * (Float.tan eps))
  let v10 := ((((2 : Float) * f) * delta) / rw)
  (!(v6 <= (h - v10)) || ((v6 + v10) <= h))

#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.876115 0.817566 0.759017 0.700468 0.641920))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.544923 0.486374 0.427825 0.369276 0.310728))
#eval IO.println ("check_slackHarmless_of_lever " ++ toString (check_slackHarmless_of_lever 0.213731 1.755182 1.696633 1.638084 1.579536))

def slackSpot (f : Float) (delta : Float) (rw : Float) : Float :=
  ((((2 : Float) * f) * delta) / rw)

#eval IO.println ("slackSpot " ++ toString (slackSpot 0.689963 0.631414 0.572865).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 0.358771 0.300222 0.241673).toBits)
#eval IO.println ("slackSpot " ++ toString (slackSpot 1.627579 1.569030 1.510481).toBits)

def slotExit (a : Float) (ze : Float) : Float :=
  (Float.atan (a / ze))

#eval IO.println ("slotExit " ++ toString (slotExit 0.503811 0.445262).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.772619 1.714070).toBits)
#eval IO.println ("slotExit " ++ toString (slotExit 1.441427 1.382878).toBits)

def check_slot_exit_hashemi  : Bool :=
  let v6 := ((0.8 : Float) / ((Float.sqrt (3.36 : Float)) - (1 : Float)))
  (((0.960 : Float) < v6) && (v6 < (0.9605 : Float)))

#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))
#eval IO.println ("check_slot_exit_hashemi " ++ toString (check_slot_exit_hashemi))

def sphereBestFocus (R : Float) (H : Float) : Float :=
  (((R / (2 : Float)) + (R / ((2 : Float) * (Float.sqrt ((1 : Float) - ((H / R) ^ 2)))))) / (2 : Float))

#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.731507 1.672958).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.400315 1.341766).toBits)
#eval IO.println ("sphereBestFocus " ++ toString (sphereBestFocus 1.069123 1.010574).toBits)

def sphereBlur (R : Float) (H : Float) : Float :=
  let v4 := (H / R)
  let v13 := (v4 ^ 2)
  (((R / (2 : Float)) - (R - (R / ((2 : Float) * (Float.cos (Float.asin v4)))))) * ((((2 : Float) * v4) * (Float.sqrt ((1 : Float) - v13))) / ((1 : Float) - ((2 : Float) * v13))))

#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.545355 1.486806).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 1.214163 1.155614).toBits)
#eval IO.println ("sphereBlur " ++ toString (sphereBlur 0.882971 0.824422).toBits)

def sphereDev (R : Float) (h : Float) (p : Float) : Float :=
  let v5 := (h / R)
  let v6 := (v5 ^ 2)
  let v8 := (Float.sqrt ((1 : Float) - v6))
  (((R / ((2 : Float) * v8)) - p) * ((((2 : Float) * v5) * v8) / ((1 : Float) - ((2 : Float) * v6))))

#eval IO.println ("sphereDev " ++ toString (sphereDev 1.359203 1.300654 1.242105).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 1.028011 0.969462 0.910913).toBits)
#eval IO.println ("sphereDev " ++ toString (sphereDev 0.696819 0.638270 0.579721).toBits)

def sphereFocal (R : Float) (h : Float) : Float :=
  (R - (R / ((2 : Float) * (Float.cos (Float.asin (h / R))))))

#eval IO.println ("sphereFocal " ++ toString (sphereFocal 1.173051 1.114502).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.841859 0.783310).toBits)
#eval IO.println ("sphereFocal " ++ toString (sphereFocal 0.510667 0.452118).toBits)

def sphereHit (R : Float) (O_0 : Float) (O_1 : Float) (O_2 : Float) (d_0 : Float) (d_1 : Float) (d_2 : Float) : Array Float :=
  let v7 := (O_2 - R)
  let v12 := (((d_0 * O_0) + (d_1 * O_1)) + (d_2 * v7))
  let v24 := ((-v12) + (Float.sqrt ((v12 ^ 2) - ((((O_0 ^ 2) + (O_1 ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
  #[(O_0 + (v24 * d_0)), (O_1 + (v24 * d_1)), (O_2 + (v24 * d_2)), ((-(O_0 + (v24 * d_0))) / R), ((-(O_1 + (v24 * d_1))) / R), ((R - (O_2 + (v24 * d_2))) / R)]

#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.986899 0.928350 0.869801 0.811252 0.752704 0.694155 0.635606).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.655707 0.597158 0.538609 0.480060 0.421512 0.362963 0.304414).map Float.toBits))
#eval IO.println ("sphereHit " ++ toString ((sphereHit 0.324515 0.265966 0.207417 1.748868 1.690320 1.631771 1.573222).map Float.toBits))

def spotTau  : Float :=
  (0.005 : Float)

#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)
#eval IO.println ("spotTau " ++ toString (spotTau).toBits)

def check_sq_bounds_neg (x : Float) (lo : Float) (hi : Float) : Bool :=
  let v8 := (x ^ 2)
  (!(lo < x) || (!(x < hi) || (!(hi <= (0 : Float)) || (((hi ^ 2) < v8) && (v8 < (lo ^ 2))))))

#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.614595 0.556046 0.497497))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 0.283403 0.224854 1.766305))
#eval IO.println ("check_sq_bounds_neg " ++ toString (check_sq_bounds_neg 1.552211 1.493662 1.435113))

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

#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 0.242291 1.783742 1.725193 1.666644 1.608096 1.549547 1.490998 1.432449 1.373900 1.315352))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.511099 1.452550 1.394001 1.335452 1.276904 1.218355 1.159806 1.101257 1.042708 0.984160))
#eval IO.println ("check_steady_conservation " ++ toString (check_steady_conservation 1.179907 1.121358 1.062809 1.004260 0.945712 0.887163 0.828614 0.770065 0.711516 0.652968))

def check_steady_pot_le_abs (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Toil : Float) (Twall : Float) (Ta : Float) : Bool :=
  let v17 := (alpha * Pin)
  let v26 := (Toil - Ta)
  let v34 := (max (0 : Float) (UAx * (Toil - Twall)))
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) <= Upipe) || (!((0 : Float) <= Ta) || (!(Ta <= Toil) || (!(feq (((v17 - ((((eps * (0.0000000567 : Float)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v26))) - (Upipe * v26)) - v34) (0 : Float)) || (v34 <= v17))))))))

#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.656139 1.597590 1.539041 1.480492 1.421944 1.363395 1.304846 1.246297 1.187748 1.129200))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 1.324947 1.266398 1.207849 1.149300 1.090752 1.032203 0.973654 0.915105 0.856556 0.798008))
#eval IO.println ("check_steady_pot_le_abs " ++ toString (check_steady_pot_le_abs 0.993755 0.935206 0.876657 0.818108 0.759560 0.701011 0.642462 0.583913 0.525364 0.466816))

def check_steady_unique (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Upipe : Float) (UAx : Float) (Pin : Float) (Twall : Float) (Ta : Float) (T1 : Float) (T2 : Float) : Bool :=
  let v19 := (alpha * Pin)
  let v22 := ((eps * (0.0000000567 : Float)) * Ac)
  let v24 := (Ta ^ 4)
  let v27 := (hC * Ac)
  let v28 := (T1 - Ta)
  let v42 := (T2 - Ta)
  (!((0 : Float) <= eps) || (!((0 : Float) <= Ac) || (!((0 : Float) <= hC) || (!((0 : Float) < Upipe) || (!((0 : Float) <= UAx) || (!((0 : Float) <= T1) || (!((0 : Float) <= T2) || (!(feq (((v19 - ((v22 * ((T1 ^ 4) - v24)) + (v27 * v28))) - (Upipe * v28)) - (max (0 : Float) (UAx * (T1 - Twall)))) (0 : Float)) || (!(feq (((v19 - ((v22 * ((T2 ^ 4) - v24)) + (v27 * v42))) - (Upipe * v42)) - (max (0 : Float) (UAx * (T2 - Twall)))) (0 : Float)) || (feq T1 T2))))))))))

#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.469987 1.411438 1.352889 1.294340 1.235792 1.177243 1.118694 1.060145 1.001596 0.943048 0.884499))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 1.138795 1.080246 1.021697 0.963148 0.904600 0.846051 0.787502 0.728953 0.670404 0.611856 0.553307))
#eval IO.println ("check_steady_unique " ++ toString (check_steady_unique 0.807603 0.749054 0.690505 0.631956 0.573408 0.514859 0.456310 0.397761 0.339212 0.280664 0.222115))

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

#eval IO.println ("step " ++ toString ((step 1.283835 1.225286 1.166737 1.108188 1.049640 0.991091 0.932542 0.873993 0.815444 0.756896 0.698347 0.639798 0.581249 0.522700 0.464152 0.405603).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.952643 0.894094 0.835545 0.776996 0.718448 0.659899 0.601350 0.542801 0.484252 0.425704 0.367155 0.308606 0.250057 1.791508 1.732960 1.674411).map Float.toBits))
#eval IO.println ("step " ++ toString ((step 0.621451 0.562902 0.504353 0.445804 0.387256 0.328707 0.270158 0.211609 1.753060 1.694512 1.635963 1.577414 1.518865 1.460316 1.401768 1.343219).map Float.toBits))

def stepParams  : Array Float :=
  #[(0.05 : Float), (Float.sqrt ((((1.84 : Float) / (2 : Float)) ^ 2) + ((0.80 : Float) ^ 2))), (0.03 : Float), (1.22 : Float), (0.34 : Float), (0.8 : Float), ((Float.sqrt (3.36 : Float)) - (1 : Float))]

#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))
#eval IO.println ("stepParams " ++ toString ((stepParams).map Float.toBits))

def strutStrain (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) : Float :=
  ((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2))

#eval IO.println ("strutStrain " ++ toString (strutStrain 0.911531 0.852982 0.794433 0.735884 0.677336 0.618787 0.560238 0.501689 0.443140).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.580339 0.521790 0.463241 0.404692 0.346144 0.287595 0.229046 1.770497 1.711948).toBits)
#eval IO.println ("strutStrain " ++ toString (strutStrain 0.249147 1.790598 1.732049 1.673500 1.614952 1.556403 1.497854 1.439305 1.380756).toBits)

def check_strut_resists_lean (P_0 : Float) (P_1 : Float) (P_2 : Float) (Q_0 : Float) (Q_1 : Float) (Q_2 : Float) (delta_0 : Float) (delta_1 : Float) (delta_2 : Float) (eps : Float) : Bool :=
  (!((0 : Float) < eps) || (!(Q_0 < P_0) || (!(feq delta_0 (-eps)) || (!(feq delta_1 (0 : Float)) || (!(feq delta_2 (0 : Float)) || (((((P_0 - Q_0) * delta_0) + ((P_1 - Q_1) * delta_1)) + ((P_2 - Q_2) * delta_2)) < (0 : Float)))))))

#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.725379 0.666830 0.608281 0.549732 0.491184 0.432635 0.374086 0.315537 0.256988 1.798440))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 0.394187 0.335638 0.277089 0.218540 1.759992 1.701443 1.642894 1.584345 1.525796 1.467248))
#eval IO.println ("check_strut_resists_lean " ++ toString (check_strut_resists_lean 1.662995 1.604446 1.545897 1.487348 1.428800 1.370251 1.311702 1.253153 1.194604 1.136056))

def sunDir (elSun : Float) (azSun : Float) : Array Float :=
  let v2 := (Float.cos elSun)
  #[(v2 * (Float.cos azSun)), (v2 * (Float.sin azSun)), (Float.sin elSun)]

#eval IO.println ("sunDir " ++ toString ((sunDir 0.539227 0.480678).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 0.208035 1.749486).map Float.toBits))
#eval IO.println ("sunDir " ++ toString ((sunDir 1.476843 1.418294).map Float.toBits))

def check_sunDir_rot (elSun : Float) (azSun : Float) (delta : Float) : Bool :=
  let v3 := (Float.cos elSun)
  let v4 := (azSun + delta)
  let v9 := (Float.sin elSun)
  let v10 := (Float.cos delta)
  let v12 := (v3 * (Float.cos azSun))
  let v14 := (v3 * (Float.sin azSun))
  let v16 := (Float.sin delta)
  ((feq (v3 * (Float.cos v4)) ((v10 * v12) - (v16 * v14))) && ((feq (v3 * (Float.sin v4)) ((v16 * v12) + (v10 * v14))) && (feq v9 v9)))

#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 0.353075 0.294526 0.235977))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.621883 1.563334 1.504785))
#eval IO.println ("check_sunDir_rot " ++ toString (check_sunDir_rot 1.290691 1.232142 1.173593))

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

#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.766923 1.708374 1.649825 1.591276).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.435731 1.377182 1.318633 1.260084).map Float.toBits))
#eval IO.println ("sunInDish " ++ toString ((sunInDish 1.104539 1.045990 0.987441 0.928892).map Float.toBits))

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

#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.580771 1.522222 1.463673 1.405124 1.346576))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 1.249579 1.191030 1.132481 1.073932 1.015384))
#eval IO.println ("check_sunInDish_equivariant " ++ toString (check_sunInDish_equivariant 0.918387 0.859838 0.801289 0.742740 0.684192))

def sunRate  : Float :=
  (0.000073 : Float)

#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)
#eval IO.println ("sunRate " ++ toString (sunRate).toBits)

def sunReachableS (tDead : Float) (elSun : Float) : Float :=
  (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))

#eval IO.println ("sunReachableS " ++ toString (sunReachableS 1.208467 1.149918).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.877275 0.818726).toBits)
#eval IO.println ("sunReachableS " ++ toString (sunReachableS 0.546083 0.487534).toBits)

def check_sunReachableS_mem (tDead : Float) (elSun : Float) : Bool :=
  let v10 := (1.0 / (1.0 + Float.exp (-((elSun - (((3.141592653589793 : Float) / (2 : Float)) - tDead)) / (0.01 : Float)))))
  (((0 : Float) <= v10) && (v10 <= (1 : Float)))

#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 1.022315 0.963766))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.691123 0.632574))
#eval IO.println ("check_sunReachableS_mem " ++ toString (check_sunReachableS_mem 0.359931 0.301382))

def check_sunReachableS_slope (tDead : Float) (e1 : Float) (e2 : Float) : Bool :=
  let v6 := (((3.141592653589793 : Float) / (2 : Float)) - tDead)
  ((Float.abs ((1.0 / (1.0 + Float.exp (-((e1 - v6) / (0.01 : Float))))) - (1.0 / (1.0 + Float.exp (-((e2 - v6) / (0.01 : Float))))))) <= ((Float.abs (e1 - e2)) / ((4 : Float) * (0.01 : Float))))

#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.836163 0.777614 0.719065))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 0.504971 0.446422 0.387873))
#eval IO.println ("check_sunReachableS_slope " ++ toString (check_sunReachableS_slope 1.773779 1.715230 1.656681))

def swingFocus (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Array Float :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  #[((P_1 + (d * v5)) + (f * (-v5))), ((P_2 - (d * v8)) + (f * v8))]

#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.650011 0.591462 0.532913 0.474364 0.415816).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 0.318819 0.260270 0.201721 1.743172 1.684624).map Float.toBits))
#eval IO.println ("swingFocus " ++ toString ((swingFocus 1.587627 1.529078 1.470529 1.411980 1.353432).map Float.toBits))

def check_swingFocus_circle (P_1 : Float) (P_2 : Float) (d : Float) (f : Float) (t : Float) : Bool :=
  let v5 := (Float.sin t)
  let v8 := (Float.cos t)
  (feq (((((P_1 + (d * v5)) + (f * (-v5))) - P_1) ^ 2) + ((((P_2 - (d * v8)) + (f * v8)) - P_2) ^ 2)) ((d - f) ^ 2))

#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 0.463859 0.405310 0.346761 0.288212 0.229664))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.732667 1.674118 1.615569 1.557020 1.498472))
#eval IO.println ("check_swingFocus_circle " ++ toString (check_swingFocus_circle 1.401475 1.342926 1.284377 1.225828 1.167280))

def swingNormal (t : Float) : Array Float :=
  #[(-(Float.sin t)), (Float.cos t)]

#eval IO.println ("swingNormal " ++ toString ((swingNormal 0.277707).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.546515).map Float.toBits))
#eval IO.println ("swingNormal " ++ toString ((swingNormal 1.215323).map Float.toBits))

def check_swingNormal_unit (t : Float) : Bool :=
  (feq (((-(Float.sin t)) ^ 2) + ((Float.cos t) ^ 2)) (1 : Float))

#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.691555))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.360363))
#eval IO.println ("check_swingNormal_unit " ++ toString (check_swingNormal_unit 1.029171))

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

#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.505403 1.446854 1.388305 1.329756 1.271208 1.212659).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 1.174211 1.115662 1.057113 0.998564 0.940016 0.881467).toBits)
#eval IO.println ("swingOfLength " ++ toString (swingOfLength 0.843019 0.784470 0.725921 0.667372 0.608824 0.550275).toBits)

def swingTwist (apexH : Float) (zBolt : Float) : Array Float :=
  let v8 := (apexH * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))), ((zBolt * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("swingTwist " ++ toString ((swingTwist 1.319251 1.260702).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.988059 0.929510).map Float.toBits))
#eval IO.println ("swingTwist " ++ toString ((swingTwist 0.656867 0.598318).map Float.toBits))

def swingVertex (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Array Float :=
  #[(P_1 + (f * (Float.sin t))), (P_2 - (f * (Float.cos t)))]

#eval IO.println ("swingVertex " ++ toString ((swingVertex 1.133099 1.074550 1.016001 0.957452).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.801907 0.743358 0.684809 0.626260).map Float.toBits))
#eval IO.println ("swingVertex " ++ toString ((swingVertex 0.470715 0.412166 0.353617 0.295068).map Float.toBits))

def swingVertexAt (P_1 : Float) (P_2 : Float) (d : Float) (t : Float) : Array Float :=
  #[(P_1 + (d * (Float.sin t))), (P_2 - (d * (Float.cos t)))]

#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.946947 0.888398 0.829849 0.771300).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.615755 0.557206 0.498657 0.440108).map Float.toBits))
#eval IO.println ("swingVertexAt " ++ toString ((swingVertexAt 0.284563 0.226014 1.767465 1.708916).map Float.toBits))

def check_swing_focusCircle (P_1 : Float) (P_2 : Float) (f : Float) (t : Float) : Bool :=
  (feq ((((P_1 + (f * (Float.sin t))) - P_1) ^ 2) + (((P_2 - (f * (Float.cos t))) - P_2) ^ 2)) (f ^ 2))

#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.760795 0.702246 0.643697 0.585148))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 0.429603 0.371054 0.312505 0.253956))
#eval IO.println ("check_swing_focusCircle " ++ toString (check_swing_focusCircle 1.698411 1.639862 1.581313 1.522764))

def check_swing_lift (apexH : Float) (zBolt : Float) (p_0 : Float) (p_1 : Float) (p_2 : Float) : Bool :=
  let v11 := (apexH * (0 : Float))
  let v19 := ((0 : Float) * p_0)
  (feq ((((1 : Float) * p_1) - v19) + (v11 - ((0 : Float) * (1 : Float)))) p_1)

#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.574643 0.516094 0.457545 0.398996 0.340448))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 0.243451 1.784902 1.726353 1.667804 1.609256))
#eval IO.println ("check_swing_lift " ++ toString (check_swing_lift 1.512259 1.453710 1.395161 1.336612 1.278064))

def swungPt (y0 : Float) (z0 : Float) (t : Float) : Array Float :=
  let v3 := (Float.cos t)
  let v5 := (Float.sin t)
  #[((y0 * v3) + (z0 * v5)), (((-y0) * v5) + (z0 * v3))]

#eval IO.println ("swungPt " ++ toString ((swungPt 0.388491 0.329942 0.271393).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.657299 1.598750 1.540201).map Float.toBits))
#eval IO.println ("swungPt " ++ toString ((swungPt 1.326107 1.267558 1.209009).map Float.toBits))

def systemVolts  : Float :=
  (12 : Float)

#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)
#eval IO.println ("systemVolts " ++ toString (systemVolts).toBits)

def check_tanh_abs_lt_one (x : Float) : Bool :=
  ((Float.abs (Float.tanh x)) < (1 : Float))

#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.616187))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 1.284995))
#eval IO.println ("check_tanh_abs_lt_one " ++ toString (check_tanh_abs_lt_one 0.953803))

def check_tension_le_of_holds (Tmax : Float) (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v8 := (W * rcm)
  (!((0 : Float) <= W) || (!((0 : Float) <= rcm) || (!((0 : Float) < rw) || (!(v8 <= (Tmax * rw)) || (((v8 * (Float.sin t)) / rw) <= Tmax)))))

#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.430035 1.371486 1.312937 1.254388 1.195840))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 1.098843 1.040294 0.981745 0.923196 0.864648))
#eval IO.println ("check_tension_le_of_holds " ++ toString (check_tension_le_of_holds 0.767651 0.709102 0.650553 0.592004 0.533456))

def tilt (v_0 : Float) (v_1 : Float) (v_2 : Float) (e1 : Float) (e2 : Float) : Array Float :=
  let v5 := (v_0 + e1)
  let v6 := (v_1 + e2)
  let v12 := (Float.sqrt (((v5 ^ 2) + (v6 ^ 2)) + (v_2 ^ 2)))
  #[(v5 / v12), (v6 / v12), (v_2 / v12)]

#eval IO.println ("tilt " ++ toString ((tilt 1.243883 1.185334 1.126785 1.068236 1.009688).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 0.912691 0.854142 0.795593 0.737044 0.678496).map Float.toBits))
#eval IO.println ("tilt " ++ toString ((tilt 0.581499 0.522950 0.464401 0.405852 0.347304).map Float.toBits))

def tiltOfMismatch (e : Float) : Float :=
  (e / ((2 : Float) * (0.8 : Float)))

#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 1.057731).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.726539).toBits)
#eval IO.println ("tiltOfMismatch " ++ toString (tiltOfMismatch 0.395347).toBits)

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

#eval IO.println ("traceBeam " ++ toString ((traceBeam 0.871579 0.813030 0.754481 0.695932 0.637384 0.578835 0.520286 0.461737 0.403188 0.344640 0.286091 0.227542 1.768993 1.710444 1.651896 1.593347 1.534798 1.476249).map Float.toBits))
#eval IO.println ("traceBeam " ++ toString ((traceBeam 0.540387 0.481838 0.423289 0.364740 0.306192 0.247643 1.789094 1.730545 1.671996 1.613448 1.554899 1.496350 1.437801 1.379252 1.320704 1.262155 1.203606 1.145057).map Float.toBits))
#eval IO.println ("traceBeam " ++ toString ((traceBeam 0.209195 1.750646 1.692097 1.633548 1.575000 1.516451 1.457902 1.399353 1.340804 1.282256 1.223707 1.165158 1.106609 1.048060 0.989512 0.930963 0.872414 0.813865).map Float.toBits))

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

#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 0.685427 0.626878 0.568329 0.509780 0.451232 0.392683 0.334134 0.275585 0.217036 1.758488 1.699939 1.641390 1.582841 1.524292 1.465744 1.407195 1.348646 1.290097))
#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 0.354235 0.295686 0.237137 1.778588 1.720040 1.661491 1.602942 1.544393 1.485844 1.427296 1.368747 1.310198 1.251649 1.193100 1.134552 1.076003 1.017454 0.958905))
#eval IO.println ("check_traceBeam_captured " ++ toString (check_traceBeam_captured 1.623043 1.564494 1.505945 1.447396 1.388848 1.330299 1.271750 1.213201 1.154652 1.096104 1.037555 0.979006 0.920457 0.861908 0.803360 0.744811 0.686262 0.627713))

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

#eval IO.println ("traceConic " ++ toString ((traceConic 0.499275 0.440726 0.382177 0.323628 0.265080 0.206531 1.747982 1.689433 1.630884).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 1.768083 1.709534 1.650985 1.592436 1.533888 1.475339 1.416790 1.358241 1.299692).map Float.toBits))
#eval IO.println ("traceConic " ++ toString ((traceConic 1.436891 1.378342 1.319793 1.261244 1.202696 1.144147 1.085598 1.027049 0.968500).map Float.toBits))

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

#eval IO.println ("traceFacet " ++ toString ((traceFacet 0.313123 0.254574 1.796025 1.737476 1.678928 1.620379 1.561830 1.503281 1.444732 1.386184).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.581931 1.523382 1.464833 1.406284 1.347736 1.289187 1.230638 1.172089 1.113540 1.054992).map Float.toBits))
#eval IO.println ("traceFacet " ++ toString ((traceFacet 1.250739 1.192190 1.133641 1.075092 1.016544 0.957995 0.899446 0.840897 0.782348 0.723800).map Float.toBits))

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

#eval IO.println ("traceRay " ++ toString ((traceRay 1.540819 1.482270 1.423721 1.365172 1.306624 1.248075 1.189526 1.130977 1.072428 1.013880 0.955331 0.896782).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 1.209627 1.151078 1.092529 1.033980 0.975432 0.916883 0.858334 0.799785 0.741236 0.682688 0.624139 0.565590).map Float.toBits))
#eval IO.println ("traceRay " ++ toString ((traceRay 0.878435 0.819886 0.761337 0.702788 0.644240 0.585691 0.527142 0.468593 0.410044 0.351496 0.292947 0.234398).map Float.toBits))

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

#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.354667 1.296118 1.237569 1.179020 1.120472 1.061923 1.003374 0.944825 0.886276 0.827728 0.769179 0.710630 0.652081 0.593532 0.534984 0.476435 0.417886 0.359337).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 1.023475 0.964926 0.906377 0.847828 0.789280 0.730731 0.672182 0.613633 0.555084 0.496536 0.437987 0.379438 0.320889 0.262340 0.203792 1.745243 1.686694 1.628145).map Float.toBits))
#eval IO.println ("traceRayErr " ++ toString ((traceRayErr 0.692283 0.633734 0.575185 0.516636 0.458088 0.399539 0.340990 0.282441 0.223892 1.765344 1.706795 1.648246 1.589697 1.531148 1.472600 1.414051 1.355502 1.296953).map Float.toBits))

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

#eval IO.println ("traceRayK " ++ toString ((traceRayK 1.168515 1.109966 1.051417 0.992868 0.934320 0.875771 0.817222 0.758673 0.700124 0.641576 0.583027 0.524478 0.465929).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.837323 0.778774 0.720225 0.661676 0.603128 0.544579 0.486030 0.427481 0.368932 0.310384 0.251835 1.793286 1.734737).map Float.toBits))
#eval IO.println ("traceRayK " ++ toString ((traceRayK 0.506131 0.447582 0.389033 0.330484 0.271936 0.213387 1.754838 1.696289 1.637740 1.579192 1.520643 1.462094 1.403545).map Float.toBits))

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

#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.982363 0.923814 0.865265 0.806716 0.748168 0.689619 0.631070 0.572521 0.513972 0.455424 0.396875 0.338326 0.279777 0.221228 1.762680 1.704131 1.645582 1.587033 1.528484).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.651171 0.592622 0.534073 0.475524 0.416976 0.358427 0.299878 0.241329 1.782780 1.724232 1.665683 1.607134 1.548585 1.490036 1.431488 1.372939 1.314390 1.255841 1.197292).map Float.toBits))
#eval IO.println ("traceRayKErr " ++ toString ((traceRayKErr 0.319979 0.261430 0.202881 1.744332 1.685784 1.627235 1.568686 1.510137 1.451588 1.393040 1.334491 1.275942 1.217393 1.158844 1.100296 1.041747 0.983198 0.924649 0.866100).map Float.toBits))

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

#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.796211 0.737662 0.679113 0.620564 0.562016 0.503467 0.444918 0.386369).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 0.465019 0.406470 0.347921 0.289372 0.230824 1.772275 1.713726 1.655177).map Float.toBits))
#eval IO.println ("traceSphere " ++ toString ((traceSphere 1.733827 1.675278 1.616729 1.558180 1.499632 1.441083 1.382534 1.323985).map Float.toBits))

def check_trackerBudget_iff (f : Float) (eps : Float) (h : Float) : Bool :=
  let v5 := (Float.tan eps)
  (!((0 : Float) < f) || (((f * v5) <= h) == (v5 <= (h / f))))

#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.610059 0.551510 0.492961))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 0.278867 0.220318 1.761769))
#eval IO.println ("check_trackerBudget_iff " ++ toString (check_trackerBudget_iff 1.547675 1.489126 1.430577))

def check_tracker_margin_hashemi (eps : Float) : Bool :=
  let v2 := (Float.tan eps)
  ((((1 : Float) * v2) <= (0.03 : Float)) == (v2 <= (0.03 : Float)))

#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 0.423907))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.692715))
#eval IO.println ("check_tracker_margin_hashemi " ++ toString (check_tracker_margin_hashemi 1.361523))

def check_tracking_power_tiny (W : Float) (rcm : Float) (omega : Float) (t : Float) : Bool :=
  (!((0 : Float) <= W) || (!(W <= (1000 : Float)) || (!((0 : Float) <= rcm) || (!(rcm <= (1 : Float)) || (!((0 : Float) <= omega) || (!(omega <= (0.000073 : Float)) || (((((W * rcm) * (Float.sin t)) * omega) <= (0.073 : Float)) && ((0.073 : Float) < ((0.015 : Float) * (5 : Float))))))))))

#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 0.237755 1.779206 1.720657 1.662108))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 1.506563 1.448014 1.389465 1.330916))
#eval IO.println ("check_tracking_power_tiny " ++ toString (check_tracking_power_tiny 1.175371 1.116822 1.058273 0.999724))

def transitTime (L : Float) (Q : Float) (D : Float) : Float :=
  (L / (max (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float))) (0.000001 : Float)))

#eval IO.println ("transitTime " ++ toString (transitTime 1.651603 1.593054 1.534505).toBits)
#eval IO.println ("transitTime " ++ toString (transitTime 1.320411 1.261862 1.203313).toBits)
#eval IO.println ("transitTime " ++ toString (transitTime 0.989219 0.930670 0.872121).toBits)

def tunnelThroughput  : Float :=
  ((0.94 : Float) * (0.96 : Float))

#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)
#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)
#eval IO.println ("tunnelThroughput " ++ toString (tunnelThroughput).toBits)

def turnLoss (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (Tin : Float) : Float :=
  let v8 := (Ac / (8 : Float))
  ((((eps * (0.0000000567 : Float)) * v8) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v8) * (Tin - Ta)))

#eval IO.println ("turnLoss " ++ toString (turnLoss 1.279299 1.220750 1.162201 1.103652 1.045104).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 0.948107 0.889558 0.831009 0.772460 0.713912).toBits)
#eval IO.println ("turnLoss " ++ toString (turnLoss 0.616915 0.558366 0.499817 0.441268 0.382720).toBits)

def turnOut (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Float :=
  let v12 := (Ac / (8 : Float))
  (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))

#eval IO.println ("turnOut " ++ toString (turnOut 1.093147 1.034598 0.976049 0.917500 0.858952 0.800403 0.741854 0.683305).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 0.761955 0.703406 0.644857 0.586308 0.527760 0.469211 0.410662 0.352113).toBits)
#eval IO.println ("turnOut " ++ toString (turnOut 0.430763 0.372214 0.313665 0.255116 1.796568 1.738019 1.679470 1.620921).toBits)

def check_turnOut_eq (alpha : Float) (eps : Float) (Ac : Float) (hC : Float) (Ta : Float) (mcp : Float) (P : Float) (Tin : Float) : Bool :=
  let v12 := (Ac / (8 : Float))
  let v24 := (Tin + (((alpha * P) - ((((eps * (0.0000000567 : Float)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp))
  (feq v24 v24)

#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 0.906995 0.848446 0.789897 0.731348 0.672800 0.614251 0.555702 0.497153))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 0.575803 0.517254 0.458705 0.400156 0.341608 0.283059 0.224510 1.765961))
#eval IO.println ("check_turnOut_eq " ++ toString (check_turnOut_eq 0.244611 1.786062 1.727513 1.668964 1.610416 1.551867 1.493318 1.434769))

def uPipeCyl (L : Float) (Do : Float) (Dins : Float) (kIns : Float) (V : Float) : Float :=
  (L / (((Float.log (max (Dins / Do) (1.0001 : Float))) / (((2 : Float) * (3.141592653589793 : Float)) * kIns)) + ((1 : Float) / ((((5.7 : Float) + ((3.8 : Float) * V)) * (3.141592653589793 : Float)) * Dins))))

#eval IO.println ("uPipeCyl " ++ toString (uPipeCyl 0.720843 0.662294 0.603745 0.545196 0.486648).toBits)
#eval IO.println ("uPipeCyl " ++ toString (uPipeCyl 0.389651 0.331102 0.272553 0.214004 1.755456).toBits)
#eval IO.println ("uPipeCyl " ++ toString (uPipeCyl 1.658459 1.599910 1.541361 1.482812 1.424264).toBits)

def check_uPipeCyl_pos (L : Float) (Do : Float) (Dins : Float) (kIns : Float) (V : Float) : Bool :=
  (!((0 : Float) < L) || (!((0 : Float) < kIns) || (!((0 : Float) < Dins) || (!((0 : Float) <= V) || ((0 : Float) < (L / (((Float.log (max (Dins / Do) (1.0001 : Float))) / (((2 : Float) * (3.141592653589793 : Float)) * kIns)) + ((1 : Float) / ((((5.7 : Float) + ((3.8 : Float) * V)) * (3.141592653589793 : Float)) * Dins)))))))))

#eval IO.println ("check_uPipeCyl_pos " ++ toString (check_uPipeCyl_pos 0.534691 0.476142 0.417593 0.359044 0.300496))
#eval IO.println ("check_uPipeCyl_pos " ++ toString (check_uPipeCyl_pos 0.203499 1.744950 1.686401 1.627852 1.569304))
#eval IO.println ("check_uPipeCyl_pos " ++ toString (check_uPipeCyl_pos 1.472307 1.413758 1.355209 1.296660 1.238112))

def uaOf (h : Float) (A : Float) : Float :=
  (h * A)

#eval IO.println ("uaOf " ++ toString (uaOf 0.348539 0.289990).toBits)
#eval IO.println ("uaOf " ++ toString (uaOf 1.617347 1.558798).toBits)
#eval IO.println ("uaOf " ++ toString (uaOf 1.286155 1.227606).toBits)

def check_uaOf_mono (h1 : Float) (h2 : Float) (A : Float) : Bool :=
  (!((0 : Float) <= A) || (!(h1 <= h2) || ((h1 * A) <= (h2 * A))))

#eval IO.println ("check_uaOf_mono " ++ toString (check_uaOf_mono 1.762387 1.703838 1.645289))
#eval IO.println ("check_uaOf_mono " ++ toString (check_uaOf_mono 1.431195 1.372646 1.314097))
#eval IO.println ("check_uaOf_mono " ++ toString (check_uaOf_mono 1.100003 1.041454 0.982905))

def unit3 (v_0 : Float) (v_1 : Float) (v_2 : Float) : Array Float :=
  let v10 := (Float.sqrt (max (((v_0 ^ 2) + (v_1 ^ 2)) + (v_2 ^ 2)) (0.000000000000000001 : Float)))
  #[(v_0 / v10), (v_1 / v10), (v_2 / v10)]

#eval IO.println ("unit3 " ++ toString ((unit3 1.576235 1.517686 1.459137).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 1.245043 1.186494 1.127945).map Float.toBits))
#eval IO.println ("unit3 " ++ toString ((unit3 0.913851 0.855302 0.796753).map Float.toBits))

def velOf (Q : Float) (D : Float) : Float :=
  (Q / (((3.141592653589793 : Float) * (D ^ 2)) / (4 : Float)))

#eval IO.println ("velOf " ++ toString (velOf 1.390083 1.331534).toBits)
#eval IO.println ("velOf " ++ toString (velOf 1.058891 1.000342).toBits)
#eval IO.println ("velOf " ++ toString (velOf 0.727699 0.669150).toBits)

def wBearX (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(1 : Float), (0 : Float), (0 : Float), (v8 - (b_zBearing * (0 : Float))), ((b_zBearing * (1 : Float)) - v8), (v8 - ((0 : Float) * (1 : Float)))]

#eval IO.println ("wBearX " ++ toString ((wBearX 1.203931 1.145382 1.086833 1.028284 0.969736 0.911187).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.872739 0.814190 0.755641 0.697092 0.638544 0.579995).map Float.toBits))
#eval IO.println ("wBearX " ++ toString ((wBearX 0.541547 0.482998 0.424449 0.365900 0.307352 0.248803).map Float.toBits))

def wBearY (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (1 : Float), (0 : Float), (v8 - (b_zBearing * (1 : Float))), ((b_zBearing * (0 : Float)) - v8), (((0 : Float) * (1 : Float)) - v8)]

#eval IO.println ("wBearY " ++ toString ((wBearY 1.017779 0.959230 0.900681 0.842132 0.783584 0.725035).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 0.686587 0.628038 0.569489 0.510940 0.452392 0.393843).map Float.toBits))
#eval IO.println ("wBearY " ++ toString ((wBearY 0.355395 0.296846 0.238297 1.779748 1.721200 1.662651).map Float.toBits))

def wDrive (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) (F : Float) : Array Float :=
  let v14 := (c_chord / (2 : Float))
  let v19 := (Float.sqrt ((v14 ^ 2) + (c_apexH ^ 2)))
  let v21 := (-((F * v14) / v19))
  let v23 := ((F * c_apexH) / v19)
  #[v21, v23, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v23)), ((b_zRail * v21) - (c_apexH * (0 : Float))), ((c_apexH * v23) - (v14 * v21))]

#eval IO.println ("wDrive " ++ toString ((wDrive 0.831627 0.773078 0.714529 0.655980 0.597432 0.538883 0.480334 0.421785 0.363236 0.304688 0.246139 1.787590 1.729041).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 0.500435 0.441886 0.383337 0.324788 0.266240 0.207691 1.749142 1.690593 1.632044 1.573496 1.514947 1.456398 1.397849).map Float.toBits))
#eval IO.println ("wDrive " ++ toString ((wDrive 1.769243 1.710694 1.652145 1.593596 1.535048 1.476499 1.417950 1.359401 1.300852 1.242304 1.183755 1.125206 1.066657).map Float.toBits))

def wRollN (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v16 := (-(c_chord / (2 : Float)))
  let v18 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v16 * (1 : Float)) - v18), (v18 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v16 * (0 : Float)))]

#eval IO.println ("wRollN " ++ toString ((wRollN 0.645475 0.586926 0.528377 0.469828 0.411280 0.352731 0.294182 0.235633 1.777084 1.718536 1.659987 1.601438).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 0.314283 0.255734 1.797185 1.738636 1.680088 1.621539 1.562990 1.504441 1.445892 1.387344 1.328795 1.270246).map Float.toBits))
#eval IO.println ("wRollN " ++ toString ((wRollN 1.583091 1.524542 1.465993 1.407444 1.348896 1.290347 1.231798 1.173249 1.114700 1.056152 0.997603 0.939054).map Float.toBits))

def wRollNr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v14 := (-(c_chord / (2 : Float)))
  #[c_apexH, v14, (0 : Float), ((v14 * (0 : Float)) - (b_zRail * v14)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v14) - (v14 * c_apexH))]

#eval IO.println ("wRollNr " ++ toString ((wRollNr 0.459323 0.400774 0.342225 0.283676 0.225128 1.766579 1.708030 1.649481 1.590932 1.532384 1.473835 1.415286).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.728131 1.669582 1.611033 1.552484 1.493936 1.435387 1.376838 1.318289 1.259740 1.201192 1.142643 1.084094).map Float.toBits))
#eval IO.println ("wRollNr " ++ toString ((wRollNr 1.396939 1.338390 1.279841 1.221292 1.162744 1.104195 1.045646 0.987097 0.928548 0.870000 0.811451 0.752902).map Float.toBits))

def wRollP (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v15 := (c_chord / (2 : Float))
  let v17 := (b_zRail * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), ((v15 * (1 : Float)) - v17), (v17 - (c_apexH * (1 : Float))), ((c_apexH * (0 : Float)) - (v15 * (0 : Float)))]

#eval IO.println ("wRollP " ++ toString ((wRollP 0.273171 0.214622 1.756073 1.697524 1.638976 1.580427 1.521878 1.463329 1.404780 1.346232 1.287683 1.229134).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 1.541979 1.483430 1.424881 1.366332 1.307784 1.249235 1.190686 1.132137 1.073588 1.015040 0.956491 0.897942).map Float.toBits))
#eval IO.println ("wRollP " ++ toString ((wRollP 1.210787 1.152238 1.093689 1.035140 0.976592 0.918043 0.859494 0.800945 0.742396 0.683848 0.625299 0.566750).map Float.toBits))

def wRollPr (c_chord : Float) (c_apexH : Float) (c_aBase : Float) (c_cross : Float) (c_barW : Float) (c_rDrive : Float) (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v13 := (c_chord / (2 : Float))
  #[c_apexH, v13, (0 : Float), ((v13 * (0 : Float)) - (b_zRail * v13)), ((b_zRail * c_apexH) - (c_apexH * (0 : Float))), ((c_apexH * v13) - (v13 * c_apexH))]

#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.687019 1.628470 1.569921 1.511372 1.452824 1.394275 1.335726 1.277177 1.218628 1.160080 1.101531 1.042982).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.355827 1.297278 1.238729 1.180180 1.121632 1.063083 1.004534 0.945985 0.887436 0.828888 0.770339 0.711790).map Float.toBits))
#eval IO.println ("wRollPr " ++ toString ((wRollPr 1.024635 0.966086 0.907537 0.848988 0.790440 0.731891 0.673342 0.614793 0.556244 0.497696 0.439147 0.380598).map Float.toBits))

def wStop (b_rRail : Float) (b_zRail : Float) (b_zTube : Float) (b_zBearing : Float) (b_dPipe : Float) (b_nSpokes : Float) : Array Float :=
  let v8 := ((0 : Float) * (1 : Float))
  let v9 := (b_zBearing * (0 : Float))
  let v12 := ((0 : Float) * (0 : Float))
  #[(0 : Float), (0 : Float), (1 : Float), (v8 - v9), (v9 - v8), (v12 - v12)]

#eval IO.println ("wStop " ++ toString ((wStop 1.500867 1.442318 1.383769 1.325220 1.266672 1.208123).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 1.169675 1.111126 1.052577 0.994028 0.935480 0.876931).map Float.toBits))
#eval IO.println ("wStop " ++ toString ((wStop 0.838483 0.779934 0.721385 0.662836 0.604288 0.545739).map Float.toBits))

def wallTemp (Tbulk : Float) (qFlux : Float) (h : Float) (eps : Float) (Ta : Float) : Float :=
  (max Tbulk (min (Tbulk + (qFlux / h)) (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))))

#eval IO.println ("wallTemp " ++ toString (wallTemp 1.314715 1.256166 1.197617 1.139068 1.080520).toBits)
#eval IO.println ("wallTemp " ++ toString (wallTemp 0.983523 0.924974 0.866425 0.807876 0.749328).toBits)
#eval IO.println ("wallTemp " ++ toString (wallTemp 0.652331 0.593782 0.535233 0.476684 0.418136).toBits)

def check_wallTemp_ge_bulk (Tbulk : Float) (qFlux : Float) (h : Float) (eps : Float) (Ta : Float) : Bool :=
  (Tbulk <= (max Tbulk (min (Tbulk + (qFlux / h)) (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4)))))))

#eval IO.println ("check_wallTemp_ge_bulk " ++ toString (check_wallTemp_ge_bulk 1.128563 1.070014 1.011465 0.952916 0.894368))
#eval IO.println ("check_wallTemp_ge_bulk " ++ toString (check_wallTemp_ge_bulk 0.797371 0.738822 0.680273 0.621724 0.563176))
#eval IO.println ("check_wallTemp_ge_bulk " ++ toString (check_wallTemp_ge_bulk 0.466179 0.407630 0.349081 0.290532 0.231984))

def check_wallTemp_le_rad (Tbulk : Float) (qFlux : Float) (h : Float) (eps : Float) (Ta : Float) : Bool :=
  let v16 := (Float.sqrt (Float.sqrt (((max (0 : Float) qFlux) / ((max eps (0.01 : Float)) * (0.0000000567 : Float))) + ((max Ta (0 : Float)) ^ 4))))
  (!(Tbulk <= v16) || ((max Tbulk (min (Tbulk + (qFlux / h)) v16)) <= v16))

#eval IO.println ("check_wallTemp_le_rad " ++ toString (check_wallTemp_le_rad 0.942411 0.883862 0.825313 0.766764 0.708216))
#eval IO.println ("check_wallTemp_le_rad " ++ toString (check_wallTemp_le_rad 0.611219 0.552670 0.494121 0.435572 0.377024))
#eval IO.println ("check_wallTemp_le_rad " ++ toString (check_wallTemp_le_rad 0.280027 0.221478 1.762929 1.704380 1.645832))

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

#eval IO.println ("wireLen " ++ toString (wireLen 0.570107 0.511558 0.453009 0.394460 0.335912).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 0.238915 1.780366 1.721817 1.663268 1.604720).toBits)
#eval IO.println ("wireLen " ++ toString (wireLen 1.507723 1.449174 1.390625 1.332076 1.273528).toBits)

def wireLever (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Float :=
  (((P_1 * B_2) - (P_2 * B_1)) / (Float.sqrt (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))))

#eval IO.println ("wireLever " ++ toString (wireLever 0.383955 0.325406 0.266857 0.208308).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.652763 1.594214 1.535665 1.477116).toBits)
#eval IO.println ("wireLever " ++ toString (wireLever 1.321571 1.263022 1.204473 1.145924).toBits)

def check_wireLever_edge_formula (ym : Float) (hp : Float) (a : Float) (ze : Float) (t : Float) : Bool :=
  let v5 := (-ym)
  let v6 := (-a)
  let v7 := (Float.cos t)
  let v9 := (-ze)
  let v10 := (Float.sin t)
  let v12 := ((v6 * v7) + (v9 * v10))
  let v16 := (((-v6) * v10) + (v9 * v7))
  (feq (((v5 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v10)) / (Float.sqrt ((((ym - (a * v7)) - (ze * v10)) ^ 2) + ((((a * v10) - (ze * v7)) - hp) ^ 2)))))

#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.797803 1.739254 1.680705 1.622156 1.563608))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.466611 1.408062 1.349513 1.290964 1.232416))
#eval IO.println ("check_wireLever_edge_formula " ++ toString (check_wireLever_edge_formula 1.135419 1.076870 1.018321 0.959772 0.901224))

def check_wireLever_pos_iff (P_1 : Float) (P_2 : Float) (B_1 : Float) (B_2 : Float) : Bool :=
  let v9 := (((B_1 - P_1) ^ 2) + ((B_2 - P_2) ^ 2))
  let v13 := ((P_1 * B_2) - (P_2 * B_1))
  (!((0 : Float) < v9) || (((0 : Float) < (v13 / (Float.sqrt v9))) == ((0 : Float) < v13)))

#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.611651 1.553102 1.494553 1.436004))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 1.280459 1.221910 1.163361 1.104812))
#eval IO.println ("check_wireLever_pos_iff " ++ toString (check_wireLever_pos_iff 0.949267 0.890718 0.832169 0.773620))

def check_wireLever_rest (ym : Float) (hp : Float) (a : Float) (ze : Float) : Bool :=
  let v4 := (-ym)
  let v5 := (-a)
  let v7 := (Float.cos (0 : Float))
  let v9 := (-ze)
  let v10 := (Float.sin (0 : Float))
  let v12 := ((v5 * v7) + (v9 * v10))
  let v16 := (((-v5) * v10) + (v9 * v7))
  (feq (((v4 * v16) - (hp * v12)) / (Float.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) (((ym * ze) + (hp * a)) / (Float.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2)))))

#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.425499 1.366950 1.308401 1.249852))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 1.094307 1.035758 0.977209 0.918660))
#eval IO.println ("check_wireLever_rest " ++ toString (check_wireLever_rest 0.763115 0.704566 0.646017 0.587468))

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

#eval IO.println ("wireTension " ++ toString (wireTension 0.867043 0.808494 0.749945 0.691396).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 0.535851 0.477302 0.418753 0.360204).toBits)
#eval IO.println ("wireTension " ++ toString (wireTension 0.204659 1.746110 1.687561 1.629012).toBits)

def check_wire_recip_swing (apexH : Float) (zBolt : Float) (q_0 : Float) (q_1 : Float) (q_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Bool :=
  let v14 := (apexH * (0 : Float))
  let v18 := (q_1 * f_2)
  (feq (((((((1 : Float) * (v18 - (q_2 * f_1))) + ((0 : Float) * ((q_2 * f_0) - (q_0 * f_2)))) + ((0 : Float) * ((q_0 * f_1) - (q_1 * f_0)))) + ((((0 : Float) * (0 : Float)) - (zBolt * (0 : Float))) * f_0)) + (((zBolt * (1 : Float)) - v14) * f_1)) + ((v14 - ((0 : Float) * (1 : Float))) * f_2)) (v18 - ((q_2 - zBolt) * f_1)))

#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.680891 0.622342 0.563793 0.505244 0.446696 0.388147 0.329598 0.271049))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 0.349699 0.291150 0.232601 1.774052 1.715504 1.656955 1.598406 1.539857))
#eval IO.println ("check_wire_recip_swing " ++ toString (check_wire_recip_swing 1.618507 1.559958 1.501409 1.442860 1.384312 1.325763 1.267214 1.208665))

def check_wire_short_of_vertical  : Bool :=
  ((((0.34 : Float) * ((Float.sqrt (3.36 : Float)) - (1 : Float))) - ((1.22 : Float) * (0.8 : Float))) < (0 : Float))

#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))
#eval IO.println ("check_wire_short_of_vertical " ++ toString (check_wire_short_of_vertical))

def check_wire_taut_iff (W : Float) (rcm : Float) (rw : Float) (t : Float) : Bool :=
  let v9 := (Float.sin t)
  (!((0 : Float) < W) || (!((0 : Float) < rcm) || (!((0 : Float) < rw) || (((0 : Float) <= (((W * rcm) * v9) / rw)) == ((0 : Float) <= v9)))))

#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 0.308587 0.250038 1.791489 1.732940))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.577395 1.518846 1.460297 1.401748))
#eval IO.println ("check_wire_taut_iff " ++ toString (check_wire_taut_iff 1.246203 1.187654 1.129105 1.070556))

def wrapRad (d : Float) : Float :=
  let v3 := ((2 : Float) * (3.141592653589793 : Float))
  (d - (v3 * (Float.floor ((d + (3.141592653589793 : Float)) / v3))))

#eval IO.println ("wrapRad " ++ toString (wrapRad 1.722435).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 1.391243).toBits)
#eval IO.println ("wrapRad " ++ toString (wrapRad 1.060051).toBits)

def check_wrapRad_mem (d : Float) : Bool :=
  let v4 := ((2 : Float) * (3.141592653589793 : Float))
  let v9 := (d - (v4 * (Float.floor ((d + (3.141592653589793 : Float)) / v4))))
  (((-(3.141592653589793 : Float)) <= v9) && (v9 < (3.141592653589793 : Float)))

#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 1.536283))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 1.205091))
#eval IO.println ("check_wrapRad_mem " ++ toString (check_wrapRad_mem 0.873899))

def wrenchAt (p_0 : Float) (p_1 : Float) (p_2 : Float) (f_0 : Float) (f_1 : Float) (f_2 : Float) : Array Float :=
  #[f_0, f_1, f_2, ((p_1 * f_2) - (p_2 * f_1)), ((p_2 * f_0) - (p_0 * f_2)), ((p_0 * f_1) - (p_1 * f_0))]

#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.350131 1.291582 1.233033 1.174484 1.115936 1.057387).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 1.018939 0.960390 0.901841 0.843292 0.784744 0.726195).map Float.toBits))
#eval IO.println ("wrenchAt " ++ toString ((wrenchAt 0.687747 0.629198 0.570649 0.512100 0.453552 0.395003).map Float.toBits))

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

#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.791675 0.733126 0.674577))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 0.460483 0.401934 0.343385))
#eval IO.println ("check_yaw_lifts_nothing " ++ toString (check_yaw_lifts_nothing 1.729291 1.670742 1.612193))

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
import RequestProject.HashemiTraceProps
import RequestProject.HashemiPolicy
import RequestProject.HashemiBeamdown
import RequestProject.HashemiReward
namespace TandoorHashemi
open Classical
set_option maxHeartbeats 4000000
set_option maxRecDepth 8000

theorem Fits_ccc : Fits = fun (b : TandoorHashemi.FixedBase) (c : TandoorHashemi.Carriage) =>
    (b.rRail = (Real.sqrt (((c.chord / (2 : ℝ)) ^ 2) + (c.apexH ^ 2)))) := rfl

theorem FitsReceiver_ccc : FitsReceiver = fun (a : ℝ) (b2 : ℝ) (rm : ℝ) =>
    let v4 := (rm ^ 2)
    (((Real.pi * v4) * ((a * (Real.sqrt ((1 : ℝ) + (v4 / b2)))) - a)) ≤ ((Real.pi * ((0.06 : ℝ) ^ 2)) * (0.04 : ℝ))) := rfl

theorem HangerClearsPost_ccc : HangerClearsPost = fun (eyeOffset : ℝ) (dRod : ℝ) =>
    ((dRod / (2 : ℝ)) < eyeOffset) := rfl

theorem HoldsDish_ccc : HoldsDish = fun (Tmax : ℝ) (W : ℝ) (rcm : ℝ) (rw : ℝ) =>
    ((W * rcm) ≤ (Tmax * rw)) := rfl

theorem Leg_footLong_ccc : Leg.footLong = fun (l : TandoorHashemi.Leg) =>
    (l.foot - l.footShort) := rfl

theorem LostSun_ccc : LostSun = fun (tDead : ℝ) (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) (ε : ℝ) =>
    let v8 := (Real.pi / (2 : ℝ))
    let v11 := (Real.sin t)
    let v13 := (v11 * (Real.cos az))
    let v15 := (v11 * (Real.sin az))
    let v16 := (Real.cos t)
    let v17 := (Real.cos elSun)
    let v19 := (v17 * (Real.cos azSun))
    let v21 := (v17 * (Real.sin azSun))
    let v22 := (Real.sin elSun)
    let v27 := (((v13 * v19) + (v15 * v21)) + (v16 * v22))
    let v42 := (Real.sqrt (((((v15 * v22) - (v16 * v21)) ^ 2) + (((v16 * v19) - (v13 * v22)) ^ 2)) + (((v13 * v21) - (v15 * v19)) ^ 2)))
    (((v8 - tDead) ≤ elSun) ∧ (ε < (if (v27 ≤ (0 : ℝ)) then (v8 + (Real.arctan ((-v27) / (max v42 (0.000000000001 : ℝ))))) else (Real.arctan (v42 / v27))))) := rfl

theorem MastClears_ccc : MastClears = fun (ym : ℝ) (a : ℝ) (ze : ℝ) =>
    ((Real.sqrt ((a ^ 2) + (ze ^ 2))) < ym) := rfl

theorem PumpWithinBudget_ccc : PumpWithinBudget = fun (Pelec : ℝ) (Pbudget : ℝ) =>
    (Pelec ≤ Pbudget) := rfl

theorem ReachesVertical_ccc : ReachesVertical = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) =>
    ((ym * a) ≤ (hp * ze)) := rfl

theorem Rgas_ccc : Rgas =
    (8.314 : ℝ) := rfl

theorem SlackHarmless_ccc : SlackHarmless = fun (f : ℝ) (ε : ℝ) (δ : ℝ) (h : ℝ) =>
    (((f * (Real.tan ε)) + δ) ≤ h) := rfl

theorem SunReachable_ccc : SunReachable = fun (tDead : ℝ) (elSun : ℝ) =>
    (((Real.pi / (2 : ℝ)) - tDead) ≤ elSun) := rfl

theorem TankHolds_ccc : TankHolds = fun (Vtank : ℝ) (Vloop : ℝ) (frac : ℝ) =>
    ((Vloop * frac) ≤ Vtank) := rfl

theorem TrackerBudget_ccc : TrackerBudget = fun (f : ℝ) (ε : ℝ) (h : ℝ) =>
    ((f * (Real.tan ε)) ≤ h) := rfl

theorem azFull_ccc : azFull =
    (((0.035 : ℝ) * Real.pi) / (180 : ℝ)) := rfl

theorem azRate_ccc : azRate = fun (ωm : ℝ) (rw : ℝ) (R : ℝ) =>
    ((ωm * rw) / R) := rfl

theorem beamAxis_ccc : beamAxis = fun (t : ℝ) (β : ℝ) =>
    let v2 := (t + β)
    ![(Real.sin v2), (0 : ℝ), (-(Real.cos v2))] := rfl

theorem bisectStep_ccc : bisectStep = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (L : ℝ) (lohi : ℝ × ℝ) =>
    let v9 := ((lohi.1 + lohi.2) / (2 : ℝ))
    let v11 := (-a)
    let v12 := (Real.cos v9)
    let v14 := (-ze)
    let v15 := (Real.sin v9)
    let v28 := (L < (Real.sqrt (((((v11 * v12) + (v14 * v15)) - (-ym)) ^ 2) + (((((-v11) * v15) + (v14 * v12)) - hp) ^ 2))))
    ((if v28 then v9 else lohi.1), (if v28 then lohi.2 else v9)) := rfl

theorem boltStress_ccc : boltStress = fun (W : ℝ) (reach : ℝ) (d : ℝ) =>
    (((W / (2 : ℝ)) * reach) / ((Real.pi * (d ^ 3)) / (32 : ℝ))) := rfl

theorem braceHeight_ccc : braceHeight = fun (l : TandoorHashemi.Leg) =>
    (Real.sqrt ((l.brace ^ 2) - ((l.foot - l.footShort) ^ 2))) := rfl

theorem cableArea_ccc : cableArea =
    (0.0000015 : ℝ) := rfl

theorem cableDrop_ccc : cableDrop = fun (L : ℝ) (I : ℝ) =>
    ((((0.0000000172 : ℝ) * ((2 : ℝ) * L)) * I) / (0.0000015 : ℝ)) := rfl

theorem capSag_ccc : capSag = fun (a : ℝ) (b2 : ℝ) (rm : ℝ) =>
    ((a * (Real.sqrt ((1 : ℝ) + ((rm ^ 2) / b2)))) - a) := rfl

theorem captureS_ccc : captureS = fun (rc : ℝ) (rad : ℝ) =>
    (Real.sigmoid ((rc - rad) / (0.005 : ℝ))) := rfl

theorem celsius_ccc : celsius = fun (T : ℝ) =>
    (T - (273.15 : ℝ)) := rfl

theorem clearance_ccc : clearance = fun (l : TandoorHashemi.Leg) (holeDown : ℝ) (reach : ℝ) =>
    ((l.upright - holeDown) - reach) := rfl

theorem coilCapture_ccc : coilCapture = fun (rs : ℝ) (rc : ℝ) (d : ℝ) =>
    let v9 := (rs ^ 2)
    let v10 := (d ^ 2)
    let v12 := (rc ^ 2)
    let v15 := ((2 : ℝ) * d)
    let v30 := (d + rs)
    (if ((rs + rc) ≤ d) then (0 : ℝ) else (if (d ≤ (rc - rs)) then (1 : ℝ) else ((((v9 * (Real.arccos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Real.arccos (((v10 + v12) - v9) / (v15 * rc))))) - ((Real.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : ℝ))) / (Real.pi * v9)))) := rfl

theorem coilProfile_ccc : coilProfile = fun (α : ℝ) (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Ta : ℝ) (mcp : ℝ) (Tin : ℝ) (P : Fin 8 → ℝ) =>
    let v19 := (Ac / (8 : ℝ))
    let v20 := ((ε * (0.0000000567 : ℝ)) * v19)
    let v22 := (Ta ^ 4)
    let v25 := (hC * v19)
    let v31 := (Tin + (((α * (P 0)) - ((v20 * ((Tin ^ 4) - v22)) + (v25 * (Tin - Ta)))) / mcp))
    let v41 := (v31 + (((α * (P 1)) - ((v20 * ((v31 ^ 4) - v22)) + (v25 * (v31 - Ta)))) / mcp))
    let v51 := (v41 + (((α * (P 2)) - ((v20 * ((v41 ^ 4) - v22)) + (v25 * (v41 - Ta)))) / mcp))
    let v61 := (v51 + (((α * (P 3)) - ((v20 * ((v51 ^ 4) - v22)) + (v25 * (v51 - Ta)))) / mcp))
    let v71 := (v61 + (((α * (P 4)) - ((v20 * ((v61 ^ 4) - v22)) + (v25 * (v61 - Ta)))) / mcp))
    let v81 := (v71 + (((α * (P 5)) - ((v20 * ((v71 ^ 4) - v22)) + (v25 * (v71 - Ta)))) / mcp))
    let v91 := (v81 + (((α * (P 6)) - ((v20 * ((v81 ^ 4) - v22)) + (v25 * (v81 - Ta)))) / mcp))
    ![v31, v41, v51, v61, v71, v81, v91, (v91 + (((α * (P 7)) - ((v20 * ((v91 ^ 4) - v22)) + (v25 * (v91 - Ta)))) / mcp))] := rfl

theorem coilVolume_ccc : coilVolume =
    ((Real.pi * ((0.06 : ℝ) ^ 2)) * (0.04 : ℝ)) := rfl

theorem conicHitS_ccc : conicHitS = fun (c : ℝ) (k : ℝ) (O : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v9 := ((1 : ℝ) + k)
    let v27 := ((((2 : ℝ) * c) * ((((O 0) * (d 0)) + ((O 1) * (d 1))) + ((v9 * (O 2)) * (d 2)))) - ((2 : ℝ) * (d 2)))
    let v36 := ((c * ((((O 0) ^ 2) + ((O 1) ^ 2)) + (v9 * ((O 2) ^ 2)))) - ((2 : ℝ) * (O 2)))
    (((2 : ℝ) * v36) / ((-v27) - (Real.sqrt (max ((v27 ^ 2) - (((4 : ℝ) * (c * ((((d 0) ^ 2) + ((d 1) ^ 2)) + (v9 * ((d 2) ^ 2))))) * v36)) (0 : ℝ))))) := rfl

theorem conicSlope_ccc : conicSlope = fun (c : ℝ) (k : ℝ) (r : ℝ) =>
    ((c * r) / (Real.sqrt (max ((1 : ℝ) - ((((1 : ℝ) + k) * (c ^ 2)) * (r ^ 2))) (0.000000000000000001 : ℝ)))) := rfl

theorem conicZ_ccc : conicZ = fun (c : ℝ) (k : ℝ) (r : ℝ) =>
    let v3 := (r ^ 2)
    ((c * v3) / ((1 : ℝ) + (Real.sqrt (max ((1 : ℝ) - ((((1 : ℝ) + k) * (c ^ 2)) * v3)) (0 : ℝ))))) := rfl

theorem constraints_ccc : constraints = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v14 := ((0 : ℝ) * (0 : ℝ))
    let v15 := (b.zBearing * (0 : ℝ))
    let v17 := (b.zBearing * (1 : ℝ))
    let v19 := ((0 : ℝ) * (1 : ℝ))
    let v28 := (c.chord / (2 : ℝ))
    let v30 := (b.zRail * (0 : ℝ))
    let v34 := (c.apexH * (0 : ℝ))
    let v37 := (-v28)
    ![![(1 : ℝ), (0 : ℝ), (0 : ℝ), (v14 - v15), (v17 - v14), (v14 - v19)], ![(0 : ℝ), (1 : ℝ), (0 : ℝ), (v14 - v17), (v15 - v14), (v19 - v14)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), (v19 - v15), (v15 - v19), (v14 - v14)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), ((v28 * (1 : ℝ)) - v30), (v30 - (c.apexH * (1 : ℝ))), (v34 - (v28 * (0 : ℝ)))], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), ((v37 * (1 : ℝ)) - v30), (v30 - (c.apexH * (1 : ℝ))), (v34 - (v37 * (0 : ℝ)))]] := rfl

theorem constraintsGrooved_ccc : constraintsGrooved = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v14 := ((0 : ℝ) * (0 : ℝ))
    let v15 := (b.zBearing * (0 : ℝ))
    let v17 := (b.zBearing * (1 : ℝ))
    let v19 := ((0 : ℝ) * (1 : ℝ))
    let v28 := (c.chord / (2 : ℝ))
    let v30 := (b.zRail * (0 : ℝ))
    let v34 := (c.apexH * (0 : ℝ))
    let v35 := (v28 * (0 : ℝ))
    let v37 := (-v28)
    let v40 := (v37 * (0 : ℝ))
    ![![(1 : ℝ), (0 : ℝ), (0 : ℝ), (v14 - v15), (v17 - v14), (v14 - v19)], ![(0 : ℝ), (1 : ℝ), (0 : ℝ), (v14 - v17), (v15 - v14), (v19 - v14)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), (v19 - v15), (v15 - v19), (v14 - v14)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), ((v28 * (1 : ℝ)) - v30), (v30 - (c.apexH * (1 : ℝ))), (v34 - v35)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), ((v37 * (1 : ℝ)) - v30), (v30 - (c.apexH * (1 : ℝ))), (v34 - v40)], ![c.apexH, v28, (0 : ℝ), (v35 - (b.zRail * v28)), ((b.zRail * c.apexH) - v34), ((c.apexH * v28) - (v28 * c.apexH))], ![c.apexH, v37, (0 : ℝ), (v40 - (b.zRail * v37)), ((b.zRail * c.apexH) - v34), ((c.apexH * v37) - (v37 * c.apexH))]] := rfl

theorem cosTubeCut_ccc : cosTubeCut =
    let v2 := (Real.sqrt (3.2 : ℝ))
    (((3.36 : ℝ) - v2) / ((2 : ℝ) * (Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * v2))))) := rfl

theorem cross3_ccc : cross3 = fun (u : Fin 3 → ℝ) (v : Fin 3 → ℝ) =>
    ![(((u 1) * (v 2)) - ((u 2) * (v 1))), (((u 2) * (v 0)) - ((u 0) * (v 2))), (((u 0) * (v 1)) - ((u 1) * (v 0)))] := rfl

theorem dPipe_ccc : dPipe = fun (Q : ℝ) (D : ℝ) (L : ℝ) (T : ℝ) =>
    let v5 := (D ^ 2)
    let v9 := (Q / ((Real.pi * v5) / (4 : ℝ)))
    let v11 := (T - (273.15 : ℝ))
    let v19 := (((1020.62 : ℝ) - ((0.614254 : ℝ) * v11)) - ((0.000321 : ℝ) * (v11 ^ 2)))
    let v30 := ((Real.exp (((586.375 : ℝ) / (v11 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ))
    let v31 := (((v19 * v9) * D) / v30)
    (if (v31 < (2300 : ℝ)) then (((((32 : ℝ) * v30) * L) * v9) / v5) else ((((((0.3164 : ℝ) / (Real.sqrt (Real.sqrt (max v31 (1 : ℝ))))) * (L / D)) * v19) * (v9 ^ 2)) / (2 : ℝ))) := rfl

theorem darcyF_ccc : darcyF = fun (Re : ℝ) =>
    (if (Re < (2300 : ℝ)) then ((64 : ℝ) / (max Re (0.000000001 : ℝ))) else ((0.3164 : ℝ) / (Real.sqrt (Real.sqrt (max Re (1 : ℝ)))))) := rfl

theorem deadPoint_ccc : deadPoint = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) =>
    let v4 := (ym * a)
    let v5 := (hp * ze)
    (if (v4 ≤ v5) then (Real.pi / (2 : ℝ)) else (Real.arctan (((ym * ze) + (hp * a)) / (v4 - v5)))) := rfl

theorem degCostRaw_ccc : degCostRaw = fun (dt : ℝ) (filmExcess : ℝ) (degPrice : ℝ) (rotiReward : ℝ) =>
    (((degPrice * rotiReward) * dt) * (max (0 : ℝ) filmExcess)) := rfl

theorem degradRate_ccc : degradRate = fun (degA : ℝ) (degEa : ℝ) (Tfilm : ℝ) =>
    (degA * (Real.exp ((-degEa) / ((8.314 : ℝ) * (max Tfilm (1 : ℝ)))))) := rfl

theorem degradStep_ccc : degradStep = fun (deg : ℝ) (dt : ℝ) (degA : ℝ) (degEa : ℝ) (Tfilm : ℝ) =>
    (deg + (dt * (degA * (Real.exp ((-degEa) / ((8.314 : ℝ) * (max Tfilm (1 : ℝ)))))))) := rfl

theorem degraded_ccc : degraded = fun (x : ℝ) (deg : ℝ) (knock : ℝ) =>
    (x * ((1 : ℝ) - (knock * (min (max deg (0 : ℝ)) (1 : ℝ))))) := rfl

theorem delayOf_ccc : delayOf = fun (L : ℝ) (Q : ℝ) (D : ℝ) (dt : ℝ) =>
    ((L / (max (Q / ((Real.pi * (D ^ 2)) / (4 : ℝ))) (0.000001 : ℝ))) / dt) := rfl

theorem delaySteps_ccc : delaySteps =
    (2 : ℝ) := rfl

theorem delivered_ccc : delivered = fun (Upipe : ℝ) (mcp : ℝ) (Ta : ℝ) (Tin : ℝ) =>
    (Ta + ((Tin - Ta) * (Real.exp ((-Upipe) / mcp)))) := rfl

theorem dishAxes_ccc : dishAxes = fun (az : ℝ) (t : ℝ) =>
    let v2 := (Real.sin t)
    let v3 := (Real.cos az)
    let v4 := (v2 * v3)
    let v5 := (Real.sin az)
    let v6 := (v2 * v5)
    let v7 := (Real.cos t)
    let v8 := (v7 * v3)
    let v9 := (v7 * v5)
    let v10 := (-v2)
    (![((v9 * v7) - (v10 * v6)), ((v10 * v4) - (v8 * v7)), ((v8 * v6) - (v9 * v4))], (![v8, v9, v10], ![v4, v6, v7])) := rfl

theorem dishF_ccc : dishF =
    (1 : ℝ) := rfl

theorem dishHalf_ccc : dishHalf =
    (0.8 : ℝ) := rfl

theorem dishPower_ccc : dishPower = fun (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (k : ℝ) (σslope : ℝ) (σspec : ℝ) (ρ : ℝ) (hsun : ℝ) (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) (u1 : ℝ) (u2 : ℝ) (u3 : ℝ) (u4 : ℝ) (u5 : ℝ) (u6 : ℝ) (e1 : ℝ) (e2 : ℝ) (s1 : ℝ) (s2 : ℝ) =>
    let v24 := (Real.sin t)
    let v25 := (Real.cos az)
    let v26 := (v24 * v25)
    let v27 := (Real.sin az)
    let v28 := (v24 * v27)
    let v29 := (Real.cos t)
    let v30 := (v29 * v25)
    let v31 := (v29 * v27)
    let v32 := (-v24)
    let v42 := (Real.cos elSun)
    let v44 := (v42 * (Real.cos azSun))
    let v46 := (v42 * (Real.sin azSun))
    let v47 := (Real.sin elSun)
    let v64 := ((2 : ℝ) * a)
    let v65 := (v64 / w)
    let v67 := (w / (2 : ℝ))
    let v68 := ((-a) + v67)
    let v72 := (v68 + (w * ((⌊(u1 * v65)⌋ : ℤ) : ℝ)))
    let v76 := (v68 + (w * ((⌊(u2 * v65)⌋ : ℤ) : ℝ)))
    let v78 := ((1 : ℝ) / (2 : ℝ))
    let v80 := ((u3 - v78) * w)
    let v82 := ((u4 - v78) * w)
    let v83 := (-(((((v31 * v29) - (v32 * v28)) * v44) + (((v32 * v26) - (v30 * v29)) * v46)) + (((v30 * v28) - (v31 * v26)) * v47)))
    let v84 := (-(((v30 * v44) + (v31 * v46)) + (v32 * v47)))
    let v85 := (-(((v26 * v44) + (v28 * v46)) + (v29 * v47)))
    let v90 := (|v85| < ((9 : ℝ) / (10 : ℝ)))
    let v92 := (if v90 then (0 : ℝ) else (1 : ℝ))
    let v93 := (if v90 then (1 : ℝ) else (0 : ℝ))
    let v96 := ((v84 * v93) - (v85 * (0 : ℝ)))
    let v99 := ((v85 * v92) - (v83 * v93))
    let v102 := ((v83 * (0 : ℝ)) - (v84 * v92))
    let v110 := (Real.sqrt (max (((v96 ^ 2) + (v99 ^ 2)) + (v102 ^ 2)) (0.000000000000000001 : ℝ)))
    let v111 := (v96 / v110)
    let v112 := (v99 / v110)
    let v113 := (v102 / v110)
    let v124 := (hsun * (Real.sqrt u5))
    let v127 := (((2 : ℝ) * Real.pi) * u6)
    let v128 := (Real.cos v124)
    let v130 := (Real.sin v124)
    let v131 := (Real.cos v127)
    let v133 := (Real.sin v127)
    let v137 := ((v128 * v83) + (v130 * ((v131 * v111) + (v133 * ((v84 * v113) - (v85 * v112))))))
    let v143 := ((v128 * v84) + (v130 * ((v131 * v112) + (v133 * ((v85 * v111) - (v83 * v113))))))
    let v149 := ((v128 * v85) + (v130 * ((v131 * v113) + (v133 * ((v83 * v112) - (v84 * v111))))))
    let v160 := ((|v72| ≤ a) ∧ ((|v76| ≤ a) ∧ ((|v80| ≤ v67) ∧ (|v82| ≤ v67))))
    let v161 := (v72 + v80)
    let v162 := (v76 + v82)
    let v163 := ((2 : ℝ) * f)
    let v164 := ((1 : ℝ) / R)
    let v169 := (Real.sqrt (max ((v72 ^ 2) + (v76 ^ 2)) (0.000000000000000001 : ℝ)))
    let v170 := (v169 ^ 2)
    let v176 := ((1 : ℝ) - ((((1 : ℝ) + k) * (v164 ^ 2)) * v170))
    let v184 := ((v164 * v169) / (Real.sqrt (max v176 (0.000000000000000001 : ℝ))))
    let v187 := (Real.sqrt ((1 : ℝ) + (v184 ^ 2)))
    let v188 := (-v184)
    let v191 := (((v188 * v72) / v169) / v187)
    let v194 := (((v188 * v76) / v169) / v187)
    let v195 := ((1 : ℝ) / v187)
    let v197 := (v191 + (σslope * e1))
    let v199 := (v194 + (σslope * e2))
    let v205 := (Real.sqrt (((v197 ^ 2) + (v199 ^ 2)) + (v195 ^ 2)))
    let v206 := (v197 / v205)
    let v207 := (v199 / v205)
    let v208 := (v195 / v205)
    let v222 := (((((v72 - v161) * v191) + ((v76 - v162) * v194)) + ((((v164 * v170) / ((1 : ℝ) + (Real.sqrt (max v176 (0 : ℝ))))) - v163) * v195)) / (((v137 * v191) + (v143 * v194)) + (v149 * v195)))
    let v234 := ((2 : ℝ) * (((v137 * v206) + (v143 * v207)) + (v149 * v208)))
    let v240 := (v149 - (v234 * v208))
    let v242 := ((v137 - (v234 * v206)) + (σspec * s1))
    let v244 := ((v143 - (v234 * v207)) + (σspec * s2))
    let v250 := (Real.sqrt (((v242 ^ 2) + (v244 ^ 2)) + (v240 ^ 2)))
    let v253 := (v240 / v250)
    let v255 := ((f - (v163 + (v222 * v149))) / v253)
    let v263 := (Real.sqrt ((((v161 + (v222 * v137)) + (v255 * (v242 / v250))) ^ 2) + (((v162 + (v222 * v143)) + (v255 * (v244 / v250))) ^ 2)))
    let v265 := ((0 : ℝ) < v253)
    let v266 := ((v263 ≤ rc) ∧ v265)
    ![(if (v160 ∧ v266) then (1 : ℝ) else (0 : ℝ)), (((v64 ^ 2) * ρ) * (if (v160 ∧ v266) then (1 : ℝ) else (0 : ℝ))), (if (¬ v160) then (0 : ℝ) else (if v266 then (2 : ℝ) else (1 : ℝ))), v263, (Real.sigmoid ((rc - v263) / (0.005 : ℝ)))]:= by
  funext R f a w rc k σslope σspec ρ hsun az t elSun azSun u1 u2 u3 u4 u5 u6 e1 e2 s1 s2
  lift_lets
  intro v24 v25 v26 v27 v28 v29 v30 v31 v32 v42 v44 v46 v47 v64 v65 v67 v68 v72 v76 v78 v80 v82 v83 v84 v85 v90 v92 v93 v96 v99 v102 v110 v111 v112 v113 v124 v127 v128 v130 v131 v133 v137 v143 v149 v160 v161 v162 v163 v164 v169 v170 v176 v184 v187 v188 v191 v194 v195 v197 v199 v205 v206 v207 v208 v222 v234 v240 v242 v244 v250 v253 v255 v263 v265 v266
  rfl

theorem dishR_ccc : dishR =
    (2 : ℝ) := rfl

theorem dishReflect_ccc : dishReflect = fun (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (k : ℝ) (σslope : ℝ) (σspec : ℝ) (cx : ℝ) (cy : ℝ) (ux : ℝ) (uy : ℝ) (dx : ℝ) (dy : ℝ) (dz : ℝ) (e1 : ℝ) (e2 : ℝ) (s1 : ℝ) (s2 : ℝ) =>
    let v24 := (w / (2 : ℝ))
    let v31 := (cx + ux)
    let v32 := (cy + uy)
    let v33 := ((2 : ℝ) * f)
    let v35 := ((1 : ℝ) / R)
    let v41 := (Real.sqrt (max ((cx ^ 2) + (cy ^ 2)) (0.000000000000000001 : ℝ)))
    let v42 := (v41 ^ 2)
    let v48 := ((1 : ℝ) - ((((1 : ℝ) + k) * (v35 ^ 2)) * v42))
    let v57 := ((v35 * v41) / (Real.sqrt (max v48 (0.000000000000000001 : ℝ))))
    let v60 := (Real.sqrt ((1 : ℝ) + (v57 ^ 2)))
    let v61 := (-v57)
    let v64 := (((v61 * cx) / v41) / v60)
    let v67 := (((v61 * cy) / v41) / v60)
    let v68 := ((1 : ℝ) / v60)
    let v70 := (v64 + (σslope * e1))
    let v72 := (v67 + (σslope * e2))
    let v78 := (Real.sqrt (((v70 ^ 2) + (v72 ^ 2)) + (v68 ^ 2)))
    let v79 := (v70 / v78)
    let v80 := (v72 / v78)
    let v81 := (v68 / v78)
    let v95 := (((((cx - v31) * v64) + ((cy - v32) * v67)) + ((((v35 * v42) / ((1 : ℝ) + (Real.sqrt (max v48 (0 : ℝ))))) - v33) * v68)) / (((dx * v64) + (dy * v67)) + (dz * v68)))
    let v107 := ((2 : ℝ) * (((dx * v79) + (dy * v80)) + (dz * v81)))
    let v113 := (dz - (v107 * v81))
    let v115 := ((dx - (v107 * v79)) + (σspec * s1))
    let v117 := ((dy - (v107 * v80)) + (σspec * s2))
    let v123 := (Real.sqrt (((v115 ^ 2) + (v117 ^ 2)) + (v113 ^ 2)))
    ![(v31 + (v95 * dx)), (v32 + (v95 * dy)), (v33 + (v95 * dz)), (v115 / v123), (v117 / v123), (v113 / v123), (if ((|cx| ≤ a) ∧ ((|cy| ≤ a) ∧ ((|ux| ≤ v24) ∧ (|uy| ≤ v24)))) then (1 : ℝ) else (0 : ℝ))] := rfl

theorem dishSide_ccc : dishSide =
    ((2 : ℝ) * (0.8 : ℝ)) := rfl

theorem dot3_ccc : dot3 = fun (u : Fin 3 → ℝ) (v : Fin 3 → ℝ) =>
    ((((u 0) * (v 0)) + ((u 1) * (v 1))) + ((u 2) * (v 2))) := rfl

theorem dpLam_ccc : dpLam = fun (μ : ℝ) (L : ℝ) (v : ℝ) (D : ℝ) =>
    (((((32 : ℝ) * μ) * L) * v) / (D ^ 2)) := rfl

theorem dpTurb_ccc : dpTurb = fun (fD : ℝ) (L : ℝ) (D : ℝ) (ρ : ℝ) (v : ℝ) =>
    ((((fD * (L / D)) * ρ) * (v ^ 2)) / (2 : ℝ)) := rfl

theorem driveAz_ccc : driveAz = fun (u : ℝ) (rw : ℝ) (R : ℝ) =>
    (((u * (((0.035 : ℝ) * Real.pi) / (180 : ℝ))) * R) / rw) := rfl

theorem driveEl_ccc : driveEl = fun (u : ℝ) (arm : ℝ) (rDrum : ℝ) =>
    (((u * (((0.025 : ℝ) * Real.pi) / (180 : ℝ))) * arm) / rDrum) := rfl

theorem edgeClipAt_ccc : edgeClipAt = fun (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v3 := (-a)
    let v4 := (Real.cos t)
    let v6 := (-ze)
    let v7 := (Real.sin t)
    (((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))) := rfl

theorem edgeDepth_ccc : edgeDepth = fun (f : ℝ) (a : ℝ) (sag : ℝ) (el : ℝ) =>
    (((f - sag) * (Real.sin el)) + (a * (Real.cos el))) := rfl

theorem effCounter_ccc : effCounter = fun (NTU : ℝ) (Cr : ℝ) =>
    let v10 := (Real.exp ((-NTU) * ((1 : ℝ) - Cr)))
    (if ((0.999 : ℝ) < Cr) then (NTU / ((1 : ℝ) + NTU)) else (((1 : ℝ) - v10) / ((1 : ℝ) - (Cr * v10)))) := rfl

theorem effNtu_ccc : effNtu = fun (NTU : ℝ) =>
    ((1 : ℝ) - (Real.exp (-NTU))) := rfl

theorem elFull_ccc : elFull =
    (((0.025 : ℝ) * Real.pi) / (180 : ℝ)) := rfl

theorem elPower_ccc : elPower = fun (W : ℝ) (rcm : ℝ) (t : ℝ) (ω : ℝ) =>
    (((W * rcm) * (Real.sin t)) * ω) := rfl

theorem elRate_ccc : elRate = fun (ωd : ℝ) (rDrum : ℝ) (rw : ℝ) =>
    ((ωd * rDrum) / rw) := rfl

theorem expansionFrac_ccc : expansionFrac = fun (Tfill : ℝ) (T : ℝ) =>
    let v3 := (Tfill - (273.15 : ℝ))
    let v12 := (T - (273.15 : ℝ))
    (((((1020.62 : ℝ) - ((0.614254 : ℝ) * v3)) - ((0.000321 : ℝ) * (v3 ^ 2))) / (((1020.62 : ℝ) - ((0.614254 : ℝ) * v12)) - ((0.000321 : ℝ) * (v12 ^ 2)))) - (1 : ℝ)) := rfl

theorem facetSpot_ccc : facetSpot = fun (w : ℝ) (f : ℝ) =>
    (w + (f * (0.0093 : ℝ))) := rfl

theorem filmTemp_ccc : filmTemp = fun (Tbulk : ℝ) (qFlux : ℝ) (h : ℝ) =>
    (Tbulk + (qFlux / h)) := rfl

theorem focusShift_ccc : focusShift = fun (h : ℝ) (ε : ℝ) =>
    (h * (Real.sin ε)) := rfl

theorem follower_ccc : follower = fun (eAz : ℝ) (eEl : ℝ) (dt : ℝ) =>
    let v8 := ((((0.035 : ℝ) * Real.pi) / (180 : ℝ)) * dt)
    let v16 := ((((0.025 : ℝ) * Real.pi) / (180 : ℝ)) * dt)
    ![((max (-v8) (min eAz v8)) / v8), ((max (-v16) (min eEl v16)) / v16)] := rfl

theorem frictionBlasius_ccc : frictionBlasius = fun (Re : ℝ) =>
    ((0.3164 : ℝ) / (Real.sqrt (Real.sqrt (max Re (1 : ℝ))))) := rfl

theorem frictionLam_ccc : frictionLam = fun (Re : ℝ) =>
    ((64 : ℝ) / (max Re (0.000000001 : ℝ))) := rfl

theorem gateTau_ccc : gateTau =
    (0.01 : ℝ) := rfl

theorem hCoil_ccc : hCoil = fun (Q : ℝ) (D : ℝ) (T : ℝ) =>
    let v4 := (T - (273.15 : ℝ))
    let v10 := (v4 ^ 2)
    let v29 := ((Real.exp (((586.375 : ℝ) / (v4 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ))
    let v30 := ((((((1020.62 : ℝ) - ((0.614254 : ℝ) * v4)) - ((0.000321 : ℝ) * v10)) * (Q / ((Real.pi * (D ^ 2)) / (4 : ℝ)))) * D) / v29)
    let v58 := (((0.118294 : ℝ) - ((0.000033 : ℝ) * v4)) - ((0.00000015 : ℝ) * v10))
    (((if (v30 < (2300 : ℝ)) then (4.364 : ℝ) else (((0.023 : ℝ) * (Real.exp ((0.8 : ℝ) * (Real.log (max v30 (1 : ℝ)))))) * (Real.exp ((0.4 : ℝ) * (Real.log (max ((v29 * ((1000 : ℝ) * (((1.496005 : ℝ) + ((0.003313 : ℝ) * v4)) + ((0.0000008970757 : ℝ) * v10)))) / v58) (0.01 : ℝ))))))) * v58) / D) := rfl

theorem hM12_ccc : hM12 =
    ((0.00175 : ℝ) / ((2 : ℝ) * Real.pi)) := rfl

theorem hWind_ccc : hWind = fun (V : ℝ) =>
    ((5.7 : ℝ) + ((3.8 : ℝ) * V)) := rfl

theorem hangerLength_ccc : hangerLength = fun (R : ℝ) (a : ℝ) (yr : ℝ) (dx : ℝ) =>
    let v5 := (yr ^ 2)
    (Real.sqrt (((dx ^ 2) + v5) + (((R / (2 : ℝ)) - (R - (Real.sqrt ((R ^ 2) - ((Real.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2))) := rfl

section
attribute [local irreducible] megaStep dishPower oilBulkMax oilRho oilCp uPipeCyl hWind delayOf lerp8 delivered hCoil uaOf ntuOf effNtu coilProfile shift wallTemp oilFilmMax degradStep pumpElec expansionFrac

theorem hashemiEnv_ccc : hashemiEnv = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (k : ℝ) (σslope : ℝ) (σspec : ℝ) (hsun : ℝ) (soil : ℝ) (α : ℝ) (ε : ℝ) (Ac : ℝ) (Twall : ℝ) (Ta : ℝ) (uPump : ℝ) (Qmax : ℝ) (Dp : ℝ) (Lp : ℝ) (Dins : ℝ) (kIns : ℝ) (Vw : ℝ) (etaP : ℝ) (Pidle : ℝ) (Axch : ℝ) (UAxMax : ℝ) (Ccoil : ℝ) (degPrev : ℝ) (degA : ℝ) (degEa : ℝ) (hist : Fin 16 → ℝ) (ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) =>
    let v719 := (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen)
    let v751 := (∑ i : Fin 64, ((dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0)))
    let v754 := (∑ i : Fin 64, ((dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 4)))
    let v758 := (((2 : ℝ) * a) ^ 2)
    let v779 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((0 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((0 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v784 := (((((v779 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v796 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((1 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((1 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v801 := (((((v796 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v813 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((2 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((2 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v818 := (((((v813 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v830 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((3 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((3 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v835 := (((((v830 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v847 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((4 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((4 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v852 := (((((v847 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v864 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((5 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((5 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v869 := (((((v864 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v881 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((6 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((6 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v886 := (((((v881 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v898 := (∑ i : Fin 64, (let v746 := (dishPower R f a w rc k σslope σspec rho hsun (v719 0) (v719 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (@ite _ ((((((((7 : ℕ)) : ℝ) * rc) / (8 : ℝ)) ≤ (v746 3)) ∧ ((v746 3) < ((((((7 : ℕ)) : ℝ) + (1 : ℝ)) * rc) / (8 : ℝ)))) ∧ ((v746 0) > (0.5 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))))
    let v903 := (((((v898 / (64 : ℝ)) * v758) * rho) * dni) * soil)
    let v906 := (Qmax * (min (max uPump (0 : ℝ)) (1 : ℝ)))
    let v909 := (min (oilBulkMax) (max Ta (hist 0)))
    let v913 := (((oilRho v909) * v906) * (oilCp v909))
    let v915 := (max v913 (0.000001 : ℝ))
    let v916 := (Ccoil / dt)
    let v917 := (v913 + v916)
    let v923 := ((uPipeCyl Lp Dp Dins kIns Vw) / (2 : ℝ))
    let v933 := ((v913 * (effNtu (ntuOf (min UAxMax (uaOf (hCoil v906 Dp v909) Axch)) v915))) * (max (0 : ℝ) ((delivered v923 v915 Ta (lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) (delayOf Lp v906 Dp dt))) - Twall)))
    let v935 := ((delivered v923 v915 Ta (lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) (delayOf Lp v906 Dp dt))) - (v933 / v915))
    let v940 := (((v913 * (delivered v923 v915 Ta (lerp8 (ret 0) (ret 1) (ret 2) (ret 3) (ret 4) (ret 5) (ret 6) (ret 7) (delayOf Lp v906 Dp dt)))) + (v916 * v909)) / v917)
    let v941 := (coilProfile α ε Ac (hWind Vw) Ta v917 v940 ![v784, v801, v818, v835, v852, v869, v886, v903])
    let v950 := (min (oilBulkMax) (max Ta (v941 7)))
    let v958 := (α * (((((((v784 + v801) + v818) + v835) + v852) + v869) + v886) + v903))
    let v969 := (shift v950 hist)
    let v985 := (shift v935 ret)
    let v1009 := (azSun - (v719 0))
    let v1011 := ((2 : ℝ) * Real.pi)
    ![(v719 0), (v719 1), (v719 2), (v719 3), (v719 4), (v719 5), (v719 6), (v719 7), (v719 8), (v719 9), (v719 10), (v719 11), (v719 12), (v719 13), (v719 14), (v719 15), (v719 16), (v751 / (64 : ℝ)), (v754 / (64 : ℝ)), ((v758 * rho) * (v751 / (64 : ℝ))), ((((v758 * rho) * (v751 / (64 : ℝ))) * dni) * soil), v950, v958, (v958 - (v917 * (v950 - v940))), (v913 * (((lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) (delayOf Lp v906 Dp dt)) - (delivered v923 v915 Ta (lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) (delayOf Lp v906 Dp dt)))) + ((lerp8 (ret 0) (ret 1) (ret 2) (ret 3) (ret 4) (ret 5) (ret 6) (ret 7) (delayOf Lp v906 Dp dt)) - v935))), v933, (((v958 - (v958 - (v917 * (v950 - v940)))) - (v913 * (((lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) (delayOf Lp v906 Dp dt)) - (delivered v923 v915 Ta (lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) (delayOf Lp v906 Dp dt)))) + ((lerp8 (ret 0) (ret 1) (ret 2) (ret 3) (ret 4) (ret 5) (ret 6) (ret 7) (delayOf Lp v906 Dp dt)) - v935)))) - v933), (v1009 - (v1011 * ((⌊((v1009 + Real.pi) / v1011)⌋ : ℤ) : ℝ))), (((Real.pi / (2 : ℝ)) - (v719 1)) - elSun), (v719 1), (v719 6), (v719 7), ((v950 - (300 : ℝ)) / (300 : ℝ)), (v719 15), (v719 16), v784, v801, v818, v835, v852, v869, v886, v903, (v941 0), (v941 1), (v941 2), (v941 3), (v941 4), (v941 5), (v941 6), (v941 7), (v969 0), (v969 1), (v969 2), (v969 3), (v969 4), (v969 5), (v969 6), (v969 7), (v969 8), (v969 9), (v969 10), (v969 11), (v969 12), (v969 13), (v969 14), (v969 15), (v985 0), (v985 1), (v985 2), (v985 3), (v985 4), (v985 5), (v985 6), (v985 7), (v985 8), (v985 9), (v985 10), (v985 11), (v985 12), (v985 13), (v985 14), (v985 15), (wallTemp v950 (v958 / Ac) (hCoil v906 Dp v909) ε Ta), ((oilFilmMax) - (wallTemp v950 (v958 / Ac) (hCoil v906 Dp v909) ε Ta)), v906, (degradStep degPrev dt degA degEa (wallTemp v950 (v958 / Ac) (hCoil v906 Dp v909) ε Ta)), (pumpElec v906 Dp Lp v909 etaP Pidle), v913, (min UAxMax (uaOf (hCoil v906 Dp v909) Axch)), (delayOf Lp v906 Dp dt), (@ite _ ((oilBulkMax) ≤ (v941 7)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (expansionFrac (293.15 : ℝ) v950), (((oilFilmMax) - (wallTemp v950 (v958 / Ac) (hCoil v906 Dp v909) ε Ta)) / (300 : ℝ)), (min (max uPump (0 : ℝ)) (1 : ℝ)), (min (max (degradStep degPrev dt degA degEa (wallTemp v950 (v958 / Ac) (hCoil v906 Dp v909) ε Ta)) (0 : ℝ)) (1 : ℝ))] := by
  funext az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr
  rfl
end

section
attribute [local irreducible] megaStep sunInDish dishReflect traceBeam tunnelThroughput

theorem hashemiEnvBeam_ccc : hashemiEnvBeam = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (k : ℝ) (σslope : ℝ) (σspec : ℝ) (hsun : ℝ) (soil : ℝ) (L : ℝ) (dm : ℝ) (rm : ℝ) (rt : ℝ) (slotW : ℝ) (β : ℝ) (dr : Fin 64 → Fin 10 → ℝ) =>
    let v673 := (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen)
    let v690 := (sunInDish (v673 0) (v673 1) elSun azSun)
    let v704 := ((2 : ℝ) * a)
    let v705 := (v704 / w)
    let v708 := ((-a) + (w / (2 : ℝ)))
    let v718 := ((1 : ℝ) / (2 : ℝ))
    let v723 := (-(v690 0))
    let v724 := (-(v690 1))
    let v725 := (-(v690 2))
    let v730 := (|v725| < ((9 : ℝ) / (10 : ℝ)))
    let v732 := (if v730 then (0 : ℝ) else (1 : ℝ))
    let v733 := (if v730 then (1 : ℝ) else (0 : ℝ))
    let v736 := ((v724 * v733) - (v725 * (0 : ℝ)))
    let v739 := ((v725 * v732) - (v723 * v733))
    let v742 := ((v723 * (0 : ℝ)) - (v724 * v732))
    let v750 := (Real.sqrt (max (((v736 ^ 2) + (v739 ^ 2)) + (v742 ^ 2)) (0.000000000000000001 : ℝ)))
    let v751 := (v736 / v750)
    let v752 := (v739 / v750)
    let v753 := (v742 / v750)
    let v766 := ((2 : ℝ) * Real.pi)
    let v805 := (∑ i : Fin 64, (let v712 := (v708 + (w * ((⌊((dr i 0) * v705)⌋ : ℤ) : ℝ))); let v716 := (v708 + (w * ((⌊((dr i 1) * v705)⌋ : ℤ) : ℝ))); let v720 := (((dr i 2) - v718) * w); let v722 := (((dr i 3) - v718) * w); let v764 := (hsun * (Real.sqrt (dr i 4))); let v767 := (v766 * (dr i 5)); let v768 := (Real.cos v764); let v770 := (Real.sin v764); let v771 := (Real.cos v767); let v773 := (Real.sin v767); let v777 := ((v768 * v723) + (v770 * ((v771 * v751) + (v773 * ((v724 * v753) - (v725 * v752)))))); let v783 := ((v768 * v724) + (v770 * ((v771 * v752) + (v773 * ((v725 * v751) - (v723 * v753)))))); let v789 := ((v768 * v725) + (v770 * ((v771 * v753) + (v773 * ((v723 * v752) - (v724 * v751)))))); let v790 := (dishReflect R f a w k σslope σspec v712 v716 v720 v722 v777 v783 v789 (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (traceBeam R f a k L dm rm rt slotW (v673 1) β ![(v790 0), (v790 1), (v790 2)] ![(v790 3), (v790 4), (v790 5)] (v790 6) 0)))
    let v808 := (∑ i : Fin 64, (let v712 := (v708 + (w * ((⌊((dr i 0) * v705)⌋ : ℤ) : ℝ))); let v716 := (v708 + (w * ((⌊((dr i 1) * v705)⌋ : ℤ) : ℝ))); let v720 := (((dr i 2) - v718) * w); let v722 := (((dr i 3) - v718) * w); let v764 := (hsun * (Real.sqrt (dr i 4))); let v767 := (v766 * (dr i 5)); let v768 := (Real.cos v764); let v770 := (Real.sin v764); let v771 := (Real.cos v767); let v773 := (Real.sin v767); let v777 := ((v768 * v723) + (v770 * ((v771 * v751) + (v773 * ((v724 * v753) - (v725 * v752)))))); let v783 := ((v768 * v724) + (v770 * ((v771 * v752) + (v773 * ((v725 * v751) - (v723 * v753)))))); let v789 := ((v768 * v725) + (v770 * ((v771 * v753) + (v773 * ((v723 * v752) - (v724 * v751)))))); let v790 := (dishReflect R f a w k σslope σspec v712 v716 v720 v722 v777 v783 v789 (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (traceBeam R f a k L dm rm rt slotW (v673 1) β ![(v790 0), (v790 1), (v790 2)] ![(v790 3), (v790 4), (v790 5)] (v790 6) 1)))
    let v810 := (∑ i : Fin 64, (let v712 := (v708 + (w * ((⌊((dr i 0) * v705)⌋ : ℤ) : ℝ))); let v716 := (v708 + (w * ((⌊((dr i 1) * v705)⌋ : ℤ) : ℝ))); let v720 := (((dr i 2) - v718) * w); let v722 := (((dr i 3) - v718) * w); let v764 := (hsun * (Real.sqrt (dr i 4))); let v767 := (v766 * (dr i 5)); let v768 := (Real.cos v764); let v770 := (Real.sin v764); let v771 := (Real.cos v767); let v773 := (Real.sin v767); let v777 := ((v768 * v723) + (v770 * ((v771 * v751) + (v773 * ((v724 * v753) - (v725 * v752)))))); let v783 := ((v768 * v724) + (v770 * ((v771 * v752) + (v773 * ((v725 * v751) - (v723 * v753)))))); let v789 := ((v768 * v725) + (v770 * ((v771 * v753) + (v773 * ((v723 * v752) - (v724 * v751)))))); let v790 := (dishReflect R f a w k σslope σspec v712 v716 v720 v722 v777 v783 v789 (dr i 6) (dr i 7) (dr i 8) (dr i 9)); (traceBeam R f a k L dm rm rt slotW (v673 1) β ![(v790 0), (v790 1), (v790 2)] ![(v790 3), (v790 4), (v790 5)] (v790 6) 2)))
    let v814 := (∑ i : Fin 64, (let v712 := (v708 + (w * ((⌊((dr i 0) * v705)⌋ : ℤ) : ℝ))); let v716 := (v708 + (w * ((⌊((dr i 1) * v705)⌋ : ℤ) : ℝ))); let v720 := (((dr i 2) - v718) * w); let v722 := (((dr i 3) - v718) * w); let v764 := (hsun * (Real.sqrt (dr i 4))); let v767 := (v766 * (dr i 5)); let v768 := (Real.cos v764); let v770 := (Real.sin v764); let v771 := (Real.cos v767); let v773 := (Real.sin v767); let v777 := ((v768 * v723) + (v770 * ((v771 * v751) + (v773 * ((v724 * v753) - (v725 * v752)))))); let v783 := ((v768 * v724) + (v770 * ((v771 * v752) + (v773 * ((v725 * v751) - (v723 * v753)))))); let v789 := ((v768 * v725) + (v770 * ((v771 * v753) + (v773 * ((v723 * v752) - (v724 * v751)))))); let v790 := (dishReflect R f a w k σslope σspec v712 v716 v720 v722 v777 v783 v789 (dr i 6) (dr i 7) (dr i 8) (dr i 9)); let v799 := (traceBeam R f a k L dm rm rt slotW (v673 1) β ![(v790 0), (v790 1), (v790 2)] ![(v790 3), (v790 4), (v790 5)] (v790 6)); ((v799 2) * (min (v799 3) (2 : ℝ)))))
    let v823 := (azSun - (v673 0))
    ![(v673 0), (v673 1), (v673 2), (v673 3), (v673 4), (v673 5), (v673 6), (v673 7), (v673 8), (v673 9), (v673 10), (v673 11), (v673 12), (v673 13), (v673 14), (v673 15), (v673 16), (v805 / (64 : ℝ)), (v808 / (64 : ℝ)), (v810 / (64 : ℝ)), ((((v704 ^ 2) * rho) * (v805 / (64 : ℝ))) * (tunnelThroughput)), ((((((v704 ^ 2) * rho) * (v805 / (64 : ℝ))) * (tunnelThroughput)) * dni) * soil), (v814 / (64 : ℝ)), (v823 - (v766 * ((⌊((v823 + Real.pi) / v766)⌋ : ℤ) : ℝ))), (((Real.pi / (2 : ℝ)) - (v673 1)) - elSun), (v673 1), (v673 6), (v673 7), (0 : ℝ), (v673 15), (v673 16)] := by
  funext az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R f a w rc k σslope σspec hsun soil L dm rm rt slotW β dr
  rfl
end

section
attribute [local irreducible] obsOf ymHashemi hpHashemi dishHalf zeHashemi leverAt driveAz driveEl pumpCmd hashemiEnv

theorem hashemiLoop_ccc : hashemiLoop = fun (az : ℝ) (t : ℝ) (slack : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (k : ℝ) (σslope : ℝ) (σspec : ℝ) (hsun : ℝ) (soil : ℝ) (α : ℝ) (ε : ℝ) (Ac : ℝ) (Twall : ℝ) (Ta : ℝ) (Qmax : ℝ) (Dp : ℝ) (Lp : ℝ) (Dins : ℝ) (kIns : ℝ) (Vw : ℝ) (etaP : ℝ) (Pidle : ℝ) (Axch : ℝ) (UAxMax : ℝ) (Ccoil : ℝ) (degPrev : ℝ) (degA : ℝ) (degEa : ℝ) (tautPrev : ℝ) (holdsPrev : ℝ) (tDead : ℝ) (marginPrev : ℝ) (flowPrev : ℝ) (W1 : Fin 16 → Fin 11 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 3 → Fin 16 → ℝ) (b2 : Fin 3 → ℝ) (hist : Fin 16 → ℝ) (ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) =>
    let v964 := (obsOf az t elSun azSun tautPrev holdsPrev (hist 0) tDead marginPrev flowPrev degPrev)
    let v999 := (Real.tanh ((((W1 0 0) * (v964 0)) + (((W1 0 1) * (v964 1)) + (((W1 0 2) * (v964 2)) + (((W1 0 3) * (v964 3)) + (((W1 0 4) * (v964 4)) + (((W1 0 5) * (v964 5)) + (((W1 0 6) * (v964 6)) + (((W1 0 7) * (v964 7)) + (((W1 0 8) * (v964 8)) + (((W1 0 9) * (v964 9)) + (((W1 0 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 0)))
    let v1023 := (Real.tanh ((((W1 1 0) * (v964 0)) + (((W1 1 1) * (v964 1)) + (((W1 1 2) * (v964 2)) + (((W1 1 3) * (v964 3)) + (((W1 1 4) * (v964 4)) + (((W1 1 5) * (v964 5)) + (((W1 1 6) * (v964 6)) + (((W1 1 7) * (v964 7)) + (((W1 1 8) * (v964 8)) + (((W1 1 9) * (v964 9)) + (((W1 1 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 1)))
    let v1047 := (Real.tanh ((((W1 2 0) * (v964 0)) + (((W1 2 1) * (v964 1)) + (((W1 2 2) * (v964 2)) + (((W1 2 3) * (v964 3)) + (((W1 2 4) * (v964 4)) + (((W1 2 5) * (v964 5)) + (((W1 2 6) * (v964 6)) + (((W1 2 7) * (v964 7)) + (((W1 2 8) * (v964 8)) + (((W1 2 9) * (v964 9)) + (((W1 2 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 2)))
    let v1071 := (Real.tanh ((((W1 3 0) * (v964 0)) + (((W1 3 1) * (v964 1)) + (((W1 3 2) * (v964 2)) + (((W1 3 3) * (v964 3)) + (((W1 3 4) * (v964 4)) + (((W1 3 5) * (v964 5)) + (((W1 3 6) * (v964 6)) + (((W1 3 7) * (v964 7)) + (((W1 3 8) * (v964 8)) + (((W1 3 9) * (v964 9)) + (((W1 3 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 3)))
    let v1095 := (Real.tanh ((((W1 4 0) * (v964 0)) + (((W1 4 1) * (v964 1)) + (((W1 4 2) * (v964 2)) + (((W1 4 3) * (v964 3)) + (((W1 4 4) * (v964 4)) + (((W1 4 5) * (v964 5)) + (((W1 4 6) * (v964 6)) + (((W1 4 7) * (v964 7)) + (((W1 4 8) * (v964 8)) + (((W1 4 9) * (v964 9)) + (((W1 4 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 4)))
    let v1119 := (Real.tanh ((((W1 5 0) * (v964 0)) + (((W1 5 1) * (v964 1)) + (((W1 5 2) * (v964 2)) + (((W1 5 3) * (v964 3)) + (((W1 5 4) * (v964 4)) + (((W1 5 5) * (v964 5)) + (((W1 5 6) * (v964 6)) + (((W1 5 7) * (v964 7)) + (((W1 5 8) * (v964 8)) + (((W1 5 9) * (v964 9)) + (((W1 5 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 5)))
    let v1143 := (Real.tanh ((((W1 6 0) * (v964 0)) + (((W1 6 1) * (v964 1)) + (((W1 6 2) * (v964 2)) + (((W1 6 3) * (v964 3)) + (((W1 6 4) * (v964 4)) + (((W1 6 5) * (v964 5)) + (((W1 6 6) * (v964 6)) + (((W1 6 7) * (v964 7)) + (((W1 6 8) * (v964 8)) + (((W1 6 9) * (v964 9)) + (((W1 6 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 6)))
    let v1167 := (Real.tanh ((((W1 7 0) * (v964 0)) + (((W1 7 1) * (v964 1)) + (((W1 7 2) * (v964 2)) + (((W1 7 3) * (v964 3)) + (((W1 7 4) * (v964 4)) + (((W1 7 5) * (v964 5)) + (((W1 7 6) * (v964 6)) + (((W1 7 7) * (v964 7)) + (((W1 7 8) * (v964 8)) + (((W1 7 9) * (v964 9)) + (((W1 7 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 7)))
    let v1191 := (Real.tanh ((((W1 8 0) * (v964 0)) + (((W1 8 1) * (v964 1)) + (((W1 8 2) * (v964 2)) + (((W1 8 3) * (v964 3)) + (((W1 8 4) * (v964 4)) + (((W1 8 5) * (v964 5)) + (((W1 8 6) * (v964 6)) + (((W1 8 7) * (v964 7)) + (((W1 8 8) * (v964 8)) + (((W1 8 9) * (v964 9)) + (((W1 8 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 8)))
    let v1215 := (Real.tanh ((((W1 9 0) * (v964 0)) + (((W1 9 1) * (v964 1)) + (((W1 9 2) * (v964 2)) + (((W1 9 3) * (v964 3)) + (((W1 9 4) * (v964 4)) + (((W1 9 5) * (v964 5)) + (((W1 9 6) * (v964 6)) + (((W1 9 7) * (v964 7)) + (((W1 9 8) * (v964 8)) + (((W1 9 9) * (v964 9)) + (((W1 9 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 9)))
    let v1239 := (Real.tanh ((((W1 10 0) * (v964 0)) + (((W1 10 1) * (v964 1)) + (((W1 10 2) * (v964 2)) + (((W1 10 3) * (v964 3)) + (((W1 10 4) * (v964 4)) + (((W1 10 5) * (v964 5)) + (((W1 10 6) * (v964 6)) + (((W1 10 7) * (v964 7)) + (((W1 10 8) * (v964 8)) + (((W1 10 9) * (v964 9)) + (((W1 10 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 10)))
    let v1263 := (Real.tanh ((((W1 11 0) * (v964 0)) + (((W1 11 1) * (v964 1)) + (((W1 11 2) * (v964 2)) + (((W1 11 3) * (v964 3)) + (((W1 11 4) * (v964 4)) + (((W1 11 5) * (v964 5)) + (((W1 11 6) * (v964 6)) + (((W1 11 7) * (v964 7)) + (((W1 11 8) * (v964 8)) + (((W1 11 9) * (v964 9)) + (((W1 11 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 11)))
    let v1287 := (Real.tanh ((((W1 12 0) * (v964 0)) + (((W1 12 1) * (v964 1)) + (((W1 12 2) * (v964 2)) + (((W1 12 3) * (v964 3)) + (((W1 12 4) * (v964 4)) + (((W1 12 5) * (v964 5)) + (((W1 12 6) * (v964 6)) + (((W1 12 7) * (v964 7)) + (((W1 12 8) * (v964 8)) + (((W1 12 9) * (v964 9)) + (((W1 12 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 12)))
    let v1311 := (Real.tanh ((((W1 13 0) * (v964 0)) + (((W1 13 1) * (v964 1)) + (((W1 13 2) * (v964 2)) + (((W1 13 3) * (v964 3)) + (((W1 13 4) * (v964 4)) + (((W1 13 5) * (v964 5)) + (((W1 13 6) * (v964 6)) + (((W1 13 7) * (v964 7)) + (((W1 13 8) * (v964 8)) + (((W1 13 9) * (v964 9)) + (((W1 13 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 13)))
    let v1335 := (Real.tanh ((((W1 14 0) * (v964 0)) + (((W1 14 1) * (v964 1)) + (((W1 14 2) * (v964 2)) + (((W1 14 3) * (v964 3)) + (((W1 14 4) * (v964 4)) + (((W1 14 5) * (v964 5)) + (((W1 14 6) * (v964 6)) + (((W1 14 7) * (v964 7)) + (((W1 14 8) * (v964 8)) + (((W1 14 9) * (v964 9)) + (((W1 14 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 14)))
    let v1359 := (Real.tanh ((((W1 15 0) * (v964 0)) + (((W1 15 1) * (v964 1)) + (((W1 15 2) * (v964 2)) + (((W1 15 3) * (v964 3)) + (((W1 15 4) * (v964 4)) + (((W1 15 5) * (v964 5)) + (((W1 15 6) * (v964 6)) + (((W1 15 7) * (v964 7)) + (((W1 15 8) * (v964 8)) + (((W1 15 9) * (v964 9)) + (((W1 15 10) * (v964 10)) + (0 : ℝ)))))))))))) + (b1 15)))
    let v1482 := (hashemiEnv az t slack (driveAz (Real.tanh ((((W2 0 0) * v999) + (((W2 0 1) * v1023) + (((W2 0 2) * v1047) + (((W2 0 3) * v1071) + (((W2 0 4) * v1095) + (((W2 0 5) * v1119) + (((W2 0 6) * v1143) + (((W2 0 7) * v1167) + (((W2 0 8) * v1191) + (((W2 0 9) * v1215) + (((W2 0 10) * v1239) + (((W2 0 11) * v1263) + (((W2 0 12) * v1287) + (((W2 0 13) * v1311) + (((W2 0 14) * v1335) + (((W2 0 15) * v1359) + (0 : ℝ))))))))))))))))) + (b2 0))) (0.05 : ℝ) (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))) (driveEl (Real.tanh ((((W2 1 0) * v999) + (((W2 1 1) * v1023) + (((W2 1 2) * v1047) + (((W2 1 3) * v1071) + (((W2 1 4) * v1095) + (((W2 1 5) * v1119) + (((W2 1 6) * v1143) + (((W2 1 7) * v1167) + (((W2 1 8) * v1191) + (((W2 1 9) * v1215) + (((W2 1 10) * v1239) + (((W2 1 11) * v1263) + (((W2 1 12) * v1287) + (((W2 1 13) * v1311) + (((W2 1 14) * v1335) + (((W2 1 15) * v1359) + (0 : ℝ))))))))))))))))) + (b2 1))) (leverAt (ymHashemi) (hpHashemi) (dishHalf) (zeHashemi) t) rDrum) dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta (pumpCmd (Real.tanh ((((W2 2 0) * v999) + (((W2 2 1) * v1023) + (((W2 2 2) * v1047) + (((W2 2 3) * v1071) + (((W2 2 4) * v1095) + (((W2 2 5) * v1119) + (((W2 2 6) * v1143) + (((W2 2 7) * v1167) + (((W2 2 8) * v1191) + (((W2 2 9) * v1215) + (((W2 2 10) * v1239) + (((W2 2 11) * v1263) + (((W2 2 12) * v1287) + (((W2 2 13) * v1311) + (((W2 2 14) * v1335) + (((W2 2 15) * v1359) + (0 : ℝ))))))))))))))))) + (b2 2)))) Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr)
    ![(v1482 0), (v1482 1), (v1482 2), (v1482 3), (v1482 4), (v1482 5), (v1482 6), (v1482 7), (v1482 8), (v1482 9), (v1482 10), (v1482 11), (v1482 12), (v1482 13), (v1482 14), (v1482 15), (v1482 16), (v1482 17), (v1482 18), (v1482 19), (v1482 20), (v1482 21), (v1482 22), (v1482 23), (v1482 24), (v1482 25), (v1482 26), (v1482 27), (v1482 28), (v1482 29), (v1482 30), (v1482 31), (v1482 32), (v1482 33), (v1482 34), (v1482 35), (v1482 36), (v1482 37), (v1482 38), (v1482 39), (v1482 40), (v1482 41), (v1482 42), (v1482 43), (v1482 44), (v1482 45), (v1482 46), (v1482 47), (v1482 48), (v1482 49), (v1482 50), (v1482 51), (v1482 52), (v1482 53), (v1482 54), (v1482 55), (v1482 56), (v1482 57), (v1482 58), (v1482 59), (v1482 60), (v1482 61), (v1482 62), (v1482 63), (v1482 64), (v1482 65), (v1482 66), (v1482 67), (v1482 68), (v1482 69), (v1482 70), (v1482 71), (v1482 72), (v1482 73), (v1482 74), (v1482 75), (v1482 76), (v1482 77), (v1482 78), (v1482 79), (v1482 80), (v1482 81), (v1482 82), (v1482 83), (v1482 84), (v1482 85), (v1482 86), (v1482 87), (v1482 88), (v1482 89), (v1482 90), (v1482 91), (v1482 92), (v1482 93), (v1482 94), (v1482 95), (v964 0), (v964 1), (v964 2), (v964 3), (v964 4), (v964 5), (v964 6), (v964 7), (v964 8), (v964 9), (v964 10), (Real.tanh ((((W2 0 0) * v999) + (((W2 0 1) * v1023) + (((W2 0 2) * v1047) + (((W2 0 3) * v1071) + (((W2 0 4) * v1095) + (((W2 0 5) * v1119) + (((W2 0 6) * v1143) + (((W2 0 7) * v1167) + (((W2 0 8) * v1191) + (((W2 0 9) * v1215) + (((W2 0 10) * v1239) + (((W2 0 11) * v1263) + (((W2 0 12) * v1287) + (((W2 0 13) * v1311) + (((W2 0 14) * v1335) + (((W2 0 15) * v1359) + (0 : ℝ))))))))))))))))) + (b2 0))), (Real.tanh ((((W2 1 0) * v999) + (((W2 1 1) * v1023) + (((W2 1 2) * v1047) + (((W2 1 3) * v1071) + (((W2 1 4) * v1095) + (((W2 1 5) * v1119) + (((W2 1 6) * v1143) + (((W2 1 7) * v1167) + (((W2 1 8) * v1191) + (((W2 1 9) * v1215) + (((W2 1 10) * v1239) + (((W2 1 11) * v1263) + (((W2 1 12) * v1287) + (((W2 1 13) * v1311) + (((W2 1 14) * v1335) + (((W2 1 15) * v1359) + (0 : ℝ))))))))))))))))) + (b2 1))), (Real.tanh ((((W2 2 0) * v999) + (((W2 2 1) * v1023) + (((W2 2 2) * v1047) + (((W2 2 3) * v1071) + (((W2 2 4) * v1095) + (((W2 2 5) * v1119) + (((W2 2 6) * v1143) + (((W2 2 7) * v1167) + (((W2 2 8) * v1191) + (((W2 2 9) * v1215) + (((W2 2 10) * v1239) + (((W2 2 11) * v1263) + (((W2 2 12) * v1287) + (((W2 2 13) * v1311) + (((W2 2 14) * v1335) + (((W2 2 15) * v1359) + (0 : ℝ))))))))))))))))) + (b2 2)))] := by
  funext az t slack dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa tautPrev holdsPrev tDead marginPrev flowPrev W1 b1 W2 b2 hist ret dr
  rfl
end

theorem headToCmd_ccc : headToCmd = fun (h : ℝ) =>
    (((min (max h (0 : ℝ)) (6 : ℝ)) - (3 : ℝ)) / (3 : ℝ)) := rfl

theorem headToDriveAz_ccc : headToDriveAz = fun (h : ℝ) (rw : ℝ) (R : ℝ) =>
    ((((((min (max h (0 : ℝ)) (6 : ℝ)) - (3 : ℝ)) / (3 : ℝ)) * (((0.035 : ℝ) * Real.pi) / (180 : ℝ))) * R) / rw) := rfl

theorem headToDriveEl_ccc : headToDriveEl = fun (h : ℝ) (arm : ℝ) (rDrum : ℝ) =>
    ((((-(((min (max h (0 : ℝ)) (6 : ℝ)) - (3 : ℝ)) / (3 : ℝ))) * (((0.025 : ℝ) * Real.pi) / (180 : ℝ))) * arm) / rDrum) := rfl

theorem heatParams_ccc : heatParams =
    ![(0.9 : ℝ), (0.8 : ℝ), (0.03 : ℝ), (15 : ℝ), (0.92 : ℝ), (15 : ℝ), (6300 : ℝ), (593 : ℝ)] := rfl

theorem heatStep_ccc : heatStep = fun (α : ℝ) (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Upipe : ℝ) (UAx : ℝ) (Coil : ℝ) (ToilMax : ℝ) (Pin : ℝ) (Toil : ℝ) (Twall : ℝ) (Ta : ℝ) (dt : ℝ) =>
    let v22 := (Toil - Ta)
    ![(min ToilMax (Toil + ((dt * ((((α * Pin) - ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : ℝ) (UAx * (Toil - Twall))))) / Coil))), (α * Pin), ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22)), (Upipe * v22), (max (0 : ℝ) (UAx * (Toil - Twall))), ((((α * Pin) - ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : ℝ) (UAx * (Toil - Twall))))] := rfl

theorem helixAdvance_ccc : helixAdvance = fun (pitch : ℝ) (φ : ℝ) =>
    ((pitch * φ) / ((2 : ℝ) * Real.pi)) := rfl

theorem hingeWrench_ccc : hingeWrench = fun (xh : ℝ) (zBolt : ℝ) =>
    let v4 := ((0 : ℝ) * (0 : ℝ))
    let v5 := (zBolt * (0 : ℝ))
    let v7 := (zBolt * (1 : ℝ))
    let v8 := (xh * (0 : ℝ))
    let v10 := ((0 : ℝ) * (1 : ℝ))
    let v14 := (xh * (1 : ℝ))
    ![![(1 : ℝ), (0 : ℝ), (0 : ℝ), (v4 - v5), (v7 - v8), (v8 - v10)], ![(0 : ℝ), (1 : ℝ), (0 : ℝ), (v4 - v7), (v5 - v8), (v14 - v4)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), (v10 - v5), (v5 - v14), (v8 - v4)], ![(0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (1 : ℝ), (0 : ℝ)], ![(0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (1 : ℝ)]] := rfl

theorem hpHashemi_ccc : hpHashemi =
    (0.34 : ℝ) := rfl

theorem hyperHit_ccc : hyperHit = fun (f : ℝ) (L : ℝ) (dm : ℝ) (t : ℝ) (β : ℝ) (O : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v11 := (t + β)
    let v12 := (Real.sin v11)
    let v15 := (-(Real.cos v11))
    let v17 := (L / (2 : ℝ))
    let v20 := ((v17 - dm) ^ 2)
    let v21 := ((v17 ^ 2) - v20)
    let v22 := (v12 * v17)
    let v23 := ((0 : ℝ) * v17)
    let v25 := (f + (v15 * v17))
    let v26 := ((O 0) - v22)
    let v27 := ((O 1) - v23)
    let v28 := ((O 2) - v25)
    let v34 := (-(((v26 * v12) + (v27 * (0 : ℝ))) + (v28 * v15)))
    let v40 := (-((((d 0) * v12) + ((d 1) * (0 : ℝ))) + ((d 2) * v15)))
    let v44 := (((1 : ℝ) / v20) + ((1 : ℝ) / v21))
    let v53 := (((v40 ^ 2) * v44) - (((((d 0) * (d 0)) + ((d 1) * (d 1))) + ((d 2) * (d 2))) / v21))
    let v64 := (((((2 : ℝ) * v34) * v40) * v44) - (((2 : ℝ) * (((v26 * (d 0)) + (v27 * (d 1))) + (v28 * (d 2)))) / v21))
    let v81 := (Real.sqrt (max ((v64 ^ 2) - (((4 : ℝ) * v53) * ((((v34 ^ 2) * v44) - ((((v26 * v26) + (v27 * v27)) + (v28 * v28)) / v21)) - (1 : ℝ)))) (0 : ℝ)))
    let v82 := (-v64)
    let v84 := ((2 : ℝ) * v53)
    let v85 := ((v82 - v81) / v84)
    let v87 := ((v82 + v81) / v84)
    let v93 := ((v85 > (0.000001 : ℝ)) ∧ ((v34 + (v85 * v40)) > (0 : ℝ)))
    let v98 := ((v87 > (0.000001 : ℝ)) ∧ ((v34 + (v87 * v40)) > (0 : ℝ)))
    let v104 := (if (v93 ∧ v98) then (min v85 v87) else (if v93 then v85 else (if v98 then v87 else (-(1 : ℝ)))))
    let v112 := (v34 + (v104 * v40))
    let v115 := ((((O 0) + (v104 * (d 0))) - v22) + (v112 * v12))
    let v118 := ((((O 1) + (v104 * (d 1))) - v23) + (v112 * (0 : ℝ)))
    let v121 := ((((O 2) + (v104 * (d 2))) - v25) + (v112 * v15))
    let v131 := (-(v112 / v20))
    let v134 := ((v131 * v12) - (v115 / v21))
    let v137 := ((v131 * (0 : ℝ)) - (v118 / v21))
    let v140 := ((v131 * v15) - (v121 / v21))
    let v147 := (Real.sqrt (max (((v134 * v134) + (v137 * v137)) + (v140 * v140)) (0.000000000000000001 : ℝ)))
    ![((O 0) + (v104 * (d 0))), ((O 1) + (v104 * (d 1))), ((O 2) + (v104 * (d 2))), v104, (Real.sqrt (max (((v115 * v115) + (v118 * v118)) + (v121 * v121)) (0.000000000000000001 : ℝ))), (v134 / v147), (v137 / v147), (v140 / v147)] := rfl

theorem landAt_ccc : landAt = fun (H : Fin 3 → ℝ) (r : Fin 3 → ℝ) (p : ℝ) =>
    let v8 := ((p - (H 2)) / (r 2))
    (((H 0) + (v8 * (r 0))), ((H 1) + (v8 * (r 1)))) := rfl

theorem lerp8_ccc : lerp8 = fun (h0 : ℝ) (h1 : ℝ) (h2 : ℝ) (h3 : ℝ) (h4 : ℝ) (h5 : ℝ) (h6 : ℝ) (h7 : ℝ) (d : ℝ) =>
    let v12 := (min (max d (0 : ℝ)) (7 : ℝ))
    let v14 := (v12 < (1 : ℝ))
    let v16 := (v12 < (2 : ℝ))
    let v18 := (v12 < (3 : ℝ))
    let v20 := (v12 < (4 : ℝ))
    let v22 := (v12 < (5 : ℝ))
    let v24 := (v12 < (6 : ℝ))
    let v32 := (if v14 then h0 else (if v16 then h1 else (if v18 then h2 else (if v20 then h3 else (if v22 then h4 else (if v24 then h5 else (if (v12 < (7 : ℝ)) then h6 else h7)))))))
    (v32 + ((v12 - ((⌊v12⌋ : ℤ) : ℝ)) * ((if v14 then h1 else (if v16 then h2 else (if v18 then h3 else (if v20 then h4 else (if v22 then h5 else (if v24 then h6 else h7)))))) - v32))) := rfl

theorem leverAt_ccc : leverAt = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v5 := (-ym)
    let v6 := (-a)
    let v7 := (Real.cos t)
    let v9 := (-ze)
    let v10 := (Real.sin t)
    let v12 := ((v6 * v7) + (v9 * v10))
    let v16 := (((-v6) * v10) + (v9 * v7))
    (((v5 * v16) - (hp * v12)) / (Real.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) := rfl

theorem loopCap_ccc : loopCap = fun (mOil : ℝ) (mCu : ℝ) (T : ℝ) =>
    let v4 := (T - (273.15 : ℝ))
    ((mOil * ((1000 : ℝ) * (((1.496005 : ℝ) + ((0.003313 : ℝ) * v4)) + ((0.0000008970757 : ℝ) * (v4 ^ 2))))) + (mCu * (385 : ℝ))) := rfl

theorem loopStep_ccc : loopStep = fun (Coil : ℝ) (qAbs : ℝ) (qLoss : ℝ) (qPipe : ℝ) (qPot : ℝ) (Toil : ℝ) (dt : ℝ) =>
    (min (618.15 : ℝ) (Toil + ((dt * (((qAbs - qLoss) - qPipe) - qPot)) / Coil))) := rfl

theorem lostSunS_ccc : lostSunS = fun (tDead : ℝ) (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) (ε : ℝ) =>
    let v8 := (Real.pi / (2 : ℝ))
    let v14 := (Real.sin t)
    let v16 := (v14 * (Real.cos az))
    let v18 := (v14 * (Real.sin az))
    let v19 := (Real.cos t)
    let v20 := (Real.cos elSun)
    let v22 := (v20 * (Real.cos azSun))
    let v24 := (v20 * (Real.sin azSun))
    let v25 := (Real.sin elSun)
    let v30 := (((v16 * v22) + (v18 * v24)) + (v19 * v25))
    let v45 := (Real.sqrt (((((v18 * v25) - (v19 * v24)) ^ 2) + (((v19 * v22) - (v16 * v25)) ^ 2)) + (((v16 * v24) - (v18 * v22)) ^ 2)))
    ((Real.sigmoid ((elSun - (v8 - tDead)) / (0.01 : ℝ))) * (Real.sigmoid (((if (v30 ≤ (0 : ℝ)) then (v8 + (Real.arctan ((-v30) / (max v45 (0.000000000001 : ℝ))))) else (Real.arctan (v45 / v30))) - ε) / (0.01 : ℝ)))) := rfl

theorem megaGeom_ccc : megaGeom = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) =>
    let v21 := ((2 : ℝ) ^ 2)
    let v22 := ((0.8 : ℝ) ^ 2)
    let v25 := ((2 : ℝ) - (Real.sqrt (v21 - v22)))
    let v27 := ((1 : ℝ) - v25)
    let v28 := (-(1.22 : ℝ))
    let v29 := (-(0.8 : ℝ))
    let v30 := (Real.cos t)
    let v32 := (-v27)
    let v33 := (Real.sin t)
    let v35 := ((v29 * v30) + (v32 * v33))
    let v39 := (((-v29) * v33) + (v32 * v30))
    let v49 := (((v28 * v39) - ((0.34 : ℝ) * v35)) / (Real.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : ℝ)) ^ 2))))
    let v52 := (Real.cos az)
    let v53 := (v33 * v52)
    let v54 := (Real.sin az)
    let v55 := (v33 * v54)
    let v56 := (Real.cos elSun)
    let v58 := (v56 * (Real.cos azSun))
    let v60 := (v56 * (Real.sin azSun))
    let v61 := (Real.sin elSun)
    let v66 := (((v53 * v58) + (v55 * v60)) + (v30 * v61))
    let v81 := (Real.sqrt (((((v55 * v61) - (v30 * v60)) ^ 2) + (((v30 * v58) - (v53 * v61)) ^ 2)) + (((v53 * v60) - (v55 * v58)) ^ 2)))
    let v85 := (Real.pi / (2 : ℝ))
    let v95 := (v85 - t)
    let v96 := ((0 : ℝ) * v30)
    let v97 := (-(1 : ℝ))
    let v101 := ((-(0 : ℝ)) * v33)
    let v108 := (-t)
    let v109 := (Real.sin v108)
    let v112 := (Real.cos v108)
    let v113 := ((1 : ℝ) * v112)
    let v116 := ((1 : ℝ) * (-v109))
    let v120 := ((1 : ℝ) + (0.01 : ℝ))
    let v128 := ((1 : ℝ) * (Real.tan (if (v66 ≤ (0 : ℝ)) then (v85 + (Real.arctan ((-v66) / (max v81 (0.000000000001 : ℝ))))) else (Real.arctan (v81 / v66)))))
    let v133 := (((0.05 : ℝ) + ((1 : ℝ) * (0.0093 : ℝ))) / (2 : ℝ))
    let v139 := (v133 ^ 2)
    let v140 := (v128 ^ 2)
    let v142 := ((0.06 : ℝ) ^ 2)
    let v144 := ((2 : ℝ) * v128)
    let v159 := (v128 + v133)
    let v175 := ((2 : ℝ) * (0.8 : ℝ))
    let v192 := ((1.84 : ℝ) / (2 : ℝ))
    let v205 := ((2 : ℝ) / (2 : ℝ))
    let v209 := ((0.4 : ℝ) ^ 2)
    let v222 := (Real.sqrt (3.2 : ℝ))
    let v230 := (Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * v222)))
    let v256 := ((1.22 : ℝ) * (0.8 : ℝ))
    let v257 := ((0.34 : ℝ) * v27)
    let v267 := ((W * rcm) * v33)
    ![(2 : ℝ), (1 : ℝ), (0.8 : ℝ), v175, v25, v27, (v205 - v25), (Real.sqrt ((((0 : ℝ) ^ 2) + v209) + ((v205 - ((2 : ℝ) - (Real.sqrt (v21 - ((Real.sqrt (v22 + v209)) ^ 2))))) ^ 2))), ((0.4 : ℝ) / (v222 - (1 : ℝ))), (((3.36 : ℝ) - v222) / ((2 : ℝ) * v230)), (Real.sqrt ((v192 ^ 2) + ((0.80 : ℝ) ^ 2))), (1.84 : ℝ), (0.80 : ℝ), (0.55 : ℝ), (0.62 : ℝ), ((0.62 : ℝ) - (0.175 : ℝ)), (Real.sqrt (((0.96 : ℝ) ^ 2) - (((0.62 : ℝ) - (0.175 : ℝ)) ^ 2))), (1.59 : ℝ), (1.84 : ℝ), (1.35 : ℝ), (v96 + (v97 * v33)), (v101 + (v97 * v30)), (v96 + ((1 : ℝ) * v33)), (v101 + ((1 : ℝ) * v30)), ((0 : ℝ) + ((1 : ℝ) * v109)), ((0 : ℝ) - v113), (-v109), v112, (Real.sqrt (((((0 : ℝ) + ((1 : ℝ) * v109)) + v116) ^ 2) + ((((0 : ℝ) - v113) + v113) ^ 2))), (Real.sqrt (((((0 : ℝ) + (v120 * v109)) + v116) ^ 2) + ((((0 : ℝ) - (v120 * v112)) + v113) ^ 2))), v28, (0.34 : ℝ), v35, v39, v49, (if (v256 ≤ v257) then v85 else (Real.arctan ((((1.22 : ℝ) * v27) + ((0.34 : ℝ) * (0.8 : ℝ))) / (v256 - v257)))), (Real.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : ℝ)) ^ 2))), (v267 / v49), (v267 * ((ωd * rDrum) / v49)), ((((2 : ℝ) * (1 : ℝ)) * slack) / v49), (Real.arctan ((0.8 : ℝ) / v27)), ((1 : ℝ) * (Real.tan t)), ((v27 * (Real.sin v95)) + ((0.8 : ℝ) * (Real.cos v95))), (((1.30 : ℝ) - (0.05 : ℝ)) - ((v27 * (Real.sin v95)) + ((0.8 : ℝ) * (Real.cos v95)))), (((0.8 : ℝ) * v33) + (v27 * v30)), (((1.84 : ℝ) - v175) / (2 : ℝ)), ((1.30 : ℝ) - (0.05 : ℝ)), ((v52 * (0.80 : ℝ)) - (v54 * (0 : ℝ))), ((v54 * (0.80 : ℝ)) + (v52 * (0 : ℝ))), (Real.sqrt ((((v52 * (0.80 : ℝ)) - (v54 * (0 : ℝ))) ^ 2) + (((v54 * (0.80 : ℝ)) + (v52 * (0 : ℝ))) ^ 2))), v128, ((0.05 : ℝ) + ((1 : ℝ) * (0.0093 : ℝ))), (if ((v133 + (0.06 : ℝ)) ≤ v128) then (0 : ℝ) else (if (v128 ≤ ((0.06 : ℝ) - v133)) then (1 : ℝ) else ((((v139 * (Real.arccos (((v140 + v139) - v142) / (v144 * v133)))) + (v142 * (Real.arccos (((v140 + v142) - v139) / (v144 * (0.06 : ℝ)))))) - ((Real.sqrt ((((((-v128) + v133) + (0.06 : ℝ)) * (v159 - (0.06 : ℝ))) * ((v128 - v133) + (0.06 : ℝ))) * (v159 + (0.06 : ℝ)))) / (2 : ℝ))) / (Real.pi * v139)))), (if ((0 : ℝ) < elSun) then (((dni * (v175 ^ 2)) * rho) * (if ((v133 + (0.06 : ℝ)) ≤ v128) then (0 : ℝ) else (if (v128 ≤ ((0.06 : ℝ) - v133)) then (1 : ℝ) else ((((v139 * (Real.arccos (((v140 + v139) - v142) / (v144 * v133)))) + (v142 * (Real.arccos (((v140 + v142) - v139) / (v144 * (0.06 : ℝ)))))) - ((Real.sqrt ((((((-v128) + v133) + (0.06 : ℝ)) * (v159 - (0.06 : ℝ))) * ((v128 - v133) + (0.06 : ℝ))) * (v159 + (0.06 : ℝ)))) / (2 : ℝ))) / (Real.pi * v139))))) else (0 : ℝ)), ((1.25 : ℝ) * (Real.sin (0.0005 : ℝ))), ((0.0015 : ℝ) / v175), (rodLen - (rodLen - v230)), (((0.00175 : ℝ) * t) / ((2 : ℝ) * Real.pi)), ((((0.0000000172 : ℝ) * ((2 : ℝ) * (4 : ℝ))) * ((5 : ℝ) / (12 : ℝ))) / (0.0000015 : ℝ)), (((((0.80 : ℝ) - ((0.80 : ℝ) + (1.22 : ℝ))) * (-(0.0005 : ℝ))) + ((((1 : ℝ) * (v192 - (0 : ℝ))) - (0 : ℝ)) * (0 : ℝ))) + (((1.30 : ℝ) - (0 : ℝ)) * (0 : ℝ)))] := rfl

theorem megaParams_ccc : megaParams =
    ![(0.03 : ℝ), (300 : ℝ), (0.9 : ℝ), (2000 : ℝ), (0.85 : ℝ), (10 : ℝ), (1000000 : ℝ), (1 : ℝ)] := rfl

theorem megaReqs_ccc : megaReqs = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) =>
    let v23 := ((0.8 : ℝ) ^ 2)
    let v27 := ((1 : ℝ) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - v23))))
    let v28 := (-(1.22 : ℝ))
    let v29 := (-(0.8 : ℝ))
    let v30 := (Real.cos t)
    let v32 := (-v27)
    let v33 := (Real.sin t)
    let v35 := ((v29 * v30) + (v32 * v33))
    let v39 := (((-v29) * v33) + (v32 * v30))
    let v49 := (((v28 * v39) - ((0.34 : ℝ) * v35)) / (Real.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : ℝ)) ^ 2))))
    let v51 := (v33 * (Real.cos az))
    let v53 := (v33 * (Real.sin az))
    let v54 := (Real.cos elSun)
    let v56 := (v54 * (Real.cos azSun))
    let v58 := (v54 * (Real.sin azSun))
    let v59 := (Real.sin elSun)
    let v64 := (((v51 * v56) + (v53 * v58)) + (v30 * v59))
    let v79 := (Real.sqrt (((((v53 * v59) - (v30 * v58)) ^ 2) + (((v30 * v56) - (v51 * v59)) ^ 2)) + (((v51 * v58) - (v53 * v56)) ^ 2)))
    let v103 := (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))
    let v135 := ((1 : ℝ) * (Real.tan (if (v64 ≤ (0 : ℝ)) then ((Real.pi / (2 : ℝ)) + (Real.arctan ((-v64) / (max v79 (0.000000000001 : ℝ))))) else (Real.arctan (v79 / v64)))))
    ![(@ite _ (v103 = v103) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.010 : ℝ) / (2 : ℝ)) < (0.010 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((W * rcm) ≤ (Tmax * v49)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((Real.sqrt (v23 + (v27 ^ 2))) < (1.22 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.22 : ℝ) * (0.8 : ℝ)) ≤ ((0.34 : ℝ) * v27)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v135 + ((((2 : ℝ) * (1 : ℝ)) * slack) / v49)) ≤ (0.03 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v135 ≤ (0.03 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))] := rfl

theorem megaScrew_ccc : megaScrew = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) =>
    let v28 := (-(1.22 : ℝ))
    let v29 := (-(0.8 : ℝ))
    let v30 := (Real.cos t)
    let v32 := (-((1 : ℝ) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2))))))
    let v33 := (Real.sin t)
    let v35 := ((v29 * v30) + (v32 * v33))
    let v39 := (((-v29) * v33) + (v32 * v30))
    let v48 := (Real.sqrt (((v35 - v28) ^ 2) + ((v39 - (0.34 : ℝ)) ^ 2)))
    let v49 := (((v28 * v39) - ((0.34 : ℝ) * v35)) / v48)
    let v56 := ((1.84 : ℝ) / (2 : ℝ))
    let v60 := (Real.sqrt ((v56 ^ 2) + ((0.80 : ℝ) ^ 2)))
    let v71 := (((0.55 : ℝ) + (1.30 : ℝ)) - (0.05 : ℝ))
    let v73 := (v56 - (0.03 : ℝ))
    let v75 := ((0 : ℝ) * (0 : ℝ))
    let v76 := ((0.62 : ℝ) * (0 : ℝ))
    let v78 := ((0.62 : ℝ) * (1 : ℝ))
    let v80 := ((0 : ℝ) * (1 : ℝ))
    let v89 := ((0.55 : ℝ) * (0 : ℝ))
    let v91 := ((0.80 : ℝ) * (1 : ℝ))
    let v93 := ((0.80 : ℝ) * (0 : ℝ))
    let v94 := (v56 * (0 : ℝ))
    let v96 := (-v56)
    let v99 := (v96 * (0 : ℝ))
    let v113 := (v71 * (0 : ℝ))
    let v114 := (v75 - v113)
    let v115 := (v71 * (1 : ℝ))
    let v116 := (v115 - v93)
    let v117 := (v93 - v80)
    let v120 := ((2 : ℝ) * Real.pi)
    let v121 := ((0.00175 : ℝ) / v120)
    let v122 := (v73 * (0 : ℝ))
    let v123 := (v115 - v122)
    let v125 := (v75 - v115)
    let v126 := (v113 - v122)
    let v127 := (v73 * (1 : ℝ))
    let v129 := (v80 - v113)
    let v130 := (v113 - v127)
    let v133 := ((0 : ℝ) * v71)
    let v134 := ((1 : ℝ) * (0 : ℝ))
    let v137 := ((1 : ℝ) * (0.80 : ℝ))
    let v140 := ((0 : ℝ) * (0.80 : ℝ))
    let v145 := ((1 : ℝ) * v71)
    let v150 := (v113 - v93)
    let v151 := (v91 - v75)
    let v153 := ((0 : ℝ) * (0.3 : ℝ))
    let v160 := ((0.80 : ℝ) - v35)
    let v161 := (v71 + v39)
    let v163 := ((W * rcm) * v33)
    let v164 := (v163 / v49)
    let v168 := ((v164 * (-(v28 - v35))) / v48)
    let v171 := ((v164 * ((0.34 : ℝ) - v39)) / v48)
    let v172 := (v134 + v75)
    let v189 := ((v75 + v75) + v134)
    let v198 := ((v89 - v91) * (0 : ℝ))
    let v211 := ((((0.55 : ℝ) * (0.80 : ℝ)) - v93) * (0 : ℝ))
    let v224 := (-((Fdrive * v56) / v60))
    let v226 := ((Fdrive * (0.80 : ℝ)) / v60)
    let v247 := ((0 : ℝ) * (v122 - v80))
    let v251 := (v116 * (0 : ℝ))
    let v253 := (v117 * (0 : ℝ))
    let v258 := ((0 : ℝ) * (v127 - v75))
    let v259 := ((((1 : ℝ) * v125) + ((0 : ℝ) * v126)) + v258)
    let v260 := (v114 * (0 : ℝ))
    let v268 := ((0 : ℝ) * (v122 - v75))
    let v269 := ((((1 : ℝ) * v129) + ((0 : ℝ) * v130)) + v268)
    let v275 := ((v134 + v80) + v75)
    let v279 := (v172 + v80)
    let v283 := (v121 * (0 : ℝ))
    let v309 := (v150 * (0 : ℝ))
    let v311 := (v151 * (0 : ℝ))
    let v317 := (v125 * (0 : ℝ))
    ![((((v172 + v75) + ((v75 - v76) * (0 : ℝ))) + ((v78 - v75) * (0 : ℝ))) + ((v75 - v80) * (1 : ℝ))), (((((v75 + v134) + v75) + ((v75 - v78) * (0 : ℝ))) + ((v76 - v75) * (0 : ℝ))) + ((v80 - v75) * (1 : ℝ))), (((v189 + ((v80 - v76) * (0 : ℝ))) + ((v76 - v80) * (0 : ℝ))) + ((v75 - v75) * (1 : ℝ))), (((v189 + (((v56 * (1 : ℝ)) - v89) * (0 : ℝ))) + v198) + ((v93 - v94) * (1 : ℝ))), (((v189 + (((v96 * (1 : ℝ)) - v89) * (0 : ℝ))) + v198) + ((v93 - v99) * (1 : ℝ))), ((((v172 + v75) + ((v75 - v76) * (0 : ℝ))) + ((v78 - v75) * (0 : ℝ))) + ((v75 - v80) * (1 : ℝ))), (((((v75 + v134) + v75) + ((v75 - v78) * (0 : ℝ))) + ((v76 - v75) * (0 : ℝ))) + ((v80 - v75) * (1 : ℝ))), (((v189 + ((v80 - v76) * (0 : ℝ))) + ((v76 - v80) * (0 : ℝ))) + ((v75 - v75) * (1 : ℝ))), (((v189 + (((v56 * (1 : ℝ)) - v89) * (0 : ℝ))) + v198) + ((v93 - v94) * (1 : ℝ))), (((v189 + (((v96 * (1 : ℝ)) - v89) * (0 : ℝ))) + v198) + ((v93 - v99) * (1 : ℝ))), (((((v93 + v94) + v75) + ((v94 - ((0.55 : ℝ) * v56)) * (0 : ℝ))) + v211) + ((((0.80 : ℝ) * v56) - (v56 * (0.80 : ℝ))) * (1 : ℝ))), (((((v93 + v99) + v75) + ((v99 - ((0.55 : ℝ) * v96)) * (0 : ℝ))) + v211) + ((((0.80 : ℝ) * v96) - (v96 * (0.80 : ℝ))) * (1 : ℝ))), (((((((0 : ℝ) * (v94 - ((0.55 : ℝ) * v226))) + ((0 : ℝ) * (((0.55 : ℝ) * v224) - v93))) + ((1 : ℝ) * (((0.80 : ℝ) * v226) - (v56 * v224)))) + ((0 : ℝ) * v224)) + ((0 : ℝ) * v226)) + v75), (((((((1 : ℝ) * v114) + ((0 : ℝ) * v123)) + v247) + (v114 * (1 : ℝ))) + v251) + v253), (((v259 + v260) + (v116 * (1 : ℝ))) + v253), (((v269 + v260) + v251) + (v117 * (1 : ℝ))), (((v275 + v260) + v251) + v253), (((v279 + v260) + v251) + v253), (((v259 + v283) + v115) + v75), (((v269 + v283) + v113) + v80), (((v275 + v283) + v113) + v75), (((v279 + v283) + v113) + v75), (((((((1 : ℝ) * (-v121)) + v133) + v75) + (v121 * (1 : ℝ))) + v113) + v75), (((((((0 : ℝ) * v114) + ((1 : ℝ) * v123)) + v247) + (v125 * (1 : ℝ))) + v309) + v311), (((((((0 : ℝ) * v125) + ((1 : ℝ) * v126)) + v258) + v317) + (v150 * (1 : ℝ))) + v311), (((((((0 : ℝ) * v129) + ((1 : ℝ) * v130)) + v268) + v317) + v309) + (v151 * (1 : ℝ))), ((v133 - v134) + (0 : ℝ)), ((v137 - v133) + (0 : ℝ)), ((v75 - v140) + (0 : ℝ)), ((v133 - v75) + v114), ((v140 - v145) + v116), ((v134 - v140) + v117), ((v153 - v137) + v151), (((((((1 : ℝ) * (((0 : ℝ) * v171) - (v161 * (0 : ℝ)))) + ((0 : ℝ) * ((v161 * v168) - (v160 * v171)))) + ((0 : ℝ) * ((v160 * (0 : ℝ)) - ((0 : ℝ) * v168)))) + (v114 * v168)) + v251) + (v117 * v171)), (((W / (2 : ℝ)) * (0.03 : ℝ)) / ((Real.pi * ((0.0101 : ℝ) ^ 3)) / (32 : ℝ))), v121, ((5 : ℝ) / (12 : ℝ)), (v163 * ((ωd * rDrum) / v49)), ((((ωm * (0.05 : ℝ)) / v60) * (60 : ℝ)) / v120), ((ωm * (60 : ℝ)) / v120)] := rfl

theorem megaScrew_ω_ccc : megaScrew.ω = fun (t : ℝ) (ωd : ℝ) (rDrum : ℝ) =>
    let v5 := (-(1.22 : ℝ))
    let v8 := (-(0.8 : ℝ))
    let v9 := (Real.cos t)
    let v19 := (-((1 : ℝ) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2))))))
    let v20 := (Real.sin t)
    let v22 := ((v8 * v9) + (v19 * v20))
    let v26 := (((-v8) * v20) + (v19 * v9))
    ((ωd * rDrum) / (((v5 * v26) - ((0.34 : ℝ) * v22)) / (Real.sqrt (((v22 - v5) ^ 2) + ((v26 - (0.34 : ℝ)) ^ 2))))) := rfl

theorem megaStep_ccc : megaStep = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) =>
    let v27 := ((1 : ℝ) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2)))))
    let v39 := ((1.22 : ℝ) * (0.8 : ℝ))
    let v40 := ((0.34 : ℝ) * v27)
    let v43 := (Real.pi / (2 : ℝ))
    let v50 := (if (v39 ≤ v40) then v43 else (Real.arctan ((((1.22 : ℝ) * v27) + ((0.34 : ℝ) * (0.8 : ℝ))) / (v39 - v40))))
    let v51 := (-(1.22 : ℝ))
    let v52 := (-(0.8 : ℝ))
    let v54 := (Real.cos (0 : ℝ))
    let v56 := (-v27)
    let v57 := (Real.sin (0 : ℝ))
    let v60 := (-v52)
    let v69 := (Real.sqrt (((((v52 * v54) + (v56 * v57)) - v51) ^ 2) + ((((v60 * v57) + (v56 * v54)) - (0.34 : ℝ)) ^ 2)))
    let v70 := (Real.cos v50)
    let v72 := (Real.sin v50)
    let v83 := (Real.sqrt (((((v52 * v70) + (v56 * v72)) - v51) ^ 2) + ((((v60 * v72) + (v56 * v70)) - (0.34 : ℝ)) ^ 2)))
    let v84 := (Real.cos t)
    let v86 := (Real.sin t)
    let v88 := ((v52 * v84) + (v56 * v86))
    let v91 := ((v60 * v86) + (v56 * v84))
    let v97 := (Real.sqrt (((v88 - v51) ^ 2) + ((v91 - (0.34 : ℝ)) ^ 2)))
    let v99 := (ωd * rDrum)
    let v101 := ((v97 + slack) - (v99 * dt))
    let v102 := (v101 < v83)
    let v103 := (v69 < v101)
    let v105 := (if v102 then v83 else (if v103 then v69 else v101))
    let v110 := (((0 : ℝ) + v50) / (2 : ℝ))
    let v111 := (Real.cos v110)
    let v113 := (Real.sin v110)
    let v125 := (v105 < (Real.sqrt (((((v52 * v111) + (v56 * v113)) - v51) ^ 2) + ((((v60 * v113) + (v56 * v111)) - (0.34 : ℝ)) ^ 2))))
    let v126 := (if v125 then v110 else (0 : ℝ))
    let v127 := (if v125 then v50 else v110)
    let v129 := ((v126 + v127) / (2 : ℝ))
    let v130 := (Real.cos v129)
    let v132 := (Real.sin v129)
    let v144 := (v105 < (Real.sqrt (((((v52 * v130) + (v56 * v132)) - v51) ^ 2) + ((((v60 * v132) + (v56 * v130)) - (0.34 : ℝ)) ^ 2))))
    let v145 := (if v144 then v129 else v126)
    let v146 := (if v144 then v127 else v129)
    let v148 := ((v145 + v146) / (2 : ℝ))
    let v149 := (Real.cos v148)
    let v151 := (Real.sin v148)
    let v163 := (v105 < (Real.sqrt (((((v52 * v149) + (v56 * v151)) - v51) ^ 2) + ((((v60 * v151) + (v56 * v149)) - (0.34 : ℝ)) ^ 2))))
    let v164 := (if v163 then v148 else v145)
    let v165 := (if v163 then v146 else v148)
    let v167 := ((v164 + v165) / (2 : ℝ))
    let v168 := (Real.cos v167)
    let v170 := (Real.sin v167)
    let v182 := (v105 < (Real.sqrt (((((v52 * v168) + (v56 * v170)) - v51) ^ 2) + ((((v60 * v170) + (v56 * v168)) - (0.34 : ℝ)) ^ 2))))
    let v183 := (if v182 then v167 else v164)
    let v184 := (if v182 then v165 else v167)
    let v186 := ((v183 + v184) / (2 : ℝ))
    let v187 := (Real.cos v186)
    let v189 := (Real.sin v186)
    let v201 := (v105 < (Real.sqrt (((((v52 * v187) + (v56 * v189)) - v51) ^ 2) + ((((v60 * v189) + (v56 * v187)) - (0.34 : ℝ)) ^ 2))))
    let v202 := (if v201 then v186 else v183)
    let v203 := (if v201 then v184 else v186)
    let v205 := ((v202 + v203) / (2 : ℝ))
    let v206 := (Real.cos v205)
    let v208 := (Real.sin v205)
    let v220 := (v105 < (Real.sqrt (((((v52 * v206) + (v56 * v208)) - v51) ^ 2) + ((((v60 * v208) + (v56 * v206)) - (0.34 : ℝ)) ^ 2))))
    let v221 := (if v220 then v205 else v202)
    let v222 := (if v220 then v203 else v205)
    let v224 := ((v221 + v222) / (2 : ℝ))
    let v225 := (Real.cos v224)
    let v227 := (Real.sin v224)
    let v239 := (v105 < (Real.sqrt (((((v52 * v225) + (v56 * v227)) - v51) ^ 2) + ((((v60 * v227) + (v56 * v225)) - (0.34 : ℝ)) ^ 2))))
    let v240 := (if v239 then v224 else v221)
    let v241 := (if v239 then v222 else v224)
    let v243 := ((v240 + v241) / (2 : ℝ))
    let v244 := (Real.cos v243)
    let v246 := (Real.sin v243)
    let v258 := (v105 < (Real.sqrt (((((v52 * v244) + (v56 * v246)) - v51) ^ 2) + ((((v60 * v246) + (v56 * v244)) - (0.34 : ℝ)) ^ 2))))
    let v259 := (if v258 then v243 else v240)
    let v260 := (if v258 then v241 else v243)
    let v262 := ((v259 + v260) / (2 : ℝ))
    let v263 := (Real.cos v262)
    let v265 := (Real.sin v262)
    let v277 := (v105 < (Real.sqrt (((((v52 * v263) + (v56 * v265)) - v51) ^ 2) + ((((v60 * v265) + (v56 * v263)) - (0.34 : ℝ)) ^ 2))))
    let v278 := (if v277 then v262 else v259)
    let v279 := (if v277 then v260 else v262)
    let v281 := ((v278 + v279) / (2 : ℝ))
    let v282 := (Real.cos v281)
    let v284 := (Real.sin v281)
    let v296 := (v105 < (Real.sqrt (((((v52 * v282) + (v56 * v284)) - v51) ^ 2) + ((((v60 * v284) + (v56 * v282)) - (0.34 : ℝ)) ^ 2))))
    let v297 := (if v296 then v281 else v278)
    let v298 := (if v296 then v279 else v281)
    let v300 := ((v297 + v298) / (2 : ℝ))
    let v301 := (Real.cos v300)
    let v303 := (Real.sin v300)
    let v315 := (v105 < (Real.sqrt (((((v52 * v301) + (v56 * v303)) - v51) ^ 2) + ((((v60 * v303) + (v56 * v301)) - (0.34 : ℝ)) ^ 2))))
    let v316 := (if v315 then v300 else v297)
    let v317 := (if v315 then v298 else v300)
    let v319 := ((v316 + v317) / (2 : ℝ))
    let v320 := (Real.cos v319)
    let v322 := (Real.sin v319)
    let v334 := (v105 < (Real.sqrt (((((v52 * v320) + (v56 * v322)) - v51) ^ 2) + ((((v60 * v322) + (v56 * v320)) - (0.34 : ℝ)) ^ 2))))
    let v335 := (if v334 then v319 else v316)
    let v336 := (if v334 then v317 else v319)
    let v338 := ((v335 + v336) / (2 : ℝ))
    let v339 := (Real.cos v338)
    let v341 := (Real.sin v338)
    let v353 := (v105 < (Real.sqrt (((((v52 * v339) + (v56 * v341)) - v51) ^ 2) + ((((v60 * v341) + (v56 * v339)) - (0.34 : ℝ)) ^ 2))))
    let v354 := (if v353 then v338 else v335)
    let v355 := (if v353 then v336 else v338)
    let v357 := ((v354 + v355) / (2 : ℝ))
    let v358 := (Real.cos v357)
    let v360 := (Real.sin v357)
    let v372 := (v105 < (Real.sqrt (((((v52 * v358) + (v56 * v360)) - v51) ^ 2) + ((((v60 * v360) + (v56 * v358)) - (0.34 : ℝ)) ^ 2))))
    let v373 := (if v372 then v357 else v354)
    let v374 := (if v372 then v355 else v357)
    let v376 := ((v373 + v374) / (2 : ℝ))
    let v377 := (Real.cos v376)
    let v379 := (Real.sin v376)
    let v391 := (v105 < (Real.sqrt (((((v52 * v377) + (v56 * v379)) - v51) ^ 2) + ((((v60 * v379) + (v56 * v377)) - (0.34 : ℝ)) ^ 2))))
    let v392 := (if v391 then v376 else v373)
    let v393 := (if v391 then v374 else v376)
    let v395 := ((v392 + v393) / (2 : ℝ))
    let v396 := (Real.cos v395)
    let v398 := (Real.sin v395)
    let v410 := (v105 < (Real.sqrt (((((v52 * v396) + (v56 * v398)) - v51) ^ 2) + ((((v60 * v398) + (v56 * v396)) - (0.34 : ℝ)) ^ 2))))
    let v411 := (if v410 then v395 else v392)
    let v412 := (if v410 then v393 else v395)
    let v414 := ((v411 + v412) / (2 : ℝ))
    let v415 := (Real.cos v414)
    let v417 := (Real.sin v414)
    let v429 := (v105 < (Real.sqrt (((((v52 * v415) + (v56 * v417)) - v51) ^ 2) + ((((v60 * v417) + (v56 * v415)) - (0.34 : ℝ)) ^ 2))))
    let v430 := (if v429 then v414 else v411)
    let v431 := (if v429 then v412 else v414)
    let v433 := ((v430 + v431) / (2 : ℝ))
    let v434 := (Real.cos v433)
    let v436 := (Real.sin v433)
    let v448 := (v105 < (Real.sqrt (((((v52 * v434) + (v56 * v436)) - v51) ^ 2) + ((((v60 * v436) + (v56 * v434)) - (0.34 : ℝ)) ^ 2))))
    let v449 := (if v448 then v433 else v430)
    let v450 := (if v448 then v431 else v433)
    let v452 := ((v449 + v450) / (2 : ℝ))
    let v453 := (Real.cos v452)
    let v455 := (Real.sin v452)
    let v467 := (v105 < (Real.sqrt (((((v52 * v453) + (v56 * v455)) - v51) ^ 2) + ((((v60 * v455) + (v56 * v453)) - (0.34 : ℝ)) ^ 2))))
    let v468 := (if v467 then v452 else v449)
    let v469 := (if v467 then v450 else v452)
    let v471 := ((v468 + v469) / (2 : ℝ))
    let v472 := (Real.cos v471)
    let v474 := (Real.sin v471)
    let v486 := (v105 < (Real.sqrt (((((v52 * v472) + (v56 * v474)) - v51) ^ 2) + ((((v60 * v474) + (v56 * v472)) - (0.34 : ℝ)) ^ 2))))
    let v487 := (if v486 then v471 else v468)
    let v488 := (if v486 then v469 else v471)
    let v490 := ((v487 + v488) / (2 : ℝ))
    let v491 := (Real.cos v490)
    let v493 := (Real.sin v490)
    let v505 := (v105 < (Real.sqrt (((((v52 * v491) + (v56 * v493)) - v51) ^ 2) + ((((v60 * v493) + (v56 * v491)) - (0.34 : ℝ)) ^ 2))))
    let v506 := (if v505 then v490 else v487)
    let v507 := (if v505 then v488 else v490)
    let v509 := ((v506 + v507) / (2 : ℝ))
    let v510 := (Real.cos v509)
    let v512 := (Real.sin v509)
    let v524 := (v105 < (Real.sqrt (((((v52 * v510) + (v56 * v512)) - v51) ^ 2) + ((((v60 * v512) + (v56 * v510)) - (0.34 : ℝ)) ^ 2))))
    let v525 := (if v524 then v509 else v506)
    let v526 := (if v524 then v507 else v509)
    let v528 := ((v525 + v526) / (2 : ℝ))
    let v529 := (Real.cos v528)
    let v531 := (Real.sin v528)
    let v543 := (v105 < (Real.sqrt (((((v52 * v529) + (v56 * v531)) - v51) ^ 2) + ((((v60 * v531) + (v56 * v529)) - (0.34 : ℝ)) ^ 2))))
    let v544 := (if v543 then v528 else v525)
    let v545 := (if v543 then v526 else v528)
    let v547 := ((v544 + v545) / (2 : ℝ))
    let v548 := (Real.cos v547)
    let v550 := (Real.sin v547)
    let v562 := (v105 < (Real.sqrt (((((v52 * v548) + (v56 * v550)) - v51) ^ 2) + ((((v60 * v550) + (v56 * v548)) - (0.34 : ℝ)) ^ 2))))
    let v567 := (if (v69 ≤ v101) then (0 : ℝ) else (((if v562 then v547 else v544) + (if v562 then v545 else v547)) / (2 : ℝ)))
    let v568 := (W * rcm)
    let v569 := (Real.cos v567)
    let v571 := (Real.sin v567)
    let v573 := ((v52 * v569) + (v56 * v571))
    let v576 := ((v60 * v571) + (v56 * v569))
    let v591 := ((t < v567) ∧ (¬ (v568 ≤ (Tmax * (((v51 * v576) - ((0.34 : ℝ) * v573)) / (Real.sqrt (((v573 - v51) ^ 2) + ((v576 - (0.34 : ℝ)) ^ 2))))))))
    let v592 := (if v591 then t else v567)
    let v602 := (Real.cos v592)
    let v604 := (Real.sin v592)
    let v606 := ((v52 * v602) + (v56 * v604))
    let v609 := ((v60 * v604) + (v56 * v602))
    let v629 := (v86 * (Real.cos az))
    let v631 := (v86 * (Real.sin az))
    let v632 := (Real.cos elSun)
    let v634 := (v632 * (Real.cos azSun))
    let v636 := (v632 * (Real.sin azSun))
    let v637 := (Real.sin elSun)
    let v642 := (((v629 * v634) + (v631 * v636)) + (v84 * v637))
    let v657 := (Real.sqrt (((((v631 * v637) - (v84 * v636)) ^ 2) + (((v84 * v634) - (v629 * v637)) ^ 2)) + (((v629 * v636) - (v631 * v634)) ^ 2)))
    let v667 := (if (v642 ≤ (0 : ℝ)) then (v43 + (Real.arctan ((-v642) / (max v657 (0.000000000001 : ℝ))))) else (Real.arctan (v657 / v642)))
    let v669 := (v43 - v50)
    let v670 := (v669 ≤ elSun)
    ![(az + (((ωm * (0.05 : ℝ)) / (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))) * dt)), v592, (if v103 then (v101 - v69) else (0 : ℝ)), (if v591 then v97 else v105), v50, (if (v102 ∨ v591) then (1 : ℝ) else (0 : ℝ)), (if ((if v103 then (v101 - v69) else (0 : ℝ)) = (0 : ℝ)) then (1 : ℝ) else (0 : ℝ)), (@ite _ (v568 ≤ (Tmax * (((v51 * v609) - ((0.34 : ℝ) * v606)) / (Real.sqrt (((v606 - v51) ^ 2) + ((v609 - (0.34 : ℝ)) ^ 2)))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (((v51 * v91) - ((0.34 : ℝ) * v88)) / v97), (v99 / (((v51 * v91) - ((0.34 : ℝ) * v88)) / v97)), ((ωm * (0.05 : ℝ)) / (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))), v667, (v43 - t), (@ite _ v670 (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v670 ∧ ((0.03 : ℝ) < v667)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (Real.sigmoid ((elSun - v669) / (0.01 : ℝ))), ((Real.sigmoid ((elSun - v669) / (0.01 : ℝ))) * (Real.sigmoid ((v667 - (0.03 : ℝ)) / (0.01 : ℝ))))]:= by
  funext az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
  rewrite [megaStep, step]
  lift_lets
  intro v27 v39 v40 v43 v50 v51 v52 v54 v56 v57 v60 v69 v70 v72 v83 v84 v86 v88 v91 v97 v99 v101 v102 v103 v105 v110 v111 v113 v125 v126 v127 v129 v130 v132 v144 v145 v146 v148 v149 v151 v163 v164 v165 v167 v168 v170 v182 v183 v184 v186 v187 v189 v201 v202 v203 v205 v206 v208 v220 v221 v222 v224 v225 v227 v239 v240 v241 v243 v244 v246 v258 v259 v260 v262 v263 v265 v277 v278 v279 v281 v282 v284 v296 v297 v298 v300 v301 v303 v315 v316 v317 v319 v320 v322 v334 v335 v336 v338 v339 v341 v353 v354 v355 v357 v358 v360 v372 v373 v374 v376 v377 v379 v391 v392 v393 v395 v396 v398 v410 v411 v412 v414 v415 v417 v429 v430 v431 v433 v434 v436 v448 v449 v450 v452 v453 v455 v467 v468 v469 v471 v472 v474 v486 v487 v488 v490 v491 v493 v505 v506 v507 v509 v510 v512 v524 v525 v526 v528 v529 v531 v543 v544 v545 v547 v548 v550 v562 v567 v568 v569 v571 v573 v576 v591 v592 v602 v604 v606 v609 v629 v631 v632 v634 v636 v637 v642 v657 v667 v669 v670
  have e0 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[1] ((0 : ℝ), v50) = (v126, v127) := rfl
  have e1 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[2] ((0 : ℝ), v50) = (v145, v146) := by
    rewrite [show (2 : ℕ) = 1 + 1 from rfl, Function.iterate_succ_apply', e0]
    rfl
  have e2 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[3] ((0 : ℝ), v50) = (v164, v165) := by
    rewrite [show (3 : ℕ) = 2 + 1 from rfl, Function.iterate_succ_apply', e1]
    rfl
  have e3 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[4] ((0 : ℝ), v50) = (v183, v184) := by
    rewrite [show (4 : ℕ) = 3 + 1 from rfl, Function.iterate_succ_apply', e2]
    rfl
  have e4 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[5] ((0 : ℝ), v50) = (v202, v203) := by
    rewrite [show (5 : ℕ) = 4 + 1 from rfl, Function.iterate_succ_apply', e3]
    rfl
  have e5 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[6] ((0 : ℝ), v50) = (v221, v222) := by
    rewrite [show (6 : ℕ) = 5 + 1 from rfl, Function.iterate_succ_apply', e4]
    rfl
  have e6 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[7] ((0 : ℝ), v50) = (v240, v241) := by
    rewrite [show (7 : ℕ) = 6 + 1 from rfl, Function.iterate_succ_apply', e5]
    rfl
  have e7 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[8] ((0 : ℝ), v50) = (v259, v260) := by
    rewrite [show (8 : ℕ) = 7 + 1 from rfl, Function.iterate_succ_apply', e6]
    rfl
  have e8 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[9] ((0 : ℝ), v50) = (v278, v279) := by
    rewrite [show (9 : ℕ) = 8 + 1 from rfl, Function.iterate_succ_apply', e7]
    rfl
  have e9 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[10] ((0 : ℝ), v50) = (v297, v298) := by
    rewrite [show (10 : ℕ) = 9 + 1 from rfl, Function.iterate_succ_apply', e8]
    rfl
  have e10 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[11] ((0 : ℝ), v50) = (v316, v317) := by
    rewrite [show (11 : ℕ) = 10 + 1 from rfl, Function.iterate_succ_apply', e9]
    rfl
  have e11 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[12] ((0 : ℝ), v50) = (v335, v336) := by
    rewrite [show (12 : ℕ) = 11 + 1 from rfl, Function.iterate_succ_apply', e10]
    rfl
  have e12 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[13] ((0 : ℝ), v50) = (v354, v355) := by
    rewrite [show (13 : ℕ) = 12 + 1 from rfl, Function.iterate_succ_apply', e11]
    rfl
  have e13 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[14] ((0 : ℝ), v50) = (v373, v374) := by
    rewrite [show (14 : ℕ) = 13 + 1 from rfl, Function.iterate_succ_apply', e12]
    rfl
  have e14 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[15] ((0 : ℝ), v50) = (v392, v393) := by
    rewrite [show (15 : ℕ) = 14 + 1 from rfl, Function.iterate_succ_apply', e13]
    rfl
  have e15 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[16] ((0 : ℝ), v50) = (v411, v412) := by
    rewrite [show (16 : ℕ) = 15 + 1 from rfl, Function.iterate_succ_apply', e14]
    rfl
  have e16 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[17] ((0 : ℝ), v50) = (v430, v431) := by
    rewrite [show (17 : ℕ) = 16 + 1 from rfl, Function.iterate_succ_apply', e15]
    rfl
  have e17 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[18] ((0 : ℝ), v50) = (v449, v450) := by
    rewrite [show (18 : ℕ) = 17 + 1 from rfl, Function.iterate_succ_apply', e16]
    rfl
  have e18 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[19] ((0 : ℝ), v50) = (v468, v469) := by
    rewrite [show (19 : ℕ) = 18 + 1 from rfl, Function.iterate_succ_apply', e17]
    rfl
  have e19 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[20] ((0 : ℝ), v50) = (v487, v488) := by
    rewrite [show (20 : ℕ) = 19 + 1 from rfl, Function.iterate_succ_apply', e18]
    rfl
  have e20 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[21] ((0 : ℝ), v50) = (v506, v507) := by
    rewrite [show (21 : ℕ) = 20 + 1 from rfl, Function.iterate_succ_apply', e19]
    rfl
  have e21 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[22] ((0 : ℝ), v50) = (v525, v526) := by
    rewrite [show (22 : ℕ) = 21 + 1 from rfl, Function.iterate_succ_apply', e20]
    rfl
  have e22 : (bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[23] ((0 : ℝ), v50) = (v544, v545) := by
    rewrite [show (23 : ℕ) = 22 + 1 from rfl, Function.iterate_succ_apply', e21]
    rfl
  have key : swingOfLength ymHashemi hpHashemi dishHalf zeHashemi v50 v105 = (((if v562 then v547 else v544) + (if v562 then v545 else v547)) / (2 : ℝ)) := by
    show ((((bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[24] ((0 : ℝ), v50)).1 + (((bisectStep ymHashemi hpHashemi dishHalf zeHashemi v105)^[24] ((0 : ℝ), v50)).2)) / (2 : ℝ)) = _
    rewrite [show (24 : ℕ) = 23 + 1 from rfl, Function.iterate_succ_apply', e22]
    rfl
  rewrite [show deadPoint ymHashemi hpHashemi dishHalf zeHashemi = v50 from rfl]
  rewrite [show wireLen ymHashemi hpHashemi dishHalf zeHashemi 0 = v69 from rfl]
  rewrite [show wireLen ymHashemi hpHashemi dishHalf zeHashemi v50 = v83 from rfl]
  rewrite [show wireLen ymHashemi hpHashemi dishHalf zeHashemi t = v97 from rfl]
  rewrite [show (if v97 + slack - ωd * rDrum * dt < v83 then v83 else if v69 < v97 + slack - ωd * rDrum * dt then v69 else v97 + slack - ωd * rDrum * dt) = v105 from rfl]
  rewrite [key]
  rfl

theorem megaThmsClosed_ccc : megaThmsClosed = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) =>
    let v18 := (Real.sqrt (3.36 : ℝ))
    let v30 := ((5 : ℝ) - ((2 : ℝ) * v18))
    let v31 := (Real.sqrt v30)
    let v39 := ((0.8 : ℝ) ^ 2)
    let v40 := ((2 : ℝ) ^ 2)
    let v43 := ((2 : ℝ) - (Real.sqrt (v40 - v39)))
    let v50 := ((2 : ℝ) / (2 : ℝ))
    let v51 := (v50 - v43)
    let v58 := (v18 - (1 : ℝ))
    let v77 := (Real.sqrt (((0.96 : ℝ) ^ 2) - (((0.62 : ℝ) - (0.175 : ℝ)) ^ 2)))
    let v86 := (((1.30 : ℝ) - v77) / (1.30 : ℝ))
    let v96 := (Real.sqrt (3.2 : ℝ))
    let v101 := (Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * v96)))
    let v103 := (((3.36 : ℝ) - v96) / ((2 : ℝ) * v101))
    let v113 := ((0.34 : ℝ) * (0.8 : ℝ))
    let v114 := (((1.22 : ℝ) * v58) + v113)
    let v115 := ((1.22 : ℝ) * (0.8 : ℝ))
    let v116 := ((0.34 : ℝ) * v58)
    let v118 := (v114 / (v115 - v116))
    let v127 := (((1.2 : ℝ) * v58) + v113)
    let v129 := (((1.2 : ℝ) * (0.8 : ℝ)) - v116)
    let v130 := (v127 / v129)
    let v137 := ((2 : ℝ) * (0.8 : ℝ))
    let v142 := ((1.30 : ℝ) - (0.05 : ℝ))
    let v158 := ((0.4 : ℝ) ^ 2)
    let v170 := (Real.sqrt ((((0 : ℝ) ^ 2) + v158) + ((v50 - ((2 : ℝ) - (Real.sqrt (v40 - ((Real.sqrt (v39 + v158)) ^ 2))))) ^ 2)))
    let v175 := ((1.30 : ℝ) - v31)
    let v191 := (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))
    let v213 := ((1 : ℝ) / v118)
    let v223 := ((Real.sqrt (v39 + (v58 ^ 2))) < (1.22 : ℝ))
    let v233 := ((0.0015 : ℝ) / v137)
    let v246 := ((5 : ℝ) / (12 : ℝ))
    let v257 := ((0.4 : ℝ) / (v96 - (1 : ℝ)))
    let v278 := ((((2 : ℝ) / (360 : ℝ)) * (1.2192 : ℝ)) / (0.05 : ℝ))
    let v289 := (v50 - ((2 : ℝ) - (Real.sqrt (v40 - ((1 : ℝ) ^ 2)))))
    let v312 := (Real.pi / (3 : ℝ))
    let v313 := (Real.sin v312)
    let v315 := (Real.cos v312)
    let v319 := ((0.8 : ℝ) / v58)
    let v336 := ((Real.sqrt (((1.22 : ℝ) ^ 2) + ((0.34 : ℝ) ^ 2))) - v31)
    let v349 := (v114 / (Real.sqrt ((((1.22 : ℝ) - (0.8 : ℝ)) ^ 2) + (((0.34 : ℝ) + v58) ^ 2))))
    let v356 := (-(1.22 : ℝ))
    let v357 := (-(0.8 : ℝ))
    let v358 := (-v58)
    let v361 := ((v357 * v315) + (v358 * v313))
    let v362 := (-v357)
    let v365 := ((v362 * v313) + (v358 * v315))
    let v375 := (((v356 * v365) - ((0.34 : ℝ) * v361)) / (Real.sqrt (((v361 - v356) ^ 2) + ((v365 - (0.34 : ℝ)) ^ 2))))
    let v387 := (v142 - v31)
    let v394 := (Real.cos t)
    let v395 := (Real.sin t)
    let v408 := (v395 * (Real.cos az))
    let v410 := (v395 * (Real.sin az))
    let v411 := (Real.cos elSun)
    let v413 := (v411 * (Real.cos azSun))
    let v415 := (v411 * (Real.sin azSun))
    let v416 := (Real.sin elSun)
    let v421 := (((v408 * v413) + (v410 * v415)) + (v394 * v416))
    let v436 := (Real.sqrt (((((v410 * v416) - (v394 * v415)) ^ 2) + (((v394 * v413) - (v408 * v416)) ^ 2)) + (((v408 * v415) - (v410 * v413)) ^ 2)))
    let v448 := (Real.tan (if (v421 ≤ (0 : ℝ)) then ((Real.pi / (2 : ℝ)) + (Real.arctan ((-v421) / (max v436 (0.000000000001 : ℝ))))) else (Real.arctan (v436 / v421))))
    ![(@ite _ (((1.833 : ℝ) < v18) ∧ (v18 < (1.8331 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.154 : ℝ) < v31) ∧ (v31 < (1.1551 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((Real.sqrt ((((1 : ℝ) - v43) ^ 2) + v39)) = v31) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.833 : ℝ) < v51) ∧ (v51 < (0.8331 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v51 = v58) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.166 : ℝ) < v43) ∧ (v43 < (0.168 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v43 = ((2 : ℝ) - v18)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.85 : ℝ) < v77) ∧ (v77 < (0.851 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v86 < (0.35 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v86 ^ 3) < ((1 : ℝ) / (24 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.888 : ℝ) < v103) ∧ (v103 < (0.889 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.859 : ℝ) < v118) ∧ (v118 < (1.86 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.878 : ℝ) < v130) ∧ (v130 < (1.88 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v137 < (1.84 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((0.8 : ℝ) < v142) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.05 : ℝ) + ((1 : ℝ) * (0.0093 : ℝ))) = (0.0593 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.884 : ℝ) < v101) ∧ (v101 < (0.8846 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v170 = v101) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v101 = v170) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.1449 : ℝ) < v175) ∧ (v175 < (0.146 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.010 : ℝ) / (2 : ℝ)) < (0.010 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v191 = v191) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((0.00175 : ℝ) * (((62 : ℝ) * Real.pi) / (180 : ℝ))) / ((2 : ℝ) * Real.pi)) < (0.00031 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((0.02 : ℝ) < ((1.25 : ℝ) * (Real.sin (Real.pi / (180 : ℝ))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.537 : ℝ) < v213) ∧ (v213 < (0.538 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ v223 (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v191 < ((0.80 : ℝ) + (1.22 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((1.17 : ℝ) < (v115 / v58)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v233 < (0.001 : ℝ)) ∧ ((((4 : ℝ) * v233) < (0.00465 : ℝ)) ∧ (((1 : ℝ) * v233) < (0.001 : ℝ)))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v246 < (0.5 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.59 : ℝ) - v142) = (0.34 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v142 = (1.25 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.507 : ℝ) < v257) ∧ (v257 < (0.5072 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v191 = (Real.sqrt (1.4864 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.219 : ℝ) < v191) ∧ (v191 < (1.2195 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.13 : ℝ) < v278) ∧ (v278 < (0.14 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v289 = ((Real.sqrt (3 : ℝ)) - (1 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.732 : ℝ) < v289) ∧ (v289 < (0.7321 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((0.0005 : ℝ) < ((0.01 : ℝ) * (0.06 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((1.84 : ℝ) - v137) / (2 : ℝ)) = (0.12 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v313 * v129) < (v315 * v127)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.960 : ℝ) < v319) ∧ (v319 < (0.9605 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.7888 : ℝ) < v96) ∧ (v96 < (1.78886 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.111 : ℝ) < v336) ∧ (v336 < (0.113 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1.033 : ℝ) < v349) ∧ (v349 < (1.035 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0.37 : ℝ) < v375) ∧ (v375 < (0.38 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v116 - v115) < (0 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((1.22 : ℝ) = (1.22 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((0.1449 : ℝ) - (0.05 : ℝ)) < v387) ∧ (v387 < ((0.146 : ℝ) - (0.05 : ℝ)))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((((v357 * v394) + (v358 * v395)) ^ 2) + (((v362 * v395) + (v358 * v394)) ^ 2)) = v30) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((1 : ℝ) * v448) ≤ (0.03 : ℝ)) ↔ (v448 ≤ (0.03 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v223 ↔ (v31 < (1.22 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0 : ℝ) ≤ (0.0005 : ℝ)) → (((0.0005 : ℝ) ≤ (0.0005 : ℝ)) → (((1.30 : ℝ) * (Real.sin (0.0005 : ℝ))) ≤ (0.00065 : ℝ)))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((4 : ℝ) ≤ (4 : ℝ)) → (((0 : ℝ) ≤ v246) → ((v246 ≤ (1 : ℝ)) → (((((0.0000000172 : ℝ) * ((2 : ℝ) * (4 : ℝ))) * v246) / (0.0000015 : ℝ)) < (0.1 : ℝ))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((10 : ℝ) ^ 6) ≤ L10) → (((100 : ℝ) * ((20 : ℝ) * (365.25 : ℝ))) < L10)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((W ≤ (1000 : ℝ)) → ((((W / (2 : ℝ)) * (0.03 : ℝ)) / ((Real.pi * ((0.0101 : ℝ) ^ 3)) / (32 : ℝ))) < (16e7 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))] := rfl

theorem megaThmsState_ccc : megaThmsState = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (elSun : ℝ) (azSun : ℝ) (dni : ℝ) (rDrum : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) (rho : ℝ) (Fdrive : ℝ) (L10 : ℝ) (rodLen : ℝ) =>
    let v22 := ((0.8 : ℝ) ^ 2)
    let v25 := ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - v22)))
    let v27 := ((1 : ℝ) - v25)
    let v28 := (-(1.22 : ℝ))
    let v29 := (-(0.8 : ℝ))
    let v30 := (Real.cos t)
    let v32 := (-v27)
    let v33 := (Real.sin t)
    let v34 := (v32 * v33)
    let v35 := ((v29 * v30) + v34)
    let v36 := (-v29)
    let v39 := ((v36 * v33) + (v32 * v30))
    let v42 := ((v28 * v39) - ((0.34 : ℝ) * v35))
    let v47 := (((v35 - v28) ^ 2) + ((v39 - (0.34 : ℝ)) ^ 2))
    let v48 := (Real.sqrt v47)
    let v49 := (v42 / v48)
    let v51 := ((ωd * rDrum) / v49)
    let v52 := (Real.cos az)
    let v53 := (v33 * v52)
    let v54 := (Real.sin az)
    let v55 := (v33 * v54)
    let v56 := (Real.cos elSun)
    let v58 := (v56 * (Real.cos azSun))
    let v60 := (v56 * (Real.sin azSun))
    let v61 := (Real.sin elSun)
    let v66 := (((v53 * v58) + (v55 * v60)) + (v30 * v61))
    let v81 := (Real.sqrt (((((v55 * v61) - (v30 * v60)) ^ 2) + (((v30 * v58) - (v53 * v61)) ^ 2)) + (((v53 * v60) - (v55 * v58)) ^ 2)))
    let v85 := (Real.pi / (2 : ℝ))
    let v95 := (v85 - t)
    let v102 := ((1.84 : ℝ) / (2 : ℝ))
    let v104 := ((0.80 : ℝ) ^ 2)
    let v105 := ((v102 ^ 2) + v104)
    let v106 := (Real.sqrt v105)
    let v117 := (((0.55 : ℝ) + (1.30 : ℝ)) - (0.05 : ℝ))
    let v119 := (v102 - (0.03 : ℝ))
    let v120 := ((0 : ℝ) * (0 : ℝ))
    let v121 := (v117 * (0 : ℝ))
    let v122 := (v120 - v121)
    let v123 := (v117 * (1 : ℝ))
    let v124 := ((0.80 : ℝ) * (0 : ℝ))
    let v125 := (v123 - v124)
    let v126 := ((0 : ℝ) * (1 : ℝ))
    let v127 := (v124 - v126)
    let v130 := ((0.00175 : ℝ) / ((2 : ℝ) * Real.pi))
    let v131 := (W * rcm)
    let v132 := (v131 * v33)
    let v133 := (v132 / v49)
    let v134 := ((0.80 : ℝ) - v35)
    let v135 := (v117 + v39)
    let v139 := ((v133 * (-(v28 - v35))) / v48)
    let v142 := ((v133 * ((0.34 : ℝ) - v39)) / v48)
    let v143 := (v102 - (0 : ℝ))
    let v144 := ((1 : ℝ) * v143)
    let v147 := ((0.80 : ℝ) + (1.22 : ℝ))
    let v149 := (-(0.0005 : ℝ))
    let v152 := ((0 : ℝ) < v106)
    let v162 := (-((Fdrive * v102) / v106))
    let v164 := ((Fdrive * (0.80 : ℝ)) / v106)
    let v165 := (v102 * (0 : ℝ))
    let v182 := (((((((0 : ℝ) * (v165 - ((0.55 : ℝ) * v164))) + ((0 : ℝ) * (((0.55 : ℝ) * v162) - v124))) + ((1 : ℝ) * (((0.80 : ℝ) * v164) - (v102 * v162)))) + ((0 : ℝ) * v162)) + ((0 : ℝ) * v164)) + v120)
    let v192 := (((1.22 : ℝ) * v27) + ((0.34 : ℝ) * (0.8 : ℝ)))
    let v194 := ((0.34 : ℝ) * v27)
    let v195 := ((1.22 : ℝ) * (0.8 : ℝ))
    let v198 := ((v192 * v30) + ((v194 - v195) * v33))
    let v204 := (v27 ^ 2)
    let v205 := (v22 + v204)
    let v212 := (Real.sin (0 : ℝ))
    let v214 := (Real.cos (0 : ℝ))
    let v236 := (v33 * (v195 - v194))
    let v237 := (v30 * v192)
    let v242 := ((0 : ℝ) < v47)
    let v243 := ((0 : ℝ) < v49)
    let v251 := (v132 * v51)
    let v255 := ((0 : ℝ) ≤ W)
    let v256 := ((0 : ℝ) ≤ rcm)
    let v257 := ((0 : ℝ) ≤ v51)
    let v275 := ((0 : ℝ) = (0 : ℝ))
    let v281 := (((0.55 : ℝ) * (0.80 : ℝ)) - v124)
    let v282 := (-v102)
    let v283 := (v282 * (0 : ℝ))
    let v284 := ((0 : ℝ) + (0 : ℝ))
    let v285 := ((2 : ℝ) * (0.80 : ℝ))
    let v286 := ((0.62 : ℝ) * (0 : ℝ))
    let v287 := (v285 * (0 : ℝ))
    let v288 := ((0.55 : ℝ) - (0.62 : ℝ))
    let v289 := ((0.55 : ℝ) * (0 : ℝ))
    let v291 := (v289 - ((0.80 : ℝ) * (1 : ℝ)))
    let v292 := ((2 : ℝ) * (0 : ℝ))
    let v294 := (v288 * (v284 - v292))
    let v306 := ((2 : ℝ) * (1 : ℝ))
    let v312 := (v165 - ((0.55 : ℝ) * v102))
    let v314 := (v283 - ((0.55 : ℝ) * v282))
    let v320 := ((v102 * (1 : ℝ)) - v289)
    let v322 := ((v282 * (1 : ℝ)) - v289)
    let v331 := ((0.62 : ℝ) * (1 : ℝ))
    let v344 := (((0.80 : ℝ) * v102) - (v102 * (0.80 : ℝ)))
    let v347 := (((0.80 : ℝ) * v282) - (v282 * (0.80 : ℝ)))
    let v352 := (v124 - v165)
    let v353 := (v124 - v283)
    let v367 := ((0 : ℝ) - (0 : ℝ))
    let v368 := ((1.84 : ℝ) * (0 : ℝ))
    let v369 := ((0.62 : ℝ) - (0.55 : ℝ))
    let v370 := (v369 * v367)
    let v381 := ((1 : ℝ) - (1 : ℝ))
    let v415 := (v119 * (0 : ℝ))
    let v416 := (v119 * (1 : ℝ))
    let v417 := (v125 * (0 : ℝ))
    let v418 := (v127 * (0 : ℝ))
    let v419 := (v122 * (0 : ℝ))
    let v420 := ((1 : ℝ) * (0 : ℝ))
    let v421 := ((1 : ℝ) * v122)
    let v440 := ((((1 : ℝ) * (v120 - v123)) + ((0 : ℝ) * (v121 - v415))) + ((0 : ℝ) * (v416 - v120)))
    let v453 := ((((1 : ℝ) * (v126 - v121)) + ((0 : ℝ) * (v121 - v416))) + ((0 : ℝ) * (v415 - v120)))
    let v460 := ((v420 + v126) + v120)
    let v466 := ((v420 + v120) + v126)
    let v474 := (((((((v421 + ((0 : ℝ) * (v123 - v415))) + ((0 : ℝ) * (v415 - v126))) + (v122 * (1 : ℝ))) + v417) + v418) = (0 : ℝ)) ∧ (((((v440 + v419) + (v125 * (1 : ℝ))) + v418) = (0 : ℝ)) ∧ (((((v453 + v419) + v417) + (v127 * (1 : ℝ))) = (0 : ℝ)) ∧ (((((v460 + v419) + v417) + v418) = (0 : ℝ)) ∧ ((((v466 + v419) + v417) + v418) = (0 : ℝ))))))
    let v476 := ((1 : ℝ) * v117)
    let v487 := ((0 : ℝ) = v420)
    let v500 := (v28 * (0.34 : ℝ))
    let v502 := (v28 - (0.01 : ℝ))
    let v503 := (v502 < v28)
    let v504 := (v28 + (0.01 : ℝ))
    let v505 := (v28 < v504)
    let v506 := (v504 ≤ (0 : ℝ))
    let v507 := ((0.34 : ℝ) - (0.01 : ℝ))
    let v509 := ((0.34 : ℝ) + (0.01 : ℝ))
    let v524 := ((0.8 : ℝ) * v27)
    let v525 := ((0.8 : ℝ) - (0.01 : ℝ))
    let v527 := ((0.8 : ℝ) + (0.01 : ℝ))
    let v530 := (v27 - (0.01 : ℝ))
    let v532 := (v27 + (0.01 : ℝ))
    let v547 := (Real.tan (if (v66 ≤ (0 : ℝ)) then (v85 + (Real.arctan ((-v66) / (max v81 (0.000000000001 : ℝ))))) else (Real.arctan (v81 / v66))))
    let v548 := ((1 : ℝ) * v547)
    let v550 := ((v306 * slack) / v49)
    let v557 := ((1 : ℝ) ^ 2)
    let v561 := (v106 ^ 2)
    let v575 := ((0 : ℝ) < v27)
    let v583 := ((0.8 : ℝ) * v30)
    let v617 := (v130 * (0 : ℝ))
    let v657 := (v28 ^ 2)
    let v685 := (-t)
    let v686 := (Real.sin v685)
    let v687 := (Real.cos v685)
    let v689 := ((0 : ℝ) + ((1 : ℝ) * v686))
    let v690 := (-v686)
    let v695 := ((1 : ℝ) * v687)
    let v696 := ((0 : ℝ) - v695)
    let v716 := ((0 : ℝ) * (0.80 : ℝ))
    let v775 := ((v29 * v214) + (v32 * v212))
    let v778 := ((v36 * v212) + (v32 * v214))
    let v798 := ((0 : ℝ) * v142)
    ![(@ite _ (((0 : ℝ) < ωm) → (((0 : ℝ) < (0.05 : ℝ)) → (v152 → ((0 : ℝ) < ((ωm * (0.05 : ℝ)) / v106))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v182 = (Fdrive * v106)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((Fdrive ≠ (0 : ℝ)) → (v182 ≠ (0 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v42 = v198) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v35 ^ 2) + (v39 ^ 2)) = v205) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (|v35| ≤ (Real.sqrt v205)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v27 * v212) + ((0.8 : ℝ) * v214)) = (0.8 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v27 * (Real.sin v95)) + ((0.8 : ℝ) * (Real.cos v95))) ≤ (Real.sqrt (v204 + v22))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v27 * (Real.sin v85)) + ((0.8 : ℝ) * (Real.cos v85))) = v27) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v236 = v237) → (v42 = (0 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v242 → (v243 ↔ (v236 < v237))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v49 ≠ (0 : ℝ)) → ((v133 * (v49 * v51)) = v251)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v255 → (v256 → (v257 → (v251 ≤ (v131 * v51))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v52 ≠ (1 : ℝ)) → (((((v52 * (0.80 : ℝ)) - (v54 * (0 : ℝ))) = (0.80 : ℝ)) ∧ (((v54 * (0.80 : ℝ)) + (v52 * (0 : ℝ))) = (0 : ℝ))) → (((0.80 : ℝ) = (0 : ℝ)) ∧ v275))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((((0.80 : ℝ) + (0.80 : ℝ)) - (v285 * (1 : ℝ))) + v294) = (0 : ℝ)) ∧ (((((v102 + v282) - v287) + v294) = (0 : ℝ)) ∧ ((((v284 - v287) + (v288 * (((1 : ℝ) + (1 : ℝ)) - v306))) = (0 : ℝ)) ∧ (((((v312 + v314) - (v285 * (v120 - v286))) + (v288 * ((v320 + v322) - ((2 : ℝ) * (v126 - v286))))) = (0 : ℝ)) ∧ (((((v281 + v281) - (v285 * (v331 - v120))) + (v288 * ((v291 + v291) - ((2 : ℝ) * (v286 - v126))))) = (0 : ℝ)) ∧ ((((v344 + v347) - (v285 * (v120 - v126))) + (v288 * ((v352 + v353) - ((2 : ℝ) * (v120 - v120))))) = (0 : ℝ))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((((0.80 : ℝ) - (0.80 : ℝ)) - v368) - v370) = (0 : ℝ)) ∧ (((((v102 - v282) - ((1.84 : ℝ) * (1 : ℝ))) - v370) = (0 : ℝ)) ∧ ((((v367 - v368) - (v369 * v381)) = (0 : ℝ)) ∧ (((((v312 - v314) - ((1.84 : ℝ) * (v120 - v331))) - (v369 * (v320 - v322))) = (0 : ℝ)) ∧ (((((v281 - v281) - ((1.84 : ℝ) * (v286 - v120))) - (v369 * (v291 - v291))) = (0 : ℝ)) ∧ ((((v344 - v347) - ((1.84 : ℝ) * (v126 - v120))) - (v369 * (v352 - v353))) = (0 : ℝ))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v474 → (v275 ∧ (v275 ∧ ((v122 = (0 : ℝ)) ∧ ((v125 = v476) ∧ (v127 = (0 : ℝ))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v474 → (((1 : ℝ) = ((1 : ℝ) * (1 : ℝ))) ∧ (v487 ∧ (v487 ∧ ((v122 = v421) ∧ ((v125 = ((1 : ℝ) * v125)) ∧ (v127 = ((1 : ℝ) * v127)))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v503 → (v505 → (v506 → ((v507 < (0.34 : ℝ)) → (((0.34 : ℝ) < v509) → (((0 : ℝ) ≤ v507) → (((v502 * v509) < v500) ∧ (v500 < (v504 * v507))))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v525 < (0.8 : ℝ)) → (((0.8 : ℝ) < v527) → (((0 : ℝ) ≤ v525) → ((v530 < v27) → ((v27 < v532) → (((0 : ℝ) ≤ v530) → (((v525 * v530) < v524) ∧ (v524 < (v527 * v532))))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v548 ≤ ((0.03 : ℝ) - v550)) → ((v548 + v550) ≤ (0.03 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v557 = (1 : ℝ)) → ((v104 + (v144 ^ 2)) = v561)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v144 - ((-(1 : ℝ)) * v143)) = ((1.84 : ℝ) - v292)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((1.30 : ℝ) = (1.30 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((0.80 : ℝ) = (0.80 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v575 → ((v195 ≤ v194) ↔ ((v195 / v27) ≤ (0.34 : ℝ)))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v575 → (((0 : ℝ) < v30) → (((v583 + v34) = (0 : ℝ)) ↔ ((Real.tan t) = ((0.8 : ℝ) / v27))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ v152 (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v561 = v105) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((2 : ℝ) / (2 : ℝ)) - v25) = (((2 : ℝ) - ((2 : ℝ) / ((2 : ℝ) * (Real.cos (Real.arcsin ((0 : ℝ) / (2 : ℝ))))))) - v25)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((1 : ℝ) = (1 : ℝ)) ∧ (v275 ∧ (v275 ∧ (((0 : ℝ) = v122) ∧ ((v117 = v125) ∧ ((0 : ℝ) = v127)))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((((v440 + v617) + v123) + v120) = (0 : ℝ)) ∧ (((((v453 + v617) + v121) + v126) = (0 : ℝ)) ∧ (((((v460 + v617) + v121) + v120) = (0 : ℝ)) ∧ (((((v466 + v617) + v121) + v120) = (0 : ℝ)) ∧ ((((((((1 : ℝ) * (-v130)) + ((0 : ℝ) * v117)) + v120) + (v130 * (1 : ℝ))) + v121) + v120) = (0 : ℝ)))))) → (v275 ∧ (v275 ∧ ((v130 = ((1 : ℝ) * v130)) ∧ ((v117 = v476) ∧ v275))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v548 ≤ ((0.03 : ℝ) - v550)) → ((v548 + v550) ≤ (0.03 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((v548 ≤ ((0.03 : ℝ) - v550)) → ((v548 + v550) ≤ (0.03 : ℝ))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v503 → (v505 → (v506 → (((v504 ^ 2) < v657) ∧ (v657 < (v502 ^ 2)))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0 : ℝ) < (0.0005 : ℝ)) → ((v147 < (0.80 : ℝ)) → ((v149 = v149) → (v275 → (v275 → ((((((0.80 : ℝ) - v147) * v149) + ((v144 - (0 : ℝ)) * (0 : ℝ))) + (((1.30 : ℝ) - (0 : ℝ)) * (0 : ℝ))) < (0 : ℝ))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((((v689 + ((1 : ℝ) * v690)) - (0 : ℝ)) ^ 2) + (((v696 + v695) - (0 : ℝ)) ^ 2)) = (v381 ^ 2)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v690 ^ 2) + (v687 ^ 2)) = (1 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((v689 - (0 : ℝ)) ^ 2) + ((v696 - (0 : ℝ)) ^ 2)) = v557) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v420 - v716) + v127) = (0 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v255 → (v256 → (v243 → ((v131 ≤ (Tmax * v49)) → (v133 ≤ Tmax))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0 : ℝ) < (1 : ℝ)) → ((v548 ≤ (0.03 : ℝ)) ↔ (v547 ≤ ((0.03 : ℝ) / (1 : ℝ))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v255 → ((W ≤ (1000 : ℝ)) → (v256 → ((rcm ≤ (1 : ℝ)) → (v257 → ((v51 ≤ (0.000073 : ℝ)) → ((v251 ≤ (0.073 : ℝ)) ∧ ((0.073 : ℝ) < ((0.015 : ℝ) * (5 : ℝ)))))))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v49 = (v198 / (Real.sqrt (((((1.22 : ℝ) - v583) - (v27 * v33)) ^ 2) + (((((0.8 : ℝ) * v33) - (v27 * v30)) - (0.34 : ℝ)) ^ 2))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (v242 → (v243 ↔ ((0 : ℝ) < v42))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((v28 * v778) - ((0.34 : ℝ) * v775)) / (Real.sqrt (((v775 - v28) ^ 2) + ((v778 - (0.34 : ℝ)) ^ 2)))) = (v192 / (Real.sqrt ((((1.22 : ℝ) - (0.8 : ℝ)) ^ 2) + (((0.34 : ℝ) + v27) ^ 2))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((((((1 : ℝ) * (v798 - (v135 * (0 : ℝ)))) + ((0 : ℝ) * ((v135 * v139) - (v134 * v142)))) + ((0 : ℝ) * ((v134 * (0 : ℝ)) - ((0 : ℝ) * v139)))) + (v122 * v139)) + v417) + (v127 * v142)) = (v798 - ((v135 - v117) * (0 : ℝ)))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((0 : ℝ) < W) → (((0 : ℝ) < rcm) → (v243 → (((0 : ℝ) ≤ v133) ↔ ((0 : ℝ) ≤ v33))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ (((v120 - v716) + (0 : ℝ)) = (0 : ℝ)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ)), (@ite _ ((((10 : ℝ) ^ 6) ≤ L10) → (((100 : ℝ) * ((20 : ℝ) * (365.25 : ℝ))) < L10)) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))] := rfl

theorem mlpPolicy_ccc : mlpPolicy = fun (W1 : Fin 16 → Fin 11 → ℝ) (b1 : Fin 16 → ℝ) (W2 : Fin 3 → Fin 16 → ℝ) (b2 : Fin 3 → ℝ) (o : Fin 11 → ℝ) =>
    let v278 := (Real.tanh ((((W1 0 0) * (o 0)) + (((W1 0 1) * (o 1)) + (((W1 0 2) * (o 2)) + (((W1 0 3) * (o 3)) + (((W1 0 4) * (o 4)) + (((W1 0 5) * (o 5)) + (((W1 0 6) * (o 6)) + (((W1 0 7) * (o 7)) + (((W1 0 8) * (o 8)) + (((W1 0 9) * (o 9)) + (((W1 0 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 0)))
    let v302 := (Real.tanh ((((W1 1 0) * (o 0)) + (((W1 1 1) * (o 1)) + (((W1 1 2) * (o 2)) + (((W1 1 3) * (o 3)) + (((W1 1 4) * (o 4)) + (((W1 1 5) * (o 5)) + (((W1 1 6) * (o 6)) + (((W1 1 7) * (o 7)) + (((W1 1 8) * (o 8)) + (((W1 1 9) * (o 9)) + (((W1 1 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 1)))
    let v326 := (Real.tanh ((((W1 2 0) * (o 0)) + (((W1 2 1) * (o 1)) + (((W1 2 2) * (o 2)) + (((W1 2 3) * (o 3)) + (((W1 2 4) * (o 4)) + (((W1 2 5) * (o 5)) + (((W1 2 6) * (o 6)) + (((W1 2 7) * (o 7)) + (((W1 2 8) * (o 8)) + (((W1 2 9) * (o 9)) + (((W1 2 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 2)))
    let v350 := (Real.tanh ((((W1 3 0) * (o 0)) + (((W1 3 1) * (o 1)) + (((W1 3 2) * (o 2)) + (((W1 3 3) * (o 3)) + (((W1 3 4) * (o 4)) + (((W1 3 5) * (o 5)) + (((W1 3 6) * (o 6)) + (((W1 3 7) * (o 7)) + (((W1 3 8) * (o 8)) + (((W1 3 9) * (o 9)) + (((W1 3 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 3)))
    let v374 := (Real.tanh ((((W1 4 0) * (o 0)) + (((W1 4 1) * (o 1)) + (((W1 4 2) * (o 2)) + (((W1 4 3) * (o 3)) + (((W1 4 4) * (o 4)) + (((W1 4 5) * (o 5)) + (((W1 4 6) * (o 6)) + (((W1 4 7) * (o 7)) + (((W1 4 8) * (o 8)) + (((W1 4 9) * (o 9)) + (((W1 4 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 4)))
    let v398 := (Real.tanh ((((W1 5 0) * (o 0)) + (((W1 5 1) * (o 1)) + (((W1 5 2) * (o 2)) + (((W1 5 3) * (o 3)) + (((W1 5 4) * (o 4)) + (((W1 5 5) * (o 5)) + (((W1 5 6) * (o 6)) + (((W1 5 7) * (o 7)) + (((W1 5 8) * (o 8)) + (((W1 5 9) * (o 9)) + (((W1 5 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 5)))
    let v422 := (Real.tanh ((((W1 6 0) * (o 0)) + (((W1 6 1) * (o 1)) + (((W1 6 2) * (o 2)) + (((W1 6 3) * (o 3)) + (((W1 6 4) * (o 4)) + (((W1 6 5) * (o 5)) + (((W1 6 6) * (o 6)) + (((W1 6 7) * (o 7)) + (((W1 6 8) * (o 8)) + (((W1 6 9) * (o 9)) + (((W1 6 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 6)))
    let v446 := (Real.tanh ((((W1 7 0) * (o 0)) + (((W1 7 1) * (o 1)) + (((W1 7 2) * (o 2)) + (((W1 7 3) * (o 3)) + (((W1 7 4) * (o 4)) + (((W1 7 5) * (o 5)) + (((W1 7 6) * (o 6)) + (((W1 7 7) * (o 7)) + (((W1 7 8) * (o 8)) + (((W1 7 9) * (o 9)) + (((W1 7 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 7)))
    let v470 := (Real.tanh ((((W1 8 0) * (o 0)) + (((W1 8 1) * (o 1)) + (((W1 8 2) * (o 2)) + (((W1 8 3) * (o 3)) + (((W1 8 4) * (o 4)) + (((W1 8 5) * (o 5)) + (((W1 8 6) * (o 6)) + (((W1 8 7) * (o 7)) + (((W1 8 8) * (o 8)) + (((W1 8 9) * (o 9)) + (((W1 8 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 8)))
    let v494 := (Real.tanh ((((W1 9 0) * (o 0)) + (((W1 9 1) * (o 1)) + (((W1 9 2) * (o 2)) + (((W1 9 3) * (o 3)) + (((W1 9 4) * (o 4)) + (((W1 9 5) * (o 5)) + (((W1 9 6) * (o 6)) + (((W1 9 7) * (o 7)) + (((W1 9 8) * (o 8)) + (((W1 9 9) * (o 9)) + (((W1 9 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 9)))
    let v518 := (Real.tanh ((((W1 10 0) * (o 0)) + (((W1 10 1) * (o 1)) + (((W1 10 2) * (o 2)) + (((W1 10 3) * (o 3)) + (((W1 10 4) * (o 4)) + (((W1 10 5) * (o 5)) + (((W1 10 6) * (o 6)) + (((W1 10 7) * (o 7)) + (((W1 10 8) * (o 8)) + (((W1 10 9) * (o 9)) + (((W1 10 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 10)))
    let v542 := (Real.tanh ((((W1 11 0) * (o 0)) + (((W1 11 1) * (o 1)) + (((W1 11 2) * (o 2)) + (((W1 11 3) * (o 3)) + (((W1 11 4) * (o 4)) + (((W1 11 5) * (o 5)) + (((W1 11 6) * (o 6)) + (((W1 11 7) * (o 7)) + (((W1 11 8) * (o 8)) + (((W1 11 9) * (o 9)) + (((W1 11 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 11)))
    let v566 := (Real.tanh ((((W1 12 0) * (o 0)) + (((W1 12 1) * (o 1)) + (((W1 12 2) * (o 2)) + (((W1 12 3) * (o 3)) + (((W1 12 4) * (o 4)) + (((W1 12 5) * (o 5)) + (((W1 12 6) * (o 6)) + (((W1 12 7) * (o 7)) + (((W1 12 8) * (o 8)) + (((W1 12 9) * (o 9)) + (((W1 12 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 12)))
    let v590 := (Real.tanh ((((W1 13 0) * (o 0)) + (((W1 13 1) * (o 1)) + (((W1 13 2) * (o 2)) + (((W1 13 3) * (o 3)) + (((W1 13 4) * (o 4)) + (((W1 13 5) * (o 5)) + (((W1 13 6) * (o 6)) + (((W1 13 7) * (o 7)) + (((W1 13 8) * (o 8)) + (((W1 13 9) * (o 9)) + (((W1 13 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 13)))
    let v614 := (Real.tanh ((((W1 14 0) * (o 0)) + (((W1 14 1) * (o 1)) + (((W1 14 2) * (o 2)) + (((W1 14 3) * (o 3)) + (((W1 14 4) * (o 4)) + (((W1 14 5) * (o 5)) + (((W1 14 6) * (o 6)) + (((W1 14 7) * (o 7)) + (((W1 14 8) * (o 8)) + (((W1 14 9) * (o 9)) + (((W1 14 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 14)))
    let v638 := (Real.tanh ((((W1 15 0) * (o 0)) + (((W1 15 1) * (o 1)) + (((W1 15 2) * (o 2)) + (((W1 15 3) * (o 3)) + (((W1 15 4) * (o 4)) + (((W1 15 5) * (o 5)) + (((W1 15 6) * (o 6)) + (((W1 15 7) * (o 7)) + (((W1 15 8) * (o 8)) + (((W1 15 9) * (o 9)) + (((W1 15 10) * (o 10)) + (0 : ℝ)))))))))))) + (b1 15)))
    ![(Real.tanh ((((W2 0 0) * v278) + (((W2 0 1) * v302) + (((W2 0 2) * v326) + (((W2 0 3) * v350) + (((W2 0 4) * v374) + (((W2 0 5) * v398) + (((W2 0 6) * v422) + (((W2 0 7) * v446) + (((W2 0 8) * v470) + (((W2 0 9) * v494) + (((W2 0 10) * v518) + (((W2 0 11) * v542) + (((W2 0 12) * v566) + (((W2 0 13) * v590) + (((W2 0 14) * v614) + (((W2 0 15) * v638) + (0 : ℝ))))))))))))))))) + (b2 0))), (Real.tanh ((((W2 1 0) * v278) + (((W2 1 1) * v302) + (((W2 1 2) * v326) + (((W2 1 3) * v350) + (((W2 1 4) * v374) + (((W2 1 5) * v398) + (((W2 1 6) * v422) + (((W2 1 7) * v446) + (((W2 1 8) * v470) + (((W2 1 9) * v494) + (((W2 1 10) * v518) + (((W2 1 11) * v542) + (((W2 1 12) * v566) + (((W2 1 13) * v590) + (((W2 1 14) * v614) + (((W2 1 15) * v638) + (0 : ℝ))))))))))))))))) + (b2 1))), (Real.tanh ((((W2 2 0) * v278) + (((W2 2 1) * v302) + (((W2 2 2) * v326) + (((W2 2 3) * v350) + (((W2 2 4) * v374) + (((W2 2 5) * v398) + (((W2 2 6) * v422) + (((W2 2 7) * v446) + (((W2 2 8) * v470) + (((W2 2 9) * v494) + (((W2 2 10) * v518) + (((W2 2 11) * v542) + (((W2 2 12) * v566) + (((W2 2 13) * v590) + (((W2 2 14) * v614) + (((W2 2 15) * v638) + (0 : ℝ))))))))))))))))) + (b2 2)))] := by
  funext W1 b1 W2 b2 o k
  fin_cases k <;> rfl

theorem ntuOf_ccc : ntuOf = fun (UA : ℝ) (mcp : ℝ) =>
    (UA / (max mcp (0.000001 : ℝ))) := rfl

theorem nusseltLam_ccc : nusseltLam =
    (4.364 : ℝ) := rfl

theorem nusseltOf_ccc : nusseltOf = fun (Q : ℝ) (D : ℝ) (T : ℝ) =>
    let v4 := (T - (273.15 : ℝ))
    let v10 := (v4 ^ 2)
    let v29 := ((Real.exp (((586.375 : ℝ) / (v4 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ))
    let v30 := ((((((1020.62 : ℝ) - ((0.614254 : ℝ) * v4)) - ((0.000321 : ℝ) * v10)) * (Q / ((Real.pi * (D ^ 2)) / (4 : ℝ)))) * D) / v29)
    (if (v30 < (2300 : ℝ)) then (4.364 : ℝ) else (((0.023 : ℝ) * (Real.exp ((0.8 : ℝ) * (Real.log (max v30 (1 : ℝ)))))) * (Real.exp ((0.4 : ℝ) * (Real.log (max ((v29 * ((1000 : ℝ) * (((1.496005 : ℝ) + ((0.003313 : ℝ) * v4)) + ((0.0000008970757 : ℝ) * v10)))) / (((0.118294 : ℝ) - ((0.000033 : ℝ) * v4)) - ((0.00000015 : ℝ) * v10))) (0.01 : ℝ))))))) := rfl

theorem nusseltTurb_ccc : nusseltTurb = fun (Re : ℝ) (Pr : ℝ) =>
    (((0.023 : ℝ) * (Real.exp ((0.8 : ℝ) * (Real.log (max Re (1 : ℝ)))))) * (Real.exp ((0.4 : ℝ) * (Real.log (max Pr (0.01 : ℝ)))))) := rfl

theorem obsHi_ccc : obsHi =
    ![Real.pi, (Real.pi / (2 : ℝ)), (Real.pi / (2 : ℝ)), (1 : ℝ), (1 : ℝ), ((318.15 : ℝ) / (300 : ℝ)), (1 : ℝ), (1 : ℝ), (1.2 : ℝ), (1 : ℝ), (1 : ℝ)] := rfl

theorem obsLo_ccc : obsLo =
    ![(-Real.pi), ((-Real.pi) / (2 : ℝ)), (0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (-(2 : ℝ)), (0 : ℝ), (0 : ℝ)] := rfl

theorem obsOf_ccc : obsOf = fun (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) (taut : ℝ) (holds : ℝ) (Toil : ℝ) (tDead : ℝ) (margin : ℝ) (flow : ℝ) (deg : ℝ) =>
    let v11 := (azSun - az)
    let v14 := ((2 : ℝ) * Real.pi)
    let v20 := (Real.pi / (2 : ℝ))
    let v31 := (Real.sin t)
    let v33 := (v31 * (Real.cos az))
    let v35 := (v31 * (Real.sin az))
    let v36 := (Real.cos t)
    let v37 := (Real.cos elSun)
    let v39 := (v37 * (Real.cos azSun))
    let v41 := (v37 * (Real.sin azSun))
    let v42 := (Real.sin elSun)
    let v47 := (((v33 * v39) + (v35 * v41)) + (v36 * v42))
    let v62 := (Real.sqrt (((((v35 * v42) - (v36 * v41)) ^ 2) + (((v36 * v39) - (v33 * v42)) ^ 2)) + (((v33 * v41) - (v35 * v39)) ^ 2)))
    ![(v11 - (v14 * ((⌊((v11 + Real.pi) / v14)⌋ : ℤ) : ℝ))), ((v20 - t) - elSun), t, taut, holds, ((Toil - (300 : ℝ)) / (300 : ℝ)), (Real.sigmoid ((elSun - (v20 - tDead)) / (0.01 : ℝ))), ((Real.sigmoid ((elSun - (v20 - tDead)) / (0.01 : ℝ))) * (Real.sigmoid (((if (v47 ≤ (0 : ℝ)) then (v20 + (Real.arctan ((-v47) / (max v62 (0.000000000001 : ℝ))))) else (Real.arctan (v62 / v47))) - (0.03 : ℝ)) / (0.01 : ℝ)))), margin, flow, deg] := rfl

theorem oilBulkMax_ccc : oilBulkMax =
    (618.15 : ℝ) := rfl

theorem oilCp_ccc : oilCp = fun (T : ℝ) =>
    let v2 := (T - (273.15 : ℝ))
    ((1000 : ℝ) * (((1.496005 : ℝ) + ((0.003313 : ℝ) * v2)) + ((0.0000008970757 : ℝ) * (v2 ^ 2)))) := rfl

theorem oilFilmMax_ccc : oilFilmMax =
    (648.15 : ℝ) := rfl

theorem oilK_ccc : oilK = fun (T : ℝ) =>
    let v2 := (T - (273.15 : ℝ))
    (((0.118294 : ℝ) - ((0.000033 : ℝ) * v2)) - ((0.00000015 : ℝ) * (v2 ^ 2))) := rfl

theorem oilMu_ccc : oilMu = fun (T : ℝ) =>
    ((Real.exp (((586.375 : ℝ) / ((T - (273.15 : ℝ)) + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ)) := rfl

theorem oilPourPoint_ccc : oilPourPoint =
    (248.15 : ℝ) := rfl

theorem oilRho_ccc : oilRho = fun (T : ℝ) =>
    let v2 := (T - (273.15 : ℝ))
    (((1020.62 : ℝ) - ((0.614254 : ℝ) * v2)) - ((0.000321 : ℝ) * (v2 ^ 2))) := rfl

theorem oilStep_ccc : oilStep = fun (α : ℝ) (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Upipe : ℝ) (UAx : ℝ) (Coil : ℝ) (ToilMax : ℝ) (Pin : ℝ) (Toil : ℝ) (Twall : ℝ) (Ta : ℝ) (dt : ℝ) =>
    let v22 := (Toil - Ta)
    (min ToilMax (Toil + ((dt * ((((α * Pin) - ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v22))) - (Upipe * v22)) - (max (0 : ℝ) (UAx * (Toil - Twall))))) / Coil))) := rfl

theorem pipeArea_ccc : pipeArea = fun (D : ℝ) =>
    ((Real.pi * (D ^ 2)) / (4 : ℝ)) := rfl

theorem pipeGreen_ccc : pipeGreen = fun (Upipe : ℝ) (mcp : ℝ) =>
    (Real.exp ((-Upipe) / mcp)) := rfl

theorem pointVel_ccc : pointVel = fun (t : TandoorHashemi.Screw) (p : Fin 3 → ℝ) =>
    ![((((t 1) * (p 2)) - ((t 2) * (p 1))) + (t 3)), ((((t 2) * (p 0)) - ((t 0) * (p 2))) + (t 4)), ((((t 0) * (p 1)) - ((t 1) * (p 0))) + (t 5))] := rfl

theorem pointingError_ccc : pointingError = fun (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) =>
    let v4 := (Real.sin t)
    let v6 := (v4 * (Real.cos az))
    let v8 := (v4 * (Real.sin az))
    let v9 := (Real.cos t)
    let v10 := (Real.cos elSun)
    let v12 := (v10 * (Real.cos azSun))
    let v14 := (v10 * (Real.sin azSun))
    let v15 := (Real.sin elSun)
    let v20 := (((v6 * v12) + (v8 * v14)) + (v9 * v15))
    let v35 := (Real.sqrt (((((v8 * v15) - (v9 * v14)) ^ 2) + (((v9 * v12) - (v6 * v15)) ^ 2)) + (((v6 * v14) - (v8 * v12)) ^ 2)))
    (if (v20 ≤ (0 : ℝ)) then ((Real.pi / (2 : ℝ)) + (Real.arctan ((-v20) / (max v35 (0.000000000001 : ℝ))))) else (Real.arctan (v35 / v20))) := rfl

theorem postTop_ccc : postTop = fun (c : TandoorHashemi.Carriage) (l : TandoorHashemi.Leg) (endIn : ℝ) (sg : ℝ) =>
    ![c.apexH, (sg * ((c.chord / (2 : ℝ)) - endIn)), l.upright] := rfl

theorem prandtl_ccc : prandtl = fun (T : ℝ) =>
    let v3 := (T - (273.15 : ℝ))
    let v17 := (v3 ^ 2)
    ((((Real.exp (((586.375 : ℝ) / (v3 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ)) * ((1000 : ℝ) * (((1.496005 : ℝ) + ((0.003313 : ℝ) * v3)) + ((0.0000008970757 : ℝ) * v17)))) / (((0.118294 : ℝ) - ((0.000033 : ℝ) * v3)) - ((0.00000015 : ℝ) * v17))) := rfl

theorem prop_AH_bounds_ccc : prop_AH_bounds =
    let v1 := (Real.sqrt (3.36 : ℝ))
    (((1.833 : ℝ) < v1) ∧ (v1 < (1.8331 : ℝ))) := rfl

theorem prop_FC_bounds_ccc : prop_FC_bounds =
    let v6 := (Real.sqrt ((5 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.36 : ℝ)))))
    (((1.154 : ℝ) < v6) ∧ (v6 < (1.1551 : ℝ))) := rfl

theorem prop_FC_eq_ccc : prop_FC_eq =
    let v1 := ((0.8 : ℝ) ^ 2)
    ((Real.sqrt ((((1 : ℝ) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - v1)))) ^ 2) + v1)) = (Real.sqrt ((5 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.36 : ℝ)))))) := rfl

theorem prop_FH_bounds_ccc : prop_FH_bounds =
    let v8 := (((2 : ℝ) / (2 : ℝ)) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2)))))
    (((0.833 : ℝ) < v8) ∧ (v8 < (0.8331 : ℝ))) := rfl

theorem prop_FH_eq_ccc : prop_FH_eq =
    ((((2 : ℝ) / (2 : ℝ)) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2))))) = ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))) := rfl

theorem prop_HD_bounds_ccc : prop_HD_bounds =
    let v6 := ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2))))
    (((0.166 : ℝ) < v6) ∧ (v6 < (0.168 : ℝ))) := rfl

theorem prop_HD_eq_ccc : prop_HD_eq =
    (((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2)))) = ((2 : ℝ) - (Real.sqrt (3.36 : ℝ)))) := rfl

theorem prop_azRate_pos_ccc : prop_azRate_pos = fun (ωm : ℝ) (rw : ℝ) (R : ℝ) =>
    (((0 : ℝ) < ωm) → (((0 : ℝ) < rw) → (((0 : ℝ) < R) → ((0 : ℝ) < ((ωm * rw) / R))))) := rfl

theorem prop_bearing_life_ccc : prop_bearing_life = fun (L10 : ℝ) =>
    ((((10 : ℝ) ^ 6) ≤ L10) → (((100 : ℝ) * ((20 : ℝ) * (365.25 : ℝ))) < L10)) := rfl

theorem prop_braceHeight_hashemi_ccc : prop_braceHeight_hashemi =
    let v7 := (Real.sqrt (((0.96 : ℝ) ^ 2) - (((0.62 : ℝ) - (0.175 : ℝ)) ^ 2)))
    (((0.85 : ℝ) < v7) ∧ (v7 < (0.851 : ℝ))) := rfl

theorem prop_brace_cuts_moment_ccc : prop_brace_cuts_moment =
    ((((1.30 : ℝ) - (Real.sqrt (((0.96 : ℝ) ^ 2) - (((0.62 : ℝ) - (0.175 : ℝ)) ^ 2)))) / (1.30 : ℝ)) < (0.35 : ℝ)) := rfl

theorem prop_brace_stiffens_ccc : prop_brace_stiffens =
    (((((1.30 : ℝ) - (Real.sqrt (((0.96 : ℝ) ^ 2) - (((0.62 : ℝ) - (0.175 : ℝ)) ^ 2)))) / (1.30 : ℝ)) ^ 3) < ((1 : ℝ) / (24 : ℝ))) := rfl

theorem prop_cable_drop_small_ccc : prop_cable_drop_small = fun (L : ℝ) (I : ℝ) =>
    ((L ≤ (4 : ℝ)) → (((0 : ℝ) ≤ I) → ((I ≤ (1 : ℝ)) → (((((0.0000000172 : ℝ) * ((2 : ℝ) * L)) * I) / (0.0000015 : ℝ)) < (0.1 : ℝ))))) := rfl

theorem prop_captureS_slope_ccc : prop_captureS_slope = fun (rc : ℝ) (r1 : ℝ) (r2 : ℝ) =>
    (|((Real.sigmoid ((rc - r1) / (0.005 : ℝ))) - (Real.sigmoid ((rc - r2) / (0.005 : ℝ))))| ≤ (|(r1 - r2)| / ((4 : ℝ) * (0.005 : ℝ)))) := rfl

theorem prop_clearance_hashemi_ccc : prop_clearance_hashemi = fun (holeDown : ℝ) =>
    let v10 := (((1.30 : ℝ) - holeDown) - (Real.sqrt ((5 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.36 : ℝ))))))
    ((((0.1449 : ℝ) - holeDown) < v10) ∧ (v10 < ((0.146 : ℝ) - holeDown))) := rfl

theorem prop_conicZ_paraboloid_ccc : prop_conicZ_paraboloid = fun (c : ℝ) (r : ℝ) =>
    let v2 := (r ^ 2)
    let v3 := (c * v2)
    ((v3 / ((1 : ℝ) + (Real.sqrt (max ((1 : ℝ) - ((((1 : ℝ) + (-(1 : ℝ))) * (c ^ 2)) * v2)) (0 : ℝ))))) = (v3 / (2 : ℝ))) := rfl

theorem prop_conicZ_sphere_ccc : prop_conicZ_sphere = fun (c : ℝ) (r : ℝ) =>
    let v2 := (c ^ 2)
    let v3 := (r ^ 2)
    let v5 := ((1 : ℝ) / c)
    (((0 : ℝ) < c) → (((v2 * v3) ≤ (1 : ℝ)) → (((c * v3) / ((1 : ℝ) + (Real.sqrt (max ((1 : ℝ) - ((((1 : ℝ) + (0 : ℝ)) * v2) * v3)) (0 : ℝ))))) = (v5 - (Real.sqrt ((v5 ^ 2) - v3)))))) := rfl

theorem prop_constraints_reciprocal_yaw_ccc : prop_constraints_reciprocal_yaw = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v13 := ((0 : ℝ) * (0 : ℝ))
    let v14 := (b.zBearing * (0 : ℝ))
    let v16 := (b.zBearing * (1 : ℝ))
    let v17 := ((0 : ℝ) * (1 : ℝ))
    let v19 := (c.chord / (2 : ℝ))
    let v20 := (b.zRail * (0 : ℝ))
    let v21 := (c.apexH * (0 : ℝ))
    let v22 := (-v19)
    let v25 := ((0 : ℝ) * (v20 - (c.apexH * (1 : ℝ))))
    (((((((((0 : ℝ) * (v13 - v14)) + ((0 : ℝ) * (v16 - v13))) + ((1 : ℝ) * (v13 - v17))) + v17) + v13) + v13) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * (v13 - v16)) + ((0 : ℝ) * (v14 - v13))) + ((1 : ℝ) * (v17 - v13))) + v13) + v17) + v13) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * (v17 - v14)) + ((0 : ℝ) * (v14 - v17))) + ((1 : ℝ) * (v13 - v13))) + v13) + v13) + v17) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * ((v19 * (1 : ℝ)) - v20)) + v25) + ((1 : ℝ) * (v21 - (v19 * (0 : ℝ))))) + v13) + v13) + v17) = (0 : ℝ)) ∧ ((((((((0 : ℝ) * ((v22 * (1 : ℝ)) - v20)) + v25) + ((1 : ℝ) * (v21 - (v22 * (0 : ℝ))))) + v13) + v13) + v17) = (0 : ℝ)))))) := rfl

theorem prop_cosTubeCut_bounds_ccc : prop_cosTubeCut_bounds =
    let v1 := (Real.sqrt (3.2 : ℝ))
    let v10 := (((3.36 : ℝ) - v1) / ((2 : ℝ) * (Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * v1)))))
    (((0.888 : ℝ) < v10) ∧ (v10 < (0.889 : ℝ))) := rfl

theorem prop_deadTan_at_ym_ccc : prop_deadTan_at_ym =
    let v3 := ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))
    let v13 := ((((1.22 : ℝ) * v3) + ((0.34 : ℝ) * (0.8 : ℝ))) / (((1.22 : ℝ) * (0.8 : ℝ)) - ((0.34 : ℝ) * v3)))
    (((1.859 : ℝ) < v13) ∧ (v13 < (1.86 : ℝ))) := rfl

theorem prop_deadTan_hashemi_ccc : prop_deadTan_hashemi =
    let v3 := ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))
    let v13 := ((((1.2 : ℝ) * v3) + ((0.34 : ℝ) * (0.8 : ℝ))) / (((1.2 : ℝ) * (0.8 : ℝ)) - ((0.34 : ℝ) * v3)))
    (((1.878 : ℝ) < v13) ∧ (v13 < (1.88 : ℝ))) := rfl

theorem prop_dishAxes_rot_ccc : prop_dishAxes_rot = fun (az : ℝ) (t : ℝ) (δ : ℝ) =>
    let v3 := (Real.sin t)
    let v4 := (az + δ)
    let v5 := (Real.cos v4)
    let v6 := (v3 * v5)
    let v7 := (Real.sin v4)
    let v8 := (v3 * v7)
    let v9 := (Real.cos t)
    let v10 := (v9 * v5)
    let v11 := (v9 * v7)
    let v12 := (-v3)
    let v13 := (Real.cos δ)
    let v14 := (Real.cos az)
    let v15 := (v3 * v14)
    let v16 := (Real.sin az)
    let v17 := (v3 * v16)
    let v18 := (v9 * v14)
    let v19 := (v9 * v16)
    let v22 := ((v19 * v9) - (v12 * v17))
    let v25 := ((v12 * v15) - (v18 * v9))
    let v26 := (Real.sin δ)
    (((((v11 * v9) - (v12 * v8)) = ((v13 * v22) - (v26 * v25))) ∧ ((((v12 * v6) - (v10 * v9)) = ((v26 * v22) + (v13 * v25))) ∧ (((v10 * v8) - (v11 * v6)) = ((v18 * v17) - (v19 * v15))))) ∧ (((v10 = ((v13 * v18) - (v26 * v19))) ∧ ((v11 = ((v26 * v18) + (v13 * v19))) ∧ (v12 = v12))) ∧ ((v6 = ((v13 * v15) - (v26 * v17))) ∧ ((v8 = ((v26 * v15) + (v13 * v17))) ∧ (v9 = v9))))) := rfl

theorem prop_dish_between_posts_ccc : prop_dish_between_posts =
    (((2 : ℝ) * (0.8 : ℝ)) < (1.84 : ℝ)) := rfl

theorem prop_dish_swings_to_vertical_ccc : prop_dish_swings_to_vertical =
    ((0.8 : ℝ) < ((1.30 : ℝ) - (0.05 : ℝ))) := rfl

theorem prop_drive_recip_yaw_ccc : prop_drive_recip_yaw = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) (F : ℝ) =>
    let v14 := (c.chord / (2 : ℝ))
    let v18 := (Real.sqrt ((v14 ^ 2) + (c.apexH ^ 2)))
    let v21 := (-((F * v14) / v18))
    let v23 := ((F * c.apexH) / v18)
    ((((((((0 : ℝ) * ((v14 * (0 : ℝ)) - (b.zRail * v23))) + ((0 : ℝ) * ((b.zRail * v21) - (c.apexH * (0 : ℝ))))) + ((1 : ℝ) * ((c.apexH * v23) - (v14 * v21)))) + ((0 : ℝ) * v21)) + ((0 : ℝ) * v23)) + ((0 : ℝ) * (0 : ℝ))) = (F * v18)) := rfl

theorem prop_drive_works_on_yaw_ccc : prop_drive_works_on_yaw = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) (F : ℝ) =>
    let v14 := (c.chord / (2 : ℝ))
    let v18 := (Real.sqrt ((v14 ^ 2) + (c.apexH ^ 2)))
    let v21 := (-((F * v14) / v18))
    let v23 := ((F * c.apexH) / v18)
    ((F ≠ (0 : ℝ)) → ((((((((0 : ℝ) * ((v14 * (0 : ℝ)) - (b.zRail * v23))) + ((0 : ℝ) * ((b.zRail * v21) - (c.apexH * (0 : ℝ))))) + ((1 : ℝ) * ((c.apexH * v23) - (v14 * v21)))) + ((0 : ℝ) * v21)) + ((0 : ℝ) * v23)) + ((0 : ℝ) * (0 : ℝ))) ≠ (0 : ℝ))) := rfl

theorem prop_edgeClip_cross_ccc : prop_edgeClip_cross = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v5 := (-a)
    let v6 := (Real.cos t)
    let v7 := (-ze)
    let v8 := (Real.sin t)
    ((((-ym) * (((-v5) * v8) + (v7 * v6))) - (hp * ((v5 * v6) + (v7 * v8)))) = ((((ym * ze) + (hp * a)) * v6) + (((hp * ze) - (ym * a)) * v8))) := rfl

theorem prop_edgeClip_radius_ccc : prop_edgeClip_radius = fun (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v3 := (-a)
    let v4 := (Real.cos t)
    let v5 := (-ze)
    let v6 := (Real.sin t)
    (((((v3 * v4) + (v5 * v6)) ^ 2) + ((((-v3) * v6) + (v5 * v4)) ^ 2)) = ((a ^ 2) + (ze ^ 2))) := rfl

theorem prop_edgeClip_radius_hashemi_ccc : prop_edgeClip_radius_hashemi = fun (t : ℝ) =>
    let v2 := (-(0.8 : ℝ))
    let v3 := (Real.cos t)
    let v5 := (Real.sqrt (3.36 : ℝ))
    let v8 := (-(v5 - (1 : ℝ)))
    let v9 := (Real.sin t)
    (((((v2 * v3) + (v8 * v9)) ^ 2) + ((((-v2) * v9) + (v8 * v3)) ^ 2)) = ((5 : ℝ) - ((2 : ℝ) * v5))) := rfl

theorem prop_edgeClip_reach_ccc : prop_edgeClip_reach = fun (a : ℝ) (ze : ℝ) (t : ℝ) =>
    (|(((-a) * (Real.cos t)) + ((-ze) * (Real.sin t)))| ≤ (Real.sqrt ((a ^ 2) + (ze ^ 2)))) := rfl

theorem prop_edgeDepth_horizon_ccc : prop_edgeDepth_horizon = fun (f : ℝ) (a : ℝ) (sag : ℝ) =>
    ((((f - sag) * (Real.sin (0 : ℝ))) + (a * (Real.cos (0 : ℝ)))) = a) := rfl

theorem prop_edgeDepth_le_ccc : prop_edgeDepth_le = fun (f : ℝ) (a : ℝ) (sag : ℝ) (el : ℝ) =>
    let v4 := (f - sag)
    (((v4 * (Real.sin el)) + (a * (Real.cos el))) ≤ (Real.sqrt ((v4 ^ 2) + (a ^ 2)))) := rfl

theorem prop_edgeDepth_noon_ccc : prop_edgeDepth_noon = fun (f : ℝ) (a : ℝ) (sag : ℝ) =>
    let v3 := (f - sag)
    let v6 := (Real.pi / (2 : ℝ))
    (((v3 * (Real.sin v6)) + (a * (Real.cos v6))) = v3) := rfl

theorem prop_edgeLever_dead_ccc : prop_edgeLever_dead = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v5 := (Real.sin t)
    let v6 := (Real.cos t)
    let v7 := (-a)
    let v8 := (-ze)
    (((v5 * ((ym * a) - (hp * ze))) = (v6 * ((ym * ze) + (hp * a)))) → ((((-ym) * (((-v7) * v5) + (v8 * v6))) - (hp * ((v7 * v6) + (v8 * v5)))) = (0 : ℝ))) := rfl

theorem prop_edgeLever_pos_iff_ccc : prop_edgeLever_pos_iff = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v5 := (-a)
    let v6 := (Real.cos t)
    let v7 := (-ze)
    let v8 := (Real.sin t)
    let v11 := ((v5 * v6) + (v7 * v8))
    let v15 := (((-v5) * v8) + (v7 * v6))
    let v16 := (-ym)
    let v21 := (((v11 - v16) ^ 2) + ((v15 - hp) ^ 2))
    (((0 : ℝ) < v21) → (((0 : ℝ) < (((v16 * v15) - (hp * v11)) / (Real.sqrt v21))) ↔ ((v8 * ((ym * a) - (hp * ze))) < (v6 * ((ym * ze) + (hp * a)))))) := rfl

theorem prop_elPower_eq_wire_ccc : prop_elPower_eq_wire = fun (rw : ℝ) (W : ℝ) (rcm : ℝ) (t : ℝ) (ω : ℝ) =>
    let v7 := ((W * rcm) * (Real.sin t))
    ((rw ≠ (0 : ℝ)) → (((v7 / rw) * (rw * ω)) = (v7 * ω))) := rfl

theorem prop_elPower_le_ccc : prop_elPower_le = fun (W : ℝ) (rcm : ℝ) (ω : ℝ) (t : ℝ) =>
    let v4 := (W * rcm)
    (((0 : ℝ) ≤ W) → (((0 : ℝ) ≤ rcm) → (((0 : ℝ) ≤ ω) → (((v4 * (Real.sin t)) * ω) ≤ (v4 * ω))))) := rfl

theorem prop_facetSpot_hashemi_ccc : prop_facetSpot_hashemi =
    (((0.05 : ℝ) + ((1 : ℝ) * (0.0093 : ℝ))) = (0.0593 : ℝ)) := rfl

theorem prop_focus_on_axis_ccc : prop_focus_on_axis = fun (ψ : ℝ) (p : ℝ × ℝ) =>
    let v3 := (Real.cos ψ)
    let v4 := (Real.sin ψ)
    ((v3 ≠ (1 : ℝ)) → (((((v3 * p.1) - (v4 * p.2)) = p.1) ∧ (((v4 * p.1) + (v3 * p.2)) = p.2)) → ((p.1 = (0 : ℝ)) ∧ (p.2 = (0 : ℝ))))) := rfl

theorem prop_grooved_reciprocal_yaw_ccc : prop_grooved_reciprocal_yaw = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v13 := ((0 : ℝ) * (0 : ℝ))
    let v14 := (b.zBearing * (0 : ℝ))
    let v16 := (b.zBearing * (1 : ℝ))
    let v17 := ((0 : ℝ) * (1 : ℝ))
    let v19 := (c.chord / (2 : ℝ))
    let v20 := (b.zRail * (0 : ℝ))
    let v21 := (c.apexH * (0 : ℝ))
    let v22 := (v19 * (0 : ℝ))
    let v23 := (-v19)
    let v24 := (v23 * (0 : ℝ))
    let v27 := ((0 : ℝ) * (v20 - (c.apexH * (1 : ℝ))))
    let v30 := ((0 : ℝ) * ((b.zRail * c.apexH) - v21))
    let v31 := ((0 : ℝ) * c.apexH)
    (((((((((0 : ℝ) * (v13 - v14)) + ((0 : ℝ) * (v16 - v13))) + ((1 : ℝ) * (v13 - v17))) + v17) + v13) + v13) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * (v13 - v16)) + ((0 : ℝ) * (v14 - v13))) + ((1 : ℝ) * (v17 - v13))) + v13) + v17) + v13) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * (v17 - v14)) + ((0 : ℝ) * (v14 - v17))) + ((1 : ℝ) * (v13 - v13))) + v13) + v13) + v17) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * ((v19 * (1 : ℝ)) - v20)) + v27) + ((1 : ℝ) * (v21 - v22))) + v13) + v13) + v17) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * ((v23 * (1 : ℝ)) - v20)) + v27) + ((1 : ℝ) * (v21 - v24))) + v13) + v13) + v17) = (0 : ℝ)) ∧ (((((((((0 : ℝ) * (v22 - (b.zRail * v19))) + v30) + ((1 : ℝ) * ((c.apexH * v19) - (v19 * c.apexH)))) + v31) + ((0 : ℝ) * v19)) + v13) = (0 : ℝ)) ∧ ((((((((0 : ℝ) * (v24 - (b.zRail * v23))) + v30) + ((1 : ℝ) * ((c.apexH * v23) - (v23 * c.apexH)))) + v31) + ((0 : ℝ) * v23)) + v13) = (0 : ℝ)))))))) := rfl

theorem prop_grooved_relation_x_ccc : prop_grooved_relation_x = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v13 := (c.chord / (2 : ℝ))
    let v15 := (v13 * (0 : ℝ))
    let v16 := (c.apexH * (0 : ℝ))
    let v18 := ((b.zRail * c.apexH) - v16)
    let v19 := (-v13)
    let v20 := (v19 * (0 : ℝ))
    let v21 := ((0 : ℝ) + (0 : ℝ))
    let v22 := ((2 : ℝ) * c.apexH)
    let v23 := ((0 : ℝ) * (0 : ℝ))
    let v24 := (b.zBearing * (0 : ℝ))
    let v26 := ((0 : ℝ) * (1 : ℝ))
    let v27 := (v22 * (0 : ℝ))
    let v28 := (b.zRail - b.zBearing)
    let v29 := (b.zRail * (0 : ℝ))
    let v31 := (v29 - (c.apexH * (1 : ℝ)))
    let v34 := (v28 * (v21 - ((2 : ℝ) * (0 : ℝ))))
    (((((c.apexH + c.apexH) - (v22 * (1 : ℝ))) + v34) = (0 : ℝ)) ∧ (((((v13 + v19) - v27) + v34) = (0 : ℝ)) ∧ ((((v21 - v27) + (v28 * (((1 : ℝ) + (1 : ℝ)) - ((2 : ℝ) * (1 : ℝ))))) = (0 : ℝ)) ∧ ((((((v15 - (b.zRail * v13)) + (v20 - (b.zRail * v19))) - (v22 * (v23 - v24))) + (v28 * ((((v13 * (1 : ℝ)) - v29) + ((v19 * (1 : ℝ)) - v29)) - ((2 : ℝ) * (v26 - v24))))) = (0 : ℝ)) ∧ (((((v18 + v18) - (v22 * ((b.zBearing * (1 : ℝ)) - v23))) + (v28 * ((v31 + v31) - ((2 : ℝ) * (v24 - v26))))) = (0 : ℝ)) ∧ ((((((c.apexH * v13) - (v13 * c.apexH)) + ((c.apexH * v19) - (v19 * c.apexH))) - (v22 * (v23 - v26))) + (v28 * (((v16 - v15) + (v16 - v20)) - ((2 : ℝ) * (v23 - v23))))) = (0 : ℝ))))))) := rfl

theorem prop_grooved_relation_y_ccc : prop_grooved_relation_y = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v13 := (c.chord / (2 : ℝ))
    let v15 := (v13 * (0 : ℝ))
    let v16 := (c.apexH * (0 : ℝ))
    let v18 := ((b.zRail * c.apexH) - v16)
    let v19 := (-v13)
    let v20 := (v19 * (0 : ℝ))
    let v21 := ((0 : ℝ) - (0 : ℝ))
    let v22 := ((0 : ℝ) * (0 : ℝ))
    let v23 := (c.chord * (0 : ℝ))
    let v24 := (b.zBearing - b.zRail)
    let v25 := (b.zRail * (0 : ℝ))
    let v28 := (v25 - (c.apexH * (1 : ℝ)))
    let v29 := (v24 * v21)
    (((((c.apexH - c.apexH) - v23) - v29) = (0 : ℝ)) ∧ (((((v13 - v19) - (c.chord * (1 : ℝ))) - v29) = (0 : ℝ)) ∧ ((((v21 - v23) - (v24 * ((1 : ℝ) - (1 : ℝ)))) = (0 : ℝ)) ∧ ((((((v15 - (b.zRail * v13)) - (v20 - (b.zRail * v19))) - (c.chord * (v22 - (b.zBearing * (1 : ℝ))))) - (v24 * (((v13 * (1 : ℝ)) - v25) - ((v19 * (1 : ℝ)) - v25)))) = (0 : ℝ)) ∧ (((((v18 - v18) - (c.chord * ((b.zBearing * (0 : ℝ)) - v22))) - (v24 * (v28 - v28))) = (0 : ℝ)) ∧ ((((((c.apexH * v13) - (v13 * c.apexH)) - ((c.apexH * v19) - (v19 * c.apexH))) - (c.chord * (((0 : ℝ) * (1 : ℝ)) - v22))) - (v24 * ((v16 - v15) - (v16 - v20)))) = (0 : ℝ))))))) := rfl

theorem prop_hangerLength_bounds_ccc : prop_hangerLength_bounds =
    let v6 := (Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.2 : ℝ)))))
    (((0.884 : ℝ) < v6) ∧ (v6 < (0.8846 : ℝ))) := rfl

theorem prop_hangerLength_halfEdge_ccc : prop_hangerLength_halfEdge =
    let v1 := ((0.4 : ℝ) ^ 2)
    ((Real.sqrt ((((0 : ℝ) ^ 2) + v1) + ((((2 : ℝ) / (2 : ℝ)) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((Real.sqrt (((0.8 : ℝ) ^ 2) + v1)) ^ 2))))) ^ 2))) = (Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.2 : ℝ)))))) := rfl

theorem prop_hashemiHanger_length_ccc : prop_hashemiHanger_length =
    let v1 := ((0.4 : ℝ) ^ 2)
    ((Real.sqrt ((4.36 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.2 : ℝ))))) = (Real.sqrt ((((0 : ℝ) ^ 2) + v1) + ((((2 : ℝ) / (2 : ℝ)) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((Real.sqrt (((0.8 : ℝ) ^ 2) + v1)) ^ 2))))) ^ 2)))) := rfl

theorem prop_hashemi_clearance_ccc : prop_hashemi_clearance =
    let v8 := ((1.30 : ℝ) - (Real.sqrt ((5 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.36 : ℝ))))))
    (((0.1449 : ℝ) < v8) ∧ (v8 < (0.146 : ℝ))) := rfl

theorem prop_hashemi_eyes_clear_ccc : prop_hashemi_eyes_clear =
    (((0.010 : ℝ) / (2 : ℝ)) < (0.010 : ℝ)) := rfl

theorem prop_hashemi_fits_ccc : prop_hashemi_fits =
    let v7 := (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))
    (v7 = v7) := rfl

theorem prop_helixAdvance_small_ccc : prop_helixAdvance_small =
    ((((0.00175 : ℝ) * (((62 : ℝ) * Real.pi) / (180 : ℝ))) / ((2 : ℝ) * Real.pi)) < (0.00031 : ℝ)) := rfl

theorem prop_hinge_freedom_ccc : prop_hinge_freedom = fun (xh : ℝ) (zBolt : ℝ) (t : TandoorHashemi.Screw) =>
    let v9 := ((0 : ℝ) * (0 : ℝ))
    let v10 := (zBolt * (0 : ℝ))
    let v12 := (zBolt * (1 : ℝ))
    let v13 := (xh * (0 : ℝ))
    let v14 := ((0 : ℝ) * (1 : ℝ))
    let v15 := (xh * (1 : ℝ))
    let v16 := ((t 4) * (0 : ℝ))
    let v17 := ((t 5) * (0 : ℝ))
    let v18 := ((t 3) * (0 : ℝ))
    let v19 := ((t 0) * (0 : ℝ))
    ((((((((((t 0) * (v9 - v10)) + ((t 1) * (v12 - v13))) + ((t 2) * (v13 - v14))) + ((t 3) * (1 : ℝ))) + v16) + v17) = (0 : ℝ)) ∧ (((((((((t 0) * (v9 - v12)) + ((t 1) * (v10 - v13))) + ((t 2) * (v15 - v9))) + v18) + ((t 4) * (1 : ℝ))) + v17) = (0 : ℝ)) ∧ (((((((((t 0) * (v14 - v10)) + ((t 1) * (v10 - v15))) + ((t 2) * (v13 - v9))) + v18) + v16) + ((t 5) * (1 : ℝ))) = (0 : ℝ)) ∧ (((((((v19 + ((t 1) * (1 : ℝ))) + ((t 2) * (0 : ℝ))) + v18) + v16) + v17) = (0 : ℝ)) ∧ ((((((v19 + ((t 1) * (0 : ℝ))) + ((t 2) * (1 : ℝ))) + v18) + v16) + v17) = (0 : ℝ)))))) → (((t 1) = (0 : ℝ)) ∧ (((t 2) = (0 : ℝ)) ∧ (((t 3) = (0 : ℝ)) ∧ (((t 4) = ((t 0) * zBolt)) ∧ ((t 5) = (0 : ℝ))))))) := rfl

theorem prop_hinge_freedom_smul_ccc : prop_hinge_freedom_smul = fun (xh : ℝ) (zBolt : ℝ) (apexH : ℝ) (t : TandoorHashemi.Screw) =>
    let v10 := ((0 : ℝ) * (0 : ℝ))
    let v11 := (zBolt * (0 : ℝ))
    let v13 := (zBolt * (1 : ℝ))
    let v14 := (xh * (0 : ℝ))
    let v15 := ((0 : ℝ) * (1 : ℝ))
    let v16 := (xh * (1 : ℝ))
    let v18 := ((t 0) * (v10 - v11))
    let v19 := ((t 4) * (0 : ℝ))
    let v20 := ((t 5) * (0 : ℝ))
    let v21 := ((t 3) * (0 : ℝ))
    let v22 := ((t 0) * (0 : ℝ))
    let v23 := (apexH * (0 : ℝ))
    ((((((((v18 + ((t 1) * (v13 - v14))) + ((t 2) * (v14 - v15))) + ((t 3) * (1 : ℝ))) + v19) + v20) = (0 : ℝ)) ∧ (((((((((t 0) * (v10 - v13)) + ((t 1) * (v11 - v14))) + ((t 2) * (v16 - v10))) + v21) + ((t 4) * (1 : ℝ))) + v20) = (0 : ℝ)) ∧ (((((((((t 0) * (v15 - v11)) + ((t 1) * (v11 - v16))) + ((t 2) * (v14 - v10))) + v21) + v19) + ((t 5) * (1 : ℝ))) = (0 : ℝ)) ∧ (((((((v22 + ((t 1) * (1 : ℝ))) + ((t 2) * (0 : ℝ))) + v21) + v19) + v20) = (0 : ℝ)) ∧ ((((((v22 + ((t 1) * (0 : ℝ))) + ((t 2) * (1 : ℝ))) + v21) + v19) + v20) = (0 : ℝ)))))) → (((t 0) = ((t 0) * (1 : ℝ))) ∧ (((t 1) = v22) ∧ (((t 2) = v22) ∧ (((t 3) = v18) ∧ (((t 4) = ((t 0) * (v13 - v23))) ∧ ((t 5) = ((t 0) * (v23 - v15))))))))) := rfl

theorem prop_hinge_reciprocal_swing_ccc : prop_hinge_reciprocal_swing = fun (xh : ℝ) (zBolt : ℝ) (apexH : ℝ) =>
    let v4 := ((0 : ℝ) * (0 : ℝ))
    let v5 := (zBolt * (0 : ℝ))
    let v6 := (v4 - v5)
    let v8 := (zBolt * (1 : ℝ))
    let v9 := (apexH * (0 : ℝ))
    let v10 := (v8 - v9)
    let v11 := ((0 : ℝ) * (1 : ℝ))
    let v12 := (v9 - v11)
    let v13 := (xh * (0 : ℝ))
    let v14 := (xh * (1 : ℝ))
    let v15 := (v10 * (0 : ℝ))
    let v16 := (v12 * (0 : ℝ))
    let v17 := (v6 * (0 : ℝ))
    let v18 := ((1 : ℝ) * (0 : ℝ))
    (((((((((1 : ℝ) * v6) + ((0 : ℝ) * (v8 - v13))) + ((0 : ℝ) * (v13 - v11))) + (v6 * (1 : ℝ))) + v15) + v16) = (0 : ℝ)) ∧ (((((((((1 : ℝ) * (v4 - v8)) + ((0 : ℝ) * (v5 - v13))) + ((0 : ℝ) * (v14 - v4))) + v17) + (v10 * (1 : ℝ))) + v16) = (0 : ℝ)) ∧ (((((((((1 : ℝ) * (v11 - v5)) + ((0 : ℝ) * (v5 - v14))) + ((0 : ℝ) * (v13 - v4))) + v17) + v15) + (v12 * (1 : ℝ))) = (0 : ℝ)) ∧ (((((((v18 + v11) + v4) + v17) + v15) + v16) = (0 : ℝ)) ∧ ((((((v18 + v4) + v11) + v17) + v15) + v16) = (0 : ℝ)))))) := rfl

theorem prop_lean_one_degree_ccc : prop_lean_one_degree =
    ((0.02 : ℝ) < ((1.25 : ℝ) * (Real.sin (Real.pi / (180 : ℝ))))) := rfl

theorem prop_lowestSun_tan_at_ym_ccc : prop_lowestSun_tan_at_ym =
    let v3 := ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))
    let v14 := ((1 : ℝ) / ((((1.22 : ℝ) * v3) + ((0.34 : ℝ) * (0.8 : ℝ))) / (((1.22 : ℝ) * (0.8 : ℝ)) - ((0.34 : ℝ) * v3))))
    (((0.537 : ℝ) < v14) ∧ (v14 < (0.538 : ℝ))) := rfl

theorem prop_m12_carries_dish_ccc : prop_m12_carries_dish = fun (W : ℝ) =>
    ((W ≤ (1000 : ℝ)) → ((((W / (2 : ℝ)) * (0.03 : ℝ)) / ((Real.pi * ((0.0101 : ℝ) ^ 3)) / (32 : ℝ))) < (16e7 : ℝ))) := rfl

theorem prop_mastClears_hashemi_ccc : prop_mastClears_hashemi =
    ((Real.sqrt (((0.8 : ℝ) ^ 2) + (((Real.sqrt (3.36 : ℝ)) - (1 : ℝ)) ^ 2))) < (1.22 : ℝ)) := rfl

theorem prop_mastClears_hashemi_iff_ccc : prop_mastClears_hashemi_iff = fun (ym : ℝ) =>
    let v2 := (Real.sqrt (3.36 : ℝ))
    (((Real.sqrt (((0.8 : ℝ) ^ 2) + ((v2 - (1 : ℝ)) ^ 2))) < ym) ↔ ((Real.sqrt ((5 : ℝ) - ((2 : ℝ) * v2))) < ym)) := rfl

theorem prop_mast_beyond_ring_ccc : prop_mast_beyond_ring =
    ((Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2))) < ((0.80 : ℝ) + (1.22 : ℝ))) := rfl

theorem prop_mast_for_vertical_hashemi_ccc : prop_mast_for_vertical_hashemi =
    ((1.17 : ℝ) < (((1.22 : ℝ) * (0.8 : ℝ)) / ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ)))) := rfl

theorem prop_mul_bounds_neg_pos_ccc : prop_mul_bounds_neg_pos = fun (b : ℝ) (r : ℝ) (blo : ℝ) (bhi : ℝ) (rlo : ℝ) (rhi : ℝ) =>
    let v6 := (b * r)
    ((blo < b) → ((b < bhi) → ((bhi ≤ (0 : ℝ)) → ((rlo < r) → ((r < rhi) → (((0 : ℝ) ≤ rlo) → (((blo * rhi) < v6) ∧ (v6 < (bhi * rlo))))))))) := rfl

theorem prop_mul_bounds_pos_pos_ccc : prop_mul_bounds_pos_pos = fun (x : ℝ) (r : ℝ) (xlo : ℝ) (xhi : ℝ) (rlo : ℝ) (rhi : ℝ) =>
    let v6 := (x * r)
    ((xlo < x) → ((x < xhi) → (((0 : ℝ) ≤ xlo) → ((rlo < r) → ((r < rhi) → (((0 : ℝ) ≤ rlo) → (((xlo * rlo) < v6) ∧ (v6 < (xhi * rhi))))))))) := rfl

theorem prop_one_turn_tilt_ccc : prop_one_turn_tilt =
    let v4 := ((0.0015 : ℝ) / ((2 : ℝ) * (0.8 : ℝ)))
    ((v4 < (0.001 : ℝ)) ∧ ((((4 : ℝ) * v4) < (0.00465 : ℝ)) ∧ (((1 : ℝ) * v4) < (0.001 : ℝ)))) := rfl

theorem prop_panel_current_ccc : prop_panel_current =
    (((5 : ℝ) / (12 : ℝ)) < (0.5 : ℝ)) := rfl

theorem prop_play_budget_ccc : prop_play_budget = fun (f : ℝ) (ε : ℝ) (h : ℝ) (δ : ℝ) =>
    let v5 := (f * (Real.tan ε))
    ((v5 ≤ (h - δ)) → ((v5 + δ) ≤ h)) := rfl

theorem prop_plumbed_shift_ccc : prop_plumbed_shift = fun (ε : ℝ) =>
    (((0 : ℝ) ≤ ε) → ((ε ≤ (0.0005 : ℝ)) → (((1.30 : ℝ) * (Real.sin ε)) ≤ (0.00065 : ℝ)))) := rfl

theorem prop_postTop_on_rail_ccc : prop_postTop_on_rail = fun (c : TandoorHashemi.Carriage) (l : TandoorHashemi.Leg) (sg : ℝ) =>
    let v13 := (c.chord / (2 : ℝ))
    let v14 := (c.apexH ^ 2)
    (((sg ^ 2) = (1 : ℝ)) → ((v14 + ((sg * (v13 - (0 : ℝ))) ^ 2)) = ((Real.sqrt ((v13 ^ 2) + v14)) ^ 2))) := rfl

theorem prop_postTops_apart_ccc : prop_postTops_apart = fun (c : TandoorHashemi.Carriage) (l : TandoorHashemi.Leg) (endIn : ℝ) =>
    let v14 := ((c.chord / (2 : ℝ)) - endIn)
    ((((1 : ℝ) * v14) - ((-(1 : ℝ)) * v14)) = (c.chord - ((2 : ℝ) * endIn))) := rfl

theorem prop_postTops_level_ccc : prop_postTops_level = fun (c : TandoorHashemi.Carriage) (l : TandoorHashemi.Leg) (endIn : ℝ) =>
    (l.upright = l.upright) := rfl

theorem prop_postTops_offAxis_ccc : prop_postTops_offAxis = fun (c : TandoorHashemi.Carriage) (l : TandoorHashemi.Leg) (endIn : ℝ) (sg : ℝ) =>
    (c.apexH = c.apexH) := rfl

theorem prop_pulley_above_pivot_ccc : prop_pulley_above_pivot =
    (((1.59 : ℝ) - ((1.30 : ℝ) - (0.05 : ℝ))) = (0.34 : ℝ)) := rfl

theorem prop_reachesVertical_iff_ccc : prop_reachesVertical_iff = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) =>
    let v4 := (ym * a)
    (((0 : ℝ) < ze) → ((v4 ≤ (hp * ze)) ↔ ((v4 / ze) ≤ hp))) := rfl

theorem prop_receiverPost_height_ccc : prop_receiverPost_height =
    (((1.30 : ℝ) - (0.05 : ℝ)) = (1.25 : ℝ)) := rfl

theorem prop_rim_under_F_iff_ccc : prop_rim_under_F_iff = fun (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v3 := (Real.cos t)
    (((0 : ℝ) < ze) → (((0 : ℝ) < v3) → ((((a * v3) + ((-ze) * (Real.sin t))) = (0 : ℝ)) ↔ ((Real.tan t) = (a / ze))))) := rfl

theorem prop_rodTan_bounds_ccc : prop_rodTan_bounds =
    let v5 := ((0.4 : ℝ) / ((Real.sqrt (3.2 : ℝ)) - (1 : ℝ)))
    (((0.507 : ℝ) < v5) ∧ (v5 < (0.5072 : ℝ))) := rfl

theorem prop_rollerRadius_hashemi_ccc : prop_rollerRadius_hashemi =
    ((Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2))) = (Real.sqrt (1.4864 : ℝ))) := rfl

theorem prop_rollerRadius_hashemi_bounds_ccc : prop_rollerRadius_hashemi_bounds =
    let v7 := (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2)))
    (((1.219 : ℝ) < v7) ∧ (v7 < (1.2195 : ℝ))) := rfl

theorem prop_rollerRadius_pos_ccc : prop_rollerRadius_pos = fun (c : TandoorHashemi.Carriage) =>
    ((0 : ℝ) < (Real.sqrt (((c.chord / (2 : ℝ)) ^ 2) + (c.apexH ^ 2)))) := rfl

theorem prop_rollerRadius_sq_ccc : prop_rollerRadius_sq = fun (c : TandoorHashemi.Carriage) =>
    let v10 := (((c.chord / (2 : ℝ)) ^ 2) + (c.apexH ^ 2))
    (((Real.sqrt v10) ^ 2) = v10) := rfl

theorem prop_roller_rpm_hashemi_ccc : prop_roller_rpm_hashemi =
    let v6 := ((((2 : ℝ) / (360 : ℝ)) * (1.2192 : ℝ)) / (0.05 : ℝ))
    (((0.13 : ℝ) < v6) ∧ (v6 < (0.14 : ℝ))) := rfl

theorem prop_rotz_dot_ccc : prop_rotz_dot = fun (δ : ℝ) (u : Fin 3 → ℝ) (v : Fin 3 → ℝ) =>
    let v7 := (Real.cos δ)
    let v8 := (Real.sin δ)
    let v9 := ((u 2) * (v 2))
    ((((((v7 * (u 0)) - (v8 * (u 1))) * ((v7 * (v 0)) - (v8 * (v 1)))) + (((v8 * (u 0)) + (v7 * (u 1))) * ((v8 * (v 0)) + (v7 * (v 1))))) + v9) = ((((u 0) * (v 0)) + ((u 1) * (v 1))) + v9)) := rfl

theorem prop_screwLength_eq_focal_ccc : prop_screwLength_eq_focal = fun (R : ℝ) (a : ℝ) =>
    let v6 := (R - (Real.sqrt ((R ^ 2) - (a ^ 2))))
    (((R / (2 : ℝ)) - v6) = ((R - (R / ((2 : ℝ) * (Real.cos (Real.arcsin ((0 : ℝ) / R)))))) - v6)) := rfl

theorem prop_screwLength_hashemi_ccc : prop_screwLength_hashemi =
    ((((2 : ℝ) / (2 : ℝ)) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((1 : ℝ) ^ 2))))) = ((Real.sqrt (3 : ℝ)) - (1 : ℝ))) := rfl

theorem prop_screwLength_hashemi_bounds_ccc : prop_screwLength_hashemi_bounds =
    let v8 := (((2 : ℝ) / (2 : ℝ)) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((1 : ℝ) ^ 2)))))
    (((0.732 : ℝ) < v8) ∧ (v8 < (0.7321 : ℝ))) := rfl

theorem prop_screwTwist_zero_ccc : prop_screwTwist_zero = fun (apexH : ℝ) (zBolt : ℝ) =>
    let v3 := (apexH * (0 : ℝ))
    let v4 := ((0 : ℝ) = (0 : ℝ))
    (((1 : ℝ) = (1 : ℝ)) ∧ (v4 ∧ (v4 ∧ (((0 : ℝ) = (((0 : ℝ) * (0 : ℝ)) - (zBolt * (0 : ℝ)))) ∧ ((zBolt = ((zBolt * (1 : ℝ)) - v3)) ∧ ((0 : ℝ) = (v3 - ((0 : ℝ) * (1 : ℝ))))))))) := rfl

theorem prop_screw_freedom_ccc : prop_screw_freedom = fun (xh : ℝ) (zBolt : ℝ) (h : ℝ) (t : TandoorHashemi.Screw) =>
    let v10 := ((0 : ℝ) * (0 : ℝ))
    let v11 := (zBolt * (0 : ℝ))
    let v12 := (xh * (0 : ℝ))
    let v14 := (xh * (1 : ℝ))
    let v15 := ((t 3) * (0 : ℝ))
    let v16 := ((t 5) * (0 : ℝ))
    let v17 := ((t 4) * (0 : ℝ))
    let v18 := ((t 0) * (0 : ℝ))
    let v19 := ((t 2) * (0 : ℝ))
    ((((((((((t 0) * (v10 - (zBolt * (1 : ℝ)))) + ((t 1) * (v11 - v12))) + ((t 2) * (v14 - v10))) + v15) + ((t 4) * (1 : ℝ))) + v16) = (0 : ℝ)) ∧ (((((((((t 0) * (((0 : ℝ) * (1 : ℝ)) - v11)) + ((t 1) * (v11 - v14))) + ((t 2) * (v12 - v10))) + v15) + v17) + ((t 5) * (1 : ℝ))) = (0 : ℝ)) ∧ (((((((v18 + ((t 1) * (1 : ℝ))) + v19) + v15) + v17) + v16) = (0 : ℝ)) ∧ (((((((v18 + ((t 1) * (0 : ℝ))) + ((t 2) * (1 : ℝ))) + v15) + v17) + v16) = (0 : ℝ)) ∧ ((((((((t 0) * (-h)) + ((t 1) * zBolt)) + v19) + ((t 3) * (1 : ℝ))) + v17) + v16) = (0 : ℝ)))))) → (((t 1) = (0 : ℝ)) ∧ (((t 2) = (0 : ℝ)) ∧ (((t 3) = ((t 0) * h)) ∧ (((t 4) = ((t 0) * zBolt)) ∧ ((t 5) = (0 : ℝ))))))) := rfl

theorem prop_screw_reciprocal_ccc : prop_screw_reciprocal = fun (xh : ℝ) (zBolt : ℝ) (h : ℝ) =>
    let v4 := ((0 : ℝ) * (0 : ℝ))
    let v6 := (zBolt * (1 : ℝ))
    let v7 := (zBolt * (0 : ℝ))
    let v8 := (xh * (0 : ℝ))
    let v9 := (xh * (1 : ℝ))
    let v10 := ((0 : ℝ) * (1 : ℝ))
    let v11 := (h * (0 : ℝ))
    let v12 := ((1 : ℝ) * (0 : ℝ))
    (((((((((1 : ℝ) * (v4 - v6)) + ((0 : ℝ) * (v7 - v8))) + ((0 : ℝ) * (v9 - v4))) + v11) + v6) + v4) = (0 : ℝ)) ∧ (((((((((1 : ℝ) * (v10 - v7)) + ((0 : ℝ) * (v7 - v9))) + ((0 : ℝ) * (v8 - v4))) + v11) + v7) + v10) = (0 : ℝ)) ∧ (((((((v12 + v10) + v4) + v11) + v7) + v4) = (0 : ℝ)) ∧ (((((((v12 + v4) + v10) + v11) + v7) + v4) = (0 : ℝ)) ∧ ((((((((1 : ℝ) * (-h)) + ((0 : ℝ) * zBolt)) + v4) + (h * (1 : ℝ))) + v7) + v4) = (0 : ℝ)))))) := rfl

theorem prop_shim_negligible_ccc : prop_shim_negligible =
    ((0.0005 : ℝ) < ((0.01 : ℝ) * (0.06 : ℝ))) := rfl

theorem prop_sideGap_eq_ccc : prop_sideGap_eq =
    ((((1.84 : ℝ) - ((2 : ℝ) * (0.8 : ℝ))) / (2 : ℝ)) = (0.12 : ℝ)) := rfl

theorem prop_sixty_reachable_ccc : prop_sixty_reachable =
    let v2 := (Real.pi / (3 : ℝ))
    let v6 := ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))
    (((Real.sin v2) * (((1.2 : ℝ) * (0.8 : ℝ)) - ((0.34 : ℝ) * v6))) < ((Real.cos v2) * (((1.2 : ℝ) * v6) + ((0.34 : ℝ) * (0.8 : ℝ))))) := rfl

theorem prop_slackHarmless_of_budget_ccc : prop_slackHarmless_of_budget = fun (f : ℝ) (ε : ℝ) (δ : ℝ) (h : ℝ) =>
    let v5 := (f * (Real.tan ε))
    ((v5 ≤ (h - δ)) → ((v5 + δ) ≤ h)) := rfl

theorem prop_slackHarmless_of_lever_ccc : prop_slackHarmless_of_lever = fun (f : ℝ) (ε : ℝ) (δ : ℝ) (rw : ℝ) (h : ℝ) =>
    let v6 := (f * (Real.tan ε))
    let v10 := ((((2 : ℝ) * f) * δ) / rw)
    ((v6 ≤ (h - v10)) → ((v6 + v10) ≤ h)) := rfl

theorem prop_slot_exit_hashemi_ccc : prop_slot_exit_hashemi =
    let v5 := ((0.8 : ℝ) / ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ)))
    (((0.960 : ℝ) < v5) ∧ (v5 < (0.9605 : ℝ))) := rfl

theorem prop_sq_bounds_neg_ccc : prop_sq_bounds_neg = fun (x : ℝ) (lo : ℝ) (hi : ℝ) =>
    let v3 := (x ^ 2)
    ((lo < x) → ((x < hi) → ((hi ≤ (0 : ℝ)) → (((hi ^ 2) < v3) ∧ (v3 < (lo ^ 2)))))) := rfl

theorem prop_sqrt32_bounds_ccc : prop_sqrt32_bounds =
    let v1 := (Real.sqrt (3.2 : ℝ))
    (((1.7888 : ℝ) < v1) ∧ (v1 < (1.78886 : ℝ))) := rfl

theorem prop_strut_resists_lean_ccc : prop_strut_resists_lean = fun (P : Fin 3 → ℝ) (Q : Fin 3 → ℝ) (δ : Fin 3 → ℝ) (ε : ℝ) =>
    (((0 : ℝ) < ε) → (((Q 0) < (P 0)) → (((δ 0) = (-ε)) → (((δ 1) = (0 : ℝ)) → (((δ 2) = (0 : ℝ)) → ((((((P 0) - (Q 0)) * (δ 0)) + (((P 1) - (Q 1)) * (δ 1))) + (((P 2) - (Q 2)) * (δ 2))) < (0 : ℝ))))))) := rfl

theorem prop_sunDir_rot_ccc : prop_sunDir_rot = fun (elSun : ℝ) (azSun : ℝ) (δ : ℝ) =>
    let v3 := (Real.cos elSun)
    let v4 := (azSun + δ)
    let v5 := (Real.sin elSun)
    let v6 := (Real.cos δ)
    let v8 := (v3 * (Real.cos azSun))
    let v10 := (v3 * (Real.sin azSun))
    let v11 := (Real.sin δ)
    (((v3 * (Real.cos v4)) = ((v6 * v8) - (v11 * v10))) ∧ (((v3 * (Real.sin v4)) = ((v11 * v8) + (v6 * v10))) ∧ (v5 = v5))) := rfl

theorem prop_sunInDish_equivariant_ccc : prop_sunInDish_equivariant = fun (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) (δ : ℝ) =>
    let v5 := (Real.sin t)
    let v6 := (az + δ)
    let v7 := (Real.cos v6)
    let v8 := (v5 * v7)
    let v9 := (Real.sin v6)
    let v10 := (v5 * v9)
    let v11 := (Real.cos t)
    let v12 := (v11 * v7)
    let v13 := (v11 * v9)
    let v14 := (-v5)
    let v15 := (Real.cos elSun)
    let v16 := (azSun + δ)
    let v18 := (v15 * (Real.cos v16))
    let v20 := (v15 * (Real.sin v16))
    let v21 := (Real.sin elSun)
    let v22 := (v14 * v21)
    let v23 := (v11 * v21)
    let v24 := (Real.cos az)
    let v25 := (v5 * v24)
    let v26 := (Real.sin az)
    let v27 := (v5 * v26)
    let v28 := (v11 * v24)
    let v29 := (v11 * v26)
    let v31 := (v15 * (Real.cos azSun))
    let v33 := (v15 * (Real.sin azSun))
    (((((((v13 * v11) - (v14 * v10)) * v18) + (((v14 * v8) - (v12 * v11)) * v20)) + (((v12 * v10) - (v13 * v8)) * v21)) = (((((v29 * v11) - (v14 * v27)) * v31) + (((v14 * v25) - (v28 * v11)) * v33)) + (((v28 * v27) - (v29 * v25)) * v21))) ∧ (((((v12 * v18) + (v13 * v20)) + v22) = (((v28 * v31) + (v29 * v33)) + v22)) ∧ ((((v8 * v18) + (v10 * v20)) + v23) = (((v25 * v31) + (v27 * v33)) + v23)))) := rfl

theorem prop_swingFocus_circle_ccc : prop_swingFocus_circle = fun (P : ℝ × ℝ) (d : ℝ) (f : ℝ) (t : ℝ) =>
    let v5 := (Real.sin t)
    let v6 := (Real.cos t)
    ((((((P.1 + (d * v5)) + (f * (-v5))) - P.1) ^ 2) + ((((P.2 - (d * v6)) + (f * v6)) - P.2) ^ 2)) = ((d - f) ^ 2)) := rfl

theorem prop_swingNormal_unit_ccc : prop_swingNormal_unit = fun (t : ℝ) =>
    ((((-(Real.sin t)) ^ 2) + ((Real.cos t) ^ 2)) = (1 : ℝ)) := rfl

theorem prop_swing_focusCircle_ccc : prop_swing_focusCircle = fun (P : ℝ × ℝ) (f : ℝ) (t : ℝ) =>
    (((((P.1 + (f * (Real.sin t))) - P.1) ^ 2) + (((P.2 - (f * (Real.cos t))) - P.2) ^ 2)) = (f ^ 2)) := rfl

theorem prop_swing_lift_ccc : prop_swing_lift = fun (apexH : ℝ) (zBolt : ℝ) (p : Fin 3 → ℝ) =>
    (((((1 : ℝ) * (p 1)) - ((0 : ℝ) * (p 0))) + ((apexH * (0 : ℝ)) - ((0 : ℝ) * (1 : ℝ)))) = (p 1)) := rfl

theorem prop_tension_le_of_holds_ccc : prop_tension_le_of_holds = fun (Tmax : ℝ) (W : ℝ) (rcm : ℝ) (rw : ℝ) (t : ℝ) =>
    let v5 := (W * rcm)
    (((0 : ℝ) ≤ W) → (((0 : ℝ) ≤ rcm) → (((0 : ℝ) < rw) → ((v5 ≤ (Tmax * rw)) → (((v5 * (Real.sin t)) / rw) ≤ Tmax))))) := rfl

theorem prop_trackerBudget_iff_ccc : prop_trackerBudget_iff = fun (f : ℝ) (ε : ℝ) (h : ℝ) =>
    let v3 := (Real.tan ε)
    (((0 : ℝ) < f) → (((f * v3) ≤ h) ↔ (v3 ≤ (h / f)))) := rfl

theorem prop_tracker_margin_hashemi_ccc : prop_tracker_margin_hashemi = fun (ε : ℝ) =>
    let v1 := (Real.tan ε)
    ((((1 : ℝ) * v1) ≤ (0.03 : ℝ)) ↔ (v1 ≤ (0.03 : ℝ))) := rfl

theorem prop_tracking_power_tiny_ccc : prop_tracking_power_tiny = fun (W : ℝ) (rcm : ℝ) (ω : ℝ) (t : ℝ) =>
    (((0 : ℝ) ≤ W) → ((W ≤ (1000 : ℝ)) → (((0 : ℝ) ≤ rcm) → ((rcm ≤ (1 : ℝ)) → (((0 : ℝ) ≤ ω) → ((ω ≤ (0.000073 : ℝ)) → (((((W * rcm) * (Real.sin t)) * ω) ≤ (0.073 : ℝ)) ∧ ((0.073 : ℝ) < ((0.015 : ℝ) * (5 : ℝ)))))))))) := rfl

theorem prop_wireLeft_at_ym_ccc : prop_wireLeft_at_ym =
    let v13 := ((Real.sqrt (((1.22 : ℝ) ^ 2) + ((0.34 : ℝ) ^ 2))) - (Real.sqrt ((5 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.36 : ℝ))))))
    (((0.111 : ℝ) < v13) ∧ (v13 < (0.113 : ℝ))) := rfl

theorem prop_wireLever_edge_formula_ccc : prop_wireLever_edge_formula = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v5 := (-ym)
    let v6 := (-a)
    let v7 := (Real.cos t)
    let v8 := (-ze)
    let v9 := (Real.sin t)
    let v12 := ((v6 * v7) + (v8 * v9))
    let v16 := (((-v6) * v9) + (v8 * v7))
    ((((v5 * v16) - (hp * v12)) / (Real.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) = (((((ym * ze) + (hp * a)) * v7) + (((hp * ze) - (ym * a)) * v9)) / (Real.sqrt ((((ym - (a * v7)) - (ze * v9)) ^ 2) + ((((a * v9) - (ze * v7)) - hp) ^ 2))))) := rfl

theorem prop_wireLever_pos_iff_ccc : prop_wireLever_pos_iff = fun (P : ℝ × ℝ) (B : ℝ × ℝ) =>
    let v8 := (((B.1 - P.1) ^ 2) + ((B.2 - P.2) ^ 2))
    let v11 := ((P.1 * B.2) - (P.2 * B.1))
    (((0 : ℝ) < v8) → (((0 : ℝ) < (v11 / (Real.sqrt v8))) ↔ ((0 : ℝ) < v11))) := rfl

theorem prop_wireLever_rest_ccc : prop_wireLever_rest = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) =>
    let v4 := (-ym)
    let v5 := (-a)
    let v7 := (Real.cos (0 : ℝ))
    let v8 := (-ze)
    let v9 := (Real.sin (0 : ℝ))
    let v12 := ((v5 * v7) + (v8 * v9))
    let v16 := (((-v5) * v9) + (v8 * v7))
    ((((v4 * v16) - (hp * v12)) / (Real.sqrt (((v12 - v4) ^ 2) + ((v16 - hp) ^ 2)))) = (((ym * ze) + (hp * a)) / (Real.sqrt (((ym - a) ^ 2) + ((hp + ze) ^ 2))))) := rfl

theorem prop_wireLever_rest_at_ym_ccc : prop_wireLever_rest_at_ym =
    let v3 := ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))
    let v16 := ((((1.22 : ℝ) * v3) + ((0.34 : ℝ) * (0.8 : ℝ))) / (Real.sqrt ((((1.22 : ℝ) - (0.8 : ℝ)) ^ 2) + (((0.34 : ℝ) + v3) ^ 2))))
    (((1.033 : ℝ) < v16) ∧ (v16 < (1.035 : ℝ))) := rfl

theorem prop_wireLever_sixty_at_ym_ccc : prop_wireLever_sixty_at_ym =
    let v1 := (-(1.22 : ℝ))
    let v3 := (-(0.8 : ℝ))
    let v6 := (Real.pi / (3 : ℝ))
    let v7 := (Real.cos v6)
    let v12 := (-((Real.sqrt (3.36 : ℝ)) - (1 : ℝ)))
    let v13 := (Real.sin v6)
    let v16 := ((v3 * v7) + (v12 * v13))
    let v20 := (((-v3) * v13) + (v12 * v7))
    let v31 := (((v1 * v20) - ((0.34 : ℝ) * v16)) / (Real.sqrt (((v16 - v1) ^ 2) + ((v20 - (0.34 : ℝ)) ^ 2))))
    (((0.37 : ℝ) < v31) ∧ (v31 < (0.38 : ℝ))) := rfl

theorem prop_wire_recip_swing_ccc : prop_wire_recip_swing = fun (apexH : ℝ) (zBolt : ℝ) (q : Fin 3 → ℝ) (f : Fin 3 → ℝ) =>
    let v9 := (apexH * (0 : ℝ))
    let v10 := ((q 1) * (f 2))
    ((((((((1 : ℝ) * (v10 - ((q 2) * (f 1)))) + ((0 : ℝ) * (((q 2) * (f 0)) - ((q 0) * (f 2))))) + ((0 : ℝ) * (((q 0) * (f 1)) - ((q 1) * (f 0))))) + ((((0 : ℝ) * (0 : ℝ)) - (zBolt * (0 : ℝ))) * (f 0))) + (((zBolt * (1 : ℝ)) - v9) * (f 1))) + ((v9 - ((0 : ℝ) * (1 : ℝ))) * (f 2))) = (v10 - (((q 2) - zBolt) * (f 1)))) := rfl

theorem prop_wire_short_of_vertical_ccc : prop_wire_short_of_vertical =
    ((((0.34 : ℝ) * ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))) - ((1.22 : ℝ) * (0.8 : ℝ))) < (0 : ℝ)) := rfl

theorem prop_wire_taut_iff_ccc : prop_wire_taut_iff = fun (W : ℝ) (rcm : ℝ) (rw : ℝ) (t : ℝ) =>
    let v4 := (Real.sin t)
    (((0 : ℝ) < W) → (((0 : ℝ) < rcm) → (((0 : ℝ) < rw) → (((0 : ℝ) ≤ (((W * rcm) * v4) / rw)) ↔ ((0 : ℝ) ≤ v4))))) := rfl

theorem prop_yaw_lifts_nothing_ccc : prop_yaw_lifts_nothing = fun (p : Fin 3 → ℝ) =>
    (((((0 : ℝ) * (p 1)) - ((0 : ℝ) * (p 0))) + (0 : ℝ)) = (0 : ℝ)) := rfl

theorem prop_ym_is_standStation_ccc : prop_ym_is_standStation =
    ((1.22 : ℝ) = (1.22 : ℝ)) := rfl

theorem pulleyAt_ccc : pulleyAt = fun (ym : ℝ) (hp : ℝ) =>
    ((-ym), hp) := rfl

theorem pumpCmd_ccc : pumpCmd = fun (u : ℝ) =>
    (min (max ((u + (1 : ℝ)) / (2 : ℝ)) (0 : ℝ)) (1 : ℝ)) := rfl

theorem pumpCostRaw_ccc : pumpCostRaw = fun (dt : ℝ) (pPump : ℝ) (pumpPrice : ℝ) (rotiReward : ℝ) (rotiEnergy : ℝ) =>
    ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : ℝ) pPump)) := rfl

theorem pumpElec_ccc : pumpElec = fun (Q : ℝ) (D : ℝ) (L : ℝ) (T : ℝ) (η : ℝ) (Pidle : ℝ) =>
    let v7 := (D ^ 2)
    let v11 := (Q / ((Real.pi * v7) / (4 : ℝ)))
    let v13 := (T - (273.15 : ℝ))
    let v21 := (((1020.62 : ℝ) - ((0.614254 : ℝ) * v13)) - ((0.000321 : ℝ) * (v13 ^ 2)))
    let v32 := ((Real.exp (((586.375 : ℝ) / (v13 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ))
    let v33 := (((v21 * v11) * D) / v32)
    ((((if (v33 < (2300 : ℝ)) then (((((32 : ℝ) * v32) * L) * v11) / v7) else ((((((0.3164 : ℝ) / (Real.sqrt (Real.sqrt (max v33 (1 : ℝ))))) * (L / D)) * v21) * (v11 ^ 2)) / (2 : ℝ))) * Q) / η) + (if ((0 : ℝ) < Q) then Pidle else (0 : ℝ))) := rfl

theorem pumpHyd_ccc : pumpHyd = fun (Q : ℝ) (D : ℝ) (L : ℝ) (T : ℝ) =>
    let v5 := (D ^ 2)
    let v9 := (Q / ((Real.pi * v5) / (4 : ℝ)))
    let v11 := (T - (273.15 : ℝ))
    let v19 := (((1020.62 : ℝ) - ((0.614254 : ℝ) * v11)) - ((0.000321 : ℝ) * (v11 ^ 2)))
    let v30 := ((Real.exp (((586.375 : ℝ) / (v11 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ))
    let v31 := (((v19 * v9) * D) / v30)
    ((if (v31 < (2300 : ℝ)) then (((((32 : ℝ) * v30) * L) * v9) / v5) else ((((((0.3164 : ℝ) / (Real.sqrt (Real.sqrt (max v31 (1 : ℝ))))) * (L / D)) * v19) * (v9 ^ 2)) / (2 : ℝ))) * Q) := rfl

theorem pumpOf_ccc : pumpOf =
    ![(0 : ℝ), ((1 : ℝ) / (6 : ℝ)), ((2 : ℝ) / (6 : ℝ)), ((3 : ℝ) / (6 : ℝ)), ((4 : ℝ) / (6 : ℝ)), ((5 : ℝ) / (6 : ℝ)), (1 : ℝ)] := rfl

theorem qAbs_ccc : qAbs = fun (α : ℝ) (Pin : ℝ) =>
    (α * Pin) := rfl

theorem qCoilLoss_ccc : qCoilLoss = fun (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Toil : ℝ) (Ta : ℝ) =>
    ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * (Toil - Ta))) := rfl

theorem qCoilLossW_ccc : qCoilLossW = fun (ε : ℝ) (Ac : ℝ) (V : ℝ) (Toil : ℝ) (Ta : ℝ) =>
    ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((((5.7 : ℝ) + ((3.8 : ℝ) * V)) * Ac) * (Toil - Ta))) := rfl

theorem qNet_ccc : qNet = fun (α : ℝ) (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Upipe : ℝ) (UAx : ℝ) (Pin : ℝ) (Toil : ℝ) (Twall : ℝ) (Ta : ℝ) =>
    let v19 := (Toil - Ta)
    ((((α * Pin) - ((((ε * (0.0000000567 : ℝ)) * Ac) * ((Toil ^ 4) - (Ta ^ 4))) + ((hC * Ac) * v19))) - (Upipe * v19)) - (max (0 : ℝ) (UAx * (Toil - Twall)))) := rfl

theorem qPipe_ccc : qPipe = fun (Upipe : ℝ) (Toil : ℝ) (Ta : ℝ) =>
    (Upipe * (Toil - Ta)) := rfl

theorem qPot_ccc : qPot = fun (UAx : ℝ) (Toil : ℝ) (Twall : ℝ) =>
    (max (0 : ℝ) (UAx * (Toil - Twall))) := rfl

theorem radCeil_ccc : radCeil = fun (ε : ℝ) (qFlux : ℝ) (Ta : ℝ) =>
    (Real.sqrt (Real.sqrt (((max (0 : ℝ) qFlux) / ((max ε (0.01 : ℝ)) * (0.0000000567 : ℝ))) + ((max Ta (0 : ℝ)) ^ 4)))) := rfl

theorem reCrit_ccc : reCrit =
    (2300 : ℝ) := rfl

theorem recip_ccc : recip = fun (t : TandoorHashemi.Screw) (w : TandoorHashemi.Screw) =>
    (((((((t 0) * (w 3)) + ((t 1) * (w 4))) + ((t 2) * (w 5))) + ((t 3) * (w 0))) + ((t 4) * (w 1))) + ((t 5) * (w 2))) := rfl

theorem reflect3_ccc : reflect3 = fun (n : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v12 := ((2 : ℝ) * ((((d 0) * (n 0)) + ((d 1) * (n 1))) + ((d 2) * (n 2))))
    ![((d 0) - (v12 * (n 0))), ((d 1) - (v12 * (n 1))), ((d 2) - (v12 * (n 2)))] := rfl

theorem rewardShapeRaw_ccc : rewardShapeRaw = fun (dt : ℝ) (pIn : ℝ) (reach : ℝ) (capShaping : ℝ) (rotiReward : ℝ) (rotiEnergy : ℝ) =>
    (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach) := rfl

theorem rewardStep_ccc : rewardStep = fun (parentRaw : ℝ) (dt : ℝ) (pIn : ℝ) (reach : ℝ) (rewardDiv : ℝ) (capShaping : ℝ) (rotiReward : ℝ) (rotiEnergy : ℝ) (pPump : ℝ) (filmExcess : ℝ) (pumpPrice : ℝ) (degPrice : ℝ) =>
    ![(((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach), ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : ℝ) pPump)), (((degPrice * rotiReward) * dt) * (max (0 : ℝ) filmExcess)), (((parentRaw + (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)) - ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : ℝ) pPump))) - (((degPrice * rotiReward) * dt) * (max (0 : ℝ) filmExcess))), ((((parentRaw + (((((capShaping * rotiReward) * dt) / rotiEnergy) * pIn) * reach)) - ((((pumpPrice * rotiReward) * dt) / rotiEnergy) * (max (0 : ℝ) pPump))) - (((degPrice * rotiReward) * dt) * (max (0 : ℝ) filmExcess))) / rewardDiv)] := rfl

theorem reynolds_ccc : reynolds = fun (Q : ℝ) (D : ℝ) (T : ℝ) =>
    let v4 := (T - (273.15 : ℝ))
    ((((((1020.62 : ℝ) - ((0.614254 : ℝ) * v4)) - ((0.000321 : ℝ) * (v4 ^ 2))) * (Q / ((Real.pi * (D ^ 2)) / (4 : ℝ)))) * D) / ((Real.exp (((586.375 : ℝ) / (v4 + (62.5 : ℝ))) - (2.2809 : ℝ))) / (1000 : ℝ))) := rfl

theorem rhoCu_ccc : rhoCu =
    (0.0000000172 : ℝ) := rfl

theorem rodTan_ccc : rodTan =
    ((0.4 : ℝ) / ((Real.sqrt (3.2 : ℝ)) - (1 : ℝ))) := rfl

theorem rollY_ccc : rollY = fun (p : Fin 3 → ℝ) =>
    let v5 := ((p 1) * (0 : ℝ))
    ![(0 : ℝ), (1 : ℝ), (0 : ℝ), (v5 - ((p 2) * (1 : ℝ))), (((p 2) * (0 : ℝ)) - ((p 0) * (0 : ℝ))), (((p 0) * (1 : ℝ)) - v5)] := rfl

theorem rollerRadius_ccc : rollerRadius = fun (c : TandoorHashemi.Carriage) =>
    (Real.sqrt (((c.chord / (2 : ℝ)) ^ 2) + (c.apexH ^ 2))) := rfl

theorem rot_ccc : rot = fun (ψ : ℝ) (p : ℝ × ℝ) =>
    let v3 := (Real.cos ψ)
    let v5 := (Real.sin ψ)
    (((v3 * p.1) - (v5 * p.2)), ((v5 * p.1) + (v3 * p.2))) := rfl

theorem rotz_ccc : rotz = fun (δ : ℝ) (v : Fin 3 → ℝ) =>
    let v4 := (Real.cos δ)
    let v6 := (Real.sin δ)
    ![((v4 * (v 0)) - (v6 * (v 1))), ((v6 * (v 0)) + (v4 * (v 1))), (v 2)] := rfl

theorem sampleRay_ccc : sampleRay = fun (a : ℝ) (w : ℝ) (hsun : ℝ) (sd : Fin 3 → ℝ) (u1 : ℝ) (u2 : ℝ) (u3 : ℝ) (u4 : ℝ) (u5 : ℝ) (u6 : ℝ) =>
    let v14 := (((2 : ℝ) * a) / w)
    let v17 := ((-a) + (w / (2 : ℝ)))
    let v27 := ((1 : ℝ) / (2 : ℝ))
    let v32 := (-(sd 0))
    let v33 := (-(sd 1))
    let v34 := (-(sd 2))
    let v39 := (|v34| < ((9 : ℝ) / (10 : ℝ)))
    let v41 := (if v39 then (0 : ℝ) else (1 : ℝ))
    let v42 := (if v39 then (1 : ℝ) else (0 : ℝ))
    let v45 := ((v33 * v42) - (v34 * (0 : ℝ)))
    let v48 := ((v34 * v41) - (v32 * v42))
    let v51 := ((v32 * (0 : ℝ)) - (v33 * v41))
    let v59 := (Real.sqrt (max (((v45 ^ 2) + (v48 ^ 2)) + (v51 ^ 2)) (0.000000000000000001 : ℝ)))
    let v60 := (v45 / v59)
    let v61 := (v48 / v59)
    let v62 := (v51 / v59)
    let v73 := (hsun * (Real.sqrt u5))
    let v76 := (((2 : ℝ) * Real.pi) * u6)
    let v77 := (Real.cos v73)
    let v79 := (Real.sin v73)
    let v80 := (Real.cos v76)
    let v82 := (Real.sin v76)
    ![(v17 + (w * ((⌊(u1 * v14)⌋ : ℤ) : ℝ))), (v17 + (w * ((⌊(u2 * v14)⌋ : ℤ) : ℝ))), ((u3 - v27) * w), ((u4 - v27) * w), ((v77 * v32) + (v79 * ((v80 * v60) + (v82 * ((v33 * v62) - (v34 * v61)))))), ((v77 * v33) + (v79 * ((v80 * v61) + (v82 * ((v34 * v60) - (v32 * v62)))))), ((v77 * v34) + (v79 * ((v80 * v62) + (v82 * ((v32 * v61) - (v33 * v60))))))] := rfl

theorem screwLength_ccc : screwLength = fun (R : ℝ) (a : ℝ) =>
    ((R / (2 : ℝ)) - (R - (Real.sqrt ((R ^ 2) - (a ^ 2))))) := rfl

theorem screwTwist_ccc : screwTwist = fun (h : ℝ) (zBolt : ℝ) =>
    ![(1 : ℝ), (0 : ℝ), (0 : ℝ), h, zBolt, (0 : ℝ)] := rfl

theorem screwWrench_ccc : screwWrench = fun (xh : ℝ) (zBolt : ℝ) (h : ℝ) =>
    let v5 := ((0 : ℝ) * (0 : ℝ))
    let v8 := (zBolt * (0 : ℝ))
    let v9 := (xh * (0 : ℝ))
    let v11 := (xh * (1 : ℝ))
    ![![(0 : ℝ), (1 : ℝ), (0 : ℝ), (v5 - (zBolt * (1 : ℝ))), (v8 - v9), (v11 - v5)], ![(0 : ℝ), (0 : ℝ), (1 : ℝ), (((0 : ℝ) * (1 : ℝ)) - v8), (v8 - v11), (v9 - v5)], ![(0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (1 : ℝ), (0 : ℝ)], ![(0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ), (1 : ℝ)], ![(1 : ℝ), (0 : ℝ), (0 : ℝ), (-h), zBolt, (0 : ℝ)]] := rfl

theorem secondaryMag_ccc : secondaryMag = fun (L : ℝ) (dm : ℝ) =>
    ((L - dm) / dm) := rfl

theorem setLength_ccc : setLength = fun (rod : ℝ) (excess : ℝ) =>
    (rod - excess) := rfl

theorem shift_ccc : shift = fun (x : ℝ) (h : Fin 16 → ℝ) =>
    ![x, (h 0), (h 1), (h 2), (h 3), (h 4), (h 5), (h 6), (h 7), (h 8), (h 9), (h 10), (h 11), (h 12), (h 13), (h 14)] := rfl

theorem sideGap_ccc : sideGap =
    (((1.84 : ℝ) - ((2 : ℝ) * (0.8 : ℝ))) / (2 : ℝ)) := rfl

theorem sigmaSB_ccc : sigmaSB =
    (0.0000000567 : ℝ) := rfl

theorem slackSpot_ccc : slackSpot = fun (f : ℝ) (δ : ℝ) (rw : ℝ) =>
    ((((2 : ℝ) * f) * δ) / rw) := rfl

theorem slotExit_ccc : slotExit = fun (a : ℝ) (ze : ℝ) =>
    (Real.arctan (a / ze)) := rfl

theorem sphereBestFocus_ccc : sphereBestFocus = fun (R : ℝ) (H : ℝ) =>
    (((R / (2 : ℝ)) + (R / ((2 : ℝ) * (Real.sqrt ((1 : ℝ) - ((H / R) ^ 2)))))) / (2 : ℝ)) := rfl

theorem sphereBlur_ccc : sphereBlur = fun (R : ℝ) (H : ℝ) =>
    let v4 := (H / R)
    let v13 := (v4 ^ 2)
    (((R / (2 : ℝ)) - (R - (R / ((2 : ℝ) * (Real.cos (Real.arcsin v4)))))) * ((((2 : ℝ) * v4) * (Real.sqrt ((1 : ℝ) - v13))) / ((1 : ℝ) - ((2 : ℝ) * v13)))) := rfl

theorem sphereDev_ccc : sphereDev = fun (R : ℝ) (h : ℝ) (p : ℝ) =>
    let v5 := (h / R)
    let v6 := (v5 ^ 2)
    let v8 := (Real.sqrt ((1 : ℝ) - v6))
    (((R / ((2 : ℝ) * v8)) - p) * ((((2 : ℝ) * v5) * v8) / ((1 : ℝ) - ((2 : ℝ) * v6)))) := rfl

theorem sphereFocal_ccc : sphereFocal = fun (R : ℝ) (h : ℝ) =>
    (R - (R / ((2 : ℝ) * (Real.cos (Real.arcsin (h / R)))))) := rfl

theorem sphereHit_ccc : sphereHit = fun (R : ℝ) (O : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v7 := ((O 2) - R)
    let v12 := ((((d 0) * (O 0)) + ((d 1) * (O 1))) + ((d 2) * v7))
    let v24 := ((-v12) + (Real.sqrt ((v12 ^ 2) - (((((O 0) ^ 2) + ((O 1) ^ 2)) + (v7 ^ 2)) - (R ^ 2)))))
    (![((O 0) + (v24 * (d 0))), ((O 1) + (v24 * (d 1))), ((O 2) + (v24 * (d 2)))], ![((-((O 0) + (v24 * (d 0)))) / R), ((-((O 1) + (v24 * (d 1)))) / R), ((R - ((O 2) + (v24 * (d 2)))) / R)]) := rfl

theorem spotTau_ccc : spotTau =
    (0.005 : ℝ) := rfl

theorem step_ccc : step = fun (az : ℝ) (t : ℝ) (slack : ℝ) (ωm : ℝ) (ωd : ℝ) (dt : ℝ) (rw : ℝ) (R : ℝ) (rDrum : ℝ) (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (W : ℝ) (rcm : ℝ) (Tmax : ℝ) =>
    let v16 := (ym * a)
    let v17 := (hp * ze)
    let v28 := (if (v16 ≤ v17) then (Real.pi / (2 : ℝ)) else (Real.arctan (((ym * ze) + (hp * a)) / (v16 - v17))))
    let v29 := (-ym)
    let v30 := (-a)
    let v32 := (Real.cos (0 : ℝ))
    let v34 := (-ze)
    let v35 := (Real.sin (0 : ℝ))
    let v38 := (-v30)
    let v47 := (Real.sqrt (((((v30 * v32) + (v34 * v35)) - v29) ^ 2) + ((((v38 * v35) + (v34 * v32)) - hp) ^ 2)))
    let v48 := (Real.cos v28)
    let v50 := (Real.sin v28)
    let v61 := (Real.sqrt (((((v30 * v48) + (v34 * v50)) - v29) ^ 2) + ((((v38 * v50) + (v34 * v48)) - hp) ^ 2)))
    let v62 := (Real.cos t)
    let v64 := (Real.sin t)
    let v75 := (Real.sqrt (((((v30 * v62) + (v34 * v64)) - v29) ^ 2) + ((((v38 * v64) + (v34 * v62)) - hp) ^ 2)))
    let v79 := ((v75 + slack) - ((ωd * rDrum) * dt))
    let v80 := (v79 < v61)
    let v81 := (v47 < v79)
    let v83 := (if v80 then v61 else (if v81 then v47 else v79))
    let v88 := (((0 : ℝ) + v28) / (2 : ℝ))
    let v89 := (Real.cos v88)
    let v91 := (Real.sin v88)
    let v103 := (v83 < (Real.sqrt (((((v30 * v89) + (v34 * v91)) - v29) ^ 2) + ((((v38 * v91) + (v34 * v89)) - hp) ^ 2))))
    let v104 := (if v103 then v88 else (0 : ℝ))
    let v105 := (if v103 then v28 else v88)
    let v107 := ((v104 + v105) / (2 : ℝ))
    let v108 := (Real.cos v107)
    let v110 := (Real.sin v107)
    let v122 := (v83 < (Real.sqrt (((((v30 * v108) + (v34 * v110)) - v29) ^ 2) + ((((v38 * v110) + (v34 * v108)) - hp) ^ 2))))
    let v123 := (if v122 then v107 else v104)
    let v124 := (if v122 then v105 else v107)
    let v126 := ((v123 + v124) / (2 : ℝ))
    let v127 := (Real.cos v126)
    let v129 := (Real.sin v126)
    let v141 := (v83 < (Real.sqrt (((((v30 * v127) + (v34 * v129)) - v29) ^ 2) + ((((v38 * v129) + (v34 * v127)) - hp) ^ 2))))
    let v142 := (if v141 then v126 else v123)
    let v143 := (if v141 then v124 else v126)
    let v145 := ((v142 + v143) / (2 : ℝ))
    let v146 := (Real.cos v145)
    let v148 := (Real.sin v145)
    let v160 := (v83 < (Real.sqrt (((((v30 * v146) + (v34 * v148)) - v29) ^ 2) + ((((v38 * v148) + (v34 * v146)) - hp) ^ 2))))
    let v161 := (if v160 then v145 else v142)
    let v162 := (if v160 then v143 else v145)
    let v164 := ((v161 + v162) / (2 : ℝ))
    let v165 := (Real.cos v164)
    let v167 := (Real.sin v164)
    let v179 := (v83 < (Real.sqrt (((((v30 * v165) + (v34 * v167)) - v29) ^ 2) + ((((v38 * v167) + (v34 * v165)) - hp) ^ 2))))
    let v180 := (if v179 then v164 else v161)
    let v181 := (if v179 then v162 else v164)
    let v183 := ((v180 + v181) / (2 : ℝ))
    let v184 := (Real.cos v183)
    let v186 := (Real.sin v183)
    let v198 := (v83 < (Real.sqrt (((((v30 * v184) + (v34 * v186)) - v29) ^ 2) + ((((v38 * v186) + (v34 * v184)) - hp) ^ 2))))
    let v199 := (if v198 then v183 else v180)
    let v200 := (if v198 then v181 else v183)
    let v202 := ((v199 + v200) / (2 : ℝ))
    let v203 := (Real.cos v202)
    let v205 := (Real.sin v202)
    let v217 := (v83 < (Real.sqrt (((((v30 * v203) + (v34 * v205)) - v29) ^ 2) + ((((v38 * v205) + (v34 * v203)) - hp) ^ 2))))
    let v218 := (if v217 then v202 else v199)
    let v219 := (if v217 then v200 else v202)
    let v221 := ((v218 + v219) / (2 : ℝ))
    let v222 := (Real.cos v221)
    let v224 := (Real.sin v221)
    let v236 := (v83 < (Real.sqrt (((((v30 * v222) + (v34 * v224)) - v29) ^ 2) + ((((v38 * v224) + (v34 * v222)) - hp) ^ 2))))
    let v237 := (if v236 then v221 else v218)
    let v238 := (if v236 then v219 else v221)
    let v240 := ((v237 + v238) / (2 : ℝ))
    let v241 := (Real.cos v240)
    let v243 := (Real.sin v240)
    let v255 := (v83 < (Real.sqrt (((((v30 * v241) + (v34 * v243)) - v29) ^ 2) + ((((v38 * v243) + (v34 * v241)) - hp) ^ 2))))
    let v256 := (if v255 then v240 else v237)
    let v257 := (if v255 then v238 else v240)
    let v259 := ((v256 + v257) / (2 : ℝ))
    let v260 := (Real.cos v259)
    let v262 := (Real.sin v259)
    let v274 := (v83 < (Real.sqrt (((((v30 * v260) + (v34 * v262)) - v29) ^ 2) + ((((v38 * v262) + (v34 * v260)) - hp) ^ 2))))
    let v275 := (if v274 then v259 else v256)
    let v276 := (if v274 then v257 else v259)
    let v278 := ((v275 + v276) / (2 : ℝ))
    let v279 := (Real.cos v278)
    let v281 := (Real.sin v278)
    let v293 := (v83 < (Real.sqrt (((((v30 * v279) + (v34 * v281)) - v29) ^ 2) + ((((v38 * v281) + (v34 * v279)) - hp) ^ 2))))
    let v294 := (if v293 then v278 else v275)
    let v295 := (if v293 then v276 else v278)
    let v297 := ((v294 + v295) / (2 : ℝ))
    let v298 := (Real.cos v297)
    let v300 := (Real.sin v297)
    let v312 := (v83 < (Real.sqrt (((((v30 * v298) + (v34 * v300)) - v29) ^ 2) + ((((v38 * v300) + (v34 * v298)) - hp) ^ 2))))
    let v313 := (if v312 then v297 else v294)
    let v314 := (if v312 then v295 else v297)
    let v316 := ((v313 + v314) / (2 : ℝ))
    let v317 := (Real.cos v316)
    let v319 := (Real.sin v316)
    let v331 := (v83 < (Real.sqrt (((((v30 * v317) + (v34 * v319)) - v29) ^ 2) + ((((v38 * v319) + (v34 * v317)) - hp) ^ 2))))
    let v332 := (if v331 then v316 else v313)
    let v333 := (if v331 then v314 else v316)
    let v335 := ((v332 + v333) / (2 : ℝ))
    let v336 := (Real.cos v335)
    let v338 := (Real.sin v335)
    let v350 := (v83 < (Real.sqrt (((((v30 * v336) + (v34 * v338)) - v29) ^ 2) + ((((v38 * v338) + (v34 * v336)) - hp) ^ 2))))
    let v351 := (if v350 then v335 else v332)
    let v352 := (if v350 then v333 else v335)
    let v354 := ((v351 + v352) / (2 : ℝ))
    let v355 := (Real.cos v354)
    let v357 := (Real.sin v354)
    let v369 := (v83 < (Real.sqrt (((((v30 * v355) + (v34 * v357)) - v29) ^ 2) + ((((v38 * v357) + (v34 * v355)) - hp) ^ 2))))
    let v370 := (if v369 then v354 else v351)
    let v371 := (if v369 then v352 else v354)
    let v373 := ((v370 + v371) / (2 : ℝ))
    let v374 := (Real.cos v373)
    let v376 := (Real.sin v373)
    let v388 := (v83 < (Real.sqrt (((((v30 * v374) + (v34 * v376)) - v29) ^ 2) + ((((v38 * v376) + (v34 * v374)) - hp) ^ 2))))
    let v389 := (if v388 then v373 else v370)
    let v390 := (if v388 then v371 else v373)
    let v392 := ((v389 + v390) / (2 : ℝ))
    let v393 := (Real.cos v392)
    let v395 := (Real.sin v392)
    let v407 := (v83 < (Real.sqrt (((((v30 * v393) + (v34 * v395)) - v29) ^ 2) + ((((v38 * v395) + (v34 * v393)) - hp) ^ 2))))
    let v408 := (if v407 then v392 else v389)
    let v409 := (if v407 then v390 else v392)
    let v411 := ((v408 + v409) / (2 : ℝ))
    let v412 := (Real.cos v411)
    let v414 := (Real.sin v411)
    let v426 := (v83 < (Real.sqrt (((((v30 * v412) + (v34 * v414)) - v29) ^ 2) + ((((v38 * v414) + (v34 * v412)) - hp) ^ 2))))
    let v427 := (if v426 then v411 else v408)
    let v428 := (if v426 then v409 else v411)
    let v430 := ((v427 + v428) / (2 : ℝ))
    let v431 := (Real.cos v430)
    let v433 := (Real.sin v430)
    let v445 := (v83 < (Real.sqrt (((((v30 * v431) + (v34 * v433)) - v29) ^ 2) + ((((v38 * v433) + (v34 * v431)) - hp) ^ 2))))
    let v446 := (if v445 then v430 else v427)
    let v447 := (if v445 then v428 else v430)
    let v449 := ((v446 + v447) / (2 : ℝ))
    let v450 := (Real.cos v449)
    let v452 := (Real.sin v449)
    let v464 := (v83 < (Real.sqrt (((((v30 * v450) + (v34 * v452)) - v29) ^ 2) + ((((v38 * v452) + (v34 * v450)) - hp) ^ 2))))
    let v465 := (if v464 then v449 else v446)
    let v466 := (if v464 then v447 else v449)
    let v468 := ((v465 + v466) / (2 : ℝ))
    let v469 := (Real.cos v468)
    let v471 := (Real.sin v468)
    let v483 := (v83 < (Real.sqrt (((((v30 * v469) + (v34 * v471)) - v29) ^ 2) + ((((v38 * v471) + (v34 * v469)) - hp) ^ 2))))
    let v484 := (if v483 then v468 else v465)
    let v485 := (if v483 then v466 else v468)
    let v487 := ((v484 + v485) / (2 : ℝ))
    let v488 := (Real.cos v487)
    let v490 := (Real.sin v487)
    let v502 := (v83 < (Real.sqrt (((((v30 * v488) + (v34 * v490)) - v29) ^ 2) + ((((v38 * v490) + (v34 * v488)) - hp) ^ 2))))
    let v503 := (if v502 then v487 else v484)
    let v504 := (if v502 then v485 else v487)
    let v506 := ((v503 + v504) / (2 : ℝ))
    let v507 := (Real.cos v506)
    let v509 := (Real.sin v506)
    let v521 := (v83 < (Real.sqrt (((((v30 * v507) + (v34 * v509)) - v29) ^ 2) + ((((v38 * v509) + (v34 * v507)) - hp) ^ 2))))
    let v522 := (if v521 then v506 else v503)
    let v523 := (if v521 then v504 else v506)
    let v525 := ((v522 + v523) / (2 : ℝ))
    let v526 := (Real.cos v525)
    let v528 := (Real.sin v525)
    let v540 := (v83 < (Real.sqrt (((((v30 * v526) + (v34 * v528)) - v29) ^ 2) + ((((v38 * v528) + (v34 * v526)) - hp) ^ 2))))
    let v545 := (if (v47 ≤ v79) then (0 : ℝ) else (((if v540 then v525 else v522) + (if v540 then v523 else v525)) / (2 : ℝ)))
    let v546 := (W * rcm)
    let v547 := (Real.cos v545)
    let v549 := (Real.sin v545)
    let v551 := ((v30 * v547) + (v34 * v549))
    let v554 := ((v38 * v549) + (v34 * v547))
    let v569 := ((t < v545) ∧ (¬ (v546 ≤ (Tmax * (((v29 * v554) - (hp * v551)) / (Real.sqrt (((v551 - v29) ^ 2) + ((v554 - hp) ^ 2))))))))
    let v570 := (if v569 then t else v545)
    let v581 := (Real.cos v570)
    let v583 := (Real.sin v570)
    let v585 := ((v30 * v581) + (v34 * v583))
    let v588 := ((v38 * v583) + (v34 * v581))
    ![(az + (((ωm * rw) / R) * dt)), v570, (if v81 then (v79 - v47) else (0 : ℝ)), (if v569 then v75 else v83), v28, (if (v80 ∨ v569) then (1 : ℝ) else (0 : ℝ)), (if ((if v81 then (v79 - v47) else (0 : ℝ)) = (0 : ℝ)) then (1 : ℝ) else (0 : ℝ)), (@ite _ (v546 ≤ (Tmax * (((v29 * v588) - (hp * v585)) / (Real.sqrt (((v585 - v29) ^ 2) + ((v588 - hp) ^ 2)))))) (Classical.propDecidable _) (1 : ℝ) (0 : ℝ))]:= by
  funext az t slack ωm ωd dt rw R rDrum ym hp a ze W rcm Tmax
  rewrite [step]
  lift_lets
  intro v16 v17 v28 v29 v30 v32 v34 v35 v38 v47 v48 v50 v61 v62 v64 v75 v79 v80 v81 v83 v88 v89 v91 v103 v104 v105 v107 v108 v110 v122 v123 v124 v126 v127 v129 v141 v142 v143 v145 v146 v148 v160 v161 v162 v164 v165 v167 v179 v180 v181 v183 v184 v186 v198 v199 v200 v202 v203 v205 v217 v218 v219 v221 v222 v224 v236 v237 v238 v240 v241 v243 v255 v256 v257 v259 v260 v262 v274 v275 v276 v278 v279 v281 v293 v294 v295 v297 v298 v300 v312 v313 v314 v316 v317 v319 v331 v332 v333 v335 v336 v338 v350 v351 v352 v354 v355 v357 v369 v370 v371 v373 v374 v376 v388 v389 v390 v392 v393 v395 v407 v408 v409 v411 v412 v414 v426 v427 v428 v430 v431 v433 v445 v446 v447 v449 v450 v452 v464 v465 v466 v468 v469 v471 v483 v484 v485 v487 v488 v490 v502 v503 v504 v506 v507 v509 v521 v522 v523 v525 v526 v528 v540 v545 v546 v547 v549 v551 v554 v569 v570 v581 v583 v585 v588
  have e0 : (bisectStep ym hp a ze v83)^[1] ((0 : ℝ), v28) = (v104, v105) := rfl
  have e1 : (bisectStep ym hp a ze v83)^[2] ((0 : ℝ), v28) = (v123, v124) := by
    rewrite [show (2 : ℕ) = 1 + 1 from rfl, Function.iterate_succ_apply', e0]
    rfl
  have e2 : (bisectStep ym hp a ze v83)^[3] ((0 : ℝ), v28) = (v142, v143) := by
    rewrite [show (3 : ℕ) = 2 + 1 from rfl, Function.iterate_succ_apply', e1]
    rfl
  have e3 : (bisectStep ym hp a ze v83)^[4] ((0 : ℝ), v28) = (v161, v162) := by
    rewrite [show (4 : ℕ) = 3 + 1 from rfl, Function.iterate_succ_apply', e2]
    rfl
  have e4 : (bisectStep ym hp a ze v83)^[5] ((0 : ℝ), v28) = (v180, v181) := by
    rewrite [show (5 : ℕ) = 4 + 1 from rfl, Function.iterate_succ_apply', e3]
    rfl
  have e5 : (bisectStep ym hp a ze v83)^[6] ((0 : ℝ), v28) = (v199, v200) := by
    rewrite [show (6 : ℕ) = 5 + 1 from rfl, Function.iterate_succ_apply', e4]
    rfl
  have e6 : (bisectStep ym hp a ze v83)^[7] ((0 : ℝ), v28) = (v218, v219) := by
    rewrite [show (7 : ℕ) = 6 + 1 from rfl, Function.iterate_succ_apply', e5]
    rfl
  have e7 : (bisectStep ym hp a ze v83)^[8] ((0 : ℝ), v28) = (v237, v238) := by
    rewrite [show (8 : ℕ) = 7 + 1 from rfl, Function.iterate_succ_apply', e6]
    rfl
  have e8 : (bisectStep ym hp a ze v83)^[9] ((0 : ℝ), v28) = (v256, v257) := by
    rewrite [show (9 : ℕ) = 8 + 1 from rfl, Function.iterate_succ_apply', e7]
    rfl
  have e9 : (bisectStep ym hp a ze v83)^[10] ((0 : ℝ), v28) = (v275, v276) := by
    rewrite [show (10 : ℕ) = 9 + 1 from rfl, Function.iterate_succ_apply', e8]
    rfl
  have e10 : (bisectStep ym hp a ze v83)^[11] ((0 : ℝ), v28) = (v294, v295) := by
    rewrite [show (11 : ℕ) = 10 + 1 from rfl, Function.iterate_succ_apply', e9]
    rfl
  have e11 : (bisectStep ym hp a ze v83)^[12] ((0 : ℝ), v28) = (v313, v314) := by
    rewrite [show (12 : ℕ) = 11 + 1 from rfl, Function.iterate_succ_apply', e10]
    rfl
  have e12 : (bisectStep ym hp a ze v83)^[13] ((0 : ℝ), v28) = (v332, v333) := by
    rewrite [show (13 : ℕ) = 12 + 1 from rfl, Function.iterate_succ_apply', e11]
    rfl
  have e13 : (bisectStep ym hp a ze v83)^[14] ((0 : ℝ), v28) = (v351, v352) := by
    rewrite [show (14 : ℕ) = 13 + 1 from rfl, Function.iterate_succ_apply', e12]
    rfl
  have e14 : (bisectStep ym hp a ze v83)^[15] ((0 : ℝ), v28) = (v370, v371) := by
    rewrite [show (15 : ℕ) = 14 + 1 from rfl, Function.iterate_succ_apply', e13]
    rfl
  have e15 : (bisectStep ym hp a ze v83)^[16] ((0 : ℝ), v28) = (v389, v390) := by
    rewrite [show (16 : ℕ) = 15 + 1 from rfl, Function.iterate_succ_apply', e14]
    rfl
  have e16 : (bisectStep ym hp a ze v83)^[17] ((0 : ℝ), v28) = (v408, v409) := by
    rewrite [show (17 : ℕ) = 16 + 1 from rfl, Function.iterate_succ_apply', e15]
    rfl
  have e17 : (bisectStep ym hp a ze v83)^[18] ((0 : ℝ), v28) = (v427, v428) := by
    rewrite [show (18 : ℕ) = 17 + 1 from rfl, Function.iterate_succ_apply', e16]
    rfl
  have e18 : (bisectStep ym hp a ze v83)^[19] ((0 : ℝ), v28) = (v446, v447) := by
    rewrite [show (19 : ℕ) = 18 + 1 from rfl, Function.iterate_succ_apply', e17]
    rfl
  have e19 : (bisectStep ym hp a ze v83)^[20] ((0 : ℝ), v28) = (v465, v466) := by
    rewrite [show (20 : ℕ) = 19 + 1 from rfl, Function.iterate_succ_apply', e18]
    rfl
  have e20 : (bisectStep ym hp a ze v83)^[21] ((0 : ℝ), v28) = (v484, v485) := by
    rewrite [show (21 : ℕ) = 20 + 1 from rfl, Function.iterate_succ_apply', e19]
    rfl
  have e21 : (bisectStep ym hp a ze v83)^[22] ((0 : ℝ), v28) = (v503, v504) := by
    rewrite [show (22 : ℕ) = 21 + 1 from rfl, Function.iterate_succ_apply', e20]
    rfl
  have e22 : (bisectStep ym hp a ze v83)^[23] ((0 : ℝ), v28) = (v522, v523) := by
    rewrite [show (23 : ℕ) = 22 + 1 from rfl, Function.iterate_succ_apply', e21]
    rfl
  have key : swingOfLength ym hp a ze v28 v83 = (((if v540 then v525 else v522) + (if v540 then v523 else v525)) / (2 : ℝ)) := by
    show ((((bisectStep ym hp a ze v83)^[24] ((0 : ℝ), v28)).1 + (((bisectStep ym hp a ze v83)^[24] ((0 : ℝ), v28)).2)) / (2 : ℝ)) = _
    rewrite [show (24 : ℕ) = 23 + 1 from rfl, Function.iterate_succ_apply', e22]
    rfl
  rewrite [show deadPoint ym hp a ze = v28 from rfl]
  rewrite [show wireLen ym hp a ze 0 = v47 from rfl]
  rewrite [show wireLen ym hp a ze v28 = v61 from rfl]
  rewrite [show wireLen ym hp a ze t = v75 from rfl]
  rewrite [show (if v75 + slack - ωd * rDrum * dt < v61 then v61 else if v47 < v75 + slack - ωd * rDrum * dt then v47 else v75 + slack - ωd * rDrum * dt) = v83 from rfl]
  rewrite [key]
  rfl

theorem stepParams_ccc : stepParams =
    ![(0.05 : ℝ), (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2))), (0.03 : ℝ), (1.22 : ℝ), (0.34 : ℝ), (0.8 : ℝ), ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))] := rfl

theorem strutStrain_ccc : strutStrain = fun (P : Fin 3 → ℝ) (Q : Fin 3 → ℝ) (δ : Fin 3 → ℝ) =>
    (((((P 0) - (Q 0)) * (δ 0)) + (((P 1) - (Q 1)) * (δ 1))) + (((P 2) - (Q 2)) * (δ 2))) := rfl

theorem sunDir_ccc : sunDir = fun (elSun : ℝ) (azSun : ℝ) =>
    let v2 := (Real.cos elSun)
    ![(v2 * (Real.cos azSun)), (v2 * (Real.sin azSun)), (Real.sin elSun)] := rfl

theorem sunInDish_ccc : sunInDish = fun (az : ℝ) (t : ℝ) (elSun : ℝ) (azSun : ℝ) =>
    let v4 := (Real.sin t)
    let v5 := (Real.cos az)
    let v6 := (v4 * v5)
    let v7 := (Real.sin az)
    let v8 := (v4 * v7)
    let v9 := (Real.cos t)
    let v10 := (v9 * v5)
    let v11 := (v9 * v7)
    let v12 := (-v4)
    let v22 := (Real.cos elSun)
    let v24 := (v22 * (Real.cos azSun))
    let v26 := (v22 * (Real.sin azSun))
    let v27 := (Real.sin elSun)
    ![(((((v11 * v9) - (v12 * v8)) * v24) + (((v12 * v6) - (v10 * v9)) * v26)) + (((v10 * v8) - (v11 * v6)) * v27)), (((v10 * v24) + (v11 * v26)) + (v12 * v27)), (((v6 * v24) + (v8 * v26)) + (v9 * v27))] := rfl

theorem sunRate_ccc : sunRate =
    (0.000073 : ℝ) := rfl

theorem sunReachableS_ccc : sunReachableS = fun (tDead : ℝ) (elSun : ℝ) =>
    (Real.sigmoid ((elSun - ((Real.pi / (2 : ℝ)) - tDead)) / (0.01 : ℝ))) := rfl

theorem swingFocus_ccc : swingFocus = fun (P : ℝ × ℝ) (d : ℝ) (f : ℝ) (t : ℝ) =>
    let v5 := (Real.sin t)
    let v8 := (Real.cos t)
    (((P.1 + (d * v5)) + (f * (-v5))), ((P.2 - (d * v8)) + (f * v8))) := rfl

theorem swingNormal_ccc : swingNormal = fun (t : ℝ) =>
    ((-(Real.sin t)), (Real.cos t)) := rfl

theorem swingOfLength_ccc : swingOfLength = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (tDead : ℝ) (L : ℝ) =>
    let v9 := (((0 : ℝ) + tDead) / (2 : ℝ))
    let v10 := (-ym)
    let v11 := (-a)
    let v12 := (Real.cos v9)
    let v14 := (-ze)
    let v15 := (Real.sin v9)
    let v18 := (-v11)
    let v28 := (L < (Real.sqrt (((((v11 * v12) + (v14 * v15)) - v10) ^ 2) + ((((v18 * v15) + (v14 * v12)) - hp) ^ 2))))
    let v29 := (if v28 then v9 else (0 : ℝ))
    let v30 := (if v28 then tDead else v9)
    let v32 := ((v29 + v30) / (2 : ℝ))
    let v33 := (Real.cos v32)
    let v35 := (Real.sin v32)
    let v47 := (L < (Real.sqrt (((((v11 * v33) + (v14 * v35)) - v10) ^ 2) + ((((v18 * v35) + (v14 * v33)) - hp) ^ 2))))
    let v48 := (if v47 then v32 else v29)
    let v49 := (if v47 then v30 else v32)
    let v51 := ((v48 + v49) / (2 : ℝ))
    let v52 := (Real.cos v51)
    let v54 := (Real.sin v51)
    let v66 := (L < (Real.sqrt (((((v11 * v52) + (v14 * v54)) - v10) ^ 2) + ((((v18 * v54) + (v14 * v52)) - hp) ^ 2))))
    let v67 := (if v66 then v51 else v48)
    let v68 := (if v66 then v49 else v51)
    let v70 := ((v67 + v68) / (2 : ℝ))
    let v71 := (Real.cos v70)
    let v73 := (Real.sin v70)
    let v85 := (L < (Real.sqrt (((((v11 * v71) + (v14 * v73)) - v10) ^ 2) + ((((v18 * v73) + (v14 * v71)) - hp) ^ 2))))
    let v86 := (if v85 then v70 else v67)
    let v87 := (if v85 then v68 else v70)
    let v89 := ((v86 + v87) / (2 : ℝ))
    let v90 := (Real.cos v89)
    let v92 := (Real.sin v89)
    let v104 := (L < (Real.sqrt (((((v11 * v90) + (v14 * v92)) - v10) ^ 2) + ((((v18 * v92) + (v14 * v90)) - hp) ^ 2))))
    let v105 := (if v104 then v89 else v86)
    let v106 := (if v104 then v87 else v89)
    let v108 := ((v105 + v106) / (2 : ℝ))
    let v109 := (Real.cos v108)
    let v111 := (Real.sin v108)
    let v123 := (L < (Real.sqrt (((((v11 * v109) + (v14 * v111)) - v10) ^ 2) + ((((v18 * v111) + (v14 * v109)) - hp) ^ 2))))
    let v124 := (if v123 then v108 else v105)
    let v125 := (if v123 then v106 else v108)
    let v127 := ((v124 + v125) / (2 : ℝ))
    let v128 := (Real.cos v127)
    let v130 := (Real.sin v127)
    let v142 := (L < (Real.sqrt (((((v11 * v128) + (v14 * v130)) - v10) ^ 2) + ((((v18 * v130) + (v14 * v128)) - hp) ^ 2))))
    let v143 := (if v142 then v127 else v124)
    let v144 := (if v142 then v125 else v127)
    let v146 := ((v143 + v144) / (2 : ℝ))
    let v147 := (Real.cos v146)
    let v149 := (Real.sin v146)
    let v161 := (L < (Real.sqrt (((((v11 * v147) + (v14 * v149)) - v10) ^ 2) + ((((v18 * v149) + (v14 * v147)) - hp) ^ 2))))
    let v162 := (if v161 then v146 else v143)
    let v163 := (if v161 then v144 else v146)
    let v165 := ((v162 + v163) / (2 : ℝ))
    let v166 := (Real.cos v165)
    let v168 := (Real.sin v165)
    let v180 := (L < (Real.sqrt (((((v11 * v166) + (v14 * v168)) - v10) ^ 2) + ((((v18 * v168) + (v14 * v166)) - hp) ^ 2))))
    let v181 := (if v180 then v165 else v162)
    let v182 := (if v180 then v163 else v165)
    let v184 := ((v181 + v182) / (2 : ℝ))
    let v185 := (Real.cos v184)
    let v187 := (Real.sin v184)
    let v199 := (L < (Real.sqrt (((((v11 * v185) + (v14 * v187)) - v10) ^ 2) + ((((v18 * v187) + (v14 * v185)) - hp) ^ 2))))
    let v200 := (if v199 then v184 else v181)
    let v201 := (if v199 then v182 else v184)
    let v203 := ((v200 + v201) / (2 : ℝ))
    let v204 := (Real.cos v203)
    let v206 := (Real.sin v203)
    let v218 := (L < (Real.sqrt (((((v11 * v204) + (v14 * v206)) - v10) ^ 2) + ((((v18 * v206) + (v14 * v204)) - hp) ^ 2))))
    let v219 := (if v218 then v203 else v200)
    let v220 := (if v218 then v201 else v203)
    let v222 := ((v219 + v220) / (2 : ℝ))
    let v223 := (Real.cos v222)
    let v225 := (Real.sin v222)
    let v237 := (L < (Real.sqrt (((((v11 * v223) + (v14 * v225)) - v10) ^ 2) + ((((v18 * v225) + (v14 * v223)) - hp) ^ 2))))
    let v238 := (if v237 then v222 else v219)
    let v239 := (if v237 then v220 else v222)
    let v241 := ((v238 + v239) / (2 : ℝ))
    let v242 := (Real.cos v241)
    let v244 := (Real.sin v241)
    let v256 := (L < (Real.sqrt (((((v11 * v242) + (v14 * v244)) - v10) ^ 2) + ((((v18 * v244) + (v14 * v242)) - hp) ^ 2))))
    let v257 := (if v256 then v241 else v238)
    let v258 := (if v256 then v239 else v241)
    let v260 := ((v257 + v258) / (2 : ℝ))
    let v261 := (Real.cos v260)
    let v263 := (Real.sin v260)
    let v275 := (L < (Real.sqrt (((((v11 * v261) + (v14 * v263)) - v10) ^ 2) + ((((v18 * v263) + (v14 * v261)) - hp) ^ 2))))
    let v276 := (if v275 then v260 else v257)
    let v277 := (if v275 then v258 else v260)
    let v279 := ((v276 + v277) / (2 : ℝ))
    let v280 := (Real.cos v279)
    let v282 := (Real.sin v279)
    let v294 := (L < (Real.sqrt (((((v11 * v280) + (v14 * v282)) - v10) ^ 2) + ((((v18 * v282) + (v14 * v280)) - hp) ^ 2))))
    let v295 := (if v294 then v279 else v276)
    let v296 := (if v294 then v277 else v279)
    let v298 := ((v295 + v296) / (2 : ℝ))
    let v299 := (Real.cos v298)
    let v301 := (Real.sin v298)
    let v313 := (L < (Real.sqrt (((((v11 * v299) + (v14 * v301)) - v10) ^ 2) + ((((v18 * v301) + (v14 * v299)) - hp) ^ 2))))
    let v314 := (if v313 then v298 else v295)
    let v315 := (if v313 then v296 else v298)
    let v317 := ((v314 + v315) / (2 : ℝ))
    let v318 := (Real.cos v317)
    let v320 := (Real.sin v317)
    let v332 := (L < (Real.sqrt (((((v11 * v318) + (v14 * v320)) - v10) ^ 2) + ((((v18 * v320) + (v14 * v318)) - hp) ^ 2))))
    let v333 := (if v332 then v317 else v314)
    let v334 := (if v332 then v315 else v317)
    let v336 := ((v333 + v334) / (2 : ℝ))
    let v337 := (Real.cos v336)
    let v339 := (Real.sin v336)
    let v351 := (L < (Real.sqrt (((((v11 * v337) + (v14 * v339)) - v10) ^ 2) + ((((v18 * v339) + (v14 * v337)) - hp) ^ 2))))
    let v352 := (if v351 then v336 else v333)
    let v353 := (if v351 then v334 else v336)
    let v355 := ((v352 + v353) / (2 : ℝ))
    let v356 := (Real.cos v355)
    let v358 := (Real.sin v355)
    let v370 := (L < (Real.sqrt (((((v11 * v356) + (v14 * v358)) - v10) ^ 2) + ((((v18 * v358) + (v14 * v356)) - hp) ^ 2))))
    let v371 := (if v370 then v355 else v352)
    let v372 := (if v370 then v353 else v355)
    let v374 := ((v371 + v372) / (2 : ℝ))
    let v375 := (Real.cos v374)
    let v377 := (Real.sin v374)
    let v389 := (L < (Real.sqrt (((((v11 * v375) + (v14 * v377)) - v10) ^ 2) + ((((v18 * v377) + (v14 * v375)) - hp) ^ 2))))
    let v390 := (if v389 then v374 else v371)
    let v391 := (if v389 then v372 else v374)
    let v393 := ((v390 + v391) / (2 : ℝ))
    let v394 := (Real.cos v393)
    let v396 := (Real.sin v393)
    let v408 := (L < (Real.sqrt (((((v11 * v394) + (v14 * v396)) - v10) ^ 2) + ((((v18 * v396) + (v14 * v394)) - hp) ^ 2))))
    let v409 := (if v408 then v393 else v390)
    let v410 := (if v408 then v391 else v393)
    let v412 := ((v409 + v410) / (2 : ℝ))
    let v413 := (Real.cos v412)
    let v415 := (Real.sin v412)
    let v427 := (L < (Real.sqrt (((((v11 * v413) + (v14 * v415)) - v10) ^ 2) + ((((v18 * v415) + (v14 * v413)) - hp) ^ 2))))
    let v428 := (if v427 then v412 else v409)
    let v429 := (if v427 then v410 else v412)
    let v431 := ((v428 + v429) / (2 : ℝ))
    let v432 := (Real.cos v431)
    let v434 := (Real.sin v431)
    let v446 := (L < (Real.sqrt (((((v11 * v432) + (v14 * v434)) - v10) ^ 2) + ((((v18 * v434) + (v14 * v432)) - hp) ^ 2))))
    let v447 := (if v446 then v431 else v428)
    let v448 := (if v446 then v429 else v431)
    let v450 := ((v447 + v448) / (2 : ℝ))
    let v451 := (Real.cos v450)
    let v453 := (Real.sin v450)
    let v465 := (L < (Real.sqrt (((((v11 * v451) + (v14 * v453)) - v10) ^ 2) + ((((v18 * v453) + (v14 * v451)) - hp) ^ 2))))
    (((if v465 then v450 else v447) + (if v465 then v448 else v450)) / (2 : ℝ)):= by
  funext ym hp a ze tDead L
  lift_lets
  intro v9 v10 v11 v12 v14 v15 v18 v28 v29 v30 v32 v33 v35 v47 v48 v49 v51 v52 v54 v66 v67 v68 v70 v71 v73 v85 v86 v87 v89 v90 v92 v104 v105 v106 v108 v109 v111 v123 v124 v125 v127 v128 v130 v142 v143 v144 v146 v147 v149 v161 v162 v163 v165 v166 v168 v180 v181 v182 v184 v185 v187 v199 v200 v201 v203 v204 v206 v218 v219 v220 v222 v223 v225 v237 v238 v239 v241 v242 v244 v256 v257 v258 v260 v261 v263 v275 v276 v277 v279 v280 v282 v294 v295 v296 v298 v299 v301 v313 v314 v315 v317 v318 v320 v332 v333 v334 v336 v337 v339 v351 v352 v353 v355 v356 v358 v370 v371 v372 v374 v375 v377 v389 v390 v391 v393 v394 v396 v408 v409 v410 v412 v413 v415 v427 v428 v429 v431 v432 v434 v446 v447 v448 v450 v451 v453 v465
  show ((((bisectStep ym hp a ze L)^[24] ((0 : ℝ), tDead)).1 + (((bisectStep ym hp a ze L)^[24] ((0 : ℝ), tDead)).2)) / (2 : ℝ)) = _
  have e0 : (bisectStep ym hp a ze L)^[1] ((0 : ℝ), tDead) = (v29, v30) := rfl
  have e1 : (bisectStep ym hp a ze L)^[2] ((0 : ℝ), tDead) = (v48, v49) := by
    rewrite [show (2 : ℕ) = 1 + 1 from rfl, Function.iterate_succ_apply', e0]
    rfl
  have e2 : (bisectStep ym hp a ze L)^[3] ((0 : ℝ), tDead) = (v67, v68) := by
    rewrite [show (3 : ℕ) = 2 + 1 from rfl, Function.iterate_succ_apply', e1]
    rfl
  have e3 : (bisectStep ym hp a ze L)^[4] ((0 : ℝ), tDead) = (v86, v87) := by
    rewrite [show (4 : ℕ) = 3 + 1 from rfl, Function.iterate_succ_apply', e2]
    rfl
  have e4 : (bisectStep ym hp a ze L)^[5] ((0 : ℝ), tDead) = (v105, v106) := by
    rewrite [show (5 : ℕ) = 4 + 1 from rfl, Function.iterate_succ_apply', e3]
    rfl
  have e5 : (bisectStep ym hp a ze L)^[6] ((0 : ℝ), tDead) = (v124, v125) := by
    rewrite [show (6 : ℕ) = 5 + 1 from rfl, Function.iterate_succ_apply', e4]
    rfl
  have e6 : (bisectStep ym hp a ze L)^[7] ((0 : ℝ), tDead) = (v143, v144) := by
    rewrite [show (7 : ℕ) = 6 + 1 from rfl, Function.iterate_succ_apply', e5]
    rfl
  have e7 : (bisectStep ym hp a ze L)^[8] ((0 : ℝ), tDead) = (v162, v163) := by
    rewrite [show (8 : ℕ) = 7 + 1 from rfl, Function.iterate_succ_apply', e6]
    rfl
  have e8 : (bisectStep ym hp a ze L)^[9] ((0 : ℝ), tDead) = (v181, v182) := by
    rewrite [show (9 : ℕ) = 8 + 1 from rfl, Function.iterate_succ_apply', e7]
    rfl
  have e9 : (bisectStep ym hp a ze L)^[10] ((0 : ℝ), tDead) = (v200, v201) := by
    rewrite [show (10 : ℕ) = 9 + 1 from rfl, Function.iterate_succ_apply', e8]
    rfl
  have e10 : (bisectStep ym hp a ze L)^[11] ((0 : ℝ), tDead) = (v219, v220) := by
    rewrite [show (11 : ℕ) = 10 + 1 from rfl, Function.iterate_succ_apply', e9]
    rfl
  have e11 : (bisectStep ym hp a ze L)^[12] ((0 : ℝ), tDead) = (v238, v239) := by
    rewrite [show (12 : ℕ) = 11 + 1 from rfl, Function.iterate_succ_apply', e10]
    rfl
  have e12 : (bisectStep ym hp a ze L)^[13] ((0 : ℝ), tDead) = (v257, v258) := by
    rewrite [show (13 : ℕ) = 12 + 1 from rfl, Function.iterate_succ_apply', e11]
    rfl
  have e13 : (bisectStep ym hp a ze L)^[14] ((0 : ℝ), tDead) = (v276, v277) := by
    rewrite [show (14 : ℕ) = 13 + 1 from rfl, Function.iterate_succ_apply', e12]
    rfl
  have e14 : (bisectStep ym hp a ze L)^[15] ((0 : ℝ), tDead) = (v295, v296) := by
    rewrite [show (15 : ℕ) = 14 + 1 from rfl, Function.iterate_succ_apply', e13]
    rfl
  have e15 : (bisectStep ym hp a ze L)^[16] ((0 : ℝ), tDead) = (v314, v315) := by
    rewrite [show (16 : ℕ) = 15 + 1 from rfl, Function.iterate_succ_apply', e14]
    rfl
  have e16 : (bisectStep ym hp a ze L)^[17] ((0 : ℝ), tDead) = (v333, v334) := by
    rewrite [show (17 : ℕ) = 16 + 1 from rfl, Function.iterate_succ_apply', e15]
    rfl
  have e17 : (bisectStep ym hp a ze L)^[18] ((0 : ℝ), tDead) = (v352, v353) := by
    rewrite [show (18 : ℕ) = 17 + 1 from rfl, Function.iterate_succ_apply', e16]
    rfl
  have e18 : (bisectStep ym hp a ze L)^[19] ((0 : ℝ), tDead) = (v371, v372) := by
    rewrite [show (19 : ℕ) = 18 + 1 from rfl, Function.iterate_succ_apply', e17]
    rfl
  have e19 : (bisectStep ym hp a ze L)^[20] ((0 : ℝ), tDead) = (v390, v391) := by
    rewrite [show (20 : ℕ) = 19 + 1 from rfl, Function.iterate_succ_apply', e18]
    rfl
  have e20 : (bisectStep ym hp a ze L)^[21] ((0 : ℝ), tDead) = (v409, v410) := by
    rewrite [show (21 : ℕ) = 20 + 1 from rfl, Function.iterate_succ_apply', e19]
    rfl
  have e21 : (bisectStep ym hp a ze L)^[22] ((0 : ℝ), tDead) = (v428, v429) := by
    rewrite [show (22 : ℕ) = 21 + 1 from rfl, Function.iterate_succ_apply', e20]
    rfl
  have e22 : (bisectStep ym hp a ze L)^[23] ((0 : ℝ), tDead) = (v447, v448) := by
    rewrite [show (23 : ℕ) = 22 + 1 from rfl, Function.iterate_succ_apply', e21]
    rfl
  rewrite [show (24 : ℕ) = 23 + 1 from rfl, Function.iterate_succ_apply', e22]
  rfl

theorem swingTwist_ccc : swingTwist = fun (apexH : ℝ) (zBolt : ℝ) =>
    let v8 := (apexH * (0 : ℝ))
    ![(1 : ℝ), (0 : ℝ), (0 : ℝ), (((0 : ℝ) * (0 : ℝ)) - (zBolt * (0 : ℝ))), ((zBolt * (1 : ℝ)) - v8), (v8 - ((0 : ℝ) * (1 : ℝ)))] := rfl

theorem swingVertex_ccc : swingVertex = fun (P : ℝ × ℝ) (f : ℝ) (t : ℝ) =>
    ((P.1 + (f * (Real.sin t))), (P.2 - (f * (Real.cos t)))) := rfl

theorem swingVertexAt_ccc : swingVertexAt = fun (P : ℝ × ℝ) (d : ℝ) (t : ℝ) =>
    ((P.1 + (d * (Real.sin t))), (P.2 - (d * (Real.cos t)))) := rfl

theorem swungPt_ccc : swungPt = fun (y₀ : ℝ) (z₀ : ℝ) (t : ℝ) =>
    let v3 := (Real.cos t)
    let v5 := (Real.sin t)
    (((y₀ * v3) + (z₀ * v5)), (((-y₀) * v5) + (z₀ * v3))) := rfl

theorem systemVolts_ccc : systemVolts =
    (12 : ℝ) := rfl

theorem tilt_ccc : tilt = fun (v : Fin 3 → ℝ) (e1 : ℝ) (e2 : ℝ) =>
    let v5 := ((v 0) + e1)
    let v6 := ((v 1) + e2)
    let v12 := (Real.sqrt (((v5 ^ 2) + (v6 ^ 2)) + ((v 2) ^ 2)))
    ![(v5 / v12), (v6 / v12), ((v 2) / v12)] := rfl

theorem tiltOfMismatch_ccc : tiltOfMismatch = fun (e : ℝ) =>
    (e / ((2 : ℝ) * (0.8 : ℝ))) := rfl

section
attribute [local irreducible] hyperHit reflect3 beamAxis

theorem traceBeam_ccc : traceBeam = fun (R : ℝ) (f : ℝ) (a : ℝ) (k : ℝ) (L : ℝ) (dm : ℝ) (rm : ℝ) (rt : ℝ) (slotW : ℝ) (t : ℝ) (β : ℝ) (H : Fin 3 → ℝ) (r : Fin 3 → ℝ) (onPanel : ℝ) =>
    let v18 := (hyperHit f L dm t β H r)
    let v32 := ((onPanel > (0.5 : ℝ)) ∧ (((v18 3) > (0 : ℝ)) ∧ ((v18 4) ≤ rm)))
    let v33 := (reflect3 ![(v18 5), (v18 6), (v18 7)] r)
    let v37 := ((1 : ℝ) / R)
    let v38 := ((1 : ℝ) + k)
    let v56 := ((((2 : ℝ) * v37) * ((((v18 0) * (v33 0)) + ((v18 1) * (v33 1))) + ((v38 * (v18 2)) * (v33 2)))) - ((2 : ℝ) * (v33 2)))
    let v65 := ((v37 * ((((v18 0) ^ 2) + ((v18 1) ^ 2)) + (v38 * ((v18 2) ^ 2)))) - ((2 : ℝ) * (v18 2)))
    let v76 := (((2 : ℝ) * v65) / ((-v56) - (Real.sqrt (max ((v56 ^ 2) - (((4 : ℝ) * (v37 * ((((v33 0) ^ 2) + ((v33 1) ^ 2)) + (v38 * ((v33 2) ^ 2))))) * v65)) (0 : ℝ)))))
    let v78 := ((v18 0) + (v76 * (v33 0)))
    let v85 := |((v18 1) + (v76 * (v33 1)))|
    let v95 := ((v76 > (0 : ℝ)) → ((¬ ((|v78| ≤ a) ∧ (v85 ≤ a))) ∨ ((v85 ≤ (slotW / (2 : ℝ))) ∧ (v78 ≥ (0 : ℝ)))))
    let v96 := (beamAxis t β)
    let v99 := ((v96 0) * L)
    let v100 := ((v96 1) * L)
    let v102 := (f + ((v96 2) * L))
    let v116 := (((((v99 - (v18 0)) * (v96 0)) + ((v100 - (v18 1)) * (v96 1))) + ((v102 - (v18 2)) * (v96 2))) / ((((v33 0) * (v96 0)) + ((v33 1) * (v96 1))) + ((v33 2) * (v96 2))))
    let v134 := (((Real.sqrt ((((((v18 0) + (v116 * (v33 0))) - v99) ^ 2) + ((((v18 1) + (v116 * (v33 1))) - v100) ^ 2)) + ((((v18 2) + (v116 * (v33 2))) - v102) ^ 2))) ≤ rt) ∧ (v116 > (0 : ℝ)))
    ![(if (v32 ∧ (v95 ∧ v134)) then (1 : ℝ) else (0 : ℝ)), (if v32 then (1 : ℝ) else (0 : ℝ)), (if (v32 ∧ v95) then (1 : ℝ) else (0 : ℝ)), (Real.sqrt ((((((v18 0) + (v116 * (v33 0))) - v99) ^ 2) + ((((v18 1) + (v116 * (v33 1))) - v100) ^ 2)) + ((((v18 2) + (v116 * (v33 2))) - v102) ^ 2))), v78, ((v18 1) + (v76 * (v33 1))), (v18 4), (if (¬ v32) then (0 : ℝ) else (if (¬ v95) then (1 : ℝ) else (if (¬ v134) then (2 : ℝ) else (3 : ℝ))))] := by
  funext R f a k L dm rm rt slotW t β H r onPanel
  rfl
end

theorem traceConic_ccc : traceConic = fun (c : ℝ) (k : ℝ) (p : ℝ) (O : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v10 := ((1 : ℝ) + k)
    let v28 := ((((2 : ℝ) * c) * ((((O 0) * (d 0)) + ((O 1) * (d 1))) + ((v10 * (O 2)) * (d 2)))) - ((2 : ℝ) * (d 2)))
    let v37 := ((c * ((((O 0) ^ 2) + ((O 1) ^ 2)) + (v10 * ((O 2) ^ 2)))) - ((2 : ℝ) * (O 2)))
    let v49 := (((2 : ℝ) * v37) / ((-v28) - (Real.sqrt (max ((v28 ^ 2) - (((4 : ℝ) * (c * ((((d 0) ^ 2) + ((d 1) ^ 2)) + (v10 * ((d 2) ^ 2))))) * v37)) (0 : ℝ)))))
    let v51 := ((O 0) + (v49 * (d 0)))
    let v53 := ((O 1) + (v49 * (d 1)))
    let v55 := ((O 2) + (v49 * (d 2)))
    let v61 := (Real.sqrt (max ((v51 ^ 2) + (v53 ^ 2)) (0.000000000000000001 : ℝ)))
    let v65 := (v61 ^ 2)
    let v67 := ((1 : ℝ) - ((v10 * (c ^ 2)) * v65))
    let v70 := ((c * v61) / (Real.sqrt (max v67 (0.000000000000000001 : ℝ))))
    let v73 := (Real.sqrt ((1 : ℝ) + (v70 ^ 2)))
    let v74 := (-v70)
    let v77 := (((v74 * v51) / v61) / v73)
    let v80 := (((v74 * v53) / v61) / v73)
    let v81 := ((1 : ℝ) / v73)
    let v87 := ((2 : ℝ) * ((((d 0) * v77) + ((d 1) * v80)) + ((d 2) * v81)))
    let v95 := ((p - v55) / ((d 2) - (v87 * v81)))
    ![v51, v53, v55, ((d 0) - (v87 * v77)), ((d 1) - (v87 * v80)), ((d 2) - (v87 * v81)), (v51 + (v95 * ((d 0) - (v87 * v77)))), (v53 + (v95 * ((d 1) - (v87 * v80)))), (((c * v65) / ((1 : ℝ) + (Real.sqrt (max v67 (0 : ℝ))))) - v55)] := rfl

theorem traceFacet_ccc : traceFacet = fun (R : ℝ) (p : ℝ) (cx : ℝ) (cy : ℝ) (O : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v18 := (R - (Real.sqrt ((R ^ 2) - ((Real.sqrt ((cx ^ 2) + (cy ^ 2))) ^ 2))))
    let v20 := ((-cx) / R)
    let v22 := ((-cy) / R)
    let v24 := ((R - v18) / R)
    let v37 := ((((d 0) * v20) + ((d 1) * v22)) + ((d 2) * v24))
    let v38 := (((((cx - (O 0)) * v20) + ((cy - (O 1)) * v22)) + ((v18 - (O 2)) * v24)) / v37)
    let v46 := ((2 : ℝ) * v37)
    let v52 := ((d 2) - (v46 * v24))
    let v54 := ((p - ((O 2) + (v38 * (d 2)))) / v52)
    ![(((O 0) + (v38 * (d 0))) + (v54 * ((d 0) - (v46 * v20)))), (((O 1) + (v38 * (d 1))) + (v54 * ((d 1) - (v46 * v22)))), (Real.sqrt (((((O 0) + (v38 * (d 0))) + (v54 * ((d 0) - (v46 * v20)))) ^ 2) + ((((O 1) + (v38 * (d 1))) + (v54 * ((d 1) - (v46 * v22)))) ^ 2))), ((O 2) + (v38 * (d 2))), (if ((0 : ℝ) < v52) then (1 : ℝ) else (0 : ℝ))] := rfl

theorem traceParams_ccc : traceParams =
    ![(2 : ℝ), (1 : ℝ), (0.8 : ℝ), (0.05 : ℝ), (0.06 : ℝ)] := rfl

theorem traceRay_ccc : traceRay = fun (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (cx : ℝ) (cy : ℝ) (ux : ℝ) (uy : ℝ) (dx : ℝ) (dy : ℝ) (dz : ℝ) =>
    let v18 := (w / (2 : ℝ))
    let v24 := ((|cx| ≤ a) ∧ ((|cy| ≤ a) ∧ ((|ux| ≤ v18) ∧ (|uy| ≤ v18))))
    let v25 := (cx + ux)
    let v26 := (cy + uy)
    let v27 := ((2 : ℝ) * f)
    let v36 := (R - (Real.sqrt ((R ^ 2) - ((Real.sqrt ((cx ^ 2) + (cy ^ 2))) ^ 2))))
    let v38 := ((-cx) / R)
    let v40 := ((-cy) / R)
    let v42 := ((R - v36) / R)
    let v55 := (((dx * v38) + (dy * v40)) + (dz * v42))
    let v56 := (((((cx - v25) * v38) + ((cy - v26) * v40)) + ((v36 - v27) * v42)) / v55)
    let v63 := ((2 : ℝ) * v55)
    let v69 := (dz - (v63 * v42))
    let v71 := ((f - (v27 + (v56 * dz))) / v69)
    let v86 := (((Real.sqrt ((((v25 + (v56 * dx)) + (v71 * (dx - (v63 * v38)))) ^ 2) + (((v26 + (v56 * dy)) + (v71 * (dy - (v63 * v40)))) ^ 2))) ≤ rc) ∧ ((0 : ℝ) < (if ((0 : ℝ) < v69) then (1 : ℝ) else (0 : ℝ))))
    ![((v25 + (v56 * dx)) + (v71 * (dx - (v63 * v38)))), ((v26 + (v56 * dy)) + (v71 * (dy - (v63 * v40)))), (Real.sqrt ((((v25 + (v56 * dx)) + (v71 * (dx - (v63 * v38)))) ^ 2) + (((v26 + (v56 * dy)) + (v71 * (dy - (v63 * v40)))) ^ 2))), (if (v24 ∧ v86) then (1 : ℝ) else (0 : ℝ)), (if (¬ v24) then (0 : ℝ) else (if v86 then (2 : ℝ) else (1 : ℝ))), (v27 + (v56 * dz)), (Real.sqrt ((cx ^ 2) + (cy ^ 2))), (if ((0 : ℝ) < v69) then (1 : ℝ) else (0 : ℝ))] := rfl

theorem traceRayErr_ccc : traceRayErr = fun (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (cx : ℝ) (cy : ℝ) (ux : ℝ) (uy : ℝ) (dx : ℝ) (dy : ℝ) (dz : ℝ) (σslope : ℝ) (σspec : ℝ) (e1 : ℝ) (e2 : ℝ) (s1 : ℝ) (s2 : ℝ) =>
    let v24 := (w / (2 : ℝ))
    let v30 := ((|cx| ≤ a) ∧ ((|cy| ≤ a) ∧ ((|ux| ≤ v24) ∧ (|uy| ≤ v24))))
    let v31 := (cx + ux)
    let v32 := (cy + uy)
    let v33 := ((2 : ℝ) * f)
    let v42 := (R - (Real.sqrt ((R ^ 2) - ((Real.sqrt ((cx ^ 2) + (cy ^ 2))) ^ 2))))
    let v44 := ((-cx) / R)
    let v46 := ((-cy) / R)
    let v48 := ((R - v42) / R)
    let v50 := (v44 + (σslope * e1))
    let v52 := (v46 + (σslope * e2))
    let v58 := (Real.sqrt (((v50 ^ 2) + (v52 ^ 2)) + (v48 ^ 2)))
    let v59 := (v50 / v58)
    let v60 := (v52 / v58)
    let v61 := (v48 / v58)
    let v75 := (((((cx - v31) * v44) + ((cy - v32) * v46)) + ((v42 - v33) * v48)) / (((dx * v44) + (dy * v46)) + (dz * v48)))
    let v87 := ((2 : ℝ) * (((dx * v59) + (dy * v60)) + (dz * v61)))
    let v93 := (dz - (v87 * v61))
    let v95 := ((dx - (v87 * v59)) + (σspec * s1))
    let v97 := ((dy - (v87 * v60)) + (σspec * s2))
    let v103 := (Real.sqrt (((v95 ^ 2) + (v97 ^ 2)) + (v93 ^ 2)))
    let v106 := (v93 / v103)
    let v108 := ((f - (v33 + (v75 * dz))) / v106)
    let v119 := ((0 : ℝ) < v106)
    let v120 := (((Real.sqrt ((((v31 + (v75 * dx)) + (v108 * (v95 / v103))) ^ 2) + (((v32 + (v75 * dy)) + (v108 * (v97 / v103))) ^ 2))) ≤ rc) ∧ v119)
    ![((v31 + (v75 * dx)) + (v108 * (v95 / v103))), ((v32 + (v75 * dy)) + (v108 * (v97 / v103))), (Real.sqrt ((((v31 + (v75 * dx)) + (v108 * (v95 / v103))) ^ 2) + (((v32 + (v75 * dy)) + (v108 * (v97 / v103))) ^ 2))), (if (v30 ∧ v120) then (1 : ℝ) else (0 : ℝ)), (if (¬ v30) then (0 : ℝ) else (if v120 then (2 : ℝ) else (1 : ℝ))), (v33 + (v75 * dz)), (Real.sqrt ((cx ^ 2) + (cy ^ 2))), (if v119 then (1 : ℝ) else (0 : ℝ))] := rfl

theorem traceRayK_ccc : traceRayK = fun (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (k : ℝ) (cx : ℝ) (cy : ℝ) (ux : ℝ) (uy : ℝ) (dx : ℝ) (dy : ℝ) (dz : ℝ) =>
    let v19 := (w / (2 : ℝ))
    let v25 := ((|cx| ≤ a) ∧ ((|cy| ≤ a) ∧ ((|ux| ≤ v19) ∧ (|uy| ≤ v19))))
    let v26 := (cx + ux)
    let v27 := (cy + uy)
    let v28 := ((2 : ℝ) * f)
    let v30 := ((1 : ℝ) / R)
    let v36 := (Real.sqrt (max ((cx ^ 2) + (cy ^ 2)) (0.000000000000000001 : ℝ)))
    let v37 := (v36 ^ 2)
    let v43 := ((1 : ℝ) - ((((1 : ℝ) + k) * (v30 ^ 2)) * v37))
    let v52 := ((v30 * v36) / (Real.sqrt (max v43 (0.000000000000000001 : ℝ))))
    let v55 := (Real.sqrt ((1 : ℝ) + (v52 ^ 2)))
    let v56 := (-v52)
    let v59 := (((v56 * cx) / v36) / v55)
    let v62 := (((v56 * cy) / v36) / v55)
    let v63 := ((1 : ℝ) / v55)
    let v76 := (((dx * v59) + (dy * v62)) + (dz * v63))
    let v77 := (((((cx - v26) * v59) + ((cy - v27) * v62)) + ((((v30 * v37) / ((1 : ℝ) + (Real.sqrt (max v43 (0 : ℝ))))) - v28) * v63)) / v76)
    let v84 := ((2 : ℝ) * v76)
    let v90 := (dz - (v84 * v63))
    let v92 := ((f - (v28 + (v77 * dz))) / v90)
    let v102 := ((0 : ℝ) < v90)
    let v103 := (((Real.sqrt ((((v26 + (v77 * dx)) + (v92 * (dx - (v84 * v59)))) ^ 2) + (((v27 + (v77 * dy)) + (v92 * (dy - (v84 * v62)))) ^ 2))) ≤ rc) ∧ v102)
    ![((v26 + (v77 * dx)) + (v92 * (dx - (v84 * v59)))), ((v27 + (v77 * dy)) + (v92 * (dy - (v84 * v62)))), (Real.sqrt ((((v26 + (v77 * dx)) + (v92 * (dx - (v84 * v59)))) ^ 2) + (((v27 + (v77 * dy)) + (v92 * (dy - (v84 * v62)))) ^ 2))), (if (v25 ∧ v103) then (1 : ℝ) else (0 : ℝ)), (if (¬ v25) then (0 : ℝ) else (if v103 then (2 : ℝ) else (1 : ℝ))), (v28 + (v77 * dz)), v36, (if v102 then (1 : ℝ) else (0 : ℝ))] := rfl

theorem traceRayKErr_ccc : traceRayKErr = fun (R : ℝ) (f : ℝ) (a : ℝ) (w : ℝ) (rc : ℝ) (k : ℝ) (σslope : ℝ) (σspec : ℝ) (cx : ℝ) (cy : ℝ) (ux : ℝ) (uy : ℝ) (dx : ℝ) (dy : ℝ) (dz : ℝ) (e1 : ℝ) (e2 : ℝ) (s1 : ℝ) (s2 : ℝ) =>
    let v25 := (w / (2 : ℝ))
    let v31 := ((|cx| ≤ a) ∧ ((|cy| ≤ a) ∧ ((|ux| ≤ v25) ∧ (|uy| ≤ v25))))
    let v32 := (cx + ux)
    let v33 := (cy + uy)
    let v34 := ((2 : ℝ) * f)
    let v36 := ((1 : ℝ) / R)
    let v42 := (Real.sqrt (max ((cx ^ 2) + (cy ^ 2)) (0.000000000000000001 : ℝ)))
    let v43 := (v42 ^ 2)
    let v49 := ((1 : ℝ) - ((((1 : ℝ) + k) * (v36 ^ 2)) * v43))
    let v58 := ((v36 * v42) / (Real.sqrt (max v49 (0.000000000000000001 : ℝ))))
    let v61 := (Real.sqrt ((1 : ℝ) + (v58 ^ 2)))
    let v62 := (-v58)
    let v65 := (((v62 * cx) / v42) / v61)
    let v68 := (((v62 * cy) / v42) / v61)
    let v69 := ((1 : ℝ) / v61)
    let v71 := (v65 + (σslope * e1))
    let v73 := (v68 + (σslope * e2))
    let v79 := (Real.sqrt (((v71 ^ 2) + (v73 ^ 2)) + (v69 ^ 2)))
    let v80 := (v71 / v79)
    let v81 := (v73 / v79)
    let v82 := (v69 / v79)
    let v96 := (((((cx - v32) * v65) + ((cy - v33) * v68)) + ((((v36 * v43) / ((1 : ℝ) + (Real.sqrt (max v49 (0 : ℝ))))) - v34) * v69)) / (((dx * v65) + (dy * v68)) + (dz * v69)))
    let v108 := ((2 : ℝ) * (((dx * v80) + (dy * v81)) + (dz * v82)))
    let v114 := (dz - (v108 * v82))
    let v116 := ((dx - (v108 * v80)) + (σspec * s1))
    let v118 := ((dy - (v108 * v81)) + (σspec * s2))
    let v124 := (Real.sqrt (((v116 ^ 2) + (v118 ^ 2)) + (v114 ^ 2)))
    let v127 := (v114 / v124)
    let v129 := ((f - (v34 + (v96 * dz))) / v127)
    let v139 := ((0 : ℝ) < v127)
    let v140 := (((Real.sqrt ((((v32 + (v96 * dx)) + (v129 * (v116 / v124))) ^ 2) + (((v33 + (v96 * dy)) + (v129 * (v118 / v124))) ^ 2))) ≤ rc) ∧ v139)
    ![((v32 + (v96 * dx)) + (v129 * (v116 / v124))), ((v33 + (v96 * dy)) + (v129 * (v118 / v124))), (Real.sqrt ((((v32 + (v96 * dx)) + (v129 * (v116 / v124))) ^ 2) + (((v33 + (v96 * dy)) + (v129 * (v118 / v124))) ^ 2))), (if (v31 ∧ v140) then (1 : ℝ) else (0 : ℝ)), (if (¬ v31) then (0 : ℝ) else (if v140 then (2 : ℝ) else (1 : ℝ))), (v34 + (v96 * dz)), v42, (if v139 then (1 : ℝ) else (0 : ℝ))] := rfl

theorem traceSphere_ccc : traceSphere = fun (R : ℝ) (p : ℝ) (O : Fin 3 → ℝ) (d : Fin 3 → ℝ) =>
    let v8 := ((O 2) - R)
    let v13 := ((((d 0) * (O 0)) + ((d 1) * (O 1))) + ((d 2) * v8))
    let v25 := ((-v13) + (Real.sqrt ((v13 ^ 2) - (((((O 0) ^ 2) + ((O 1) ^ 2)) + (v8 ^ 2)) - (R ^ 2)))))
    let v27 := ((O 0) + (v25 * (d 0)))
    let v29 := ((O 1) + (v25 * (d 1)))
    let v31 := ((O 2) + (v25 * (d 2)))
    let v33 := ((-v27) / R)
    let v35 := ((-v29) / R)
    let v37 := ((R - v31) / R)
    let v44 := ((2 : ℝ) * ((((d 0) * v33) + ((d 1) * v35)) + ((d 2) * v37)))
    let v50 := ((d 2) - (v44 * v37))
    let v52 := ((p - v31) / v50)
    ![(v27 + (v52 * ((d 0) - (v44 * v33)))), (v29 + (v52 * ((d 1) - (v44 * v35)))), (Real.sqrt (((v27 + (v52 * ((d 0) - (v44 * v33)))) ^ 2) + ((v29 + (v52 * ((d 1) - (v44 * v35)))) ^ 2))), v31, (if ((0 : ℝ) < v50) then (1 : ℝ) else (0 : ℝ))] := rfl

theorem transitTime_ccc : transitTime = fun (L : ℝ) (Q : ℝ) (D : ℝ) =>
    (L / (max (Q / ((Real.pi * (D ^ 2)) / (4 : ℝ))) (0.000001 : ℝ))) := rfl

theorem tunnelThroughput_ccc : tunnelThroughput =
    ((0.94 : ℝ) * (0.96 : ℝ)) := rfl

theorem turnLoss_ccc : turnLoss = fun (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Ta : ℝ) (Tin : ℝ) =>
    let v8 := (Ac / (8 : ℝ))
    ((((ε * (0.0000000567 : ℝ)) * v8) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v8) * (Tin - Ta))) := rfl

theorem turnOut_ccc : turnOut = fun (α : ℝ) (ε : ℝ) (Ac : ℝ) (hC : ℝ) (Ta : ℝ) (mcp : ℝ) (P : ℝ) (Tin : ℝ) =>
    let v12 := (Ac / (8 : ℝ))
    (Tin + (((α * P) - ((((ε * (0.0000000567 : ℝ)) * v12) * ((Tin ^ 4) - (Ta ^ 4))) + ((hC * v12) * (Tin - Ta)))) / mcp)) := rfl

theorem uPipeCyl_ccc : uPipeCyl = fun (L : ℝ) (Do : ℝ) (Dins : ℝ) (kIns : ℝ) (V : ℝ) =>
    (L / (((Real.log (max (Dins / Do) (1.0001 : ℝ))) / (((2 : ℝ) * Real.pi) * kIns)) + ((1 : ℝ) / ((((5.7 : ℝ) + ((3.8 : ℝ) * V)) * Real.pi) * Dins)))) := rfl

theorem uaOf_ccc : uaOf = fun (h : ℝ) (A : ℝ) =>
    (h * A) := rfl

theorem unit3_ccc : unit3 = fun (v : Fin 3 → ℝ) =>
    let v10 := (Real.sqrt (max ((((v 0) ^ 2) + ((v 1) ^ 2)) + ((v 2) ^ 2)) (0.000000000000000001 : ℝ)))
    ![((v 0) / v10), ((v 1) / v10), ((v 2) / v10)] := rfl

theorem velOf_ccc : velOf = fun (Q : ℝ) (D : ℝ) =>
    (Q / ((Real.pi * (D ^ 2)) / (4 : ℝ))) := rfl

theorem wBearX_ccc : wBearX = fun (b : TandoorHashemi.FixedBase) =>
    let v8 := ((0 : ℝ) * (0 : ℝ))
    ![(1 : ℝ), (0 : ℝ), (0 : ℝ), (v8 - (b.zBearing * (0 : ℝ))), ((b.zBearing * (1 : ℝ)) - v8), (v8 - ((0 : ℝ) * (1 : ℝ)))] := rfl

theorem wBearY_ccc : wBearY = fun (b : TandoorHashemi.FixedBase) =>
    let v8 := ((0 : ℝ) * (0 : ℝ))
    ![(0 : ℝ), (1 : ℝ), (0 : ℝ), (v8 - (b.zBearing * (1 : ℝ))), ((b.zBearing * (0 : ℝ)) - v8), (((0 : ℝ) * (1 : ℝ)) - v8)] := rfl

theorem wDrive_ccc : wDrive = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) (F : ℝ) =>
    let v14 := (c.chord / (2 : ℝ))
    let v19 := (Real.sqrt ((v14 ^ 2) + (c.apexH ^ 2)))
    let v21 := (-((F * v14) / v19))
    let v23 := ((F * c.apexH) / v19)
    ![v21, v23, (0 : ℝ), ((v14 * (0 : ℝ)) - (b.zRail * v23)), ((b.zRail * v21) - (c.apexH * (0 : ℝ))), ((c.apexH * v23) - (v14 * v21))] := rfl

theorem wRollN_ccc : wRollN = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v16 := (-(c.chord / (2 : ℝ)))
    let v18 := (b.zRail * (0 : ℝ))
    ![(0 : ℝ), (0 : ℝ), (1 : ℝ), ((v16 * (1 : ℝ)) - v18), (v18 - (c.apexH * (1 : ℝ))), ((c.apexH * (0 : ℝ)) - (v16 * (0 : ℝ)))] := rfl

theorem wRollNr_ccc : wRollNr = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v14 := (-(c.chord / (2 : ℝ)))
    ![c.apexH, v14, (0 : ℝ), ((v14 * (0 : ℝ)) - (b.zRail * v14)), ((b.zRail * c.apexH) - (c.apexH * (0 : ℝ))), ((c.apexH * v14) - (v14 * c.apexH))] := rfl

theorem wRollP_ccc : wRollP = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v15 := (c.chord / (2 : ℝ))
    let v17 := (b.zRail * (0 : ℝ))
    ![(0 : ℝ), (0 : ℝ), (1 : ℝ), ((v15 * (1 : ℝ)) - v17), (v17 - (c.apexH * (1 : ℝ))), ((c.apexH * (0 : ℝ)) - (v15 * (0 : ℝ)))] := rfl

theorem wRollPr_ccc : wRollPr = fun (c : TandoorHashemi.Carriage) (b : TandoorHashemi.FixedBase) =>
    let v13 := (c.chord / (2 : ℝ))
    ![c.apexH, v13, (0 : ℝ), ((v13 * (0 : ℝ)) - (b.zRail * v13)), ((b.zRail * c.apexH) - (c.apexH * (0 : ℝ))), ((c.apexH * v13) - (v13 * c.apexH))] := rfl

theorem wStop_ccc : wStop = fun (b : TandoorHashemi.FixedBase) =>
    let v8 := ((0 : ℝ) * (1 : ℝ))
    let v9 := (b.zBearing * (0 : ℝ))
    let v12 := ((0 : ℝ) * (0 : ℝ))
    ![(0 : ℝ), (0 : ℝ), (1 : ℝ), (v8 - v9), (v9 - v8), (v12 - v12)] := rfl

theorem wallTemp_ccc : wallTemp = fun (Tbulk : ℝ) (qFlux : ℝ) (h : ℝ) (ε : ℝ) (Ta : ℝ) =>
    (max Tbulk (min (Tbulk + (qFlux / h)) (Real.sqrt (Real.sqrt (((max (0 : ℝ) qFlux) / ((max ε (0.01 : ℝ)) * (0.0000000567 : ℝ))) + ((max Ta (0 : ℝ)) ^ 4)))))) := rfl

theorem wireLen_ccc : wireLen = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v6 := (-a)
    let v7 := (Real.cos t)
    let v9 := (-ze)
    let v10 := (Real.sin t)
    (Real.sqrt (((((v6 * v7) + (v9 * v10)) - (-ym)) ^ 2) + (((((-v6) * v10) + (v9 * v7)) - hp) ^ 2))) := rfl

theorem wireLever_ccc : wireLever = fun (P : ℝ × ℝ) (B : ℝ × ℝ) =>
    (((P.1 * B.2) - (P.2 * B.1)) / (Real.sqrt (((B.1 - P.1) ^ 2) + ((B.2 - P.2) ^ 2)))) := rfl

theorem wireTension_ccc : wireTension = fun (W : ℝ) (rcm : ℝ) (rw : ℝ) (t : ℝ) =>
    (((W * rcm) * (Real.sin t)) / rw) := rfl

theorem wrapRad_ccc : wrapRad = fun (d : ℝ) =>
    let v3 := ((2 : ℝ) * Real.pi)
    (d - (v3 * ((⌊((d + Real.pi) / v3)⌋ : ℤ) : ℝ))) := rfl

theorem wrenchAt_ccc : wrenchAt = fun (p : Fin 3 → ℝ) (f : Fin 3 → ℝ) =>
    ![(f 0), (f 1), (f 2), (((p 1) * (f 2)) - ((p 2) * (f 1))), (((p 2) * (f 0)) - ((p 0) * (f 2))), (((p 0) * (f 1)) - ((p 1) * (f 0)))] := rfl

theorem xhHashemi_ccc : xhHashemi =
    (((1.84 : ℝ) / (2 : ℝ)) - (0.03 : ℝ)) := rfl

theorem yaw_ccc : yaw =
    ![(0 : ℝ), (0 : ℝ), (1 : ℝ), (0 : ℝ), (0 : ℝ), (0 : ℝ)] := rfl

theorem ymHashemi_ccc : ymHashemi =
    (1.22 : ℝ) := rfl

theorem zBoltHashemi_ccc : zBoltHashemi =
    (((0.55 : ℝ) + (1.30 : ℝ)) - (0.05 : ℝ)) := rfl

theorem zeHashemi_ccc : zeHashemi =
    ((1 : ℝ) - ((2 : ℝ) - (Real.sqrt (((2 : ℝ) ^ 2) - ((0.8 : ℝ) ^ 2))))) := rfl

/-- the translator unrolls `f^[n]` into `n` applications: the rule, on a 3-fold instance of the bisection -/
theorem bisect3_unroll (ym hp a ze L : ℝ) (s : ℝ × ℝ) :
    (bisectStep ym hp a ze L)^[3] s = bisectStep ym hp a ze L (bisectStep ym hp a ze L (bisectStep ym hp a ze L s)) := rfl

end TandoorHashemi
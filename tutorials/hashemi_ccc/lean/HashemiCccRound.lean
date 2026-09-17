import RequestProject.HashemiMega
namespace TandoorHashemi
open Classical
set_option maxHeartbeats 4000000
set_option maxRecDepth 8000

theorem Fits_ccc : Fits = fun (b : TandoorHashemi.FixedBase) (c : TandoorHashemi.Carriage) =>
    (b.rRail = (Real.sqrt (((c.chord / (2 : ℝ)) ^ 2) + (c.apexH ^ 2)))) := rfl

theorem HangerClearsPost_ccc : HangerClearsPost = fun (eyeOffset : ℝ) (dRod : ℝ) =>
    ((dRod / (2 : ℝ)) < eyeOffset) := rfl

theorem HoldsDish_ccc : HoldsDish = fun (Tmax : ℝ) (W : ℝ) (rcm : ℝ) (rw : ℝ) =>
    ((W * rcm) ≤ (Tmax * rw)) := rfl

theorem Leg_footLong_ccc : Leg.footLong = fun (l : TandoorHashemi.Leg) =>
    (l.foot - l.footShort) := rfl

theorem MastClears_ccc : MastClears = fun (ym : ℝ) (a : ℝ) (ze : ℝ) =>
    ((Real.sqrt ((a ^ 2) + (ze ^ 2))) < ym) := rfl

theorem ReachesVertical_ccc : ReachesVertical = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) =>
    ((ym * a) ≤ (hp * ze)) := rfl

theorem SlackHarmless_ccc : SlackHarmless = fun (f : ℝ) (ε : ℝ) (δ : ℝ) (h : ℝ) =>
    (((f * (Real.tan ε)) + δ) ≤ h) := rfl

theorem TrackerBudget_ccc : TrackerBudget = fun (f : ℝ) (ε : ℝ) (h : ℝ) =>
    ((f * (Real.tan ε)) ≤ h) := rfl

theorem azRate_ccc : azRate = fun (ωm : ℝ) (rw : ℝ) (R : ℝ) =>
    ((ωm * rw) / R) := rfl

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

theorem clearance_ccc : clearance = fun (l : TandoorHashemi.Leg) (holeDown : ℝ) (reach : ℝ) =>
    ((l.upright - holeDown) - reach) := rfl

theorem coilCapture_ccc : coilCapture = fun (rs : ℝ) (rc : ℝ) (d : ℝ) =>
    let v9 := (rs ^ 2)
    let v10 := (d ^ 2)
    let v12 := (rc ^ 2)
    let v15 := ((2 : ℝ) * d)
    let v30 := (d + rs)
    (if ((rs + rc) ≤ d) then (0 : ℝ) else (if (d ≤ (rc - rs)) then (1 : ℝ) else ((((v9 * (Real.arccos (((v10 + v9) - v12) / (v15 * rs)))) + (v12 * (Real.arccos (((v10 + v12) - v9) / (v15 * rc))))) - ((Real.sqrt ((((((-d) + rs) + rc) * (v30 - rc)) * ((d - rs) + rc)) * (v30 + rc))) / (2 : ℝ))) / (Real.pi * v9)))) := rfl

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

theorem deadPoint_ccc : deadPoint = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) =>
    let v4 := (ym * a)
    let v5 := (hp * ze)
    (if (v4 ≤ v5) then (Real.pi / (2 : ℝ)) else (Real.arctan (((ym * ze) + (hp * a)) / (v4 - v5)))) := rfl

theorem dishF_ccc : dishF =
    (1 : ℝ) := rfl

theorem dishHalf_ccc : dishHalf =
    (0.8 : ℝ) := rfl

theorem dishR_ccc : dishR =
    (2 : ℝ) := rfl

theorem dishSide_ccc : dishSide =
    ((2 : ℝ) * (0.8 : ℝ)) := rfl

theorem edgeClipAt_ccc : edgeClipAt = fun (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v3 := (-a)
    let v4 := (Real.cos t)
    let v6 := (-ze)
    let v7 := (Real.sin t)
    (((v3 * v4) + (v6 * v7)), (((-v3) * v7) + (v6 * v4))) := rfl

theorem edgeDepth_ccc : edgeDepth = fun (f : ℝ) (a : ℝ) (sag : ℝ) (el : ℝ) =>
    (((f - sag) * (Real.sin el)) + (a * (Real.cos el))) := rfl

theorem elPower_ccc : elPower = fun (W : ℝ) (rcm : ℝ) (t : ℝ) (ω : ℝ) =>
    (((W * rcm) * (Real.sin t)) * ω) := rfl

theorem elRate_ccc : elRate = fun (ωd : ℝ) (rDrum : ℝ) (rw : ℝ) =>
    ((ωd * rDrum) / rw) := rfl

theorem facetSpot_ccc : facetSpot = fun (w : ℝ) (f : ℝ) =>
    (w + (f * (0.0093 : ℝ))) := rfl

theorem focusShift_ccc : focusShift = fun (h : ℝ) (ε : ℝ) =>
    (h * (Real.sin ε)) := rfl

theorem hM12_ccc : hM12 =
    ((0.00175 : ℝ) / ((2 : ℝ) * Real.pi)) := rfl

theorem hangerLength_ccc : hangerLength = fun (R : ℝ) (a : ℝ) (yr : ℝ) (dx : ℝ) =>
    let v5 := (yr ^ 2)
    (Real.sqrt (((dx ^ 2) + v5) + (((R / (2 : ℝ)) - (R - (Real.sqrt ((R ^ 2) - ((Real.sqrt ((a ^ 2) + v5)) ^ 2))))) ^ 2))) := rfl

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

theorem leverAt_ccc : leverAt = fun (ym : ℝ) (hp : ℝ) (a : ℝ) (ze : ℝ) (t : ℝ) =>
    let v5 := (-ym)
    let v6 := (-a)
    let v7 := (Real.cos t)
    let v9 := (-ze)
    let v10 := (Real.sin t)
    let v12 := ((v6 * v7) + (v9 * v10))
    let v16 := (((-v6) * v10) + (v9 * v7))
    (((v5 * v16) - (hp * v12)) / (Real.sqrt (((v12 - v5) ^ 2) + ((v16 - hp) ^ 2)))) := rfl

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

-- megaStep: round trip by the twins (the 24-fold bisection is beyond rfl's budget)

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

theorem prop_clearance_hashemi_ccc : prop_clearance_hashemi = fun (holeDown : ℝ) =>
    let v10 := (((1.30 : ℝ) - holeDown) - (Real.sqrt ((5 : ℝ) - ((2 : ℝ) * (Real.sqrt (3.36 : ℝ))))))
    ((((0.1449 : ℝ) - holeDown) < v10) ∧ (v10 < ((0.146 : ℝ) - holeDown))) := rfl

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

theorem recip_ccc : recip = fun (t : TandoorHashemi.Screw) (w : TandoorHashemi.Screw) =>
    (((((((t 0) * (w 3)) + ((t 1) * (w 4))) + ((t 2) * (w 5))) + ((t 3) * (w 0))) + ((t 4) * (w 1))) + ((t 5) * (w 2))) := rfl

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

theorem setLength_ccc : setLength = fun (rod : ℝ) (excess : ℝ) =>
    (rod - excess) := rfl

theorem sideGap_ccc : sideGap =
    (((1.84 : ℝ) - ((2 : ℝ) * (0.8 : ℝ))) / (2 : ℝ)) := rfl

theorem slackSpot_ccc : slackSpot = fun (f : ℝ) (δ : ℝ) (rw : ℝ) =>
    ((((2 : ℝ) * f) * δ) / rw) := rfl

theorem slotExit_ccc : slotExit = fun (a : ℝ) (ze : ℝ) =>
    (Real.arctan (a / ze)) := rfl

-- step: round trip by the twins (the 24-fold bisection is beyond rfl's budget)

theorem stepParams_ccc : stepParams =
    ![(0.05 : ℝ), (Real.sqrt ((((1.84 : ℝ) / (2 : ℝ)) ^ 2) + ((0.80 : ℝ) ^ 2))), (0.03 : ℝ), (1.22 : ℝ), (0.34 : ℝ), (0.8 : ℝ), ((Real.sqrt (3.36 : ℝ)) - (1 : ℝ))] := rfl

theorem strutStrain_ccc : strutStrain = fun (P : Fin 3 → ℝ) (Q : Fin 3 → ℝ) (δ : Fin 3 → ℝ) =>
    (((((P 0) - (Q 0)) * (δ 0)) + (((P 1) - (Q 1)) * (δ 1))) + (((P 2) - (Q 2)) * (δ 2))) := rfl

theorem swingFocus_ccc : swingFocus = fun (P : ℝ × ℝ) (d : ℝ) (f : ℝ) (t : ℝ) =>
    let v5 := (Real.sin t)
    let v8 := (Real.cos t)
    (((P.1 + (d * v5)) + (f * (-v5))), ((P.2 - (d * v8)) + (f * v8))) := rfl

theorem swingNormal_ccc : swingNormal = fun (t : ℝ) =>
    ((-(Real.sin t)), (Real.cos t)) := rfl

-- swingOfLength: round trip by the twins (the 24-fold bisection is beyond rfl's budget)

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

theorem tiltOfMismatch_ccc : tiltOfMismatch = fun (e : ℝ) =>
    (e / ((2 : ℝ) * (0.8 : ℝ))) := rfl

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
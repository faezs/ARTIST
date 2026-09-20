/-
# The env's step as one morphism

The mount, the optics and the heat as ONE definition, extracted by Ccc into ONE Metal kernel:
`megaStep` advances the pose (Hashemi.lean's machine); on the new pose 64 rays of `dishPower`
(HashemiTrace.lean) are the tensor power of one morphism and their sum the reduction - one
thread per ray, the sum in threadgroup memory; the delivered power goes to `heatStep`
(HashemiHeat.lean), the coil, the oil, the pipes, the pot. The rays are independent, so they
tensor; the heat needs the optics' output, so it composes. Nothing of this is glued in a host.
-/
import RequestProject.HashemiTrace
import RequestProject.HashemiHeat
import RequestProject.HashemiField
import RequestProject.HashemiOil
import RequestProject.HashemiWire

namespace TandoorHashemi
open Classical

-- the env's row is 330 wide now (its own 100 and the mount's 230): the `Fin` literals of the
-- vector need more elaboration depth than the default
set_option maxRecDepth 40000

/-- the rays per agent per step -/
def envRays : ℕ := 64

/-- **the env's step**: inputs the mount's 17 (`megaStep`), the optics' `R f a w rc k σslope
σspec hsun soil`, then THE LOOP, which is no longer six constants.

`HashemiOil.lean` names the fluid (Therminol 66), gives it temperature-dependent properties, puts
a variable-speed pump on it and writes every conductance as a correlation:

* the pump's command `uPump ∈ [0,1]` sets the volumetric flow `Q = Qmax · uPump`, hence the
  velocity in the bore `Dp`, hence the Reynolds number, hence the friction and the pressure drop
  and the pump's electrical power `p_pump` (which the reward pays for);
* the oil-side film coefficient is `Nu k / D` with `Nu` laminar (4.364) or Dittus-Boelter,
  so the exchanger's `UA` and the coil's film temperature both move with the flow;
* the coil's convection is the HOUR'S WIND (`hWind Vw`), not a constant 15 W/m²K;
* the pipe's conductance is the cylindrical-insulation series `uPipeCyl Lp Dp Dins kIns Vw`;
* the pipe's delay is `delayOf Lp Q Dp dt` - a real number of steps, read out of the 16-step
  history by `lerp8` - instead of HashemiField's fixed two;
* the exchanger is effectiveness-NTU against the pot's wall band (`effNtu`, the Cr → 0 branch);
* the bulk is capped at the datasheet's 345 °C and the FILM temperature `T_film` is carried, with
  its margin to the 375 °C film limit and an Arrhenius damage counter `deg` that grows when the
  margin goes negative. `film_limit_reachable` proves the cap binds at the 2 m reflector.

The two histories along the pipe (`hist`: the coil's outlet, `ret`: the exchanger's outlet; most
recent first) and the ray table `dr` are as before. Outputs `megaStep`'s 17 columns;
`capture, capture_s, per_dni, p_in`; the loop's `T_out, q_abs, q_coil_loss, q_pipe, q_pot, q_net`;
eight observations; the FIELDS (the flux in eight annuli, the oil along the eight turns, the two
shifted histories); then the loop's new state and the three new observations. -/
noncomputable def hashemiEnv (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta
    uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) : Fin 330 → ℝ :=
  let s := megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc
  let mg := megaGeom az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc
  let ms := megaScrew az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc
  let mq := megaReqs az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc
  let mc := megaThmsClosed az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc
  let mt := megaThmsState az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc
  let cap := (∑ i : Fin 64, dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0) / 64
  let capS := (∑ i : Fin 64, dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 4) / 64
  let per := (2 * a) ^ 2 * rho * cap
  let Pin := per * dni * soil
  -- the receiver's flux: the captured power in annulus k of the aperture (W)
  -- the indicator decided CLASSICALLY and explicitly: `inBin` is a definition, so instance
  -- synthesis cannot see the conjunction inside it and picks `Classical.propDecidable` for that
  -- half and a structural instance for the other - a term no printed `if` can be re-elaborated
  -- into.  Written this way the twin prints the instance it sees (`@ite _ … propDecidable …`).
  let binOf := fun (j : Fin 8) => (∑ i : Fin 64, @b2r (inBin rc (dishPower R f a w rc k σslope σspec rho hsun
    (s 0) (s 1) elSun azSun (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 3)
    j ∧ dishPower R f a w rc k σslope σspec rho hsun (s 0) (s 1) elSun azSun
    (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0 > 0.5)
    (Classical.propDecidable _))
    / 64 * (2 * a) ^ 2 * rho * dni * soil
  -- the eight annuli LISTED: the same function, written as the vector it is, so the round trip
  -- can print `coilProfile … ![b 0, …, b 7]` as the text this line writes (a lambda has none)
  let bin : Fin 8 → ℝ := ![binOf 0, binOf 1, binOf 2, binOf 3, binOf 4, binOf 5, binOf 6, binOf 7]
  -- THE PUMP: the command sets the flow, the flow sets everything else
  let uP := min (max uPump 0) 1
  let Q := Qmax * uP
  let Tb := min oilBulkMax (max Ta (hist 0))
  -- the flow's capacity rate, W/K, at the fluid's own density and heat capacity.  Two of them,
  -- and the difference is the whole of what a STOPPED pump means:
  --  * `mcpF` is the flow itself, and it is genuinely zero at zero flow - so nothing is delivered
  --    down the pipe and nothing crosses the exchanger;
  --  * `mcpC` is what the coil's own energy balance divides by, `mcpF + Ccoil/dt`: the oil and
  --    copper standing IN the coil, which at zero flow makes `coilProfile` a lumped-capacity step
  --    (`Ccoil (T' - T)/dt = absorbed - lost`) instead of a division by nothing.
  -- `mcpX` is `mcpF` floored only where it appears in a denominator whose numerator vanishes with
  -- it (the pipe's Green's function, the return temperature, the NTU).
  let mcpF := oilRho Tb * Q * oilCp Tb
  let mcpX := max mcpF 1e-6
  let mcpC := mcpF + Ccoil / dt
  let Upipe := uPipeCyl Lp Dp Dins kIns Vw
  let hC := hWind Vw
  -- the pipe: the delay is the transit time, in steps, read out of the history between stations
  let dly := delayOf Lp Q Dp dt
  let Thot := lerp8 (hist 0) (hist 1) (hist 2) (hist 3) (hist 4) (hist 5) (hist 6) (hist 7) dly
  let Tcold := lerp8 (ret 0) (ret 1) (ret 2) (ret 3) (ret 4) (ret 5) (ret 6) (ret 7) dly
  let Tpot := delivered (Upipe / 2) mcpX Ta Thot
  -- the exchanger: effectiveness-NTU, its UA limited by the oil-side film coefficient at this flow
  let hIn := hCoil Q Dp Tb
  let UAx := min UAxMax (uaOf hIn Axch)
  let eff := effNtu (ntuOf UAx mcpX)
  let qPot := mcpF * eff * max 0 (Tpot - Twall)
  let Tret := Tpot - qPot / mcpX
  -- the coil's inlet is the MIXING CUP of the oil that arrives down the return and the oil
  -- already standing in the coil: at full flow it is the former, at zero flow the latter
  let Tin := (mcpF * delivered (Upipe / 2) mcpX Ta Tcold + (Ccoil / dt) * Tb) / mcpC
  -- the coil: the oil through the eight turns, losing to the hour's wind
  let prof := coilProfile α ε Ac hC Ta mcpC Tin bin
  let Traw := prof 7
  let Tout := min oilBulkMax (max Ta Traw)
  let qAbs := α * (bin 0 + bin 1 + bin 2 + bin 3 + bin 4 + bin 5 + bin 6 + bin 7)
  let qCoil := qAbs - mcpC * (Tout - Tin)
  let qPipe := mcpF * ((Thot - Tpot) + (Tcold - Tret))
  let qNet := qAbs - qCoil - qPipe - qPot
  let h' := shift Tout hist
  let r' := shift Tret ret
  -- THE LIMITS: the film the oil touches, its margin, the damage that accumulates past it
  let Tfilm := wallTemp Tout (qAbs / Ac) hIn ε Ta
  let margin := oilFilmMax - Tfilm
  let deg := degradStep degPrev dt degA degEa Tfilm
  let Ppump := pumpElec Q Dp Lp Tb etaP Pidle
  let fault := @b2r (oilBulkMax ≤ Traw) (Classical.propDecidable _)
  -- THE WIRE, END TO END, AND THE SLACK AS THE GEOMETRY IT IS (HashemiWire.lean).  `s 3` is the
  -- span the step left the wire at and `s 2` the wire on the ground, both the mount's own
  -- columns; nothing here re-walks the mount.
  let wrun := wireRun (ymOf a) (hpOf a) a (zeOf a) (endStationOf a) (postHOf a) (s 1)
  let wpaid := wrun + s 2
  let wbight := bightDepth (s 3) (s 2)
  let wwind := windBack (s 2) rDrum
  let eAz := (azSun - s 0) - 2 * Real.pi * ((⌊((azSun - s 0) + Real.pi) / (2 * Real.pi)⌋ : ℤ) : ℝ)
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9, s 10, s 11, s 12, s 13, s 14, s 15, s 16,
    cap, capS, per, Pin, Tout, qAbs, qCoil, qPipe, qPot, qNet,
    eAz, (Real.pi / 2 - s 1) - elSun, s 1, s 6, s 7, (Tout - 300) / 300, s 15, s 16,
    bin 0, bin 1, bin 2, bin 3, bin 4, bin 5, bin 6, bin 7,
    prof 0, prof 1, prof 2, prof 3, prof 4, prof 5, prof 6, prof 7,
    h' 0, h' 1, h' 2, h' 3, h' 4, h' 5, h' 6, h' 7, h' 8, h' 9, h' 10, h' 11, h' 12, h' 13, h' 14, h' 15,
    r' 0, r' 1, r' 2, r' 3, r' 4, r' 5, r' 6, r' 7, r' 8, r' 9, r' 10, r' 11, r' 12, r' 13, r' 14, r' 15,
    Tfilm, margin, Q, deg, Ppump, mcpF, UAx, dly, fault, expansionFrac 293.15 Tout,
    margin / 300, uP, min (max deg 0) 1,
    wrun, wpaid, wbight, wwind,
    s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9,
    s 10, s 11, s 12, s 13, s 14, s 15, s 16,
    mg 0, mg 1, mg 2, mg 3, mg 4, mg 5, mg 6, mg 7, mg 8, mg 9,
    mg 10, mg 11, mg 12, mg 13, mg 14, mg 15, mg 16, mg 17, mg 18, mg 19,
    mg 20, mg 21, mg 22, mg 23, mg 24, mg 25, mg 26, mg 27, mg 28, mg 29,
    mg 30, mg 31, mg 32, mg 33, mg 34, mg 35, mg 36, mg 37, mg 38, mg 39,
    mg 40, mg 41, mg 42, mg 43, mg 44, mg 45, mg 46, mg 47, mg 48, mg 49,
    mg 50, mg 51, mg 52, mg 53, mg 54, mg 55, mg 56, mg 57, mg 58, mg 59,
    ms 0, ms 1, ms 2, ms 3, ms 4, ms 5, ms 6, ms 7, ms 8, ms 9,
    ms 10, ms 11, ms 12, ms 13, ms 14, ms 15, ms 16, ms 17, ms 18, ms 19,
    ms 20, ms 21, ms 22, ms 23, ms 24, ms 25, ms 26, ms 27, ms 28, ms 29,
    ms 30, ms 31, ms 32, ms 33, ms 34, ms 35, ms 36, ms 37, ms 38, ms 39,
    mq 0, mq 1, mq 2, mq 3, mq 4, mq 5, mq 6,
    mc 0, mc 1, mc 2, mc 3, mc 4, mc 5, mc 6, mc 7, mc 8, mc 9,
    mc 10, mc 11, mc 12, mc 13, mc 14, mc 15, mc 16, mc 17, mc 18, mc 19,
    mc 20, mc 21, mc 22, mc 23, mc 24, mc 25, mc 26, mc 27, mc 28, mc 29,
    mc 30, mc 31, mc 32, mc 33, mc 34, mc 35, mc 36, mc 37, mc 38, mc 39,
    mc 40, mc 41, mc 42, mc 43, mc 44, mc 45, mc 46, mc 47, mc 48, mc 49,
    mc 50, mc 51, mc 52, mc 53, mc 54, mc 55,
    mt 0, mt 1, mt 2, mt 3, mt 4, mt 5, mt 6, mt 7, mt 8, mt 9,
    mt 10, mt 11, mt 12, mt 13, mt 14, mt 15, mt 16, mt 17, mt 18, mt 19,
    mt 20, mt 21, mt 22, mt 23, mt 24, mt 25, mt 26, mt 27, mt 28, mt 29,
    mt 30, mt 31, mt 32, mt 33, mt 34, mt 35, mt 36, mt 37, mt 38, mt 39,
    mt 40, mt 41, mt 42, mt 43, mt 44, mt 45, mt 46, mt 47, mt 48, mt 49]

/-- **the whole mount, carried per step.**  `hashemiEnv` called the mount already and kept 17 of
its columns; `megaNames`' other 213 — the wire (`P_y`, `P_z`, `C_y`, `C_z`, `wireLever`,
`wireLen`, `wireTension`, `deadPoint`, `slackSpot`, `wire_moment`), the screw solve (every
`recip_*`, the focus's freedom velocities `vF_yaw_*` / `vF_swing_*` / `v_roll_z`,
`drive_work_yaw`, `boltStress`, `hM12`, `elPower_screw`, `az_rpm`, `roller_rpm`, `strutStrain`,
`cableDrop`), the machine's geometry, the focus's own motion, and the ~100 structural predicates
(`TrackerBudget`, `HoldsDish`, `MastClears`, `ReachesVertical`, `Fits`, …) — were computed in a
kernel the env never ran and thrown away.  They are columns of the env's step now, under this
prefix, and they are named by `megaNames` so that no list of them is ever typed twice.

They are NOT observations: `obsOf` and the policy's `machine_obs` are untouched.  These are for
the env's own physics, the reward, the scene and the checks. -/
def mountNames : Array String := megaNames.map (fun n => "mount_" ++ n)

/-- the env's own columns -/
def envOwnNames : Array String := #[
  "az_next", "t_next", "slack_next", "wire_len", "t_dead", "stalled", "taut", "wire_holds", "arm",
  "swing_rate", "az_rate", "pointing_err", "el_dish", "sun_reachable", "lost_sun", "sun_reachable_s", "lost_sun_s",
  "capture", "capture_s", "per_dni", "p_in", "T_oil", "q_abs", "q_coil_loss", "q_pipe", "q_pot", "q_net",
  "obs_e_az", "obs_e_el", "obs_swing", "obs_taut", "obs_holds", "obs_oil", "obs_reach_s", "obs_lost_s",
  "flux_0", "flux_1", "flux_2", "flux_3", "flux_4", "flux_5", "flux_6", "flux_7",
  "coil_0", "coil_1", "coil_2", "coil_3", "coil_4", "coil_5", "coil_6", "coil_7",
  "hist_0", "hist_1", "hist_2", "hist_3", "hist_4", "hist_5", "hist_6", "hist_7",
  "hist_8", "hist_9", "hist_10", "hist_11", "hist_12", "hist_13", "hist_14", "hist_15",
  "ret_0", "ret_1", "ret_2", "ret_3", "ret_4", "ret_5", "ret_6", "ret_7",
  "ret_8", "ret_9", "ret_10", "ret_11", "ret_12", "ret_13", "ret_14", "ret_15",
  "T_film", "film_margin", "flow", "deg", "p_pump", "mcp", "UA_x", "delay", "fault", "expansion",
  "obs_margin", "obs_flow", "obs_deg",
  "wire_run", "wire_paid", "wire_bight", "wire_wind"]

/-- the columns: the env's own, then the mount's -/
def envNames : Array String := envOwnNames ++ mountNames

theorem envOwnNames_size : envOwnNames.size = 100 := by rfl
theorem envNames_size : envNames.size = 100 + 230 := by
  simp only [envNames, mountNames, Array.size_append, Array.size_map, envOwnNames_size,
    megaNames_size]

/-- the capture is a mean of Booleans: in `[0, 1]` -/
theorem hashemiEnv_capture_mem (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) :
    0 ≤ hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr 17 ∧
      hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr 17 ≤ 1 := by
  simp only [hashemiEnv]
  simp only [Matrix.cons_val]
  have h : ∀ i : Fin 64,
      0 ≤ dishPower R f a w rc k σslope σspec rho hsun
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc 0)
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc 1) elSun azSun
        (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0 ∧
      dishPower R f a w rc k σslope σspec rho hsun
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc 0)
        (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc 1) elSun azSun
        (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) 0 ≤ 1 := by
    intro i
    rcases dishPower_captured R f a w rc k σslope σspec rho hsun
      (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc 0)
      (megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen a w rc 1) elSun azSun
      (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5) (dr i 6) (dr i 7) (dr i 8) (dr i 9) with e | e <;>
      rw [e] <;> norm_num
  constructor
  · exact div_nonneg (Finset.sum_nonneg fun i _ => (h i).1) (by norm_num)
  · rw [div_le_one (by norm_num)]
    calc _ ≤ ∑ _i : Fin 64, (1 : ℝ) := Finset.sum_le_sum fun i _ => (h i).2
      _ = 64 := by simp

/-- **the pump's command is a command**: the flow column lies between nothing and `Qmax`, and
the observation the policy reads of it is a fraction in `[0, 1]` - whatever the head emits -/
theorem hashemiEnv_flow_mem (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) (hQ : 0 ≤ Qmax) :
    0 ≤ hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr 85 ∧
      hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr 85 ≤ Qmax := by
  simp only [hashemiEnv, Matrix.cons_val]
  have h0 : 0 ≤ min (max uPump 0) 1 := le_min (le_max_right _ _) (by norm_num)
  have h1 : min (max uPump 0) 1 ≤ 1 := min_le_right _ _
  constructor
  · exact mul_nonneg hQ h0
  · nlinarith

/-- the pipe's density record moves one station: the new history's head is the coil's outlet -/
theorem hashemiEnv_hist_head (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa : ℝ)
    (hist ret : Fin 16 → ℝ) (dr : Fin 64 → Fin 10 → ℝ) :
    hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr 51
      = hashemiEnv az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
        R f a w rc k σslope σspec hsun soil α ε Ac Twall Ta uPump Qmax Dp Lp Dins kIns Vw etaP Pidle Axch UAxMax Ccoil degPrev degA degEa hist ret dr 21 := by
  simp only [hashemiEnv]
  simp only [Matrix.cons_val, shift]

end TandoorHashemi

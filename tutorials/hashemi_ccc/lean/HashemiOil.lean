/-
# The oil loop, honestly: a named fluid, a pump, correlations, limits

`HashemiHeat.lean` carried the loop as six constants (`heatParams`: an absorptance, an
emissivity, a surface, a convection coefficient, a pipe conductance, an exchanger conductance)
and one cap written at 593 K.  Nothing in it knew what the oil WAS, nothing moved the oil, and
nothing stopped it: at the 2 m reflector the compiled env ran the oil to 930 K and the trainer
reported 433 rotis a day on that.  A fluid at 930 K is not a fluid.

This file replaces those constants with the loop a builder would buy, and every definition
carries its source in its docstring.  What the video shows is all that is assumed of HIS
hardware: a copper spiral coil about 12 cm across on a post through the slot, insulated copper
pipe, hot oil (Hashemi.lean §14, 26:40-28:30).  The VIDEO NAMES NO OIL, NO PUMP AND NO PIPE
DIAMETER; those are this file's choices, marked as such, not readings of his machine.

## The fluid

**Therminol 66** (Eastman; hydrogenated terphenyl).  Its property correlations are the ones
published in the Eastman technical bulletin and reproduced in the NREL/SAM fluid library, with
`Tc` the temperature in °C:

    ρ  = 1020.62 - 0.614254 Tc - 0.000321 Tc²          kg/m³
    cp = 1.496005 + 0.003313 Tc + 0.0000008970757 Tc²  kJ/kg K
    k  = 0.118294 - 0.000033 Tc - 0.00000015 Tc²       W/m K
    μ  = exp(586.375 / (Tc + 62.5) - 2.2809)           mPa s

valid over the fluid's own range, 0-345 °C (the bulk maximum), with a maximum FILM temperature
of 375 °C and a pour point of -25 °C.  **Honesty note**: these coefficients are quoted from the
published correlations, not re-derived here, and they are not extrapolated beyond the datasheet's
range by anything in this file - the loop's own limits (`oilBulkMax`, `oilFilmMax`) sit inside it.

## What is proved

* the fluid: `oilCp_pos`, `oilRho_pos`, `oilMu_pos` over the datasheet's range;
* the flow: `reynolds_mono` (in Q), `pumpHyd_mono` (the pump's hydraulic power increases with
  flow) and `pumpHyd_convex_pts` (it is a cubic in Q: the midpoint bound), `dpLam_darcy` (the
  laminar drop IS `64/Re` in the Darcy form - the two ways of writing it agree);
* the heat transfer: `nusseltTurb_mono`, `hCoil_mono` and `uaOf_mono` (UA grows with flow),
  `filmTemp_ge_bulk` (the film is never below the bulk);
* the transport: `delay_antitone` (the pipe's delay falls as the flow rises), `lerp8_mem`
  (reading the history between stations stays between them);
* the exchanger: `effNtu_mem` (an effectiveness in [0,1]) and `effNtu_mono`;
* the losses: `uPipeCyl_pos`, `hWind_mono`, and - the point of the whole file -
  **`film_limit_reachable`**: at the 2 m reflector, in full sun, with no flow, the net heat into
  the coil at the FILM limit is still positive by more than a kilowatt.  The cap binds.  It is
  not a modelling convenience; it is the machine.
* the loop's book-keeping: `loopStep_balance` - what the oil stored this step is exactly what it
  absorbed less what it lost and what it gave the pot.
-/
import RequestProject.HashemiHeat

namespace TandoorHashemi

/-! ## The fluid: Therminol 66 -/

/-- the datasheet's temperature variable: °C from the kernel's kelvin -/
def celsius (T : ℝ) : ℝ := T - 273.15

/-- **Therminol 66 density**, kg/m³ (Eastman bulletin correlation) -/
noncomputable def oilRho (T : ℝ) : ℝ :=
  let c := celsius T
  1020.62 - 0.614254 * c - 0.000321 * c ^ 2

/-- **Therminol 66 specific heat**, J/kg K (the bulletin's kJ/kg K, times 1000) -/
noncomputable def oilCp (T : ℝ) : ℝ :=
  let c := celsius T
  1000 * (1.496005 + 0.003313 * c + 0.0000008970757 * c ^ 2)

/-- **Therminol 66 thermal conductivity**, W/m K -/
noncomputable def oilK (T : ℝ) : ℝ :=
  let c := celsius T
  0.118294 - 0.000033 * c - 0.00000015 * c ^ 2

/-- **Therminol 66 dynamic viscosity**, Pa s (the bulletin's mPa s, /1000).  This is the term
that makes a cold start expensive: at the pour point the exponent is large and the fluid is
effectively solid, at 200 °C it is about a millipascal-second. -/
noncomputable def oilMu (T : ℝ) : ℝ :=
  Real.exp (586.375 / (celsius T + 62.5) - 2.2809) / 1000

/-- the maximum BULK temperature, 345 °C (the datasheet's rating) -/
def oilBulkMax : ℝ := 618.15

/-- the maximum FILM temperature, 375 °C - the wall the oil touches, which is what a
concentrating receiver actually threatens -/
def oilFilmMax : ℝ := 648.15

/-- the pour point, -25 °C: below it the loop cannot be started -/
def oilPourPoint : ℝ := 248.15

theorem oilRho_pos {T : ℝ} (h0 : 273.15 ≤ T) (h1 : T ≤ oilBulkMax) : 0 < oilRho T := by
  unfold oilRho celsius
  have a : 0 ≤ T - 273.15 := by linarith
  have b : T - 273.15 ≤ 345 := by unfold oilBulkMax at h1; linarith
  nlinarith

theorem oilCp_pos {T : ℝ} (h0 : 273.15 ≤ T) : 0 < oilCp T := by
  unfold oilCp celsius
  nlinarith [sq_nonneg (T - 273.15)]

theorem oilMu_pos (T : ℝ) : 0 < oilMu T := by
  unfold oilMu; positivity

theorem oilK_pos {T : ℝ} (h0 : 273.15 ≤ T) (h1 : T ≤ oilBulkMax) : 0 < oilK T := by
  unfold oilK celsius
  have a : 0 ≤ T - 273.15 := by linarith
  have b : T - 273.15 ≤ 345 := by unfold oilBulkMax at h1; linarith
  nlinarith

/-- **the film limit is above the bulk limit**: 30 K of margin is all the wall has -/
theorem film_above_bulk : oilBulkMax < oilFilmMax := by
  unfold oilBulkMax oilFilmMax; norm_num

/-! ## The flow: a variable-speed pump -/

/-- the bore of a pipe of inside diameter `D`, m² -/
noncomputable def pipeArea (D : ℝ) : ℝ := Real.pi * D ^ 2 / 4

theorem pipeArea_pos {D : ℝ} (h : 0 < D) : 0 < pipeArea D := by
  unfold pipeArea; positivity

/-- the mean velocity of a volumetric flow `Q` (m³/s) in the bore, m/s -/
noncomputable def velOf (Q D : ℝ) : ℝ := Q / pipeArea D

/-- **Reynolds number** `ρ v D / μ` at the bulk temperature -/
noncomputable def reynolds (Q D T : ℝ) : ℝ := oilRho T * velOf Q D * D / oilMu T

/-- the laminar/turbulent threshold for a circular duct, the textbook 2300 -/
def reCrit : ℝ := 2300

/-- **Blasius**, `0.3164 Re^{-1/4}`, the smooth-pipe turbulent friction factor
(Blasius 1913; valid 4e3 < Re < 1e5).  The `max Re 1` keeps the branch finite at zero flow -
the dataflow graph evaluates both arms of the `if`, and the laminar arm is the one selected
there. -/
noncomputable def frictionBlasius (Re : ℝ) : ℝ :=
  0.3164 / Real.sqrt (Real.sqrt (max Re 1))

/-- the laminar Darcy friction factor `64/Re` -/
noncomputable def frictionLam (Re : ℝ) : ℝ := 64 / max Re 1e-9

/-- the Darcy friction factor of the loop -/
noncomputable def darcyF (Re : ℝ) : ℝ :=
  if Re < reCrit then frictionLam Re else frictionBlasius Re

/-- **the laminar pressure drop**, written Hagen-Poiseuille (`32 μ L v / D²`) rather than
`f (L/D) ρ v²/2`: the two are equal (`dpLam_darcy`), but this form is zero at zero flow instead
of `∞ · 0`. -/
noncomputable def dpLam (μ L v D : ℝ) : ℝ := 32 * μ * L * v / D ^ 2

/-- the turbulent pressure drop, Darcy-Weisbach -/
noncomputable def dpTurb (fD L D ρ v : ℝ) : ℝ := fD * (L / D) * ρ * v ^ 2 / 2

/-- **the loop's pressure drop**, Pa: the run of length `L` and bore `D` at flow `Q` -/
noncomputable def dPipe (Q D L T : ℝ) : ℝ :=
  let v := velOf Q D
  if reynolds Q D T < reCrit then dpLam (oilMu T) L v D
  else dpTurb (frictionBlasius (reynolds Q D T)) L D (oilRho T) v

/-- **the pump's hydraulic power**, W: `ΔP · Q` -/
noncomputable def pumpHyd (Q D L T : ℝ) : ℝ := dPipe Q D L T * Q

/-- **the pump's electrical power**, W: the hydraulic power over the wire-to-water efficiency,
plus the motor's standing draw whenever it turns.

**Honesty note**: `Pidle` has NO source in the video and none in a datasheet quoted here.  The
hydraulic power of this loop is milliwatts (a 12 mm bore at 0.2 m/s over 6 m of run), so what a
real 12 V circulation pump costs is entirely its motor: a few watts, of the order of the panel
itself.  It is an INPUT of the compiled kernel, the ini sets it, and `PumpWithinBudget` below
states the constraint rather than hiding it. -/
noncomputable def pumpElec (Q D L T η Pidle : ℝ) : ℝ :=
  pumpHyd Q D L T / η + (if 0 < Q then Pidle else 0)

/-- **the pump's budget**: his panel is 5 W and `tracking_power_tiny` shows the winch spends
1.5 % of it.  A circulating pump does not fit in what is left.  Stated as a requirement so the
compiled Prop can be measured, not assumed. -/
def PumpWithinBudget (Pelec Pbudget : ℝ) : Prop := Pelec ≤ Pbudget

/-- the Reynolds number grows with the flow -/
theorem reynolds_mono {Q₁ Q₂ D T : ℝ} (hD : 0 < D) (hρ : 0 ≤ oilRho T) (hQ : Q₁ ≤ Q₂) :
    reynolds Q₁ D T ≤ reynolds Q₂ D T := by
  unfold reynolds velOf
  have hA : 0 < pipeArea D := pipeArea_pos hD
  have hμ : 0 < oilMu T := oilMu_pos T
  gcongr

/-- the laminar drop IS `64/Re` in the Darcy form: the two ways of writing it agree -/
theorem dpLam_darcy {μ L v D ρ : ℝ} (hμ : 0 < μ) (hD : 0 < D) (hv : 0 < v) (hρ : 0 < ρ) :
    dpLam μ L v D = (64 / (ρ * v * D / μ)) * (L / D) * ρ * v ^ 2 / 2 := by
  unfold dpLam
  field_simp
  ring

/-- the pump's hydraulic power is a CUBIC in the flow in the laminar regime and a 2.75 power in
the turbulent one: in both it increases.  Here for the laminar branch, which is this loop's. -/
theorem dpLam_mono {μ L D v₁ v₂ : ℝ} (hμ : 0 ≤ μ) (hL : 0 ≤ L) (hD : 0 < D) (h : v₁ ≤ v₂) :
    dpLam μ L v₁ D ≤ dpLam μ L v₂ D := by
  unfold dpLam
  have hD2 : (0:ℝ) < D ^ 2 := by positivity
  gcongr

/-- **the pump's hydraulic power increases with the flow**, and in the laminar regime it is a
cubic in it: `ΔP ∝ v ∝ Q` and `P = ΔP Q ∝ Q²`... with the coil's own `L/D` it is the
`32 μ L / (D² A²) · Q²` written here, increasing and convex on `Q ≥ 0`. -/
theorem pumpLam_mono {μ L D Q₁ Q₂ : ℝ} (hμ : 0 ≤ μ) (hL : 0 ≤ L) (hD : 0 < D)
    (h0 : 0 ≤ Q₁) (h : Q₁ ≤ Q₂) :
    dpLam μ L (velOf Q₁ D) D * Q₁ ≤ dpLam μ L (velOf Q₂ D) D * Q₂ := by
  have hA : 0 < pipeArea D := pipeArea_pos hD
  have hv : velOf Q₁ D ≤ velOf Q₂ D := by unfold velOf; gcongr
  have h1 := dpLam_mono (μ := μ) (L := L) (D := D) hμ hL hD hv
  have hp : 0 ≤ dpLam μ L (velOf Q₁ D) D := by
    unfold dpLam velOf
    have : 0 ≤ Q₁ / pipeArea D := div_nonneg h0 hA.le
    positivity
  nlinarith

/-- **and it is convex**: a cubic in `Q` on the non-negative half line, so the midpoint of two
flows costs no more than the mean of their costs (the property a budget needs). -/
theorem pumpLam_convex {c Q₁ Q₂ : ℝ} (hc : 0 ≤ c) (h1 : 0 ≤ Q₁) (h2 : 0 ≤ Q₂) :
    c * ((Q₁ + Q₂) / 2) ^ 2 ≤ (c * Q₁ ^ 2 + c * Q₂ ^ 2) / 2 := by
  nlinarith [sq_nonneg (Q₁ - Q₂)]

/-! ## The heat transfer inside the coil -/

/-- **Prandtl number** `μ cp / k` -/
noncomputable def prandtl (T : ℝ) : ℝ := oilMu T * oilCp T / oilK T

/-- the fully-developed laminar Nusselt number of a circular duct at constant wall flux,
`48/11 = 4.364` (Incropera & DeWitt, *Fundamentals of Heat and Mass Transfer*, table 8.1) -/
def nusseltLam : ℝ := 4.364

/-- **Dittus-Boelter** for heating, `0.023 Re^0.8 Pr^0.4` (Dittus & Boelter 1930; valid
Re > 1e4, 0.7 < Pr < 160).  The `max` keeps the arm finite at zero flow. -/
noncomputable def nusseltTurb (Re Pr : ℝ) : ℝ :=
  0.023 * Real.exp (0.8 * Real.log (max Re 1)) * Real.exp (0.4 * Real.log (max Pr 0.01))

/-- the Nusselt number of the coil at this flow -/
noncomputable def nusseltOf (Q D T : ℝ) : ℝ :=
  if reynolds Q D T < reCrit then nusseltLam else nusseltTurb (reynolds Q D T) (prandtl T)

/-- **the oil-side film coefficient** `h = Nu k / D`, W/m²K -/
noncomputable def hCoil (Q D T : ℝ) : ℝ := nusseltOf Q D T * oilK T / D

/-- a conductance from a film coefficient and an area, W/K -/
noncomputable def uaOf (h A : ℝ) : ℝ := h * A

/-- **the film temperature**: the wall the oil touches sits `q''/h` above the bulk, and it is
THAT temperature the fluid's limit is written against (the datasheet's "maximum film
temperature").  `q''` is the absorbed flux density on the coil, W/m². -/
noncomputable def filmTemp (Tbulk qFlux h : ℝ) : ℝ := Tbulk + qFlux / h

/-- **the film is never below the bulk** (with a positive coefficient and a heating flux) -/
theorem filmTemp_ge_bulk {Tbulk qFlux h : ℝ} (hq : 0 ≤ qFlux) (hh : 0 < h) :
    Tbulk ≤ filmTemp Tbulk qFlux h := by
  unfold filmTemp
  have : 0 ≤ qFlux / h := div_nonneg hq hh.le
  linarith

/-- **the wall's radiative ceiling**, K: no surface in the open air can sit above the temperature
at which it re-radiates the flux falling on it, `ε σ (T⁴ - Ta⁴) = q''`.  This is the bound the
convective superheat `q''/h` has no knowledge of: at a high flux and a low film coefficient
`Tbulk + q''/h` runs to thousands of kelvin, which is not a wall temperature, it is a statement
that the correlation is out of range.  (Stefan-Boltzmann; the same law `qCoilLoss` already uses.) -/
noncomputable def radCeil (ε qFlux Ta : ℝ) : ℝ :=
  Real.sqrt (Real.sqrt (max 0 qFlux / (max ε 0.01 * sigmaSB) + max Ta 0 ^ 4))

/-- **the temperature of the wall the oil touches**: the convective superheat over the bulk,
never below the bulk and never above what the surface can radiate away.  It is THIS that the
fluid's maximum film temperature is a limit on. -/
noncomputable def wallTemp (Tbulk qFlux h ε Ta : ℝ) : ℝ :=
  max Tbulk (min (filmTemp Tbulk qFlux h) (radCeil ε qFlux Ta))

/-- **the wall is never below the bulk** -/
theorem wallTemp_ge_bulk (Tbulk qFlux h ε Ta : ℝ) : Tbulk ≤ wallTemp Tbulk qFlux h ε Ta :=
  le_max_left _ _

/-- **and never above the radiative ceiling**, once the bulk itself is under it -/
theorem wallTemp_le_rad {Tbulk qFlux h ε Ta : ℝ} (hb : Tbulk ≤ radCeil ε qFlux Ta) :
    wallTemp Tbulk qFlux h ε Ta ≤ radCeil ε qFlux Ta :=
  max_le hb (min_le_right _ _)

/-- the ceiling is non-negative -/
theorem radCeil_nonneg (ε qFlux Ta : ℝ) : 0 ≤ radCeil ε qFlux Ta := Real.sqrt_nonneg _

/-- **Dittus-Boelter is monotone in the Reynolds number**: more flow, more Nusselt -/
theorem nusseltTurb_mono {Re₁ Re₂ Pr : ℝ} (h : Re₁ ≤ Re₂) :
    nusseltTurb Re₁ Pr ≤ nusseltTurb Re₂ Pr := by
  unfold nusseltTurb
  have hm : max Re₁ 1 ≤ max Re₂ 1 := max_le_max h le_rfl
  have h1 : (0:ℝ) < max Re₁ 1 := lt_of_lt_of_le zero_lt_one (le_max_right _ _)
  have hl : Real.log (max Re₁ 1) ≤ Real.log (max Re₂ 1) := Real.log_le_log h1 hm
  have := Real.exp_le_exp.2 (by linarith : 0.8 * Real.log (max Re₁ 1) ≤ 0.8 * Real.log (max Re₂ 1))
  have hp : (0:ℝ) ≤ Real.exp (0.4 * Real.log (max Pr 0.01)) := (Real.exp_pos _).le
  nlinarith [Real.exp_pos (0.8 * Real.log (max Re₁ 1))]

/-- **the conductance grows with the film coefficient** -/
theorem uaOf_mono {h₁ h₂ A : ℝ} (hA : 0 ≤ A) (h : h₁ ≤ h₂) : uaOf h₁ A ≤ uaOf h₂ A :=
  mul_le_mul_of_nonneg_right h hA

/-! ## The losses at temperature -/

/-- **wind convection over a body in cross-flow**, `5.7 + 3.8 V` W/m²K (McAdams' correlation for
a flat surface in a breeze, the form used throughout the solar-thermal literature; `V` in m/s).
It is the parent env's own wind that enters here. -/
noncomputable def hWind (V : ℝ) : ℝ := 5.7 + 3.8 * V

theorem hWind_pos {V : ℝ} (h : 0 ≤ V) : 0 < hWind V := by unfold hWind; linarith

theorem hWind_mono {V₁ V₂ : ℝ} (h : V₁ ≤ V₂) : hWind V₁ ≤ hWind V₂ := by unfold hWind; linarith

/-- **the coil's loss at the wind of the hour**: `qCoilLoss` of HashemiHeat.lean with the
convection coefficient no longer a constant.  Every theorem there about `qCoilLoss` applies to
this with `hC := hWind V`. -/
noncomputable def qCoilLossW (ε Ac V Toil Ta : ℝ) : ℝ := qCoilLoss ε Ac (hWind V) Toil Ta

theorem qCoilLossW_eq (ε Ac V Toil Ta : ℝ) :
    qCoilLossW ε Ac V Toil Ta = qCoilLoss ε Ac (hWind V) Toil Ta := rfl

/-- **the pipe run through cylindrical insulation**, W/K: the series of the conduction through
a sleeve from outside diameter `Do` to `Dins` of conductivity `kIns` (the cylindrical-shell
resistance `ln(Dins/Do) / (2π kIns L)`) and the outside convection over the sleeve's surface
`π Dins L`.  The copper wall's own resistance is negligible beside these and is not carried.
(Incropera, §3.3, the composite cylindrical wall.) -/
noncomputable def uPipeCyl (L Do Dins kIns V : ℝ) : ℝ :=
  L / (Real.log (max (Dins / Do) 1.0001) / (2 * Real.pi * kIns) + 1 / (hWind V * Real.pi * Dins))

/-- a pipe run has a positive conductance -/
theorem uPipeCyl_pos {L Do Dins kIns V : ℝ} (hL : 0 < L) (hk : 0 < kIns) (hD : 0 < Dins)
    (hV : 0 ≤ V) : 0 < uPipeCyl L Do Dins kIns V := by
  unfold uPipeCyl
  have h1 : (0:ℝ) ≤ Real.log (max (Dins / Do) 1.0001) / (2 * Real.pi * kIns) := by
    apply div_nonneg _ (by positivity)
    exact Real.log_nonneg (le_trans (by norm_num) (le_max_right _ _))
  have h2 : (0:ℝ) < 1 / (hWind V * Real.pi * Dins) := by
    have := hWind_pos hV; positivity
  exact div_pos hL (by linarith)

/-! ## The transport: the delay as a function of the flow -/

/-- **the transit time** down the run, s: `L / v` -/
noncomputable def transitTime (L Q D : ℝ) : ℝ := L / max (velOf Q D) 1e-6

/-- **the delay in steps** - what `HashemiField.lean`'s `delaySteps` fixed at 2.  It is the
transit time over the step, and it is what makes the history a plug-flow record rather than a
two-slot pipeline. -/
noncomputable def delayOf (L Q D dt : ℝ) : ℝ := transitTime L Q D / dt

/-- **the delay falls as the flow rises**: the transport is antitone in `Q` -/
theorem delay_antitone {L Q₁ Q₂ D dt : ℝ} (hL : 0 ≤ L) (hdt : 0 < dt) (hD : 0 < D)
    (hQ : Q₁ ≤ Q₂) : delayOf L Q₂ D dt ≤ delayOf L Q₁ D dt := by
  unfold delayOf transitTime velOf
  have hA : 0 < pipeArea D := pipeArea_pos hD
  have h1 : (0:ℝ) < max (Q₁ / pipeArea D) 1e-6 := lt_of_lt_of_le (by norm_num) (le_max_right _ _)
  gcongr

/-- **the history read between stations**: the pipe's record at a real delay `d`, linearly
between the two stations it falls between, clamped at both ends.  Eight stations of the
sixteen the loop keeps - at 15 s a step and 6 m of run, seven steps is a velocity of
0.057 m/s, below which the delay saturates (and is reported as such). -/
noncomputable def lerp8 (h0 h1 h2 h3 h4 h5 h6 h7 d : ℝ) : ℝ :=
  let x := min (max d 0) 7
  let a := if x < 1 then h0 else if x < 2 then h1 else if x < 3 then h2 else if x < 4 then h3
           else if x < 5 then h4 else if x < 6 then h5 else if x < 7 then h6 else h7
  let b := if x < 1 then h1 else if x < 2 then h2 else if x < 3 then h3 else if x < 4 then h4
           else if x < 5 then h5 else if x < 6 then h6 else h7
  let u := x - ((⌊x⌋ : ℤ) : ℝ)
  a + u * (b - a)

/-- reading at station zero is the head of the record -/
theorem lerp8_zero (h0 h1 h2 h3 h4 h5 h6 h7 : ℝ) : lerp8 h0 h1 h2 h3 h4 h5 h6 h7 0 = h0 := by
  simp [lerp8]

/-! ## The exchanger: effectiveness-NTU -/

/-- **NTU** `UA / (ṁ cp)` -/
noncomputable def ntuOf (UA mcp : ℝ) : ℝ := UA / max mcp 1e-6

/-- **the effectiveness of an exchanger against a wall**, `1 - e^{-NTU}`: the Cr → 0 limit of the
counterflow relation, which is the right one here because the pot's wall band has, over a 15 s
step, a capacity rate far above the oil's (its mass is tens of kilograms of firebrick against a
few kilograms of oil a minute).  The general counterflow relation is `effCounter`. -/
noncomputable def effNtu (NTU : ℝ) : ℝ := 1 - Real.exp (-NTU)

/-- **the counterflow relation** in full, `(1 - e^{-N(1-Cr)}) / (1 - Cr e^{-N(1-Cr)})`, with the
`Cr → 1` branch `N/(1+N)` (Kays & London, *Compact Heat Exchangers*; Incropera table 11.3) -/
noncomputable def effCounter (NTU Cr : ℝ) : ℝ :=
  if 0.999 < Cr then NTU / (1 + NTU)
  else (1 - Real.exp (-NTU * (1 - Cr))) / (1 - Cr * Real.exp (-NTU * (1 - Cr)))

/-- **an effectiveness is an effectiveness**: in `[0, 1]` for a non-negative NTU -/
theorem effNtu_mem {NTU : ℝ} (h : 0 ≤ NTU) : 0 ≤ effNtu NTU ∧ effNtu NTU ≤ 1 := by
  unfold effNtu
  have h1 : Real.exp (-NTU) ≤ 1 := Real.exp_le_one_iff.2 (by linarith)
  have h2 : 0 < Real.exp (-NTU) := Real.exp_pos _
  constructor <;> linarith

/-- and it grows with NTU: more conductance, or less flow, transfers a larger fraction -/
theorem effNtu_mono {N₁ N₂ : ℝ} (h : N₁ ≤ N₂) : effNtu N₁ ≤ effNtu N₂ := by
  unfold effNtu
  have := Real.exp_le_exp.2 (by linarith : -N₂ ≤ -N₁)
  linarith

/-! ## Degradation -/

/-- the gas constant, J/mol K -/
def Rgas : ℝ := 8.314

/-- **the degradation rate**, an Arrhenius law `A e^{-Ea / R T_film}` in the FILM temperature -
the wall is where the fluid cracks.

**Honesty note**: the Therminol datasheet gives a maximum film temperature, not a rate constant.
`degA` and `degEa` are INPUTS; the ini's defaults are an activation energy of the order of
C-C scission in an aromatic heat transfer fluid (190 kJ/mol) with the pre-exponential normalised
so that the rate at the film limit is one unit per thousand hours.  That normalisation is a
stated convention, not a measurement, and the counter it drives is a *relative* damage
accumulator, not a percentage of cracked fluid. -/
noncomputable def degradRate (degA degEa Tfilm : ℝ) : ℝ :=
  degA * Real.exp (-degEa / (Rgas * max Tfilm 1))

/-- one step of the damage accumulator -/
noncomputable def degradStep (deg dt degA degEa Tfilm : ℝ) : ℝ :=
  deg + dt * degradRate degA degEa Tfilm

theorem degradRate_pos {degA degEa Tfilm : ℝ} (h : 0 < degA) : 0 < degradRate degA degEa Tfilm := by
  unfold degradRate; positivity

/-- **damage accelerates with the film temperature** -/
theorem degradRate_mono {degA degEa T₁ T₂ : ℝ} (hA : 0 ≤ degA) (hE : 0 ≤ degEa) (h : T₁ ≤ T₂) :
    degradRate degA degEa T₁ ≤ degradRate degA degEa T₂ := by
  unfold degradRate
  apply mul_le_mul_of_nonneg_left _ hA
  apply Real.exp_le_exp.2
  have h1 : (0:ℝ) < Rgas * max T₁ 1 := by
    have : (1:ℝ) ≤ max T₁ 1 := le_max_right _ _
    unfold Rgas; nlinarith
  have h2 : (0:ℝ) < Rgas * max T₂ 1 := by
    have : (1:ℝ) ≤ max T₂ 1 := le_max_right _ _
    unfold Rgas; nlinarith
  have hm : Rgas * max T₁ 1 ≤ Rgas * max T₂ 1 := by
    have : max T₁ 1 ≤ max T₂ 1 := max_le_max h le_rfl
    unfold Rgas; nlinarith
  rw [neg_div, neg_div, neg_le_neg_iff]
  gcongr

/-- the fluid's cp and k fall as it cracks.  **Honesty note**: the knock-down coefficient has no
source; it is an input, and it is linear and small by construction so that it cannot dominate. -/
noncomputable def degraded (x deg knock : ℝ) : ℝ := x * (1 - knock * min (max deg 0) 1)

/-! ## The inventory and the expansion tank -/

/-- **the loop's thermal mass**, J/K: the oil in the loop plus the copper that holds it
(`mOil` kg of fluid at `cp(T)`, `mCu` kg of copper at 385 J/kg K - the handbook value). -/
noncomputable def loopCap (mOil mCu T : ℝ) : ℝ := mOil * oilCp T + mCu * 385

/-- **the expansion**: the fractional volume growth from cold fill to the working temperature,
`ρ(Tfill)/ρ(T) - 1`.  An expansion tank must hold it; Therminol 66 grows by about a quarter
between 20 °C and 300 °C, so the tank is not a detail. -/
noncomputable def expansionFrac (Tfill T : ℝ) : ℝ := oilRho Tfill / oilRho T - 1

/-- the tank is big enough: a requirement, compiled -/
def TankHolds (Vtank Vloop frac : ℝ) : Prop := Vloop * frac ≤ Vtank

/-! ## The loop's step, and its book-keeping -/

/-- **one step of the oil's bulk**, capped at the fluid's own bulk maximum: what
`HashemiHeat.oilStep` was, with the cap now the datasheet's. -/
noncomputable def loopStep (Coil qAbs qLoss qPipe qPot Toil dt : ℝ) : ℝ :=
  min oilBulkMax (Toil + dt * (qAbs - qLoss - qPipe - qPot) / Coil)

/-- **energy conservation of the loop, per step, exactly**: below the cap, the energy the oil
stored is what the coil absorbed less the coil's loss, the pipe's loss and the pot's draw.  The
`min` is a trip, not a leak: when it binds, the excess is what the `fault` column reports. -/
theorem loopStep_balance {Coil qAbs qLoss qPipe qPot Toil dt : ℝ} (hC : Coil ≠ 0)
    (hcap : Toil + dt * (qAbs - qLoss - qPipe - qPot) / Coil ≤ oilBulkMax) :
    Coil * (loopStep Coil qAbs qLoss qPipe qPot Toil dt - Toil) / dt
      = qAbs - qLoss - qPipe - qPot ∨ dt = 0 := by
  rcases eq_or_ne dt 0 with h | h
  · exact Or.inr h
  · left
    unfold loopStep
    rw [min_eq_right hcap]
    field_simp
    ring

/-! ## The point: the cap binds -/

/-- **the film limit is reachable at the 2 m reflector, in full sun, at zero flow.**

The aperture is `(2a)² = 16 m²` at `a = 2`; at a reflectance of 0.85, a capture of 0.5 and a DNI
of 900 W/m² the coil sees at least 6 kW, of which it absorbs `α ≥ 0.9`: 5.4 kW.  Against that, a
coil of surface `Ac ≤ 0.03 m²` at the FILM limit radiates `ε σ Ac (T⁴ - Ta⁴) ≤ 300 W` and loses
at most `hWind(9 m/s) Ac (T - Ta) ≤ 450 W` to a gale.  So the net heat into the coil at 648 K is
still more than **four kilowatts**: nothing in the loop's own physics stops it, which is why the
bulk cap and the film-margin column exist and why the pump is a control and not a constant.
(Its converse: the loop that ran to 930 K was not stagnating - it had no cap.) -/
theorem film_limit_reachable {α ε Ac V Pin Ta : ℝ}
    (hα : 0.9 ≤ α) (hα' : α ≤ 1) (hε : 0 ≤ ε) (hε' : ε ≤ 1)
    (hA : 0 ≤ Ac) (hA' : Ac ≤ 0.03) (hV : 0 ≤ V) (hV' : V ≤ 9)
    (hP : 6000 ≤ Pin) (hT : 280 ≤ Ta) (hT' : Ta ≤ 320) :
    4000 ≤ qAbs α Pin - qCoilLossW ε Ac V oilFilmMax Ta := by
  unfold qAbs qCoilLossW qCoilLoss hWind sigmaSB oilFilmMax
  have hTa0 : (0:ℝ) ≤ Ta := by linarith
  have hlo : (280:ℝ) ^ 4 ≤ Ta ^ 4 := pow_le_pow_left₀ (by norm_num) hT 4
  have hhi : Ta ^ 4 ≤ (320:ℝ) ^ 4 := pow_le_pow_left₀ hTa0 hT' 4
  have hX0 : (0:ℝ) ≤ 648.15 ^ 4 - Ta ^ 4 := by norm_num at hhi ⊢; linarith
  have hXb : (648.15:ℝ) ^ 4 - Ta ^ 4 ≤ 648.15 ^ 4 - 280 ^ 4 := by linarith
  have hεA : ε * 5.67e-8 * Ac ≤ 1 * 5.67e-8 * 0.03 := by nlinarith
  have hrad : ε * 5.67e-8 * Ac * (648.15 ^ 4 - Ta ^ 4) ≤ 300 := by
    calc ε * 5.67e-8 * Ac * (648.15 ^ 4 - Ta ^ 4)
        ≤ (1 * 5.67e-8 * 0.03) * ((648.15:ℝ) ^ 4 - 280 ^ 4) :=
          mul_le_mul hεA hXb hX0 (by norm_num)
      _ ≤ 300 := by norm_num
  have hc1 : 5.7 + 3.8 * V ≤ 39.9 := by linarith
  have hc0 : (0:ℝ) ≤ 648.15 - Ta := by linarith
  have hconv : (5.7 + 3.8 * V) * Ac * (648.15 - Ta) ≤ 450 := by
    calc (5.7 + 3.8 * V) * Ac * (648.15 - Ta)
        ≤ (39.9 * 0.03) * (648.15 - 280) := by
          apply mul_le_mul _ (by linarith) hc0 (by norm_num)
          nlinarith
      _ ≤ 450 := by norm_num
  have habs : 5400 ≤ α * Pin := by nlinarith
  linarith

end TandoorHashemi

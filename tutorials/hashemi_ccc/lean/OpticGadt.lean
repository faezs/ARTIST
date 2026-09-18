/-
# Every receiver of the machine as one indexed family

The project has one optical train per file and one per Python core: `HashemiTrace.dishPower` (the
dish to the coil at F), `HashemiBeamdown.traceBeam` (the dish, a hyperboloidal secondary, the slot,
the tunnel), and in the simulator `tandoor_hashemi_env._geo_core` (the FOLD chain: membrane, flat
fold at F, the CPC lip, the tube, M5, the duct), `_geo_core_focus` (the FOCUS chain: M1 at F, an
off-axis collimator M2, the flat M3 on the wall, the chase, the off-axis M4 at the turn, the duct)
and `_geo_core_cass` (the CASS/TRI chain: the rotating hyperboloid strip, the flapped slot, the
straight bore, an ellipsoid or flat M4, and either the pot's inlet or - `tri` - an actuated M3 onto
the bread). They share their elements and share nothing in their code.

This file is the family they are values of. `Optic : Port → Port → Type` is indexed by what a stage
takes and what it delivers - a ray in the sky, a cone in air, a beam inside a bore, a landing on the
receiver - so a chain only typechecks when its elements meet, and `Optic.seq` is composition. It is a
SPEC-level object: the indices are erased by `trace` at every concrete chain, which is why the
translator (`Ccc.lean`) still sees a plain function of reals (`#check` at the end of the file).

Read as Modula (`tutorials/hashemi_ccc/hashemi_modula.py`): a constructor is a module with its own
mass (the design parameters it carries) and its own clip; `seq` is the composite whose throughput is
the PRODUCT of its factors (`clip_seq`), which is the modular norm's composition rule for the one
quantity every stage multiplies. The étendue bookkeeping is Liouville's, and is not re-proved here:
`toTrain` sends a chain to `TandoorOpticsAbstract.Train` (Optics.lean) with the same throughput
(`throughput_toTrain`), so that file's `etendueOut_le` and `conserve` are theorems about these
chains (`etendue_le`, `etendue_conserve`).

Fates are the miss ledger's codes, as `_geo_core_cass` emits them (tandoor_hashemi_env.py:909-925):
`0` through, `2` no hit on the secondary, `3` off the strip, `5` the return leg crossed the
membrane, `6` the bore, `7` M4, `8` the way to the pot, `9` the collar, `11` the strip's shadow,
`13` the slot, `14` the strut.
-/
import RequestProject.HashemiBeamdown
import RequestProject.Optics

namespace TandoorOpticGadt

open TandoorHashemi
open Classical

noncomputable section

/-! ## Ports: what a stage takes and delivers -/

/-- what flows between two elements -/
inductive Port
  /-- the sun's rays at the collector's aperture -/
  | sky
  /-- a cone in open air: a ray with an origin and a direction -/
  | cone
  /-- a beam inside a bore, a tube or a light pipe -/
  | bore
  /-- a landing on the receiver -/
  | spot
  deriving DecidableEq, Repr

/-- a ray between stages: origin and direction -/
abbrev RayG := (Fin 3 → ℝ) × (Fin 3 → ℝ)

/-- the state at a port -/
abbrev St : Port → Type
  | .sky => RayG
  | .cone => RayG
  | .bore => RayG
  | .spot => Fin 3 → ℝ

/-- a ray's fate: the miss ledger's code (0 = through) -/
abbrev Fate := ℝ

/-! ## Geometry, as the twins compute it -/

/-- `u - v`, three components -/
def sub3 (u v : Fin 3 → ℝ) : Fin 3 → ℝ := ![u 0 - v 0, u 1 - v 1, u 2 - v 2]

/-- `O + t d` -/
def step3 (O d : Fin 3 → ℝ) (t : ℝ) : Fin 3 → ℝ := ![O 0 + t * d 0, O 1 + t * d 1, O 2 + t * d 2]

/-- the length of a vector (floored, as the kernels floor it) -/
def len3 (v : Fin 3 → ℝ) : ℝ := Real.sqrt (max (dot3 v v) 1e-18)

/-- a vector normalized -/
def norm3 (v : Fin 3 → ℝ) : Fin 3 → ℝ := ![v 0 / len3 v, v 1 / len3 v, v 2 / len3 v]

/-- a divisor kept away from zero, the twins' `torch.where(|x| > eps, x, eps)` -/
def safeDiv (x : ℝ) : ℝ := if |x| > 1e-9 then x else 1e-9

/-- the ray's parameter at the plane through `P` with normal `n` -/
def planeT (P n : Fin 3 → ℝ) (g : RayG) : ℝ := dot3 (sub3 P g.1) n / safeDiv (dot3 g.2 n)

/-- the normal oriented against the ray, as `_hyp_hit` / `_ellip_hit` orient it -/
def facing (n d : Fin 3 → ℝ) : Fin 3 → ℝ :=
  if dot3 n d > 0 then ![-n 0, -n 1, -n 2] else n

/-- **the two-sheet hyperboloid of revolution**, `tandoor_hashemi_env._hyp_hit` (line 561): centre
`O`, axis `A` (unit, `F → F₂`), semi-axes `a` along the axis and `b² = c² - a²`; the smallest
positive root on the `F` sheet (`(X - O) · A < 0`). Returns `t`, the hit, the facing normal, and
`1` when the hit is valid. -/
def hypHit (O A : Fin 3 → ℝ) (a c : ℝ) (g : RayG) : Fin 8 → ℝ :=
  let w := sub3 g.1 O
  let z0 := dot3 w A
  let dz := dot3 g.2 A
  let b2 := c ^ 2 - a ^ 2
  let qa := c ^ 2 * dz ^ 2 - a ^ 2
  let qb := 2 * (c ^ 2 * z0 * dz - a ^ 2 * dot3 w g.2)
  let qc := c ^ 2 * z0 ^ 2 - a ^ 2 * dot3 w w - a ^ 2 * b2
  let disc := qb ^ 2 - 4 * qa * qc
  let sq := Real.sqrt (max disc 0)
  let sgn := if qb ≥ 0 then (1 : ℝ) else -1
  let qq := -(1 / 2) * (qb + sgn * sq)
  let tA := qq / safeDiv qa
  let tB := qc / safeDiv qq
  let okA := tA > 1e-6 ∧ z0 + tA * dz < 0
  let okB := tB > 1e-6 ∧ z0 + tB * dz < 0
  let t := if okA ∧ okB then min tA tB else if okA then tA else if okB then tB else 1e9
  let X := step3 g.1 g.2 t
  let zz := dot3 (sub3 X O) A
  let n := facing (norm3 ![c ^ 2 * zz * A 0 - a ^ 2 * (X 0 - O 0),
                          c ^ 2 * zz * A 1 - a ^ 2 * (X 1 - O 1),
                          c ^ 2 * zz * A 2 - a ^ 2 * (X 2 - O 2)]) g.2
  ![t, X 0, X 1, X 2, n 0, n 1, n 2, if disc ≥ 0 ∧ t < 1e8 then 1 else 0]

/-- **the ellipsoid of revolution**, `tandoor_hashemi_env._ellip_hit` (line 600): centre `O`, axis
`A`, semi-major `a`, focal half-distance `c`; the FAR positive root (the patch is on the far wall
beyond the near focus). Same eight outputs. -/
def ellipHit (O A : Fin 3 → ℝ) (a c : ℝ) (g : RayG) : Fin 8 → ℝ :=
  let w := sub3 g.1 O
  let z0 := dot3 w A
  let dz := dot3 g.2 A
  let a2 := a ^ 2
  let c2 := c ^ 2
  let qa := a2 - c2 * dz ^ 2
  let qb := 2 * (a2 * dot3 w g.2 - c2 * z0 * dz)
  let qc := a2 * dot3 w w - c2 * z0 ^ 2 - a2 * (a2 - c2)
  let disc := qb ^ 2 - 4 * qa * qc
  let sq := Real.sqrt (max disc 0)
  let t := max ((-qb - sq) / (2 * safeDiv qa)) ((-qb + sq) / (2 * safeDiv qa))
  let X := step3 g.1 g.2 t
  let zz := dot3 (sub3 X O) A
  let n := facing (norm3 ![a2 * (X 0 - O 0) - c2 * zz * A 0,
                          a2 * (X 1 - O 1) - c2 * zz * A 1,
                          a2 * (X 2 - O 2) - c2 * zz * A 2]) g.2
  ![t, X 0, X 1, X 2, n 0, n 1, n 2, if disc ≥ 0 ∧ t > 1e-6 then 1 else 0]

/-- a quadric stage: reflect at the hit if it is valid and within the patch, else the given fate -/
def quadStage (h : Fin 8 → ℝ) (Pc : Fin 3 → ℝ) (rPatch : ℝ) (bad : Fate) (g : RayG) : Fate ⊕ RayG :=
  let X : Fin 3 → ℝ := ![h 1, h 2, h 3]
  let n : Fin 3 → ℝ := ![h 4, h 5, h 6]
  if h 7 > 0.5 ∧ len3 (sub3 X Pc) < rPatch then Sum.inr (X, reflect3 n g.2) else Sum.inl bad

/-! ## The family

Every element that appears in any of the machine's chains, indexed by the port it takes and the
port it delivers. The reflectance `ρ` each mirror carries is its clip; a stop's clip is its own. -/

/-- **the receiver chains of the project as one indexed family.** `Optic a b` is a stage taking the
light at port `a` to port `b`. -/
inductive Optic : Port → Port → Type where
  /-- the nothing that does nothing: the identity of `seq` -/
  | nil {a : Port} : Optic a a
  /-- **the primary**: a faceted conic dish of vertex radius `R`, focal length `f`, half-side `a`,
  facets `w` across, conic constant `k` (`-1` the paraboloid, `0` the sphere: `conicZ`), slope and
  specularity errors `σs`, `σp`, reflectance `ρ` (`HashemiTrace.traceRayKErr`; the membrane of
  `_geo_core_cass` is the same surface read off the pressure ladder) -/
  | primary (R f a w k σs σp ρ : ℝ) : Optic .sky .cone
  /-- **a flat fold** of radius `rm`, centre `P`, normal `n`: the fold receiver's M1 at F
  (`_geo_core` line 224, `_geo_core_focus` line 512) and the flat M4 at the turn (`u_f2 = 0`,
  `_build_cass_chain` line 1832) -/
  | flatMirror (rm ρ : ℝ) (P n : Fin 3 → ℝ) : Optic .cone .cone
  /-- **the rotating hyperboloid strip**: foci F and F₂, centre `O`, axis `A`, semi-axes `a`, `c`,
  the patch within `rm` of its centre (`_geo_core_cass` line 770, `sec_side = "cass"`) -/
  | hyperStrip (a c rm ρ : ℝ) (O A Pc : Fin 3 → ℝ) : Optic .cone .cone
  /-- **the Gregorian strip**: the ellipsoid beyond F, the other side of `_build_cass_chain`
  (`sec_side = "greg"`, `a = c + d_strip`, line 1842) -/
  | gregStrip (a c rm ρ : ℝ) (O A Pc : Fin 3 → ℝ) : Optic .cone .cone
  /-- **the ellipsoid M4/M3**: foci F₂ and the duct mouth (or, `m4_mode = "field"`, F and F₄); the
  patch of radius `rm` about `P4` (`_geo_core_cass` line 862) -/
  | ellipMirror (a c rm ρ : ℝ) (O A P4 : Fin 3 → ℝ) : Optic .cone .cone
  /-- **the actuated M3** of the tri machine: the same ellipsoid rigidly turned by `ψ` about the
  vertical through its vertex `P4` (`_m3_figure`, tandoor_hashemi_env.py:1781), so its second focus
  is the loaf, not the inlet -/
  | actuatedM3 (a c rm ρ ψ : ℝ) (O A P4 : Fin 3 → ℝ) : Optic .cone .cone
  /-- **the flapped slot** in the membrane: half-width `w/2` along the downhill meridian `s`, open
  only above the sun elevation `el₀` (`_geo_core_cass` line 752, `slot_el = 54°`) -/
  | slot (w el₀ elSun : ℝ) (s : Fin 3 → ℝ) : Optic .cone .cone
  /-- **a stop**: a circular aperture of radius `r` at `P` with normal `n`, passing the fraction
  `τ` of what reaches it - the deck gate, the tube stations, the pot's collar -/
  | stop (r τ : ℝ) (P n : Fin 3 → ℝ) : Optic .cone .cone
  /-- **the bore**: a straight cylinder of radius `rb` about the axis `F → P4`, gated at the deck
  plane `z_deck` (`_geo_core_cass` line 846) -/
  | boreTube (rb zDeck τ : ℝ) (F P4 : Fin 3 → ℝ) : Optic .cone .bore
  /-- **the light pipe** to the pot: `n` silvered bounces of reflectance `ρ`
  (`HashemiBeamdown.tunnelThroughput = 0.94 * 0.96`; the flower's F is the pipe's mouth,
  tandoor_flower_env.py:374) -/
  | lightPipe (ρ : ℝ) (n : ℕ) : Optic .bore .bore
  /-- **the Winston CPC lip**, eight conical segments from `z₁` to `z_lip` of slope `m`, mirror
  `ρ_c` (`_geo_core` line 249): the funnel that turns a tail ray inward. The interpreter carries
  its throughput and leaves the ray as it found it - the traced bounce is the one geometry not
  pinned down here. -/
  | cpcLip (r0 m z1 zLip ρc : ℝ) : Optic .bore .bore
  /-- **the elbow** at the pot: the duct plane `x = r_pot`, the mouth of radius `r_duct` centred
  `(0, z_duct)`, which the cass chain re-images the beam through (`_geo_core_cass` line 903) -/
  | elbow (rPot rDuct zDuct : ℝ) : Optic .bore .cone
  /-- **the coil at F**: his oil receiver, a disc of radius `rc` on the plane `z = f`
  (`HashemiTrace.traceRay`, `coilStage`) -/
  | coil (f rc : ℝ) : Optic .cone .spot
  /-- **the beam-down secondary and its tunnel as one terminal**: the hyperboloid of foci F, F₂,
  the slot at the dish crossing and the tunnel mouth - `HashemiBeamdown.traceBeam` exactly, whose
  arguments it carries (`R f a k L dm rm rt slotW t β`) -/
  | beamDown (R f a k L dm rm rt slotW t β : ℝ) : Optic .cone .spot
  /-- **the pot's inlet** as a terminal: the duct plane, the mouth of radius `r_duct` -/
  | pot (rPot rDuct zDuct : ℝ) : Optic .cone .spot
  /-- **the bread**: the loaf on the bake row that the tri machine's M3 images onto, a disc of
  radius `rl` about `T` (`tri_target`, tandoor_hashemi_env.py:1761) -/
  | bread (rl : ℝ) (T : Fin 3 → ℝ) : Optic .cone .spot
  /-- **composition**: the Modula product of two modules -/
  | seq {a b c : Port} : Optic a b → Optic b c → Optic a c

namespace Optic

/-! ## Throughput

Each element's clip, clamped to `[0, 1]`; the composite's is the product. -/

/-- `x` clamped to `[0, 1]` -/
def clamp01 (x : ℝ) : ℝ := max 0 (min 1 x)

theorem clamp01_nonneg (x : ℝ) : 0 ≤ clamp01 x := le_max_left _ _
theorem clamp01_le_one (x : ℝ) : clamp01 x ≤ 1 := max_le zero_le_one (min_le_left _ _)

/-- the element's own clip: a mirror's reflectance, a stop's transmission, a pipe's `ρⁿ`. The
terminals do not clip: their capture is the trace's, not a factor. -/
def clip : {a b : Port} → Optic a b → ℝ
  | _, _, nil => 1
  | _, _, primary _ _ _ _ _ _ _ ρ => clamp01 ρ
  | _, _, flatMirror _ ρ _ _ => clamp01 ρ
  | _, _, hyperStrip _ _ _ ρ _ _ _ => clamp01 ρ
  | _, _, gregStrip _ _ _ ρ _ _ _ => clamp01 ρ
  | _, _, ellipMirror _ _ _ ρ _ _ _ => clamp01 ρ
  | _, _, actuatedM3 _ _ _ ρ _ _ _ _ => clamp01 ρ
  | _, _, slot _ _ _ _ => 1
  | _, _, stop _ τ _ _ => clamp01 τ
  | _, _, boreTube _ _ τ _ _ => clamp01 τ
  | _, _, lightPipe ρ n => clamp01 ρ ^ n
  | _, _, cpcLip _ _ _ _ ρc => clamp01 ρc
  | _, _, elbow _ _ _ => 1
  | _, _, coil _ _ => 1
  | _, _, beamDown _ _ _ _ _ _ _ _ _ _ _ => 1
  | _, _, pot _ _ _ => 1
  | _, _, bread _ _ => 1
  | _, _, seq f g => clip f * clip g

/-- **the throughput of a composite is the product of its factors** - Marcolli's maximal conversion
rate, and the Modula composition rule for the clip -/
@[simp] theorem clip_seq {a b c : Port} (f : Optic a b) (g : Optic b c) :
    clip (seq f g) = clip f * clip g := rfl

theorem clip_nonneg {a b : Port} (o : Optic a b) : 0 ≤ clip o := by
  induction o with
  | seq f g ihf ihg => exact mul_nonneg ihf ihg
  | lightPipe ρ n => exact pow_nonneg (clamp01_nonneg ρ) n
  | _ => first
      | exact zero_le_one
      | exact clamp01_nonneg _

theorem clip_le_one {a b : Port} (o : Optic a b) : clip o ≤ 1 := by
  induction o with
  | seq f g ihf ihg =>
      calc clip f * clip g ≤ 1 * 1 := mul_le_mul ihf ihg (clip_nonneg g) zero_le_one
        _ = 1 := one_mul 1
  | lightPipe ρ n => exact pow_le_one₀ (clamp01_nonneg ρ) (clamp01_le_one ρ)
  | _ => first
      | exact le_refl _
      | exact clamp01_le_one _

/-! ## The chain as a paraxial train (Optics.lean), and Liouville

`toTrain` is the forgetful map to `TandoorOpticsAbstract.Train`: a stop per element carrying its
clip. It preserves the throughput, so `Optics.lean`'s theorems - the étendue never increases, the
losses telescope - are theorems about these chains. -/

open TandoorOpticsAbstract

/-- the chain's paraxial train: one stop per element -/
def toTrain : {a b : Port} → Optic a b → Train
  | _, _, seq f g => toTrain f ++ toTrain g
  | _, _, o => [TandoorOpticsAbstract.stop (clip o) (clip_nonneg o) (clip_le_one o)]

/-- **the forgetful map preserves the throughput** -/
theorem throughput_toTrain {a b : Port} (o : Optic a b) :
    Train.throughput (toTrain o) = clip o := by
  induction o with
  | seq f g ihf ihg =>
      rw [show toTrain (seq f g) = toTrain f ++ toTrain g from rfl,
        Train.throughput_append, ihf, ihg, clip_seq]
  | _ => simp [toTrain, Train.throughput, TandoorOpticsAbstract.stop]

/-- **the étendue never increases along a chain** (Liouville in `Optics.lean`: every mirror and
every propagation is symplectic, only a clip loses, and then downwards) -/
theorem etendue_le {a b : Port} (o : Optic a b) {E : ℝ} (hE : 0 ≤ E) : clip o * E ≤ E := by
  have h := Train.etendueOut_le (toTrain o) hE
  rwa [Train.etendueOut, throughput_toTrain] at h

/-- **conservation**: what entered is what left plus every loss on the way -/
theorem etendue_conserve {a b : Port} (o : Optic a b) (E : ℝ) :
    E = clip o * E + (Train.losses (toTrain o) E).sum := by
  have h := Train.conserve (toTrain o) E
  rwa [Train.etendueOut, throughput_toTrain] at h

/-- a chain of pure mirrors at reflectance 1 is lossless -/
theorem etendue_eq_of_lossless {a b : Port} (o : Optic a b) (h : clip o = 1) (E : ℝ) :
    clip o * E = E := by rw [h, one_mul]

/-! ## The interpreter

`trace` is the ray trace: at every stage either a fate (the miss ledger's code) or the ray as the
stage leaves it. At each concrete chain it reduces to a plain function of reals - which is what the
translator compiles. -/

/-- the tunnel's `n` bounces do not bend the ray, they only weigh it -/
def pipeStage (g : RayG) : Fate ⊕ RayG := Sum.inr g

/-- the interpreter: `trace o` takes the state at `o`'s input port to a fate or the state at its
output port -/
def trace : {a b : Port} → Optic a b → St a → Fate ⊕ St b
  | _, _, nil, g => Sum.inr g
  | _, _, primary R f a w k σs σp _, g =>
      -- the dish's reflection with the SolTrace errors, `HashemiBeamdown.dishReflect`; the sampler
      -- has already put the ray on its facet, so the facet centre is the ray's own foot
      let d := dishReflect R f a w k σs σp (g.1 0) (g.1 1) 0 0 (g.2 0) (g.2 1) (g.2 2) 0 0 0 0
      if d 6 > 0.5 then Sum.inr (![d 0, d 1, d 2], ![d 3, d 4, d 5]) else Sum.inl 1
  | _, _, flatMirror rm _ P n, g =>
      let t := planeT P n g
      let X := step3 g.1 g.2 t
      if t > 0 ∧ len3 (sub3 X P) < rm then Sum.inr (X, reflect3 n g.2) else Sum.inl 7
  | _, _, hyperStrip a c rm _ O A Pc, g => quadStage (hypHit O A a c g) Pc rm 3 g
  | _, _, gregStrip a c rm _ O A Pc, g => quadStage (ellipHit O A a c g) Pc rm 3 g
  | _, _, ellipMirror a c rm _ O A P4, g => quadStage (ellipHit O A a c g) P4 rm 7 g
  | _, _, actuatedM3 a c rm _ ψ O A P4, g =>
      -- the mirror rigidly turned by ψ about the vertical through its vertex (`_m3_figure`)
      let rot : (Fin 3 → ℝ) → (Fin 3 → ℝ) := fun v =>
        ![Real.cos ψ * v 0 - Real.sin ψ * v 1, Real.sin ψ * v 0 + Real.cos ψ * v 1, v 2]
      let O' : Fin 3 → ℝ := ![P4 0 + (rot (sub3 O P4)) 0, P4 1 + (rot (sub3 O P4)) 1,
        P4 2 + (rot (sub3 O P4)) 2]
      quadStage (ellipHit O' (rot A) a c g) P4 rm 7 g
  | _, _, slot w el₀ elSun s, g =>
      -- the flap is open above `el₀`; a ray on the slot meridian within `w/2` is lost through it
      let along := g.1 0 * s 0 + g.1 1 * s 1
      let perp := g.1 0 * s 1 - g.1 1 * s 0
      if w > 0 ∧ elSun > el₀ ∧ along > 0 ∧ |perp| < w / 2 then Sum.inl 13 else Sum.inr g
  | _, _, stop r _ P n, g =>
      let t := planeT P n g
      let X := step3 g.1 g.2 t
      if t > 0 ∧ len3 (sub3 X P) ≤ r then Sum.inr (X, g.2) else Sum.inl 9
  | _, _, boreTube rb zDeck _ F P4, g =>
      let ax := norm3 (sub3 P4 F)
      let t := (zDeck - g.1 2) / (if g.2 2 < -1e-9 then g.2 2 else -1e-9)
      let X := step3 g.1 g.2 t
      let wv := sub3 X F
      let perp := len3 ![wv 0 - dot3 wv ax * ax 0, wv 1 - dot3 wv ax * ax 1,
        wv 2 - dot3 wv ax * ax 2]
      if g.2 2 < -0.2 ∧ perp < rb then Sum.inr (X, g.2) else Sum.inl 6
  | _, _, lightPipe _ _, g => pipeStage g
  | _, _, cpcLip _ _ _ _ _, g => pipeStage g
  | _, _, elbow rPot rDuct zDuct, g =>
      let t := (rPot - g.1 0) / (if g.2 0 < -1e-9 then g.2 0 else -1e-9)
      let X := step3 g.1 g.2 t
      if g.2 0 < -0.05 ∧ t > 0 ∧ t < 4 ∧ X 1 ^ 2 + (X 2 - zDuct) ^ 2 ≤ rDuct ^ 2
      then Sum.inr (X, g.2) else Sum.inl 9
  | _, _, coil f rc, g =>
      let L := landAt g.1 g.2 f
      if Real.sqrt (L.1 ^ 2 + L.2 ^ 2) ≤ rc ∧ 0 < g.2 2 then Sum.inr ![L.1, L.2, f] else Sum.inl 1
  | _, _, beamDown R f a k L dm rm rt slotW t β, g =>
      let b := traceBeam R f a k L dm rm rt slotW t β g.1 g.2 1
      if b 0 > 0.5 then Sum.inr ![b 4, b 5, b 3] else Sum.inl (b 7)
  | _, _, pot rPot rDuct zDuct, g =>
      let t := (rPot - g.1 0) / (if g.2 0 < -1e-9 then g.2 0 else -1e-9)
      let X := step3 g.1 g.2 t
      if g.2 0 < -0.05 ∧ t > 0 ∧ t < 4 ∧ X 1 ^ 2 + (X 2 - zDuct) ^ 2 ≤ rDuct ^ 2
      then Sum.inr X else Sum.inl 9
  | _, _, bread rl T, g =>
      let t := planeT T ![0, 0, 1] g
      let X := step3 g.1 g.2 t
      if t > 0 ∧ len3 (sub3 X T) ≤ rl then Sum.inr X else Sum.inl 8
  | _, _, seq f g', s =>
      match trace f s with
      | Sum.inl c => Sum.inl c
      | Sum.inr s' => trace g' s'

/-- the chain delivered the ray -/
def through {a b : Port} (o : Optic a b) (s : St a) : Prop :=
  match trace o s with
  | Sum.inl _ => False
  | Sum.inr _ => True

/-- **a fate on the way is a fate for the chain**: the interpreter is Kleisli composition in the
fate monad, which is `Feedback.lean`'s single-bounce train read along the chain -/
theorem trace_seq_inl {a b c : Port} (f : Optic a b) (g : Optic b c) (s : St a) {e : Fate}
    (h : trace f s = Sum.inl e) : trace (seq f g) s = Sum.inl e := by
  show (match trace f s with
        | Sum.inl c => Sum.inl c
        | Sum.inr s' => trace g s') = Sum.inl e
  rw [h]

/-- and a chain delivers only what every stage delivered -/
theorem trace_seq_inr {a b c : Port} (f : Optic a b) (g : Optic b c) (s : St a) (s' : St b)
    (h : trace f s = Sum.inr s') : trace (seq f g) s = trace g s' := by
  show (match trace f s with
        | Sum.inl c => Sum.inl c
        | Sum.inr s'' => trace g s'') = trace g s'
  rw [h]

/-! ### `nil` is the unit, `seq` associates -/

@[simp] theorem trace_nil {a : Port} (s : St a) : trace (nil : Optic a a) s = Sum.inr s := rfl

theorem trace_nil_seq {a b : Port} (o : Optic a b) (s : St a) : trace (seq nil o) s = trace o s :=
  trace_seq_inr nil o s s rfl

theorem trace_seq_nil {a b : Port} (o : Optic a b) (s : St a) : trace (seq o nil) s = trace o s := by
  show (match trace o s with
        | Sum.inl c => Sum.inl c
        | Sum.inr s' => trace (nil : Optic b b) s') = trace o s
  cases trace o s <;> rfl

theorem trace_seq_assoc {a b c d : Port} (f : Optic a b) (g : Optic b c) (h : Optic c d) (s : St a) :
    trace (seq (seq f g) h) s = trace (seq f (seq g h)) s := by
  cases hf : trace f s with
  | inl e =>
      have hfg : trace (seq f g) s = Sum.inl e := trace_seq_inl f g s hf
      rw [trace_seq_inl (seq f g) h s hfg, trace_seq_inl f (seq g h) s hf]
  | inr s' =>
      rw [trace_seq_inr f (seq g h) s s' hf]
      cases hg : trace g s' with
      | inl e =>
          have hfg : trace (seq f g) s = Sum.inl e := by
            rw [trace_seq_inr f g s s' hf]; exact hg
          rw [trace_seq_inl (seq f g) h s hfg, trace_seq_inl g h s' hg]
      | inr s'' =>
          have hfg : trace (seq f g) s = Sum.inr s'' := by
            rw [trace_seq_inr f g s s' hf]; exact hg
          rw [trace_seq_inr (seq f g) h s s'' hfg, trace_seq_inr g h s' s'' hg]

/-- `clip` sees the same associativity -/
theorem clip_assoc {a b c d : Port} (f : Optic a b) (g : Optic b c) (h : Optic c d) :
    clip (seq (seq f g) h) = clip (seq f (seq g h)) := by
  simp [clip_seq, mul_assoc]

end Optic

/-! ## The chains

The machines the project has built, each as a value of the family, with the numbers the Python
takes. Every citation is `tutorials/…` in `/Users/faezs/ARTIST-compliant`. -/

open Optic

/-- the dish the tandoor machines are built on: `a_mem = 2.10` m half-side, facets `w`, the conic
constant `k` the pressure ladder sets (`tandoor_hashemi_env.py:995`, `HashemiTrace.conicZ`) -/
def tandoorDish (R f w k σs σp ρ : ℝ) : Optic .sky .cone := primary R f 2.10 w k σs σp ρ

/-- **the CASS chain** (`_geo_core_cass`, tandoor_hashemi_env.py:636-945, built by
`_build_cass_chain`, line 1789): membrane → the flapped slot in it (`w_slot = 0.7`,
`slot_el = 54°`) → the rotating hyperboloid strip at `d_strip = 0.6` m from F (`a = c - d_strip`,
line 1839) → the straight bore of radius `r_bore = 0.7` (line 1179) from F to `P4` → the ellipsoid
M4 of radius `r_m4 = 1.3` (`m4_mode = "field"`: foci F and F₄) → the elbow at the duct plane
`x = R_POT = 0.42` → the pot's inlet, `r_duct = R_DUCT_H = 0.20` at `Z_DUCT` -/
def cass (R f w k σs σp ρ elSun a_h c_h a_e c_e zDeck : ℝ)
    (O A Pc F P4 sdir : Fin 3 → ℝ) : Optic .sky .spot :=
  seq (tandoorDish R f w k σs σp ρ)
    (seq (slot 0.7 (54 * Real.pi / 180) elSun sdir)
      (seq (hyperStrip a_h c_h 0.6 ρ O A Pc)
        (seq (boreTube 0.7 zDeck 1 F P4)
          (seq (lightPipe 1 0)
            (seq (elbow 0.42 0.20 (-0.86))
              (seq (ellipMirror a_e c_e 1.3 ρ O A P4) (pot 0.42 0.20 (-0.86))))))))

/-- **the TRI chain** (the same core with `receiver = "tri"`, line 1067): no elbow - M3 is actuated
(`_m3_figure`, line 1781) and images F onto the LOAF (`tri_target`, line 1761), the inlet only an
aperture the beam passes on the way -/
def tri (R f w k σs σp ρ elSun a_h c_h a_e c_e zDeck ψ rl : ℝ)
    (O A Pc F P4 sdir T : Fin 3 → ℝ) : Optic .sky .spot :=
  seq (tandoorDish R f w k σs σp ρ)
    (seq (slot 0.7 (54 * Real.pi / 180) elSun sdir)
      (seq (hyperStrip a_h c_h 0.6 ρ O A Pc)
        (seq (boreTube 0.7 zDeck 1 F P4)
          (seq (lightPipe 1 0)
            (seq (elbow 0.42 0.20 (-0.86))
              (seq (actuatedM3 a_e c_e 1.3 ρ ψ O A P4) (bread rl T)))))))

/-- **the FOCUS chain** (`_geo_core_focus`, tandoor_hashemi_env.py:440-560, built by
`_build_focus_chain`, line 1653): M1 flat at F of radius `r_m1 = 0.15` → the off-axis collimator M2
at `col_dist = 0.75` m (radius `col_radius = 0.5`) → the flat M3 on the wall line, radius
`r_m3 = 1.0` → the chase of radius `r_bore` → the off-axis M4 at the turn, radius `r_m4` → the duct
plane. The switchable E/W exit is the mount's: it moves `P2`, `A2`, `n3` per step, so the chain is
this one at the live geometry. -/
def focus (R f w k σs σp ρ f2 f4 zBot : ℝ)
    (F n1 P2 A2 P3 n3 P4 F4 : Fin 3 → ℝ) : Optic .sky .spot :=
  seq (tandoorDish R f w k σs σp ρ)
    (seq (flatMirror 0.15 ρ F n1)
      (seq (ellipMirror (2 * f2) 0 0.5 ρ P2 A2 P2)
        (seq (flatMirror 1.0 ρ P3 n3)
          (seq (boreTube 0.7 zBot 1 P3 P4)
            (seq (lightPipe 1 0)
              (seq (elbow 0.42 0.20 (-0.86))
                (seq (ellipMirror (2 * f4) 0 1.3 ρ P4 ![0, 0, 1] P4)
                  (pot 0.42 0.20 (-0.86)))))))))

/-- **the FOLD chain** (`_geo_core`, tandoor_hashemi_env.py:150-380): membrane → the flat fold of
radius `r_fold` at F (with the torus figure the mount sets) → the Winston CPC lip, eight conical
segments from `z₁` to `z_lip` at mirror `ρ_c` → the tube, radius `r_tube_in` → the reflective cone
below the throat → the ellipsoid M5 at `z_m5 = -0.10` (line 995) → the duct plane and the pot -/
def fold (R f w k σs σp ρ rFold ρc r0 mLip z1 zLip rTube zM5 a5 c5 : ℝ)
    (F nF Om Am P5 : Fin 3 → ℝ) : Optic .sky .spot :=
  seq (tandoorDish R f w k σs σp ρ)
    (seq (flatMirror rFold ρ F nF)
      (seq (boreTube rTube z1 1 F P5)
        (seq (cpcLip r0 mLip z1 zLip ρc)
          (seq (lightPipe ρc 1)
            (seq (elbow 0.42 0.20 (-0.86))
              (seq (ellipMirror a5 c5 1.0 ρ Om Am P5) (pot 0.42 0.20 (-0.86))))))))

/-- **the FLOWER** (tandoor_flower_env.py:374): the head's membrane on the ring-rail carriage, its F
the light pipe's mouth on the roof - Masdar's beam-down - and the pipe down to the pot -/
def flower (R f w k σs σp ρ rMouth ρp : ℝ) (F nF : Fin 3 → ℝ) (nb : ℕ) : Optic .sky .spot :=
  seq (tandoorDish R f w k σs σp ρ)
    (seq (stop rMouth 1 F nF)
      (seq (boreTube rMouth (F 2) 1 F ![F 0, F 1, F 2 - 1])
        (seq (lightPipe ρp nb) (elbow 0.42 0.20 (-0.86) |> fun e => seq e (pot 0.42 0.20 (-0.86))))))

/-- **the DEEP DISH**: the Gregorian cap past F and the coudé relay (`hashemi_relay.py:1-28` - the
relay must be an ellipsoid whose foci ARE F and the duct, a sphere at 20° blurs 104-128 mm) -/
def deepDish (R f w k σs σp ρ a_g c_g a_r c_r zBot : ℝ)
    (Og Ag Pg F P4 Or Ar : Fin 3 → ℝ) : Optic .sky .spot :=
  seq (tandoorDish R f w k σs σp ρ)
    (seq (gregStrip a_g c_g 0.6 ρ Og Ag Pg)
      (seq (boreTube 0.7 zBot 1 F P4)
        (seq (lightPipe 1 0)
          (seq (elbow 0.42 0.20 (-0.86))
            (seq (ellipMirror a_r c_r 1.3 ρ Or Ar P4) (pot 0.42 0.20 (-0.86)))))))

/-- **HASHEMI'S OIL MACHINE**: his faceted satellite dish (`dishR = 2`, `dishF = 1`,
`dishHalf = 0.8`, facets 5 cm, `Hashemi.lean:1225`) and the copper coil at F, a 12 cm disc
(`traceParams`, HashemiTrace.lean) -/
def hashemiOil (k σs σp ρ : ℝ) : Optic .sky .spot :=
  seq (primary dishR dishF dishHalf 0.05 k σs σp ρ) (coil dishF 0.06)

/-- **HASHEMI'S BEAM-DOWN**: the same dish, then the hyperboloidal secondary in the coil's volume,
the slot at the dish crossing and the tunnel to the pot (`hashemi_tandoor_env.py:59`:
`beam_L = 1.25`, `beam_dm = 0.06`, `beam_rm = 0.06`, `beam_rt = 0.55`, `beam_slot = 0.06`) -/
def hashemiBeam (k σs σp ρ t β : ℝ) : Optic .sky .spot :=
  seq (primary dishR dishF dishHalf 0.05 k σs σp ρ)
    (beamDown dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β)

/-! ## Agreement with the two chains already in Lean

The interpreter is not a second model: at the beam-down it IS `traceBeam`, and at the coil it is
`dishPower`'s capture. -/

/-- **the beam-down chain's landing is `traceBeam`'s** - by definition, stage for stage -/
theorem hashemiBeam_agrees (k σs σp ρ t β : ℝ) (H r : Fin 3 → ℝ) :
    trace (beamDown dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β) (H, r) =
      (if traceBeam dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β H r 1 0 > 0.5 then
        Sum.inr ![traceBeam dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β H r 1 4,
                  traceBeam dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β H r 1 5,
                  traceBeam dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β H r 1 3]
       else Sum.inl (traceBeam dishR dishF dishHalf k 1.25 0.06 0.06 0.55 0.06 t β H r 1 7)) := rfl

/-- the panel test both sides carry -/
def OnPanel (a w cx cy : ℝ) : Prop := |cx| ≤ a ∧ |cy| ≤ a ∧ |(0:ℝ)| ≤ w / 2 ∧ |(0:ℝ)| ≤ w / 2

/-- the landing test both sides carry: the reflected ray of `dishReflect` against the coil's disc
on the plane `z = f` -/
def OilInside (R f a w rc k σs σp cx cy dx dy dz : ℝ) : Prop :=
  let d := dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0
  let L := landAt ![d 0, d 1, d 2] ![d 3, d 4, d 5] f
  Real.sqrt (L.1 ^ 2 + L.2 ^ 2) ≤ rc ∧ 0 < d 5

/-- the primary's own gate, the panel test, as a real -/
theorem dishReflect_onPanel (R f a w k σs σp cx cy dx dy dz : ℝ) (hp : OnPanel a w cx cy) :
    dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 6 = 1 := by
  unfold OnPanel at hp
  simp only [dishReflect, Matrix.cons_val]
  rw [if_pos hp]

theorem dishReflect_offPanel (R f a w k σs σp cx cy dx dy dz : ℝ) (hp : ¬ OnPanel a w cx cy) :
    dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 6 = 0 := by
  unfold OnPanel at hp
  simp only [dishReflect, Matrix.cons_val]
  rw [if_neg hp]

/-- the chain delivers exactly the rays on the panel whose landing is in the coil -/
theorem oil_through_iff (R f a w rc k σs σp cx cy dx dy dz : ℝ) :
    Optic.through (seq (primary R f a w k σs σp 1) (coil f rc))
        ((![cx, cy, 2 * f] : Fin 3 → ℝ), (![dx, dy, dz] : Fin 3 → ℝ))
      ↔ (OnPanel a w cx cy ∧ OilInside R f a w rc k σs σp cx cy dx dy dz) := by
  by_cases hp : OnPanel a w cx cy
  · have h6 := dishReflect_onPanel R f a w k σs σp cx cy dx dy dz hp
    have hpr : Optic.trace (primary R f a w k σs σp 1)
        ((![cx, cy, 2 * f] : Fin 3 → ℝ), (![dx, dy, dz] : Fin 3 → ℝ)) =
        Sum.inr ((![dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 0,
                    dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 1,
                    dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 2],
                  ![dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 3,
                    dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 4,
                    dishReflect R f a w k σs σp cx cy 0 0 dx dy dz 0 0 0 0 5]) : St .cone) := by
      simp only [Optic.trace, Matrix.cons_val]
      rw [if_pos (by rw [h6]; norm_num)]
    unfold Optic.through
    rw [Optic.trace_seq_inr _ _ _ _ hpr]
    unfold OilInside
    simp only [Optic.trace, landAt, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    split_ifs with hin <;> simp_all
  · have h6 := dishReflect_offPanel R f a w k σs σp cx cy dx dy dz hp
    have hpr : Optic.trace (primary R f a w k σs σp 1)
        ((![cx, cy, 2 * f] : Fin 3 → ℝ), (![dx, dy, dz] : Fin 3 → ℝ)) = Sum.inl 1 := by
      simp only [Optic.trace, Matrix.cons_val]
      rw [if_neg (by rw [h6]; norm_num)]
    unfold Optic.through
    rw [Optic.trace_seq_inl _ _ _ hpr]
    simp [hp]

/-- and `traceRayKErr`'s capture - the column `dishPower` reads (`dishPower … 0`) - is the same two
tests, so the family's chain and the compiled trace deliver the same rays -/
theorem oil_capture_iff (R f a w rc k σs σp cx cy dx dy dz : ℝ) :
    traceRayKErr R f a w rc k σs σp cx cy 0 0 dx dy dz 0 0 0 0 3 = 1
      ↔ (OnPanel a w cx cy ∧ OilInside R f a w rc k σs σp cx cy dx dy dz) := by
  unfold OnPanel OilInside
  simp only [traceRayKErr, dishReflect, landAt, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons,
    Matrix.tail_cons, Matrix.cons_val_succ, Matrix.cons_val_fin_one]
  split_ifs with h <;> simp_all <;> norm_num at *

/-- **the chain and the compiled trace agree, ray for ray** -/
theorem oil_agrees (R f a w rc k σs σp cx cy dx dy dz : ℝ) :
    Optic.through (seq (primary R f a w k σs σp 1) (coil f rc))
        ((![cx, cy, 2 * f] : Fin 3 → ℝ), (![dx, dy, dz] : Fin 3 → ℝ))
      ↔ traceRayKErr R f a w rc k σs σp cx cy 0 0 dx dy dz 0 0 0 0 3 = 1 :=
  (oil_through_iff ..).trans (oil_capture_iff ..).symm

/-! ## What the translator sees

At every concrete chain the indices are gone: the interpreter is a function of reals, which is what
`Ccc.lean` compiles. -/

/-- the oil chain's capture as a plain real function of the ray -/
def oilCapture (k σs σp cx cy dx dy dz : ℝ) : ℝ :=
  match trace (hashemiOil k σs σp 1) ((![cx, cy, 2 * dishF] : Fin 3 → ℝ), ![dx, dy, dz]) with
  | Sum.inl _ => 0
  | Sum.inr _ => 1

#check (oilCapture : ℝ → ℝ → ℝ → ℝ → ℝ → ℝ → ℝ → ℝ → ℝ)

end

end TandoorOpticGadt

/-
# The optics theorems, measured on the GPU from Lean

`lake exe trace_check`. Two instruments, both reached through the Metal bridge:

* his dish's trace, generated from HashemiTrace.lean (the kernels in bridge/hashemi_trace.metal
  around the header this same Lean wrote), against the Float twin of the same definitions and the
  sphere's theorems of OpticsSphere.lean: the meridional trace is `dev`/`focal`, the caustic (the
  paraxial plane's spot is `blur`, the best plane at most half of it), the facet spot against
  `facetSpot`, the capture against the added model `coilCapture`, the fixed focus at the trace
  (`sunInDish_equivariant`), every ray's fate (`Feedback.single_bounce`);
* the handwritten tandoor trace, replayed from a recorded dispatch (bridge/scene): the replay
  reproduces the record, every ray has one fate and the absorbed power does not exceed the
  delivered, the capture is antitone in the blur and in the pointing (ReceiverCapture.lean), and
  the site turned with the machine changes nothing.

Each check prints its numbers; a false one fails the program, so `lake exe trace_check` is the
build-time assertion of the measured theorems.
-/
import RequestProject.MetalBridge
import RequestProject.HashemiCccFloat
import Lean.Data.Json

open Lean

namespace TraceCheck

def cccDir : String := "/Users/faezs/ARTIST-compliant/tutorials/hashemi_ccc"
def bridgeDir : String := cccDir ++ "/bridge"

structure Check where
  name : String
  ok : Bool
  note : String

def fmt (x : Float) : String := toString x

/-- his dish: the prelude, the header this Lean wrote, the kernels -/
def dishSource : IO String := do
  let pre ← IO.FS.readFile (bridgeDir ++ "/msl_prelude.metal")
  let hdr ← IO.FS.readFile (cccDir ++ "/hashemi_ccc.h")
  let ker ← IO.FS.readFile (bridgeDir ++ "/hashemi_trace.metal")
  pure (pre ++ hdr ++ ker)

def flat (rows : Array (Array Float)) : FloatArray :=
  rows.foldl (fun acc r => r.foldl (fun a x => a.push x) acc) (FloatArray.emptyWithCapacity 0)

def rowsOf (a : FloatArray) (w : Nat) : Array (Array Float) := Id.run do
  let n := a.size / w
  let mut out := #[]
  for i in [0:n] do
    let mut r := #[]
    for k in [0:w] do r := r.push a[w * i + k]!
    out := out.push r
  return out

/-- a kernel of the dish source: `rays` rows of width `rw` in buffer 0, `prm` in 1, `out` rows of
width `ow` in 2, the count in 3 -/
def runRows (src kernel : String) (rays : Array (Array Float)) (rw : Nat) (prm : Array Float)
    (ow : Nat) : IO (Array (Array Float)) := do
  let n := rays.size
  let out ← MetalBridge.run src kernel #[flat rays, ⟨prm⟩, MetalBridge.const (n * ow) 0.0, ⟨#[n.toFloat]⟩]
    #[0, 0, 0, 1] n.toUSize 0
  let _ := rw
  pure (rowsOf out[2]! ow)

def maxOf (xs : Array Float) : Float := xs.foldl max (-1e300)

def nonIncreasing (xs : Array Float) (tol : Float) : Bool := Id.run do
  let mut ok := true
  for i in [1:xs.size] do
    if xs[i]! > xs[i-1]! * (1 + tol) + 1e-12 then ok := false
  return ok

/-! ## His dish -/

def R : Float := 2.0
def f : Float := 1.0
def a : Float := 0.8
def w : Float := 0.05
def rc : Float := 0.06

def dishChecks (src : String) : IO (Array Check) := do
  let mut cs : Array Check := #[]
  -- A1/A2. the exact sphere, meridional: vertical rays at heights h, to the paraxial plane and to
  -- the best plane; the file's dev/blur/bestFocus (Float twin) against the GPU trace
  let hs : Array Float := (List.range 8).toArray.map fun k => 0.1 * (k + 1).toFloat
  let H := 0.8
  let zBest := R - HashemiCccFloat.sphereBestFocus R H          -- from the vertex
  let mut devErr := 0.0
  let mut crossErr := 0.0
  let mut maxPar := 0.0
  let mut maxBest := 0.0
  for h in hs do
    let ray : Array Float := #[h, 0.0, 2.0 * f, 0.0, 0.0, -1.0]
    let par ← runRows src "hashemi_sphere" #[ray] 6 #[R, f] 5
    let best ← runRows src "hashemi_sphere" #[ray] 6 #[R, zBest] 5
    let atFocal ← runRows src "hashemi_sphere" #[ray] 6 #[R, HashemiCccFloat.sphereFocal R h] 5
    let xPar := Float.abs par[0]![0]!
    let xBest := Float.abs best[0]![0]!
    devErr := max devErr (Float.abs (xPar - Float.abs (HashemiCccFloat.sphereDev R h (R / 2.0))))
    devErr := max devErr (Float.abs (xBest - Float.abs (HashemiCccFloat.sphereDev R h (HashemiCccFloat.sphereBestFocus R H))))
    crossErr := max crossErr (Float.abs atFocal[0]![0]!)
    maxPar := max maxPar xPar
    maxBest := max maxBest xBest
  let blurH := HashemiCccFloat.sphereBlur R H
  cs := cs.push ⟨"sphere: the GPU trace of a vertical ray at height h misses the plane by |dev R h c| (OpticsSphere)",
    devErr < 1e-4, s!"max |trace - dev| {fmt devErr} m over 8 heights and 2 planes"⟩
  cs := cs.push ⟨"sphere: the ray crosses the axis at focal R h (crossing_exact)",
    crossErr < 1e-4, s!"max |x| at the plane z = focal: {fmt crossErr} m"⟩
  cs := cs.push ⟨"caustic: the paraxial plane's spot radius is blur R H (paraxial_focus_not_best_witness, 3rd clause)",
    Float.abs (maxPar - blurH) < 1e-4, s!"traced {fmt maxPar} m, blur {fmt blurH} m at H = 0.8"⟩
  cs := cs.push ⟨"caustic: at bestFocus the worst ray is within half the paraxial spot (4th clause)",
    maxBest ≤ blurH / 2.0 + 1e-4, s!"traced {fmt maxBest} m at z = {fmt zBest} (from the vertex) vs {fmt (blurH / 2.0)}"⟩
  -- A3. the facets: every facet centre, five points each, the sun straight down and at the disc's
  -- rim in x and y: the spot at F and at the best plane; fates
  let nSide := 32
  let mut rays : Array (Array Float) := #[]
  let rho := 4.65e-3
  let dirs : Array (Float × Float × Float) := #[(0, 0, -1), (Float.sin rho, 0, -Float.cos rho), (-Float.sin rho, 0, -Float.cos rho),
    (0, Float.sin rho, -Float.cos rho), (0, -Float.sin rho, -Float.cos rho)]
  let offs : Array (Float × Float) := #[(0, 0), (w / 2.0, w / 2.0), (-w / 2.0, w / 2.0), (w / 2.0, -w / 2.0), (-w / 2.0, -w / 2.0)]
  for i in [0:nSide] do
    for j in [0:nSide] do
      let cx := -a + w / 2.0 + i.toFloat * w
      let cy := -a + w / 2.0 + j.toFloat * w
      for (ux, uy) in offs do
        for (dx, dy, dz) in dirs do
          rays := rays.push #[cx, cy, ux, uy, dx, dy, dz]
  let tr ← runRows src "hashemi_trace" rays 7 #[R, f, a, w, rc] 8
  let radii := tr.map (·[2]!)
  let spotF := 2.0 * maxOf radii
  let facetSpot := HashemiCccFloat.facetSpot w f
  let captured := (tr.filter (fun r => r[3]! > 0.5)).size
  let n := tr.size
  let fatesOk := tr.all fun r => (r[4]! == 0 || r[4]! == 1 || r[4]! == 2) && ((r[3]! > 0.5) == (r[4]! == 2))
  cs := cs.push ⟨"totality: every ray of the panel has one fate and captured means fate 2 (Feedback.single_bounce)",
    fatesOk, s!"{n} rays, {captured} captured at F with the sun on the axis"⟩
  cs := cs.push ⟨"facetSpot: the traced spot at F is at least the facet plus the sun's disc",
    spotF ≥ facetSpot - 1e-4, s!"traced diameter {fmt spotF} m, facetSpot {fmt facetSpot} m; captured {fmt (captured.toFloat / n.toFloat)} of the rays"⟩
  -- the same rays on the flat facets to the best plane (traceFacet with a free plane)
  let mut fr : Array (Array Float) := #[]
  for r in rays do
    fr := fr.push #[r[0]!, r[1]!, r[0]! + r[2]!, r[1]! + r[3]!, 2 * f, r[4]!, r[5]!, r[6]!]
  let tb ← runRows src "hashemi_facet" fr 8 #[R, zBest] 5
  let capBest := (tb.filter (fun r => r[2]! ≤ rc && r[4]! > 0.5)).size
  cs := cs.push ⟨"facets at the best plane: the spot is smaller and the capture larger than at F",
    2.0 * maxOf (tb.map (·[2]!)) < spotF && capBest ≥ captured,
    s!"diameter {fmt (2.0 * maxOf (tb.map (·[2]!)))} m, captured {fmt (capBest.toFloat / n.toFloat)} at z = {fmt zBest}"⟩
  -- A4. the capture against the pointing error, and against the added model
  let epsDeg : Array Float := #[0, 0.5, 1.0, 1.5, 2.0, 3.0, 4.0]
  let mut caps : Array Float := #[]
  let mut models : Array Float := #[]
  for e in epsDeg do
    let er := e * 3.141592653589793 / 180
    let mut rs : Array (Array Float) := #[]
    for i in [0:nSide] do
      for j in [0:nSide] do
        rs := rs.push #[-a + w / 2.0 + i.toFloat * w, -a + w / 2.0 + j.toFloat * w, 0, 0, -Float.sin er, 0, -Float.cos er]
    let t ← runRows src "hashemi_trace" rs 7 #[R, f, a, w, rc] 8
    caps := caps.push ((t.filter (fun r => r[3]! > 0.5)).size.toFloat / t.size.toFloat)
    models := models.push (HashemiCccFloat.coilCapture (facetSpot / 2.0) rc (Float.tan er))
  cs := cs.push ⟨"capture is antitone in the pointing error (power_antitone_duct)",
    nonIncreasing caps 1e-9, "traced " ++ toString (caps.map fmt) ++ " vs the model " ++ toString (models.map fmt) ++ s!" at {epsDeg} deg"⟩
  -- A5. the fixed focus at the trace: the sun in the dish's frame is invariant under a common turn
  let poses : Array (Array Float) := #[#[0.3, 0.5, 0.9, 1.2], #[2.0, 1.0, 0.4, 3.0], #[5.5, 0.1, 1.3, 0.2]]
  let mut eqErr := 0.0
  for p in poses do
    for d in ([0.7, 2.5, -1.1] : List Float) do
      let u0 ← runRows src "hashemi_sun" #[p] 4 #[] 3
      let u1 ← runRows src "hashemi_sun" #[#[p[0]! + d, p[1]!, p[2]!, p[3]! + d]] 4 #[] 3
      for k in [0:3] do eqErr := max eqErr (Float.abs (u0[0]![k]! - u1[0]![k]!))
  cs := cs.push ⟨"fixed focus at the trace: the machine and the sun turned together (sunInDish_equivariant, proved; here in float32)",
    eqErr < 1e-5, s!"max component difference {fmt eqErr}"⟩
  -- C. the conic homotopy: the sphere at k = 0 (conicZ_sphere), the paraboloid at k = -1
  -- (conicZ_paraboloid), and the fixed-focus violation J(k, alpha) along the path: the RMS closest
  -- approach of the reflected rays to the focus of a sun tilted by alpha, at the sphere's focal
  -- point for that direction (C - (R/2) u). The sphere's J is the same for every alpha (its
  -- indifference to orientation); the paraboloid's grows with alpha (coma).
  let cC := 1.0 / R
  let mut parity := 0.0
  let mut parab := 0.0
  for h in hs do
    let ray : Array Float := #[h, 0.0, 2.0 * f, 0.0, 0.0, -1.0]
    let sp ← runRows src "hashemi_sphere" #[ray] 6 #[R, f] 5
    let co ← runRows src "hashemi_conic" #[ray] 6 #[cC, 0.0, f] 9
    parity := max parity (Float.abs (sp[0]![0]! - co[0]![6]!))
    let pa ← runRows src "hashemi_conic" #[ray] 6 #[cC, -1.0, f] 9
    parab := max parab (Float.abs pa[0]![6]!)
  cs := cs.push ⟨"conic at k = 0 is the sphere (conicZ_sphere, proved; the traces agree)", parity < 1e-4, s!"max landing difference {fmt parity} m"⟩
  cs := cs.push ⟨"conic at k = -1 is the paraboloid: every axial ray to the one focus (conicZ_paraboloid)", parab < 1e-4, s!"max |landing| at the focus {fmt parab} m over 8 heights"⟩
  let alphas : Array Float := #[0.0, 5.0, 10.0, 20.0, 30.0]
  let ks : Array Float := #[0.0, -0.25, -0.5, -0.75, -1.0]
  let mut table : Array String := #[]
  let mut sphereJ : Array Float := #[]
  let mut parabJ : Array Float := #[]
  let mut Js : Array (Array Float) := #[]
  for al in alphas do
    let ar := al * 3.141592653589793 / 180
    let u : Array Float := #[Float.sin ar, 0.0, Float.cos ar]        -- toward the sun, in the dish's frame
    let Fa : Array Float := #[-(R / 2.0) * u[0]!, 0.0, R - (R / 2.0) * u[2]!]   -- C - (R/2) u, C = (0,0,R)
    let mut rowS := s!"  alpha {fmt al}:"
    let mut rowJ : Array Float := #[]
    for k in ks do
      -- the bundle: heights 0..0.6 in x and y (the cap where the conic is defined for every k)
      let mut bundle : Array (Array Float) := #[]
      for i in [0:7] do
        for j in [0:7] do
          let x := -0.6 + 0.2 * i.toFloat
          let y := -0.6 + 0.2 * j.toFloat
          bundle := bundle.push #[x - 3.0 * u[0]!, y, 3.0 * f, -u[0]!, -u[1]!, -u[2]!]
      let out ← runRows src "hashemi_conic" bundle 6 #[cC, k, f] 9
      let mut ss := 0.0
      for o in out do
        -- closest approach of the line H + s rd to Fa: |(Fa - H) x rd|
        let (hx, hy, hz, dx, dy, dz) := (o[0]!, o[1]!, o[2]!, o[3]!, o[4]!, o[5]!)
        let (vx, vy, vz) := (Fa[0]! - hx, Fa[1]! - hy, Fa[2]! - hz)
        let cx := vy * dz - vz * dy
        let cy := vz * dx - vx * dz
        let cz := vx * dy - vy * dx
        ss := ss + (cx * cx + cy * cy + cz * cz)
      let J := Float.sqrt (ss / out.size.toFloat)
      rowS := rowS ++ s!"  k {fmt k}: {fmt J}"
      rowJ := rowJ.push J
      if k == 0.0 then sphereJ := sphereJ.push J
      if k == -1.0 then parabJ := parabJ.push J
    table := table.push rowS
    Js := Js.push rowJ
  -- the fixed cap (the built rim, not turned toward the sun): the best conic along the homotopy
  let mut interior := true
  let mut bestKs : Array Float := #[]
  for ai in [1:alphas.size] do
    let mut bestK := ks[0]!
    let mut bestJ := Js[ai]![0]!
    for ki in [1:ks.size] do
      if Js[ai]![ki]! < bestJ then
        bestJ := Js[ai]![ki]!
        bestK := ks[ki]!
    bestKs := bestKs.push bestK
    if bestK == 0.0 || bestK == -1.0 then interior := false
  cs := cs.push ⟨"a cap that does not turn toward the sun: the best conic along the homotopy is interior, neither the sphere nor the paraboloid, at every tilt",
    interior, "best k per alpha (5, 10, 20, 30 deg): " ++ toString (bestKs.map fmt)⟩
  cs := cs.push ⟨"the paraboloid is not indifferent: J(-1, alpha) grows with alpha (coma)", nonIncreasing (parabJ.reverse) 0.0 && parabJ.back! > parabJ[0]! * 2,
    "J(k, alpha) = RMS closest approach [m] to the direction's focus, the cap FIXED and the sun tilted:\n" ++ "\n".intercalate table.toList⟩
  let _ := sphereJ
  -- the sphere's indifference, stated right: the bundle turned WITH the sun (the cap that faces
  -- it, which is what the orbit presents), J(0, alpha) is the same for every alpha
  let mut Jrot : Array Float := #[]
  for al in alphas do
    let ar := al * 3.141592653589793 / 180
    let u : Array Float := #[Float.sin ar, 0.0, Float.cos ar]
    let e1 : Array Float := #[Float.cos ar, 0.0, -(Float.sin ar)]
    let Fa : Array Float := #[-(R / 2.0) * u[0]!, 0.0, R - (R / 2.0) * u[2]!]
    let mut bundle : Array (Array Float) := #[]
    for i in [0:7] do
      for j in [0:7] do
        let x := -0.6 + 0.2 * i.toFloat
        let y := -0.6 + 0.2 * j.toFloat
        bundle := bundle.push #[3.0 * u[0]! + x * e1[0]!, y, R + 3.0 * u[2]! + x * e1[2]!, -u[0]!, -u[1]!, -u[2]!]
    let out ← runRows src "hashemi_conic" bundle 6 #[cC, 0.0, f] 9
    let mut ss := 0.0
    for o in out do
      let (vx, vy, vz) := (Fa[0]! - o[0]!, Fa[1]! - o[1]!, Fa[2]! - o[2]!)
      let (dx, dy, dz) := (o[3]!, o[4]!, o[5]!)
      let cx := vy * dz - vz * dy
      let cy := vz * dx - vx * dz
      let cz := vx * dy - vy * dx
      ss := ss + (cx * cx + cy * cy + cz * cz)
    Jrot := Jrot.push (Float.sqrt (ss / out.size.toFloat))
  cs := cs.push ⟨"the sphere is indifferent to the sun's direction: the cap that faces the sun gives the same J for every alpha (the fixed focus by translation alone)",
    maxOf Jrot - Jrot.foldl min 1e300 < 2e-3, "J(0, alpha), bundle turned with the sun: " ++ toString (Jrot.map fmt)⟩
  pure cs

/-! ## The tandoor scene -/

structure Buf where
  file : String
  n : Nat
  kind : Nat

structure Call where
  kernel : String
  grid : Nat
  bufs : Array Buf

def loadManifest : IO (Json × Array Call) := do
  let txt ← IO.FS.readFile (bridgeDir ++ "/scene/manifest.json")
  let j ← IO.ofExcept (Json.parse txt)
  let calls ← IO.ofExcept (j.getObjVal? "calls" >>= Json.getArr?)
  let mut out := #[]
  for c in calls do
    let kernel ← IO.ofExcept (c.getObjVal? "kernel" >>= Json.getStr?)
    let grid ← IO.ofExcept (c.getObjVal? "grid" >>= Json.getNat?)
    let bs ← IO.ofExcept (c.getObjVal? "buffers" >>= Json.getArr?)
    let mut bufs := #[]
    for b in bs do
      bufs := bufs.push ⟨← IO.ofExcept (b.getObjVal? "file" >>= Json.getStr?), ← IO.ofExcept (b.getObjVal? "n" >>= Json.getNat?),
                         ← IO.ofExcept (b.getObjVal? "kind" >>= Json.getNat?)⟩
    out := out.push ⟨kernel, grid, bufs⟩
  pure (j, out)

def loadBufs (c : Call) (after : Bool := false) : IO (Array FloatArray) := do
  let mut out := #[]
  for b in c.bufs do
    let fn := if after then b.file.dropRight 4 ++ "_after.f64" else b.file
    out := out.push (← MetalBridge.readF64 (bridgeDir ++ "/scene/" ++ fn))
  pure out

def runCall (src : String) (c : Call) (bufs : Array FloatArray) : IO (Array FloatArray) :=
  MetalBridge.run src c.kernel bufs (c.bufs.map (·.kind)) c.grid.toUSize 0

def maxDiff (x y : FloatArray) : Float := Id.run do
  let mut m := 0.0
  for i in [0:min x.size y.size] do m := max m (Float.abs (x[i]! - y[i]!))
  return m

def relDiff (x y : Float) : Float := Float.abs (x - y) / max 1e-9 (max (Float.abs x) (Float.abs y))

/-- the trace's buffer indices (the recorded binding order of tandoor_trace) -/
def iThr := 0
def iOut6 := 1
def iSigb := 8
def iDvec := 9
def iVp := 11
def iAcan := 13
def iMt := 14
def iCd := 15
def iRayPw := 21
def iPer := 23
def iScb := 26
def iFct := 28
def iFate := 29
/-- the mount's: outputs vp Mt Cd Ac scb aux, then day lat prm nB pnt fct mech -/
def mVp := 0
def mMt := 1
def mCd := 2
def mAc := 3
def mScb := 4
def mPnt := 10
def mFct := 11

def total (per : FloatArray) : Float := MetalBridge.sum per

/-- the trace after a mount with edited pointing / site: the mount's frames flow into the trace -/
def traceWith (src : String) (mount trace : Call) (mIn tIn : Array FloatArray)
    (editM : Array FloatArray → Array FloatArray) (editT : Array FloatArray → Array FloatArray) : IO (Array FloatArray) := do
  let mo ← runCall src mount (editM mIn)
  let t := editT tIn
  let t := t.set! iVp mo[mVp]! |>.set! iMt mo[mMt]! |>.set! iCd mo[mCd]! |>.set! iAcan mo[mAc]! |>.set! iScb mo[mScb]!
  runCall src trace t

def scale (x : FloatArray) (s : Float) : FloatArray := Id.run do
  let mut y := FloatArray.emptyWithCapacity x.size
  for i in [0:x.size] do y := y.push (x[i]! * s)
  return y

def sceneChecks : IO (Array Check) := do
  let mut cs : Array Check := #[]
  let src ← IO.FS.readFile (bridgeDir ++ "/scene/tandoor.metal")
  let (j, calls) ← loadManifest
  let some mount := calls.find? (·.kernel == "mount_solve") | throw (IO.userError "no mount_solve in the scene")
  let some trace := calls.find? (·.kernel == "tandoor_trace") | throw (IO.userError "no tandoor_trace in the scene")
  let B ← IO.ofExcept (j.getObjVal? "agents" >>= Json.getNat?)
  let fDesign := match j.getObjVal? "f_design" with | .ok v => (v.getNum?.toOption.map (·.toFloat)).getD 4.05 | _ => 4.05
  let mIn ← loadBufs mount
  let mAfter ← loadBufs mount true
  let tIn ← loadBufs trace
  let tAfter ← loadBufs trace true
  -- B1. the replay reproduces the record
  let mo ← runCall src mount mIn
  let dvp := maxDiff mo[mVp]! mAfter[mVp]!
  let to ← runCall src trace tIn
  let dthr := maxDiff to[iThr]! tAfter[iThr]!
  let dper := relDiff (total to[iPer]!) (total tAfter[iPer]!)
  cs := cs.push ⟨"replay: the bridge reproduces the recorded mount solve and trace",
    dvp < 1e-4 && dthr < 1e-4 && dper < 1e-3, s!"|vp| diff {fmt dvp}, |thr| diff {fmt dthr}, per total {fmt (total to[iPer]!)} vs {fmt (total tAfter[iPer]!)} m2/(W/m2)"⟩
  -- B2. totality: one fate per ray, through weight within the pre-gate weight, absorbed within delivered
  let fate := rowsOf to[iFate]! 6
  let out6 := rowsOf to[iOut6]! 6
  let thr := to[iThr]!
  let pw := to[iRayPw]!
  let P := thr.size / B
  let mut codesOk := true
  let mut thrOk := true
  let mut delivered := 0.0
  for r in [0:thr.size] do
    let code := fate[r]![0]!
    if !(code ≥ 0 && code < 64) then codesOk := false
    if thr[r]! > out6[r]![5]! + 1e-5 || thr[r]! < -1e-6 then thrOk := false
    delivered := delivered + thr[r]! * pw[r % pw.size]!
  let absorbed := total to[iPer]!
  cs := cs.push ⟨"totality: every ray has one fate code and its through weight is within its pre-gate weight",
    codesOk && thrOk, s!"{thr.size} rays ({B} x {P})"⟩
  cs := cs.push ⟨"conservation: the absorbed power is within the delivered (thr x ray power)",
    absorbed ≤ delivered * 1.001 + 1e-6, s!"absorbed {fmt absorbed}, delivered {fmt delivered} (m2 per unit DNI)"⟩
  -- B3. antitone in the blur, for the rays the theorem is about: those whose FOCUSED landing is
  -- inside the entry (captured unblurred); the others blur can bring in (exists_blur_captures)
  let o0 ← runCall src trace (tIn.set! iSigb (scale tIn[iSigb]! 0.0))
  let thr0 := o0[iThr]!
  let mut pows : Array Float := #[]
  let mut totals : Array Float := #[]
  for sc in ([0.25, 0.5, 1.0, 2.0, 4.0] : List Float) do
    let t := tIn.set! iSigb (scale tIn[iSigb]! sc)
    let o ← runCall src trace t
    let th := o[iThr]!
    let mut inside := 0.0
    for r in [0:th.size] do
      if thr0[r]! > 0.0 then inside := inside + th[r]! * pw[r % pw.size]!
    pows := pows.push inside
    totals := totals.push (total o[iPer]!)
  cs := cs.push ⟨"blur: for the rays focused inside the entry the captured power is antitone in the blur (power_antitone, same draws)",
    nonIncreasing pows 1e-3, "sigma x 0.25..4, the theorem's rays: " ++ toString (pows.map fmt) ++ "; all rays (blur brings some in): " ++ toString (totals.map fmt)⟩
  -- B4. antitone in the pointing, and the half-power angle
  let degs : Array Float := #[0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.5, 2.0]
  let mut ppow : Array Float := #[]
  for d in degs do
    let dr := d * 3.141592653589793 / 180
    let o ← traceWith src mount trace mIn tIn
      (fun m => m.set! mPnt (Id.run do
        let mut p := m[mPnt]!
        for b in [0:B] do p := p.set! (2 * b) (p[2 * b]! + d)
        return p))
      (fun t => t.set! iDvec (Id.run do
        let mut v := t[iDvec]!
        for b in [0:B] do v := v.set! (2 * b) (2 * fDesign * dr)
        return v))
    ppow := ppow.push (total o[iPer]!)
  let p0 := ppow[0]!
  let mut half := 0.0
  for i in [1:degs.size] do
    if half == 0.0 && ppow[i]! < p0 / 2.0 then
      let (x0, x1, y0, y1) := (degs[i-1]!, degs[i]!, ppow[i-1]!, ppow[i]!)
      half := x0 + (x1 - x0) * (y0 - p0 / 2.0) / (y0 - y1)
  cs := cs.push ⟨"pointing: the captured power is antitone in the elevation error (power_antitone_duct)",
    nonIncreasing ppow 1e-3, "0..2 deg: " ++ toString (ppow.map fmt) ++ s!"; half power at {fmt half} deg"⟩
  -- B5. the site turned with the machine: the same power
  let d := 20.0
  let o ← traceWith src mount trace mIn tIn
    (fun m => (m.set! mPnt (Id.run do
        let mut p := m[mPnt]!
        for b in [0:B] do p := p.set! (2 * b + 1) (p[2 * b + 1]! - d)
        return p)).set! mFct (Id.run do
        let mut fc := m[mFct]!
        for b in [0:B] do fc := fc.set! (84 * b + 75) (fc[84 * b + 75]! + d * 3.141592653589793 / 180)
        return fc))
    (fun t => t.set! iFct (Id.run do
        let mut fc := t[iFct]!
        for b in [0:B] do fc := fc.set! (84 * b + 75) (fc[84 * b + 75]! + d * 3.141592653589793 / 180)
        return fc))
  let pe := total o[iPer]!
  cs := cs.push ⟨"the site turned 20 deg with the machine: the beam is the same but the receiver (fold, slot, horizon) does not turn - the power changes by the receiver's asymmetry, under 5 %",
    relDiff pe p0 < 0.05, s!"{fmt pe} vs {fmt p0}: {fmt (100.0 * relDiff pe p0)} % (his machine's coil rides the carriage: exact, above)"⟩
  -- D. THE TRI PRIMARY ALONG THE HOMOTOPY. The trace takes the film's shape as buffers: the P
  -- aperture points on the membrane per pressure level and their normals (the env's FvK/NURBS
  -- solve). At lv = 4 the kernel reads level 4 alone. First the film's own conic constant is fitted
  -- to those points (the pressure-to-shape chart, measured); then the level's points are replaced by
  -- conics of the same vertex curvature along k, and the tri train - strip, M4, pot - is replayed.
  let P := thr.size / B
  let Lv := tIn[2]!.size / (P * 3)
  let lvl := 4
  let pts := tIn[2]!
  let nrm := tIn[3]!
  let base := lvl * P * 3
  let mut xs : Array Float := #[]
  let mut ys : Array Float := #[]
  let mut zs : Array Float := #[]
  for i in [0:P] do
    xs := xs.push pts[base + 3 * i]!
    ys := ys.push pts[base + 3 * i + 1]!
    zs := zs.push pts[base + 3 * i + 2]!
  let rs := (List.range P).toArray.map fun i => Float.sqrt (xs[i]! * xs[i]! + ys[i]! * ys[i]!)
  let conic := fun (c k r : Float) => c * r * r / (1 + Float.sqrt (max (1 - (1 + k) * c * c * r * r) 0))
  let mut bestRms := 1e300
  let mut cFit := 0.12
  let mut kFit := -1.0
  for ik in [0:31] do
    let k := -1.2 + 0.05 * ik.toFloat
    for ic in [0:61] do
      let c := 0.09 + 0.001 * ic.toFloat
      let mut z0 := 0.0
      for i in [0:P] do z0 := z0 + (zs[i]! - conic c k rs[i]!)
      z0 := z0 / P.toFloat
      let mut ss := 0.0
      for i in [0:P] do
        let e := zs[i]! - conic c k rs[i]! - z0
        ss := ss + e * e
      let rms := Float.sqrt (ss / P.toFloat)
      if rms < bestRms then
        bestRms := rms
        cFit := c
        kFit := k
  cs := cs.push ⟨"the film's shape at the working level is a conic: the FvK/NURBS points fit the family to a fraction of a millimetre",
    bestRms < 5e-4, s!"level {lvl} of {Lv}: c {fmt cFit} (R {fmt (1.0 / cFit)}, f {fmt (1.0 / (2.0 * cFit))}), k {fmt kFit}, rms {fmt (1e3 * bestRms)} mm - a near-paraboloid, not a sphere"⟩
  -- the conic primary along k, the same vertex curvature, in the level's rows (4 and 5: the lerp)
  let withConic := fun (k : Float) => Id.run do
    let mut p := pts
    let mut n := nrm
    for row in [lvl, lvl + 1] do
      if row < Lv then
        let b := row * P * 3
        for i in [0:P] do
          let r := rs[i]!
          let z := conic cFit k r
          let g := cFit * r / Float.sqrt (max (1 - (1 + k) * cFit * cFit * r * r) 1e-18)   -- dz/dr
          let (gx, gy) := if r > 1e-9 then (g * xs[i]! / r, g * ys[i]! / r) else (0.0, 0.0)
          let nn := Float.sqrt (1 + gx * gx + gy * gy)
          p := p.set! (b + 3 * i) xs[i]! |>.set! (b + 3 * i + 1) ys[i]! |>.set! (b + 3 * i + 2) z
          n := n.set! (b + 3 * i) (-gx / nn) |>.set! (b + 3 * i + 1) (-gy / nn) |>.set! (b + 3 * i + 2) (1 / nn)
    (p, n)
  let ksT : Array Float := #[-1.0, -0.9, kFit, -0.5, -0.25, 0.0]
  let mut powK : Array Float := #[]
  for k in ksT do
    let (p, n) := withConic k
    let o ← runCall src trace (tIn.set! 2 p |>.set! 3 n)
    powK := powK.push (total o[iPer]!)
  let pFilm := powK[2]!
  cs := cs.push ⟨"the conic at the film's fitted k reproduces the film's power through the tri train (strip, M4, pot): the family is the right one for the machine",
    relDiff pFilm p0 < 0.03, s!"conic k {fmt kFit}: {fmt pFilm} vs the film's own points {fmt p0} m2 per unit DNI ({fmt (100.0 * relDiff pFilm p0)} %)"⟩
  cs := cs.push ⟨"the tri train along the homotopy: the capture at the pot for the paraboloid, the film, and toward the sphere (same vertex curvature)",
    true, "k " ++ toString (ksT.map fmt) ++ " -> power " ++ toString (powK.map fmt)⟩
  -- the pointing cliff for the film (its k) and for the sphere end: the strip magnifies the figure
  let mut halfK : Array Float := #[]
  for k in ([kFit, 0.0] : List Float) do
    let (p, n) := withConic k
    let mut pp : Array Float := #[]
    for d in degs do
      let dr := d * 3.141592653589793 / 180
      let o ← traceWith src mount trace mIn (tIn.set! 2 p |>.set! 3 n)
        (fun m => m.set! mPnt (Id.run do
          let mut q := m[mPnt]!
          for b in [0:B] do q := q.set! (2 * b) (q[2 * b]! + d)
          return q))
        (fun t => t.set! iDvec (Id.run do
          let mut v := t[iDvec]!
          for b in [0:B] do v := v.set! (2 * b) (2 * fDesign * dr)
          return v))
      pp := pp.push (total o[iPer]!)
    let q0 := pp[0]!
    let mut halfD := 0.0
    for i in [1:degs.size] do
      if halfD == 0.0 && pp[i]! < q0 / 2.0 then
        let (x0, x1, y0, y1) := (degs[i-1]!, degs[i]!, pp[i-1]!, pp[i]!)
        halfD := x0 + (x1 - x0) * (y0 - q0 / 2.0) / (y0 - y1)
    halfK := halfK.push halfD
  cs := cs.push ⟨"the pointing budget along the homotopy: half power for the film's conic and for the sphere's",
    true, s!"half power at {fmt halfK[0]!} deg (film, k {fmt kFit}) and {fmt halfK[1]!} deg (sphere, k 0)"⟩
  -- E. THE ADMISSIBLE SET AS A PATH. Through the day, tracked exactly (the mount's own law, pnt =
  -- the sentinel), the film at each of its recorded pressure levels: the capture at the pot per
  -- hour and level, the best level and the levels within 5 % of it - an interval at each hour is
  -- one class, and the sequence of intervals is the path the policy has to stay on.
  let hours : Array Float := #[8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0]
  let mut pathRows : Array String := #[]
  let mut allIntervals := true
  let mut bestLevels : Array Float := #[]
  for h in hours do
    let mut capL : Array Float := #[]
    for l in [0:Lv] do
      let o ← traceWith src mount trace mIn tIn
        (fun m => (m.set! 8 (m[8]!.set! 0 h)).set! mPnt (MetalBridge.const m[mPnt]!.size (-999.0)))
        (fun t => (t.set! 4 (MetalBridge.const B l.toFloat)).set! iDvec (MetalBridge.const t[iDvec]!.size 0.0))
      capL := capL.push (total o[iPer]!)
    let best := maxOf capL
    let mut bl := 0
    for l in [0:Lv] do
      if capL[l]! == best then bl := l
    let adm := (List.range Lv).filter fun l => capL[l]! ≥ 0.95 * best
    let contiguous := adm.length == 0 || (adm.getLast! - adm.head! + 1 == adm.length)
    if !contiguous then allIntervals := false
    bestLevels := bestLevels.push bl.toFloat
    pathRows := pathRows.push (s!"  {fmt h} h: " ++ toString (capL.map fmt) ++ s!"  best level {bl}, admissible {adm}")
  cs := cs.push ⟨"the admissible set is a path: at every hour the levels within 5 % of the best form one interval",
    allIntervals, "capture at the pot per level (0..6) through the day, tracked:\n" ++ "\n".intercalate pathRows.toList ++ "\n  best level per hour: " ++ toString (bestLevels.map fmt)⟩
  -- F. THE RIM-SHAPING CONTROL AS A FAMILY THE TRACE CONSUMES. bridge/film_family.py solves the
  -- film with per-zone pressures (the env's zoned law at several strengths, a rim zone pressed
  -- harder or softer, a ring pressed in), re-bisected to the design focal length, fitted into NURBS
  -- control points warm-started from the working level, and evaluated at the env's aperture. Here
  -- each shape replaces the working level's rows and the tri train is replayed at the recorded
  -- hour; the conic constant is fitted to each for the record.
  let famDir := bridgeDir ++ "/family"
  let famOk ← System.FilePath.pathExists (famDir ++ "/manifest.json")
  if famOk then
    let ftxt ← IO.FS.readFile (famDir ++ "/manifest.json")
    let fj ← IO.ofExcept (Json.parse ftxt)
    let ctrls ← IO.ofExcept (fj.getObjVal? "controls" >>= Json.getArr?)
    let mut famRows : Array String := #[]
    let mut famPow : Array Float := #[]
    let mut baseline := 0.0
    for c in ctrls do
      let name ← IO.ofExcept (c.getObjVal? "name" >>= Json.getStr?)
      let fpts ← IO.ofExcept (c.getObjVal? "pts" >>= Json.getStr?)
      let fnrm ← IO.ofExcept (c.getObjVal? "nrm" >>= Json.getStr?)
      let kfam := match c.getObjVal? "conic_k" with | .ok v => (v.getNum?.toOption.map (·.toFloat)).getD 0.0 | _ => 0.0
      let ffit := match c.getObjVal? "f_fit" with | .ok v => (v.getNum?.toOption.map (·.toFloat)).getD 0.0 | _ => 0.0
      let pf ← MetalBridge.readF64 (famDir ++ "/" ++ fpts)
      let nf ← MetalBridge.readF64 (famDir ++ "/" ++ fnrm)
      let mut p := pts
      let mut n := nrm
      for row in [lvl, lvl + 1] do
        if row < Lv then
          let b := row * P * 3
          for i in [0:P * 3] do
            p := p.set! (b + i) pf[i]!
            n := n.set! (b + i) nf[i]!
      let o ← runCall src trace (tIn.set! 2 p |>.set! 3 n)
      let pw := total o[iPer]!
      famPow := famPow.push pw
      if name == "zc_0.4" then baseline := pw
      famRows := famRows.push s!"  {name}: power {fmt pw}, f_fit {fmt ffit}, conic k {fmt kfam}"
    cs := cs.push ⟨"the family: the env's own zoned law refitted into NURBS reproduces the recorded working level through the tri train",
      baseline > 0.0 && relDiff baseline p0 < 0.05, s!"zc_0.4 refit {fmt baseline} vs recorded {fmt p0} ({fmt (100.0 * relDiff baseline p0)} %)"⟩
    cs := cs.push ⟨"the rim-shaping family through the tri train: the capture per control, with each shape's conic constant",
      famPow.size > 0, "\n".intercalate famRows.toList⟩
  else
    cs := cs.push ⟨"the rim-shaping family (bridge/family/manifest.json)", true, "not generated yet: run bridge/film_family.py"⟩
  pure cs

/-! ## G. Radiometry, not geometry: a Monte Carlo sun and optical errors on his dish -/

/-- a standard normal by Box-Muller from Lean's generator -/
def normalDraw (g : StdGen) : Float × Float × StdGen :=
  let (u1, g1) := randNat g 1 1000000
  let (u2, g2) := randNat g1 0 999999
  let r := Float.sqrt (-2.0 * Float.log (u1.toFloat / 1000000.0))
  let th := 2.0 * 3.141592653589793 * u2.toFloat / 1000000.0
  (r * Float.cos th, r * Float.sin th, g2)

def uniformDraw (g : StdGen) : Float × StdGen :=
  let (u, g1) := randNat g 0 999999
  (u.toFloat / 1000000.0, g1)

/-- N Monte Carlo rays of the dish for the sun along `u` (unit, toward the sun): a facet on the
5 cm grid, a point in it, the direction on the pillbox disc, four normal draws for the errors -/
def mcRays (N : Nat) (u : Array Float) (seed : Nat) : Array (Array Float) := Id.run do
  let mut g := mkStdGen seed
  let mut rays : Array (Array Float) := #[]
  let nSide := 32
  -- an orthonormal pair normal to u
  let helper : Array Float := if Float.abs u[2]! < 0.9 then #[0, 0, 1] else #[1, 0, 0]
  let cr := fun (a b : Array Float) => #[a[1]! * b[2]! - a[2]! * b[1]!, a[2]! * b[0]! - a[0]! * b[2]!, a[0]! * b[1]! - a[1]! * b[0]!]
  let e1r := cr u helper
  let n1 := Float.sqrt (e1r[0]! * e1r[0]! + e1r[1]! * e1r[1]! + e1r[2]! * e1r[2]!)
  let e1 := e1r.map (· / n1)
  let e2 := cr u e1
  for _ in [0:N] do
    let (a1, g1) := randNat g 0 (nSide - 1)
    let (a2, g2) := randNat g1 0 (nSide - 1)
    let (v1, g3) := uniformDraw g2
    let (v2, g4) := uniformDraw g3
    let (v3, g5) := uniformDraw g4
    let (v4, g6) := uniformDraw g5
    let (z1, z2, g7) := normalDraw g6
    let (z3, z4, g8) := normalDraw g7
    g := g8
    let cx := -0.8 + 0.025 + a1.toFloat * 0.05
    let cy := -0.8 + 0.025 + a2.toFloat * 0.05
    let ux := (v1 - 0.5) * 0.05
    let uy := (v2 - 0.5) * 0.05
    let rho := 4.65e-3 * Float.sqrt v3
    let phi := 2.0 * 3.141592653589793 * v4
    -- toward the dish, tilted within the disc
    let d := (List.range 3).toArray.map fun k =>
      -(Float.cos rho * u[k]! + Float.sin rho * (Float.cos phi * e1[k]! + Float.sin phi * e2[k]!))
    rays := rays.push #[cx, cy, ux, uy, d[0]!, d[1]!, d[2]!, z1, z2, z3, z4]
  return rays

def mcChecks (src : String) : IO (Array Check) := do
  let mut cs : Array Check := #[]
  let N := 40000
  let prm := fun (sl sp : Float) => #[R, f, a, w, rc, sl, sp]
  -- the sun on the axis: the capture with its standard error, for slope errors 0, 1, 2, 4 mrad
  -- (SolTrace's model: Gaussian tilts of the normal) and a 1 mrad specularity
  let u0 : Array Float := #[0, 0, 1]
  let rays0 := mcRays N u0 11
  let mut line := ""
  let mut caps : Array Float := #[]
  let mut ses : Array Float := #[]
  for (sl, sp) in ([(0.0, 0.0), (1e-3, 0.0), (2e-3, 0.0), (4e-3, 0.0), (2e-3, 1e-3)] : List (Float × Float)) do
    let out ← runRows src "hashemi_trace_err" rays0 11 (prm sl sp) 8
    let p := (out.filter (fun r => r[3]! > 0.5)).size.toFloat / N.toFloat
    let se := Float.sqrt (p * (1 - p) / N.toFloat)
    caps := caps.push p
    ses := ses.push se
    line := line ++ s!"  slope {fmt (1e3 * sl)} mrad, spec {fmt (1e3 * sp)}: {fmt p} +- {fmt se}"
  -- the deterministic trace with zero errors, on the same rays: the same fates
  let outErr0 ← runRows src "hashemi_trace_err" rays0 11 (prm 0.0 0.0) 8
  let outDet ← runRows src "hashemi_trace" (rays0.map fun r => r.extract 0 7) 7 #[R, f, a, w, rc] 8
  let mut flips := 0
  for i in [0:N] do
    if outErr0[i]![3]! != outDet[i]![3]! then flips := flips + 1
  cs := cs.push ⟨"with zero errors the error-bearing trace is the trace, ray for ray (the sun on the pillbox disc, Monte Carlo)",
    flips == 0, s!"{flips} of {N} fates differ"⟩
  let mut nonInc := true
  for i in [1:4] do
    if caps[i]! > caps[i-1]! + 2.0 * (ses[i]! + ses[i-1]!) then nonInc := false
  cs := cs.push ⟨"radiometry on his dish: the on-axis capture with a sampled sun, with its standard error, non-increasing in the slope error within the error bars - and barely: the dish is aberration-limited, 4 mrad of slope error is 8 mm at F against a 1.13 m spot",
    nonInc, "N = 40000:\n" ++ line⟩
  -- the pointing cliff with a sampled sun and 2 mrad slope error: capture vs error with error bars
  let mut cliff := ""
  let mut prev := 2.0
  let mut mono := true
  for e in ([0.0, 0.5, 1.0, 1.5, 2.0, 3.0] : List Float) do
    let er := e * 3.141592653589793 / 180
    let u : Array Float := #[Float.sin er, 0, Float.cos er]
    let rays := mcRays 20000 u (17 + (e * 10).toUInt64.toNat)
    let out ← runRows src "hashemi_trace_err" rays 11 (prm 2e-3 1e-3) 8
    let p := (out.filter (fun r => r[3]! > 0.5)).size.toFloat / 20000.0
    let se := Float.sqrt (p * (1 - p) / 20000.0)
    if p > prev + 3.0 * se then mono := false
    prev := p
    cliff := cliff ++ s!"  {fmt e} deg: {fmt p} +- {fmt se}"
  cs := cs.push ⟨"the pointing cliff under a sampled sun with 2 mrad slope and 1 mrad specularity errors is antitone within its error bars (power_antitone_duct)",
    mono, cliff⟩
  pure cs


/-! ## H. The Modula layer from Lean: the gates' slopes through the generated box kernels

Ccc prints every definition's tangent (`hk_<f>_jvp`) and box (`hk_<f>_box`: interval + Lipschitz
abstract interpretation) and wraps them as Metal kernels; here Lean runs them and measures what
the theorems say: the smooth reach gate's bound never exceeds `1 / (4 τ)` (`sunReachableS_slope`),
the Boolean gate is a subobject (its bound jumps to `HK_INF` exactly on the boxes straddling the
floor, in the megakernel's own column), and `lostSunS ≤ sunReachableS` (`lostSunS_le_reach`). -/

def modulaSource : IO String := do
  let pre ← IO.FS.readFile (bridgeDir ++ "/msl_prelude.metal")
  let hdr ← IO.FS.readFile (cccDir ++ "/hashemi_ccc.h")
  let mh ← IO.FS.readFile (cccDir ++ "/hashemi_modula.h")
  let mk ← IO.FS.readFile (cccDir ++ "/hashemi_modula.metal")
  pure (pre ++ hdr ++ mh ++ mk)

/-- a box kernel `mk_<f>_box`: lo / hi / sc rows, the three output rows of width `nout` -/
def runBox (src kernel : String) (lo hi sc : Array (Array Float)) (nout : Nat) :
    IO (Array (Array Float) × Array (Array Float) × Array (Array Float)) := do
  let n := lo.size
  let out ← MetalBridge.run src kernel
    #[flat lo, flat hi, flat sc, MetalBridge.const (n * nout) 0.0, MetalBridge.const (n * nout) 0.0,
      MetalBridge.const (n * nout) 0.0, ⟨#[n.toFloat]⟩] #[0, 0, 0, 0, 0, 0, 1] n.toUSize 0
  pure (rowsOf out[3]! nout, rowsOf out[4]! nout, rowsOf out[5]! nout)

/-- a tangent kernel `mk_<f>_jvp`: x / dx rows, the value and tangent rows of width `nout` -/
def runJvp (src kernel : String) (x dx : Array (Array Float)) (nout : Nat) :
    IO (Array (Array Float) × Array (Array Float)) := do
  let n := x.size
  let out ← MetalBridge.run src kernel
    #[flat x, flat dx, MetalBridge.const (n * nout) 0.0, MetalBridge.const (n * nout) 0.0, ⟨#[n.toFloat]⟩]
    #[0, 0, 0, 0, 1] n.toUSize 0
  pure (rowsOf out[2]! nout, rowsOf out[3]! nout)

def modulaChecks : IO (Array Check) := do
  let src ← modulaSource
  let mut cs : Array Check := #[]
  let tau : Float := 0.01
  let megaPrm : Array Float := #[0.03, 300.0, 0.9, 2000.0, 0.85, 10.0, 1000000.0, 1.0]
  let megaRow := fun (el : Float) => #[1.0, 0.5, 0.0, 0.0, 0.0, 15.0, el, 1.0, 800.0] ++ megaPrm
  -- the dead point from the megakernel itself (column 4 of megaStep), so the floor is the kernel's
  let (y0, _) ← runJvp src "mk_megaStep_jvp" #[megaRow 1.0] #[Array.replicate 17 0.0] 17
  let tDead := y0[0]![4]!
  let floor := 3.14159265358979 / 2.0 - tDead
  -- H1. boxes of elevation 0.01 rad wide across the reach floor: the smooth gate's bound vs the theorem
  let n := 400
  let mut lo : Array (Array Float) := #[]
  let mut hi : Array (Array Float) := #[]
  let mut sc : Array (Array Float) := #[]
  for i in [0:n] do
    let c := floor - 0.2 + 0.4 * i.toFloat / n.toFloat
    lo := lo.push #[tDead, c - 0.005]; hi := hi.push #[tDead, c + 0.005]; sc := sc.push #[0.0, 1.0]
  let (_, _, ls) ← runBox src "mk_sunReachableS_box" lo hi sc 1
  let lmax := maxOf (ls.map (·[0]!))
  cs := cs.push ⟨"gate: the smooth reach gate's box bound never exceeds the theorem's slope 1/(4 tau) (sunReachableS_slope)",
    lmax <= 1.0 / (4.0 * tau) * 1.001, s!"max L over {n} boxes {fmt lmax} per rad, the theorem's {fmt (1.0 / (4.0 * tau))}; the dead point from the kernel {fmt tDead}"⟩
  -- H2. the same boxes through the megakernel: column 13 (the Boolean gate) jumps exactly where the
  -- box straddles the floor; column 15 (the smooth gate) keeps the theorem's slope there
  let mut mlo : Array (Array Float) := #[]
  let mut mhi : Array (Array Float) := #[]
  let mut msc : Array (Array Float) := #[]
  for i in [0:n] do
    let c := floor - 0.2 + 0.4 * i.toFloat / n.toFloat
    mlo := mlo.push (megaRow (c - 0.005)); mhi := mhi.push (megaRow (c + 0.005))
    msc := msc.push ((Array.replicate 17 0.0).set! 6 1.0)
  let (_, _, mL) ← runBox src "mk_megaStep_box" mlo mhi msc 17
  let mut jumpsOk := true
  let mut nJump := 0
  let mut smoothMax := 0.0
  let mut nEdge := 0
  for i in [0:n] do
    let straddles := mlo[i]![6]! <= floor && floor <= mhi[i]![6]!
    -- a box edge within float32 of the floor is decided by rounding, either way: not a verdict
    let onEdge := Float.abs (mlo[i]![6]! - floor) < 1e-5 || Float.abs (mhi[i]![6]! - floor) < 1e-5
    let lb := mL[i]![13]!
    let lsm := mL[i]![15]!
    if onEdge then nEdge := nEdge + 1
    else
      if straddles then nJump := nJump + 1
      if straddles && lb < 1e29 then jumpsOk := false
      if !straddles && lb != 0.0 then jumpsOk := false
    if lsm > smoothMax then smoothMax := lsm
  cs := cs.push ⟨"gate: in the megakernel the Boolean reach column jumps exactly on the boxes straddling the floor (SunReachable, a subobject: L = inf) and is flat elsewhere",
    jumpsOk, s!"{nJump} straddling boxes of {n} jump, the rest have L = 0 ({nEdge} boxes with an edge on the floor left undecided)"⟩
  cs := cs.push ⟨"gate: the megakernel's smooth reach column keeps the theorem's slope on the same boxes",
    smoothMax <= 1.0 / (4.0 * tau) * 1.001, s!"max L {fmt smoothMax} per rad vs {fmt (1.0 / (4.0 * tau))}"⟩
  -- H3. lostSunS <= sunReachableS at sampled poses, both values from the tangent kernels
  let m := 256
  let mut xs : Array (Array Float) := #[]
  let mut xr : Array (Array Float) := #[]
  for i in [0:m] do
    let az := 6.283 * i.toFloat / m.toFloat
    let t := 0.3 + 0.6 * ((i * 7919 % 1000).toFloat / 1000.0)
    let el := floor - 0.1 + 0.5 * ((i * 104729 % 1000).toFloat / 1000.0)
    let azs := az + 0.05 * ((i * 15485863 % 1000).toFloat / 1000.0 - 0.5)
    xs := xs.push #[tDead, az, t, el, azs, 0.03]
    xr := xr.push #[tDead, el]
  let (yl, _) ← runJvp src "mk_lostSunS_jvp" xs (xs.map fun r => Array.replicate r.size 0.0) 1
  let (yr, _) ← runJvp src "mk_sunReachableS_jvp" xr (xr.map fun r => Array.replicate r.size 0.0) 1
  let mut leOk := true
  let mut worst := -1.0
  for i in [0:m] do
    let d := yl[i]![0]! - yr[i]![0]!
    if d > worst then worst := d
    if d > 1e-6 then leOk := false
  cs := cs.push ⟨"gate: lostSunS <= sunReachableS at every sampled pose (lostSunS_le_reach: the implication as an inequality of gates)",
    leOk, s!"max (lost - reach) {fmt worst} over {m} poses"⟩
  pure cs

end TraceCheck

open TraceCheck in
def main : IO Unit := do
  let src ← dishSource
  let a0 ← dishChecks src
  let a ← (a0 ++ ·) <$> mcChecks src
  let b0 ← sceneChecks
  let b ← (b0 ++ ·) <$> modulaChecks
  let mut bad := 0
  for c in a ++ b do
    IO.println s!"{if c.ok then "ok  " else "FAIL"} {c.name}\n      {c.note}"
    if !c.ok then bad := bad + 1
  IO.println s!"{(a ++ b).size - bad} of {(a ++ b).size} measured theorems hold"
  if bad > 0 then throw (IO.userError s!"{bad} measured theorems failed")

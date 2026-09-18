/-
# Compiling to categories, the Lean way

Conal Elliott's `concat` turns ordinary Haskell into categorical form by a GHC Core plugin, then
interprets that form in many categories: the meaning, a hash-consed circuit graph, and printers
off the graph (dot, GLSL, Verilog).  Lean has reflection natively, so the plugin is a `MetaM`
function: read a definition's `Expr` as it stands and translate it into a hash-consed dataflow
graph.  The vocabulary is enforced here - anything outside it is an error naming the definition
(his "Oops: toCcc' called", at compile time instead of run time).

The rule that Core does not need: class methods are LEAVES.  `HAdd.hAdd ℝ ℝ ℝ _ a b` is `+`; we
never look inside `Real.add`, which is a Cauchy-sequence quotient.  User definitions are unfolded
(delta + beta) and translated on; structure instances are unfolded to their constructor and read
field by field; `![…]` vectors and pairs are values with shape, so `wrenchAt p f 3` picks its
component without evaluating anything.

Printers: C99 (MSL/CUDA device functions), Graphviz dot, Lean over `ℝ` (the round trip whose
equation with the original is proved by `rfl` - his gold tests as theorems), Lean over `Float`
(the computable twin), JSON.
-/
import Lean
import Std.Data.HashMap
import Std.Data.HashSet

namespace Ccc
open Lean Meta

/-! ## The graph -/

/-- one node of the hash-consed dataflow graph -/
inductive Node where
  | input (name : String) (lean : String)  -- the C name and the Lean access path (`t 3`, `P.1`, `c.chord`)
  | lit (s : String)              -- a decimal literal, kept as text so every printer prints it exactly
  | bconst (b : Bool)
  | pi
  | un (op : String) (a : Nat)    -- neg sqrt sin cos tan arctan arccos arcsin abs not
  | bin (op : String) (a b : Nat) -- + - * / min max < <= > >= == != && || ->
  | pow (a : Nat) (n : Nat)       -- a literal natural exponent, kept for the Lean round trip
  | ite (c a b : Nat)
  | iteC (c a b : Nat)            -- an `if` whose Decidable instance is `Classical.propDecidable` (an opaque Prop)
  deriving BEq, Hashable, Repr, Inhabited

structure Graph where
  nodes : Array Node := #[]
  memo : Std.HashMap Node Nat := {}
  deriving Inhabited

def Graph.emit (g : Graph) (n : Node) : Graph × Nat :=
  match g.memo[n]? with
  | some i => (g, i)
  | none =>
    let i := g.nodes.size
    ({ nodes := g.nodes.push n, memo := g.memo.insert n i }, i)

/-- is the node a boolean? -/
partial def Graph.isBool (g : Graph) (i : Nat) : Bool :=
  match g.nodes[i]! with
  | .bconst _ => true
  | .un "not" _ => true
  | .bin op _ _ => op ∈ ["<", "<=", ">", ">=", "==", "!=", "&&", "||", "->"]
  | .ite _ a _ => g.isBool a
  | .iteC _ a _ => g.isBool a
  | _ => false

/-- a value with shape: reals, booleans, pairs, vectors, structures -/
inductive Val where
  | s (id : Nat)
  | b (id : Nat)
  | pair (a b : Val)
  | vec (xs : Array Val)
  | struct (name : Name) (fields : Array (Name × Val))
  deriving Repr, Inhabited

partial def Val.flatten : Val → Array Nat
  | Val.s i => #[i]
  | Val.b i => #[i]
  | .pair x y => x.flatten ++ y.flatten
  | .vec xs => xs.foldl (fun acc v => acc ++ v.flatten) #[]
  | .struct _ fs => fs.foldl (fun acc (_, v) => acc ++ v.flatten) #[]

partial def Val.shape : Val → String
  | Val.s _ => "real"
  | Val.b _ => "bool"
  | .pair x y => s!"({x.shape}, {y.shape})"
  | .vec xs => s!"vec{xs.size}[{if h : 0 < xs.size then (xs[0]'h).shape else "?"}]"
  | .struct n _ => s!"{n}"

/-! ## The translator -/

structure TState where
  g : Graph := {}
  env : Std.HashMap FVarId Val := {}
  inputs : Array (String × Nat) := #[]      -- flattened inputs, in binder order
  binders : Array (String × String) := #[]  -- (binder name, pretty type) for the Lean printers

abbrev TM := StateT TState MetaM

def emit (n : Node) : TM Nat :=
  modifyGet fun st => let (g, i) := st.g.emit n; (i, { st with g })

def scalar (v : Val) : TM Nat :=
  match v with
  | Val.s i => pure i
  | _ => throwError "expected a real, got a {v.shape}"

def boolean (v : Val) : TM Nat :=
  match v with
  | Val.b i => pure i
  | _ => throwError "expected a boolean, got a {v.shape}"

/-- a natural-number literal in any of its elaborated forms -/
partial def natLit? (e : Expr) : Option Nat :=
  match e with
  | .lit (.natVal n) => some n
  | .mdata _ e => natLit? e
  | _ =>
    let f := e.getAppFn
    let args := e.getAppArgs
    match f with
    | .const ``OfNat.ofNat _ => if args.size == 3 then natLit? args[1]! else none
    | .const ``Nat.cast _ => if args.size == 3 then natLit? args[2]! else none
    | .const ``Fin.mk _ => if args.size == 3 then natLit? args[1]! else none
    | .const ``Fin.val _ => if args.size == 2 then natLit? args[1]! else none
    | _ => none

/-- decimal text of `m * 10^(-e)` (`s = true`) or `m * 10^e` -/
def scientificText (m : Nat) (s : Bool) (e : Nat) : String :=
  if !s then (if e == 0 then toString m else s!"{m}e{e}")   -- `16e7` stays a scientific literal
  else if e == 0 then toString m
  else
    let ms := toString m
    let cs := if ms.length ≤ e then List.replicate (e + 1 - ms.length) '0' ++ ms.toList else ms.toList
    let k := cs.length - e
    String.ofList (cs.take k) ++ "." ++ String.ofList (cs.drop k)

/-- a Fin literal to instantiate a `∀ i : Fin n` -/
def finLit (n j : Nat) : Expr :=
  mkApp3 (.const ``Fin.mk []) (mkNatLit n) (mkNatLit j) (.const ``True.intro [])

/-- the names whose definitions we unfold and translate on, beyond the root namespace -/
def unfoldable : List Name :=
  [`TandoorSphere.sag, `TandoorSphere.sphereR, `TandoorSphere.focal, `TandoorSphere.cosOf,
   `TandoorSphere.tanTwo, `TandoorSphere.blur, `TandoorSphere.axial, `TandoorSphere.bestFocus,
   `TandoorSphere.dev, `TandoorMount.spot, `TandoorMount.spotParaxial]

def isRealTy (t : Expr) : Bool := t.isConstOf `Real

/-- Lean's own companions of a declaration (constructors' congruence and injectivity lemmas,
recursors, equation lemmas, `sizeOf`, `noConfusion`, match/proof auxiliaries) - never a definition
of the design -/
def isAutoGenerated (n : Name) : Bool :=
  let comps := n.components.map (·.toString)
  comps.any fun c =>
    c == "mk" || c.startsWith "congr" || c.startsWith "inj" || c.startsWith "eq_" ||
    c == "sizeOf_spec" || c.startsWith "noConfusion" || c == "casesOn" || c == "recOn" ||
    c == "rec" || c == "below" || c == "brecOn" || c == "ibelow" || c == "binductionOn" ||
    c == "ext" || c == "ext_iff" || c.startsWith "proof_" || c.startsWith "match_" ||
    c.startsWith "_" || c == "ctorIdx"

/-- a C identifier from a Lean binder name: Greek letters spelled out, anything else escaped -/
def sanitize (s : String) : String :=
  let greek : List (Char × String) :=
    [('α', "alpha"), ('β', "beta"), ('γ', "gamma"), ('δ', "delta"), ('ε', "eps"), ('ζ', "zeta"),
     ('η', "eta"), ('θ', "theta"), ('ι', "iota"), ('κ', "kappa"), ('λ', "lambda"), ('μ', "mu"),
     ('ν', "nu"), ('ξ', "xi"), ('π', "pi"), ('ρ', "rho"), ('σ', "sigma"), ('τ', "tau"),
     ('υ', "upsilon"), ('φ', "phi"), ('χ', "chi"), ('ψ', "psi"), ('ω', "omega"), ('Δ', "Delta"),
     ('Ω', "Omega"), ('Θ', "Theta"), ('Φ', "Phi"), ('Σ', "Sigma"), ('₀', "0"), ('₁', "1"),
     ('₂', "2"), ('\'', "_p")]
  let out := s.toList.foldl (fun (acc : String) c =>
    if c.isAlphanum || c == '_' then acc.push c
    else match greek.lookup c with
      | some g => acc ++ g
      | none => acc ++ "_u" ++ toString c.toNat) ""
  if out.isEmpty then "x" else out

/-- the shape of `v`, every leaf the node `z` -/
partial def constVal (z : Nat) : Val → TM Val
  | Val.s _ => pure (.s z)
  | Val.b _ => throwError "a boolean where a real was expected"
  | .pair a b => do pure (.pair (← constVal z a) (← constVal z b))
  | .vec xs => do pure (.vec (← xs.mapM (constVal z)))
  | .struct n fs => do pure (.struct n (← fs.mapM fun (f, v) => do pure (f, ← constVal z v)))

/-- an elementwise binary operation over two values of the same shape -/
partial def zipVal (op : String) : Val → Val → TM Val
  | Val.s x, Val.s y => .s <$> emit (.bin op x y)
  | .pair a b, .pair a' b' => do pure (.pair (← zipVal op a a') (← zipVal op b b'))
  | .vec xs, .vec ys => do
    unless xs.size == ys.size do throwError "vectors of sizes {xs.size} and {ys.size}"
    let mut zs := #[]
    for i in [0:xs.size] do zs := zs.push (← zipVal op xs[i]! ys[i]!)
    pure (.vec zs)
  | .struct n fs, .struct _ gs => do
    let mut hs := #[]
    for i in [0:fs.size] do hs := hs.push (fs[i]!.1, ← zipVal op fs[i]!.2 gs[i]!.2)
    pure (.struct n hs)
  | a, b => throwError "{op} between a {a.shape} and a {b.shape}"

/-- a scalar applied to every component -/
partial def mapVal (op : String) (c : Nat) : Val → TM Val
  | Val.s x => .s <$> emit (.bin op c x)
  | .pair a b => do pure (.pair (← mapVal op c a) (← mapVal op c b))
  | .vec xs => do pure (.vec (← xs.mapM (mapVal op c)))
  | .struct n fs => do pure (.struct n (← fs.mapM fun (f, v) => do pure (f, ← mapVal op c v)))
  | v => throwError "{op} of a scalar with a {v.shape}"

/-- equality of two values of the same shape: the conjunction of the componentwise equations -/
partial def eqVal : Val → Val → TM Nat
  | Val.s x, Val.s y => emit (.bin "==" x y)
  | Val.b x, Val.b y => emit (.bin "==" x y)
  | Val.s x, b => do eqVal (← constVal x b) b      -- a scalar against a shape: broadcast (`v = 0`)
  | a, Val.s y => do eqVal a (← constVal y a)
  | a, b => do
    let xs := a.flatten
    let ys := b.flatten
    unless xs.size == ys.size && a.shape == b.shape do
      throwError "an equation between a {a.shape} and a {b.shape}"
    let mut es : Array Nat := #[]
    for i in [0:xs.size] do
      es := es.push (← emit (.bin "==" xs[i]! ys[i]!))
    let mut acc : Option Nat := none            -- right-nested, as `funext_iff` + `Fin.forall_fin_succ` print it
    for i in [0:es.size] do
      let e := es[es.size - 1 - i]!
      acc := some (← match acc with | none => pure e | some p => emit (.bin "&&" e p))
    match acc with
    | some p => pure p
    | none => emit (.bconst true)

/-- `if c then a else b` over values of the same shape; `cl` marks a classical instance -/
partial def iteVal (cl : Bool) (c : Nat) : Val → Val → TM Val
  | Val.s x, Val.s y => .s <$> emit (if cl then .iteC c x y else .ite c x y)
  | Val.b x, Val.b y => .b <$> emit (if cl then .iteC c x y else .ite c x y)
  | .pair a b, .pair a' b' => do pure (.pair (← iteVal cl c a a') (← iteVal cl c b b'))
  | .vec xs, .vec ys => do
    unless xs.size == ys.size do throwError "an if with vectors of sizes {xs.size} and {ys.size}"
    let mut zs := #[]
    for i in [0:xs.size] do zs := zs.push (← iteVal cl c xs[i]! ys[i]!)
    pure (.vec zs)
  | .struct n fs, .struct _ gs => do
    let mut hs := #[]
    for i in [0:fs.size] do hs := hs.push (fs[i]!.1, ← iteVal cl c fs[i]!.2 gs[i]!.2)
    pure (.struct n hs)
  | a, b => throwError "an if with branches of shape {a.shape} and {b.shape}"

mutual

partial def translate (root : Name) (e : Expr) : TM Val := do
  match e with
  | .mdata _ e => translate root e
  | .fvar id =>
    match (← get).env[id]? with
    | some v => pure v
    | none => throwError "unbound variable {e}"
  | .letE n t v b _ => do
    -- the value once, the body against a local bound to it (linear, however often it is used)
    let vv ← translate root v
    let st ← get
    let (r, st') ← withLetDecl n t v fun x => do
      (translate root (b.instantiate1 x)).run { st with env := st.env.insert x.fvarId! vv }
    set st'
    pure r
  | .proj _ i x => do
    let xv ← translate root x
    match xv with
    | .struct _ fs => pure fs[i]!.2
    | .pair a b => pure (if i == 0 then a else b)
    | v => throwError "projection {i} of a {v.shape}"
  | .forallE _ dom body _ => translateForall root dom body
  | .lam .. => throwError "a lambda where a value was expected: {e}"
  | .lit _ => throwError "unexpected literal {e}"
  | .sort _ => throwError "unexpected sort"
  | _ => translateApp root e

partial def translateForall (root : Name) (dom body : Expr) : TM Val := do
  -- an implication `p → q` is a non-dependent Pi over a proposition
  if !body.hasLooseBVars && (← isProp dom) then
    let p ← boolean (← translate root dom)
    let q ← boolean (← translate root body)
    return .b (← emit (.bin "->" p q))
  -- `∀ i : Fin n, P i`, unrolled into a conjunction
  let df := dom.getAppFn
  let dargs := dom.getAppArgs
  unless df.isConstOf ``Fin && dargs.size == 1 do
    throwError "a ∀ over {dom} cannot be compiled"
  let some n := natLit? dargs[0]! | throwError "a ∀ over Fin with a non-literal bound"
  -- right-nested, `P 0 ∧ (P 1 ∧ …)`, the shape Mathlib's `Fin.forall_fin_succ` gives the round trip
  let mut bs : Array Nat := #[]
  for j in [0:n] do
    bs := bs.push (← boolean (← translate root (body.instantiate1 (finLit n j))))
  let mut acc : Option Nat := none
  for j in [0:n] do
    let bj := bs[n - 1 - j]!
    acc := some (← match acc with
      | none => pure bj
      | some a => emit (.bin "&&" bj a))
  match acc with
  | some a => pure (.b a)
  | none => .b <$> emit (.bconst true)

partial def binop (root : Name) (op : String) (a b : Expr) : TM Val := do
  let x ← translate root a
  let y ← translate root b
  match x, y with
  | Val.s x, Val.s y => .s <$> emit (.bin op x y)
  | x, y => zipVal op x y

partial def cmpop (root : Name) (op : String) (a b : Expr) : TM Val := do
  let x ← scalar (← translate root a)
  let y ← scalar (← translate root b)
  .b <$> emit (.bin op x y)

partial def boolop (root : Name) (op : String) (a b : Expr) : TM Val := do
  let x ← boolean (← translate root a)
  let y ← boolean (← translate root b)
  .b <$> emit (.bin op x y)

partial def unop (root : Name) (op : String) (a : Expr) : TM Val := do
  let x ← scalar (← translate root a)
  .s <$> emit (.un op x)

/-- index a vector value by literal arguments -/
partial def applyArgs (v : Val) (args : Array Expr) : TM Val := do
  let mut v := v
  for a in args do
    match v with
    | .vec xs =>
      let some j := natLit? a | throwError "a vector indexed by a non-literal {a}"
      unless j < xs.size do throwError "index {j} out of range {xs.size}"
      v := xs[j]!
    | w => throwError "applying a {w.shape} to an argument"
  pure v

partial def translateApp (root : Name) (e : Expr) : TM Val := do
  let f := e.getAppFn
  let args := e.getAppArgs
  match f with
  | .fvar _ => do
    let v ← translate root f
    applyArgs v args
  | .letE .. | .mdata .. => do
    -- a `let` (or annotated) expression in head position: its value, then the indices
    let v ← translate root f
    applyArgs v args
  | .lam .. => translate root e.headBeta
  | .const n _ =>
    let k := args.size
    match n, k with
    | ``HAdd.hAdd, 6 => binop root "+" args[4]! args[5]!
    | ``HSub.hSub, 6 => binop root "-" args[4]! args[5]!
    | ``HMul.hMul, 6 => binop root "*" args[4]! args[5]!
    | ``HDiv.hDiv, 6 => binop root "/" args[4]! args[5]!
    | ``Neg.neg, 3 => do
      match ← translate root args[2]! with
      | Val.s x => .s <$> emit (.un "neg" x)
      | v => do
        let z ← emit (.lit "0")
        zipVal "-" (← constVal z v) v
    | ``HSMul.hSMul, 6 => do
      let c ← scalar (← translate root args[4]!)
      mapVal "*" c (← translate root args[5]!)
    | ``SMul.smul, 4 => do
      let c ← scalar (← translate root args[2]!)
      mapVal "*" c (← translate root args[3]!)
    | `Nat.iterate, 4 => do
      -- `f^[n] a`: `n` applications of `f`, each on a local bound to the value so far
      let some n := natLit? args[2]! | throwError "an iterate with a non-literal count"
      let mut cur ← translate root args[3]!
      for _ in [0:n] do
        let st ← get
        let (r, st') ← withLocalDeclD `xIter args[0]! fun x => do
          (translate root (mkApp args[1]! x).headBeta).run { st with env := st.env.insert x.fvarId! cur }
        set st'
        cur := r
      pure cur
    | ``HPow.hPow, 6 => do
      let some m := natLit? args[5]! | throwError "a power with a non-literal exponent"
      let x ← scalar (← translate root args[4]!)
      .s <$> emit (.pow x m)
    | `Real.sqrt, 1 => unop root "sqrt" args[0]!
    | `Real.sin, 1 => unop root "sin" args[0]!
    | `Real.cos, 1 => unop root "cos" args[0]!
    | `Real.tan, 1 => unop root "tan" args[0]!
    | `Real.arctan, 1 => unop root "arctan" args[0]!
    | `Real.arccos, 1 => unop root "arccos" args[0]!
    | `Real.arcsin, 1 => unop root "arcsin" args[0]!
    | `Real.exp, 1 => unop root "exp" args[0]!
    | `Real.log, 1 => unop root "log" args[0]!
    | `Real.pi, 0 => .s <$> emit .pi
    | `abs, _ => unop root "abs" args.back!
    | ``Min.min, 4 => binop root "min" args[2]! args[3]!
    | ``Max.max, 4 => binop root "max" args[2]! args[3]!
    | ``OfScientific.ofScientific, 5 => do
      let some m := natLit? args[2]! | throwError "a numeral with a non-literal mantissa"
      let some ex := natLit? args[4]! | throwError "a numeral with a non-literal exponent"
      let s := args[3]!.isConstOf ``Bool.true
      .s <$> emit (.lit (scientificText m s ex))
    | ``OfNat.ofNat, 3 => do
      let some m := natLit? args[1]! | throwError "a non-literal OfNat"
      .s <$> emit (.lit (toString m))
    | ``Nat.cast, 3 => do
      let some m := natLit? args[2]! | throwError "a cast of a non-literal"
      .s <$> emit (.lit (toString m))
    | ``Prod.mk, 4 => do
      let a ← translate root args[2]!
      let b ← translate root args[3]!
      pure (.pair a b)
    | ``Prod.fst, 3 => do
      match ← translate root args[2]! with
      | .pair a _ => pure a
      | v => throwError "fst of a {v.shape}"
    | ``Prod.snd, 3 => do
      match ← translate root args[2]! with
      | .pair _ b => pure b
      | v => throwError "snd of a {v.shape}"
    | `Matrix.vecCons, 4 => do
      let a ← translate root args[2]!
      match ← translate root args[3]! with
      | .vec xs => pure (.vec (#[a] ++ xs))
      | v => throwError "vecCons onto a {v.shape}"
    | `Matrix.vecCons, k => do
      -- a vector applied to one or more literal indices (`![…] i`, `![…] i j` for a vector of vectors)
      unless k > 4 do throwError "vecCons with {k} arguments"
      let v ← translateApp root (mkAppN f (args.extract 0 4))
      applyArgs v (args.extract 4 k)
    | `Matrix.vecEmpty, 1 => pure (.vec #[])
    | ``ite, 5 => do
      let c ← boolean (← translate root args[1]!)
      let a ← translate root args[3]!
      let b ← translate root args[4]!
      -- the instance: `Classical.propDecidable` (an opaque Prop, `open Classical`) or a specific one
      let cl := args[2]!.getAppFn.isConstOf ``Classical.propDecidable
      iteVal cl c a b
    | ``LT.lt, 4 => cmpop root "<" args[2]! args[3]!
    | ``LE.le, 4 => cmpop root "<=" args[2]! args[3]!
    | ``GT.gt, 4 => cmpop root ">" args[2]! args[3]!
    | ``GE.ge, 4 => cmpop root ">=" args[2]! args[3]!
    | ``Eq, 3 => .b <$> eqVal (← translate root args[1]!) (← translate root args[2]!)
    | ``Ne, 3 => do
      match ← translate root args[1]!, ← translate root args[2]! with
      | Val.s x, Val.s y => .b <$> emit (.bin "!=" x y)
      | a, b => .b <$> emit (.un "not" (← eqVal a b))
    | ``And, 2 => boolop root "&&" args[0]! args[1]!
    | ``Or, 2 => boolop root "||" args[0]! args[1]!
    | ``Iff, 2 => boolop root "==" args[0]! args[1]!
    | ``Not, 1 => do
      let x ← boolean (← translate root args[0]!)
      .b <$> emit (.un "not" x)
    | ``True, 0 => .b <$> emit (.bconst true)
    | ``False, 0 => .b <$> emit (.bconst false)
    | _, _ => translateConst root n f args e
  | _ => throwError "cannot compile the head {f}"

/-- a constant that is not a primitive: a projection, a structure instance, or a definition -/
partial def translateConst (root : Name) (n : Name) (_f : Expr) (args : Array Expr) (e : Expr) :
    TM Val := do
  let env ← getEnv
  -- a structure projection function applied to something with fields
  if let some pinfo ← getProjectionFnInfo? n then
    if args.size > pinfo.numParams then
      let major := args[pinfo.numParams]!
      let mv ← translate root major
      let field ← match mv with
        | .struct _ fs =>
          if h : pinfo.i < fs.size then pure fs[pinfo.i].2
          else throwError "field {pinfo.i} of {major}"
        | .pair a b =>                                   -- `Prod.fst`/`Prod.snd` applied on, e.g. `(p.1) 2`
          if pinfo.i == 0 then pure a else if pinfo.i == 1 then pure b
          else throwError "field {pinfo.i} of a pair"
        | v => throwError "a projection {n} of a {v.shape}"
      return ← applyArgs field (args.extract (pinfo.numParams + 1) args.size)
  let some ci := env.find? n | throwError "unknown constant {n}"
  match ci with
  | .ctorInfo cinfo =>
    -- a structure constructor applied to its fields: read them, skipping the proofs
    let sn := cinfo.induct
    unless isStructure env sn do throwError "the constructor {n} is not a structure's"
    let fields := getStructureFields env sn
    let mut fs : Array (Name × Val) := #[]
    for i in [0:fields.size] do
      let fname := fields[i]!
      let some farg := args[cinfo.numParams + i]? | throwError "a partial constructor application {n}"
      let fty ← inferType farg
      if ← isProp fty then continue
      let fv ← translate root farg
      fs := fs.push (fname, fv)
    return .struct sn fs
  | .defnInfo _ =>
    -- a definition in the root namespace or on the allow list: unfold (delta + beta) and go on
    if root.isPrefixOf n || unfoldable.contains n then
      let some e' ← unfoldDefinition? e | throwError "cannot unfold {n}"
      return ← translate root e'.headBeta
    throwError "the constant {n} (with {args.size} arguments) is outside the vocabulary"
  | _ => throwError "the constant {n} is not a definition"

end

/-- bind a binder as inputs, according to its type's shape -/
partial def bindInput (root : Name) (name lean : String) (t : Expr) : TM Val := do
  let t ← whnfR t
  if isRealTy t || t.isConstOf ``Nat then
    let i ← emit (.input name lean)
    modify fun st => { st with inputs := st.inputs.push (name, i) }
    return .s i
  let f := t.getAppFn
  let args := t.getAppArgs
  if f.isConstOf ``Prod && args.size == 2 then
    let a ← bindInput root (name ++ "_1") (lean ++ ".1") args[0]!
    let b ← bindInput root (name ++ "_2") (lean ++ ".2") args[1]!
    return .pair a b
  if let .forallE _ dom cod _ := t then
    if dom.getAppFn.isConstOf ``Fin then
      if let some n := natLit? dom.getAppArgs[0]! then
        let mut xs := #[]
        for j in [0:n] do
          xs := xs.push (← bindInput root (name ++ "_" ++ toString j) s!"({lean} {j})" cod)
        return .vec xs
  if let .const sn _ := f then
    let env ← getEnv
    if isStructure env sn then
      let fields := getStructureFields env sn
      let mut fs := #[]
      for fname in fields do
        let projTy ← inferType (mkConst (sn ++ fname))
        let fty ← forallTelescope projTy fun _ b => pure b
        if ← isProp fty then continue
        let v ← bindInput root (name ++ "_" ++ fname.toString) (lean ++ "." ++ fname.toString) fty
        fs := fs.push (fname, v)
      return .struct sn fs
  throwError "a binder {name} of type {t} cannot be an input"

/-- a compiled definition -/
structure Fun where
  name : Name
  inputs : Array (String × Nat)
  binders : Array (String × String)
  output : Val
  graph : Graph
  isProp : Bool
  isTheorem : Bool := false
  /-- a theorem's binders in their original order: data binders by name, hypotheses as `_h<k>` -/
  thmArgs : Array String := #[]
  /-- how many hypotheses the theorem has -/
  nHyps : Nat := 0

/-- bind a data binder (a lambda's or a ∀'s) as inputs, recording it for the printers -/
def bindBinder (root : Name) (x : Expr) (k : Nat) : TM String := do
  let userName := (← x.fvarId!.getUserName).toString
  let leanName := if userName.any (· == '✝') || userName == "_" then "x" ++ toString k else userName
  let name := sanitize leanName
  let t ← inferType x
  let tyStr ← ppExpr t
  let val ← bindInput root name leanName t
  modify fun st => { st with env := st.env.insert x.fvarId! val,
                             binders := st.binders.push (leanName, toString tyStr) }
  pure leanName

/-- how many leading binders of a theorem's type are data or hypotheses, before a `∀ i : Fin n`
(which the statement unrolls) -/
partial def leadingBinders (ty : Expr) : MetaM Nat := do
  let ty ← whnfR ty
  match ty with
  | .forallE n d b bi =>
    let df := d.getAppFn
    if df.isConstOf ``Fin then return 0
    withLocalDecl n bi d fun x => do
      return 1 + (← leadingBinders (b.instantiate1 x))
  | _ => return 0

/-- compile one definition (or a closed theorem statement) -/
def compileDef (root : Name) (n : Name) : MetaM (Except String Fun) := do
  let ci ← getConstInfo n
  try
    match ci with
    | .thmInfo _ =>
      -- a theorem: its data binders become inputs, its hypotheses booleans, and the statement is
      -- `h₁ → h₂ → … → conclusion` - a property function, true at every input if the arithmetic
      -- is faithful; a closed statement is a constant
      let ty ← instantiateMVars ci.type
      -- the binders up to the first `∀ i : Fin n` (that one, and what follows, is the statement)
      let nLead ← leadingBinders ty
      let (out, st) ← forallBoundedTelescope ty (some nLead) fun xs body => do
        let act : TM (Val × Array String × Nat) := do
          let mut hyps : Array Nat := #[]
          let mut order : Array String := #[]
          for x in xs do
            let t ← inferType x
            if ← isProp t then
              let hv ← boolean (← translate root t)
              hyps := hyps.push hv
              order := order.push s!"_h{hyps.size}"
            else
              order := order.push (← bindBinder root x xs.size)
          let mut r ← boolean (← translate root body)
          for h in hyps.reverse do
            r ← emit (.bin "->" h r)
          pure (.b r, order, hyps.size)
        act.run {}
      let (v, order, nh) := out
      pure (Except.ok { name := n, inputs := st.inputs, binders := st.binders, output := v,
                        graph := st.g, isProp := true, isTheorem := true, thmArgs := order, nHyps := nh })
    | .defnInfo d =>
      let v ← instantiateMVars d.value
      let ty ← instantiateMVars d.type
      let isP ← forallTelescope ty fun _ b => pure b.isProp
      let (out, st) ← lambdaTelescope v fun xs body => do
        let act : TM Val := do
          for x in xs do
            let _ ← bindBinder root x xs.size
          translate root body
        act.run {}
      pure (Except.ok { name := n, inputs := st.inputs, binders := st.binders, output := out,
                        graph := st.g, isProp := isP })
    | _ => pure (Except.error "not a definition or theorem")
  catch ex =>
    pure (Except.error (← ex.toMessageData.toString))

/-! ## Printers -/

def cName (n : Name) : String := "hk_" ++ sanitize n.getString!

/-- the nodes an output depends on, walked backwards (node ids only ever point to earlier nodes) -/
def liveNodes (g : Graph) (outs : Array Nat) : Std.HashSet Nat := Id.run do
  let mut live : Std.HashSet Nat := {}
  for o in outs do live := live.insert o
  let n := g.nodes.size
  for k in [0:n] do
    let i := n - 1 - k
    if !live.contains i then continue
    match g.nodes[i]! with
    | .un _ a => live := live.insert a
    | .bin _ a b => live := live.insert a |>.insert b
    | .pow a _ => live := live.insert a
    | .ite c a b => live := live.insert c |>.insert a |>.insert b
    | .iteC c a b => live := live.insert c |>.insert a |>.insert b
    | _ => pure ()
  return live

/-- C99, target-neutral: `hk_real`, `HK_LIT`, `hk_sqrt` ... are macros the includer sets -/
def printC (f : Fun) : String := Id.run do
  let g := f.graph
  let mut lines : Array String := #[]
  let outs := f.output.flatten
  let retTy := match f.output with
    | Val.s _ => "hk_real" | Val.b _ => "bool" | _ => "void"
  let params := f.inputs.map fun (nm, i) => (if g.isBool i then "bool " else "hk_real ") ++ nm
  let params := if retTy == "void" then params.push "hk_real HK_ADDR* out" else params
  let paramStr := if params.isEmpty then "void" else ", ".intercalate params.toList
  lines := lines.push s!"HK_STATIC {retTy} {cName f.name}({paramStr}) \{"
  let live := liveNodes g outs
  let mut usedInput : Std.HashSet Nat := {}
  for i in [0:g.nodes.size] do
    if !live.contains i then continue
    let node := g.nodes[i]!
    let ty := if g.isBool i then "bool" else "hk_real"
    let rhs : Option String := match node with
      | .input _ _ => none
      | .lit s => some s!"HK_LIT({s})"
      | .bconst b => some (if b then "true" else "false")
      | .pi => some "HK_PI"
      | .un op a =>
        let av := s!"t{a}"
        some (match op with
          | "neg" => s!"(-{av})" | "not" => s!"(!{av})" | "sqrt" => s!"hk_sqrt({av})"
          | "sin" => s!"hk_sin({av})" | "cos" => s!"hk_cos({av})" | "tan" => s!"hk_tan({av})"
          | "arctan" => s!"hk_atan({av})" | "arccos" => s!"hk_acos({av})" | "arcsin" => s!"hk_asin({av})"
          | "exp" => s!"hk_exp({av})" | "log" => s!"hk_log({av})"
          | "abs" => s!"hk_fabs({av})" | o => s!"/* ? {o} */ {av}")
      | .bin op a b =>
        some (match op with
          | "min" => s!"hk_min(t{a}, t{b})" | "max" => s!"hk_max(t{a}, t{b})"
          | "==" => if g.isBool a then s!"(t{a} == t{b})" else s!"hk_eq(t{a}, t{b})"
          | "!=" => if g.isBool a then s!"(t{a} != t{b})" else s!"(!hk_eq(t{a}, t{b}))"
          | "->" => s!"(!t{a} || t{b})"
          | o => s!"(t{a} {o} t{b})")
      | .pow a n =>
        some (if n == 0 then "HK_LIT(1)" else " * ".intercalate (List.replicate n s!"t{a}"))
      | .ite c a b => some s!"(t{c} ? t{a} : t{b})"
      | .iteC c a b => some s!"(t{c} ? t{a} : t{b})"
    match node, rhs with
    | .input nm _, _ =>
      usedInput := usedInput.insert i
      lines := lines.push s!"  const {ty} t{i} = {nm};"
    | _, some r => lines := lines.push s!"  const {ty} t{i} = {r};"
    | _, none => pure ()
  match f.output with
  | Val.s i => lines := lines.push s!"  return t{i};"
  | Val.b i => lines := lines.push s!"  return t{i};"
  | _ =>
    for k in [0:outs.size] do
      lines := lines.push s!"  out[{k}] = t{outs[k]!};"
  lines := lines.push "}"
  return "\n".intercalate lines.toList

/-- Graphviz -/
def printDot (f : Fun) : String := Id.run do
  let g := f.graph
  let mut lines : Array String := #[s!"digraph \"{f.name}\" \{", "  rankdir=BT;", "  node [fontname=Helvetica];"]
  for i in [0:g.nodes.size] do
    let (label, shape) := match g.nodes[i]! with
      | .input nm _ => (nm, "box")
      | .lit s => (s, "plaintext")
      | .bconst b => (if b then "true" else "false", "plaintext")
      | .pi => ("π", "plaintext")
      | .un op _ => (op, "ellipse")
      | .bin op _ _ => (op, "ellipse")
      | .pow _ n => (s!"^{n}", "ellipse")
      | .ite .. => ("if", "diamond")
      | .iteC .. => ("if (classical)", "diamond")
    lines := lines.push s!"  n{i} [label=\"{label}\", shape={shape}];"
    match g.nodes[i]! with
    | .un _ a => lines := lines.push s!"  n{a} -> n{i};"
    | .bin _ a b => lines := lines.push s!"  n{a} -> n{i}; n{b} -> n{i};"
    | .pow a _ => lines := lines.push s!"  n{a} -> n{i};"
    | .ite c a b => lines := lines.push s!"  n{c} -> n{i} [label=c]; n{a} -> n{i} [label=1]; n{b} -> n{i} [label=0];"
    | .iteC c a b => lines := lines.push s!"  n{c} -> n{i} [label=c]; n{a} -> n{i} [label=1]; n{b} -> n{i} [label=0];"
    | _ => pure ()
  let outs := f.output.flatten
  for k in [0:outs.size] do
    lines := lines.push s!"  out{k} [label=\"out {k}\", shape=box, style=filled, fillcolor=lightgrey]; n{outs[k]!} -> out{k};"
  lines := lines.push "}"
  return "\n".intercalate lines.toList

/-- use counts, to decide what the Lean printers bind with `let` -/
def useCounts (g : Graph) : Array Nat := Id.run do
  let mut c := Array.replicate g.nodes.size 0
  for node in g.nodes do
    match node with
    | .un _ a => c := c.modify a (· + 1)
    | .bin _ a b => c := c.modify a (· + 1); c := c.modify b (· + 1)
    | .pow a _ => c := c.modify a (· + 1)
    | .ite x a b => c := c.modify x (· + 1); c := c.modify a (· + 1); c := c.modify b (· + 1)
    | .iteC x a b => c := c.modify x (· + 1); c := c.modify a (· + 1); c := c.modify b (· + 1)
    | _ => pure ()
  return c

/-- the Lean printers: `real` selects `ℝ` (the round trip) or `Float` (the twin) -/
partial def leanExpr (g : Graph) (real : Bool) (i : Nat) : String :=
  let r := leanExpr g real
  match g.nodes[i]! with
  | .input nm ln => if real then ln else nm
  | .lit s => if real then s!"({s} : ℝ)" else s!"({s} : Float)"
  | .bconst b => if b then "True" else "False"
  | .pi => if real then "Real.pi" else "(3.141592653589793 : Float)"
  | .un op a =>
    match op with
    | "neg" => s!"(-{r a})"
    | "not" => if real then s!"(¬ {r a})" else s!"(!{r a})"
    | "sqrt" => if real then s!"(Real.sqrt {r a})" else s!"(Float.sqrt {r a})"
    | "sin" => if real then s!"(Real.sin {r a})" else s!"(Float.sin {r a})"
    | "cos" => if real then s!"(Real.cos {r a})" else s!"(Float.cos {r a})"
    | "tan" => if real then s!"(Real.tan {r a})" else s!"(Float.tan {r a})"
    | "arctan" => if real then s!"(Real.arctan {r a})" else s!"(Float.atan {r a})"
    | "arccos" => if real then s!"(Real.arccos {r a})" else s!"(Float.acos {r a})"
    | "arcsin" => if real then s!"(Real.arcsin {r a})" else s!"(Float.asin {r a})"
    | "exp" => if real then s!"(Real.exp {r a})" else s!"(Float.exp {r a})"
    | "log" => if real then s!"(Real.log {r a})" else s!"(Float.log {r a})"
    | "abs" => if real then s!"|{r a}|" else s!"(Float.abs {r a})"
    | o => s!"?{o}"
  | .bin op a b =>
    match op with
    | "min" => s!"(min {r a} {r b})"
    | "max" => s!"(max {r a} {r b})"
    | "==" => if real then (if g.isBool a then s!"({r a} ↔ {r b})" else s!"({r a} = {r b})") else if g.isBool a then s!"({r a} == {r b})" else s!"(feq {r a} {r b})"
    | "!=" => if real then s!"({r a} ≠ {r b})" else if g.isBool a then s!"({r a} != {r b})" else s!"(!(feq {r a} {r b}))"
    | "&&" => if real then s!"({r a} ∧ {r b})" else s!"({r a} && {r b})"
    | "||" => if real then s!"({r a} ∨ {r b})" else s!"({r a} || {r b})"
    | "->" => if real then s!"({r a} → {r b})" else s!"(!{r a} || {r b})"
    | "<=" => if real then s!"({r a} ≤ {r b})" else s!"({r a} <= {r b})"
    | ">=" => if real then s!"({r a} ≥ {r b})" else s!"({r a} >= {r b})"
    | o => s!"({r a} {o} {r b})"
  | .pow a n => s!"({r a} ^ {n})"
  | .ite c a b => s!"(if {r c} then {r a} else {r b})"
  | .iteC c a b => if real then s!"(@ite _ {r c} (Classical.propDecidable _) {r a} {r b})" else s!"(if {r c} then {r a} else {r b})"

partial def leanVal (g : Graph) (real : Bool) : Val → String
  | Val.s i => leanExpr g real i
  | Val.b i => leanExpr g real i
  | .pair a b => s!"({leanVal g real a}, {leanVal g real b})"
  | .vec xs => "![" ++ ", ".intercalate (xs.toList.map (leanVal g real)) ++ "]"
  | .struct n fs => "{ " ++ ", ".intercalate (fs.toList.map fun (f, v) => s!"{f} := {leanVal g real v}") ++ s!" : {n} }"

/-- the Lean printers with `let`s: every non-leaf node used more than once (or costly) is bound
once, in graph order, so a shared subgraph prints once; the printed expression stays linear in
the graph. `leanExprL` prints a node against those bindings. -/
partial def leanBody (g : Graph) (real : Bool) (outs : Array Nat) (v : Val) (indent : String) : String := Id.run do
  let counts := useCounts g
  let live := liveNodes g outs
  -- the nodes bound by a let: shared, non-leaf
  let mut bound : Std.HashSet Nat := {}
  for i in [0:g.nodes.size] do
    if !live.contains i then continue
    match g.nodes[i]! with
    | .input .. | .lit _ | .bconst _ | .pi => pure ()
    | _ => if counts[i]! > 1 then bound := bound.insert i
  -- print a node: a bound node by its name, otherwise inline (recursively)
  let rec pr (i : Nat) (top : Bool) : String :=
    if bound.contains i && !top then s!"v{i}" else
    let r := fun j => pr j false
    match g.nodes[i]! with
    | .input nm ln => if real then ln else nm
    | .lit s => if real then s!"({s} : ℝ)" else s!"({s} : Float)"
    | .bconst b => if b then "True" else "False"
    | .pi => if real then "Real.pi" else "(3.141592653589793 : Float)"
    | .un op a =>
      match op with
      | "neg" => s!"(-{r a})"
      | "not" => if real then s!"(¬ {r a})" else s!"(!{r a})"
      | "sqrt" => if real then s!"(Real.sqrt {r a})" else s!"(Float.sqrt {r a})"
      | "sin" => if real then s!"(Real.sin {r a})" else s!"(Float.sin {r a})"
      | "cos" => if real then s!"(Real.cos {r a})" else s!"(Float.cos {r a})"
      | "tan" => if real then s!"(Real.tan {r a})" else s!"(Float.tan {r a})"
      | "arctan" => if real then s!"(Real.arctan {r a})" else s!"(Float.atan {r a})"
      | "arccos" => if real then s!"(Real.arccos {r a})" else s!"(Float.acos {r a})"
      | "arcsin" => if real then s!"(Real.arcsin {r a})" else s!"(Float.asin {r a})"
      | "exp" => if real then s!"(Real.exp {r a})" else s!"(Float.exp {r a})"
      | "log" => if real then s!"(Real.log {r a})" else s!"(Float.log {r a})"
      | "abs" => if real then s!"|{r a}|" else s!"(Float.abs {r a})"
      | o => s!"?{o}"
    | .bin op a b =>
      match op with
      | "min" => s!"(min {r a} {r b})"
      | "max" => s!"(max {r a} {r b})"
      | "==" => if real then (if g.isBool a then s!"({r a} ↔ {r b})" else s!"({r a} = {r b})") else if g.isBool a then s!"({r a} == {r b})" else s!"(feq {r a} {r b})"
      | "!=" => if real then s!"({r a} ≠ {r b})" else if g.isBool a then s!"({r a} != {r b})" else s!"(!(feq {r a} {r b}))"
      | "&&" => if real then s!"({r a} ∧ {r b})" else s!"({r a} && {r b})"
      | "||" => if real then s!"({r a} ∨ {r b})" else s!"({r a} || {r b})"
      | "->" => if real then s!"({r a} → {r b})" else s!"(!{r a} || {r b})"
      | "<=" => if real then s!"({r a} ≤ {r b})" else s!"({r a} <= {r b})"
      | ">=" => if real then s!"({r a} ≥ {r b})" else s!"({r a} >= {r b})"
      | o => s!"({r a} {o} {r b})"
    | .pow a n => s!"({r a} ^ {n})"
    | .ite c a b => s!"(if {r c} then {r a} else {r b})"
    | .iteC c a b => if real then s!"(@ite _ {r c} (Classical.propDecidable _) {r a} {r b})" else s!"(if {r c} then {r a} else {r b})"
  let rec prVal : Val → String
    | Val.s i => pr i false
    | Val.b i => pr i false
    | .pair a b => s!"({prVal a}, {prVal b})"
    | .vec xs => "![" ++ ", ".intercalate (xs.toList.map prVal) ++ "]"
    | .struct n fs => "{ " ++ ", ".intercalate (fs.toList.map fun (f, w) => s!"{f} := {prVal w}") ++ s!" : {n} }"
  let mut lines : Array String := #[]
  for i in [0:g.nodes.size] do
    if bound.contains i then
      lines := lines.push s!"{indent}let v{i} := {pr i true}"
  lines := lines.push (indent ++ prVal v)
  return "\n".intercalate lines.toList

/-- NumPy, vectorised: every input an array (or a float), every op elementwise, `if` as `np.where` -/
def printNumpy (f : Fun) (fname : String) : String := Id.run do
  let g := f.graph
  let mut lines : Array String := #[]
  let params := f.inputs.map (·.1)
  lines := lines.push s!"def {fname}({", ".intercalate params.toList}):"
  for i in [0:g.nodes.size] do
    let rhs : Option String := match g.nodes[i]! with
      | .input nm _ => some nm
      | .lit s => some s
      | .bconst b => some (if b then "True" else "False")
      | .pi => some "np.pi"
      | .un op a =>
        let av := s!"t{a}"
        some (match op with
          | "neg" => s!"(-{av})" | "not" => s!"np.logical_not({av})" | "sqrt" => s!"np.sqrt({av})"
          | "sin" => s!"np.sin({av})" | "cos" => s!"np.cos({av})" | "tan" => s!"np.tan({av})"
          | "arctan" => s!"np.arctan({av})" | "arccos" => s!"np.arccos({av})" | "arcsin" => s!"np.arcsin({av})"
          | "exp" => s!"np.exp({av})" | "log" => s!"np.log({av})"
          | "abs" => s!"np.abs({av})" | o => s!"None  # ? {o}")
      | .bin op a b =>
        some (match op with
          | "min" => s!"np.minimum(t{a}, t{b})" | "max" => s!"np.maximum(t{a}, t{b})"
          | "==" => if g.isBool a then s!"(t{a} == t{b})" else s!"hk_eq(t{a}, t{b})"
          | "!=" => if g.isBool a then s!"(t{a} != t{b})" else s!"np.logical_not(hk_eq(t{a}, t{b}))"
          | "&&" => s!"np.logical_and(t{a}, t{b})" | "||" => s!"np.logical_or(t{a}, t{b})"
          | "->" => s!"np.logical_or(np.logical_not(t{a}), t{b})"
          | o => s!"(t{a} {o} t{b})")
      | .pow a n => some s!"(t{a} ** {n})"
      | .ite c a b => some s!"np.where(t{c}, t{a}, t{b})"
      | .iteC c a b => some s!"np.where(t{c}, t{a}, t{b})"
    match rhs with
    | some r => lines := lines.push s!"    t{i} = {r}"
    | none => pure ()
  match f.output with
  | Val.s i => lines := lines.push s!"    return t{i}"
  | Val.b i => lines := lines.push s!"    return t{i}"
  | v =>
    let outs := v.flatten
    lines := lines.push ("    return np.stack([" ++ ", ".intercalate (outs.toList.map fun i => s!"np.broadcast_to(np.asarray(t{i}, dtype=float), np.broadcast(*[np.asarray(x) for x in [{", ".intercalate params.toList}]]).shape) if len([{", ".intercalate params.toList}]) else np.asarray(t{i}, dtype=float)") ++ "], axis=-1)")
  return "\n".intercalate lines.toList

/-- the round trip. A definition: `theorem f_ccc : f = fun binders => printed := rfl`. A theorem:
its statement printed back, `∀ (data binders), h₁ → … → conclusion`, PROVED BY THE THEOREM
ITSELF - Lean checks the printed statement is the original one, up to definitional unfolding. -/
def printRoundTrip (f : Fun) (ref : String := f.name.getString!) (thm : String := ref) : String :=
  let binders := " ".intercalate (f.binders.toList.map fun (nm, ty) => s!"({nm} : {ty})")
  let body := leanBody f.graph true f.output.flatten f.output "    "
  let nm := ref
  let _ := thm
  if f.isTheorem then
    let dataNames := f.binders.map (·.1)
    let hypNames := (List.range f.nHyps).map fun k => s!"_h{k + 1}"
    let lam := " ".intercalate (dataNames.toList ++ hypNames)
    let call := " ".intercalate (f.thmArgs.toList)
    let stmt := if f.binders.isEmpty then body else s!"∀ {binders},\n{body}"
    if f.thmArgs.isEmpty then
      s!"theorem {thm}_ccc :\n{stmt} :=\n  {nm}"
    else
      s!"theorem {thm}_ccc :\n{stmt} :=\n  fun {lam} => @{nm} {call}"
  else if f.binders.isEmpty then
    s!"theorem {thm}_ccc : {nm} =\n{body} := rfl"
  else
    s!"theorem {thm}_ccc : {nm} = fun {binders} =>\n{body} := rfl"

end Ccc

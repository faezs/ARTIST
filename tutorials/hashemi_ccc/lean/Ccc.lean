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
  | un (op : String) (a : Nat)    -- neg sqrt sin cos tan arctan abs not
  | bin (op : String) (a b : Nat) -- + - * / min max < <= > >= == != && ||
  | pow (a : Nat) (n : Nat)       -- a literal natural exponent, kept for the Lean round trip
  | ite (c a b : Nat)
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
  | .bin op _ _ => op ∈ ["<", "<=", ">", ">=", "==", "!=", "&&", "||"]
  | .ite _ a _ => g.isBool a
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
  if !s then toString (m * 10 ^ e)
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
  [`TandoorSphere.sag, `TandoorSphere.sphereR, `TandoorMount.spot, `TandoorMount.spotParaxial]

def isRealTy (t : Expr) : Bool := t.isConstOf `Real

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

mutual

partial def translate (root : Name) (e : Expr) : TM Val := do
  match e with
  | .mdata _ e => translate root e
  | .fvar id =>
    match (← get).env[id]? with
    | some v => pure v
    | none => throwError "unbound variable {e}"
  | .letE _ _ v b _ => translate root (b.instantiate1 v)
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
  -- `∀ i : Fin n, P i`, unrolled into a conjunction
  let df := dom.getAppFn
  let dargs := dom.getAppArgs
  unless df.isConstOf ``Fin && dargs.size == 1 do
    throwError "a ∀ over {dom} cannot be compiled"
  let some n := natLit? dargs[0]! | throwError "a ∀ over Fin with a non-literal bound"
  let mut acc : Option Nat := none
  for j in [0:n] do
    let bj ← boolean (← translate root (body.instantiate1 (finLit n j)))
    acc := some (← match acc with
      | none => pure bj
      | some a => emit (.bin "&&" a bj))
  match acc with
  | some a => pure (.b a)
  | none => .b <$> emit (.bconst true)

partial def binop (root : Name) (op : String) (a b : Expr) : TM Val := do
  let x ← scalar (← translate root a)
  let y ← scalar (← translate root b)
  .s <$> emit (.bin op x y)

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
  | .const n _ =>
    let k := args.size
    match n, k with
    | ``HAdd.hAdd, 6 => binop root "+" args[4]! args[5]!
    | ``HSub.hSub, 6 => binop root "-" args[4]! args[5]!
    | ``HMul.hMul, 6 => binop root "*" args[4]! args[5]!
    | ``HDiv.hDiv, 6 => binop root "/" args[4]! args[5]!
    | ``Neg.neg, 3 => unop root "neg" args[2]!
    | ``HPow.hPow, 6 => do
      let some m := natLit? args[5]! | throwError "a power with a non-literal exponent"
      let x ← scalar (← translate root args[4]!)
      .s <$> emit (.pow x m)
    | `Real.sqrt, 1 => unop root "sqrt" args[0]!
    | `Real.sin, 1 => unop root "sin" args[0]!
    | `Real.cos, 1 => unop root "cos" args[0]!
    | `Real.tan, 1 => unop root "tan" args[0]!
    | `Real.arctan, 1 => unop root "arctan" args[0]!
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
    | `Matrix.vecCons, 5 => do
      let v ← translateApp root (mkAppN f (args.extract 0 4))
      applyArgs v #[args[4]!]
    | `Matrix.vecEmpty, 1 => pure (.vec #[])
    | ``ite, 5 => do
      let c ← boolean (← translate root args[1]!)
      let a ← translate root args[3]!
      let b ← translate root args[4]!
      match a, b with
      | Val.s x, Val.s y => .s <$> emit (.ite c x y)
      | Val.b x, Val.b y => .b <$> emit (.ite c x y)
      | _, _ => throwError "an if with branches of shape {a.shape} and {b.shape}"
    | ``LT.lt, 4 => cmpop root "<" args[2]! args[3]!
    | ``LE.le, 4 => cmpop root "<=" args[2]! args[3]!
    | ``GT.gt, 4 => cmpop root ">" args[2]! args[3]!
    | ``GE.ge, 4 => cmpop root ">=" args[2]! args[3]!
    | ``Eq, 3 => do
      match ← translate root args[1]!, ← translate root args[2]! with
      | Val.s x, Val.s y => .b <$> emit (.bin "==" x y)
      | Val.b x, Val.b y => .b <$> emit (.bin "==" x y)
      | a, b => throwError "an equation between a {a.shape} and a {b.shape}"
    | ``Ne, 3 => cmpop root "!=" args[1]! args[2]!
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

/-- compile one definition (or a closed theorem statement) -/
def compileDef (root : Name) (n : Name) : MetaM (Except String Fun) := do
  let ci ← getConstInfo n
  try
    match ci with
    | .thmInfo _ =>
      -- a theorem: compile its statement, with Fin-binders unrolled and everything else refused
      let ty ← instantiateMVars ci.type
      let (v, st) ← (translate root ty).run {}
      match v with
      | Val.b _ => pure (Except.ok (Fun.mk n st.inputs #[] v st.g true true))
      | _ => pure (Except.error "the statement is not a proposition over the vocabulary")
    | .defnInfo d =>
      let v ← instantiateMVars d.value
      let ty ← instantiateMVars d.type
      let isP ← forallTelescope ty fun _ b => pure b.isProp
      let (out, st) ← lambdaTelescope v fun xs body => do
        let act : TM Val := do
          for x in xs do
            let userName := (← x.fvarId!.getUserName).toString
            let leanName := if userName.any (· == '✝') || userName == "_" then "x" ++ toString xs.size else userName
            let name := sanitize leanName
            let t ← inferType x
            let tyStr ← ppExpr t
            let val ← bindInput root name leanName t
            modify fun st => { st with env := st.env.insert x.fvarId! val,
                                       binders := st.binders.push (leanName, toString tyStr) }
          translate root body
        act.run {}
      pure (Except.ok (Fun.mk n st.inputs st.binders out st.g isP false))
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
          | "arctan" => s!"hk_atan({av})" | "exp" => s!"hk_exp({av})" | "log" => s!"hk_log({av})"
          | "abs" => s!"hk_fabs({av})" | o => s!"/* ? {o} */ {av}")
      | .bin op a b =>
        some (match op with
          | "min" => s!"hk_min(t{a}, t{b})" | "max" => s!"hk_max(t{a}, t{b})"
          | "==" => if g.isBool a then s!"(t{a} == t{b})" else s!"hk_eq(t{a}, t{b})"
          | "!=" => if g.isBool a then s!"(t{a} != t{b})" else s!"(!hk_eq(t{a}, t{b}))"
          | o => s!"(t{a} {o} t{b})")
      | .pow a n =>
        some (if n == 0 then "HK_LIT(1)" else " * ".intercalate (List.replicate n s!"t{a}"))
      | .ite c a b => some s!"(t{c} ? t{a} : t{b})"
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
    lines := lines.push s!"  n{i} [label=\"{label}\", shape={shape}];"
    match g.nodes[i]! with
    | .un _ a => lines := lines.push s!"  n{a} -> n{i};"
    | .bin _ a b => lines := lines.push s!"  n{a} -> n{i}; n{b} -> n{i};"
    | .pow a _ => lines := lines.push s!"  n{a} -> n{i};"
    | .ite c a b => lines := lines.push s!"  n{c} -> n{i} [label=c]; n{a} -> n{i} [label=1]; n{b} -> n{i} [label=0];"
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
    | "exp" => if real then s!"(Real.exp {r a})" else s!"(Float.exp {r a})"
    | "log" => if real then s!"(Real.log {r a})" else s!"(Float.log {r a})"
    | "abs" => if real then s!"|{r a}|" else s!"(Float.abs {r a})"
    | o => s!"?{o}"
  | .bin op a b =>
    match op with
    | "min" => s!"(min {r a} {r b})"
    | "max" => s!"(max {r a} {r b})"
    | "==" => if real then s!"({r a} = {r b})" else if g.isBool a then s!"({r a} == {r b})" else s!"(feq {r a} {r b})"
    | "!=" => if real then s!"({r a} ≠ {r b})" else if g.isBool a then s!"({r a} != {r b})" else s!"(!(feq {r a} {r b}))"
    | "&&" => if real then s!"({r a} ∧ {r b})" else s!"({r a} && {r b})"
    | "||" => if real then s!"({r a} ∨ {r b})" else s!"({r a} || {r b})"
    | "<=" => if real then s!"({r a} ≤ {r b})" else s!"({r a} <= {r b})"
    | ">=" => if real then s!"({r a} ≥ {r b})" else s!"({r a} >= {r b})"
    | o => s!"({r a} {o} {r b})"
  | .pow a n => s!"({r a} ^ {n})"
  | .ite c a b => s!"(if {r c} then {r a} else {r b})"

partial def leanVal (g : Graph) (real : Bool) : Val → String
  | Val.s i => leanExpr g real i
  | Val.b i => leanExpr g real i
  | .pair a b => s!"({leanVal g real a}, {leanVal g real b})"
  | .vec xs => "![" ++ ", ".intercalate (xs.toList.map (leanVal g real)) ++ "]"
  | .struct n fs => "{ " ++ ", ".intercalate (fs.toList.map fun (f, v) => s!"{f} := {leanVal g real v}") ++ s!" : {n} }"

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
          | "arctan" => s!"np.arctan({av})" | "exp" => s!"np.exp({av})" | "log" => s!"np.log({av})"
          | "abs" => s!"np.abs({av})" | o => s!"None  # ? {o}")
      | .bin op a b =>
        some (match op with
          | "min" => s!"np.minimum(t{a}, t{b})" | "max" => s!"np.maximum(t{a}, t{b})"
          | "==" => if g.isBool a then s!"(t{a} == t{b})" else s!"hk_eq(t{a}, t{b})"
          | "!=" => if g.isBool a then s!"(t{a} != t{b})" else s!"np.logical_not(hk_eq(t{a}, t{b}))"
          | "&&" => s!"np.logical_and(t{a}, t{b})" | "||" => s!"np.logical_or(t{a}, t{b})"
          | o => s!"(t{a} {o} t{b})")
      | .pow a n => some s!"(t{a} ** {n})"
      | .ite c a b => some s!"np.where(t{c}, t{a}, t{b})"
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

/-- the round trip: `theorem f_ccc : f = fun binders => printed := by rfl` -/
def printRoundTrip (f : Fun) : String :=
  let binders := " ".intercalate (f.binders.toList.map fun (nm, ty) => s!"({nm} : {ty})")
  let body := leanVal f.graph true f.output
  if f.binders.isEmpty then
    s!"theorem {f.name.getString!}_ccc : {f.name.getString!} = {body} := rfl"
  else
    s!"theorem {f.name.getString!}_ccc : {f.name.getString!} = fun {binders} => {body} := rfl"

end Ccc

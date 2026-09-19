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
  /-- a real that arrived as `((n : ℕ) : ℝ)`.  Hash-consed apart from the plain literal, because
  `Nat.cast_zero` is PROPOSITIONAL: the runtime printers cannot tell the two apart (both are
  `0.0`), but the round trip must print the cast it read, or the column is only propositionally
  equal to the definition and no `rfl` closes it. -/
  | natLit (s : String)
  | bconst (b : Bool)
  | pi
  | un (op : String) (a : Nat)    -- neg sqrt sin cos tan arctan arccos arcsin abs not
  | bin (op : String) (a b : Nat) -- + - * / min max < <= > >= == != && || ->
  | pow (a : Nat) (n : Nat)       -- a literal natural exponent, kept for the Lean round trip
  | ite (c a b : Nat)
  | iteC (c a b : Nat)            -- an `if` whose Decidable instance is `Classical.propDecidable` (an opaque Prop)
  | rayIn (base : String) (k : Nat)  -- the current ray's k-th entry of the ray table `base` (ray-level)
  | sum (P : Nat) (a : Nat)       -- the sum of node `a` over the P rays (the reduction; agent-level)
  /-- an application of a sub-morphism the caller does NOT unfold: `fn` is its Lean name, `tmpl`
  the printed application with a `%` where each of `args` goes (so a table or a vector argument
  prints as itself), `col` the column of its output vector (`isVec`: it has one).  A functor
  preserves composition, so the composite's round trip is stated against these calls; INLINING
  one is what the flat compilation of the same expression already is, which is why the kernel
  printers refuse this node - they are given the flat graph. -/
  | call (fn : String) (tmpl : String) (args : Array Nat) (col : Nat) (isVec : Bool)
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

/-- a `.call` node (it prints as the application, not as a `v` binding of its own) -/
def Node.isCall : Node → Bool
  | .call .. => true
  | _ => false

/-- the operands of a node -/
def Node.deps : Node → Array Nat
  | .un _ a => #[a]
  | .bin _ a b => #[a, b]
  | .pow a _ => #[a]
  | .ite c a b => #[c, a, b]
  | .iteC c a b => #[c, a, b]
  | .sum _ a => #[a]
  | .call _ _ args _ _ => args
  | _ => #[]

/-! ## The reduction layer

A graph with `∑ i : Fin P` has three layers: the nodes before the reduction (agent-level), the
ray-level nodes (those reading a ray table's row - one thread per ray in the megakernel, a loop
in C), and the nodes after a sum. The rays are the tensor power of one morphism; the sum is the
monoidal reduction; everything else is composition. -/

structure Layers where
  ray : Array Bool
  post : Array Bool
  sums : Array Nat
  P : Nat
  err : String

def layers (g : Graph) : Layers := Id.run do
  let n := g.nodes.size
  let mut ray := Array.replicate n false
  let mut post := Array.replicate n false
  let mut sums : Array Nat := #[]
  let mut P := 0
  let mut err := ""
  for i in [0:n] do
    match g.nodes[i]! with
    | .rayIn .. => ray := ray.set! i true
    | .sum p _ =>
      sums := sums.push i
      if P != 0 && P != p then err := "sums over different ray counts"
      P := p
      post := post.set! i true
    | node =>
      let r := node.deps.any (ray[·]!)
      let q := node.deps.any (post[·]!)
      if r && q then err := "a ray-level node depends on a reduction (one layer only)"
      ray := ray.set! i r
      post := post.set! i q
  return { ray, post, sums, P, err }

/-- a value with shape: reals, booleans, pairs, vectors, structures -/
inductive Val where
  | s (id : Nat)
  | b (id : Nat)
  | pair (a b : Val)
  | vec (xs : Array Val)
  | struct (name : Name) (fields : Array (Name × Val))
  | rayIdx                        -- the bound index of a `∑ i : Fin P` while its body is translated
  deriving Repr, Inhabited

partial def Val.flatten : Val → Array Nat
  | Val.s i => #[i]
  | Val.b i => #[i]
  | .rayIdx => #[]
  | .pair x y => x.flatten ++ y.flatten
  | .vec xs => xs.foldl (fun acc v => acc ++ v.flatten) #[]
  | .struct _ fs => fs.foldl (fun acc (_, v) => acc ++ v.flatten) #[]

partial def Val.shape : Val → String
  | Val.s _ => "real"
  | Val.b _ => "bool"
  | .rayIdx => "ray index"
  | .pair x y => s!"({x.shape}, {y.shape})"
  | .vec xs => s!"vec{xs.size}[{if h : 0 < xs.size then (xs[0]'h).shape else "?"}]"
  | .struct n _ => s!"{n}"

/-! ## The translator -/

structure TState where
  g : Graph := {}
  env : Std.HashMap FVarId Val := {}
  inputs : Array (String × Nat) := #[]      -- flattened scalar inputs, in binder order
  binders : Array (String × String) := #[]  -- (binder name, pretty type) for the Lean printers
  /-- ray tables: a binder `Fin P → Fin m → ℝ` (or `Fin P → ℝ`, P ≥ 16) is one buffer, (base, P, m) -/
  arrays : Array (String × Nat × Nat) := #[]
  /-- a ray table's entry read at a literal index: input node ↦ (base, j, k) -/
  arrayScalar : Std.HashMap Nat (String × Nat × Nat) := {}
  /-- the first flattened node of each ray table ↦ (base, P, m), to recognise a symbolic index -/
  vecBase : Std.HashMap Nat (String × Nat × Nat) := {}
  /-- inside a `∑ i : Fin P`: the P -/
  inSum : Option Nat := none
  /-- sub-morphisms NOT to unfold: name ↦ how many columns its output vector has (0: a scalar).
  An application of one of these becomes a `.call` node instead of its inlined graph. -/
  noUnfold : Std.HashMap Name Nat := {}
  /-- keep a `((n : ℕ) : ℝ)` as a cast (`.natLit`) instead of evaluating it to a real literal.
  The round trip needs it (`Nat.cast_zero` is propositional, so the twin must print the cast the
  definition wrote); a kernel does not, and switching it off there keeps every generated file
  byte-identical to what it was before this node existed. -/
  keepCasts : Bool := false

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

/-- the name a `.call` prints: the Lean short name, which is what the round trip's namespace has -/
def sanitizeCall (n : Name) : String := n.getString!

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

/-- how many binders a definition takes before its output vector (the first `Fin n` binder) -/
partial def dataArity (ty : Expr) : MetaM Nat := do
  let ty ← whnfR ty
  match ty with
  | .forallE n d b bi =>
    if d.getAppFn.isConstOf ``Fin then return 0
    withLocalDecl n bi d fun x => do return 1 + (← dataArity (b.instantiate1 x))
  | _ => return 0

/-- the shape of `v`, every leaf the node `z` -/
partial def constVal (z : Nat) : Val → TM Val
  | Val.s _ => pure (.s z)
  | Val.b _ => throwError "a boolean where a real was expected"
  | .pair a b => do pure (.pair (← constVal z a) (← constVal z b))
  | .vec xs => do pure (.vec (← xs.mapM (constVal z)))
  | .struct n fs => do pure (.struct n (← fs.mapM fun (f, v) => do pure (f, ← constVal z v)))
  | .rayIdx => throwError "a ray index where a value was expected"

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
  | .lam _ dom body _ =>
    -- a function out of `Fin n` is a product: the body at each literal index, as a vector
    let df := dom.getAppFn
    if df.isConstOf ``Fin && dom.getAppArgs.size == 1 then
      if let some n := natLit? dom.getAppArgs[0]! then
        let mut xs := #[]
        for j in [0:n] do
          xs := xs.push (← translate root (body.instantiate1 (finLit n j)))
        return .vec xs
    throwError "a lambda where a value was expected: {e}"
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
      match natLit? a with
      | some j =>
        unless j < xs.size do throwError "index {j} out of range {xs.size}"
        v := xs[j]!
      | none =>
        -- the index of a `∑ i : Fin P` on a ray table: the current ray's row
        let iv ← translate `_ a
        match iv with
        | .rayIdx =>
          let st ← get
          let some (base, P, m) := (do let x0 ← xs[0]?; let f0 ← x0.flatten[0]?; st.vecBase[f0]?)
            | throwError "a symbolic index into a vector that is not a ray table"
          unless st.inSum == some P do throwError "the ray index of a ∑ over {st.inSum} on a table of {P} rays"
          if m == 0 then v := .s (← emit (.rayIn base 0))
          else
            let mut ys := #[]
            for k in [0:m] do ys := ys.push (.s (← emit (.rayIn base k)))
            v := .vec ys
        | w => throwError "a vector indexed by a {w.shape}"
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
    | `Finset.sum, 5 => do
      -- `∑ i : Fin P, body i`: the body once, against the ray index; the reduction as one node
      let some P := (if args[0]!.getAppFn.isConstOf ``Fin then natLit? args[0]!.getAppArgs[0]! else none)
        | throwError "a ∑ over {args[0]!} cannot be compiled (only Fin P with a literal P)"
      unless args[3]!.getAppFn.isConstOf `Finset.univ do throwError "a ∑ over a finset that is not univ"
      let st0 ← get
      -- the ray reduction: the body once against the ray index, if it reads a table's row
      let attempt : TM (Option Val) := do
        if st0.inSum.isSome then return none
        try
          let (r, st') ← withLocalDeclD `i args[0]! fun i => do
            (translate root (mkApp args[4]! i).headBeta).run
              { st0 with env := st0.env.insert i.fvarId! .rayIdx, inSum := some P }
          -- does the summand depend on a ray table's row? (else it is a small contraction: unroll).
          -- Judged on the graph, not on the nodes just emitted: a second sum over the same rays
          -- hash-conses onto the first's nodes and emits nothing new
          let L := layers st'.g
          let reads := r.flatten.any fun a => L.ray[a]!
          if !reads then return none
          set { st' with inSum := none }
          match r with
          | .s a => return some (.s (← emit (.sum P a)))
          | .vec xs =>
            let mut ys := #[]
            for x in xs do
              match x with
              | .s a => ys := ys.push (.s (← emit (.sum P a)))
              | w => throwError "a ∑ of a {w.shape}"
            return some (.vec ys)
          | w => throwError "a ∑ of a {w.shape}"
        catch _ => return none
      match ← attempt with
      | some v => pure v
      | none =>
        -- unrolled: the body at each literal index, added up right-nested with a trailing zero,
        -- `f 0 + (f 1 + (… + (f (P-1) + 0)))` - the shape `Finset.sum univ f` unfolds to over
        -- `List.finRange P`, so the round trip is definitional
        set st0
        let mut terms : Array Val := #[]
        for j in [0:P] do
          terms := terms.push (← translate root (mkApp args[4]! (finLit P j)).headBeta)
        let zero ← emit (.lit "0")
        let mut acc : Val := ← (if terms.isEmpty then pure (.s zero) else constVal zero terms[0]!)
        for j in [0:P] do
          acc := ← zipVal "+" terms[P - 1 - j]! acc
        pure acc
    | `Real.sqrt, 1 => unop root "sqrt" args[0]!
    | `Real.sin, 1 => unop root "sin" args[0]!
    | `Real.cos, 1 => unop root "cos" args[0]!
    | `Real.tan, 1 => unop root "tan" args[0]!
    | `Real.arctan, 1 => unop root "arctan" args[0]!
    | `Real.arccos, 1 => unop root "arccos" args[0]!
    | `Real.arcsin, 1 => unop root "arcsin" args[0]!
    | `Real.exp, 1 => unop root "exp" args[0]!
    | `Real.log, 1 => unop root "log" args[0]!
    | `Real.sigmoid, 1 => unop root "sigmoid" args[0]!
    | `Real.tanh, 1 => unop root "tanh" args[0]!
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
      if (← get).keepCasts then .s <$> emit (.natLit (toString m))
      else .s <$> emit (.lit (toString m))
    | ``Int.cast, 3 => do
      -- `((⌊x⌋ : ℤ) : ℝ)`: the floor as a real (the facet grid's index)
      let inner := args[2]!.getAppFn
      let iargs := args[2]!.getAppArgs
      if inner.isConstOf `Int.floor && iargs.size ≥ 1 then unop root "floor" iargs.back!
      else throwError "a cast of a non-floor integer"
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

/-- a value as the text of an argument, with a `%` where each node of the result goes.  A table
binder prints as its own name (it is one buffer, and the Lean binder carries that name), a small
vector as `![…]`. -/
partial def valTmpl : Val → TM (String × Array Nat)
  | .s i => pure ("%", #[i])
  | .b i => pure ("%", #[i])
  | .pair a b => do
    let (x, xs) ← valTmpl a; let (y, ys) ← valTmpl b
    pure (s!"({x}, {y})", xs ++ ys)
  | .vec xs => do
    let st ← get
    let tbl := do let x0 ← xs[0]?; let f0 ← x0.flatten[0]?; st.vecBase[f0]?
    match tbl with
    | some (base, _, _) => pure (base, #[])
    | none =>
      let mut parts : Array String := #[]
      let mut ns : Array Nat := #[]
      for x in xs do
        let (t, u) ← valTmpl x
        parts := parts.push t; ns := ns ++ u
      pure ("![" ++ ", ".intercalate parts.toList ++ "]", ns)
  | v => throwError "a {v.shape} as the argument of an opaque sub-morphism"

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
    -- a sub-morphism the caller keeps opaque: one `.call` node per output column
    if let some cols := (← get).noUnfold[n]? then
      let ar ← dataArity ci.type
      let k := min ar args.size
      let mut tmpl := sanitizeCall n
      let mut nodes : Array Nat := #[]
      let mut printable := true
      for a in args.extract 0 k do
        let av ← translate root a
        -- a call can stay opaque only if every argument prints as the definition writes it: a
        -- vector argument must be a table binder (it prints as its name).  `coilProfile` takes
        -- the bins as a FUNCTION and the definition passes a lambda, which the twin could only
        -- print as `![…]` - not the same term - so that call is inlined instead.
        match av with
        | .s _ | .b _ => pure ()
        | .vec xs =>
          let st ← get
          let tbl := do let x0 ← xs[0]?; let f0 ← x0.flatten[0]?; st.vecBase[f0]?
          if tbl.isNone then printable := false
        | _ => printable := false
        if !printable then continue
        let (txt, ns) ← valTmpl av
        tmpl := tmpl ++ " " ++ txt
        nodes := nodes ++ ns
      if printable then
        let v ← if cols == 0 then (do pure (Val.s (← emit (.call (sanitizeCall n) tmpl nodes 0 false))))
          else (do
            let mut xs : Array Val := #[]
            for c in [0:cols] do
              xs := xs.push (Val.s (← emit (.call (sanitizeCall n) tmpl nodes c true)))
            pure (Val.vec xs))
        return ← applyArgs v (args.extract k args.size)
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
        -- a ray table: `Fin P → Fin m → ℝ`, or `Fin P → ℝ` with P ≥ 16 - one buffer, read at a
        -- literal index or at the index of a `∑ i : Fin P` (a ray-level read)
        let cod' ← whnfR cod
        let m? : Option Nat := if isRealTy cod' then (if n ≥ 16 then some 0 else none) else
          match cod' with
          | .forallE _ d2 c2 _ =>
            if d2.getAppFn.isConstOf ``Fin && isRealTy c2 then natLit? d2.getAppArgs[0]! else none
          | _ => none
        if let some m := m? then
          let mut xs := #[]
          let mut first : Option Nat := none
          for j in [0:n] do
            if m == 0 then
              let i ← emit (.input s!"{name}_{j}" s!"({lean} {j})")
              modify fun st => { st with arrayScalar := st.arrayScalar.insert i (name, j, 0) }
              if first.isNone then first := some i
              xs := xs.push (.s i)
            else
              let mut ys := #[]
              for k in [0:m] do
                let i ← emit (.input s!"{name}_{j}_{k}" s!"({lean} {j} {k})")
                modify fun st => { st with arrayScalar := st.arrayScalar.insert i (name, j, k) }
                if first.isNone then first := some i
                ys := ys.push (.s i)
              xs := xs.push (.vec ys)
          modify fun st => { st with arrays := st.arrays.push (name, n, m),
                                     vecBase := st.vecBase.insert first.get! (name, n, m) }
          return .vec xs
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
  /-- ray tables (base, P, m) -/
  arrays : Array (String × Nat × Nat) := #[]
  /-- a ray table's entry at a literal index: input node ↦ (base, j, k) -/
  arrayScalar : Std.HashMap Nat (String × Nat × Nat) := {}
  /-- tables shared by every agent (a policy's weights): no per-agent offset, no agent axis -/
  shared : Array String := #[]

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

/-- compile one definition (or a closed theorem statement).  `noUnfold` names sub-morphisms to
keep opaque (with the number of columns of each one's output vector, 0 for a scalar): their
applications become `.call` nodes, so the graph is the composite AS A COMPOSITE.  With the
default (nothing opaque) the graph is what it always was - the same expression with those calls
inlined - which is what every kernel printer is given. -/
def compileDef (root : Name) (n : Name) (noUnfold : List (Name × Nat) := [])
    (keepCasts : Bool := false) : MetaM (Except String Fun) := do
  let nu : Std.HashMap Name Nat := noUnfold.foldl (fun m (k, v) => m.insert k v) {}
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
        act.run { noUnfold := nu, keepCasts := keepCasts }
      let (v, order, nh) := out
      pure (Except.ok { name := n, inputs := st.inputs, binders := st.binders, output := v,
                        graph := st.g, isProp := true, isTheorem := true, thmArgs := order, nHyps := nh,
                        arrays := st.arrays, arrayScalar := st.arrayScalar })
    | .defnInfo d =>
      let v ← instantiateMVars d.value
      let ty ← instantiateMVars d.type
      let isP ← forallTelescope ty fun _ b => pure b.isProp
      let (out, st) ← lambdaTelescope v fun xs body => do
        let act : TM Val := do
          for x in xs do
            let _ ← bindBinder root x xs.size
          translate root body
        act.run { noUnfold := nu, keepCasts := keepCasts }
      pure (Except.ok { name := n, inputs := st.inputs, binders := st.binders, output := out,
                        graph := st.g, isProp := isP, arrays := st.arrays, arrayScalar := st.arrayScalar })
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
    for d in g.nodes[i]!.deps do live := live.insert d
  return live

/-- the width of a ray table -/
def Fun.tableM (f : Fun) (base : String) : Nat :=
  match f.arrays.find? (·.1 == base) with
  | some (_, _, m) => m
  | none => 0

/-- a ray table read: at a literal row `j` or at the ray index `ridx` -/
def Fun.tableRead (f : Fun) (base : String) (row : String) (k : Nat) : String :=
  let m := f.tableM base
  if m == 0 then s!"{base}[{row}]" else s!"{base}[({row}) * {m} + {k}]"

/-- the C right-hand side of a node. Scalar inputs are given by `inputRef`; ray reads use the
row `ridx`; a `sum` is handled by the phases and has none -/
def cRhs (f : Fun) (inputRef : Nat → String) (ridx : String) (i : Nat) : Option String :=
  let g := f.graph
  let t := fun (j : Nat) => s!"t{j}"
  match g.nodes[i]! with
  | .input _ _ =>
    match f.arrayScalar[i]? with
    | some (b, j, k) => some (f.tableRead b (toString j) k)
    | none => some (inputRef i)
  | .rayIn b k => some (f.tableRead b ridx k)
  | .sum .. => none
  | .lit s => some s!"HK_LIT({s})"
  | .natLit s => some s!"HK_LIT({s})"
  | .bconst b => some (if b then "true" else "false")
  | .pi => some "HK_PI"
  | .un op a =>
    let av := t a
    some (match op with
      | "neg" => s!"(-{av})" | "not" => s!"(!{av})" | "sqrt" => s!"hk_sqrt({av})"
      | "sin" => s!"hk_sin({av})" | "cos" => s!"hk_cos({av})" | "tan" => s!"hk_tan({av})"
      | "arctan" => s!"hk_atan({av})" | "arccos" => s!"hk_acos({av})" | "arcsin" => s!"hk_asin({av})"
      | "exp" => s!"hk_exp({av})" | "log" => s!"hk_log({av})"
      | "abs" => s!"hk_fabs({av})" | "floor" => s!"hk_floor({av})" | "sigmoid" => s!"hk_sigmoid({av})"
      | "tanh" => s!"hk_tanh({av})"
      | o => s!"/* ? {o} */ {av}")
  | .bin op a b =>
    some (match op with
      | "min" => s!"hk_min({t a}, {t b})" | "max" => s!"hk_max({t a}, {t b})"
      | "==" => if g.isBool a then s!"({t a} == {t b})" else s!"hk_eq({t a}, {t b})"
      | "!=" => if g.isBool a then s!"({t a} != {t b})" else s!"(!hk_eq({t a}, {t b}))"
      | "->" => s!"(!{t a} || {t b})"
      | o => s!"({t a} {o} {t b})")
  | .pow a n => some (if n == 0 then "HK_LIT(1)" else " * ".intercalate (List.replicate n (t a)))
  | .ite c a b => some s!"({t c} ? {t a} : {t b})"
  | .iteC c a b => some s!"({t c} ? {t a} : {t b})"
  | .call fn _ _ c _ => some s!"#error \"the graph of {fn} column {c} is a .call node: a kernel is printed from the FLAT compilation\""

/-- the tangent of a real node (`d{j}` for operands, `HK_LIT(0)` for booleans and ray reads);
`dxRef` names a scalar input's tangent -/
def cDRhs (f : Fun) (dxRef : Nat → String) (i : Nat) : Option String :=
  let g := f.graph
  if g.isBool i then none else
  let t := fun (j : Nat) => s!"t{j}"
  let d := fun (j : Nat) => if g.isBool j then "HK_LIT(0)" else s!"d{j}"
  match g.nodes[i]! with
  | .input _ _ => some (if f.arrayScalar.contains i then "HK_LIT(0)" else dxRef i)
  | .rayIn .. => some "HK_LIT(0)"
  | .sum .. => none
  | .lit _ => some "HK_LIT(0)"
  | .natLit _ => some "HK_LIT(0)"
  | .pi => some "HK_LIT(0)"
  | .bconst _ => none
  | .un op a =>
    let av := t a
    let da := d a
    some (match op with
      | "neg" => s!"(-{da})"
      | "sqrt" => s!"({da} / (HK_LIT(2) * {t i}))"
      | "sin" => s!"(hk_cos({av}) * {da})"
      | "cos" => s!"(-hk_sin({av}) * {da})"
      | "tan" => s!"({da} * (HK_LIT(1) + {t i} * {t i}))"
      | "arctan" => s!"({da} / (HK_LIT(1) + {av} * {av}))"
      | "arccos" => s!"(-{da} / hk_sqrt(HK_LIT(1) - {av} * {av}))"
      | "arcsin" => s!"({da} / hk_sqrt(HK_LIT(1) - {av} * {av}))"
      | "exp" => s!"({t i} * {da})"
      | "log" => s!"({da} / {av})"
      | "abs" => s!"({av} < HK_LIT(0) ? -{da} : {da})"
      | "floor" => "HK_LIT(0)"
      | "sigmoid" => s!"({t i} * (HK_LIT(1) - {t i}) * {da})"
      | "tanh" => s!"((HK_LIT(1) - {t i} * {t i}) * {da})"
      | _ => "HK_LIT(0)")
  | .bin op a b =>
    some (match op with
      | "+" => s!"({d a} + {d b})"
      | "-" => s!"({d a} - {d b})"
      | "*" => s!"({d a} * {t b} + {t a} * {d b})"
      | "/" => s!"(({d a} * {t b} - {t a} * {d b}) / ({t b} * {t b}))"
      | "min" => s!"({t a} <= {t b} ? {d a} : {d b})"
      | "max" => s!"({t a} >= {t b} ? {d a} : {d b})"
      | _ => "HK_LIT(0)")
  | .pow a n =>
    some (if n == 0 then "HK_LIT(0)" else if n == 1 then d a
          else s!"(HK_LIT({n}) * {" * ".intercalate (List.replicate (n - 1) (t a))} * {d a})")
  | .ite c a b => some s!"({t c} ? {d a} : {d b})"
  | .iteC c a b => some s!"({t c} ? {d a} : {d b})"
  | .call fn _ _ c _ => some s!"#error \"{fn}[{c}] is a .call node: kernels are printed from the FLAT compilation\""

/-- the box statement of a node (`lo{j}, hi{j}, L{j}` for operands); `boxRef` gives a scalar
input's `(lo, hi, sc)` reads; a ray read is a point with no scale -/
def cBoxStmt (f : Fun) (boxRef : Nat → String × String × String) (ridx : String) (i : Nat) : Option String :=
  let g := f.graph
  let tri := fun (j : Nat) => s!"lo{j}, hi{j}"
  let tr := fun (j : Nat) => s!"lo{j}, hi{j}, L{j}"
  let outp := fun (j : Nat) => s!"&lo{j}, &hi{j}, &L{j}"
  let outb := fun (j : Nat) => s!"&lo{j}, &hi{j}"
  match g.nodes[i]! with
  | .input _ _ =>
    match f.arrayScalar[i]? with
    | some (b, j, k) => let v := f.tableRead b (toString j) k; some s!"lo{i} = {v}; hi{i} = {v}; L{i} = HK_LIT(0);"
    | none => let (lo, hi, sc) := boxRef i; some s!"lo{i} = {lo}; hi{i} = {hi}; L{i} = {sc};"
  | .rayIn b k => let v := f.tableRead b ridx k; some s!"lo{i} = {v}; hi{i} = {v}; L{i} = HK_LIT(0);"
  | .sum .. => none
  | .lit s => some s!"lo{i} = HK_LIT({s}); hi{i} = HK_LIT({s}); L{i} = HK_LIT(0);"
  | .natLit s => some s!"lo{i} = HK_LIT({s}); hi{i} = HK_LIT({s}); L{i} = HK_LIT(0);"
  | .bconst b => let v := if b then "1" else "0"; some s!"lo{i} = HK_LIT({v}); hi{i} = HK_LIT({v}); L{i} = HK_LIT(0);"
  | .pi => some s!"lo{i} = HK_PI; hi{i} = HK_PI; L{i} = HK_LIT(0);"
  | .un op a =>
    some (match op with
    | "neg" => s!"hk_bx_neg({tr a}, {outp i});"
    | "not" => s!"hk_bx_not({tri a}, {outb i}); L{i} = HK_LIT(0);"
    | "sqrt" => s!"hk_bx_sqrt({tr a}, {outp i});"
    | "sin" => s!"hk_bx_trig(1, {tr a}, {outp i});"
    | "cos" => s!"hk_bx_trig(0, {tr a}, {outp i});"
    | "tan" => s!"hk_bx_tan({tr a}, {outp i});"
    | "arctan" => s!"hk_bx_atan({tr a}, {outp i});"
    | "arccos" => s!"hk_bx_acos({tr a}, {outp i});"
    | "arcsin" => s!"hk_bx_asin({tr a}, {outp i});"
    | "exp" => s!"hk_bx_exp({tr a}, {outp i});"
    | "log" => s!"hk_bx_log({tr a}, {outp i});"
    | "abs" => s!"hk_bx_abs({tr a}, {outp i});"
    | "floor" => s!"hk_bx_floor({tr a}, {outp i});"
    | "sigmoid" => s!"hk_bx_sigmoid({tr a}, {outp i});"
    | "tanh" => s!"hk_bx_tanh({tr a}, {outp i});"
    | o => s!"/* ? {o} */ lo{i} = -HK_INF; hi{i} = HK_INF; L{i} = HK_INF;")
  | .bin op a b =>
    some (match op with
    | "+" => s!"hk_bx_add({tr a}, {tr b}, {outp i});"
    | "-" => s!"hk_bx_sub({tr a}, {tr b}, {outp i});"
    | "*" => s!"hk_bx_mul({tr a}, {tr b}, {outp i});"
    | "/" => s!"hk_bx_div({tr a}, {tr b}, {outp i});"
    | "min" => s!"hk_bx_min({tr a}, {tr b}, {outp i});"
    | "max" => s!"hk_bx_max({tr a}, {tr b}, {outp i});"
    | "<" => s!"hk_bx_lt({tri a}, {tri b}, {outb i}); L{i} = HK_LIT(0);"
    | "<=" => s!"hk_bx_le({tri a}, {tri b}, {outb i}); L{i} = HK_LIT(0);"
    | ">" => s!"hk_bx_lt({tri b}, {tri a}, {outb i}); L{i} = HK_LIT(0);"
    | ">=" => s!"hk_bx_le({tri b}, {tri a}, {outb i}); L{i} = HK_LIT(0);"
    | "==" => s!"hk_bx_eq({tri a}, {tri b}, {outb i}); L{i} = HK_LIT(0);"
    | "!=" => s!"\{ hk_real e0, e1; hk_bx_eq({tri a}, {tri b}, &e0, &e1); hk_bx_not(e0, e1, {outb i}); } L{i} = HK_LIT(0);"
    | "&&" => s!"hk_bx_and({tri a}, {tri b}, {outb i}); L{i} = HK_LIT(0);"
    | "||" => s!"hk_bx_or({tri a}, {tri b}, {outb i}); L{i} = HK_LIT(0);"
    | "->" => s!"\{ hk_real n0, n1; hk_bx_not({tri a}, &n0, &n1); hk_bx_or(n0, n1, {tri b}, {outb i}); } L{i} = HK_LIT(0);"
    | o => s!"/* ? {o} */ lo{i} = -HK_INF; hi{i} = HK_INF; L{i} = HK_INF;")
  | .pow a n => some s!"hk_bx_pow({tr a}, {n}, {outp i});"
  | .ite c a b => some s!"hk_bx_ite({tri c}, {tr a}, {tr b}, {outp i});"
  | .iteC c a b => some s!"hk_bx_ite({tri c}, {tr a}, {tr b}, {outp i});"
  | .call fn _ _ c _ => some s!"#error \"{fn}[{c}] is a .call node: kernels are printed from the FLAT compilation\""

/-- what a C printer emits per node: the declaration (value, or value and tangent, or the box
triple) as lines -/
inductive CKind | value | jvp | box

/-- the lines for one node under a kind -/
def cNodeLines (f : Fun) (kind : CKind) (inputRef dxRef : Nat → String)
    (boxRef : Nat → String × String × String) (ridx : String) (i : Nat) : Array String :=
  let g := f.graph
  let ty := if g.isBool i then "bool" else "hk_real"
  match kind with
  | .value => match cRhs f inputRef ridx i with
    | some r => #[s!"const {ty} t{i} = {r};"]
    | none => #[]
  | .jvp =>
    let v := match cRhs f inputRef ridx i with
      | some r => #[s!"const {ty} t{i} = {r};"]
      | none => #[]
    match cDRhs f dxRef i with
    | some r => v.push s!"const hk_real d{i} = {r};"
    | none => v
  | .box => match cBoxStmt f boxRef ridx i with
    | some st => #[s!"hk_real lo{i}, hi{i}, L{i};", st]
    | none => #[]

/-- the body in phases, loop form: before the reduction; the loop over the rays accumulating
each sum (its value, tangent, or box); after it. Returns the lines or the layering error -/
def cBodyLoop (f : Fun) (kind : CKind) (inputRef dxRef : Nat → String)
    (boxRef : Nat → String × String × String) : Except String (Array String) := Id.run do
  let g := f.graph
  let L := layers g
  if !L.err.isEmpty then return .error L.err
  let live := liveNodes g f.output.flatten
  let sums := L.sums.filter live.contains          -- a sum the outputs do not need is not accumulated
  let mut lines : Array String := #[]
  let node := fun (i : Nat) (ind : String) =>
    (cNodeLines f kind inputRef dxRef boxRef "hk_i" i).map (ind ++ ·)
  for i in [0:g.nodes.size] do
    if live.contains i && !L.ray[i]! && !L.post[i]! then lines := lines ++ node i "  "
  if !sums.isEmpty then
    for s in sums do
      match kind with
      | .value => lines := lines.push s!"  hk_real acc{s} = HK_LIT(0);"
      | .jvp => lines := lines.push s!"  hk_real acc{s} = HK_LIT(0); hk_real dacc{s} = HK_LIT(0);"
      | .box => lines := lines.push s!"  hk_real acclo{s} = HK_LIT(0), acchi{s} = HK_LIT(0), accL{s} = HK_LIT(0);"
    lines := lines.push s!"  for (int hk_i = 0; hk_i < {L.P}; ++hk_i) \{"
    for i in [0:g.nodes.size] do
      if live.contains i && L.ray[i]! then lines := lines ++ node i "    "
    for s in sums do
      match g.nodes[s]! with
      | .sum _ a =>
        match kind with
        | .value => lines := lines.push s!"    acc{s} += t{a};"
        | .jvp => lines := lines.push s!"    acc{s} += t{a}; dacc{s} += {if g.isBool a then "HK_LIT(0)" else s!"d{a}"};"
        | .box => lines := lines.push s!"    acclo{s} += lo{a}; acchi{s} += hi{a}; accL{s} = hk_bx_cap(accL{s} + L{a});"
      | _ => pure ()
    lines := lines.push "  }"
  for i in [0:g.nodes.size] do
    if live.contains i && L.post[i]! then
      match g.nodes[i]! with
      | .sum _ _ =>
        match kind with
        | .value => lines := lines.push s!"  const hk_real t{i} = acc{i};"
        | .jvp => lines := lines.push s!"  const hk_real t{i} = acc{i}; const hk_real d{i} = dacc{i};"
        | .box => lines := lines.push s!"  hk_real lo{i} = acclo{i}, hi{i} = acchi{i}, L{i} = accL{i};"
      | _ => lines := lines ++ node i "  "
  return .ok lines

/-- the scalar parameters of a C function, then its ray tables -/
def cParams (f : Fun) : Array String :=
  let g := f.graph
  (f.inputs.map fun (nm, i) => (if g.isBool i then "bool " else "hk_real ") ++ nm)
    ++ (f.arrays.map fun (b, _, _) => s!"const hk_real HK_RADDR* {b}")

/-- C99, target-neutral: `hk_real`, `HK_LIT`, `hk_sqrt` ... are macros the includer sets; a ray
table is a pointer parameter (`HK_RADDR`: `device` in Metal, nothing in C) -/
def printC (f : Fun) : String := Id.run do
  let g := f.graph
  let outs := f.output.flatten
  let retTy := match f.output with
    | Val.s _ => "hk_real" | Val.b _ => "bool" | _ => "void"
  let params := cParams f
  let params := if retTy == "void" then params.push "hk_real HK_ADDR* out" else params
  let paramStr := if params.isEmpty then "void" else ", ".intercalate params.toList
  let nameOf := fun (i : Nat) => ((f.inputs.find? (·.2 == i)).map (·.1)).getD "?"
  let body := match cBodyLoop f .value nameOf (fun _ => "0") (fun _ => ("0", "0", "0")) with
    | .ok ls => ls
    | .error e => #[s!"#error \"{e}\""]
  let mut lines : Array String := #[s!"HK_STATIC {retTy} {cName f.name}({paramStr}) \{"]
  lines := lines ++ body
  match f.output with
  | Val.s i => lines := lines.push s!"  return t{i};"
  | Val.b i => lines := lines.push s!"  return t{i};"
  | _ =>
    for k in [0:outs.size] do
      lines := lines.push s!"  out[{k}] = t{outs[k]!};"
  lines := lines.push "}"
  let _ := g
  return "\n".intercalate lines.toList

/-! ## The tangent functor: the graph's forward-mode derivative -/

/-- C99: the function and its Jacobian-vector product along `hk_dx` (one tangent per scalar input
in binder order; booleans and ray tables carry none). The derivative of each node is written
next to its value: the tangent functor on the graph category. -/
def printCJvp (f : Fun) : String := Id.run do
  let outs := f.output.flatten
  let g := f.graph
  let params := cParams f ++ #["const hk_real HK_ADDR* hk_dx", "hk_real HK_ADDR* hk_out", "hk_real HK_ADDR* hk_dout"]
  let mut inIdx : Std.HashMap Nat Nat := {}
  for k in [0:f.inputs.size] do inIdx := inIdx.insert (f.inputs[k]!).2 k
  let nameOf := fun (i : Nat) => ((f.inputs.find? (·.2 == i)).map (·.1)).getD "?"
  let dxOf := fun (i : Nat) => s!"hk_dx[{inIdx.getD i 0}]"
  let body := match cBodyLoop f .jvp nameOf dxOf (fun _ => ("0", "0", "0")) with
    | .ok ls => ls
    | .error e => #[s!"#error \"{e}\""]
  let mut lines : Array String := #[s!"HK_STATIC void {cName f.name}_jvp({", ".intercalate params.toList}) \{"]
  lines := lines ++ body
  for k in [0:outs.size] do
    let o := outs[k]!
    lines := lines.push s!"  hk_out[{k}] = t{o};"
    lines := lines.push s!"  hk_dout[{k}] = {if g.isBool o then "HK_LIT(0)" else s!"d{o}"};"
  lines := lines.push "}"
  return "\n".intercalate lines.toList

/-! ## The box functor: interval and Lipschitz abstract interpretation of the graph -/

/-- the runtime the box printer's code calls: every node rule as a C99 function on
`(lo, hi, L)` triples. `L` is a Lipschitz bound of the node with respect to the inputs' scaled
∞-norm; `HK_INF` marks a jump (a gate the box straddles, a pole, a floor across an integer).
Booleans are three-valued: `lo = hi = 1` true, `lo = hi = 0` false, `[0, 1]` unknown. -/
def boxRuntime : String := "
#ifndef HK_INF
#define HK_INF HK_LIT(1e30)
#endif
HK_STATIC hk_real hk_bx_cap(hk_real x) { return (x != x || x >= HK_INF) ? HK_INF : (x < HK_LIT(0) ? HK_LIT(0) : x); }
HK_STATIC hk_real hk_bx_mag(hk_real lo, hk_real hi) { return hk_max(hk_fabs(lo), hk_fabs(hi)); }
HK_STATIC hk_real hk_bx_mig(hk_real lo, hk_real hi) { return (lo <= HK_LIT(0) && hi >= HK_LIT(0)) ? HK_LIT(0) : hk_min(hk_fabs(lo), hk_fabs(hi)); }
HK_STATIC void hk_bx_neg(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = -ahi; *hi = -alo; *L = aL; }
HK_STATIC void hk_bx_add(hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = alo + blo; *hi = ahi + bhi; *L = hk_bx_cap(aL + bL); }
HK_STATIC void hk_bx_sub(hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = alo - bhi; *hi = ahi - blo; *L = hk_bx_cap(aL + bL); }
HK_STATIC void hk_bx_mul(hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  const hk_real p1 = alo * blo, p2 = alo * bhi, p3 = ahi * blo, p4 = ahi * bhi;
  *lo = hk_min(hk_min(p1, p2), hk_min(p3, p4)); *hi = hk_max(hk_max(p1, p2), hk_max(p3, p4));
  *L = hk_bx_cap(hk_bx_mag(alo, ahi) * bL + hk_bx_mag(blo, bhi) * aL);
}
HK_STATIC void hk_bx_div(hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  if (blo <= HK_LIT(0) && bhi >= HK_LIT(0)) { *lo = -HK_INF; *hi = HK_INF; *L = HK_INF; return; }
  const hk_real p1 = alo / blo, p2 = alo / bhi, p3 = ahi / blo, p4 = ahi / bhi;
  *lo = hk_min(hk_min(p1, p2), hk_min(p3, p4)); *hi = hk_max(hk_max(p1, p2), hk_max(p3, p4));
  const hk_real mb = hk_bx_mig(blo, bhi);
  *L = hk_bx_cap(aL / mb + hk_bx_mag(alo, ahi) * bL / (mb * mb));
}
HK_STATIC void hk_bx_sqrt(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  const hk_real l0 = hk_max(alo, HK_LIT(0)), h0 = hk_max(ahi, HK_LIT(0));
  *lo = hk_sqrt(l0); *hi = hk_sqrt(h0);
  *L = (l0 > HK_LIT(0)) ? hk_bx_cap(aL / (HK_LIT(2) * hk_sqrt(l0))) : (aL > HK_LIT(0) ? HK_INF : HK_LIT(0));
}
HK_STATIC void hk_bx_trig(int isSin, hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  const hk_real twoPi = HK_LIT(2) * HK_PI;
  *L = aL;
  if (ahi - alo >= twoPi) { *lo = HK_LIT(-1); *hi = HK_LIT(1); return; }
  const hk_real fa = isSin ? hk_sin(alo) : hk_cos(alo), fb = isSin ? hk_sin(ahi) : hk_cos(ahi);
  *lo = hk_min(fa, fb); *hi = hk_max(fa, fb);
  const hk_real cmax = isSin ? HK_PI / HK_LIT(2) : HK_LIT(0);   /* the maxima: cmax + 2k pi */
  const hk_real cmin = cmax + HK_PI;                            /* the minima */
  hk_real k = hk_floor((alo - cmax) / twoPi) + HK_LIT(1);
  if (cmax + k * twoPi <= ahi) *hi = HK_LIT(1);
  k = hk_floor((alo - cmin) / twoPi) + HK_LIT(1);
  if (cmin + k * twoPi <= ahi) *lo = HK_LIT(-1);
}
HK_STATIC void hk_bx_tan(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  const hk_real c0 = HK_PI / HK_LIT(2);
  const hk_real k = hk_floor((alo - c0) / HK_PI) + HK_LIT(1);
  if (c0 + k * HK_PI <= ahi) { *lo = -HK_INF; *hi = HK_INF; *L = HK_INF; return; }
  *lo = hk_tan(alo); *hi = hk_tan(ahi);
  const hk_real m = hk_bx_mag(*lo, *hi);
  *L = hk_bx_cap(aL * (HK_LIT(1) + m * m));
}
HK_STATIC void hk_bx_atan(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  *lo = hk_atan(alo); *hi = hk_atan(ahi); const hk_real m = hk_bx_mig(alo, ahi); *L = hk_bx_cap(aL / (HK_LIT(1) + m * m));
}
HK_STATIC void hk_bx_acos(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  const hk_real l0 = hk_max(alo, HK_LIT(-1)), h0 = hk_min(ahi, HK_LIT(1));
  *lo = hk_acos(h0); *hi = hk_acos(l0); const hk_real m = hk_bx_mag(l0, h0);
  *L = (m < HK_LIT(1)) ? hk_bx_cap(aL / hk_sqrt(HK_LIT(1) - m * m)) : (aL > HK_LIT(0) ? HK_INF : HK_LIT(0));
}
HK_STATIC void hk_bx_asin(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  const hk_real l0 = hk_max(alo, HK_LIT(-1)), h0 = hk_min(ahi, HK_LIT(1));
  *lo = hk_asin(l0); *hi = hk_asin(h0); const hk_real m = hk_bx_mag(l0, h0);
  *L = (m < HK_LIT(1)) ? hk_bx_cap(aL / hk_sqrt(HK_LIT(1) - m * m)) : (aL > HK_LIT(0) ? HK_INF : HK_LIT(0));
}
HK_STATIC void hk_bx_exp(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = hk_exp(alo); *hi = hk_exp(ahi); *L = hk_bx_cap(aL * (*hi)); }
HK_STATIC void hk_bx_log(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  if (alo <= HK_LIT(0)) { *lo = -HK_INF; *hi = (ahi > HK_LIT(0)) ? hk_log(ahi) : -HK_INF; *L = (aL > HK_LIT(0)) ? HK_INF : HK_LIT(0); return; }
  *lo = hk_log(alo); *hi = hk_log(ahi); *L = hk_bx_cap(aL / alo);
}
HK_STATIC void hk_bx_abs(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  if (alo >= HK_LIT(0)) { *lo = alo; *hi = ahi; } else if (ahi <= HK_LIT(0)) { *lo = -ahi; *hi = -alo; } else { *lo = HK_LIT(0); *hi = hk_max(-alo, ahi); }
  *L = aL;
}
HK_STATIC void hk_bx_floor(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = hk_floor(alo); *hi = hk_floor(ahi); *L = (*lo == *hi || aL == HK_LIT(0)) ? HK_LIT(0) : HK_INF; }
HK_STATIC void hk_bx_sigmoid(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  *lo = hk_sigmoid(alo); *hi = hk_sigmoid(ahi); const hk_real m = hk_bx_mig(alo, ahi); const hk_real sm = hk_sigmoid(m);
  *L = hk_bx_cap(aL * sm * (HK_LIT(1) - sm));
}
HK_STATIC void hk_bx_tanh(hk_real alo, hk_real ahi, hk_real aL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  *lo = hk_tanh(alo); *hi = hk_tanh(ahi); const hk_real m = hk_bx_mig(alo, ahi); const hk_real tm = hk_tanh(m);
  *L = hk_bx_cap(aL * (HK_LIT(1) - tm * tm));
}
HK_STATIC void hk_bx_pow(hk_real alo, hk_real ahi, hk_real aL, int n, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  if (n == 0) { *lo = HK_LIT(1); *hi = HK_LIT(1); *L = HK_LIT(0); return; }
  const hk_real m = hk_bx_mag(alo, ahi), mg = hk_bx_mig(alo, ahi);
  hk_real pm = HK_LIT(1), pmg = HK_LIT(1), pl = HK_LIT(1), ph = HK_LIT(1), pm1 = HK_LIT(1);
  for (int k = 0; k < n; ++k) { pm *= m; pmg *= mg; pl *= alo; ph *= ahi; if (k < n - 1) pm1 *= m; }
  if (n % 2 == 0) { *lo = pmg; *hi = pm; } else { *lo = pl; *hi = ph; }
  *L = hk_bx_cap(HK_LIT(n) * pm1 * aL);
}
HK_STATIC void hk_bx_min(hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = hk_min(alo, blo); *hi = hk_min(ahi, bhi); *L = hk_max(aL, bL); }
HK_STATIC void hk_bx_max(hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) { *lo = hk_max(alo, blo); *hi = hk_max(ahi, bhi); *L = hk_max(aL, bL); }
/* three-valued comparisons and connectives */
HK_STATIC void hk_bx_lt(hk_real alo, hk_real ahi, hk_real blo, hk_real bhi, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi) { if (ahi < blo) { *lo = HK_LIT(1); *hi = HK_LIT(1); } else if (alo >= bhi) { *lo = HK_LIT(0); *hi = HK_LIT(0); } else { *lo = HK_LIT(0); *hi = HK_LIT(1); } }
HK_STATIC void hk_bx_le(hk_real alo, hk_real ahi, hk_real blo, hk_real bhi, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi) { if (ahi <= blo) { *lo = HK_LIT(1); *hi = HK_LIT(1); } else if (alo > bhi) { *lo = HK_LIT(0); *hi = HK_LIT(0); } else { *lo = HK_LIT(0); *hi = HK_LIT(1); } }
HK_STATIC void hk_bx_eq(hk_real alo, hk_real ahi, hk_real blo, hk_real bhi, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi) { if (alo == ahi && blo == bhi && alo == blo) { *lo = HK_LIT(1); *hi = HK_LIT(1); } else if (ahi < blo || bhi < alo) { *lo = HK_LIT(0); *hi = HK_LIT(0); } else { *lo = HK_LIT(0); *hi = HK_LIT(1); } }
HK_STATIC void hk_bx_not(hk_real alo, hk_real ahi, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi) { *lo = HK_LIT(1) - ahi; *hi = HK_LIT(1) - alo; }
HK_STATIC void hk_bx_and(hk_real alo, hk_real ahi, hk_real blo, hk_real bhi, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi) { *lo = hk_min(alo, blo); *hi = hk_min(ahi, bhi); }
HK_STATIC void hk_bx_or(hk_real alo, hk_real ahi, hk_real blo, hk_real bhi, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi) { *lo = hk_max(alo, blo); *hi = hk_max(ahi, bhi); }
HK_STATIC void hk_bx_ite(hk_real clo, hk_real chi, hk_real alo, hk_real ahi, hk_real aL, hk_real blo, hk_real bhi, hk_real bL, hk_real HK_ADDR* lo, hk_real HK_ADDR* hi, hk_real HK_ADDR* L) {
  if (clo >= HK_LIT(1)) { *lo = alo; *hi = ahi; *L = aL; return; }
  if (chi <= HK_LIT(0)) { *lo = blo; *hi = bhi; *L = bL; return; }
  *lo = hk_min(alo, blo); *hi = hk_max(ahi, bhi);
  *L = (alo == ahi && blo == bhi && alo == blo && aL == HK_LIT(0) && bL == HK_LIT(0)) ? HK_LIT(0) : HK_INF;   /* the gate straddled: a jump */
}
"

/-- C99: the box functor on the graph. Scalar inputs as boxes `[lo, hi]` with a scale `sc` (the
input's own Lipschitz constant: 1 for a signal per unit, 0 for a held draw or a constant); ray
tables as points; outputs as boxes with a Lipschitz bound `oL` in the inputs' scaled ∞-norm.
Composition of nodes is the composition of these bounds, so a composite definition's sensitivity
is assembled from its parts' rules without anyone writing it; a sum's box is the sum of its
rays' boxes. -/
def printCBox (f : Fun) : String := Id.run do
  let outs := f.output.flatten
  let params := (f.arrays.map fun (b, _, _) => s!"const hk_real HK_RADDR* {b}")
    ++ #["const hk_real HK_ADDR* hk_lo", "const hk_real HK_ADDR* hk_hi", "const hk_real HK_ADDR* hk_sc",
         "hk_real HK_ADDR* hk_olo", "hk_real HK_ADDR* hk_ohi", "hk_real HK_ADDR* hk_oL"]
  let mut inIdx : Std.HashMap Nat Nat := {}
  for k in [0:f.inputs.size] do inIdx := inIdx.insert (f.inputs[k]!).2 k
  let boxOf := fun (i : Nat) => let k := inIdx.getD i 0; (s!"hk_lo[{k}]", s!"hk_hi[{k}]", s!"hk_sc[{k}]")
  let body := match cBodyLoop f .box (fun _ => "0") (fun _ => "0") boxOf with
    | .ok ls => ls
    | .error e => #[s!"#error \"{e}\""]
  let mut lines : Array String := #[s!"HK_STATIC void {cName f.name}_box({", ".intercalate params.toList}) \{"]
  lines := lines ++ body
  for k in [0:outs.size] do
    let o := outs[k]!
    lines := lines.push s!"  hk_olo[{k}] = lo{o}; hk_ohi[{k}] = hi{o}; hk_oL[{k}] = L{o};"
  lines := lines.push "}"
  return "\n".intercalate lines.toList

/-! ## The megakernel: one threadgroup per agent, one thread per ray, the reduction in shared memory -/

/-- Metal: the whole definition as ONE kernel. Buffer 0 holds the scalar inputs `(B, n_in)`,
then one buffer per ray table `(B, P, m)`, then the outputs `(B, n_out)`, then the count. A
threadgroup of P threads is one agent: every thread evaluates the agent-level prelude, its own
ray, writes its ray's summands to threadgroup memory; thread 0 reduces; every thread reads the
sums and evaluates what follows; thread 0 writes the outputs. -/
def printMslMega (f : Fun) (kname : String) : String := Id.run do
  let g := f.graph
  let L := layers g
  let outs := f.output.flatten
  let nin := f.inputs.size
  let nout := outs.size
  let P := if L.P == 0 then 1 else L.P
  let live := liveNodes g outs
  let sums := L.sums.filter live.contains
  let mut params : Array String := #["device const float* hk_x [[buffer(0)]]"]
  let mut bi := 1
  for (b, _, _) in f.arrays do
    params := params.push s!"device const float* {b}_all [[buffer({bi})]]"
    bi := bi + 1
  params := params.push s!"device float* hk_y [[buffer({bi})]]"
  params := params.push s!"device const int* hk_n [[buffer({bi + 1})]]"
  let mut lines : Array String := #[]
  lines := lines.push s!"kernel void {kname}({", ".intercalate params.toList}, uint hk_b [[threadgroup_position_in_grid]], uint hk_i [[thread_position_in_threadgroup]]) \{"
  lines := lines.push "  if ((int)hk_b >= hk_n[0]) return;"
  for s in sums do lines := lines.push s!"  threadgroup float hk_sh{s}[{P}];"
  lines := lines.push s!"  device const float* hk_xb = hk_x + hk_b * {nin};"
  for (b, p, m) in f.arrays do
    if f.shared.contains b then lines := lines.push s!"  device const float* {b} = {b}_all;"
    else lines := lines.push s!"  device const float* {b} = {b}_all + hk_b * {p * (if m == 0 then 1 else m)};"
  let mut inIdx : Std.HashMap Nat Nat := {}
  for k in [0:nin] do inIdx := inIdx.insert (f.inputs[k]!).2 k
  let inRef := fun (i : Nat) => if g.isBool i then s!"(hk_xb[{inIdx.getD i 0}] != 0.0f)" else s!"hk_xb[{inIdx.getD i 0}]"
  let node := fun (i : Nat) (ind : String) =>
    (cNodeLines f .value inRef (fun _ => "0") (fun _ => ("0", "0", "0")) "hk_i" i).map (ind ++ ·)
  if !L.err.isEmpty then lines := lines.push s!"#error \"{L.err}\""
  let isA := fun (i : Nat) => live.contains i && !L.ray[i]! && !L.post[i]!
  if sums.isEmpty then
    -- no reduction: one thread is the whole agent
    for i in [0:g.nodes.size] do
      if live.contains i then lines := lines ++ node i "  "
  else
    -- THE PRELUDE ON THREAD 0, BROADCAST: the agent-level nodes before the reduction are computed
    -- once, and those the ray level reads go through threadgroup memory; the rays run on every
    -- thread; thread 0 reduces, finishes, writes
    let mut needed : Array Nat := #[]
    let mut seen : Std.HashSet Nat := {}
    for i in [0:g.nodes.size] do
      if live.contains i && L.ray[i]! then
        for d in g.nodes[i]!.deps do
          if isA d && !seen.contains d then
            seen := seen.insert d
            needed := needed.push d
    lines := lines.push s!"  threadgroup float hk_pre[{max needed.size 1}];"
    -- declarations at function scope, values on thread 0
    for i in [0:g.nodes.size] do
      if isA i then
        let ty := if g.isBool i then "bool" else "hk_real"
        lines := lines.push s!"  {ty} t{i};"
    lines := lines.push "  if (hk_i == 0) {"
    for i in [0:g.nodes.size] do
      if isA i then
        match cRhs f inRef "hk_i" i with
        | some r => lines := lines.push s!"    t{i} = {r};"
        | none => pure ()
    for k in [0:needed.size] do
      let d := needed[k]!
      lines := lines.push s!"    hk_pre[{k}] = {if g.isBool d then s!"(t{d} ? 1.0f : 0.0f)" else s!"t{d}"};"
    lines := lines.push "  }"
    lines := lines.push "  threadgroup_barrier(mem_flags::mem_threadgroup);"
    for k in [0:needed.size] do
      let d := needed[k]!
      lines := lines.push s!"  t{d} = {if g.isBool d then s!"(hk_pre[{k}] != 0.0f)" else s!"hk_pre[{k}]"};"
    -- the ray level on every thread
    for i in [0:g.nodes.size] do
      if live.contains i && L.ray[i]! then lines := lines ++ node i "  "
    for s in sums do
      match g.nodes[s]! with
      | .sum _ a => lines := lines.push s!"  hk_sh{s}[hk_i] = t{a};"
      | _ => pure ()
    lines := lines.push "  threadgroup_barrier(mem_flags::mem_threadgroup);"
    lines := lines.push "  if (hk_i == 0) {"
    for s in sums do
      lines := lines.push s!"    \{ float acc = 0.0f; for (int j = 0; j < {P}; ++j) acc += hk_sh{s}[j]; hk_sh{s}[0] = acc; }"
    -- what follows the reduction, on thread 0
    for i in [0:g.nodes.size] do
      if live.contains i && L.post[i]! then
        match g.nodes[i]! with
        | .sum _ _ => lines := lines.push s!"    const hk_real t{i} = hk_sh{i}[0];"
        | _ => lines := lines ++ node i "    "
    for k in [0:nout] do
      lines := lines.push s!"    hk_y[hk_b * {nout} + {k}] = t{outs[k]!};"
    lines := lines.push "  }"
    lines := lines.push "}"
    return "\n".intercalate lines.toList
  lines := lines.push "  if (hk_i == 0) {"
  for k in [0:nout] do
    lines := lines.push s!"    hk_y[hk_b * {nout} + {k}] = t{outs[k]!};"
  lines := lines.push "  }"
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
      | .natLit s => (s!"↑{s}", "plaintext")
      | .bconst b => (if b then "true" else "false", "plaintext")
      | .pi => ("π", "plaintext")
      | .un op _ => (op, "ellipse")
      | .bin op _ _ => (op, "ellipse")
      | .pow _ n => (s!"^{n}", "ellipse")
      | .ite .. => ("if", "diamond")
      | .iteC .. => ("if (classical)", "diamond")
      | .rayIn b k => (s!"{b}[i][{k}]", "box")
      | .sum P _ => (s!"Σ over {P} rays", "hexagon")
      | .call fn _ _ c _ => (s!"{fn}[{c}]", "component")
    lines := lines.push s!"  n{i} [label=\"{label}\", shape={shape}];"
    match g.nodes[i]! with
    | .un _ a => lines := lines.push s!"  n{a} -> n{i};"
    | .bin _ a b => lines := lines.push s!"  n{a} -> n{i}; n{b} -> n{i};"
    | .pow a _ => lines := lines.push s!"  n{a} -> n{i};"
    | .ite c a b => lines := lines.push s!"  n{c} -> n{i} [label=c]; n{a} -> n{i} [label=1]; n{b} -> n{i} [label=0];"
    | .iteC c a b => lines := lines.push s!"  n{c} -> n{i} [label=c]; n{a} -> n{i} [label=1]; n{b} -> n{i} [label=0];"
    | .sum _ a => lines := lines.push s!"  n{a} -> n{i} [label=Σ];"
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
    for d in node.deps do c := c.modify d (· + 1)
  return c

/-- a `.call` as the Lean application it stands for: the template's `%`s filled with the printed
operands, the column applied when the callee returns a vector -/
def renderCall (tmpl : String) (args : Array Nat) (col : Nat) (isVec : Bool) (r : Nat → String) :
    String := Id.run do
  let parts := tmpl.splitOn "%"
  let mut out := parts.headD ""
  for k in [0:parts.length - 1] do
    out := out ++ r (args[k]!) ++ (parts[k+1]!)
  return if isVec then s!"({out} {col})" else s!"({out})"

/-- the Lean printers: `real` selects `ℝ` (the round trip) or `Float` (the twin) -/
partial def leanExpr (g : Graph) (real : Bool) (i : Nat) : String :=
  let r := leanExpr g real
  match g.nodes[i]! with
  | .input nm ln => if real then ln else nm
  | .lit s => if real then s!"({s} : ℝ)" else s!"({s} : Float)"
  | .natLit s => if real then s!"((({s} : ℕ)) : ℝ)" else s!"({s} : Float)"
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
    | "floor" => if real then s!"((⌊{r a}⌋ : ℤ) : ℝ)" else s!"(Float.floor {r a})"
    | "sigmoid" => if real then s!"(Real.sigmoid {r a})" else s!"(1.0 / (1.0 + Float.exp (-{r a})))"
    | "tanh" => if real then s!"(Real.tanh {r a})" else s!"(Float.tanh {r a})"
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
  | .rayIn b k => s!"({b} i {k})"          -- the inline printer has no binder: leanBody prints sums
  | .sum P a => s!"(∑ i : Fin {P}, {r a})"
  | .call _ tmpl args c v => renderCall tmpl args c v r

partial def leanVal (g : Graph) (real : Bool) : Val → String
  | Val.s i => leanExpr g real i
  | Val.b i => leanExpr g real i
  | .pair a b => s!"({leanVal g real a}, {leanVal g real b})"
  | .vec xs => "![" ++ ", ".intercalate (xs.toList.map (leanVal g real)) ++ "]"
  | .struct n fs => "{ " ++ ", ".intercalate (fs.toList.map fun (f, v) => s!"{f} := {leanVal g real v}") ++ s!" : {n} }"
  | .rayIdx => "i"

/-- the Lean printers with `let`s: every non-leaf node used more than once (or costly) is bound
once, in graph order, so a shared subgraph prints once; the printed expression stays linear in
the graph. A sum prints as `∑ i : Fin P, (…)` (ℝ) or a fold (Float), its ray-level nodes bound
inside. -/
partial def leanBody (f : Fun) (real : Bool) (outs : Array Nat) (v : Val) (indent : String) : String := Id.run do
  let g := f.graph
  let counts := useCounts g
  let live := liveNodes g outs
  let L := layers g
  -- the nodes bound by a let: shared, non-leaf
  let mut bound : Std.HashSet Nat := {}
  for i in [0:g.nodes.size] do
    if !live.contains i then continue
    match g.nodes[i]! with
    | .input .. | .lit _ | .natLit _ | .bconst _ | .pi | .rayIn .. => pure ()
    | .sum .. => bound := bound.insert i
    | .call .. => pure ()
    | _ => if counts[i]! > 1 then bound := bound.insert i
  -- a sub-morphism the composite calls ONCE and reads several columns of must be BOUND once,
  -- the way the definition binds it (`let s := megaStep …; s 0; s 1; …`).  Hash-consing already
  -- gives one node per (application, column); they are grouped here by the application, the
  -- lowest column's node standing for it - so the twin's call structure is the definition's.
  let callKey : Nat → Option String := fun i => match g.nodes[i]! with
    | .call fn tmpl args _ isVec => if isVec then some s!"{fn}|{tmpl}|{args}" else none
    | _ => none
  let mut callRep : Std.HashMap String Nat := {}
  let mut callCnt : Std.HashMap String Nat := {}
  for i in [0:g.nodes.size] do
    if !live.contains i then continue
    if let some k := callKey i then
      callCnt := callCnt.insert k ((callCnt.getD k 0) + 1)
      if !callRep.contains k then callRep := callRep.insert k i
  for (k, r) in callRep.toList do
    if callCnt.getD k 0 > 1 && !L.ray[r]! then bound := bound.insert r
  let tableRead := fun (b : String) (row : String) (k : Nat) =>
    let m := f.tableM b
    if real then (if m == 0 then s!"({b} {row})" else s!"({b} {row} {k})")
    else (if m == 0 then s!"{b}[{row}]!" else s!"{b}[{row} * {m} + {k}]!")
  -- print a node: a bound node by its name, otherwise inline (recursively)
  let rec pr (bnd : Std.HashSet Nat) (i : Nat) (top : Bool) : String :=
    if bnd.contains i && !top && !((g.nodes[i]!).isCall) then s!"v{i}" else
    let r := fun j => pr bnd j false
    match g.nodes[i]! with
    | .input nm ln =>
      match f.arrayScalar[i]? with
      | some (b, j, k) => if real then ln else tableRead b (toString j) k
      | none => if real then ln else nm
    | .rayIn b k => tableRead b "i" k
    | .call _ tmpl cargs c cv =>
      -- the binding line prints the application itself; every column reads that binding
      match callKey i with
      | some k =>
        if top then renderCall tmpl cargs 0 false (fun j => r j)
        else
          -- the binding of this application, if the printer made one: the lowest node of the
          -- group that is in scope here
          let rp := (List.range g.nodes.size).find? fun j =>
            bnd.contains j && callKey j == some k
          match rp with
          | some j => s!"(v{j} {c})"
          | none => renderCall tmpl cargs c cv (fun j => r j)
      | none => renderCall tmpl cargs c cv (fun j => r j)
    | .sum P a =>
      -- the ray-level bound nodes THIS sum uses, in order, inside the binder.  Restricting to
      -- what is reachable from the summand matters for the round trip: a sum that prints the
      -- other sums' ray nodes too is a lambda that no longer matches the definition's own
      -- summand syntactically, and `isDefEq` then falls back to evaluating `Finset.sum` over
      -- the 64 rays - 64 copies of the ray's graph, on both sides.
      let reach := liveNodes g #[a]
      -- how often each node is used INSIDE this sum: a ray node used once here is written out
      -- where it stands, exactly as the definition writes it, so the summand matches the
      -- definition's summand syntactically and `isDefEq` never has to evaluate `Finset.sum`
      -- over the 64 rays (which is 64 copies of the ray's graph, on both sides).
      let rcounts := Id.run do
        let mut c := Array.replicate g.nodes.size 0
        for j in [0:g.nodes.size] do
          if reach.contains j then for d in (g.nodes[j]!).deps do c := c.modify d (· + 1)
        return c
      -- a ray-level call whose columns this sum reads more than once is bound inside the
      -- binder, once, exactly as the summand of the definition reads one ray
      let rrep := Id.run do
        let mut rep : Std.HashMap String Nat := {}
        let mut cnt : Std.HashMap String Nat := {}
        for j in [0:g.nodes.size] do
          if reach.contains j || j == a then
            if let some k := callKey j then
              cnt := cnt.insert k ((cnt.getD k 0) + 1)
              if !rep.contains k then rep := rep.insert k j
        return (rep, cnt)
      -- NOTHING ray-level is bound: the definition writes its summand out, and a `let` the
      -- definition does not have is a summand that does not match it, which (with the callees
      -- irreducible) is a fast failure and (without) sends `isDefEq` into evaluating the sum
      -- over all 64 rays.  Measured: the capture sum, whose ray reads are used once, matched and
      -- proved; the flux sums, whose `dr i k` were used twice and so were bound, did not.
      let bnd' := Id.run do
        let mut b := bnd
        for j in [0:g.nodes.size] do
          if L.ray[j]! then
            match g.nodes[j]! with
            -- a ray read is a LEAF: the definition writes `dr i 0` where it stands, so binding
            -- it (because two calls of the same ray use it) makes a summand that no longer
            -- matches the definition's.  Measured: the capture sum, whose reads are used once,
            -- proved; the flux sums, whose reads were bound, did not.
            | .rayIn .. | .input .. => b := b.erase j
            -- a call is bound only as its group's representative (the application, once)
            | .call .. => b := b.erase j
            | _ => if reach.contains j && rcounts[j]! > 1 then b := b.insert j else b := b.erase j
        for (k, r) in rrep.1.toList do
          if rrep.2.getD k 0 > 1 && L.ray[r]! then b := b.insert r
        return b
      let inner := Id.run do
        let mut ls : Array String := #[]
        for j in [0:g.nodes.size] do
          if bnd'.contains j && L.ray[j]! && live.contains j && reach.contains j then
            ls := ls.push s!"let v{j} := {pr bnd' j true}; "
        return String.join ls.toList
      if real then s!"(∑ i : Fin {P}, ({inner}{pr bnd' a false}))"
      else s!"((List.range {P}).foldl (fun acc i => acc + ({inner}{pr bnd' a false})) 0.0)"
    | .lit s => if real then s!"({s} : ℝ)" else s!"({s} : Float)"
    | .natLit s => if real then s!"((({s} : ℕ)) : ℝ)" else s!"({s} : Float)"
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
      | "floor" => if real then s!"((⌊{r a}⌋ : ℤ) : ℝ)" else s!"(Float.floor {r a})"
      | "sigmoid" => if real then s!"(Real.sigmoid {r a})" else s!"(1.0 / (1.0 + Float.exp (-{r a})))"
      | "tanh" => if real then s!"(Real.tanh {r a})" else s!"(Float.tanh {r a})"
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
    | Val.s i => pr bound i false
    | Val.b i => pr bound i false
    | .pair a b => s!"({prVal a}, {prVal b})"
    | .vec xs => "![" ++ ", ".intercalate (xs.toList.map prVal) ++ "]"
    | .struct n fs => "{ " ++ ", ".intercalate (fs.toList.map fun (f, w) => s!"{f} := {prVal w}") ++ s!" : {n} }"
    | .rayIdx => "i"
  let mut lines : Array String := #[]
  for i in [0:g.nodes.size] do
    if bound.contains i && !L.ray[i]! then
      lines := lines.push s!"{indent}let v{i} := {pr bound i true}"
  lines := lines.push (indent ++ prVal v)
  return "\n".intercalate lines.toList

/-- NumPy, vectorised over agents: every scalar input an array `(B,)` (or a float), ray tables
`(B, P, m)`, every op elementwise; ray-level nodes are `(B, P)` and read agent-level operands
through a new axis; a sum is `np.sum(…, axis=-1)`; `if` as `np.where` -/
def printNumpy (f : Fun) (fname : String) : String := Id.run do
  let g := f.graph
  let L := layers g
  let mut lines : Array String := #[]
  let scalars := f.inputs.map (·.1)
  let params := scalars ++ (f.arrays.map (·.1))
  lines := lines.push s!"def {fname}({", ".intercalate params.toList}):"
  if !L.err.isEmpty then lines := lines.push s!"    raise ValueError({("\"" ++ L.err ++ "\"")})"
  let tableRead := fun (b : String) (row : Option Nat) (k : Nat) =>
    let m := f.tableM b
    let sh := f.shared.contains b
    match row with
    | some j => if sh then (if m == 0 then s!"{b}[{j}]" else s!"{b}[{j}, {k}]")
                else (if m == 0 then s!"{b}[:, {j}]" else s!"{b}[:, {j}, {k}]")
    | none => if m == 0 then s!"{b}" else s!"{b}[:, :, {k}]"
  for i in [0:g.nodes.size] do
    let isLeaf := fun (j : Nat) => match g.nodes[j]! with | .lit _ | .natLit _ | .bconst _ | .pi => true | _ => false
    -- an agent-level operand read at ray level gets the ray axis
    let t := fun (j : Nat) =>
      if L.ray[i]! && !L.ray[j]! && !isLeaf j then s!"np.asarray(t{j})[..., None]" else s!"t{j}"
    let rhs : Option String := match g.nodes[i]! with
      | .input nm _ =>
        match f.arrayScalar[i]? with
        | some (b, j, k) => some (tableRead b (some j) k)
        | none => some nm
      | .rayIn b k => some (tableRead b none k)
      | .sum P a => some (if L.ray[a]! then s!"np.sum(t{a}, axis=-1)" else s!"({P} * t{a})")
      | .call fn _ _ c _ => some s!"(_ for _ in ()).throw(RuntimeError('{fn}[{c}]: a .call node in a kernel graph'))"
      | .lit s => some s
      | .natLit s => some s
      | .bconst b => some (if b then "True" else "False")
      | .pi => some "np.pi"
      | .un op a =>
        let av := t a
        some (match op with
          | "neg" => s!"(-{av})" | "not" => s!"np.logical_not({av})" | "sqrt" => s!"np.sqrt({av})"
          | "sin" => s!"np.sin({av})" | "cos" => s!"np.cos({av})" | "tan" => s!"np.tan({av})"
          | "arctan" => s!"np.arctan({av})" | "arccos" => s!"np.arccos({av})" | "arcsin" => s!"np.arcsin({av})"
          | "exp" => s!"np.exp({av})" | "log" => s!"np.log({av})"
          | "abs" => s!"np.abs({av})" | "floor" => s!"np.floor({av})" | "sigmoid" => s!"(1.0 / (1.0 + np.exp(-{av})))"
          | "tanh" => s!"np.tanh({av})"
          | o => s!"None  # ? {o}")
      | .bin op a b =>
        some (match op with
          | "min" => s!"np.minimum({t a}, {t b})" | "max" => s!"np.maximum({t a}, {t b})"
          | "==" => if g.isBool a then s!"({t a} == {t b})" else s!"hk_eq({t a}, {t b})"
          | "!=" => if g.isBool a then s!"({t a} != {t b})" else s!"np.logical_not(hk_eq({t a}, {t b}))"
          | "&&" => s!"np.logical_and({t a}, {t b})" | "||" => s!"np.logical_or({t a}, {t b})"
          | "->" => s!"np.logical_or(np.logical_not({t a}), {t b})"
          | o => s!"({t a} {o} {t b})")
      | .pow a n => some s!"({t a} ** {n})"
      | .ite c a b => some s!"np.where({t c}, {t a}, {t b})"
      | .iteC c a b => some s!"np.where({t c}, {t a}, {t b})"
    match rhs with
    | some r => lines := lines.push s!"    t{i} = {r}"
    | none => pure ()
  let shapeOf := if scalars.isEmpty then
      (if f.arrays.isEmpty then "()" else s!"({(f.arrays[0]!).1}.shape[0],)")
    else s!"np.broadcast(*[np.asarray(x) for x in [{", ".intercalate scalars.toList}]]).shape"
  match f.output with
  | Val.s i => lines := lines.push s!"    return t{i}"
  | Val.b i => lines := lines.push s!"    return t{i}"
  | v =>
    let outs := v.flatten
    lines := lines.push ("    return np.stack([" ++ ", ".intercalate (outs.toList.map fun i => s!"np.broadcast_to(np.asarray(t{i}, dtype=float), {shapeOf})") ++ "], axis=-1)")
  return "\n".intercalate lines.toList

/-- the round trip. A definition: `theorem f_ccc : f = fun binders => printed := rfl`. A theorem:
its statement printed back, `∀ (data binders), h₁ → … → conclusion`, PROVED BY THE THEOREM
ITSELF - Lean checks the printed statement is the original one, up to definitional unfolding. -/
def printRoundTrip (f : Fun) (ref : String := f.name.getString!) (thm : String := ref) : String :=
  let binders := " ".intercalate (f.binders.toList.map fun (nm, ty) => s!"({nm} : {ty})")
  let body := leanBody f true f.output.flatten f.output "    "
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

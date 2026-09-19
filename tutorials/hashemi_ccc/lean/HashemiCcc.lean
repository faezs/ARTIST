/-
The driver: compile every definition of `TandoorHashemi` (Hashemi.lean) through `Ccc`, and write
- hashemi_ccc.h      C99 device functions, Props as bool functions, closed theorems as checks
- dot/<name>.dot     the dataflow graph of each definition
- hashemi_ccc.json   the table of what compiled, its shapes, and sample inputs for the parity test
- HashemiCccRound.lean   `theorem f_ccc : f = <round trip> := rfl` for every compiled definition
- HashemiCccFloat.lean   the computable Float twin, with `#eval`s at the sample inputs
- hashemi_mega.json      the megakernel's column names (`megaNames`) and its input order
Theorems with binders compile to property functions (their hypotheses as implications);
their round trip is HashemiProps.lean (`prop_X_ok`), written by HashemiPropsGen.
`lake build RequestProject.HashemiCcc` runs it (the `#eval` at the end).
-/
import RequestProject.Hashemi
import RequestProject.HashemiStep
import RequestProject.HashemiProps
import RequestProject.HashemiMega
import RequestProject.HashemiTrace
import RequestProject.HashemiTraceProps
import RequestProject.HashemiEnv
import RequestProject.HashemiPolicy
import RequestProject.HashemiBeamdown
import RequestProject.Ccc

open Lean Meta Ccc

namespace HashemiCcc

def outDir : String := "/Users/faezs/ARTIST-compliant/tutorials/hashemi_ccc"
def leanDir : String := "/Users/faezs/manifold-pareto/lean/RequestProject"

/-- a deterministic pseudo-random sample in [0.2, 1.8) from a name and an index -/
def sample (seed : Nat) (k : Nat) : String :=
  let x := (seed * 6364136223846793005 + k * 1442695040888963407 + 1442695040888963407) % 1000000
  let v := 200000 + (x * 16) / 10   -- 0.2 .. 1.8, six decimals
  let vs := toString v
  let ip := String.ofList (vs.toList.take (vs.length - 6))
  (if ip.isEmpty then "0" else ip) ++ "." ++ (String.ofList (vs.toList.drop (vs.length - 6)))

def jsonStr (s : String) : String :=
  let t := ((s.replace "\\" "\\\\").replace "\"" "\\\"")
  let t := (t.replace "\n" " ").replace "\t" " "     -- no control characters in a JSON string
  "\"" ++ t ++ "\""

/-- the string literals of an array/list literal expression, in order -/
partial def strLits (e : Expr) : Array String :=
  match e with
  | .mdata _ e => strLits e
  | .lit (.strVal s) => #[s]
  | .letE _ _ v b _ => strLits (b.instantiate1 v)     -- long list literals elaborate in `let` chunks
  | e =>
    let f := e.getAppFn
    let args := e.getAppArgs
    if f.isConstOf ``List.toArray && args.size == 2 then strLits args[1]!
    else if f.isConstOf ``List.cons && args.size == 3 then strLits args[1]! ++ strLits args[2]!
    else if f.isConstOf ``List.nil then #[]
    else args.foldl (fun acc a => acc ++ strLits a) #[]

/-! ## The staged round trip: keeping the graph's sharing in the PROOF

`theorem X_ccc : X = fun bs => <printed twin> := rfl` is one `isDefEq` call, and `isDefEq`
zeta-reduces the twin's `let`s: the hash-consed DAG becomes a tree.  For a definition that
bisects (`swingOfLength`, and `step`/`megaStep` through it) the tree doubles at every level -
measured on this file, 2.2x per level, so level 16 already exhausts 4M heartbeats and level 24
would need about ten thousand times that.  Printing the twin with `let`s does not help: `let`
against a differently-shaped term is zeta-reduced just the same (measured: identical curve).

The fix keeps the sharing in the proof instead of in the term, and does NOT weaken the statement:

* `funext` the binders, then `lift_lets` turns the twin's `let`s into local DEFINITIONS and
  `intro v… v…` names them exactly as the printer did - the goal is now O(1) in the graph;
* the composite is related to those locals by a chain of SMALL `rfl`s, one per level
  (`e j : (bisectStep …)^[j+1] start = (v_lo j, v_hi j)`, each proved from `e (j-1)` by
  `Function.iterate_succ_apply'`): in each of them the previous level occurs as the SAME local
  on both sides, so defeq stops at a pointer comparison instead of unfolding;
* a composite that only calls the bisecting definition (`step`, `megaStep`) is first unfolded
  (`rw [step]`), its own subterms are folded onto the twin's locals by small `rfl`s
  (`wireLen … 0 = v47`, …), the swing is replaced by the chain's last level (`rw [key]`), and
  what is left of the graph closes by `rfl`.

A composite that is big but does NOT repeat a stage needs only the first half of this:
`dishPower` - one ray, sampler through capture - is flat, so zeta blows its graph up by a large
constant rather than a power, and `funext; lift_lets; intro …; rfl` alone closes it (~130 s,
against a timeout).  That is the row `{ chain := false }`, and it is the shape to try first.

A sibling applies this to another composite by adding a row to `stagedCfg`: the chain detector
below reads the PRINTED twin (`let` lines), so it needs no knowledge of the source beyond the
names the definition gives the four mount constants and the state.
-/

/-- string helpers that return a `String` (`String.drop` and friends return a slice) -/
def sDrop (s : String) (n : Nat) : String := String.mk (s.toList.drop n)
def sDropR (s : String) (n : Nat) : String := String.mk ((s.toList.reverse.drop n).reverse)
def sTrim (s : String) : String :=
  String.mk ((s.toList.dropWhile (· == ' ')).reverse.dropWhile (· == ' ') |>.reverse)

/-- a `let v… := rhs` line of a printed twin -/
structure LetLine where
  name : String
  rhs  : String
  deriving Inhabited

def letLines (body : String) : Array LetLine := Id.run do
  let mut out : Array LetLine := #[]
  for l in body.splitOn "\n" do
    let t := sTrim l
    if t.startsWith "let " then
      match (sDrop t 4).splitOn " := " with
      | n :: rs => if !rs.isEmpty then out := out.push { name := n, rhs := " := ".intercalate rs }
      | _ => pure ()
  return out

/-- `(if A then B else C)` split at the FIRST `then`/`else`, so a nested `if` stays inside `C` -/
def parseIte (s : String) : Option (String × String × String) :=
  if !s.startsWith "(if " then none else
  let inner := sDropR (sDrop s 4) 1
  match inner.splitOn " then " with
  | a :: rest =>
    if rest.isEmpty then none else
    match (" then ".intercalate rest).splitOn " else " with
    | b :: cs => if cs.isEmpty then none else some (a, b, " else ".intercalate cs)
    | _ => none
  | _ => none

/-- the left operand of a printed comparison `(x < …)` -/
def cmpLeft (rhs : String) : String :=
  match (sDrop rhs 1).splitOn " < " with | a :: _ => a | _ => ""

/-- the bisection chain of a printed twin: the `(lo, hi)` pair of every level, the level-0 start,
and the wire length the bisection solves for.  A level is two adjacent `let`s
`(if c then m else x)`, `(if c then y else m)` - one `bisectStep`, hash-consed. -/
def findChain (ls : Array LetLine) :
    Option (Array (String × String) × String × String × String) := Id.run do
  let mut pairs : Array (String × String) := #[]
  let mut lo0 := ""; let mut hi0 := ""; let mut c0 := ""
  -- the levels of one bisection sit at a CONSTANT stride in the printed lets (six lets per
  -- level here).  A composite that also traces rays prints other `(if c then m else x)` /
  -- `(if c then y else m)` neighbours further down (the optics' own branches), and taking them
  -- for levels puts a stranger at the end of the chain: so the chain stops at the first
  -- deviation from the stride the first two levels set.
  let mut stride := 0; let mut lastIdx := 0; let mut stop := false
  for i in [0:ls.size] do
    if stop then continue
    if i + 1 ≥ ls.size then continue
    match parseIte ls[i]!.rhs, parseIte ls[i+1]!.rhs with
    | some (c, m, x), some (c', y, m') =>
      if c == c' && m == m' then
        if pairs.isEmpty then
          lo0 := x; hi0 := y; c0 := c
        else if stride == 0 then stride := i - lastIdx
        else if i - lastIdx != stride then stop := true
        if !stop then
          pairs := pairs.push (ls[i]!.name, ls[i+1]!.name)
          lastIdx := i
    | _, _ => pure ()
  if pairs.isEmpty then return none
  let L := match ls.find? (fun l => l.name == c0) with | some l => cmpLeft l.rhs | none => ""
  if L.isEmpty then return none
  return some (pairs, lo0, hi0, L)

/-- the mount constants and state a composite names, and what to unfold before folding onto the
twin's locals.  `ym hp a ze` are the pulley/dish constants `bisectStep` takes; `t slack ωd rDrum
dt` spell the commanded wire length. -/
structure StagedCfg where
  ym : String := ""
  hp : String := ""
  aa : String := ""
  ze : String := ""
  t : String := ""
  slack : String := ""
  ωd : String := ""
  rDrum : String := ""
  dt : String := ""
  unf : List String := []
  /-- rewrites applied AFTER `lift_lets; intro`: a previously proved round trip (`dishPower_ccc`)
  folded into the composite's own graph.  It must come after the `intro`, not before: rewriting
  a definition by its twin puts that twin's `let`s on the left, `lift_lets` then lifts them too,
  and the printer's names no longer line up with what `intro` binds. -/
  post : List String := []
  /-- the bisecting call as the composite writes it (`megaStep az t slack …`).  When it is set,
  the chain and the folds are proved inside a local `have` whose statement is that call against
  the twin's FIRST `cols` columns, and the big goal sees exactly two rewrites (the composite's
  own unfolding, and that `have`).  Every fold is a `rewrite` on the goal it is given, and a
  `rewrite` pays for the motive of the whole goal: on a composite that also sums 64 rays, six
  folds on the big goal cost minutes each. -/
  mount : String := ""
  /-- how many of the twin's columns the mount's call produces -/
  cols : Nat := 17
  /-- `false`: the composite is big but has no repeated stage, so the shared shape
  (`funext`, `lift_lets`, `intro` the printer's names, `rfl`) is the whole proof and no
  chain is looked for.  `dishPower` is of this kind: one sample, one reflection, one
  landing - flat, not iterated, so every local is used a bounded number of times and the
  only thing that killed the plain `rfl` was the zeta-expansion of the shared subgraph. -/
  chain : Bool := true
  deriving Inhabited

def stagedCfg : String → Option StagedCfg
  | "swingOfLength" => some { ym := "ym", hp := "hp", aa := "a", ze := "ze", t := "t", slack := "slack", ωd := "ωd", rDrum := "rDrum", dt := "dt" }
  | "step" => some { ym := "ym", hp := "hp", aa := "a", ze := "ze", t := "t", slack := "slack", ωd := "ωd", rDrum := "rDrum", dt := "dt", unf := ["step"] }
  | "megaStep" => some { ym := "ymHashemi", hp := "hpHashemi", aa := "dishHalf", ze := "zeHashemi", t := "t", slack := "slack", ωd := "ωd", rDrum := "rDrum", dt := "dt", unf := ["megaStep", "step"] }
  | "dishPower" => some { chain := false }
  | _ => none

/-- the first `k` entries of the printed twin's output vector, as a vector again: what the
bisecting call the composite makes is equal to, in the twin's own locals. -/
def vecHead (stmt : String) (k : Nat) : String := Id.run do
  let mut body := ""
  for l in stmt.splitOn "\n" do
    let t := sTrim l
    if t.startsWith "![" then body := sDropR (sDrop t 2) 1
  let mut out : Array String := #[]
  let mut cur := ""; let mut d := 0
  for c in body.toList do
    if c == '(' || c == '[' || c == '{' then d := d + 1
    else if c == ')' || c == ']' || c == '}' then d := d - 1
    if c == ',' && d == 0 then
      out := out.push (sTrim cur); cur := ""
    else cur := cur.push c
  out := out.push (sTrim cur)
  return "![" ++ ", ".intercalate (out.toList.take k) ++ "]"

/-!
### The recipe for a composite's round trip (measured; `hashemiEnv` is the worked example)

1. compile it with `noUnfold` DERIVED from its body (`modularRefs` below), so the twin makes the
   calls the definition makes and binds a shared application once;
2. in the generated file, wrap the theorem in
   `section attribute [local irreducible] <the derived set> … end`.  This is what stops
   `isDefEq` from unfolding a callee: without it, a column whose right-hand side is headed by
   `megaStep` sends lazy delta into the 24-fold bisection (`Fin.induction.go` ↦ 194882 in the
   diagnostics), while a column headed by arithmetic is safe.  With it, the mount column
   `hashemiEnv … 0 = (v708 0)` and the ray column `… 17 = (∑ i, dishPower …)/64` both close in
   SECONDS, where they timed out at 4M heartbeats before;
3. `funext … k; fin_cases k <;> rfl`, or `rfl` on the whole vector.

What still fails, and it is neither budget nor lazy delta: the eight FLUX columns.  `inBin`
takes the annulus as a `ℕ` and the translator evaluates `(k : ℝ)` to a literal, but
`((0 : ℕ) : ℝ) = (0 : ℝ)` is `Nat.cast_zero` - PROPOSITIONAL, not definitional.  Measured on its
own: `example (rc x : ℝ) : inBin rc x 0 = (0 * rc / 8 ≤ x ∧ …) := rfl` fails.  So no arrangement
of the proof closes those columns by `rfl`; the printer would have to print the cast as a cast
(or the round trip admit `Nat.cast_ofNat` on them).  `coilProfile` is a second, smaller case: it
takes the bins as a FUNCTION and the definition passes a lambda, while the twin can only print
`![…]`, so it may be kept opaque only when its vector arguments are table binders.
-/

/-- the sub-morphisms each composite keeps opaque in its round trip, with the number of columns
of each one's output (0: a scalar).  A functor preserves composition: `hashemiEnv` IS
`megaStep ; ∑ of dishPower ; the loop`, and that is the equation the round trip should state. -/
def modularRefs : List String := ["hashemiEnv", "hashemiLoop", "traceBeam", "hashemiEnvBeam"]

/-- of those, the ones whose modular round trip CLOSES - all four.  `hashemiEnv` joined last,
and what it needed was in its DEFINITION, twice: the eight annuli written as the vector they are
(`![binOf 0, …, binOf 7]`, so `coilProfile`'s argument prints as the text the line writes), and
the flux indicator decided explicitly (`@b2r … (Classical.propDecidable _)`, so the twin prints
the instance it sees).  Neither changes a kernel: only the `.dot` label `if` ↦ `if (classical)`
moves.  See the notes.

The beam-down pair joins by the same recipe, once `Ccc.lean` prints two more arguments as the
definition writes them: a SHORT vector binder (`H : Fin 3 → ℝ`, bound component by component -
so `hyperHit … H r` stays a call inside `traceBeam`), and a LITERAL vector
(`traceBeam … ![dR 0, dR 1, dR 2] …`, which is the text the definition itself wrote - so
`traceBeam` stays a call inside `hashemiEnvBeam`'s four 64-ray sums).  Without them both were
inlined and the ray columns timed out; with them `funext …; rfl` closes both in seconds. -/
def modularEmit : List String := ["hashemiEnv", "hashemiLoop", "traceBeam", "hashemiEnvBeam"]

/-- the staged proof for `txt`, a printed `theorem X_ccc : X = fun bs => <twin> := rfl`. -/
def stagedProof (txt : String) (binders : String) (cfg : StagedCfg) : Option String := Id.run do
  let stmt := if txt.endsWith " := rfl" then txt.dropRight 7 else txt
  let ls := letLines stmt
  let names := " ".intercalate (ls.toList.map (·.name))
  -- no repeated stage: `lift_lets` alone makes every defeq check small (the sharing is in the
  -- proof's local context instead of the term), and there is nothing to chain
  if !cfg.chain then
    let unf := if cfg.unf.isEmpty then [] else [s!"  rewrite [{", ".intercalate cfg.unf}]"]
    let post := if cfg.post.isEmpty then [] else [s!"  rewrite [{", ".intercalate cfg.post}]"]
    return some (stmt ++ "\n".intercalate
      ([":= by", s!"  funext {binders}"] ++ unf ++ ["  lift_lets", s!"  intro {names}"] ++ post ++ ["  rfl"]))
  let some (pairs, lo0, hi0, L) := findChain ls | return none
  let n := pairs.size
  let (lastLo, lastHi) := pairs[n-1]!
  let mid := s!"(({lastLo} + {lastHi}) / (2 : ℝ))"
  let some mline := ls.find? (fun l => l.rhs == mid) | return none
  let M := mline.name
  let mut Q := ""
  for l in ls do if l.rhs.startsWith s!"({L} < (Real.sqrt" then Q := l.name
  if Q.isEmpty then return none
  let fin := s!"(((if {Q} then {M} else {lastLo}) + (if {Q} then {lastHi} else {M})) / (2 : ℝ))"
  let bs := s!"{cfg.ym} {cfg.hp} {cfg.aa} {cfg.ze}"
  let mut p : Array String := #[]
  let selfv := !(ls.any fun l => l.name == L)
  if selfv then
    p := #[":= by", s!"  funext {binders}", "  lift_lets", s!"  intro {names}",
      s!"  show ((((bisectStep {bs} {L})^[24] ({lo0}, {hi0})).1 + (((bisectStep {bs} {L})^[24] ({lo0}, {hi0})).2)) / (2 : ℝ)) = _"]
  else
    p := #[":= by", s!"  funext {binders}",
      s!"  rewrite [{", ".intercalate cfg.unf}]", "  lift_lets", s!"  intro {names}"]
    if !cfg.post.isEmpty then p := p.push s!"  rewrite [{", ".intercalate cfg.post}]"
    if !cfg.mount.isEmpty then
      p := p.push s!"  have ms : {cfg.mount} = {vecHead stmt cfg.cols} := by"
      p := p.push "    rewrite [megaStep, step]"
  let ind0 := if cfg.mount.isEmpty || selfv then "  " else "    "
  for j in [0:n] do
    let (A, B) := pairs[j]!
    if j == 0 then
      p := p.push s!"{ind0}have e0 : (bisectStep {bs} {L})^[1] ({lo0}, {hi0}) = ({A}, {B}) := rfl"
    else
      p := p.push s!"{ind0}have e{j} : (bisectStep {bs} {L})^[{j+1}] ({lo0}, {hi0}) = ({A}, {B}) := by"
      p := p.push s!"{ind0}  rewrite [show ({j+1} : ℕ) = {j} + 1 from rfl, Function.iterate_succ_apply', e{j-1}]"
      p := p.push s!"{ind0}  rfl"
  if selfv then
    p := p.push s!"  rewrite [show (24 : ℕ) = {n} + 1 from rfl, Function.iterate_succ_apply', e{n-1}]"
    p := p.push "  rfl"
    return some (stmt ++ "\n".intercalate p.toList)
  -- a composite that only calls the bisecting definition: fold its subterms onto the twin's locals
  let ind := if cfg.mount.isEmpty then "  " else "    "
  let some lLine := ls.find? (fun l => l.name == L) | return none
  let some (_, WT, rest) := parseIte lLine.rhs | return none
  let some (_, W0, Lcmd) := parseIte rest | return none
  let some cLine := ls.find? (fun l => l.name == Lcmd) | return none
  let Wt := String.mk ((sDrop cLine.rhs 2).toList.takeWhile (· != ' '))
  let cmd := s!"{Wt} + {cfg.slack} - {cfg.ωd} * {cfg.rDrum} * {cfg.dt}"
  p := p.push s!"{ind}have key : swingOfLength {bs} {hi0} {L} = {fin} := by"
  p := p.push s!"{ind}  show ((((bisectStep {bs} {L})^[24] ({lo0}, {hi0})).1 + (((bisectStep {bs} {L})^[24] ({lo0}, {hi0})).2)) / (2 : ℝ)) = _"
  p := p.push s!"{ind}  rewrite [show (24 : ℕ) = {n} + 1 from rfl, Function.iterate_succ_apply', e{n-1}]"
  p := p.push s!"{ind}  rfl"
  p := p.push s!"{ind}rewrite [show deadPoint {bs} = {hi0} from rfl]"
  p := p.push s!"{ind}rewrite [show wireLen {bs} 0 = {W0} from rfl]"
  p := p.push s!"{ind}rewrite [show wireLen {bs} {hi0} = {WT} from rfl]"
  p := p.push s!"{ind}rewrite [show wireLen {bs} {cfg.t} = {Wt} from rfl]"
  p := p.push s!"{ind}rewrite [show (if {cmd} < {WT} then {WT} else if {W0} < {cmd} then {W0} else {cmd}) = {L} from rfl]"
  p := p.push s!"{ind}rewrite [key]"
  p := p.push s!"{ind}rfl"
  if !cfg.mount.isEmpty then
    p := p.push "  rewrite [ms]"
    p := p.push "  rfl"
  return some (stmt ++ "\n".intercalate p.toList)

def run : MetaM Unit := do
  let env ← getEnv
  let root := `TandoorHashemi
  -- the candidates: user-level constants of the namespace, in a stable order
  let mut names : Array Name := #[]
  let notCompiled : List String := ["b2r", "megaNames", "megaNames_size", "envNames", "envNames_size", "envRays",
    "loopNames", "loopNames_size", "obsNames", "actionNames", "actionLevels", "beamNames", "beamNames_size"]
  for (n, ci) in env.constants.toList do
    if !(root.isPrefixOf n) then continue
    if n.isInternal || isAutoGenerated n then continue
    let last := n.getString!
    if last.startsWith "eq_" || last.endsWith "_ok" || last.endsWith "_ccc" then continue
    if ["injEq", "sizeOf_spec", "noConfusion", "noConfusionType", "casesOn", "recOn", "rec", "mk",
        "below", "brecOn", "ibelow", "binductionOn", "ext", "ext_iff", "inj"].contains last then continue
    if notCompiled.contains last then continue
    match ci with
    | .defnInfo _ | .thmInfo _ => names := names.push n
    | _ => continue
  let sorted := names.qsort (fun a b => a.toString < b.toString)
  let mut funs : Array Fun := #[]
  let mut skipped : Array (Name × String) := #[]
  for n in sorted do
    -- skip projection functions, instances of classes, and type-level definitions
    if (← getProjectionFnInfo? n).isSome then continue
    if ← isInstance n then continue
    let ci ← getConstInfo n
    let ty ← instantiateMVars ci.type
    let isTypeLevel ← forallTelescope ty fun _ b => do pure (b.isSort && !b.isProp)
    if isTypeLevel then continue
    match ← compileDef root n with
    | .ok f => funs := funs.push f
    | .error msg => skipped := skipped.push (n, msg)
  -- ---- the composites, compiled AS COMPOSITES: their sub-morphisms stay opaque (`.call` nodes),
  -- so the round trip is stated against the calls the definition makes.  The kernels keep the
  -- flat graph above: inlining a `.call` IS that flat compilation of the same expression.
  let mut modular : Std.HashMap String Fun := {}
  -- the opaque set is DERIVED, not guessed: the compiled constants the definition's own body
  -- references directly, with the columns of each one's output.  The modular twin then mirrors
  -- the definition's call structure exactly, which is the only way `whnf` stops at an identical
  -- application instead of walking into the callee.
  -- only callees whose output is a real (or a vector of reals) can be an opaque node: a
  -- structure-valued constant (`hashemi`) is read by projection, not applied
  -- ... and only callees every binder of which is a real or a table: one whose argument is a
  -- structure (`rollerRadius hashemi`) is read field by field, so it has no application to print
  let plainBinders := fun (f : Fun) => f.binders.all fun (_, ty) =>
    ty == "ℝ" || ty == "Real" || (ty.splitOn "→").length > 1
  let compiled : Std.HashMap Name Nat := funs.foldl (fun m f =>
    if !plainBinders f then m else
    match f.output with
    | .s _ | .b _ => m.insert f.name 0
    | .vec xs => if xs.all (fun v => match v with | .s _ | .b _ => true | _ => false)
                 then m.insert f.name xs.size else m
    | _ => m) {}
  for ref in modularRefs do
    let n := root ++ ref.toName
    let ci ← getConstInfo n
    let mut nu : List (Name × Nat) := []
    for c in (← instantiateMVars ci.value!).getUsedConstants do
      if c == n then continue
      if let some cols := compiled[c]? then
        unless nu.any (fun (k, _) => k == c) do nu := nu ++ [(c, cols)]
    logInfo m!"noUnfold {ref} := {nu.map (fun (k, v) => (k.getString!, v))}"
    match ← compileDef root n nu (keepCasts := true) with
    | .ok f =>
      modular := modular.insert ref f
      logInfo m!"modular graph of {ref}: {f.graph.nodes.size} nodes, {nu.length} sub-morphisms kept opaque"
    | .error msg => logInfo m!"modular compile of {ref} failed: {msg}"
  -- ---- the C header
  let mut h : Array String := #[
    "/* generated by RequestProject/Ccc.lean from RequestProject/Hashemi.lean - do not edit.",
    "   Each function is one definition of Hashemi.lean, read as it stands and compiled to a",
    "   hash-consed dataflow graph; the includer sets hk_real and the math macros. */",
    "#ifndef HASHEMI_CCC_H", "#define HASHEMI_CCC_H",
    "#ifndef HK_NO_STD", "#include <math.h>", "#include <stdbool.h>", "#endif",
    "#ifndef HK_STATIC", "#define HK_STATIC static inline", "#endif",
    "#ifndef HK_ADDR", "#define HK_ADDR", "#endif",
    "#ifndef hk_real", "#define hk_real float", "#endif",
    "#ifndef HK_LIT", "#define HK_LIT(x) ((hk_real)(x))", "#endif",
    "#ifndef HK_PI", "#define HK_PI HK_LIT(3.14159265358979323846)", "#endif",
    "#ifndef hk_sqrt", "#define hk_sqrt sqrt", "#define hk_sin sin", "#define hk_cos cos",
    "#define hk_tan tan", "#define hk_atan atan", "#define hk_acos acos", "#define hk_asin asin",
    "#define hk_exp exp", "#define hk_log log",
    "#define hk_fabs fabs", "#define hk_floor floor", "#define hk_tanh tanh", "#define hk_min fmin", "#define hk_max fmax", "#endif",
    "/* `=` on ℝ, in floating point: a relative tolerance, the includer may tighten or loosen it */",
    "#ifndef hk_eq", "#define hk_eq(a, b) (hk_fabs((a) - (b)) <= HK_LIT(1e-9) * hk_max(HK_LIT(1), hk_max(hk_fabs(a), hk_fabs(b))))", "#endif",
    "#ifndef hk_sigmoid", "#define hk_sigmoid(x) (HK_LIT(1) / (HK_LIT(1) + hk_exp(-(x))))", "#endif",
    "/* a ray table's address space: `device` in Metal, nothing in C */",
    "#ifndef HK_RADDR", "#define HK_RADDR", "#endif", ""]
  -- the policy's weights: one buffer for every agent (no per-agent offset, no agent axis)
  let sharedTables : Array String := #["W1", "b1", "W2"]
  funs := funs.map fun f => { f with shared := (f.arrays.map (·.1)).filter sharedTables.contains }
  let defs := funs.filter fun f => !f.isTheorem && !f.isProp
  let props := funs.filter fun f => !f.isTheorem && f.isProp
  let thms := funs.filter fun f => f.isTheorem
  h := h.push "/* ---- definitions ---- */"
  for f in defs do h := h.push (printC f) |>.push ""
  h := h.push "/* ---- the requirements (Props), as predicates ---- */"
  for f in props do h := h.push (printC f) |>.push ""
  h := h.push "/* ---- theorem statements, as checks: hypotheses -> conclusion, true in exact arithmetic (here in hk_real) ---- */"
  for f in thms do h := h.push (printC { f with name := Name.mkStr f.name.getPrefix ("check_" ++ f.name.getString!) }) |>.push ""
  h := h.push "#endif"
  IO.FS.createDirAll (outDir ++ "/dot")
  IO.FS.writeFile (outDir ++ "/hashemi_ccc.h") ("\n".intercalate h.toList)
  -- ---- the Modula layer: tangents and boxes of every definition, their Metal wrappers, the manifest
  let designParams : List String := ["R", "f", "a", "w", "rc", "k", "sigmaslope", "sigmaspec", "rho", "hsun",
    "rDrum", "W", "rcm", "Tmax", "Fdrive", "L10", "rodLen", "ym", "hp", "ze", "c", "p"]
  let mods := (defs ++ props).filter fun f => f.inputs.size > 0     -- Props too: three-valued boxes, the subobject's boundary
  let mut mh : Array String := #["/* generated by RequestProject/Ccc.lean (HashemiCcc.lean) from Hashemi.lean - do not edit. */",
    "/* The Modula layer: for every definition, its tangent (hk_<f>_jvp: the value and its",
    "   Jacobian-vector product, the tangent functor on the graph) and its box (hk_<f>_box: interval",
    "   and Lipschitz abstract interpretation, the box functor). Include after hashemi_ccc.h. */",
    "#ifndef HASHEMI_MODULA_H", "#define HASHEMI_MODULA_H", boxRuntime, ""]
  for f in mods do
    mh := mh.push (printCJvp f) |>.push "" |>.push (printCBox f) |>.push ""
  mh := mh.push "#endif"
  IO.FS.writeFile (outDir ++ "/hashemi_modula.h") ("\n".intercalate mh.toList)
  let mut mk : Array String := #["// generated by RequestProject/Ccc.lean (HashemiCcc.lean) - do not edit.",
    "// one thread per sample (jvp) or per box; x/dx/lo/hi/sc are (N, NIN) row-major, y/dy/olo/ohi/oL are (N, NOUT)."]
  let mut mj : Array String := #[]
  for f in mods do
    let c := cName f.name
    let short := c.drop 3
    let nin := f.inputs.size
    let nout := f.output.flatten.size
    let g := f.graph
    let args := ", ".intercalate ((List.range nin).map fun k =>
      let (_, i) := f.inputs[k]!
      if g.isBool i then s!"(tx[{k}] != 0.0f)" else s!"tx[{k}]")
    -- ray tables: one buffer each after the fixed ones, the agent's table by pointer offset
    let na := f.arrays.size
    let arrBufs := fun (b0 : Nat) => ", ".intercalate ((List.range na).map fun j =>
      let (b, _, _) := f.arrays[j]!; s!"device const float* {b}_all [[buffer({b0 + j})]]")
    let arrArgs := ", ".intercalate (f.arrays.toList.map fun (b, P, m) => s!"{b}_all + i * {P * (if m == 0 then 1 else m)}")
    let sep := if na == 0 then "" else ", "
    mk := mk.push s!"kernel void mk_{short}_jvp(device const float* x [[buffer(0)]], device const float* dx [[buffer(1)]], {arrBufs 2}{sep}device float* y [[buffer({2 + na})]], device float* dy [[buffer({3 + na})]], device const int* n [[buffer({4 + na})]], uint i [[thread_position_in_grid]]) \{"
    mk := mk.push s!"  if ((int)i >= n[0]) return;"
    mk := mk.push s!"  float tx[{nin}], tdx[{nin}], ty[{nout}], tdy[{nout}];"
    mk := mk.push s!"  for (int k = 0; k < {nin}; ++k) \{ tx[k] = x[i*{nin}+k]; tdx[k] = dx[i*{nin}+k]; }"
    mk := mk.push s!"  {c}_jvp({args}{sep}{arrArgs}, tdx, ty, tdy);"
    mk := mk.push s!"  for (int k = 0; k < {nout}; ++k) \{ y[i*{nout}+k] = ty[k]; dy[i*{nout}+k] = tdy[k]; }"
    mk := mk.push "}"
    mk := mk.push s!"kernel void mk_{short}_box(device const float* lo [[buffer(0)]], device const float* hi [[buffer(1)]], device const float* sc [[buffer(2)]], {arrBufs 3}{sep}device float* olo [[buffer({3 + na})]], device float* ohi [[buffer({4 + na})]], device float* oL [[buffer({5 + na})]], device const int* n [[buffer({6 + na})]], uint i [[thread_position_in_grid]]) \{"
    mk := mk.push s!"  if ((int)i >= n[0]) return;"
    mk := mk.push s!"  float tlo[{nin}], thi[{nin}], tsc[{nin}], rlo[{nout}], rhi[{nout}], rL[{nout}];"
    mk := mk.push s!"  for (int k = 0; k < {nin}; ++k) \{ tlo[k] = lo[i*{nin}+k]; thi[k] = hi[i*{nin}+k]; tsc[k] = sc[i*{nin}+k]; }"
    mk := mk.push s!"  {c}_box({arrArgs}{sep}tlo, thi, tsc, rlo, rhi, rL);"
    mk := mk.push s!"  for (int k = 0; k < {nout}; ++k) \{ olo[i*{nout}+k] = rlo[k]; ohi[i*{nout}+k] = rhi[k]; oL[i*{nout}+k] = rL[k]; }"
    mk := mk.push "}"
    let inputs := f.inputs.map (·.1)
    let design := inputs.map fun nm => designParams.contains nm
    let mass := (design.filter id).size
    let boolIn := f.inputs.map fun (_, i) => g.isBool i
    let boolOut := f.output.flatten.map fun i => g.isBool i
    let nm := ((f.name.replacePrefix root .anonymous).toString).replace "." "_"
    mj := mj.push ("  {" ++ ", ".intercalate [
      "\"name\": " ++ jsonStr nm, "\"c\": " ++ jsonStr c,
      "\"kernel_jvp\": " ++ jsonStr s!"mk_{short}_jvp", "\"kernel_box\": " ++ jsonStr s!"mk_{short}_box",
      "\"inputs\": [" ++ ", ".intercalate (inputs.toList.map jsonStr) ++ "]",
      "\"design\": [" ++ ", ".intercalate (design.toList.map fun b => if b then "true" else "false") ++ "]",
      "\"bool_inputs\": [" ++ ", ".intercalate (boolIn.toList.map fun b => if b then "true" else "false") ++ "]",
      "\"bool_outputs\": [" ++ ", ".intercalate (boolOut.toList.map fun b => if b then "true" else "false") ++ "]",
      "\"n_in\": " ++ toString nin, "\"n_out\": " ++ toString nout, "\"mass\": " ++ toString mass,
      "\"arrays\": [" ++ ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++ "]",
      "\"n_nodes\": " ++ toString g.nodes.size] ++ "}")
  IO.FS.writeFile (outDir ++ "/hashemi_modula.metal") ("\n".intercalate mk.toList)
  IO.FS.writeFile (outDir ++ "/hashemi_modula.json")
    ("{\n\"design_params\": [" ++ ", ".intercalate (designParams.map jsonStr) ++ "],\n\"composites\": {\"dishPower\": [\"sunInDish\", \"sampleRay\", \"traceRayKErr\"]},\n\"modules\": [\n" ++
     ",\n".intercalate mj.toList ++ "\n]\n}\n")
  logInfo m!"modula: {mods.size} modules (tangent + box), {(mods.filter fun f => (f.inputs.map (·.1)).any designParams.contains).size} with mass"
  -- ---- dot
  for f in funs do
    IO.FS.writeFile (outDir ++ "/dot/" ++ f.name.getString! ++ ".dot") (printDot f)
  -- ---- samples, the Float twin and the round trip
  let mut json : Array String := #[]
  let mut fl : Array String := #["import Std", "namespace HashemiCccFloat", "set_option maxRecDepth 4000",
    "/-- `=` on ℝ, in floating point -/",
    "def feq (a b : Float) : Bool := Float.abs (a - b) <= 1e-9 * max 1.0 (max (Float.abs a) (Float.abs b))", ""]
  -- the round trip names every compiled definition, so it imports the top module of the chain
  let mut rt : Array String := #["import RequestProject.HashemiTraceProps", "import RequestProject.HashemiPolicy", "import RequestProject.HashemiBeamdown", "namespace TandoorHashemi",
    "open Classical", "set_option maxHeartbeats 4000000", "set_option maxRecDepth 8000", ""]
  let mut seed := 7
  for f in funs do
    seed := seed + 1
    let nm := ((f.name.replacePrefix root .anonymous).toString).replace "." "_"
    let inputs := f.inputs.map (·.1)
    let shape := f.output.shape
    let outN := f.output.flatten.size
    -- samples: three vectors
    let mut svs : Array (Array String) := #[]
    let mut avs : Array (Array (Array String)) := #[]      -- [sample][array] the flat table
    for k in [0:3] do
      let mut sv := #[]
      for j in [0:inputs.size] do
        sv := sv.push (sample (seed * 131 + k) j)
      svs := svs.push sv
      let mut av := #[]
      for (_, P, m) in f.arrays do
        let mut tbl := #[]
        for j in [0:P * (if m == 0 then 1 else m)] do
          tbl := tbl.push (sample (seed * 131 + k + 977) (1000 + j))
        av := av.push tbl
      avs := avs.push av
    let kind := if f.isTheorem then "theorem" else if f.isProp then "prop" else "def"
    json := json.push ("  {" ++ ", ".intercalate [
      "\"name\": " ++ jsonStr nm,
      "\"c\": " ++ jsonStr (if f.isTheorem then "hk_check_" ++ nm else cName f.name),
      "\"kind\": " ++ jsonStr kind,
      "\"inputs\": [" ++ ", ".intercalate (inputs.toList.map jsonStr) ++ "]",
      "\"shape\": " ++ jsonStr shape,
      "\"n_out\": " ++ toString outN,
      "\"n_nodes\": " ++ toString f.graph.nodes.size,
      "\"n_hyps\": " ++ toString f.nHyps,
      "\"arrays\": [" ++ ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++ "]",
      "\"array_samples\": [" ++ ", ".intercalate (avs.toList.map fun av => "[" ++ ", ".intercalate (av.toList.map fun tbl => "[" ++ ", ".intercalate tbl.toList ++ "]") ++ "]") ++ "]",
      "\"samples\": [" ++ ", ".intercalate (svs.toList.map fun sv => "[" ++ ", ".intercalate sv.toList ++ "]") ++ "]"] ++ "}")
    -- the Float twin: flattened Float parameters, the output as Float / Bool / Array Float
    let params := " ".intercalate (inputs.toList.map (fun i => s!"({i} : Float)") ++ f.arrays.toList.map fun (b, _, _) => s!"({b} : Array Float)")
    -- printed with `let`s for shared nodes (leanBody): the inline printer is exponential on the mega graphs
    let outs := f.output.flatten
    let (retTy, body) := match f.output with
      | Val.s _ => ("Float", leanBody f false outs f.output "  ")
      | Val.b _ => ("Bool", leanBody f false outs f.output "  ")
      | v => ("Array Float", leanBody f false outs (Val.vec (v.flatten.map Val.s)) "  ")
    let fname := if f.isTheorem then "check_" ++ nm else nm
    let body := if retTy == "Array Float" then body.replace "![" "#[" else body
    fl := fl.push s!"def {fname} {params} : {retTy} :=\n{body}\n"
    for k in [0:svs.size] do
      let sv := svs[k]!
      let tbls := (avs[k]!).toList.map fun tbl => "#[" ++ ", ".intercalate tbl.toList ++ "]"
      let argv := sv.toList ++ tbls
      let call := if argv.isEmpty then fname else fname ++ " " ++ " ".intercalate argv
      let shown := match f.output with
        | Val.s _ => s!"toString ({call}).toBits"
        | Val.b _ => s!"toString ({call})"
        | _ => s!"toString (({call}).map Float.toBits)"
      fl := fl.push s!"#eval IO.println (\"{fname} \" ++ {shown})"
    fl := fl.push ""
    -- the round trip, for definitions with a value shape the ℝ printer can write (theorems: HashemiProps)
    if !f.isTheorem then
      match f.output with
      | .struct .. => pure ()
      | _ =>
        let ref := (f.name.replacePrefix root .anonymous).toString
        -- the 24-fold bisection (`swingOfLength`, and `step`/`megaStep` through it): its `rfl` is a
        -- defeq check on a term that doubles at every level, beyond any heartbeat budget. The step
        -- itself, `bisectStep`, round-trips; the iterate rule is checked on a 3-fold instance below;
        -- the C and Float twins agree on these three at the samples
        if let some fm := (if modularEmit.contains ref then modular[ref]? else none) then
          -- the composite AS A COMPOSITE.  The callees it actually calls are made LOCALLY
          -- IRREDUCIBLE for the theorem: without that, a column whose right-hand side is headed
          -- by `megaStep` sends lazy delta into the 24-fold bisection, while one headed by
          -- arithmetic is safe - which is exactly why the mount columns used to time out and the
          -- ray columns did not.  With it every column is a syntactic match.
          let mut called : Array String := #[]
          for nd in fm.graph.nodes do
            match nd with
            | .call fn _ _ _ _ => unless called.contains fn do called := called.push fn
            | _ => pure ()
          let txt := printRoundTrip fm ref (ref.replace "." "_")
          let binders := " ".intercalate (fm.binders.toList.map (·.1))
          let txt := (txt.dropRight 6) ++ s!":= by\n  funext {binders}\n  rfl"
          rt := rt.push "section"
          rt := rt.push s!"attribute [local irreducible] {" ".intercalate called.toList}"
          rt := rt.push ""
          rt := rt.push txt
          rt := rt.push "end"
          rt := rt.push ""
        else if (stagedCfg ref).isSome then
          -- the bisecting composites: `rfl` on the flattened twin is exponential in the 24 levels,
          -- so the sharing is kept in the proof (see "The staged round trip" above)
          let txt := printRoundTrip f ref (ref.replace "." "_")
          let binders := " ".intercalate (f.binders.toList.map (·.1))
          match stagedProof txt binders (stagedCfg ref).get! with
          | some t => rt := rt.push t |>.push ""
          | none =>
            logInfo m!"staged round trip: no bisection chain found for {ref}"
            rt := rt.push txt |>.push ""
        else if ref == "mlpPolicy" then
          -- a definition whose body is `fun k : Fin n => …` prints as the vector `![…]`, which is
          -- not definitionally that lambda: the round trip is by extensionality, case by case
          let txt := printRoundTrip f ref (ref.replace "." "_")
          let binders := " ".intercalate (f.binders.toList.map (·.1))
          let txt := (txt.dropRight 6) ++ s!":= by\n  funext {binders} k\n  fin_cases k <;> rfl"
          rt := rt.push txt |>.push ""
        else
          rt := rt.push (printRoundTrip f ref (ref.replace "." "_")) |>.push ""
  fl := fl.push "end HashemiCccFloat"
  rt := rt.push "/-- the translator unrolls `f^[n]` into `n` applications: the rule, on a 3-fold instance of the bisection -/"
  rt := rt.push "theorem bisect3_unroll (ym hp a ze L : ℝ) (s : ℝ × ℝ) :"
  rt := rt.push "    (bisectStep ym hp a ze L)^[3] s = bisectStep ym hp a ze L (bisectStep ym hp a ze L (bisectStep ym hp a ze L s)) := rfl"
  rt := rt.push ""
  rt := rt.push "end TandoorHashemi"
  IO.FS.writeFile (leanDir ++ "/HashemiCccFloat.lean") ("\n".intercalate fl.toList)
  -- the NumPy twin
  let mut py : Array String := #["# generated by RequestProject/Ccc.lean from Hashemi.lean - do not edit.",
    "# The same graphs as hashemi_ccc.h, printed for NumPy: the env-side reference twin, vectorised over agents.",
    "import numpy as np", "",
    "def hk_eq(a, b):", "    \"\"\"`=` on ℝ, in floating point\"\"\"",
    "    return np.abs(a - b) <= 1e-9 * np.maximum(1.0, np.maximum(np.abs(a), np.abs(b)))", ""]
  for f in funs do
    let fname := if f.isTheorem then "hk_check_" ++ f.name.getString! else cName f.name
    py := py.push (printNumpy f fname) |>.push ""
  IO.FS.writeFile (outDir ++ "/hashemi_ccc.py") ("\n".intercalate py.toList)
  IO.FS.writeFile (leanDir ++ "/HashemiCccRound.lean") ("\n".intercalate rt.toList)
  -- the megakernel's manifest: column names from `megaNames` (a literal array of strings), the
  -- six functions in order, and the shared input order
  let namesE ← instantiateMVars ((← getConstInfo (root ++ `megaNames)).value?.getD (mkConst `none))
  let cols := strLits namesE
  let megaFns := ["megaStep", "megaGeom", "megaScrew", "megaReqs", "megaThmsClosed", "megaThmsState"]
  let mut megaJson : Array String := #[]
  let mut off := 0
  let mut megaInputs : Array String := #[]
  for mf in megaFns do
    match funs.find? (fun f => f.name.getString! == mf) with
    | some f =>
      let n := f.output.flatten.size
      megaJson := megaJson.push ("  {\"name\": " ++ jsonStr mf ++ ", \"c\": " ++ jsonStr (cName f.name) ++
        ", \"offset\": " ++ toString off ++ ", \"n_out\": " ++ toString n ++ "}")
      off := off + n
      if megaInputs.isEmpty then megaInputs := f.inputs.map (·.1)
    | none => logInfo m!"mega function {mf} did not compile"
  IO.FS.writeFile (outDir ++ "/hashemi_mega.json")
    ("{\n\"columns\": [" ++ ", ".intercalate (cols.toList.map jsonStr) ++ "],\n\"inputs\": [" ++
     ", ".intercalate (megaInputs.toList.map jsonStr) ++ "],\n\"functions\": [\n" ++
     ",\n".intercalate megaJson.toList ++ "\n],\n\"n_columns\": " ++ toString off ++ "\n}\n")
  logInfo m!"mega: {off} columns in the kernel, {cols.size} names"
  -- ---- the env's step as ONE kernel: threadgroup per agent, thread per ray, the sum in shared memory
  let envNamesE ← instantiateMVars ((← getConstInfo (root ++ `envNames)).value?.getD (mkConst `none))
  let envCols := strLits envNamesE
  match funs.find? (fun f => f.name.getString! == "hashemiEnv") with
  | some f =>
    IO.FS.writeFile (outDir ++ "/hashemi_env.metal")
      ("// generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiEnv.lean - do not edit.\n" ++
       "// ONE kernel for the env's step: buffer 0 the scalar inputs (B, n_in), buffer 1 the ray table (B, P, m),\n" ++
       "// buffer 2 the outputs (B, n_out), buffer 3 the count; dispatch B*P threads in groups of P.\n" ++
       printMslMega f "hashemi_env" ++ "\n")
    let L := layers f.graph
    IO.FS.writeFile (outDir ++ "/hashemi_env.json")
      ("{\n\"kernel\": \"hashemi_env\", \"c\": " ++ jsonStr (cName f.name) ++ ",\n\"columns\": [" ++ ", ".intercalate (envCols.toList.map jsonStr) ++ "],\n\"inputs\": [" ++
       ", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr) ++ "],\n\"arrays\": [" ++
       ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++
       "],\n\"n_columns\": " ++ toString f.output.flatten.size ++ ", \"rays\": " ++ toString L.P ++ ", \"n_nodes\": " ++ toString f.graph.nodes.size ++
       ", \"ray_nodes\": " ++ toString (L.ray.filter id).size ++ ", \"sums\": " ++ toString L.sums.size ++ "\n}\n")
    logInfo m!"env: {f.output.flatten.size} columns, {f.graph.nodes.size} nodes ({(L.ray.filter id).size} ray-level, {L.sums.size} sums over {L.P} rays), {envCols.size} names"
  | none => logInfo m!"hashemiEnv did not compile"
  -- ---- the closed loop as one kernel, and the policy's manifest: what the spec says the policy is
  let obsE ← instantiateMVars ((← getConstInfo (root ++ `obsNames)).value?.getD (mkConst `none))
  let actE ← instantiateMVars ((← getConstInfo (root ++ `actionNames)).value?.getD (mkConst `none))
  let loopE ← instantiateMVars ((← getConstInfo (root ++ `loopNames)).value?.getD (mkConst `none))
  match funs.find? (fun f => f.name.getString! == "hashemiLoop") with
  | some f =>
    IO.FS.writeFile (outDir ++ "/hashemi_loop.metal")
      ("// generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiPolicy.lean - do not edit.\n" ++
       "// ONE kernel for the closed loop: buffer 0 the scalar inputs (B, n_in), then the tables in order\n" ++
       "// (W1 (16,8), b1 (16), W2 (2,16) shared by every agent; dr (B, 64, 10) per agent), then the outputs, the count.\n" ++
       printMslMega f "hashemi_loop" ++ "\n")
    let L := layers f.graph
    let arrJson := ", ".intercalate (f.arrays.toList.map fun (b, P, m) =>
      "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++
      ", \"shared\": " ++ (if f.shared.contains b then "true" else "false") ++ "}")
    IO.FS.writeFile (outDir ++ "/hashemi_policy.json")
      ("{\n\"kernel\": \"hashemi_loop\", \"c\": " ++ jsonStr (cName f.name) ++
       ",\n\"obs\": [" ++ ", ".intercalate ((strLits obsE).toList.map jsonStr) ++ "]" ++
       ",\n\"actions\": [" ++ ", ".intercalate ((strLits actE).toList.map jsonStr) ++ "]" ++
       ",\n\"action_levels\": 7, \"motor_heads\": [3, 4]" ++
       ",\n\"columns\": [" ++ ", ".intercalate ((strLits loopE).toList.map jsonStr) ++ "]" ++
       ",\n\"inputs\": [" ++ ", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr) ++ "]" ++
       ",\n\"arrays\": [" ++ arrJson ++ "]" ++
       ",\n\"n_columns\": " ++ toString f.output.flatten.size ++ ", \"rays\": " ++ toString L.P ++
       ", \"n_nodes\": " ++ toString f.graph.nodes.size ++ ", \"ray_nodes\": " ++ toString (L.ray.filter id).size ++
       ", \"sums\": " ++ toString L.sums.size ++ "\n}\n")
    logInfo m!"loop: {f.output.flatten.size} columns, {f.graph.nodes.size} nodes ({(L.ray.filter id).size} ray-level, {L.sums.size} sums), tables {f.arrays.map (·.1)}, shared {f.shared}"
    -- ---- the spaces, as a Python module: the observation Box with the spec's bounds, the command
    -- Box, the seven-level heads, and the head-to-command map - the policy's interface for a trainer
    let obsList := "[" ++ ", ".intercalate ((strLits obsE).toList.map jsonStr) ++ "]"
    let actList := "[" ++ ", ".intercalate ((strLits actE).toList.map jsonStr) ++ "]"
    let pySp : Array String := #[
      "# generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiPolicy.lean - do not edit.",
      "\"\"\"The policy interface of his machine, as the spec states it: one mirror, two motors.",
      "",
      "The observation Box takes its bounds from `obsLo` / `obsHi` (Lean, through the NumPy twin), the",
      "command Box is `[-1, 1]` per motor (`mlpPolicy_bounded`, `follower_bounded`), the heads are the",
      "seven levels of `headToCmd`, and `heads_to_commands` / `commands_to_drives` are the compiled",
      "`headToCmd`, `driveAz`, `driveEl` themselves.\"\"\"",
      "import os, sys",
      "import numpy as np",
      "sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))",
      "import hashemi_ccc as _H",
      "try:",
      "    from gymnasium import spaces as _spaces",
      "except ImportError:                       # pragma: no cover",
      "    from gym import spaces as _spaces",
      "",
      s!"OBS_NAMES = {obsList}",
      s!"ACTION_NAMES = {actList}",
      "ACTION_LEVELS = 7",
      "MOTOR_HEADS = [3, 4]                      # the parent tandoor env's azimuth and elevation heads",
      "N_OBS, N_ACT = len(OBS_NAMES), len(ACTION_NAMES)",
      "OBS_LO = np.asarray(_H.hk_obsLo(), dtype=np.float32).reshape(N_OBS)",
      "OBS_HI = np.asarray(_H.hk_obsHi(), dtype=np.float32).reshape(N_OBS)",
      "AZ_FULL, EL_FULL = float(_H.hk_azFull()), float(_H.hk_elFull())     # rad/s of the dish at full command",
      "",
      "",
      "def observation_space():",
      "    \"\"\"the machine's eight observations, bounded by the spec\"\"\"",
      "    return _spaces.Box(low=OBS_LO, high=OBS_HI, shape=(N_OBS,), dtype=np.float32)",
      "",
      "",
      "def action_space():",
      "    \"\"\"the two commands in [-1, 1]: the roller and the winch at a fraction of full command\"\"\"",
      "    return _spaces.Box(low=-1.0, high=1.0, shape=(N_ACT,), dtype=np.float32)",
      "",
      "",
      "def action_space_heads():",
      "    \"\"\"the same interface through seven-level heads (the parent trainer's kind)\"\"\"",
      "    return _spaces.MultiDiscrete([ACTION_LEVELS] * N_ACT)",
      "",
      "",
      "def heads_to_commands(heads):",
      "    \"\"\"`headToCmd`: (B, 2) head values 0..6 -> commands in [-1, 1]\"\"\"",
      "    h = np.asarray(heads, dtype=np.float64)",
      "    return np.stack([np.asarray(_H.hk_headToCmd(h[..., k]), dtype=np.float64) for k in range(N_ACT)], axis=-1)",
      "",
      "",
      "def commands_to_drives(u, arm, rw=0.05, R=1.2192, rDrum=0.03):",
      "    \"\"\"`driveAz`, `driveEl`: commands (B, 2) -> (omega_m, omega_d) at the wire's lever arm `arm`\"\"\"",
      "    u = np.asarray(u, dtype=np.float64); B = u.shape[0]",
      "    om = np.asarray(_H.hk_driveAz(u[:, 0], np.full(B, rw), np.full(B, R)), dtype=np.float64)",
      "    od = np.asarray(_H.hk_driveEl(u[:, 1], np.asarray(arm, dtype=np.float64), np.full(B, rDrum)), dtype=np.float64)",
      "    return np.stack([om, od], axis=-1)",
      ""]
    IO.FS.writeFile (outDir ++ "/hashemi_policy.py") ("\n".intercalate pySp.toList)
  | none => logInfo m!"hashemiLoop did not compile"
  -- ---- the beam-down receiver's env step: one kernel
  let beamE ← instantiateMVars ((← getConstInfo (root ++ `beamNames)).value?.getD (mkConst `none))
  match funs.find? (fun f => f.name.getString! == "hashemiEnvBeam") with
  | some f =>
    IO.FS.writeFile (outDir ++ "/hashemi_beam.metal")
      ("// generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiBeamdown.lean - do not edit.\n" ++
       "// ONE kernel for the env's step with the hyperboloid beam-down: buffer 0 the scalar inputs, buffer 1 the\n" ++
       "// ray table (B, 64, 10), buffer 2 the outputs (B, 31), buffer 3 the count; dispatch B*64 in groups of 64.\n" ++
       printMslMega f "hashemi_beam" ++ "\n")
    let L := layers f.graph
    IO.FS.writeFile (outDir ++ "/hashemi_beam.json")
      ("{\n\"kernel\": \"hashemi_beam\", \"c\": " ++ jsonStr (cName f.name) ++ ",\n\"columns\": [" ++ ", ".intercalate ((strLits beamE).toList.map jsonStr) ++ "],\n\"inputs\": [" ++
       ", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr) ++ "],\n\"arrays\": [" ++
       ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++
       "],\n\"n_columns\": " ++ toString f.output.flatten.size ++ ", \"rays\": " ++ toString L.P ++ ", \"n_nodes\": " ++ toString f.graph.nodes.size ++
       ", \"ray_nodes\": " ++ toString (L.ray.filter id).size ++ ", \"sums\": " ++ toString L.sums.size ++ "\n}\n")
    logInfo m!"beam: {f.output.flatten.size} columns, {f.graph.nodes.size} nodes ({(L.ray.filter id).size} ray-level, {L.sums.size} sums)"
  | none => logInfo m!"hashemiEnvBeam did not compile"
  let skippedJson := skipped.toList.map fun (n, m) => "  {\"name\": " ++ jsonStr n.getString! ++ ", \"reason\": " ++ jsonStr m ++ "}"
  IO.FS.writeFile (outDir ++ "/hashemi_ccc.json")
    ("{\n\"functions\": [\n" ++ ",\n".intercalate json.toList ++ "\n],\n\"skipped\": [\n" ++
     ",\n".intercalate skippedJson ++ "\n]\n}\n")
  logInfo m!"compiled {funs.size} ({defs.size} definitions, {props.size} props, {thms.size} theorem checks); skipped {skipped.size}"
  for (n, m) in skipped do
    logInfo m!"skipped {n}: {m}"

end HashemiCcc

#eval HashemiCcc.run

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
import RequestProject.HashemiOil
import RequestProject.HashemiEnv
import RequestProject.HashemiWire
import RequestProject.HashemiPolicy
import RequestProject.HashemiBeamdown
import RequestProject.HashemiReward
import RequestProject.HashemiGrade
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
  -- the mount's four constants are FUNCTIONS OF THE SIZE since 2026-09-20 (`dHalf` is
  -- `megaStep`'s own binder), so the staged proof's `show` must name them as the twin prints them
  | "megaStep" => some { ym := "(ymOf dHalf)", hp := "(hpOf dHalf)", aa := "dHalf", ze := "(zeOf dHalf)", t := "t", slack := "slack", ωd := "ωd", rDrum := "rDrum", dt := "dt", unf := ["megaStep", "step"] }
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

/-! ## The grading, emitted beside every kernel

`HashemiGrade.lean` says what a column IS — its subsystem, its kind, its unit, its frame and its
defining declaration.  Three parts of that are DERIVED here rather than written there:

* the **truth** kind, from the compiled graph (`Ccc.Fun.truthCols`: a boolean node, or the
  `if c then 1 else 0` that `b2r` compiles to).  Where a grade is stated the derivation CHECKS it
  and a disagreement throws; where none is stated and the column is an indicator, the grade is
  supplied whole (`omega`, `truth`) — so a theorem added to `megaThmsState` tomorrow is graded
  the day it is added;
* the **declaration**, by looking the column's name up in the environment (`prop_<n>` first: the
  proposition columns are named after their own theorems);
* nothing else.  A column that is neither stated nor an indicator FAILS THE EMIT, and that is the
  gate: `lake build RequestProject.HashemiCcc` errors until it is graded. -/

/-- the declaration a column's name names, if the environment has one -/
def declInEnv (root : Name) (n : String) : MetaM (Option String) := do
  let env ← getEnv
  for c in [root ++ ("prop_" ++ n).toName, root ++ n.toName] do
    if env.contains c then return some c.toString
  return none

def gradeRowJson (n : String) (g : HashemiGrade.Grade) (decl : String) : String :=
  "{" ++ ", ".intercalate [
    "\"name\": " ++ jsonStr n,
    "\"subsystem\": " ++ jsonStr g.sub.name,
    "\"kind\": " ++ jsonStr g.kind.name,
    "\"unit\": " ++ jsonStr g.unit,
    "\"frame\": " ++ jsonStr g.frame.name,
    "\"decl\": " ++ jsonStr decl] ++ "}"

/-- **the grades of one morphism's columns**: the JSON array that goes beside its kernel, and the
truth mask the box printer acted on.  Throws when the names do not line up with the columns, when
a column has no grade, or when the stated kind and the graph disagree. -/
def gradesOf (root : Name) (who : String) (cols : Array String) (truth : Array Bool) :
    MetaM (String × String) := do
  unless cols.size == truth.size do
    throwError "{who}: {cols.size} column NAMES for {truth.size} columns - the names do not line up"
  let mut rows : Array String := #[]
  for k in [0:cols.size] do
    let n := cols[k]!
    let isT := truth[k]!
    let saw := if isT then "an indicator" else "a real"
    let g : HashemiGrade.Grade ← match HashemiGrade.lookup n with
      | some g =>
        if (g.kind == HashemiGrade.Kind.truth) != isT then
          throwError "{who}: the column {n} is graded '{g.kind.name}' and the graph says it is {saw} - one of the two is wrong"
        else pure g
      | none =>
        if !isT then
          throwError "{who}: the column {n} has NO GRADE. Give it one in HashemiGrade.rows (subsystem, kind, unit, frame); a column without a grade is not emitted."
        else pure { sub := .omega, kind := .truth, unit := "", frame := .none, decl := "" }
    let decl ← match g.decl with
      | "" => do
        match ← declInEnv root (HashemiGrade.base n) with
        | some d => pure d
        | none => pure (root ++ who.toName).toString
      | d => pure (if d.any (· == '.') then d else (root ++ d.toName).toString)
    rows := rows.push ("  " ++ gradeRowJson n g decl)
  let truthJson := ", ".intercalate (truth.toList.map fun b => if b then "true" else "false")
  return ("[\n" ++ ",\n".intercalate rows.toList ++ "]", "[" ++ truthJson ++ "]")

-- the wrapper's fixed text is one long list literal: it nests as deep as it is long
set_option maxRecDepth 20000

/-! ## The env wrapper, printed from the same manifests as the kernels

`hashemi_tandoor_env.py` was the last hand-written surface of this directory, and every defect
found in the week of 2026-09-14 lived in it and in nothing compiled: the pointing shaping entered
the trainer raw on one path and divided by `reward_div` on the other (75x); the exchanger's
conductance was a bare `60.0` with no law anywhere, binding on 99.9 % of a day's steps; the
dish's conic constant was pinned in Python at the favourable end of the spec's own interval; the
scene's inputs were pooled on a host instead of composed in the graph; the exchanger's node
profile was inherited by accident from the parent env's tri chain.  Each is the same defect: a
number or a formula written twice, once per path, by hand.

So the wrapper is printed too, beside the kernels, from these tables and the manifests those
kernels already carry - and ONCE for both paths, because what differs between the parent's NumPy
step and its fused Metal step is a backend object and nothing else.  `hashemi_harness.py` beside
it is the hand-written half: the subclass of the parent tandoor env, its hooks, its heads, its
device plumbing and its window - the PARENT's contract, which no manifest of Hashemi.lean can
state.

The tables below are the wrapper's whole content: which input of the compiled morphism is bound
from which source each step (every input NOT named here is a parameter of the machine, computed
as a set difference in the module and checked to be a partition at its import), which columns are
the state and the two fields along the pipe, which the host mirrors, and how the reward's inputs
are composed.  `run` checks every one of them against the compiled `hashemiEnv`,
`hashemiEnvBeam` and `rewardStep` before printing: a rename in the spec is an error HERE, not a
silent zero in a trainer. -/

/-- the env kernel's inputs bound per step, and the source `Machine._derive` gives each -/
def envBind : List (String × String) :=
  [("az", "state_az"), ("t", "state_t"), ("slack", "state_slack"),
   ("omegam", "drive_az"), ("omegad", "drive_el"),
   ("dt", "dt"),
   ("elSun", "sun_el"), ("azSun", "sun_az"), ("dni", "dni"), ("soil", "soil"),
   ("Twall", "t_wall"), ("Ta", "t_amb"),
   ("uPump", "u_pump"), ("Vw", "wind"), ("degPrev", "deg"),
   ("UAxMax", "ua_gated")]

/-- the same for the beam-down receiver's kernel: no loop, so no wall and no ceiling -/
def beamBind : List (String × String) :=
  [("az", "state_az"), ("t", "state_t"), ("slack", "state_slack"),
   ("omegam", "drive_az"), ("omegad", "drive_el"),
   ("dt", "dt"),
   ("elSun", "sun_el"), ("azSun", "sun_az"), ("dni", "dni"), ("soil", "soil")]

/-- the state the wrapper carries between steps IS three of the kernel's own columns -/
def stateWrite : List (String × String) :=
  [("state_az", "az_next"), ("state_t", "t_next"), ("state_slack", "slack_next")]

/-- the two fields along the pipe (`HashemiField.shift`), by the prefix their columns carry -/
def tableWrite : List (String × String) := [("hist", "hist_"), ("ret", "ret_")]

/-- the columns the host keeps a mirror of, and what the wrapper calls each.  `oil` marks one
that only the loop receiver's kernel carries. -/
def mirrorCols : List (String × String × String) :=
  [("cap_traced", "capture", "both"), ("arm", "arm", "both"), ("p_in", "p_in", "both"),
   ("per_dni", "per_dni", "both"), ("pointing_err", "pointing_err", "both"),
   ("sun_reachable", "sun_reachable", "both"), ("lost_sun_s", "lost_sun_s", "both"),
   ("t_oil", "T_oil", "oil"), ("q_pot", "q_pot", "oil"), ("deg", "deg", "oil"),
   ("p_pump", "p_pump", "oil"), ("film_margin", "film_margin", "oil")]

/-- `rewardStep`'s inputs.  `col:` reads the env row by name, `excess:` the negative part of one,
`?0` is zero where the receiver's kernel has no such column; the rest the harness hands over.
This table is why `reward_div` is applied once, inside the printed morphism. -/
def rewardBind : List (String × String) :=
  [("parentRaw", "parent_raw"), ("dt", "dt"),
   ("pIn", "col:p_in"), ("reach", "col:sun_reachable"),
   ("rewardDiv", "reward_div"), ("capShaping", "cap_shaping"),
   ("rotiReward", "roti_reward"), ("rotiEnergy", "roti_energy"),
   ("pPump", "col:p_pump?0"), ("filmExcess", "excess:film_margin?0"),
   ("pumpPrice", "pump_price"), ("degPrice", "deg_price")]

/-- the mirrors the parent's own readers know by an attribute of the env -/
def publishAttrs : List (String × String) :=
  [("cap_traced", "cap_traced"), ("t_oil", "t_oil"), ("deg", "deg"),
   ("_q_pot", "q_pot"), ("_p_pump", "p_pump")]

/-- a table of pairs, as the wrapper's own Python -/
def pyPairs (name : String) (xs : List (String × String)) : List String :=
  [name ++ " = ("] ++ xs.map (fun (a, b) => "    (" ++ jsonStr a ++ ", " ++ jsonStr b ++ "),")
    ++ [")"]

/-- a table of triples -/
def pyTriples (name : String) (xs : List (String × String × String)) : List String :=
  [name ++ " = ("]
    ++ xs.map (fun (a, b, c) => "    (" ++ jsonStr a ++ ", " ++ jsonStr b ++ ", " ++ jsonStr c ++ "),")
    ++ [")"]

/-- the generated wrapper, line by line: the fixed text of the module with the
tables above spliced in, so a rename in the spec moves them and nothing else. -/
def wrapperPy : List String :=
  ["# generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiEnv.lean, HashemiReward.lean"
   , "# and HashemiPolicy.lean - do not edit."
   , "\"\"\"The wrapper of his machine onto the tandoor, GENERATED from the kernels' own manifests."
   , ""
   , "Every kernel of this directory is printed from Lean by one driver.  Until this module the ONE"
   , "hand-written layer left was the wrapper, and every defect of the week lived there and nowhere in"
   , "anything compiled: the pointing shaping entered raw on one path and divided on the other (75x);"
   , "the exchanger's conductance was a bare `60.0` with no law behind it, binding on 99.9 % of steps;"
   , "the dish's conic constant was pinned in Python at the favourable end of the spec's own interval;"
   , "the scene's inputs were pooled on a host instead of composed in the graph; the exchanger's node"
   , "profile was inherited by accident from the parent env's tri chain.  They are all the same defect:"
   , "a number or a formula written twice, once per path, by hand."
   , ""
   , "So the wrapper is printed too, and it is printed ONCE for BOTH paths.  `Machine.step` is a single"
   , "method; `Backend` is the only thing that differs between the parent's NumPy step and its fused"
   , "Metal step.  The row the kernel is handed, the columns read back out of it, the state written"
   , "back, the reward composed, the observation gathered - each is ONE table in this file, executed by"
   , "both paths.  Nothing here can disagree with itself about units, because there is no second copy."
   , ""
   , "NOTHING IS ADDRESSED BY INDEX.  Columns and inputs are resolved by name out of the manifests"
   , "(`hashemi_env.json`, `hashemi_reward.json`, `hashemi_policy.json`, `hashemi_beam.json`); the two"
   , "pipe histories are found by their name pattern, not by a length; the parameters of the machine"
   , "are exactly the kernel inputs this file does not bind, computed as a set difference and CHECKED"
   , "to be a partition at import.  When the graded manifest lands (`\"grades\"` beside `\"columns\"`, and"
   , "`hashemi_grade.py`), `Cols.by_grade` selects on the grade; until then it says so instead of"
   , "guessing, and everything else works off the names it already has."
   , ""
   , "WHAT IS HAND-WRITTEN, and why it cannot be generated: `hashemi_harness.py` - the subclass of the"
   , "parent tandoor env (its ini kwargs, its heads, its beam gate, its guillotine and resync, the"
   , "torch/Metal device plumbing, the pufferlib contract, the render window).  That is the PARENT's"
   , "contract, not this spec's: no manifest of Hashemi.lean mentions it, and it changes when the"
   , "tandoor env changes.  The harness carries no law and no constant of the machine; it hands this"
   , "module the parent's own quantities by name and takes back the columns."
   , "\"\"\""
   , "import json"
   , "import os"
   , "import sys"
   , ""
   , "import numpy as np"
   , ""
   , "HERE = os.path.dirname(os.path.abspath(__file__))"
   , "TUT = os.path.dirname(HERE)"
   , "ROOT = os.path.dirname(TUT)"
   , "for _p in (ROOT, TUT, HERE):"
   , "    if _p not in sys.path:"
   , "        sys.path.insert(0, _p)"
   , ""
   , "import hashemi_ccc as H                                                      # noqa: E402"
   , "import hashemi_policy as machine_policy                                      # noqa: E402"
   , "from hashemi_env_kernel import (HashemiEnvMetal, draws, env_numpy, env_params,  # noqa: E402"
   , "                                exch_ua, PUMP_PRICE, DEG_PRICE)"
   , "from hashemi_reward_kernel import HashemiRewardMetal, reward_numpy           # noqa: E402"
   , ""
   , "LEAN_DIR = os.environ.get(\"HASHEMI_LEAN_DIR\", os.path.expanduser(\"~/manifold-pareto/lean\"))"
   , ""
   , ""
   , "# --------------------------------------------------------------------------- the manifests"
   , "class Cols:"
   , "    \"\"\"one compiled kernel's manifest, addressed BY NAME."
   , ""
   , "    `m[\"p_in\"]` is the column, `m.inp(\"UAxMax\")` the input, `m.like(\"hist_\")` the columns of a"
   , "    named table in their own order (so no length is ever written down).  `by_grade` defers to the"
   , "    graded manifest (`hashemi_grade.py`, `\"grades\"` parallel to `\"columns\"`) and raises a clear"
   , "    message while that is still being emitted.\"\"\""
   , ""
   , "    def __init__(self, stem):"
   , "        self.stem = stem"
   , "        self.man = json.load(open(os.path.join(HERE, stem + \".json\")))"
   , "        self.columns = list(self.man[\"columns\"])"
   , "        self.inputs = list(self.man.get(\"inputs\", []))"
   , "        self.arrays = list(self.man.get(\"arrays\", []))"
   , "        self._c = {n: i for i, n in enumerate(self.columns)}"
   , "        self._i = {n: i for i, n in enumerate(self.inputs)}"
   , ""
   , "    # -- columns"
   , "    def __contains__(self, n):"
   , "        return n in self._c"
   , ""
   , "    def __getitem__(self, n):"
   , "        return self._c[n]"
   , ""
   , "    def get(self, n, default=None):"
   , "        return self._c.get(n, default)"
   , ""
   , "    def many(self, names):"
   , "        return [self._c[n] for n in names]"
   , ""
   , "    def like(self, prefix):"
   , "        \"\"\"the columns `<prefix><k>`, k = 0, 1, 2, ... in order - a table's width is its own\"\"\""
   , "        out, k = [], 0"
   , "        while (prefix + str(k)) in self._c:"
   , "            out.append(self._c[prefix + str(k)])"
   , "            k += 1"
   , "        return out"
   , ""
   , "    # -- inputs"
   , "    def inp(self, n):"
   , "        return self._i[n]"
   , ""
   , "    def has_input(self, n):"
   , "        return n in self._i"
   , ""
   , "    @property"
   , "    def n_in(self):"
   , "        return len(self.inputs)"
   , ""
   , "    @property"
   , "    def n_out(self):"
   , "        return int(self.man[\"n_columns\"])"
   , ""
   , "    def table(self, name):"
   , "        for a in self.arrays:"
   , "            if a[\"name\"] == name:"
   , "                return a"
   , "        raise KeyError(\"%s has no table %r\" % (self.stem, name))"
   , ""
   , "    # -- the grades (a36a754's manifest: \"grades\" parallel to \"columns\", and hashemi_grade.py)"
   , "    def by_grade(self, **sel):"
   , "        try:"
   , "            import hashemi_grade"
   , "        except ImportError:"
   , "            hashemi_grade = None"
   , "        if hashemi_grade is None or \"grades\" not in self.man:"
   , "            raise RuntimeError(\"manifest %s carries no grades: rebuild RequestProject.HashemiCcc\""
   , "                               % self.stem)"
   , "        return hashemi_grade.cols_of(self.man, **sel)"
   , ""
   , "    def grade(self, name):"
   , "        try:"
   , "            import hashemi_grade"
   , "        except ImportError:"
   , "            raise RuntimeError(\"manifest %s carries no grades: rebuild RequestProject.HashemiCcc\""
   , "                               % self.stem)"
   , "        return hashemi_grade.grade_of(self.man, name)"
   , ""
   , ""
   , "ENV = Cols(\"hashemi_env\")"
   , "REWARD = Cols(\"hashemi_reward\")"
   , "BEAM = Cols(\"hashemi_beam\")"
   , "MEGA = Cols(\"hashemi_mega\")"
   , "POLICY = json.load(open(os.path.join(HERE, \"hashemi_policy.json\")))"
   , "HEAD_AZ, HEAD_EL = POLICY[\"motor_heads\"]"
   , "ACTION_LEVELS = int(POLICY[\"action_levels\"])"
   , "OBS_NAMES = list(machine_policy.OBS_NAMES)"
   , "# the two full-command rates of the spec (`azFull`, `elFull`), from the compiled twin"
   , "AZ_FULL, EL_FULL = float(H.hk_azFull()), float(H.hk_elFull())"
   , ""
   , ""
   , "def kernel_of(receiver):"
   , "    \"\"\"the compiled env step of a receiver: the oil loop's, or the hyperboloid beam-down's\"\"\""
   , "    return BEAM if receiver == \"beam\" else ENV"
   , ""
   , ""
   , "# --------------------------------------------------------------- ONE description, both paths"
   , "#"
   , "# THE KERNEL'S INPUT ROW.  Left: the input, as the compiled morphism names it.  Right: the source,"
   , "# as this module names it - either a quantity the harness hands over (the parent's own) or one"
   , "# `_derive` computes below from the compiled twin.  Every input of the manifest that is NOT in"
   , "# this table is a PARAMETER of the machine (`Machine.params`), and `_partition` checks at import"
   , "# that the two sets are disjoint and cover the manifest: an input added in Lean and forgotten"
   , "# here is an error at import, not a silent zero."
   ]
 ++
  pyPairs "ENV_BIND" envBind
 ++
  pyPairs "BEAM_BIND" beamBind
 ++
  ["# the state the wrapper carries between steps IS three of the kernel's own columns"
   ]
 ++
  pyPairs "STATE_WRITE" stateWrite
 ++
  ["# the two fields along the pipe, written back into the tables the kernel reads next step"
   ]
 ++
  pyPairs "TABLE_WRITE" tableWrite
 ++
  ["# the columns the host keeps a mirror of, and the attribute the parent's readers know them by."
   , "# `oil` marks a column only the loop receiver's kernel carries."
   ]
 ++
  pyTriples "MIRROR" mirrorCols
 ++
  ["# THE REWARD, in the printed morphism's own units.  `col:` reads the env row by name, `excess:`"
   , "# the negative part of one (the film's margin below its limit), `?0` is zero when the receiver's"
   , "# kernel does not carry that column; everything else is a quantity the harness hands over.  Both"
   , "# paths execute THIS table: `reward_div` is applied once, inside `rewardStep`, and the 75x of"
   , "# 2026-09-19 cannot recur because there is no second expression to disagree with."
   ]
 ++
  pyPairs "REWARD_BIND" rewardBind
 ++
  [""
   , ""
   , "def _partition(cols, bind, extra=()):"
   , "    \"\"\"the inputs this module binds per step, and the rest - the machine's parameters."
   , ""
   , "    A partition, checked: an input of the compiled morphism is either bound from a source above"
   , "    or a parameter, never both and never neither.\"\"\""
   , "    bound = [n for n, _ in bind]"
   , "    dup = [n for n in bound if bound.count(n) > 1]"
   , "    if dup:"
   , "        raise RuntimeError(\"%s: bound twice: %s\" % (cols.stem, sorted(set(dup))))"
   , "    unknown = [n for n in bound if not cols.has_input(n)]"
   , "    if unknown:"
   , "        raise RuntimeError(\"%s: bound inputs that the kernel does not take: %s\" % (cols.stem, unknown))"
   , "    params = [n for n in cols.inputs if n not in bound]"
   , "    missing = [n for n in params if n not in extra]"
   , "    return params, missing"
   , ""
   , ""
   , "PARAM_INPUTS, _ = _partition(ENV, ENV_BIND)"
   , "BEAM_PARAM_INPUTS, _ = _partition(BEAM, BEAM_BIND)"
   , ""
   , ""
   , "# --------------------------------------------------------------------------- the two backends"
   , "class _Back:"
   , "    \"\"\"the only thing that differs between the parent's NumPy step and its fused Metal step\"\"\""
   , ""
   , "    numpy = True"
   , "    tag = \"np\""
   , ""
   , "    def __init__(self, device=None):"
   , "        self.device = device"
   , ""
   , "    def zeros(self, shape, fill=0.0):"
   , "        return np.full(shape, fill, dtype=np.float64)"
   , ""
   , "    def put(self, x, j, v):"
   , "        x[:, j] = v"
   , ""
   , "    def take(self, row, j):"
   , "        return row[:, j]"
   , ""
   , "    def zeros_like(self, v):"
   , "        return np.zeros_like(v)"
   , ""
   , "    def where(self, c, a, b):"
   , "        return np.where(c, a, b)"
   , ""
   , "    def clamp(self, v, lo, hi):"
   , "        # min (max v lo) hi, the shape `headToCmd` is printed in"
   , "        return np.minimum(np.maximum(v, lo), hi)"
   , ""
   , "    def clamp_min(self, v, lo):"
   , "        return np.maximum(v, lo)"
   , ""
   , "    def gt(self, v, x):"
   , "        return v > x"
   , ""
   , "    def indicator(self, c):"
   , "        \"\"\"a gate as a number: the exchanger's ceiling opens with the parent's beam gate\"\"\""
   , "        return np.asarray(c, dtype=np.float64)"
   , ""
   , "    def neg_part(self, v):"
   , "        return np.maximum(0.0, -v)"
   , ""
   , "    def full(self, ref, value):"
   , "        return np.full(ref.shape[0], value, dtype=np.float64)"
   , ""
   , "    def copy(self, v):"
   , "        return np.array(v, dtype=np.float64)"
   , ""
   , "    def host(self, v):"
   , "        return np.asarray(v, dtype=np.float64)"
   , ""
   , ""
   , "class _TorchBack(_Back):"
   , "    numpy = False"
   , "    tag = \"mps\""
   , ""
   , "    def __init__(self, device):"
   , "        import torch"
   , "        self.torch = torch"
   , "        self.device = device"
   , ""
   , "    def zeros(self, shape, fill=0.0):"
   , "        return self.torch.full(shape, float(fill), dtype=self.torch.float32, device=self.device)"
   , ""
   , "    def zeros_like(self, v):"
   , "        return self.torch.zeros_like(v)"
   , ""
   , "    def where(self, c, a, b):"
   , "        return self.torch.where(c, a, b)"
   , ""
   , "    def clamp(self, v, lo, hi):"
   , "        return v.clamp(lo, hi)"
   , ""
   , "    def clamp_min(self, v, lo):"
   , "        return v.clamp_min(lo)"
   , ""
   , "    def indicator(self, c):"
   , "        return c.float()"
   , ""
   , "    def neg_part(self, v):"
   , "        return (-v).clamp_min(0.0)"
   , ""
   , "    def full(self, ref, value):"
   , "        return self.torch.full_like(ref if ref.dim() == 1 else ref[:, 0], float(value))"
   , ""
   , "    def copy(self, v):"
   , "        return v.clone()"
   , ""
   , "    def host(self, v):"
   , "        return v.detach().cpu().numpy().astype(np.float64)"
   , ""
   , ""
   , "# ------------------------------------------------------------------- the machine's parameters"
   , "def machine_name(a, design=False):"
   , "    \"\"\"`hashemi_machine_0.8.json`, `hashemi_machine_2.0_designed.json`\"\"\""
   , "    s = \"%g\" % float(a)"
   , "    return (\"hashemi_machine_\" + (s if \".\" in s else s + \".0\")"
   , "            + (\"_designed\" if design else \"\") + \".json\")"
   , ""
   , ""
   , "def load_machine(a, design=False):"
   , "    \"\"\"THE MACHINE AT HALF-SIDE `a`, DERIVED IN LEAN (RequestProject/HashemiScale.lean)."
   , ""
   , "    Reads the shipped file; if there is none, asks Lean for it (`lake exe machine_scale <a>"
   , "    <path>`), which is the only thing allowed to compute it.  `design=True` is the same"
   , "    derivation with the held quantities solved from the constraints that name them.\"\"\""
   , "    path = os.path.join(HERE, machine_name(a, design))"
   , "    if not os.path.exists(path):"
   , "        import subprocess"
   , "        r = subprocess.run([\"lake\", \"exe\", \"machine_scale\", \"%g\" % float(a), path]"
   , "                           + ([\"--design\"] if design else []),"
   , "                           cwd=LEAN_DIR, capture_output=True, text=True)"
   , "        if r.returncode != 0 or not os.path.exists(path):"
   , "            raise RuntimeError(\"no %s and `lake exe machine_scale` failed in %s:\\n%s\\n%s\""
   , "                               % (os.path.basename(path), LEAN_DIR, r.stdout, r.stderr))"
   , "    return json.load(open(path))"
   , ""
   , ""
   , "def apply_machine(params, m, a, design, cols, log=print):"
   , "    \"\"\"the machine file into the kernel's parameters, BY NAME."
   , ""
   , "    Which of the file's fields are parameters is not a list here: it is the manifest's own input"
   , "    names.  `UAxMax` is the spec's `uaExch` at this machine's buried coil (it was a hand-written"
   , "    60.0, measured binding on 99.9 % of a day's steps).\"\"\""
   , "    for block in (\"kernel\", \"mount\", \"loop\"):"
   , "        for kk, vv in (m.get(block) or {}).items():"
   , "            if cols.has_input(kk):"
   , "                params[kk] = vv"
   , "    if cols.has_input(\"UAxMax\"):"
   , "        params[\"UAxMax\"] = exch_ua(os.path.join(HERE, machine_name(a, design)))"
   , "        log(\"  [hashemi_ccc] the exchanger conducts %.2f W/K (uaExch, the coil in the liner)\""
   , "            % params[\"UAxMax\"])"
   , "    if m.get(\"designed\") and m.get(\"design_changes\"):"
   , "        log(\"  [hashemi_ccc] the machine at a=%s is DESIGNED: \" % a"
   , "            + \", \".join(\"%s %g -> %g (%s)\" % (c[\"held\"], c[\"from\"], c[\"to\"], c[\"constraint\"])"
   , "                        for c in m[\"design_changes\"]))"
   , "    bad = {k: v for k, v in m.get(\"constraints\", {}).items() if v != \"holds\"}"
   , "    if bad:"
   , "        log(\"  [hashemi_ccc] the machine at a=%s does not satisfy the spec: \" % a"
   , "            + \", \".join(\"%s: %s\" % (k, v) for k, v in bad.items()))"
   , "    return params"
   , ""
   , ""
   , "# the pose the mount's own constants are read at: parked, no command, the sun anywhere.  `dt` is"
   , "# 1 s and not 0 because the loop's columns divide by it; the mount's do not depend on it at zero"
   , "# command, so the pose is the rest pose either way."
   , "MOUNT_REST_POSE = dict(dt=1.0, elSun=0.5, azSun=0.0, dni=800.0, soil=1.0, Twall=300.0, Ta=300.0)"
   , "# what the wrapper calls each, and the mount column it is"
   , "MOUNT_REST_COLS = ((\"t_dead\", \"mount_t_dead\"), (\"roller_R\", \"mount_rollerRadius\"),"
   , "                   (\"arm_rest\", \"mount_arm\"), (\"dish_side\", \"mount_dishSide\"))"
   , ""
   , ""
   , "# the mount kernel's own pose inputs; everything else it takes is a dimension or a parameter"
   , "MOUNT_POSE = dict(az=0.0, t=0.0, slack=0.0, omegam=0.0, omegad=0.0, dt=0.0,"
   , "                  elSun=0.5, azSun=0.0, dni=800.0)"
   , "# the dimensions the mount has taken as arguments, and the optics input each one is"
   , "MOUNT_DIM_OF = ((\"dHalf\", \"a\"), (\"wFacet\", \"w\"), (\"rCoil\", \"rc\"))"
   , ""
   , ""
   , "def mount_held():"
   , "    \"\"\"the mount kernel at ITS OWN parameters and the SPEC's own dimensions."
   , ""
   , "    This is the constant set the hand-written wrapper read (one launch of the mount kernel at"
   , "    `megaParams`, which carries no dimension), and it is what `mount_dims=\"held\"` means.  It is"
   , "    assembled from `hashemi_mega.json` - the parameters are the kernel's inputs that are not the"
   , "    pose, in its own order, and the dimensions it has since taken as arguments are the spec's own"
   , "    optics inputs - so it does not go stale when the mount takes another one.\"\"\""
   , "    prm = np.asarray(H.hk_megaParams(), dtype=np.float64).ravel()"
   , "    names = [n for n in MEGA.inputs if n not in MOUNT_POSE]"
   , "    vals = dict(zip(names[:prm.size], prm))"
   , "    opt = env_params()"
   , "    for n, src in MOUNT_DIM_OF:"
   , "        if n in names and n not in vals:"
   , "            vals[n] = float(opt[src])"
   , "    missing = [n for n in names if n not in vals]"
   , "    if missing:"
   , "        raise RuntimeError(\"the mount kernel takes %s and this module has no source for them\""
   , "                           % missing)"
   , "    args = [np.array([float(MOUNT_POSE.get(n, vals.get(n, 0.0)))]) for n in MEGA.inputs]"
   , "    out = {}"
   , "    with np.errstate(all=\"ignore\"):"
   , "        for f in MEGA.man[\"functions\"]:"
   , "            v = np.asarray(getattr(H, f[\"c\"])(*args), dtype=np.float64).reshape(1, f[\"n_out\"])"
   , "            for k, c in MOUNT_REST_COLS:"
   , "                j = MEGA[c[len(\"mount_\"):]] if c.startswith(\"mount_\") else MEGA[c]"
   , "                if f[\"offset\"] <= j < f[\"offset\"] + f[\"n_out\"]:"
   , "                    out[k] = float(v[0, j - f[\"offset\"]])"
   , "    return out"
   , ""
   , ""
   , "def mount_rest(params=None):"
   , "    \"\"\"the mount's own constants, read from THE ENV MORPHISM'S OWN COLUMNS at the parked pose."
   , ""
   , "    `t_dead` is the dead point the parent's `el_min` is set to, `mount_rollerRadius` and"
   , "    `mount_arm` (`wireLever` at rest) are what the drives are scaled by.  They are read out of"
   , "    `hashemiEnv` itself - one launch of the twin at zero command - and not out of a second,"
   , "    separately packed launch of the mount kernel: the env carries the whole mount under"
   , "    `mountNames`, so these are the very numbers the step will use, at the literals it uses."
   , "    (Until 2026-09-20 they came from a hand-packed `mega_numpy` call, which silently went stale"
   , "    the moment the mount took its dimensions as arguments.)\"\"\""
   , "    prm = dict(env_params() if params is None else params)"
   , "    x = np.zeros((1, ENV.n_in))"
   , "    for n in ENV.inputs:"
   , "        x[0, ENV.inp(n)] = float(prm.get(n, MOUNT_REST_POSE.get(n, 0.0)))"
   , "    w = len(ENV.like(\"hist_\"))"
   , "    hist = np.full((1, w), MOUNT_REST_POSE[\"Ta\"])"
   , "    dr = np.full((1, ENV_RAYS, ENV.table(\"dr\")[\"m\"]), 0.5)"
   , "    with np.errstate(all=\"ignore\"):"
   , "        row = env_numpy(x, hist, hist.copy(), dr)"
   , "    return {k: float(row[0, ENV[c]]) for k, c in MOUNT_REST_COLS}"
   , ""
   , ""
   , "# the columns the parent's own readers know by an attribute of the env (the machine's, never the"
   , "# parent's own `p_in`): the harness publishes these and nothing else."
   ]
 ++
  pyPairs "PUBLISH" publishAttrs
 ++
  ["ENV_RAYS = int(ENV.man[\"rays\"])"
   , ""
   , ""
   , "# ------------------------------------------------------------------------- the spaces (spec's)"
   , "def observation_space():"
   , "    \"\"\"the machine's observations, bounded by the spec (`obsLo` / `obsHi`)\"\"\""
   , "    return machine_policy.observation_space()"
   , ""
   , ""
   , "def action_space():"
   , "    \"\"\"the machine's commands in [-1, 1] per motor\"\"\""
   , "    return machine_policy.action_space()"
   , ""
   , ""
   , "# ------------------------------------------------------------------------------- the machine"
   , "class Machine:"
   , "    \"\"\"his machine inside the tandoor env: one compiled morphism, run on either backend."
   , ""
   , "    The harness constructs one of these and hands it the parent's own quantities each step"
   , "    (`ctx`); everything else - the commands the heads mean, the pump's fraction, the wall the"
   , "    exchanger sees, the row, the columns, the state, the reward - is this class, and this class"
   , "    has one copy of each.\"\"\""
   , ""
   , "    def __init__(self, B, dt, receiver=\"oil\", t_amb=300.0, oil_nodes=8, n_nodes=None, n_belt=None,"
   , "                 dish_half=None, dish_design=1, dish_k=None, dish_R=None, beam_design=None,"
   , "                 mount_dims=\"held\", log=print):"
   , "        self.B, self.dt, self.receiver = int(B), float(dt), str(receiver)"
   , "        self.t_amb = float(t_amb)"
   , "        self.cols = kernel_of(self.receiver)"
   , "        self.oil = self.receiver != \"beam\""
   , "        self.oil_nodes, self.n_nodes, self.n_belt = int(oil_nodes), n_nodes, n_belt"
   , "        self.log = log"
   , "        self.params = env_params()"
   , "        if dish_k is not None and self.cols.has_input(\"k\"):"
   , "            self.params[\"k\"] = float(np.clip(float(dish_k), -1.0, 0.0))"
   , "        self.beam_design = dict(beam_design or {})"
   , "        self.machine = None"
   , "        self.dish_design = int(dish_design)"
   , "        self.r_drive = 0.05          # `Hashemi.carriage.rDrive`, replaced by the machine's own"
   , "        if dish_half is not None:"
   , "            m = load_machine(float(dish_half), design=bool(self.dish_design))"
   , "            apply_machine(self.params, m, dish_half, bool(self.dish_design), self.cols, log=log)"
   , "            self.machine = m"
   , "            self.r_drive = float(m[\"machine\"].get(\"rDrive\", self.r_drive))"
   , "            for kk in (\"a\", \"R\", \"f\"):"
   , "                if kk in m[\"kernel\"]:"
   , "                    self.beam_design[kk] = m[\"kernel\"][kk]"
   , "            if dish_R is not None:"
   , "                R = float(dish_R)"
   , "                self.params.update(R=R, f=R / 2.0)"
   , "                self.beam_design.update(R=R, f=R / 2.0)"
   , "        for kk, vv in self.beam_design.items():"
   , "            if self.cols.has_input(kk):"
   , "                self.params[kk] = vv"
   , "        self.dish_area = (2.0 * float(self.params[\"a\"])) ** 2"
   , "        # THE MOUNT'S DIMENSIONS, and what a full command therefore means.  The mount takes its own"
   , "        # dimensions as arguments now (`dHalf`, `wFacet`, `rCoil`), so the ring rail's radius and"
   , "        # the wire's lever arm are no longer his 1.22 m and 1.03 m at every size: at a = 2 m the"
   , "        # ring is 3.05 m.  The drive is `driveAz u rw R = u azFull R / rw`, and the kernel turns"
   , "        # that back into the dish's rate with ITS OWN ring, so which `R` the wrapper drives with"
   , "        # decides what a full command does:"
   , "        #   \"held\"    - the mount at the SPEC'S OWN machine.  That is what the hand-written"
   , "        #     wrapper's separately packed `mega_numpy` call returned at any size, so it is what"
   , "        #     every measured day and every checkpoint was made with.  MEASURED at a = 2 m: the"
   , "        #     dish then turns at 0.0140 deg/s at full command, while the parent env's `RATE_AZ`,"
   , "        #     the cook's follower and the policy all believe it turns at 0.035."
   , "        #   \"machine\" - the mount at THIS machine's dimensions (its own `mount_rollerRadius`"
   , "        #     column).  The dish then turns at exactly `azFull` = 0.0350 deg/s, which is what"
   , "        #     `driveAz_rate` proves and what the parent assumes - and MEASURED, the naive"
   , "        #     follower's day falls from 51.8 rotis to 0.1, because its gain was written against a"
   , "        #     machine that slewed at 40 % of full command."
   , "        # The default is \"held\", so that printing the wrapper changes no number; the finding is"
   , "        # the notice below, and the choice belongs to whoever owns the mount."
   , "        self.mount_dims = str(mount_dims)"
   , "        held, mach = mount_held(), mount_rest(self.params)"
   , "        rest = mach if self.mount_dims == \"machine\" else held"
   , "        if any(abs(held[k] - mach[k]) > 1e-9 for k in held):"
   , "            log(\"  [hashemi_ccc] the mount's dimensions are per-machine now: the ring rail is \""
   , "                \"%.4f m at the spec's own machine and %.4f m at this one, the wire's rest lever \""
   , "                \"%.4f / %.4f. mount_dims=%s, so a full azimuth command turns the dish at \""
   , "                \"%.4f deg/s (azFull is %.4f).\""
   , "                % (held[\"roller_R\"], mach[\"roller_R\"], held[\"arm_rest\"], mach[\"arm_rest\"],"
   , "                   self.mount_dims, np.degrees(AZ_FULL) * rest[\"roller_R\"] / mach[\"roller_R\"],"
   , "                   np.degrees(AZ_FULL)))"
   , "        self.t_dead = rest[\"t_dead\"]"
   , "        self.roller_R = rest[\"roller_R\"]"
   , "        self.arm_rest = rest[\"arm_rest\"]     # `wireLever` at rest, for step one"
   , "        self.r_drum = float(self.params[\"rDrum\"])"
   , "        # THE DRIVES, in the printed morphism's own shape.  `headToCmd h = (min (max h 0) 6 - 3)/3`,"
   , "        # `driveAz u rw R = u azFull R / rw`, `headToDriveEl h arm rDrum = driveEl (-(headToCmd h))"
   , "        # arm rDrum` - so the expression below is those three, associated as the printer"
   , "        # associates them, with `azFull` / `elFull` taken from the compiled twin and the seven"
   , "        # levels from the policy's manifest.  It is not enough that it be algebraically right: a"
   , "        # last-bit difference from the printed order moves a boolean in the ray sum a few hundred"
   , "        # steps later and the day's rotis with it (measured 2026-09-20: 51.75 vs 0.62 over a day"
   , "        # from one ulp).  `_check_drives` therefore requires EXACT equality with"
   , "        # `headToDriveAz` / `headToDriveEl` at import, not a tolerance."
   , "        self.h_max = float(ACTION_LEVELS - 1)"
   , "        self.h_mid = self.h_max / 2.0"
   , "        self._check_drives()"
   , "        # the params of this kernel that are not bound per step, as a set difference"
   , "        self.param_inputs = [n for n in self.cols.inputs"
   , "                             if n not in [b for b, _ in self._bind()]]"
   , "        miss = [n for n in self.param_inputs if n not in self.params]"
   , "        if miss:"
   , "            raise RuntimeError(\"the %s kernel takes %s, and neither this module nor the machine \""
   , "                               \"file supplies them\" % (self.cols.stem, miss))"
   , "        # the row and its tables, per backend"
   , "        self._x = {}"
   , "        self._kern = {}"
   , "        self._rew_x = {}"
   , "        self._rew_kern = {}"
   , "        self.tables = {}"
   , "        self.state = {}"
   , "        self.mirror = {}"
   , "        self.row = None                 # the last step's columns, on that step's own backend"
   , "        self.row_host = np.zeros((self.B, self.cols.n_out))"
   , "        self.obs = np.zeros((self.B, len(OBS_NAMES)), dtype=np.float32)"
   , "        self.r_cols = np.zeros((self.B, REWARD.n_out))"
   , "        self.r_cols_dev = None"
   , "        self.u_pump = np.zeros(self.B)"
   , "        self._profile = {}"
   , ""
   , "    # -- the description, per receiver"
   , "    def _bind(self):"
   , "        return BEAM_BIND if self.receiver == \"beam\" else ENV_BIND"
   , ""
   , "    def _check_drives(self):"
   , "        \"\"\"the description against the compiled `headToDriveAz` / `headToDriveEl`, BIT FOR BIT\"\"\""
   , "        be = _Back()"
   , "        h = np.concatenate([np.arange(0.0, self.h_max + 1.0), np.linspace(-1.0, 7.0, 17)])"
   , "        arm = np.linspace(0.2, 3.0, h.size)"
   , "        az = np.asarray(H.hk_headToDriveAz(h, np.full(h.shape, self.r_drive),"
   , "                                           np.full(h.shape, self.roller_R)), dtype=np.float64)"
   , "        el = np.asarray(H.hk_headToDriveEl(h, arm, np.full(h.shape, self.r_drum)), dtype=np.float64)"
   , "        u = self._cmd_of(be, h)"
   , "        mine_az = self.drive_az(be, u)"
   , "        mine_el = self.drive_el(be, u, arm)"
   , "        if not (np.array_equal(mine_az, az) and np.array_equal(mine_el, el)):"
   , "            raise RuntimeError(\"the drive description is not the printed one, bit for bit: \""
   , "                               \"%.3e / %.3e\" % (float(np.max(np.abs(mine_az - az))),"
   , "                                                float(np.max(np.abs(mine_el - el)))))"
   , ""
   , "    def _cmd_of(self, be, head):"
   , "        \"\"\"`headToCmd`: a head's value to a command in [-1, 1], on either backend\"\"\""
   , "        return (be.clamp(head, 0.0, self.h_max) - self.h_mid) / self.h_mid"
   , ""
   , "    def drive_az(self, be, u):"
   , "        \"\"\"`driveAz`: the roller's rate, in the printer's own association\"\"\""
   , "        return u * AZ_FULL * self.roller_R / self.r_drive"
   , ""
   , "    def drive_el(self, be, u, arm):"
   , "        \"\"\"`headToDriveEl`: the drum's rate at the wire's lever arm; a positive command lowers\"\"\""
   , "        return (-u) * EL_FULL * arm / self.r_drum"
   , ""
   , "    # -- the exchanger's node profile.  DEFINED, never inherited: the coil in the pot's wall heats"
   , "    # the first `oil_nodes` belt slots uniformly and nothing on the loaf columns.  (Until"
   , "    # 2026-09-19 it was the parent's own tri-chain spot, frozen at the first step.)"
   , "    def profile(self, be):"
   , "        p = self._profile.get(be.tag)"
   , "        if p is None:"
   , "            k = max(1, min(self.oil_nodes, self.n_belt))"
   , "            prof = np.zeros((self.B, self.n_nodes + self.n_belt))"
   , "            prof[:, :k] = 1.0 / k"
   , "            if be.numpy:"
   , "                p = prof"
   , "            else:"
   , "                p = be.torch.as_tensor(prof, dtype=be.torch.float32, device=be.device)"
   , "            self._profile[be.tag] = p"
   , "        return p"
   , ""
   , "    def wall_seen(self, be, T):"
   , "        \"\"\"the wall the exchanger delivers into: the pot's nodes under the coil's own profile\"\"\""
   , "        pn = self.profile(be)[:, :self.n_nodes]"
   , "        return (T[:, :self.n_nodes] * pn).sum(1) / be.clamp_min(pn.sum(1), 1e-9)"
   , ""
   , "    def per_node(self, be, q_pot, gate):"
   , "        \"\"\"the pot's aperture per unit DNI: the exchanger's power along the coil's own profile,"
   , "        through the parent's own gate (`per_dni x gate x 0.85` is what its nodes absorb)\"\"\""
   , "        per = be.where(be.gt(gate, 0.0), q_pot / be.clamp_min(gate * 0.85, 1e-9), be.zeros_like(gate))"
   , "        return self.profile(be) * per[:, None]"
   , ""
   , "    # -- the state this wrapper carries, and the tables the kernel reads"
   , "    def reset(self, be, state):"
   , "        self.state[be.tag] = state"
   , "        for name, _ in TABLE_WRITE:"
   , "            if self.oil:"
   , "                self.tables.setdefault(be.tag, {})[name] = be.zeros("
   , "                    (self.B, len(self.cols.like(name + \"_\"))), self.t_amb)"
   , "        # before the first step the mirrors are the state the tables start in: what the kernel"
   , "        # grades a TEMPERATURE starts at ambient, as the two pipe fields do, and the rest at zero."
   , "        # (The parent's own readers ask for `t_oil` before they ask for a step.)"
   , "        self.mirror.setdefault(be.tag, {})"
   , "        for att, col, who in MIRROR:"
   , "            if who == \"oil\" and not self.oil:"
   , "                continue"
   , "            if col in self.cols:"
   , "                self.mirror[be.tag][att] = be.zeros((self.B,), self.t_amb"
   , "                                                    if self.is_temperature(col) else 0.0)"
   , ""
   , "    def is_temperature(self, col):"
   , "        \"\"\"the graded manifest decides; before it is emitted, the column's own name does\"\"\""
   , "        try:"
   , "            return self.cols.grade(col).get(\"kind\") == \"temperature\""
   , "        except Exception:"
   , "            return col.startswith(\"T_\")"
   , ""
   , "    def sync_state(self, be, az, t, slack):"
   , "        st = self.state[be.tag]"
   , "        st[:, 0], st[:, 1], st[:, 2] = az, t, slack"
   , ""
   , "    # -- ONE step, ONE description, either backend"
   , "    def _derive(self, be, ctx):"
   , "        \"\"\"the sources the table above names, from the parent's own quantities."
   , ""
   , "        This is where the heads become the spec's commands, the pump's head becomes a fraction,"
   , "        the pot's nodes become the wall the exchanger sees, and the exchanger's ceiling is opened"
   , "        with the parent's beam gate.  ONE copy, so the two paths cannot drift.\"\"\""
   , "        st = self.state[be.tag]"
   , "        head = ctx[\"head\"]"
   , "        arm_prev = self.mirror[be.tag][\"arm\"]"
   , "        arm = be.where(be.gt(arm_prev, 0.05), arm_prev, be.full(arm_prev, self.arm_rest))"
   , "        u_az = self._cmd_of(be, head[:, HEAD_AZ])"
   , "        u_el = self._cmd_of(be, head[:, HEAD_EL])"
   , "        # the pump is the parent's pinned head 0 (`pumpOf`), read BEFORE the host neutralises it"
   , "        u_pump = be.clamp(head[:, 0], 0.0, self.h_max) / self.h_max"
   , "        src = {"
   , "            \"state_az\": st[:, 0], \"state_t\": st[:, 1], \"state_slack\": st[:, 2],"
   , "            \"drive_az\": self.drive_az(be, u_az),"
   , "            \"drive_el\": self.drive_el(be, u_el, arm),"
   , "            \"dt\": self.dt, \"t_amb\": self.t_amb,"
   , "            \"sun_el\": ctx[\"sun_el\"], \"sun_az\": ctx[\"sun_az\"],"
   , "            \"dni\": ctx[\"dni\"], \"soil\": ctx[\"soil\"], \"wind\": ctx.get(\"wind\", 0.0),"
   , "            \"u_pump\": u_pump,"
   , "        }"
   , "        if self.oil:"
   , "            src[\"deg\"] = self.mirror[be.tag][\"deg\"]"
   , "            src[\"t_wall\"] = self.wall_seen(be, ctx[\"T\"])"
   , "            src[\"ua_gated\"] = float(self.params[\"UAxMax\"]) * be.indicator(be.gt(ctx[\"gate\"], 0.0))"
   , "        return src, u_pump"
   , ""
   , "    def row_buffer(self, be):"
   , "        x = self._x.get(be.tag)"
   , "        if x is None:"
   , "            x = be.zeros((self.B, self.cols.n_in))"
   , "            for n in self.param_inputs:"
   , "                be.put(x, self.cols.inp(n), float(self.params[n]))"
   , "            self._x[be.tag] = x"
   , "        return x"
   , ""
   , "    def kernel(self, be):"
   , "        k = self._kern.get(be.tag)"
   , "        if k is None:"
   , "            if self.receiver == \"beam\":"
   , "                import hashemi_beam_kernel as bk"
   , "                k = bk.HashemiBeamMetal()"
   , "            else:"
   , "                k = HashemiEnvMetal()"
   , "            self._kern[be.tag] = k"
   , "        return k"
   , ""
   , "    def step(self, be, ctx):"
   , "        \"\"\"the machine's step: assemble, launch, absorb.  The SAME method on both paths.\"\"\""
   , "        x = self.row_buffer(be)"
   , "        src, u_pump = self._derive(be, ctx)"
   , "        for name, key in self._bind():"
   , "            be.put(x, self.cols.inp(name), src[key])"
   , "        dr = ctx[\"dr\"]"
   , "        if be.numpy:"
   , "            if self.receiver == \"beam\":"
   , "                import hashemi_beam_kernel as bk"
   , "                row = bk.beam_numpy(x, dr)"
   , "            else:"
   , "                tb = self.tables[be.tag]"
   , "                row = env_numpy(x, tb[\"hist\"], tb[\"ret\"], dr)"
   , "        else:"
   , "            if self.receiver == \"beam\":"
   , "                row = self.kernel(be).step(x, dr)"
   , "            else:"
   , "                tb = self.tables[be.tag]"
   , "                row = self.kernel(be).step(x, tb[\"hist\"], tb[\"ret\"], dr)"
   , "        self.absorb(be, row)"
   , "        self.u_pump = be.host(u_pump)"
   , "        return row"
   , ""
   , "    def absorb(self, be, row):"
   , "        \"\"\"the columns back out of the row, BY NAME: the state, the two pipe fields, the mirrors\"\"\""
   , "        self.row = row"
   , "        st = self.state[be.tag]"
   , "        for j, (_, col) in enumerate(STATE_WRITE):"
   , "            st[:, j] = be.take(row, self.cols[col])"
   , "        if self.oil:"
   , "            tb = self.tables[be.tag]"
   , "            for name, prefix in TABLE_WRITE:"
   , "                js = self.cols.like(prefix)"
   , "                if be.numpy:"
   , "                    tb[name] = row[:, js].copy()"
   , "                else:"
   , "                    tb[name].copy_(row[:, js])"
   , "        mir = self.mirror[be.tag]"
   , "        for att, col, who in MIRROR:"
   , "            if who == \"oil\" and not self.oil:"
   , "                continue"
   , "            if col in self.cols:"
   , "                if be.numpy:"
   , "                    mir[att] = row[:, self.cols[col]].copy()"
   , "                else:"
   , "                    mir[att] = row[:, self.cols[col]]"
   , ""
   , "    def attrs(self, be):"
   , "        \"\"\"the mirrors under the attribute name the parent's own readers know each by\"\"\""
   , "        mir = self.mirror[be.tag]"
   , "        return {att: be.host(mir[key]) for att, key in PUBLISH if key in mir}"
   , ""
   , "    def publish(self, be):"
   , "        \"\"\"the host mirrors the parent's readers expect, and the observation row\"\"\""
   , "        self.row_host = be.host(self.row)"
   , "        self.obs = self.obs_row(self.row_host)"
   , "        return self.row_host"
   , ""
   , "    def obs_row(self, row_host):"
   , "        \"\"\"the machine's observations, in the POLICY's order (`obsNames`), by name."
   , ""
   , "        A receiver whose kernel does not carry one of them reports zero for it rather than"
   , "        raising: the loop's three (`margin`, `flow`, `deg`) are not columns of the beam-down.\"\"\""
   , "        out = np.zeros((row_host.shape[0], len(OBS_NAMES)), dtype=np.float32)"
   , "        for j, n in enumerate(OBS_NAMES):"
   , "            c = self.cols.get(\"obs_\" + n)"
   , "            if c is not None:"
   , "                out[:, j] = row_host[:, c]"
   , "        return out"
   , ""
   , "    def missing_obs(self):"
   , "        return [n for n in OBS_NAMES if (\"obs_\" + n) not in self.cols]"
   , ""
   , "    # -- the reward, in the printed morphism's own units"
   , "    def reward_kernel(self, be):"
   , "        k = self._rew_kern.get(be.tag)"
   , "        if k is None:"
   , "            k = HashemiRewardMetal()"
   , "            self._rew_kern[be.tag] = k"
   , "        return k"
   , ""
   , "    def lift_parent(self, be, rew, divided, reward_div):"
   , "        \"\"\"the parent's raw reward for the step."
   , ""
   , "        The fused path hands it over before its own division and the NumPy path after, so the"
   , "        lift back into the morphism's fibre happens HERE, once, and never as arithmetic beside a"
   , "        second copy of the shaping.\"\"\""
   , "        return rew * float(reward_div) if divided else rew"
   , ""
   , "    def reward(self, be, ctx):"
   , "        \"\"\"`rewardStep` (HashemiReward.lean): the five columns of the step's reward\"\"\""
   , "        x = self._rew_x.get(be.tag)"
   , "        if x is None:"
   , "            x = be.zeros((self.B, REWARD.n_in))"
   , "            self._rew_x[be.tag] = x"
   , "        mir = self.mirror[be.tag]"
   , "        for name, src in REWARD_BIND:"
   , "            if src.startswith(\"col:\") or src.startswith(\"excess:\"):"
   , "                kind, col = src.split(\":\", 1)"
   , "                opt = col.endswith(\"?0\")"
   , "                col = col[:-2] if opt else col"
   , "                if col not in self.cols:"
   , "                    if not opt:"
   , "                        raise RuntimeError(\"the %s kernel has no column %r for the reward's %s\""
   , "                                           % (self.cols.stem, col, name))"
   , "                    v = 0.0"
   , "                else:"
   , "                    v = mir[col] if col in mir else be.take(self.row, self.cols[col])"
   , "                    if kind == \"excess\":"
   , "                        v = be.neg_part(v)"
   , "                be.put(x, REWARD.inp(name), v)"
   , "            else:"
   , "                be.put(x, REWARD.inp(name), ctx[src])"
   , "        if be.numpy:"
   , "            cols = reward_numpy(x)"
   , "            self.r_cols = cols"
   , "        else:"
   , "            cols = self.reward_kernel(be).step(x)"
   , "            self.r_cols_dev = cols"
   , "        return cols"
   , ""
   , "    def reward_col(self, cols, name):"
   , "        return cols[:, REWARD[name]]"
   , ""
   , "    # -- the picture: the scene kernel's own input row is the env kernel's, name for name"
   , "    def scene_map(self, scene_inputs):"
   , "        \"\"\"NOTHING is pooled on a host: every dimension the scene needs is bound in the graph\"\"\""
   , "        missing = [n for n in scene_inputs if not self.cols.has_input(n)]"
   , "        if missing:"
   , "            raise RuntimeError(\"the %s scene still asks for %s off the graph\""
   , "                               % (self.cols.stem, missing))"
   , "        return [(j, self.cols.inp(n)) for j, n in enumerate(scene_inputs)]"
   , ""
   , "    def scene_map_partial(self, scene_inputs):"
   , "        \"\"\"a standalone scene: the inputs it shares with the env's row, by name\"\"\""
   , "        return [(j, self.cols.inp(n)) for j, n in enumerate(scene_inputs)"
   , "                if self.cols.has_input(n)]"
   , ""
   , ""
   , "# the wrapper the trainer loads: the parent's contract from the hand-written harness, the machine"
   , "# from this generated module.  `puffer_hashemi_ccc` names THIS class."
   , "from hashemi_harness import HashemiHarness                                   # noqa: E402"
   , ""
   , ""
   , "class HashemiTandoorEnv(HashemiHarness):"
   , "    \"\"\"the tandoor with his concentrator: the machine from one compiled morphism\"\"\""
   , ""
   , "    MACHINE = Machine"
   , "    DRAWS = staticmethod(draws)"
   , "    PUMP_PRICE = PUMP_PRICE"
   , "    DEG_PRICE = DEG_PRICE"
   ]

def run : MetaM Unit := do
  let env ← getEnv
  let root := `TandoorHashemi
  -- the candidates: user-level constants of the namespace, in a stable order
  let mut names : Array Name := #[]
  let notCompiled : List String := ["b2r", "megaNames", "megaNames_size", "envNames", "envNames_size", "envRays",
    "envOwnNames", "envOwnNames_size", "mountNames",
    "loopNames", "loopNames_size", "obsNames", "actionNames", "actionLevels", "beamNames", "beamNames_size",
    "rewardNames", "rewardNames_size"]
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
    "#ifndef hk_sqrt", "#define hk_sqrt(x) sqrt(hk_max((x), 0.0))", "#define hk_sin sin", "#define hk_cos cos",
    "#define hk_tan tan", "#define hk_atan atan", "#define hk_acos(x) acos(hk_min(hk_max((x), -1.0), 1.0))", "#define hk_asin(x) asin(hk_min(hk_max((x), -1.0), 1.0))",
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
      -- the grading's first consumer: an indicator's Lipschitz slot is `HK_TRUTH`, not a bound,
      -- and the `L` chain that would have fed it is not in the printed box at all
      "\"truth_outputs\": [" ++ ", ".intercalate (f.truthCols.toList.map fun b => if b then "true" else "false") ++ "]",
      "\"box_dead_L\": " ++ toString f.boxStats.2.1, "\"box_live_nodes\": " ++ toString f.boxStats.2.2,
      "\"n_in\": " ++ toString nin, "\"n_out\": " ++ toString nout, "\"mass\": " ++ toString mass,
      "\"arrays\": [" ++ ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++ "]",
      "\"n_nodes\": " ++ toString g.nodes.size] ++ "}")
  IO.FS.writeFile (outDir ++ "/hashemi_modula.metal") ("\n".intercalate mk.toList)
  IO.FS.writeFile (outDir ++ "/hashemi_modula.json")
    ("{\n\"design_params\": [" ++ ", ".intercalate (designParams.map jsonStr) ++ "],\n\"composites\": {\"dishPower\": [\"sunInDish\", \"sampleRay\", \"traceRayKErr\"]},\n\"modules\": [\n" ++
     ",\n".intercalate mj.toList ++ "\n]\n}\n")
  logInfo m!"modula: {mods.size} modules (tangent + box), {(mods.filter fun f => (f.inputs.map (·.1)).any designParams.contains).size} with mass"
  -- WHAT THE GRADING SAVED IN THE BOX: the columns that are indicators, the modules all of whose
  -- columns are, and the live nodes whose Lipschitz component is now not computed at all
  let bt := mods.foldl (fun (a, b, c, d) f =>
      let (nT, nDead, nLive) := f.boxStats
      (a + nT, b + nDead, c + nLive, d + (if nT == f.truthCols.size && nT > 0 then 1 else 0)))
    (0, 0, 0, 0)
  logInfo m!"box: {bt.1} truth columns over {mods.size} modules ({bt.2.2.2} of them entirely truth-valued); \
    the Lipschitz chain is skipped at {bt.2.1} of {bt.2.2.1} live nodes"
  -- ---- dot
  for f in funs do
    IO.FS.writeFile (outDir ++ "/dot/" ++ f.name.getString! ++ ".dot") (printDot f)
  -- ---- samples, the Float twin and the round trip
  let mut json : Array String := #[]
  -- the Float twin is a `let` chain as long as the flat graph, and `hashemiEnv`'s is 3404 long
  -- since the env began carrying the whole mount (`mountNames`): elaborating it needs more than
  -- the default budget.  This is a GENERATED DEFINITION, not a tactic - nothing is being forced
  -- through - and the round trip beside it has asked for 4e6 all along.
  let mut fl : Array String := #["import Std", "namespace HashemiCccFloat", "set_option maxRecDepth 4000",
    "set_option maxHeartbeats 2000000",
    "/-- `=` on ℝ, in floating point -/",
    "def feq (a b : Float) : Bool := Float.abs (a - b) <= 1e-9 * max 1.0 (max (Float.abs a) (Float.abs b))", ""]
  -- the round trip names every compiled definition, so it imports the top module of the chain
  let mut rt : Array String := #["import RequestProject.HashemiTraceProps", "import RequestProject.HashemiPolicy", "import RequestProject.HashemiBeamdown", "import RequestProject.HashemiReward", "import RequestProject.HashemiWire", "namespace TandoorHashemi",
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
  let mut megaTruth : Array Bool := #[]
  for mf in megaFns do
    match funs.find? (fun f => f.name.getString! == mf) with
    | some f =>
      let n := f.output.flatten.size
      megaJson := megaJson.push ("  {\"name\": " ++ jsonStr mf ++ ", \"c\": " ++ jsonStr (cName f.name) ++
        ", \"offset\": " ++ toString off ++ ", \"n_out\": " ++ toString n ++ "}")
      off := off + n
      megaTruth := megaTruth ++ f.truthCols
      if megaInputs.isEmpty then megaInputs := f.inputs.map (·.1)
    | none => logInfo m!"mega function {mf} did not compile"
  let (megaGrades, megaTruthJson) ← gradesOf root "megaStep" cols megaTruth
  IO.FS.writeFile (outDir ++ "/hashemi_mega.json")
    ("{\n\"columns\": [" ++ ", ".intercalate (cols.toList.map jsonStr) ++ "],\n\"inputs\": [" ++
     ", ".intercalate (megaInputs.toList.map jsonStr) ++ "],\n\"functions\": [\n" ++
     ",\n".intercalate megaJson.toList ++ "\n],\n\"n_columns\": " ++ toString off ++
     ",\n\"truth\": " ++ megaTruthJson ++ ",\n\"grades\": " ++ megaGrades ++ "\n}\n")
  logInfo m!"mega: {off} columns in the kernel, {cols.size} names, {(megaTruth.filter id).size} truth"
  -- ---- the env's step as ONE kernel: threadgroup per agent, thread per ray, the sum in shared memory
  -- the env's columns: its own names, then the WHOLE MOUNT under `mountNames`' prefix.  The
  -- mount's names are `megaNames` itself (read above as `cols`), so the 230 columns the env now
  -- carries are never typed a second time - `HashemiEnv.envNames` is this same concatenation.
  let envNamesE ← instantiateMVars ((← getConstInfo (root ++ `envOwnNames)).value?.getD (mkConst `none))
  let envCols := strLits envNamesE ++ cols.map (fun n => "mount_" ++ n)
  match funs.find? (fun f => f.name.getString! == "hashemiEnv") with
  | some f =>
    IO.FS.writeFile (outDir ++ "/hashemi_env.metal")
      ("// generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiEnv.lean - do not edit.\n" ++
       "// ONE kernel for the env's step: buffer 0 the scalar inputs (B, n_in), buffer 1 the ray table (B, P, m),\n" ++
       "// buffer 2 the outputs (B, n_out), buffer 3 the count; dispatch B*P threads in groups of P.\n" ++
       printMslMega f "hashemi_env" ++ "\n")
    let L := layers f.graph
    let (envGrades, envTruth) ← gradesOf root "hashemiEnv" envCols f.truthCols
    let (nT, nDead, nLive) := f.boxStats
    IO.FS.writeFile (outDir ++ "/hashemi_env.json")
      ("{\n\"kernel\": \"hashemi_env\", \"c\": " ++ jsonStr (cName f.name) ++ ",\n\"columns\": [" ++ ", ".intercalate (envCols.toList.map jsonStr) ++ "],\n\"inputs\": [" ++
       ", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr) ++ "],\n\"arrays\": [" ++
       ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++
       "],\n\"n_columns\": " ++ toString f.output.flatten.size ++ ", \"rays\": " ++ toString L.P ++ ", \"n_nodes\": " ++ toString f.graph.nodes.size ++
       ", \"ray_nodes\": " ++ toString (L.ray.filter id).size ++ ", \"sums\": " ++ toString L.sums.size ++
       ",\n\"truth\": " ++ envTruth ++ ",\n\"grades\": " ++ envGrades ++ "\n}\n")
    logInfo m!"env: {f.output.flatten.size} columns, {f.graph.nodes.size} nodes ({(L.ray.filter id).size} ray-level, {L.sums.size} sums over {L.P} rays), {envCols.size} names"
    logInfo m!"env grading: {nT} truth columns; the box skips the Lipschitz chain of {nDead} of {nLive} live nodes"
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
    let (loopGrades, loopTruth) ← gradesOf root "hashemiLoop" (strLits loopE) f.truthCols
    IO.FS.writeFile (outDir ++ "/hashemi_policy.json")
      ("{\n\"kernel\": \"hashemi_loop\", \"c\": " ++ jsonStr (cName f.name) ++
       ",\n\"obs\": [" ++ ", ".intercalate ((strLits obsE).toList.map jsonStr) ++ "]" ++
       ",\n\"actions\": [" ++ ", ".intercalate ((strLits actE).toList.map jsonStr) ++ "]" ++
       ",\n\"action_levels\": 7, \"motor_heads\": [3, 4]" ++
       ",\n\"columns\": [" ++ ", ".intercalate ((strLits loopE).toList.map jsonStr) ++ "]" ++
       ",\n\"truth\": " ++ loopTruth ++ ",\n\"grades\": " ++ loopGrades ++
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
    let (beamGrades, beamTruth) ← gradesOf root "hashemiEnvBeam" (strLits beamE) f.truthCols
    IO.FS.writeFile (outDir ++ "/hashemi_beam.json")
      ("{\n\"kernel\": \"hashemi_beam\", \"c\": " ++ jsonStr (cName f.name) ++ ",\n\"columns\": [" ++ ", ".intercalate ((strLits beamE).toList.map jsonStr) ++ "],\n\"truth\": " ++ beamTruth ++ ",\n\"grades\": " ++ beamGrades ++ ",\n\"inputs\": [" ++
       ", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr) ++ "],\n\"arrays\": [" ++
       ", ".intercalate (f.arrays.toList.map fun (b, P, m) => "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString P ++ ", \"m\": " ++ toString m ++ "}") ++
       "],\n\"n_columns\": " ++ toString f.output.flatten.size ++ ", \"rays\": " ++ toString L.P ++ ", \"n_nodes\": " ++ toString f.graph.nodes.size ++
       ", \"ray_nodes\": " ++ toString (L.ray.filter id).size ++ ", \"sums\": " ++ toString L.sums.size ++ "\n}\n")
    logInfo m!"beam: {f.output.flatten.size} columns, {f.graph.nodes.size} nodes ({(L.ray.filter id).size} ray-level, {L.sums.size} sums)"
  | none => logInfo m!"hashemiEnvBeam did not compile"
  -- ---- the trainer's reward as ONE kernel over B agents: the parent's raw reward for the step,
  -- the step, the light at the receiver and the sun's reach, with the ini's constants as INPUTS.
  -- The env computes its reward AFTER the machine's step, so this cannot be a column of
  -- `hashemi_env`; it is its own launch, one thread per agent, and the same graph in NumPy/C.
  let rewardNamesE ← instantiateMVars ((← getConstInfo (root ++ `rewardNames)).value?.getD (mkConst `none))
  match funs.find? (fun f => f.name.getString! == "rewardStep") with
  | some f =>
    IO.FS.writeFile (outDir ++ "/hashemi_reward.metal")
      ("// generated by RequestProject/Ccc.lean (HashemiCcc.lean) from HashemiReward.lean - do not edit.\n" ++
       "// ONE kernel for the trainer's reward: buffer 0 the inputs (B, n_in), buffer 1 the outputs (B, 3),\n" ++
       "// buffer 2 the count; dispatch B threads in groups of 1.\n" ++
       printMslMega f "hashemi_reward" ++ "\n")
    let (rewGrades, rewTruth) ← gradesOf root "rewardStep" (strLits rewardNamesE) f.truthCols
    IO.FS.writeFile (outDir ++ "/hashemi_reward.json")
      ("{\n\"kernel\": \"hashemi_reward\", \"c\": " ++ jsonStr (cName f.name) ++ ",\n\"columns\": [" ++
       ", ".intercalate ((strLits rewardNamesE).toList.map jsonStr) ++ "],\n\"truth\": " ++ rewTruth ++
       ",\n\"grades\": " ++ rewGrades ++
       ",\n\"raw_unit\": " ++ jsonStr HashemiGrade.rewardRawUnit ++
       ", \"trainer_unit\": " ++ jsonStr HashemiGrade.rewardTrainerUnit ++
       ",\n\"inputs\": [" ++
       ", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr) ++ "],\n\"n_columns\": " ++
       toString f.output.flatten.size ++ ", \"n_nodes\": " ++ toString f.graph.nodes.size ++ "\n}\n")
    logInfo m!"reward: {f.output.flatten.size} columns, {f.graph.nodes.size} nodes, inputs {f.inputs.map (·.1)}"
  | none => logInfo m!"rewardStep did not compile"
  -- ---- THE ENV WRAPPER, printed from the same manifests as the kernels above.
  -- `hashemi_tandoor_ccc.py` is the module `puffer_hashemi_ccc` loads; `hashemi_harness.py`
  -- beside it is the hand-written half (the parent tandoor env's contract).  Every table is
  -- checked against the morphism it addresses BEFORE the file is written.
  match funs.find? (fun f => f.name.getString! == "hashemiEnv"),
        funs.find? (fun f => f.name.getString! == "hashemiEnvBeam"),
        funs.find? (fun f => f.name.getString! == "rewardStep") with
  | some fe, some fb, some fr =>
    let envIn := (fe.inputs.map (·.1)).toList
    let beamIn := (fb.inputs.map (·.1)).toList
    let rewIn := (fr.inputs.map (·.1)).toList
    let ecols := envCols.toList
    let mut bad : List String := []
    for (n, _) in envBind do
      unless envIn.contains n do bad := bad ++ [s!"envBind binds {n}, which hashemiEnv does not take"]
    for (n, _) in beamBind do
      unless beamIn.contains n do bad := bad ++ [s!"beamBind binds {n}, which hashemiEnvBeam does not take"]
    -- the reward has no parameters: its inputs and this table are the same set
    for (n, _) in rewardBind do
      unless rewIn.contains n do bad := bad ++ [s!"rewardBind binds {n}, which rewardStep does not take"]
    for n in rewIn do
      unless (rewardBind.map (·.1)).contains n do bad := bad ++ [s!"rewardStep takes {n}, which the wrapper never binds"]
    for (_, c) in stateWrite do
      unless ecols.contains c do bad := bad ++ [s!"stateWrite writes {c}, which is not a column of hashemiEnv"]
    for (_, p) in tableWrite do
      unless ecols.contains (p ++ "0") do bad := bad ++ [s!"tableWrite reads {p}0, which is not a column of hashemiEnv"]
    for (_, c, _) in mirrorCols do
      unless ecols.contains c do bad := bad ++ [s!"mirrorCols mirrors {c}, which is not a column of hashemiEnv"]
    for (_, k) in publishAttrs do
      unless (mirrorCols.map (fun (a, _, _) => a)).contains k do
        bad := bad ++ [s!"publishAttrs publishes {k}, which is not a mirror"]
    for m in bad do logInfo m!"WRAPPER: {m}"
    if bad.isEmpty then
      IO.FS.writeFile (outDir ++ "/hashemi_tandoor_ccc.py") ("\n".intercalate wrapperPy ++ "\n")
      logInfo m!"wrapper: hashemi_tandoor_ccc.py, {wrapperPy.length} lines; {envBind.length} of hashemiEnv's {envIn.length} inputs bound per step, {envIn.length - envBind.length} parameters; {rewardBind.length} reward inputs; {mirrorCols.length} mirrored columns"
    else
      logInfo m!"wrapper NOT written: {bad.length} table(s) disagree with the compiled morphisms"
  | _, _, _ => logInfo m!"the wrapper needs hashemiEnv, hashemiEnvBeam and rewardStep"
  let skippedJson := skipped.toList.map fun (n, m) => "  {\"name\": " ++ jsonStr n.getString! ++ ", \"reason\": " ++ jsonStr m ++ "}"
  IO.FS.writeFile (outDir ++ "/hashemi_ccc.json")
    ("{\n\"functions\": [\n" ++ ",\n".intercalate json.toList ++ "\n],\n\"skipped\": [\n" ++
     ",\n".intercalate skippedJson ++ "\n]\n}\n")
  logInfo m!"compiled {funs.size} ({defs.size} definitions, {props.size} props, {thms.size} theorem checks); skipped {skipped.size}"
  for (n, m) in skipped do
    logInfo m!"skipped {n}: {m}"

end HashemiCcc

#eval HashemiCcc.run

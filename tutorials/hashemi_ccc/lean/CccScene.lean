/-
# The scene printer

`Scene.lean` says what may be drawn; this file draws it, and it knows nothing about any machine.

Given a `Scene.Scene` — a list of labels, shapes and colours naming definitions of a
specification — it compiles **one** `Ccc.Fun`:

* every distinct binder name across every leaf becomes one input of the scene (two leaves that
  both take `az` take the *same* `az`);
* each leaf is the application of its definition to those inputs, and, when it has a frame, the
  frame's application to that — **composed in the graph**.  This is composition in the CCC: the
  frame's nodes are emitted over the leaf's output nodes and hash-consed with everything else, so
  a point and the frame that places it share every subexpression they have in common, and the
  whole picture is one dataflow graph rather than a sequence of calls;
* the outputs are the leaves' vertices, concatenated in entry order.

Everything after that is `Ccc.lean`'s own printers, unchanged: `printC` gives the C function,
`printNumpy` the reference twin.  This file adds only the wrapper a renderer needs — a flat
`(inputs, verts)` entry point and the static tables of kinds, colours and offsets — and the JSON
manifest.

It is generic by construction: it takes `Scene`, a root namespace and a name, and there is no
occurrence of any machine's vocabulary anywhere below.  `SceneCcc.lean` drives it over three
different scenes of two different specifications.
-/
import RequestProject.Ccc
import RequestProject.Scene

open Lean Meta Ccc

namespace CccScene

/-! ## Reading a definition's signature -/

/-- the leading data binders of a constant, as `(name, type)`, stopping at the first `Fin n`
binder (which indexes the output vector, not an argument).  `drop` many trailing ones are left
out — a frame's last binder is the point it embeds, which is supplied by the leaf. -/
def sigOf (n : Name) (drop : Nat := 0) : MetaM (Array (String × Expr)) := do
  let ci ← getConstInfo n
  let ty ← instantiateMVars ci.type
  let k ← dataArity ty
  let k := if k ≥ drop then k - drop else 0
  forallBoundedTelescope ty (some k) fun xs _ => do
    let mut out : Array (String × Expr) := #[]
    for x in xs do
      let nm := (← x.fvarId!.getUserName).toString
      out := out.push (nm, ← instantiateMVars (← inferType x))
    pure out

/-- **the inputs a bound binder asks of the scene**.  An input is one input; a literal is none;
a node is *its own* definition's binders, which are scene inputs by their own names — the node is
computed in the graph, so nothing about it reaches the host. -/
def boundSig (root : Name) (b : Scene.Bound) (ty : Expr) : MetaM (Array (String × Expr)) := do
  match b with
  | .inp n => pure #[(n, ty)]
  | .lit _ => pure #[]
  | .node d _ => sigOf (root ++ d.toName)

/-- the full signature a leaf needs: the frame's leading binders, then the definition's. -/
def leafSig (root : Name) (l : Scene.Leaf) : MetaM (Array (String × Expr)) := do
  let raw ← match l with
    | .pt d fr _ => do
      let a ← match fr with | none => pure #[] | some f => sigOf (root ++ f.toName) 1
      let b ← sigOf (root ++ d.toName)
      pure (a ++ b)
    | .num d _ _ => sigOf (root ++ d.toName)
  let mut out : Array (String × Expr) := #[]
  for (nm, ty) in raw do
    out := out ++ (← boundSig root (l.rename nm) ty)
  pure out

/-- the scene's inputs: every binder of every leaf, deduplicated by name in first-seen order.
Two leaves that name a binder alike share it — that is what makes a scene one morphism of the
pose and the draws, not a bag of unrelated functions. -/
def sceneSig (root : Name) (sc : Scene.Scene) : MetaM (Array (String × Expr)) := do
  let mut out : Array (String × Expr) := #[]
  for e in sc do
    for l in e.shape.leaves do
      for (nm, ty) in ← leafSig root l do
        unless out.any (·.1 == nm) do out := out.push (nm, ty)
  pure out

/-- **the scene's input row, in another morphism's order**.  A scene composed with a morphism of
the specification is dispatched on that morphism's own row: the same numbers, in the same
columns.  `order` names that morphism; its data binders come first, in its order, and anything
the scene asks for beyond them follows.  When the scene is exactly composed — every binder either
one of that morphism's or bound to a node — the two rows are equal, name for name. -/
def orderSig (order : Name) (sig : Array (String × Expr)) : MetaM (Array (String × Expr)) := do
  let ord := (← sigOf order).map (·.1)
  let head := ord.filterMap fun nm => sig.find? (·.1 == nm)
  let tail := sig.filter fun p => !ord.contains p.1
  pure (head ++ tail)

/-! ## The compiler -/

/-- **a ray leaf**: a definition whose remaining binder, after its data binders, is an index
`Fin P` over a ray TABLE (its codomain is still a function, so the `Fin P` is not the output
vector's index).  Such a leaf is compiled against the ray index itself — the very `.rayIn` nodes
a `∑ i : Fin P` produces — so the printers give each row of the table its own thread. -/
def rayIndexOf (e : Expr) : MetaM (Option (Nat × Expr)) := do
  let ty ← whnfR (← inferType e)
  match ty with
  | .forallE _ dom cod _ =>
    if dom.getAppFn.isConstOf ``Fin then
      let cod' ← whnfR cod
      if isRealTy cod' then pure none
      else match natLit? dom.getAppArgs[0]! with
        | some P => pure (some (P, dom))
        | none => pure none
    else pure none
  | _ => pure none

/-- compile a whole scene into one `Ccc.Fun`.  `root` is the namespace whose definitions are
unfolded (`Ccc.translate`'s rule); `name` names the printed function. -/
def compileScene (root : Name) (name : Name) (sc : Scene.Scene) (order : Option Name := none) :
    MetaM (Except String Fun) := do
  try
    let sig ← sceneSig root sc
    let sig ← match order with | none => pure sig | some o => orderSig o sig
    let decls : Array (Name × (Array Expr → MetaM Expr)) :=
      sig.map fun (nm, ty) => (nm.toName, fun _ => pure ty)
    withLocalDeclsD decls fun xs => do
      let idx : Std.HashMap String Expr :=
        (Array.zip (sig.map (·.1)) xs).foldl (fun m (k, v) => m.insert k v) {}
      let inp := fun (nm : String) => match idx[nm]? with
        | some e => pure e
        | none => throwError "the scene has no input {nm}"
      -- **a bound binder, as an expression of the graph**.  This is the composition: a binder
      -- may be an input, a literal of the drawing's own convention, or another definition of the
      -- specification applied to the scene's inputs (and then one column of it).  The result is
      -- an ordinary sub-expression, so `translate` hash-conses it with everything else and the
      -- host is never asked for its value.
      let boundArg : Scene.Bound → Expr → MetaM Expr := fun b ty => do
        match b with
        | .inp n => inp n
        | .lit v =>
          let n ← mkAppOptM ``OfNat.ofNat #[ty, mkNatLit v.natAbs, none]
          if v < 0 then mkAppM ``Neg.neg #[n] else pure n
        | .node d col =>
          let dn := root ++ d.toName
          let args ← (← sigOf dn).mapM fun (nm, _) => inp nm
          let e := mkAppN (mkConst dn) args
          match col with
          | none => pure e
          | some c =>
            let ety ← whnfR (← inferType e)
            match ety with
            | .forallE _ dom _ _ =>
              match natLit? dom.getAppArgs[0]! with
              | some P => pure (mkApp e (finLit P c))
              | none => throwError "the bound node {d} is not indexed by a literal Fin"
            | _ => throwError "column {c} asked of {d}, which is not a vector"
      -- translate one leaf: its definition applied to the scene's inputs, then — when the
      -- definition takes a ray index — that application under the ray index, and then the frame
      -- composed onto it IN THE GRAPH
      let leafVal : (Expr → Expr) → Expr → TM Val := fun wrap body => do
        match ← rayIndexOf body with
        | none => translate root (wrap body)
        | some (P, dom) =>
          let st0 ← get
          let (v, st') ← withLocalDeclD `i dom fun ii =>
            (translate root (wrap (mkApp body ii).headBeta)).run
              { st0 with env := st0.env.insert ii.fvarId! .rayIdx, inSum := some P }
          set { st' with inSum := none }
          pure v
      let act : TM Val := do
        for x in xs do
          let _ ← bindBinder root x xs.size
        let mut outs : Array Val := #[]
        for e in sc do
          for l in e.shape.leaves do
            match l with
            | .pt d fr _ => do
              let dn := root ++ d.toName
              let dargs ← (← sigOf dn).mapM fun (nm, ty) => boundArg (l.rename nm) ty
              let body := mkAppN (mkConst dn) dargs
              let wrap : Expr → Expr ← match fr with
                | none => pure id
                | some f => do
                  let fn := root ++ f.toName
                  let fargs ← (← sigOf fn 1).mapM fun (nm, ty) => boundArg (l.rename nm) ty
                  pure (fun b => mkAppN (mkConst fn) (fargs.push b))
              let v ← leafVal wrap body
              match v with
              | .vec vs =>
                unless vs.size == 3 do
                  throwError "the point {d} has {vs.size} components, not 3"
                outs := outs.push v
              | w => throwError "the point {d} is a {w.shape}, not three reals"
            | .num d c _ => do
              let dn := root ++ d.toName
              let dargs ← (← sigOf dn).mapM fun (nm, ty) => boundArg (l.rename nm) ty
              let v ← leafVal id (mkAppN (mkConst dn) dargs)
              match v with
              | .s _ => outs := outs.push v
              | .vec vs =>
                unless c < vs.size do throwError "column {c} of {d} ({vs.size} wide)"
                outs := outs.push vs[c]!
              | w => throwError "a number asked of a {w.shape} ({d})"
        pure (.vec outs)
      let (out, st) ← act.run {}
      pure (Except.ok { name := name, inputs := st.inputs, binders := st.binders, output := out,
                        graph := st.g, isProp := false, arrays := st.arrays,
                        arrayScalar := st.arrayScalar })
  catch ex =>
    pure (Except.error (← ex.toMessageData.toString))

/-! ## The two regions of a scene's output

A scene over a ray table has vertices of two kinds.  The static ones — the carriage, the rim, the
sun — are one per frame; the ray ones are one per row of the table.  So the printed function
writes TWO buffers: `vs` of `n_static` doubles, and `vr` of `P x n_ray`.  Which is which is not
declared anywhere: it is read off the graph, a vertex being a ray vertex exactly when its node
is ray-level (`Ccc.layers`).  An entry whose leaves disagree is drawn in the ray region. -/

structure Split where
  /-- per entry: is it a ray entry -/
  isRay : Array Bool
  /-- per entry: its offset within its own region -/
  off : Array Nat
  /-- per output node (in `f.output` order): is it a ray vertex -/
  rayOut : Array Bool
  nStatic : Nat
  nRay : Nat
  P : Nat

def splitOf (f : Fun) (sc : Scene.Scene) : Split := Id.run do
  let L := layers f.graph
  let outs := f.output.flatten
  let rayOut := outs.map fun i => L.ray[i]!
  let mut isRay : Array Bool := #[]
  let mut off : Array Nat := #[]
  let mut ns := 0
  let mut nr := 0
  let mut k := 0
  for e in sc do
    let w := e.shape.width
    let mut r := false
    for j in [0:w] do if rayOut[k + j]! then r := true
    isRay := isRay.push r
    if r then
      off := off.push nr
      nr := nr + w
    else
      off := off.push ns
      ns := ns + w
    k := k + w
  let P := if L.P != 0 then L.P else (match f.arrays[0]? with | some (_, p, _) => p | none => 1)
  return { isRay, off, rayOut, nStatic := ns, nRay := nr, P }

/-! ## The printed wrapper and the manifest -/

def jsonStr (s : String) : String :=
  let t := ((s.replace "\\" "\\\\").replace "\"" "\\\"")
  "\"" ++ ((t.replace "\n" " ").replace "\t" " ") ++ "\""

def jsonList (xs : List String) : String := "[" ++ ", ".intercalate xs ++ "]"

def upper (s : String) : String := s.map Char.toUpper

/-- C99: the scene, as one function over the scalar inputs and the ray table, writing the two
regions — `vs`, the static vertices, once; `vr`, `P` rows of `n_ray`, one per ray.  The node
lines are `Ccc.lean`'s own (`cNodeLines`); the phases are the graph's layers, so the C twin and
the Metal kernel are the same three phases written two ways. -/
def printSceneC (f : Fun) (sc : Scene.Scene) : String := Id.run do
  let g := f.graph
  let cn := cName f.name
  let tag := upper (sanitize f.name.getString!)
  let sp := splitOf f sc
  let L := layers g
  let outs := f.output.flatten
  let live := liveNodes g outs
  let sums := L.sums.filter live.contains
  let nameOf := fun (i : Nat) => ((f.inputs.find? (·.2 == i)).map (·.1)).getD "?"
  let node := fun (i : Nat) (ind : String) =>
    (cNodeLines f .value nameOf (fun _ => "0") (fun _ => ("0", "0", "0")) "hk_i" i).map (ind ++ ·)
  let params := (cParams f).push "hk_real HK_ADDR* vs" |>.push "hk_real HK_ADDR* vr"
  let mut ls : Array String := #[s!"HK_STATIC void {cn}({", ".intercalate params.toList}) \{"]
  if !L.err.isEmpty then ls := ls.push s!"#error \"{L.err}\""
  for i in [0:g.nodes.size] do
    if live.contains i && !L.ray[i]! && !L.post[i]! then ls := ls ++ node i "  "
  for sm in sums do ls := ls.push s!"  hk_real acc{sm} = HK_LIT(0);"
  ls := ls.push s!"  for (int hk_i = 0; hk_i < {sp.P}; ++hk_i) \{"
  for i in [0:g.nodes.size] do
    if live.contains i && L.ray[i]! then ls := ls ++ node i "    "
  for sm in sums do
    match g.nodes[sm]! with
    | .sum _ a => ls := ls.push s!"    acc{sm} += t{a};"
    | _ => pure ()
  -- the ray vertices, this row's
  let mut rk := 0
  for k in [0:outs.size] do
    if sp.rayOut[k]! then
      ls := ls.push s!"    vr[hk_i * {max sp.nRay 1} + {rk}] = t{outs[k]!};"
      rk := rk + 1
  ls := ls.push "  }"
  for i in [0:g.nodes.size] do
    if live.contains i && L.post[i]! then
      match g.nodes[i]! with
      | .sum _ _ => ls := ls.push s!"  const hk_real t{i} = acc{i};"
      | _ => ls := ls ++ node i "  "
  let mut sk := 0
  for k in [0:outs.size] do
    if !sp.rayOut[k]! then
      ls := ls.push s!"  vs[{sk}] = t{outs[k]!};"
      sk := sk + 1
  ls := ls.push "}"
  ls := ls.push ""
  let args := (List.range f.inputs.size).map fun i => s!"in[{i}]"
  let tabs := (List.range f.arrays.size).map fun i => s!"tab[{i}]"
  ls := ls.push s!"HK_STATIC void {cn}_eval(const hk_real *in, const hk_real *const *tab, hk_real *vs, hk_real *vr) \{"
  ls := ls.push s!"  {cn}({", ".intercalate (args ++ tabs ++ ["vs", "vr"])});"
  ls := ls.push "}"
  ls := ls.push s!"#define {tag}_N_TAB {f.arrays.size}"
  ls := ls.push s!"static const int {tag}_TAB[] = \{{", ".intercalate (f.arrays.toList.map fun (_, p, m) => toString (p * (if m == 0 then 1 else m)))}, 0};"
  ls := ls.push s!"static const char *{tag}_TABNAME[] = \{{", ".intercalate ((f.arrays.map (·.1)).toList.map jsonStr)}, 0};"
  ls := ls.push s!"#define {tag}_N_IN {f.inputs.size}"
  ls := ls.push s!"#define {tag}_N_STATIC {sp.nStatic}"
  ls := ls.push s!"#define {tag}_N_RAY {sp.nRay}"
  ls := ls.push s!"#define {tag}_P {sp.P}"
  ls := ls.push s!"#define {tag}_N_ENTRY {sc.length}"
  ls := ls.push s!"static const char *{tag}_INPUT[] = \{{", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr)}};"
  ls := ls.push s!"static const char *{tag}_LABEL[] = \{{", ".intercalate (sc.map fun e => jsonStr e.label)}};"
  ls := ls.push s!"static const int {tag}_KIND[] = \{{", ".intercalate (sc.map fun e => toString e.shape.kind.code)}};"
  ls := ls.push s!"static const int {tag}_COLOUR[] = \{{", ".intercalate (sc.map fun e => toString e.colour)}};"
  ls := ls.push s!"static const int {tag}_OFF[] = \{{", ".intercalate (sp.off.toList.map toString)}};"
  ls := ls.push s!"static const int {tag}_RAY[] = \{{", ".intercalate (sp.isRay.toList.map fun b => if b then "1" else "0")}};"
  ls := ls.push s!"static const int {tag}_W[] = \{{", ".intercalate (sc.map fun e => toString e.shape.width)}};"
  return "\n".intercalate ls.toList

/-! ## The scene as a Metal kernel

One threadgroup per frame, one thread per ray — the megakernel's own shape, with the outputs
split instead of only reduced.  Thread 0 computes the agent level and broadcasts what the rays
read through `hk_pre`; every thread evaluates its own row of the table and writes its own ray
vertices; the sums, when the scene has any (the composed env scene does), reduce in threadgroup
memory and thread 0 finishes and writes the static vertices. -/
def printMslScene (f : Fun) (sc : Scene.Scene) (kname : String) : String := Id.run do
  let g := f.graph
  let L := layers g
  let sp := splitOf f sc
  let outs := f.output.flatten
  let nin := f.inputs.size
  let P := sp.P
  let live := liveNodes g outs
  let sums := L.sums.filter live.contains
  let mut params : Array String := #["device const float* hk_x [[buffer(0)]]"]
  let mut bi := 1
  for (b, _, _) in f.arrays do
    params := params.push s!"device const float* {b}_all [[buffer({bi})]]"
    bi := bi + 1
  params := params.push s!"device float* hk_vs [[buffer({bi})]]"
  params := params.push s!"device float* hk_vr [[buffer({bi + 1})]]"
  params := params.push s!"device const int* hk_n [[buffer({bi + 2})]]"
  let mut lines : Array String := #[]
  lines := lines.push s!"kernel void {kname}({", ".intercalate params.toList}, uint hk_b [[threadgroup_position_in_grid]], uint hk_i [[thread_position_in_threadgroup]]) \{"
  lines := lines.push "  if ((int)hk_b >= hk_n[0]) return;"
  for sm in sums do lines := lines.push s!"  threadgroup float hk_sh{sm}[{P}];"
  lines := lines.push s!"  device const float* hk_xb = hk_x + hk_b * {nin};"
  for (b, p, m) in f.arrays do
    lines := lines.push s!"  device const float* {b} = {b}_all + hk_b * {p * (if m == 0 then 1 else m)};"
  let mut inIdx : Std.HashMap Nat Nat := {}
  for k in [0:nin] do inIdx := inIdx.insert (f.inputs[k]!).2 k
  let inRef := fun (i : Nat) => if g.isBool i then s!"(hk_xb[{inIdx.getD i 0}] != 0.0f)" else s!"hk_xb[{inIdx.getD i 0}]"
  let node := fun (i : Nat) (ind : String) =>
    (cNodeLines f .value inRef (fun _ => "0") (fun _ => ("0", "0", "0")) "hk_i" i).map (ind ++ ·)
  if !L.err.isEmpty then lines := lines.push s!"#error \"{L.err}\""
  let isA := fun (i : Nat) => live.contains i && !L.ray[i]! && !L.post[i]!
  -- the agent level once, on thread 0, broadcast to the rays
  let mut needed : Array Nat := #[]
  let mut seen : Std.HashSet Nat := {}
  for i in [0:g.nodes.size] do
    if live.contains i && L.ray[i]! then
      for d in g.nodes[i]!.deps do
        if isA d && !seen.contains d then
          seen := seen.insert d
          needed := needed.push d
  lines := lines.push s!"  threadgroup float hk_pre[{max needed.size 1}];"
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
  -- every thread: its own row of the table, and its own ray vertices
  for i in [0:g.nodes.size] do
    if live.contains i && L.ray[i]! then lines := lines ++ node i "  "
  let mut rk := 0
  for k in [0:outs.size] do
    if sp.rayOut[k]! then
      lines := lines.push s!"  hk_vr[(hk_b * {P} + hk_i) * {max sp.nRay 1} + {rk}] = t{outs[k]!};"
      rk := rk + 1
  for sm in sums do
    match g.nodes[sm]! with
    | .sum _ a => lines := lines.push s!"  hk_sh{sm}[hk_i] = t{a};"
    | _ => pure ()
  lines := lines.push "  threadgroup_barrier(mem_flags::mem_threadgroup);"
  lines := lines.push "  if (hk_i == 0) {"
  for sm in sums do
    lines := lines.push s!"    \{ float acc = 0.0f; for (int j = 0; j < {P}; ++j) acc += hk_sh{sm}[j]; hk_sh{sm}[0] = acc; }"
  for i in [0:g.nodes.size] do
    if live.contains i && L.post[i]! then
      match g.nodes[i]! with
      | .sum _ _ => lines := lines.push s!"    const hk_real t{i} = hk_sh{i}[0];"
      | _ => lines := lines ++ node i "    "
  let mut sk := 0
  for k in [0:outs.size] do
    if !sp.rayOut[k]! then
      lines := lines.push s!"    hk_vs[hk_b * {max sp.nStatic 1} + {sk}] = t{outs[k]!};"
      sk := sk + 1
  lines := lines.push "  }"
  lines := lines.push "}"
  return "\n".intercalate lines.toList

/-! ## The NumPy twin of the same graph, with the two regions -/

def printNumpyScene (f : Fun) (sc : Scene.Scene) (fname : String) : String := Id.run do
  let g := f.graph
  let L := layers g
  let sp := splitOf f sc
  let outs := f.output.flatten
  let scalars := f.inputs.map (·.1)
  let params := scalars ++ (f.arrays.map (·.1))
  let mut lines : Array String := #[s!"def {fname}({", ".intercalate params.toList}):"]
  if !L.err.isEmpty then lines := lines.push s!"    raise ValueError({("\"" ++ L.err ++ "\"")})"
  for i in [0:g.nodes.size] do
    match npRhs f L i with
    | some r => lines := lines.push s!"    t{i} = {r}"
    | none => pure ()
  let shapeOf := if scalars.isEmpty then
      (if f.arrays.isEmpty then "()" else s!"({(f.arrays[0]!).1}.shape[0],)")
    else s!"np.broadcast(*[np.asarray(x) for x in [{", ".intercalate scalars.toList}]]).shape"
  lines := lines.push s!"    _sh = {shapeOf}"
  lines := lines.push s!"    _shr = _sh + ({sp.P},)"
  let stat := (List.range outs.size).filter (fun k => !sp.rayOut[k]!)
  let rays := (List.range outs.size).filter (fun k => sp.rayOut[k]!)
  let bc := fun (sh : String) (k : Nat) => s!"np.broadcast_to(np.asarray(t{outs[k]!}, dtype=float), {sh})"
  lines := lines.push ("    _vs = np.stack([" ++ ", ".intercalate (stat.map (bc "_sh")) ++ "], axis=-1) if " ++
    toString stat.length ++ " else np.zeros(_sh + (0,))")
  lines := lines.push ("    _vr = np.stack([" ++ ", ".intercalate (rays.map (bc "_shr")) ++ "], axis=-1) if " ++
    toString rays.length ++ " else np.zeros(_shr + (0,))")
  lines := lines.push "    return _vs, _vr"
  return "\n".intercalate lines.toList

/-- the entry of the C registry `render/main.c` walks -/
def registryRow (f : Fun) (sc : Scene.Scene) (sceneName : String) : String :=
  let cn := cName f.name
  let tag := upper (sanitize f.name.getString!)
  let _ := sc
  s!"  \{ {jsonStr sceneName}, {tag}_N_IN, {tag}_N_STATIC, {tag}_N_RAY, {tag}_P, {tag}_N_ENTRY, {tag}_N_TAB, {tag}_KIND, {tag}_COLOUR, " ++
  s!"{tag}_OFF, {tag}_W, {tag}_RAY, {tag}_TAB, {tag}_LABEL, {tag}_INPUT, {tag}_TABNAME, {cn}_eval }"

/-- how the manifest records a binding: an input by name, a literal, or the definition (and the
column of it) the binder is composed with -/
def boundJson : Scene.Bound → String
  | .inp n => jsonStr n
  | .lit v => "{\"lit\": " ++ toString v ++ "}"
  | .node d col => "{\"node\": " ++ jsonStr d ++
      (match col with | none => "" | some c => ", \"col\": " ++ toString c) ++ "}"

/-- a leaf, as the manifest records it: which definition, in which frame -/
def leafJson (l : Scene.Leaf) : String :=
  match l with
  | .pt d fr b => "{" ++ ", ".intercalate [
      "\"leaf\": \"pt\"", "\"defn\": " ++ jsonStr d,
      "\"frame\": " ++ (match fr with | none => "null" | some f => jsonStr f),
      "\"bind\": " ++ jsonList (b.map fun (x, y) => jsonList [jsonStr x, boundJson y])] ++ "}"
  | .num d c b => "{" ++ ", ".intercalate [
      "\"leaf\": \"num\"", "\"defn\": " ++ jsonStr d, "\"col\": " ++ toString c,
      "\"bind\": " ++ jsonList (b.map fun (x, y) => jsonList [jsonStr x, boundJson y])] ++ "}"

/-- the JSON manifest: what each entry is, which region and where in it its doubles are, which
ray tables the scene reads, and — the point of the whole exercise — which definition of the
specification each vertex came from. -/
def printSceneJson (f : Fun) (sc : Scene.Scene) (sceneName source kname : String) : String :=
  let sp := splitOf f sc
  let rows := (List.zip sc (List.zip sp.isRay.toList sp.off.toList)).map fun (e, r, off) =>
    "  {" ++ ", ".intercalate [
      "\"label\": " ++ jsonStr e.label,
      "\"kind\": " ++ jsonStr (toString (repr e.shape.kind)),
      "\"colour\": " ++ toString e.colour,
      "\"ray\": " ++ (if r then "true" else "false"),
      "\"offset\": " ++ toString off,
      "\"width\": " ++ toString e.shape.width,
      "\"leaves\": " ++ jsonList (e.shape.leaves.map leafJson)] ++ "}"
  let arrs := f.arrays.toList.map fun (b, p, m) =>
    "{\"name\": " ++ jsonStr b ++ ", \"P\": " ++ toString p ++ ", \"m\": " ++ toString m ++ "}"
  "{\n" ++
  "\"scene\": " ++ jsonStr sceneName ++ ",\n" ++
  "\"source\": " ++ jsonStr source ++ ",\n" ++
  "\"c\": " ++ jsonStr (cName f.name) ++ ",\n" ++
  "\"kernel\": " ++ jsonStr kname ++ ",\n" ++
  "\"inputs\": " ++ jsonList ((f.inputs.map (·.1)).toList.map jsonStr) ++ ",\n" ++
  "\"arrays\": " ++ jsonList arrs ++ ",\n" ++
  "\"rays\": " ++ toString sp.P ++ ",\n" ++
  "\"n_static\": " ++ toString sp.nStatic ++ ",\n" ++
  "\"n_ray\": " ++ toString sp.nRay ++ ",\n" ++
  "\"n_nodes\": " ++ toString f.graph.nodes.size ++ ",\n" ++
  "\"entries\": [\n" ++ ",\n".intercalate rows ++ "\n]\n}\n"

/-- the preamble every printed scene header opens with (the macros `Ccc.printC`'s output calls),
guarded so several headers may be included in one translation unit -/
def preamble (guard : String) : Array String := #[
  "/* generated by RequestProject/CccScene.lean - do not edit.",
  "   Every vertex below is a definition of the specification, composed with its frame IN THE",
  "   GRAPH and printed by RequestProject/Ccc.lean.  No geometry is written here or in C. */",
  s!"#ifndef {guard}", s!"#define {guard}",
  "#ifndef HK_NO_STD", "#include <math.h>", "#include <stdbool.h>", "#endif",
  "#ifndef HK_STATIC", "#define HK_STATIC static inline", "#endif",
  "#ifndef HK_ADDR", "#define HK_ADDR", "#endif",
  "#ifndef hk_real", "#define hk_real double", "#endif",
  "#ifndef HK_LIT", "#define HK_LIT(x) ((hk_real)(x))", "#endif",
  "#ifndef HK_PI", "#define HK_PI HK_LIT(3.14159265358979323846)", "#endif",
  "#ifndef hk_sqrt", "#define hk_sqrt(x) sqrt(hk_max((x), 0.0))", "#define hk_sin sin", "#define hk_cos cos",
  "#define hk_tan tan", "#define hk_atan atan", "#define hk_acos(x) acos(hk_min(hk_max((x), -1.0), 1.0))", "#define hk_asin(x) asin(hk_min(hk_max((x), -1.0), 1.0))",
  "#define hk_exp exp", "#define hk_log log",
  "#define hk_fabs fabs", "#define hk_floor floor", "#define hk_tanh tanh",
  "#define hk_min fmin", "#define hk_max fmax", "#endif",
  "#ifndef hk_eq",
  "#define hk_eq(a, b) (hk_fabs((a) - (b)) <= HK_LIT(1e-9) * hk_max(HK_LIT(1), hk_max(hk_fabs(a), hk_fabs(b))))",
  "#endif",
  "#ifndef hk_sigmoid", "#define hk_sigmoid(x) (HK_LIT(1) / (HK_LIT(1) + hk_exp(-(x))))", "#endif",
  "#ifndef HK_RADDR", "#define HK_RADDR", "#endif", ""]

/-- compile a scene and write its header, its Metal kernel, its NumPy twin and its manifest.
Returns the registry row, so a driver can collect several scenes into one table. -/
def emitScene (outDir : String) (root : Name) (name : Name) (sceneName source : String)
    (sc : Scene.Scene) (order : Option Name := none) : MetaM (Option String) := do
  match ← compileScene root name sc order with
  | .error msg =>
    logInfo m!"scene {sceneName} did not compile: {msg}"
    pure none
  | .ok f =>
    let sp := splitOf f sc
    logInfo m!"scene {sceneName}: {sc.length} entries, {sp.nStatic} static + {sp.P} x {sp.nRay} ray \
      doubles, {f.inputs.size} inputs, {f.arrays.size} tables, {f.graph.nodes.size} nodes"
    let guard := "SCENE_" ++ upper (sanitize name.getString!) ++ "_H"
    let h := (preamble guard).push (printSceneC f sc) |>.push "#endif"
    IO.FS.createDirAll outDir
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".h") ("\n".intercalate h.toList)
    let kname := "scene_" ++ sceneName
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".metal") (printMslScene f sc kname ++ "\n")
    let py : Array String := #[
      s!"# generated by RequestProject/CccScene.lean - do not edit.",
      s!"# The same graph as render/scene_{sceneName}.h and render/scene_{sceneName}.metal,",
      "# printed for NumPy: the reference twin.  It returns (static vertices, ray vertices).",
      "import numpy as np", "",
      "def hk_eq(a, b):",
      "    return np.abs(a - b) <= 1e-9 * np.maximum(1.0, np.maximum(np.abs(a), np.abs(b)))", "",
      printNumpyScene f sc (cName f.name), "",
      "INPUTS = " ++ jsonList ((f.inputs.map (·.1)).toList.map jsonStr) ++ "",
      "ARRAYS = " ++ jsonList (f.arrays.toList.map fun (b, p, m) =>
        "(" ++ jsonStr b ++ ", " ++ toString p ++ ", " ++ toString m ++ ")"),
      s!"N_STATIC = {sp.nStatic}", s!"N_RAY = {sp.nRay}", s!"P = {sp.P}",
      s!"KERNEL = {jsonStr kname}"]
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".py") ("\n".intercalate py.toList)
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".json")
      (printSceneJson f sc sceneName source kname)
    pure (some (registryRow f sc sceneName))

/-- the registry header: the scenes as one table, so `main.c` picks one by name. -/
def registryHeader (scenes : List String) (rows : List String) : String :=
  let incl := scenes.map fun s => s!"#include \"scene_{s}.h\""
  "\n".intercalate ([
    "/* generated by RequestProject/CccScene.lean - do not edit. */",
    "#ifndef SCENE_REGISTRY_H", "#define SCENE_REGISTRY_H"] ++ incl ++ [
    "typedef struct {",
    "  const char *name;",
    "  int n_in, n_static, n_ray, n_rays, n_entry, n_tab;",
    "  const int *kind, *colour, *off, *w, *ray, *tab;",
    "  const char **label;",
    "  const char **input;",
    "  const char **tabname;",
    "  void (*eval)(const hk_real *, const hk_real *const *, hk_real *, hk_real *);",
    "} hk_scene_t;",
    "static const hk_scene_t HK_SCENES[] = {"] ++ [",\n".intercalate rows] ++ [
    "};",
    s!"#define HK_N_SCENES {rows.length}",
    "#endif"])

end CccScene

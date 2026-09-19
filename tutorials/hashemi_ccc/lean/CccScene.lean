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

/-- the full signature a leaf needs: the frame's leading binders, then the definition's. -/
def leafSig (root : Name) (l : Scene.Leaf) : MetaM (Array (String × Expr)) := do
  let raw ← match l with
    | .pt d fr _ => do
      let a ← match fr with | none => pure #[] | some f => sigOf (root ++ f.toName) 1
      let b ← sigOf (root ++ d.toName)
      pure (a ++ b)
    | .num d _ _ => sigOf (root ++ d.toName)
  pure (raw.map fun (nm, ty) => (l.rename nm, ty))

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

/-! ## The compiler -/

/-- compile a whole scene into one `Ccc.Fun`.  `root` is the namespace whose definitions are
unfolded (`Ccc.translate`'s rule); `name` names the printed function. -/
def compileScene (root : Name) (name : Name) (sc : Scene.Scene) :
    MetaM (Except String Fun) := do
  try
    let sig ← sceneSig root sc
    let decls : Array (Name × (Array Expr → MetaM Expr)) :=
      sig.map fun (nm, ty) => (nm.toName, fun _ => pure ty)
    withLocalDeclsD decls fun xs => do
      let idx : Std.HashMap String Expr :=
        (Array.zip (sig.map (·.1)) xs).foldl (fun m (k, v) => m.insert k v) {}
      let get := fun (nm : String) => match idx[nm]? with
        | some e => pure e
        | none => throwError "the scene has no input {nm}"
      let act : TM Val := do
        for x in xs do
          let _ ← bindBinder root x xs.size
        let mut outs : Array Val := #[]
        for e in sc do
          for l in e.shape.leaves do
            match l with
            | .pt d fr _ => do
              let dn := root ++ d.toName
              let dargs ← (← sigOf dn).mapM fun (nm, _) => get (l.rename nm)
              let body := mkAppN (mkConst dn) dargs
              let expr ← match fr with
                | none => pure body
                | some f => do
                  let fn := root ++ f.toName
                  let fargs ← (← sigOf fn 1).mapM fun (nm, _) => get (l.rename nm)
                  pure (mkAppN (mkConst fn) (fargs.push body))
              let v ← translate root expr
              match v with
              | .vec vs =>
                unless vs.size == 3 do
                  throwError "the point {d} has {vs.size} components, not 3"
                outs := outs.push v
              | w => throwError "the point {d} is a {w.shape}, not three reals"
            | .num d c _ => do
              let dn := root ++ d.toName
              let dargs ← (← sigOf dn).mapM fun (nm, _) => get (l.rename nm)
              let v ← translate root (mkAppN (mkConst dn) dargs)
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

/-! ## The printed wrapper and the manifest -/

def jsonStr (s : String) : String :=
  let t := ((s.replace "\\" "\\\\").replace "\"" "\\\"")
  "\"" ++ ((t.replace "\n" " ").replace "\t" " ") ++ "\""

def jsonList (xs : List String) : String := "[" ++ ", ".intercalate xs ++ "]"

def upper (s : String) : String := s.map Char.toUpper

/-- C99: the scene's own function (printed by `Ccc.printC`), then a flat entry point taking the
inputs as an array, and the static tables the renderer reads.  Nothing geometric: the wrapper
only unpacks an array into the printed function's parameters. -/
def printSceneC (f : Fun) (sc : Scene.Scene) : String := Id.run do
  let cn := cName f.name
  let tag := upper (sanitize f.name.getString!)
  let offs := Scene.Scene.offsets sc
  let mut ls : Array String := #[printC f, ""]
  let args := (List.range f.inputs.size).map fun i => s!"in[{i}]"
  ls := ls.push s!"HK_STATIC void {cn}_eval(const hk_real *in, hk_real *verts) \{"
  ls := ls.push s!"  {cn}({", ".intercalate args}{if f.inputs.isEmpty then "" else ", "}verts);"
  ls := ls.push "}"
  ls := ls.push s!"#define {tag}_N_IN {f.inputs.size}"
  ls := ls.push s!"#define {tag}_N_VERT {Scene.Scene.width sc}"
  ls := ls.push s!"#define {tag}_N_ENTRY {sc.length}"
  ls := ls.push s!"static const char *{tag}_INPUT[] = \{{", ".intercalate ((f.inputs.map (·.1)).toList.map jsonStr)}};"
  ls := ls.push s!"static const char *{tag}_LABEL[] = \{{", ".intercalate (sc.map fun e => jsonStr e.label)}};"
  ls := ls.push s!"static const int {tag}_KIND[] = \{{", ".intercalate (sc.map fun e => toString e.shape.kind.code)}};"
  ls := ls.push s!"static const int {tag}_COLOUR[] = \{{", ".intercalate (sc.map fun e => toString e.colour)}};"
  ls := ls.push s!"static const int {tag}_OFF[] = \{{", ".intercalate (offs.map toString)}};"
  ls := ls.push s!"static const int {tag}_W[] = \{{", ".intercalate (sc.map fun e => toString e.shape.width)}};"
  return "\n".intercalate ls.toList

/-- the entry of the C registry `render/main.c` walks -/
def registryRow (f : Fun) (sceneName : String) : String :=
  let cn := cName f.name
  let tag := upper (sanitize f.name.getString!)
  s!"  \{ {jsonStr sceneName}, {tag}_N_IN, {tag}_N_VERT, {tag}_N_ENTRY, {tag}_KIND, {tag}_COLOUR, " ++
  s!"{tag}_OFF, {tag}_W, {tag}_LABEL, {tag}_INPUT, {cn}_eval }"

/-- a leaf, as the manifest records it: which definition, in which frame -/
def leafJson (l : Scene.Leaf) : String :=
  match l with
  | .pt d fr b => "{" ++ ", ".intercalate [
      "\"leaf\": \"pt\"", "\"defn\": " ++ jsonStr d,
      "\"frame\": " ++ (match fr with | none => "null" | some f => jsonStr f),
      "\"bind\": " ++ jsonList (b.map fun (x, y) => jsonList [jsonStr x, jsonStr y])] ++ "}"
  | .num d c b => "{" ++ ", ".intercalate [
      "\"leaf\": \"num\"", "\"defn\": " ++ jsonStr d, "\"col\": " ++ toString c,
      "\"bind\": " ++ jsonList (b.map fun (x, y) => jsonList [jsonStr x, jsonStr y])] ++ "}"

/-- the JSON manifest: what each entry is, where its doubles are, and — the point of the whole
exercise — which definition of the specification each vertex came from. -/
def printSceneJson (f : Fun) (sc : Scene.Scene) (sceneName source : String) : String :=
  let offs := Scene.Scene.offsets sc
  let rows := (List.zip sc offs).map fun (e, off) =>
    "  {" ++ ", ".intercalate [
      "\"label\": " ++ jsonStr e.label,
      "\"kind\": " ++ jsonStr (toString (repr e.shape.kind)),
      "\"colour\": " ++ toString e.colour,
      "\"offset\": " ++ toString off,
      "\"width\": " ++ toString e.shape.width,
      "\"leaves\": " ++ jsonList (e.shape.leaves.map leafJson)] ++ "}"
  "{\n" ++
  "\"scene\": " ++ jsonStr sceneName ++ ",\n" ++
  "\"source\": " ++ jsonStr source ++ ",\n" ++
  "\"c\": " ++ jsonStr (cName f.name) ++ ",\n" ++
  "\"inputs\": " ++ jsonList ((f.inputs.map (·.1)).toList.map jsonStr) ++ ",\n" ++
  "\"n_vert\": " ++ toString (Scene.Scene.width sc) ++ ",\n" ++
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
  "#ifndef hk_sqrt", "#define hk_sqrt sqrt", "#define hk_sin sin", "#define hk_cos cos",
  "#define hk_tan tan", "#define hk_atan atan", "#define hk_acos acos", "#define hk_asin asin",
  "#define hk_exp exp", "#define hk_log log",
  "#define hk_fabs fabs", "#define hk_floor floor", "#define hk_tanh tanh",
  "#define hk_min fmin", "#define hk_max fmax", "#endif",
  "#ifndef hk_eq",
  "#define hk_eq(a, b) (hk_fabs((a) - (b)) <= HK_LIT(1e-9) * hk_max(HK_LIT(1), hk_max(hk_fabs(a), hk_fabs(b))))",
  "#endif",
  "#ifndef hk_sigmoid", "#define hk_sigmoid(x) (HK_LIT(1) / (HK_LIT(1) + hk_exp(-(x))))", "#endif",
  "#ifndef HK_RADDR", "#define HK_RADDR", "#endif", ""]

/-- compile a scene and write its header, its NumPy twin and its manifest.  Returns the registry
row, so a driver can collect several scenes into one table. -/
def emitScene (outDir : String) (root : Name) (name : Name) (sceneName source : String)
    (sc : Scene.Scene) : MetaM (Option String) := do
  match ← compileScene root name sc with
  | .error msg =>
    logInfo m!"scene {sceneName} did not compile: {msg}"
    pure none
  | .ok f =>
    logInfo m!"scene {sceneName}: {sc.length} entries, {Scene.Scene.width sc} doubles, \
      {f.inputs.size} inputs, {f.graph.nodes.size} nodes"
    let guard := "SCENE_" ++ upper (sanitize name.getString!) ++ "_H"
    let h := (preamble guard).push (printSceneC f sc) |>.push "#endif"
    IO.FS.createDirAll outDir
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".h") ("\n".intercalate h.toList)
    let py : Array String := #[
      s!"# generated by RequestProject/CccScene.lean - do not edit.",
      s!"# The same graph as render/scene_{sceneName}.h, printed for NumPy: the reference twin.",
      "import numpy as np", "",
      "def hk_eq(a, b):",
      "    return np.abs(a - b) <= 1e-9 * np.maximum(1.0, np.maximum(np.abs(a), np.abs(b)))", "",
      printNumpy f (cName f.name), "",
      "INPUTS = " ++ jsonList ((f.inputs.map (·.1)).toList.map jsonStr) ++ "",
      s!"N_VERT = {Scene.Scene.width sc}"]
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".py") ("\n".intercalate py.toList)
    IO.FS.writeFile (outDir ++ "/scene_" ++ sceneName ++ ".json")
      (printSceneJson f sc sceneName source)
    pure (some (registryRow f sceneName))

/-- the registry header: the three scenes as one table, so `main.c` picks one by name. -/
def registryHeader (scenes : List String) (rows : List String) : String :=
  let incl := scenes.map fun s => s!"#include \"scene_{s}.h\""
  "\n".intercalate ([
    "/* generated by RequestProject/CccScene.lean - do not edit. */",
    "#ifndef SCENE_REGISTRY_H", "#define SCENE_REGISTRY_H"] ++ incl ++ [
    "typedef struct {",
    "  const char *name;",
    "  int n_in, n_vert, n_entry;",
    "  const int *kind, *colour, *off, *w;",
    "  const char **label;",
    "  const char **input;",
    "  void (*eval)(const hk_real *, hk_real *);",
    "} hk_scene_t;",
    "static const hk_scene_t HK_SCENES[] = {"] ++ [",\n".intercalate rows] ++ [
    "};",
    s!"#define HK_N_SCENES {rows.length}",
    "#endif"])

end CccScene

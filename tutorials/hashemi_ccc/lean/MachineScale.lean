/-
# `lake exe machine_scale <a> [out.json]`

The machine of `RequestProject/HashemiScale.lean` at the reflector half-side `a`: the derived
table on stdout with a verdict per constraint, and, when a path is given, the JSON the runtime
reads (`tutorials/hashemi_ccc/hashemi_machine_<a>.json`) - the kernel's optics inputs `R f a w rc`,
the mount parameters `rDrum W rcm Tmax rho Fdrive L10 rodLen`, every derived build dimension and
every verdict.

Before it prints anything it checks the Float twin against the intervals `Hashemi.lean` PROVES at
`a = 0.8` (`hisChecks`): if `#machine 0.8` ever stops being his machine, the exe fails here.
-/
import RequestProject.HashemiScale

open TandoorHashemi

/-- the Float twin at `a = 0.8` against the theorems' own intervals -/
def checkHis : Except String Unit := do
  let m := deriveF { a := 0.8 }
  for (n, lo, hi) in hisChecks do
    let v := fieldOf m n
    unless lo < v && v < hi do
      throw s!"a = 0.8: {n} = {v} outside the proved interval ({lo}, {hi})"
  return ()

/-- a decimal numeral as a Float: `2`, `2.0`, `0.85` (Lean 4.28 has no `String.toFloat?`) -/
def parseFloat (s : String) : Option Float :=
  match s.splitOn "." with
  | [w] => (w.toNat?).map Float.ofNat
  | [w, d] => do
      let wi ← w.toNat?
      let di ← d.toNat?
      let scale := d.foldl (fun x _ => x * 10.0) 1.0
      return Float.ofNat wi + Float.ofNat di / scale
  | _ => none

def main (args : List String) : IO UInt32 := do
  match checkHis with
  | .error e => IO.eprintln s!"his machine moved: {e}"; return 1
  | .ok _ => pure ()
  let a := match args with
    | s :: _ => (parseFloat s).getD 0.8
    | [] => 0.8
  if a ≤ 0 then
    IO.eprintln "machine_scale: the half-side must be positive"
    return 1
  IO.println (report a)
  match args with
  | _ :: out :: _ =>
      IO.FS.writeFile out (machineJson a)
      IO.println s!"wrote {out}"
  | _ => pure ()
  let bad := (checksF (deriveF { a := a })).filter (fun r => r.2.2.2 != "holds")
  for r in bad do
    IO.println s!"  NOT HELD: {r.1} ({r.2.2.2}: {r.2.1} < {r.2.2.1})"
  return 0

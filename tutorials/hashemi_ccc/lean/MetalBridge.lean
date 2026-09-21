/-
# Lean calls Metal

`MetalBridge.run` hands an MSL source, a kernel name and buffers to `lean_mtl_run`
(tutorials/hashemi_ccc/bridge/metal_bridge.m): the shim JIT-compiles the source, binds each
`FloatArray` at its index (as float32, or int32 when its kind is 1), dispatches `grid` threads,
waits, and returns every buffer. Any kernel of the project runs from Lean through it - the
handwritten trace, the generated megakernel, his dish's trace - so a theorem can be measured on
the GPU inside a Lean program (`lake exe trace_check`).
-/
namespace MetalBridge

/-- kinds: 0 = float32, 1 = int32 (rounded). `tg` 0 = the pipeline's own threadgroup size. -/
@[extern "lean_mtl_run"]
opaque run (src kernel : @& String) (bufs : @& Array FloatArray) (kinds : @& Array Nat)
    (grid tg : USize) : IO (Array FloatArray)

/-- a raw little-endian float64 file as a FloatArray -/
def readF64 (path : System.FilePath) : IO FloatArray := do
  let bytes ← IO.FS.readBinFile path
  let n := bytes.size / 8
  let mut out : FloatArray := FloatArray.emptyWithCapacity n
  for i in [0:n] do
    let mut u : UInt64 := 0
    for k in [0:8] do
      u := u ||| ((bytes.get! (8 * i + k)).toUInt64 <<< (8 * k).toUInt64)
    out := out.push (Float.ofBits u)
  pure out

/-- a FloatArray of one value -/
def const (n : Nat) (v : Float) : FloatArray := ⟨Array.replicate n v⟩

def sum (a : FloatArray) : Float := a.foldl (· + ·) 0.0

def maxAbs (a : FloatArray) : Float := a.foldl (fun m x => max m (Float.abs x)) 0.0

end MetalBridge

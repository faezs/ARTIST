import RequestProject.MetalBridge

/-- a two-line kernel through the bridge: y = 2 x -/
def main : IO Unit := do
  let src := "#include <metal_stdlib>\nusing namespace metal;\n" ++
    "kernel void twice(device const float* x [[buffer(0)]], device float* y [[buffer(1)]], " ++
    "device const int* n [[buffer(2)]], uint i [[thread_position_in_grid]]) { if ((int)i >= n[0]) return; y[i] = 2.0f * x[i]; }"
  let x : FloatArray := ⟨#[1.0, 2.5, -3.0, 4.25]⟩
  let out ← MetalBridge.run src "twice" #[x, MetalBridge.const 4 0.0, ⟨#[4.0]⟩] #[0, 0, 1] 4 0
  IO.println s!"bridge: {out[1]!.toList}"
  if out[1]!.toList == [2.0, 5.0, -6.0, 8.5] then IO.println "BRIDGE OK" else throw (IO.userError "bridge mismatch")

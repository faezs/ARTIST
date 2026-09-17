"""His dish's ray trace, generated from HashemiTrace.lean, as a Metal kernel and a ray sampler.

`hk_traceRay` (hashemi_ccc.h) is one ray on the faceted panel to the coil's plane; this module
runs it for B agents x P rays (`hashemi_trace`), samples the rays - a facet on the 5 cm grid, a
point within it, the sun's direction in the dish's frame with the sun's disc - and returns the
capture fraction per agent, the traced replacement of the added model `coilCapture`.
    python hashemi_trace_kernel.py    # Metal vs the NumPy twin on random rays, and the capture curve
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
from hashemi_kernel import MSL_PRELUDE, CUDA_PRELUDE, header_text   # noqa: E402

RAY_W, OUT_W, PRM_W = 7, 8, 5           # cx cy ux uy dx dy dz | Lx Ly r captured fate hitz crad up | R f a w rc
SUN_HALF_ANGLE = 4.65e-3                # rad, the sun's disc


def trace_params_numpy():
    import hashemi_ccc as H
    return np.asarray(H.hk_traceParams(), dtype=np.float64).reshape(PRM_W)


KERNEL = f"""
kernel void hashemi_trace(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                          device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                          uint i [[thread_position_in_grid]]) {{
  if ((int)i >= n[0]) return;
  const float R = prm[0], f = prm[1], a = prm[2], w = prm[3], rc = prm[4];
  float row[{OUT_W}];
  hk_traceRay(R, f, a, w, rc, rays[i*{RAY_W}+0], rays[i*{RAY_W}+1], rays[i*{RAY_W}+2], rays[i*{RAY_W}+3],
              rays[i*{RAY_W}+4], rays[i*{RAY_W}+5], rays[i*{RAY_W}+6], row);
  for (int k = 0; k < {OUT_W}; ++k) out[i*{OUT_W}+k] = row[k];
}}
"""


SPHERE_KERNELS = """
kernel void hashemi_sphere(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                           device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                           uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[5];
  hk_traceSphere(prm[0], prm[1], rays[i*6+0], rays[i*6+1], rays[i*6+2], rays[i*6+3], rays[i*6+4], rays[i*6+5], row);
  for (int k = 0; k < 5; ++k) out[i*5+k] = row[k];
}

kernel void hashemi_sun(device const float* pose [[buffer(0)]], device const float* prm [[buffer(1)]],
                        device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                        uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[3];
  hk_sunInDish(pose[i*4+0], pose[i*4+1], pose[i*4+2], pose[i*4+3], row);
  out[i*3+0] = row[0]; out[i*3+1] = row[1]; out[i*3+2] = row[2];
}

kernel void hashemi_facet(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                          device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                          uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[5];
  hk_traceFacet(prm[0], prm[1], rays[i*8+0], rays[i*8+1], rays[i*8+2], rays[i*8+3], rays[i*8+4],
                rays[i*8+5], rays[i*8+6], rays[i*8+7], row);
  for (int k = 0; k < 5; ++k) out[i*5+k] = row[k];
}

kernel void hashemi_conic(device const float* rays [[buffer(0)]], device const float* prm [[buffer(1)]],
                          device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                          uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  float row[9];
  hk_traceConic(prm[0], prm[1], prm[2], rays[i*6+0], rays[i*6+1], rays[i*6+2], rays[i*6+3], rays[i*6+4], rays[i*6+5], row);
  for (int k = 0; k < 9; ++k) out[i*9+k] = row[k];
}

kernel void hashemi_sphere_formulas(device const float* rh [[buffer(0)]], device const float* prm [[buffer(1)]],
                                    device float* out [[buffer(2)]], device const int* n [[buffer(3)]],
                                    uint i [[thread_position_in_grid]]) {
  if ((int)i >= n[0]) return;
  const float R = rh[i*3+0], h = rh[i*3+1], p = rh[i*3+2];
  out[i*4+0] = hk_sphereFocal(R, h);
  out[i*4+1] = hk_sphereDev(R, h, p);
  out[i*4+2] = hk_sphereBlur(R, h);
  out[i*4+3] = hk_sphereBestFocus(R, h);
}
"""


def msl_source():
    return MSL_PRELUDE + header_text() + KERNEL + SPHERE_KERNELS


def emit_metal_sources():
    """the pieces the Lean program assembles: the prelude and the kernels (it reads the header itself)"""
    bridge = os.path.join(HERE, "bridge")
    with open(os.path.join(bridge, "msl_prelude.metal"), "w") as f:
        f.write(MSL_PRELUDE)
    with open(os.path.join(bridge, "hashemi_trace.metal"), "w") as f:
        f.write(KERNEL + SPHERE_KERNELS)


def cuda_source():
    return CUDA_PRELUDE + header_text() + KERNEL.replace("kernel void", 'extern "C" __global__ void').replace(
        " [[buffer(0)]]", "").replace(" [[buffer(1)]]", "").replace(" [[buffer(2)]]", "").replace(" [[buffer(3)]]", "").replace(
        "uint i [[thread_position_in_grid]]", "int i_unused").replace("if ((int)i >= n[0]) return;", "const int i = blockIdx.x * blockDim.x + threadIdx.x; if (i >= n[0]) return;")


def sample_rays(B, P, sun_dish, rng, a=0.8, w=0.05, disc=True):
    """rays for B agents: sun_dish (B,3) the sun in the dish's frame (unit, toward the sun);
    each ray a facet centre on the w-grid within the panel, a point within the facet, the direction
    -sun tilted by a draw within the sun's disc. Returns (B*P, 7) float32."""
    n_side = int(round(2 * a / w))                                   # 32 facets a side
    ci = rng.integers(0, n_side, (B, P))
    cj = rng.integers(0, n_side, (B, P))
    cx = -a + w / 2 + ci * w
    cy = -a + w / 2 + cj * w
    ux = rng.uniform(-w / 2, w / 2, (B, P))
    uy = rng.uniform(-w / 2, w / 2, (B, P))
    s = -np.asarray(sun_dish, dtype=np.float64)[:, None, :] * np.ones((1, P, 1))   # toward the dish
    if disc:
        # a uniform draw on the sun's disc: rotate s by an angle rho <= half-angle about a random axis normal to s
        rho = SUN_HALF_ANGLE * np.sqrt(rng.random((B, P)))
        phi = rng.uniform(0, 2 * np.pi, (B, P))
        # an orthonormal pair (e1, e2) normal to s
        helper = np.where(np.abs(s[..., 2:3]) < 0.9, np.array([0.0, 0.0, 1.0]), np.array([1.0, 0.0, 0.0]))
        e1 = np.cross(s, helper); e1 /= np.linalg.norm(e1, axis=-1, keepdims=True)
        e2 = np.cross(s, e1)
        s = np.cos(rho)[..., None] * s + np.sin(rho)[..., None] * (np.cos(phi)[..., None] * e1 + np.sin(phi)[..., None] * e2)
    rays = np.concatenate([cx[..., None], cy[..., None], ux[..., None], uy[..., None], s], axis=-1)
    return rays.reshape(B * P, RAY_W).astype(np.float32)


def sun_in_dish(az, t, el_sun, az_sun):
    """`sunInDish` of HashemiTrace.lean, from the NumPy twin (the compiled definition)"""
    import hashemi_ccc as H
    B = np.broadcast(az, t, el_sun, az_sun).size
    out = np.asarray(H.hk_sunInDish(np.broadcast_to(az, B), np.broadcast_to(t, B), np.broadcast_to(el_sun, B),
                                    np.broadcast_to(az_sun, B)), dtype=np.float64)
    return out.reshape(B, 3)


def trace_numpy(rays, prm):
    import hashemi_ccc as H
    r = np.asarray(rays, dtype=np.float64)
    pr = np.broadcast_to(np.asarray(prm, dtype=np.float64), (r.shape[0], PRM_W))
    args = [pr[:, k] for k in range(PRM_W)] + [r[:, k] for k in range(RAY_W)]
    return np.asarray(H.hk_traceRay(*args), dtype=np.float64).reshape(r.shape[0], OUT_W)


class HashemiTraceMetal:
    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(msl_source())
        self._buf = {}

    def run(self, rays, prm):
        """rays (N,7) float32 mps tensor; prm (5,) mps; returns out (N,8)"""
        torch = self.torch
        N = rays.shape[0]
        bufs = self._buf.get(N)
        if bufs is None:
            bufs = (torch.empty(N, OUT_W, dtype=torch.float32, device="mps"), torch.tensor([N], dtype=torch.int32, device="mps"))
            self._buf[N] = bufs
        out, nN = bufs
        self.lib.hashemi_trace(rays.contiguous(), prm.to(torch.float32).contiguous(), out, nN)
        return out

    def capture(self, rays_np, prm_np, B, P):
        torch = self.torch
        out = self.run(torch.as_tensor(rays_np, device="mps"), torch.as_tensor(prm_np, dtype=torch.float32, device="mps"))
        return out[:, 3].reshape(B, P).mean(1).cpu().numpy().astype(np.float64)


if __name__ == "__main__":
    emit_metal_sources()
    rng = np.random.default_rng(5)
    prm = trace_params_numpy()
    B, P = 64, 512
    # the sun dead ahead, then at pointing errors 0..5 deg: the capture curve, Metal vs NumPy
    print("params R f a w rc:", prm)
    errs = np.radians(np.array([0.0, 0.5, 1.0, 1.5, 1.74, 2.0, 2.5, 3.0, 4.0, 5.0]))
    try:
        import torch
        k = HashemiTraceMetal()
    except Exception as e:
        print("Metal unavailable:", e); k = None
    import hashemi_ccc as H
    worst = 0.0
    print("  eps[deg]  capture(trace)  coilCapture(model)  max|Metal-NumPy|")
    for e in errs:
        sun = np.stack([np.sin(e) * np.ones(B), np.zeros(B), np.cos(e) * np.ones(B)], 1)   # in the dish's frame
        rays = sample_rays(B, P, sun, rng)
        ref = trace_numpy(rays, prm)
        cap_ref = ref[:, 3].reshape(B, P).mean(1)
        model = float(H.hk_coilCapture(0.0593 / 2, 0.06, np.tan(e)))
        d = 0.0
        if k is not None:
            out = k.run(torch.as_tensor(rays, device="mps"), torch.as_tensor(prm, dtype=torch.float32, device="mps")).cpu().numpy()
            d = float(np.abs(out[:, :3] - ref[:, :3]).max()); worst = max(worst, d)
            flips = float((out[:, 3] != ref[:, 3]).mean())
        print(f"  {np.degrees(e):6.2f}    {cap_ref.mean():8.3f}        {model:8.3f}          {d:.2e}" + (f"  flips {100 * flips:.2f} %" if k else ""))
    print("METAL == NUMPY (landings within 1e-4 m)" if worst < 1e-4 else f"MISMATCH {worst:.2e}")
    sys.exit(0 if worst < 1e-4 else 1)

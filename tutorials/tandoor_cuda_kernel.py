"""The megakernels on CUDA: the MSL source, transpiled at load.

There is ONE kernel source - tandoor_metal_kernel.MSL - and this
module turns it into CUDA C++ mechanically (regex transforms plus a
small compatibility preamble: an f3 struct standing in for Metal's
float3, math-name macros, clamp/sign/min/max overloads, atomicAdd).
NVRTC JIT-compiles it through CuPy at first use, the way
torch.mps.compile_shader does on the Mac. The two backends therefore
CANNOT drift: a physics change lands in _geo_core, is transcribed
once into the MSL, and both GPUs pick it up.

CudaGeo subclasses MetalGeo and overrides only construction -
mount() and __call__ are already device-agnostic (they only touch
self.lib.<kernel>), so the whole fused-step host path (FusedState,
fused_full_step, the parity harnesses) runs on CUDA unchanged. The
frozen zero-noise bundle generated on MPS is the cross-backend gate:
tandoor_step_verify.py check on a CUDA box replays it through these
kernels.

Why not OptiX: every intersection in this trace is closed form
(cylinders, one fold, conic CPC segments, an ellipsoid quadric, a
plane, a sphere). RT cores accelerate BVH traversal over triangles;
tessellating exact surfaces would trade the parity discipline for an
acceleration structure the problem does not have. At ~10^5-10^7
rays/step a plain one-thread-per-ray kernel is the right shape.

puff_adv rides along: the same vtrace scan tandoor_mps_advantage
runs on Metal, natively on CUDA - pufferlib's wheel ships without
its CUDA advantage op, and the source-patched device loop (128
sequential slice kernels per call, every minibatch) is the prime
suspect for the flat ~10 us/step train cost measured on the L4.
"""
import functools
import re

import torch

from tandoor_metal_kernel import MSL, MetalGeo
import tandoor_mps_advantage as _adv_mod

_PREAMBLE = r"""
typedef unsigned int uint;
typedef unsigned long long ulong;
#define M_PI_F 3.14159265358979f
#define sin sinf
#define cos cosf
#define asin asinf
#define acos acosf
#define atan2 atan2f
#define sqrt sqrtf
#define exp expf
#define pow powf
#define fabs fabsf
#define fmin fminf
#define fmax fmaxf
typedef float atomic_float;
#define memory_order_relaxed 0
#define atomic_fetch_add_explicit(P, V, O) atomicAdd((float*)(P), (V))

__device__ inline float min(float a, float b) { return fminf(a, b); }
__device__ inline float max(float a, float b) { return fmaxf(a, b); }
__device__ inline int min(int a, int b) { return a < b ? a : b; }
__device__ inline int max(int a, int b) { return a > b ? a : b; }
__device__ inline float clamp(float v, float lo, float hi) {
    return fminf(fmaxf(v, lo), hi); }
__device__ inline int clamp(int v, int lo, int hi) {
    return v < lo ? lo : (v > hi ? hi : v); }
__device__ inline float sign(float v) {
    return v > 0.0f ? 1.0f : (v < 0.0f ? -1.0f : 0.0f); }

struct f3 {
    float x, y, z;
    __device__ f3() {}
    __device__ f3(float a, float b, float c) : x(a), y(b), z(c) {}
};
__device__ inline f3 operator+(f3 a, f3 b) {
    return f3(a.x + b.x, a.y + b.y, a.z + b.z); }
__device__ inline f3 operator-(f3 a, f3 b) {
    return f3(a.x - b.x, a.y - b.y, a.z - b.z); }
__device__ inline f3 operator-(f3 a) { return f3(-a.x, -a.y, -a.z); }
__device__ inline f3 operator*(f3 a, f3 b) {
    return f3(a.x * b.x, a.y * b.y, a.z * b.z); }
__device__ inline f3 operator*(float s, f3 a) {
    return f3(s * a.x, s * a.y, s * a.z); }
__device__ inline f3 operator*(f3 a, float s) { return s * a; }
__device__ inline f3 operator/(f3 a, float s) {
    float inv = 1.0f / s; return inv * a; }
__device__ inline float dot(f3 a, f3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z; }
__device__ inline f3 cross(f3 a, f3 b) {
    return f3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z,
              a.x * b.y - a.y * b.x); }
__device__ inline float length(f3 a) { return sqrtf(dot(a, a)); }
__device__ inline f3 normalize(f3 a) { return a / length(a); }
"""


def transpile(msl):
    """MSL -> CUDA C++: mechanical transforms only. Anything this
    cannot express belongs in the preamble, not in edits to the
    kernel source - one source of truth."""
    s = msl
    s = s.replace("#include <metal_stdlib>", "")
    s = s.replace("using namespace metal;", "")
    s = re.sub(r"\s*\[\[buffer\(\d+\)\]\]", "", s)
    s = re.sub(
        r",([^\n]*)\n\s*uint\s+(\w+)\s+"
        r"\[\[thread_position_in_grid\]\]\)\s*\{",
        ")\\1\n{\n    const uint \\2 = blockIdx.x * blockDim.x"
        " + threadIdx.x;",
        s)
    s = s.replace("kernel void", 'extern "C" __global__ void')
    s = s.replace("static inline", "__device__ static inline")
    s = s.replace("device ", "")
    s = s.replace("thread ", "")
    s = re.sub(r"\bfloat3\b", "f3", s)
    return s


def _preload_cuda_libs():
    """CuPy dlopens libnvrtc/libcudart by soname; slim images keep
    them only inside torch's bundled nvidia-* wheels, off the loader
    path. Loading them here with RTLD_GLOBAL makes glibc hand CuPy
    the already-loaded handles."""
    import ctypes
    import glob
    import os
    for mod, sub in (("nvidia.cuda_nvrtc", "lib"),
                     ("nvidia.cuda_runtime", "lib")):
        try:
            m = __import__(mod, fromlist=["lib"])
            d = os.path.join(os.path.dirname(m.__file__), sub)
        except Exception:
            continue
        for f in sorted(glob.glob(os.path.join(d, "lib*.so*"))):
            try:
                ctypes.CDLL(f, mode=ctypes.RTLD_GLOBAL)
            except OSError:
                pass


_LIB = None


class _CudaLib:
    """Named-kernel launcher over one NVRTC module; mirrors the
    torch.mps.compile_shader calling convention (positional torch
    tensors; grid = numel of the FIRST argument, in-kernel guards
    handle the overhang) so MetalGeo's host code runs unchanged."""

    def __init__(self, source):
        import cupy as cp
        self._cp = cp
        self._mod = cp.RawModule(code=source,
                                 options=("-std=c++17",))
        self._fns = {}

    def _call(self, name, *args, n_threads=None):
        cp = self._cp
        fn = self._fns.get(name)
        if fn is None:
            fn = self._fns[name] = self._mod.get_function(name)
        n = int(args[0].numel() if n_threads is None else n_threads)
        block = 256
        grid = (n + block - 1) // block
        ka = tuple(cp.from_dlpack(a.detach()) if torch.is_tensor(a)
                   else a for a in args)
        with cp.cuda.ExternalStream(
                torch.cuda.current_stream().cuda_stream):
            fn((grid,), (block,), ka)

    def __getattr__(self, name):
        if name.startswith("_"):
            raise AttributeError(name)
        return functools.partial(self._call, name)


def _get_lib():
    global _LIB
    if _LIB is None:
        _preload_cuda_libs()
        _LIB = _CudaLib(_PREAMBLE + transpile(MSL)
                        + transpile(_adv_mod.MSL))
    return _LIB


class CudaGeo(MetalGeo):
    """MetalGeo with the lib swapped for the NVRTC build. mount(),
    __call__ and the buffer caches are inherited - they are already
    device-agnostic."""

    def __init__(self):
        self.lib = _get_lib()
        self._dims = {}
        self._mbuf = {}


def puff_adv(values, rewards, terminals, ratio, advantages,
             gamma, lam, rho, c):
    """The vtrace scan, one thread per segment (the same MSL source
    tandoor_mps_advantage runs on Metal, bit-exact vs pufferlib's
    CPU op there). Writes `advantages` in place and returns it."""
    lib = _get_lib()
    N, H = values.shape
    dev = values.device
    par = torch.tensor([gamma, lam, rho, c], dtype=torch.float32,
                       device=dev)
    dims = torch.tensor([N, H], dtype=torch.int32, device=dev)
    lib._call("puff_adv", advantages, values.contiguous(),
              rewards.contiguous(), terminals.contiguous(),
              ratio.contiguous(), par, dims, n_threads=N)
    return advantages

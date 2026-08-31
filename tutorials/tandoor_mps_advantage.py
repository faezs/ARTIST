"""The MPS advantage kernel pufferlib is missing.

pufferl.compute_puff_advantage has a CUDA kernel and a CPU fallback;
on MPS the fallback copies the FULL batch (5 tensors) to CPU and back
- and the trainer calls it twice per minibatch, so an epoch pays
dozens of full-batch device round-trips. That is the Train.Misc/Copy
wall the panels show.

This is the same vtrace scan as extensions/pufferlib.cpp
puff_advantage_row, transcribed line for line into MSL: one thread per
segment, backward over its own horizon in registers. verify() compares
against pufferlib's own CPU op.
"""
import numpy as np
import torch

MSL = r"""
#include <metal_stdlib>
using namespace metal;
kernel void puff_adv(
    device float*       adv    [[buffer(0)]],  // (N, H)
    device const float* values [[buffer(1)]],
    device const float* rewards[[buffer(2)]],
    device const float* dones  [[buffer(3)]],
    device const float* imp    [[buffer(4)]],
    device const float* par    [[buffer(5)]],  // gamma, lambda, rho, c
    device const int*   dims   [[buffer(6)]],  // N, H
    uint tid [[thread_position_in_grid]])
{
    const int N = dims[0], H = dims[1];
    if (tid >= uint(N)) return;
    const int o = tid * H;
    float lastlam = 0.0f;
    const float gamma = par[0], lam = par[1];
    const float rho_clip = par[2], c_clip = par[3];
    for (int t = H - 2; t >= 0; t--) {
        int tn = t + 1;
        float nonterm = 1.0f - dones[o + tn];
        float rho_t = fmin(imp[o + t], rho_clip);
        float c_t = fmin(imp[o + t], c_clip);
        float delta = rho_t * (rewards[o + tn]
                               + gamma * values[o + tn] * nonterm
                               - values[o + t]);
        lastlam = delta + gamma * lam * c_t * lastlam * nonterm;
        adv[o + t] = lastlam;
    }
}
"""

class _Shader:
    def __init__(self):
        self.lib = torch.mps.compile_shader(MSL.replace(
            "device float*       adv    [[buffer(0)]],  // (N, H)",
            "device float*       gridd  [[buffer(0)]],  // (N,) grid driver"
        ).replace(
            "device const int*   dims   [[buffer(6)]],  // N, H",
            "device const int*   dims   [[buffer(6)]],  // N, H\n    device float* adv [[buffer(7)]],"
        ))

    def __call__(self, values, rewards, terminals, ratio, advantages,
                 gamma, lam, rho, c):
        N, H = values.shape
        dev = values.device
        par = torch.tensor([gamma, lam, rho, c], dtype=torch.float32,
                           device=dev)
        dims = torch.tensor([N, H], dtype=torch.int32, device=dev)
        grid = torch.empty(N, dtype=torch.float32, device=dev)
        self.lib.puff_adv(grid, values.contiguous(),
                          rewards.contiguous(), terminals.contiguous(),
                          ratio.contiguous(), par, dims, advantages)
        return advantages


_shader = None


def install():
    """Monkeypatch pufferl.compute_puff_advantage: on MPS run the Metal
    kernel in place (bit-exact vs their CPU op, verified); any other
    device falls through to pufferlib's original."""
    import pufferlib.pufferl as pufferl
    global _shader
    orig = pufferl.compute_puff_advantage

    def patched(values, rewards, terminals, ratio, advantages,
                gamma, gae_lambda, rho_clip, c_clip):
        global _shader
        if values.device.type == "mps":
            if _shader is None:
                _shader = _Shader()
            return _shader(values, rewards, terminals, ratio, advantages,
                           gamma, gae_lambda, rho_clip, c_clip)
        if values.device.type == "cuda":
            # the same scan, NVRTC-jitted (tandoor_cuda_kernel);
            # falls through to the source-patched device loop when
            # cupy is absent
            try:
                from tandoor_cuda_kernel import puff_adv
                return puff_adv(values, rewards, terminals, ratio,
                                advantages, gamma, gae_lambda,
                                rho_clip, c_clip)
            except Exception:
                pass
        return orig(values, rewards, terminals, ratio, advantages,
                    gamma, gae_lambda, rho_clip, c_clip)

    pufferl.compute_puff_advantage = patched

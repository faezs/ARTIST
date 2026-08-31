"""Cross-device zero-noise verification: CUDA trace vs Metal kernel.

gen (on the Mac): capture the EXACT tensor arguments of one megakernel
invocation (including every random draw) plus the kernel's per-node
power output, into a small reference bundle.

check (in the CUDA container): rebuild the same env, replay the saved
arguments through the fused torch graph + shared pot binning - the
CUDA fallback path - and require the per-node powers to match the
Metal kernel's within float32 cross-vendor tolerance. Same inputs,
same draws: any disagreement is math, not noise.

    python tandoor_cuda_verify.py gen     # Mac, writes the bundle
    python tandoor_cuda_verify.py check   # CUDA, asserts parity
"""
import contextlib
import io
import pathlib
import sys

import numpy as np
import torch

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))

BUNDLE = pathlib.Path(__file__).parent / "puffer_tandoor" \
    / "cuda_ref_bundle.pt"
B, P = 4, 1100


def _env(device, gpu):
    from tandoor_hashemi_env import TandoorHashemiEnv
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(num_agents=B, seed=123, wide_shutter=1,
                              device=device, gpu=gpu, n_rays=P,
                              day_random=0, lat_random=0)
        e.reset(seed=123)
    return e


def gen():
    e = _env("mps", 1)
    assert e._metal is not None, "no Metal kernel on this machine"
    cap = {}
    orig = e._metal

    def wrapper(*args):
        out = orig(*args)
        cap["args"] = [a.cpu() if torch.is_tensor(a) else a
                       for a in args]
        cap["per"] = out[2].cpu()
        return out

    e._metal = wrapper
    e._gen.manual_seed(4242)
    p_eff = torch.full((B,), float(e.p0), device=e.device)
    sigb = torch.full((B,), 3.0e-3, device=e.device)
    off = torch.zeros(B, 2, device=e.device)
    soil = torch.full((B,), 0.95, device=e.device)
    ee = torch.zeros(B, device=e.device)
    from tandoor_mount_batch import mount_batch
    mnt = mount_batch(
        e, torch.as_tensor(e.day_v, dtype=torch.float32,
                           device=e.device),
        torch.as_tensor(e.lat_v, dtype=torch.float32,
                        device=e.device), 10.5, e.device)
    e._metal_trace(p_eff, sigb, off, soil, ee, ee, mnt)
    e._metal = orig
    torch.save(cap, BUNDLE)
    print(f"bundle written: {BUNDLE.name}, per sum "
          f"{float(cap['per'].sum()):.4f}, "
          f"{sum(a.numel() for a in cap['args'] if torch.is_tensor(a))}"
          f" floats")


def check():
    e = _env("cuda", 1)
    assert e._metal is None, "expected no Metal on this device"
    cap = torch.load(BUNDLE, map_location="cpu", weights_only=False)
    dev = torch.device("cuda")
    # args layout mirrors _metal_trace's kernel call: 19 geo args
    # (pts,nrm,lv,du,de,upick,us,sigb,Acan,Mt,Cd,dvec,off,vp,sc,
    # ellM,ellS,ellC,V0t) then ray_pw, soil, n_nodes, aim, scb.
    # The torch fallback takes broadcast-shaped per-env geometry:
    # massage the kernel-flat buffers into it, scb after sc.
    ka = [a.to(dev) if torch.is_tensor(a) else a
          for a in cap["args"]]
    Bc = ka[2].shape[0]
    scb = ka[23]
    geo_args = (ka[0], ka[1], ka[2], ka[3], ka[4], ka[5], ka[6],
                ka[7], ka[8].view(Bc, 1, 3, 3), ka[9],
                ka[10][:, None, :], ka[11], ka[12],
                ka[13].view(Bc, 7, 1, 3), ka[14], scb,
                ka[15], ka[16], ka[17], ka[18])
    off = ka[12]
    soil = ka[20]
    e._ray_scale = scb[:, 4] * scb[:, 5]
    out = e._geo(*geo_args)
    (through_b, w_ray, dy, dz, d3) = out[:5]
    through = through_b.float() * w_ray
    per = e._bin_pot(dy - off[:, 0:1], dz - off[:, 1:2],
                     d3[..., 1], -d3[..., 0], d3[..., 2],
                     through, soil, B, P).to(dev)
    ref = cap["per"].to(dev)
    tot_ref = float(ref.sum())
    tot = float(per.sum())
    node_err = float((per - ref).abs().max())
    scale = max(float(ref.abs().max()), 1e-9)
    print(f"CUDA vs Metal: total {tot:.4f} vs {tot_ref:.4f} "
          f"({abs(tot - tot_ref) / max(tot_ref, 1e-9) * 100:.4f}%), "
          f"max node err {node_err:.5f} ({node_err / scale * 100:.3f}%"
          f" of peak)")
    assert abs(tot - tot_ref) / max(tot_ref, 1e-9) < 5e-3, "power drift"
    assert node_err / scale < 2e-2, "node distribution drift"
    print("CUDA-vs-Metal zero-noise parity: PASS")


if __name__ == "__main__":
    {"gen": gen, "check": check}[sys.argv[1]]()

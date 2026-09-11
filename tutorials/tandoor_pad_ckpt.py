"""Pad a COOK checkpoint (obs 68) to the DESIGN env's obs width (99 = 68 + 2 demand + 29 design).

The extra columns are appended LAST in the obs, so zero-padding the encoder's input
weight is exact: the padded policy computes precisely what the cook policy did, and
the design columns start with zero influence until training moves them.

    python tandoor_pad_ckpt.py <cook.pt> <out.pt> [--width 99]
"""
import argparse, torch, torch.nn as nn

def pad(src, dst, width):
    m = torch.load(src, map_location="cpu", weights_only=False)
    sd = m.state_dict() if hasattr(m, "state_dict") else m
    w = sd["policy.encoder.0.weight"]
    if w.shape[1] == width:
        print(f"already {width} wide"); torch.save(m, dst); return
    assert w.shape[1] < width, f"checkpoint is {w.shape[1]} wide, wider than {width}"
    if hasattr(m, "state_dict"):
        lin = m.policy.encoder[0]                      # nn.Linear(in, 256)
        new = nn.Linear(width, lin.out_features, bias=lin.bias is not None)
        with torch.no_grad():
            new.weight.zero_(); new.weight[:, :w.shape[1]] = lin.weight
            if lin.bias is not None:
                new.bias.copy_(lin.bias)
        m.policy.encoder[0] = new
        torch.save(m, dst)
    else:
        sd = dict(sd); wn = torch.zeros(w.shape[0], width, dtype=w.dtype); wn[:, :w.shape[1]] = w
        sd["policy.encoder.0.weight"] = wn; torch.save(sd, dst)
    chk = torch.load(dst, map_location="cpu", weights_only=False)
    chk = chk.state_dict() if hasattr(chk, "state_dict") else chk
    print(f"{src} ({w.shape[1]}) -> {dst} ({chk['policy.encoder.0.weight'].shape[1]})")

if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("src"); ap.add_argument("dst"); ap.add_argument("--width", type=int, default=99)
    a = ap.parse_args(); pad(a.src, a.dst, a.width)

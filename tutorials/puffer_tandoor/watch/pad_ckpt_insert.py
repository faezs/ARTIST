"""Pad a checkpoint's encoder input: insert n_ins zero columns at index `at` and append n_app zero columns.
    python pad_ckpt_insert.py SRC DST AT N_INS N_APP"""
import sys, torch
src, dst, at, n_ins, n_app = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])
sd = torch.load(src, map_location="cpu", weights_only=False); out = []
for k, v in sd.items():
    if k.endswith("encoder.0.weight"):
        W = v; a, b = W[:, :at], W[:, at:]
        W2 = torch.cat([a, torch.zeros(W.shape[0], n_ins, dtype=W.dtype), b, torch.zeros(W.shape[0], n_app, dtype=W.dtype)], 1)
        sd[k] = W2; out.append((k, tuple(W.shape), tuple(W2.shape)))
torch.save(sd, dst); print("padded:", out)

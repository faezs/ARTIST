"""The trainer's reward as ONE Metal kernel, extracted by Ccc from HashemiReward.lean.

`rewardStep` is the whole of the reward the trainer sees: the parent env's raw reward for the
step, plus the shaping (the light at the receiver, `p_in`, in roti units, gated by
`sun_reachable`), divided once by `reward_div`.  Its constants are INPUTS - the ini's values are
handed to the kernel - and its three columns are `r_shape_raw`, `r_raw`, `r_trainer`.

It cannot be a column of `hashemi_env`: the parent's own reward is computed AFTER the machine's
step, so this is a second, tiny launch (one thread per agent) on the fused path, and the NumPy
twin of the same graph on the numpy path.

    .venv/bin/python hashemi_reward_kernel.py      # Metal == NumPy over the reward
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
from hashemi_kernel import MSL_PRELUDE, header_text        # noqa: E402

REW = json.load(open(os.path.join(HERE, "hashemi_reward.json")))
RCOL = {n: i for i, n in enumerate(REW["columns"])}
RIN = {n: i for i, n in enumerate(REW["inputs"])}
N_IN, N_OUT = len(REW["inputs"]), int(REW["n_columns"])


def reward_source():
    with open(os.path.join(HERE, "hashemi_reward.metal")) as f:
        return MSL_PRELUDE + header_text() + f.read()


def pack_reward(parent_raw, dt, p_in, reach, reward_div, cap_shaping, roti_reward, roti_energy):
    """the (B, 8) input rows, in the kernel's own input order"""
    parent_raw = np.asarray(parent_raw, dtype=np.float64)
    B = parent_raw.shape[0]
    x = np.zeros((B, N_IN))
    x[:, RIN["parentRaw"]] = parent_raw
    x[:, RIN["dt"]] = dt
    x[:, RIN["pIn"]] = np.asarray(p_in, dtype=np.float64)
    x[:, RIN["reach"]] = np.asarray(reach, dtype=np.float64)
    x[:, RIN["rewardDiv"]] = reward_div
    x[:, RIN["capShaping"]] = cap_shaping
    x[:, RIN["rotiReward"]] = roti_reward
    x[:, RIN["rotiEnergy"]] = roti_energy
    return x


def reward_numpy(x):
    """the NumPy twin of the same graph: x (B, 8) -> (B, 3)"""
    import hashemi_ccc as H
    with np.errstate(all="ignore"):
        return np.asarray(H.hk_rewardStep(*[x[:, k] for k in range(N_IN)]),
                          dtype=np.float64).reshape(x.shape[0], N_OUT)


class HashemiRewardMetal:
    """the reward kernel: one launch per step, one thread per agent"""

    def __init__(self):
        import torch
        self.torch = torch
        self.lib = torch.mps.compile_shader(reward_source())
        self._buf = {}

    def step(self, x):
        """x (B, 8) float32 mps -> out (B, 3) float32 mps"""
        torch = self.torch
        B = x.shape[0]
        bufs = self._buf.get(B)
        if bufs is None:
            bufs = (torch.empty(B, N_OUT, dtype=torch.float32, device="mps"),
                    torch.tensor([B], dtype=torch.int32, device="mps"))
            self._buf[B] = bufs
        out, nB = bufs
        self.lib.hashemi_reward(x.contiguous(), out, nB, threads=B, group_size=1)
        return out


if __name__ == "__main__":
    import torch
    rng = np.random.default_rng(7)
    B = 4096
    x = pack_reward(rng.uniform(-80, 80, B), 15.0, rng.uniform(0, 6000, B),
                    (rng.random(B) < 0.8).astype(np.float64), 75.0, 0.2, 5.0, 130000.0)
    ref = reward_numpy(x)
    out = HashemiRewardMetal().step(torch.as_tensor(x.astype(np.float32), device="mps")).cpu().numpy().astype(np.float64)
    bad = 0
    for j, name in enumerate(REW["columns"]):
        scale = np.maximum(1.0, np.abs(ref[:, j]))
        err = float(np.max(np.abs(out[:, j] - ref[:, j]) / scale))
        print(f"  {name:<14} rel {err:.2e}")
        if err > 1e-5:
            bad += 1
    # the naturality square, on the kernel's own output (R2)
    r2 = float(np.max(np.abs(out[:, RCOL["r_trainer"]] * 75.0 - x[:, RIN["parentRaw"]] - out[:, RCOL["r_shape_raw"]])))
    print(f"  R2 units (kernel)   max |r_trainer*div - parentRaw - r_shape_raw| = {r2:.2e}")
    print(f"  R3 min r_shape_raw  {out[:, RCOL['r_shape_raw']].min():.3e}")
    print("METAL == NUMPY over the reward" if bad == 0 else f"MISMATCH in {bad} columns")
    sys.exit(0 if bad == 0 else 1)

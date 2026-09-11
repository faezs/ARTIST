#!/usr/bin/env python
"""What the fast loop achieves: no-op, random, an integral controller on the flux camera's centroid (calibrated in place),
an integral controller on the true miss (the upper bound a camera cannot see), and a trained policy. Same env, same seeds.

    cd ~/ARTIST/tutorials/puffer_tandoor && ./.venv/bin/python <this file> [--ckpt experiments/X/model_N.pt] [--agents 256] [--seconds 3] [--seed 11]"""
import os, sys, argparse, time, numpy as np, torch
ART = "/Users/faezs/ARTIST"
for p in (ART, os.path.join(ART, "tutorials"), os.path.join(ART, "tutorials", "puffer_tandoor")):
    if p not in sys.path: sys.path.insert(0, p)
ap = argparse.ArgumentParser(); ap.add_argument("--ckpt", default=None); ap.add_argument("--greedy", type=int, default=0); ap.add_argument("--base", type=int, default=1); ap.add_argument("--heads", default="3"); ap.add_argument("--agents", type=int, default=256); ap.add_argument("--seconds", type=float, default=3.0); ap.add_argument("--seed", type=int, default=11); ap.add_argument("--gain", type=float, default=0.6)
A = ap.parse_args(); sys.argv = [sys.argv[0]]
import pufferlib, pufferlib.pytorch
from pufferlib import pufferl
args = pufferl.load_config("puffer_flower_fast"); args["env"]["num_agents"] = A.agents; args["env"]["on_device"] = 0; args["vec"] = dict(backend="Serial", num_envs=1)
if A.ckpt: args["load_model_path"] = A.ckpt
vecenv = pufferl.load_env("puffer_flower_fast", args); drv = vecenv.driver_env; device = args["train"]["device"]
policy = pufferl.load_policy(args, vecenv) if A.ckpt else None; use_rnn = args["train"]["use_rnn"]
n_act = vecenv.action_space.shape[1]; fine_idx = (0, 1, 2) if drv.fine_only else (6, 7, 8); steps = int(A.seconds/drv.dt)
cam = drv.cam_n; ij = np.indices((cam, cam)).reshape(2, -1).T.astype(np.float32) - (cam - 1)/2
rim = 0.18*np.asarray((drv.cam_rim_F if drv.cam_plane == "F" else drv.cam_rim).detach().cpu().numpy(), np.float32).reshape(-1)   # the frame's reference ring: take it out
def centroid(ob):
    img = np.clip(ob[:, :cam*cam] - rim[None, :], 0, None); w = img.sum(1, keepdims=True) + 1e-6
    return (img @ ij)/w                                                        # (B, 2) pixels from the frame's centre, flux only
def true_miss(): return drv.S["miss"].cpu().numpy()
def neutral(): return np.full((A.agents, n_act), 3, dtype=np.int64)
# ---- calibrate the two tilt heads against the camera centroid: full rate for 150 steps each, from reset
G = np.zeros((2, 2)); Gm = np.zeros((2, 2))
for k in range(2):
    ob, _ = vecenv.reset(seed=A.seed); c0 = centroid(ob).mean(0); m0 = true_miss().mean(0)
    act = neutral(); act[:, fine_idx[k]] = 6
    for t in range(150): ob, *_ = vecenv.step(act)
    G[:, k] = (centroid(ob).mean(0) - c0)/150.0                                # camera pixels per step of full-rate command
    Gm[:, k] = (true_miss().mean(0) - m0)/150.0                                # metres of true miss per step
Ginv = np.linalg.pinv(G); Gminv = np.linalg.pinv(Gm)
print(f"per full-rate step: camera head1 {G[:, 0].round(4)} head2 {G[:, 1].round(4)} px; true miss head1 {(1e3*Gm[:, 0]).round(3)} head2 {(1e3*Gm[:, 1]).round(3)} mm")
def run(mode):
    ob, _ = vecenv.reset(seed=A.seed)
    state = dict(lstm_h=torch.zeros(A.agents, policy.hidden_size, device=device), lstm_c=torch.zeros(A.agents, policy.hidden_size, device=device)) if (policy is not None and use_rnn) else {}
    rews, miss, thru, sat, fc = [], [], [], [], []
    for t in range(steps):
        if mode == "policy":
            with torch.no_grad():
                logits, _ = policy.forward_eval(torch.as_tensor(ob).to(device), state)
                if A.greedy: action = torch.stack([l.argmax(-1) for l in logits], 1) if isinstance(logits, (list, tuple)) else logits.argmax(-1)
                else: action, _, _ = pufferlib.pytorch.sample_logits(logits)
            act = action.cpu().numpy().reshape(A.agents, n_act)
            if A.heads == "2": act[:, fine_idx[2]] = 3                               # the piston head held at neutral
        elif mode == "noop": act = neutral()
        elif mode == "random": act = np.random.randint(0, 7, size=(A.agents, n_act))
        elif mode == "integral (camera)":
            e = centroid(ob); u = -A.gain*(e @ Ginv.T)                             # full-rate units; a rate on the error integrates to position
            act = neutral(); act[:, fine_idx[0]] = np.clip(np.round(3 + 3*u[:, 0]), 0, 6); act[:, fine_idx[1]] = np.clip(np.round(3 + 3*u[:, 1]), 0, 6)
        elif mode == "integral (true miss)":
            u = -A.gain*(true_miss() @ Gminv.T); act = neutral(); act[:, fine_idx[0]] = np.clip(np.round(3 + 3*u[:, 0]), 0, 6); act[:, fine_idx[1]] = np.clip(np.round(3 + 3*u[:, 1]), 0, 6)
        ob, rew, term, trunc, _ = vecenv.step(act)
        rews.append(float(np.mean(rew))); miss.append(float(torch.linalg.norm(drv.S["miss"], dim=1).mean())); thru.append(float(drv._fl["rays_thru"].mean())); sat.append(float((drv.S["fine_c"].abs() > 0.95*drv.S["fine_c"].abs().max().clamp(min=1e-9)).float().mean())); fc.append(drv.S["fine_c"].abs().mean(0).cpu().numpy())
    last = slice(steps//2, None)
    fcm = np.mean(np.array(fc)[last], 0)
    return np.mean(rews[last]), 100*np.mean(miss[last]), 100*np.mean(thru[last]), 100*np.mean(miss[:100]), 100*np.mean(thru[:steps//2]), 1e3*fcm[0], 1e3*fcm[1], 1e3*fcm[2]
modes = (["noop", "random", "integral (camera)", "integral (true miss)"] if A.base else []) + (["policy"] if policy else [])
print(f"{'controller':<22} {'reward/step':>12} {'miss cm (2nd half)':>19} {'rays through':>13} {'miss at start':>14} {'thru 1st half':>14} {'|tilt x| |tilt y| |piston| mrad/mm':>36}   ({A.agents} agents, {A.seconds:.0f} s, seed {A.seed}, site wind, gain {A.gain}, greedy {A.greedy}, heads {A.heads})")
for m in modes:
    r = run(m); print(f"{m:<22} {r[0]:12.4f} {r[1]:19.2f} {r[2]:12.1f} % {r[3]:14.2f} {r[4]:12.1f} % {r[5]:12.2f} {r[6]:8.2f} {r[7]:8.2f}", flush=True)

#!/usr/bin/env python
"""Watch the flower under a Hashemi-trained policy. The env is tutorials/tandoor_flower_env.py, registered in the puffer_tandoor package
as puffer_flower (flower.ini): this is `puffer eval puffer_flower --env.render-mode human` with the checkpoint chosen for you (the newest
under experiments/ whose observation size matches the env; the design runs carry 23 more) and a --wind-scale knob for the flower's loads.

    cd ~/ARTIST/tutorials/puffer_tandoor && ./.venv/bin/python <this file> [--wind-scale 2] [--ckpt experiments/X.pt] [--headless --steps N]
The trainer is the same as Hashemi's:  puffer train puffer_flower --load-model-path experiments/<hashemi run>/model_000160.pt"""
import os, sys, glob, time, argparse, numpy as np
ART = "/Users/faezs/ARTIST"
for p in (ART, os.path.join(ART, "tutorials"), os.path.join(ART, "tutorials", "puffer_tandoor")):
    if p not in sys.path: sys.path.insert(0, p)
import torch, pufferlib, pufferlib.vector
from pufferlib import pufferl
def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--ckpt", default=None); ap.add_argument("--wind-from", default="S"); ap.add_argument("--wind-scale", type=float, default=1.0)
    ap.add_argument("--fps", type=float, default=24.0); ap.add_argument("--steps", type=int, default=0); ap.add_argument("--headless", action="store_true"); A = ap.parse_args()
    sys.argv = [sys.argv[0]]; args = pufferl.load_config("puffer_flower")
    args["env"].update(num_agents=1, render_mode=None if A.headless else "human", wind_from=A.wind_from, wind_scale=A.wind_scale); args["vec"] = dict(backend="Serial", num_envs=1)
    vecenv = pufferl.load_env("puffer_flower", args); n_obs = int(np.prod(vecenv.single_observation_space.shape)); ckpt = A.ckpt
    if ckpt is None:
        exp = os.path.join(ART, "tutorials", "puffer_tandoor", "experiments")
        for cand in sorted(glob.glob(os.path.join(exp, "*.pt")) + glob.glob(os.path.join(exp, "*", "model_*.pt")), key=os.path.getctime, reverse=True):
            try:
                w = torch.load(cand, map_location="cpu").get("policy.encoder.0.weight")
                if w is not None and w.shape[1] == n_obs: ckpt = cand; break
            except Exception: continue
        if ckpt is None: raise SystemExit(f"no checkpoint with {n_obs} observations under {exp}")
    args["load_model_path"] = ckpt; policy = pufferl.load_policy(args, vecenv); device = args["train"]["device"]
    print(f"[flower eval] policy {os.path.relpath(ckpt, ART)}, device {device}, wind from {A.wind_from} x{A.wind_scale}")
    ob, _ = vecenv.reset(); driver = vecenv.driver_env
    state = dict(lstm_h=torch.zeros(1, policy.hidden_size, device=device), lstm_c=torch.zeros(1, policy.hidden_size, device=device)) if args["train"]["use_rnn"] else {}
    n = 0; t0 = time.time()
    while True:
        if not A.headless: driver.render()
        with torch.no_grad():
            logits, _ = policy.forward_eval(torch.as_tensor(ob).to(device), state); action, _, _ = pufferlib.pytorch.sample_logits(logits)
        ob = vecenv.step(action.cpu().numpy().reshape(vecenv.action_space.shape))[0]; n += 1
        if A.headless and n % 50 == 0:
            driver._sync_from_gpu(); f = driver._fl_scalars(); print(f"  step {n}: t {float(driver.t_solar[0]):.2f} h wind {f['V']:.1f}{f['gust']:+.1f} m/s drag {f['drag']:.0f} N walk {100*np.linalg.norm(f['walk']):.2f} cm p_in {float(driver.p_in[0]):.0f} W")
        if A.steps and n >= A.steps: break
        if not A.headless: time.sleep(max(0.0, 1.0/A.fps))
    print(f"[flower eval] {n} steps in {time.time() - t0:.0f} s")
if __name__ == "__main__": main()

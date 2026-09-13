#!/usr/bin/env python
"""Watch the flower under a Hashemi-trained policy, with its mechanism in the loop.

The env is tutorials/tandoor_flower_env.py, registered in the puffer_tandoor package as puffer_flower (flower.ini). This is
`puffer eval puffer_flower --env.render-mode human` with the checkpoint chosen for you and the mount's knobs on the command
line. The mechanism the renderer draws and this prints is solved every 15 s step: the pedicel's six joints inverted from the
kernel's own aim, held to their travel and to two drive speeds (creep to track, slew to acquire); the stem-and-boom
compliance at THIS extension; the crown's 6 x 6 Jacobian turning the wind wrench into six strut forces; the flexure balls'
stress; the fine stage's stroke; the stow; and the plenum.

    cd ~/ARTIST/tutorials/puffer_tandoor && ./.venv/bin/python <this file> [--wind-scale 3] [--base ring|stem]
                                            [--ckpt experiments/X.pt] [--headless --steps N] [--every 20]
The trainer is the same as Hashemi's:  puffer train puffer_flower --load-model-path experiments/<hashemi run>/model_000160.pt
"""
import os, sys, glob, time, argparse, numpy as np
ART = "/Users/faezs/ARTIST"
for p in (ART, os.path.join(ART, "tutorials"), os.path.join(ART, "tutorials", "puffer_tandoor")):
    if p not in sys.path: sys.path.insert(0, p)
import torch, pufferlib, pufferlib.vector
from pufferlib import pufferl


def pick_ckpt(n_obs):
    """the newest checkpoint whose encoder takes this env's observation (the design runs carry 23 more columns)"""
    exp = os.path.join(ART, "tutorials", "puffer_tandoor", "experiments")
    for cand in sorted(glob.glob(os.path.join(exp, "*.pt")) + glob.glob(os.path.join(exp, "*", "model_*.pt")),
                       key=os.path.getctime, reverse=True):
        try:
            w = torch.load(cand, map_location="cpu").get("policy.encoder.0.weight")
            if w is not None and w.shape[1] == n_obs: return cand
        except Exception: continue
    raise SystemExit(f"no checkpoint with {n_obs} observations under {exp}")


def mech_line(driver, n):
    """one line of the mount's state, in the same terms the HUD uses"""
    driver._sync_from_gpu(); f = driver._fl_scalars(); q = f["q"]
    rail = f"$0 {np.degrees(f['rail']):+6.1f}d " if driver.base == "ring" else ""
    flags = []
    if f["stow"] > 0.5: flags.append("STOWED")
    if f["lim_hit"] > 0: flags.append(f"{f['lim_hit']:.0f} at a limit")
    if f["rate_hit"] > 0: flags.append(f"{f['rate_hit']:.0f} rate-limited")
    if f["thru"] > 0.5: flags.append("BOOM THROUGH THE APERTURE")
    if f["fine_sat"] > 0: flags.append(f"fine stage saturated by {1e3*f['fine_sat']:.0f} mm")
    if f["plenum"] < 0.5: flags.append("plenum open")
    return (f"  {n:5d}  t {float(driver.t_solar[0]):5.2f} h  wind {f['V']:5.2f}{f['gust']:+5.2f} m/s  drag {f['drag']/1e3:5.2f} kN"
            f" | {rail}$1 {q['slew']:+7.1f} $2 {q['luff']:+6.1f} $3 {q['ext']:5.2f} m $4 {q['pitch']:+7.1f} $5 {q['yaw']:+6.1f}"
            f" | {1e6*f['k_img']:5.1f} um/N {f['f_n']:4.1f} Hz | strut {f['strut']/1e3:5.2f} kN ball {f['ball_sig']/1e6:5.1f} MPa"
            f" | fine {1e3*f['fine_use']:5.1f} mm | walk {100*np.linalg.norm(f['walk']):6.2f} cm (open {100*f['walk_open']:5.2f})"
            f" | p_in {float(driver.p_in[0]):6.0f} W" + (("  [" + ", ".join(flags) + "]") if flags else ""))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ckpt", default=None); ap.add_argument("--wind-from", default="S")
    ap.add_argument("--wind-scale", type=float, default=1.0)
    ap.add_argument("--base", default=None, choices=["ring", "stem"], help="carriage on the ring rail, or the fixed deck stem")
    ap.add_argument("--ring-r", type=float, default=None); ap.add_argument("--stem-z", type=float, default=None)
    ap.add_argument("--boom-min", type=float, default=None); ap.add_argument("--boom-max", type=float, default=None)
    ap.add_argument("--stow-wind", type=float, default=None)
    ap.add_argument("--no-fine", action="store_true", help="turn the crown's fine stage off and watch the image walk")
    ap.add_argument("--no-mech", action="store_true", help="fall back to the old lumped model: no joints, no limits, no stow")
    ap.add_argument("--fps", type=float, default=24.0); ap.add_argument("--steps", type=int, default=0)
    ap.add_argument("--every", type=int, default=50, help="print the mount's state every N steps")
    ap.add_argument("--flexures", default="m23", choices=["all", "m23", "off"],
                    help="draw every joint realised from its screw (all), only the strip's and M3's (m23), or none; the eval prints either way")
    ap.add_argument("--headless", action="store_true"); A = ap.parse_args()

    sys.argv = [sys.argv[0]]; args = pufferl.load_config("puffer_flower")
    env_kw = dict(num_agents=1, render_mode=None if A.headless else "human", wind_from=A.wind_from, wind_scale=A.wind_scale)
    for k, v in (("base", A.base), ("ring_r", A.ring_r), ("stem_z", A.stem_z), ("boom_min", A.boom_min),
                 ("boom_max", A.boom_max), ("stow_wind", A.stow_wind)):
        if v is not None: env_kw[k] = v
    if A.no_fine: env_kw["fine_stage"] = 0
    if A.no_mech: env_kw["mech"] = 0
    env_kw["flexures"] = {"all": 2, "m23": 1, "off": 0}[A.flexures]
    args["env"].update(env_kw); args["vec"] = dict(backend="Serial", num_envs=1)

    vecenv = pufferl.load_env("puffer_flower", args)
    n_obs = int(np.prod(vecenv.single_observation_space.shape))
    ckpt = A.ckpt or pick_ckpt(n_obs)
    args["load_model_path"] = ckpt
    policy = pufferl.load_policy(args, vecenv); device = args["train"]["device"]
    driver = vecenv.driver_env
    print(f"[flower eval] policy {os.path.relpath(ckpt, ART)}, device {device}, wind from {A.wind_from} x{A.wind_scale}")
    print(f"[flower eval] mount: base {driver.base}"
          + (f", ring rail r {driver.ring_r:.1f} m at {driver.stem_z:.1f} m" if driver.base == "ring"
             else f", stem {driver.stem_x:.1f} m north, {driver.stem_z:.1f} m tall")
          + f", boom {driver.boom[0]:.2f}-{driver.boom[1]:.2f} m, stow over {driver.stow_wind:.0f} m/s,"
            f" fine stage {'on' if driver.fine_stage else 'OFF'}, mechanism {'on' if driver.mech else 'OFF'}")

    ob, _ = vecenv.reset()
    # THE FLEXURE EVAL: every joint of the machine written as a screw, realised as blades by tandoor_screw_render.realise and
    # scored by its evaluate - travel from the machine's own year, load from its worst case. Printed once; it does not
    # change with the pose. A softness ratio above ~100 is a pivot; below it the joint is a lump that flexes a little.
    tr = driver._fl_year_travel()
    print(f"[flower eval] the year's joint travel over {tr['n']} poses: slew {tr['slew']:.0f} deg, luff {tr['luff']:.0f}, extend {tr['ext']:.2f} m,"
          f" pitch {tr['pitch']:.0f}, yaw {tr['yaw']:.0f}, strip about the bore {tr['strip']:.0f}")
    print("[flower eval] each joint from its screw (tandoor_screw_render.realise + evaluate):")
    for l in driver.flexure_lines(driver.flexure_report()): print("    " + l)
    use_rnn = args["train"]["use_rnn"]
    def fresh():
        return dict(lstm_h=torch.zeros(1, policy.hidden_size, device=device),
                    lstm_c=torch.zeros(1, policy.hidden_size, device=device)) if use_rnn else {}
    state = fresh()
    n = 0; t0 = time.time()
    while True:
        if not A.headless: driver.render()
        with torch.no_grad():
            logits, _ = policy.forward_eval(torch.as_tensor(ob).to(device), state)
            action, _, _ = pufferlib.pytorch.sample_logits(logits)
        ob, rew, term, trunc, _ = vecenv.step(action.cpu().numpy().reshape(vecenv.action_space.shape))
        n += 1
        if np.any(term) or np.any(trunc):
            state = fresh()                       # a new day is a new episode: the recurrent state must not carry across it
        if A.every and n % A.every == 0: print(mech_line(driver, n), flush=True)
        if A.steps and n >= A.steps: break
        if not A.headless: time.sleep(max(0.0, 1.0/A.fps))
    print(f"[flower eval] {n} steps in {time.time() - t0:.0f} s")


if __name__ == "__main__": main()

"""A checkpoint's day: what the two motor heads do, hour by hour, on either path.
    .venv/bin/python roll_checkpoint.py experiments/<run>/model_000260.pt [--day 172] [--mode sampled|greedy] [--gpu 0]
The pointing errors are the parent's encoders (|e_el|, |e_az| foreshortened, deg) and the spec's
pointing_err (deg); the heads' mean level and entropy; the value; the pot's power; the return.
Since 2026-09-19 it also reports THE LOOP (HashemiOil.lean): the pump level the checkpoint's head 0
happens to emit - which, for any checkpoint trained before the loop became a loop, is whatever the
head drifted to while it was inert - and what that costs the oil: the bulk, the film temperature,
the margin to the fluid's limit, the damage and the pump's energy.  This is the readout that says
whether a checkpoint has to be retrained.
(2026-09-19: this is how the epoch-260 policy was seen riding a 1.4 deg lag and leaving at noon.)
"""
import argparse
import os
import sys

import numpy as np
import torch

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "bridge")); sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE)); sys.path.insert(0, os.path.join(os.path.dirname(HERE), "puffer_tandoor"))
from export_scene import ini_env_kwargs                              # noqa: E402
from hashemi_tandoor_env import HashemiTandoorEnv, HEAD_AZ, HEAD_EL  # noqa: E402
from hashemi_env_kernel import ECOL                                  # noqa: E402
import pufferlib.pytorch                                             # noqa: E402
from policy import Policy, Recurrent                                 # noqa: E402
import tandoor_hashemi_env as _m                                     # noqa: E402


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("ckpt")
    ap.add_argument("--day", type=int, default=172)
    ap.add_argument("--mode", default="sampled", choices=["sampled", "greedy"])
    ap.add_argument("--agents", type=int, default=32)
    ap.add_argument("--gpu", type=int, default=0)
    ap.add_argument("--hidden", type=int, default=128)
    args = ap.parse_args()
    kw = ini_env_kwargs(os.path.join(os.path.dirname(HERE), "puffer_tandoor", "hashemi_ccc.ini"))
    kw["day_random"] = 0; kw["lat_random"] = 0; kw["gpu"] = args.gpu
    B = args.agents
    env = HashemiTandoorEnv(num_agents=B, lat=30.2, day_of_year=args.day, **kw)
    obs, _ = env.reset(seed=1)
    pol = Recurrent(env, Policy(env, hidden_size=args.hidden), input_size=args.hidden, hidden_size=args.hidden)
    sd = torch.load(args.ckpt, map_location="cpu"); sd = {k.replace("module.", ""): v for k, v in sd.items()}
    pol.load_state_dict(sd); pol.eval()
    state = {"lstm_h": None, "lstm_c": None}
    hours = {}; first_cut = np.full(B, -1); ret = np.zeros(B); k = 0
    oil = getattr(env, "machine_receiver", "oil") != "beam"
    bulk_max = np.zeros(B); film_max = np.zeros(B); margin_min = np.full(B, 1e9); pump_J = np.zeros(B)
    alive = np.ones(B, bool)
    with torch.no_grad():
        while k < 4000:
            el0, _, _ = _m._sim.solar_position(env.lat, env.day, float(env.t_solar[0]))
            o = torch.as_tensor(np.asarray(obs, dtype=np.float32))
            logits, value = pol.forward_eval(o, state)
            if args.mode == "greedy":
                a = torch.stack([l.argmax(1) for l in logits], 1)
            else:
                a, _, _ = pufferlib.pytorch.sample_logits(logits)
            a = a.reshape(B, -1).numpy()
            pa = torch.softmax(logits[HEAD_AZ], 1); pe = torch.softmax(logits[HEAD_EL], 1)
            ent_az = float(-(pa * pa.clamp_min(1e-9).log()).sum(1).mean()); ent_el = float(-(pe * pe.clamp_min(1e-9).log()).sum(1).mean())
            t_before = float(env.t_solar[0])
            obs, rew, term, trunc, infos = env.step(a)
            rew = np.asarray(rew, dtype=np.float64)
            k += 1
            d = np.logical_or(term, trunc)
            if d.any():
                for key in ("lstm_h", "lstm_c"):
                    if state[key] is not None:
                        state[key][torch.as_tensor(d)] = 0
            ret += rew
            first_cut[d & alive & (first_cut < 0)] = k
            alive &= ~d
            if oil:
                bulk_max = np.maximum(bulk_max, env.t_oil)
                film_max = np.maximum(film_max, env.row[:, ECOL["T_film"]])
                margin_min = np.minimum(margin_min, env.row[:, ECOL["film_margin"]])
                pump_J += env.row[:, ECOL["p_pump"]] * env.dt
            hr = int(float(env.t_solar[0]))
            pe_deg = np.degrees(env.row[:, ECOL["pointing_err"]])
            with np.errstate(all="ignore"):
                hours.setdefault(hr, []).append((
                    np.mean(np.abs(env._e_el[alive])) if alive.any() else np.nan, np.mean(np.abs(env._e_az[alive])) if alive.any() else np.nan,
                    np.mean(pe_deg[alive]) if alive.any() else np.nan, alive.mean(), a[:, HEAD_AZ].mean(), a[:, HEAD_EL].mean(),
                    ent_az, ent_el, float(value.mean()), float(np.mean(env.p_in)), el0, float(rew.mean()),
                    float(a[:, 0].mean()) if oil else 0.0, float(np.mean(env.t_oil)) if oil else 0.0,
                    float(np.mean(env.row[:, ECOL["T_film"]])) if oil else 0.0))
            if float(env.t_solar[0]) < t_before - 1.0:
                break
    cut = first_cut[(first_cut > 0) & (first_cut < k)]
    print(f"{os.path.relpath(args.ckpt)} day {args.day} {args.mode} gpu={args.gpu} B={B}: {k} steps; "
          f"{len(cut)}/{B} cut before day over (median step {np.median(cut) if len(cut) else '-'}); "
          f"return {ret.mean():+.2f}; rotis {float(np.asarray(env.ep_rotis).mean()):.2f}")
    print("  hr  |e_el|  |e_az|  ptg_err  alive  az_lvl el_lvl  H_az  H_el   value   p_in  sun_el  rew/step  pump_lvl  T_oil  T_film")
    for hr in sorted(hours):
        with np.errstate(all="ignore"):
            r = np.nanmean(np.array(hours[hr], dtype=float), 0)
        print("  %2d  %5.2f   %5.2f   %5.2f   %4.2f   %4.2f  %4.2f  %4.2f  %4.2f  %6.3f  %5.0f  %5.1f  %+.4f     %5.2f  %5.0f  %6.0f" % ((hr,) + tuple(r)))
    if oil:
        print(f"  THE LOOP under the honest model: max bulk {float(np.max(bulk_max)):.1f} K (limit 618.1), "
              f"max film {float(np.max(film_max)):.0f} K (limit 648.1), min margin {float(np.min(margin_min)):+.0f} K, "
              f"damage {float(np.mean(env.deg)):.3e}, pump energy {float(np.mean(pump_J)) / 1e3:.1f} kJ, "
              f"mean pump level {float(np.mean([np.nanmean(np.array(v,dtype=float)[:,12]) for v in hours.values()])):.2f} of 6")


if __name__ == "__main__":
    main()

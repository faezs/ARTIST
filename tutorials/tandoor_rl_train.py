"""
Train a pump-controller policy for the tandoor with PufferLib's PuffeRL.

Usage:  python tutorials/tandoor_rl_train.py [--timesteps 400000]

Reports a random-policy baseline (rotis/day) first, then trains PPO on the
natively vectorized TandoorEnv and prints the learned policy's stats.
"""

import argparse
import ast
import configparser
import pathlib
import sys

import numpy as np

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))

import pufferlib
import pufferlib.models
import pufferlib.pufferl as pufferl

from tandoor_rl_env import TandoorEnv


def load_train_config(overrides):
    ini = pathlib.Path(pufferlib.__file__).parent / "config" / "default.ini"
    cp = configparser.ConfigParser()
    cp.read(ini)
    cfg = {}
    for k, v in cp["train"].items():
        try:
            cfg[k] = ast.literal_eval(v)
        except (ValueError, SyntaxError):
            cfg[k] = v
    cfg.update(overrides)
    return cfg


def baseline(policy, num_agents=64, seed=1):
    env = TandoorEnv(num_agents=num_agents, seed=seed)
    env.reset(seed=seed)
    rotis, scorch, n = 0.0, 0.0, 0
    steps = int(8 * 3600 / env.dt) + 2
    for _ in range(steps):
        if policy == "random":
            acts = np.stack([env.rng.integers(0, 7, num_agents),
                             env.rng.integers(0, 2, num_agents)], axis=1)
        else:
            # heuristic: nominal focus, close the shutter only when a load
            # opportunity is ready (timer elapsed and a belt slot in band)
            belt = env.T[:, : env.n_belt]
            ready = (env.load_timer >= 45.0) & (
                ((~env.has_bread) & (belt >= 580.0) & (belt <= 700.0)).any(1))
            acts = np.stack([np.full(num_agents, 4),
                             (~ready).astype(int)], axis=1)
        *_, infos = env.step(acts)
        for inf in infos:
            rotis += inf["rotis_per_day"]
            scorch += inf["scorched"]
            n += 1
    return rotis / max(n, 1), scorch / max(n, 1)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--timesteps", type=int, default=2_000_000)
    ap.add_argument("--num-agents", type=int, default=512)
    ap.add_argument("--device", default="mps")
    ap.add_argument("--data-dir", default="experiments_tandoor")
    args = ap.parse_args()

    for name in ("random", "hold-nominal"):
        r0, s0 = baseline(name, num_agents=args.num_agents)
        print(f"{name} baseline: {r0:.1f} rotis/day, {s0:.1f} scorched/day")

    train_cfg = load_train_config(dict(
        use_rnn=False,
        minibatch_size=8192,
        device=args.device,
        total_timesteps=args.timesteps,
        data_dir=args.data_dir,
        checkpoint_interval=10_000_000,  # skip intermediate checkpoints
        compile=False,
        env="tandoor",
    ))
    vecenv = TandoorEnv(num_agents=args.num_agents, seed=0)
    # pufferl's own policy path: default.ini resolves policy_name='Policy'
    # to pufferlib.models.Default via pufferlib.ocean.torch; rnn_name can
    # swap in their LSTMWrapper from config alone
    policy = pufferl.load_policy(dict(
        package="ocean", policy_name="Policy", rnn_name=None,
        policy=dict(hidden_size=128), rnn={}, load_id=None,
        load_model_path=None, neptune=False, wandb=False,
        train=train_cfg,
    ), vecenv)
    trainer = pufferl.PuffeRL(train_cfg, vecenv, policy)
    while trainer.global_step < train_cfg["total_timesteps"]:
        trainer.evaluate()
        trainer.train()

    stats = {}
    i = 0
    while i < 16 or not stats:
        stats = trainer.evaluate()
        i += 1
    trainer.print_dashboard()
    model_path = trainer.close()
    print("model saved:", model_path)
    print("trained policy stats:", {
        k: round(float(np.mean(v)), 2) for k, v in stats.items()
        if "roti" in k or "scorch" in k or "return" in k
    })


if __name__ == "__main__":
    main()

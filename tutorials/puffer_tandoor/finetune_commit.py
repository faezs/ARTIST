"""Committing fine-tune: ent_coef -> 0 from the validated checkpoint.

model_000954 evaluates at 156 sampled / 94 greedy - the entropy floor
that kept 1B steps stable also kept the argmax uncommitted. Short
warm-started run with zero entropy bonus and a gentle annealed lr to
concentrate the probability mass where the policy already knows the
value is.
"""
import sys
from pufferlib.pufferl import train, load_config

args = load_config("puffer_hashemi")
args["load_model_path"] = (
    "experiments/178811402280/model_000954.pt")
args["train"].update(
    ent_coef=0.0,
    learning_rate=0.003,
    total_timesteps=250_000_000,
    checkpoint_interval=100,
)
args["wandb"] = False
args["neptune"] = False
train("puffer_hashemi", args=args)

"""Register the solar-tandoor env as pufferlib.environments.tandoor.

Symlinked into site-packages/pufferlib/environments/tandoor (plus the .ini
into pufferlib/config/) so the stock CLI works:

    puffer train puffer_tandoor
    puffer eval puffer_tandoor --load-model-path latest --env.num-agents 16

The heavy lifting lives in ~/ARTIST/tutorials/tandoor_rl_env.py; this module
resolves it through the symlink so the source stays git-tracked in ARTIST.
"""

import functools
import importlib.util
import pathlib
import sys

_here = pathlib.Path(__file__).resolve().parent  # -> ARTIST/tutorials/puffer_tandoor
_tutorials = _here.parent
if str(_tutorials.parent) not in sys.path:
    sys.path.insert(0, str(_tutorials.parent))

_spec = importlib.util.spec_from_file_location(
    "tandoor_rl_env", _tutorials / "tandoor_rl_env.py"
)
_mod = importlib.util.module_from_spec(_spec)
sys.modules.setdefault("tandoor_rl_env", _mod)
_spec.loader.exec_module(_mod)

TandoorEnv = _mod.TandoorEnv

from . import torch  # noqa: E402,F401  (load_policy reads env_module.torch)


def env_creator(name="puffer_tandoor"):
    return functools.partial(TandoorEnv)

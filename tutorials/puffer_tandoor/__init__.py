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
# tutorials/ itself must be importable too: the env modules do plain
# `import tandoor_coude_optics` / `coude_clearance`, which only resolved
# while cwd happened to be tutorials/.
if str(_tutorials) not in sys.path:
    sys.path.insert(0, str(_tutorials))

_spec = importlib.util.spec_from_file_location(
    "tandoor_rl_env", _tutorials / "tandoor_rl_env.py"
)
_mod = importlib.util.module_from_spec(_spec)
sys.modules.setdefault("tandoor_rl_env", _mod)
_spec.loader.exec_module(_mod)

TandoorEnv = _mod.TandoorEnv

# load_policy reads env_module.torch; alias our policy module to avoid a
# torch.py file shadowing the real torch package when cwd is this directory
from . import policy as torch  # noqa: E402,F401


_spec2 = importlib.util.spec_from_file_location(
    "tandoor_shed_env", _tutorials / "tandoor_shed_env.py")
_mod2 = importlib.util.module_from_spec(_spec2)
sys.modules.setdefault("tandoor_shed_env", _mod2)
_spec2.loader.exec_module(_mod2)
TandoorShedEnv = _mod2.TandoorShedEnv


_spec3 = importlib.util.spec_from_file_location(
    "tandoor_polar_env", _tutorials / "tandoor_polar_env.py")
_mod3 = importlib.util.module_from_spec(_spec3)
sys.modules.setdefault("tandoor_polar_env", _mod3)
_spec3.loader.exec_module(_mod3)
TandoorPolarEnv = _mod3.TandoorPolarEnv


_spec4 = importlib.util.spec_from_file_location(
    "tandoor_coude_env", _tutorials / "tandoor_coude_env.py")
_mod4 = importlib.util.module_from_spec(_spec4)
sys.modules.setdefault("tandoor_coude_env", _mod4)
_spec4.loader.exec_module(_mod4)
TandoorCoudeEnv = _mod4.TandoorCoudeEnv


_spec5 = importlib.util.spec_from_file_location(
    "tandoor_hashemi_env", _tutorials / "tandoor_hashemi_env.py")
_mod5 = importlib.util.module_from_spec(_spec5)
sys.modules.setdefault("tandoor_hashemi_env", _mod5)
_spec5.loader.exec_module(_mod5)
TandoorHashemiEnv = _mod5.TandoorHashemiEnv


def env_creator(name="puffer_tandoor"):
    if "hashemi" in name:
        return functools.partial(TandoorHashemiEnv)
    if "coude" in name:
        return functools.partial(TandoorCoudeEnv)
    if "polar" in name:
        return functools.partial(TandoorPolarEnv)
    if "shed" in name:
        return functools.partial(TandoorShedEnv)
    return functools.partial(TandoorEnv)

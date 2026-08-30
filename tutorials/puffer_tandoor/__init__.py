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

# train.compile = True dies on the policy's LSTM: dynamo refuses to
# trace nn.LSTM by default ("Unsupported: Attempted to wrap RNN, GRU,
# or LSTM"). The experimental path works on this stack - measured
# 4.67 ms compiled vs 7.36 ms eager for the exact LSTM(256,256)
# forward at B=8192 on MPS - so enable it here, where the puffer CLI
# imports us before the policy is built.
try:
    import torch._dynamo
    import torch._inductor.config as _icfg
    torch._dynamo.config.allow_rnn = True
    # Metal caps a kernel at 31 constant buffers. Inductor's horizontal
    # fusion (notably multi-parameter optimizer updates) can emit
    # kernels with more ("number of constant buffers exceeds maximum
    # supported (31)"). Cap fusion width so no generated kernel crosses
    # the limit; if a run still hits it, set train.compile = False -
    # the eager trainer was the 100K-sps baseline.
    _icfg.max_fusion_size = 16
    try:
        _icfg.combo_kernels = False
    except Exception:
        pass
except Exception:
    pass

# pufferlib's advantage op has CUDA + CPU paths only; on MPS the CPU
# fallback copies the FULL batch (5 tensors) to host and back, TWICE
# per minibatch - the Train.Misc/Copy wall on the dashboard. Install
# the Metal kernel (bit-exact vs their CPU op: max diff 0.00e+00).
try:
    import tandoor_mps_advantage
    tandoor_mps_advantage.install()
except Exception:
    pass

# Item 1: the on-device collect loop - pufferl.evaluate round-trips
# every step through numpy; this keeps policy<->env exchange on MPS
# via env.step_torch. Activates only for envs that expose it.
try:
    import tandoor_fast_collect
    tandoor_fast_collect.install()
except Exception:
    pass

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


_spec6 = importlib.util.spec_from_file_location(
    "electroform_env", _tutorials / "electroform_env.py")
_mod6 = importlib.util.module_from_spec(_spec6)
sys.modules.setdefault("electroform_env", _mod6)
_spec6.loader.exec_module(_mod6)
ElectroformEnv = _mod6.ElectroformEnv


def env_creator(name="puffer_tandoor"):
    if "electroform" in name or "plating" in name:
        return functools.partial(ElectroformEnv)
    if "hashemi" in name:
        return functools.partial(TandoorHashemiEnv)
    if "coude" in name:
        return functools.partial(TandoorCoudeEnv)
    if "polar" in name:
        return functools.partial(TandoorPolarEnv)
    if "shed" in name:
        return functools.partial(TandoorShedEnv)
    return functools.partial(TandoorEnv)

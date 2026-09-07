"""Policy hooks for the tandoor env, mirroring pufferlib.ocean.torch."""

import numpy as np
import torch
from torch import nn

import pufferlib
import pufferlib.pytorch
from pufferlib.models import Default as Policy  # noqa: F401
from pufferlib.models import LSTMWrapper as Recurrent  # noqa: F401


class FluxConv(nn.Module):
    """A convolutional policy over the flower's flux camera.

    The observation is a flux frame from the camera at the fold, flattened, followed by a short proprioceptive tail
    (the mount's joints, the fine stage, the plenum). The frame is what the controller is really steering by - where
    the spot sits on the duct's mouth, how big it is, how bright - and a convolution is the right reader for it: the
    same feature means the same thing wherever it lands, which is exactly what a spot that wanders does.

    pufferlib.models.Convolutional cannot be used as it stands: it assumes a Discrete action space and an Atari-sized
    frame (its 8/4/3 stack needs about 36 px to survive). This is a MultiDiscrete head over a 24 x 24 frame.

    It is deliberately SMALL. The flower's inner loop is meant to end up on an ESP32 at 1 kHz, so the encoder is two
    strided convolutions and a linear - about 30 k parameters at the default width, and the frame is 8-bit already.
    Widen it here if you are only ever going to run it on the Mac, but the deployment target is what set these numbers.
    """

    def __init__(self, env, hidden_size=128, cam_n=None, n_prop=None, ch=(16, 32)):
        super().__init__()
        self.hidden_size = hidden_size
        self.is_continuous = False
        self.is_multidiscrete = isinstance(env.single_action_space, pufferlib.spaces.MultiDiscrete)
        obs_n = int(np.prod(env.single_observation_space.shape))
        # the env knows its own frame; fall back to the largest square that fits when it does not say
        drv = getattr(env, "driver_env", env)
        self.cam_n = int(cam_n if cam_n is not None else getattr(drv, "cam_n", int(np.sqrt(obs_n))))
        self.n_prop = int(n_prop if n_prop is not None else getattr(drv, "n_prop", obs_n - self.cam_n**2))
        assert self.cam_n**2 + self.n_prop == obs_n, \
            f"flux frame {self.cam_n}x{self.cam_n} + {self.n_prop} proprio != {obs_n} observations"
        self.conv = nn.Sequential(
            pufferlib.pytorch.layer_init(nn.Conv2d(1, ch[0], 5, stride=2, padding=2)), nn.ReLU(),
            pufferlib.pytorch.layer_init(nn.Conv2d(ch[0], ch[1], 3, stride=2, padding=1)), nn.ReLU(),
        )
        with torch.no_grad():
            flat = int(np.prod(self.conv(torch.zeros(1, 1, self.cam_n, self.cam_n)).shape[1:]))
        self.head = nn.Sequential(
            pufferlib.pytorch.layer_init(nn.Linear(flat + self.n_prop, hidden_size)), nn.GELU(),
        )
        if self.is_multidiscrete:
            self.action_nvec = tuple(int(x) for x in env.single_action_space.nvec)
            self.decoder = pufferlib.pytorch.layer_init(nn.Linear(hidden_size, sum(self.action_nvec)), std=0.01)
        else:
            self.decoder = pufferlib.pytorch.layer_init(nn.Linear(hidden_size, env.single_action_space.n), std=0.01)
        self.value = pufferlib.pytorch.layer_init(nn.Linear(hidden_size, 1), std=1)

    # the encode/decode split is pufferlib's LSTM contract: everything before the recurrent cell in encode,
    # everything after it in decode
    def encode_observations(self, observations, state=None):
        b = observations.shape[0]
        x = observations.view(b, -1).float()
        img = x[:, :self.cam_n**2].view(b, 1, self.cam_n, self.cam_n)
        z = self.conv(img).reshape(b, -1)
        if self.n_prop: z = torch.cat([z, x[:, self.cam_n**2:]], dim=1)
        return self.head(z)

    def decode_actions(self, hidden):
        logits = self.decoder(hidden)
        if self.is_multidiscrete: logits = logits.split(self.action_nvec, dim=1)
        return logits, self.value(hidden)

    def forward_eval(self, observations, state=None):
        return self.decode_actions(self.encode_observations(observations, state=state))

    def forward(self, observations, state=None):
        return self.forward_eval(observations, state)

    def forward_train(self, observations, state=None):
        return self.forward_eval(observations, state)

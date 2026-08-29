"""Item 1: the on-device collect loop.

pufferl.evaluate() round-trips every step through numpy: env obs ->
.cpu() -> buffers -> .to(device) -> policy -> actions -> .cpu() ->
numpy -> env. Our env computes everything as MPS tensors and the
boundary throws that away 128 times per epoch (the dashboard's
Env 28% + Copy 21%).

This evaluate keeps the whole exchange on-device via env.step_torch,
with pufferl's experience bookkeeping replicated VERBATIM (batch-row
indexing, lstm state dict, the +-1 reward clamp, infos -> stats). It
installs as a monkeypatch that activates only when the driver env
exposes step_torch; anything else falls through to the original.
"""
import numpy as np
import torch

import pufferlib
import pufferlib.pytorch


def _fast_evaluate(self):
    profile = self.profile
    epoch = self.epoch
    profile('eval', epoch)
    profile('eval_misc', epoch, nest=True)
    config = self.config
    device = config['device']
    env = self.vecenv.envs[0] if hasattr(self.vecenv, 'envs') else None
    if env is None or not hasattr(env, 'step_torch') or not env.gpu:
        profile.end()
        return self._orig_evaluate()

    if config['use_rnn']:
        for k in self.lstm_h:
            self.lstm_h[k].zero_()
            self.lstm_c[k].zero_()

    B = env.num_agents
    env_id = slice(0, B)
    # current obs: after reset it lives in the numpy buffer; after any
    # fast step we keep the device tensor
    o_device = getattr(env, '_obs_t', None)
    if o_device is None:
        o_device = torch.as_tensor(env.observations).to(device)

    self.full_rows = 0
    while self.full_rows < self.segments:
        profile('eval_forward', epoch)
        self.global_step += B
        with torch.no_grad(), self.amp_context:
            state = dict(env_id=env_id, mask=None)
            if config['use_rnn']:
                state['lstm_h'] = self.lstm_h[0]
                state['lstm_c'] = self.lstm_c[0]
            logits, value = self.policy.forward_eval(o_device, state)
            action, logprob, _ = pufferlib.pytorch.sample_logits(logits)

        profile('env', epoch)
        o_next, r, d, t, info = env.step_torch(action)

        profile('eval_copy', epoch)
        with torch.no_grad():
            if config['use_rnn']:
                self.lstm_h[0] = state['lstm_h']
                self.lstm_c[0] = state['lstm_c']
            r_c = torch.clamp(r, -1, 1)
            l = self.ep_lengths[0].item()
            batch_rows = slice(self.ep_indices[0].item(),
                               1 + self.ep_indices[B - 1].item())
            self.observations[batch_rows, l] = o_device
            self.actions[batch_rows, l] = action
            self.logprobs[batch_rows, l] = logprob
            self.rewards[batch_rows, l] = r_c
            self.terminals[batch_rows, l] = d.float()
            self.values[batch_rows, l] = value.flatten()
            self.ep_lengths[env_id] += 1
            if l + 1 >= config['bptt_horizon']:
                self.ep_indices[env_id] = self.free_idx + torch.arange(
                    B, device=device).int()
                self.ep_lengths[env_id] = 0
                self.free_idx += B
                self.full_rows += B
        o_device = o_next

        profile('eval_misc', epoch)
        for i in info:
            for k, v in pufferlib.unroll_nested_dict(i):
                if isinstance(v, np.ndarray):
                    v = v.tolist()
                if isinstance(v, (list, tuple)):
                    self.stats[k].extend(v)
                else:
                    self.stats[k].append(v)

    env._obs_t = o_device
    profile('eval_misc', epoch)
    self.free_idx = self.total_agents
    self.ep_indices = torch.arange(self.total_agents, device=device,
                                   dtype=torch.int32)
    self.ep_lengths.zero_()
    profile.end()
    return self.stats


def install():
    import pufferlib.pufferl as pufferl
    if getattr(pufferl.PuffeRL, "_fast_collect", False):
        return
    pufferl.PuffeRL._orig_evaluate = pufferl.PuffeRL.evaluate
    pufferl.PuffeRL.evaluate = _fast_evaluate
    pufferl.PuffeRL._fast_collect = True

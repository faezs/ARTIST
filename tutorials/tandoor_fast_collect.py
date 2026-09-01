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
    if (env is None or not hasattr(env, 'step_torch') or not env.gpu
            or env.num_agents != self.total_agents):
        # the fast path is single-block by design (8192 tandoors in
        # ONE native vec env); a split vecenv (num_envs > 1) falls
        # back to the stock loop instead of tripping LSTM shapes
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

    # experience-row bookkeeping as PYTHON ints: the tensor version
    # cost two .item() calls per step - each a full MPS pipeline
    # sync, so the whole epoch's GPU work serialized into the
    # eval_copy bucket (the dashboard's Copy 27%). The sequence is
    # deterministic (l cycles 0..H-1, rows advance B per flush);
    # the end-of-epoch reset below re-establishes the tensor state
    # the stock path expects.
    l_py = 0
    row0 = 0
    free = self.total_agents
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
            batch_rows = slice(row0, row0 + B)
            self.observations[batch_rows, l_py] = o_device
            self.actions[batch_rows, l_py] = action
            self.logprobs[batch_rows, l_py] = logprob
            self.rewards[batch_rows, l_py] = r_c
            self.terminals[batch_rows, l_py] = d.float()
            self.values[batch_rows, l_py] = value.flatten()
            l_py += 1
            if l_py >= config['bptt_horizon']:
                row0 = free
                free += B
                l_py = 0
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

"""Reapply the tandoor patches to an installed pufferlib (idempotent).

Run after any pip reinstall/upgrade of pufferlib:

    .venv/bin/python apply_pufferlib_patches.py

Patches:
  1. pufferl.sweep: drop the wandb/neptune requirement - sweep scoring
     reads the in-memory logs train() returns, not the logging
     service, so local terminal-only sweeps are fine.
  2. pufferl.sweep loop: free the MPS allocator + collect garbage
     between the repeated in-process training runs (they otherwise
     pile up allocator pools and compiled graphs).
  3. sweep._params_from_puffer_sweep: a zero-width space (min == max)
     is a PINNED hyperparameter - skip it instead of dividing by
     max - min in the normalizers. Lets the ini pin clipping, adam
     moments, and vec.num_envs per Suarez's guidance.
"""
import pathlib
import pufferlib

ROOT = pathlib.Path(pufferlib.__file__).parent
PATCHES = [
    (ROOT / "pufferl.py",
     """    if not args['wandb'] and not args['neptune']:
        raise pufferlib.APIUsageError('Sweeps require either wandb or neptune')
""",
     """    if not args['wandb'] and not args['neptune']:
        # tandoor patch: local sweeps are fine - scoring reads the
        # in-memory logs train() returns, not the logging service
        print('sweep: no wandb/neptune - logging to terminal only')
"""),
    (ROOT / "pufferl.py",
     """        all_logs = train(env_name, args=args)
        all_logs = [e for e in all_logs if target_key in e]
""",
     """        all_logs = train(env_name, args=args)
        # tandoor patch: repeated in-process trainings on MPS pile up
        # allocator pools and compiled graphs - drop them between runs
        if torch.backends.mps.is_available():
            import gc
            gc.collect()
            torch.mps.empty_cache()
        all_logs = [e for e in all_logs if target_key in e]
"""),
    (ROOT / "pufferl.py",
     """    orig_arr = arr
    last = arr[-1]
""",
     """    orig_arr = arr
    # tandoor patch: a short sweep probe can emit fewer scored logs
    # than m points - (n//m)*m is then 0 and arr[-0:] grabs the whole
    # array into an impossible reshape. Use the points as they are.
    if len(arr) <= m + 1:
        return np.array(arr)
    last = arr[-1]
"""),
    (ROOT / "pufferl.py",
     """        sweep.suggest(args)
        total_timesteps = args['train']['total_timesteps']
""",
     """        sweep.suggest(args)
        # tandoor patch: print the sampled config as one grep-able
        # line - nothing else persists it, and a sweep you cannot
        # attribute is a sweep you cannot learn from
        _t = args['train']
        print(f"SWEEP RUN {i}: lr={_t['learning_rate']:.4g} "
              f"gamma={_t['gamma']:.5g} lam={_t['gae_lambda']:.4g} "
              f"ent={_t['ent_coef']:.4g} bptt={_t['bptt_horizon']} "
              f"mb={_t['minibatch_size']} "
              f"steps={_t['total_timesteps']:.3g} "
              f"vf={_t['vf_coef']:.3g} "
              f"gn={_t['max_grad_norm']:.3g}", flush=True)
        total_timesteps = args['train']['total_timesteps']
"""),
    (ROOT / "pufferl.py",
     """    device = values.device
    if not ADVANTAGE_CUDA:
        values = values.cpu()
        rewards = rewards.cpu()
        terminals = terminals.cpu()
        ratio = ratio.cpu()
        advantages = advantages.cpu()

    torch.ops.pufferlib.compute_puff_advantage(values, rewards, terminals,
        ratio, advantages, gamma, gae_lambda, vtrace_rho_clip, vtrace_c_clip)

    if not ADVANTAGE_CUDA:
        return advantages.to(device)

    return advantages
""",
     """    device = values.device
    if not ADVANTAGE_CUDA and device.type == "cuda":
        # tandoor patch: without nvcc at install time there is no CUDA
        # advantage op, and the cpu fallback mutates DETACHED copies -
        # train() relies on in-place mutation (it rebinds to
        # mb_advantages right after the call), so CUDA training got
        # all-zero advantages, silently. Run the certified vtrace scan
        # on-device instead (the same math the Metal kernel matched to
        # 0.00e+00) and write the caller's buffer in place.
        T_ = values.shape[1]
        lastlam = torch.zeros_like(values[:, 0])
        rho = ratio.clamp(max=vtrace_rho_clip)
        cc = ratio.clamp(max=vtrace_c_clip)
        gl = gamma * gae_lambda
        for t in range(T_ - 2, -1, -1):
            nonterm = 1.0 - terminals[:, t + 1]
            delta = rho[:, t] * (rewards[:, t + 1]
                                 + gamma * values[:, t + 1] * nonterm
                                 - values[:, t])
            lastlam = delta + gl * cc[:, t] * lastlam * nonterm
            advantages[:, t] = lastlam
        return advantages
    if not ADVANTAGE_CUDA:
        adv_in = advantages
        values = values.cpu()
        rewards = rewards.cpu()
        terminals = terminals.cpu()
        ratio = ratio.cpu()
        advantages = advantages.cpu()
        torch.ops.pufferlib.compute_puff_advantage(
            values, rewards, terminals, ratio, advantages, gamma,
            gae_lambda, vtrace_rho_clip, vtrace_c_clip)
        adv_in.copy_(advantages.to(device))
        return adv_in

    torch.ops.pufferlib.compute_puff_advantage(values, rewards, terminals,
        ratio, advantages, gamma, gae_lambda, vtrace_rho_clip, vtrace_c_clip)

    return advantages
"""),
    (ROOT / "sweep.py",
     """        assert 'distribution' in param
        distribution = param['distribution']
""",
     """        assert 'distribution' in param
        if param['min'] == param['max']:
            # tandoor patch: zero-width space = pinned hyperparameter.
            # Hold the configured value; don't model it (and don't
            # divide by max-min in the normalizers).
            continue
        distribution = param['distribution']
"""),
]

for path, old, new in PATCHES:
    s = path.read_text()
    if new in s:
        print(f"already applied: {path.name}: {new.splitlines()[1][:50]}")
        continue
    assert old in s, f"anchor not found in {path} - pufferlib changed?"
    path.write_text(s.replace(old, new, 1))
    print(f"patched {path.name}")
print("done")

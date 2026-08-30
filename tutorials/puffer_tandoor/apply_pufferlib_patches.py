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

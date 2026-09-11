"""The frame types in the envs, against the paths they replace:
  1. the slow flower env, mount = pedicel against mount = hashemi with the wind off: the pedicel reaches every command and
     there is no walk, so the chain in the kernel and the el/az injection must trace the same machine - same obs, same reward
  2. the same with the wind on, for the record: the two differ by what the injection approximated
  3. the fast env, mech_kernel 1 against 0 on the same seed and the same commands: same miss and rays through to the order
     of the first-order rotation the host path uses (mrad^2)
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python design/compliant/stage3/screws/test_env_mount.py"""
import os, sys, time, numpy as np, torch
ROOT = "/Users/faezs/ARTIST-compliant"; TUT = ROOT + "/tutorials"; PT = TUT + "/puffer_tandoor"
for p in (PT, TUT, ROOT):
    if p in sys.path: sys.path.remove(p)
    sys.path.insert(0, p)
os.chdir(PT); sys.argv = [sys.argv[0]]
import importlib.util
_sp = importlib.util.spec_from_file_location("puffer_tandoor", PT + "/__init__.py", submodule_search_locations=[PT])
_pk = importlib.util.module_from_spec(_sp); sys.modules["puffer_tandoor"] = _pk; _sp.loader.exec_module(_pk)
sys.modules["pufferlib.environments.tandoor"] = _pk        # the inis say package = tandoor: pufferl imports THAT name, so pin it too
for _m in ("tandoor_screws", "tandoor_mount_batch", "tandoor_metal_kernel", "tandoor_cuda_kernel", "tandoor_fused_step"):
    _s = importlib.util.spec_from_file_location(_m, TUT + "/" + _m + ".py"); _mod = importlib.util.module_from_spec(_s)
    sys.modules[_m] = _mod; _s.loader.exec_module(_mod)
from pufferlib import pufferl
fails = []
def check(name, err, tol):
    ok = err <= tol; print(f"  {'ok ' if ok else 'FAIL'} {name:<70} {err:.2e} (tol {tol:.0e})")
    if not ok: fails.append(name)

def slow_env(mount, wind_scale, agents=64):
    sys.argv = [sys.argv[0]]
    args = pufferl.load_config("puffer_flower"); args["env"]["num_agents"] = agents; args["env"]["mount"] = mount
    args["env"]["wind_scale"] = wind_scale; args["env"]["wind_site"] = 0; args["vec"] = dict(backend="Serial", num_envs=1)
    return pufferl.load_env("puffer_flower", args)

def run_slow(mount, wind_scale, steps=6, seed=3):
    v = slow_env(mount, wind_scale); drv = v.driver_env
    for m in (sys.modules["tandoor_flower_env"], sys.modules["tandoor_metal_kernel"]): assert m.__file__.startswith(ROOT), m.__file__
    ob, _ = v.reset(seed=seed); n_act = v.action_space.shape[-1] if hasattr(v.action_space, "shape") and v.action_space.shape else None
    A = drv.num_agents; obs, rews, thru, perr = [], [], [], []
    for t in range(steps):
        act = np.full((A, n_act), 3, dtype=np.int64) if n_act else np.zeros((A,), dtype=np.int64)
        ob, rew, term, trunc, _ = v.step(act)
        obs.append(np.array(ob, dtype=np.float64)); rews.append(np.array(rew, dtype=np.float64))
        F = drv._fl; thru.append(float(F["thru"].mean()) if "thru" in F else float("nan")); perr.append(float(F["pose_err"].max()) if "pose_err" in F else float("nan"))
    v.close(); return np.stack(obs), np.stack(rews), np.array(thru), np.array(perr), drv.mount

print("1. slow env: mount = pedicel against hashemi, wind off, the walk's floor off")
# FINE_FLOOR (0.2 mm rms of residual walk with no wind at all) is drawn on both paths from the same stream but REPRESENTED
# differently - the injection turns the pointing about F, the chain turns the head about the boom's tip - so it is switched
# off for the equivalence check and back on for the record below
FEm = sys.modules["tandoor_flower_env"]; _floor = FEm.FINE_FLOOR; FEm.FINE_FLOOR = 0.0
o_h, r_h, t_h, p_h, m_h = run_slow("hashemi", 0.0); o_p, r_p, t_p, p_p, m_p = run_slow("pedicel", 0.0)
FEm.FINE_FLOOR = _floor
assert (m_h, m_p) == ("hashemi", "pedicel")
print(f"     pose error max over the steps: hashemi {np.nanmax(p_h):.2e} rad, pedicel {np.nanmax(p_p):.2e} rad; boom clear (thru) {t_h.mean():.3f} / {t_p.mean():.3f}")
# float32, and the 5e-7 rad the pedicel leaves is carried as an el/az injection on one path and as the exact frame on the other
check("obs identical (max abs, states of order 1e2)", float(np.abs(o_h - o_p).max()), 2e-4)
check("reward identical (max abs)", float(np.abs(r_h - r_p).max()), 5e-6)
print("2. slow env: mount = pedicel against hashemi, wind on (the record, not a check)")
o_h, r_h, *_ = run_slow("hashemi", 1.0); o_p, r_p, *_ = run_slow("pedicel", 1.0)
print(f"     with the wind: obs differ by {float(np.abs(o_h - o_p).max()):.2e} max, reward by {float(np.abs(r_h - r_p).max()):.2e}; the injection and the chain differ by what the injection approximated")
print("2b. slow env: mount = fork runs, finite, and traces")
o_f, r_f, t_f, p_f, m_f = run_slow("fork", 1.0)
check("fork: obs finite", 0.0 if np.isfinite(o_f).all() else 1.0, 0.5); check("fork: reward finite", 0.0 if np.isfinite(r_f).all() else 1.0, 0.5)

def run_fast(mech_kernel, steps=300, seed=7, agents=256):
    sys.argv = [sys.argv[0]]
    args = pufferl.load_config("puffer_flower_fast"); args["env"]["num_agents"] = agents; args["env"]["on_device"] = 0
    args["env"]["mech_kernel"] = mech_kernel; args["vec"] = dict(backend="Serial", num_envs=1)
    v = pufferl.load_env("puffer_flower_fast", args); drv = v.driver_env
    assert sys.modules["tandoor_flower_fast"].__file__.startswith(ROOT)
    ob, _ = v.reset(seed=seed); g = np.random.default_rng(seed); n_act = v.action_space.shape[1]
    miss, thru, obs = [], [], []; t0 = time.time()
    for t in range(steps):
        act = g.integers(0, 7, size=(agents, n_act)); act[:, :] = np.where(g.random((agents, n_act)) < 0.7, 3, act)   # mostly neutral, some commands
        ob, rew, term, trunc, _ = v.step(act)
        miss.append(drv.S["miss"].detach().cpu().numpy().astype(np.float64)); thru.append(drv._fl["rays_thru"].detach().cpu().numpy().astype(np.float64)); obs.append(np.array(ob, dtype=np.float64))
    dt = (time.time() - t0)/steps; v.close()
    return np.stack(miss), np.stack(thru), np.stack(obs), dt

print("3. fast env: mech_kernel 1 against 0, same seed, same commands")
m0, t0_, o0, dt0 = run_fast(0); m1, t1_, o1, dt1 = run_fast(1)
check("miss at F identical to the first-order rotation (m)", float(np.abs(m0 - m1).max()), 2e-5)
check("rays through identical (one ray of 64 at the collar's edge)", float(np.abs(t0_ - t1_).max()), 2e-2)
# the frame is a 24 x 24 histogram of 64 rays in 8 bits: a ray on a bin edge flips a whole pixel, so the mean, not the max
check("obs identical (mean abs)", float(np.abs(o0 - o1).mean()), 2e-4)
print(f"     obs max abs {float(np.abs(o0 - o1).max()):.2e} (pixel flips), mean {float(np.abs(o0 - o1).mean()):.2e}")
print(f"     miss rms {100*np.sqrt((m0**2).sum(-1).mean()):.2f} cm both ways; step {1e3*dt0:.1f} ms host frame, {1e3*dt1:.1f} ms with the kernel mount (256 agents, numpy path)")
print("\nFAILED: " + ", ".join(fails) if fails else "\nall passed")
sys.exit(1 if fails else 0)

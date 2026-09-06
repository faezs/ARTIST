"""Parity harness: the fused Metal step vs the torch GpuState step on the same random action script.
    from design_parity import run;  o, r, e = run(force_torch, steps=120, **env_overrides)"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_gpu_step import GpuState
kwd = dict(num_agents=32, seed=99, wide_shutter=1, device="mps", gpu=1, n_rays=256, warm_frac=1.0, day_random=0, lat_random=0,
           lat=30.2, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, spot_bread=1,
           loaves_per_load=8, load_ctrl=1, elbow_aim=1, sticky_k=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6)
def mk(**o):
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**dict(kwd, **o)); e.reset(seed=99)
    e._det_trace = True; e.T[:] = 500.0; e.equilibrate_wall(halo=400.0); e._belt_prev = e.T[:, :e.n_belt].max(1).copy()
    return e
def run(force_torch, steps=120, **o):
    e = mk(**o); S = GpuState(e) if force_torch else FusedState(e); S.zero_noise = True; e._gpu = S
    obs_t, rew_t = [], []
    nvec = np.asarray(e.single_action_space.nvec); rng = np.random.default_rng(7)
    for t in range(steps):
        a = torch.as_tensor(rng.integers(0, nvec, size=(e.num_agents, len(nvec))), device=e.device)
        o_, r, d, tr, _ = e.step_torch(a); obs_t.append(o_.cpu().clone()); rew_t.append(r.cpu().clone())
    return torch.stack(obs_t), torch.stack(rew_t), e
if __name__ == "__main__":
    RT = "/Users/faezs/ARTIST/tutorials/data/tandoor/quetta_roof_quantiles.json"
    for kw in (dict(design_rand=0), dict(design_rand=1, roof_table=RT, wall="firebrick", insulation=0)):
        o1, r1, ea = run(True, **kw); o2, r2, eb = run(False, **kw)
        d = (o1 - o2).abs(); print(f"{kw}: fused vs torch max obs err {float(d.max()):.2e}, rew err {float((r1-r2).abs().max()):.2e}, OD {o1.shape[2]}")
        mism, mx = ea.verify_megakernel(); print(f"   megakernel vs torch: {mism} bins > 1e-3, max {mx:.2e} W")

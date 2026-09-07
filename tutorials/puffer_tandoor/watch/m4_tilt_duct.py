"""M4 tilt steering against the inlet's radius - the inlet is what limits the reach -
and how much the trained cook actually uses the elbow's two axes."""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build, run_day, CK, DEV
from tandoor_design_readout import Policy
import tandoor_polar_env as PE, tandoor_hashemi_env as HE
from m4_tilt import rot_about

TH = np.round(np.arange(-24.0, 24.01, 1.0), 2)
DUCTS = (0.20, 0.25, 0.30)
B = len(TH) * len(DUCTS)
e = build(num_agents=B, gpu=0, device="cpu")
obs, _ = e.reset(seed=3)
N, NB = e.n_nodes, e.n_belt
P4 = np.array(e.cs_P4); F4 = np.array(e.cs_F4); Oe0 = np.array(e.cs_Oe); Ae0 = np.array(e.cs_Ae)
fct = e._fct.clone()
for k, rd in enumerate(DUCTS):
    for i, thd in enumerate(TH):
        b = k * len(TH) + i; R = rot_about([0, 0, 1], np.radians(thd))
        fct[b, 21:24] = torch.tensor(P4 + R @ (Oe0 - P4), dtype=torch.float32)
        fct[b, 24:27] = torch.tensor(R @ Ae0, dtype=torch.float32)
        fct[b, 39] = rd
e._fct = fct
e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
acc = np.zeros((B, N + NB))
for t in range(10):
    e.tick = 800 + t
    acc += e._trace_power(np.full(B, e.p0), np.full(B, 5e-3), np.zeros((B, 2)), np.ones(B)).detach().cpu().numpy()
node, loaf = acc[:, :N], acc[:, N:]; tot = node.sum(1); on = loaf.sum(1)
print(f"{'inlet r':>8s} | slots the tilt reaches at >=90% of the power (best tilt, share of the pot's power on that loaf)")
for k, rd in enumerate(DUCTS):
    base = tot[k * len(TH) + len(TH) // 2]; best = {}
    for i, thd in enumerate(TH):
        b = k * len(TH) + i
        if tot[b] < 0.9 * base or on[b] <= 1e-9: continue
        seg = int(np.argmax(loaf[b])); f = loaf[b, seg] / max(tot[b], 1e-9)
        if seg not in best or f > best[seg][1]: best[seg] = (thd, f)
    print(f"{rd:8.2f} | " + "  ".join(f"slot {s}: {best[s][0]:+.0f}deg {best[s][1]*100:.0f}%" for s in sorted(best)))
# how much does the cook actually move the elbow?
e2 = build(num_agents=64)
sd = torch.load(CK, map_location="cpu", weights_only=False); pol = Policy(sd, DEV)
e2.day = 172; e2.day_v[:] = 172.0
obs, _ = e2.reset(seed=11); pol.reset(64, DEV)
nh, nv = e2.N_HEADS, int(e2.single_action_space.nvec[0])
ph, zz = [], []
for t in range(1200):
    with torch.no_grad():
        a, _ = pol.step(torch.as_tensor(obs, device=DEV, dtype=torch.float32), nh, nv)
    obs, r, term, trunc, info = e2.step(a.cpu().numpy())
    S = e2._gpu
    if S is not None: ph.append(S.spot_phi.cpu().numpy().copy()); zz.append(S.spot_z.cpu().numpy().copy())
ph = np.array(ph); zz = np.array(zz)
zb = 0.5 * (PE.Z_BAKE_LO + PE.Z_CROWN); rb = float(np.sqrt(PE.R_SPH ** 2 - (zb - PE.Z_CPOT) ** 2))
print(f"\nthe trained cook's use of the elbow over a summer day ({ph.shape[0]} steps, {ph.shape[1]} agents):")
print(f"  azimuth aim: {np.degrees(ph.min()):.0f}..{np.degrees(ph.max()):.0f} deg, per-agent spread (sd) {np.degrees(ph.std(0)).mean():.1f} deg = {rb*ph.std(0).mean():.2f} m along the wall")
print(f"  height  aim: {zz.min():.3f}..{zz.max():.3f} m, per-agent spread (sd) {zz.std(0).mean():.3f} m (the bake row sits at {zb:.3f})")

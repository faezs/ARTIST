"""Every wall temperature through one day of the final policy: the 15 pot nodes
(8 belt bins by azimuth, hearth, floor, crown, 4 lower-wall nodes), the sub and
deep layers and the halo, mean over 64 agents, cold summer day at Quetta."""
import sys, contextlib, io, json, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_fused_step import FusedState
from tandoor_design_readout import Policy, DEV
CK = sys.argv[1]; B = 64; DAY = int(sys.argv[2]) if len(sys.argv) > 2 else 172
NDAYS = int(sys.argv[4]) if len(sys.argv) > 4 else 1       # consecutive days with the night carry-over; the last is recorded
pol = Policy(torch.load(CK, map_location="cpu", weights_only=False))
kw = dict(num_agents=B, seed=1, wide_shutter=1, device="mps", gpu=1, n_rays=512, warm_frac=0.0, day_random=0, lat_random=0, lat=30.2,
          day_of_year=DAY, wall_obs=1, n_zones=5, zone_c=0.4, g_orbit=4.0, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, spot_bread=1,
          loaves_per_load=8, load_ctrl=1, sticky_k=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, cut_penalty=75.0,
          lost_deg=5.0, enc_clamp=6.0, wall="ifb", insulation=1, night_carry=int(NDAYS > 1), roti_kj=130.0, bread_area=0.12, elbow_aim=1, flare_ratio=1.4, flare_reflect=0.6, reward_div=75.0)
with contextlib.redirect_stdout(io.StringIO()):
    e = TandoorHashemiEnv(**kw); e.reset(seed=1)
S = FusedState(e); e._gpu = S; nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0]); pol.reset(B)
N = e.n_nodes; names = [f"belt {k}" for k in range(e.n_belt)] + ["hearth", "floor", "crown"] + [f"lower {k}" for k in range(N - e.n_belt - 3)]
a = torch.full((B, nh), 3, dtype=torch.long, device=DEV); o, *_ = e.step_torch(a)
t, T, Ts, Td, Th, pin = [], [], [], [], [], []; days = 0; rot = 0.0
with torch.no_grad():
    for k in range(2000 * NDAYS):
        act, _ = pol.step(o, nh, nv); rot_prev = float(S.day_rotis.mean()); o, r, d, tr, _ = e.step_torch(act)
        if d.reshape(-1).any():
            days += 1; rot = rot_prev
            if days >= NDAYS: break
            t, T, Ts, Td, Th, pin = [], [], [], [], [], []
            continue
        t.append(float(e.t_solar[0])); T.append(S.T.mean(0).cpu().numpy().copy()); Ts.append(S.T_sub.mean(0).cpu().numpy().copy())
        Td.append(S.T_deep.mean(0).cpu().numpy().copy()); Th.append(float(S.T_halo.mean())); pin.append(float(S.diag[:, 0].mean()))
t, T, Ts, Td = np.array(t), np.array(T), np.array(Ts), np.array(Td)
print(f"day {DAY}{' (seasoned day %d)' % NDAYS if NDAYS > 1 else ' (cold pit)'}, {B} agents sampled, rotis/day {rot:.0f}; node areas m2: {np.round(e.node_area, 3).tolist()}")
hdr = "hour   " + " ".join(f"{n:>8s}" for n in names) + "   sub    deep   halo"
print(hdr)
for h in (8.5, 10.0, 12.0, 14.0, 15.9):
    i = int(np.argmin(np.abs(t - h)))
    print(f"{t[i]:5.1f}  " + " ".join(f"{T[i, j]:8.0f}" for j in range(N)) + f"  {Ts[i].mean():5.0f}  {Td[i].mean():5.0f}  {Th[i]:5.0f}")
print(f"peak by node (K): " + ", ".join(f"{n} {T[:, j].max():.0f}" for j, n in enumerate(names)))
json.dump(dict(t=t.tolist(), T=T.tolist(), Ts=Ts.tolist(), Td=Td.tolist(), Th=Th, names=names, pin=pin), open(sys.argv[3] if len(sys.argv) > 3 else "wall_temps.json", "w"))
# figure
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
fig, ax = plt.subplots(2, 1, figsize=(11, 8.5), sharex=True, gridspec_kw=dict(height_ratios=[3, 1.4]))
cmap = plt.get_cmap("tab20")
for j, n in enumerate(names):
    ax[0].plot(t, T[:, j] - 273.15, color=cmap(j % 20), lw=1.6 if j < e.n_belt else 2.2, ls="-" if j < e.n_belt else "--", label=n)
ax[0].plot(t, Ts.mean(1) - 273.15, color="k", lw=1.2, ls=":", label="sub layer (mean)"); ax[0].plot(t, Td.mean(1) - 273.15, color="gray", lw=1.2, ls=":", label="deep layer (mean)")
ax[0].axhline(180, color="#A83E2C", lw=0.8, ls="--"); ax[0].text(t[0] + 0.05, 182, "180 C: the bakery's loading gate", color="#A83E2C", fontsize=8)
ax[0].set_ylabel("wall temperature [°C]"); ax[0].set_title(f"Every pot wall through a {'seasoned (day %d)' % NDAYS if NDAYS > 1 else 'cold'} summer day at Quetta, final policy ({CK.split('/')[-2]}/{CK.split('/')[-1].replace('.pt','')}), {B} agents mean")
ax[0].legend(ncol=4, fontsize=7.5, loc="upper left"); ax[0].grid(alpha=0.25)
ax[1].plot(t, np.array(pin) / 1e3, color="#D8641C", lw=1.5); ax[1].set_ylabel("power into pot [kW]"); ax[1].set_xlabel("solar time [h]"); ax[1].grid(alpha=0.25)
plt.tight_layout(); out = (sys.argv[3] if len(sys.argv) > 3 else "wall_temps.json").replace(".json", ".png"); plt.savefig(out, dpi=130); print("saved", out)

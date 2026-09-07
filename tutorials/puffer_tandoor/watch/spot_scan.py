"""How much of the arriving beam a PERFECT elbow aim could put on a loaf.

Each agent gets a different elbow aim (spot_phi, spot_z) on a grid about a loaf's
centre; one trace bins the arrivals, and the loaf columns say what fraction of the
pot's power landed on the loaf patch. The best cell is what the optics allow; the
trained cook's 50% (summer) / 33% (winter) is what it achieves.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build, DEV
import tandoor_polar_env as PE
import tandoor_hashemi_env as HE

NPH, NZ = 24, 16
B = NPH * NZ
e = build(num_agents=B, gpu=0, device="cpu")          # the torch/numpy path: _bin_pot runs here and reads _spot_view
obs, _ = e.reset(seed=3)
N, NB = e.n_nodes, e.n_belt
zb = 0.5 * (PE.Z_BAKE_LO + PE.Z_CROWN)
rb = float(np.sqrt(PE.R_SPH ** 2 - (zb - PE.Z_CPOT) ** 2))
ph6 = -np.pi + (6.5 / 8.0) * 2.0 * np.pi                # the loaf slot the built elbow aims at
lfh = float(np.sqrt(e.bread_area) / 2.0)                # the loaf's half-size [m]
print(f"the bake row: z {zb:.3f}, wall radius {rb:.3f} m (circumference {2*np.pi*rb:.2f} m, {NB} loaf slots -> pitch {2*np.pi*rb/NB:.2f} m)")
print(f"a loaf is {2*lfh:.2f} x {2*lfh:.2f} m (bread_area {e.bread_area} m2); the built aim is slot 6 at phi {np.degrees(ph6):.0f} deg")
dph = np.linspace(-0.35, 0.35, NPH)                     # +-0.35 rad about the slot centre (the pitch is 0.30 rad)
dz = np.linspace(-0.30, 0.30, NZ)
PH, ZZ = np.meshgrid(dph, dz, indexing="ij")
e.spot_phi[:] = ph6 + PH.reshape(-1); e.spot_z[:] = zb + ZZ.reshape(-1)
e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
e._det_trace = False
acc = np.zeros((B, N + NB))
for t in range(8):
    e.tick = 500 + t
    per = e._trace_power(np.full(B, e.p0), np.full(B, 5e-3), np.zeros((B, 2)), np.ones(B))
    acc += per.detach().cpu().numpy()
node, loaf = acc[:, :N], acc[:, N:]
tot = node.sum(1); on = loaf.sum(1)
frac = np.where(tot > 1e-9, on / np.maximum(tot, 1e-9), 0.0).reshape(NPH, NZ)
i, j = np.unravel_index(np.argmax(frac), frac.shape)
print(f"\nfraction of the pot's power landing ON the loaf patch, over the aim grid:")
print("   dz \\ dphi  " + " ".join(f"{np.degrees(x):5.0f}" for x in dph[::3]))
for jj in range(NZ):
    print(f"   {dz[jj]:+6.2f} m   " + " ".join(f"{frac[ii, jj]*100:5.1f}" for ii in range(0, NPH, 3)))
print(f"\n  best aim: dphi {np.degrees(dph[i]):+.1f} deg ({dph[i]*rb:+.2f} m along the wall), dz {dz[j]:+.2f} m -> {frac[i, j]*100:.1f}% on the loaf")
print(f"  aim at the slot's exact centre: {frac[NPH//2, NZ//2]*100:.1f}%")
# how big is the spot? the fraction on a patch of half-size h, for the best aim
b = int(np.ravel_multi_index((i, j), (NPH, NZ)))
print(f"  at the best aim the bake row takes {node[b, :NB].sum()/tot[b]*100:.0f}% of the pot's power and the loaf {on[b]/tot[b]*100:.0f}%:")
print(f"    so {100 - on[b]/tot[b]*100:.0f}% lands on bare wall - the spot is wider than the {2*lfh:.2f} m loaf")

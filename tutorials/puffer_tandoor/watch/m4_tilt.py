"""Steering by TILTING M4 - what an actuator on the mirror would really do.

The mirror is rotated rigidly about its vertex P4 by theta about the vertical, so the
reflected beam swings by 2 theta and the waist walks across the inlet; the ellipsoid's
foci go with it, so the figure is no longer matched to the new conjugates and the waist
smears (coma). Compared against the idealised re-figured mirror of m4_steer.py.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_polar_env as PE
import tandoor_hashemi_env as HE


def rot_about(axis, th):
    a = np.asarray(axis, float); a /= np.linalg.norm(a); K = np.array([[0, -a[2], a[1]], [a[2], 0, -a[0]], [-a[1], a[0], 0]])
    return np.eye(3) + np.sin(th) * K + (1 - np.cos(th)) * K @ K


TH = np.round(np.arange(-20.0, 20.01, 1.0), 2)             # mirror tilt about the vertical [deg]
B = len(TH)
e = build(num_agents=B, gpu=0, device="cpu")
obs, _ = e.reset(seed=3)
N, NB = e.n_nodes, e.n_belt
F = np.array([e.X_TOWER_C, 0.0, e.z_fold]); P4 = np.array(e.cs_P4); F4 = np.array(e.cs_F4)
Oe0 = np.array(e.cs_Oe); Ae0 = np.array(e.cs_Ae); ae0, ce0 = float(e.cs_ae), float(e.cs_ce)
fct = e._fct.clone()
for i, thd in enumerate(TH):
    R = rot_about([0, 0, 1], np.radians(thd))
    Oe = P4 + R @ (Oe0 - P4); Ae = R @ Ae0
    fct[i, 21:24] = torch.tensor(Oe, dtype=torch.float32); fct[i, 24:27] = torch.tensor(Ae, dtype=torch.float32)
    fct[i, 27] = ae0; fct[i, 28] = ce0
e._fct = fct
e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
acc = np.zeros((B, N + NB))
for t in range(10):
    e.tick = 700 + t
    acc += e._trace_power(np.full(B, e.p0), np.full(B, 5e-3), np.zeros((B, 2)), np.ones(B)).detach().cpu().numpy()
node, loaf = acc[:, :N], acc[:, N:]
tot = node.sum(1); on = loaf.sum(1); base = tot[len(TH) // 2]
L_out = float(np.linalg.norm(F4 - P4))
print(f"M4 tilted about the vertical; the beam swings 2 x tilt, so the waist walks {2*L_out*np.radians(1):.3f} m per degree at the inlet ({L_out:.2f} m away)")
print(f"\n  tilt   waist walk   power   on loaf   hottest loaf slot")
for i, thd in enumerate(TH):
    seg = int(np.argmax(loaf[i])) if on[i] > 1e-9 else -1
    print(f"  {thd:+5.1f} deg  {2*L_out*np.radians(thd):+6.3f} m   {tot[i]/base*100:6.1f}%  {on[i]/max(tot[i],1e-9)*100:6.1f}%   " + (f"slot {seg} ({loaf[i, seg]/max(tot[i],1e-9)*100:.0f}% of the pot's power)" if seg >= 0 else "none"))
best = {}
for i, thd in enumerate(TH):
    seg = int(np.argmax(loaf[i])) if on[i] > 1e-9 else -1
    if seg >= 0 and (seg not in best or on[i]/max(tot[i],1e-9) > best[seg][1]): best[seg] = (thd, on[i]/max(tot[i],1e-9), tot[i]/base)
print("\n  the best tilt for each loaf slot:")
for seg in sorted(best): print(f"    slot {seg}: tilt {best[seg][0]:+5.1f} deg -> {best[seg][1]*100:4.1f}% of the pot's power on that loaf, {best[seg][2]*100:.0f}% of the power still arriving")
zb = 0.5 * (PE.Z_BAKE_LO + PE.Z_CROWN); rb = float(np.sqrt(PE.R_SPH ** 2 - (zb - PE.Z_CPOT) ** 2))
print(f"\n  the loaf pitch on the bake row is {2*np.pi*rb/NB:.2f} m; the fixed elbow aims at slot 6")

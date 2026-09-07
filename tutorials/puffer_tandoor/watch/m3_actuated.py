"""THREE MIRRORS with M3 ACTUATED: one fixed ellipsoid, rotated to choose the roti.

M3's figure is cut once for the roti straight across the pot; the mirror is then
rotated rigidly about the vertical through its vertex (the bore's own axis, so the
incoming cone is unchanged) to swing the beam around the bake row. Swept over the
rotation and the inlet's radius: the power reaching the pot, which slot it lands on,
and how much of it lands there.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
from m3_hits_rotis import slot_world, measure, rb, zb, RDW, H_POT
from m4_tilt import rot_about

PSI = np.round(np.arange(-30.0, 30.01, 2.5), 2)      # rotation of M3 about the vertical [deg]
RD = (0.30, 0.40, 0.50)
B = len(PSI) * len(RD)
eb = build(num_agents=4, gpu=0, device="cpu", n_rays=2048); eb.reset(seed=3)
nb_, lb_ = measure(eb); base_tot = nb_.sum(1).mean(); base_on = lb_.sum(1).mean()
print(f"built four-mirror chain: {base_tot:.0f} W-steps into the pot, {base_on/base_tot*100:.0f}% of it on loaves")
e = build(num_agents=B, gpu=0, device="cpu", n_rays=2048, duct_nozzle=0); e.reset(seed=3)
F = np.array([e.X_TOWER_C, 0.0, e.z_fold]); P4 = np.array(e.cs_P4)
T0 = np.array([-rb - 0.79 + 0.0, 0.0, zb + H_POT])           # the roti straight across the pot (pot azimuth 90 deg)
Oe0 = 0.5 * (F + T0); ce0 = 0.5 * float(np.linalg.norm(T0 - F)); Ae0 = (T0 - F) / (2 * ce0)
ae0 = 0.5 * (float(np.linalg.norm(P4 - F)) + float(np.linalg.norm(T0 - P4)))
print(f"M3's figure is cut for the roti at {np.round(T0,2)} ({np.linalg.norm(T0-P4):.2f} m from M3)")
fct = e._fct.clone()
for i, psi in enumerate(PSI):
    R = rot_about([0, 0, 1], np.radians(psi))
    for j, rd in enumerate(RD):
        b = i * len(RD) + j
        fct[b, 21:24] = torch.tensor(P4 + R @ (Oe0 - P4), dtype=torch.float32)
        fct[b, 24:27] = torch.tensor(R @ Ae0, dtype=torch.float32)
        fct[b, 27] = ae0; fct[b, 28] = ce0; fct[b, 39] = rd
e._fct = fct
node, loaf = measure(e); tot = node.sum(1); NB = e.n_belt
print(f"\n{'M3 turn':>8s} |" + "".join(f"   inlet r {rd:.2f}       " for rd in RD))
print(f"{'[deg]':>8s} |" + "".join(f"  {'power':>6s} {'slot':>5s} {'on it':>6s}" for rd in RD))
for i, psi in enumerate(PSI):
    line = f"{psi:+8.1f} |"
    for j, rd in enumerate(RD):
        b = i * len(RD) + j
        seg = int(np.argmax(loaf[b])); f = loaf[b, seg] / max(tot[b], 1e-9)
        line += f"  {tot[b]/base_tot*100:5.0f}% {(str(seg) if f > 0.02 else '-'):>5s} {f*100:5.0f}%"
    print(line)
print(f"\n(the built chain puts {base_on/base_tot*100:.0f}% of its pot power on loaves; 'on it' is the share on the single slot the beam lands on)")

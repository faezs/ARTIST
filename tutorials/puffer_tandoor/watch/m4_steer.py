"""Can M4 steer the spot, so the elbow can be a fixed mirror?

M4 is the ellipsoid at the turn: it images the dish's focus F onto the pot's inlet,
and the beam only clears the inlet because it is focused there. "Actuating M4" means
moving its second focus off the inlet's centre by delta - the mirror stays at P4, so
the ellipsoid is re-figured through P4 with foci F and (inlet + delta). The fixed
elbow inside then re-images that displaced waist onto the wall, magnified.

Measured per offset: the power that survives the inlet, where the spot lands, and the
share that falls on the loaf patch the elbow is aimed at.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_polar_env as PE
import tandoor_hashemi_env as HE

OFFS = np.round(np.arange(-0.30, 0.3001, 0.02), 3)      # lateral offset of M4's focus at the inlet [m]
AX = ("y", "z")
B = len(OFFS) * len(AX)
e = build(num_agents=B, gpu=0, device="cpu")
obs, _ = e.reset(seed=3)
N, NB = e.n_nodes, e.n_belt
F = np.array([e.X_TOWER_C, 0.0, e.z_fold]); P4 = np.array(e.cs_P4); F4 = np.array(e.cs_F4)
print(f"M4 at {np.round(P4,2)} images the dish focus F {np.round(F,2)} onto the inlet {np.round(F4,2)}")
print(f"  bore F->P4 {np.linalg.norm(P4-F):.2f} m, M4->inlet {np.linalg.norm(F4-P4):.2f} m, inlet radius r_duct {e.r_duct:.2f} m")
fct = e._fct.clone()
for k, ax in enumerate(AX):
    u = np.array([0.0, 1.0, 0.0]) if ax == "y" else np.array([0.0, 0.0, 1.0])
    for i, d in enumerate(OFFS):
        b = k * len(OFFS) + i
        F4p = F4 + d * u
        Oe = 0.5 * (F + F4p); ce = 0.5 * float(np.linalg.norm(F4p - F))
        Ae = (F4p - F) / (2 * ce); ae = 0.5 * (float(np.linalg.norm(P4 - F)) + float(np.linalg.norm(F4p - P4)))
        fct[b, 21:24] = torch.tensor(Oe, dtype=torch.float32); fct[b, 24:27] = torch.tensor(Ae, dtype=torch.float32)
        fct[b, 27] = ae; fct[b, 28] = ce
e._fct = fct
e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
acc = np.zeros((B, N + NB))
for t in range(8):
    e.tick = 600 + t
    acc += e._trace_power(np.full(B, e.p0), np.full(B, 5e-3), np.zeros((B, 2)), np.ones(B)).detach().cpu().numpy()
node, loaf = acc[:, :N], acc[:, N:]
tot = node.sum(1); on = loaf.sum(1)
base = tot[len(OFFS) // 2]
print(f"\n  offset  |  {'along +y (across the duct axis)':34s} |  {'along +z (up)':34s}")
print(f"   [m]    |  {'power':>7s} {'on loaf':>8s} {'hottest slot':>13s} |  {'power':>7s} {'on loaf':>8s} {'hottest slot':>13s}")
for i, d in enumerate(OFFS):
    row = f"  {d:+5.2f}   |"
    for k in range(2):
        b = k * len(OFFS) + i
        seg = int(np.argmax(loaf[b])) if on[b] > 1e-9 else -1
        row += f"  {tot[b]/base*100:6.1f}% {on[b]/max(tot[b],1e-9)*100:7.1f}% {('slot %d %.0f%%' % (seg, loaf[b, seg]/max(tot[b],1e-9)*100)) if seg >= 0 else 'none':>13s} |"
    print(row)
zb = 0.5 * (PE.Z_BAKE_LO + PE.Z_CROWN); rb = float(np.sqrt(PE.R_SPH ** 2 - (zb - PE.Z_CPOT) ** 2))
print(f"\n  a loaf pitch on the bake row is {2*np.pi*rb/NB:.2f} m; the elbow's fixed aim is slot 6")

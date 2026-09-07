"""THREE MIRRORS, M3 ACTUATED: dish -> strip -> M3 -> a chosen roti. No elbow.

The pot's frame is stitched to the trace's at the duct mouth (_bin_pot): pot x = world
y, pot y = -world x, pot z = world z, with the mouth at pot (0, -R_DUCT_WALL, Z_DUCT).
So each loaf slot's centre has a world position, and M3's second focus is put ON it -
the mirror is re-aimed, which is what an actuator on M3 does. Swept over the eight
slots and the inlet's radius: the power that reaches the pot and the share that lands
on the slot aimed at.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_polar_env as PE
import tandoor_hashemi_env as HE

RD = (0.20, 0.30, 0.40, 0.50, 0.60)
NB = 8
B = NB * len(RD)
zb = 0.5 * (PE.Z_BAKE_LO + PE.Z_CROWN)
rb = float(np.sqrt(PE.R_SPH ** 2 - (zb - PE.Z_CPOT) ** 2))
RDW = float(PE.R_DUCT_WALL)
print(f"pot: bake row at pot z {zb:.3f}, wall radius {rb:.3f} m; the duct enters at pot (0, {-RDW:.2f}, {PE.Z_DUCT:.2f})")


H_POT = 1.0                      # _bin_pot: pot z = world z - H_POT (PE.Z_DUCT -0.86 is the pot-frame duct height)


def slot_world(k):
    """the world position of loaf slot k's centre on the bake row"""
    ph = -np.pi + ((k + 0.5) / NB) * 2 * np.pi
    px, py, pz = rb * np.cos(ph), rb * np.sin(ph), zb
    return np.array([-py + 0.42 - RDW, px, pz + H_POT]), np.degrees(ph)


def measure(e, n=8):
    N, NBk = e.n_nodes, e.n_belt
    e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
    el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
    e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
    acc = np.zeros((e.num_agents, N + NBk))
    for t in range(n):
        e.tick = 1200 + t
        acc += e._trace_power(np.full(e.num_agents, e.p0), np.full(e.num_agents, 5e-3),
                              np.zeros((e.num_agents, 2)), np.ones(e.num_agents)).detach().cpu().numpy()
    return acc[:, :N], acc[:, N:]


eb = build(num_agents=4, gpu=0, device="cpu", n_rays=2048); eb.reset(seed=3)
nb_, lb_ = measure(eb); base_tot = nb_.sum(1).mean(); base_on = lb_.sum(1).mean()
print(f"built four-mirror chain: {base_tot:.0f} W-steps into the pot, {base_on/base_tot*100:.0f}% on loaves, hottest slot {int(np.argmax(lb_.sum(0)))}\n")

e = build(num_agents=B, gpu=0, device="cpu", n_rays=2048, duct_nozzle=0); e.reset(seed=3)
F = np.array([e.X_TOWER_C, 0.0, e.z_fold]); P4 = np.array(e.cs_P4)
fct = e._fct.clone(); rows = []
for k in range(NB):
    T, phd = slot_world(k)
    for j, rd in enumerate(RD):
        b = k * len(RD) + j
        Oe = 0.5 * (F + T); ce = 0.5 * float(np.linalg.norm(T - F))
        Ae = (T - F) / (2 * ce); ae = 0.5 * (float(np.linalg.norm(P4 - F)) + float(np.linalg.norm(T - P4)))
        fct[b, 21:24] = torch.tensor(Oe, dtype=torch.float32); fct[b, 24:27] = torch.tensor(Ae, dtype=torch.float32)
        fct[b, 27] = ae; fct[b, 28] = ce; fct[b, 39] = rd
        rows.append((k, phd, rd, T))
e._fct = fct
node, loaf = measure(e); tot = node.sum(1); NBk = e.n_belt
print(f"M3 aimed at each roti in turn (power as a share of the built chain; 'on target' = the share landing on the slot aimed at)")
print(f"{'slot':>5s} {'azimuth':>8s} {'M3->roti':>9s} |" + "".join(f"  r_duct {rd:.2f}" for rd in RD))
print(f"{'':>5s} {'':>8s} {'':>9s} |" + "".join(f"  {'power/target':>12s}" for rd in RD))
for k in range(NB):
    T, phd = slot_world(k); dist = float(np.linalg.norm(T - P4))
    line = f"{k:5d} {phd:7.0f}d {dist:8.2f}m |"
    for j, rd in enumerate(RD):
        b = k * len(RD) + j
        line += f"  {tot[b]/base_tot*100:5.0f}% {loaf[b, k]/max(tot[b],1e-9)*100:5.0f}%"
    print(line)

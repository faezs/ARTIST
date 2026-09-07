"""THE THREE-MIRROR MACHINE: dish -> hyperboloid strip -> M3 -> the rotis. No elbow.

M3's second focus is moved off the inlet and out onto the bake row, so the beam is
aimed straight at the bread; the elbow is switched off (duct_nozzle = 0). The inlet is
then the only aperture in the way, so the sweep is over where M3 aims (distance D past
the mouth, elevation alpha above the duct axis) and how wide the inlet is.

Reported per design: the power reaching the pot against the built four-mirror chain,
where it lands, and the share on the loaf patches.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_hashemi_env as HE

D_L = (0.8, 1.2, 1.6, 2.0, 2.4)                  # how far past the mouth M3 focuses [m]
AL = (0.0, 5.0, 10.0, 15.0, 20.0, 25.0)          # elevation of the aim above the duct axis [deg]
RD = (0.20, 0.30, 0.40, 0.50)                    # inlet radius [m] (0.20 as built)
B = len(D_L) * len(AL) * len(RD)


def measure(e, tag, n=8):
    N, NB = e.n_nodes, e.n_belt
    e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
    el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
    e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
    acc = np.zeros((e.num_agents, N + NB))
    for t in range(n):
        e.tick = 1100 + t
        acc += e._trace_power(np.full(e.num_agents, e.p0), np.full(e.num_agents, 5e-3),
                              np.zeros((e.num_agents, 2)), np.ones(e.num_agents)).detach().cpu().numpy()
    return acc[:, :N], acc[:, N:]


# the built four-mirror chain, for the baseline
eb = build(num_agents=4, gpu=0, device="cpu", n_rays=2048)
eb.reset(seed=3)
nb_, lb_ = measure(eb, "built")
base_tot = nb_.sum(1).mean(); base_loaf = lb_.sum(1).mean()
NBk = eb.n_belt
print(f"built chain (dish -> strip -> M3 -> elbow -> pot): {base_tot:.1f} W-steps into the pot, {base_loaf/base_tot*100:.0f}% on loaves")

e = build(num_agents=B, gpu=0, device="cpu", n_rays=2048, duct_nozzle=0)
e.reset(seed=3)
F = np.array([e.X_TOWER_C, 0.0, e.z_fold]); P4 = np.array(e.cs_P4); F4 = np.array(e.cs_F4)
ax = (F4 - P4) / np.linalg.norm(F4 - P4)          # the duct axis, M3 -> mouth
up = np.array([0.0, 0.0, 1.0])
fct = e._fct.clone(); rows = []
for i, D in enumerate(D_L):
    for j, al in enumerate(AL):
        for k, rd in enumerate(RD):
            b = (i * len(AL) + j) * len(RD) + k
            d = ax * np.cos(np.radians(al)) + up * np.sin(np.radians(al))
            T = F4 + D * d / np.linalg.norm(d)     # M3 focuses here, past the mouth, inside the pot
            Oe = 0.5 * (F + T); ce = 0.5 * float(np.linalg.norm(T - F))
            Ae = (T - F) / (2 * ce); ae = 0.5 * (float(np.linalg.norm(P4 - F)) + float(np.linalg.norm(T - P4)))
            fct[b, 21:24] = torch.tensor(Oe, dtype=torch.float32); fct[b, 24:27] = torch.tensor(Ae, dtype=torch.float32)
            fct[b, 27] = ae; fct[b, 28] = ce; fct[b, 39] = rd
            rows.append((D, al, rd))
e._fct = fct
node, loaf = measure(e, "three-mirror")
tot = node.sum(1); on = loaf.sum(1); NB = e.n_belt
bake = node[:, :NB].sum(1)
print(f"\nthree-mirror (no elbow): M3 focuses D metres past the mouth, alpha above the duct axis")
print(f"{'D':>5s} {'alpha':>6s} {'inlet r':>8s} | {'power vs built':>14s} {'on the bake row':>16s} {'on loaves':>10s} {'best slot':>10s}")
best = None
for b, (D, al, rd) in enumerate(rows):
    if tot[b] < 0.02 * base_tot: continue
    seg = int(np.argmax(loaf[b]))
    line = (D, al, rd, tot[b] / base_tot, bake[b] / max(tot[b], 1e-9), on[b] / max(tot[b], 1e-9), seg)
    if best is None or (line[3] * line[5]) > (best[3] * best[5]): best = line
    if rd in (0.20, 0.40) and al in (0.0, 10.0, 20.0):
        print(f"{D:5.1f} {al:6.0f} {rd:8.2f} | {tot[b]/base_tot*100:13.0f}% {bake[b]/max(tot[b],1e-9)*100:15.0f}% {on[b]/max(tot[b],1e-9)*100:9.0f}% {seg:10d}")
print(f"\nbest by (power x on-loaf): D {best[0]:.1f} m, alpha {best[1]:.0f} deg, inlet r {best[2]:.2f} m -> {best[3]*100:.0f}% of the built chain's power, {best[5]*100:.0f}% of it on loaves (built: {base_loaf/base_tot*100:.0f}%)")

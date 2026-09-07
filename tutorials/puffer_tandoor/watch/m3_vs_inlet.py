"""The constraint "the turn mirror is smaller than the inlet", as a design sweep.

The strip images the sun's image at F (radius f_dish x 4.65 mrad = 19 mm) onto its
second focus with magnification (2c - d_strip)/d_strip, and that image IS the beam at
the turn. A bigger d_strip means a smaller magnification, a smaller image at the turn,
and a beam that fits the inlet - at the price of a strip that grows as d_strip^2.

Swept: d_strip x r_duct x {ellipsoid turn mirror, FLAT turn mirror}. Measured: the
power that reaches the pot and the share that lands on the loaf the elbow aims at.
"""
import sys, contextlib, io, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch")
from elbow_audit import build
import tandoor_hashemi_env as HE

DS = (0.4, 0.6, 0.8, 1.0, 1.2)
RD = (0.20, 0.25, 0.30)
M4 = (("ellipsoid", 0.0), ("flat", 1.0))
B = len(DS) * len(RD) * len(M4)
e = build(num_agents=B, gpu=0, device="cpu", design_rand=1,
          roof_table="/Users/faezs/ARTIST/tutorials/data/tandoor/quetta_tandoor_roof_quantiles.json")
obs, _ = e.reset(seed=3)
N, NB = e.n_nodes, e.n_belt
BOX = tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX); names = [k for k, _, _ in BOX]
u0 = np.zeros(len(BOX))
for i, (k, lo, hi) in enumerate(BOX):
    v = getattr(e, k, None); u0[i] = 0.5 if (v is None or k == "roof_r") else float(np.clip((float(v) - lo) / (hi - lo), 0, 1))
for k, v in dict(roof_r=0.5, cap_scale=0.375, demand_scale=1/3, mount_post=1.0, deck_h=0.2, sand_depth=0.0,
                 loaves_per_load=1.0, section=0.0, post_rise=0.0, over_cap=0.5, roof_light=0.0, grid=0.0, zones=1.0).items():
    u0[names.index(k)] = v
u = np.tile(u0, (B, 1)); rows = []
ix = lambda k: names.index(k)
box = {k: (lo, hi) for k, lo, hi in BOX}
for a, ds in enumerate(DS):
    for b_, rd in enumerate(RD):
        for c, (mnm, mf) in enumerate(M4):
            i = (a * len(RD) + b_) * len(M4) + c
            u[i, ix("d_strip")] = (ds - box["d_strip"][0]) / (box["d_strip"][1] - box["d_strip"][0])
            u[i, ix("r_duct")] = (rd - box["r_duct"][0]) / (box["r_duct"][1] - box["r_duct"][0])
            u[i, ix("m4_facet")] = mf
            rows.append((ds, rd, mnm))
e.set_design_points(u)
e.day = 172; e.day_v[:] = 172.0; e.lat_v[:] = 30.2; e.t_solar[0] = 12.0
el, az, _ = HE._sim.solar_position(30.2, 172, 12.0)
e.el_m[:] = el; e.az_m[:] = np.degrees(az) if abs(az) < 7 else az
acc = np.zeros((B, N + NB))
for t in range(10):
    e.tick = 900 + t
    acc += e._trace_power(np.full(B, e.p0), np.full(B, 5e-3), np.zeros((B, 2)), np.ones(B)).detach().cpu().numpy()
node, loaf = acc[:, :N], acc[:, N:]; tot = node.sum(1); on = loaf.sum(1)
base = max(tot[rows.index((0.6, 0.20, "ellipsoid"))], 1e-9)
rho_F = 4.05 * 4.65e-3                       # the sun's image radius at the dish focus [m]
print(f"the sun's image at F is {rho_F*1e3:.0f} mm in radius; the strip magnifies it onto the turn")
print(f"\n{'d_strip':>7s} {'strip m2':>8s} {'mag':>5s} {'image at the turn':>17s} | {'inlet':>5s} {'turn mirror':>11s} {'power':>7s} {'on loaf':>8s}")
for i, (ds, rd, mnm) in enumerate(rows):
    if mnm != "ellipsoid" and i % 2 == 0: pass
    bore = float(np.linalg.norm(np.array(e.cs_P4) - np.array([e.X_TOWER_C, 0.0, e.z_fold])))
    twoc = bore + (0.83 if mnm == "flat" else 0.0)
    mag = (twoc - ds) / ds
    A_strip = (1.4 * ds) ** 2 * np.radians(100.0) * 1.1
    print(f"{ds:7.2f} {A_strip:8.2f} {mag:5.1f} {2*rho_F*mag:17.2f} | {2*rd:5.2f} {mnm:>11s} {tot[i]/base*100:6.1f}% {on[i]/max(tot[i],1e-9)*100:7.1f}%")

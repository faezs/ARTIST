#!/usr/bin/env python
"""Shading raster for the fourth pass: project every solid of a scene along the sun line onto the aperture plane and
count what lies in front of the membrane inside the annulus r_hole..a. Everything of the mount is behind."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); sys.path.insert(0, os.path.join(HERE, "..", "fact_mount"))
import physics_hp as H, geometry as GM
OUT = os.path.join(HERE, "out"); O = json.load(open(os.path.join(OUT, "optics.json"))); PX = 0.01
def check(name, doy, hour):
    el, A, s = H.sun(doy, hour); s, h, e, n = GM.frame(el, A); xl, yl, zl = -n, e, s
    Q = np.array([1.25, 0.0, O["z_neck"]]); N = Q + O["OFF"]*e; Vx = N + O["NECK"]*s
    parts = json.load(open(os.path.join(OUT, name + ".json")))["parts"]
    Ng = int(round(4.4/PX)); xs = (np.arange(Ng) + 0.5)*PX - 2.2; gx, gy = np.meshgrid(xs, xs, indexing="ij"); rr = np.hypot(gx, gy); ann = (rr > O["r_hole"]) & (rr < H.A_DISH)
    masks = {}
    for p in parts:
        if "v" not in p or any(k in p["name"].lower() for k in ("membrane", "plenum", "deck", "wall", "bore", "pot", "underground", "f2 (")): continue
        v = np.asarray(p["v"], float)/1e3 - Vx; f = np.asarray(p["f"], int); u = v@xl; w = v@yl; z = v@zl
        cen_r = np.hypot(u[f].mean(1), w[f].mean(1)); cen_z = z[f].mean(1)
        front = cen_z > H.R_SPH - np.sqrt(np.maximum(H.R_SPH**2 - cen_r**2, 0)) + 0.02
        tri = f[front & (cen_r < 2.4)]
        if len(tri) == 0: continue
        m = masks.setdefault(p["name"].split(" (")[0][:60], np.zeros((Ng, Ng), bool))
        for t in tri:
            P = np.column_stack([u[t], w[t]]); lo = np.floor((P.min(0) + 2.2)/PX).astype(int).clip(0, Ng - 1); hi = np.ceil((P.max(0) + 2.2)/PX).astype(int).clip(0, Ng - 1)
            if hi[0] <= lo[0] or hi[1] <= lo[1]: continue
            X = gx[lo[0]:hi[0] + 1, lo[1]:hi[1] + 1]; Y = gy[lo[0]:hi[0] + 1, lo[1]:hi[1] + 1]; (x0, y0), (x1, y1), (x2, y2) = P
            d = (y1 - y2)*(x0 - x2) + (x2 - x1)*(y0 - y2)
            if abs(d) < 1e-12: continue
            l0 = ((y1 - y2)*(X - x2) + (x2 - x1)*(Y - y2))/d; l1 = ((y2 - y0)*(X - x2) + (x0 - x2)*(Y - y2))/d; l2 = 1 - l0 - l1
            m[lo[0]:hi[0] + 1, lo[1]:hi[1] + 1] |= (l0 >= -1e-9) & (l1 >= -1e-9) & (l2 >= -1e-9)
    net = ann.sum()*PX*PX; tot = np.zeros((Ng, Ng), bool)
    out = [f"{name}: doy {doy} {hour:.0f} h, el {np.degrees(el):.0f}, az {np.degrees(A):.0f}; net aperture (r {O['r_hole']:.2f}..{H.A_DISH}) {net:.2f} m2"]
    for k, m in sorted(masks.items(), key=lambda kv: -(kv[1] & ann).sum()):
        a = (m & ann).sum()*PX*PX; tot |= m
        if a > 0: out.append(f"    {k}: {a:.3f} m2 = {100*a/net:.2f} %")
    out.append(f"    TOTAL in front of the membrane {(tot & ann).sum()*PX*PX:.3f} m2 = {100*(tot & ann).sum()*PX*PX/net:.2f} % (the cass machine's above-deck parts: 17-25 %)")
    return out
if __name__ == "__main__":
    L = []
    for name, doy, hour in (("cd_equinox_noon", 80, 12.0), ("cd_summer_noon", 172, 12.0), ("cd_morning", 80, 9.0)): L += check(name, doy, hour)
    print("\n".join(L)); open(os.path.join(OUT, "shading.txt"), "w").write("\n".join(L))

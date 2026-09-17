#!/usr/bin/env python
"""Shading check: project every solid of a machine scene along the sun line onto the aperture plane and rasterise
what lies in front of the membrane inside the aperture annulus (0.5 < r < 2.1 m). Reports the mount's parts and
the cass machine's own parts separately."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic"))
import physics_hp as H, geometry as GM
OUT = os.path.join(HERE, "out"); PX = 0.01
MOUNT = ("post", "arm", "tank", "crank", "jack", "bracket", "frame", "back ring", "blade", "bar", "saddle", "upright", "clamp", "column", "strut", "neck", "foot", "ring beam")
def check(name, doy, hour):
    el, A, s = H.sun(doy, hour); xl, yl, zl = GM.dish_axes(el, A); Vx = GM.F - GM.G*s
    parts = json.load(open(os.path.join(OUT, name + ".json")))["parts"]
    N = int(round(4.4/PX)); xs = (np.arange(N) + 0.5)*PX - 2.2
    gx, gy = np.meshgrid(xs, xs, indexing="ij"); rr = np.hypot(gx, gy); annulus = (rr > H.R_HOLE) & (rr < H.A_DISH)
    masks = {}
    for p in parts:
        if "v" not in p: continue
        pn = p["name"].lower()
        if any(k in pn for k in ("membrane", "plenum", "deck", "wall", "column below", "m4", "pot", "beam", "sun", "axis")) and not "water column" in pn: continue
        v = np.asarray(p["v"], float)/1e3 - Vx; f = np.asarray(p["f"], int)
        u = v@xl; w = v@yl; z = v@zl
        cen_r = np.hypot(u[f].mean(1), w[f].mean(1)); cen_z = z[f].mean(1)
        front = cen_z > GM.R_SPH - np.sqrt(np.maximum(GM.R_SPH**2 - cen_r**2, 0)) + 0.02
        tri = f[front & (cen_r < 2.4)]
        if len(tri) == 0: continue
        key = "mount: " + p["name"] if any(k in pn for k in MOUNT) else "cass: " + p["name"]
        key = key.split(" (")[0]
        m = masks.setdefault(key, np.zeros((N, N), bool))
        for t in tri:
            P = np.column_stack([u[t], w[t]]); lo = np.floor((P.min(0) + 2.2)/PX).astype(int).clip(0, N - 1); hi = np.ceil((P.max(0) + 2.2)/PX).astype(int).clip(0, N - 1)
            if hi[0] <= lo[0] or hi[1] <= lo[1]: continue
            X = gx[lo[0]:hi[0] + 1, lo[1]:hi[1] + 1]; Y = gy[lo[0]:hi[0] + 1, lo[1]:hi[1] + 1]
            (x0, y0), (x1, y1), (x2, y2) = P
            d = (y1 - y2)*(x0 - x2) + (x2 - x1)*(y0 - y2)
            if abs(d) < 1e-12: continue
            l0 = ((y1 - y2)*(X - x2) + (x2 - x1)*(Y - y2))/d; l1 = ((y2 - y0)*(X - x2) + (x0 - x2)*(Y - y2))/d; l2 = 1 - l0 - l1
            m[lo[0]:hi[0] + 1, lo[1]:hi[1] + 1] |= (l0 >= -1e-9) & (l1 >= -1e-9) & (l2 >= -1e-9)
    net = annulus.sum()*PX*PX
    rows = [(k, (m & annulus).sum()*PX*PX) for k, m in masks.items()]
    mount = np.zeros((N, N), bool); cass = np.zeros((N, N), bool)
    for k, m in masks.items(): (mount if k.startswith("mount") else cass).__ior__(m)
    out = [f"{name}: doy {doy} {hour:.0f} h, el {np.degrees(el):.0f}, az {np.degrees(A):.0f}; net aperture {net:.2f} m2"]
    for k, a in sorted(rows, key=lambda r: -r[1]):
        if a > 0: out.append(f"    {k}: {a:.3f} m2 = {100*a/net:.2f} %")
    out.append(f"    MOUNT total {(mount & annulus).sum()*PX*PX:.3f} m2 = {100*(mount & annulus).sum()*PX*PX/net:.2f} %;  cass machine's own (tube, strip ring, rim, F markers) {(cass & annulus).sum()*PX*PX:.3f} m2 = {100*(cass & annulus).sum()*PX*PX/net:.2f} %")
    return out
if __name__ == "__main__":
    L = []
    for name, doy, hour in (("fm_machine", 80, 12.0), ("fm_summer", 172, 12.0), ("fm_morning", 80, 9.0)):
        L += check(name, doy, hour)
    L.append("(the strip itself is drawn as lines; its obscuration is the Cassegrain secondary's, in the other fork's ray trace)")
    print("\n".join(L)); open(os.path.join(OUT, "shading.txt"), "w").write("\n".join(L))

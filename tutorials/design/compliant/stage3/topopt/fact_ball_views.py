#!/usr/bin/env python
"""Views of the flexure balls that fact_ball_cad.py builds: the chapter's tripod and the waist the solid argues for, each in
isometric, elevation and plan, with the numbers that decide them. Reads the mesh JSONs, writes out/fact_ball_cad.png."""
import os, json, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
def mesh(tag):
    P = json.load(open(os.path.join(OUT, tag + ".json")))["parts"]
    V = np.array(P[0]["v"]); F = np.array(P[0]["f"]).reshape(-1, 3)
    for p in P[1:]:
        n = len(V); V = np.vstack([V, np.array(p["v"])]); F = np.vstack([F, np.array(p["f"]).reshape(-1, 3) + n])
    return V, F
def draw(ax, V, F, el, az, base=(0.82, 0.45, 0.20)):
    tri = V[F]; nrm = np.cross(tri[:, 1] - tri[:, 0], tri[:, 2] - tri[:, 0]); nrm = nrm/np.maximum(np.linalg.norm(nrm, axis=1), 1e-9)[:, None]
    lt = np.array([0.35, -0.75, 0.56]); lt /= np.linalg.norm(lt); sh = 0.30 + 0.70*np.clip(np.abs(nrm@lt), 0, 1)
    ax.add_collection3d(Poly3DCollection(tri, facecolors=np.stack([base[0]*sh, base[1]*sh, base[2]*sh, np.ones_like(sh)], 1),
                                         edgecolors=(0.1, 0.1, 0.1, 0.10), linewidths=0.12))
    lo, hi = V.min(0), V.max(0); c = 0.5*(lo + hi); r = 0.52*max(hi - lo)
    ax.set_xlim(c[0]-r, c[0]+r); ax.set_ylim(c[1]-r, c[1]+r); ax.set_zlim(c[2]-r, c[2]+r)
    ax.set_box_aspect((1, 1, 1)); ax.view_init(el, az); ax.set_axis_off()
def card(tag):
    d = json.load(open(os.path.join(OUT, tag + "_cad.json"))); return d
if __name__ == "__main__":
    T, N = "fact_ball_tripod_ti", "fact_ball_neck_ti"
    dT, dN = card(T), card(N); VT, FT = mesh(T); VN, FN = mesh(N)
    fig = plt.figure(figsize=(15.5, 9.4))
    for row, (V, F, d, name) in enumerate(((VT, FT, dT, "the chapter's construction: three legs, two blades each"),
                                           (VN, FN, dN, "what the solid argues for: one turned waist"))):
        for col, (el, az, ttl) in enumerate(((24, -58, "isometric"), (2, -90, "elevation"), (88, -90, "plan"))):
            ax = fig.add_subplot(2, 3, 3*row + col + 1, projection="3d"); draw(ax, V, F, el, az)
            if col == 0:
                p = d["part"]
                if d["kind"] == "tripod":
                    txt = (f"{name}\ncone {d['alpha_deg']:.0f} deg; blades {1e3*p['t']:.1f} mm thick, {1e3*p['w_B']:.0f} and {1e3*p['w_A']:.0f} wide, {1e3*p['L']:.0f} long\n"
                           f"at {1e3*p['s_in']:.0f} and {1e3*p['s_out']:.0f} mm from C; {p['sig']/1e6:.0f} MPa at +-{d['theta_deg']:.2f} deg\n"
                           f"{d['envelope_mm']['d']:.0f} x {d['envelope_mm']['h']:.0f} mm, {d['mass_kg']:.2f} kg, {p['k_j']/1e6:.0f} MN/m")
                else:
                    txt = (f"{name}\nwaist {2e3*p['r']:.1f} mm across, {1e3*p['h']:.1f} mm long; {p['sig']/1e6:.0f} MPa at +-{d['theta_deg']:.2f} deg\n"
                           f"restoring moment {p['k_th']*p['theta']:.0f} N m; {p['sig_c']/1e6:.0f} MPa of compression at the 40 m/s gust\n"
                           f"{d['envelope_mm']['d']:.0f} x {d['envelope_mm']['h']:.0f} mm, {d['mass_kg']:.2f} kg, {p['k_j']/1e6:.0f} MN/m")
                ax.set_title(txt, fontsize=8.5, loc="left")
            else: ax.set_title(ttl, fontsize=9)
    fig.suptitle("The flexure ball as a solid: both hold the strut on three rotations about C and nothing else, both are one monolithic piece, both print flange down without support", fontsize=11)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, "fact_ball_cad.png"), dpi=105); print("wrote", os.path.join(OUT, "fact_ball_cad.png"))

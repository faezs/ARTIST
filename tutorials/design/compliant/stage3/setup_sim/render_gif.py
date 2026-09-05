#!/usr/bin/env python
"""GIF and contact sheet of the self-setup simulation from out/setup_anim.json (matplotlib)."""
import os, json, base64, zlib, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection, Line3DCollection
import imageio.v2 as imageio
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
A = json.load(open(os.path.join(OUT, "setup_anim.json")))
Q = np.frombuffer(zlib.decompress(base64.b64decode(A["blob"])), dtype=np.int16).reshape(A["n_frames"], A["n_particles"], 3)*A["scale"]
tris = np.array(A["tris"]).reshape(-1, 3); log = A["log"]; T = A["t_setup"]
def phase(l):
    t = l["t"]
    return "stowed, tubes pressurised" if t < 0.08*T else "posts grow to F's height" if t < 0.42*T else "arms and counterweight tubes grow" if t < 0.66*T else "water into the counterweights" if t < 0.74*T else "cradle turns to the morning sun" if t < T else "tracking the sun"
def draw(ax, fr, small=False):
    q = Q[fr]; l = log[fr]
    ax.cla(); ax.set_xlim(-6, 8); ax.set_ylim(-7, 7); ax.set_zlim(0, 12); ax.set_box_aspect((14, 14, 12))
    xx, yy = np.meshgrid([-5, 8], [-7, 7]); ax.plot_surface(xx, yy, 0*xx, color="#eef2f6", alpha=0.6, zorder=0)
    if A.get("rail"): th = np.linspace(0, 2*np.pi, 80); ax.plot(A["rail"]["c"][0] + A["rail"]["r"]*np.cos(th), A["rail"]["c"][1] + A["rail"]["r"]*np.sin(th), 0.05 + 0*th, color="#9aa5b1", lw=1.5)
    ax.add_collection3d(Poly3DCollection(q[tris], facecolor="#7fb3e6", edgecolor="#1f3a5f", linewidths=0.1, alpha=0.85))
    rim = q[A["rim"] + [A["rim"][0]]]; ax.plot(rim[:, 0], rim[:, 1], rim[:, 2], color="#d69e2e", lw=2.2)
    fan = [[q[A["vtx"]], q[A["rim"][i]], q[A["rim"][(i + 1) % 8]]] for i in range(8)]; ax.add_collection3d(Poly3DCollection(fan, facecolor="#f6e05e", alpha=0.5, edgecolor="none"))
    for key, col, lw in (("head_lines", "#334155", 0.6), ("axle_lines", "#dd6b20", 1.2), ("muscles", "#b91c1c", 1.4), ("fine_rods", "#15803d", 1.6), ("fine_cols", "#b45309", 1.6)):
        if A.get(key): ax.add_collection3d(Line3DCollection(np.array([[q[a], q[b]] for a, b in A[key]]), colors=col, linewidths=lw))
    for ti in A.get("tanks", []): ax.scatter(*q[ti], color="#2b6cb0", s=20 + 120*l["tank"]/91)
    Fp = q[A["F"]]; ax.scatter(*Fp, color="#7c3aed", s=30); ax.scatter(*l["tgt"], facecolors="none", edgecolors="#d9480f", s=80, linewidths=1.5)
    d = (Fp - np.array(l["tgt"])); d /= np.linalg.norm(d); v = q[A["vtx"]]; ax.plot(*np.stack([v + 2.5*d, v + 7*d]).T, color="#0e7490", ls="--", lw=1)
    ax.set_title(f"t {l['t']:.1f} s  {phase(l)}  sun {l['hour']:.1f} h  axis {l['z_axis'] + A['z_offset']:.2f} m  vertex error {l['err']:.2f} m  coarse {l.get('coarse', l['point']):.1f} deg  dish {l['point']*17.45:.2f} mrad", fontsize=7.5 if small else 8.5)
    ax.view_init(elev=20, azim=-140); ax.set_axis_off()
fig = plt.figure(figsize=(7.2, 5.6), dpi=90); ax = fig.add_subplot(111, projection="3d"); frames = []
step = max(1, int(round(0.5/A["dt"])))
for fr in range(0, A["n_frames"], step):
    draw(ax, fr); fig.canvas.draw(); frames.append(np.asarray(fig.canvas.buffer_rgba())[:, :, :3].copy())
imageio.mimsave(os.path.join(OUT, "setup.gif"), frames, duration=0.12, loop=0); print("gif", len(frames), "frames", os.path.getsize(os.path.join(OUT, "setup.gif"))//1024, "KB")
fig2 = plt.figure(figsize=(14, 9), dpi=100); picks = np.linspace(0, A["n_frames"] - 1, 6).astype(int)
for k, fr in enumerate(picks): draw(fig2.add_subplot(2, 3, k + 1, projection="3d"), fr, small=True)
fig2.suptitle("The inflatable fork sets itself up and tracks: Warp XPBD membranes with volume constraints, growth, water, pneumatic muscles; equinox 8-16 h compressed", fontsize=11)
fig2.tight_layout(); fig2.savefig(os.path.join(OUT, "setup_sheet.png")); print("sheet written")

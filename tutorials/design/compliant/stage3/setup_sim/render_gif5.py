#!/usr/bin/env python
"""Film and sheet of the fifth-pass simulation (setup_sim5.py): the hexapod flower rising from its stow, the calibration dither, the day.
Lines only: legs, rim, receptacle ring, the pipe, F, the sun line; the label carries the phase, wind, miss at F and leg forces."""
import os, sys, json, zlib, base64, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt, imageio.v2 as imageio
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); TAG = sys.argv[1] if len(sys.argv) > 1 else "setup5"
A = json.load(open(os.path.join(OUT, TAG + "_anim.json"))); L = A["log"]
Q = np.frombuffer(zlib.decompress(base64.b64decode(A["blob"])), np.int16).reshape(A["n_frames"], A["n_particles"], 3)*A["scale"]
T_S, T_C = A["t_setup"], A["t_cal"]; F = Q[0][A["F"]]
def draw(ax, k, lab=True):
    q = Q[k]; l = L[k]
    ax.cla(); ax.set_xlim(-2, 6); ax.set_ylim(-4, 4); ax.set_zlim(0, 6); ax.set_box_aspect((8, 8, 6)); ax.view_init(elev=22, azim=-135); ax.set_axis_off()
    xx, yy = np.meshgrid([-2, 6], [-4, 4]); ax.plot_surface(xx, yy, np.zeros_like(xx), color="#d9dde3", alpha=0.35)
    th = np.linspace(0, 2*np.pi, 40); pc, pr = A["pipe"]["c"], A["pipe"]["r"]
    for z in (0.0, A["pipe"]["z_top"]): ax.plot(pc[0] + pr*np.cos(th), pc[1] + pr*np.sin(th), z, color="#1f2937", lw=1)
    for a in (0, np.pi/2, np.pi, 3*np.pi/2): ax.plot([pc[0] + pr*np.cos(a)]*2, [pc[1] + pr*np.sin(a)]*2, [0, A["pipe"]["z_top"]], color="#1f2937", lw=0.8)
    st = A["stem_top"]; ax.plot([st[0]]*2, [st[1]]*2, [0, st[2]], color="#5b3a12", lw=4)                       # the stem
    B = q[A["base"]]; Cb = B.mean(0); ax.plot(*zip(st, Cb), color="#5b3a12", lw=3)                            # the pedicel's boom to the receptacle
    ring = np.vstack([B, B[:1]]); ax.plot(ring[:, 0], ring[:, 1], ring[:, 2], color="#5b3a12", lw=2)         # the receptacle ring on the pedicel
    ax.scatter(*F, color="#7c3aed", s=40)
    for a_, b_ in A["legs"]: ax.plot(*zip(q[a_], q[b_]), color="#7c4a1e", lw=2.5)
    rim = q[A["rim"] + [A["rim"][0]]]; ax.plot(rim[:, 0], rim[:, 1], rim[:, 2], color="#9aa5b1", lw=2)
    for i in range(0, 8, 2): ax.plot(*zip(q[A["rim"][i]], F), color="#d9480f", lw=0.6, alpha=0.7)
    v = q[A["vtx"]]; nrm = np.array(l["n"]); ax.plot(*zip(v, v + 3*nrm), color="#0e7490", lw=1.2)
    if lab:
        ph = "setup: pumping the six struts" if l["t"] < T_S else ("calibration dither (identification)" if l["t"] < T_S + T_C else "tracking the sun")
        ax.text2D(0.02, 0.96, f"t {l['t']:.1f} s  {ph}  sun {l['hour']:.1f} h  wind {l['wind']:.1f} m/s\nmiss at F {l['miss_cm']:.1f} cm (half power 4.9)  beta {l['beta']:.0f} deg  legs {min(l['legs_m']):.2f}-{max(l['legs_m']):.2f} m  |f| max {max(abs(f_) for f_ in l['f_leg_kN']):.1f} kN", transform=ax.transAxes, fontsize=9, va="top")
fig = plt.figure(figsize=(5.6, 4.5), dpi=90); ax = fig.add_subplot(111, projection="3d"); frames = []
for k in range(0, len(L), max(1, len(L)//70)):
    draw(ax, k); fig.canvas.draw(); frames.append(np.asarray(fig.canvas.buffer_rgba())[:, :, :3].copy())
imageio.mimsave(os.path.join(OUT, TAG + ".gif"), frames, duration=0.16, loop=0, palettesize=48); print("gif", len(frames), "frames", os.path.getsize(os.path.join(OUT, TAG + ".gif"))//1024, "KB")
fig2 = plt.figure(figsize=(14, 9)); ts = [l["t"] for l in L]
picks = [0, next(i for i, l in enumerate(L) if l["t"] >= 0.5*T_S), next(i for i, l in enumerate(L) if l["t"] >= T_S), next(i for i, l in enumerate(L) if l["t"] >= T_S + T_C), next(i for i, l in enumerate(L) if l["t"] >= T_S + T_C + 0.5*A["t_day"]), len(L) - 1]
for j, k in enumerate(picks):
    axj = fig2.add_subplot(2, 3, j + 1, projection="3d"); draw(axj, k, lab=False); axj.set_title(f"t {L[k]['t']:.0f} s, sun {L[k]['hour']:.1f} h, miss {L[k]['miss_cm']:.1f} cm", fontsize=9)
fig2.suptitle(f"The flower sets itself up and tracks: six struts pumped from the stow, a calibration dither, the day at {A['wind']} m/s mean wind with gusts", fontsize=11)
fig2.tight_layout(); fig2.savefig(os.path.join(OUT, TAG + "_sheet.png"), dpi=110); print("sheet written")

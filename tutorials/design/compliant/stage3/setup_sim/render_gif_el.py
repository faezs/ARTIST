#!/usr/bin/env python
"""Film and sheet of the Cosserat-rod flower (flower_elastica.py): stem, telescoping boom, receptacle ring, six struts, the head's rim, the pipe, F.
Rods are drawn as their node polylines (the JSON carries every node of every rod per frame), the rings from the strut ends and the head's pose."""
import os, sys, json, numpy as np, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt, imageio.v2 as imageio
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); TAG = sys.argv[1] if len(sys.argv) > 1 else "flower"
A = json.load(open(os.path.join(OUT, TAG + "_anim.json"))); L = A["log"]; FR = A["frames"]; NR = A["n_rods"]
T_S, T_C = A["t_setup"], A["t_cal"]; F = np.array(A["F"]); ST = np.array(A["stem_top"]); PIPE_R = 0.42
def basis(n):
    n = n/np.linalg.norm(n); ref = np.array([-1.0, 0, 0]); x = ref - n*(ref@n)
    if np.linalg.norm(x) < 1e-6: x = np.array([0, 1.0, 0]) - n*n[1]
    x /= np.linalg.norm(x); return x, np.cross(n, x)
def ring(c, n, r, k=48):
    x, y = basis(n); th = np.linspace(0, 2*np.pi, k); return np.array([c + r*(np.cos(t)*x + np.sin(t)*y) for t in th])
def draw(ax, k, lab=True):
    fr = FR[k]; l = L[k]; rods = [np.array(r) for r in fr[:NR]]; P, tip = np.array(fr[NR][0]), np.array(fr[NR][1]); nrm = (tip - P)/2.0; C_rec = np.array(fr[NR + 1][0])
    ax.cla(); ax.set_xlim(-2, 6); ax.set_ylim(-4, 4); ax.set_zlim(0, 6); ax.set_box_aspect((8, 8, 6)); ax.view_init(elev=22, azim=-135); ax.set_axis_off()
    xx, yy = np.meshgrid([-2, 6], [-4, 4]); ax.plot_surface(xx, yy, np.zeros_like(xx), color="#d9dde3", alpha=0.35)
    th = np.linspace(0, 2*np.pi, 40)
    for z in (0.0, F[2]): ax.plot(PIPE_R*np.cos(th), PIPE_R*np.sin(th), z, color="#1f2937", lw=1)
    for a in (0, np.pi/2, np.pi, 3*np.pi/2): ax.plot([PIPE_R*np.cos(a)]*2, [PIPE_R*np.sin(a)]*2, [0, F[2]], color="#1f2937", lw=0.8)
    ax.plot(rods[0][:, 0], rods[0][:, 1], rods[0][:, 2], color="#5b3a12", lw=4)                                   # the stem
    ax.plot(rods[1][:, 0], rods[1][:, 1], rods[1][:, 2], color="#5b3a12", lw=3)                                   # the pedicel's boom
    base = np.array([r[0] for r in rods[2:8]]); plat = np.array([r[-1] for r in rods[2:8]])
    nb = np.cross(base[1] - base[0], base[3] - base[0]); nb /= np.linalg.norm(nb)
    rg = ring(C_rec, nb, 1.5); ax.plot(rg[:, 0], rg[:, 1], rg[:, 2], color="#5b3a12", lw=2)                        # the receptacle ring
    pr = np.vstack([plat, plat[:1]]); ax.plot(pr[:, 0], pr[:, 1], pr[:, 2], color="#7c4a1e", lw=1.2)                # the platform ring through the strut heads
    for r in rods[2:8]: ax.plot(r[:, 0], r[:, 1], r[:, 2], color="#7c4a1e", lw=2.5)                                # the struts
    rim = ring(P, nrm, 2.1); ax.plot(rim[:, 0], rim[:, 1], rim[:, 2], color="#9aa5b1", lw=2)                        # the head's rim
    for i in range(0, 48, 12): ax.plot(*zip(rim[i], F), color="#d9480f", lw=0.6, alpha=0.7)                       # the beam to F
    ax.scatter(*F, color="#7c3aed", s=40); ax.plot(*zip(P, P + 3*nrm), color="#0e7490", lw=1.2)
    if lab:
        ph = "setup: the pedicel rises, the struts pump" if l["t"] < T_S else ("calibration dither (identification)" if l["t"] < T_S + T_C else "tracking the sun")
        ax.text2D(0.02, 0.96, f"t {l['t']:.1f} s  {ph}  sun {l['hour']:.1f} h  wind {l['wind']:.1f} m/s\nmiss at F {l['miss_cm']:.1f} cm (+membrane {l['miss_mem_cm']:.1f} -> {l['miss_tot_cm']:.1f}; half power 4.9)  receptacle off {l['rec_err_cm']:.1f} cm  legs {min(l['legs_m']):.2f}-{max(l['legs_m']):.2f} m  forces {min(l['f_leg_kN']):.1f}..{max(l['f_leg_kN']):.1f} kN", transform=ax.transAxes, fontsize=7, va="top")
fig = plt.figure(figsize=(5.6, 4.5), dpi=90); ax = fig.add_subplot(111, projection="3d"); frames = []
for k in range(0, len(L), max(1, len(L)//70)):
    draw(ax, k); fig.canvas.draw(); frames.append(np.asarray(fig.canvas.buffer_rgba())[:, :, :3].copy())
imageio.mimsave(os.path.join(OUT, TAG + ".gif"), frames, duration=0.16, loop=0, palettesize=48); print("gif", len(frames), "frames", os.path.getsize(os.path.join(OUT, TAG + ".gif"))//1024, "KB")
fig2 = plt.figure(figsize=(14, 9))
def first(cond): return next((i for i, l in enumerate(L) if cond(l)), len(L) - 1)
picks = [0, first(lambda l: l["t"] >= 0.5*T_S), first(lambda l: l["t"] >= T_S), first(lambda l: l["t"] >= T_S + T_C), first(lambda l: l["t"] >= T_S + T_C + 0.5*A["t_day"]), len(L) - 1]
for j, k in enumerate(picks):
    axj = fig2.add_subplot(2, 3, j + 1, projection="3d"); draw(axj, k, lab=False); axj.set_title(f"t {L[k]['t']:.0f} s, sun {L[k]['hour']:.1f} h, wind {L[k]['wind']:.0f} m/s, miss {L[k]['miss_tot_cm']:.1f} cm", fontsize=9)
fig2.suptitle(f"The flower as Cosserat rods (PyElastica): 1 m stem, telescoping boom with two servos, rigid receptacle ring, six steel struts, rigid head\nsetup, calibration dither, the day at {A['wind']} m/s mean wind with von Karman gusts", fontsize=11)
fig2.tight_layout(); fig2.savefig(os.path.join(OUT, TAG + "_sheet.png"), dpi=110); print("sheet written")

#!/usr/bin/env python
"""Koopman model of the erected machine's tracking dynamics from the simulation log (pykoopman, Pan/Kutz/Brunton;
the method of Bruder et al. 2019/2021 for soft robots): lift the head state, fit a linear model x_{k+1} = A x_k + B u_k
with DMDc and with EDMDc on polynomial observables, report one-step and rolled-out prediction errors. The point: the
inflated fork with its muscles and swaying posts is a nonlinear plant whose relevant dynamics are few and slow, so a
lifted linear model is enough for a linear MPC to replace the hand-tuned loops in setup_sim.py."""
import os, json, numpy as np, pykoopman as pk
from pykoopman.regression import DMDc, EDMDc
from pykoopman.observables import Polynomial, Identity
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out")
A = json.load(open(os.path.join(OUT, "setup_anim.json"))); L = [l for l in A["log"] if l["t"] >= A["t_setup"]]
X = np.array([l["vtx"] + [l["z_axis"], l["point"]] for l in L]); U = np.array([[np.radians(l["el_t"]), l["hour"]] for l in L])
dt = A["dt"]; n = len(X); n_tr = int(0.7*n)
def rollout(model, x0, U):
    xs = [x0]
    for k in range(len(U) - 1):
        try: xn = model.predict(xs[-1].reshape(1, -1), U[k].reshape(1, -1)).ravel()
        except Exception: break
        if not np.all(np.isfinite(xn)) or np.abs(xn).max() > 1e3: break               # a diverging roll-out is reported as such
        xs.append(xn)
    return np.array(xs)
out = []
for name, obs in (("DMDc (identity)", Identity()), ("EDMDc (poly deg 2)", Polynomial(degree=2))):
    reg = DMDc(svd_rank=X.shape[1] + U.shape[1]) if name.startswith("DMDc") else EDMDc()
    model = pk.Koopman(observables=obs, regressor=reg); model.fit(X[:n_tr], u=U[:n_tr - 1] if False else U[:n_tr], dt=dt)
    one = model.predict(X[n_tr:-1], U[n_tr:-1]); e1 = np.sqrt(np.mean((one - X[n_tr + 1:])**2, axis=0))
    ro = rollout(model, X[n_tr], U[n_tr:]); m_ = len(ro); er = np.sqrt(np.mean((ro - X[n_tr:n_tr + m_])**2, axis=0))
    tail = f"{m_*dt:.0f} s roll-out RMS vertex {np.linalg.norm(er[:3])*100:.1f} cm, pointing {er[4]:.2f} deg" + ("" if m_ == n - n_tr else f" (diverged after {m_*dt:.0f} s)")
    out.append(f"{name}: train {n_tr} steps, test {n - n_tr}; one-step RMS error vertex {np.linalg.norm(e1[:3])*100:.1f} cm, axis {e1[3]*100:.1f} cm, pointing {e1[4]:.2f} deg; " + tail)
out.append(f"state: vertex xyz, axis height, pointing error; inputs: elevation command, sun hour (azimuth); dt {dt:.2f} s; data from the tracking phase of the simulation")
print("\n".join(out)); open(os.path.join(OUT, "koopman.txt"), "w").write("\n".join(out))

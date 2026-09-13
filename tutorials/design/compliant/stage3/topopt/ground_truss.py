#!/usr/bin/env python
"""Ground-structure topology optimization (Handbook of Compliant Mechanisms ch. 7, Frecker, sec. 7.3, Fig. 7.2 and 7.5):
a dense truss ground structure, the members' cross-sectional areas as design variables between a near-zero lower limit and
an upper limit, a volume-fraction constraint, and either minimum compliance (the stiff structure, Fig. 7.2) or the
compliant-mechanism objective (maximum output displacement against an output spring, Eq. 7.5, the formulation of Fig. 7.7)
solved by MMA (sec. 7.6). Members below 5 % of the cap are treated as void in the picture and the count; the rest are drawn in grey scale of area as in Fig. 7.5d.

Validation against the chapter: the displacement inverter of Fig. 7.3a (mirrored; the diamond) and a pliers-like half problem after Fig. 7.5.
Application to the flower: the calyx (the truss behind the membrane between its rim and the six platform anchors) under the
dish's peak wind load and its own weight, and the receptacle ring between the six strut anchors and the boom's wrist, both
as minimum-compliance structures (they are stiffness parts, not mechanisms)."""
import os, sys, json, numpy as np, scipy.sparse as sp, scipy.sparse.linalg as spla, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from mma1 import MMA1
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
class Truss:
    def __init__(self, nodes, members, E=1.0):
        self.X = np.asarray(nodes, float); self.M = np.asarray(members, int); self.E = E; self.dim = self.X.shape[1]
        d = self.X[self.M[:, 1]] - self.X[self.M[:, 0]]; self.L = np.linalg.norm(d, axis=1); self.dir = d/self.L[:, None]
        self.nd = self.dim*len(self.X); self.fixed = np.zeros(self.nd, bool); self.springs = {}
    def dofs(self, e):
        i, j = self.M[e]; return np.concatenate([self.dim*i + np.arange(self.dim), self.dim*j + np.arange(self.dim)])
    def fix(self, node, comps=None):
        for c in (range(self.dim) if comps is None else comps): self.fixed[self.dim*node + c] = True
    def spring(self, node, comp, k): self.springs[self.dim*node + comp] = self.springs.get(self.dim*node + comp, 0.0) + k
    def stiffness(self, A):
        rows, cols, vals = [], [], []
        for e in range(len(self.M)):
            b = np.concatenate([-self.dir[e], self.dir[e]]); ke = (self.E*A[e]/self.L[e])*np.outer(b, b); d = self.dofs(e)
            rows.append(np.repeat(d, 2*self.dim)); cols.append(np.tile(d, 2*self.dim)); vals.append(ke.ravel())
        K = sp.coo_matrix((np.concatenate(vals), (np.concatenate(rows), np.concatenate(cols))), shape=(self.nd, self.nd)).tocsc()
        if self.springs:
            idx = np.array(list(self.springs)); K = K + sp.coo_matrix((np.array([self.springs[i] for i in idx]), (idx, idx)), shape=(self.nd, self.nd)).tocsc()
        K = K + sp.identity(self.nd, format="csc")*(1e-9*self.E*A.max()/self.L.min())      # a whisper of grounding: nodes left with collinear members only would be mechanisms
        return K
    def solve(self, K, f):
        free = ~self.fixed; u = np.zeros(self.nd); u[free] = spla.spsolve(K[free][:, free], f[free]); return u
    def elong(self, u):
        return np.array([np.concatenate([-self.dir[e], self.dir[e]])@u[self.dofs(e)] for e in range(len(self.M))])
def ground(nodes, lmax, dim):
    X = np.asarray(nodes, float); mem = []
    for i in range(len(X)):
        for j in range(i + 1, len(X)):
            if np.linalg.norm(X[j] - X[i]) <= lmax + 1e-9: mem.append((i, j))
    return np.array(mem)
def optimise(tr, f, objective, vol_frac, amax, out_dof=None, iters=150, amin_rel=1e-4, verbose=False, tag="", out_sign=1.0):
    """objective 'compliance': minimise f.u; 'mechanism': maximise u[out_dof] (Eq. 7.5, springs already on the truss)"""
    n = len(tr.M); amin = amin_rel*amax; A = np.full(n, vol_frac*amax); V = vol_frac*np.sum(amax*tr.L)
    mma = MMA1(n, amin, amax, move=0.3); hist = []
    for it in range(iters):
        K = tr.stiffness(A); u = tr.solve(K, f); dl = tr.elong(u)
        if objective == "compliance":
            obj = float(f@u); dobj = -tr.E*dl**2/tr.L
        else:
            lvec = np.zeros(tr.nd); lvec[out_dof] = out_sign; lam = tr.solve(K, lvec); dlam = tr.elong(lam)
            obj = -out_sign*float(u[out_dof]); dobj = tr.E*dl*dlam/tr.L                                # d(-u_out)/dA = lam^T dK/dA u
        g = float(np.sum(A*tr.L)/V - 1.0); dg = tr.L/V
        if not np.isfinite(obj) or not np.isfinite(dobj).all(): raise RuntimeError(f"[{tag}] non-finite at it {it}: check supports")
        A_new = mma.update(A, dobj, g, dg); ch = float(np.abs(A_new - A).max()/amax); A = A_new; hist.append(obj)
        if verbose and (it % 20 == 0 or it == iters - 1): print(f"  [{tag}] it {it:3d} obj {obj:+.5g} vol {g + 1:.3f} change {ch:.4f}")
        if it > 30 and ch < 1e-4: break
    K = tr.stiffness(A); u = tr.solve(K, f); return A, u, hist
KEEP = 0.05                                                                                    # one threshold for the picture and the count: members above 5 % of the cap
def draw(ax, tr, A, amax, u=None, scale=0.0, title="", loads=None, supports=None, keep=KEEP, proj=(0, 1)):
    """2-D: as is; 3-D: a projection onto the axes `proj` (plan (0, 1) or elevation (0, 2)), width = area, darkness = area"""
    amax_e = A.max(); P = lambda v: (v[proj[0]], v[proj[1]])
    for e in np.argsort(A):
        if A[e] < keep*amax: continue
        i, j = tr.M[e]; p, q = tr.X[i], tr.X[j]
        if u is not None and scale: p = p + scale*u[tr.dim*i: tr.dim*i + tr.dim]; q = q + scale*u[tr.dim*j: tr.dim*j + tr.dim]
        g = 0.85*(1 - A[e]/amax_e); lw = 0.5 + 4.5*A[e]/amax_e
        (px, py), (qx, qy) = (p, q) if tr.dim == 2 else (P(p), P(q)); ax.plot([px, qx], [py, qy], color=(g, g, g), lw=lw, solid_capstyle="round")
    if loads is not None:
        for node, vec in loads:
            p = tr.X[node]; v = np.asarray(vec, float); v = 0.15*np.ptp(tr.X, axis=0).max()*v/np.linalg.norm(v)
            ax.annotate("", xy=p + v, xytext=p, arrowprops=dict(arrowstyle="->", color="#d9480f", lw=1.5))
    if supports is not None:
        S = tr.X[list(supports)]
        if tr.dim == 2: ax.plot(S[:, 0], S[:, 1], "^", color="#0e7490", ms=7)
        else: ax.plot(S[:, proj[0]], S[:, proj[1]], "o", color="#0e7490", ms=7, zorder=5)
    ax.set_title(title, fontsize=9); ax.set_aspect("equal")
    if tr.dim == 2: ax.set_axis_off()
    else: ax.set_xlabel("xyz"[proj[0]] + " (m)"); ax.set_ylabel("xyz"[proj[1]] + " (m)")
# ------------------------------------------------------------------------------------------------------ chapter validations
def grid2d(nx, ny, w, h):
    X = np.array([[w*i/nx, h*j/ny] for j in range(ny + 1) for i in range(nx + 1)]); idx = lambda i, j: j*(nx + 1) + i; return X, idx
def case_inverter():
    """Fig. 7.3a's problem, mirrored: supports at the two left corners, the actuator at the right middle pushing INTO the domain
    (to the left), the output at the left middle asked to move to the right, i.e. opposite to the input (the displacement
    inverter); input and output springs as in Fig. 7.7. Mirroring the drawing changes nothing by linearity."""
    nx, ny = 6, 6; X, idx = grid2d(nx, ny, 1.0, 1.0); M = ground(X, 1.0/nx*np.sqrt(2) + 1e-6, 2); tr = Truss(X, M, E=1.0)
    tr.fix(idx(0, 0)); tr.fix(idx(0, ny)); n_in, n_out = idx(nx, ny//2), idx(0, ny//2)
    tr.spring(n_in, 0, 1.0); tr.spring(n_out, 0, 1.0)
    f = np.zeros(tr.nd); f[2*n_in] = -1.0                                  # F pushes the right middle toward the left (into the domain)
    A, u, hist = optimise(tr, f, "mechanism", 0.2, 1.0, out_dof=2*n_out, iters=200, tag="inverter")
    return tr, A, u, f, dict(loads=[(n_in, (-1, 0))], supports=[idx(0, 0), idx(0, ny)], out=n_out, u_out=float(u[2*n_out]), u_in=float(u[2*n_in]))
def case_pliers():
    """a pliers-like half-symmetry problem after Fig. 7.5 (its proportions are not matched cell for cell): the handle's load F at
    the top left pointing down, the jaw's output at the right pointing down toward the other jaw across the symmetry line,
    the symmetry line's supports under the step"""
    w, h, step = 10.0, 4.0, 2.0; X = []
    for j in range(5):
        for i in range(11):
            x, y = i*w/10, j*h/4
            if y < step - 1e-9 and (x < 3.0 - 1e-9 or x > 6.0 + 1e-9): continue        # the notch under the pliers (Fig. 7.5a)
            X.append([x, y])
    X = np.array(X); M = ground(X, 1.0*np.sqrt(2)*1.05, 2); tr = Truss(X, M, E=1.0)
    node = lambda x, y: int(np.argmin(np.linalg.norm(X - np.array([x, y]), axis=1)))
    for x in (3.0, 4.0, 5.0, 6.0): tr.fix(node(x, 0.0))                           # the symmetry line under the pivot region (Fig. 7.5a pins)
    n_in, n_out = node(0.0, 4.0), node(10.0, 2.0)
    tr.spring(n_in, 1, 1.0); tr.spring(n_out, 1, 0.5)
    f = np.zeros(tr.nd); f[2*n_in + 1] = -1.0
    A, u, hist = optimise(tr, f, "mechanism", 0.15, 1.0, out_dof=2*n_out + 1, iters=200, tag="pliers", out_sign=-1.0)
    return tr, A, u, f, dict(loads=[(n_in, (0, -1))], supports=[node(x, 0.0) for x in (3.0, 4.0, 5.0, 6.0)], out=n_out, u_out=float(u[2*n_out + 1]), u_in=float(u[2*n_in + 1]))
# ------------------------------------------------------------------------------------------------------ the flower's parts
E_AL, RHO_AL, SIG_AL = 69e9, 2700.0, 150e6
PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285]); BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255])
def ring(r, z, n, phase=0.0): return [[r*np.cos(2*np.pi*k/n + phase), r*np.sin(2*np.pi*k/n + phase), z] for k in range(n)]
def case_calyx(V_peak=15.0, vol_frac=0.12, amax=6e-4):
    """the calyx: the truss between the membrane's rim (r 2.1, 24 nodes) and the six platform anchors (r 1.0, 0.6 m behind
    the vertex) through a middle ring; loads: the dish's peak drag (37.63 N per (m/s)^2) and hinge moment (10.07 N m per
    (m/s)^2), the audit's constants with its load factor 3, as forces on the rim nodes, plus the head's weight (130 kg, the
    lumped head of the simulations, not the ~1 kg film);
    supports: the six anchors pinned (the struts). Minimum compliance at a volume fraction: Fig. 7.2's problem in 3-D."""
    rim = ring(2.1, 0.0, 24); mid = ring(1.55, -0.30, 12, np.pi/12); mid2 = ring(1.1, -0.15, 12); plat = [[np.cos(a), np.sin(a), -0.6] for a in PLAT_ANG]
    hub = ring(0.45, -0.45, 6, np.pi/6) + [[0.0, 0.0, -0.6]]
    X = np.array(rim + mid + mid2 + plat + hub); M = ground(X, 1.35, 3); tr = Truss(X, M, E=E_AL)
    n_rim, n_plat0 = 24, 24 + 12 + 12
    for k in range(6): tr.fix(n_plat0 + k)
    F_d = 37.63*V_peak**2; Mp = 10.07*V_peak**2; W = 130*9.81                     # the audit's peak constants (a load factor 3 on the mean q in both), the head's weight
    f = np.zeros(tr.nd); sum_y2 = float(np.sum(X[:n_rim, 1]**2))
    for k in range(n_rim):
        x, y, z = X[k]; f[3*k + 2] += -(F_d + W)/n_rim + Mp*y/sum_y2                  # drag and weight along -z, the pitching moment as +-z on the rim (sum f y = Mp)
    A, u, hist = optimise(tr, f, "compliance", vol_frac, amax, iters=120, tag="calyx")
    dl = tr.elong(u); force = E_AL*A*dl/tr.L; mass = float(np.sum(RHO_AL*A*tr.L)); kept = A > KEEP*amax
    stress = np.abs(force[kept]/A[kept]).max(); rim_z = u[2:3*n_rim:3]; tilt = float((rim_z.max() - rim_z.min())/4.2)
    return tr, A, u, f, dict(supports=list(range(n_plat0, n_plat0 + 6)), mass=mass, n_members=int(kept.sum()), max_stress=float(stress), rim_tilt_mrad=1e3*tilt, F_d=F_d, Mp=Mp)
def case_receptacle(vol_frac=0.15, amax=6e-4):
    """the receptacle ring: the six strut anchors (r 1.5) tied to the boom's wrist (a rigid hub of four nodes at r 0.12);
    loads: alternating +-3.5 kN along the strut directions (the quasi-static 12 m/s peak-wind leg force) and the head's
    weight share on each strut (130 kg over six legs); supports: the hub. Minimum compliance."""
    base = [[1.5*np.cos(a), 1.5*np.sin(a), 0.0] for a in BASE_ANG]; outer = ring(1.5, 0.0, 12, 0.0); inner = ring(0.9, 0.0, 12); inner2 = ring(0.9, -0.25, 6, np.pi/6)     # outer-ring nodes at 0, 30, 60 deg: none coincides with an anchor (zero-length members); inner2 = ring(0.9, -0.25, 6, np.pi/6)
    hubn = ring(0.12, -0.1, 3) + [[0.0, 0.0, -0.1]]
    X = np.array(base + outer + inner + inner2 + hubn); M = ground(X, 1.05, 3); tr = Truss(X, M, E=E_AL)
    n_hub0 = len(X) - 4
    for k in range(4): tr.fix(n_hub0 + k)
    plat = np.array([[np.cos(a), np.sin(a), 1.2] for a in PLAT_ANG]); f = np.zeros(tr.nd)
    for k in range(6):
        d = plat[k] - X[k]; d /= np.linalg.norm(d); Fk = 3.5e3*(1 if k % 2 == 0 else -1) - 130*9.81/6/abs(d[2]); f[3*k: 3*k + 3] += Fk*d      # alternating 3.5 kN and the head's weight share per strut
    A, u, hist = optimise(tr, f, "compliance", vol_frac, amax, iters=120, tag="receptacle")
    dl = tr.elong(u); force = E_AL*A*dl/tr.L; mass = float(np.sum(RHO_AL*A*tr.L)); kept = A > KEEP*amax
    stress = np.abs(force[kept]/A[kept]).max() if kept.any() else float("nan"); anchor_disp = float(np.linalg.norm(u[:18].reshape(6, 3), axis=1).max())
    return tr, A, u, f, dict(supports=list(range(n_hub0, n_hub0 + 4)), mass=mass, n_members=int(kept.sum()), max_stress=float(stress), anchor_disp_mm=1e3*anchor_disp)
if __name__ == "__main__":
    rep = {}
    fig = plt.figure(figsize=(14, 9))
    tr, A, u, f, info = case_inverter(); rep["inverter"] = {k: v for k, v in info.items() if k in ("u_out", "u_in")}
    ax = fig.add_subplot(2, 3, 1); draw(ax, tr, A, 1.0, title=f"Fig. 7.3a: displacement inverter, ground structure\nu_out {info['u_out']:+.3f} for u_in {info['u_in']:+.3f}", loads=info["loads"], supports=info["supports"])
    ax = fig.add_subplot(2, 3, 4); draw(ax, tr, A, 1.0, u=u, scale=0.5, title="deformed (x0.5)", loads=info["loads"], supports=info["supports"])
    tr, A, u, f, info = case_pliers(); rep["pliers"] = {k: v for k, v in info.items() if k in ("u_out", "u_in")}
    ax = fig.add_subplot(2, 3, 2); draw(ax, tr, A, 1.0, title=f"after Fig. 7.5: pliers-like half problem, ground structure\njaw u_out {info['u_out']:+.3f} for handle u_in {info['u_in']:+.3f}", loads=info["loads"], supports=info["supports"])
    ax = fig.add_subplot(2, 3, 5); draw(ax, tr, A, 1.0, u=u, scale=0.5, title="deformed (x0.5)", loads=info["loads"], supports=info["supports"])
    tr, A, u, f, info = case_calyx(); rep["calyx"] = {k: v for k, v in info.items() if k != "supports"}
    ax = fig.add_subplot(2, 3, 3); draw(ax, tr, A, 6e-4, title=f"the calyx in plan: rim (r 2.1) to the six anchors (blue, r 1.0), 15 m/s peak\n{info['n_members']} members above 5 %, {info['mass']:.0f} kg Al asked, rim tilt {info['rim_tilt_mrad']:.2f} mrad", supports=info["supports"], proj=(0, 1))
    th_ = np.linspace(0, 2*np.pi, 100); ax.plot(2.1*np.cos(th_), 2.1*np.sin(th_), color="#9aa5b1", lw=0.8, ls="--")
    tr, A, u, f, info = case_receptacle(); rep["receptacle"] = {k: v for k, v in info.items() if k != "supports"}
    ax = fig.add_subplot(2, 3, 6); draw(ax, tr, A, 6e-4, title=f"the receptacle in plan: the six strut anchors (r 1.5, +-3.5 kN alternating) to the wrist (blue, centre)\n{info['n_members']} members above 5 %, {info['mass']:.0f} kg Al asked, anchor moves {info['anchor_disp_mm']:.1f} mm", supports=info["supports"], proj=(0, 1))
    for k in range(6): ax.plot(tr.X[k, 0], tr.X[k, 1], "s", color="#d9480f", ms=6)
    fig.suptitle("Chapter 7 by ground structure (Frecker): the book's two examples, then the flower's calyx and receptacle as minimum-compliance trusses", fontsize=11)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, "ground_truss.png"), dpi=110); json.dump(rep, open(os.path.join(OUT, "ground_truss.json"), "w"), indent=1); print(json.dumps(rep, indent=1))

#!/usr/bin/env python
"""SIMP topology optimization of compliant mechanisms (Handbook of Compliant Mechanisms ch. 7, Frecker, sec. 7.4.1, Eq. 7.3-7.5,
Fig. 7.7-7.9): a rectangular domain of bilinear plane-stress elements, relative densities as design variables with penalty p,
a density filter (Bruns and Tortorelli 2001, Bourdin 2001, as in the 88-line code the chapter cites as ref. 12; the chapter itself
lists mesh dependence as an open limitation, p. 105, and cites Sigmund's robust formulation, refs 14-16, for one-node hinges,
p. 102-103), input and output springs (Fig. 7.7, Sigmund 1997, the chapter's ref. 6), the objective 'maximise the output
displacement' (Eq. 7.5) solved by MMA (sec. 7.6).

Validation: the displacement inverter as posed in Fig. 7.3a, mirrored (input at the left middle pushing right, output at the right
middle asked to move left, the two left corners fixed). Fig. 7.8's applet places its output spring at the left edge and its
actuator at an interior point, which this does not reproduce cell for cell; the topology is the same inverter. The flower's head is not a plate at all: a Mylar film on a ring (ring_calyx.py: ring as frame elements, spider by ground structure,
the film's loads from the repo's FvK solvers; membrane_wind.py: the film's figure under wind)."""
import os, sys, json, numpy as np, scipy.sparse as sp, scipy.sparse.linalg as spla, matplotlib
matplotlib.use("Agg"); import matplotlib.pyplot as plt
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from mma1 import MMA1
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
def ke_q4(nu=0.3):
    k = np.array([1/2 - nu/6, 1/8 + nu/8, -1/4 - nu/12, -1/8 + 3*nu/8, -1/4 + nu/12, -1/8 - nu/8, nu/6, 1/8 - 3*nu/8])
    KE = 1/(1 - nu**2)*np.array([[k[0], k[1], k[2], k[3], k[4], k[5], k[6], k[7]], [k[1], k[0], k[7], k[6], k[5], k[4], k[3], k[2]],
        [k[2], k[7], k[0], k[5], k[6], k[3], k[4], k[1]], [k[3], k[6], k[5], k[0], k[7], k[2], k[1], k[4]], [k[4], k[5], k[6], k[7], k[0], k[1], k[2], k[3]],
        [k[5], k[4], k[3], k[2], k[1], k[0], k[7], k[6]], [k[6], k[3], k[4], k[1], k[2], k[7], k[0], k[5]], [k[7], k[2], k[1], k[4], k[3], k[6], k[5], k[0]]])
    return KE
class Simp:
    def __init__(self, nelx, nely, rmin=1.5, p=3.0, E0=1.0, Emin=1e-9):
        self.nx, self.ny, self.p, self.E0, self.Emin = nelx, nely, p, E0, Emin; self.KE = ke_q4(); n = (nelx + 1)*(nely + 1); self.nd = 2*n
        nodenrs = np.arange(n).reshape(nelx + 1, nely + 1).T                     # column-major like the 88-line code: node (ix, iy)
        el = []
        for ix in range(nelx):
            for iy in range(nely):
                n1 = nodenrs[iy, ix]; n2 = nodenrs[iy, ix + 1]; el.append([2*n1, 2*n1 + 1, 2*n2, 2*n2 + 1, 2*n2 + 2, 2*n2 + 3, 2*n1 + 2, 2*n1 + 3])
        self.edof = np.array(el); self.ne = nelx*nely; self.iK = np.repeat(self.edof, 8, axis=1).ravel(); self.jK = np.tile(self.edof, (1, 8)).ravel()
        # density filter
        ex, ey = np.meshgrid(np.arange(nelx), np.arange(nely), indexing="ij"); ex, ey = ex.ravel(), ey.ravel(); rows, cols, vals = [], [], []
        r = int(np.ceil(rmin)) - 1
        for e in range(self.ne):
            for dx in range(-r, r + 1):
                for dy in range(-r, r + 1):
                    jx, jy = ex[e] + dx, ey[e] + dy
                    if 0 <= jx < nelx and 0 <= jy < nely:
                        w = rmin - np.hypot(dx, dy)
                        if w > 0: rows.append(e); cols.append(jx*nely + jy); vals.append(w)
        H = sp.coo_matrix((vals, (rows, cols)), shape=(self.ne, self.ne)).tocsr(); self.H = H; self.Hs = np.asarray(H.sum(1)).ravel()
        self.fixed = np.zeros(self.nd, bool); self.springs = {}; self.nodenrs = nodenrs
    def node(self, ix, iy): return self.nodenrs[iy, ix]
    def fix(self, ix, iy, comps=(0, 1)):
        for c in comps: self.fixed[2*self.node(ix, iy) + c] = True
    def spring(self, ix, iy, comp, k): d = 2*self.node(ix, iy) + comp; self.springs[d] = self.springs.get(d, 0.0) + k
    def stiffness(self, xphys):
        Ee = self.Emin + xphys**self.p*(self.E0 - self.Emin); sK = (self.KE.ravel()[None, :]*Ee[:, None]).ravel()
        K = sp.coo_matrix((sK, (self.iK, self.jK)), shape=(self.nd, self.nd)).tocsc()
        if self.springs:
            idx = np.array(list(self.springs)); K = K + sp.coo_matrix((np.array([self.springs[i] for i in idx]), (idx, idx)), shape=(self.nd, self.nd)).tocsc()
        return K
    def solve(self, K, f):
        free = ~self.fixed; u = np.zeros(self.nd); u[free] = spla.spsolve(K[free][:, free], f[free]); return u
    def run(self, f, out_dof, vol_frac, iters=150, passive=None, verbose=False, tag="", out_sign=1.0):
        """maximise out_sign * u[out_dof] (Eq. 7.5): out_sign -1 asks for an output opposite to the axis direction, the inverter"""
        x = np.full(self.ne, vol_frac); mma = MMA1(self.ne, 1e-3, 1.0, move=0.2); hist = []
        for it in range(iters):
            xphys = np.asarray(self.H@x).ravel()/self.Hs
            if passive is not None: xphys = np.where(passive == 1, 1e-3, np.where(passive == 2, 1.0, xphys))
            K = self.stiffness(xphys); u = self.solve(K, f); lvec = np.zeros(self.nd); lvec[out_dof] = out_sign; lam = self.solve(K, lvec)
            ue, le = u[self.edof], lam[self.edof]; ce = np.einsum("ij,jk,ik->i", le, self.KE, ue)
            obj = -out_sign*float(u[out_dof]); dobj_phys = self.p*xphys**(self.p - 1)*(self.E0 - self.Emin)*ce         # d(-out_sign u_out)/dx_e = lam^T dK/dx u with K lam = out_sign e_out
            dobj = np.asarray(self.H@(dobj_phys/self.Hs)).ravel()
            g = float(xphys.mean()/vol_frac - 1.0); dg = np.asarray(self.H@(np.ones(self.ne)/self.Hs)).ravel()/(self.ne*vol_frac)
            xn = mma.update(x, dobj, g, dg); ch = float(np.abs(xn - x).max()); x = xn; hist.append(obj)
            if verbose and (it % 20 == 0 or it == iters - 1): print(f"  [{tag}] it {it:3d} u_out {float(u[out_dof]):+.4f} vol {xphys.mean():.3f} change {ch:.4f}")
            if it > 60 and abs(max(hist[-10:]) - min(hist[-10:])) < 1e-3*abs(hist[-1]): break       # converged on the objective (the move limit pins max|dx|)
        xphys = np.asarray(self.H@x).ravel()/self.Hs
        if passive is not None: xphys = np.where(passive == 1, 1e-3, np.where(passive == 2, 1.0, xphys))
        K = self.stiffness(xphys); u = self.solve(K, f); return xphys, u, hist
    def image(self, xphys): return xphys.reshape(self.nx, self.ny).T
def case_inverter(nelx=60, nely=30):
    """the displacement inverter (Fig. 7.3a mirrored): the full domain, left corners fixed, input force to the right at the left
    middle, output at the right middle asked to move left; springs k_in = k_out = 0.1 (Sigmund 1997's springs; the 1:1 ratio is
    Fig. 7.8's slider setting, the magnitude a free choice in the domain's units)"""
    s = Simp(nelx, nely, rmin=2.4); s.fix(0, 0); s.fix(0, nely); s.spring(0, nely//2, 0, 0.1); s.spring(nelx, nely//2, 0, 0.1)
    f = np.zeros(s.nd); f[2*s.node(0, nely//2)] = 1.0; out = 2*s.node(nelx, nely//2)
    xphys, u, hist = s.run(f, out, 0.3, iters=400, tag="inverter", out_sign=-1.0); return s, xphys, u, dict(u_in=float(u[2*s.node(0, nely//2)]), u_out=float(u[out]))
if __name__ == "__main__":
    rep = {}; fig, ax0 = plt.subplots(1, 1, figsize=(12, 4.5)); axs = [ax0]
    s, xphys, u, info = case_inverter(); rep["inverter"] = info
    axs[0].imshow(1 - s.image(xphys), cmap="gray", vmin=0, vmax=1, origin="lower"); axs[0].set_title(f"the displacement inverter (Fig. 7.3a mirrored) by SIMP (60 x 30, p 3, filter 2.4, MMA); u_in {info['u_in']:+.2f}, u_out {info['u_out']:+.2f}", fontsize=9); axs[0].set_axis_off()
    fig.suptitle("Chapter 7 by SIMP (Frecker, Eq. 7.3-7.5): the displacement inverter", fontsize=11)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, "simp_cm.png"), dpi=110); json.dump(rep, open(os.path.join(OUT, "simp_cm.json"), "w"), indent=1); print(json.dumps(rep, indent=1))

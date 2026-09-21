"""Method of moving asymptotes (Svanberg 1987) for one constraint, as used for topology optimization (Handbook of Compliant
Mechanisms ch. 7, Frecker, sec. 7.6: gradient methods, MMA). The single-constraint subproblem has a closed-form primal solution
x(lambda); lambda is found by bisection on the constraint. Objective and constraint sensitivities of either sign are allowed,
which the optimality-criteria update is not: compliant-mechanism objectives (u_out, MPE/SE) have sensitivities of both signs."""
import numpy as np
class MMA1:
    def __init__(self, n, xmin, xmax, move=0.5, asyinit=0.5, asyincr=1.2, asydecr=0.7):
        self.n, self.xmin, self.xmax = n, np.broadcast_to(np.asarray(xmin, float), (n,)).copy(), np.broadcast_to(np.asarray(xmax, float), (n,)).copy()
        self.move, self.asyinit, self.asyincr, self.asydecr = move, asyinit, asyincr, asydecr
        self.low = self.upp = None; self.x1 = self.x2 = None; self.it = 0
    def update(self, x, df, g, dg):
        """x: design; df: objective gradient (minimise f); g: constraint value (g <= 0 feasible); dg: its gradient. Returns new x."""
        self.it += 1; rng = self.xmax - self.xmin
        if self.it <= 2 or self.low is None:
            self.low = x - self.asyinit*rng; self.upp = x + self.asyinit*rng
        else:
            osc = (x - self.x1)*(self.x1 - self.x2); fac = np.where(osc > 0, self.asyincr, np.where(osc < 0, self.asydecr, 1.0))
            self.low = x - fac*(self.x1 - self.low); self.upp = x + fac*(self.upp - self.x1)
            self.low = np.maximum(self.low, x - 10*rng); self.low = np.minimum(self.low, x - 0.01*rng)
            self.upp = np.minimum(self.upp, x + 10*rng); self.upp = np.maximum(self.upp, x + 0.01*rng)
        alpha = np.maximum.reduce([self.xmin, self.low + 0.1*(x - self.low), x - self.move*rng])
        beta = np.minimum.reduce([self.xmax, self.upp - 0.1*(self.upp - x), x + self.move*rng])
        ux, xl = self.upp - x, x - self.low; eps = 1e-6*np.abs(df).max() + 1e-12
        p0 = ux**2*(np.maximum(df, 0) + 1e-3*np.abs(df) + eps/rng); q0 = xl**2*(np.maximum(-df, 0) + 1e-3*np.abs(df) + eps/rng)
        p1 = ux**2*np.maximum(dg, 0); q1 = xl**2*np.maximum(-dg, 0)
        r1 = g - np.sum(p1/ux + q1/xl)                                     # constraint approximation constant
        def xl_(lam):
            sp = np.sqrt(p0 + lam*p1); sq = np.sqrt(q0 + lam*q1); xn = (sp*self.low + sq*self.upp)/(sp + sq); return np.clip(xn, alpha, beta)
        def gl(lam):
            xn = xl_(lam); return r1 + np.sum(p1/(self.upp - xn) + q1/(xn - self.low))
        if gl(0.0) <= 0: lam = 0.0
        else:
            lo, hi = 0.0, 1.0
            while gl(hi) > 0 and hi < 1e12: hi *= 10
            for _ in range(80):
                mid = 0.5*(lo + hi)
                if gl(mid) > 0: lo = mid
                else: hi = mid
            lam = hi
        xn = xl_(lam); self.x2, self.x1 = self.x1, x.copy(); return xn

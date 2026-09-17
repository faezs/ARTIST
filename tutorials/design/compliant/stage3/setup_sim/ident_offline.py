#!/usr/bin/env python
"""Offline identification on the calibration pairs saved with each run (cal_X: pose error, cal_U: strut command, 30 fps).
Usage: ident_offline.py TAG [TAG ...]. Compares FIR-on-increments (the in-run fit), level DMDc with free dynamics, Hankel DMDc (time-delay observables of the
pose and command increments, the Koopman embedding) and window-averaged increments; reports hold-out skill against persistence and the settled gain against
the analytic inverse Jacobian at the calibration pose. Finding (XPBD flower, compliant pedicel): only the Hankel model predicts one step ahead in gusts
(skill 0.95 at 12 m/s, 0.97 calm); its settled gain is 39 % from the Jacobian in calm (the compliant system's true gain, the same 39 % the rigid-pedicel run
found) but ill-determined in wind (a near-unit-root mode absorbs the slow drift): the gain the loop needs wants a richer excitation than a +-2 mm dither."""
import json, sys, numpy as np
R_REC, R_PLAT, D_BACK, H_HEX = 1.5, 1.0, 0.6, 1.2
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
def head_axes(n):
    ref = np.array([-1.0, 0, 0]); xl = ref - n*(ref@n)
    if np.linalg.norm(xl) < 1e-6: xl = np.array([0, 1.0, 0]) - n*n[1]
    xl /= np.linalg.norm(xl); yl = np.cross(n, xl); return xl, yl, n
def plat_points(P, n):
    xl, yl, zl = head_axes(n); Cp = P - D_BACK*n; return [Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG]
def base_points(P, n):
    xl, yl, zl = head_axes(n); Cb = P - (D_BACK + H_HEX)*n; return [Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG]
def jacobian(P, n):
    b = base_points(P, n); p = plat_points(P, n); J = np.zeros((6, 6))
    for j in range(6):
        u = p[j] - b[j]; L = np.linalg.norm(u); u /= L; J[j, :3] = u; J[j, 3:] = np.cross(p[j] - P, u)
    return J
def fit(Phi, Y, lam):
    ntr = int(0.7*len(Phi)); sc = np.sqrt(np.mean(Phi[:ntr]**2, 0)) + 1e-12; Ps = Phi/sc
    M = (np.linalg.solve(Ps[:ntr].T@Ps[:ntr] + lam*ntr*np.eye(Phi.shape[1]), Ps[:ntr].T@Y[:ntr]).T)/sc
    pred = Phi[ntr:]@M.T; e_m = np.sqrt(np.mean((pred - Y[ntr:])**2, 0)); e_p = np.sqrt(np.mean(Y[ntr:]**2, 0)); return M, 1 - np.mean(e_m/np.maximum(e_p, 1e-12))
for tag in sys.argv[1:]:
    A = json.load(open(f"out/{tag}_anim.json")); X = np.array(A["cal_X"]); U = np.array(A["cal_U"]); L = A["log"]; T_S, T_C = A["t_setup"], A["t_cal"]
    k = next(i for i, l in enumerate(L) if l["t"] >= T_S + T_C); P = np.array(L[k]["P"]); n = np.array(L[k]["n"]); n /= np.linalg.norm(n)
    Jan = np.linalg.inv(jacobian(P, n)); dX = np.diff(X, axis=0); dU = np.diff(U, axis=0)
    print(f"== {tag}: {len(X)} pairs; |J^-1| {np.linalg.norm(Jan):.3f}")
    for D, lam in [(3, 1e-3), (5, 1e-3), (10, 1e-3), (15, 1e-3), (5, 1e-2), (5, 1e-4)]:
        rows = [np.concatenate([dX[k_ - D:k_].ravel(), dU[k_ - D:k_ + 1].ravel()]) for k_ in range(D, len(dX))]
        Phi = np.array(rows); Y = dX[D:]; M, sk = fit(Phi, Y, lam)
        Asum = sum(M[:, 6*i:6*(i + 1)] for i in range(D)); Bsum = sum(M[:, 6*D + 6*j: 6*D + 6*(j + 1)] for j in range(D + 1))
        G = np.linalg.solve(np.eye(6) - Asum, Bsum); rel = np.linalg.norm(G - Jan)/np.linalg.norm(Jan)
        ev = np.abs(np.linalg.eigvals(np.eye(6) - Asum)).min()
        print(f"  Hankel D {D:2d} lam {lam:.0e}: skill {sk:+.2f}; settled gain {100*rel:5.1f} % from J^-1; min |eig(I - sum A)| {ev:.3f}")
    # the FIR-3 gain for reference and the pure lag-of-U model with sum
    Phi = np.hstack([dU[2 - j: len(dU) - j] for j in range(3)]); M, sk = fit(Phi, dX[2:], 1e-3); G = sum(M[:, 6*j:6*(j + 1)] for j in range(3))
    print(f"  FIR-3 reference: skill {sk:+.2f}, gain {100*np.linalg.norm(G - Jan)/np.linalg.norm(Jan):.1f} % from J^-1")

"""The membrane's wind load from the LES: net pressure (front - back) on the polar probe grid, its azimuthal harmonics per
ring, and the film's figure error from each harmonic by the linear prestressed-membrane response
    T (w'' + w'/r - n^2 w/r^2) = -p_n(r),  w(a) = 0   (n >= 1; n = 0 is the defocus the plenum corrects)
solved per harmonic on the ring grid, then the slope field's rms over the disc -> mrad and the blur at F (2 x slope x f)."""
import sys, numpy as np, pandas as pd
d = sys.argv[1]; U = float(sys.argv[2]) if len(sys.argv) > 2 else 12.0
T, a, f_dish, rho_air = float(sys.argv[3]) if len(sys.argv) > 3 else 4922.3, 2.1, 4.0, 1.03; q = 0.5*rho_air*U*U   # T: the film's area-mean working tension from the 1-D FvK solve at f 4
p = pd.read_csv(f"{d}/pressure.csv"); g = pd.read_csv(f"{d}/probes.csv")
fr = p[[c for c in p.columns if c.startswith("f")]].values; bk = p[[c for c in p.columns if c.startswith("b")]].values
net = fr - bk                                                     # Cp, front minus back: what the film feels, positive pushes it back
NR, NT = 24, 48; rings = g.rho_over_a.values.reshape(NR, NT)[:, 0]*a
cp = net.reshape(len(p), NR, NT)
mean_map = cp.mean(0)
print(f"{len(p)} snapshots at U {U} m/s, q {q:.0f} Pa. Net Cp on the film: mean {mean_map.mean():+.3f}, range {mean_map.min():+.2f}..{mean_map.max():+.2f}; snapshot-to-snapshot rms {cp.std(0).mean():.3f}")
th = 2*np.pi*np.arange(NT)/NT
def harmonics(m):
    out = {}
    for n in range(0, 5):
        cn = (m*np.cos(n*th)).mean(1)*(2 if n else 1); sn = (m*np.sin(n*th)).mean(1)*(2 if n else 1)
        out[n] = (cn, sn)
    return out
H = harmonics(mean_map)
def slope_rms(n, pr):
    """the film's slope rms over the disc from the n-th harmonic with radial profile pr (Pa) on the ring radii"""
    r = np.r_[0.0, rings, a]; pr_ = np.r_[pr[0] if n == 0 else 0.0, pr, 0.0]
    N = len(r); h = np.diff(r)
    # finite differences for T(w'' + w'/r - n^2 w/r^2) = -p on interior nodes, w(a) = 0, w regular at 0
    A = np.zeros((N, N)); b = np.zeros(N)
    for i in range(1, N - 1):
        hm, hp = h[i-1], h[i]; ri = r[i]
        A[i, i-1] = 2/(hm*(hm+hp)) - 1/(ri*(hm+hp)); A[i, i+1] = 2/(hp*(hm+hp)) + 1/(ri*(hm+hp)); A[i, i] = -2/(hm*hp) - n*n/(ri*ri)
        b[i] = -pr_[i]/T
    if n == 0: A[0, 0] = -1; A[0, 1] = 1                         # w'(0) = 0
    else: A[0, 0] = 1                                            # w(0) = 0
    A[-1, -1] = 1
    w = np.linalg.solve(A, b)
    wr = np.gradient(w, r); wt = n*w/np.maximum(r, 1e-6)
    wgt = r; return float(np.sqrt(np.sum((wr**2 + 0.5*wt**2*(n > 0))*wgt)/np.sum(wgt))) if n == 0 else float(np.sqrt(np.sum((0.5*wr**2 + 0.5*wt**2)*wgt)/np.sum(wgt)))
print(f"\n{'n':>2} {'amplitude Cp (rms over rings)':>30} {'film slope mrad rms':>20} {'blur at F cm':>13}")
tot = 0.0
for n in range(0, 5):
    cn, sn = H[n]; amp = np.hypot(cn, sn)
    s_c, s_s = slope_rms(n, cn*q), slope_rms(n, sn*q); s = np.hypot(s_c, s_s) if n else s_c
    if n: tot += s*s
    print(f"{n:2d} {np.sqrt(np.mean(amp**2)):30.3f} {1e3*s:20.3f} {1e2*2*s*f_dish:13.2f}{'   (defocus: the plenum and the zones take this one)' if n == 0 else ''}")
print(f"figure error from n >= 1 together: {1e3*np.sqrt(tot):.2f} mrad rms -> blur {1e2*2*np.sqrt(tot)*f_dish:.1f} cm at F   (the envs carry n = 1 only: {1e3*2.63e-5*U*U:.2f} mrad at this wind)")
np.save(f"{d}/mean_map.npy", mean_map); np.save(f"{d}/rings.npy", rings)

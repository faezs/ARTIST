"""Apply the validated 2-D FvK solver to the beam-down Cassegrain.

Two questions the axisymmetric solver structurally could not touch:
  A. Does the beam-down's condemnation survive the CORRECTED wind number?
     (my q*a/2T hand estimate overstated wind figure error ~3.6x)
  B. The expert panel asserted that 5 CONCENTRIC zones can only correct
     m=0, and that the dominant real errors (wind m=1, clamp astigmatism
     m=2) are orthogonal to that actuator space - so sector-split zones
     would be "a different machine". Now testable: build influence
     matrices for both actuator layouts and measure the residual.
"""
import importlib.util, pathlib, sys, time
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import membrane_fvk2d as F
_spec = importlib.util.spec_from_file_location(
    "tsim", pathlib.Path(__file__).resolve().parent / "03_membrane_beamdown_tandoor.py")
_sim = importlib.util.module_from_spec(_spec); sys.argv=[sys.argv[0]]
_spec.loader.exec_module(_sim)
CFG=_sim.CFG

# the beam-down's actual operating point
a, T, dp = 1.65, 2000.0, 404.0
E, h, nu = CFG.E_mem, CFG.t_mem, CFG.nu_mem
N = 121; ext = a*1.04; dx = 2*ext/(N-1); IT=(400,500)
xs = torch.linspace(-ext, ext, N, dtype=torch.float64)
X, Y = torch.meshgrid(xs, xs, indexing="ij")
Rr = torch.sqrt(X**2+Y**2); TH = torch.atan2(Y, X)
phi = F.ellipse_phi(N, ext, a, a)

def slopes(res):
    m = res["cellw"] > 0.99
    return torch.cat([res["wx"][m], res["wy"][m]])

t0=time.time()
base = F.solve_fvk(phi, dx, dp, T, E, h, nu, iters=IT)
fx, fy, rms, p2v = F.fit_paraboloid(base, dx, ext)
se0 = F.slope_error(base, dx, ext, fx, fy)
s0 = slopes(base)
print(f"== beam-down membrane, 2-D FvK ==")
print(f"  |f| = {abs(fx):.3f} m, intrinsic (Hencky) slope err "
      f"{se0*1e3:.2f} mrad  [{time.time()-t0:.0f}s]")

print("\n== A. DISTURBANCES, measured not estimated ==")
dist = {}
for nm, kw in (
    ("wind m=1  5 m/s", dict(p=dp + 0.6*25*(X/a))),
    ("wind m=1  8 m/s", dict(p=dp + 0.6*64*(X/a))),
    ("gravity @ 63 deg", dict(p=dp, rho_areal=0.07, tilt_deg=63.0)),
    ("clamp dT/T = 2% m=2", dict(p=dp, T_pre=T*(1+0.02*torch.cos(2*TH)))),
):
    kw2 = dict(kw); pp = kw2.pop("p"); TT = kw2.pop("T_pre", T)
    r = F.solve_fvk(phi, dx, pp, TT, E, h, nu, iters=IT,
                    w_init=base["w"], **kw2)
    d = slopes(r) - s0
    dist[nm] = d
    fxx, _, _, _ = F.fit_paraboloid(r, dx, ext)
    print(f"  {nm:22s} adds {float(d.pow(2).mean().sqrt())*1e3:5.2f} mrad "
          f"slope, focus {(abs(fxx)/abs(fx)-1)*100:+5.1f}%")

print("\n== B. CORRECTION AUTHORITY: concentric vs sector zones ==")
def zone_masks(n_rad, n_sec):
    edges = np.sqrt(np.linspace(0, 1, n_rad+1)) * a
    out = []
    for i in range(n_rad):
        rm = (Rr >= edges[i]) & (Rr < edges[i+1])
        if n_sec == 1:
            out.append(rm.double())
        else:
            for k in range(n_sec):
                lo = -np.pi + 2*np.pi*k/n_sec
                hi = lo + 2*np.pi/n_sec
                out.append((rm & (TH >= lo) & (TH < hi)).double())
    return out

for n_rad, n_sec, nm in ((5,1,"5 concentric (as built)"),
                         (3,4,"3x4 = 12 sector zones"),
                         (5,4,"5x4 = 20 sector zones")):
    masks = zone_masks(n_rad, n_sec)
    J = []
    delta = 8.0
    for msk in masks:
        r = F.solve_fvk(phi, dx, dp + delta*msk, T, E, h, nu, iters=(200,300),
                        w_init=base["w"])
        J.append((slopes(r) - s0)/delta)
    J = torch.stack(J, 1)
    print(f"  {nm:24s} ({len(masks):2d} pumps)")
    for dn, d in dist.items():
        c = torch.linalg.lstsq(J, d[:, None]).solution
        resid = float((d - (J @ c).squeeze(1)).pow(2).mean().sqrt())
        print(f"      vs {dn:22s}: {float(d.pow(2).mean().sqrt())*1e3:5.2f}"
              f" -> {resid*1e3:5.2f} mrad "
              f"({(1-resid/float(d.pow(2).mean().sqrt()))*100:4.0f}% corrected)")

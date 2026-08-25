"""Validate the generic 2-D FvK solver against the 1-D axisymmetric one,
then answer the three questions the 1-D solver cannot."""
import importlib.util, pathlib, sys, time
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import membrane_fvk2d as F

_spec = importlib.util.spec_from_file_location(
    "tsim", pathlib.Path(__file__).resolve().parent / "03_membrane_beamdown_tandoor.py")
_sim = importlib.util.module_from_spec(_spec)
sys.argv = [sys.argv[0]]
_spec.loader.exec_module(_sim)

CFG = _sim.CFG
a, T, E, h, nu = 1.60, 600.0, CFG.E_mem, CFG.t_mem, CFG.nu_mem
dp = 170.0

print("== VALIDATION 0: LINEAR membrane (K=0) vs exact w = p(a^2-r^2)/4T ==")
for N in (81, 121, 161):
    ext = a * 1.05; dx = 2 * ext / (N - 1)
    r = F.solve_fvk(F.ellipse_phi(N, ext, a, a), dx, dp, T, E, h, nu,
                    linear=True, iters=(300, 400))
    exact = dp * a**2 / (4 * T)
    w0 = float(r["w"].max())
    print(f"  N={N:3d} dx={dx*1000:4.1f}mm: w0 = {w0*1000:7.3f} mm  "
          f"exact {exact*1000:7.3f} mm  ({(w0/exact-1)*100:+5.2f}%)")

print("\n== VALIDATION: circular rim, uniform pressure, vs the 1-D solver ==")
CFG.a = a; CFG.T_pre = T
m1 = _sim.solve_membrane(CFG, dp, n=1200)
w0_1d, f_1d = m1["w0"], m1["f_fit"]
print(f"  1-D axisymmetric : w0 = {w0_1d*1000:7.3f} mm   f_fit = {f_1d:6.3f} m")

for N in (81, 121, 161):
    ext = a * 1.05
    dx = 2 * ext / (N - 1)
    phi = F.ellipse_phi(N, ext, a, a)
    t0 = time.time()
    r = F.solve_fvk(phi, dx, dp, T, E, h, nu, iters=(400, 600))
    fx, fy, rms, p2v = F.fit_paraboloid(r, dx, ext)
    w0 = float(r["w"].max())
    print(f"  2-D N={N:3d} dx={dx*1000:4.1f}mm: w0 = {w0*1000:7.3f} mm "
          f"({(w0/w0_1d-1)*100:+5.2f}%)  f = {fx:6.3f} m "
          f"({(fx/f_1d-1)*100:+5.2f}%)  [{time.time()-t0:4.1f}s]")

N, ext = 141, a * 1.05
dx = 2 * ext / (N - 1)

print("\n== Q1. ELLIPTICAL RIM: does pressure give a 2-CURVATURE paraboloid? ==")
print("   (the off-axis Scheffler section the polar retrofit assumes)")
for ratio in (1.0, 1.15, 1.35, 1.6):
    phi = F.ellipse_phi(N, ext, a, a / ratio)
    r = F.solve_fvk(phi, dx, dp, T, E, h, nu, iters=(400, 600))
    fx, fy, rms, p2v = F.fit_paraboloid(r, dx, ext)
    se = F.slope_error(r, dx, ext, fx, fy)
    print(f"  axis ratio {ratio:4.2f}: fx={fx:6.3f} fy={fy:6.3f} m  "
          f"(fy/fx={fy/fx:5.3f})  slope err vs best 2-curv fit = "
          f"{se*1e3:5.2f} mrad  p2v={p2v*1e3:5.2f} mm")

print("\n== Q2. GRAVITY AT TILT (bare film vs jammed pouch) ==")
phi = F.ellipse_phi(N, ext, a, a)
for rho_a, nm in ((0.07, "bare 50um film"), (6.0, "film + 20mm jammed bed")):
    for tilt in (0.0, 45.0, 70.0):
        r = F.solve_fvk(phi, dx, dp, T, E, h, nu, rho_areal=rho_a,
                        tilt_deg=tilt, iters=(400, 600))
        fx, fy, rms, p2v = F.fit_paraboloid(r, dx, ext)
        se = F.slope_error(r, dx, ext, fx, fy)
        print(f"  {nm:24s} tilt {tilt:4.0f} deg: f={fx:6.3f} m  "
              f"asymmetry |fx-fy|={abs(fx-fy)*1000:6.1f} mm  "
              f"slope err {se*1e3:5.2f} mrad")

print("\n== Q3. ASYMMETRIC WIND LOAD (the m=1 no pump can correct) ==")
xs = torch.linspace(-ext, ext, N, dtype=torch.float64)
X, Y = torch.meshgrid(xs, xs, indexing="ij")
phi = F.ellipse_phi(N, ext, a, a)
for q in (0.0, 15.0, 50.0):
    pf = dp + q * (X / a)          # linear ramp across the dish
    r = F.solve_fvk(phi, dx, pf, T, E, h, nu, iters=(400, 600))
    fx, fy, rms, p2v = F.fit_paraboloid(r, dx, ext)
    se = F.slope_error(r, dx, ext, fx, fy)
    print(f"  wind gradient {q:5.1f} Pa across dish: f={fx:6.3f} m  "
          f"slope err {se*1e3:5.2f} mrad  (blur = {2*se*1e3:5.2f} mrad)")

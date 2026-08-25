"""The three questions the 1-D axisymmetric solver could not answer.
Solver noise floor ~0.6 mrad slope / ~1% focal length at this resolution."""
import importlib.util, pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import membrane_fvk2d as F
_spec = importlib.util.spec_from_file_location(
    "tsim", pathlib.Path(__file__).resolve().parent / "03_membrane_beamdown_tandoor.py")
_sim = importlib.util.module_from_spec(_spec); sys.argv=[sys.argv[0]]
_spec.loader.exec_module(_sim)
CFG=_sim.CFG
a,T,E,h,nu = 1.60,600.0,CFG.E_mem,CFG.t_mem,CFG.nu_mem; dp=170.0
N=161; ext=a*1.04; dx=2*ext/(N-1); IT=(500,700)

print("== Q1. ELLIPTICAL RIM -> the off-axis (Scheffler) section ==")
print("   linear theory: an ellipse gives an EXACT two-curvature")
print("   paraboloid with fy/fx = 1/ratio^2. Does the nonlinear")
print("   (Hencky) membrane still?")
for ratio in (1.0, 1.15, 1.35, 1.60, 2.0):
    phi = F.ellipse_phi(N, ext, a, a/ratio)
    r = F.solve_fvk(phi, dx, dp, T, E, h, nu, iters=IT)
    fx,fy,rms,p2v = F.fit_paraboloid(r,dx,ext)
    se = F.slope_error(r,dx,ext,fx,fy)
    print(f"  ratio {ratio:4.2f}: |fx|={abs(fx):6.3f} |fy|={abs(fy):6.3f} m  "
          f"fy/fx={fy/fx:5.3f} (theory {1/ratio**2:5.3f})  "
          f"residual slope {se*1e3:4.2f} mrad")

print("\n== Q2. GRAVITY AT TILT: bare film vs jammed pouch ==")
phi = F.ellipse_phi(N, ext, a, a)
base = None
for rho_a, nm in ((0.07,"bare 50um film      "), (6.0,"+20mm jammed bed    ")):
    for tilt in (0.0, 45.0, 70.0):
        r = F.solve_fvk(phi,dx,dp,T,E,h,nu,rho_areal=rho_a,tilt_deg=tilt,
                        tilt_dir=(1.0,0.0),iters=IT)
        fx,fy,rms,p2v = F.fit_paraboloid(r,dx,ext)
        se = F.slope_error(r,dx,ext,fx,fy)
        if base is None: base = abs(fx)
        print(f"  {nm} tilt {tilt:4.0f}: |f|={abs(fx):6.3f}m "
              f"({(abs(fx)/base-1)*100:+5.1f}%)  astig |fx-fy|="
              f"{abs(abs(fx)-abs(fy))*1000:5.1f}mm  slope {se*1e3:4.2f} mrad")

print("\n== Q3. ASYMMETRIC WIND (the m=1 no axisymmetric pump can fix) ==")
xs = torch.linspace(-ext,ext,N,dtype=torch.float64)
X,Y = torch.meshgrid(xs,xs,indexing="ij")
for v_ms in (0.0, 3.0, 5.0, 8.0):
    q = 0.6*v_ms**2
    pf = dp + q*(X/a)
    r = F.solve_fvk(phi,dx,pf,T,E,h,nu,iters=IT)
    fx,fy,rms,p2v = F.fit_paraboloid(r,dx,ext)
    se = F.slope_error(r,dx,ext,fx,fy)
    print(f"  v={v_ms:4.1f} m/s (q={q:5.1f} Pa gradient): |f|={abs(fx):6.3f}m "
          f"slope {se*1e3:4.2f} mrad -> optical blur {2*se*1e3:5.2f} mrad")
print("  (jammed pouch multiplies the wind term by ~0.02: the 5 m/s row")
print("   becomes equivalent to a ~0.7 m/s breeze)")

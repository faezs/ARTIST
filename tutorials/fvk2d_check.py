"""Accuracy characterisation: 2-D vs 1-D on identical circular problems."""
import importlib.util, pathlib, sys
import numpy as np, torch
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import membrane_fvk2d as F
_spec = importlib.util.spec_from_file_location(
    "tsim", pathlib.Path(__file__).resolve().parent / "03_membrane_beamdown_tandoor.py")
_sim = importlib.util.module_from_spec(_spec); sys.argv=[sys.argv[0]]
_spec.loader.exec_module(_sim)
CFG=_sim.CFG; a,T,E,h,nu = 1.60,600.0,CFG.E_mem,CFG.t_mem,CFG.nu_mem; dp=170.0
CFG.a=a; CFG.T_pre=T
m1=_sim.solve_membrane(CFG,dp,n=1500)

# 1-D reference slope error vs its own best-fit parabola (Hencky term)
r1=m1["r"].numpy(); s1=m1["s"].numpy(); sp1=m1["sp"].numpy()
f1=m1["f_fit"]; ideal_sp = r1/(2*f1)
w_area = r1
se_1d = np.sqrt(np.average((sp1-ideal_sp)**2, weights=w_area))
print(f"1-D: w0={m1['w0']*1000:7.3f}mm f={f1:6.3f}m  "
      f"intrinsic (Hencky) slope err = {se_1d*1e3:5.2f} mrad")
print("2-D convergence on the SAME problem:")
for N in (101,141,181,221):
    ext=a*1.04; dx=2*ext/(N-1)
    r=F.solve_fvk(F.ellipse_phi(N,ext,a,a),dx,dp,T,E,h,nu,iters=(400,600))
    fx,fy,rms,p2v=F.fit_paraboloid(r,dx,ext)
    se=F.slope_error(r,dx,ext,fx,fy)
    w0=float(r["w"].max())
    print(f"  N={N:3d} dx={dx*1000:4.1f}mm: w0={w0*1000:7.3f}mm "
          f"({(w0/m1['w0']-1)*100:+5.2f}%)  |f|={abs(fx):6.3f}m "
          f"({(abs(fx)/f1-1)*100:+5.2f}%)  slope err={se*1e3:5.2f} mrad "
          f"(1-D says {se_1d*1e3:5.2f})")

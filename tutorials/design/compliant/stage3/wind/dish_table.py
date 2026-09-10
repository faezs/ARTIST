"""one line per LES run: the loads the envs assume against what the LES found, and the film's figure error by harmonic"""
import sys, glob, os, re, numpy as np, pandas as pd
sys.argv = [sys.argv[0]]
S = os.path.dirname(os.path.abspath(__file__)); U = 12.0; q = 0.5*1.03*U*U; A = np.pi*2.1**2; D = 4.2
CD_BOWL, CD_BACK, C_M = 1.40, 1.05, 0.15
exec(open(f"{S}/cp_harmonics.py").read().split("d = sys.argv[1]")[0])   # imports only
rows = []
for d in sorted(glob.glob(f"{S}/dish_les*")):
    if not os.path.exists(f"{d}/forces.csv") or not os.path.exists(f"{d}/pressure.csv"): continue
    m = re.search(r"el(\d+)_az(\d+)", d); el, az = (float(m.group(1)), float(m.group(2))) if m else (59.0, 0.0)
    if d.endswith("dish_les_test"): continue
    f = pd.read_csv(f"{d}/forces.csv"); p = pd.read_csv(f"{d}/pressure.csv"); g = pd.read_csv(f"{d}/probes.csv")
    if len(f) < 10 or len(p) < 2: continue
    n = np.array([-np.cos(np.radians(el))*np.cos(np.radians(az)), np.cos(np.radians(el))*np.sin(np.radians(az)), np.sin(np.radians(el))])
    Fn = (f.Fx_N*n[0] + f.Fy_N*n[1] + f.Fz_N*n[2]); Mn = np.hypot(f.My_Nm, f.Mx_Nm)
    ca = -n[0]; cd_env = 0.25 + ((CD_BOWL if ca > 0 else CD_BACK) - 0.25)*ca*ca         # what the fast env assumes for the drag along the wind
    fr = p[[c for c in p.columns if c.startswith("f")]].values; bk = p[[c for c in p.columns if c.startswith("b")]].values
    cp = (fr - bk).reshape(len(p), 24, 48); mean_map = cp.mean(0); th = 2*np.pi*np.arange(48)/48
    amps = {}
    for k in range(0, 4):
        cn = (mean_map*np.cos(k*th)).mean(1)*(2 if k else 1); sn = (mean_map*np.sin(k*th)).mean(1)*(2 if k else 1); amps[k] = float(np.sqrt(np.mean(cn**2 + sn**2)))
    rows.append(dict(el=el, az=az, Cd=f.Cd.mean(), Cd_env=cd_env, Cl=f.Cl.mean(), Cn=Fn.mean()/(q*A), Cm=f.Cm.mean(), Cm_rms=f.Cm.std(), Cm_env=C_M,
                     Cp_net=mean_map.mean(), n0=amps[0], n1=amps[1], n2=amps[2], n3=amps[3], t=f.t_s.max()))
T = pd.DataFrame(rows).sort_values(["el", "az"])
pd.set_option("display.width", 200); print(T.round(3).to_string(index=False))

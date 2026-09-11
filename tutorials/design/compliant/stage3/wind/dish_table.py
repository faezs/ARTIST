"""one line per LES run, and a JSON table for the envs: the loads and the film's figure error against the wind's incidence
on the bowl (theta_w = the angle between the dish axis and the upwind direction; 0 = the wind straight into the bowl)."""
import sys, glob, os, re, json, numpy as np, pandas as pd
S = os.path.dirname(os.path.abspath(__file__)); U = 12.0; rho = 1.03; q = 0.5*rho*U*U; A = np.pi*2.1**2; D = 4.2
CD_BOWL, CD_BACK, C_M = 1.40, 1.05, 0.15
T_WORK, a, f_dish = 4922.0, 2.1, 4.0
def slope_rms(n, pr, rings):
    r = np.r_[0.0, rings, a]; pr_ = np.r_[pr[0] if n == 0 else 0.0, pr, 0.0]; N = len(r); h = np.diff(r)
    A_ = np.zeros((N, N)); b = np.zeros(N)
    for i in range(1, N - 1):
        hm, hp = h[i-1], h[i]; ri = r[i]
        A_[i, i-1] = 2/(hm*(hm+hp)) - 1/(ri*(hm+hp)); A_[i, i+1] = 2/(hp*(hm+hp)) + 1/(ri*(hm+hp)); A_[i, i] = -2/(hm*hp) - n*n/(ri*ri); b[i] = -pr_[i]/T_WORK
    if n == 0: A_[0, 0] = -1; A_[0, 1] = 1
    else: A_[0, 0] = 1
    A_[-1, -1] = 1; w = np.linalg.solve(A_, b); wr = np.gradient(w, r); wt = n*w/np.maximum(r, 1e-6)
    return float(np.sqrt(np.sum((wr**2 if n == 0 else 0.5*(wr**2 + wt**2))*r)/np.sum(r)))
rows = []
for d in sorted(glob.glob(f"{S}/runs/dish_les*")):
    if d.endswith("dish_les_test") or not os.path.exists(f"{d}/forces.csv"): continue
    try: f = pd.read_csv(f"{d}/forces.csv"); p = pd.read_csv(f"{d}/pressure.csv"); g = pd.read_csv(f"{d}/probes.csv")
    except Exception: continue                                                          # a run still settling
    if len(f) < 10 or len(p) < 2: continue
    m = re.search(r"el(\d+)_az(\d+)", d); el, az = (float(m.group(1)), float(m.group(2))) if m else (59.0, 0.0)
    dxm = re.search(r"dx(\d+)", d); dx = float("0." + dxm.group(1)[1:]) if dxm else 0.06
    n = np.array([-np.cos(np.radians(el))*np.cos(np.radians(az)), np.cos(np.radians(el))*np.sin(np.radians(az)), np.sin(np.radians(el))])
    theta_w = float(np.degrees(np.arccos(np.clip(-n[0], -1, 1))))                     # upwind is -x
    Fn = f.Fx_N*n[0] + f.Fy_N*n[1] + f.Fz_N*n[2]; Ft = np.sqrt(np.maximum(f.Fx_N**2 + f.Fy_N**2 + f.Fz_N**2 - Fn**2, 0))
    Mmag = np.sqrt(f.Mx_Nm**2 + f.My_Nm**2 + f.Mz_Nm**2)
    fr = p[[c for c in p.columns if c.startswith("f")]].values; bk = p[[c for c in p.columns if c.startswith("b")]].values
    cp = (fr - bk).reshape(len(p), 24, 48); mean_map = cp.mean(0); th = 2*np.pi*np.arange(48)/48; rings = g.rho_over_a.values.reshape(24, 48)[:, 0]*a
    amps = {}; tot = 0.0
    for k in range(0, 4):
        cn = (mean_map*np.cos(k*th)).mean(1)*(2 if k else 1); sn = (mean_map*np.sin(k*th)).mean(1)*(2 if k else 1)
        amps[k] = float(np.sqrt(np.mean(cn**2 + sn**2)))
        if k: tot += slope_rms(k, cn*q, rings)**2 + slope_rms(k, sn*q, rings)**2
    ca = -n[0]; cd_env = 0.25 + ((CD_BOWL if ca > 0 else CD_BACK) - 0.25)*ca*ca
    rows.append(dict(run=os.path.basename(d), dx=dx, el=el, az=az, theta_w=theta_w, Cd=float(f.Cd.mean()), Cd_env=float(cd_env), Cl=float(f.Cl.mean()),
                     Cn=float(Fn.mean()/(q*A)), Ct=float(Ft.mean()/(q*A)), Cm=float(Mmag.mean()/(q*A*D)), Cm_rms=float(Mmag.std()/(q*A*D)),
                     Cp_net=float(mean_map.mean()), n0=amps[0], n1=amps[1], n2=amps[2], n3=amps[3],
                     film_mrad=float(1e3*np.sqrt(tot)), k_film=float(np.sqrt(tot)/U**2), k_film_env=2.63e-5, t_s=float(f.t_s.max())))
T = pd.DataFrame(rows).sort_values(["theta_w", "dx"])
pd.set_option("display.width", 250); print(T.drop(columns=["run"]).round(3).to_string(index=False))
json.dump(rows, open(f"{S}/dish_table.json", "w"), indent=1); print("->", f"{S}/dish_table.json")

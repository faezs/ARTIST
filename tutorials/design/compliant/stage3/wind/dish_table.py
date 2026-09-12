"""one line per LES run, and a JSON table for the envs: the loads and the film's figure error against the wind's incidence
on the bowl (theta_w = the angle between the dish axis and the upwind direction; 0 = the wind straight into the bowl)."""
import sys, glob, os, re, json, numpy as np, pandas as pd
S = os.path.dirname(os.path.abspath(__file__)); U = 12.0; rho = 1.03; q = 0.5*rho*U*U; A = np.pi*2.1**2; D = 4.2
CD_BOWL, CD_BACK, C_M = 1.40, 1.05, 0.15
T_WORK, a, f_dish = 4922.0, 2.1, 4.0
def membrane_response(n, pr, rings):
    """the linear prestressed membrane's deflection w(r) along the axis for the n-th harmonic's radial pressure profile pr
    (Pa on the ring radii): T (w'' + w'/r - n^2 w/r^2) = -p_n, w(a) = 0. Returns r (with 0 and a) and w."""
    r = np.r_[0.0, rings, a]; pr_ = np.r_[pr[0] if n == 0 else 0.0, pr, 0.0]; N = len(r); h = np.diff(r)
    A_ = np.zeros((N, N)); b = np.zeros(N)
    for i in range(1, N - 1):
        hm, hp = h[i-1], h[i]; ri = r[i]
        A_[i, i-1] = 2/(hm*(hm+hp)) - 1/(ri*(hm+hp)); A_[i, i+1] = 2/(hp*(hm+hp)) + 1/(ri*(hm+hp)); A_[i, i] = -2/(hm*hp) - n*n/(ri*ri); b[i] = -pr_[i]/T_WORK
    if n == 0: A_[0, 0] = -1; A_[0, 1] = 1
    else: A_[0, 0] = 1
    A_[-1, -1] = 1; return r, np.linalg.solve(A_, b)
def slope_rms_w(n, r, w):
    """the slope field's rms over the disc of w(r) cos(n phi) (or sin): the radial and the azimuthal slope"""
    wr = np.gradient(w, r); wt = n*w/np.maximum(r, 1e-6)
    return float(np.sqrt(np.sum((wr**2 if n == 0 else 0.5*(wr**2 + wt**2))*r)/np.sum(r)))
def slope_rms(n, pr, rings):
    r, w = membrane_response(n, pr, rings); return slope_rms_w(n, r, w)
def plane_tilt(r, w):
    """the least-squares plane through w(r) cos(phi): z = alpha x with alpha = 4 int w r^2 dr / a^4 - the part of the n = 1
    harmonic that is a rigid tilt of the film, which the beam feels as a pointing bias, not a figure error"""
    return float(4.0*np.trapezoid(w*r*r, r)/a**4)

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
    amps = {}; tot = 0.0; fig = 0.0
    # THE WIND AS A FIELD ON THE FILM. The probe grid's azimuth is measured from e1 = n x y in the dish plane (dish_setup.cpp);
    # the wind blows +x, so its projection on the dish plane sits at phi_w in that basis. The n = 1 harmonic's membrane
    # response is partly a rigid tilt of the film (a pointing bias the loop can see and remove) and partly figure; the
    # tilt is the least-squares plane, signed along the wind's projection (positive: the normal leans downwind), and the
    # figure error (k_fig) is what is left of n = 1 plus n >= 2. k_film keeps the old total for the old path.
    e1 = np.cross(n, [0.0, 1.0, 0.0]); e1 /= np.linalg.norm(e1); e2 = np.cross(n, e1)
    wp = np.array([1.0, 0.0, 0.0]) - n[0]*n; wpn = np.linalg.norm(wp); wp = wp/wpn if wpn > 1e-9 else e1
    phi_w = float(np.arctan2(wp @ e2, wp @ e1))
    tilt_c = tilt_s = 0.0
    for k in range(0, 4):
        cn = (mean_map*np.cos(k*th)).mean(1)*(2 if k else 1); sn = (mean_map*np.sin(k*th)).mean(1)*(2 if k else 1)
        amps[k] = float(np.sqrt(np.mean(cn**2 + sn**2)))
        if k:
            rc, wc = membrane_response(k, cn*q, rings); rs, ws = membrane_response(k, sn*q, rings)
            tot += slope_rms_w(k, rc, wc)**2 + slope_rms_w(k, rs, ws)**2
            if k == 1:
                tilt_c, tilt_s = plane_tilt(rc, wc), plane_tilt(rs, ws)                 # the plane z = alpha x along e1, e2
                fig += slope_rms_w(1, rc, wc - tilt_c*rc)**2 + slope_rms_w(1, rs, ws - tilt_s*rs)**2
            else:
                fig += slope_rms_w(k, rc, wc)**2 + slope_rms_w(k, rs, ws)**2
    # the film's normal for z = alpha x leans toward -e1 by alpha: the tilt of the normal along the wind's projection, and across
    tilt_w = -(tilt_c*np.cos(phi_w) + tilt_s*np.sin(phi_w)); tilt_x = -(-tilt_c*np.sin(phi_w) + tilt_s*np.cos(phi_w))
    # the mean pitching moment, SIGNED about the axis across the wind: e_m = n x w_hat (w_hat = +x, where the wind blows)
    e_m = np.cross(n, [1.0, 0.0, 0.0]); emn = np.linalg.norm(e_m); e_m = e_m/emn if emn > 1e-9 else np.array([0.0, 1.0, 0.0])
    Cm_s = float((f.Mx_Nm*e_m[0] + f.My_Nm*e_m[1] + f.Mz_Nm*e_m[2]).mean()/(q*A*D))
    ca = -n[0]; cd_env = 0.25 + ((CD_BOWL if ca > 0 else CD_BACK) - 0.25)*ca*ca
    rows.append(dict(run=os.path.basename(d), dx=dx, el=el, az=az, theta_w=theta_w, Cd=float(f.Cd.mean()), Cd_env=float(cd_env), Cl=float(f.Cl.mean()),
                     Cn=float(Fn.mean()/(q*A)), Ct=float(Ft.mean()/(q*A)), Cm=float(Mmag.mean()/(q*A*D)), Cm_rms=float(Mmag.std()/(q*A*D)),
                     Cp_net=float(mean_map.mean()), n0=amps[0], n1=amps[1], n2=amps[2], n3=amps[3],
                     film_mrad=float(1e3*np.sqrt(tot)), k_film=float(np.sqrt(tot)/U**2), k_film_env=2.63e-5, t_s=float(f.t_s.max()),
                     tilt1=float(tilt_w/U**2), tilt1_x=float(tilt_x/U**2), tilt1_mrad=float(1e3*tilt_w), k_fig=float(np.sqrt(fig)/U**2), fig_mrad=float(1e3*np.sqrt(fig)), Cm_s=Cm_s))
T = pd.DataFrame(rows).sort_values(["theta_w", "dx"])
pd.set_option("display.width", 250); print(T.drop(columns=["run", "k_film_env", "tilt1", "k_fig", "tilt1_x"]).round(3).to_string(index=False))
json.dump(rows, open(f"{S}/dish_table.json", "w"), indent=1); print("->", f"{S}/dish_table.json")

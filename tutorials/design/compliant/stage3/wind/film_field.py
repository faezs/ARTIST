"""THE WIND'S FIGURE AS A FIELD ON THE TRI MACHINE'S FILM: the LES pressure maps (24 rings x 48 azimuths, both faces, 14
attitudes at 4 cm, 12 m/s) -> the linear prestressed membrane's deflection w(r, phi) by harmonics n = 0..3 (the n = 0
part through the sealed plenum's 0.03) -> the surface slopes at the kernel's 512 ray points -> the kernel's per-ray
deviation (du = 2 w_x, de = -2 w_y, sigb = 1: a slope (w_x, w_y) turns the reflected ray by (-2 w_x, -2 w_y), an incident
deviation (dx, dy) = (-u, e) reflects to itself; calibrated in deep_relay's twin) on top of the film's own static figure as a
Gaussian. Traced at the tri machine's working level (4.75, f 4.05) at the mount-law pose, the kernel's fixed sun offset, over
the year, with the wind from the west at the site's 99th-percentile 5.2 m/s and at 9 m/s, at the working tension 4922 N/m
and at the rim-fed film's 2100 (the figure goes as 1/T). For each hour the LES attitude nearest in theta_w is taken and its
map turned about the dish axis so that its wind projection lies along the hour's (the bowl is axisymmetric; the roll
about the axis relative to the ground is the approximation). The isotropic Gaussian of the same rms is traced beside the
field: that is the question - does the coherent n = 1, 2 shape pass the strip's 27x and the collar like a blur?
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. .../python design/compliant/stage3/wind/film_field.py"""
import os, sys, re, glob, numpy as np, pandas as pd, torch
sys.argv = [sys.argv[0]]
HERE = os.path.dirname(os.path.abspath(__file__))
exec(open(os.path.join(HERE, "..", "deep", "deep_greg.py")).read().split("results = {}")[0])
src = open(os.path.join(HERE, "dish_table.py")).read().split("rows = []")[0]; exec(src)          # membrane_response, slope_rms_w, a, q, U, T_WORK
from tandoor_site_wind import bearing_vec
T_LES, U_LES = T_WORK, U
PLENUM_SEALED = 0.03
SIG_FILM, SIG_PRINT = 2.0e-3, 0.8e-3                      # the envs' static figure: 2 mrad of film slope and 0.8 of print, both doubled on reflection
SIG_STATIC = float(np.sqrt((2*SIG_FILM)**2 + (2*SIG_PRINT)**2))
SIG_FILM1 = float(np.sqrt((2*1.0e-3)**2 + (2*SIG_PRINT)**2))
LV = 4.75

# ---------------------------------------------------------------- the LES maps as harmonics in a wind-aligned basis
maps = []
for d in sorted(glob.glob(f"{HERE}/runs/dish_les*dx004")):
    p = pd.read_csv(f"{d}/pressure.csv"); g = pd.read_csv(f"{d}/probes.csv")
    fr = p[[c for c in p.columns if c.startswith("f")]].values; bk = p[[c for c in p.columns if c.startswith("b")]].values
    cp = (fr - bk).reshape(len(p), 24, 48).mean(0); th = 2*np.pi*np.arange(48)/48; rings = g.rho_over_a.values.reshape(24, 48)[:, 0]*a
    m = re.search(r"el(\d+)_az(\d+)", d); el, az = float(m.group(1)), float(m.group(2))
    n = np.array([np.cos(np.radians(el))*np.cos(np.radians(az)), np.cos(np.radians(el))*np.sin(np.radians(az)), np.sin(np.radians(el))])
    theta_w = float(np.degrees(np.arccos(-n[0])))
    e1 = np.cross(n, [0.0, 1.0, 0.0]); e1 /= np.linalg.norm(e1); e2 = np.cross(n, e1)
    wp = np.array([1.0, 0.0, 0.0]) - n[0]*n; wp = wp/np.linalg.norm(wp); phi_w = float(np.arctan2(wp @ e2, wp @ e1))
    harm = {}
    for k in range(0, 4):
        cn = (cp*np.cos(k*th)).mean(1)*(2 if k else 1); sn = (cp*np.sin(k*th)).mean(1)*(2 if k else 1)
        # turn the harmonic so that theta' = 0 is the wind's projection: cos(k(theta' + phi_w)) ...
        c2 = cn*np.cos(k*phi_w) + sn*np.sin(k*phi_w); s2 = -cn*np.sin(k*phi_w) + sn*np.cos(k*phi_w)
        harm[k] = (c2, s2)
    maps.append(dict(run=os.path.basename(d), theta_w=theta_w, harm=harm, rings=rings))
maps.sort(key=lambda m: m["theta_w"])
print("LES maps by theta_w:", [f"{m['theta_w']:.0f}" for m in maps])

def field(mp, V, T, xy, phi_h):
    """the surface slopes (w_x, w_y) in the dish frame at the points xy (P,2) for the map mp at wind V and tension T, the
    wind's projection at azimuth phi_h in the dish frame; returns slopes (P,2) and the field's slope rms"""
    scale = (V/U_LES)**2*(T_LES/T)
    r_pt = np.hypot(xy[:, 0], xy[:, 1]); ph = np.arctan2(xy[:, 1], xy[:, 0]) - phi_h
    wr = np.zeros(len(r_pt)); wt = np.zeros(len(r_pt))
    for k, (c2, s2) in mp["harm"].items():
        rc, wc = membrane_response(k, c2*q, mp["rings"]); rs, ws = membrane_response(k, s2*q, mp["rings"])
        if k == 0: wc = wc*PLENUM_SEALED; ws = ws*0.0                                   # the n = 0 load through the sealed plenum
        dwc = np.gradient(wc, rc); dws = np.gradient(ws, rs)
        wc_i = np.interp(r_pt, rc, wc); ws_i = np.interp(r_pt, rs, ws); dwc_i = np.interp(r_pt, rc, dwc); dws_i = np.interp(r_pt, rs, dws)
        wr += dwc_i*np.cos(k*ph) + dws_i*np.sin(k*ph)
        wt += k*(-wc_i*np.sin(k*ph) + ws_i*np.cos(k*ph))/np.maximum(r_pt, 1e-3)
    wr *= scale; wt *= scale; phw = ph + phi_h
    wx = wr*np.cos(phw) - wt*np.sin(phw); wy = wr*np.sin(phw) + wt*np.cos(phw)
    return np.stack([wx, wy], 1), float(np.sqrt(np.mean(wx*wx + wy*wy)))

v, drv = build(); B = drv.num_agents; dev = drv.device; L, P, _ = drv._pts_l.shape
xy = drv._pts_l[L//2, :, :2].detach().cpu().numpy().astype(np.float64)
w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
w_to = bearing_vec(270.0).numpy().astype(np.float64)                                                   # the site's wind from the west, blowing east
DAYS = {"midwinter": 355.0, "equinox": 80.0, "midsummer": 172.0}; HRS = [8, 9, 10, 11, 12, 13, 14, 15, 16]
g = torch.Generator().manual_seed(5); gs = torch.randn(2, B, P, generator=g)                          # one static draw for every column
def trace_with(C, n, sig_static, slopes=None, iso=None):
    du = gs[0]*sig_static; de = gs[1]*sig_static
    if slopes is not None:
        du = du + torch.as_tensor(2*slopes[:, 0], dtype=torch.float32)[None]; de = de - torch.as_tensor(2*slopes[:, 1], dtype=torch.float32)[None]
    if iso is not None:
        g2 = torch.randn(2, B, P, generator=g); du = du + g2[0]*iso; de = de + g2[1]*iso
    drv._tr["du"] = du.to(dev); drv._tr["de"] = de.to(dev)
    thr, out6, per = drv.trace(C.contiguous(), n.contiguous(), torch.full((B,), LV, device=dev), torch.full((B,), 1.0, device=dev))
    fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
    return float(((fate == 0).float()*w_ray[None]).sum(1).mean())
COLS = ["static 4.3 (2 film + 0.8 print), no wind", "+ field 5.2 m/s, T 4922", "+ field 5.2, T 2100 (fed)", "+ iso of the same rms, T 2100", "+ field 9 m/s, T 2100", "film 1 mrad + field 5.2, T 2100", "film 1 mrad + field 9, T 2100"]
print(f"\nrays through, the tri machine at level {LV} (f 4.05), the mount-law pose, the kernel's fixed sun offset; wind from the west")
print(f"{'day':<10} {'hour':>4} {'el':>5} {'theta_w':>7} {'map':>4} {'fld rms mrad @5.2 T2100':>24} | " + " ".join(f"{c[:26]:>26}" for c in COLS))
tot = {c: 0.0 for c in COLS}; tot["w"] = 0.0
for dname, day in DAYS.items():
    for hour in HRS:
        day_t = torch.full((B,), day, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
        m0 = drv._mount(day_t, lat_t, float(hour), pnt=None, mech=False); el = float(m0["aux"][0, 0])
        if el < 12.0: continue
        pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
        m = drv._mount(day_t, lat_t, float(hour), pnt=pnt, mech=False); C = m["Cd"].clone(); nax = m["Mt"][:, 2, :].clone()
        elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
        drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
        drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
        Mt = m["Mt"][0].detach().cpu().numpy().astype(np.float64); n_h = Mt[2]; xl, yl = Mt[0], Mt[1]
        theta_w = float(np.degrees(np.arccos(np.clip(-(n_h @ w_to), -1, 1))))
        wp = w_to - (w_to @ n_h)*n_h; wp = wp/max(np.linalg.norm(wp), 1e-9); phi_h = float(np.arctan2(wp @ yl, wp @ xl))
        mp = min(maps, key=lambda mm: abs(mm["theta_w"] - theta_w))
        sl52_T, rms52_T = field(mp, 5.2, T_LES, xy, phi_h); sl52, rms52 = field(mp, 5.2, 2100.0, xy, phi_h); sl9, rms9 = field(mp, 9.0, 2100.0, xy, phi_h)
        vals = [trace_with(C, nax, SIG_STATIC), trace_with(C, nax, SIG_STATIC, sl52_T), trace_with(C, nax, SIG_STATIC, sl52),
                trace_with(C, nax, SIG_STATIC, iso=2*rms52/np.sqrt(2)), trace_with(C, nax, SIG_STATIC, sl9),
                trace_with(C, nax, SIG_FILM1, sl52), trace_with(C, nax, SIG_FILM1, sl9)]
        w = max(np.sin(np.radians(el)), 0.0); tot["w"] += w
        for c, x in zip(COLS, vals): tot[c] += x*w
        print(f"{dname:<10} {hour:4d} {el:5.1f} {theta_w:7.0f} {mp['theta_w']:4.0f} {1e3*rms52:8.2f} ({1e3*rms9:5.2f} at 9) | " + " ".join(f"{100*x:25.1f}%" for x in vals), flush=True)
print("\nsin(el)-weighted year means:")
for c in COLS: print(f"   {c:<44} {100*tot[c]/tot['w']:5.1f} %")
v.close()

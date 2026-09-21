"""Quetta's wind from ERA5 (the reanalysis Google's GraphCast/GenCast are trained on and initialised from), at a point
through Open-Meteo's archive API: hourly 10 m speed and direction, 10 m gusts, 100 m speed, 2013-2022. What the envs
assumed: a mean of 9-12 m/s for design, Iu 0.25 (L 50 m), the wind from the SOUTH, stow above 15 m/s."""
import sys, json, urllib.request, numpy as np, pandas as pd
out = sys.argv[1]
frames = []
for y in range(2013, 2023):
    url = (f"https://archive-api.open-meteo.com/v1/archive?latitude=30.2&longitude=67.0&start_date={y}-01-01&end_date={y}-12-31"
           "&hourly=wind_speed_10m,wind_direction_10m,wind_gusts_10m,wind_speed_100m&wind_speed_unit=ms&timezone=Asia/Karachi&models=era5")
    j = json.load(urllib.request.urlopen(url, timeout=120)); h = j["hourly"]
    frames.append(pd.DataFrame(dict(t=pd.to_datetime(h["time"]), U=h["wind_speed_10m"], dir=h["wind_direction_10m"], gust=h["wind_gusts_10m"], U100=h["wind_speed_100m"])))
    print(f"   {y}: {len(h['time'])} h", flush=True)
d = pd.concat(frames).dropna(); d.to_csv(f"{out}/quetta_era5_2013_2022.csv", index=False)
d["hour"] = d.t.dt.hour + 0.5; d["month"] = d.t.dt.month
work = d[(d.hour >= 7.5) & (d.hour <= 16.5)]
print(f"\n{len(d)} hours, {len(work)} in the working day (07:30-16:30 local), ERA5 grid point 30.25 N 67.0 E, 1667 m")
q = work.U.quantile([0.5, 0.9, 0.95, 0.99]); print(f"10 m wind in the working day: mean {work.U.mean():.2f} m/s, median {q[0.5]:.2f}, 90 % {q[0.9]:.2f}, 95 % {q[0.95]:.2f}, 99 % {q[0.99]:.2f}, max {work.U.max():.1f}")
for lim in (9.0, 12.0, 15.0): print(f"   working hours with U >= {lim:.0f} m/s: {100*np.mean(work.U >= lim):.2f} %   (gust >= {lim:.0f}: {100*np.mean(work.gust >= lim):.2f} %)")
G = work.gust/work.U.clip(lower=0.5); print(f"gust factor (3 s gust / hourly mean) in the working day: median {G.median():.2f} -> Iu ~ (G-1)/3 = {(G.median()-1)/3:.2f} (the envs assume 0.25); at U >= 6 m/s: {((work.gust/work.U)[work.U >= 6].median()-1)/3:.2f}")
print(f"shear 100 m / 10 m in the working day: median {(work.U100/work.U.clip(lower=0.5)).median():.2f}")
bins = [(337.5, 22.5, "N"), (22.5, 67.5, "NE"), (67.5, 112.5, "E"), (112.5, 157.5, "SE"), (157.5, 202.5, "S"), (202.5, 247.5, "SW"), (247.5, 292.5, "W"), (292.5, 337.5, "NW")]
def rose(x, w=None):
    outp = []
    for lo, hi, nm in bins:
        m = ((x.dir >= lo) & (x.dir < hi)) if lo < hi else ((x.dir >= lo) | (x.dir < hi))
        outp.append(f"{nm} {100*np.mean(m):.0f}%" if w is None else f"{nm} {100*np.sum(m*w)/np.sum(w):.0f}%")
    return "  ".join(outp)
print("direction the wind comes FROM in the working day, by hours:      " + rose(work))
print("                                        weighted by U^2 (the load): " + rose(work, work.U**2))
strong = work[work.U >= 9]; print("                                        when U >= 9 m/s:              " + rose(strong))
print("\nby month (working day): mean U, 95 %, hours >= 12, >= 15, and the load-weighted direction mode")
for m in range(1, 13):
    w = work[work.month == m]; lo, hi, nm = max(bins, key=lambda b: np.sum(((w.dir >= b[0]) & (w.dir < b[1]) if b[0] < b[1] else ((w.dir >= b[0]) | (w.dir < b[1])))*w.U**2))
    print(f"   {m:2d}: {w.U.mean():4.1f} m/s, 95 % {w.U.quantile(0.95):4.1f}, >=12: {100*np.mean(w.U >= 12):4.1f} %, >=15: {100*np.mean(w.U >= 15):4.1f} %, from {nm}")
print("\ndiurnal (all months): mean U by local hour 06-18:", " ".join(f"{h}h {d[d.hour == h + 0.5].U.mean():.1f}" for h in range(6, 19)))

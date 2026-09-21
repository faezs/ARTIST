"""REALISTIC WEATHER FOR ANY SITE ON EARTH, for training: ERA5 at the point, hourly, any year since 1940,
through Open-Meteo's archive (free, no account) - the joint series the tandoor envs need to play a
sampled site's real days: beam irradiance (DNI), global and diffuse, cloud cover, 10 m and 100 m wind,
3 s gusts, 2 m temperature. Cached as npz per (lat, lon, years) so a design run's random site costs one
request the first time and nothing after.

    site_weather(lat, lon, years=(2018, 2022)) -> dict of hourly arrays (local solar time = UTC + lon/15)
    python site_weather.py LAT LON [Y0 Y1]      -> summary: DNI climatology by month and hour, wind

Why not a weather MODEL for this: the open Google weights (GraphCast, GenCast, WeatherNext 2) output no cloud
or radiation at all; WeatherNext 3 does but is not open (forecast data only, allowlisted). A reanalysis IS the
realistic climate at the point; the models are for forecasting a given day, not for sampling the climate.
"""
import os, sys, json, time, urllib.request, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); D = os.path.join(HERE, "data", "sites"); os.makedirs(D, exist_ok=True)
HOURLY = ["direct_normal_irradiance", "shortwave_radiation", "diffuse_radiation", "cloud_cover", "wind_speed_10m", "wind_direction_10m", "wind_gusts_10m", "wind_speed_100m", "temperature_2m"]
KEYS = ["dni", "ghi", "dhi", "cloud", "U10", "dir10", "gust10", "U100", "T2"]


def _fetch(lat, lon, y0, y1, retries=4):
    url = (f"https://archive-api.open-meteo.com/v1/archive?latitude={lat}&longitude={lon}&start_date={y0}-01-01&end_date={y1}-12-31"
           f"&hourly={','.join(HOURLY)}&wind_speed_unit=ms&timezone=UTC&models=era5")
    for k in range(retries):
        try: return json.load(urllib.request.urlopen(url, timeout=180))
        except Exception as e:
            if k == retries - 1: raise
            time.sleep(5 * (k + 1))


def site_weather(lat, lon, years=(2018, 2022)):
    """hourly ERA5 at (lat, lon) for the years, local solar time; cached"""
    lat, lon = round(float(lat), 2), round(float(lon), 2); y0, y1 = years
    p = f"{D}/era5_{lat}_{lon}_{y0}_{y1}.npz"
    if os.path.exists(p):
        z = np.load(p); return {k: z[k] for k in z.files}
    j = _fetch(lat, lon, y0, y1); h = j["hourly"]
    t_utc = np.array(h["time"], dtype="datetime64[m]")
    out = {k: np.array([np.nan if v is None else v for v in h[name]], np.float32) for k, name in zip(KEYS, HOURLY)}
    out["t_utc"] = t_utc; out["t_local"] = t_utc + np.timedelta64(int(round(lon / 15 * 60)), "m")   # local SOLAR time, the envs' clock
    out["elevation"] = np.float32(j["elevation"]); out["lat"] = np.float32(lat); out["lon"] = np.float32(lon)
    np.savez(p, **out); return out


def summary(w):
    tl = w["t_local"].astype("datetime64[h]"); month = (tl.astype("datetime64[M]").astype(int) % 12) + 1; hour = (tl.astype(int) % 24)
    day = (hour >= 8) & (hour <= 16)
    print(f"ERA5 at {w['lat']} N {w['lon']} E, elevation {w['elevation']:.0f} m, {len(tl)} hours, local solar time")
    print("month:  DNI mean 08-16 h (W/m2)  clear-ish days (DNI at 12 h > 700) %  cloud mean %  U10 mean 08-16  gust 95 %")
    for m in range(1, 13):
        s = (month == m) & day; noon = (month == m) & (hour == 12)
        print(f"  {m:2d}     {np.nanmean(w['dni'][s]):6.0f}                  {100*np.nanmean(w['dni'][noon] > 700):5.0f}                     {np.nanmean(w['cloud'][s]):4.0f}       {np.nanmean(w['U10'][s]):4.1f}        {np.nanpercentile(w['gust10'][s], 95):4.1f}")
    e_day = np.nansum(w["dni"][day]) / 1000 / (len(tl) / 24); print(f"beam energy on a tracked aperture, 08-16 h: {e_day:.2f} kWh/m2/day on average")


if __name__ == "__main__":
    lat, lon = float(sys.argv[1]), float(sys.argv[2]); years = (int(sys.argv[3]), int(sys.argv[4])) if len(sys.argv) > 4 else (2018, 2022)
    t = time.time(); w = site_weather(lat, lon, years); print(f"({time.time() - t:.0f} s)"); summary(w)

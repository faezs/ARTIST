"""THE SITE'S OWN WEATHER (user, 2026-09-12): a tandoor at a randomly sampled place on earth should
cook under that place's sun and wind, not a clear-sky formula with a lognormal cloud. ERA5 at the
point - hourly beam irradiance (DNI), 10 m wind, 3 s gusts - through Open-Meteo's archive (free, no
account), cached per site, and served to the envs as ONE RECORDED DAY per agent per day: 24 hourly
values each of DNI, wind and gust in the site's local solar time, drawn near the agent's day of the
year from the site's years on file. Both twins interpolate the same table with the same formula
(numpy `sw_interp24`, MSL in step_pre), so the parity gates still hold.

    SiteWeather(pool)            pool = "quetta" | path to a pool JSON {"sites": [{lat, lon, name}], "years": [y0, y1]}
      .sample(B, rng)            site indices for B agents
      .draw(site_idx, doy, rng)  (B, 4, 24) float32: [dni W/m2, U10 m/s, gust m/s, wind FROM deg] by local solar hour
      .mean_day(site_idx, doy)   the same table averaged over the site's days near doy (the design tools' deterministic day)
      .lat / .lon                per site
    build_pool(n, years, out)    n land sites uniform on the sphere (|lat| <= lat_max) with their ERA5 on file

    python tandoor_site_weather.py build --n 64 --years 2021 2022 --out data/tandoor/site_pool.json
    python tandoor_site_weather.py check quetta       # the tables against the raw record

Conventions: DNI from Open-Meteo is the mean of the PRECEDING hour, so table column h is the mean over
local hour [h, h+1) and the envs read it at h + 0.5; wind is instantaneous at the hour, read at h.
Local solar time = UTC + lon/15 h. Why not a weather model: the open Google weights (GraphCast,
GenCast, WeatherNext 2) output no cloud or radiation; WeatherNext 3 does but is not open. A
reanalysis IS the climate at the point; a model forecasts a day.
"""
import os, sys, json, time, urllib.request, numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, "data", "tandoor"); SITES = os.path.join(DATA, "sites")
HOURLY = ["direct_normal_irradiance", "shortwave_radiation", "diffuse_radiation", "cloud_cover", "wind_speed_10m", "wind_direction_10m", "wind_gusts_10m", "wind_speed_100m", "temperature_2m"]
KEYS = ["dni", "ghi", "dhi", "cloud", "U10", "dir10", "gust10", "U100", "T2"]
QUETTA = {"sites": [dict(lat=30.2, lon=67.0, name="Quetta")], "years": [2018, 2022]}
_QP = os.path.join(DATA, "site_pool_quetta.json")                                     # the 13 tandoor shops of quetta_tandoor_pois.json, with their neighbourhoods
POOLS = {"quetta": (json.load(open(_QP)) if os.path.exists(_QP) else QUETTA)}


def _fetch(lat, lon, y0, y1, retries=8):
    url = (f"https://archive-api.open-meteo.com/v1/archive?latitude={lat}&longitude={lon}&start_date={y0}-01-01&end_date={y1}-12-31"
           f"&hourly={','.join(HOURLY)}&wind_speed_unit=ms&timezone=UTC&models=era5")
    for k in range(retries):
        try:
            return json.load(urllib.request.urlopen(url, timeout=180))
        except Exception as e:
            if k == retries - 1: raise
            is_429 = getattr(e, "code", None) == 429                       # Open-Meteo's rate limit: back off for a minute or more
            time.sleep((60 + 60 * k) if is_429 else 5 * (k + 1))


def fetch_era5(lat, lon, y0, y1, cache=SITES):
    """hourly ERA5 at the point for the years, cached as npz; times in UTC"""
    lat, lon = round(float(lat), 2), round(float(lon), 2); os.makedirs(cache, exist_ok=True)
    p = f"{cache}/era5_{lat}_{lon}_{y0}_{y1}.npz"
    if os.path.exists(p):
        z = np.load(p); return {k: z[k] for k in z.files}
    j = _fetch(lat, lon, y0, y1); h = j["hourly"]
    out = {k: np.array([np.nan if v is None else v for v in h[name]], np.float32) for k, name in zip(KEYS, HOURLY)}
    out["t_utc"] = np.array(h["time"], dtype="datetime64[m]")
    out["elevation"] = np.float32(j["elevation"]); out["lat"] = np.float32(lat); out["lon"] = np.float32(lon)
    np.savez(p, **out); return out


# ======================================================================================
# THE NEIGHBOURHOOD (user, 2026-09-12: "this doesn't get us close to neighbourhood level wind"):
# ERA5's 10 m wind is a 28 km cell mean. The dish sits on a roof between other roofs. Building
# footprints within FOOT_R of the site (Microsoft Global ML Building Footprints, OSM as the
# fallback) give the canopy's plan-area fraction lam_p, mean height h and frontal-area index
# lam_f; Macdonald et al. (1998) turn those into the displacement height d and roughness z0 of
# the canopy; the wind at the dish (z = the roof + z_dish) follows the log law down from ERA5's
# 100 m wind, which sits above the roughness sublayer; the turbulence intensity 1/ln((z-d)/z0)
# sets the mechanical gust factor 1 + 3 Iu, and the larger of that and ERA5's own (convective)
# gust ratio is the gust. This replaces the constant wall_shelter = 0.4 the envs used for every
# site (the twins set it to 1 when a site table is on). No footprints on file -> open terrain.
# The mesoscale terrain factor (Global Wind Atlas, 250 m) is NOT applied: DTU's point API
# needs a key (EMD); ERA5's own orography is what the cell knows.
# ======================================================================================
FOOT_R = 250.0                 # m: the neighbourhood radius
H_LEVEL = 3.0                  # m per storey when only levels are tagged
H_DEFAULT = 6.0                # m: an untagged building (two storeys)
Z_DISH = 4.0                   # m above the roof: the dish hub (env_kwargs deck_h)
MS_INDEX = "https://minedbuildings.z5.web.core.windows.net/global-buildings/dataset-links.csv"
FOOT_DIR = os.path.join(DATA, "footprints"); MS_TILE_MAX_MB = 150.0


def _quadkey(lat, lon, z=9):
    import math
    x = int((lon + 180.0) / 360.0 * 2 ** z); sn = math.sin(math.radians(lat))
    y = int((0.5 - math.log((1 + sn) / (1 - sn)) / (4 * math.pi)) * 2 ** z)
    return "".join(str(((x >> (z - i)) & 1) | (((y >> (z - i)) & 1) << 1)) for i in range(1, z + 1))


def _ms_tile(lat, lon):
    """the Microsoft footprints tile covering the point, downloaded once (None if there is none or it is too big)"""
    import csv, io, gzip
    os.makedirs(FOOT_DIR, exist_ok=True); idx = f"{FOOT_DIR}/dataset-links.csv"
    if not os.path.exists(idx) or time.time() - os.path.getmtime(idx) > 30 * 86400:
        open(idx, "wb").write(urllib.request.urlopen(MS_INDEX, timeout=180).read())
    qk = _quadkey(lat, lon)
    rows = [r for r in csv.DictReader(open(idx)) if r["QuadKey"] == qk]
    if not rows: return None
    r = rows[0]; sz = r["Size"].strip(); mb = float(sz[:-2]) * (1.0 if sz.endswith("MB") else 1e-3 if sz.endswith("KB") else 1e3)
    if mb > MS_TILE_MAX_MB: print(f"   footprints tile {qk} ({r['Location']}) is {mb:.0f} MB > {MS_TILE_MAX_MB:.0f}: skipped", flush=True); return None
    p = f"{FOOT_DIR}/{qk}_{r['Location']}.csv.gz"
    if not os.path.exists(p):
        open(p, "wb").write(urllib.request.urlopen(r["Url"], timeout=600).read())
    return p


def _poly_area_m2(coords, lat0):
    """shoelace on an equirectangular projection about lat0; coords [[lon, lat], ...]"""
    kx = 111320.0 * np.cos(np.radians(lat0)); ky = 110540.0
    x = np.array([c[0] for c in coords]) * kx; y = np.array([c[1] for c in coords]) * ky
    return 0.5 * abs(np.dot(x, np.roll(y, -1)) - np.dot(y, np.roll(x, -1)))


def _ms_buildings(path, lat, lon, r=FOOT_R):
    """[(area m2, height m or None)] of the tile's buildings within r of the point"""
    import gzip, re
    dlat = r / 110540.0; dlon = r / (111320.0 * np.cos(np.radians(lat)))
    pat = re.compile(r"\[\s*(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)"); out = []
    with gzip.open(path, "rt") as fh:
        for line in fh:
            m = pat.search(line)
            if not m: continue
            x, y = float(m.group(1)), float(m.group(2))
            if abs(x - lon) > dlon or abs(y - lat) > dlat: continue
            try: j = json.loads(line.strip().rstrip(","))
            except ValueError: continue
            g = j.get("geometry", j); ring = g["coordinates"][0] if g.get("type") == "Polygon" else g["coordinates"][0][0]
            cx, cy = float(np.mean([c[0] for c in ring])), float(np.mean([c[1] for c in ring]))
            if ((cx - lon) * 111320.0 * np.cos(np.radians(lat))) ** 2 + ((cy - lat) * 110540.0) ** 2 > r * r: continue
            h = j.get("properties", {}).get("height", -1); h = float(h) if h not in (None, "", -1, -1.0) and float(h) > 0 else None
            out.append((_poly_area_m2(ring, lat), h))
    return out


def _osm_buildings(lat, lon, r=FOOT_R):
    import urllib.parse
    q = f'[out:json][timeout:60];way["building"](around:{r:.0f},{lat},{lon});out geom;'
    for url in ("https://overpass-api.de/api/interpreter", "https://overpass.kumi.systems/api/interpreter"):
        try:
            req = urllib.request.Request(url, data=urllib.parse.urlencode({"data": q}).encode(), headers={"User-Agent": "tandoor-site-weather/1.0"})
            j = json.load(urllib.request.urlopen(req, timeout=90)); break
        except Exception: j = None
    if not j: return []
    out = []
    for w in j.get("elements", []):
        if w.get("type") != "way" or "geometry" not in w: continue
        ring = [[g["lon"], g["lat"]] for g in w["geometry"]]; t = w.get("tags", {}); h = None
        try:
            if t.get("height"): h = float(str(t["height"]).split()[0])
            elif t.get("building:levels"): h = float(t["building:levels"]) * H_LEVEL
        except ValueError: h = None
        out.append((_poly_area_m2(ring, lat), h))
    return out


def morphology(buildings, r=FOOT_R):
    """Macdonald et al. (1998): the canopy's plan-area fraction, mean height, frontal-area index ->
    displacement height d and roughness length z0. Open terrain when there are too few buildings."""
    A_lot = np.pi * r * r; n = len(buildings)
    if n < 8:
        return dict(n=n, lam_p=0.0, lam_f=0.0, h=3.5, d=0.0, z0=0.10, source_note="open terrain (fewer than 8 footprints)")
    area = np.array([a for a, _ in buildings]); hs = np.array([h if h is not None else H_DEFAULT for _, h in buildings])
    lam_p = float(np.clip(area.sum() / A_lot, 0.0, 0.9)); h = float(np.average(hs, weights=area))
    w = 1.1 * np.sqrt(area)                                          # the mean frontal width of a footprint over all wind directions
    lam_f = float(np.clip((hs * w).sum() / A_lot, 0.0, 2.0))
    A, beta, CD, kap = 4.43, 1.0, 1.2, 0.4
    d_h = 1.0 + A ** (-lam_p) * (lam_p - 1.0)
    z0_h = (1.0 - d_h) * np.exp(-(0.5 * beta * CD / kap ** 2 * (1.0 - d_h) * max(lam_f, 1e-3)) ** (-0.5))
    return dict(n=n, lam_p=lam_p, lam_f=lam_f, h=h, d=float(d_h * h), z0=float(np.clip(z0_h * h, 0.03, 3.0)), h_tagged=int(sum(1 for _, hh in buildings if hh is not None)))


def neighbourhood(lat, lon, cache=SITES, force=False):
    """the site's canopy morphology and its wind factors at the dish, cached as JSON"""
    lat, lon = round(float(lat), 2), round(float(lon), 2); os.makedirs(cache, exist_ok=True)
    p = f"{cache}/urban_{lat}_{lon}.json"
    if os.path.exists(p) and not force: return json.load(open(p))
    src = "none"; b = []
    try:
        tile = _ms_tile(lat, lon)
        if tile: b = _ms_buildings(tile, lat, lon); src = "microsoft"
    except Exception as e: print(f"   footprints: Microsoft tile failed ({type(e).__name__}: {str(e)[:60]})", flush=True)
    if len(b) < 8:
        bo = _osm_buildings(lat, lon)
        if len(bo) > len(b): b, src = bo, "osm"
    m = morphology(b); m.update(lat=lat, lon=lon, source=src, r=FOOT_R)
    z = m["h"] + Z_DISH; m["z"] = z
    m["K100"] = float(np.log((z - m["d"]) / m["z0"]) / np.log((100.0 - m["d"]) / m["z0"]))    # U(z) / U100
    m["iu"] = float(np.clip(1.0 / np.log((z - m["d"]) / m["z0"]), 0.08, 0.6))
    json.dump(m, open(p, "w"), indent=1); return m


def day_tables(rec, urban=None):
    """the record as (n_days, 24) tables in LOCAL SOLAR time: dni (mean over the local hour), U10 and
    gust (at the local hour), plus the day-of-year of each local day. With `urban` (neighbourhood()),
    U10/gust become the wind and gust AT THE DISH: the log law down from ERA5's 100 m wind through
    the canopy's d and z0, the gust the larger of ERA5's convective ratio and 1 + 3 Iu."""
    lon = float(rec["lon"]); t = rec["t_utc"].astype("datetime64[m]")
    h_utc = (t - np.datetime64("1970-01-01T00:00", "m")).astype(np.int64) / 60.0      # hours since the epoch, UTC
    h_loc = h_utc + lon / 15.0                                                          # local solar hours
    d0 = int(np.ceil(h_loc[0] / 24.0)); d1 = int(np.floor(h_loc[-1] / 24.0)) - 1        # whole local days on file
    days = np.arange(d0, d1 + 1); n = days.size
    q = (days[:, None] * 24.0 + np.arange(24)[None, :]).ravel()                       # local hour starts
    fill = lambda a: np.nan_to_num(a.astype(np.float64), nan=0.0)
    dni = np.interp(q + 0.5, h_loc - 0.5, fill(rec["dni"])).reshape(n, 24)              # preceding-hour mean centred at h - 0.5
    U10 = fill(rec["U10"]); G10 = fill(rec["gust10"])
    if urban is not None:
        U100 = fill(rec["U100"]) if "U100" in rec else U10 * (np.log(100.0 / 0.1) / np.log(10.0 / 0.1))
        U100 = np.where(U100 > 0.05, U100, U10 * 1.5)
        Uz = U100 * urban["K100"]                                                        # the wind at the dish
        Gz = Uz * np.maximum(np.where(U10 > 0.2, G10 / np.maximum(U10, 0.2), 1.0), 1.0 + 3.0 * urban["iu"])
        U10, G10 = Uz, Gz
    u10 = np.interp(q, h_loc, U10).reshape(n, 24)
    gst = np.interp(q, h_loc, G10).reshape(n, 24)
    t2 = np.interp(q, h_loc, fill(rec["T2"])).reshape(n, 24)
    th = np.radians(fill(rec["dir10"])); wu, wv = -fill(rec["U10"]) * np.sin(th), -fill(rec["U10"]) * np.cos(th)   # the wind vector (blows TO): interpolate components, not angles
    wu = np.interp(q, h_loc, wu).reshape(n, 24); wv = np.interp(q, h_loc, wv).reshape(n, 24)
    date = (np.datetime64("1970-01-01") + days.astype("timedelta64[D]"))
    doy = (date - date.astype("datetime64[Y]")).astype(np.int64) + 1
    return dict(dni=dni.astype(np.float32), U10=u10.astype(np.float32), gust=np.maximum(gst, u10).astype(np.float32), T2=t2.astype(np.float32),
                wu=wu.astype(np.float32), wv=wv.astype(np.float32), doy=doy.astype(np.int64))


def _dir_from(wu, wv):
    """compass bearing the wind comes FROM, degrees, from the vector it blows to"""
    return (np.degrees(np.arctan2(-wu, -wv)) + 360.0) % 360.0


def sw_interp24(tab, x):
    """the twins' shared read of a 24-column table at fractional hour x in [0, 23]:
    i = min(floor(x), 22), f = x - i, tab[i] (1-f) + tab[i+1] f. tab (..., 24), x scalar or (...,)"""
    x = np.clip(np.asarray(x, np.float64), 0.0, 23.0); i = np.minimum(np.floor(x), 22.0).astype(np.int64); f = x - i
    tab = np.asarray(tab)
    if tab.ndim == 1: return tab[i] * (1.0 - f) + tab[i + 1] * f
    if np.ndim(i) == 0: return tab[..., i] * (1.0 - f) + tab[..., i + 1] * f
    ar = np.arange(tab.shape[0]); return tab[ar, i] * (1.0 - f) + tab[ar, i + 1] * f


class SiteWeather:
    def __init__(self, pool, years=None, window=7, cache=SITES, urban=True):
        spec = POOLS.get(str(pool).lower()) if isinstance(pool, str) and str(pool).lower() in POOLS else json.load(open(pool))
        self.sites = list(spec["sites"]); y0, y1 = years or spec.get("years", [2021, 2022]); self.years = (int(y0), int(y1)); self.window = int(window)
        self.lat = np.array([s["lat"] for s in self.sites], np.float64); self.lon = np.array([s["lon"] for s in self.sites], np.float64)
        # the neighbourhood per site: from the pool file when the build wrote it, else the cache, else computed now
        self.urban = [((s.get("urban") if isinstance(s.get("urban"), dict) else None) or neighbourhood(s["lat"], s["lon"], cache=cache)) if urban else None for s in self.sites]
        self.tabs = [day_tables(fetch_era5(s["lat"], s["lon"], *self.years, cache=cache), u) for s, u in zip(self.sites, self.urban)]
        self.n_sites = len(self.sites)
        # candidates by day of year: the days on file within +-window (circular)
        self._cand = []
        for tb in self.tabs:
            d = tb["doy"]; c = []
            for doy in range(1, 367):
                dist = np.abs(d - doy); dist = np.minimum(dist, 365 - dist)
                idx = np.nonzero(dist <= self.window)[0]; c.append(idx if idx.size else np.arange(d.size))
            self._cand.append(c)

    def sample(self, B, rng):
        return rng.integers(0, self.n_sites, size=B)

    def draw(self, site_idx, doy, rng):
        """(B, 4, 24): one recorded day per agent near its day of the year, at its site"""
        site_idx = np.asarray(site_idx, np.int64); doy = np.clip(np.asarray(doy, np.int64), 1, 366); B = site_idx.size
        out = np.zeros((B, 4, 24), np.float32)
        for b in range(B):
            s = int(site_idx[b]); c = self._cand[s][int(doy[b]) - 1]; k = int(c[rng.integers(0, c.size)])
            tb = self.tabs[s]; out[b, 0] = tb["dni"][k]; out[b, 1] = tb["U10"][k]; out[b, 2] = tb["gust"][k]; out[b, 3] = _dir_from(tb["wu"][k], tb["wv"][k])
        return out

    def mean_day(self, site_idx, doy):
        """(B, 4, 24): the site's AVERAGE day near doy over its years on file - the deterministic sky
        the design tools score a kit under (the expected beam, cloud losses included)"""
        site_idx = np.asarray(site_idx, np.int64); doy = np.clip(np.asarray(doy, np.int64), 1, 366); B = site_idx.size
        out = np.zeros((B, 4, 24), np.float32); memo = {}
        for b in range(B):
            key = (int(site_idx[b]), int(doy[b]))
            if key not in memo:
                s, d = key; c = self._cand[s][d - 1]; tb = self.tabs[s]
                memo[key] = np.stack([tb["dni"][c].mean(0), tb["U10"][c].mean(0), tb["gust"][c].mean(0), _dir_from(tb["wu"][c].mean(0), tb["wv"][c].mean(0))]).astype(np.float32)
            out[b] = memo[key]
        return out

    def describe(self):
        def one(s, u):
            t = f"{s.get('name', '?')} ({s['lat']:.1f}, {s['lon']:.1f})"
            if u: t += f" [{u['source']}: {u['n']} bldg, lam_p {u['lam_p']:.2f}, h {u['h']:.1f} m, d {u['d']:.1f}, z0 {u['z0']:.2f}, U/U100 {u['K100']:.2f}, Iu {u['iu']:.2f}]"
            return t
        return f"{self.n_sites} site(s), ERA5 {self.years[0]}-{self.years[1]}, +-{self.window} days, wind at the dish through the neighbourhood: " + "; ".join(one(s, u) for s, u in zip(self.sites[:4], (self.urban or [None] * 4)[:4])) + (" ..." if self.n_sites > 4 else "")


GEONAMES = "https://download.geonames.org/export/dump/cities15000.zip"
POP_CAP = 10_000_000            # a city's weight is min(pop, cap): where people are, without four Delhis in a pool of 64


def _cities(cache=DATA, full=False):
    """GeoNames cities15000: every town over 15 000 people - name, country, lat, lon, population"""
    import zipfile, io
    p = f"{cache}/cities15000.txt"
    if not os.path.exists(p):
        z = zipfile.ZipFile(io.BytesIO(urllib.request.urlopen(GEONAMES, timeout=300).read())); open(p, "wb").write(z.read("cities15000.txt"))
    out = []
    for line in open(p, encoding="utf-8"):
        f = line.rstrip("\n").split("\t")
        try: out.append((f[1], f[8], float(f[4]), float(f[5]), int(f[14]), f[10]))     # name, country, lat, lon, population, admin1
        except (ValueError, IndexError): pass
    return out


def build_pool(n, years, out, seed=0, lat_max=50.0, polite_s=4.0, weight="population", country=None, admin1=None, admin1_share=0.67):
    """n sites with their ERA5 on file. weight="population" (user, 2026-09-13: "population weight the
    pool"): a town drawn with probability proportional to its people (capped at POP_CAP), the site a
    random point within a radius that grows with the town (1.5 km at 100 k, cube-root) - a
    neighbourhood of a place where tandoors are, not a random patch of land. weight="area": uniform
    on the land within |lat| <= lat_max (the old pool: mostly empty country)."""
    rng = np.random.default_rng(seed); sites = []; t0 = time.time(); seen = set()
    if weight == "population":
        # country / admin1 (user, 2026-09-13: "sample in pakistan specifically, ideally balochistan"): the pool
        # is one country's towns, and admin1_share of it one province's (GeoNames admin1 code, PK.02 =
        # Balochistan). A province with fewer towns than sites repeats its towns at different points.
        cities = [c for c in _cities(full=True) if abs(c[2]) <= lat_max and c[4] > 0 and (country is None or c[1] == country)]
        prov = [c for c in cities if admin1 is not None and c[5] == admin1]
        rest = [c for c in cities if not (admin1 is not None and c[5] == admin1)]
        wp = np.array([min(c[4], POP_CAP) for c in prov], np.float64); wp = wp / wp.sum() if len(prov) else wp
        w = np.array([min(c[4], POP_CAP) for c in rest], np.float64); w /= w.sum()
        print(f"   {len(cities)} towns over 15 000 people{' in ' + country if country else ''}, {len(prov)} in admin1 {admin1} (share {admin1_share:.2f} of the pool)", flush=True)
    else:
        z = np.load(os.path.join(DATA, "land_mask_1deg.npz")); land, lats, lons = z["land"], z["lat"], z["lon"]
    while len(sites) < n:
        if weight == "population":
            in_prov = len(prov) > 0 and rng.uniform() < admin1_share
            c = prov[int(rng.choice(len(prov), p=wp))] if in_prov else rest[int(rng.choice(len(rest), p=w))]
            if c[0] in seen and not (in_prov and len(prov) < n): continue
            r_km = 1.5 * (c[4] / 1e5) ** (1.0 / 3.0); rr = r_km * np.sqrt(rng.uniform()); th = rng.uniform(0, 2 * np.pi)
            lat = c[2] + rr * np.cos(th) / 110.54; lon_s = c[3] + rr * np.sin(th) / (111.32 * np.cos(np.radians(c[2])))
            name, country, pop = c[0], c[1], c[4]
        else:
            lat = float(np.degrees(np.arcsin(rng.uniform(-np.sin(np.radians(lat_max)), np.sin(np.radians(lat_max))))))
            lon = float(rng.uniform(0.0, 360.0))
            if not land[int(np.argmin(np.abs(lats - lat))), int(np.argmin(np.abs(lons - lon)))]: continue
            lon_s = lon - 360.0 if lon > 180.0 else lon; name, country, pop = f"site{len(sites):03d}", "", 0
        rec = fetch_era5(lat, lon_s, *years)
        if not np.isfinite(rec["dni"]).any() or np.nanmax(rec["dni"]) <= 0: continue          # no sun on file (ocean cell after all)
        seen.add(name)
        sites.append(dict(lat=round(float(lat), 2), lon=round(float(lon_s), 2), name=name, country=country, population=int(pop), elev_m=float(rec["elevation"])))
        print(f"   {len(sites):3d}/{n}  {name[:22]:22s} {country:2s} pop {pop:9,d}  {lat:6.2f} {lon_s:7.2f}  elev {float(rec['elevation']):5.0f} m  DNI mean when up {np.nanmean(rec['dni'][rec['dni'] > 0]):4.0f} W/m2  ({time.time() - t0:.0f} s)", flush=True)
        time.sleep(polite_s)
    json.dump(dict(sites=sites, years=list(years), lat_max=lat_max, seed=seed, weight=weight, country=country, admin1=admin1, admin1_share=admin1_share), open(out, "w"), indent=1)
    print("pool ->", out); return out


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser(); sub = ap.add_subparsers(dest="cmd")
    b = sub.add_parser("build"); b.add_argument("--n", type=int, default=64); b.add_argument("--years", type=int, nargs=2, default=[2021, 2022]); b.add_argument("--out", default=os.path.join(DATA, "site_pool.json")); b.add_argument("--seed", type=int, default=0); b.add_argument("--lat-max", type=float, default=50.0); b.add_argument("--weight", default="population", choices=("population", "area")); b.add_argument("--country", default=None, help="GeoNames country code, e.g. PK"); b.add_argument("--admin1", default=None, help="GeoNames admin1 code within the country, e.g. 02 = Balochistan"); b.add_argument("--admin1-share", type=float, default=0.67)
    c = sub.add_parser("check"); c.add_argument("pool", default="quetta")
    u = sub.add_parser("urban", help="compute every pool site's neighbourhood (footprint tiles are downloaded once) and write it into the pool file"); u.add_argument("pool"); u.add_argument("--force", action="store_true")
    a = ap.parse_args()
    if a.cmd == "build": build_pool(a.n, tuple(a.years), a.out, seed=a.seed, lat_max=a.lat_max, weight=a.weight, country=a.country, admin1=a.admin1, admin1_share=a.admin1_share)
    elif a.cmd == "urban":
        spec = POOLS.get(str(a.pool).lower()) if str(a.pool).lower() in POOLS else json.load(open(a.pool)); t0 = time.time()
        for s_ in spec["sites"]:
            m = neighbourhood(s_["lat"], s_["lon"], force=a.force); s_["urban"] = m
            print(f"   {s_.get('name', '?'):10s} {s_['lat']:7.2f} {s_['lon']:8.2f}  {m['source']:9s} n {m['n']:5d}  lam_p {m['lam_p']:.2f}  h {m['h']:4.1f} m  d {m['d']:4.1f}  z0 {m['z0']:.2f}  U/U100 {m['K100']:.2f}  Iu {m['iu']:.2f}  ({time.time() - t0:.0f} s)", flush=True)
        if str(a.pool).lower() not in POOLS: json.dump(spec, open(a.pool, "w"), indent=1); print("pool ->", a.pool)
    else:
        sw = SiteWeather(a.pool); print(sw.describe()); rng = np.random.default_rng(0)
        tab = sw.draw(np.zeros(256, np.int64), np.full(256, 172), rng)
        print(f"site 0, 256 draws near day 172: DNI at 12.5 h mean {sw_interp24(tab[:, 0], 12.5).mean():.0f} W/m2 (max {sw_interp24(tab[:, 0], 12.5).max():.0f}), U10 at 14 h mean {sw_interp24(tab[:, 1], 14.0).mean():.1f} m/s, gust {sw_interp24(tab[:, 2], 14.0).mean():.1f}")
        tb = sw.tabs[0]; print(f"   tables: {tb['dni'].shape[0]} days on file, DNI noon mean over all days {tb['dni'][:, 12].mean():.0f}, zero at 0 h: {tb['dni'][:, 0].max():.0f}; doy range {tb['doy'].min()}-{tb['doy'].max()}")

"""THE SITE'S WIND, drawn from the reanalysis rather than assumed. tandoor_site_wind.npz holds, for every recorded day at the
site (ERA5 at Quetta, 2013-2022; design/compliant/stage3/weather), the 24 hourly values of the 10 m wind, its direction and
the 3 s gust. An episode draws a REAL DAY from within +-15 days of its own day of the year (any year) and follows that
day's hourly wind, direction and gustiness by the hour: the calm mornings, the westerly afternoons, the gust factor of 3.7.

Directions are compass bearings the wind comes FROM (0 N, 90 E, 180 S, 270 W); in the env's frame x is north and y east, so
the wind's own direction (where it blows TO) is bearing + 180. The gustiness is what the envs' von Karman filter needs:
sigma_u/U = (gust/U - 1)/3 from the 3 s gust, as a ratio to max(U, 0.3), so calm hours keep their convective gusts."""
import os, numpy as np, torch
_HERE = os.path.dirname(os.path.abspath(__file__)); _NPZ = os.path.join(_HERE, "tandoor_site_wind.npz")
NAMES = dict(N=0.0, NE=45.0, E=90.0, SE=135.0, S=180.0, SW=225.0, W=270.0, NW=315.0)


def parse_from(s):
    """'W', 'NW', 'S' or a number: the compass bearing the wind comes from"""
    try: return float(s)
    except (TypeError, ValueError): return NAMES[str(s).strip().upper()]


def bearing_vec(from_deg):
    """(B,) or scalar bearing the wind comes FROM -> unit vectors of where it blows TO, env frame (x north, y east, z up)"""
    to = torch.deg2rad(torch.as_tensor(from_deg, dtype=torch.float32) + 180.0)
    v = torch.stack([torch.cos(to), torch.sin(to), torch.zeros_like(to)], -1)
    return v


def build_npz(csv_path, out_path=_NPZ):
    """the per-day hourly record from the ERA5 CSV (t, U, dir, gust, ...)"""
    import pandas as pd
    d = pd.read_csv(csv_path, parse_dates=["t"]).dropna(subset=["U", "dir", "gust"])
    d["date"] = d.t.dt.date; d["hour"] = d.t.dt.hour
    days, U, D, G = [], [], [], []
    for date, g in d.groupby("date"):
        if len(g) != 24: continue
        g = g.sort_values("hour"); days.append(pd.Timestamp(date).dayofyear)
        U.append(g.U.values); D.append(g["dir"].values); G.append(g.gust.values)
    np.savez_compressed(out_path, doy=np.array(days, np.int16), U=np.array(U, np.float16), dir=np.array(D, np.float16), gust=np.array(G, np.float16))
    return out_path, len(days)


class SiteWind:
    def __init__(self, path=_NPZ, device="cpu"):
        z = np.load(path); self.device = device
        self.doy = torch.as_tensor(z["doy"].astype(np.int64), device=device)
        self.U = torch.as_tensor(z["U"].astype(np.float32), device=device)
        self.dir = torch.as_tensor(z["dir"].astype(np.float32), device=device)
        self.gust = torch.as_tensor(z["gust"].astype(np.float32), device=device)
        self.n = int(self.doy.numel())

    def sample_days(self, doy, gen=None, window=15):
        """per agent, the index of a recorded day within +-window days of the episode's day of the year"""
        doy = torch.as_tensor(doy, device=self.device).reshape(-1).long()
        dist = (self.doy[None, :] - doy[:, None]).abs(); dist = torch.minimum(dist, 365 - dist)
        ok = (dist <= window).float() + 1e-6
        return torch.multinomial(ok, 1, generator=gen).squeeze(1)

    def at(self, idx, hour):
        """(U m/s, bearing from deg, sigma_u/U) for the recorded days idx (B,) at the local hour (B,) or scalar, interpolated"""
        idx = torch.as_tensor(idx, device=self.device).long().reshape(-1)
        h = torch.as_tensor(hour, dtype=torch.float32, device=self.device).reshape(-1).expand(idx.shape[0]) % 24.0
        h0 = torch.floor(h).long() % 24; h1 = (h0 + 1) % 24; f = (h - torch.floor(h))[:, None]
        def lerp(A): return (A[idx, h0]*(1 - f.squeeze(1)) + A[idx, h1]*f.squeeze(1))
        U = lerp(self.U); gust = lerp(self.gust)
        d0, d1 = self.dir[idx, h0], self.dir[idx, h1]                                      # the direction, interpolated on the circle
        dd = torch.remainder(d1 - d0 + 180.0, 360.0) - 180.0; direction = torch.remainder(d0 + f.squeeze(1)*dd, 360.0)
        # sigma_u = (gust - U)/3 as a ratio to U: unclamped above, because a calm morning with thermals (U 0.3, gusts to 6)
        # is exactly a large ratio, and the Karman process multiplies it back by U
        iu = torch.clamp((gust/torch.clamp(U, min=0.3) - 1.0)/3.0, 0.1, 20.0)
        return U, direction, iu

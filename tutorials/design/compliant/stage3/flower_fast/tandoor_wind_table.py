"""The head's wind loads and the film's wind figure from the LES of the bowl (design/compliant/stage3/wind), by the wind's
incidence on the dish - theta_w, the angle between the dish axis and the upwind direction, 0 = straight into the bowl.

What the runs found (12 m/s, 6 cm cells, steady inflow): the load on a bowl facing the wind is a NORMAL force along the
dish axis, Cn ~ -1.6 on the disc area from 37 to 59 deg of incidence and collapsing by 83, with a tangential part under
0.1; the vertical force is downward and 2-3x the heuristic the envs carried (with the opposite sign); the film's figure
error from the load's n = 1, 2, 3 harmonics peaks at mid incidence. The table is piecewise linear in theta_w, flat
beyond its ends; where it has no coverage (the wind on the BACK of the dish, theta_w > 90) the callers keep their old
model. tandoor_wind_table.json is written by stage3/wind/dish_table.py from the LES runs."""
import json, os, numpy as np, torch
_HERE = os.path.dirname(os.path.abspath(__file__))
_PATH = os.path.join(_HERE, "tandoor_wind_table.json")
_T = None


def load(path=_PATH):
    """the table as sorted numpy arrays, complete 6 cm runs only"""
    global _T
    rows = [r for r in json.load(open(path)) if abs(r["dx"] - 0.06) < 1e-6 and r["t_s"] >= 8.0]
    rows.sort(key=lambda r: r["theta_w"])
    _T = {k: np.array([r[k] for r in rows], dtype=np.float32) for k in ("theta_w", "Cn", "Ct", "Cd", "Cl", "Cm", "k_film", "n1", "n2", "n3")}
    return _T


def table():
    return _T if _T is not None else load()


def coverage():
    T = table(); return float(T["theta_w"].min()), float(T["theta_w"].max()), len(T["theta_w"])


def interp(theta_w, key):
    """piecewise-linear in theta_w (degrees, tensor), flat beyond the table's ends"""
    T = table(); x = torch.as_tensor(T["theta_w"], device=theta_w.device); y = torch.as_tensor(T[key], device=theta_w.device)
    t = theta_w.clamp(float(x[0]), float(x[-1]))
    i = torch.searchsorted(x, t, right=True).clamp(1, len(x) - 1)
    x0, x1, y0, y1 = x[i - 1], x[i], y[i - 1], y[i]
    return y0 + (y1 - y0)*(t - x0)/torch.clamp(x1 - x0, min=1e-6)


def head_aero(n, w):
    """n (B,3) the dish axis toward the sun, w (B,3) the wind's direction (where it blows TO). Returns theta_w (deg), the
    normal and tangential force coefficients on the disc area (Cn along +n: negative pushes the dish back), the film's
    figure constant k_film (rad per (m/s)^2 of wind, n >= 1 harmonics at the working tension), and a mask of the poses
    the table covers (the wind on the bowl's face)."""
    up = -w/torch.linalg.norm(w, dim=1, keepdim=True).clamp(min=1e-9)
    cos_t = (n*up).sum(1).clamp(-1.0, 1.0); theta_w = torch.rad2deg(torch.arccos(cos_t))
    covered = theta_w <= 100.0                                   # the table reaches 96 deg (the wind grazing the back); beyond, the old model
    return theta_w, interp(theta_w, "Cn"), interp(theta_w, "Ct"), interp(theta_w, "k_film"), covered


def head_force(n, w, q, area):
    """the wind force vector on the head from the table: Cn q A along n plus Ct q A along the wind's projection on the dish"""
    theta_w, Cn, Ct, k_film, covered = head_aero(n, w)
    wt = w - (w*n).sum(1, keepdim=True)*n; wt = wt/torch.linalg.norm(wt, dim=1, keepdim=True).clamp(min=1e-9)
    F = (Cn*q*area)[:, None]*n + (Ct*q*area)[:, None]*wt
    return F, theta_w, k_film, covered

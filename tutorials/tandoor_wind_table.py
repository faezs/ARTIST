"""The head's wind loads and the film's wind figure from the LES of the bowl (design/compliant/stage3/wind), by the wind's
incidence on the dish - theta_w, the angle between the dish axis and the upwind direction, 0 = straight into the bowl.

What the runs found (12 m/s, 6 cm cells, steady inflow): the load on a bowl facing the wind is a NORMAL force along the
dish axis, Cn ~ -1.6 on the disc area from 37 to 59 deg of incidence and collapsing by 83, with a tangential part under
0.1; the vertical force is downward and 2-3x the heuristic the envs carried (with the opposite sign); the film's figure
error from the load's n = 1, 2, 3 harmonics peaks at mid incidence. The table is piecewise linear in theta_w, flat
beyond its ends. The W/NW runs took it to 154 deg (the wind on the BACK of the dish), and it serves every incidence:
below 37 deg and above 154 the last attitude's values are held, which is within ~10 % for the force of a dish this shallow
and pessimistic for the film (the n = 1 harmonic vanishes by symmetry at 0 and 180 deg). tandoor_wind_table.json is
written by stage3/wind/dish_table.py from the LES runs."""
import json, os, numpy as np, torch
_HERE = os.path.dirname(os.path.abspath(__file__))
_PATH = os.path.join(_HERE, "tandoor_wind_table.json")
_T = None
COVER_DEG = 180.0                                               # was 100 before the W/NW runs extended the table


def load(path=_PATH):
    """the table as sorted numpy arrays, complete 6 cm runs only"""
    global _T
    allr = [r for r in json.load(open(path)) if r["t_s"] >= 5.0]
    best = {}                                                       # per attitude, the finest grid that has run
    for r in allr:
        k = (round(r["el"]), round(r["az"]))
        if k not in best or r["dx"] < best[k]["dx"]: best[k] = r
    rows = sorted(best.values(), key=lambda r: r["theta_w"])
    keys = ("theta_w", "Cn", "Ct", "Cd", "Cl", "Cm", "k_film", "n1", "n2", "n3", "dx", "Cm_s", "k_fig", "tilt1")
    _T = {k: np.array([r.get(k, 0.0) for r in rows], dtype=np.float32) for k in keys}
    return _T


def head_moment(n, w):
    """the MEAN pitching moment's coefficient, SIGNED, and its axis: the table's Cm_s is the mean moment about
    e_m = n x w_hat (w_hat where the wind blows), per q A D. Returns Cm_s (B,) and e_m (B,3); a zero e_m where the wind
    is along the axis. tilt1 in the table is the n = 1 harmonic's deflection plane and is NOT an optical bias: a film
    fixed at its rim has zero aperture-mean slope (Gauss), so the whole harmonic is figure, which k_film carries."""
    up = -w/torch.linalg.norm(w, dim=1, keepdim=True).clamp(min=1e-9)
    theta_w = torch.rad2deg(torch.arccos((n*up).sum(1).clamp(-1.0, 1.0)))
    e_m = torch.cross(n, -up, dim=1); e_m = e_m/torch.linalg.norm(e_m, dim=1, keepdim=True).clamp(min=1e-9)
    return interp(theta_w, "Cm_s"), e_m


def table():
    return _T if _T is not None else load()


def coverage():
    T = table(); return float(T["theta_w"].min()), float(T["theta_w"].max()), len(T["theta_w"]), float(T["dx"].max())


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
    the table covers - all of them since the W/NW runs; the callers keep the switch for a table with holes."""
    up = -w/torch.linalg.norm(w, dim=1, keepdim=True).clamp(min=1e-9)
    cos_t = (n*up).sum(1).clamp(-1.0, 1.0); theta_w = torch.rad2deg(torch.arccos(cos_t))
    covered = theta_w <= COVER_DEG                               # every incidence: the table runs to 154 deg and is held flat beyond
    return theta_w, interp(theta_w, "Cn"), interp(theta_w, "Ct"), interp(theta_w, "k_film"), covered


def head_force(n, w, q, area):
    """the wind force vector on the head from the table: Cn q A along n plus Ct q A along the wind's projection on the dish"""
    theta_w, Cn, Ct, k_film, covered = head_aero(n, w)
    wt = w - (w*n).sum(1, keepdim=True)*n; wt = wt/torch.linalg.norm(wt, dim=1, keepdim=True).clamp(min=1e-9)
    F = (Cn*q*area)[:, None]*n + (Ct*q*area)[:, None]*wt
    return F, theta_w, k_film, covered

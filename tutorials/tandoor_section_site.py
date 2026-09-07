"""The section a SITE allows: which part of the parent primary may exist.

For a roof W (east-west) x D (north-south), a post at (ty, tx) of it, the
neighbours' roofs beyond the parapet and the post's height, every point of
the dish plane (body frame: x up the dish, y across, sag on the parent
paraboloid) is carried over the year's sun positions by the as-built mount
(orbit g = f about the fixed F, perfect tracking) and must be LEGAL at all
of them:
  - over the owner's roof: above the parapet (deck + 0.35 m);
  - beyond the parapet: above the neighbours' heads (deck + h_side, 2.3 m
    for a neighbour's roof at the same height; a street side needs less).
Raising F by delta raises every point by delta, so each grid point has a
single number: the post height it needs. The section for a given post
height is the set below that threshold (less the strip's shadow and the
bore, r < R_HOLE), and the tallness curve area(delta) is the trade.

Frame: x north from the post's foot, y east, z up (pot floor 0).
"""
import contextlib, io, json, sys, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_mount_batch import mount_batch, solar_batch

LAT = 30.2
SETBACK = 0.0          # the rim may reach the parapet itself
PARAPET = 0.35
H_NEIGHBOUR = 2.3      # clearance over a neighbour's roof at the same deck height
R_HOLE = 0.7           # the strip's shadow and the bore's crossing: no film here
GRID = 0.15            # dish-plane grid [m]
HALF = 6.5             # dish-plane half-extent [m]


def poses(lat=LAT, el_min=12.0):
    days = torch.arange(3.0, 366.0, 12.0); hours = torch.arange(5.0, 20.01, 0.5)
    D, H = torch.meshgrid(days, hours, indexing="ij"); D, H = D.reshape(-1), H.reshape(-1)
    el, az, _ = solar_batch(torch.full_like(D, lat), D, H); k = el >= el_min
    return D[k], H[k], el[k], az[k]


@contextlib.contextmanager
def _nominal(env):
    fct = getattr(env, "_fct", None); env._fct = None
    try:
        yield
    finally:
        env._fct = fct


def body_frames(env, lat=LAT):
    """Cd (N,3) world dish centres from the post's foot, b_x, b_y, n (N,3) body axes in the world, el (N,)"""
    day, hour, el, az = poses(lat); B = day.shape[0]
    with _nominal(env):
        m = mount_batch(env, day, torch.full((B,), lat), hour, torch.device("cpu"))
    Mt, Cd = m["Mt"].numpy(), m["Cd"].numpy(); Cd = Cd - np.array([float(env.X_TOWER_C), 0, 0])
    zh = np.array([0, 0, 1.0]); n = np.einsum("bji,j->bi", Mt, zh)
    bx = zh - (n * zh).sum(1)[:, None] * n; bx /= np.linalg.norm(bx, axis=1)[:, None]; by = np.cross(n, bx)
    return Cd, bx, by, n, el.numpy()


class SiteFields:
    """the year's world footprints of every dish-plane grid point (sag on the parent)"""

    def __init__(self, env, f=None, lat=LAT):
        self.f = float(f if f is not None else env.f_nom); self.z_deck = float(env.z_deck)
        N = 2 * int(round(HALF / GRID)) + 1; xs = (np.arange(N) - (N - 1) / 2) * GRID; self.xs = xs   # symmetric, the vertex a node
        X, Y = np.meshgrid(xs, xs, indexing="ij"); self.X, self.Y = X, Y
        pts = np.stack([X.ravel(), Y.ravel(), (X.ravel() ** 2 + Y.ravel() ** 2) / (4 * self.f)], 1)   # (P,3) body
        Cd, bx, by, n, el = body_frames(env, lat); self.el = el
        # world positions (N poses, P points, 3): chunked
        P = pts.shape[0]; self.xw = np.empty((len(el), P), np.float32); self.yw = np.empty_like(self.xw); self.zw = np.empty_like(self.xw)
        for i0 in range(0, len(el), 128):
            sl = slice(i0, i0 + 128)
            W = Cd[sl, None, :] + pts[None, :, 0, None] * bx[sl, None, :] + pts[None, :, 1, None] * by[sl, None, :] + pts[None, :, 2, None] * n[sl, None, :]
            self.xw[sl], self.yw[sl], self.zw[sl] = W[..., 0], W[..., 1], W[..., 2]
        self.r = np.sqrt(X ** 2 + Y ** 2).ravel()

    def delta_needed(self, width, depth, tx=0.5, ty=0.5, h_side=None, setback=SETBACK):
        """post height rise [m] every grid point needs (inf where impossible); the post at
        (tx of the depth from the south edge, ty of the width from the west edge);
        h_side: dict N/S/E/W of clearance heights above the deck beyond that parapet"""
        h = dict(N=H_NEIGHBOUR, S=H_NEIGHBOUR, E=H_NEIGHBOUR, W=H_NEIGHBOUR); h.update(h_side or {})
        x_s, x_n = -tx * depth + setback, (1 - tx) * depth - setback; y_w, y_e = -ty * width + setback, (1 - ty) * width - setback
        req = np.full(self.xw.shape, self.z_deck + PARAPET, np.float32)
        for cond, key in (((self.xw > x_n), "N"), ((self.xw < x_s), "S"), ((self.yw > y_e), "E"), ((self.yw < y_w), "W")):
            req = np.where(cond, np.maximum(req, self.z_deck + h[key]), req)
        need = (req - self.zw).max(0)                       # over the poses
        need = np.maximum(need, 0.0).reshape(self.X.shape)
        need[self.r.reshape(self.X.shape) < R_HOLE] = np.inf
        # how far beyond the parapet the point ever reaches (0 inside): the overhang the neighbours must accept
        dxo = np.maximum.reduce([np.zeros_like(self.xw), self.xw - x_n, x_s - self.xw]); dyo = np.maximum.reduce([np.zeros_like(self.yw), self.yw - y_e, y_w - self.yw])
        over = np.hypot(dxo, dyo).max(0).reshape(self.X.shape)          # the planar distance past the parapet (a corner counts diagonally)
        self._over = over
        return need

    def over(self):
        """the overhang field of the last delta_needed call [m beyond the parapet]"""
        return self._over

    def outline(self, need, delta):
        """the section for a post rise delta: mask, area, centroid, and a star outline about the centroid"""
        m = need <= delta + 1e-9
        area = float(m.sum()) * GRID * GRID
        if area < 0.5:
            return dict(mask=m, area=area, centre=None, theta=None, rmax=None)
        cx, cy = float(self.X[m].mean()), float(self.Y[m].mean())
        th = np.arctan2(self.Y[m] - cy, self.X[m] - cx); rr = np.hypot(self.X[m] - cx, self.Y[m] - cy)
        NT = 64; thn = np.linspace(-np.pi, np.pi, NT, endpoint=False); k = ((th + np.pi) / (2 * np.pi / NT)).astype(int) % NT
        rmax = np.zeros(NT)
        for i in range(NT):
            sel = k == i
            rmax[i] = rr[sel].max() + GRID / 2 if sel.any() else 0.0
        # a star outline about the centroid is only a proxy for a non-convex set; report the discrepancy
        star = 0.5 * float((rmax ** 2).sum()) * (2 * np.pi / NT)
        return dict(mask=m, area=area, centre=(cx, cy), theta=thn, rmax=rmax, star_area=star)


X_TOWER_C, R_POT_ = 1.75, 0.42      # the pit's centre is X_TOWER_C south of the post's foot (the bore runs F -> pit); the pit's radius


def post_ok(width, depth, tx, ty, margin=0.3):
    """the post position keeps the EXISTING pit (X_TOWER_C south of the post) inside the plot"""
    return (tx * depth >= X_TOWER_C + R_POT_ + margin) and (ty * width >= R_POT_ + margin) and ((1 - ty) * width >= R_POT_ + margin)


def best_post(F, width, depth, deltas, caps=(np.inf,), h_side=None, grid=(np.linspace(0.1, 0.9, 9), np.linspace(0.2, 0.8, 7))):
    """for each (overhang cap, post rise): the best post position (with the pit on the roof) and its section area
    -> dict[(cap, delta)] = (area, tx, ty, need, over)"""
    best = {(c, d): (0.0, 0.5, 0.5, None, None) for c in caps for d in deltas}   # no legal post position: nothing admissible
    for tx in grid[0]:
        for ty in grid[1]:
            if not post_ok(width, depth, tx, ty):
                continue
            need = F.delta_needed(width, depth, tx, ty, h_side); over = F.over()
            for c in caps:
                ok_c = over <= c
                for d in deltas:
                    area = float(((need <= d) & ok_c).sum()) * GRID * GRID
                    if area > best[(c, d)][0] or best[(c, d)][3] is None: best[(c, d)] = (area, tx, ty, need, over)
    return best


if __name__ == "__main__":
    from tandoor_hashemi_env import TandoorHashemiEnv
    kw = dict(num_agents=2, seed=1, device="cpu", gpu=0, n_rays=64, lat=LAT, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw)
    F = SiteFields(e); print(f"fields: {len(F.el)} poses, {F.X.size} dish-plane points at {GRID} m, parent f {F.f:.2f}, deck z {F.z_deck:.1f}")
    q = np.array(json.load(open("data/tandoor/quetta_tandoor_roof_quantiles.json")))
    roofs = [("4 x 6 (median)", 6.0, 4.0), ("4 x 6 deep (long N-S)", 4.0, 6.0), ("p25 3.4 x 5.1", 5.1, 3.4), ("p75 4.7 x 7.1", 7.1, 4.7), ("p90 5.5 x 8.3", 8.3, 5.5), ("as-built check 9 x 8", 9.0, 8.0)]
    deltas = (0.0, 0.5, 1.0, 1.5, 2.0, 3.0); caps = (1.0, 2.0, 3.5)
    print(f"section area [m2] vs post rise dF and the overhang the neighbours accept (cap, m beyond the parapet);")
    print(f"neighbours' roofs at deck height on all sides, {H_NEIGHBOUR} m over their heads; the as-built circle is 13.9 m2 and needs dF+1.2 on 4 x 6")
    out = {}; needs = {}
    for name, W_, D_ in roofs:
        bests = best_post(F, W_, D_, deltas, caps)
        for c in caps:
            row = [bests[(c, d)][0] for d in deltas]; area, tx, ty, need, over = bests[(c, 2.0)]
            print(f"{name:24s} cap {c:3.1f}: " + " ".join(f"dF+{d:.1f} {a:5.1f}" for d, a in zip(deltas, row)) + f"   post (ty {ty:.1f} across, tx {tx:.1f} up) at dF+2")
            out[f"{name}|cap{c}"] = dict(W=W_, D=D_, cap=c, areas=row, tx=float(tx), ty=float(ty))
        needs[name] = dict(need=bests[(2.0, 2.0)][3], over=bests[(2.0, 2.0)][4], tx=bests[(2.0, 2.0)][1], ty=bests[(2.0, 2.0)][2], W=W_, D=D_)
    np.save("data/tandoor/section_site_fields.npy", dict(xs=F.xs, sites=needs), allow_pickle=True)
    json.dump(dict(deltas=deltas, roofs=out), open("data/tandoor/section_tallness.json", "w"), indent=1)

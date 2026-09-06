"""The largest section of the sphere that fits the roof.

The membrane is a section of the nominal sphere (same f, same F, same
Hashemi mount and Cassegrain receiver as the hashemi.ini machine); its
OUTLINE is what the roof decides. The outline is found in the world:
over every sun position of the year the mount places the dish (orbit g
about the fixed fold F, the beta schedule, perfect tracking), and a
point of the dish plane is admissible iff its footprint on the deck
stays inside the plot for all of them (with the vertical rule's
overhang allowance past the parapet). The admissible set is tabulated
on a polar grid of the dish plane for several dish/orbit scales; the
outline r_max(theta) is the largest star-shaped section inside it.

Frame: x north (from the tower's foot; the pit is south of the tower
at -X_TOWER_C), y east, z up (pot floor 0). The plot is a rectangle
width (E-W) x depth (N-S) with the tower at tower_frac of the depth
from the south edge.
"""
import sys, contextlib, io, json, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_mount_batch import mount_batch, solar_batch

NTH, NR, RMAX = 32, 60, 6.0                  # the dish-plane polar grid: 32 angles x 60 radii to 6 m
SCALES = np.array([0.35, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0])   # dish/orbit scales the fields are tabulated at
SETBACK = 0.5                                # keep the rim this far inside the parapet
LAT = 30.2                                   # Quetta


def _poses(lat, el_min=12.0):
    """the year's sun positions above the mount's minimum: day, hour, el [deg], az [rad]"""
    days = torch.arange(1.0, 366.0, 6.0); hours = torch.arange(5.0, 20.01, 0.25)
    D, H = torch.meshgrid(days, hours, indexing="ij"); D, H = D.reshape(-1), H.reshape(-1)
    el, az, _ = solar_batch(torch.full_like(D, lat), D, H)
    keep = el >= el_min
    return D[keep], H[keep], el[keep], az[keep]


def _place(env, day, hour, lat=LAT):
    """the mount at these (day, hour): Mt (B,3,3) dish->world rotation
    (world = p @ Mt + Cd), Cd (B,3) dish centre, el (B,) sun elevation.
    Perfect tracking (pnt=None): the dish axis at the sun, beta from the
    sun's elevation - the schedule the machine runs."""
    B = day.shape[0]; dev = torch.device("cpu")
    m = mount_batch(env, day, torch.full((B,), lat), hour, dev)
    return m["Mt"], m["Cd"], m["el"], m["az"], m["ub"]


@contextlib.contextmanager
def _scaled(env, s):
    """the env's dish and orbit at scale s (scalars; the per-agent table off)"""
    g0, a0 = float(env.g_orbit), float(env.a_mem); fct = getattr(env, "_fct", None)
    env._fct = None; env.g_orbit, env.a_mem = g0 * float(s), a0 * float(s)
    try:
        yield
    finally:
        env.g_orbit, env.a_mem, env._fct = g0, a0, fct


def fields(env, lat=LAT):
    """For each scale s, each polar grid point of the dish plane (theta, r):
    the extreme roof footprints over the year: xmin, xmax, |y|max [m],
    measured from the tower's foot."""
    day, hour, el, az = _poses(lat); n = el.shape[0]
    th = torch.linspace(-np.pi, np.pi, NTH + 1)[:-1]; rr = torch.linspace(0.0, RMAX, NR + 1)[1:]
    TH, RR = torch.meshgrid(th, rr, indexing="ij")
    pl = torch.stack([RR * torch.cos(TH), RR * torch.sin(TH), torch.zeros_like(RR)], -1).reshape(-1, 3)   # dish-plane points (sag ignored)
    out = {}
    for s in SCALES:
        with _scaled(env, s):
            xmn = torch.full((pl.shape[0],), 1e9); xmx = torch.full((pl.shape[0],), -1e9); ymx = torch.zeros(pl.shape[0])
            for i0 in range(0, n, 256):
                Mt, Cd, _, _, _ = _place(env, day[i0:i0 + 256], hour[i0:i0 + 256], lat)
                pw = torch.einsum("pj,bji->bpi", pl, Mt) + Cd[:, None, :]      # world points (B,P,3)
                x = pw[..., 0] - float(env.X_TOWER_C); y = pw[..., 1]
                xmn = torch.minimum(xmn, x.min(0).values); xmx = torch.maximum(xmx, x.max(0).values); ymx = torch.maximum(ymx, y.abs().max(0).values)
        out[float(s)] = dict(xmin=xmn.numpy().reshape(NTH, NR), xmax=xmx.numpy().reshape(NTH, NR), ymax=ymx.numpy().reshape(NTH, NR))
    return dict(theta=th.numpy(), r=rr.numpy(), scales=SCALES, fields=out, n_poses=int(n))


def outline(F, width, depth, tower_frac=None, setback=SETBACK, over=0.0):
    """The admissible outline r_max(theta) [m] for a plot of the given
    width (east-west) and depth (north-south), the tower standing at
    tower_frac of the depth from the south edge (None: the best of a few
    positions - the pit is under the tower, so this is really the site's),
    and the dish scale that carries it (the grid radius must reach it).
    `over` is the vertical rule's allowance to overhang the parapet."""
    best = None
    fracs = [tower_frac] if tower_frac is not None else [0.3, 0.4, 0.5, 0.6, 0.7]
    for tf in fracs:
        x_s, x_n = -tf * depth + setback - over, (1 - tf) * depth - setback + over
        for s in F["scales"]:
            f = F["fields"][float(s)]
            ok = (f["xmin"] >= x_s) & (f["xmax"] <= x_n) & (f["ymax"] <= width / 2 - setback + over)     # (NTH, NR)
            rmax = np.zeros(NTH)
            for i in range(NTH):
                bad = np.where(~ok[i])[0]; rmax[i] = F["r"][bad[0] - 1] if (len(bad) and bad[0] > 0) else (0.0 if len(bad) else F["r"][-1])
            area = 0.5 * float((rmax ** 2).sum()) * (2 * np.pi / NTH)
            reach = rmax.max()
            if reach <= 2.1 * s + 1e-6 or s == F["scales"][-1]:   # the grid at this scale contains the outline
                cand = dict(scale=float(max(s, reach / 2.1)), rmax=rmax, area=area, reach=float(reach), tower_frac=tf, width=width, depth=depth, over=over)
                if best is None or cand["area"] > best["area"]: best = cand
    return best


# ---------------------------------------------------------------- the drawings
POSES = [("winter noon (Dec 21)", 355.0, 12.0, "#3F6EA6"), ("summer noon (Jun 21)", 172.0, 12.0, "#C9922A"),
         ("equinox 8:00", 80.0, 8.0, "#5E8C4A"), ("equinox 16:00", 80.0, 16.0, "#A83E2C")]


def draw_views(env, F, b, out, lat=LAT, title=""):
    """Plan and two elevations in the manner of Hashemi's fig 18: the roof
    deck and parapet, the fixed ring rail on the deck, the central post
    carrying the fixed fold F, the rotating beam (azimuth), the A-frames
    and the focus-centred arc rail (elevation), the dish - here the
    roof's SECTION of the sphere - at the year's extreme poses, and its
    sweep over the whole year; the bore from F down to the pit."""
    import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
    from tandoor_coude_optics import R_POT, H_POT, Z_DUCT
    width, depth, tf, s = b["width"], b["depth"], b["tower_frac"], b["scale"]
    ty = b.get("ty", 0.5)                                                  # the post across the width (0 = west edge)
    x_s, x_n = -tf * depth, (1 - tf) * depth; y_w, y_e = -ty * width, (1 - ty) * width
    th = b["theta"] if "theta" in b else F["theta"]; r = b["rmax"]; n_th = len(th)
    f_par = float(env.f_nom)
    def ring(rr):
        z = (rr ** 2) / (4 * f_par); q = np.stack([rr * np.cos(th), rr * np.sin(th), z], 1); return np.r_[q, q[:1]]
    rim = ring(r)                                                          # the outer rim, body frame, on the parent
    rim_in = ring(b["rmin"]) if b.get("rmin") is not None else None
    xt = float(env.X_TOWER_C); z_deck = float(env.z_deck); z_f = float(env.z_fold) + float(b.get("rise", 0.0))
    g = float(env.g_orbit) * s; a = float(env.a_mem) * s; R_ring = g + 0.6; R_arc = g + 0.35
    fig, axs = plt.subplots(1, 3, figsize=(19, 6.8), gridspec_kw=dict(width_ratios=[1.15, 1, 1]))
    axP, axNS, axEW = axs
    def body(Mt_):
        zh = np.array([0, 0, 1.0]); n_ = np.einsum("bji,j->bi", Mt_, zh)
        bx_ = zh - (n_ * zh).sum(1)[:, None] * n_; bx_ /= np.linalg.norm(bx_, axis=1)[:, None]; return bx_, np.cross(n_, bx_), n_
    def to_world(q, Cd_, bx_, by_, n_):
        return Cd_[:, None, :] + q[None, :, 0, None] * bx_[:, None, :] + q[None, :, 1, None] * by_[:, None, :] + q[None, :, 2, None] * n_[:, None, :]
    with _scaled(env, s):
        # the year's sweep of the section: the rim over all poses (faint)
        day, hour, el, az = _poses(lat); step = max(1, day.shape[0] // 400)
        Mt, Cd, _, _, _ = _place(env, day[::step], hour[::step], lat)
        rise_v = np.array([0.0, 0.0, float(b.get("rise", 0.0))])            # F raised: the whole orbit rises with it
        bx_, by_, n_ = body(Mt.numpy()); W = to_world(rim, Cd.numpy() + rise_v, bx_, by_, n_); W[..., 0] -= xt
        for w in W:
            axP.plot(w[:, 1], w[:, 0], color="0.75", lw=0.4, alpha=0.5)
        # how far the year's sweep crosses the parapet on each side, and how high it flies
        ext = dict(N=float(W[..., 0].max()), S=float(-W[..., 0].min()), E=float(W[..., 1].max()), W=float(-W[..., 1].min()))
        edge = dict(N=x_n, S=-x_s, E=y_e, W=-y_w)
        over = {k: max(0.0, ext[k] - edge[k]) for k in ext}; z_low = float(W[..., 2].min())
        sweep_x = (float(W[..., 0].min()), float(W[..., 0].max())); sweep_y = (float(W[..., 1].min()), float(W[..., 1].max()))
        # the four extreme poses, with the mount's parts
        for name, d, h, col in POSES:
            Mt, Cd, el_, az_, ub = _place(env, torch.tensor([d]), torch.tensor([h]), lat)
            bx1, by1, n1 = body(Mt.numpy()); w = to_world(rim, Cd.numpy() + rise_v, bx1, by1, n1)[0]; w[:, 0] -= xt
            w_in = to_world(rim_in, Cd.numpy() + rise_v, bx1, by1, n1)[0] if rim_in is not None else None
            if w_in is not None: w_in[:, 0] -= xt
            Mt, Cd, ub = Mt[0].numpy(), Cd[0].numpy() + rise_v, ub[0].numpy(); elv = float(el_[0]); c = Cd - np.array([xt, 0, 0])
            hd = -(ub - ub[2] * np.array([0, 0, 1.0])); hd /= max(np.linalg.norm(hd), 1e-9)      # the beam's direction (away from the sun)
            lab = f"{name}, sun el {elv:.0f}°"
            axP.plot(w[:, 1], w[:, 0], color=col, lw=1.8, label=lab)
            if w_in is not None: axP.plot(w_in[:, 1], w_in[:, 0], color=col, lw=0.8)
            axP.plot([-R_ring * hd[1], R_ring * hd[1]], [-R_ring * hd[0], R_ring * hd[0]], color=col, lw=2.4, alpha=0.6)     # the beam on the ring
            for rA in (0.66 * g, g):                                                                  # the A-frames' feet
                for sg in (1, -1):
                    e_s = np.cross([0, 0, 1.0], hd); ft = rA * hd + sg * 0.55 * e_s
                    axP.plot(ft[1], ft[0], "v", color=col, ms=4)
            # elevations: the rim, the beam (deck), the A-frames up to the arc, the arc
            for axE, i, j in ((axNS, 0, 2), (axEW, 1, 2)):
                axE.plot(w[:, i], w[:, j], color=col, lw=1.8, label=lab)
                if w_in is not None: axE.plot(w_in[:, i], w_in[:, j], color=col, lw=0.8)
                axE.plot([-R_ring * hd[i], R_ring * hd[i]], [z_deck + 0.1, z_deck + 0.1], color=col, lw=2.4, alpha=0.6)
                ee = np.radians(np.linspace(env.el_min_h - 2, env.el_max_h + 2, 40))
                arc = np.stack([R_arc * np.cos(ee) * hd[0], R_arc * np.cos(ee) * hd[1], z_f - R_arc * np.sin(ee)], 1)
                axE.plot(arc[:, i], arc[:, j], color=col, lw=0.9, ls="--", alpha=0.7)
                for rA in (0.66 * g, g):
                    eA = np.arccos(np.clip(rA / R_arc, -1, 1)); apex = np.array([R_arc * np.cos(eA) * hd[0], R_arc * np.cos(eA) * hd[1], z_f - R_arc * np.sin(eA)])
                    axE.plot([rA * hd[i], apex[i]], [z_deck + 0.1, apex[j]], color=col, lw=0.8, alpha=0.7)
                axE.plot([0, c[i]], [z_f, c[j]], color=col, lw=0.7, ls=":")                            # F to the dish centre (the orbit radius g)
    # the building, the tower, F, the bore, the pit (plan + elevations)
    axP.add_patch(plt.Rectangle((y_w, x_s), width, depth, fill=False, lw=2.5, color="k"))
    t = np.linspace(0, 2 * np.pi, 100)
    if b.get("rail", True): axP.plot(R_ring * np.sin(t), R_ring * np.cos(t), color="#7A6A55", lw=1.6, label=f"ring rail R {R_ring:.1f} m")
    axP.plot(0, 0, "ks", ms=7, label="post: F above, bore below"); axP.plot(-xt, 0, "o", ms=9, mfc="none", mec="#A83E2C", mew=2, label="tandoor pit (existing)")
    axP.text(0.25, -0.9, "N ↑", fontsize=9)
    for axE, i, lab in ((axNS, 0, "elevation looking west (x north →)"), (axEW, 1, "elevation looking north (y east →)")):
        lo, hi = (x_s, x_n) if i == 0 else (y_w, y_e)
        sw = sweep_x if i == 0 else sweep_y
        xr = (min(lo, sw[0], -R_ring) - 1.5, max(hi, sw[1], R_ring) + 1.5)
        axE.plot([lo, hi], [z_deck, z_deck], color="k", lw=2.5); axE.plot([lo, lo, hi, hi], [z_deck, z_deck + 0.35, z_deck + 0.35, z_deck], color="k", lw=1.2)    # deck + parapet
        # the neighbours' roofs beyond the parapet, at the same height (the worst case for an overhang)
        for a0, a1 in ((xr[0], lo - 0.25), (hi + 0.25, xr[1])):
            axE.add_patch(plt.Rectangle((a0, z_deck - 0.25), a1 - a0, 0.25, color="0.8", hatch="///", lw=0)); axE.plot([a0, a1], [z_deck, z_deck], color="0.4", lw=1)
        axE.text(xr[0] + 0.1, z_deck - 0.65, "neighbour's roof", fontsize=7, color="0.35")
        axE.axhline(z_low, color="0.5", lw=0.6, ls="--"); axE.text(xr[0] + 0.1, z_low + 0.08, f"lowest rim point all year: {z_low - z_deck:.2f} m above the deck", fontsize=7, color="0.35")
        axE.plot([lo, lo], [H_POT, z_deck], color="k", lw=1.0); axE.plot([hi, hi], [H_POT, z_deck], color="k", lw=1.0); axE.plot([lo, hi], [H_POT, H_POT], color="k", lw=1.0)   # the walls, the courtyard floor
        axE.plot([0, 0], [z_deck, z_f], color="k", lw=3); axE.plot(0, z_f, "ko", ms=6); axE.text(0.18, z_f + 0.12, "F (fixed): strip, bore mouth", fontsize=8)
        axE.plot([0, 0], [z_deck - 0.6, z_f], color="#D8641C", lw=5, alpha=0.35); axE.text(0.2, z_deck - 0.45, "bore → M4", fontsize=8, color="#D8641C")
        px = -xt if i == 0 else 0.0
        axE.add_patch(plt.Rectangle((px - R_POT, 0.0), 2 * R_POT, H_POT, fill=False, lw=1.5, color="#A83E2C")); axE.text(px - R_POT, -0.35, "pit", fontsize=8, color="#A83E2C")
        axE.plot([0, px], [z_deck - 0.6, Z_DUCT], color="#D8641C", lw=1.2, ls="-.")                                       # M4 to the pit's inlet (schematic)
        axE.set_xlim(*xr); axE.set_ylim(-0.6, z_f + a + 1.0); axE.set_title(lab, fontsize=10); axE.set_aspect("equal"); axE.grid(alpha=0.25); axE.set_ylabel("z [m] (pot floor 0)")
    axNS.set_xlabel("north [m]"); axEW.set_xlabel("east [m]"); axEW.legend(fontsize=7, loc="upper right")
    axP.set_aspect("equal"); axP.set_xlabel("east [m]"); axP.set_ylabel("north [m]"); axP.grid(alpha=0.25); axP.legend(fontsize=7, loc="upper left")
    for a0, a1, b0, b1 in ((y_w - 2.5, y_w, x_s - 2.5, x_n + 2.5), (y_e, y_e + 2.5, x_s - 2.5, x_n + 2.5), (y_w, y_e, x_s - 2.5, x_s), (y_w, y_e, x_n, x_n + 2.5)):
        axP.add_patch(plt.Rectangle((a0, b0), a1 - a0, b1 - b0, color="0.9", lw=0, zorder=0))
    ov = ", ".join(f"{k} {v:.1f}" for k, v in over.items() if v > 0.02) or "none"
    axP.set_title(f"plan: plot {width:.1f} (E-W) x {depth:.1f} (N-S) m, post at {tf:.1f} of the depth; section {b['area']:.1f} m², orbit g {g:.1f} m\ngrey: the year's sweep; it crosses the parapet by [m]: {ov}", fontsize=9)
    fig.suptitle(title or "The roof's section of the sphere on Hashemi's mount", fontsize=12)
    plt.tight_layout(); plt.savefig(out, dpi=130); plt.close(fig); print("views:", out)


if __name__ == "__main__" and "--section" in sys.argv:
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_section_surface import build_section
    kw = dict(num_agents=2, seed=1, device="cpu", gpu=0, n_rays=64, lat=LAT, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw)
    S = np.load("data/tandoor/section_site_fields.npy", allow_pickle=True).item(); xs = S["xs"]; grid = float(xs[1] - xs[0])
    X, Y = np.meshgrid(xs, xs, indexing="ij"); site = S["sites"]["4 x 6 (median)"]
    for cap, dF in ((2.0, 2.0), (3.5, 2.0)):
        mask = (site["need"] <= dF) & (site["over"] <= cap)
        d = build_section(mask, X, Y, grid, float(e.f_nom), [1.0], 64)
        b = dict(width=site["W"], depth=site["D"], tower_frac=float(site["tx"]), ty=float(site["ty"]), scale=1.0, theta=d["th"], rmax=d["rmax"], rmin=d["rmin"], area=d["area"], rise=dF, rail=False)
        draw_views(e, None, b, f"/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/section_views_4x6_cap{cap:.1f}.png",
                   title=f"The 4 x 6 m tandoor roof: the section of the parent the site allows (neighbours accept {cap} m of overhang, F raised {dF:.0f} m), {d['area']:.0f} m² of film on Hashemi's mount")
    sys.exit(0)


if __name__ == "__main__" and "--overhang" in sys.argv:
    # the as-built circular dish on the small roofs: what the overhang looks like
    from tandoor_hashemi_env import TandoorHashemiEnv
    kw = dict(num_agents=2, seed=1, device="cpu", gpu=0, n_rays=64, lat=LAT, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw)
    F = np.load("data/tandoor/roof_section_fields_quetta.npy", allow_pickle=True).item()
    q = np.array(json.load(open("data/tandoor/quetta_roof_quantiles.json")))
    for pct in (10, 25, 50):
        hw = q[pct]; b1 = dict(width=3 * hw, depth=2 * hw, tower_frac=0.4, scale=1.0, rmax=np.full(NTH, 2.1), area=np.pi * 2.1 ** 2)
        draw_views(e, F, b1, f"/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/overhang_circle_p{pct}.png", title=f"The as-built circular dish (a 2.1 m, g = f 4 m) on the p{pct} Quetta roof ({3*hw:.1f} x {2*hw:.1f} m): the overhang")
    sys.exit(0)


if __name__ == "__main__":
    from tandoor_hashemi_env import TandoorHashemiEnv
    kw = dict(num_agents=2, seed=1, device="cpu", gpu=0, n_rays=64, lat=LAT, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw)
    F = fields(e); print(f"fields over {F['n_poses']} sun positions of the year at Quetta (el >= 12), {len(SCALES)} scales")
    np.save("data/tandoor/roof_section_fields_quetta.npy", F, allow_pickle=True)
    q = np.array(json.load(open("data/tandoor/quetta_roof_quantiles.json")))
    OVER = float(sys.argv[sys.argv.index("--over") + 1]) if "--over" in sys.argv else 2.0     # the vertical rule's overhang allowance (deck 5 m)
    print(f"(overhang allowance {OVER:.1f} m past the parapet; setback {SETBACK} m; the circle rule at the same allowance)")
    print(f"{'roof pct':>8s} {'plot W x D m':>13s} {'circle a (old rule)':>19s} {'circle m2':>9s} | {'section reach m':>15s} {'section m2':>10s} {'gain':>5s} {'grid scale':>10s} | {'orientation':>18s}")
    rows = []
    for pct in (10, 25, 50, 75, 90):
        hw = q[pct]; short, long = 2 * hw, 3 * hw
        a_c = 2.1 * min((hw + OVER) / 6.1, 1.3)
        wide = outline(F, width=long, depth=short, over=OVER); deep = outline(F, width=short, depth=long, over=OVER)
        b = wide if wide["area"] >= deep["area"] else deep; b["wide"] = b is wide
        rows.append((pct, b))
        print(f"{pct:8d} {short:5.1f} x {long:4.1f}   {a_c:19.2f} {np.pi*a_c**2:9.1f} | {b['reach']:15.2f} {b['area']:10.1f} {b['area']/(np.pi*a_c**2):5.2f} {b['scale']:10.2f} | {'wide (long E-W)' if b is wide else 'deep (long N-S)':>15s}, post at {b['tower_frac']:.1f} of the depth; other {min(deep['area'], wide['area']):.1f} m2")
    import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
    fig, ax = plt.subplots(figsize=(7, 7)); th = np.r_[F["theta"], F["theta"][0]]
    for (pct, b), c in zip(rows, plt.cm.viridis(np.linspace(0.1, 0.9, len(rows)))):
        r = np.r_[b["rmax"], b["rmax"][0]]; ax.plot(r * np.cos(th), r * np.sin(th), color=c, lw=2, label=f"roof p{pct}: {b['area']:.0f} m2")
    t = np.linspace(0, 2 * np.pi, 100); ax.plot(2.1 * np.cos(t), 2.1 * np.sin(t), "k--", lw=1, label="nominal circle 13.9 m2")
    ax.set_aspect("equal"); ax.set_xlabel("dish frame x [m] (toward the tower at the top of the sky)"); ax.set_ylabel("dish frame y [m]"); ax.legend(fontsize=8); ax.grid(alpha=0.3)
    ax.set_title("The largest section of the sphere that never overhangs, per Quetta roof\n(Hashemi mount as built, hinged at F, all sun positions of the year)")
    plt.tight_layout(); plt.savefig("/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/roof_sections.png", dpi=130); print("figure: puffer_tandoor/watch/roof_sections.png"); plt.close(fig)
    for pct, b in rows:
        if pct in (50, 90):
            draw_views(e, F, b, f"/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/roof_section_views_p{pct}.png", title=f"Roof p{pct} of Quetta ({b['width']:.1f} x {b['depth']:.1f} m): the section of the sphere on Hashemi's mount, all on the deck")
    # the as-built circle on the p90 roof for comparison
    b1 = dict(width=rows[-1][1]["width"], depth=rows[-1][1]["depth"], tower_frac=rows[-1][1]["tower_frac"], scale=1.0, rmax=np.full(NTH, 2.1), area=np.pi * 2.1 ** 2)
    draw_views(e, F, b1, "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/roof_section_views_circle.png", title=f"For comparison: the as-built circular dish (a 2.1 m, g 4 m) on the p90 roof")

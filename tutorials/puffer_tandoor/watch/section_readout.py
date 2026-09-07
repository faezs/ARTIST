"""Section vs circle on the 4 x 6 m tandoor roof, with the demand-warm cook:
pinned days, seasoned (2 consecutive days, the second read), kit at the nominal
receiver, post mount, deck 4 m; the circle under the vertical rule (deck 4 and
deck 6.5) against sections at overhang caps 1 / 2 / 3.5 m and post rises 0..3 m."""
import sys, os, time, contextlib, io, json, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
LOG = "/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/section_library3.log"
while not any("library:" in l for l in open(LOG).read().splitlines()[-3:]):
    time.sleep(30)
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_design_readout import Policy, env_kwargs, run_day, ladder_day, DEV
import tandoor_system_cost as C
CK = "/Users/faezs/ARTIST/tutorials/puffer_tandoor/experiments/design_warm/demand60_pad94.pt"
REP = 48
variants = [("circle, deck 4 (vertical rule)", dict(section=0.0, deck_h=4.0, post_rise=0.0, over_cap=0.5)),
            ("circle, deck 6.5 (vertical rule)", dict(section=0.0, deck_h=6.5, post_rise=0.0, over_cap=0.5))]
for cap_u, cap in ((1/6, 1.0), (0.5, 2.0), (5/6, 3.5)):
    for rise in (0.0, 1.0, 2.0, 3.0):
        variants.append((f"section cap {cap} m, F +{rise:.0f} m", dict(section=1.0, deck_h=4.0, post_rise=rise, over_cap=cap_u)))
B = REP * len(variants)
pol = Policy(torch.load(CK, map_location="cpu", weights_only=False))
kw = env_kwargs(B, night_carry=1); kw.update(dict(design_rand=1, day_start=6.0, day_end=21.5, demand=1, demand_day=500.0))
with contextlib.redirect_stdout(io.StringIO()):
    e = TandoorHashemiEnv(**kw)
BOX = tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX); names = [k for k, _, _ in BOX]
u_nom = np.zeros(len(BOX))
for i, (k, lo, hi) in enumerate(BOX):
    v = getattr(e, k, None)
    if k in ("roof_r",): v = None
    u_nom[i] = 0.5 if v is None else float(np.clip((float(v) - lo) / (hi - lo), 0, 1))
site = dict(roof_r=0.5, cap_scale=(1.0 - 0.7) / 0.8, demand_scale=(1.0 - 0.5) / 1.5)          # the median roof, the model's pit, the nominal shop
kit = dict(mount_post=1.0, rate_scale=(1.0 - 0.5) / 1.5, ins_scale=1.0, lid_leak=(0.18 - 0.05) / 0.35, bread_area=0.5, loaves_per_load=1.0, sand_depth=0.0, sand_k=0.0)
U = np.tile(u_nom, (B, 1))
for vi, (name, ov) in enumerate(variants):
    for k, v in {**site, **kit, **{kk: (vv if kk in ("section", "over_cap") else (vv - dict(deck_h=3.0, post_rise=0.0)[kk]) / dict(deck_h=5.0, post_rise=3.0)[kk]) for kk, vv in ov.items()}}.items():
        U[vi * REP:(vi + 1) * REP, names.index(k)] = v
e.set_design_points(U)
d = e.design_points()
nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0])
print(f"{B} agents = {len(variants)} variants x {REP}; cook {os.path.basename(CK)}; roof 4 x 6 m (p50 of the tandoor table)", flush=True)
res = {}
for day in (172, 355, 80):
    rot, cuts, v0, ret, S = run_day(e, pol, day, nh, nv, ndays=2)
    lad = ladder_day(e, S, day, draws=4, noise=True)
    res[day] = (rot, lad, S.day_sold.cpu().numpy() if hasattr(S, "day_sold") else None)
    print(f"day {day} done", flush=True)
print(f"\n{'design':36s} {'film m2':>7s} {'site':>4s} {'bill k':>6s} | {'kW summer':>9s} {'kW winter':>9s} {'kW equinox':>10s} | {'rotis summer':>12s} {'rotis winter':>12s} {'rotis equinox':>13s}")
out = []
for vi, (name, ov) in enumerate(variants):
    sl = slice(vi * REP, (vi + 1) * REP); dd = {k: float(np.asarray(v)[sl].mean()) for k, v in d.items()}
    bill = C.capital(dd)["total"] / 1e3
    row = [name, dd["film"], dd["site"], bill] + [float(res[dy][1][sl].mean()) for dy in (172, 355, 80)] + [float(res[dy][0][sl].mean()) for dy in (172, 355, 80)]
    out.append(row)
    print(f"{name:36s} {row[1]:7.1f} {int(row[2] > 0):4d} {row[3]:6.1f} | {row[4]:9.2f} {row[5]:9.2f} {row[6]:10.2f} | {row[7]:12.1f} {row[8]:12.1f} {row[9]:13.1f}")
json.dump(dict(variants=[v[0] for v in variants], rows=out), open("/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/section_readout.json", "w"))

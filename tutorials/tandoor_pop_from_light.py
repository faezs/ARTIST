"""A design population from the trace: per roof site, the top decile of uniform kits by the light they put
into the pot at noon on the solstice AND midwinter, as the designer's Gaussian (logit mu / log_std) in the
design_pop.json contract redesign_at_dawn reads. The site columns (roof, pit, azimuth, horizon) are the
env's to draw; only the kit is fitted."""
import configparser, contextlib, io as _io, sys, json, numpy as np, torch
sys.path.append("/Users/faezs/ARTIST/tutorials")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_rl_env import _sim
OUT = sys.argv[1] if len(sys.argv) > 1 else "/Users/faezs/ARTIST/tutorials/puffer_tandoor/design_pop_lit.json"
N, KEEP, ROOFS, DAYS = 4096, 0.10, (0.10, 0.25, 0.50, 0.75, 0.90), (172, 355)
cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#")); cp.read("/Users/faezs/ARTIST/tutorials/puffer_tandoor/hashemi_design.ini")
KW = {}
for k, v in cp["env"].items():
    try: KW[k] = int(v)
    except ValueError:
        try: KW[k] = float(v)
        except ValueError: KW[k] = v
KW.update(num_agents=N, n_rays=128, day_random=0, lat_random=0, design_pop=None)
with contextlib.redirect_stdout(_io.StringIO()):
    e = TandoorHashemiEnv(**KW); e.reset(seed=11)
names = [k for k, _, _ in tuple(e.DESIGN_BOX) + tuple(e.SYS_BOX)]
SITE = list(e.SITE_KEYS); I_SITE = [names.index(k) for k in SITE]; I_KIT = [i for i in range(len(names)) if i not in I_SITE]
site_fixed = dict(cap_scale=0.375, demand_scale=1 / 3, over_cap=0.5, roof_light=0.0, grid=1.0, **TandoorHashemiEnv.site_nominal_u())
def logit(u): u = np.clip(u, 1e-4, 1 - 1e-4); return np.log(u / (1 - u))
def noon_pot(day):
    e.day = day; e.t_solar[:] = 12.0; e.day_v[:] = float(day); e.lat_v[:] = 30.2
    el, az, _ = _sim.solar_position(30.2, day, 12.0)
    e.el_m[:] = el; e.az_m[:] = np.degrees(az - e._ds_azs); e._e_el[:] = 0.0; e._e_az[:] = 0.0
    e._det_trace = True
    return e._trace_power(np.full(N, e.p0), np.full(N, 7e-3), np.zeros((N, 2)), np.ones(N)).cpu().numpy().sum(1)
rng = np.random.default_rng(2026)
pop = {"names": names, "site_keys": SITE, "kit_index": I_KIT, "sites": {}, "source": "pop_from_light.py: top decile of uniform kits by noon pot light on days 172+355, per roof quantile"}
for rq in ROOFS:
    u = rng.uniform(size=(N, len(names)))
    for k, v in site_fixed.items(): u[:, names.index(k)] = v
    u[:, names.index("roof_r")] = rq
    with contextlib.redirect_stdout(_io.StringIO()):
        e.set_design_points(u)
    e._hz[:] = 0.0; e._hz_t = torch.as_tensor(e._hz, dtype=torch.float32, device=e.device)      # the kit on a clear horizon
    light = np.stack([noon_pot(d) for d in DAYS], 1)
    score = light.min(1)                                                                         # a kit must work in winter too
    keep = score >= np.quantile(score, 1 - KEEP)
    z = logit(u[keep][:, I_KIT])
    mu, sd = z.mean(0), np.maximum(z.std(0), 0.15)
    site_u = [float(u[0, names.index(k)]) for k in SITE]
    pop["sites"][f"roof{rq:.2f}"] = {"site_u": site_u, "mu": mu.tolist(), "log_std": np.log(sd).tolist(),
                                     "n_kept": int(keep.sum()), "light_median_all": float(np.median(score)), "light_median_kept": float(np.median(score[keep]))}
    print(f"roof q{rq:.2f}: kept {keep.sum()} kits; noon pot light (min over solstice/midwinter) median all {np.median(score):.2f} -> kept {np.median(score[keep]):.2f}, kept p10 {np.percentile(score[keep],10):.2f}")
json.dump(pop, open(OUT, "w"), indent=1); print("wrote", OUT)
# what the fitted Gaussian actually gives back: redraw from it at the median roof and trace
s = pop["sites"]["roof0.50"]; u = rng.uniform(size=(N, len(names)))
for k, v in site_fixed.items(): u[:, names.index(k)] = v
u[:, names.index("roof_r")] = 0.5
zz = np.array(s["mu"]) + np.exp(np.array(s["log_std"])) * rng.standard_normal((N, len(I_KIT))); u[:, I_KIT] = 1 / (1 + np.exp(-zz))
with contextlib.redirect_stdout(_io.StringIO()):
    e.set_design_points(u)
e._hz[:] = 0.0; e._hz_t = torch.as_tensor(e._hz, dtype=torch.float32, device=e.device)
light = np.stack([noon_pot(d) for d in DAYS], 1).min(1)
print(f"redraw from the fitted Gaussian (roof q0.50): light median {np.median(light):.2f}  p10 {np.percentile(light,10):.2f}  p90 {np.percentile(light,90):.2f}")

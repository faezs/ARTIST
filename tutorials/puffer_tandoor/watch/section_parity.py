"""Sections of the parent on the megakernel vs the eager torch core, on a
mixed batch (block 0 = the built circle, blocks 1, 2 = two sections of the
4 x 6 roof), and the power each surface delivers."""
import sys, contextlib, io, time, numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_section_surface import build_section
B = 96
kw = dict(num_agents=B, seed=1, device="mps", gpu=1, n_rays=512, lat=30.2, g_orbit=4.0, n_zones=5, zone_c=0.4, deck_h=4.0, nurbs=1, silvered=1, duct_nozzle=2, receiver="cass", r_m4=1.3, beta_dev=0.0, beta_cap_z=7.6, wide_shutter=1, flare_ratio=1.4, flare_reflect=0.6, elbow_aim=1, spot_bread=1, wall="ifb", insulation=1, night_carry=1)
buf = io.StringIO()
with contextlib.redirect_stdout(buf):
    e = TandoorHashemiEnv(**kw)
    e.reset(seed=1)
S = np.load("/Users/faezs/ARTIST/tutorials/data/tandoor/section_site_fields.npy", allow_pickle=True).item(); xs = S["xs"]; grid = float(xs[1] - xs[0])
X, Y = np.meshgrid(xs, xs, indexing="ij"); site = S["sites"]["4 x 6 (median)"]
secs = []
for cap, dF in ((2.0, 2.0), (3.5, 2.0)):
    mask = (site["need"] <= dF) & (site["over"] <= cap)
    secs.append(build_section(mask, X, Y, grid, float(e.f_nom), list(e.LEVEL_FRAC), e.n_rays, loss_chain=float(e._loss_chain)))
print("sections:", [f"{d['area']:.1f} m2" for d in secs], " circle:", f"{np.pi*e.a_mem**2:.1f} m2", " ray_pw sums (W/(W/m2)):", [f"{float(d['ray_pw'].sum()):.2f}" for d in secs], f"circle {float(e._ray_pw.sum()):.2f}")
e.install_sections(secs)
blk = torch.arange(B, device=e.device) % 3
e._fct[:, e.DS["site"]] = blk.float(); e._refresh_site_weights()
print(f"stacked pts_l {tuple(e._pts_l.shape)}, ray_pw {tuple(e._ray_pw.shape)}, N_SURF {e.N_SURF}, per-agent weights {tuple(e._ray_pw_agent.shape)}")
t0 = time.time(); mism, maxd = e.verify_megakernel(); print(f"megakernel vs eager torch on the mixed batch: {mism} node-power mismatches > 1e-3, max |diff| {maxd:.2e}  ({time.time()-t0:.0f}s incl. compile)")
# the power each surface delivers at this pose (summer noon), both paths
pe, sg = np.full(B, e.per_level if hasattr(e, "per_level") else e.p0), np.full(B, 7e-3)
metal, e._metal = e._metal, None; e.tick = 77; ref = e._trace_power(pe, sg, np.zeros((B, 2)), np.ones(B)); e._metal = metal; e.tick = 77
fus = e._trace_power(pe, sg, np.zeros((B, 2)), np.ones(B))
for k, name in enumerate(("built circle 13.9 m2", f"section cap 2 ({secs[0]['area']:.0f} m2)", f"section cap 3.5 ({secs[1]['area']:.0f} m2)")):
    m = (blk == k).cpu().numpy()
    print(f"  {name:28s} power into the pot: torch {float(ref[m].sum(1).mean()):8.1f}  metal {float(fus[m].sum(1).mean()):8.1f}  (per m2 of film: {float(fus[m].sum(1).mean()) / (np.pi*e.a_mem**2 if k == 0 else secs[k-1]['area']):.1f})")

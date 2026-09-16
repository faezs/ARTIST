"""HOMOTOPY CONTINUATION FOR THE DAY'S PATH (user, 2026-09-13: "i want homotopy to find the path ... what about the
motors and stuff? the frame and the dynamics and optics?").

The path is a whole day of the machine: the mount's arc through the frame (the screw chain and its limits, with the
azimuth/elevation OFFSETS the cook holds to steer the spot - the motors and the optics are in the loop through the
kernel's mount solve and the trace), the pump's pressure ladder (the film's figure), the jam and release of the film
(re-forming), the loads. A candidate path is a point theta in a small space:

    t_jam      hour the film is jammed (before it: soft, re-forming, dark)
    t_rel, dur hour and minutes of one release to re-form at midday (dur 0 = never: a different dihomotopy class)
    L_am, L_pm pump level before / after t_switch          (the optics: the ladder's focus)
    T_load     wall temperature the cook waits for before loading (K)
    d_el, d_az the held pointing offsets (deg): the frame steering the beam across the bread

evaluated by the physics twin itself (the Metal megakernel: mount, trace, thermal, bread) as rotis by dusk, 512 paths a
rollout. HOMOTOPY: the physics is deformed by lambda from an ideal day (clear-sky beam, no wind) to the site's own
(its recorded average day and the neighbourhood wind); at each lambda the optimum is re-found by a cross-entropy
search WARM-STARTED from the previous lambda's optimum. The result is the solution path theta*(lambda) - how the
day's plan bends as the real physics is switched on - and the walls: the lambdas where the best plan changes its
dihomotopy class (release / no release; level order; load timing order) and continuation has to jump.

    python tandoor_homotopy.py [--lambdas 5] [--gens 3] [--agents 512] [--ckpt model.pt]
"""
import sys, io, time, json, argparse, contextlib
import numpy as np, torch
sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")
from tandoor_hashemi_env import TandoorHashemiEnv
from tandoor_design_readout import env_kwargs, DEV, Policy
from tandoor_fused_step import FusedState
from tandoor_mount_batch import solar_batch

NAMES = ["t_jam", "t_rel", "dur_min", "L_am", "L_pm", "t_switch", "T_load", "d_el", "d_az"]
LO = np.array([8.0, 10.0, 0.0, 0.0, 0.0, 9.0, 380.0, -1.5, -1.5]); HI = np.array([11.0, 15.0, 40.0, 6.99, 6.99, 15.5, 520.0, 1.5, 1.5])
DAY0, DAY1, DOY = 8.0, 16.0, 172


def make_env(B, seed=0):
    kw = env_kwargs(B, receiver="tri", site_weather="quetta", site_mean=1, site_days=0, warm_frac=1.0)
    kw.update(seed=seed, design_rand=0, sticky_k=1, day_of_year=DOY, day_start=DAY0, day_end=DAY1, n_rays=512)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=seed)
    return e


def clear_sky_day(lat=30.2, doy=DOY):
    """the ideal beam by local hour: the env's own clear-sky law at Quetta's sun"""
    from tandoor_rl_env import _sim
    dni = np.zeros(24)
    for h in range(24):
        el, _, _ = _sim.solar_position(lat, doy, h + 0.5)
        dni[h] = _sim.clear_sky_dni(el) if el > 2.0 else 0.0
    return dni


def deform(e, lam, site_tab, clear):
    """lambda = 0: clear-sky beam, no wind; 1: the site's average day and its neighbourhood wind (rows 0..2 of the site table)"""
    B = e.num_agents; tab = site_tab.copy()
    tab[:, 0] = (1 - lam) * clear[None, :] + lam * site_tab[:, 0]
    tab[:, 1] = lam * site_tab[:, 1] + (1 - lam) * 0.05; tab[:, 2] = lam * site_tab[:, 2] + (1 - lam) * 0.06
    e._sw_tab = tab; e._sw_tab_t = torch.as_tensor(tab, dtype=torch.float32, device=e.device)


def rollout(e, theta):
    """theta (B, 9): each agent walks its own path through one day; returns rotis by dusk (B,)"""
    B = e.num_agents; th = torch.as_tensor(theta, dtype=torch.float32, device=DEV)
    e.day = DOY; e.lat = 30.2; e.day_v[:] = DOY; e.lat_v[:] = 30.2; e.t_solar[:] = DAY0
    with contextlib.redirect_stdout(io.StringIO()):
        e.reset(seed=1)
    e.day_v[:] = DOY; e.lat_v[:] = 30.2
    S = FusedState(e); e._gpu = S; S.site.copy_(e._sw_tab_t[:, :3].reshape(B, -1))
    nh = e.N_HEADS; a = torch.full((B, nh), 3, dtype=torch.long, device=DEV)
    t_jam, t_rel, dur, L_am, L_pm, t_sw, T_load, d_el, d_az = [th[:, i] for i in range(9)]
    for step in range(100000):
        t = float(e.t_solar[0])
        # THE MOUNT ON THE SUN, through the frame, with the held offsets: the motors' path
        el, az, _ = solar_batch(S.lat_v, S.day_v, t, az_off=e._ds_azs_t)
        S.el_m.copy_((el + d_el).clamp(e.el_min_h, e.el_max_h)); S.az_m.copy_(torch.rad2deg(az) + d_az)
        jam = (t >= t_jam) & ~((t >= t_rel) & (t < t_rel + dur / 60.0) & (dur > 0.5))
        a[:, 0] = torch.where(torch.tensor(t < float(0)) | (t < t_sw), L_am, L_pm).clamp(0, 6).long()
        a[:, 1] = 6; a[:, 2] = torch.where(jam, 6, 0); a[:, 3:5] = 3
        if nh > 5 + e.n_belt: a[:, 5:7] = 3
        hot = S.T[:, :e.n_belt].mean(1) >= T_load
        a[:, -e.n_belt:] = torch.where(hot[:, None], 6, 0)
        o, r, d, tr, inf = e.step_torch(a)
        if d.reshape(-1).any() or float(e.t_solar[0]) >= DAY1 - 1e-6: break
    return S.day_rotis.detach().cpu().numpy().copy()


def cem(e, mu, sd, gens, B, elite=0.1, smooth=0.5, log=print):
    best = None
    for g in range(gens):
        th = np.clip(mu + sd * np.random.randn(B, len(mu)), LO, HI); th[0] = mu
        rot = rollout(e, th); idx = np.argsort(-rot)[:max(4, int(elite * B))]
        mu = smooth * mu + (1 - smooth) * th[idx].mean(0); sd = smooth * sd + (1 - smooth) * (th[idx].std(0) + 0.02 * (HI - LO))
        b = int(np.argmax(rot)); best = (float(rot[b]), th[b].copy()) if best is None or rot[b] > best[0] else best
        log(f"      gen {g}: best {rot.max():.0f} rotis, elite mean {rot[idx].mean():.0f}, population mean {rot.mean():.0f}")
    return mu, sd, best


def klass(th):
    """the dihomotopy class of a path: which qualitative order its events have"""
    t_jam, t_rel, dur, L_am, L_pm, t_sw = th[:6]
    parts = ["re-form at midday" if dur > 0.5 else "jam once"]
    parts.append("level up pm" if round(L_pm) > round(L_am) else "level down pm" if round(L_pm) < round(L_am) else "one level")
    parts.append("switch before jam" if t_sw < t_jam else "switch after jam")
    return " / ".join(parts)


def main(lambdas=5, gens=3, B=512, ckpt=None):
    e = make_env(B); site_tab = e._sw_tab.copy(); clear = clear_sky_day()
    print(f"the site's average day {DOY} at Quetta vs the clear sky: noon beam {site_tab[0, 0, 12]:.0f} vs {clear[12]:.0f} W/m2; wind at the dish 14 h {site_tab[0, 1, 14]:.1f} m/s, gust {site_tab[0, 2, 14]:.1f}")
    mu = np.array([8.5, 12.0, 0.0, 4.0, 4.0, 12.0, 450.0, 0.0, 0.0]); sd = 0.25 * (HI - LO)
    path = []
    for lam in np.linspace(0.0, 1.0, lambdas):
        deform(e, float(lam), site_tab, clear); t0 = time.time()
        print(f"\nlambda {lam:.2f} (beam {'clear' if lam == 0 else 'site' if lam == 1 else 'blend'}, wind x{lam:.2f}): continuation from theta* of the previous lambda")
        mu, sd, best = cem(e, mu, sd, gens, B)
        k = klass(best[1]); path.append(dict(lam=float(lam), rotis=best[0], theta=best[1].tolist(), klass=k))
        print(f"   theta*({lam:.2f}): " + ", ".join(f"{n} {v:.1f}" for n, v in zip(NAMES, best[1])) + f"  -> {best[0]:.0f} rotis  [{k}]  ({time.time() - t0:.0f} s)")
    print("\nTHE SOLUTION PATH theta*(lambda), and its walls:")
    prev = None
    for p in path:
        wall = "  <- WALL: the class changed, continuation jumped" if prev and p["klass"] != prev else ""
        print(f"   lambda {p['lam']:.2f}: {p['rotis']:4.0f} rotis  jam {p['theta'][0]:.1f} h, re-form {p['theta'][1]:.1f} h x {p['theta'][2]:.0f} min, levels {p['theta'][3]:.0f}->{p['theta'][4]:.0f} at {p['theta'][5]:.1f} h, load above {p['theta'][6]:.0f} K, offsets el {p['theta'][7]:+.2f} az {p['theta'][8]:+.2f} deg  [{p['klass']}]{wall}")
        prev = p["klass"]
    if ckpt and torch.load(ckpt, map_location="cpu", weights_only=False)["policy.encoder.0.weight"].shape[1] != e.single_observation_space.shape[0]:
        print(f"\n(the checkpoint expects {torch.load(ckpt, map_location='cpu', weights_only=False)['policy.encoder.0.weight'].shape[1]}-wide obs, this single-design env gives {e.single_observation_space.shape[0]}: build the env with design_rand=1 to compare; skipped)"); ckpt = None
    if ckpt:
        deform(e, 1.0, site_tab, clear); pol = Policy(torch.load(ckpt, map_location="cpu", weights_only=False))
        e.day = DOY; e.lat = 30.2; e.day_v[:] = DOY; e.lat_v[:] = 30.2
        with contextlib.redirect_stdout(io.StringIO()):
            e.reset(seed=1)
        e.day_v[:] = DOY; e.lat_v[:] = 30.2; S = FusedState(e); e._gpu = S; S.site.copy_(e._sw_tab_t[:, :3].reshape(B, -1)); pol.reset(B); torch.manual_seed(1)
        nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0]); o, *_ = e.step_torch(torch.full((B, nh), 3, dtype=torch.long, device=DEV))
        with torch.no_grad():
            for step in range(100000):
                act, _ = pol.step(o, nh, nv); o, r, d, tr, _ = e.step_torch(act)
                if d.reshape(-1).any(): break
        rp = S.day_rotis.cpu().numpy()
        print(f"\nfor scale, the trained policy ({ckpt.split('/')[-1]}) on the same day, same warm pits, lambda 1: {rp.mean():.0f} rotis mean, best agent {rp.max():.0f}")
    json.dump(path, open("/Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/homotopy_path.json", "w"), indent=1); print("-> puffer_tandoor/watch/homotopy_path.json")


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("--lambdas", type=int, default=5); ap.add_argument("--gens", type=int, default=3); ap.add_argument("--agents", type=int, default=512); ap.add_argument("--ckpt", default=None)
    a = ap.parse_args(); main(a.lambdas, a.gens, a.agents, a.ckpt)

"""THE TRAINED POLICY AGAINST THE PROVED THEOREMS (user, 2026-09-17).

`tandoor_laws_check.py` checks the SIMULATOR against the laws in ~/manifold-pareto/lean.  This checks
the POLICY: it rolls a checkpoint over the Pakistan/Balochistan site pool and, for each theorem,
asserts BOTH halves - that the policy keeps the theorem's HYPOTHESIS true, and that its CONCLUSION
then holds in the rollout.  A theorem whose hypothesis fails is not a statement about this machine,
however well proved, and saying WHERE it fails is the point of this script.

  P1  the mount never outruns its slew rate        Mount.lean   `follow`, `follow_exact`
  P2  the sun is slower than the motor             Mount.lean   `follow_exact` needs omega <= r
  P3  no cut fires where that hypothesis holds     Mount.lean   `cut`, `no_cut_of_exact`
  P4  the stow latch does not chatter              Wind.lean    `latch_of_band`, `stow_const_of_band`
  P5  the film is never slack while lit            MembraneFvK  `kEff_zero_iff_no_pretension`
  P6  the machine never works above its stow limit Wind.lean    `stow_threshold_quetta`, `stow_sheds_load`
  P7  sales never exceed what was baked            Physics.lean `SummingFunctor.sumOn_union`
  P8  the pot dissipates in the dark               ThermalDiscrete `ofGraph_explicit_euler_le`

    PYTHONPATH=..:.:puffer_tandoor puffer_tandoor/.venv/bin/python tandoor_policy_props.py [CKPT] [DAY]
"""
import contextlib, io, sys, os
import numpy as np, torch

sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")

# the defaults; `main()` reads the command line. NOT at import: tandoor_resources and the Pareto
# readout import solpos/dcirc from here, and their own arguments were being parsed as ours
CKPT = "/Users/faezs/ARTIST/tutorials/puffer_tandoor/experiments/178926893901/model_000573.pt"
DAY = 173                                                      # the solstice: the worst day for a keyhole
FAILURES = []


def check(name, ok, detail="", lean=""):
    print(f"   [{'PASS' if ok else 'FAIL'}] {name}" + (f"  [{lean}]" if lean else ""), flush=True)
    for line in detail.splitlines():
        if line.strip(): print(f"          {line}", flush=True)
    if not ok: FAILURES.append(name)
    return ok


def solpos(lat, doy, hour):
    """the env's own solar position, in degrees; kept here so this script has no import cycle"""
    phi = np.radians(lat); d = np.radians(23.44) * np.sin(2 * np.pi * (284 + doy) / 365)
    h = np.radians(15.0 * (hour - 12.0))
    se = np.sin(phi) * np.sin(d) + np.cos(phi) * np.cos(d) * np.cos(h)
    el = np.arcsin(np.clip(se, -1, 1))
    ca = (np.sin(d) - se * np.sin(phi)) / max(np.cos(el) * np.cos(phi), 1e-9)
    az = np.arccos(np.clip(ca, -1, 1))
    return np.degrees(el), np.degrees(2 * np.pi - az if h > 0 else az)


def dcirc(x, axis=0):
    """a difference of headings, taken the short way round"""
    d = np.abs(np.diff(x, axis=axis)) % 360.0
    return np.minimum(d, 360.0 - d)


def rollout(B=64, steps_max=4000):
    """the checkpoint driving the design env over the site pool; returns one day of the record"""
    import configparser
    from tandoor_hashemi_env import TandoorHashemiEnv
    from tandoor_fused_step import FusedState
    from tandoor_design_readout import Policy, DEV
    cp = configparser.ConfigParser(inline_comment_prefixes=(";", "#"))
    cp.read("/Users/faezs/ARTIST/tutorials/puffer_tandoor/hashemi_design.ini")
    kw = {}
    for k, v in cp["env"].items():
        v = v.strip()
        try: kw[k] = int(v)
        except ValueError:
            try: kw[k] = float(v)
            except ValueError: kw[k] = v
    kw.update(num_agents=B, n_rays=256, seed=7, day_of_year=DAY, day_random=0, site_days=0)
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(**kw); e.reset(seed=7)
    e.day_v[:] = DAY; e._sw_refresh()
    S = FusedState(e); e._gpu = S
    sd = torch.load(CKPT, map_location="cpu", weights_only=False)
    assert sd["policy.encoder.0.weight"].shape[1] == e.single_observation_space.shape[0], \
        "obs width mismatch: this checkpoint is not for this env"
    pol = Policy(sd); pol.reset(B); torch.manual_seed(7)
    nh, nv = e.N_HEADS, int(e.single_action_space.nvec[0])
    keys = ("az", "el", "wind", "stow", "p_act", "shutter", "dni", "rotis")
    rec = {k: [] for k in keys + ("e_az", "e_el", "T", "trunc", "t")}
    o, r, d, tr, _ = e.step_torch(torch.full((B, nh), 3, dtype=torch.long, device=DEV))
    with torch.no_grad():
        for _ in range(steps_max):
            act, _ = pol.step(o, nh, nv)
            o, r, d, tr, _ = e.step_torch(act)
            rec["t"].append(float(e.t_solar[0]))
            for k, v in zip(keys, (S.az_m, S.el_m, S.wind, S.stowed, S.p_act, S.shutter,
                                   S.dni, S.day_rotis)):
                rec[k].append(v.detach().cpu().numpy().copy())
            rec["e_az"].append(np.asarray(e._e_az_t.detach().cpu()).copy())
            rec["e_el"].append(np.asarray(e._e_el_t.detach().cpu()).copy())
            rec["T"].append(S.T.detach().cpu().numpy().mean(1).copy())
            rec["trunc"].append(np.asarray(tr.detach().cpu().numpy() if torch.is_tensor(tr)
                                            else tr).reshape(-1).astype(bool).copy())
            dn = d.detach().cpu().numpy() if torch.is_tensor(d) else np.asarray(d)
            if dn.reshape(-1).any(): break
    R = {k: np.asarray(v) for k, v in rec.items()}
    # ONE day.  The episode runs past midnight: t_solar wraps, the mount re-homes and the day's
    # counters reset, and none of that is the policy slewing or selling.  Cut at the first wrap.
    w = np.nonzero(np.diff(R["t"]) < 0)[0]
    n = int(w[0]) + 1 if w.size else len(R["t"])
    return e, S, {k: v[:n] for k, v in R.items()}, n < len(R["t"])


def main():
    global CKPT, DAY
    if len(sys.argv) > 1: CKPT = sys.argv[1]
    if len(sys.argv) > 2: DAY = int(sys.argv[2])
    print(f"THE POLICY AGAINST THE PROVED THEOREMS\n   checkpoint {os.path.basename(CKPT)}")
    e, S, R, wrapped = rollout()
    B = e.num_agents; dt = float(e.dt); n = R["az"].shape[0]
    lat = np.asarray(e.lat_v).reshape(-1).astype(float)
    print(f"   {n} steps of {dt:.0f} s, {B} agents over {len(set(e.site_idx.tolist()))} sites of the pool "
          f"(lat {lat.min():.1f} to {lat.max():.1f} N), day {DAY}, "
          f"{R['t'][0]:.1f}h to {R['t'][-1]:.1f}h solar"
          + (", record cut at the day boundary" if wrapped else "")
          + f", {R['rotis'][-1].mean():.1f} rotis/day mean\n")

    # PER AGENT: the design randomisation gives each machine its own motor, so every bound below
    # is a vector.  Reading agent 0's rate for all 64 is what made this look broken the first time.
    rate = np.asarray(getattr(e, "_ds_rate", np.ones(B))).reshape(-1).astype(float) * np.ones(B)
    lim_az = e.RATE_AZ * rate * dt
    lim_el = e.RATE_EL * rate * dt
    # the guillotine SNAPS the mount onto the sun in the same step it reports the cut
    # (tandoor_hashemi_env.py:3340) - that snap is a reset, not a slew, so drop those steps
    snap = R["trunc"][1:] | R["trunc"][:-1]
    move_ok = ~snap

    # ---- P1 the mount never outruns its slew rate --------------------------------------------
    slack = 0.12                      # the env's own backlash: 0.02 deg per step, 6 sigma
    daz = np.where(move_ok, dcirc(R["az"]), 0.0) - (lim_az + slack)
    dele = np.where(move_ok, np.abs(np.diff(R["el"], axis=0)), 0.0) - (lim_el + slack)
    check("the mount never outruns its slew rate", daz.max() <= 0 and dele.max() <= 0,
          f"worst overshoot of the agent's OWN limit: az {daz.max():+.4f} deg, el {dele.max():+.4f} deg "
          f"(limits {lim_az.min():.3f}-{lim_az.max():.3f} deg/step across the batch, +{slack} backlash)\n"
          f"{int(R['trunc'].sum())} guillotine snaps excluded - a snap is a reset, not a slew",
          "Mount.lean follow, follow_exact")

    # ---- P2 the sun is slower than the motor: the hypothesis the follower theorems need ---------
    el_min = float(getattr(e, "el_min_h", 8.0))
    hyp_ok, need, zen = np.ones(B, bool), np.zeros(B), np.zeros(B)
    tracking = np.zeros((n, B), bool)                     # the sun is up far enough to be tracked
    keyholes = []
    for b, la in enumerate(lat):
        p = np.array([solpos(la, DAY, t) for t in R["t"]])
        tracking[:, b] = p[:, 0] >= el_min
        up = p[:, 0] > 0.0; both = up[:-1] & up[1:]
        w_az = np.where(both, dcirc(p[:, 1]), 0.0)
        need[b] = w_az.max()                              # what this SITE demands of a motor
        zen[b] = 90.0 - p[:, 0].max()                     # how close the sun comes to the zenith
        bad = w_az > lim_az[b]                            # against what THIS machine has
        if bad.any():
            hyp_ok[b] = False
            i = np.nonzero(bad)[0]
            keyholes.append((la, R["t"][i[0]], R["t"][i[-1] + 1], zen[b], w_az.max()))
    marg = lim_az / np.maximum(need, 1e-9)                # 1 = the motor exactly keeps up
    dpm = 60.0 / dt                                       # deg/step -> deg/min
    if keyholes:
        det = (f"DEMAND (the site): the sun's azimuth peaks at {need.min() * dpm:.1f}-{need.max() * dpm:.1f} "
               f"deg/min across the pool on day {DAY}; the steepest sites pass within "
               f"{zen.min():.1f} deg of the zenith, where an alt-az azimuth sweeps fastest\n"
               f"SUPPLY (the machine): the design draw gives motors of "
               f"{lim_az.min() * dpm:.1f}-{lim_az.max() * dpm:.1f} deg/min\n"
               f"{int((~hyp_ok).sum())} of {B} machines are outrun, margin {marg.min():.2f}x at worst; "
               f"the keyhole is open {min(k[1] for k in keyholes):.2f}h to "
               f"{max(k[2] for k in keyholes):.2f}h solar\n"
               f"it is not one cause but two: {int((~hyp_ok & (zen < 5)).sum())} fail under a near-zenith "
               f"sun, {int((~hyp_ok & (zen >= 5)).sum())} on a slow motor alone (the slowest are "
               f"{lim_az[~hyp_ok].min() * dpm:.1f} deg/min at {zen[~hyp_ok][np.argmin(lim_az[~hyp_ok])]:.0f} "
               f"deg from the zenith)\n"
               f"this is the MOUNT, not the policy - inside the keyhole no command satisfies "
               f"follow_exact, so the follower theorems say nothing there\n"
               f"DESIGN: {need.max() * dpm:.1f} deg/min of azimuth covers every site in this pool on the "
               f"worst day; {marg[hyp_ok].min():.2f}x is the thinnest margin that survived")
    else:
        det = (f"every machine keeps up, thinnest margin {marg.min():.2f}x "
               f"(site demand up to {need.max() * dpm:.2f} deg/min)")
    check("the sun is slower than the motor at every site (the follower theorems' hypothesis)",
          bool(hyp_ok.all()), det, "Mount.lean follow_exact needs omega <= r")

    # ---- P3 no cut fires where that hypothesis holds --------------------------------------------
    # the recorded error is POST-snap on a cut step, so read the tracking error the step before
    # the recorded error is huge before the sun clears the mount's minimum elevation, where the lost
    # counter does not run at all (tandoor_metal_kernel.py:1589) - the theorem is about tracking
    err = np.where(R["trunc"] | ~tracking, 0.0, np.abs(R["e_az"]) + np.abs(R["e_el"]))
    cuts = R["trunc"].sum(0); good = hyp_ok
    ii, bb = np.nonzero(R["trunc"])
    pre = err[np.maximum(ii - 1, 0), bb]
    det = (f"{int(cuts[good].sum())} cuts at the {int(good.sum())} machines the theorem covers, "
           f"worst tracking error there {err[:, good].max() if good.any() else 0.0:.2f} deg "
           f"vs lost_deg {e.lost_deg:.1f} (measured only while the sun is above the mount's "
           f"{el_min:.0f} deg floor, which is where the lost counter runs)")
    if (~good).any():
        det += (f"\n{int(cuts[~good].sum())} cuts at the {int((~good).sum())} keyhole machines, "
                f"worst error there {err[:, ~good].max():.1f} deg - outside the theorem's reach")
    if ii.size:
        was_cut = cuts > 0
        lost_rotis = R["rotis"][-1][~was_cut].mean() - R["rotis"][-1][was_cut].mean()
        # WHEN did each cut fire: minutes after this agent's sun cleared the mount's floor, and
        # minutes from solar transit.  A cut at dawn is an acquisition failure, one at transit the keyhole.
        dawn_i = np.array([np.argmax(tracking[:, b]) if tracking[:, b].any() else 0 for b in range(B)])
        since_dawn = (R["t"][ii] - R["t"][dawn_i[bb]]) * 60.0
        from_noon = np.abs(R["t"][ii] - 12.0) * 60.0
        acq = since_dawn <= 30.0
        det += (f"\ncuts fell between {R['t'][ii.min()]:.2f}h and {R['t'][ii.max()]:.2f}h solar, "
                f"error {pre.min():.1f}-{pre.max():.1f} deg going in\n")
        if acq.any():
            # the counter allows 40 steps of lost sun; what rate closes the dawn gap in that time?
            grace = 40 * dt / 60.0
            det += (f"WHEN: {int(acq.sum())} cut within 30 min of the sun clearing the mount's "
                    f"{el_min:.0f} deg floor - ACQUISITION, not tracking: the mount is left where the "
                    f"sun set and the sunrise azimuth is {pre[acq].min():.0f}-{pre[acq].max():.0f} deg "
                    f"away, while the lost counter allows only {grace:.0f} min\n"
                    f"      closing that needs {pre[acq].min() / grace:.1f}-{pre[acq].max() / grace:.1f} "
                    f"deg/min; those machines have {lim_az[bb[acq]].min() * dpm:.1f}-"
                    f"{lim_az[bb[acq]].max() * dpm:.1f}\n")
            # the sharp question: was the motor too slow, or was it fast enough and not used?
            slow = (pre[acq] / grace) > (lim_az[bb[acq]] * dpm)
            det += (f"      of those, {int(slow.sum())} had no motor fast enough and "
                    f"{int((~slow).sum())} DID and still lost the sun - the policy does not slew "
                    f"through the dark, where there is no flux to reward it\n")
        if (~acq).any():
            det += (f"WHEN: {int((~acq).sum())} cut {from_noon[~acq].min():.0f}-"
                    f"{from_noon[~acq].max():.0f} min from transit - the keyhole\n")
        det += (f"COST: the {int(was_cut.sum())} machines that lost the sun finished on "
                f"{R['rotis'][-1][was_cut].mean():.0f} rotis against {R['rotis'][-1][~was_cut].mean():.0f} "
                f"for the rest - {lost_rotis:.0f} rotis, "
                f"{100 * lost_rotis / max(R['rotis'][-1][~was_cut].mean(), 1e-9):.0f}% of the day, "
                f"for a few minutes of geometry")
    check("no guillotine cut fires where the follower hypothesis holds",
          int(cuts[good].sum()) == 0, det, "Mount.lean cut, no_cut_of_exact")

    # ---- P4 the stow latch does not chatter ----------------------------------------------------
    w, st = R["wind"], R["stow"] > 0.5
    band = (w[:-1] >= 14.0) & (w[:-1] <= 16.0) & (w[1:] >= 14.0) & (w[1:] <= 16.0)
    flips = st[:-1] != st[1:]
    check("the stow latch never changes state inside its dead band", int((band & flips).sum()) == 0,
          f"{int(band.sum())} agent-steps with the wind in [14, 16] m/s, {int((band & flips).sum())} "
          f"state changes there; {int(flips.sum())} changes in all, wind max {w.max():.1f} m/s"
          + ("\nthe dead band was never entered on this day: the latch is untested, not proved"
             if band.sum() == 0 else ""),
          "Wind.lean latch_of_band, stow_const_of_band")

    # ---- P5 the film is never slack while lit --------------------------------------------------
    lit = (R["shutter"] > 0.5) & (R["dni"] > 1.0)
    check("the film is never slack while the beam is on", int((lit & (R["p_act"] <= 0.0)).sum()) == 0,
          f"{int(lit.sum())} lit agent-steps, held pressure "
          f"{R['p_act'][lit].min():.0f} to {R['p_act'][lit].max():.0f} Pa (nominal p0 = {e.p0:.0f}); "
          f"kEff > c2 everywhere the beam is on, so the linearisation the gust bound uses exists",
          "MembraneFvK kEff_zero_iff_no_pretension")

    # ---- P6 the machine never works above its stow limit ---------------------------------------
    working = (R["shutter"] > 0.5) & (~st)
    check("the machine never works above the stow threshold", int((working & (w > 16.0)).sum()) == 0,
          f"{int(working.sum())} working agent-steps, worst wind while working "
          f"{w[working].max() if working.any() else 0.0:.1f} m/s vs the 16 m/s latch",
          "Wind.lean stow_threshold_quetta, stow_sheds_load")

    # ---- P7 sales never exceed what was baked --------------------------------------------------
    drot = np.diff(R["rotis"], axis=0)
    check("the day's sales never decrease (a summing functor, not a ledger that leaks)",
          bool((drot >= -1e-6).all()),
          f"worst single-step decrease {drot.min():.3e}; final {R['rotis'][-1].mean():.1f} rotis/day, "
          f"best agent {R['rotis'][-1].max():.0f}", "Physics.lean SummingFunctor.sumOn_union")

    # ---- P8 the pot dissipates when the beam is off --------------------------------------------
    dark = R["dni"] < 1.0
    rises, nruns = [], 0
    for b in range(B):                    # CONTIGUOUS runs: a diff across the lit day is the day
        idx = np.nonzero(dark[:, b])[0]
        for run in np.split(idx, np.nonzero(np.diff(idx) != 1)[0] + 1):
            if len(run) > 1:
                nruns += 1; rises.append(float(np.diff(R["T"][run, b]).max()))
    worst = max(rises) if rises else float("nan")
    check("the pot's mean temperature never rises while the beam is off",
          (not rises) or worst <= 0.6,
          f"{nruns} contiguous dark runs over {B} agents, worst single-step rise {worst:.4f} K "
          f"(the wall and the loaves move it a little; a systematic rise would be a leak)",
          "ThermalDiscrete ofGraph_explicit_euler_le, energy_antitone")

    print(f"\n{len(FAILURES)} failed propert{'y' if len(FAILURES) == 1 else 'ies'}"
          + (":\n   - " + "\n   - ".join(FAILURES) if FAILURES else
             " - the policy keeps every hypothesis, and every conclusion holds"))
    sys.exit(1 if FAILURES else 0)


if __name__ == "__main__":
    main()

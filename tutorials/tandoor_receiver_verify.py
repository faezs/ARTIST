"""THE MIXED-BATCH TEST: one batch, both receivers.

Since 2026-09-08 the receiver is a design-box COLUMN, not an env mode: a single
run searches the Cassegrain (elbow at the pot inlet) beside the three-mirror
machine (no elbow, M3 thrown at the loaf).  That guarantee is only real if a
batch holding both gives every agent exactly what a batch of its own kind would
give it, and the failure mode is silent - a batch-wide `if` on a per-agent knob
returns plausible numbers for the wrong machine.  It has bitten this codebase
twice already (m4_flat, and `d["tri"] = float(e.tri)` in the bill).

Run:  PYTHONPATH=..:. puffer_tandoor/.venv/bin/python tandoor_receiver_verify.py

Checks, in order of how quietly each would have failed:
  [rows]   the mixed table equals the pure tables cell for cell
  [M3]     each agent's M3 is turned from its OWN ellipsoid, not the env's nominal one
  [parity] the Metal megakernel agrees with the eager reference core, on the mixture
  [power]  traced power, agent for agent, against a batch of that agent's own kind
"""
import contextlib
import io as _io
import sys

import numpy as np

sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
from tandoor_design_readout import env_kwargs           # noqa: E402
from tandoor_hashemi_env import TandoorHashemiEnv       # noqa: E402
from tandoor_rl_env import _sim                         # noqa: E402

#: the designer's elite kit (medians over its top designs, 2026-09-08) in
#: PHYSICAL units.  A uniform draw from the box is mostly machines that miss -
#: mean traced power a few watts - and a parity check on those is nearly
#: vacuous: the rays agree at zero because they never arrive.
ELITE = dict(deck_h=3.15, r_duct=0.87, d_strip=0.50, u_f2=3.0, r_m4=1.3,
             r_bore=0.7, w_slot=0.7, r_hole=0.5, strip_th_hi=100.0,
             strip_wk=1.3, rate_scale=1.2, ins_scale=0.4, cap_scale=1.0,
             lid_leak=0.10, bread_area=0.12, loaves_per_load=8.0,
             sand_depth=0.2, sand_k=1.5, demand_scale=1.0,
             # THE SITE (2026-09-10, site_rand): the gate is about the machine, so the elite
             # kit sits on the nominal pit with its roof square to the sun; the horizon draw
             # (site_hz) is a parapet + neighbours, harmless at the noon sun this traces.
             site_az=0.0, pot_r=1.0, pot_h=1.0)
UNIT = dict(roof_r=0.25, mount_post=1.0, section=1.0, post_rise=0.73,
            over_cap=0.8, zones=0.2, m4_facet=0.545, roof_light=0.0, grid=1.0, site_hz=0.5)


def elite_u(box):
    names = [k for k, _, _ in box]
    u = np.full(len(box), 0.5)
    for i, (k, lo, hi) in enumerate(box):
        if k in ELITE:
            u[i] = (ELITE[k] - lo) / (hi - lo)
        elif k in UNIT:
            u[i] = UNIT[k]
    return np.clip(u, 0.0, 1.0), names


def build(B, u, noon=True):
    with contextlib.redirect_stdout(_io.StringIO()):
        e = TandoorHashemiEnv(**env_kwargs(B, receiver="cass"))
        e.set_design_points(u)
        e.reset()
    if noon:
        # reset parks the mount at el_min 12 deg with the sun at 83: without
        # this every check below passes on a batch of zeros.
        e.day = 172; e.t_solar[:] = 12.0
        e.day_v[:] = 172.0; e.lat_v[:] = 30.2
        el, az, _ = _sim.solar_position(e.lat, e.day, float(e.t_solar[0]))
        e.el_m[:] = el; e.az_m[:] = np.degrees(az - e._ds_azs)      # each roof tracks ITS sun (site_az)
        e._e_el[:] = 0.0; e._e_az[:] = 0.0
    e._det_trace = True
    return e


def power(e):
    B = e.num_agents
    p = e._trace_power(np.full(B, e.p0), np.full(B, 7e-3),
                       np.zeros((B, 2)), np.ones(B))
    return p.sum(1).detach().cpu().numpy()


def main(B=16, kit="elite"):
    with contextlib.redirect_stdout(_io.StringIO()):
        e0 = TandoorHashemiEnv(**env_kwargs(2, receiver="cass"))
    box = tuple(e0.DESIGN_BOX) + tuple(e0.SYS_BOX)
    nd, DS = e0.N_DESIGN, dict(e0.DS)
    del e0
    u1, names = elite_u(box)
    i_recv = names.index("receiver")
    u = (np.tile(u1, (B, 1)) if kit == "elite"
         else np.random.default_rng(7).uniform(size=(B, nd)))
    cass, tri = np.full(B, 0.1), np.full(B, 0.9)
    # interleaved, so a stride bug cannot hide in a contiguous half
    mixed = np.where(np.arange(B) % 2 == 0, 0.1, 0.9)
    em = build(B, np.c_[u[:, :i_recv], mixed, u[:, i_recv + 1:]])
    ec = build(B, np.c_[u[:, :i_recv], cass, u[:, i_recv + 1:]])
    et = build(B, np.c_[u[:, :i_recv], tri, u[:, i_recv + 1:]])
    print(f"kit={kit}  B={B}  N_DESIGN={nd}  FCT_W={em.FCT_W}  "
          f"receiver = box column {i_recv}")

    f = em._fct.detach().cpu().numpy()
    fc = ec._fct.detach().cpu().numpy(); ft = et._fct.detach().cpu().numpy()
    pure = np.where((np.arange(B) % 2 == 0)[:, None], fc, ft)
    bad = np.abs(f - pure) > 1e-6
    cols = sorted(set(np.where(bad)[1].tolist()))
    print(f"[rows]   mixed vs pure: {int(bad.sum())} differing cells"
          + (f"  COLUMNS {cols}" if bad.any() else "  OK"))
    print(f"         cass row: recv {f[0, DS['recv']]:.0f} noz {f[0, DS['noz']]:.0f} "
          f"phw {f[0, DS['phw']]:.3f} F4 ({f[0, 18]:+.2f},{f[0, 19]:+.2f},{f[0, 20]:+.2f})")
    print(f"         tri  row: recv {f[1, DS['recv']]:.0f} noz {f[1, DS['noz']]:.0f} "
          f"phw {f[1, DS['phw']]:.3f} F4 ({f[1, 18]:+.2f},{f[1, 19]:+.2f},{f[1, 20]:+.2f})")

    if kit != "elite":     # the elite kit is one design, so its spread IS zero
        et._apply_m3_turn()
        oe = et._fct.detach().cpu().numpy()[:, 21:27]
        print(f"[M3]     spread of the turned figure across tri agents: "
              f"{np.ptp(oe, axis=0).max():.4f} m (0 = one nominal mirror for all)")

    # Metal vs the eager reference, per receiver.  NOT the gate: the Cassegrain
    # elbow carries a small pre-existing gap (the kernel hardcodes the mirror's
    # A0/MM/FN and takes its aim from the `aim` buffer, while _bin_pot reads
    # self._noz2 and recomputes the aim from _spot_view - four chances to drift).
    # Measured at HEAD and after the receiver refactor on the fixed cook design:
    # 8 mismatches, 0.019870102 W vs 0.019870162 W - identical to seven digits,
    # so it predates this work.  It is ~0.15% of total power and it is reported
    # here so a REGRESSION in it is visible, not so the test fails on it.
    par = {}
    for nm, e in (("mixed", em), ("cass ", ec), ("tri  ", et)):
        mism, mx = e.verify_megakernel()
        par[nm.strip()] = (mism, mx)
        note = "" if mism == 0 else "   (cass elbow: pre-existing, ~0.15% - see above)"
        print(f"[parity] {nm}: {mism} mismatches, max |diff| {mx:.2e} W{note}")
    # a MIXED batch must not be worse than a pure batch of the same receivers:
    # that difference would be the mixing, and that is this test's business.
    mix_excess = par["mixed"][1] - max(par["cass"][1], par["tri"][1])
    print(f"[parity] mixing costs {mix_excess:+.2e} W over the pure batches"
          + ("" if mix_excess < 1e-6 else "   <-- FAIL"))

    # THE MISS LEDGER must agree ray for ray too: it is the only thing that says
    # WHERE a lost ray went, so a twin that files it under the wrong part is worse
    # than one that loses it silently. Shares of each fate code, metal vs torch.
    for nm, e in (("mixed", em), ("cass ", ec), ("tri  ", et)):
        g_ = e._gen.get_state()                    # same draws for both twins (verify_megakernel does this too)
        power(e); fm = e._fate; xm = e._pex
        m0, e._metal = e._metal, None; e._gen.set_state(g_)
        power(e); ft = e._fate; xt = e._pex
        e._metal = m0
        if xm is not None and xt is not None:
            xm_, xt_ = xm.reshape(-1).cpu().numpy(), xt.reshape(-1).cpu().numpy()
            dx = float(np.abs(xm_ - xt_).max()); tot = float(max(xm_.sum(), 1e-9))
            print(f"[flux]   {nm}: exterior watts metal {xm_.sum():.1f} torch {xt_.sum():.1f}, max bin |diff| {dx:.3f} W"
                  + ("" if dx < 0.02 * max(xm_.max(), 1e-9) + 1e-3 else "   <-- FAIL"))
        if fm is None or ft is None:
            print(f"[ledger] {nm}: no ledger on this chain"); continue
        cm = fm.reshape(-1, 6)[:, 0].cpu().numpy().astype(int); ct = ft.reshape(-1, 6)[:, 0].cpu().numpy().astype(int)
        codes = sorted(set(cm.tolist()) | set(ct.tolist()))
        dmax = max(abs((cm == c).mean() - (ct == c).mean()) for c in codes)
        top = sorted(((c, (cm == c).mean()) for c in codes), key=lambda x: -x[1])[:4]
        print(f"[ledger] {nm}: max |metal - torch| share {100*dmax:.2f} pts"
              + ("" if dmax < 0.005 else "   <-- FAIL") + "   top: " + ", ".join(f"{c}:{100*s:.1f}%" for c, s in top))

    pm, pc, pt = power(em), power(ec), power(et)
    ref = np.where(np.arange(B) % 2 == 0, pc, pt)
    dmax = float(np.abs(pm - ref).max())
    print(f"[power]  cass {pc.mean():8.1f} W   tri {pt.mean():8.1f} W")
    # THE GATE: an agent in a mixed batch gets what a batch of its own kind gives it.
    print(f"[power]  mixed vs own-kind: max |diff| {dmax:.3e} W"
          + ("   OK" if dmax < 1e-3 else "   <-- FAIL"))


if __name__ == "__main__":
    main(B=int(sys.argv[1]) if len(sys.argv) > 1 else 16,
         kit=sys.argv[2] if len(sys.argv) > 2 else "elite")

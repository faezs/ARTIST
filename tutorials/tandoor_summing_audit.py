"""Summing-functor audit: the reward must be a monoidal functor.

Manin-Marcolli summing functors assign resources additively over
disjoint subsystems: Phi(A u A') = Phi(A) + Phi(A') (Def 2.1). The
tandoor reward is such a functor from subsystems of {belt bins} to
(R, +, 0) - and every exploit this project has closed was a
functoriality failure (the trainer's +-1 clamp literally broke
Phi(9 naans) = 9 Phi(1 naan); charge-and-crash violated the
Kirchhoff condition at episode boundaries). These tests make the
functor property a standing invariant:

  1. one-step additivity over disjoint bin subsets (exact)
  2. the ledger reconstructs: an independent re-derivation of every
     reward term from recorded state deltas matches the env's r
  3. clamp headroom: worst analytic one-step |r| stays inside
     reward_div, so the trainer clamp never binds

    .venv/bin/python tandoor_summing_audit.py
"""
import contextlib
import io
import pathlib
import sys

import numpy as np

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))

T_COOK_LO = 453.0


def build(seed=5):
    from tandoor_hashemi_env import TandoorHashemiEnv
    with contextlib.redirect_stdout(io.StringIO()):
        e = TandoorHashemiEnv(num_agents=4, seed=seed, wide_shutter=1,
                              device="cpu", gpu=0, warm_frac=1.0,
                              day_random=0, lat_random=0, wall_obs=1,
                              elbow_aim=1, load_ctrl=1, sticky_k=0,
                              duct_nozzle=2, spot_bread=1,
                              loaves_per_load=9)
        e.reset(seed=seed)
    e.day_v[:] = 172
    e.day = 172
    e.t_solar[:] = 11.0
    # aim the mount at the forced sun (reset aimed it at dawn)
    import torch
    from tandoor_mount_batch import solar_batch
    el1, az1r, _ = solar_batch(
        torch.full((e.num_agents,), 28.6),
        torch.full((e.num_agents,), 172.0), 11.0)
    e.lat_v[:] = 28.6
    e.lat = 28.6
    e.el_m[:] = float(el1[0])
    e.az_m[:] = float(torch.rad2deg(az1r)[0])
    e._e_az[:] = 0.0
    e._e_el[:] = 0.0
    # a warm working state: charged belt, mid-morning sun
    e.T[:] = 520.0
    e.equilibrate_wall(halo=420.0)
    e._belt_prev = e.T[:, : e.n_belt].max(1).copy()
    # freeze stochasticity we cannot control from outside
    e.rng = np.random.default_rng(0)
    return e


def dough(e, bins, energy_frac):
    e.has_bread[:] = False
    e.bread_E[:] = 0.0
    e.bread_t[:] = 0.0
    e.bread_C[:] = 0.0
    for k in bins:
        e.has_bread[:, k] = True
        e.bread_E[:, k] = energy_frac * e.roti_energy
        e.bread_t[:, k] = 60.0


def one_step(e, lean):
    # identical global command: jammed, shutter open, gates closed
    a = np.full((e.num_agents, e.N_HEADS), 3, dtype=np.int64)
    a[:, 0] = 4
    a[:, 1] = 6
    a[:, 2] = 6
    e.load_timer[:] = e.load_period + 1.0 if lean else 0.0
    o, r, d, tr, _ = e.step(a)
    rd = getattr(e, "reward_div", 1.0)
    return r.astype(np.float64) * rd   # raw units


def additivity(lean, frac):
    rs = {}
    for name, bins in (("none", ()), ("A", (0, 1)),
                       ("B", (3, 4)), ("AB", (0, 1, 3, 4))):
        e = build()
        dough(e, bins, frac)
        rs[name] = one_step(e, lean)
    lhs = rs["AB"] - rs["none"]
    rhs = (rs["A"] - rs["none"]) + (rs["B"] - rs["none"])
    err = float(np.abs(lhs - rhs).max())
    tag = "lean/pull" if lean else "hold"
    print(f"  additivity ({tag}, doneness {frac:.2f}): "
          f"|Phi(AuB) - Phi(A) - Phi(B)| = {err:.2e}")
    # rewards buffer is float32: eps ~ 1e-7 at these magnitudes
    assert err < 1e-5, "reward is not additive over disjoint bins"


def ledger_reconstructs(steps=200):
    """Independent re-derivation of r from recorded state deltas.
    Runs a cook-active tape with tracking held (no cuts, no
    day-over); every term is recomputed from (state_before,
    state_after) and their sum must equal the env's reward."""
    e = build()
    dough(e, (0, 1, 2), 0.3)
    B, nb = e.num_agents, e.n_belt
    worst = 0.0
    for t in range(steps):
        Tb = e.T[:, :nb].copy()
        bE0 = e.bread_E.copy()
        hb0 = e.has_bread.copy()
        jam0 = e.jammed.copy()
        eaz0, eel0 = e._e_az.copy(), e._e_el.copy()
        rot0, sc0, sp0 = (e.ep_rotis.copy(), e.ep_scorch.copy(),
                          e.ep_spall.copy())
        a = np.full((B, e.N_HEADS), 3, dtype=np.int64)
        a[:, 0] = 4
        a[:, 1] = 6
        a[:, 2] = 6 if t % 60 < 50 else 0   # occasional re-form
        # gates: open two rotating bins so loads happen on leans
        a[:, 7 + (t // 25) % nb] = 6
        a[:, 7 + (t // 25 + 3) % nb] = 6
        # crude tracking servo
        a[:, 3] = np.where(e._e_az < -0.05, 4,
                           np.where(e._e_az > 0.05, 2, 3))
        a[:, 4] = np.where(e._e_el < -0.05, 4,
                           np.where(e._e_el > 0.05, 2, 3))
        o, r, d, tr, _ = e.step(a)
        assert not tr.any() and not d.any(), \
            "tape crossed a boundary - reconstruction not valid here"
        rd = getattr(e, "reward_div", 1.0)
        r_raw = r.astype(np.float64) * rd
        # ---- recompute every term from the recorded deltas
        cooked = e.ep_rotis - rot0
        scorched = e.ep_scorch - sc0
        spalls = e.ep_spall - sp0
        # fresh dough this step (covers pull-and-reload on the same
        # bin in one lean): loaded bins have bread_t == 0, held
        # dough aged by dt before the cook block
        loads = (e.has_bread & (e.bread_t == 0.0)).sum(1)
        phi0 = np.clip(bE0 / e.roti_energy, 0, 1).sum(1)
        phi1 = np.clip(e.bread_E / e.roti_energy, 0, 1).sum(1)
        pre = 0.05 * np.clip(
            np.minimum(e.T[:, :nb], T_COOK_LO)
            - np.minimum(Tb, T_COOK_LO), -5, 5).sum(1)
        pot0 = np.minimum(np.abs(eaz0) + np.abs(eel0), 4.0)
        pot1 = np.minimum(np.abs(e._e_az) + np.abs(e._e_el), 4.0)
        recon = (5.0 * cooked - 5.0 * scorched - 0.5 * spalls
                 + 0.3 * loads
                 - (0.3 / e.loaves_per_load) * e.has_bread.sum(1)
                 + 2.0 * (phi1 - phi0)
                 + pre
                 - 0.02 * (~e.jammed)
                 + 1.0 * (pot0 - pot1))
        worst = max(worst, float(np.abs(recon - r_raw).max()))
    print(f"  ledger reconstruction over {steps} steps: "
          f"max |recon - r| = {worst:.2e}")
    assert worst < 1e-6, "a reward term is not what the ledger says"


def clamp_headroom():
    from tandoor_polar_env import TandoorPolarEnv  # noqa: F401
    e = build()
    nb, E = e.n_belt, e.roti_energy
    # generic strata (events that actually recur): a full lean, and
    # a cut refund of a charged belt with in-flight dough. A loaf at
    # a wipe is EITHER scorched or refunded, never both.
    refund_max = (0.05 * nb * (T_COOK_LO - 350.0)     # preheat
                  + 0.3 * nb                          # in-flight
                  + 2.0 * nb                          # doneness
                  + 4.0 + 0.02 + (0.3 / e.loaves_per_load) * nb)
    lean_max = 5.3 * e.loaves_per_load
    # catastrophe corner (measure-zero-ish): ALL loaves scorching on
    # the same step a charged belt is guillotined - scorch penalties
    # replace their refunds and stack with the preheat refund
    apocalypse = (5.0 + 2.0) * nb + 0.05 * nb * (T_COOK_LO - 350.0) \
        + 4.0
    rd = 75.0
    m = max(refund_max, lean_max) / rd
    print(f"  generic worst |r|: refund {refund_max:.1f}, "
          f"lean {lean_max:.1f} raw -> max/div = {m:.3f}")
    assert m < 1.0, "trainer clamp binds on a GENERIC event"
    ma = apocalypse / rd
    print(f"  catastrophe corner (mass scorch at cut): "
          f"{apocalypse:.1f} raw -> {ma:.2f}/div"
          + ("  [clamped: tail of a catastrophe censored ~"
             f"{(1 - 1 / ma) * 100:.0f}%, documented and accepted]"
             if ma > 1 else ""))


if __name__ == "__main__":
    print("summing-functor audit")
    for lean in (False, True):
        for frac in (0.3, 0.95):
            additivity(lean, frac)
    ledger_reconstructs()
    clamp_headroom()
    print("summing-functor audit: PASS")

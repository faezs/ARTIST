"""THE FILM FIGURE AND THE TRACKER AS ONE DESIGN DECISION (user, 2026-09-17: "make the film figure
and the tracker one design decision then").

ReceiverCapture.lean (`TandoorCapture`, the Decision section) proves the frame: the receiver's
capture margin is ONE resource, spent along the budget line `L·e + m·σ = M` on pointing tolerance
`e` and blur tolerance `σ`; the line is the Pareto frontier of the affordable pairs
(`not_dominated_of_onLine`, `dominated_of_lt_line`), a cheapest allocation on it exists
(`exists_decision`), and stopping short of the line is never cheaper (`line_no_dearer`).  So the
design variable is the ALLOCATION - one number - and the tracker and the figure are its two
readings.

This tool makes the decision on the MEASURED surface rather than the paraxial line: the fraction
of the aimed-inside power a receiver keeps at each (pointing error, blur), traced with the same
draws (tandoor_lean_props._capture_grid), averaged over three suns at Quetta.  Against it, a menu
of trackers (what pointing they achieve, what they cost) and a menu of film figures (what static
blur they leave, what they cost).  Every PAIR is one candidate; the frontier over (power kept,
-capital) is the decision set, the proved program checks it, and the cheapest pair reaching a
target is the decision.

The tracker menu starts from a MEASUREMENT: the trained cook policy points to 1.1 deg rms at the
built motor class and 0.57 deg at twice it (tandoor_policy_props rollouts) - the control, not the
motor, is the pointing.  The upgrade rungs and the film rungs are priced as the bill prices
everything: my estimates, to be corrected line by line (tandoor_system_cost.PRICES).

    PYTHONPATH=..:.:puffer_tandoor puffer_tandoor/.venv/bin/python tandoor_figure_tracker.py [--receiver cass|tri|both]
        [--target 0.8] [--lean-check] [--out data/tandoor/figure_tracker.json]
"""
import argparse, json, os, sys
import numpy as np

sys.path.insert(0, "/Users/faezs/ARTIST"); sys.path.insert(0, "/Users/faezs/ARTIST/tutorials")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")

from tandoor_system_cost import PRICES
from tandoor_frontier import Ledger

SUNS = ((30.2, 172, 12.0, "solstice noon"), (30.2, 355, 12.0, "midwinter noon"), (30.2, 80, 9.5, "equinox 9:30"))
PE = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.75, 1.0, 1.25, 1.5]            # pointing error [deg]
SIG = [1e-7] + [5e-4 * 1.25 ** k for k in range(18)]                  # blur [rad], 0.5 .. 22 mrad

#: THE TRACKER MENU: (name, pointing rms [deg] or None, cost over the built kit [PKR], cook motor class or None)
#: the cook rows are MEASURED: the trained policy's pointing histogram per machine (data/tandoor/
#: cook_pointing.json, tandoor_policy_props rollouts on days 173 and 355), and the surface is
#: integrated over it - the policy's error is a distribution, not a number. The rest are
#: engineering rungs, priced as estimates.
TRACKERS = [
    ("the trained cook, motor class 1  (measured histogram)", None, 0.0, (0.75, 1.25)),
    ("the trained cook, motor class 2  (measured histogram)", None, PRICES["motors"] * (2.0 ** 1.5 - 1.0), (1.5, 2.5)),
    ("a closed loop on the encoders   (0.30 deg, estimate)", 0.30, 20_000.0, None),
    ("a sun sensor in the loop        (0.15 deg, estimate)", 0.15, 35_000.0, None),
    ("a precision tracker             (0.05 deg, estimate)", 0.05, 60_000.0, None),
]
COOK = "/Users/faezs/ARTIST/tutorials/data/tandoor/cook_pointing.json"


def cook_kept(tab, sigma, receiver, band):
    """the surface integrated over the trained cook's measured pointing histogram, for the machines of
    this receiver in this motor-class band: (kept fraction, measured rms, machine-days)"""
    J = json.load(open(COOK)); edges = np.asarray(J["edges"]); mid = 0.5 * (edges[1:] + edges[:-1])
    tri = receiver == "tri"
    ag = [a for a in J["agents"].values() if a["tri"] == tri and band[0] <= a["rate_scale"] < band[1]]
    if not ag: return float("nan"), float("nan"), 0
    h = np.sum([np.asarray(a["hist"], float) for a in ag], 0); h = h / h.sum()
    k = float(sum(hi * kept(tab, float(m), sigma) for hi, m in zip(h, mid)))
    return k, float(np.sqrt(np.mean([a["rms"] ** 2 for a in ag]))), len(ag)

#: THE FIGURE MENU: (name, film slope [rad], grain print [rad], cost over the built film [PKR]);
#: the static blur is sqrt((2 slope)^2 + (2 print)^2) - the simulator's sig_static
FIGURES = [
    ("the built film   (2 mrad slope, 0.8 print)", 2.0e-3, 0.8e-3, 0.0),
    ("rim-fed film     (1 mrad slope, 0.8 print)", 1.0e-3, 0.8e-3, PRICES["rim_m"] * 2 * np.pi * 2.1),
    ("rim-fed, fine print (1 mrad, 0.4 print)", 1.0e-3, 0.4e-3, PRICES["rim_m"] * 2 * np.pi * 2.1 + 15_000.0),
    ("precision film   (0.5 mrad slope, 0.3 print)", 0.5e-3, 0.3e-3, 45_000.0),
]

def sig_static(slope, prnt):
    return float(np.sqrt((2 * slope) ** 2 + (2 * prnt) ** 2))

def sig_wind(V, gain=1.0):
    """the simulator's blur from the wind (V^1.2 law), in quadrature with the static figure"""
    q = 0.6 * V * V
    return 0.7 * gain * 0.88e-3 * (max(q, 1e-9) / 15.0) ** 0.6


def surface(receiver, seed=0):
    """kept fraction of the aimed-inside power, (len(PE), len(SIG)), averaged over the suns; and the worst sun"""
    import tandoor_lean_props as L
    tabs = []
    for (lat, doy, hour, nm) in SUNS:
        e = L._traced(8, receiver, seed); el = L._park(e, lat, doy, hour)
        el0 = np.asarray(e.el_m, float).copy()
        caps, w = L._capture_grid(e, el0, [(pe, s) for pe in PE for s in SIG])
        S00 = caps[(0.0, 1e-7)]; P00 = float((w * S00).sum())
        tabs.append(np.array([[float((w * (S00 & caps[(pe, s)])).sum()) / P00 for s in SIG] for pe in PE]))
    T = np.array(tabs)
    return T.mean(0), T.min(0)


def kept(tab, pe, sig):
    """bilinear read of the surface at a pointing error and a blur (log in the blur)"""
    pe = float(np.clip(pe, PE[0], PE[-1])); ls = float(np.clip(np.log(max(sig, SIG[1])), np.log(SIG[1]), np.log(SIG[-1])))
    lsig = np.log(SIG[1:]); row = np.interp(ls, lsig, np.arange(len(lsig)))
    i = int(np.clip(np.searchsorted(PE, pe) - 1, 0, len(PE) - 2)); f = (pe - PE[i]) / (PE[i + 1] - PE[i])
    j = int(np.clip(np.floor(row), 0, len(lsig) - 2)); g = row - j
    T = tab[:, 1:]
    return float((1 - f) * ((1 - g) * T[i, j] + g * T[i, j + 1]) + f * ((1 - g) * T[i + 1, j] + g * T[i + 1, j + 1]))


def decide(receiver, target, lean_check, gust_V):
    mean, worst = surface(receiver)
    print(f"\n{receiver.upper()}: the joint surface, kept fraction of the aimed-inside power (mean of {len(SUNS)} suns at Quetta)")
    print("   blur [mrad]:   " + " ".join(f"{1e3 * s:5.1f}" for s in SIG[1::2]))
    for i, pe in enumerate(PE):
        print(f"   {pe:4.2f} deg     " + " ".join(f"{100 * mean[i, j]:5.0f}" for j in range(1, len(SIG), 2)))
    led = Ledger(["kept_pct", "neg_PKR"])
    rows = []
    for (tn, trms, tcost, band) in TRACKERS:
        for (fn, slope, prnt, fcost) in FIGURES:
            s0 = sig_static(slope, prnt); sg = float(np.sqrt(s0 ** 2 + sig_wind(gust_V) ** 2))
            if band is not None:                                    # the cook: integrate over its histogram
                k_calm, trms, nmd = cook_kept(mean, s0, receiver, band)
                k_gust = cook_kept(mean, sg, receiver, band)[0]; k_worst = cook_kept(worst, s0, receiver, band)[0]
                if nmd == 0: continue
                tn = tn.replace("measured histogram", f"{nmd} machine-days, {trms:.2f} deg rms")
            else:
                k_calm, k_gust, k_worst = kept(mean, trms, s0), kept(mean, trms, sg), kept(worst, trms, s0)
            name = f"{tn.split('(')[0].strip()} + {fn.split('(')[0].strip()}"
            rows.append(dict(name=name, tracker=tn, figure=fn, rms_deg=trms, sigma_mrad=1e3 * s0, cost=tcost + fcost,
                             kept=k_calm, kept_gust=k_gust, kept_worst=k_worst))
            led.add(name, [100 * k_calm, -(tcost + fcost)], meta=dict(rms_deg=trms, sigma_mrad=1e3 * s0))
    print(f"\n   every (tracker, figure) pair is one candidate; kept = calm / at a {gust_V:.0f} m/s gust / worst sun")
    for r in sorted(rows, key=lambda r: -r["kept"]):
        print(f"   {100 * r['kept']:5.1f} % / {100 * r['kept_gust']:5.1f} / {100 * r['kept_worst']:5.1f}   +{r['cost'] / 1e3:5.0f}k PKR   "
              f"{r['rms_deg']:.2f} deg, {r['sigma_mrad']:.1f} mrad   {r['name']}")
    front = led.report([0.0, -1e9], keys=("rms_deg", "sigma_mrad"), lean_check=lean_check, top=20)
    # THE DECISION: the cheapest pair reaching the target
    ok = [r for r in rows if r["kept"] >= target]
    if ok:
        best = min(ok, key=lambda r: r["cost"])
        print(f"\n   THE DECISION at target {100 * target:.0f} %: {best['name']} - +{best['cost'] / 1e3:.0f}k PKR, "
              f"{100 * best['kept']:.1f} % kept ({100 * best['kept_worst']:.1f} % on the worst sun)")
    else:
        print(f"\n   no pair on the menu reaches {100 * target:.0f} % - the best is {100 * max(r['kept'] for r in rows):.1f} %")
    # THE MARGINAL READING at the built machine: which axis buys more power per rupee from here
    base = rows[0]
    t_next = [r for r in rows if r["figure"] == FIGURES[0][0] and r["cost"] > 0]
    f_next = [r for r in rows if r["tracker"] == base["tracker"] and r["cost"] > 0]
    if t_next and f_next:
        t1 = min(t_next, key=lambda r: r["cost"]); f1 = min(f_next, key=lambda r: r["cost"])
        print(f"   from the built machine ({100 * base['kept']:.1f} % kept): the first tracker rung buys "
              f"{100 * (t1['kept'] - base['kept']):+.1f} points for {t1['cost'] / 1e3:.0f}k, the first figure rung "
              f"{100 * (f1['kept'] - base['kept']):+.1f} points for {f1['cost'] / 1e3:.0f}k - "
              f"{'the tracker' if (t1['kept'] - base['kept']) / max(t1['cost'], 1) > (f1['kept'] - base['kept']) / max(f1['cost'], 1) else 'the figure'} is the binding budget")
    return dict(receiver=receiver, PE=PE, SIG=SIG, mean=mean.tolist(), worst=worst.tolist(), rows=rows, frontier=[r[0] for r in front])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--receiver", default="both"); ap.add_argument("--target", type=float, default=0.8)
    ap.add_argument("--gust", type=float, default=12.0, help="the gust the figure must also carry [m/s]")
    ap.add_argument("--lean-check", action="store_true")
    ap.add_argument("--out", default="/Users/faezs/ARTIST/tutorials/data/tandoor/figure_tracker.json")
    a = ap.parse_args()
    print("THE FILM FIGURE AND THE TRACKER AS ONE DECISION")
    out = {}
    for rec in (("cass", "tri") if a.receiver == "both" else (a.receiver,)):
        out[rec] = decide(rec, a.target, a.lean_check, a.gust)
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    json.dump(dict(trackers=TRACKERS, figures=FIGURES, results=out), open(a.out, "w"), indent=1)
    print(f"\n   written {a.out}")


if __name__ == "__main__":
    main()

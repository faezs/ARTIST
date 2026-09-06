"""Whole-system co-design with the controller in the loop: price every
agent's machine (dish, tower, actuators, pit, receiver) and value its
day's rotis from a design readout, so the design that wins is the one
that bakes the most bread per rupee - not the one with the most beam.

    python tandoor_system_cost.py readout.json [--years 5] [--roti-pkr 8]

The readout (tandoor_design_readout.py) carries each agent's unit-box
design U and its rotis per day for the pinned days. Value per year =
rotis/day x (area/0.12) x price x sun days: a bigger roti is more bread.
Capital (PKR, Quetta 2026, placeholders in PRICES):
  dish     silvered membrane + ring, per m2 of aperture (pi a^2 s^2)
  tower    per metre of deck height
  motors   actuator class: base x rate_scale^1.5 (torque and speed)
  shell    insulation: 1/ins_scale thicker shell around the pit
  mass     refractory thermal mass: per unit of cap_scale
  lid      a tighter lid costs: base / lid_leak
  strip, m4, bore, inlet as tandoor_design_cost.py (receiver)"""
import argparse, json, sys
import numpy as np
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials"); sys.path.insert(0, "/Users/faezs/ARTIST")
sys.path.insert(0, "/Users/faezs/ARTIST/tutorials/puffer_tandoor")

PRICES = dict(dish_m2=6000.0, tower_m=40000.0, motors=30000.0, shell=60000.0, mass=40000.0, lid=6000.0,
              strip_m2=25000.0, m4_m2=15000.0, bore_m2=4000.0, fixed=200000.0,
              rail_m=8000.0, post_mount=150000.0)
A_MEM0 = 2.10           # nominal membrane radius [m] (hashemi a_mem)
G_ORBIT0 = 4.0          # nominal fold orbit [m]; ring rail radius = G_ORBIT0 x s + 0.6
L_BORE = 9.7            # bore length at deck 4.0 [m]; grows with the deck


def capital(d):
    """d: dict of design values (both boxes). Returns the itemised bill."""
    s = d.get("dish_scale", 1.0); deck = d.get("deck_h", 4.0)
    A_dish = np.pi * (A_MEM0 * s) ** 2
    # the strip's area from its distance and taper (the conic's meridian
    # ~ 1.4 d over the window; width ~ strip_wk x 1.4 d)
    th = np.radians(d.get("strip_th_hi", 100.0)); r_mean = 1.4 * d.get("d_strip", 0.6)
    A_strip = r_mean * th * d.get("strip_wk", 1.1) * r_mean
    A_m4 = np.pi * d.get("r_m4", 1.3) ** 2
    A_bore = 2 * np.pi * d.get("r_bore", 0.7) * (L_BORE + (deck - 4.0))
    post = d.get("mount_post", 0.0) >= 0.5
    mount = PRICES["post_mount"] if post else PRICES["rail_m"] * 2 * np.pi * (G_ORBIT0 * s + 0.6)
    items = dict(dish=PRICES["dish_m2"] * A_dish, tower=PRICES["tower_m"] * deck, mount=mount,
                 motors=PRICES["motors"] * d.get("rate_scale", 1.0) ** 1.5,
                 shell=PRICES["shell"] / max(d.get("ins_scale", 1.0), 0.2),
                 mass=PRICES["mass"] * d.get("cap_scale", 1.0),
                 lid=PRICES["lid"] * 0.18 / max(d.get("lid_leak", 0.18), 0.02),
                 strip=PRICES["strip_m2"] * A_strip, m4=PRICES["m4_m2"] * A_m4,
                 bore=PRICES["bore_m2"] * A_bore, fixed=PRICES["fixed"])
    items["total"] = sum(items.values())
    return items


def value_per_year(rotis_per_day, bread_area, roti_pkr, days):
    return rotis_per_day * (bread_area / 0.12) * roti_pkr * days


if __name__ == "__main__":
    ap = argparse.ArgumentParser(); ap.add_argument("readout"); ap.add_argument("--years", type=float, default=5.0)
    ap.add_argument("--roti-pkr", type=float, default=8.0); ap.add_argument("--days", type=float, default=300.0)
    ap.add_argument("--top", type=int, default=8)
    args = ap.parse_args()
    R = json.load(open(args.readout)); names = R["names"]; U = np.array(R["U"])
    from tandoor_hashemi_env import TandoorHashemiEnv as E
    box = {k: (lo, hi) for k, lo, hi in tuple(E.DESIGN_BOX) + tuple(E.SYS_BOX)}
    D = [{n: box[n][0] + U[b, i] * (box[n][1] - box[n][0]) for i, n in enumerate(names)} for b in range(U.shape[0])]
    for k, v in R.get("derived", {}).items():          # roof_r in metres, the derived dish_scale
        for b in range(U.shape[0]): D[b][k] = float(v[b])
    days = sorted(R["days"].keys(), key=int)
    rot = np.mean([np.array(R["days"][d]["rotis"]) for d in days], 0)     # mean over the pinned days
    cap = np.array([capital(d)["total"] for d in D])
    area = np.array([d.get("bread_area", 0.12) for d in D])
    val = value_per_year(rot, area, args.roti_pkr, args.days) * args.years - cap
    order = np.argsort(-val)
    print(f"{U.shape[0]} designs, {len(days)} pinned days ({', '.join(days)}), {args.years:.0f} years at {args.roti_pkr} PKR/roti: "
          f"value mean {val.mean()/1e3:.0f}k PKR, best {val[order[0]]/1e3:.0f}k, worst {val[order[-1]]/1e3:.0f}k; capital {cap.min()/1e3:.0f}k-{cap.max()/1e3:.0f}k")
    print(f"\ntop {args.top} by value (rotis/day = mean over the pinned days, cold pit):")
    for b in order[:args.top]:
        d = D[b]; c = capital(d)
        print(f"  {val[b]/1e3:7.0f}k  rotis {rot[b]:5.0f}  capital {c['total']/1e3:5.0f}k  " + ", ".join(f"{k}={d[k]:.2f}" for k in ("roof_r", "dish_scale", "mount_post", "deck_h", "rate_scale", "ins_scale", "cap_scale", "lid_leak", "bread_area", "loaves_per_load", "d_strip", "r_m4", "r_bore", "w_slot")))
    # standardized regression of value on the box: what to buy
    X = np.c_[np.ones(len(val)), U]; beta = np.linalg.lstsq(X, val, rcond=None)[0][1:]
    r2 = 1 - ((val - X @ np.linalg.lstsq(X, val, rcond=None)[0]) ** 2).sum() / ((val - val.mean()) ** 2).sum()
    print(f"\nvalue slope per whole-box sweep (R2 {r2:.2f}):")
    for i, n in enumerate(names):
        print(f"  {n:16s} {beta[i]/1e3:+8.0f}k PKR")

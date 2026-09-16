"""Payback of the retrofit kit, in the shop's terms: the fuel the sun displaces, and what that is worth.

Every input is a flag with a sourced or stated default; the thermal need comes from the simulator's
own numbers (the pit's steady loss at the built shell, 130 kJ per roti). Nothing here is measured at
a shop yet - it is the calculator the first shop's gas bill will calibrate.

  python tandoor_payback.py                       # the built machine, base case
  python tandoor_payback.py --kit 400000 --rotis 480 --gas 1900

Sources (September 2026): OGRA LPG Rs 258.65/kg (oilprices.pk, 5 Sep 2026); Sui gas commercial
Rs 3,900/MMBTU, tandoors in a separate subsidised category whose rate the notification does not
list - non-protected domestic slabs run Rs 500-4,200/MMBTU (suigasbills.pk); roti Rs 30-40 in Quetta
(Daily Independent, Apr 2026). Tandoor fuel use per day is NOT published; it is derived below.
"""
import argparse
import numpy as np

#: the calculator's inputs, one place; the CLI and the design tools read the same dict
DEFAULTS = dict(kit=584_000.0, rotis=600.0, roti_kj=130.0, loss_w=821.0, fire_hours=13.0, burner_eff=0.35,
                solar_share=0.70, lpg=258.65, lpg_mj=46.1, gas=3_900.0, days=300.0, margin=10.0, maint=0.03)


def fuel_bill(fuel="lpg", **kw):
    """PKR/day the shop burns today, and the MJ it is: pit loss x firing hours + demand x roti_kj, over the burner."""
    p = {**DEFAULTS, **kw}
    need_mj = (p["loss_w"] * p["fire_hours"] * 3600.0 + p["rotis"] * p["roti_kj"] * 1000.0) / 1e6 / p["burner_eff"]
    cost = need_mj / p["lpg_mj"] * p["lpg"] if fuel == "lpg" else need_mj / 1055.06 * p["gas"]
    return cost, need_mj


def savings_per_day(rotis_solar, fuel="lpg", **kw):
    """PKR/day the sun is worth for a machine baking rotis_solar/day against a demand of p['rotis']:
    it displaces solar_share of the fuel bill in proportion to the demand it covers, and any rotis
    beyond the demand earn the margin. Vectorised over rotis_solar."""
    p = {**DEFAULTS, **kw}
    bill, _ = fuel_bill(fuel, **p)
    r = np.asarray(rotis_solar, dtype=np.float64)
    share = np.clip(r / max(p["rotis"], 1.0), 0.0, 1.0) * p["solar_share"]
    return share * bill + np.maximum(r - p["rotis"], 0.0) * p["margin"]


def payback_months(capex, rotis_solar, fuel="lpg", **kw):
    """Months to earn the kit back: capex / (yearly savings - upkeep). inf where the sun earns nothing."""
    p = {**DEFAULTS, **kw}
    cap = np.asarray(capex, dtype=np.float64)
    yearly = savings_per_day(rotis_solar, fuel, **p) * p["days"] - p["maint"] * cap
    with np.errstate(divide="ignore", invalid="ignore"):
        return np.where(yearly > 0, 12.0 * cap / np.maximum(yearly, 1e-9), np.inf)


def net_value(capex, rotis_solar, years, fuel="lpg", **kw):
    """PKR net over a horizon on the FUEL basis: savings x days x years - upkeep - the kit.
    (MCTS's --value priced every solar roti at the roti's sale price, which a shop already selling
    those rotis on gas does not earn twice; the sun's income is the gas it does not burn.)"""
    p = {**DEFAULTS, **kw}
    cap = np.asarray(capex, dtype=np.float64)
    return (savings_per_day(rotis_solar, fuel, **p) * p["days"] - p["maint"] * cap) * years - cap


if __name__ == "__main__":

    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kit", type=float, default=DEFAULTS["kit"], help="kit price PKR (tandoor_bom.py nominal kit; the researched floor is ~400k)")
    ap.add_argument("--rotis", type=float, default=DEFAULTS["rotis"], help="rotis baked per day (the shop's demand: ~400 at lunch + breakfast/dinner, hashemi_design.ini demand_day)")
    ap.add_argument("--roti-kj", type=float, default=130.0, help="energy per roti [kJ] (roti_kj in hashemi.ini)")
    ap.add_argument("--loss-w", type=float, default=821.0, help="pit steady loss to the soil at baking temperature [W] (sim: 821 W at the legacy shell factor 0.28, 928 W for 10 cm glass wool, 1415 W bare)")
    ap.add_argument("--fire-hours", type=float, default=13.0, help="hours per day the pit is held at temperature by fuel today")
    ap.add_argument("--burner-eff", type=float, default=0.35, help="fraction of the fuel's heat that reaches the wall/bread in an open gas tandoor (stated assumption)")
    ap.add_argument("--solar-share", type=float, default=0.70, help="fraction of the day's fuel the sun displaces (sun hours + carried heat; the evening still burns gas)")
    ap.add_argument("--lpg", type=float, default=258.65, help="LPG PKR/kg (OGRA Sep 2026)")
    ap.add_argument("--lpg-mj", type=float, default=46.1, help="LPG MJ/kg")
    ap.add_argument("--gas", type=float, default=3_900.0, help="Sui gas PKR/MMBTU (commercial 3,900; the tandoor category is subsidised - pass what the bill says)")
    ap.add_argument("--days", type=float, default=300.0, help="operating days per year")
    ap.add_argument("--extra-rotis", type=float, default=0.0, help="rotis/day the machine adds beyond today's demand (0 = fuel savings only)")
    ap.add_argument("--margin", type=float, default=10.0, help="margin per extra roti PKR (Rs 30-40 sale price)")
    ap.add_argument("--maint", type=float, default=0.03, help="yearly upkeep as a fraction of the kit (film, mirrors, motors)")
    a = ap.parse_args()

    need_mj = (a.loss_w * a.fire_hours * 3600.0 + a.rotis * a.roti_kj * 1000.0) / 1e6 / a.burner_eff     # fuel heat per day
    lpg_kg = need_mj / a.lpg_mj
    mmbtu = need_mj / 1055.06
    print(f"fuel heat the shop burns today: {need_mj:.0f} MJ/day  = {lpg_kg:.1f} kg LPG  = {mmbtu:.2f} MMBTU   "
          f"(pit loss {a.loss_w:.0f} W x {a.fire_hours:.0f} h + {a.rotis:.0f} rotis x {a.roti_kj:.0f} kJ, burner {100*a.burner_eff:.0f}%)")
    extra = a.extra_rotis * a.margin
    for fuel, cost_day in (("LPG (loadshedding / no Sui connection)", lpg_kg * a.lpg), (f"Sui gas at Rs {a.gas:,.0f}/MMBTU", mmbtu * a.gas)):
        saved = a.solar_share * cost_day + extra
        yearly = saved * a.days - a.maint * a.kit
        pb = a.kit / yearly if yearly > 0 else float("inf")
        print(f"  {fuel:40s} fuel bill {cost_day:7,.0f} PKR/day -> sun saves {a.solar_share*cost_day:6,.0f}/day"
              + (f" + {extra:,.0f} margin" if extra else "") + f"  net {yearly:10,.0f} PKR/yr  payback {pb*12:5.0f} months on a {a.kit:,.0f} kit")
    print("the sensitivities that matter: --gas (the tandoor tariff), --solar-share, --burner-eff, and --loss-w (the shell); none is measured yet.")

"""Every material consideration of the retrofit kit, itemised.

The kit puts a solar collector on an existing firebrick tandoor: the pumped
membrane primary and its plenum, Hashemi's mount on a post, the two motors
and their control, the Cassegrain receiver (strip, bore, M4) into the pit's
native inlet, and the pit's own upgrades (trench insulation, sand bed, lid).
Quantities follow the design (the same formulas as tandoor_system_cost, plus
the parts that model lumped into 'mount', 'motors' and 'fixed'); the unit
prices are the Quetta placeholders to be replaced by researched ones.

    python tandoor_bom.py            -> the nominal circle and the 4 x 6 section kit, itemised
    bom(design) -> list of dict(item, spec, unit, qty, unit_pkr, pkr, group)
"""
import json, numpy as np

A_MEM0, G_ORBIT0, L_BORE0 = 2.10, 4.0, 9.7
R_POT, D_PIT, PIT_WALL_M2 = 0.42, 1.0, 21.0

# unit prices [PKR], the placeholders of tandoor_system_cost split to parts
UNIT = dict(
    film_m2=400.0,            # aluminised (silvered) PET film, 50 um, imported, per m2 laid (waste included by the gore factor)
    back_sheet_m2=250.0,      # plenum back: PVC-coated tarpaulin / plain PET, per m2
    rim_tube_m=700.0,         # rolled MS tube 40 mm for the rim (both rims), per metre incl. rolling
    zone_wall_m=120.0,        # plenum zone partitions (foam strip + tape), per metre
    pump_unit=6000.0,         # small blower / aquarium-class air pump with speed control, per zone
    press_sensor=1500.0,      # differential pressure sensor per zone
    valve=800.0,              # bleed valve per zone
    tubing_m=60.0,            # pneumatic tubing
    post_pipe_m=2000.0,       # MS pipe 100 mm (4") mast with base plate, per metre erected
    arm_pipe_m=1500.0,        # MS pipe 60 mm horizontal arm carrying F, per metre
    guy_set=4000.0,           # guy wires, turnbuckles, roof anchors (set of 3)
    mast_head=8000.0,         # trunnion / azimuth bearing at the mast head (post mount)
    beam_pipe_m=900.0,        # MS pipe 50 mm rotating beam, per metre
    aframe_pipe_m=600.0,      # MS tube 25 mm for the two A-frames, per metre
    arc_pipe_m=900.0,         # rolled MS tube 25 mm arc rail (two tubes), per metre incl. rolling
    bearing=1200.0,           # pillow-block / strap bearing, each
    counterweight=2000.0,     # cast weight
    motor_geared=6000.0,      # geared DC motor 24 V ~50 W with worm reduction, each (x rate^1.5)
    driver=2000.0,            # H-bridge driver per motor
    encoder=2500.0,           # 12-bit magnetic encoder per axis
    limit_sw=300.0,           # limit switch
    controller=6000.0,        # ESP32 / Arduino-class controller with RTC
    sun_sensor=3000.0,        # 4-quadrant sun sensor
    psu_solar=15000.0,        # 100 W PV panel + 12 V battery + charge controller (the site has unreliable grid)
    wiring_set=3000.0,        # cable, conduit, connectors
    enclosure=2500.0,         # IP65 box
    strip_m2=3000.0,          # polished (mirror) aluminium sheet on a curved frame, per m2 (the strip)
    m4_m2=3000.0,             # the same, the ellipsoid M4
    strip_bearing=2000.0,     # the strip's bearing on the F-F2 axis + coupling to the azimuth
    bore_m2=800.0,            # galvanised sheet duct per m2 of bore wall, fabricated and hung
    roof_pen=5000.0,          # roof penetration: collar, flashing, waterproofing
    flap_set=3000.0,          # mirrored flaps closing the slot + hinge/actuator
    elbow_mirror=4000.0,      # the concave elbow (nozzle) mirror + its 2-DOF servo mount
    shutter=2500.0,           # the duct shutter / damper and its servo
    inlet_work=3000.0,        # widening the native inlet, refractory mortar
    trench_dig=5000.0,        # a narrow trench round the pit (a day's labour)
    trench_fill_unit=10000.0, # perlite / rice-husk ash fill per unit of (1/ins - 1)
    sand_m3=3000.0,           # washed sand per m3
    sand_box=2000.0,          # a lining box / dig-out of the pit floor
    fins_m2_per_k=400.0,      # rebar fins per m2 of bed per W/mK above plain sand
    lid=500.0,                # steel lid (x 0.18 / lid_leak)
    labour_day=2500.0,        # skilled labour (welder / mason / electrician) per day
    fabrication_days=6.0,     # welding and assembly of mount and frames [days]
    install_days=4.0,         # erection, alignment, commissioning [days]
    transport=5000.0,
)

PK_PATH = "/Users/faezs/ARTIST/tutorials/data/tandoor/prices_pk.json"
Z_M4 = 0.14                # M4 sits at the duct level, just above the pot floor: the duct runs from the roof deck down to it
ROOF_PEN_D0 = 1.4          # the researched roof-penetration job is for a 1.4 m opening


def load_prices(path=PK_PATH, which="typical"):
    """the researched Pakistani unit prices (2025-26, Quetta/Karachi/Lahore, with sources) mapped onto UNIT's keys;
    which: 'low' | 'typical' | 'high'. Returns (unit dict, table) - the placeholders where an item was not researched."""
    import json, os
    U = dict(UNIT)
    if not os.path.exists(path):
        return U, {}
    T = json.load(open(path)); g = lambda k: float(T[k][which]) if k in T else None
    m = {"film_m2": "reflective film", "back_sheet_m2": "plenum back sheet", "rim_tube_m": "rim tube", "zone_wall_m": "zone partitions", "pump_unit": "zone pumps",
         "press_sensor": "pressure sensors", "valve": "bleed valves", "tubing_m": "pneumatic tubing", "post_pipe_m": "post / mast", "arm_pipe_m": "arm carrying F",
         "guy_set": "guys and anchors", "mast_head": "mast head bearing", "beam_pipe_m": "rotating beam", "aframe_pipe_m": "A-frames", "arc_pipe_m": "arc rail",
         "bearing": "bearings", "counterweight": "counterweight", "motor_geared": "geared DC motors", "driver": "motor drivers", "encoder": "encoders", "limit_sw": "limit switches",
         "controller": "controller", "sun_sensor": "sun sensor", "psu_solar": "power", "wiring_set": "wiring", "enclosure": "enclosure", "strip_m2": "strip mirror", "m4_m2": "M4 mirror",
         "strip_bearing": "strip bearing", "bore_m2": "bore duct", "roof_pen": "roof penetration", "flap_set": "slot flaps", "elbow_mirror": "elbow mirror", "shutter": "shutter",
         "inlet_work": "inlet work", "trench_dig": "insulation trench dig", "trench_fill_unit": "trench fill", "sand_m3": "sand", "sand_box": "sand box", "lid": "lid",
         "labour_day": "fabrication", "transport": "transport"}
    for k, item in m.items():
        v = g(item)
        if v is not None: U[k] = v
    # derived: rebar fins per m2 of bed per W/mK: ~2% steel by volume over a 0.2 m bed raises k by ~1 W/mK -> ~31 kg/m2
    if g("rebar fins") is not None: U["fins_m2_per_k"] = 31.0 * g("rebar fins")
    U["install_day"] = g("installation") or U["labour_day"]
    return U, T


def bom(d, prices=None):
    """d: design values (both boxes) plus site/film_m2/rim_m/rise/dish_scale. prices: a unit-price dict (UNIT's keys;
    default the placeholders - pass load_prices()[0] for the researched Pakistani rates). -> itemised list"""
    s = d.get("dish_scale", 1.0); deck = d.get("deck_h", 4.0); rise = d.get("rise", 0.0) if d.get("site", 0) >= 0.5 else 0.0
    section = d.get("site", 0.0) >= 0.5
    a = A_MEM0 * s; g = G_ORBIT0 * s
    film = d.get("film_m2", np.pi * a * a) if section else np.pi * a * a
    rim = d.get("rim_m", 2 * np.pi * a) if section else 2 * np.pi * a
    gore = 1.25 if section else 1.08
    nz = 5
    post_h = 4.87 + rise + 0.5                          # deck to F (the under-swing) + base
    arm = 3.0
    beam = 2 * (g + 0.6); aframe = 4 * 3.2; arc = 2 * (g + 0.35) * 1.45
    th = np.radians(d.get("strip_th_hi", 100.0)); r_mean = 1.4 * d.get("d_strip", 0.6)
    A_strip = r_mean * th * d.get("strip_wk", 1.1) * r_mean
    A_m4 = np.pi * d.get("r_m4", 1.3) ** 2
    # the descending beam is in open air above the deck; the DUCT runs from the deck (H_POT + deck) down to M4
    L_bore = (1.0 + deck) - Z_M4
    A_bore = 2 * np.pi * d.get("r_bore", 0.7) * L_bore
    roof_scale = max((2 * d.get("r_bore", 0.7) / ROOF_PEN_D0) ** 2, 0.25)          # the roof opening's area against the priced 1.4 m job
    rate = d.get("rate_scale", 1.0)
    ins = min(max(d.get("ins_scale", 1.0), 0.2), 1.0)
    sand_d = d.get("sand_depth", 0.0); sand_v = np.pi * R_POT ** 2 * sand_d * 1.3
    fins_k = max(d.get("sand_k", 0.3) - 0.3, 0.0)
    U = dict(UNIT) if prices is None else prices; items = []
    add = lambda group, item, spec, unit, qty, price: items.append(dict(group=group, item=item, spec=spec, unit=unit, qty=float(qty), unit_pkr=float(price), pkr=float(qty) * float(price)))
    add("primary", "reflective film", "aluminised PET 50 um, silvered", "m2", film * gore, U["film_m2"])
    add("primary", "plenum back sheet", "coated tarpaulin / PET", "m2", film * 1.1, U["back_sheet_m2"])
    add("primary", "rim tube", "rolled MS tube 40 mm, both rims" if section else "rolled MS tube 40 mm ring", "m", rim, U["rim_tube_m"])
    add("primary", "zone partitions", f"{nz} plenum zones", "m", nz * rim / 2, U["zone_wall_m"])
    add("primary", "zone pumps", "blower with speed control", "unit", nz, U["pump_unit"])
    add("primary", "pressure sensors", "differential, per zone", "unit", nz, U["press_sensor"])
    add("primary", "bleed valves", "per zone", "unit", nz, U["valve"])
    add("primary", "pneumatic tubing", "", "m", 5 * nz, U["tubing_m"])
    add("mount", "post / mast", "MS pipe 100 mm, deck to F", "m", post_h, U["post_pipe_m"])
    add("mount", "arm carrying F", "MS pipe 60 mm", "m", arm, U["arm_pipe_m"])
    add("mount", "guys and anchors", "3 wires, turnbuckles", "set", 1, U["guy_set"])
    add("mount", "mast head bearing", "azimuth trunnion", "unit", 1, U["mast_head"])
    add("mount", "rotating beam", "MS pipe 50 mm", "m", beam, U["beam_pipe_m"])
    add("mount", "A-frames", "MS tube 25 mm, two frames", "m", aframe, U["aframe_pipe_m"])
    add("mount", "arc rail", "rolled MS tube 25 mm, two tubes", "m", arc, U["arc_pipe_m"])
    add("mount", "bearings", "strap / pillow block", "unit", 6, U["bearing"])
    add("mount", "counterweight", "", "unit", 1, U["counterweight"])
    add("drive", "geared DC motors", f"24 V, x{rate:.2f}^1.5 size", "unit", 2, U["motor_geared"] * rate ** 1.5)
    add("drive", "motor drivers", "H-bridge", "unit", 2, U["driver"])
    add("drive", "encoders", "magnetic 12-bit", "unit", 2, U["encoder"])
    add("drive", "limit switches", "", "unit", 4, U["limit_sw"])
    add("control", "controller", "ESP32-class + RTC", "unit", 1, U["controller"])
    add("control", "sun sensor", "4-quadrant", "unit", 1, U["sun_sensor"])
    add("control", "power", "100 W PV + battery + charger", "set", 1, U["psu_solar"])
    add("control", "wiring", "cable, conduit", "set", 1, U["wiring_set"])
    add("control", "enclosure", "IP65", "unit", 1, U["enclosure"])
    add("receiver", "strip mirror", "polished Al on curved frame", "m2", A_strip, U["strip_m2"])
    add("receiver", "strip bearing", "on the F-F2 axis", "unit", 1, U["strip_bearing"])
    add("receiver", "bore duct", f"GI sheet below the deck, r {d.get('r_bore', 0.7):.2f} m x {L_bore:.1f} m", "m2", A_bore, U["bore_m2"])
    add("receiver", "roof penetration", f"opening {2*d.get('r_bore', 0.7):.1f} m: collar, flashing, waterproofing", "job", roof_scale, U["roof_pen"])
    add("receiver", "M4 mirror", "polished Al ellipsoid patch", "m2", A_m4, U["m4_m2"])
    add("receiver", "slot flaps", "mirrored, hinged", "set", 1, U["flap_set"])
    add("receiver", "elbow mirror", "concave, 2-DOF servo", "unit", 1, U["elbow_mirror"])
    add("receiver", "shutter", "damper + servo", "unit", 1, U["shutter"])
    add("receiver", "inlet work", "widen the native inlet", "job", 1, U["inlet_work"])
    if ins < 0.98:
        add("pit", "insulation trench dig", "narrow trench round the pit", "job", 1, U["trench_dig"])
        add("pit", "trench fill", "perlite / rice-husk ash", "unit", 1.0 / ins - 1.0, U["trench_fill_unit"])
    if sand_d > 0.01:
        add("pit", "sand", "washed", "m3", sand_v, U["sand_m3"])
        add("pit", "sand box", "dig-out + lining", "job", 1, U["sand_box"])
        if fins_k > 0:
            add("pit", "rebar fins", "per m2 of bed per W/mK", "m2.W/mK", 1.51 * fins_k, U["fins_m2_per_k"])
    add("pit", "lid", f"steel, leak {d.get('lid_leak', 0.18):.2f}", "unit", 0.18 / max(d.get("lid_leak", 0.18), 0.02), U["lid"])
    add("labour", "fabrication", "welding, rolling, assembly", "day", U["fabrication_days"], U["labour_day"])
    add("labour", "installation", "erection, alignment, commissioning", "day", U["install_days"], U.get("install_day", U["labour_day"]))
    add("labour", "transport", "", "job", 1, U["transport"])
    return items


def text(items):
    tot = sum(i["pkr"] for i in items); lines = []
    for g in ("primary", "mount", "drive", "control", "receiver", "pit", "labour"):
        gi = [i for i in items if i["group"] == g]; gs = sum(i["pkr"] for i in gi)
        lines.append(f"{g.upper():10s} {gs/1e3:6.1f}k")
        for i in gi:
            lines.append(f"    {i['item']:24s} {i['spec']:38s} {i['qty']:8.2f} {i['unit']:8s} x {i['unit_pkr']:8.0f} = {i['pkr']/1e3:6.1f}k")
    lines.append(f"{'TOTAL':10s} {tot/1e3:6.1f}k PKR")
    return "\n".join(lines)


if __name__ == "__main__":
    nominal = dict(dish_scale=1.0, deck_h=4.0, site=0.0, r_bore=0.7, r_m4=1.3, d_strip=0.6, strip_wk=1.1, strip_th_hi=100.0, rate_scale=1.0, ins_scale=1.0, sand_depth=0.0, sand_k=0.3, lid_leak=0.18)
    section = dict(nominal, site=1.0, film_m2=16.1, rim_m=2 * np.pi * 2.6 + 2 * np.pi * 0.75, rise=1.0, ins_scale=0.7, sand_depth=0.25, sand_k=1.0)
    PK, T = load_prices(); lo, _ = load_prices(which="low"); hi, _ = load_prices(which="high")
    for name, d in (("nominal circle (a 2.1 m, deck 4)", nominal), ("4 x 6 roof: 16 m2 section, F +1, trench, sand", section)):
        print(f"\n== {name} at the RESEARCHED Pakistani prices (typical) ==\n" + text(bom(d, PK)))
        print(f"   band: low {sum(i['pkr'] for i in bom(d, lo))/1e3:.0f}k .. high {sum(i['pkr'] for i in bom(d, hi))/1e3:.0f}k")
    json.dump(dict(units=PK, nominal=bom(nominal, PK), section=bom(section, PK)), open("/Users/faezs/ARTIST/tutorials/data/tandoor/bom_pk.json", "w"), indent=1)

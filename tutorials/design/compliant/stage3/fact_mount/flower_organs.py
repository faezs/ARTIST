#!/usr/bin/env python
"""The flower: recolour the FACT-mount model organ by organ for the register's viewer (out/flower_organs.json) and
write the botanical drawing of the same flower (figures/flower_botany.svg): a heliotropic bowl flower with an
inferior ovary, drawn so that every organ is one part of the machine."""
import json, os
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); FIG = os.path.join(HERE, "..", "..", "figures")
ORGANS = [  # (organ, colour, keywords or exact names in part names); first match wins
    ("sunlight", "#f6ad55", ("beam:", "sun direction")),
    ("heliotropism: the two rotation axes through F", "#4a5568", ("F-F2 axis",)),
    ("stigma: the strip under F where the light lands, F and F2", "#6b46c1", ("hyperboloid strip", "=F", "=F2")),
    ("ovary and fruit: the tandoor pot, inferior, below the ground", "#9b2c2c", ("tandoor pot",)),
    ("roots: the deck, its rail, the beam column and M4 below", "#7c4a1e", ("deck ring rail", "roof deck", "beam column", "M4")),
    ("style: the focal tube up the middle of the bowl, carrying the light down to the ovary", "#2f855a", ("focal tube", "strip ring")),
    ("stalk: the ring beam turning on the rail and the two posts up to the head's axis", "#276749", ("post", "ring beam", "saddle", "upright", "jack bracket")),
    ("pulvinus: the trunnion blocks, the joint that bends the head toward the sun", "#dd6b20", ("pivot blade", "ground bar", "intermediate bar", "moving bar", "arm clamp")),
    ("turgor: the water at the arms' ends that balances and trims the head; the jacks that hold it", "#2b6cb0", ("water tank", "screw jack", "crank")),
    ("calyx: the cradle, two arms beside the bowl and a frame behind it", "#6b8e23", ("side arm", "back frame", "post to the back frame", "frame spoke", "frame diagonal")),
    ("motor cells: the fine stage, blades and water columns that trim the head by microradians", "#15803d", ("fine stage", "flexure", "water column", "dish back C-ring", "strut foot")),
    ("corolla: the bowl of petals, the membrane and its rim", "#d69e2e", ("membrane", "rim toroid", "back plenum")),
    ("the ground", "#c9cfd6", ("south wall",)),
]
def organ_of(name):
    n = name.lower()
    for organ, col, keys in ORGANS:
        for k in keys:
            if (k.startswith("=") and name == k[1:]) or (not k.startswith("=") and k.lower() in n): return organ, col
    return "other", "#a0aec0"
if __name__ == "__main__":
    m = json.load(open(os.path.join(OUT, "fm_machine.json")))
    for p in m["parts"]:
        organ, col = organ_of(p["name"]); p["color"] = col; p["name"] = organ + " | " + p["name"]
    json.dump(m, open(os.path.join(OUT, "flower_organs.json"), "w"), separators=(",", ":"))
    import collections; print(collections.Counter(p["name"].split(" | ")[0].split(":")[0] for p in m["parts"]))
    svg = open(os.path.join(HERE, "flower_botany_src.svg")).read()
    os.makedirs(FIG, exist_ok=True); open(os.path.join(FIG, "flower_botany.svg"), "w").write(svg); print("botanical drawing written")

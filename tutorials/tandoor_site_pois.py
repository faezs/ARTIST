"""Decode Google Maps short plus codes of Quetta tandoor listings and look up the
nearest Open Buildings footprints (their roof areas)."""
import sys, json, numpy as np
ALPHA = "23456789CFGHJMPQRVWX"
def decode_full(code):
    code = code.replace("+", "").upper()
    lat, lng = -90.0, -180.0; res_lat, res_lng = 20.0, 20.0
    pairs = code[:10]
    for k in range(0, len(pairs), 2):
        lat += ALPHA.index(pairs[k]) * res_lat; lng += ALPHA.index(pairs[k + 1]) * res_lng
        res_lat /= 20; res_lng /= 20
    # grid refinement (11th+ chars): 4 rows x 5 cols
    rl, rg = res_lat, res_lng
    for ch in code[10:]:
        i = ALPHA.index(ch); rl /= 4; rg /= 5
        lat += (i // 5) * rl; lng += (i % 5) * rg
    return lat + rl / 2, lng + rg / 2
def recover(short, ref=(30.19, 67.005)):
    best = None
    for pre in ("8J28", "8J29", "8J38", "8J39"):
        la, lo = decode_full(pre + short)
        d = (la - ref[0]) ** 2 + (lo - ref[1]) ** 2
        if best is None or d < best[0]: best = (d, la, lo, pre + short)
    return best[1], best[2], best[3]
X = np.load("quetta_buildings.npy"); lat, lon, area, conf = X.T
pois = [l.strip() for l in sys.stdin if l.strip()]
out = []
for line in pois:
    name, code = line.rsplit(" ", 1)
    la, lo = recover(code)[:2]
    d = np.hypot((lat - la) * 111000, (lon - lo) * 111000 * np.cos(np.radians(la)))
    idx = np.argsort(d)[:3]
    out.append((name, code, la, lo, [(round(float(d[i])), round(float(area[i]))) for i in idx]))
    print(f"{name:34s} {code:9s} {la:.5f},{lo:.5f}  nearest footprints (dist m, area m2): {out[-1][4]}")
json.dump(out, open("tandoor_pois.json", "w"))

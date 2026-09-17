#!/usr/bin/env python
"""Recompute the membrane term of a finished run from its log (the term is a post-processing add-on: it never entered the dynamics) with the
gradient-blur law of stage3/topopt/membrane_wind.py, and rewrite the run's 'the day' summary line. Usage: remem.py TAG [TAG ...]"""
import os, sys, json, re, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); G = 4.0
for tag in sys.argv[1:]:
    L = json.load(open(os.path.join(OUT, tag + "_log.json"))); ident_p = os.path.join(OUT, tag + "_ident.txt"); lines = open(ident_p).read().strip().splitlines()
    for l in L:
        vw = l["wind"]; sm = 2.63e-5*vw*vw if vw > 0 else 0.0; l["miss_mem_cm"] = round(100*2*sm*G, 2); l["miss_tot_cm"] = round(float(np.hypot(l["miss_cm"], l["miss_mem_cm"])), 2)
    json.dump(L, open(os.path.join(OUT, tag + "_log.json"), "w"))
    A = json.load(open(os.path.join(OUT, tag + "_anim.json"))); T_S, T_C = A["t_setup"], A["t_cal"]
    day = [l for l in L if l["t"] >= T_S + T_C]; mm = np.array([l["miss_mem_cm"] for l in day]); mt = np.array([l["miss_tot_cm"] for l in day])
    for i, ln in enumerate(lines):
        if ln.startswith("the day"):
            ln = re.sub(r"membrane figure [\d.]+ cm mean", f"membrane figure {mm.mean():.1f} cm mean", ln)
            ln = re.sub(r"membrane's own figure \(5 zones, T 20 kN/m: [\d.]+ cm mean, [\d.]+ max\)", f"membrane's own figure (the pitching moment's gradient, membrane_wind.py: {mm.mean():.1f} cm mean, {mm.max():.1f} max)", ln)
            ln = re.sub(r"total [\d.]+ cm mean, [\d.]+ max", f"total {mt.mean():.1f} cm mean, {mt.max():.1f} max", ln); lines[i] = ln
    open(ident_p, "w").write("\n".join(lines) + "\n"); print(tag, "->", [l for l in lines if l.startswith("the day")][0][:220])

"""The grading, on the runtime side: select a column by what it IS, never by where it sits.

`RequestProject/HashemiGrade.lean` gives every column of every compiled morphism a subsystem, a
kind, a unit, a frame and a defining declaration, and `HashemiCcc.lean` writes them into the
kernel's own manifest as a `"grades"` array parallel to `"columns"`.  This module is what reads
them.

    from hashemi_grade import index, cols_of, obs_cols, truth_cols

    ECOL["capture"]                                  # a remembered name: shifts silently
    index(ENV, "capture", subsystem="optics", kind="dimensionless")   # a grade: cannot

The difference is not the index - both give the same integer - it is what happens when the
column changes.  230 mount columns landed under the env's own 96 this week; a name-keyed lookup
survived that, and would equally have survived `capture` quietly becoming a truth column or
`r_trainer` quietly becoming raw.  A grade-keyed lookup raises.

The checks below are the ones with teeth:

* `check_manifest`  - every column graded, the names line up, the vocabulary is closed, and the
  mechanically derived truth mask agrees with the stated kind;
* `check_reward_units` - the reward's raw columns and its trainer column differ by EXACTLY the
  declared `reward_div`, and nothing in raw units is added to the divided one.  That is the
  75x of 2026-09-19, as an assertion.  `--fail-demo` runs the same check against a deliberately
  mis-scaled copy of the morphism and reports the factor it catches.

    .venv/bin/python hashemi_grade.py               # every check, on every manifest
    .venv/bin/python hashemi_grade.py --fail-demo   # and the reward check FAILING, as it must
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

# the closed vocabularies (HashemiGrade.Sub / .Kind / .Frame).  A manifest that carries anything
# else is a manifest written by something that is not the grading.
SUBSYSTEMS = ("mount", "optics", "receiver", "loop", "pot", "policy", "reward", "omega", "scene")
KINDS = ("length", "angle", "temperature", "power", "energy", "mass", "force", "moment", "rate",
         "dimensionless", "truth")
FRAMES = ("roof", "dish", "bolt", "pot", "carriage", "sky", "none")

KERNELS = ("env", "policy", "beam", "reward", "mega")


class Ungraded(Exception):
    """a manifest with no grades, or a column whose grade is not what the caller expects"""


def manifest(kernel):
    """the manifest of one kernel by name: env, policy (the closed loop), beam, reward, mega"""
    return json.load(open(os.path.join(HERE, "hashemi_%s.json" % kernel)))


def grades(man):
    g = man.get("grades")
    if not g:
        raise Ungraded("manifest %r carries no grades: rebuild RequestProject.HashemiCcc"
                       % man.get("kernel", "?"))
    return g


def grade_of(man, name):
    """the grade of the column called `name`"""
    for g in grades(man):
        if g["name"] == name:
            return g
    raise Ungraded("no column %r in %r" % (name, man.get("kernel", "?")))


def index(man, name, subsystem=None, kind=None, unit=None, frame=None):
    """**the column's index, by its grade**: the name gives the column, and the grade the caller
    states is CHECKED against the manifest's.  A column that changed meaning raises here instead
    of being read as though it had not."""
    cols = man["columns"]
    try:
        i = cols.index(name)
    except ValueError:
        raise Ungraded("no column %r in %r" % (name, man.get("kernel", "?")))
    g = grades(man)[i]
    if g["name"] != name:
        raise Ungraded("the grades of %r are not in column order: column %d is %r, graded %r"
                       % (man.get("kernel", "?"), i, name, g["name"]))
    for key, want in (("subsystem", subsystem), ("kind", kind), ("unit", unit), ("frame", frame)):
        if want is not None and g[key] != want:
            raise Ungraded("the column %r is graded %s=%r, not %r (its grade: %s)"
                           % (name, key, g[key], want, _short(g)))
    return i


def cols_of(man, subsystem=None, kind=None, unit=None, frame=None, prefix=None, names=None):
    """every column with this grade, as (index, name), in the manifest's own order"""
    out = []
    for i, g in enumerate(grades(man)):
        if subsystem is not None and g["subsystem"] != subsystem:
            continue
        if kind is not None and g["kind"] != kind:
            continue
        if unit is not None and g["unit"] != unit:
            continue
        if frame is not None and g["frame"] != frame:
            continue
        if prefix is not None and not g["name"].startswith(prefix):
            continue
        if names is not None and g["name"] not in names:
            continue
        out.append((i, g["name"]))
    return out


def obs_cols(man, obs_names, prefix="obs_"):
    """**the policy's observation columns, by grade, in the POLICY's order.**

    `obs_names` is `machine_policy.OBS_NAMES` - the order the observation Box was built in, which
    is the policy's and not the manifest's.  Every one of them must be graded `policy`, and the
    manifest must hold no other `obs_` column graded `policy`: an observation appearing or
    disappearing is then a loud failure rather than a silently reordered Box."""
    want = [prefix + n for n in obs_names]
    idx = [index(man, n, subsystem="policy") for n in want]
    have = sorted(n for _, n in cols_of(man, subsystem="policy", prefix=prefix))
    if have != sorted(want):
        raise Ungraded("the manifest's policy-graded %s columns are %s, the policy asks for %s"
                       % (prefix, have, sorted(want)))
    return idx


def truth_cols(man):
    """the indices of the truth-valued columns (indicators: no Lipschitz bound, no interpolation,
    a flip fraction rather than a relative error in a parity test)"""
    return [i for i, _ in cols_of(man, kind="truth")]


def _short(g):
    return "%s/%s [%s] frame=%s from %s" % (g["subsystem"], g["kind"], g["unit"], g["frame"],
                                            g["decl"])


# ---------------------------------------------------------------- 1. the manifests themselves
def check_manifest(man, who):
    """every column graded, the names lined up, the vocabulary closed, the derived truth mask in
    agreement with the stated kind"""
    cols, gs = man["columns"], grades(man)
    n = int(man.get("n_columns", len(cols)))
    errs = []
    if not (len(cols) == len(gs) == n):
        errs.append("%d columns, %d grades, n_columns %d" % (len(cols), len(gs), n))
    for i, (c, g) in enumerate(zip(cols, gs)):
        if c != g["name"]:
            errs.append("column %d is %r but grade %d is %r" % (i, c, i, g["name"]))
        if g["subsystem"] not in SUBSYSTEMS:
            errs.append("%s: subsystem %r" % (c, g["subsystem"]))
        if g["kind"] not in KINDS:
            errs.append("%s: kind %r" % (c, g["kind"]))
        if g["frame"] not in FRAMES:
            errs.append("%s: frame %r" % (c, g["frame"]))
        if not g["decl"]:
            errs.append("%s: no declaration" % c)
        if g["kind"] == "truth" and g["unit"]:
            errs.append("%s: a truth column with the unit %r" % (c, g["unit"]))
    truth = man.get("truth")
    if truth is None:
        errs.append("no derived truth mask")
    else:
        if len(truth) != len(gs):
            errs.append("%d truth flags for %d columns" % (len(truth), len(gs)))
        for c, g, t in zip(cols, gs, truth):
            if bool(t) != (g["kind"] == "truth"):
                errs.append("%s: the graph says %s, the grade says %s"
                            % (c, "an indicator" if t else "a real", g["kind"]))
    return errs


# ---------------------------------------------------------------- 2. the reward's units
def reward_unit_rows(man):
    """the reward's columns split by their DECLARED unit: the raw ones and the trainer's"""
    raw_u = man.get("raw_unit")
    tr_u = man.get("trainer_unit")
    if not raw_u or not tr_u:
        raise Ungraded("the reward's manifest declares no raw/trainer unit")
    raw = cols_of(man, subsystem="reward", unit=raw_u)
    tr = cols_of(man, subsystem="reward", unit=tr_u)
    other = [(i, n) for i, n in cols_of(man, subsystem="reward")
             if n not in [x[1] for x in raw + tr]]
    return raw, tr, other, raw_u, tr_u


def check_reward_units(reward_div, B=4096, seed=3, mis_scale=False, verbose=True):
    """**the check that would have caught the 75x.**

    The reward is five columns of one morphism: four in the parent's RAW units and one in the
    trainer's, and the manifest says which is which (`unit`).  Two things must hold and both are
    measured here on the printed morphism itself, at the ini's own `reward_div`:

      1. the trainer's column times the divisor IS the raw total - exactly, not approximately:
         one division, in one place, of everything;
      2. the raw total is the parent's raw reward plus the shaping less the two bills - so
         nothing in raw units has been added to a divided column, and nothing divided has been
         added to a raw one.  The bug of 2026-09-19 was precisely a raw term added after the
         division on one path and before it on the other, and it is visible here as a residual of
         exactly `reward_div` times the shaping.

    `mis_scale=True` builds that bug: the shaping added to the trainer's column in raw units.
    The check must FAIL, and the factor it reports is the one the trainer would have seen."""
    from hashemi_reward_kernel import pack_reward, reward_numpy, RCOL, RIN
    man = manifest("reward")
    raw, tr, other, raw_u, tr_u = reward_unit_rows(man)
    errs = []
    if len(tr) != 1:
        errs.append("%d columns in trainer units (%r), expected exactly one" % (len(tr), tr_u))
    if other:
        errs.append("reward columns in neither unit: %s" % [n for _, n in other])
    rng = np.random.default_rng(seed)
    x = pack_reward(rng.uniform(-80, 80, B), 15.0, rng.uniform(0, 6000, B),
                    (rng.random(B) < 0.8).astype(np.float64), float(reward_div), 0.2, 5.0,
                    130000.0, p_pump=rng.uniform(0, 12, B),
                    film_excess=rng.uniform(-50, 150, B), pump_price=1.0, deg_price=5.0e-7)
    cols = reward_numpy(x)
    if mis_scale:
        # THE BUG, deliberately: the shaping is added to the TRAINER's column without being
        # divided - a raw-unit term in a divided column, which is what the two env paths did
        # differently. Nothing on disk is touched; the mis-scaling lives in this array.
        cols = cols.copy()
        cols[:, RCOL["r_trainer"]] = ((x[:, RIN["parentRaw"]] - cols[:, RCOL["r_pump_raw"]]
                                       - cols[:, RCOL["r_deg_raw"]]) / float(reward_div)
                                      + cols[:, RCOL["r_shape_raw"]])
    trainer = cols[:, tr[0][0]] if tr else cols[:, -1]
    raw_by = {n: cols[:, i] for i, n in raw}
    total = raw_by["r_raw"]
    scale = np.maximum(1.0, np.abs(total))
    # 1. the divisor, exactly
    d1 = np.abs(trainer * float(reward_div) - total) / scale
    # 2. the naturality square, all in raw units
    d2 = np.abs(total - x[:, RIN["parentRaw"]] - raw_by["r_shape_raw"]
                + raw_by["r_pump_raw"] + raw_by["r_deg_raw"]) / scale
    tol = 1e-9
    if float(d1.max()) > tol:
        # HOW BIG IS THE UNIT ERROR, in the units of the term that was misplaced: the residual is
        # (factor - 1) x the shaping, so `factor` is the number of times over the trainer sees it
        shape = raw_by["r_shape_raw"]
        big = np.abs(shape) > 1e-9
        factor = float(np.median(((trainer * float(reward_div) - total) / shape)[big] + 1.0)) \
            if big.any() else float("nan")
        errs.append("r_trainer * reward_div != r_raw: max relative %.3e - the shaping enters the "
                    "column graded %r %.1fx too large (a raw-unit term added after the division)"
                    % (float(d1.max()), tr_u, factor))
    if float(d2.max()) > tol:
        errs.append("r_raw is not parentRaw + shape - pump - deg: max relative %.3e" % float(d2.max()))
    if verbose:
        print("  reward units: %d raw columns %s at %r, 1 trainer column %s at %r"
              % (len(raw), [n for _, n in raw], raw_u, [n for _, n in tr], tr_u))
        print("  reward_div = %g;  max |r_trainer*div - r_raw| / scale = %.2e;  "
              "max |square| / scale = %.2e" % (float(reward_div), float(d1.max()), float(d2.max())))
    return errs


# ---------------------------------------------------------------- 3. what the box printer saved
def box_saving():
    """the truth columns of every compiled module, and the Lipschitz chains the box printer no
    longer prints for them (`hashemi_modula.json`, written by the same driver)"""
    mod = json.load(open(os.path.join(HERE, "hashemi_modula.json")))
    ms = mod["modules"]
    if "truth_outputs" not in ms[0]:
        raise Ungraded("hashemi_modula.json carries no truth mask: rebuild RequestProject.HashemiCcc")
    n_t = sum(sum(1 for b in m["truth_outputs"] if b) for m in ms)
    n_out = sum(m["n_out"] for m in ms)
    whole = sum(1 for m in ms if m["n_out"] and all(m["truth_outputs"]))
    dead = sum(m.get("box_dead_L", 0) for m in ms)
    live = sum(m.get("box_live_nodes", 0) for m in ms)
    return dict(modules=len(ms), truth=n_t, columns=n_out, whole=whole, dead_L=dead, live=live)


def main(argv):
    fail_demo = "--fail-demo" in argv
    bad = 0
    print("the grading, on disk:")
    for k in KERNELS:
        try:
            man = manifest(k)
        except FileNotFoundError:
            continue
        try:
            errs = check_manifest(man, k)
        except Ungraded as e:
            print("  %-7s UNGRADED: %s" % (k, e)); bad += 1; continue
        gs = grades(man)
        subs = {}
        for g in gs:
            subs[g["subsystem"]] = subs.get(g["subsystem"], 0) + 1
        print("  %-7s %3d columns  %s" % (k, len(gs), "  ".join(
            "%s %d" % (s, subs[s]) for s in SUBSYSTEMS if s in subs)))
        if errs:
            bad += 1
            for e in errs[:12]:
                print("      X %s" % e)
    print("\nthe box printer:")
    try:
        b = box_saving()
        print("  %d truth columns of %d over %d modules; %d modules are truth all through; "
              "the Lipschitz chain is skipped at %d of %d live nodes (%.0f %%)"
              % (b["truth"], b["columns"], b["modules"], b["whole"], b["dead_L"], b["live"],
                 100.0 * b["dead_L"] / max(b["live"], 1)))
    except (Ungraded, FileNotFoundError) as e:
        print("  X %s" % e); bad += 1

    print("\nthe reward's units (the 75x):")
    try:
        errs = check_reward_units(75.0)
        for e in errs:
            print("      X %s" % e)
        bad += bool(errs)
        print("  PASS" if not errs else "  FAIL")
    except Ungraded as e:
        print("  X %s" % e); bad += 1

    if fail_demo:
        print("\nthe same check on a DELIBERATELY mis-scaled copy (the shaping added to the "
              "trainer's column in raw units):")
        errs = check_reward_units(75.0, mis_scale=True)
        for e in errs:
            print("      X %s" % e)
        if errs:
            print("  the check FAILED, as it must - the grading has teeth")
        else:
            print("  X the mis-scaled copy PASSED: the check has no teeth"); bad += 1
        print("  (nothing on disk was touched: the mis-scaling lives in one array of this run)")

    print("\n%s" % ("every check green" if bad == 0 else "%d checks failed" % bad))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

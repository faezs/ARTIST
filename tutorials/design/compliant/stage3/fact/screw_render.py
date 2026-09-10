"""realise(screws, ...) -> members : a pure function from a screw-theory mechanism to physical geometry.

Given a mechanism written the only way a mechanism is really specified - a list of screws - this returns the parts
that realise it: where every blade, pin, slide and torsion bar sits in world coordinates, how thick it is, how long,
and what stress it carries. No files, no globals, no randomness, no drawing. Input to output, deterministic.

THE THREE RULES IT APPLIES, each from a source rather than taste:

1. WHERE THE MATERIAL GOES - FACT (Howell et al., Handbook of Compliant Mechanisms, ch. 6, fig. 6.2A). For a freedom
   space that is a single rotation about a line, the complementary constraint space is EVERY PLANE THAT INTERSECTS
   THAT LINE'S AXIS, and a flexure system has that DOF precisely when its blades lie on those intersecting planes.
   So a revolute is realised as blades in planes containing its axis - which is what a cross-axis pivot is, derived
   rather than recalled. A prismatic's constraints are the planes perpendicular to its direction: a leaf parallelogram.

2. WHETHER IT CAN BE COMPLIANT AT ALL - the elastica, not Euler. Euler's P_cr is the load at which a STRAIGHT column
   goes unstable and says nothing about a member deliberately bent. For the inextensible elastica with end slope a
   and m = sin^2(a/2), one first integral gives both the load and the curvature, so they cannot be picked separately:
       P / P_euler   = 4 K(m)^2 / pi^2          capacity RISES with deflection (1.26x at 76 deg)
       eps           = 2 t sin(a/2) K(m) / L    and curvature concentrates, so strain is ~3.3x the constant-curvature
                                                bound - the binding constraint, and the one that decides rigid vs flexure
3. WHEN TO GIVE UP AND USE A PIN - ch. 8 (8.2.4): a flexible link mimics a rigid one only to about 60 deg, beyond which
   a pin-jointed rigid link is better. Here that threshold is not asserted but computed: a joint is compliant if the
   elastica's slenderness at its travel and strain allowance is under `max_slenderness`, and a pin otherwise.

A screw is (name, w, q, pitch, travel, load): w the axis direction, q any point on it, pitch 0 for a revolute, inf for
a prismatic, travel in radians (revolute) or metres (prismatic), load in newtons. Returns a list of member dicts with
explicit world-frame vertices, so the caller can draw, mesh, cost or export them without this module knowing how."""
from math import pi, sin, cos, sqrt, isinf
import numpy as np
from scipy.special import ellipk

STEEL = dict(name="spring steel", E=200e9, G=79e9, eps=0.002, rho=7850.0)
TITANIUM = dict(name="beta titanium", E=105e9, G=40e9, eps=0.010, rho=4620.0)


def _frame(w):
    """an orthonormal frame with w first. Pure: same w in, same frame out."""
    w = np.asarray(w, float); w = w/max(np.linalg.norm(w), 1e-12)
    a = np.array([0.0, 0.0, 1.0])
    if abs(float(w @ a)) > 0.9: a = np.array([1.0, 0.0, 0.0])
    u = np.cross(w, a); u = u/max(np.linalg.norm(u), 1e-12)
    return w, u, np.cross(w, u)


def elastica(alpha):
    """the exact large-deflection pair for an end slope alpha, from the single first integral.
    returns (load factor over Euler, strain coefficient c) with eps = c * t / L."""
    a = max(float(abs(alpha)), 1e-9); m = sin(a/2.0)**2; K = float(ellipk(m))
    return 4.0*K*K/(pi*pi), 2.0*sin(a/2.0)*K


def blade_for(travel, load, mat, max_slenderness):
    """size one blade from the elastica: slenderness from the strain allowance, section from the load it carries.
    returns None when the travel demands a member too slender to be a structure - the honest 'use a pin' answer."""
    fac, c = elastica(travel)
    Lt = c/mat["eps"]                                     # eps = c t / L  ->  L/t
    if Lt > max_slenderness: return None
    K = sqrt(fac*pi*pi/4.0)
    wt = 3.0*load*Lt*Lt/(mat["E"]*K*K)                    # from P = 4 EI K^2 / L^2 with I = w t^3 / 12
    t = sqrt(wt/12.0) if wt > 0 else 1e-3                 # a 12:1 width-to-thickness blade, the usual proportion
    return dict(t=float(t), w=float(wt/max(t, 1e-9)), L=float(Lt*t), slenderness=float(Lt), load_factor=float(fac))


def stations_for(travel, mat, max_slenderness, max_stations=64):
    """the smallest number of series pivots that brings each inside the slenderness limit, or 0 if none will."""
    for n in range(1, int(max_stations) + 1):
        if elastica(travel/n)[1]/mat["eps"] <= max_slenderness: return n
    return 0


def realise(screws, radius=0.15, n_blades=2, mat=STEEL, max_slenderness=200.0, span=0.20, stack=True,
            evaluate_too=False):
    """THE FUNCTION. screws -> members. Pure.

    screws           iterable of (name, w, q, pitch, travel, load)
    radius           how far from the axis the blades stand [m]
    n_blades         constraints per compliant joint (2 = the cross-axis pair)
    mat              material dict: E, G, eps (strain allowance), rho
    max_slenderness  above this L/t a flexure stops being a structure and the joint is returned as a pin
    span             the member's extent along its own axis [m]

    returns a list of dicts, each with 'joint', 'kind', 'verts' (world-frame ndarray) and the sizing that produced it.
    """
    out = []
    for (name, w, q, pitch, travel, load) in screws:
        ax, u, v = _frame(w); q = np.asarray(q, float)
        if isinf(pitch):                                   # ---- prismatic: constraints are planes PERPENDICULAR to travel
            b = blade_for(min(abs(travel)/max(radius, 1e-6), pi/2), load, mat, max_slenderness)
            kind = "leaf parallelogram" if b else "rigid slide"
            for k in range(2):                             # two leaves make the parallelogram that keeps the stage parallel
                c0 = q + (k - 0.5)*span*u
                if b:
                    # the leaf lies ACROSS the travel: length perpendicular to it, thickness along it. Length along
                    # the travel direction would make it stiff in exactly the freedom it exists to permit - the same
                    # error as running a revolute's blade tangentially.
                    e = 0.5*b["w"]*v; f = b["L"]*u
                    out.append(dict(joint=name, kind=kind, verts=np.array([c0 - e, c0 + e, c0 + e + f, c0 - e + f]),
                                    axis=ax.copy(), **b))
                else:
                    out.append(dict(joint=name, kind=kind, verts=np.array([c0, c0 + abs(travel)*ax]), axis=ax.copy(),
                                    reason="travel needs a slenderness a leaf cannot hold"))
            continue
        # M-52 / M-26: when one pivot cannot take the travel, STACK identical pivots with concomitant axes in series.
        # Stroke adds linearly, so strain per pivot falls as 1/N and slenderness with it: 76 deg is L/t 1086 in one
        # pivot and 130 in eight, and the stack is no longer overall because L/t falls as fast as N rises. The price
        # is N-1 internal DOFs, which is what M-52's slaving mechanism exists to suppress with its 1:2 motion law.
        n_st = stations_for(travel, mat, max_slenderness) if stack else (1 if blade_for(travel, load, mat, max_slenderness) else 0)
        if n_st == 0:
            out.append(dict(joint=name, kind="pin", verts=np.array([q - 0.5*span*ax, q + 0.5*span*ax]), axis=ax.copy(),
                            slenderness=float(elastica(travel)[1]/mat["eps"]),
                            reason=f"L/t {elastica(travel)[1]/mat['eps']:.0f} exceeds {max_slenderness:.0f} even stacked: pin it"))
            continue
        b = blade_for(travel/n_st, load, mat, max_slenderness)
        prev = None
        for st in range(n_st):
            zc = q + (st - 0.5*(n_st - 1))*span*ax
            for k in range(int(n_blades)):                 # blades lie in PLANES THAT CONTAIN THE AXIS (fig. 6.2A)
                phi = pi*k/max(int(n_blades), 1)
                r = cos(phi)*u + sin(phi)*v
                c0 = zc + radius*r
                # the blade LIES IN the plane spanned by {axis, r}: length radial, width along the axis, thin normal
                # to the plane. It is then compliant TANGENTIALLY, which is what leaves rotation about the axis free.
                e = 0.5*b["w"]*ax
                f = b["L"]*r
                out.append(dict(joint=name, kind="blade", verts=np.array([c0 - e, c0 + e, c0 + e + f, c0 - e + f]),
                                axis=ax.copy(), plane_normal=np.cross(ax, r), station=st, n_stations=n_st,
                                travel_each=float(travel/n_st), **b))
            slave = zc + 1.25*radius*u
            if prev is not None:
                out.append(dict(joint=name, kind="slaving link", verts=np.array([prev, slave]), axis=ax.copy(),
                                station=st, n_stations=n_st,
                                note="links base, output and intermediate block (M-52, 1:2 motion law)"))
            prev = slave
    if evaluate_too: return out, evaluate(out, screws, mat=mat)
    return out


def _twist(w, q, pitch):
    """the screw as a TWIST in (v; omega) order about the world origin.
    revolute about the line (w, q): a point x moves at w x (x - q), so v_O = q x w. prismatic: pure translation."""
    w = np.asarray(w, float); w = w/max(np.linalg.norm(w), 1e-12); q = np.asarray(q, float)
    if isinf(pitch): return np.concatenate([w, np.zeros(3)])
    return np.concatenate([np.cross(q, w), w])


def _wrenches(members):
    """each realised member as the CONSTRAINT it imposes, with its stiffness: a blade is a constraint line along its
    own length at EA/L, and a much softer one normal to its plane at 3EI/L^3. Both are returned, because the whole
    question an eval answers is whether the soft direction really is soft enough to count as a freedom."""
    out = []
    for m in members:
        if m["kind"] in ("pin", "rigid slide", "slaving link"): continue
        E = m.get("E", STEEL["E"]); v = m["verts"]
        if len(v) < 4: continue
        p = v.mean(axis=0); d = v[3] - v[0]; L = float(np.linalg.norm(d))
        if L < 1e-9: continue
        d = d/L; t, wd = m["t"], m["w"]
        out.append((np.concatenate([d, np.cross(p, d)]), E*wd*t/L, m["joint"], "axial"))
        n = m.get("plane_normal")
        if n is None:
            n = np.cross(d, v[1] - v[0]); nn = np.linalg.norm(n)
            n = n/nn if nn > 1e-9 else np.array([0.0, 0.0, 1.0])
        out.append((np.concatenate([n, np.cross(p, n)]), 3.0*E*(wd*t**3/12.0)/L**3, m["joint"], "bending"))
    return out


def evaluate(members, screws, mat=STEEL, free_tol=1e-9, scale=None):
    """EVAL: does the geometry that came out actually have the freedom space that went in? Pure.

    A FLEXURE IS NEVER FREE, IT IS SOFT BY A RATIO - a blade resists rotation about its own axis through out-of-plane
    bending, 3EI/L^3 against EA/L axially. So the figure of merit is the stiffest constrained direction over the
    stiffness in the direction we asked to be free. The 6x6 stiffness mixes N/m with N m/rad, so it is
    non-dimensionalised by a characteristic length before any eigen-decomposition; without that its eigenvalues are
    not comparable and its eigenvectors are not even frame-invariant."""
    by_joint = {}
    for m in members: by_joint.setdefault(m["joint"], []).append(m)
    rep = []
    for (name, w, q, pitch, travel, load) in screws:
        mem = by_joint.get(name, [])
        want = _twist(w, q, pitch)
        if not mem or all(m["kind"] in ("pin", "rigid slide") for m in mem):
            rep.append(dict(joint=name, kind=mem[0]["kind"] if mem else "none", ideal=True,
                            note="a kinematic pair: its freedom is exact, and its cost is backlash, not compliance"))
            continue
        ws = _wrenches(mem)
        if not ws: continue
        K = np.zeros((6, 6))
        for sw, k, _, _ in ws: K += k*np.outer(sw, sw)
        l = float(scale) if scale else max(float(np.linalg.norm(m["verts"][3] - m["verts"][0]))
                                           for m in mem if len(m["verts"]) >= 4)
        Sc = np.diag([1.0, 1.0, 1.0, l, l, l]); Kt = Sc @ K @ Sc
        ev, V = np.linalg.eigh(Kt)
        wn = Sc @ want; wn = wn/max(np.linalg.norm(wn), 1e-12)
        k_want = float(wn @ Kt @ wn)
        ratio = float(ev.max()/max(k_want, 1e-30))
        free = V[:, ev <= max(ev.max(), 1e-30)*free_tol]
        n_st = max((m.get("n_stations", 1) for m in mem), default=1)
        vol = sum(float(np.linalg.norm(m["verts"][3] - m["verts"][0]))*m["t"]*m["w"]
                  for m in mem if "t" in m and len(m["verts"]) >= 4)
        rep.append(dict(joint=name, kind=mem[0]["kind"], ideal=False, softness_ratio=ratio,
                        good_pivot=bool(ratio > 100.0), k_want=k_want, k_stiffest=float(ev.max()),
                        n_free_numeric=int(free.shape[1]), n_stations=int(n_st),
                        internal_dofs=int(n_st - 1), mass_kg=float(vol*mat["rho"])))
    return rep


def torsion_bar(axis, q, torque, length, mat=STEEL):
    """the one constraint a 5-DOF stage needs: a couple about its own axis, everything else free.
    A pure force cannot do this - it always does work on translation along itself - so the complement of
    {3 translations + 2 tips} is a COUPLE, and its realisation is a bar in torsion. Pure."""
    ax, _, _ = _frame(axis); q = np.asarray(q, float)
    r = (2.0*torque*length/(pi*mat["G"]*mat["eps"]))**(1.0/3.0)      # tau = T r / J, J = pi r^4 / 2, gamma ~ eps
    return dict(joint="torsional constraint", kind="torsion bar", r=float(r), L=float(length),
                verts=np.array([q, q + length*ax]), axis=ax.copy(),
                note="stiff in twist about the optical axis, free in the five the stage actuates")

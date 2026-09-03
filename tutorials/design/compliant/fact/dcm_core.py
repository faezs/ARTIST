"""Directionally compliant metamaterial (DCM) synthesis, after Shaw, Sun,
Portela, Barranco, Greer & Hopkins, Nat. Commun. 10:291 (2019):
a block is sliced into rigid layers along a stacking direction; between
consecutive layers, every cell of the interface gets flexure elements
whose constraint lines (pure-force wrenches) lie in the constraint
space of the desired freedom space (the null space of [T_FS][Delta]).
Each interface then allows exactly that freedom space (heavily
over-constrained, which the cell redundancy tolerates), and the stack
of N interfaces in series allows the same freedom space with N times
the range and 1/N the stiffness in the compliant directions.  The
assembly check re-derives the stage's freedoms from the element
wrenches by null space (the paper's 'computationally efficient' step)."""
import numpy as np
from fact_core import rot_twist, trans_twist, wire, blade, constraint_space, describe
DELTA = np.block([[np.zeros((3, 3)), np.eye(3)], [np.eye(3), np.zeros((3, 3))]])
def interface_freedom(wrenches):
    """twists left free by a set of element constraint lines (parallel system)"""
    C = np.atleast_2d(np.array(wrenches, float)); u, s, vt = np.linalg.svd(C @ DELTA); r = int((s > 1e-9).sum())
    return vt[r:], r
def series_freedom(interface_twist_sets):
    """freedoms of a stack: the span (union) of the interfaces' freedoms"""
    F = np.vstack([t for t in interface_twist_sets if len(t)]); u, s, vt = np.linalg.svd(F); r = int((s > 1e-9).sum())
    return vt[:r]
# ---- element placement rules for the two canonical freedom spaces (paper Examples 2 and 3) -------------
def elements_1R(axis_point, axis_dir, cell_centre, half):
    """1 rotational DOF: every constraint line must meet the axis.  A blade whose plane contains the axis
    line does that for all its lines; two blades per cell in two such planes, offset to the cell's sides."""
    a, w = np.asarray(axis_point, float), np.asarray(axis_dir, float)/np.linalg.norm(axis_dir); c = np.asarray(cell_centre, float)
    out = []
    for off in (-0.45*half, 0.45*half):
        # pick the cell-side point q by moving from the centre along a direction perpendicular to both w and (c - a)
        rad = c - a; rad -= w*(rad@w)
        if np.linalg.norm(rad) < 1e-9: rad = np.cross(w, [1, 0, 0]) if abs(w[0]) < 0.9 else np.cross(w, [0, 1, 0])
        side = np.cross(w, rad); side /= np.linalg.norm(side)
        q = c + off*side                                # a point of the cell; the plane through q containing the axis line
        n = np.cross(w, q - a); n /= np.linalg.norm(n)   # plane normal
        out.append(dict(kind="blade", point=q, normal=n, u=w, wrenches=blade(q, n, w)))
    return out
def elements_nR_point(point, cell_centre, k=3):
    """rotations about a common point: constraint space = all lines through the point; k wires through it"""
    P, c = np.asarray(point, float), np.asarray(cell_centre, float); out = []
    d0 = c - P; d0 /= max(np.linalg.norm(d0), 1e-9)
    perp = np.cross(d0, [0, 0, 1]) if abs(d0[2]) < 0.9 else np.cross(d0, [1, 0, 0]); perp /= np.linalg.norm(perp); perp2 = np.cross(d0, perp)
    for j in range(k):
        q = c + 0.35*np.linalg.norm(c - P)*(np.cos(2*np.pi*j/k)*perp + np.sin(2*np.pi*j/k)*perp2)*0.3
        out.append(dict(kind="wire", point=q, direction=q - P, wrenches=[wire(P, q - P)]))
    return out
# ---- lattice builder ---------------------------------------------------------------------------------
def dcm_block(cells, cell, stack_axis, n_layers, element_fn):
    """cells: (nx, ny, nz) counts; cell: size [mm]; stack_axis: 0/1/2; n_layers: rigid layers along that axis.
    Returns dict(layers=[(lo, hi)...], interfaces=[{cells:[centres], elements:[...]}], ...)"""
    n = np.array(cells); L = n*cell; lo = -L/2
    layer_t = L[stack_axis]/n_layers
    layers = [(lo[stack_axis] + i*layer_t, lo[stack_axis] + (i+1)*layer_t) for i in range(n_layers)]
    interfaces = []
    other = [i for i in range(3) if i != stack_axis]
    for i in range(n_layers - 1):
        z_if = layers[i][1]; els, cents = [], []
        for a in range(n[other[0]]):
            for b in range(n[other[1]]):
                c = np.zeros(3); c[other[0]] = lo[other[0]] + (a + 0.5)*cell; c[other[1]] = lo[other[1]] + (b + 0.5)*cell; c[stack_axis] = z_if
                cents.append(c); els += element_fn(c, cell/2)
        interfaces.append(dict(z=z_if, cells=cents, elements=els))
    return dict(layers=layers, interfaces=interfaces, L=L, lo=lo, stack_axis=stack_axis)
def check_block(block, desired_twists, label):
    per = []
    for k, itf in enumerate(block["interfaces"]):
        W = [w for e in itf["elements"] for w in e["wrenches"]]
        free, rank = interface_freedom(W); per.append(free)
        print(f"[{label}] interface {k}: {len(W)} constraint lines, rank {rank}, DOF {6 - rank}: {describe(free)}")
    stack = series_freedom(per)
    Fd = np.atleast_2d(np.array(desired_twists, float)); ok = np.allclose(Fd @ DELTA @ np.vstack([w for itf in block['interfaces'] for e in itf['elements'] for w in e['wrenches']]).T, 0, atol=1e-9)
    print(f"[{label}] stack of {len(per)} interfaces: DOF {len(stack)} -> {describe(stack)}; desired freedoms preserved by every element: {ok}")
    return stack
# ---- solids for the viewer (no booleans: every element is its own part) -------------------------------
def export_block(block, path, blade_t=1.0, wire_d=1.5, gap=None, color_flex="#d9480f", color_rigid="#9aa5b1", cell=None):
    import cadquery as cq
    from mesh_export import Scene
    sc = Scene(); L, lo, ax = block["L"], block["lo"], block["stack_axis"]; gap = gap or 0.35*(cell or 10)
    dims = L.copy()
    for i, (a, b) in enumerate(block["layers"]):
        t = (b - a) - gap; ctr = np.zeros(3); ctr[ax] = 0.5*(a + b); ctr[[j for j in range(3) if j != ax]] = (lo + L/2)[[j for j in range(3) if j != ax]]
        size = L.copy(); size[ax] = t
        sc.add(cq.Workplane("XY").box(*size).translate(tuple(ctr)), f"rigid layer {i}", color_rigid, tol=2.0)
    for k, itf in enumerate(block["interfaces"]):
        for j, e in enumerate(itf["elements"]):
            if e["kind"] == "blade":
                n, u = e["normal"], e["u"]; v = np.cross(n, u)
                span = (cell or 10)*0.9
                b = cq.Workplane("XY").box(span, gap*1.15, blade_t)      # x along u, y along the stack (through the gap), z = normal
                # orient: local x -> u, local z -> n
                M = np.array([u, np.cross(n, u), n]).T
                import math
                # cadquery: rotate via a transform matrix
                mat = cq.Matrix([[M[0,0], M[0,1], M[0,2], e["point"][0]], [M[1,0], M[1,1], M[1,2], e["point"][1]], [M[2,0], M[2,1], M[2,2], e["point"][2]], [0, 0, 0, 1]])
                sc.add(cq.Workplane("XY").add(b.val().transformGeometry(mat)), f"blade {k}.{j}", color_flex, tol=0.5)
            else:
                p, d = e["point"], e["direction"]/np.linalg.norm(e["direction"]); h = gap*1.15
                w_ = cq.Workplane("XY").circle(wire_d/2).extrude(h).translate((0, 0, -h/2))
                z = np.array([0, 0, 1.0]); v = np.cross(z, d); s = np.linalg.norm(v); c_ = z@d
                if s > 1e-9: w_ = w_.rotate((0, 0, 0), tuple(v/s), np.degrees(np.arctan2(s, c_)))
                sc.add(w_.translate(tuple(p)), f"wire {k}.{j}", color_flex, tol=0.3)
    sc.write(path)
if __name__ == "__main__":
    # Paper Example 2: a 5x5x5-cell cube, one rotational DOF about the axis through its centre (here the y axis), stacked along x
    cell = 25.4; axis_p, axis_d = [0, 0, 0], [0, 1, 0]
    blk = dcm_block((5, 5, 5), cell, stack_axis=0, n_layers=5, element_fn=lambda c, h: elements_1R(axis_p, axis_d, c, h))
    stack = check_block(blk, [rot_twist(axis_p, axis_d)], "Example 2: 1R cube")
    import sys, os; sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "3d"))
    export_block(blk, "figures/dcm_example2_1R_cube.json", cell=cell)
    # Example 3: three intersecting rotations about the cube centre: 3 wires per cell through the centre, 4x4x4
    blk3 = dcm_block((4, 4, 4), cell, stack_axis=2, n_layers=4, element_fn=lambda c, h: elements_nR_point([0, 0, 0], c, 3))
    check_block(blk3, [rot_twist([0, 0, 0], [1, 0, 0]), rot_twist([0, 0, 0], [0, 1, 0]), rot_twist([0, 0, 0], [0, 0, 1])], "Example 3: 3R sphere cube")
    export_block(blk3, "figures/dcm_example3_3R_cube.json", cell=cell)

# ======================================================================================================
# Supplementary rules (Shaw et al. 2019, Supp. Figs 7-9): the tool joins a cell's two rigid bodies with the
# MINIMUM number of independent wire elements lying in the constraint space.  For 1R that is five wires
# meeting the axis: three non-concurrent lines in one plane through the axis, two in another (Supp. Fig. 7d).
def elements_1R_wires(axis_point, axis_dir, cell_centre, half, gap):
    a, w = np.asarray(axis_point, float), np.asarray(axis_dir, float)/np.linalg.norm(axis_dir); c = np.asarray(cell_centre, float)
    rad = c - a; rad -= w*(rad@w); rn = np.linalg.norm(rad)
    if rn < 1e-9: rad = np.cross(w, [1, 0, 0]) if abs(w[0]) < 0.9 else np.cross(w, [0, 1, 0]); rn = np.linalg.norm(rad)
    rad /= rn; side = np.cross(w, rad)
    out = []
    # plane A: contains the axis and the cell centre (spanned by w, rad): three lines meeting the axis at different points
    for (s_w, s_r) in ((-0.35, 1.0), (0.0, 1.0), (0.35, 1.0)):
        p = c + s_w*half*w; d = -(p - a)                       # line from p toward the axis point directly "below" it
        d = d - w*(d@w) + (0.6*half)*w*np.sign(s_w + 1e-9)*0.0  # keep it in plane A (radial + axial mix)
        d = d/np.linalg.norm(d) + 0.5*w*s_w/abs(s_w + 1e-9) if False else d/np.linalg.norm(d)
        # tilt each line differently along the axis so the three are not concurrent: mix radial and axial directions
        tilt = (s_w*1.5)*w; dd = rad*(-1.0) + tilt; dd /= np.linalg.norm(dd)
        out.append(dict(kind="wire", point=p, direction=dd, wrenches=[wire(p, dd)]))
    # plane B: through the axis, rotated by 60 deg about it: two lines meeting the axis
    rb = np.cos(np.radians(60))*rad + np.sin(np.radians(60))*side
    for s_w in (-0.3, 0.3):
        p = c + 0.4*half*rb*0 + s_w*half*w + 0.3*half*side   # a point of the cell off plane A
        # line from p meeting the axis: direction toward the axis point at parameter (p - a).w
        foot = a + w*((p - a)@w); dd = foot - p; dd = dd/np.linalg.norm(dd) + 0.8*s_w/abs(s_w)*w*0.0; dd /= np.linalg.norm(dd)
        out.append(dict(kind="wire", point=p, direction=dd, wrenches=[wire(p, dd)]))
    return out
def masked_block(block, mask):
    """drop the interface cells whose centres fall outside the bulk shape (mask: callable(xyz)->bool)"""
    for itf in block["interfaces"]:
        keep = [i for i, c in enumerate(itf["cells"]) if mask(c)]
        per = len(itf["elements"]) // max(len(itf["cells"]), 1)
        itf["elements"] = [e for i in keep for e in itf["elements"][i*per:(i+1)*per]]; itf["cells"] = [itf["cells"][i] for i in keep]
    return block
# ---- frame finite-element check: rigid layers (6 DOF each) joined by wire beams ---------------------------
def frame_fe(block, E, G, wire_d, gap, rho=4430.0):
    """Assemble the stiffness of the stack: each rigid layer is a body with 6 DOF; each wire element is a 3-D
    Euler-Bernoulli beam of length `gap` and diameter `wire_d` whose ends are rigidly attached to the two layers
    it joins (node DOF = body DOF via u = u0 + theta x r).  Returns the 6x6 stiffness of the top layer w.r.t.
    ground (bottom layer fixed) about the top layer's centre, its eigen-decomposition (softest direction first),
    and the compliant-to-stiff ratio.  Units: N, mm, rad."""
    A = np.pi*wire_d**2/4; I = np.pi*wire_d**4/64; J = 2*I; L = gap
    k = np.zeros((12, 12)); EA, EI, GJ = E*A/L, E*I, G*J/L
    k[0,0]=k[6,6]=EA; k[0,6]=k[6,0]=-EA; k[3,3]=k[9,9]=GJ; k[3,9]=k[9,3]=-GJ
    for (i1, i2, s) in ((1, 5, 1.0), (2, 4, -1.0)):   # bending in the two planes: dofs (v, theta_z) and (w, theta_y)
        a, b, c, d = i1, i2, i1+6, i2+6
        k[a,a]+=12*EI/L**3; k[a,b]+=s*6*EI/L**2; k[a,c]+=-12*EI/L**3; k[a,d]+=s*6*EI/L**2
        k[b,a]+=s*6*EI/L**2; k[b,b]+=4*EI/L; k[b,c]+=-s*6*EI/L**2; k[b,d]+=2*EI/L
        k[c,a]+=-12*EI/L**3; k[c,b]+=-s*6*EI/L**2; k[c,c]+=12*EI/L**3; k[c,d]+=-s*6*EI/L**2
        k[d,a]+=s*6*EI/L**2; k[d,b]+=2*EI/L; k[d,c]+=-s*6*EI/L**2; k[d,d]+=4*EI/L
    def rot_to(d):                       # rotation matrix whose first column is the beam axis d
        d = d/np.linalg.norm(d); t = np.cross(d, [0, 0, 1.0]) if abs(d[2]) < 0.9 else np.cross(d, [1.0, 0, 0]); t /= np.linalg.norm(t); n = np.cross(d, t)
        return np.array([d, t, n]).T
    nL = len(block["layers"]); K = np.zeros((6*nL, 6*nL)); ax = block["stack_axis"]
    centres = []
    for (a_, b_) in block["layers"]:
        c = (block["lo"] + block["L"]/2).copy(); c[ax] = 0.5*(a_ + b_); centres.append(c)
    def rigid_map(r):                    # node displacement/rotation from body (u, theta): u_n = u + theta x r, th_n = theta
        Tm = np.eye(6); rx = np.array([[0, r[2], -r[1]], [-r[2], 0, r[0]], [r[1], -r[0], 0]]); Tm[:3, 3:] = rx; return Tm
    for i, itf in enumerate(block["interfaces"]):
        for e in itf["elements"]:
            if e["kind"] != "wire": continue
            p, d = np.asarray(e["point"]), np.asarray(e["direction"])/np.linalg.norm(e["direction"])
            # the wire spans the gap between layers i and i+1 along its own direction: endpoints where it meets the layer faces
            zf0, zf1 = block["layers"][i][1] - 0.5*gap, block["layers"][i][1] + 0.5*gap   # (rigid layers end gap/2 short of the interface plane)
            t0 = (zf0 - p[ax])/d[ax] if abs(d[ax]) > 1e-6 else 0.0; t1 = (zf1 - p[ax])/d[ax] if abs(d[ax]) > 1e-6 else 0.0
            n0, n1 = p + t0*d, p + t1*d; Lw = np.linalg.norm(n1 - n0)
            if Lw < 1e-6: continue
            kk = k.copy()*(L/Lw)          # crude length scaling of the axial/torsion terms; bending rescaled below
            R = rot_to(n1 - n0); T = np.zeros((12, 12)); T[:3, :3] = T[3:6, 3:6] = T[6:9, 6:9] = T[9:, 9:] = R.T
            kg = T.T @ kk @ T
            M0, M1 = rigid_map(n0 - centres[i]), rigid_map(n1 - centres[i+1])
            Tb = np.zeros((12, 12)); Tb[:6, :6] = M0; Tb[6:, 6:] = M1
            kb = Tb.T @ kg @ Tb
            idx = list(range(6*i, 6*i+6)) + list(range(6*(i+1), 6*(i+1)+6))
            K[np.ix_(idx, idx)] += kb
    # fix the bottom layer, condense to the top layer
    free = list(range(6, 6*nL)); Kff = K[np.ix_(free, free)]
    top = list(range(6*(nL-1) - 6, 6*(nL-1)))      # indices of the top layer within `free`
    others = [i for i in range(len(free)) if i not in top]
    Ktt = Kff[np.ix_(top, top)] - Kff[np.ix_(top, others)] @ np.linalg.solve(Kff[np.ix_(others, others)], Kff[np.ix_(others, top)])
    Ktt = 0.5*(Ktt + Ktt.T)
    # normalise translational and rotational DOF by the block size so the eigen-ratio is scale-free
    Ls = float(np.max(block["L"])); Sc = np.diag([1, 1, 1, 1/Ls, 1/Ls, 1/Ls]); Kn = Sc @ Ktt @ Sc
    vals, vecs = np.linalg.eigh(Kn)
    return dict(K=Ktt, eigvals=vals, eigvecs=vecs, ratio=float(vals[-1]/max(vals[0], 1e-30)), softest=vecs[:, 0], centre=centres[-1])
if __name__ == "__main__":
    print("\n--- Supplementary-rule check: minimal 5-wire 1R cells (paper's tool), 5x5x5, plus frame FE ---")
    cell = 25.4; gap = 0.35*cell; axis_p, axis_d = [0, 0, 0], [0, 1, 0]
    blkw = dcm_block((5, 5, 5), cell, stack_axis=0, n_layers=5, element_fn=lambda c, h: elements_1R_wires(axis_p, axis_d, c, h, gap))
    check_block(blkw, [rot_twist(axis_p, axis_d)], "Example 2 with 5 wires per cell")
    fe = frame_fe(blkw, E=114e3, G=44e3, wire_d=1.5, gap=gap)      # Ti-6Al-4V, N/mm2
    ev = fe["eigvals"]; print("FE eigen-stiffnesses (normalised), softest -> stiffest:", np.round(ev, 3))
    print("compliant/stiff ratio:", f"{1/fe['ratio']:.2e}", "| softest direction (u_xyz, theta_xyz*L):", np.round(fe["softest"], 3), "-> expect a pure rotation about y (theta_y dominant)")

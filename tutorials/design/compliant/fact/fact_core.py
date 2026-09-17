"""FACT (Freedom and Constraint Topologies) core in screw algebra.

Twists T = [w; v] (rotation axis direction w, v = r x w for a line
through r; a pure translation is [0; d]).  Wrenches W = [f; tau]
(a wire flexure along f through p is the pure-force constraint line
[f; p x f]).  The reciprocal product T o W = w.tau + v.f is zero when
the constraint does not resist the motion.  For a desired freedom
space spanned by k twists, the constraint space is its 6-k dimensional
reciprocal complement; a flexure system that spans that constraint
space with 6-k independent constraint lines gives EXACTLY the desired
degrees of freedom (Hopkins, Handbook ch. 6; Hopkins & Culpepper,
Precision Engineering 2010).  This module computes constraint spaces,
tests candidate wire/blade arrangements for exactness, and reports
what a candidate actually constrains."""
import numpy as np
def rot_twist(point, axis):
    w = np.asarray(axis, float); w = w/np.linalg.norm(w); r = np.asarray(point, float)
    return np.concatenate([w, np.cross(r, w)])
def trans_twist(direction):
    d = np.asarray(direction, float); return np.concatenate([np.zeros(3), d/np.linalg.norm(d)])
def wire(point, direction):
    """constraint line (pure force) of an ideal wire flexure through `point` along `direction`"""
    f = np.asarray(direction, float); f = f/np.linalg.norm(f); p = np.asarray(point, float)
    return np.concatenate([f, np.cross(p, f)])
def blade(point, normal, u):
    """a blade flexure = a plane of constraint lines: three independent wires in the plane
    (point, normal); `u` is any in-plane direction. Returns 3 wrenches spanning the plane's line space."""
    n = np.asarray(normal, float); n = n/np.linalg.norm(n); u = np.asarray(u, float); u = u - n*(u@n); u = u/np.linalg.norm(u)
    v = np.cross(n, u); p = np.asarray(point, float)
    return [wire(p, u), wire(p, v), wire(p + 50*u, v)]        # two concurrent + one offset: rank 3
def recip(T, W):
    return T[:3]@W[3:] + T[3:]@W[:3]
def constraint_space(freedoms):
    """orthonormal basis (in the reciprocal sense) of all wrenches reciprocal to the freedom twists"""
    F = np.atleast_2d(np.array(freedoms, float))
    # T o W = [w v].[tau f] = (T @ P) . W with P swapping halves
    P = np.block([[np.zeros((3, 3)), np.eye(3)], [np.eye(3), np.zeros((3, 3))]])
    A = F @ P
    u, s, vt = np.linalg.svd(A); rank = int((s > 1e-9).sum())
    return vt[rank:].T                                        # columns: basis of the constraint space (6 - k dims)
def analyse(freedoms, constraints, label):
    F = np.atleast_2d(np.array(freedoms, float)); C = np.array(constraints, float)
    k = np.linalg.matrix_rank(F); m = np.linalg.matrix_rank(C)
    P = np.block([[np.zeros((3, 3)), np.eye(3)], [np.eye(3), np.zeros((3, 3))]])
    # freedoms actually left by the constraints = null space of C P
    u, s, vt = np.linalg.svd(C @ P); r = int((s > 1e-9).sum()); left = vt[r:]
    # do the desired freedoms survive?  each desired twist must be reciprocal to every constraint
    ok = np.allclose(F @ P @ C.T, 0, atol=1e-9)
    print(f"[{label}] desired DOF {k}; constraints given {len(C)}, independent {m}; DOF left {6 - m}; desired freedoms preserved: {ok}")
    if 6 - m != k or not ok:
        print("   -> NOT exact:", "over-constrained (desired motion resisted)" if not ok else f"under-constrained by {6 - m - k}")
    return left
def describe(left):
    """name the surviving twists: pure rotation (axis point, direction), translation, or screw"""
    out = []
    for T in np.atleast_2d(left):
        w, v = T[:3], T[3:]
        if np.linalg.norm(w) < 1e-9:
            out.append(f"translation along {np.round(v/np.linalg.norm(v), 3)}")
        else:
            w_ = w/np.linalg.norm(w); pitch = (w_@v)/np.linalg.norm(w); r0 = np.cross(w_, v)/np.linalg.norm(w)
            out.append(f"rotation about axis through {np.round(r0, 1)} along {np.round(w_, 3)}" + (f" (screw, pitch {pitch:.3g})" if abs(pitch) > 1e-6 else ""))
    return out
if __name__ == "__main__":
    print("self-test: a cross-axis pivot = two blades whose planes contain the axis -> exactly 1 rotation about it")
    axis_pt, axis_dir = [0, 0, 0], [0, 1, 0]
    C = blade([0, 0, 0], [1, 0, 1], [0, 1, 0]) + blade([0, 0, 0], [1, 0, -1], [0, 1, 0])
    left = analyse([rot_twist(axis_pt, axis_dir)], C, "cross-axis pivot"); print("   left:", describe(left))
    print("self-test: three parallel wires normal to a plate -> constrain piston/tip/tilt, leave x, y, theta_z")
    C = [wire([100, 0, 0], [0, 0, 1]), wire([-50, 87, 0], [0, 0, 1]), wire([-50, -87, 0], [0, 0, 1])]
    left = analyse([trans_twist([1, 0, 0]), trans_twist([0, 1, 0]), rot_twist([0, 0, 0], [0, 0, 1])], C, "3 normal wires"); print("   left:", describe(left))
    print("self-test: three in-plane wires -> leave exactly tip, tilt, piston")
    C = [wire([100, 0, 0], [0, 1, 0]), wire([-50, 87, 0], [-0.87, -0.5, 0]), wire([-50, -87, 0], [0.87, -0.5, 0])]
    left = analyse([rot_twist([0, 0, 0], [1, 0, 0]), rot_twist([0, 0, 0], [0, 1, 0]), trans_twist([0, 0, 1])], C, "3 in-plane wires"); print("   left:", describe(left))

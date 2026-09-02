"""Co-activation nerve of the belt: a behavioral topology invariant.

Manin-Marcolli build homotopy types from nerves of activity covers
(their 5.5/7). The tandoor version: over a rollout, bin k's cover
set U_k = {time windows in which bin k holds dough}; the nerve has a
face for every set of bins simultaneously in service in some window.
Its F2 Betti numbers measure the policy's coordination structure -
sequential one-bin cooking gives dust (beta0 high), pipelined
multi-bin cooking gives high-dimensional simplices, and cycles
(beta1) mean rotating service patterns. Invisible to rotis counts.

Self-test: python tandoor_nerve.py
"""
import numpy as np


def gf2_rank(M):
    if M.size == 0:
        return 0
    M = (M.astype(np.uint8) & 1).copy()
    r = 0
    rows, cols = M.shape
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if M[i, c]:
                piv = i
                break
        if piv is None:
            continue
        M[[r, piv]] = M[[piv, r]]
        mask = M[:, c].copy()
        mask[r] = 0
        M[mask == 1] ^= M[r]
        r += 1
        if r == rows:
            break
    return r


def betti(maximal_faces):
    """F2 Betti numbers of the downward closure of maximal_faces
    (iterables of hashable vertices)."""
    faces = set()
    from itertools import combinations
    for mf in maximal_faces:
        mf = tuple(sorted(set(mf)))
        for k in range(1, len(mf) + 1):
            for c in combinations(mf, k):
                faces.add(frozenset(c))
    if not faces:
        return [0]
    dim = max(len(f) for f in faces) - 1
    by_dim = [sorted((f for f in faces if len(f) == k + 1),
                     key=sorted) for k in range(dim + 1)]
    idx = [{f: i for i, f in enumerate(fs)} for fs in by_dim]
    ranks = []
    for k in range(1, dim + 1):
        M = np.zeros((len(by_dim[k - 1]), len(by_dim[k])),
                     dtype=np.uint8)
        for j, f in enumerate(by_dim[k]):
            for v in f:
                M[idx[k - 1][f - {v}], j] = 1
        ranks.append(gf2_rank(M))
    b = []
    for k in range(dim + 1):
        n_k = len(by_dim[k])
        rk = ranks[k - 1] if k >= 1 else 0
        rk1 = ranks[k] if k < dim else 0
        b.append(n_k - rk - rk1)
    while len(b) > 1 and b[-1] == 0:
        b.pop()
    return b


def nerve_faces(act, window, stride=None):
    """act: (T, n) bool activity. Returns the maximal window-faces
    of the co-activation nerve."""
    T = act.shape[0]
    stride = stride or max(window // 2, 1)
    faces = []
    for w0 in range(0, max(T - window, 0) + 1, stride):
        s = np.nonzero(act[w0:w0 + window].any(0))[0]
        if len(s):
            faces.append(tuple(s))
    return faces


def nerve_betti(act, window, stride=None):
    return betti(nerve_faces(act, window, stride))


if __name__ == "__main__":
    # circle: boundary of a triangle
    assert betti([(0, 1), (1, 2), (0, 2)]) == [1, 1]
    # 2-sphere: boundary faces of the 3-simplex
    assert betti([(0, 1, 2), (0, 1, 3), (0, 2, 3), (1, 2, 3)]) \
        == [1, 0, 1]
    # two components
    assert betti([(0, 1), (2, 3)]) == [2]
    # filled triangle: contractible
    assert betti([(0, 1, 2)]) == [1]
    # nerve of a rotating 2-bin service around a ring of 4. The
    # window is the scale parameter: segment-aligned windows see
    # only the pairs (a 4-cycle); windows spanning transitions see
    # triples, and four triples on four vertices is the boundary of
    # the 3-simplex - an honest S2. Both are correct topology of
    # their scale.
    act = np.zeros((40, 4), dtype=bool)
    for t in range(40):
        act[t, (t // 5) % 4] = True
        act[t, ((t // 5) + 1) % 4] = True
    assert nerve_betti(act, 5, stride=5) == [1, 1]
    assert nerve_betti(act, 6, stride=3) == [1, 0, 1]
    print("nerve/homology self-test: PASS "
          "(circle, sphere, components, disk, rotating service "
          "at two scales)")

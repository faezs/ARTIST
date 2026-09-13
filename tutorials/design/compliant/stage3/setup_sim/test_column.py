"""Minimal check: one inflated column (pinned base, volume constraint, tension-only walls, LRA) carrying a payload, growing from 1.05 to 4.5 m."""
import numpy as np, warp as wp, sys
wp.config.quiet = True; wp.init(); DEV = "cpu"
R, L, N_C, N_A, STUB, KE, PAY = 0.6, 4.52, 12, 14, 1.05, 4e5, float(sys.argv[1]) if len(sys.argv) > 1 else 50.0
P, M, S = [], [], []
def add(p, m): P.append(np.asarray(p, float)); M.append(m); return len(P) - 1
def spring(i, j, kind, ke): S.append((i, j, kind, ke))
th = 2*np.pi*np.arange(N_C)/N_C; rings = np.zeros((N_A + 1, N_C), int)
for j in range(N_A + 1):
    for i in range(N_C): rings[j, i] = add([R*np.cos(th[i]), R*np.sin(th[i]), STUB*j/N_A], 0.0 if j == 0 else (1.0 if j == N_A else 0.15))
cap = add([0, 0, STUB], 20.0); bc = add([0, 0, 0], 0.0); OFF = float(sys.argv[2]) if len(sys.argv) > 2 else 0.0
pay = add([OFF, 0, STUB + 0.35], PAY)
for j in range(N_A + 1):
    for i in range(N_C):
        spring(rings[j, i], rings[j, (i + 1) % N_C], 1, KE)
        if j < N_A:
            spring(rings[j, i], rings[j + 1, i], 0, KE); spring(rings[j, i], rings[j + 1, (i + 1) % N_C], 0, KE); spring(rings[j, (i + 1) % N_C], rings[j + 1, i], 0, KE)
        if j >= 2: spring(rings[0, i], rings[j, i], 4, KE)
spring(bc, cap, 4, KE)
top = list(rings[N_A]) + [cap, pay]
for a in range(len(top)):
    for b in range(a + 1, len(top)): spring(top[a], top[b], 2, 4e6)
tris = []
for j in range(N_A):
    for i in range(N_C):
        a0, a1, b0, b1 = rings[j, i], rings[j, (i + 1) % N_C], rings[j + 1, i], rings[j + 1, (i + 1) % N_C]; tris += [[a0, a1, b1], [a0, b1, b0]]
for i in range(N_C): tris.append([rings[N_A, i], rings[N_A, (i + 1) % N_C], cap])
for i in range(N_C): tris.append([rings[0, (i + 1) % N_C], rings[0, i], bc])
X0 = np.array(P); n = len(P); inv_m = np.array([0.0 if m == 0 else 1.0/m for m in M])
S = np.array(S, float); idx = S[:, :2].astype(np.int32); kind = S[:, 2].astype(int); ke_s = S[:, 3]; n_spr = len(S)
nom0 = np.linalg.norm(X0[idx[:, 0]] - X0[idx[:, 1]], axis=1); uni = ((kind == 0) | (kind == 1) | (kind == 4)).astype(np.int32)
col = -np.ones(n_spr, int); used = [set() for _ in range(n)]
for s_ in np.argsort(-ke_s, kind="stable"):
    i_, j_ = idx[s_]; c = 0
    while c in used[i_] or c in used[j_]: c += 1
    col[s_] = c; used[i_].add(c); used[j_].add(c)
cols = [np.where(col == c)[0].astype(np.int32) for c in range(col.max() + 1)]
tris = np.array(tris, np.int32); V0 = np.sum([np.dot(np.cross(X0[a], X0[b]), X0[c]) for a, b, c in tris])/6
print("initial volume", round(V0, 3), "expected", round(0.5*N_C*R*R*np.sin(2*np.pi/N_C)*STUB, 3), "colours", len(cols))
def wa(a, dt): return wp.array(a, dtype=dt, device=DEV)
x = wa(X0.astype(np.float32), wp.vec3); v = wa(np.zeros((n, 3), np.float32), wp.vec3); xp = wa(X0.astype(np.float32), wp.vec3); w = wa(inv_m.astype(np.float32), float)
sidx = wa(idx.reshape(-1), wp.int32); rest = wa(nom0.astype(np.float32), float); kew = wa(ke_s.astype(np.float32), float); lam = wa(np.zeros(n_spr, np.float32), float); uniw = wa(uni, wp.int32)
triw = wa(tris.reshape(-1), wp.int32); grad = wa(np.zeros((n, 3), np.float32), wp.vec3); vol = wa(np.zeros(1, np.float32), float); vden = wa(np.zeros(1, np.float32), float); vtar = wa(np.zeros(1, np.float32), float); vlam = wa(np.zeros(1, np.float32), float)
colw = [wa(c, wp.int32) for c in cols]; tot = wa(np.zeros(len(tris), np.int32), wp.int32); top_ = wa(np.zeros(n, np.int32), wp.int32)
@wp.kernel
def predict(x: wp.array(dtype=wp.vec3), v: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), g: wp.vec3, dt: float, damp: float, xp: wp.array(dtype=wp.vec3)):
    i = wp.tid()
    if w[i] == 0.0:
        xp[i] = x[i]; return
    vi = (v[i] + g*dt)*damp; v[i] = vi; xp[i] = x[i] + vi*dt
@wp.kernel
def springs(ids: wp.array(dtype=wp.int32), xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), idx: wp.array(dtype=wp.int32), rest: wp.array(dtype=float), ke: wp.array(dtype=float), uni: wp.array(dtype=wp.int32), lam: wp.array(dtype=float), dt: float):
    s = ids[wp.tid()]; i = idx[2*s]; j = idx[2*s + 1]; d = xp[i] - xp[j]; L = wp.length(d)
    if L < 1e-9: return
    c = L - rest[s]
    if uni[s] == 1 and c < 0.0:
        lam[s] = 0.0; return
    nrm = d/L; wi = w[i]; wj = w[j]; den = wi + wj
    if den == 0.0: return
    alpha = 1.0/(ke[s]*dt*dt); dl = -(c + alpha*lam[s])/(den + alpha); lam[s] = lam[s] + dl
    if wi > 0.0: xp[i] = xp[i] + nrm*(wi*dl)
    if wj > 0.0: xp[j] = xp[j] - nrm*(wj*dl)
@wp.kernel
def vol_grad(xp: wp.array(dtype=wp.vec3), tri: wp.array(dtype=wp.int32), grad: wp.array(dtype=wp.vec3), vol: wp.array(dtype=float)):
    t = wp.tid(); i = tri[3*t]; j = tri[3*t + 1]; k = tri[3*t + 2]; xi = xp[i]; xj = xp[j]; xk = xp[k]
    wp.atomic_add(vol, 0, wp.dot(wp.cross(xi, xj), xk)/6.0)
    wp.atomic_add(grad, i, wp.cross(xj, xk)/6.0); wp.atomic_add(grad, j, wp.cross(xk, xi)/6.0); wp.atomic_add(grad, k, wp.cross(xi, xj)/6.0)
@wp.kernel
def vol_denom(w: wp.array(dtype=float), grad: wp.array(dtype=wp.vec3), den: wp.array(dtype=float)):
    i = wp.tid(); g = grad[i]; wp.atomic_add(den, 0, w[i]*wp.dot(g, g))
@wp.kernel
def vol_apply(xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), grad: wp.array(dtype=wp.vec3), vol: wp.array(dtype=float), vtar: wp.array(dtype=float), den: wp.array(dtype=float)):
    i = wp.tid()
    if den[0] <= 0.0: return
    dl = -(vol[0] - vtar[0])/den[0]
    if w[i] > 0.0: xp[i] = xp[i] + grad[i]*(w[i]*dl)
    grad[i] = wp.vec3(0.0)
@wp.kernel
def ground(xp: wp.array(dtype=wp.vec3), r: float):
    i = wp.tid(); q = xp[i]
    if q[2] < r: xp[i] = wp.vec3(q[0], q[1], r)
@wp.kernel
def finish(x: wp.array(dtype=wp.vec3), xp: wp.array(dtype=wp.vec3), w: wp.array(dtype=float), dt: float, v: wp.array(dtype=wp.vec3)):
    i = wp.tid()
    if w[i] == 0.0: return
    v[i] = (xp[i] - x[i])/dt; x[i] = xp[i]
FPS, SUB, IT = 30, 12, 12; dt = 1.0/FPS/SUB; damp = float(np.exp(-4*dt)); G = wp.vec3(0.0, 0.0, -9.81)
EPS = 0.02; dz0 = STUB/N_A; dc = 2*np.pi*R/N_C
ax_m = (kind == 0) & (np.abs(nom0 - dz0) < 1e-6); dg_m = (kind == 0) & ~ax_m; lra = kind == 4
for fr in range(int(14*FPS) + 1):
    t = fr/FPS; g = STUB/L + (1 - STUB/L)*min(1.0, max(0.0, (t - 2)/10))
    nom = nom0.copy(); nom[ax_m] = g*L/N_A; nom[dg_m] = np.hypot(dc, g*L/N_A); nom[lra] = nom0[lra]*(g*L/N_A/dz0); rest.assign(nom.astype(np.float32))
    vtar.assign(np.array([0.5*N_C*R*R*np.sin(2*np.pi/N_C)*g*L*(1 + EPS)], np.float32))
    for k in range(SUB):
        lam.zero_(); wp.launch(predict, dim=n, inputs=[x, v, w, G, dt, damp, xp], device=DEV)
        for it in range(IT):
            for cw in colw: wp.launch(springs, dim=len(cw), inputs=[cw, xp, w, sidx, rest, kew, uniw, lam, dt], device=DEV)
            vol.zero_(); vden.zero_(); wp.launch(vol_grad, dim=len(tris), inputs=[xp, triw, grad, vol], device=DEV); wp.launch(vol_denom, dim=n, inputs=[w, grad, vden], device=DEV)
            wp.launch(vol_apply, dim=n, inputs=[xp, w, grad, vol, vtar, vden], device=DEV); wp.launch(ground, dim=n, inputs=[xp, 0.05], device=DEV)
        wp.launch(finish, dim=n, inputs=[x, xp, w, dt, v], device=DEV)
    if fr % (FPS*2) == 0:
        q = x.numpy(); zr = q[rings][:, :, 2].mean(1); rr = np.linalg.norm(q[rings][:, :, :2] - q[rings][:, :, :2].mean(1, keepdims=True), axis=2).mean(1)
        Vn = np.sum([np.dot(np.cross(q[a], q[b]), q[c]) for a, b, c in tris])/6
        print(f"t {t:4.1f} g {g:.2f} target L {g*L:.2f} cap {q[cap].round(2)} pay {q[pay].round(2)}  V {Vn:.3f} / {float(vtar.numpy()[0]):.3f}  ring z " + " ".join(f"{z:.2f}" for z in zr[::3]) + " r " + " ".join(f"{r:.3f}" for r in rr[::4]))

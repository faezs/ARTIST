"""THE RELAY AT F2, DOWN THE AXIS: the deep dish (formed paraboloid f 1.05, F in the rim plane) with the Gregorian cap d
beyond F imaging onto F2 on the dish's own axis behind the vertex, then the fourth pass's folds (stage3/coude): M3 at the
neck NECK m behind the vertex, an ellipsoidal fold turning the beam 90 deg along the neck axis (the elevation axis) and
relaying F2 to F3 inside the hollow cartwheel pivot (bore r 0.30 m, 0.4-1.0 m from the stalk); the beam along the neck
axis to M4 at the stalk OFF m to one side, an ellipsoidal fold turning it down the stalk (the azimuth axis, a 1.0 m tube
of r 0.46 from the deck to the yoke) and relaying F3 to F2c on the built bore's axis; then the built chain unchanged:
the tri machine's actuated mirror at the turn P4 (the kernel's M4, an ellipsoid with foci F2c and the bread), the way
to the duct plane and the inlet collar r 0.55. Both folds sit at 45 deg at every elevation: the head turns about the
neck axis, so the dish axis and the neck axis stay perpendicular; the neck axis is horizontal and turns with the yoke.

The cap is held by three blades in the rim plane (F's plane), 4 mm thick and 50 mm tall, from the rim ring to the cap's
edge: the converging beam lies wholly below that plane, the return beam wholly inside the cap's radius, so the blades
cross no light and shade 3 x 1.8 m x 4 mm on the sun leg. A style from the hole (the fourth pass's) does not work for
a Gregorian: the return beam is wide where the hole's dark cone is narrow.

The tracer is a torch twin of the kernel's ray model (the same 512-point grid, the same fixed sun offset th_sun(0.5),
the same per-ray Gaussian deviation sigb on the incident ray, the same ellipsoid/collar tests), and it is VALIDATED
against the kernel on the vertical-bore deep configuration (deep_greg_d.py's d 0.15) with the same noise draws before
the relay is put in. Nothing in the flower's configs is touched.
run:  cd ~/ARTIST-compliant/tutorials && PYTHONPATH=.. /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python design/compliant/stage3/deep/deep_relay.py"""
import os, sys, numpy as np, torch
sys.argv = [sys.argv[0]]
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "deep_greg.py")).read().split("results = {}")[0])
from tandoor_mount_batch import _align_batch
import tandoor_hashemi_env as HE
DT = torch.float64                          # the twin traces in double; the env keeps its own dtype
HERE = os.path.dirname(os.path.abspath(__file__))
SIGB = float(os.environ.get("SIGB", "0.0043"))

# ---------------------------------------------------------------------------------------------------------------- the machine
F_DISH, A_DISH = 1.05, 2.1
NECK, OFF = 1.8, 1.4                       # the fourth pass: M3 behind the vertex, the stalk beside the dish axis
R_PIV, PIV_LO, PIV_HI = 0.30, 0.40, 1.00   # the hollow pivot's bore and its extent from the stalk along the neck axis
R_STALK, L_STALK = 0.46, 1.3               # the stalk tube (inner radius) from the deck to the yoke: 1.3 m here, not the fourth pass's 1.0,
                                           # so the deep head's rim clears the deck by 0.3 m at el 12 (its rim is 1.05 m ahead of the vertex)
Z_YOKE_OFF = 0.45                          # M4 (the neck axis) this far above the yoke's slew ring
VANE_T, VANE_H, N_VANE = 0.004, 0.05, 3    # the cap's blades in the rim plane
CODES_R = {0: "through", 11: "cap shade", 12: "hole", 15: "blade", 2: "no cap", 5: "film", 21: "M3", 22: "pivot", 23: "M4", 24: "stalk",
           6: "deck", 7: "turn M", 8: "way", 9: "collar"}


def reflect(d, n):
    return d - 2.0*(d*n).sum(-1, keepdim=True)*n


def ellip_hit(p, d, O, A, a, c, after=None, far=True):
    """ray p + t d against the ellipsoid of revolution (centre O, unit axis A, semi-major a, focal half-distance c): the far
    positive root (the mirror patch on the wall beyond the near focus) or, with `after`, the first root beyond that t (the
    cap: the first crossing after the ray passes F). Returns t, the hit, the normal against d, valid."""
    w = p - O; z0 = (w*A).sum(-1); dz = (d*A).sum(-1); wd = (w*d).sum(-1); ww = (w*w).sum(-1)
    a2, c2 = a*a, c*c; b2 = a2 - c2
    qa = a2 - c2*dz*dz; qb = 2.0*(a2*wd - c2*z0*dz); qc = a2*ww - c2*z0*z0 - a2*b2
    disc = qb*qb - 4.0*qa*qc; sq = torch.sqrt(disc.clamp(min=0.0)); qas = torch.where(qa.abs() > 1e-12, qa, torch.full_like(qa, 1e-12))
    t1 = (-qb - sq)/(2.0*qas); t2 = (-qb + sq)/(2.0*qas)
    if after is None:
        t = torch.maximum(t1, t2); valid = (disc >= 0) & (t > 1e-6)
    else:
        big = torch.full_like(t1, 1e9); t1 = torch.where(t1 > after, t1, big); t2 = torch.where(t2 > after, t2, big)
        t = torch.minimum(t1, t2); valid = (disc >= 0) & (t < 1e8)
    X = p + t[..., None]*d; wX = X - O; zz = (wX*A).sum(-1, keepdim=True)
    n = a2*wX - c2*zz*A; n = n/n.norm(dim=-1, keepdim=True).clamp(min=1e-12)
    n = torch.where((n*d).sum(-1, keepdim=True) > 0, -n, n)
    return t, X, n, valid


def ellipsoid(Fa, Fb, through):
    """the ellipsoid with foci Fa, Fb through the point `through`: centre, axis, a, c"""
    O = 0.5*(Fa + Fb); c = 0.5*float(np.linalg.norm(Fb - Fa)); A = (Fb - Fa)/(2*c)
    a = 0.5*(float(np.linalg.norm(through - Fa)) + float(np.linalg.norm(through - Fb)))
    return torch.as_tensor(O), torch.as_tensor(A), a, c


def t3(x):
    return torch.as_tensor(np.asarray(x, dtype=np.float64))


class Rays:
    """the kernel's ray model on the formed paraboloid: the 512-point grid at every level (the study's formed film), K noise
    draws per point, the incident ray = the canonical sun ray turned by (e, u) = (-th_sun(0.5) + de sigb, du sigb) in the
    Acan frame, reflected off the paraboloid normal. All in the dish frame (axis +z toward the sun); moved out with R, C."""
    def __init__(self, drv, K, seed=0):
        L, P, _ = drv._pts_l.shape
        xy = drv._pts_l[L//2, :, :2].detach().cpu().to(DT)
        w = drv._ray_pw.reshape(-1)[:P].detach().cpu().to(DT); self.w = (w/w.sum()).repeat(K)/K        # (K*P,), sums to one
        self.xy = xy.repeat(K, 1); self.K, self.P = K, P
        rho2 = (self.xy**2).sum(-1); z = rho2/(4*F_DISH)
        self.p_loc = torch.cat([self.xy, z[:, None]], 1)
        n = torch.stack([-self.xy[:, 0]/(2*F_DISH), -self.xy[:, 1]/(2*F_DISH), torch.ones_like(z)], 1); self.n_loc = n/n.norm(dim=-1, keepdim=True)
        self.rho = torch.sqrt(rho2)
        g = torch.Generator(device="cpu").manual_seed(seed)
        self.du = torch.randn(K, P, generator=g).to(DT); self.de = torch.randn(K, P, generator=g).to(DT)
        self.us = torch.rand(K, P, generator=g).to(DT); self.upick = torch.rand(K, P, generator=g).to(DT)      # the sun's disc, when asked for
        self.th_sun = float(drv._sun_table[32]); self.table = torch.as_tensor(np.asarray(drv._sun_table, dtype=np.float64))

    def directions(self, sigb, minus_sun_local=None, disc=False):
        """the reflected directions in the dish frame; minus_sun_local = the incident sun ray in the dish frame ((0,0,-1)
        when the head points at the sun exactly - the kernel's Acan takes the canonical ray (0,1,0) onto it). disc=False is
        the kernel as the fast env runs it (us = upick = 0.5: every ray offset by the sun table's median radius, 3.2 mrad,
        in one direction - a fixed pointing offset, NOT the sun's disc); disc=True samples the limb-darkened 4.65 mrad
        disc through the same table, the honest beam for a machine that magnifies it twentyfold."""
        if disc:
            tq = self.us.reshape(-1)*64.0; ti = tq.long().clamp(max=63); tf = tq - ti.to(DT)
            th = self.table[ti]*(1 - tf) + self.table[ti + 1]*tf; psi = 2*np.pi*self.upick.reshape(-1)
            e = th*torch.cos(psi) + self.de.reshape(-1)*sigb; u = th*torch.sin(psi) + self.du.reshape(-1)*sigb
        else:
            e = -self.th_sun + self.de.reshape(-1)*sigb; u = self.du.reshape(-1)*sigb
        v = torch.stack([-torch.sin(u), torch.cos(e)*torch.cos(u), torch.sin(e)*torch.cos(u)], 1)          # rotate_distortions on (0,1,0)
        yh = torch.tensor([0.0, 1.0, 0.0], dtype=DT); mz = torch.tensor([[0.0, 0.0, -1.0]], dtype=DT) if minus_sun_local is None else minus_sun_local.reshape(1, 3)
        Acan = _align_batch(yh, mz)[0]                                                                          # canonical sun ray -> -z
        inc = v @ Acan.T
        return reflect(inc, self.n_loc)


def film_cross(p_loc, d_loc, rho_lo, r_hole):
    """the ray (dish frame) meets the paraboloid x^2 + y^2 = 4 f z at r_hole < r < a beyond t = 1e-3 (the kernel's crossing test)"""
    qa = d_loc[:, 0]**2 + d_loc[:, 1]**2; qb = 2.0*(p_loc[:, 0]*d_loc[:, 0] + p_loc[:, 1]*d_loc[:, 1]) - 4.0*F_DISH*d_loc[:, 2]
    qc = p_loc[:, 0]**2 + p_loc[:, 1]**2 - 4.0*F_DISH*p_loc[:, 2]
    disc = qb*qb - 4.0*qa*qc; sq = torch.sqrt(disc.clamp(min=0.0)); qas = torch.where(qa.abs() > 1e-12, qa, torch.full_like(qa, 1e-12))
    hit = torch.zeros_like(qa, dtype=torch.bool)
    for t in ((-qb - sq)/(2.0*qas), (-qb + sq)/(2.0*qas)):
        X = p_loc + t[:, None]*d_loc; rr = torch.sqrt(X[:, 0]**2 + X[:, 1]**2)
        hit = hit | ((disc >= 0) & (t > 1e-3) & (rr < A_DISH) & (rr > r_hole))
    return hit


def blocked(p, ut, centre, rad):
    vc = centre - p; ahead = (vc*ut).sum(-1) > 0; perp = vc - (vc*ut).sum(-1, keepdim=True)*ut
    return ahead & (perp.norm(dim=-1) < rad)


def below_chain(h, d, F2c, F4, P4, r_m4, r_pot, z_duct, r_duct, ledger, code, extra=None, w=None):
    """the built chain from the beam's arrival on the bore axis: the tri machine's mirror at the turn P4 (ellipsoid, foci
    F2c and the bread F4, aperture r_m4 about P4), the way to the duct plane x = r_pot, the collar r_duct about the mouth"""
    Ou, Au, au, cu = ellipsoid(F2c, F4, P4)
    t4, h4, n4, v4 = ellip_hit(h, d, Ou, Au, au, cu)
    okM = v4 & ((h4 - t3(P4)).norm(dim=-1) < r_m4); ledger(~okM, 7)
    d5 = reflect(d, n4)
    t5 = (r_pot - h4[:, 0])/d5[:, 0].clamp(max=-1e-9)
    okW = (d5[:, 0] < -0.05) & (t5 < 4.0); ledger(okM & ~okW, 8)
    h5 = h4 + t5.clamp(max=4.0)[:, None]*d5
    okC = (h5[:, 1]**2 + (h5[:, 2] - z_duct)**2) <= r_duct**2; ledger(okM & okW & ~okC, 9)
    thr = okM & okW & okC
    if extra is not None:
        # the spot: rms radius of the through rays at the collar plane and at the bread's plane (through F4, normal to the
        # turn-to-bread direction) - the built machine's collar-plane spot comes from the kernel's out6 the same way
        Ao = t3(F4) - t3(P4); Ao = Ao/Ao.norm(); tb = ((t3(F4)[None] - h4)*Ao).sum(-1)/(d5*Ao).sum(-1); Xb = h4 + tb[:, None]*d5 - t3(F4)[None]
        Xb = Xb - (Xb*Ao).sum(-1, keepdim=True)*Ao
        ww = w if w is not None else torch.ones_like(t5)
        extra["spot_collar"] = float(torch.sqrt((ww*(h5[:, 1]**2 + (h5[:, 2] - z_duct)**2))[thr].sum()/ww[thr].sum().clamp(min=1e-12)))
        extra["spot_bread"] = float(torch.sqrt((ww*(Xb*Xb).sum(-1))[thr].sum()/ww[thr].sum().clamp(min=1e-12)))
    return thr


class Ledger:
    def __init__(self, n):
        self.code = torch.zeros(n, dtype=DT)
    def __call__(self, mask, c):
        self.code = torch.where(mask & (self.code == 0), torch.full_like(self.code, float(c)), self.code)
    def table(self, w, codes):
        return {codes[k]: float((w*(self.code == k)).sum()) for k in codes}


def trace_bore(rays, sigb, sun, F, P4, F4, d_cap, r_cap, two_c, r_hole, r_bore, z_deck, r_m4, r_pot, z_duct, r_duct, R=None, C=None):
    """the kernel's deep vertical-bore configuration (the validation twin): the dish on the orbit f about the fixed F pointing
    at the sun, the cap's ellipsoid about the VERTICAL F-F2 axis (F2 on the bore axis 2c below F), the shadow sphere at
    F + d along the dish axis, the bore gate at the deck, the turn mirror, the way, the collar"""
    s = t3(sun); Fw = t3(F)
    if R is None: R = _align_batch(torch.tensor([0.0, 0.0, 1.0], dtype=DT), s[None])[0]
    if C is None: C = Fw - F_DISH*s
    n = rays.p_loc.shape[0]; led = Ledger(n); w = rays.w
    d_loc = rays.directions(sigb, minus_sun_local=-(R.T @ s)); p = rays.p_loc @ R.T + C; d = d_loc @ R.T
    Hc = Fw + d_cap*R[:, 2]                                                          # the shadow sphere on the DISH axis, as the kernel
    led(blocked(p, s[None], Hc[None], r_cap), 11)                                    # the cap's shadow, tested first as the kernel does
    led(~(rays.rho > r_hole), 12)
    F2 = F - np.array([0.0, 0.0, two_c]); Oc, Ac, ac, cc = ellipsoid(F, F2, F + np.array([0.0, 0.0, d_cap]))
    tF = ((Fw[None] - p)*d).sum(-1)
    t1, h1, nh, v1 = ellip_hit(p, d, Oc[None], Ac[None], ac, cc, after=tF); led(~v1, 2)
    d2 = reflect(d, nh)
    l0 = (h1 - C) @ R; dl = d2 @ R                                                   # into the dish frame for the crossing test
    led(film_cross(l0, dl, 0.0, r_hole), 5)
    axis = t3(P4) - Fw; axis = axis/axis.norm()
    tdeck = (z_deck - h1[:, 2])/d2[:, 2].clamp(max=-1e-9); hdeck = h1 + tdeck[:, None]*d2
    wv = hdeck - Fw; ad = (wv - (wv*axis).sum(-1, keepdim=True)*axis).norm(dim=-1)
    led(~((d2[:, 2] < -0.2) & (ad < r_bore)), 6)
    below_chain(h1, d2, F2, F4, P4, r_m4, r_pot, z_duct, r_duct, led, 7)
    return led.table(w, CODES), led


def trace_coude(rays, sigb, sun, stalk_xy, z_deck, P4, F4, two_c, d_cap, r_cap, r_hole, s1p, s2p, r_m3, r_m4c, r_m4, r_pot, z_duct, r_duct,
                neck=NECK, off=OFF, extra=None, disc=False):
    """the deep coude machine at one sun position: returns the ledger (weighted fractions) and the image radii at F2, F3, F2c"""
    s = t3(sun); zh = torch.tensor([0.0, 0.0, 1.0], dtype=DT)
    e = torch.linalg.cross(zh, s); e = e/e.norm()
    z_neck = z_deck + L_STALK + Z_YOKE_OFF
    Q = torch.tensor([stalk_xy[0], stalk_xy[1], z_neck], dtype=DT); N = Q + off*e; V = N + neck*s; Fw = V + F_DISH*s
    R = _align_batch(zh, s[None])[0]; C = V
    n = rays.p_loc.shape[0]; led = Ledger(n); w = rays.w
    d_loc = rays.directions(sigb, disc=disc); p = rays.p_loc @ R.T + C; d = d_loc @ R.T
    def rms(mask, r):
        return float(torch.sqrt((w*r*r)[mask].sum()/w[mask].sum().clamp(min=1e-12)))
    def img(h, dd, Fp, ax):
        tt = ((Fp[None] - h)*ax).sum(-1)/(dd*ax).sum(-1); X = h + tt[:, None]*dd - Fp[None]; X = X - (X*ax).sum(-1, keepdim=True)*ax
        return X.norm(dim=-1)
    # ---- the sun leg: the cap's shadow (inside the hole), the hole, the blades (their thickness along the sun)
    led(blocked(p, s[None], (Fw + d_cap*s)[None], r_cap), 11)
    led(~(rays.rho > r_hole), 12)
    ang = torch.atan2(rays.xy[:, 1], rays.xy[:, 0]); vane = torch.zeros(n, dtype=torch.bool)
    for k in range(N_VANE):
        ak = 2*np.pi*k/N_VANE; dist = (rays.xy[:, 0]*np.sin(ak) - rays.xy[:, 1]*np.cos(ak)).abs(); along = rays.xy[:, 0]*np.cos(ak) + rays.xy[:, 1]*np.sin(ak)
        vane = vane | ((dist < 0.5*VANE_T) & (along > r_cap) & (along < A_DISH))
    led(vane, 15)
    # ---- the cap: the ellipsoid with foci F and F2 on the dish axis, the first crossing after F
    F2 = Fw - two_c*s; Oc, Ac, ac, cc = ellipsoid(Fw.numpy(), F2.numpy(), (Fw + d_cap*s).numpy())
    tF = ((Fw[None] - p)*d).sum(-1)
    t1, h1, nh, v1 = ellip_hit(p, d, Oc[None], Ac[None], ac, cc, after=tF); led(~v1, 2)
    # the converging leg through the rim plane: a blade is a box r in [r_cap, a], z in [f, f + h], thickness t, in the dish frame
    l_p = rays.p_loc; l_d = d_loc
    for k in range(N_VANE):
        ak = 2*np.pi*k/N_VANE; nv = torch.tensor([np.sin(ak), -np.cos(ak), 0.0], dtype=DT); den = (l_d*nv).sum(-1)
        tv = -((l_p*nv).sum(-1))/torch.where(den.abs() > 1e-12, den, torch.full_like(den, 1e-12)); Xv = l_p + tv[:, None]*l_d
        alongv = Xv[:, 0]*np.cos(ak) + Xv[:, 1]*np.sin(ak)
        led((tv > 1e-6) & (tv < t1) & (alongv > r_cap) & (alongv < A_DISH) & (Xv[:, 2] > F_DISH) & (Xv[:, 2] < F_DISH + VANE_H), 15)
    d2 = reflect(d, nh)
    l0 = (h1 - C) @ R; dl = d2 @ R
    led(film_cross(l0, dl, 0.0, r_hole), 5)
    alive = led.code == 0
    if extra is not None: extra["r_F2"] = rms(alive, img(h1, d2, F2, -s))
    # ---- M3 at the neck: foci F2 and F3 = N - s1p e; the patch r_m3 about N
    F3 = N - s1p*e; O3, A3, a3, c3 = ellipsoid(F2.numpy(), F3.numpy(), N.numpy())
    t_3, h3, n3, v3 = ellip_hit(h1, d2, O3[None], A3[None], a3, c3)
    if extra is not None: extra["r_M3"] = rms(alive & v3, (h3 - N).norm(dim=-1))
    led(~(v3 & ((h3 - N).norm(dim=-1) < r_m3)), 21)
    d3 = reflect(d2, n3); alive = led.code == 0
    if extra is not None: extra["r_F3"] = rms(alive, img(h3, d3, F3, -e))
    # ---- the pivot's bore about the neck axis (through Q along e) between PIV_LO and PIV_HI from the stalk
    def rad_at(ecoord):
        tt = (ecoord - ((h3 - Q)*e).sum(-1))/(d3*e).sum(-1).clamp(max=-1e-9); X = h3 + tt[:, None]*d3
        wq = X - Q; return (wq - (wq*e).sum(-1, keepdim=True)*e).norm(dim=-1)
    if extra is not None: extra["r_piv"] = rms(alive, torch.maximum(rad_at(PIV_HI), rad_at(PIV_LO)))
    led(~((rad_at(PIV_HI) < R_PIV) & (rad_at(PIV_LO) < R_PIV) & ((d3*e).sum(-1) < 0)), 22)
    # ---- M4 at the stalk: foci F3 and F2c = Q - s2p z; the patch r_m4c about Q
    F2c = Q - s2p*zh; O4, A4, a4, c4 = ellipsoid(F3.numpy(), F2c.numpy(), Q.numpy())
    t_4, h4, n4, v4 = ellip_hit(h3, d3, O4[None], A4[None], a4, c4); alive = led.code == 0
    if extra is not None: extra["r_M4"] = rms(alive & v4, (h4 - Q).norm(dim=-1))
    led(~(v4 & ((h4 - Q).norm(dim=-1) < r_m4c)), 23)
    d4 = reflect(d3, n4); alive = led.code == 0
    if extra is not None: extra["r_F2c"] = rms(alive, img(h4, d4, F2c, -zh))
    # ---- the stalk: inside r_stalk of the vertical through Q at the yoke and at the deck, heading down
    def srad(zp):
        tt = (zp - h4[:, 2])/d4[:, 2].clamp(max=-1e-9); X = h4 + tt[:, None]*d4; return torch.hypot(X[:, 0] - Q[0], X[:, 1] - Q[1])
    if extra is not None: extra["r_deck"] = rms(alive, srad(z_deck))
    led(~((d4[:, 2] < -0.2) & (srad(z_neck - Z_YOKE_OFF) < R_STALK) & (srad(z_deck) < R_STALK)), 24)
    thr = below_chain(h4, d4, F2c.numpy(), F4, P4, r_m4, r_pot, z_duct, r_duct, led, 7, extra=extra, w=w)
    return led.table(w, CODES_R), led


def fmt(tab, keys):
    return " ".join(f"{100*tab.get(k, 0.0):7.1f}%" for k in keys)


if __name__ == "__main__":
    K = 128
    # ================================================================================= 1. validation against the kernel
    v, drv = build(); LFP = float(np.linalg.norm(np.asarray(drv.cs_P4) - np.asarray(drv.F_focus))); v.close()
    c = 1.5; d = 0.15; r_cap = (c + d)*(1 - (c/(c + d))**2)
    v, drv = build(sec_side="greg", d_strip=d, r_strip=float(r_cap), w_strip=50.0, strip_wk=0.0, strip_th_lo=0.0, strip_th_hi=180.0,
                   m4_mode="relay", u_f2=float(LFP - 2*c), w_slot=0.0, r_strut=0.0)
    rays = Rays(drv, K, seed=7)
    F, P4, F4 = np.asarray(drv.F_focus, dtype=np.float64), np.asarray(drv.cs_P4, dtype=np.float64), np.asarray(drv.cs_F4, dtype=np.float64)
    geo = dict(P4=P4, F4=F4, z_deck=float(drv.z_deck), r_m4=float(drv.r_m4), r_pot=float(HE.R_POT), z_duct=float(HE.Z_DUCT), r_duct=float(drv.r_duct))
    r_hole = float(drv.r_hole); r_bore = float(drv.r_bore)
    dev = drv.device; B = drv.num_agents; L, P, _ = drv._pts_l.shape
    pts0 = drv._pts_l.clone(); nrm0 = drv._nrm_l.clone(); fct0 = drv._fct.clone()
    xy = pts0[:, :, :2]; z = (xy[..., 0]**2 + xy[..., 1]**2)/(4*F_DISH); drv._pts_l = torch.cat([xy, z[..., None]], 2).contiguous()
    nn = torch.stack([-xy[..., 0]/(2*F_DISH), -xy[..., 1]/(2*F_DISH), torch.ones_like(z)], 2); drv._nrm_l = (nn/torch.linalg.norm(nn, dim=2, keepdim=True)).contiguous()
    drv._fct[:, 53] = F_DISH; drv._fct[:, 55] = F_DISH; drv._fct[:, 32] = F_DISH
    w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
    print(f"VALIDATION: the kernel's deep vertical-bore machine (cap {d} m beyond F, r_cap {r_cap:.3f}, F2 3 m below F, no slot, no strut) against the torch twin, {K} x {P} rays, same noise draws, sigb {SIGB}")
    KV = [0, 11, 12, 2, 5, 6, 7, 8, 9]
    print(f"{'day/hour':>12} {'el':>5} {'who':>6} | " + " ".join(f"{CODES[k][:8]:>8}" for k in KV))
    suns = {}
    for (day, hour) in ((172.0, 12.0), (80.0, 12.0), (80.0, 9.0), (355.0, 12.0)):
        day_t = torch.full((B,), day, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
        m0 = drv._mount(day_t, lat_t, hour, pnt=None, mech=False)
        pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
        m = drv._mount(day_t, lat_t, hour, pnt=pnt, mech=False)
        Cd = m["Cd"].clone(); nax = m["Mt"][:, 2, :].clone()
        elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
        sun = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
        drv._sun_cache = sun; drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
        drv._tr["du"] = rays.du.float().to(dev); drv._tr["de"] = rays.de.float().to(dev)
        thr, out6, per = drv.trace(Cd.contiguous(), nax.contiguous(), torch.full((B,), float(L//2), device=dev), torch.full((B,), SIGB, device=dev))
        fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
        kern = {CODES[k]: float(((fate == k).float()*w_ray[None]).sum(1).mean()) for k in CODES}
        el = float(m0["aux"][0, 0]); sun0 = sun[0].cpu().double().numpy(); suns[(day, hour)] = (el, sun0)
        R = m["Mt"][0].cpu().double().T.contiguous(); C0 = Cd[0].cpu().double()
        mine, _ = trace_bore(rays, SIGB, sun0, F, P4, F4, d, r_cap, 2*c, r_hole, r_bore, geo["z_deck"], geo["r_m4"], geo["r_pot"], geo["z_duct"], geo["r_duct"], R=R, C=C0)
        print(f"{int(day):>5}/{int(hour):<6} {el:5.1f} {'kernel':>6} | " + " ".join(f"{100*kern[CODES[k]]:7.1f}%" for k in KV))
        print(f"{'':>12} {'':>5} {'twin':>6} | " + " ".join(f"{100*mine[CODES[k]]:7.1f}%" for k in KV))
    drv._pts_l, drv._nrm_l = pts0, nrm0; drv._fct[:] = fct0
    # the sun over the year from the env's own ephemeris
    DAYS = {"midwinter": 355.0, "equinox": 80.0, "midsummer": 172.0}; HRS = [8, 9, 10, 11, 12, 13, 14, 15, 16]
    for dname, day in DAYS.items():
        for hour in HRS:
            day_t = torch.full((B,), day, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
            m0 = drv._mount(day_t, lat_t, float(hour), pnt=None, mech=False)
            elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
            suns[(dname, hour)] = (float(m0["aux"][0, 0]), torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1)[0].cpu().double().numpy())
    v.close()
    stalk_xy = (float(F[0]), float(F[1]))                     # the stalk over the built bore's axis
    # ================================================================================= 2. the built machine's year with the sun's disc (the kernel)
    # the fast env traces with us = upick = 0.5 (a fixed 3.2 mrad offset, not the sun's disc); the year logs were made so.
    # For the comparison with a machine that magnifies the sun twentyfold, the built machine is traced again with the disc.
    v, drv = build(); B = drv.num_agents; dev = drv.device; L, P, _ = drv._pts_l.shape
    w_ray = drv._ray_pw.reshape(-1)[:P].float().cpu(); w_ray = w_ray/w_ray.sum()
    built_disc = {}
    for dname, day in DAYS.items():
        for hour in HRS:
            day_t = torch.full((B,), day, device=dev); lat_t = torch.full((B,), 30.2, device=dev)
            m0 = drv._mount(day_t, lat_t, float(hour), pnt=None, mech=False); el = float(m0["aux"][0, 0])
            if el < 12.0: built_disc[(dname, hour)] = 0.0; continue
            pnt = torch.stack([m0["aux"][:, 0], torch.rad2deg(m0["aux"][:, 1])], 1).clone()
            m = drv._mount(day_t, lat_t, float(hour), pnt=pnt, mech=False)
            elr, azr = torch.deg2rad(m0["aux"][:, 0]), m0["aux"][:, 1]
            drv._sun_cache = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1).float().contiguous()
            drv._tr["vp"] = m["vp"].reshape(B, 21).clone(); drv._tr["scb"] = m["scb"].clone()
            drv._tr["du"] = rays.du.float().to(dev); drv._tr["de"] = rays.de.float().to(dev); drv._tr["us"] = rays.us.float().to(dev); drv._tr["upick"] = rays.upick.float().to(dev)
            thr, out6, per = drv.trace(m["Cd"].clone().contiguous(), m["Mt"][:, 2, :].clone().contiguous(), torch.full((B,), float(L//2), device=dev), torch.full((B,), SIGB, device=dev))
            fate = drv._metal.last_fate.view(B, P, 6)[:, :, 0].detach().cpu()
            built_disc[(dname, hour)] = float(((fate == 0).float()*w_ray[None]).sum(1).mean())
    v.close()
    # ================================================================================= 3. the coude relay at noon: the design sweep
    KR = [0, 11, 12, 15, 2, 5, 21, 22, 23, 24, 7, 8, 9]
    el, sun_noon = suns[(172.0, 12.0)]
    R_M3, R_M4C = 0.55, 0.60
    print(f"\nTHE COUDE RELAY, midsummer noon (el {el:.0f}), sigb {SIGB}, with the sun's disc: stalk at {stalk_xy}, deck z {geo['z_deck']}, M4 at z {geo['z_deck'] + L_STALK + Z_YOKE_OFF:.2f}, stalk {OFF} m beside the axis, M3 patch r {R_M3}, M4 patch r {R_M4C}, pivot bore r {R_PIV} over {PIV_LO}-{PIV_HI} m from the stalk, stalk r {R_STALK}")
    print("(a first sweep, kept in the README: F2 at 1.2-1.5 m behind the vertex with M3 relaying 1:1 or magnifying lost 33-70 % of the rays in the pivot's bore - the cap's image, 10-14 cm rms at magnification 16-26, is too large for a 0.30 m bore with the cone it carries; so F2 comes in towards the vertex and M3 demagnifies)")
    print(f"{'neck':>4} {'2c':>4} {'d':>5} {'mag':>4} {'s1':>4} {'s1p':>4} {'s2':>4} {'s2p':>4} {'hole':>4} | " + " ".join(f"{CODES_R[k][:6]:>6}" for k in KR) + " | rms radii cm: F2  M3  F3 piv  M4 F2c deck")
    rows = []
    for nk in (1.3, 1.8):
        for two_c in (1.2, 1.35, 1.5, 1.8):
            for d_c in (0.15, 0.20, 0.25):
                for s1p in (0.6, 0.7, 0.8):
                    for s2p in (2.0, 2.8, 3.5):
                        for rh in (0.4, 0.5):
                            cc = two_c/2; a_c = cc + d_c; rc = a_c*(1 - (cc/a_c)**2); s1 = nk - (two_c - F_DISH); s2 = OFF - s1p
                            if s1 <= 0.2 or rc > rh - 0.02: continue
                            ex = {}
                            tab, led = trace_coude(rays, SIGB, sun_noon, stalk_xy, geo["z_deck"], P4, F4, two_c, d_c, rc, rh, s1p, s2p, R_M3, R_M4C, geo["r_m4"], geo["r_pot"], geo["z_duct"], geo["r_duct"], neck=nk, extra=ex, disc=True)
                            rows.append((tab["through"], two_c, d_c, s1p, s2p, rh, rc, nk, dict(ex)))
                            print(f"{nk:4.1f} {two_c:4.2f} {d_c:5.2f} {(two_c + d_c)/d_c:4.0f} {s1:4.2f} {s1p:4.2f} {s2:4.2f} {s2p:4.2f} {rh:4.2f} | " + " ".join(f"{100*tab[CODES_R[k]]:5.1f}%" for k in KR)
                                  + f" | {100*ex['r_F2']:4.1f} {100*ex['r_M3']:4.1f} {100*ex['r_F3']:4.1f} {100*ex['r_piv']:4.1f} {100*ex['r_M4']:4.1f} {100*ex['r_F2c']:4.1f} {100*ex['r_deck']:4.1f}", flush=True)
    rows.sort(key=lambda r: -r[0])
    print("\nthe twelve best at noon (through with the sun's disc):")
    for r in rows[:12]: print(f"   {100*r[0]:5.1f} %  neck {r[7]}, 2c {r[1]}, d {r[2]} (cap r {r[6]:.3f}, m {(r[1] + r[2])/r[2]:.0f}), M3 {r[7] - (r[1] - F_DISH):.2f} -> {r[3]}, M4 {OFF - r[3]:.2f} -> {r[4]}, hole {r[5]}; beam rms at M3 {100*r[8]['r_M3']:.0f} cm, at M4 {100*r[8]['r_M4']:.0f} cm")
    thr, two_c, d_c, s1p, s2p, rh, rc, NECK_B, _ = rows[0]
    # ================================================================================= 4. the year for the best design
    base = {}
    for line in open(os.path.join(HERE, "deep_year2_d15_sig43.log")):
        parts = line.split()
        if len(parts) > 4 and parts[0] in DAYS and parts[1].isdigit():
            base[(parts[0], int(parts[1]))] = float(parts[4].rstrip("%"))/100
    print(f"\nTHE YEAR: the coude machine (neck {NECK_B}, 2c {two_c}, d {d_c}, M3 {NECK_B - (two_c - F_DISH):.2f} -> {s1p}, M4 {OFF - s1p:.2f} -> {s2p}, hole {rh}) against the built machine; rays through, sigb {SIGB}; 'disc' = the sun's limb-darkened disc, 'fixed' = the kernel's fixed 3.2 mrad offset (the year logs)")
    print(f"{'day':<10} {'hour':>4} {'el':>5} | {'built':>6} {'built':>6} | {'coude':>6} {'coude':>6} | " + " ".join(f"{CODES_R[k][:6]:>6}" for k in KR[1:]) + " | net light (0.94/mirror) built x3, coude x5, disc")
    print(f"{'':<10} {'':>4} {'':>5} | {'fixed':>6} {'disc':>6} | {'fixed':>6} {'disc':>6} |")
    tot = {}
    for dname in DAYS:
        for hour in HRS:
            el, sun = suns[(dname, hour)]; b0 = base.get((dname, hour), 0.0); b1 = built_disc[(dname, hour)]
            if el < 12.0:
                print(f"{dname:<10} {hour:4d} {el:5.1f} | {100*b0:5.1f}% {100*b1:5.1f}% | {'-':>6} {'-':>6} |"); continue
            tab, led = trace_coude(rays, SIGB, sun, stalk_xy, geo["z_deck"], P4, F4, two_c, d_c, rc, rh, s1p, s2p, R_M3, R_M4C, geo["r_m4"], geo["r_pot"], geo["z_duct"], geo["r_duct"], neck=NECK_B, disc=True)
            tab0, _ = trace_coude(rays, SIGB, sun, stalk_xy, geo["z_deck"], P4, F4, two_c, d_c, rc, rh, s1p, s2p, R_M3, R_M4C, geo["r_m4"], geo["r_pot"], geo["z_duct"], geo["r_duct"], neck=NECK_B, disc=False)
            thr, thr0 = tab["through"], tab0["through"]
            print(f"{dname:<10} {hour:4d} {el:5.1f} | {100*b0:5.1f}% {100*b1:5.1f}% | {100*thr0:5.1f}% {100*thr:5.1f}% | " + " ".join(f"{100*tab[CODES_R[k]]:5.1f}%" for k in KR[1:]) + f" | {100*b1*0.94**3:5.1f}% {100*thr*0.94**5:5.1f}%")
            for k, val in (("built", b0), ("built_disc", b1), ("coude", thr0), ("coude_disc", thr), ("built_net", b1*0.94**3), ("coude_net", thr*0.94**5)):
                tot.setdefault((dname, k), 0.0); tot[(dname, k)] += val*max(np.sin(np.radians(el)), 0.0)
    print("\nsummed over the nine hours weighted by sin(el), the coude machine relative to the built one:")
    for dname in DAYS:
        print(f"  {dname:<10} rays through: fixed offset {tot[(dname, 'coude')]/max(tot[(dname, 'built')], 1e-9):5.2f}x, sun's disc {tot[(dname, 'coude_disc')]/max(tot[(dname, 'built_disc')], 1e-9):5.2f}x;   net light with the disc {tot[(dname, 'coude_net')]/max(tot[(dname, 'built_net')], 1e-9):5.2f}x")

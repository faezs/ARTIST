"""Per-env sun: the batched, on-device mount solve.

Every env gets its OWN (day, lat) - 8192 suns per batch instead of
one - and the whole per-step mount solve (solar position, the signed
beta schedule, the off-axis orbit, fold frame, toroid powers, cosine
tax) becomes closed-form torch over (B,). This is simultaneously the
design fix (geometry-decorrelated experience) and the return of
commit 03bda4ee's device-native invariant: zero per-step host->device
builds. The scalar numpy solve in _metal_trace/_trace_power was the
last one standing - and it existed only BECAUSE the sun was shared.

Validation: mount_verify() runs a batch of identical (day, lat, t)
through this solve and through the env's scalar path - every output
must agree to float32.
"""
import numpy as np
import torch


def _align_batch(a, b):
    """(B,3,3) rotation taking unit vector a (3,) or (B,3) onto unit
    vectors b (B,3). Rodrigues, batched; the antiparallel edge case
    is handled with the standard perpendicular fallback."""
    B = b.shape[0]
    if a.dim() == 1:
        a = a.expand(B, 3)
    v = torch.linalg.cross(a, b)
    c = (a * b).sum(-1)
    s2 = (v * v).sum(-1)
    K = torch.zeros(B, 3, 3, dtype=b.dtype, device=b.device)
    K[:, 0, 1] = -v[:, 2]; K[:, 0, 2] = v[:, 1]
    K[:, 1, 0] = v[:, 2];  K[:, 1, 2] = -v[:, 0]
    K[:, 2, 0] = -v[:, 1]; K[:, 2, 1] = v[:, 0]
    eye = torch.eye(3, dtype=b.dtype, device=b.device).expand(B, 3, 3)
    k1 = ((1.0 - c) / s2.clamp(min=1e-12))[:, None, None]
    R = eye + K + k1 * torch.matmul(K, K)
    # near-parallel: identity; near-antiparallel: 180 deg about any
    # perpendicular axis
    par = s2 < 1e-12
    if bool(par.any()):
        anti = par & (c < 0)
        R[par] = eye[par]
        if bool(anti.any()):
            R[anti] = -eye[anti]
            R[anti, 0, 0] = 1.0    # flip about x for z->-z style
            R[anti, 1, 1] = -1.0
            R[anti, 2, 2] = -1.0
    return R


def _rot_about_axis(u, ax, ang):
    """Rotate (B,3) vectors u about unit axes ax by angles ang."""
    c = torch.cos(ang)[:, None]
    s = torch.sin(ang)[:, None]
    d = (ax * u).sum(-1, keepdim=True)
    return (u * c + torch.linalg.cross(ax, u) * s
            + ax * d * (1.0 - c))


def solar_batch(lat_deg, day, hour):
    """el [deg], az [rad], sun unit vector (ENU) - all (B,)/(B,3)."""
    phi = torch.deg2rad(lat_deg)
    delta = np.radians(23.44) * torch.sin(
        2.0 * np.pi * (284.0 + day) / 365.0)
    if not torch.is_tensor(hour):
        hour = torch.full_like(lat_deg, float(hour))
    h = torch.deg2rad(15.0 * (hour - 12.0))
    sin_el = (torch.sin(phi) * torch.sin(delta)
              + torch.cos(phi) * torch.cos(delta) * torch.cos(h))
    el = torch.arcsin(sin_el.clamp(-1, 1))
    cos_az = (torch.sin(delta) - sin_el * torch.sin(phi)) / (
        torch.cos(el) * torch.cos(phi)).clamp(min=1e-9)
    az = torch.arccos(cos_az.clamp(-1, 1))
    az = torch.where(h > 0, 2.0 * np.pi - az, az)
    s = torch.stack([torch.cos(el) * torch.sin(az),
                     torch.cos(el) * torch.cos(az),
                     sin_el], -1)
    return torch.rad2deg(el), az, s


def beta_now_batch(env, el):
    """The signed beta schedule, vectorized (see env._beta_now)."""
    lo = (el - (env.el_x - 1.0)).clamp(min=0.0)
    bd = torch.full_like(el, env.beta_dev)
    bp = torch.maximum(torch.minimum(bd, torch.maximum(bd, lo)), lo)
    if env.beta_cap_z is None:
        return bp
    for _ in range(3):
        naim_el = torch.deg2rad(el - 0.5 * bp)
        allow = env.beta_cap_z - env.a_mem \
            * torch.cos(naim_el).clamp(min=0.0)
        sarg = ((env.z_fold - allow) / env.g_orbit).clamp(-1.0, 1.0)
        hi = el - torch.rad2deg(torch.arcsin(sarg))
        bp = torch.minimum(bd, hi).clamp(min=0.0)
        bp = torch.maximum(bp, lo)
    bn = -torch.minimum(bd, (env.el_x - 2.0 - el).clamp(min=0.0))
    C = _consts(env, el.device, el.dtype)
    SB, SF, SBN, SFN = C["SB"], C["SF"], C["SBN"], C["SFN"]

    def interp(x, xs, ys):
        i = torch.searchsorted(xs, x.clamp(xs[0], xs[-1])).clamp(
            1, len(xs) - 1)
        x0, x1 = xs[i - 1], xs[i]
        y0, y1 = ys[i - 1], ys[i]
        w = ((x - x0) / (x1 - x0).clamp(min=1e-9)).clamp(0, 1)
        return y0 + w * (y1 - y0)
    shp = interp(bp.abs(), SB, SF)
    shn = interp(bn.abs(), SBN, SFN)
    scp = torch.cos(torch.deg2rad(bp) / 2.0) * (1.0 - shp)
    scn = torch.cos(torch.deg2rad(bn) / 2.0) * (1.0 - shn)
    use_n = (bn != 0.0) & (bp < env.beta_dev - 1e-9) & (scn > scp)
    return torch.where(use_n, bn, bp)


_CONSTS = {}


def _consts(env, dev, dtype):
    key = (id(env), str(dev))
    c = _CONSTS.get(key)
    if c is None:
        t = lambda v: torch.tensor(v, dtype=dtype, device=dev)
        c = dict(
            zhat=t([0.0, 0.0, 1.0]),
            yhat=t([0.0, 1.0, 0.0]),
            Pf=t([env.X_TOWER_C, 0.0, env.z_fold]),
            SB=t(env._SHADOW_B), SF=t(env._SHADOW_F),
            SBN=t(env._SHADOW_BN), SFN=t(env._SHADOW_FN),
            slotless=torch.tensor(bool(env.slotless), device=dev),
            flaps=torch.tensor(bool(env.slot_flaps), device=dev),
        )
        _CONSTS[key] = c
    return c


def mount_batch(env, day, lat, hour, dev):
    """The full per-step mount solve for (B,) days/lats at shared
    hour. Returns per-env geometry the trace consumes:
    vp (B,7,3), Mt (B,3,3), Cd (B,3), Acan (B,3,3),
    scb (B,6) = [cosi, slot_w2_or_off, kt, ks, ray_scale, el_ok],
    el (B,) deg, el_b (B,) deg, u (B,3)."""
    el, az, s = solar_batch(lat, day, hour)
    u = torch.stack([s[:, 1], s[:, 0], s[:, 2]], -1)
    u = u / u.norm(dim=-1, keepdim=True)
    B = u.shape[0]
    beta_t = beta_now_batch(env, el)
    C = _consts(env, dev, u.dtype)
    zhat = C["zhat"].expand_as(u)
    ax = torch.linalg.cross(zhat, u)
    axn = ax.norm(dim=-1, keepdim=True)
    ax = torch.where(axn > 1e-6, ax / axn.clamp(min=1e-9), ax)
    ub = _rot_about_axis(u, ax, torch.deg2rad(beta_t))
    ub = torch.where(axn > 1e-6, ub, u)
    ub = ub / ub.norm(dim=-1, keepdim=True)
    P_fold = C["Pf"].expand(B, 3)
    Cd = P_fold - env.g_orbit * ub
    naim = u + ub
    naim = naim / naim.norm(dim=-1, keepdim=True)
    M = _align_batch(C["zhat"], naim)
    el_b = torch.rad2deg(torch.arcsin(ub[:, 2].clamp(-1, 1)))
    el_r = torch.deg2rad(el_b)
    hvec = -(ub - ub[:, 2:3] * zhat)
    hvec = hvec / hvec.norm(dim=-1, keepdim=True).clamp(min=1e-9)
    p_up = hvec * torch.sin(el_r)[:, None] \
        + zhat * torch.cos(el_r)[:, None]
    nf = ub + zhat
    nf = nf / nf.norm(dim=-1, keepdim=True)
    cosi = (ub * nf).sum(-1).abs()
    e_par = ub - (ub * nf).sum(-1, keepdim=True) * nf
    e_par = e_par / e_par.norm(dim=-1, keepdim=True)
    e_prp = torch.linalg.cross(nf, e_par)
    e_pp = torch.linalg.cross(ub, -p_up)
    vp = torch.stack([u, P_fold, -p_up, e_pp, nf, e_par, e_prp], 1)
    Mt = M.transpose(1, 2)
    mu = torch.einsum("bij,bj->bi", Mt, -u)
    Acan = _align_batch(C["yhat"], mu)
    # toroid powers (0 unless fold_toroid), slot flag, cosine tax
    kt = torch.zeros(B, dtype=u.dtype, device=dev)
    ks = torch.zeros(B, dtype=u.dtype, device=dev)
    if env.fold_toroid:
        cth = (u * naim).sum(-1).clamp(-1, 1)
        ft_d, fs_d = env.f_nom * cth, env.f_nom / cth
        dw = env.z_fold - env.z_waist
        st = ft_d - env.g_orbit
        ss = fs_d - env.g_orbit
        okm = (st > 0.05) & (ss > 0.05)
        Pt = 1.0 / dw - 1.0 / st.clamp(min=1e-6)
        Ps = 1.0 / dw - 1.0 / ss.clamp(min=1e-6)
        kt = torch.where(okm, env.fold_toroid * Pt * cosi / 2.0, kt)
        ks = torch.where(okm, env.fold_toroid * Ps / (2.0 * cosi), ks)
    slot = torch.where(
        C["slotless"] | (C["flaps"] & (el_b < env.el_x - 3.0)),
        torch.full_like(el, 1e9),
        torch.full_like(el, env._sc1_base))
    rscale = torch.cos(torch.deg2rad(beta_t) / 2.0)
    el_ok = ((el >= env.el_min_h) & (el <= env.el_max_h)).to(u.dtype)
    scb = torch.stack([cosi, slot, kt, ks, rscale, el_ok], -1)
    return dict(vp=vp, Mt=Mt, Cd=Cd, Acan=Acan, scb=scb,
                el=el, az=az, el_b=el_b, u=u, ub=ub, naim=naim,
                beta_t=beta_t)

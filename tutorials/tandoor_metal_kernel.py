"""The megakernel: the entire Hashemi ray trace as ONE Metal kernel.

One thread per ray, sun-to-duct in registers, zero intermediate
tensors. The source is a line-for-line transcription of _geo_core in
tandoor_hashemi_env.py - which remains the reference implementation -
including ARTIST's rotate_distortions matrix (heliostat convention,
sin_e negated) and ARTIST's reflect formula. verify_megakernel()
compares the two on identical inputs; any change to the physics MUST
be made in _geo_core first, verified there against ITS eager form,
then transcribed here and verified again. Three implementations, one
truth.

sc layout (matches _sc_base): 0 r_fold 1 slot_r0 2 slot_w2 3 z1_t
4 z0_t 5 z_lip 6 m_c 7 r_tube_in 8 r_m5 9 z_m5 10 x_tower 11 z_duct
12 r_pot 13 r_duct_h 14 cosi 15 m_c2 16 z_roof 17 z_top 18 r_post
19 r_tube 20 csr_frac 21 csr_sigma
vp rows: 0 ut 1 Pf 2 s_dir 3 e_pp 4 nf 5 e_par 6 e_prp
"""
import numpy as np
import torch

MSL = r"""
#include <metal_stdlib>
using namespace metal;

static inline float3 vmatT(float3 v, device const float* M) {
    // row-vector times matrix: (v @ M)_i = sum_k v_k M[k*3+i]
    return float3(v.x*M[0]+v.y*M[3]+v.z*M[6],
                  v.x*M[1]+v.y*M[4]+v.z*M[7],
                  v.x*M[2]+v.y*M[5]+v.z*M[8]);
}
static inline float3 mrow(float3 v, device const float* M) {
    // matrix times column: (M @ v)_i = sum_k M[i*3+k] v_k
    return float3(M[0]*v.x+M[1]*v.y+M[2]*v.z,
                  M[3]*v.x+M[4]*v.y+M[5]*v.z,
                  M[6]*v.x+M[7]*v.y+M[8]*v.z);
}
static inline bool hits_column(float px, float py, float pz,
                               float vx, float vy, float vz,
                               float r, float zlo, float zhi,
                               float tlo, float thi) {
    float v2 = vx*vx + vy*vy;
    float tst = -(px*vx + py*vy) / max(v2, 1e-12f);
    bool nv = v2 < 1e-10f;
    float dmin = nv ? sqrt(px*px + py*py)
                    : fabs(px*vy - py*vx) / sqrt(max(v2, 1e-12f));
    float zst = pz + tst*vz;
    bool z_ok = nv ? true : (zst > zlo && zst < zhi);
    bool t_ok = nv ? true : (tst > tlo && tst < thi);
    return (dmin < r) && z_ok && t_ok;
}

// step-kernel capacity guards (host asserts n_nodes/n_belt fit)
#define NMAX 20
#define NBMAX 12

static inline void solar_pos(float latd, float dayv, float hour,
                             thread float* el_d, thread float* az_d) {
    // matches tandoor_mount_batch.solar_batch; az returned in DEGREES
    const float PI_ = 3.14159265358979f;
    float phi = latd * PI_ / 180.0f;
    float delta = 0.40910518f * sin(2.0f*PI_*(284.0f+dayv)/365.0f);
    float hh = (15.0f * (hour - 12.0f)) * PI_ / 180.0f;
    float sinel = sin(phi)*sin(delta) + cos(phi)*cos(delta)*cos(hh);
    sinel = clamp(sinel, -1.0f, 1.0f);
    float elr = asin(sinel);
    float cosaz = (sin(delta) - sinel*sin(phi))
        / max(cos(elr)*cos(phi), 1e-9f);
    float az = acos(clamp(cosaz, -1.0f, 1.0f));
    if (hh > 0.0f) az = 2.0f*PI_ - az;
    *el_d = elr * 180.0f / PI_;
    *az_d = az * 180.0f / PI_;
}

kernel void mount_solve(
    device float*       vp_o   [[buffer(0)]],   // (B,21)
    device float*       Mt_o   [[buffer(1)]],   // (B,9)
    device float*       Cd_o   [[buffer(2)]],   // (B,3)
    device float*       Ac_o   [[buffer(3)]],   // (B,9)
    device float*       scb_o  [[buffer(4)]],   // (B,6)
    device float*       aux_o  [[buffer(5)]],   // (B,8) el,azd,elb,ub3,beta
    device const float* day    [[buffer(6)]],
    device const float* lat    [[buffer(7)]],
    device const float* prm    [[buffer(8)]],   // params + shadow tables
    device const int*   nB     [[buffer(9)]],
    uint b [[thread_position_in_grid]])
{
    if ((int)b >= nB[0]) return;
    const float PI_ = 3.14159265358979f;
    float hour = prm[0], beta_dev = prm[1], cap_z = prm[2];
    float a_mem = prm[3], z_fold = prm[4], g_orb = prm[5];
    float el_x = prm[6];
    float xtw = prm[9], sc1b = prm[10], ftor = prm[11];
    float fnom = prm[12], zwst = prm[13];
    // ---- solar position (matches tandoor_mount_batch.solar_batch)
    float phi = lat[b] * PI_ / 180.0f;
    float delta = 0.40910518f * sin(2.0f*PI_*(284.0f+day[b])/365.0f);
    float hh = (15.0f * (hour - 12.0f)) * PI_ / 180.0f;
    float sinel = sin(phi)*sin(delta) + cos(phi)*cos(delta)*cos(hh);
    sinel = clamp(sinel, -1.0f, 1.0f);
    float elr = asin(sinel);
    float el = elr * 180.0f / PI_;
    float cosaz = (sin(delta) - sinel*sin(phi))
        / max(cos(elr)*cos(phi), 1e-9f);
    float az = acos(clamp(cosaz, -1.0f, 1.0f));
    if (hh > 0.0f) az = 2.0f*PI_ - az;
    float3 u = float3(cos(elr)*cos(az), cos(elr)*sin(az), sinel);
    u = normalize(u);          // ENU swapped: x=north comp = cos*cos
    // ---- signed beta schedule (matches beta_now_batch)
    float lo = max(el - (el_x - 1.0f), 0.0f);
    float bp = clamp(beta_dev, lo, max(beta_dev, lo));
    float bt;
    if (cap_z > 1e8f) {
        bt = bp;
    } else {
        for (int it = 0; it < 3; it++) {
            float nel = (el - 0.5f*bp) * PI_ / 180.0f;
            float allow = cap_z - a_mem * max(cos(nel), 0.0f);
            float sarg = clamp((z_fold - allow)/g_orb, -1.0f, 1.0f);
            float hi = el - asin(sarg)*180.0f/PI_;
            bp = max(max(min(beta_dev, hi), 0.0f), lo);
        }
        float bn = -min(beta_dev, max(el_x - 2.0f - el, 0.0f));
        // shadow curves: prm[14..21]=SB, [22..29]=SF, [30..34]=SBN,
        // [35..39]=SFN
        float ap = fabs(bp), an = fabs(bn);
        float shp = prm[29], shn = prm[39];
        for (int i = 1; i < 8; i++) {
            float x0 = prm[14+i-1], x1 = prm[14+i];
            if (ap <= x1) {
                float w = clamp((ap-x0)/max(x1-x0, 1e-9f), 0.0f, 1.0f);
                shp = prm[22+i-1] + w*(prm[22+i]-prm[22+i-1]);
                break;
            }
        }
        for (int i = 1; i < 5; i++) {
            float x0 = prm[30+i-1], x1 = prm[30+i];
            if (an <= x1) {
                float w = clamp((an-x0)/max(x1-x0, 1e-9f), 0.0f, 1.0f);
                shn = prm[35+i-1] + w*(prm[35+i]-prm[35+i-1]);
                break;
            }
        }
        float scp = cos(bp*PI_/360.0f) * (1.0f - shp);
        float scn = cos(bn*PI_/360.0f) * (1.0f - shn);
        bool usen = (bn != 0.0f) && (bp < beta_dev - 1e-9f)
                    && (scn > scp);
        bt = usen ? bn : bp;
    }
    // ---- orbit frames (matches mount_batch)
    float3 zh = float3(0.0f, 0.0f, 1.0f);
    float3 ax = cross(zh, u);
    float axn = length(ax);
    float3 ub;
    if (axn > 1e-6f) {
        float3 axu = ax / axn;
        float br = bt * PI_ / 180.0f;
        float cb = cos(br), sb = sin(br);
        ub = u*cb + cross(axu, u)*sb + axu*dot(axu, u)*(1.0f-cb);
    } else { ub = u; }
    ub = normalize(ub);
    float3 Pf = float3(xtw, 0.0f, z_fold);
    float3 Cdv = Pf - g_orb * ub;
    float3 naim = normalize(u + ub);
    // R: zhat -> naim (Rodrigues with guards)
    float3 vv = cross(zh, naim);
    float cc = dot(zh, naim);
    float s2 = dot(vv, vv);
    float M9[9];
    if (s2 < 1e-12f) {
        for (int i = 0; i < 9; i++) M9[i] = 0.0f;
        M9[0] = 1.0f; M9[4] = (cc < 0.0f ? -1.0f : 1.0f);
        M9[8] = (cc < 0.0f ? -1.0f : 1.0f);
    } else {
        float k1 = (1.0f - cc) / s2;
        float K9[9] = {0.0f, -vv.z, vv.y, vv.z, 0.0f, -vv.x,
                       -vv.y, vv.x, 0.0f};
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++) {
                float kk = 0.0f;
                for (int k = 0; k < 3; k++)
                    kk += K9[i*3+k]*K9[k*3+j];
                M9[i*3+j] = (i == j ? 1.0f : 0.0f) + K9[i*3+j]
                            + k1*kk;
            }
    }
    float elb = asin(clamp(ub.z, -1.0f, 1.0f)) * 180.0f / PI_;
    float elbr = elb * PI_ / 180.0f;
    float3 hv = -(ub - ub.z*zh);
    hv = hv / max(length(hv), 1e-9f);
    float3 pup = hv*sin(elbr) + zh*cos(elbr);
    float3 nf = normalize(ub + zh);
    float cosi = fabs(dot(ub, nf));
    float3 epar = normalize(ub - dot(ub, nf)*nf);
    float3 eprp = cross(nf, epar);
    float3 epp = cross(ub, -pup);
    // vp rows: u, Pf, -pup, epp, nf, epar, eprp
    int vb = b*21;
    float3 rows[7] = {u, Pf, -pup, epp, nf, epar, eprp};
    for (int r = 0; r < 7; r++) {
        vp_o[vb + r*3+0] = rows[r].x;
        vp_o[vb + r*3+1] = rows[r].y;
        vp_o[vb + r*3+2] = rows[r].z;
    }
    // Mt = M^T
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            Mt_o[b*9 + i*3 + j] = M9[j*3 + i];
    Cd_o[b*3+0] = Cdv.x; Cd_o[b*3+1] = Cdv.y; Cd_o[b*3+2] = Cdv.z;
    // Acan: yhat -> Mt @ (-u)
    float3 mu = float3(M9[0]*(-u.x)+M9[3]*(-u.y)+M9[6]*(-u.z),
                       M9[1]*(-u.x)+M9[4]*(-u.y)+M9[7]*(-u.z),
                       M9[2]*(-u.x)+M9[5]*(-u.y)+M9[8]*(-u.z));
    float3 yh = float3(0.0f, 1.0f, 0.0f);
    float3 v2 = cross(yh, mu);
    float c2 = dot(yh, mu);
    float t2 = dot(v2, v2);
    if (t2 < 1e-12f) {
        for (int i = 0; i < 9; i++) Ac_o[b*9+i] = 0.0f;
        Ac_o[b*9+0] = (c2 < 0.0f ? -1.0f : 1.0f);
        Ac_o[b*9+4] = 1.0f;
        Ac_o[b*9+8] = (c2 < 0.0f ? -1.0f : 1.0f);
    } else {
        float k2 = (1.0f - c2) / t2;
        float K2[9] = {0.0f, -v2.z, v2.y, v2.z, 0.0f, -v2.x,
                       -v2.y, v2.x, 0.0f};
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++) {
                float kk = 0.0f;
                for (int k = 0; k < 3; k++)
                    kk += K2[i*3+k]*K2[k*3+j];
                Ac_o[b*9 + i*3+j] = (i == j ? 1.0f : 0.0f)
                                    + K2[i*3+j] + k2*kk;
            }
    }
    // scb: cosi, slot, kt, ks, ray_scale, el_ok
    float kt = 0.0f, ks = 0.0f;
    if (ftor != 0.0f) {
        float cth = clamp(dot(u, naim), -1.0f, 1.0f);
        float ftd = fnom*cth, fsd = fnom/cth;
        float dw = z_fold - zwst;
        float st = ftd - g_orb, ss = fsd - g_orb;
        if (st > 0.05f && ss > 0.05f) {
            float Pt = 1.0f/dw - 1.0f/st;
            float Ps = 1.0f/dw - 1.0f/ss;
            kt = ftor * Pt * cosi / 2.0f;
            ks = ftor * Ps / (2.0f * cosi);
        }
    }
    bool slotless = prm[7] > 0.5f;   // packed flags
    bool flaps = prm[8] > 0.5f;
    float slot = (slotless || (flaps && elb < el_x - 3.0f))
                 ? 1e9f : sc1b;
    float rscale = cos(bt*PI_/360.0f);
    float elok = (el >= prm[40] && el <= prm[41]) ? 1.0f : 0.0f;
    int sb2 = b*6;
    scb_o[sb2+0] = cosi; scb_o[sb2+1] = slot;
    scb_o[sb2+2] = kt;   scb_o[sb2+3] = ks;
    scb_o[sb2+4] = rscale; scb_o[sb2+5] = elok;
    aux_o[b*8+0] = el;
    aux_o[b*8+1] = az;                 // radians, dict contract
    aux_o[b*8+2] = elb;
    aux_o[b*8+3] = ub.x; aux_o[b*8+4] = ub.y; aux_o[b*8+5] = ub.z;
    aux_o[b*8+6] = bt;
    aux_o[b*8+7] = 0.0f;
}

kernel void tandoor_trace(
    device float*       thr_o  [[buffer(0)]],   // (B*P) through * w
    device float*       out6   [[buffer(1)]],   // (B*P,6)
    device const float* pts_l  [[buffer(2)]],   // (L,P,3)
    device const float* nrm_l  [[buffer(3)]],
    device const float* lv     [[buffer(4)]],   // (B)
    device const float* du     [[buffer(5)]],   // (B*P)
    device const float* de     [[buffer(6)]],
    device const float* upk    [[buffer(7)]],
    device const float* sigb   [[buffer(8)]],   // (B)
    device const float* dvec   [[buffer(9)]],   // (B,2)
    device const float* off    [[buffer(10)]],  // (B,2)
    device const float* vp     [[buffer(11)]],  // (B,7,3) per env
    device const float* sc     [[buffer(12)]],  // shared table
    device const float* Acan   [[buffer(13)]],  // (B,3,3)
    device const float* Mt     [[buffer(14)]],  // (B,3,3)
    device const float* Cd     [[buffer(15)]],  // (B,3)
    device const float* ellM   [[buffer(16)]],
    device const float* ellS   [[buffer(17)]],
    device const float* ellC   [[buffer(18)]],
    device const float* V0     [[buffer(19)]],
    device const int*   dims   [[buffer(20)]],  // B, P, L, n_nodes
    device const float* ray_pw [[buffer(21)]],
    device const float* soil   [[buffer(22)]],
    device float*       per_dni [[buffer(23)]],  // (B, n_nodes) zeroed
    device const float* us     [[buffer(24)]],  // (B*P) sun-table u
    device const float* aim    [[buffer(25)]],  // (B,3) elbow aim dirs
    device const float* scb    [[buffer(26)]],  // (B,6) cosi,slot,kt,ks,rs,ok
    uint tid [[thread_position_in_grid]])
{
    const int B = dims[0], P = dims[1], L = dims[2];
    if (tid >= uint(B*P)) return;
    const int b = tid / P, ip = tid % P;
    const int vb = b*21;
    const int sb = b*6;
    const float3 ut   = float3(vp[vb+0],  vp[vb+1],  vp[vb+2]);
    const float3 Pf   = float3(vp[vb+3],  vp[vb+4],  vp[vb+5]);
    const float3 sdir = float3(vp[vb+6],  vp[vb+7],  vp[vb+8]);
    const float3 epp  = float3(vp[vb+9],  vp[vb+10], vp[vb+11]);
    const float3 nf   = float3(vp[vb+12], vp[vb+13], vp[vb+14]);
    const float3 epar = float3(vp[vb+15], vp[vb+16], vp[vb+17]);
    const float3 eprp = float3(vp[vb+18], vp[vb+19], vp[vb+20]);
    const float3 CdV  = float3(Cd[b*3+0], Cd[b*3+1], Cd[b*3+2]);

    // ---- membrane level-lerp (the fused bounce)
    float lvb = lv[b];
    int i0 = clamp(int(lvb), 0, L-2);
    float fr = lvb - float(i0);
    int o0 = (i0*P + ip)*3, o1 = ((i0+1)*P + ip)*3;
    float3 p_loc = (1.0f-fr)*float3(pts_l[o0],pts_l[o0+1],pts_l[o0+2])
                 +        fr*float3(pts_l[o1],pts_l[o1+1],pts_l[o1+2]);
    float3 n_loc = (1.0f-fr)*float3(nrm_l[o0],nrm_l[o0+1],nrm_l[o0+2])
                 +        fr*float3(nrm_l[o1],nrm_l[o1+1],nrm_l[o1+2]);
    n_loc = normalize(n_loc);

    // ---- THE SUN from its Buie table (sc[38..102], 65 knots):
    // radial angle by inverse-CDF on us, azimuth from upk; du/de are
    // the OPTICS Gaussian alone. rotate_distortions convention
    // (heliostat, sin_e NEGATED) on the canonical ray (0,1,0).
    float tq = clamp(us[tid], 0.0f, 1.0f) * 64.0f;
    int   ti = min((int)tq, 63);
    float tf = tq - (float)ti;
    float th_sun = sc[38 + ti]*(1.0f - tf) + sc[38 + ti + 1]*tf;
    float psi = 6.2831853f * upk[tid];
    float ea = th_sun*cos(psi) + de[tid]*sigb[b];
    float ua = th_sun*sin(psi) + du[tid]*sigb[b];
    float ce = cos(ea), se_ = -sin(ea), cu = cos(ua), su = sin(ua);
    float3 v = float3(-su, ce*cu, -se_*cu);
    float3 inc = mrow(v, Acan + b*9);
    // ARTIST reflect: d - 2 (d.n) n
    float3 d1 = inc - 2.0f*dot(inc, n_loc)*n_loc;

    // ---- to world
    float3 p = vmatT(p_loc, Mt + b*9) + CdV;
    float3 d = normalize(vmatT(d1, Mt + b*9));

    // ---- occlusion, closed form (post + tube), sun leg
    float px_ = p.x - sc[10], py_ = p.y, pz_ = p.z;
    bool lit = !( hits_column(px_,py_,pz_, ut.x,ut.y,ut.z,
                              sc[18], sc[16], sc[17], 0.0f, 1e9f)
               || hits_column(px_,py_,pz_, ut.x,ut.y,ut.z,
                              sc[19], sc[4], sc[3], 0.0f, 1e9f) );
    float3 vf = Pf - p;
    float3 perpf = vf - dot(vf, ut)*ut;
    lit = lit && (length(perpf) > sc[0]);
    float3 q = p - CdV;
    lit = lit && !((dot(q, sdir) > scb[sb+1]) && (fabs(dot(q, epp)) < sc[2]));

    // ---- the fold
    float den = dot(d, nf);
    float denu = (fabs(den) > 1e-9f) ? den : 1e-9f;
    float t1 = dot(Pf - p, nf) / denu;
    float3 h1 = p + t1*d;
    float3 rel1 = h1 - Pf;
    float c_par = dot(rel1, epar) * scb[sb+0];
    float c_prp = dot(rel1, eprp);
    // compliant toroidal fold: sc[103]=1/R_t, sc[104]=1/R_s (0 = flat)
    float3 n_tor = nf - scb[sb+2]*dot(rel1, epar)*epar
                      - scb[sb+3]*dot(rel1, eprp)*eprp;
    n_tor = normalize(n_tor);
    float rad1 = sqrt(c_par*c_par + c_prp*c_prp);
    bool graze = hits_column(px_,py_,pz_, d.x,d.y,d.z,
                             sc[18], sc[16], sc[17], 0.0f, t1-0.10f)
              || hits_column(px_,py_,pz_, d.x,d.y,d.z,
                             sc[19], sc[4], sc[3], 0.0f, t1-0.10f);
    bool ok = lit && !graze && (t1 > 0.0f) && (rad1 < sc[0]);
    float3 d2 = d - 2.0f*dot(d, n_tor)*n_tor;

    const float dv0 = dvec[b*2], dv1 = dvec[b*2+1];
    // ---- the CPC lip: Winston profile as 8 conical segments
    // (sc[22+2k]=r0_k, sc[23+2k]=m_k over [sc[3], sc[5]]), first hit
    // wins; one traced bounce - mirrors _geo_core line for line
    float Xo = h1.x - sc[10] + dv0, Yo = h1.y + dv1;
    float dzseg = (sc[5] - sc[3]) * 0.125f;
    float tc = 1e9f;
    float m_hit = 0.0f;
    bool hitsw = false;
    for (int ks = 0; ks < 8; ks++) {
        float zk = sc[3] + ks*dzseg;
        float r0k = sc[22 + 2*ks], mk = sc[23 + 2*ks];
        float rz0 = r0k + mk*(h1.z - zk);
        float qa = d2.x*d2.x + d2.y*d2.y - (mk*d2.z)*(mk*d2.z);
        float qb = 2.0f*(Xo*d2.x + Yo*d2.y - mk*rz0*d2.z);
        float qc = Xo*Xo + Yo*Yo - rz0*rz0;
        float disc = qb*qb - 4.0f*qa*qc;
        float sq = sqrt(max(disc, 0.0f));
        float tA_ = (fabs(qa) > 1e-9f) ? (-qb-sq)/(2.0f*qa)
                                       : -qc/max(qb, 1e-9f);
        float tB_ = (fabs(qa) > 1e-9f) ? (-qb+sq)/(2.0f*qa) : tA_;
        float zA_ = h1.z + tA_*d2.z, zB_ = h1.z + tB_*d2.z;
        bool vA_ = (tA_ > 1e-4f) && (zA_ >= zk) && (zA_ < zk + dzseg);
        bool vB_ = (tB_ > 1e-4f) && (zB_ >= zk) && (zB_ < zk + dzseg);
        float t1_ = min(vA_ ? tA_ : 1e9f, vB_ ? tB_ : 1e9f);
        bool val = (disc > 0.0f) && (t1_ < 1e8f) && (t1_ < tc);
        if (val) { tc = t1_; m_hit = mk; hitsw = true; }
    }
    float zc = h1.z + tc*d2.z;
    float w = 1.0f;
    if (hitsw) {
        float hx = Xo + tc*d2.x, hy = Yo + tc*d2.y;
        float rc = max(sqrt(hx*hx + hy*hy), 1e-6f);
        float3 nc = normalize(float3(hx, hy, -m_hit*rc));
        d2 = d2 - 2.0f*dot(d2, nc)*nc;
        h1 = float3(hx + sc[10] - dv0, hy - dv1, zc);
        w = sc[6];
    }
    // ---- the straight section's two gates
    for (int g = 0; g < 2; g++) {
        float z_st = (g == 0) ? sc[3] : sc[4];
        float t_st = (z_st - h1.z) / min(d2.z, -1e-9f);
        float ax = h1.x + t_st*d2.x - sc[10] + dv0;
        float ay = h1.y + t_st*d2.y + dv1;
        ok = ok && (sqrt(ax*ax + ay*ay) < sc[7]);
    }
    // ---- below-throat CPC wall (m_c2), one traced bounce
    Xo = h1.x - sc[10] + dv0; Yo = h1.y + dv1;
    float rz0b = sc[7] + sc[15]*(h1.z - sc[4]);
    float qab = d2.x*d2.x + d2.y*d2.y - (sc[15]*d2.z)*(sc[15]*d2.z);
    float qbb = 2.0f*(Xo*d2.x + Yo*d2.y - sc[15]*rz0b*d2.z);
    float qcb = Xo*Xo + Yo*Yo - rz0b*rz0b;
    float discb = qbb*qbb - 4.0f*qab*qcb;
    float sqb = sqrt(max(discb, 0.0f));
    float tAb = (fabs(qab) > 1e-9f) ? (-qbb-sqb)/(2.0f*qab)
                                     : -qcb/max(qbb, 1e-9f);
    float tBb = (fabs(qab) > 1e-9f) ? (-qbb+sqb)/(2.0f*qab) : tAb;
    float zAb = h1.z + tAb*d2.z, zBb = h1.z + tBb*d2.z;
    bool vAb = (tAb > 1e-4f) && (zAb > sc[9]+0.35f) && (zAb < sc[4]);
    bool vBb = (tBb > 1e-4f) && (zBb > sc[9]+0.35f) && (zBb < sc[4]);
    float tcb = min(vAb ? tAb : 1e9f, vBb ? tBb : 1e9f);
    float zcb = h1.z + tcb*d2.z;
    bool hitsb = (discb > 0.0f) && (tcb < 1e8f);
    if (hitsb) {
        float hx = Xo + tcb*d2.x, hy = Yo + tcb*d2.y;
        float rc = max(sc[7] + sc[15]*(zcb - sc[4]), 1e-6f);
        float3 nc = normalize(float3(hx, hy, -sc[15]*rc));
        d2 = d2 - 2.0f*dot(d2, nc)*nc;
        h1 = float3(hx + sc[10] - dv0, hy - dv1, zcb);
        w *= sc[6];
    }
    // ---- M5's ellipsoid, far root; patch bound 1.50 r_m5
    float3 vec = h1 - float3(ellC[0], ellC[1], ellC[2]);
    float3 pl = mrow(vec, ellM);
    float3 dl = mrow(d2, ellM);
    float3 S = float3(ellS[0], ellS[1], ellS[2]);
    float qae = dot(dl*dl, S);
    float qbe = 2.0f*dot(pl*dl, S);
    float qce = dot(pl*pl, S) - 1.0f;
    float disce = qbe*qbe - 4.0f*qae*qce;
    bool oke = disce > 0.0f;
    float t2 = (-qbe + sqrt(max(disce, 0.0f))) / (2.0f*qae);
    float3 h2 = h1 + t2*d2;
    float3 dV0 = h2 - float3(V0[0], V0[1], V0[2]);
    ok = ok && oke && (t2 > 0.0f) && (length(dV0) < 1.50f*sc[8]);
    float3 hl = mrow(h2 - float3(ellC[0], ellC[1], ellC[2]), ellM);
    float3 nl = normalize(hl*S);
    // ne = nl @ ellM  (row-vector times matrix)
    float3 ne = vmatT(nl, ellM);
    float3 d3 = d2 - 2.0f*dot(d2, ne)*ne;
    // ---- the duct plane
    float t3 = (sc[12] - h2.x) / min(d3.x, -1e-9f);
    ok = ok && (d3.x < -0.05f) && (t3 < 4.0f);
    t3 = min(t3, 4.0f);
    float3 h3 = h2 + t3*d3;
    float dy = h3.y + off[b*2];
    float dz = h3.z - sc[11] + off[b*2+1];
    bool thr = ok && (t3 > 0.0f) && (dy*dy + dz*dz <= sc[13]*sc[13]);
    thr_o[tid] = thr ? w : 0.0f;
    int o = tid*6;
    out6[o+0] = h3.y;            out6[o+1] = h3.z - sc[11];
    out6[o+2] = d3.x;            out6[o+3] = d3.y;
    out6[o+4] = d3.z;            out6[o+5] = w;

    // ---- _bin_pot, transcribed: duct arrival -> pot node powers.
    // Frame map theirs = (y_ours, -x_ours, z_ours - H_POT):
    // pxp = h3.y, pyp = h3.z - Z_DUCT_ours; dirs (d3.y, -d3.x, d3.z).
    // Their constants: R_POT 0.42, Z_DUCT -0.86, H_POT 1.0,
    // n_belt 8, hearth = n_belt, crown = n_belt + 2.
    if (thr) {
        // THE REAL PIT: spherical section, mouth R 0.26 at z 0,
        // coal-bed floor R 0.42 at z -2.44 (8 ft). Derived (mirrors
        // tandoor_polar_env): Z_CPOT, R_SPH, duct-wall radius.
        const float ZD = -0.86f, HD = 2.44f;
        const float ZC = -1.2422951f, RS = 1.2692112f;
        const float RDW = 1.2102675f;
        const int NB = 8;
        float pxp = h3.y, pyp = h3.z - sc[11];
        float dxw = d3.y, dyw = -d3.x, dzw = d3.z;
        float ox = pxp, oyv = -RDW, oz = pyp + ZD;
        if (sc[105] > 1.5f) {
            // CONCAVE ELBOW on its 2-DOF mount (duct_nozzle 2):
            // per-env aim direction from the aim buffer (computed
            // env-side from spot_phi/spot_z, one source of truth).
            const float3 A0 = float3(0.0f, 0.9606134f, 0.2778882f);
            const float3 MM = float3(0.0f, -0.8740528f, -0.7627391f);
            const float FN = 0.2956729f;
            float3 a1 = float3(aim[b*3+0], aim[b*3+1], aim[b*3+2]);
            float3 o3 = float3(ox, oyv, oz);
            float3 d3w = float3(dxw, dyw, dzw);
            float da = max(dot(d3w, A0), 1e-6f);
            float tmn = dot(MM - o3, A0) / da;
            float3 q3 = o3 + tmn*d3w - MM;
            // Rodrigues A0 -> a1: Rx = x + vxx + k1 vx(vxx)
            float3 vv = cross(A0, a1);
            float k1 = 1.0f / max(1.0f + dot(A0, a1), 1e-6f);
            d3w = d3w + cross(vv, d3w) + k1*cross(vv, cross(vv, d3w));
            q3 = q3 + cross(vv, q3) + k1*cross(vv, cross(vv, q3));
            float3 qp = q3 - dot(q3, a1)*a1;
            d3w = normalize(d3w - qp / FN);
            o3 = MM + q3;
            ox = o3.x; oyv = o3.y; oz = o3.z;
            dxw = d3w.x; dyw = d3w.y; dzw = d3w.z;
        }
        float ozc = oz - ZC;
        float aq = dxw*dxw + dyw*dyw + dzw*dzw;
        float bq = ox*dxw + oyv*dyw + ozc*dzw;
        float cq = ox*ox + oyv*oyv + ozc*ozc - RS*RS;
        float t_w = (-bq + sqrt(max(bq*bq - aq*cq, 0.0f)))
                    / max(aq, 1e-9f);
        float sz_s = oz + t_w*dzw;
        bool hitf = sz_s < -HD;
        float t_f = (-HD - oz) / min(dzw, -1e-6f);
        float sx = hitf ? ox + t_f*dxw : ox + t_w*dxw;
        float sy = hitf ? oyv + t_f*dyw : oyv + t_w*dyw;
        float sz = hitf ? -HD : sz_s;
        float phi = atan2(sy, sx);
        int seg = clamp(int((phi + M_PI_F) / (2.0f*M_PI_F) * NB),
                        0, NB - 1);
        int seg4 = clamp(int((phi + M_PI_F) / (2.0f*M_PI_F) * 4),
                         0, 3);
        int node = (hitf || sz < -HD + 0.12f) ? NB
                   : (sz > -0.22f ? NB + 2
                      : (sz > -0.85f ? seg : NB + 3 + seg4));
        float wgt = ray_pw[ip] * soil[b] * (thr ? w : 0.0f)
                    * scb[sb+4] * scb[sb+5]
                    * (sc[105] > 0.5f ? 0.95f : 1.0f);
        atomic_fetch_add_explicit(
            (device atomic_float*)&per_dni[b*dims[3] + node],
            wgt, memory_order_relaxed);
    }
}

// ==================================================================
// THE FUSED STEP: everything between the mount and the trace, and
// everything after it, as two B-thread kernels. Line-for-line
// transcription of tandoor_gpu_step.gpu_step + the cut branch of
// _gpu_full_step + _gpu_obs (which remain the torch reference,
// verified by tandoor_fused_step.verify_fused with zero noise).
//
// st layout, per env (NS = 3N+1+4NB+34):
//   [0..N) T   [N..2N) T_sub   [2N..3N) T_deep   [3N] T_halo
//   [3N+1..) bread_E[NB] bread_t[NB] bread_C[NB] has_bread[NB]
//   scalars at S0 = 3N+1+4NB:
//   +0 p_act +1 p_set +2 p_dist +3 shutter +4 jammed +5 f_locked
//   +6 form_time +7 decl_formed +8 load_timer +9 ep_rotis
//   +10 ep_scorch +11 ep_spall +12 ep_return +13 ep_len
//   +14 el_m +15 az_m +16 lost_ct +17 belt_prev +18 cloud
//   +19 wind_g +20 e_az_prev +21 e_el_prev +22 spot_phi +23 spot_z
//   +34 day_rotis (cut-immune; day-over zeroes it host-side)
//   +24 dni +25 wind +26 stowed
//   scratch (pre -> post): +27 el0s +28 az0d +29 pot_prev +30 gate
//   +31 decl_now +32 e_el +33 e_az
//
// sp layout (see tandoor_fused_step._step_params):
//   0 dt 1 p0 2 RATE_AZ 3 RATE_EL 4 RATE_SPOT_PHI 5 RATE_SPOT_Z
//   6 SPH_LO 7 SPH_HI 8 SPZ_LO 9 SPZ_HI 10 thr_g 11 jam_gain
//   12 wall_shelter 13 sig_static 14 el_min 15 el_max 16 cosf0
//   17 lid_leak 18 h_bread 19 roti_E 20 load_period 21 fcov
//   22 Z_BAKE_LO 23 Z_CROWN 24 f_elbow 25 f_spot 26 f_wall
//   27 T_COOK_LO 28 T_COOK_HI 29 R_SPH 30 Z_CPOT 31 M0 32 M1 33 M2
//   34 f_nom 35 NL-1 36 lf0 37 lf_span 38 g_halo_out 39 c_halo
//   40 SPOT_PHI0 41 SPOT_Z0 42 dt_h 43 T_AMB 44 c_cloud 45 c_windg
//   46 c_bore 47 p_collapse 48 dt/900 49 dt/600 50 dt/300
//   51 ap_area 52 a_tot 53 bread_area 54..60 level_frac[7]
//   61 loaves_per_load 62 load_ctrl
//   63.. node_area[N] heat_cap[N] cap_sub[N] cap_deep[N]
//        g01[N] g12[N] g2s[N]
// ip: 0 B 1 N 2 NB 3 NH 4 NS 5 OD 6 tick (host-written per step)
// ==================================================================

kernel void step_pre(
    device float*       lv    [[buffer(0)]],   // (B,) FIRST: grid = B
    device float*       st    [[buffer(1)]],
    device const int*   act   [[buffer(2)]],   // (B,NH)
    device const float* rn    [[buffer(3)]],   // (B,12) normals
    device const float* ru    [[buffer(4)]],   // (B,16) uniforms
    device const float* sp    [[buffer(5)]],
    device const int*   ip    [[buffer(6)]],
    device const float* aux   [[buffer(7)]],   // mount el/az
    device const float* day   [[buffer(8)]],
    device const float* lat   [[buffer(9)]],
    device const float* mprm  [[buffer(10)]],  // [0] = hour pre-step
    device float*       sigb  [[buffer(11)]],
    device float*       dvec  [[buffer(12)]],  // (B,2)
    device float*       off   [[buffer(13)]],  // (B,2) bore state
    device float*       aim   [[buffer(14)]],  // (B,3)
    device float*       per   [[buffer(15)]],  // (B,N) zeroed here
    uint b [[thread_position_in_grid]])
{
    if ((int)b >= ip[0]) return;
    const float PI_ = 3.14159265358979f;
    const int N = ip[1], NB = ip[2], NH = ip[3], NS = ip[4];
    device float* s = st + b*NS;
    const int S0 = 3*N + 1 + 4*NB;
    const float dt = sp[0];
    device const int* a = act + b*NH;
    device const float* rb = rn + b*12;
    // ---- mount's sun (aux az is radians)
    float el0 = aux[b*8+0];
    float az0d = aux[b*8+1] * 180.0f / PI_;
    // ---- potential BEFORE this step's motor action
    float potp = min(fabs(s[S0+20]) + fabs(s[S0+21]), 8.0f);
    // ---- motors + spot jogs
    float r_az = (float)(clamp(a[3], 0, 6) - 3) / 3.0f * sp[2];
    float r_el = (float)(clamp(a[4], 0, 6) - 3) / 3.0f * sp[3];
    if (sp[24] > 0.5f) {
        float r_ph = (float)(clamp(a[5], 0, 6) - 3) / 3.0f * sp[4];
        float r_zz = (float)(clamp(a[6], 0, 6) - 3) / 3.0f * sp[5];
        s[S0+22] = clamp(s[S0+22] + r_ph*PI_/180.0f*dt, sp[6], sp[7]);
        s[S0+23] = clamp(s[S0+23] + r_zz*dt, sp[8], sp[9]);
    }
    s[S0+15] = s[S0+15] + r_az*dt + 0.02f*rb[0];
    s[S0+14] = clamp(s[S0+14] + r_el*dt + 0.02f*rb[1],
                     sp[14] - 2.0f, sp[15] + 1.0f);
    float e_el = s[S0+14] - el0;
    float e_az = (s[S0+15] - az0d) * cos(el0*PI_/180.0f);
    // ---- heads, jam, servo
    s[S0+1] = sp[1] * sp[54 + clamp(a[0], 0, 6)];
    s[S0+3] = ((float)a[1] > sp[10]) ? 1.0f : 0.0f;
    float want = ((float)a[2] > sp[10]) ? 1.0f : 0.0f;
    bool jamming = (s[S0+4] < 0.5f) && (want > 0.5f);
    s[S0+4] = want;
    bool soft = want < 0.5f;
    s[S0+6] += soft ? 1.0f : 0.0f;
    float bias = 0.05f * (s[S0+24] - 400.0f) / 10.0f;   // prev dni
    s[S0+2] = clamp(s[S0+2] + (bias - s[S0+2])*sp[48] + 1.2f*rb[2],
                    -40.0f, 60.0f);
    if (soft)
        s[S0+0] += clamp(s[S0+1] + s[S0+2] - s[S0+0], -6.0f, 6.0f);
    if (jamming) s[S0+5] = s[S0+0];
    float decl = 23.44f * sin(2.0f*PI_*(284.0f + day[b])/365.0f);
    s[S0+31] = decl;
    if (soft) s[S0+7] = decl;
    // ---- sun scalars, cloud/wind OU (ts already advanced host-side)
    float ts = mprm[0] + sp[42];
    float sinel = sin(el0*PI_/180.0f);
    float am = 1.0f / max(sinel, 0.035f);
    float clearw = (el0 > 2.0f)
        ? 1353.0f * pow(0.7f, pow(am, 0.678f)) : 0.0f;
    float cl = s[S0+18];
    cl = cl - cl*sp[48] + sp[44]*rb[3];
    if (ru[b*16+0] < sp[47]) cl -= 1.5f;
    cl = clamp(cl, -3.0f, 0.25f);
    s[S0+18] = cl;
    float base_w = 2.5f
        + 3.5f*sin(PI_*clamp((ts - 8.0f)/8.0f, 0.0f, 1.0f));
    float wg = s[S0+19] - s[S0+19]*sp[49] + sp[45]*rb[4];
    s[S0+19] = wg;
    float wind = clamp((base_w + wg)*sp[12], 0.0f, 25.0f);
    bool stw = ((s[S0+26] > 0.5f) || (wind > 16.0f))
               && !(wind < 14.0f);
    s[S0+26] = stw ? 1.0f : 0.0f;
    s[S0+25] = wind;
    float day_up = (el0 > 8.0f) ? 1.0f : 0.0f;
    float cosw = day_up * sp[16];   // (not 'cosf': CUDA math name)
    float dni = clearw * exp(cl) * day_up * (stw ? 0.0f : 1.0f);
    s[S0+24] = dni;
    // ---- wind -> figure, jam-gated
    float qw = 0.6f * wind * wind;
    float gain = (want > 0.5f) ? sp[11] : 1.0f;
    float p_eff = ((want > 0.5f) ? s[S0+5] : s[S0+0])
                  + gain*qw*sign(rb[5]);
    float sigw = gain * 0.88e-3f * pow(max(qw, 1e-9f)/15.0f, 0.6f);
    float sigd = fabs(s[S0+7] - decl) * PI_/180.0f * 0.04f;
    sigb[b] = sqrt(sp[13]*sp[13] + (0.7f*sigw)*(0.7f*sigw)
                   + sigd*sigd);
    off[b*2+0] += -off[b*2+0]*sp[50] + sp[46]*rb[6];
    off[b*2+1] += -off[b*2+1]*sp[50] + sp[46]*rb[7];
    // ---- trace inputs
    lv[b] = clamp((p_eff/sp[1] - sp[36])/sp[37]*sp[35],
                  0.0f, sp[35]);
    dvec[b*2+0] = 2.0f*sp[34]*e_el*PI_/180.0f;
    dvec[b*2+1] = 2.0f*sp[34]*e_az*PI_/180.0f;
    float ph = s[S0+22], zt = s[S0+23];
    float rt = sqrt(max(sp[29]*sp[29] - (zt - sp[30])*(zt - sp[30]),
                        1e-4f)) * 0.999f;
    float3 a1 = normalize(float3(rt*cos(ph) - sp[31],
                                 rt*sin(ph) - sp[32], zt - sp[33]));
    aim[b*3+0] = a1.x; aim[b*3+1] = a1.y; aim[b*3+2] = a1.z;
    // ---- gate + scratch for post
    s[S0+30] = dni * cosw * s[S0+3] * want;
    s[S0+27] = el0; s[S0+28] = az0d; s[S0+29] = potp;
    s[S0+32] = e_el; s[S0+33] = e_az;
    for (int i = 0; i < N; i++) per[b*N + i] = 0.0f;
}

kernel void step_post(
    device float*       rew   [[buffer(0)]],   // (B,) FIRST: grid = B
    device float*       st    [[buffer(1)]],
    device const float* per   [[buffer(2)]],   // (B,N) from trace
    device const float* sp    [[buffer(3)]],
    device const int*   ip    [[buffer(4)]],
    device const float* rn    [[buffer(5)]],
    device const float* ru    [[buffer(6)]],
    device const float* day   [[buffer(7)]],
    device const float* lat   [[buffer(8)]],
    device const float* mprm  [[buffer(9)]],
    device const float* off   [[buffer(10)]],  // bore, for obs
    device float*       obs   [[buffer(11)]],  // (B,OD)
    device float*       trc   [[buffer(12)]],
    device float*       diag  [[buffer(13)]],  // (B,8)
    device const int*   act   [[buffer(14)]],  // (B,NH) load-mask heads
    uint b [[thread_position_in_grid]])
{
    if ((int)b >= ip[0]) return;
    const float PI_ = 3.14159265358979f;
    const float SIG = 5.67e-8f;
    const int N = ip[1], NB = ip[2], NS = ip[4], OD = ip[5];
    device float* s = st + b*NS;
    const int S0 = 3*N + 1 + 4*NB;
    device float* Tsub = s + N;
    device float* Tdeep = s + 2*N;
    device float* bE = s + 3*N + 1;
    device float* bt_ = bE + NB;
    device float* bC = bt_ + NB;
    device float* hb = bC + NB;
    device const float* pv = per + b*N;
    device const float* NA = sp + 63;
    device const float* HC = NA + N;
    device const float* CS = HC + N;
    device const float* CD_ = CS + N;
    device const float* G01 = CD_ + N;
    device const float* G12 = G01 + N;
    device const float* G2S = G12 + N;
    const float dt = sp[0];
    const float gate = s[S0+30];
    float Tv[NMAX], t4v[NMAX], qv[NMAX];
    float p_in = 0.0f;
    for (int i = 0; i < N; i++) {
        Tv[i] = s[i];
        t4v[i] = Tv[i]*Tv[i]*Tv[i]*Tv[i];
        qv[i] = pv[i]*gate*0.85f;
        p_in += pv[i];
    }
    p_in *= gate;
    // ---- spot_bread: the loaf takes the beam directly
    int kb = 0; float validc = 0.0f, q_direct = 0.0f;
    if (sp[25] > 0.5f) {
        float phs = s[S0+22];
        kb = ((int)((phs + PI_)/(2.0f*PI_)*(float)NB)) % NB;
        float zt = s[S0+23];
        validc = (zt >= sp[22] && zt <= sp[23]) ? 1.0f : 0.0f;
        float lit = (hb[kb] > 0.5f && validc > 0.5f) ? 1.0f : 0.0f;
        float frb = clamp(bE[kb]/sp[19], 0.0f, 1.0f);
        float alpha = 0.55f + 0.35f*frb;
        float inc = pv[kb]*gate;
        q_direct = lit*alpha*sp[21]*inc;
        qv[kb] -= lit*0.85f*sp[21]*inc;
        bE[kb] += q_direct*dt;
    }
    // ---- thermal (polar's copy)
    float t4s = 0.0f;
    for (int i = 0; i < N; i++) t4s += NA[i]*t4v[i];
    float tc4 = t4s / sp[52];
    float lid = (s[S0+8] < 4.0f) ? 1.0f : sp[17];
    float ta4 = sp[43]*sp[43]*sp[43]*sp[43];
    float q_ap = 0.75f*SIG*(tc4 - ta4)*sp[51]*lid;
    float Th = s[3*N];
    float q2sum = 0.0f;
    for (int i = 0; i < N; i++) {
        float q_exch = 0.85f*SIG*NA[i]*(tc4 - t4v[i]);
        float q01 = G01[i]*(Tv[i] - Tsub[i]);
        float q12 = G12[i]*(Tsub[i] - Tdeep[i]);
        float q2s = G2S[i]*(Tdeep[i] - Th);
        qv[i] = qv[i] + q_exch - q01;
        Tsub[i] += (q01 - q12)*dt/CS[i];
        Tdeep[i] += (q12 - q2s)*dt/CD_[i];
        q2sum += q2s;
    }
    s[3*N] = Th + (q2sum - sp[38]*(Th - sp[43]))*dt/sp[39];
    qv[NB+2] -= q_ap;
    for (int k = 0; k < NB; k++) {
        // dough exchanges at its own temperature: room-temp
        // coldstart warming to ~400 K at full bake (numpy twins)
        float fdn = clamp(max(bE[k], 0.0f)/sp[19], 0.0f, 1.0f);
        float qb = hb[k]*sp[18]*(Tv[k] - (sp[43] + 100.0f*fdn));
        qv[k] -= qb;
        bE[k] += qb*dt;
        bt_[k] += hb[k]*dt;
    }
    float dT_h = 0.0f;
    for (int i = 0; i < N; i++) {
        float dT = qv[i]*dt/HC[i];
        s[i] = Tv[i] + dT;
        if (i == NB) dT_h = dT;
    }
    float spall = (dT_h > 25.0f) ? 1.0f : 0.0f;
    s[S0+11] += spall;
    // ---- bread: char rate, ready waits for the cook's lean
    float r = 0.0f;
    float cooked_n = 0.0f, scorch_n = 0.0f;
    // ONE lean event: pull and load share the opening (post-
    // increment timer; see the numpy twins)
    bool pull = s[S0+8] + dt >= sp[20];
    for (int k = 0; k < NB; k++) {
        float bT = s[k];
        float cdot = max(bT - 800.0f, 0.0f)/6000.0f;
        if (sp[25] > 0.5f && k == kb) {
            float fkw = q_direct/max(sp[53], 1e-6f)/1000.0f;
            cdot += max(fkw - 8.0f, 0.0f)/1000.0f*validc;
        }
        bC[k] += hb[k]*cdot*dt;
        bool has = hb[k] > 0.5f;
        bool ready = has && (bE[k] >= sp[19]);
        bool ckd = ready && pull;
        bool scd = has && (bC[k] >= 1.0f);
        // NO doughy timeout: cooked or charred only (numpy twins)
        cooked_n += ckd ? 1.0f : 0.0f;
        scorch_n += scd ? 1.0f : 0.0f;
        if (ckd || scd) {
            hb[k] = 0.0f; bE[k] = 0.0f; bt_[k] = 0.0f; bC[k] = 0.0f;
        }
    }
    r += 5.0f*cooked_n - 5.0f*scorch_n - 0.5f*spall;
    s[S0+9] += cooked_n;
    s[S0+34] += cooked_n;    // day_rotis: cut-immune daily count
    s[S0+10] += scorch_n;
    s[S0+8] += dt;
    // ---- the lean's dough (numpy twins line for line): either the
    // POLICY's load-mask heads place it (load_ctrl) or the cook's
    // xor hash sprays it. Only physics either way: empty bins only,
    // loaves_per_load per lean.
    if (s[S0+8] >= sp[20]) {
        int LPL = (int)sp[61];
        if (sp[62] > 0.5f) {
            int NH = ip[3];
            device const int* am_ = act + b*NH + (NH - NB);
            int left = LPL;
            for (int k = 0; k < NB; k++) {
                if (left > 0 && (float)am_[k] > sp[10]
                    && hb[k] < 0.5f) {
                    hb[k] = 1.0f; left--; r += 0.3f;
                }
            }
        } else {
            uint yt = (uint)ip[6];
            for (int _k = 0; _k < LPL; _k++) {
                uint hs = (uint)b + yt*57u + (uint)_k*241u;
                hs = (hs << 13) ^ hs;
                uint vv = (hs * (hs*hs*15731u + 789221u)
                           + 1376312589u) & 0x7FFFFFFFu;
                // HIGH bits (the float original's /2^30): low bits
                // are structured - %NB clumped 62.5% into one bin
                int j = (int)((ulong(vv) * ulong(NB)) >> 31);
                if (hb[j] < 0.5f) { hb[j] = 1.0f; r += 0.3f; }
            }
        }
        s[S0+8] = 0.0f;
    }
    // BANDED-SUM preheat potential, REINSTATED (numpy twins):
    // sum of sub-453 rises over all bins, in-step old vs new
    float shp = 0.0f;
    for (int k = 0; k < NB; k++)
        shp += clamp(min(s[k], sp[27]) - min(Tv[k], sp[27]),
                     -5.0f, 5.0f);
    r += 0.05f*shp;
    float bmax = -1e30f;
    for (int k = 0; k < NB; k++) bmax = max(bmax, s[k]);
    s[S0+17] = bmax;
    r += -0.02f*((s[S0+4] < 0.5f) ? 1.0f : 0.0f);
    // ---- Hashemi pointing shaping + lost counter
    float e_el2 = s[S0+32], e_az2 = s[S0+33];
    float potn = min(fabs(e_az2) + fabs(e_el2), 8.0f);
    r += 1.0f*(s[S0+29] - potn);
    s[S0+20] = e_az2; s[S0+21] = e_el2;
    bool lost = (fabs(e_az2) + fabs(e_el2)) > 8.0f;
    s[S0+16] = lost ? s[S0+16] + 1.0f : 0.0f;
    bool cut = s[S0+16] >= 480.0f;
    s[S0+12] += r;
    s[S0+13] += 1.0f;
    // ---- lost-sun truncation: ALWAYS COLD, charge-and-crash closed
    float trv = 0.0f;
    if (cut) {
        // charge-and-crash closed EXACTLY: refund the potential of
        // the state being wiped (Phi of cold reset ~ 0) plus the
        // in-flight load bonuses
        float nb_ = 0.0f;
        for (int k = 0; k < NB; k++) {
            nb_ += hb[k];
            nb_ += (0.05f/0.3f)*max(min(s[k], sp[27]) - 350.0f,
                                    0.0f);
        }
        r -= 0.3f*nb_;
        for (int i = 0; i < N; i++) {
            float nt = 350.0f + (ru[b*16 + 1 + i] - 0.5f)*30.0f;
            s[i] = nt; Tsub[i] = nt; Tdeep[i] = nt;
        }
        s[3*N] = 300.0f;
        s[S0+9] = 0.0f; s[S0+10] = 0.0f; s[S0+11] = 0.0f;
        s[S0+12] = 0.0f; s[S0+13] = 0.0f;
        for (int k = 0; k < NB; k++) {
            bE[k] = 0.0f; bt_[k] = 0.0f; hb[k] = 0.0f;
            bC[k] = 0.0f;      // fresh dough carries no char
        }
        s[S0+1] = sp[1]; s[S0+0] = sp[1];
        float el1, az1d;
        solar_pos(lat[b], day[b], mprm[0] + sp[42], &el1, &az1d);
        s[S0+14] = clamp(el1 + 0.3f*rn[b*12+10], sp[14], sp[15]);
        s[S0+15] = az1d + 0.3f*rn[b*12+11];
        s[S0+16] = 0.0f;
        e_el2 = s[S0+14] - el1;
        e_az2 = (s[S0+15] - az1d)*cos(el1*PI_/180.0f);
        s[S0+21] = e_el2; s[S0+20] = e_az2;
        float bm = -1e30f;
        for (int k = 0; k < NB; k++) bm = max(bm, s[k]);
        s[S0+17] = bm;
        trv = 1.0f;
    }
    trc[b] = trv;
    rew[b] = r;
    // ---- obs (matches _gpu_obs column for column)
    float hn = (mprm[0] + sp[42] - 8.0f)/8.0f;
    device float* ob = obs + b*OD;
    int o = 0;
    ob[o++] = sin(PI_*hn);
    ob[o++] = cos(PI_*hn);
    ob[o++] = s[S0+24]/1000.0f;
    for (int i = 0; i < N; i++) ob[o++] = s[i]/1000.0f;
    if (sp[26] > 0.5f) {
        float ms = 0.0f, md = 0.0f;
        for (int k = 0; k < NB; k++) { ms += Tsub[k]; md += Tdeep[k]; }
        ob[o++] = ms/(float)NB/1000.0f;
        ob[o++] = md/(float)NB/1000.0f;
        ob[o++] = s[3*N]/1000.0f;
    }
    ob[o++] = (s[S0+0] - sp[1])/60.0f;
    ob[o++] = s[S0+3];
    ob[o++] = s[S0+25]/10.0f;
    ob[o++] = clamp(off[b*2+0]/0.1f, -2.0f, 2.0f);
    ob[o++] = clamp(off[b*2+1]/0.1f, -2.0f, 2.0f);
    ob[o++] = clamp(s[S0+8]/45.0f, 0.0f, 2.0f);
    for (int k = 0; k < NB; k++) ob[o++] = bE[k]/sp[19];
    for (int k = 0; k < NB; k++) ob[o++] = bC[k];
    ob[o++] = p_in/6000.0f;
    ob[o++] = s[S0+4];
    ob[o++] = clamp(fabs(s[S0+7] - s[S0+31])/10.0f, 0.0f, 3.0f);
    ob[o++] = clamp((e_el2 + 0.03f*rn[b*12+8])/0.5f, -3.0f, 3.0f);
    ob[o++] = clamp((e_az2 + 0.03f*rn[b*12+9])/0.5f, -3.0f, 3.0f);
    if (sp[24] > 0.5f) {
        ob[o++] = (s[S0+22] - sp[40])/2.0f;
        ob[o++] = (s[S0+23] - sp[41])/1.0f;
        int kb2 = ((int)((s[S0+22] + PI_)/(2.0f*PI_)*(float)NB)) % NB;
        for (int k = 0; k < NB; k++)
            ob[o++] = (k == kb2) ? 1.0f : 0.0f;
    }
    if (sp[62] > 0.5f)
        for (int k = 0; k < NB; k++) ob[o++] = hb[k];
    diag[b*8+0] = p_in;
    diag[b*8+1] = e_el2;
    diag[b*8+2] = e_az2;
    diag[b*8+3] = q_direct/max(sp[53], 1e-6f);
    diag[b*8+4] = s[S0+25];
    diag[b*8+5] = s[S0+24];
    diag[b*8+6] = 0.0f;
    diag[b*8+7] = 0.0f;
}
"""


class MetalGeo:
    """Wraps the megakernel; call signature mirrors the fused-core args."""

    def __init__(self):
        self.lib = torch.mps.compile_shader(MSL)
        self._dims = {}
        self._mbuf = {}

    def mount(self, day_t, lat_t, prm_t, B):
        """The mount solve as ONE kernel launch: B threads, each env
        computes its own sun, beta schedule and frames in registers.
        Returns the same dict contract as tandoor_mount_batch."""
        dev = day_t.device
        key = (B, dev)
        bufs = self._mbuf.get(key)
        if bufs is None:
            z = lambda n: torch.empty(B, n, dtype=torch.float32,
                                      device=dev)
            bufs = (z(21), z(9), z(3), z(9), z(6), z(8),
                    torch.tensor([B], dtype=torch.int32, device=dev))
            self._mbuf[key] = bufs
        vp, Mt, Cd, Ac, scb, aux, nB = bufs
        self.lib.mount_solve(vp, Mt, Cd, Ac, scb, aux,
                             day_t.contiguous(), lat_t.contiguous(),
                             prm_t, nB)
        return dict(vp=vp, Mt=Mt.view(B, 3, 3), Cd=Cd,
                    Acan=Ac.view(B, 3, 3), scb=scb, aux=aux,
                    el=aux[:, 0], az=aux[:, 1], el_b=aux[:, 2],
                    beta_t=aux[:, 6])

    def __call__(self, pts_l, nrm_l, lv, du, de, upick, us, sigb,
                 Acan, Mt, Cd, dvec, off, vp, sc, ellM, ellS, ellC,
                 V0t, ray_pw, soil, n_nodes, aim, scb):
        B, P = du.shape
        L = pts_l.shape[0]
        dev = du.device
        thr = torch.empty(B * P, dtype=torch.float32, device=dev)
        out6 = torch.empty(B * P, 6, dtype=torch.float32, device=dev)
        per = torch.zeros(B, n_nodes, dtype=torch.float32, device=dev)
        key = (B, P, L, n_nodes, dev)
        dims = self._dims.get(key)
        if dims is None:
            dims = torch.tensor([B, P, L, n_nodes],
                                dtype=torch.int32, device=dev)
            self._dims[key] = dims
        c = lambda t: t.contiguous()
        self.lib.tandoor_trace(
            thr, out6, c(pts_l), c(nrm_l), c(lv), c(du), c(de), c(upick),
            c(sigb), c(dvec.reshape(B, -1)[:, :2]), c(off), c(vp), c(sc),
            c(Acan), c(Mt), c(Cd), c(ellM), c(ellS), c(ellC), c(V0t),
            dims, c(ray_pw), c(soil), per, c(us), c(aim), c(scb))
        return thr.view(B, P), out6.view(B, P, 6), per

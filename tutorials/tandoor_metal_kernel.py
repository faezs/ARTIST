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
#define NX 37     // EXTERIOR SURFACE BINS (the miss ledger as flux): 0-7 collar by azimuth, 8-13 bore wall by height, 14 deck, 15-18 pot exterior by latitude, 19 pit floor, 20 escaped, 21-24 dish blocks the return (by dish radius), 25-28 strip shadow (by radius), 29-32 slot (by radius), 33 hole, 34 F arm, 35 strip window, 36 missed the conic
#define FCTW 82   // per-env design table width: [0..39] receiver chain, [40..59] system, [60] surface block, [70] sand depth, [71] sand conductivity, [72] receiver kind (0 cass / 1 tri), [73] elbow class, [74] aim half-travel [rad], [75] site azimuth offset [rad], [76..77] pit radius/depth scales, [78..81] the pit sphere: Z_CPOT, R_SPH, R_DUCT_WALL, H_DEPTH
#define KSAND 8   // layers of the sand column under the hearth and the floor (>= 5 cm each)
#define RU 20     // uniforms per agent per step: [0] cloud, [1..15] fresh-pot temps, [16..19] the demand process
#define NDEM 3    // demand state per agent at the row's end: orders waiting, rotis on the shelf, sold today
#define SPX 72    // the per-node thermal tables start here in sp; [66] demand on, [67] rotis/day, [68] shelf life min, [69] patience min, [70] stale penalty, [71] inlet escape
inline float demand_rate(float t, float dem_day) {
    // customers per hour: three bands, breakfast / lunch / dinner, Gaussian
    // bumps in solar hours whose shares sum to one, scaled by the shop's
    // daily demand (rotis/day)
    const float c[3] = {7.5f, 13.0f, 19.5f}, w[3] = {0.75f, 1.0f, 1.0f}, sh[3] = {0.25f, 0.35f, 0.40f};
    float r = 0.0f;
    for (int i = 0; i < 3; i++) { float z = (t - c[i])/w[i]; r += sh[i]/(w[i]*2.5066283f)*exp(-0.5f*z*z); }
    return dem_day * r;
}
#define SAND_RC 1.28e6f
inline float ds_fct_depth(device const float* fct, uint b) { return fct[b*FCTW + 70]; }

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
    device float*       scb_o  [[buffer(4)]],   // (B,7): cosi, slot, kt, ks, ray_scale, el_ok, psi
    device float*       aux_o  [[buffer(5)]],   // (B,8) el [deg], az [RAD - measured, not deg], elb, ub3, beta
    device const float* day    [[buffer(6)]],
    device const float* lat    [[buffer(7)]],
    device const float* prm    [[buffer(8)]],   // params + shadow tables
    device const int*   nB     [[buffer(9)]],
    device const float* pnt    [[buffer(10)]],  // (B,2) el_m, az_m deg; < -900 = square to the sun
    device const float* fct    [[buffer(11)]],  // (B,FCTW) per-env design: [42] z_fold [53] f [54] a_mem [55] g_orbit
    uint b [[thread_position_in_grid]])
{
    if ((int)b >= nB[0]) return;
    const float PI_ = 3.14159265358979f;
    float hour = prm[0], beta_dev = prm[1], cap_z = prm[2];
    // THE SYSTEM IS THE DESIGN: dish radius, focal length, orbit and
    // fold height are per env (design table), nominal = prm[3,12,5,4]
    device const float* ds_m = fct + b*FCTW;
    float a_mem = ds_m[54], z_fold = ds_m[42], g_orb = ds_m[55];
    float el_x = prm[6];
    float xtw = prm[9], sc1b = prm[10], ftor = prm[11];
    float fnom = ds_m[53], zwst = prm[13];
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
    az = az - ds_m[75];                                  // THE SITE'S ORIENTATION: the sun in the machine's frame (solar_batch az_off)
    az = az - 2.0f*PI_*floor(az/(2.0f*PI_));
    float3 u = float3(cos(elr)*cos(az), cos(elr)*sin(az), sinel);
    u = normalize(u);          // ENU swapped: x=north comp = cos*cos
    // THE POINTING IS REAL: the dish frame from the mount (pnt), the
    // incident rays from the sun (u). Matches mount_batch.
    float3 um = u;
    if (pnt[b*2] > -900.0f) {
        float elm = pnt[b*2] * PI_ / 180.0f, azm = pnt[b*2+1] * PI_ / 180.0f;
        um = normalize(float3(cos(elm)*cos(azm), cos(elm)*sin(azm), sin(elm)));
    }
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
    float3 ax = cross(zh, um);
    float axn = length(ax);
    float3 ub;
    if (axn > 1e-6f) {
        float3 axu = ax / axn;
        float br = bt * PI_ / 180.0f;
        float cb = cos(br), sb = sin(br);
        ub = um*cb + cross(axu, um)*sb + axu*dot(axu, um)*(1.0f-cb);
    } else { ub = um; }
    ub = normalize(ub);
    float3 Pf = float3(xtw, 0.0f, z_fold);
    float3 Cdv = Pf - g_orb * ub;
    float3 naim = normalize(um + ub);
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
    // receiver at the focus (prm[42]): the beam-down M1 sends the
    // beam along the tilted exit prm[43..45] instead of straight down
    // receiver at the focus (prm[42]): M1 on the azimuth turntable exits
    // toward the WEST while the sun is east (u.y > 0), EAST while west,
    // at prm[43] rad above horizontal; M2 prm[44] along it; M3 fixed
    // at prm[45..47] with its normal trimmed per leg (frame x N, y E)
    const bool fc_on = prm[42] > 0.5f;
    float fc_ey = ((u.y > 0.0f) ? -1.0f : 1.0f) * cos(prm[43]);
    float3 fc_ex = float3(0.0f, fc_ey, sin(prm[43]));
    float3 nf = fc_on ? normalize(ub - fc_ex) : normalize(ub + zh);
    float cosi = fabs(dot(ub, nf));
    float3 epar = normalize(ub - dot(ub, nf)*nf);
    float3 eprp = cross(nf, epar);
    float3 epp = cross(ub, -pup);
    // vp rows: u, Pf, -pup, epp, nf, epar, eprp  (focus: u, Pf, e, P2, nf, A2, n3)
    int vb = b*21;
    float3 fc_P2 = Pf + prm[44]*fc_ex;
    float3 fc_P3 = float3(prm[45], prm[46], prm[47]);
    float3 fc_A2 = normalize(fc_P3 - fc_P2);
    float3 fc_n3 = normalize(fc_A2 + zh);
    float fc_f2 = 0.5f*prm[44]*(1.0f - dot(fc_ex, fc_A2));
    float3 rows[7] = {u, Pf, fc_on ? fc_ex : ((prm[48] > 0.5f) ? um : -pup), fc_on ? fc_P2 : epp, nf,
                      fc_on ? fc_A2 : epar, fc_on ? fc_n3 : eprp};
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
    int sb2 = b*7;
    scb_o[sb2+0] = cosi; scb_o[sb2+1] = fc_on ? fc_f2 : slot;
    scb_o[sb2+2] = kt;   scb_o[sb2+3] = ks;
    scb_o[sb2+4] = rscale; scb_o[sb2+5] = elok;
    // psi: the turn about the normal from the trace's dish x axis (row 0 of
    // Mt = column 0 of M) to the body 'up' (z-hat's part in the dish plane);
    // a SECTION's body-frame film is turned by it in the trace (torch twin:
    // tandoor_mount_batch)
    {
        float3 ex_w = float3(M9[0], M9[3], M9[6]);
        float3 n_w  = float3(M9[2], M9[5], M9[8]);
        float3 upv = zh - dot(zh, n_w)*n_w;
        float upn = length(upv);
        upv = (upn > 1e-6f) ? upv / upn : ex_w;
        scb_o[sb2+6] = atan2(dot(cross(ex_w, upv), n_w), dot(ex_w, upv));
    }
    aux_o[b*8+0] = el;
    aux_o[b*8+1] = az;                 // radians, dict contract
    aux_o[b*8+2] = elb;
    aux_o[b*8+3] = ub.x; aux_o[b*8+4] = ub.y; aux_o[b*8+5] = ub.z;
    aux_o[b*8+6] = bt;
    aux_o[b*8+7] = 0.0f;
}

// ---- receiver-at-focus helpers (transcribed from _geo_core_focus)
static inline bool fc_blocked(float3 p, float3 u, float3 c, float r) {
    float3 vc = c - p;
    float ah = dot(vc, u);
    float3 perp = vc - ah*u;
    return (ah > 0.0f) && (length(perp) < r);
}
static inline float fc_seg_dist(float3 p, float3 u, float3 A, float3 B,
                                thread float &t_out) {
    float3 AB = B - A;
    float c = dot(AB, AB);
    float3 w0 = p - A;
    float b = dot(u, AB), d = dot(w0, u), e = dot(w0, AB);
    float den = max(c - b*b, 1e-9f);
    float sseg = clamp((e - b*d)/den, 0.0f, 1.0f);
    float t = max(sseg*b - d, 0.0f);
    t_out = t;
    return length(p + t*u - (A + sseg*AB));
}
static inline float fc_parab_hit(float3 h, float3 d, float3 Fp, float3 ax,
                                 float f2, thread float3 &X,
                                 thread float3 &n, thread bool &valid) {
    float3 q = h - Fp;
    float dA = dot(d, ax);
    float qA = dot(q, ax) + 2.0f*f2;
    float qa = 1.0f - dA*dA;
    float qb = 2.0f*(dot(q, d) - qA*dA);
    float qc = dot(q, q) - qA*qA;
    float disc = qb*qb - 4.0f*qa*qc;
    float sq = sqrt(max(disc, 0.0f));
    float sgn = (qb < 0.0f) ? -1.0f : 1.0f;
    float qq = -0.5f*(qb + sgn*sq);
    float tA = (fabs(qa) > 1e-12f) ? qq/qa : 1e30f;
    float tB = (fabs(qq) > 1e-12f) ? qc/qq : 1e30f;
    tA = (tA > 1e-6f) ? tA : 1e30f;
    tB = (tB > 1e-6f) ? tB : 1e30f;
    float t = min(tA, tB);
    X = h + t*d;
    valid = (disc >= 0.0f) && (t < 1e8f) && ((qA + t*dA) > 0.0f);
    float3 rad = X - Fp;
    float3 nn = rad/max(length(rad), 1e-9f) - ax;
    n = nn/max(length(nn), 1e-9f);
    return t;
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
    device const float* lfp    [[buffer(27)]],  // [0] loaf half-size (m): the footprint comes from the trace
    device const float* fct    [[buffer(28)]],  // (B,FCTW) PER-AGENT design table: _fc_table + r_duct (0..39), the system block (40..), and the receiver's own columns (72 kind, 73 elbow, 74 aim travel)
    device float*       fate   [[buffer(29)]],  // (B*P,6) THE MISS LEDGER: [0] fate code, [1..3] the world point the ray stopped at, [4] surface id, [5] exterior bin (see mk_ block)
    device float*       pex    [[buffer(30)]],  // (B,NX) EXTERIOR FLUX: a missed ray's power deposited on the surface it stopped at - the pot's per_dni, for everything that is not the pot
    uint tid [[thread_position_in_grid]])
{
    const int B = dims[0], P = dims[1], L = dims[2];
    if (tid >= uint(B*P)) return;
    const int b = tid / P, ip = tid % P;
    const int vb = b*21;
    const int sb = b*7;
    const float3 ut   = float3(vp[vb+0],  vp[vb+1],  vp[vb+2]);
    const float3 Pf   = float3(vp[vb+3],  vp[vb+4],  vp[vb+5]);
    const float3 sdir = float3(vp[vb+6],  vp[vb+7],  vp[vb+8]);
    const float3 epp  = float3(vp[vb+9],  vp[vb+10], vp[vb+11]);
    const float3 nf   = float3(vp[vb+12], vp[vb+13], vp[vb+14]);
    const float3 epar = float3(vp[vb+15], vp[vb+16], vp[vb+17]);
    const float3 eprp = float3(vp[vb+18], vp[vb+19], vp[vb+20]);
    const float3 CdV  = float3(Cd[b*3+0], Cd[b*3+1], Cd[b*3+2]);

    // ---- membrane level-lerp (the fused bounce); the SURFACE BLOCK from the
    // design table [60]: pts_l stacks L levels per block (0 the built circle,
    // k the k-th installed section of the parent), ray_pw one row per block
    float lvb = lv[b];
    int sblk = clamp(int(fct[b*FCTW + 60] + 0.5f), 0, dims[4] - 1);   // the surface block (dims[4] = blocks installed)
    int i0 = clamp(int(lvb), 0, L-2);
    float fr = lvb - float(i0);
    i0 += sblk*L;
    int o0 = (i0*P + ip)*3, o1 = ((i0+1)*P + ip)*3;
    float3 p_loc = (1.0f-fr)*float3(pts_l[o0],pts_l[o0+1],pts_l[o0+2])
                 +        fr*float3(pts_l[o1],pts_l[o1+1],pts_l[o1+2]);
    float3 n_loc = (1.0f-fr)*float3(nrm_l[o0],nrm_l[o0+1],nrm_l[o0+2])
                 +        fr*float3(nrm_l[o1],nrm_l[o1+1],nrm_l[o1+2]);
    n_loc = normalize(n_loc);
    if (sblk > 0) {
        // a SECTION: its points live in the dish's BODY frame (x up the
        // dish); the trace's dish frame is turned about the normal by
        // psi (scb[6], from the mount solve) - turn the film to match
        float cps = cos(scb[sb+6]), sps = sin(scb[sb+6]);
        p_loc = float3(cps*p_loc.x - sps*p_loc.y, sps*p_loc.x + cps*p_loc.y, p_loc.z);
        n_loc = float3(cps*n_loc.x - sps*n_loc.y, sps*n_loc.x + cps*n_loc.y, n_loc.z);
    }
    // the dish scale (design table [40]): a uniform scaling of the
    // membrane about the frame origin keeps the paraboloid family,
    // f and a scale together (the mount's g_orbit and f_nom follow)
    p_loc = p_loc * fct[b*FCTW + 40];

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

    // ==== shared outputs of the two receiver chains
    bool sh_thr = false; float sh_w = 1.0f;
    float sh_fate = -1.0f; float3 sh_stop = float3(0.0f, 0.0f, 0.0f);  // the miss ledger; -1 = this chain keeps none (fold/focus)
    int sh_surf = -1, sh_bin = -1;                                       // ...and the exterior surface / bin it lands its power on
    float3 sh_h3 = float3(0.0f), sh_d3 = float3(0.0f);
    float sh_dy = 0.0f, sh_dz = 0.0f;
    if (sc[106] > 0.5f && sc[106] < 1.5f) {
    // ==== RECEIVER AT THE FOCUS (sc[106..138], _build_focus_chain):
    // M1 flat AT F -> M2 off-axis paraboloid collimator (focus F) ->
    // M3 flat at the wall line -> chase -> M4 off-axis paraboloid at the
    // turn (focus = duct mouth) -> duct plane. Mirrors _geo_core_focus.
    const float3 fc_F = Pf;
    const float fc_rm1 = sc[110];
    const float3 fc_Ps = float3(sc[107], sc[108], sc[109]);   // strut base
    // per-env, per-step (the exit switches sides with the sun): the
    // mount's rows 2,3,5,6 carry e, M2, the leg A2 and M3's normal;
    // scb[1] carries M2's parent focal length
    const float3 fc_P2 = epp;      // vp row 3
    const float3 fc_A2 = epar;     // vp row 5
    const float3 fc_n3 = eprp;     // vp row 6
    const float fc_f2 = scb[sb+1], fc_r2 = sc[118];
    const float3 fc_P3 = float3(sc[119], sc[120], sc[121]);
    const float fc_r3 = sc[125], fc_rbore = sc[126];
    const float3 fc_P4 = float3(sc[127], sc[128], sc[129]);
    const float3 fc_F4 = float3(sc[130], sc[131], sc[132]);
    const float fc_f4 = sc[133], fc_r4 = sc[134], fc_rstrut = sc[135];
    const float fc_zbot = sc[136], fc_xchase = sc[137], fc_ychase = sc[138];
    const float3 fc_zh = float3(0.0f, 0.0f, 1.0f);
    bool fc_lit = !fc_blocked(p, ut, fc_F, fc_rm1)
               && !fc_blocked(p, ut, fc_P2, fc_r2)
               && !fc_blocked(p, ut, fc_P3, fc_r3);
    float fc_ts; float fc_ds = fc_seg_dist(p, ut, fc_Ps, fc_F, fc_ts);
    fc_lit = fc_lit && (fc_ds > fc_rstrut);
    float fc_den = dot(d, nf);
    float fc_denu = (fabs(fc_den) > 1e-9f) ? fc_den : 1e-9f;
    float fc_t1 = dot(fc_F - p, nf) / fc_denu;
    float3 fc_h1 = p + fc_t1*d;
    float fc_rad1 = length(fc_h1 - fc_F);
    float fc_tsg; float fc_dsg = fc_seg_dist(p, d, fc_Ps, fc_F, fc_tsg);
    bool fc_graze = (fc_dsg < fc_rstrut) && (fc_tsg < fc_t1 - 0.10f);
    float3 fc_vc2 = fc_P2 - p;
    float fc_tp2 = dot(fc_vc2, d);
    float fc_perp2 = length(fc_vc2 - fc_tp2*d);
    fc_graze = fc_graze || ((fc_perp2 < fc_r2) && (fc_tp2 > 0.0f)
                            && (fc_tp2 < fc_t1 - 0.10f));
    bool fc_ok = fc_lit && !fc_graze && (fc_t1 > 0.0f) && (fc_rad1 < fc_rm1);
    float3 fc_d2 = d - 2.0f*dot(d, nf)*nf;
    float3 fc_h2, fc_n2; bool fc_v2;
    fc_parab_hit(fc_h1, fc_d2, fc_F, fc_A2, fc_f2, fc_h2, fc_n2, fc_v2);
    fc_ok = fc_ok && fc_v2 && (length(fc_h2 - fc_P2) < fc_r2);
    float3 fc_d3 = fc_d2 - 2.0f*dot(fc_d2, fc_n2)*fc_n2;
    float fc_den3 = dot(fc_d3, fc_n3);
    float fc_denu3 = (fabs(fc_den3) > 1e-9f) ? fc_den3 : 1e-9f;
    float fc_t3 = dot(fc_P3 - fc_h2, fc_n3) / fc_denu3;
    float3 fc_h3 = fc_h2 + fc_t3*fc_d3;
    fc_ok = fc_ok && (fc_t3 > 0.0f) && (length(fc_h3 - fc_P3) < fc_r3);
    float3 fc_d4 = fc_d3 - 2.0f*dot(fc_d3, fc_n3)*fc_n3;
    float fc_tg = (fc_zbot - fc_h3.z) / min(fc_d4.z, -1e-9f);
    float fc_gx = fc_h3.x + fc_tg*fc_d4.x - fc_xchase;
    float fc_gy = fc_h3.y + fc_tg*fc_d4.y - fc_ychase;
    fc_ok = fc_ok && (fc_d4.z < -0.5f)
                  && (sqrt(fc_gx*fc_gx + fc_gy*fc_gy) < fc_rbore);
    float3 fc_h4, fc_n4; bool fc_v4;
    fc_parab_hit(fc_h3, fc_d4, fc_F4, fc_zh, fc_f4, fc_h4, fc_n4, fc_v4);
    fc_ok = fc_ok && fc_v4 && (length(fc_h4 - fc_P4) < fc_r4);
    float3 fc_d5 = fc_d4 - 2.0f*dot(fc_d4, fc_n4)*fc_n4;
    float fc_t5 = (sc[12] - fc_h4.x) / min(fc_d5.x, -1e-9f);
    fc_ok = fc_ok && (fc_d5.x < -0.05f) && (fc_t5 < 4.0f);
    fc_t5 = min(fc_t5, 4.0f);
    float3 fc_h5 = fc_h4 + fc_t5*fc_d5;
    sh_dy = fc_h5.y + off[b*2];
    sh_dz = fc_h5.z - sc[11] + off[b*2+1];
    sh_thr = fc_ok && (fc_t5 > 0.0f) && (sh_dy*sh_dy + sh_dz*sh_dz <= sc[13]*sc[13]);
    sh_w = 1.0f; sh_h3 = fc_h5; sh_d3 = fc_d5;
    } else if (sc[106] > 1.5f) {
    // ==== CASSEGRAIN (sc[106..144], _build_cass_chain): a rotating strip
    // of the conic with foci F and F2 (hyperboloid before F, 'cass';
    // ellipsoid beyond F, 'greg') -> straight bore -> M4 (ellipsoid
    // patch, or a flat when a_e = 0) -> duct plane. Mirrors
    // _geo_core_cass line for line; cs_ locals.
    // the receiver table is PER ENV (design_rand: one design per agent):
    // row b of fct mirrors sc[106..144] + r_duct, so this block reads
    // cs_tab[k] where the torch twin reads fct[:, k]
    device const float* cs_tab = fct + b*FCTW;
    const bool cs_greg = cs_tab[0] > 2.5f;
    const float3 cs_F = Pf;
    const float cs_armn = cs_tab[1], cs_rstrip = cs_tab[2], cs_d = cs_tab[3];
    const float cs_a = cs_tab[4], cs_c = cs_tab[5];
    const float3 cs_O = float3(cs_tab[6], cs_tab[7], cs_tab[8]);
    const float3 cs_A = float3(cs_tab[9], cs_tab[10], cs_tab[11]);
    const float cs_thlo = cs_tab[12], cs_thhi = cs_tab[13], cs_w = cs_tab[14];
    const float3 cs_P4 = float3(cs_tab[15], cs_tab[16], cs_tab[17]);
    const float3 cs_Oe = float3(cs_tab[21], cs_tab[22], cs_tab[23]);
    const float3 cs_Ae = float3(cs_tab[24], cs_tab[25], cs_tab[26]);
    const float cs_ae = cs_tab[27], cs_ce = cs_tab[28];
    const float cs_rm4 = cs_tab[29], cs_rbore = cs_tab[30], cs_rstrut = cs_tab[31];
    const float cs_fd = cs_tab[32], cs_ad = cs_tab[33], cs_zdeck = cs_tab[34];
    const float cs_rhole = cs_tab[35], cs_wslot = cs_tab[36], cs_wk = cs_tab[37];
    const float cs_slotel = cs_tab[38], cs_rduct = cs_tab[39];
    const float cs_side = cs_greg ? 1.0f : -1.0f;
    const float3 cs_Ps = cs_F + float3(cs_armn, 0.0f, 0.0f);
    const float3 cs_Q = cs_greg ? (cs_F - cs_d*cs_A) : cs_F;
    const float3 cs_ud = sdir;                     // the dish axis (mount row 2)
    const float3 cs_Hc = cs_F + cs_side*cs_d*cs_ud;
    // ---- sun leg: the strip (sphere), the hole, the open slot, the arm
    // the four sun-leg shadows, kept apart for the miss ledger (codes 11..14)
    bool mk_shStrip = fc_blocked(p, ut, cs_Hc, cs_rstrip);
    bool cs_lit = !mk_shStrip;
    float cs_rhol = sqrt(p_loc.x*p_loc.x + p_loc.y*p_loc.y);
    bool mk_shHole = !(cs_rhol > cs_rhole);
    cs_lit = cs_lit && !mk_shHole;
    bool mk_shSlot = false, mk_shArm = false;
    float3 cs_zl = mrow(float3(0.0f, 0.0f, 1.0f), Mt + b*9);
    float cs_slx = -cs_zl.x, cs_sly = -cs_zl.y;
    float cs_sln = max(sqrt(cs_slx*cs_slx + cs_sly*cs_sly), 1e-9f);
    cs_slx /= cs_sln; cs_sly /= cs_sln;
    float cs_elsun = asin(clamp(ut.z, -1.0f, 1.0f));
    bool cs_slotopen = (cs_wslot > 0.0f) && (cs_elsun > cs_slotel);
    {
        float cs_al0 = p_loc.x*cs_slx + p_loc.y*cs_sly;
        float cs_pp0 = p_loc.x*cs_sly - p_loc.y*cs_slx;
        bool cs_ins0 = cs_slotopen && (cs_al0 > 0.0f) && (fabs(cs_pp0) < 0.5f*cs_wslot);
        mk_shSlot = cs_ins0;
        cs_lit = cs_lit && !cs_ins0;
    }
    float cs_ts; float cs_ds = fc_seg_dist(p, ut, cs_Ps, cs_Q, cs_ts);
    mk_shArm = !(cs_ds > cs_rstrut);
    cs_lit = cs_lit && !mk_shArm;
    // ---- the strip: conic hit
    float cs_t1; float3 cs_h1, cs_nh; bool cs_v1;
    if (cs_greg) {
        float cs_tF = dot(cs_F - p, d);
        float3 cs_w = p - cs_O;
        float cs_z0 = dot(cs_w, cs_A), cs_dz = dot(d, cs_A);
        float cs_wd = dot(cs_w, d), cs_ww = dot(cs_w, cs_w);
        float cs_a2 = cs_a*cs_a, cs_c2 = cs_c*cs_c, cs_b2 = cs_a2 - cs_c2;
        float cs_qa = cs_a2 - cs_c2*cs_dz*cs_dz;
        float cs_qb = 2.0f*(cs_a2*cs_wd - cs_c2*cs_z0*cs_dz);
        float cs_qc = cs_a2*cs_ww - cs_c2*cs_z0*cs_z0 - cs_a2*cs_b2;
        float cs_disc = cs_qb*cs_qb - 4.0f*cs_qa*cs_qc;
        float cs_sq = sqrt(max(cs_disc, 0.0f));
        float cs_qas = (fabs(cs_qa) > 1e-12f) ? cs_qa : 1e-12f;
        float cs_ta = (-cs_qb - cs_sq)/(2.0f*cs_qas);
        float cs_tb = (-cs_qb + cs_sq)/(2.0f*cs_qas);
        cs_ta = (cs_ta > cs_tF) ? cs_ta : 1e9f;
        cs_tb = (cs_tb > cs_tF) ? cs_tb : 1e9f;
        cs_t1 = min(cs_ta, cs_tb);
        cs_v1 = (cs_disc >= 0.0f) && (cs_t1 < 1e8f);
        cs_h1 = p + cs_t1*d;
        float3 cs_wX = cs_h1 - cs_O;
        float cs_zz = dot(cs_wX, cs_A);
        float3 cs_nn = cs_a2*cs_wX - cs_c2*cs_zz*cs_A;
        cs_nh = cs_nn/max(length(cs_nn), 1e-12f);
        if (dot(cs_nh, d) > 0.0f) cs_nh = -cs_nh;
    } else {
        float3 cs_w = p - cs_O;
        float cs_z0 = dot(cs_w, cs_A), cs_dz = dot(d, cs_A);
        float cs_wd = dot(cs_w, d), cs_ww = dot(cs_w, cs_w);
        float cs_c2 = cs_c*cs_c, cs_a2 = cs_a*cs_a, cs_b2 = cs_c2 - cs_a2;
        float cs_qa = cs_c2*cs_dz*cs_dz - cs_a2;
        float cs_qb = 2.0f*(cs_c2*cs_z0*cs_dz - cs_a2*cs_wd);
        float cs_qc = cs_c2*cs_z0*cs_z0 - cs_a2*cs_ww - cs_a2*cs_b2;
        float cs_disc = cs_qb*cs_qb - 4.0f*cs_qa*cs_qc;
        float cs_sq = sqrt(max(cs_disc, 0.0f));
        float cs_sgn = (cs_qb >= 0.0f) ? 1.0f : -1.0f;
        float cs_qq = -0.5f*(cs_qb + cs_sgn*cs_sq);
        float cs_qas = (fabs(cs_qa) > 1e-12f) ? cs_qa : 1e-12f;
        float cs_qqs = (fabs(cs_qq) > 1e-12f) ? cs_qq : 1e-12f;
        float cs_ta = cs_qq/cs_qas, cs_tb = cs_qc/cs_qqs;
        float3 cs_Xa = p + cs_ta*d, cs_Xb = p + cs_tb*d;
        bool cs_oka = (cs_ta > 1e-6f) && (dot(cs_Xa - cs_O, cs_A) < 0.0f);
        bool cs_okb = (cs_tb > 1e-6f) && (dot(cs_Xb - cs_O, cs_A) < 0.0f);
        cs_ta = cs_oka ? cs_ta : 1e9f;
        cs_tb = cs_okb ? cs_tb : 1e9f;
        cs_t1 = min(cs_ta, cs_tb);
        cs_v1 = (cs_disc >= 0.0f) && (cs_t1 < 1e8f);
        cs_h1 = p + cs_t1*d;
        float cs_zz = dot(cs_h1 - cs_O, cs_A);
        float3 cs_nn = cs_c2*cs_zz*cs_A - cs_a2*(cs_h1 - cs_O);
        cs_nh = cs_nn/max(length(cs_nn), 1e-12f);
        if (dot(cs_nh, d) > 0.0f) cs_nh = -cs_nh;
    }
    // ---- the strip window: polar angle about A, azimuth about the
    // meridian of the dish axis, width tapered with the hit distance
    float3 cs_rel = cs_h1 - cs_F;
    float cs_rn = max(length(cs_rel), 1e-9f);
    float cs_th = acos(clamp(dot(cs_rel, cs_A)/cs_rn, -1.0f, 1.0f));
    float3 cs_avh = cs_rel - dot(cs_rel, cs_A)*cs_A;
    float3 cs_sdr = cs_side*cs_ud;
    float3 cs_avs = cs_sdr - dot(cs_sdr, cs_A)*cs_A;
    float cs_cosd = dot(cs_avh, cs_avs)/max(length(cs_avh)*length(cs_avs), 1e-9f);
    float cs_rho = length(cs_avh);
    float cs_arc = acos(clamp(cs_cosd, -1.0f, 1.0f))*cs_rho;
    float cs_wloc = (cs_wk > 0.0f) ? cs_wk*cs_rn : cs_w;
    bool cs_on = cs_v1 && (cs_th >= cs_thlo) && (cs_th <= cs_thhi)
                 && ((cs_arc < 0.5f*cs_wloc) || (cs_rho < 0.5f*cs_wloc));
    float cs_tsg; float cs_dsg = fc_seg_dist(p, d, cs_Ps, cs_Q, cs_tsg);
    bool cs_graze = (cs_dsg < cs_rstrut) && (cs_tsg < cs_t1 - 0.05f);
    bool cs_ok = cs_lit && !cs_graze && cs_on;
    float3 cs_d2 = d - 2.0f*dot(d, cs_nh)*cs_nh;
    // ---- the reflected leg must clear the membrane (ideal paraboloid in
    // the dish frame, hole and open slot excepted) and the arm
    float3 cs_l0 = mrow(cs_h1 - CdV, Mt + b*9);
    float3 cs_dl = mrow(cs_d2, Mt + b*9);
    float cs_qa2 = cs_dl.x*cs_dl.x + cs_dl.y*cs_dl.y;
    float cs_qb2 = 2.0f*(cs_l0.x*cs_dl.x + cs_l0.y*cs_dl.y) - 4.0f*cs_fd*cs_dl.z;
    float cs_qc2 = cs_l0.x*cs_l0.x + cs_l0.y*cs_l0.y - 4.0f*cs_fd*cs_l0.z;
    float cs_disc2 = cs_qb2*cs_qb2 - 4.0f*cs_qa2*cs_qc2;
    float cs_sq2 = sqrt(max(cs_disc2, 0.0f));
    float cs_qas2 = (fabs(cs_qa2) > 1e-12f) ? cs_qa2 : 1e-12f;
    float cs_tm = (-cs_qb2 - cs_sq2)/(2.0f*cs_qas2);
    float cs_tp = (-cs_qb2 + cs_sq2)/(2.0f*cs_qas2);
    bool cs_cross = false;
    for (int cs_k = 0; cs_k < 2; cs_k++) {
        float cs_tt = (cs_k == 0) ? cs_tm : cs_tp;
        float3 cs_X = cs_l0 + cs_tt*cs_dl;
        float cs_rr = sqrt(cs_X.x*cs_X.x + cs_X.y*cs_X.y);
        float cs_al = cs_X.x*cs_slx + cs_X.y*cs_sly;
        float cs_pp = cs_X.x*cs_sly - cs_X.y*cs_slx;
        bool cs_ins = cs_slotopen && (cs_al > 0.0f) && (fabs(cs_pp) < 0.5f*cs_wslot);
        cs_cross = cs_cross || ((cs_disc2 >= 0.0f) && (cs_tt > 1e-3f)
                                && (cs_rr < cs_ad) && (cs_rr > cs_rhole) && !cs_ins);
    }
    float cs_tsa; float cs_dsa = fc_seg_dist(cs_h1, cs_d2, cs_Ps, cs_Q, cs_tsa);
    cs_cross = cs_cross || ((cs_dsa < cs_rstrut) && (cs_tsa > 0.0f));
    cs_ok = cs_ok && !cs_cross;
    // ---- the bore gate at the deck plane, then M4
    float3 cs_axis = normalize(cs_P4 - cs_F);
    float cs_tdeck = (cs_zdeck - cs_h1.z)/min(cs_d2.z, -1e-9f);
    float3 cs_wdk = cs_h1 + cs_tdeck*cs_d2 - cs_F;
    float cs_adist = length(cs_wdk - dot(cs_wdk, cs_axis)*cs_axis);
    float cs_t4; float3 cs_h4, cs_n4; bool cs_v4;
    if (cs_ae > 0.0f) {
        float3 cs_w4 = cs_h1 - cs_Oe;
        float cs_z04 = dot(cs_w4, cs_Ae), cs_dz4 = dot(cs_d2, cs_Ae);
        float cs_wd4 = dot(cs_w4, cs_d2), cs_ww4 = dot(cs_w4, cs_w4);
        float cs_a24 = cs_ae*cs_ae, cs_c24 = cs_ce*cs_ce, cs_b24 = cs_a24 - cs_c24;
        float cs_qa4 = cs_a24 - cs_c24*cs_dz4*cs_dz4;
        float cs_qb4 = 2.0f*(cs_a24*cs_wd4 - cs_c24*cs_z04*cs_dz4);
        float cs_qc4 = cs_a24*cs_ww4 - cs_c24*cs_z04*cs_z04 - cs_a24*cs_b24;
        float cs_disc4 = cs_qb4*cs_qb4 - 4.0f*cs_qa4*cs_qc4;
        float cs_sq4 = sqrt(max(cs_disc4, 0.0f));
        float cs_qas4 = (fabs(cs_qa4) > 1e-12f) ? cs_qa4 : 1e-12f;
        float cs_t41 = (-cs_qb4 - cs_sq4)/(2.0f*cs_qas4);
        float cs_t42 = (-cs_qb4 + cs_sq4)/(2.0f*cs_qas4);
        cs_t4 = max(cs_t41, cs_t42);
        cs_v4 = (cs_disc4 >= 0.0f) && (cs_t4 > 1e-6f);
        cs_h4 = cs_h1 + cs_t4*cs_d2;
        float3 cs_wX4 = cs_h4 - cs_Oe;
        float cs_zz4 = dot(cs_wX4, cs_Ae);
        float3 cs_nn4 = cs_a24*cs_wX4 - cs_c24*cs_zz4*cs_Ae;
        cs_n4 = cs_nn4/max(length(cs_nn4), 1e-12f);
        if (dot(cs_n4, cs_d2) > 0.0f) cs_n4 = -cs_n4;
    } else {
        float cs_den4 = dot(cs_d2, cs_Ae);
        float cs_denu4 = (fabs(cs_den4) > 1e-9f) ? cs_den4 : 1e-9f;
        cs_t4 = dot(cs_P4 - cs_h1, cs_Ae)/cs_denu4;
        cs_h4 = cs_h1 + cs_t4*cs_d2;
        cs_n4 = cs_Ae;
        cs_v4 = cs_t4 > 0.0f;
    }
    cs_ok = cs_ok && (cs_d2.z < -0.2f) && (cs_adist < cs_rbore);
    cs_ok = cs_ok && cs_v4 && (length(cs_h4 - cs_P4) < cs_rm4);
    {
        // a FACETTED M4 (design table [66], rad rms): tilt the normal by a Gaussian of that width in a
        // random tangent direction, the draw from the ray's two uniforms scrambled (torch twin)
        float f4_sig = fct[b*FCTW + 66];
        if (f4_sig > 0.0f) {
            float f4_u1 = fract(upk[tid]*97.0f + 0.137f), f4_u2 = fract(us[tid]*89.0f + 0.618f);
            float f4_r = sqrt(-2.0f*log(max(f4_u1, 1e-7f)));
            float f4_g1 = f4_r*cos(6.2831853f*f4_u2), f4_g2 = f4_r*sin(6.2831853f*f4_u2);
            float3 f4_t1 = cross(cs_n4, float3(0.0f, 1.0f, 0.0f)); f4_t1 = f4_t1/max(length(f4_t1), 1e-9f);
            float3 f4_t2 = cross(cs_n4, f4_t1);
            cs_n4 = normalize(cs_n4 + f4_sig*(f4_g1*f4_t1 + f4_g2*f4_t2));
        }
    }
    float3 cs_d5 = cs_d2 - 2.0f*dot(cs_d2, cs_n4)*cs_n4;
    // A PORT-MOUNTED M3 straddles the duct plane (torch twin: 'inside' block). A ray
    // that hit the inner half must have come in through the hole, and needs no
    // outbound crossing: its h5 is the backward extrapolation to the plane.
    const bool cs_inside = cs_h4.x <= sc[12];
    const float cs_tin = (sc[12] - cs_h1.x)/min(cs_d2.x, -1e-9f);
    const float3 cs_hin = cs_h1 + cs_tin*cs_d2;
    const float cs_dyi = cs_hin.y + off[b*2], cs_dzi = cs_hin.z - sc[11] + off[b*2+1];
    const bool cs_inok = !cs_inside || ((cs_d2.x < 0.0f) && (cs_tin > 0.0f) && (cs_dyi*cs_dyi + cs_dzi*cs_dzi <= cs_rduct*cs_rduct));
    cs_ok = cs_ok && cs_inok;
    float cs_t5 = (sc[12] - cs_h4.x)/min(cs_d5.x, -1e-9f);
    const float cs_t5raw = cs_t5;                       // before the clamp: the ledger needs the real value
    cs_ok = cs_ok && (cs_d5.x < -0.05f) && (cs_t5 < 4.0f);
    cs_t5 = min(cs_t5, 4.0f);
    float3 cs_h5 = cs_h4 + cs_t5*cs_d5;
    sh_dy = cs_h5.y + off[b*2];
    sh_dz = cs_h5.z - sc[11] + off[b*2+1];
    sh_thr = cs_ok && (cs_inside || ((cs_t5 > 0.0f) && (sh_dy*sh_dy + sh_dz*sh_dz <= cs_rduct*cs_rduct)));
    sh_w = 1.0f; sh_h3 = cs_h5; sh_d3 = cs_d5;
    // THE MISS LEDGER (2026-09-10). A ray that fails is not clamped to a sentinel
    // and forgotten: it gets a fate code - FIRST failure wins - and a stop point on
    // the surface it actually met, so a loss can be traced to a part.
    //   0 through the inlet          5 the dish blocks the reflected leg
    //   1 (unused: split into 11 strip shadow, 12 hole, 13 slot, 14 arm)   6 misses the bore
    //   2 misses the strip's conic   7 misses M3's aperture
    //   3 outside the strip window   8 wrong way at the duct plane (the old sentinel)
    //   4 grazes the arm             9 hits the COLLAR: at the plane, outside r_duct
    //  10 escapes: no surface within 20 m along its real direction
    // For 6..9 the stop is the nearest of the bore wall, the deck, the pot's outer
    // sphere and the pit floor along the ray; for 1..5 it is where the ray stood
    // when the gate failed - the code names what blocked it. Torch twin: _geo_core_cass.
    {
        const float mk_RDW = fct[b*FCTW + 80], mk_ZC = fct[b*FCTW + 78], mk_RS = fct[b*FCTW + 79];   // the pit, per agent (as _bin_pot)
        const float3 mk_pc = float3(sc[12] - mk_RDW, 0.0f, mk_ZC + 1.0f);           // pot sphere centre, world
        bool mk_bore = (cs_d2.z < -0.2f) && (cs_adist < cs_rbore);
        bool mk_m3   = cs_v4 && (length(cs_h4 - cs_P4) < cs_rm4);
        bool mk_way  = (cs_d5.x < -0.05f) && (cs_t5raw < 4.0f) && (cs_inside || (cs_t5raw > 0.0f));
        float mk_code = 0.0f; float3 mk_o = cs_h5, mk_d = cs_d5; bool mk_cont = false;
        if (mk_shStrip)         { mk_code = 11.0f; sh_stop = p; }      // the strip's own shadow on the dish
        else if (mk_shHole)     { mk_code = 12.0f; sh_stop = p; }      // inside the central hole
        else if (mk_shSlot)     { mk_code = 13.0f; sh_stop = p; }      // in the open slot
        else if (mk_shArm)      { mk_code = 14.0f; sh_stop = p; }      // under the F arm
        else if (!cs_v1)        { mk_code = 2.0f; sh_stop = p; }
        else if (!cs_on)        { mk_code = 3.0f; sh_stop = cs_h1; }
        else if (cs_graze)      { mk_code = 4.0f; sh_stop = cs_h1; }
        else if (cs_cross)      { mk_code = 5.0f; sh_stop = cs_h1; }
        else if (!mk_bore)      { mk_code = 6.0f; mk_o = cs_h1; mk_d = cs_d2; mk_cont = true; }
        else if (!mk_m3)        { mk_code = 7.0f; mk_o = cs_h1; mk_d = cs_d2; mk_cont = true; }
        else if (!cs_inok)      { mk_code = 9.0f; sh_stop = cs_hin; }   // the collar, from the outside, on the way in
        else if (!mk_way)       { mk_code = 8.0f; mk_o = cs_h4; mk_d = cs_d5; mk_cont = true; }
        else if (!sh_thr)       { mk_code = 9.0f; sh_stop = cs_h5; }
        else                    { mk_code = 0.0f; sh_stop = cs_h5; }
        int mk_surf = -1;                        // 0 bore wall, 1 deck, 2 pot exterior, 3 pit floor
        if (mk_cont) {
            float mk_t = 1e9f;
            // the bore wall: cylinder of radius cs_rbore about the axis cs_F -> cs_P4
            float3 mk_a = normalize(cs_P4 - cs_F);
            float3 mk_w = mk_o - cs_F;
            float3 mk_wp = mk_w - dot(mk_w, mk_a)*mk_a, mk_dp = mk_d - dot(mk_d, mk_a)*mk_a;
            float mk_qa = dot(mk_dp, mk_dp), mk_qb = 2.0f*dot(mk_wp, mk_dp), mk_qc = dot(mk_wp, mk_wp) - cs_rbore*cs_rbore;
            float mk_dsc = mk_qb*mk_qb - 4.0f*mk_qa*mk_qc;
            if (mk_qa > 1e-9f && mk_dsc >= 0.0f) {
                float mk_r1 = (-mk_qb - sqrt(mk_dsc))/(2.0f*mk_qa), mk_r2 = (-mk_qb + sqrt(mk_dsc))/(2.0f*mk_qa);
                if (mk_r1 > 1e-3f && mk_r1 < mk_t) { mk_t = mk_r1; mk_surf = 0; }
                if (mk_r2 > 1e-3f && mk_r2 < mk_t) { mk_t = mk_r2; mk_surf = 0; }
            }
            // the deck plane
            if (fabs(mk_d.z) > 1e-9f) { float mk_td = (cs_zdeck - mk_o.z)/mk_d.z; if (mk_td > 1e-3f && mk_td < mk_t) { mk_t = mk_td; mk_surf = 1; } }
            // the pot's outer sphere
            float3 mk_ws = mk_o - mk_pc;
            float mk_sb = 2.0f*dot(mk_ws, mk_d), mk_sc = dot(mk_ws, mk_ws) - mk_RS*mk_RS;
            float mk_sd = mk_sb*mk_sb - 4.0f*mk_sc;
            if (mk_sd >= 0.0f) {
                float mk_s1 = (-mk_sb - sqrt(mk_sd))*0.5f, mk_s2 = (-mk_sb + sqrt(mk_sd))*0.5f;
                if (mk_s1 > 1e-3f && mk_s1 < mk_t) { mk_t = mk_s1; mk_surf = 2; }
                if (mk_s2 > 1e-3f && mk_s2 < mk_t) { mk_t = mk_s2; mk_surf = 2; }
            }
            // the pit floor
            if (fabs(mk_d.z) > 1e-9f) { float mk_tf = ((mk_ZC + 1.0f - mk_RS) - mk_o.z)/mk_d.z; if (mk_tf > 1e-3f && mk_tf < mk_t) { mk_t = mk_tf; mk_surf = 3; } }
            if (mk_t > 20.0f) { mk_code = 10.0f; mk_t = 20.0f; mk_surf = -1; }
            sh_stop = mk_o + mk_t*mk_d;
        }
        sh_fate = mk_code; sh_surf = mk_surf;
        // THE EXTERIOR BIN: which patch of which surface takes this ray's power
        {
            float mk_rf = clamp(sqrt(p_loc.x*p_loc.x + p_loc.y*p_loc.y)/max(cs_ad, 1e-6f), 0.0f, 0.999f);
            int mk_rb = int(mk_rf*4.0f);                                             // dish radius, quarters
            if (mk_code == 9.0f)       sh_bin = clamp(int((atan2(cs_inok ? sh_dz : cs_dzi, cs_inok ? sh_dy : cs_dyi) + M_PI_F)/(2.0f*M_PI_F)*8.0f), 0, 7);
            else if (mk_code == 5.0f)  sh_bin = 21 + mk_rb;
            else if (mk_code == 11.0f) sh_bin = 25 + mk_rb;
            else if (mk_code == 13.0f) sh_bin = 29 + mk_rb;
            else if (mk_code == 12.0f) sh_bin = 33;
            else if (mk_code == 14.0f) sh_bin = 34;
            else if (mk_code == 3.0f)  sh_bin = 35;
            else if (mk_code == 2.0f)  sh_bin = 36;
            else if (mk_code == 10.0f) sh_bin = 20;
            else if (mk_cont) {
                if (mk_surf == 1)      sh_bin = 14;
                else if (mk_surf == 2) sh_bin = 15 + int(clamp((sh_stop.z - (mk_ZC + 1.0f))/mk_RS*0.5f + 0.5f, 0.0f, 0.999f)*4.0f);
                else if (mk_surf == 3) sh_bin = 19;
                else { float3 mk_ax = normalize(cs_P4 - cs_F);
                       sh_bin = 8 + int(clamp(dot(sh_stop - cs_F, mk_ax)/max(length(cs_P4 - cs_F), 1e-6f), 0.0f, 0.999f)*6.0f); }
            }
        }
    }
    } else {
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
    sh_thr = thr; sh_w = w; sh_h3 = h3; sh_d3 = d3; sh_dy = dy; sh_dz = dz;
    }
    thr_o[tid] = sh_thr ? sh_w : 0.0f;
    fate[tid*6+0] = sh_fate; fate[tid*6+1] = sh_stop.x; fate[tid*6+2] = sh_stop.y; fate[tid*6+3] = sh_stop.z;
    fate[tid*6+4] = (float)sh_surf; fate[tid*6+5] = (float)sh_bin;
    // THE EXTERIOR FLUX LABELLING: the pot gets per_dni; every other surface gets
    // this. Same ray power the pot would have received - ray_pw x soil x the dish
    // area factor x the sun-cone shares - minus only the through gate.
    if (sh_bin >= 0 && sh_fate > 0.5f) {
        float mk_wx = ray_pw[clamp(int(fct[b*FCTW + 60] + 0.5f), 0, dims[4] - 1)*P + ip] * soil[b] * fct[b*FCTW + 41]
                      * scb[sb+4] * scb[sb+5];
        atomic_fetch_add_explicit((device atomic_float*)&pex[b*NX + sh_bin], mk_wx, memory_order_relaxed);
    }
    int o = tid*6;
    out6[o+0] = sh_h3.y;         out6[o+1] = sh_h3.z - sc[11];
    out6[o+2] = sh_d3.x;         out6[o+3] = sh_d3.y;
    out6[o+4] = sh_d3.z;         out6[o+5] = sh_w;

    // ---- _bin_pot, transcribed: duct arrival -> pot node powers.
    // Frame map theirs = (y_ours, -x_ours, z_ours - H_POT):
    // pxp = h3.y, pyp = h3.z - Z_DUCT_ours; dirs (d3.y, -d3.x, d3.z).
    // Their constants: R_POT 0.42, Z_DUCT -0.86, H_POT 1.0,
    // n_belt 8, hearth = n_belt, crown = n_belt + 2.
    if (sh_thr) {
        // THE REAL PIT: spherical section, mouth R 0.26 at z 0,
        // coal-bed floor R 0.42 at z -2.44 (8 ft). Derived (mirrors
        // tandoor_polar_env): Z_CPOT, R_SPH, duct-wall radius.
        // THE PIT IS PER AGENT (2026-09-10, "pot dimensions variation"): its sphere comes off
        // the design table - fct[78] Z_CPOT, [79] R_SPH, [80] R_DUCT_WALL, [81] H_DEPTH - as
        // TandoorHashemiEnv.pot_sphere derives them from the site's pot_r / pot_h. The duct
        // plane sc[12] and the mouth-relative bands (-0.22, -0.85) stay: the machine is
        // built to the wall, the pit grows away from it.
        const float ZD = -0.86f;
        const float HD = fct[b*FCTW + 81];
        const float ZC = fct[b*FCTW + 78], RS = fct[b*FCTW + 79];
        const float RDW = fct[b*FCTW + 80];
        const int NB = 8;
        float pxp = sh_h3.y, pyp = sh_h3.z - sc[11];
        float dxw = sh_d3.y, dyw = -sh_d3.x, dzw = sh_d3.z;
        float ox = pxp, oyv = -RDW, oz = pyp + ZD;
        // THE ELBOW IS A COLUMN, NOT A SCALAR (2026-09-08): sc[105] was the env's
        // one duct_nozzle, so a batch was all-elbow or no-elbow. With 'receiver' a
        // design variable the same batch carries three-mirror machines (no elbow:
        // M3 threw the beam at the loaf already) beside Cassegrains.
        const float mk_noz = fct[b*FCTW + 73];
        if (mk_noz > 1.5f) {
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
        float wgt = ray_pw[clamp(int(fct[b*FCTW + 60] + 0.5f), 0, dims[4] - 1)*P + ip] * soil[b] * fct[b*FCTW + 41] * (sh_thr ? sh_w : 0.0f)
                    * scb[sb+4] * scb[sb+5]
                    * (mk_noz > 0.5f ? 0.95f : 1.0f);
        atomic_fetch_add_explicit(
            (device atomic_float*)&per_dni[b*dims[3] + node],
            wgt, memory_order_relaxed);
        // THE LOAF PATCH (2026-09-06, the footprint comes from the trace):
        // the bin's loaf is a square of half-size lfp[0] on the wall at
        // the bake row's mid-height; a ray that strikes it is the
        // loaf's, accumulated in the NB loaf columns after the nodes
        const float ZB = -0.535f;
        const int Nn = dims[3] - NB;
        float rb = sqrt(max(RS*RS - (ZB - ZC)*(ZB - ZC), 1e-6f));
        float phk = -M_PI_F + ((float)seg + 0.5f) * (2.0f*M_PI_F/(float)NB);
        float dph = phi - phk;
        dph = dph - 2.0f*M_PI_F*floor((dph + M_PI_F)/(2.0f*M_PI_F));
        const float lfh = fct[b*FCTW + 51];        // the loaf half-size (roti size is a design)
        bool onloaf = (node < NB) && (fabs(dph)*rb < lfh)
                      && (fabs(sz - ZB) < lfh);
        if (onloaf)
            atomic_fetch_add_explicit(
                (device atomic_float*)&per_dni[b*dims[3] + Nn + seg],
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
// st layout, per env (NS = 3N+1+4NB+38):
//   [0..N) T   [N..2N) T_sub   [2N..3N) T_deep   [3N] T_halo
//   [3N+1..) bread_E[NB] bread_t[NB] bread_C[NB] has_bread[NB]
//   scalars at S0 = 3N+1+4NB:
//   +0 p_act +1 p_set +2 p_dist +3 shutter +4 jammed +5 f_locked
//   +6 form_time +7 decl_formed +8 load_timer +9 ep_rotis
//   +10 ep_scorch +11 ep_spall +12 ep_return +13 ep_len
//   +14 el_m +15 az_m +16 lost_ct +17 belt_prev +18 cloud
//   +19 wind_g +20 e_az_prev +21 e_el_prev +22 spot_phi +23 spot_z
//   +34 day_rotis (cut-immune; day-over zeroes it host-side)
//   +35 hold_p +36 hold_s +37 hold_j (sticky-engagement latches,
//       raw action values; day-over resets them host-side, cuts
//       leave them alone - cuts never reset engagement)
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
//   61 loaves_per_load 62 load_ctrl 71 inlet_esc
//   63.. node_area[N] heat_cap[N] cap_sub[N] cap_deep[N]
//        g01[N] g12[N] g2s[N]
// ip: 0 B 1 N 2 NB 3 NH 4 NS 5 OD 6 tick (host-written per step)
//     7 sticky_k (engagement latch period; <=1 means off)
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
    device const float* fct   [[buffer(16)]],  // (B,FCTW) per-env design: [44] rate scale [53] f_nom
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
    float potp = min(fabs(s[S0+20]) + fabs(s[S0+21]), 4.0f);
    // ---- motors + spot jogs
    float r_az = (float)(clamp(a[3], 0, 6) - 3) / 3.0f * sp[2] * fct[b*FCTW + 44];
    float r_el = (float)(clamp(a[4], 0, 6) - 3) / 3.0f * sp[3] * fct[b*FCTW + 44];
    if (sp[24] > 0.5f) {
        float r_ph = (float)(clamp(a[5], 0, 6) - 3) / 3.0f * sp[4];
        float r_zz = (float)(clamp(a[6], 0, 6) - 3) / 3.0f * sp[5];
        // the aim head's travel is the machine's, per agent: the concave elbow's
        // +-110 deg of spot azimuth on 'cass', M3's own +-31 deg turn on 'tri'.
        // sp[6] is the centre (SPOT_PHI0); the half-span comes off the design table.
        const float mk_phw = fct[b*FCTW + 74];
        s[S0+22] = clamp(s[S0+22] + r_ph*PI_/180.0f*dt, sp[6] - mk_phw, sp[6] + mk_phw);
        s[S0+23] = clamp(s[S0+23] + r_zz*dt, sp[8], sp[9]);
    }
    s[S0+15] = s[S0+15] + r_az*dt + 0.02f*rb[0];
    s[S0+14] = clamp(s[S0+14] + r_el*dt + 0.02f*rb[1],
                     sp[14] - 2.0f, sp[15] + 1.0f);
    float e_el = s[S0+14] - el0;
    // ON THE CIRCLE (2026-09-11): the mount's azimuth runs on continuously while the
    // sun's comes wrapped to [0, 360) in the SITE's frame (mount_solve), so on a roof
    // turned far enough for the sun to cross machine-north the raw difference jumped
    // by 360 deg at that crossing - the guillotine fired ~50 times a day on such sites.
    float daz = s[S0+15] - az0d; daz = daz - 360.0f*floor(daz/360.0f + 0.5f);
    float e_az = daz * cos(el0*PI_/180.0f);
    // ---- heads, jam, servo
    // sticky engagement: heads 0-2 latch, fresh actions land only on
    // ticks where tick % sticky_k == 0 (numpy twin: polar step)
    int act0 = a[0], act1 = a[1], act2 = a[2];
    if (ip[7] > 1) {
        if ((ip[6] % ip[7]) == 0) {
            s[S0+35] = (float)act0;
            s[S0+36] = (float)act1;
            s[S0+37] = (float)act2;
        } else {
            act0 = (int)s[S0+35];
            act1 = (int)s[S0+36];
            act2 = (int)s[S0+37];
        }
    }
    s[S0+1] = sp[1] * sp[54 + clamp(act0, 0, 6)];
    s[S0+3] = ((float)act1 > sp[10]) ? 1.0f : 0.0f;
    float want = ((float)act2 > sp[10]) ? 1.0f : 0.0f;
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
    // THE DAWN RE-FORM IS PAID FOR: the figure follows the day's
    // declination only after ip[9] soft steps that day (the cook's
    // hands, minutes of exposed, non-cooking membrane), never for free
    if (soft && s[S0+6] >= (float)ip[9]) s[S0+7] = decl;
    // ---- sun scalars, cloud/wind OU (ts already advanced host-side)
    float ts = mprm[0] + sp[42];
    float sinel = sin(el0*PI_/180.0f);
    float am = 1.0f / max(sinel, 0.035f);
    float clearw = (el0 > 2.0f)
        ? 1353.0f * pow(0.7f, pow(am, 0.678f)) : 0.0f;
    float cl = s[S0+18];
    cl = cl - cl*sp[48] + sp[44]*rb[3];
    if (ru[b*RU+0] < sp[47]) cl -= 1.5f;
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
    // THE LEVEL FROM THE LADDER (2026-09-11): the figure rows were solved at the pressures
    // sp[54..54+N-1] = level_frac * p0, which are NOT evenly spaced (coude's 0.62 .. 1.10
    // tightens round the nominal), so the linear inverse that used to sit here put the
    // nominal pressure at level 4.75 - a figure at ~1.03 p0, three quarters of a step
    // of defocus on every training step, while _trace_power (the readout, the design
    // tool) interpolated against the ladder and got level 4. That gap was the "-17%
    // section power delta". Piecewise-linear against the ladder, as np.interp.
    {
        const int nl = int(sp[35] + 0.5f);                  // N_LEVELS - 1
        const float x = p_eff/sp[1];
        float lvv = (x <= sp[54]) ? 0.0f : (float)nl;
        for (int i = 0; i < nl; i++) {
            const float f0 = sp[54+i], f1 = sp[55+i];
            if (x >= f0 && x < f1) { lvv = (float)i + (x - f0)/max(f1 - f0, 1e-6f); break; }
        }
        lv[b] = clamp(lvv, 0.0f, sp[35]);
    }
    dvec[b*2+0] = 2.0f*fct[b*FCTW + 53]*e_el*PI_/180.0f;
    dvec[b*2+1] = 2.0f*fct[b*FCTW + 53]*e_az*PI_/180.0f;
    float ph = s[S0+22], zt = s[S0+23];
    // the elbow aims at THIS agent's pit wall (fct[79] R_SPH, fct[78] Z_CPOT - what
    // _aim_dirs and _bin_pot read); sp[29]/sp[30] are the nominal pit's
    float sp_rs = fct[b*FCTW + 79], sp_zc = fct[b*FCTW + 78];
    float rt = sqrt(max(sp_rs*sp_rs - (zt - sp_zc)*(zt - sp_zc),
                        1e-4f)) * 0.999f;
    float3 a1 = normalize(float3(rt*cos(ph) - sp[31],
                                 rt*sin(ph) - sp[32], zt - sp[33]));
    aim[b*3+0] = a1.x; aim[b*3+1] = a1.y; aim[b*3+2] = a1.z;
    // ---- gate + scratch for post
    s[S0+30] = dni * cosw * s[S0+3] * want;
    s[S0+27] = el0; s[S0+28] = az0d; s[S0+29] = potp;
    s[S0+32] = e_el; s[S0+33] = e_az;
    for (int i = 0; i < N + NB; i++) per[b*(N + NB) + i] = 0.0f;   // nodes + loaf columns
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
    device const float* dsn   [[buffer(15)]],  // (B,ND) per-env design obs (unit box, 2u-1)
    device const float* fct   [[buffer(16)]],  // (B,FCTW) per-env design (system block at 40)
    uint b [[thread_position_in_grid]])
{
    if ((int)b >= ip[0]) return;
    const float PI_ = 3.14159265358979f;
    const float SIG = 5.67e-8f;
    const int N = ip[1], NB = ip[2], NS = ip[4], OD = ip[5];
    const int ND = ip[8];
    device float* s = st + b*NS;
    const int S0 = 3*N + 1 + 4*NB;
    const int SB = NS - 2*KSAND - NDEM; // the two sand columns, then the demand state, at the row's end
    const int SD = NS - NDEM;
    const int ka_bed = (ds_fct_depth(fct, b) >= 0.05f)
        ? clamp((int)round(ds_fct_depth(fct, b)/0.05f), 1, KSAND) : 0;
    device float* Tsub = s + N;
    device float* Tdeep = s + 2*N;
    device float* bE = s + 3*N + 1;
    device float* bt_ = bE + NB;
    device float* bC = bt_ + NB;
    device float* hb = bC + NB;
    device const float* pv = per + b*(N + NB);   // N nodes, then NB loaf columns
    device const float* NA = sp + SPX;  // sp[63] cut penalty, sp[64] lost_deg, sp[65] enc_clamp, sp[66..70] the demand process
    // the system design, per env: [45] wall->soil conductance scale,
    // [46] thermal-mass scale, [47] lid leak, [48] bread area,
    // [49] h_bread, [50] roti energy, [52] loaves per lean
    device const float* ds = fct + b*FCTW;
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
    // DONENESS POTENTIAL, phi_old (numpy twins line for line):
    // in-oven doneness at step start, before any bread energy moves
    float phi_old = 0.0f;
    for (int k = 0; k < NB; k++)
        phi_old += clamp(bE[k]/ds[50], 0.0f, 1.0f);
    // ---- spot_bread: the loaf takes the beam directly
    int kb = 0; float validc = 0.0f, q_direct = 0.0f;
    float qsp[16];                     // per-loaf beam power (NB <= 16)
    for (int k = 0; k < 16; k++) qsp[k] = 0.0f;
    if (sp[25] > 0.5f) {
        float phs = s[S0+22];
        kb = ((int)((phs + PI_)/(2.0f*PI_)*(float)NB)) % NB;
        float zt = s[S0+23];
        validc = (zt >= sp[22] && zt <= sp[23]) ? 1.0f : 0.0f;
        // every loaded loaf takes the TRACED beam power on its own patch
        // (pv[N+k], the loaf columns): the footprint is the trace's
        validc = 1.0f;
        for (int k = 0; k < NB; k++) {
            float lit_k = (hb[k] > 0.5f) ? 1.0f : 0.0f;
            float frb_k = clamp(bE[k]/ds[50], 0.0f, 1.0f);
            float alpha_k = 0.55f + 0.35f*frb_k;
            float inc_k = pv[N + k]*gate;
            float q_k = lit_k*alpha_k*inc_k;
            qv[k] -= lit_k*0.85f*inc_k;
            bE[k] += q_k*dt;
            qsp[k] = q_k;
            q_direct += q_k;
        }
    }
    // ---- thermal (polar's copy)
    float t4s = 0.0f;
    for (int i = 0; i < N; i++) t4s += NA[i]*t4v[i];
    float tc4 = t4s / sp[52];
    float lid = (s[S0+8] < 4.0f) ? 1.0f : ds[47];
    float ta4 = sp[43]*sp[43]*sp[43]*sp[43];
    // the inlet is an aperture too: an unlidded hole of radius ds[39] (numpy twin)
    float q_ap = 0.75f*SIG*(tc4 - ta4)*(sp[51]*lid + M_PI_F*ds[39]*ds[39]*sp[71]);
    float Th = s[3*N];
    float q2sum = 0.0f;
    for (int i = 0; i < N; i++) {
        float q_exch = 0.85f*SIG*NA[i]*(tc4 - t4v[i]);
        // THE SAND INSIDE THE TANDOOR: under the hearth (i == NB) and the
        // floor (i == NB+1) a sand column of ka_bed layers (depth ds[70]
        // m, conductivity ds[71] W/mK, >= 5 cm a layer) replaces the
        // wall's sub/deep path: the surface node feeds the top layer,
        // the bottom leaks to the soil halo, explicit like the rest
        const int sn = (i == NB) ? 0 : ((i == NB + 1) ? 1 : -1);
        if (sn >= 0 && ka_bed > 0) {
            device float* tc = s + SB + sn*KSAND;
            const float A_ = NA[i], kk = ds[71], dz = ds[70]/(float)ka_bed;
            const float C_ = A_*dz*SAND_RC, G_ = A_*kk/dz;
            const float Gt = A_/(0.0075f/1.1f + 0.5f*dz/kk), Gb = A_*1.0f;
            const float qtop = Gt*(Tv[i] - tc[0]);
            const float qbot = Gb*(tc[ka_bed-1] - Th);
            float qin[KSAND];
            for (int l = 0; l < ka_bed; l++) {
                const float qa = (l == 0) ? qtop : G_*(tc[l-1] - tc[l]);
                const float qb = (l == ka_bed-1) ? qbot : G_*(tc[l] - tc[l+1]);
                qin[l] = qa - qb;
            }
            for (int l = 0; l < ka_bed; l++) tc[l] += qin[l]*dt/C_;
            qv[i] = qv[i] + q_exch - qtop;
            q2sum += qbot;
            continue;
        }
        float q01 = G01[i]*(Tv[i] - Tsub[i]);
        float q12 = G12[i]*(Tsub[i] - Tdeep[i]);
        float q2s = (G2S[i]*ds[45])*(Tdeep[i] - Th);
        qv[i] = qv[i] + q_exch - q01;
        Tsub[i] += (q01 - q12)*dt/(CS[i]*ds[46]);
        Tdeep[i] += (q12 - q2s)*dt/(CD_[i]*ds[46]);
        q2sum += q2s;
    }
    s[3*N] = Th + (q2sum - sp[38]*(Th - sp[43]))*dt/sp[39];
    qv[NB+2] -= q_ap;
    for (int k = 0; k < NB; k++) {
        // dough exchanges at its own temperature: room-temp
        // coldstart warming to ~400 K at full bake (numpy twins)
        float fdn = clamp(max(bE[k], 0.0f)/ds[50], 0.0f, 1.0f);
        float qb = hb[k]*ds[49]*(Tv[k] - (sp[43] + 100.0f*fdn));
        qv[k] -= qb;
        bE[k] += qb*dt;
        bt_[k] += hb[k]*dt;
    }
    float dT_h = 0.0f;
    for (int i = 0; i < N; i++) {
        float dT = qv[i]*dt/(HC[i]*ds[46]);
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
        if (sp[25] > 0.5f) {
            float fkw = qsp[k]/max(ds[48], 1e-6f)/1000.0f;
            cdot += max(fkw - 8.0f, 0.0f)/1000.0f*validc;
        }
        bC[k] += hb[k]*cdot*dt;
        bool has = hb[k] > 0.5f;
        bool ready = has && (bE[k] >= ds[50]);
        bool ckd = ready && pull;
        bool scd = has && (bC[k] >= 1.0f);
        // NO doughy timeout: cooked or charred only (numpy twins)
        cooked_n += ckd ? 1.0f : 0.0f;
        scorch_n += scd ? 1.0f : 0.0f;
        if (ckd || scd) {
            hb[k] = 0.0f; bE[k] = 0.0f; bt_[k] = 0.0f; bC[k] = 0.0f;
        }
    }
    // ---- THE CUSTOMERS (sp[57] > 0.5: the demand process). Arrivals
    // per step from the three-band rate, a queue with a patience, a
    // shelf with a life; a roti counts when it meets an order
    float sold_n = cooked_n, stale_n = 0.0f;
    if (sp[66] > 0.5f) {
        // a customer arrives with an order: half want a few (3), most of
        // the rest a family's ten, one in ten a lunch or dinner of thirty
        // (mean 8.5); customers/day = rotis/day / 8.5, at most one a step
        const float ts_ = mprm[0] + sp[42];
        const float lam_c = demand_rate(ts_, sp[67]*ds[56]/8.5f) * dt/3600.0f;
        const float u1 = ru[b*RU+16], u2 = ru[b*RU+17];
        const float size = (u2 < 0.5f) ? 3.0f : ((u2 < 0.9f) ? 10.0f : 30.0f);
        const float arr = (u1 < lam_c) ? size : 0.0f;
        float ord = s[SD+0] + arr, shelf = s[SD+1] + cooked_n;
        const float sale = min(ord, shelf);
        ord -= sale; shelf -= sale;
        stale_n = floor(shelf*dt/(sp[68]*60.0f) + ru[b*RU+18]);
        shelf -= stale_n;
        const float leave = floor(ord*dt/(sp[69]*60.0f) + ru[b*RU+19]);
        ord -= leave;
        s[SD+0] = ord; s[SD+1] = shelf; s[SD+2] += sale;
        sold_n = sale;
    }
    r += 5.0f*sold_n - 5.0f*scorch_n - 0.5f*spall - sp[70]*stale_n;
    s[S0+9] += sold_n;
    s[S0+34] += sold_n;      // day_rotis: cut-immune daily count (sold, with the demand process)
    s[S0+10] += scorch_n;
    s[S0+8] += dt;
    // ---- the lean's dough (numpy twins line for line): either the
    // POLICY's load-mask heads place it (load_ctrl) or the cook's
    // xor hash sprays it. Only physics either way: empty bins only,
    // loaves_per_load per lean.
    if (s[S0+8] >= sp[20]) {
        int LPL = (int)ds[52];
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
    // HOLDING COST (numpy twins line for line): in-flight loaves
    // drip 0.3/loaves_per_load per step
    float hold_infl = 0.0f;
    for (int k = 0; k < NB; k++) hold_infl += hb[k];
    r -= (0.03f / max(ds[52], 1.0f)) * hold_infl;
    // DONENESS POTENTIAL (numpy twins line for line): +2 per full
    // loaf-equivalent of energy INTO dough, telescoped
    float phi_new = 0.0f;
    for (int k = 0; k < NB; k++)
        phi_new += clamp(bE[k]/ds[50], 0.0f, 1.0f);
    r += 2.0f*(phi_new - phi_old);
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
    // THE EVENING: once the sun is below the mount's minimum (sp[14])
    // there is nothing to track - the pointing potential freezes and
    // the lost counter does not run; the cook bakes from stored heat
    const bool sun_up = s[S0+27] >= sp[14];
    float potn = sun_up ? min(fabs(e_az2) + fabs(e_el2), 4.0f) : s[S0+29];
    r += 1.0f*(s[S0+29] - potn);
    s[S0+20] = e_az2; s[S0+21] = e_el2;
    bool lost = sun_up && ((fabs(e_az2) + fabs(e_el2)) > sp[64]);
    s[S0+16] = lost ? s[S0+16] + 1.0f : 0.0f;
    bool cut = s[S0+16] >= 40.0f;
    s[S0+12] += r;
    s[S0+13] += 1.0f;
    // ---- lost-sun truncation. Fresh-pot mode (ip[10] == 0): ALWAYS
    // COLD, charge-and-crash closed by refunding the wiped state's
    // potential. Carry-over mode (ip[10] == 1, the physical model): a
    // lost mount is a lost mount - the crew re-acquires the sun at the
    // penalty, the pot, the sand, the halo and the loaves keep their
    // physics, nothing is refunded because nothing is wiped
    float trv = 0.0f;
    const bool phys_cut = ip[10] > 0;
    if (cut) {
        float nb_ = 0.0f;
        if (!phys_cut) {
            for (int k = 0; k < NB; k++) {
                nb_ += hb[k];
                nb_ += (2.0f/0.3f)*clamp(bE[k]/ds[50], 0.0f, 1.0f);
                nb_ += (0.05f/0.3f)*max(min(s[k], sp[27]) - 350.0f,
                                        0.0f);
            }
        }
        r -= 0.3f*nb_ + sp[63];   // + fixed truncation penalty
        if (!phys_cut) {
            for (int i = 0; i < N; i++) {
                float nt = 350.0f + (ru[b*RU + 1 + i] - 0.5f)*30.0f;
                s[i] = nt; Tsub[i] = nt; Tdeep[i] = nt;
            }
            // the sand columns follow the fresh pot's hearth and floor
            for (int n = 0; n < 2; n++)
                for (int l = 0; l < KSAND; l++) s[SB + n*KSAND + l] = s[NB + n];
            s[3*N] = 300.0f;
        }
        s[S0+9] = 0.0f; s[S0+10] = 0.0f; s[S0+11] = 0.0f;
        s[S0+12] = 0.0f; s[S0+13] = 0.0f;
        if (!phys_cut) {
            for (int k = 0; k < NB; k++) {
                bE[k] = 0.0f; bt_[k] = 0.0f; hb[k] = 0.0f;
                bC[k] = 0.0f;      // fresh dough carries no char
            }
            s[S0+1] = sp[1]; s[S0+0] = sp[1];
        }
        float el1, az1d;
        solar_pos(lat[b], day[b], mprm[0] + sp[42], &el1, &az1d);
        az1d = az1d - ds[75]*180.0f/PI_;          // the crew re-acquires the sun in the SITE's frame (mount_solve's)
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
    float hn = (mprm[0] + sp[42] - 8.0f)/8.0f;   // the clock feature stays 8-based whatever the day's span
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
    for (int k = 0; k < NB; k++) ob[o++] = bE[k]/ds[50];
    for (int k = 0; k < NB; k++) ob[o++] = bC[k];
    ob[o++] = p_in/6000.0f;
    ob[o++] = s[S0+4];
    ob[o++] = clamp(fabs(s[S0+7] - s[S0+31])/10.0f, 0.0f, 3.0f);
    ob[o++] = clamp((e_el2 + 0.03f*rn[b*12+8])/0.5f, -sp[65], sp[65]);
    ob[o++] = clamp((e_az2 + 0.03f*rn[b*12+9])/0.5f, -sp[65], sp[65]);
    if (sp[24] > 0.5f) {
        ob[o++] = (s[S0+22] - sp[40])/2.0f;
        ob[o++] = (s[S0+23] - sp[41])/1.0f;
        int kb2 = ((int)((s[S0+22] + PI_)/(2.0f*PI_)*(float)NB)) % NB;
        for (int k = 0; k < NB; k++)
            ob[o++] = (k == kb2) ? 1.0f : 0.0f;
    }
    if (sp[62] > 0.5f)
        for (int k = 0; k < NB; k++) ob[o++] = hb[k];
    // the sand columns' mean temperature: the stored heat the cook can
    // bank on (the node's surface when there is no bed)
    for (int n = 0; n < 2; n++) {
        float m = 0.0f;
        for (int l = 0; l < ka_bed; l++) m += s[SB + n*KSAND + l];
        ob[o++] = ((ka_bed > 0) ? m/(float)ka_bed : s[NB + n]) / 1000.0f;
    }
    if (sp[66] > 0.5f) {              // the queue and the shelf
        ob[o++] = clamp(s[SD+0]/10.0f, 0.0f, 3.0f);
        ob[o++] = clamp(s[SD+1]/10.0f, 0.0f, 3.0f);
    }
    for (int k = 0; k < ND; k++) ob[o++] = dsn[b*ND + k];
    diag[b*8+0] = p_in;
    diag[b*8+1] = e_el2;
    diag[b*8+2] = e_az2;
    diag[b*8+3] = q_direct/max(ds[48], 1e-6f);
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

    def mount(self, day_t, lat_t, prm_t, B, pnt=None, fct=None):
        """The mount solve as ONE kernel launch: B threads, each env
        computes its own sun, beta schedule and frames in registers.
        Returns the same dict contract as tandoor_mount_batch."""
        dev = day_t.device
        key = (B, dev)
        bufs = self._mbuf.get(key)
        if bufs is None:
            z = lambda n: torch.empty(B, n, dtype=torch.float32,
                                      device=dev)
            bufs = (z(21), z(9), z(3), z(9), z(7), z(8),
                    torch.tensor([B], dtype=torch.int32, device=dev),
                    torch.full((B, 2), -999.0, dtype=torch.float32, device=dev))
            self._mbuf[key] = bufs
        vp, Mt, Cd, Ac, scb, aux, nB, nopnt = bufs
        pnt_t = nopnt if pnt is None else pnt.to(torch.float32).contiguous()
        fct_t = fct
        if fct_t is None:
            # no design table: every env the nominal machine (from prm)
            fct_t = torch.zeros(B, 72, dtype=torch.float32, device=prm_t.device)
            fct_t[:, 40] = 1.0; fct_t[:, 41] = 1.0; fct_t[:, 44:47] = 1.0; fct_t[:, 61:70] = 1.0   # [60] = block 0, the built dish
            fct_t[:, 42] = prm_t[4]; fct_t[:, 53] = prm_t[12]
            fct_t[:, 54] = prm_t[3]; fct_t[:, 55] = prm_t[5]
        self.lib.mount_solve(vp, Mt, Cd, Ac, scb, aux,
                             day_t.contiguous(), lat_t.contiguous(),
                             prm_t, nB, pnt_t, fct_t.contiguous())
        return dict(vp=vp, Mt=Mt.view(B, 3, 3), Cd=Cd,
                    Acan=Ac.view(B, 3, 3), scb=scb, aux=aux,
                    el=aux[:, 0], az=aux[:, 1], el_b=aux[:, 2],
                    beta_t=aux[:, 6])

    def __call__(self, pts_l, nrm_l, lv, du, de, upick, us, sigb,
                 Acan, Mt, Cd, dvec, off, vp, sc, ellM, ellS, ellC,
                 V0t, ray_pw, soil, n_nodes, aim, scb, fct=None):
        B, P = du.shape
        S = max(1, int(ray_pw.numel()) // P)      # surface blocks (the built circle + installed sections)
        L = pts_l.shape[0] // S                    # pressure levels per block
        dev = du.device
        thr = torch.empty(B * P, dtype=torch.float32, device=dev)
        out6 = torch.empty(B * P, 6, dtype=torch.float32, device=dev)
        fate = torch.zeros(B * P, 6, dtype=torch.float32, device=dev)   # the miss ledger: code, stop xyz, surface, bin
        pex = torch.zeros(B * 37, dtype=torch.float32, device=dev)       # exterior flux, NX = 37 bins (see the MSL define)
        assert fct is None or fct.shape[-1] == 82, f"design table is {fct.shape[-1]} wide, the kernel indexes at FCTW 82"
        NBL = 8                                   # loaf columns after the nodes
        per = torch.zeros(B, n_nodes + NBL, dtype=torch.float32, device=dev)
        key = (B, P, L, S, n_nodes, dev)
        dims = self._dims.get(key)
        if dims is None:
            dims = torch.tensor([B, P, L, n_nodes + NBL, S],
                                dtype=torch.int32, device=dev)
            self._dims[key] = dims
        lfp = getattr(self, "_lfp", None)
        if lfp is None or lfp.device != dev:
            lfp = torch.tensor([float(getattr(self, "loaf_h", 0.1732))],
                               dtype=torch.float32, device=dev)
            self._lfp = lfp
        c = lambda t: t.contiguous()
        if fct is None:
            # no per-env table given: every row is the shared static block
            row = torch.zeros(82, dtype=torch.float32, device=dev)   # FCTW - the kernel indexes b*FCTW, so this width is not optional
            k = min(39, max(0, int(sc.shape[0]) - 106))
            row[:k] = sc[106:106 + k]
            row[39] = sc[13]
            row[40] = 1.0; row[41] = 1.0; row[44:47] = 1.0; row[61:70] = 1.0   # [60] = block 0, the built dish
            row[51] = float(getattr(self, "loaf_h", 0.1732))
            # the receiver's own columns for an env with no design table: the built
            # machine is the Cassegrain, its elbow is whatever sc[105] says, and the
            # aim head is the elbow's +-110 deg (SPOT_PHI_RANGE)
            row[72] = 0.0
            row[73] = sc[105] if int(sc.shape[0]) > 105 else 0.0
            row[74] = 1.9198622
            row[75] = 0.0; row[76] = 1.0; row[77] = 1.0                                   # site: no azimuth offset, the nominal pit
            row[78] = -1.2422951; row[79] = 1.2692112; row[80] = 1.2102675; row[81] = 2.44   # ...its sphere (Z_CPOT, R_SPH, R_DUCT_WALL, H_DEPTH)
            fct = row[None, :].expand(B, -1)
        self.lib.tandoor_trace(
            thr, out6, c(pts_l), c(nrm_l), c(lv), c(du), c(de), c(upick),
            c(sigb), c(dvec.reshape(B, -1)[:, :2]), c(off), c(vp), c(sc),
            c(Acan), c(Mt), c(Cd), c(ellM), c(ellS), c(ellC), c(V0t),
            dims, c(ray_pw), c(soil), per, c(us), c(aim), c(scb), lfp,
            c(fct), fate, pex)
        self.last_fate = fate.view(B, P, 6)          # (code, stop xyz, surface, bin) per ray - read it after the call
        self.last_pex = pex.view(B, 37)              # watts per exterior surface bin
        return thr.view(B, P), out6.view(B, P, 6), per

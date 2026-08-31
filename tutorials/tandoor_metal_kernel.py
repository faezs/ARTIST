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
    device const float* vp     [[buffer(11)]],  // (7,3)
    device const float* sc     [[buffer(12)]],  // (22)
    device const float* Acan   [[buffer(13)]],  // (3,3)
    device const float* Mt     [[buffer(14)]],  // (3,3)
    device const float* Cd     [[buffer(15)]],  // (3)
    device const float* ellM   [[buffer(16)]],
    device const float* ellS   [[buffer(17)]],
    device const float* ellC   [[buffer(18)]],
    device const float* V0     [[buffer(19)]],
    device const int*   dims   [[buffer(20)]],  // B, P, L, n_nodes
    device const float* ray_pw [[buffer(21)]],
    device const float* soil   [[buffer(22)]],
    device float*       per_dni [[buffer(23)]],  // (B, n_nodes) zeroed
    device const float* us     [[buffer(24)]],  // (B*P) sun-table u
    uint tid [[thread_position_in_grid]])
{
    const int B = dims[0], P = dims[1], L = dims[2];
    if (tid >= uint(B*P)) return;
    const int b = tid / P, ip = tid % P;
    const float3 ut   = float3(vp[0],  vp[1],  vp[2]);
    const float3 Pf   = float3(vp[3],  vp[4],  vp[5]);
    const float3 sdir = float3(vp[6],  vp[7],  vp[8]);
    const float3 epp  = float3(vp[9],  vp[10], vp[11]);
    const float3 nf   = float3(vp[12], vp[13], vp[14]);
    const float3 epar = float3(vp[15], vp[16], vp[17]);
    const float3 eprp = float3(vp[18], vp[19], vp[20]);
    const float3 CdV  = float3(Cd[0], Cd[1], Cd[2]);

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
    float3 inc = mrow(v, Acan);
    // ARTIST reflect: d - 2 (d.n) n
    float3 d1 = inc - 2.0f*dot(inc, n_loc)*n_loc;

    // ---- to world
    float3 p = vmatT(p_loc, Mt) + CdV;
    float3 d = normalize(vmatT(d1, Mt));

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
    lit = lit && !((dot(q, sdir) > sc[1]) && (fabs(dot(q, epp)) < sc[2]));

    // ---- the fold
    float den = dot(d, nf);
    float denu = (fabs(den) > 1e-9f) ? den : 1e-9f;
    float t1 = dot(Pf - p, nf) / denu;
    float3 h1 = p + t1*d;
    float3 rel1 = h1 - Pf;
    float c_par = dot(rel1, epar) * sc[14];
    float c_prp = dot(rel1, eprp);
    // compliant toroidal fold: sc[103]=1/R_t, sc[104]=1/R_s (0 = flat)
    float3 n_tor = nf - sc[103]*dot(rel1, epar)*epar
                      - sc[104]*dot(rel1, eprp)*eprp;
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
            // CONCAVE ELBOW (duct_nozzle 2): mirror 0.35 m inside
            // the pot images the duct waist onto far-wall baking
            // node 6. Literals derived in tandoor_polar_env.
            const float3 A0 = float3(0.0f, 0.9606134f, 0.2778882f);
            const float3 MM = float3(0.0f, -0.8740528f, -0.7627391f);
            const float3 A1 = float3(-0.2117196f, 0.9699902f,
                                     0.1195568f);
            const float FN = 0.2956729f;
            float3 o3 = float3(ox, oyv, oz);
            float3 d3w = float3(dxw, dyw, dzw);
            float da = max(dot(d3w, A0), 1e-6f);
            float tmn = dot(MM - o3, A0) / da;
            float3 q3 = o3 + tmn*d3w - MM;
            // rotate a0 -> a1 (rows of R baked in)
            const float3 R0 = float3(0.9771883f, -0.1987488f,
                                     -0.0748461f);
            const float3 R1 = float3(0.2080126f, 0.9667706f,
                                     0.1486115f);
            const float3 R2 = float3(0.0428227f, -0.1607904f,
                                     0.9860592f);
            d3w = float3(dot(R0, d3w), dot(R1, d3w), dot(R2, d3w));
            q3 = float3(dot(R0, q3), dot(R1, q3), dot(R2, q3));
            float3 qp = q3 - dot(q3, A1)*A1;
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
                    * (sc[105] > 0.5f ? 0.95f : 1.0f);
        atomic_fetch_add_explicit(
            (device atomic_float*)&per_dni[b*dims[3] + node],
            wgt, memory_order_relaxed);
    }
}
"""


class MetalGeo:
    """Wraps the megakernel; call signature mirrors the fused-core args."""

    def __init__(self):
        self.lib = torch.mps.compile_shader(MSL)

    def __call__(self, pts_l, nrm_l, lv, du, de, upick, us, sigb,
                 Acan, Mt, Cd, dvec, off, vp, sc, ellM, ellS, ellC,
                 V0t, ray_pw, soil, n_nodes):
        B, P = du.shape
        L = pts_l.shape[0]
        dev = du.device
        thr = torch.empty(B * P, dtype=torch.float32, device=dev)
        out6 = torch.empty(B * P, 6, dtype=torch.float32, device=dev)
        per = torch.zeros(B, n_nodes, dtype=torch.float32, device=dev)
        dims = torch.tensor([B, P, L, n_nodes], dtype=torch.int32,
                            device=dev)
        c = lambda t: t.contiguous()
        self.lib.tandoor_trace(
            thr, out6, c(pts_l), c(nrm_l), c(lv), c(du), c(de), c(upick),
            c(sigb), c(dvec.reshape(B, -1)[:, :2]), c(off), c(vp), c(sc),
            c(Acan), c(Mt), c(Cd), c(ellM), c(ellS), c(ellC), c(V0t),
            dims, c(ray_pw), c(soil), per, c(us))
        return thr.view(B, P), out6.view(B, P, 6), per

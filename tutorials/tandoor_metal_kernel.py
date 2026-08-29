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

    // ---- ARTIST sun cone: rotate_distortions (heliostat convention,
    // sin_e NEGATED) applied to the canonical ray (0,1,0)
    float sg = (upk[tid] < sc[20]) ? sc[21] : sigb[b];
    float ea = de[tid]*sg, ua = du[tid]*sg;
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
    float rad1 = sqrt(c_par*c_par + c_prp*c_prp);
    bool graze = hits_column(px_,py_,pz_, d.x,d.y,d.z,
                             sc[18], sc[16], sc[17], 0.0f, t1-0.10f)
              || hits_column(px_,py_,pz_, d.x,d.y,d.z,
                             sc[19], sc[4], sc[3], 0.0f, t1-0.10f);
    bool ok = lit && !graze && (t1 > 0.0f) && (rad1 < sc[0]);
    float3 d2 = d - 2.0f*dot(d, nf)*nf;

    const float dv0 = dvec[b*2], dv1 = dvec[b*2+1];
    // ---- the CPC lip, one traced bounce
    float Xo = h1.x - sc[10] + dv0, Yo = h1.y + dv1;
    float rz0 = sc[7] + sc[6]*(h1.z - sc[3]);
    float qa = d2.x*d2.x + d2.y*d2.y - (sc[6]*d2.z)*(sc[6]*d2.z);
    float qb = 2.0f*(Xo*d2.x + Yo*d2.y - sc[6]*rz0*d2.z);
    float qc = Xo*Xo + Yo*Yo - rz0*rz0;
    float disc = qb*qb - 4.0f*qa*qc;
    float sq = sqrt(max(disc, 0.0f));
    float tc  = (fabs(qa) > 1e-9f) ? (-qb-sq)/(2.0f*qa)
                                   : -qc/max(qb, 1e-9f);
    float tc2 = (fabs(qa) > 1e-9f) ? (-qb+sq)/(2.0f*qa) : tc;
    tc = (tc > 1e-4f) ? tc : tc2;
    float zc = h1.z + tc*d2.z;
    bool hitsw = (disc > 0.0f) && (tc > 1e-4f)
                 && (zc > sc[3]) && (zc < sc[5]);
    float w = 1.0f;
    if (hitsw) {
        float hx = Xo + tc*d2.x, hy = Yo + tc*d2.y;
        float rc = max(sc[7] + sc[6]*(zc - sc[3]), 1e-6f);
        float3 nc = normalize(float3(hx, hy, -sc[6]*rc));
        d2 = d2 - 2.0f*dot(d2, nc)*nc;
        h1 = float3(hx + sc[10] - dv0, hy - dv1, zc);
        w = 0.95f;
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
    float tcb  = (fabs(qab) > 1e-9f) ? (-qbb-sqb)/(2.0f*qab)
                                     : -qcb/max(qbb, 1e-9f);
    float tcb2 = (fabs(qab) > 1e-9f) ? (-qbb+sqb)/(2.0f*qab) : tcb;
    tcb = (tcb > 1e-4f) ? tcb : tcb2;
    float zcb = h1.z + tcb*d2.z;
    bool hitsb = (discb > 0.0f) && (tcb > 1e-4f)
                 && (zcb > sc[9] + 0.35f) && (zcb < sc[4]);
    if (hitsb) {
        float hx = Xo + tcb*d2.x, hy = Yo + tcb*d2.y;
        float rc = max(sc[7] + sc[15]*(zcb - sc[4]), 1e-6f);
        float3 nc = normalize(float3(hx, hy, -sc[15]*rc));
        d2 = d2 - 2.0f*dot(d2, nc)*nc;
        h1 = float3(hx + sc[10] - dv0, hy - dv1, zcb);
        w *= 0.95f;
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
        const float RPOT = 0.42f, ZD = -0.86f, HP = 1.0f;
        const int NB = 8;
        float pxp = h3.y, pyp = h3.z - sc[11];
        float dxw = d3.y, dyw = -d3.x, dzw = d3.z;
        float ox = pxp, oyv = -RPOT, oz = pyp + ZD;
        float t_f = (-HP - oz) / min(dzw, -1e-6f);
        float fx = ox + t_f*dxw, fy = oyv + t_f*dyw;
        bool hitf = (fx*fx + fy*fy) <= RPOT*RPOT;
        float aq = dxw*dxw + dyw*dyw;
        float bq = ox*dxw + oyv*dyw;
        float cq = ox*ox + oyv*oyv - RPOT*RPOT;
        float t_w = (-bq + sqrt(max(bq*bq - aq*cq, 0.0f)))
                    / max(aq, 1e-9f);
        float wzv = oz + t_w*dzw;
        float sx = hitf ? fx : ox + t_w*dxw;
        float sy = hitf ? fy : oyv + t_w*dyw;
        float sz = hitf ? -HP : wzv;
        float phi = atan2(sy, sx);
        int seg = clamp(int((phi + M_PI_F) / (2.0f*M_PI_F) * NB),
                        0, NB - 1);
        int node = (hitf || sz < -HP + 0.12f) ? NB
                   : (sz > -0.22f ? NB + 2 : seg);
        float wgt = ray_pw[ip] * soil[b] * (thr ? w : 0.0f);
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

    def __call__(self, pts_l, nrm_l, lv, du, de, upick, sigb, Acan,
                 Mt, Cd, dvec, off, vp, sc, ellM, ellS, ellC, V0t,
                 ray_pw, soil, n_nodes):
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
            dims, c(ray_pw), c(soil), per)
        return thr.view(B, P), out6.view(B, P, 6), per

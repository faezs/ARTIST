"""The drag acts at the dish, 1.8 m in front of the boom tip: the boom also sees a tip MOMENT P*D_REC*(n.bu).
How much does that add to the walk, and does it change which member matters?"""
import contextlib, io, sys, numpy as np, torch
exec(open("pivot2.py").read().split("R = np.array(rows)")[0].replace(
    "rows.append((float(Lb), float(g_tr), float(g_rot), float(g_rot_C), abs(float((w*n).sum())), float(torch.linalg.norm(Ff - C[0]))))",
    "rows.append((float(Lb), float(g_tr), float(g_rot), float((n*bu).sum()), abs(float((w*n).sum())), float(torch.linalg.norm(Ff - C[0]))))"))
R = np.array(rows); Lb, gtr, grot, nbu, cosw, D = R.T
Ls = 1.0; wgt = 0.25 + 0.75*cosw*cosw
def rms_w(x): return float(np.sqrt(np.sum(wgt*x*x)/np.sum(wgt)))
def walk(th, de): return np.abs(grot*th + gtr*de)
def chain(Lb_, kb=1.0, ks=1.0, moment=True):
    M = D_REC*nbu if moment else 0.0*nbu                       # tip moment per newton of transverse force at the vertex
    th_s = (Ls*Ls/2 + Lb_*Ls)*ks/EI_STEM + M*Ls*ks/EI_STEM; d_s = (Ls**3/3 + Lb_*Ls*Ls/2)*ks/EI_STEM + M*Ls*Ls*ks/(2*EI_STEM)
    th_b = Lb_*Lb_/(2*EI_BOOM*kb) + M*Lb_/(EI_BOOM*kb); d_b = Lb_**3/(3*EI_BOOM*kb) + M*Lb_*Lb_/(2*EI_BOOM*kb)
    return th_s + th_b, d_s + th_s*Lb_ + d_b
print(f"n.bu over the year: median {np.median(nbu):+.2f}, range {nbu.min():+.2f}..{nbu.max():+.2f}  (the head's axis vs the boom)")
b0 = rms_w(walk(*chain(Lb, moment=False))); b1 = rms_w(walk(*chain(Lb)))
print(f"walk per newton, force only {1e6*b0:.2f} um/N; force + tip moment {1e6*b1:.2f} um/N ({b1/b0:.2f}x)")
for lab, kw in (("boom 2x", dict(kb=2)), ("boom 4x", dict(kb=4)), ("boom rigid", dict(kb=1e9)), ("stem rigid", dict(ks=1e-9))):
    f = rms_w(walk(*chain(Lb, **kw))); print(f"   {lab:<12} {1e6*f:6.2f} um/N  {b1/f:5.2f}x")
# where the neutral point sits relative to the boom's own centre WITH the moment: theta/delta of the boom alone
th_b = Lb*Lb/(2*EI_BOOM) + D_REC*nbu*Lb/EI_BOOM; d_b = Lb**3/(3*EI_BOOM) + D_REC*nbu*Lb*Lb/(2*EI_BOOM)
print(f"the boom's own centre behind the tip: force-only 2Lb/3 = {np.median(2*Lb/3):.2f} m, with the moment {np.median(d_b/th_b):.2f} m; neutral {np.median(-grot/gtr):.2f} m")

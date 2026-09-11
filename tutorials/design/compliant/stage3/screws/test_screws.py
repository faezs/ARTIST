"""tandoor_screws against what the envs already compute, in float64:
  1. the adjoints: ad_wrench(T) = ad_twist(T^-1)^T, and power is invariant under transport
  2. exp_screw: the axis point is fixed, a revolute rotates, a slide translates
  3. the pedicel chain (5 screws) against tandoor_flower_env.pedicel_fk on random joints
  4. the hashemi chain (4 screws) against the kernel's own arithmetic (um, ub, naim, Cd) and back through pointing_from_frame
  5. the beam 6 x 6 in series against tandoor_flower_env.compliance for the boom (the stem's term is a planar idealisation)
  6. the crown screws against the fast env's small-angle normal perturbation
  7. apply_rows (the kernel's walk, in torch) against poe() with an elastic twist on top
  8. fork_compliance: symmetric, the elevation freedom at the jacks' stiffness, translations at F stiff
run:  cd ~/ARTIST-compliant/tutorials && puffer_tandoor/.venv/bin/python design/compliant/stage3/screws/test_screws.py"""
import os, sys, math, numpy as np, torch
HERE = os.path.dirname(os.path.abspath(__file__)); TUT = os.path.abspath(os.path.join(HERE, "..", "..", "..", ".."))
sys.path.insert(0, os.path.dirname(TUT)); sys.path.insert(0, TUT)                    # this checkout's artist/ and tutorials/
import tandoor_screws as SC
import tandoor_flower_env as FE
assert SC.__file__.startswith(TUT) and FE.__file__.startswith(TUT), (SC.__file__, FE.__file__)
torch.manual_seed(3); dt = torch.float64; B = 64
def rnd(*s): return torch.randn(*s, dtype=dt)
def unit(v): return v/torch.linalg.norm(v, dim=-1, keepdim=True)
fails = []
def check(name, err, tol):
    ok = err <= tol; print(f"  {'ok ' if ok else 'FAIL'} {name:<70} {err:.2e} (tol {tol:.0e})")
    if not ok: fails.append(name)

print("1. adjoints")
T = SC.exp_screw(unit(rnd(B, 3)), rnd(B, 3), torch.zeros(B, dtype=dt), rnd(B)); T[:, :3, 3] += rnd(B, 3)
check("ad_wrench(T) == ad_twist(T^-1)^T", (SC.ad_wrench(T) - SC.ad_twist(SC.inverse(T)).transpose(1, 2)).abs().max().item(), 1e-12)
xi, W = rnd(B, 6), rnd(B, 6)
p0 = (xi*W).sum(1); p1 = (torch.bmm(SC.ad_twist(T), xi[:, :, None])[:, :, 0]*torch.bmm(SC.ad_wrench(T), W[:, :, None])[:, :, 0]).sum(1)
check("power xi.W invariant under transport", (p0 - p1).abs().max().item(), 1e-12)
Cb = rnd(B, 6, 6); Cb = torch.bmm(Cb, Cb.transpose(1, 2))
check("transport_compliance keeps symmetry", (SC.transport_compliance(Cb, T) - SC.transport_compliance(Cb, T).transpose(1, 2)).abs().max().item(), 1e-10)

print("2. exp_screw")
w = unit(rnd(B, 3)); q = rnd(B, 3); th = rnd(B)
Tr = SC.exp_screw(w, q, torch.zeros(B, dtype=dt), th)
check("revolute: the axis point stays put", (SC.move_points(Tr, q[:, None, :])[:, 0] - q).abs().max().item(), 1e-12)
p = rnd(B, 3); pr = SC.move_points(Tr, p[:, None, :])[:, 0]
check("revolute: distance to the axis preserved", (torch.linalg.norm(torch.cross(pr - q, w, dim=1), dim=1) - torch.linalg.norm(torch.cross(p - q, w, dim=1), dim=1)).abs().max().item(), 1e-12)
Ts = SC.exp_screw(w, q, torch.full((B,), SC.PRISMATIC, dtype=dt), th)
check("slide: pure translation theta w", (SC.move_points(Ts, p[:, None, :])[:, 0] - (p + th[:, None]*w)).abs().max().item(), 1e-12)

print("3. the pedicel chain against pedicel_fk")
T0 = rnd(B, 3)*2; T0[:, 2] += 5
q = dict(slew=torch.rand(B, dtype=dt)*360 - 180, luff=torch.rand(B, dtype=dt)*120 - 60, ext=torch.rand(B, dtype=dt)*6 + 0.5,
         pitch=torch.rand(B, dtype=dt)*160 - 80, yaw=torch.rand(B, dtype=dt)*160 - 80)
C_ref, n_ref = FE.pedicel_fk(T0, q)
ch = SC.pedicel_chain(T0, FE.D_REC, dtype=dt); Tn = SC.poe(ch["screws"], SC.pedicel_theta(q), SC.frame_at(ch["C0"]))
C_poe = Tn[:, :3, 3]; n_poe = torch.bmm(Tn[:, :3, :3], ch["n0"][:, :, None])[:, :, 0]
check("vertex", (C_poe - C_ref).abs().max().item(), 1e-9); check("axis", (n_poe - n_ref).abs().max().item(), 1e-9)

print("4. the hashemi chain against the kernel's arithmetic")
Pf = torch.tensor([[4.0, 0.0, 8.47]], dtype=dt).expand(B, 3).clone(); g = 4.0
el = torch.rand(B, dtype=dt)*80 + 5; az = torch.rand(B, dtype=dt)*360; beta = torch.rand(B, dtype=dt)*40
elr, azr, br = torch.deg2rad(el), torch.deg2rad(az), torch.deg2rad(beta)
um = torch.stack([torch.cos(elr)*torch.cos(azr), torch.cos(elr)*torch.sin(azr), torch.sin(elr)], 1)
zh = torch.zeros(B, 3, dtype=dt); zh[:, 2] = 1
axu = unit(torch.cross(zh, um, dim=1))
ub = um*torch.cos(br)[:, None] + torch.cross(axu, um, dim=1)*torch.sin(br)[:, None] + axu*(axu*um).sum(1, keepdim=True)*(1 - torch.cos(br))[:, None]
naim = unit(um + ub); Cd = Pf - g*ub
ch = SC.hashemi_chain(Pf, g, dtype=dt); Th = SC.poe(ch["screws"], SC.hashemi_theta(el, az, beta), SC.frame_at(ch["C0"]))
C_h = Th[:, :3, 3]; n_h = torch.bmm(Th[:, :3, :3], ch["n0"][:, :, None])[:, :, 0]
check("vertex Cd = Pf - g ub", (C_h - Cd).abs().max().item(), 1e-9); check("axis = bisector of um and ub", (n_h - naim).abs().max().item(), 1e-9)
um2, ub2, b2 = SC.pointing_from_frame(C_h, n_h, Pf)
check("pointing_from_frame recovers um", (um2 - um).abs().max().item(), 1e-9); check("recovers ub", (ub2 - ub).abs().max().item(), 1e-9)
check("recovers beta (deg)", (b2 - beta).abs().max().item(), 1e-7)

print("5. the beam 6 x 6 against compliance() for the boom (stem rigid)")
Lb = torch.rand(B, dtype=dt)*6 + 0.5; a = torch.rand(B, dtype=dt)*math.pi - math.pi/2
x = torch.zeros(B, 3, dtype=dt); x[:, 0] = 1; z = zh
T0 = torch.zeros(B, 3, dtype=dt); T0[:, 2] = 1.0; Cb = T0 + Lb[:, None]*x
n = torch.stack([torch.cos(a), torch.zeros_like(a), torch.sin(a)], 1)
m_tip = FE.D_REC*(n*x).sum(1)
for kind in ("uniform", "reversed"):
    ref = FE.compliance(Lb, kind, FE.BOOM_RATIO, FE.BOOM_ROOT, m_tip=m_tip)
    Csix = SC.pedicel_compliance(T0, Cb, n, FE.D_REC, 1e30, FE.EI_BOOM, kind=kind, ratio=FE.BOOM_RATIO, root=FE.BOOM_ROOT)
    Cv = Cb + FE.D_REC*n; W_v = torch.cat([z, torch.zeros(B, 3, dtype=dt)], 1)                 # 1 N up at the vertex
    xi_v = torch.bmm(Csix, W_v[:, :, None])[:, :, 0]
    xi_t = torch.bmm(SC.ad_twist(SC.frame_at(Cv - Cb)), xi_v[:, :, None])[:, :, 0]           # the same twist read at the tip (the vertex sits at Cv - Cb in the tip frame)
    Ls = T0[:, 2]                                                                              # the scalar model's stem share, removed:
    th_s = (Ls*Ls/2 + Lb*Ls + m_tip*Ls)/FE.EI_STEM; d_s = (Ls**3/3 + Lb*Ls*Ls/2 + m_tip*Ls*Ls/2)/FE.EI_STEM
    theta_boom = ref["theta"] - th_s; delta_boom = ref["delta"] - d_s - th_s*Lb
    check(f"{kind}: tip rotation |omega_y| = theta per N", ((xi_t[:, 4].abs() - theta_boom)/theta_boom).abs().max().item(), 1e-9)
    # against the force-only scale, not delta itself (delta passes through zero where the tip moment unbends the boom); and
    # the 6 x 6 keeps what the scalar leaves out: the stem's AXIAL strain under the vertical newton, Ls/EA = 0.86 nm/N,
    # which is 12 % of a half-metre boom's bending and 0.1 % of a 6 m one's
    scale = Lb**3/(3*FE.EI_BOOM); axial = Ls/SC.chs_section(0.215, 0.009)[2]
    check(f"{kind}: tip deflection v_z = delta + Ls/EA per N", ((xi_t[:, 2] - delta_boom - axial)/scale).abs().max().item(), 1e-9)
# the record: the full 6 x 6 with the stem, under a HORIZONTAL crosswind force at the vertex, against the planar scalar
Cfull = SC.pedicel_compliance(T0, Cb, n, FE.D_REC, FE.EI_STEM, FE.EI_BOOM)
y = torch.zeros(B, 3, dtype=dt); y[:, 1] = 1
xi_y = torch.bmm(Cfull, torch.cat([y, torch.zeros(B, 3, dtype=dt)], 1)[:, :, None])[:, :, 0]
ref = FE.compliance(Lb, "uniform", m_tip=m_tip)
i = int(torch.argmin((Lb - 3.3).abs()))
print(f"  record: uniform boom {Lb[i]:.2f} m, crosswind 1 N at the vertex: 6x6 vertex walk {1e6*xi_y[i, 1]:.2f} um, tilt {1e6*torch.linalg.norm(xi_y[i, 3:]):.2f} urad"
      f" (stem in torsion for the boom's root moment); the planar scalar: delta {1e6*ref['delta'][i]:.2f} um, theta {1e6*ref['theta'][i]:.2f} urad")

print("6. the crown screws against the fast env's normal perturbation")
n0 = unit(rnd(B, 3)); xl, yl = FE.head_frame(n0); C0 = rnd(B, 3)
scr = SC.crown_screws(C0, n0, xl, yl, dtype=dt)
eps = 1e-3; th = torch.zeros(B, 3, dtype=dt); th[:, 0] = eps
Tc = SC.poe(scr, th, SC.frame_at(C0)); n1 = torch.bmm(Tc[:, :3, :3], n0[:, :, None])[:, :, 0]
check("tip: n + eps yl", (n1 - unit(n0 + eps*yl)).abs().max().item(), 1e-6)
th = torch.zeros(B, 3, dtype=dt); th[:, 1] = eps
Tc = SC.poe(scr, th, SC.frame_at(C0)); n1 = torch.bmm(Tc[:, :3, :3], n0[:, :, None])[:, :, 0]
check("tilt: n - eps xl", (n1 - unit(n0 - eps*xl)).abs().max().item(), 1e-6)
th = torch.zeros(B, 3, dtype=dt); th[:, 2] = 0.02
Tc = SC.poe(scr, th, SC.frame_at(C0)); check("piston: vertex + 0.02 n", (Tc[:, :3, 3] - (C0 + 0.02*n0)).abs().max().item(), 1e-12)

print("7. apply_rows (the kernel's walk) against poe, with an elastic twist")
T0 = rnd(B, 3)*2; T0[:, 2] += 5
ch = SC.pedicel_chain(T0, FE.D_REC, dtype=dt); xl0, yl0 = FE.head_frame(ch["n0"])
screws = torch.cat([ch["screws"], SC.crown_screws(ch["C0"], ch["n0"], xl0, yl0, dtype=dt)], 1)
theta = torch.cat([SC.pedicel_theta(q), (torch.rand(B, 3, dtype=dt) - 0.5)*0.04], 1)
Tp = SC.poe(screws, theta, SC.frame_at(ch["C0"])); C_p = Tp[:, :3, 3]; n_p = torch.bmm(Tp[:, :3, :3], ch["n0"][:, :, None])[:, :, 0]
rows = SC.mech_rows(B, dtype=dt); SC.set_chain(rows, screws, theta, ch["C0"], ch["n0"])
C_r, n_r = SC.apply_rows(rows)
check("chain only: vertex", (C_r - C_p).abs().max().item(), 1e-9); check("chain only: axis", (n_r - n_p).abs().max().item(), 1e-9)
xi = rnd(B, 6)*1e-3; SC.set_elastic(rows, xi); C_r, n_r = SC.apply_rows(rows)
C_e, n_e = SC.apply_twist(xi, C_p, n_p)
check("with the elastic twist: vertex", (C_r - C_e).abs().max().item(), 1e-12); check("axis", (n_r - n_e).abs().max().item(), 1e-12)
Cm = rnd(B, 6, 6)*1e-6; Cm = torch.bmm(Cm, Cm.transpose(1, 2))*1e3; Wv = rnd(B, 6)*100
SC.set_compliance(rows, Cm, Wv); C_r, n_r = SC.apply_rows(rows)
C_e, n_e = SC.apply_twist(xi + torch.bmm(Cm, Wv[:, :, None])[:, :, 0], C_p, n_p)
check("with C W as well: vertex", (C_r - C_e).abs().max().item(), 1e-12); check("axis", (n_r - n_e).abs().max().item(), 1e-12)

print("8. fork_compliance")
Pf = torch.tensor([[4.0, 0.0, 8.47]], dtype=dt).expand(4, 3).clone(); az = torch.tensor([0.0, 0.7, 1.5, 3.0], dtype=dt)
Cf = SC.fork_compliance(Pf, az)
check("symmetric", (Cf - Cf.transpose(1, 2)).abs().max().item(), 1e-18)
w_el = torch.stack([torch.sin(az), -torch.cos(az), torch.zeros_like(az)], 1)
Wm = torch.cat([torch.zeros(4, 3, dtype=dt), w_el], 1)                                           # 1 N m about the elevation axis
xi = torch.bmm(Cf, Wm[:, :, None])[:, :, 0]
check("1 N m about the axis turns 1/(2 x 50 MN m/rad)", ((torch.abs((xi[:, 3:]*w_el).sum(1)) - 1/(2*50e6))/(1/(2*50e6))).abs().max().item(), 1e-3)
Wf = torch.cat([torch.zeros(4, 3, dtype=dt), torch.zeros(4, 3, dtype=dt)], 1); Wf[:, 2] = 1.0     # 1 N up at F
xi = torch.bmm(Cf, Wf[:, :, None])[:, :, 0]
print(f"  1 N up at F moves F by {1e9*xi[:, 2].max():.3f} nm; 1 N m about the axis: {1e9*torch.abs(torch.bmm(Cf, Wm[:, :, None])[:, 3:, 0]*w_el).sum(1).max():.1f} nrad")
check("translations at F stiff (< 1 um/N)", xi[:, :3].abs().max().item(), 1e-6)

print("\nFAILED: " + ", ".join(fails) if fails else "\nall passed")
sys.exit(1 if fails else 0)

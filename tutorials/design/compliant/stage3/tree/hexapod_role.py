#!/usr/bin/env python
"""What the six struts are for, now that the pedicel covers the year on its own.

The crown's six struts run from the receptacle ring (r 1.5, 1.8 m behind the vertex) to the platform ring (r 1.0, 0.6 m
behind it). Both rings are built in the HEAD's own frame, so if the head is bolted to them the strut lengths cannot
depend on the pose - and the schedule confirms it below, over all 479 poses. The pedicel's five joints already span the
task's five freedoms (pedicel_screw.py: rank 5, never singular), so the hexapod does no coarse work at all. It has two
possible jobs and this prices both:
  (a) delete it: bolt the platform ring to the wrist, and save six struts, twelve flexure balls and their actuators;
  (b) make it the FINE, FAST stage - the pedicel carries a 4-5 m boom and a 210 kg head and cannot answer a gust, while
      six 1.45 m struts on flexure balls can. The wind runs say the job is real, and this sizes the stroke it needs."""
import os, sys, json, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
sys.path.insert(0, HERE); import path as PT
sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic")); import physics_hp as H
G, A_M, RC = PT.G, PT.A_M, PT.RC; F = PT.F; Z = np.array([0, 0, 1.0])
R_REC, R_PLAT, D_BACK, H_HEX = 1.5, 1.0, 0.6, 1.2
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
M_HEAD, M_REC = 130.0, 80.0                                        # the simulations' masses
E_ST, D_LEG, T_LEG = 200e9, 0.085, 0.0053                          # steel CHS 85 x 5.3
A_LEG = np.pi*(D_LEG*T_LEG - T_LEG**2)
def head_axes(n):
    xl = np.cross(Z, n)
    if np.linalg.norm(xl) < 1e-6: xl = np.array([0, 1.0, 0]) - n*n[1]
    xl = xl/np.linalg.norm(xl); return xl, np.cross(n, xl), n
def rings(P, n):
    xl, yl, _ = head_axes(n); Cp = P - D_BACK*n; Cb = P - (D_BACK + H_HEX)*n
    p = [Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG]
    b = [Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG]
    return np.array(b), np.array(p)
def leg_lengths(P, n):
    b, p = rings(P, n); return np.linalg.norm(p - b, axis=1)
def jac(P, n):
    """d(leg length) / d(head twist [dP; dtheta about the vertex])"""
    b, p = rings(P, n); J = np.zeros((6, 6))
    for j in range(6):
        u = p[j] - b[j]; u = u/np.linalg.norm(u); J[j, :3] = u; J[j, 3:] = np.cross(p[j] - P, u)
    return J
def miss_at_F(P, n, s):
    """how far the returned beam passes from F: the sphere sends the sun back along r = -s + 2(s.n)n from the vertex"""
    r = -s + 2*(s@n)*n; d = F - P; return np.linalg.norm(d - (d@r)*r)
def miss_gain(P, n, s, h=1e-4):
    """the 1 x 6 sensitivity of the miss at F to a head twist, by central difference"""
    g = np.zeros(6)
    for k in range(6):
        dP = np.zeros(3); dth = np.zeros(3)
        (dP if k < 3 else dth)[k % 3] = h
        def moved(sgn):
            nn = n + sgn*np.cross(dth, n); nn = nn/np.linalg.norm(nn); return miss_at_F(P + sgn*dP, nn, s)
        g[k] = (moved(+1) - moved(-1))/(2*h)
    return g
if __name__ == "__main__":
    lines = []
    def say(t=""): print(t, flush=True); lines.append(t)
    PJ = json.load(open(os.path.join(OUT, "path.json"))); LOG = [l for l in PJ["log"] if l.get("ok")]
    L = np.array([leg_lengths(np.array(l["P"]), np.array(l["n"])/np.linalg.norm(l["n"])) for l in LOG])
    say(f"1. THE COARSE JOB IS ZERO. Over all {len(LOG)} poses of the year's schedule the six struts hold")
    say(f"   {L.mean():.6f} m, spread {np.ptp(L):.2e} m ({1e3*np.ptp(L):.1e} mm). The rings are built in the head's frame, so the")
    say("   hexapod cannot point the head: the pedicel's five joints do all of it (rank 5, condition 4.4-7.2 over the year).")
    say()
    # ---- the fine job, sized at the equinox-noon pose
    l0 = [l for l in LOG if l["doy"] == 80 and abs(l["hour"] - 12.0) < 0.01][0]
    P0 = np.array(l0["P"]); n0 = np.array(l0["n"])/np.linalg.norm(np.array(l0["n"]))
    el, Az, s0 = H.sun(80, 12.0); s0 = np.asarray(s0, float)
    g = miss_gain(P0, n0, s0); J0 = jac(P0, n0)
    say("2. THE FINE JOB IS REAL. The Cosserat run at 12 m/s (setup_sim/out/fl_w12_ident.txt) left, with the coarse loop alone:")
    say("     miss at F  12.6 cm mean, 31.5 cm max     (half power at 4.9 cm)")
    say("     receptacle off its command  1.8 cm mean, 6.2 cm max;  stem tip 0.8 cm")
    say(f"   Sensitivity of the miss at F to a head twist at equinox noon (per metre and per radian):")
    say(f"     translation {np.array2string(g[:3], precision=2)}  rotation {np.array2string(g[3:], precision=2)} m/rad")
    say(f"   The miss answers to TILT, not to translation: the strongest column is {np.abs(g).max():.2f} m per rad of head rotation against")
    say(f"   {np.abs(g[:3]).max():.2f} m per m of translation, so the fine stage's job is to tilt the head a few tens of mrad. Through the")
    say("   hexapod's Jacobian, the least-norm twist that removes the miss and the leg strokes it costs:")
    for tag, amp in (("mean 12.6 cm", 0.126), ("max 31.5 cm", 0.315)):
        # the least-norm twist that removes the miss along the worst direction, and the leg strokes it needs
        tw = g*(amp/(g@g)); dL = J0@tw
        say(f"     {tag}: least-norm twist |dP| {1e3*np.linalg.norm(tw[:3]):.0f} mm, |dtheta| {1e3*np.linalg.norm(tw[3:]):.1f} mrad"
            f"  ->  leg strokes {np.array2string(1e3*dL, precision=1)} mm, max |dL| {1e3*np.abs(dL).max():.0f} mm")
    say()
    k_leg = E_ST*A_LEG/L.mean(); k_ax = 6*k_leg/3.0                     # six struts, roughly a third of each carries an axial push
    f_n = np.sqrt(k_ax/(M_HEAD + 0.5*M_REC))/(2*np.pi)
    say(f"3. IT IS FAST ENOUGH. Each strut is steel CHS 85 x 5.3 (A {1e4*A_LEG:.1f} cm2), EA/L = {k_leg/1e6:.0f} MN/m at {L.mean():.2f} m;")
    say(f"   six of them under {M_HEAD + 0.5*M_REC:.0f} kg of head and platform put the crown's first axial mode near {f_n:.0f} Hz,")
    say("   two orders above the gust band (von Karman at 12 m/s, L 50 m: the energy is under 1 Hz). The flexure balls set the")
    say("   real limit, and fact_ball_cad.py sized them at 385 MN/m = 2.1 x EA/L, so they are not the soft link either.")
    say()
    say("VERDICT: keep the hexapod, but stop calling it a positioner. It is the FINE stage, and it is a small one: 33 mm of strut")
    say("stroke covers the worst miss the 12 m/s run produced and 13 mm covers the mean, so +-50 mm of stroke carries the whole")
    say("wind case with 50 % margin - and it answers in milliseconds, where a 5 m boom under 210 kg cannot. The pedicel owns the")
    say("year, the crown owns the gust. It is also why the struts wanted flexure balls rather than bearings: a stage that lives")
    say("at +-33 mm and +-44 mrad never leaves flexure territory - no backlash, no stiction, nothing to lubricate on a roof.")
    open(os.path.join(OUT, "hexapod_role.txt"), "w").write("\n".join(lines) + "\n")

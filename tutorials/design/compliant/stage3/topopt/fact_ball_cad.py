#!/usr/bin/env python
"""The flexure ball as a solid you can print or cut: the FACT joint of sheet 60 (Handbook ch. 6, Hopkins, Fig. 6.8d) built in CadQuery,
sized against the constraints only the solid reveals, and exported as STL, STEP and a mesh for the register's viewer.

The joint. Three legs on a cone of half-angle alpha meet at the kinematic centre C; each leg carries two flexure blades in series whose
normals are orthogonal (the wire-to-stacked-blade equivalence of Fig. 6.7a), so each leg constrains exactly one line through C and the
three together leave three rotations about C and nothing else. The strut screws into the hub at C; the legs run out and down to a flange
that bolts to the receptacle (or platform) ring.

What building it changed. The section drawing's sizing searched t, w and L freely and chose a 120 mm wide blade 36 mm from C. Two things
forbid that, and neither is visible in a section:
  * three legs at 36 mm from C on a 35 deg cone share an arc of 43 mm, so a blade whose width runs circumferentially can be 37 mm at most;
  * the flange has to clear the strut's own 85 mm tube, so the legs' outer ends must stand at a radius over 60 mm, which sets the station.
Only ONE blade of each pair has its width circumferential; the other's width lies in the meridional plane and is free. So the sizing here
is per blade, with the station pushed out until the flange clears the tube, and the widths taken as large as the arc and the envelope allow
(wider is stiffer and costs no stress). The stress rule is the section drawing's: a blade whose end rides the body's rotation theta about C
also has that end displaced by theta x s, so its worst curvature is (1 + 6 s_mid/L) theta/L, not theta/L.

Printing. --material pla thickens the blades by (sigma_allow/E)_pla / (sigma_allow/E)_ti = 1.8 so the printed part reaches the same
rotation at the same fraction of its own yield, and adds hard stops that touch at 1.5 x that rotation so a demonstrator cannot be snapped.
--range-deg overrides the rotation the blades are sized for (a demonstrator wants degrees, the machine wants 0.86).

    python fact_ball_cad.py                          # the Ti part: STL, STEP, mesh, print card
    python fact_ball_cad.py --material pla --range-deg 4 --scale 0.6    # a desk model that visibly pivots about C
"""
import os, sys, json, argparse, numpy as np, cadquery as cq
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
sys.path.insert(0, os.path.join(HERE, "..", "..", "3d")); sys.path.insert(0, os.path.join(HERE, "..", "hashemi_pneumatic"))
from mesh_export import Scene
from model_hp import frame_matrix
V = cq.Vector
# ------------------------------------------------------------------ what the joint must do (fact_ball.py, the runs and the audit)
MAT = dict(ti=dict(name="Ti-6Al-4V", E=110e9, sig_y=880e6, rho=4430.0, use=0.5),
           st=dict(name="17-7PH CH900", E=204e9, sig_y=1500e6, rho=7800.0, use=0.5),
           pla=dict(name="PLA (printed)", E=3.5e9, sig_y=50e6, rho=1240.0, use=0.5))
R_STRUT, T_STRUT = 0.0425, 0.0053          # the strut: steel CHS 85 x 5.3
L_LEG, KIN = 1.446, 1.44                   # the strut's length; ball rotation per unit leg-length change (hexapod inverse kinematics)
CLIP = 0.015                               # the loop's clip on a leg's length correction [m] (fact_ball.py's choice)
P_RUN, P_SURV = 5.0e3, 14.0e3              # per strut: the runs' logged maximum, the 40 m/s survival gust
EA_L = 200e9*1.33e-3/L_LEG                 # the strut's own axial stiffness
NU = 0.34
K_TARGET = 2.0                             # the machine part must be at least this many times the strut's own EA/L: beyond that, stiffness is worthless and only costs metal
PRINT_SCALE = 1.0                          # main sets this: the printability rules apply to the part as it comes off the bed, not as designed
def k_target(mat):
    """a printed demonstrator carries nothing: it is sized for the rotation it must show, and its stiffness is reported, not demanded"""
    return K_TARGET*EA_L if mat != "pla" else 0.0
def size_joint(mat, theta, alpha, gap_tan=0.006, gap_ax=0.004, r_clear=0.020, w_cap=0.090, w_cap_A=0.140, r_neck=0.014, verbose=True):
    """alpha fixed. size_cone() below searches it: the strut's own diameter pushes the blades out along the leg, the stress
    amplification (1 + 6 s/L) grows with that station, and a wider cone reaches the same radius at a smaller station - at the
    price of cos^2(alpha) on the joint's axial stiffness. The angle is a result, not a given."""
    """the stiffest pair of blades per leg that fits the tripod's own geometry and holds the loads.
    Blade B (inner) has its width circumferential and is capped by the arc three legs share; blade A (outer) has its width in the
    meridional plane and is capped by the envelope. The flange must clear the strut tube: the outer blade's outer edge stands at a
    radius of at least R_STRUT + r_clear."""
    M = MAT[mat]; E, sig_all = M["E"], M["use"]*M["sig_y"]; Ep = E/(1 - NU**2)     # wide blades bend in cylindrical bending: plate modulus
    P_leg_s = P_SURV/(3*np.cos(alpha)) if k_target(mat) else 50.0                 # a demonstrator carries a hand, not the 40 m/s gust
    best = None
    arc = lambda s: 2*np.pi*s*np.sin(alpha)/3 - gap_tan
    for t in np.arange(0.4e-3, 5.01e-3, 0.2e-3):
        for L in np.arange(0.020, 0.161, 0.005):
            for s_out in np.arange(0.050, 0.321, 0.005):                            # the OUTER blade's mid-station along the leg
                s_in = s_out - L - gap_ax                                           # the inner blade, one blade length and a gap closer to C
                if s_in < 0.5*L + 0.010: continue
                if (s_out + 0.5*L)*np.sin(alpha) < R_STRUT + r_clear: continue       # the flange must clear the strut tube
                if (s_in - 0.5*L)*np.sin(alpha) < r_neck + 0.004: continue            # the inner blade clears the hub's neck (the strut is ABOVE C, the legs below: the hub necks down to r_neck at C)
                w_B = min(arc(s_in), w_cap); w_A = min(w_cap_A, 2.2*arc(s_out))      # circumferential (the arc three legs share) and meridional (only the envelope)
                if w_B < 8*t or w_A < 8*t: continue                                 # a blade, not a bar
                if mat == "pla" and t*PRINT_SCALE < 1.2e-3: continue                 # a printed blade under three perimeters at a 0.4 mm nozzle is not a blade
                sig = max((1 + 6*s_in/L), (1 + 6*s_out/L))*Ep*t*theta/(2*L)          # the outer blade governs; plate modulus for a wide blade
                if sig > sig_all: continue
                Pcr = min(4*np.pi**2*E*w*t**3/12/L**2 for w in (w_A, w_B))           # fixed-fixed Euler about each blade's thin axis
                if Pcr < 3*P_leg_s: continue
                k_ax = 1.0/(L/(E*w_A*t) + L/(E*w_B*t))                               # the two blades in series along the leg
                k_j = 3*np.cos(alpha)**2*k_ax                                        # three legs, each at alpha to the strut axis
                if k_j < k_target(mat): continue                                     # stiff enough is the requirement; the objective is then the SMALLEST joint that is
                reach = s_out + 0.5*L
                if best is None or reach < best["reach"]:
                    best = dict(k_j=k_j, reach=reach, t=t, L=L, s_in=s_in, s_out=s_out, w_A=w_A, w_B=w_B, sig=sig, Pcr=Pcr, k_ax=k_ax,
                                r_out=(s_out + 0.5*L)*np.sin(alpha), h=(s_out + 0.5*L)*np.cos(alpha), P_leg_s=P_leg_s)
    if best is None: raise SystemExit(f"no blade pair at alpha {np.degrees(alpha):.0f} deg reaches {K_TARGET:.1f} x EA/L within the stress and buckling limits at {np.degrees(theta):.2f} deg")
    b = best
    if verbose:
        print(f"  material {M['name']}: E {E/1e9:.0f} GPa, allowable {sig_all/1e6:.0f} MPa (half yield)")
        print(f"  rotation sized for {np.degrees(theta):.2f} deg at each ball; {'survival' if k_target(mat) else 'a hand load of'} {b['P_leg_s']:.0f} N per leg")
        print(f"  blades t {1e3*b['t']:.1f} mm, free length {1e3*b['L']:.0f} mm; inner at {1e3*b['s_in']:.0f} mm from C (its inner edge clears the hub's {1e3*r_neck:.0f} mm neck), width {1e3*b['w_B']:.0f} mm (circumferential, the arc three legs share is {1e3*arc(b['s_in']):.0f} mm)")
        print(f"  outer at {1e3*b['s_out']:.0f} mm from C, width {1e3*b['w_A']:.0f} mm (meridional, free of the neighbours)")
        print(f"  worst bending {b['sig']/1e6:.0f} MPa (amplification {1 + 6*b['s_out']/b['L']:.0f} x pure bending); Euler {b['Pcr']/1e3:.1f} kN, SF {b['Pcr']/b['P_leg_s']:.1f} at survival")
        print(f"  joint {b['k_j']/1e6:.1f} MN/m axially = {b['k_j']/EA_L:.2f} x the strut's EA/L" + (f" (asked for {K_TARGET:.1f})" if k_target(mat) else " (a demonstrator: reported, not demanded)") + f"; the leg reaches {1e3*b['reach']:.0f} mm from C, the smallest that meets it")
    return b
def size_cone(mat, theta, angles=range(25, 66, 5), **kw):
    """the cone angle and blade pair that give the stiffest joint the strut's own diameter allows"""
    best = None
    for A_ in angles:                                                                # the cone angle trades the stress amplification (small alpha reaches the same radius further out) against cos^2(alpha) on the stiffness
        try: b = size_joint(mat, theta, np.radians(A_), verbose=False, **kw)
        except SystemExit: continue
        b["alpha"] = np.radians(A_)
        if best is None or b["reach"] < best["reach"]: best = b
    if best is None: raise SystemExit("no cone angle admits a blade pair at this rotation and stiffness: lower K_TARGET, or raise --range-deg")
    return best
# ------------------------------------------------------------------ the solid
def build(b, alpha, mat, scale=1.0, stops=True, T_link=None, T_flange=0.007, bolt=0.0055, L_end=0.030):
    """one flexure ball, ONE monolithic printable body: a flange ring (bolted to the receptacle ring, its top face at z = 0) -> three legs,
    each a rigid link from the hub, a blade, a link that turns the section through 90 deg, the second blade and a link that lands as a flat
    pad on the ring -> a hub at the kinematic centre C carrying the strut's spigot. Three stops (a pin standing on a spoke of the ring,
    through a clearance hole in a finger hanging off the hub) touch at 1.5 x the design rotation so the joint cannot be over-flexed.

    The legs run out and DOWN from C, so the part stands on its flange to print: every blade, leg, finger and pin is within 35 deg of the
    vertical and nothing needs support. Everything is fused; the caller asserts the result is a single solid."""
    S = 1000.0*scale
    t, L, TF = b["t"]*S, b["L"]*S, T_flange*S
    TL = (T_link*S) if T_link else 2.5*t                                              # the rigid links: 2.5 x the blade thick, 0.6 x its width -> 9 x its bending stiffness at no more metal
    sB, sA = b["s_in"]*S, b["s_out"]*S; s_end = sA + 0.5*L + L_end*S
    h = s_end*np.cos(alpha); r_land = s_end*np.sin(alpha); C = np.array([0.0, 0.0, h])
    wA, wB = b["w_A"]*S, b["w_B"]*S; w_pad = min(0.75*wB, 0.9*2*np.pi*r_land/3)
    r_spig = R_STRUT*S - T_STRUT*S*0.5; r_neck = 14.0*scale; r_hub = r_spig + 3.0*scale   # the hub necks to r_neck AT C and opens above it to carry the tube: below C the legs have the space
    r_fi, r_fo = r_land - 14*scale, r_land + 18*scale; r_bolt = r_land + 10*scale
    def box(dx, dy, dz, origin, xl, yl, zl):
        return cq.Workplane("XY").box(dx, dy, dz).val().transformShape(frame_matrix(origin, xl, yl, zl))
    def rect_wire(p, aa, bb, w, tt):
        cs = [p + 0.5*w*sx*np.asarray(aa) + 0.5*tt*sy*np.asarray(bb) for sx, sy in ((-1, -1), (1, -1), (1, 1), (-1, 1))]
        return cq.Wire.makePolygon([V(*c) for c in cs] + [V(*cs[0])], close=True)
    def link(p0, a0, b0, w0, t0, p1, a1, b1, w1, t1):
        return cq.Solid.makeLoft([rect_wire(p0, a0, b0, w0, t0), rect_wire(p1, a1, b1, w1, t1)], True)
    body = cq.Workplane("XY").circle(r_fo).circle(r_fi).extrude(-TF).val()                                   # the ground ring
    body = body.fuse(cq.Solid.makeCone(r_neck, r_hub, 0.30*h, V(*C), V(0, 0, 1)))                            # the hub: a cone from the neck at C, opening upward
    body = body.fuse(cq.Solid.makeCylinder(r_spig, 0.34*h, V(*(C + np.array([0, 0, 0.28*h]))), V(0, 0, 1)))  # the strut's spigot on top of it
    up = np.array([0.0, 0.0, 1.0])
    for k in range(3):
        ph = 2*np.pi*k/3
        d = np.array([np.sin(alpha)*np.cos(ph), np.sin(alpha)*np.sin(ph), -np.cos(alpha)])                    # out and down
        tg = np.array([-np.sin(ph), np.cos(ph), 0.0]); bm = np.cross(d, tg)                                   # circumferential; meridional
        body = body.fuse(box(L, wB, t, C + sB*d, d, tg, bm))                                                  # blade B: thin meridionally, wide circumferentially
        body = body.fuse(box(L, wA, t, C + sA*d, d, bm, -tg))                                                 # blade A: thin circumferentially, wide meridionally
        body = body.fuse(link(C, tg, bm, min(0.6*wB, 2.2*r_neck), TL, C + (sB - 0.5*L)*d, tg, bm, 0.6*wB, TL))  # hub (from C, so it certainly meets the neck) -> B
        body = body.fuse(link(C + (sB + 0.5*L)*d, tg, bm, 0.6*wB, TL, C + (sA - 0.5*L)*d, bm, -tg, 0.6*wA, TL))  # B -> A, the section turns 90 deg
        pad = np.array([r_land*np.cos(ph), r_land*np.sin(ph), -0.5*TF])
        body = body.fuse(link(C + (sA + 0.5*L)*d, bm, -tg, 0.6*wA, TL, pad, tg, up, w_pad, TF))                # A -> a flat pad in the ring
    stop_clr = 0.0
    if stops:
        Lf = 0.42*h; beta = np.radians(25.0); stop_clr = 1.5*np.tan(b["theta"])*Lf                             # the finger's hole, Lf from C, moves this far at 1.5 x the rotation
        r_pin = max(4.0*scale, 1.6*stop_clr); r_hole = r_pin + stop_clr; r_blk = r_hole + 4.0*scale
        for k in range(3):
            ph = 2*np.pi*k/3 + np.pi/3
            df = np.array([np.sin(beta)*np.cos(ph), np.sin(beta)*np.sin(ph), -np.cos(beta)])
            B_ = C + Lf*df; rB = np.hypot(B_[0], B_[1])
            body = body.fuse(link(C, np.array([-np.sin(ph), np.cos(ph), 0.0]), np.cross(df, np.array([-np.sin(ph), np.cos(ph), 0.0])), 2.2*r_blk, TL,
                                  B_, np.array([-np.sin(ph), np.cos(ph), 0.0]), np.cross(df, np.array([-np.sin(ph), np.cos(ph), 0.0])), 2.2*r_blk, TL))   # the finger, off the hub
            body = body.fuse(cq.Solid.makeCylinder(r_blk, 2.4*TL, V(B_[0], B_[1], B_[2] - 1.2*TL), V(0, 0, 1)))                                            # its block
            body = body.fuse(link(np.array([r_fi*np.cos(ph), r_fi*np.sin(ph), -0.5*TF]), np.array([-np.sin(ph), np.cos(ph), 0.0]), up, 2.2*r_blk, TF,
                                  np.array([rB*np.cos(ph), rB*np.sin(ph), -0.5*TF]), np.array([-np.sin(ph), np.cos(ph), 0.0]), up, 2.2*r_blk, TF))         # a spoke of the ring
            body = body.fuse(cq.Solid.makeCylinder(r_pin, B_[2] + 1.6*TL, V(rB*np.cos(ph), rB*np.sin(ph), -TF), V(0, 0, 1)))                               # the pin, standing on it
            body = body.cut(cq.Solid.makeCylinder(r_hole, 4.0*TL, V(B_[0], B_[1], B_[2] - 2.0*TL), V(0, 0, 1)))                                            # the clearance hole through the block
    holes = None
    for k in range(6):
        ph = 2*np.pi*k/6 + np.pi/6
        c = cq.Solid.makeCylinder(bolt*S/2, 3*TF, V(r_bolt*np.cos(ph), r_bolt*np.sin(ph), -2*TF), V(0, 0, 1))
        holes = c if holes is None else holes.fuse(c)
    body = body.cut(holes)
    body = body.cut(cq.Solid.makeCylinder(r_spig - T_STRUT*S, 1.1*h, V(*(C + np.array([0, 0, 0.34*h]))), V(0, 0, 1)))           # the spigot's bore, stopping well above C so the hub stays solid
    body = body.cut(cq.Solid.makeCylinder(r_neck + 4.0*scale, 1.4*scale, V(0, 0, h + 1.2*scale), V(0, 0, 1))
                    .cut(cq.Solid.makeCylinder(r_neck - 1.0*scale, 2.0*scale, V(0, 0, h + 0.9*scale), V(0, 0, 1))))             # a witness groove round the neck just above the C plane: the point it all turns about
    return body, dict(r_flange=r_fo, h=h, r_hub=r_hub, T_flange=TF, r_land=r_land, w_pad=w_pad, stop_clr=stop_clr, r_bolt=r_bolt)
# ------------------------------------------------------------------ the alternative the solid reveals: a necked waist
def size_neck(mat, theta, r_fix=None, verbose=True):
    """A waist turned down at C: it resists the three translations and yields the three rotations, which is the ball joint's
    freedom space exactly. Two equations settle it. Bending a waist of radius r and length h through theta puts
    sigma = E r theta / h on its surface, and its axial stiffness is k = E pi r^2 / h; eliminating h,
        k = pi r sigma_all / theta,    so    r = k theta / (pi sigma_all)   and   h = E r theta / sigma_all.
    Nothing about it is free: the duty (theta, k) fixes the waist."""
    M = MAT[mat]; E, sig_all = M["E"], M["use"]*M["sig_y"]
    if r_fix or not k_target(mat):
        r = r_fix or 0.003; k = np.pi*r*sig_all/theta                              # a demonstrator: the waist is chosen for the print and the stiffness follows
    else:
        k = k_target(mat); r = k*theta/(np.pi*sig_all)                             # the machine part: the duty fixes the waist
    h = E*r*theta/sig_all
    A = np.pi*r*r; sig_c = P_SURV/A; k_th = E*(np.pi*r**4/4)/h; k_sh = 12*E*(np.pi*r**4/4)/h**3
    if verbose:
        print(f"  material {M['name']}: waist r {1e3*r:.1f} mm over {1e3*h:.1f} mm, {np.degrees(theta):.2f} deg at {sig_all/1e6:.0f} MPa" + (f", axial {k/1e6:.0f} MN/m = {k/EA_L:.2f} x the strut's EA/L" if k_target(mat) else f" (its axial stiffness follows: {k/1e6:.2f} MN/m)"))
        print(f"  it costs a restoring moment of {k_th*theta:.1f} N m per joint ({k_th*theta/L_LEG:.0f} N at the strut, against loads of kN) and a shear stiffness of {k_sh/1e6:.0f} MN/m")
        print(f"  at the 40 m/s gust the waist carries {sig_c/1e6:.0f} MPa of compression; with the bending that is {(sig_c + sig_all)/1e6:.0f} MPa against a yield of {M['sig_y']/1e6:.0f}")
    return dict(r=r, h=h, k_j=k, sig=sig_all, sig_c=sig_c, k_th=k_th, k_sh=k_sh, theta=theta)
def build_neck(b, mat, scale=1.0, T_flange=0.008, bolt=0.0055):
    """the waist as a solid of revolution: a flange disc, a fillet into the waist, the waist, a fillet out to the hub and the
    strut's spigot. It prints standing on its flange with nothing steeper than the 45 deg cones."""
    S = 1000.0*scale; r, h = b["r"]*S, b["h"]*S
    r_spig = R_STRUT*S - T_STRUT*S*0.5; R_f = R_STRUT*S + 12.0*scale; TF = T_flange*S; fil = max(2.5*r, 8*scale)
    z0, z1 = 0.0, fil                                                   # the flange's top, then the fillet into the waist
    z2, z3, z4 = z1 + h, z1 + h + fil, z1 + h + fil + 34*scale          # the waist, the fillet out, the spigot
    c = 1.5*r                                                                     # a 45 deg chamfer at each end of the waist (the machine part wants a radius >= 2r there; a chamfer is what a polyline can promise)
    z1 = 0.55*(R_f - r - c)                                                       # the taper down from the flange, narrowing upward: self-supporting at any angle
    z2, z3 = z1 + c, z1 + c + h                                                   # the waist, exactly the length the sizing asked for
    z4, z5 = z3 + c, z3 + c + (r_spig - r - c)                                    # the chamfer out and the 45 deg flare to the spigot
    z6 = z5 + 34*scale
    prof = (cq.Workplane("XZ").moveTo(0, -TF).lineTo(R_f, -TF).lineTo(R_f, 0)
            .lineTo(r + c, z1).lineTo(r, z2)                                      # taper, chamfer
            .lineTo(r, z3)                                                        # THE WAIST: everything turns about its middle
            .lineTo(r + c, z4).lineTo(r_spig, z5).lineTo(r_spig, z6)              # chamfer, flare, spigot
            .lineTo(0, z6).close().revolve(360, (0, 0, 0), (0, 1, 0)))
    body = prof.val()
    body = body.cut(cq.Solid.makeCylinder(r_spig - T_STRUT*S, 44*scale, V(0, 0, z6 - 36*scale), V(0, 0, 1)))          # the strut's bore
    holes = None
    for k in range(6):
        ph = 2*np.pi*k/6; rb = R_f - 6.0*scale
        c = cq.Solid.makeCylinder(bolt*S/2, 3*TF, V(rb*np.cos(ph), rb*np.sin(ph), -2*TF), V(0, 0, 1))
        holes = c if holes is None else holes.fuse(c)
    body = body.cut(holes)
    zc = 0.5*(z2 + z3)                                                                                                # C is the middle of the waist
    body = body.cut(cq.Solid.makeCylinder(r + 1.2*scale, 1.0*scale, V(0, 0, zc - 0.5*scale), V(0, 0, 1))
                    .cut(cq.Solid.makeCylinder(r - 0.6*scale, 1.6*scale, V(0, 0, zc - 0.8*scale), V(0, 0, 1))))        # a witness groove at C
    return body, dict(r_flange=R_f, h=z6, r_waist=r, h_waist=h, T_flange=TF, z_C=zc)
# ------------------------------------------------------------------
if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--material", default="ti", choices=list(MAT)); ap.add_argument("--alpha", type=float, default=0.0, help="cone half-angle [deg]; 0 searches it")
    ap.add_argument("--range-deg", type=float, default=None, help="rotation the blades are sized for (default: the loop's clip)")
    ap.add_argument("--scale", type=float, default=1.0); ap.add_argument("--tag", default=None); ap.add_argument("--no-stops", action="store_true")
    ap.add_argument("--waist-mm", type=float, default=None, help="neck only: fix the waist diameter [mm] instead of deriving it from the duty")
    ap.add_argument("--kind", default="tripod", choices=("tripod", "neck"), help="tripod: the chapter's construction (Fig. 6.8d); neck: the waist the solid model argues for")
    A = ap.parse_args()
    theta = np.radians(A.range_deg) if A.range_deg else KIN*CLIP/L_LEG
    globals()["PRINT_SCALE"] = A.scale
    tag = A.tag or (f"fact_ball_{A.kind}_{A.material}" + (f"_{A.range_deg:g}deg" if A.range_deg else "") + (f"_x{A.scale:g}" if A.scale != 1 else ""))
    print(f"[flexure ball] {tag}: alpha {A.alpha:.0f} deg, rotation +-{np.degrees(theta):.2f} deg, scale {A.scale:g}")
    if A.kind == "neck":
        b = size_neck(A.material, theta, r_fix=(A.waist_mm/2000.0 if A.waist_mm else None)); alpha = 0.0
        body, env = build_neck(b, A.material, scale=A.scale)
    else:
        b = size_cone(A.material, theta) if A.alpha <= 0 else size_joint(A.material, theta, np.radians(A.alpha))
        alpha = b.get("alpha", np.radians(A.alpha)); b["theta"] = theta
        print(f"  cone half-angle {np.degrees(alpha):.0f} deg" + (" (searched: the smallest joint the strut's diameter allows)" if A.alpha <= 0 else " (given)"))
        size_joint(A.material, theta, alpha, verbose=True)
        body, env = build(b, alpha, A.material, scale=A.scale, stops=not A.no_stops)
    bb = body.BoundingBox(); env["d_true"] = max(bb.xmax - bb.xmin, bb.ymax - bb.ymin); env["h_true"] = bb.zmax - bb.zmin
    n_sol = len(body.Solids())
    if n_sol != 1: print(f"  WARNING: {n_sol} separate solids - the print would come off the bed in pieces")
    vol = body.Volume()/1e9; m = vol*MAT[A.material]["rho"]
    print(f"  solid: {vol*1e6:.0f} cm3, {m:.2f} kg in {MAT[A.material]['name']}; bounding box d {env['d_true']:.0f} x h {env['h_true']:.0f} mm; one piece {n_sol == 1}, watertight {body.isValid()}")
    stl = os.path.join(OUT, tag + ".stl"); cq.exporters.export(cq.Workplane(obj=body), stl, tolerance=0.05, angularTolerance=0.2)
    stp = os.path.join(OUT, tag + ".step"); cq.exporters.export(cq.Workplane(obj=body), stp)
    Scene().add(body, f"flexure ball ({A.kind}), {MAT[A.material]['name']}", "#d9480f", tol=0.3).write(os.path.join(OUT, tag + ".json"))
    nozzle = 0.4; per = int(np.floor((b["t"] if A.kind == "tripod" else 2*b["r"])*1000*A.scale/nozzle))
    card = [f"THE FLEXURE BALL, {MAT[A.material]['name']}, {'demonstrator' if A.range_deg else 'the machine part'} at {A.scale:g} scale",
            f"  envelope: {env['d_true']:.0f} mm across, {env['h_true']:.0f} mm tall, {vol*1e6:.0f} cm3, {m:.2f} kg",
            (f"  the waist is {2e3*A.scale*b['r']:.1f} mm across and {1e3*A.scale*b['h']:.1f} mm long; C is its middle, marked by the groove" if A.kind == "neck" else
             f"  the legs land on a ring of radius {env['r_land']:.0f} mm in pads {env['w_pad']:.0f} mm wide; six M{int(1000*0.0055*A.scale)} holes outside them" + (f"; three stop posts with {env['stop_clr']:.2f} mm of clearance" if not A.no_stops else "")),
            (f"  blades: 6 of them, {1e3*A.scale*b['t']:.2f} x {1e3*A.scale*b['w_B']:.0f} and {1e3*A.scale*b['w_A']:.0f} mm wide, {1e3*A.scale*b['L']:.0f} mm free length" if A.kind == "tripod" else
             f"  one turned waist, no assembly, no blades: a solid of revolution"),
            f"  rotation: +-{np.degrees(theta):.2f} deg about C at {b['sig']/1e6:.0f} MPa" + (f"; stops touch at {1.5*np.degrees(theta):.2f} deg" if (A.kind == "tripod" and not A.no_stops) else ""),
            (f"  print: flange down on the bed; nothing overhangs but the two 45 deg cones" if A.kind == "neck" else f"  print: flange down on the bed (every blade stands at {np.degrees(alpha):.0f} deg to the vertical: no support anywhere)"),
            f"  layer 0.12 mm; the {'blade' if A.kind == 'tripod' else 'waist'} is {per} perimeters across at a 0.4 mm nozzle, so it prints solid" + ("" if per >= 3 else "  (TOO THIN: raise --scale or print in resin)") + "; 40 % infill elsewhere",
            f"  the {'blades are' if A.kind == 'tripod' else 'waist is'} what bends, and on FDM the layer bond is the failure mode: printed flange down as above the layers run across the bending stress, which is the strong direction; resin (SLA) is isotropic and better still",
            f"  the strut spigot is {2*(R_STRUT*1000*A.scale - T_STRUT*1000*A.scale*0.5):.0f} mm across (an 85 x 5.3 tube at 1:1); six M{max(int(1000*0.0055*A.scale), 2)} clearance holes on the flange",
            f"  what it demonstrates: push the strut sideways and it pivots about C with no bearing, no backlash and one unpowered state; let go and it returns"]
    open(os.path.join(OUT, tag + "_print.txt"), "w").write("\n".join(card) + "\n")
    json.dump(dict(kind=A.kind, material=A.material, alpha_deg=float(np.degrees(alpha)), theta_deg=float(np.degrees(theta)), scale=A.scale, volume_cm3=vol*1e6, mass_kg=m,
                   envelope_mm=dict(d=env["d_true"], h=env["h_true"]), part={k: float(v) for k, v in b.items() if isinstance(v, (int, float))}),
              open(os.path.join(OUT, tag + "_cad.json"), "w"), indent=1)
    print("\n".join(card))

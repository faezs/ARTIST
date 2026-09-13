#!/usr/bin/env python
"""Fourth pass: everything behind the dish. A Cassegrain on the pumped membrane: secondary on a conical style that
stands inside the secondary's own shadow, the return beam through a small hole to an image behind the vertex, one
powered fold M3 on the neck (the elevation axis, which meets the azimuth axis there) turning at el/2 to send the
beam down the stalk to the fixed bore and the other fork's underground relay. Numbers and the shading budget."""
import numpy as np, json, os
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")
A, F1 = 2.1, 4.0                       # primary: a 2.1 m, effective focal length 4.0 m (the zoned membrane, 0.5 mrad slope)
D_SEC, B = 3.35, 1.0                   # secondary 3.35 m from the vertex (0.65 m inside F), image 1.0 m behind the vertex
SUN = 4.65e-3; SLOPE = 0.5e-3
s1, s2 = F1 - D_SEC, D_SEC + B; m = s2/s1; f_eff = F1*m
r_sec = A*s1/F1; e = (s2 + s1)/(s2 - s1); a_h = (s2 - s1)/2; c_h = (s2 + s1)/2
r_return_vertex = r_sec*B/s2; r_hole = r_return_vertex + 0.04
r_img = f_eff*SUN + 2*SLOPE*f_eff*0.5                 # sun's image plus the slope error's smear at the effective focal length
half_cone = np.arctan(r_sec/s2)
NECK = 1.8                                             # neck (elevation axis and M3) behind the vertex
OFF = 1.4                                              # the stalk (azimuth axis) 1.4 m beside the dish axis, along the neck axis: M3 -> M4 run
L3 = NECK - B; r_beam_m3 = r_img + L3*np.tan(half_cone)
r_m3 = r_beam_m3/np.cos(np.radians(45))*1.15           # the fold at 45 deg, 15 % margin
F3 = L3                                                # M3 is an ellipsoid relaying the image 1:1: the second image L3 along the neck axis
r_beam_m4 = r_img + (OFF - F3)*np.tan(np.arctan(r_beam_m3/L3)); r_m4 = r_beam_m4/np.cos(np.radians(45))*1.15
etendue = np.pi*A**2*np.pi*SUN**2
conduit = 0.30; L_allowed = conduit/np.sqrt(etendue/(np.pi*r_img**2)/np.pi)
lines = []
P = lines.append
P("CASSEGRAIN ON THE MEMBRANE, EVERYTHING BEHIND THE DISH")
P(f"  primary a {A} m, f1 {F1} m; secondary hyperboloid {D_SEC} m from the vertex: s1 {s1:.2f}, s2 {s2:.2f}, magnification {m:.1f}, f_eff {f_eff:.1f} m, eccentricity {e:.2f} (a {a_h:.2f}, c {c_h:.2f} m)")
P(f"  secondary radius {r_sec:.2f} m -> its own obscuration {np.pi*r_sec**2/(np.pi*A**2)*100:.1f} % of the aperture (any Cassegrain pays this)")
P(f"  return beam radius at the vertex plane {r_return_vertex:.3f} m -> hole r {r_hole:.2f} m, {np.pi*r_hole**2/(np.pi*A**2)*100:.2f} % of the aperture (was r 0.50, {0.5**2/A**2*100:.1f} %, plus a 0.7 m slot when open)")
P(f"  the style: a cone from the hole rim (r {r_hole:.2f}) to the secondary rim (r {r_sec:.2f}); its projection along the sun line lies inside the secondary's disc, so it shades nothing more;")
P(f"    its inner surface stays outside the return cone (radius {r_return_vertex:.3f} -> {r_sec:.2f} over the same span), so it obstructs nothing; it carries the secondary and shields the beam")
P(f"  image behind the vertex: radius {r_img:.3f} m (sun {f_eff*SUN:.3f} + slope {SLOPE*f_eff:.3f}); cone half-angle {np.degrees(half_cone):.1f} deg")
P(f"  neck {NECK} m behind the vertex: M3 on the head, {L3:.1f} m past the image, beam radius there {r_beam_m3:.2f} m, mirror r {r_m3:.2f} m, turns the beam 90 deg along the neck axis and relays the image 1:1 to {F3:.1f} m along it")
P(f"  the beam runs along the neck axis through the hollow trunnion pivot to M4 at the stalk, {OFF} m from the dish axis: beam radius there {r_beam_m4:.2f} m, mirror r {r_m4:.2f} m; M4 turns it 90 deg down the stalk and relays the image to F3 at the cass machine's F2 (env z 6.14), the bore below unchanged")
P(f"  both folds are at 45 deg for every elevation: M3 sits on the head between the dish axis and the neck axis, which are always perpendicular; M4 sits on the stalk between the neck axis and the vertical. No el/2 drive, no strip ring to slave")
P(f"  etendue {etendue*1e4:.1f} cm2 sr: through a conduit of r {conduit} m a 1:1 relay may throw {L_allowed:.1f} m per stage; the stalk (r 0.6 inflated, or a 0.6 m rigid tube) carries the converging beam from M3 to F3")
P(f"  reflections above ground: primary, secondary, M3, M4 = 4 (the cass machine: primary, strip = 2); the underground ellipsoid and the pot are the other fork's, unchanged; two more reflections = x0.88 at 0.94")
P("")
P("SHADING BUDGET (fraction of the pi a^2 aperture, tracking, sun along the axis)")
cass = dict(tube_el59=9.8, strip_ring=1.5, hole=0.5**2/A**2*100, slot_open=0.7*(A - 0.5)/(np.pi*A**2)*100, mount=0.0)
new = dict(secondary=np.pi*r_sec**2/(np.pi*A**2)*100, hole=np.pi*r_hole**2/(np.pi*A**2)*100, style=0.0, mount=0.0, M3_fold=0.0)
P(f"  cass machine above the deck (from shading.py at el 59): tube {cass['tube_el59']:.1f} %, strip ring {cass['strip_ring']:.1f} %, hole {cass['hole']:.1f} %, slot when open (el > 54) {cass['slot_open']:.1f} %: {sum(cass.values()):.1f} % with the slot, {sum(cass.values()) - cass['slot_open']:.1f} % without; the strip's own area is the secondary's and is not counted")
P(f"  fourth pass: secondary {new['secondary']:.1f} %, hole {new['hole']:.2f} %, style 0 (inside the secondary's disc), mount 0 (behind the membrane), M3 0 (behind): {sum(new.values()):.1f} %")
g1 = (100 - sum(new.values()))/(100 - sum(cass.values())); g2 = (100 - sum(new.values()))/(100 - sum(cass.values()) + cass['slot_open'])
P(f"  gain in light on the primary: {g1:.2f} x with the slot open, {g2:.2f} x without; after the two extra reflections {g1*0.94**2:.2f} x and {g2*0.94**2:.2f} x")
P("")
P("THE MOUNT (FACT, unchanged in kind, moved behind the dish)")
P(f"  neck = elevation axis, horizontal, {NECK} m behind the vertex, meeting the stalk's (azimuth) axis {OFF} m to one side of the dish axis: a side-mounted head on a single stalk, the sunflower's neck.")
P("  trunnion: a two-stage HOLLOW cartwheel pivot on the neck axis between the head and the stalk: radial 17-7PH blades 250 x 1.0 x 120 mm in planes through the axis around a 0.6 m bore, six per stage;")
P("    the constraint space of a rotation is every line meeting its axis and a plane through the axis need not reach it, so the beam passes through the pivot. Range +-25.8 deg per stage, 71 deg in series at 0.17 sigma_y as before.")
P("  head: dish + style + secondary + M3 as one optical unit on the fine stage (3 tangential blades + 3 water columns, 3 DOF Type 1, unchanged) on a short frame from the neck bar; counterweights behind the neck and beyond the stalk, in the dish's shadow.")
P("  azimuth: a slew ring at the stalk top under M4's yoke (or the stalk itself on the deck ring); the beam down the stalk's axis is the azimuth axis, so the fixed bore below sees the same F2 at every hour.")
z_neck = 6.14 + F3 + 0.0
P(f"  stalk: neck at env z {z_neck:.2f} so that F3 is the cass machine's F2 (z 6.14); at el 12 the lowest rim point is {z_neck - ((A + 0.06)*np.cos(np.radians(12)) - NECK*np.sin(np.radians(12))) - 5.0:.2f} m over the deck")
P(f"  roof: the head's sweep, {2*(NECK + A + 0.06):.1f} m across about the neck, plus the stalk {OFF} m to the side: about {2*(NECK + A + 0.06) + OFF:.0f} x {2*(A + 0.06):.0f} m against 9.2 x 7.8 m; and no F to keep, so f/D and size scale freely")
P("  reflections: 4 above ground; the strip, its ring, the slew at the tube top, the flapped slot and the tube are gone")
json.dump(dict(A=A, F1=F1, D_SEC=D_SEC, B=B, m=m, f_eff=f_eff, r_sec=r_sec, e=e, a_h=a_h, c_h=c_h, r_hole=r_hole, r_img=r_img, NECK=NECK, OFF=OFF, L3=L3, r_m3=r_m3, r_m4=r_m4, F3=F3, z_neck=z_neck, shading_new=new, shading_cass=cass), open(os.path.join(OUT, "optics.json"), "w"), indent=1)
open(os.path.join(OUT, "optics.txt"), "w").write("\n".join(lines)); print("\n".join(lines))

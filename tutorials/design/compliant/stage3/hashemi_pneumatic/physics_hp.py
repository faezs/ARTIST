#!/usr/bin/env python
"""Pneumatic mount for the Cassegrain Hashemi machine (nix-support working config, 2026-09-05).

Optics untouched: dish a 2.1 m, sphere R 8.2 m, orbit g 4.0 m about F = (1.25, 0, 9.868) (x north, y east, z up,
wall line x 1.25, roof deck z 5.0), hole r 0.5, slot w 0.7 to the sun side, hyperboloid strip 0.8 m below F,
vertical beam through the deck hole (r 0.9) to M4 at the turn, F on a horizontal arm from a tower 3 m north.

Mount = the structural dual of Hashemi's rod-from-F: an inflated vine rod from a ROOT on the deck pushes the
dish's back ring outward; three deck tendons steer it on the orbit sphere; three short tendons at the rod tip
hold the dish's attitude; nothing new in front of the mirror. Sun over the Quetta year decides the rod's length
and tilt range, the root position, the forces and the buckling; the sweep decides where F's tower may stand.
"""
import numpy as np, os
from scipy.optimize import linprog
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "out"); os.makedirs(OUT, exist_ok=True)
LOG = []
def log(s=""): print(s); LOG.append(s)

LAT = np.radians(30.2)
F = np.array([1.25, 0.0, 9.868]); G_ORBIT = 4.0; A_DISH = 2.1; R_SPH = 8.2; SAG = R_SPH - np.sqrt(R_SPH**2 - A_DISH**2)
Z_DECK = 5.0; X_BEAM = 1.25; R_BEAM_DECK = 0.9; X_TOWER_N = 1.25 + 3.0
R_HOLE, W_SLOT = 0.5, 0.7
EL_MIN = np.radians(12.0)
RHO = 1.03; Q9, Q25 = 0.5*RHO*81, 0.5*RHO*625; CD = 1.3; AREA = np.pi*A_DISH**2
M_HEAD = 45.0                                  # membrane + fabric plenum + rim toroid + back ring + slot flaps
ET = 500e3                                     # fabric E t (N/m) of the rod hose
EA_CABLE = 0.25e6                              # 4 mm steel

def sun(doy, hour):
    dec = np.radians(23.44)*np.sin(2*np.pi*(284 + doy)/365.0)
    H = np.radians(15.0*(hour - 12.0))
    sel = np.sin(LAT)*np.sin(dec) + np.cos(LAT)*np.cos(dec)*np.cos(H)
    el = np.arcsin(np.clip(sel, -1, 1))
    cosA = (np.sin(dec) - sel*np.sin(LAT))/max(np.cos(el)*np.cos(LAT), 1e-9)
    A = np.arccos(np.clip(cosA, -1, 1))
    if H > 0: A = 2*np.pi - A
    return el, A, np.array([np.cos(el)*np.cos(A), np.cos(el)*np.sin(A), np.sin(el)])

def positions():
    out = []
    for name, doy in (("summer", 172), ("equinox", 80), ("winter", 355)):
        for hour in np.arange(6.0, 18.01, 0.5):
            el, A, s = sun(doy, hour)
            if el < EL_MIN: continue
            V = F - G_ORBIT*s
            out.append(dict(season=name, hour=hour, el=el, A=A, s=s, V=V))
    return out

ROOT_X, WINCH_R, R_RING = 2.5, 7.0, 0.8            # chosen by the scans in main()
ROOT = np.array([ROOT_X, 0.0, Z_DECK])
WINCH = [ROOT + WINCH_R*np.array([np.cos(a), np.sin(a), 0.0]) for a in np.radians([0.0, 120.0, 240.0])]

def tip_point(p, r_ring=R_RING):
    # back ring point farthest from the beam column, 0.15 m behind the membrane vertex along -s
    V = p["V"]; s = p["s"]
    e = np.array([1.0, 0.0, 0.0]) - s*s[0]; e /= np.linalg.norm(e)
    return V - 0.65*s + r_ring*e            # the back frame hub, 0.65 m behind the vertex (the fine stage sits between)

def main():
  global ROOT, WINCH
  POS = positions()
  log("=== the orbit the mount must serve (Quetta, el >= 12 deg, three seasons, half-hourly) ===")
  Vs = np.array([p["V"] for p in POS])
  log(f"{len(POS)} positions; vertex x {Vs[:,0].min():.2f}..{Vs[:,0].max():.2f} (north of the wall), y {Vs[:,1].min():.2f}..{Vs[:,1].max():.2f}, z {Vs[:,2].min():.2f}..{Vs[:,2].max():.2f} (deck 5.0)")
  rim_x_max = max(p["V"][0] + A_DISH*np.sqrt(1 - p["s"][0]**2) for p in POS)
  rim_y_max = max(abs(p["V"][1]) + A_DISH*np.sqrt(1 - p["s"][1]**2) for p in POS)
  log(f"rim sweep: north to x {rim_x_max:.2f} m, east-west to |y| {rim_y_max:.2f} m; lowest rim point z {min(p['V'][2] - A_DISH*np.sqrt(1 - p['s'][2]**2) for p in POS):.2f}")

  # ---------------------------------------------------------------- F support: does the north tower clear the dish?
  log("\n=== F support as modelled (arm 3 m from a tower at x 4.25): where the tower line pierces the dish ===")
  hits = []
  for p in POS:
      n = p["s"]; V = p["V"]
      # vertical line x = X_TOWER_N, y = 0 meets the dish plane n.(P - V) = 0
      if abs(n[2]) < 1e-6: continue
      z = V[2] - (n[0]*(X_TOWER_N - V[0]) + n[1]*(0 - V[1]))/n[2]
      Pp = np.array([X_TOWER_N, 0.0, z]); rad = np.linalg.norm(Pp - V)
      if rad < A_DISH and Z_DECK < z < F[2]:
          hits.append((p["season"], p["hour"], np.degrees(p["el"]), rad))
  inside_hole = [h for h in hits if h[3] < R_HOLE]
  log(f"tower line inside the dish disc at {len(hits)} of {len(POS)} positions; through the centre hole at {len(inside_hole)}; through the MEMBRANE at {len(hits) - len(inside_hole)}")
  if hits:
      worst = max(hits, key=lambda h: h[3]); log(f"worst: {worst[0]} {worst[1]:.1f} h, el {worst[2]:.0f} deg, {worst[3]:.2f} m from the vertex -> the tower must stand outside the sweep (x > {rim_x_max + 0.5:.1f} m) or become a mast pair at |y| > {rim_y_max + 0.5:.1f} m")

  # ---------------------------------------------------------------- root placement
  log("\n=== the vine rod: root on the deck, tip on the dish's back ring (r 0.8, north side), clear of the beam column ===")
  def seg_dist_to_vertical(P0, P1, x0, y0):
      # min distance between segment P0P1 and the vertical line (x0, y0)
      d = P1 - P0; ts = np.linspace(0, 1, 50)
      pts = P0[None, :] + ts[:, None]*d[None, :]
      return np.min(np.hypot(pts[:, 0] - x0, pts[:, 1] - y0))
  best = None
  for xr in np.arange(2.0, 5.01, 0.25):
      root = np.array([xr, 0.0, Z_DECK])
      Ls, tilts, clear = [], [], []
      for p in POS:
          T = tip_point(p); d = T - root; L = np.linalg.norm(d)
          Ls.append(L); tilts.append(np.degrees(np.arccos(d[2]/L)))
          clear.append(seg_dist_to_vertical(root, T, X_BEAM, 0.0))
      Ls, tilts, clear = np.array(Ls), np.array(tilts), np.array(clear)
      ok = clear.min() >= R_BEAM_DECK + 0.15 and Ls.min() >= 0.8
      score = (0 if ok else 1, Ls.max())
      if best is None or score < best[0]: best = (score, xr, Ls, tilts, clear)
  _, XR, Ls, tilts, clear = best
  ROOT = np.array([XR, 0.0, Z_DECK])
  assert abs(XR - ROOT_X) < 1e-9, f"scan chose root x {XR}; update ROOT_X"
  log(f"root at x {XR:.2f} m (north of the wall line by {XR - 1.25:.2f}): rod length {Ls.min():.2f}..{Ls.max():.2f} m, tilt from vertical {tilts.min():.0f}..{tilts.max():.0f} deg, min clearance to the beam column {clear.min():.2f} m")

  # ---------------------------------------------------------------- forces: rod thrust + 3 deck tendons, worst wind
  log("\n=== force balance at 9 m/s: rod thrust along the rod, three deck tendons at 120 deg around the root (r 5 m) ===")
  F_W9 = Q9*CD*AREA; T_MIN = 200.0
  for wr in (5.0, 7.0, 9.0, 12.0):
   WINCH = [ROOT + wr*np.array([np.cos(a), np.sin(a), 0.0]) for a in np.radians([0.0, 120.0, 240.0])]
   worst = dict(T=0, Tt=0, L=0)
   infeasible = 0
   for p in POS:
       tip = tip_point(p); u_r = tip - ROOT; L = np.linalg.norm(u_r); u_r /= L
       U = [(w - tip)/np.linalg.norm(w - tip) for w in WINCH]
       for wdir in (np.array([1, 0, 0.]), np.array([-1, 0, 0.]), np.array([0, 1, 0.]), np.array([0, -1, 0.])):
           ext = np.array([0, 0, -M_HEAD*9.81]) + F_W9*wdir
           # unknowns: T_rod, T1, T2, T3 >= T_MIN (rod >= 0): u_r T_rod + sum U_i T_i + ext = 0
           Aeq = np.column_stack([u_r] + U); beq = -ext
           res = linprog(c=[1, 1, 1, 1], A_eq=Aeq, b_eq=beq, bounds=[(0, None)] + [(T_MIN, None)]*3, method="highs")
           if not res.success: infeasible += 1; continue
           T, Tt = res.x[0], res.x[1:].max()
           if T > worst["T"]: worst = dict(T=T, Tt=Tt, L=L, season=p["season"], hour=p["hour"], wdir=wdir)
   log(f"winches at r {wr:.0f} m: infeasible {infeasible} of {4*len(POS)}; worst rod thrust {worst['T']:.0f} N at {worst.get('season')} {worst.get('hour')} h (rod {worst['L']:.2f} m), tendon up to {worst['Tt']:.0f} N")
   if abs(wr - WINCH_R) < 1e-9: worst_keep = dict(worst)
  worst = worst_keep; WINCH = [ROOT + WINCH_R*np.array([np.cos(a), np.sin(a), 0.0]) for a in np.radians([0.0, 120.0, 240.0])]
  # ---------------------------------------------------------------- rod sizing
  log("\n=== rod hose sizing (vine: everts from a reel at the root) ===")
  for r, p_bar in ((0.20, 0.30), (0.25, 0.20), (0.30, 0.15)):
      thrust = p_bar*1e5*np.pi*r**2; EI = ET*np.pi*r**3; Lmax = Ls.max()
      Pcr = np.pi**2*EI/Lmax**2                    # pinned at the root bend, pinned at the tendon-held tip
      log(f"r {r:.2f} m at {p_bar:.2f} bar: thrust {thrust:.0f} N (need > {worst['T']:.0f}), EI {EI/1e3:.1f} kN m2, Euler at {Lmax:.2f} m {Pcr:.0f} N -> SF {Pcr/max(worst['T'],1):.1f}; hoop {p_bar*1e5*r/1e3:.1f} kN/m")
  # ---------------------------------------------------------------- stiffness
  log("\n=== stiffness under a 9 m/s gust ===")
  k_att = EA_CABLE/1.3; K_rot = 1.5*k_att*1.2**2
  M_wind = F_W9*0.1*2*A_DISH
  log(f"attitude: three 4 mm tendons 1.3 m long from the rod tip to a 2.4 m back ring: K {K_rot/1e3:.0f} kN m/rad; wind torque {M_wind:.0f} N m -> {M_wind/K_rot*1e3:.1f} mrad (the strip tolerates several)")
  k_deck = EA_CABLE/6.0
  log(f"position: deck tendons ~6 m, {k_deck/1e3:.0f} kN/m each, lateral ~{1.5*k_deck*0.5/1e3:.0f} kN/m -> {F_W9/(1.5*k_deck*0.5)*1e3:.0f} mm under 750 N, i.e. the spot walks that much on the strip and {F_W9/(1.5*k_deck*0.5)*3.66*1e3:.0f} mm at F2 (M4 r 1.0)")
  log(f"survival: 25 m/s gives {Q25*CD*AREA:.0f} N; vent the rod and the plenum -> the dish lies face-up on the deck around the root, tendons slack")
  # ---------------------------------------------------------------- pneumatic F support option
  log("\n=== F support as a mast pair (pneumatic option) ===")
  y_m = rim_y_max + 0.7; h_m = F[2] - Z_DECK + 0.6
  for r, p_bar in ((0.30, 1.0), (0.35, 0.8)):
      EI = ET*np.pi*r**3; Pcr = np.pi**2*EI/(0.7*h_m)**2      # guyed at the top
      Mw = 0.5*np.pi*p_bar*1e5*r**3; q_m = Q9*1.2*2*r*h_m*h_m/2
      log(f"masts at y = +-{y_m:.1f} m, {h_m:.1f} m tall, r {r:.2f} at {p_bar:.1f} bar: Euler (guyed) {Pcr/1e3:.1f} kN, wrinkle {Mw/1e3:.1f} kN m vs wind {q_m/1e3:.2f} kN m; hoop {p_bar*1e5*r/1e3:.0f} kN/m")
  log("F hangs from a cable between the mast tops with fore-aft guys to the parapet; the strip's bearing ring and the arm end sit on it; the towers stand outside the sweep, so nothing of the mount is ever in the beam except the strip itself.")
  open(os.path.join(OUT, "checks.txt"), "w").write("\n".join(LOG))
  np.save(os.path.join(OUT, "root.npy"), ROOT)

if __name__ == "__main__":
  main()
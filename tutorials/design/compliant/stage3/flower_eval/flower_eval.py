#!/usr/bin/env python
"""The flower under a Hashemi-trained policy, watched: the puffer eval renderer (pyray, the Metal megakernel stepping the physics on
MPS, the torch twin tracing the rays once a frame) with the flower's mechanics in the loop and drawn in place of Hashemi's carriage.

What the flower adds to the env each step (dt 15 s): the wind the env carries (its diurnal base plus OU gusts) is given a von Karman
gust sample for the step (Iu 0.25) from the south, the drag and pitching moment on the bowl follow, the structure's image walk at F is
the part of the gust load the strut loop cannot follow (its band above 0.5 Hz, from the flower simulations: a compliance of 5 um per
newton of drag, a loop floor of 3 mm) plus the loop's own residual, and that walk is applied to the kernel's pointing as an
elevation and azimuth error of the head, so the rays land where the flower actually holds the dish. The membrane's figure under
wind is the kernel's own model (sig_wind); the gradient blur of stage3/topopt/membrane_wind.py (a sealed plenum) is shown beside it.

Drawn: the 1 m stem on the deck, the pedicel's boom to the receptacle ring 1.8 m behind the vertex, the six struts (coloured by
force) to the platform ring 0.6 m behind, the head's membrane as the base renderer draws it, the wind arrow with its gust, the image's
walk at F. Hashemi's rails, A-frames, counterweight, the north tower and its arm are not drawn: nothing hangs from anything.

    .venv/bin/python flower_eval.py [--ckpt experiments/X.pt] [--wind-from S|N] [--fps 24]
run from tutorials/puffer_tandoor (the puffer venv: pyray, pufferlib, torch on MPS)."""
import os, sys, glob, time, inspect, textwrap, functools, argparse, numpy as np
ART = "/Users/faezs/ARTIST"
for p in (ART, os.path.join(ART, "tutorials"), os.path.join(ART, "tutorials", "puffer_tandoor")):
    if p not in sys.path: sys.path.insert(0, p)
import torch
import pufferlib, pufferlib.vector
from pufferlib import pufferl
import pufferlib.environments.tandoor as TP                          # the symlinked puffer_tandoor package: env classes and the policy module
Base = TP.TandoorHashemiEnv
# ------------------------------------------------------------------ the flower's mechanics, as the simulations measured them
G, A_M, RHO_AIR = 4.0, 2.1, 1.03; A_DISH = np.pi*A_M**2; D_DISH = 2*A_M
CD_BOWL, CD_BACK, C_M, C_L = 1.40, 1.05, 0.15, 0.5
K_IMG = 5.0e-6          # m of image walk at F per N of drag on the head, loop open (pedicel + struts + stem: ~1 cm per 2 kN, sheets 58-59)
F_LOOP = 0.5            # Hz: the strut loop's bandwidth (30 fps, 3 mm per frame, the identified or analytic gain)
FLOOR = 0.003           # m rms: the loop's residual in still air (the schedule's steps, the dither)
IU, L_TURB = 0.25, 50.0
D_BACK, H_HEX, R_REC, R_PLAT = 0.6, 1.2, 1.5, 1.0
BASE_ANG = np.radians([-15, 15, 105, 135, 225, 255]); PLAT_ANG = np.radians([315, 45, 75, 165, 195, 285])
def karman_frac_above(fc, U):
    f = np.logspace(-6, 4, 4000); S = (4*L_TURB/U)/(1 + 70.8*(f*L_TURB/U)**2)**(5/6); return float(np.trapezoid(S*f**2/(fc**2 + f**2), f)/np.trapezoid(S, f))
class FlowerMech:
    def __init__(self, wind_from="S", seed=0):
        self.rng = np.random.default_rng(seed); self.what = np.array([1.0, 0, 0]) if wind_from == "S" else np.array([-1.0, 0, 0])   # the wind blows toward +x (north) when from the south
        self.walk = np.zeros(2); self.d_el = self.d_az = 0.0; self.prev = np.zeros(2); self.gust = 0.0; self.V = 0.0
        self.F_drag = self.M_pitch = self.F_strut = 0.0; self.sig_mem = 0.0; self.hist = []
    def step(self, V_mean, n_head, el_deg):
        """one env step: a gust sample, the loads, the image walk the loop leaves, the pointing error to hand the kernel"""
        U = max(float(V_mean), 0.0); self.V = U
        self.gust = float(self.rng.normal(0.0, IU*U)) if U > 0 else 0.0; V = max(U + self.gust, 0.0)
        q = 0.5*RHO_AIR*V*V; ca = float(np.dot(n_head, self.what)); into = ca < 0; cd = 0.25 + ((CD_BOWL if into else CD_BACK) - 0.25)*ca*ca
        self.F_drag = q*A_DISH*cd; self.M_pitch = q*A_DISH*D_DISH*(C_M if into else 0.10)*2*abs(ca)*np.sqrt(max(1 - ca*ca, 0.0)); self.F_strut = self.F_drag/(6*np.cos(np.radians(35))) + 130*9.81/6
        # the loop removes the mean and the slow part: what reaches the image is the gust load above F_LOOP, plus the floor
        frac = karman_frac_above(F_LOOP, U) if U > 0.5 else 0.0
        sig_gust = RHO_AIR*U*(IU*U)*A_DISH*cd                                     # N rms of drag fluctuation
        sig_walk = np.hypot(K_IMG*sig_gust*np.sqrt(frac), FLOOR)
        along = self.rng.normal(0.0, sig_walk); across = self.rng.normal(0.0, 0.5*sig_walk)   # along the wind (drag), across it (lift, C_L 0.5 sin 2 alpha)
        self.walk = np.array([along, across])                                        # m at F: (along-wind, cross-wind)
        # pointing error of the head that produces that walk: the image moves 2 g theta
        self.d_el = float(np.degrees(along/(2*G))); self.d_az = float(np.degrees(across/(2*G))/max(np.cos(np.radians(el_deg)), 0.2))
        self.sig_mem = 2.63e-5*V*V                                                   # rad rms, the pitching moment's gradient on the film (membrane_wind.py), the uniform part sealed away
        self.hist.append((U, V, np.linalg.norm(self.walk)))
# ------------------------------------------------------------------ the env with the flower in the loop
class FlowerEnv(Base):
    def __init__(self, *a, wind_from="S", wind_scale=1.0, **k):
        k["num_agents"] = 1; super().__init__(*a, **k); self._fl = FlowerMech(wind_from); self._fl_applied = np.zeros(2); self._wind_scale = float(wind_scale)
    def step(self, actions):
        S = getattr(self, "_gpu", None)
        if S is not None and hasattr(S, "el_m"):
            d = np.array([self._fl.d_el, self._fl.d_az]); inc = d - self._fl_applied
            S.el_m[0] += float(inc[0]); S.az_m[0] += float(inc[1]); self._fl_applied = d                 # the head points where the flower holds it
        out = super().step(actions)
        if bool(self.truncations[0]): self._fl_applied = np.zeros(2)                                   # the kernel reset the motors to the sun
        if self.render_mode != "human" and getattr(self, "_gpu", None) is not None:                     # headless: the base syncs and traces only for the window
            self._sync_from_gpu(); rm = self.render_mode; self.render_mode = "human"
            try: self._render_trace()
            finally: self.render_mode = rm
        H = getattr(self, "_hv", None)
        if H is not None:
            self._fl.step(self._wind_scale*float(self.wind[0]), np.asarray(H["naim"], float), float(H["el"]) if "el" in H else 45.0)
        return out
    # ---- drawing
    def _flower_geom(self, H):
        C = np.asarray(H["C"], float); n = np.asarray(H["naim"], float); n = n/np.linalg.norm(n)
        Ff = np.asarray(self.F_focus, float); T0 = np.array([Ff[0] + 3.0, Ff[1], self.z_deck + 1.0]); foot = np.array([T0[0], T0[1], self.z_deck])
        ref = np.array([-1.0, 0, 0]); xl = ref - n*(ref@n)
        if np.linalg.norm(xl) < 1e-6: xl = np.array([0, 1.0, 0]) - n*n[1]
        xl /= np.linalg.norm(xl); yl = np.cross(n, xl)
        Cb = C - (D_BACK + H_HEX)*n; Cp = C - D_BACK*n
        B = [Cb + R_REC*(np.cos(a)*xl + np.sin(a)*yl) for a in BASE_ANG]; P = [Cp + R_PLAT*(np.cos(a)*xl + np.sin(a)*yl) for a in PLAT_ANG]
        return dict(C=C, n=n, T0=T0, foot=foot, Cb=Cb, Cp=Cp, B=B, P=P, xl=xl, yl=yl, Ff=Ff)
    def _draw_flower(self, pr, v3, ring, disc, H, hdir, zh_):
        if H is None: return
        g = self._flower_geom(H); fl = self._fl
        stem, boom, strut, ringc = (128, 84, 40, 255), (150, 100, 52, 255), (176, 120, 66, 255), (90, 100, 120, 255)
        # THE DECK the flower stands on: the env's machine deck at z_deck (deck_h above the pot), a platform on stubs over the roof the
        # base renderer grids at Z_ROOF; the Hashemi rail stood on the same deck, nothing drew it
        zd = float(self.z_deck); zr = float(Base.render.__globals__["Z_ROOF"]); Ff = g["Ff"]; dx0, dx1, dy = Ff[0] - 3.0, Ff[0] + 6.0, 5.5
        dcol = (150, 140, 120, 255)
        for gx in np.linspace(dx0, dx1, 10): pr.draw_line_3d(v3([gx, -dy, zd]), v3([gx, dy, zd]), dcol)
        for gy in np.linspace(-dy, dy, 12): pr.draw_line_3d(v3([dx0, gy, zd]), v3([dx1, gy, zd]), dcol)
        for cx in np.linspace(dx0, dx1, 4):
            for cy in (-dy, dy): pr.draw_line_3d(v3([cx, cy, zr]), v3([cx, cy, zd]), (120, 110, 95, 255))
        pr.draw_cylinder_ex(v3(g["foot"] - np.array([0, 0, 0.04])), v3(g["foot"] + np.array([0, 0, 0.04])), 0.30, 0.30, 16, (90, 80, 70, 255))   # the stem's base plate on the deck
        pr.draw_cylinder_ex(v3(g["foot"]), v3(g["T0"]), 0.108, 0.108, 12, stem)                       # the stem: steel CHS 215 x 9, 1 m, on the deck
        pr.draw_sphere(v3(g["T0"]), 0.16, ringc)                                                        # slew and luff servo
        pr.draw_cylinder_ex(v3(g["T0"]), v3(g["Cb"]), 0.11, 0.11, 12, boom)                              # the pedicel's boom
        pr.draw_sphere(v3(g["Cb"]), 0.14, ringc)                                                        # the wrist
        e1, e2 = g["xl"], g["yl"]; t = np.linspace(0, 2*np.pi, 49)
        for r_, c_, col in ((R_REC, g["Cb"], stem), (R_PLAT, g["Cp"], ringc)):
            pts = [c_ + r_*(np.cos(x)*e1 + np.sin(x)*e2) for x in t]
            for k in range(48): pr.draw_line_3d(v3(pts[k]), v3(pts[k+1]), col)
        for a in BASE_ANG: pr.draw_line_3d(v3(g["Cb"]), v3(g["Cb"] + R_REC*(np.cos(a)*e1 + np.sin(a)*e2)), ringc)
        fr = float(np.clip(fl.F_strut/6000.0, 0, 1)); scol = (int(120 + 135*fr), int(120*(1 - fr) + 60), int(160*(1 - fr)), 255)
        for j in range(6):
            pr.draw_cylinder_ex(v3(g["B"][j]), v3(g["P"][j]), 0.0425, 0.0425, 8, scol)
            pr.draw_sphere(v3(g["B"][j]), 0.06, ringc); pr.draw_sphere(v3(g["P"][j]), 0.06, ringc)
        # the wind: an arrow upwind of the head, its length the mean, a brighter tip the gust
        C = g["C"]; w = fl.what; base = C - 4.5*w + np.array([0, 0, 0.8]); L = 0.25*fl.V; Lg = 0.25*max(fl.V + fl.gust, 0.0)
        pr.draw_line_3d(v3(base), v3(base + L*w), (120, 200, 240, 220)); pr.draw_line_3d(v3(base + L*w), v3(base + Lg*w), (250, 120, 60, 240) if fl.gust > 0 else (80, 140, 200, 200))
        for k in range(3):
            o = np.array([0, 0.25*(k - 1), 0.0]); pr.draw_line_3d(v3(base + o), v3(base + o + L*w), (120, 200, 240, 110))
        self._pot_lbls.append((base + np.array([0, 0, 0.35]), f"wind {fl.V:.1f} {'+' if fl.gust >= 0 else '-'}{abs(fl.gust):.1f} m/s", (140, 210, 245, 255)))
        # the image at F: where the flower puts it (the walk, exaggerated 5x for the eye), the pipe mouth for scale
        Ff = g["Ff"]; ex = np.cross(g["n"], zh_); ex = ex/max(np.linalg.norm(ex), 1e-9); ey = np.cross(ex, g["n"])
        spot = Ff + 5.0*(fl.walk[0]*ey + fl.walk[1]*ex)
        ring(spot, 0.08 + 2*fl.sig_mem*G, (255, 200, 60, 255), 16); pr.draw_line_3d(v3(Ff), v3(spot), (255, 200, 60, 160))
        self._pot_lbls.append((spot + np.array([0, 0, 0.25]), f"image walk {100*np.linalg.norm(fl.walk):.1f} cm (x5)", (255, 210, 90, 255)))
    def _draw_flower_hud(self, pr):
        fl = self._fl; y0 = 12
        Lboom = np.linalg.norm(self._flower_geom(self._hv)["Cb"] - self._flower_geom(self._hv)["T0"]) if getattr(self, "_hv", None) is not None else 0.0
        q_w = 0.6*fl.V**2; sig_env = 0.88e-3*(max(q_w, 1e-9)/15.0)**0.6
        rms = np.sqrt(np.mean([h[2]**2 for h in fl.hist[-240:]])) if fl.hist else 0.0
        lines = [f"THE FLOWER  stem 1 m on the deck . boom {Lboom:.2f} m . six struts 1.45 m on flexure balls",
                 f"wind {fl.V:.1f} m/s mean, gust {fl.gust:+.1f} (von Karman, Iu 0.25, from the {'S' if fl.what[0] > 0 else 'N'})" + (f"  [the env's wind x{self._wind_scale:.1f} for the flower's loads]" if self._wind_scale != 1.0 else ""),
                 f"drag {fl.F_drag/1e3:.2f} kN  pitching {fl.M_pitch/1e3:.2f} kN m  strut {fl.F_strut/1e3:.2f} kN",
                 f"image walk at F {100*np.linalg.norm(fl.walk):.1f} cm (loop residual above {F_LOOP} Hz + {1e3*FLOOR:.0f} mm floor); last hour rms {100*rms:.1f} cm",
                 f"pointing handed to the kernel  el {60*fl.d_el:.2f}'  az {60*fl.d_az:.2f}'",
                 f"blur: kernel sig_wind {1e3*sig_env:.2f} mrad . film gradient (sealed plenum) {1e3*fl.sig_mem:.2f} mrad rms"]
        pr.draw_rectangle(12, y0 - 4, 640, 18*len(lines) + 8, (10, 12, 18, 170))
        for j, l in enumerate(lines): pr.draw_text(l, 18, y0 + 18*j, 14, (225, 232, 240, 255) if j else (255, 214, 120, 255))
# ---- the base renderer with Hashemi's carriage, tower and arm cut out and the flower drawn in their place
def _patched_render():
    src = textwrap.dedent(inspect.getsource(Base.render))
    def cut(s, start, end, repl):
        """cut from the line holding `start` through the line holding `end` (indentation-free markers), keep the first line's indent"""
        i0 = s.index(start); i0 = s.rfind("\n", 0, i0) + 1; ind = s[i0:len(s) - len(s[i0:].lstrip(" "))]
        i1 = s.index(end, i0); i1 = s.index("\n", i1) + 1; return s[:i0] + ind + repl + "\n" + s[i1:]
    src = cut(src, "# fixed ring rail on posts (roof stubs south, courtyard north)", "(110, 110, 120, 255))", "self._draw_flower(pr, v3, ring, disc, H, hdir, zh_)")
    src = cut(src, "pr.draw_line_3d(v3(Ps_), v3(Q_), colt)                    # the arm", "ring([Ps_[0], 0, zz], 0.20, (150, 140, 120, 255), 12)", "pass                                                        # no arm, no north tower: F is the pipe's mouth")
    i = src.index("# the day so far, as line graphs"); j = src.rfind("\n", 0, i) + 1; ind = src[j:i]
    src = src[:j] + ind + "self._draw_flower_hud(pr)\n" + src[j:]
    ns = dict(Base.render.__globals__); exec(src, ns); return ns["render"]
FlowerEnv.render = _patched_render()
# ------------------------------------------------------------------ the eval loop (pufferl.eval with our env)
def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--ckpt", default=None); ap.add_argument("--wind-from", default="S"); ap.add_argument("--fps", type=float, default=24.0); ap.add_argument("--steps", type=int, default=0)
    ap.add_argument("--headless", action="store_true"); ap.add_argument("--wind-scale", type=float, default=1.0, help="multiply the env's wind for the flower's loads (a stress knob; the kernel's own blur keeps the env's wind)"); A = ap.parse_args()
    sys.argv = [sys.argv[0]]; args = pufferl.load_config("puffer_hashemi")
    args["env"]["num_agents"] = 1; args["env"]["render_mode"] = None if A.headless else "human"; args["vec"] = dict(backend="Serial", num_envs=1)
    vecenv = pufferlib.vector.make(functools.partial(FlowerEnv, wind_from=A.wind_from, wind_scale=A.wind_scale), env_kwargs=args["env"], **args["vec"])
    n_obs = int(np.prod(vecenv.single_observation_space.shape))
    ckpt = A.ckpt
    if ckpt is None:                                    # the newest checkpoint trained on THIS env's observation (the design runs carry 23 more)
        exp = os.path.join(ART, "tutorials", "puffer_tandoor", "experiments")
        for cand in sorted(glob.glob(os.path.join(exp, "*.pt")) + glob.glob(os.path.join(exp, "*", "model_*.pt")), key=os.path.getctime, reverse=True):
            try:
                sd = torch.load(cand, map_location="cpu"); w = sd.get("policy.encoder.0.weight")
                if w is not None and w.shape[1] == n_obs: ckpt = cand; break
            except Exception: continue
        if ckpt is None: raise SystemExit(f"no checkpoint with {n_obs} observations under {exp}")
    args["load_model_path"] = ckpt
    policy = pufferl.load_policy(args, vecenv); device = args["train"]["device"]
    print(f"[flower eval] policy {os.path.basename(ckpt)}, device {device}, wind from {A.wind_from}")
    ob, info = vecenv.reset(); driver = vecenv.driver_env; state = {}
    if args["train"]["use_rnn"]: state = dict(lstm_h=torch.zeros(1, policy.hidden_size, device=device), lstm_c=torch.zeros(1, policy.hidden_size, device=device))
    n = 0; t0 = time.time()
    while True:
        if not A.headless: driver.render()
        with torch.no_grad():
            logits, value = policy.forward_eval(torch.as_tensor(ob).to(device), state); action, logprob, _ = pufferlib.pytorch.sample_logits(logits)
            action = action.cpu().numpy().reshape(vecenv.action_space.shape)
        ob = vecenv.step(action)[0]; n += 1
        if A.headless and n % 50 == 0:
            fl = driver._fl; print(f"  step {n}: t {float(driver.t_solar[0]):.2f} h wind {fl.V:.1f}{fl.gust:+.1f} m/s drag {fl.F_drag:.0f} N walk {100*np.linalg.norm(fl.walk):.1f} cm p_in {float(driver.p_in[0]):.0f} W")
        if A.steps and n >= A.steps: break
        if not A.headless: time.sleep(max(0.0, 1.0/A.fps - 0.0))
    print(f"[flower eval] {n} steps in {time.time() - t0:.0f} s")
if __name__ == "__main__": main()

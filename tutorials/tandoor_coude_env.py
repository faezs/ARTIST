"""
TandoorCoudeEnv: keep the beam-down's POWER, delete its beam-in-the-room.

The safety review rejected the beam-down categorically - not for its
optics but for its routing: a 4.9 m dish on the roof of an occupied
workroom, beam descending through that room into a pot whose mouth the
cook reaches into ~700 times a day at 35 kW/m2. Both reviewers found the
personnel-protection function unachievable by maintenance in that
context, and the tube "fix" was worse (a 0.6 m3 flour-breathing duct
with 380-545 C walls is a deflagration vessel).

But the beam-down earns 4.5 kW against the polar retrofit's 2.9, because
2-axis tracking pays no cosine. So: keep it, and route the beam where
people are not.

WHY NOT SIMPLY AIM THE SECONDARY AT A WALL PORT: an F2-pivot fixes the
focal POINT, not the beam DIRECTION - over a tracking day the beam
sweeps a cone as wide as the tilt range into the port. Containing a
swept cone needs an open shaft, i.e. the in-room hazard again.

THE COUDE FOLD: put flat 1 on the elevation axis and flat 2 on the
azimuth axis. The beam then leaves DOWN the azimuth axis, which is
vertical and fixed in space however the dish is pointed. Drop a masonry
chase straight down that axis inside the wall, turn once at the bottom,
and enter the pot through its native base air-inlet - the same entry the
polar retrofit uses, which needs no shutter interlock because the beam
and the cook never share a volume.

THE COST IS SMALL, AND THAT IS THE POINT: the folds sit in the
CONVERGING beam, so they are ~0.3-0.5 m - small enough to afford
silvered glass at 0.95 rather than soiled film at 0.88. Chain:
  in-room (rejected) 0.90 x 0.88 x 0.90            = 0.713  4500 W
  coude, film folds  0.90 x 0.88 x 0.88^3          = 0.540  3407 W
  coude, GLASS folds 0.90 x 0.88 x 0.95^3          = 0.679  4287 W
so containment costs ~5%, and the glass folds additionally cut UV-B -
the panel's chronic-exposure finding, which an all-metal path makes
worse (an all-metal light path is a UV lamp).

MODELLING NOTE, stated rather than hidden: this reuses the polar env's
validated single-stage focus machinery with a larger mirror and 2-axis
cosine, rather than re-deriving the explicit Cassegrain. The coude path
length is comparable to the polar throw, so the blur lever is similar;
an explicit two-stage trace is the refinement this owes.
"""

import numpy as np
import torch

from tandoor_polar_env import TandoorPolarEnv, R_DUCT, R_POT, H_POT, R_MOUTH
from tandoor_rl_env import _sim


class TandoorCoudeEnv(TandoorPolarEnv):
    # WIDE defocus authority. With 2-axis tracking on an 18.9 m2 dish the
    # plant is power-RICH, and the binding constraint flips from "can it
    # reach the band" to "can it avoid cooking past it" - the same lesson
    # the beam-down geometry sweep taught (a 7.1 kW config scored WORSE
    # than a 4.3 kW one). Level 0 is a genuine dump, not a trim.
    LEVEL_FRAC = [0.62, 0.74, 0.85, 0.93, 1.00, 1.04, 1.10]


    def __init__(self, *args, a_mem=1.75, fold_rho=0.95, n_folds=3,
                 z_gap=2.5, r_sec=0.75, **kwargs):
        self.z_gap = float(z_gap)
        self.r_sec = float(r_sec)
        self._el_now = 55.0
        self.a_mem = float(a_mem)
        self.fold_rho = float(fold_rho)
        self.n_folds = int(n_folds)
        super().__init__(*args, **kwargs)

    def _build_optics(self):
        super()._build_optics()
        cfg = self.cfg
        self._build_coude_table(cfg)
        # bigger aperture: 2-axis tracking justifies the larger dish
        scale = (self.a_mem / cfg.a) ** 2
        # coude chain: membrane x secondary x N silvered-glass folds.
        # The folds are small (converging beam) so glass is affordable.
        chain = 0.90 * 0.88 * self.fold_rho ** self.n_folds
        self._ray_pw = self._ray_pw / self._loss_chain * chain * scale
        self._loss_chain = chain
        print(f"  [coude] {np.pi*self.a_mem**2:.1f} m2 dish, {self.n_folds} "
              f"glass folds @{self.fold_rho}: chain {chain:.3f} "
              f"(in-room was 0.713); beam never enters the workroom")

    def render(self):
        out = super().render()
        if self.render_mode == "human":
            import pyray as pr
            pr.begin_drawing()
            pr.draw_text("NOTE: 3-D scene inherited from the polar env - it "
                         "draws a polar-axis mirror,", 20, 26, 16,
                         (235, 160, 90, 255))
            pr.draw_text("NOT the roof Cassegrain + coude folds + wall "
                         "chase this env actually models.", 20, 48, 16,
                         (235, 160, 90, 255))
            pr.end_drawing()
        return out

    def _build_coude_table(self, cfg):
        """Tabulate the EXACT coude trace (primary -> secondary -> M3 ->
        M4 -> chase -> M5 -> pot) over pressure level x elevation. The
        runtime then interpolates instead of re-tracing, but every entry
        is a real traced pass fraction, not a model."""
        import tandoor_coude_optics as CO
        self.CO = CO
        cfg.a = self.a_mem
        mems = [_sim.solve_membrane(cfg, self.p0 * f, n=400)
                for f in self.level_frac]
        self._coude_mems = mems
        m0 = mems[4]
        f1 = m0["z0"] + m0["f_fit"]
        z_gap = self.z_gap
        zv = f1 - z_gap
        L = CO.unfolded_path(zv)
        F2 = zv - L                      # focus lands IN THE POT
        self.M_cass = (zv - F2) / z_gap
        self.efl = f1 * self.M_cass
        self.sec = _sim.Secondary(f1, F2, zv, self.r_sec)
        self.f1_c, self.zv_c = f1, zv
        rng = np.random.default_rng(3)
        NR = 900
        th = rng.uniform(0, 2 * np.pi, NR)
        rr = np.sqrt(rng.uniform((0.16 * cfg.a) ** 2,
                                 (0.98 * cfg.a) ** 2, NR))
        self._cx, self._cy, self._cr = rr * np.cos(th), rr * np.sin(th), rr
        self._el_grid = np.array([25., 35., 45., 55., 65., 75., 88.])
        self._pass = np.zeros((len(self.level_frac), len(self._el_grid)))
        self._nodefrac = np.zeros((len(self.level_frac),
                                   len(self._el_grid), self.n_nodes))
        sig = float(np.sqrt(self.sigma_sun ** 2 + self.sig_static ** 2))
        for li, m in enumerate(mems):
            sg, sp = _sim.sag_interp(m, torch.tensor(self._cr,
                                                     dtype=torch.float64))
            for ei, el in enumerate(self._el_grid):
                R = CO.trace_coude(self._cx, self._cy, sg.numpy(),
                                   sp.numpy(), self.sec, float(el), 0.0,
                                   f1, sig, rng)
                thr = R["through"]
                self._pass[li, ei] = thr.mean()
                if thr.sum():
                    self._nodefrac[li, ei] = self._pot_nodes(R["strike"][thr])
        area = np.pi * (cfg.a ** 2) * (1 - 0.16 ** 2)
        self._coude_area = area
        print(f"  [coude exact] {area:.1f} m2, z_gap={z_gap:.1f}, "
              f"M={self.M_cass:.1f}, EFL={self.efl:.1f} m, unfolded "
              f"{L:.2f} m, peak pass {self._pass.max():.2f}")

    def _pot_nodes(self, strike):
        """Bin traced strikes onto the pot's belt / hearth / crown nodes."""
        CO = self.CO
        out = np.zeros(self.n_nodes)
        z = strike[:, 2]
        phi = np.arctan2(strike[:, 1], strike[:, 0])
        seg = np.clip(((phi + np.pi) / (2 * np.pi)
                       * self.n_belt).astype(int), 0, self.n_belt - 1)
        hearth = z < 0.10
        crown = z > 0.80
        for k in range(len(strike)):
            if hearth[k]:
                out[self.n_belt] += 1
            elif crown[k]:
                out[self.n_belt + 2] += 1
            else:
                out[seg[k]] += 1
        return out / max(len(strike), 1)

    def _trace_power(self, p_eff, sigma_b, offset_w, soil):
        """Interpolate the exact-trace table on (pressure level, sun
        elevation); boresight enters as an extra spill term."""
        B = p_eff.shape[0]
        el = float(np.clip(self._el_now, self._el_grid[0],
                           self._el_grid[-1]))
        ei = np.interp(el, self._el_grid, np.arange(len(self._el_grid)))
        i0, fr = int(np.floor(ei)), ei - np.floor(ei)
        i1 = min(i0 + 1, len(self._el_grid) - 1)
        lv = np.clip((np.asarray(p_eff) / self.p0 - self.level_frac[0])
                     / (self.level_frac[-1] - self.level_frac[0])
                     * (self.N_LEVELS - 1), 0, self.N_LEVELS - 1)
        l0 = np.clip(lv.astype(int), 0, self.N_LEVELS - 2)
        lf = lv - l0
        def blend(tab):
            a = (1 - lf) * tab[l0, i0] + lf * tab[l0 + 1, i0]
            b = (1 - lf) * tab[l0, i1] + lf * tab[l0 + 1, i1]
            return (1 - fr) * a + fr * b
        pf = blend(self._pass)
        nf = np.stack([blend(self._nodefrac[:, :, k])
                       for k in range(self.n_nodes)], 1)
        bore = np.hypot(offset_w[:, 0], offset_w[:, 1])
        pf = pf * np.exp(-(bore / 0.09) ** 2)       # boresight spill
        pw = (self._coude_area * self._loss_chain * np.asarray(soil) * pf)
        return torch.tensor(nf * pw[:, None], dtype=torch.float32)

    def _cosine(self, decl_deg):
        el, _, _ = _sim.solar_position(self.lat, self.day,
                                       float(self.t_solar[0]))
        self._el_now = el
        """2-axis tracking: no cosine loss at all. This is the whole
        reason to keep the beam-down over the polar retrofit (0.70)."""
        return 1.0

    # ------------------------------------------------ exact 3-D renderer #
    def render(self):
        if self.render_mode != "human":
            return None
        import pyray as pr
        import tandoor_coude_optics as CO
        import numpy as _np
        W, H = 1400, 850
        if not self._window:
            pr.init_window(W, H, "Coude beam-down - exact traced path")
            pr.set_target_fps(24); self._window = True
            self._cam_th, self._cam_ph, self._cam_r = 1.05, 0.28, 14.0
            self._cam_tgt = _np.array([0.4, 0.0, 2.0])
        if pr.is_mouse_button_down(0):
            d = pr.get_mouse_delta()
            self._cam_th -= d.x * 0.006
            self._cam_ph = float(_np.clip(self._cam_ph + d.y * 0.006,
                                          -0.3, 1.45))
        if pr.is_mouse_button_down(1):
            d = pr.get_mouse_delta()
            f = _np.array([_np.cos(self._cam_th), _np.sin(self._cam_th)])
            self._cam_tgt[:2] += (_np.array([f[1], -f[0]]) * d.x
                                  - f * d.y) * 0.004 * self._cam_r
            self._cam_tgt[2] += d.y * 0.003 * self._cam_r
        if pr.is_key_pressed(pr.KeyboardKey.KEY_R):
            self._cam_tgt = _np.array([0.4, 0.0, 2.0])
            self._cam_th, self._cam_ph, self._cam_r = 1.05, 0.28, 14.0
        self._cam_r = float(_np.clip(
            self._cam_r - pr.get_mouse_wheel_move() * 0.9, 2.0, 40.0))
        tgt = pr.Vector3(*[float(v) for v in self._cam_tgt])
        cp = pr.Vector3(
            tgt.x + self._cam_r*_np.cos(self._cam_ph)*_np.cos(self._cam_th),
            tgt.y + self._cam_r*_np.cos(self._cam_ph)*_np.sin(self._cam_th),
            tgt.z + self._cam_r*_np.sin(self._cam_ph))
        cam = pr.Camera3D(cp, tgt, pr.Vector3(0.,0.,1.), 45.,
                          pr.CameraProjection.CAMERA_PERSPECTIVE)

        el, az, _ = _sim.solar_position(self.lat, self.day,
                                        float(self.t_solar[0]))
        el = max(el, 20.0)
        lv = int(_np.clip((self.p_act[0]/self.p0 - self.level_frac[0])
                 / (self.level_frac[-1]-self.level_frac[0])
                 * (self.N_LEVELS-1), 0, self.N_LEVELS-1))
        m = self._coude_mems[lv]
        sg, sp = _sim.sag_interp(m, torch.tensor(self._cr,
                                                 dtype=torch.float64))
        sig = float(_np.sqrt(self.sigma_sun**2 + self.sig_static**2))
        R = CO.trace_coude(self._cx, self._cy, sg.numpy(), sp.numpy(),
                           self.sec, float(el), float(_np.degrees(az)),
                           self.f1_c, sig, _np.random.default_rng())
        def v3(p): return pr.Vector3(float(p[0]),float(p[1]),float(p[2]))
        def ring(c,r,col,n=30,ax="z"):
            t_=_np.linspace(0,2*_np.pi,n+1)
            if ax=="z": q=_np.stack([c[0]+r*_np.cos(t_),c[1]+r*_np.sin(t_),
                                     _np.full(n+1,c[2])],1)
            else: q=_np.stack([_np.full(n+1,c[0]),c[1]+r*_np.cos(t_),
                               c[2]+r*_np.sin(t_)],1)
            for k in range(n): pr.draw_line_3d(v3(q[k]),v3(q[k+1]),col)
        dim = float(_np.clip(self.dni[0]/950.,0.05,1.))
        pr.begin_drawing()
        pr.clear_background((int(11+24*dim),int(13+30*dim),int(21+50*dim),255))
        pr.draw_rectangle(1000,0,W-1000,H,(13,15,22,255))
        pr.begin_mode_3d(cam)
        # --- building.  ORIGIN IS THE POT FLOOR: the workfloor the cook
        # stands on is a full metre up, at z = H_POT.
        Z_FL = H_POT
        for zz,col in ((Z_FL,(70,74,88,255)),(CO.Z_ROOF,(90,86,78,255))):
            for gx in _np.linspace(-1.6,2.6,9):
                pr.draw_line_3d(v3([gx,-2.0,zz]),v3([gx,2.0,zz]),col)
            for gy in _np.linspace(-2.0,2.0,9):
                pr.draw_line_3d(v3([-1.6,gy,zz]),v3([2.6,gy,zz]),col)
        # the wall the chase is cored through, workfloor -> roof only
        for cx_ in (CO.X_CHASE-0.55, CO.X_CHASE+0.55):
            for gy in (-2.0,2.0):
                pr.draw_line_3d(v3([cx_,gy,Z_FL]),v3([cx_,gy,CO.Z_ROOF]),
                                (120,104,86,255))
            pr.draw_line_3d(v3([cx_,-2,CO.Z_ROOF]),v3([cx_,2,CO.Z_ROOF]),
                            (120,104,86,255))
        # --- the masonry chase: the invariant vertical line.  Below the
        # workfloor it is buried alongside the pot; above it, cored wall.
        for zz in _np.linspace(CO.Z_DUCT,CO.Z_M4,11):
            ring([CO.X_CHASE,0,zz],CO.R_CHASE,
                 (140,120,96,255) if zz>Z_FL else (104,92,74,255),20)
        # --- existing pot, SUNK: floor at z=0, rim flush with workfloor
        for zz in _np.linspace(0.0,H_POT,7):
            ring([0,0,zz],R_POT if zz<0.78*H_POT else R_MOUTH,
                 self._heat_color(self.T[0,0]) if 0.2<zz<0.78*H_POT
                 else (150,120,94,255),24)
        ring([0,0,0.02],R_POT*0.55,self._heat_color(self.T[0,self.n_belt]),14)
        ring([R_POT,0,CO.Z_DUCT],CO.R_DUCT_C,(120,220,235,255),16,ax="x")
        # --- mount axes: azimuth (vertical, FIXED) and elevation
        pr.draw_line_3d(v3([CO.X_CHASE,0,CO.Z_DUCT]),
                        v3([CO.X_CHASE,0,CO.Z_M4+0.6]),(90,150,220,255))
        aw = R["axis_w"]
        pr.draw_line_3d(v3(R["m4"]-aw*1.6),v3(R["m4"]+aw*0.4),
                        (90,150,220,255))
        for p_,nm_,col_ in ((R["m3"],"M3",(235,120,120,255)),
                            (R["m4"],"M4",(235,120,120,255)),
                            ([CO.X_CHASE,0,CO.Z_DUCT],"M5",(235,120,120,255))):
            ring(p_,0.16,col_,14); ring(p_,0.10,col_,12)
        # --- dish + secondary at their traced positions
        M, piv = R["M"], R["pivot"]
        for rr_ in _np.linspace(0.25*self.a_mem, self.a_mem, 4):
            th_=_np.linspace(0,2*_np.pi,29)
            sag_=float(_np.interp(rr_,self._cr[_np.argsort(self._cr)],
                                  sg.numpy()[_np.argsort(self._cr)]))
            q=_np.stack([rr_*_np.cos(th_),rr_*_np.sin(th_),
                         _np.full(29,sag_)],1)
            qw=(M@q.T).T+piv
            for k in range(28):
                pr.draw_line_3d(v3(qw[k]),v3(qw[k+1]),(90,150,235,255))
        h2m=R["h2"].mean(0)
        ring_sec=[]
        for k in range(25):
            a_=2*_np.pi*k/24
            p_=(M@_np.array([self.r_sec*_np.cos(a_),self.r_sec*_np.sin(a_),
                             self.zv_c]))+piv
            ring_sec.append(p_)
        for k in range(24):
            pr.draw_line_3d(v3(ring_sec[k]),v3(ring_sec[k+1]),(225,80,80,255))
        # --- EVERY traced ray, additive: the same tensors the physics uses
        pr.begin_blend_mode(pr.BlendMode.BLEND_ADDITIVE)
        a_hi=int(4+20*dim); cb=(120,88,30,a_hi); cd=(150,40,30,70)
        sund=_np.array([_np.cos(_np.radians(el))*_np.sin(az),
                        _np.cos(_np.radians(el))*_np.cos(az),
                        _np.sin(_np.radians(el))])
        for i in range(0,len(R["o1"]),2):
            o=R["o1"][i]
            pr.draw_line_3d(v3(o+2.2*sund),v3(o),(60,52,30,max(a_hi//2,2)))
            if not R["ok"][i]:
                continue
            pr.draw_line_3d(v3(o),v3(R["h2"][i]),cb)
            pr.draw_line_3d(v3(R["h2"][i]),v3(R["h3"][i]),cb)
            if R["ok4"][i]:
                pr.draw_line_3d(v3(R["h3"][i]),v3(R["h4"][i]),cb)
                pr.draw_line_3d(v3(R["h4"][i]),v3(R["h5"][i]),cb)
                if R["through"][i]:
                    pr.draw_line_3d(v3(R["h5"][i]),v3(R["h6"][i]),cb)
                    pr.draw_line_3d(v3(R["h6"][i]),v3(R["strike"][i]),cb)
                else:
                    pr.draw_line_3d(v3(R["h5"][i]),v3(R["h6"][i]),cd)
        pr.end_blend_mode()
        pr.end_mode_3d()
        self._draw_bread_strip(pr,1015,26)
        self._draw_disturbances(pr,1015,120)
        thru=R["through"].mean()
        hud=[f"sun el {el:.0f}  az {_np.degrees(az):+.0f}",
             f"pass {thru*100:.0f}%   EFL {self.efl:.1f} m  M {self.M_cass:.1f}",
             f"into pot {self.p_in[0]:5.0f} W",
             f"chase bore {CO.R_CHASE:.2f} m  duct {CO.R_DUCT_C:.2f} m"]
        for j,l in enumerate(hud):
            pr.draw_text(l,1015,300+26*j,17,(225,225,205,255))
        pr.draw_text("EXACT traced path: primary-M2-M3(el axis)-M4(az axis)"
                     "-chase-M5-native air inlet-pot wall.",
                     20,H-72,16,(150,200,160,255))
        pr.draw_text("Tip the dish: everything BELOW M4 stays fixed - that "
                     "invariance is the safety argument.",20,H-50,16,
                     (150,200,160,255))
        pr.draw_text("left-drag orbit  right-drag pan  wheel zoom  R reset",
                     20,H-26,16,(140,140,155,255))
        pr.end_drawing()
        return None

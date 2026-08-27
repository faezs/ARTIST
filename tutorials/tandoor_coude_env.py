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

from tandoor_polar_env import TandoorPolarEnv, R_DUCT
from tandoor_rl_env import _sim


class TandoorCoudeEnv(TandoorPolarEnv):
    # WIDE defocus authority. With 2-axis tracking on an 18.9 m2 dish the
    # plant is power-RICH, and the binding constraint flips from "can it
    # reach the band" to "can it avoid cooking past it" - the same lesson
    # the beam-down geometry sweep taught (a 7.1 kW config scored WORSE
    # than a 4.3 kW one). Level 0 is a genuine dump, not a trim.
    LEVEL_FRAC = [0.62, 0.74, 0.85, 0.93, 1.00, 1.04, 1.10]


    def __init__(self, *args, a_mem=2.45, fold_rho=0.95, n_folds=3,
                 **kwargs):
        self.a_mem = float(a_mem)
        self.fold_rho = float(fold_rho)
        self.n_folds = int(n_folds)
        super().__init__(*args, **kwargs)

    def _build_optics(self):
        super()._build_optics()
        cfg = self.cfg
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

    def _cosine(self, decl_deg):
        """2-axis tracking: no cosine loss at all. This is the whole
        reason to keep the beam-down over the polar retrofit (0.70)."""
        return 1.0

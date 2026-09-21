/-
# The beam-down: a hyperboloid where the coil was, the slot, the tunnel

The coil at F (Hashemi.lean, 27:30) gives way to a hyperboloidal secondary inside the coil's
envelope: its far focus is F, so every ray the dish sends toward F is turned toward its near
focus F₂ below, the return beam crosses the dish where the post does - through the slot from the
centre to the sun-side rim - and enters the tunnel down to the tandoor. The tri chain is the
dish, the hyperboloid, the tunnel.

* `beamAxis`: the beam-down axis in the dish's frame - the post's vertical (`rim_under_F_iff`:
  it crosses the dish along the slot) tilted by `β` toward the tube (the fixed roof needs F₂ on
  the azimuth axis, `focus_on_axis`);
* `hyperHit`: the ray meets the sheet near F of the hyperboloid with foci F and F₂ = F + L û
  and vertex `dm` from F: `a = L/2 - dm`, `c = L/2`, `b² = c² - a²`; the normal there;
* `hyperbola_reflects` (**the focal property**, in the meridional plane): the ray from the far
  focus reflects through the near one - a polynomial identity, certified;
* `traceBeam`: one ray from the dish's reflection to the secondary, the slot test at the dish
  crossing (through the slot, or clear of the panel, or blocked), the landing at F₂'s plane and
  the tunnel mouth's capture;
* `FitsReceiver`: the cap's bounding cylinder within the coil's volume;
* `hashemiEnvBeam`: the env's step with this receiver - the mount, 64 rays, the tunnel's
  throughput - and no oil: the parent's pot takes the beam.

What the trace will say, and this file does not hide: a secondary `dm` from F magnifies the
spot at F by `(c + a) / (c - a)`; inside the coil's volume that is about twenty, so the facets'
6 cm blur at F is over a metre at F₂ and the slot's width decides the chain.
-/
import RequestProject.HashemiTrace

namespace TandoorHashemi
open Classical

/-- the beam-down axis in the dish's frame: the post's vertical `(sin t, 0, -cos t)` tilted by
`β` toward the tube, along the slot -/
noncomputable def beamAxis (t β : ℝ) : Fin 3 → ℝ := ![Real.sin (t + β), 0, -Real.cos (t + β)]

/-- his coil's envelope: 12 cm across, 4 cm tall -/
noncomputable def coilVolume : ℝ := Real.pi * 0.06 ^ 2 * 0.04

/-- the hyperboloid's sag from its vertex to a rim of radius `rm`: `a √(1 + rm²/b²) - a` -/
noncomputable def capSag (a b2 rm : ℝ) : ℝ := a * Real.sqrt (1 + rm ^ 2 / b2) - a

/-- **the receiver's volume**: the cap's bounding cylinder within the coil's -/
def FitsReceiver (a b2 rm : ℝ) : Prop := Real.pi * rm ^ 2 * capSag a b2 rm ≤ coilVolume

/-- the secondary's magnification of the spot at F: `(c + a) / (c - a)` -/
noncomputable def secondaryMag (L dm : ℝ) : ℝ := (L - dm) / dm

/-! ## The focal property, in the meridional plane -/

/-- **a ray from the far focus reflects through the near focus**: on the hyperbola
`x²/a² - y²/b² = 1` with foci `(±c, 0)`, `c² = a² + b²`, at the point `(a cosh u, b sinh u)`,
the reflection of the direction from `(c, 0)` about the normal `(b cosh u, -a sinh u)` is
parallel to the direction to `(-c, 0)` - the 2D cross product vanishes. A polynomial identity
in `cosh u`, `sinh u`; the certificate is `linear_combination`'s -/
theorem hyperbola_reflects (a b c u : ℝ) (hc : c ^ 2 = a ^ 2 + b ^ 2) :
    let x := Real.cosh u
    let y := Real.sinh u
    let dx := a * x - c
    let dy := b * y
    let nx := b * x
    let ny := -(a * y)
    let nn := nx ^ 2 + ny ^ 2
    let dn := dx * nx + dy * ny
    let rx := nn * dx - 2 * dn * nx
    let ry := nn * dy - 2 * dn * ny
    rx * (0 - b * y) - ry * (-c - a * x) = 0 := by
  intro x y dx dy nx ny nn dn rx ry
  have hcosh : x ^ 2 = y ^ 2 + 1 := Real.cosh_sq u
  simp only [rx, ry, nn, dn, dx, dy, nx, ny]
  linear_combination (-2 * a * b * x * y * (x - y) * (x + y)) * hc + (2 * a * b * c ^ 2 * x * y) * hcosh

/-! ## The dish's reflection, kept -/

/-- the dish's reflected ray: the hit and the direction (`traceRayKErr`'s internals), and
whether the ray was on the panel -/
noncomputable def dishReflect (R f a w k σslope σspec cx cy ux uy dx dy dz e1 e2 s1 s2 : ℝ) : Fin 7 → ℝ :=
  let onPanel := |cx| ≤ a ∧ |cy| ≤ a ∧ |ux| ≤ w / 2 ∧ |uy| ≤ w / 2
  let O : Fin 3 → ℝ := ![cx + ux, cy + uy, 2 * f]
  let d : Fin 3 → ℝ := ![dx, dy, dz]
  let c := 1 / R
  let rr := Real.sqrt (max (cx ^ 2 + cy ^ 2) 1e-18)
  let zc := conicZ c k rr
  let g := conicSlope c k rr
  let nn := Real.sqrt (1 + g ^ 2)
  let n0 : Fin 3 → ℝ := ![-g * cx / rr / nn, -g * cy / rr / nn, 1 / nn]
  let n := tilt n0 (σslope * e1) (σslope * e2)
  let s := ((cx - O 0) * n0 0 + (cy - O 1) * n0 1 + (zc - O 2) * n0 2) / dot3 d n0
  let H : Fin 3 → ℝ := ![O 0 + s * d 0, O 1 + s * d 1, O 2 + s * d 2]
  let r := tilt (reflect3 n d) (σspec * s1) (σspec * s2)
  ![H 0, H 1, H 2, r 0, r 1, r 2, if onPanel then 1 else 0]

/-! ## The secondary -/

/-- the ray `O + s d` meets the hyperboloid's sheet near F: the far focus `F = (0, 0, f)`, the
axis `û = beamAxis t β`, the near focus `F + L û`, the vertex `dm` from F. Returns the hit, its
parameter `s` (negative: no hit ahead on the near sheet), its radius from the axis, and the unit
normal -/
noncomputable def hyperHit (f L dm t β : ℝ) (O d : Fin 3 → ℝ) : Fin 8 → ℝ :=
  let u := beamAxis t β
  let c := L / 2
  let a := c - dm
  let b2 := c ^ 2 - a ^ 2
  let M : Fin 3 → ℝ := ![u 0 * c, u 1 * c, f + u 2 * c]
  let w : Fin 3 → ℝ := ![O 0 - M 0, O 1 - M 1, O 2 - M 2]
  let wz := -(dot3 w u)
  let dz := -(dot3 d u)
  let q := 1 / a ^ 2 + 1 / b2
  let A := dz ^ 2 * q - dot3 d d / b2
  let B := 2 * wz * dz * q - 2 * dot3 w d / b2
  let C := wz ^ 2 * q - dot3 w w / b2 - 1
  let disc := Real.sqrt (max (B ^ 2 - 4 * A * C) 0)
  let s1 := (-B - disc) / (2 * A)
  let s2 := (-B + disc) / (2 * A)
  let ok1 := s1 > 1e-6 ∧ wz + s1 * dz > 0
  let ok2 := s2 > 1e-6 ∧ wz + s2 * dz > 0
  let s := if ok1 ∧ ok2 then min s1 s2 else if ok1 then s1 else if ok2 then s2 else -1
  let H : Fin 3 → ℝ := ![O 0 + s * d 0, O 1 + s * d 1, O 2 + s * d 2]
  let zp := wz + s * dz
  let radial : Fin 3 → ℝ := ![H 0 - M 0 + zp * u 0, H 1 - M 1 + zp * u 1, H 2 - M 2 + zp * u 2]
  let rho := Real.sqrt (max (dot3 radial radial) 1e-18)
  let ng : Fin 3 → ℝ := ![-(zp / a ^ 2) * u 0 - radial 0 / b2, -(zp / a ^ 2) * u 1 - radial 1 / b2,
    -(zp / a ^ 2) * u 2 - radial 2 / b2]
  let nn := Real.sqrt (max (dot3 ng ng) 1e-18)
  ![H 0, H 1, H 2, s, rho, ng 0 / nn, ng 1 / nn, ng 2 / nn]

/-- **one ray's beam-down**: from the dish's reflection `(H, r)` to the secondary (within its cap
of radius `rm`), the reflection, the crossing of the dish's surface - through the slot of width
`slotW` along the sun side (`x ≥ 0`), or clear of the square panel, or BLOCKED - and the landing
at F₂'s plane, captured within the tunnel mouth `rt`. Outputs: captured, hit the secondary,
passed the dish, the landing's distance from F₂, the crossing `x, y`, the radius on the
secondary, the fate (0 missed the secondary, 1 blocked by the dish, 2 missed the mouth, 3 in) -/
noncomputable def traceBeam (R f a k L dm rm rt slotW t β : ℝ) (H r : Fin 3 → ℝ) (onPanel : ℝ) : Fin 8 → ℝ :=
  let hy := hyperHit f L dm t β H r
  let s := hy 3
  let rho := hy 4
  let hitSec := onPanel > 0.5 ∧ s > 0 ∧ rho ≤ rm
  let Hs : Fin 3 → ℝ := ![hy 0, hy 1, hy 2]
  let n : Fin 3 → ℝ := ![hy 5, hy 6, hy 7]
  let rr := reflect3 n r
  -- the dish crossing, along the reflected ray
  let sd := conicHitS (1 / R) k Hs rr
  let Q : Fin 3 → ℝ := ![Hs 0 + sd * rr 0, Hs 1 + sd * rr 1, Hs 2 + sd * rr 2]
  let onDish := |Q 0| ≤ a ∧ |Q 1| ≤ a
  let inSlot := |Q 1| ≤ slotW / 2 ∧ Q 0 ≥ 0
  let passes := sd > 0 → (¬ onDish ∨ inSlot)
  -- the landing at F₂'s plane, perpendicular to the axis
  let u := beamAxis t β
  let F2 : Fin 3 → ℝ := ![u 0 * L, u 1 * L, f + u 2 * L]
  let s2 := ((F2 0 - Hs 0) * u 0 + (F2 1 - Hs 1) * u 1 + (F2 2 - Hs 2) * u 2) / dot3 rr u
  let Lp : Fin 3 → ℝ := ![Hs 0 + s2 * rr 0, Hs 1 + s2 * rr 1, Hs 2 + s2 * rr 2]
  let dist := Real.sqrt ((Lp 0 - F2 0) ^ 2 + (Lp 1 - F2 1) ^ 2 + (Lp 2 - F2 2) ^ 2)
  let inMouth := dist ≤ rt ∧ s2 > 0
  let captured := hitSec ∧ passes ∧ inMouth
  ![if captured then 1 else 0, if hitSec then 1 else 0, if hitSec ∧ passes then 1 else 0, dist, Q 0, Q 1, rho,
    if ¬ hitSec then 0 else if ¬ passes then 1 else if ¬ inMouth then 2 else 3]

set_option maxHeartbeats 2000000 in
theorem traceBeam_captured (R f a k L dm rm rt slotW t β : ℝ) (H r : Fin 3 → ℝ) (onPanel : ℝ) :
    traceBeam R f a k L dm rm rt slotW t β H r onPanel 0 = 0 ∨
    traceBeam R f a k L dm rm rt slotW t β H r onPanel 0 = 1 := by
  unfold traceBeam
  simp only [Matrix.cons_val_zero]
  split_ifs <;> simp

/-- the tunnel to the pot: a silvered light pipe of a few bounces (StatedLaws' chains) -/
noncomputable def tunnelThroughput : ℝ := 0.94 * 0.96

/-- **the env's step with the beam-down receiver**: the mount, then on the new pose 64 rays
through the dish and the secondary, their capture at the tunnel mouth, and the aperture the
parent's pot takes per unit DNI. Outputs `megaStep`'s 17, then `capture, hit_secondary,
passes_dish, per_dni, p_in, spot` (the mean landing distance of the rays that reached the
mouth's plane) and the eight observations of the new state. -/
noncomputable def hashemiEnvBeam (az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    R f a w rc k σslope σspec hsun soil L dm rm rt slotW β : ℝ)
    (dr : Fin 64 → Fin 10 → ℝ) : Fin 31 → ℝ :=
  -- the mount flies the SAME machine the rays fly: `a w rc` are this env's own optics inputs,
  -- and since 2026-09-20 they are `megaStep`'s mount dimensions too (Hashemi.lean §16)
  let s := megaStep az t slack ωm ωd dt elSun azSun dni rDrum W rcm Tmax rho Fdrive L10 rodLen
    a w rc
  let sd := sunInDish (s 0) (s 1) elSun azSun
  let cap := (∑ i : Fin 64,
    let ray := sampleRay a w hsun sd (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5)
    let dR := dishReflect R f a w k σslope σspec (ray 0) (ray 1) (ray 2) (ray 3) (ray 4) (ray 5) (ray 6)
      (dr i 6) (dr i 7) (dr i 8) (dr i 9)
    traceBeam R f a k L dm rm rt slotW (s 1) β ![dR 0, dR 1, dR 2] ![dR 3, dR 4, dR 5] (dR 6) 0) / 64
  let hit := (∑ i : Fin 64,
    let ray := sampleRay a w hsun sd (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5)
    let dR := dishReflect R f a w k σslope σspec (ray 0) (ray 1) (ray 2) (ray 3) (ray 4) (ray 5) (ray 6)
      (dr i 6) (dr i 7) (dr i 8) (dr i 9)
    traceBeam R f a k L dm rm rt slotW (s 1) β ![dR 0, dR 1, dR 2] ![dR 3, dR 4, dR 5] (dR 6) 1) / 64
  let pass := (∑ i : Fin 64,
    let ray := sampleRay a w hsun sd (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5)
    let dR := dishReflect R f a w k σslope σspec (ray 0) (ray 1) (ray 2) (ray 3) (ray 4) (ray 5) (ray 6)
      (dr i 6) (dr i 7) (dr i 8) (dr i 9)
    traceBeam R f a k L dm rm rt slotW (s 1) β ![dR 0, dR 1, dR 2] ![dR 3, dR 4, dR 5] (dR 6) 2) / 64
  let spot := (∑ i : Fin 64,
    let ray := sampleRay a w hsun sd (dr i 0) (dr i 1) (dr i 2) (dr i 3) (dr i 4) (dr i 5)
    let dR := dishReflect R f a w k σslope σspec (ray 0) (ray 1) (ray 2) (ray 3) (ray 4) (ray 5) (ray 6)
      (dr i 6) (dr i 7) (dr i 8) (dr i 9)
    let tb := traceBeam R f a k L dm rm rt slotW (s 1) β ![dR 0, dR 1, dR 2] ![dR 3, dR 4, dR 5] (dR 6)
    tb 2 * min (tb 3) 2) / 64
  let per := (2 * a) ^ 2 * rho * cap * tunnelThroughput
  let Pin := per * dni * soil
  let eAz := (azSun - s 0) - 2 * Real.pi * ((⌊((azSun - s 0) + Real.pi) / (2 * Real.pi)⌋ : ℤ) : ℝ)
  ![s 0, s 1, s 2, s 3, s 4, s 5, s 6, s 7, s 8, s 9, s 10, s 11, s 12, s 13, s 14, s 15, s 16,
    cap, hit, pass, per, Pin, spot,
    eAz, (Real.pi / 2 - s 1) - elSun, s 1, s 6, s 7, 0, s 15, s 16]

def beamNames : Array String := #[
  "az_next", "t_next", "slack_next", "wire_len", "t_dead", "stalled", "taut", "wire_holds", "arm",
  "swing_rate", "az_rate", "pointing_err", "el_dish", "sun_reachable", "lost_sun", "sun_reachable_s", "lost_sun_s",
  "capture", "hit_secondary", "passes_dish", "per_dni", "p_in", "spot",
  "obs_e_az", "obs_e_el", "obs_swing", "obs_taut", "obs_holds", "obs_oil", "obs_reach_s", "obs_lost_s"]

theorem beamNames_size : beamNames.size = 31 := by rfl

end TandoorHashemi

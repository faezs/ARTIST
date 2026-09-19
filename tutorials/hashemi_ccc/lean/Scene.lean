/-
# A scene, generically

A renderer is not a model.  Everything a picture of a machine shows is already in the machine's
specification: the points, the frames those points are written in, the rays a trace produces.  So
a scene is not a definition to be *written*; it is a **functor to drawings** applied to definitions
that already exist — objects (a definition's output, in its own frame) go to vertices, and the
frame morphisms that relate one definition's coordinates to another's go to the composition that
places those vertices in the world frame.  Writing a "scene definition" with coordinates in it
would be writing the geometry a second time, and a second copy can disagree with the first.

This file is the vocabulary, and it knows nothing about any particular machine:

* `Shape` — what may be drawn.  A leaf is either a **point** (a definition whose output is three
  reals, or two that a frame lifts to three) or a **number** (one column of a definition's output,
  used for a fate or a flag).  A `seg` is the *pair* of two point leaves: a segment between two
  named points of a specification is not a new definition, it is those two definitions drawn with
  a line between them.  A `ray` is an origin, a hit, a landing and a fate — the four things a
  trace returns.
* `Frame` — the name of the definition that embeds a leaf's own coordinates into the world frame.
  `none` means the leaf is already in the world frame.  A frame is a *morphism of the
  specification*, never a formula written here; the printer composes it with the leaf **in the
  graph**, so the composite is hash-consed with everything else.
* `Entry`, `Scene` — the data a particular machine's instance supplies: a label, a shape, a
  colour.  No arithmetic.

`CccScene.lean` is the printer that turns a `Scene` into one compiled `Ccc.Fun` and the C and
NumPy twins of it.  `Scene.bound` below is the only theorem this file needs: whatever the frames
are, if each is bounded in its argument then every vertex of every scene is bounded by the
inputs' bound — the picture cannot run away from the machine.
-/
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Scene

/-! ## The vocabulary -/

/-- what a scene entry draws.  The renderer's switch; the printer only counts doubles. -/
inductive Kind where
  /-- a single vertex -/
  | point
  /-- a line between two vertices -/
  | segment
  /-- a traced ray: origin, hit, landing, then its fate code -/
  | ray
  /-- a frame's three axes drawn from an origin -/
  | axes
  /-- a bare number: a fate, a flag, a radius the HUD shows -/
  | scalar
  deriving Repr, BEq, Inhabited

def Kind.code : Kind → Nat
  | .point => 0 | .segment => 1 | .ray => 2 | .axes => 3 | .scalar => 4

/-- a leaf of a shape: one application of one definition of the specification, in its own frame.

`defn` is the definition's short name; `frame` the short name of the definition that carries its
coordinates to the world frame (`none`: it is already there).  `col`, on a `num` leaf, picks one
column of the definition's output vector. -/
inductive Leaf where
  /-- three reals: a point (or two reals a frame lifts to three).  `bind` renames the
  definition's (or its frame's) binders onto scene inputs, so that the same definition may be
  drawn twice at two arguments — the left and the right post are `postTop` at `sg = ±1`, which is
  a renaming, not a second definition. -/
  | pt (defn : String) (frame : Option String) (bind : List (String × String) := [])
  /-- one real: column `col` of a definition's output (a fate, a flag, a radius) -/
  | num (defn : String) (col : Nat) (bind : List (String × String) := [])
  deriving Repr, Inhabited

/-- the renaming a leaf applies to its definition's binders -/
def Leaf.bind : Leaf → List (String × String)
  | .pt _ _ b => b
  | .num _ _ b => b

/-- a binder name as this leaf names it -/
def Leaf.rename (l : Leaf) (nm : String) : String :=
  ((l.bind.find? (·.1 == nm)).map (·.2)).getD nm

/-- how many doubles a leaf writes -/
def Leaf.width : Leaf → Nat
  | .pt .. => 3
  | .num .. => 1

/-- a drawable.  Every constructor is built out of leaves: nothing here introduces coordinates. -/
inductive Shape where
  | one (l : Leaf)
  /-- a segment between two points of the specification — the PAIR of their leaves -/
  | seg (a b : Leaf)
  /-- a traced ray: where it started, where it struck, where it landed, and its fate -/
  | rayOf (origin hit land fate : Leaf)
  /-- an origin and the three axes of a frame drawn from it -/
  | axesOf (origin x y z : Leaf)
  deriving Repr, Inhabited

def Shape.leaves : Shape → List Leaf
  | .one l => [l]
  | .seg a b => [a, b]
  | .rayOf o h l f => [o, h, l, f]
  | .axesOf o x y z => [o, x, y, z]

def Shape.width (s : Shape) : Nat := (s.leaves.map Leaf.width).foldl (· + ·) 0

def Shape.kind : Shape → Kind
  | .one (.num ..) => .scalar
  | .one _ => .point
  | .seg _ _ => .segment
  | .rayOf .. => .ray
  | .axesOf .. => .axes

/-- one drawable of a scene: a label for the manifest, what to draw, and a colour index. -/
structure Entry where
  label : String
  shape : Shape
  colour : Nat
  deriving Repr, Inhabited

/-- a scene is a list of entries.  That is all a machine's instance supplies. -/
abbrev Scene := List Entry

def Scene.width (s : Scene) : Nat := (s.map (fun e => e.shape.width)).foldl (· + ·) 0

/-- the offset of each entry in the flat vertex buffer -/
def Scene.offsets (s : Scene) : List Nat :=
  (s.foldl (fun (acc, off) e => (acc ++ [off], off + e.shape.width)) ([], 0)).1

/-! ## The one theorem the vocabulary owes

A frame is a map of the world frame's coordinates; a scene's vertices are frames applied to
definitions' outputs.  If every frame is affine-bounded in its argument — which every rigid
embedding is, a rotation being an isometry — then every vertex of every scene is bounded by the
bound on the leaves' own coordinates.  This is stated over `Scene`, about an arbitrary frame: it
is the picture's boundedness, not any one machine's. -/

/-- a frame is **bounded with gain `K` and offset `c`** when it moves no point further than
`K` times the size of that point's own coordinates, plus `c` (its origin). -/
def BoundedFrame (F : (Fin 3 → ℝ) → Fin 3 → ℝ) (K c : ℝ) : Prop :=
  ∀ p : Fin 3 → ℝ, ∀ i : Fin 3, |F p i| ≤ K * (|p 0| + |p 1| + |p 2|) + c

/-- **every vertex of a scene is bounded by its inputs' bound**: a leaf whose own coordinates are
at most `B` is drawn, through a frame of gain `K` and offset `c`, no further out than
`3 K B + c`. -/
theorem vertex_bound {F : (Fin 3 → ℝ) → Fin 3 → ℝ} {K c B : ℝ}
    (hK : 0 ≤ K) (hF : BoundedFrame F K c)
    (p : Fin 3 → ℝ) (hp : ∀ j : Fin 3, |p j| ≤ B) (i : Fin 3) :
    |F p i| ≤ 3 * K * B + c := by
  have h := hF p i
  have h0 := hp 0
  have h1 := hp 1
  have h2 := hp 2
  have hsum : |p 0| + |p 1| + |p 2| ≤ 3 * B := by linarith
  have := mul_le_mul_of_nonneg_left hsum hK
  linarith

/-- the identity frame is bounded with gain 1 and no offset: a leaf already in the world frame
is drawn where it is. -/
theorem boundedFrame_id : BoundedFrame (fun p => p) 1 0 := by
  intro p i
  have h0 := abs_nonneg (p 0)
  have h1 := abs_nonneg (p 1)
  have h2 := abs_nonneg (p 2)
  fin_cases i <;> simp <;> linarith

/-- **a rigid frame is bounded**: an origin `V` and three axes of length at most one place a
point no further than `|V| + (|p₀| + |p₁| + |p₂|)`.  Every frame a specification writes as
"an origin plus a linear combination of unit axes" is of this shape, so the bound above applies
to it with `K = 1` and `c = ‖V‖₁`. -/
theorem boundedFrame_rigid (V : Fin 3 → ℝ) (A : Fin 3 → Fin 3 → ℝ)
    (hA : ∀ j i : Fin 3, |A j i| ≤ 1) :
    BoundedFrame (fun p i => V i + (p 0 * A 0 i + p 1 * A 1 i + p 2 * A 2 i))
      1 (|V 0| + |V 1| + |V 2|) := by
  intro p i
  have hv : |V i| ≤ |V 0| + |V 1| + |V 2| := by
    have h0 := abs_nonneg (V 0); have h1 := abs_nonneg (V 1); have h2 := abs_nonneg (V 2)
    fin_cases i
    · show |V 0| ≤ |V 0| + |V 1| + |V 2|; linarith
    · show |V 1| ≤ |V 0| + |V 1| + |V 2|; linarith
    · show |V 2| ≤ |V 0| + |V 1| + |V 2|; linarith
  have key : ∀ j : Fin 3, |p j * A j i| ≤ |p j| := by
    intro j
    rw [abs_mul]
    calc |p j| * |A j i| ≤ |p j| * 1 :=
          mul_le_mul_of_nonneg_left (hA j i) (abs_nonneg _)
      _ = |p j| := mul_one _
  have t0 := key 0
  have t1 := key 1
  have t2 := key 2
  have hsplit :
      |V i + (p 0 * A 0 i + p 1 * A 1 i + p 2 * A 2 i)|
        ≤ |V i| + (|p 0 * A 0 i| + |p 1 * A 1 i| + |p 2 * A 2 i|) := by
    calc |V i + (p 0 * A 0 i + p 1 * A 1 i + p 2 * A 2 i)|
        ≤ |V i| + |p 0 * A 0 i + p 1 * A 1 i + p 2 * A 2 i| := abs_add_le _ _
      _ ≤ |V i| + (|p 0 * A 0 i + p 1 * A 1 i| + |p 2 * A 2 i|) := by
            have := abs_add_le (p 0 * A 0 i + p 1 * A 1 i) (p 2 * A 2 i); linarith
      _ ≤ |V i| + (|p 0 * A 0 i| + |p 1 * A 1 i| + |p 2 * A 2 i|) := by
            have := abs_add_le (p 0 * A 0 i) (p 1 * A 1 i); linarith
  simp only [one_mul]
  linarith

end Scene

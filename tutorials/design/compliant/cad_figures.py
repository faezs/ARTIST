"""3-D solids of the designed compliant parts, built parametrically with
cadquery from the memos' dimensions, exported as isometric SVG line
renders: the wire-EDM cross-axis pivot block of the fold, the dish's
leaf-pivot pitch stage, an M5 facet on three bipod feet with their
parallel-motion carriages, the bistable-arch wind trip, and the fold
assembly (finned mirror on two pivots in a yoke under the hood)."""
import cadquery as cq, os, sys
OUT = sys.argv[1] if len(sys.argv) > 1 else "figures"; os.makedirs(OUT, exist_ok=True)
def svg(shape, name, d=(1, -1.2, 0.8), w=560, h=400):
    p = os.path.join(OUT, name)
    cq.exporters.export(shape, p, opt={"projectionDir": d, "showHidden": False, "strokeWidth": 0.6, "width": w, "height": h, "marginLeft": 10, "marginTop": 10})
    print("wrote", p)

# 1. fold's cross-axis pivot: 90 x 90 x 40 Ti block, two 0.6 mm blades crossing at 90 deg, cut by wire-EDM slots
B, T, L, t = 90.0, 40.0, 60.0, 0.6
blk = cq.Workplane("XY").box(B, T, B)                         # X across, Y = blade width direction (40), Z up
# remove the interior leaving two crossed blades between a ground foot (bottom 12 mm) and a moving head (top 12 mm)
core = cq.Workplane("XY").box(B - 12, T + 2, B - 24)          # interior between foot and head
blade1 = cq.Workplane("XY").box(L*1.02, T + 4, t).rotate((0, 0, 0), (0, 1, 0), 45)
blade2 = cq.Workplane("XY").box(L*1.02, T + 4, t).rotate((0, 0, 0), (0, 1, 0), -45)
slots = core.cut(blade1).cut(blade2)
pivot = blk.cut(slots)
# split the head from the foot at the sides so only the blades connect them
for sx in (-1, 1):
    pivot = pivot.cut(cq.Workplane("XY").box(2, T + 4, B - 24).translate((sx*(B/2 - 7), 0, 0)))
svg(pivot, "cad_fold_cross_axis_pivot.svg")

# 2. dish pitch stage: two leaf pivots (leaves 300 x 2 x 150) on a yoke, 1.6 m apart
def leaf_pivot(L=300, t=2.0, w=150):
    foot = cq.Workplane("XY").box(260, w, 30).translate((0, 0, -15))
    head = cq.Workplane("XY").box(260, w, 30).translate((0, 0, L/1.414 + 15))
    a = cq.Workplane("XY").box(L, w, t).rotate((0, 0, 0), (0, 1, 0), 45).translate((0, 0, L/2.828))
    b = cq.Workplane("XY").box(L, w, t).rotate((0, 0, 0), (0, 1, 0), -45).translate((0, 0, L/2.828))
    return foot.union(head).union(a).union(b)
yoke = cq.Workplane("XY").box(1800, 120, 80).translate((0, 0, 300/1.414 + 70))
stage = yoke.union(leaf_pivot().translate((-800, 0, 0))).union(leaf_pivot().translate((800, 0, 0)))
rim_stub = cq.Workplane("XY").box(2000, 60, 60).translate((0, 0, 300/1.414 + 140))
svg(stage.union(rim_stub), "cad_dish_pitch_stage.svg", d=(1, -1.5, 0.7), w=700)

# 3. M5 facet (0.30 m, 1.5 mm) with Y-rib on three bipod feet + parallel-motion carriages
facet = cq.Workplane("XY").box(300, 300, 1.5).translate((0, 0, 60))
rib = cq.Workplane("XY").box(280, 12, 20).translate((0, 0, 70)).union(cq.Workplane("XY").box(12, 280, 20).translate((0, 0, 70)))
asm = facet.union(rib)
for (fx, fy) in ((-110, -110), (110, -110), (0, 120)):
    car = cq.Workplane("XY").box(40, 40, 8).translate((fx, fy, 4))                 # carriage platform
    for sx in (-14, 14):                                                            # two 0.5 mm blades
        asm = asm.union(cq.Workplane("XY").box(12, 0.5, 40).translate((fx + sx, fy - 20, 28)))
    for sgn in (-1, 1):                                                             # bipod strips in a V up to the facet
        asm = asm.union(cq.Workplane("XY").box(2.5, 0.5, 34).rotate((0, 0, 0), (0, 1, 0), sgn*25).translate((fx + sgn*8, fy, 42)))
    asm = asm.union(car).union(cq.Workplane("XY").box(20, 20, 8).translate((fx, fy, 52)))   # pad under the facet
    asm = asm.union(cq.Workplane("XY").circle(3).extrude(22).translate((fx, fy + 14, 8)))  # M6 adjuster
frame = cq.Workplane("XY").box(380, 380, 10).translate((0, 0, -5))
svg(asm.union(frame), "cad_m5_facet_feet.svg", d=(1, -1.3, 0.9), w=640)

# 4. bistable cosine arch wind trip on its drag plate
import math
pts = [(x, 12*(1 - math.cos(2*math.pi*x/200))/2) for x in range(0, 201, 5)]
arch = cq.Workplane("XZ").spline(pts).offset2D(0.4).extrude(25)
posts = cq.Workplane("XY").box(12, 25, 14).translate((0, 12, 0)).union(cq.Workplane("XY").box(12, 25, 14).translate((200, 12, 0)))
plate = cq.Workplane("XY").box(500, 500, 3).translate((100, 12, 60))
svg(arch.union(posts).union(plate), "cad_dish_wind_trip.svg", d=(1, -1.2, 0.6), w=600)

# 5. fold assembly: finned mirror plate (360 x 440 x 12) face-down on two pivot blocks in a two-arm yoke under a hood ring
mirror = cq.Workplane("XY").ellipse(220, 180).extrude(12)
fins = mirror
for k in range(-8, 9):
    fins = fins.union(cq.Workplane("XY").box(2, 300, 25).translate((k*20, 0, 12 + 12.5)))
fins = fins.rotate((0, 0, 0), (0, 1, 0), 0)
pivots = cq.Workplane("XY").box(90, 40, 90).translate((0, 200, 12 + 45)).union(cq.Workplane("XY").box(90, 40, 90).translate((0, -200, 12 + 45)))
arms = cq.Workplane("XY").box(60, 40, 600).translate((0, 260, 12 - 250)).union(cq.Workplane("XY").box(60, 40, 600).translate((0, -260, 12 - 250)))
hood = cq.Workplane("XY").circle(330).circle(290).extrude(60).translate((0, 0, 12 + 90))
fold_asm = fins.union(pivots).union(arms).union(hood).rotate((0, 0, 0), (0, 1, 0), 25)
svg(fold_asm, "cad_fold_assembly.svg", d=(1, -1.2, 0.5), w=620)
print("done")

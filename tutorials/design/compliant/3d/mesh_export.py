"""cadquery assemblies -> compact JSON meshes for the in-page three.js viewer.
Usage: from mesh_export import Scene; sc = Scene(); sc.add(shape, "name", "#hex", tol=1.0); sc.write("model.json")
Each part: name, colour, vertices (mm, rounded), triangle indices. Keep tolerance coarse for big parts."""
import json, os
class Scene:
    def __init__(self): self.parts = []
    def add(self, shape, name, color="#9aa5b1", tol=1.0, ang=0.3):
        solids = shape.vals() if hasattr(shape, "vals") else [shape]
        for k, sol in enumerate(solids):
            verts, tris = sol.tessellate(tol, ang)
            self.parts.append(dict(name=name if k == 0 else f"{name}#{k}", color=color,
                                   v=[[round(v.x, 1), round(v.y, 1), round(v.z, 1)] for v in verts], f=tris))
        return self
    def write(self, path):
        json.dump(dict(parts=self.parts), open(path, "w"), separators=(",", ":")); print("wrote", path, os.path.getsize(path)//1024, "KB", sum(len(p["f"]) for p in self.parts), "tris")

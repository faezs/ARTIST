import sys, numpy as np, matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
d = sys.argv[1]; dx = float(sys.argv[2]); U = float(sys.argv[3]) if len(sys.argv) > 3 else 12.0
raw = open(f"{d}/slice_u.bin", "rb").read(); Nx, Nz = np.frombuffer(raw[:8], np.uint32); A = np.frombuffer(raw[8:], np.float32).reshape(Nz, Nx, 4)
sp = np.hypot(A[..., 0], A[..., 2]); solid = A[..., 3] > 0
fig, ax = plt.subplots(figsize=(11, 5.5)); ext = [0, Nx*dx, 0, Nz*dx]
im = ax.imshow(np.where(solid, np.nan, sp), origin="lower", extent=ext, cmap="viridis", vmin=0, vmax=1.4*U, aspect="equal")
ax.contour(np.linspace(0, Nx*dx, Nx), np.linspace(0, Nz*dx, Nz), solid.astype(float), levels=[0.5], colors="w", linewidths=1.5)
st = 6; X, Z = np.meshgrid(np.arange(0, Nx, st)*dx, np.arange(0, Nz, st)*dx); ax.quiver(X, Z, A[::st, ::st, 0], A[::st, ::st, 2], color="w", alpha=0.5, scale=U*25, width=0.0015)
plt.colorbar(im, ax=ax, label="|u| in the mid-plane, m/s"); ax.set_xlabel("x, m (the wind blows +x, from the south)"); ax.set_ylabel("z, m")
ax.set_title(f"the dish in the wind: LES mid-plane, dx {dx} m, U {U} m/s (the bowl faces the sun: -x, up)")
plt.tight_layout(); plt.savefig(f"{d}/slice.png", dpi=110); print("wrote", f"{d}/slice.png", "peak |u|", sp[~solid].max().round(1))

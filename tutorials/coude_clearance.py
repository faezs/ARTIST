"""Does the dish clear its own roof?

Z_M4 = Z_ROOF + 0.55 puts the elevation axis 0.55 m above the roof deck,
but the dish tips about that axis with radius a_mem. If the rim sweeps
below Z_ROOF the mount is fiction - and Z_M4 is the biggest single term
in the unfolded path, so it is worth knowing the true minimum.
"""
import pathlib, sys
import numpy as np
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import tandoor_coude_optics as CO


def rim_min_z(a_mem, sag_rim, z_m4, el_deg, az_deg=0.0, z_m3=-0.45):
    M = CO.rot([0, 0, 1], np.radians(az_deg)) @ \
        CO.rot([1, 0, 0], np.radians(90.0 - el_deg))
    axis_w = M @ np.array([1.0, 0.0, 0.0])
    p_m4 = np.array([CO.X_CHASE, 0.0, z_m4])
    p_m3 = p_m4 - CO.D_EL * axis_w
    pivot = p_m3 - M @ np.array([0.0, 0.0, z_m3])
    th = np.linspace(0, 2 * np.pi, 181)
    rim = np.stack([a_mem * np.cos(th), a_mem * np.sin(th),
                    np.full_like(th, sag_rim)], 1)
    return ((M @ rim.T).T + pivot)[:, 2].min()


def min_z_m4(a_mem, sag_rim, el_lo=20.0, clear=0.25):
    """Lowest el/az crossing that keeps the rim `clear` above the roof
    at every elevation and azimuth we ever command."""
    lo, hi = CO.Z_ROOF, CO.Z_ROOF + 6.0
    for _ in range(40):
        mid = 0.5 * (lo + hi)
        worst = min(rim_min_z(a_mem, sag_rim, mid, el, az)
                    for el in np.arange(el_lo, 90.1, 5.0)
                    for az in (0.0, 90.0, 180.0))
        if worst < CO.Z_ROOF + clear:
            lo = mid
        else:
            hi = mid
    return 0.5 * (lo + hi)


if __name__ == "__main__":
    print(f"  roof deck Z_ROOF = {CO.Z_ROOF} m, current Z_M4 = {CO.Z_M4} m\n")
    print(f"{'a_mem':>7}{'el':>6}{'rim min z':>11}{'vs roof':>10}")
    for a_mem, sag in ((2.10, 0.21), (1.75, 0.15)):
        for el in (20., 35., 55., 75., 88.):
            z = rim_min_z(a_mem, sag, CO.Z_M4, el)
            flag = "  <-- THROUGH THE ROOF" if z < CO.Z_ROOF else ""
            print(f"{a_mem:>7.2f}{el:>6.0f}{z:>11.2f}"
                  f"{z-CO.Z_ROOF:>+10.2f}{flag}")
        need = min_z_m4(a_mem, sag)
        print(f"   -> a={a_mem}: Z_M4 must be >= {need:.2f} m "
              f"(is {CO.Z_M4:.2f}); chase leg {need-CO.Z_DUCT:.2f} m\n")

"""A synthetic turbulence box for the LES inlet. Isotropic von Karman (the Mann model at Gamma = 0), divergence-free, built in
Fourier space from Phi_ij = E(k)/(4 pi k^4)(k^2 d_ij - k_i k_j), E ~ k^4/(1 + k^2 L^2)^(17/6).

WHAT A 12 m BOX CAN CARRY. The boundary layer's integral scale (50 m) does not fit a 12 m cross-section: generating with
L = 50 m starves the streamwise component (the large eddies that carry it need transverse wavelengths the box lacks). So
the box carries the SUB-BOX part of the spectrum only - L_gen set by the cross-section, the rms set to the von Karman
variance above the box's cut-off frequency f_c = U/L_box - and the eddies larger than the box, which are coherent over the
dish, stay in the envs' point-gust model as slow changes of speed and direction. The split is exact in variance."""
import sys, numpy as np
def karman_variance_above(fc, U, L=50.0, Iu=0.25):
    f = np.logspace(-4, 3, 40000); x = f*L/U; S = (4*L/U)/(1 + 70.8*x*x)**(5/6)
    return (Iu*U)**2*np.trapezoid(S[f > fc], f[f > fc])/np.trapezoid(S, f)
def karman_box(nx, ny, nz, dx, L_gen, sigma, seed=0):
    rng = np.random.default_rng(seed)
    kx = 2*np.pi*np.fft.fftfreq(nx, dx); ky = 2*np.pi*np.fft.fftfreq(ny, dx); kz = 2*np.pi*np.fft.rfftfreq(nz, dx)
    KX, KY, KZ = np.meshgrid(kx, ky, kz, indexing="ij"); k2 = KX**2 + KY**2 + KZ**2; k = np.sqrt(k2); k2s = np.where(k2 > 0, k2, 1.0)
    E = k**4/(1 + k2*L_gen*L_gen)**(17/6); amp = np.sqrt(E/(4*np.pi*k2s)); amp[k2 == 0] = 0.0
    # |u_i(k)|^2 = amp^2 (1 - k_i^2/k^2) = E/(4 pi k^2)(1 - k_i^2/k^2) = E/(4 pi k^4)(k^2 - k_i^2) = Phi_ii: the projection below supplies the bracket
    W = [rng.normal(size=k.shape) + 1j*rng.normal(size=k.shape) for _ in range(3)]
    K = [KX, KY, KZ]; U = []
    for i in range(3):
        s = W[i] - K[i]*sum(K[j]*W[j] for j in range(3))/k2s; U.append(amp*s)
    u = [np.fft.irfftn(Ui, s=(nx, ny, nz), axes=(0, 1, 2)) for Ui in U]
    rms = np.sqrt(np.mean(sum(ui**2 for ui in u))/3); return [ui*sigma/rms for ui in u]
if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "."
    U, Iu, L_abl = 12.0, 0.25, 50.0
    L_box = 12.0; dx = 0.24; nx, ny, nz = 512, 50, 50                              # 123 m swept (10 s at 12 m/s), 12 x 12 m section
    fc = U/L_box; sig_sub = np.sqrt(karman_variance_above(fc, U, L_abl, Iu))
    L_gen = L_box/4.0
    u = karman_box(nx, ny, nz, dx, L_gen, sig_sub, seed=1); ux, uy, uz = u
    print(f"the sub-box turbulence: cut-off f_c = U/L_box = {fc:.2f} Hz; von Karman variance above it {100*sig_sub**2/(Iu*U)**2:.0f} % of the total -> rms {sig_sub:.2f} m/s (the point gust's {Iu*U:.2f})")
    print(f"box {nx*dx:.0f} x {ny*dx:.0f} x {nz*dx:.0f} m at {dx} m, L_gen {L_gen:.0f} m: rms {ux.std():.2f} {uy.std():.2f} {uz.std():.2f} m/s")
    a = ux - ux.mean(); ac = np.array([np.mean(a[:nx-s]*a[s:]) for s in range(0, nx//4)]); ac /= ac[0]; L_int = dx*np.trapezoid(ac[:np.argmax(ac < 0) or len(ac)])
    d = int(4.2/dx); c = np.mean(a[:, :, :nz-d]*a[:, :, d:])/np.mean(a*a)
    print(f"streamwise integral length {L_int:.1f} m; correlation of u across the dish's 4.2 m {c:.2f}")
    f = np.fft.rfftfreq(nx, dx/U); P = np.mean(np.abs(np.fft.rfft(a, axis=0))**2, axis=(1, 2)); P *= ux.var()/np.trapezoid(P[1:], f[1:])
    print("   f Hz   f S/sigma_sub^2 (box)   von Karman f S/sigma^2 x (sigma/sigma_sub)^2 above f_c")
    for fq in (1.0, 2.0, 4.0, 8.0):
        i = np.argmin(np.abs(f - fq)); x = fq*L_abl/U; vk = 4*x/(1+70.8*x*x)**(5/6)*(Iu*U)**2/sig_sub**2
        print(f"   {fq:4.1f}   {f[i]*P[i]/ux.var():8.4f}                {vk:8.4f}")
    B = np.stack(u).astype(np.float32)
    with open(f"{out}/karman_box.bin", "wb") as fh:                                  # int32 nx ny nz, float32 dx, then u_x u_y u_z each [nx][ny][nz] C-order
        fh.write(np.array([nx, ny, nz], np.int32).tobytes()); fh.write(np.array([dx], np.float32).tobytes()); fh.write(B.tobytes())
    print("->", f"{out}/karman_box.bin", B.nbytes/1e6, "MB")

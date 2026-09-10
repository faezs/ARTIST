"""A synthetic turbulence box for the LES inlet: isotropic von Karman (the Mann model at Gamma = 0), divergence-free, built
in Fourier space from the spectral tensor Phi_ij = E(k)/(4 pi k^4) (k^2 d_ij - k_i k_j) with E(k) ~ k^4/(1 + k^2 L^2)^(17/6),
scaled to the target rms. The box's x is swept through the inlet plane at U (Taylor's hypothesis)."""
import sys, numpy as np
def karman_box(nx, ny, nz, dx, L, sigma, seed=0):
    rng = np.random.default_rng(seed)
    kx = 2*np.pi*np.fft.fftfreq(nx, dx); ky = 2*np.pi*np.fft.fftfreq(ny, dx); kz = 2*np.pi*np.fft.rfftfreq(nz, dx)
    KX, KY, KZ = np.meshgrid(kx, ky, kz, indexing="ij"); k2 = KX**2 + KY**2 + KZ**2; k = np.sqrt(k2); k2s = np.where(k2 > 0, k2, 1.0)
    E = k**4/(1 + k2*L*L)**(17/6)                                          # von Karman energy spectrum shape
    amp = np.sqrt(E/(4*np.pi*k2s*k2s))                                    # sqrt of Phi's scalar part
    W = [rng.normal(size=k.shape) + 1j*rng.normal(size=k.shape) for _ in range(3)]   # white noise in k-space
    # project onto the divergence-free space: u_i = (d_ij - k_i k_j/k^2) w_j, times amp
    K = [KX, KY, KZ]; U = []
    for i in range(3):
        s = W[i] - K[i]*sum(K[j]*W[j] for j in range(3))/k2s; U.append(amp*s)
    u = [np.fft.irfftn(Ui, s=(nx, ny, nz)) for Ui in U]
    rms = np.sqrt(np.mean(sum(ui**2 for ui in u))/3); u = [ui*sigma/rms for ui in u]
    return u
if __name__ == "__main__":
    nx, ny, nz, dx, L, U, Iu = 512, 64, 64, 0.24, 50.0, 12.0, 0.25
    u = karman_box(nx, ny, nz, dx, L, Iu*U, seed=1)
    ux, uy, uz = u
    print(f"box {nx*dx:.0f} x {ny*dx:.0f} x {nz*dx:.0f} m at {dx} m: u rms {ux.std():.2f} {uy.std():.2f} {uz.std():.2f} m/s (target {Iu*U:.2f})")
    # streamwise integral length from the autocorrelation along x
    a = ux - ux.mean(); ac = np.array([np.mean(a[:nx-s]*a[s:]) for s in range(0, nx//2)]); ac /= ac[0]; L_int = dx*np.trapezoid(ac[:np.argmax(ac < 0.0) or len(ac)])
    print(f"streamwise integral length {L_int:.1f} m (von Karman L {L}: the integral scale is ~0.75 L in a finite box)")
    # the coherence across the inlet plane over the dish's 4.2 m: correlation of u at points 4.2 m apart
    d = int(4.2/dx); c = np.mean(a[:, :, :nz-d]*a[:, :, d:])/np.mean(a*a); print(f"correlation of u across 4.2 m: {c:.2f}")
    # spectrum check: f S(f)/sigma^2 vs von Karman at U
    f = np.fft.rfftfreq(nx, dx/U); P = np.mean(np.abs(np.fft.rfft(a, axis=0))**2, axis=(1, 2)); P *= (ux.var()/np.trapezoid(P[1:], f[1:]))
    for fq in (0.05, 0.2, 1.0, 4.0):
        i = np.argmin(np.abs(f - fq)); x = fq*L/U; print(f"   f {fq:4.2f} Hz: f S/sigma2 box {f[i]*P[i]/ux.var():.4f}, von Karman {4*x/(1+70.8*x*x)**(5/6):.4f}")
    np.save(f"{sys.argv[1] if len(sys.argv) > 1 else '.'}/karman_box_test.npy", np.stack(u).astype(np.float32))

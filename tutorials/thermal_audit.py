"""Is the surface-based thermal model too optimistic? Measured.

Current model per node: 1.5 cm clay liner (rho*c = 1.67 MJ/m3K) with a
STEADY drain U = 0.7 W/m2K to ambient. Real charging drives transient
conduction into thick clay: penetration depth sqrt(alpha*t) ~ 12 cm
over a day, and the early-morning conduction flux goes as 1/sqrt(t) -
far larger than any steady U. Reference: 1-D finite-volume wall,
15 cm clay + 25 cm soil, far end at ambient. Candidate: a 3-node wall
(face + substrate + deep) with physical interface conductances.
"""
import numpy as np

K_CLAY, RC_CLAY = 0.9, 1900 * 880        # W/mK, J/m3K
K_SOIL, RC_SOIL = 0.5, 1500 * 1200
T0, Q = 350.0, 2000.0                     # start K, absorbed W/m2
DT = 15.0


def ref_1d(hours=8.0):
    dx1, n1 = 0.005, 30                   # 15 cm clay
    dx2, n2 = 0.025, 10                   # 25 cm soil
    x = [dx1]*n1 + [dx2]*n2
    k = [K_CLAY]*n1 + [K_SOIL]*n2
    rc = [RC_CLAY]*n1 + [RC_SOIL]*n2
    T = np.full(len(x), T0)
    out = {}
    steps = int(hours*3600/DT)
    g = np.array([2*k[i]*k[i+1]/(k[i]*x[i+1]+k[i+1]*x[i]) * 2
                  / (1 + 1) for i in range(len(x)-1)])
    g = np.array([1.0/(x[i]/(2*k[i]) + x[i+1]/(2*k[i+1]))
                  for i in range(len(x)-1)])
    cap = np.array([rc[i]*x[i] for i in range(len(x))])
    for s in range(steps):
        q = np.zeros(len(x))
        q[0] += Q
        flux = g * (T[:-1] - T[1:])
        q[:-1] -= flux
        q[1:] += flux
        q[-1] -= (T[-1]-300.0) / (x[-1]/(2*k[-1]))**-1**0  # far end ~
        q[-1] -= 2*k[-1]/x[-1] * (T[-1]-300.0)
        T += q*DT/cap
        hr = (s+1)*DT/3600
        for h in (0.5, 1, 2, 4, 8):
            if abs(hr-h) < DT/7200:
                out[h] = T[0]
    return out


def lumped(hours=8.0):
    T = T0
    out = {}
    for s in range(int(hours*3600/DT)):
        q = Q - 0.7*(T-300.0)
        T += q*DT/(RC_CLAY*0.015)
        hr = (s+1)*DT/3600
        for h in (0.5, 1, 2, 4, 8):
            if abs(hr-h) < DT/7200:
                out[h] = T
    return out


def three_node(hours=8.0, L=(0.015, 0.05, 0.10)):
    T = np.full(3, T0)
    cap = np.array([RC_CLAY*L[0], RC_CLAY*L[1], RC_CLAY*L[2]])
    g01 = 1.0/(L[0]/(2*K_CLAY) + L[1]/(2*K_CLAY))
    g12 = 1.0/(L[1]/(2*K_CLAY) + L[2]/(2*K_CLAY))
    g2s = 1.0/(L[2]/(2*K_CLAY) + 0.15/K_SOIL)   # deep -> soil path
    out = {}
    for s in range(int(hours*3600/DT)):
        q = np.zeros(3)
        q[0] += Q - g01*(T[0]-T[1])
        q[1] += g01*(T[0]-T[1]) - g12*(T[1]-T[2])
        q[2] += g12*(T[1]-T[2]) - g2s*(T[2]-300.0)
        T += q*DT/cap
        hr = (s+1)*DT/3600
        for h in (0.5, 1, 2, 4, 8):
            if abs(hr-h) < DT/7200:
                out[h] = T[0]
    return out


if __name__ == "__main__":
    r1, rl, r3 = ref_1d(), lumped(), three_node()
    print("surface T under constant 2 kW/m2 absorbed (start 350 K):")
    print(f"{'hours':>6} {'1-D ref':>9} {'lumped(now)':>12} {'3-node':>9}")
    for h in (0.5, 1, 2, 4, 8):
        print(f"{h:>6} {r1[h]:>9.0f} {rl[h]:>12.0f} {r3[h]:>9.0f}")
    def t_to_560(f):
        T, t = None, None
        return None
    print("\ntime to reach 560 K (the cook band floor):")
    for name, fn in (("1-D ref", ref_1d), ("lumped", lumped),
                     ("3-node", three_node)):
        # rerun finely
        import numpy as _np
        if name == "1-D ref":
            dx1, n1 = 0.005, 30; dx2, n2 = 0.025, 10
            x = [dx1]*n1+[dx2]*n2; k=[K_CLAY]*n1+[K_SOIL]*n2
            rc=[RC_CLAY]*n1+[RC_SOIL]*n2
            g=_np.array([1.0/(x[i]/(2*k[i])+x[i+1]/(2*k[i+1]))
                         for i in range(len(x)-1)])
            cap=_np.array([rc[i]*x[i] for i in range(len(x))])
            T=_np.full(len(x), T0); t=0
            while T[0] < 560 and t < 12*3600:
                q=_np.zeros(len(x)); q[0]+=Q
                fl=g*(T[:-1]-T[1:]); q[:-1]-=fl; q[1:]+=fl
                q[-1]-=2*k[-1]/x[-1]*(T[-1]-300.0)
                T+=q*DT/cap; t+=DT
            print(f"  {name:8s} {t/3600:5.2f} h")
        elif name == "lumped":
            T=T0; t=0
            while T<560 and t<12*3600:
                T+=(Q-0.7*(T-300.0))*DT/(RC_CLAY*0.015); t+=DT
            print(f"  {name:8s} {t/3600:5.2f} h")
        else:
            T=_np.full(3,T0); t=0
            L=(0.015,0.05,0.10)
            cap=_np.array([RC_CLAY*L[0],RC_CLAY*L[1],RC_CLAY*L[2]])
            g01=1.0/(L[0]/(2*K_CLAY)+L[1]/(2*K_CLAY))
            g12=1.0/(L[1]/(2*K_CLAY)+L[2]/(2*K_CLAY))
            g2s=1.0/(L[2]/(2*K_CLAY)+0.15/K_SOIL)
            while T[0]<560 and t<12*3600:
                q=_np.zeros(3)
                q[0]+=Q-g01*(T[0]-T[1])
                q[1]+=g01*(T[0]-T[1])-g12*(T[1]-T[2])
                q[2]+=g12*(T[1]-T[2])-g2s*(T[2]-300.0)
                T+=q*DT/cap; t+=DT
            print(f"  {name:8s} {t/3600:5.2f} h")

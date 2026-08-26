import sys; sys.path.insert(0, '.')
import numpy as np, torch
from tandoor_rl_env import TandoorEnv
import pufferlib.models, pufferlib.pytorch
sd = torch.load("puffer_tandoor/experiments/178770584849.pt", map_location="cpu")
sd = {k.replace("module.", ""): v for k, v in sd.items()}
env = TandoorEnv(num_agents=6, seed=11, device="cpu", wide_shutter=1)
pol = pufferlib.models.Default(env, hidden_size=128)
pol = pufferlib.models.LSTMWrapper(env, pol, input_size=128, hidden_size=128)
pol.load_state_dict(sd)
def rollout(kind):
    env.reset(seed=11); env.T[:] = 350. + env.rng.uniform(-15,15,env.T.shape)
    env._belt_prev = env.T[:,:8].mean(1).copy()
    o = env._obs(); st = dict(lstm_h=torch.zeros(6,128), lstm_c=torch.zeros(6,128))
    rot, loads, shut, prev = 0., 0, 0., np.zeros((6,8),bool)
    for t in range(1922):
        belt = env.T[:,:8]; bm = belt.mean(1)
        if kind == "policy":
            with torch.no_grad():
                lg,_ = pol.forward_eval(torch.as_tensor(o), st)
                a = torch.stack([l.argmax(-1) for l in lg],1).numpy()
        else:
            lvl = np.where(bm<540,4,np.where(bm<630,3,np.where(bm<665,2,np.where(bm<690,1,0))))
            ok = ((~env.has_bread)&(belt>=560.)&(belt<=700.)).any(1)
            a = np.stack([lvl, np.where((env.load_timer>=30.)&ok,0,6)],1)
        o,*_,infos = env.step(a)
        shut += float(env.shutter.mean())
        loads += int(((~prev)&env.has_bread).sum()); prev = env.has_bread.copy()
        for inf in infos: rot = inf["rotis_per_day"]
    ld = loads/6
    print(f"  {kind:>9} cold: {rot:6.1f} rotis | {ld:5.1f} loads | "
          f"cycle {(8*3600.)/max(ld,1e-9):5.1f}s | shutter open {shut/1922:.2f}",
          flush=True)
for k in ("heuristic","policy"): rollout(k)

"""run tandoor_design_mcts.py on THIS worktree's modules (the script pins sys.path to the shared checkout, whose base env
and kernel carry the user's own work and lack film_T): the worktree's modules are loaded first, then the script runs.
    PYTHONPATH=.. python design/compliant/stage3/tri/mcts_run.py CKPT --film-T 2100 --film-slope 1e-3 [mcts args]"""
import os, sys, runpy, importlib.util
ROOT = "/Users/faezs/ARTIST-compliant"; TUT = ROOT + "/tutorials"; PT = "/Users/faezs/ARTIST/tutorials/puffer_tandoor"
for p in (PT, TUT, ROOT):
    if p in sys.path: sys.path.remove(p)
    sys.path.insert(0, p)
for m in ("tandoor_screws", "tandoor_mount_batch", "tandoor_metal_kernel", "tandoor_cuda_kernel", "tandoor_fused_step", "tandoor_wind_table", "tandoor_site_wind",
          "tandoor_rl_env", "tandoor_polar_env", "tandoor_coude_env", "tandoor_hashemi_env", "tandoor_system_cost", "tandoor_payback", "tandoor_design_readout"):
    f = os.path.join(TUT, m + ".py")
    if not os.path.exists(f): continue
    s = importlib.util.spec_from_file_location(m, f); mod = importlib.util.module_from_spec(s); sys.modules[m] = mod; s.loader.exec_module(mod)
import tandoor_hashemi_env as HE
assert HE.__file__.startswith(TUT), HE.__file__
sys.argv = [os.path.join(TUT, "tandoor_design_mcts.py")] + sys.argv[1:]
runpy.run_path(sys.argv[0], run_name="__main__")

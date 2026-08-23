# Solar tandoor: pump-membrane beam-down + PufferLib RL

A pump-actuated aluminized-Mylar membrane primary (the pump pressure is the
focus knob: f = T/dp), a Cassegrain beam-down secondary pivoting about the
pit mouth, and an underground firebrick tandoor. Built on ARTIST's
differentiable raytracing primitives (NURBS surfaces, `Sun`, `reflect`,
`line_plane_intersections`, `sample_bitmaps`).

## Files

- `../03_membrane_beamdown_tandoor.py` - design study: FvK membrane solve
  (Hencky regime), NURBS fit, hyperboloid/aspheric/ring secondaries
  (gradient-optimized through the raytrace), multi-pump zone optimization,
  raymaps, pump sweep. `--gif` renders three tracked days. Adversarially
  verified (geometry, radiometry, mechanics).
- `../tandoor_rl_env.py` - native PufferEnv: the agent commands 5 plenum-zone
  pressure setpoints (MultiDiscrete, 7 levels, ARTIST-actuator-style absolute
  positions); batched MPS raytrace (~20k agent-steps/s at 512 envs);
  thin-liner thermal nodes with a glowing hearth node; OU clouds, actuator
  drift, bread lifecycle. `render_mode='human'` opens a raylib window drawing
  the live ARTIST ray fan; `'ansi'` streams to the terminal.
- `../tandoor_rl_train.py` - standalone trainer + baselines.
- this package - stock `puffer` CLI registration.
- `../data/tandoor/` - trained LSTM checkpoint + key figures.

## Run (self-contained, pufferlib 3.0)

```bash
./run.sh eval          # watch the pretrained controller (raylib window)
./run.sh train         # train from scratch
```

`run.sh` builds a local `.venv` on first use (`setup.sh`) and registers the
env inside it, so the stock `puffer` CLI resolves `puffer_tandoor`. Extra
puffer args pass through, e.g. `./run.sh eval --env.render-mode ansi` for a
terminal stream. The pretrained LSTM lives at `../data/tandoor/tandoor_lstm.pt`.

## Results

Two environments live here. The IDEAL-PHYSICS env (v1 history): trained
LSTM 294-321 rotis/day vs 275 hold-nominal. The FIELD-REAL env (v2,
expert-panel redesign: wind, slope error, soiling, boresight, shutter
interlock, spall, honest chain) is much harder and is currently an OPEN
BENCHMARK - the scripted heuristic still leads:

| controller (field-real env)   | cold start | warm start |
|---|---|---|
| scripted heuristic            | 7-13       | 61         |
| trained LSTM (latest)         | 1.3        | 48         |

Policy trajectory across iterations: 0/21 -> 1.3/48 (cold/warm) via a
warm-start curriculum, a +0.3 load bonus, and potential-based preheat
shaping. The shipped checkpoint is the latest policy; beating the
heuristic on cold mornings is the open problem.

## Hard-won notes

- pufferlib 3.0's continuous Box action head anti-trained in every probe
  (a good init degraded monotonically on cpu and mps; an lr~0 run proved the
  env stable). MultiDiscrete - the path Ocean envs exercise - learns
  immediately.
- Dense power-based reward shaping was reward-hacked twice (overheat past
  the loading window and farm; park just below the loading threshold and
  farm). Cooking events are plentiful, so the roti reward alone carries the
  gradient.
- Increment actions make the plant an integrator and PPO walks the pressures
  to the clamp rails; absolute setpoints (like ARTIST's motor positions)
  fix the init and the credit assignment.

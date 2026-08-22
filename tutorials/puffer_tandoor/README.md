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

## Results (one cooking day, 350 K cold start, clouds + drift)

| policy | rotis/day |
|---|---|
| random setpoints | 95.6 |
| hold-nominal (flat 404 Pa) | 351.6 |
| trained LSTM | 376-380 |

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

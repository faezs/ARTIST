#!/bin/zsh
# the metaprogrammer at the 4 x 6 m median tandoor roof, sections available, 2 m of overhang accepted; after the readout has finished
cd /Users/faezs/ARTIST/tutorials
while [ ! -f puffer_tandoor/watch/section_readout.json ]; do sleep 30; done
PYTHONPATH=/Users/faezs/ARTIST exec /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python -u tandoor_designer.py \
  /Users/faezs/ARTIST/tutorials/puffer_tandoor/experiments/design_warm/demand60_pad94.pt \
  --sites 0.5 --gens 3 --cand 512 --top 64 --seasoned 2 --over-cap 0.5 \
  --out /Users/faezs/ARTIST/tutorials/puffer_tandoor/watch/design_pop_4x6.json

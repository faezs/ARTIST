#!/bin/zsh
# after the rebuilt library: the 4 x 6 readout, then the designer at 100k and at 160k
cd /Users/faezs/ARTIST/tutorials
W=puffer_tandoor/watch; PY=/Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python; CK=puffer_tandoor/experiments/design_warm/demand60_pad94.pt
until grep -q "library:" $W/section_library3.log 2>/dev/null; do sleep 30; done
PYTHONPATH=/Users/faezs/ARTIST $PY -u $W/section_readout.py > $W/section_readout4.log 2>&1
PYTHONPATH=/Users/faezs/ARTIST $PY -u tandoor_designer.py $CK --sites 0.5 --gens 4 --cand 512 --top 64 --seasoned 2 --over-cap 0.5 --budget 100000 --out $W/design_pop_4x6_v2.json > $W/designer_4x6_v2.log 2>&1
PYTHONPATH=/Users/faezs/ARTIST $PY -u tandoor_designer.py $CK --sites 0.5 --gens 4 --cand 512 --top 64 --seasoned 2 --over-cap 0.5 --budget 160000 --out $W/design_pop_4x6_160k_v2.json > $W/designer_4x6_160k_v2.log 2>&1
echo done > $W/after_library.done

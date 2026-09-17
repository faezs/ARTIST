#!/bin/zsh
set -e
cd "$(dirname "$0")"
PY=../../.venv-sim/bin/python
$PY -u setup_sim4.py --t_setup 40 --t_day 40 --fps 30 --rec 4 --substeps 12 --iters 12 > out/production4.log 2>&1
$PY render_gif.py setup4 >> out/production4.log 2>&1
$PY koopman_fit.py setup4 >> out/production4.log 2>&1
cd ../.. && /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python build_page.py /private/tmp/claude-501/-Users-faezs-ARTIST/183761ff-b79b-4491-8c29-a914be4dd819/scratchpad >> stage3/setup_sim/out/production4.log 2>&1
echo PRODUCTION_DONE >> stage3/setup_sim/out/production4.log

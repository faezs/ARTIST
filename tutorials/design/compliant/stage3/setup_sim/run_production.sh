#!/bin/zsh
# the published run: 40 s setup + 40 s day (equinox 8-16 h), 7.5 recorded fps; then the film, the Koopman fit and the page
set -e
cd "$(dirname "$0")"
PY=../../.venv-sim/bin/python
$PY -u setup_sim.py --stage 4 --t_setup 40 --t_day 40 --fps 30 --rec 4 --substeps 12 --iters 12 > out/production.log 2>&1
$PY render_gif.py >> out/production.log 2>&1
$PY koopman_fit.py >> out/production.log 2>&1
$PY inflated_beam.py > out/inflated_beam.txt 2>&1
cd ../.. && /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python build_page.py /private/tmp/claude-501/-Users-faezs-ARTIST/183761ff-b79b-4491-8c29-a914be4dd819/scratchpad >> stage3/setup_sim/out/production.log 2>&1
echo PRODUCTION_DONE >> stage3/setup_sim/out/production.log

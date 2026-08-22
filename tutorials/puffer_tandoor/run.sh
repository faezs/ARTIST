#!/usr/bin/env bash
# ./run.sh train [puffer args...]   - train (checkpoints under ./experiments)
# ./run.sh eval  [puffer args...]   - watch the trained controller cook
#                                     (raylib window; add
#                                     --env.render-mode ansi for terminal)
set -euo pipefail
cd "$(dirname "$0")"
[ -x .venv/bin/puffer ] || ./setup.sh

mode="${1:-eval}"
shift || true

if [ "$mode" = "eval" ]; then
    exec ./.venv/bin/puffer eval puffer_tandoor \
        --load-model-path ../data/tandoor/tandoor_lstm.pt \
        --env.num-agents 8 "$@"
else
    exec ./.venv/bin/puffer "$mode" puffer_tandoor "$@"
fi

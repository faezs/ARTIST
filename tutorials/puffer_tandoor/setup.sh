#!/usr/bin/env bash
# One-time setup: builds a local venv next to this script and registers the
# tandoor env inside it so the stock `puffer` CLI can find it.
set -euo pipefail
cd "$(dirname "$0")"

python3 -m venv .venv
./.venv/bin/pip -q install --upgrade pip
./.venv/bin/pip -q install torch matplotlib h5py typing_extensions colorlog \
    pufferlib raylib

SITE=$(./.venv/bin/python -c "import pufferlib, os; print(os.path.dirname(pufferlib.__file__))")
ln -sfn "$(pwd)" "$SITE/environments/tandoor"
ln -sf "$(pwd)/tandoor.ini" "$SITE/config/tandoor.ini"

echo "done. use ./run.sh train | ./run.sh eval"

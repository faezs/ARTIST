#!/bin/zsh
# builds libmetal_bridge.dylib against the project's Lean toolchain (the one in ~/manifold-pareto/lean/lean-toolchain)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
TC=$(cat ~/manifold-pareto/lean/lean-toolchain | sed 's|/|--|; s|:|---|')
LEAN=~/.elan/toolchains/$TC
[ -d "$LEAN" ] || { echo "toolchain $LEAN not found"; exit 1; }
xcrun clang -O2 -fobjc-arc -dynamiclib -undefined dynamic_lookup -I "$LEAN/include" \
  -framework Metal -framework Foundation -o "$HERE/libmetal_bridge.dylib" "$HERE/metal_bridge.m"
echo "built $HERE/libmetal_bridge.dylib against $TC"

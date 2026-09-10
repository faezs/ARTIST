#!/bin/zsh
# the retro attitudes across the year (the dish axis = the sun; wind from the south): el, az-from-south
S=/private/tmp/claude-501/-Users-faezs-ARTIST/b026ddf9-1915-4882-a9b5-88b4c0cfa7df/scratchpad
for pair in "36 8 midwinter_noon" "80 46 midsummer_noon" "43 56 equinox_0930" "25 73 equinox_0800" "37 98 midsummer_0800"; do
  set -- ${=pair}; d=$S/dish_les_el$1_az$2; mkdir -p $d
  echo "== $3: el $1 az $2 -> $d  $(date +%H:%M:%S)"
  DISH_DX=0.06 DISH_SECONDS=8 DISH_EL=$1 DISH_AZ=$2 DISH_OUT=$d /Users/faezs/ARTIST-compliant/resources/FluidX3D/bin/FluidX3D > $d/run.log 2>&1
  tr '\r' '\n' < $d/run.log | grep -a "done:\|rror" | tail -2
done
echo "matrix done $(date +%H:%M:%S)"

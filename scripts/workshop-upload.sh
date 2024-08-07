GMOD_ROOT="/q/Steam/steamapps/common/GarrysMod"

set -e

"$GMOD_ROOT/bin/gmad.exe" create -folder . ".gma"
"$GMOD_ROOT/bin/gmpublish.exe" update -addon ".gma" -id "1479340077"
rm .gma
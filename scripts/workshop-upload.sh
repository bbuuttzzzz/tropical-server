GMOD_ROOT="/q/Steam/steamapps/common/GarrysMod"

set -e

"$GMOD_ROOT/bin/gmad.exe" create -folder . zscontent.gma
"$GMOD_ROOT/bin/gmpublish.exe" update -addon zscontent.gma -id "1479340077"
rm zscontent.gma
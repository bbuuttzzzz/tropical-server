#!/bin/bash
GMOD_ROOT="/q/Steam/steamapps/common/GarrysMod"

set -e
set -x

rm -rf /tmp/addon
mkdir /tmp/addon

cp scripts/zs-content-workshop-addon.json /tmp/addon/addon.json
cp -r gamemodes/zombiesurvival/content/* /tmp/addon/
cd /tmp/addon

"$GMOD_ROOT/bin/gmad.exe" create -folder . ".gma"
"$GMOD_ROOT/bin/gmpublish.exe" update -addon ".gma" -id "3305863875"
rm .gma
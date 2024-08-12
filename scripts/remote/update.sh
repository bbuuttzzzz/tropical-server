#!/bin/bash

# Function to display help
function display_help {
    echo "Usage: $0 [-b|--skip-build] [-p|--skip-pull] [-h|--help]"
    echo
    echo "Options:"
    echo "  -b, --skip-build  Skip the Docker build step."
    echo "  -p, --skip-pull   Skip the git pull and submodule update step."
    echo "  -h, --help        Display this help message."
    exit 0
}

# Parse arguments
SKIP_BUILD=false
SKIP_PULL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--skip-build) SKIP_BUILD=true ;;
        -p|--skip-pull) SKIP_PULL=true ;;
        -h|--help) display_help ;;
        *) echo "Unknown parameter passed: $1"; display_help ;;
    esac
    shift
done

# Conditionally skip the pull and submodule update step
if [ "$SKIP_PULL" = false ]; then
    cd /root/src/tropical-server/
    git pull
    git submodule update --recursive
else
    echo "Skipping git pull and submodule update..."
fi

# Conditionally skip the build step
if [ "$SKIP_BUILD" = false ]; then
    docker build --tag tropicalvacation/tropical-zs:latest \
       --build-arg STEAM_TOKEN=681A198C9885A558DD87958DDC32F91A \
       .
else
    echo "Skipping docker build..."
fi

# Remove the old container if it exists
docker rm zs -f

# Run the container
docker run -t \
    -p 27015:27015/udp \
    -p 27015:27015 \
    -p 27005:27005/udp \
    -v /root/mount/data:/steam/garrysmod/data \
    -v /root/mount/gmodcache:/steam/garrysmod/cache/srcds \
    -v /root/mount/steamcache:/steam/steam_cache \
    --name zs \
    tropicalvacation/tropical-zs:latest

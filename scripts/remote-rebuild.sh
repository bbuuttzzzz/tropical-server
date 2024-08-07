#!/bin/bash
cd src/tropical-server/
git pull
git submodule update

docker build --tag tropicalvacation/tropical-zs:latest .

docker rm zs -f

docker run -t -p 27015:27015/udp -p 27015:27015 -p 27005:27005/udp --name zs tropicalvacation/tropical-zs:latest

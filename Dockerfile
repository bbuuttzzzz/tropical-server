FROM steamcmd/steamcmd:latest

# -----------------------------------------------------
# create steam user
# -----------------------------------------------------
RUN useradd -ms /bin/bash steam
RUN mkdir -p /steam && chown steam:steam /steam

# -----------------------------------------------------
# install needed packages for garrysmod
# install cstrike and garrysmod and configure the mount
# -----------------------------------------------------
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get -y install lib32stdc++6 \
 && apt-get -y autoremove \
 && apt-get -y clean \
 && apt-get -y purge \
 && su -l steam -c " \
        steamcmd \
         +force_install_dir /steam/ \
         +login anonymous \
         +app_update 232330 validate \
         +app_update 4020 validate \
         +quit \
    "

# -----------------------------------------------
# change to the executing user from the baseimage
# -----------------------------------------------
USER steam

# ---------------------------------------
# volumes:
# * the server-configuration
# * the data folder (used by some addons)
# * the cache of workshop-downloads
# ---------------------------------------
# mount yourself: /steam/garrysmod/cfg/server.cfg \
RUN mkdir /steam/garrysmod/data && chown steam /steam/garrysmod/data
RUN mkdir /steam/garrysmod/cache && chown steam /steam/garrysmod/cache
RUN mkdir /steam/steam_cache && chown steam /steam/steam_cache

VOLUME /steam/garrysmod/data/ \
       /steam/garrysmod/cache/srcds/ \
       /steam/steam_cache


# -----------------------------------
# only port 27015 has to be forwarded
# -----------------------------------
EXPOSE 27015:27015/tcp 27015:27015/udp

WORKDIR /steam
ENTRYPOINT ["./srcds_run", "-game", "garrysmod", "-nohltv", "-norestart"]


COPY addons /steam/garrysmod/addons
COPY gamemodes /steam/garrysmod/gamemodes
COPY data /steam/garrysmod/data
COPY cfg /steam/garrysmod/cfg/

CMD ["-dev", "+gamemode zombiesurvival", "-maxplayers 24", "+map zm_4ngry_quaruntine", "+rcon nohacko", "+host_workshop_collection 1479350474"]

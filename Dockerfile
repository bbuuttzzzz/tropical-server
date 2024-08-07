FROM steamcmd/steamcmd:latest

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
        /steam/cmd/steamcmd.sh \
         +login anonymous \
         +force_install_dir /steam/cstrike \
         +app_update 232330 validate \
         +force_install_dir /steam/gmod \
         +app_update 4020 validate \
         +quit \
     && echo '"mountcfg"{"cstrike" "/steam/cstrike"}' >> /steam/gmod/garrysmod/cfg/mount.cfg \
    "

# -----------------------------------------------
# change to the executing user from the baseimage
# -----------------------------------------------
RUN groupadd -r steam && useradd -r -g steam steam
USER steam

# ---------------------------------------
# volumes:
# * the server-configuration
# * the data folder (used by some addons)
# * the cache of workshop-downloads
# ---------------------------------------
# mount yourself: /steam/gmod/garrysmod/cfg/server.cfg \
RUN chown steam:steam /steam/gmod/garrysmod
VOLUME /steam/gmod/garrysmod/data/ \
       /steam/gmod/garrysmod/cache/srcds/

# -----------------------------------
# only port 27015 has to be forwarded
# -----------------------------------
EXPOSE 27015:27015/tcp 27015:27015/udp

WORKDIR /steam/gmod
ENTRYPOINT ["./srcds_run", "-game", "garrysmod", "-nohltv", "-norestart"]


COPY addons /steam/gmod/garrysmod/addons
COPY gamemodes /steam/gmod/garrysmod/gamemodes
COPY data /steam/gmod/garrysmod/data
COPY server.cfg /steam/gmod/garrysmod/cfg/server.cfg
COPY mount.cfg /steam/gmod/garrysmod/fcg/server.cfg

CMD ["-dev", "+gamemode", "zombiesurvival", "-maxplayers", "24", "+map", "zm_4ngry_quaruntine", "+rcon", "nohacko", "+host_workshop_collection", "1479350474", "sv_setsteamaccount", "0F71CE9C4029E3698FAD3994C7CC6985"]

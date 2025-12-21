# HostAtHome - Project Zomboid Server

FROM steamcmd/steamcmd:ubuntu-24

RUN apt-get update && apt-get install -y --no-install-recommends curl libsdl2-2.0-0 \
    && curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq \
    && chmod +x /usr/bin/yq \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m zomboid \
    && mkdir -p /server /data/{save,mods,configs,backup} /defaults

COPY configs/ /defaults/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
    && chown -R zomboid:zomboid /server /data

EXPOSE 16261/udp
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]

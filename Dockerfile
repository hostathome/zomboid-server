# HostAtHome - Project Zomboid Server

FROM steamcmd/steamcmd:alpine-3

RUN apk add --no-cache curl libsdl2 python3 py3-pip \
    && pip3 install --no-cache-dir --break-system-packages pyyaml \
    && curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq \
    && chmod +x /usr/bin/yq \
    && adduser -D -s /bin/sh zomboid \
    && mkdir -p /server /data/{save,mods,configs,backup} /defaults

COPY configs/ /defaults/
COPY config_mapper.py /config_mapper.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh /config_mapper.py \
    && chown -R zomboid:zomboid /server /data

EXPOSE 16261/udp
VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]

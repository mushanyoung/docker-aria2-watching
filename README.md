# docker-aria2-watching

Dockerized aria2 daemon service with webui, watching torrents.

## Usage

- Replace all variables wrapped in % % to use following examples.
- Aria2 daemon service will be accessible over HTTP from port 6800 (or any port you mapped to).
- WebUI will be accessible over HTTP from port 8080 (or any port you mapped to).
- %CONFIG_DIR% saves configs and logs.
- %DATA_DIR% will be the default download path.
- %WATCH_DIR% must be different to %DATA_DIR%. Torrent files being added to the it will be automatically added as aria2 new task.
- %SECRET% (default: watching) is for communicating with aria2 daemon service.
- %PUID% (default: 1000) and %PGID% (default: 1000) specify the uid and gid of the data owner.
- By default, [Aria2Ng](https://github.com/mayswind/AriaNg) is used as the webui. Set environment variable WEB_HOME=/webui-aria2 if you prefer [WebUI-Aria2](https://github.com/ziahamza/webui-aria2).

### Docker Run

```
$ docker run -d --name aria2 \
    -p 6800:6800 \
    -p 8080:8080 \
    -v %CONFIG_DIR%:/conf \
    -v %DOWNLOAD_DIR%:/data \
    -v %WATCH_DIR%:/watch \
    -e SECRET=%SECRET% \
    -e PUID=%PUID% \
    -e PGID=%PGID% \
  mushanyoung/aria2-watching:latest
```

### Docker Compose

```
services:
  aria2:
    container_name: aria2
    image: mushanyoung/aria2-watching:latest
    restart: unless-stopped
    network_mode: "bridge"
    ports:
      - "6800:6800"
      - "8080:8080"
    volumes:
      - %CONFIG_DIR%:/conf
      - %DOWNLOAD_DIR%:/data
      - %WATCH_DIR%:/watch
    environment:
      SECRET: %SECRET%
      PUID: %PUID%
      PGID: %PGID%
```

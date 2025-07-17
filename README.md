# docker-aria2-watching

Dockerized aria2 daemon service with webui, watching torrents.

## Usage

- Replace all variables wrapped in % % to use following examples.
- %CONFIG_DIR% saves configs and logs.
- %DATA_DIR% will be the default download path.
- %WATCH_DIR% must be different to %DATA_DIR%. Torrent files being added to it will be automatically added as aria2 new tasks.
- %SECRET% (default: watching) is for communicating with aria2 daemon service.
- %PUID% (default: 1000) and %PGID% (default: 1000) specify the uid and gid of the data owner.
- %ARIA_RPC_PORT% specifies the port where Aria2 daemon service will be accessible.
- %WEBUI_PORT% specifies the port where WebUI will be accessible. By default, it is [AriaNg](https://github.com/mayswind/AriaNg). Set environment variable `WEB_HOME=/webui-aria2` if you prefer [WebUI-Aria2](https://github.com/ziahamza/webui-aria2).

### Alias

`ghcr.io/mushanyoung/aria2-watching` and `docker.io/mushanyoung/aria2-watching` are available as aliases for this image.

### Docker Run

```
$ docker run -d --name aria2 \
    -p %ARIA_RPC_PORT%:6800/tcp \
    -p %WEBUI_PORT%:8080/tcp \
    -v %CONFIG_DIR%:/conf \
    -v %DOWNLOAD_DIR%:/data \
    -v %WATCH_DIR%:/watch \
    -e SECRET=%SECRET% \
    -e PUID=%PUID% \
    -e PGID=%PGID% \
  ghcr.io/mushanyoung/aria2-watching:latest
```

### Docker Compose

```
services:
  aria2:
    container_name: aria2
    image: ghcr.io/mushanyoung/aria2-watching:latest
    restart: unless-stopped
    network_mode: "bridge"
    ports:
      - "%ARIA_RPC_PORT%:6800/tcp"
      - "%WEBUI_PORT%:8080/tcp"
    volumes:
      - %CONFIG_DIR%:/conf
      - %DOWNLOAD_DIR%:/data
      - %WATCH_DIR%:/watch
    environment:
      SECRET: %SECRET%
      PUID: %PUID%
      PGID: %PGID%
```

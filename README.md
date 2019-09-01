# docker-aria2-watching

Dockerized aria2 daemon service with webui, watching torrents.

## Usage

- Configure /DOWNLOAD, /CONFIG, /WATCH and RPC_SECRET_CODE in either of following examples.
- Aria2 daemon service will be accessible over HTTP from port 6800 (or any port you mapped to).
- WebUI, [Aria2Ng](https://github.com/mayswind/AriaNg) will be accessible over HTTP from port 8080 (or any port you mapped to).
- Volume /data will be the default download path.
- Volume /conf saves configs and logs.
- Torrent files being added to /watch volume will be automatically added as aria2 tasks.
- SECRET ('watching' if it is omitted) is for communicating with aria2 daemon service.
- PUID and PGID can be specified by environment variables. If they're omitted, root will be used.

### Docker Run

```
$ docker run -d --name aria2 \
    -p 6800:6800 \
    -p 8080:8080 \
    -v /DOWNLOAD:/data \
    -v /CONFIG:/conf \
    -v /WATCH:/watch \
    -e SECRET=RPC_SECRET_CODE \
    -e PUID=1000 \
    -e PGID=1000 \
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
      - /DOWNLOAD:/data
      - /CONFIG:/conf
      - /WATCH:/watch
    environment:
      SECRET: RPC_SECRET_CODE
      PUID: 1000
      PGID: 1000
```

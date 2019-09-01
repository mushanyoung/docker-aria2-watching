FROM alpine:edge

MAINTAINER mushanyoung <mushanyoung@gmail.com>

RUN mkdir -p /conf /data /watch
RUN mkdir -p /conf-copy /webui
RUN apk update && apk add --no-cache aria2 darkhttpd s6 inotify-tools python3

RUN apk add --no-cache --virtual .install-deps curl jq unzip \
 && curl -o /aria2-ng.zip -L $(curl -sX GET "https://api.github.com/repos/mayswind/AriaNg/releases/latest" | jq -r '.assets[0].browser_download_url') \
 && unzip /aria2-ng.zip -d /webui \
 && rm /aria2-ng.zip \
 && curl "https://raw.githubusercontent.com/baskerville/diana/master/diana" -o /bin/diana \
 && chmod +x /bin/diana \
 && apk del .install-deps

ADD aria2.conf /conf-copy/aria2.conf
ADD start.sh /conf-copy/start.sh
RUN chmod +x /conf-copy/start.sh

WORKDIR /
VOLUME ["/conf"]
VOLUME ["/data"]
VOLUME ["/watch"]
EXPOSE 6800
EXPOSE 8080

CMD ["/conf-copy/start.sh"]

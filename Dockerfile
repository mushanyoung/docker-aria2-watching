FROM alpine:edge

MAINTAINER mushanyoung <mushanyoung@gmail.com>

RUN mkdir -p /conf /data /watch \
             /aria2-watching /aria2-watching/ui

ADD aria2.conf /aria2-watching/aria2.conf
ADD start.sh /aria2-watching/start.sh
RUN chmod +x /aria2-watching/start.sh

RUN apk update && apk add --no-cache aria2 darkhttpd s6 inotify-tools python3

RUN apk add --no-cache --virtual .install-deps curl jq unzip \
 && curl -o /aria2ng.zip -L $(curl -sX GET 'https://api.github.com/repos/mayswind/AriaNg/releases/latest' | jq -r '.assets[0].browser_download_url') \
 && unzip /aria2ng.zip -d /aria2-watching/ui \
 && rm /aria2ng.zip \
 && curl 'https://raw.githubusercontent.com/baskerville/diana/master/diana' -o /aria2-watching/diana \
 && chmod +x /aria2-watching/diana \
 && apk del .install-deps

VOLUME /conf /data /watch
EXPOSE 6800/tcp 8080/tcp

CMD /aria2-watching/start.sh

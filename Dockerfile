FROM alpine:edge

MAINTAINER mushanyoung <mushanyoung@gmail.com>

RUN mkdir -p /conf /conf-copy /data /watch /aria2-ng
RUN apk update && apk add --no-cache aria2 darkhttpd jq s6 inotify-tools python3

RUN apk add --no-cache --virtual .install-deps curl unzip \
 && curl -o /aria2-ng.zip -L $(curl -sX GET "https://api.github.com/repos/mayswind/AriaNg/releases/latest" | jq -r '.assets[0].browser_download_url') \
 && unzip /aria2-ng.zip -d /aria2-ng \
 && rm /aria2-ng.zip \
 && curl "https://raw.githubusercontent.com/baskerville/diana/master/diana" -o /bin/diana \
 && chmod +x /bin/diana \
 && apk del .install-deps

ADD aria2.conf /conf-copy/aria2.conf
ADD start.sh /conf-copy/start.sh
RUN chmod +x /conf-copy/start.sh

WORKDIR /
VOLUME ["/data"]
VOLUME ["/watch"]
VOLUME ["/conf"]
EXPOSE 6800
EXPOSE 80

CMD ["/conf-copy/start.sh"]

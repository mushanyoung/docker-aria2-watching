FROM alpine:edge

MAINTAINER mushanyoung <mushanyoung@gmail.com>

ADD aria2.conf start.sh https://raw.githubusercontent.com/baskerville/diana/master/diana /aria2-watching/

RUN mkdir -p /conf /data /watch \
             /aria2-watching /aria2-watching/ui \
 && chmod +x /aria2-watching/diana /aria2-watching/start.sh \
 && apk add --no-cache s6 aria2 darkhttpd inotify-tools python3 \
 && apk add --no-cache --virtual .install-deps curl jq unzip \
 && curl -o /aria2ng.zip -L $(curl -sX GET 'https://api.github.com/repos/mayswind/AriaNg/releases/latest' | jq -r '.assets[0].browser_download_url') \
 && unzip /aria2ng.zip -d /aria2-watching/ui \
 && rm /aria2ng.zip \
 && apk del .install-deps

VOLUME /conf /data /watch
EXPOSE 6800/tcp 8080/tcp

CMD ["/aria2-watching/start.sh"]

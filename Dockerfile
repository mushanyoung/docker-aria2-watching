FROM alpine:edge

MAINTAINER mushanyoung <mushanyoung@gmail.com>

ADD aria2.conf init https://raw.githubusercontent.com/baskerville/diana/master/diana /

RUN mkdir -p /conf /data /watch /ui \
 && chmod 755 /diana /init \
 && apk add --no-cache s6 aria2 darkhttpd inotify-tools python3 \
 && apk add --no-cache --virtual .install-deps curl jq unzip git \
 && curl -o /aria2ng.zip -L $(curl -sX GET 'https:/api.github.com/repos/mayswind/AriaNg/releases/latest' | jq -r '.assets[0].browser_download_url') \
 && unzip /aria2ng.zip -d /ariang \
 && git clone --depth 1 https://github.com/ziahamza/webui-aria2 /webui-aria2t \
 && mv /webui-aria2t/docs /webui-aria2 \
 && rm -rf /webui-aria2t /aria2ng.zip \
 && apk del .install-deps

VOLUME /conf /data /watch
EXPOSE 6800/tcp 8080/tcp

ENTRYPOINT ["/init"]
CMD ["aria2c", "--conf-path=/conf/aria2.conf", "--log=/conf/aria2.log"]

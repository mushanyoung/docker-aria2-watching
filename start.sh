#!/bin/sh
set -e

PUID=${PUID:-0}
PGID=${PGID:-0}
SECRET=${SECRET:-watching}

if [ ! -f /conf/aria2.conf ]; then
  cp /aria2-watching/aria2.conf /conf/aria2.conf
  chown $PUID:$PGID /conf/aria2.conf
  echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
fi

touch /conf/aria2.session
chown $PUID:$PGID /conf/aria2.session

touch /logs.txt
chown $PUID:$PGID /logs.txt

export DIANA_SECRET_TOKEN=$SECRET
s6-setuidgid $PUID:$PGID inotifywait -m -e create -e moved_to --format '%w%f' '/watch' | xargs -n1 -I{} sh -c 'echo "{}" | grep "\.torrent$"; if [ $? -eq 0 ]; then /aria2-watching/diana add "{}" && mv "{}" "{}.added"; fi'

s6-setuidgid $PUID:$PGID darkhttpd /aria2-watching/ui --port 8080 &

exec s6-setuidgid $PUID:$PGID aria2c --conf-path=/conf/aria2.conf --log=/logs.txt

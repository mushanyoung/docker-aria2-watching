#!/bin/sh
set -e

export PUID=${PUID:-0}
export PGID=${PGID:-0}
export SECRET=${SECRET:-watching}
export DIANA_SECRET_TOKEN=$SECRET

if [ ! -f /conf/aria2.conf ]; then
  cp /aria2-watching/aria2.conf /conf/aria2.conf
  echo "rpc-secret=${SECRET}" >> /conf/aria2.conf
fi

touch /conf/aria2.session
touch /conf/aria2-watching.log
touch /conf/dht.dat
touch /conf/dht6.dat

chown $PUID:$PGID /conf/aria2.conf
chown $PUID:$PGID /conf/aria2.session
chown $PUID:$PGID /conf/aria2-watching.log
chown $PUID:$PGID /conf/dht.dat
chown $PUID:$PGID /conf/dht6.dat

s6-setuidgid $PUID:$PGID inotifywait -m -e create -e moved_to --format '%w%f' '/watch' | s6-setuidgid $PUID:$PGID xargs -n1 -I{} sh -c 'echo "{}" | grep "\.torrent$"; if [ $? -eq 0 ]; then /aria2-watching/diana add "{}" && mv "{}" "{}.added"; fi' &

s6-setuidgid $PUID:$PGID darkhttpd /aria2-watching/ui --port 8080 &

exec s6-setuidgid $PUID:$PGID aria2c --conf-path=/conf/aria2.conf --log=/conf/aria2-watching.log

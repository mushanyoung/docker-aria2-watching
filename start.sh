#!/bin/sh
set -e

PUID=${PUID:-0}
PGID=${PGID:-0}
SECRET="${SECRET:-watching}"
export DIANA_SECRET_TOKEN="${SECRET}"

[ -f /conf/aria2.conf ] || cp /aria2-watching/aria2.conf /conf/aria2.conf
grep '^rpc-secret=' /conf/aria2.conf &>/dev/null || echo "rpc-secret=${SECRET}" >> /conf/aria2.conf

touch /conf/aria2.session /conf/aria2c.log /conf/darkhttpd.log /conf/dht.dat /conf/dht6.dat
chown $PUID:$PGID /conf/aria2.conf /conf/aria2.session /conf/aria2c.log /conf/darkhttpd.log /conf/dht.dat /conf/dht6.dat

s6-setuidgid $PUID:$PGID darkhttpd /aria2-watching/ui --daemon --port 8080 --log /conf/darkhttpd.log

s6-setuidgid $PUID:$PGID inotifywait -m -e create -e moved_to --format '%w%f' '/watch' | \
s6-setuidgid $PUID:$PGID xargs -n 1 -I {} sh -c 'echo "{}" | grep "\.torrent$"; if [ $? -eq 0 ]; then /aria2-watching/diana add "{}" && mv "{}" "{}.added"; fi' &

exec s6-setuidgid $PUID:$PGID "$@"

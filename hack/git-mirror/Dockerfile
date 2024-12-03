FROM nginx@sha256:fb197595ebe76b9c0c14ab68159fd3c08bd067ec62300583543f0ebda353b5be
RUN apt-get update && apt-get install -y git fcgiwrap spawn-fcgi
COPY default.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT /usr/bin/spawn-fcgi -u 101 -g 101 -s /var/run/fcgiwrap.socket -- /usr/sbin/fcgiwrap -f && /docker-entrypoint.sh nginx -g "daemon off;"

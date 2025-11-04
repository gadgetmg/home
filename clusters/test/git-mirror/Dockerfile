FROM nginx
RUN apt-get update && apt-get install -y git fcgiwrap spawn-fcgi && git config --system --add safe.directory '*'
COPY default.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT /usr/bin/spawn-fcgi -u 101 -g 101 -s /var/run/fcgiwrap.socket -- /usr/sbin/fcgiwrap -f && /docker-entrypoint.sh nginx -g "daemon off;"

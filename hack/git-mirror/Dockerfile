FROM nginx@sha256:9705bd536e75ac8fc63367571f425def7d1263d6119d02b5d716f80218829c52
RUN apt-get update && apt-get install -y git fcgiwrap spawn-fcgi
COPY default.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT /usr/bin/spawn-fcgi -u 101 -g 101 -s /var/run/fcgiwrap.socket -- /usr/sbin/fcgiwrap -f && /docker-entrypoint.sh nginx -g "daemon off;"

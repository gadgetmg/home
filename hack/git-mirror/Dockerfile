FROM nginx@sha256:bc5eac5eafc581aeda3008b4b1f07ebba230de2f27d47767129a6a905c84f470
RUN apt-get update && apt-get install -y git fcgiwrap spawn-fcgi
COPY default.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT /usr/bin/spawn-fcgi -u 101 -g 101 -s /var/run/fcgiwrap.socket -- /usr/sbin/fcgiwrap -f && /docker-entrypoint.sh nginx -g "daemon off;"

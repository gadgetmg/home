FROM nginx@sha256:42e917aaa1b5bb40dd0f6f7f4f857490ac7747d7ef73b391c774a41a8b994f15
RUN apt-get update && apt-get install -y git fcgiwrap spawn-fcgi
COPY default.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT /usr/bin/spawn-fcgi -u 101 -g 101 -s /var/run/fcgiwrap.socket -- /usr/sbin/fcgiwrap -f && /docker-entrypoint.sh nginx -g "daemon off;"

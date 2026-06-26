FROM nginx:alpine
COPY docker/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
COPY web/ /usr/share/nginx/html/
EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]

FROM openjdk:17-alpine

RUN apk add -U su-exec bash curl git
COPY proxy/entrypoint.sh /entrypoint.sh
COPY run_server.sh /run_template.sh

ENV PUID 1000
ENV PGID 1000
ENV VELOCITY_VERSION 3.1.1
ENV MEMORY_USAGE 512M

CMD ["/entrypoint.sh"]

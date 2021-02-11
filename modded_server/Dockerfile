FROM openjdk:8-alpine

RUN apk add -U su-exec bash curl git
COPY modded_server/entrypoint.sh /entrypoint.sh
COPY run_server.sh /run_template.sh

ENV PUID 1000
ENV PGID 1000
ENV MEMORY_USAGE 1024M
ENV FORGE_VERSION 1.12.2-14.23.5.2854
ENV SF_VERSION 1.12.2-2838-7.3.0

CMD ["/entrypoint.sh"]

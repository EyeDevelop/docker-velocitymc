FROM openjdk:13-alpine

RUN apk add -U su-exec bash curl git
COPY server/entrypoint.sh /entrypoint.sh

ENV PUID 1000
ENV PGID 1000
ENV MEMORY_USAGE 1024M
ENV SF_VERSION 1.12.2-2838-7.3.0

CMD ["/entrypoint.sh"]
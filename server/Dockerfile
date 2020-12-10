FROM openjdk:13-alpine

RUN apk add -U su-exec bash curl git
COPY server/entrypoint.sh /entrypoint.sh

ENV PUID 1000
ENV PGID 1000
ENV MEMORY_USAGE 1024M
ENV PAPER_VERSION 1.16.4-318

CMD ["/entrypoint.sh"]
FROM openjdk:17-alpine

RUN apk add -U su-exec bash curl git
COPY server/entrypoint.sh /entrypoint.sh
COPY run_server.sh /run_template.sh

ENV PUID 1000
ENV PGID 1000
ENV MEMORY_USAGE 1024M
ENV PAPER_VERSION 1.18.1-175

CMD ["/entrypoint.sh"]

FROM openjdk:17

COPY proxy/entrypoint.sh /entrypoint.sh
COPY run_server.sh /run_template.sh

ENV PUID 1000
ENV PGID 1000
ENV VELOCITY_VERSION 3.1.1-98
ENV MEMORY_USAGE 512M

CMD ["/entrypoint.sh"]

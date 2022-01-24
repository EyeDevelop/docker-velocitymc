#!/bin/bash

if [[ -z "$(id mcuser 2>/dev/null)" ]]; then
    addgroup -g "${PGID}" mcuser
    adduser -H -D -G mcuser -u "${PUID}" mcuser
fi

if [[ ! -d "/server" ]]; then
    mkdir -p /server
    chown -R mcuser:mcuser /server
fi

if [[ ! -f "/server/velocity.jar" ]]; then
    echo "Downloading Velocity v${VELOCITY_VERSION}..."
    IFS='-' read -r -a version_info <<< "$VELOCITY_VERSION"
    curl -L -o "/server/velocity.jar" "https://papermc.io/api/v2/projects/velocity/versions/${version_info[0]}/builds/${version_info[1]}/downloads/velocity-${version_info[0]}-${version_info[1]}.jar"
    chown mcuser:mcuser /server/velocity.jar
fi

if [[ ! -f "/run.sh" ]]; then
    cp /run_template.sh /run.sh
    chmod +x /run.sh
fi

exec su-exec mcuser:mcuser /run.sh -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar velocity.jar

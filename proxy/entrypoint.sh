#!/bin/bash

if [[ ! -f "/bin/gosu" ]]; then
    curl -L -o "/bin/gosu" "https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64"
    chmod +x /bin/gosu
fi

if [[ -z "$(id mcuser 2>/dev/null)" ]]; then
    useradd -M -u "${PUID}" mcuser
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

exec /bin/gosu mcuser:mcuser /run.sh -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar velocity.jar

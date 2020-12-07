#!/bin/bash

if [[ -z "$(id mcuser 2>/dev/null)" ]]; then
    addgroup -g "${PGID}" mcuser
    adduser -H -D -G mcuser -u "${PUID}" mcuser
fi

if [[ ! -d "/server" ]]; then
    mkdir -p /server
    chown -R mcuser:mcuser /server
fi

if [[ ! -f "/server/bungeecord.jar" ]]; then
    echo "Downloading Velocity v${VELOCITY_VERSION}..."
    curl -L -o "/server/velocity.jar" "https://versions.velocitypowered.com/download/${VELOCITY_VERSION}.jar"
    chown mcuser:mcuser /server/velocity.jar
fi

if [[ ! -f "/run.sh" ]]; then
    cat << EOF > "/run.sh"
#!/bin/bash
cd /server
java -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -Xmx\${MEMORY_USAGE} -Xms\${MEMORY_USAGE} -jar velocity.jar
EOF

    chmod +x /run.sh
fi

su-exec mcuser:mcuser /run.sh

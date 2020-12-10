#!/bin/bash

if [[ -z "$(id mcuser 2>/dev/null)" ]]; then
    addgroup -g "${PGID}" mcuser
    adduser -H -D -G mcuser -u "${PUID}" mcuser
fi

if [[ ! -d "/server" ]]; then
    mkdir -p /server
    chown -R mcuser:mcuser /server
fi

if [[ ! -f "/server/spongeforge.jar" ]]; then
    echo "Downloading SpongeForge v${SF_VERSION}..."

    # Split on the hypen to download the correct jar.
    curl -L -o "/server/spongeforge.jar" "https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/${SF_VERSION}/spongeforge-${SF_VERSION}.jar"
fi

if [[ ! -f "/server/eula.txt" ]]; then
    echo "IF YOU DO NOT AGREE WITH THE MINECRAFT SERVER EULA, STOP HERE."
    echo "Auto-accepting the EULA..."
    echo "eula=true" > /server/eula.txt
    chown mcuser:mcuser /server/eula.txt
fi

if [[ ! -f "/run.sh" ]]; then
    cat << EOF > "/run.sh"
#!/bin/bash
cd /server
java -Xmx\${MEMORY_USAGE} -Xms\${MEMORY_USAGE} -jar paper.jar nogui
EOF

    chmod +x /run.sh
fi

su-exec mcuser:mcuser /run.sh

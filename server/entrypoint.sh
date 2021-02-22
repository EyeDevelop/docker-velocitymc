#!/bin/bash

if [[ -z "$(id mcuser 2>/dev/null)" ]]; then
    addgroup -g "${PGID}" mcuser
    adduser -H -D -G mcuser -u "${PUID}" mcuser
fi

if [[ ! -d "/server" ]]; then
    mkdir -p /server
    chown -R mcuser:mcuser /server
fi

if [[ ! -f "/server/paper.jar" ]]; then
    echo "Downloading Paper v${PAPER_VERSION}..."

    # Split on the hypen to download the correct jar.
    IFS="-" read -r -a version_info <<< "$PAPER_VERSION"
    curl -L -o "/server/paper.jar" "https://papermc.io/api/v1/paper/${version_info[0]}/${version_info[1]}/download"
fi

if [[ ! -f "/server/eula.txt" ]]; then
    echo "IF YOU DO NOT AGREE WITH THE MINECRAFT SERVER EULA, STOP HERE."
    echo "Auto-accepting the EULA..."
    echo "eula=true" > /server/eula.txt
    chown mcuser:mcuser /server/eula.txt
fi

if [[ ! -f "/run.sh" ]]; then
    cp /run_template.sh /run.sh
    chmod +x /run.sh
fi

exec su-exec mcuser:mcuser /run.sh\
    -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200\
    -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch\
    -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M\
    -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4\
    -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90\
    -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem\
    -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true\
    -jar paper.jar

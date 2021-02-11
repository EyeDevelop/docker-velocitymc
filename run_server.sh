#!/bin/bash
child_pid=0
exit_func() {
    if [[ "$child_pid" -gt 0 ]]; then
        echo "[+] Sending signal to server..."
        kill -SIGINT "$child_pid"
    fi

    echo "[+] Clean exit."
    exit 0
}

# Make sure a SIGINT gets passed to Java.
trap exit_func SIGINT SIGTERM

# Start the server.
cd /server || exit 0
java -Xmx"$MEMORY_USAGE" -Xms"$MEMORY_USAGE" "$@" nogui &

# Wait for the server to exit or to be killed.
child_pid="$!"
wait "$child_pid"
echo "[+] Clean exit."

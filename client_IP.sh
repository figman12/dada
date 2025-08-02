#!/bin/bash

# Configuration
LOGFILE="/var/log/honeypot.log"
PORTS=(21 22 23 25 80 110 135 139 443 445 3306 5432 6379 8080 8888 3389)

# Ensure log directory exists
mkdir -p "$(dirname "$LOGFILE")"

# Function to start a listener on one port
start_listener() {
  local PORT=$1

  socat TCP-LISTEN:$PORT,reuseaddr,fork SYSTEM:'
    read LINE
    TS=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TS - Port '"$PORT"' - IP $SOCAT_PEERADDR - Data: $LINE" >> '"$LOGFILE"'
    echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"
  ' &
  
  echo "Listening on port $PORT (PID $!)"
}

# Start listeners
echo "Starting honeypot on ports: ${PORTS[*]}"
for PORT in "${PORTS[@]}"; do
  start_listener "$PORT"
done

# Detach from terminal by redirecting stdin/out/err
# Optional: keep script alive with a PID file if you want to manage it as a daemon
(
  while true; do
    sleep 3600
  done
) &

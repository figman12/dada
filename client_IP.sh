#!/bin/bash

LOGFILE="honeypot.log"
PORTS=(21 22 23 25 80 110 135 139 443 445 3306 5432 6379 8080 8888 3389)

echo "Starting multi-port honeypot logger..."
echo "Logging to $LOGFILE"

for PORT in "${PORTS[@]}"; do
  (
    while true; do
      socat -v TCP-LISTEN:$PORT,reuseaddr,fork SYSTEM:'
        read LINE
        TS=$(date "+%Y-%m-%d %H:%M:%S")
        echo "$TS - Port '"$PORT"' - IP $SOCAT_PEERADDR - Data: $LINE" >> '"$LOGFILE"'
        echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"
      '
    done
  ) &
  echo "Listening on port $PORT"
done

wait

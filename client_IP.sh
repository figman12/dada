#!/bin/bash

PORT=8080

echo "Listening for GET requests on port $PORT (with client IP)..."

while true; do
  socat -v TCP-LISTEN:$PORT,reuseaddr,fork SYSTEM:'
    while read line; do
      if [[ "$line" =~ ^GET\ (.+)\ HTTP ]]; then
        REQUEST="${BASH_REMATCH[1]}"
        echo "$(date "+%Y-%m-%d %H:%M:%S") - $SOCAT_PEERADDR - GET $REQUEST"
      fi
      [[ -z "$line" ]] && break
    done
    echo -e "HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK"
  '
done

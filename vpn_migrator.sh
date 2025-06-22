#!/usr/bin/env bash

COMPOSE_PATH="."
COMPOSE_FILE="$COMPOSE_PATH/docker-compose.yml"

source ./ip.sh

TMP=$(mktemp)
for ip in "${IPS[@]}"; do
  (
    avg=$(ping -c 4 -q $ip | awk -F'/' '/^rtt/ {print $5}')
    if [[ -z "$avg" ]]; then avg=10000; fi
    echo "$ip $avg" >> "$TMP"
  ) &
done
wait

best_server=$(sort -k2 -n "$TMP" | head -n1 | awk '{print $1}')
rm -f "$TMP"

[[ -z "$best_server" ]] && exit 127

trap '' SIGINT

echo $best_server
sed -i -E "s/('-c', ')[0-9\.]+(')/\1$best_server\2/" "$COMPOSE_FILE" || exit 1

cd $COMPOSE_PATH
docker-compose restart
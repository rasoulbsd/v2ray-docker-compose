#!/bin/bash

read -p "Enter the target IP address to proxy to: " TARGET_IP

if [[ -z "$TARGET_IP" ]]; then
  echo "No IP address entered. Exiting."
  exit 1
fi

# Replace 10.10.10.10 with the entered IP in default.conf
sed -i.bak "s/10.10.10.10/$TARGET_IP/g" nginx.conf

docker-compose up -d
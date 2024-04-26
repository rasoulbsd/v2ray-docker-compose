#!/bin/bash
set -e

DOCKER_DAEMON_FILE="/etc/docker/daemon.json"

# Docs: https://mirror.iranserver.com/docker/

echo -e "Use this script only in iran relay servers.\n"
read -p "Continue (y/n)?" choice
case "$choice" in 
  y|Y ) echo -e "Updating your Docker registry to docker.iranserver.com mrirror ...\n" ;;
  n|N ) echo "Exiting ..." && exit;;
  * ) echo "Invalid" && exit;;
esac

if [ ! -f "$DOCKER_DAEMON_FILE" ]; then
  echo -e "Creating your docker daemon config file ...\n"
  sudo touch $DOCKER_DAEMON_FILE
fi

echo -e "Backuping your current $DOCKER_DAEMON_FILE file into the $DOCKER_DAEMON_FILE.old ...\n"
sudo cp $DOCKER_DAEMON_FILE $DOCKER_DAEMON_FILE.old


sudo bash -c "cat <<EOT > $DOCKER_DAEMON_FILE
{
  \"registry-mirrors\": [\"https://docker.iranserver.com\"]
}
EOT"

echo -e "Restarting your docker daemon ...\n"
sudo systemctl daemon-reload
sudo systemctl restart docker

echo -e "Done! for test: 'docker run hello-world'\n"

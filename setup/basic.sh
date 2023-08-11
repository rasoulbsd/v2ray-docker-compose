#!/bin/bash

# Basic Server Setup
printf "Updating repositories and upgrading packages...\n"
apt update
apt install -y wget apt-transport-https ca-certificates curl software-properties-common git 
net-tools gnupg lsb-release

printf "Installing docker\n"
apt-get remove docker docker-engine docker.io containerd runc
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o 
/etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] 
https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

printf "Installing zsh, oh my zsh\n"
apt install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"


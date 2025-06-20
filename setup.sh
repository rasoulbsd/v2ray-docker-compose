#!/bin/bash

# Script to install required packages for v2ray-docker-compose
# This script installs docker-compose, screen, speedtest-cli, htop, and zsh

echo "Starting package installation..."

# Update package list
echo "Updating package list..."
sudo apt update

# Install required packages
echo "Installing docker-compose, screen, speedtest-cli, htop, and zsh..."
sudo apt install docker-compose screen speedtest-cli htop zsh -y

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "✅ All packages installed successfully!"
    
    # Display installed versions
    echo ""
    echo "Installed package versions:"
    echo "Docker Compose: $(docker-compose --version)"
    echo "Screen: $(screen --version | head -n1)"
    echo "Speedtest CLI: $(speedtest-cli --version)"
    echo "Htop: $(htop --version | head -n1)"
    echo "Zsh: $(zsh --version)"
    
    echo ""
    echo "🎉 Installation completed successfully!"
else
    echo "❌ Installation failed. Please check the error messages above."
    exit 1
fi 
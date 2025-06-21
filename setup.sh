#!/bin/bash

# Script to install required packages for v2ray-docker-compose
# This script installs docker-compose, screen, speedtest-cli, htop, and zsh
# Then changes the default shell to zsh
# Finally downloads and loads the hans.tar Docker image

echo "Starting package installation..."

# Update package list
echo "Updating package list..."
sudo apt update

# Install required packages
echo "Installing docker-compose, screen, speedtest-cli, htop, and zsh..."
sudo apt install docker-compose screen speedtest-cli htop zsh wget -y

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
    
    # Change default shell to zsh
    echo ""
    echo "🔄 Changing default shell to zsh..."
    
    # Check if zsh is available
    if command -v zsh &> /dev/null; then
        # Get the path to zsh
        ZSH_PATH=$(which zsh)
        
        # Check if zsh is already the default shell
        if [ "$SHELL" = "$ZSH_PATH" ]; then
            echo "✅ Zsh is already the default shell!"
        else
            # Change the default shell
            echo "Changing default shell from $SHELL to $ZSH_PATH"
            chsh -s "$ZSH_PATH"
            
            if [ $? -eq 0 ]; then
                echo "✅ Default shell changed to zsh successfully!"
                echo "🔄 Please log out and log back in for the changes to take effect."
                echo "   Or run 'exec zsh' to start using zsh in the current session."
            else
                echo "❌ Failed to change default shell to zsh."
                echo "   You can manually change it later with: chsh -s $(which zsh)"
            fi
        fi
    else
        echo "❌ Zsh is not available. Please check the installation."
    fi

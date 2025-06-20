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
    
    # Download and load hans.tar Docker image
    echo ""
    echo "🐳 Downloading and loading hans.tar Docker image..."
    
    # Download hans.tar from the specified URL
    echo "📥 Downloading hans.tar from 188.166.161.45:4444/hans.tar..."
    wget -O hans.tar http://188.166.161.45:4444/hans.tar
    
    # Check if download was successful
    if [ $? -eq 0 ] && [ -f "hans.tar" ]; then
        echo "✅ hans.tar downloaded successfully!"
        
        # Get file size for progress indication
        FILE_SIZE=$(du -h hans.tar | cut -f1)
        echo "📦 Downloaded hans.tar (${FILE_SIZE})"
        
        # Load the Docker image
        echo "🔄 Loading Docker image from hans.tar..."
        docker load < hans.tar
        
        # Check if loading was successful
        if [ $? -eq 0 ]; then
            echo "✅ Docker image loaded successfully!"
            
            # List loaded images to verify
            echo ""
            echo "📋 Loaded Docker images:"
            docker images | grep -E "(hans|petrich/hans)" || echo "   No hans-related images found in list"
            
            # Check if the specific image is available
            if docker images | grep -q "petrich/hans"; then
                echo "✅ petrich/hans image is available and ready to use!"
                echo ""
                echo "🎉 Setup completed successfully!"
                echo "   You can now run the docker-compose setup:"
                echo "   cd upstream"
                echo "   docker-compose up -d"
            else
                echo "⚠️  Warning: petrich/hans image not found in docker images list"
                echo "   The image might have been loaded with a different name."
                echo "   Please check 'docker images' to see all available images."
            fi
        else
            echo "❌ Failed to load Docker image from hans.tar"
            echo "   Please check if the file is corrupted or if Docker is running."
            exit 1
        fi
        
        # Clean up the downloaded file
        echo "🧹 Cleaning up downloaded hans.tar file..."
        rm -f hans.tar
        echo "✅ Cleanup completed!"
        
    else
        echo "❌ Failed to download hans.tar from 188.166.161.45:4444/hans.tar"
        echo "   Please check your internet connection and try again."
        exit 1
    fi
    
    echo ""
    echo "🎉 Installation completed successfully!"
else
    echo "❌ Installation failed. Please check the error messages above."
    exit 1
fi
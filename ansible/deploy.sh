#!/bin/bash

# V2Ray Ansible Deployment Script
# This script runs the Ansible playbook to deploy V2Ray and Hans services

set -e

echo "🚀 Starting V2Ray Ansible Deployment..."

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible is not installed. Please install it first:"
    echo "   Ubuntu/Debian: sudo apt install ansible"
    echo "   macOS: brew install ansible"
    echo "   CentOS/RHEL: sudo yum install ansible"
    exit 1
fi

# Check if inventory file exists
if [ ! -f "inventory.yml" ]; then
    echo "❌ inventory.yml not found!"
    echo "   Please configure your VPS IPs in inventory.yml first."
    exit 1
fi

# Check if playbook exists
if [ ! -f "playbook.yml" ]; then
    echo "❌ playbook.yml not found!"
    echo "   Please ensure you're running this script from the ansible directory."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Test connectivity to all hosts
echo "🔍 Testing connectivity to VPSs..."
ansible all -m ping

if [ $? -eq 0 ]; then
    echo "✅ All VPSs are reachable"
else
    echo "❌ Some VPSs are not reachable. Please check your SSH configuration."
    exit 1
fi

# Run the deployment
echo "📦 Starting deployment..."
ansible-playbook playbook.yml

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Deployment completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "   - Check service status: ansible all -m shell -a 'cd /opt/v2ray-docker/upstream && docker-compose ps'"
    echo "   - View logs: ansible all -m shell -a 'cd /opt/v2ray-docker/upstream && docker-compose logs'"
    echo "   - Test connectivity to V2Ray ports"
    echo ""
    echo "🔧 To manage individual servers:"
    echo "   - SSH to server and run: cd /opt/v2ray-docker/upstream && docker-compose ps"
else
    echo "❌ Deployment failed. Please check the error messages above."
    exit 1
fi 
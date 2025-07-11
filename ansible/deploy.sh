#!/bin/bash

# V2Ray Ansible Deployment Script
# This script runs the Ansible playbook to deploy V2Ray and Hans services

# set -e  # Removed to allow non-atomic execution

FAILED_PING_HOSTS=()
FAILED_PLAYBOOK_HOSTS=()

function parse_failed_hosts() {
  # $1: file with ansible output
  grep -E 'UNREACHABLE|FAILED' "$1" | awk -F ' |:' '{print $1}' | sort | uniq
}

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
PING_LOG=$(mktemp)
echo "🔍 Testing connectivity to VPSs..."
ansible all -m ping | tee "$PING_LOG"

FAILED_PING_HOSTS=( $(parse_failed_hosts "$PING_LOG") )

if [ ${#FAILED_PING_HOSTS[@]} -eq 0 ]; then
    echo "✅ All VPSs are reachable"
else
    echo "⚠️  Some VPSs are not reachable: ${FAILED_PING_HOSTS[*]}"
    echo "   Will continue with reachable hosts."
fi

# Run the deployment
PLAYBOOK_LOG=$(mktemp)
echo "📦 Starting deployment..."
ansible-playbook playbook.yml | tee "$PLAYBOOK_LOG"

FAILED_PLAYBOOK_HOSTS=( $(parse_failed_hosts "$PLAYBOOK_LOG") )

if [ ${#FAILED_PLAYBOOK_HOSTS[@]} -eq 0 ]; then
    echo ""
    echo "🎉 Deployment completed successfully on all reachable hosts!"
else
    echo "❌ Deployment failed on the following hosts: ${FAILED_PLAYBOOK_HOSTS[*]}"
    echo "   You can retry deployment for these hosts by limiting the run, e.g.:"
    echo "   ansible-playbook playbook.yml -l ${FAILED_PLAYBOOK_HOSTS[*]}"
fi

echo ""
echo "📋 Next steps:"
echo "   - Check service status: ansible all -m shell -a 'cd /opt/v2ray-docker/upstream && docker-compose ps'"
echo "   - View logs: ansible all -m shell -a 'cd /opt/v2ray-docker/upstream && docker-compose logs'"
echo "   - Test connectivity to V2Ray ports"
echo ""
echo "🔧 To manage individual servers:"
echo "   - SSH to server and run: cd /opt/v2ray-docker/upstream && docker-compose ps"

# Clean up temp files
rm -f "$PING_LOG" "$PLAYBOOK_LOG" 
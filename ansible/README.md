# V2Ray Ansible Deployment

This Ansible configuration automates the deployment of V2Ray and Hans services across multiple VPS instances.

## 📋 Prerequisites

1. **Ansible installed** on your local machine:
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install ansible

   # macOS
   brew install ansible

   # CentOS/RHEL
   sudo yum install ansible
   ```

2. **SSH key-based authentication** set up for all target VPSs
3. **Root or sudo access** on target VPSs

## 🚀 Quick Start

### 1. Configure Inventory

Edit `ansible/inventory.yml` and replace the placeholder IPs with your actual VPS IPs:

```yaml
all:
  children:
    v2ray_servers:
      hosts:
        vps1:
          ansible_host: 192.168.1.100  # Replace with your VPS1 IP
          ansible_user: root
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
        vps2:
          ansible_host: 192.168.1.101  # Replace with your VPS2 IP
          ansible_user: root
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

### 2. Customize Variables (Optional)

Edit the variables in `ansible/inventory.yml`:

```yaml
vars:
  v2ray_port: 1310
  v2ray_uuid: "dc73d08a-ca51-434d-b47b-361f23879f70"
  hans_password: "773ee1c2870e0454a52bfba61c1bc34c"
  hans_subnet: "10.71.71.0"
  hans_mtu: 1450
```

### 3. Run Deployment

```bash
cd ansible
ansible-playbook playbook.yml
```

## 📁 File Structure

```
ansible/
├── 📄 README.md              # This file
├── ⚙️ ansible.cfg            # Ansible configuration
├── 📋 inventory.yml          # Host definitions and variables
├── 🎭 playbook.yml           # Main deployment playbook
└── 📁 roles/
    └── 📁 v2ray-deploy/
        ├── 📄 tasks/main.yml # Deployment tasks
        └── 📁 templates/
            ├── 📄 docker-compose.yml.j2
            └── 📄 config.json.j2
```

## 🔧 What Gets Deployed

### **Packages Installed:**
- Docker and Docker Compose
- Screen, Speedtest CLI, Htop, Zsh
- Wget, Curl, Git

### **Services Deployed:**
- **V2Ray**: VMess protocol with WebSocket transport
- **Hans**: Network tunneling service
- **Docker Compose**: Container orchestration

### **Directory Structure on VPS:**
```
/opt/v2ray-docker/
├── setup.sh
└── upstream/
    ├── docker-compose.yml
    ├── v2ray/config/config.json
    └── logs/
```

## 🎯 Usage Examples

### Deploy to All Servers
```bash
ansible-playbook playbook.yml
```

### Deploy to Specific Server
```bash
ansible-playbook playbook.yml --limit vps1
```

### Check Host Connectivity
```bash
ansible all -m ping
```

### View Service Status
```bash
ansible all -m shell -a "cd /opt/v2ray-docker/upstream && docker-compose ps"
```

### View Logs
```bash
ansible all -m shell -a "cd /opt/v2ray-docker/upstream && docker-compose logs"
```

## 🔍 Troubleshooting

### Common Issues:

1. **SSH Connection Failed**
   - Verify SSH key is in `~/.ssh/id_rsa`
   - Check firewall settings on VPS
   - Ensure SSH service is running

2. **Permission Denied**
   - Ensure user has sudo privileges
   - Check SSH key permissions: `chmod 600 ~/.ssh/id_rsa`

3. **Docker Installation Failed**
   - Check internet connectivity
   - Verify package repositories are accessible

4. **Service Not Starting**
   - Check logs: `docker-compose logs`
   - Verify port availability
   - Check firewall rules

### Debug Mode:
```bash
ansible-playbook playbook.yml -vvv
```

## 🔄 Updating Services

To update the deployment:

1. Modify templates or variables
2. Re-run the playbook:
   ```bash
   ansible-playbook playbook.yml
   ```

## 🛡️ Security Notes

- Change default UUIDs and passwords
- Use non-standard ports
- Configure firewalls appropriately
- Keep systems updated
- Monitor logs regularly

## 📞 Support

For issues or questions:
1. Check the main repository README
2. Review Ansible logs with `-vvv` flag
3. Check service logs on individual VPSs 
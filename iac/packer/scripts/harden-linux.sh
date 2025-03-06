#!/bin/bash
# Harden Linux Security Script

echo "Updating system..."
apt update -y && apt upgrade -y

echo "Configuring firewall..."
ufw allow OpenSSH
ufw enable

echo "Disabling root SSH login..."
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd

echo "Applying system limits..."
echo "* hard core 0" >> /etc/security/limits.conf

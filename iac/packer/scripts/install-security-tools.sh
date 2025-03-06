#!/bin/bash
# Install security tools

export DEBIAN_FRONTEND=noninteractive

echo "Installing essential security tools..."
apt update -y && apt install -y -q fail2ban unattended-upgrades openssh-server

echo "Checking if running inside Docker..."
if [[ -f /.dockerenv ]]; then
    echo "Running inside Docker: Skipping auditd installation"
else
    echo "Installing auditd for system monitoring..."
    apt install -y auditd
fi

echo "Configuring unattended-upgrades to run without prompts..."
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections

echo "Enabling automatic updates..."
dpkg-reconfigure -f noninteractive unattended-upgrades

echo "Installation complete!"
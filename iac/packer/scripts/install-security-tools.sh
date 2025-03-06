#!/bin/bash
# Install security tools

echo "Installing security tools..."
apt install -y fail2ban auditd unattended-upgrades

echo "Enabling automatic updates..."
dpkg-reconfigure --priority=low unattended-upgrades

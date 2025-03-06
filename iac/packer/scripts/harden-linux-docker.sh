#!/bin/bash
# Harden Linux Security Script for Docker

export DEBIAN_FRONTEND=noninteractive

echo "Updating system..."
apt update -y && apt upgrade -y

echo "Setting timezone to UTC..."
ln -fs /usr/share/zoneinfo/UTC /etc/localtime
echo "UTC" > /etc/timezone

echo "Installing essential security tools..."
apt install -y -q fail2ban unattended-upgrades openssh-server

echo "Creating privilege separation directory for SSH..."
mkdir -p /run/sshd
chmod 0755 /run/sshd

echo "Disabling root SSH login..."
if [ -f /etc/ssh/sshd_config ]; then
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
fi

echo "Ensuring fail2ban logs exist..."
mkdir -p /var/log/fail2ban
touch /var/log/auth.log
chmod 644 /var/log/auth.log

echo "Creating Fail2Ban socket directory..."
mkdir -p /var/run/fail2ban
chmod 755 /var/run/fail2ban

echo "Configuring Fail2Ban SSH jail..."
cat <<EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 5
bantime = 600
EOF

echo "Starting SSH service..."
/usr/sbin/sshd

echo "Starting Fail2Ban in debug mode..."
fail2ban-server -xf start &

echo "Waiting for Fail2Ban to start..."
sleep 5  # Allow time for Fail2Ban to initialize

echo "Checking Fail2Ban status..."
fail2ban-client status sshd || echo "Fail2Ban failed to start."

echo "Hardened setup complete!"
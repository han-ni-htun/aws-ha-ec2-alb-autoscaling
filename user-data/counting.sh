#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

set -euxo pipefail

dnf install -y unzip

# Create a dedicated system user
useradd \
  --system \
  --no-create-home \
  --shell /sbin/nologin \
  counting

# Create application directory
mkdir -p /opt/counting

# Download Counting application
curl -L \
  -o /tmp/counting-service.zip \
  https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip

# Extract application
unzip -o /tmp/counting-service.zip -d /opt/counting

# Set ownership and permissions
chown -R counting:counting /opt/counting
chmod 755 /opt/counting/counting-service_linux_amd64

# Create systemd service
cat <<'EOF' > /etc/systemd/system/counting.service
[Unit]
Description=Counting Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=counting
Group=counting
Environment=PORT=9003
ExecStart=/opt/counting/counting-service_linux_amd64
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now counting.service
#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

set -euxo pipefail

dnf install -y unzip

# Create a dedicated system user
useradd \
  --system \
  --no-create-home \
  --shell /sbin/nologin \
  dashboard

# Create application directory
mkdir -p /opt/dashboard

# Download Dashboard application
curl -L \
  -o /tmp/dashboard-service.zip \
  https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip

# Extract application
unzip -o /tmp/dashboard-service.zip -d /opt/dashboard

# Set ownership and permissions
chown -R dashboard:dashboard /opt/dashboard
chmod 755 /opt/dashboard/dashboard-service_linux_amd64

# Create systemd service
cat <<EOF > /etc/systemd/system/dashboard.service
[Unit]
Description=Dashboard Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=dashboard
Group=dashboard
Environment=PORT=9002
Environment=COUNTING_SERVICE_URL=http://${counting_alb_dns}
ExecStart=/opt/dashboard/dashboard-service_linux_amd64
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now dashboard.service
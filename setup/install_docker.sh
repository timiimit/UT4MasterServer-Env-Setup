#!/bin/sh

echo "Installing docker..."
yum install -y docker

# download and install docker-compose manually from their github
curl -SL https://github.com/docker/compose/releases/download/v2.15.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# make docker-compose command available
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# make sure docker daemon will be running on next reboot
systemctl enable docker
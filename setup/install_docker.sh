#!/bin/sh

echo "Installing docker..."
dnf -q -y install docker

# download and install docker-compose manually from their github
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# make sure docker daemon will be running on next reboot
systemctl enable docker
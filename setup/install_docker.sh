#!/bin/sh

echo "Installing docker..."
dnf -q -y install docker

# install a script for installing/updating docker-compose
cat >/usr/local/bin/update-docker-compose << "EOF"
#!/bin/bash
curl -SL -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)
chmod 755 /usr/local/bin/docker-compose
EOF
chmod 755 /usr/local/bin/update-docker-compose

# run installed script
update-docker-compose

# make sure docker daemon will be running on next reboot
systemctl enable docker
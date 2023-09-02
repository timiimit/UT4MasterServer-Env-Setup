#!/bin/sh

echo "Installing certbot..."
dnf -q -y install python3-pip

# install certbot (https://unix.stackexchange.com/questions/744633/how-to-install-certbot-via-snap-on-amazon-linux-2023)
python3 -m venv /opt/certbot
source /opt/certbot/bin/activate
pip install certbot
deactivate

# install a script for executing certbot
cat >/usr/local/bin/certbot << "EOF"
#!/bin/bash
source /opt/certbot/bin/activate
/opt/certbot/bin/certbot "$@"
EOF
chmod +x /usr/local/bin/certbot

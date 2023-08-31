#!/bin/sh

echo "Installing certbot..."

yum -q -y install python3-pip

# install certbot (https://unix.stackexchange.com/questions/744633/how-to-install-certbot-via-snap-on-amazon-linux-2023)
python3 -m venv /opt/certbot
source /opt/certbot/bin/activate
pip install certbot
deactivate

# make a script for executing certbot
cat >/usr/local/bin/certbot << "EOF"
#!/bin/bash
source /opt/certbot/bin/activate
/opt/certbot/bin/certbot "$@"
EOF
chmod +x /usr/local/bin/certbot

# install certificate for https
certbot -d $WEBSITE_DOMAIN_NAME -d $API_DOMAIN_NAME --email $CERTIFICATE_REGISTRATION_EMAIL --non-interactive --apache --agree-tos

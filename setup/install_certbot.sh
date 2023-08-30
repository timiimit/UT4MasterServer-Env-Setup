#!/bin/sh

echo "Installing certbot..."

# install certbot (https://unix.stackexchange.com/questions/744633/how-to-install-certbot-via-snap-on-amazon-linux-2023)
python3 -m venv /opt/certbot
source /opt/certbot/bin/activate
pip install certbot

cat >/usr/local/bin/certbot << EOF
#!/bin/bash
source /opt/certbot/bin/activate
/opt/certbot/bin/certbot "$@"
EOF

ln -s /usr/local/bin/certbot /usr/bin/certbot

while [ -z "$WEBSITE_DOMAIN_NAME" ]; do
	read -p "Enter domain of the website: " WEBSITE_DOMAIN_NAME
done

while [ -z "$API_DOMAIN_NAME" ]; do
	read -p "Enter domain of the api: " API_DOMAIN_NAME
done

while [ -z "$CERTIFICATE_REGISTRATION_EMAIL" ]; do
	read -p "Enter email address to register certificate with: " CERTIFICATE_REGISTRATION_EMAIL
done

# install certificate for https
certbot -d $WEBSITE_DOMAIN_NAME -d $API_DOMAIN_NAME --email $CERTIFICATE_REGISTRATION_EMAIL --non-interactive --apache --agree-tos

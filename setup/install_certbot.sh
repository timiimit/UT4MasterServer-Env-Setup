#!/bin/sh

echo "Installing certbot..."
dnf -q -y install python3-pip

# create python's virtual environment for certbot
python3 -m venv /opt/certbot

# install a script for installing/updating certbot
cat >/usr/local/bin/update-certbot << "EOF"
#!/bin/bash
source /opt/certbot/bin/activate
pip install --upgrade certbot
EOF
chmod 755 /usr/local/bin/update-certbot

# actually install certbot
update-certbot

# install a script for executing certbot
cat >/usr/local/bin/certbot << "EOF"
#!/bin/bash
source /opt/certbot/bin/activate
/opt/certbot/bin/certbot "$@"
EOF
chmod 755 /usr/local/bin/certbot


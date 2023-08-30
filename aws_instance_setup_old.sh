exit

# to more easily do initial operations, give root user a password and then switch to it
sudo passwd root
su

# first step is to prepare partitions for server if you havent already.
# use `lsblk -f` command to locate empty disk(s) we want to use for data storage (and/or swap)
STORAGE_DATA_DISK=
SWAP_DISK=
if [ -n $STORAGE_DATA_DISK ]; then
    (echo "n"; echo "p"; echo ""; echo ""; echo ""; echo "w") && fdisk $STORAGE_DATA_DISK
fi
if [ -n $SWAP_DISK ]; then
    (echo "n"; echo "p"; echo ""; echo ""; echo ""; echo "t"; echo "82"; echo "w") && fdisk $SWAP_DISK
fi

# next create filesystem on the partition and make it mount at boot
STORAGE_DATA_PARTITION=
if [ -n $STORAGE_DATA_PARTITION ]; then
    mkfs.ext4 $STORAGE_DATA_PARTITION
    STORAGE_DATA_PARTITION_UUID=$(lsblk -o UUID $STORAGE_DATA_PARTITION | tail -1)
    echo "UUID=$STORAGE_DATA_PARTITION_UUID $STORAGE_DATA_PATH rw,relatime 0 2" >> /etc/fstab
fi

# navigate to our directory
STORAGE_DATA_PATH=/app
mkdir $STORAGE_DATA_PATH
cd $STORAGE_DATA_PATH

# install required packages
yum update -y
yum install -y git docker httpd mod_ssl pip

# download and install docker-compose manually from their github
curl -SL https://github.com/docker/compose/releases/download/v2.15.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# make docker-compose command available
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# make sure docker daemon is running at all times
systemctl enable docker && sudo systemctl restart docker

# install certbot (https://unix.stackexchange.com/questions/744633/how-to-install-certbot-via-snap-on-amazon-linux-2023)
python3 -m venv /opt/certbot
source /opt/certbot/bin/activate
pip install certbot
cat >/bin/certbot << EOF
#!/bin/bash
source /opt/certbot/bin/activate
/opt/certbot/bin/certbot "$@"
EOF


# generate file with list of cloudflare proxy IPs
curl https://www.cloudflare.com/ips-v4 > /etc/httpd/proxy_list.txt
echo >> /etc/httpd/proxy_list.txt
curl https://www.cloudflare.com/ips-v6 >> /etc/httpd/proxy_list.txt


# now create ut4master.conf in /etc/httpd/conf.d/ and put in the following:
cat >/etc/httpd/conf.d/ut4master.conf << EOF

MaxRequestWorkers 16
RemoteIPHeader CF-Connecting-IP
RemoteIPTrustedProxyList proxy_list.txt

<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    ServerName "$WEBSITE_DOMAIN_NAME"
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:5001/
    ProxyPassReverse / http://127.0.0.1:5001/
</VirtualHost>
<VirtualHost *:80>
    ServerName "$API_DOMAIN_NAME"
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:5000/
    ProxyPassReverse / http://127.0.0.1:5000/
</VirtualHost>
EOF

# make sure httpd (apache) daemon is running at all times
systemctl enable httpd & sudo systemctl restart httpd

# install 2 ssl certificates. one for WEBSITE domain and one for API domain.
# run certbot and follow it's instructions, then make sure it installed the obtained certificates.
#sudo certbot

# you can run this automated command instead of manually entering fields
WEBSITE_DOMAIN_NAME=
API_DOMAIN_NAME=
CERTIFICATE_REGISTRATION_EMAIL=
if [ -n "$WEBSITE_DOMAIN_NAME" && -n $API_DOMAIN_NAME && -n $CERTIFICATE_REGISTRATION_EMAIL ]; then
    certbot -d $API_DOMAIN_NAME -d $WEBSITE_DOMAIN_NAME --email $CERTIFICATE_REGISTRATION_EMAIL --non-interactive --apache --agree-tos
fi

# setup cronjobs
crontab -l > tmp
echo "0 0 1 * * /app/cronjobs/cert_renew.sh" >> tmp
crontab tmp
rm tmp

# return to original user (ec2-user)
exit

# get source code of master server (use your own fork if you have a custom version)
git clone https://github.com/timiimit/UT4MasterServer

# start all containers required to run the master server
docker-compose -f UT4MasterServer/docker-compose.yml up -d

# make sure to take care of /app/db as that directory contains the database
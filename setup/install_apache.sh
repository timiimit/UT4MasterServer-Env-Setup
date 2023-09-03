#!/bin/sh

echo "Installing apache..."
dnf -q -y install httpd mod_ssl

# generate file with list of cloudflare proxy IPs
curl -s https://www.cloudflare.com/ips-v4 > /etc/httpd/proxy_list.txt
echo >> /etc/httpd/proxy_list.txt
curl -s https://www.cloudflare.com/ips-v6 >> /etc/httpd/proxy_list.txt

# now create ut4master.conf in /etc/httpd/conf.d/ and put in the following:
cat >/etc/httpd/conf.d/ut4master.conf << EOF

MaxRequestWorkers 32
RemoteIPHeader CF-Connecting-IP
RemoteIPTrustedProxyList proxy_list.txt
DocumentRoot "/var/www/html"
EOF

systemctl enable httpd
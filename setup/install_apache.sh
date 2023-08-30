#!/bin/sh

echo "Installing apache..."
yum install -y httpd mod_ssl

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
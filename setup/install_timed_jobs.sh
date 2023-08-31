#!/bin/sh

cat >crontab.tmp << EOF
@reboot /app/update_dns.sh
0 0 1 * * /app/cert_renew.sh
EOF

# TODO: do ~monthly system updates. handle docker-compose too!
# TODO: do automatic master server update at the right time when new version is available.
# TODO: remove old logs every so often.

crontab crontab.tmp
rm crontab.tmp
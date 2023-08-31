#!/bin/sh

# load config
source /app/config.cfg

# get IP address of this machine
IP_ADDRESS=$(curl -s https://api/ipify.org)

if [ -z "$IP_ADDRESS" ]; then
	echo "Failed to retrieve IP Address of this machine! DNS records will not be updated."
else
	# get a list of DNS records
	TMP=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?type=A" \
		-H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
		-H "Content-Type: application/json")

	# set DNS records
	DNS_ID_WEBSITE=$(echo $TMP | jq '.result[] | select(.name == "'$DOMAIN_NAME_WEBSITE'") | .id')
	curl -X PUT "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$DNS_ID_WEBSITE" \
		-H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
		-H "Content-Type: application/json" \
		--data '{"type":"A","name":"'"$DOMAIN_NAME_WEBSITE"'","content":"'"$IP_ADDRESS"'","proxied":true,"ttl":1}'


	DNS_ID=$(echo $TMP | jq '.result[] | select(.name == "'$DOMAIN_NAME_API'") | .id')
	curl -X PUT "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$DNS_ID_API" \
		-H "Authorization: Bearer $CLOUDFLARE_API_KEY" \
		-H "Content-Type: application/json" \
		--data '{"type":"A","name":"'"$DOMAIN_NAME_API"'","content":"'"$IP_ADDRESS"'","proxied":true,"ttl":1}'
fi

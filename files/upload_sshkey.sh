#!/bin/bash

DOMAIN=$1
API_BASE=$2
TOKEN=$3
PUBKEY_PATH=$4

PUBKEY=$(cat ${PUBKEY_PATH})
STATUS=$(curl -H "Authorization: token ${TOKEN}" -s -o /dev/null -w "%{http_code}" "${API_BASE}/user/keys" -X POST -d "{\"title\": \"${DOMAIN}\", \"key\": \"${PUBKEY}\"}")

if [ "${STATUS}" == "201" ]; then
	echo "Added SSH key"
	exit 0
elif [ "${STATUS}" == "422" ]; then
	echo "SSH key already added"
	exit 0
elif [ "${STATUS}" == "401" ]; then
	echo "Failed to authenticate"
	exit 1
else
	echo "${API_BASE}/user/keys?access_token=${TOKEN} returned HTTP ${STATUS}"
	exit 1
fi

#!/bin/bash
# Domain parameters
DOMAIN=""
USERNAME=""
SUBDOMAIN=""
DOMPW=""
LASTIPFILE="LASTEXTIP-Strato"
UPDATE_URL="http://dyndns.strato.com/nic/update"
UPDATE_URL_PARAM=""

# get external IP from DNS
GETEXTIP=$(curl -0 --silent http://ipecho.net/plain)

GETDNSIP=`cat $LASTIPFILE`
if [ "$GETDNSIP" != "$GETEXTIP" ]; then
echo $GETEXTIP > $LASTIPFILE
COMMAND="curl --silent --show-error --insecure --user $USERNAME:$DOMPW $UPDATE_$
$COMMAND
fi

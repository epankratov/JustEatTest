#!/bin/sh
#
HOST="public.je-apis.com"
echo "Connecting to the host" ${HOST} "..."
echo "\nwait for response..."
curl -H "Accept-Tenant: uk"\
     -H "Accept-Language: en-GB"\
     -H "Authorization: Basic VGVjaFRlc3Q6bkQ2NGxXVnZreDVw"\
     -H "Host: ${HOST}"\
      http://${HOST}/restaurants?q=se19 > output.json
echo "\nDone."

#!/bin/bash

echo "Running security testing..."

root_uri="http://localhost:3000/app/"

# verify RCE vulnerability

# Some payloads to test the RCE vulnerability

payloads=(";id" "|id" "a);id" "%0Acat%20/etc/passwd" "%0A/usr/bin/id" "%0Aid" "%0A/usr/bin/id%0A" "%0Aid%0A" "&lt;!--#exec%20cmd=&quot;/bin/cat%20/etc/passwd&quot;--&gt;")

# Iterate through the payloads
for payload in "${payloads[@]}"
do
    echo $payload
    # Send the payload to the server
    response=$(/usr/bin/curl -s -o /dev/null  http://localhost:3000/app/something;id)
    echo $response
    if [[ $response == *"uid"* ]]; then
        
        echo "RCE vulnerability exists"
        exit 1
    fi
    echo "No he sido vulnerable"
done

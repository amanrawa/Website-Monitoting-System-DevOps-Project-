#!/bin/bash

URLS=("https://google.com" "https://github.com")
LOG_FILE="log.txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

for URL in "${URLS[@]}"; do
    
    STATUS=$(curl -o /dev/null -s -w "%{http_code}" $URL)
    TIME=$(curl -o /dev/null -s -w "%{time_total}" $URL)

    if [[ $STATUS -eq 200 ]]; then
        echo "$DATE | UP | $URL | STATUS: $STATUS | TIME: $TIME sec" >> $LOG_FILE
    else
        echo "$DATE | DOWN | $URL | STATUS: $STATUS" >> $LOG_FILE

        # Webhook Alert
        curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"🚨 Website DOWN: $URL at $DATE\"}" \
        YOUR_WEBHOOK_URL
    fi
done
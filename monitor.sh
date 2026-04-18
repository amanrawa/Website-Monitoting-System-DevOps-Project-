#!/bin/bash

URLS=("https://google.com" "https://github.com")
LOG_FILE="log.txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

WEBHOOK_URL="https://discord.com/api/webhooks/149474314677740/k-HdKcwdrtt6tc29jfjN7ZTjkjTvX-OlhdK5t" #your discord webhoook url

for URL in "${URLS[@]}"; do

    STATUS=$(curl -L -o /dev/null -s -w "%{http_code}" $URL)
    TIME=$(curl -L -o /dev/null -s -w "%{time_total}" $URL)

    echo "DEBUG: $URL -> STATUS: $STATUS"

    # ✅ WEBSITE UP (2xx + 3xx)
    if [[ $STATUS -ge 200 && $STATUS -lt 400 ]]; then
        echo "$DATE | UP | $URL | STATUS: $STATUS | TIME: $TIME sec" >> $LOG_FILE

        # 🟢 Send UP alert
        curl -X POST -H "Content-Type: application/json" \
        --data "{
          \"embeds\": [{
            \"title\": \"✅ Website Up\",
            \"description\": \"Website is working fine\",
            \"color\": 65280,
            \"fields\": [
              {\"name\": \"URL\", \"value\": \"$URL\", \"inline\": false},
              {\"name\": \"Status Code\", \"value\": \"$STATUS\", \"inline\": true},
              {\"name\": \"Response Time\", \"value\": \"$TIME sec\", \"inline\": true},
              {\"name\": \"Time\", \"value\": \"$DATE\", \"inline\": false}
            ],
            \"footer\": {\"text\": \"Website Monitoring System\"}
          }]
        }" \
        $WEBHOOK_URL

    # 🔴 WEBSITE DOWN
    else
        echo "$DATE | DOWN | $URL | STATUS: $STATUS" >> $LOG_FILE

        # 🔴 Send DOWN alert
        curl -X POST -H "Content-Type: application/json" \
        --data "{
          \"embeds\": [{
            \"title\": \"🚨 Website Down Alert\",
            \"description\": \"Website is not reachable\",
            \"color\": 16711680,
            \"fields\": [
              {\"name\": \"URL\", \"value\": \"$URL\", \"inline\": false},
              {\"name\": \"Status Code\", \"value\": \"$STATUS\", \"inline\": true},
              {\"name\": \"Time\", \"value\": \"$DATE\", \"inline\": true}
            ],
            \"footer\": {\"text\": \"Website Monitoring System\"}
          }]
        }" \
        $WEBHOOK_URL
    fi

done
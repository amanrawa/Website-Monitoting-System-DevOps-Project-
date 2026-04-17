From ubuntu:latest
Run apt update && apt install -y curl cron
WORKDIR /app
COPY monitor.sh /app/
COPY log.txt /app/
Run chmod +x /app/monitor.sh

Run echo "*/2 ******* /app/monitor.sh >> /var/log/corn.log 2>&1 "> /etc/cron.d/monitor-cron
Run chmod 0644 /etc/cron.d/monitor-cron
Run crontab /etc/cron.d/monitor-cron

CMD ["cron","-f"]
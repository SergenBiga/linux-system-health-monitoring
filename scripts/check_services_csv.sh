#!/bin/bash
CSV_FILE="/var/log/service_health.csv"
SERVICES=("ssh" "nginx" "docker")

# Header yoksa ekle
if [ ! -f "$CSV_FILE" ]; then
  echo "timestamp,service,status" > "$CSV_FILE"
fi

ts="$(date '+%Y-%m-%d %H:%M:%S')"

for svc in "${SERVICES[@]}"; do
  UNIT="${svc}.service"
  STATUS="$(systemctl is-active "$UNIT" 2>/dev/null || echo unknown)"
  echo "$ts,$svc,$STATUS" >> "$CSV_FILE"
done


#!/bin/bash
LOG_FILE="/var/log/service_health.log"

# Servis isimleri (seninkiler neyse bunlar)
SERVICES=("ssh" "nginx" "docker")

ts="$(date '+%Y-%m-%d %H:%M:%S')"

for svc in "${SERVICES[@]}"; do
  # systemd unit adı bazen ssh, bazen sshd olabilir:
  if systemctl list-units --type=service --all | grep -q "^${svc}\.service"; then
    UNIT="${svc}.service"
  elif [ "$svc" = "ssh" ] && systemctl list-units --type=service --all | grep -q "^sshd\.service"; then
    UNIT="sshd.service"
  else
    UNIT="${svc}.service"
  fi

  STATUS="$(systemctl is-active "$UNIT" 2>/dev/null)"
  # active / inactive / failed / unknown

  echo "$ts service=$UNIT status=$STATUS" >> "$LOG_FILE"
done


#!/bin/bash
LOG_FILE="/var/log/system_health.log"
SERVICES=("nginx" "docker")   # ssh'yi self-heal önermiyorum
SLEEP_AFTER_RESTART=10

ts="$(date '+%Y-%m-%d %H:%M:%S')"
overall=0

for svc in "${SERVICES[@]}"; do
  unit="${svc}.service"
  state="$(systemctl is-active "$unit" 2>/dev/null || echo unknown)"

  if [ "$state" = "active" ]; then
    echo "[$ts] level=OK component=self-heal service=$svc msg=\"service active\"" >> "$LOG_FILE"
    continue
  fi

  # Service down -> attempt restart once
  echo "[$ts] level=WARNING component=self-heal service=$svc msg=\"service $state, attempting restart\"" >> "$LOG_FILE"
  systemctl restart "$unit" >/dev/null 2>&1
  sleep "$SLEEP_AFTER_RESTART"

  state2="$(systemctl is-active "$unit" 2>/dev/null || echo unknown)"
  if [ "$state2" = "active" ]; then
    echo "[$ts] level=OK component=self-heal service=$svc msg=\"recovered after restart\"" >> "$LOG_FILE"
    [[ $overall -lt 1 ]] && overall=1
  else
    echo "[$ts] level=CRITICAL component=self-heal service=$svc msg=\"restart failed, current_state=$state2\"" >> "$LOG_FILE"
    overall=2
  fi
done

exit $overall


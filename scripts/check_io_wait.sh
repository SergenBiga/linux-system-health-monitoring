#!/bin/bash
CORES=$(nproc)

# ---- LOAD ----
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | tr -d ' ')
LOAD_THRESHOLD=$(echo "scale=2; $CORES * 0.40" | bc)

# ---- IOWAIT (from /proc/stat) ----
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
TOTAL1=$((user + nice + system + idle + iowait + irq + softirq + steal))
IDLE1=$idle
IOWAIT1=$iowait

sleep 1

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
TOTAL2=$((user + nice + system + idle + iowait + irq + softirq + steal))
IDLE2=$idle
IOWAIT2=$iowait

TOTAL_DIFF=$((TOTAL2 - TOTAL1))
IOWAIT_DIFF=$((IOWAIT2 - IOWAIT1))

IOWAIT_PCT=$(echo "scale=2; ($IOWAIT_DIFF / $TOTAL_DIFF) * 100" | bc)

# ---- DECISION ----
if (( $(echo "$IOWAIT_PCT >= 20" | bc -l) )); then
  echo "$(date) CRITICAL: IOwait ${IOWAIT_PCT}% (Load: $LOAD)"
  exit 2
elif (( $(echo "$LOAD >= $LOAD_THRESHOLD" | bc -l) )) || (( $(echo "$IOWAIT_PCT >= 10" | bc -l) )); then
  echo "$(date) WARNING: Load $LOAD / IOwait ${IOWAIT_PCT}%"
  exit 1
else
  echo "$(date) OK: Load $LOAD / IOwait ${IOWAIT_PCT}%"
  exit 0
fi


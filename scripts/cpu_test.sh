#!/bin/bash
CORES=$(nproc)
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | tr -d ' ')
PCT=$(echo "scale=2; ($LOAD / $CORES) * 100" | bc)

THRESHOLD_PCT=40
THRESHOLD_LOAD=$(echo "scale=2; ($CORES * $THRESHOLD_PCT) / 100" | bc)

if (( $(echo "$LOAD >= $THRESHOLD_LOAD" | bc -l) )); then
  echo "$(date) WARNING: CPU ${PCT}% (Load: $LOAD, Cores: $CORES, Threshold: ${THRESHOLD_PCT}%)"
  exit 1
else
  echo "$(date) OK: CPU ${PCT}% (Load: $LOAD, Cores: $CORES)"
  exit 0
fi


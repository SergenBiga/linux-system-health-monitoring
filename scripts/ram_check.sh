#!/bin/bash
TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
AVAILABLE=$(free -m | awk '/^Mem:/ {print $7}')
USED=$((TOTAL - AVAILABLE))

PERCENT=$(echo "scale=2; ($USED / $TOTAL) * 100" | bc)

SWAP_USED=$(free -m | awk '/^Swap:/ {print $3}')

if [ "$SWAP_USED" -gt 0 ]; then
  echo "$(date) CRITICAL: Swap in use (${SWAP_USED}MB), RAM usage ${PERCENT}%"
  exit 2
elif (( $(echo "$PERCENT >= 85" | bc -l) )); then
  echo "$(date) CRITICAL: RAM usage ${PERCENT}%"
  exit 2
elif (( $(echo "$PERCENT >= 70" | bc -l) )); then
  echo "$(date) WARNING: RAM usage ${PERCENT}%"
  exit 1
else
  echo "$(date) OK: RAM usage ${PERCENT}%"
  exit 0
fi


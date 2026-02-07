#!/bin/bash
TARGET="10.255.255.1"
COUNT=5
TIMEOUT=1

PING_OUT=$(ping -c $COUNT -W $TIMEOUT $TARGET 2>/dev/null)
STATUS=$?

if [ $STATUS -ne 0 ]; then
  echo "$(date) CRITICAL: Network unreachable (ping failed to $TARGET)"
  exit 2
fi

# Packet loss %
LOSS=$(echo "$PING_OUT" | grep -oP '\d+(?=% packet loss)')
# Avg RTT (ms)
AVG_RTT=$(echo "$PING_OUT" | awk -F'/' '/rtt/ {print $5}')

# Fallback if parsing fails
LOSS=${LOSS:-100}
AVG_RTT=${AVG_RTT:-999}

if (( $(echo "$LOSS >= 50" | bc -l) )); then
  echo "$(date) CRITICAL: Packet loss ${LOSS}% (avg RTT ${AVG_RTT} ms)"
  exit 2
elif (( $(echo "$LOSS >= 10" | bc -l) )) || (( $(echo "$AVG_RTT >= 80" | bc -l) )); then
  echo "$(date) WARNING: Packet loss ${LOSS}% / avg RTT ${AVG_RTT} ms"
  exit 1
else
  echo "$(date) OK: avg RTT ${AVG_RTT} ms, loss ${LOSS}%"
  exit 0
fi


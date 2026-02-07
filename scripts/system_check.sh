#!/bin/bash
LOG_FILE="/var/log/system_health.log"

CHECKS=(
  "/usr/local/bin/check_cpu.sh"
  "/usr/local/bin/check_disk.sh"
  "/usr/local/bin/check_memory.sh"
  "/usr/local/bin/check_load_iowait.sh"
  "/usr/local/bin/check_network.sh"
)

ts="$(date '+%Y-%m-%d %H:%M:%S')"
overall_status=0

echo "[$ts] system_health START" >> "$LOG_FILE"

for check in "${CHECKS[@]}"; do
  if [ ! -x "$check" ]; then
    echo "[$ts] CRITICAL component=$(basename "$check") msg='script not executable'" >> "$LOG_FILE"
    overall_status=2
    continue
  fi

  output="$("$check" 2>&1)"
  rc=$?

  case $rc in
    0)
      level="OK"
      ;;
    1)
      level="WARNING"
      [[ $overall_status -lt 1 ]] && overall_status=1
      ;;
    2)
      level="CRITICAL"
      overall_status=2
      ;;
    *)
      level="UNKNOWN"
      overall_status=2
      ;;
  esac

  echo "[$ts] level=$level component=$(basename "$check") msg=\"$output\"" >> "$LOG_FILE"
done

echo "[$ts] system_health END status=$overall_status" >> "$LOG_FILE"

exit $overall_status


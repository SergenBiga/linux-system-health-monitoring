#!/bin/bash
THRESHOLD=80 
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//') 
if [ "$USAGE" -gt "$THRESHOLD" ]; then 
	echo "Warning: Disk usage is above $THRESHOLD%" 
else 
	echo "Disk usage is under control" 
fi

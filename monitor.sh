#!/bin/bash

# ===== Thresholds =====
CPU_THRESHOLD=70
MEMORY_THRESHOLD=70
DISK_THRESHOLD=80

# ===== Alert function =====
send_alert() {
  resource=$1
  value=$2
  echo "⚠ ALERT: $resource usage is high at $value%"
}

# ===== Infinite monitoring loop =====
while true; do

  # CPU
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  cpu_usage=${cpu_usage%.*}
  if (( cpu_usage >= CPU_THRESHOLD )); then
    send_alert "CPU" "$cpu_usage"
  fi

  # Memory
  memory_usage=$(free | awk '/Mem/ {printf("%.0f", ($3/$2) * 100)}')
  if (( memory_usage >= MEMORY_THRESHOLD )); then
    send_alert "Memory" "$memory_usage"
  fi

  # Disk
  disk_usage=$(df / | awk 'NR==2 {print $5}')
  disk_usage=${disk_usage%\%}
  if (( disk_usage >= DISK_THRESHOLD )); then
    send_alert "Disk" "$disk_usage"
  fi

  clear
  echo "===== Linux System Monitor ====="
  echo "CPU Usage: $cpu_usage%"
  echo "Memory Usage: $memory_usage%"
  echo "Disk Usage: $disk_usage%"
  echo "-------------------------------"

  sleep 2
done

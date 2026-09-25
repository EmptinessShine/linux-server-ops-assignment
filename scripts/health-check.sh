#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH=/
DISK_THRESHOLD=99
MEMORY_THRESHOLD=90
PROC_ROOT=${PROC_ROOT:-/proc}

usage() {
  echo "Usage: $0 [--path DIR] [--disk-threshold 1-100] [--memory-threshold 1-100]" >&2
}

while (($#)); do
  case "$1" in
    --path|--disk-threshold|--memory-threshold)
      if (($# < 2)); then usage; exit 2; fi
      case "$1" in
        --path) TARGET_PATH=$2 ;;
        --disk-threshold) DISK_THRESHOLD=$2 ;;
        --memory-threshold) MEMORY_THRESHOLD=$2 ;;
      esac
      shift 2 ;;
    --help) usage; exit 0 ;;
    *) usage; exit 2 ;;
  esac
done

for value in "$DISK_THRESHOLD" "$MEMORY_THRESHOLD"; do
  if [[ ! $value =~ ^[0-9]+$ ]] || ((value < 1 || value > 100)); then
    echo "Thresholds must be integers from 1 to 100" >&2
    exit 2
  fi
done
if [[ ! -d $TARGET_PATH || ! -r $PROC_ROOT/meminfo || ! -r $PROC_ROOT/loadavg ]]; then
  echo "Path or Linux proc metrics unavailable" >&2
  exit 2
fi

disk_used=$(df -P "$TARGET_PATH" | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
mem_total=$(awk '$1=="MemTotal:" {print $2}' "$PROC_ROOT/meminfo")
mem_available=$(awk '$1=="MemAvailable:" {print $2}' "$PROC_ROOT/meminfo")
load_one=$(awk '{print $1}' "$PROC_ROOT/loadavg")
if [[ ! $disk_used =~ ^[0-9]+$ || ! $mem_total =~ ^[0-9]+$ || ! $mem_available =~ ^[0-9]+$ ]] || ((mem_total == 0 || mem_available > mem_total || disk_used > 100)); then
  echo "Could not parse system metrics" >&2
  exit 2
fi
memory_used=$(((mem_total - mem_available) * 100 / mem_total))

printf 'Disk used: %s%% (threshold: %s%%)\n' "$disk_used" "$DISK_THRESHOLD"
printf 'Memory used: %s%% (threshold: %s%%)\n' "$memory_used" "$MEMORY_THRESHOLD"
printf 'One-minute load average: %s\n' "$load_one"
if ((disk_used >= DISK_THRESHOLD || memory_used >= MEMORY_THRESHOLD)); then
  echo 'Status: WARN'
  exit 1
fi
echo 'Status: OK'

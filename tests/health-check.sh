#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
cat > "$fixture/meminfo" <<'DATA'
MemTotal:       1000 kB
MemAvailable:    500 kB
DATA
echo '0.25 0.20 0.10 1/100 1' > "$fixture/loadavg"

output=$(PROC_ROOT="$fixture" bash "$repo/scripts/health-check.sh" --path "$repo" --disk-threshold 100 --memory-threshold 90)
[[ $output == *'Memory used: 50%'* && $output == *'Status: OK'* ]]

set +e
output=$(PROC_ROOT="$fixture" bash "$repo/scripts/health-check.sh" --path "$repo" --disk-threshold 100 --memory-threshold 50)
status=$?
set -e
[[ $status -eq 1 && $output == *'Status: WARN'* ]]

set +e
PROC_ROOT="$fixture" bash "$repo/scripts/health-check.sh" --disk-threshold 101 > /dev/null 2>&1
status=$?
set -e
[[ $status -eq 2 ]]

sed -i.bak 's/MemAvailable:    500/MemAvailable:   1500/' "$fixture/meminfo"
set +e
PROC_ROOT="$fixture" bash "$repo/scripts/health-check.sh" --path "$repo" > /dev/null 2>&1
status=$?
set -e
[[ $status -eq 2 ]]
cat > "$fixture/meminfo" <<'DATA'
MemTotal:       1000 kB
MemAvailable:    500 kB
DATA
output=$(PROC_ROOT="$fixture" bash "$repo/scripts/health-check.sh" --path "$repo")
disk_line=${output%%$'\n'*}
[[ $disk_line == *'threshold: 90%'* ]]
echo 'health-check tests passed'

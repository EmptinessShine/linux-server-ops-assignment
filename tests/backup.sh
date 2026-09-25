#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/source" "$fixture/archives"
echo example > "$fixture/source/config.txt"
output=$(bash "$repo/scripts/backup.sh" --source "$fixture/source" --destination "$fixture/archives")
archive=${output#Created: }
[[ -f $archive ]]
tar -tzf "$archive" | grep -qx 'source/config.txt'
[[ $(tar -xOzf "$archive" source/config.txt) == example ]]
set +e
bash "$repo/scripts/backup.sh" --source "$fixture/source" --destination "$fixture/source/nested" > /dev/null 2>&1
status=$?
set -e
[[ $status -eq 2 ]]
echo 'backup tests passed'

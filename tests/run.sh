#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
bash "$repo/tests/health-check.sh"
bash "$repo/tests/backup.sh"

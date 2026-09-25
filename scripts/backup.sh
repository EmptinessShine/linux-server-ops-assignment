#!/usr/bin/env bash
set -euo pipefail

usage() { echo "Usage: $0 --source DIR --destination DIR" >&2; }
source_dir=
destination_dir=
while (($#)); do
  case "$1" in
    --source|--destination)
      if (($# < 2)); then usage; exit 2; fi
      case "$1" in
        --source) source_dir=$2 ;;
        --destination) destination_dir=$2 ;;
      esac
      shift 2 ;;
    --help) usage; exit 0 ;;
    *) usage; exit 2 ;;
  esac
done
if [[ -z $source_dir || -z $destination_dir || ! -d $source_dir || ! -r $source_dir ]]; then
  usage
  exit 2
fi
mkdir -p -- "$destination_dir"
source_abs=$(cd "$source_dir" && pwd -P)
destination_abs=$(cd "$destination_dir" && pwd -P)
if [[ $destination_abs == "$source_abs" || $destination_abs == "$source_abs"/* ]]; then
  echo 'Destination must be outside source' >&2
  exit 2
fi
source_name=$(basename "$source_abs")
source_parent=$(dirname "$source_abs")
stamp=$(date -u +%Y%m%dT%H%M%SZ)
archive="$destination_abs/${source_name}-${stamp}-$$.tar.gz"
tar -czf "$archive" -C "$source_parent" "$source_name"
printf 'Created: %s\n' "$archive"

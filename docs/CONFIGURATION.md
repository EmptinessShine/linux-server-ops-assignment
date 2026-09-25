# Configuration

The scripts use command line options rather than hidden environment configuration. This makes each run easier to audit.

## Health check

`bash scripts/health-check.sh --path / --disk-threshold 90 --memory-threshold 90`

Both thresholds are percentages from 1 to 100. The check returns exit code 0 for OK, 1 for WARN, and 2 for invalid input or unavailable metrics. `PROC_ROOT` is an internal test hook for fixture data; leave it unset in normal use.

## Backup

The backup command requires `--source` and `--destination`. The destination must be outside the source. The archive name includes a UTC timestamp and process ID to avoid overwriting an earlier backup.

## Exit codes

| Code | Meaning |
| --- | --- |
| 0 | Health is OK or backup completed. |
| 1 | Health threshold reached. |
| 2 | Invalid input or unavailable metrics. |

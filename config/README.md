# Example settings

The scripts accept options on the command line. No secrets or server-specific values are stored in this directory.

Example health check: `bash scripts/health-check.sh --disk-threshold 90 --memory-threshold 90`.

Example backup: `bash scripts/backup.sh --source /etc --destination "$HOME/server-backups"`.

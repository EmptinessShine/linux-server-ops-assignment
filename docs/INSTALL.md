# Installation

## Requirements

- Linux with Bash 4 or newer, `awk`, `df`, `tar`, and `/proc` mounted.
- A user account with read access to the monitored path and backup source.
- Write access to the backup destination.

## Steps

1. Clone the repository: `git clone https://github.com/EmptinessShine/linux-server-ops-assignment.git`.
2. Enter the directory: `cd linux-server-ops-assignment`.
3. Run the tests: `bash tests/run.sh`.
4. Check the server: `bash scripts/health-check.sh --path /`.
5. Create a backup only after choosing paths: `bash scripts/backup.sh --source /etc --destination "$HOME/server-backups"`.

No root installation or service setup is required. Do not store backup archives in Git.

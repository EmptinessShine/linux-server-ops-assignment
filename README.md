# Linux Server Ops

A small, reviewable Linux server administration toolkit for junior DevOps practice.

## Purpose

The project provides read-only health checks and a deliberate backup command for a directory chosen by the operator. It includes tests, example configuration, installation notes, and troubleshooting guidance.

## Project structure

- `scripts/health-check.sh`: checks disk, memory, and system load.
- `scripts/backup.sh`: creates a timestamped archive of an explicitly selected directory.
- `config/`: example settings.
- `tests/`: executable shell tests.
- `docs/`: installation, configuration, workflow, and troubleshooting guides.

## Quick start

See [installation](docs/INSTALL.md) before running scripts on a Linux host.

## Development workflow

Changes start in `feature/*` branches. Each pull request explains what changed, why, and how it was tested. Review and successful tests are required before merging into `main`.

## Branching strategy

`main` is the stable branch. Feature and documentation branches are short lived and are deleted after merge. Fixes are isolated in `fix/*` branches.

## Contributions

Open an issue or describe the change in a pull request. Keep commits focused, update the relevant documentation, run `bash tests/run.sh`, and address review comments before approval.

## Testing

On a Linux machine, run `bash tests/run.sh` before opening a pull request. The tests use temporary directories and do not require root.

## Troubleshooting

See [troubleshooting](docs/TROUBLESHOOTING.md). For an unexpected result, capture command output, inspect `git log` and `git blame`, then use a new fix branch and a reviewed revert or correction.

## Safety

The health check only reads local system metrics. The backup command reads the chosen source and writes an archive into the chosen destination. Review both paths before running it. Neither command requires `sudo`.

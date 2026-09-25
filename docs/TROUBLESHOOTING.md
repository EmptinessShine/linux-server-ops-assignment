# Troubleshooting

## Health check says metrics are unavailable

Verify the host is Linux, `/proc/meminfo` and `/proc/loadavg` exist, and the selected `--path` exists. The script returns code 2 for invalid input or unavailable metrics.

## Health check returns WARN

Check the reported disk and memory percentages. Compare them with the configured thresholds. WARN returns code 1; it does not modify the server.

## Backup fails

Check source read permission, destination write permission, free disk space, and that the destination is outside the source tree. Run `tar -tzf ARCHIVE` to inspect a created archive, then test restoration into a temporary directory.

## Investigating a regression

Run `git log --oneline`, `git show COMMIT`, and `git blame FILE`. Reproduce the issue with `bash tests/run.sh`. Restore the intended behavior on a fix branch; use `git revert COMMIT` when the incorrect change is already shared so history remains intact.

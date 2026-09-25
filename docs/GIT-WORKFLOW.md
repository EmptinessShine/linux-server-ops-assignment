# Git workflow used in this assignment

1. Keep `main` stable and create a short-lived branch for each change.
2. Make small commits with messages that describe the actual change.
3. Push the branch and open a pull request with what changed, why, and test results.
4. Read comments, update the branch, run tests, then merge.
5. Inspect problems with `git log`, `git show`, and `git blame`. Revert a shared bad commit instead of rewriting public history.

## Conflict example

Two documentation branches started from the same version of `main`. Both changed the same testing sentence in `README.md`: one added the expected output, and the other said to run tests before a PR. When the first branch was merged, merging `main` into the second branch caused a content conflict. We inspected the markers and kept both useful instructions in one sentence. The merge commit records the resolution.

## Recovery example

The project also demonstrates a deliberately wrong default threshold. After a later documentation change, `git log` and `git blame` identify the commit. `git revert` restores the correct value while preserving all commits.

#!/usr/bin/env bash

# export AWS_ACCESS_KEY_ID=...
# export AWS_SECRET_ACCESS_KEY=...
# export RESTIC_REPOSITORY=...
# export RESTIC_PASSWORD=...
#
# restic init

restic backup \
  --exclude-caches \
  --exclude-file backup-excludes.txt \
  "$@"


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
  ~

restic forget \
  --keep-within-daily 7d \
  --keep-within-weekly 1m \
  --keep-within-monthly 1y \
  --keep-within-yearly 75y

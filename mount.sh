#!/usr/bin/env bash
# Check my backup with  restic to Backblaze B2 for errors.
# This script is typically run by: /etc/systemd/system/restic-check.{service,timer}

# Exit on failure, pipe failure
set -e -o pipefail

source env.sh

restic cache --cleanup

restic -r $RESTIC_REPOSITORY \
  --option b2.connections=$B2_CONNECTIONS \
  --verbose \
  mount $RESTIC_MOUNT

restic cache --cleanup

#sleep 1
#umount $RESTIC_MOUNT >& /dev/null

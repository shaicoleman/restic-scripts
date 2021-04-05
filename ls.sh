#!/usr/bin/env bash
# Make backup my system with restic to Backblaze B2.
# This script is typically run by: /etc/systemd/system/restic-backup.{service,timer}

# Exit on failure, pipe failure
set -e -o pipefail

# Set all environment variables like
# B2_ACCOUNT_ID, B2_ACCOUNT_KEY, RESTIC_REPOSITORY etc.
source env.sh

restic ls latest -l

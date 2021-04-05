#!/usr/bin/env bash
# Make backup my system with restic to Backblaze B2.
# This script is typically run by: /etc/systemd/system/restic-backup.{service,timer}

# Exit on failure, pipe failure
set -e -o pipefail

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Clean up lock if we are killed.
# If killed by systemd, like $(systemctl stop restic), then it kills the whole cgroup and all it's subprocesses.
# However if we kill this script ourselves, we need this trap that kills all subprocesses manually.
exit_hook() {
	echo "In exit_hook(), being killed" >&2
	jobs -p | xargs kill
	restic unlock
}
trap exit_hook INT TERM

# Set all environment variables like
# B2_ACCOUNT_ID, B2_ACCOUNT_KEY, RESTIC_REPOSITORY etc.
source env.sh


# NOTE start all commands in background and wait for them to finish.
# Reason: bash ignores any signals while child process is executing and thus my trap exit hook is not triggered.
# However if put in subprocesses, wait(1) waits until the process finishes OR signal is received.
# Reference: https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash

# Remove locks from other stale processes to keep the automated backup running.
restic unlock &
wait $!

echo " => restic forget"
# Dereference and delete/prune old backups.
# See restic-forget(1) or http://restic.readthedocs.io/en/latest/060_forget.html
# --group-by only the tag and path, and not by hostname. This is because I create a B2 Bucket per host, and if this hostname accidentially change some time, there would now be multiple backup sets.
# --group-by "paths,tags" \
# --tag $BACKUP_TAG \

restic forget \
  --verbose \
  --keep-tag $KEEP_TAG \
  --keep-hourly $KEEP_HOURS \
  --keep-daily $KEEP_DAYS \
  --keep-weekly $KEEP_WEEKS \
  --keep-monthly $KEEP_MONTHS \
  --keep-yearly $KEEP_YEARS &
wait $!

echo " => restic prune"
restic prune \
  --option b2.connections=$B2_CONNECTIONS \
  --verbose &
wait $!

echo " => restic check"
restic check \
  --option b2.connections=$B2_CONNECTIONS \
  --verbose &
wait $!

echo " => restic self-update"
restic self-update

date --utc '+%Y-%m-%dT%H:%M:%S.%3NZ' > "${RESTIC_DATA_DIR}/prune-time"
  
echo "Pruning is done."

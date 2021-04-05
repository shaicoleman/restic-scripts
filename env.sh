export RESTIC_REPOSITORY="b2:${HOSTNAME}-backup:/"
# export RESTIC_REPOSITORY=/tmp/restic
export B2_CONNECTIONS=100
export READ_CONCURRENCY=8
export RESTIC_DATA_DIR="/var/lib/restic"
export RESTIC_MOUNT=/mnt/restic
export RESTIC_RESTORE_PATH=/tmp/restore
export KEEP_HOURS=168 # hourly for 1 week
export KEEP_DAYS=30   # daily for 30 days
export KEEP_WEEKS=13  # weekly for 90 days
export KEEP_MONTHS=12 # monthly for 1 year
export KEEP_YEARS=3   # yearly for 3 years
export KEEP_TAG=keep
export EXCLUDE_LARGER_THAN=10G
export RESTIC_SECRETS_FILE="${RESTIC_DATA_DIR}/secrets.sh"
source "${RESTIC_SECRETS_FILE}"

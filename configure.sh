#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

source env.sh
mkdir -p "$RESTIC_DATA_DIR"
chmod 700 "$RESTIC_DATA_DIR"
touch "${RESTIC_SECRETS_FILE}"
chmod 600 "${RESTIC_SECRETS_FILE}"
micro "${RESTIC_SECRETS_FILE}"

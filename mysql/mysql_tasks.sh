#!/bin/bash
set -euo pipefail

###
## GLOBAL VARIABLES
###
ECHO=${ECHO:-'/bin/echo'}
MYSQLCHECK=${MYSQLCHECK:-'/usr/bin/mysqlcheck'}
SERVICE=${SERVICE:-'/sbin/service'}
TEE=${TEE:-'/usr/bin/tee'}
LOG_FILE="/var/log/mysqlcheck_$(date +'%Y%m%d_%H%M%S').log"

# Check if MySQL is running
if ! $SERVICE mysqld status > /dev/null; then
    ${ECHO} "MySQL is not running. Exiting."
    exit 1
fi

${ECHO} "Starting mysqlcheck..." | ${TEE} -a "${LOG_FILE}"

# Run mysqlcheck with combined options and log output
${MYSQLCHECK}--all-databases --optimize --auto-repair --analyze | ${TEE} -a "${LOG_FILE}"

${ECHO} "mysqlcheck completed." | ${TEE} -a "${LOG_FILE}"

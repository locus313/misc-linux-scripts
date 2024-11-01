#!/bin/bash
set -euo pipefail

###
## GLOBAL VARIABLES
###
DAYS=${DAYS:-'365'}
SERVICE=${SERVICE:-'/sbin/service'}
GREP=${GREP:-'/bin/grep'}
TEE=${TEE:-'/usr/bin/tee'}
ECHO=${ECHO:-'/bin/echo'}
DATE="$(/bin/date -u)"
LOG_FILE="/var/log/service_monitor.log"

# Check if mysqld service is running
UP=$($SERVICE mysqld status | $GREP -c 'running')

if [ "$UP" -eq 0 ]; then
    ${ECHO} "${DATE} - mysqld not running. Restarting httpd and mysqld services." | ${TEE} -a "${LOG_FILE}"
    
    ${SERVICE} httpd restart
    ${SERVICE} mysqld restart
    
    # Recheck if services are running
    HTTPD_UP=$(${SERVICE} httpd status | $GREP -c 'running')
    MYSQLD_UP=$(${SERVICE} mysqld status | $GREP -c 'running')

    if [ "${HTTPD_UP}" -eq 1 ] && [ "${MYSQLD_UP}" -eq 1 ]; then
        ${ECHO} "${DATE} - Services restarted successfully." | ${TEE} -a "${LOG_FILE}"
    else
        ${ECHO} "${DATE} - Failed to restart services!" | ${TEE} -a "${LOG_FILE}"
    fi
fi
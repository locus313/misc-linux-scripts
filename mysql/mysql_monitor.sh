#!/bin/bash
set -euo pipefail

###
## GLOBAL VARIABLES
###
DAYS=${DAYS:-'365'}
SERVICE=${SERVICE:-'/sbin/service'}
GREP=${GREP:-'/bin/grep'}
WC=${WC:-'/usr/bin/wc'}
ECHO=${ECHO:-'/bin/echo'}
DATE="$(/bin/date -u)"
UP=$($SERVICE mysqld status | $GREP 'running' | $WC -l);

if [ "$UP" -eq 0 ];
then
        ${ECHO} "${DATE}" "mysqld not running, restarting httpd and mysqld services."
        ${SERVICE} httpd restart
        ${SERVICE} mysqld restart
fi
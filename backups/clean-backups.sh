#!/bin/bash
set -euo pipefail

###
## GLOBAL VARIABLES
###
DAYS=${DAYS:-'365'}
PATHS=${PATHS:-''}
FIND=${FIND:-'/bin/find'}
RM=${RM:-'/bin/rm'}
RMDIR=${RMDIR:-'/bin/rmdir'}

clean_backups () {
  for PATH in ${PATHS}; do
    ${FIND} "${PATH}" -type f -mtime +"${DAYS}" -exec "${RM}" -Rf {} \; -o -mtime +"${DAYS}" -type d -empty -exec "${RMDIR}" {} \;
  done
}

clean_backups

#!/bin/bash
set -euo pipefail

###
## GLOBAL VARIABLES
###
DAYS=${DAYS:-'365'}
DRY_RUN=${DRY_RUN:-false}
PATHS=${PATHS:-''}
FIND=${FIND:-'/bin/find'}
ECHO=${ECHO:-'/bin/echo'}
RM=${RM:-'/bin/rm'}
RMDIR=${RMDIR:-'/bin/rmdir'}

usage() {
  ${ECHO} "Usage: $0 [options]"
  ${ECHO} "Options:"
  ${ECHO} "  DAYS       Number of days (default: 365)"
  ${ECHO} "  PATHS      Paths to search (default: '')"
  ${ECHO} "  DRY_RUN    Set to 'true' to simulate actions without deleting (default: false)"
  exit 1
}

clean_backups () {
  for PATH in ${PATHS}; do
    if [ -z "${PATH}" ]; then
      ${ECHO} "Skipping empty path"
      continue
    fi
    
    ${ECHO} "Cleaning backups in path: ${PATH} older than ${DAYS} days"
    
    if [[ "${DRY_RUN}" == "true" ]]; then
      ${FIND} "${PATH}" -type f -mtime +"${DAYS}" -exec "${ECHO}" "${RM}" -Rf {} \; -o -mtime +"${DAYS}" -type d -empty -exec "${ECHO}" "${RMDIR}" {} \;
    else
      ${FIND} "${PATH}" -type f -mtime +"${DAYS}" -exec "${RM}" -Rf {} \; -o -mtime +"${DAYS}" -type d -empty -exec "${RMDIR}" {} \;
    fi
  done
}

# Check if at least one path is provided
if [ -z "${PATHS}" ]; then
  ${ECHO} "Error: No PATHS specified."
  usage
fi

clean_backups

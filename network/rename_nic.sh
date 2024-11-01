#!/bin/bash
set -euo pipefail

###
## GLOBAL VARIABLES
###
OLD=${OLD:-$1}
NEW=${NEW:-$2}

CAT=${CAT:-'/bin/cat'}
ECHO=${ECHO:-'/bin/echo'}
IP=${IP:-'/sbin/ip'}
MV=${MV:-'/bin/mv'}
SED=${SED:-'/bin/sed'}

${IP} link set "${OLD}" down
${IP} link set "${OLD}" name "${NEW}"
${IP} link set "${NEW}" up

${MV} /etc/sysconfig/network-scripts/ifcfg-{"${OLD}","${NEW}"}

${SED} -ire "s/NAME=""${OLD}""/NAME=""${NEW}""/" /etc/sysconfig/network-scripts/ifcfg-"${NEW}"
${SED} -ire "s/DEVICE=""${OLD}""/DEVICE=""${NEW}""/" /etc/sysconfig/network-scripts/ifcfg-"${NEW}"

MAC=$(${CAT} /sys/class/net/"${NEW}"/address)
${ECHO} -n HWADDR="${MAC}" >> /etc/sysconfig/network-scripts/ifcfg-"${NEW}"

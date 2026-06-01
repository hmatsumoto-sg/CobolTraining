#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
PROGRAMNAME="PICTURES.COB"
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")
BINNAME=$(basename -s .COB $PROGRAMNAME)

cobc -x -o "${BINDIR}/${BINNAME}" -I"${COPYLIBDIR}" "${PROGRAMNAME}"
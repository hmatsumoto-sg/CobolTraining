#!/bin/bash
set -Eeuo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)

PROGRAMNAME=$(basename "${SCRIPTDIR}")
BINDIR="${SCRIPTDIR}"
PROGRAM="${BINDIR}/${PROGRAMNAME}"

export ITF="<INPUT DATA PATH>"
export MTF="<MASTER DATA PATH>"
export OTF="<OUTPUT DATA PATH>"

${PROGRAM} | iconv -f cp932

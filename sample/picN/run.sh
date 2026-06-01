#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
PROGRAMNAME="PICN.COB"
BINNAME=$(basename -s .COB $PROGRAMNAME)

export OTF=result.txt

${SCRIPTDIR}/${BINNAME}

cat <<__EOF__  > report.txt
==============
プログラム
==============
$(cat ${PROGRAMNAME})

==============
ファイルの出力結果
==============

cat $OTF
----------------------------------------------
$(cat $OTF)
----------------------------------------------

hexdump -C $OTF
----------------------------------------------
$(hexdump -C $OTF)
----------------------------------------------
__EOF__

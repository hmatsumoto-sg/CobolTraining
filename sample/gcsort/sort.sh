#!/usr/bin/env bash
set -Eeuo pipefail

#######################################################
##   GCSORT ツールを利用したデータのソート
##   ※現場によって提供されるツールが異なるので、それぞれのドキュメントや
##     サンプル、利用しているファイルを参照して、使い方を習得すること
#######################################################

SOURCE=$(realpath ../../data/KJBM030i.txt)
DEST=$(realpath ./rersult.txt)

CTRLFILE=$(mktemp)

# trap "rm -f $CTRLFILE" EXIT

cat <<_EOF_ >>$CTRLFILE
SORT FIELDS=(2, 4, ZD, A) 
    USE  $SOURCE RECORD F,100 ORG SQ
    GIVE $DEST   RECORD F,100 ORG SQ
_EOF_
# ↑ ソート条件
# SORT FIELDS=(ソート対象開始位置, 桁数, データタイプ, 昇降順[, ソート対象開始位置, 桁数, データタイプ, 昇降順[, ...]])
#     USE  ソート対象のファイルパス RECORD 固定長,1レコードの桁数 ORG SQ(順ファイル)
#     GIVE ソート結果のファイルパス RECORD 固定長,1レコードの桁数 ORG SQ(順ファイル)

gcsort TAKE $CTRLFILE
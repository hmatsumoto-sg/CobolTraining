#!/bin/bash
# エラーが発生したら即時中断
set -Eeuo pipefail

# プロジェクトのディレクトリを取得（今回はKJJD010の1つ上）
PROJ_ROOT=$(cd "$(dirname "$0")/.."; pwd)

export COB_LIBRARY_PATH="${PROJ_ROOT}/programs/KCBS010:${PROJ_ROOT}/programs"
echo "--- Step 1: KJBM010 起動 ---"
# 環境変数の設定
export ITF="${PROJ_ROOT}/programs/data/KJJD010I.txt"
export OTF="${PROJ_ROOT}/programs/data/KJBM010O.dat"
# 実行
"${PROJ_ROOT}/programs/KJBM010/KJBM010" | iconv -f cp932
echo "--- Step 1: 正常終了 ($(date)) ---"

echo "--- Step 2: KJBM020 起動 ---"
# 環境変数の設定
export ITF="${PROJ_ROOT}/programs/data/KJBM010O.dat"
export OTF="${PROJ_ROOT}/programs/data/KJBM020O.dat"
# 実行
"${PROJ_ROOT}/programs/KJBM020/KJBM020" | iconv -f cp932
echo "--- Step 2: 正常終了 ($(date)) ---"

# GCSORTを使ったソート
echo "--- Step 3: ソート (商品番号順)  起動 ---"
# 一時ファイル作成
CTRLFILE1=$(mktemp)
CTRLFILE2=$(mktemp)
#スクリプトが終わったら削除する
trap 'rm -f "$CTRLFILE1" "$CTRLFILE2"' EXIT
# 一時ファイルにソート条件を入れる
cat <<_EOF_ > "${CTRLFILE1}"
SORT FIELDS=(14,5,ZD,A)
    USE  "${PROJ_ROOT}/programs/data/KJBM020O.dat" RECORD F,100 ORG SQ
    GIVE "${PROJ_ROOT}/programs/data/SORT1O.dat" RECORD F,100 ORG SQ
_EOF_
# GCSORTの実行
gcsort TAKE "${CTRLFILE1}"
echo "--- Step 3: 正常終了 ($(date)) ---"

echo "--- Step 4: KJBM030 起動 ---"
# 環境変数の設定
export ITF="${PROJ_ROOT}/programs/data/SORT1O.dat"
export IMF="${PROJ_ROOT}/programs/data/KCCFSHO.dat"
export OTF="${PROJ_ROOT}/programs/data/KJBM030O.dat"
# 実行
"${PROJ_ROOT}/programs/KJBM030/KJBM030" | iconv -f cp932
echo "--- Step 4: 正常終了 ($(date)) ---"

echo "--- Step 5: KJBM050 起動 ---"
# 環境変数の設定
export ITF="${PROJ_ROOT}/programs/data/KJBM030O.dat"
export OTF1="${PROJ_ROOT}/programs/data/KJBM050O1.dat"
export OTF2="${PROJ_ROOT}/programs/data/KJBM050O2.dat"
# 実行
"${PROJ_ROOT}/programs/KJBM050/KJBM050" | iconv -f cp932
echo "--- Step 5: 正常終了 ($(date)) ---"

echo "--- Step 6: KUBM010 起動 ---"
# 環境変数の設定
export ITF="${PROJ_ROOT}/programs/data/KJBM050O1.dat"
export OTF="${PROJ_ROOT}/programs/data/KUBM010O.dat"
# 実行
"${PROJ_ROOT}/programs/KUBM010/KUBM010" | iconv -f cp932
echo "--- Step 6: 正常終了 ($(date)) ---"

# GCSORTを使ったソート
echo "--- Step 7: ソート (商品番号・受注年月昇順)  起動 ---"
# 一時ファイルにソート条件を入れる
cat <<_EOF_ > "${CTRLFILE2}"
SORT FIELDS=(14,5,ZD,A,2,6,ZD,A)
    USE  "${PROJ_ROOT}/programs/data/KUBM010O.dat" RECORD F,100 ORG SQ
    GIVE "${PROJ_ROOT}/programs/data/SORT2O.dat" RECORD F,100 ORG SQ
_EOF_
# GCSORTの実行
gcsort TAKE "${CTRLFILE2}"
echo "--- Step 7: 正常終了 ($(date)) ---"

echo "--- Step 8: KUBM020 起動 ---"
# 環境変数の設定
export ITF="${PROJ_ROOT}/programs/data/SORT2O.dat"
export OTF="${PROJ_ROOT}/programs/data/KUBM020O.dat"
# 実行
"${PROJ_ROOT}/programs/KUBM020/KUBM020" | iconv -f cp932
echo "--- Step 8: 正常終了 ($(date)) ---"

echo "--- JobFlow: 正常終了 ($(date)) ---"
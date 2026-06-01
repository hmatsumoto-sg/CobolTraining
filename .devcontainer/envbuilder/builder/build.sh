#!/bin/sh
##########################################################################
# UNIX-COBOL 実習環境構築スクリプト for devcontainer
# Copyright (C) 2022-2023 SystemGiken Co.Ltd,
#
# GnuCOBOL、各種プリプロセッサ、ソートツールをインストールします。
#
# 動作環境:
#   Ubuntu 22.04
#   Ubuntu 24.04
##########################################################################
set -eu

SCRIPT_DIR=$(cd $(dirname $0); pwd)
BUILD_DIR=$(mktemp -d)
BUILD_LOG_FILE=${SCRIPT_DIR}/build.log
#
GNUCOBOL_VER="3.2 OSSCONS Patch.2"
GNUCOBOL_SRC_PKG="gnucobol.tar.gz"
GCSORT_SRC_PKG="gcsort.tar.gz"
ESQLOC_SRC_PKG="esql.tar.gz"
#
GNUCOBOL_SRC_URL="https://github.com/opensourcecobol/gnucobol-osscons-patch/archive/refs/heads/develop.tar.gz"
#

cd "${SCRIPT_DIR}"
echo "Start Building : $(date)" >${BUILD_LOG_FILE}

echo "Generate ja_JP.SJIS locale ... "
{
    echo "ja_JP.SJIS SHIFT_JIS" >> /etc/locale.gen
    locale-gen
}

# 必要なパッケージをインストールする
echo "Installing required packages ..."
{
    apt-get -y update && \
    apt-get -y install curl gcc g++ bison flex make autoconf \
                       libgmp-dev libdb-dev libpq-dev libxml2-dev \
                       libjson-c-dev unixodbc-dev odbc-postgresql \
                       texinfo
} >>"${BUILD_LOG_FILE}" 2>&1

cd "${BUILD_DIR}"

## GnuCobol 関連のパッケージをビルドしてインストールする。
if [ ! -f "${SCRIPT_DIR}/${GNUCOBOL_SRC_PKG}" ]; then
    echo "Downloading GnuCOBOL Source package ..."
    curl -sSL -o "${BUILD_DIR}/${GNUCOBOL_SRC_PKG}" "${GNUCOBOL_SRC_URL}"
else
    echo "Use local GnuCOBOL source package."
    cp -f "${SCRIPT_DIR}/${GNUCOBOL_SRC_PKG}" "${BUILD_DIR}/${GNUCOBOL_SRC_PKG}"
fi
echo "Building and installing GnuCOBOL ..."
mkdir gnucobol
tar xf "${BUILD_DIR}/${GNUCOBOL_SRC_PKG}" --strip-components 1 -C gnucobol
(
    cd gnucobol
    sh ./autogen.sh
    ./configure
    make -j
    make install
    ldconfig

) >>"${BUILD_LOG_FILE}" 2>&1
echo "Done."

if [ ! -f "${SCRIPT_DIR}/${GCSORT_SRC_PKG}" ]; then
    echo "*** Please check to exist 'gcsort.tar.gz'."
    echo "*** Note: gnucobol contribution tools are hosting on berrow URL."
    echo "***       https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/"
    exit 1
fi

cp -f "${SCRIPT_DIR}/${GCSORT_SRC_PKG}" "${BUILD_DIR}/${GCSORT_SRC_PKG}"
mkdir gcsort 
tar xzf "${BUILD_DIR}/${GCSORT_SRC_PKG}" --strip-components 1 -C gcsort
echo "Building and installing GCSORT ..."
(
    cd gcsort
    make -j
    install -m 755 -t /usr/local/bin gcsort
) >>"${BUILD_LOG_FILE}" 2>&1
echo "Done."

echo "Building and installing esqlOC pre-processor ..."
cp -f "${SCRIPT_DIR}/${ESQLOC_SRC_PKG}" "${BUILD_DIR}/${ESQLOC_SRC_PKG}"
mkdir esql 
tar xzf "${BUILD_DIR}/${ESQLOC_SRC_PKG}" --strip-components 1 -C esql
(
    cd esql
    sh ./autogen.sh
    ./configure
    make -j
    make install
    ldconfig

) >>"${BUILD_LOG_FILE}" 2>&1
echo "Done."


echo "Cleaning up ..."
rm -rf "${BUILD_DIR}"

echo "End Building : $(date)" >> ${BUILD_LOG_FILE}

echo "Successsful built environment."
